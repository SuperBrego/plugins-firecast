# Tutoriais, projeto de plug-in, module.xml, rdk, Drag and Drop

> Extraído de `docs/Firecast_SDK_-_Single formatado.pdf` (texto automático; tabelas podem ter colunas desalinhadas). 

```text
PRIMEIROS PASSOS

(Conteúdo desta página não consta no documento original.)

HISTÓRICO DE VERSÕES

(Conteúdo desta página não consta no documento original.)
TUTORIAIS

Criar um modelo de ficha à partir de um PDF

     1. Você deve ter um projeto de plug-in já criado. Se você ainda não tem um projeto de plug-in, leia
          "Criando um novo projeto de plug-in" e crie o seu antes (é bem fácil =] )

     2. Abra o prompt de comando e navegue até a pasta de seu projeto de plug-in.

     3. Execute o comando "rdk pdf" sem aspas no prompt de comando
Uma página como esta se abrirá no navegador de internet (Sempre utilize um browser mais atualizado.
Experimente o Google Chrome):
4. Clique em "escolher arquivo" e selecione o PDF que deseja converter.
5. Se o Zoom padrão de 1,5x deixar o conteúdo muito pequeno, escolha outro valor de escala que
     melhor se encaixar em seu PDF e clique em "Aplicar Configurações". Experimente outras
     configurações também!
6. Clique em "salvar todas as páginas". Um arquivo ".zip" que contém o PDF em formato .SVG será
     gerado!
7. Copie o arquivo .zip (gerado no passo anterior) para a pasta do projeto do plug-in.
8. Volte no prompt de comando e execute "rdk lfm <ArquivoZip.zip>" sem as áspas e substituindo
     <ArquivoZip.zip> pelo nome do arquivo gerado no passo 6.

9. Volte na pasta projeto do plug-in e entre no sub-diretório criado pelo comando no passo
     anterior (Local onde contém os arquivos .lfm convertidos)
10. Edite o arquivo .lfm principal (aquele que contém o mesmo nome do arquivo .PDF):
11. Altere os atributos "dataType" e "title" do form para valores adequados:
     dataType – Um texto que identifica qual é o tipo de conteúdo do seu modelo de ficha. Você
     deve inventar um Data Type único que possua ao menos cinco caracteres alfanuméricos, "_" ou
     "." e que não comece com dígitos. Use a criatividade! Exemplos: “br.com.rrpg.DnD5_S3”,
     “br.com.rrpg.VampiroAMascara”, “br.com.meusite.MeuModeloDeFicha”, “meuplugin.FichaX”,
     etc..
     title – O título do seu modelo de ficha. Este texto aparecerá na lista de fichas quando o usuário
     criar um personagem. Exemplos: “DnD 5th”, “Vampiro a Máscara”, “Meu modelo de ficha”, etc..

12. Pronto! Agora você já pode excluir o arquivo ".zip" que colocou na pasta projeto do plug-in e
     executar o comando "rdk i" para testar o modelo de ficha no RRPG =)
     13. Se quiser, edite os arquivos ".lfm" gerados em um editor de texto para complementar a ficha
          gerada!

Observações

     ● Os cálculos e scripts existentes no PDF não são convertidos automaticamente. Você deve
          recriá-los manualmente, se quiser. Leia o tutorial Criar campos calculados em fichas.

Criar campos calculados em fichas

Os campos calculados são feitos usando a tag dataLink para definir cálculos que devem ser executados
quando houver mudança nos valores de alguns campos da ficha (NodeDatabase).
Tutorial 1 - Campo calculado simples

Neste tutorial, iremos fazer com que o label da interface abaixo sempre mostre o valor do cálculo
"((campo forca) / 2 - 5) arredondado para baixo".
Importante: Note que o edit já está ligado ao campo "forca" da ficha/NodeDatabase

 <?xml version="1.0" encoding="UTF-8"?>
 <form name="frmFTeste">

                <layout left="20" top="20" height="25" width="200">
                              <!-- Atributo -->
                              <label align="left" text="Força: " autoSize="true"/>
                              <edit align="client" horzTextAlign="center" field="forca"/>

                              <!-- Modificador -->
                              <label align="right" text="valor" width="70"
 horzTextAlign="center"/>
                </layout>
 </form>

Passo 1 - Associar o label a um campo do NodeDatabase/Ficha

Vamos ligar o label a um campo chamado "modificadorDeForca":

 <label field="modificadorDeForca" align="right" text="valor" width="70"
 horzTextAlign="center"/>

Passo 2 - Criar uma tag dataLink

Vamos criar uma tag dataLink e ligá-la ao campo "forca" para que possamos associar um código LUA
que será executado sempre que o campo "forca" for alterado.

 <dataLink field="forca">
 </dataLink>
Passo 3 - Criar uma tag event para tratar o evento "onChange" do dataLink que criamos.

 <dataLink field="forca">
                <event name="onChange">

                </event>
 </dataLink>

Veja também: Tratando eventos do Lua Form

Passo 4 - Escrever o código LUA do cálculo

 <dataLink field="forca">
                <event name="onChange">
                              sheet.modificadorDeForca = math.floor(((sheet.forca or 10) / 2)

 - 5);
                </event>

 </dataLink>

Aqui realmente colocamos o código do cálculo. O que este código faz:
     ● Toda vez que o valor do campo "forca" mudar, atribui ao campo "modificadorDeForca" (àquele
          que o label foi conectado) o resultado de:
               ○ o valor do campo "forca" (ou 10, caso ainda não tenha sido preenchido) dividido por 2,
                    subtraído em 5 e arredondado para baixo (math.floor).

Passo 5 - Aprimorar o código do cálculo

 <dataLink field="forca">
                <event name="onChange">
                              local mod = math.floor(((sheet.forca or 10) / 2) - 5);
                              if (mod >= 0) then
                                             mod = "+" .. mod;
                              end;
                              sheet.modificadorDeForca = mod;
                </event>
 </dataLink>

Colocamos uma condição (um "if") para adicionar o caracter "+" na frente do resultado se for positivo
ou zero.

Código final do tutorial

 <?xml version="1.0" encoding="UTF-8"?>
 <form name="frmFTeste">

                <!-- Aqui começa o layout da ficha -->
                <layout left="20" top="20" height="25" width="200">

                              <!-- Atributo -->
                              <label align="left" text="Força: " autoSize="true"/>
                              <edit align="client" horzTextAlign="center" field="forca"/>
                              <!-- Modificador -->
                              <label field="modificadorDeForca" align="right" text="valor"

                                           width="70" horzTextAlign="center"/>
                </layout>
                <!-- Começa aqui os cálculos automáticos da ficha -->
                <dataLink field="forca">

                              <event name="onChange">
                                             local mod = math.floor(((sheet.forca or 10) / 2) - 5);

                                             if (mod >= 0) then
                                                            mod = "+" .. mod;

                                             end;
                                             sheet.modificadorDeForca = mod;
                              </event>
                </dataLink>
 </form>
Tutorial 2 - Criar um campo calculado que depende do valor de outros 3
campos

Neste tutorial, vamos completar o tutorial 1 acima para adicionar um campo calculado chamado
"Bônus de Ataque Corpo-A-Corpo", que será igual à soma dos seguintes campos:

     ● "Bônus Base de Ataque" (campo editável)
     ● "Bônus de Proficiência da Arma" (campo editável)
     ● Modificador de força (campo calculado).

Considere que:
     ● O texto (label) apontado pela seta branca está ligado ao field "modificadorDeForca"
     ● A caixa de texto (edit) apontada pela seta vermelha está ligada ao field "bonusBaseAtaque"
     ● A caixa de texto apontada pela seta verde está ligada ao field "bonusProficiencia"
     ● O texto apontado pela seta azul está ligado ao field "ataque"

Passo 1 - Criar uma tag dataLink que se conectará, ao mesmo tempo, aos 3 campos
necessários para o cálculo:

 <dataLink fields="{'modificadorDeForca', 'bonusBaseAtaque',
 'bonusProficiencia'}">
 </dataLink>

ATENÇÃO: Para ligar um dataLink à mais de 1 campo ao mesmo tempo, você deve usar o atributo
"fields" do DataLink ao invés de "field" (Um está no plural, enquanto outro está no singular).

Passo 2 - Criar uma tag event para tratar o evento "onChange" do dataLink que criamos.

<dataLink fields="{'modificadorDeForca', 'bonusBaseAtaque',

'bonusProficiencia'}">  <event name="onChange">

</event>
</dataLink>

Este evento será chamado sempre que qualquer um dos campos informados em "fields" sofrer
alteração.

Passo 3 - Escrever o código LUA do cálculo

<dataLink fields="{'modificadorDeForca', 'bonusBaseAtaque',

'bonusProficiencia'}">  <event name="onChange">

             sheet.ataque = (tonumber(sheet.modificadorDeForca) or 0) +

                        (tonumber(sheet.bonusBaseAtaque) or 0) +

                        (tonumber(sheet.bonusProficiencia) or 0);

                           if sheet.ataque >= 0 then
                                         sheet.ataque = "+" .. sheet.ataque;

                           end;
              </event>
</dataLink>

Sempre que o valor de algum dos campos ligados mudar ("modificadorDeForca", "bonusBaseAtaque"

ou "bonusProficiencia"):

     ● o campo "ataque" receberá a soma de:
               ○ Valor do campo "modificadorForca" interpretado como número (o valor campo pode
                    não ser um número válido, exemplo: "ABC") ou 0 caso não consiga interpretar como
                    número.
               ○ Valor do campo "bonusBaseAtaque" interpretado como numero ou 0 caso não consiga
                    interpretar como número.
               ○ Valor do campo "bonusProficiencia" interpretado como número ou 0 caso não consiga
                    interpretar como número.

     ● Se o valor do campo "ataque" for maior ou igual a zero:
               ○ Adiciona o caracter "+" na frente do valor.
Criar abas para a ficha

Para criar abas na ficha, você deve utilizar as tags tabControl e tab.
Você cria 1 tag "tabControl" e adiciona, dentro, quantas tags "tab" quiser, uma para cada aba. Os
controles de cada aba devem ser adicionados dentro de sua respectiva tag "tab".
Para entender melhor, veja exemplos de tab e tabControl.

Permitir o usuário escolher uma imagem dentro da ficha

É necessário o usar a tag image, colocar sua propriedade "editable" para "true" e definir um "field" para
ela.
Adicionalmente, você poderá definir a propriedade "style" da tag como "autoFit" para que o a imagem
ocupe todo o espaço definido para ela.
Exemplo:

 <?xml version="1.0" encoding="UTF-8"?>
 <form name="frmFTeste">

                <image field="imagemDoPersonagem" editable="true" style="autoFit"
                             left="20" top="20" width="200" height="200" />

 </form>

O usuário poderá alterar a imagem quando clicar nela:
Criar uma lista dinâmica na ficha

Se você deseja adicionar uma uma lista dinâmica de algo (com quantidade personalizada pelo usuário)
em sua ficha, você deve utilizar a tag recordList.
Exemplos:

     ● Uma lista de equipamentos
     ● Uma lista de ataques
     ● Uma lista de magias
Você precisará ter, no mínimo, dois arquivos ".lfm", um representando a ficha que contém a lista (a tag
recordList) e um que descreve o painel que deve "repetir" para cada item desta lista.
Para melhor compreender, veja este exemplo.

Fazer uma ficha enviar rolagens para a mesa

     1. Adicione uma tag button ao Lua Form
     2. Manipule o evento "onClick" da tag button
     3. Utilize o código abaixo:

              <button>
                              <event name="onClick">
                                             local rolagem =

 rrpg.interpretarRolagem(sheet.ataqueDoPersonagem);

                                             if not rolagem.possuiAlgumDado then
                                                            -- se o usuario não tiver preenchido qual dado

 rolar,
                                                            -- vamos adicionar um 1d20 + na "fórmula da

 rolagem"
                                                            rolagem =

 rrpg.interpretarRolagem("1d20"):concatenar(rolagem);
                                             end;

                                             local mesaDoPersonagem = rrpg.getMesaDe(sheet);

                                             if mesaDoPersonagem ~= nil then
                                                          mesaDoPersonagem.chat:rolarDados(rolagem, "Ataque

 do personagem");
                                             end;

                              </event>
                </button>

     1. Altere o código conforme a necessidade

O que o código acima faz?

     1. Utiliza a função interpretarRolagem da biblioteca "rrpg" para interpretar o campo
          "ataqueDoPersonagem" como uma rolagem de dados.

     2. Verifica se a rolagem utiliza algum dado (d4, d6, d8, etc..)... Se não possuir dado na rolagem
          (Exemplos: "+5", ou "-2"), faz:
               1. Interpreta uma nova rolagem "1d20" e a concatena/junta ao inicio (Para ficar, por
                    exemplo, "1d20 + 5" ou "1d20 - 2").
3. Usando a ficha atual (sheet), tenta localizar o objeto mesa à qual a ficha pertence. É usado a
     função getMesaDe da biblioteca rrpg para isso.

4. Se conseguiu localizar o objeto mesa à qual a ficha atual pertence:
          1. Invoca o método rolarDados do chat da mesa, passando a rolagem que queremos e um

               texto adicional "Ataque do personagem".

Mudanças que você pode querer fazer no código acima

     ● O código acima usa o texto da rolagem contido no campo chamado "ataqueDoPersonagem".
          Talvez a rolagem de sua ficha esteja em outro campo.

     ● Quando a rolagem não usar nenhum dado (d4, d6, d8, etc..) o código adiciona "1d20" ao inicio
          dela. Talvez o sistema da sua ficha não utiliza 1d20 nesta rolagem!

     ● Que tal alterar o texto "Ataque do personagem"?
     ● Talvez você queira que somente o mestre e o jogador dono da ficha possam rolar dados desta

          ficha.
               ○ Você pode utilizar a função getPersonagemDe da biblioteca rrpg e verificar se sua
                    propriedade dono é igual à propriedade meuJogador da variável mesaDoPersonagem.
                    Se for igual, é porque a ficha pertence ao usuário.
               ○ Você pode utilizar a propriedade isMestre do objeto meuJogador para verificar se o
                    usuário é mestre da mesa.
               ○ O código que faz esta verificação seria parecido com:

local personagem = rrpg.getPersonagemDe(sheet);

if (personagem ~= nil) then
            local mesa = personagem.mesa;

      if ((personagem.dono == mesa.meuJogador) or

(mesa.meuJogador.isMestre)) then                 -- permitir

enviar a rolagem

      end;

end;

Criar uma lista dinâmica + painel de detalhes

Este tutorial vai ensinar a criar uma lista dinâmica de itens que, quando você selecionar um dos itens
desta lista, exibe um painel detalhando as informações sobre o item selecionado.
É recomendado você ler Criar uma lista dinâmica na ficha antes, pois este tutorial utiliza a mesma ideia.

Dois arquivos Lua Form (extensão ".LFM")

Utilizaremos a tag recordList neste tutorial, portanto, você deve possuir dois arquivos ".lfm":
     ● O arquivo Lua Form principal que contém a tag recordList
     ● O arquivo Lua Form Template dos Itens do Record List: Este form vai ser instanciado 1 vez para

          cada item na lista.
Neste tutorial, chamaremos o arquivo Lua Form Principal de "MinhaFicha.lfm" e o arquivo Lua Form
Template dos Itens de "ItemDaLista.lfm"

Imagens
Sobre a implementação

A ideia para criar esta lista dinâmica com painel de detalhes é bem simples. Existem dois componentes
chaves nesta ideia:

     ● Você precisa de um recordList que funcionará como uma lista onde o usuário possa escolher o
          item.

     ● Você precisará de um dataScopeBox que conterá as tags que são apresentadas no painel de
          detalhes.

Quando o usuário escolher um item no recordList (evento "onSelect" da tag recordList), fazemos com
que os componentes que estão dentro do dataScopeBox passem a salvar/carregar dados neste item ao
alterar o escopo de dados das tags que estão dentro. Caso tenha dúvida sobre escopo de dados, veja
Escopo de Dados no Lua Form
Código Fonte

 Arquivo “MinhaFicha.lfm”

 <?xml version="1.0" encoding="UTF-8"?>
 <form name="frmFTeste" theme="dark" padding="{left=4, top=4, right=4, bottom=4}">

    <!-- Botão de inserir novo item à lista -->
    <layout align="top" height="30" margins="{bottom=4}">

                  <button text="Criar Novo Item" width="150" align="left">
                                 <event name="onClick">
                                               -- Usuário clicou no botão de criar novo item.
                                               -- Vamos inserir um novo item no nosso recordList
                                               self.rclListaDosItens:append();
                                 </event>

                  </button>
    </layout>

    <!-- recordList, representando a lista -->
    <recordList name="rclListaDosItens" field="campoDosItens" templateForm="frmItemDaLista"

                                               align="client" selectable="true">

                             <event name="onSelect">
                                           --[[
                                           Este evento é chamado quando o usuário selecionar/deselecionar itens da lis

Quando o usuário selecionar, vamos fazer nosso dataScopeBox (e todas as tag dentro dele) salvar e c
dados no objeto Nodo (NodeDatabase) do item selecionado.

1.  --]]

2.  local node = self.rclListaDosItens.selectedNode;

          self.boxDetalhesDoItem.node = node;
3.  -- a caixa de detalhe só ficará visível se houver item selecionado

                   self.boxDetalhesDoItem.visible = (node ~= nil);

    </event>

    </recordList>

              <!-- dataScopeBox representando a nossa caixa de detalhes -->
              <dataScopeBox name="boxDetalhesDoItem" visible="false" align="right"

                                        width="400" margins="{left=4, right=4}">
                             <!-- Faça um layout "bonito" para sua caixa de detalhes =). Utilize a propriedade "
nas tags aqui dentro -->

    <rectangle align="top" color="black" xradius="10" yradius="10"
                                      height="180" padding="{top=3, left=3, right=3, bottom=3}">

                                           <layout align="top" height="30" margins="{bottom=4}">
                                                          <label align="left" text="Titulo do Item:" autoSize="true"/>
                                                          <edit align="client" field="campoTitulo"/>

                                           </layout>

                                           <layout align="top" height="130">
                                                          <image align="left" editable="true" field="campoURLImagem" width="1

                                                          <layout align="client" margins="{left=2}">
                                                                        <edit align="top" field="campoSubTitulo" height="30"/>
                                                                        <textEditor align="top" field="campoTextoGrande" height="10

                                                          </layout>
                                           </layout>
                             </rectangle>
              </dataScopeBox>
</form>

Arquivo “ItemDaLista.lfm”

<?xml version="1.0" encoding="UTF-8"?>
<form name="frmItemDaLista" height="50" theme="dark">

              <layout align="client" margins="{left=4, right=4, top=4, bottom=4}">
                             <!-- Botão para apagar o item da lista -->
                             <button align="left" width="32" text="X" onClick="ndb.deleteNode(sheet);"/>

                             <!-- O título do item que aparece na lista -->
                             <label align="client" text="Teste de label" field="campoTitulo" margins="{left=4}"/
              </layout>
 </form>

Lista Dinâmica + Painel de Detalhes alternativo

Código Fonte Alternativo

 Arquivo “MinhaFicha.lfm”

 <?xml version="1.0" encoding="UTF-8"?>
 <form name="frmFTeste" theme="dark" padding="{left=4, top=4, right=4, bottom=4}">
    <!-- Botão de inserir novo item à lista -->

    <layout align="top" height="30" margins="{bottom=4}">
                  <button text="Criar Novo Item" width="150" align="left">
                                 <event name="onClick">
                                               -- Usuário clicou no botão de criar novo item.
                                               -- Vamos inserir um novo item no nosso recordList
                                               self.rclListaDosItens:append();
                                 </event>
                  </button>

    </layout>

              <!-- recordList, representando a lista -->
              <recordList name="rclListaDosItens" field="campoDosItens" templateForm="frmItemDaLista" ali
layout="horizontal" height="40">

                             <event name="onSelect">
                                           --[[
                                           Este evento é chamado quando o usuário selecionar/deselecionar itens da lis

fazer nosso dataScopeBox (e todas as tag dentro dele) salvar e carregar dados no objeto Nodo (Nod

1.  --]]

2.  local node = self.rclListaDosItens.selectedNode;

                            self.boxDetalhesDoItem.node = node;

3.  -- a caixa de detalhe só ficará visível se houver item selecionado

                            self.boxDetalhesDoItem.visible = (node ~= nil);

                  </event>
    </recordList>

    <!-- dataScopeBox representando a nossa caixa de detalhes -->

    <dataScopeBox name="boxDetalhesDoItem" visible="false" align="client"
                             margins="{left=4, right=4, top=2}">

                  <!-- Faça um layout "bonito" para sua caixa de detalhes =). Utilize a propriedade "

    <rectangle align="client" color="black" xradius="10" yradius="10"
                        padding="{top=3, left=3, right=3, bottom=3}">

                            <layout align="top" height="30" margins="{bottom=4}">
                                        <label align="left" text="Titulo do Item:" autoSize="true"/>
                                        <edit align="client" field="campoTitulo"/>

                            <!-- Botão de apagar o item -->
                                                        <button align="right" text="Apagar!"
                                                                       margins="{left=4, right=4, top=2, bottom=2}" width="150"
                                                                       onClick="ndb.deleteNode(self.boxDetalhesDoItem.node);" />

                                           </layout>

                                           <layout align="top" height="130">
                                                          <image align="left" editable="true" field="campoURLImagem" width="1

                                                          <layout align="client" margins="{left=2}">
                                                                        <edit align="top" field="campoSubTitulo" height="30"/>
                                                                        <textEditor align="top" field="campoTextoGrande" height="10

                                                          </layout>
                                           </layout>
                             </rectangle>
              </dataScopeBox>
</form>

Arquivo “ItemDaLista.lfm”

<?xml version="1.0" encoding="UTF-8"?>
<form name="frmItemDaLista" height="50" width="100">

              <!-- O título do item que aparece na lista -->

              <label align="client" text="Teste de label" field="campoTitulo"
                           margins="{left=4, right=4, top=4, bottom=4}"/>

              <!-- Adicionar um valor padrão para o campoTitulo caso esteja vazio.
                             Isto é especialmente útil em novos itens -->

              <dataLink field="campoTitulo" defaultValue="Titulo Aqui"/>
</form>

Incrementando o código: Selecionar o primeiro item ao carregar os dados

Trate o evento "onEndEnumeration" da tag recordList com o seguinte código:

<event name="onEndEnumeration">
              if self.rclListaDosItens.selectedNode == nil and sheet ~= nil then
                             local nodes = ndb.getChildNodes(sheet.campoDosItens);

                    if #nodes > 0 then
                                  self.rclListaDosItens.selectedNode = nodes[1];

                    end;

              end;
</event>
Criar um botão que esconde itens de uma lista dinâmica

Atenção: Este é um tópico avançado e requer o conhecimento de como criar uma lista dinâmica.
Este tipo de funcionalidade é útil quando em uma ficha ou em uma janela acoplável é necessário
esconder certos itens de certos usuários, por exemplo:

     ● NPCs - Talvez o mestre queira esconder determinado NPC dos jogadores
     ● Equipamentos - Talvez um jogador de um grupo possua um equipamento que o Mestre deseja

          que os demais jogadores não saibam de sua existência.
     ● Uma anotação secreta, que somente o mestre pode visualizar.

Começando....

Vamos supor que você já tenha implementado em seu código uma lista dinâmica com a seguinte
aparência:

e com o seguinte código:
 Arquivo Principal “ficha.lfm”

 <?xml version="1.0" encoding="UTF-8"?>
 <form name="frmFichaTeste">

                <layout align="top" height="30">
                              <button align="left" text="Novo"

 onClick="self.rclLista:append();"/>
                </layout>

                <recordList name="rclLista" align="client" field="itens"
                                      templateForm="frmItem"/>

 </form>

 Arquivo Secundário “item.lfm”
 <?xml version="1.0" encoding="UTF-8"?>
 <form name="frmItem" height="30" margins="{top=2,bottom=2}">

         <edit align="client" field="descricao" margins="{right=2}"/>

         <button align="right" text="Apagar" width="80"
                     onClick="ndb.deleteNode(sheet);"/>

 </form>

Próximos passos

Para adicionar a funcionalidade de esconder item, você deverá fazer as seguintes alterações em seu
arquivo equivalente ao "item.lfm" (aquele que repete para cada item na lista):

     ● Criar um botão novo ou outra funcionalidade que permita o usuário clicar e realizar uma ação.
          Neste tutorial usaremos a tag imageCheckBox pelo simples fato de eu achá-la bacana =).

 <imageCheckBox name="cbxInvisivel" align="right" width="25"
 margins="{left=2, right=2}"
 checkedImage="images/invisivel.png"
 uncheckedImage="images/visivel.png" autoChange="false"
 onClick="self:alternarVisibilidade();" />

Esta é a imagem "images/invisivel.png":
Esta é a imagem "images/visivel.png:
Note que a propriedade autoChange foi setada para false para que a tag não mude automaticamente
sua propriedade "checked".
Note também que ao clicar no imageCheckBox, será invocada a função "self:alternarVisibilidade"

     ● Criar o código da função "self:alternarVisibilidade" que utiliza a função ndb.setPermission

 <script>
                function self:alternarVisibilidade()
                              if self.cbxInvisivel.checked then
                                             -- o imageCheckbox está marcando como

 invisivel..
                                             -- Vamos mudar as permissões para

 tornar visivel então..

                                             -- resetar as permissões de read dos
 jogadores e espectadores
                                           ndb.setPermission(sheet, "group",
"jogadores", "read", nil);

                                           ndb.setPermission(sheet, "group",
"espectadores", "read", nil;

                             else
                                           -- o imageCheckbox está marcando como

visível
                                           -- Vamos mudar as permissões para

tornar invisível então...

                                           -- negar as permissões de read dos
jogadores e espectadores

                                           ndb.setPermission(sheet, "group",
"jogadores", "read", "deny");

                                           ndb.setPermission(sheet, "group",
"espectadores", "read", "deny");

                             end;
              end;
</script>

   ● Criar um código que fica responsável por atualizar o estado do imageCheckBox conforme as
        permissões existentes e alteradas:

<script>
              function self:atualizarCbxInvisivel()
                             -- Esta função é chamada em vários pontos para atualizar o estado do

checkbox de invisibilidade

                             -- Marcar o checkbox se existir uma permissão "read deny" para jogadores
ou para espectadores

                             self.cbxInvisivel.checked = ndb.getPermission(sheet, "group",
"espectadores", "read") == "deny" or

                                                                                ndb.getPermission(sheet, "group",
"jogadores", "read") == "deny";

                             -- Permitir o click no checkbox apenas se o usuário atual possuir a
permissão "writePermissions"

                             self.cbxInvisivel.enabled = ndb.testPermission(sheet,
"writePermissions");
                end;
 </script>

Veja também:
     ● Função ndb.getPermission
     ● Função ndb.testPermission
               ○ Criar um NodeObserver que será responsável por invocar a função acima
                    "self:atualizarCbxInvisivel" quando ocorrer alguma mudança nas permissões do
                    NodeDatabase. O NodeObserver será criado no evento onScopeNodeChanged da tag
                    Form
<event name="onScopeNodeChanged">
              if self.observer ~= nil then
                             -- Já tinhamos criado um observer, vamos desativá-lo.

                    self.observer.enabled = false;
                    self.observer = nil;

end;

if sheet ~= nil then
              -- O form foi ligado a um NodeDatabase!
              -- Vamos criar um NodeObserver para este nodo.

                    self.observer = ndb.newObserver(sheet);

                    self.observer.onPermissionListChanged =
                                  function(node)
                                                 -- Esta função será chamada quando
                                                 -- as definições de permissões de sheet mudarem

                          self:atualizarCbxInvisivel();

                    end;

                    self.observer.onFinalPermissionsCouldBeChanged =
                                  function(node)
                                                 -- Esta função será chamada quando
                                                 -- minhas permissões em sheet puderem
                                                 -- ter sido afetadas por alterações de permissões
                                                 -- no NodeDatabase ou porque me tornei
                                                 -- mestre/jogador/espectador

                          self:atualizarCbxInvisivel();

                    end;

                    -- Devemos atualizar o checkbox agora também
                    self:atualizarCbxInvisivel();

              end;
</event>
Resultado final

O que aparece para os Mestres da mesa:

O que os Jogadores e Espectadores da mesa veem:

Código fonte final (sem os comentários)

 Arquivo Principal “ficha.lfm”

 <?xml version="1.0" encoding="UTF-8"?>
 <form name="frmFichaTeste">

                <layout align="top" height="30">
                              <button align="left" text="Novo"

 onClick="self.rclLista:append();"/>
                </layout>
                <recordList name="rclLista" align="client" field="itens"
                                      templateForm="frmItem"/>

 </form>

 Arquivo Secundário “item.lfm”
<?xml version="1.0" encoding="UTF-8"?>
<form name="frmItem" height="30" margins="{top=2,bottom=2}">

       <script>
                function self:alternarVisibilidade()
                       if self.cbxInvisivel.checked then
                                ndb.setPermission(sheet, "group", "jogadores", "read", nil);
                                ndb.setPermission(sheet, "group", "espectadores", "read",

nil);
                       else
                                ndb.setPermission(sheet, "group", "jogadores", "read",

"deny");
                                ndb.setPermission(sheet, "group", "espectadores", "read",

"deny");
                       end;

                end;

                function self:atualizarCbxInvisivel()
                       self.cbxInvisivel.checked = ndb.getPermission(sheet, "group",

"espectadores", "read") == "deny" or
                                                                          ndb.getPermission(sheet, "group",

"jogadores", "read") == "deny"

                         self.cbxInvisivel.enabled = ndb.testPermission(sheet,
"writePermissions");

                end;
       </script>

       <edit align="client" field="descricao" margins="{right=2}"/>

       <imageCheckBox name="cbxInvisivel" align="right" width="25"
margins="{left=2, right=2}"

                                  checkedImage="images/invisivel.png"
                                  uncheckedImage="images/visivel.png"
                                  autoChange="false"
                                  onClick="self:alternarVisibilidade();" />

       <button align="right" text="Apagar" width="80"
onClick="ndb.deleteNode(sheet);"/>

       <event name="onScopeNodeChanged">
                     if self.observer ~= nil then
                                    self.observer.enabled = false;
                                    self.observer = nil;
end;

if sheet ~= nil then
              self.observer = ndb.newObserver(sheet);

                           self.observer.onPermissionListChanged =
                                         function(node)
                                                        self:atualizarCbxInvisivel();
                                         end;

                           self.observer.onFinalPermissionsCouldBeChanged =
                                         function(node)
                                                        self:atualizarCbxInvisivel();
                                         end;

                           self:atualizarCbxInvisivel();

                     end;
       </event>
</form>

Criar uma janela acoplável de mesa

Uma janela acoplável de mesa segue os mesmos princípios de um modelo de ficha. A única diferença é
que você deve usar "tablesDock" na propriedade "formType" da tag Form.
Exemplo:

 <?xml version="1.0" encoding="UTF-8"?>
 <form name="frmMinhaJanelaAcoplavel" formType="tablesDock"
 dataType="RRPG.DataTypeUnico.DaMinhaJanelaAcoplavel"

            title="Minha Janela Acoplável">

         <label text="Olá Mundo"/>

         ... Outras tags LFM e códigos lua.....
 </form>

Agora basta compilar seu plug-in que o RRPG fará o resto =)
Como dito anteriormente, janelas acopláveis seguem os mesmos princípios de modelos de fichas e
salvam/carregam dados em um NodeDatabase da mesa. A propriedade "dataType" da tag Form serve
para informar ao RRPG onde os dados devem ser salvos, e, portanto, uma vez definido, é recomendado
que não seja alterado.

Todos da mesa que estiverem com esta janela acoplável aberta lerão e salvarão dados em um único
mesmo lugar: As mudanças no NodeDatabase serão sincronizadas com todos da mesa!
Criando um plug-in para vários idiomas

(Conteúdo desta página não consta no documento original.)
REFERÊNCIAS

Projetos de Plug-in

Um projeto de plug-in é um diretório no computador que contém todo o código fonte e arquivos
auxiliares que são compilados e empacotados sob a forma de um único arquivo de extensão ‘.rpk’, o
plug-in.

Criando um novo projeto de plug-in

     1. Crie uma nova pasta qualquer no computador.
     2. Abra o prompt de comando e navegue pelo prompt até a pasta criada.
     3. Execute o comando “rdk p”, sem as aspas, dentro da pasta para transformar o diretório em um

          projeto de plug-in.
     4. Vá até a pasta criada, abra, em um editor de texto, o arquivo “module.xml” que foi criado pelo

          comando acima e o preencha . Saiba mais sobre este arquivo lendo O arquivo “module.xml”
Exemplo passo a passo

     1. Criando uma nova pasta no computador:
2. Abrindo o prompt de comando e navegando até a pasta criada...
1. Executando o comando "rdk p"
2. Editando o arquivo "module.xml":
Testando o projeto de plug-in

    Para testar seu projeto de plug-in, ele deve ser compilado e instalado no RRPG. Siga estes passos:
     1. Abra o prompt de comando.
     2. Navegue pelo prompt até a pasta do projeto de plug-in.
     3. Execute o comando “rdk i”, sem as aspas, dentro da pasta para compilar e instalar o projeto de

          plug-in.
     4. Teste seu plug-in no RRPG Firecast.
Observações:
     ● O comando “rdk i” não instala o plug-in caso encontre algum erro no projeto.
     ● Se o RRPG Firecast estiver em execução, o comando “rdk i” automaticamente descarrega o

          plug-in, instala a nova versão e recarrega o plug-in.
     ● Se o RRPG Firecast estiver fechado, o comando “rdk i” realiza uma instalação “off-line” e a nova
          versão será carregada quando o RRPG Firecast executar.

Exemplo passo a passo:

     1. Abrindo o prompt de comando:

     2. Navegando pelo prompt até a pasta do projeto de plug-in:
3. Executando o comando "rdk i"

Disponibilizando um plug-in

Agora que você já fez e testou seu plug-in, está na hora de o tornar disponível a outras pessoas!
Onde está o plug-in que criei?

Ao compilar seu projeto (comando "rdk i" ou comando "rdk c"), o arquivo final de seu plug-in é colocado
dentro sub-pasta "output" do projeto.

Distribuição manual

Envie para os outros o arquivo que está dentro da sub-pasta "output"! (Um arquivo de extensão ".rpk")

Instalação manual do plug-in

É bem simples: Se a pessoa já possuir o RRPG Firecast instalado, ela só precisa "dar 2 cliques" no
arquivo baixado e o processo de instalação se iniciará.

Uma maneira alternativa de instalar o plug-in é ir ao menu de plug-ins do RRPG, clicar no botão
"instalar" e escolher o arquivo ".rpk" baixado.

Após a instalação manual, o arquivo ".rpk" pode ser excluído pois não interferirá no funcionamento do
plug-in!

Arquivos em um projeto de plug-in

O arquivo "module.xml"

Todo projeto de plugin deve conter um arquivo de nome “module.xml” em sua raiz que contém as
informações sobre o mesmo. A estrutura das tags/marcações deste documento é:

     ● module

               ○ id – Uma identificação global e única do plug-in. É um texto que contém apenas
                    caracteres alfanuméricos, underlines, pontos e deve conter ao menos 5 caracteres e
                    um máximo de 40. Você deve inventar um valor único para este campo, e, uma vez
                    definido, o ID não deve mudar. Exemplos: “br.com.rrpg.DnD5_SDK3”,
                    “br.com.outrosite.storytellerX”.

               ○ version – Um texto que identifica a versão do seu plug-in. Não se esqueça de atualizar
                    este campo quando for lançar uma nova versão do seu plug-in =). Exemplos: “1.0”, “1.1”,
                    “1.2b”

               ○ info – Tag que reúne as informações do puglin traduzidas em uma determinada língua.
                    Pode aparecer mais de uma vez, uma para cada tradução. Ela contém as seguintes tags
                    filhas:
                         ■ name – O um texto curto que nomeia seu plug-in. Exemplos: “DnD 5”, “Plugin
                               de Mighty Blade”, “Plugin X”, etc..
                         ■ description – Um texto breve que descreve o que seu plug-in faz. Exemplos:
                               “Adiciona suporte a fichas de DnD 5”.
                         ■ author – Seu nome/nickname
                         ■ site – Você possui um site? Coloq-ue aqui o endereço dele se tiver
                    ■ contact – Como se faz contato com você? Adicione endereço de e-mail,
                         facebook, twitter, etc..

          ○ settings – A tag to configure the behaviors of your plugin. Available settings are:
                    ■ automaticStringLocalization – When true, it allows the Firecast to
                         automatically translate attributes of LFM files and strings passed to the API

                         calls. It's a very cool feature to make your plugin multi-language but may

                         produce inconsistent behaviors. Default: false. See Criando um plug-in para

                         vários idiomas

Exemplo:

          <?xml version="1.0" encoding="UTF-8"?>
          <module sdkVersion="3.6">

                 <!--O id identifica seu módulo globalmente. Deve ser único,
          conter apenas caracteres alfanuméricos, underlines, pontos e deve
          conter ao menos 5 caracteres e um máximo de 40. Uma vez definido
          o ID, você não deve alterar ele ;) -->

                 <id>br.com.rrpg.DnD5_SDK3</id>

                 <!--version é a versão do seu módulo. Quando for lançar uma
          nova versão do seu módulo, altere aqui =) -->

                 <version>1.0</version>

          <settings>

          <automaticStringLocalization>true</automaticStringLocalization>
                 </settings>

                 <info lang="pt-BR">
                        <!--Informações do plugin na língua "pt-BR". Você pode

          ter várias tags "info", uma para cada tradução que quiser.-->
                        <name>D&amp;D 5e</name>
                        <description>Modelo de ficha de D&amp;D 5ª

          edição</description>
                        <author>Firecast</author>
                        <site>https://firecast.app/</site>
                        <contact>https://www.facebook.com/AlyssonRPG</contact>

                 </info>

                 <info lang="en">
                        <!--Informações do plugin na língua "en". Você pode ter

          várias tags "info", uma para cada tradução que quiser.-->
                        <name>D&amp;D 5th Edition</name>
                        <description>D&amp;D 5th edition character sheet for

          firecast</description>
                 </info>

          </module>

Embedded font files

(Conteúdo desta página não consta no documento original.)
Ferramentas do SDK 3

Ferramenta rdk

“rdk” é a principal ferramenta do SDK3 e é usada como linha de comando no prompt.

comando "rdk p"

Este comando prepara o diretório corrente para o uso da ferramenta “rdk” mais nova.
Observações:

     ● Quando baixar uma nova versão do SDK 3, você deve executar este comando em cada um do
          seus projetos de plug-ins a fim de atualizá-los.

     ● Você pode preparar um diretório mais de uma vez sem causar nenhum problema.
     ● Este comando cria/atualiza o arquivo “module.xml” (O arquivo “module.xml”) .

comando "rdk c"

Este comando compila o diretório corrente e empacota todo o conteúdo em um único arquivo de
extensão ‘.rpk’ em “<DiretorioCorrente>\output\<NomeDoModulo>.rpk”
Observações:

     ● O comando percorre todos os arquivos de extensão “lfm” e gera arquivos de extensão “lua”
          equivalentes.

     ● O comando realiza validações antes de empacotar o conteúdo do diretório, como:
               ○ O arquivo “module.xml” deve existir e estar preenchido corretamente (O arquivo
                    “module.xml”) .
               ○ Os arquivos de extensão “lua” devem estar sintaticamente corretos.
               ○ Os arquivos de extensão “lfm” devem estar sintaticamente corretos, e possuir tags e
                    atributos válidos.

     ● Os arquivos e subdiretórios de nomes iniciados com dois underlines (“__”) e o diretório “output”
          são ignorados por este comando.

comando "rdk i"

Este comando compila o diretório corrente (ver Comando “rdk c” ) e instala o plugin gerado.
Observações:

     ● Se for encontrado algum erro de validação durante a compilação, o plug-in não é instalado.
     ● Se o RRPG Firecast estiver em execução, o comando “rdk i” automaticamente descarrega o

          plug-in, instala a nova versão e recarrega o plug-in no RRPG Firecast.
     ● Se o RRPG Firecast estiver fechado, o comando “rdk i” realiza uma instalação “off-line” e a nova

          versão será carregada quando o RRPG Firecast for executado
comando "rdk pdf"

Este comando abre uma ferramenta que converte arquivos no formato .PDF para o formato .SVG. Esta
ferramenta funciona no navegador de internet.
Após a conversão, você poderá utilizar o comando "rdk lfm" para converter o conteúdo do .pdf para um
Lua Form

comando "rdk lfm"

rdk lfm <arquivo>
Converte o arquivo informado para um Lua Form .
Formatos aceitos:

     ● Arquivos .svg
     ● Arquivos .zip que contém arquivos .svg
Se você deseja converter um .PDF para Lua Form, utilize a ferramenta "rdk pdf" para extrair o
conteúdo do PDF como SVG antes =)

Arrastando e Soltando Informações / Drag And Drop

Arrastar e Soltar, do inglês "Drag and Drop", é a ação de clicar em um objeto virtual e "arrastá-lo" a uma
posição diferente ou sobre um outro objeto virtual. De maneira geral, ele pode ser usado para invocar
diversos tipos de ações, ou criar vários tipos de associações entre dois objetos abstratos.
A sequência básica de ações relacionadas ao drag-and-drop é:

          ● Clicar, e manter o botão do mouse apertado para "agarrar" o objeto,
          ● "Arrastar" (drag) o objeto/cursor à posição ou localização desejada,
          ● "Soltar" (drop) o objeto, soltando o botão pressionado.

Fluxo de acontecimento

No exemplo a seguir, o usuário iniciou o processo drag-and-drop agarrando o objeto preto (1 na figura),
arrastando o mouse até o objeto vermelho (3 na figura) e soltando o botão.
O fluxo segue na seguinte ordem:
          ● O Usuário clica e mantêm o botão do mouse pressionado sobre o objeto 1 para iniciar um
               processo de drag-and-drop.
          ● O Firecast, através do evento onStartDrag do objeto 1, pede para que o objeto 1 informe as
               informações que o usuário pode arrastar dele.
          ● O Plugin SDK3, dentro da chamada do evento onStartDrag, informa ao Firecast o que o
               usuário pode arrastar do objeto 1. Os dados são adicionados a um objeto Drag (2 na figura)
               que o Firecast cria automaticamente para esta operação de drag-and-drop específica.
          ● O Firecast interage com o usuário até que ele passe o mouse sobre uma área de Drop, isto
               é, de um objeto que aceite que operações drag-and-drop sejam "largadas" sobre ele. O
               objeto 3 possui uma área de drop.
          ● O Firecast, através do evento onStartDrop do objeto 3, pede para que o objeto 3 informe o
               quais informações o usuário pode "largar" sobre ele.
          ● O Plugin SDK3, dentro da chamada do evento onStartDrop, informa ao Firecast o que o
               usuário pode largar sobre o objeto 3. Os dados são adicionados a um objeto Drop que o
               Firecast cria automaticamente para receber estas informações.
          ● O Firecast, com base nas informações do objeto Drag preenchidas pelo objeto 1 e nas
               informações do objeto Drop preenchidas pelo objeto 3, decide se a operação drag-and-
               drop pode acontecer. Se um não conseguir lidar com as informações do outro, a operação
               drag-and-drop não poderá ser concluída.
          ● Caso a operação Drag-and-Drop puder ser finalizada, o Firecast chama a ação do objeto 3
               ou objeto 1 que melhor puder lidar com esta operação.

Informações e Ações em uma operação drag-and-drop

Para que uma operação Drag-And-Drop aconteça, é necessário haver ao menos uma informação e ao
menos uma ação capaz de lidar com ela.
Informações e ações podem existir tanto no objeto Drag quanto no objeto Drop:

          ● Informações existentes no objeto Drag são combinadas com ações existentes no objeto
               Drop

          ● Informações existentes no objeto Drop são combinadas com ações existentes no objeto
               Drag

Informações e ações estão atreladas a um DataType, isto é, a uma cadeia de caracteres que define o
tipo de dados que é arrastado.
DataTypes padrões do Firecast

O programador pode inventar qualquer DataType, porém existem os seguintes que são padrões do

Firecast:

DataType padrão                     Valor transportado

text                                Uma cadeia de caracteres, um texto qualquer.

imageURL                            Uma cadeia de caracteres que contém uma URL de
                                    uma imagem.

player                              Um objeto Jogador

players                             Array de objeto Jogador

character                           Um objeto Personagem

characters                          Array de objeto Personagem

libraryItem                         Um objeto BibliotecaItem

libraryItens                        Array de objeto BibliotecaItem

sceneUnitClass                      Um objeto SceneUnitClass

sceneUnitClasses                    Array de objeto SceneUnitClass

imageFile                           A table containing the following attributes:

                                                  ●          name - String with the name

                                    of the file.

                                                  ●          mimeType - String with the

                                    MIME type of the image (examples:

                                    image/jpeg, image/png)

                                                  ●          stream - A read-only Stream

                                    object containing the image file bytes.

imageFiles                          An array of tables with the same structure as the

                                    "imageFile".

Observação: Ao utilizar os dataTypes padrões, o RRPG valida e exige que sejam transportados valores

adequados conforme a tabela acima.

Exemplos

Exemplo 1 - Arrastando um texto de um Label

Experimente arrastar o label para a caixa de digitação de mensagens e comandos do RRPG.

                     <label text="Me arraste!" top="150" hitTest="true">
                            <event name="OnStartDrag">
                                    drag:addData("text", "Texto que será arrastado deste

            label!");
                            </event>

                     </label>
Exemplo 2 - Arrastando uma imagem e um texto de um Label

Experimente arrastar o label para o log do chat do RRPG!

                     <label text="Me arraste!" top="150" hitTest="true">
                            <event name="OnStartDrag">
                                    drag:addData("text", "Texto que será arrastado deste

            label!");
                                    drag:addData("imageURL", "http://www.rrpg.com.br/wp-

            content/uploads/2013/05/cropped-Untitled-2.png");
                            </event>

                     </label>

Exemplo 3 - Um controle que captura arraste de imagens.

Arraste uma imagem do browser Chrome ou do jogador para este controle.

                   <rectangle left="150" top="150"
                                       width="150" height="150"
                                       strokeColor="yellow" strokeSize="1"
                                       color="none">

                          <image name="imgImagem" align="client" hitTest="true">
                                 <event name="OnStartDrop">
                                         drop:addAction("imageURL",
                                                function(value)
                                                       self.imgImagem.src = value;
                                                end);
                                 </event>

                          </image>

                   </rectangle>

Exemplo 4 - Um controle que captura arraste de Jogadores.

Arraste um jogador da mesa para este controle!

                     <rectangle left="150" top="150"
                                         width="150" height="150"
                                         strokeColor="yellow" strokeSize="1"
                                         color="none"
                                         hitTest="true">

                            <event name="OnStartDrop">
                                    drop:addAction("player",
                                           function(value)
                                                  showMessage("O login deste jogador é: " ..

            value.login);
                                           end);

                            </event>
                     </rectangle>

Exemplo 5 - Arrastando uma ação à partir de um botão

Arraste este botão para um jogador da mesa!
             <button left="150" top="150" text="meArraste">
                    <event name="OnStartDrag">
                            drag:addAction("player",
                                   function(destValue)
                                          showMessage("Você me arrastou para o jogador: "

    .. destValue.login);
                                   end);

                    </event>
             </button>
```
