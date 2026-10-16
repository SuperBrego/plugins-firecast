# Tag tab

> Extraído de `docs/Firecast_SDK_-_Single formatado.pdf` (texto automático; tabelas podem ter colunas desalinhadas). 

```text
Tag tab

       A tag/componente tab representa uma aba dentro de um grupo de abas (Ver Tag tabControl).
       Excelente para dividir controles em duas ou mais abas.
       IMPORTANTE: Para usar abas, você deve usar uma Tag tabControl.

Herança
O tab possui todas as características de uma tag visual. Veja:
               ● Características de todas as tags visuais

Características

  Além das características herdadas, a tag tab também possui as seguintes características:

Propriedades e atributos

Propriedade               Tipo    Valor                        Descrição
                                  Padrão

text ou title             string  <string                      Representa o título da aba.
                                  vazio>

Métodos
  É possível invocar métodos dos controles usando código LUA.

Método                            Descrição

tab:activate()                    Ativa a aba no tabControl.

Exemplos

Exemplo 1 - Uma aba simples

    <?xml version="1.0" encoding="UTF-8"?>
    <form name="frmFichaTeste">

                   <tabControl left="20" top="20">
                                 <tab title="Minha aba">
                                 </tab>

                   </tabControl>
    </form>
Exemplo 2 - Duas abas com conteúdos distintos

    <?xml version="1.0" encoding="UTF-8"?>
    <form name="frmFichaTeste">

                   <tabControl left="20" top="20" width="250">
                                 <tab title="Primeira Aba">
                                                <label text="Olá Mundo, texto na primeira aba" align="client"
                                                             vertTextAlign="center" horzTextAlign="center"/>
                                 </tab>

                                 <tab title="Segunda Aba">
                                                <edit text="Edit na segunda aba" width="200" left="25" top="10"/>

                                 </tab>
                   </tabControl>
    </form>
  Observação: Foram usadas neste exemplo a Tag label e a Tag edit
```
