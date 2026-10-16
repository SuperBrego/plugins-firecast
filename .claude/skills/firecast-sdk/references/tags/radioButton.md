# Tag radioButton

> Extraído de `docs/Firecast_SDK_-_Single formatado.pdf` (texto automático; tabelas podem ter colunas desalinhadas). 

```text
Tag radioButton

       A tag/componente radioButton representa uma caixa de marcação na interface que, quando
       usada em grupo, permite apenas uma esteja marcada por vez.

Herança

            O radioButton possui todas as características de uma tag de texto. Veja:
                           ● Características de todas as tags de textos
                           ● Características de todas as tags visuais

Características

  Além das características herdadas, a tag radioButton também possui as seguintes características:

Propriedades e atributos

Propriedade               Tipo     Valor Padrão  Descrição

checked                   Boolean  false         Indica se a caixa de
                                                 marcação está marcada
                                                 (true) ou desmarcada (false)

groupName                 String   <string       Um texto qualquer usado
                                   vazio>        pelo programador
                                                 programador para
                                                 especificar grupos de
                                                 radioButton.

                                                 Quando um radioButton é
                                                 marcado, todos os outros
                                                 radioButtons que
                                                 possuírem o mesmo valor
                                                 de groupName são
                                                 desmarcados.

field                     String   <string       Caminho de um campo no
                                   vazio>        NodeDatabase.

                                                 Quando associado, o
                                                 radioButton passa a
                                                 apresentar e salvar o
                                                 conteúdo no campo
                                                 informado.

                                                 Ao preencher este campo, é
                                                 recomendado que você
                                                 também preencha o
                                                 atributo "fieldValue"
                                                 abaixo.
fieldValue         String          <string       Veja também:
                                   contendo o
                                   mesmo name              ● Lua Form e
                                   do                           NodeDatabase
                                   controle/tag
                                   >                       ● NodeDatabase

                                                 Quando usado com o
                                                 NodeDatabase através do
                                                 "field", este atributo
                                                 contém o valor que é salvo
                                                 no campo do
                                                 NodeDatabase quando o
                                                 radioButton estiver
                                                 selecionado.

                                                 Na prática, existirão vários
                                                 radioButtons ligados ao
                                                 mesmo field, porém cada
                                                 um com um "fieldValue"
                                                 diferente.

Eventos            Descrição
   Nome do evento

onChange           Este evento é invocado quando a marcação do radioButton
                   sofre alteração.

Veja Tratando eventos do Lua Form

Exemplos:
Exemplo 1 - RadioButtons simples

<?xml version="1.0" encoding="UTF-8"?>
<form name="frmFTeste">

              <radioButton text="Força" groupName="grupoDeRadios1" field="atributoBasico"
fieldValue="for"

                                      top="10" left="20"/>

              <radioButton text="Destreza" groupName="grupoDeRadios1" field="atributoBasico"
fieldValue="des"

                                      top="32" left="20" />
                   <radioButton text="Inteligência" groupName="grupoDeRadios1"
    field="atributoBasico" fieldValue="int"

                                          top="54" left="20"/>
    </form>
```
