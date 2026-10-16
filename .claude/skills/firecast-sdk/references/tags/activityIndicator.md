# Tag activityIndicator

> Extraído de `docs/Firecast_SDK_-_Single formatado.pdf` (texto automático; tabelas podem ter colunas desalinhadas). 

```text
Tag activityIndicator

A tag/componente activityIndicator representa um controle que exibe uma animação na interface com
o intuito de indicar ao usuário que alguma atividade está sendo feita, como um carregamento ou uma
outra espera qualquer!

Herança

          O activityIndicator possui todas as características de uma tag visual qualquer. Veja:
                         ● Características de todas as tags visuais

Características

Além das características herdadas, a tag activityIndicator também possui as seguintes características:

Propriedades e atributos

Propriedade               Tipo                            Valor Padrão Descrição
enabled         Boolean                  false  Este atributo controla a
                                                animação do indicador
                                                de atividade.
                                                Quando true, o indicador
                                                apresenta uma animação
                                                na interface.

Exemplos:

Exemplo 1 - Um indicador de atividade simples

 <?xml version="1.0" encoding="UTF-8"?>
 <form name="frmFTeste">

                <activityIndicator left="20" top="20" enabled="true"/>
 </form>
```
