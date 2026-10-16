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

        local MAX_EXTRAS   = 6
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

        -- ── Rotação de camadas ───────────────────────────────────────

        local function applySlotOrder(slotId, frontLayer)
            local imgs = slotControls(slotId)
            local urls = slotUrls[slotId]
            local o = {
                frontLayer,
                (frontLayer % 3) + 1,
                ((frontLayer + 1) % 3) + 1
            }
            imgs[1].src = urls[o[1]]
            imgs[2].src = urls[o[2]]
            imgs[3].src = urls[o[3]]
        end

        -- ── Foco global entre slots ───────────────────────────────────

        local function applySlotFocus(activeSlotId)
            for _, sid in ipairs({"left", "center", "right"}) do
                local imgs = slotControls(sid)
                if sid == activeSlotId then
                    imgs[1].opacity = 1.0
                    imgs[2].opacity = 0.45
                    imgs[3].opacity = 0.25
                else
                    imgs[1].opacity = 0.18
                    imgs[2].opacity = 0.12
                    imgs[3].opacity = 0.08
                end
            end
        end

        -- ── Botão de foco manual ─────────────────────────────────────

        local function setFocus(slotId, layer)
            applySlotOrder(slotId, layer)
            applySlotFocus(slotId)
            -- Esconde sprite de extra temporário
            self.imgExtraSprite.visible = false
        end

        -- ── Limpar configuração ──────────────────────────────────────

        -- ── Limpar cena ──────────────────────────────────────────────

        local function clearScene()
            self.rectDialog.visible     = false
            self.imgDialogAvatar.visible = false
            self.imgExtraSprite.visible  = false
            -- Volta todos os slots para opacidade total
            for _, sid in ipairs({"left", "center", "right"}) do
                local imgs = slotControls(sid)
                imgs[1].opacity = 1.0
                imgs[2].opacity = 0.45
                imgs[3].opacity = 0.25
            end
        end

        -- ── Carrega configurações ────────────────────────────────────

        local function loadConfig()
            local node = sheet
            self.imgBackground.src = (node and node.bgUrl) or ""

            npcMap    = {}
            npcColors = {}
            extraUrls = {}

            for _, slotId in ipairs({"left", "center", "right"}) do
                local visible = (node and node["slot_" .. slotId .. "_visible"]) == true

                for layer = 1, 3 do
                    local url   = (node and node["slot_" .. slotId .. "_url"   .. layer]) or ""
                    local name  = (node and node["slot_" .. slotId .. "_npc"   .. layer]) or ""
                    local color = (node and node["slot_" .. slotId .. "_color" .. layer]) or "#a89fd8"
                    slotUrls[slotId][layer] = url
                    if name ~= "" then
                        npcMap[name:lower()]    = { slot = slotId, layer = layer }
                        npcColors[name:lower()] = color
                    end
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
                    if prevImg then prevImg.src = slotUrls[slotId][layer] end
                end
            end

            for i = 1, MAX_EXTRAS do
                local npcName = (node and node["extra_" .. i .. "_npc"])   or ""
                local url     = (node and node["extra_" .. i .. "_url"])   or ""
                local color   = (node and node["extra_" .. i .. "_color"]) or "#a89fd8"
                extraUrls[i]  = url
                local ctrls   = extraControls(i)
                ctrls.img.src      = url
                ctrls.rect.visible = (url ~= "" or npcName ~= "")
                ctrls.img.visible  = (url ~= "")

                if npcName ~= "" then
                    npcMap[npcName:lower()]    = { extra = i }
                    npcColors[npcName:lower()] = color
                end

                -- Preview na config
                local prevImg = self["imgPreviewExtra_" .. i]
                if prevImg then prevImg.src = url end
            end
        end

        -- ── Limpar configuração ──────────────────────────────────────

        local function clearConfig()
            local node = sheet
            if not node then return end

            node.bgUrl = ""

            for _, slotId in ipairs({"left", "center", "right"}) do
                node["slot_" .. slotId .. "_visible"] = false
                for layer = 1, 3 do
                    node["slot_" .. slotId .. "_npc"   .. layer] = ""
                    node["slot_" .. slotId .. "_url"   .. layer] = ""
                    node["slot_" .. slotId .. "_color" .. layer] = ""
                end
            end

            for i = 1, MAX_EXTRAS do
                node["extra_" .. i .. "_npc"]   = ""
                node["extra_" .. i .. "_url"]   = ""
                node["extra_" .. i .. "_color"] = ""
            end

            loadConfig()
        end

        -- ── Diálogo ──────────────────────────────────────────────────

        local function showDialog(npcName, content, avatarUrl)
            local color = npcColors[npcName:lower()] or "#a89fd8"
            self.labDialogName.text      = npcName or ""
            self.labDialogName.fontColor = color
            self.labDialogContent.text   = content or ""
            self.rectDialog.visible      = true

            -- Avatar
            if avatarUrl and avatarUrl ~= "" then
                self.imgDialogAvatar.src     = avatarUrl
                self.imgDialogAvatar.visible = true
                -- Recua o texto para dar espaço ao avatar
                self.labDialogName.left    = 100
                self.labDialogName.width   = 1145
                self.labDialogContent.left = 100
                self.labDialogContent.width = 1145
            else
                self.imgDialogAvatar.visible = false
                self.labDialogName.left    = 35
                self.labDialogName.width   = 1210
                self.labDialogContent.left = 35
                self.labDialogContent.width = 1210
            end
        end

        -- ── Chat ─────────────────────────────────────────────────────

        local function onChatMessage(msg)
            local logRec = msg.logRec
            if not logRec then return end
            local msgContent = logRec.msg
            if not msgContent then return end

            local content     = msgContent.content or ""
            local impersonate = msgContent.impersonation
            if not impersonate then return end

            if impersonate.mode == "character" then
                local npcName = impersonate.name or ""
                local entry   = npcMap[npcName:lower()]

                if entry then
                    if entry.slot then
                        -- NPC de slot normal
                        local avatarUrl = slotUrls[entry.slot][entry.layer]
                        if sheet then
                            sheet["slot_" .. entry.slot .. "_front"] = tostring(entry.layer)
                        end
                        applySlotOrder(entry.slot, entry.layer)
                        applySlotFocus(entry.slot)
                        self.imgExtraSprite.visible = false
                        showDialog(npcName, content, avatarUrl)

                    elseif entry.extra then
                        -- Extra entra em cena no slot centro temporariamente
                        local url = extraUrls[entry.extra] or ""
                        self.imgExtraSprite.src     = url
                        self.imgExtraSprite.visible = true
                        -- Escurece os slots para dar destaque ao extra
                        for _, sid in ipairs({"left", "center", "right"}) do
                            local imgs = slotControls(sid)
                            imgs[1].opacity = 0.18
                            imgs[2].opacity = 0.12
                            imgs[3].opacity = 0.08
                        end
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
                self.labDialogContent.text   = msgContent.content or ""
                self.rectDialog.visible      = true
                self.labDialogName.left  = 35; self.labDialogName.width  = 1210
                self.labDialogContent.left = 35; self.labDialogContent.width = 1210
                applySlotFocus(nil)
            end
        end

        -- ── Init ─────────────────────────────────────────────────────

        local function enterPresentation()
            self.barControle.visible  = false
            self.panelConfig.visible  = false
            self.btnVoltar.visible    = true
            local s = math.min(
                self.frmStageContainer.width  / 1280,
                self.frmStageContainer.height / 600
            )
            self.frmStage.scaleX = s
            self.frmStage.scaleY = s
        end

        local function exitPresentation()
            self.barControle.visible = true
            self.btnVoltar.visible   = false
            self.frmStage.scaleX     = 1
            self.frmStage.scaleY     = 1
        end

        local function init()
            loadConfig()
            if chatReceiver == nil then
                chatReceiver = Firecast.Messaging.newReceiver("ChatMessageEx", onChatMessage)
            end
        end
    



    


    obj.barControle = GUI.fromHandle(_obj_newObject("layout"));
    obj.barControle:setParent(obj);
    obj.barControle:setAlign("top");
    obj.barControle:setHeight(28);
    obj.barControle:setName("barControle");

    obj.button1 = GUI.fromHandle(_obj_newObject("button"));
    obj.button1:setParent(obj.barControle);
    obj.button1:setAlign("left");
    obj.button1:setWidth(110);
    obj.button1:setHeight(28);
    obj.button1:setText("⚙ Configuração");
    obj.button1:setFontSize(11);
    obj.button1:setName("button1");

    obj.button2 = GUI.fromHandle(_obj_newObject("button"));
    obj.button2:setParent(obj.barControle);
    obj.button2:setAlign("left");
    obj.button2:setWidth(80);
    obj.button2:setHeight(28);
    obj.button2:setText("✕ Limpar");
    obj.button2:setFontSize(11);
    obj.button2:setMargins({left=4});
    obj.button2:setName("button2");

    obj.button3 = GUI.fromHandle(_obj_newObject("button"));
    obj.button3:setParent(obj.barControle);
    obj.button3:setAlign("left");
    obj.button3:setWidth(110);
    obj.button3:setHeight(28);
    obj.button3:setText("▶ Apresentação");
    obj.button3:setFontSize(11);
    obj.button3:setMargins({left=4});
    obj.button3:setName("button3");

    obj.panelConfig = GUI.fromHandle(_obj_newObject("layout"));
    obj.panelConfig:setParent(obj);
    obj.panelConfig:setAlign("right");
    obj.panelConfig:setWidth(440);
    obj.panelConfig:setName("panelConfig");
    obj.panelConfig:setVisible(true);

    obj.scrollBox1 = GUI.fromHandle(_obj_newObject("scrollBox"));
    obj.scrollBox1:setParent(obj.panelConfig);
    obj.scrollBox1:setAlign("client");
    obj.scrollBox1:setName("scrollBox1");

    obj.layout1 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout1:setParent(obj.scrollBox1);
    obj.layout1:setLeft(0);
    obj.layout1:setTop(0);
    obj.layout1:setWidth(416);
    obj.layout1:setHeight(1900);
    obj.layout1:setMargins({left=12, right=12, top=12, bottom=12});
    obj.layout1:setName("layout1");

    obj.button4 = GUI.fromHandle(_obj_newObject("button"));
    obj.button4:setParent(obj.layout1);
    obj.button4:setAlign("top");
    obj.button4:setHeight(28);
    obj.button4:setText("🗑 Limpar tudo (nomes e URLs)");
    obj.button4:setMargins({bottom=8});
    obj.button4:setName("button4");

    obj.label1 = GUI.fromHandle(_obj_newObject("label"));
    obj.label1:setParent(obj.layout1);
    obj.label1:setText("Imagem de Fundo");
    obj.label1:setAlign("top");
    obj.label1:setHeight(20);
    lfm_setPropAsString(obj.label1, "fontStyle", "bold");
    obj.label1:setFontSize(13);
    obj.label1:setName("label1");

    obj.edit1 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit1:setParent(obj.layout1);
    obj.edit1:setAlign("top");
    obj.edit1:setHeight(28);
    obj.edit1:setField("bgUrl");
    obj.edit1:setHint("URL da imagem de fundo");
    obj.edit1:setMargins({bottom=16});
    obj.edit1:setName("edit1");

    obj.label2 = GUI.fromHandle(_obj_newObject("label"));
    obj.label2:setParent(obj.layout1);
    obj.label2:setText("Slots de Personagem");
    obj.label2:setAlign("top");
    obj.label2:setHeight(20);
    lfm_setPropAsString(obj.label2, "fontStyle", "bold");
    obj.label2:setFontSize(13);
    obj.label2:setName("label2");

    obj.label3 = GUI.fromHandle(_obj_newObject("label"));
    obj.label3:setParent(obj.layout1);
    obj.label3:setText("Cada slot tem 3 camadas. Use ★ para foco manual.");
    obj.label3:setAlign("top");
    obj.label3:setHeight(18);
    obj.label3:setFontSize(11);
    obj.label3:setFontColor("Gray");
    obj.label3:setMargins({bottom=8});
    obj.label3:setName("label3");

    obj.layout2 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout2:setParent(obj.layout1);
    obj.layout2:setAlign("top");
    obj.layout2:setHeight(18);
    obj.layout2:setMargins({bottom=4});
    obj.layout2:setName("layout2");

    obj.label4 = GUI.fromHandle(_obj_newObject("label"));
    obj.label4:setParent(obj.layout2);
    obj.label4:setText("Camada");
    obj.label4:setAlign("left");
    obj.label4:setWidth(44);
    obj.label4:setFontSize(10);
    obj.label4:setFontColor("Gray");
    obj.label4:setName("label4");

    obj.label5 = GUI.fromHandle(_obj_newObject("label"));
    obj.label5:setParent(obj.layout2);
    obj.label5:setText("Nome");
    obj.label5:setAlign("left");
    obj.label5:setWidth(100);
    obj.label5:setFontSize(10);
    obj.label5:setFontColor("Gray");
    obj.label5:setMargins({left=4});
    obj.label5:setName("label5");

    obj.label6 = GUI.fromHandle(_obj_newObject("label"));
    obj.label6:setParent(obj.layout2);
    obj.label6:setText("Cor");
    obj.label6:setAlign("left");
    obj.label6:setWidth(52);
    obj.label6:setFontSize(10);
    obj.label6:setFontColor("Gray");
    obj.label6:setMargins({left=4});
    obj.label6:setName("label6");

    obj.label7 = GUI.fromHandle(_obj_newObject("label"));
    obj.label7:setParent(obj.layout2);
    obj.label7:setText("URL");
    obj.label7:setAlign("client");
    obj.label7:setFontSize(10);
    obj.label7:setFontColor("Gray");
    obj.label7:setMargins({left=4});
    obj.label7:setName("label7");

    obj.label8 = GUI.fromHandle(_obj_newObject("label"));
    obj.label8:setParent(obj.layout2);
    obj.label8:setText("Prev");
    obj.label8:setAlign("right");
    obj.label8:setWidth(36);
    obj.label8:setFontSize(10);
    obj.label8:setFontColor("Gray");
    obj.label8:setHorzTextAlign("center");
    obj.label8:setMargins({right=4});
    obj.label8:setName("label8");

    obj.label9 = GUI.fromHandle(_obj_newObject("label"));
    obj.label9:setParent(obj.layout2);
    obj.label9:setText("★");
    obj.label9:setAlign("right");
    obj.label9:setWidth(28);
    obj.label9:setFontSize(10);
    obj.label9:setFontColor("Gray");
    obj.label9:setHorzTextAlign("center");
    obj.label9:setName("label9");

    obj.layout3 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout3:setParent(obj.layout1);
    obj.layout3:setAlign("top");
    obj.layout3:setHeight(20);
    obj.layout3:setMargins({bottom=4});
    obj.layout3:setName("layout3");

    obj.label10 = GUI.fromHandle(_obj_newObject("label"));
    obj.label10:setParent(obj.layout3);
    obj.label10:setText("Esquerda");
    obj.label10:setAlign("left");
    obj.label10:setWidth(100);
    obj.label10:setFontSize(11);
    lfm_setPropAsString(obj.label10, "fontStyle", "bold");
    obj.label10:setVertTextAlign("center");
    obj.label10:setName("label10");

    obj.checkBox1 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.checkBox1:setParent(obj.layout3);
    obj.checkBox1:setAlign("client");
    obj.checkBox1:setField("slot_left_visible");
    obj.checkBox1:setText("Visível");
    obj.checkBox1:setMargins({left=4});
    obj.checkBox1:setName("checkBox1");

    obj.layout4 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout4:setParent(obj.layout1);
    obj.layout4:setAlign("top");
    obj.layout4:setHeight(36);
    obj.layout4:setMargins({bottom=4});
    obj.layout4:setName("layout4");

    obj.label11 = GUI.fromHandle(_obj_newObject("label"));
    obj.label11:setParent(obj.layout4);
    obj.label11:setText("Frente");
    obj.label11:setAlign("left");
    obj.label11:setWidth(44);
    obj.label11:setFontSize(10);
    obj.label11:setFontColor("Gray");
    obj.label11:setVertTextAlign("center");
    obj.label11:setName("label11");

    obj.edit2 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit2:setParent(obj.layout4);
    obj.edit2:setAlign("left");
    obj.edit2:setWidth(100);
    obj.edit2:setField("slot_left_npc1");
    obj.edit2:setHint("Nome");
    obj.edit2:setMargins({left=4, right=4});
    obj.edit2:setName("edit2");

    obj.edit3 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit3:setParent(obj.layout4);
    obj.edit3:setAlign("left");
    obj.edit3:setWidth(52);
    obj.edit3:setField("slot_left_color1");
    obj.edit3:setHint("#a89fd8");
    obj.edit3:setMargins({right=4});
    obj.edit3:setName("edit3");

    obj.edit4 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit4:setParent(obj.layout4);
    obj.edit4:setAlign("client");
    obj.edit4:setField("slot_left_url1");
    obj.edit4:setHint("URL");
    obj.edit4:setMargins({right=4});
    obj.edit4:setName("edit4");

    obj.imgPreview_left_1 = GUI.fromHandle(_obj_newObject("image"));
    obj.imgPreview_left_1:setParent(obj.layout4);
    obj.imgPreview_left_1:setName("imgPreview_left_1");
    obj.imgPreview_left_1:setAlign("right");
    obj.imgPreview_left_1:setWidth(36);
    obj.imgPreview_left_1:setHeight(36);
    obj.imgPreview_left_1:setStyle("proportional");
    obj.imgPreview_left_1:setSRC("");
    obj.imgPreview_left_1:setMargins({right=4});

    obj.button5 = GUI.fromHandle(_obj_newObject("button"));
    obj.button5:setParent(obj.layout4);
    obj.button5:setAlign("right");
    obj.button5:setWidth(28);
    obj.button5:setHeight(36);
    obj.button5:setText("★");
    obj.button5:setName("button5");

    obj.layout5 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout5:setParent(obj.layout1);
    obj.layout5:setAlign("top");
    obj.layout5:setHeight(36);
    obj.layout5:setMargins({bottom=4});
    obj.layout5:setName("layout5");

    obj.label12 = GUI.fromHandle(_obj_newObject("label"));
    obj.label12:setParent(obj.layout5);
    obj.label12:setText("Meio");
    obj.label12:setAlign("left");
    obj.label12:setWidth(44);
    obj.label12:setFontSize(10);
    obj.label12:setFontColor("Gray");
    obj.label12:setVertTextAlign("center");
    obj.label12:setName("label12");

    obj.edit5 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit5:setParent(obj.layout5);
    obj.edit5:setAlign("left");
    obj.edit5:setWidth(100);
    obj.edit5:setField("slot_left_npc2");
    obj.edit5:setHint("Nome");
    obj.edit5:setMargins({left=4, right=4});
    obj.edit5:setName("edit5");

    obj.edit6 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit6:setParent(obj.layout5);
    obj.edit6:setAlign("left");
    obj.edit6:setWidth(52);
    obj.edit6:setField("slot_left_color2");
    obj.edit6:setHint("#a89fd8");
    obj.edit6:setMargins({right=4});
    obj.edit6:setName("edit6");

    obj.edit7 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit7:setParent(obj.layout5);
    obj.edit7:setAlign("client");
    obj.edit7:setField("slot_left_url2");
    obj.edit7:setHint("URL");
    obj.edit7:setMargins({right=4});
    obj.edit7:setName("edit7");

    obj.imgPreview_left_2 = GUI.fromHandle(_obj_newObject("image"));
    obj.imgPreview_left_2:setParent(obj.layout5);
    obj.imgPreview_left_2:setName("imgPreview_left_2");
    obj.imgPreview_left_2:setAlign("right");
    obj.imgPreview_left_2:setWidth(36);
    obj.imgPreview_left_2:setHeight(36);
    obj.imgPreview_left_2:setStyle("proportional");
    obj.imgPreview_left_2:setSRC("");
    obj.imgPreview_left_2:setMargins({right=4});

    obj.button6 = GUI.fromHandle(_obj_newObject("button"));
    obj.button6:setParent(obj.layout5);
    obj.button6:setAlign("right");
    obj.button6:setWidth(28);
    obj.button6:setHeight(36);
    obj.button6:setText("★");
    obj.button6:setName("button6");

    obj.layout6 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout6:setParent(obj.layout1);
    obj.layout6:setAlign("top");
    obj.layout6:setHeight(36);
    obj.layout6:setMargins({bottom=12});
    obj.layout6:setName("layout6");

    obj.label13 = GUI.fromHandle(_obj_newObject("label"));
    obj.label13:setParent(obj.layout6);
    obj.label13:setText("Atrás");
    obj.label13:setAlign("left");
    obj.label13:setWidth(44);
    obj.label13:setFontSize(10);
    obj.label13:setFontColor("Gray");
    obj.label13:setVertTextAlign("center");
    obj.label13:setName("label13");

    obj.edit8 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit8:setParent(obj.layout6);
    obj.edit8:setAlign("left");
    obj.edit8:setWidth(100);
    obj.edit8:setField("slot_left_npc3");
    obj.edit8:setHint("Nome");
    obj.edit8:setMargins({left=4, right=4});
    obj.edit8:setName("edit8");

    obj.edit9 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit9:setParent(obj.layout6);
    obj.edit9:setAlign("left");
    obj.edit9:setWidth(52);
    obj.edit9:setField("slot_left_color3");
    obj.edit9:setHint("#a89fd8");
    obj.edit9:setMargins({right=4});
    obj.edit9:setName("edit9");

    obj.edit10 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit10:setParent(obj.layout6);
    obj.edit10:setAlign("client");
    obj.edit10:setField("slot_left_url3");
    obj.edit10:setHint("URL");
    obj.edit10:setMargins({right=4});
    obj.edit10:setName("edit10");

    obj.imgPreview_left_3 = GUI.fromHandle(_obj_newObject("image"));
    obj.imgPreview_left_3:setParent(obj.layout6);
    obj.imgPreview_left_3:setName("imgPreview_left_3");
    obj.imgPreview_left_3:setAlign("right");
    obj.imgPreview_left_3:setWidth(36);
    obj.imgPreview_left_3:setHeight(36);
    obj.imgPreview_left_3:setStyle("proportional");
    obj.imgPreview_left_3:setSRC("");
    obj.imgPreview_left_3:setMargins({right=4});

    obj.button7 = GUI.fromHandle(_obj_newObject("button"));
    obj.button7:setParent(obj.layout6);
    obj.button7:setAlign("right");
    obj.button7:setWidth(28);
    obj.button7:setHeight(36);
    obj.button7:setText("★");
    obj.button7:setName("button7");

    obj.layout7 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout7:setParent(obj.layout1);
    obj.layout7:setAlign("top");
    obj.layout7:setHeight(20);
    obj.layout7:setMargins({bottom=4});
    obj.layout7:setName("layout7");

    obj.label14 = GUI.fromHandle(_obj_newObject("label"));
    obj.label14:setParent(obj.layout7);
    obj.label14:setText("Centro");
    obj.label14:setAlign("left");
    obj.label14:setWidth(100);
    obj.label14:setFontSize(11);
    lfm_setPropAsString(obj.label14, "fontStyle", "bold");
    obj.label14:setVertTextAlign("center");
    obj.label14:setName("label14");

    obj.checkBox2 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.checkBox2:setParent(obj.layout7);
    obj.checkBox2:setAlign("client");
    obj.checkBox2:setField("slot_center_visible");
    obj.checkBox2:setText("Visível");
    obj.checkBox2:setMargins({left=4});
    obj.checkBox2:setName("checkBox2");

    obj.layout8 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout8:setParent(obj.layout1);
    obj.layout8:setAlign("top");
    obj.layout8:setHeight(36);
    obj.layout8:setMargins({bottom=4});
    obj.layout8:setName("layout8");

    obj.label15 = GUI.fromHandle(_obj_newObject("label"));
    obj.label15:setParent(obj.layout8);
    obj.label15:setText("Frente");
    obj.label15:setAlign("left");
    obj.label15:setWidth(44);
    obj.label15:setFontSize(10);
    obj.label15:setFontColor("Gray");
    obj.label15:setVertTextAlign("center");
    obj.label15:setName("label15");

    obj.edit11 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit11:setParent(obj.layout8);
    obj.edit11:setAlign("left");
    obj.edit11:setWidth(100);
    obj.edit11:setField("slot_center_npc1");
    obj.edit11:setHint("Nome");
    obj.edit11:setMargins({left=4, right=4});
    obj.edit11:setName("edit11");

    obj.edit12 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit12:setParent(obj.layout8);
    obj.edit12:setAlign("left");
    obj.edit12:setWidth(52);
    obj.edit12:setField("slot_center_color1");
    obj.edit12:setHint("#a89fd8");
    obj.edit12:setMargins({right=4});
    obj.edit12:setName("edit12");

    obj.edit13 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit13:setParent(obj.layout8);
    obj.edit13:setAlign("client");
    obj.edit13:setField("slot_center_url1");
    obj.edit13:setHint("URL");
    obj.edit13:setMargins({right=4});
    obj.edit13:setName("edit13");

    obj.imgPreview_center_1 = GUI.fromHandle(_obj_newObject("image"));
    obj.imgPreview_center_1:setParent(obj.layout8);
    obj.imgPreview_center_1:setName("imgPreview_center_1");
    obj.imgPreview_center_1:setAlign("right");
    obj.imgPreview_center_1:setWidth(36);
    obj.imgPreview_center_1:setHeight(36);
    obj.imgPreview_center_1:setStyle("proportional");
    obj.imgPreview_center_1:setSRC("");
    obj.imgPreview_center_1:setMargins({right=4});

    obj.button8 = GUI.fromHandle(_obj_newObject("button"));
    obj.button8:setParent(obj.layout8);
    obj.button8:setAlign("right");
    obj.button8:setWidth(28);
    obj.button8:setHeight(36);
    obj.button8:setText("★");
    obj.button8:setName("button8");

    obj.layout9 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout9:setParent(obj.layout1);
    obj.layout9:setAlign("top");
    obj.layout9:setHeight(36);
    obj.layout9:setMargins({bottom=4});
    obj.layout9:setName("layout9");

    obj.label16 = GUI.fromHandle(_obj_newObject("label"));
    obj.label16:setParent(obj.layout9);
    obj.label16:setText("Meio");
    obj.label16:setAlign("left");
    obj.label16:setWidth(44);
    obj.label16:setFontSize(10);
    obj.label16:setFontColor("Gray");
    obj.label16:setVertTextAlign("center");
    obj.label16:setName("label16");

    obj.edit14 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit14:setParent(obj.layout9);
    obj.edit14:setAlign("left");
    obj.edit14:setWidth(100);
    obj.edit14:setField("slot_center_npc2");
    obj.edit14:setHint("Nome");
    obj.edit14:setMargins({left=4, right=4});
    obj.edit14:setName("edit14");

    obj.edit15 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit15:setParent(obj.layout9);
    obj.edit15:setAlign("left");
    obj.edit15:setWidth(52);
    obj.edit15:setField("slot_center_color2");
    obj.edit15:setHint("#a89fd8");
    obj.edit15:setMargins({right=4});
    obj.edit15:setName("edit15");

    obj.edit16 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit16:setParent(obj.layout9);
    obj.edit16:setAlign("client");
    obj.edit16:setField("slot_center_url2");
    obj.edit16:setHint("URL");
    obj.edit16:setMargins({right=4});
    obj.edit16:setName("edit16");

    obj.imgPreview_center_2 = GUI.fromHandle(_obj_newObject("image"));
    obj.imgPreview_center_2:setParent(obj.layout9);
    obj.imgPreview_center_2:setName("imgPreview_center_2");
    obj.imgPreview_center_2:setAlign("right");
    obj.imgPreview_center_2:setWidth(36);
    obj.imgPreview_center_2:setHeight(36);
    obj.imgPreview_center_2:setStyle("proportional");
    obj.imgPreview_center_2:setSRC("");
    obj.imgPreview_center_2:setMargins({right=4});

    obj.button9 = GUI.fromHandle(_obj_newObject("button"));
    obj.button9:setParent(obj.layout9);
    obj.button9:setAlign("right");
    obj.button9:setWidth(28);
    obj.button9:setHeight(36);
    obj.button9:setText("★");
    obj.button9:setName("button9");

    obj.layout10 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout10:setParent(obj.layout1);
    obj.layout10:setAlign("top");
    obj.layout10:setHeight(36);
    obj.layout10:setMargins({bottom=12});
    obj.layout10:setName("layout10");

    obj.label17 = GUI.fromHandle(_obj_newObject("label"));
    obj.label17:setParent(obj.layout10);
    obj.label17:setText("Atrás");
    obj.label17:setAlign("left");
    obj.label17:setWidth(44);
    obj.label17:setFontSize(10);
    obj.label17:setFontColor("Gray");
    obj.label17:setVertTextAlign("center");
    obj.label17:setName("label17");

    obj.edit17 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit17:setParent(obj.layout10);
    obj.edit17:setAlign("left");
    obj.edit17:setWidth(100);
    obj.edit17:setField("slot_center_npc3");
    obj.edit17:setHint("Nome");
    obj.edit17:setMargins({left=4, right=4});
    obj.edit17:setName("edit17");

    obj.edit18 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit18:setParent(obj.layout10);
    obj.edit18:setAlign("left");
    obj.edit18:setWidth(52);
    obj.edit18:setField("slot_center_color3");
    obj.edit18:setHint("#a89fd8");
    obj.edit18:setMargins({right=4});
    obj.edit18:setName("edit18");

    obj.edit19 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit19:setParent(obj.layout10);
    obj.edit19:setAlign("client");
    obj.edit19:setField("slot_center_url3");
    obj.edit19:setHint("URL");
    obj.edit19:setMargins({right=4});
    obj.edit19:setName("edit19");

    obj.imgPreview_center_3 = GUI.fromHandle(_obj_newObject("image"));
    obj.imgPreview_center_3:setParent(obj.layout10);
    obj.imgPreview_center_3:setName("imgPreview_center_3");
    obj.imgPreview_center_3:setAlign("right");
    obj.imgPreview_center_3:setWidth(36);
    obj.imgPreview_center_3:setHeight(36);
    obj.imgPreview_center_3:setStyle("proportional");
    obj.imgPreview_center_3:setSRC("");
    obj.imgPreview_center_3:setMargins({right=4});

    obj.button10 = GUI.fromHandle(_obj_newObject("button"));
    obj.button10:setParent(obj.layout10);
    obj.button10:setAlign("right");
    obj.button10:setWidth(28);
    obj.button10:setHeight(36);
    obj.button10:setText("★");
    obj.button10:setName("button10");

    obj.layout11 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout11:setParent(obj.layout1);
    obj.layout11:setAlign("top");
    obj.layout11:setHeight(20);
    obj.layout11:setMargins({bottom=4});
    obj.layout11:setName("layout11");

    obj.label18 = GUI.fromHandle(_obj_newObject("label"));
    obj.label18:setParent(obj.layout11);
    obj.label18:setText("Direita");
    obj.label18:setAlign("left");
    obj.label18:setWidth(100);
    obj.label18:setFontSize(11);
    lfm_setPropAsString(obj.label18, "fontStyle", "bold");
    obj.label18:setVertTextAlign("center");
    obj.label18:setName("label18");

    obj.checkBox3 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.checkBox3:setParent(obj.layout11);
    obj.checkBox3:setAlign("client");
    obj.checkBox3:setField("slot_right_visible");
    obj.checkBox3:setText("Visível");
    obj.checkBox3:setMargins({left=4});
    obj.checkBox3:setName("checkBox3");

    obj.layout12 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout12:setParent(obj.layout1);
    obj.layout12:setAlign("top");
    obj.layout12:setHeight(36);
    obj.layout12:setMargins({bottom=4});
    obj.layout12:setName("layout12");

    obj.label19 = GUI.fromHandle(_obj_newObject("label"));
    obj.label19:setParent(obj.layout12);
    obj.label19:setText("Frente");
    obj.label19:setAlign("left");
    obj.label19:setWidth(44);
    obj.label19:setFontSize(10);
    obj.label19:setFontColor("Gray");
    obj.label19:setVertTextAlign("center");
    obj.label19:setName("label19");

    obj.edit20 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit20:setParent(obj.layout12);
    obj.edit20:setAlign("left");
    obj.edit20:setWidth(100);
    obj.edit20:setField("slot_right_npc1");
    obj.edit20:setHint("Nome");
    obj.edit20:setMargins({left=4, right=4});
    obj.edit20:setName("edit20");

    obj.edit21 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit21:setParent(obj.layout12);
    obj.edit21:setAlign("left");
    obj.edit21:setWidth(52);
    obj.edit21:setField("slot_right_color1");
    obj.edit21:setHint("#a89fd8");
    obj.edit21:setMargins({right=4});
    obj.edit21:setName("edit21");

    obj.edit22 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit22:setParent(obj.layout12);
    obj.edit22:setAlign("client");
    obj.edit22:setField("slot_right_url1");
    obj.edit22:setHint("URL");
    obj.edit22:setMargins({right=4});
    obj.edit22:setName("edit22");

    obj.imgPreview_right_1 = GUI.fromHandle(_obj_newObject("image"));
    obj.imgPreview_right_1:setParent(obj.layout12);
    obj.imgPreview_right_1:setName("imgPreview_right_1");
    obj.imgPreview_right_1:setAlign("right");
    obj.imgPreview_right_1:setWidth(36);
    obj.imgPreview_right_1:setHeight(36);
    obj.imgPreview_right_1:setStyle("proportional");
    obj.imgPreview_right_1:setSRC("");
    obj.imgPreview_right_1:setMargins({right=4});

    obj.button11 = GUI.fromHandle(_obj_newObject("button"));
    obj.button11:setParent(obj.layout12);
    obj.button11:setAlign("right");
    obj.button11:setWidth(28);
    obj.button11:setHeight(36);
    obj.button11:setText("★");
    obj.button11:setName("button11");

    obj.layout13 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout13:setParent(obj.layout1);
    obj.layout13:setAlign("top");
    obj.layout13:setHeight(36);
    obj.layout13:setMargins({bottom=4});
    obj.layout13:setName("layout13");

    obj.label20 = GUI.fromHandle(_obj_newObject("label"));
    obj.label20:setParent(obj.layout13);
    obj.label20:setText("Meio");
    obj.label20:setAlign("left");
    obj.label20:setWidth(44);
    obj.label20:setFontSize(10);
    obj.label20:setFontColor("Gray");
    obj.label20:setVertTextAlign("center");
    obj.label20:setName("label20");

    obj.edit23 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit23:setParent(obj.layout13);
    obj.edit23:setAlign("left");
    obj.edit23:setWidth(100);
    obj.edit23:setField("slot_right_npc2");
    obj.edit23:setHint("Nome");
    obj.edit23:setMargins({left=4, right=4});
    obj.edit23:setName("edit23");

    obj.edit24 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit24:setParent(obj.layout13);
    obj.edit24:setAlign("left");
    obj.edit24:setWidth(52);
    obj.edit24:setField("slot_right_color2");
    obj.edit24:setHint("#a89fd8");
    obj.edit24:setMargins({right=4});
    obj.edit24:setName("edit24");

    obj.edit25 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit25:setParent(obj.layout13);
    obj.edit25:setAlign("client");
    obj.edit25:setField("slot_right_url2");
    obj.edit25:setHint("URL");
    obj.edit25:setMargins({right=4});
    obj.edit25:setName("edit25");

    obj.imgPreview_right_2 = GUI.fromHandle(_obj_newObject("image"));
    obj.imgPreview_right_2:setParent(obj.layout13);
    obj.imgPreview_right_2:setName("imgPreview_right_2");
    obj.imgPreview_right_2:setAlign("right");
    obj.imgPreview_right_2:setWidth(36);
    obj.imgPreview_right_2:setHeight(36);
    obj.imgPreview_right_2:setStyle("proportional");
    obj.imgPreview_right_2:setSRC("");
    obj.imgPreview_right_2:setMargins({right=4});

    obj.button12 = GUI.fromHandle(_obj_newObject("button"));
    obj.button12:setParent(obj.layout13);
    obj.button12:setAlign("right");
    obj.button12:setWidth(28);
    obj.button12:setHeight(36);
    obj.button12:setText("★");
    obj.button12:setName("button12");

    obj.layout14 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout14:setParent(obj.layout1);
    obj.layout14:setAlign("top");
    obj.layout14:setHeight(36);
    obj.layout14:setMargins({bottom=12});
    obj.layout14:setName("layout14");

    obj.label21 = GUI.fromHandle(_obj_newObject("label"));
    obj.label21:setParent(obj.layout14);
    obj.label21:setText("Atrás");
    obj.label21:setAlign("left");
    obj.label21:setWidth(44);
    obj.label21:setFontSize(10);
    obj.label21:setFontColor("Gray");
    obj.label21:setVertTextAlign("center");
    obj.label21:setName("label21");

    obj.edit26 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit26:setParent(obj.layout14);
    obj.edit26:setAlign("left");
    obj.edit26:setWidth(100);
    obj.edit26:setField("slot_right_npc3");
    obj.edit26:setHint("Nome");
    obj.edit26:setMargins({left=4, right=4});
    obj.edit26:setName("edit26");

    obj.edit27 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit27:setParent(obj.layout14);
    obj.edit27:setAlign("left");
    obj.edit27:setWidth(52);
    obj.edit27:setField("slot_right_color3");
    obj.edit27:setHint("#a89fd8");
    obj.edit27:setMargins({right=4});
    obj.edit27:setName("edit27");

    obj.edit28 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit28:setParent(obj.layout14);
    obj.edit28:setAlign("client");
    obj.edit28:setField("slot_right_url3");
    obj.edit28:setHint("URL");
    obj.edit28:setMargins({right=4});
    obj.edit28:setName("edit28");

    obj.imgPreview_right_3 = GUI.fromHandle(_obj_newObject("image"));
    obj.imgPreview_right_3:setParent(obj.layout14);
    obj.imgPreview_right_3:setName("imgPreview_right_3");
    obj.imgPreview_right_3:setAlign("right");
    obj.imgPreview_right_3:setWidth(36);
    obj.imgPreview_right_3:setHeight(36);
    obj.imgPreview_right_3:setStyle("proportional");
    obj.imgPreview_right_3:setSRC("");
    obj.imgPreview_right_3:setMargins({right=4});

    obj.button13 = GUI.fromHandle(_obj_newObject("button"));
    obj.button13:setParent(obj.layout14);
    obj.button13:setAlign("right");
    obj.button13:setWidth(28);
    obj.button13:setHeight(36);
    obj.button13:setText("★");
    obj.button13:setName("button13");

    obj.label22 = GUI.fromHandle(_obj_newObject("label"));
    obj.label22:setParent(obj.layout1);
    obj.label22:setText("Personagens Extras");
    obj.label22:setAlign("top");
    obj.label22:setHeight(20);
    lfm_setPropAsString(obj.label22, "fontStyle", "bold");
    obj.label22:setFontSize(13);
    obj.label22:setName("label22");

    obj.label23 = GUI.fromHandle(_obj_newObject("label"));
    obj.label23:setParent(obj.layout1);
    obj.label23:setText("Quando falam, aparecem no centro temporariamente.");
    obj.label23:setAlign("top");
    obj.label23:setHeight(18);
    obj.label23:setFontSize(11);
    obj.label23:setFontColor("Gray");
    obj.label23:setMargins({bottom=8});
    obj.label23:setName("label23");

    obj.layout15 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout15:setParent(obj.layout1);
    obj.layout15:setAlign("top");
    obj.layout15:setHeight(18);
    obj.layout15:setMargins({bottom=4});
    obj.layout15:setName("layout15");

    obj.label24 = GUI.fromHandle(_obj_newObject("label"));
    obj.label24:setParent(obj.layout15);
    obj.label24:setText("Nome");
    obj.label24:setAlign("left");
    obj.label24:setWidth(100);
    obj.label24:setFontSize(10);
    obj.label24:setFontColor("Gray");
    obj.label24:setName("label24");

    obj.label25 = GUI.fromHandle(_obj_newObject("label"));
    obj.label25:setParent(obj.layout15);
    obj.label25:setText("Cor");
    obj.label25:setAlign("left");
    obj.label25:setWidth(52);
    obj.label25:setFontSize(10);
    obj.label25:setFontColor("Gray");
    obj.label25:setMargins({left=4});
    obj.label25:setName("label25");

    obj.label26 = GUI.fromHandle(_obj_newObject("label"));
    obj.label26:setParent(obj.layout15);
    obj.label26:setText("URL");
    obj.label26:setAlign("client");
    obj.label26:setFontSize(10);
    obj.label26:setFontColor("Gray");
    obj.label26:setMargins({left=4});
    obj.label26:setName("label26");

    obj.label27 = GUI.fromHandle(_obj_newObject("label"));
    obj.label27:setParent(obj.layout15);
    obj.label27:setText("Prev");
    obj.label27:setAlign("right");
    obj.label27:setWidth(36);
    obj.label27:setFontSize(10);
    obj.label27:setFontColor("Gray");
    obj.label27:setHorzTextAlign("center");
    obj.label27:setName("label27");

    obj.layout16 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout16:setParent(obj.layout1);
    obj.layout16:setAlign("top");
    obj.layout16:setHeight(36);
    obj.layout16:setMargins({bottom=6});
    obj.layout16:setName("layout16");

    obj.edit29 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit29:setParent(obj.layout16);
    obj.edit29:setAlign("left");
    obj.edit29:setWidth(100);
    obj.edit29:setField("extra_1_npc");
    obj.edit29:setHint("Extra 1");
    obj.edit29:setMargins({right=4});
    obj.edit29:setName("edit29");

    obj.edit30 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit30:setParent(obj.layout16);
    obj.edit30:setAlign("left");
    obj.edit30:setWidth(52);
    obj.edit30:setField("extra_1_color");
    obj.edit30:setHint("#a89fd8");
    obj.edit30:setMargins({right=4});
    obj.edit30:setName("edit30");

    obj.edit31 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit31:setParent(obj.layout16);
    obj.edit31:setAlign("client");
    obj.edit31:setField("extra_1_url");
    obj.edit31:setHint("URL");
    obj.edit31:setMargins({right=4});
    obj.edit31:setName("edit31");

    obj.imgPreviewExtra_1 = GUI.fromHandle(_obj_newObject("image"));
    obj.imgPreviewExtra_1:setParent(obj.layout16);
    obj.imgPreviewExtra_1:setName("imgPreviewExtra_1");
    obj.imgPreviewExtra_1:setAlign("right");
    obj.imgPreviewExtra_1:setWidth(36);
    obj.imgPreviewExtra_1:setHeight(36);
    obj.imgPreviewExtra_1:setStyle("proportional");
    obj.imgPreviewExtra_1:setSRC("");

    obj.layout17 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout17:setParent(obj.layout1);
    obj.layout17:setAlign("top");
    obj.layout17:setHeight(36);
    obj.layout17:setMargins({bottom=6});
    obj.layout17:setName("layout17");

    obj.edit32 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit32:setParent(obj.layout17);
    obj.edit32:setAlign("left");
    obj.edit32:setWidth(100);
    obj.edit32:setField("extra_2_npc");
    obj.edit32:setHint("Extra 2");
    obj.edit32:setMargins({right=4});
    obj.edit32:setName("edit32");

    obj.edit33 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit33:setParent(obj.layout17);
    obj.edit33:setAlign("left");
    obj.edit33:setWidth(52);
    obj.edit33:setField("extra_2_color");
    obj.edit33:setHint("#a89fd8");
    obj.edit33:setMargins({right=4});
    obj.edit33:setName("edit33");

    obj.edit34 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit34:setParent(obj.layout17);
    obj.edit34:setAlign("client");
    obj.edit34:setField("extra_2_url");
    obj.edit34:setHint("URL");
    obj.edit34:setMargins({right=4});
    obj.edit34:setName("edit34");

    obj.imgPreviewExtra_2 = GUI.fromHandle(_obj_newObject("image"));
    obj.imgPreviewExtra_2:setParent(obj.layout17);
    obj.imgPreviewExtra_2:setName("imgPreviewExtra_2");
    obj.imgPreviewExtra_2:setAlign("right");
    obj.imgPreviewExtra_2:setWidth(36);
    obj.imgPreviewExtra_2:setHeight(36);
    obj.imgPreviewExtra_2:setStyle("proportional");
    obj.imgPreviewExtra_2:setSRC("");

    obj.layout18 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout18:setParent(obj.layout1);
    obj.layout18:setAlign("top");
    obj.layout18:setHeight(36);
    obj.layout18:setMargins({bottom=6});
    obj.layout18:setName("layout18");

    obj.edit35 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit35:setParent(obj.layout18);
    obj.edit35:setAlign("left");
    obj.edit35:setWidth(100);
    obj.edit35:setField("extra_3_npc");
    obj.edit35:setHint("Extra 3");
    obj.edit35:setMargins({right=4});
    obj.edit35:setName("edit35");

    obj.edit36 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit36:setParent(obj.layout18);
    obj.edit36:setAlign("left");
    obj.edit36:setWidth(52);
    obj.edit36:setField("extra_3_color");
    obj.edit36:setHint("#a89fd8");
    obj.edit36:setMargins({right=4});
    obj.edit36:setName("edit36");

    obj.edit37 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit37:setParent(obj.layout18);
    obj.edit37:setAlign("client");
    obj.edit37:setField("extra_3_url");
    obj.edit37:setHint("URL");
    obj.edit37:setMargins({right=4});
    obj.edit37:setName("edit37");

    obj.imgPreviewExtra_3 = GUI.fromHandle(_obj_newObject("image"));
    obj.imgPreviewExtra_3:setParent(obj.layout18);
    obj.imgPreviewExtra_3:setName("imgPreviewExtra_3");
    obj.imgPreviewExtra_3:setAlign("right");
    obj.imgPreviewExtra_3:setWidth(36);
    obj.imgPreviewExtra_3:setHeight(36);
    obj.imgPreviewExtra_3:setStyle("proportional");
    obj.imgPreviewExtra_3:setSRC("");

    obj.layout19 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout19:setParent(obj.layout1);
    obj.layout19:setAlign("top");
    obj.layout19:setHeight(36);
    obj.layout19:setMargins({bottom=6});
    obj.layout19:setName("layout19");

    obj.edit38 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit38:setParent(obj.layout19);
    obj.edit38:setAlign("left");
    obj.edit38:setWidth(100);
    obj.edit38:setField("extra_4_npc");
    obj.edit38:setHint("Extra 4");
    obj.edit38:setMargins({right=4});
    obj.edit38:setName("edit38");

    obj.edit39 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit39:setParent(obj.layout19);
    obj.edit39:setAlign("left");
    obj.edit39:setWidth(52);
    obj.edit39:setField("extra_4_color");
    obj.edit39:setHint("#a89fd8");
    obj.edit39:setMargins({right=4});
    obj.edit39:setName("edit39");

    obj.edit40 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit40:setParent(obj.layout19);
    obj.edit40:setAlign("client");
    obj.edit40:setField("extra_4_url");
    obj.edit40:setHint("URL");
    obj.edit40:setMargins({right=4});
    obj.edit40:setName("edit40");

    obj.imgPreviewExtra_4 = GUI.fromHandle(_obj_newObject("image"));
    obj.imgPreviewExtra_4:setParent(obj.layout19);
    obj.imgPreviewExtra_4:setName("imgPreviewExtra_4");
    obj.imgPreviewExtra_4:setAlign("right");
    obj.imgPreviewExtra_4:setWidth(36);
    obj.imgPreviewExtra_4:setHeight(36);
    obj.imgPreviewExtra_4:setStyle("proportional");
    obj.imgPreviewExtra_4:setSRC("");

    obj.layout20 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout20:setParent(obj.layout1);
    obj.layout20:setAlign("top");
    obj.layout20:setHeight(36);
    obj.layout20:setMargins({bottom=6});
    obj.layout20:setName("layout20");

    obj.edit41 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit41:setParent(obj.layout20);
    obj.edit41:setAlign("left");
    obj.edit41:setWidth(100);
    obj.edit41:setField("extra_5_npc");
    obj.edit41:setHint("Extra 5");
    obj.edit41:setMargins({right=4});
    obj.edit41:setName("edit41");

    obj.edit42 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit42:setParent(obj.layout20);
    obj.edit42:setAlign("left");
    obj.edit42:setWidth(52);
    obj.edit42:setField("extra_5_color");
    obj.edit42:setHint("#a89fd8");
    obj.edit42:setMargins({right=4});
    obj.edit42:setName("edit42");

    obj.edit43 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit43:setParent(obj.layout20);
    obj.edit43:setAlign("client");
    obj.edit43:setField("extra_5_url");
    obj.edit43:setHint("URL");
    obj.edit43:setMargins({right=4});
    obj.edit43:setName("edit43");

    obj.imgPreviewExtra_5 = GUI.fromHandle(_obj_newObject("image"));
    obj.imgPreviewExtra_5:setParent(obj.layout20);
    obj.imgPreviewExtra_5:setName("imgPreviewExtra_5");
    obj.imgPreviewExtra_5:setAlign("right");
    obj.imgPreviewExtra_5:setWidth(36);
    obj.imgPreviewExtra_5:setHeight(36);
    obj.imgPreviewExtra_5:setStyle("proportional");
    obj.imgPreviewExtra_5:setSRC("");

    obj.layout21 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout21:setParent(obj.layout1);
    obj.layout21:setAlign("top");
    obj.layout21:setHeight(36);
    obj.layout21:setMargins({bottom=16});
    obj.layout21:setName("layout21");

    obj.edit44 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit44:setParent(obj.layout21);
    obj.edit44:setAlign("left");
    obj.edit44:setWidth(100);
    obj.edit44:setField("extra_6_npc");
    obj.edit44:setHint("Extra 6");
    obj.edit44:setMargins({right=4});
    obj.edit44:setName("edit44");

    obj.edit45 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit45:setParent(obj.layout21);
    obj.edit45:setAlign("left");
    obj.edit45:setWidth(52);
    obj.edit45:setField("extra_6_color");
    obj.edit45:setHint("#a89fd8");
    obj.edit45:setMargins({right=4});
    obj.edit45:setName("edit45");

    obj.edit46 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit46:setParent(obj.layout21);
    obj.edit46:setAlign("client");
    obj.edit46:setField("extra_6_url");
    obj.edit46:setHint("URL");
    obj.edit46:setMargins({right=4});
    obj.edit46:setName("edit46");

    obj.imgPreviewExtra_6 = GUI.fromHandle(_obj_newObject("image"));
    obj.imgPreviewExtra_6:setParent(obj.layout21);
    obj.imgPreviewExtra_6:setName("imgPreviewExtra_6");
    obj.imgPreviewExtra_6:setAlign("right");
    obj.imgPreviewExtra_6:setWidth(36);
    obj.imgPreviewExtra_6:setHeight(36);
    obj.imgPreviewExtra_6:setStyle("proportional");
    obj.imgPreviewExtra_6:setSRC("");

    obj.frmStageContainer = GUI.fromHandle(_obj_newObject("layout"));
    obj.frmStageContainer:setParent(obj);
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
    obj.imgSprite_center_3:setLeft(625);
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
    obj.imgSprite_center_2:setLeft(561);
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
    obj.imgSprite_center_1:setLeft(529);
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
    obj.imgSprite_right_3:setLeft(1100);
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
    obj.imgSprite_right_2:setLeft(1036);
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
    obj.imgSprite_right_1:setLeft(1033);
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
    obj.rectExtrasBar:setTop(467);
    obj.rectExtrasBar:setWidth(1280);
    obj.rectExtrasBar:setHeight(56);
    obj.rectExtrasBar:setColor("#0a0820");
    obj.rectExtrasBar:setOpacity(0.75);

    obj.rectExtra_1 = GUI.fromHandle(_obj_newObject("rectangle"));
    obj.rectExtra_1:setParent(obj.frmStage);
    obj.rectExtra_1:setName("rectExtra_1");
    obj.rectExtra_1:setLeft(426);
    obj.rectExtra_1:setTop(471);
    obj.rectExtra_1:setWidth(58);
    obj.rectExtra_1:setHeight(48);
    obj.rectExtra_1:setColor("#1a1535");
    obj.rectExtra_1:setOpacity(0.9);
    obj.rectExtra_1:setVisible(false);

    obj.imgExtra_1 = GUI.fromHandle(_obj_newObject("image"));
    obj.imgExtra_1:setParent(obj.frmStage);
    obj.imgExtra_1:setName("imgExtra_1");
    obj.imgExtra_1:setLeft(431);
    obj.imgExtra_1:setTop(474);
    obj.imgExtra_1:setWidth(49);
    obj.imgExtra_1:setHeight(41);
    obj.imgExtra_1:setStyle("proportional");
    obj.imgExtra_1:setVisible(false);
    obj.imgExtra_1:setSRC("");

    obj.rectExtra_2 = GUI.fromHandle(_obj_newObject("rectangle"));
    obj.rectExtra_2:setParent(obj.frmStage);
    obj.rectExtra_2:setName("rectExtra_2");
    obj.rectExtra_2:setLeft(493);
    obj.rectExtra_2:setTop(471);
    obj.rectExtra_2:setWidth(58);
    obj.rectExtra_2:setHeight(48);
    obj.rectExtra_2:setColor("#1a1535");
    obj.rectExtra_2:setOpacity(0.9);
    obj.rectExtra_2:setVisible(false);

    obj.imgExtra_2 = GUI.fromHandle(_obj_newObject("image"));
    obj.imgExtra_2:setParent(obj.frmStage);
    obj.imgExtra_2:setName("imgExtra_2");
    obj.imgExtra_2:setLeft(497);
    obj.imgExtra_2:setTop(474);
    obj.imgExtra_2:setWidth(49);
    obj.imgExtra_2:setHeight(41);
    obj.imgExtra_2:setStyle("proportional");
    obj.imgExtra_2:setVisible(false);
    obj.imgExtra_2:setSRC("");

    obj.rectExtra_3 = GUI.fromHandle(_obj_newObject("rectangle"));
    obj.rectExtra_3:setParent(obj.frmStage);
    obj.rectExtra_3:setName("rectExtra_3");
    obj.rectExtra_3:setLeft(560);
    obj.rectExtra_3:setTop(471);
    obj.rectExtra_3:setWidth(58);
    obj.rectExtra_3:setHeight(48);
    obj.rectExtra_3:setColor("#1a1535");
    obj.rectExtra_3:setOpacity(0.9);
    obj.rectExtra_3:setVisible(false);

    obj.imgExtra_3 = GUI.fromHandle(_obj_newObject("image"));
    obj.imgExtra_3:setParent(obj.frmStage);
    obj.imgExtra_3:setName("imgExtra_3");
    obj.imgExtra_3:setLeft(564);
    obj.imgExtra_3:setTop(474);
    obj.imgExtra_3:setWidth(49);
    obj.imgExtra_3:setHeight(41);
    obj.imgExtra_3:setStyle("proportional");
    obj.imgExtra_3:setVisible(false);
    obj.imgExtra_3:setSRC("");

    obj.rectExtra_4 = GUI.fromHandle(_obj_newObject("rectangle"));
    obj.rectExtra_4:setParent(obj.frmStage);
    obj.rectExtra_4:setName("rectExtra_4");
    obj.rectExtra_4:setLeft(627);
    obj.rectExtra_4:setTop(471);
    obj.rectExtra_4:setWidth(58);
    obj.rectExtra_4:setHeight(48);
    obj.rectExtra_4:setColor("#1a1535");
    obj.rectExtra_4:setOpacity(0.9);
    obj.rectExtra_4:setVisible(false);

    obj.imgExtra_4 = GUI.fromHandle(_obj_newObject("image"));
    obj.imgExtra_4:setParent(obj.frmStage);
    obj.imgExtra_4:setName("imgExtra_4");
    obj.imgExtra_4:setLeft(631);
    obj.imgExtra_4:setTop(474);
    obj.imgExtra_4:setWidth(49);
    obj.imgExtra_4:setHeight(41);
    obj.imgExtra_4:setStyle("proportional");
    obj.imgExtra_4:setVisible(false);
    obj.imgExtra_4:setSRC("");

    obj.rectExtra_5 = GUI.fromHandle(_obj_newObject("rectangle"));
    obj.rectExtra_5:setParent(obj.frmStage);
    obj.rectExtra_5:setName("rectExtra_5");
    obj.rectExtra_5:setLeft(694);
    obj.rectExtra_5:setTop(471);
    obj.rectExtra_5:setWidth(58);
    obj.rectExtra_5:setHeight(48);
    obj.rectExtra_5:setColor("#1a1535");
    obj.rectExtra_5:setOpacity(0.9);
    obj.rectExtra_5:setVisible(false);

    obj.imgExtra_5 = GUI.fromHandle(_obj_newObject("image"));
    obj.imgExtra_5:setParent(obj.frmStage);
    obj.imgExtra_5:setName("imgExtra_5");
    obj.imgExtra_5:setLeft(698);
    obj.imgExtra_5:setTop(474);
    obj.imgExtra_5:setWidth(49);
    obj.imgExtra_5:setHeight(41);
    obj.imgExtra_5:setStyle("proportional");
    obj.imgExtra_5:setVisible(false);
    obj.imgExtra_5:setSRC("");

    obj.rectExtra_6 = GUI.fromHandle(_obj_newObject("rectangle"));
    obj.rectExtra_6:setParent(obj.frmStage);
    obj.rectExtra_6:setName("rectExtra_6");
    obj.rectExtra_6:setLeft(761);
    obj.rectExtra_6:setTop(471);
    obj.rectExtra_6:setWidth(58);
    obj.rectExtra_6:setHeight(48);
    obj.rectExtra_6:setColor("#1a1535");
    obj.rectExtra_6:setOpacity(0.9);
    obj.rectExtra_6:setVisible(false);

    obj.imgExtra_6 = GUI.fromHandle(_obj_newObject("image"));
    obj.imgExtra_6:setParent(obj.frmStage);
    obj.imgExtra_6:setName("imgExtra_6");
    obj.imgExtra_6:setLeft(765);
    obj.imgExtra_6:setTop(474);
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

    obj.btnVoltar = GUI.fromHandle(_obj_newObject("button"));
    obj.btnVoltar:setParent(obj.frmStage);
    obj.btnVoltar:setName("btnVoltar");
    obj.btnVoltar:setLeft(4);
    obj.btnVoltar:setTop(4);
    obj.btnVoltar:setWidth(80);
    obj.btnVoltar:setHeight(22);
    obj.btnVoltar:setText("◀ Voltar");
    obj.btnVoltar:setFontSize(9);
    obj.btnVoltar:setVisible(false);

    obj._e_event0 = obj:addEventListener("onNodeReady",
        function ()
            init()
        end);

    obj._e_event1 = obj.button1:addEventListener("onClick",
        function (event)
            self.panelConfig.visible = not self.panelConfig.visible
        end);

    obj._e_event2 = obj.button2:addEventListener("onClick",
        function (event)
            clearScene()
        end);

    obj._e_event3 = obj.button3:addEventListener("onClick",
        function (event)
            enterPresentation()
        end);

    obj._e_event4 = obj.button4:addEventListener("onClick",
        function (event)
            clearConfig()
        end);

    obj._e_event5 = obj.edit1:addEventListener("onExit",
        function ()
            loadConfig()
        end);

    obj._e_event6 = obj.checkBox1:addEventListener("onChange",
        function ()
            loadConfig()
        end);

    obj._e_event7 = obj.edit2:addEventListener("onExit",
        function ()
            loadConfig()
        end);

    obj._e_event8 = obj.edit3:addEventListener("onExit",
        function ()
            loadConfig()
        end);

    obj._e_event9 = obj.edit4:addEventListener("onExit",
        function ()
            loadConfig()
        end);

    obj._e_event10 = obj.button5:addEventListener("onClick",
        function (event)
            setFocus('left', 1)
        end);

    obj._e_event11 = obj.edit5:addEventListener("onExit",
        function ()
            loadConfig()
        end);

    obj._e_event12 = obj.edit6:addEventListener("onExit",
        function ()
            loadConfig()
        end);

    obj._e_event13 = obj.edit7:addEventListener("onExit",
        function ()
            loadConfig()
        end);

    obj._e_event14 = obj.button6:addEventListener("onClick",
        function (event)
            setFocus('left', 2)
        end);

    obj._e_event15 = obj.edit8:addEventListener("onExit",
        function ()
            loadConfig()
        end);

    obj._e_event16 = obj.edit9:addEventListener("onExit",
        function ()
            loadConfig()
        end);

    obj._e_event17 = obj.edit10:addEventListener("onExit",
        function ()
            loadConfig()
        end);

    obj._e_event18 = obj.button7:addEventListener("onClick",
        function (event)
            setFocus('left', 3)
        end);

    obj._e_event19 = obj.checkBox2:addEventListener("onChange",
        function ()
            loadConfig()
        end);

    obj._e_event20 = obj.edit11:addEventListener("onExit",
        function ()
            loadConfig()
        end);

    obj._e_event21 = obj.edit12:addEventListener("onExit",
        function ()
            loadConfig()
        end);

    obj._e_event22 = obj.edit13:addEventListener("onExit",
        function ()
            loadConfig()
        end);

    obj._e_event23 = obj.button8:addEventListener("onClick",
        function (event)
            setFocus('center', 1)
        end);

    obj._e_event24 = obj.edit14:addEventListener("onExit",
        function ()
            loadConfig()
        end);

    obj._e_event25 = obj.edit15:addEventListener("onExit",
        function ()
            loadConfig()
        end);

    obj._e_event26 = obj.edit16:addEventListener("onExit",
        function ()
            loadConfig()
        end);

    obj._e_event27 = obj.button9:addEventListener("onClick",
        function (event)
            setFocus('center', 2)
        end);

    obj._e_event28 = obj.edit17:addEventListener("onExit",
        function ()
            loadConfig()
        end);

    obj._e_event29 = obj.edit18:addEventListener("onExit",
        function ()
            loadConfig()
        end);

    obj._e_event30 = obj.edit19:addEventListener("onExit",
        function ()
            loadConfig()
        end);

    obj._e_event31 = obj.button10:addEventListener("onClick",
        function (event)
            setFocus('center', 3)
        end);

    obj._e_event32 = obj.checkBox3:addEventListener("onChange",
        function ()
            loadConfig()
        end);

    obj._e_event33 = obj.edit20:addEventListener("onExit",
        function ()
            loadConfig()
        end);

    obj._e_event34 = obj.edit21:addEventListener("onExit",
        function ()
            loadConfig()
        end);

    obj._e_event35 = obj.edit22:addEventListener("onExit",
        function ()
            loadConfig()
        end);

    obj._e_event36 = obj.button11:addEventListener("onClick",
        function (event)
            setFocus('right', 1)
        end);

    obj._e_event37 = obj.edit23:addEventListener("onExit",
        function ()
            loadConfig()
        end);

    obj._e_event38 = obj.edit24:addEventListener("onExit",
        function ()
            loadConfig()
        end);

    obj._e_event39 = obj.edit25:addEventListener("onExit",
        function ()
            loadConfig()
        end);

    obj._e_event40 = obj.button12:addEventListener("onClick",
        function (event)
            setFocus('right', 2)
        end);

    obj._e_event41 = obj.edit26:addEventListener("onExit",
        function ()
            loadConfig()
        end);

    obj._e_event42 = obj.edit27:addEventListener("onExit",
        function ()
            loadConfig()
        end);

    obj._e_event43 = obj.edit28:addEventListener("onExit",
        function ()
            loadConfig()
        end);

    obj._e_event44 = obj.button13:addEventListener("onClick",
        function (event)
            setFocus('right', 3)
        end);

    obj._e_event45 = obj.edit29:addEventListener("onExit",
        function ()
            loadConfig()
        end);

    obj._e_event46 = obj.edit30:addEventListener("onExit",
        function ()
            loadConfig()
        end);

    obj._e_event47 = obj.edit31:addEventListener("onExit",
        function ()
            loadConfig()
        end);

    obj._e_event48 = obj.edit32:addEventListener("onExit",
        function ()
            loadConfig()
        end);

    obj._e_event49 = obj.edit33:addEventListener("onExit",
        function ()
            loadConfig()
        end);

    obj._e_event50 = obj.edit34:addEventListener("onExit",
        function ()
            loadConfig()
        end);

    obj._e_event51 = obj.edit35:addEventListener("onExit",
        function ()
            loadConfig()
        end);

    obj._e_event52 = obj.edit36:addEventListener("onExit",
        function ()
            loadConfig()
        end);

    obj._e_event53 = obj.edit37:addEventListener("onExit",
        function ()
            loadConfig()
        end);

    obj._e_event54 = obj.edit38:addEventListener("onExit",
        function ()
            loadConfig()
        end);

    obj._e_event55 = obj.edit39:addEventListener("onExit",
        function ()
            loadConfig()
        end);

    obj._e_event56 = obj.edit40:addEventListener("onExit",
        function ()
            loadConfig()
        end);

    obj._e_event57 = obj.edit41:addEventListener("onExit",
        function ()
            loadConfig()
        end);

    obj._e_event58 = obj.edit42:addEventListener("onExit",
        function ()
            loadConfig()
        end);

    obj._e_event59 = obj.edit43:addEventListener("onExit",
        function ()
            loadConfig()
        end);

    obj._e_event60 = obj.edit44:addEventListener("onExit",
        function ()
            loadConfig()
        end);

    obj._e_event61 = obj.edit45:addEventListener("onExit",
        function ()
            loadConfig()
        end);

    obj._e_event62 = obj.edit46:addEventListener("onExit",
        function ()
            loadConfig()
        end);

    obj._e_event63 = obj.btnVoltar:addEventListener("onClick",
        function (event)
            exitPresentation()
        end);

    function obj:_releaseEvents()
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
        if self.label16 ~= nil then self.label16:destroy(); self.label16 = nil; end;
        if self.imgExtraSprite ~= nil then self.imgExtraSprite:destroy(); self.imgExtraSprite = nil; end;
        if self.imgPreviewExtra_3 ~= nil then self.imgPreviewExtra_3:destroy(); self.imgPreviewExtra_3 = nil; end;
        if self.edit28 ~= nil then self.edit28:destroy(); self.edit28 = nil; end;
        if self.rectExtrasBar ~= nil then self.rectExtrasBar:destroy(); self.rectExtrasBar = nil; end;
        if self.layout11 ~= nil then self.layout11:destroy(); self.layout11 = nil; end;
        if self.frmStageContainer ~= nil then self.frmStageContainer:destroy(); self.frmStageContainer = nil; end;
        if self.imgDialogAvatar ~= nil then self.imgDialogAvatar:destroy(); self.imgDialogAvatar = nil; end;
        if self.edit30 ~= nil then self.edit30:destroy(); self.edit30 = nil; end;
        if self.layout3 ~= nil then self.layout3:destroy(); self.layout3 = nil; end;
        if self.edit42 ~= nil then self.edit42:destroy(); self.edit42 = nil; end;
        if self.imgPreviewExtra_6 ~= nil then self.imgPreviewExtra_6:destroy(); self.imgPreviewExtra_6 = nil; end;
        if self.imgExtra_1 ~= nil then self.imgExtra_1:destroy(); self.imgExtra_1 = nil; end;
        if self.button11 ~= nil then self.button11:destroy(); self.button11 = nil; end;
        if self.edit35 ~= nil then self.edit35:destroy(); self.edit35 = nil; end;
        if self.edit5 ~= nil then self.edit5:destroy(); self.edit5 = nil; end;
        if self.imgExtra_4 ~= nil then self.imgExtra_4:destroy(); self.imgExtra_4 = nil; end;
        if self.edit27 ~= nil then self.edit27:destroy(); self.edit27 = nil; end;
        if self.checkBox1 ~= nil then self.checkBox1:destroy(); self.checkBox1 = nil; end;
        if self.layout16 ~= nil then self.layout16:destroy(); self.layout16 = nil; end;
        if self.button1 ~= nil then self.button1:destroy(); self.button1 = nil; end;
        if self.label10 ~= nil then self.label10:destroy(); self.label10 = nil; end;
        if self.edit14 ~= nil then self.edit14:destroy(); self.edit14 = nil; end;
        if self.label22 ~= nil then self.label22:destroy(); self.label22 = nil; end;
        if self.edit39 ~= nil then self.edit39:destroy(); self.edit39 = nil; end;
        if self.rectExtra_5 ~= nil then self.rectExtra_5:destroy(); self.rectExtra_5 = nil; end;
        if self.edit9 ~= nil then self.edit9:destroy(); self.edit9 = nil; end;
        if self.imgPreviewExtra_1 ~= nil then self.imgPreviewExtra_1:destroy(); self.imgPreviewExtra_1 = nil; end;
        if self.edit45 ~= nil then self.edit45:destroy(); self.edit45 = nil; end;
        if self.imgPreview_center_2 ~= nil then self.imgPreview_center_2:destroy(); self.imgPreview_center_2 = nil; end;
        if self.layout13 ~= nil then self.layout13:destroy(); self.layout13 = nil; end;
        if self.button4 ~= nil then self.button4:destroy(); self.button4 = nil; end;
        if self.label15 ~= nil then self.label15:destroy(); self.label15 = nil; end;
        if self.edit32 ~= nil then self.edit32:destroy(); self.edit32 = nil; end;
        if self.layout5 ~= nil then self.layout5:destroy(); self.layout5 = nil; end;
        if self.edit40 ~= nil then self.edit40:destroy(); self.edit40 = nil; end;
        if self.imgPreviewExtra_4 ~= nil then self.imgPreviewExtra_4:destroy(); self.imgPreviewExtra_4 = nil; end;
        if self.imgSprite_right_2 ~= nil then self.imgSprite_right_2:destroy(); self.imgSprite_right_2 = nil; end;
        if self.edit18 ~= nil then self.edit18:destroy(); self.edit18 = nil; end;
        if self.label2 ~= nil then self.label2:destroy(); self.label2 = nil; end;
        if self.button13 ~= nil then self.button13:destroy(); self.button13 = nil; end;
        if self.frmStage ~= nil then self.frmStage:destroy(); self.frmStage = nil; end;
        if self.imgExtra_3 ~= nil then self.imgExtra_3:destroy(); self.imgExtra_3 = nil; end;
        if self.edit37 ~= nil then self.edit37:destroy(); self.edit37 = nil; end;
        if self.barControle ~= nil then self.barControle:destroy(); self.barControle = nil; end;
        if self.imgSprite_left_2 ~= nil then self.imgSprite_left_2:destroy(); self.imgSprite_left_2 = nil; end;
        if self.edit3 ~= nil then self.edit3:destroy(); self.edit3 = nil; end;
        if self.button8 ~= nil then self.button8:destroy(); self.button8 = nil; end;
        if self.label19 ~= nil then self.label19:destroy(); self.label19 = nil; end;
        if self.layout20 ~= nil then self.layout20:destroy(); self.layout20 = nil; end;
        if self.label5 ~= nil then self.label5:destroy(); self.label5 = nil; end;
        if self.imgExtra_6 ~= nil then self.imgExtra_6:destroy(); self.imgExtra_6 = nil; end;
        if self.edit21 ~= nil then self.edit21:destroy(); self.edit21 = nil; end;
        if self.imgPreview_left_2 ~= nil then self.imgPreview_left_2:destroy(); self.imgPreview_left_2 = nil; end;
        if self.checkBox3 ~= nil then self.checkBox3:destroy(); self.checkBox3 = nil; end;
        if self.edit6 ~= nil then self.edit6:destroy(); self.edit6 = nil; end;
        if self.button3 ~= nil then self.button3:destroy(); self.button3 = nil; end;
        if self.label12 ~= nil then self.label12:destroy(); self.label12 = nil; end;
        if self.edit12 ~= nil then self.edit12:destroy(); self.edit12 = nil; end;
        if self.label20 ~= nil then self.label20:destroy(); self.label20 = nil; end;
        if self.layout18 ~= nil then self.layout18:destroy(); self.layout18 = nil; end;
        if self.imgSprite_center_2 ~= nil then self.imgSprite_center_2:destroy(); self.imgSprite_center_2 = nil; end;
        if self.rectExtra_3 ~= nil then self.rectExtra_3:destroy(); self.rectExtra_3 = nil; end;
        if self.edit24 ~= nil then self.edit24:destroy(); self.edit24 = nil; end;
        if self.imgPreview_right_3 ~= nil then self.imgPreview_right_3:destroy(); self.imgPreview_right_3 = nil; end;
        if self.label9 ~= nil then self.label9:destroy(); self.label9 = nil; end;
        if self.layout15 ~= nil then self.layout15:destroy(); self.layout15 = nil; end;
        if self.button6 ~= nil then self.button6:destroy(); self.button6 = nil; end;
        if self.label17 ~= nil then self.label17:destroy(); self.label17 = nil; end;
        if self.edit17 ~= nil then self.edit17:destroy(); self.edit17 = nil; end;
        if self.layout7 ~= nil then self.layout7:destroy(); self.layout7 = nil; end;
        if self.label27 ~= nil then self.label27:destroy(); self.label27 = nil; end;
        if self.imgPreviewExtra_2 ~= nil then self.imgPreviewExtra_2:destroy(); self.imgPreviewExtra_2 = nil; end;
        if self.edit46 ~= nil then self.edit46:destroy(); self.edit46 = nil; end;
        if self.edit31 ~= nil then self.edit31:destroy(); self.edit31 = nil; end;
        if self.layout2 ~= nil then self.layout2:destroy(); self.layout2 = nil; end;
        if self.edit1 ~= nil then self.edit1:destroy(); self.edit1 = nil; end;
        if self.label7 ~= nil then self.label7:destroy(); self.label7 = nil; end;
        if self.edit23 ~= nil then self.edit23:destroy(); self.edit23 = nil; end;
        if self.edit4 ~= nil then self.edit4:destroy(); self.edit4 = nil; end;
        if self.edit10 ~= nil then self.edit10:destroy(); self.edit10 = nil; end;
        if self.rectExtra_1 ~= nil then self.rectExtra_1:destroy(); self.rectExtra_1 = nil; end;
        if self.imgPreview_right_1 ~= nil then self.imgPreview_right_1:destroy(); self.imgPreview_right_1 = nil; end;
        if self.edit26 ~= nil then self.edit26:destroy(); self.edit26 = nil; end;
        if self.layout17 ~= nil then self.layout17:destroy(); self.layout17 = nil; end;
        if self.label11 ~= nil then self.label11:destroy(); self.label11 = nil; end;
        if self.label25 ~= nil then self.label25:destroy(); self.label25 = nil; end;
        if self.edit15 ~= nil then self.edit15:destroy(); self.edit15 = nil; end;
        if self.layout9 ~= nil then self.layout9:destroy(); self.layout9 = nil; end;
        if self.rectExtra_6 ~= nil then self.rectExtra_6:destroy(); self.rectExtra_6 = nil; end;
        if self.edit8 ~= nil then self.edit8:destroy(); self.edit8 = nil; end;
        if self.edit29 ~= nil then self.edit29:destroy(); self.edit29 = nil; end;
        if self.edit44 ~= nil then self.edit44:destroy(); self.edit44 = nil; end;
        if self.imgPreview_center_1 ~= nil then self.imgPreview_center_1:destroy(); self.imgPreview_center_1 = nil; end;
        if self.layout10 ~= nil then self.layout10:destroy(); self.layout10 = nil; end;
        if self.edit33 ~= nil then self.edit33:destroy(); self.edit33 = nil; end;
        if self.layout4 ~= nil then self.layout4:destroy(); self.layout4 = nil; end;
        if self.rectDialog ~= nil then self.rectDialog:destroy(); self.rectDialog = nil; end;
        if self.edit43 ~= nil then self.edit43:destroy(); self.edit43 = nil; end;
        if self.imgSprite_right_1 ~= nil then self.imgSprite_right_1:destroy(); self.imgSprite_right_1 = nil; end;
        if self.edit19 ~= nil then self.edit19:destroy(); self.edit19 = nil; end;
        if self.label1 ~= nil then self.label1:destroy(); self.label1 = nil; end;
        if self.button10 ~= nil then self.button10:destroy(); self.button10 = nil; end;
        if self.scrollBox1 ~= nil then self.scrollBox1:destroy(); self.scrollBox1 = nil; end;
        if self.imgExtra_2 ~= nil then self.imgExtra_2:destroy(); self.imgExtra_2 = nil; end;
        if self.edit34 ~= nil then self.edit34:destroy(); self.edit34 = nil; end;
        if self.imgSprite_left_3 ~= nil then self.imgSprite_left_3:destroy(); self.imgSprite_left_3 = nil; end;
        if self.labDialogName ~= nil then self.labDialogName:destroy(); self.labDialogName = nil; end;
        if self.panelConfig ~= nil then self.panelConfig:destroy(); self.panelConfig = nil; end;
        if self.edit2 ~= nil then self.edit2:destroy(); self.edit2 = nil; end;
        if self.imgExtra_5 ~= nil then self.imgExtra_5:destroy(); self.imgExtra_5 = nil; end;
        if self.label4 ~= nil then self.label4:destroy(); self.label4 = nil; end;
        if self.edit20 ~= nil then self.edit20:destroy(); self.edit20 = nil; end;
        if self.imgPreview_left_1 ~= nil then self.imgPreview_left_1:destroy(); self.imgPreview_left_1 = nil; end;
        if self.layout19 ~= nil then self.layout19:destroy(); self.layout19 = nil; end;
        if self.imgSprite_center_3 ~= nil then self.imgSprite_center_3:destroy(); self.imgSprite_center_3 = nil; end;
        if self.button2 ~= nil then self.button2:destroy(); self.button2 = nil; end;
        if self.label13 ~= nil then self.label13:destroy(); self.label13 = nil; end;
        if self.edit13 ~= nil then self.edit13:destroy(); self.edit13 = nil; end;
        if self.label23 ~= nil then self.label23:destroy(); self.label23 = nil; end;
        if self.edit38 ~= nil then self.edit38:destroy(); self.edit38 = nil; end;
        if self.rectExtra_4 ~= nil then self.rectExtra_4:destroy(); self.rectExtra_4 = nil; end;
        if self.btnVoltar ~= nil then self.btnVoltar:destroy(); self.btnVoltar = nil; end;
        if self.imgBackground ~= nil then self.imgBackground:destroy(); self.imgBackground = nil; end;
        if self.label8 ~= nil then self.label8:destroy(); self.label8 = nil; end;
        if self.imgPreview_center_3 ~= nil then self.imgPreview_center_3:destroy(); self.imgPreview_center_3 = nil; end;
        if self.layout12 ~= nil then self.layout12:destroy(); self.layout12 = nil; end;
        if self.button5 ~= nil then self.button5:destroy(); self.button5 = nil; end;
        if self.label14 ~= nil then self.label14:destroy(); self.label14 = nil; end;
        if self.label26 ~= nil then self.label26:destroy(); self.label26 = nil; end;
        if self.layout6 ~= nil then self.layout6:destroy(); self.layout6 = nil; end;
        if self.edit41 ~= nil then self.edit41:destroy(); self.edit41 = nil; end;
        if self.imgPreviewExtra_5 ~= nil then self.imgPreviewExtra_5:destroy(); self.imgPreviewExtra_5 = nil; end;
        if self.imgSprite_right_3 ~= nil then self.imgSprite_right_3:destroy(); self.imgSprite_right_3 = nil; end;
        if self.label3 ~= nil then self.label3:destroy(); self.label3 = nil; end;
        if self.button12 ~= nil then self.button12:destroy(); self.button12 = nil; end;
        if self.edit36 ~= nil then self.edit36:destroy(); self.edit36 = nil; end;
        if self.imgSprite_left_1 ~= nil then self.imgSprite_left_1:destroy(); self.imgSprite_left_1 = nil; end;
        if self.layout1 ~= nil then self.layout1:destroy(); self.layout1 = nil; end;
        if self.button9 ~= nil then self.button9:destroy(); self.button9 = nil; end;
        if self.label18 ~= nil then self.label18:destroy(); self.label18 = nil; end;
        if self.layout21 ~= nil then self.layout21:destroy(); self.layout21 = nil; end;
        if self.label6 ~= nil then self.label6:destroy(); self.label6 = nil; end;
        if self.edit22 ~= nil then self.edit22:destroy(); self.edit22 = nil; end;
        if self.imgPreview_left_3 ~= nil then self.imgPreview_left_3:destroy(); self.imgPreview_left_3 = nil; end;
        if self.checkBox2 ~= nil then self.checkBox2:destroy(); self.checkBox2 = nil; end;
        if self.edit7 ~= nil then self.edit7:destroy(); self.edit7 = nil; end;
        if self.imgSprite_center_1 ~= nil then self.imgSprite_center_1:destroy(); self.imgSprite_center_1 = nil; end;
        if self.label21 ~= nil then self.label21:destroy(); self.label21 = nil; end;
        if self.edit11 ~= nil then self.edit11:destroy(); self.edit11 = nil; end;
        if self.rectExtra_2 ~= nil then self.rectExtra_2:destroy(); self.rectExtra_2 = nil; end;
        if self.labDialogContent ~= nil then self.labDialogContent:destroy(); self.labDialogContent = nil; end;
        if self.edit25 ~= nil then self.edit25:destroy(); self.edit25 = nil; end;
        if self.imgPreview_right_2 ~= nil then self.imgPreview_right_2:destroy(); self.imgPreview_right_2 = nil; end;
        if self.layout14 ~= nil then self.layout14:destroy(); self.layout14 = nil; end;
        if self.button7 ~= nil then self.button7:destroy(); self.button7 = nil; end;
        if self.label24 ~= nil then self.label24:destroy(); self.label24 = nil; end;
        if self.edit16 ~= nil then self.edit16:destroy(); self.edit16 = nil; end;
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
