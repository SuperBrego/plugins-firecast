# Tag dataScopeBox

> Extraído de `docs/Firecast_SDK_-_Single formatado.pdf` (texto automático; tabelas podem ter colunas desalinhadas). 

```text
Tag dataScopeBox

     A tag/componente dataScopeBox funciona como a tag layout, porém permite definir em qual
     objeto Nodo seus controles salvarão/lerão os dados (NodeDatabase);
     Após definir o nodo escopo, todos os componentes visuais que estão dentro desta tag passarão a
     ler e salvar os dados neste nodo.
     Saiba mais sobre escopo de dados do NodeDatabase em Lua Form e NodeDatabase.
     Atenção: A tag popup não é capturada pelo escopo de dados definido pelo dataScopeBox.

Herança

     O dataScopeBox possui todas as características de uma tag layout.
     Veja:

                               ○ Tag layout
                               ○ Características de todas as tags visuais.

Características

     Além das características herdadas, o dataScopeBox possui também as seguintes características:

Propriedades    Tipo           Valor Padrão                  Descrição
                Objeto Nodo    nil
 Propriedade                                                 Define em qual objeto nodo de um
 scopeNode,                                                  NodeDatabase os controles de
 nodeObject ou                                               edição deste dataScopeBox
 node                                                        devem salvar os dados.
                                                             Observações:

                                                                       ● Se for nil, os controles
                                                                            dentro desta tag que
                                                                            salvam/carregam
                                                                            dados no
                                                                            NodeDatabase ficam
                                                                            desabilitados.

                                                                       ● Só é possível alterar
                                                                            esta propriedade
                                                                            utilizando código Lua.

                                                             Veja também:
                                                                       ● NodeDatabase
                                                                       ● Escopo de Dados

Métodos

É possível invocar métodos dos controles usando código LUA.

Método                                  Descrição

dataScopeBox:setNodeObject(nodeObject)  Método alternativo para alterar a
                                        propriedade "scopeNode"

dataScopeBox:getNodeObject();           Método alternativo que retorna o valor da
                                        propriedade "scopeNode"
Eventos da tag dataScopeBox

Nome do evento               Descrição
onNodeReady
                             Este evento é invocado quando o objeto nodo de um
onNodeUnready                NodeDatabase associado a este dataScopeBox está pronto
                             para ser usado.
                             Quando este evento é chamado, você pode assumir:

                                       ● a propriedade "node" do dataScopeBox está
                                            diferente de nil e possui uma referência válida para
                                            um objeto nodo.

                                       ● O processo de carregamento do nodeDatabase
                                            associado já chegou ao fim. Você já consegue
                                            acessar os dados armazenados nele normalmente.

                             Este evento é invocado quando o objeto nodo de um
                             NodeDatabase associado a este dataScopeBox deixa de estar
                             pronto para ser usado.
                             Quando este evento é chamado, você pode assumir:

                                       ● a propriedade "node" do dataScopeBox não contém
                                            mais uma referência válida para um objeto nodo.

onNodeChanged                Este evento é invocado um objeto nodo de um NodeDatabase é
                             associado ou desassociado a este dataScopeBox.
                             Ver NodeDatabase

Veja também Tratando eventos do Lua Form.

Exemplos:

Exemplo 1 - Lista com Painel de Detalhes
Veja o tutorial Criar uma lista dinâmica + painel de detalhes para ver o exemplo completo .
```
