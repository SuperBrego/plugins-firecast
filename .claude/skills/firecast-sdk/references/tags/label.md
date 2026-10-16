# Tag label

> Extraído de `docs/Firecast_SDK_-_Single formatado.pdf` (texto automático; tabelas podem ter colunas desalinhadas). 

```text
Tag label

       A tag/componente label representa um texto não editável na interface. Excelente para mostrar
       informações.

Herança

            O label possui todas as características de uma tag de texto. Veja:
                           ● Características de todas as tags de textos
                           ● Características de todas as tags visuais

Características

  Além das características herdadas, a tag label também possui as seguintes características:

Propriedades e atributos

Propriedade               Tipo     Valor   Descrição
                                   Padrão

autoSize                  Boolean  false   Se for true, o label
                                           automaticamente ajusta seu
                                           tamanho (crescendo ou
                                           encolhendo) para melhor exibir o
                                           seu conteúdo.
field   String  <string  Caminho de um campo no
format  String  vazio>   NodeDatabase.

                <string  Quando associado, o label passa a
                vazio>   apresentar o conteúdo do campo
                         na interface.

                         Veja também:

                                   ● Lua Form e
                                        NodeDatabase

                                   ● NodeDatabase

                         Define uma formatação
                         automática para o texto do label.

                         Esta propriedade aceita
                         formatações estilo printf da
                         linguagem C ou Format da
                         linguagem Pascal.

                         Exemplos:

                         %d    Número

                               inteiro

                         %f    Número

                               float/"com

                               vírgula"

                         %3.3  Número
                         f     float
                               apresenta
                               ndo 3
                               casas
                               decimais

                         %s    Texto

                         %.2f  Número

                         kg    com duas

                               casas

                               decimais

                               seguidas

                               do texto

                               "kg"

                         Carg  Apresenta
                         a em  um texto
                              %1.1   como:
                              f %%   Carga em
                                     25,3 %

                              Para documentação completa,
                              favor procurar a documentação
                              da função Format do Delphi.

                              Observações:

                                        ● Se a propriedade
                                             formatFloat estiver
                                             preenchida, a
                                             propriedade format é
                                             ignorada.

                                        ● Apenas 1 parâmetro
                                             é suportado em
                                             format.

formatFloat  String  <string  Define uma formatação
                     vazio>   automática para números no
                              label. Esta permite um controle
                              maior do que a propriedade
                              format.

                              Esta propriedade aceita
                              formatações da função
                              FormatFloat do Delphi.

                              Exemplos:

                              0.00   Númer

                                     o com 2

                                     casas

                                     decimai

                                     s

                              ,0.00  Númer
                                     o com 2
                                     casas
                                     decimai
                                     se
                                     separad
                                     or de
                                     milhare
                                     s

                              0.0#   Númer

                                     o com 1

                                     ou 2
0.###      casas
litros     decimai
           s,
0.00##     depend
# kg       endo do
           valor.
Total: ,0
.00        Númer
           o com 0
           a3
           casas
           decimai
           s,
           depend
           endo do
           valor e,
           no final,
           a
           palavra
           "litros"

           Númer
           o com 2
           a5
           casas
           decimai
           s,
           depend
           endo do
           valor e,
           no final,
           a
           palavra
           "kg"

           Palavra
           "Total: "
           seguida
           de
           número
           com 2
           casas
           decimai
           se
           separad
           or de
           milhare
           s.
Receita   O
de        caracte
0.00;Pr   r;
ejuízo    separa
de 0.00   seções
          para
+0.00;    valores
(0.00);v  positivo
azio      s,
          negativ
          os e
          zero.

          Se
          positivo
          ou
          maior
          que
          zero,
          usa a
          formata
          ção
          "Receit
          a de
          0.00",
          se
          negativ
          o,
          utiliza a
          formata
          cao
          "Prejuíz
          o de
          0.00"

          O
          caracte
          r;
          separa
          seções
          para
          valores
          positivo
          s,
          negativ
          os e
          zero.

          Se
          positivo
                                                                                                       : +0.00
                                                                                                       Se
                                                                                                       negativ
                                                                                                       o: (0.00)
                                                                                                       Se zero:
                                                                                                       vazio
                                                                            Para documentação completa,
                                                                            favor procurar a documentação
                                                                            da função FormatFloat do Delphi.
                                                                            Observações:
                                                                                      ● Se a propriedade
                                                                                           formatFloat estiver
                                                                                           preenchida, a
                                                                                           propriedade format é
                                                                                           ignorada.

Exemplos:
Exemplo 1 - Olá Mundo

    <?xml version="1.0" encoding="UTF-8"?>
    <form name="frmFichaTeste">

                   <label left="20" top="20" text="Olá Mundo"/>
    </form>

Exemplo 2 - Cores
<?xml version="1.0" encoding="UTF-8"?>
<form name="frmFichaTeste">

              <label left="20" top="20" text="Label de cor verde com quebra de
linha" fontColor="lime" autoSize="true"/>

</form>

Veja também String de cores no Lua Form

Exemplo 3 - Usando Field para integrar com o NodeDatabase

<?xml version="1.0" encoding="UTF-8"?>
<form name="frmFichaTeste">

              <label left="20" top="20" field="campoForca" autoSize="true"
wordWrap="false"/>

         <button left="20" top="40" width="150" text="Aumentar Força"
                       onClick="sheet.campoForca = (sheet.campoForca or 0) +

1;"/>

</form>

Neste exemplo, um botão que incrementa o valor do field "campoForca" enquanto o label,
conectado ao mesmo campo, exibe seus valores.
                                  ->                                                    ->

Veja também:

                          ○ Tratando eventos do Lua Form
                          ○ Lua Form e NodeDatabase

Tag layout

(Conteúdo desta página não consta no documento original.)
```
