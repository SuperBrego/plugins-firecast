require("firecast.lua");
local __o_rrpgObjs = require("rrpgObjs.lua");
require("rrpgGUI.lua");
require("rrpgDialogs.lua");
require("rrpgLFM.lua");
require("ndb.lua");
require("locale.lua");
local __o_Utils = require("utils.lua");

local function constructNew_frmVNScene()
    local obj = GUI.fromHandle(_obj_newObject("form"));
    local self = obj;
    local sheet = nil;

    rawset(obj, "_oldSetNodeObjectFunction", obj.setNodeObject);

    function obj:setNodeObject(nodeObject)
        sheet = nodeObject;
        self.sheet = nodeObject;
        self:_oldSetNodeObjectFunction(nodeObject);
    end;

    function obj:setNodeDatabase(nodeObject)
        self:setNodeObject(nodeObject);
    end;

    _gui_assignInitialParentForForm(obj.handle);
    obj:beginUpdate();
    obj:setName("frmVNScene");
    obj:setFormType("sheetTemplate");
    obj:setDataType("br.GodsCorpse.VNScene");
    obj:setTitle("Visual Novel Scene");


    



        require("firecast.lua");
        require("dialogs.lua");
        require("system.lua");

        local MAX_EXTRAS   = 6
        local SCENE_FORMAT = "VNSCENE1"
        local SLOT_IDS     = { "left", "center", "right" }
        local SLOT_CONFIG_HEIGHT = 152   -- cabeçalho + 3 camadas
        local CONFIG_BASE_HEIGHT = 1000  -- resto da aba de configuração
        local DEFAULT_NPC_COLOR = "#a89fd8"
        local FOCUS_OPACITY = { 1.0, 0.45, 0.25 }
        local DIM_OPACITY   = { 0.18, 0.12, 0.08 }
        local MARKUP_TAGS   = { "b", "i", "u", "s", "color", "size", "font", "url", "img",
                                "center", "quote", "code", "spoiler" }

        local chatReceiver = nil
        local npcMap       = {}  -- nome(lower) -> {slot, layer} ou {extra=i}
        local extraUrls    = {}  -- URL de cada extra
        local slotUrls     = {
            left   = { "", "", "" },
            center = { "", "", "" },
            right  = { "", "", "" },
        }
        -- Cor do nome por NPC (nome lower -> cor hex)
        local npcColors = {}
        local dialogExpanded = false
        local fadeTargets = {}       -- nome do controle -> opacidade alvo
        local previewCheckRuns = 0
        local bulkUpdating = false   -- true enquanto vários campos são gravados de uma vez
        local keysCache = nil
        local configDocked = false   -- true: painel de configuração está dentro da aba Cena (modo debug)

        -- ── Utilitários ──────────────────────────────────────────────

        local function slotControls(slotId)
            return {
                self["imgSprite_" .. slotId .. "_1"],
                self["imgSprite_" .. slotId .. "_2"],
                self["imgSprite_" .. slotId .. "_3"],
            }
        end

        local function extraControls(idx)
            return {
                img  = self["imgExtra_" .. idx],
                rect = self["rectExtra_" .. idx],
            }
        end

        local function normalizeNpcName(name)
            return ((name or ""):gsub("^%s*(.-)%s*$", "%1")):lower()
        end

        local function setSrc(img, url)
            if img and img.src ~= url then img.src = url end
        end

        local function configuredColor(value)
            return value ~= "" and value or DEFAULT_NPC_COLOR
        end

        -- Torna um nome de tag insensível a maiúsculas: "b" -> "[bB]"
        local function caseInsensitive(word)
            return (word:gsub("%a", function(c) return "[" .. c:lower() .. c:upper() .. "]" end))
        end

        -- Remove BBCode e tags HTML simples das mensagens do chat
        local function cleanMessage(text)
            text = text or ""
            text = text:gsub("</?%a[^>]*>", "")
            for _, tag in ipairs(MARKUP_TAGS) do
                local t = caseInsensitive(tag)
                text = text:gsub("%[/" .. t .. "%]", "")
                text = text:gsub("%[" .. t .. "%]", "")
                text = text:gsub("%[" .. t .. "[=%s][^%]]*%]", "")
            end
            return text
        end

        -- ── Rotação de camadas ───────────────────────────────────────

        local function applySlotOrder(slotId, frontLayer)
            local imgs = slotControls(slotId)
            local urls = slotUrls[slotId]
            local o = {
                frontLayer,
                (frontLayer % 3) + 1,
                ((frontLayer + 1) % 3) + 1
            }
            setSrc(imgs[1], urls[o[1]])
            setSrc(imgs[2], urls[o[2]])
            setSrc(imgs[3], urls[o[3]])
        end

        -- ── Transição suave de opacidade ─────────────────────────────

        local function fadeTo(controlName, value)
            fadeTargets[controlName] = value
            self.tmrFade.enabled = true
        end

        local function onFadeTimer()
            local active = false
            for name, target in pairs(fadeTargets) do
                local img = self[name]
                if img then
                    local current = img.opacity or target
                    local diff = target - current
                    if math.abs(diff) < 0.02 then
                        img.opacity = target
                        fadeTargets[name] = nil
                    else
                        img.opacity = current + diff * 0.35
                        active = true
                    end
                else
                    fadeTargets[name] = nil
                end
            end
            if not active then self.tmrFade.enabled = false end
        end

        -- ── Foco global entre slots ───────────────────────────────────

        local function getFront(slotId)
            local value = sheet and sheet["slot_" .. slotId .. "_front"]
            return tonumber(value) or 1
        end

        -- activeSlotId = nil escurece todos os slots.
        -- activeLayer (opcional) destaca essa camada sem reordenar o slot.
        local function applySlotFocus(activeSlotId, activeLayer)
            for _, sid in ipairs(SLOT_IDS) do
                local active = (sid == activeSlotId)
                local levels = active and FOCUS_OPACITY or DIM_OPACITY

                -- posição atual (1 = frente) da camada que está falando
                local speakingPos = nil
                if active and activeLayer then
                    speakingPos = ((activeLayer - getFront(sid)) % 3) + 1
                end

                for pos = 1, 3 do
                    local level = levels[pos]
                    if speakingPos then
                        level = (pos == speakingPos) and 1.0 or math.min(level, 0.45)
                    end
                    fadeTo("imgSprite_" .. sid .. "_" .. pos, level)
                end
            end
        end

        -- ── Botão de foco manual ─────────────────────────────────────

        local function setFront(slotId, layer)
            if not sheet then return end
            local value = tostring(layer)
            local field = "slot_" .. slotId .. "_front"
            if sheet[field] ~= value then sheet[field] = value end
        end

        local function setFocus(slotId, layer)
            setFront(slotId, layer)
            applySlotOrder(slotId, layer)
            applySlotFocus(slotId)
            -- Esconde sprite de extra temporário
            self.imgExtraSprite.visible = false
        end

        -- ── Aviso de imagem que não carregou ─────────────────────────

        local function updatePreviewState(img, errLabel, url)
            if not img or not errLabel then return false end
            if url == "" then
                errLabel.visible = false
                return false
            end
            local loaded = (img.naturalWidth or 0) > 0
            errLabel.visible = not loaded
            return not loaded
        end

        local function checkPreviews()
            local pending = false
            for _, slotId in ipairs(SLOT_IDS) do
                for layer = 1, 3 do
                    local suffix = slotId .. "_" .. layer
                    if updatePreviewState(self["imgPreview_" .. suffix],
                                          self["labPreviewErr_" .. suffix],
                                          slotUrls[slotId][layer]) then
                        pending = true
                    end
                end
            end
            for i = 1, MAX_EXTRAS do
                if updatePreviewState(self["imgPreviewExtra_" .. i],
                                      self["labPreviewErrExtra_" .. i],
                                      extraUrls[i] or "") then
                    pending = true
                end
            end
            previewCheckRuns = previewCheckRuns + 1
            if not pending or previewCheckRuns >= 6 then
                self.tmrPreview.enabled = false
            end
        end

        local function schedulePreviewCheck()
            previewCheckRuns = 0
            self.tmrPreview.enabled = false
            self.tmrPreview.enabled = true
        end

        -- ── Carrega configurações ────────────────────────────────────

        local function loadConfig()
            if bulkUpdating then return end
            local node = sheet
            setSrc(self.imgBackground, (node and node.bgUrl) or "")

            npcMap    = {}
            npcColors = {}
            extraUrls = {}
            local duplicateNames = {}
            local hasExtras = false

            local function registerNpc(name, entry, color)
                local key = normalizeNpcName(name)
                if key == "" then return end
                if npcMap[key] then
                    duplicateNames[key] = true
                    return
                end
                npcMap[key] = entry
                npcColors[key] = color
            end

            for _, slotId in ipairs(SLOT_IDS) do
                local visible = (node and node["slot_" .. slotId .. "_visible"]) == true

                for layer = 1, 3 do
                    local url   = (node and node["slot_" .. slotId .. "_url"   .. layer]) or ""
                    local name  = (node and node["slot_" .. slotId .. "_npc"   .. layer]) or ""
                    local color = configuredColor((node and node["slot_" .. slotId .. "_color" .. layer]) or "")
                    slotUrls[slotId][layer] = url
                    registerNpc(name, { slot = slotId, layer = layer }, color)
                end

                local frontStr = (node and node["slot_" .. slotId .. "_front"]) or "1"
                local front    = tonumber(frontStr) or 1
                applySlotOrder(slotId, front)

                local imgs = slotControls(slotId)
                imgs[1].visible = visible
                imgs[2].visible = visible
                imgs[3].visible = visible

                -- Preview por linha
                for layer = 1, 3 do
                    local prevImg = self["imgPreview_" .. slotId .. "_" .. layer]
                    setSrc(prevImg, slotUrls[slotId][layer])
                end
            end

            for i = 1, MAX_EXTRAS do
                local npcName = (node and node["extra_" .. i .. "_npc"])   or ""
                local url     = (node and node["extra_" .. i .. "_url"])   or ""
                local color   = configuredColor((node and node["extra_" .. i .. "_color"]) or "")
                extraUrls[i]  = url
                if url ~= "" or npcName ~= "" then hasExtras = true end
                local ctrls   = extraControls(i)
                setSrc(ctrls.img, url)
                ctrls.rect.visible = (url ~= "" or npcName ~= "")
                ctrls.img.visible  = (url ~= "")

                registerNpc(npcName, { extra = i }, color)

                -- Preview na config
                local prevImg = self["imgPreviewExtra_" .. i]
                setSrc(prevImg, url)
            end

            local duplicates = {}
            for name in pairs(duplicateNames) do table.insert(duplicates, name) end
            table.sort(duplicates)
            if self.labConfigWarning then
                self.labConfigWarning.visible = #duplicates > 0
                self.labConfigWarning.text = #duplicates > 0
                    and "Nomes de NPC duplicados: " .. table.concat(duplicates, ", ") .. ". O primeiro cadastro será usado."
                    or ""
            end
            self.rectExtrasBar.visible = hasExtras
            schedulePreviewCheck()
        end

        -- Campos de texto: espera o usuário parar de digitar antes de recarregar
        local function scheduleLoadConfig()
            self.tmrConfig.enabled = false
            self.tmrConfig.enabled = true
        end

        local function onConfigTimer()
            self.tmrConfig.enabled = false
            loadConfig()
        end

        -- ── Limpar e girar configuração ──────────────────────────────

        local function resetSlotFields(node, slotId)
            node["slot_" .. slotId .. "_front"] = "1"
            for layer = 1, 3 do
                node["slot_" .. slotId .. "_npc"   .. layer] = ""
                node["slot_" .. slotId .. "_url"   .. layer] = ""
                node["slot_" .. slotId .. "_color" .. layer] = DEFAULT_NPC_COLOR
            end
        end

        local function resetAllFields(node)
            node.bgUrl = ""

            for _, slotId in ipairs(SLOT_IDS) do
                node["slot_" .. slotId .. "_visible"] = false
                resetSlotFields(node, slotId)
            end

            for i = 1, MAX_EXTRAS do
                node["extra_" .. i .. "_npc"]   = ""
                node["extra_" .. i .. "_url"]   = ""
                node["extra_" .. i .. "_color"] = DEFAULT_NPC_COLOR
            end
        end

        local function clearConfig()
            if not sheet then return end
            bulkUpdating = true
            resetAllFields(sheet)
            bulkUpdating = false
            loadConfig()
        end

        local function confirmClearConfig()
            Dialogs.confirmYesNo("Apagar todos os nomes, cores e URLs da cena?", function(confirmed)
                if confirmed then clearConfig() end
            end)
        end

        local function confirmClearSlot(slotId)
            Dialogs.confirmYesNo("Apagar nomes, cores e URLs deste slot?", function(confirmed)
                if not confirmed or not sheet then return end
                resetSlotFields(sheet, slotId)
                loadConfig()
            end)
        end

        -- O que estava na frente vai para trás; Meio sobe para Frente e Atrás para Meio
        local function rotateSlot(slotId)
            local node = sheet
            if not node then return end

            for _, field in ipairs({ "npc", "url", "color" }) do
                local default = (field == "color") and DEFAULT_NPC_COLOR or ""
                local key = "slot_" .. slotId .. "_" .. field
                local front, middle, back = node[key .. "1"], node[key .. "2"], node[key .. "3"]
                node[key .. "1"] = middle or default
                node[key .. "2"] = back   or default
                node[key .. "3"] = front  or default
            end

            loadConfig()
        end

        -- ── Exportar, importar e cenas salvas ────────────────────────

        -- Campos que compõem uma cena (as cenas salvas ficam fora, em scene_N_*)
        local function configKeys()
            if keysCache then return keysCache end
            local keys = { "bgUrl" }
            for _, slotId in ipairs(SLOT_IDS) do
                keys[#keys + 1] = "slot_" .. slotId .. "_visible"
                keys[#keys + 1] = "slot_" .. slotId .. "_front"
                for layer = 1, 3 do
                    keys[#keys + 1] = "slot_" .. slotId .. "_npc"   .. layer
                    keys[#keys + 1] = "slot_" .. slotId .. "_url"   .. layer
                    keys[#keys + 1] = "slot_" .. slotId .. "_color" .. layer
                end
            end
            for i = 1, MAX_EXTRAS do
                keys[#keys + 1] = "extra_" .. i .. "_npc"
                keys[#keys + 1] = "extra_" .. i .. "_url"
                keys[#keys + 1] = "extra_" .. i .. "_color"
            end
            keysCache = keys
            return keys
        end

        local function isBooleanKey(key)
            return key:sub(-8) == "_visible"
        end

        -- Texto no formato: primeira linha VNSCENE1, depois uma linha chave=valor por campo
        local function encodeConfig(node)
            local lines = { SCENE_FORMAT }
            for _, key in ipairs(configKeys()) do
                local value = node[key]
                if value == nil then value = isBooleanKey(key) and false or "" end
                value = tostring(value):gsub("[\r\n]+", " ")
                lines[#lines + 1] = key .. "=" .. value
            end
            return table.concat(lines, "\n")
        end

        local function trim(text)
            return (text:gsub("^%s*(.-)%s*$", "%1"))
        end

        -- Devolve tabela chave -> valor, ou nil se o texto não for uma configuração válida
        local function decodeConfig(text)
            if type(text) ~= "string" then return nil end
            text = text:gsub("^\239\187\191", "")   -- remove BOM UTF-8

            local allowed = {}
            for _, key in ipairs(configKeys()) do allowed[key] = true end

            local values = {}
            local found = 0
            local sawHeader = false
            for rawLine in (text .. "\n"):gmatch("([^\n]*)\n") do
                local line = trim(rawLine)
                if line ~= "" then
                    if not sawHeader then
                        if line ~= SCENE_FORMAT then return nil end
                        sawHeader = true
                    else
                        local key, value = line:match("^([^=]+)=(.*)$")
                        key = key and trim(key)
                        if key and allowed[key] then
                            values[key] = trim(value)
                            found = found + 1
                        end
                    end
                end
            end

            if not sawHeader or found == 0 then return nil end
            return values
        end

        local function defaultFor(key)
            if isBooleanKey(key) then return false end
            if key:find("_color", 1, true) then return DEFAULT_NPC_COLOR end
            if key:sub(-6) == "_front" then return "1" end
            return ""
        end

        -- Tira o estado temporário (extra em cena, foco dimmerizado) ao trocar de cena
        local function resetTransientScene()
            self.imgExtraSprite.visible = false
            for _, sid in ipairs(SLOT_IDS) do
                for pos = 1, 3 do
                    fadeTo("imgSprite_" .. sid .. "_" .. pos, FOCUS_OPACITY[pos])
                end
            end
        end

        -- Grava só o que mudou, sem recarregar a cena a cada campo, e recarrega uma vez no fim
        local function applyValues(node, values)
            bulkUpdating = true
            for _, key in ipairs(configKeys()) do
                local target = values[key]
                if target == nil then
                    target = defaultFor(key)
                elseif isBooleanKey(key) then
                    target = (target == "true")
                end
                if node[key] ~= target then node[key] = target end
            end
            bulkUpdating = false
            resetTransientScene()
            loadConfig()
        end

        local function exportConfig()
            if not sheet then return end
            if System.setClipboardText(encodeConfig(sheet)) then
                showMessage("Configuração copiada. Cole em um arquivo ou mensagem para guardar ou compartilhar.")
            else
                showMessage("Não foi possível copiar para a área de transferência.")
            end
        end

        local function importConfig()
            local values = decodeConfig(System.getClipboardText())
            if not values then
                showMessage("A área de transferência não tem uma configuração válida. Copie o texto inteiro gerado por 'Exportar'.")
                return
            end
            Dialogs.confirmYesNo("Substituir a configuração atual pela que está na área de transferência?", function(confirmed)
                if confirmed and sheet then applyValues(sheet, values) end
            end)
        end

        local function saveScene(n)
            local node = sheet
            if not node then return end
            local nameKey = "scene_" .. n .. "_name"
            if normalizeNpcName(node[nameKey] or "") == "" then node[nameKey] = "Cena " .. n end
            node["scene_" .. n .. "_data"] = encodeConfig(node)
        end

        local function confirmSaveScene(n)
            local node = sheet
            if not node then return end
            if (node["scene_" .. n .. "_data"] or "") == "" then
                saveScene(n)
                return
            end
            Dialogs.confirmYesNo("Já existe uma cena neste espaço. Sobrescrever com a configuração atual?", function(confirmed)
                if confirmed then saveScene(n) end
            end)
        end

        local function confirmLoadScene(n)
            local node = sheet
            if not node then return end
            local values = decodeConfig(node["scene_" .. n .. "_data"])
            if not values then
                showMessage("Este espaço está vazio. Use 'Salvar' para guardar a cena atual aqui.")
                return
            end
            local name = node["scene_" .. n .. "_name"] or ""
            if name == "" then name = "Cena " .. n end
            Dialogs.confirmYesNo("Substituir a configuração atual pela cena \"" .. name .. "\"?", function(confirmed)
                if confirmed and sheet then applyValues(sheet, values) end
            end)
        end

        local function confirmDeleteScene(n)
            local node = sheet
            if node and (node["scene_" .. n .. "_data"] or "") == "" and (node["scene_" .. n .. "_name"] or "") == "" then
                showMessage("Este espaço já está vazio.")
                return
            end
            Dialogs.confirmYesNo("Apagar esta cena salva?", function(confirmed)
                if not confirmed or not sheet then return end
                sheet["scene_" .. n .. "_name"] = ""
                sheet["scene_" .. n .. "_data"] = ""
            end)
        end

        -- ── Diálogo ──────────────────────────────────────────────────

        local function layoutDialog(hasAvatar)
            local top = dialogExpanded and 350 or 516
            self.rectDialog.top = top
            self.rectDialog.height = dialogExpanded and 250 or 84
            self.imgDialogAvatar.top = top + 3
            self.labDialogName.top = top + 5
            self.labDialogContent.top = top + 29
            self.labDialogContent.height = dialogExpanded and 216 or 52
            self.btnDialogExpand.top = top + 4
            self.btnDialogExpand.text = dialogExpanded and "Reduzir" or "Expandir"

            if hasAvatar then
                self.labDialogName.left = 100
                self.labDialogName.width = 1060
                self.labDialogContent.left = 100
                self.labDialogContent.width = 1060
            else
                self.labDialogName.left = 35
                self.labDialogName.width = 1125
                self.labDialogContent.left = 35
                self.labDialogContent.width = 1125
            end
        end

        local function toggleDialogExpanded()
            if not self.rectDialog.visible then return end
            dialogExpanded = not dialogExpanded
            layoutDialog(self.imgDialogAvatar.visible)
        end

        local function showDialog(npcName, content, avatarUrl)
            local color = npcColors[normalizeNpcName(npcName)] or DEFAULT_NPC_COLOR
            self.labDialogName.text      = npcName or ""
            self.labDialogName.fontColor = color
            self.labDialogContent.text   = content or ""
            self.rectDialog.visible      = true
            self.btnDialogExpand.visible = true

            -- Avatar
            if avatarUrl and avatarUrl ~= "" then
                setSrc(self.imgDialogAvatar, avatarUrl)
                self.imgDialogAvatar.visible = true
            else
                self.imgDialogAvatar.visible = false
            end
            layoutDialog(self.imgDialogAvatar.visible)
        end

        -- ── Chat ─────────────────────────────────────────────────────

        local function onChatMessage(msg)
            if sheet and sheet.listenChat == false then return end

            local logRec = msg.logRec
            if not logRec then return end
            local msgContent = logRec.msg
            if not msgContent then return end

            local content     = cleanMessage(msgContent.content)
            local impersonate = msgContent.impersonation
            if not impersonate then return end

            if impersonate.mode == "character" then
                local npcName = impersonate.name or ""
                local entry   = npcMap[normalizeNpcName(npcName)]

                if entry then
                    if entry.slot then
                        -- NPC de slot normal
                        local avatarUrl = slotUrls[entry.slot][entry.layer]
                        if sheet and sheet.keepLayerOrder == true then
                            applySlotFocus(entry.slot, entry.layer)
                        else
                            setFront(entry.slot, entry.layer)
                            applySlotOrder(entry.slot, entry.layer)
                            applySlotFocus(entry.slot)
                        end
                        self.imgExtraSprite.visible = false
                        showDialog(npcName, content, avatarUrl)

                    elseif entry.extra then
                        -- Extra entra em cena no slot centro temporariamente
                        local url = extraUrls[entry.extra] or ""
                        setSrc(self.imgExtraSprite, url)
                        self.imgExtraSprite.visible = true
                        -- Escurece os slots para dar destaque ao extra
                        applySlotFocus(nil)
                        showDialog(npcName, content, url)
                    end
                else
                    -- NPC não mapeado: só texto
                    self.imgExtraSprite.visible = false
                    showDialog(npcName, content, nil)
                end

            elseif impersonate.mode == "narrator" then
                self.imgExtraSprite.visible  = false
                self.imgDialogAvatar.visible = false
                self.labDialogName.text      = "Narrador"
                self.labDialogName.fontColor = "#cccccc"
                self.labDialogContent.text   = content
                self.rectDialog.visible      = true
                self.btnDialogExpand.visible = true
                layoutDialog(false)
                applySlotFocus(nil)
            end
        end

        -- ── Init ─────────────────────────────────────────────────────

        local function updateStageScale()
            local container = self.frmStageContainer
            if not container or container.width <= 0 or container.height <= 0 then return end

            local scale = math.min(container.width / 1280, container.height / 600)

            self.frmStage.scaleX = scale
            self.frmStage.scaleY = scale
            self.frmStage.left = math.max(0, (container.width - 1280 * scale) / 2)
            self.frmStage.top  = math.max(0, (container.height - 600 * scale) / 2)
        end

        -- Mostra a configuração na aba própria ou, no modo debug, ao lado da cena
        local function updateConfigTab()
            local showConfig = not (sheet and sheet.hideConfig == true)
            local debug      = sheet and sheet.debugMode == true
            local host       = self.sceneContent
            local panel      = self.panelConfig

            if debug then
                if host.width <= 0 or host.height <= 0 then return end

                if not configDocked then
                    panel.parent = host
                    configDocked = true
                end
                panel.visible = showConfig

                if host.width >= 900 then
                    panel.align = "right"
                    panel.width = math.max(360, math.min(560, host.width * 0.42))
                else
                    panel.align = "bottom"
                    panel.height = host.height * 0.5
                end

                self.tabConfig.visible = false
                self.tcMain.tabIndex = 0
            else
                if configDocked then
                    panel.parent = self.tabConfig
                    panel.align = "client"
                    panel.visible = true
                    configDocked = false
                end

                self.tabConfig.visible = showConfig
                if not showConfig then self.tcMain.tabIndex = 0 end
            end
        end

        local function updateSlotLayout()
            local container = self.slotConfigs
            if not container then return end

            local stacked = container.width < 1220
            if stacked then
                container.height = SLOT_CONFIG_HEIGHT * 3
                self.configContent.height = CONFIG_BASE_HEIGHT + SLOT_CONFIG_HEIGHT * 3
                for _, name in ipairs({"slotConfigLeft", "slotConfigCenter", "slotConfigRight"}) do
                    self[name].align = "top"
                    self[name].height = SLOT_CONFIG_HEIGHT
                end
            else
                container.height = SLOT_CONFIG_HEIGHT
                self.configContent.height = CONFIG_BASE_HEIGHT + SLOT_CONFIG_HEIGHT
                self.slotConfigLeft.align = "left"
                self.slotConfigLeft.width = 400
                self.slotConfigLeft.height = SLOT_CONFIG_HEIGHT
                self.slotConfigCenter.align = "left"
                self.slotConfigCenter.width = 400
                self.slotConfigCenter.height = SLOT_CONFIG_HEIGHT
                self.slotConfigRight.align = "client"
            end
        end

        local function init()
            loadConfig()
            updateSlotLayout()
            updateStageScale()
            updateConfigTab()
            if chatReceiver == nil then
                chatReceiver = Firecast.Messaging.newReceiver("ChatMessageEx", onChatMessage)
            end
        end

        local function uninit()
            if chatReceiver then
                chatReceiver:disable()
                chatReceiver = nil
            end
        end
    



    


    obj.tmrConfig = GUI.fromHandle(_obj_newObject("timer"));
    obj.tmrConfig:setParent(obj);
    obj.tmrConfig:setName("tmrConfig");
    obj.tmrConfig:setInterval(600);
    obj.tmrConfig:setEnabled(false);

    obj.tmrFade = GUI.fromHandle(_obj_newObject("timer"));
    obj.tmrFade:setParent(obj);
    obj.tmrFade:setName("tmrFade");
    obj.tmrFade:setInterval(40);
    obj.tmrFade:setEnabled(false);

    obj.tmrPreview = GUI.fromHandle(_obj_newObject("timer"));
    obj.tmrPreview:setParent(obj);
    obj.tmrPreview:setName("tmrPreview");
    obj.tmrPreview:setInterval(2000);
    obj.tmrPreview:setEnabled(false);

    obj.tcMain = GUI.fromHandle(_obj_newObject("tabControl"));
    obj.tcMain:setParent(obj);
    obj.tcMain:setAlign("client");
    obj.tcMain:setName("tcMain");
    obj.tcMain:setTabIndex(0);

    obj.tab1 = GUI.fromHandle(_obj_newObject("tab"));
    obj.tab1:setParent(obj.tcMain);
    obj.tab1:setTitle("Cena");
    obj.tab1:setName("tab1");

    obj.sceneContent = GUI.fromHandle(_obj_newObject("layout"));
    obj.sceneContent:setParent(obj.tab1);
    obj.sceneContent:setAlign("client");
    obj.sceneContent:setName("sceneContent");

    obj.layout1 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout1:setParent(obj.sceneContent);
    obj.layout1:setAlign("bottom");
    obj.layout1:setHeight(24);
    obj.layout1:setMargins({left=8, right=8, top=4, bottom=4});
    obj.layout1:setName("layout1");

    obj.checkBox1 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.checkBox1:setParent(obj.layout1);
    obj.checkBox1:setAlign("left");
    obj.checkBox1:setWidth(190);
    obj.checkBox1:setField("hideConfig");
    obj.checkBox1:setText("Ocultar Configuração");
    obj.checkBox1:setHint("Esconde a configuração (útil para jogadores)");
    obj.checkBox1:setName("checkBox1");

    obj.checkBox2 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.checkBox2:setParent(obj.layout1);
    obj.checkBox2:setAlign("left");
    obj.checkBox2:setWidth(340);
    obj.checkBox2:setField("debugMode");
    obj.checkBox2:setText("Modo debug (cena e configuração lado a lado)");
    obj.checkBox2:setHint("Mostra a configuração ao lado da cena, sem trocar de aba");
    obj.checkBox2:setName("checkBox2");

    obj.frmStageContainer = GUI.fromHandle(_obj_newObject("layout"));
    obj.frmStageContainer:setParent(obj.sceneContent);
    obj.frmStageContainer:setAlign("client");
    obj.frmStageContainer:setName("frmStageContainer");

    obj.frmStage = GUI.fromHandle(_obj_newObject("layout"));
    obj.frmStage:setParent(obj.frmStageContainer);
    obj.frmStage:setLeft(0);
    obj.frmStage:setTop(0);
    obj.frmStage:setWidth(1280);
    obj.frmStage:setHeight(600);
    obj.frmStage:setName("frmStage");

    obj.imgBackground = GUI.fromHandle(_obj_newObject("image"));
    obj.imgBackground:setParent(obj.frmStage);
    obj.imgBackground:setName("imgBackground");
    obj.imgBackground:setLeft(0);
    obj.imgBackground:setTop(0);
    obj.imgBackground:setWidth(1280);
    obj.imgBackground:setHeight(600);
    obj.imgBackground:setStyle("stretch");
    obj.imgBackground:setSRC("");

    obj.imgSprite_left_3 = GUI.fromHandle(_obj_newObject("image"));
    obj.imgSprite_left_3:setParent(obj.frmStage);
    obj.imgSprite_left_3:setName("imgSprite_left_3");
    obj.imgSprite_left_3:setLeft(160);
    obj.imgSprite_left_3:setTop(215);
    obj.imgSprite_left_3:setWidth(239);
    obj.imgSprite_left_3:setHeight(400);
    obj.imgSprite_left_3:setStyle("proportional");
    obj.imgSprite_left_3:setOpacity(0.25);
    obj.imgSprite_left_3:setVisible(false);
    obj.imgSprite_left_3:setSRC("");

    obj.imgSprite_left_2 = GUI.fromHandle(_obj_newObject("image"));
    obj.imgSprite_left_2:setParent(obj.frmStage);
    obj.imgSprite_left_2:setName("imgSprite_left_2");
    obj.imgSprite_left_2:setLeft(96);
    obj.imgSprite_left_2:setTop(107);
    obj.imgSprite_left_2:setWidth(288);
    obj.imgSprite_left_2:setHeight(480);
    obj.imgSprite_left_2:setStyle("proportional");
    obj.imgSprite_left_2:setOpacity(0.45);
    obj.imgSprite_left_2:setVisible(false);
    obj.imgSprite_left_2:setSRC("");

    obj.imgSprite_left_1 = GUI.fromHandle(_obj_newObject("image"));
    obj.imgSprite_left_1:setParent(obj.frmStage);
    obj.imgSprite_left_1:setName("imgSprite_left_1");
    obj.imgSprite_left_1:setLeft(23);
    obj.imgSprite_left_1:setTop(0);
    obj.imgSprite_left_1:setWidth(337);
    obj.imgSprite_left_1:setHeight(564);
    obj.imgSprite_left_1:setStyle("proportional");
    obj.imgSprite_left_1:setOpacity(1.0);
    obj.imgSprite_left_1:setVisible(false);
    obj.imgSprite_left_1:setSRC("");

    obj.imgSprite_center_3 = GUI.fromHandle(_obj_newObject("image"));
    obj.imgSprite_center_3:setParent(obj.frmStage);
    obj.imgSprite_center_3:setName("imgSprite_center_3");
    obj.imgSprite_center_3:setLeft(567);
    obj.imgSprite_center_3:setTop(215);
    obj.imgSprite_center_3:setWidth(239);
    obj.imgSprite_center_3:setHeight(400);
    obj.imgSprite_center_3:setStyle("proportional");
    obj.imgSprite_center_3:setOpacity(0.25);
    obj.imgSprite_center_3:setVisible(false);
    obj.imgSprite_center_3:setSRC("");

    obj.imgSprite_center_2 = GUI.fromHandle(_obj_newObject("image"));
    obj.imgSprite_center_2:setParent(obj.frmStage);
    obj.imgSprite_center_2:setName("imgSprite_center_2");
    obj.imgSprite_center_2:setLeft(503);
    obj.imgSprite_center_2:setTop(107);
    obj.imgSprite_center_2:setWidth(288);
    obj.imgSprite_center_2:setHeight(480);
    obj.imgSprite_center_2:setStyle("proportional");
    obj.imgSprite_center_2:setOpacity(0.45);
    obj.imgSprite_center_2:setVisible(false);
    obj.imgSprite_center_2:setSRC("");

    obj.imgSprite_center_1 = GUI.fromHandle(_obj_newObject("image"));
    obj.imgSprite_center_1:setParent(obj.frmStage);
    obj.imgSprite_center_1:setName("imgSprite_center_1");
    obj.imgSprite_center_1:setLeft(471);
    obj.imgSprite_center_1:setTop(0);
    obj.imgSprite_center_1:setWidth(337);
    obj.imgSprite_center_1:setHeight(564);
    obj.imgSprite_center_1:setStyle("proportional");
    obj.imgSprite_center_1:setOpacity(1.0);
    obj.imgSprite_center_1:setVisible(false);
    obj.imgSprite_center_1:setSRC("");

    obj.imgSprite_right_3 = GUI.fromHandle(_obj_newObject("image"));
    obj.imgSprite_right_3:setParent(obj.frmStage);
    obj.imgSprite_right_3:setName("imgSprite_right_3");
    obj.imgSprite_right_3:setLeft(881);
    obj.imgSprite_right_3:setTop(215);
    obj.imgSprite_right_3:setWidth(239);
    obj.imgSprite_right_3:setHeight(400);
    obj.imgSprite_right_3:setStyle("proportional");
    obj.imgSprite_right_3:setOpacity(0.25);
    obj.imgSprite_right_3:setVisible(false);
    obj.imgSprite_right_3:setSRC("");

    obj.imgSprite_right_2 = GUI.fromHandle(_obj_newObject("image"));
    obj.imgSprite_right_2:setParent(obj.frmStage);
    obj.imgSprite_right_2:setName("imgSprite_right_2");
    obj.imgSprite_right_2:setLeft(896);
    obj.imgSprite_right_2:setTop(107);
    obj.imgSprite_right_2:setWidth(288);
    obj.imgSprite_right_2:setHeight(480);
    obj.imgSprite_right_2:setStyle("proportional");
    obj.imgSprite_right_2:setOpacity(0.45);
    obj.imgSprite_right_2:setVisible(false);
    obj.imgSprite_right_2:setSRC("");

    obj.imgSprite_right_1 = GUI.fromHandle(_obj_newObject("image"));
    obj.imgSprite_right_1:setParent(obj.frmStage);
    obj.imgSprite_right_1:setName("imgSprite_right_1");
    obj.imgSprite_right_1:setLeft(920);
    obj.imgSprite_right_1:setTop(0);
    obj.imgSprite_right_1:setWidth(337);
    obj.imgSprite_right_1:setHeight(564);
    obj.imgSprite_right_1:setStyle("proportional");
    obj.imgSprite_right_1:setOpacity(1.0);
    obj.imgSprite_right_1:setVisible(false);
    obj.imgSprite_right_1:setSRC("");

    obj.imgExtraSprite = GUI.fromHandle(_obj_newObject("image"));
    obj.imgExtraSprite:setParent(obj.frmStage);
    obj.imgExtraSprite:setName("imgExtraSprite");
    obj.imgExtraSprite:setLeft(471);
    obj.imgExtraSprite:setTop(0);
    obj.imgExtraSprite:setWidth(337);
    obj.imgExtraSprite:setHeight(564);
    obj.imgExtraSprite:setStyle("proportional");
    obj.imgExtraSprite:setOpacity(1.0);
    obj.imgExtraSprite:setVisible(false);
    obj.imgExtraSprite:setSRC("");

    obj.rectExtrasBar = GUI.fromHandle(_obj_newObject("rectangle"));
    obj.rectExtrasBar:setParent(obj.frmStage);
    obj.rectExtrasBar:setName("rectExtrasBar");
    obj.rectExtrasBar:setLeft(0);
    obj.rectExtrasBar:setTop(456);
    obj.rectExtrasBar:setWidth(1280);
    obj.rectExtrasBar:setHeight(56);
    obj.rectExtrasBar:setColor("#0a0820");
    obj.rectExtrasBar:setOpacity(0.75);

    obj.rectExtra_1 = GUI.fromHandle(_obj_newObject("rectangle"));
    obj.rectExtra_1:setParent(obj.frmStage);
    obj.rectExtra_1:setName("rectExtra_1");
    obj.rectExtra_1:setLeft(443);
    obj.rectExtra_1:setTop(460);
    obj.rectExtra_1:setWidth(58);
    obj.rectExtra_1:setHeight(48);
    obj.rectExtra_1:setColor("#1a1535");
    obj.rectExtra_1:setOpacity(0.9);
    obj.rectExtra_1:setVisible(false);

    obj.imgExtra_1 = GUI.fromHandle(_obj_newObject("image"));
    obj.imgExtra_1:setParent(obj.frmStage);
    obj.imgExtra_1:setName("imgExtra_1");
    obj.imgExtra_1:setLeft(448);
    obj.imgExtra_1:setTop(463);
    obj.imgExtra_1:setWidth(49);
    obj.imgExtra_1:setHeight(41);
    obj.imgExtra_1:setStyle("proportional");
    obj.imgExtra_1:setVisible(false);
    obj.imgExtra_1:setSRC("");

    obj.rectExtra_2 = GUI.fromHandle(_obj_newObject("rectangle"));
    obj.rectExtra_2:setParent(obj.frmStage);
    obj.rectExtra_2:setName("rectExtra_2");
    obj.rectExtra_2:setLeft(510);
    obj.rectExtra_2:setTop(460);
    obj.rectExtra_2:setWidth(58);
    obj.rectExtra_2:setHeight(48);
    obj.rectExtra_2:setColor("#1a1535");
    obj.rectExtra_2:setOpacity(0.9);
    obj.rectExtra_2:setVisible(false);

    obj.imgExtra_2 = GUI.fromHandle(_obj_newObject("image"));
    obj.imgExtra_2:setParent(obj.frmStage);
    obj.imgExtra_2:setName("imgExtra_2");
    obj.imgExtra_2:setLeft(515);
    obj.imgExtra_2:setTop(463);
    obj.imgExtra_2:setWidth(49);
    obj.imgExtra_2:setHeight(41);
    obj.imgExtra_2:setStyle("proportional");
    obj.imgExtra_2:setVisible(false);
    obj.imgExtra_2:setSRC("");

    obj.rectExtra_3 = GUI.fromHandle(_obj_newObject("rectangle"));
    obj.rectExtra_3:setParent(obj.frmStage);
    obj.rectExtra_3:setName("rectExtra_3");
    obj.rectExtra_3:setLeft(577);
    obj.rectExtra_3:setTop(460);
    obj.rectExtra_3:setWidth(58);
    obj.rectExtra_3:setHeight(48);
    obj.rectExtra_3:setColor("#1a1535");
    obj.rectExtra_3:setOpacity(0.9);
    obj.rectExtra_3:setVisible(false);

    obj.imgExtra_3 = GUI.fromHandle(_obj_newObject("image"));
    obj.imgExtra_3:setParent(obj.frmStage);
    obj.imgExtra_3:setName("imgExtra_3");
    obj.imgExtra_3:setLeft(582);
    obj.imgExtra_3:setTop(463);
    obj.imgExtra_3:setWidth(49);
    obj.imgExtra_3:setHeight(41);
    obj.imgExtra_3:setStyle("proportional");
    obj.imgExtra_3:setVisible(false);
    obj.imgExtra_3:setSRC("");

    obj.rectExtra_4 = GUI.fromHandle(_obj_newObject("rectangle"));
    obj.rectExtra_4:setParent(obj.frmStage);
    obj.rectExtra_4:setName("rectExtra_4");
    obj.rectExtra_4:setLeft(644);
    obj.rectExtra_4:setTop(460);
    obj.rectExtra_4:setWidth(58);
    obj.rectExtra_4:setHeight(48);
    obj.rectExtra_4:setColor("#1a1535");
    obj.rectExtra_4:setOpacity(0.9);
    obj.rectExtra_4:setVisible(false);

    obj.imgExtra_4 = GUI.fromHandle(_obj_newObject("image"));
    obj.imgExtra_4:setParent(obj.frmStage);
    obj.imgExtra_4:setName("imgExtra_4");
    obj.imgExtra_4:setLeft(649);
    obj.imgExtra_4:setTop(463);
    obj.imgExtra_4:setWidth(49);
    obj.imgExtra_4:setHeight(41);
    obj.imgExtra_4:setStyle("proportional");
    obj.imgExtra_4:setVisible(false);
    obj.imgExtra_4:setSRC("");

    obj.rectExtra_5 = GUI.fromHandle(_obj_newObject("rectangle"));
    obj.rectExtra_5:setParent(obj.frmStage);
    obj.rectExtra_5:setName("rectExtra_5");
    obj.rectExtra_5:setLeft(711);
    obj.rectExtra_5:setTop(460);
    obj.rectExtra_5:setWidth(58);
    obj.rectExtra_5:setHeight(48);
    obj.rectExtra_5:setColor("#1a1535");
    obj.rectExtra_5:setOpacity(0.9);
    obj.rectExtra_5:setVisible(false);

    obj.imgExtra_5 = GUI.fromHandle(_obj_newObject("image"));
    obj.imgExtra_5:setParent(obj.frmStage);
    obj.imgExtra_5:setName("imgExtra_5");
    obj.imgExtra_5:setLeft(716);
    obj.imgExtra_5:setTop(463);
    obj.imgExtra_5:setWidth(49);
    obj.imgExtra_5:setHeight(41);
    obj.imgExtra_5:setStyle("proportional");
    obj.imgExtra_5:setVisible(false);
    obj.imgExtra_5:setSRC("");

    obj.rectExtra_6 = GUI.fromHandle(_obj_newObject("rectangle"));
    obj.rectExtra_6:setParent(obj.frmStage);
    obj.rectExtra_6:setName("rectExtra_6");
    obj.rectExtra_6:setLeft(778);
    obj.rectExtra_6:setTop(460);
    obj.rectExtra_6:setWidth(58);
    obj.rectExtra_6:setHeight(48);
    obj.rectExtra_6:setColor("#1a1535");
    obj.rectExtra_6:setOpacity(0.9);
    obj.rectExtra_6:setVisible(false);

    obj.imgExtra_6 = GUI.fromHandle(_obj_newObject("image"));
    obj.imgExtra_6:setParent(obj.frmStage);
    obj.imgExtra_6:setName("imgExtra_6");
    obj.imgExtra_6:setLeft(783);
    obj.imgExtra_6:setTop(463);
    obj.imgExtra_6:setWidth(49);
    obj.imgExtra_6:setHeight(41);
    obj.imgExtra_6:setStyle("proportional");
    obj.imgExtra_6:setVisible(false);
    obj.imgExtra_6:setSRC("");

    obj.rectDialog = GUI.fromHandle(_obj_newObject("rectangle"));
    obj.rectDialog:setParent(obj.frmStage);
    obj.rectDialog:setName("rectDialog");
    obj.rectDialog:setLeft(0);
    obj.rectDialog:setTop(516);
    obj.rectDialog:setWidth(1280);
    obj.rectDialog:setHeight(84);
    obj.rectDialog:setColor("#0a0820");
    obj.rectDialog:setOpacity(0.88);
    obj.rectDialog:setVisible(false);

    obj.imgDialogAvatar = GUI.fromHandle(_obj_newObject("image"));
    obj.imgDialogAvatar:setParent(obj.frmStage);
    obj.imgDialogAvatar:setName("imgDialogAvatar");
    obj.imgDialogAvatar:setLeft(38);
    obj.imgDialogAvatar:setTop(519);
    obj.imgDialogAvatar:setWidth(56);
    obj.imgDialogAvatar:setHeight(56);
    obj.imgDialogAvatar:setStyle("proportional");
    obj.imgDialogAvatar:setVisible(false);
    obj.imgDialogAvatar:setSRC("");

    obj.labDialogName = GUI.fromHandle(_obj_newObject("label"));
    obj.labDialogName:setParent(obj.frmStage);
    obj.labDialogName:setName("labDialogName");
    obj.labDialogName:setLeft(35);
    obj.labDialogName:setTop(521);
    obj.labDialogName:setWidth(1210);
    obj.labDialogName:setHeight(22);
    obj.labDialogName:setText("");
    obj.labDialogName:setFontColor("#a89fd8");
    obj.labDialogName:setFontSize(13);
    lfm_setPropAsString(obj.labDialogName, "fontStyle", "bold");

    obj.labDialogContent = GUI.fromHandle(_obj_newObject("label"));
    obj.labDialogContent:setParent(obj.frmStage);
    obj.labDialogContent:setName("labDialogContent");
    obj.labDialogContent:setLeft(35);
    obj.labDialogContent:setTop(545);
    obj.labDialogContent:setWidth(1210);
    obj.labDialogContent:setHeight(52);
    obj.labDialogContent:setText("");
    obj.labDialogContent:setFontColor("White");
    obj.labDialogContent:setFontSize(12);
    obj.labDialogContent:setWordWrap(true);

    obj.btnDialogExpand = GUI.fromHandle(_obj_newObject("button"));
    obj.btnDialogExpand:setParent(obj.frmStage);
    obj.btnDialogExpand:setName("btnDialogExpand");
    obj.btnDialogExpand:setLeft(1170);
    obj.btnDialogExpand:setTop(520);
    obj.btnDialogExpand:setWidth(90);
    obj.btnDialogExpand:setHeight(20);
    obj.btnDialogExpand:setText("Expandir");
    obj.btnDialogExpand:setFontSize(9);
    obj.btnDialogExpand:setVisible(false);
    obj.btnDialogExpand:setHint("Expande ou reduz a caixa de diálogo");

    obj.tabConfig = GUI.fromHandle(_obj_newObject("tab"));
    obj.tabConfig:setParent(obj.tcMain);
    obj.tabConfig:setTitle("Configuração");
    obj.tabConfig:setName("tabConfig");

    obj.panelConfig = GUI.fromHandle(_obj_newObject("layout"));
    obj.panelConfig:setParent(obj.tabConfig);
    obj.panelConfig:setAlign("client");
    obj.panelConfig:setName("panelConfig");

    obj.scrollBox1 = GUI.fromHandle(_obj_newObject("scrollBox"));
    obj.scrollBox1:setParent(obj.panelConfig);
    obj.scrollBox1:setAlign("client");
    obj.scrollBox1:setName("scrollBox1");

    obj.configContent = GUI.fromHandle(_obj_newObject("layout"));
    obj.configContent:setParent(obj.scrollBox1);
    obj.configContent:setName("configContent");
    obj.configContent:setAlign("top");
    obj.configContent:setHeight(1220);
    obj.configContent:setMargins({left=12, right=12, top=12, bottom=12});

    obj.button1 = GUI.fromHandle(_obj_newObject("button"));
    obj.button1:setParent(obj.configContent);
    obj.button1:setAlign("top");
    obj.button1:setHeight(28);
    obj.button1:setText("🗑 Limpar tudo (nomes e URLs)");
    obj.button1:setHint("Apaga toda a configuração da cena (pede confirmação)");
    obj.button1:setMargins({bottom=8});
    obj.button1:setName("button1");

    obj.label1 = GUI.fromHandle(_obj_newObject("label"));
    obj.label1:setParent(obj.configContent);
    obj.label1:setText("Imagem de Fundo");
    obj.label1:setAlign("top");
    obj.label1:setHeight(20);
    lfm_setPropAsString(obj.label1, "fontStyle", "bold");
    obj.label1:setFontSize(13);
    obj.label1:setName("label1");

    obj.edit1 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit1:setParent(obj.configContent);
    obj.edit1:setAlign("top");
    obj.edit1:setHeight(28);
    obj.edit1:setField("bgUrl");
    obj.edit1:setHint("URL da imagem de fundo");
    obj.edit1:setMargins({bottom=16});
    obj.edit1:setName("edit1");

    obj.checkBox3 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.checkBox3:setParent(obj.configContent);
    obj.checkBox3:setAlign("top");
    obj.checkBox3:setHeight(24);
    obj.checkBox3:setField("listenChat");
    obj.checkBox3:setChecked(true);
    obj.checkBox3:setText("Atualizar a cena com mensagens do chat");
    obj.checkBox3:setHint("Quando ligado, as falas do chat atualizam sprites e diálogo");
    obj.checkBox3:setMargins({bottom=8});
    obj.checkBox3:setName("checkBox3");

    obj.checkBox4 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.checkBox4:setParent(obj.configContent);
    obj.checkBox4:setAlign("top");
    obj.checkBox4:setHeight(24);
    obj.checkBox4:setField("keepLayerOrder");
    obj.checkBox4:setText("Manter a ordem das camadas quando alguém fala");
    obj.checkBox4:setHint("Ligado: o personagem que fala é destacado onde está, sem ir para a frente");
    obj.checkBox4:setMargins({bottom=8});
    obj.checkBox4:setName("checkBox4");

    obj.labConfigWarning = GUI.fromHandle(_obj_newObject("label"));
    obj.labConfigWarning:setParent(obj.configContent);
    obj.labConfigWarning:setName("labConfigWarning");
    obj.labConfigWarning:setAlign("top");
    obj.labConfigWarning:setHeight(18);
    obj.labConfigWarning:setVisible(false);
    obj.labConfigWarning:setFontSize(10);
    obj.labConfigWarning:setFontColor("#d66");
    obj.labConfigWarning:setWordWrap(true);
    obj.labConfigWarning:setMargins({bottom=8});

    obj.label2 = GUI.fromHandle(_obj_newObject("label"));
    obj.label2:setParent(obj.configContent);
    obj.label2:setText("Slots de Personagem");
    obj.label2:setAlign("top");
    obj.label2:setHeight(20);
    lfm_setPropAsString(obj.label2, "fontStyle", "bold");
    obj.label2:setFontSize(13);
    obj.label2:setName("label2");

    obj.label3 = GUI.fromHandle(_obj_newObject("label"));
    obj.label3:setParent(obj.configContent);
    obj.label3:setText("Como funciona: o Nome cadastrado precisa ser igual ao nome do personagem usado no chat (maiúsculas e minúsculas não importam; espaços nas pontas são ignorados).");
    obj.label3:setAlign("top");
    obj.label3:setHeight(30);
    obj.label3:setFontSize(10);
    obj.label3:setFontColor("Gray");
    obj.label3:setWordWrap(true);
    obj.label3:setMargins({bottom=2});
    obj.label3:setName("label3");

    obj.label4 = GUI.fromHandle(_obj_newObject("label"));
    obj.label4:setParent(obj.configContent);
    obj.label4:setText("Quando esse personagem fala, a cena destaca o sprite dele e mostra a fala. Mensagens do Narrador só mostram o texto.");
    obj.label4:setAlign("top");
    obj.label4:setHeight(30);
    obj.label4:setFontSize(10);
    obj.label4:setFontColor("Gray");
    obj.label4:setWordWrap(true);
    obj.label4:setMargins({bottom=2});
    obj.label4:setName("label4");

    obj.label5 = GUI.fromHandle(_obj_newObject("label"));
    obj.label5:setParent(obj.configContent);
    obj.label5:setText("Cada slot tem 3 camadas (Frente, Meio, Atrás). Use ★ para escolher a camada em foco.");
    obj.label5:setAlign("top");
    obj.label5:setHeight(18);
    obj.label5:setFontSize(10);
    obj.label5:setFontColor("Gray");
    obj.label5:setWordWrap(true);
    obj.label5:setMargins({bottom=8});
    obj.label5:setName("label5");

    obj.slotConfigs = GUI.fromHandle(_obj_newObject("layout"));
    obj.slotConfigs:setParent(obj.configContent);
    obj.slotConfigs:setName("slotConfigs");
    obj.slotConfigs:setAlign("top");
    obj.slotConfigs:setHeight(152);

    obj.slotConfigLeft = GUI.fromHandle(_obj_newObject("layout"));
    obj.slotConfigLeft:setParent(obj.slotConfigs);
    obj.slotConfigLeft:setName("slotConfigLeft");
    obj.slotConfigLeft:setAlign("left");
    obj.slotConfigLeft:setWidth(400);
    obj.slotConfigLeft:setHeight(152);
    obj.slotConfigLeft:setMargins({right=8});

    obj.layout2 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout2:setParent(obj.slotConfigLeft);
    obj.layout2:setAlign("top");
    obj.layout2:setHeight(20);
    obj.layout2:setMargins({bottom=4});
    obj.layout2:setName("layout2");

    obj.label6 = GUI.fromHandle(_obj_newObject("label"));
    obj.label6:setParent(obj.layout2);
    obj.label6:setText("Esquerda");
    obj.label6:setAlign("left");
    obj.label6:setWidth(70);
    obj.label6:setFontSize(11);
    lfm_setPropAsString(obj.label6, "fontStyle", "bold");
    obj.label6:setVertTextAlign("center");
    obj.label6:setName("label6");

    obj.button2 = GUI.fromHandle(_obj_newObject("button"));
    obj.button2:setParent(obj.layout2);
    obj.button2:setAlign("right");
    obj.button2:setWidth(52);
    obj.button2:setHeight(20);
    obj.button2:setText("Limpar");
    obj.button2:setFontSize(10);
    obj.button2:setMargins({left=4});
    obj.button2:setHint("Apaga nomes, cores e URLs deste slot");
    obj.button2:setName("button2");

    obj.button3 = GUI.fromHandle(_obj_newObject("button"));
    obj.button3:setParent(obj.layout2);
    obj.button3:setAlign("right");
    obj.button3:setWidth(52);
    obj.button3:setHeight(20);
    obj.button3:setText("Girar");
    obj.button3:setFontSize(10);
    obj.button3:setMargins({left=4});
    obj.button3:setHint("Gira as camadas: a da frente vai para trás, e Meio e Atrás sobem");
    obj.button3:setName("button3");

    obj.checkBox5 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.checkBox5:setParent(obj.layout2);
    obj.checkBox5:setAlign("client");
    obj.checkBox5:setField("slot_left_visible");
    obj.checkBox5:setText("Visível");
    obj.checkBox5:setHint("Mostra este slot na cena");
    obj.checkBox5:setMargins({left=4});
    obj.checkBox5:setName("checkBox5");

    obj.layout3 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout3:setParent(obj.slotConfigLeft);
    obj.layout3:setAlign("top");
    obj.layout3:setHeight(36);
    obj.layout3:setMargins({bottom=4});
    obj.layout3:setName("layout3");

    obj.label7 = GUI.fromHandle(_obj_newObject("label"));
    obj.label7:setParent(obj.layout3);
    obj.label7:setText("Frente");
    obj.label7:setAlign("left");
    obj.label7:setWidth(44);
    obj.label7:setFontSize(10);
    obj.label7:setFontColor("Gray");
    obj.label7:setVertTextAlign("center");
    obj.label7:setName("label7");

    obj.edit2 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit2:setParent(obj.layout3);
    obj.edit2:setAlign("left");
    obj.edit2:setWidth(100);
    obj.edit2:setField("slot_left_npc1");
    obj.edit2:setHint("Nome");
    obj.edit2:setMargins({left=4, right=4});
    obj.edit2:setName("edit2");

    obj.colorComboBox1 = GUI.fromHandle(_obj_newObject("colorComboBox"));
    obj.colorComboBox1:setParent(obj.layout3);
    obj.colorComboBox1:setAlign("left");
    obj.colorComboBox1:setWidth(52);
    obj.colorComboBox1:setField("slot_left_color1");
    obj.colorComboBox1:setUseAlpha(false);
    obj.colorComboBox1:setHint("Cor do nome no diálogo");
    obj.colorComboBox1:setMargins({right=4});
    obj.colorComboBox1:setName("colorComboBox1");

    obj.edit3 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit3:setParent(obj.layout3);
    obj.edit3:setAlign("client");
    obj.edit3:setField("slot_left_url1");
    obj.edit3:setHint("URL");
    obj.edit3:setMargins({right=4});
    obj.edit3:setName("edit3");

    obj.layout4 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout4:setParent(obj.layout3);
    obj.layout4:setAlign("right");
    obj.layout4:setWidth(36);
    obj.layout4:setHeight(36);
    obj.layout4:setMargins({right=4});
    obj.layout4:setName("layout4");

    obj.imgPreview_left_1 = GUI.fromHandle(_obj_newObject("image"));
    obj.imgPreview_left_1:setParent(obj.layout4);
    obj.imgPreview_left_1:setName("imgPreview_left_1");
    obj.imgPreview_left_1:setAlign("client");
    obj.imgPreview_left_1:setStyle("proportional");
    obj.imgPreview_left_1:setSRC("");

    obj.labPreviewErr_left_1 = GUI.fromHandle(_obj_newObject("label"));
    obj.labPreviewErr_left_1:setParent(obj.layout4);
    obj.labPreviewErr_left_1:setName("labPreviewErr_left_1");
    obj.labPreviewErr_left_1:setAlign("client");
    obj.labPreviewErr_left_1:setText("!");
    obj.labPreviewErr_left_1:setFontSize(18);
    lfm_setPropAsString(obj.labPreviewErr_left_1, "fontStyle", "bold");
    obj.labPreviewErr_left_1:setFontColor("#ff5555");
    obj.labPreviewErr_left_1:setHorzTextAlign("center");
    obj.labPreviewErr_left_1:setVertTextAlign("center");
    obj.labPreviewErr_left_1:setVisible(false);
    obj.labPreviewErr_left_1:setHint("A imagem não carregou. Confira a URL.");

    obj.button4 = GUI.fromHandle(_obj_newObject("button"));
    obj.button4:setParent(obj.layout3);
    obj.button4:setAlign("right");
    obj.button4:setWidth(28);
    obj.button4:setHeight(36);
    obj.button4:setText("★");
    obj.button4:setHint("Definir esta camada como a da frente (foco)");
    obj.button4:setName("button4");

    obj.layout5 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout5:setParent(obj.slotConfigLeft);
    obj.layout5:setAlign("top");
    obj.layout5:setHeight(36);
    obj.layout5:setMargins({bottom=4});
    obj.layout5:setName("layout5");

    obj.label8 = GUI.fromHandle(_obj_newObject("label"));
    obj.label8:setParent(obj.layout5);
    obj.label8:setText("Meio");
    obj.label8:setAlign("left");
    obj.label8:setWidth(44);
    obj.label8:setFontSize(10);
    obj.label8:setFontColor("Gray");
    obj.label8:setVertTextAlign("center");
    obj.label8:setName("label8");

    obj.edit4 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit4:setParent(obj.layout5);
    obj.edit4:setAlign("left");
    obj.edit4:setWidth(100);
    obj.edit4:setField("slot_left_npc2");
    obj.edit4:setHint("Nome");
    obj.edit4:setMargins({left=4, right=4});
    obj.edit4:setName("edit4");

    obj.colorComboBox2 = GUI.fromHandle(_obj_newObject("colorComboBox"));
    obj.colorComboBox2:setParent(obj.layout5);
    obj.colorComboBox2:setAlign("left");
    obj.colorComboBox2:setWidth(52);
    obj.colorComboBox2:setField("slot_left_color2");
    obj.colorComboBox2:setUseAlpha(false);
    obj.colorComboBox2:setHint("Cor do nome no diálogo");
    obj.colorComboBox2:setMargins({right=4});
    obj.colorComboBox2:setName("colorComboBox2");

    obj.edit5 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit5:setParent(obj.layout5);
    obj.edit5:setAlign("client");
    obj.edit5:setField("slot_left_url2");
    obj.edit5:setHint("URL");
    obj.edit5:setMargins({right=4});
    obj.edit5:setName("edit5");

    obj.layout6 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout6:setParent(obj.layout5);
    obj.layout6:setAlign("right");
    obj.layout6:setWidth(36);
    obj.layout6:setHeight(36);
    obj.layout6:setMargins({right=4});
    obj.layout6:setName("layout6");

    obj.imgPreview_left_2 = GUI.fromHandle(_obj_newObject("image"));
    obj.imgPreview_left_2:setParent(obj.layout6);
    obj.imgPreview_left_2:setName("imgPreview_left_2");
    obj.imgPreview_left_2:setAlign("client");
    obj.imgPreview_left_2:setStyle("proportional");
    obj.imgPreview_left_2:setSRC("");

    obj.labPreviewErr_left_2 = GUI.fromHandle(_obj_newObject("label"));
    obj.labPreviewErr_left_2:setParent(obj.layout6);
    obj.labPreviewErr_left_2:setName("labPreviewErr_left_2");
    obj.labPreviewErr_left_2:setAlign("client");
    obj.labPreviewErr_left_2:setText("!");
    obj.labPreviewErr_left_2:setFontSize(18);
    lfm_setPropAsString(obj.labPreviewErr_left_2, "fontStyle", "bold");
    obj.labPreviewErr_left_2:setFontColor("#ff5555");
    obj.labPreviewErr_left_2:setHorzTextAlign("center");
    obj.labPreviewErr_left_2:setVertTextAlign("center");
    obj.labPreviewErr_left_2:setVisible(false);
    obj.labPreviewErr_left_2:setHint("A imagem não carregou. Confira a URL.");

    obj.button5 = GUI.fromHandle(_obj_newObject("button"));
    obj.button5:setParent(obj.layout5);
    obj.button5:setAlign("right");
    obj.button5:setWidth(28);
    obj.button5:setHeight(36);
    obj.button5:setText("★");
    obj.button5:setHint("Definir esta camada como a da frente (foco)");
    obj.button5:setName("button5");

    obj.layout7 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout7:setParent(obj.slotConfigLeft);
    obj.layout7:setAlign("top");
    obj.layout7:setHeight(36);
    obj.layout7:setMargins({bottom=12});
    obj.layout7:setName("layout7");

    obj.label9 = GUI.fromHandle(_obj_newObject("label"));
    obj.label9:setParent(obj.layout7);
    obj.label9:setText("Atrás");
    obj.label9:setAlign("left");
    obj.label9:setWidth(44);
    obj.label9:setFontSize(10);
    obj.label9:setFontColor("Gray");
    obj.label9:setVertTextAlign("center");
    obj.label9:setName("label9");

    obj.edit6 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit6:setParent(obj.layout7);
    obj.edit6:setAlign("left");
    obj.edit6:setWidth(100);
    obj.edit6:setField("slot_left_npc3");
    obj.edit6:setHint("Nome");
    obj.edit6:setMargins({left=4, right=4});
    obj.edit6:setName("edit6");

    obj.colorComboBox3 = GUI.fromHandle(_obj_newObject("colorComboBox"));
    obj.colorComboBox3:setParent(obj.layout7);
    obj.colorComboBox3:setAlign("left");
    obj.colorComboBox3:setWidth(52);
    obj.colorComboBox3:setField("slot_left_color3");
    obj.colorComboBox3:setUseAlpha(false);
    obj.colorComboBox3:setHint("Cor do nome no diálogo");
    obj.colorComboBox3:setMargins({right=4});
    obj.colorComboBox3:setName("colorComboBox3");

    obj.edit7 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit7:setParent(obj.layout7);
    obj.edit7:setAlign("client");
    obj.edit7:setField("slot_left_url3");
    obj.edit7:setHint("URL");
    obj.edit7:setMargins({right=4});
    obj.edit7:setName("edit7");

    obj.layout8 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout8:setParent(obj.layout7);
    obj.layout8:setAlign("right");
    obj.layout8:setWidth(36);
    obj.layout8:setHeight(36);
    obj.layout8:setMargins({right=4});
    obj.layout8:setName("layout8");

    obj.imgPreview_left_3 = GUI.fromHandle(_obj_newObject("image"));
    obj.imgPreview_left_3:setParent(obj.layout8);
    obj.imgPreview_left_3:setName("imgPreview_left_3");
    obj.imgPreview_left_3:setAlign("client");
    obj.imgPreview_left_3:setStyle("proportional");
    obj.imgPreview_left_3:setSRC("");

    obj.labPreviewErr_left_3 = GUI.fromHandle(_obj_newObject("label"));
    obj.labPreviewErr_left_3:setParent(obj.layout8);
    obj.labPreviewErr_left_3:setName("labPreviewErr_left_3");
    obj.labPreviewErr_left_3:setAlign("client");
    obj.labPreviewErr_left_3:setText("!");
    obj.labPreviewErr_left_3:setFontSize(18);
    lfm_setPropAsString(obj.labPreviewErr_left_3, "fontStyle", "bold");
    obj.labPreviewErr_left_3:setFontColor("#ff5555");
    obj.labPreviewErr_left_3:setHorzTextAlign("center");
    obj.labPreviewErr_left_3:setVertTextAlign("center");
    obj.labPreviewErr_left_3:setVisible(false);
    obj.labPreviewErr_left_3:setHint("A imagem não carregou. Confira a URL.");

    obj.button6 = GUI.fromHandle(_obj_newObject("button"));
    obj.button6:setParent(obj.layout7);
    obj.button6:setAlign("right");
    obj.button6:setWidth(28);
    obj.button6:setHeight(36);
    obj.button6:setText("★");
    obj.button6:setHint("Definir esta camada como a da frente (foco)");
    obj.button6:setName("button6");

    obj.slotConfigCenter = GUI.fromHandle(_obj_newObject("layout"));
    obj.slotConfigCenter:setParent(obj.slotConfigs);
    obj.slotConfigCenter:setName("slotConfigCenter");
    obj.slotConfigCenter:setAlign("left");
    obj.slotConfigCenter:setWidth(400);
    obj.slotConfigCenter:setHeight(152);
    obj.slotConfigCenter:setMargins({right=8});

    obj.layout9 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout9:setParent(obj.slotConfigCenter);
    obj.layout9:setAlign("top");
    obj.layout9:setHeight(20);
    obj.layout9:setMargins({bottom=4});
    obj.layout9:setName("layout9");

    obj.label10 = GUI.fromHandle(_obj_newObject("label"));
    obj.label10:setParent(obj.layout9);
    obj.label10:setText("Centro");
    obj.label10:setAlign("left");
    obj.label10:setWidth(70);
    obj.label10:setFontSize(11);
    lfm_setPropAsString(obj.label10, "fontStyle", "bold");
    obj.label10:setVertTextAlign("center");
    obj.label10:setName("label10");

    obj.button7 = GUI.fromHandle(_obj_newObject("button"));
    obj.button7:setParent(obj.layout9);
    obj.button7:setAlign("right");
    obj.button7:setWidth(52);
    obj.button7:setHeight(20);
    obj.button7:setText("Limpar");
    obj.button7:setFontSize(10);
    obj.button7:setMargins({left=4});
    obj.button7:setHint("Apaga nomes, cores e URLs deste slot");
    obj.button7:setName("button7");

    obj.button8 = GUI.fromHandle(_obj_newObject("button"));
    obj.button8:setParent(obj.layout9);
    obj.button8:setAlign("right");
    obj.button8:setWidth(52);
    obj.button8:setHeight(20);
    obj.button8:setText("Girar");
    obj.button8:setFontSize(10);
    obj.button8:setMargins({left=4});
    obj.button8:setHint("Gira as camadas: a da frente vai para trás, e Meio e Atrás sobem");
    obj.button8:setName("button8");

    obj.checkBox6 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.checkBox6:setParent(obj.layout9);
    obj.checkBox6:setAlign("client");
    obj.checkBox6:setField("slot_center_visible");
    obj.checkBox6:setText("Visível");
    obj.checkBox6:setHint("Mostra este slot na cena");
    obj.checkBox6:setMargins({left=4});
    obj.checkBox6:setName("checkBox6");

    obj.layout10 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout10:setParent(obj.slotConfigCenter);
    obj.layout10:setAlign("top");
    obj.layout10:setHeight(36);
    obj.layout10:setMargins({bottom=4});
    obj.layout10:setName("layout10");

    obj.label11 = GUI.fromHandle(_obj_newObject("label"));
    obj.label11:setParent(obj.layout10);
    obj.label11:setText("Frente");
    obj.label11:setAlign("left");
    obj.label11:setWidth(44);
    obj.label11:setFontSize(10);
    obj.label11:setFontColor("Gray");
    obj.label11:setVertTextAlign("center");
    obj.label11:setName("label11");

    obj.edit8 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit8:setParent(obj.layout10);
    obj.edit8:setAlign("left");
    obj.edit8:setWidth(100);
    obj.edit8:setField("slot_center_npc1");
    obj.edit8:setHint("Nome");
    obj.edit8:setMargins({left=4, right=4});
    obj.edit8:setName("edit8");

    obj.colorComboBox4 = GUI.fromHandle(_obj_newObject("colorComboBox"));
    obj.colorComboBox4:setParent(obj.layout10);
    obj.colorComboBox4:setAlign("left");
    obj.colorComboBox4:setWidth(52);
    obj.colorComboBox4:setField("slot_center_color1");
    obj.colorComboBox4:setUseAlpha(false);
    obj.colorComboBox4:setHint("Cor do nome no diálogo");
    obj.colorComboBox4:setMargins({right=4});
    obj.colorComboBox4:setName("colorComboBox4");

    obj.edit9 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit9:setParent(obj.layout10);
    obj.edit9:setAlign("client");
    obj.edit9:setField("slot_center_url1");
    obj.edit9:setHint("URL");
    obj.edit9:setMargins({right=4});
    obj.edit9:setName("edit9");

    obj.layout11 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout11:setParent(obj.layout10);
    obj.layout11:setAlign("right");
    obj.layout11:setWidth(36);
    obj.layout11:setHeight(36);
    obj.layout11:setMargins({right=4});
    obj.layout11:setName("layout11");

    obj.imgPreview_center_1 = GUI.fromHandle(_obj_newObject("image"));
    obj.imgPreview_center_1:setParent(obj.layout11);
    obj.imgPreview_center_1:setName("imgPreview_center_1");
    obj.imgPreview_center_1:setAlign("client");
    obj.imgPreview_center_1:setStyle("proportional");
    obj.imgPreview_center_1:setSRC("");

    obj.labPreviewErr_center_1 = GUI.fromHandle(_obj_newObject("label"));
    obj.labPreviewErr_center_1:setParent(obj.layout11);
    obj.labPreviewErr_center_1:setName("labPreviewErr_center_1");
    obj.labPreviewErr_center_1:setAlign("client");
    obj.labPreviewErr_center_1:setText("!");
    obj.labPreviewErr_center_1:setFontSize(18);
    lfm_setPropAsString(obj.labPreviewErr_center_1, "fontStyle", "bold");
    obj.labPreviewErr_center_1:setFontColor("#ff5555");
    obj.labPreviewErr_center_1:setHorzTextAlign("center");
    obj.labPreviewErr_center_1:setVertTextAlign("center");
    obj.labPreviewErr_center_1:setVisible(false);
    obj.labPreviewErr_center_1:setHint("A imagem não carregou. Confira a URL.");

    obj.button9 = GUI.fromHandle(_obj_newObject("button"));
    obj.button9:setParent(obj.layout10);
    obj.button9:setAlign("right");
    obj.button9:setWidth(28);
    obj.button9:setHeight(36);
    obj.button9:setText("★");
    obj.button9:setHint("Definir esta camada como a da frente (foco)");
    obj.button9:setName("button9");

    obj.layout12 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout12:setParent(obj.slotConfigCenter);
    obj.layout12:setAlign("top");
    obj.layout12:setHeight(36);
    obj.layout12:setMargins({bottom=4});
    obj.layout12:setName("layout12");

    obj.label12 = GUI.fromHandle(_obj_newObject("label"));
    obj.label12:setParent(obj.layout12);
    obj.label12:setText("Meio");
    obj.label12:setAlign("left");
    obj.label12:setWidth(44);
    obj.label12:setFontSize(10);
    obj.label12:setFontColor("Gray");
    obj.label12:setVertTextAlign("center");
    obj.label12:setName("label12");

    obj.edit10 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit10:setParent(obj.layout12);
    obj.edit10:setAlign("left");
    obj.edit10:setWidth(100);
    obj.edit10:setField("slot_center_npc2");
    obj.edit10:setHint("Nome");
    obj.edit10:setMargins({left=4, right=4});
    obj.edit10:setName("edit10");

    obj.colorComboBox5 = GUI.fromHandle(_obj_newObject("colorComboBox"));
    obj.colorComboBox5:setParent(obj.layout12);
    obj.colorComboBox5:setAlign("left");
    obj.colorComboBox5:setWidth(52);
    obj.colorComboBox5:setField("slot_center_color2");
    obj.colorComboBox5:setUseAlpha(false);
    obj.colorComboBox5:setHint("Cor do nome no diálogo");
    obj.colorComboBox5:setMargins({right=4});
    obj.colorComboBox5:setName("colorComboBox5");

    obj.edit11 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit11:setParent(obj.layout12);
    obj.edit11:setAlign("client");
    obj.edit11:setField("slot_center_url2");
    obj.edit11:setHint("URL");
    obj.edit11:setMargins({right=4});
    obj.edit11:setName("edit11");

    obj.layout13 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout13:setParent(obj.layout12);
    obj.layout13:setAlign("right");
    obj.layout13:setWidth(36);
    obj.layout13:setHeight(36);
    obj.layout13:setMargins({right=4});
    obj.layout13:setName("layout13");

    obj.imgPreview_center_2 = GUI.fromHandle(_obj_newObject("image"));
    obj.imgPreview_center_2:setParent(obj.layout13);
    obj.imgPreview_center_2:setName("imgPreview_center_2");
    obj.imgPreview_center_2:setAlign("client");
    obj.imgPreview_center_2:setStyle("proportional");
    obj.imgPreview_center_2:setSRC("");

    obj.labPreviewErr_center_2 = GUI.fromHandle(_obj_newObject("label"));
    obj.labPreviewErr_center_2:setParent(obj.layout13);
    obj.labPreviewErr_center_2:setName("labPreviewErr_center_2");
    obj.labPreviewErr_center_2:setAlign("client");
    obj.labPreviewErr_center_2:setText("!");
    obj.labPreviewErr_center_2:setFontSize(18);
    lfm_setPropAsString(obj.labPreviewErr_center_2, "fontStyle", "bold");
    obj.labPreviewErr_center_2:setFontColor("#ff5555");
    obj.labPreviewErr_center_2:setHorzTextAlign("center");
    obj.labPreviewErr_center_2:setVertTextAlign("center");
    obj.labPreviewErr_center_2:setVisible(false);
    obj.labPreviewErr_center_2:setHint("A imagem não carregou. Confira a URL.");

    obj.button10 = GUI.fromHandle(_obj_newObject("button"));
    obj.button10:setParent(obj.layout12);
    obj.button10:setAlign("right");
    obj.button10:setWidth(28);
    obj.button10:setHeight(36);
    obj.button10:setText("★");
    obj.button10:setHint("Definir esta camada como a da frente (foco)");
    obj.button10:setName("button10");

    obj.layout14 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout14:setParent(obj.slotConfigCenter);
    obj.layout14:setAlign("top");
    obj.layout14:setHeight(36);
    obj.layout14:setMargins({bottom=12});
    obj.layout14:setName("layout14");

    obj.label13 = GUI.fromHandle(_obj_newObject("label"));
    obj.label13:setParent(obj.layout14);
    obj.label13:setText("Atrás");
    obj.label13:setAlign("left");
    obj.label13:setWidth(44);
    obj.label13:setFontSize(10);
    obj.label13:setFontColor("Gray");
    obj.label13:setVertTextAlign("center");
    obj.label13:setName("label13");

    obj.edit12 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit12:setParent(obj.layout14);
    obj.edit12:setAlign("left");
    obj.edit12:setWidth(100);
    obj.edit12:setField("slot_center_npc3");
    obj.edit12:setHint("Nome");
    obj.edit12:setMargins({left=4, right=4});
    obj.edit12:setName("edit12");

    obj.colorComboBox6 = GUI.fromHandle(_obj_newObject("colorComboBox"));
    obj.colorComboBox6:setParent(obj.layout14);
    obj.colorComboBox6:setAlign("left");
    obj.colorComboBox6:setWidth(52);
    obj.colorComboBox6:setField("slot_center_color3");
    obj.colorComboBox6:setUseAlpha(false);
    obj.colorComboBox6:setHint("Cor do nome no diálogo");
    obj.colorComboBox6:setMargins({right=4});
    obj.colorComboBox6:setName("colorComboBox6");

    obj.edit13 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit13:setParent(obj.layout14);
    obj.edit13:setAlign("client");
    obj.edit13:setField("slot_center_url3");
    obj.edit13:setHint("URL");
    obj.edit13:setMargins({right=4});
    obj.edit13:setName("edit13");

    obj.layout15 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout15:setParent(obj.layout14);
    obj.layout15:setAlign("right");
    obj.layout15:setWidth(36);
    obj.layout15:setHeight(36);
    obj.layout15:setMargins({right=4});
    obj.layout15:setName("layout15");

    obj.imgPreview_center_3 = GUI.fromHandle(_obj_newObject("image"));
    obj.imgPreview_center_3:setParent(obj.layout15);
    obj.imgPreview_center_3:setName("imgPreview_center_3");
    obj.imgPreview_center_3:setAlign("client");
    obj.imgPreview_center_3:setStyle("proportional");
    obj.imgPreview_center_3:setSRC("");

    obj.labPreviewErr_center_3 = GUI.fromHandle(_obj_newObject("label"));
    obj.labPreviewErr_center_3:setParent(obj.layout15);
    obj.labPreviewErr_center_3:setName("labPreviewErr_center_3");
    obj.labPreviewErr_center_3:setAlign("client");
    obj.labPreviewErr_center_3:setText("!");
    obj.labPreviewErr_center_3:setFontSize(18);
    lfm_setPropAsString(obj.labPreviewErr_center_3, "fontStyle", "bold");
    obj.labPreviewErr_center_3:setFontColor("#ff5555");
    obj.labPreviewErr_center_3:setHorzTextAlign("center");
    obj.labPreviewErr_center_3:setVertTextAlign("center");
    obj.labPreviewErr_center_3:setVisible(false);
    obj.labPreviewErr_center_3:setHint("A imagem não carregou. Confira a URL.");

    obj.button11 = GUI.fromHandle(_obj_newObject("button"));
    obj.button11:setParent(obj.layout14);
    obj.button11:setAlign("right");
    obj.button11:setWidth(28);
    obj.button11:setHeight(36);
    obj.button11:setText("★");
    obj.button11:setHint("Definir esta camada como a da frente (foco)");
    obj.button11:setName("button11");

    obj.slotConfigRight = GUI.fromHandle(_obj_newObject("layout"));
    obj.slotConfigRight:setParent(obj.slotConfigs);
    obj.slotConfigRight:setName("slotConfigRight");
    obj.slotConfigRight:setAlign("client");
    obj.slotConfigRight:setWidth(400);
    obj.slotConfigRight:setHeight(152);
    obj.slotConfigRight:setMargins({right=0});

    obj.layout16 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout16:setParent(obj.slotConfigRight);
    obj.layout16:setAlign("top");
    obj.layout16:setHeight(20);
    obj.layout16:setMargins({bottom=4});
    obj.layout16:setName("layout16");

    obj.label14 = GUI.fromHandle(_obj_newObject("label"));
    obj.label14:setParent(obj.layout16);
    obj.label14:setText("Direita");
    obj.label14:setAlign("left");
    obj.label14:setWidth(70);
    obj.label14:setFontSize(11);
    lfm_setPropAsString(obj.label14, "fontStyle", "bold");
    obj.label14:setVertTextAlign("center");
    obj.label14:setName("label14");

    obj.button12 = GUI.fromHandle(_obj_newObject("button"));
    obj.button12:setParent(obj.layout16);
    obj.button12:setAlign("right");
    obj.button12:setWidth(52);
    obj.button12:setHeight(20);
    obj.button12:setText("Limpar");
    obj.button12:setFontSize(10);
    obj.button12:setMargins({left=4});
    obj.button12:setHint("Apaga nomes, cores e URLs deste slot");
    obj.button12:setName("button12");

    obj.button13 = GUI.fromHandle(_obj_newObject("button"));
    obj.button13:setParent(obj.layout16);
    obj.button13:setAlign("right");
    obj.button13:setWidth(52);
    obj.button13:setHeight(20);
    obj.button13:setText("Girar");
    obj.button13:setFontSize(10);
    obj.button13:setMargins({left=4});
    obj.button13:setHint("Gira as camadas: a da frente vai para trás, e Meio e Atrás sobem");
    obj.button13:setName("button13");

    obj.checkBox7 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.checkBox7:setParent(obj.layout16);
    obj.checkBox7:setAlign("client");
    obj.checkBox7:setField("slot_right_visible");
    obj.checkBox7:setText("Visível");
    obj.checkBox7:setHint("Mostra este slot na cena");
    obj.checkBox7:setMargins({left=4});
    obj.checkBox7:setName("checkBox7");

    obj.layout17 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout17:setParent(obj.slotConfigRight);
    obj.layout17:setAlign("top");
    obj.layout17:setHeight(36);
    obj.layout17:setMargins({bottom=4});
    obj.layout17:setName("layout17");

    obj.label15 = GUI.fromHandle(_obj_newObject("label"));
    obj.label15:setParent(obj.layout17);
    obj.label15:setText("Frente");
    obj.label15:setAlign("left");
    obj.label15:setWidth(44);
    obj.label15:setFontSize(10);
    obj.label15:setFontColor("Gray");
    obj.label15:setVertTextAlign("center");
    obj.label15:setName("label15");

    obj.edit14 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit14:setParent(obj.layout17);
    obj.edit14:setAlign("left");
    obj.edit14:setWidth(100);
    obj.edit14:setField("slot_right_npc1");
    obj.edit14:setHint("Nome");
    obj.edit14:setMargins({left=4, right=4});
    obj.edit14:setName("edit14");

    obj.colorComboBox7 = GUI.fromHandle(_obj_newObject("colorComboBox"));
    obj.colorComboBox7:setParent(obj.layout17);
    obj.colorComboBox7:setAlign("left");
    obj.colorComboBox7:setWidth(52);
    obj.colorComboBox7:setField("slot_right_color1");
    obj.colorComboBox7:setUseAlpha(false);
    obj.colorComboBox7:setHint("Cor do nome no diálogo");
    obj.colorComboBox7:setMargins({right=4});
    obj.colorComboBox7:setName("colorComboBox7");

    obj.edit15 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit15:setParent(obj.layout17);
    obj.edit15:setAlign("client");
    obj.edit15:setField("slot_right_url1");
    obj.edit15:setHint("URL");
    obj.edit15:setMargins({right=4});
    obj.edit15:setName("edit15");

    obj.layout18 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout18:setParent(obj.layout17);
    obj.layout18:setAlign("right");
    obj.layout18:setWidth(36);
    obj.layout18:setHeight(36);
    obj.layout18:setMargins({right=4});
    obj.layout18:setName("layout18");

    obj.imgPreview_right_1 = GUI.fromHandle(_obj_newObject("image"));
    obj.imgPreview_right_1:setParent(obj.layout18);
    obj.imgPreview_right_1:setName("imgPreview_right_1");
    obj.imgPreview_right_1:setAlign("client");
    obj.imgPreview_right_1:setStyle("proportional");
    obj.imgPreview_right_1:setSRC("");

    obj.labPreviewErr_right_1 = GUI.fromHandle(_obj_newObject("label"));
    obj.labPreviewErr_right_1:setParent(obj.layout18);
    obj.labPreviewErr_right_1:setName("labPreviewErr_right_1");
    obj.labPreviewErr_right_1:setAlign("client");
    obj.labPreviewErr_right_1:setText("!");
    obj.labPreviewErr_right_1:setFontSize(18);
    lfm_setPropAsString(obj.labPreviewErr_right_1, "fontStyle", "bold");
    obj.labPreviewErr_right_1:setFontColor("#ff5555");
    obj.labPreviewErr_right_1:setHorzTextAlign("center");
    obj.labPreviewErr_right_1:setVertTextAlign("center");
    obj.labPreviewErr_right_1:setVisible(false);
    obj.labPreviewErr_right_1:setHint("A imagem não carregou. Confira a URL.");

    obj.button14 = GUI.fromHandle(_obj_newObject("button"));
    obj.button14:setParent(obj.layout17);
    obj.button14:setAlign("right");
    obj.button14:setWidth(28);
    obj.button14:setHeight(36);
    obj.button14:setText("★");
    obj.button14:setHint("Definir esta camada como a da frente (foco)");
    obj.button14:setName("button14");

    obj.layout19 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout19:setParent(obj.slotConfigRight);
    obj.layout19:setAlign("top");
    obj.layout19:setHeight(36);
    obj.layout19:setMargins({bottom=4});
    obj.layout19:setName("layout19");

    obj.label16 = GUI.fromHandle(_obj_newObject("label"));
    obj.label16:setParent(obj.layout19);
    obj.label16:setText("Meio");
    obj.label16:setAlign("left");
    obj.label16:setWidth(44);
    obj.label16:setFontSize(10);
    obj.label16:setFontColor("Gray");
    obj.label16:setVertTextAlign("center");
    obj.label16:setName("label16");

    obj.edit16 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit16:setParent(obj.layout19);
    obj.edit16:setAlign("left");
    obj.edit16:setWidth(100);
    obj.edit16:setField("slot_right_npc2");
    obj.edit16:setHint("Nome");
    obj.edit16:setMargins({left=4, right=4});
    obj.edit16:setName("edit16");

    obj.colorComboBox8 = GUI.fromHandle(_obj_newObject("colorComboBox"));
    obj.colorComboBox8:setParent(obj.layout19);
    obj.colorComboBox8:setAlign("left");
    obj.colorComboBox8:setWidth(52);
    obj.colorComboBox8:setField("slot_right_color2");
    obj.colorComboBox8:setUseAlpha(false);
    obj.colorComboBox8:setHint("Cor do nome no diálogo");
    obj.colorComboBox8:setMargins({right=4});
    obj.colorComboBox8:setName("colorComboBox8");

    obj.edit17 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit17:setParent(obj.layout19);
    obj.edit17:setAlign("client");
    obj.edit17:setField("slot_right_url2");
    obj.edit17:setHint("URL");
    obj.edit17:setMargins({right=4});
    obj.edit17:setName("edit17");

    obj.layout20 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout20:setParent(obj.layout19);
    obj.layout20:setAlign("right");
    obj.layout20:setWidth(36);
    obj.layout20:setHeight(36);
    obj.layout20:setMargins({right=4});
    obj.layout20:setName("layout20");

    obj.imgPreview_right_2 = GUI.fromHandle(_obj_newObject("image"));
    obj.imgPreview_right_2:setParent(obj.layout20);
    obj.imgPreview_right_2:setName("imgPreview_right_2");
    obj.imgPreview_right_2:setAlign("client");
    obj.imgPreview_right_2:setStyle("proportional");
    obj.imgPreview_right_2:setSRC("");

    obj.labPreviewErr_right_2 = GUI.fromHandle(_obj_newObject("label"));
    obj.labPreviewErr_right_2:setParent(obj.layout20);
    obj.labPreviewErr_right_2:setName("labPreviewErr_right_2");
    obj.labPreviewErr_right_2:setAlign("client");
    obj.labPreviewErr_right_2:setText("!");
    obj.labPreviewErr_right_2:setFontSize(18);
    lfm_setPropAsString(obj.labPreviewErr_right_2, "fontStyle", "bold");
    obj.labPreviewErr_right_2:setFontColor("#ff5555");
    obj.labPreviewErr_right_2:setHorzTextAlign("center");
    obj.labPreviewErr_right_2:setVertTextAlign("center");
    obj.labPreviewErr_right_2:setVisible(false);
    obj.labPreviewErr_right_2:setHint("A imagem não carregou. Confira a URL.");

    obj.button15 = GUI.fromHandle(_obj_newObject("button"));
    obj.button15:setParent(obj.layout19);
    obj.button15:setAlign("right");
    obj.button15:setWidth(28);
    obj.button15:setHeight(36);
    obj.button15:setText("★");
    obj.button15:setHint("Definir esta camada como a da frente (foco)");
    obj.button15:setName("button15");

    obj.layout21 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout21:setParent(obj.slotConfigRight);
    obj.layout21:setAlign("top");
    obj.layout21:setHeight(36);
    obj.layout21:setMargins({bottom=12});
    obj.layout21:setName("layout21");

    obj.label17 = GUI.fromHandle(_obj_newObject("label"));
    obj.label17:setParent(obj.layout21);
    obj.label17:setText("Atrás");
    obj.label17:setAlign("left");
    obj.label17:setWidth(44);
    obj.label17:setFontSize(10);
    obj.label17:setFontColor("Gray");
    obj.label17:setVertTextAlign("center");
    obj.label17:setName("label17");

    obj.edit18 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit18:setParent(obj.layout21);
    obj.edit18:setAlign("left");
    obj.edit18:setWidth(100);
    obj.edit18:setField("slot_right_npc3");
    obj.edit18:setHint("Nome");
    obj.edit18:setMargins({left=4, right=4});
    obj.edit18:setName("edit18");

    obj.colorComboBox9 = GUI.fromHandle(_obj_newObject("colorComboBox"));
    obj.colorComboBox9:setParent(obj.layout21);
    obj.colorComboBox9:setAlign("left");
    obj.colorComboBox9:setWidth(52);
    obj.colorComboBox9:setField("slot_right_color3");
    obj.colorComboBox9:setUseAlpha(false);
    obj.colorComboBox9:setHint("Cor do nome no diálogo");
    obj.colorComboBox9:setMargins({right=4});
    obj.colorComboBox9:setName("colorComboBox9");

    obj.edit19 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit19:setParent(obj.layout21);
    obj.edit19:setAlign("client");
    obj.edit19:setField("slot_right_url3");
    obj.edit19:setHint("URL");
    obj.edit19:setMargins({right=4});
    obj.edit19:setName("edit19");

    obj.layout22 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout22:setParent(obj.layout21);
    obj.layout22:setAlign("right");
    obj.layout22:setWidth(36);
    obj.layout22:setHeight(36);
    obj.layout22:setMargins({right=4});
    obj.layout22:setName("layout22");

    obj.imgPreview_right_3 = GUI.fromHandle(_obj_newObject("image"));
    obj.imgPreview_right_3:setParent(obj.layout22);
    obj.imgPreview_right_3:setName("imgPreview_right_3");
    obj.imgPreview_right_3:setAlign("client");
    obj.imgPreview_right_3:setStyle("proportional");
    obj.imgPreview_right_3:setSRC("");

    obj.labPreviewErr_right_3 = GUI.fromHandle(_obj_newObject("label"));
    obj.labPreviewErr_right_3:setParent(obj.layout22);
    obj.labPreviewErr_right_3:setName("labPreviewErr_right_3");
    obj.labPreviewErr_right_3:setAlign("client");
    obj.labPreviewErr_right_3:setText("!");
    obj.labPreviewErr_right_3:setFontSize(18);
    lfm_setPropAsString(obj.labPreviewErr_right_3, "fontStyle", "bold");
    obj.labPreviewErr_right_3:setFontColor("#ff5555");
    obj.labPreviewErr_right_3:setHorzTextAlign("center");
    obj.labPreviewErr_right_3:setVertTextAlign("center");
    obj.labPreviewErr_right_3:setVisible(false);
    obj.labPreviewErr_right_3:setHint("A imagem não carregou. Confira a URL.");

    obj.button16 = GUI.fromHandle(_obj_newObject("button"));
    obj.button16:setParent(obj.layout21);
    obj.button16:setAlign("right");
    obj.button16:setWidth(28);
    obj.button16:setHeight(36);
    obj.button16:setText("★");
    obj.button16:setHint("Definir esta camada como a da frente (foco)");
    obj.button16:setName("button16");

    obj.label18 = GUI.fromHandle(_obj_newObject("label"));
    obj.label18:setParent(obj.configContent);
    obj.label18:setText("Personagens Extras");
    obj.label18:setAlign("top");
    obj.label18:setHeight(20);
    lfm_setPropAsString(obj.label18, "fontStyle", "bold");
    obj.label18:setFontSize(13);
    obj.label18:setName("label18");

    obj.label19 = GUI.fromHandle(_obj_newObject("label"));
    obj.label19:setParent(obj.configContent);
    obj.label19:setText("Quando falam, aparecem no centro temporariamente.");
    obj.label19:setAlign("top");
    obj.label19:setHeight(18);
    obj.label19:setFontSize(11);
    obj.label19:setFontColor("Gray");
    obj.label19:setMargins({bottom=8});
    obj.label19:setName("label19");

    obj.layout23 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout23:setParent(obj.configContent);
    obj.layout23:setAlign("top");
    obj.layout23:setHeight(18);
    obj.layout23:setMargins({bottom=4});
    obj.layout23:setName("layout23");

    obj.label20 = GUI.fromHandle(_obj_newObject("label"));
    obj.label20:setParent(obj.layout23);
    obj.label20:setText("Nome");
    obj.label20:setAlign("left");
    obj.label20:setWidth(100);
    obj.label20:setFontSize(10);
    obj.label20:setFontColor("Gray");
    obj.label20:setName("label20");

    obj.label21 = GUI.fromHandle(_obj_newObject("label"));
    obj.label21:setParent(obj.layout23);
    obj.label21:setText("Cor");
    obj.label21:setAlign("left");
    obj.label21:setWidth(52);
    obj.label21:setFontSize(10);
    obj.label21:setFontColor("Gray");
    obj.label21:setMargins({left=4});
    obj.label21:setName("label21");

    obj.label22 = GUI.fromHandle(_obj_newObject("label"));
    obj.label22:setParent(obj.layout23);
    obj.label22:setText("URL");
    obj.label22:setAlign("client");
    obj.label22:setFontSize(10);
    obj.label22:setFontColor("Gray");
    obj.label22:setMargins({left=4});
    obj.label22:setName("label22");

    obj.label23 = GUI.fromHandle(_obj_newObject("label"));
    obj.label23:setParent(obj.layout23);
    obj.label23:setText("Prev");
    obj.label23:setAlign("right");
    obj.label23:setWidth(36);
    obj.label23:setFontSize(10);
    obj.label23:setFontColor("Gray");
    obj.label23:setHorzTextAlign("center");
    obj.label23:setName("label23");

    obj.layout24 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout24:setParent(obj.configContent);
    obj.layout24:setAlign("top");
    obj.layout24:setHeight(36);
    obj.layout24:setMargins({bottom=6});
    obj.layout24:setName("layout24");

    obj.edit20 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit20:setParent(obj.layout24);
    obj.edit20:setAlign("left");
    obj.edit20:setWidth(100);
    obj.edit20:setField("extra_1_npc");
    obj.edit20:setHint("Extra 1");
    obj.edit20:setMargins({right=4});
    obj.edit20:setName("edit20");

    obj.colorComboBox10 = GUI.fromHandle(_obj_newObject("colorComboBox"));
    obj.colorComboBox10:setParent(obj.layout24);
    obj.colorComboBox10:setAlign("left");
    obj.colorComboBox10:setWidth(52);
    obj.colorComboBox10:setField("extra_1_color");
    obj.colorComboBox10:setUseAlpha(false);
    obj.colorComboBox10:setHint("Cor do nome no diálogo");
    obj.colorComboBox10:setMargins({right=4});
    obj.colorComboBox10:setName("colorComboBox10");

    obj.edit21 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit21:setParent(obj.layout24);
    obj.edit21:setAlign("client");
    obj.edit21:setField("extra_1_url");
    obj.edit21:setHint("URL");
    obj.edit21:setMargins({right=4});
    obj.edit21:setName("edit21");

    obj.layout25 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout25:setParent(obj.layout24);
    obj.layout25:setAlign("right");
    obj.layout25:setWidth(36);
    obj.layout25:setHeight(36);
    obj.layout25:setName("layout25");

    obj.imgPreviewExtra_1 = GUI.fromHandle(_obj_newObject("image"));
    obj.imgPreviewExtra_1:setParent(obj.layout25);
    obj.imgPreviewExtra_1:setName("imgPreviewExtra_1");
    obj.imgPreviewExtra_1:setAlign("client");
    obj.imgPreviewExtra_1:setStyle("proportional");
    obj.imgPreviewExtra_1:setSRC("");

    obj.labPreviewErrExtra_1 = GUI.fromHandle(_obj_newObject("label"));
    obj.labPreviewErrExtra_1:setParent(obj.layout25);
    obj.labPreviewErrExtra_1:setName("labPreviewErrExtra_1");
    obj.labPreviewErrExtra_1:setAlign("client");
    obj.labPreviewErrExtra_1:setText("!");
    obj.labPreviewErrExtra_1:setFontSize(18);
    lfm_setPropAsString(obj.labPreviewErrExtra_1, "fontStyle", "bold");
    obj.labPreviewErrExtra_1:setFontColor("#ff5555");
    obj.labPreviewErrExtra_1:setHorzTextAlign("center");
    obj.labPreviewErrExtra_1:setVertTextAlign("center");
    obj.labPreviewErrExtra_1:setVisible(false);
    obj.labPreviewErrExtra_1:setHint("A imagem não carregou. Confira a URL.");

    obj.layout26 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout26:setParent(obj.configContent);
    obj.layout26:setAlign("top");
    obj.layout26:setHeight(36);
    obj.layout26:setMargins({bottom=6});
    obj.layout26:setName("layout26");

    obj.edit22 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit22:setParent(obj.layout26);
    obj.edit22:setAlign("left");
    obj.edit22:setWidth(100);
    obj.edit22:setField("extra_2_npc");
    obj.edit22:setHint("Extra 2");
    obj.edit22:setMargins({right=4});
    obj.edit22:setName("edit22");

    obj.colorComboBox11 = GUI.fromHandle(_obj_newObject("colorComboBox"));
    obj.colorComboBox11:setParent(obj.layout26);
    obj.colorComboBox11:setAlign("left");
    obj.colorComboBox11:setWidth(52);
    obj.colorComboBox11:setField("extra_2_color");
    obj.colorComboBox11:setUseAlpha(false);
    obj.colorComboBox11:setHint("Cor do nome no diálogo");
    obj.colorComboBox11:setMargins({right=4});
    obj.colorComboBox11:setName("colorComboBox11");

    obj.edit23 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit23:setParent(obj.layout26);
    obj.edit23:setAlign("client");
    obj.edit23:setField("extra_2_url");
    obj.edit23:setHint("URL");
    obj.edit23:setMargins({right=4});
    obj.edit23:setName("edit23");

    obj.layout27 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout27:setParent(obj.layout26);
    obj.layout27:setAlign("right");
    obj.layout27:setWidth(36);
    obj.layout27:setHeight(36);
    obj.layout27:setName("layout27");

    obj.imgPreviewExtra_2 = GUI.fromHandle(_obj_newObject("image"));
    obj.imgPreviewExtra_2:setParent(obj.layout27);
    obj.imgPreviewExtra_2:setName("imgPreviewExtra_2");
    obj.imgPreviewExtra_2:setAlign("client");
    obj.imgPreviewExtra_2:setStyle("proportional");
    obj.imgPreviewExtra_2:setSRC("");

    obj.labPreviewErrExtra_2 = GUI.fromHandle(_obj_newObject("label"));
    obj.labPreviewErrExtra_2:setParent(obj.layout27);
    obj.labPreviewErrExtra_2:setName("labPreviewErrExtra_2");
    obj.labPreviewErrExtra_2:setAlign("client");
    obj.labPreviewErrExtra_2:setText("!");
    obj.labPreviewErrExtra_2:setFontSize(18);
    lfm_setPropAsString(obj.labPreviewErrExtra_2, "fontStyle", "bold");
    obj.labPreviewErrExtra_2:setFontColor("#ff5555");
    obj.labPreviewErrExtra_2:setHorzTextAlign("center");
    obj.labPreviewErrExtra_2:setVertTextAlign("center");
    obj.labPreviewErrExtra_2:setVisible(false);
    obj.labPreviewErrExtra_2:setHint("A imagem não carregou. Confira a URL.");

    obj.layout28 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout28:setParent(obj.configContent);
    obj.layout28:setAlign("top");
    obj.layout28:setHeight(36);
    obj.layout28:setMargins({bottom=6});
    obj.layout28:setName("layout28");

    obj.edit24 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit24:setParent(obj.layout28);
    obj.edit24:setAlign("left");
    obj.edit24:setWidth(100);
    obj.edit24:setField("extra_3_npc");
    obj.edit24:setHint("Extra 3");
    obj.edit24:setMargins({right=4});
    obj.edit24:setName("edit24");

    obj.colorComboBox12 = GUI.fromHandle(_obj_newObject("colorComboBox"));
    obj.colorComboBox12:setParent(obj.layout28);
    obj.colorComboBox12:setAlign("left");
    obj.colorComboBox12:setWidth(52);
    obj.colorComboBox12:setField("extra_3_color");
    obj.colorComboBox12:setUseAlpha(false);
    obj.colorComboBox12:setHint("Cor do nome no diálogo");
    obj.colorComboBox12:setMargins({right=4});
    obj.colorComboBox12:setName("colorComboBox12");

    obj.edit25 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit25:setParent(obj.layout28);
    obj.edit25:setAlign("client");
    obj.edit25:setField("extra_3_url");
    obj.edit25:setHint("URL");
    obj.edit25:setMargins({right=4});
    obj.edit25:setName("edit25");

    obj.layout29 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout29:setParent(obj.layout28);
    obj.layout29:setAlign("right");
    obj.layout29:setWidth(36);
    obj.layout29:setHeight(36);
    obj.layout29:setName("layout29");

    obj.imgPreviewExtra_3 = GUI.fromHandle(_obj_newObject("image"));
    obj.imgPreviewExtra_3:setParent(obj.layout29);
    obj.imgPreviewExtra_3:setName("imgPreviewExtra_3");
    obj.imgPreviewExtra_3:setAlign("client");
    obj.imgPreviewExtra_3:setStyle("proportional");
    obj.imgPreviewExtra_3:setSRC("");

    obj.labPreviewErrExtra_3 = GUI.fromHandle(_obj_newObject("label"));
    obj.labPreviewErrExtra_3:setParent(obj.layout29);
    obj.labPreviewErrExtra_3:setName("labPreviewErrExtra_3");
    obj.labPreviewErrExtra_3:setAlign("client");
    obj.labPreviewErrExtra_3:setText("!");
    obj.labPreviewErrExtra_3:setFontSize(18);
    lfm_setPropAsString(obj.labPreviewErrExtra_3, "fontStyle", "bold");
    obj.labPreviewErrExtra_3:setFontColor("#ff5555");
    obj.labPreviewErrExtra_3:setHorzTextAlign("center");
    obj.labPreviewErrExtra_3:setVertTextAlign("center");
    obj.labPreviewErrExtra_3:setVisible(false);
    obj.labPreviewErrExtra_3:setHint("A imagem não carregou. Confira a URL.");

    obj.layout30 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout30:setParent(obj.configContent);
    obj.layout30:setAlign("top");
    obj.layout30:setHeight(36);
    obj.layout30:setMargins({bottom=6});
    obj.layout30:setName("layout30");

    obj.edit26 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit26:setParent(obj.layout30);
    obj.edit26:setAlign("left");
    obj.edit26:setWidth(100);
    obj.edit26:setField("extra_4_npc");
    obj.edit26:setHint("Extra 4");
    obj.edit26:setMargins({right=4});
    obj.edit26:setName("edit26");

    obj.colorComboBox13 = GUI.fromHandle(_obj_newObject("colorComboBox"));
    obj.colorComboBox13:setParent(obj.layout30);
    obj.colorComboBox13:setAlign("left");
    obj.colorComboBox13:setWidth(52);
    obj.colorComboBox13:setField("extra_4_color");
    obj.colorComboBox13:setUseAlpha(false);
    obj.colorComboBox13:setHint("Cor do nome no diálogo");
    obj.colorComboBox13:setMargins({right=4});
    obj.colorComboBox13:setName("colorComboBox13");

    obj.edit27 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit27:setParent(obj.layout30);
    obj.edit27:setAlign("client");
    obj.edit27:setField("extra_4_url");
    obj.edit27:setHint("URL");
    obj.edit27:setMargins({right=4});
    obj.edit27:setName("edit27");

    obj.layout31 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout31:setParent(obj.layout30);
    obj.layout31:setAlign("right");
    obj.layout31:setWidth(36);
    obj.layout31:setHeight(36);
    obj.layout31:setName("layout31");

    obj.imgPreviewExtra_4 = GUI.fromHandle(_obj_newObject("image"));
    obj.imgPreviewExtra_4:setParent(obj.layout31);
    obj.imgPreviewExtra_4:setName("imgPreviewExtra_4");
    obj.imgPreviewExtra_4:setAlign("client");
    obj.imgPreviewExtra_4:setStyle("proportional");
    obj.imgPreviewExtra_4:setSRC("");

    obj.labPreviewErrExtra_4 = GUI.fromHandle(_obj_newObject("label"));
    obj.labPreviewErrExtra_4:setParent(obj.layout31);
    obj.labPreviewErrExtra_4:setName("labPreviewErrExtra_4");
    obj.labPreviewErrExtra_4:setAlign("client");
    obj.labPreviewErrExtra_4:setText("!");
    obj.labPreviewErrExtra_4:setFontSize(18);
    lfm_setPropAsString(obj.labPreviewErrExtra_4, "fontStyle", "bold");
    obj.labPreviewErrExtra_4:setFontColor("#ff5555");
    obj.labPreviewErrExtra_4:setHorzTextAlign("center");
    obj.labPreviewErrExtra_4:setVertTextAlign("center");
    obj.labPreviewErrExtra_4:setVisible(false);
    obj.labPreviewErrExtra_4:setHint("A imagem não carregou. Confira a URL.");

    obj.layout32 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout32:setParent(obj.configContent);
    obj.layout32:setAlign("top");
    obj.layout32:setHeight(36);
    obj.layout32:setMargins({bottom=6});
    obj.layout32:setName("layout32");

    obj.edit28 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit28:setParent(obj.layout32);
    obj.edit28:setAlign("left");
    obj.edit28:setWidth(100);
    obj.edit28:setField("extra_5_npc");
    obj.edit28:setHint("Extra 5");
    obj.edit28:setMargins({right=4});
    obj.edit28:setName("edit28");

    obj.colorComboBox14 = GUI.fromHandle(_obj_newObject("colorComboBox"));
    obj.colorComboBox14:setParent(obj.layout32);
    obj.colorComboBox14:setAlign("left");
    obj.colorComboBox14:setWidth(52);
    obj.colorComboBox14:setField("extra_5_color");
    obj.colorComboBox14:setUseAlpha(false);
    obj.colorComboBox14:setHint("Cor do nome no diálogo");
    obj.colorComboBox14:setMargins({right=4});
    obj.colorComboBox14:setName("colorComboBox14");

    obj.edit29 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit29:setParent(obj.layout32);
    obj.edit29:setAlign("client");
    obj.edit29:setField("extra_5_url");
    obj.edit29:setHint("URL");
    obj.edit29:setMargins({right=4});
    obj.edit29:setName("edit29");

    obj.layout33 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout33:setParent(obj.layout32);
    obj.layout33:setAlign("right");
    obj.layout33:setWidth(36);
    obj.layout33:setHeight(36);
    obj.layout33:setName("layout33");

    obj.imgPreviewExtra_5 = GUI.fromHandle(_obj_newObject("image"));
    obj.imgPreviewExtra_5:setParent(obj.layout33);
    obj.imgPreviewExtra_5:setName("imgPreviewExtra_5");
    obj.imgPreviewExtra_5:setAlign("client");
    obj.imgPreviewExtra_5:setStyle("proportional");
    obj.imgPreviewExtra_5:setSRC("");

    obj.labPreviewErrExtra_5 = GUI.fromHandle(_obj_newObject("label"));
    obj.labPreviewErrExtra_5:setParent(obj.layout33);
    obj.labPreviewErrExtra_5:setName("labPreviewErrExtra_5");
    obj.labPreviewErrExtra_5:setAlign("client");
    obj.labPreviewErrExtra_5:setText("!");
    obj.labPreviewErrExtra_5:setFontSize(18);
    lfm_setPropAsString(obj.labPreviewErrExtra_5, "fontStyle", "bold");
    obj.labPreviewErrExtra_5:setFontColor("#ff5555");
    obj.labPreviewErrExtra_5:setHorzTextAlign("center");
    obj.labPreviewErrExtra_5:setVertTextAlign("center");
    obj.labPreviewErrExtra_5:setVisible(false);
    obj.labPreviewErrExtra_5:setHint("A imagem não carregou. Confira a URL.");

    obj.layout34 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout34:setParent(obj.configContent);
    obj.layout34:setAlign("top");
    obj.layout34:setHeight(36);
    obj.layout34:setMargins({bottom=16});
    obj.layout34:setName("layout34");

    obj.edit30 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit30:setParent(obj.layout34);
    obj.edit30:setAlign("left");
    obj.edit30:setWidth(100);
    obj.edit30:setField("extra_6_npc");
    obj.edit30:setHint("Extra 6");
    obj.edit30:setMargins({right=4});
    obj.edit30:setName("edit30");

    obj.colorComboBox15 = GUI.fromHandle(_obj_newObject("colorComboBox"));
    obj.colorComboBox15:setParent(obj.layout34);
    obj.colorComboBox15:setAlign("left");
    obj.colorComboBox15:setWidth(52);
    obj.colorComboBox15:setField("extra_6_color");
    obj.colorComboBox15:setUseAlpha(false);
    obj.colorComboBox15:setHint("Cor do nome no diálogo");
    obj.colorComboBox15:setMargins({right=4});
    obj.colorComboBox15:setName("colorComboBox15");

    obj.edit31 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit31:setParent(obj.layout34);
    obj.edit31:setAlign("client");
    obj.edit31:setField("extra_6_url");
    obj.edit31:setHint("URL");
    obj.edit31:setMargins({right=4});
    obj.edit31:setName("edit31");

    obj.layout35 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout35:setParent(obj.layout34);
    obj.layout35:setAlign("right");
    obj.layout35:setWidth(36);
    obj.layout35:setHeight(36);
    obj.layout35:setName("layout35");

    obj.imgPreviewExtra_6 = GUI.fromHandle(_obj_newObject("image"));
    obj.imgPreviewExtra_6:setParent(obj.layout35);
    obj.imgPreviewExtra_6:setName("imgPreviewExtra_6");
    obj.imgPreviewExtra_6:setAlign("client");
    obj.imgPreviewExtra_6:setStyle("proportional");
    obj.imgPreviewExtra_6:setSRC("");

    obj.labPreviewErrExtra_6 = GUI.fromHandle(_obj_newObject("label"));
    obj.labPreviewErrExtra_6:setParent(obj.layout35);
    obj.labPreviewErrExtra_6:setName("labPreviewErrExtra_6");
    obj.labPreviewErrExtra_6:setAlign("client");
    obj.labPreviewErrExtra_6:setText("!");
    obj.labPreviewErrExtra_6:setFontSize(18);
    lfm_setPropAsString(obj.labPreviewErrExtra_6, "fontStyle", "bold");
    obj.labPreviewErrExtra_6:setFontColor("#ff5555");
    obj.labPreviewErrExtra_6:setHorzTextAlign("center");
    obj.labPreviewErrExtra_6:setVertTextAlign("center");
    obj.labPreviewErrExtra_6:setVisible(false);
    obj.labPreviewErrExtra_6:setHint("A imagem não carregou. Confira a URL.");

    obj.label24 = GUI.fromHandle(_obj_newObject("label"));
    obj.label24:setParent(obj.configContent);
    obj.label24:setText("Cenas Salvas");
    obj.label24:setAlign("top");
    obj.label24:setHeight(20);
    lfm_setPropAsString(obj.label24, "fontStyle", "bold");
    obj.label24:setFontSize(13);
    obj.label24:setName("label24");

    obj.label25 = GUI.fromHandle(_obj_newObject("label"));
    obj.label25:setParent(obj.configContent);
    obj.label25:setText("Guarde a configuração atual (fundo, slots e extras) com um nome e volte a ela depois.");
    obj.label25:setAlign("top");
    obj.label25:setHeight(18);
    obj.label25:setFontSize(11);
    obj.label25:setFontColor("Gray");
    obj.label25:setMargins({bottom=8});
    obj.label25:setName("label25");

    obj.layout36 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout36:setParent(obj.configContent);
    obj.layout36:setAlign("top");
    obj.layout36:setHeight(28);
    obj.layout36:setMargins({bottom=4});
    obj.layout36:setName("layout36");

    obj.edit32 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit32:setParent(obj.layout36);
    obj.edit32:setAlign("client");
    obj.edit32:setField("scene_1_name");
    obj.edit32:setHint("Nome da cena 1");
    obj.edit32:setMargins({right=4});
    obj.edit32:setName("edit32");

    obj.button17 = GUI.fromHandle(_obj_newObject("button"));
    obj.button17:setParent(obj.layout36);
    obj.button17:setAlign("right");
    obj.button17:setWidth(60);
    obj.button17:setText("Apagar");
    obj.button17:setFontSize(10);
    obj.button17:setMargins({left=4});
    obj.button17:setHint("Apaga esta cena salva");
    obj.button17:setName("button17");

    obj.button18 = GUI.fromHandle(_obj_newObject("button"));
    obj.button18:setParent(obj.layout36);
    obj.button18:setAlign("right");
    obj.button18:setWidth(64);
    obj.button18:setText("Carregar");
    obj.button18:setFontSize(10);
    obj.button18:setMargins({left=4});
    obj.button18:setHint("Substitui a configuração atual por esta cena");
    obj.button18:setName("button18");

    obj.button19 = GUI.fromHandle(_obj_newObject("button"));
    obj.button19:setParent(obj.layout36);
    obj.button19:setAlign("right");
    obj.button19:setWidth(56);
    obj.button19:setText("Salvar");
    obj.button19:setFontSize(10);
    obj.button19:setMargins({left=4});
    obj.button19:setHint("Guarda a configuração atual nesta cena");
    obj.button19:setName("button19");

    obj.layout37 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout37:setParent(obj.configContent);
    obj.layout37:setAlign("top");
    obj.layout37:setHeight(28);
    obj.layout37:setMargins({bottom=4});
    obj.layout37:setName("layout37");

    obj.edit33 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit33:setParent(obj.layout37);
    obj.edit33:setAlign("client");
    obj.edit33:setField("scene_2_name");
    obj.edit33:setHint("Nome da cena 2");
    obj.edit33:setMargins({right=4});
    obj.edit33:setName("edit33");

    obj.button20 = GUI.fromHandle(_obj_newObject("button"));
    obj.button20:setParent(obj.layout37);
    obj.button20:setAlign("right");
    obj.button20:setWidth(60);
    obj.button20:setText("Apagar");
    obj.button20:setFontSize(10);
    obj.button20:setMargins({left=4});
    obj.button20:setHint("Apaga esta cena salva");
    obj.button20:setName("button20");

    obj.button21 = GUI.fromHandle(_obj_newObject("button"));
    obj.button21:setParent(obj.layout37);
    obj.button21:setAlign("right");
    obj.button21:setWidth(64);
    obj.button21:setText("Carregar");
    obj.button21:setFontSize(10);
    obj.button21:setMargins({left=4});
    obj.button21:setHint("Substitui a configuração atual por esta cena");
    obj.button21:setName("button21");

    obj.button22 = GUI.fromHandle(_obj_newObject("button"));
    obj.button22:setParent(obj.layout37);
    obj.button22:setAlign("right");
    obj.button22:setWidth(56);
    obj.button22:setText("Salvar");
    obj.button22:setFontSize(10);
    obj.button22:setMargins({left=4});
    obj.button22:setHint("Guarda a configuração atual nesta cena");
    obj.button22:setName("button22");

    obj.layout38 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout38:setParent(obj.configContent);
    obj.layout38:setAlign("top");
    obj.layout38:setHeight(28);
    obj.layout38:setMargins({bottom=4});
    obj.layout38:setName("layout38");

    obj.edit34 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit34:setParent(obj.layout38);
    obj.edit34:setAlign("client");
    obj.edit34:setField("scene_3_name");
    obj.edit34:setHint("Nome da cena 3");
    obj.edit34:setMargins({right=4});
    obj.edit34:setName("edit34");

    obj.button23 = GUI.fromHandle(_obj_newObject("button"));
    obj.button23:setParent(obj.layout38);
    obj.button23:setAlign("right");
    obj.button23:setWidth(60);
    obj.button23:setText("Apagar");
    obj.button23:setFontSize(10);
    obj.button23:setMargins({left=4});
    obj.button23:setHint("Apaga esta cena salva");
    obj.button23:setName("button23");

    obj.button24 = GUI.fromHandle(_obj_newObject("button"));
    obj.button24:setParent(obj.layout38);
    obj.button24:setAlign("right");
    obj.button24:setWidth(64);
    obj.button24:setText("Carregar");
    obj.button24:setFontSize(10);
    obj.button24:setMargins({left=4});
    obj.button24:setHint("Substitui a configuração atual por esta cena");
    obj.button24:setName("button24");

    obj.button25 = GUI.fromHandle(_obj_newObject("button"));
    obj.button25:setParent(obj.layout38);
    obj.button25:setAlign("right");
    obj.button25:setWidth(56);
    obj.button25:setText("Salvar");
    obj.button25:setFontSize(10);
    obj.button25:setMargins({left=4});
    obj.button25:setHint("Guarda a configuração atual nesta cena");
    obj.button25:setName("button25");

    obj.layout39 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout39:setParent(obj.configContent);
    obj.layout39:setAlign("top");
    obj.layout39:setHeight(28);
    obj.layout39:setMargins({bottom=4});
    obj.layout39:setName("layout39");

    obj.edit35 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit35:setParent(obj.layout39);
    obj.edit35:setAlign("client");
    obj.edit35:setField("scene_4_name");
    obj.edit35:setHint("Nome da cena 4");
    obj.edit35:setMargins({right=4});
    obj.edit35:setName("edit35");

    obj.button26 = GUI.fromHandle(_obj_newObject("button"));
    obj.button26:setParent(obj.layout39);
    obj.button26:setAlign("right");
    obj.button26:setWidth(60);
    obj.button26:setText("Apagar");
    obj.button26:setFontSize(10);
    obj.button26:setMargins({left=4});
    obj.button26:setHint("Apaga esta cena salva");
    obj.button26:setName("button26");

    obj.button27 = GUI.fromHandle(_obj_newObject("button"));
    obj.button27:setParent(obj.layout39);
    obj.button27:setAlign("right");
    obj.button27:setWidth(64);
    obj.button27:setText("Carregar");
    obj.button27:setFontSize(10);
    obj.button27:setMargins({left=4});
    obj.button27:setHint("Substitui a configuração atual por esta cena");
    obj.button27:setName("button27");

    obj.button28 = GUI.fromHandle(_obj_newObject("button"));
    obj.button28:setParent(obj.layout39);
    obj.button28:setAlign("right");
    obj.button28:setWidth(56);
    obj.button28:setText("Salvar");
    obj.button28:setFontSize(10);
    obj.button28:setMargins({left=4});
    obj.button28:setHint("Guarda a configuração atual nesta cena");
    obj.button28:setName("button28");

    obj.layout40 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout40:setParent(obj.configContent);
    obj.layout40:setAlign("top");
    obj.layout40:setHeight(28);
    obj.layout40:setMargins({bottom=4});
    obj.layout40:setName("layout40");

    obj.edit36 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit36:setParent(obj.layout40);
    obj.edit36:setAlign("client");
    obj.edit36:setField("scene_5_name");
    obj.edit36:setHint("Nome da cena 5");
    obj.edit36:setMargins({right=4});
    obj.edit36:setName("edit36");

    obj.button29 = GUI.fromHandle(_obj_newObject("button"));
    obj.button29:setParent(obj.layout40);
    obj.button29:setAlign("right");
    obj.button29:setWidth(60);
    obj.button29:setText("Apagar");
    obj.button29:setFontSize(10);
    obj.button29:setMargins({left=4});
    obj.button29:setHint("Apaga esta cena salva");
    obj.button29:setName("button29");

    obj.button30 = GUI.fromHandle(_obj_newObject("button"));
    obj.button30:setParent(obj.layout40);
    obj.button30:setAlign("right");
    obj.button30:setWidth(64);
    obj.button30:setText("Carregar");
    obj.button30:setFontSize(10);
    obj.button30:setMargins({left=4});
    obj.button30:setHint("Substitui a configuração atual por esta cena");
    obj.button30:setName("button30");

    obj.button31 = GUI.fromHandle(_obj_newObject("button"));
    obj.button31:setParent(obj.layout40);
    obj.button31:setAlign("right");
    obj.button31:setWidth(56);
    obj.button31:setText("Salvar");
    obj.button31:setFontSize(10);
    obj.button31:setMargins({left=4});
    obj.button31:setHint("Guarda a configuração atual nesta cena");
    obj.button31:setName("button31");

    obj.layout41 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout41:setParent(obj.configContent);
    obj.layout41:setAlign("top");
    obj.layout41:setHeight(28);
    obj.layout41:setMargins({bottom=4});
    obj.layout41:setName("layout41");

    obj.edit37 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit37:setParent(obj.layout41);
    obj.edit37:setAlign("client");
    obj.edit37:setField("scene_6_name");
    obj.edit37:setHint("Nome da cena 6");
    obj.edit37:setMargins({right=4});
    obj.edit37:setName("edit37");

    obj.button32 = GUI.fromHandle(_obj_newObject("button"));
    obj.button32:setParent(obj.layout41);
    obj.button32:setAlign("right");
    obj.button32:setWidth(60);
    obj.button32:setText("Apagar");
    obj.button32:setFontSize(10);
    obj.button32:setMargins({left=4});
    obj.button32:setHint("Apaga esta cena salva");
    obj.button32:setName("button32");

    obj.button33 = GUI.fromHandle(_obj_newObject("button"));
    obj.button33:setParent(obj.layout41);
    obj.button33:setAlign("right");
    obj.button33:setWidth(64);
    obj.button33:setText("Carregar");
    obj.button33:setFontSize(10);
    obj.button33:setMargins({left=4});
    obj.button33:setHint("Substitui a configuração atual por esta cena");
    obj.button33:setName("button33");

    obj.button34 = GUI.fromHandle(_obj_newObject("button"));
    obj.button34:setParent(obj.layout41);
    obj.button34:setAlign("right");
    obj.button34:setWidth(56);
    obj.button34:setText("Salvar");
    obj.button34:setFontSize(10);
    obj.button34:setMargins({left=4});
    obj.button34:setHint("Guarda a configuração atual nesta cena");
    obj.button34:setName("button34");

    obj.label26 = GUI.fromHandle(_obj_newObject("label"));
    obj.label26:setParent(obj.configContent);
    obj.label26:setText("Exportar e Importar");
    obj.label26:setAlign("top");
    obj.label26:setHeight(20);
    lfm_setPropAsString(obj.label26, "fontStyle", "bold");
    obj.label26:setFontSize(13);
    obj.label26:setMargins({top=12});
    obj.label26:setName("label26");

    obj.label27 = GUI.fromHandle(_obj_newObject("label"));
    obj.label27:setParent(obj.configContent);
    obj.label27:setText("Copia a configuração atual como texto, ou aplica um texto copiado de outra ficha.");
    obj.label27:setAlign("top");
    obj.label27:setHeight(18);
    obj.label27:setFontSize(11);
    obj.label27:setFontColor("Gray");
    obj.label27:setMargins({bottom=8});
    obj.label27:setName("label27");

    obj.layout42 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout42:setParent(obj.configContent);
    obj.layout42:setAlign("top");
    obj.layout42:setHeight(28);
    obj.layout42:setName("layout42");

    obj.button35 = GUI.fromHandle(_obj_newObject("button"));
    obj.button35:setParent(obj.layout42);
    obj.button35:setAlign("left");
    obj.button35:setWidth(180);
    obj.button35:setText("Exportar (copiar)");
    obj.button35:setMargins({right=8});
    obj.button35:setHint("Copia a configuração atual para a área de transferência");
    obj.button35:setName("button35");

    obj.button36 = GUI.fromHandle(_obj_newObject("button"));
    obj.button36:setParent(obj.layout42);
    obj.button36:setAlign("left");
    obj.button36:setWidth(180);
    obj.button36:setText("Importar (colar)");
    obj.button36:setHint("Aplica a configuração que está na área de transferência");
    obj.button36:setName("button36");

    obj._e_event0 = obj:addEventListener("onNodeReady",
        function ()
            init()
        end);

    obj._e_event1 = obj:addEventListener("onNodeUnready",
        function ()
            uninit()
        end);

    obj._e_event2 = obj.tmrConfig:addEventListener("onTimer",
        function ()
            onConfigTimer()
        end);

    obj._e_event3 = obj.tmrFade:addEventListener("onTimer",
        function ()
            onFadeTimer()
        end);

    obj._e_event4 = obj.tmrPreview:addEventListener("onTimer",
        function ()
            checkPreviews()
        end);

    obj._e_event5 = obj.sceneContent:addEventListener("onResize",
        function ()
            updateConfigTab()
        end);

    obj._e_event6 = obj.checkBox1:addEventListener("onChange",
        function ()
            updateConfigTab()
        end);

    obj._e_event7 = obj.checkBox2:addEventListener("onChange",
        function ()
            updateConfigTab()
        end);

    obj._e_event8 = obj.frmStageContainer:addEventListener("onResize",
        function ()
            updateStageScale()
        end);

    obj._e_event9 = obj.btnDialogExpand:addEventListener("onClick",
        function (event)
            toggleDialogExpanded()
        end);

    obj._e_event10 = obj.button1:addEventListener("onClick",
        function (event)
            confirmClearConfig()
        end);

    obj._e_event11 = obj.edit1:addEventListener("onChange",
        function ()
            scheduleLoadConfig()
        end);

    obj._e_event12 = obj.slotConfigs:addEventListener("onResize",
        function ()
            updateSlotLayout()
        end);

    obj._e_event13 = obj.button2:addEventListener("onClick",
        function (event)
            confirmClearSlot('left')
        end);

    obj._e_event14 = obj.button3:addEventListener("onClick",
        function (event)
            rotateSlot('left')
        end);

    obj._e_event15 = obj.checkBox5:addEventListener("onChange",
        function ()
            loadConfig()
        end);

    obj._e_event16 = obj.edit2:addEventListener("onChange",
        function ()
            scheduleLoadConfig()
        end);

    obj._e_event17 = obj.colorComboBox1:addEventListener("onChange",
        function ()
            loadConfig()
        end);

    obj._e_event18 = obj.edit3:addEventListener("onChange",
        function ()
            scheduleLoadConfig()
        end);

    obj._e_event19 = obj.button4:addEventListener("onClick",
        function (event)
            setFocus('left', 1)
        end);

    obj._e_event20 = obj.edit4:addEventListener("onChange",
        function ()
            scheduleLoadConfig()
        end);

    obj._e_event21 = obj.colorComboBox2:addEventListener("onChange",
        function ()
            loadConfig()
        end);

    obj._e_event22 = obj.edit5:addEventListener("onChange",
        function ()
            scheduleLoadConfig()
        end);

    obj._e_event23 = obj.button5:addEventListener("onClick",
        function (event)
            setFocus('left', 2)
        end);

    obj._e_event24 = obj.edit6:addEventListener("onChange",
        function ()
            scheduleLoadConfig()
        end);

    obj._e_event25 = obj.colorComboBox3:addEventListener("onChange",
        function ()
            loadConfig()
        end);

    obj._e_event26 = obj.edit7:addEventListener("onChange",
        function ()
            scheduleLoadConfig()
        end);

    obj._e_event27 = obj.button6:addEventListener("onClick",
        function (event)
            setFocus('left', 3)
        end);

    obj._e_event28 = obj.button7:addEventListener("onClick",
        function (event)
            confirmClearSlot('center')
        end);

    obj._e_event29 = obj.button8:addEventListener("onClick",
        function (event)
            rotateSlot('center')
        end);

    obj._e_event30 = obj.checkBox6:addEventListener("onChange",
        function ()
            loadConfig()
        end);

    obj._e_event31 = obj.edit8:addEventListener("onChange",
        function ()
            scheduleLoadConfig()
        end);

    obj._e_event32 = obj.colorComboBox4:addEventListener("onChange",
        function ()
            loadConfig()
        end);

    obj._e_event33 = obj.edit9:addEventListener("onChange",
        function ()
            scheduleLoadConfig()
        end);

    obj._e_event34 = obj.button9:addEventListener("onClick",
        function (event)
            setFocus('center', 1)
        end);

    obj._e_event35 = obj.edit10:addEventListener("onChange",
        function ()
            scheduleLoadConfig()
        end);

    obj._e_event36 = obj.colorComboBox5:addEventListener("onChange",
        function ()
            loadConfig()
        end);

    obj._e_event37 = obj.edit11:addEventListener("onChange",
        function ()
            scheduleLoadConfig()
        end);

    obj._e_event38 = obj.button10:addEventListener("onClick",
        function (event)
            setFocus('center', 2)
        end);

    obj._e_event39 = obj.edit12:addEventListener("onChange",
        function ()
            scheduleLoadConfig()
        end);

    obj._e_event40 = obj.colorComboBox6:addEventListener("onChange",
        function ()
            loadConfig()
        end);

    obj._e_event41 = obj.edit13:addEventListener("onChange",
        function ()
            scheduleLoadConfig()
        end);

    obj._e_event42 = obj.button11:addEventListener("onClick",
        function (event)
            setFocus('center', 3)
        end);

    obj._e_event43 = obj.button12:addEventListener("onClick",
        function (event)
            confirmClearSlot('right')
        end);

    obj._e_event44 = obj.button13:addEventListener("onClick",
        function (event)
            rotateSlot('right')
        end);

    obj._e_event45 = obj.checkBox7:addEventListener("onChange",
        function ()
            loadConfig()
        end);

    obj._e_event46 = obj.edit14:addEventListener("onChange",
        function ()
            scheduleLoadConfig()
        end);

    obj._e_event47 = obj.colorComboBox7:addEventListener("onChange",
        function ()
            loadConfig()
        end);

    obj._e_event48 = obj.edit15:addEventListener("onChange",
        function ()
            scheduleLoadConfig()
        end);

    obj._e_event49 = obj.button14:addEventListener("onClick",
        function (event)
            setFocus('right', 1)
        end);

    obj._e_event50 = obj.edit16:addEventListener("onChange",
        function ()
            scheduleLoadConfig()
        end);

    obj._e_event51 = obj.colorComboBox8:addEventListener("onChange",
        function ()
            loadConfig()
        end);

    obj._e_event52 = obj.edit17:addEventListener("onChange",
        function ()
            scheduleLoadConfig()
        end);

    obj._e_event53 = obj.button15:addEventListener("onClick",
        function (event)
            setFocus('right', 2)
        end);

    obj._e_event54 = obj.edit18:addEventListener("onChange",
        function ()
            scheduleLoadConfig()
        end);

    obj._e_event55 = obj.colorComboBox9:addEventListener("onChange",
        function ()
            loadConfig()
        end);

    obj._e_event56 = obj.edit19:addEventListener("onChange",
        function ()
            scheduleLoadConfig()
        end);

    obj._e_event57 = obj.button16:addEventListener("onClick",
        function (event)
            setFocus('right', 3)
        end);

    obj._e_event58 = obj.edit20:addEventListener("onChange",
        function ()
            scheduleLoadConfig()
        end);

    obj._e_event59 = obj.colorComboBox10:addEventListener("onChange",
        function ()
            loadConfig()
        end);

    obj._e_event60 = obj.edit21:addEventListener("onChange",
        function ()
            scheduleLoadConfig()
        end);

    obj._e_event61 = obj.edit22:addEventListener("onChange",
        function ()
            scheduleLoadConfig()
        end);

    obj._e_event62 = obj.colorComboBox11:addEventListener("onChange",
        function ()
            loadConfig()
        end);

    obj._e_event63 = obj.edit23:addEventListener("onChange",
        function ()
            scheduleLoadConfig()
        end);

    obj._e_event64 = obj.edit24:addEventListener("onChange",
        function ()
            scheduleLoadConfig()
        end);

    obj._e_event65 = obj.colorComboBox12:addEventListener("onChange",
        function ()
            loadConfig()
        end);

    obj._e_event66 = obj.edit25:addEventListener("onChange",
        function ()
            scheduleLoadConfig()
        end);

    obj._e_event67 = obj.edit26:addEventListener("onChange",
        function ()
            scheduleLoadConfig()
        end);

    obj._e_event68 = obj.colorComboBox13:addEventListener("onChange",
        function ()
            loadConfig()
        end);

    obj._e_event69 = obj.edit27:addEventListener("onChange",
        function ()
            scheduleLoadConfig()
        end);

    obj._e_event70 = obj.edit28:addEventListener("onChange",
        function ()
            scheduleLoadConfig()
        end);

    obj._e_event71 = obj.colorComboBox14:addEventListener("onChange",
        function ()
            loadConfig()
        end);

    obj._e_event72 = obj.edit29:addEventListener("onChange",
        function ()
            scheduleLoadConfig()
        end);

    obj._e_event73 = obj.edit30:addEventListener("onChange",
        function ()
            scheduleLoadConfig()
        end);

    obj._e_event74 = obj.colorComboBox15:addEventListener("onChange",
        function ()
            loadConfig()
        end);

    obj._e_event75 = obj.edit31:addEventListener("onChange",
        function ()
            scheduleLoadConfig()
        end);

    obj._e_event76 = obj.button17:addEventListener("onClick",
        function (event)
            confirmDeleteScene(1)
        end);

    obj._e_event77 = obj.button18:addEventListener("onClick",
        function (event)
            confirmLoadScene(1)
        end);

    obj._e_event78 = obj.button19:addEventListener("onClick",
        function (event)
            confirmSaveScene(1)
        end);

    obj._e_event79 = obj.button20:addEventListener("onClick",
        function (event)
            confirmDeleteScene(2)
        end);

    obj._e_event80 = obj.button21:addEventListener("onClick",
        function (event)
            confirmLoadScene(2)
        end);

    obj._e_event81 = obj.button22:addEventListener("onClick",
        function (event)
            confirmSaveScene(2)
        end);

    obj._e_event82 = obj.button23:addEventListener("onClick",
        function (event)
            confirmDeleteScene(3)
        end);

    obj._e_event83 = obj.button24:addEventListener("onClick",
        function (event)
            confirmLoadScene(3)
        end);

    obj._e_event84 = obj.button25:addEventListener("onClick",
        function (event)
            confirmSaveScene(3)
        end);

    obj._e_event85 = obj.button26:addEventListener("onClick",
        function (event)
            confirmDeleteScene(4)
        end);

    obj._e_event86 = obj.button27:addEventListener("onClick",
        function (event)
            confirmLoadScene(4)
        end);

    obj._e_event87 = obj.button28:addEventListener("onClick",
        function (event)
            confirmSaveScene(4)
        end);

    obj._e_event88 = obj.button29:addEventListener("onClick",
        function (event)
            confirmDeleteScene(5)
        end);

    obj._e_event89 = obj.button30:addEventListener("onClick",
        function (event)
            confirmLoadScene(5)
        end);

    obj._e_event90 = obj.button31:addEventListener("onClick",
        function (event)
            confirmSaveScene(5)
        end);

    obj._e_event91 = obj.button32:addEventListener("onClick",
        function (event)
            confirmDeleteScene(6)
        end);

    obj._e_event92 = obj.button33:addEventListener("onClick",
        function (event)
            confirmLoadScene(6)
        end);

    obj._e_event93 = obj.button34:addEventListener("onClick",
        function (event)
            confirmSaveScene(6)
        end);

    obj._e_event94 = obj.button35:addEventListener("onClick",
        function (event)
            exportConfig()
        end);

    obj._e_event95 = obj.button36:addEventListener("onClick",
        function (event)
            importConfig()
        end);

    function obj:_releaseEvents()
        __o_rrpgObjs.removeEventListenerById(self._e_event95);
        __o_rrpgObjs.removeEventListenerById(self._e_event94);
        __o_rrpgObjs.removeEventListenerById(self._e_event93);
        __o_rrpgObjs.removeEventListenerById(self._e_event92);
        __o_rrpgObjs.removeEventListenerById(self._e_event91);
        __o_rrpgObjs.removeEventListenerById(self._e_event90);
        __o_rrpgObjs.removeEventListenerById(self._e_event89);
        __o_rrpgObjs.removeEventListenerById(self._e_event88);
        __o_rrpgObjs.removeEventListenerById(self._e_event87);
        __o_rrpgObjs.removeEventListenerById(self._e_event86);
        __o_rrpgObjs.removeEventListenerById(self._e_event85);
        __o_rrpgObjs.removeEventListenerById(self._e_event84);
        __o_rrpgObjs.removeEventListenerById(self._e_event83);
        __o_rrpgObjs.removeEventListenerById(self._e_event82);
        __o_rrpgObjs.removeEventListenerById(self._e_event81);
        __o_rrpgObjs.removeEventListenerById(self._e_event80);
        __o_rrpgObjs.removeEventListenerById(self._e_event79);
        __o_rrpgObjs.removeEventListenerById(self._e_event78);
        __o_rrpgObjs.removeEventListenerById(self._e_event77);
        __o_rrpgObjs.removeEventListenerById(self._e_event76);
        __o_rrpgObjs.removeEventListenerById(self._e_event75);
        __o_rrpgObjs.removeEventListenerById(self._e_event74);
        __o_rrpgObjs.removeEventListenerById(self._e_event73);
        __o_rrpgObjs.removeEventListenerById(self._e_event72);
        __o_rrpgObjs.removeEventListenerById(self._e_event71);
        __o_rrpgObjs.removeEventListenerById(self._e_event70);
        __o_rrpgObjs.removeEventListenerById(self._e_event69);
        __o_rrpgObjs.removeEventListenerById(self._e_event68);
        __o_rrpgObjs.removeEventListenerById(self._e_event67);
        __o_rrpgObjs.removeEventListenerById(self._e_event66);
        __o_rrpgObjs.removeEventListenerById(self._e_event65);
        __o_rrpgObjs.removeEventListenerById(self._e_event64);
        __o_rrpgObjs.removeEventListenerById(self._e_event63);
        __o_rrpgObjs.removeEventListenerById(self._e_event62);
        __o_rrpgObjs.removeEventListenerById(self._e_event61);
        __o_rrpgObjs.removeEventListenerById(self._e_event60);
        __o_rrpgObjs.removeEventListenerById(self._e_event59);
        __o_rrpgObjs.removeEventListenerById(self._e_event58);
        __o_rrpgObjs.removeEventListenerById(self._e_event57);
        __o_rrpgObjs.removeEventListenerById(self._e_event56);
        __o_rrpgObjs.removeEventListenerById(self._e_event55);
        __o_rrpgObjs.removeEventListenerById(self._e_event54);
        __o_rrpgObjs.removeEventListenerById(self._e_event53);
        __o_rrpgObjs.removeEventListenerById(self._e_event52);
        __o_rrpgObjs.removeEventListenerById(self._e_event51);
        __o_rrpgObjs.removeEventListenerById(self._e_event50);
        __o_rrpgObjs.removeEventListenerById(self._e_event49);
        __o_rrpgObjs.removeEventListenerById(self._e_event48);
        __o_rrpgObjs.removeEventListenerById(self._e_event47);
        __o_rrpgObjs.removeEventListenerById(self._e_event46);
        __o_rrpgObjs.removeEventListenerById(self._e_event45);
        __o_rrpgObjs.removeEventListenerById(self._e_event44);
        __o_rrpgObjs.removeEventListenerById(self._e_event43);
        __o_rrpgObjs.removeEventListenerById(self._e_event42);
        __o_rrpgObjs.removeEventListenerById(self._e_event41);
        __o_rrpgObjs.removeEventListenerById(self._e_event40);
        __o_rrpgObjs.removeEventListenerById(self._e_event39);
        __o_rrpgObjs.removeEventListenerById(self._e_event38);
        __o_rrpgObjs.removeEventListenerById(self._e_event37);
        __o_rrpgObjs.removeEventListenerById(self._e_event36);
        __o_rrpgObjs.removeEventListenerById(self._e_event35);
        __o_rrpgObjs.removeEventListenerById(self._e_event34);
        __o_rrpgObjs.removeEventListenerById(self._e_event33);
        __o_rrpgObjs.removeEventListenerById(self._e_event32);
        __o_rrpgObjs.removeEventListenerById(self._e_event31);
        __o_rrpgObjs.removeEventListenerById(self._e_event30);
        __o_rrpgObjs.removeEventListenerById(self._e_event29);
        __o_rrpgObjs.removeEventListenerById(self._e_event28);
        __o_rrpgObjs.removeEventListenerById(self._e_event27);
        __o_rrpgObjs.removeEventListenerById(self._e_event26);
        __o_rrpgObjs.removeEventListenerById(self._e_event25);
        __o_rrpgObjs.removeEventListenerById(self._e_event24);
        __o_rrpgObjs.removeEventListenerById(self._e_event23);
        __o_rrpgObjs.removeEventListenerById(self._e_event22);
        __o_rrpgObjs.removeEventListenerById(self._e_event21);
        __o_rrpgObjs.removeEventListenerById(self._e_event20);
        __o_rrpgObjs.removeEventListenerById(self._e_event19);
        __o_rrpgObjs.removeEventListenerById(self._e_event18);
        __o_rrpgObjs.removeEventListenerById(self._e_event17);
        __o_rrpgObjs.removeEventListenerById(self._e_event16);
        __o_rrpgObjs.removeEventListenerById(self._e_event15);
        __o_rrpgObjs.removeEventListenerById(self._e_event14);
        __o_rrpgObjs.removeEventListenerById(self._e_event13);
        __o_rrpgObjs.removeEventListenerById(self._e_event12);
        __o_rrpgObjs.removeEventListenerById(self._e_event11);
        __o_rrpgObjs.removeEventListenerById(self._e_event10);
        __o_rrpgObjs.removeEventListenerById(self._e_event9);
        __o_rrpgObjs.removeEventListenerById(self._e_event8);
        __o_rrpgObjs.removeEventListenerById(self._e_event7);
        __o_rrpgObjs.removeEventListenerById(self._e_event6);
        __o_rrpgObjs.removeEventListenerById(self._e_event5);
        __o_rrpgObjs.removeEventListenerById(self._e_event4);
        __o_rrpgObjs.removeEventListenerById(self._e_event3);
        __o_rrpgObjs.removeEventListenerById(self._e_event2);
        __o_rrpgObjs.removeEventListenerById(self._e_event1);
        __o_rrpgObjs.removeEventListenerById(self._e_event0);
    end;

    obj._oldLFMDestroy = obj.destroy;

    function obj:destroy() 
        self:_releaseEvents();

        if (self.handle ~= 0) and (self.setNodeDatabase ~= nil) then
          self:setNodeDatabase(nil);
        end;

        if self.layout8 ~= nil then self.layout8:destroy(); self.layout8 = nil; end;
        if self.imgPreviewExtra_3 ~= nil then self.imgPreviewExtra_3:destroy(); self.imgPreviewExtra_3 = nil; end;
        if self.imgDialogAvatar ~= nil then self.imgDialogAvatar:destroy(); self.imgDialogAvatar = nil; end;
        if self.layout11 ~= nil then self.layout11:destroy(); self.layout11 = nil; end;
        if self.edit30 ~= nil then self.edit30:destroy(); self.edit30 = nil; end;
        if self.tmrConfig ~= nil then self.tmrConfig:destroy(); self.tmrConfig = nil; end;
        if self.layout3 ~= nil then self.layout3:destroy(); self.layout3 = nil; end;
        if self.imgPreviewExtra_6 ~= nil then self.imgPreviewExtra_6:destroy(); self.imgPreviewExtra_6 = nil; end;
        if self.button11 ~= nil then self.button11:destroy(); self.button11 = nil; end;
        if self.button25 ~= nil then self.button25:destroy(); self.button25 = nil; end;
        if self.edit35 ~= nil then self.edit35:destroy(); self.edit35 = nil; end;
        if self.checkBox4 ~= nil then self.checkBox4:destroy(); self.checkBox4 = nil; end;
        if self.button28 ~= nil then self.button28:destroy(); self.button28 = nil; end;
        if self.edit27 ~= nil then self.edit27:destroy(); self.edit27 = nil; end;
        if self.checkBox1 ~= nil then self.checkBox1:destroy(); self.checkBox1 = nil; end;
        if self.colorComboBox1 ~= nil then self.colorComboBox1:destroy(); self.colorComboBox1 = nil; end;
        if self.label10 ~= nil then self.label10:destroy(); self.label10 = nil; end;
        if self.label22 ~= nil then self.label22:destroy(); self.label22 = nil; end;
        if self.edit14 ~= nil then self.edit14:destroy(); self.edit14 = nil; end;
        if self.rectExtra_5 ~= nil then self.rectExtra_5:destroy(); self.rectExtra_5 = nil; end;
        if self.edit9 ~= nil then self.edit9:destroy(); self.edit9 = nil; end;
        if self.layout37 ~= nil then self.layout37:destroy(); self.layout37 = nil; end;
        if self.colorComboBox4 ~= nil then self.colorComboBox4:destroy(); self.colorComboBox4 = nil; end;
        if self.label15 ~= nil then self.label15:destroy(); self.label15 = nil; end;
        if self.labPreviewErrExtra_1 ~= nil then self.labPreviewErrExtra_1:destroy(); self.labPreviewErrExtra_1 = nil; end;
        if self.imgSprite_right_2 ~= nil then self.imgSprite_right_2:destroy(); self.imgSprite_right_2 = nil; end;
        if self.imgExtra_3 ~= nil then self.imgExtra_3:destroy(); self.imgExtra_3 = nil; end;
        if self.layout25 ~= nil then self.layout25:destroy(); self.layout25 = nil; end;
        if self.colorComboBox11 ~= nil then self.colorComboBox11:destroy(); self.colorComboBox11 = nil; end;
        if self.imgSprite_left_2 ~= nil then self.imgSprite_left_2:destroy(); self.imgSprite_left_2 = nil; end;
        if self.labPreviewErrExtra_6 ~= nil then self.labPreviewErrExtra_6:destroy(); self.labPreviewErrExtra_6 = nil; end;
        if self.edit3 ~= nil then self.edit3:destroy(); self.edit3 = nil; end;
        if self.button8 ~= nil then self.button8:destroy(); self.button8 = nil; end;
        if self.labPreviewErr_left_2 ~= nil then self.labPreviewErr_left_2:destroy(); self.labPreviewErr_left_2 = nil; end;
        if self.imgExtra_6 ~= nil then self.imgExtra_6:destroy(); self.imgExtra_6 = nil; end;
        if self.layout20 ~= nil then self.layout20:destroy(); self.layout20 = nil; end;
        if self.button34 ~= nil then self.button34:destroy(); self.button34 = nil; end;
        if self.tab1 ~= nil then self.tab1:destroy(); self.tab1 = nil; end;
        if self.imgPreview_left_2 ~= nil then self.imgPreview_left_2:destroy(); self.imgPreview_left_2 = nil; end;
        if self.layout18 ~= nil then self.layout18:destroy(); self.layout18 = nil; end;
        if self.edit6 ~= nil then self.edit6:destroy(); self.edit6 = nil; end;
        if self.button3 ~= nil then self.button3:destroy(); self.button3 = nil; end;
        if self.labPreviewErr_center_1 ~= nil then self.labPreviewErr_center_1:destroy(); self.labPreviewErr_center_1 = nil; end;
        if self.imgPreview_right_3 ~= nil then self.imgPreview_right_3:destroy(); self.imgPreview_right_3 = nil; end;
        if self.label9 ~= nil then self.label9:destroy(); self.label9 = nil; end;
        if self.layout15 ~= nil then self.layout15:destroy(); self.layout15 = nil; end;
        if self.button18 ~= nil then self.button18:destroy(); self.button18 = nil; end;
        if self.button6 ~= nil then self.button6:destroy(); self.button6 = nil; end;
        if self.layout7 ~= nil then self.layout7:destroy(); self.layout7 = nil; end;
        if self.imgPreviewExtra_2 ~= nil then self.imgPreviewExtra_2:destroy(); self.imgPreviewExtra_2 = nil; end;
        if self.button21 ~= nil then self.button21:destroy(); self.button21 = nil; end;
        if self.edit31 ~= nil then self.edit31:destroy(); self.edit31 = nil; end;
        if self.layout2 ~= nil then self.layout2:destroy(); self.layout2 = nil; end;
        if self.slotConfigs ~= nil then self.slotConfigs:destroy(); self.slotConfigs = nil; end;
        if self.layout42 ~= nil then self.layout42:destroy(); self.layout42 = nil; end;
        if self.label7 ~= nil then self.label7:destroy(); self.label7 = nil; end;
        if self.button16 ~= nil then self.button16:destroy(); self.button16 = nil; end;
        if self.button24 ~= nil then self.button24:destroy(); self.button24 = nil; end;
        if self.edit23 ~= nil then self.edit23:destroy(); self.edit23 = nil; end;
        if self.checkBox5 ~= nil then self.checkBox5:destroy(); self.checkBox5 = nil; end;
        if self.edit10 ~= nil then self.edit10:destroy(); self.edit10 = nil; end;
        if self.rectExtra_1 ~= nil then self.rectExtra_1:destroy(); self.rectExtra_1 = nil; end;
        if self.edit26 ~= nil then self.edit26:destroy(); self.edit26 = nil; end;
        if self.label11 ~= nil then self.label11:destroy(); self.label11 = nil; end;
        if self.label25 ~= nil then self.label25:destroy(); self.label25 = nil; end;
        if self.edit15 ~= nil then self.edit15:destroy(); self.edit15 = nil; end;
        if self.rectExtra_6 ~= nil then self.rectExtra_6:destroy(); self.rectExtra_6 = nil; end;
        if self.edit8 ~= nil then self.edit8:destroy(); self.edit8 = nil; end;
        if self.edit29 ~= nil then self.edit29:destroy(); self.edit29 = nil; end;
        if self.layout30 ~= nil then self.layout30:destroy(); self.layout30 = nil; end;
        if self.colorComboBox7 ~= nil then self.colorComboBox7:destroy(); self.colorComboBox7 = nil; end;
        if self.labPreviewErr_right_3 ~= nil then self.labPreviewErr_right_3:destroy(); self.labPreviewErr_right_3 = nil; end;
        if self.labPreviewErrExtra_2 ~= nil then self.labPreviewErrExtra_2:destroy(); self.labPreviewErrExtra_2 = nil; end;
        if self.rectDialog ~= nil then self.rectDialog:destroy(); self.rectDialog = nil; end;
        if self.imgSprite_right_1 ~= nil then self.imgSprite_right_1:destroy(); self.imgSprite_right_1 = nil; end;
        if self.button30 ~= nil then self.button30:destroy(); self.button30 = nil; end;
        if self.imgExtra_2 ~= nil then self.imgExtra_2:destroy(); self.imgExtra_2 = nil; end;
        if self.layout24 ~= nil then self.layout24:destroy(); self.layout24 = nil; end;
        if self.colorComboBox12 ~= nil then self.colorComboBox12:destroy(); self.colorComboBox12 = nil; end;
        if self.scrollBox1 ~= nil then self.scrollBox1:destroy(); self.scrollBox1 = nil; end;
        if self.labDialogName ~= nil then self.labDialogName:destroy(); self.labDialogName = nil; end;
        if self.imgSprite_left_3 ~= nil then self.imgSprite_left_3:destroy(); self.imgSprite_left_3 = nil; end;
        if self.btnDialogExpand ~= nil then self.btnDialogExpand:destroy(); self.btnDialogExpand = nil; end;
        if self.edit2 ~= nil then self.edit2:destroy(); self.edit2 = nil; end;
        if self.labPreviewErr_left_3 ~= nil then self.labPreviewErr_left_3:destroy(); self.labPreviewErr_left_3 = nil; end;
        if self.imgExtra_5 ~= nil then self.imgExtra_5:destroy(); self.imgExtra_5 = nil; end;
        if self.layout23 ~= nil then self.layout23:destroy(); self.layout23 = nil; end;
        if self.slotConfigLeft ~= nil then self.slotConfigLeft:destroy(); self.slotConfigLeft = nil; end;
        if self.button35 ~= nil then self.button35:destroy(); self.button35 = nil; end;
        if self.imgPreview_left_1 ~= nil then self.imgPreview_left_1:destroy(); self.imgPreview_left_1 = nil; end;
        if self.layout19 ~= nil then self.layout19:destroy(); self.layout19 = nil; end;
        if self.button2 ~= nil then self.button2:destroy(); self.button2 = nil; end;
        if self.label8 ~= nil then self.label8:destroy(); self.label8 = nil; end;
        if self.layout12 ~= nil then self.layout12:destroy(); self.layout12 = nil; end;
        if self.imgPreview_center_3 ~= nil then self.imgPreview_center_3:destroy(); self.imgPreview_center_3 = nil; end;
        if self.button5 ~= nil then self.button5:destroy(); self.button5 = nil; end;
        if self.button19 ~= nil then self.button19:destroy(); self.button19 = nil; end;
        if self.layout6 ~= nil then self.layout6:destroy(); self.layout6 = nil; end;
        if self.imgPreviewExtra_5 ~= nil then self.imgPreviewExtra_5:destroy(); self.imgPreviewExtra_5 = nil; end;
        if self.label3 ~= nil then self.label3:destroy(); self.label3 = nil; end;
        if self.button12 ~= nil then self.button12:destroy(); self.button12 = nil; end;
        if self.button20 ~= nil then self.button20:destroy(); self.button20 = nil; end;
        if self.edit36 ~= nil then self.edit36:destroy(); self.edit36 = nil; end;
        if self.layout1 ~= nil then self.layout1:destroy(); self.layout1 = nil; end;
        if self.colorComboBox9 ~= nil then self.colorComboBox9:destroy(); self.colorComboBox9 = nil; end;
        if self.label18 ~= nil then self.label18:destroy(); self.label18 = nil; end;
        if self.layout41 ~= nil then self.layout41:destroy(); self.layout41 = nil; end;
        if self.label6 ~= nil then self.label6:destroy(); self.label6 = nil; end;
        if self.button17 ~= nil then self.button17:destroy(); self.button17 = nil; end;
        if self.button27 ~= nil then self.button27:destroy(); self.button27 = nil; end;
        if self.edit22 ~= nil then self.edit22:destroy(); self.edit22 = nil; end;
        if self.checkBox2 ~= nil then self.checkBox2:destroy(); self.checkBox2 = nil; end;
        if self.imgSprite_center_1 ~= nil then self.imgSprite_center_1:destroy(); self.imgSprite_center_1 = nil; end;
        if self.label21 ~= nil then self.label21:destroy(); self.label21 = nil; end;
        if self.edit11 ~= nil then self.edit11:destroy(); self.edit11 = nil; end;
        if self.rectExtra_2 ~= nil then self.rectExtra_2:destroy(); self.rectExtra_2 = nil; end;
        if self.tmrPreview ~= nil then self.tmrPreview:destroy(); self.tmrPreview = nil; end;
        if self.edit25 ~= nil then self.edit25:destroy(); self.edit25 = nil; end;
        if self.layout34 ~= nil then self.layout34:destroy(); self.layout34 = nil; end;
        if self.labConfigWarning ~= nil then self.labConfigWarning:destroy(); self.labConfigWarning = nil; end;
        if self.colorComboBox3 ~= nil then self.colorComboBox3:destroy(); self.colorComboBox3 = nil; end;
        if self.label16 ~= nil then self.label16:destroy(); self.label16 = nil; end;
        if self.rectExtrasBar ~= nil then self.rectExtrasBar:destroy(); self.rectExtrasBar = nil; end;
        if self.edit16 ~= nil then self.edit16:destroy(); self.edit16 = nil; end;
        if self.imgExtraSprite ~= nil then self.imgExtraSprite:destroy(); self.imgExtraSprite = nil; end;
        if self.label24 ~= nil then self.label24:destroy(); self.label24 = nil; end;
        if self.edit28 ~= nil then self.edit28:destroy(); self.edit28 = nil; end;
        if self.layout31 ~= nil then self.layout31:destroy(); self.layout31 = nil; end;
        if self.frmStageContainer ~= nil then self.frmStageContainer:destroy(); self.frmStageContainer = nil; end;
        if self.colorComboBox6 ~= nil then self.colorComboBox6:destroy(); self.colorComboBox6 = nil; end;
        if self.labPreviewErr_right_2 ~= nil then self.labPreviewErr_right_2:destroy(); self.labPreviewErr_right_2 = nil; end;
        if self.sceneContent ~= nil then self.sceneContent:destroy(); self.sceneContent = nil; end;
        if self.labPreviewErrExtra_3 ~= nil then self.labPreviewErrExtra_3:destroy(); self.labPreviewErrExtra_3 = nil; end;
        if self.button31 ~= nil then self.button31:destroy(); self.button31 = nil; end;
        if self.imgExtra_1 ~= nil then self.imgExtra_1:destroy(); self.imgExtra_1 = nil; end;
        if self.layout27 ~= nil then self.layout27:destroy(); self.layout27 = nil; end;
        if self.colorComboBox13 ~= nil then self.colorComboBox13:destroy(); self.colorComboBox13 = nil; end;
        if self.edit5 ~= nil then self.edit5:destroy(); self.edit5 = nil; end;
        if self.labPreviewErr_center_2 ~= nil then self.labPreviewErr_center_2:destroy(); self.labPreviewErr_center_2 = nil; end;
        if self.button36 ~= nil then self.button36:destroy(); self.button36 = nil; end;
        if self.imgExtra_4 ~= nil then self.imgExtra_4:destroy(); self.imgExtra_4 = nil; end;
        if self.layout22 ~= nil then self.layout22:destroy(); self.layout22 = nil; end;
        if self.layout16 ~= nil then self.layout16:destroy(); self.layout16 = nil; end;
        if self.button1 ~= nil then self.button1:destroy(); self.button1 = nil; end;
        if self.layout29 ~= nil then self.layout29:destroy(); self.layout29 = nil; end;
        if self.tabConfig ~= nil then self.tabConfig:destroy(); self.tabConfig = nil; end;
        if self.imgPreviewExtra_1 ~= nil then self.imgPreviewExtra_1:destroy(); self.imgPreviewExtra_1 = nil; end;
        if self.layout13 ~= nil then self.layout13:destroy(); self.layout13 = nil; end;
        if self.imgPreview_center_2 ~= nil then self.imgPreview_center_2:destroy(); self.imgPreview_center_2 = nil; end;
        if self.button4 ~= nil then self.button4:destroy(); self.button4 = nil; end;
        if self.edit32 ~= nil then self.edit32:destroy(); self.edit32 = nil; end;
        if self.layout5 ~= nil then self.layout5:destroy(); self.layout5 = nil; end;
        if self.imgPreviewExtra_4 ~= nil then self.imgPreviewExtra_4:destroy(); self.imgPreviewExtra_4 = nil; end;
        if self.frmStage ~= nil then self.frmStage:destroy(); self.frmStage = nil; end;
        if self.label2 ~= nil then self.label2:destroy(); self.label2 = nil; end;
        if self.button13 ~= nil then self.button13:destroy(); self.button13 = nil; end;
        if self.edit18 ~= nil then self.edit18:destroy(); self.edit18 = nil; end;
        if self.button23 ~= nil then self.button23:destroy(); self.button23 = nil; end;
        if self.edit37 ~= nil then self.edit37:destroy(); self.edit37 = nil; end;
        if self.checkBox6 ~= nil then self.checkBox6:destroy(); self.checkBox6 = nil; end;
        if self.colorComboBox8 ~= nil then self.colorComboBox8:destroy(); self.colorComboBox8 = nil; end;
        if self.slotConfigRight ~= nil then self.slotConfigRight:destroy(); self.slotConfigRight = nil; end;
        if self.label19 ~= nil then self.label19:destroy(); self.label19 = nil; end;
        if self.layout40 ~= nil then self.layout40:destroy(); self.layout40 = nil; end;
        if self.label5 ~= nil then self.label5:destroy(); self.label5 = nil; end;
        if self.button14 ~= nil then self.button14:destroy(); self.button14 = nil; end;
        if self.button26 ~= nil then self.button26:destroy(); self.button26 = nil; end;
        if self.edit21 ~= nil then self.edit21:destroy(); self.edit21 = nil; end;
        if self.layout38 ~= nil then self.layout38:destroy(); self.layout38 = nil; end;
        if self.checkBox3 ~= nil then self.checkBox3:destroy(); self.checkBox3 = nil; end;
        if self.imgSprite_center_2 ~= nil then self.imgSprite_center_2:destroy(); self.imgSprite_center_2 = nil; end;
        if self.label12 ~= nil then self.label12:destroy(); self.label12 = nil; end;
        if self.tcMain ~= nil then self.tcMain:destroy(); self.tcMain = nil; end;
        if self.edit12 ~= nil then self.edit12:destroy(); self.edit12 = nil; end;
        if self.rectExtra_3 ~= nil then self.rectExtra_3:destroy(); self.rectExtra_3 = nil; end;
        if self.label20 ~= nil then self.label20:destroy(); self.label20 = nil; end;
        if self.edit24 ~= nil then self.edit24:destroy(); self.edit24 = nil; end;
        if self.tmrFade ~= nil then self.tmrFade:destroy(); self.tmrFade = nil; end;
        if self.layout35 ~= nil then self.layout35:destroy(); self.layout35 = nil; end;
        if self.colorComboBox2 ~= nil then self.colorComboBox2:destroy(); self.colorComboBox2 = nil; end;
        if self.label17 ~= nil then self.label17:destroy(); self.label17 = nil; end;
        if self.label27 ~= nil then self.label27:destroy(); self.label27 = nil; end;
        if self.edit17 ~= nil then self.edit17:destroy(); self.edit17 = nil; end;
        if self.layout32 ~= nil then self.layout32:destroy(); self.layout32 = nil; end;
        if self.labPreviewErrExtra_4 ~= nil then self.labPreviewErrExtra_4:destroy(); self.labPreviewErrExtra_4 = nil; end;
        if self.edit1 ~= nil then self.edit1:destroy(); self.edit1 = nil; end;
        if self.button32 ~= nil then self.button32:destroy(); self.button32 = nil; end;
        if self.layout26 ~= nil then self.layout26:destroy(); self.layout26 = nil; end;
        if self.colorComboBox14 ~= nil then self.colorComboBox14:destroy(); self.colorComboBox14 = nil; end;
        if self.edit4 ~= nil then self.edit4:destroy(); self.edit4 = nil; end;
        if self.labPreviewErr_center_3 ~= nil then self.labPreviewErr_center_3:destroy(); self.labPreviewErr_center_3 = nil; end;
        if self.labPreviewErr_left_1 ~= nil then self.labPreviewErr_left_1:destroy(); self.labPreviewErr_left_1 = nil; end;
        if self.imgPreview_right_1 ~= nil then self.imgPreview_right_1:destroy(); self.imgPreview_right_1 = nil; end;
        if self.layout17 ~= nil then self.layout17:destroy(); self.layout17 = nil; end;
        if self.layout28 ~= nil then self.layout28:destroy(); self.layout28 = nil; end;
        if self.layout9 ~= nil then self.layout9:destroy(); self.layout9 = nil; end;
        if self.configContent ~= nil then self.configContent:destroy(); self.configContent = nil; end;
        if self.layout10 ~= nil then self.layout10:destroy(); self.layout10 = nil; end;
        if self.imgPreview_center_1 ~= nil then self.imgPreview_center_1:destroy(); self.imgPreview_center_1 = nil; end;
        if self.edit33 ~= nil then self.edit33:destroy(); self.edit33 = nil; end;
        if self.layout4 ~= nil then self.layout4:destroy(); self.layout4 = nil; end;
        if self.edit19 ~= nil then self.edit19:destroy(); self.edit19 = nil; end;
        if self.label1 ~= nil then self.label1:destroy(); self.label1 = nil; end;
        if self.button10 ~= nil then self.button10:destroy(); self.button10 = nil; end;
        if self.button22 ~= nil then self.button22:destroy(); self.button22 = nil; end;
        if self.edit34 ~= nil then self.edit34:destroy(); self.edit34 = nil; end;
        if self.panelConfig ~= nil then self.panelConfig:destroy(); self.panelConfig = nil; end;
        if self.checkBox7 ~= nil then self.checkBox7:destroy(); self.checkBox7 = nil; end;
        if self.label4 ~= nil then self.label4:destroy(); self.label4 = nil; end;
        if self.button15 ~= nil then self.button15:destroy(); self.button15 = nil; end;
        if self.button29 ~= nil then self.button29:destroy(); self.button29 = nil; end;
        if self.edit20 ~= nil then self.edit20:destroy(); self.edit20 = nil; end;
        if self.layout39 ~= nil then self.layout39:destroy(); self.layout39 = nil; end;
        if self.imgSprite_center_3 ~= nil then self.imgSprite_center_3:destroy(); self.imgSprite_center_3 = nil; end;
        if self.label13 ~= nil then self.label13:destroy(); self.label13 = nil; end;
        if self.label23 ~= nil then self.label23:destroy(); self.label23 = nil; end;
        if self.edit13 ~= nil then self.edit13:destroy(); self.edit13 = nil; end;
        if self.rectExtra_4 ~= nil then self.rectExtra_4:destroy(); self.rectExtra_4 = nil; end;
        if self.imgBackground ~= nil then self.imgBackground:destroy(); self.imgBackground = nil; end;
        if self.layout36 ~= nil then self.layout36:destroy(); self.layout36 = nil; end;
        if self.colorComboBox5 ~= nil then self.colorComboBox5:destroy(); self.colorComboBox5 = nil; end;
        if self.labPreviewErr_right_1 ~= nil then self.labPreviewErr_right_1:destroy(); self.labPreviewErr_right_1 = nil; end;
        if self.label14 ~= nil then self.label14:destroy(); self.label14 = nil; end;
        if self.label26 ~= nil then self.label26:destroy(); self.label26 = nil; end;
        if self.imgSprite_right_3 ~= nil then self.imgSprite_right_3:destroy(); self.imgSprite_right_3 = nil; end;
        if self.layout33 ~= nil then self.layout33:destroy(); self.layout33 = nil; end;
        if self.slotConfigCenter ~= nil then self.slotConfigCenter:destroy(); self.slotConfigCenter = nil; end;
        if self.colorComboBox10 ~= nil then self.colorComboBox10:destroy(); self.colorComboBox10 = nil; end;
        if self.imgSprite_left_1 ~= nil then self.imgSprite_left_1:destroy(); self.imgSprite_left_1 = nil; end;
        if self.labPreviewErrExtra_5 ~= nil then self.labPreviewErrExtra_5:destroy(); self.labPreviewErrExtra_5 = nil; end;
        if self.button9 ~= nil then self.button9:destroy(); self.button9 = nil; end;
        if self.button33 ~= nil then self.button33:destroy(); self.button33 = nil; end;
        if self.layout21 ~= nil then self.layout21:destroy(); self.layout21 = nil; end;
        if self.colorComboBox15 ~= nil then self.colorComboBox15:destroy(); self.colorComboBox15 = nil; end;
        if self.imgPreview_left_3 ~= nil then self.imgPreview_left_3:destroy(); self.imgPreview_left_3 = nil; end;
        if self.edit7 ~= nil then self.edit7:destroy(); self.edit7 = nil; end;
        if self.labDialogContent ~= nil then self.labDialogContent:destroy(); self.labDialogContent = nil; end;
        if self.imgPreview_right_2 ~= nil then self.imgPreview_right_2:destroy(); self.imgPreview_right_2 = nil; end;
        if self.layout14 ~= nil then self.layout14:destroy(); self.layout14 = nil; end;
        if self.button7 ~= nil then self.button7:destroy(); self.button7 = nil; end;
        self:_oldLFMDestroy();
    end;

    obj:endUpdate();

    return obj;
end;

function newfrmVNScene()
    local retObj = nil;
    __o_rrpgObjs.beginObjectsLoading();

    __o_Utils.tryFinally(
      function()
        retObj = constructNew_frmVNScene();
      end,
      function()
        __o_rrpgObjs.endObjectsLoading();
      end);

    assert(retObj ~= nil);
    return retObj;
end;

local _frmVNScene = {
    newEditor = newfrmVNScene, 
    new = newfrmVNScene, 
    name = "frmVNScene", 
    dataType = "br.GodsCorpse.VNScene", 
    formType = "sheetTemplate", 
    formComponentName = "form", 
    cacheMode = "none", 
    title = "Visual Novel Scene", 
    description=""};

frmVNScene = _frmVNScene;
Firecast.registrarForm(_frmVNScene);
Firecast.registrarDataType(_frmVNScene);

return _frmVNScene;
