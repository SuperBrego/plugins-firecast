# Tag colorComboBox

> Extraído de `docs/Firecast_SDK_-_Single formatado.pdf` (texto automático; tabelas podem ter colunas desalinhadas). 

```text
Tag colorComboBox

     A tag/componente colorCmboBox representa uma caixa de seleção que permite o usuário
     selecionar uma cor qualquer.

Herança

          O colorComboBox possui todas as características de uma tag visual. Veja:
                         ● Características de todas as tags visuais
Características

Além das características herdadas, a tag colorComboBox também possui as seguintes características:

Propriedades e atributos

Propriedade               Tipo           Valor Padrão    Descrição
color                     String de Cor  "Null"
                                                         A cor escolhida pelo usuário.
                                                         Exemplos: "Red", "White",
                                                         "#005623"

useAlpha                  Boolean        True            Se true, permite o usuário
field                     String         <string vazio>  escolher uma cor com
                                                         transparência.
frameRegion               String         <string vazio>
                                                         Caminho de um campo no
                                                         NodeDatabase.
                                                         Quando associado, o
                                                         colorComboBox passa a
                                                         apresentar e salvar o conteúdo
                                                         no campo informado.
                                                         Veja também:

                                                                   ● Lua Form e
                                                                        NodeDatabase

                                                                   ● NodeDatabase

                                                         Considerando que o
                                                         componente/tag pai possui um
                                                         frame (ver Frames), ao definir o
                                                         valor desta propriedade, a
                                                         posição e tamanho deste
                                                         controle é automaticamente
                                                         calculada para se encaixar na
                                                         Região do Frame de mesmo
                                                         nome.
                                                         Veja Frames e Regiões

Métodos                                  Descrição

 Método                                  "Abre" o colorComboBox. Exibe a caixa de
 colorComboBox:dropDown()                seleção de cores na interface.

Eventos                   Descrição

 Nome do evento           Este evento é invocado quando a seleção do colorComboBox é
 onChange                 alterada.
onUserChange              Este evento é disparado quando o valor do campo do objeto
                          Nodo associado (ver atributo "field") for alterado porque o
                          usuário alterou o conteúdo do colorComboBox.
                          Importante: Este evento é disparado APENAS se o atributo
                          "field" estiver preenchido corretamente e se a alteração de
                          valor ocorrer neste colorComboBox mediante ação do usuário.

Veja Tratando eventos do Lua Form

Exemplos

Exemplo 1 - colorComboBox simples
```
