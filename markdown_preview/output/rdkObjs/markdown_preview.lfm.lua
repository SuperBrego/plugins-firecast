require("firecast.lua");
local __o_rrpgObjs = require("rrpgObjs.lua");
require("rrpgGUI.lua");
require("rrpgDialogs.lua");
require("rrpgLFM.lua");
require("ndb.lua");
require("locale.lua");
local __o_Utils = require("utils.lua");

local function constructNew_frmMarkdownPreview()
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
    obj:setName("frmMarkdownPreview");
    obj:setFormType("sheetTemplate");
    obj:setDataType("br.GodsCorpse.MarkdownPreview");
    obj:setTitle("Markdown Preview");


    



        local DEFAULT_SIZE  = 15
        local DEFAULT_COLOR = "Black"
        local CODE_FONT     = "Courier New"
        local CODE_COLOR    = "#c0392b"
        local LINK_COLOR    = "#2980b9"
        local QUOTE_COLOR   = "#7f8c8d"
        local IMAGE_WIDTH   = 300
        local IMAGE_HEIGHT  = 200

        local TALEMARK_OPTS = {
            parseCharActions             = false,
            parseCharEmDashSpeech        = false,
            parseCharQuotedSpeech        = false,
            parseOutOfChar               = false,
            parseSmileys                 = false,
            parseInitialCaps             = false,
            parseCommonMarkStrongEmphasis = true,
            parseHeadings                = true,
            parseHorzLines               = true,
            parseURL                     = false,
            trimTexts                    = false,
        }

        local function trim(s)
            return s:match("^%s*(.-)%s*$")
        end

        -- Conta caracteres UTF-8 (não bytes) para cálculo de padding em tabelas
        local function ulen(s)
            local len = 0
            local i = 1
            while i <= #s do
                local b = s:byte(i)
                if b < 0x80 then i = i + 1
                elseif b < 0xE0 then i = i + 2
                elseif b < 0xF0 then i = i + 3
                else i = i + 4
                end
                len = len + 1
            end
            return len
        end

        local function hasComplexInline(s)
            return s:find("%[.-%]%(.-%)") ~= nil
                or s:find("~~.-~~") ~= nil
                or s:find("`[^`]+`") ~= nil
                or s:find("https?://") ~= nil
        end

        local function insertPlain(re, text, size, color, font, styles)
            re:setSelectionFontSize(size or DEFAULT_SIZE)
            re:setSelectionFontColor(color or DEFAULT_COLOR)
            if font and font ~= "" then re:setSelectionFontFamily(font) end
            re:setSelectionFontStyle(styles or {})
            re:insertText(text)
        end

        local function renderInline(re, text, baseSize, baseColor, baseStyles)
            baseSize   = baseSize   or DEFAULT_SIZE
            baseColor  = baseColor  or DEFAULT_COLOR
            baseStyles = baseStyles or {}

            local pos = 1
            local len = #text

            while pos <= len do
                local matched = false

                -- Imagem: ![alt](url)
                do
                    local s, e, _, url = text:find("^!%[(.-)%]%((.-)%)", pos)
                    if s then
                        re:insertImage({url=url, width=IMAGE_WIDTH, height=IMAGE_HEIGHT, drawMode="proportional"})
                        pos = e + 1
                        matched = true
                    end
                end
                if matched then goto continue end

                -- Link: [texto](url)
                do
                    local s, e, txt, url = text:find("^%[(.-)%]%((.-)%)", pos)
                    if s then
                        local startGlyph = re:getSelectionPosInGlyphs()
                        re:setSelectionFontSize(baseSize)
                        re:setSelectionFontColor(LINK_COLOR)
                        re:setSelectionFontStyle({"underline"})
                        re:insertText(txt)
                        local endGlyph = re:getSelectionPosInGlyphs()
                        re:gotoPositionInGlyphs(startGlyph)
                        re:gotoPositionInGlyphs(endGlyph, true)
                        re:setSelectionURL(url)
                        re:gotoPositionInGlyphs(endGlyph)
                        pos = e + 1
                        matched = true
                    end
                end
                if matched then goto continue end

                -- Bold+italic: ***texto*** ou ___texto___
                do
                    local s, e, cap = text:find("^%*%*%*(.-)%*%*%*", pos)
                    if not s then s, e, cap = text:find("^___(.-)___", pos) end
                    if s then
                        local st = {}
                        for _, v in ipairs(baseStyles) do table.insert(st, v) end
                        table.insert(st, "bold"); table.insert(st, "italic")
                        insertPlain(re, cap, baseSize, baseColor, "", st)
                        pos = e + 1
                        matched = true
                    end
                end
                if matched then goto continue end

                -- Bold: **texto** ou __texto__
                do
                    local s, e, cap = text:find("^%*%*(.-)%*%*", pos)
                    if not s then s, e, cap = text:find("^__(.-)__", pos) end
                    if s then
                        local st = {}
                        for _, v in ipairs(baseStyles) do table.insert(st, v) end
                        table.insert(st, "bold")
                        insertPlain(re, cap, baseSize, baseColor, "", st)
                        pos = e + 1
                        matched = true
                    end
                end
                if matched then goto continue end

                -- Italic: *texto* ou _texto_
                do
                    local s, e, cap = text:find("^%*(.-)%*", pos)
                    if not s then s, e, cap = text:find("^_(.-)_", pos) end
                    if s then
                        local st = {}
                        for _, v in ipairs(baseStyles) do table.insert(st, v) end
                        table.insert(st, "italic")
                        insertPlain(re, cap, baseSize, baseColor, "", st)
                        pos = e + 1
                        matched = true
                    end
                end
                if matched then goto continue end

                -- Strikethrough: ~~texto~~
                do
                    local s, e, cap = text:find("^~~(.-)~~", pos)
                    if s then
                        local st = {}
                        for _, v in ipairs(baseStyles) do table.insert(st, v) end
                        table.insert(st, "strikeout")
                        insertPlain(re, cap, baseSize, baseColor, "", st)
                        pos = e + 1
                        matched = true
                    end
                end
                if matched then goto continue end

                -- Code inline: `texto`
                do
                    local s, e, cap = text:find("^`([^`]+)`", pos)
                    if s then
                        insertPlain(re, cap, baseSize, CODE_COLOR, CODE_FONT, {})
                        pos = e + 1
                        matched = true
                    end
                end
                if matched then goto continue end

                -- URL nua
                do
                    local s, e, url = text:find("^(https?://[^%s]+)", pos)
                    if s then
                        local startGlyph = re:getSelectionPosInGlyphs()
                        re:setSelectionFontSize(baseSize)
                        re:setSelectionFontColor(LINK_COLOR)
                        re:setSelectionFontStyle({"underline"})
                        re:insertText(url)
                        local endGlyph = re:getSelectionPosInGlyphs()
                        re:gotoPositionInGlyphs(startGlyph)
                        re:gotoPositionInGlyphs(endGlyph, true)
                        re:setSelectionURL(url)
                        re:gotoPositionInGlyphs(endGlyph)
                        pos = e + 1
                        matched = true
                    end
                end
                if matched then goto continue end

                -- Texto neutro
                do
                    local next_s = nil
                    for _, pat in ipairs({
                        "!%[", "%[", "%*%*%*", "___", "%*%*", "__",
                        "%*", "_", "~~", "`", "https?://"
                    }) do
                        local ns = text:find(pat, pos)
                        if ns and (not next_s or ns < next_s) then next_s = ns end
                    end

                    local chunk
                    if next_s and next_s > pos then
                        chunk = text:sub(pos, next_s - 1)
                        pos = next_s
                    else
                        chunk = text:sub(pos)
                        pos = len + 1
                    end

                    if chunk ~= "" then
                        insertPlain(re, chunk, baseSize, baseColor, "", baseStyles)
                    end
                end

                ::continue::
            end
        end

        -- Detecta se uma linha é separador de tabela (ex: |---|---|)
        local function isTableSeparator(s)
            return s:match("^|?%s*:?%-+:?%s*|") ~= nil
        end

        -- Divide uma linha de tabela em células
        local function splitTableRow(s)
            local cells = {}
            -- Remove espaços, depois pipes do início e fim
            local inner = trim(s)
            inner = inner:gsub("^|", ""):gsub("|%s*$", "")
            for cell in (inner .. "|"):gmatch("([^|]*)|") do
                table.insert(cells, trim(cell))
            end
            return cells
        end

        -- Detecta alinhamento da coluna pelo separador
        local function getColAlign(sep)
            local s = trim(sep)
            local left  = s:sub(1,1) == ":"
            local right = s:sub(-1)  == ":"
            if left and right then return "center"
            elseif right      then return "right"
            else                   return "left"
            end
        end

        -- Renderiza uma tabela Markdown
        local function renderTable(re, tableLines)
            if #tableLines < 2 then return end

            local headers    = splitTableRow(tableLines[1])
            local separators = splitTableRow(tableLines[2])
            local aligns     = {}
            for _, sep in ipairs(separators) do
                table.insert(aligns, getColAlign(sep))
            end

            local ncols = #headers

            -- Calcula largura de cada coluna (máximo entre header e dados)
            local colWidths = {}
            for c = 1, ncols do
                colWidths[c] = ulen(headers[c])
            end
            for r = 3, #tableLines do
                local row = splitTableRow(tableLines[r])
                for c = 1, ncols do
                    local cell = row[c] or ""
                    local clen = ulen(cell)
                    if clen > colWidths[c] then colWidths[c] = clen end
                end
            end

            local HEADER_COLOR = "#2c3e50"
            local SEP_COLOR    = "#95a5a6"
            local TABLE_SIZE   = DEFAULT_SIZE - 1

            -- Toda a tabela usa fonte mono para o padding de espaços alinhar
            local function monoPlain(text, color, styles)
                insertPlain(re, text, TABLE_SIZE, color, CODE_FONT, styles or {})
            end

            local function renderRow(cells, isHeader)
                for c = 1, ncols do
                    local cell  = cells[c] or ""
                    local align = aligns[c] or "left"
                    local width = colWidths[c]
                    local pad   = width - ulen(cell)

                    local padLeft, padRight = 0, 0
                    if align == "center" then
                        padLeft  = math.floor(pad / 2)
                        padRight = pad - padLeft
                    elseif align == "right" then
                        padLeft  = pad
                    else
                        padRight = pad
                    end

                    local color  = isHeader and HEADER_COLOR or DEFAULT_COLOR
                    local styles = isHeader and {"bold"} or {}

                    if padLeft > 0 then
                        monoPlain(string.rep(" ", padLeft), color)
                    end
                    monoPlain(cell, color, styles)
                    if padRight > 0 then
                        monoPlain(string.rep(" ", padRight), color)
                    end

                    if c < ncols then
                        monoPlain(" | ", SEP_COLOR)
                    end
                end
                re:breakLine()
            end

            -- Header
            renderRow(headers, true)

            -- Linha separadora ---------+----------
            local sepLine = ""
            for c = 1, ncols do
                sepLine = sepLine .. string.rep("-", colWidths[c])
                if c < ncols then
                    sepLine = sepLine .. "-+-"
                end
            end
            monoPlain(sepLine, SEP_COLOR)
            re:breakLine()

            -- Linhas de dados
            for r = 3, #tableLines do
                renderRow(splitTableRow(tableLines[r]), false)
            end
        end

        local function renderMarkdown(re, md)
            re.readOnly = false
            re:selectAll()
            re:beginEdit()
            re:deleteSelection()

            -- Respeita a cor de fonte atual (pode ter sido alterada pelo toggleFundo)
            local currentColor = re.defaultFontColor or DEFAULT_COLOR
            local savedColor = DEFAULT_COLOR
            DEFAULT_COLOR = currentColor

            local lines = {}
            for line in (md .. "\n"):gmatch("([^\n]*)\n") do
                table.insert(lines, line)
            end

            local i = 1
            local needNewline = false

            local function nl()
                if needNewline then
                    insertPlain(re, "", DEFAULT_SIZE, DEFAULT_COLOR, "", {})
                    re:breakLine()
                    needNewline = false
                end
            end

            while i <= #lines do
                local raw     = lines[i]
                local trimmed = trim(raw)

                -- Code block: ```
                if trimmed:match("^```") then
                    nl()
                    i = i + 1
                    while i <= #lines do
                        local cl = lines[i]
                        if trim(cl):match("^```") then i = i + 1; break end
                        insertPlain(re, cl, DEFAULT_SIZE - 1, CODE_COLOR, CODE_FONT, {})
                        re:breakLine()
                        i = i + 1
                    end
                    needNewline = false

                -- Tabela: linha com | seguida de separador
                elseif trimmed:match("^|") and i + 1 <= #lines and isTableSeparator(trim(lines[i+1])) then
                    nl()
                    local tableLines = {}
                    while i <= #lines and trim(lines[i]):match("^|") do
                        table.insert(tableLines, lines[i])
                        i = i + 1
                    end
                    renderTable(re, tableLines)
                    needNewline = false

                -- Linha em branco
                elseif trimmed == "" then
                    needNewline = true
                    i = i + 1

                -- HR
                elseif trimmed:match("^%-%-%-+$")
                    or trimmed:match("^%*%*%*+$")
                    or trimmed:match("^___+$") then
                    nl()
                    insertPlain(re, string.rep("-", 50), DEFAULT_SIZE - 4, "#aaaaaa", CODE_FONT, {})
                    needNewline = true
                    i = i + 1

                -- Headings
                elseif trimmed:match("^(#+)%s+(.+)$") then
                    local hashes, content = trimmed:match("^(#+)%s+(.+)$")
                    local level = math.min(#hashes, 6)
                    local sizes = {28, 24, 20, 18, 16, 15}
                    needNewline = false  -- descarta quebra pendente antes do heading
                    if hasComplexInline(content) then
                        local sz = sizes[level]
                        renderInline(re, content, sz, DEFAULT_COLOR, {"bold"})
                    else
                        re:insertTalemark(trimmed, TALEMARK_OPTS)
                    end
                    -- Quebra depois com tamanho padrão e marca pendente
                    -- para que linha em branco seguinte produza separação
                    insertPlain(re, "", DEFAULT_SIZE, DEFAULT_COLOR, "", {})
                    re:breakLine()
                    needNewline = true
                    i = i + 1

                -- Imagem standalone
                elseif trimmed:match("^!%[.-%]%(.-%)$") then
                    local _, url = trimmed:match("^!%[(.-)%]%((.-)%)$")
                    nl()
                    re:insertImage({url=url, width=IMAGE_WIDTH, height=IMAGE_HEIGHT, drawMode="proportional"})
                    needNewline = true
                    i = i + 1

                -- Lista não-ordenada
                elseif trimmed:match("^[%-%*%+]%s+(.+)$") then
                    local content = trimmed:match("^[%-%*%+]%s+(.+)$")
                    nl()
                    insertPlain(re, "  \xE2\x80\xa2 ", DEFAULT_SIZE, DEFAULT_COLOR, "", {})
                    renderInline(re, content)
                    needNewline = true
                    i = i + 1

                -- Lista ordenada
                elseif trimmed:match("^(%d+)%.%s+(.+)$") then
                    local num, content = trimmed:match("^(%d+)%.%s+(.+)$")
                    nl()
                    insertPlain(re, "  " .. num .. ". ", DEFAULT_SIZE, DEFAULT_COLOR, "", {})
                    renderInline(re, content)
                    needNewline = true
                    i = i + 1

                -- Blockquote
                elseif trimmed:match("^>+%s*(.*)$") then
                    local arrows, content = trimmed:match("^(>+)%s*(.*)$")
                    local depth = #arrows
                    nl()
                    insertPlain(re, string.rep("  ", depth) .. "\xE2\x94\x82 ", DEFAULT_SIZE, QUOTE_COLOR, "", {"italic"})
                    renderInline(re, content, DEFAULT_SIZE, QUOTE_COLOR, {"italic"})
                    needNewline = true
                    i = i + 1

                -- Texto comum
                else
                    nl()
                    if hasComplexInline(raw) then
                        renderInline(re, raw)
                    else
                        local safe = raw:gsub('"', "\xE2\x80\x9C")
                        re:insertTalemark(safe, TALEMARK_OPTS)
                    end
                    needNewline = true
                    i = i + 1
                end
            end

            re:gotoStart()
            re:endEdit()
            re.readOnly = true
            DEFAULT_COLOR = savedColor
        end

        local function doRender()
            renderMarkdown(self.rePreview, self.txtEditor.text or "")
            self.tcMain.tabIndex = 0
        end

        local function toggleEditor()
            local chk = self.chkOcultarEditor
            self.tabEditor.visible = not chk.checked
            if chk.checked and self.tcMain.tabIndex == 1 then
                self.tcMain.tabIndex = 0
            end
        end

        local function toggleFundo()
            local re = self.rePreview
            if self.chkFundoEscuro.checked then
                re.backgroundColor = "#2b2b2b"
                re.defaultFontColor = "#f0f0f0"
            else
                re.backgroundColor = "White"
                re.defaultFontColor = "Black"
            end
            renderMarkdown(re, self.txtEditor.text or "")
        end
    



    


    obj.tcMain = GUI.fromHandle(_obj_newObject("tabControl"));
    obj.tcMain:setParent(obj);
    obj.tcMain:setAlign("client");
    obj.tcMain:setName("tcMain");

    obj.tab1 = GUI.fromHandle(_obj_newObject("tab"));
    obj.tab1:setParent(obj.tcMain);
    obj.tab1:setTitle("Preview");
    obj.tab1:setName("tab1");

    obj.layout1 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout1:setParent(obj.tab1);
    obj.layout1:setAlign("client");
    obj.layout1:setName("layout1");

    obj.rePreview = GUI.fromHandle(_obj_newObject("richEdit"));
    obj.rePreview:setParent(obj.layout1);
    obj.rePreview:setName("rePreview");
    obj.rePreview:setAlign("client");
    obj.rePreview.readOnly = true;
    obj.rePreview.showToolbar = false;
    obj.rePreview.defaultFontSize = 15;
    obj.rePreview.defaultFontColor = "Black";
    obj.rePreview:setMargins({left=8, right=8, top=8, bottom=4});

    obj.chkOcultarEditor = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.chkOcultarEditor:setParent(obj.layout1);
    obj.chkOcultarEditor:setName("chkOcultarEditor");
    obj.chkOcultarEditor:setText("Ocultar editor");
    obj.chkOcultarEditor:setAlign("bottom");
    obj.chkOcultarEditor:setHeight(30);
    obj.chkOcultarEditor:setChecked(false);
    obj.chkOcultarEditor:setField("ocultarEditor");
    obj.chkOcultarEditor:setMargins({left=8, right=8, top=4, bottom=4});

    obj.chkFundoEscuro = GUI.fromHandle(_obj_newObject("checkBox"));
    obj.chkFundoEscuro:setParent(obj.layout1);
    obj.chkFundoEscuro:setName("chkFundoEscuro");
    obj.chkFundoEscuro:setText("Fundo escuro");
    obj.chkFundoEscuro:setAlign("bottom");
    obj.chkFundoEscuro:setHeight(30);
    obj.chkFundoEscuro:setChecked(false);
    obj.chkFundoEscuro:setField("fundoEscuro");
    obj.chkFundoEscuro:setMargins({left=8, right=8, top=0, bottom=8});

    obj.tabEditor = GUI.fromHandle(_obj_newObject("tab"));
    obj.tabEditor:setParent(obj.tcMain);
    obj.tabEditor:setTitle("Editor");
    obj.tabEditor:setName("tabEditor");

    obj.layout2 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout2:setParent(obj.tabEditor);
    obj.layout2:setAlign("client");
    obj.layout2:setName("layout2");

    obj.txtEditor = GUI.fromHandle(_obj_newObject("textEditor"));
    obj.txtEditor:setParent(obj.layout2);
    obj.txtEditor:setName("txtEditor");
    obj.txtEditor:setAlign("client");
    obj.txtEditor:setField("mdContent");
    obj.txtEditor:setMargins({left=8, right=8, top=8, bottom=4});

    obj.layout3 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout3:setParent(obj.layout2);
    obj.layout3:setAlign("bottom");
    obj.layout3:setHeight(30);
    obj.layout3:setMargins({left=8, right=8, top=4, bottom=4});
    obj.layout3:setName("layout3");

    obj.label1 = GUI.fromHandle(_obj_newObject("label"));
    obj.label1:setParent(obj.layout3);
    obj.label1:setText("Imagens:");
    obj.label1:setAlign("left");
    obj.label1:setWidth(60);
    obj.label1:setVertTextAlign("center");
    obj.label1:setName("label1");

    obj.label2 = GUI.fromHandle(_obj_newObject("label"));
    obj.label2:setParent(obj.layout3);
    obj.label2:setText("L");
    obj.label2:setAlign("left");
    obj.label2:setWidth(14);
    obj.label2:setVertTextAlign("center");
    obj.label2:setName("label2");

    obj.edtImgW = GUI.fromHandle(_obj_newObject("edit"));
    obj.edtImgW:setParent(obj.layout3);
    obj.edtImgW:setName("edtImgW");
    obj.edtImgW:setAlign("left");
    obj.edtImgW:setWidth(50);
    obj.edtImgW:setType("number");
    obj.edtImgW:setField("imgWidth");
    obj.edtImgW:setText("300");

    obj.label3 = GUI.fromHandle(_obj_newObject("label"));
    obj.label3:setParent(obj.layout3);
    obj.label3:setText("A");
    obj.label3:setAlign("left");
    obj.label3:setWidth(14);
    obj.label3:setMargins({left=6});
    obj.label3:setVertTextAlign("center");
    obj.label3:setName("label3");

    obj.edtImgH = GUI.fromHandle(_obj_newObject("edit"));
    obj.edtImgH:setParent(obj.layout3);
    obj.edtImgH:setName("edtImgH");
    obj.edtImgH:setAlign("left");
    obj.edtImgH:setWidth(50);
    obj.edtImgH:setType("number");
    obj.edtImgH:setField("imgHeight");
    obj.edtImgH:setText("200");

    obj.button1 = GUI.fromHandle(_obj_newObject("button"));
    obj.button1:setParent(obj.layout2);
    obj.button1:setText("Renderizar Preview");
    obj.button1:setAlign("bottom");
    obj.button1:setHeight(36);
    obj.button1:setMargins({left=8, right=8, top=0, bottom=8});
    obj.button1:setName("button1");

    obj._e_event0 = obj:addEventListener("onNodeReady",
        function ()
            if self.chkFundoEscuro.checked then
                        self.rePreview.backgroundColor = "#2b2b2b"
                        self.rePreview.defaultFontColor = "#f0f0f0"
                    end
                    self.tabEditor.visible = not self.chkOcultarEditor.checked
                    IMAGE_WIDTH  = tonumber(self.edtImgW.text) or 300
                    IMAGE_HEIGHT = tonumber(self.edtImgH.text) or 200
                    renderMarkdown(self.rePreview, self.txtEditor.text or "")
        end);

    obj._e_event1 = obj.chkOcultarEditor:addEventListener("onChange",
        function ()
            toggleEditor()
        end);

    obj._e_event2 = obj.chkFundoEscuro:addEventListener("onChange",
        function ()
            toggleFundo()
        end);

    obj._e_event3 = obj.edtImgW:addEventListener("onUserChange",
        function ()
            IMAGE_WIDTH = tonumber(self.edtImgW.text) or 300
        end);

    obj._e_event4 = obj.edtImgH:addEventListener("onUserChange",
        function ()
            IMAGE_HEIGHT = tonumber(self.edtImgH.text) or 200
        end);

    obj._e_event5 = obj.button1:addEventListener("onClick",
        function (event)
            doRender()
        end);

    function obj:_releaseEvents()
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

        if self.label2 ~= nil then self.label2:destroy(); self.label2 = nil; end;
        if self.edtImgH ~= nil then self.edtImgH:destroy(); self.edtImgH = nil; end;
        if self.txtEditor ~= nil then self.txtEditor:destroy(); self.txtEditor = nil; end;
        if self.chkOcultarEditor ~= nil then self.chkOcultarEditor:destroy(); self.chkOcultarEditor = nil; end;
        if self.rePreview ~= nil then self.rePreview:destroy(); self.rePreview = nil; end;
        if self.label1 ~= nil then self.label1:destroy(); self.label1 = nil; end;
        if self.button1 ~= nil then self.button1:destroy(); self.button1 = nil; end;
        if self.layout3 ~= nil then self.layout3:destroy(); self.layout3 = nil; end;
        if self.chkFundoEscuro ~= nil then self.chkFundoEscuro:destroy(); self.chkFundoEscuro = nil; end;
        if self.tab1 ~= nil then self.tab1:destroy(); self.tab1 = nil; end;
        if self.edtImgW ~= nil then self.edtImgW:destroy(); self.edtImgW = nil; end;
        if self.layout2 ~= nil then self.layout2:destroy(); self.layout2 = nil; end;
        if self.label3 ~= nil then self.label3:destroy(); self.label3 = nil; end;
        if self.tcMain ~= nil then self.tcMain:destroy(); self.tcMain = nil; end;
        if self.tabEditor ~= nil then self.tabEditor:destroy(); self.tabEditor = nil; end;
        if self.layout1 ~= nil then self.layout1:destroy(); self.layout1 = nil; end;
        self:_oldLFMDestroy();
    end;

    obj:endUpdate();

    return obj;
end;

function newfrmMarkdownPreview()
    local retObj = nil;
    __o_rrpgObjs.beginObjectsLoading();

    __o_Utils.tryFinally(
      function()
        retObj = constructNew_frmMarkdownPreview();
      end,
      function()
        __o_rrpgObjs.endObjectsLoading();
      end);

    assert(retObj ~= nil);
    return retObj;
end;

local _frmMarkdownPreview = {
    newEditor = newfrmMarkdownPreview, 
    new = newfrmMarkdownPreview, 
    name = "frmMarkdownPreview", 
    dataType = "br.GodsCorpse.MarkdownPreview", 
    formType = "sheetTemplate", 
    formComponentName = "form", 
    cacheMode = "none", 
    title = "Markdown Preview", 
    description=""};

frmMarkdownPreview = _frmMarkdownPreview;
Firecast.registrarForm(_frmMarkdownPreview);
Firecast.registrarDataType(_frmMarkdownPreview);

return _frmMarkdownPreview;
