# Tag event

> Extraído de `docs/Firecast_SDK_-_Single formatado.pdf` (texto automático; tabelas podem ter colunas desalinhadas). 

```text
Tag event

     Esta tag especial serve para tratar um evento de uma tag/controle usando a linguagem de
     programação LUA (veja A linguagem de programação LUA).
     Observações:

                               ○ O corpo da tag contém código de programação LUA
                               ○ Esta tag não cria nenhum controle.
                               ○ Você deve colocar a tag event dentro da tag que deseja tratar o evento.
     Importante: Não deixe de ler as Orientações ao usar código LUA em um Lua Form

Características
Propriedades e atributos
Propriedade  Tipo    Valor Padrão   Descrição
name         String
                     <Não há valor  Identifica o nome do
                     padrão>        evento que deseja
                                    manipular.
                                    Cada tag/controle possui
                                    seu próprio conjunto de
                                    eventos que podem ser
                                    tratados. Consulte a
                                    documentação!
                                    O preenchimento desta
                                    propriedade é obrigatório.

Exemplos

Exemplo 1 - Olá mundo com um botão.
A tag event está dentro da tag button, portanto, a tag está manipulando o evento "onClick" do button

 <?xml version="1.0" encoding="UTF-8"?>
 <form name="frmFichaTeste">

                <button left="20" top="20" text="clique">
                              <event name="onClick">
                                             showMessage("Olá mundo!");
                              </event>

                </button>

 </form>

Importante: Não deixe de ler as Orientações ao usar código LUA em um Lua Form
Exemplo 2 - Centralizando um controle na interface visual
A tag event está dentro da tag form, portanto ela está manipulando o evento "onResize" do form.

 <?xml version="1.0" encoding="UTF-8"?>
 <form name="frmFichaTeste">

                <event name="onResize">
                              self.btnMeuBotao.left = self.width / 2 - self.btnMeuBotao.width / 2;
                              self.btnMeuBotao.top = self.height / 2 - self.btnMeuBotao.height / 2;

                </event>
                <button name="btnMeuBotao" text="Meu botão!"/>
 </form>

Importante: Não deixe de ler as Orientações ao usar código LUA em um Lua Form
Exemplo 3 - Definindo funções e as chamando em eventos
<?xml version="1.0" encoding="UTF-8"?>
<form name="frmFichaTeste">

<script><![CDATA[
              local function rotacionarUmPouco(controle)
                             local angulo = controle.rotationAngle;
                             angulo = angulo + 30;

                    while angulo >= 360 do
                                  angulo = angulo - 360;

                    end;

                    controle.rotationAngle = angulo;

              end;
]]>
</script>

<button name="btnMeuBotao" left="20" top="30" text="Botão 1">
              <event name="onClick">
                             rotacionarUmPouco(self.btnMeuBotao);
              </event>

</button>

              <button name="btnMeuBotao2" left="20" top="100" text="Botão 2">
                             <event name="onClick">
                                           rotacionarUmPouco(self.btnMeuBotao2);
                             </event>

              </button>
</form>

                                 --->
Neste exemplo foi usada a Tag script para definir uma função e foi usado um bloco CDATA para lidar
com caracteres reservados do XML.
Importante: Não deixe de ler as Orientações ao usar código LUA em um Lua Form
```
