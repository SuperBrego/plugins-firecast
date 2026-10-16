# Tag textEditor

> Extraído de `docs/Firecast_SDK_-_Single formatado.pdf` (texto automático; tabelas podem ter colunas desalinhadas). 

```text
Tag textEditor

  A tag/componente textEditor representa uma caixa de texto de múltiplas linhas. Um ótimo
  controle para permitir a entrada de dados texto com quebra de linhas.

Herança

            O textEditor possui todas as características de uma tag de texto. Veja:
                   ● Características de todas as tags de textos
                   ● Características de todas as tags visuais

Características

  Além das características herdadas, a tag textEditor também possui as seguintes características:

Propriedades e atributos

Propriedade               Tipo       Valor    Descrição
                                     Padrão

readOnly                  Boolean    false    Quando true, o textEditor
                                              não permite o usuário
                                              alterar seu conteúdo
                                              (somente leitura).

field                     String     <string  Caminho de um campo no
                                     vazio>   NodeDatabase.

                                              Quando associado, o
                                              textEditor passa a
                                              apresentar e salvar o
                                              conteúdo no campo
                                              informado.

                                              Veja também:

                                                        ● Lua Form e
                                                             NodeDatabase

                                                        ● NodeDatabase

transparent               Boolean    false    Quando True, as bordas e o
                                              fundo do textEditor não
                                              serão exibidas, mostrando
                                              apenas o texto conteúdo e o
                                              cursor de digitação.

Eventos                   Descrição
   Nome do evento

onChange                  Este evento é invocado quando o conteúdo do textEditor é
                          alterado.

Veja Tratando eventos do Lua Form

Exemplos:
Exemplo 1 - Um textEditor simples

    <?xml version="1.0" encoding="UTF-8"?>
    <form name="frmFichaTeste">

                   <textEditor left="10" top="10" width="150" height="250" text="Este é um textEditor\n\ncom
    multiplas linhas"/>
    </form>
```
