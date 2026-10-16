# Tag style

> Extraído de `docs/Firecast_SDK_-_Single formatado.pdf` (texto automático; tabelas podem ter colunas desalinhadas). 

```text
Tag style

       Esta tag especial serve para definir um estilo em cascata, muito semelhante ao CSS no HTML.
       Um estilo em cascata é um bloco de códigos especiais que aplica valores à propriedades de 1 ou
       mais controles de uma vez só, em cascata.
       É especialmente útil para evitar retrabalho e para separar o formato do conteúdo principal do
       Lua Form.
       Importante: A sintaxe do estilo em cascata é muito semelhante ao do CSS, porém as
       propriedades disponíveis são diferentes..

Características

       A tag style não possui nenhum atributo/propriedade e seu corpo contém o código do estilo em
       cascata.

Sintaxe
   A tag style possui uma sintaxe muito parecida com o CSS e seu conteúdo consiste de uma lista
   de regras. Cada regra ou conjunto de regras consiste de um ou mais seletores e um bloco de
   declaração. Uma declaração de bloco é composta por uma lista de declarações entre chaves.
   Cada declaração em si é uma propriedade, dois pontos (:), um valor, então um ponto e vírgula (;).
   Exemplo que resume as regras acima:

seletor1 [, seletor2, ...] {

   propriedade1: valor;

 [propriedade2: valor2;

   ...]

}

Seletores

       Um seletor é uma regra genérica que define à quais tags/componentes o estilo será aplicado, e
       ele pode as seguintes aparências:

Seletor  Exemplo          Descrição

.class   .TituloAtributo  O estilo será aplicado a todas as tags
                          que possuam atributo "class"
                          equivalente a "TituloAtributo".

                          Exemplo de tag que receberia o
                          estilo em cascata:
                          <label text="Olá Mundo"
                          class="TituloAtributo"/>

#nome    #edtNome         O estilo será aplicado à tag cujo
                          atributo "name" seja igual a
*        *                "edtNome"
tagName  label
                          Exemplo de tag que receberia o
                          estilo em cascata:

                          <edit name="edtNome"
                          text="Campo de text"/>

                          O estilo será aplicado a todas as tags.

                          O estilo é aplicado a todas as tags
                          "tagName", neste exemplo, todos os
                          labels.
                                       Exemplo de tag que receberia este
                                       estilo em cascata:

                                       <label text="Olá mundo"/>

tagName.class   layout.PainelAtributo  O estilo é aplicado a todas as tags
                                       "layou" cujo atributo "class" seja
                                       "PainelAtributo"

Além disso, através da combinação dos seletores acima, é possível definir um seletor composto
que analisa onde a tag está. Exemplos:

Seletor         Exemplo                Descrição

.class tagName  .PainelAtributo label  O estilo será aplicado a todos as "label"
                                       que estão dentro de alguma tag que
                                       contenha o atributo "class" equivalente
                                       a "PainelAtributo"

                                       Exemplo:

                                       <layout class="PainelAtributo">
                                        <label text="Label de dentro"/>

                                       </layout>

                                       <label text="Label de fora"/>

                                       Neste caso, o label de dentro receberá o
                                       estilo, porém o label de fora não.

tagName         layout label           O estilo será aplicada a todos "labels"
tagName         .PainelAtributo .Titu  que estão dentro de algum "layout"
.class .class   loAtributo
                                       O estilo será aplicado a todas as tags
tagName         layout layout label    que possuam atributo "class" igual a
tagName                                "TituloAtributo" que estão dentro de
tagName                                alguma tag que possuam "class" igual a
etc....                                "PainelAtributo";

                                       O estilo será aplicado a todos "labels"
                                       que estão dentro de um "layout" que por
                                       sua vez estão dentro de outro "layout".
       É possível definir múltiplos seletores a um único bloco de estilo utilizando vírgula, exemplo:

    .TituloAtributo, .TituloPericia, .TituloEquipamento {
                   fontSize: 18;
                   width: 200;

    }

  "fontSize: 18" e "width: 200" serão aplicados a todas as tags cuja propriedade "class" seja
  "TituloAtributo", "TituloPericia" e "TituloEquipamento".

Propriedades
       As propriedades disponíveis são aquelas que a tag disponibiliza. Confira a documentação da
       TAG.
       Importante: O conjunto de propriedades é diferente daquelas que você pode usar em CSS do
       HTML.

Exemplos

Exemplo 1 - Aplicando uma cor de fonte e alinhamento à todos labels de um lua form.

    <?xml version="1.0" encoding="UTF-8"?>
    <form name="frmFichaTeste">

                   <style>
                                 label {
                                                fontColor: lime;
                                                horzTextAlign: center;
                                                vertTextAlign: center;

                               }
                   </style>

                   <layout left="20" top="20" width="100" height="100">
                                 <label align="top" text="Label 1"/>
                                 <label align="top" text="Label 4"/>
                                 <label align="top" text="Label 5"/>
                                 <label align="top" text="Label 6"/>
                                 <label align="top" text="Label 7"/>

                   </layout>
    </form>
Exemplo 2 - Aplicando uma cor e negrito à tags de uma determinada class

    <?xml version="1.0" encoding="UTF-8"?>
    <form name="frmFichaTeste">

                   <style>
                                 .Titulo {
                                                fontColor: lime;
                                                fontStyle: bold;
                                 }

                   </style>

                   <layout left="20" top="20" width="100" height="100">
                                 <label class="Titulo" align="top" text="Label 1"/>
                                 <label align="top" text="Label 4"/>

                                 <label class="Titulo" align="top" text="Label 5"/>
                                 <label align="top" text="Label 6"/>

                                 <label class="Titulo" align="top" text="Label 7"/>
                                 <label align="top" text="Label 8"/>
                   </layout>
    </form>
Exemplo 3 - (Avançado) Uma mini ficha, usando edits, labels, layouts e styles.

    <?xml version="1.0" encoding="UTF-8"?>
    <form name="frmFichaTeste">

                    <style>
                                 layout.LayoutCampo {
                                                width: 64;
                                                align: left;
                                                margins: {left=2, right=2};
                                 }

                                 layout.LayoutCampo edit {
                                                height:30;
                                                horzTextAlign: center;
                                                fontSize: 20;
                                                align: top;

                                 }

                                 layout.LayoutCampo label {
                                                align: top;
                                                horzTextAlign: center;
                                                vertTextAlign: leading;
                                                autoSize: true;

                                 }
                   </style>

                   <layout left="10" top="10" width="200" height="64">
                                 <layout class="LayoutCampo">
                                                <edit field="combate.armadura"/>
                                                <label text="Armadura"/>
                                 </layout>

                                 <layout class="LayoutCampo">
                                                <edit field="saude.pontosDeVida"/>
                                                <label text="Pontos de Vida"/>

                                 </layout>

                                 <layout class="LayoutCampo">
                                                <edit field="equipamentos.carga"/>
                                                <label text="Carga (kg)"/>

                                 </layout>
                   </layout>
    </form>

  Neste exemplo, os atributos dos edits, labels e layouts foram definidos por Estilo em Cascata pela
  tag style.
  Foram definidos 3 blocos de estilos em cascata:

            ● Um com seletor "layout.LayoutCampo" (aplicado a todas as tags layout de class
                 "LayoutCampo")

            ● Um com seletor "layout.LayoutCampo edit" (aplicado a todas as tags edit que
                 estão dentro de uma tag layout de class "LayoutCampo")

            ● Um com seletor "layout.LayoutCampo label" (aplicado a todas as tags label
                 que estão dentro de uma tag layout de class "LayoutCampo")
```
