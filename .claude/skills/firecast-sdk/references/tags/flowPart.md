# Tag flowPart

> Extraído de `docs/Firecast_SDK_-_Single formatado.pdf` (texto automático; tabelas podem ter colunas desalinhadas). 

```text
Tag flowPart

     A tag/componente flowPart representa uma parte dinâmica de um layout dinâmico (Ver Tag
     flowLayout). É um controle similar à uma tag layout, mas com a possibilidade de definir uma largura
     dinâmica, isto é, um layout que muda sua largura de acordo com a necessidade.
     Observação: Deve ser usado junto com a Tag flowLayout.
IMPORTANTE: Esta tag foi descontinuada. Prefira utilizar o sistema de alinhamento em grid em
vez desta tag.

Herança

     O flowPart possui todas as características da tag layout.
     Veja:

                               ○ Tag layout
                               ○ Características de todas as tags visuais.

Características

     Além das características herdadas, o flowPart possui também as seguintes características:

Propriedades e atributos

Propriedade               Tipo   Valor       Descrição
                                 Padrão
minWidth                  Float              Define a largura mínima que esta
                                 <o mesmo    parte dinâmica pode assumir.
                                 que width>  Quando não definido, o valor
                                             "width" será usado e, portanto, a
                                             parte não mudará sua largura de
                                             forma dinâmica.

maxWidth                  Float  <o mesmo    Define a largura máxima que esta
                                 que width>  parte dinâmica pode assumir.
                                             Quando não definido, o valor
                                             "width" será usado e, portanto, a
                                             parte não mudará sua largura de
                                             forma dinâmica.

minScaledWidth            Float  <o mesmo    Este valor deve ser menor ou
                                 que         igual à propriedade "minWidth".
                                 minWidth>   Quando definido, o layout
                                             dinâmico poderá utilizar, para
                                             este controle, uma largura menor
                                             que "minWidth", porém
                                             escalando o conteúdo de forma
                                             proporcional até uma largura
                                             mínima de "minScaledWidth"

maxScaledWidth            Float  <o mesmo    Este valor deve ser maior ou
                                 que         igual à propriedade "maxWidth".
                                 maxWidth>   Quando definido, o layout
                                             dinâmico poderá utilizar, para
                                             este controle, uma largura maior
                                             que "maxWidth", porém
                                             escalando o conteúdo de forma
                                             proporcional até uma largura
                                             máxima de "maxScaledWidth"
avoidScale  Boolean              false      Quando true e quando alguma
vertAlign                                   das propriedades
stepSizes   Enumerado:           "leading"  "minScaledWidth" e
                      ● "leadi              "maxScaledWidth" estiverem
                                            definidas, o layout dinâmico
                           ng"              assumirá uma largura menor que
                      ● "cente              "minWidth" ou maior que
                                            "maxWidth" apenas em último
                           r"               caso (Por exemplo: Quando um
                      ● "traili             controle por si só não caber
                                            numa única linha).
                           ng"
                                            Na linha do layout dinâmico que
            Arranjo de Float {}             este controle foi alocado, qual
                                            será seu alinhamento vertical?

                                                      ● "leading" - Este
                                                           controle estará
                                                           alinhado no topo de
                                                           sua linha

                                                      ● "center" - Este
                                                           controle estará
                                                           alinhado no centro
                                                           de sua linha

                                                      ● "trailing" - Este
                                                           controle estará
                                                           alinhado no rodapé
                                                           de sua linha.

                                            Por padrão, este controle poderá
                                            ter qualquer largura entre
                                            "minWidth" e "maxWidth" (uma
                                            faixa de números reais).
                                            Ao usar "stepSizes", este
                                            controle assumirá apenas alguma
                                            das larguras que estão no
                                            arranjo.
                                            Exemplos:

                                                      ● {100, 200, 300} - O
                                                           controle poderá
                                                           assumir larguras 100,
                                                           200 ou 300.. Não
                                                           poderá assumir, por
                                                           exemplo, a largura
                                                           150.

                                                      ● {200, 450} - o
                                                           controle poderá
                                                           assumir ou a largura
                                                           de 200 ou de 450.

                                            Observação: Ao usar esta
                                            propriedade, o controle passa a
                                            desconsiderar as propriedades
                                            "minWidth" e "maxWidth"
                                            (porém minScaledWidth e
adjustHeightToLine  Boolean  false  maxScaledWidth continuam
                                    sendo respeitados)

                                    Quando true, este controle pode
                                    se redimensionar a fim de ocupar
                                    todo o espaço vertical da linha
                                    em que foi alocado.

Exemplos

Exemplo 1 - Layout Dinâmico usando flowPart para se ajustar a vários tamanhos de interfaces

 <?xml version="1.0" encoding="UTF-8"?>
 <form name="frmFichaTeste">

                <style>
                              flowPart {
                                             margins: {left=5, right=5, top=5, bottom=5};
                              }

                              label {
                                             width: 75;
                                             horzTextAlign: trailing;
                                             margins: {right=5};

                              }
                </style>

                <flowLayout align="client" orientation="horizontal" horzAlign="justify"
                                      margins="{left=20, top=20, bottom=20, right=20}">

                              <flowPart minWidth="130" maxWidth="200" height="25">
                                             <label align="left" text="Força: "/>
                                             <edit align="client"/>

                              </flowPart>

                              <flowPart minWidth="130" maxWidth="200" height="25">
                                             <label align="left" text="Destreza: "/>
                                             <edit align="client"/>

                              </flowPart>

                              <flowPart minWidth="130" maxWidth="200" height="25">
                                             <label align="left" text="Constituição: "/>
                                             <edit align="client"/>

                              </flowPart>

                              <flowPart minWidth="130" maxWidth="200" height="25">
                                             <label align="left" text="Inteligência: "/>
                                             <edit align="client"/>
                              </flowPart>
                </flowLayout>
 </form>

Neste exemplo foi utilizada a Tag style para aplicar algumas propriedades a vários controles de uma só
vez. Cada tag flowPart usada pode assumir largura entre 130 e 200.
```
