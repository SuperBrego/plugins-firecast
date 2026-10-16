# Biblioteca locale

> Extraído de `docs/Firecast_SDK_-_Single formatado.pdf` (texto automático; tabelas podem ter colunas desalinhadas). 

```text
Biblioteca Locale

       Biblioteca que contém funções para lidar com idiomas e regiões, incluindo funcionalidade para
       permitir um plug-in em várias línguas
       Exemplo de uso:

    -- Primeiro, é necessário usar a unidade "locale.lua"
    require("locale.lua");

    -- Agora é possível acessar as funções da biblioteca
    Locale.FUNCAO_DA_BIBLIOTECA(Parametro1, Parametro2, ...);

Funções da biblioteca Locale

    function lang(txtId)
    ou
    function LANG(txtId)
    ou
    function Locale.lang(txtId)

       Percorre todos os arquivos ".lang" do plug-in à procura de um texto cuja identificação seja igual
       à passada como parâmetro e que combine com o idioma atual do usuário.
       Esta função é a principal para você obter strings correto para o idioma do usuário.
       Parâmetros:

                                 ○ txtId - Uma cadeia de caracteres que identifica o texto que deseja obter
       Retorno:

                                 ○ Uma cadeia de caracteres contendo o texto para o idioma do usuário.
       Observações:

                                 ○ A busca ocorre em todos os arquivos de extensão .lang de forma
                                      eficiente.

                                 ○ Caso a busca não encontre o texto para o idioma do usuário, a busca
                                      retornará uma cadeia de caracteres de outro idioma. A função emite um
                                      erro se "txtId" não for conhecido em nenhum idioma.

                                 ○ Leia o tutorial de como criar um plug-in multi-línguas para exemplo!

    function Locale.loadLangTexts(langTexts)

       Carrega, em tempo de execução, um arquivo ".lang" para que mais textos traduzidos possam ser
       encontrados pelas funções Locale.lang e Locale.tryLang.
       Parâmetros:
Observações:            ○ langTexts - Uma cadeia de caracteres com o conteúdo do arquivo .lang
                             que será carregado em tempo de execução.

                        ○ Leia o tutorial de como criar um plug-in multi-línguas para exemplo!

function Locale.newLocalizedTexts()

   Creates an isolated context to work with translations without affecting the plugin translations.
   Arguments:

        None
   Return:

                             ○ A new LocalizedTexts object

function tryLang(txtId)
ou
function tryLANG(txtId)
ou
function Locale.tryLang(txtId)

Idêntico à função lang, porém retorna nil ao invés de um erro quando não encontra a tradução.

LocalizedTexts object

  This object represents an isolated context for working with translations without modifying the
  plugin translations itself.

  You can create a new instance of this object by calling Locale.newLocalizedTexts()

Object characteristics

Methods                        Descrição
   Método

obj:addText(localeId, textId,  Add a single translation entry to the
text)                          LocalizedTexts object.

                               Arguments:

                                                              ○ localeId - A string
obj:lang(textId)                                              containing the
obj:loadTexts(langTexts)                                      identification of the
                                                              locale, in BCP 47
                                                              format, in which this
                                                              text should be used.
                                                              Examples: "pt", "pt-
                                                              BR", "en", "en-US",
                                                              and so on. Nil or
                                                              empty string means
                                                              undefined.
                                                         ○ textId - A string
                                                              containing the
                                                              identification of the
                                                              text. This textId is
                                                              used when searching
                                                              translations with
                                                              translations with
                                                              obj:lang() and/or
                                                              obj:tryLang().
                                                         ○ text - A string
                                                              containing the
                                                              translated text.

                          Search for a translation to be used for the current
                          user's language.

                          Arguments:

                                                         ○ textId - A string
                                                              containing the
                                                              identification of the
                                                              text.

                          Returns:

                                                         ○ A string containing
                                                              the translated text.

                          Remarks:

                                                         ○ If the search does not
                                                              find text for the
                                                              user's language, the
                                                              function will return a
                                                              string from another
                                                              language.

                                                         ○ The function raises
                                                              an error if "textId"
                                                              does not exist in any
                                                              language.

                          Loads a ".lang" file so that more translated text
obj:tryLang(textId)  can be found by the obj:lang() and obj:tryLang()
                     methods.

                     Arguments:

                                                    ○ langTexts - A string
                                                         with the contents of
                                                         the .lang file that will
                                                         be loaded

                     Remarks:

                                                    ○ Read the tutorial on
                                                         how to create a
                                                         multi-language plugin
                                                         for examples.

                     This function works similarly to the obj:lang()
                     method, except it does not raise an error if the
                     text entry does not exist. In such a case, a nil
                     value is returned.
```
