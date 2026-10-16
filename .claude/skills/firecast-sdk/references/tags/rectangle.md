# Tag rectangle

> Extraído de `docs/Firecast_SDK_-_Single formatado.pdf` (texto automático; tabelas podem ter colunas desalinhadas). 

```text
Tag rectangle

       A tag/componente rectangle representa um retângulo na interface o qual você pode
       personalizar cores, bordas e outros aspectos da forma.

Herança

       O rectangle possui todas as características de um controle shape/forma.
       Veja

                                 ○ Características de tags shapes
                                 ○ Características de todas as tags visuais.

Características

       Além das características herdadas, o rectangle possui também as seguintes características:

Propriedades e atributos

Propriedade               Tipo                 Valor Padrão Descrição

corners                   Conjunto de:         "topLeft     Identifica quais quinas do
                                               topRight     controle serão
                                    ● "to      bottomLeft   customizadas pela
                                         pLe   bottomRight  propriedade
                                         ft"   "            "cornerType"

                                    ● "to                   Exemplos:
                                         pRi
                                         ght                          ● Apenas as
                                         "                                 duas quinas
                                                                           superiores:
                                    ● "bo                                  "topLeft
                                         tto                               topRight"
                                         mL
                                         eft"                         ● Apenas as
                                                                           duas quinas
                                    ● "bo                                  da esquerda:
                                         tto                               "topLeft
                                         mRi                               bottomLeft"
                                         ght
                                         "                            ● Todas as
                                                                           quinas:
                                                                           "topLeft
                                                                           topRight
                                                                           bottomLeft
                                                                           bottomRight
                                                                           "

                                                                      ● Nenhuma
                                                                           quina:
                                                                           ""
cornerType  Enumerado:           "round"    Especifica o tipo de
sides                                       formato que as quinas
                      ● "ro      "top left  deste retângulo terão.
xradius                    und   bottom
yradius                    "     right"     Você deve especificar
                                            valores das propriedades
                      ● "be                 "xradius" e "yradius"
                           vel"             para o formato das
                                            quinas serem visíveis.
                      ● "inn
                           erR              Veja o Exemplo 3 para
                           oun              mais detalhes.
                           d"
                                            Define quais bordas
                      ● "inn                serão desenhadas na
                           erLi             interface.
                           ne"
                                            Exemplos:
            Conjunto de:
                                                      ● Apenas a
                      ● "to                                borda
                           p"                              superior:
                                                           "top"
                      ● "lef
                           t"                         ● Apenas as
                                                           bordas
                      ● "bo                                laterais: "left
                           tto                             right"
                           m"
                                                      ● Todas as
                      ● "rig                               bordas: "top
                           ht"                             left bottom
                                                           right"
            Float                0.0
                                                      ● Nenhuma
            Float                0.0                       borda: ""

                                            Define a "largura" do
                                            efeito das quinas
                                            (propriedade
                                            "cornerType""

                                            Veja o Exemplo 3 para
                                            mais detalhes.

                                            Define a "altura" do
                                            efeito das quinas
                                            (propriedade
                                            "cornerType""

                                            Veja o Exemplo 3 para
                                                                                      mais detalhes.

Exemplos
Exemplo 1 - Retângulo simples

    <?xml version="1.0" encoding="UTF-8"?>
    <form name="frmFichaTeste">

                   <rectangle left="20" top="20" width="200" height="200" color="yellow"/>
    </form>

Exemplo 2 - Retângulo com bordas simples

    <?xml version="1.0" encoding="UTF-8"?>
    <form name="frmFichaTeste">

                   <rectangle left="20" top="20" width="200" height="200"
                                       color="black" strokeColor="red" strokeSize="5"/>

    </form>
Exemplo 3 - Retângulo com quinas variadas

    <?xml version="1.0" encoding="UTF-8"?>
    <form name="frmFichaTeste">

                   <rectangle left="20" top="20" width="200" height="200"
                                       color="yellow" strokeColor="red" strokeSize="5"
                                       xradius="25" yradius="25" cornerType="round"/>

    </form>

cornerType="round"

                    cornerType="bevel"
cornerType="innerRound"  cornerType="innerLine"

Exemplo 4 - Retângulo com quinas variadas e sem bordas

    <?xml version="1.0" encoding="UTF-8"?>
    <form name="frmFichaTeste">

                   <rectangle left="20" top="20" width="200" height="200"
                                       color="yellow" xradius="25" yradius="25" cornerType="round"/>

    </form>

cornerType="round"

                         cornerType="bevel"
cornerType="innerRound"                    cornerType="innerLine"
```
