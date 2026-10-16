# Tag form

> Extraído de `docs/Firecast_SDK_-_Single formatado.pdf` (texto automático; tabelas podem ter colunas desalinhadas). 

```text
Tag form

     A tag/componente form representa uma ficha, um formulário ou uma janela do plug-in.
     As principais características do form são:
             ● Para que alguma interface visual seja apresentada na tela do usuário, é
                  necessário existir ao menos 1 form. Sem form, não há apresentação da

                  interface.
             ● Apenas os componentes que estão dentro de um form são apresentados na

                  tela.
             ● É possível existir um form dentro de outro form.
             ● É possível definir um tema para um form e todos os componentes que estão

                  dentro dele. Exemplo: Você quer que o form (e demais componentes) tenha

                  aparência escura ou clara?
             ● É possível associar um Nodo de um NodeDatabase (Ver NodeDatabase) a um

                  form. Quando você faz isso, todos os componentes de edição (que estão dentro

                  do form) passam a salvar os dados neste nodo.
                                 ○ Os modelos de ficha fazem isso! Mas você não precisa se
                                      preocupar com isso, pois o SDK 3 faz isso automaticamente

                                      para você ;) .

Herança

     O form possui todas as características de um controle qualquer. Veja Características de todas as
     tags visuais.

Características

     Além das características herdadas, o form possui também as seguintes características:

Propriedades e atributos da tag FORM

Propriedade  Tipo                     Valor    Descrição
                                      Padrão
title        String                   <string  Define o título do formulário.
                                      vazio>   Este título pode ser apresentado
description  String                            em vários lugares, como
                                      <string  identificação da ficha (se for um
                                      vazio>   modelo de ficha) ou como título de
                                               janela.

                                               Define um texto descritivo do
                                               formulário.
                                               Se for um modelo de ficha, este
                                               valor pode ser apresentado ao
                                               usuário durante a criação do
                                               personagem.
dataType  String                 <string    Define um tipo de dados que este
formType                         vazio>     formulário é capaz de editar.
                                            Se você está criando uma ficha
                                            nova, você deve inventar este
                                            texto. A partir de então, este será o
                                            identificador da sua ficha!
                                            Este campo deve ser preenchido se
                                            você estiver criando uma janela
                                            acoplável de mesa que salve dados
                                            em um NodeDatabase armazenado
                                            no servidor RRPG. Neste caso, o
                                            dataType serve para identificar
                                            qual NodeDatabase da mesa
                                            deverá ser aberto para salvamento
                                            de dados.
                                            O valor deve possuir ao menos 5
                                            caracteres alfanuméricos, "_" ou "."
                                            e não deve começar com um dígito.
                                            Exemplos:
                                            “RRPG.MeuNome.DnD5”
                                            “br.com.Meusite.VampiroAMascar
                                            a”
                                            "br.com.MeuSite.MeuTablesDock"

          Enumerado:             “undefine  Define a finalidade deste
                    ● “undefi    d”         formulário.
                         ned”               “sheetTemplate” – Este formulário
                    ● “sheetT               é um modelo de ficha.
                         emplat             "tablesDock" - Este formulário é
                                            uma janela acoplável de mesa.
                         e”                 Importante: Se você quiser que
                    ● "tables               sua janela acoplável de mesa salve
                                            dados em um NodeDatabase
                         Dock"              armazenado no servidor RRPG,
                                            preencha também a propriedade
                                            "dataType". Janelas acopláveis são
                                            visíveis apenas para assinantes
                                            Gold e/ou em mesas onde seu
                                            criador for Gold Plus.
                                            “undefined” – Este formulário não
                                            tem uma finalidade bem definida e
                                            pode ser usado para várias
                                            finalidades diferentes. O RRPG não
                                            fará nenhum tratamento especial.
theme      Enumerado:            “default”  Define o tema de cores que os
                     ● “default             componentes visuais terão neste
                                            formulário.
                          ”                 “default”: Tema padrão (cores
                     ● “light”              escuras).
                     ● “dark”               “light”: Tema de cores claras.
                                            “dark”: Tema de cores escuras.
                                            Observação: Mesmo que outros
                                            temas sejam adicionados
                                            futuramente, "default" sempre
                                            usará cores escuras.

lockWhileNodeIsLoading Boolean   true       Quando true, o form apresenta o
                                            texto “carregando” e trava a
minWidth   Float                 <o         interface enquanto o
                                 mesmo      NodeDatabase associado estiver
maxWidth   Float                 que        baixando dados.
                                 width>
isShowing  Boolean                          Quando dentro de uma tag
                                 <o         flowLayout ou quando for um item
                                 mesmo      de uma tag recordList layout
                                 que        "horizontalTiles" ou "verticalTiles",
                                 width>     define a largura mínima que este
                                            form pode assumir, o tornando
                                 False      adaptável ao "tamanho da tela".
                                            Quando não definido, o valor
                                            "width" será usado e, portanto, o
                                            form não mudará sua largura de
                                            forma dinâmica.

                                            Quando dentro de uma tag
                                            flowLayout ou quando for um item
                                            de uma tag recordList layout
                                            "horizontalTiles" ou "verticalTiles",
                                            define a largura máxima que este
                                            form pode assumir, o tornando
                                            adaptável ao "tamanho da tela".
                                            Quando não definido, o valor
                                            "width" será usado e, portanto, o
                                            form não mudará sua largura de
                                            forma dinâmica.

                                            (Somente Leitura) Esta
                                            propriedade contém True se o
                                            form está sendo exibido na
                                            interface do usuário ou false se o
                                            form não está visível.
 cacheMode           Enumerated:         "none"     Determines if and how the form
                               ● “none”             can be cached to improve the
Métodos da tag FORM            ● “time”             performance of loading character
 Método                                             sheets or showing items on record
                                                    lists/grid record lists.

                                                              ● "none" - No caching.
                                                                   When instances of this
                                                                   form are needed, new
                                                                   instances are always
                                                                   freshly allocated.

                                                              ● "time" - Cached by
                                                                   time. When instances
                                                                   of this form are no
                                                                   longer needed (e.g.,
                                                                   because a character is
                                                                   closed or an item is
                                                                   removed from a grid
                                                                   record list), the SDK3
                                                                   will keep the instance
                                                                   alive for 1 minute.
                                                                   When instances of this
                                                                   form are needed, the
                                                                   SDK3 will reuse
                                                                   cached free instances
                                                                   of this form instead of
                                                                   allocating a new one.

                                                    Remarks:
                                                              ● Prior to SDK version
                                                                   3.7, the SDK always
                                                                   used the "time" cache
                                                                   mode implicitly.
                                                              ● Caching forms can lead
                                                                   to significant
                                                                   performance gains, but
                                                                   the programmer needs
                                                                   to prepare their code
                                                                   for the reuse behavior:
                                                                   the same instance can
                                                                   be used to display
                                                                   more than one
                                                                   character's data.

                                         Descrição
form:setNodeObject(nodeObject)  Define em qual objeto nodo de um
form:getNodeObject();           NodeDatabase os controles de edição deste
form:lockWithActivity([msg])    formulário devem salvar os dados.
                                Parâmetros:
form:unlockWithActivity()
                                               ● nodeObject – Um objeto
                                                    Nodo (de um NodeDatabase)
                                                    ou nil.

                                Ver:
                                          ● NodeDatabase
                                          ● Escopo de Dados

                                Retorna o objeto nodo (de um
                                NodeDatabase) no qual os controles de
                                edição deste formulário devem salvar os
                                dados.
                                nil é retornado quando não há nodo
                                associado.
                                Ver:

                                          ● NodeDatabase
                                          ● Escopo de Dados

                                Desabilita a interação do usuário com o
                                formulário exibindo um indicador de
                                atividade e, opcionalmente, uma mensagem.
                                Ideal quando você quer fazer o usuário
                                aguardar a conclusão de algum processo
                                qualquer antes de voltar a interagir com a
                                interface.
                                Parâmetros:

                                          ● (OPCIONAL) msg - uma cadeia
                                               de caracteres contendo a
                                               mensagem que será exibida na
                                               interface.

                                Observações:
                                          ● Este método segue uma ideia de
                                               pilha: Você pode invocar este
                                               método mais de uma vez. Para
                                               cada chamada a este método,
                                               deve haver uma chamada do
                                               método unlockWithActivity para
                                               destravar a interface. A
                                               mensagem exibida será sempre a
                                               da última chamada ao método.

                                Volta a habilitar a interação entre o usuário e
                                a interface que foi previamente travada pelo
                                método form:lockWithActivity
                                Retorna true se o form foi realmente
                                liberado, ou false se precisar de mais
                                chamadas de unlockWithActivity para isso.
Eventos da tag Form  Descrição
 Nome do evento      Este evento é invocado quando o objeto nodo de um
 onNodeReady         NodeDatabase associado a este formulário está pronto para ser
                     usado.
 onNodeUnready       Quando este evento é chamado, você pode assumir:

 onNodeChanged                 ● a variável "sheet" do LuaForm está diferente de nil
 ou                                 e possui uma referência válida para um objeto nodo.
 onScopeNodeChanged
                               ● O processo de carregamento do nodeDatabase
                                    associado já chegou ao fim. Você já consegue
                                    acessar os dados armazenados nele normalmente.

                     Este evento é invocado quando o objeto nodo de um
                     NodeDatabase associado a este formulário deixa de estar
                     pronto para ser usado.
                     Quando este evento é chamado, você pode assumir:

                               ● a variável "sheet" do LuaForm não contém mais
                                    uma referência válida para um objeto nodo.

                     Este evento é invocado um objeto nodo de um NodeDatabase é
                     associado ou desassociado a este formulário.
                     Ver NodeDatabase

onShow               Este evento é invocado quando o formulário for ficar visível na
                     interface.

onHide               Este evento é invocado quando o formulário for ser
                     escondido/fechado.

Veja também Tratando eventos do Lua Form.
```
