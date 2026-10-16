# Frames e Regiões (tags frame, borders, draw, anchors, regions...)

> Extraído de `docs/Firecast_SDK_-_Single formatado.pdf` (texto automático; tabelas podem ter colunas desalinhadas). 

```text
Frames

       Algumas tags/controles do Lua Form permitem o programador definir um frame, isto é, uma
       moldura para ser exibida na interface visual.
       Um frame é uma aparência personalizada que se adapta dinamicamente ao tamanho do
       controle.

Ainda não entendi o que é um frame.

       Veja estes exemplos para entender melhor!

    <?xml version="1.0" encoding="UTF-8"?>
    <form name="frmFichaTeste">
              <layout align="client" frameStyle="/frames/frame1.xml"
                             margins="{left=10, top=10, right=10, bottom=10}">
                             <label align="client" horzTextAlign="center"

text="Conteudo do Layout"/>
              </layout>

</form>

<?xml version="1.0" encoding="UTF-8"?>
<form name="frmFichaTeste">
                   <layout align="client" frameStyle="/frames/meuOutroFrame.xml"
                                 margins="{left=10, top=10, right=10, bottom=10}">
                                 <label align="client" horzTextAlign="center"

    text="Conteudo do Layout"/>
                   </layout>

    </form>

       A tag layout por si só não apresenta nada na interface, mas ao aplica um frame à ela, passou a
       apresentar estas bordas e backgrounds "legais".

O que eu preencho na propriedade "frameStyle"?

       Você deve preencher com o caminho de um arquivo XML que contém a definição de um frame.
       Saiba mais sobre este arquivo lendo Arquivo de Definição de Frame.
Exemplos

       Veja alguns exemplos em Exemplos de frames.

Arquivo de Definição de Frame

       Todo frame é definido por um documento XML que segue o padrão descrito neste tópico.

       Importante: Não é possível utilizar as tags do Lua Form na definição de frames. O documento
       de definição de frames possui seu próprio conjunto de tags e atributos.

Estrutura do documento XML de definição de frame

       Todo documento de XML de definição de frame deve ter a tag frame como tag raiz.

Tag frame
       Atributos:

Propriedade        Tipo                             Valor       Descrição
                                                    Padrão

width              Float                            <Não há     A largura em que o
                                                    valor       frame foi definido.
                                                    padrão e
                                                    deve ser    Todo o restante do
                                                    preenchido  frame será
                                                    >           interpretado usando
                                                                esta largura como
                                                                base.

height             Float                            <Não há     A altura em que o
                                                    valor       frame foi definido.
                                                    padrão e
                                                    deve ser    Todo o restante do
                                                    preenchido  frame será
                                                    >           interpretado usando
                                                                esta altura como
                                                                base.

autoScaleX         Boolean                          false       Indica como o frame
                                                                deve se comportar
                                                                ao ser apresentado
                                                                em um tamanho
                                                                diferente do que foi
                                                                definido.

                                                                true - O conteúdo do
                                                                frame será esticado
autoScaleY       Boolean             false  ou comprimido no
                                            eixo X para equivaler
   Tags filhas:                             à nova largura.
Tag filha
borders                                     false - O conteúdo do
draw                                        frame será
                                            reposicionado no
                                            eixo X, respeitando o
                                            ancoramento de
                                            cada item do
                                            conteúdo do frame.

                                            Indica como o frame
                                            deve se comportar
                                            ao ser apresentado
                                            em um tamanho
                                            diferente do que foi
                                            definido.

                                            true - O conteúdo do
                                            frame será esticado
                                            ou comprimido no
                                            eixo Y para equivaler
                                            à nova altura.

                                            false - O conteúdo do
                                            frame será
                                            reposicionado no
                                            eixo Y, respeitando o
                                            ancoramento de
                                            cada item do
                                            conteúdo do frame.

                 Quantidade                 Descrição
                 0 ou 1. (opcional)
                                            Descreve o tamanho das
                 0 ou 1. (opcional)         bordas que o frame possui.

                                            Leia mais em Tag borders

                                            Define os itens que serão
                                            desenhados no frame.

                                            Leia mais em Tag draw.

                                            Estes itens são
                                            desenhados embaixo dos
                                            controles Lua Form de
                                            onde o frame for aplicado.
postdraw           0 o ou 1. (opcional)          Define os itens que serão
regions            0 ou 1. (opcional)            desenhados após o
                                                 conteúdo do frame ser
                                                 desenhado.

                                                 Leia mais em Tag
                                                 postdraw.

                                                 Estes itens são
                                                 desenhados em cima dos
                                                 controles Lua Form de
                                                 onde o frame for aplicado.

                                                 Define as regiões que este
                                                 frame possui. Usado para
                                                 alinhar controles Lua
                                                 Form no lugar correto do
                                                 frame.

                                                 Leia mais em Tag regions.

Tag borders        Tipo                  Valor   Descrição
       Atributos:  Float                 Padrão
                   Float                 0.0     Define o tamanho da
   Propriedade     Float                         borda esquerda do
   left            Float                 0.0     frame.

   top                                   0.0     Define o tamanho da
                                                 borda superior do
   right                                 0.0     frame.

   bottom                                        Define o tamanho da
                                                 borda da direita do
                                                 frame.

                                                 Define o tamanho da
                                                 borda inferior do
                                                 frame.

Tag draw
Esta tag contém todos os elementos que são desenhados no frame.

Atributos: Esta tag não possui atributos
Tags filhas:

Tag filha          Quantidade                  Descrição

image              0 ou várias vezes. (lista)  Cada tag image representa
                                               uma imagem que será
                                               desenhada.

                                               Leia mais em Tag image.

Tag postdraw
       Esta tag contém todos os elementos que são desenhados no frame.

Atributos: Esta tag não possui atributos
Tags filhas:

Tag filha          Quantidade                  Descrição

image              0 ou várias vezes. (lista)  Cada tag image representa
                                               uma imagem que será
                                               desenhada acima do
                                               controles Lua Form.

                                               Leia mais em Tag image.

Tag image          Tipo                   Valor         Descrição
       Atributos:  Float                  Padrão
                                                        Define onde, no
   Propriedade                            <Não há,      eixo X, a imagem
                                          preenchime    será desenhada.
   left                                   nto
                                          obrigatório>  Define onde, no
top                Float                                eixo Y, a imagem
                                          <Não há,      será desenhada.
                                          preenchime
                                          nto
                                          obrigatório>
right      Float                  <Não há,      Define onde, no
bottom                            preenchime    eixo X, a borda
overflowX  Float                  nto           direita da imagem
                                  obrigatório>  será desenhada.
           Enumerado:
                     ● "none"     <Não há,      A largura da
                     ● "tile"     preenchime    imagem será
                     ● "stretch"  nto           equivalente a
                     ● "center"   obrigatório>  ("right" - "left")

                                  "tile"        Define onde, no
                                                eixo Y, a borda
                                                inferior da imagem
                                                será desenhada.

                                                A altura da imagem
                                                será equivalente a
                                                ("bottom" - "top")

                                                Define como a
                                                imagem será
                                                desenhada no eixo
                                                X quando a largura
                                                a desenhar for
                                                diferente da
                                                largura definida.

                                                "none": A imagem
                                                será desenhada
                                                apenas uma vez, a
                                                cortando se o
                                                tamanho diminuir.

                                                "tile": A imagem
                                                será desenhada
                                                várias vezes para
                                                que ocupe o novo
                                                tamanho.

                                                "stretch": A
                                                imagem será
                                                encolhida ou
                                                espichada para o
                                                novo tamanho.

                                                "center": A imagem
                                                será desenhada
                                                apenas uma vez no
                                                centro.
overflowY        BoEnumerado:           "tile"  Idem ao atributo
zOrder                     ● "none"     0.0     "overflowX",
                           ● "tile"             porém agora
   Tags filhas:            ● "stretch"          analisando a altura
Tag filha                  ● "center"           e o eixo Y da
source                                          imagem.
                 Float
anchors                                         Define a ordem em
                                                que esta imagem
                                                será desenhada.

                                                A image que tiver o
                                                menor zOrder será
                                                desenhada
                                                embaixo das
                                                outras, enquanto a
                                                que tiver maior
                                                zOrder será
                                                desenhada acima.

                 Quantidade                     Descrição
                 1 vez (preenchimento
                 obrigatório)                   A tag source contém
                                                informações sobre qual
                 0 ou 1 (opcional).             imagem será desenhada.

                                                Leia mais em tag source.

                                                Observação:

                                                Enquanto a tag image
                                                possui informações
                                                relacionadas ao "onde a
                                                imagem será desenhada",
                                                a tag source possui
                                                informações de qual
                                                imagem será desenhada.

                                                Define como a imagem
                                                será ancorada quando o
                                                frame for desenhado com
                                                um tamanho maior ou
                                                menor do que o definido.

                                                Leia mais em tag anchors

                                                A ausência desta tag
                                                implica no ancoramento
                                         "left e top".

Tag source         Tipo    Valor         Descrição
       Atributos:  String  Padrão
                           <Não há,      Caminho do arquivo
   Propriedade             preenchime    da imagem que será
                           nto           desenhada na tela.
   url                     obrigatório>
                                         Contém um caminho
left               Float   <Não há,      relativo à pasta em
                           preenchime    que se encontra o
top                Float   nto           arquivo ".xml" de
                           obrigatório>  definição deste frame.

                           <Não há,      Este atributo é usado
                           preenchime    para definir qual parte
                           nto           da imagem, informada
                           obrigatório>  pelo atributo "url",
                                         será desenhada na
                                         tela.

                                         É possível desenhar a
                                         imagem inteira, ou
                                         apenas um
                                         pedaço/retângulo
                                         dela (o que é bastante
                                         útil).

                                         Medido em pixels,
                                         informa a posição
                                         esquerda do
                                         pedaço/retângulo que
                                         será desenhado na
                                         tela.

                                         Medido em pixels,
                                         informa a posição
                                         superior do
                                         pedaço/retângulo que
                                         será desenhado na
                                         tela.
                                                Veja a descrição do
                                                atributo "left".

right        Float                <Não há,      Medido em pixels,
                                  preenchime    informa a posição da
                                  nto           direita do
                                  obrigatório>  pedaço/retângulo que
                                                será desenhado na
                                                tela.

                                                Veja a descrição do
                                                atributo "left".

bottom       Float                <Não há,      Medido em pixels,
                                  preenchime    informa a posição
                                  nto           inferior do
                                  obrigatório>  pedaço/retângulo que
                                                será desenhado na
                                                tela.

                                                Veja a descrição do
                                                atributo "left".

Tags filhas:
    Não há tags filhas.

Tag anchors

       Define o ancoramento do componente.
       Quando o frame for desenhado com um tamanho diferente do desenhado, o componente
       mantém sua posição relativa baseada em sua âncora.

       Atributos:

Propriedade              Tipo     Valor         Descrição
                                  Padrão

left                     Boolean  false         Quando true, define

                                                um âncora à

                                                esquerda.

                                                Leia as observações
                                                abaixo desta tabela.

top                      Boolean  false         Quando true, define

                                                um âncora acima.

                                                Leia as observações
                                                abaixo desta tabela.
right      Boolean                        false  Quando true, define
                                                 um âncora à direita.

                                                 Leia as observações
                                                 abaixo desta tabela.

bottom     Boolean                        false  Quando true, define
                                                 um âncora abaixo.

                                                 Leia as observações
                                                 abaixo desta tabela.

Comportamento de âncora:

                         ○ “left” = true, ”right” = false: O componente manterá sempre a mesma
                               posição left/X.

                         ○ “left” = false, “right” = true: A posição left será calculada
                               automaticamente para manter sempre a mesma distância entre sua
                               borda direita e a borda direita do pai/frame.

                         ○ “left” e “right” ambos = true: O controle manterá tanto a distância entre
                               (1) sua borda esquerda com a borda esquerda do pai/frame; (2) como
                               sua borda direita com a borda direita do pai/frame. Para isso, a largura
                               do componente será alterada conforme o tamanho de visualização do
                               frame.

                         ○ “left” e “right” ambos = false: O controle não está ancorado e ocorrerá
                               um efeito similar ao de centralização.

O comportamento das âncoras “top” e “bottom” é o mesmo das âncoras “left” e “right”, porém
agora no eixo Y.

Tags filhas:

    Não há tags filhas.

Tag regions

       Esta tag contém uma lista de tags region, que define regiões no frame que poderão ser usadas
       para alinhar tags/controles Lua Form posteriormente. Saiba mais em Frames e Regiões.

Atributos: Esta tag não possui atributos
Tags filhas:

Tag filha  Quantidade                            Descrição

region     0 ou várias vezes. (lista)            Cada tag image representa
                                                 uma região do frame
                                                 Leia mais em Tag region.
Tag region         Tipo     Valor         Descrição
       Atributos:  String   Padrão
                                          Define um nome
   Propriedade              <Não há,      para esta região para
                            preenchime    que possa ser usada
   name                     nto           posteriormente por
                            obrigatório>  um controle Lua
left               Float                  Form. Saiba mais em
top                Float    <Não há,      Frames e Regiões.
right              Float    preenchime
                            nto           Define, onde no eixo
bottom             Float    obrigatório>  X, é a posição
                                          esquerda desta
autoScaleX         Boolean  <Não há,      região no frame.
                            preenchime
                            nto           Define, onde no eixo
                            obrigatório>  Y, é a posição
                                          superior desta região
                            <Não há,      no frame.
                            preenchime
                            nto           Define, onde no eixo
                            obrigatório>  X, é a posição da
                                          direita desta região
                            <Não há,      no frame.
                            preenchime
                            nto           A largura da região
                            obrigatório>  será equivalente a
                                          ("right" - "left")
                            false
                                          Define, onde no eixo
                                          Y, é a posição
                                          inferior desta região
                                          no frame.

                                          A altura da região
                                          será equivalente a
                                          ("bottom" - "top")

                                          Indica como as sub-
                                          regiões desta região
                                          devem se comportar
                                          ao ser apresentadas
                                          em um tamanho de
                                          frame diferente do
autoScaleY       Boolean             false  que foi definido.

   Tags filhas:                             true - As sub-regiões
Tag filha                                   serão esticadas ou
anchors                                     comprimidas no eixo
                                            X para equivaler à
                                            nova largura.

                                            false - As sub-regiões
                                            serão reposicionadas
                                            no eixo X,
                                            respeitando seus
                                            ancoramentos.

                                            Indica como as sub-
                                            regiões desta região
                                            devem se comportar
                                            ao ser apresentadas
                                            em um tamanho de
                                            frame diferente do
                                            que foi definido.

                                            true - As sub-regiões
                                            serão esticadas ou
                                            comprimidas no eixo
                                            Y para equivaler à
                                            nova altura.

                                            false - As sub-regiões
                                            serão reposicionadas
                                            no eixo Y,
                                            respeitando seus
                                            ancoramentos

                 Quantidade                 Descrição
                 0 ou 1 (opcional).
                                            Define como a região será
                                            ancorada quando o frame
                                            for desenhado com um
                                            tamanho maior ou menor
                                            do que o definido.

                                            Leia mais em tag anchors

                                            A ausência desta tag
                                            implica no ancoramento
                                            "left e top".
regions  0 ou 1 (opcional).                     Define as sub-regiões
                                                desta região.

                                                Leia mais em Tag regions.

Exemplos

       Veja os exemplos em Exemplos de frames.

Frames e Regiões

                 Os frames podem possuir regiões em suas definições que são acessíveis à
       tags/componentes do LuaForm. Ao associar uma região de frame à algum componente do Lua
       Form, o controle automaticamente terá sua posição e tamanho ajustados para que ocupe a
       região escolhida do frame.

                 Veja o exemplo de frame com regiões.

Exemplos de frames

       1 - Background que estica para o novo tamanho
       2 - Background que se repete para preencher o tamanho
       3 - Frame com 2 partes fixas e 1 parte que se estica
       4 - Frame retangular dinâmico, usando vários arquivos de imagens
       5 - Frame com regiões
       Os exemplos acima são arquivos de definições de frame utilizados em tags layout da seguinte
       forma em um Lua Form:

    <?xml version="1.0" encoding="UTF-8"?>
    <form name="frmFichaTeste">

                   <layout align="client" frameStyle="/frames/frame1.xml"
                                 margins="{left=10, top=10, right=10, bottom=10}">

                                 <label align="client" horzTextAlign="center"
    text="Conteudo do Layout"/>
                   </layout>
    </form>

1 - Background que estica para o novo tamanho

  Arquivo de imagem: background1.png (tamanho 256x223)

    <?xml version="1.0" encoding="UTF-8"?>
    <frame width="256" height="223">

                   <draw>
                                 <!-- Imagem de fundo -->

                                 <image left="0" top="0" right="256" bottom="223"
    overflowX="stretch" overflowY="stretch">

                                                <anchors left="true" top="true" bottom="true"
    right="true"/>

                                                <source url="background1.png" left="0" right="256"
    top="0" bottom="223"/>

                                 </image>
                   </draw>
    </frame>
2 - Background que se repete para preencher o tamanho

  Arquivo de imagem: background1.png (tamanho 256x223)

    <?xml version="1.0" encoding="UTF-8"?>
    <frame width="256" height="223">

                   <draw>
                                 <!-- Imagem de fundo -->

                                 <image left="0" top="0" right="256" bottom="223"
    overflowX="tile" overflowY="tile">

                                                <anchors left="true" top="true" bottom="true"
    right="true"/>

                                                <source url="background1.png" left="0" right="256"
top="0" bottom="223"/>
                             </image>

              </draw>
</frame>
3 - Frame com 2 partes fixas e 1 parte que se estica

  Dada a seguinte imagem (header0_smaller.png) de tamanho 468x100:

  Criamos um frame que se escala na vertical (autoScaleY = true) e que possui 3 partes:
                                 ○ A parte da esquerda, âncora à esquerda, desenha uma porção da
                                      imagem (um retângulo de 84x100)
                                 ○ A parte da direita, âncora à direita, desenha uma outra porção da
                                      imagem (um retângulo 40x100)
                                 ○ A parte central, âncora à esquerda e à direita, desenha uma outra
                                      porção da imagem (um retângulo 341x100) de forma esticada.
<?xml version="1.0" encoding="UTF-8"?>
<frame width="468" height="100" autoScaleY="true">

              <borders left="12" top="24" bottom="24" right="20" />
              <draw>

                             <!-- Parte Esquerda (FIXA) -->
                             <image left="0" top="0" right="84" bottom="100"zOrder="0">

                                           <anchors left="true" top="true" bottom="true"/>
                                           <source url="header0_smaller.png" left="0"
right="84" top="0" bottom="100"/>
                             </image>

                             <!-- Parte Direita (FIXA) -->
                             <image left="425" top="0" right="468" bottom="100"
zOrder="0">

                                           <anchors left="false" top="true" bottom="true"
right="true"/>

                                           <source url="header0_smaller.png" left="425"
right="468" top="0" bottom="100"/>

                             </image>

                             <!-- Parte Central (ESTICA) -->
                             <image left="84" top="0" right="425" bottom="100"

                                         overflowX="stretch" overflowY="stretch" zOrder="-
1">

                                           <anchors left="true" top="true" bottom="true"
right="true"/>

                                           <source url="header0_smaller.png" left="84"
right="425" top="0" bottom="100"/>

                             </image>
              </draw>
</frame>
4 - Frame retangular dinâmico, usando vários arquivos de imagens

  Deseja-se formar um frame com a seguinte aparência:

  Para isso, dividimos a figura em 8 partes
                                             leftLine.png (12x66)
                                             rightLine.png (12x66)
                                             lowerDir.png (29x32)
                       lowerEsq.png (29x32)

                       upperDir.png (29x32)

                       upperEsq.png (29x32)

                                           lowerLine.png (80x5)
                                           upperLine.png (80x5)
e usamos o seguinte arquivo de definição de frame:

<?xml version="1.0" encoding="UTF-8"?>
<frame width="138" height="130">

              <borders left="12" top="10" bottom="10" right="12"/>
              <draw>

                                           <!-- QUINAS -->
                                           <!-- quina superior esquerda -->
                                           <image left="0" top="0" right="29" bottom="32"
overflowX="stretch">

                                                          <anchors left="true" top="true"/>
                                                          <source url="upperEsq.png" left="0" right="29"
top="0" bottom="32"/>
                                           </image>

                                           <!-- quina superior direita -->
                                         <image left="109" top="0" right="138" bottom="32"
overflowX="stretch" overflowY="stretch">

                                                          <anchors left="false" right="true" top="true"/>
                                                          <source url="upperDir.png" left="0" right="29"
top="0" bottom="32"/>
                                           </image>

                       <!-- quina inferior esquerda -->
                       <image left="0" top="98" right="29" bottom="130">

                                     <anchors left="true" top="false" bottom="true"/>
                                     <source url="lowerEsq.png" left="0" right="29"

top="0" bottom="32"/>
                       </image>

bottom="true"/>        <!-- quina inferior direita -->
top="0" bottom="32"/>  <image left="109" top="98" right="138" bottom="130">

                                     <anchors left="false" right="true" top="false"

                                     <source url="lowerDir.png" left="0" right="29"

                       </image>

                                         <!-- LINHAS -->
                                           <!-- linha horizontal superior -->
                                           <image left="29" top="0" right="109" bottom="5"

zOrder="-1" overflowX="stretch">
                                                          <anchors left="true" right="true" top="true"/>
                                                          <source url="upperLine.png" left="0" right="80"

top="0" bottom="5"/>
                                           </image>

                                           <!-- linha horizontal inferior -->
                                           <image left="29" top="125" right="109" bottom="130"
zOrder="-1" overflowX="stretch">

                                                          <anchors left="true" right="true" top="false"
bottom="true"/>

                                                          <source url="lowerLine.png" left="0" right="80"
top="0" bottom="5"/>

                                           </image>

overflowX="stretch">    <!-- linha vertical esquerda -->
top="true"/>           <image left="0" top="32" right="12"
top="0" bottom="66"/>
                                   bottom="98" zOrder="-1" overflowY="stretch"

                                     <anchors left="true" right="false" bottom="true"

                                     <source url="leftLine.png" left="0" right="12"

                       </image>

                       <!-- linha vertical direita -->
overflowX="stretch">   <image left="126" top="32" right="138" bottom="98"
top="true"/>                       zOrder="-1" overflowY="stretch"
top="0" bottom="66"/>                <anchors left="false" right="true" bottom="true"
                                     <source url="rightLine.png" left="0" right="12"
              </draw>
</frame>               </image>
5 - Frame com regiões

  Deseja-se montar um frame com 2 regiões com a seguinte aparência:
O exemplo utiliza um arquivo de imagem "pecaCobre.png" de tamanho 228x94
Arquivo de definição de frame:

 <?xml version="1.0" encoding="UTF-8"?>
 <frame width="228" height="94" autoScaleY="true" autoScaleX="true">

                <borders left="6" top="7" bottom="6" right="39" />
                <draw>

                              <!-- fundo -->
                              <image left="0" top="0" right="228" bottom="94"

                                           overflowX="stretch" overflowY="stretch" zOrder="-
 1">

                                             <anchors left="true" top="true" bottom="true"
 right="true"/>

                                             <source url="pecaCobreBckBlack.png" left="0"
 right="228" top="0" bottom="94"/>

                              </image>
                </draw>

                <regions>
                              <region name="RegiaoSmallTitulo" left="15" top="30"

 right="45" bottom="64">
                                             <anchors left="true" top="true" bottom="true"

 right="true"/>
                              </region>

                              <region name="RegiaoValor" left="85" top="7" right="187"
 bottom="89">

                                             <anchors left="true" top="true" bottom="true"
 right="true"/>

                              </region>
                </regions>
 </frame>
Uso no Lua Form:

 <?xml version="1.0" encoding="UTF-8"?>
 <form name="frmFichaTeste">

                <layout align="top" frameStyle="/frames/meuframe.xml"
                              margins="{left=30, top=30, right=30, bottom=5}">
                              <label horzTextAlign="center" text="PO"

 frameRegion="RegiaoSmallTitulo"/>
                              <label horzTextAlign="center" text="500"

 frameRegion="RegiaoValor"/>
                </layout>
                <layout align="top" frameStyle="/frames/meuframe.xml"
                              margins="{left=30, top=5, right=30, bottom=5}">
                              <label horzTextAlign="center" text="PP"

 frameRegion="RegiaoSmallTitulo"/>
                              <label horzTextAlign="center" text="8"
```
