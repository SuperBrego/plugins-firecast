# Tag import

> Extraído de `docs/Firecast_SDK_-_Single formatado.pdf` (texto automático; tabelas podem ter colunas desalinhadas). 

```text
Tag import

       Com a tag import, o programador pode importar/incluir um outro documento XML ao Lua
       Form, acarretando na substituição da tag pelo conteúdo do arquivo especificado.
É especialmente útil para:

                         ○ Organizar o documento Lua form. Exemplo: Quando o arquivo ".lfm"
                               ficar grande, é interessante dividir ele em partes menores, cada parte
                               em seu documento XML separado.

                         ○ Reaproveitar código. Exemplo: Se você tiver templates ou styles que
                               queira reaproveitar em outros Lua Forms, você pode criar um
                               documento XML que contenha apenas o que queira reaproveitar e o
                               importar nos Lua Forms.

Características

Propriedades e atributos

Propriedade               Tipo    Valor               Descrição
                                  Padrão

file                      String  <Não há             Endereço de um arquivo

                                  valor               XML.

                                  padrão>             Este endereço é relativo à

                                                      localização do documento

                                                      atual. Portanto, se o outro

                                                      arquivo XML estiver na

                                                      mesma pasta, você só precisa

                                                      informar o nome dele.

                                                      Exemplo:

                                                      "MeuDocumento.xml"

Exemplos

Exemplo 1 - Importação simples
   Arquivo “ficha.lfm”

    <?xml version="1.0" encoding="UTF-8"?>
    <form name="frmFichaTeste">

                   <import file="OutroArquivo.xml"/>
    </form>

Arquivo “OutroArquivo.xml”
    <?xml version="1.0" encoding="UTF-8"?>
    <layout width="100" height="100" top="20" left="20">

                   <label align="client" horzTextAlign="center" text="Estou em outro
    documento"/>
    </layout>

Exemplo 2 - Importação de várias tags usando a Tag group
       Usando a Tag group conseguimos importar um grupo de tags que está em outro documento
       XML.

   Arquivo “ficha.lfm”

    <?xml version="1.0" encoding="UTF-8"?>
    <form name="frmFichaTeste">

                   <import file="OutroArquivo.xml"/>

                   <MinhaTag titulo="Meu Botão"/>
    </form>

   Arquivo “OutroArquivo.xml”

    <?xml version="1.0" encoding="UTF-8"?>
    <group>

                   <style>
                                 label {
                                                fontColor: lime;
                                 }

                   </style>
                   <template name="MinhaTag">

                                 <button left="20" top="120" text="$(titulo)"/>
                   </template>
              <layout width="100" height="100" top="20" left="20">
                             <label align="client" horzTextAlign="center"
                                         text="Estou em outro documento"/>

              </layout>
</group>
```
