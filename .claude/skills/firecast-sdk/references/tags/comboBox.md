# Tag comboBox

> Extraído de `docs/Firecast_SDK_-_Single formatado.pdf` (texto automático; tabelas podem ter colunas desalinhadas). 

```text
Tag comboBox

     A tag/componente comboBox representa uma caixa de seleção que permite o usuário selecionar
     um item entre vários..

Herança

          O comboBox possui todas as características de uma tag de texto. Veja:
                         ● Características de todas as tags de textos
                         ● Características de todas as tags visuais

Características

Além das características herdadas, a tag comboBox também possui as seguintes características:

Propriedades e atributos

Propriedade               Tipo     Valor Padrão    Descrição
text                      String   <string vazio>
                                                   O texto escolhido pelo usuário e
                                                   apresentado na interface pelo
                                                   comboBox.
                                                   Observação: Este campo retorna
                                                   e aceita somente valores que
                                                   estão na propriedade "items"
value        String      <string vazio>>  O valor associado ao item
field        String                       escolhido e apresentado na
                                          interface.
frameRegion  String                       Observação: Este campo retorna
                                          e aceita somente valores que
transparent  Boolean                      estão na propriedade "values".
items        Arranjo de
             String      <string vazio>   Caminho de um campo no
                                          NodeDatabase.
                         <string vazio>   Quando associado, o comboBox
                                          passa a apresentar e salvar o
                         false            conteúdo no campo informado.
                         {}               Veja também:

                                                    ● Lua Form e
                                                         NodeDatabase

                                                    ● NodeDatabase
                                                    ●
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

                                          Quando True, as bordas e o
                                          fundo do comboBox não serão
                                          exibidas, mostrando apenas o
                                          texto conteúdo.

                                          Lista de itens do qual o usuário
                                          poderá escolher um.
                                          Exemplo:
                                          {'Lança', 'Espada', 'Adaga'}
values                Arranjo de   {}  Lista de valores associados aos
                                       itens da propriedade "items".
                      String           Cada posição deste arranjo é
                                       "casado" com a mesma posição
                                       do arranjo "items".
                                       Observação 1: Não é obrigatório
                                       o uso desta propriedade;
                                       Observação 2: Quando esta
                                       propriedade e o atributo "field"
                                       estiverem definidos, este são os
                                       valores que serão salvos no
                                       NodeDatabase.
                                       Exemplo: {'L', 'E', 'A'}

Métodos                                Descrição

 Método                                "Abre" o comboBox. Exibe a lista de seleção
 comboBox:dropDown()                   na interface.

Eventos               Descrição

 Nome do evento       Este evento é invocado quando a seleção do comboBox é
 onChange             alterada.

Veja Tratando eventos do Lua Form

Exemplos

Exemplo 1 - comboBox simples

 <?xml version="1.0" encoding="UTF-8"?>
 <form name="frmFichaTeste">

                <comboBox left="20" top="20" items="{'Lança', 'Espada', 'Adaga'}"/>
 </form>

Exemplo 2 - comboBox usando a propriedade "values" para escolha do item padrão.
 <?xml version="1.0" encoding="UTF-8"?>
 <form name="frmFichaTeste">

                <comboBox left="20" top="20" items="{'Lança', 'Espada', 'Adaga'}"
                                  values="{'L', 'E', 'A'}" value="E"/>

 </form>

Neste exemplo, devido as propriedades "items" e "values", houve a associação dos seguintes valores e
itens:

          ● L = Lança
          ● E = Espada
          ● A = Adaga
```
