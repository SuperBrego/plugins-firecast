# Tag popupForm

> Extraído de `docs/Firecast_SDK_-_Single formatado.pdf` (texto automático; tabelas podem ter colunas desalinhadas). 

```text
Tag popupForm

       A tag/componente popupForm é uma especialização da tag form que contém propriedades
       próprias para exibir uma janela popup na interface do usuário .

       Você pode usar esta tag como tag raiz de um arquivo LFM.

Herança

       O popupForm possui todas as características da Tag form.
       Veja:

                                 ○ Tag form
                                 ○ Características de todas as tags visuais.

Características

       Além das características herdadas, o popupForm possui também as seguintes características:

Propriedades e atributos da tag popupForm

Propriedade  Tipo                          Valor  Descrição
drawContainer  Boolean  Padrã  Define se o popupForm
                        o      deve desenhar uma borda
cancelable     Boolean  true   que delimita seu conteúdo.

                        true   Define se o popupForm
                               pode ser cancelado pelo
                               usuário.

                               Quando true, o popupForm
                               fecha automaticamente
                               quando o usuário fizer uma
                               ação de cancelamento de
                               popup (tecla ESC, clique no
                               botão X da janela em
                               desktop, tecla voltar em
                               celulares/tablets, click fora
                               do Popup em dispositivos
                               móveis, etc..).

                               Quando false, o popupForm
                               não fecha automaticamente
                               quando o usuário fizer uma
                               ação padrão de
                               cancelamento do popup.
                               Assim, a única maneira de
                               fechar o popupForm é
                               invocar o método "close" ou
                               "gui.closePopup" via
                               programação.

                               O evento
                               "onCancelRequest" é
                               disparado apenas quando
                               "cancelable" for false.
placement  String                "cente  Define onde o popupForm
           enumerado:            r"      deve ser exibido.
resizable
movable              ● "cen      false   "center" - no centro da tela
                          ter"
                                         "bottom" - na parte de baixo
                     ● "bot              da tela
                          tom"
                                         "top" - na parte de cima da
                     ● "top              tela
                          "
                                         "left" - à esquerda na tela
                     ● "left
                          "              "right" - à direita na tela

                     ● "righ             "topLeft" - no canto
                          t"             superior esquerdo da tela

                     ● "top              "topRight - no canto
                          Left"          superior direito da tela

                     ● "top              "bottomLeft" - no canto
                          Righ           inferior esquerdo da tela
                          t"
                                         "bottomRight" - no canto
                     ● "bot              inferior direito da tela
                          tom
                          Left"          "mouse" - onde o mouse
                                         está atualmente
                     ● "bot
                          tom            "mouseCenter" -
                          Righ           centralizado onde o mouse
                          t"             está atualmente.

                     ● "mo               Define se o usuário pode
                          use"           redimensionar o popup form
                                         manualmente.
                     ● "mo
                          use            Funciona somente se a
                          Cent           propriedade
                          er"            "drawContainer" for true.

           Boolean                       Observações:

                                                   ● Por enquanto,
                                                        esta
                                                        propriedade não
                                                        possui efeito no
                                                        Firecast Mobile.

           Boolean               true    Determines whether the

                                         user can move the popup
                                           form by clicking and
                                           dragging it.

                                           This property is considered
                                           only if the "drawContainer"
                                           property is set to "false".

Métodos da tag popupForm                   Descrição
   Método
   popupForm:show();                       Exibe o popup na interface do usuário
                                           Retorna true se o popupForm não estava
   popupForm:close();                      visível e passou a ficar visível na
                                           interface.

                                           Fecha o popup da interface do usuário.
                                           Retorna true o popupForm estava visível
                                           na interface e passou a não ficar visível.

Eventos da tag popupForm  Descrição
   Nome do evento

onCancelRequest           Se o atributo "cancelable" for false, este evento é invocado
                          quando o usuário fizer uma ação sinalizando que deseja
                          fechar o popup.

                          Você pode realizar ações "bacanas" aqui, como, por
                          exemplo:

                                    ● Invocar o método "close" apenas se o usuário
                                         não tiver preenchido nenhum campo da
                                         interface

                                    ● Perguntar ao usuário se ele realmente deseja
                                         cancelar (usando dialogs.confirmYesNo) e só
                                         depois então fechar o popup invocando o
                                         método "close".

Veja também Tratando eventos do Lua Form.
```
