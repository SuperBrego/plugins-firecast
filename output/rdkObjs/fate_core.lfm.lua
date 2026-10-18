require("firecast.lua");
local __o_rrpgObjs = require("rrpgObjs.lua");
require("rrpgGUI.lua");
require("rrpgDialogs.lua");
require("rrpgLFM.lua");
require("ndb.lua");
require("locale.lua");
local __o_Utils = require("utils.lua");

local function constructNew_frmFateCore()
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
    obj:setName("frmFateCore");
    obj:setFormType("sheetTemplate");
    obj:setDataType("br.GodsCorpse.FateCore");
    obj:setTitle("Fate Core");


    



        require("firecast.lua");
        local Async = require("async.lua");

        -- Configuração padrão
        local DEFAULT_FISICO      = 4   -- caixas de estresse físico (total)
        local DEFAULT_MENTAL      = 4   -- caixas de estresse mental (total)
        -- Rolagem de dado Fate

        local function rolarFate(nomePericia, bonus)
            local room = Firecast.getRoomOf(sheet)
            if not room then return end

            local bonusNum = tonumber(bonus) or 0
            local expr = "4dF"
            if bonusNum > 0 then
                expr = "4dF + " .. bonusNum
            elseif bonusNum < 0 then
                expr = "4dF - " .. math.abs(bonusNum)
            end

            local msg = nomePericia ~= "" and nomePericia or "Perícia"
            Async.execute(function()
                await(room.chat:asyncRoll(expr, msg))
            end)
        end

        -- Atualiza caixas de estresse

        local function atualizarEstresse()
            local node    = sheet
            local fisico  = tonumber(node and node.cfg_fisico)  or DEFAULT_FISICO
            local mental  = tonumber(node and node.cfg_mental)  or DEFAULT_MENTAL

            for i = 1, 8 do
                for _, prefixo in ipairs({"chkFisico_", "chkFisicoTopo_"}) do
                    local chkF = self[prefixo .. i]
                    if chkF then chkF.visible = (i <= fisico) end
                end
                for _, prefixo in ipairs({"chkMental_", "chkMentalTopo_"}) do
                    local chkM = self[prefixo .. i]
                    if chkM then chkM.visible = (i <= mental) end
                end
            end
        end

        -- Atualiza consequência suave extra

        local function atualizarConsequencias()
            local node = sheet
            local cse  = (node and node.cfg_cse) == true
            local rowCSE = self["rowConsCSExtra"]
            if rowCSE then rowCSE.visible = cse end
            local rowCSETopo = self["rowConsCSExtraTopo"]
            if rowCSETopo then rowCSETopo.visible = cse end
        end

        local niveisPericia = {
            [0] = "Medíocre", [1] = "Regular", [2] = "Razoável",
            [3] = "Bom", [4] = "Ótimo", [5] = "Excepcional",
            [6] = "Fantástico", [7] = "Épico", [8] = "Lendário"
        }

        local function atualizarNivelPericia(i)
            local valor = tonumber(sheet and sheet["pericia" .. i .. "_valor"])
            local nivel = self["nivelPericia_" .. i]
            if nivel then
                nivel.text = valor and niveisPericia[valor] or ""
            end
        end

        local function atualizarPericias()
            if not sheet then return end
            local existePericia = false
            local ultimaPericia = 0
            for i = 1, 16 do
                existePericia = existePericia or sheet["pericia" .. i .. "_ativa"] == true
                if sheet["pericia" .. i .. "_ativa"] == true then ultimaPericia = i end
            end
            if not existePericia then
                for i = 1, 4 do sheet["pericia" .. i .. "_ativa"] = true end
            end
            for i = 1, 16 do
                local row = self["rowPericia_" .. i]
                if row then row.visible = sheet["pericia" .. i .. "_ativa"] == true end
                atualizarNivelPericia(i)
            end
            local corpo = self["corpoPrincipal"]
            if corpo then corpo.height = 520 end
            local lista = self["listaPericiasFacanhas"]
            if lista then lista.height = math.max(600, 70 + ultimaPericia * 57) end
        end

        local function atualizarFacanhas()
            if not sheet then return end
            local existeFacanha = false
            for i = 1, 10 do existeFacanha = existeFacanha or sheet["facanha" .. i .. "_ativa"] == true end
            if not existeFacanha then
                for i = 1, 3 do sheet["facanha" .. i .. "_ativa"] = true end
            end
            for i = 1, 10 do
                local row = self["rowFacanha_" .. i]
                if row then row.visible = sheet["facanha" .. i .. "_ativa"] == true end
            end
        end

        local function adicionarFacanha()
            if not sheet then return end
            for i = 1, 10 do
                if sheet["facanha" .. i .. "_ativa"] ~= true then
                    sheet["facanha" .. i .. "_ativa"] = true
                    atualizarFacanhas()
                    return
                end
            end
        end

        local function removerFacanha(i)
            if not sheet then return end
            sheet["facanha" .. i .. "_ativa"] = false
            atualizarFacanhas()
        end

        local function adicionarPericia()
            if not sheet then return end
            for i = 1, 16 do
                if sheet["pericia" .. i .. "_ativa"] ~= true then
                    sheet["pericia" .. i .. "_ativa"] = true
                    atualizarPericias()
                    return
                end
            end
        end

        local function removerPericia(i)
            if not sheet then return end
            sheet["pericia" .. i .. "_ativa"] = false
            atualizarPericias()
        end

        local function atualizarExtras()
            if not sheet then return end
            for i = 1, 6 do
                local row = self["rowExtraD_" .. i]
                if row then
                    row.visible = sheet["extraD" .. i .. "_ativo"] == true
                    if i <= 3 then
                        row.height = sheet["extraD" .. i .. "_expandido"] == true and 380 or 240
                    end
                end
            end
        end

        local function adicionarExtra()
            if not sheet then return end
            for i = 1, 6 do
                if sheet["extraD" .. i .. "_ativo"] ~= true then
                    sheet["extraD" .. i .. "_ativo"] = true
                    atualizarExtras()
                    return
                end
            end
        end

        local function removerExtra(i)
            if not sheet then return end
            sheet["extraD" .. i .. "_ativo"] = false
            sheet["extraD" .. i .. "_nome"] = nil
            sheet["extraD" .. i .. "_perm"] = nil
            sheet["extraD" .. i .. "_custo"] = nil
            sheet["extraD" .. i .. "_desc"] = nil
            atualizarExtras()
        end

        local function alternarDescricaoExtra(i)
            if not sheet then return end
            local expandido = sheet["extraD" .. i .. "_expandido"] == true
            sheet["extraD" .. i .. "_expandido"] = not expandido
            local row = self["rowExtraD_" .. i]
            if row then row.height = expandido and 240 or 380 end
        end

        local function atualizarDicaRetrato()
            local dica = self["dicaRetrato"]
            local imagem = self["imgRetrato"]
            if dica then
                local url = imagem and imagem.imageURL
                dica.visible = url == nil or url == ""
            end
        end

        local function removerRetrato()
            if not sheet then return end
            sheet.retrato = nil
            local imagem = self["imgRetrato"]
            if imagem then imagem.imageURL = "" end
            atualizarDicaRetrato()
        end

        -- Aplica todas as configurações

        local function aplicarConfig()
            atualizarEstresse()
            atualizarConsequencias()
            atualizarPericias()
            atualizarFacanhas()
            atualizarExtras()
            atualizarDicaRetrato()
        end
    



    


    obj.tcMain = GUI.fromHandle(_obj_newObject("tabControl"));
    obj.tcMain:setParent(obj);
    obj.tcMain:setAlign("client");
    obj.tcMain:setName("tcMain");

    obj.tab1 = GUI.fromHandle(_obj_newObject("tab"));
    obj.tab1:setParent(obj.tcMain);
    obj.tab1:setTitle("Ficha");
    obj.tab1:setName("tab1");

    obj.scrollBox1 = GUI.fromHandle(_obj_newObject("scrollBox"));
    obj.scrollBox1:setParent(obj.tab1);
    obj.scrollBox1:setAlign("client");
    obj.scrollBox1:setName("scrollBox1");

    obj.layout1 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout1:setParent(obj.scrollBox1);
    obj.layout1:setAlign("top");
    obj.layout1:setHeight(2200);
    obj.layout1:setMargins({left=10, right=10, top=10, bottom=10});
    obj.layout1:setName("layout1");

    obj.layout2 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout2:setParent(obj.layout1);
    obj.layout2:setAlign("top");
    obj.layout2:setHeight(58);
    obj.layout2:setMargins({bottom=10});
    obj.layout2:setName("layout2");

    obj.layout3 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout3:setParent(obj.layout2);
    obj.layout3:setAlign("client");
    obj.layout3:setMargins({right=8});
    obj.layout3:setName("layout3");

    obj.label1 = GUI.fromHandle(_obj_newObject("label"));
    obj.label1:setParent(obj.layout3);
    obj.label1:setText("Nome");
    obj.label1:setAlign("top");
    obj.label1:setHeight(18);
    obj.label1:setFontSize(11);
    obj.label1:setFontColor("Gray");
    lfm_setPropAsString(obj.label1, "fontStyle", "bold");
    obj.label1:setName("label1");

    obj.edit1 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit1:setParent(obj.layout3);
    obj.edit1:setAlign("client");
    obj.edit1:setField("nome");
    obj.edit1:setFontSize(15);
    obj.edit1:setName("edit1");

    obj.layout4 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout4:setParent(obj.layout2);
    obj.layout4:setAlign("right");
    obj.layout4:setWidth(120);
    obj.layout4:setName("layout4");

    obj.layout5 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout5:setParent(obj.layout4);
    obj.layout5:setAlign("left");
    obj.layout5:setWidth(56);
    obj.layout5:setMargins({right=8});
    obj.layout5:setName("layout5");

    obj.label2 = GUI.fromHandle(_obj_newObject("label"));
    obj.label2:setParent(obj.layout5);
    obj.label2:setText("Recarga");
    obj.label2:setAlign("top");
    obj.label2:setHeight(18);
    obj.label2:setFontSize(10);
    obj.label2:setFontColor("Gray");
    lfm_setPropAsString(obj.label2, "fontStyle", "bold");
    obj.label2:setName("label2");

    obj.edit2 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit2:setParent(obj.layout5);
    obj.edit2:setAlign("client");
    obj.edit2:setField("recarga");
    obj.edit2:setHorzTextAlign("center");
    obj.edit2:setFontSize(15);
    obj.edit2:setName("edit2");

    obj.layout6 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout6:setParent(obj.layout4);
    obj.layout6:setAlign("client");
    obj.layout6:setName("layout6");

    obj.label3 = GUI.fromHandle(_obj_newObject("label"));
    obj.label3:setParent(obj.layout6);
    obj.label3:setText("P. Destino");
    obj.label3:setAlign("top");
    obj.label3:setHeight(18);
    obj.label3:setFontSize(10);
    obj.label3:setFontColor("Gray");
    lfm_setPropAsString(obj.label3, "fontStyle", "bold");
    obj.label3:setName("label3");

    obj.edit3 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit3:setParent(obj.layout6);
    obj.edit3:setAlign("client");
    obj.edit3:setField("pontosDestino");
    obj.edit3:setHorzTextAlign("center");
    obj.edit3:setFontSize(15);
    obj.edit3:setName("edit3");

    obj.corpoPrincipal = GUI.fromHandle(_obj_newObject("layout"));
    obj.corpoPrincipal:setParent(obj.layout1);
    obj.corpoPrincipal:setName("corpoPrincipal");
    obj.corpoPrincipal:setAlign("top");
    obj.corpoPrincipal:setHeight(520);
    obj.corpoPrincipal:setMargins({bottom=10});

    obj.layout7 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout7:setParent(obj.corpoPrincipal);
    obj.layout7:setAlign("left");
    obj.layout7:setWidth(260);
    obj.layout7:setVisible(false);
    obj.layout7:setMargins({right=8});
    obj.layout7:setName("layout7");

    obj.label4 = GUI.fromHandle(_obj_newObject("label"));
    obj.label4:setParent(obj.layout7);
    obj.label4:setText("Perícias");
    obj.label4:setAlign("top");
    obj.label4:setHeight(18);
    obj.label4:setFontSize(11);
    obj.label4:setFontColor("Gray");
    lfm_setPropAsString(obj.label4, "fontStyle", "bold");
    obj.label4:setMargins({bottom=4});
    obj.label4:setName("label4");

    obj.layout8 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout8:setParent(obj.layout7);
    obj.layout8:setAlign("client");
    obj.layout8:setName("layout8");

    obj.rowNivel_8 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowNivel_8:setParent(obj.layout8);
    obj.rowNivel_8:setAlign("top");
    obj.rowNivel_8:setHeight(52);
    obj.rowNivel_8:setName("rowNivel_8");
    obj.rowNivel_8:setVisible(false);
    obj.rowNivel_8:setMargins({bottom=2});

    obj.label5 = GUI.fromHandle(_obj_newObject("label"));
    obj.label5:setParent(obj.rowNivel_8);
    obj.label5:setText("+8");
    obj.label5:setAlign("left");
    obj.label5:setWidth(24);
    obj.label5:setFontSize(11);
    obj.label5:setFontColor("#b9151f");
    lfm_setPropAsString(obj.label5, "fontStyle", "bold");
    obj.label5:setVertTextAlign("center");
    obj.label5:setHorzTextAlign("trailing");
    obj.label5:setMargins({right=4});
    obj.label5:setName("label5");

    obj.label6 = GUI.fromHandle(_obj_newObject("label"));
    obj.label6:setParent(obj.rowNivel_8);
    obj.label6:setText("Lendário");
    obj.label6:setAlign("left");
    obj.label6:setWidth(52);
    obj.label6:setFontSize(10);
    obj.label6:setFontColor("Gray");
    obj.label6:setVertTextAlign("center");
    obj.label6:setMargins({right=4});
    obj.label6:setName("label6");

    obj.layout9 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout9:setParent(obj.rowNivel_8);
    obj.layout9:setAlign("client");
    obj.layout9:setName("layout9");

    obj.layout10 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout10:setParent(obj.layout9);
    obj.layout10:setAlign("top");
    obj.layout10:setHeight(24);
    obj.layout10:setMargins({bottom=2});
    obj.layout10:setName("layout10");

    obj.edit4 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit4:setParent(obj.layout10);
    obj.edit4:setAlign("client");
    obj.edit4:setField("per8_1");
    obj.edit4:setHint("perícia");
    obj.edit4:setFontSize(10);
    obj.edit4:setMargins({right=2});
    obj.edit4:setName("edit4");

    obj.edit5 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit5:setParent(obj.layout10);
    obj.edit5:setAlign("right");
    obj.edit5:setWidth(24);
    obj.edit5:setField("per8_1v");
    obj.edit5:setHint("0");
    obj.edit5:setHorzTextAlign("center");
    obj.edit5:setFontSize(10);
    obj.edit5:setMargins({right=2});
    obj.edit5:setName("edit5");

    obj.button1 = GUI.fromHandle(_obj_newObject("button"));
    obj.button1:setParent(obj.layout10);
    obj.button1:setAlign("right");
    obj.button1:setWidth(24);
    obj.button1:setHeight(24);
    obj.button1:setText("dF");
    obj.button1:setFontSize(10);
    obj.button1:setName("button1");

    obj.rowNivel_7 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowNivel_7:setParent(obj.layout8);
    obj.rowNivel_7:setAlign("top");
    obj.rowNivel_7:setHeight(52);
    obj.rowNivel_7:setName("rowNivel_7");
    obj.rowNivel_7:setVisible(false);
    obj.rowNivel_7:setMargins({bottom=2});

    obj.label7 = GUI.fromHandle(_obj_newObject("label"));
    obj.label7:setParent(obj.rowNivel_7);
    obj.label7:setText("+7");
    obj.label7:setAlign("left");
    obj.label7:setWidth(24);
    obj.label7:setFontSize(11);
    obj.label7:setFontColor("#b9151f");
    lfm_setPropAsString(obj.label7, "fontStyle", "bold");
    obj.label7:setVertTextAlign("center");
    obj.label7:setHorzTextAlign("trailing");
    obj.label7:setMargins({right=4});
    obj.label7:setName("label7");

    obj.label8 = GUI.fromHandle(_obj_newObject("label"));
    obj.label8:setParent(obj.rowNivel_7);
    obj.label8:setText("Épico");
    obj.label8:setAlign("left");
    obj.label8:setWidth(52);
    obj.label8:setFontSize(10);
    obj.label8:setFontColor("Gray");
    obj.label8:setVertTextAlign("center");
    obj.label8:setMargins({right=4});
    obj.label8:setName("label8");

    obj.layout11 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout11:setParent(obj.rowNivel_7);
    obj.layout11:setAlign("client");
    obj.layout11:setName("layout11");

    obj.layout12 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout12:setParent(obj.layout11);
    obj.layout12:setAlign("top");
    obj.layout12:setHeight(24);
    obj.layout12:setMargins({bottom=2});
    obj.layout12:setName("layout12");

    obj.edit6 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit6:setParent(obj.layout12);
    obj.edit6:setAlign("client");
    obj.edit6:setField("per7_1");
    obj.edit6:setHint("perícia");
    obj.edit6:setFontSize(10);
    obj.edit6:setMargins({right=2});
    obj.edit6:setName("edit6");

    obj.edit7 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit7:setParent(obj.layout12);
    obj.edit7:setAlign("right");
    obj.edit7:setWidth(24);
    obj.edit7:setField("per7_1v");
    obj.edit7:setHint("0");
    obj.edit7:setHorzTextAlign("center");
    obj.edit7:setFontSize(10);
    obj.edit7:setMargins({right=2});
    obj.edit7:setName("edit7");

    obj.button2 = GUI.fromHandle(_obj_newObject("button"));
    obj.button2:setParent(obj.layout12);
    obj.button2:setAlign("right");
    obj.button2:setWidth(24);
    obj.button2:setHeight(24);
    obj.button2:setText("dF");
    obj.button2:setFontSize(10);
    obj.button2:setName("button2");

    obj.rowNivel_6 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowNivel_6:setParent(obj.layout8);
    obj.rowNivel_6:setAlign("top");
    obj.rowNivel_6:setHeight(52);
    obj.rowNivel_6:setName("rowNivel_6");
    obj.rowNivel_6:setVisible(false);
    obj.rowNivel_6:setMargins({bottom=2});

    obj.label9 = GUI.fromHandle(_obj_newObject("label"));
    obj.label9:setParent(obj.rowNivel_6);
    obj.label9:setText("+6");
    obj.label9:setAlign("left");
    obj.label9:setWidth(24);
    obj.label9:setFontSize(11);
    obj.label9:setFontColor("#b9151f");
    lfm_setPropAsString(obj.label9, "fontStyle", "bold");
    obj.label9:setVertTextAlign("center");
    obj.label9:setHorzTextAlign("trailing");
    obj.label9:setMargins({right=4});
    obj.label9:setName("label9");

    obj.label10 = GUI.fromHandle(_obj_newObject("label"));
    obj.label10:setParent(obj.rowNivel_6);
    obj.label10:setText("Fantástico");
    obj.label10:setAlign("left");
    obj.label10:setWidth(52);
    obj.label10:setFontSize(10);
    obj.label10:setFontColor("Gray");
    obj.label10:setVertTextAlign("center");
    obj.label10:setMargins({right=4});
    obj.label10:setName("label10");

    obj.layout13 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout13:setParent(obj.rowNivel_6);
    obj.layout13:setAlign("client");
    obj.layout13:setName("layout13");

    obj.layout14 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout14:setParent(obj.layout13);
    obj.layout14:setAlign("top");
    obj.layout14:setHeight(24);
    obj.layout14:setMargins({bottom=2});
    obj.layout14:setName("layout14");

    obj.edit8 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit8:setParent(obj.layout14);
    obj.edit8:setAlign("client");
    obj.edit8:setField("per6_1");
    obj.edit8:setHint("perícia");
    obj.edit8:setFontSize(10);
    obj.edit8:setMargins({right=2});
    obj.edit8:setName("edit8");

    obj.edit9 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit9:setParent(obj.layout14);
    obj.edit9:setAlign("right");
    obj.edit9:setWidth(24);
    obj.edit9:setField("per6_1v");
    obj.edit9:setHint("0");
    obj.edit9:setHorzTextAlign("center");
    obj.edit9:setFontSize(10);
    obj.edit9:setMargins({right=2});
    obj.edit9:setName("edit9");

    obj.button3 = GUI.fromHandle(_obj_newObject("button"));
    obj.button3:setParent(obj.layout14);
    obj.button3:setAlign("right");
    obj.button3:setWidth(24);
    obj.button3:setHeight(24);
    obj.button3:setText("dF");
    obj.button3:setFontSize(10);
    obj.button3:setName("button3");

    obj.rowNivel_5 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowNivel_5:setParent(obj.layout8);
    obj.rowNivel_5:setAlign("top");
    obj.rowNivel_5:setHeight(28);
    obj.rowNivel_5:setName("rowNivel_5");
    obj.rowNivel_5:setMargins({bottom=2});

    obj.label11 = GUI.fromHandle(_obj_newObject("label"));
    obj.label11:setParent(obj.rowNivel_5);
    obj.label11:setText("+5");
    obj.label11:setAlign("left");
    obj.label11:setWidth(24);
    obj.label11:setFontSize(11);
    obj.label11:setFontColor("#b9151f");
    lfm_setPropAsString(obj.label11, "fontStyle", "bold");
    obj.label11:setVertTextAlign("center");
    obj.label11:setHorzTextAlign("trailing");
    obj.label11:setMargins({right=4});
    obj.label11:setName("label11");

    obj.label12 = GUI.fromHandle(_obj_newObject("label"));
    obj.label12:setParent(obj.rowNivel_5);
    obj.label12:setText("Excepcional");
    obj.label12:setAlign("left");
    obj.label12:setWidth(52);
    obj.label12:setFontSize(10);
    obj.label12:setFontColor("Gray");
    obj.label12:setVertTextAlign("center");
    obj.label12:setMargins({right=4});
    obj.label12:setName("label12");

    obj.layout15 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout15:setParent(obj.rowNivel_5);
    obj.layout15:setAlign("client");
    obj.layout15:setName("layout15");

    obj.edit10 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit10:setParent(obj.layout15);
    obj.edit10:setAlign("client");
    obj.edit10:setField("per5_1");
    obj.edit10:setHint("perícia");
    obj.edit10:setFontSize(10);
    obj.edit10:setMargins({right=2});
    obj.edit10:setName("edit10");

    obj.edit11 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit11:setParent(obj.layout15);
    obj.edit11:setAlign("right");
    obj.edit11:setWidth(24);
    obj.edit11:setField("per5_1v");
    obj.edit11:setHint("0");
    obj.edit11:setHorzTextAlign("center");
    obj.edit11:setFontSize(10);
    obj.edit11:setMargins({right=2});
    obj.edit11:setName("edit11");

    obj.button4 = GUI.fromHandle(_obj_newObject("button"));
    obj.button4:setParent(obj.layout15);
    obj.button4:setAlign("right");
    obj.button4:setWidth(24);
    obj.button4:setHeight(24);
    obj.button4:setText("dF");
    obj.button4:setFontSize(10);
    obj.button4:setName("button4");

    obj.rowNivel_4 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowNivel_4:setParent(obj.layout8);
    obj.rowNivel_4:setAlign("top");
    obj.rowNivel_4:setHeight(56);
    obj.rowNivel_4:setName("rowNivel_4");
    obj.rowNivel_4:setMargins({bottom=2});

    obj.label13 = GUI.fromHandle(_obj_newObject("label"));
    obj.label13:setParent(obj.rowNivel_4);
    obj.label13:setText("+4");
    obj.label13:setAlign("left");
    obj.label13:setWidth(24);
    obj.label13:setFontSize(11);
    obj.label13:setFontColor("#b9151f");
    lfm_setPropAsString(obj.label13, "fontStyle", "bold");
    obj.label13:setVertTextAlign("center");
    obj.label13:setHorzTextAlign("trailing");
    obj.label13:setMargins({right=4});
    obj.label13:setName("label13");

    obj.label14 = GUI.fromHandle(_obj_newObject("label"));
    obj.label14:setParent(obj.rowNivel_4);
    obj.label14:setText("Ótimo");
    obj.label14:setAlign("left");
    obj.label14:setWidth(52);
    obj.label14:setFontSize(10);
    obj.label14:setFontColor("Gray");
    obj.label14:setVertTextAlign("center");
    obj.label14:setMargins({right=4});
    obj.label14:setName("label14");

    obj.layout16 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout16:setParent(obj.rowNivel_4);
    obj.layout16:setAlign("client");
    obj.layout16:setName("layout16");

    obj.layout17 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout17:setParent(obj.layout16);
    obj.layout17:setAlign("top");
    obj.layout17:setHeight(24);
    obj.layout17:setMargins({bottom=4});
    obj.layout17:setName("layout17");

    obj.edit12 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit12:setParent(obj.layout17);
    obj.edit12:setAlign("client");
    obj.edit12:setField("per4_1");
    obj.edit12:setHint("perícia");
    obj.edit12:setFontSize(10);
    obj.edit12:setMargins({right=2});
    obj.edit12:setName("edit12");

    obj.edit13 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit13:setParent(obj.layout17);
    obj.edit13:setAlign("right");
    obj.edit13:setWidth(24);
    obj.edit13:setField("per4_1v");
    obj.edit13:setHint("0");
    obj.edit13:setHorzTextAlign("center");
    obj.edit13:setFontSize(10);
    obj.edit13:setMargins({right=2});
    obj.edit13:setName("edit13");

    obj.button5 = GUI.fromHandle(_obj_newObject("button"));
    obj.button5:setParent(obj.layout17);
    obj.button5:setAlign("right");
    obj.button5:setWidth(24);
    obj.button5:setHeight(24);
    obj.button5:setText("dF");
    obj.button5:setFontSize(10);
    obj.button5:setName("button5");

    obj.layout18 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout18:setParent(obj.layout16);
    obj.layout18:setAlign("top");
    obj.layout18:setHeight(24);
    obj.layout18:setName("layout18");

    obj.edit14 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit14:setParent(obj.layout18);
    obj.edit14:setAlign("client");
    obj.edit14:setField("per4_2");
    obj.edit14:setHint("perícia");
    obj.edit14:setFontSize(10);
    obj.edit14:setMargins({right=2});
    obj.edit14:setName("edit14");

    obj.edit15 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit15:setParent(obj.layout18);
    obj.edit15:setAlign("right");
    obj.edit15:setWidth(24);
    obj.edit15:setField("per4_2v");
    obj.edit15:setHint("0");
    obj.edit15:setHorzTextAlign("center");
    obj.edit15:setFontSize(10);
    obj.edit15:setMargins({right=2});
    obj.edit15:setName("edit15");

    obj.button6 = GUI.fromHandle(_obj_newObject("button"));
    obj.button6:setParent(obj.layout18);
    obj.button6:setAlign("right");
    obj.button6:setWidth(24);
    obj.button6:setHeight(24);
    obj.button6:setText("dF");
    obj.button6:setFontSize(10);
    obj.button6:setName("button6");

    obj.rowNivel_3 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowNivel_3:setParent(obj.layout8);
    obj.rowNivel_3:setAlign("top");
    obj.rowNivel_3:setHeight(84);
    obj.rowNivel_3:setName("rowNivel_3");
    obj.rowNivel_3:setMargins({bottom=2});

    obj.label15 = GUI.fromHandle(_obj_newObject("label"));
    obj.label15:setParent(obj.rowNivel_3);
    obj.label15:setText("+3");
    obj.label15:setAlign("left");
    obj.label15:setWidth(24);
    obj.label15:setFontSize(11);
    obj.label15:setFontColor("#b9151f");
    lfm_setPropAsString(obj.label15, "fontStyle", "bold");
    obj.label15:setVertTextAlign("center");
    obj.label15:setHorzTextAlign("trailing");
    obj.label15:setMargins({right=4});
    obj.label15:setName("label15");

    obj.label16 = GUI.fromHandle(_obj_newObject("label"));
    obj.label16:setParent(obj.rowNivel_3);
    obj.label16:setText("Bom");
    obj.label16:setAlign("left");
    obj.label16:setWidth(52);
    obj.label16:setFontSize(10);
    obj.label16:setFontColor("Gray");
    obj.label16:setVertTextAlign("center");
    obj.label16:setMargins({right=4});
    obj.label16:setName("label16");

    obj.layout19 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout19:setParent(obj.rowNivel_3);
    obj.layout19:setAlign("client");
    obj.layout19:setName("layout19");

    obj.layout20 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout20:setParent(obj.layout19);
    obj.layout20:setAlign("top");
    obj.layout20:setHeight(24);
    obj.layout20:setMargins({bottom=4});
    obj.layout20:setName("layout20");

    obj.edit16 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit16:setParent(obj.layout20);
    obj.edit16:setAlign("client");
    obj.edit16:setField("per3_1");
    obj.edit16:setHint("perícia");
    obj.edit16:setFontSize(10);
    obj.edit16:setMargins({right=2});
    obj.edit16:setName("edit16");

    obj.edit17 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit17:setParent(obj.layout20);
    obj.edit17:setAlign("right");
    obj.edit17:setWidth(24);
    obj.edit17:setField("per3_1v");
    obj.edit17:setHint("0");
    obj.edit17:setHorzTextAlign("center");
    obj.edit17:setFontSize(10);
    obj.edit17:setMargins({right=2});
    obj.edit17:setName("edit17");

    obj.button7 = GUI.fromHandle(_obj_newObject("button"));
    obj.button7:setParent(obj.layout20);
    obj.button7:setAlign("right");
    obj.button7:setWidth(24);
    obj.button7:setHeight(24);
    obj.button7:setText("dF");
    obj.button7:setFontSize(10);
    obj.button7:setName("button7");

    obj.layout21 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout21:setParent(obj.layout19);
    obj.layout21:setAlign("top");
    obj.layout21:setHeight(24);
    obj.layout21:setMargins({bottom=4});
    obj.layout21:setName("layout21");

    obj.edit18 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit18:setParent(obj.layout21);
    obj.edit18:setAlign("client");
    obj.edit18:setField("per3_2");
    obj.edit18:setHint("perícia");
    obj.edit18:setFontSize(10);
    obj.edit18:setMargins({right=2});
    obj.edit18:setName("edit18");

    obj.edit19 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit19:setParent(obj.layout21);
    obj.edit19:setAlign("right");
    obj.edit19:setWidth(24);
    obj.edit19:setField("per3_2v");
    obj.edit19:setHint("0");
    obj.edit19:setHorzTextAlign("center");
    obj.edit19:setFontSize(10);
    obj.edit19:setMargins({right=2});
    obj.edit19:setName("edit19");

    obj.button8 = GUI.fromHandle(_obj_newObject("button"));
    obj.button8:setParent(obj.layout21);
    obj.button8:setAlign("right");
    obj.button8:setWidth(24);
    obj.button8:setHeight(24);
    obj.button8:setText("dF");
    obj.button8:setFontSize(10);
    obj.button8:setName("button8");

    obj.layout22 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout22:setParent(obj.layout19);
    obj.layout22:setAlign("top");
    obj.layout22:setHeight(24);
    obj.layout22:setName("layout22");

    obj.edit20 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit20:setParent(obj.layout22);
    obj.edit20:setAlign("client");
    obj.edit20:setField("per3_3");
    obj.edit20:setHint("perícia");
    obj.edit20:setFontSize(10);
    obj.edit20:setMargins({right=2});
    obj.edit20:setName("edit20");

    obj.edit21 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit21:setParent(obj.layout22);
    obj.edit21:setAlign("right");
    obj.edit21:setWidth(24);
    obj.edit21:setField("per3_3v");
    obj.edit21:setHint("0");
    obj.edit21:setHorzTextAlign("center");
    obj.edit21:setFontSize(10);
    obj.edit21:setMargins({right=2});
    obj.edit21:setName("edit21");

    obj.button9 = GUI.fromHandle(_obj_newObject("button"));
    obj.button9:setParent(obj.layout22);
    obj.button9:setAlign("right");
    obj.button9:setWidth(24);
    obj.button9:setHeight(24);
    obj.button9:setText("dF");
    obj.button9:setFontSize(10);
    obj.button9:setName("button9");

    obj.rowNivel_2 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowNivel_2:setParent(obj.layout8);
    obj.rowNivel_2:setAlign("top");
    obj.rowNivel_2:setHeight(112);
    obj.rowNivel_2:setName("rowNivel_2");
    obj.rowNivel_2:setMargins({bottom=2});

    obj.label17 = GUI.fromHandle(_obj_newObject("label"));
    obj.label17:setParent(obj.rowNivel_2);
    obj.label17:setText("+2");
    obj.label17:setAlign("left");
    obj.label17:setWidth(24);
    obj.label17:setFontSize(11);
    obj.label17:setFontColor("#b9151f");
    lfm_setPropAsString(obj.label17, "fontStyle", "bold");
    obj.label17:setVertTextAlign("center");
    obj.label17:setHorzTextAlign("trailing");
    obj.label17:setMargins({right=4});
    obj.label17:setName("label17");

    obj.label18 = GUI.fromHandle(_obj_newObject("label"));
    obj.label18:setParent(obj.rowNivel_2);
    obj.label18:setText("Razoável");
    obj.label18:setAlign("left");
    obj.label18:setWidth(52);
    obj.label18:setFontSize(10);
    obj.label18:setFontColor("Gray");
    obj.label18:setVertTextAlign("center");
    obj.label18:setMargins({right=4});
    obj.label18:setName("label18");

    obj.layout23 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout23:setParent(obj.rowNivel_2);
    obj.layout23:setAlign("client");
    obj.layout23:setName("layout23");

    obj.layout24 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout24:setParent(obj.layout23);
    obj.layout24:setAlign("top");
    obj.layout24:setHeight(24);
    obj.layout24:setMargins({bottom=4});
    obj.layout24:setName("layout24");

    obj.edit22 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit22:setParent(obj.layout24);
    obj.edit22:setAlign("client");
    obj.edit22:setField("per2_1");
    obj.edit22:setHint("perícia");
    obj.edit22:setFontSize(10);
    obj.edit22:setMargins({right=2});
    obj.edit22:setName("edit22");

    obj.edit23 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit23:setParent(obj.layout24);
    obj.edit23:setAlign("right");
    obj.edit23:setWidth(24);
    obj.edit23:setField("per2_1v");
    obj.edit23:setHint("0");
    obj.edit23:setHorzTextAlign("center");
    obj.edit23:setFontSize(10);
    obj.edit23:setMargins({right=2});
    obj.edit23:setName("edit23");

    obj.button10 = GUI.fromHandle(_obj_newObject("button"));
    obj.button10:setParent(obj.layout24);
    obj.button10:setAlign("right");
    obj.button10:setWidth(24);
    obj.button10:setHeight(24);
    obj.button10:setText("dF");
    obj.button10:setFontSize(10);
    obj.button10:setName("button10");

    obj.layout25 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout25:setParent(obj.layout23);
    obj.layout25:setAlign("top");
    obj.layout25:setHeight(24);
    obj.layout25:setMargins({bottom=4});
    obj.layout25:setName("layout25");

    obj.edit24 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit24:setParent(obj.layout25);
    obj.edit24:setAlign("client");
    obj.edit24:setField("per2_2");
    obj.edit24:setHint("perícia");
    obj.edit24:setFontSize(10);
    obj.edit24:setMargins({right=2});
    obj.edit24:setName("edit24");

    obj.edit25 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit25:setParent(obj.layout25);
    obj.edit25:setAlign("right");
    obj.edit25:setWidth(24);
    obj.edit25:setField("per2_2v");
    obj.edit25:setHint("0");
    obj.edit25:setHorzTextAlign("center");
    obj.edit25:setFontSize(10);
    obj.edit25:setMargins({right=2});
    obj.edit25:setName("edit25");

    obj.button11 = GUI.fromHandle(_obj_newObject("button"));
    obj.button11:setParent(obj.layout25);
    obj.button11:setAlign("right");
    obj.button11:setWidth(24);
    obj.button11:setHeight(24);
    obj.button11:setText("dF");
    obj.button11:setFontSize(10);
    obj.button11:setName("button11");

    obj.layout26 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout26:setParent(obj.layout23);
    obj.layout26:setAlign("top");
    obj.layout26:setHeight(24);
    obj.layout26:setMargins({bottom=4});
    obj.layout26:setName("layout26");

    obj.edit26 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit26:setParent(obj.layout26);
    obj.edit26:setAlign("client");
    obj.edit26:setField("per2_3");
    obj.edit26:setHint("perícia");
    obj.edit26:setFontSize(10);
    obj.edit26:setMargins({right=2});
    obj.edit26:setName("edit26");

    obj.edit27 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit27:setParent(obj.layout26);
    obj.edit27:setAlign("right");
    obj.edit27:setWidth(24);
    obj.edit27:setField("per2_3v");
    obj.edit27:setHint("0");
    obj.edit27:setHorzTextAlign("center");
    obj.edit27:setFontSize(10);
    obj.edit27:setMargins({right=2});
    obj.edit27:setName("edit27");

    obj.button12 = GUI.fromHandle(_obj_newObject("button"));
    obj.button12:setParent(obj.layout26);
    obj.button12:setAlign("right");
    obj.button12:setWidth(24);
    obj.button12:setHeight(24);
    obj.button12:setText("dF");
    obj.button12:setFontSize(10);
    obj.button12:setName("button12");

    obj.layout27 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout27:setParent(obj.layout23);
    obj.layout27:setAlign("top");
    obj.layout27:setHeight(24);
    obj.layout27:setName("layout27");

    obj.edit28 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit28:setParent(obj.layout27);
    obj.edit28:setAlign("client");
    obj.edit28:setField("per2_4");
    obj.edit28:setHint("perícia");
    obj.edit28:setFontSize(10);
    obj.edit28:setMargins({right=2});
    obj.edit28:setName("edit28");

    obj.edit29 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit29:setParent(obj.layout27);
    obj.edit29:setAlign("right");
    obj.edit29:setWidth(24);
    obj.edit29:setField("per2_4v");
    obj.edit29:setHint("0");
    obj.edit29:setHorzTextAlign("center");
    obj.edit29:setFontSize(10);
    obj.edit29:setMargins({right=2});
    obj.edit29:setName("edit29");

    obj.button13 = GUI.fromHandle(_obj_newObject("button"));
    obj.button13:setParent(obj.layout27);
    obj.button13:setAlign("right");
    obj.button13:setWidth(24);
    obj.button13:setHeight(24);
    obj.button13:setText("dF");
    obj.button13:setFontSize(10);
    obj.button13:setName("button13");

    obj.rowNivel_1 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowNivel_1:setParent(obj.layout8);
    obj.rowNivel_1:setAlign("top");
    obj.rowNivel_1:setHeight(140);
    obj.rowNivel_1:setName("rowNivel_1");
    obj.rowNivel_1:setMargins({bottom=2});

    obj.label19 = GUI.fromHandle(_obj_newObject("label"));
    obj.label19:setParent(obj.rowNivel_1);
    obj.label19:setText("+1");
    obj.label19:setAlign("left");
    obj.label19:setWidth(24);
    obj.label19:setFontSize(11);
    obj.label19:setFontColor("#b9151f");
    lfm_setPropAsString(obj.label19, "fontStyle", "bold");
    obj.label19:setVertTextAlign("center");
    obj.label19:setHorzTextAlign("trailing");
    obj.label19:setMargins({right=4});
    obj.label19:setName("label19");

    obj.label20 = GUI.fromHandle(_obj_newObject("label"));
    obj.label20:setParent(obj.rowNivel_1);
    obj.label20:setText("Regular");
    obj.label20:setAlign("left");
    obj.label20:setWidth(52);
    obj.label20:setFontSize(10);
    obj.label20:setFontColor("Gray");
    obj.label20:setVertTextAlign("center");
    obj.label20:setMargins({right=4});
    obj.label20:setName("label20");

    obj.layout28 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout28:setParent(obj.rowNivel_1);
    obj.layout28:setAlign("client");
    obj.layout28:setName("layout28");

    obj.layout29 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout29:setParent(obj.layout28);
    obj.layout29:setAlign("top");
    obj.layout29:setHeight(24);
    obj.layout29:setMargins({bottom=4});
    obj.layout29:setName("layout29");

    obj.edit30 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit30:setParent(obj.layout29);
    obj.edit30:setAlign("client");
    obj.edit30:setField("per1_1");
    obj.edit30:setHint("perícia");
    obj.edit30:setFontSize(10);
    obj.edit30:setMargins({right=2});
    obj.edit30:setName("edit30");

    obj.edit31 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit31:setParent(obj.layout29);
    obj.edit31:setAlign("right");
    obj.edit31:setWidth(24);
    obj.edit31:setField("per1_1v");
    obj.edit31:setHint("0");
    obj.edit31:setHorzTextAlign("center");
    obj.edit31:setFontSize(10);
    obj.edit31:setMargins({right=2});
    obj.edit31:setName("edit31");

    obj.button14 = GUI.fromHandle(_obj_newObject("button"));
    obj.button14:setParent(obj.layout29);
    obj.button14:setAlign("right");
    obj.button14:setWidth(24);
    obj.button14:setHeight(24);
    obj.button14:setText("dF");
    obj.button14:setFontSize(10);
    obj.button14:setName("button14");

    obj.layout30 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout30:setParent(obj.layout28);
    obj.layout30:setAlign("top");
    obj.layout30:setHeight(24);
    obj.layout30:setMargins({bottom=4});
    obj.layout30:setName("layout30");

    obj.edit32 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit32:setParent(obj.layout30);
    obj.edit32:setAlign("client");
    obj.edit32:setField("per1_2");
    obj.edit32:setHint("perícia");
    obj.edit32:setFontSize(10);
    obj.edit32:setMargins({right=2});
    obj.edit32:setName("edit32");

    obj.edit33 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit33:setParent(obj.layout30);
    obj.edit33:setAlign("right");
    obj.edit33:setWidth(24);
    obj.edit33:setField("per1_2v");
    obj.edit33:setHint("0");
    obj.edit33:setHorzTextAlign("center");
    obj.edit33:setFontSize(10);
    obj.edit33:setMargins({right=2});
    obj.edit33:setName("edit33");

    obj.button15 = GUI.fromHandle(_obj_newObject("button"));
    obj.button15:setParent(obj.layout30);
    obj.button15:setAlign("right");
    obj.button15:setWidth(24);
    obj.button15:setHeight(24);
    obj.button15:setText("dF");
    obj.button15:setFontSize(10);
    obj.button15:setName("button15");

    obj.layout31 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout31:setParent(obj.layout28);
    obj.layout31:setAlign("top");
    obj.layout31:setHeight(24);
    obj.layout31:setMargins({bottom=4});
    obj.layout31:setName("layout31");

    obj.edit34 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit34:setParent(obj.layout31);
    obj.edit34:setAlign("client");
    obj.edit34:setField("per1_3");
    obj.edit34:setHint("perícia");
    obj.edit34:setFontSize(10);
    obj.edit34:setMargins({right=2});
    obj.edit34:setName("edit34");

    obj.edit35 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit35:setParent(obj.layout31);
    obj.edit35:setAlign("right");
    obj.edit35:setWidth(24);
    obj.edit35:setField("per1_3v");
    obj.edit35:setHint("0");
    obj.edit35:setHorzTextAlign("center");
    obj.edit35:setFontSize(10);
    obj.edit35:setMargins({right=2});
    obj.edit35:setName("edit35");

    obj.button16 = GUI.fromHandle(_obj_newObject("button"));
    obj.button16:setParent(obj.layout31);
    obj.button16:setAlign("right");
    obj.button16:setWidth(24);
    obj.button16:setHeight(24);
    obj.button16:setText("dF");
    obj.button16:setFontSize(10);
    obj.button16:setName("button16");

    obj.layout32 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout32:setParent(obj.layout28);
    obj.layout32:setAlign("top");
    obj.layout32:setHeight(24);
    obj.layout32:setMargins({bottom=4});
    obj.layout32:setName("layout32");

    obj.edit36 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit36:setParent(obj.layout32);
    obj.edit36:setAlign("client");
    obj.edit36:setField("per1_4");
    obj.edit36:setHint("perícia");
    obj.edit36:setFontSize(10);
    obj.edit36:setMargins({right=2});
    obj.edit36:setName("edit36");

    obj.edit37 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit37:setParent(obj.layout32);
    obj.edit37:setAlign("right");
    obj.edit37:setWidth(24);
    obj.edit37:setField("per1_4v");
    obj.edit37:setHint("0");
    obj.edit37:setHorzTextAlign("center");
    obj.edit37:setFontSize(10);
    obj.edit37:setMargins({right=2});
    obj.edit37:setName("edit37");

    obj.button17 = GUI.fromHandle(_obj_newObject("button"));
    obj.button17:setParent(obj.layout32);
    obj.button17:setAlign("right");
    obj.button17:setWidth(24);
    obj.button17:setHeight(24);
    obj.button17:setText("dF");
    obj.button17:setFontSize(10);
    obj.button17:setName("button17");

    obj.layout33 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout33:setParent(obj.layout28);
    obj.layout33:setAlign("top");
    obj.layout33:setHeight(24);
    obj.layout33:setName("layout33");

    obj.edit38 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit38:setParent(obj.layout33);
    obj.edit38:setAlign("client");
    obj.edit38:setField("per1_5");
    obj.edit38:setHint("perícia");
    obj.edit38:setFontSize(10);
    obj.edit38:setMargins({right=2});
    obj.edit38:setName("edit38");

    obj.edit39 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit39:setParent(obj.layout33);
    obj.edit39:setAlign("right");
    obj.edit39:setWidth(24);
    obj.edit39:setField("per1_5v");
    obj.edit39:setHint("0");
    obj.edit39:setHorzTextAlign("center");
    obj.edit39:setFontSize(10);
    obj.edit39:setMargins({right=2});
    obj.edit39:setName("edit39");

    obj.button18 = GUI.fromHandle(_obj_newObject("button"));
    obj.button18:setParent(obj.layout33);
    obj.button18:setAlign("right");
    obj.button18:setWidth(24);
    obj.button18:setHeight(24);
    obj.button18:setText("dF");
    obj.button18:setFontSize(10);
    obj.button18:setName("button18");

    obj.layout34 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout34:setParent(obj.corpoPrincipal);
    obj.layout34:setAlign("client");
    obj.layout34:setName("layout34");

    obj.layout35 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout35:setParent(obj.layout34);
    obj.layout35:setAlign("top");
    obj.layout35:setHeight(230);
    obj.layout35:setMargins({bottom=12});
    obj.layout35:setName("layout35");

    obj.layout36 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout36:setParent(obj.layout35);
    obj.layout36:setAlign("left");
    obj.layout36:setWidth(180);
    obj.layout36:setMargins({right=12});
    obj.layout36:setName("layout36");

    obj.button19 = GUI.fromHandle(_obj_newObject("button"));
    obj.button19:setParent(obj.layout36);
    obj.button19:setAlign("bottom");
    obj.button19:setHeight(26);
    obj.button19:setText("Remover imagem");
    obj.button19:setFontSize(9);
    obj.button19:setMargins({top=4});
    obj.button19:setName("button19");

    obj.rectangle1 = GUI.fromHandle(_obj_newObject("rectangle"));
    obj.rectangle1:setParent(obj.layout36);
    obj.rectangle1:setAlign("client");
    obj.rectangle1:setColor("#2B2B2B");
    obj.rectangle1:setStrokeColor("#888888");
    obj.rectangle1:setStrokeSize(2);
    obj.rectangle1:setStrokeDash("dash");
    obj.rectangle1:setName("rectangle1");

    obj.imgRetrato = GUI.fromHandle(_obj_newObject("image"));
    obj.imgRetrato:setParent(obj.layout36);
    obj.imgRetrato:setName("imgRetrato");
    obj.imgRetrato:setAlign("client");
    obj.imgRetrato:setField("retrato");
    obj.imgRetrato:setEditable(true);
    obj.imgRetrato:setStyle("proportional");

    obj.dicaRetrato = GUI.fromHandle(_obj_newObject("label"));
    obj.dicaRetrato:setParent(obj.layout36);
    obj.dicaRetrato:setName("dicaRetrato");
    obj.dicaRetrato:setText("Clique aqui para adicionar imagem");
    obj.dicaRetrato:setAlign("client");
    obj.dicaRetrato:setFontSize(11);
    obj.dicaRetrato:setFontColor("#D0D0D0");
    obj.dicaRetrato:setHorzTextAlign("center");
    obj.dicaRetrato:setVertTextAlign("center");

    obj.layout37 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout37:setParent(obj.layout35);
    obj.layout37:setAlign("client");
    obj.layout37:setName("layout37");

    obj.layout38 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout38:setParent(obj.layout37);
    obj.layout38:setAlign("top");
    obj.layout38:setHeight(34);
    obj.layout38:setMargins({bottom=6});
    obj.layout38:setName("layout38");

    obj.label21 = GUI.fromHandle(_obj_newObject("label"));
    obj.label21:setParent(obj.layout38);
    obj.label21:setText("Estresse Físico");
    obj.label21:setAlign("left");
    obj.label21:setWidth(150);
    obj.label21:setFontSize(11);
    obj.label21:setFontColor("Gray");
    obj.label21:setVertTextAlign("center");
    obj.label21:setName("label21");

    obj.chkFisicoTopo_1 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.chkFisicoTopo_1:setParent(obj.layout38);
    obj.chkFisicoTopo_1:setName("chkFisicoTopo_1");
    obj.chkFisicoTopo_1:setAlign("left");
    obj.chkFisicoTopo_1:setWidth(30);
    obj.chkFisicoTopo_1:setField("stF1");
    obj.chkFisicoTopo_1:setText("1");
    obj.chkFisicoTopo_1:setFontSize(10);

    obj.chkFisicoTopo_2 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.chkFisicoTopo_2:setParent(obj.layout38);
    obj.chkFisicoTopo_2:setName("chkFisicoTopo_2");
    obj.chkFisicoTopo_2:setAlign("left");
    obj.chkFisicoTopo_2:setWidth(30);
    obj.chkFisicoTopo_2:setField("stF2");
    obj.chkFisicoTopo_2:setText("2");
    obj.chkFisicoTopo_2:setFontSize(10);

    obj.chkFisicoTopo_3 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.chkFisicoTopo_3:setParent(obj.layout38);
    obj.chkFisicoTopo_3:setName("chkFisicoTopo_3");
    obj.chkFisicoTopo_3:setAlign("left");
    obj.chkFisicoTopo_3:setWidth(30);
    obj.chkFisicoTopo_3:setField("stF3");
    obj.chkFisicoTopo_3:setText("3");
    obj.chkFisicoTopo_3:setFontSize(10);

    obj.chkFisicoTopo_4 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.chkFisicoTopo_4:setParent(obj.layout38);
    obj.chkFisicoTopo_4:setName("chkFisicoTopo_4");
    obj.chkFisicoTopo_4:setAlign("left");
    obj.chkFisicoTopo_4:setWidth(30);
    obj.chkFisicoTopo_4:setField("stF4");
    obj.chkFisicoTopo_4:setText("4");
    obj.chkFisicoTopo_4:setFontSize(10);

    obj.chkFisicoTopo_5 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.chkFisicoTopo_5:setParent(obj.layout38);
    obj.chkFisicoTopo_5:setName("chkFisicoTopo_5");
    obj.chkFisicoTopo_5:setAlign("left");
    obj.chkFisicoTopo_5:setWidth(30);
    obj.chkFisicoTopo_5:setField("stF5");
    obj.chkFisicoTopo_5:setText("5");
    obj.chkFisicoTopo_5:setFontSize(10);
    obj.chkFisicoTopo_5:setVisible(false);

    obj.chkFisicoTopo_6 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.chkFisicoTopo_6:setParent(obj.layout38);
    obj.chkFisicoTopo_6:setName("chkFisicoTopo_6");
    obj.chkFisicoTopo_6:setAlign("left");
    obj.chkFisicoTopo_6:setWidth(30);
    obj.chkFisicoTopo_6:setField("stF6");
    obj.chkFisicoTopo_6:setText("6");
    obj.chkFisicoTopo_6:setFontSize(10);
    obj.chkFisicoTopo_6:setVisible(false);

    obj.chkFisicoTopo_7 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.chkFisicoTopo_7:setParent(obj.layout38);
    obj.chkFisicoTopo_7:setName("chkFisicoTopo_7");
    obj.chkFisicoTopo_7:setAlign("left");
    obj.chkFisicoTopo_7:setWidth(30);
    obj.chkFisicoTopo_7:setField("stF7");
    obj.chkFisicoTopo_7:setText("7");
    obj.chkFisicoTopo_7:setFontSize(10);
    obj.chkFisicoTopo_7:setVisible(false);

    obj.chkFisicoTopo_8 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.chkFisicoTopo_8:setParent(obj.layout38);
    obj.chkFisicoTopo_8:setName("chkFisicoTopo_8");
    obj.chkFisicoTopo_8:setAlign("left");
    obj.chkFisicoTopo_8:setWidth(30);
    obj.chkFisicoTopo_8:setField("stF8");
    obj.chkFisicoTopo_8:setText("8");
    obj.chkFisicoTopo_8:setFontSize(10);
    obj.chkFisicoTopo_8:setVisible(false);

    obj.layout39 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout39:setParent(obj.layout37);
    obj.layout39:setAlign("top");
    obj.layout39:setHeight(34);
    obj.layout39:setMargins({bottom=8});
    obj.layout39:setName("layout39");

    obj.label22 = GUI.fromHandle(_obj_newObject("label"));
    obj.label22:setParent(obj.layout39);
    obj.label22:setText("Estresse Mental");
    obj.label22:setAlign("left");
    obj.label22:setWidth(150);
    obj.label22:setFontSize(11);
    obj.label22:setFontColor("Gray");
    obj.label22:setVertTextAlign("center");
    obj.label22:setName("label22");

    obj.chkMentalTopo_1 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.chkMentalTopo_1:setParent(obj.layout39);
    obj.chkMentalTopo_1:setName("chkMentalTopo_1");
    obj.chkMentalTopo_1:setAlign("left");
    obj.chkMentalTopo_1:setWidth(30);
    obj.chkMentalTopo_1:setField("stM1");
    obj.chkMentalTopo_1:setText("1");
    obj.chkMentalTopo_1:setFontSize(10);

    obj.chkMentalTopo_2 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.chkMentalTopo_2:setParent(obj.layout39);
    obj.chkMentalTopo_2:setName("chkMentalTopo_2");
    obj.chkMentalTopo_2:setAlign("left");
    obj.chkMentalTopo_2:setWidth(30);
    obj.chkMentalTopo_2:setField("stM2");
    obj.chkMentalTopo_2:setText("2");
    obj.chkMentalTopo_2:setFontSize(10);

    obj.chkMentalTopo_3 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.chkMentalTopo_3:setParent(obj.layout39);
    obj.chkMentalTopo_3:setName("chkMentalTopo_3");
    obj.chkMentalTopo_3:setAlign("left");
    obj.chkMentalTopo_3:setWidth(30);
    obj.chkMentalTopo_3:setField("stM3");
    obj.chkMentalTopo_3:setText("3");
    obj.chkMentalTopo_3:setFontSize(10);

    obj.chkMentalTopo_4 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.chkMentalTopo_4:setParent(obj.layout39);
    obj.chkMentalTopo_4:setName("chkMentalTopo_4");
    obj.chkMentalTopo_4:setAlign("left");
    obj.chkMentalTopo_4:setWidth(30);
    obj.chkMentalTopo_4:setField("stM4");
    obj.chkMentalTopo_4:setText("4");
    obj.chkMentalTopo_4:setFontSize(10);

    obj.chkMentalTopo_5 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.chkMentalTopo_5:setParent(obj.layout39);
    obj.chkMentalTopo_5:setName("chkMentalTopo_5");
    obj.chkMentalTopo_5:setAlign("left");
    obj.chkMentalTopo_5:setWidth(30);
    obj.chkMentalTopo_5:setField("stM5");
    obj.chkMentalTopo_5:setText("5");
    obj.chkMentalTopo_5:setFontSize(10);
    obj.chkMentalTopo_5:setVisible(false);

    obj.chkMentalTopo_6 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.chkMentalTopo_6:setParent(obj.layout39);
    obj.chkMentalTopo_6:setName("chkMentalTopo_6");
    obj.chkMentalTopo_6:setAlign("left");
    obj.chkMentalTopo_6:setWidth(30);
    obj.chkMentalTopo_6:setField("stM6");
    obj.chkMentalTopo_6:setText("6");
    obj.chkMentalTopo_6:setFontSize(10);
    obj.chkMentalTopo_6:setVisible(false);

    obj.chkMentalTopo_7 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.chkMentalTopo_7:setParent(obj.layout39);
    obj.chkMentalTopo_7:setName("chkMentalTopo_7");
    obj.chkMentalTopo_7:setAlign("left");
    obj.chkMentalTopo_7:setWidth(30);
    obj.chkMentalTopo_7:setField("stM7");
    obj.chkMentalTopo_7:setText("7");
    obj.chkMentalTopo_7:setFontSize(10);
    obj.chkMentalTopo_7:setVisible(false);

    obj.chkMentalTopo_8 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.chkMentalTopo_8:setParent(obj.layout39);
    obj.chkMentalTopo_8:setName("chkMentalTopo_8");
    obj.chkMentalTopo_8:setAlign("left");
    obj.chkMentalTopo_8:setWidth(30);
    obj.chkMentalTopo_8:setField("stM8");
    obj.chkMentalTopo_8:setText("8");
    obj.chkMentalTopo_8:setFontSize(10);
    obj.chkMentalTopo_8:setVisible(false);

    obj.layout40 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout40:setParent(obj.layout37);
    obj.layout40:setAlign("top");
    obj.layout40:setHeight(34);
    obj.layout40:setMargins({bottom=6});
    obj.layout40:setName("layout40");

    obj.label23 = GUI.fromHandle(_obj_newObject("label"));
    obj.label23:setParent(obj.layout40);
    obj.label23:setText("Consequência Suave");
    obj.label23:setAlign("left");
    obj.label23:setWidth(150);
    obj.label23:setFontSize(11);
    obj.label23:setFontColor("#b9151f");
    obj.label23:setVertTextAlign("center");
    obj.label23:setName("label23");

    obj.edit40 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit40:setParent(obj.layout40);
    obj.edit40:setAlign("client");
    obj.edit40:setField("cons_suave");
    obj.edit40:setFontSize(12);
    obj.edit40:setName("edit40");

    obj.rowConsCSExtraTopo = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowConsCSExtraTopo:setParent(obj.layout37);
    obj.rowConsCSExtraTopo:setAlign("top");
    obj.rowConsCSExtraTopo:setHeight(34);
    obj.rowConsCSExtraTopo:setName("rowConsCSExtraTopo");
    obj.rowConsCSExtraTopo:setMargins({bottom=6});

    obj.label24 = GUI.fromHandle(_obj_newObject("label"));
    obj.label24:setParent(obj.rowConsCSExtraTopo);
    obj.label24:setText("Consequência Suave extra");
    obj.label24:setAlign("left");
    obj.label24:setWidth(150);
    obj.label24:setFontSize(11);
    obj.label24:setFontColor("#b9151f");
    obj.label24:setVertTextAlign("center");
    obj.label24:setName("label24");

    obj.edit41 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit41:setParent(obj.rowConsCSExtraTopo);
    obj.edit41:setAlign("client");
    obj.edit41:setField("cons_suaveX");
    obj.edit41:setFontSize(12);
    obj.edit41:setName("edit41");

    obj.layout41 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout41:setParent(obj.layout37);
    obj.layout41:setAlign("top");
    obj.layout41:setHeight(34);
    obj.layout41:setMargins({bottom=6});
    obj.layout41:setName("layout41");

    obj.label25 = GUI.fromHandle(_obj_newObject("label"));
    obj.label25:setParent(obj.layout41);
    obj.label25:setText("Consequência Moderada");
    obj.label25:setAlign("left");
    obj.label25:setWidth(150);
    obj.label25:setFontSize(11);
    obj.label25:setFontColor("#b9151f");
    obj.label25:setVertTextAlign("center");
    obj.label25:setName("label25");

    obj.edit42 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit42:setParent(obj.layout41);
    obj.edit42:setAlign("client");
    obj.edit42:setField("cons_moderada");
    obj.edit42:setFontSize(12);
    obj.edit42:setName("edit42");

    obj.layout42 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout42:setParent(obj.layout37);
    obj.layout42:setAlign("top");
    obj.layout42:setHeight(34);
    obj.layout42:setName("layout42");

    obj.label26 = GUI.fromHandle(_obj_newObject("label"));
    obj.label26:setParent(obj.layout42);
    obj.label26:setText("Consequência Grave");
    obj.label26:setAlign("left");
    obj.label26:setWidth(150);
    obj.label26:setFontSize(11);
    obj.label26:setFontColor("#b9151f");
    obj.label26:setVertTextAlign("center");
    obj.label26:setName("label26");

    obj.edit43 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit43:setParent(obj.layout42);
    obj.edit43:setAlign("client");
    obj.edit43:setField("cons_severa");
    obj.edit43:setFontSize(12);
    obj.edit43:setName("edit43");

    obj.label27 = GUI.fromHandle(_obj_newObject("label"));
    obj.label27:setParent(obj.layout34);
    obj.label27:setText("Aspectos");
    obj.label27:setAlign("top");
    obj.label27:setHeight(24);
    obj.label27:setFontSize(13);
    obj.label27:setFontColor("Gray");
    lfm_setPropAsString(obj.label27, "fontStyle", "bold");
    obj.label27:setMargins({bottom=6});
    obj.label27:setName("label27");

    obj.label28 = GUI.fromHandle(_obj_newObject("label"));
    obj.label28:setParent(obj.layout34);
    obj.label28:setText("Conceito");
    obj.label28:setAlign("top");
    obj.label28:setHeight(16);
    obj.label28:setFontSize(10);
    obj.label28:setFontColor("#b9151f");
    lfm_setPropAsString(obj.label28, "fontStyle", "bold");
    obj.label28:setName("label28");

    obj.edit44 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit44:setParent(obj.layout34);
    obj.edit44:setAlign("top");
    obj.edit44:setHeight(28);
    obj.edit44:setField("conceito");
    obj.edit44:setFontSize(13);
    obj.edit44:setMargins({bottom=8});
    obj.edit44:setName("edit44");

    obj.label29 = GUI.fromHandle(_obj_newObject("label"));
    obj.label29:setParent(obj.layout34);
    obj.label29:setText("Dificuldade");
    obj.label29:setAlign("top");
    obj.label29:setHeight(16);
    obj.label29:setFontSize(10);
    obj.label29:setFontColor("#b9151f");
    lfm_setPropAsString(obj.label29, "fontStyle", "bold");
    obj.label29:setName("label29");

    obj.edit45 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit45:setParent(obj.layout34);
    obj.edit45:setAlign("top");
    obj.edit45:setHeight(28);
    obj.edit45:setField("dificuldade");
    obj.edit45:setFontSize(13);
    obj.edit45:setMargins({bottom=8});
    obj.edit45:setName("edit45");

    obj.rowAspecto_1 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowAspecto_1:setParent(obj.layout34);
    obj.rowAspecto_1:setAlign("top");
    obj.rowAspecto_1:setHeight(34);
    obj.rowAspecto_1:setName("rowAspecto_1");
    obj.rowAspecto_1:setMargins({bottom=5});

    obj.label30 = GUI.fromHandle(_obj_newObject("label"));
    obj.label30:setParent(obj.rowAspecto_1);
    obj.label30:setText("Aspecto");
    obj.label30:setAlign("top");
    obj.label30:setHeight(16);
    obj.label30:setFontSize(10);
    obj.label30:setFontColor("Gray");
    lfm_setPropAsString(obj.label30, "fontStyle", "bold");
    obj.label30:setName("label30");

    obj.edit46 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit46:setParent(obj.rowAspecto_1);
    obj.edit46:setAlign("client");
    obj.edit46:setField("aspecto1");
    obj.edit46:setFontSize(13);
    obj.edit46:setName("edit46");

    obj.rowAspecto_2 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowAspecto_2:setParent(obj.layout34);
    obj.rowAspecto_2:setAlign("top");
    obj.rowAspecto_2:setHeight(34);
    obj.rowAspecto_2:setName("rowAspecto_2");
    obj.rowAspecto_2:setMargins({bottom=5});

    obj.label31 = GUI.fromHandle(_obj_newObject("label"));
    obj.label31:setParent(obj.rowAspecto_2);
    obj.label31:setText("Aspecto");
    obj.label31:setAlign("top");
    obj.label31:setHeight(16);
    obj.label31:setFontSize(10);
    obj.label31:setFontColor("Gray");
    lfm_setPropAsString(obj.label31, "fontStyle", "bold");
    obj.label31:setName("label31");

    obj.edit47 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit47:setParent(obj.rowAspecto_2);
    obj.edit47:setAlign("client");
    obj.edit47:setField("aspecto2");
    obj.edit47:setFontSize(13);
    obj.edit47:setName("edit47");

    obj.rowAspecto_3 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowAspecto_3:setParent(obj.layout34);
    obj.rowAspecto_3:setAlign("top");
    obj.rowAspecto_3:setHeight(34);
    obj.rowAspecto_3:setName("rowAspecto_3");
    obj.rowAspecto_3:setMargins({bottom=5});

    obj.label32 = GUI.fromHandle(_obj_newObject("label"));
    obj.label32:setParent(obj.rowAspecto_3);
    obj.label32:setText("Aspecto");
    obj.label32:setAlign("top");
    obj.label32:setHeight(16);
    obj.label32:setFontSize(10);
    obj.label32:setFontColor("Gray");
    lfm_setPropAsString(obj.label32, "fontStyle", "bold");
    obj.label32:setName("label32");

    obj.edit48 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit48:setParent(obj.rowAspecto_3);
    obj.edit48:setAlign("client");
    obj.edit48:setField("aspecto3");
    obj.edit48:setFontSize(13);
    obj.edit48:setName("edit48");

    obj.rowAspecto_4 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowAspecto_4:setParent(obj.layout34);
    obj.rowAspecto_4:setAlign("top");
    obj.rowAspecto_4:setHeight(34);
    obj.rowAspecto_4:setName("rowAspecto_4");
    obj.rowAspecto_4:setVisible(false);
    obj.rowAspecto_4:setMargins({bottom=5});

    obj.label33 = GUI.fromHandle(_obj_newObject("label"));
    obj.label33:setParent(obj.rowAspecto_4);
    obj.label33:setText("Aspecto");
    obj.label33:setAlign("top");
    obj.label33:setHeight(16);
    obj.label33:setFontSize(10);
    obj.label33:setFontColor("Gray");
    lfm_setPropAsString(obj.label33, "fontStyle", "bold");
    obj.label33:setName("label33");

    obj.edit49 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit49:setParent(obj.rowAspecto_4);
    obj.edit49:setAlign("client");
    obj.edit49:setField("aspecto4");
    obj.edit49:setFontSize(13);
    obj.edit49:setName("edit49");

    obj.rowAspecto_5 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowAspecto_5:setParent(obj.layout34);
    obj.rowAspecto_5:setAlign("top");
    obj.rowAspecto_5:setHeight(34);
    obj.rowAspecto_5:setName("rowAspecto_5");
    obj.rowAspecto_5:setVisible(false);
    obj.rowAspecto_5:setMargins({bottom=5});

    obj.label34 = GUI.fromHandle(_obj_newObject("label"));
    obj.label34:setParent(obj.rowAspecto_5);
    obj.label34:setText("Aspecto");
    obj.label34:setAlign("top");
    obj.label34:setHeight(16);
    obj.label34:setFontSize(10);
    obj.label34:setFontColor("Gray");
    lfm_setPropAsString(obj.label34, "fontStyle", "bold");
    obj.label34:setName("label34");

    obj.edit50 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit50:setParent(obj.rowAspecto_5);
    obj.edit50:setAlign("client");
    obj.edit50:setField("aspecto5");
    obj.edit50:setFontSize(13);
    obj.edit50:setName("edit50");

    obj.rowAspecto_6 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowAspecto_6:setParent(obj.layout34);
    obj.rowAspecto_6:setAlign("top");
    obj.rowAspecto_6:setHeight(34);
    obj.rowAspecto_6:setName("rowAspecto_6");
    obj.rowAspecto_6:setVisible(false);
    obj.rowAspecto_6:setMargins({bottom=5});

    obj.label35 = GUI.fromHandle(_obj_newObject("label"));
    obj.label35:setParent(obj.rowAspecto_6);
    obj.label35:setText("Aspecto");
    obj.label35:setAlign("top");
    obj.label35:setHeight(16);
    obj.label35:setFontSize(10);
    obj.label35:setFontColor("Gray");
    lfm_setPropAsString(obj.label35, "fontStyle", "bold");
    obj.label35:setName("label35");

    obj.edit51 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit51:setParent(obj.rowAspecto_6);
    obj.edit51:setAlign("client");
    obj.edit51:setField("aspecto6");
    obj.edit51:setFontSize(13);
    obj.edit51:setName("edit51");

    obj.rowAspecto_7 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowAspecto_7:setParent(obj.layout34);
    obj.rowAspecto_7:setAlign("top");
    obj.rowAspecto_7:setHeight(34);
    obj.rowAspecto_7:setName("rowAspecto_7");
    obj.rowAspecto_7:setVisible(false);
    obj.rowAspecto_7:setMargins({bottom=5});

    obj.label36 = GUI.fromHandle(_obj_newObject("label"));
    obj.label36:setParent(obj.rowAspecto_7);
    obj.label36:setText("Aspecto");
    obj.label36:setAlign("top");
    obj.label36:setHeight(16);
    obj.label36:setFontSize(10);
    obj.label36:setFontColor("Gray");
    lfm_setPropAsString(obj.label36, "fontStyle", "bold");
    obj.label36:setName("label36");

    obj.edit52 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit52:setParent(obj.rowAspecto_7);
    obj.edit52:setAlign("client");
    obj.edit52:setField("aspecto7");
    obj.edit52:setFontSize(13);
    obj.edit52:setName("edit52");

    obj.listaPericiasFacanhas = GUI.fromHandle(_obj_newObject("layout"));
    obj.listaPericiasFacanhas:setParent(obj.layout1);
    obj.listaPericiasFacanhas:setName("listaPericiasFacanhas");
    obj.listaPericiasFacanhas:setAlign("top");
    obj.listaPericiasFacanhas:setHeight(600);
    obj.listaPericiasFacanhas:setMargins({bottom=10});

    obj.layout43 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout43:setParent(obj.listaPericiasFacanhas);
    obj.layout43:setAlign("left");
    obj.layout43:setWidth(520);
    obj.layout43:setMargins({right=12});
    obj.layout43:setName("layout43");

    obj.layout44 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout44:setParent(obj.layout43);
    obj.layout44:setAlign("top");
    obj.layout44:setHeight(30);
    obj.layout44:setMargins({bottom=6});
    obj.layout44:setName("layout44");

    obj.label37 = GUI.fromHandle(_obj_newObject("label"));
    obj.label37:setParent(obj.layout44);
    obj.label37:setText("Perícias");
    obj.label37:setAlign("left");
    obj.label37:setWidth(130);
    obj.label37:setFontSize(13);
    obj.label37:setFontColor("Gray");
    lfm_setPropAsString(obj.label37, "fontStyle", "bold");
    obj.label37:setVertTextAlign("center");
    obj.label37:setName("label37");

    obj.button20 = GUI.fromHandle(_obj_newObject("button"));
    obj.button20:setParent(obj.layout44);
    obj.button20:setAlign("right");
    obj.button20:setWidth(116);
    obj.button20:setHeight(30);
    obj.button20:setText("+ Adicionar Perícia");
    obj.button20:setFontSize(11);
    obj.button20:setName("button20");

    obj.rowPericia_1 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowPericia_1:setParent(obj.layout43);
    obj.rowPericia_1:setAlign("top");
    obj.rowPericia_1:setHeight(52);
    obj.rowPericia_1:setName("rowPericia_1");
    obj.rowPericia_1:setMargins({bottom=5});

    obj.layout45 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout45:setParent(obj.rowPericia_1);
    obj.layout45:setAlign("top");
    obj.layout45:setHeight(30);
    obj.layout45:setName("layout45");

    obj.edit53 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit53:setParent(obj.layout45);
    obj.edit53:setAlign("left");
    obj.edit53:setWidth(52);
    obj.edit53:setField("pericia1_valor");
    obj.edit53:setHint("Valor");
    obj.edit53:setFontSize(12);
    obj.edit53:setHorzTextAlign("center");
    obj.edit53:setMargins({right=4});
    obj.edit53:setName("edit53");

    obj.pericia_1_nome = GUI.fromHandle(_obj_newObject("edit"));
    obj.pericia_1_nome:setParent(obj.layout45);
    obj.pericia_1_nome:setName("pericia_1_nome");
    obj.pericia_1_nome:setAlign("client");
    obj.pericia_1_nome:setField("pericia1_nome");
    obj.pericia_1_nome:setHint("Nome");
    obj.pericia_1_nome:setFontSize(13);
    obj.pericia_1_nome:setMargins({right=4});

    obj.pericia_1_bonus = GUI.fromHandle(_obj_newObject("edit"));
    obj.pericia_1_bonus:setParent(obj.layout45);
    obj.pericia_1_bonus:setName("pericia_1_bonus");
    obj.pericia_1_bonus:setAlign("right");
    obj.pericia_1_bonus:setWidth(52);
    obj.pericia_1_bonus:setField("pericia1_bonus");
    obj.pericia_1_bonus:setHint("Bônus");
    obj.pericia_1_bonus:setFontSize(12);
    obj.pericia_1_bonus:setHorzTextAlign("center");
    obj.pericia_1_bonus:setMargins({right=4});

    obj.button21 = GUI.fromHandle(_obj_newObject("button"));
    obj.button21:setParent(obj.layout45);
    obj.button21:setAlign("right");
    obj.button21:setWidth(42);
    obj.button21:setText("dF");
    obj.button21:setFontSize(11);
    obj.button21:setName("button21");

    obj.button22 = GUI.fromHandle(_obj_newObject("button"));
    obj.button22:setParent(obj.layout45);
    obj.button22:setAlign("right");
    obj.button22:setWidth(72);
    obj.button22:setText("Remover");
    obj.button22:setFontSize(10);
    obj.button22:setMargins({right=4});
    obj.button22:setName("button22");

    obj.nivelPericia_1 = GUI.fromHandle(_obj_newObject("label"));
    obj.nivelPericia_1:setParent(obj.rowPericia_1);
    obj.nivelPericia_1:setName("nivelPericia_1");
    obj.nivelPericia_1:setText("");
    obj.nivelPericia_1:setAlign("client");
    obj.nivelPericia_1:setFontSize(10);
    obj.nivelPericia_1:setFontColor("Gray");

    obj.rowPericia_2 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowPericia_2:setParent(obj.layout43);
    obj.rowPericia_2:setAlign("top");
    obj.rowPericia_2:setHeight(52);
    obj.rowPericia_2:setName("rowPericia_2");
    obj.rowPericia_2:setMargins({bottom=5});

    obj.layout46 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout46:setParent(obj.rowPericia_2);
    obj.layout46:setAlign("top");
    obj.layout46:setHeight(30);
    obj.layout46:setName("layout46");

    obj.edit54 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit54:setParent(obj.layout46);
    obj.edit54:setAlign("left");
    obj.edit54:setWidth(52);
    obj.edit54:setField("pericia2_valor");
    obj.edit54:setHint("Valor");
    obj.edit54:setFontSize(12);
    obj.edit54:setHorzTextAlign("center");
    obj.edit54:setMargins({right=4});
    obj.edit54:setName("edit54");

    obj.pericia_2_nome = GUI.fromHandle(_obj_newObject("edit"));
    obj.pericia_2_nome:setParent(obj.layout46);
    obj.pericia_2_nome:setName("pericia_2_nome");
    obj.pericia_2_nome:setAlign("client");
    obj.pericia_2_nome:setField("pericia2_nome");
    obj.pericia_2_nome:setHint("Nome");
    obj.pericia_2_nome:setFontSize(13);
    obj.pericia_2_nome:setMargins({right=4});

    obj.pericia_2_bonus = GUI.fromHandle(_obj_newObject("edit"));
    obj.pericia_2_bonus:setParent(obj.layout46);
    obj.pericia_2_bonus:setName("pericia_2_bonus");
    obj.pericia_2_bonus:setAlign("right");
    obj.pericia_2_bonus:setWidth(52);
    obj.pericia_2_bonus:setField("pericia2_bonus");
    obj.pericia_2_bonus:setHint("Bônus");
    obj.pericia_2_bonus:setFontSize(12);
    obj.pericia_2_bonus:setHorzTextAlign("center");
    obj.pericia_2_bonus:setMargins({right=4});

    obj.button23 = GUI.fromHandle(_obj_newObject("button"));
    obj.button23:setParent(obj.layout46);
    obj.button23:setAlign("right");
    obj.button23:setWidth(42);
    obj.button23:setText("dF");
    obj.button23:setFontSize(11);
    obj.button23:setName("button23");

    obj.button24 = GUI.fromHandle(_obj_newObject("button"));
    obj.button24:setParent(obj.layout46);
    obj.button24:setAlign("right");
    obj.button24:setWidth(72);
    obj.button24:setText("Remover");
    obj.button24:setFontSize(10);
    obj.button24:setMargins({right=4});
    obj.button24:setName("button24");

    obj.nivelPericia_2 = GUI.fromHandle(_obj_newObject("label"));
    obj.nivelPericia_2:setParent(obj.rowPericia_2);
    obj.nivelPericia_2:setName("nivelPericia_2");
    obj.nivelPericia_2:setText("");
    obj.nivelPericia_2:setAlign("client");
    obj.nivelPericia_2:setFontSize(10);
    obj.nivelPericia_2:setFontColor("Gray");

    obj.rowPericia_3 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowPericia_3:setParent(obj.layout43);
    obj.rowPericia_3:setAlign("top");
    obj.rowPericia_3:setHeight(52);
    obj.rowPericia_3:setName("rowPericia_3");
    obj.rowPericia_3:setMargins({bottom=5});

    obj.layout47 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout47:setParent(obj.rowPericia_3);
    obj.layout47:setAlign("top");
    obj.layout47:setHeight(30);
    obj.layout47:setName("layout47");

    obj.edit55 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit55:setParent(obj.layout47);
    obj.edit55:setAlign("left");
    obj.edit55:setWidth(52);
    obj.edit55:setField("pericia3_valor");
    obj.edit55:setHint("Valor");
    obj.edit55:setFontSize(12);
    obj.edit55:setHorzTextAlign("center");
    obj.edit55:setMargins({right=4});
    obj.edit55:setName("edit55");

    obj.pericia_3_nome = GUI.fromHandle(_obj_newObject("edit"));
    obj.pericia_3_nome:setParent(obj.layout47);
    obj.pericia_3_nome:setName("pericia_3_nome");
    obj.pericia_3_nome:setAlign("client");
    obj.pericia_3_nome:setField("pericia3_nome");
    obj.pericia_3_nome:setHint("Nome");
    obj.pericia_3_nome:setFontSize(13);
    obj.pericia_3_nome:setMargins({right=4});

    obj.pericia_3_bonus = GUI.fromHandle(_obj_newObject("edit"));
    obj.pericia_3_bonus:setParent(obj.layout47);
    obj.pericia_3_bonus:setName("pericia_3_bonus");
    obj.pericia_3_bonus:setAlign("right");
    obj.pericia_3_bonus:setWidth(52);
    obj.pericia_3_bonus:setField("pericia3_bonus");
    obj.pericia_3_bonus:setHint("Bônus");
    obj.pericia_3_bonus:setFontSize(12);
    obj.pericia_3_bonus:setHorzTextAlign("center");
    obj.pericia_3_bonus:setMargins({right=4});

    obj.button25 = GUI.fromHandle(_obj_newObject("button"));
    obj.button25:setParent(obj.layout47);
    obj.button25:setAlign("right");
    obj.button25:setWidth(42);
    obj.button25:setText("dF");
    obj.button25:setFontSize(11);
    obj.button25:setName("button25");

    obj.button26 = GUI.fromHandle(_obj_newObject("button"));
    obj.button26:setParent(obj.layout47);
    obj.button26:setAlign("right");
    obj.button26:setWidth(72);
    obj.button26:setText("Remover");
    obj.button26:setFontSize(10);
    obj.button26:setMargins({right=4});
    obj.button26:setName("button26");

    obj.nivelPericia_3 = GUI.fromHandle(_obj_newObject("label"));
    obj.nivelPericia_3:setParent(obj.rowPericia_3);
    obj.nivelPericia_3:setName("nivelPericia_3");
    obj.nivelPericia_3:setText("");
    obj.nivelPericia_3:setAlign("client");
    obj.nivelPericia_3:setFontSize(10);
    obj.nivelPericia_3:setFontColor("Gray");

    obj.rowPericia_4 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowPericia_4:setParent(obj.layout43);
    obj.rowPericia_4:setAlign("top");
    obj.rowPericia_4:setHeight(52);
    obj.rowPericia_4:setName("rowPericia_4");
    obj.rowPericia_4:setMargins({bottom=5});

    obj.layout48 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout48:setParent(obj.rowPericia_4);
    obj.layout48:setAlign("top");
    obj.layout48:setHeight(30);
    obj.layout48:setName("layout48");

    obj.edit56 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit56:setParent(obj.layout48);
    obj.edit56:setAlign("left");
    obj.edit56:setWidth(52);
    obj.edit56:setField("pericia4_valor");
    obj.edit56:setHint("Valor");
    obj.edit56:setFontSize(12);
    obj.edit56:setHorzTextAlign("center");
    obj.edit56:setMargins({right=4});
    obj.edit56:setName("edit56");

    obj.pericia_4_nome = GUI.fromHandle(_obj_newObject("edit"));
    obj.pericia_4_nome:setParent(obj.layout48);
    obj.pericia_4_nome:setName("pericia_4_nome");
    obj.pericia_4_nome:setAlign("client");
    obj.pericia_4_nome:setField("pericia4_nome");
    obj.pericia_4_nome:setHint("Nome");
    obj.pericia_4_nome:setFontSize(13);
    obj.pericia_4_nome:setMargins({right=4});

    obj.pericia_4_bonus = GUI.fromHandle(_obj_newObject("edit"));
    obj.pericia_4_bonus:setParent(obj.layout48);
    obj.pericia_4_bonus:setName("pericia_4_bonus");
    obj.pericia_4_bonus:setAlign("right");
    obj.pericia_4_bonus:setWidth(52);
    obj.pericia_4_bonus:setField("pericia4_bonus");
    obj.pericia_4_bonus:setHint("Bônus");
    obj.pericia_4_bonus:setFontSize(12);
    obj.pericia_4_bonus:setHorzTextAlign("center");
    obj.pericia_4_bonus:setMargins({right=4});

    obj.button27 = GUI.fromHandle(_obj_newObject("button"));
    obj.button27:setParent(obj.layout48);
    obj.button27:setAlign("right");
    obj.button27:setWidth(42);
    obj.button27:setText("dF");
    obj.button27:setFontSize(11);
    obj.button27:setName("button27");

    obj.button28 = GUI.fromHandle(_obj_newObject("button"));
    obj.button28:setParent(obj.layout48);
    obj.button28:setAlign("right");
    obj.button28:setWidth(72);
    obj.button28:setText("Remover");
    obj.button28:setFontSize(10);
    obj.button28:setMargins({right=4});
    obj.button28:setName("button28");

    obj.nivelPericia_4 = GUI.fromHandle(_obj_newObject("label"));
    obj.nivelPericia_4:setParent(obj.rowPericia_4);
    obj.nivelPericia_4:setName("nivelPericia_4");
    obj.nivelPericia_4:setText("");
    obj.nivelPericia_4:setAlign("client");
    obj.nivelPericia_4:setFontSize(10);
    obj.nivelPericia_4:setFontColor("Gray");

    obj.rowPericia_5 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowPericia_5:setParent(obj.layout43);
    obj.rowPericia_5:setAlign("top");
    obj.rowPericia_5:setHeight(52);
    obj.rowPericia_5:setName("rowPericia_5");
    obj.rowPericia_5:setVisible(false);
    obj.rowPericia_5:setMargins({bottom=5});

    obj.layout49 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout49:setParent(obj.rowPericia_5);
    obj.layout49:setAlign("top");
    obj.layout49:setHeight(30);
    obj.layout49:setName("layout49");

    obj.edit57 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit57:setParent(obj.layout49);
    obj.edit57:setAlign("left");
    obj.edit57:setWidth(52);
    obj.edit57:setField("pericia5_valor");
    obj.edit57:setHint("Valor");
    obj.edit57:setFontSize(12);
    obj.edit57:setHorzTextAlign("center");
    obj.edit57:setMargins({right=4});
    obj.edit57:setName("edit57");

    obj.pericia_5_nome = GUI.fromHandle(_obj_newObject("edit"));
    obj.pericia_5_nome:setParent(obj.layout49);
    obj.pericia_5_nome:setName("pericia_5_nome");
    obj.pericia_5_nome:setAlign("client");
    obj.pericia_5_nome:setField("pericia5_nome");
    obj.pericia_5_nome:setHint("Nome");
    obj.pericia_5_nome:setFontSize(13);
    obj.pericia_5_nome:setMargins({right=4});

    obj.pericia_5_bonus = GUI.fromHandle(_obj_newObject("edit"));
    obj.pericia_5_bonus:setParent(obj.layout49);
    obj.pericia_5_bonus:setName("pericia_5_bonus");
    obj.pericia_5_bonus:setAlign("right");
    obj.pericia_5_bonus:setWidth(52);
    obj.pericia_5_bonus:setField("pericia5_bonus");
    obj.pericia_5_bonus:setHint("Bônus");
    obj.pericia_5_bonus:setFontSize(12);
    obj.pericia_5_bonus:setHorzTextAlign("center");
    obj.pericia_5_bonus:setMargins({right=4});

    obj.button29 = GUI.fromHandle(_obj_newObject("button"));
    obj.button29:setParent(obj.layout49);
    obj.button29:setAlign("right");
    obj.button29:setWidth(42);
    obj.button29:setText("dF");
    obj.button29:setFontSize(11);
    obj.button29:setName("button29");

    obj.button30 = GUI.fromHandle(_obj_newObject("button"));
    obj.button30:setParent(obj.layout49);
    obj.button30:setAlign("right");
    obj.button30:setWidth(72);
    obj.button30:setText("Remover");
    obj.button30:setFontSize(10);
    obj.button30:setMargins({right=4});
    obj.button30:setName("button30");

    obj.nivelPericia_5 = GUI.fromHandle(_obj_newObject("label"));
    obj.nivelPericia_5:setParent(obj.rowPericia_5);
    obj.nivelPericia_5:setName("nivelPericia_5");
    obj.nivelPericia_5:setText("");
    obj.nivelPericia_5:setAlign("client");
    obj.nivelPericia_5:setFontSize(10);
    obj.nivelPericia_5:setFontColor("Gray");

    obj.rowPericia_6 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowPericia_6:setParent(obj.layout43);
    obj.rowPericia_6:setAlign("top");
    obj.rowPericia_6:setHeight(52);
    obj.rowPericia_6:setName("rowPericia_6");
    obj.rowPericia_6:setVisible(false);
    obj.rowPericia_6:setMargins({bottom=5});

    obj.layout50 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout50:setParent(obj.rowPericia_6);
    obj.layout50:setAlign("top");
    obj.layout50:setHeight(30);
    obj.layout50:setName("layout50");

    obj.edit58 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit58:setParent(obj.layout50);
    obj.edit58:setAlign("left");
    obj.edit58:setWidth(52);
    obj.edit58:setField("pericia6_valor");
    obj.edit58:setHint("Valor");
    obj.edit58:setFontSize(12);
    obj.edit58:setHorzTextAlign("center");
    obj.edit58:setMargins({right=4});
    obj.edit58:setName("edit58");

    obj.pericia_6_nome = GUI.fromHandle(_obj_newObject("edit"));
    obj.pericia_6_nome:setParent(obj.layout50);
    obj.pericia_6_nome:setName("pericia_6_nome");
    obj.pericia_6_nome:setAlign("client");
    obj.pericia_6_nome:setField("pericia6_nome");
    obj.pericia_6_nome:setHint("Nome");
    obj.pericia_6_nome:setFontSize(13);
    obj.pericia_6_nome:setMargins({right=4});

    obj.pericia_6_bonus = GUI.fromHandle(_obj_newObject("edit"));
    obj.pericia_6_bonus:setParent(obj.layout50);
    obj.pericia_6_bonus:setName("pericia_6_bonus");
    obj.pericia_6_bonus:setAlign("right");
    obj.pericia_6_bonus:setWidth(52);
    obj.pericia_6_bonus:setField("pericia6_bonus");
    obj.pericia_6_bonus:setHint("Bônus");
    obj.pericia_6_bonus:setFontSize(12);
    obj.pericia_6_bonus:setHorzTextAlign("center");
    obj.pericia_6_bonus:setMargins({right=4});

    obj.button31 = GUI.fromHandle(_obj_newObject("button"));
    obj.button31:setParent(obj.layout50);
    obj.button31:setAlign("right");
    obj.button31:setWidth(42);
    obj.button31:setText("dF");
    obj.button31:setFontSize(11);
    obj.button31:setName("button31");

    obj.button32 = GUI.fromHandle(_obj_newObject("button"));
    obj.button32:setParent(obj.layout50);
    obj.button32:setAlign("right");
    obj.button32:setWidth(72);
    obj.button32:setText("Remover");
    obj.button32:setFontSize(10);
    obj.button32:setMargins({right=4});
    obj.button32:setName("button32");

    obj.nivelPericia_6 = GUI.fromHandle(_obj_newObject("label"));
    obj.nivelPericia_6:setParent(obj.rowPericia_6);
    obj.nivelPericia_6:setName("nivelPericia_6");
    obj.nivelPericia_6:setText("");
    obj.nivelPericia_6:setAlign("client");
    obj.nivelPericia_6:setFontSize(10);
    obj.nivelPericia_6:setFontColor("Gray");

    obj.rowPericia_7 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowPericia_7:setParent(obj.layout43);
    obj.rowPericia_7:setAlign("top");
    obj.rowPericia_7:setHeight(52);
    obj.rowPericia_7:setName("rowPericia_7");
    obj.rowPericia_7:setVisible(false);
    obj.rowPericia_7:setMargins({bottom=5});

    obj.layout51 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout51:setParent(obj.rowPericia_7);
    obj.layout51:setAlign("top");
    obj.layout51:setHeight(30);
    obj.layout51:setName("layout51");

    obj.edit59 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit59:setParent(obj.layout51);
    obj.edit59:setAlign("left");
    obj.edit59:setWidth(52);
    obj.edit59:setField("pericia7_valor");
    obj.edit59:setHint("Valor");
    obj.edit59:setFontSize(12);
    obj.edit59:setHorzTextAlign("center");
    obj.edit59:setMargins({right=4});
    obj.edit59:setName("edit59");

    obj.pericia_7_nome = GUI.fromHandle(_obj_newObject("edit"));
    obj.pericia_7_nome:setParent(obj.layout51);
    obj.pericia_7_nome:setName("pericia_7_nome");
    obj.pericia_7_nome:setAlign("client");
    obj.pericia_7_nome:setField("pericia7_nome");
    obj.pericia_7_nome:setHint("Nome");
    obj.pericia_7_nome:setFontSize(13);
    obj.pericia_7_nome:setMargins({right=4});

    obj.pericia_7_bonus = GUI.fromHandle(_obj_newObject("edit"));
    obj.pericia_7_bonus:setParent(obj.layout51);
    obj.pericia_7_bonus:setName("pericia_7_bonus");
    obj.pericia_7_bonus:setAlign("right");
    obj.pericia_7_bonus:setWidth(52);
    obj.pericia_7_bonus:setField("pericia7_bonus");
    obj.pericia_7_bonus:setHint("Bônus");
    obj.pericia_7_bonus:setFontSize(12);
    obj.pericia_7_bonus:setHorzTextAlign("center");
    obj.pericia_7_bonus:setMargins({right=4});

    obj.button33 = GUI.fromHandle(_obj_newObject("button"));
    obj.button33:setParent(obj.layout51);
    obj.button33:setAlign("right");
    obj.button33:setWidth(42);
    obj.button33:setText("dF");
    obj.button33:setFontSize(11);
    obj.button33:setName("button33");

    obj.button34 = GUI.fromHandle(_obj_newObject("button"));
    obj.button34:setParent(obj.layout51);
    obj.button34:setAlign("right");
    obj.button34:setWidth(72);
    obj.button34:setText("Remover");
    obj.button34:setFontSize(10);
    obj.button34:setMargins({right=4});
    obj.button34:setName("button34");

    obj.nivelPericia_7 = GUI.fromHandle(_obj_newObject("label"));
    obj.nivelPericia_7:setParent(obj.rowPericia_7);
    obj.nivelPericia_7:setName("nivelPericia_7");
    obj.nivelPericia_7:setText("");
    obj.nivelPericia_7:setAlign("client");
    obj.nivelPericia_7:setFontSize(10);
    obj.nivelPericia_7:setFontColor("Gray");

    obj.rowPericia_8 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowPericia_8:setParent(obj.layout43);
    obj.rowPericia_8:setAlign("top");
    obj.rowPericia_8:setHeight(52);
    obj.rowPericia_8:setName("rowPericia_8");
    obj.rowPericia_8:setVisible(false);
    obj.rowPericia_8:setMargins({bottom=5});

    obj.layout52 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout52:setParent(obj.rowPericia_8);
    obj.layout52:setAlign("top");
    obj.layout52:setHeight(30);
    obj.layout52:setName("layout52");

    obj.edit60 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit60:setParent(obj.layout52);
    obj.edit60:setAlign("left");
    obj.edit60:setWidth(52);
    obj.edit60:setField("pericia8_valor");
    obj.edit60:setHint("Valor");
    obj.edit60:setFontSize(12);
    obj.edit60:setHorzTextAlign("center");
    obj.edit60:setMargins({right=4});
    obj.edit60:setName("edit60");

    obj.pericia_8_nome = GUI.fromHandle(_obj_newObject("edit"));
    obj.pericia_8_nome:setParent(obj.layout52);
    obj.pericia_8_nome:setName("pericia_8_nome");
    obj.pericia_8_nome:setAlign("client");
    obj.pericia_8_nome:setField("pericia8_nome");
    obj.pericia_8_nome:setHint("Nome");
    obj.pericia_8_nome:setFontSize(13);
    obj.pericia_8_nome:setMargins({right=4});

    obj.pericia_8_bonus = GUI.fromHandle(_obj_newObject("edit"));
    obj.pericia_8_bonus:setParent(obj.layout52);
    obj.pericia_8_bonus:setName("pericia_8_bonus");
    obj.pericia_8_bonus:setAlign("right");
    obj.pericia_8_bonus:setWidth(52);
    obj.pericia_8_bonus:setField("pericia8_bonus");
    obj.pericia_8_bonus:setHint("Bônus");
    obj.pericia_8_bonus:setFontSize(12);
    obj.pericia_8_bonus:setHorzTextAlign("center");
    obj.pericia_8_bonus:setMargins({right=4});

    obj.button35 = GUI.fromHandle(_obj_newObject("button"));
    obj.button35:setParent(obj.layout52);
    obj.button35:setAlign("right");
    obj.button35:setWidth(42);
    obj.button35:setText("dF");
    obj.button35:setFontSize(11);
    obj.button35:setName("button35");

    obj.button36 = GUI.fromHandle(_obj_newObject("button"));
    obj.button36:setParent(obj.layout52);
    obj.button36:setAlign("right");
    obj.button36:setWidth(72);
    obj.button36:setText("Remover");
    obj.button36:setFontSize(10);
    obj.button36:setMargins({right=4});
    obj.button36:setName("button36");

    obj.nivelPericia_8 = GUI.fromHandle(_obj_newObject("label"));
    obj.nivelPericia_8:setParent(obj.rowPericia_8);
    obj.nivelPericia_8:setName("nivelPericia_8");
    obj.nivelPericia_8:setText("");
    obj.nivelPericia_8:setAlign("client");
    obj.nivelPericia_8:setFontSize(10);
    obj.nivelPericia_8:setFontColor("Gray");

    obj.rowPericia_9 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowPericia_9:setParent(obj.layout43);
    obj.rowPericia_9:setAlign("top");
    obj.rowPericia_9:setHeight(52);
    obj.rowPericia_9:setName("rowPericia_9");
    obj.rowPericia_9:setVisible(false);
    obj.rowPericia_9:setMargins({bottom=5});

    obj.layout53 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout53:setParent(obj.rowPericia_9);
    obj.layout53:setAlign("top");
    obj.layout53:setHeight(30);
    obj.layout53:setName("layout53");

    obj.edit61 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit61:setParent(obj.layout53);
    obj.edit61:setAlign("left");
    obj.edit61:setWidth(52);
    obj.edit61:setField("pericia9_valor");
    obj.edit61:setHint("Valor");
    obj.edit61:setFontSize(12);
    obj.edit61:setHorzTextAlign("center");
    obj.edit61:setMargins({right=4});
    obj.edit61:setName("edit61");

    obj.pericia_9_nome = GUI.fromHandle(_obj_newObject("edit"));
    obj.pericia_9_nome:setParent(obj.layout53);
    obj.pericia_9_nome:setName("pericia_9_nome");
    obj.pericia_9_nome:setAlign("client");
    obj.pericia_9_nome:setField("pericia9_nome");
    obj.pericia_9_nome:setHint("Nome");
    obj.pericia_9_nome:setFontSize(13);
    obj.pericia_9_nome:setMargins({right=4});

    obj.pericia_9_bonus = GUI.fromHandle(_obj_newObject("edit"));
    obj.pericia_9_bonus:setParent(obj.layout53);
    obj.pericia_9_bonus:setName("pericia_9_bonus");
    obj.pericia_9_bonus:setAlign("right");
    obj.pericia_9_bonus:setWidth(52);
    obj.pericia_9_bonus:setField("pericia9_bonus");
    obj.pericia_9_bonus:setHint("Bônus");
    obj.pericia_9_bonus:setFontSize(12);
    obj.pericia_9_bonus:setHorzTextAlign("center");
    obj.pericia_9_bonus:setMargins({right=4});

    obj.button37 = GUI.fromHandle(_obj_newObject("button"));
    obj.button37:setParent(obj.layout53);
    obj.button37:setAlign("right");
    obj.button37:setWidth(42);
    obj.button37:setText("dF");
    obj.button37:setFontSize(11);
    obj.button37:setName("button37");

    obj.button38 = GUI.fromHandle(_obj_newObject("button"));
    obj.button38:setParent(obj.layout53);
    obj.button38:setAlign("right");
    obj.button38:setWidth(72);
    obj.button38:setText("Remover");
    obj.button38:setFontSize(10);
    obj.button38:setMargins({right=4});
    obj.button38:setName("button38");

    obj.nivelPericia_9 = GUI.fromHandle(_obj_newObject("label"));
    obj.nivelPericia_9:setParent(obj.rowPericia_9);
    obj.nivelPericia_9:setName("nivelPericia_9");
    obj.nivelPericia_9:setText("");
    obj.nivelPericia_9:setAlign("client");
    obj.nivelPericia_9:setFontSize(10);
    obj.nivelPericia_9:setFontColor("Gray");

    obj.rowPericia_10 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowPericia_10:setParent(obj.layout43);
    obj.rowPericia_10:setAlign("top");
    obj.rowPericia_10:setHeight(52);
    obj.rowPericia_10:setName("rowPericia_10");
    obj.rowPericia_10:setVisible(false);
    obj.rowPericia_10:setMargins({bottom=5});

    obj.layout54 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout54:setParent(obj.rowPericia_10);
    obj.layout54:setAlign("top");
    obj.layout54:setHeight(30);
    obj.layout54:setName("layout54");

    obj.edit62 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit62:setParent(obj.layout54);
    obj.edit62:setAlign("left");
    obj.edit62:setWidth(52);
    obj.edit62:setField("pericia10_valor");
    obj.edit62:setHint("Valor");
    obj.edit62:setFontSize(12);
    obj.edit62:setHorzTextAlign("center");
    obj.edit62:setMargins({right=4});
    obj.edit62:setName("edit62");

    obj.pericia_10_nome = GUI.fromHandle(_obj_newObject("edit"));
    obj.pericia_10_nome:setParent(obj.layout54);
    obj.pericia_10_nome:setName("pericia_10_nome");
    obj.pericia_10_nome:setAlign("client");
    obj.pericia_10_nome:setField("pericia10_nome");
    obj.pericia_10_nome:setHint("Nome");
    obj.pericia_10_nome:setFontSize(13);
    obj.pericia_10_nome:setMargins({right=4});

    obj.pericia_10_bonus = GUI.fromHandle(_obj_newObject("edit"));
    obj.pericia_10_bonus:setParent(obj.layout54);
    obj.pericia_10_bonus:setName("pericia_10_bonus");
    obj.pericia_10_bonus:setAlign("right");
    obj.pericia_10_bonus:setWidth(52);
    obj.pericia_10_bonus:setField("pericia10_bonus");
    obj.pericia_10_bonus:setHint("Bônus");
    obj.pericia_10_bonus:setFontSize(12);
    obj.pericia_10_bonus:setHorzTextAlign("center");
    obj.pericia_10_bonus:setMargins({right=4});

    obj.button39 = GUI.fromHandle(_obj_newObject("button"));
    obj.button39:setParent(obj.layout54);
    obj.button39:setAlign("right");
    obj.button39:setWidth(42);
    obj.button39:setText("dF");
    obj.button39:setFontSize(11);
    obj.button39:setName("button39");

    obj.button40 = GUI.fromHandle(_obj_newObject("button"));
    obj.button40:setParent(obj.layout54);
    obj.button40:setAlign("right");
    obj.button40:setWidth(72);
    obj.button40:setText("Remover");
    obj.button40:setFontSize(10);
    obj.button40:setMargins({right=4});
    obj.button40:setName("button40");

    obj.nivelPericia_10 = GUI.fromHandle(_obj_newObject("label"));
    obj.nivelPericia_10:setParent(obj.rowPericia_10);
    obj.nivelPericia_10:setName("nivelPericia_10");
    obj.nivelPericia_10:setText("");
    obj.nivelPericia_10:setAlign("client");
    obj.nivelPericia_10:setFontSize(10);
    obj.nivelPericia_10:setFontColor("Gray");

    obj.rowPericia_11 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowPericia_11:setParent(obj.layout43);
    obj.rowPericia_11:setAlign("top");
    obj.rowPericia_11:setHeight(52);
    obj.rowPericia_11:setName("rowPericia_11");
    obj.rowPericia_11:setVisible(false);
    obj.rowPericia_11:setMargins({bottom=5});

    obj.layout55 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout55:setParent(obj.rowPericia_11);
    obj.layout55:setAlign("top");
    obj.layout55:setHeight(30);
    obj.layout55:setName("layout55");

    obj.edit63 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit63:setParent(obj.layout55);
    obj.edit63:setAlign("left");
    obj.edit63:setWidth(52);
    obj.edit63:setField("pericia11_valor");
    obj.edit63:setHint("Valor");
    obj.edit63:setFontSize(12);
    obj.edit63:setHorzTextAlign("center");
    obj.edit63:setMargins({right=4});
    obj.edit63:setName("edit63");

    obj.pericia_11_nome = GUI.fromHandle(_obj_newObject("edit"));
    obj.pericia_11_nome:setParent(obj.layout55);
    obj.pericia_11_nome:setName("pericia_11_nome");
    obj.pericia_11_nome:setAlign("client");
    obj.pericia_11_nome:setField("pericia11_nome");
    obj.pericia_11_nome:setHint("Nome");
    obj.pericia_11_nome:setFontSize(13);
    obj.pericia_11_nome:setMargins({right=4});

    obj.pericia_11_bonus = GUI.fromHandle(_obj_newObject("edit"));
    obj.pericia_11_bonus:setParent(obj.layout55);
    obj.pericia_11_bonus:setName("pericia_11_bonus");
    obj.pericia_11_bonus:setAlign("right");
    obj.pericia_11_bonus:setWidth(52);
    obj.pericia_11_bonus:setField("pericia11_bonus");
    obj.pericia_11_bonus:setHint("Bônus");
    obj.pericia_11_bonus:setFontSize(12);
    obj.pericia_11_bonus:setHorzTextAlign("center");
    obj.pericia_11_bonus:setMargins({right=4});

    obj.button41 = GUI.fromHandle(_obj_newObject("button"));
    obj.button41:setParent(obj.layout55);
    obj.button41:setAlign("right");
    obj.button41:setWidth(42);
    obj.button41:setText("dF");
    obj.button41:setFontSize(11);
    obj.button41:setName("button41");

    obj.button42 = GUI.fromHandle(_obj_newObject("button"));
    obj.button42:setParent(obj.layout55);
    obj.button42:setAlign("right");
    obj.button42:setWidth(72);
    obj.button42:setText("Remover");
    obj.button42:setFontSize(10);
    obj.button42:setMargins({right=4});
    obj.button42:setName("button42");

    obj.nivelPericia_11 = GUI.fromHandle(_obj_newObject("label"));
    obj.nivelPericia_11:setParent(obj.rowPericia_11);
    obj.nivelPericia_11:setName("nivelPericia_11");
    obj.nivelPericia_11:setText("");
    obj.nivelPericia_11:setAlign("client");
    obj.nivelPericia_11:setFontSize(10);
    obj.nivelPericia_11:setFontColor("Gray");

    obj.rowPericia_12 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowPericia_12:setParent(obj.layout43);
    obj.rowPericia_12:setAlign("top");
    obj.rowPericia_12:setHeight(52);
    obj.rowPericia_12:setName("rowPericia_12");
    obj.rowPericia_12:setVisible(false);
    obj.rowPericia_12:setMargins({bottom=5});

    obj.layout56 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout56:setParent(obj.rowPericia_12);
    obj.layout56:setAlign("top");
    obj.layout56:setHeight(30);
    obj.layout56:setName("layout56");

    obj.edit64 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit64:setParent(obj.layout56);
    obj.edit64:setAlign("left");
    obj.edit64:setWidth(52);
    obj.edit64:setField("pericia12_valor");
    obj.edit64:setHint("Valor");
    obj.edit64:setFontSize(12);
    obj.edit64:setHorzTextAlign("center");
    obj.edit64:setMargins({right=4});
    obj.edit64:setName("edit64");

    obj.pericia_12_nome = GUI.fromHandle(_obj_newObject("edit"));
    obj.pericia_12_nome:setParent(obj.layout56);
    obj.pericia_12_nome:setName("pericia_12_nome");
    obj.pericia_12_nome:setAlign("client");
    obj.pericia_12_nome:setField("pericia12_nome");
    obj.pericia_12_nome:setHint("Nome");
    obj.pericia_12_nome:setFontSize(13);
    obj.pericia_12_nome:setMargins({right=4});

    obj.pericia_12_bonus = GUI.fromHandle(_obj_newObject("edit"));
    obj.pericia_12_bonus:setParent(obj.layout56);
    obj.pericia_12_bonus:setName("pericia_12_bonus");
    obj.pericia_12_bonus:setAlign("right");
    obj.pericia_12_bonus:setWidth(52);
    obj.pericia_12_bonus:setField("pericia12_bonus");
    obj.pericia_12_bonus:setHint("Bônus");
    obj.pericia_12_bonus:setFontSize(12);
    obj.pericia_12_bonus:setHorzTextAlign("center");
    obj.pericia_12_bonus:setMargins({right=4});

    obj.button43 = GUI.fromHandle(_obj_newObject("button"));
    obj.button43:setParent(obj.layout56);
    obj.button43:setAlign("right");
    obj.button43:setWidth(42);
    obj.button43:setText("dF");
    obj.button43:setFontSize(11);
    obj.button43:setName("button43");

    obj.button44 = GUI.fromHandle(_obj_newObject("button"));
    obj.button44:setParent(obj.layout56);
    obj.button44:setAlign("right");
    obj.button44:setWidth(72);
    obj.button44:setText("Remover");
    obj.button44:setFontSize(10);
    obj.button44:setMargins({right=4});
    obj.button44:setName("button44");

    obj.nivelPericia_12 = GUI.fromHandle(_obj_newObject("label"));
    obj.nivelPericia_12:setParent(obj.rowPericia_12);
    obj.nivelPericia_12:setName("nivelPericia_12");
    obj.nivelPericia_12:setText("");
    obj.nivelPericia_12:setAlign("client");
    obj.nivelPericia_12:setFontSize(10);
    obj.nivelPericia_12:setFontColor("Gray");

    obj.rowPericia_13 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowPericia_13:setParent(obj.layout43);
    obj.rowPericia_13:setAlign("top");
    obj.rowPericia_13:setHeight(52);
    obj.rowPericia_13:setName("rowPericia_13");
    obj.rowPericia_13:setVisible(false);
    obj.rowPericia_13:setMargins({bottom=5});

    obj.layout57 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout57:setParent(obj.rowPericia_13);
    obj.layout57:setAlign("top");
    obj.layout57:setHeight(30);
    obj.layout57:setName("layout57");

    obj.edit65 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit65:setParent(obj.layout57);
    obj.edit65:setAlign("left");
    obj.edit65:setWidth(52);
    obj.edit65:setField("pericia13_valor");
    obj.edit65:setHint("Valor");
    obj.edit65:setFontSize(12);
    obj.edit65:setHorzTextAlign("center");
    obj.edit65:setMargins({right=4});
    obj.edit65:setName("edit65");

    obj.pericia_13_nome = GUI.fromHandle(_obj_newObject("edit"));
    obj.pericia_13_nome:setParent(obj.layout57);
    obj.pericia_13_nome:setName("pericia_13_nome");
    obj.pericia_13_nome:setAlign("client");
    obj.pericia_13_nome:setField("pericia13_nome");
    obj.pericia_13_nome:setHint("Nome");
    obj.pericia_13_nome:setFontSize(13);
    obj.pericia_13_nome:setMargins({right=4});

    obj.pericia_13_bonus = GUI.fromHandle(_obj_newObject("edit"));
    obj.pericia_13_bonus:setParent(obj.layout57);
    obj.pericia_13_bonus:setName("pericia_13_bonus");
    obj.pericia_13_bonus:setAlign("right");
    obj.pericia_13_bonus:setWidth(52);
    obj.pericia_13_bonus:setField("pericia13_bonus");
    obj.pericia_13_bonus:setHint("Bônus");
    obj.pericia_13_bonus:setFontSize(12);
    obj.pericia_13_bonus:setHorzTextAlign("center");
    obj.pericia_13_bonus:setMargins({right=4});

    obj.button45 = GUI.fromHandle(_obj_newObject("button"));
    obj.button45:setParent(obj.layout57);
    obj.button45:setAlign("right");
    obj.button45:setWidth(42);
    obj.button45:setText("dF");
    obj.button45:setFontSize(11);
    obj.button45:setName("button45");

    obj.button46 = GUI.fromHandle(_obj_newObject("button"));
    obj.button46:setParent(obj.layout57);
    obj.button46:setAlign("right");
    obj.button46:setWidth(72);
    obj.button46:setText("Remover");
    obj.button46:setFontSize(10);
    obj.button46:setMargins({right=4});
    obj.button46:setName("button46");

    obj.nivelPericia_13 = GUI.fromHandle(_obj_newObject("label"));
    obj.nivelPericia_13:setParent(obj.rowPericia_13);
    obj.nivelPericia_13:setName("nivelPericia_13");
    obj.nivelPericia_13:setText("");
    obj.nivelPericia_13:setAlign("client");
    obj.nivelPericia_13:setFontSize(10);
    obj.nivelPericia_13:setFontColor("Gray");

    obj.rowPericia_14 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowPericia_14:setParent(obj.layout43);
    obj.rowPericia_14:setAlign("top");
    obj.rowPericia_14:setHeight(52);
    obj.rowPericia_14:setName("rowPericia_14");
    obj.rowPericia_14:setVisible(false);
    obj.rowPericia_14:setMargins({bottom=5});

    obj.layout58 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout58:setParent(obj.rowPericia_14);
    obj.layout58:setAlign("top");
    obj.layout58:setHeight(30);
    obj.layout58:setName("layout58");

    obj.edit66 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit66:setParent(obj.layout58);
    obj.edit66:setAlign("left");
    obj.edit66:setWidth(52);
    obj.edit66:setField("pericia14_valor");
    obj.edit66:setHint("Valor");
    obj.edit66:setFontSize(12);
    obj.edit66:setHorzTextAlign("center");
    obj.edit66:setMargins({right=4});
    obj.edit66:setName("edit66");

    obj.pericia_14_nome = GUI.fromHandle(_obj_newObject("edit"));
    obj.pericia_14_nome:setParent(obj.layout58);
    obj.pericia_14_nome:setName("pericia_14_nome");
    obj.pericia_14_nome:setAlign("client");
    obj.pericia_14_nome:setField("pericia14_nome");
    obj.pericia_14_nome:setHint("Nome");
    obj.pericia_14_nome:setFontSize(13);
    obj.pericia_14_nome:setMargins({right=4});

    obj.pericia_14_bonus = GUI.fromHandle(_obj_newObject("edit"));
    obj.pericia_14_bonus:setParent(obj.layout58);
    obj.pericia_14_bonus:setName("pericia_14_bonus");
    obj.pericia_14_bonus:setAlign("right");
    obj.pericia_14_bonus:setWidth(52);
    obj.pericia_14_bonus:setField("pericia14_bonus");
    obj.pericia_14_bonus:setHint("Bônus");
    obj.pericia_14_bonus:setFontSize(12);
    obj.pericia_14_bonus:setHorzTextAlign("center");
    obj.pericia_14_bonus:setMargins({right=4});

    obj.button47 = GUI.fromHandle(_obj_newObject("button"));
    obj.button47:setParent(obj.layout58);
    obj.button47:setAlign("right");
    obj.button47:setWidth(42);
    obj.button47:setText("dF");
    obj.button47:setFontSize(11);
    obj.button47:setName("button47");

    obj.button48 = GUI.fromHandle(_obj_newObject("button"));
    obj.button48:setParent(obj.layout58);
    obj.button48:setAlign("right");
    obj.button48:setWidth(72);
    obj.button48:setText("Remover");
    obj.button48:setFontSize(10);
    obj.button48:setMargins({right=4});
    obj.button48:setName("button48");

    obj.nivelPericia_14 = GUI.fromHandle(_obj_newObject("label"));
    obj.nivelPericia_14:setParent(obj.rowPericia_14);
    obj.nivelPericia_14:setName("nivelPericia_14");
    obj.nivelPericia_14:setText("");
    obj.nivelPericia_14:setAlign("client");
    obj.nivelPericia_14:setFontSize(10);
    obj.nivelPericia_14:setFontColor("Gray");

    obj.rowPericia_15 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowPericia_15:setParent(obj.layout43);
    obj.rowPericia_15:setAlign("top");
    obj.rowPericia_15:setHeight(52);
    obj.rowPericia_15:setName("rowPericia_15");
    obj.rowPericia_15:setVisible(false);
    obj.rowPericia_15:setMargins({bottom=5});

    obj.layout59 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout59:setParent(obj.rowPericia_15);
    obj.layout59:setAlign("top");
    obj.layout59:setHeight(30);
    obj.layout59:setName("layout59");

    obj.edit67 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit67:setParent(obj.layout59);
    obj.edit67:setAlign("left");
    obj.edit67:setWidth(52);
    obj.edit67:setField("pericia15_valor");
    obj.edit67:setHint("Valor");
    obj.edit67:setFontSize(12);
    obj.edit67:setHorzTextAlign("center");
    obj.edit67:setMargins({right=4});
    obj.edit67:setName("edit67");

    obj.pericia_15_nome = GUI.fromHandle(_obj_newObject("edit"));
    obj.pericia_15_nome:setParent(obj.layout59);
    obj.pericia_15_nome:setName("pericia_15_nome");
    obj.pericia_15_nome:setAlign("client");
    obj.pericia_15_nome:setField("pericia15_nome");
    obj.pericia_15_nome:setHint("Nome");
    obj.pericia_15_nome:setFontSize(13);
    obj.pericia_15_nome:setMargins({right=4});

    obj.pericia_15_bonus = GUI.fromHandle(_obj_newObject("edit"));
    obj.pericia_15_bonus:setParent(obj.layout59);
    obj.pericia_15_bonus:setName("pericia_15_bonus");
    obj.pericia_15_bonus:setAlign("right");
    obj.pericia_15_bonus:setWidth(52);
    obj.pericia_15_bonus:setField("pericia15_bonus");
    obj.pericia_15_bonus:setHint("Bônus");
    obj.pericia_15_bonus:setFontSize(12);
    obj.pericia_15_bonus:setHorzTextAlign("center");
    obj.pericia_15_bonus:setMargins({right=4});

    obj.button49 = GUI.fromHandle(_obj_newObject("button"));
    obj.button49:setParent(obj.layout59);
    obj.button49:setAlign("right");
    obj.button49:setWidth(42);
    obj.button49:setText("dF");
    obj.button49:setFontSize(11);
    obj.button49:setName("button49");

    obj.button50 = GUI.fromHandle(_obj_newObject("button"));
    obj.button50:setParent(obj.layout59);
    obj.button50:setAlign("right");
    obj.button50:setWidth(72);
    obj.button50:setText("Remover");
    obj.button50:setFontSize(10);
    obj.button50:setMargins({right=4});
    obj.button50:setName("button50");

    obj.nivelPericia_15 = GUI.fromHandle(_obj_newObject("label"));
    obj.nivelPericia_15:setParent(obj.rowPericia_15);
    obj.nivelPericia_15:setName("nivelPericia_15");
    obj.nivelPericia_15:setText("");
    obj.nivelPericia_15:setAlign("client");
    obj.nivelPericia_15:setFontSize(10);
    obj.nivelPericia_15:setFontColor("Gray");

    obj.rowPericia_16 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowPericia_16:setParent(obj.layout43);
    obj.rowPericia_16:setAlign("top");
    obj.rowPericia_16:setHeight(52);
    obj.rowPericia_16:setName("rowPericia_16");
    obj.rowPericia_16:setVisible(false);
    obj.rowPericia_16:setMargins({bottom=5});

    obj.layout60 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout60:setParent(obj.rowPericia_16);
    obj.layout60:setAlign("top");
    obj.layout60:setHeight(30);
    obj.layout60:setName("layout60");

    obj.edit68 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit68:setParent(obj.layout60);
    obj.edit68:setAlign("left");
    obj.edit68:setWidth(52);
    obj.edit68:setField("pericia16_valor");
    obj.edit68:setHint("Valor");
    obj.edit68:setFontSize(12);
    obj.edit68:setHorzTextAlign("center");
    obj.edit68:setMargins({right=4});
    obj.edit68:setName("edit68");

    obj.pericia_16_nome = GUI.fromHandle(_obj_newObject("edit"));
    obj.pericia_16_nome:setParent(obj.layout60);
    obj.pericia_16_nome:setName("pericia_16_nome");
    obj.pericia_16_nome:setAlign("client");
    obj.pericia_16_nome:setField("pericia16_nome");
    obj.pericia_16_nome:setHint("Nome");
    obj.pericia_16_nome:setFontSize(13);
    obj.pericia_16_nome:setMargins({right=4});

    obj.pericia_16_bonus = GUI.fromHandle(_obj_newObject("edit"));
    obj.pericia_16_bonus:setParent(obj.layout60);
    obj.pericia_16_bonus:setName("pericia_16_bonus");
    obj.pericia_16_bonus:setAlign("right");
    obj.pericia_16_bonus:setWidth(52);
    obj.pericia_16_bonus:setField("pericia16_bonus");
    obj.pericia_16_bonus:setHint("Bônus");
    obj.pericia_16_bonus:setFontSize(12);
    obj.pericia_16_bonus:setHorzTextAlign("center");
    obj.pericia_16_bonus:setMargins({right=4});

    obj.button51 = GUI.fromHandle(_obj_newObject("button"));
    obj.button51:setParent(obj.layout60);
    obj.button51:setAlign("right");
    obj.button51:setWidth(42);
    obj.button51:setText("dF");
    obj.button51:setFontSize(11);
    obj.button51:setName("button51");

    obj.button52 = GUI.fromHandle(_obj_newObject("button"));
    obj.button52:setParent(obj.layout60);
    obj.button52:setAlign("right");
    obj.button52:setWidth(72);
    obj.button52:setText("Remover");
    obj.button52:setFontSize(10);
    obj.button52:setMargins({right=4});
    obj.button52:setName("button52");

    obj.nivelPericia_16 = GUI.fromHandle(_obj_newObject("label"));
    obj.nivelPericia_16:setParent(obj.rowPericia_16);
    obj.nivelPericia_16:setName("nivelPericia_16");
    obj.nivelPericia_16:setText("");
    obj.nivelPericia_16:setAlign("client");
    obj.nivelPericia_16:setFontSize(10);
    obj.nivelPericia_16:setFontColor("Gray");

    obj.layout61 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout61:setParent(obj.listaPericiasFacanhas);
    obj.layout61:setAlign("client");
    obj.layout61:setMargins({right=8});
    obj.layout61:setName("layout61");

    obj.layout62 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout62:setParent(obj.layout61);
    obj.layout62:setAlign("top");
    obj.layout62:setHeight(30);
    obj.layout62:setMargins({bottom=6});
    obj.layout62:setName("layout62");

    obj.label38 = GUI.fromHandle(_obj_newObject("label"));
    obj.label38:setParent(obj.layout62);
    obj.label38:setText("Façanhas");
    obj.label38:setAlign("left");
    obj.label38:setWidth(130);
    obj.label38:setFontSize(13);
    obj.label38:setFontColor("Gray");
    lfm_setPropAsString(obj.label38, "fontStyle", "bold");
    obj.label38:setVertTextAlign("center");
    obj.label38:setName("label38");

    obj.button53 = GUI.fromHandle(_obj_newObject("button"));
    obj.button53:setParent(obj.layout62);
    obj.button53:setAlign("right");
    obj.button53:setWidth(116);
    obj.button53:setHeight(30);
    obj.button53:setText("+ Adicionar");
    obj.button53:setFontSize(11);
    obj.button53:setName("button53");

    obj.layout63 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout63:setParent(obj.layout61);
    obj.layout63:setAlign("client");
    obj.layout63:setName("layout63");

    obj.rowFacanha_1 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowFacanha_1:setParent(obj.layout63);
    obj.rowFacanha_1:setAlign("top");
    obj.rowFacanha_1:setHeight(28);
    obj.rowFacanha_1:setName("rowFacanha_1");
    obj.rowFacanha_1:setMargins({bottom=4});

    obj.edit69 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit69:setParent(obj.rowFacanha_1);
    obj.edit69:setAlign("client");
    obj.edit69:setField("facanha1");
    obj.edit69:setFontSize(13);
    obj.edit69:setMargins({right=6});
    obj.edit69:setName("edit69");

    obj.button54 = GUI.fromHandle(_obj_newObject("button"));
    obj.button54:setParent(obj.rowFacanha_1);
    obj.button54:setAlign("right");
    obj.button54:setWidth(80);
    obj.button54:setText("Remover");
    obj.button54:setFontSize(10);
    obj.button54:setName("button54");

    obj.rowFacanha_2 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowFacanha_2:setParent(obj.layout63);
    obj.rowFacanha_2:setAlign("top");
    obj.rowFacanha_2:setHeight(28);
    obj.rowFacanha_2:setName("rowFacanha_2");
    obj.rowFacanha_2:setMargins({bottom=4});

    obj.edit70 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit70:setParent(obj.rowFacanha_2);
    obj.edit70:setAlign("client");
    obj.edit70:setField("facanha2");
    obj.edit70:setFontSize(13);
    obj.edit70:setMargins({right=6});
    obj.edit70:setName("edit70");

    obj.button55 = GUI.fromHandle(_obj_newObject("button"));
    obj.button55:setParent(obj.rowFacanha_2);
    obj.button55:setAlign("right");
    obj.button55:setWidth(80);
    obj.button55:setText("Remover");
    obj.button55:setFontSize(10);
    obj.button55:setName("button55");

    obj.rowFacanha_3 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowFacanha_3:setParent(obj.layout63);
    obj.rowFacanha_3:setAlign("top");
    obj.rowFacanha_3:setHeight(28);
    obj.rowFacanha_3:setName("rowFacanha_3");
    obj.rowFacanha_3:setMargins({bottom=4});

    obj.edit71 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit71:setParent(obj.rowFacanha_3);
    obj.edit71:setAlign("client");
    obj.edit71:setField("facanha3");
    obj.edit71:setFontSize(13);
    obj.edit71:setMargins({right=6});
    obj.edit71:setName("edit71");

    obj.button56 = GUI.fromHandle(_obj_newObject("button"));
    obj.button56:setParent(obj.rowFacanha_3);
    obj.button56:setAlign("right");
    obj.button56:setWidth(80);
    obj.button56:setText("Remover");
    obj.button56:setFontSize(10);
    obj.button56:setName("button56");

    obj.rowFacanha_4 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowFacanha_4:setParent(obj.layout63);
    obj.rowFacanha_4:setAlign("top");
    obj.rowFacanha_4:setHeight(28);
    obj.rowFacanha_4:setName("rowFacanha_4");
    obj.rowFacanha_4:setVisible(false);
    obj.rowFacanha_4:setMargins({bottom=4});

    obj.edit72 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit72:setParent(obj.rowFacanha_4);
    obj.edit72:setAlign("client");
    obj.edit72:setField("facanha4");
    obj.edit72:setFontSize(13);
    obj.edit72:setMargins({right=6});
    obj.edit72:setName("edit72");

    obj.button57 = GUI.fromHandle(_obj_newObject("button"));
    obj.button57:setParent(obj.rowFacanha_4);
    obj.button57:setAlign("right");
    obj.button57:setWidth(80);
    obj.button57:setText("Remover");
    obj.button57:setFontSize(10);
    obj.button57:setName("button57");

    obj.rowFacanha_5 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowFacanha_5:setParent(obj.layout63);
    obj.rowFacanha_5:setAlign("top");
    obj.rowFacanha_5:setHeight(28);
    obj.rowFacanha_5:setName("rowFacanha_5");
    obj.rowFacanha_5:setVisible(false);
    obj.rowFacanha_5:setMargins({bottom=4});

    obj.edit73 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit73:setParent(obj.rowFacanha_5);
    obj.edit73:setAlign("client");
    obj.edit73:setField("facanha5");
    obj.edit73:setFontSize(13);
    obj.edit73:setMargins({right=6});
    obj.edit73:setName("edit73");

    obj.button58 = GUI.fromHandle(_obj_newObject("button"));
    obj.button58:setParent(obj.rowFacanha_5);
    obj.button58:setAlign("right");
    obj.button58:setWidth(80);
    obj.button58:setText("Remover");
    obj.button58:setFontSize(10);
    obj.button58:setName("button58");

    obj.rowFacanha_6 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowFacanha_6:setParent(obj.layout63);
    obj.rowFacanha_6:setAlign("top");
    obj.rowFacanha_6:setHeight(28);
    obj.rowFacanha_6:setName("rowFacanha_6");
    obj.rowFacanha_6:setVisible(false);
    obj.rowFacanha_6:setMargins({bottom=4});

    obj.edit74 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit74:setParent(obj.rowFacanha_6);
    obj.edit74:setAlign("client");
    obj.edit74:setField("facanha6");
    obj.edit74:setFontSize(13);
    obj.edit74:setMargins({right=6});
    obj.edit74:setName("edit74");

    obj.button59 = GUI.fromHandle(_obj_newObject("button"));
    obj.button59:setParent(obj.rowFacanha_6);
    obj.button59:setAlign("right");
    obj.button59:setWidth(80);
    obj.button59:setText("Remover");
    obj.button59:setFontSize(10);
    obj.button59:setName("button59");

    obj.rowFacanha_7 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowFacanha_7:setParent(obj.layout63);
    obj.rowFacanha_7:setAlign("top");
    obj.rowFacanha_7:setHeight(28);
    obj.rowFacanha_7:setName("rowFacanha_7");
    obj.rowFacanha_7:setVisible(false);
    obj.rowFacanha_7:setMargins({bottom=4});

    obj.edit75 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit75:setParent(obj.rowFacanha_7);
    obj.edit75:setAlign("client");
    obj.edit75:setField("facanha7");
    obj.edit75:setFontSize(13);
    obj.edit75:setMargins({right=6});
    obj.edit75:setName("edit75");

    obj.button60 = GUI.fromHandle(_obj_newObject("button"));
    obj.button60:setParent(obj.rowFacanha_7);
    obj.button60:setAlign("right");
    obj.button60:setWidth(80);
    obj.button60:setText("Remover");
    obj.button60:setFontSize(10);
    obj.button60:setName("button60");

    obj.rowFacanha_8 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowFacanha_8:setParent(obj.layout63);
    obj.rowFacanha_8:setAlign("top");
    obj.rowFacanha_8:setHeight(28);
    obj.rowFacanha_8:setName("rowFacanha_8");
    obj.rowFacanha_8:setVisible(false);
    obj.rowFacanha_8:setMargins({bottom=4});

    obj.edit76 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit76:setParent(obj.rowFacanha_8);
    obj.edit76:setAlign("client");
    obj.edit76:setField("facanha8");
    obj.edit76:setFontSize(13);
    obj.edit76:setMargins({right=6});
    obj.edit76:setName("edit76");

    obj.button61 = GUI.fromHandle(_obj_newObject("button"));
    obj.button61:setParent(obj.rowFacanha_8);
    obj.button61:setAlign("right");
    obj.button61:setWidth(80);
    obj.button61:setText("Remover");
    obj.button61:setFontSize(10);
    obj.button61:setName("button61");

    obj.rowFacanha_9 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowFacanha_9:setParent(obj.layout63);
    obj.rowFacanha_9:setAlign("top");
    obj.rowFacanha_9:setHeight(28);
    obj.rowFacanha_9:setName("rowFacanha_9");
    obj.rowFacanha_9:setVisible(false);
    obj.rowFacanha_9:setMargins({bottom=4});

    obj.edit77 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit77:setParent(obj.rowFacanha_9);
    obj.edit77:setAlign("client");
    obj.edit77:setField("facanha9");
    obj.edit77:setFontSize(13);
    obj.edit77:setMargins({right=6});
    obj.edit77:setName("edit77");

    obj.button62 = GUI.fromHandle(_obj_newObject("button"));
    obj.button62:setParent(obj.rowFacanha_9);
    obj.button62:setAlign("right");
    obj.button62:setWidth(80);
    obj.button62:setText("Remover");
    obj.button62:setFontSize(10);
    obj.button62:setName("button62");

    obj.rowFacanha_10 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowFacanha_10:setParent(obj.layout63);
    obj.rowFacanha_10:setAlign("top");
    obj.rowFacanha_10:setHeight(28);
    obj.rowFacanha_10:setName("rowFacanha_10");
    obj.rowFacanha_10:setVisible(false);

    obj.edit78 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit78:setParent(obj.rowFacanha_10);
    obj.edit78:setAlign("client");
    obj.edit78:setField("facanha10");
    obj.edit78:setFontSize(13);
    obj.edit78:setMargins({right=6});
    obj.edit78:setName("edit78");

    obj.button63 = GUI.fromHandle(_obj_newObject("button"));
    obj.button63:setParent(obj.rowFacanha_10);
    obj.button63:setAlign("right");
    obj.button63:setWidth(80);
    obj.button63:setText("Remover");
    obj.button63:setFontSize(10);
    obj.button63:setName("button63");

    obj.layout64 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout64:setParent(obj.layout1);
    obj.layout64:setAlign("top");
    obj.layout64:setHeight(0);
    obj.layout64:setVisible(false);
    obj.layout64:setName("layout64");

    obj.layout65 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout65:setParent(obj.layout64);
    obj.layout65:setAlign("left");
    obj.layout65:setWidth(260);
    obj.layout65:setMargins({right=8});
    obj.layout65:setName("layout65");

    obj.label39 = GUI.fromHandle(_obj_newObject("label"));
    obj.label39:setParent(obj.layout65);
    obj.label39:setText("Estresse");
    obj.label39:setAlign("top");
    obj.label39:setHeight(18);
    obj.label39:setFontSize(11);
    obj.label39:setFontColor("Gray");
    lfm_setPropAsString(obj.label39, "fontStyle", "bold");
    obj.label39:setMargins({bottom=6});
    obj.label39:setName("label39");

    obj.layout66 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout66:setParent(obj.layout65);
    obj.layout66:setAlign("top");
    obj.layout66:setHeight(32);
    obj.layout66:setMargins({bottom=8});
    obj.layout66:setName("layout66");

    obj.label40 = GUI.fromHandle(_obj_newObject("label"));
    obj.label40:setParent(obj.layout66);
    obj.label40:setText("Físico");
    obj.label40:setAlign("left");
    obj.label40:setWidth(48);
    obj.label40:setFontSize(10);
    obj.label40:setFontColor("Gray");
    obj.label40:setVertTextAlign("center");
    obj.label40:setName("label40");

    obj.chkFisico_1 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.chkFisico_1:setParent(obj.layout66);
    obj.chkFisico_1:setName("chkFisico_1");
    obj.chkFisico_1:setAlign("left");
    obj.chkFisico_1:setWidth(28);
    obj.chkFisico_1:setField("stF1");
    obj.chkFisico_1:setText("1");
    obj.chkFisico_1:setFontSize(10);

    obj.chkFisico_2 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.chkFisico_2:setParent(obj.layout66);
    obj.chkFisico_2:setName("chkFisico_2");
    obj.chkFisico_2:setAlign("left");
    obj.chkFisico_2:setWidth(28);
    obj.chkFisico_2:setField("stF2");
    obj.chkFisico_2:setText("2");
    obj.chkFisico_2:setFontSize(10);

    obj.chkFisico_3 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.chkFisico_3:setParent(obj.layout66);
    obj.chkFisico_3:setName("chkFisico_3");
    obj.chkFisico_3:setAlign("left");
    obj.chkFisico_3:setWidth(28);
    obj.chkFisico_3:setField("stF3");
    obj.chkFisico_3:setText("3");
    obj.chkFisico_3:setFontSize(10);

    obj.chkFisico_4 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.chkFisico_4:setParent(obj.layout66);
    obj.chkFisico_4:setName("chkFisico_4");
    obj.chkFisico_4:setAlign("left");
    obj.chkFisico_4:setWidth(28);
    obj.chkFisico_4:setField("stF4");
    obj.chkFisico_4:setText("4");
    obj.chkFisico_4:setFontSize(10);

    obj.chkFisico_5 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.chkFisico_5:setParent(obj.layout66);
    obj.chkFisico_5:setName("chkFisico_5");
    obj.chkFisico_5:setAlign("left");
    obj.chkFisico_5:setWidth(28);
    obj.chkFisico_5:setField("stF5");
    obj.chkFisico_5:setText("5");
    obj.chkFisico_5:setFontSize(10);
    obj.chkFisico_5:setVisible(false);

    obj.chkFisico_6 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.chkFisico_6:setParent(obj.layout66);
    obj.chkFisico_6:setName("chkFisico_6");
    obj.chkFisico_6:setAlign("left");
    obj.chkFisico_6:setWidth(28);
    obj.chkFisico_6:setField("stF6");
    obj.chkFisico_6:setText("6");
    obj.chkFisico_6:setFontSize(10);
    obj.chkFisico_6:setVisible(false);

    obj.chkFisico_7 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.chkFisico_7:setParent(obj.layout66);
    obj.chkFisico_7:setName("chkFisico_7");
    obj.chkFisico_7:setAlign("left");
    obj.chkFisico_7:setWidth(28);
    obj.chkFisico_7:setField("stF7");
    obj.chkFisico_7:setText("7");
    obj.chkFisico_7:setFontSize(10);
    obj.chkFisico_7:setVisible(false);

    obj.chkFisico_8 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.chkFisico_8:setParent(obj.layout66);
    obj.chkFisico_8:setName("chkFisico_8");
    obj.chkFisico_8:setAlign("left");
    obj.chkFisico_8:setWidth(28);
    obj.chkFisico_8:setField("stF8");
    obj.chkFisico_8:setText("8");
    obj.chkFisico_8:setFontSize(10);
    obj.chkFisico_8:setVisible(false);

    obj.layout67 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout67:setParent(obj.layout65);
    obj.layout67:setAlign("top");
    obj.layout67:setHeight(32);
    obj.layout67:setName("layout67");

    obj.label41 = GUI.fromHandle(_obj_newObject("label"));
    obj.label41:setParent(obj.layout67);
    obj.label41:setText("Mental");
    obj.label41:setAlign("left");
    obj.label41:setWidth(48);
    obj.label41:setFontSize(10);
    obj.label41:setFontColor("Gray");
    obj.label41:setVertTextAlign("center");
    obj.label41:setName("label41");

    obj.chkMental_1 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.chkMental_1:setParent(obj.layout67);
    obj.chkMental_1:setName("chkMental_1");
    obj.chkMental_1:setAlign("left");
    obj.chkMental_1:setWidth(28);
    obj.chkMental_1:setField("stM1");
    obj.chkMental_1:setText("1");
    obj.chkMental_1:setFontSize(10);

    obj.chkMental_2 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.chkMental_2:setParent(obj.layout67);
    obj.chkMental_2:setName("chkMental_2");
    obj.chkMental_2:setAlign("left");
    obj.chkMental_2:setWidth(28);
    obj.chkMental_2:setField("stM2");
    obj.chkMental_2:setText("2");
    obj.chkMental_2:setFontSize(10);

    obj.chkMental_3 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.chkMental_3:setParent(obj.layout67);
    obj.chkMental_3:setName("chkMental_3");
    obj.chkMental_3:setAlign("left");
    obj.chkMental_3:setWidth(28);
    obj.chkMental_3:setField("stM3");
    obj.chkMental_3:setText("3");
    obj.chkMental_3:setFontSize(10);

    obj.chkMental_4 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.chkMental_4:setParent(obj.layout67);
    obj.chkMental_4:setName("chkMental_4");
    obj.chkMental_4:setAlign("left");
    obj.chkMental_4:setWidth(28);
    obj.chkMental_4:setField("stM4");
    obj.chkMental_4:setText("4");
    obj.chkMental_4:setFontSize(10);

    obj.chkMental_5 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.chkMental_5:setParent(obj.layout67);
    obj.chkMental_5:setName("chkMental_5");
    obj.chkMental_5:setAlign("left");
    obj.chkMental_5:setWidth(28);
    obj.chkMental_5:setField("stM5");
    obj.chkMental_5:setText("5");
    obj.chkMental_5:setFontSize(10);
    obj.chkMental_5:setVisible(false);

    obj.chkMental_6 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.chkMental_6:setParent(obj.layout67);
    obj.chkMental_6:setName("chkMental_6");
    obj.chkMental_6:setAlign("left");
    obj.chkMental_6:setWidth(28);
    obj.chkMental_6:setField("stM6");
    obj.chkMental_6:setText("6");
    obj.chkMental_6:setFontSize(10);
    obj.chkMental_6:setVisible(false);

    obj.chkMental_7 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.chkMental_7:setParent(obj.layout67);
    obj.chkMental_7:setName("chkMental_7");
    obj.chkMental_7:setAlign("left");
    obj.chkMental_7:setWidth(28);
    obj.chkMental_7:setField("stM7");
    obj.chkMental_7:setText("7");
    obj.chkMental_7:setFontSize(10);
    obj.chkMental_7:setVisible(false);

    obj.chkMental_8 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.chkMental_8:setParent(obj.layout67);
    obj.chkMental_8:setName("chkMental_8");
    obj.chkMental_8:setAlign("left");
    obj.chkMental_8:setWidth(28);
    obj.chkMental_8:setField("stM8");
    obj.chkMental_8:setText("8");
    obj.chkMental_8:setFontSize(10);
    obj.chkMental_8:setVisible(false);

    obj.layout68 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout68:setParent(obj.layout64);
    obj.layout68:setAlign("client");
    obj.layout68:setName("layout68");

    obj.label42 = GUI.fromHandle(_obj_newObject("label"));
    obj.label42:setParent(obj.layout68);
    obj.label42:setText("Consequências");
    obj.label42:setAlign("top");
    obj.label42:setHeight(18);
    obj.label42:setFontSize(11);
    obj.label42:setFontColor("Gray");
    lfm_setPropAsString(obj.label42, "fontStyle", "bold");
    obj.label42:setMargins({bottom=4});
    obj.label42:setName("label42");

    obj.layout69 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout69:setParent(obj.layout68);
    obj.layout69:setAlign("top");
    obj.layout69:setHeight(26);
    obj.layout69:setMargins({bottom=4});
    obj.layout69:setName("layout69");

    obj.label43 = GUI.fromHandle(_obj_newObject("label"));
    obj.label43:setParent(obj.layout69);
    obj.label43:setText("[2] Suave");
    obj.label43:setAlign("left");
    obj.label43:setWidth(72);
    obj.label43:setFontSize(10);
    obj.label43:setFontColor("#b9151f");
    obj.label43:setVertTextAlign("center");
    obj.label43:setName("label43");

    obj.edit79 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit79:setParent(obj.layout69);
    obj.edit79:setAlign("client");
    obj.edit79:setField("cons_suave");
    obj.edit79:setFontSize(10);
    obj.edit79:setName("edit79");

    obj.rowConsCSExtra = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowConsCSExtra:setParent(obj.layout68);
    obj.rowConsCSExtra:setAlign("top");
    obj.rowConsCSExtra:setHeight(26);
    obj.rowConsCSExtra:setName("rowConsCSExtra");
    obj.rowConsCSExtra:setMargins({bottom=4});

    obj.label44 = GUI.fromHandle(_obj_newObject("label"));
    obj.label44:setParent(obj.rowConsCSExtra);
    obj.label44:setText("[2] Suave+");
    obj.label44:setAlign("left");
    obj.label44:setWidth(72);
    obj.label44:setFontSize(10);
    obj.label44:setFontColor("#b9151f");
    obj.label44:setVertTextAlign("center");
    obj.label44:setName("label44");

    obj.edit80 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit80:setParent(obj.rowConsCSExtra);
    obj.edit80:setAlign("client");
    obj.edit80:setField("cons_suaveX");
    obj.edit80:setFontSize(10);
    obj.edit80:setName("edit80");

    obj.layout70 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout70:setParent(obj.layout68);
    obj.layout70:setAlign("top");
    obj.layout70:setHeight(26);
    obj.layout70:setMargins({bottom=4});
    obj.layout70:setName("layout70");

    obj.label45 = GUI.fromHandle(_obj_newObject("label"));
    obj.label45:setParent(obj.layout70);
    obj.label45:setText("[4] Moderada");
    obj.label45:setAlign("left");
    obj.label45:setWidth(72);
    obj.label45:setFontSize(10);
    obj.label45:setFontColor("#b9151f");
    obj.label45:setVertTextAlign("center");
    obj.label45:setName("label45");

    obj.edit81 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit81:setParent(obj.layout70);
    obj.edit81:setAlign("client");
    obj.edit81:setField("cons_moderada");
    obj.edit81:setFontSize(10);
    obj.edit81:setName("edit81");

    obj.layout71 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout71:setParent(obj.layout68);
    obj.layout71:setAlign("top");
    obj.layout71:setHeight(26);
    obj.layout71:setName("layout71");

    obj.label46 = GUI.fromHandle(_obj_newObject("label"));
    obj.label46:setParent(obj.layout71);
    obj.label46:setText("[6] Severa");
    obj.label46:setAlign("left");
    obj.label46:setWidth(72);
    obj.label46:setFontSize(10);
    obj.label46:setFontColor("#b9151f");
    obj.label46:setVertTextAlign("center");
    obj.label46:setName("label46");

    obj.edit82 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit82:setParent(obj.layout71);
    obj.edit82:setAlign("client");
    obj.edit82:setField("cons_severa");
    obj.edit82:setFontSize(10);
    obj.edit82:setName("edit82");

    obj.tab2 = GUI.fromHandle(_obj_newObject("tab"));
    obj.tab2:setParent(obj.tcMain);
    obj.tab2:setTitle("Extras");
    obj.tab2:setName("tab2");

    obj.scrollBox2 = GUI.fromHandle(_obj_newObject("scrollBox"));
    obj.scrollBox2:setParent(obj.tab2);
    obj.scrollBox2:setAlign("client");
    obj.scrollBox2:setName("scrollBox2");

    obj.layout72 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout72:setParent(obj.scrollBox2);
    obj.layout72:setAlign("top");
    obj.layout72:setHeight(1700);
    obj.layout72:setMargins({left=10, right=10, top=10, bottom=10});
    obj.layout72:setName("layout72");

    obj.button64 = GUI.fromHandle(_obj_newObject("button"));
    obj.button64:setParent(obj.layout72);
    obj.button64:setAlign("top");
    obj.button64:setHeight(34);
    obj.button64:setText("+ Adicionar Extra");
    obj.button64:setFontSize(12);
    obj.button64:setMargins({bottom=10});
    obj.button64:setName("button64");

    obj.rowExtraD_1 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowExtraD_1:setParent(obj.layout72);
    obj.rowExtraD_1:setAlign("top");
    obj.rowExtraD_1:setHeight(240);
    obj.rowExtraD_1:setName("rowExtraD_1");
    obj.rowExtraD_1:setVisible(false);
    obj.rowExtraD_1:setMargins({bottom=12});

    obj.label47 = GUI.fromHandle(_obj_newObject("label"));
    obj.label47:setParent(obj.rowExtraD_1);
    obj.label47:setText("Nome");
    obj.label47:setAlign("top");
    obj.label47:setHeight(14);
    obj.label47:setFontSize(10);
    obj.label47:setFontColor("Gray");
    obj.label47:setName("label47");

    obj.layout73 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout73:setParent(obj.rowExtraD_1);
    obj.layout73:setAlign("top");
    obj.layout73:setHeight(30);
    obj.layout73:setMargins({bottom=6});
    obj.layout73:setName("layout73");

    obj.edit83 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit83:setParent(obj.layout73);
    obj.edit83:setAlign("client");
    obj.edit83:setField("extraD1_nome");
    obj.edit83:setHint("Título");
    obj.edit83:setFontSize(13);
    obj.edit83:setMargins({right=6});
    obj.edit83:setName("edit83");

    obj.button65 = GUI.fromHandle(_obj_newObject("button"));
    obj.button65:setParent(obj.layout73);
    obj.button65:setAlign("right");
    obj.button65:setWidth(90);
    obj.button65:setText("Excluir");
    obj.button65:setFontSize(11);
    obj.button65:setName("button65");

    obj.layout74 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout74:setParent(obj.rowExtraD_1);
    obj.layout74:setAlign("client");
    obj.layout74:setName("layout74");

    obj.label48 = GUI.fromHandle(_obj_newObject("label"));
    obj.label48:setParent(obj.layout74);
    obj.label48:setText("Permissão");
    obj.label48:setAlign("top");
    obj.label48:setHeight(14);
    obj.label48:setFontSize(10);
    obj.label48:setFontColor("Gray");
    obj.label48:setName("label48");

    obj.edit84 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit84:setParent(obj.layout74);
    obj.edit84:setAlign("top");
    obj.edit84:setHeight(28);
    obj.edit84:setField("extraD1_perm");
    obj.edit84:setFontSize(12);
    obj.edit84:setMargins({bottom=6});
    obj.edit84:setName("edit84");

    obj.label49 = GUI.fromHandle(_obj_newObject("label"));
    obj.label49:setParent(obj.layout74);
    obj.label49:setText("Custo");
    obj.label49:setAlign("top");
    obj.label49:setHeight(14);
    obj.label49:setFontSize(10);
    obj.label49:setFontColor("Gray");
    obj.label49:setName("label49");

    obj.edit85 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit85:setParent(obj.layout74);
    obj.edit85:setAlign("top");
    obj.edit85:setHeight(28);
    obj.edit85:setField("extraD1_custo");
    obj.edit85:setFontSize(12);
    obj.edit85:setMargins({bottom=6});
    obj.edit85:setName("edit85");

    obj.layout75 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout75:setParent(obj.layout74);
    obj.layout75:setAlign("top");
    obj.layout75:setHeight(18);
    obj.layout75:setName("layout75");

    obj.label50 = GUI.fromHandle(_obj_newObject("label"));
    obj.label50:setParent(obj.layout75);
    obj.label50:setText("Descrição");
    obj.label50:setAlign("left");
    obj.label50:setWidth(110);
    obj.label50:setFontSize(10);
    obj.label50:setFontColor("Gray");
    obj.label50:setName("label50");

    obj.button66 = GUI.fromHandle(_obj_newObject("button"));
    obj.button66:setParent(obj.layout75);
    obj.button66:setAlign("right");
    obj.button66:setWidth(100);
    obj.button66:setText("Expandir");
    obj.button66:setFontSize(10);
    obj.button66:setName("button66");

    obj.textEditor1 = GUI.fromHandle(_obj_newObject("textEditor"));
    obj.textEditor1:setParent(obj.layout74);
    obj.textEditor1:setAlign("client");
    obj.textEditor1:setField("extraD1_desc");
    obj.textEditor1:setFontSize(12);
    obj.textEditor1:setName("textEditor1");

    obj.rowExtraD_2 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowExtraD_2:setParent(obj.layout72);
    obj.rowExtraD_2:setAlign("top");
    obj.rowExtraD_2:setHeight(240);
    obj.rowExtraD_2:setName("rowExtraD_2");
    obj.rowExtraD_2:setVisible(false);
    obj.rowExtraD_2:setMargins({bottom=12});

    obj.label51 = GUI.fromHandle(_obj_newObject("label"));
    obj.label51:setParent(obj.rowExtraD_2);
    obj.label51:setText("Nome");
    obj.label51:setAlign("top");
    obj.label51:setHeight(14);
    obj.label51:setFontSize(10);
    obj.label51:setFontColor("Gray");
    obj.label51:setName("label51");

    obj.layout76 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout76:setParent(obj.rowExtraD_2);
    obj.layout76:setAlign("top");
    obj.layout76:setHeight(30);
    obj.layout76:setMargins({bottom=6});
    obj.layout76:setName("layout76");

    obj.edit86 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit86:setParent(obj.layout76);
    obj.edit86:setAlign("client");
    obj.edit86:setField("extraD2_nome");
    obj.edit86:setHint("Título");
    obj.edit86:setFontSize(13);
    obj.edit86:setMargins({right=6});
    obj.edit86:setName("edit86");

    obj.button67 = GUI.fromHandle(_obj_newObject("button"));
    obj.button67:setParent(obj.layout76);
    obj.button67:setAlign("right");
    obj.button67:setWidth(90);
    obj.button67:setText("Excluir");
    obj.button67:setFontSize(11);
    obj.button67:setName("button67");

    obj.layout77 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout77:setParent(obj.rowExtraD_2);
    obj.layout77:setAlign("client");
    obj.layout77:setName("layout77");

    obj.label52 = GUI.fromHandle(_obj_newObject("label"));
    obj.label52:setParent(obj.layout77);
    obj.label52:setText("Permissão");
    obj.label52:setAlign("top");
    obj.label52:setHeight(14);
    obj.label52:setFontSize(10);
    obj.label52:setFontColor("Gray");
    obj.label52:setName("label52");

    obj.edit87 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit87:setParent(obj.layout77);
    obj.edit87:setAlign("top");
    obj.edit87:setHeight(28);
    obj.edit87:setField("extraD2_perm");
    obj.edit87:setFontSize(12);
    obj.edit87:setMargins({bottom=6});
    obj.edit87:setName("edit87");

    obj.label53 = GUI.fromHandle(_obj_newObject("label"));
    obj.label53:setParent(obj.layout77);
    obj.label53:setText("Custo");
    obj.label53:setAlign("top");
    obj.label53:setHeight(14);
    obj.label53:setFontSize(10);
    obj.label53:setFontColor("Gray");
    obj.label53:setName("label53");

    obj.edit88 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit88:setParent(obj.layout77);
    obj.edit88:setAlign("top");
    obj.edit88:setHeight(28);
    obj.edit88:setField("extraD2_custo");
    obj.edit88:setFontSize(12);
    obj.edit88:setMargins({bottom=6});
    obj.edit88:setName("edit88");

    obj.layout78 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout78:setParent(obj.layout77);
    obj.layout78:setAlign("top");
    obj.layout78:setHeight(18);
    obj.layout78:setName("layout78");

    obj.label54 = GUI.fromHandle(_obj_newObject("label"));
    obj.label54:setParent(obj.layout78);
    obj.label54:setText("Descrição");
    obj.label54:setAlign("left");
    obj.label54:setWidth(110);
    obj.label54:setFontSize(10);
    obj.label54:setFontColor("Gray");
    obj.label54:setName("label54");

    obj.button68 = GUI.fromHandle(_obj_newObject("button"));
    obj.button68:setParent(obj.layout78);
    obj.button68:setAlign("right");
    obj.button68:setWidth(100);
    obj.button68:setText("Expandir");
    obj.button68:setFontSize(10);
    obj.button68:setName("button68");

    obj.textEditor2 = GUI.fromHandle(_obj_newObject("textEditor"));
    obj.textEditor2:setParent(obj.layout77);
    obj.textEditor2:setAlign("client");
    obj.textEditor2:setField("extraD2_desc");
    obj.textEditor2:setFontSize(12);
    obj.textEditor2:setName("textEditor2");

    obj.rowExtraD_3 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowExtraD_3:setParent(obj.layout72);
    obj.rowExtraD_3:setAlign("top");
    obj.rowExtraD_3:setHeight(240);
    obj.rowExtraD_3:setName("rowExtraD_3");
    obj.rowExtraD_3:setVisible(false);
    obj.rowExtraD_3:setMargins({bottom=12});

    obj.label55 = GUI.fromHandle(_obj_newObject("label"));
    obj.label55:setParent(obj.rowExtraD_3);
    obj.label55:setText("Nome");
    obj.label55:setAlign("top");
    obj.label55:setHeight(14);
    obj.label55:setFontSize(10);
    obj.label55:setFontColor("Gray");
    obj.label55:setName("label55");

    obj.layout79 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout79:setParent(obj.rowExtraD_3);
    obj.layout79:setAlign("top");
    obj.layout79:setHeight(30);
    obj.layout79:setMargins({bottom=6});
    obj.layout79:setName("layout79");

    obj.edit89 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit89:setParent(obj.layout79);
    obj.edit89:setAlign("client");
    obj.edit89:setField("extraD3_nome");
    obj.edit89:setHint("Título");
    obj.edit89:setFontSize(13);
    obj.edit89:setMargins({right=6});
    obj.edit89:setName("edit89");

    obj.button69 = GUI.fromHandle(_obj_newObject("button"));
    obj.button69:setParent(obj.layout79);
    obj.button69:setAlign("right");
    obj.button69:setWidth(90);
    obj.button69:setText("Excluir");
    obj.button69:setFontSize(11);
    obj.button69:setName("button69");

    obj.layout80 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout80:setParent(obj.rowExtraD_3);
    obj.layout80:setAlign("client");
    obj.layout80:setName("layout80");

    obj.label56 = GUI.fromHandle(_obj_newObject("label"));
    obj.label56:setParent(obj.layout80);
    obj.label56:setText("Permissão");
    obj.label56:setAlign("top");
    obj.label56:setHeight(14);
    obj.label56:setFontSize(10);
    obj.label56:setFontColor("Gray");
    obj.label56:setName("label56");

    obj.edit90 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit90:setParent(obj.layout80);
    obj.edit90:setAlign("top");
    obj.edit90:setHeight(28);
    obj.edit90:setField("extraD3_perm");
    obj.edit90:setFontSize(12);
    obj.edit90:setMargins({bottom=6});
    obj.edit90:setName("edit90");

    obj.label57 = GUI.fromHandle(_obj_newObject("label"));
    obj.label57:setParent(obj.layout80);
    obj.label57:setText("Custo");
    obj.label57:setAlign("top");
    obj.label57:setHeight(14);
    obj.label57:setFontSize(10);
    obj.label57:setFontColor("Gray");
    obj.label57:setName("label57");

    obj.edit91 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit91:setParent(obj.layout80);
    obj.edit91:setAlign("top");
    obj.edit91:setHeight(28);
    obj.edit91:setField("extraD3_custo");
    obj.edit91:setFontSize(12);
    obj.edit91:setMargins({bottom=6});
    obj.edit91:setName("edit91");

    obj.layout81 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout81:setParent(obj.layout80);
    obj.layout81:setAlign("top");
    obj.layout81:setHeight(18);
    obj.layout81:setName("layout81");

    obj.label58 = GUI.fromHandle(_obj_newObject("label"));
    obj.label58:setParent(obj.layout81);
    obj.label58:setText("Descrição");
    obj.label58:setAlign("left");
    obj.label58:setWidth(110);
    obj.label58:setFontSize(10);
    obj.label58:setFontColor("Gray");
    obj.label58:setName("label58");

    obj.button70 = GUI.fromHandle(_obj_newObject("button"));
    obj.button70:setParent(obj.layout81);
    obj.button70:setAlign("right");
    obj.button70:setWidth(100);
    obj.button70:setText("Expandir");
    obj.button70:setFontSize(10);
    obj.button70:setName("button70");

    obj.textEditor3 = GUI.fromHandle(_obj_newObject("textEditor"));
    obj.textEditor3:setParent(obj.layout80);
    obj.textEditor3:setAlign("client");
    obj.textEditor3:setField("extraD3_desc");
    obj.textEditor3:setFontSize(12);
    obj.textEditor3:setName("textEditor3");

    obj.rowExtraD_4 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowExtraD_4:setParent(obj.layout72);
    obj.rowExtraD_4:setAlign("top");
    obj.rowExtraD_4:setHeight(240);
    obj.rowExtraD_4:setName("rowExtraD_4");
    obj.rowExtraD_4:setVisible(false);
    obj.rowExtraD_4:setMargins({bottom=12});

    obj.label59 = GUI.fromHandle(_obj_newObject("label"));
    obj.label59:setParent(obj.rowExtraD_4);
    obj.label59:setText("Nome");
    obj.label59:setAlign("top");
    obj.label59:setHeight(14);
    obj.label59:setFontSize(10);
    obj.label59:setFontColor("Gray");
    obj.label59:setName("label59");

    obj.layout82 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout82:setParent(obj.rowExtraD_4);
    obj.layout82:setAlign("top");
    obj.layout82:setHeight(30);
    obj.layout82:setMargins({bottom=6});
    obj.layout82:setName("layout82");

    obj.edit92 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit92:setParent(obj.layout82);
    obj.edit92:setAlign("client");
    obj.edit92:setField("extraD4_nome");
    obj.edit92:setHint("Título");
    obj.edit92:setFontSize(13);
    obj.edit92:setMargins({right=6});
    obj.edit92:setName("edit92");

    obj.button71 = GUI.fromHandle(_obj_newObject("button"));
    obj.button71:setParent(obj.layout82);
    obj.button71:setAlign("right");
    obj.button71:setWidth(90);
    obj.button71:setText("Excluir");
    obj.button71:setFontSize(11);
    obj.button71:setName("button71");

    obj.layout83 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout83:setParent(obj.rowExtraD_4);
    obj.layout83:setAlign("client");
    obj.layout83:setName("layout83");

    obj.label60 = GUI.fromHandle(_obj_newObject("label"));
    obj.label60:setParent(obj.layout83);
    obj.label60:setText("Permissão");
    obj.label60:setAlign("top");
    obj.label60:setHeight(14);
    obj.label60:setFontSize(10);
    obj.label60:setFontColor("Gray");
    obj.label60:setName("label60");

    obj.edit93 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit93:setParent(obj.layout83);
    obj.edit93:setAlign("top");
    obj.edit93:setHeight(28);
    obj.edit93:setField("extraD4_perm");
    obj.edit93:setFontSize(12);
    obj.edit93:setMargins({bottom=6});
    obj.edit93:setName("edit93");

    obj.label61 = GUI.fromHandle(_obj_newObject("label"));
    obj.label61:setParent(obj.layout83);
    obj.label61:setText("Custo");
    obj.label61:setAlign("top");
    obj.label61:setHeight(14);
    obj.label61:setFontSize(10);
    obj.label61:setFontColor("Gray");
    obj.label61:setName("label61");

    obj.edit94 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit94:setParent(obj.layout83);
    obj.edit94:setAlign("top");
    obj.edit94:setHeight(28);
    obj.edit94:setField("extraD4_custo");
    obj.edit94:setFontSize(12);
    obj.edit94:setMargins({bottom=6});
    obj.edit94:setName("edit94");

    obj.label62 = GUI.fromHandle(_obj_newObject("label"));
    obj.label62:setParent(obj.layout83);
    obj.label62:setText("Descrição");
    obj.label62:setAlign("top");
    obj.label62:setHeight(14);
    obj.label62:setFontSize(10);
    obj.label62:setFontColor("Gray");
    obj.label62:setName("label62");

    obj.textEditor4 = GUI.fromHandle(_obj_newObject("textEditor"));
    obj.textEditor4:setParent(obj.layout83);
    obj.textEditor4:setAlign("client");
    obj.textEditor4:setField("extraD4_desc");
    obj.textEditor4:setFontSize(12);
    obj.textEditor4:setName("textEditor4");

    obj.rowExtraD_5 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowExtraD_5:setParent(obj.layout72);
    obj.rowExtraD_5:setAlign("top");
    obj.rowExtraD_5:setHeight(240);
    obj.rowExtraD_5:setName("rowExtraD_5");
    obj.rowExtraD_5:setVisible(false);
    obj.rowExtraD_5:setMargins({bottom=12});

    obj.label63 = GUI.fromHandle(_obj_newObject("label"));
    obj.label63:setParent(obj.rowExtraD_5);
    obj.label63:setText("Nome");
    obj.label63:setAlign("top");
    obj.label63:setHeight(14);
    obj.label63:setFontSize(10);
    obj.label63:setFontColor("Gray");
    obj.label63:setName("label63");

    obj.layout84 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout84:setParent(obj.rowExtraD_5);
    obj.layout84:setAlign("top");
    obj.layout84:setHeight(30);
    obj.layout84:setMargins({bottom=6});
    obj.layout84:setName("layout84");

    obj.edit95 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit95:setParent(obj.layout84);
    obj.edit95:setAlign("client");
    obj.edit95:setField("extraD5_nome");
    obj.edit95:setHint("Título");
    obj.edit95:setFontSize(13);
    obj.edit95:setMargins({right=6});
    obj.edit95:setName("edit95");

    obj.button72 = GUI.fromHandle(_obj_newObject("button"));
    obj.button72:setParent(obj.layout84);
    obj.button72:setAlign("right");
    obj.button72:setWidth(90);
    obj.button72:setText("Excluir");
    obj.button72:setFontSize(11);
    obj.button72:setName("button72");

    obj.layout85 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout85:setParent(obj.rowExtraD_5);
    obj.layout85:setAlign("client");
    obj.layout85:setName("layout85");

    obj.label64 = GUI.fromHandle(_obj_newObject("label"));
    obj.label64:setParent(obj.layout85);
    obj.label64:setText("Permissão");
    obj.label64:setAlign("top");
    obj.label64:setHeight(14);
    obj.label64:setFontSize(10);
    obj.label64:setFontColor("Gray");
    obj.label64:setName("label64");

    obj.edit96 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit96:setParent(obj.layout85);
    obj.edit96:setAlign("top");
    obj.edit96:setHeight(28);
    obj.edit96:setField("extraD5_perm");
    obj.edit96:setFontSize(12);
    obj.edit96:setMargins({bottom=6});
    obj.edit96:setName("edit96");

    obj.label65 = GUI.fromHandle(_obj_newObject("label"));
    obj.label65:setParent(obj.layout85);
    obj.label65:setText("Custo");
    obj.label65:setAlign("top");
    obj.label65:setHeight(14);
    obj.label65:setFontSize(10);
    obj.label65:setFontColor("Gray");
    obj.label65:setName("label65");

    obj.edit97 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit97:setParent(obj.layout85);
    obj.edit97:setAlign("top");
    obj.edit97:setHeight(28);
    obj.edit97:setField("extraD5_custo");
    obj.edit97:setFontSize(12);
    obj.edit97:setMargins({bottom=6});
    obj.edit97:setName("edit97");

    obj.label66 = GUI.fromHandle(_obj_newObject("label"));
    obj.label66:setParent(obj.layout85);
    obj.label66:setText("Descrição");
    obj.label66:setAlign("top");
    obj.label66:setHeight(14);
    obj.label66:setFontSize(10);
    obj.label66:setFontColor("Gray");
    obj.label66:setName("label66");

    obj.textEditor5 = GUI.fromHandle(_obj_newObject("textEditor"));
    obj.textEditor5:setParent(obj.layout85);
    obj.textEditor5:setAlign("client");
    obj.textEditor5:setField("extraD5_desc");
    obj.textEditor5:setFontSize(12);
    obj.textEditor5:setName("textEditor5");

    obj.rowExtraD_6 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowExtraD_6:setParent(obj.layout72);
    obj.rowExtraD_6:setAlign("top");
    obj.rowExtraD_6:setHeight(240);
    obj.rowExtraD_6:setName("rowExtraD_6");
    obj.rowExtraD_6:setVisible(false);

    obj.label67 = GUI.fromHandle(_obj_newObject("label"));
    obj.label67:setParent(obj.rowExtraD_6);
    obj.label67:setText("Nome");
    obj.label67:setAlign("top");
    obj.label67:setHeight(14);
    obj.label67:setFontSize(10);
    obj.label67:setFontColor("Gray");
    obj.label67:setName("label67");

    obj.layout86 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout86:setParent(obj.rowExtraD_6);
    obj.layout86:setAlign("top");
    obj.layout86:setHeight(30);
    obj.layout86:setMargins({bottom=6});
    obj.layout86:setName("layout86");

    obj.edit98 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit98:setParent(obj.layout86);
    obj.edit98:setAlign("client");
    obj.edit98:setField("extraD6_nome");
    obj.edit98:setHint("Título");
    obj.edit98:setFontSize(13);
    obj.edit98:setMargins({right=6});
    obj.edit98:setName("edit98");

    obj.button73 = GUI.fromHandle(_obj_newObject("button"));
    obj.button73:setParent(obj.layout86);
    obj.button73:setAlign("right");
    obj.button73:setWidth(90);
    obj.button73:setText("Excluir");
    obj.button73:setFontSize(11);
    obj.button73:setName("button73");

    obj.layout87 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout87:setParent(obj.rowExtraD_6);
    obj.layout87:setAlign("client");
    obj.layout87:setName("layout87");

    obj.label68 = GUI.fromHandle(_obj_newObject("label"));
    obj.label68:setParent(obj.layout87);
    obj.label68:setText("Permissão");
    obj.label68:setAlign("top");
    obj.label68:setHeight(14);
    obj.label68:setFontSize(10);
    obj.label68:setFontColor("Gray");
    obj.label68:setName("label68");

    obj.edit99 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit99:setParent(obj.layout87);
    obj.edit99:setAlign("top");
    obj.edit99:setHeight(28);
    obj.edit99:setField("extraD6_perm");
    obj.edit99:setFontSize(12);
    obj.edit99:setMargins({bottom=6});
    obj.edit99:setName("edit99");

    obj.label69 = GUI.fromHandle(_obj_newObject("label"));
    obj.label69:setParent(obj.layout87);
    obj.label69:setText("Custo");
    obj.label69:setAlign("top");
    obj.label69:setHeight(14);
    obj.label69:setFontSize(10);
    obj.label69:setFontColor("Gray");
    obj.label69:setName("label69");

    obj.edit100 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit100:setParent(obj.layout87);
    obj.edit100:setAlign("top");
    obj.edit100:setHeight(28);
    obj.edit100:setField("extraD6_custo");
    obj.edit100:setFontSize(12);
    obj.edit100:setMargins({bottom=6});
    obj.edit100:setName("edit100");

    obj.label70 = GUI.fromHandle(_obj_newObject("label"));
    obj.label70:setParent(obj.layout87);
    obj.label70:setText("Descrição");
    obj.label70:setAlign("top");
    obj.label70:setHeight(14);
    obj.label70:setFontSize(10);
    obj.label70:setFontColor("Gray");
    obj.label70:setName("label70");

    obj.textEditor6 = GUI.fromHandle(_obj_newObject("textEditor"));
    obj.textEditor6:setParent(obj.layout87);
    obj.textEditor6:setAlign("client");
    obj.textEditor6:setField("extraD6_desc");
    obj.textEditor6:setFontSize(12);
    obj.textEditor6:setName("textEditor6");

    obj.tab3 = GUI.fromHandle(_obj_newObject("tab"));
    obj.tab3:setParent(obj.tcMain);
    obj.tab3:setTitle("Pessoal");
    obj.tab3:setName("tab3");

    obj.scrollBox3 = GUI.fromHandle(_obj_newObject("scrollBox"));
    obj.scrollBox3:setParent(obj.tab3);
    obj.scrollBox3:setAlign("client");
    obj.scrollBox3:setName("scrollBox3");

    obj.layout88 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout88:setParent(obj.scrollBox3);
    obj.layout88:setAlign("top");
    obj.layout88:setHeight(1110);
    obj.layout88:setMargins({left=10, right=10, top=10, bottom=10});
    obj.layout88:setName("layout88");

    obj.label71 = GUI.fromHandle(_obj_newObject("label"));
    obj.label71:setParent(obj.layout88);
    obj.label71:setText("IDENTIFICAÇÃO");
    obj.label71:setAlign("top");
    obj.label71:setHeight(22);
    obj.label71:setFontSize(13);
    obj.label71:setFontColor("#b9151f");
    lfm_setPropAsString(obj.label71, "fontStyle", "bold");
    obj.label71:setMargins({bottom=6});
    obj.label71:setName("label71");

    obj.layout89 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout89:setParent(obj.layout88);
    obj.layout89:setAlign("top");
    obj.layout89:setHeight(54);
    obj.layout89:setMargins({bottom=6});
    obj.layout89:setName("layout89");

    obj.layout90 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout90:setParent(obj.layout89);
    obj.layout90:setAlign("left");
    obj.layout90:setWidth(380);
    obj.layout90:setMargins({right=4});
    obj.layout90:setName("layout90");

    obj.label72 = GUI.fromHandle(_obj_newObject("label"));
    obj.label72:setParent(obj.layout90);
    obj.label72:setText("Nome");
    obj.label72:setAlign("top");
    obj.label72:setHeight(18);
    obj.label72:setFontSize(11);
    obj.label72:setFontColor("Gray");
    obj.label72:setName("label72");

    obj.edit101 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit101:setParent(obj.layout90);
    obj.edit101:setAlign("client");
    obj.edit101:setField("nome");
    obj.edit101:setFontSize(13);
    obj.edit101:setName("edit101");

    obj.layout91 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout91:setParent(obj.layout89);
    obj.layout91:setAlign("client");
    obj.layout91:setMargins({left=4});
    obj.layout91:setName("layout91");

    obj.label73 = GUI.fromHandle(_obj_newObject("label"));
    obj.label73:setParent(obj.layout91);
    obj.label73:setText("Nome alternativo / Alcunha");
    obj.label73:setAlign("top");
    obj.label73:setHeight(18);
    obj.label73:setFontSize(11);
    obj.label73:setFontColor("Gray");
    obj.label73:setName("label73");

    obj.edit102 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit102:setParent(obj.layout91);
    obj.edit102:setAlign("client");
    obj.edit102:setField("nomeAlternativo");
    obj.edit102:setFontSize(13);
    obj.edit102:setName("edit102");

    obj.layout92 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout92:setParent(obj.layout88);
    obj.layout92:setAlign("top");
    obj.layout92:setHeight(54);
    obj.layout92:setMargins({bottom=6});
    obj.layout92:setName("layout92");

    obj.layout93 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout93:setParent(obj.layout92);
    obj.layout93:setAlign("left");
    obj.layout93:setWidth(250);
    obj.layout93:setMargins({right=4});
    obj.layout93:setName("layout93");

    obj.label74 = GUI.fromHandle(_obj_newObject("label"));
    obj.label74:setParent(obj.layout93);
    obj.label74:setText("Idade");
    obj.label74:setAlign("top");
    obj.label74:setHeight(18);
    obj.label74:setFontSize(11);
    obj.label74:setFontColor("Gray");
    obj.label74:setName("label74");

    obj.edit103 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit103:setParent(obj.layout93);
    obj.edit103:setAlign("client");
    obj.edit103:setField("idade");
    obj.edit103:setFontSize(13);
    obj.edit103:setName("edit103");

    obj.layout94 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout94:setParent(obj.layout92);
    obj.layout94:setAlign("left");
    obj.layout94:setWidth(260);
    obj.layout94:setMargins({left=4, right=4});
    obj.layout94:setName("layout94");

    obj.label75 = GUI.fromHandle(_obj_newObject("label"));
    obj.label75:setParent(obj.layout94);
    obj.label75:setText("Gênero");
    obj.label75:setAlign("top");
    obj.label75:setHeight(18);
    obj.label75:setFontSize(11);
    obj.label75:setFontColor("Gray");
    obj.label75:setName("label75");

    obj.edit104 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit104:setParent(obj.layout94);
    obj.edit104:setAlign("client");
    obj.edit104:setField("genero");
    obj.edit104:setFontSize(13);
    obj.edit104:setName("edit104");

    obj.layout95 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout95:setParent(obj.layout92);
    obj.layout95:setAlign("client");
    obj.layout95:setMargins({left=4});
    obj.layout95:setName("layout95");

    obj.label76 = GUI.fromHandle(_obj_newObject("label"));
    obj.label76:setParent(obj.layout95);
    obj.label76:setText("Espécie / Raça");
    obj.label76:setAlign("top");
    obj.label76:setHeight(18);
    obj.label76:setFontSize(11);
    obj.label76:setFontColor("Gray");
    obj.label76:setName("label76");

    obj.edit105 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit105:setParent(obj.layout95);
    obj.edit105:setAlign("client");
    obj.edit105:setField("especieRaca");
    obj.edit105:setFontSize(13);
    obj.edit105:setName("edit105");

    obj.layout96 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout96:setParent(obj.layout88);
    obj.layout96:setAlign("top");
    obj.layout96:setHeight(54);
    obj.layout96:setMargins({bottom=18});
    obj.layout96:setName("layout96");

    obj.layout97 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout97:setParent(obj.layout96);
    obj.layout97:setAlign("left");
    obj.layout97:setWidth(250);
    obj.layout97:setMargins({right=4});
    obj.layout97:setName("layout97");

    obj.label77 = GUI.fromHandle(_obj_newObject("label"));
    obj.label77:setParent(obj.layout97);
    obj.label77:setText("Ocupação");
    obj.label77:setAlign("top");
    obj.label77:setHeight(18);
    obj.label77:setFontSize(11);
    obj.label77:setFontColor("Gray");
    obj.label77:setName("label77");

    obj.edit106 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit106:setParent(obj.layout97);
    obj.edit106:setAlign("client");
    obj.edit106:setField("ocupacao");
    obj.edit106:setFontSize(13);
    obj.edit106:setName("edit106");

    obj.layout98 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout98:setParent(obj.layout96);
    obj.layout98:setAlign("left");
    obj.layout98:setWidth(260);
    obj.layout98:setMargins({left=4, right=4});
    obj.layout98:setName("layout98");

    obj.label78 = GUI.fromHandle(_obj_newObject("label"));
    obj.label78:setParent(obj.layout98);
    obj.label78:setText("Origem");
    obj.label78:setAlign("top");
    obj.label78:setHeight(18);
    obj.label78:setFontSize(11);
    obj.label78:setFontColor("Gray");
    obj.label78:setName("label78");

    obj.edit107 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit107:setParent(obj.layout98);
    obj.edit107:setAlign("client");
    obj.edit107:setField("origem");
    obj.edit107:setFontSize(13);
    obj.edit107:setName("edit107");

    obj.layout99 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout99:setParent(obj.layout96);
    obj.layout99:setAlign("client");
    obj.layout99:setMargins({left=4});
    obj.layout99:setName("layout99");

    obj.label79 = GUI.fromHandle(_obj_newObject("label"));
    obj.label79:setParent(obj.layout99);
    obj.label79:setText("Afiliação");
    obj.label79:setAlign("top");
    obj.label79:setHeight(18);
    obj.label79:setFontSize(11);
    obj.label79:setFontColor("Gray");
    obj.label79:setName("label79");

    obj.edit108 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit108:setParent(obj.layout99);
    obj.edit108:setAlign("client");
    obj.edit108:setField("afiliacao");
    obj.edit108:setFontSize(13);
    obj.edit108:setName("edit108");

    obj.label80 = GUI.fromHandle(_obj_newObject("label"));
    obj.label80:setParent(obj.layout88);
    obj.label80:setText("DESCRIÇÃO DO PERSONAGEM");
    obj.label80:setAlign("top");
    obj.label80:setHeight(22);
    obj.label80:setFontSize(13);
    obj.label80:setFontColor("#b9151f");
    lfm_setPropAsString(obj.label80, "fontStyle", "bold");
    obj.label80:setMargins({bottom=6});
    obj.label80:setName("label80");

    obj.layout100 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout100:setParent(obj.layout88);
    obj.layout100:setAlign("top");
    obj.layout100:setHeight(112);
    obj.layout100:setMargins({bottom=8});
    obj.layout100:setName("layout100");

    obj.layout101 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout101:setParent(obj.layout100);
    obj.layout101:setAlign("left");
    obj.layout101:setWidth(450);
    obj.layout101:setMargins({right=4});
    obj.layout101:setName("layout101");

    obj.label81 = GUI.fromHandle(_obj_newObject("label"));
    obj.label81:setParent(obj.layout101);
    obj.label81:setText("Aparência");
    obj.label81:setAlign("top");
    obj.label81:setHeight(18);
    obj.label81:setFontSize(11);
    obj.label81:setFontColor("Gray");
    obj.label81:setName("label81");

    obj.textEditor7 = GUI.fromHandle(_obj_newObject("textEditor"));
    obj.textEditor7:setParent(obj.layout101);
    obj.textEditor7:setAlign("client");
    obj.textEditor7:setField("aparencia");
    obj.textEditor7:setFontSize(12);
    obj.textEditor7:setName("textEditor7");

    obj.layout102 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout102:setParent(obj.layout100);
    obj.layout102:setAlign("client");
    obj.layout102:setMargins({left=4});
    obj.layout102:setName("layout102");

    obj.label82 = GUI.fromHandle(_obj_newObject("label"));
    obj.label82:setParent(obj.layout102);
    obj.label82:setText("Personalidade");
    obj.label82:setAlign("top");
    obj.label82:setHeight(18);
    obj.label82:setFontSize(11);
    obj.label82:setFontColor("Gray");
    obj.label82:setName("label82");

    obj.textEditor8 = GUI.fromHandle(_obj_newObject("textEditor"));
    obj.textEditor8:setParent(obj.layout102);
    obj.textEditor8:setAlign("client");
    obj.textEditor8:setField("personalidade");
    obj.textEditor8:setFontSize(12);
    obj.textEditor8:setName("textEditor8");

    obj.layout103 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout103:setParent(obj.layout88);
    obj.layout103:setAlign("top");
    obj.layout103:setHeight(150);
    obj.layout103:setMargins({bottom=8});
    obj.layout103:setName("layout103");

    obj.label83 = GUI.fromHandle(_obj_newObject("label"));
    obj.label83:setParent(obj.layout103);
    obj.label83:setText("História");
    obj.label83:setAlign("top");
    obj.label83:setHeight(18);
    obj.label83:setFontSize(11);
    obj.label83:setFontColor("Gray");
    obj.label83:setName("label83");

    obj.textEditor9 = GUI.fromHandle(_obj_newObject("textEditor"));
    obj.textEditor9:setParent(obj.layout103);
    obj.textEditor9:setAlign("client");
    obj.textEditor9:setField("historia");
    obj.textEditor9:setFontSize(12);
    obj.textEditor9:setName("textEditor9");

    obj.layout104 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout104:setParent(obj.layout88);
    obj.layout104:setAlign("top");
    obj.layout104:setHeight(112);
    obj.layout104:setMargins({bottom=18});
    obj.layout104:setName("layout104");

    obj.layout105 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout105:setParent(obj.layout104);
    obj.layout105:setAlign("left");
    obj.layout105:setWidth(450);
    obj.layout105:setMargins({right=4});
    obj.layout105:setName("layout105");

    obj.label84 = GUI.fromHandle(_obj_newObject("label"));
    obj.label84:setParent(obj.layout105);
    obj.label84:setText("Objetivos, Ideais, Medos e Fraquezas");
    obj.label84:setAlign("top");
    obj.label84:setHeight(32);
    obj.label84:setFontSize(10);
    obj.label84:setFontColor("Gray");
    obj.label84:setName("label84");

    obj.textEditor10 = GUI.fromHandle(_obj_newObject("textEditor"));
    obj.textEditor10:setParent(obj.layout105);
    obj.textEditor10:setAlign("client");
    obj.textEditor10:setField("motivacoes");
    obj.textEditor10:setFontSize(12);
    obj.textEditor10:setName("textEditor10");

    obj.layout106 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout106:setParent(obj.layout104);
    obj.layout106:setAlign("client");
    obj.layout106:setMargins({left=4});
    obj.layout106:setName("layout106");

    obj.label85 = GUI.fromHandle(_obj_newObject("label"));
    obj.label85:setParent(obj.layout106);
    obj.label85:setText("Relacionamentos");
    obj.label85:setAlign("top");
    obj.label85:setHeight(18);
    obj.label85:setFontSize(11);
    obj.label85:setFontColor("Gray");
    obj.label85:setName("label85");

    obj.textEditor11 = GUI.fromHandle(_obj_newObject("textEditor"));
    obj.textEditor11:setParent(obj.layout106);
    obj.textEditor11:setAlign("client");
    obj.textEditor11:setField("relacionamentos");
    obj.textEditor11:setFontSize(12);
    obj.textEditor11:setName("textEditor11");

    obj.label86 = GUI.fromHandle(_obj_newObject("label"));
    obj.label86:setParent(obj.layout88);
    obj.label86:setText("RECURSOS");
    obj.label86:setAlign("top");
    obj.label86:setHeight(22);
    obj.label86:setFontSize(13);
    obj.label86:setFontColor("#b9151f");
    lfm_setPropAsString(obj.label86, "fontStyle", "bold");
    obj.label86:setMargins({bottom=6});
    obj.label86:setName("label86");

    obj.layout107 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout107:setParent(obj.layout88);
    obj.layout107:setAlign("top");
    obj.layout107:setHeight(112);
    obj.layout107:setMargins({bottom=8});
    obj.layout107:setName("layout107");

    obj.label87 = GUI.fromHandle(_obj_newObject("label"));
    obj.label87:setParent(obj.layout107);
    obj.label87:setText("Equipamentos e Pertences");
    obj.label87:setAlign("top");
    obj.label87:setHeight(18);
    obj.label87:setFontSize(11);
    obj.label87:setFontColor("Gray");
    obj.label87:setName("label87");

    obj.textEditor12 = GUI.fromHandle(_obj_newObject("textEditor"));
    obj.textEditor12:setParent(obj.layout107);
    obj.textEditor12:setAlign("client");
    obj.textEditor12:setField("equipamentosPertences");
    obj.textEditor12:setFontSize(12);
    obj.textEditor12:setName("textEditor12");

    obj.layout108 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout108:setParent(obj.layout88);
    obj.layout108:setAlign("top");
    obj.layout108:setHeight(112);
    obj.layout108:setMargins({bottom=8});
    obj.layout108:setName("layout108");

    obj.label88 = GUI.fromHandle(_obj_newObject("label"));
    obj.label88:setParent(obj.layout108);
    obj.label88:setText("Aliados e Contatos");
    obj.label88:setAlign("top");
    obj.label88:setHeight(18);
    obj.label88:setFontSize(11);
    obj.label88:setFontColor("Gray");
    obj.label88:setName("label88");

    obj.textEditor13 = GUI.fromHandle(_obj_newObject("textEditor"));
    obj.textEditor13:setParent(obj.layout108);
    obj.textEditor13:setAlign("client");
    obj.textEditor13:setField("aliadosContatos");
    obj.textEditor13:setFontSize(12);
    obj.textEditor13:setName("textEditor13");

    obj.layout109 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout109:setParent(obj.layout88);
    obj.layout109:setAlign("top");
    obj.layout109:setHeight(112);
    obj.layout109:setName("layout109");

    obj.label89 = GUI.fromHandle(_obj_newObject("label"));
    obj.label89:setParent(obj.layout109);
    obj.label89:setText("Outras Informações");
    obj.label89:setAlign("top");
    obj.label89:setHeight(18);
    obj.label89:setFontSize(11);
    obj.label89:setFontColor("Gray");
    obj.label89:setName("label89");

    obj.textEditor14 = GUI.fromHandle(_obj_newObject("textEditor"));
    obj.textEditor14:setParent(obj.layout109);
    obj.textEditor14:setAlign("client");
    obj.textEditor14:setField("outrasInformacoes");
    obj.textEditor14:setFontSize(12);
    obj.textEditor14:setName("textEditor14");

    obj.tab4 = GUI.fromHandle(_obj_newObject("tab"));
    obj.tab4:setParent(obj.tcMain);
    obj.tab4:setTitle("Configuração");
    obj.tab4:setName("tab4");

    obj.scrollBox4 = GUI.fromHandle(_obj_newObject("scrollBox"));
    obj.scrollBox4:setParent(obj.tab4);
    obj.scrollBox4:setAlign("client");
    obj.scrollBox4:setName("scrollBox4");

    obj.layout110 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout110:setParent(obj.scrollBox4);
    obj.layout110:setAlign("client");
    obj.layout110:setMargins({left=12, right=12, top=12, bottom=12});
    obj.layout110:setName("layout110");

    obj.label90 = GUI.fromHandle(_obj_newObject("label"));
    obj.label90:setParent(obj.layout110);
    obj.label90:setText("Estresse");
    obj.label90:setAlign("top");
    obj.label90:setHeight(20);
    lfm_setPropAsString(obj.label90, "fontStyle", "bold");
    obj.label90:setFontSize(13);
    obj.label90:setName("label90");

    obj.layout111 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout111:setParent(obj.layout110);
    obj.layout111:setAlign("top");
    obj.layout111:setHeight(28);
    obj.layout111:setMargins({bottom=4, top=4});
    obj.layout111:setName("layout111");

    obj.label91 = GUI.fromHandle(_obj_newObject("label"));
    obj.label91:setParent(obj.layout111);
    obj.label91:setText("Caixas Físico (2 a 8)");
    obj.label91:setAlign("left");
    obj.label91:setWidth(180);
    obj.label91:setFontSize(11);
    obj.label91:setVertTextAlign("center");
    obj.label91:setName("label91");

    obj.edit109 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit109:setParent(obj.layout111);
    obj.edit109:setAlign("left");
    obj.edit109:setWidth(54);
    obj.edit109:setField("cfg_fisico");
    obj.edit109:setHint("4");
    obj.edit109:setHorzTextAlign("center");
    obj.edit109:setName("edit109");

    obj.layout112 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout112:setParent(obj.layout110);
    obj.layout112:setAlign("top");
    obj.layout112:setHeight(28);
    obj.layout112:setMargins({bottom=16});
    obj.layout112:setName("layout112");

    obj.label92 = GUI.fromHandle(_obj_newObject("label"));
    obj.label92:setParent(obj.layout112);
    obj.label92:setText("Caixas Mental (2 a 8)");
    obj.label92:setAlign("left");
    obj.label92:setWidth(180);
    obj.label92:setFontSize(11);
    obj.label92:setVertTextAlign("center");
    obj.label92:setName("label92");

    obj.edit110 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit110:setParent(obj.layout112);
    obj.edit110:setAlign("left");
    obj.edit110:setWidth(54);
    obj.edit110:setField("cfg_mental");
    obj.edit110:setHint("4");
    obj.edit110:setHorzTextAlign("center");
    obj.edit110:setName("edit110");

    obj.label93 = GUI.fromHandle(_obj_newObject("label"));
    obj.label93:setParent(obj.layout110);
    obj.label93:setText("Consequências");
    obj.label93:setAlign("top");
    obj.label93:setHeight(20);
    lfm_setPropAsString(obj.label93, "fontStyle", "bold");
    obj.label93:setFontSize(13);
    obj.label93:setName("label93");

    obj.layout113 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout113:setParent(obj.layout110);
    obj.layout113:setAlign("top");
    obj.layout113:setHeight(28);
    obj.layout113:setMargins({top=4});
    obj.layout113:setName("layout113");

    obj.label94 = GUI.fromHandle(_obj_newObject("label"));
    obj.label94:setParent(obj.layout113);
    obj.label94:setText("Consequência Suave extra");
    obj.label94:setAlign("left");
    obj.label94:setWidth(200);
    obj.label94:setFontSize(11);
    obj.label94:setVertTextAlign("center");
    obj.label94:setName("label94");

    obj.checkBox1 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.checkBox1:setParent(obj.layout113);
    obj.checkBox1:setAlign("client");
    obj.checkBox1:setField("cfg_cse");
    obj.checkBox1:setText("");
    obj.checkBox1:setChecked(true);
    obj.checkBox1:setName("checkBox1");

    obj._e_event0 = obj:addEventListener("onNodeReady",
        function ()
            aplicarConfig()
        end);

    obj._e_event1 = obj.button1:addEventListener("onClick",
        function (event)
            rolarFate(self.per8_1.text, self.per8_1v.text)
        end);

    obj._e_event2 = obj.button2:addEventListener("onClick",
        function (event)
            rolarFate(self.per7_1.text, self.per7_1v.text)
        end);

    obj._e_event3 = obj.button3:addEventListener("onClick",
        function (event)
            rolarFate(self.per6_1.text, self.per6_1v.text)
        end);

    obj._e_event4 = obj.button4:addEventListener("onClick",
        function (event)
            rolarFate(self.per5_1.text, self.per5_1v.text)
        end);

    obj._e_event5 = obj.button5:addEventListener("onClick",
        function (event)
            rolarFate(self.per4_1.text, self.per4_1v.text)
        end);

    obj._e_event6 = obj.button6:addEventListener("onClick",
        function (event)
            rolarFate(self.per4_2.text, self.per4_2v.text)
        end);

    obj._e_event7 = obj.button7:addEventListener("onClick",
        function (event)
            rolarFate(self.per3_1.text, self.per3_1v.text)
        end);

    obj._e_event8 = obj.button8:addEventListener("onClick",
        function (event)
            rolarFate(self.per3_2.text, self.per3_2v.text)
        end);

    obj._e_event9 = obj.button9:addEventListener("onClick",
        function (event)
            rolarFate(self.per3_3.text, self.per3_3v.text)
        end);

    obj._e_event10 = obj.button10:addEventListener("onClick",
        function (event)
            rolarFate(self.per2_1.text, self.per2_1v.text)
        end);

    obj._e_event11 = obj.button11:addEventListener("onClick",
        function (event)
            rolarFate(self.per2_2.text, self.per2_2v.text)
        end);

    obj._e_event12 = obj.button12:addEventListener("onClick",
        function (event)
            rolarFate(self.per2_3.text, self.per2_3v.text)
        end);

    obj._e_event13 = obj.button13:addEventListener("onClick",
        function (event)
            rolarFate(self.per2_4.text, self.per2_4v.text)
        end);

    obj._e_event14 = obj.button14:addEventListener("onClick",
        function (event)
            rolarFate(self.per1_1.text, self.per1_1v.text)
        end);

    obj._e_event15 = obj.button15:addEventListener("onClick",
        function (event)
            rolarFate(self.per1_2.text, self.per1_2v.text)
        end);

    obj._e_event16 = obj.button16:addEventListener("onClick",
        function (event)
            rolarFate(self.per1_3.text, self.per1_3v.text)
        end);

    obj._e_event17 = obj.button17:addEventListener("onClick",
        function (event)
            rolarFate(self.per1_4.text, self.per1_4v.text)
        end);

    obj._e_event18 = obj.button18:addEventListener("onClick",
        function (event)
            rolarFate(self.per1_5.text, self.per1_5v.text)
        end);

    obj._e_event19 = obj.button19:addEventListener("onClick",
        function (event)
            removerRetrato()
        end);

    obj._e_event20 = obj.imgRetrato:addEventListener("onPictureLoadedChange",
        function ()
            atualizarDicaRetrato()
        end);

    obj._e_event21 = obj.imgRetrato:addEventListener("onLoad",
        function ()
            atualizarDicaRetrato()
        end);

    obj._e_event22 = obj.button20:addEventListener("onClick",
        function (event)
            adicionarPericia()
        end);

    obj._e_event23 = obj.edit53:addEventListener("onExit",
        function ()
            atualizarNivelPericia(1)
        end);

    obj._e_event24 = obj.button21:addEventListener("onClick",
        function (event)
            rolarFate(self.pericia_1_nome.text, self.pericia_1_bonus.text)
        end);

    obj._e_event25 = obj.button22:addEventListener("onClick",
        function (event)
            removerPericia(1)
        end);

    obj._e_event26 = obj.edit54:addEventListener("onExit",
        function ()
            atualizarNivelPericia(2)
        end);

    obj._e_event27 = obj.button23:addEventListener("onClick",
        function (event)
            rolarFate(self.pericia_2_nome.text, self.pericia_2_bonus.text)
        end);

    obj._e_event28 = obj.button24:addEventListener("onClick",
        function (event)
            removerPericia(2)
        end);

    obj._e_event29 = obj.edit55:addEventListener("onExit",
        function ()
            atualizarNivelPericia(3)
        end);

    obj._e_event30 = obj.button25:addEventListener("onClick",
        function (event)
            rolarFate(self.pericia_3_nome.text, self.pericia_3_bonus.text)
        end);

    obj._e_event31 = obj.button26:addEventListener("onClick",
        function (event)
            removerPericia(3)
        end);

    obj._e_event32 = obj.edit56:addEventListener("onExit",
        function ()
            atualizarNivelPericia(4)
        end);

    obj._e_event33 = obj.button27:addEventListener("onClick",
        function (event)
            rolarFate(self.pericia_4_nome.text, self.pericia_4_bonus.text)
        end);

    obj._e_event34 = obj.button28:addEventListener("onClick",
        function (event)
            removerPericia(4)
        end);

    obj._e_event35 = obj.edit57:addEventListener("onExit",
        function ()
            atualizarNivelPericia(5)
        end);

    obj._e_event36 = obj.button29:addEventListener("onClick",
        function (event)
            rolarFate(self.pericia_5_nome.text, self.pericia_5_bonus.text)
        end);

    obj._e_event37 = obj.button30:addEventListener("onClick",
        function (event)
            removerPericia(5)
        end);

    obj._e_event38 = obj.edit58:addEventListener("onExit",
        function ()
            atualizarNivelPericia(6)
        end);

    obj._e_event39 = obj.button31:addEventListener("onClick",
        function (event)
            rolarFate(self.pericia_6_nome.text, self.pericia_6_bonus.text)
        end);

    obj._e_event40 = obj.button32:addEventListener("onClick",
        function (event)
            removerPericia(6)
        end);

    obj._e_event41 = obj.edit59:addEventListener("onExit",
        function ()
            atualizarNivelPericia(7)
        end);

    obj._e_event42 = obj.button33:addEventListener("onClick",
        function (event)
            rolarFate(self.pericia_7_nome.text, self.pericia_7_bonus.text)
        end);

    obj._e_event43 = obj.button34:addEventListener("onClick",
        function (event)
            removerPericia(7)
        end);

    obj._e_event44 = obj.edit60:addEventListener("onExit",
        function ()
            atualizarNivelPericia(8)
        end);

    obj._e_event45 = obj.button35:addEventListener("onClick",
        function (event)
            rolarFate(self.pericia_8_nome.text, self.pericia_8_bonus.text)
        end);

    obj._e_event46 = obj.button36:addEventListener("onClick",
        function (event)
            removerPericia(8)
        end);

    obj._e_event47 = obj.edit61:addEventListener("onExit",
        function ()
            atualizarNivelPericia(9)
        end);

    obj._e_event48 = obj.button37:addEventListener("onClick",
        function (event)
            rolarFate(self.pericia_9_nome.text, self.pericia_9_bonus.text)
        end);

    obj._e_event49 = obj.button38:addEventListener("onClick",
        function (event)
            removerPericia(9)
        end);

    obj._e_event50 = obj.edit62:addEventListener("onExit",
        function ()
            atualizarNivelPericia(10)
        end);

    obj._e_event51 = obj.button39:addEventListener("onClick",
        function (event)
            rolarFate(self.pericia_10_nome.text, self.pericia_10_bonus.text)
        end);

    obj._e_event52 = obj.button40:addEventListener("onClick",
        function (event)
            removerPericia(10)
        end);

    obj._e_event53 = obj.edit63:addEventListener("onExit",
        function ()
            atualizarNivelPericia(11)
        end);

    obj._e_event54 = obj.button41:addEventListener("onClick",
        function (event)
            rolarFate(self.pericia_11_nome.text, self.pericia_11_bonus.text)
        end);

    obj._e_event55 = obj.button42:addEventListener("onClick",
        function (event)
            removerPericia(11)
        end);

    obj._e_event56 = obj.edit64:addEventListener("onExit",
        function ()
            atualizarNivelPericia(12)
        end);

    obj._e_event57 = obj.button43:addEventListener("onClick",
        function (event)
            rolarFate(self.pericia_12_nome.text, self.pericia_12_bonus.text)
        end);

    obj._e_event58 = obj.button44:addEventListener("onClick",
        function (event)
            removerPericia(12)
        end);

    obj._e_event59 = obj.edit65:addEventListener("onExit",
        function ()
            atualizarNivelPericia(13)
        end);

    obj._e_event60 = obj.button45:addEventListener("onClick",
        function (event)
            rolarFate(self.pericia_13_nome.text, self.pericia_13_bonus.text)
        end);

    obj._e_event61 = obj.button46:addEventListener("onClick",
        function (event)
            removerPericia(13)
        end);

    obj._e_event62 = obj.edit66:addEventListener("onExit",
        function ()
            atualizarNivelPericia(14)
        end);

    obj._e_event63 = obj.button47:addEventListener("onClick",
        function (event)
            rolarFate(self.pericia_14_nome.text, self.pericia_14_bonus.text)
        end);

    obj._e_event64 = obj.button48:addEventListener("onClick",
        function (event)
            removerPericia(14)
        end);

    obj._e_event65 = obj.edit67:addEventListener("onExit",
        function ()
            atualizarNivelPericia(15)
        end);

    obj._e_event66 = obj.button49:addEventListener("onClick",
        function (event)
            rolarFate(self.pericia_15_nome.text, self.pericia_15_bonus.text)
        end);

    obj._e_event67 = obj.button50:addEventListener("onClick",
        function (event)
            removerPericia(15)
        end);

    obj._e_event68 = obj.edit68:addEventListener("onExit",
        function ()
            atualizarNivelPericia(16)
        end);

    obj._e_event69 = obj.button51:addEventListener("onClick",
        function (event)
            rolarFate(self.pericia_16_nome.text, self.pericia_16_bonus.text)
        end);

    obj._e_event70 = obj.button52:addEventListener("onClick",
        function (event)
            removerPericia(16)
        end);

    obj._e_event71 = obj.button53:addEventListener("onClick",
        function (event)
            adicionarFacanha()
        end);

    obj._e_event72 = obj.button54:addEventListener("onClick",
        function (event)
            removerFacanha(1)
        end);

    obj._e_event73 = obj.button55:addEventListener("onClick",
        function (event)
            removerFacanha(2)
        end);

    obj._e_event74 = obj.button56:addEventListener("onClick",
        function (event)
            removerFacanha(3)
        end);

    obj._e_event75 = obj.button57:addEventListener("onClick",
        function (event)
            removerFacanha(4)
        end);

    obj._e_event76 = obj.button58:addEventListener("onClick",
        function (event)
            removerFacanha(5)
        end);

    obj._e_event77 = obj.button59:addEventListener("onClick",
        function (event)
            removerFacanha(6)
        end);

    obj._e_event78 = obj.button60:addEventListener("onClick",
        function (event)
            removerFacanha(7)
        end);

    obj._e_event79 = obj.button61:addEventListener("onClick",
        function (event)
            removerFacanha(8)
        end);

    obj._e_event80 = obj.button62:addEventListener("onClick",
        function (event)
            removerFacanha(9)
        end);

    obj._e_event81 = obj.button63:addEventListener("onClick",
        function (event)
            removerFacanha(10)
        end);

    obj._e_event82 = obj.button64:addEventListener("onClick",
        function (event)
            adicionarExtra()
        end);

    obj._e_event83 = obj.button65:addEventListener("onClick",
        function (event)
            removerExtra(1)
        end);

    obj._e_event84 = obj.button66:addEventListener("onClick",
        function (event)
            alternarDescricaoExtra(1)
        end);

    obj._e_event85 = obj.button67:addEventListener("onClick",
        function (event)
            removerExtra(2)
        end);

    obj._e_event86 = obj.button68:addEventListener("onClick",
        function (event)
            alternarDescricaoExtra(2)
        end);

    obj._e_event87 = obj.button69:addEventListener("onClick",
        function (event)
            removerExtra(3)
        end);

    obj._e_event88 = obj.button70:addEventListener("onClick",
        function (event)
            alternarDescricaoExtra(3)
        end);

    obj._e_event89 = obj.button71:addEventListener("onClick",
        function (event)
            removerExtra(4)
        end);

    obj._e_event90 = obj.button72:addEventListener("onClick",
        function (event)
            removerExtra(5)
        end);

    obj._e_event91 = obj.button73:addEventListener("onClick",
        function (event)
            removerExtra(6)
        end);

    obj._e_event92 = obj.edit109:addEventListener("onExit",
        function ()
            aplicarConfig()
        end);

    obj._e_event93 = obj.edit110:addEventListener("onExit",
        function ()
            aplicarConfig()
        end);

    obj._e_event94 = obj.checkBox1:addEventListener("onChange",
        function ()
            aplicarConfig()
        end);

    function obj:_releaseEvents()
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

        if self.edit90 ~= nil then self.edit90:destroy(); self.edit90 = nil; end;
        if self.edit77 ~= nil then self.edit77:destroy(); self.edit77 = nil; end;
        if self.edit47 ~= nil then self.edit47:destroy(); self.edit47 = nil; end;
        if self.chkFisico_4 ~= nil then self.chkFisico_4:destroy(); self.chkFisico_4 = nil; end;
        if self.rowPericia_6 ~= nil then self.rowPericia_6:destroy(); self.rowPericia_6 = nil; end;
        if self.button66 ~= nil then self.button66:destroy(); self.button66 = nil; end;
        if self.edit95 ~= nil then self.edit95:destroy(); self.edit95 = nil; end;
        if self.edit70 ~= nil then self.edit70:destroy(); self.edit70 = nil; end;
        if self.edit42 ~= nil then self.edit42:destroy(); self.edit42 = nil; end;
        if self.label91 ~= nil then self.label91:destroy(); self.label91 = nil; end;
        if self.chkMentalTopo_2 ~= nil then self.chkMentalTopo_2:destroy(); self.chkMentalTopo_2 = nil; end;
        if self.imgRetrato ~= nil then self.imgRetrato:destroy(); self.imgRetrato = nil; end;
        if self.layout70 ~= nil then self.layout70:destroy(); self.layout70 = nil; end;
        if self.edit49 ~= nil then self.edit49:destroy(); self.edit49 = nil; end;
        if self.label67 ~= nil then self.label67:destroy(); self.label67 = nil; end;
        if self.edit27 ~= nil then self.edit27:destroy(); self.edit27 = nil; end;
        if self.rowPericia_8 ~= nil then self.rowPericia_8:destroy(); self.rowPericia_8 = nil; end;
        if self.layout75 ~= nil then self.layout75:destroy(); self.layout75 = nil; end;
        if self.button68 ~= nil then self.button68:destroy(); self.button68 = nil; end;
        if self.pericia_9_nome ~= nil then self.pericia_9_nome:destroy(); self.pericia_9_nome = nil; end;
        if self.layout111 ~= nil then self.layout111:destroy(); self.layout111 = nil; end;
        if self.checkBox1 ~= nil then self.checkBox1:destroy(); self.checkBox1 = nil; end;
        if self.rowNivel_5 ~= nil then self.rowNivel_5:destroy(); self.rowNivel_5 = nil; end;
        if self.label62 ~= nil then self.label62:destroy(); self.label62 = nil; end;
        if self.edit9 ~= nil then self.edit9:destroy(); self.edit9 = nil; end;
        if self.edit108 ~= nil then self.edit108:destroy(); self.edit108 = nil; end;
        if self.edit65 ~= nil then self.edit65:destroy(); self.edit65 = nil; end;
        if self.layout37 ~= nil then self.layout37:destroy(); self.layout37 = nil; end;
        if self.button44 ~= nil then self.button44:destroy(); self.button44 = nil; end;
        if self.layout59 ~= nil then self.layout59:destroy(); self.layout59 = nil; end;
        if self.label69 ~= nil then self.label69:destroy(); self.label69 = nil; end;
        if self.edit60 ~= nil then self.edit60:destroy(); self.edit60 = nil; end;
        if self.rowPericia_14 ~= nil then self.rowPericia_14:destroy(); self.rowPericia_14 = nil; end;
        if self.layout52 ~= nil then self.layout52:destroy(); self.layout52 = nil; end;
        if self.layout60 ~= nil then self.layout60:destroy(); self.layout60 = nil; end;
        if self.edit3 ~= nil then self.edit3:destroy(); self.edit3 = nil; end;
        if self.button8 ~= nil then self.button8:destroy(); self.button8 = nil; end;
        if self.button34 ~= nil then self.button34:destroy(); self.button34 = nil; end;
        if self.rowPericia_11 ~= nil then self.rowPericia_11:destroy(); self.rowPericia_11 = nil; end;
        if self.label39 ~= nil then self.label39:destroy(); self.label39 = nil; end;
        if self.edit102 ~= nil then self.edit102:destroy(); self.edit102 = nil; end;
        if self.label45 ~= nil then self.label45:destroy(); self.label45 = nil; end;
        if self.tab1 ~= nil then self.tab1:destroy(); self.tab1 = nil; end;
        if self.layout57 ~= nil then self.layout57:destroy(); self.layout57 = nil; end;
        if self.layout18 ~= nil then self.layout18:destroy(); self.layout18 = nil; end;
        if self.edit6 ~= nil then self.edit6:destroy(); self.edit6 = nil; end;
        if self.button3 ~= nil then self.button3:destroy(); self.button3 = nil; end;
        if self.pericia_14_bonus ~= nil then self.pericia_14_bonus:destroy(); self.pericia_14_bonus = nil; end;
        if self.rowFacanha_5 ~= nil then self.rowFacanha_5:destroy(); self.rowFacanha_5 = nil; end;
        if self.layout67 ~= nil then self.layout67:destroy(); self.layout67 = nil; end;
        if self.pericia_1_bonus ~= nil then self.pericia_1_bonus:destroy(); self.pericia_1_bonus = nil; end;
        if self.edit107 ~= nil then self.edit107:destroy(); self.edit107 = nil; end;
        if self.label40 ~= nil then self.label40:destroy(); self.label40 = nil; end;
        if self.label9 ~= nil then self.label9:destroy(); self.label9 = nil; end;
        if self.layout15 ~= nil then self.layout15:destroy(); self.layout15 = nil; end;
        if self.button18 ~= nil then self.button18:destroy(); self.button18 = nil; end;
        if self.button6 ~= nil then self.button6:destroy(); self.button6 = nil; end;
        if self.label33 ~= nil then self.label33:destroy(); self.label33 = nil; end;
        if self.layout7 ~= nil then self.layout7:destroy(); self.layout7 = nil; end;
        if self.button21 ~= nil then self.button21:destroy(); self.button21 = nil; end;
        if self.pericia_11_nome ~= nil then self.pericia_11_nome:destroy(); self.pericia_11_nome = nil; end;
        if self.chkMental_4 ~= nil then self.chkMental_4:destroy(); self.chkMental_4 = nil; end;
        if self.edit31 ~= nil then self.edit31:destroy(); self.edit31 = nil; end;
        if self.layout2 ~= nil then self.layout2:destroy(); self.layout2 = nil; end;
        if self.pericia_15_nome ~= nil then self.pericia_15_nome:destroy(); self.pericia_15_nome = nil; end;
        if self.layout42 ~= nil then self.layout42:destroy(); self.layout42 = nil; end;
        if self.label7 ~= nil then self.label7:destroy(); self.label7 = nil; end;
        if self.button16 ~= nil then self.button16:destroy(); self.button16 = nil; end;
        if self.button24 ~= nil then self.button24:destroy(); self.button24 = nil; end;
        if self.chkMental_3 ~= nil then self.chkMental_3:destroy(); self.chkMental_3 = nil; end;
        if self.textEditor14 ~= nil then self.textEditor14:destroy(); self.textEditor14 = nil; end;
        if self.layout45 ~= nil then self.layout45:destroy(); self.layout45 = nil; end;
        if self.edit10 ~= nil then self.edit10:destroy(); self.edit10 = nil; end;
        if self.nivelPericia_5 ~= nil then self.nivelPericia_5:destroy(); self.nivelPericia_5 = nil; end;
        if self.button54 ~= nil then self.button54:destroy(); self.button54 = nil; end;
        if self.edit85 ~= nil then self.edit85:destroy(); self.edit85 = nil; end;
        if self.label81 ~= nil then self.label81:destroy(); self.label81 = nil; end;
        if self.label11 ~= nil then self.label11:destroy(); self.label11 = nil; end;
        if self.label25 ~= nil then self.label25:destroy(); self.label25 = nil; end;
        if self.edit15 ~= nil then self.edit15:destroy(); self.edit15 = nil; end;
        if self.layout48 ~= nil then self.layout48:destroy(); self.layout48 = nil; end;
        if self.pericia_4_nome ~= nil then self.pericia_4_nome:destroy(); self.pericia_4_nome = nil; end;
        if self.button51 ~= nil then self.button51:destroy(); self.button51 = nil; end;
        if self.label84 ~= nil then self.label84:destroy(); self.label84 = nil; end;
        if self.layout88 ~= nil then self.layout88:destroy(); self.layout88 = nil; end;
        if self.layout96 ~= nil then self.layout96:destroy(); self.layout96 = nil; end;
        if self.label28 ~= nil then self.label28:destroy(); self.label28 = nil; end;
        if self.label57 ~= nil then self.label57:destroy(); self.label57 = nil; end;
        if self.edit57 ~= nil then self.edit57:destroy(); self.edit57 = nil; end;
        if self.textEditor3 ~= nil then self.textEditor3:destroy(); self.textEditor3 = nil; end;
        if self.layout24 ~= nil then self.layout24:destroy(); self.layout24 = nil; end;
        if self.nivelPericia_14 ~= nil then self.nivelPericia_14:destroy(); self.nivelPericia_14 = nil; end;
        if self.scrollBox1 ~= nil then self.scrollBox1:destroy(); self.scrollBox1 = nil; end;
        if self.rowExtraD_2 ~= nil then self.rowExtraD_2:destroy(); self.rowExtraD_2 = nil; end;
        if self.label50 ~= nil then self.label50:destroy(); self.label50 = nil; end;
        if self.button70 ~= nil then self.button70:destroy(); self.button70 = nil; end;
        if self.layout83 ~= nil then self.layout83:destroy(); self.layout83 = nil; end;
        if self.textEditor6 ~= nil then self.textEditor6:destroy(); self.textEditor6 = nil; end;
        if self.rowAspecto_5 ~= nil then self.rowAspecto_5:destroy(); self.rowAspecto_5 = nil; end;
        if self.chkFisicoTopo_4 ~= nil then self.chkFisicoTopo_4:destroy(); self.chkFisicoTopo_4 = nil; end;
        if self.layout93 ~= nil then self.layout93:destroy(); self.layout93 = nil; end;
        if self.layout23 ~= nil then self.layout23:destroy(); self.layout23 = nil; end;
        if self.nivelPericia_11 ~= nil then self.nivelPericia_11:destroy(); self.nivelPericia_11 = nil; end;
        if self.layout104 ~= nil then self.layout104:destroy(); self.layout104 = nil; end;
        if self.label77 ~= nil then self.label77:destroy(); self.label77 = nil; end;
        if self.edit78 ~= nil then self.edit78:destroy(); self.edit78 = nil; end;
        if self.layout99 ~= nil then self.layout99:destroy(); self.layout99 = nil; end;
        if self.layout101 ~= nil then self.layout101:destroy(); self.layout101 = nil; end;
        if self.chkFisico_7 ~= nil then self.chkFisico_7:destroy(); self.chkFisico_7 = nil; end;
        if self.rowPericia_5 ~= nil then self.rowPericia_5:destroy(); self.rowPericia_5 = nil; end;
        if self.button65 ~= nil then self.button65:destroy(); self.button65 = nil; end;
        if self.layout78 ~= nil then self.layout78:destroy(); self.layout78 = nil; end;
        if self.edit75 ~= nil then self.edit75:destroy(); self.edit75 = nil; end;
        if self.edit41 ~= nil then self.edit41:destroy(); self.edit41 = nil; end;
        if self.edit92 ~= nil then self.edit92:destroy(); self.edit92 = nil; end;
        if self.label92 ~= nil then self.label92:destroy(); self.label92 = nil; end;
        if self.chkMentalTopo_1 ~= nil then self.chkMentalTopo_1:destroy(); self.chkMentalTopo_1 = nil; end;
        if self.rowConsCSExtra ~= nil then self.rowConsCSExtra:destroy(); self.rowConsCSExtra = nil; end;
        if self.button60 ~= nil then self.button60:destroy(); self.button60 = nil; end;
        if self.edit97 ~= nil then self.edit97:destroy(); self.edit97 = nil; end;
        if self.chkMentalTopo_4 ~= nil then self.chkMentalTopo_4:destroy(); self.chkMentalTopo_4 = nil; end;
        if self.edit22 ~= nil then self.edit22:destroy(); self.edit22 = nil; end;
        if self.layout72 ~= nil then self.layout72:destroy(); self.layout72 = nil; end;
        if self.rowNivel_2 ~= nil then self.rowNivel_2:destroy(); self.rowNivel_2 = nil; end;
        if self.label61 ~= nil then self.label61:destroy(); self.label61 = nil; end;
        if self.edit25 ~= nil then self.edit25:destroy(); self.edit25 = nil; end;
        if self.layout77 ~= nil then self.layout77:destroy(); self.layout77 = nil; end;
        if self.layout34 ~= nil then self.layout34:destroy(); self.layout34 = nil; end;
        if self.rowNivel_7 ~= nil then self.rowNivel_7:destroy(); self.rowNivel_7 = nil; end;
        if self.button47 ~= nil then self.button47:destroy(); self.button47 = nil; end;
        if self.rowFacanha_8 ~= nil then self.rowFacanha_8:destroy(); self.rowFacanha_8 = nil; end;
        if self.edit28 ~= nil then self.edit28:destroy(); self.edit28 = nil; end;
        if self.edit63 ~= nil then self.edit63:destroy(); self.edit63 = nil; end;
        if self.layout31 ~= nil then self.layout31:destroy(); self.layout31 = nil; end;
        if self.button42 ~= nil then self.button42:destroy(); self.button42 = nil; end;
        if self.pericia_1_nome ~= nil then self.pericia_1_nome:destroy(); self.pericia_1_nome = nil; end;
        if self.button31 ~= nil then self.button31:destroy(); self.button31 = nil; end;
        if self.pericia_3_nome ~= nil then self.pericia_3_nome:destroy(); self.pericia_3_nome = nil; end;
        if self.rowPericia_16 ~= nil then self.rowPericia_16:destroy(); self.rowPericia_16 = nil; end;
        if self.pericia_2_bonus ~= nil then self.pericia_2_bonus:destroy(); self.pericia_2_bonus = nil; end;
        if self.tab2 ~= nil then self.tab2:destroy(); self.tab2 = nil; end;
        if self.layout50 ~= nil then self.layout50:destroy(); self.layout50 = nil; end;
        if self.layout62 ~= nil then self.layout62:destroy(); self.layout62 = nil; end;
        if self.edit5 ~= nil then self.edit5:destroy(); self.edit5 = nil; end;
        if self.rowFacanha_6 ~= nil then self.rowFacanha_6:destroy(); self.rowFacanha_6 = nil; end;
        if self.button36 ~= nil then self.button36:destroy(); self.button36 = nil; end;
        if self.rowPericia_13 ~= nil then self.rowPericia_13:destroy(); self.rowPericia_13 = nil; end;
        if self.edit69 ~= nil then self.edit69:destroy(); self.edit69 = nil; end;
        if self.edit104 ~= nil then self.edit104:destroy(); self.edit104 = nil; end;
        if self.label43 ~= nil then self.label43:destroy(); self.label43 = nil; end;
        if self.layout55 ~= nil then self.layout55:destroy(); self.layout55 = nil; end;
        if self.layout16 ~= nil then self.layout16:destroy(); self.layout16 = nil; end;
        if self.label30 ~= nil then self.label30:destroy(); self.label30 = nil; end;
        if self.button1 ~= nil then self.button1:destroy(); self.button1 = nil; end;
        if self.edit39 ~= nil then self.edit39:destroy(); self.edit39 = nil; end;
        if self.pericia_7_bonus ~= nil then self.pericia_7_bonus:destroy(); self.pericia_7_bonus = nil; end;
        if self.button48 ~= nil then self.button48:destroy(); self.button48 = nil; end;
        if self.layout69 ~= nil then self.layout69:destroy(); self.layout69 = nil; end;
        if self.layout13 ~= nil then self.layout13:destroy(); self.layout13 = nil; end;
        if self.label35 ~= nil then self.label35:destroy(); self.label35 = nil; end;
        if self.button4 ~= nil then self.button4:destroy(); self.button4 = nil; end;
        if self.edit32 ~= nil then self.edit32:destroy(); self.edit32 = nil; end;
        if self.layout5 ~= nil then self.layout5:destroy(); self.layout5 = nil; end;
        if self.label49 ~= nil then self.label49:destroy(); self.label49 = nil; end;
        if self.edit18 ~= nil then self.edit18:destroy(); self.edit18 = nil; end;
        if self.label2 ~= nil then self.label2:destroy(); self.label2 = nil; end;
        if self.button13 ~= nil then self.button13:destroy(); self.button13 = nil; end;
        if self.button23 ~= nil then self.button23:destroy(); self.button23 = nil; end;
        if self.chkMental_6 ~= nil then self.chkMental_6:destroy(); self.chkMental_6 = nil; end;
        if self.edit37 ~= nil then self.edit37:destroy(); self.edit37 = nil; end;
        if self.label89 ~= nil then self.label89:destroy(); self.label89 = nil; end;
        if self.textEditor11 ~= nil then self.textEditor11:destroy(); self.textEditor11 = nil; end;
        if self.label19 ~= nil then self.label19:destroy(); self.label19 = nil; end;
        if self.layout40 ~= nil then self.layout40:destroy(); self.layout40 = nil; end;
        if self.label5 ~= nil then self.label5:destroy(); self.label5 = nil; end;
        if self.button14 ~= nil then self.button14:destroy(); self.button14 = nil; end;
        if self.button26 ~= nil then self.button26:destroy(); self.button26 = nil; end;
        if self.nivelPericia_8 ~= nil then self.nivelPericia_8:destroy(); self.nivelPericia_8 = nil; end;
        if self.button59 ~= nil then self.button59:destroy(); self.button59 = nil; end;
        if self.edit80 ~= nil then self.edit80:destroy(); self.edit80 = nil; end;
        if self.label12 ~= nil then self.label12:destroy(); self.label12 = nil; end;
        if self.label20 ~= nil then self.label20:destroy(); self.label20 = nil; end;
        if self.edit12 ~= nil then self.edit12:destroy(); self.edit12 = nil; end;
        if self.nivelPericia_3 ~= nil then self.nivelPericia_3:destroy(); self.nivelPericia_3 = nil; end;
        if self.button52 ~= nil then self.button52:destroy(); self.button52 = nil; end;
        if self.edit87 ~= nil then self.edit87:destroy(); self.edit87 = nil; end;
        if self.label87 ~= nil then self.label87:destroy(); self.label87 = nil; end;
        if self.label17 ~= nil then self.label17:destroy(); self.label17 = nil; end;
        if self.label27 ~= nil then self.label27:destroy(); self.label27 = nil; end;
        if self.edit17 ~= nil then self.edit17:destroy(); self.edit17 = nil; end;
        if self.edit54 ~= nil then self.edit54:destroy(); self.edit54 = nil; end;
        if self.label58 ~= nil then self.label58:destroy(); self.label58 = nil; end;
        if self.layout86 ~= nil then self.layout86:destroy(); self.layout86 = nil; end;
        if self.pericia_12_nome ~= nil then self.pericia_12_nome:destroy(); self.pericia_12_nome = nil; end;
        if self.label55 ~= nil then self.label55:destroy(); self.label55 = nil; end;
        if self.textEditor5 ~= nil then self.textEditor5:destroy(); self.textEditor5 = nil; end;
        if self.edit51 ~= nil then self.edit51:destroy(); self.edit51 = nil; end;
        if self.pericia_16_nome ~= nil then self.pericia_16_nome:destroy(); self.pericia_16_nome = nil; end;
        if self.layout94 ~= nil then self.layout94:destroy(); self.layout94 = nil; end;
        if self.chkFisicoTopo_7 ~= nil then self.chkFisicoTopo_7:destroy(); self.chkFisicoTopo_7 = nil; end;
        if self.scrollBox4 ~= nil then self.scrollBox4:destroy(); self.scrollBox4 = nil; end;
        if self.layout26 ~= nil then self.layout26:destroy(); self.layout26 = nil; end;
        if self.nivelPericia_12 ~= nil then self.nivelPericia_12:destroy(); self.nivelPericia_12 = nil; end;
        if self.layout81 ~= nil then self.layout81:destroy(); self.layout81 = nil; end;
        if self.button72 ~= nil then self.button72:destroy(); self.button72 = nil; end;
        if self.scrollBox3 ~= nil then self.scrollBox3:destroy(); self.scrollBox3 = nil; end;
        if self.dicaRetrato ~= nil then self.dicaRetrato:destroy(); self.dicaRetrato = nil; end;
        if self.layout91 ~= nil then self.layout91:destroy(); self.layout91 = nil; end;
        if self.textEditor8 ~= nil then self.textEditor8:destroy(); self.textEditor8 = nil; end;
        if self.rowAspecto_3 ~= nil then self.rowAspecto_3:destroy(); self.rowAspecto_3 = nil; end;
        if self.chkFisicoTopo_2 ~= nil then self.chkFisicoTopo_2:destroy(); self.chkFisicoTopo_2 = nil; end;
        if self.pericia_11_bonus ~= nil then self.pericia_11_bonus:destroy(); self.pericia_11_bonus = nil; end;
        if self.layout109 ~= nil then self.layout109:destroy(); self.layout109 = nil; end;
        if self.label74 ~= nil then self.label74:destroy(); self.label74 = nil; end;
        if self.layout102 ~= nil then self.layout102:destroy(); self.layout102 = nil; end;
        if self.chkFisico_2 ~= nil then self.chkFisico_2:destroy(); self.chkFisico_2 = nil; end;
        if self.layout28 ~= nil then self.layout28:destroy(); self.layout28 = nil; end;
        if self.label71 ~= nil then self.label71:destroy(); self.label71 = nil; end;
        if self.edit76 ~= nil then self.edit76:destroy(); self.edit76 = nil; end;
        if self.edit44 ~= nil then self.edit44:destroy(); self.edit44 = nil; end;
        if self.chkFisico_5 ~= nil then self.chkFisico_5:destroy(); self.chkFisico_5 = nil; end;
        if self.rowPericia_7 ~= nil then self.rowPericia_7:destroy(); self.rowPericia_7 = nil; end;
        if self.button67 ~= nil then self.button67:destroy(); self.button67 = nil; end;
        if self.edit94 ~= nil then self.edit94:destroy(); self.edit94 = nil; end;
        if self.edit73 ~= nil then self.edit73:destroy(); self.edit73 = nil; end;
        if self.edit43 ~= nil then self.edit43:destroy(); self.edit43 = nil; end;
        if self.label90 ~= nil then self.label90:destroy(); self.label90 = nil; end;
        if self.chkMentalTopo_3 ~= nil then self.chkMentalTopo_3:destroy(); self.chkMentalTopo_3 = nil; end;
        if self.corpoPrincipal ~= nil then self.corpoPrincipal:destroy(); self.corpoPrincipal = nil; end;
        if self.rowPericia_2 ~= nil then self.rowPericia_2:destroy(); self.rowPericia_2 = nil; end;
        if self.button62 ~= nil then self.button62:destroy(); self.button62 = nil; end;
        if self.edit99 ~= nil then self.edit99:destroy(); self.edit99 = nil; end;
        if self.chkMentalTopo_6 ~= nil then self.chkMentalTopo_6:destroy(); self.chkMentalTopo_6 = nil; end;
        if self.label64 ~= nil then self.label64:destroy(); self.label64 = nil; end;
        if self.edit20 ~= nil then self.edit20:destroy(); self.edit20 = nil; end;
        if self.rowPericia_9 ~= nil then self.rowPericia_9:destroy(); self.rowPericia_9 = nil; end;
        if self.layout39 ~= nil then self.layout39:destroy(); self.layout39 = nil; end;
        if self.rowFacanha_10 ~= nil then self.rowFacanha_10:destroy(); self.rowFacanha_10 = nil; end;
        if self.layout74 ~= nil then self.layout74:destroy(); self.layout74 = nil; end;
        if self.button69 ~= nil then self.button69:destroy(); self.button69 = nil; end;
        if self.layout112 ~= nil then self.layout112:destroy(); self.layout112 = nil; end;
        if self.rowNivel_4 ~= nil then self.rowNivel_4:destroy(); self.rowNivel_4 = nil; end;
        if self.label63 ~= nil then self.label63:destroy(); self.label63 = nil; end;
        if self.button39 ~= nil then self.button39:destroy(); self.button39 = nil; end;
        if self.layout36 ~= nil then self.layout36:destroy(); self.layout36 = nil; end;
        if self.edit66 ~= nil then self.edit66:destroy(); self.edit66 = nil; end;
        if self.button45 ~= nil then self.button45:destroy(); self.button45 = nil; end;
        if self.layout58 ~= nil then self.layout58:destroy(); self.layout58 = nil; end;
        if self.edit61 ~= nil then self.edit61:destroy(); self.edit61 = nil; end;
        if self.layout33 ~= nil then self.layout33:destroy(); self.layout33 = nil; end;
        if self.button40 ~= nil then self.button40:destroy(); self.button40 = nil; end;
        if self.layout61 ~= nil then self.layout61:destroy(); self.layout61 = nil; end;
        if self.pericia_15_bonus ~= nil then self.pericia_15_bonus:destroy(); self.pericia_15_bonus = nil; end;
        if self.button9 ~= nil then self.button9:destroy(); self.button9 = nil; end;
        if self.button33 ~= nil then self.button33:destroy(); self.button33 = nil; end;
        if self.rowPericia_10 ~= nil then self.rowPericia_10:destroy(); self.rowPericia_10 = nil; end;
        if self.label38 ~= nil then self.label38:destroy(); self.label38 = nil; end;
        if self.rowFacanha_3 ~= nil then self.rowFacanha_3:destroy(); self.rowFacanha_3 = nil; end;
        if self.edit101 ~= nil then self.edit101:destroy(); self.edit101 = nil; end;
        if self.label46 ~= nil then self.label46:destroy(); self.label46 = nil; end;
        if self.layout56 ~= nil then self.layout56:destroy(); self.layout56 = nil; end;
        if self.layout64 ~= nil then self.layout64:destroy(); self.layout64 = nil; end;
        if self.edit7 ~= nil then self.edit7:destroy(); self.edit7 = nil; end;
        if self.rowFacanha_4 ~= nil then self.rowFacanha_4:destroy(); self.rowFacanha_4 = nil; end;
        if self.pericia_10_nome ~= nil then self.pericia_10_nome:destroy(); self.pericia_10_nome = nil; end;
        if self.edit106 ~= nil then self.edit106:destroy(); self.edit106 = nil; end;
        if self.label41 ~= nil then self.label41:destroy(); self.label41 = nil; end;
        if self.layout14 ~= nil then self.layout14:destroy(); self.layout14 = nil; end;
        if self.label32 ~= nil then self.label32:destroy(); self.label32 = nil; end;
        if self.button7 ~= nil then self.button7:destroy(); self.button7 = nil; end;
        if self.layout8 ~= nil then self.layout8:destroy(); self.layout8 = nil; end;
        if self.layout11 ~= nil then self.layout11:destroy(); self.layout11 = nil; end;
        if self.label37 ~= nil then self.label37:destroy(); self.label37 = nil; end;
        if self.chkMental_5 ~= nil then self.chkMental_5:destroy(); self.chkMental_5 = nil; end;
        if self.edit30 ~= nil then self.edit30:destroy(); self.edit30 = nil; end;
        if self.edit88 ~= nil then self.edit88:destroy(); self.edit88 = nil; end;
        if self.layout3 ~= nil then self.layout3:destroy(); self.layout3 = nil; end;
        if self.layout43 ~= nil then self.layout43:destroy(); self.layout43 = nil; end;
        if self.button11 ~= nil then self.button11:destroy(); self.button11 = nil; end;
        if self.button25 ~= nil then self.button25:destroy(); self.button25 = nil; end;
        if self.edit35 ~= nil then self.edit35:destroy(); self.edit35 = nil; end;
        if self.textEditor13 ~= nil then self.textEditor13:destroy(); self.textEditor13 = nil; end;
        if self.layout46 ~= nil then self.layout46:destroy(); self.layout46 = nil; end;
        if self.button28 ~= nil then self.button28:destroy(); self.button28 = nil; end;
        if self.nivelPericia_6 ~= nil then self.nivelPericia_6:destroy(); self.nivelPericia_6 = nil; end;
        if self.button57 ~= nil then self.button57:destroy(); self.button57 = nil; end;
        if self.edit82 ~= nil then self.edit82:destroy(); self.edit82 = nil; end;
        if self.label82 ~= nil then self.label82:destroy(); self.label82 = nil; end;
        if self.label10 ~= nil then self.label10:destroy(); self.label10 = nil; end;
        if self.label22 ~= nil then self.label22:destroy(); self.label22 = nil; end;
        if self.edit14 ~= nil then self.edit14:destroy(); self.edit14 = nil; end;
        if self.layout49 ~= nil then self.layout49:destroy(); self.layout49 = nil; end;
        if self.nivelPericia_1 ~= nil then self.nivelPericia_1:destroy(); self.nivelPericia_1 = nil; end;
        if self.edit59 ~= nil then self.edit59:destroy(); self.edit59 = nil; end;
        if self.button50 ~= nil then self.button50:destroy(); self.button50 = nil; end;
        if self.label85 ~= nil then self.label85:destroy(); self.label85 = nil; end;
        if self.pericia_13_nome ~= nil then self.pericia_13_nome:destroy(); self.pericia_13_nome = nil; end;
        if self.layout89 ~= nil then self.layout89:destroy(); self.layout89 = nil; end;
        if self.label15 ~= nil then self.label15:destroy(); self.label15 = nil; end;
        if self.label29 ~= nil then self.label29:destroy(); self.label29 = nil; end;
        if self.label56 ~= nil then self.label56:destroy(); self.label56 = nil; end;
        if self.edit56 ~= nil then self.edit56:destroy(); self.edit56 = nil; end;
        if self.layout25 ~= nil then self.layout25:destroy(); self.layout25 = nil; end;
        if self.listaPericiasFacanhas ~= nil then self.listaPericiasFacanhas:destroy(); self.listaPericiasFacanhas = nil; end;
        if self.rowExtraD_5 ~= nil then self.rowExtraD_5:destroy(); self.rowExtraD_5 = nil; end;
        if self.layout84 ~= nil then self.layout84:destroy(); self.layout84 = nil; end;
        if self.rectangle1 ~= nil then self.rectangle1:destroy(); self.rectangle1 = nil; end;
        if self.label53 ~= nil then self.label53:destroy(); self.label53 = nil; end;
        if self.edit53 ~= nil then self.edit53:destroy(); self.edit53 = nil; end;
        if self.layout92 ~= nil then self.layout92:destroy(); self.layout92 = nil; end;
        if self.rowAspecto_6 ~= nil then self.rowAspecto_6:destroy(); self.rowAspecto_6 = nil; end;
        if self.chkFisicoTopo_5 ~= nil then self.chkFisicoTopo_5:destroy(); self.chkFisicoTopo_5 = nil; end;
        if self.pericia_16_bonus ~= nil then self.pericia_16_bonus:destroy(); self.pericia_16_bonus = nil; end;
        if self.textEditor7 ~= nil then self.textEditor7:destroy(); self.textEditor7 = nil; end;
        if self.layout20 ~= nil then self.layout20:destroy(); self.layout20 = nil; end;
        if self.pericia_3_bonus ~= nil then self.pericia_3_bonus:destroy(); self.pericia_3_bonus = nil; end;
        if self.nivelPericia_10 ~= nil then self.nivelPericia_10:destroy(); self.nivelPericia_10 = nil; end;
        if self.label79 ~= nil then self.label79:destroy(); self.label79 = nil; end;
        if self.layout107 ~= nil then self.layout107:destroy(); self.layout107 = nil; end;
        if self.rowAspecto_1 ~= nil then self.rowAspecto_1:destroy(); self.rowAspecto_1 = nil; end;
        if self.label76 ~= nil then self.label76:destroy(); self.label76 = nil; end;
        if self.layout98 ~= nil then self.layout98:destroy(); self.layout98 = nil; end;
        if self.layout100 ~= nil then self.layout100:destroy(); self.layout100 = nil; end;
        if self.label73 ~= nil then self.label73:destroy(); self.label73 = nil; end;
        if self.edit91 ~= nil then self.edit91:destroy(); self.edit91 = nil; end;
        if self.edit74 ~= nil then self.edit74:destroy(); self.edit74 = nil; end;
        if self.edit46 ~= nil then self.edit46:destroy(); self.edit46 = nil; end;
        if self.rowPericia_1 ~= nil then self.rowPericia_1:destroy(); self.rowPericia_1 = nil; end;
        if self.pericia_14_nome ~= nil then self.pericia_14_nome:destroy(); self.pericia_14_nome = nil; end;
        if self.button61 ~= nil then self.button61:destroy(); self.button61 = nil; end;
        if self.edit71 ~= nil then self.edit71:destroy(); self.edit71 = nil; end;
        if self.edit96 ~= nil then self.edit96:destroy(); self.edit96 = nil; end;
        if self.chkMentalTopo_5 ~= nil then self.chkMentalTopo_5:destroy(); self.chkMentalTopo_5 = nil; end;
        if self.edit23 ~= nil then self.edit23:destroy(); self.edit23 = nil; end;
        if self.layout71 ~= nil then self.layout71:destroy(); self.layout71 = nil; end;
        if self.edit48 ~= nil then self.edit48:destroy(); self.edit48 = nil; end;
        if self.rowConsCSExtraTopo ~= nil then self.rowConsCSExtraTopo:destroy(); self.rowConsCSExtraTopo = nil; end;
        if self.rowNivel_1 ~= nil then self.rowNivel_1:destroy(); self.rowNivel_1 = nil; end;
        if self.label66 ~= nil then self.label66:destroy(); self.label66 = nil; end;
        if self.edit26 ~= nil then self.edit26:destroy(); self.edit26 = nil; end;
        if self.layout76 ~= nil then self.layout76:destroy(); self.layout76 = nil; end;
        if self.layout110 ~= nil then self.layout110:destroy(); self.layout110 = nil; end;
        if self.rowNivel_6 ~= nil then self.rowNivel_6:destroy(); self.rowNivel_6 = nil; end;
        if self.pericia_7_nome ~= nil then self.pericia_7_nome:destroy(); self.pericia_7_nome = nil; end;
        if self.edit8 ~= nil then self.edit8:destroy(); self.edit8 = nil; end;
        if self.edit29 ~= nil then self.edit29:destroy(); self.edit29 = nil; end;
        if self.edit64 ~= nil then self.edit64:destroy(); self.edit64 = nil; end;
        if self.layout30 ~= nil then self.layout30:destroy(); self.layout30 = nil; end;
        if self.edit109 ~= nil then self.edit109:destroy(); self.edit109 = nil; end;
        if self.button43 ~= nil then self.button43:destroy(); self.button43 = nil; end;
        if self.label68 ~= nil then self.label68:destroy(); self.label68 = nil; end;
        if self.button30 ~= nil then self.button30:destroy(); self.button30 = nil; end;
        if self.rowPericia_15 ~= nil then self.rowPericia_15:destroy(); self.rowPericia_15 = nil; end;
        if self.layout53 ~= nil then self.layout53:destroy(); self.layout53 = nil; end;
        if self.layout63 ~= nil then self.layout63:destroy(); self.layout63 = nil; end;
        if self.edit2 ~= nil then self.edit2:destroy(); self.edit2 = nil; end;
        if self.rowFacanha_1 ~= nil then self.rowFacanha_1:destroy(); self.rowFacanha_1 = nil; end;
        if self.button35 ~= nil then self.button35:destroy(); self.button35 = nil; end;
        if self.rowPericia_12 ~= nil then self.rowPericia_12:destroy(); self.rowPericia_12 = nil; end;
        if self.edit103 ~= nil then self.edit103:destroy(); self.edit103 = nil; end;
        if self.pericia_5_bonus ~= nil then self.pericia_5_bonus:destroy(); self.pericia_5_bonus = nil; end;
        if self.label44 ~= nil then self.label44:destroy(); self.label44 = nil; end;
        if self.layout54 ~= nil then self.layout54:destroy(); self.layout54 = nil; end;
        if self.layout19 ~= nil then self.layout19:destroy(); self.layout19 = nil; end;
        if self.button49 ~= nil then self.button49:destroy(); self.button49 = nil; end;
        if self.button2 ~= nil then self.button2:destroy(); self.button2 = nil; end;
        if self.edit38 ~= nil then self.edit38:destroy(); self.edit38 = nil; end;
        if self.layout66 ~= nil then self.layout66:destroy(); self.layout66 = nil; end;
        if self.pericia_8_nome ~= nil then self.pericia_8_nome:destroy(); self.pericia_8_nome = nil; end;
        if self.label8 ~= nil then self.label8:destroy(); self.label8 = nil; end;
        if self.layout12 ~= nil then self.layout12:destroy(); self.layout12 = nil; end;
        if self.button19 ~= nil then self.button19:destroy(); self.button19 = nil; end;
        if self.button5 ~= nil then self.button5:destroy(); self.button5 = nil; end;
        if self.label34 ~= nil then self.label34:destroy(); self.label34 = nil; end;
        if self.chkMental_8 ~= nil then self.chkMental_8:destroy(); self.chkMental_8 = nil; end;
        if self.layout6 ~= nil then self.layout6:destroy(); self.layout6 = nil; end;
        if self.pericia_2_nome ~= nil then self.pericia_2_nome:destroy(); self.pericia_2_nome = nil; end;
        if self.label3 ~= nil then self.label3:destroy(); self.label3 = nil; end;
        if self.button12 ~= nil then self.button12:destroy(); self.button12 = nil; end;
        if self.button20 ~= nil then self.button20:destroy(); self.button20 = nil; end;
        if self.chkMental_7 ~= nil then self.chkMental_7:destroy(); self.chkMental_7 = nil; end;
        if self.edit36 ~= nil then self.edit36:destroy(); self.edit36 = nil; end;
        if self.layout1 ~= nil then self.layout1:destroy(); self.layout1 = nil; end;
        if self.textEditor10 ~= nil then self.textEditor10:destroy(); self.textEditor10 = nil; end;
        if self.label18 ~= nil then self.label18:destroy(); self.label18 = nil; end;
        if self.layout41 ~= nil then self.layout41:destroy(); self.layout41 = nil; end;
        if self.label6 ~= nil then self.label6:destroy(); self.label6 = nil; end;
        if self.button17 ~= nil then self.button17:destroy(); self.button17 = nil; end;
        if self.button27 ~= nil then self.button27:destroy(); self.button27 = nil; end;
        if self.nivelPericia_9 ~= nil then self.nivelPericia_9:destroy(); self.nivelPericia_9 = nil; end;
        if self.button58 ~= nil then self.button58:destroy(); self.button58 = nil; end;
        if self.chkMental_2 ~= nil then self.chkMental_2:destroy(); self.chkMental_2 = nil; end;
        if self.edit81 ~= nil then self.edit81:destroy(); self.edit81 = nil; end;
        if self.pericia_12_bonus ~= nil then self.pericia_12_bonus:destroy(); self.pericia_12_bonus = nil; end;
        if self.layout44 ~= nil then self.layout44:destroy(); self.layout44 = nil; end;
        if self.label21 ~= nil then self.label21:destroy(); self.label21 = nil; end;
        if self.edit11 ~= nil then self.edit11:destroy(); self.edit11 = nil; end;
        if self.nivelPericia_4 ~= nil then self.nivelPericia_4:destroy(); self.nivelPericia_4 = nil; end;
        if self.button55 ~= nil then self.button55:destroy(); self.button55 = nil; end;
        if self.edit84 ~= nil then self.edit84:destroy(); self.edit84 = nil; end;
        if self.label80 ~= nil then self.label80:destroy(); self.label80 = nil; end;
        if self.label16 ~= nil then self.label16:destroy(); self.label16 = nil; end;
        if self.label24 ~= nil then self.label24:destroy(); self.label24 = nil; end;
        if self.edit16 ~= nil then self.edit16:destroy(); self.edit16 = nil; end;
        if self.rowExtraD_6 ~= nil then self.rowExtraD_6:destroy(); self.rowExtraD_6 = nil; end;
        if self.layout87 ~= nil then self.layout87:destroy(); self.layout87 = nil; end;
        if self.label54 ~= nil then self.label54:destroy(); self.label54 = nil; end;
        if self.textEditor2 ~= nil then self.textEditor2:destroy(); self.textEditor2 = nil; end;
        if self.edit50 ~= nil then self.edit50:destroy(); self.edit50 = nil; end;
        if self.layout97 ~= nil then self.layout97:destroy(); self.layout97 = nil; end;
        if self.chkFisicoTopo_8 ~= nil then self.chkFisicoTopo_8:destroy(); self.chkFisicoTopo_8 = nil; end;
        if self.layout27 ~= nil then self.layout27:destroy(); self.layout27 = nil; end;
        if self.nivelPericia_15 ~= nil then self.nivelPericia_15:destroy(); self.nivelPericia_15 = nil; end;
        if self.pericia_5_nome ~= nil then self.pericia_5_nome:destroy(); self.pericia_5_nome = nil; end;
        if self.rowExtraD_3 ~= nil then self.rowExtraD_3:destroy(); self.rowExtraD_3 = nil; end;
        if self.layout82 ~= nil then self.layout82:destroy(); self.layout82 = nil; end;
        if self.label51 ~= nil then self.label51:destroy(); self.label51 = nil; end;
        if self.button71 ~= nil then self.button71:destroy(); self.button71 = nil; end;
        if self.layout90 ~= nil then self.layout90:destroy(); self.layout90 = nil; end;
        if self.textEditor9 ~= nil then self.textEditor9:destroy(); self.textEditor9 = nil; end;
        if self.rowAspecto_4 ~= nil then self.rowAspecto_4:destroy(); self.rowAspecto_4 = nil; end;
        if self.chkFisicoTopo_3 ~= nil then self.chkFisicoTopo_3:destroy(); self.chkFisicoTopo_3 = nil; end;
        if self.chkFisico_8 ~= nil then self.chkFisico_8:destroy(); self.chkFisico_8 = nil; end;
        if self.layout108 ~= nil then self.layout108:destroy(); self.layout108 = nil; end;
        if self.layout22 ~= nil then self.layout22:destroy(); self.layout22 = nil; end;
        if self.layout105 ~= nil then self.layout105:destroy(); self.layout105 = nil; end;
        if self.chkFisico_3 ~= nil then self.chkFisico_3:destroy(); self.chkFisico_3 = nil; end;
        if self.edit110 ~= nil then self.edit110:destroy(); self.edit110 = nil; end;
        if self.layout29 ~= nil then self.layout29:destroy(); self.layout29 = nil; end;
        if self.label70 ~= nil then self.label70:destroy(); self.label70 = nil; end;
        if self.edit79 ~= nil then self.edit79:destroy(); self.edit79 = nil; end;
        if self.edit45 ~= nil then self.edit45:destroy(); self.edit45 = nil; end;
        if self.chkFisico_6 ~= nil then self.chkFisico_6:destroy(); self.chkFisico_6 = nil; end;
        if self.rowPericia_4 ~= nil then self.rowPericia_4:destroy(); self.rowPericia_4 = nil; end;
        if self.button64 ~= nil then self.button64:destroy(); self.button64 = nil; end;
        if self.layout79 ~= nil then self.layout79:destroy(); self.layout79 = nil; end;
        if self.edit72 ~= nil then self.edit72:destroy(); self.edit72 = nil; end;
        if self.edit40 ~= nil then self.edit40:destroy(); self.edit40 = nil; end;
        if self.edit93 ~= nil then self.edit93:destroy(); self.edit93 = nil; end;
        if self.label93 ~= nil then self.label93:destroy(); self.label93 = nil; end;
        if self.pericia_9_bonus ~= nil then self.pericia_9_bonus:destroy(); self.pericia_9_bonus = nil; end;
        if self.rowPericia_3 ~= nil then self.rowPericia_3:destroy(); self.rowPericia_3 = nil; end;
        if self.button63 ~= nil then self.button63:destroy(); self.button63 = nil; end;
        if self.edit98 ~= nil then self.edit98:destroy(); self.edit98 = nil; end;
        if self.label94 ~= nil then self.label94:destroy(); self.label94 = nil; end;
        if self.pericia_8_bonus ~= nil then self.pericia_8_bonus:destroy(); self.pericia_8_bonus = nil; end;
        if self.chkMentalTopo_7 ~= nil then self.chkMentalTopo_7:destroy(); self.chkMentalTopo_7 = nil; end;
        if self.label65 ~= nil then self.label65:destroy(); self.label65 = nil; end;
        if self.edit21 ~= nil then self.edit21:destroy(); self.edit21 = nil; end;
        if self.layout73 ~= nil then self.layout73:destroy(); self.layout73 = nil; end;
        if self.layout38 ~= nil then self.layout38:destroy(); self.layout38 = nil; end;
        if self.layout113 ~= nil then self.layout113:destroy(); self.layout113 = nil; end;
        if self.pericia_6_nome ~= nil then self.pericia_6_nome:destroy(); self.pericia_6_nome = nil; end;
        if self.tcMain ~= nil then self.tcMain:destroy(); self.tcMain = nil; end;
        if self.rowNivel_3 ~= nil then self.rowNivel_3:destroy(); self.rowNivel_3 = nil; end;
        if self.label60 ~= nil then self.label60:destroy(); self.label60 = nil; end;
        if self.edit24 ~= nil then self.edit24:destroy(); self.edit24 = nil; end;
        if self.button38 ~= nil then self.button38:destroy(); self.button38 = nil; end;
        if self.layout35 ~= nil then self.layout35:destroy(); self.layout35 = nil; end;
        if self.edit67 ~= nil then self.edit67:destroy(); self.edit67 = nil; end;
        if self.rowNivel_8 ~= nil then self.rowNivel_8:destroy(); self.rowNivel_8 = nil; end;
        if self.button46 ~= nil then self.button46:destroy(); self.button46 = nil; end;
        if self.rowFacanha_9 ~= nil then self.rowFacanha_9:destroy(); self.rowFacanha_9 = nil; end;
        if self.edit62 ~= nil then self.edit62:destroy(); self.edit62 = nil; end;
        if self.layout32 ~= nil then self.layout32:destroy(); self.layout32 = nil; end;
        if self.button41 ~= nil then self.button41:destroy(); self.button41 = nil; end;
        if self.edit1 ~= nil then self.edit1:destroy(); self.edit1 = nil; end;
        if self.rowFacanha_2 ~= nil then self.rowFacanha_2:destroy(); self.rowFacanha_2 = nil; end;
        if self.button32 ~= nil then self.button32:destroy(); self.button32 = nil; end;
        if self.edit100 ~= nil then self.edit100:destroy(); self.edit100 = nil; end;
        if self.pericia_10_bonus ~= nil then self.pericia_10_bonus:destroy(); self.pericia_10_bonus = nil; end;
        if self.label47 ~= nil then self.label47:destroy(); self.label47 = nil; end;
        if self.tab3 ~= nil then self.tab3:destroy(); self.tab3 = nil; end;
        if self.layout51 ~= nil then self.layout51:destroy(); self.layout51 = nil; end;
        if self.layout65 ~= nil then self.layout65:destroy(); self.layout65 = nil; end;
        if self.edit4 ~= nil then self.edit4:destroy(); self.edit4 = nil; end;
        if self.rowFacanha_7 ~= nil then self.rowFacanha_7:destroy(); self.rowFacanha_7 = nil; end;
        if self.button37 ~= nil then self.button37:destroy(); self.button37 = nil; end;
        if self.edit68 ~= nil then self.edit68:destroy(); self.edit68 = nil; end;
        if self.edit105 ~= nil then self.edit105:destroy(); self.edit105 = nil; end;
        if self.label42 ~= nil then self.label42:destroy(); self.label42 = nil; end;
        if self.tab4 ~= nil then self.tab4:destroy(); self.tab4 = nil; end;
        if self.layout17 ~= nil then self.layout17:destroy(); self.layout17 = nil; end;
        if self.label31 ~= nil then self.label31:destroy(); self.label31 = nil; end;
        if self.layout68 ~= nil then self.layout68:destroy(); self.layout68 = nil; end;
        if self.layout9 ~= nil then self.layout9:destroy(); self.layout9 = nil; end;
        if self.layout10 ~= nil then self.layout10:destroy(); self.layout10 = nil; end;
        if self.label36 ~= nil then self.label36:destroy(); self.label36 = nil; end;
        if self.edit89 ~= nil then self.edit89:destroy(); self.edit89 = nil; end;
        if self.edit33 ~= nil then self.edit33:destroy(); self.edit33 = nil; end;
        if self.layout4 ~= nil then self.layout4:destroy(); self.layout4 = nil; end;
        if self.label48 ~= nil then self.label48:destroy(); self.label48 = nil; end;
        if self.edit19 ~= nil then self.edit19:destroy(); self.edit19 = nil; end;
        if self.label1 ~= nil then self.label1:destroy(); self.label1 = nil; end;
        if self.button10 ~= nil then self.button10:destroy(); self.button10 = nil; end;
        if self.button22 ~= nil then self.button22:destroy(); self.button22 = nil; end;
        if self.chkMental_1 ~= nil then self.chkMental_1:destroy(); self.chkMental_1 = nil; end;
        if self.edit34 ~= nil then self.edit34:destroy(); self.edit34 = nil; end;
        if self.label88 ~= nil then self.label88:destroy(); self.label88 = nil; end;
        if self.textEditor12 ~= nil then self.textEditor12:destroy(); self.textEditor12 = nil; end;
        if self.layout47 ~= nil then self.layout47:destroy(); self.layout47 = nil; end;
        if self.label4 ~= nil then self.label4:destroy(); self.label4 = nil; end;
        if self.button15 ~= nil then self.button15:destroy(); self.button15 = nil; end;
        if self.button29 ~= nil then self.button29:destroy(); self.button29 = nil; end;
        if self.nivelPericia_7 ~= nil then self.nivelPericia_7:destroy(); self.nivelPericia_7 = nil; end;
        if self.pericia_13_bonus ~= nil then self.pericia_13_bonus:destroy(); self.pericia_13_bonus = nil; end;
        if self.button56 ~= nil then self.button56:destroy(); self.button56 = nil; end;
        if self.edit83 ~= nil then self.edit83:destroy(); self.edit83 = nil; end;
        if self.label83 ~= nil then self.label83:destroy(); self.label83 = nil; end;
        if self.label13 ~= nil then self.label13:destroy(); self.label13 = nil; end;
        if self.label23 ~= nil then self.label23:destroy(); self.label23 = nil; end;
        if self.edit13 ~= nil then self.edit13:destroy(); self.edit13 = nil; end;
        if self.pericia_4_bonus ~= nil then self.pericia_4_bonus:destroy(); self.pericia_4_bonus = nil; end;
        if self.nivelPericia_2 ~= nil then self.nivelPericia_2:destroy(); self.nivelPericia_2 = nil; end;
        if self.edit58 ~= nil then self.edit58:destroy(); self.edit58 = nil; end;
        if self.button53 ~= nil then self.button53:destroy(); self.button53 = nil; end;
        if self.edit86 ~= nil then self.edit86:destroy(); self.edit86 = nil; end;
        if self.label86 ~= nil then self.label86:destroy(); self.label86 = nil; end;
        if self.label14 ~= nil then self.label14:destroy(); self.label14 = nil; end;
        if self.label26 ~= nil then self.label26:destroy(); self.label26 = nil; end;
        if self.textEditor1 ~= nil then self.textEditor1:destroy(); self.textEditor1 = nil; end;
        if self.edit55 ~= nil then self.edit55:destroy(); self.edit55 = nil; end;
        if self.label59 ~= nil then self.label59:destroy(); self.label59 = nil; end;
        if self.nivelPericia_16 ~= nil then self.nivelPericia_16:destroy(); self.nivelPericia_16 = nil; end;
        if self.rowExtraD_4 ~= nil then self.rowExtraD_4:destroy(); self.rowExtraD_4 = nil; end;
        if self.layout85 ~= nil then self.layout85:destroy(); self.layout85 = nil; end;
        if self.label52 ~= nil then self.label52:destroy(); self.label52 = nil; end;
        if self.textEditor4 ~= nil then self.textEditor4:destroy(); self.textEditor4 = nil; end;
        if self.edit52 ~= nil then self.edit52:destroy(); self.edit52 = nil; end;
        if self.layout95 ~= nil then self.layout95:destroy(); self.layout95 = nil; end;
        if self.rowAspecto_7 ~= nil then self.rowAspecto_7:destroy(); self.rowAspecto_7 = nil; end;
        if self.chkFisicoTopo_6 ~= nil then self.chkFisicoTopo_6:destroy(); self.chkFisicoTopo_6 = nil; end;
        if self.layout21 ~= nil then self.layout21:destroy(); self.layout21 = nil; end;
        if self.nivelPericia_13 ~= nil then self.nivelPericia_13:destroy(); self.nivelPericia_13 = nil; end;
        if self.label78 ~= nil then self.label78:destroy(); self.label78 = nil; end;
        if self.scrollBox2 ~= nil then self.scrollBox2:destroy(); self.scrollBox2 = nil; end;
        if self.rowExtraD_1 ~= nil then self.rowExtraD_1:destroy(); self.rowExtraD_1 = nil; end;
        if self.layout80 ~= nil then self.layout80:destroy(); self.layout80 = nil; end;
        if self.button73 ~= nil then self.button73:destroy(); self.button73 = nil; end;
        if self.layout106 ~= nil then self.layout106:destroy(); self.layout106 = nil; end;
        if self.rowAspecto_2 ~= nil then self.rowAspecto_2:destroy(); self.rowAspecto_2 = nil; end;
        if self.chkFisicoTopo_1 ~= nil then self.chkFisicoTopo_1:destroy(); self.chkFisicoTopo_1 = nil; end;
        if self.label75 ~= nil then self.label75:destroy(); self.label75 = nil; end;
        if self.pericia_6_bonus ~= nil then self.pericia_6_bonus:destroy(); self.pericia_6_bonus = nil; end;
        if self.layout103 ~= nil then self.layout103:destroy(); self.layout103 = nil; end;
        if self.chkMentalTopo_8 ~= nil then self.chkMentalTopo_8:destroy(); self.chkMentalTopo_8 = nil; end;
        if self.chkFisico_1 ~= nil then self.chkFisico_1:destroy(); self.chkFisico_1 = nil; end;
        if self.label72 ~= nil then self.label72:destroy(); self.label72 = nil; end;
        self:_oldLFMDestroy();
    end;

    obj:endUpdate();

    return obj;
end;

function newfrmFateCore()
    local retObj = nil;
    __o_rrpgObjs.beginObjectsLoading();

    __o_Utils.tryFinally(
      function()
        retObj = constructNew_frmFateCore();
      end,
      function()
        __o_rrpgObjs.endObjectsLoading();
      end);

    assert(retObj ~= nil);
    return retObj;
end;

local _frmFateCore = {
    newEditor = newfrmFateCore, 
    new = newfrmFateCore, 
    name = "frmFateCore", 
    dataType = "br.GodsCorpse.FateCore", 
    formType = "sheetTemplate", 
    formComponentName = "form", 
    cacheMode = "none", 
    title = "Fate Core", 
    description=""};

frmFateCore = _frmFateCore;
Firecast.registrarForm(_frmFateCore);
Firecast.registrarDataType(_frmFateCore);

return _frmFateCore;
