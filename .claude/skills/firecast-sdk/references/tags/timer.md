# Tag timer

> Extraído de `docs/Firecast_SDK_-_Single formatado.pdf` (texto automático; tabelas podem ter colunas desalinhadas). 

```text
Tag timer

       A tag timer representa um componente não visual (não é exibido na interface) que executa
       determinado código LUA de tempo em tempo.

Características

Propriedades e atributos

Propriedade               Tipo    Valor    Descrição
                                  Padrão

name                      String  <string  Define um nome para
                                  vazio>   a componente.

                                           O nome deve ser
                                           único, isto é, dentro
interval           Integer         1000  de um form, não é
                                   true  possível existir 2
enabled            Boolean               controles com o
                                         mesmo nome. Se não
                                         for definido um nome
                                         para o controle no
                                         arquivo LFM, um
                                         nome único será
                                         gerado para ele em
                                         tempo de compilação.
                                         Nomear controles é
                                         especialmente útil
                                         quando se quer
                                         trabalhar com
                                         códigos LUA.

                                         Intervalo, medido em
                                         milisegundos, de
                                         quando em quando o
                                         evento onTimer será
                                         disparado.

                                         1000 = 1 segundo

                                         500 = 0,5s

                                         10000 = 10 segundos

                                         Quando true, o
                                         evento onTimer será
                                         disparado de acordo
                                         com o atributo
                                         interval.

                                         Quando false, o
                                         evento onTimer não
                                         será disparado.

Eventos            Descrição
   Nome do evento

onTimer            Este evento é invocado de tempos em tempos, de acordo
                   com o valor da propriedade "interval".

Veja Tratando eventos do Lua Form

Exemplos
Exemplo 1 - Um label "piscando"

    <?xml version="1.0" encoding="UTF-8"?>
    <form name="frmFichaTeste">

                   <timer interval="500" onTimer="self.labMeuLabel.visible = not
    self.labMeuLabel.visible;"/>

                   <label name="labMeuLabel" align="client" horzTextAlign="center"
    text="Olá!"/>
    </form>

  Veja Tratando eventos do Lua Form
```
