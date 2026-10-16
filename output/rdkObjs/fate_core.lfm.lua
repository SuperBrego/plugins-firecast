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

        -- ── Constantes de configuração padrão ────────────────────────
        local DEFAULT_ESCADA_MAX  = 5   -- topo da escada (+5)
        local DEFAULT_ESCADA_MIN  = 1   -- base (+1)
        local DEFAULT_ASPECTOS    = 3   -- aspectos livres
        local DEFAULT_FACANHAS    = 6   -- linhas de façanhas
        local DEFAULT_EXTRAS_L    = 6   -- linhas de extras (lista)
        local DEFAULT_FISICO      = 4   -- caixas de estresse físico (total)
        local DEFAULT_MENTAL      = 4   -- caixas de estresse mental (total)
        local DEFAULT_CSE         = true -- consequência suave extra

        -- Nomes dos níveis da escada (índice = bônus)
        local NIVEL = {
            [0] = "Medíocre",
            [1] = "Regular",
            [2] = "Razoável",
            [3] = "Bom",
            [4] = "Ótimo",
            [5] = "Excepcional",
            [6] = "Fantástico",
            [7] = "Épico",
            [8] = "Lendário",
        }

        -- ── Rolagem de dado Fate ─────────────────────────────────────

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
            async(function()
                await(room.chat:asyncRoll(expr, msg))
            end)
        end

        -- ── Atualiza a escada de perícias dinamicamente ───────────────

        local function atualizarEscada()
            local node    = sheet
            local maxNiv  = tonumber(node and node.cfg_escadaMax) or DEFAULT_ESCADA_MAX
            local minNiv  = tonumber(node and node.cfg_escadaMin) or DEFAULT_ESCADA_MIN

            -- Mostra/oculta linhas da escada conforme configuração
            for nivel = 0, 8 do
                local visivel = (nivel >= minNiv and nivel <= maxNiv)
                local row = self["rowNivel_" .. nivel]
                if row then row.visible = visivel end
            end
        end

        -- ── Atualiza caixas de estresse ───────────────────────────────

        local function atualizarEstresse()
            local node    = sheet
            local fisico  = tonumber(node and node.cfg_fisico)  or DEFAULT_FISICO
            local mental  = tonumber(node and node.cfg_mental)  or DEFAULT_MENTAL

            for i = 1, 8 do
                local chkF = self["chkFisico_" .. i]
                local chkM = self["chkMental_" .. i]
                if chkF then
                    chkF.visible = (i <= fisico)
                end
                if chkM then
                    chkM.visible = (i <= mental)
                end
            end
        end

        -- ── Atualiza consequência suave extra ─────────────────────────

        local function atualizarConsequencias()
            local node = sheet
            local cse  = (node and node.cfg_cse) == true
            local rowCSE = self["rowConsCSExtra"]
            if rowCSE then rowCSE.visible = cse end
        end

        -- ── Atualiza linhas de façanhas ───────────────────────────────

        local function atualizarFacanhas()
            local node = sheet
            local n    = tonumber(node and node.cfg_facanhas) or DEFAULT_FACANHAS
            for i = 1, 10 do
                local row = self["rowFacanha_" .. i]
                if row then row.visible = (i <= n) end
            end
        end

        -- ── Atualiza linhas de extras (lista) ────────────────────────

        local function atualizarExtrasLista()
            local node = sheet
            local n    = tonumber(node and node.cfg_extrasL) or DEFAULT_EXTRAS_L
            for i = 1, 10 do
                local row = self["rowExtraL_" .. i]
                if row then row.visible = (i <= n) end
            end
        end

        -- ── Atualiza aspectos livres ──────────────────────────────────

        local function atualizarAspectos()
            local node = sheet
            local n    = tonumber(node and node.cfg_aspectos) or DEFAULT_ASPECTOS
            for i = 1, 7 do
                local row = self["rowAspecto_" .. i]
                if row then row.visible = (i <= n) end
            end
        end

        -- ── Aplica todas as configurações ─────────────────────────────

        local function aplicarConfig()
            atualizarEscada()
            atualizarEstresse()
            atualizarConsequencias()
            atualizarFacanhas()
            atualizarExtrasLista()
            atualizarAspectos()
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
    obj.layout1:setAlign("client");
    obj.layout1:setMargins({left=10, right=10, top=10, bottom=10});
    obj.layout1:setName("layout1");

    obj.layout2 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout2:setParent(obj.layout1);
    obj.layout2:setAlign("top");
    obj.layout2:setHeight(52);
    obj.layout2:setMargins({bottom=8});
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
    obj.label1:setHeight(14);
    obj.label1:setFontSize(8);
    obj.label1:setFontColor("Gray");
    lfm_setPropAsString(obj.label1, "fontStyle", "bold");
    obj.label1:setName("label1");

    obj.edit1 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit1:setParent(obj.layout3);
    obj.edit1:setAlign("client");
    obj.edit1:setField("nome");
    obj.edit1:setFontSize(13);
    obj.edit1:setName("edit1");

    obj.layout4 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout4:setParent(obj.layout2);
    obj.layout4:setAlign("right");
    obj.layout4:setWidth(160);
    obj.layout4:setName("layout4");

    obj.layout5 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout5:setParent(obj.layout4);
    obj.layout5:setAlign("client");
    obj.layout5:setMargins({right=8});
    obj.layout5:setName("layout5");

    obj.label2 = GUI.fromHandle(_obj_newObject("label"));
    obj.label2:setParent(obj.layout5);
    obj.label2:setText("Jogador");
    obj.label2:setAlign("top");
    obj.label2:setHeight(14);
    obj.label2:setFontSize(8);
    obj.label2:setFontColor("Gray");
    lfm_setPropAsString(obj.label2, "fontStyle", "bold");
    obj.label2:setName("label2");

    obj.edit2 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit2:setParent(obj.layout5);
    obj.edit2:setAlign("client");
    obj.edit2:setField("jogador");
    obj.edit2:setFontSize(11);
    obj.edit2:setName("edit2");

    obj.layout6 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout6:setParent(obj.layout4);
    obj.layout6:setAlign("right");
    obj.layout6:setWidth(72);
    obj.layout6:setName("layout6");

    obj.layout7 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout7:setParent(obj.layout6);
    obj.layout7:setAlign("left");
    obj.layout7:setWidth(34);
    obj.layout7:setMargins({right=4});
    obj.layout7:setName("layout7");

    obj.label3 = GUI.fromHandle(_obj_newObject("label"));
    obj.label3:setParent(obj.layout7);
    obj.label3:setText("Recarga");
    obj.label3:setAlign("top");
    obj.label3:setHeight(14);
    obj.label3:setFontSize(7);
    obj.label3:setFontColor("Gray");
    lfm_setPropAsString(obj.label3, "fontStyle", "bold");
    obj.label3:setName("label3");

    obj.edit3 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit3:setParent(obj.layout7);
    obj.edit3:setAlign("client");
    obj.edit3:setField("recarga");
    obj.edit3:setHorzTextAlign("center");
    obj.edit3:setFontSize(13);
    obj.edit3:setName("edit3");

    obj.layout8 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout8:setParent(obj.layout6);
    obj.layout8:setAlign("client");
    obj.layout8:setName("layout8");

    obj.label4 = GUI.fromHandle(_obj_newObject("label"));
    obj.label4:setParent(obj.layout8);
    obj.label4:setText("P. Destino");
    obj.label4:setAlign("top");
    obj.label4:setHeight(14);
    obj.label4:setFontSize(7);
    obj.label4:setFontColor("Gray");
    lfm_setPropAsString(obj.label4, "fontStyle", "bold");
    obj.label4:setName("label4");

    obj.edit4 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit4:setParent(obj.layout8);
    obj.edit4:setAlign("client");
    obj.edit4:setField("pontosDestino");
    obj.edit4:setHorzTextAlign("center");
    obj.edit4:setFontSize(13);
    obj.edit4:setName("edit4");

    obj.layout9 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout9:setParent(obj.layout1);
    obj.layout9:setAlign("top");
    obj.layout9:setHeight(340);
    obj.layout9:setMargins({bottom=8});
    obj.layout9:setName("layout9");

    obj.layout10 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout10:setParent(obj.layout9);
    obj.layout10:setAlign("left");
    obj.layout10:setWidth(260);
    obj.layout10:setMargins({right=8});
    obj.layout10:setName("layout10");

    obj.label5 = GUI.fromHandle(_obj_newObject("label"));
    obj.label5:setParent(obj.layout10);
    obj.label5:setText("Perícias");
    obj.label5:setAlign("top");
    obj.label5:setHeight(18);
    obj.label5:setFontSize(9);
    obj.label5:setFontColor("Gray");
    lfm_setPropAsString(obj.label5, "fontStyle", "bold");
    obj.label5:setMargins({bottom=4});
    obj.label5:setName("label5");

    obj.layout11 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout11:setParent(obj.layout10);
    obj.layout11:setAlign("client");
    obj.layout11:setName("layout11");

    obj.rowNivel_8 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowNivel_8:setParent(obj.layout11);
    obj.rowNivel_8:setAlign("top");
    obj.rowNivel_8:setHeight(52);
    obj.rowNivel_8:setName("rowNivel_8");
    obj.rowNivel_8:setVisible(false);
    obj.rowNivel_8:setMargins({bottom=2});

    obj.label6 = GUI.fromHandle(_obj_newObject("label"));
    obj.label6:setParent(obj.rowNivel_8);
    obj.label6:setText("+8");
    obj.label6:setAlign("left");
    obj.label6:setWidth(24);
    obj.label6:setFontSize(9);
    obj.label6:setFontColor("#b9151f");
    lfm_setPropAsString(obj.label6, "fontStyle", "bold");
    obj.label6:setVertTextAlign("center");
    obj.label6:setHorzTextAlign("trailing");
    obj.label6:setMargins({right=4});
    obj.label6:setName("label6");

    obj.label7 = GUI.fromHandle(_obj_newObject("label"));
    obj.label7:setParent(obj.rowNivel_8);
    obj.label7:setText("Lendário");
    obj.label7:setAlign("left");
    obj.label7:setWidth(52);
    obj.label7:setFontSize(7);
    obj.label7:setFontColor("Gray");
    obj.label7:setVertTextAlign("center");
    obj.label7:setMargins({right=4});
    obj.label7:setName("label7");

    obj.layout12 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout12:setParent(obj.rowNivel_8);
    obj.layout12:setAlign("client");
    obj.layout12:setName("layout12");

    obj.layout13 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout13:setParent(obj.layout12);
    obj.layout13:setAlign("top");
    obj.layout13:setHeight(24);
    obj.layout13:setMargins({bottom=2});
    obj.layout13:setName("layout13");

    obj.edit5 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit5:setParent(obj.layout13);
    obj.edit5:setAlign("client");
    obj.edit5:setField("per8_1");
    obj.edit5:setHint("perícia");
    obj.edit5:setFontSize(10);
    obj.edit5:setMargins({right=2});
    obj.edit5:setName("edit5");

    obj.edit6 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit6:setParent(obj.layout13);
    obj.edit6:setAlign("right");
    obj.edit6:setWidth(24);
    obj.edit6:setField("per8_1v");
    obj.edit6:setHint("0");
    obj.edit6:setHorzTextAlign("center");
    obj.edit6:setFontSize(10);
    obj.edit6:setMargins({right=2});
    obj.edit6:setName("edit6");

    obj.button1 = GUI.fromHandle(_obj_newObject("button"));
    obj.button1:setParent(obj.layout13);
    obj.button1:setAlign("right");
    obj.button1:setWidth(24);
    obj.button1:setHeight(24);
    obj.button1:setText("dF");
    obj.button1:setFontSize(8);
    obj.button1:setName("button1");

    obj.rowNivel_7 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowNivel_7:setParent(obj.layout11);
    obj.rowNivel_7:setAlign("top");
    obj.rowNivel_7:setHeight(52);
    obj.rowNivel_7:setName("rowNivel_7");
    obj.rowNivel_7:setVisible(false);
    obj.rowNivel_7:setMargins({bottom=2});

    obj.label8 = GUI.fromHandle(_obj_newObject("label"));
    obj.label8:setParent(obj.rowNivel_7);
    obj.label8:setText("+7");
    obj.label8:setAlign("left");
    obj.label8:setWidth(24);
    obj.label8:setFontSize(9);
    obj.label8:setFontColor("#b9151f");
    lfm_setPropAsString(obj.label8, "fontStyle", "bold");
    obj.label8:setVertTextAlign("center");
    obj.label8:setHorzTextAlign("trailing");
    obj.label8:setMargins({right=4});
    obj.label8:setName("label8");

    obj.label9 = GUI.fromHandle(_obj_newObject("label"));
    obj.label9:setParent(obj.rowNivel_7);
    obj.label9:setText("Épico");
    obj.label9:setAlign("left");
    obj.label9:setWidth(52);
    obj.label9:setFontSize(7);
    obj.label9:setFontColor("Gray");
    obj.label9:setVertTextAlign("center");
    obj.label9:setMargins({right=4});
    obj.label9:setName("label9");

    obj.layout14 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout14:setParent(obj.rowNivel_7);
    obj.layout14:setAlign("client");
    obj.layout14:setName("layout14");

    obj.layout15 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout15:setParent(obj.layout14);
    obj.layout15:setAlign("top");
    obj.layout15:setHeight(24);
    obj.layout15:setMargins({bottom=2});
    obj.layout15:setName("layout15");

    obj.edit7 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit7:setParent(obj.layout15);
    obj.edit7:setAlign("client");
    obj.edit7:setField("per7_1");
    obj.edit7:setHint("perícia");
    obj.edit7:setFontSize(10);
    obj.edit7:setMargins({right=2});
    obj.edit7:setName("edit7");

    obj.edit8 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit8:setParent(obj.layout15);
    obj.edit8:setAlign("right");
    obj.edit8:setWidth(24);
    obj.edit8:setField("per7_1v");
    obj.edit8:setHint("0");
    obj.edit8:setHorzTextAlign("center");
    obj.edit8:setFontSize(10);
    obj.edit8:setMargins({right=2});
    obj.edit8:setName("edit8");

    obj.button2 = GUI.fromHandle(_obj_newObject("button"));
    obj.button2:setParent(obj.layout15);
    obj.button2:setAlign("right");
    obj.button2:setWidth(24);
    obj.button2:setHeight(24);
    obj.button2:setText("dF");
    obj.button2:setFontSize(8);
    obj.button2:setName("button2");

    obj.rowNivel_6 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowNivel_6:setParent(obj.layout11);
    obj.rowNivel_6:setAlign("top");
    obj.rowNivel_6:setHeight(52);
    obj.rowNivel_6:setName("rowNivel_6");
    obj.rowNivel_6:setVisible(false);
    obj.rowNivel_6:setMargins({bottom=2});

    obj.label10 = GUI.fromHandle(_obj_newObject("label"));
    obj.label10:setParent(obj.rowNivel_6);
    obj.label10:setText("+6");
    obj.label10:setAlign("left");
    obj.label10:setWidth(24);
    obj.label10:setFontSize(9);
    obj.label10:setFontColor("#b9151f");
    lfm_setPropAsString(obj.label10, "fontStyle", "bold");
    obj.label10:setVertTextAlign("center");
    obj.label10:setHorzTextAlign("trailing");
    obj.label10:setMargins({right=4});
    obj.label10:setName("label10");

    obj.label11 = GUI.fromHandle(_obj_newObject("label"));
    obj.label11:setParent(obj.rowNivel_6);
    obj.label11:setText("Fantástico");
    obj.label11:setAlign("left");
    obj.label11:setWidth(52);
    obj.label11:setFontSize(7);
    obj.label11:setFontColor("Gray");
    obj.label11:setVertTextAlign("center");
    obj.label11:setMargins({right=4});
    obj.label11:setName("label11");

    obj.layout16 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout16:setParent(obj.rowNivel_6);
    obj.layout16:setAlign("client");
    obj.layout16:setName("layout16");

    obj.layout17 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout17:setParent(obj.layout16);
    obj.layout17:setAlign("top");
    obj.layout17:setHeight(24);
    obj.layout17:setMargins({bottom=2});
    obj.layout17:setName("layout17");

    obj.edit9 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit9:setParent(obj.layout17);
    obj.edit9:setAlign("client");
    obj.edit9:setField("per6_1");
    obj.edit9:setHint("perícia");
    obj.edit9:setFontSize(10);
    obj.edit9:setMargins({right=2});
    obj.edit9:setName("edit9");

    obj.edit10 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit10:setParent(obj.layout17);
    obj.edit10:setAlign("right");
    obj.edit10:setWidth(24);
    obj.edit10:setField("per6_1v");
    obj.edit10:setHint("0");
    obj.edit10:setHorzTextAlign("center");
    obj.edit10:setFontSize(10);
    obj.edit10:setMargins({right=2});
    obj.edit10:setName("edit10");

    obj.button3 = GUI.fromHandle(_obj_newObject("button"));
    obj.button3:setParent(obj.layout17);
    obj.button3:setAlign("right");
    obj.button3:setWidth(24);
    obj.button3:setHeight(24);
    obj.button3:setText("dF");
    obj.button3:setFontSize(8);
    obj.button3:setName("button3");

    obj.rowNivel_5 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowNivel_5:setParent(obj.layout11);
    obj.rowNivel_5:setAlign("top");
    obj.rowNivel_5:setHeight(28);
    obj.rowNivel_5:setName("rowNivel_5");
    obj.rowNivel_5:setMargins({bottom=2});

    obj.label12 = GUI.fromHandle(_obj_newObject("label"));
    obj.label12:setParent(obj.rowNivel_5);
    obj.label12:setText("+5");
    obj.label12:setAlign("left");
    obj.label12:setWidth(24);
    obj.label12:setFontSize(9);
    obj.label12:setFontColor("#b9151f");
    lfm_setPropAsString(obj.label12, "fontStyle", "bold");
    obj.label12:setVertTextAlign("center");
    obj.label12:setHorzTextAlign("trailing");
    obj.label12:setMargins({right=4});
    obj.label12:setName("label12");

    obj.label13 = GUI.fromHandle(_obj_newObject("label"));
    obj.label13:setParent(obj.rowNivel_5);
    obj.label13:setText("Excepcional");
    obj.label13:setAlign("left");
    obj.label13:setWidth(52);
    obj.label13:setFontSize(7);
    obj.label13:setFontColor("Gray");
    obj.label13:setVertTextAlign("center");
    obj.label13:setMargins({right=4});
    obj.label13:setName("label13");

    obj.layout18 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout18:setParent(obj.rowNivel_5);
    obj.layout18:setAlign("client");
    obj.layout18:setName("layout18");

    obj.edit11 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit11:setParent(obj.layout18);
    obj.edit11:setAlign("client");
    obj.edit11:setField("per5_1");
    obj.edit11:setHint("perícia");
    obj.edit11:setFontSize(10);
    obj.edit11:setMargins({right=2});
    obj.edit11:setName("edit11");

    obj.edit12 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit12:setParent(obj.layout18);
    obj.edit12:setAlign("right");
    obj.edit12:setWidth(24);
    obj.edit12:setField("per5_1v");
    obj.edit12:setHint("0");
    obj.edit12:setHorzTextAlign("center");
    obj.edit12:setFontSize(10);
    obj.edit12:setMargins({right=2});
    obj.edit12:setName("edit12");

    obj.button4 = GUI.fromHandle(_obj_newObject("button"));
    obj.button4:setParent(obj.layout18);
    obj.button4:setAlign("right");
    obj.button4:setWidth(24);
    obj.button4:setHeight(24);
    obj.button4:setText("dF");
    obj.button4:setFontSize(8);
    obj.button4:setName("button4");

    obj.rowNivel_4 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowNivel_4:setParent(obj.layout11);
    obj.rowNivel_4:setAlign("top");
    obj.rowNivel_4:setHeight(56);
    obj.rowNivel_4:setName("rowNivel_4");
    obj.rowNivel_4:setMargins({bottom=2});

    obj.label14 = GUI.fromHandle(_obj_newObject("label"));
    obj.label14:setParent(obj.rowNivel_4);
    obj.label14:setText("+4");
    obj.label14:setAlign("left");
    obj.label14:setWidth(24);
    obj.label14:setFontSize(9);
    obj.label14:setFontColor("#b9151f");
    lfm_setPropAsString(obj.label14, "fontStyle", "bold");
    obj.label14:setVertTextAlign("center");
    obj.label14:setHorzTextAlign("trailing");
    obj.label14:setMargins({right=4});
    obj.label14:setName("label14");

    obj.label15 = GUI.fromHandle(_obj_newObject("label"));
    obj.label15:setParent(obj.rowNivel_4);
    obj.label15:setText("Ótimo");
    obj.label15:setAlign("left");
    obj.label15:setWidth(52);
    obj.label15:setFontSize(7);
    obj.label15:setFontColor("Gray");
    obj.label15:setVertTextAlign("center");
    obj.label15:setMargins({right=4});
    obj.label15:setName("label15");

    obj.layout19 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout19:setParent(obj.rowNivel_4);
    obj.layout19:setAlign("client");
    obj.layout19:setName("layout19");

    obj.layout20 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout20:setParent(obj.layout19);
    obj.layout20:setAlign("top");
    obj.layout20:setHeight(24);
    obj.layout20:setMargins({bottom=4});
    obj.layout20:setName("layout20");

    obj.edit13 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit13:setParent(obj.layout20);
    obj.edit13:setAlign("client");
    obj.edit13:setField("per4_1");
    obj.edit13:setHint("perícia");
    obj.edit13:setFontSize(10);
    obj.edit13:setMargins({right=2});
    obj.edit13:setName("edit13");

    obj.edit14 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit14:setParent(obj.layout20);
    obj.edit14:setAlign("right");
    obj.edit14:setWidth(24);
    obj.edit14:setField("per4_1v");
    obj.edit14:setHint("0");
    obj.edit14:setHorzTextAlign("center");
    obj.edit14:setFontSize(10);
    obj.edit14:setMargins({right=2});
    obj.edit14:setName("edit14");

    obj.button5 = GUI.fromHandle(_obj_newObject("button"));
    obj.button5:setParent(obj.layout20);
    obj.button5:setAlign("right");
    obj.button5:setWidth(24);
    obj.button5:setHeight(24);
    obj.button5:setText("dF");
    obj.button5:setFontSize(8);
    obj.button5:setName("button5");

    obj.layout21 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout21:setParent(obj.layout19);
    obj.layout21:setAlign("top");
    obj.layout21:setHeight(24);
    obj.layout21:setName("layout21");

    obj.edit15 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit15:setParent(obj.layout21);
    obj.edit15:setAlign("client");
    obj.edit15:setField("per4_2");
    obj.edit15:setHint("perícia");
    obj.edit15:setFontSize(10);
    obj.edit15:setMargins({right=2});
    obj.edit15:setName("edit15");

    obj.edit16 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit16:setParent(obj.layout21);
    obj.edit16:setAlign("right");
    obj.edit16:setWidth(24);
    obj.edit16:setField("per4_2v");
    obj.edit16:setHint("0");
    obj.edit16:setHorzTextAlign("center");
    obj.edit16:setFontSize(10);
    obj.edit16:setMargins({right=2});
    obj.edit16:setName("edit16");

    obj.button6 = GUI.fromHandle(_obj_newObject("button"));
    obj.button6:setParent(obj.layout21);
    obj.button6:setAlign("right");
    obj.button6:setWidth(24);
    obj.button6:setHeight(24);
    obj.button6:setText("dF");
    obj.button6:setFontSize(8);
    obj.button6:setName("button6");

    obj.rowNivel_3 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowNivel_3:setParent(obj.layout11);
    obj.rowNivel_3:setAlign("top");
    obj.rowNivel_3:setHeight(84);
    obj.rowNivel_3:setName("rowNivel_3");
    obj.rowNivel_3:setMargins({bottom=2});

    obj.label16 = GUI.fromHandle(_obj_newObject("label"));
    obj.label16:setParent(obj.rowNivel_3);
    obj.label16:setText("+3");
    obj.label16:setAlign("left");
    obj.label16:setWidth(24);
    obj.label16:setFontSize(9);
    obj.label16:setFontColor("#b9151f");
    lfm_setPropAsString(obj.label16, "fontStyle", "bold");
    obj.label16:setVertTextAlign("center");
    obj.label16:setHorzTextAlign("trailing");
    obj.label16:setMargins({right=4});
    obj.label16:setName("label16");

    obj.label17 = GUI.fromHandle(_obj_newObject("label"));
    obj.label17:setParent(obj.rowNivel_3);
    obj.label17:setText("Bom");
    obj.label17:setAlign("left");
    obj.label17:setWidth(52);
    obj.label17:setFontSize(7);
    obj.label17:setFontColor("Gray");
    obj.label17:setVertTextAlign("center");
    obj.label17:setMargins({right=4});
    obj.label17:setName("label17");

    obj.layout22 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout22:setParent(obj.rowNivel_3);
    obj.layout22:setAlign("client");
    obj.layout22:setName("layout22");

    obj.layout23 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout23:setParent(obj.layout22);
    obj.layout23:setAlign("top");
    obj.layout23:setHeight(24);
    obj.layout23:setMargins({bottom=4});
    obj.layout23:setName("layout23");

    obj.edit17 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit17:setParent(obj.layout23);
    obj.edit17:setAlign("client");
    obj.edit17:setField("per3_1");
    obj.edit17:setHint("perícia");
    obj.edit17:setFontSize(10);
    obj.edit17:setMargins({right=2});
    obj.edit17:setName("edit17");

    obj.edit18 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit18:setParent(obj.layout23);
    obj.edit18:setAlign("right");
    obj.edit18:setWidth(24);
    obj.edit18:setField("per3_1v");
    obj.edit18:setHint("0");
    obj.edit18:setHorzTextAlign("center");
    obj.edit18:setFontSize(10);
    obj.edit18:setMargins({right=2});
    obj.edit18:setName("edit18");

    obj.button7 = GUI.fromHandle(_obj_newObject("button"));
    obj.button7:setParent(obj.layout23);
    obj.button7:setAlign("right");
    obj.button7:setWidth(24);
    obj.button7:setHeight(24);
    obj.button7:setText("dF");
    obj.button7:setFontSize(8);
    obj.button7:setName("button7");

    obj.layout24 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout24:setParent(obj.layout22);
    obj.layout24:setAlign("top");
    obj.layout24:setHeight(24);
    obj.layout24:setMargins({bottom=4});
    obj.layout24:setName("layout24");

    obj.edit19 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit19:setParent(obj.layout24);
    obj.edit19:setAlign("client");
    obj.edit19:setField("per3_2");
    obj.edit19:setHint("perícia");
    obj.edit19:setFontSize(10);
    obj.edit19:setMargins({right=2});
    obj.edit19:setName("edit19");

    obj.edit20 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit20:setParent(obj.layout24);
    obj.edit20:setAlign("right");
    obj.edit20:setWidth(24);
    obj.edit20:setField("per3_2v");
    obj.edit20:setHint("0");
    obj.edit20:setHorzTextAlign("center");
    obj.edit20:setFontSize(10);
    obj.edit20:setMargins({right=2});
    obj.edit20:setName("edit20");

    obj.button8 = GUI.fromHandle(_obj_newObject("button"));
    obj.button8:setParent(obj.layout24);
    obj.button8:setAlign("right");
    obj.button8:setWidth(24);
    obj.button8:setHeight(24);
    obj.button8:setText("dF");
    obj.button8:setFontSize(8);
    obj.button8:setName("button8");

    obj.layout25 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout25:setParent(obj.layout22);
    obj.layout25:setAlign("top");
    obj.layout25:setHeight(24);
    obj.layout25:setName("layout25");

    obj.edit21 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit21:setParent(obj.layout25);
    obj.edit21:setAlign("client");
    obj.edit21:setField("per3_3");
    obj.edit21:setHint("perícia");
    obj.edit21:setFontSize(10);
    obj.edit21:setMargins({right=2});
    obj.edit21:setName("edit21");

    obj.edit22 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit22:setParent(obj.layout25);
    obj.edit22:setAlign("right");
    obj.edit22:setWidth(24);
    obj.edit22:setField("per3_3v");
    obj.edit22:setHint("0");
    obj.edit22:setHorzTextAlign("center");
    obj.edit22:setFontSize(10);
    obj.edit22:setMargins({right=2});
    obj.edit22:setName("edit22");

    obj.button9 = GUI.fromHandle(_obj_newObject("button"));
    obj.button9:setParent(obj.layout25);
    obj.button9:setAlign("right");
    obj.button9:setWidth(24);
    obj.button9:setHeight(24);
    obj.button9:setText("dF");
    obj.button9:setFontSize(8);
    obj.button9:setName("button9");

    obj.rowNivel_2 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowNivel_2:setParent(obj.layout11);
    obj.rowNivel_2:setAlign("top");
    obj.rowNivel_2:setHeight(112);
    obj.rowNivel_2:setName("rowNivel_2");
    obj.rowNivel_2:setMargins({bottom=2});

    obj.label18 = GUI.fromHandle(_obj_newObject("label"));
    obj.label18:setParent(obj.rowNivel_2);
    obj.label18:setText("+2");
    obj.label18:setAlign("left");
    obj.label18:setWidth(24);
    obj.label18:setFontSize(9);
    obj.label18:setFontColor("#b9151f");
    lfm_setPropAsString(obj.label18, "fontStyle", "bold");
    obj.label18:setVertTextAlign("center");
    obj.label18:setHorzTextAlign("trailing");
    obj.label18:setMargins({right=4});
    obj.label18:setName("label18");

    obj.label19 = GUI.fromHandle(_obj_newObject("label"));
    obj.label19:setParent(obj.rowNivel_2);
    obj.label19:setText("Razoável");
    obj.label19:setAlign("left");
    obj.label19:setWidth(52);
    obj.label19:setFontSize(7);
    obj.label19:setFontColor("Gray");
    obj.label19:setVertTextAlign("center");
    obj.label19:setMargins({right=4});
    obj.label19:setName("label19");

    obj.layout26 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout26:setParent(obj.rowNivel_2);
    obj.layout26:setAlign("client");
    obj.layout26:setName("layout26");

    obj.layout27 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout27:setParent(obj.layout26);
    obj.layout27:setAlign("top");
    obj.layout27:setHeight(24);
    obj.layout27:setMargins({bottom=4});
    obj.layout27:setName("layout27");

    obj.edit23 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit23:setParent(obj.layout27);
    obj.edit23:setAlign("client");
    obj.edit23:setField("per2_1");
    obj.edit23:setHint("perícia");
    obj.edit23:setFontSize(10);
    obj.edit23:setMargins({right=2});
    obj.edit23:setName("edit23");

    obj.edit24 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit24:setParent(obj.layout27);
    obj.edit24:setAlign("right");
    obj.edit24:setWidth(24);
    obj.edit24:setField("per2_1v");
    obj.edit24:setHint("0");
    obj.edit24:setHorzTextAlign("center");
    obj.edit24:setFontSize(10);
    obj.edit24:setMargins({right=2});
    obj.edit24:setName("edit24");

    obj.button10 = GUI.fromHandle(_obj_newObject("button"));
    obj.button10:setParent(obj.layout27);
    obj.button10:setAlign("right");
    obj.button10:setWidth(24);
    obj.button10:setHeight(24);
    obj.button10:setText("dF");
    obj.button10:setFontSize(8);
    obj.button10:setName("button10");

    obj.layout28 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout28:setParent(obj.layout26);
    obj.layout28:setAlign("top");
    obj.layout28:setHeight(24);
    obj.layout28:setMargins({bottom=4});
    obj.layout28:setName("layout28");

    obj.edit25 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit25:setParent(obj.layout28);
    obj.edit25:setAlign("client");
    obj.edit25:setField("per2_2");
    obj.edit25:setHint("perícia");
    obj.edit25:setFontSize(10);
    obj.edit25:setMargins({right=2});
    obj.edit25:setName("edit25");

    obj.edit26 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit26:setParent(obj.layout28);
    obj.edit26:setAlign("right");
    obj.edit26:setWidth(24);
    obj.edit26:setField("per2_2v");
    obj.edit26:setHint("0");
    obj.edit26:setHorzTextAlign("center");
    obj.edit26:setFontSize(10);
    obj.edit26:setMargins({right=2});
    obj.edit26:setName("edit26");

    obj.button11 = GUI.fromHandle(_obj_newObject("button"));
    obj.button11:setParent(obj.layout28);
    obj.button11:setAlign("right");
    obj.button11:setWidth(24);
    obj.button11:setHeight(24);
    obj.button11:setText("dF");
    obj.button11:setFontSize(8);
    obj.button11:setName("button11");

    obj.layout29 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout29:setParent(obj.layout26);
    obj.layout29:setAlign("top");
    obj.layout29:setHeight(24);
    obj.layout29:setMargins({bottom=4});
    obj.layout29:setName("layout29");

    obj.edit27 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit27:setParent(obj.layout29);
    obj.edit27:setAlign("client");
    obj.edit27:setField("per2_3");
    obj.edit27:setHint("perícia");
    obj.edit27:setFontSize(10);
    obj.edit27:setMargins({right=2});
    obj.edit27:setName("edit27");

    obj.edit28 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit28:setParent(obj.layout29);
    obj.edit28:setAlign("right");
    obj.edit28:setWidth(24);
    obj.edit28:setField("per2_3v");
    obj.edit28:setHint("0");
    obj.edit28:setHorzTextAlign("center");
    obj.edit28:setFontSize(10);
    obj.edit28:setMargins({right=2});
    obj.edit28:setName("edit28");

    obj.button12 = GUI.fromHandle(_obj_newObject("button"));
    obj.button12:setParent(obj.layout29);
    obj.button12:setAlign("right");
    obj.button12:setWidth(24);
    obj.button12:setHeight(24);
    obj.button12:setText("dF");
    obj.button12:setFontSize(8);
    obj.button12:setName("button12");

    obj.layout30 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout30:setParent(obj.layout26);
    obj.layout30:setAlign("top");
    obj.layout30:setHeight(24);
    obj.layout30:setName("layout30");

    obj.edit29 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit29:setParent(obj.layout30);
    obj.edit29:setAlign("client");
    obj.edit29:setField("per2_4");
    obj.edit29:setHint("perícia");
    obj.edit29:setFontSize(10);
    obj.edit29:setMargins({right=2});
    obj.edit29:setName("edit29");

    obj.edit30 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit30:setParent(obj.layout30);
    obj.edit30:setAlign("right");
    obj.edit30:setWidth(24);
    obj.edit30:setField("per2_4v");
    obj.edit30:setHint("0");
    obj.edit30:setHorzTextAlign("center");
    obj.edit30:setFontSize(10);
    obj.edit30:setMargins({right=2});
    obj.edit30:setName("edit30");

    obj.button13 = GUI.fromHandle(_obj_newObject("button"));
    obj.button13:setParent(obj.layout30);
    obj.button13:setAlign("right");
    obj.button13:setWidth(24);
    obj.button13:setHeight(24);
    obj.button13:setText("dF");
    obj.button13:setFontSize(8);
    obj.button13:setName("button13");

    obj.rowNivel_1 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowNivel_1:setParent(obj.layout11);
    obj.rowNivel_1:setAlign("top");
    obj.rowNivel_1:setHeight(140);
    obj.rowNivel_1:setName("rowNivel_1");
    obj.rowNivel_1:setMargins({bottom=2});

    obj.label20 = GUI.fromHandle(_obj_newObject("label"));
    obj.label20:setParent(obj.rowNivel_1);
    obj.label20:setText("+1");
    obj.label20:setAlign("left");
    obj.label20:setWidth(24);
    obj.label20:setFontSize(9);
    obj.label20:setFontColor("#b9151f");
    lfm_setPropAsString(obj.label20, "fontStyle", "bold");
    obj.label20:setVertTextAlign("center");
    obj.label20:setHorzTextAlign("trailing");
    obj.label20:setMargins({right=4});
    obj.label20:setName("label20");

    obj.label21 = GUI.fromHandle(_obj_newObject("label"));
    obj.label21:setParent(obj.rowNivel_1);
    obj.label21:setText("Regular");
    obj.label21:setAlign("left");
    obj.label21:setWidth(52);
    obj.label21:setFontSize(7);
    obj.label21:setFontColor("Gray");
    obj.label21:setVertTextAlign("center");
    obj.label21:setMargins({right=4});
    obj.label21:setName("label21");

    obj.layout31 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout31:setParent(obj.rowNivel_1);
    obj.layout31:setAlign("client");
    obj.layout31:setName("layout31");

    obj.layout32 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout32:setParent(obj.layout31);
    obj.layout32:setAlign("top");
    obj.layout32:setHeight(24);
    obj.layout32:setMargins({bottom=4});
    obj.layout32:setName("layout32");

    obj.edit31 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit31:setParent(obj.layout32);
    obj.edit31:setAlign("client");
    obj.edit31:setField("per1_1");
    obj.edit31:setHint("perícia");
    obj.edit31:setFontSize(10);
    obj.edit31:setMargins({right=2});
    obj.edit31:setName("edit31");

    obj.edit32 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit32:setParent(obj.layout32);
    obj.edit32:setAlign("right");
    obj.edit32:setWidth(24);
    obj.edit32:setField("per1_1v");
    obj.edit32:setHint("0");
    obj.edit32:setHorzTextAlign("center");
    obj.edit32:setFontSize(10);
    obj.edit32:setMargins({right=2});
    obj.edit32:setName("edit32");

    obj.button14 = GUI.fromHandle(_obj_newObject("button"));
    obj.button14:setParent(obj.layout32);
    obj.button14:setAlign("right");
    obj.button14:setWidth(24);
    obj.button14:setHeight(24);
    obj.button14:setText("dF");
    obj.button14:setFontSize(8);
    obj.button14:setName("button14");

    obj.layout33 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout33:setParent(obj.layout31);
    obj.layout33:setAlign("top");
    obj.layout33:setHeight(24);
    obj.layout33:setMargins({bottom=4});
    obj.layout33:setName("layout33");

    obj.edit33 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit33:setParent(obj.layout33);
    obj.edit33:setAlign("client");
    obj.edit33:setField("per1_2");
    obj.edit33:setHint("perícia");
    obj.edit33:setFontSize(10);
    obj.edit33:setMargins({right=2});
    obj.edit33:setName("edit33");

    obj.edit34 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit34:setParent(obj.layout33);
    obj.edit34:setAlign("right");
    obj.edit34:setWidth(24);
    obj.edit34:setField("per1_2v");
    obj.edit34:setHint("0");
    obj.edit34:setHorzTextAlign("center");
    obj.edit34:setFontSize(10);
    obj.edit34:setMargins({right=2});
    obj.edit34:setName("edit34");

    obj.button15 = GUI.fromHandle(_obj_newObject("button"));
    obj.button15:setParent(obj.layout33);
    obj.button15:setAlign("right");
    obj.button15:setWidth(24);
    obj.button15:setHeight(24);
    obj.button15:setText("dF");
    obj.button15:setFontSize(8);
    obj.button15:setName("button15");

    obj.layout34 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout34:setParent(obj.layout31);
    obj.layout34:setAlign("top");
    obj.layout34:setHeight(24);
    obj.layout34:setMargins({bottom=4});
    obj.layout34:setName("layout34");

    obj.edit35 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit35:setParent(obj.layout34);
    obj.edit35:setAlign("client");
    obj.edit35:setField("per1_3");
    obj.edit35:setHint("perícia");
    obj.edit35:setFontSize(10);
    obj.edit35:setMargins({right=2});
    obj.edit35:setName("edit35");

    obj.edit36 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit36:setParent(obj.layout34);
    obj.edit36:setAlign("right");
    obj.edit36:setWidth(24);
    obj.edit36:setField("per1_3v");
    obj.edit36:setHint("0");
    obj.edit36:setHorzTextAlign("center");
    obj.edit36:setFontSize(10);
    obj.edit36:setMargins({right=2});
    obj.edit36:setName("edit36");

    obj.button16 = GUI.fromHandle(_obj_newObject("button"));
    obj.button16:setParent(obj.layout34);
    obj.button16:setAlign("right");
    obj.button16:setWidth(24);
    obj.button16:setHeight(24);
    obj.button16:setText("dF");
    obj.button16:setFontSize(8);
    obj.button16:setName("button16");

    obj.layout35 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout35:setParent(obj.layout31);
    obj.layout35:setAlign("top");
    obj.layout35:setHeight(24);
    obj.layout35:setMargins({bottom=4});
    obj.layout35:setName("layout35");

    obj.edit37 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit37:setParent(obj.layout35);
    obj.edit37:setAlign("client");
    obj.edit37:setField("per1_4");
    obj.edit37:setHint("perícia");
    obj.edit37:setFontSize(10);
    obj.edit37:setMargins({right=2});
    obj.edit37:setName("edit37");

    obj.edit38 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit38:setParent(obj.layout35);
    obj.edit38:setAlign("right");
    obj.edit38:setWidth(24);
    obj.edit38:setField("per1_4v");
    obj.edit38:setHint("0");
    obj.edit38:setHorzTextAlign("center");
    obj.edit38:setFontSize(10);
    obj.edit38:setMargins({right=2});
    obj.edit38:setName("edit38");

    obj.button17 = GUI.fromHandle(_obj_newObject("button"));
    obj.button17:setParent(obj.layout35);
    obj.button17:setAlign("right");
    obj.button17:setWidth(24);
    obj.button17:setHeight(24);
    obj.button17:setText("dF");
    obj.button17:setFontSize(8);
    obj.button17:setName("button17");

    obj.layout36 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout36:setParent(obj.layout31);
    obj.layout36:setAlign("top");
    obj.layout36:setHeight(24);
    obj.layout36:setName("layout36");

    obj.edit39 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit39:setParent(obj.layout36);
    obj.edit39:setAlign("client");
    obj.edit39:setField("per1_5");
    obj.edit39:setHint("perícia");
    obj.edit39:setFontSize(10);
    obj.edit39:setMargins({right=2});
    obj.edit39:setName("edit39");

    obj.edit40 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit40:setParent(obj.layout36);
    obj.edit40:setAlign("right");
    obj.edit40:setWidth(24);
    obj.edit40:setField("per1_5v");
    obj.edit40:setHint("0");
    obj.edit40:setHorzTextAlign("center");
    obj.edit40:setFontSize(10);
    obj.edit40:setMargins({right=2});
    obj.edit40:setName("edit40");

    obj.button18 = GUI.fromHandle(_obj_newObject("button"));
    obj.button18:setParent(obj.layout36);
    obj.button18:setAlign("right");
    obj.button18:setWidth(24);
    obj.button18:setHeight(24);
    obj.button18:setText("dF");
    obj.button18:setFontSize(8);
    obj.button18:setName("button18");

    obj.layout37 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout37:setParent(obj.layout9);
    obj.layout37:setAlign("client");
    obj.layout37:setName("layout37");

    obj.image1 = GUI.fromHandle(_obj_newObject("image"));
    obj.image1:setParent(obj.layout37);
    obj.image1:setAlign("top");
    obj.image1:setHeight(160);
    obj.image1:setField("retrato");
    obj.image1:setEditable(true);
    obj.image1:setStyle("proportional");
    obj.image1:setMargins({bottom=8});
    obj.image1:setName("image1");

    obj.label22 = GUI.fromHandle(_obj_newObject("label"));
    obj.label22:setParent(obj.layout37);
    obj.label22:setText("Aspectos");
    obj.label22:setAlign("top");
    obj.label22:setHeight(18);
    obj.label22:setFontSize(9);
    obj.label22:setFontColor("Gray");
    lfm_setPropAsString(obj.label22, "fontStyle", "bold");
    obj.label22:setMargins({bottom=4});
    obj.label22:setName("label22");

    obj.label23 = GUI.fromHandle(_obj_newObject("label"));
    obj.label23:setParent(obj.layout37);
    obj.label23:setText("Conceito");
    obj.label23:setAlign("top");
    obj.label23:setHeight(12);
    obj.label23:setFontSize(7);
    obj.label23:setFontColor("#b9151f");
    lfm_setPropAsString(obj.label23, "fontStyle", "bold");
    obj.label23:setName("label23");

    obj.edit41 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit41:setParent(obj.layout37);
    obj.edit41:setAlign("top");
    obj.edit41:setHeight(22);
    obj.edit41:setField("conceito");
    obj.edit41:setFontSize(11);
    obj.edit41:setMargins({bottom=6});
    obj.edit41:setName("edit41");

    obj.label24 = GUI.fromHandle(_obj_newObject("label"));
    obj.label24:setParent(obj.layout37);
    obj.label24:setText("Dificuldade");
    obj.label24:setAlign("top");
    obj.label24:setHeight(12);
    obj.label24:setFontSize(7);
    obj.label24:setFontColor("#b9151f");
    lfm_setPropAsString(obj.label24, "fontStyle", "bold");
    obj.label24:setName("label24");

    obj.edit42 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit42:setParent(obj.layout37);
    obj.edit42:setAlign("top");
    obj.edit42:setHeight(22);
    obj.edit42:setField("dificuldade");
    obj.edit42:setFontSize(11);
    obj.edit42:setMargins({bottom=6});
    obj.edit42:setName("edit42");

    obj.rowAspecto_1 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowAspecto_1:setParent(obj.layout37);
    obj.rowAspecto_1:setAlign("top");
    obj.rowAspecto_1:setHeight(22);
    obj.rowAspecto_1:setName("rowAspecto_1");
    obj.rowAspecto_1:setMargins({bottom=4});

    obj.label25 = GUI.fromHandle(_obj_newObject("label"));
    obj.label25:setParent(obj.rowAspecto_1);
    obj.label25:setText("Aspecto");
    obj.label25:setAlign("top");
    obj.label25:setHeight(12);
    obj.label25:setFontSize(7);
    obj.label25:setFontColor("Gray");
    lfm_setPropAsString(obj.label25, "fontStyle", "bold");
    obj.label25:setName("label25");

    obj.edit43 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit43:setParent(obj.rowAspecto_1);
    obj.edit43:setAlign("client");
    obj.edit43:setField("aspecto1");
    obj.edit43:setFontSize(10);
    obj.edit43:setName("edit43");

    obj.rowAspecto_2 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowAspecto_2:setParent(obj.layout37);
    obj.rowAspecto_2:setAlign("top");
    obj.rowAspecto_2:setHeight(22);
    obj.rowAspecto_2:setName("rowAspecto_2");
    obj.rowAspecto_2:setMargins({bottom=4});

    obj.label26 = GUI.fromHandle(_obj_newObject("label"));
    obj.label26:setParent(obj.rowAspecto_2);
    obj.label26:setText("Aspecto");
    obj.label26:setAlign("top");
    obj.label26:setHeight(12);
    obj.label26:setFontSize(7);
    obj.label26:setFontColor("Gray");
    lfm_setPropAsString(obj.label26, "fontStyle", "bold");
    obj.label26:setName("label26");

    obj.edit44 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit44:setParent(obj.rowAspecto_2);
    obj.edit44:setAlign("client");
    obj.edit44:setField("aspecto2");
    obj.edit44:setFontSize(10);
    obj.edit44:setName("edit44");

    obj.rowAspecto_3 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowAspecto_3:setParent(obj.layout37);
    obj.rowAspecto_3:setAlign("top");
    obj.rowAspecto_3:setHeight(22);
    obj.rowAspecto_3:setName("rowAspecto_3");
    obj.rowAspecto_3:setMargins({bottom=4});

    obj.label27 = GUI.fromHandle(_obj_newObject("label"));
    obj.label27:setParent(obj.rowAspecto_3);
    obj.label27:setText("Aspecto");
    obj.label27:setAlign("top");
    obj.label27:setHeight(12);
    obj.label27:setFontSize(7);
    obj.label27:setFontColor("Gray");
    lfm_setPropAsString(obj.label27, "fontStyle", "bold");
    obj.label27:setName("label27");

    obj.edit45 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit45:setParent(obj.rowAspecto_3);
    obj.edit45:setAlign("client");
    obj.edit45:setField("aspecto3");
    obj.edit45:setFontSize(10);
    obj.edit45:setName("edit45");

    obj.rowAspecto_4 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowAspecto_4:setParent(obj.layout37);
    obj.rowAspecto_4:setAlign("top");
    obj.rowAspecto_4:setHeight(22);
    obj.rowAspecto_4:setName("rowAspecto_4");
    obj.rowAspecto_4:setVisible(false);
    obj.rowAspecto_4:setMargins({bottom=4});

    obj.label28 = GUI.fromHandle(_obj_newObject("label"));
    obj.label28:setParent(obj.rowAspecto_4);
    obj.label28:setText("Aspecto");
    obj.label28:setAlign("top");
    obj.label28:setHeight(12);
    obj.label28:setFontSize(7);
    obj.label28:setFontColor("Gray");
    lfm_setPropAsString(obj.label28, "fontStyle", "bold");
    obj.label28:setName("label28");

    obj.edit46 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit46:setParent(obj.rowAspecto_4);
    obj.edit46:setAlign("client");
    obj.edit46:setField("aspecto4");
    obj.edit46:setFontSize(10);
    obj.edit46:setName("edit46");

    obj.rowAspecto_5 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowAspecto_5:setParent(obj.layout37);
    obj.rowAspecto_5:setAlign("top");
    obj.rowAspecto_5:setHeight(22);
    obj.rowAspecto_5:setName("rowAspecto_5");
    obj.rowAspecto_5:setVisible(false);
    obj.rowAspecto_5:setMargins({bottom=4});

    obj.label29 = GUI.fromHandle(_obj_newObject("label"));
    obj.label29:setParent(obj.rowAspecto_5);
    obj.label29:setText("Aspecto");
    obj.label29:setAlign("top");
    obj.label29:setHeight(12);
    obj.label29:setFontSize(7);
    obj.label29:setFontColor("Gray");
    lfm_setPropAsString(obj.label29, "fontStyle", "bold");
    obj.label29:setName("label29");

    obj.edit47 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit47:setParent(obj.rowAspecto_5);
    obj.edit47:setAlign("client");
    obj.edit47:setField("aspecto5");
    obj.edit47:setFontSize(10);
    obj.edit47:setName("edit47");

    obj.rowAspecto_6 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowAspecto_6:setParent(obj.layout37);
    obj.rowAspecto_6:setAlign("top");
    obj.rowAspecto_6:setHeight(22);
    obj.rowAspecto_6:setName("rowAspecto_6");
    obj.rowAspecto_6:setVisible(false);
    obj.rowAspecto_6:setMargins({bottom=4});

    obj.label30 = GUI.fromHandle(_obj_newObject("label"));
    obj.label30:setParent(obj.rowAspecto_6);
    obj.label30:setText("Aspecto");
    obj.label30:setAlign("top");
    obj.label30:setHeight(12);
    obj.label30:setFontSize(7);
    obj.label30:setFontColor("Gray");
    lfm_setPropAsString(obj.label30, "fontStyle", "bold");
    obj.label30:setName("label30");

    obj.edit48 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit48:setParent(obj.rowAspecto_6);
    obj.edit48:setAlign("client");
    obj.edit48:setField("aspecto6");
    obj.edit48:setFontSize(10);
    obj.edit48:setName("edit48");

    obj.rowAspecto_7 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowAspecto_7:setParent(obj.layout37);
    obj.rowAspecto_7:setAlign("top");
    obj.rowAspecto_7:setHeight(22);
    obj.rowAspecto_7:setName("rowAspecto_7");
    obj.rowAspecto_7:setVisible(false);
    obj.rowAspecto_7:setMargins({bottom=4});

    obj.label31 = GUI.fromHandle(_obj_newObject("label"));
    obj.label31:setParent(obj.rowAspecto_7);
    obj.label31:setText("Aspecto");
    obj.label31:setAlign("top");
    obj.label31:setHeight(12);
    obj.label31:setFontSize(7);
    obj.label31:setFontColor("Gray");
    lfm_setPropAsString(obj.label31, "fontStyle", "bold");
    obj.label31:setName("label31");

    obj.edit49 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit49:setParent(obj.rowAspecto_7);
    obj.edit49:setAlign("client");
    obj.edit49:setField("aspecto7");
    obj.edit49:setFontSize(10);
    obj.edit49:setName("edit49");

    obj.layout38 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout38:setParent(obj.layout1);
    obj.layout38:setAlign("top");
    obj.layout38:setHeight(200);
    obj.layout38:setMargins({bottom=8});
    obj.layout38:setName("layout38");

    obj.layout39 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout39:setParent(obj.layout38);
    obj.layout39:setAlign("left");
    obj.layout39:setWidth(260);
    obj.layout39:setMargins({right=8});
    obj.layout39:setName("layout39");

    obj.label32 = GUI.fromHandle(_obj_newObject("label"));
    obj.label32:setParent(obj.layout39);
    obj.label32:setText("Façanhas");
    obj.label32:setAlign("top");
    obj.label32:setHeight(18);
    obj.label32:setFontSize(9);
    obj.label32:setFontColor("Gray");
    lfm_setPropAsString(obj.label32, "fontStyle", "bold");
    obj.label32:setMargins({bottom=4});
    obj.label32:setName("label32");

    obj.layout40 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout40:setParent(obj.layout39);
    obj.layout40:setAlign("client");
    obj.layout40:setName("layout40");

    obj.rowFacanha_1 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowFacanha_1:setParent(obj.layout40);
    obj.rowFacanha_1:setAlign("top");
    obj.rowFacanha_1:setHeight(22);
    obj.rowFacanha_1:setName("rowFacanha_1");
    obj.rowFacanha_1:setMargins({bottom=3});

    obj.edit50 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit50:setParent(obj.rowFacanha_1);
    obj.edit50:setAlign("client");
    obj.edit50:setField("facanha1");
    obj.edit50:setFontSize(10);
    obj.edit50:setName("edit50");

    obj.rowFacanha_2 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowFacanha_2:setParent(obj.layout40);
    obj.rowFacanha_2:setAlign("top");
    obj.rowFacanha_2:setHeight(22);
    obj.rowFacanha_2:setName("rowFacanha_2");
    obj.rowFacanha_2:setMargins({bottom=3});

    obj.edit51 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit51:setParent(obj.rowFacanha_2);
    obj.edit51:setAlign("client");
    obj.edit51:setField("facanha2");
    obj.edit51:setFontSize(10);
    obj.edit51:setName("edit51");

    obj.rowFacanha_3 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowFacanha_3:setParent(obj.layout40);
    obj.rowFacanha_3:setAlign("top");
    obj.rowFacanha_3:setHeight(22);
    obj.rowFacanha_3:setName("rowFacanha_3");
    obj.rowFacanha_3:setMargins({bottom=3});

    obj.edit52 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit52:setParent(obj.rowFacanha_3);
    obj.edit52:setAlign("client");
    obj.edit52:setField("facanha3");
    obj.edit52:setFontSize(10);
    obj.edit52:setName("edit52");

    obj.rowFacanha_4 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowFacanha_4:setParent(obj.layout40);
    obj.rowFacanha_4:setAlign("top");
    obj.rowFacanha_4:setHeight(22);
    obj.rowFacanha_4:setName("rowFacanha_4");
    obj.rowFacanha_4:setMargins({bottom=3});

    obj.edit53 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit53:setParent(obj.rowFacanha_4);
    obj.edit53:setAlign("client");
    obj.edit53:setField("facanha4");
    obj.edit53:setFontSize(10);
    obj.edit53:setName("edit53");

    obj.rowFacanha_5 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowFacanha_5:setParent(obj.layout40);
    obj.rowFacanha_5:setAlign("top");
    obj.rowFacanha_5:setHeight(22);
    obj.rowFacanha_5:setName("rowFacanha_5");
    obj.rowFacanha_5:setMargins({bottom=3});

    obj.edit54 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit54:setParent(obj.rowFacanha_5);
    obj.edit54:setAlign("client");
    obj.edit54:setField("facanha5");
    obj.edit54:setFontSize(10);
    obj.edit54:setName("edit54");

    obj.rowFacanha_6 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowFacanha_6:setParent(obj.layout40);
    obj.rowFacanha_6:setAlign("top");
    obj.rowFacanha_6:setHeight(22);
    obj.rowFacanha_6:setName("rowFacanha_6");
    obj.rowFacanha_6:setMargins({bottom=3});

    obj.edit55 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit55:setParent(obj.rowFacanha_6);
    obj.edit55:setAlign("client");
    obj.edit55:setField("facanha6");
    obj.edit55:setFontSize(10);
    obj.edit55:setName("edit55");

    obj.rowFacanha_7 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowFacanha_7:setParent(obj.layout40);
    obj.rowFacanha_7:setAlign("top");
    obj.rowFacanha_7:setHeight(22);
    obj.rowFacanha_7:setName("rowFacanha_7");
    obj.rowFacanha_7:setVisible(false);
    obj.rowFacanha_7:setMargins({bottom=3});

    obj.edit56 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit56:setParent(obj.rowFacanha_7);
    obj.edit56:setAlign("client");
    obj.edit56:setField("facanha7");
    obj.edit56:setFontSize(10);
    obj.edit56:setName("edit56");

    obj.rowFacanha_8 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowFacanha_8:setParent(obj.layout40);
    obj.rowFacanha_8:setAlign("top");
    obj.rowFacanha_8:setHeight(22);
    obj.rowFacanha_8:setName("rowFacanha_8");
    obj.rowFacanha_8:setVisible(false);
    obj.rowFacanha_8:setMargins({bottom=3});

    obj.edit57 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit57:setParent(obj.rowFacanha_8);
    obj.edit57:setAlign("client");
    obj.edit57:setField("facanha8");
    obj.edit57:setFontSize(10);
    obj.edit57:setName("edit57");

    obj.rowFacanha_9 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowFacanha_9:setParent(obj.layout40);
    obj.rowFacanha_9:setAlign("top");
    obj.rowFacanha_9:setHeight(22);
    obj.rowFacanha_9:setName("rowFacanha_9");
    obj.rowFacanha_9:setVisible(false);
    obj.rowFacanha_9:setMargins({bottom=3});

    obj.edit58 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit58:setParent(obj.rowFacanha_9);
    obj.edit58:setAlign("client");
    obj.edit58:setField("facanha9");
    obj.edit58:setFontSize(10);
    obj.edit58:setName("edit58");

    obj.rowFacanha_10 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowFacanha_10:setParent(obj.layout40);
    obj.rowFacanha_10:setAlign("top");
    obj.rowFacanha_10:setHeight(22);
    obj.rowFacanha_10:setName("rowFacanha_10");
    obj.rowFacanha_10:setVisible(false);

    obj.edit59 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit59:setParent(obj.rowFacanha_10);
    obj.edit59:setAlign("client");
    obj.edit59:setField("facanha10");
    obj.edit59:setFontSize(10);
    obj.edit59:setName("edit59");

    obj.layout41 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout41:setParent(obj.layout38);
    obj.layout41:setAlign("client");
    obj.layout41:setName("layout41");

    obj.label33 = GUI.fromHandle(_obj_newObject("label"));
    obj.label33:setParent(obj.layout41);
    obj.label33:setText("Extras");
    obj.label33:setAlign("top");
    obj.label33:setHeight(18);
    obj.label33:setFontSize(9);
    obj.label33:setFontColor("Gray");
    lfm_setPropAsString(obj.label33, "fontStyle", "bold");
    obj.label33:setMargins({bottom=4});
    obj.label33:setName("label33");

    obj.layout42 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout42:setParent(obj.layout41);
    obj.layout42:setAlign("client");
    obj.layout42:setName("layout42");

    obj.rowExtraL_1 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowExtraL_1:setParent(obj.layout42);
    obj.rowExtraL_1:setAlign("top");
    obj.rowExtraL_1:setHeight(22);
    obj.rowExtraL_1:setName("rowExtraL_1");
    obj.rowExtraL_1:setMargins({bottom=3});

    obj.edit60 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit60:setParent(obj.rowExtraL_1);
    obj.edit60:setAlign("client");
    obj.edit60:setField("extraL1");
    obj.edit60:setFontSize(10);
    obj.edit60:setName("edit60");

    obj.rowExtraL_2 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowExtraL_2:setParent(obj.layout42);
    obj.rowExtraL_2:setAlign("top");
    obj.rowExtraL_2:setHeight(22);
    obj.rowExtraL_2:setName("rowExtraL_2");
    obj.rowExtraL_2:setMargins({bottom=3});

    obj.edit61 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit61:setParent(obj.rowExtraL_2);
    obj.edit61:setAlign("client");
    obj.edit61:setField("extraL2");
    obj.edit61:setFontSize(10);
    obj.edit61:setName("edit61");

    obj.rowExtraL_3 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowExtraL_3:setParent(obj.layout42);
    obj.rowExtraL_3:setAlign("top");
    obj.rowExtraL_3:setHeight(22);
    obj.rowExtraL_3:setName("rowExtraL_3");
    obj.rowExtraL_3:setMargins({bottom=3});

    obj.edit62 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit62:setParent(obj.rowExtraL_3);
    obj.edit62:setAlign("client");
    obj.edit62:setField("extraL3");
    obj.edit62:setFontSize(10);
    obj.edit62:setName("edit62");

    obj.rowExtraL_4 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowExtraL_4:setParent(obj.layout42);
    obj.rowExtraL_4:setAlign("top");
    obj.rowExtraL_4:setHeight(22);
    obj.rowExtraL_4:setName("rowExtraL_4");
    obj.rowExtraL_4:setMargins({bottom=3});

    obj.edit63 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit63:setParent(obj.rowExtraL_4);
    obj.edit63:setAlign("client");
    obj.edit63:setField("extraL4");
    obj.edit63:setFontSize(10);
    obj.edit63:setName("edit63");

    obj.rowExtraL_5 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowExtraL_5:setParent(obj.layout42);
    obj.rowExtraL_5:setAlign("top");
    obj.rowExtraL_5:setHeight(22);
    obj.rowExtraL_5:setName("rowExtraL_5");
    obj.rowExtraL_5:setMargins({bottom=3});

    obj.edit64 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit64:setParent(obj.rowExtraL_5);
    obj.edit64:setAlign("client");
    obj.edit64:setField("extraL5");
    obj.edit64:setFontSize(10);
    obj.edit64:setName("edit64");

    obj.rowExtraL_6 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowExtraL_6:setParent(obj.layout42);
    obj.rowExtraL_6:setAlign("top");
    obj.rowExtraL_6:setHeight(22);
    obj.rowExtraL_6:setName("rowExtraL_6");
    obj.rowExtraL_6:setMargins({bottom=3});

    obj.edit65 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit65:setParent(obj.rowExtraL_6);
    obj.edit65:setAlign("client");
    obj.edit65:setField("extraL6");
    obj.edit65:setFontSize(10);
    obj.edit65:setName("edit65");

    obj.rowExtraL_7 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowExtraL_7:setParent(obj.layout42);
    obj.rowExtraL_7:setAlign("top");
    obj.rowExtraL_7:setHeight(22);
    obj.rowExtraL_7:setName("rowExtraL_7");
    obj.rowExtraL_7:setVisible(false);
    obj.rowExtraL_7:setMargins({bottom=3});

    obj.edit66 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit66:setParent(obj.rowExtraL_7);
    obj.edit66:setAlign("client");
    obj.edit66:setField("extraL7");
    obj.edit66:setFontSize(10);
    obj.edit66:setName("edit66");

    obj.rowExtraL_8 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowExtraL_8:setParent(obj.layout42);
    obj.rowExtraL_8:setAlign("top");
    obj.rowExtraL_8:setHeight(22);
    obj.rowExtraL_8:setName("rowExtraL_8");
    obj.rowExtraL_8:setVisible(false);
    obj.rowExtraL_8:setMargins({bottom=3});

    obj.edit67 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit67:setParent(obj.rowExtraL_8);
    obj.edit67:setAlign("client");
    obj.edit67:setField("extraL8");
    obj.edit67:setFontSize(10);
    obj.edit67:setName("edit67");

    obj.rowExtraL_9 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowExtraL_9:setParent(obj.layout42);
    obj.rowExtraL_9:setAlign("top");
    obj.rowExtraL_9:setHeight(22);
    obj.rowExtraL_9:setName("rowExtraL_9");
    obj.rowExtraL_9:setVisible(false);
    obj.rowExtraL_9:setMargins({bottom=3});

    obj.edit68 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit68:setParent(obj.rowExtraL_9);
    obj.edit68:setAlign("client");
    obj.edit68:setField("extraL9");
    obj.edit68:setFontSize(10);
    obj.edit68:setName("edit68");

    obj.rowExtraL_10 = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowExtraL_10:setParent(obj.layout42);
    obj.rowExtraL_10:setAlign("top");
    obj.rowExtraL_10:setHeight(22);
    obj.rowExtraL_10:setName("rowExtraL_10");
    obj.rowExtraL_10:setVisible(false);

    obj.edit69 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit69:setParent(obj.rowExtraL_10);
    obj.edit69:setAlign("client");
    obj.edit69:setField("extraL10");
    obj.edit69:setFontSize(10);
    obj.edit69:setName("edit69");

    obj.layout43 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout43:setParent(obj.layout1);
    obj.layout43:setAlign("top");
    obj.layout43:setHeight(160);
    obj.layout43:setName("layout43");

    obj.layout44 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout44:setParent(obj.layout43);
    obj.layout44:setAlign("left");
    obj.layout44:setWidth(260);
    obj.layout44:setMargins({right=8});
    obj.layout44:setName("layout44");

    obj.label34 = GUI.fromHandle(_obj_newObject("label"));
    obj.label34:setParent(obj.layout44);
    obj.label34:setText("Estresse");
    obj.label34:setAlign("top");
    obj.label34:setHeight(18);
    obj.label34:setFontSize(9);
    obj.label34:setFontColor("Gray");
    lfm_setPropAsString(obj.label34, "fontStyle", "bold");
    obj.label34:setMargins({bottom=6});
    obj.label34:setName("label34");

    obj.layout45 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout45:setParent(obj.layout44);
    obj.layout45:setAlign("top");
    obj.layout45:setHeight(32);
    obj.layout45:setMargins({bottom=8});
    obj.layout45:setName("layout45");

    obj.label35 = GUI.fromHandle(_obj_newObject("label"));
    obj.label35:setParent(obj.layout45);
    obj.label35:setText("Físico");
    obj.label35:setAlign("left");
    obj.label35:setWidth(48);
    obj.label35:setFontSize(8);
    obj.label35:setFontColor("Gray");
    obj.label35:setVertTextAlign("center");
    obj.label35:setName("label35");

    obj.chkFisico_1 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.chkFisico_1:setParent(obj.layout45);
    obj.chkFisico_1:setName("chkFisico_1");
    obj.chkFisico_1:setAlign("left");
    obj.chkFisico_1:setWidth(28);
    obj.chkFisico_1:setField("stF1");
    obj.chkFisico_1:setText("1");
    obj.chkFisico_1:setFontSize(8);

    obj.chkFisico_2 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.chkFisico_2:setParent(obj.layout45);
    obj.chkFisico_2:setName("chkFisico_2");
    obj.chkFisico_2:setAlign("left");
    obj.chkFisico_2:setWidth(28);
    obj.chkFisico_2:setField("stF2");
    obj.chkFisico_2:setText("2");
    obj.chkFisico_2:setFontSize(8);

    obj.chkFisico_3 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.chkFisico_3:setParent(obj.layout45);
    obj.chkFisico_3:setName("chkFisico_3");
    obj.chkFisico_3:setAlign("left");
    obj.chkFisico_3:setWidth(28);
    obj.chkFisico_3:setField("stF3");
    obj.chkFisico_3:setText("3");
    obj.chkFisico_3:setFontSize(8);

    obj.chkFisico_4 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.chkFisico_4:setParent(obj.layout45);
    obj.chkFisico_4:setName("chkFisico_4");
    obj.chkFisico_4:setAlign("left");
    obj.chkFisico_4:setWidth(28);
    obj.chkFisico_4:setField("stF4");
    obj.chkFisico_4:setText("4");
    obj.chkFisico_4:setFontSize(8);

    obj.chkFisico_5 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.chkFisico_5:setParent(obj.layout45);
    obj.chkFisico_5:setName("chkFisico_5");
    obj.chkFisico_5:setAlign("left");
    obj.chkFisico_5:setWidth(28);
    obj.chkFisico_5:setField("stF5");
    obj.chkFisico_5:setText("5");
    obj.chkFisico_5:setFontSize(8);
    obj.chkFisico_5:setVisible(false);

    obj.chkFisico_6 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.chkFisico_6:setParent(obj.layout45);
    obj.chkFisico_6:setName("chkFisico_6");
    obj.chkFisico_6:setAlign("left");
    obj.chkFisico_6:setWidth(28);
    obj.chkFisico_6:setField("stF6");
    obj.chkFisico_6:setText("6");
    obj.chkFisico_6:setFontSize(8);
    obj.chkFisico_6:setVisible(false);

    obj.chkFisico_7 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.chkFisico_7:setParent(obj.layout45);
    obj.chkFisico_7:setName("chkFisico_7");
    obj.chkFisico_7:setAlign("left");
    obj.chkFisico_7:setWidth(28);
    obj.chkFisico_7:setField("stF7");
    obj.chkFisico_7:setText("7");
    obj.chkFisico_7:setFontSize(8);
    obj.chkFisico_7:setVisible(false);

    obj.chkFisico_8 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.chkFisico_8:setParent(obj.layout45);
    obj.chkFisico_8:setName("chkFisico_8");
    obj.chkFisico_8:setAlign("left");
    obj.chkFisico_8:setWidth(28);
    obj.chkFisico_8:setField("stF8");
    obj.chkFisico_8:setText("8");
    obj.chkFisico_8:setFontSize(8);
    obj.chkFisico_8:setVisible(false);

    obj.layout46 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout46:setParent(obj.layout44);
    obj.layout46:setAlign("top");
    obj.layout46:setHeight(32);
    obj.layout46:setName("layout46");

    obj.label36 = GUI.fromHandle(_obj_newObject("label"));
    obj.label36:setParent(obj.layout46);
    obj.label36:setText("Mental");
    obj.label36:setAlign("left");
    obj.label36:setWidth(48);
    obj.label36:setFontSize(8);
    obj.label36:setFontColor("Gray");
    obj.label36:setVertTextAlign("center");
    obj.label36:setName("label36");

    obj.chkMental_1 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.chkMental_1:setParent(obj.layout46);
    obj.chkMental_1:setName("chkMental_1");
    obj.chkMental_1:setAlign("left");
    obj.chkMental_1:setWidth(28);
    obj.chkMental_1:setField("stM1");
    obj.chkMental_1:setText("1");
    obj.chkMental_1:setFontSize(8);

    obj.chkMental_2 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.chkMental_2:setParent(obj.layout46);
    obj.chkMental_2:setName("chkMental_2");
    obj.chkMental_2:setAlign("left");
    obj.chkMental_2:setWidth(28);
    obj.chkMental_2:setField("stM2");
    obj.chkMental_2:setText("2");
    obj.chkMental_2:setFontSize(8);

    obj.chkMental_3 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.chkMental_3:setParent(obj.layout46);
    obj.chkMental_3:setName("chkMental_3");
    obj.chkMental_3:setAlign("left");
    obj.chkMental_3:setWidth(28);
    obj.chkMental_3:setField("stM3");
    obj.chkMental_3:setText("3");
    obj.chkMental_3:setFontSize(8);

    obj.chkMental_4 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.chkMental_4:setParent(obj.layout46);
    obj.chkMental_4:setName("chkMental_4");
    obj.chkMental_4:setAlign("left");
    obj.chkMental_4:setWidth(28);
    obj.chkMental_4:setField("stM4");
    obj.chkMental_4:setText("4");
    obj.chkMental_4:setFontSize(8);

    obj.chkMental_5 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.chkMental_5:setParent(obj.layout46);
    obj.chkMental_5:setName("chkMental_5");
    obj.chkMental_5:setAlign("left");
    obj.chkMental_5:setWidth(28);
    obj.chkMental_5:setField("stM5");
    obj.chkMental_5:setText("5");
    obj.chkMental_5:setFontSize(8);
    obj.chkMental_5:setVisible(false);

    obj.chkMental_6 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.chkMental_6:setParent(obj.layout46);
    obj.chkMental_6:setName("chkMental_6");
    obj.chkMental_6:setAlign("left");
    obj.chkMental_6:setWidth(28);
    obj.chkMental_6:setField("stM6");
    obj.chkMental_6:setText("6");
    obj.chkMental_6:setFontSize(8);
    obj.chkMental_6:setVisible(false);

    obj.chkMental_7 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.chkMental_7:setParent(obj.layout46);
    obj.chkMental_7:setName("chkMental_7");
    obj.chkMental_7:setAlign("left");
    obj.chkMental_7:setWidth(28);
    obj.chkMental_7:setField("stM7");
    obj.chkMental_7:setText("7");
    obj.chkMental_7:setFontSize(8);
    obj.chkMental_7:setVisible(false);

    obj.chkMental_8 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.chkMental_8:setParent(obj.layout46);
    obj.chkMental_8:setName("chkMental_8");
    obj.chkMental_8:setAlign("left");
    obj.chkMental_8:setWidth(28);
    obj.chkMental_8:setField("stM8");
    obj.chkMental_8:setText("8");
    obj.chkMental_8:setFontSize(8);
    obj.chkMental_8:setVisible(false);

    obj.layout47 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout47:setParent(obj.layout43);
    obj.layout47:setAlign("client");
    obj.layout47:setName("layout47");

    obj.label37 = GUI.fromHandle(_obj_newObject("label"));
    obj.label37:setParent(obj.layout47);
    obj.label37:setText("Consequências");
    obj.label37:setAlign("top");
    obj.label37:setHeight(18);
    obj.label37:setFontSize(9);
    obj.label37:setFontColor("Gray");
    lfm_setPropAsString(obj.label37, "fontStyle", "bold");
    obj.label37:setMargins({bottom=4});
    obj.label37:setName("label37");

    obj.layout48 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout48:setParent(obj.layout47);
    obj.layout48:setAlign("top");
    obj.layout48:setHeight(26);
    obj.layout48:setMargins({bottom=4});
    obj.layout48:setName("layout48");

    obj.label38 = GUI.fromHandle(_obj_newObject("label"));
    obj.label38:setParent(obj.layout48);
    obj.label38:setText("[2] Suave");
    obj.label38:setAlign("left");
    obj.label38:setWidth(72);
    obj.label38:setFontSize(8);
    obj.label38:setFontColor("#b9151f");
    obj.label38:setVertTextAlign("center");
    obj.label38:setName("label38");

    obj.edit70 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit70:setParent(obj.layout48);
    obj.edit70:setAlign("client");
    obj.edit70:setField("cons_suave");
    obj.edit70:setFontSize(10);
    obj.edit70:setName("edit70");

    obj.rowConsCSExtra = GUI.fromHandle(_obj_newObject("layout"));
    obj.rowConsCSExtra:setParent(obj.layout47);
    obj.rowConsCSExtra:setAlign("top");
    obj.rowConsCSExtra:setHeight(26);
    obj.rowConsCSExtra:setName("rowConsCSExtra");
    obj.rowConsCSExtra:setMargins({bottom=4});

    obj.label39 = GUI.fromHandle(_obj_newObject("label"));
    obj.label39:setParent(obj.rowConsCSExtra);
    obj.label39:setText("[2] Suave+");
    obj.label39:setAlign("left");
    obj.label39:setWidth(72);
    obj.label39:setFontSize(8);
    obj.label39:setFontColor("#b9151f");
    obj.label39:setVertTextAlign("center");
    obj.label39:setName("label39");

    obj.edit71 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit71:setParent(obj.rowConsCSExtra);
    obj.edit71:setAlign("client");
    obj.edit71:setField("cons_suaveX");
    obj.edit71:setFontSize(10);
    obj.edit71:setName("edit71");

    obj.layout49 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout49:setParent(obj.layout47);
    obj.layout49:setAlign("top");
    obj.layout49:setHeight(26);
    obj.layout49:setMargins({bottom=4});
    obj.layout49:setName("layout49");

    obj.label40 = GUI.fromHandle(_obj_newObject("label"));
    obj.label40:setParent(obj.layout49);
    obj.label40:setText("[4] Moderada");
    obj.label40:setAlign("left");
    obj.label40:setWidth(72);
    obj.label40:setFontSize(8);
    obj.label40:setFontColor("#b9151f");
    obj.label40:setVertTextAlign("center");
    obj.label40:setName("label40");

    obj.edit72 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit72:setParent(obj.layout49);
    obj.edit72:setAlign("client");
    obj.edit72:setField("cons_moderada");
    obj.edit72:setFontSize(10);
    obj.edit72:setName("edit72");

    obj.layout50 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout50:setParent(obj.layout47);
    obj.layout50:setAlign("top");
    obj.layout50:setHeight(26);
    obj.layout50:setName("layout50");

    obj.label41 = GUI.fromHandle(_obj_newObject("label"));
    obj.label41:setParent(obj.layout50);
    obj.label41:setText("[6] Severa");
    obj.label41:setAlign("left");
    obj.label41:setWidth(72);
    obj.label41:setFontSize(8);
    obj.label41:setFontColor("#b9151f");
    obj.label41:setVertTextAlign("center");
    obj.label41:setName("label41");

    obj.edit73 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit73:setParent(obj.layout50);
    obj.edit73:setAlign("client");
    obj.edit73:setField("cons_severa");
    obj.edit73:setFontSize(10);
    obj.edit73:setName("edit73");

    obj.tab2 = GUI.fromHandle(_obj_newObject("tab"));
    obj.tab2:setParent(obj.tcMain);
    obj.tab2:setTitle("Extras");
    obj.tab2:setName("tab2");

    obj.scrollBox2 = GUI.fromHandle(_obj_newObject("scrollBox"));
    obj.scrollBox2:setParent(obj.tab2);
    obj.scrollBox2:setAlign("client");
    obj.scrollBox2:setName("scrollBox2");

    obj.layout51 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout51:setParent(obj.scrollBox2);
    obj.layout51:setAlign("client");
    obj.layout51:setMargins({left=10, right=10, top=10, bottom=10});
    obj.layout51:setName("layout51");

    obj.label42 = GUI.fromHandle(_obj_newObject("label"));
    obj.label42:setParent(obj.layout51);
    obj.label42:setText("Detalhes dos Extras");
    obj.label42:setAlign("top");
    obj.label42:setHeight(20);
    obj.label42:setFontSize(11);
    lfm_setPropAsString(obj.label42, "fontStyle", "bold");
    obj.label42:setMargins({bottom=8});
    obj.label42:setName("label42");

    obj.layout52 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout52:setParent(obj.layout51);
    obj.layout52:setAlign("top");
    obj.layout52:setHeight(180);
    obj.layout52:setMargins({bottom=12});
    obj.layout52:setName("layout52");

    obj.label43 = GUI.fromHandle(_obj_newObject("label"));
    obj.label43:setParent(obj.layout52);
    obj.label43:setText("Extra 1");
    obj.label43:setAlign("left");
    obj.label43:setWidth(60);
    obj.label43:setFontSize(9);
    obj.label43:setFontColor("Gray");
    lfm_setPropAsString(obj.label43, "fontStyle", "bold");
    obj.label43:setVertTextAlign("leading");
    obj.label43:setMargins({top=4, right=8});
    obj.label43:setName("label43");

    obj.layout53 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout53:setParent(obj.layout52);
    obj.layout53:setAlign("client");
    obj.layout53:setName("layout53");

    obj.label44 = GUI.fromHandle(_obj_newObject("label"));
    obj.label44:setParent(obj.layout53);
    obj.label44:setText("Nome");
    obj.label44:setAlign("top");
    obj.label44:setHeight(14);
    obj.label44:setFontSize(8);
    obj.label44:setFontColor("Gray");
    obj.label44:setName("label44");

    obj.edit74 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit74:setParent(obj.layout53);
    obj.edit74:setAlign("top");
    obj.edit74:setHeight(22);
    obj.edit74:setField("extraD1_nome");
    obj.edit74:setFontSize(11);
    obj.edit74:setMargins({bottom=4});
    obj.edit74:setName("edit74");

    obj.label45 = GUI.fromHandle(_obj_newObject("label"));
    obj.label45:setParent(obj.layout53);
    obj.label45:setText("Permissão");
    obj.label45:setAlign("top");
    obj.label45:setHeight(14);
    obj.label45:setFontSize(8);
    obj.label45:setFontColor("Gray");
    obj.label45:setName("label45");

    obj.edit75 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit75:setParent(obj.layout53);
    obj.edit75:setAlign("top");
    obj.edit75:setHeight(22);
    obj.edit75:setField("extraD1_perm");
    obj.edit75:setFontSize(10);
    obj.edit75:setMargins({bottom=4});
    obj.edit75:setName("edit75");

    obj.label46 = GUI.fromHandle(_obj_newObject("label"));
    obj.label46:setParent(obj.layout53);
    obj.label46:setText("Custo");
    obj.label46:setAlign("top");
    obj.label46:setHeight(14);
    obj.label46:setFontSize(8);
    obj.label46:setFontColor("Gray");
    obj.label46:setName("label46");

    obj.edit76 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit76:setParent(obj.layout53);
    obj.edit76:setAlign("top");
    obj.edit76:setHeight(22);
    obj.edit76:setField("extraD1_custo");
    obj.edit76:setFontSize(10);
    obj.edit76:setMargins({bottom=4});
    obj.edit76:setName("edit76");

    obj.label47 = GUI.fromHandle(_obj_newObject("label"));
    obj.label47:setParent(obj.layout53);
    obj.label47:setText("Descrição");
    obj.label47:setAlign("top");
    obj.label47:setHeight(14);
    obj.label47:setFontSize(8);
    obj.label47:setFontColor("Gray");
    obj.label47:setName("label47");

    obj.textEditor1 = GUI.fromHandle(_obj_newObject("textEditor"));
    obj.textEditor1:setParent(obj.layout53);
    obj.textEditor1:setAlign("client");
    obj.textEditor1:setField("extraD1_desc");
    obj.textEditor1:setFontSize(10);
    obj.textEditor1:setName("textEditor1");

    obj.layout54 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout54:setParent(obj.layout51);
    obj.layout54:setAlign("top");
    obj.layout54:setHeight(180);
    obj.layout54:setMargins({bottom=12});
    obj.layout54:setName("layout54");

    obj.label48 = GUI.fromHandle(_obj_newObject("label"));
    obj.label48:setParent(obj.layout54);
    obj.label48:setText("Extra 2");
    obj.label48:setAlign("left");
    obj.label48:setWidth(60);
    obj.label48:setFontSize(9);
    obj.label48:setFontColor("Gray");
    lfm_setPropAsString(obj.label48, "fontStyle", "bold");
    obj.label48:setVertTextAlign("leading");
    obj.label48:setMargins({top=4, right=8});
    obj.label48:setName("label48");

    obj.layout55 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout55:setParent(obj.layout54);
    obj.layout55:setAlign("client");
    obj.layout55:setName("layout55");

    obj.label49 = GUI.fromHandle(_obj_newObject("label"));
    obj.label49:setParent(obj.layout55);
    obj.label49:setText("Nome");
    obj.label49:setAlign("top");
    obj.label49:setHeight(14);
    obj.label49:setFontSize(8);
    obj.label49:setFontColor("Gray");
    obj.label49:setName("label49");

    obj.edit77 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit77:setParent(obj.layout55);
    obj.edit77:setAlign("top");
    obj.edit77:setHeight(22);
    obj.edit77:setField("extraD2_nome");
    obj.edit77:setFontSize(11);
    obj.edit77:setMargins({bottom=4});
    obj.edit77:setName("edit77");

    obj.label50 = GUI.fromHandle(_obj_newObject("label"));
    obj.label50:setParent(obj.layout55);
    obj.label50:setText("Permissão");
    obj.label50:setAlign("top");
    obj.label50:setHeight(14);
    obj.label50:setFontSize(8);
    obj.label50:setFontColor("Gray");
    obj.label50:setName("label50");

    obj.edit78 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit78:setParent(obj.layout55);
    obj.edit78:setAlign("top");
    obj.edit78:setHeight(22);
    obj.edit78:setField("extraD2_perm");
    obj.edit78:setFontSize(10);
    obj.edit78:setMargins({bottom=4});
    obj.edit78:setName("edit78");

    obj.label51 = GUI.fromHandle(_obj_newObject("label"));
    obj.label51:setParent(obj.layout55);
    obj.label51:setText("Custo");
    obj.label51:setAlign("top");
    obj.label51:setHeight(14);
    obj.label51:setFontSize(8);
    obj.label51:setFontColor("Gray");
    obj.label51:setName("label51");

    obj.edit79 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit79:setParent(obj.layout55);
    obj.edit79:setAlign("top");
    obj.edit79:setHeight(22);
    obj.edit79:setField("extraD2_custo");
    obj.edit79:setFontSize(10);
    obj.edit79:setMargins({bottom=4});
    obj.edit79:setName("edit79");

    obj.label52 = GUI.fromHandle(_obj_newObject("label"));
    obj.label52:setParent(obj.layout55);
    obj.label52:setText("Descrição");
    obj.label52:setAlign("top");
    obj.label52:setHeight(14);
    obj.label52:setFontSize(8);
    obj.label52:setFontColor("Gray");
    obj.label52:setName("label52");

    obj.textEditor2 = GUI.fromHandle(_obj_newObject("textEditor"));
    obj.textEditor2:setParent(obj.layout55);
    obj.textEditor2:setAlign("client");
    obj.textEditor2:setField("extraD2_desc");
    obj.textEditor2:setFontSize(10);
    obj.textEditor2:setName("textEditor2");

    obj.layout56 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout56:setParent(obj.layout51);
    obj.layout56:setAlign("top");
    obj.layout56:setHeight(180);
    obj.layout56:setMargins({bottom=12});
    obj.layout56:setName("layout56");

    obj.label53 = GUI.fromHandle(_obj_newObject("label"));
    obj.label53:setParent(obj.layout56);
    obj.label53:setText("Extra 3");
    obj.label53:setAlign("left");
    obj.label53:setWidth(60);
    obj.label53:setFontSize(9);
    obj.label53:setFontColor("Gray");
    lfm_setPropAsString(obj.label53, "fontStyle", "bold");
    obj.label53:setVertTextAlign("leading");
    obj.label53:setMargins({top=4, right=8});
    obj.label53:setName("label53");

    obj.layout57 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout57:setParent(obj.layout56);
    obj.layout57:setAlign("client");
    obj.layout57:setName("layout57");

    obj.label54 = GUI.fromHandle(_obj_newObject("label"));
    obj.label54:setParent(obj.layout57);
    obj.label54:setText("Nome");
    obj.label54:setAlign("top");
    obj.label54:setHeight(14);
    obj.label54:setFontSize(8);
    obj.label54:setFontColor("Gray");
    obj.label54:setName("label54");

    obj.edit80 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit80:setParent(obj.layout57);
    obj.edit80:setAlign("top");
    obj.edit80:setHeight(22);
    obj.edit80:setField("extraD3_nome");
    obj.edit80:setFontSize(11);
    obj.edit80:setMargins({bottom=4});
    obj.edit80:setName("edit80");

    obj.label55 = GUI.fromHandle(_obj_newObject("label"));
    obj.label55:setParent(obj.layout57);
    obj.label55:setText("Permissão");
    obj.label55:setAlign("top");
    obj.label55:setHeight(14);
    obj.label55:setFontSize(8);
    obj.label55:setFontColor("Gray");
    obj.label55:setName("label55");

    obj.edit81 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit81:setParent(obj.layout57);
    obj.edit81:setAlign("top");
    obj.edit81:setHeight(22);
    obj.edit81:setField("extraD3_perm");
    obj.edit81:setFontSize(10);
    obj.edit81:setMargins({bottom=4});
    obj.edit81:setName("edit81");

    obj.label56 = GUI.fromHandle(_obj_newObject("label"));
    obj.label56:setParent(obj.layout57);
    obj.label56:setText("Custo");
    obj.label56:setAlign("top");
    obj.label56:setHeight(14);
    obj.label56:setFontSize(8);
    obj.label56:setFontColor("Gray");
    obj.label56:setName("label56");

    obj.edit82 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit82:setParent(obj.layout57);
    obj.edit82:setAlign("top");
    obj.edit82:setHeight(22);
    obj.edit82:setField("extraD3_custo");
    obj.edit82:setFontSize(10);
    obj.edit82:setMargins({bottom=4});
    obj.edit82:setName("edit82");

    obj.label57 = GUI.fromHandle(_obj_newObject("label"));
    obj.label57:setParent(obj.layout57);
    obj.label57:setText("Descrição");
    obj.label57:setAlign("top");
    obj.label57:setHeight(14);
    obj.label57:setFontSize(8);
    obj.label57:setFontColor("Gray");
    obj.label57:setName("label57");

    obj.textEditor3 = GUI.fromHandle(_obj_newObject("textEditor"));
    obj.textEditor3:setParent(obj.layout57);
    obj.textEditor3:setAlign("client");
    obj.textEditor3:setField("extraD3_desc");
    obj.textEditor3:setFontSize(10);
    obj.textEditor3:setName("textEditor3");

    obj.layout58 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout58:setParent(obj.layout51);
    obj.layout58:setAlign("top");
    obj.layout58:setHeight(180);
    obj.layout58:setMargins({bottom=12});
    obj.layout58:setName("layout58");

    obj.label58 = GUI.fromHandle(_obj_newObject("label"));
    obj.label58:setParent(obj.layout58);
    obj.label58:setText("Extra 4");
    obj.label58:setAlign("left");
    obj.label58:setWidth(60);
    obj.label58:setFontSize(9);
    obj.label58:setFontColor("Gray");
    lfm_setPropAsString(obj.label58, "fontStyle", "bold");
    obj.label58:setVertTextAlign("leading");
    obj.label58:setMargins({top=4, right=8});
    obj.label58:setName("label58");

    obj.layout59 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout59:setParent(obj.layout58);
    obj.layout59:setAlign("client");
    obj.layout59:setName("layout59");

    obj.label59 = GUI.fromHandle(_obj_newObject("label"));
    obj.label59:setParent(obj.layout59);
    obj.label59:setText("Nome");
    obj.label59:setAlign("top");
    obj.label59:setHeight(14);
    obj.label59:setFontSize(8);
    obj.label59:setFontColor("Gray");
    obj.label59:setName("label59");

    obj.edit83 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit83:setParent(obj.layout59);
    obj.edit83:setAlign("top");
    obj.edit83:setHeight(22);
    obj.edit83:setField("extraD4_nome");
    obj.edit83:setFontSize(11);
    obj.edit83:setMargins({bottom=4});
    obj.edit83:setName("edit83");

    obj.label60 = GUI.fromHandle(_obj_newObject("label"));
    obj.label60:setParent(obj.layout59);
    obj.label60:setText("Permissão");
    obj.label60:setAlign("top");
    obj.label60:setHeight(14);
    obj.label60:setFontSize(8);
    obj.label60:setFontColor("Gray");
    obj.label60:setName("label60");

    obj.edit84 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit84:setParent(obj.layout59);
    obj.edit84:setAlign("top");
    obj.edit84:setHeight(22);
    obj.edit84:setField("extraD4_perm");
    obj.edit84:setFontSize(10);
    obj.edit84:setMargins({bottom=4});
    obj.edit84:setName("edit84");

    obj.label61 = GUI.fromHandle(_obj_newObject("label"));
    obj.label61:setParent(obj.layout59);
    obj.label61:setText("Custo");
    obj.label61:setAlign("top");
    obj.label61:setHeight(14);
    obj.label61:setFontSize(8);
    obj.label61:setFontColor("Gray");
    obj.label61:setName("label61");

    obj.edit85 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit85:setParent(obj.layout59);
    obj.edit85:setAlign("top");
    obj.edit85:setHeight(22);
    obj.edit85:setField("extraD4_custo");
    obj.edit85:setFontSize(10);
    obj.edit85:setMargins({bottom=4});
    obj.edit85:setName("edit85");

    obj.label62 = GUI.fromHandle(_obj_newObject("label"));
    obj.label62:setParent(obj.layout59);
    obj.label62:setText("Descrição");
    obj.label62:setAlign("top");
    obj.label62:setHeight(14);
    obj.label62:setFontSize(8);
    obj.label62:setFontColor("Gray");
    obj.label62:setName("label62");

    obj.textEditor4 = GUI.fromHandle(_obj_newObject("textEditor"));
    obj.textEditor4:setParent(obj.layout59);
    obj.textEditor4:setAlign("client");
    obj.textEditor4:setField("extraD4_desc");
    obj.textEditor4:setFontSize(10);
    obj.textEditor4:setName("textEditor4");

    obj.layout60 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout60:setParent(obj.layout51);
    obj.layout60:setAlign("top");
    obj.layout60:setHeight(180);
    obj.layout60:setMargins({bottom=12});
    obj.layout60:setName("layout60");

    obj.label63 = GUI.fromHandle(_obj_newObject("label"));
    obj.label63:setParent(obj.layout60);
    obj.label63:setText("Extra 5");
    obj.label63:setAlign("left");
    obj.label63:setWidth(60);
    obj.label63:setFontSize(9);
    obj.label63:setFontColor("Gray");
    lfm_setPropAsString(obj.label63, "fontStyle", "bold");
    obj.label63:setVertTextAlign("leading");
    obj.label63:setMargins({top=4, right=8});
    obj.label63:setName("label63");

    obj.layout61 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout61:setParent(obj.layout60);
    obj.layout61:setAlign("client");
    obj.layout61:setName("layout61");

    obj.label64 = GUI.fromHandle(_obj_newObject("label"));
    obj.label64:setParent(obj.layout61);
    obj.label64:setText("Nome");
    obj.label64:setAlign("top");
    obj.label64:setHeight(14);
    obj.label64:setFontSize(8);
    obj.label64:setFontColor("Gray");
    obj.label64:setName("label64");

    obj.edit86 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit86:setParent(obj.layout61);
    obj.edit86:setAlign("top");
    obj.edit86:setHeight(22);
    obj.edit86:setField("extraD5_nome");
    obj.edit86:setFontSize(11);
    obj.edit86:setMargins({bottom=4});
    obj.edit86:setName("edit86");

    obj.label65 = GUI.fromHandle(_obj_newObject("label"));
    obj.label65:setParent(obj.layout61);
    obj.label65:setText("Permissão");
    obj.label65:setAlign("top");
    obj.label65:setHeight(14);
    obj.label65:setFontSize(8);
    obj.label65:setFontColor("Gray");
    obj.label65:setName("label65");

    obj.edit87 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit87:setParent(obj.layout61);
    obj.edit87:setAlign("top");
    obj.edit87:setHeight(22);
    obj.edit87:setField("extraD5_perm");
    obj.edit87:setFontSize(10);
    obj.edit87:setMargins({bottom=4});
    obj.edit87:setName("edit87");

    obj.label66 = GUI.fromHandle(_obj_newObject("label"));
    obj.label66:setParent(obj.layout61);
    obj.label66:setText("Custo");
    obj.label66:setAlign("top");
    obj.label66:setHeight(14);
    obj.label66:setFontSize(8);
    obj.label66:setFontColor("Gray");
    obj.label66:setName("label66");

    obj.edit88 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit88:setParent(obj.layout61);
    obj.edit88:setAlign("top");
    obj.edit88:setHeight(22);
    obj.edit88:setField("extraD5_custo");
    obj.edit88:setFontSize(10);
    obj.edit88:setMargins({bottom=4});
    obj.edit88:setName("edit88");

    obj.label67 = GUI.fromHandle(_obj_newObject("label"));
    obj.label67:setParent(obj.layout61);
    obj.label67:setText("Descrição");
    obj.label67:setAlign("top");
    obj.label67:setHeight(14);
    obj.label67:setFontSize(8);
    obj.label67:setFontColor("Gray");
    obj.label67:setName("label67");

    obj.textEditor5 = GUI.fromHandle(_obj_newObject("textEditor"));
    obj.textEditor5:setParent(obj.layout61);
    obj.textEditor5:setAlign("client");
    obj.textEditor5:setField("extraD5_desc");
    obj.textEditor5:setFontSize(10);
    obj.textEditor5:setName("textEditor5");

    obj.layout62 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout62:setParent(obj.layout51);
    obj.layout62:setAlign("top");
    obj.layout62:setHeight(180);
    obj.layout62:setName("layout62");

    obj.label68 = GUI.fromHandle(_obj_newObject("label"));
    obj.label68:setParent(obj.layout62);
    obj.label68:setText("Extra 6");
    obj.label68:setAlign("left");
    obj.label68:setWidth(60);
    obj.label68:setFontSize(9);
    obj.label68:setFontColor("Gray");
    lfm_setPropAsString(obj.label68, "fontStyle", "bold");
    obj.label68:setVertTextAlign("leading");
    obj.label68:setMargins({top=4, right=8});
    obj.label68:setName("label68");

    obj.layout63 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout63:setParent(obj.layout62);
    obj.layout63:setAlign("client");
    obj.layout63:setName("layout63");

    obj.label69 = GUI.fromHandle(_obj_newObject("label"));
    obj.label69:setParent(obj.layout63);
    obj.label69:setText("Nome");
    obj.label69:setAlign("top");
    obj.label69:setHeight(14);
    obj.label69:setFontSize(8);
    obj.label69:setFontColor("Gray");
    obj.label69:setName("label69");

    obj.edit89 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit89:setParent(obj.layout63);
    obj.edit89:setAlign("top");
    obj.edit89:setHeight(22);
    obj.edit89:setField("extraD6_nome");
    obj.edit89:setFontSize(11);
    obj.edit89:setMargins({bottom=4});
    obj.edit89:setName("edit89");

    obj.label70 = GUI.fromHandle(_obj_newObject("label"));
    obj.label70:setParent(obj.layout63);
    obj.label70:setText("Permissão");
    obj.label70:setAlign("top");
    obj.label70:setHeight(14);
    obj.label70:setFontSize(8);
    obj.label70:setFontColor("Gray");
    obj.label70:setName("label70");

    obj.edit90 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit90:setParent(obj.layout63);
    obj.edit90:setAlign("top");
    obj.edit90:setHeight(22);
    obj.edit90:setField("extraD6_perm");
    obj.edit90:setFontSize(10);
    obj.edit90:setMargins({bottom=4});
    obj.edit90:setName("edit90");

    obj.label71 = GUI.fromHandle(_obj_newObject("label"));
    obj.label71:setParent(obj.layout63);
    obj.label71:setText("Custo");
    obj.label71:setAlign("top");
    obj.label71:setHeight(14);
    obj.label71:setFontSize(8);
    obj.label71:setFontColor("Gray");
    obj.label71:setName("label71");

    obj.edit91 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit91:setParent(obj.layout63);
    obj.edit91:setAlign("top");
    obj.edit91:setHeight(22);
    obj.edit91:setField("extraD6_custo");
    obj.edit91:setFontSize(10);
    obj.edit91:setMargins({bottom=4});
    obj.edit91:setName("edit91");

    obj.label72 = GUI.fromHandle(_obj_newObject("label"));
    obj.label72:setParent(obj.layout63);
    obj.label72:setText("Descrição");
    obj.label72:setAlign("top");
    obj.label72:setHeight(14);
    obj.label72:setFontSize(8);
    obj.label72:setFontColor("Gray");
    obj.label72:setName("label72");

    obj.textEditor6 = GUI.fromHandle(_obj_newObject("textEditor"));
    obj.textEditor6:setParent(obj.layout63);
    obj.textEditor6:setAlign("client");
    obj.textEditor6:setField("extraD6_desc");
    obj.textEditor6:setFontSize(10);
    obj.textEditor6:setName("textEditor6");

    obj.tab3 = GUI.fromHandle(_obj_newObject("tab"));
    obj.tab3:setParent(obj.tcMain);
    obj.tab3:setTitle("Configuração");
    obj.tab3:setName("tab3");

    obj.scrollBox3 = GUI.fromHandle(_obj_newObject("scrollBox"));
    obj.scrollBox3:setParent(obj.tab3);
    obj.scrollBox3:setAlign("client");
    obj.scrollBox3:setName("scrollBox3");

    obj.layout64 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout64:setParent(obj.scrollBox3);
    obj.layout64:setAlign("client");
    obj.layout64:setMargins({left=12, right=12, top=12, bottom=12});
    obj.layout64:setName("layout64");

    obj.label73 = GUI.fromHandle(_obj_newObject("label"));
    obj.label73:setParent(obj.layout64);
    obj.label73:setText("Escada de Perícias");
    obj.label73:setAlign("top");
    obj.label73:setHeight(20);
    lfm_setPropAsString(obj.label73, "fontStyle", "bold");
    obj.label73:setFontSize(13);
    obj.label73:setName("label73");

    obj.label74 = GUI.fromHandle(_obj_newObject("label"));
    obj.label74:setParent(obj.layout64);
    obj.label74:setText("Define quais níveis da escada aparecem na ficha.");
    obj.label74:setAlign("top");
    obj.label74:setHeight(16);
    obj.label74:setFontSize(11);
    obj.label74:setFontColor("Gray");
    obj.label74:setMargins({bottom=8});
    obj.label74:setName("label74");

    obj.layout65 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout65:setParent(obj.layout64);
    obj.layout65:setAlign("top");
    obj.layout65:setHeight(28);
    obj.layout65:setMargins({bottom=8});
    obj.layout65:setName("layout65");

    obj.label75 = GUI.fromHandle(_obj_newObject("label"));
    obj.label75:setParent(obj.layout65);
    obj.label75:setText("Nível mínimo (+1 a +4)");
    obj.label75:setAlign("left");
    obj.label75:setWidth(180);
    obj.label75:setFontSize(11);
    obj.label75:setVertTextAlign("center");
    obj.label75:setName("label75");

    obj.edit92 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit92:setParent(obj.layout65);
    obj.edit92:setAlign("client");
    obj.edit92:setField("cfg_escadaMin");
    obj.edit92:setHint("1");
    obj.edit92:setHorzTextAlign("center");
    obj.edit92:setName("edit92");

    obj.layout66 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout66:setParent(obj.layout64);
    obj.layout66:setAlign("top");
    obj.layout66:setHeight(28);
    obj.layout66:setMargins({bottom=16});
    obj.layout66:setName("layout66");

    obj.label76 = GUI.fromHandle(_obj_newObject("label"));
    obj.label76:setParent(obj.layout66);
    obj.label76:setText("Nível máximo (+2 a +8)");
    obj.label76:setAlign("left");
    obj.label76:setWidth(180);
    obj.label76:setFontSize(11);
    obj.label76:setVertTextAlign("center");
    obj.label76:setName("label76");

    obj.edit93 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit93:setParent(obj.layout66);
    obj.edit93:setAlign("client");
    obj.edit93:setField("cfg_escadaMax");
    obj.edit93:setHint("5");
    obj.edit93:setHorzTextAlign("center");
    obj.edit93:setName("edit93");

    obj.label77 = GUI.fromHandle(_obj_newObject("label"));
    obj.label77:setParent(obj.layout64);
    obj.label77:setText("Aspectos");
    obj.label77:setAlign("top");
    obj.label77:setHeight(20);
    lfm_setPropAsString(obj.label77, "fontStyle", "bold");
    obj.label77:setFontSize(13);
    obj.label77:setName("label77");

    obj.layout67 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout67:setParent(obj.layout64);
    obj.layout67:setAlign("top");
    obj.layout67:setHeight(28);
    obj.layout67:setMargins({bottom=16, top=4});
    obj.layout67:setName("layout67");

    obj.label78 = GUI.fromHandle(_obj_newObject("label"));
    obj.label78:setParent(obj.layout67);
    obj.label78:setText("Aspectos livres (1 a 7)");
    obj.label78:setAlign("left");
    obj.label78:setWidth(180);
    obj.label78:setFontSize(11);
    obj.label78:setVertTextAlign("center");
    obj.label78:setName("label78");

    obj.edit94 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit94:setParent(obj.layout67);
    obj.edit94:setAlign("client");
    obj.edit94:setField("cfg_aspectos");
    obj.edit94:setHint("3");
    obj.edit94:setHorzTextAlign("center");
    obj.edit94:setName("edit94");

    obj.label79 = GUI.fromHandle(_obj_newObject("label"));
    obj.label79:setParent(obj.layout64);
    obj.label79:setText("Façanhas e Extras");
    obj.label79:setAlign("top");
    obj.label79:setHeight(20);
    lfm_setPropAsString(obj.label79, "fontStyle", "bold");
    obj.label79:setFontSize(13);
    obj.label79:setName("label79");

    obj.layout68 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout68:setParent(obj.layout64);
    obj.layout68:setAlign("top");
    obj.layout68:setHeight(28);
    obj.layout68:setMargins({bottom=4, top=4});
    obj.layout68:setName("layout68");

    obj.label80 = GUI.fromHandle(_obj_newObject("label"));
    obj.label80:setParent(obj.layout68);
    obj.label80:setText("Linhas de façanhas (1 a 10)");
    obj.label80:setAlign("left");
    obj.label80:setWidth(180);
    obj.label80:setFontSize(11);
    obj.label80:setVertTextAlign("center");
    obj.label80:setName("label80");

    obj.edit95 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit95:setParent(obj.layout68);
    obj.edit95:setAlign("client");
    obj.edit95:setField("cfg_facanhas");
    obj.edit95:setHint("6");
    obj.edit95:setHorzTextAlign("center");
    obj.edit95:setName("edit95");

    obj.layout69 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout69:setParent(obj.layout64);
    obj.layout69:setAlign("top");
    obj.layout69:setHeight(28);
    obj.layout69:setMargins({bottom=16});
    obj.layout69:setName("layout69");

    obj.label81 = GUI.fromHandle(_obj_newObject("label"));
    obj.label81:setParent(obj.layout69);
    obj.label81:setText("Linhas de extras (1 a 10)");
    obj.label81:setAlign("left");
    obj.label81:setWidth(180);
    obj.label81:setFontSize(11);
    obj.label81:setVertTextAlign("center");
    obj.label81:setName("label81");

    obj.edit96 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit96:setParent(obj.layout69);
    obj.edit96:setAlign("client");
    obj.edit96:setField("cfg_extrasL");
    obj.edit96:setHint("6");
    obj.edit96:setHorzTextAlign("center");
    obj.edit96:setName("edit96");

    obj.label82 = GUI.fromHandle(_obj_newObject("label"));
    obj.label82:setParent(obj.layout64);
    obj.label82:setText("Estresse");
    obj.label82:setAlign("top");
    obj.label82:setHeight(20);
    lfm_setPropAsString(obj.label82, "fontStyle", "bold");
    obj.label82:setFontSize(13);
    obj.label82:setName("label82");

    obj.layout70 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout70:setParent(obj.layout64);
    obj.layout70:setAlign("top");
    obj.layout70:setHeight(28);
    obj.layout70:setMargins({bottom=4, top=4});
    obj.layout70:setName("layout70");

    obj.label83 = GUI.fromHandle(_obj_newObject("label"));
    obj.label83:setParent(obj.layout70);
    obj.label83:setText("Caixas Físico (2 a 8)");
    obj.label83:setAlign("left");
    obj.label83:setWidth(180);
    obj.label83:setFontSize(11);
    obj.label83:setVertTextAlign("center");
    obj.label83:setName("label83");

    obj.edit97 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit97:setParent(obj.layout70);
    obj.edit97:setAlign("client");
    obj.edit97:setField("cfg_fisico");
    obj.edit97:setHint("4");
    obj.edit97:setHorzTextAlign("center");
    obj.edit97:setName("edit97");

    obj.layout71 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout71:setParent(obj.layout64);
    obj.layout71:setAlign("top");
    obj.layout71:setHeight(28);
    obj.layout71:setMargins({bottom=16});
    obj.layout71:setName("layout71");

    obj.label84 = GUI.fromHandle(_obj_newObject("label"));
    obj.label84:setParent(obj.layout71);
    obj.label84:setText("Caixas Mental (2 a 8)");
    obj.label84:setAlign("left");
    obj.label84:setWidth(180);
    obj.label84:setFontSize(11);
    obj.label84:setVertTextAlign("center");
    obj.label84:setName("label84");

    obj.edit98 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit98:setParent(obj.layout71);
    obj.edit98:setAlign("client");
    obj.edit98:setField("cfg_mental");
    obj.edit98:setHint("4");
    obj.edit98:setHorzTextAlign("center");
    obj.edit98:setName("edit98");

    obj.label85 = GUI.fromHandle(_obj_newObject("label"));
    obj.label85:setParent(obj.layout64);
    obj.label85:setText("Consequências");
    obj.label85:setAlign("top");
    obj.label85:setHeight(20);
    lfm_setPropAsString(obj.label85, "fontStyle", "bold");
    obj.label85:setFontSize(13);
    obj.label85:setName("label85");

    obj.layout72 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout72:setParent(obj.layout64);
    obj.layout72:setAlign("top");
    obj.layout72:setHeight(28);
    obj.layout72:setMargins({top=4});
    obj.layout72:setName("layout72");

    obj.label86 = GUI.fromHandle(_obj_newObject("label"));
    obj.label86:setParent(obj.layout72);
    obj.label86:setText("Consequência Suave extra");
    obj.label86:setAlign("left");
    obj.label86:setWidth(200);
    obj.label86:setFontSize(11);
    obj.label86:setVertTextAlign("center");
    obj.label86:setName("label86");

    obj.checkBox1 = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.checkBox1:setParent(obj.layout72);
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

    obj._e_event19 = obj.edit92:addEventListener("onExit",
        function ()
            aplicarConfig()
        end);

    obj._e_event20 = obj.edit93:addEventListener("onExit",
        function ()
            aplicarConfig()
        end);

    obj._e_event21 = obj.edit94:addEventListener("onExit",
        function ()
            aplicarConfig()
        end);

    obj._e_event22 = obj.edit95:addEventListener("onExit",
        function ()
            aplicarConfig()
        end);

    obj._e_event23 = obj.edit96:addEventListener("onExit",
        function ()
            aplicarConfig()
        end);

    obj._e_event24 = obj.edit97:addEventListener("onExit",
        function ()
            aplicarConfig()
        end);

    obj._e_event25 = obj.edit98:addEventListener("onExit",
        function ()
            aplicarConfig()
        end);

    obj._e_event26 = obj.checkBox1:addEventListener("onChange",
        function ()
            aplicarConfig()
        end);

    function obj:_releaseEvents()
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
        if self.edit90 ~= nil then self.edit90:destroy(); self.edit90 = nil; end;
        if self.edit77 ~= nil then self.edit77:destroy(); self.edit77 = nil; end;
        if self.edit47 ~= nil then self.edit47:destroy(); self.edit47 = nil; end;
        if self.rowExtraL_4 ~= nil then self.rowExtraL_4:destroy(); self.rowExtraL_4 = nil; end;
        if self.layout11 ~= nil then self.layout11:destroy(); self.layout11 = nil; end;
        if self.chkFisico_4 ~= nil then self.chkFisico_4:destroy(); self.chkFisico_4 = nil; end;
        if self.chkMental_5 ~= nil then self.chkMental_5:destroy(); self.chkMental_5 = nil; end;
        if self.edit30 ~= nil then self.edit30:destroy(); self.edit30 = nil; end;
        if self.label37 ~= nil then self.label37:destroy(); self.label37 = nil; end;
        if self.layout3 ~= nil then self.layout3:destroy(); self.layout3 = nil; end;
        if self.edit88 ~= nil then self.edit88:destroy(); self.edit88 = nil; end;
        if self.edit70 ~= nil then self.edit70:destroy(); self.edit70 = nil; end;
        if self.edit42 ~= nil then self.edit42:destroy(); self.edit42 = nil; end;
        if self.rowExtraL_1 ~= nil then self.rowExtraL_1:destroy(); self.rowExtraL_1 = nil; end;
        if self.layout43 ~= nil then self.layout43:destroy(); self.layout43 = nil; end;
        if self.edit95 ~= nil then self.edit95:destroy(); self.edit95 = nil; end;
        if self.button11 ~= nil then self.button11:destroy(); self.button11 = nil; end;
        if self.edit35 ~= nil then self.edit35:destroy(); self.edit35 = nil; end;
        if self.layout70 ~= nil then self.layout70:destroy(); self.layout70 = nil; end;
        if self.edit49 ~= nil then self.edit49:destroy(); self.edit49 = nil; end;
        if self.layout46 ~= nil then self.layout46:destroy(); self.layout46 = nil; end;
        if self.label82 ~= nil then self.label82:destroy(); self.label82 = nil; end;
        if self.label67 ~= nil then self.label67:destroy(); self.label67 = nil; end;
        if self.edit82 ~= nil then self.edit82:destroy(); self.edit82 = nil; end;
        if self.edit27 ~= nil then self.edit27:destroy(); self.edit27 = nil; end;
        if self.checkBox1 ~= nil then self.checkBox1:destroy(); self.checkBox1 = nil; end;
        if self.label10 ~= nil then self.label10:destroy(); self.label10 = nil; end;
        if self.label22 ~= nil then self.label22:destroy(); self.label22 = nil; end;
        if self.edit14 ~= nil then self.edit14:destroy(); self.edit14 = nil; end;
        if self.rowNivel_5 ~= nil then self.rowNivel_5:destroy(); self.rowNivel_5 = nil; end;
        if self.edit59 ~= nil then self.edit59:destroy(); self.edit59 = nil; end;
        if self.layout49 ~= nil then self.layout49:destroy(); self.layout49 = nil; end;
        if self.edit9 ~= nil then self.edit9:destroy(); self.edit9 = nil; end;
        if self.label62 ~= nil then self.label62:destroy(); self.label62 = nil; end;
        if self.edit65 ~= nil then self.edit65:destroy(); self.edit65 = nil; end;
        if self.layout37 ~= nil then self.layout37:destroy(); self.layout37 = nil; end;
        if self.label85 ~= nil then self.label85:destroy(); self.label85 = nil; end;
        if self.label15 ~= nil then self.label15:destroy(); self.label15 = nil; end;
        if self.label29 ~= nil then self.label29:destroy(); self.label29 = nil; end;
        if self.label56 ~= nil then self.label56:destroy(); self.label56 = nil; end;
        if self.edit56 ~= nil then self.edit56:destroy(); self.edit56 = nil; end;
        if self.layout59 ~= nil then self.layout59:destroy(); self.layout59 = nil; end;
        if self.label69 ~= nil then self.label69:destroy(); self.label69 = nil; end;
        if self.edit60 ~= nil then self.edit60:destroy(); self.edit60 = nil; end;
        if self.layout25 ~= nil then self.layout25:destroy(); self.layout25 = nil; end;
        if self.label53 ~= nil then self.label53:destroy(); self.label53 = nil; end;
        if self.edit53 ~= nil then self.edit53:destroy(); self.edit53 = nil; end;
        if self.layout52 ~= nil then self.layout52:destroy(); self.layout52 = nil; end;
        if self.rowAspecto_6 ~= nil then self.rowAspecto_6:destroy(); self.rowAspecto_6 = nil; end;
        if self.edit3 ~= nil then self.edit3:destroy(); self.edit3 = nil; end;
        if self.button8 ~= nil then self.button8:destroy(); self.button8 = nil; end;
        if self.label39 ~= nil then self.label39:destroy(); self.label39 = nil; end;
        if self.layout20 ~= nil then self.layout20:destroy(); self.layout20 = nil; end;
        if self.layout60 ~= nil then self.layout60:destroy(); self.layout60 = nil; end;
        if self.label79 ~= nil then self.label79:destroy(); self.label79 = nil; end;
        if self.label45 ~= nil then self.label45:destroy(); self.label45 = nil; end;
        if self.tab1 ~= nil then self.tab1:destroy(); self.tab1 = nil; end;
        if self.layout57 ~= nil then self.layout57:destroy(); self.layout57 = nil; end;
        if self.layout18 ~= nil then self.layout18:destroy(); self.layout18 = nil; end;
        if self.edit6 ~= nil then self.edit6:destroy(); self.edit6 = nil; end;
        if self.button3 ~= nil then self.button3:destroy(); self.button3 = nil; end;
        if self.rowAspecto_1 ~= nil then self.rowAspecto_1:destroy(); self.rowAspecto_1 = nil; end;
        if self.rowFacanha_5 ~= nil then self.rowFacanha_5:destroy(); self.rowFacanha_5 = nil; end;
        if self.image1 ~= nil then self.image1:destroy(); self.image1 = nil; end;
        if self.label76 ~= nil then self.label76:destroy(); self.label76 = nil; end;
        if self.layout67 ~= nil then self.layout67:destroy(); self.layout67 = nil; end;
        if self.label40 ~= nil then self.label40:destroy(); self.label40 = nil; end;
        if self.label9 ~= nil then self.label9:destroy(); self.label9 = nil; end;
        if self.layout15 ~= nil then self.layout15:destroy(); self.layout15 = nil; end;
        if self.button18 ~= nil then self.button18:destroy(); self.button18 = nil; end;
        if self.button6 ~= nil then self.button6:destroy(); self.button6 = nil; end;
        if self.label33 ~= nil then self.label33:destroy(); self.label33 = nil; end;
        if self.label73 ~= nil then self.label73:destroy(); self.label73 = nil; end;
        if self.layout7 ~= nil then self.layout7:destroy(); self.layout7 = nil; end;
        if self.edit91 ~= nil then self.edit91:destroy(); self.edit91 = nil; end;
        if self.edit74 ~= nil then self.edit74:destroy(); self.edit74 = nil; end;
        if self.edit46 ~= nil then self.edit46:destroy(); self.edit46 = nil; end;
        if self.rowExtraL_5 ~= nil then self.rowExtraL_5:destroy(); self.rowExtraL_5 = nil; end;
        if self.chkMental_4 ~= nil then self.chkMental_4:destroy(); self.chkMental_4 = nil; end;
        if self.edit31 ~= nil then self.edit31:destroy(); self.edit31 = nil; end;
        if self.layout2 ~= nil then self.layout2:destroy(); self.layout2 = nil; end;
        if self.edit96 ~= nil then self.edit96:destroy(); self.edit96 = nil; end;
        if self.edit71 ~= nil then self.edit71:destroy(); self.edit71 = nil; end;
        if self.layout42 ~= nil then self.layout42:destroy(); self.layout42 = nil; end;
        if self.label7 ~= nil then self.label7:destroy(); self.label7 = nil; end;
        if self.button16 ~= nil then self.button16:destroy(); self.button16 = nil; end;
        if self.chkMental_3 ~= nil then self.chkMental_3:destroy(); self.chkMental_3 = nil; end;
        if self.edit23 ~= nil then self.edit23:destroy(); self.edit23 = nil; end;
        if self.layout71 ~= nil then self.layout71:destroy(); self.layout71 = nil; end;
        if self.edit48 ~= nil then self.edit48:destroy(); self.edit48 = nil; end;
        if self.layout45 ~= nil then self.layout45:destroy(); self.layout45 = nil; end;
        if self.edit10 ~= nil then self.edit10:destroy(); self.edit10 = nil; end;
        if self.rowNivel_1 ~= nil then self.rowNivel_1:destroy(); self.rowNivel_1 = nil; end;
        if self.label81 ~= nil then self.label81:destroy(); self.label81 = nil; end;
        if self.label66 ~= nil then self.label66:destroy(); self.label66 = nil; end;
        if self.edit85 ~= nil then self.edit85:destroy(); self.edit85 = nil; end;
        if self.edit26 ~= nil then self.edit26:destroy(); self.edit26 = nil; end;
        if self.label11 ~= nil then self.label11:destroy(); self.label11 = nil; end;
        if self.label25 ~= nil then self.label25:destroy(); self.label25 = nil; end;
        if self.edit15 ~= nil then self.edit15:destroy(); self.edit15 = nil; end;
        if self.rowNivel_6 ~= nil then self.rowNivel_6:destroy(); self.rowNivel_6 = nil; end;
        if self.layout48 ~= nil then self.layout48:destroy(); self.layout48 = nil; end;
        if self.label84 ~= nil then self.label84:destroy(); self.label84 = nil; end;
        if self.edit8 ~= nil then self.edit8:destroy(); self.edit8 = nil; end;
        if self.edit29 ~= nil then self.edit29:destroy(); self.edit29 = nil; end;
        if self.edit64 ~= nil then self.edit64:destroy(); self.edit64 = nil; end;
        if self.layout30 ~= nil then self.layout30:destroy(); self.layout30 = nil; end;
        if self.label28 ~= nil then self.label28:destroy(); self.label28 = nil; end;
        if self.label57 ~= nil then self.label57:destroy(); self.label57 = nil; end;
        if self.edit57 ~= nil then self.edit57:destroy(); self.edit57 = nil; end;
        if self.textEditor3 ~= nil then self.textEditor3:destroy(); self.textEditor3 = nil; end;
        if self.label68 ~= nil then self.label68:destroy(); self.label68 = nil; end;
        if self.layout24 ~= nil then self.layout24:destroy(); self.layout24 = nil; end;
        if self.scrollBox1 ~= nil then self.scrollBox1:destroy(); self.scrollBox1 = nil; end;
        if self.label50 ~= nil then self.label50:destroy(); self.label50 = nil; end;
        if self.textEditor6 ~= nil then self.textEditor6:destroy(); self.textEditor6 = nil; end;
        if self.layout53 ~= nil then self.layout53:destroy(); self.layout53 = nil; end;
        if self.rowAspecto_5 ~= nil then self.rowAspecto_5:destroy(); self.rowAspecto_5 = nil; end;
        if self.edit2 ~= nil then self.edit2:destroy(); self.edit2 = nil; end;
        if self.rowFacanha_1 ~= nil then self.rowFacanha_1:destroy(); self.rowFacanha_1 = nil; end;
        if self.layout63 ~= nil then self.layout63:destroy(); self.layout63 = nil; end;
        if self.layout23 ~= nil then self.layout23:destroy(); self.layout23 = nil; end;
        if self.label44 ~= nil then self.label44:destroy(); self.label44 = nil; end;
        if self.layout54 ~= nil then self.layout54:destroy(); self.layout54 = nil; end;
        if self.layout19 ~= nil then self.layout19:destroy(); self.layout19 = nil; end;
        if self.layout66 ~= nil then self.layout66:destroy(); self.layout66 = nil; end;
        if self.button2 ~= nil then self.button2:destroy(); self.button2 = nil; end;
        if self.edit38 ~= nil then self.edit38:destroy(); self.edit38 = nil; end;
        if self.label77 ~= nil then self.label77:destroy(); self.label77 = nil; end;
        if self.edit78 ~= nil then self.edit78:destroy(); self.edit78 = nil; end;
        if self.label8 ~= nil then self.label8:destroy(); self.label8 = nil; end;
        if self.layout12 ~= nil then self.layout12:destroy(); self.layout12 = nil; end;
        if self.label34 ~= nil then self.label34:destroy(); self.label34 = nil; end;
        if self.button5 ~= nil then self.button5:destroy(); self.button5 = nil; end;
        if self.chkFisico_7 ~= nil then self.chkFisico_7:destroy(); self.chkFisico_7 = nil; end;
        if self.chkMental_8 ~= nil then self.chkMental_8:destroy(); self.chkMental_8 = nil; end;
        if self.layout6 ~= nil then self.layout6:destroy(); self.layout6 = nil; end;
        if self.edit92 ~= nil then self.edit92:destroy(); self.edit92 = nil; end;
        if self.edit75 ~= nil then self.edit75:destroy(); self.edit75 = nil; end;
        if self.edit41 ~= nil then self.edit41:destroy(); self.edit41 = nil; end;
        if self.rowExtraL_2 ~= nil then self.rowExtraL_2:destroy(); self.rowExtraL_2 = nil; end;
        if self.label3 ~= nil then self.label3:destroy(); self.label3 = nil; end;
        if self.button12 ~= nil then self.button12:destroy(); self.button12 = nil; end;
        if self.chkMental_7 ~= nil then self.chkMental_7:destroy(); self.chkMental_7 = nil; end;
        if self.edit36 ~= nil then self.edit36:destroy(); self.edit36 = nil; end;
        if self.rowConsCSExtra ~= nil then self.rowConsCSExtra:destroy(); self.rowConsCSExtra = nil; end;
        if self.layout1 ~= nil then self.layout1:destroy(); self.layout1 = nil; end;
        if self.edit97 ~= nil then self.edit97:destroy(); self.edit97 = nil; end;
        if self.label18 ~= nil then self.label18:destroy(); self.label18 = nil; end;
        if self.layout41 ~= nil then self.layout41:destroy(); self.layout41 = nil; end;
        if self.label6 ~= nil then self.label6:destroy(); self.label6 = nil; end;
        if self.button17 ~= nil then self.button17:destroy(); self.button17 = nil; end;
        if self.chkMental_2 ~= nil then self.chkMental_2:destroy(); self.chkMental_2 = nil; end;
        if self.edit81 ~= nil then self.edit81:destroy(); self.edit81 = nil; end;
        if self.edit22 ~= nil then self.edit22:destroy(); self.edit22 = nil; end;
        if self.layout72 ~= nil then self.layout72:destroy(); self.layout72 = nil; end;
        if self.rowExtraL_8 ~= nil then self.rowExtraL_8:destroy(); self.rowExtraL_8 = nil; end;
        if self.layout44 ~= nil then self.layout44:destroy(); self.layout44 = nil; end;
        if self.label21 ~= nil then self.label21:destroy(); self.label21 = nil; end;
        if self.edit11 ~= nil then self.edit11:destroy(); self.edit11 = nil; end;
        if self.rowNivel_2 ~= nil then self.rowNivel_2:destroy(); self.rowNivel_2 = nil; end;
        if self.label80 ~= nil then self.label80:destroy(); self.label80 = nil; end;
        if self.label61 ~= nil then self.label61:destroy(); self.label61 = nil; end;
        if self.edit84 ~= nil then self.edit84:destroy(); self.edit84 = nil; end;
        if self.edit25 ~= nil then self.edit25:destroy(); self.edit25 = nil; end;
        if self.layout34 ~= nil then self.layout34:destroy(); self.layout34 = nil; end;
        if self.label16 ~= nil then self.label16:destroy(); self.label16 = nil; end;
        if self.label24 ~= nil then self.label24:destroy(); self.label24 = nil; end;
        if self.edit16 ~= nil then self.edit16:destroy(); self.edit16 = nil; end;
        if self.rowNivel_7 ~= nil then self.rowNivel_7:destroy(); self.rowNivel_7 = nil; end;
        if self.rowFacanha_8 ~= nil then self.rowFacanha_8:destroy(); self.rowFacanha_8 = nil; end;
        if self.edit28 ~= nil then self.edit28:destroy(); self.edit28 = nil; end;
        if self.edit63 ~= nil then self.edit63:destroy(); self.edit63 = nil; end;
        if self.layout31 ~= nil then self.layout31:destroy(); self.layout31 = nil; end;
        if self.label54 ~= nil then self.label54:destroy(); self.label54 = nil; end;
        if self.textEditor2 ~= nil then self.textEditor2:destroy(); self.textEditor2 = nil; end;
        if self.edit50 ~= nil then self.edit50:destroy(); self.edit50 = nil; end;
        if self.layout27 ~= nil then self.layout27:destroy(); self.layout27 = nil; end;
        if self.label51 ~= nil then self.label51:destroy(); self.label51 = nil; end;
        if self.tab2 ~= nil then self.tab2:destroy(); self.tab2 = nil; end;
        if self.layout50 ~= nil then self.layout50:destroy(); self.layout50 = nil; end;
        if self.rowAspecto_4 ~= nil then self.rowAspecto_4:destroy(); self.rowAspecto_4 = nil; end;
        if self.edit5 ~= nil then self.edit5:destroy(); self.edit5 = nil; end;
        if self.rowFacanha_6 ~= nil then self.rowFacanha_6:destroy(); self.rowFacanha_6 = nil; end;
        if self.edit69 ~= nil then self.edit69:destroy(); self.edit69 = nil; end;
        if self.layout22 ~= nil then self.layout22:destroy(); self.layout22 = nil; end;
        if self.chkFisico_8 ~= nil then self.chkFisico_8:destroy(); self.chkFisico_8 = nil; end;
        if self.layout62 ~= nil then self.layout62:destroy(); self.layout62 = nil; end;
        if self.label43 ~= nil then self.label43:destroy(); self.label43 = nil; end;
        if self.layout55 ~= nil then self.layout55:destroy(); self.layout55 = nil; end;
        if self.layout16 ~= nil then self.layout16:destroy(); self.layout16 = nil; end;
        if self.label30 ~= nil then self.label30:destroy(); self.label30 = nil; end;
        if self.button1 ~= nil then self.button1:destroy(); self.button1 = nil; end;
        if self.edit39 ~= nil then self.edit39:destroy(); self.edit39 = nil; end;
        if self.layout29 ~= nil then self.layout29:destroy(); self.layout29 = nil; end;
        if self.chkFisico_3 ~= nil then self.chkFisico_3:destroy(); self.chkFisico_3 = nil; end;
        if self.label70 ~= nil then self.label70:destroy(); self.label70 = nil; end;
        if self.edit79 ~= nil then self.edit79:destroy(); self.edit79 = nil; end;
        if self.edit45 ~= nil then self.edit45:destroy(); self.edit45 = nil; end;
        if self.rowExtraL_6 ~= nil then self.rowExtraL_6:destroy(); self.rowExtraL_6 = nil; end;
        if self.layout69 ~= nil then self.layout69:destroy(); self.layout69 = nil; end;
        if self.layout13 ~= nil then self.layout13:destroy(); self.layout13 = nil; end;
        if self.label35 ~= nil then self.label35:destroy(); self.label35 = nil; end;
        if self.button4 ~= nil then self.button4:destroy(); self.button4 = nil; end;
        if self.edit32 ~= nil then self.edit32:destroy(); self.edit32 = nil; end;
        if self.chkFisico_6 ~= nil then self.chkFisico_6:destroy(); self.chkFisico_6 = nil; end;
        if self.layout5 ~= nil then self.layout5:destroy(); self.layout5 = nil; end;
        if self.edit93 ~= nil then self.edit93:destroy(); self.edit93 = nil; end;
        if self.edit72 ~= nil then self.edit72:destroy(); self.edit72 = nil; end;
        if self.edit40 ~= nil then self.edit40:destroy(); self.edit40 = nil; end;
        if self.rowExtraL_3 ~= nil then self.rowExtraL_3:destroy(); self.rowExtraL_3 = nil; end;
        if self.label49 ~= nil then self.label49:destroy(); self.label49 = nil; end;
        if self.edit18 ~= nil then self.edit18:destroy(); self.edit18 = nil; end;
        if self.label2 ~= nil then self.label2:destroy(); self.label2 = nil; end;
        if self.button13 ~= nil then self.button13:destroy(); self.button13 = nil; end;
        if self.chkMental_6 ~= nil then self.chkMental_6:destroy(); self.chkMental_6 = nil; end;
        if self.edit37 ~= nil then self.edit37:destroy(); self.edit37 = nil; end;
        if self.edit98 ~= nil then self.edit98:destroy(); self.edit98 = nil; end;
        if self.label19 ~= nil then self.label19:destroy(); self.label19 = nil; end;
        if self.layout40 ~= nil then self.layout40:destroy(); self.layout40 = nil; end;
        if self.label5 ~= nil then self.label5:destroy(); self.label5 = nil; end;
        if self.button14 ~= nil then self.button14:destroy(); self.button14 = nil; end;
        if self.label65 ~= nil then self.label65:destroy(); self.label65 = nil; end;
        if self.edit80 ~= nil then self.edit80:destroy(); self.edit80 = nil; end;
        if self.edit21 ~= nil then self.edit21:destroy(); self.edit21 = nil; end;
        if self.layout38 ~= nil then self.layout38:destroy(); self.layout38 = nil; end;
        if self.rowExtraL_9 ~= nil then self.rowExtraL_9:destroy(); self.rowExtraL_9 = nil; end;
        if self.label12 ~= nil then self.label12:destroy(); self.label12 = nil; end;
        if self.tcMain ~= nil then self.tcMain:destroy(); self.tcMain = nil; end;
        if self.edit12 ~= nil then self.edit12:destroy(); self.edit12 = nil; end;
        if self.rowNivel_3 ~= nil then self.rowNivel_3:destroy(); self.rowNivel_3 = nil; end;
        if self.label20 ~= nil then self.label20:destroy(); self.label20 = nil; end;
        if self.label60 ~= nil then self.label60:destroy(); self.label60 = nil; end;
        if self.edit87 ~= nil then self.edit87:destroy(); self.edit87 = nil; end;
        if self.edit24 ~= nil then self.edit24:destroy(); self.edit24 = nil; end;
        if self.edit67 ~= nil then self.edit67:destroy(); self.edit67 = nil; end;
        if self.layout35 ~= nil then self.layout35:destroy(); self.layout35 = nil; end;
        if self.label17 ~= nil then self.label17:destroy(); self.label17 = nil; end;
        if self.label27 ~= nil then self.label27:destroy(); self.label27 = nil; end;
        if self.edit17 ~= nil then self.edit17:destroy(); self.edit17 = nil; end;
        if self.rowNivel_8 ~= nil then self.rowNivel_8:destroy(); self.rowNivel_8 = nil; end;
        if self.edit54 ~= nil then self.edit54:destroy(); self.edit54 = nil; end;
        if self.label58 ~= nil then self.label58:destroy(); self.label58 = nil; end;
        if self.rowFacanha_9 ~= nil then self.rowFacanha_9:destroy(); self.rowFacanha_9 = nil; end;
        if self.edit62 ~= nil then self.edit62:destroy(); self.edit62 = nil; end;
        if self.layout32 ~= nil then self.layout32:destroy(); self.layout32 = nil; end;
        if self.label55 ~= nil then self.label55:destroy(); self.label55 = nil; end;
        if self.textEditor5 ~= nil then self.textEditor5:destroy(); self.textEditor5 = nil; end;
        if self.edit51 ~= nil then self.edit51:destroy(); self.edit51 = nil; end;
        if self.edit1 ~= nil then self.edit1:destroy(); self.edit1 = nil; end;
        if self.rowFacanha_2 ~= nil then self.rowFacanha_2:destroy(); self.rowFacanha_2 = nil; end;
        if self.layout26 ~= nil then self.layout26:destroy(); self.layout26 = nil; end;
        if self.scrollBox3 ~= nil then self.scrollBox3:destroy(); self.scrollBox3 = nil; end;
        if self.label47 ~= nil then self.label47:destroy(); self.label47 = nil; end;
        if self.tab3 ~= nil then self.tab3:destroy(); self.tab3 = nil; end;
        if self.layout51 ~= nil then self.layout51:destroy(); self.layout51 = nil; end;
        if self.rowAspecto_3 ~= nil then self.rowAspecto_3:destroy(); self.rowAspecto_3 = nil; end;
        if self.edit4 ~= nil then self.edit4:destroy(); self.edit4 = nil; end;
        if self.rowFacanha_7 ~= nil then self.rowFacanha_7:destroy(); self.rowFacanha_7 = nil; end;
        if self.edit68 ~= nil then self.edit68:destroy(); self.edit68 = nil; end;
        if self.label74 ~= nil then self.label74:destroy(); self.label74 = nil; end;
        if self.layout65 ~= nil then self.layout65:destroy(); self.layout65 = nil; end;
        if self.label42 ~= nil then self.label42:destroy(); self.label42 = nil; end;
        if self.layout17 ~= nil then self.layout17:destroy(); self.layout17 = nil; end;
        if self.label31 ~= nil then self.label31:destroy(); self.label31 = nil; end;
        if self.chkFisico_2 ~= nil then self.chkFisico_2:destroy(); self.chkFisico_2 = nil; end;
        if self.layout68 ~= nil then self.layout68:destroy(); self.layout68 = nil; end;
        if self.layout28 ~= nil then self.layout28:destroy(); self.layout28 = nil; end;
        if self.layout9 ~= nil then self.layout9:destroy(); self.layout9 = nil; end;
        if self.label71 ~= nil then self.label71:destroy(); self.label71 = nil; end;
        if self.edit76 ~= nil then self.edit76:destroy(); self.edit76 = nil; end;
        if self.edit44 ~= nil then self.edit44:destroy(); self.edit44 = nil; end;
        if self.rowExtraL_7 ~= nil then self.rowExtraL_7:destroy(); self.rowExtraL_7 = nil; end;
        if self.layout10 ~= nil then self.layout10:destroy(); self.layout10 = nil; end;
        if self.chkFisico_5 ~= nil then self.chkFisico_5:destroy(); self.chkFisico_5 = nil; end;
        if self.label36 ~= nil then self.label36:destroy(); self.label36 = nil; end;
        if self.edit33 ~= nil then self.edit33:destroy(); self.edit33 = nil; end;
        if self.edit89 ~= nil then self.edit89:destroy(); self.edit89 = nil; end;
        if self.layout4 ~= nil then self.layout4:destroy(); self.layout4 = nil; end;
        if self.edit94 ~= nil then self.edit94:destroy(); self.edit94 = nil; end;
        if self.edit73 ~= nil then self.edit73:destroy(); self.edit73 = nil; end;
        if self.edit43 ~= nil then self.edit43:destroy(); self.edit43 = nil; end;
        if self.label48 ~= nil then self.label48:destroy(); self.label48 = nil; end;
        if self.edit19 ~= nil then self.edit19:destroy(); self.edit19 = nil; end;
        if self.label1 ~= nil then self.label1:destroy(); self.label1 = nil; end;
        if self.button10 ~= nil then self.button10:destroy(); self.button10 = nil; end;
        if self.chkMental_1 ~= nil then self.chkMental_1:destroy(); self.chkMental_1 = nil; end;
        if self.edit34 ~= nil then self.edit34:destroy(); self.edit34 = nil; end;
        if self.layout47 ~= nil then self.layout47:destroy(); self.layout47 = nil; end;
        if self.label4 ~= nil then self.label4:destroy(); self.label4 = nil; end;
        if self.button15 ~= nil then self.button15:destroy(); self.button15 = nil; end;
        if self.label64 ~= nil then self.label64:destroy(); self.label64 = nil; end;
        if self.edit83 ~= nil then self.edit83:destroy(); self.edit83 = nil; end;
        if self.edit20 ~= nil then self.edit20:destroy(); self.edit20 = nil; end;
        if self.rowFacanha_10 ~= nil then self.rowFacanha_10:destroy(); self.rowFacanha_10 = nil; end;
        if self.layout39 ~= nil then self.layout39:destroy(); self.layout39 = nil; end;
        if self.label83 ~= nil then self.label83:destroy(); self.label83 = nil; end;
        if self.label13 ~= nil then self.label13:destroy(); self.label13 = nil; end;
        if self.label23 ~= nil then self.label23:destroy(); self.label23 = nil; end;
        if self.edit13 ~= nil then self.edit13:destroy(); self.edit13 = nil; end;
        if self.rowNivel_4 ~= nil then self.rowNivel_4:destroy(); self.rowNivel_4 = nil; end;
        if self.edit58 ~= nil then self.edit58:destroy(); self.edit58 = nil; end;
        if self.label63 ~= nil then self.label63:destroy(); self.label63 = nil; end;
        if self.edit86 ~= nil then self.edit86:destroy(); self.edit86 = nil; end;
        if self.label86 ~= nil then self.label86:destroy(); self.label86 = nil; end;
        if self.edit66 ~= nil then self.edit66:destroy(); self.edit66 = nil; end;
        if self.layout36 ~= nil then self.layout36:destroy(); self.layout36 = nil; end;
        if self.label14 ~= nil then self.label14:destroy(); self.label14 = nil; end;
        if self.label26 ~= nil then self.label26:destroy(); self.label26 = nil; end;
        if self.textEditor1 ~= nil then self.textEditor1:destroy(); self.textEditor1 = nil; end;
        if self.edit55 ~= nil then self.edit55:destroy(); self.edit55 = nil; end;
        if self.layout58 ~= nil then self.layout58:destroy(); self.layout58 = nil; end;
        if self.label59 ~= nil then self.label59:destroy(); self.label59 = nil; end;
        if self.edit61 ~= nil then self.edit61:destroy(); self.edit61 = nil; end;
        if self.layout33 ~= nil then self.layout33:destroy(); self.layout33 = nil; end;
        if self.rowExtraL_10 ~= nil then self.rowExtraL_10:destroy(); self.rowExtraL_10 = nil; end;
        if self.label52 ~= nil then self.label52:destroy(); self.label52 = nil; end;
        if self.textEditor4 ~= nil then self.textEditor4:destroy(); self.textEditor4 = nil; end;
        if self.edit52 ~= nil then self.edit52:destroy(); self.edit52 = nil; end;
        if self.rowAspecto_7 ~= nil then self.rowAspecto_7:destroy(); self.rowAspecto_7 = nil; end;
        if self.rowFacanha_3 ~= nil then self.rowFacanha_3:destroy(); self.rowFacanha_3 = nil; end;
        if self.button9 ~= nil then self.button9:destroy(); self.button9 = nil; end;
        if self.label38 ~= nil then self.label38:destroy(); self.label38 = nil; end;
        if self.layout21 ~= nil then self.layout21:destroy(); self.layout21 = nil; end;
        if self.layout61 ~= nil then self.layout61:destroy(); self.layout61 = nil; end;
        if self.label78 ~= nil then self.label78:destroy(); self.label78 = nil; end;
        if self.scrollBox2 ~= nil then self.scrollBox2:destroy(); self.scrollBox2 = nil; end;
        if self.label46 ~= nil then self.label46:destroy(); self.label46 = nil; end;
        if self.layout56 ~= nil then self.layout56:destroy(); self.layout56 = nil; end;
        if self.rowAspecto_2 ~= nil then self.rowAspecto_2:destroy(); self.rowAspecto_2 = nil; end;
        if self.edit7 ~= nil then self.edit7:destroy(); self.edit7 = nil; end;
        if self.rowFacanha_4 ~= nil then self.rowFacanha_4:destroy(); self.rowFacanha_4 = nil; end;
        if self.layout64 ~= nil then self.layout64:destroy(); self.layout64 = nil; end;
        if self.label75 ~= nil then self.label75:destroy(); self.label75 = nil; end;
        if self.label41 ~= nil then self.label41:destroy(); self.label41 = nil; end;
        if self.layout14 ~= nil then self.layout14:destroy(); self.layout14 = nil; end;
        if self.label32 ~= nil then self.label32:destroy(); self.label32 = nil; end;
        if self.button7 ~= nil then self.button7:destroy(); self.button7 = nil; end;
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
