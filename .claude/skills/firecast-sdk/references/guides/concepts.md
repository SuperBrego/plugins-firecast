# HD Virtual, Modelos de ficha, NodeDatabase, Sandbox, Lua Form (cores, escopo de dados, instâncias, Grid System)

> Extraído de `docs/Firecast_SDK_-_Single formatado.pdf` (texto automático; tabelas podem ter colunas desalinhadas). 

```text
HD Virtual

     Cada plug-in possui seu próprio HD Virtual

Principais características do HD Virtual

               ● Cada plugin possui um HD Virtual. Um plug-in não acessa o conteúdo do HD virtual de
                    outro plug-in.

               ● Os plug-ins não conseguem acessar arquivos que estão fora de seu “HD Virtual”
                    diretamente. Isto significa que o plugin não enxerga o drive de armazenamento real do
                    dispositivo em que está rodando. A única forma do plug-in conseguir acessar arquivos
                    no HD do usuário é através das funlções dialogs.openFile e dialogs.saveFile

               ● Os arquivos do “HD virtual” são persistentes, isto é, ficam salvos mesmo quando o
                    dispositivo é desligado.

               ● O conteúdo do “HD virtual” é perdido quando seu plug-in é desinstalado.
               ● O VHD (HD Virtual) do plugin é composto pela união lógica do conteúdo do

                    arquivo .rpk + arquivos que foram criados durante a execução. O Firecast faz essa
                    união lógica automaticamente de forma transparente para que o programador não
                    precise se preocupar.
               ● Todos os arquivos originais do plug-in (aqueles que estão contidos na pasta projeto do
                    plug-in) ficam no modo somente-leitura. Não é possível apagar e nem alterá-los.
               ● Ao instalar uma nova versão de plugin, os arquivos que foram criados durante
                    execução do módulo são preservados.

Sobre o sistema de arquivos no HD Virtual

               ● O caractere separador de diretórios é “/”
               ● A raiz do HD virtual é o diretório “/”
               ● Os nomes de arquivos e pastas são case-sensitives, isto é, letras maiúsculas são

                    diferentes das mesmas letras em sua forma minúscula. (Exemplo: “/arquivo.lua” e
                    “/Arquivo.lua” são dois arquivos distintos)

Manipulando o HD Virtual:
Para manipular o HD Virtual, o SDK3 provê a biblioteca "VHD" .

Modelos de Fichas

          Cada modelo de ficha do SDK3 é um documento Lua Form (extensão ‘.lfm’) e toda vez que o
usuário abre um personagem, o RRPG Firecast localiza o Lua Form adequado, cria uma nova instância e
a exibe na tela.

          Veja:
                                                   ■ Interfaces Visuais (Lua Forms)
                                                   ■ Lua Form e Instâncias

Criando um novo modelo de ficha

    Para criar um novo modelo de ficha:
                    1. Crie um arquivo texto vazio de extensão ‘.lfm” dentro da pasta do projeto do plug-
                         in.
                    2. Abra o arquivo em um editor de texto, copie e cole o seguinte documento:

            <?xml version="1.0" encoding="UTF-8"?>

            <form formType="sheetTemplate" dataType="DATA_TYPE_AQUI"
                       title="TITULO_AQUI" name="NOME_AQUI">

            </form>

1. Preencha os campos “dataType”, “title” e “name”:
               a. dataType – Um texto que identifica qual é o tipo de conteúdo do seu
                     modelo de ficha. Você deve inventar um Data Type único que possua
                     ao menos cinco caracteres alfanuméricos, "_" ou "." e que não comece
                     com dígitos. Use a criatividade! Exemplos: “br.com.rrpg.DnD5_S3”,
                     “br.com.rrpg.VampiroAMascara”,
                     “br.com.meusite.MeuModeloDeFicha”, “meuplugin.FichaX”, etc..

                   b. title – O título do seu modelo de ficha. Este texto aparecerá na lista de
                        fichas quando o usuário criar um personagem. Exemplos: “DnD 5th”,
                        “Vampiro a Máscara”, “Meu modelo de ficha”, etc..

               1.            c. name – Nome interno do Lua Form. Deve conter apenas caracteres
Veja agora:                       alfanuméricos ou "_" e não deve começar com dígitos. Exemplos:
                                  “frmDnD5”, “frmVampiroAMascara”, “frmMeuModeloDeFicha”, etc..
               1.                 Apesar de não ser exigida, a prática de colocar “frm” no início do name é
                                  recomendada.
               2.
                   Pronto! Você acaba de criar um modelo de ficha vazio.

                   Interfaces Visuais (Lua Forms) para saber mais sobre o arquivo .lfm e completar seu
                   plug-in.
                   Tutoriais para ter mais ideias para seu modelo de ficha =).
Criando um novo modelo de ficha - Exemplo passo a passo

          O exemplo a seguir utiliza o editor de texto Notepad++.
                    1. Criando o arquivo texto vazio de extensão ‘.lfm’ dentro da pasta do projeto de plug-
                         in:
1. Preenchendo o conteúdo do arquivo LFM:
1. Instalando o plug-in:
1. Testando a ficha no RRPG:
NodeDatabase

     Um NodeDatabase é um documento de fácil leitura, alteração e compartilhamento de dados usado
     para salvar fichas de personagens, configurações e outras informações.
Se chama assim pois é estruturado como uma árvore, isto é, existe um nó raiz e cada nó pode
possuir outros nós de forma recursiva. Cada nó possui um nome, um nó pai (com exceção do nó
raiz), nós filhos e atributos.
Todas as alterações feitas em um nó de um NodeDatabase são automaticamente salvas no
documento.

Conteúdo:

           ○ Objeto Nodo
           ○ Biblioteca NDB

Sandboxes de Plug-ins

     O SDK3 utiliza sandboxes para a execução de plug-ins. Suas principais características são:
                               ○ Um sandbox é um ambiente virtual que representa um plug-in em
                                    execução. São instanciados/criados quando o Firecast se inicia (e na
                                    instalação de plug-ins) e são destruídos quando o Firecast é fechado (ou na
                                    desinstalação de plug-ins).
                               ○ Cada plug-in roda em sua própria sandbox.
                               ○ Os sandboxes restringem o código dos plug-ins a fim de proteger o
                                    computador/dispositivo do usuário de acessos indevidos.
                               ○ Cada plug-in está associado com seu próprio “HD virtual”.
                                                   ■ Cada sandbox enxerga APENAS o “HD virtual” do plugin
                                                         que está em execução.
                                                   ■ Não é possível acessar arquivos que estão fora do “HD
                                                         virtual”
                                                   ■ Os arquivos do “HD virtual” são persistentes, isto é, ficam
                                                         salvos mesmo quando o sandbox é destruído.
                                                   ■ Um sandbox não consegue acessar o “HD virtual” de outro
                                                         sandbox.
                                                   ■ Um sandbox não consegue acessar o “HD virtual” de outro
                                                         plugin.
                                                   ■ O conteúdo do “HD virtual” é perdido quando o plugin é
                                                         desinstalado.
                                                   ■ Saiba mais lendo o tópico HD Virtual.
                               ○ Os objetos, tabelas e variáveis vivem isolados. Isto é, um sandbox não
                                    enxerga as variáveis e tabelas Lua de outro sandbox.
                               ○ Os objetos, tabelas e variáveis de cada sandbox não são persistentes. Isto
                                    é, estas informações são perdidas quando o sandbox é destruído.
                               ○ Durante o carregamento de uma sandbox, todos os arquivos de extensão
                                    “lua” do plug-in são automaticamente carregados.
                                                   ■ Se existir o arquivo "/init.lua" na raiz do plugin, ele é
                                                         carregado primeiro.
                                                   ■ A ordem de carregamento dos demais arquivos respeita o
                                                         uso da função “require”.
                                                   ■ Observação: A tabela global Lua é compartilhada com
                                                         todos os arquivos Lua do plug-in. Logo, um arquivo Lua
                                                   enxerga as variáveis e tabelas de outro arquivo LUA (se o
                                                   modificador “local” não for usado).
                                              ■ Apenas arquivos “lua” que estão na pasta projeto do plug-in
                                                   são carregados automaticamente.

Por segurança, o sandbox oferece APENAS as seguintes funções nativas LUA:
                         ○ Variáveis:
                                              ■ _G
                                              ■ _VERSION
                         ○ Funções:
                                              ■ next
                                              ■ pairs
                                              ■ ipairs
                                              ■ pcall
                                              ■ select
                                              ■ tonumber
                                              ■ tostring
                                              ■ type
                                              ■ unpack
                                              ■ xpcall
                                              ■ collectgarbage
                                              ■ assert
                                              ■ error
                                              ■ load
                                              ■ rawget
                                              ■ rawset
                                              ■ rawequal
                                              ■ setmetatable
                                              ■ getmetatable
                                              ■ require
                         ○ Biblioteca String
                                              ■ string.byte
                                              ■ string.char
                                              ■ string.find
                                              ■ string.format
                                              ■ string.gmatch
                                              ■ string.gsub
                                              ■ string.len
                                              ■ string.lower
                                              ■ string.match
                                              ■ string.pack
                                              ■ string.packsize
                                              ■ string.rep
                                              ■ string.reverse
                                              ■ string.sub
                                              ■ string.upper
                                              ■ string.unpack
                         ○ Biblioteca Table
                                              ■ table.insert
                                              ■ table.maxn
                                              ■ table.remove
                    ■ table.sort
                    ■ table.concat
                    ■ table.pack
                    ■ table.unpack
○ Biblioteca Math
                    ■ math.abs
                    ■ math.acos
                    ■ math.asin
                    ■ math.atan
                    ■ math.ceil
                    ■ math.cos
                    ■ math.deg
                    ■ math.exp
                    ■ math.floor
                    ■ math.fmod
                    ■ math.huge
                    ■ math.log
                    ■ math.log10
                    ■ math.max
                    ■ math.min
                    ■ math.maxinteger
                    ■ math.mininteger
                    ■ math.modf
                    ■ math.pi
                    ■ math.rad
                    ■ math.random
                    ■ math.randomseed
                    ■ math.sin
                    ■ math.sqrt
                    ■ math.tan
                    ■ math.tointeger
                    ■ math.type
                    ■ math.ult
○ Biblioteca debug
                    ■ debug.getmetatable
                    ■ debug.setmetatable
                    ■ debug.traceback
○ Biblioteca OS
                    ■ os.clock
                    ■ os.difftime
                    ■ os.time
                    ■ os.date
○ Biblioteca Package
                    ■ package.loaded
                    ■ package.config
○ Biblioteca coroutine
                    ■ coroutine.create
                    ■ coroutine.close
                    ■ coroutine.resume
                    ■ coroutine.running
                    ■ coroutine.status
                                                   ■ coroutine.wrap
                                                   ■ coroutine.yield
                               ○ Biblioteca utf8
                                                   ■ utf8.char
                                                   ■ utf8.charpattern
                                                   ■ utf8.codes
                                                   ■ utf8.codepoint
                                                   ■ utf8.len
                                                   ■ utf8.offset

Veja também:

         O SDK3 já provê algumas bibliotecas e funções LUA para você utilizar em seus plug-ins! Saiba
     mais em Bibliotecas LUA.

Interfaces Visuais (Lua Forms)

    As interfaces visuais do SDK3, incluindo os modelos de fichas, são feitas usando Lua Forms
(arquivos de extensões ‘.lfm’).

Principais características do Lua Form

                    ● Sua linguagem segue o padrão XML. Saiba mais sobre em Documentos XML.
                    ● Ao compilar um projeto de plugin (Comando “rdk c”) todos os documentos ‘.lfm’ são

                         validados e compilados em arquivos “.lua”.
                    ● Possui um conjunto próprio de tags e atributos. O plug-in não compila se alguma

                         tag for utilizada incorretamente no arquivo ‘.lfm’. Ver Tags suportadas pelo Lua
                         Form.
                    ● A tag raiz (a mais externa) deve ser “form” ou "popupForm". Ver Tag FORM e Tag
                         popupForm .
                    ● A posição de cada controle é relativa à posição de sua tag pai/seu controle pai.
                         Saiba mais em Posição e Tamanho dos Controles.

Exemplo 1 – Olá mundo

 <?xml version="1.0" encoding="UTF-8"?>
 <form formType="sheetTemplate" dataType="br.com.meusite.MeuDataType"

            title="Ficha de Teste" name="frmFichaTeste">

                <label text="Olá mundo"/>
 </form>

Exemplo 2 – Um layout, um label, um edit e um botão

 <?xml version="1.0" encoding="UTF-8"?>
 <form formType="sheetTemplate" dataType="br.com.meusite.MeuDataType"

                    title="Ficha de Teste" name="frmFichaTeste">
                <layout height="30" width="200">

                              <label text="Força:" align="client" horzTextAlign="trailing"/>
                              <edit align="right" margins="{left=10}" width="100"/>
                </layout>
                <button text="Eu sou um botão" top="40" left="50" width="150"/>
 </form>
Guias

Posição e Tamanho dos Controles

     Toda tag/controle visual possui uma localização expressa com um par de coordenadas left e top, e
     duas dimensões, expressas como width e height (largura e altura), uma geometria que lembra um
     retângulo. A unidade destes atributos é o “ponto lógico” (Veja Ponto Lógico vs Pixel).
     A posição de cada controle é relativa à posição de seus controles/tags pais.
    Exemplo:

 <?xml version="1.0" encoding="UTF-8"?>
 <form name="frmFichaTeste">

                <rectangle left="20" top="30" color="white" width="300" height="300">
                              <rectangle left="20" top="30" color="green" width="200"

 height="200">
                                             <rectangle left="0" top="40" color="red" width="50"/>

                              </rectangle>
                </rectangle>
 </form>

     O exemplo contém 3 retângulos: Um vermelho, um verde e um branco. O form é pai do retângulo
     branco, que é pai do retângulo verde, que por sua vez, é pai do vermelho.

     A posição top final e absoluta do quadrado vermelho é 100, pois é a soma das posições top relativas
     (40 + 30 + 30).

Ponto Lógico vs Pixel

     Todas as dimensões ligadas à interface do Lua Form são medidas em pontos lógicos ao invés de
     pixels.

O que é um ponto lógico?

     Ponto lógico é um "pixel virtual" que você deve usar quando estiver definindo as interfaces visuais
     para expressar tamanho ou posição de forma independente da densidade da tela dos dispositivos.
O que é densidade da tela?

     Representa a quantidade de pixels dentro de uma área física da tela de um dispositivo. A densidade
     é comumente medida em ppi (points per inch - pontos por polegada).
     Telas de alta densidade possuem mais pixels em uma área (uma polegada² ou centímetro², por
     exemplo) do que uma tela de menor densidade em uma mesma área. Quanto maior a densidade de
     pixels, mais definida e "bonita" é a tela.
     Um monitor LED padrão de computador desktop possui por volta de 100ppi, um celular Motorolla
     Moto G possui 326ppi

A quanto equivale um ponto lógico?

     O valor real de um ponto lógico varia de dispositivo para dispositivo, conforme sua densidade de
     pixels.

Densidade de Pixels           Equivalência               Exemplos de dispositivos

Interface de baixa densidade  1 ponto lógico = 0,75      Celulares Androids de baixa
de pixels.                    pixels                     densidade de pixels.

Interface de média densidade 1 ponto lógico = 1 pixel    Computadores padrões,
de pixels.                                               dispositivos iOS sem retina.

Interface de alta densidade   1 ponto lógico = 1,5       Computadores configurados para
de pixels.                    pixels                     textos ampliados, celulares
                                                         Androids de alta resolução (Moto
Interface de altíssima        1 ponto lógico = 2 pixels  G ou Zenfone, por exemplo).
densidade de pixels.
                                                         Google Nexus 7, dispositivos iOS
                                                         com retina.

Interface de super densidade 1 ponto lógico = 3 pixels Google Nexus 5, Galaxy S4.
de pixels.

O que isso tudo significa?

     Que o SDK 3 lida automaticamente com as diferentes densidades de telas automaticamente para
     você.
     Normalmente você pode definir sua interface sem preocupações como se 1 ponto lógico
     equivalesse a 1 pixel.

Arquivo de imagens e pontos lógicos.

     Os arquivos de imagens (.png, jpg, bmp, etc..) possuem dimensões medidas em pixels. Ao usar estas
     imagens em uma interface medida em pontos lógicos, o SDK3 poderá automaticamente fazer
     conversões de tamanho para você.
     Exemplo: O comportamento de uma imagem de 64x64 pixels usada em uma tag image de largura
     64 e altura 64, será diferente para cada densidade de pixels:

Equivalência                  Comportamento
1 ponto lógico = 0,75 pixels  A imagem será reduzida para 48x48 pixels
1 ponto lógico = 1 pixel      antes de ser desenhada.
1 ponto lógico = 1,5 pixels
1 ponto lógico = 2 pixels     A imagem será desenhada como é, sem
1 ponto lógico = 3 pixels     escala.

                              A imagem será ampliada para 96x96 pixels
                              antes de ser desenhada.

                              A imagem será ampliada para 128x128
                              pixels antes de ser desenhada.

                              A imagem será ampliada para 192x192
                              pixels antes de ser desenhada.

Orientações ao usar código LUA em um Lua Form

Você pode usar códigos LUA (veja A linguagem de programação LUA) em seus Lua Forms de 2
maneiras:

     ● Manipulando eventos das tags - Saiba mais como em Tratando eventos do Lua Form.
     ● Usando a Tag script.
Mas para usar de forma adequada é importante você saber as características e comportamento do
código LUA em um Lua Form.

1 - Instâncias

Um Lua Form pode ser instanciado várias vezes (veja Lua Form e Instâncias), isto é, é perfeitamente
possível existir mais de 1 "cópia" de um Lua Form rodando ao mesmo tempo. Seu código deve estar
apto a lidar com esta situação!
A variável "self" representa a instância do Lua Form em que o código está executado.

2 - Acessando as tags/controles via programação.

Cada instância do Lua Form possui sua própria "cópia viva" das tags e, se você quiser acessar uma
tag/controle via programação, você precisará identificar de qual Lua Form é o controle que deseja ter
acesso.
Para identificar um controle do próprio Lua Form, você deve usar "self.".
Em 99% dos casos que precisar acessar as tags via programação, você provavelmente usará "self.".
Exemplo:

 <?xml version="1.0" encoding="UTF-8"?>
 <form name="frmFichaTeste">

                <label name="labMeuLabel" left="20" top="20" text="Meu Texto!" />
              <button text="Clique" left="20" top="50"
                             onClick="self.labMeuLabel.text = 'Cliquei no Botão'"/>

</form>

Importante: Um erro ocorrerá se tentar acessar uma tag/controle sem usar "self." (ou outra forma de
identificar o Lua Form).

3 - Declarando funções

Você pode usar a tag script para declarar funções, mas você deve usar o modificador "local" nestas
funções para que não haja confusão entre as diversas instâncias do Lua Form.

Não usar o modificador "local" nas declarações de funções causa confusão entre as instâncias do form,
já que se trataria de uma função global a todas as instâncias.

Exemplo de declaração:

 <?xml version="1.0" encoding="UTF-8"?>
 <form name="frmFichaTeste">

                <script>
                              local function exibirMensagem()
                                             local texto = "";

                    for i = 1, 5, 1 do
                                  texto = texto .. "Linha " .. i .. "\n";

                    end;

                    showMessage(texto);

              end;
</script>

              <button name="btnMeuBotao" text="Meu Botão" onClick="exibirMensagem()"/>
</form>

Você também pode declarar funções ligadas à instância para evitar os mesmos problemas:
 <?xml version="1.0" encoding="UTF-8"?>
 <form name="frmFichaTeste">

                <script>
                              function self.exibirMensagem()
                                             showMessage('Olá Mundo');
                              end;

                </script>
                <button onClick="self.exibirMensagem();"/>
 </form>

4 - Acessando o Nodo do NodeDatabase associado à instância do LuaForm

Cada instância de LuaForm pode estar associada a um objeto nodo de um NodeDatabase (ver
NodeDatabase e Lua Form e NodeDatabase).
A variável "sheet" contém este objeto nodo associado e você pode usá-lo via programação.
Exemplo de uso:

 <?xml version="1.0" encoding="UTF-8"?>
 <form name="frmFichaTeste">

                <button onClick="sheet.campoDeForca = 8;"/>
 </form>

Tratando eventos do Lua Form

Um evento é um acontecimento específico de alguma tag. É possível definir códigos LUA (veja A
linguagem de programação LUA) que serão executados toda vez que determinado evento ocorrer em
uma tag!
A maioria das tags/controles do Lua Form disparam eventos, mas cada uma possui seu próprio
conjunto de eventos. Você deve consultar a documentação!

Manipulando eventos

Existem duas maneiras de manipular eventos do Lua Form:
     ● Associando uma única linha de código ao evento;
     ● Usando a tag event para associar várias linhas de códigos ao evento.

Importante: Não deixe de ler as Orientações ao usar código LUA em um Lua Form
Modo 1 - Associando uma única linha de código ao evento.

Esta é a forma mais simples de manipular eventos, porém não é possível associar um código de mais de
1 linha aos eventos por este modo.
Dado um evento de nome NOME_EVENTO de uma tag de nome NOME_TAG, você pode associar um
código Lua assim:

 <NOME_TAG NOME_EVENTO="<CODIGO_LUA_DE_UMA_LINHA>"/>

Modo 1, Exemplo 1 - OnClick de button

A tag button possui o evento "onClick".

 <?xml version="1.0" encoding="UTF-8"?>
 <form name="frmFichaTeste"">

                <button text="Meu Botão" onClick="showMessage('Cliquei no botão');"/>
 </form>

Modo 1, Exemplo 2 - OnMouseEnter e OnMouseLeave de button

 <?xml version="1.0" encoding="UTF-8"?>
 <form name="frmFichaTeste">

                <button name="btnMeuBotao" text="Meu Botão" left="20" top="20" width="200"
                                             onMouseEnter="self.btnMeuBotao.text = 'Mouse dentro do botão'"
                                             onMouseLeave="self.btnMeuBotao.text = 'Meu Botão'"/>

 </form>
                     ---->
                    ---->

Modo 1, Exemplo 3 - Definindo função e a chamando no evento OnClick de button

 <?xml version="1.0" encoding="UTF-8"?>
 <form name="frmFichaTeste">

                <script>
                              local function exibirMensagem()
                                             local texto = "";

                    for i = 1, 5, 1 do
                                  texto = texto .. "Linha " .. i .. "\n";

                    end;

                    showMessage(texto);

              end;
</script>

              <button name="btnMeuBotao" text="Meu Botão" onClick="exibirMensagem()"/>
</form>
Foi usada a Tag script neste exemplo.

Modo 2 - Usando a tag event para manipular eventos.

     Saiba como usar a tag event e exemplos em: Tag event.

String de cores no Lua Form

As cores usadas nas tags do Lua Form são definidas por um string, e podem ter 2 formatos:
     ● Formato hexadecimal
     ● Formato literal

Formato hexadecimal

     As cores no formato hexadecimal são uma mistura de RED, GREEN, BLUE e opcionalmente ALPHA
     no seguintes formatos:

Formato hexadecimal 1 — dois caracteres por canal de cor
     #RRGGBB ou 0xRRGGBB

     onde:
     ● RR - código hexadecimal em 2 caracteres (valor entre 00 e FF) da porção vermelha
     ● GG - código hexadecimal em 2 caracteres (valor entre 00 e FF) da porção verde
     ● BB - código hexadecimal em 2 caracteres (valor entre 00 e FF) da porção azul

Formato hexadecimal 2 — dois caracteres por canal de cor + opacidade
Também possível especificar a opacidade da cor (ALPHA), seguindo o padrão:

     #RRGGBBAA ou 0xRRGGBBAA
     onde:
     ● RR - código hexadecimal em 2 caracteres (valor entre 00 e FF) da porção vermelha
     ● GG - código hexadecimal em 2 caracteres (valor entre 00 e FF) da porção verde
     ● BB - código hexadecimal em 2 caracteres (valor entre 00 e FF) da porção azul
● AA - código hexadecimal em 2 caracteres (valor entre 00 e FF) do valor alpha/opacidade, onde
     00 = 100% transparente e FF = 100% opaco.

Formato hexadecimal 3 — um caracter por canal de cor (também conhecido como shorthand hex color)
     #RGB ou 0xRGB

onde:
     ● R - código hexadecimal em 1 caracter (valor entre 0 e F) da porção vermelha
     ● G - código hexadecimal em 1 caracter (valor entre 0 e F) da porção verde
     ● B - código hexadecimal em 1 caracter (valor entre 0 e F) da porção azul

Formato hexadecimal 4 — um caracter por canal de cor + Opacidade (também conhecido como
shorthand hex color)

     #RGBA ou 0xRGBA
onde:

     ● R - código hexadecimal em 1 caracter (valor entre 0 e F) da porção vermelha

     ● G - código hexadecimal em 1 caracter (valor entre 0 e F) da porção verde

     ● B - código hexadecimal em 1 caracter (valor entre 0 e F) da porção azul

     ● A - código hexadecimal em 1 caracter (valor entre 0 e F) do valor alpha/opacidade, onde 0 =
          100% transparente e F = 100% opaco.

Exemplos:

     ● #FF0000 - cor vermelha (Formato 1 — dois caracteres por canal de cor)
     ● #F00 - cor vemelha (Formato 3 — um caracter por canal de cor)
     ● #00FF00 - cor verde (Formato 1 — dois caracteres por canal de cor)
     ● #0F0 - cor verde (Formato 3 — um caracter por canal de cor)
     ● #0000FF - cor azul (Formato 1 — dois caracteres por canal de cor)
     ● #00F - cor azul (Formato 3 — um caracter por canal de cor)
     ● #FF00007F - cor vermelha 50% transparente (Formato 2 — dois caracteres por canal de cor +

          opacidade)
     ● #F007 - cor vermelha 47% transparente (Formato 4 — um caracter por canal de cor +

          opacidade)

Formato literal

O SDK3 também provê algumas constantes que identificam facilmente algumas cores! São elas:

Constante     Hexadecimal equivalente  Cor

AliceBlue     #F0F8FF
AntiqueWhite  #FAEBD7
Aqua          #00FFFF
Aquamarine      #7FFFD4
Azure           #F0FFFF
Beige           #F5F5DC
Bisque          #FFE4C4
Black           #000000
BlanchedAlmond  #FFEBCD
Blue            #0000FF
BlueViolet      #8A2BE2
Brown           #A52A2A
BurlyWood       #DEB887
CadetBlue       #5F9EA0
Chartreuse      #7FFF00
Chocolate       #D2691E
Coral           #FF7F50
CornflowerBlue  #6495ED
Cornsilk        #FFF8DC
Crimson         #DC143C
Cyan            #00FFFF
DarkBlue        #00008B
DarkCyan        #008B8B
DarkGoldenRod   #B8860B
DarkGray        #A9A9A9
DarkGreen       #006400
DarkKhaki       #BDB76B
DarkMagenta     #8B008B
DarkOliveGreen  #556B2F
DarkOrange      #FF8C00
DarkOrchid      #9932CC
DarkRed         #8B0000
DarkSalmon      #E9967A
DarkSeaGreen    #8FBC8F
DarkSlateBlue   #483D8B
DarkSlateGray   #2F4F4F
DarkTurquoise   #00CED1
DarkViolet      #9400D3
DeepPink        #FF1493
DeepSkyBlue     #00BFFF
DimGray         #696969
DodgerBlue      #1E90FF
FireBrick       #B22222
FloralWhite     #FFFAF0
ForestGreen     #228B22
Fuchsia         #FF00FF
Gainsboro       #DCDCDC
GhostWhite      #F8F8FF
Gold            #FFD700
GoldenRod       #DAA520
Gray            #808080
Green           #008000
GreenYellow     #ADFF2F
HoneyDew        #F0FFF0
HotPink               #FF69B4
IndianRed             #CD5C5C
Indigo                #4B0082
Ivory                 #FFFFF0
Khaki                 #F0E68C
Lavender              #E6E6FA
LavenderBlush         #FFF0F5
LawnGreen             #7CFC00
LemonChiffon          #FFFACD
LightBlue             #ADD8E6
LightCoral            #F08080
LightCyan             #E0FFFF
LightGoldenRodYellow  #FAFAD2
LightGray             #D3D3D3
LightGreen            #90EE90
LightPink             #FFB6C1
LightSalmon           #FFA07A
LightSeaGreen         #20B2AA
LightSkyBlue          #87CEFA
LightSlateGray        #778899
LightSteelBlue        #B0C4DE
LightYellow           #FFFFE0
Lime                  #00FF00
LimeGreen             #32CD32
Linen                 #FAF0E6
Magenta               #FF00FF
Maroon             #800000
MediumAquaMarine   #66CDAA
MediumBlue         #0000CD
MediumOrchid       #BA55D3
MediumPurple       #9370DB
MediumSeaGreen     #3CB371
MediumSlateBlue    #7B68EE
MediumSpringGreen  #00FA9A
MediumTurquoise    #48D1CC
MediumVioletRed    #C71585
MidnightBlue       #191970
MintCream          #F5FFFA
MistyRose          #FFE4E1
Moccasin           #FFE4B5
NavajoWhite        #FFDEAD
Navy               #000080
OldLace            #FDF5E6
Olive              #808000
OliveDrab          #6B8E23
Orange             #FFA500
OrangeRed          #FF4500
Orchid             #DA70D6
PaleGoldenRod      #EEE8AA
PaleGreen          #98FB98
PaleTurquoise      #AFEEEE
PaleVioletRed      #DB7093
PapayaWhip     #FFEFD5
PeachPuff      #FFDAB9
Peru           #CD853F
Pink           #FFC0CB
Plum           #DDA0DD
PowderBlue     #B0E0E6
Purple         #800080
RebeccaPurple  #663399
Red            #FF0000
RosyBrown      #BC8F8F
RoyalBlue      #4169E1
SaddleBrown    #8B4513
Salmon         #FA8072
SandyBrown     #F4A460
SeaGreen       #2E8B57
SeaShell       #FFF5EE
Sienna         #A0522D
Silver         #C0C0C0
SkyBlue        #87CEEB
SlateBlue      #6A5ACD
SlateGray      #708090
Snow           #FFFAFA
SpringGreen    #00FF7F
SteelBlue      #4682B4
Tan            #D2B48C
Teal           #008080
Thistle      #D8BFD8
Tomato       #FF6347
Turquoise    #40E0D0
Violet       #EE82EE
Wheat        #F5DEB3
White        #FFFFFF
WhiteSmoke   #F5F5F5
Yellow       #FFFF00
YellowGreen  #9ACD32
None         #00000000
Transparent  #00000000
Null         #00000000

Lua Form e NodeDatabase

     O Lua Form foi desenvolvido de forma a se conectar facilmente ao NodeDatabase para criar
     interfaces que salvam dados.
     Para integrar um lua form ao Node Database é preciso duas coisas:

                               ○ Preencher o atributo "field" das tags que suportam NodeDatabase
                               ○ Definir um escopo de dados do Lua Form, isto é, informar em qual nodo de

                                    qual NodeDatabase o LuaForm salvará os dados.
                                                   ■ Observação importante: O SDK3 faz isto automaticamente
                                                         para você se for um modelo de ficha, se estiver usando a tag
                                                         recordList ou se for uma janela acoplável.

Tags que suportam NodeDatabase

     As tags/controles que se conectam ao NodeDatabase são:
                               ○ label
                               ○ edit
                               ○ checkBox
                               ○ comboBox
                               ○ colorComboBox
                               ○ image
                               ○ imageCheckBox
                               ○ textEditor
                               ○ recordList
                               ○ dataLink
                               ○ dataScopeBox
                               ○ progressBar

Escopo de dados

     Toda tag/controle que suporta NodeDatabase precisa de um escopo de dados, isto é, um objeto
     nodo de um nodedatabase onde os dados serão salvos.
     As tags form, popup e dataScopeBox possuem o método "controle:setNodeObject" que permitem
     definir o escopo de dados e, após definido um objeto nodo como escopo, todas as tags que estão
     dentro passarão a salvar/carregar dados neste obeto nodo.
     Exemplo:

               Suponha a seguinte interface:

                  <form
                  name="minhaTagForm">

                                <edit
                  field="campoNome"/>
                  </form>

              Se o seguinte trecho de código Lua executar:

                  minhaTagForm:setNodeObjec
                  t(NODO_A)

              o edit passará a ler e salvar dados em NODO_A.campoNome...

              Agora, se o seguinte trecho de código Lua executar:

                  minhaTagForm:setNodeObject(OUTRO_NODO
                  )

              o edit agora passará a ler e salvar dados em OUTRO_NODO.campoNome...

              E, por fim, se o seguinte trecho de código Lua executar:

                  minhaTagForm:setNodeObject(nil)

              o edit agora ficará desabilitado, pois utilizamos o atributo "field" mas não há nodo escopo de
              dados associado.
     Importante: O SDK3 define o escopo de dados automaticamente para os modelos de fichas, ao usar
     a tag recordList e para as janelas acopláveis:

                               ○ Quando o usuário abre uma ficha no RRPG, o SDK3 carrega o
                                    NodeDatabase do personagem e define seu objeto nodo raiz como escopo
                                    de dados do form.

                               ○ No caso da tag recordList, o SDK3 automaticamente define o escopo de
                                    dados de cada painel de item.

                               ○ Quando o usuário ativa um janela acoplável, o SDK 3 carrega o
                                    NodeDatabase do form (se ele tiver a propriedade dataType preenchida) e
                                    define o objeto nodo raiz como escopo de dados do form.
Preenchendo o atributo "field"

     Nas tags que suportam NodeDatabase, o atributo "field" contém o nome do campo de um objeto
     nodo a qual o controle deve se conectar.

Exemplo:

 <?xml version="1.0" encoding="UTF-8"?>

 <form name="frmFichaTeste">

                <edit field="nomeESobrenome"/>

                <edit field="caracteristicas"/>

                <label field="forca"/>

                <label field="destreza"/>

 </form>

     No exemplo acima, quando a interface estiver rodando, o primeiro edit irá se ligará ao campo
     "nomeESobrenome" do objeto nodo, isto é:

                               ○ Exibirá na interface o conteúdo do campo "nomeESobrenome" do objeto
                                    nodo escopo.

                               ○ Quando alguém alterar o valor do campo "nomeESobrenome" do objeto
                                    nodo escopo, o edit captará a mudança e automaticamente mostrará o
                                    novo valor na interface.
                                                   ■ Desde que estejam acessando o mesmo nodedatabase, este
                                                         comportamento acontece mesmo se a pessoa que alterar o
                                                         valor estiver em outro computador.

                               ○ Se o usuário alterar o texto do edit, o novo valor será salvo no campo
                                    "nomeESobrenome" do objeto nodo escopo.

     Idem para as demais tags que tem o atributo "field" definido.

Acessando/salvando dados que estão em um nodo filho.
     É possível utilizar o caractere "." para informar que o campo na verdade está em um nodo filho do
     nodo escopo.
     Exemplo:

 <?xml version="1.0" encoding="UTF-8"?>

 <form name="frmFichaTeste">

                <edit field="atributos.modificadores.forca"/>

                <edit field="nodoFilho.nodoNeto.campo1"/>

                <edit field="nodoFilho.campo2"/>

 </form>

     No exemplo acima, o primeiro edit se ligará ao campo "forca" do nodo de nome "modificadores"
     que está dentro do nodo de nome "atributos" que, por sua vez, está dentro do nodo escopo.
     Se o usuário alterar o conteúdo do edit e o não existir um nodo de nome "atributos" no nodo
     escopo, o SDK3 automaticamente criará este nodo antes de salvar os dados. Idem para o nodo
     "modificadores" dentro do nodo "atributos".
Variável sheet

     Os códigos que estão dentro de um Lua Form tem acesso à uma variável chamada "sheet" que
     representa o objeto nodo escopo do form.
     Exemplo:

 <?xml version="1.0" encoding="UTF-8"?>
 <form name="frmFichaTeste">

         <edit field="campoDeForca"/>

         <button onClick="sheet.campoDeForca = 8;"/>

 </form>

     No exemplo acima, ao clicar no botão, a propriedade "campoDeForca" será alterado para "8" e a
     mudança será refletida no edit já que está ligado ao mesmo campo que sofreu alteração.
     Veja também:

                               ○ Tratando eventos do Lua Form
                               ○ Orientações ao usar código LUA em um Lua Form

Exemplos

Exemplo 1 - Pequeno cadastro que informa se a pessoa é maior de idade

 <?xml version="1.0" encoding="UTF-8"?>
 <form name="frmFichaTeste">

                <layout left="20" top="20" height="500" width="250">
                              <layout align="top" height="32">
                                             <label align="left" text="Nome: " width="50"

 horzTextAlign="trailing"/>
                                             <edit align="client" field="nome" margins="{left=5}"/>

                              </layout>

                              <layout align="top" height="32">
                                             <label align="left" text="Idade: " width="50"

 horzTextAlign="trailing"/>
                                             <edit align="client" field="idade" margins="{left=5}"/>

                              </layout>

                              <label name="labMaiorDeIdade" text="Preencha a idade"
 align="top" horzTextAlign="center"/>

                </layout>

                <dataLink field="idade">
                              <event name="onChange">
                                             local idade = tonumber(sheet.idade);
                                             if idade ~= nil then
                                                            if idade >= 18 then
                                                                          self.labMaiorDeIdade.text = "Maior de

 idade";
                                                            else
                                                                          self.labMaiorDeIdade.text = "Menor de

 idade";
                                                            end;

                                             else
                                                            self.labMaiorDeIdade.text = "Preencha a idade";

                                             end;
                              </event>
                </dataLink>
 </form>

Neste exemplo foram usados:
     ● Tag layout
     ● Tag edit
     ● Tag label
     ● Tag dataLink
     ● Tag event

Veja também:
     ● Orientações ao usar código LUA em um Lua Form

Lua Form e Instâncias

O documento Lua Form (arquivo '.lfm') contém apenas o molde/a receita de como a interface deve ser e
se comportar.
Uma instância é uma interface concreta que foi criada a partir do molde, sendo assim, podem existir
uma ou mais instâncias do mesmo LFM ao mesmo tempo. A instância é destruída quando o usuário não
precisar mais da interface (por exemplo, ao fechar a janela do personagem), mas o molde nunca é
destruído.

Estilos em Cascata

É possível aplicar estilos em cascata semelhante ao CSS do HTML no LuaForm.
Saiba mais em Tag style

Dividindo o arquivo Lua Form em documentos menores

Se seu arquivo .lfm cresceu e está muito grande, saiba que é possível organizá-lo em documentos XML
menores!
Saiba mais lendo Tag import.

The Grid System

The Grid System is a tool designed to organize the tags/controls of your character sheet (and other Lua
forms) in a way that adapts to different screen sizes. It is inspired by the grid system in the Bootstrap
library, offering a flexible and powerful layout solution.
Links:

     ● Key concepts of the grid system: https://sdk3.firecast.app/grid/concepts/

Grid system key concepts

The Grid System is a tool designed to organize the tags/controls of your character sheet (and other Lua
forms) in a way that adapts to different screen sizes. It is inspired by the grid system in the Bootstrap
library, offering a flexible and powerful layout solution.

Key concept: The 12-column division
Forms, layouts, and all other controls are structured around a 12-column grid system, which works as
follows:
          ● 12 virtual columns: The content area of controls is divided into 12 equal virtual columns.
               These columns are used for alignment and sizing.

          ● Automatic row breaks: When the 12 virtual columns of a row are filled, the next control
               automatically starts on a new row.

Here's how it looks:
And here's how the grid system divides its content into 12 virtual columns:

Key concept: Roles in the grid system
Controls can assume one of 5 roles in the grid system:

          ● none: A control that does not align using the grid system. This is the default.
          ● row: A control that takes up an entire line in the 12-column division.
          ● col: A control whose width is defined by how many of the 12 columns it occupies.
          ● block: A control whose width is defined in pixels instead of 12-column spaces.
          ● container: A control that contains the entire interface layout while keeping the content

               width within a readable and manageable range.
Note
  All controls can be aligned using the grid system by assigning them a role with the g or g-role
  attributes.
  "row" role
  Controls with the row role take up an entire line in the layout.
  Example:

   <layout name="r1" g="row" g-min-height="60"/>'
   <layout name="r2" g="row" g-min-height="60"/>
   <layout name="r3" g="row" g-min-height="60"/>

  "col" role
  Controls with the col role have their width defined by how many of the 12 columns they occupy. This is
  set with the g-width attribute.
  Example:
   <!-- 1st line -->
   <layout name="c1" g="col" g-width="3"/>
   <layout name="c2" g="col" g-width="3"/>
   <layout name="c3" g="col" g-width="3"/>
   <!-- 2nd line -->
   <layout name="c4" g="col" g-width="1"/>
   <layout name="c5" g="col" g-width="3"/>
   <layout name="c6" g="col" g-width="8"/>
   <!-- 3rd line -->
   <layout name="c7" g="col" g-width="8"/>
   <!-- 4th line -->
   <layout name="c8" g="col" g-width="6"/>
   <layout name="c9" g="col" g-width="6"/>

Note
  The horizontal spaces between the aligned controls are called gutter. The default gutter value is 30 and
  can be customized by using the g-gutter and/or g-cnt-gutter attributes

Note

  In the 3rd line, a single col with g-width=8 is used. Although there's a free space of 4 columns in that
  line, the next control does not fit into it as it occupies 6 columns. This behavior ensures that controls
  are aligned properly and do not overlap.

  "block" role
  Controls with the block role are placed in lines like col controls, but they don't use the 12-column
  spaces. Instead, they define their width in pixels, allowing precise control over their size in the layout.
  Example:

   <layout name="b1" g="block" width="100"/>
   <layout name="b2" g="block" width="80"/>
   <layout name="b3" g="block" width="450"/>
   <layout name="b4" g="block" width="300"/>

  Blocks and the 12-column spaces
  Controls with the block role don't use the available 12-column spaces. Instead, they shrink the size of
  the 12-column spaces available in the layout.
  Example:

   <layout name="b1" g="block" width="100"/>
   <layout name="b2" g="block" width="80"/>
<layout name="b3" g="block" width="60"/>

If we add two col controls to the above layout:

<layout name="c1" g="col" g-width="8"/>
<layout name="c2" g="col" g-width="4"/>

"container" role
Controls with the container role act as a wrapper for all other controls in the interface. They ensure
that the content width remains within a readable and manageable range by limiting the width of the
entire layout.
Example:

<?xml version="1.0" encoding="UTF-8"?>
<form name="frmMyForm" >

       <rectangle g="row">
              <label text="Name: " g="col" g-width="1"/>
              <edit g="col" g-width="2"/>
              <label text="Age: " g="col" g-width="1"/>
              <edit g="col" g-width="2" height="30"/>
              <label text="Race: " g="col" g-width="1"/>
              <edit g="col" g-width="2"/>
              <label text="Field 4: " g="col" g-width="1"/>
              <edit g="col" g-width="2"/>
       </rectangle>

       <style>
              form { g-padding-top: 8; g-cnt-line-spacing: 4; theme: dark}
              rectangle { color: gray; g-padding-top: 16; g-padding-bottom: 16; }
              label { horzTextAlign: trailing; }
              edit, label { height: 30; }

       </style>
</form>

The code above produces the following layout on an extra-large screen (width=1920):

The labels have g-width set to 1 and yet are too large. On larger screens, the issue would get even
worse. By setting the rectangle role to container, we will then have the following layout on the same
screen:
Note

  The maximum width for a container is 1378px.
Note

Using a container control is optional. It helps maintain a consistent layout and is particularly useful
when you want to prevent content from becoming too wide.

Key concept: Screen size breakdown
Forms are given a screen size class based on their width in pixels, which helps define different layouts
for different screen sizes.

      Screen Size Class  Description            Form Width (px)

      xs                 Extra Small            < 576

      sm                 Small                  >= 576

      md                 Medium                 >= 768
lg  Large                               >= 992

xl  Extra Large                         >= 1200

To specify different values for different screen sizes, append "-xs", "-sm", "-md", "-lg", or "-xl" to
the grid attribute names. The grid system then selects the most appropriate suffix based on the screen
size.

Example:

<layout g="col" g-width="12" g-width-md="6"/>
<layout g="col" g-width="12" g-width-md="6"/>

In this example, on screen sizes xs and sm, the width of the col elements will be 12, taking up the full
width of the row. But on screen sizes md and larger, the width will be 6, allowing two col elements to be
displayed side by side.

Running on xs and sm screen sizes:

Running on md and larger screen sizes:
       ● Tags attributes for the grid system: https://sdk3.firecast.app/grid/attributes/

  Grid attributes

Note

  All tags/controls have all attributes described here in addition to their own attributes.

  Base attributes
            ● g or g-role: The role of the control in a grid system aligned layout.
            ● g-auto-height: Specifies whether the control's height should adjust automatically to fit its
                  grid-aligned children controls vertically.

  Attributes for controls with col role
            ● g-width: How many 12-columns count the the control occupies.
            ● g-offset: Layout offset
            ● g-push: Push offset
            ● g-pull: Pull offset

  Attributes for controls with container role
            ● g-horz-align: Specifies horizontal alignment for the container.

  Margins and padding
  Margins are defined individually by side, in pixel count:

            ● g-margin-left
            ● g-margin-top
            ● g-margin-right
            ● g-margin-bottom

  Padding is also defined individually by side, in pixel count:
            ● g-padding-left
            ● g-padding-top
            ● g-padding-right
            ● g-padding-bottom

Note

  When a g-margin-*/g-padding-* value is not defined, the grid system will use the corresponding
  value defined in the control's margins/padding attribute.

  Gutters
  There are two ways to define gutter for controls, measured in pixels:

            ● g-cnt-gutter: Sets the gutter size for all content controls, i.e., for all controls that are
                  inside.

            ● g-gutter: Sets the gutter size for the control only.

  Learn more about the gutter here;

  Vertical line spacing
            ● g-cnt-line-spacing: Define an amount of pixels to insert between lines inside the control.

  Alignment attributes
  For children alignment:

            ● g-cnt-vert-align: Specifies vertical alignment for the children of the control.
            ● g-cnt-horz-align: Specifies horizontal alignment for the children of the control.

  For alignment of the control itself:

            ● g-vert-align: Specifies vertical alignment for the control itself.

  Displacement attributes
  Use the following attributes to displace the control by a specified amount of pixels:

            ● g-final-offset-x
            ● g-final-offset-y

Note

  The g-final-offset-* attributes affect the control only and do not affect the positioning of following
  controls.

  Breakline attributes
            ● g-break-line-before: Set to true to force a line break before the control.
            ● g-break-line-after: Set to true to force a line break after the control.

  Sorting attributes
            ● g-order: An integer that defines the index of the control for ascending order (lower
                  numbers appear first in the interface than greater numbers). Default: 0.
            ● g-group: An integer that defines which group the control belongs to. The groups are sorted
                  in ascending order. Default: 0.

  Controls are sorted first by their group (ascending g-group number), and then controls within each
  group are sorted by their g-index value.

  Visibility attributes
            ● g-invisible-reserved: Set to true to force the grid system to reserve space and consider
                  this control in the layout even if it is invisible (its visible attribute is false).

  Dynamic size attributes based on text content
            ● g-dyn-width-txt: Specifies whether the Grid System should dynamically calculate the
                  width for the control based on its text content.
            ● g-dyn-height-txt: Specifies whether the Grid System should dynamically calculate the
                  height for the control based on its text content.
Tiling attributes
          ● g-vert-tile: Specifies whether the Grid System should calculate the control's height to fill
               the available vertical area.
          ● g-vert-tile-weight: A real number that determines the weight this control has when
               filling the available vertical area. It is used when multiple lines want to fill a content height.
               Lines with a higher average g-vert-tile-weight will "grow more" than lines with a lower
               average g-vert-tile-weight. Default: 1.0
          ● g-horz-tile: Specifies whether the Grid System should calculate the control's width to fill
               the available horizontal area. This attribute functions similarly to g-vert-tile but applies
               to horizontal spaces.

Size constraint attributes
For width:

          ● g-min-width: Specifies the minimum width the control should have, measured in pixels.
               The grid system will ensure that the control width is not less than this value.

          ● g-max-width: Specifies the maximum width the control should have, measured in pixels.
               The grid system will ensure that the control width is not more than this value.

For height:

          ● g-min-height: Specifies the minimum height the control should have, measured in pixels.
               The grid system will ensure that the control height is not less than this value.

          ● g-max-height: Specifies the maximum height the control should have, measured in pixels.
               The grid system will ensure that the control height is not more than this value.

Attributes used when mixing col and block roles
          ● g-cnt-min-grid-width: Specifies the minimum width, measured in pixels, that the entire
               12 columns of the content should have.
          ● g-cnt-min-grid-width-ft: Specifies the minimum width, measured as a factor of the
               control width, that the entire 12 columns of the content should have.

Special built-in attributes
        ● g-dyn-width-single-line: If set to true, the grid system will calculate the width for the
             control so it can fit horizontally all of its children block controls into a single line, without
             the need for breaklines. It replaces the g-on-get-width event.

        ● g-dyn-width-each-line: If set to true, the grid system will calculate the width for the
             control so it can fit horizontally each of its children block controls into separate lines. It
             replaces the g-on-get-width event.

        ● g-dyn-width-match-height: If set to true, the grid system will calculate the width for the
             control so it matches the control height. It replaces the g-on-aligned event.
```
