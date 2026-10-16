# Tag checkBox

> Extraído de `docs/Firecast_SDK_-_Single formatado.pdf` (texto automático; tabelas podem ter colunas desalinhadas). 

```text
Tag checkBox

     A tag/componente checkBox representa uma caixa de marcação na interface.

Herança

          O checkBox possui todas as características de uma tag de texto. Veja:
                         ● Características de todas as tags de textos
                         ● Características de todas as tags visuais
Características

Além das características herdadas, a tag checkBox também possui as seguintes características:

Propriedades e atributos

Propriedade               Tipo        Valor Padrão    Descrição
checked                   Boolean     false
                                                      Indica se a caixa de marcação
field                     String      <string vazio>  está marcada (true) ou
                                                      desmarcada (false)

                                                      Caminho de um campo no
                                                      NodeDatabase.
                                                      Quando associado, o checkBox
                                                      passa a apresentar e salvar o
                                                      conteúdo no campo informado.
                                                      Veja também:

                                                                ● Lua Form e
                                                                     NodeDatabase

                                                                ● NodeDatabase

Eventos

Nome do evento            Descrição

onChange                  Este evento é invocado quando a marcação do checkBox sofre

                          alteração.

Veja Tratando eventos do Lua Form

Exemplos:

Exemplo 1 - CheckBox simples

 <?xml version="1.0" encoding="UTF-8"?>
 <form name="frmFichaTeste">

                <checkBox left="10" top="20" text="Caixa de marcação"/>
 </form>
```
