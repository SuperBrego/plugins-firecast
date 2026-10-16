# Tag richEdit

> Extraído de `docs/Firecast_SDK_-_Single formatado.pdf` (texto automático; tabelas podem ter colunas desalinhadas). 

```text
Tag richEdit

  A tag/componente richEdit representa uma caixa de texto de múltiplas linhas com possibilidade de
  adicionar formatação, cores, alinhamentos, imagens, etc... Um ótimo controle para permitir a
  entrada de dados "texto ricos".

Herança

            O richEdit possui todas as características de uma tag visual. Veja:
                           ● Características de todas as tags visuais

Características

  Além das características herdadas, a tag richEdit também possui as seguintes características:

Propriedades e atributos

Propriedade               Tipo     Valor   Descrição
                                   Padrão

animateImages             Boolean  false   Define se o RichEdit deve
                                           executar a animação de
                                           imagens que são animadas
                                           (exemplo: GIF, GIFV)
                                           quando suportadas.
readOnly          Boolean    false    Quando true, o richEdit não
field             String     <string  permite o usuário alterar
                             vazio>   seu conteúdo
backgroundColor   String de
                  Cor        "White"  Caminho de um campo no
                                      NodeDatabase.
defaultFontColor  String de  "Black"
                  Cor                 Quando associado, o
                             15       richEdit passa a apresentar
defaultFontSize   Float      true     e salvar o conteúdo no
                                      campo informado.
showToolbar       Boolean
                                      Veja também:

                                                ● Lua Form e
                                                     NodeDatabase

                                                ● NodeDatabase

                                      Define a cor de fundo do
                                      RichEdit.

                                      Exemplos:

                                                     ● Black
                                                     ● White
                                                     ● #FDFDFD

                                      Veja String de cores no Lua
                                      Form para obter a completa
                                      de cores e outras formas de
                                      uso.

                                      Define a cor padrão para os
                                      textos do richEdit

                                      Exemplos:

                                                     ● Black
                                                     ● White
                                                     ● #FDFDFD

                                      Veja String de cores no Lua
                                      Form para obter a completa
                                      de cores e outras formas de
                                      uso

                                      Define o tamanho de fonte
                                      padrão para os textos do
                                      richEdit

                                      Define se o richEdit deve
                                       apresentar uma baixa de
                                       ferramentas para auxiliar o
                                       usuário a formatar seu
                                       texto.

hideSelection  Boolean           true  Define se a seleção que o

                                       usuário fizer (com o mouse

                                       ou teclado) será

                                       apresentada quando ele

                                       estiver focado em outro

                                       controle.

                                       True - A seleção continuará
                                       existindo, porém não será
                                       exibida visualmente se o
                                       usuário estiver focado em
                                       outro controle

                                       False - A seleção continuará
                                       existindo e será exibida
                                       visualmente mesmo se o
                                       usuário estiver focado em
                                       outro controle.

Methods                                Description
   Method
   richEdit:beginEdit()                Starts a batch of edit operations.
                                       Each call to beginEdit() must be
   richEdit:endEdit()                  balanced with another call to
                                       endEdit()
   richEdit:selectAll()
   richEdit:unselect()                 Ends a batch of edit operations. Each
   richEdit:getLengthInChars()         call to beginEdit() must be balanced
   richEdit:getLengthInGlyphs()        with another call to endEdit()

                                       Selects the entire content of the
                                       richEdit.

                                       Cancels all selections made to the
                                       richEdit.

                                       Returns the length of the richEdit
                                       content in UTF-16 char units.

                                       Returns the length of the richEdit
                                       content in glyph units.
richEdit:getSelectionPosInChars()    Returns two integers containing the
                                     current selection start index and
richEdit:getSelectionPosInGlyphs()   selection end index. If both numbers
                                     are equal, there is no selection but a
richEdit:getIsSelectionForward()     single caret at the specified index.
richEdit:getSelectionText()
richEdit:getSelectionURL()           The returned indexes are in UTF-16
richEdit:getSelectionFontColor()     character units.
richEdit:getSelectionFontBkgColor()
richEdit:getSelectionFontSize()      Returns two integers containing the
richEdit:getSelectionFontFamily()    current selection start index and
richEdit:getSelectionFontStyle()     selection end index. If both numbers
                                     are equal, there is no selection but a
                                     single caret at the specified index.

                                     The returned indexes are in glyph
                                     units.

                                     Returns true if the current selection
                                     is forward and false if it is backwards.

                                     Returns the string content of the
                                     current selection.

                                     Returns the URL address of the
                                     current selection or an empty string
                                     if no links are selected.

                                     Returns a Color String identifying the
                                     font color of the selected text.

                                     Returns a Color String identifying the
                                     font background color of the selected
                                     text.

                                     Returns the font size of the selected
                                     text.

                                     Returns the font family name of the
                                     selected text.

                                     Returns the font style of the selected
                                     text. It is an array that may contain
                                     the following strings: "bold", "italic",
                                     "underline", "strikeout".
richEdit:getSelectionFloat()            Returns the float mode of the
richEdit:getSelectionParaAlign()        selected text. It can be one of the
richEdit:getText()                      following values: "none", "left",
richEdit:gotoStart([holdSelection])     "right".

richEdit:gotoEnd([holdSelection])       Returns the paragraph alignment of
                                        the selected text. It can be one of the
richEdit:gotoNext([holdSelection])      following values: "left", "center",
                                        "right", "justify".
richEdit:gotoPrevious([holdSelection])
                                        Returns the content of the richEdit
                                        as plain text.

                                        Moves the caret to the beginning of
                                        the content.

                                        Set "holdSelection" to "true" if you
                                        want to keep and/or build a selection
                                        with the caret movement, simulating
                                        the behavior as if the "shift" key were
                                        held.

                                        Moves the caret to the end of the
                                        content.

                                        Set "holdSelection" to "true" if you
                                        want to keep and/or build a selection
                                        with the caret movement, simulating
                                        the behavior as if the "shift" key were
                                        held.

                                        Moves the caret to the next glyph
                                        position.

                                        Set "holdSelection" to "true" if you
                                        want to keep and/or build a selection
                                        with the caret movement, simulating
                                        the behavior as if the "shift" key were
                                        held.

                                        Moves the caret to the previous
                                        glyph position.

                                        Set "holdSelection" to "true" if you
                                        want to keep and/or build a selection
                                        with the caret movement, simulating
                                        the behavior as if the "shift" key were
                                        held.
richEdit:gotoStartOfLine([holdSelection])   Moves the caret to start of the
richEdit:gotoEndOfLine([holdSelection])     current line.
richEdit:gotoNextWord([holdSelection])
richEdit:gotoPreviousWord([holdSelection])  Set "holdSelection" to "true" if you
richEdit:gotoLineUp([holdSelection])        want to keep and/or build a selection
richEdit:gotoLineDown([holdSelection])      with the caret movement, simulating
                                            the behavior as if the "shift" key were
                                            held.

                                            Moves the caret to end of the current
                                            line.

                                            Set "holdSelection" to "true" if you
                                            want to keep and/or build a selection
                                            with the caret movement, simulating
                                            the behavior as if the "shift" key were
                                            held.

                                            Moves the caret to the next word.

                                            Set "holdSelection" to "true" if you
                                            want to keep and/or build a selection
                                            with the caret movement, simulating
                                            the behavior as if the "shift" key were
                                            held.

                                            Moves the caret to the previous
                                            word.

                                            Set "holdSelection" to "true" if you
                                            want to keep and/or build a selection
                                            with the caret movement, simulating
                                            the behavior as if the "shift" key were
                                            held.

                                            Moves the caret to the line above.

                                            Set "holdSelection" to "true" if you
                                            want to keep and/or build a selection
                                            with the caret movement, simulating
                                            the behavior as if the "shift" key were
                                            held.

                                            Moves the caret to the line bellow.

                                            Set "holdSelection" to "true" if you
                                            want to keep and/or build a selection
                                            with the caret movement, simulating
                                            the behavior as if the "shift" key were
                                            held.
richEdit:gotoPageUp([holdSelection])    Moves the caret to the page up.

richEdit:gotoPageDown([holdSelection])  Set "holdSelection" to "true" if you
                                        want to keep and/or build a selection
richEdit:gotoPositionInGlyphs(pos,      with the caret movement, simulating
[holdSelection])                        the behavior as if the "shift" key were
                                        held.
richEdit:gotoPositionInChars(pos,
[holdSelection])                        Moves the caret to the page down.

richEdit:copySelectionToClipboard()     Set "holdSelection" to "true" if you
richEdit:deleteSelection()              want to keep and/or build a selection
richEdit:insertText(text)               with the caret movement, simulating
                                        the behavior as if the "shift" key were
                                        held.

                                        Moves the caret to the specified
                                        position measured in glyph count.

                                        Set "holdSelection" to "true" if you
                                        want to keep and/or build a selection
                                        with the caret movement, simulating
                                        the behavior as if the "shift" key were
                                        held.

                                        Moves the caret to the specified
                                        position measured in UTF-16 char
                                        count.

                                        Set "holdSelection" to "true" if you
                                        want to keep and/or build a selection
                                        with the caret movement, simulating
                                        the behavior as if the "shift" key were
                                        held.

                                        Copies the content of the current
                                        selection to the clipboard.

                                        (Edit Operation) Deletes the current
                                        selection from the richEdit content.

                                        (Edit Operation) Inserts the specified
                                        text into the current caret position,
                                        deleting selected content if any, and
                                        moving the caret to the end of the
                                        inserted text.
richEdit:insertTalemark(talemarkText[,  (Edit Operation) Inserts the specified
talemarkOptions])                       talemark text into the current caret
                                        position, deleting selected content if
richEdit:insertImage(params)            any, and moving the caret to the end
                                        of the inserted text.

                                        Arguments:

                                                  ● talemarkText - A string
                                                       containing the Talemark
                                                       text to be inserted.

                                                  ● (Optional)
                                                       talemarkOptions - A
                                                       TalemarkOptions table
                                                       parameter to configure
                                                       the text generation.

                                        (Edit Operation) Inserts a image into
                                        the current caret position, deleting
                                        selected content if any, and moving
                                        the caret to the end of the inserted
                                        image.

                                        Arguments:

                                                  ● params - A lua table
                                                       containing the following
                                                       fields:
                                                                       ○ url - A
                                                                            string
                                                                            containin
                                                                            g the URL
                                                                            Address
                                                                            of the
                                                                            image
                                                                       ○ width - A
                                                                            number
                                                                            defining
                                                                            the width
                                                                            of the
                                                                            image
                                                                       ○ height - A
                                                                            number
                                                                            defining
                                                                            the
                                                                            height of
                                                                            the
                                                                            image
                                                                       ○ (Optional
                                                                            )
                                                                            drawMo
richEdit:breakLine()                                                    de - How
richEdit:breakParagraph()                                               the
richEdit:indent(qty)                                                    image
                                                                        should be
richEdit:pasteFromClipboard()                                           rendered
richEdit:cutSelectionToClipboard()                                      . It can be
                                                                        one of
                                                                        the
                                                                        following
                                                                        values:
                                                                        "proporti
                                                                        onal",
                                                                        "autoFit",
                                                                        "originalS
                                                                        ize",
                                                                        "stretch".

                                    (Edit Operation) Inserts a line break
                                    into the current caret position,
                                    deleting selected content if any, and
                                    automatically moving the caret to the
                                    end of the inserted text.

                                    (Edit Operation) Inserts a paragraph
                                    break into the current caret position,
                                    deleting selected content if any, and
                                    moving the caret to the end of the
                                    inserted text.

                                    (Edit Operation) Changes the
                                    indentation of the selected text. The
                                    argument "qty" defines how much to
                                    indent:

                                    - A positive non-zero integer value to
                                    indent to the right.

                                    - A negative non-zero integer value
                                    to indent to the left.

                                    (Edit Operation) Inserts the content
                                    of the clipboard into the current
                                    caret position, deleting selected
                                    content if any, and moving the caret
                                    to the end of the inserted text.

                                    (Edit Operation) Removes the
                                    current selection from the richEdit
                                    content and places it into the user
richEdit:setSelectionURL(url)              clipboard.
richEdit:setSelectionFontColor(color)
richEdit:setSelectionFontBkgColor(color)   (Edit Operation) Changes the URL
richEdit:setSelectionFontSize(size)        address of the selected text, creating
richEdit:setSelectionFontFamily(family)    a link if needed. If the argument "url"
richEdit:setSelectionFontStyle(style)      is empty, then the link is removed.

richEdit:setSelectionFloat(floatMode)      (Edit Operation) Changes the font
                                           color of the selected text to the
richEdit:setSelectionParaAlign(paraAlign)  specified Color String

                                           (Edit Operation) Changes the font
                                           background color of the selected text
                                           to the specified Color String

                                           (Edit Operation) Changes the font
                                           size of the selected text to the
                                           specified number.

                                           (Edit Operation) Changes the font
                                           family of the selected text to the
                                           specified string.

                                           (Edit Operation) Changes the font
                                           style of the selected text. The
                                           argument "style" is an array that may
                                           contain the following strings: "bold",
                                           "italic", "underline", "strikeout".

                                           (Edit Operation) Changes the float
                                           mode of the selected text. The
                                           argument "floatMode" can be one of
                                           the following strings: "none", "left",
                                           or "right".

                                           (Edit Operation) Changes the
                                           paragraph alignment of the selected
                                           text. The argument "paraAlign" can
                                           be one of the following strings: "left",
                                           "center", "right", or "justify".

Eventos            Descrição
   Nome do evento
  Veja Tratando eventos do Lua Form

Exemplos:
Exemplo 1 - Um richEdit simples

       <?xml version="1.0" encoding="UTF-8"?>
       <form ......>

              <richEdit align="client" backgroundColor="black" defaultFontColor="white" field="txt"/>
       </form>
```
