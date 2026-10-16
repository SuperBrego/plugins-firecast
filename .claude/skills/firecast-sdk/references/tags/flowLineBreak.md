# Tag flowLineBreak

> Extraído de `docs/Firecast_SDK_-_Single formatado.pdf` (texto automático; tabelas podem ter colunas desalinhadas). 

```text
Tag flowLineBreak

     A tag/componente flowLineBreak é um componente invisível e serve apenas para quebrar linha
     em um layout dinâmico (Ver Tag flowLayout).
     Observações:

                               ○ Deve ser usado junto com a Tag flowLayout.
                               ○ Se a orientação do flowLayout for "vertical", esta tag cria uma nova coluna

                                    no layout.
     IMPORTANTE: Esta tag foi descontinuada. Prefira utilizar o sistema de alinhamento em grid em
     vez desta tag.

Herança

     O flowLineBreak possui todas as características de uma tag visual.
     Veja:

                               ○ Características de todas as tags visuais.

Características

     Além das características herdadas, o flowLineBreak possui também as seguintes características:

Propriedades e atributos  Tipo                  Valor      Descrição
 Propriedade                                    Padrão
                          Enumerado:                       Se definido, altera as novas linhas
 horzAlign                          ● "leadin   <não       do layout dinâmico serão
                                         g"     definido>  alinhadas horizontalmente:
                                    ● "cente               "leading": Alinhados à esquerda
                                         r"                "center": Alinhados ao centro
                                    ● "trailin             "trailing": Alinhados à direita
                                         g"                "justify": Alinhados de forma
                                    ● "justify             justificada
lineSpacing                 "  <não       Se definido, altera o espaçamento
             Float             definido>  entre as novas linhas do layout
                                          dinâmico.

Exemplos

Exemplo 1 - Quebra de linha

 <?xml version="1.0" encoding="UTF-8"?>
 <form name="frmFichaTeste">

                <flowLayout left="20" top="20" width="250" autoHeight="true">
                              <button text="Botão 1"/>
                              <button text="Botão 2"/>

                             <flowLineBreak/>

                              <button text="Botão 3"/>

                             <flowLineBreak/>

                              <button text="Botão 4"/>
                              <button text="Botão 5"/>
                              <button text="Botão 6"/>
                              <button text="Botão 7"/>
                </flowLayout>
 </form>
```
