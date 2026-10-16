# Tag group

> Extraído de `docs/Firecast_SDK_-_Single formatado.pdf` (texto automático; tabelas podem ter colunas desalinhadas). 

```text
Tag group

       Com a tag group, o programador pode agrupar outras tags. Esta tag não faz nada além disso,
       não afeta a interface visual e nem a interpretação do Lua Form.
       Não há propriedades e nem atributos.
       É especialmente útil para usar com a tag import. Honestamente, sua única utilidade é essa
       hehehe =)

Exemplos

Exemplo 1 - Importação de várias tags usando a Tag group
       Usando a Tag import conseguimos importar um grupo de tags que está em outro documento
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
