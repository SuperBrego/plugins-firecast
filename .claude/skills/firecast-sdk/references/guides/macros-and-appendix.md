# Macros, linguagem Lua, XML, FAQ

> Extraído de `docs/Firecast_SDK_-_Single formatado.pdf` (texto automático; tabelas podem ter colunas desalinhadas). 

```text
Macros em Lua

  As macros em Lua possuem um conjunto de funções utilitárias pré-definidas para serem utilizadas!
  Conheça as funções disponíveis para as macros em lua.
  Exemplo 1: Fazendo um teste com dificuldade igual a 15

        local resultado = rolar("1d20 +
        5");

        if resultado >= 15 then
else  enviar("Acertou!");
end;  enviar("Errou!");

Biblioteca para Macros em Lua

Variáveis

    variável parametro ou variável parameter
    e
    variável arg[indice]

       (Não é uma função) Possui os parâmetros passado para a macro, onde a variável "parametro"
       contém a cadeia de caracteres completa e a variável "arg" contém um arranjo, onde cada item
       representa um argumento separado por espaço.
       Se o usuário digitar "/minhaMacro Texto de Teste":

                                 ○ A variável "parametro" conterá "Texto de Teste"
                                 ○ A variável arg[1] conterá "Texto", arg[2] conterá "de", arg[3] conterá

                                      "Teste" e #arg contém a quantidade de argumentos.
       Exemplo: Fazer um teste de resistência parametrizado.

          local dificuldade = tonumber(parametro);

          if dificuldade == nil then
                escrever("Utilize: /macro <NÚMERO>");
                return;

          end;

          local resultado = rolar("1d20 + 5", "Dificuldade " ..
          dificuldade);

          if resultado >= dificuldade then
              enviar("Passou no teste!");

          else
         enviar("Não passou no teste");
      end;

variável chat

   (Não é uma função) Objeto Chat representando o chat em que a macro foi disparada.

variable elapsedMS

   (Not a function) Contains how many milliseconds have passed since the macro started
   executing

variável meuJogador ou variável myPlayer

   (Não é uma função) objeto Jogador representando o usuário da macro naquela mesa.
   Exemplo 1: Escrever na tela o seu próprio login.

          escrever(meuJogador.login
          );

variável myCharacter

   (Não é uma função) Objeto Personagem representando o personagem principal do usuário
   naquela mesa.
   Observações:

                             ○ Se o jogador não possuir nenhum personagem, acessar esta variável irá
                                  causar um erro com uma mensagem informativa de que "o jogador não
                                  possui nenhum personagem" e a macro pára de executar.

   Exemplo 1: Escrever na tela o nome do seu personagem.

          write(myCharacter.nome)

variável sheet
   (Não é uma função) O Objeto Nodo raiz representando o NodeDatabase/Sheet do personagem
   principal do usuário logado.
   Observações:

                             ○ Se o jogador não possuir nenhum personagem, acessar esta variável irá
                                  causar um erro com uma mensagem informativa de que "o jogador não
                                  possui nenhum personagem" e a macro pára de executar.

                             ○ A execução da macro pode ser pausada até que o NodeDatabase/Ficha
                                  seja carregada pela internet.

                             ○ O Objeto Nodo retornado é o mesmo daquela variável "sheet" usada
                                  para programar as fichas/lua forms.

                             ○ As alterações feitas no objeto nodo retornado são sincronizadas
                                  normalmente, confome as regras de permissões do Node Database.

                             ○ Se houver algum erro ao carregar o NodeDatabase, a macro pára de
                                  executar.

   Exemplo:

            -- Escrever no chat a estrutura dos dados armazenados da
            ficha
            write(utils.tableToStr(sheet, true));

            -- Se for a ficha D&D 5, a linha abaixo aumenta a CA em 1
            sheet.CA = (tonumber(sheet.CA) or 0) + 1;

            -- Se for a ficha D&D 5, a linha abaixo esreve no chat
            Quantos PV o personagem tem
            write(sheet.PV)

variável mesa ou variável room

   (Não é uma função) objeto Mesa representando a mesa em que a macro está sendo executada.
   Exemplo 1: Escrever algumas informações da mesa na tela.

          escrever(mesa.nome);
          escrever(mesa.sistema);
          escrever(mesa.msgStatus);

variável jogadores ou variável players
       (Não é uma função) Arranjo de objeto Jogador, representando os usuários que estão na mesa
       no momento.
       Forma de uso: jogadores[1] contém o primeiro jogador, jogadores[2] contém o segundo jogador,
       jogadores[3] contém o terceiro, jogadores[#jogadores] possui o último jogador.
       Exemplo 1: Escrever na tela o login de todos os jogadores da mesa.

              for i = 1, #jogadores, 1
              do

              escrever(jogadores[i].log
              in);
              end;

       Exemplo 2: Dar +voz para todos os espectadores da mesa.

                for i = 1, #jogadores, 1 do
                    if

                jogadores[i].isEspectador
                then

                jogadores[i]:requestSetVoz(
                true);

                    end;
                end;

    variável inRoom

       (Não é uma função) Booleano (true ou false) indicando se a macro está sendo executada em
       algum chat associado a alguma mesa.

Funções

    function await(promise)

       Pauses the macro execution until a Promise object is resolved
Arguments:  ○ promise - The Promise object to wait for.
Return:
Remarks:    ○ The resolved value of the Promise

            ○ If the Promise is resolved with an error, an error will be raised with the
                 corresponding error message.

function enviar(text[, params])
ou
function send(text[, params])

Sends a standard message to the chat.
Arguments:

                         ○ text - A string containing the standard message to be sent.
                         ○ (Optional) params - A SendMessageParameters table containing

                               optional settings for the message.
Return:

                         ○ A LogRec table describing the sent message.
Examples:

      send("Hello!");
      send("Hello!", {impersonation = {mode="character",
      name="Turok"}});
      send("Hello!", {impersonation = {mode="narrator"}});

function agir(text[, params])
ou
function act(text[, params])

   Sends an action message to the chat.
   Arguments:

                             ○ text - A string containing the action message to be sent.
Return:    ○ (Optional) params - A SendMessageParameters table containing
Examples:       optional settings for the message.

           ○ A LogRec table describing the sent message.

act("wields his long sword");
act("wields his long sword", {impersonation =
{mode="character", name="Turok"}});
act("wields his long sword", {impersonation =
{mode="narrator"}});

function narrar(narracao)
ou
function narrate(narracao)

   Envia uma mensagem de narração para o chat.
   Parâmetros:

                             ○ narracao - Cadeia de caracteres contendo a narração que deseja enviar.
   Observação: Apenas o mestre consegue enviar mensagens de narração.
   Exemplo:

          narrar("Após uma péssima noite de descanso, Gruumsh
          acorda com as mãos algemadas");

function enviarNPC(npc, mensagem)
ou
function sendNPC(npc, mensagem)

   Envia uma mensagem para o chat como se um NPC estivesse falando
   Parâmetros:

                             ○ npc - Cadeia de caracteres contendo o nome do NPC.
                             ○ mensagem - Cadeia de caracteres contendo a mensagem que deseja
                                  enviar.

   Observação: Apenas o mestre consegue enviar mensagens como NPC.
   Exemplo:

          enviarNPC("Rei Darik", "Guardas, prendam estes
          infelizes!");

function rolar(expression[, message[, params]])
ou
function roll(expression[, message[, params]])

   Executes a dice roll in the chat.
   Arguments:

                             ○ expression - A string containing the expression of the roll, such as
                                  "1d20 + 5," or a Roll Object.

                             ○ (Optional) message - A string containing an additional message
                                  describing the roll.

                             ○ (Optional) params - A SendMessageParameters table containing
                                  optional settings for the message.

   Return:
                             ○ This function returns 3 pieces of information in the following order:
                                                  ■ A number containing the roll result
                                                  ■ A Roll Object describing the roll result.
                                                  ■ A LogRec table describing the sent message.

   Example 1:

    local r = roll("1d20 + 5");

    if r >= 15 then
                  send("Hit!");

    else
                  send("Miss!");

    end;

   Example 2:
local r = roll("1d20 + 5", "Attack", {impersonation =
{mode="character", name="Turok"}});

if r >= 15 then
              roll("1d8 + 5", "Damage", {impersonation = {mode="character",

name="Turok"}});
end;

Exemplo 3: Rolar 4d6 e selecionar os 3 maiores números da rolagem.

local resultado, rolagem = roll("4d6");
local dados = {};

-- coletar os resultados individuais de cada dado
for i = 1, #rolagem.ops, 1 do

              local op = rolagem.ops[i];

      if op.tipo == "dado" then
                    for j = 1, #op.resultados, 1 do
                                   dados[#dados + 1] = op.resultados[j];
                    end;

      end;

end;

-- Ordenar os resultados, menores primeiro
table.sort(dados);

local texto = "";

-- Pegar os ultimos 3, isto é, os 3 maiores.. de traz para frente

for i = #dados, #dados - 2, -1 do
                             texto = texto .. " " .. dados[i];

end;

enviar("Os 3 maiores números foram:" .. texto);

function rolarLocal(rolagem)
ou
function rollLocal(rolagem)

   Executa uma rolagem de dados local, isto é, uma rolagem que não será exibida em lugar
   nenhum.
   Parâmetros:

                             ○ rolagem - Cadeia de caracteres contendo a rolagem a ser feita.
                                  Exemplo: "1d20 + 5"

   Retorno:
                             ○ Esta função retorna um número contendo o resultado e um objeto
                                  rolagem com informações detalhadas do resultado.

   Exemplos:
       O comportamento da função "rolarLocal" é igual a da função "rolar", portanto, consulte os

   exemplos de "rolar".

function esperar(milisegundos)
ou
function wait(milisegundos)

   Realiza uma pausa cronometrada na execução da Macro.
   Parâmetros:

                             ○ milisegundos - Um número em milisegundos representando o intervalo
                                  de tempo que a execução da Macro ficará pausada. 1000 = 1 segundo,
                                  500 = 0,5 segundos.

function load(luaCode)

   Interpreta um código de macro escrita na linguagem LUA
   Parâmetros:

                             ○ luaCode - Cadeia de caracteres contendo um código na linguagem LUA
                                  (seguindo o mesmo padrão de uma macro).

   Retorno:
                             ○ Se luaCode possui um código Lua válido, retorna uma função que
                                  poderá ser invocada
                             ○ Se lucaCode não possui um código Lua válido, retorna dois valores: nil e
                                  uma mensagem de erro.
Exemplo:

              local func, errorMsg = load("write(1 + 5 + 9 + 10)");

              if func ~= nil then
                 -- O codigo foi carregado. Vamos invocá-lo agora
                 func();

              else
                 write("could not load lua code: " .. errorMsg);

              end

function Log.e(tag, msg)
function Log.w(tag, msg)
function Log.i(tag, msg)
function Log.d(tag, msg)
function Log.v(tag, msg)

Emmit log message to the Firecast's log file and to the Firecast's console window. Use the
/console command to reveal the console

Arguments:

                         ○ tag - Used to identify the source of a log message. It usually identifies
                               the location or activity where the log call occurs.

                         ○ msg - The message you would like to be logged

Log severity:

Log.  Error message

e     A situation that represents an unhandled error that may interrupt

      some operation

Log.  Warning message

w     A situation that can be handled but may cause some unintended

      behavior

Log.  Informational/Notice message

i     A normal but significant condition that may require special handling.
Log.  Debug message

d     A developer debug message

Log.  Verbose message

v     Algorithm steps message, very low priority messages.

      Remarks:

      ● Messages of this severity are not emitted in the
           Firecast’s log files

      ● In the Firecast’s console, you need to execute the
           command “filter add *” to be able to see these messages.

function showMessage(msg)

   Exibe uma janela para o usuário contendo uma mensagem.
   Parâmetros:

                             ○ msg - Cadeia de caracteres contendo a mensagem que deverá ser
                                  exibida para o usuário.

   Observação:
                             ○ A execução da macro é pausada até que o usuário pressione OK na
                                  janela.

function alert(msg)

   Exibe uma janela para o usuário contendo uma mensagem de alerta.
   Parâmetros:

                             ○ msg - Cadeia de caracteres contendo a mensagem que deverá ser
                                  exibida para o usuário.

   Observação:
                             ○ A execução da macro é pausada até que o usuário pressione OK na
                                  janela.

function toast(message)
   Show a quick informative message to the user that does not require user interaction and hides
   automatically after a short time
   Parameters

                             ○ message - The message string to be shown

function confirmOkCancel(question)

   Exibe uma janela para o usuário onde ele deve escolher responder ou "Ok" ou "Cancelar"
   Parâmetros:

                             ○ question - Cadeia de caracteres contendo a mensagem que deverá ser
                                  exibida para o usuário.

   Retorno:
                             ○ true se o usuário responder "Ok" ou false se o usuário responder
                                  "Cancelar"

   Observação:
                             ○ A execução da macro é pausada até que o usuário responda a janela.

   Exemplo:

            if confirmOkCancel("Será adicionado 6 à rolagem") then
               write("O usuario respondeu OK");

            else
               write("O usuario respondeu Cancelar");

            end

function confirmYesNo(question)

   Exibe uma janela para o usuário onde ele deve escolher responder ou "Sim" ou "Não"
   Parâmetros:

                             ○ question - Cadeia de caracteres contendo a pergunta que deverá ser
                                  exibida para o usuário.

   Retorno:
                             ○ true se o usuário responder "Sim" ou false se o usuário responder "Não"

   Observação:
                             ○ A execução da macro é pausada até que o usuário responda a janela.
   Exemplo:

            if confirmYesNo("Deseja continuar?") then
               write("O usuario respondeu Sim");

            else
               write("O usuario respondeu Não");

            end

function inputQuery(prompt[, initialValue, allowEmptyString])

   Exibe uma janela para o usuário onde ele deve digitar um valor.
   Parâmetros:

                             ○ prompt - Cadeia de caracteres orientando o usuário o que ele deve
                                  preencher.

                             ○ (OPCIONAL) initialValue - Cadeia de caracteres contendo uma
                                  sugestão de valor inicial para o usuário.

                             ○ (OPCIONAL) allowEmptyString - true se o usuário pode informar um
                                  texto em branco. O padrão é false.

   Retorno:
                             ○ Se o usuário confirmar o valor, esta função retorna o valor escrito pelo
                                  usuário
                             ○ Se o usuário escolher cancelar na janela exibida, a macro pára de
                                  executar.

   Observação:
                             ○ A execução da macro é pausada até que o usuário responda a janela.

   Exemplo:

            local bonus = inputQuery("Bônus de Ataque");
            local defesa = inputQuery("Defesa", "10");

            if roll("1d20 + " .. bonus) >= tonumber(defesa) then
               write("Acertou");

            else
               write("Errou");

            end;
function selectImageURL([defaultURL])

   Esta função exibe uma janela para o usuário escolher uma URL de uma imagem.
   Parâmetros:

                             ○ (OPCIONAL) defaultURL - Texto contendo uma URL sugerida para o
                                  usuário

   Retorno:
                             ○ Retorna a URL de uma imagem escolhida pelo usuário

   Observação:
                             ○ A execução da macro é pausada até que o usuário responda a janela.
                             ○ Se o usuário cancelar a janela, a macro pára de executar.

   Exemplo:

            local url =
            selectImageURL();
            write("Imagem escolhida: "
            .. url);

function choose(prompt, options, [defaultOptionIndex, shortCircuit])

   Exibe um diálogo para que o usuário possa escolher uma opção dentre uma lista de opções.
   Parâmetros

                             ○ prompt - Uma cadeia de caracteres contendo uma orientação ao
                                  usuário sobre o que ele deve selecionar.

                             ○ options - Um array/arranjo/lista de cadeias de caracteres/textos,
                                  contendo as opções que devem ser apresentadas ao usuário.

                             ○ (OPCIONAL) defaultOptionIndex - Um número contendo um índice
                                  informado qual dos itens de "options" deve ser apresentado como a
                                  escolha padrão. Se não informado, nenhuma opção será mostrada como
                                  padrão.

                             ○ (OPCIONAL) shortCircuit - Avaliação Curto-Circuito: Se for "true" e se
                                  houver apenas uma opção a ser mostrada ao usuario, a interface não é
                                  exibida e esta opçao é automaticamente selecionada. Se não informado,
                                  este parâmetro assume o valor false.

   Retorno:
       Esta função retorna dois valores na seguinte ordem:
Observações:                      ■ index - Um número, o índice de "options" que foi
Exemplo:                               escolhido pelo usuário

                                  ■ text - O texto equivalente ao índice escolhido pelo
                                       usuário, conforme "options"

              ○ A execução da macro é pausada até que o usuário responda a janela.
              ○ Se o usuário cancelar a janela, a macro pára de executar.
              ○ Lembre-se que indices de arrays em lua começa do número 1 ao invés

                   de 0
              ○ Se "options" não for válido ou se for um arranjo com 0 itens, a macro

                   pára de executar como se o usuário tivesse cancelado a janela.

local indice, texto = choose("O que deseja fazer?",
{"Atacar", "Defender"}, 1);

escrever("O usuário escolheu o índice: " .. indice);
escrever("O usuário escolheu: " .. texto);

function chooseMultiple(prompt, options)

   Exibe um diálogo para que o usuário possa escolher uma ou mais opções dentre uma lista de
   opções.

   Parâmetros

                             ○ prompt - Uma cadeia de caracteres contendo uma orientação ao
                                  usuário sobre o que ele deve selecionar.

                             ○ options - Um array/lista/arranjo de textos/cadeias de caracteres,
                                  contendo as opções que devem ser apresentadas ao usuário.

   Retorno:

              Esta função retorna dois valores na seguinte ordem:

                                                  ■ indexes - Um array/arranjo/lista de números, contendo
                                                       os índices de "options" que foram escolhidos pelo
                                                       usuário

                                                  ■ texts - Um array/arranjo/lista de textos equivalentes
                                                       aos índices escolhidos pelo usuário, conforme "options"

   Observação:

                             ○ A execução da macro é pausada até que o usuário responda a janela.
                             ○ Se o usuário cancelar a janela, a macro pára de executar.
                             ○ Lembre-se que indices de arrays em lua começa do número 1 ao invés

                                  de 0
          ○ Se "options" não for válido ou se for um arranjo com 0 itens, a macro
               pára de executar como se o usuário tivesse cancelado a janela.

Exemplo:

local indices, textos = chooseMultiple("Bônus ativos",
{"Cobertura", "Defesa Total", "Escondido"});

for i = 1, #indices, 1 do
     escrever("O usuário escolheu o índice: " .. indices[i]);
     escrever("O usuário escolheu: " .. textos[i]);

end;

function chooseCharacter(prompt[, filter, shortCircuit])

   Exibe um diálogo para que o usuário possa escolher um personagem da lista de personagens
   que estão na biblioteca da mesa.

   Parâmetros

                             ○ prompt - Uma cadeia de caracteres contendo uma orientação ao
                                  usuário sobre o que ele deve selecionar.

                             ○ (OPCIONAL) filter - Uma cadeia de caracteres informando quais
                                  persnagens devem ser apresentados na interface de seleção e pode ser
                                  um dos seguintes valores:
                                                  ■ "all" - Todos os personagens da mesa deverão ser
                                                       apresentados na janela (Opção padrão caso não seja
                                                       informado filter)
                                                  ■ "pc" - Apenas os personagens de jogadores deverão ser
                                                       apresentados na janela.
                                                  ■ "pcOnline" - Apenas os personagens de jogadores que
                                                       estão online deverão ser apresentados na janela.
                                                  ■ "npc" - Apenas os personagens do mestre deverão ser
                                                       apresentados.
                                                  ■ "mine" - Apenas os personagens do jogador que
                                                       executar a macro deverão ser apresentados.

                             ○ (OPCIONAL) shortCircuit - Avaliação Curto-Circuito: Se for "true" e se
                                  houver apenas um personagem a ser mostrado ao usuario, a interface
                                  não é exibida e este personagem é automaticamente selecionado. Se
                                  não informado, este parâmetro assume o valor false .

   Retorno:

                             ○ Um Objeto Personagem representando o personagem que o usuário
                                  escolheu.

   Observações:
          ○ A execução da macro é pausada até que o usuário responda a janela.
          ○ Se o usuário cancelar a janela, a macro pára de executar.
          ○ Se o filtro especificado por "filter" não for capaz de apresentar nenhum

               personagem para escolha, um erro será exibido para o usuário.

Exemplo:

local personagem = chooseCharacter("Qual personagem deseja
testar a força?", "pc");

escrever("Você selecionou: " .. personagem.nome);

function chooseCharacterOfPlayer(prompt, player [, shortCircuit])

   Exibe um diálogo para que o usuário possa escolher um personagens da lista de personagens de
   um jogador na mesa.
   Parâmetros

                             ○ prompt - Uma cadeia de caracteres contendo uma orientação ao
                                  usuário sobre o que ele deve selecionar.

                             ○ player - Uma cadeia de caracteres contendo o login do usuário ou um
                                  Objeto Jogador representando de qual jogador os personagens
                                  deverão ser apresentados na tela.

                             ○ (OPCIONAL) shortCircuit - Avaliação Curto-Circuito: Se for "true" e se
                                  houver apenas um personagem a ser mostrado ao usuario, a interface
                                  não é exibida e este personagem é automaticamente selecionado. Se
                                  não informado, este parâmetro assume o valor false .

   Retorno:
                             ○ Um Objeto Personagem representando o personagem que o usuário
                                  escolheu.

   Observações:
                             ○ A execução da macro é pausada até que o usuário responda a janela.
                             ○ Se o usuário cancelar a janela, a macro pára de executar.
                             ○ Se o jogador não possuir nenhum personagem, um erro é lançado.

   Exemplo:

            local player = choosePlayer("Selecione um jogador");

            local personagem = chooseCharacterOfPlayer("Selecione um
            personagem", player);
            escrever(personagem.nome);

            local personagem2 = chooseCharacterOfPlayer("Selecione um
            personagem", "AlyssonRPG");

            escrever(personagem2.nome);

function chooseCharacters(prompt[, filter])

   Exibe um diálogo para que o usuário possa escolher um ou mais personagens da lista de
   personagens que estão na biblioteca da mesa.

   Parâmetros

                             ○ prompt - Uma cadeia de caracteres contendo uma orientação ao
                                  usuário sobre o que ele deve selecionar.

                             ○ (OPCIONAL) filter - Uma cadeia de caracteres informando quais
                                  persnagens devem ser apresentados na interface de seleção e pode ser
                                  um dos seguintes valores:
                                                  ■ "all" - Todos os personagens da mesa deverão ser
                                                       apresentados na janela (Opção padrão caso não seja
                                                       informado filter)
                                                  ■ "pc" - Apenas os personagens de jogadores deverão ser
                                                       apresentados na janela.
                                                  ■ "pcOnline" - Apenas os personagens de jogadores que
                                                       estão online deverão ser apresentados na janela.
                                                  ■ "npc" - Apenas os personagens do mestre deverão ser
                                                       apresentados.
                                                  ■ "mine" - Apenas os personagens do jogador que
                                                       executar a macro deverão ser apresentados.

   Retorno:

                             ○ Um array/arranjo/lista de Objeto Personagem representando os
                                  personagens que o usuário escolheu.

   Observações:

                             ○ A execução da macro é pausada até que o usuário responda a janela.
                             ○ Se o usuário cancelar a janela, a macro pára de executar.
                             ○ Se o filtro especificado por "filter" não for capaz de apresentar nenhum

                                  personagem para escolha, um erro será exibido para o usuário.

   Exemplo:

            local personagens = chooseCharacters("Quais personagens
            deseja testar a força?", "pcOnline");

            for i = 1, #personagens, 1 do

               escrever("Você selecionou: " .. personagens[i].nome);

            end;
function choosePlayer(prompt[, shortCircuit])

   Exibe um diálogo para que o usuário possa escolher um jogador da lista de jogadores que estão
   na mesa.
   Parâmetros

                             ○ prompt - Uma cadeia de caracteres contendo uma orientação ao
                                  usuário sobre o que ele deve selecionar.

                             ○ (OPCIONAL) shortCircuit - Avaliação Curto-Circuito: Se for "true" e se
                                  houver apenas um jogador a ser mostrado ao usuario, a interface não é
                                  exibida e este jogador é automaticamente selecionado. Se não
                                  informado, este parâmetro assume o valor false .

   Retorno:
                             ○ Um Objeto Jogador representando o jogador que o usuário escolheu.

   Observações:
                             ○ A execução da macro é pausada até que o usuário responda a janela.
                             ○ Se o usuário cancelar a janela, a macro pára de executar.

   Exemplo:

            local jogador = choosePlayer("De qual jogador voce quer
            obter informações?")
            escrever("Você selecionou: " .. jogador.login);

            if jogador.isMestre then
                 escrever("O jogador é mestre na mesa");

            end;

function choosePlayers(prompt)

   Exibe um diálogo para que o usuário possa escolher um ou mais jogadores da lista de jogadores
   que estão na mesa.
   Parâmetros

                             ○ prompt - Uma cadeia de caracteres contendo uma orientação ao
                                  usuário sobre o que ele deve selecionar.

   Retorno:
Observações:  ○ Um array/lista de Objeto Jogador representando os jogadores que o
Exemplo:           usuário escolheu.

              ○ A execução da macro é pausada até que o usuário responda a janela.
              ○ Se o usuário cancelar a janela, a macro pára de executar.

local jogadores = choosePlayers("Selecione quais jogadores
devem rolar iniciativa");

for i = 1, #jogadores, 1 do
     escrever("Rolar iniciativa de " .. jogadores[i].login);

end;

function getCharacterOfPlayer(player)

   Retorna o personagem principal de um jogador da mesa.
   Parâmetros

                             ○ player - Uma cadeia de caracteres contendo o login do usuário ou um
                                  Objeto Jogador representando de qual jogador se deve obter o
                                  personagem principal.

   Retorno:
                             ○ Um Objeto Personagem representando o personagem principal do
                                  jogador.

   Observações:
                             ○ A execução da macro é pausada até que o usuário responda a janela.
                             ○ Se o usuário cancelar a janela, a macro pára de executar.
                             ○ Se o jogador não possuir nenhum personagem, um erro é lançado.
                             ○ Se o jogador possuir dois ou mais personagens, o personagem principal
                                  dele será retornado.

   Exemplo:

            local player = choosePlayer("Escolha um jogador");

            local personagemPrincipal = getCharacterOfPlayer(player);
            escrever(personagemPrincipal.nome);
function getCharacterSheet(character)

   Retorna o Node Database/sheet de um personagem.
   Parâmetros

                             ○ character - Um Objeto Personagem representando o personagem de
                                  qual se deve obter o NodeDatabase/sheet

   Retorno:
                             ○ O Objeto Nodo raiz representando o NodeDatabase/Sheet do
                                  personagem

   Observações:
                             ○ A execução da macro pode ser pausada até que o NodeDatabase/Ficha
                                  seja carregada pela internet.
                             ○ O Objeto Nodo retornado é o mesmo daquela variável "sheet" usada
                                  para programar as fichas/lua forms.
                             ○ As alterações feitas no objeto nodo retornado são sincronizadas
                                  normalmente, confome as regras de permissões do Node Database.
                             ○ Se houver algum erro ao carregar o NodeDatabase, a macro pára de
                                  executar.

   Exemplo:

            local personagem = chooseCharacter("Escolha um personagem",
            "pc")
            local node = getCharacterSheet(personagem);

            -- Escrever no chat a estrutura dos dados armazenados da
            ficha
            write(utils.tableToStr(node, true));

            -- Se for a ficha D&D 5, a linha abaixo aumenta a CA em 1
            node.CA = (tonumber(node.CA) or 0) + 1;

function getUserNDB(name[, options])

   Open a per-user NodeDatabase that is physically stored in the Firecast server.
   Arguments:

                             ○ name - A string identifying which remote user NodeDatabase should be
                                  opened
Return:   ○ (OPTIONAL) options - A Lua table describing additional settings that
Remarks:       may contain:
                              ■ create - a boolean. If true, the NodeDatabase can be
                                   created if it does not exist. Default: false

          ○ Node Object

          ○ The content of NodeDatabases opened by this function is stored
               separately per-user. Each user will have their own copy of the
               NodeDatabase identified by the “name” argument

function getUserRoomNDB(name[, options])

   Open a per user NodeDatabase in the current room that is physically stored in the Firecast
   server.

   Arguments:

                             ○ name - A string identifying which remote user NodeDatabase in the
                                  current room should be opened

                             ○ (OPTIONAL) options - A Lua table describing additional settings that
                                  may contain:
                                                  ■ create - a boolean. If true, the NodeDatabase can be
                                                       created if it does not exist. Default: false

   Return:

                             ○ Node Object

   Remarks:

                             ○ The content of NodeDatabases opened by this function is stored
                                  separately per-user and per-room. Each user in the current room will
                                  have their own copy of the NodeDatabase identified by the “name”.

function getRoomNDB(name[, options])

Open a per room NodeDatabase that is physically stored in the Firecast server.

Arguments:

                         ○ name - A string identifying which remote NodeDatabase of the current
                               room should be opened

                         ○ (OPTIONAL) options - A Lua table describing additional settings that
                               may contain:
                                              ■ create - a boolean. If true, the NodeDatabase can be
                                                   created if it does not exist. Default: false
Return:   ○ Node Object
Remarks:
          ○ The content of NodeDatabases opened by this function is stored
               separately per-room. All users of the current room will access the same
               content of the NodeDatabase identified by the “name”.

          ○ By default, users with the +GM mode can read and modify the
               NodeDatabase of the room while other users can only read values.

          ○ To open a NodeDatabase of the room, one of the following statements
               must be true:
                              ■ The current user is a Gold subscriber; or
                              ■ The creator of the room is a Platinum subscriber.

function invoke(macroName [, parameter])

Esta função invoca outra macro e aguarda sua execução.

Parâmetros:

                         ○ macroName - Cadeia de caracteres identificando qual macro deve ser
                               invocada.
                                              ■ Exemplo: Se deseja invocar a macro
                                                   /obterBonusAtaque, o valor "obterBonusAtaque"
                                                   deverá se passado aqui, sem a barra.

                         ○ (OPCIONAL) parameter - Cadeia de caracteres contendo os
                               parâmetros que devem ser passados para a macro quando ela for
                               invocada.

Retorno:

                         ○ Se a macro invocada tiver sido executada sem erros, o retorno desta
                               função é idêntico ao "return" da macro invocada (nil se ela não
                               especificou valor de return).

Observação:

                         ○ A execução desta macro é pausada até a outra macro seja executada.
                         ○ Se a macro invocada parar de executar (exemplo: Pois o usuário

                               cancelou um inputQuery), esta macro também pára de executar.

Exemplo (duas macros, uma invocando a outra):

    Macro: ObterBonusAtaque

              local attack = inputQuery("Informe o Bônus de
              Ataque");

              local damageBonus = inputQuery("Informe o Bônus
              de Dano");
                  return attack, tonumber(damageBonus);

         Macro que invoca outra macro

                  local bonusAttack, damage =
                  invoke("ObterBonusAtaque")

                  write("Ataque informado: " .. bonusAttack)
                  write("Dano informado: " .. damage);

function playLocal(address[, volume])

   Plays an audio file using the user's default audio device.
   Arguments:

                             ○ address - A string containing the external URL of the audio. Example:
                                  "https://www.domain.com/my/audioFile.mp3"

                             ○ (Optional) volume - A number representing the volume at which the
                                  audio should be played. This number functions as a multiplication
                                  factor, where 0.0 means total silence, and 2.0 means double the original
                                  audio volume. The default value is 1.0.

   Return:
                             ○ AudioTrack object representing the audio playback

   Remarks:
                             ○ This function will play the audio from start to end only once.
                             ○ This function plays audio to the user only. If you want to transmit it to
                                  other players, consider using the playRoom function.

function playRoom(address[, volume])

   Plays an audio file to all players in the room.
   Arguments:

                             ○ address - A string containing the external URL of the audio. Example:
                                  "https://www.domain.com/my/audioFile.mp3"

                             ○ (Optional) volume - A number representing the volume at which the
                                  audio should be played. This number functions as a multiplication
                                  factor, where 0.0 means total silence, and 2.0 means double the original
                                  audio volume. The default value is 1.0.

   Return:
Remarks:  ○ AudioTrack object representing the audio playback

          ○ This function will play the audio from start to end only once.
          ○ This function transmits audio to everyone in the room. If you want to

               play only to the local user, consider using the playLocal function.

function waitMessage(timeoutMS)

Waits for the next message received in the current chat.
Arguments:

                         ○ timeoutMS - The duration, in milliseconds, for which the function will
                               wait for a message. This value should be greater than 0.

The function returns two values:
                         ○ A boolean indicating if a message has been received within the specified
                               timeout.
                         ○ A LogRec table containing details of the received message.This value is
                               valid only if the first return value is true.

Example 1:

       local success, logRec = waitMessage(30000);

       if success then
             write("Message received from " .. logRec.entity.login);

       else
             write("No message received in time");

       end;

Example 2 - Waiting for a roll:

       TIMEOUT = 60000;

       while elapsedMS < TIMEOUT do
               local received, logRec = waitMessage(TIMEOUT -

       elapsedMS);

               if received and (logRec.msg.msgType == "dice") then
                      write(string.format("%s rolled and the result is %d",
                                                               logRec.entity.login,
                                                               logRec.msg.roll.resultado));

                          return;
                   end;
            end;

            write("No roll in time");

function write(texto[, quebrarLinha, permitirSmileys])
ou
function escrever(texto[, quebrarLinha, permitirSmileys])

   Escreve um texto na tela do chat. Este texto não é enviado para ninguém e aparecerá somente
   no chat do próprio usuário.
   Parâmetros:

                             ○ texto - Cadeia de caracteres contendo o texto que deseja escrever.
                             ○ (OPCIONAL) quebrarLinha - Booleano. O Firecast8 ignora este

                                  parâmetro.
                             ○ (OPCIONAL) permitirSmileys - Booleano (true ou false) indicando se o

                                  Firecast deve interpretar smileys/memes neste texto. Se omitido, o
                                  valor padrão true é assumido.
   Exemplo:

          escrever("Olá
          mundo!!!");

function writeEx(text[, talemarkOptions])

   Write/print a text in the chat. The text is not sent; only the local user can see the text.
   Arguments:

                             ○ text - A string containing the text to be printed.
                             ○ (Optional) talemarkOptions - A TalemarkOptions table containing how

                                  Firecast should color and format the text. If missing, Firecast will use a
                                  default TalemarkOptions.
Examples:

      writeEx("Hello World!");
      writeEx("Hello World!", {defaultTextStyle = {color = "red"}});
APÊNDICE

A linguagem de programação LUA

       LUA é uma linguagem de programação interpretada/script poderosa, rápida e leve, projetada
       por brasileiros para estender aplicações e é usada vastamente pelo mundo (inclusive em
       projetos famosos como o jogo World of Warcraft, por exemplo).
       A versão utilizada da linguagem LUA no SDK 3 é a 5.3
       Segue abaixo uma lista de links úteis para o aprendizado da linguagem LUA:

                           ● Site oficial da linguagem LUA: http://www.lua.org/
                           ● Manual de referência da linguagem: http://www.lua.org/manual/5.3/
                           ● LUA na Wikipedia: http://pt.wikipedia.org/wiki/Lua_

                                 %28linguagem_de_programa%C3%A7%C3%A3o%29
                           ● Livros sobre Lua: http://www.lua.org/pil/
       Observação importante:
      Visando a proteção dos usuários contra plug-ins maliciosos, os códigos LUA rodam em uma
  sandbox e nem todas as funções nativas do LUA estão disponíveis para o plug-in SDK 3.
      Saiba mais sobre sandboxes e sobre as funções nativas LUA disponíveis lendo o tópico:
  Sandboxes de Plug-ins

Veja também:

           O SDK3 já provê algumas bibliotecas e funções LUA para você utilizar em seus plug-ins!
       Saiba mais em Bibliotecas LUA.

Documentos XML

       XML são documentos usados para guardar e catalogar informações de forma intuitiva e flexível,
       e servem para diversas finalidades!
       Importante: Os documentos XMLs possuem “um rosto” diferente para cada finalidade.
       Exemplo: Enquanto um XML de interface possui um conjunto de informações e marcações
       específicas, um XML de informações do plugin possui outro conjunto distinto de informações e
       marcações específicas. Haverá uma documentação própria para guiar seus passos em cada uma
       dessas finalidades!
       Links úteis:

                      ● XML na wikipedia: http://pt.wikipedia.org/wiki/XML
                      ● Introdução ao XML: http://www.macoratti.net/xml.htm
Se você está tendo problemas com os documentos XML, eis aqui algumas dicas:

               ● Certifique que as marcações/tags abertas estão sendo fechadas corretamente.
                    Nomes de marcações são case-sensitives e precisam ser exatamente iguais à
                    marcação de abertura.

               ● Certifique que as marcações usadas são válidas para a finalidade desejada.
               ● Alguns caracteres são reservados para controle do XML. Se você precisar deles

                    mesmo assim, é preciso fazer substituição por um código especial. Veja Lidando
                    com caracteres reservados do XML.
               ● Em caso de erro relacionado à codificação do texto, cerifique-se que o
                    documento possui um cabeçalho XML identificando corretamente a codificação
                    do documento. O cabeçalho é a primeira linha do documento, onde:

                                    ○ Se o documento estiver codificado em UTF-8, o cabeçalho deve
                                         ser:
                                                        ■ <?xml version="1.0" encoding="UTF-8"?>

                                    ○ Se você não sabe a codificação do documento, talvez o
                                         cabeçalho correto seja:
                                                        ■ <?xml version="1.0" encoding="ISO-8859-1"?>

Lidando com caracteres reservados do XML

  Alguns caracteres são reservados para controle do XML. Se você precisar deles mesmo assim, é
  preciso fazer substituição por um código especial:

Tabela de caracteres reservados:

C                                 Sub

a                                 stit

r                                 uiçã

a

c

t

e

r

e

r
e
s
e
r
v
a
d
o

<                                 &lt;

>                                 &gt
                   &  &a

                      mp;

                   ‘  &ap

                      os;

                   “  &qu

                      ot;

Exemplos de substituição:

                      ● <label text=”D&amp;D”/>
                           Substituição de "&" por "&amp;" ... Contém "D&D"

                      ● <button text=”20 &gt; 10”/>
                           Substituição de ">" por "&gt"; .... Contém "20 > 10"

CDATA

       Você também pode utilizar blocos CDATA para evitar fazer substituições, o que é útil em
       códigos LUA dentro de XML.
       Saiba mais em http://en.wikipedia.org/wiki/CDATA

Exemplo de CDATA

    <event name="onResize">
                   <![CDATA[
                                 local teste = "D&D";

                   if (x < y) or (x > z) then
                                 local teste = 'D&D 4.0';

                   end;

              ]]>
</event>

Não é preciso fazer nenhuma substituição de caracteres reservados dentro de um bloco CDATA.

Observação: Só é possível utilizar CDATA no corpo de um nodo do XML. Não é possível usar
CDATA no valor de um atributo, por exemplo.
FAQ - Perguntas Frequentes

            1. O SDK 3 precisa do Delphi para funcionar?

       Não. O SDK3 é uma nova ferramenta que utiliza uma nova tecnologia de plug-ins para o RRPG.
       Ela não exige ter o Delphi instalado.

            1. Tenho uma ficha feita no Delphi. O SDK3 é compatível com esta minha ficha?

       Não. As fichas feitas em Delphi usam o SDK 2, que é incompatível com o SDK 3.

            1. Quais as vantagem do SDK 3 sobre o SDK 2 + Delphi?
                                 ○ Os plug-ins do SDK 2 rodam apenas no Windows, enquanto os feitos no
                                      SDK 3 podem rodar em outros dispositivos.
                                 ○ Você não precisa baixar o Delphi (um aplicativo grande e pago)

            1. Existe alguma ferramenta que converte os plug-ins feitos no SDK2 para a versão
                 SDK3?

           Até o momento, não. Você precisará portar o plug-in "do zero". Se você pretende criar um
       modelo de ficha baseado em um PDF editável, você pode utilizar a ferramenta de conversão
       PDF -> Ficha SDK3. Saiba mais lendo Criar um modelo de ficha à partir de um PDF.

            1. Desenvolvi um plug-in usando o SDK 3. Quem for usar meu plug-in precisa ter o SDK3
                 instalado também?

       Não. O SDK 3 é uma ferramenta para quem desenvolve plug-ins. Os usuários do plug-in
       precisam apenas ter o RRPG Firecast mais atual instalado.

            1. A ferramenta que converte um PDF editável em uma ficha também converte os
                 cálculos que existem no PDF?

       Não. Você precisa recriar os cálculos e scripts manualmente. Veja o tutorial Criar campos
       calculados em fichas caso tenha dúvidas sobre como fazer isso.
```
