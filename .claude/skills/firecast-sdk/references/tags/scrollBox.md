# Tag scrollBox

> Extraído de `docs/Firecast_SDK_-_Single formatado.pdf` (texto automático; tabelas podem ter colunas desalinhadas). 

```text
Tag scrollBox

       A tag/componente scrollBox é um controle que adiciona barras de rolagem ao seu conteúdo,
       permitindo realizar “scroll” nos componentes que estão dentro da caixa.
       Em dispositivos que possuem touch screen, permite também o gesto de “pinça” para efetuar
       zoom do conteúdo. .
       Observação: As barras de rolagem aparecem apenas for necessário, isto é, as dimensões do
       conteúdo for maior que as dimensões da tag scrollBox

Herança

       O scrollBox possui todas as características de um controle qualquer. Veja Características de
       todas as tags visuais.

Exemplos

Exemplo 1

    <?xml version="1.0" encoding="UTF-8"?>
    <form name="frmFichaTeste">
                   <scrollBox left="10" top="10" width="150" height="150">
                                 <edit top="0" text="edit 1"/>
                                 <edit top="50" text="edit 2"/>
                                 <edit top="100" text="edit 3"/>
                                 <edit top="150" text="edit 4"/>
                                 <edit top="200" text="edit 5"/>
                                 <edit top="250" text="edit 6"/>

                   </scrollBox>
    </form>
```
