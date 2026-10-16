# Tag image

> Extraído de `docs/Firecast_SDK_-_Single formatado.pdf` (texto automático; tabelas podem ter colunas desalinhadas). 

```text
Tag image

      A tag/componente image representa uma imagem na interface visual.

Herança

       O image possui todas as características de um controle qualquer. Veja Características de todas
       as tags visuais.

Características

       Além das características herdadas, o image também possui as seguintes características:
Propriedades e Atributos
Propriedade  Tipo                    Valor      Descrição
animate      Boolean                 Padrão
url, src ou                          false      Define se deve executar a
imageURL     String                             animação de imagens que são
                                     <string    animadas (exemplo: GIF, GIFV)
style ou                             vazio>     quando suportadas.
showStyle
             Enumerado:              “proporti  Define a URL/caminho de onde
                                     onal”      se encontra a imagem!
                            ●“
                                 p              Este valor:
                                 r
                                 o                              ● Pode ser um
                                 p                                   endereço de
                                 o                                   internet
                                 rt                                  (exemplo:
                                 i                                   “http://xxxx.co
                                 o                                   m.br/a.png”)
                                 n
                                 al                             ● Pode ser o
                                 ”                                   caminho de
                                                                     um arquivo
                            ●“                                       contido no
                                 a                                   pacote do
                                 u                                   plugin.
                                 t
                                                                ● Pode ser um
                                                                     arquivo que se
                                                                     encontra no
                                                                     HD Virtual do
                                                                     plugin
                                                                     instalado.

                                                Define como a imagem será
                                                apresentada na interface:

                                                “proportional”:

                                                A imagem será
                                                redimensionada,
                                                proporcionalmente, para o
                                                tamanho do controle, não
                                                necessariamente ocupando
                                                todo o espaço disponível.

                                                “autoFit”:

                                                A imagem será exibida de
                                                forma que SEMPRE ocupe
                                                TODO o espaço do controle da
                                                forma mais adequada, isto é,
                                                aumentando/diminuindo a
                              o          imagem, centralizando-a e
                              F          cortando excessos.
                              it
                              ”          “originalSize”:
                         ●“
                              o          A imagem será apresentada no
                              ri         tamanho original, sem
                              gi         redimensionamento.
                              n
                              al         “stretch”:
                              Si
                              z          A imagem será redimensionada
                              e          de forma que ocupe todo o
                              ”          espaço disponível no controle,
                         ● “s            podendo achatar ou alongar a
                              tr         imagem.
                              e
                              t          Quando true, a imagem será
                              c          exibida de forma centralizada
                              h          no controle.
                              ”
                                         Esta propriedade é válida
center          Boolean           true   apenas quando a propriedade
                                         “showStyle” for “proportional”
optimizeQualit  Boolean           false  ou “originalSize”
y ou
                                         Quando true, o SDK salvará
optimize                                 uma cópia da imagem já
                                         redimensionada de acordo com
showProgress    Boolean           true   a propriedade “style”.

                                         Utilize este atributo apenas em
                                         controles image que não
                                         sofrem constante mudança de
                                         tamanho.

                                         Quando true, o controle exibe
                                         uma barra de carregamento
                                         para informar que a imagem
                                         está sendo baixada.

                                         Quando false, a imagem
                                         definida pela propriedade
                                         “URLWhileLoading” é exibida
                                         enquanto o download é feito.
URLWhileLoa    String   <string  Define a URL/caminho da
ding                    vazio>   imagem que é exibida APENAS
                                 enquanto a imagem principal
field          String   <string  (definida na propriedade “url”)
                        vazio>   é carregada.
editable       Boolean
                        false    Este valor:
naturalAnimat  Boolean  false
                                                 ● Pode ser um
                                                      endereço de
                                                      internet
                                                      (exemplo:
                                                      “http://xxxx.co
                                                      m.br/a.png”)

                                                 ● Pode ser o
                                                      caminho de
                                                      um arquivo
                                                      contido no
                                                      projeto do
                                                      plugin

                                                 ● Pode ser um
                                                      arquivo que se
                                                      encontra no
                                                      HD Virtual do
                                                      plugin
                                                      instalado.

                                 Caminho de um campo no
                                 NodeDatabase.

                                 Quando associado, a imagem
                                 passa a apresentar a imagem
                                 de URL contida no campo do
                                 NodeDatabase informado.

                                 Veja também:

                                           ● Lua Form e
                                                NodeDatabase

                                           ● NodeDatabase

                                 Quando True, a tag permite o
                                 usuário alterar a URL da
                                 imagem.

                                 Se o atributo "field" estiver
                                 preenchido, a URL escolhida
                                 pelo usuário é salva no campo
                                 do NodeDatabase.

                                 (Somente Leitura) Quando a
ed                                       imagem tiver sido carregada,
                                         contém a informação se ela
                                         suporta animação.

naturalWidth       Double             0  (Somente Leitura) Quando a

                                         imagem tiver sido carregada,

                                         contém a largura original da

                                         imagem em pixels.

naturalHeight      Double             0  (Somente Leitura) Quando a

                                         imagem tiver sido carregada,

                                         contém a altura original da

                                         imagem em pixels.

Eventos                    Descrição
   Nome do evento

onLoad                     Este evento é invocado quando a imagem tiver sido
                           carregada.

onPictureLoadedChan        Este evento é invocado quando a imagem que será exibida
ge                         mudou.

                           Este evento é chamado quando a imagem é carregada
                           100% ou quando uma imagem é descarregada.

Veja Tratando eventos do Lua Form

Exemplos

Exemplo 1 - Imagem dentro do projeto de plug-in

       Neste exemplo, existe uma pasta chamada "imagens" dentro da pasta projeto do plug-in, e
       dentro desta pasta existe a imagem "fenix.png".

<?xml version="1.0" encoding="UTF-8"?>
<form name="frmFichaTeste">

              <image left="20" top="20" width="200" height="200"
src="/imagens/fenix.png"/>

</form>
Exemplo 2 - Imagem baixada por URL e diversos styles

    <?xml version="1.0" encoding="UTF-8"?>
    <form name="frmFichaTeste">

                   <image left="20" top="20" width="400" height="200" style="autoFit"

    src="http://fc03.deviantart.net/fs70/i/2011/234/5/4/dragon_aspects_by_rattlesnak
    edefender-d47ii5y.jpg"/>
    </form>

style="proportional"                                                                   style="aut
                          style="originalSize"                                                 style="str
```
