-- combosOFUS.lua (ofuscado leve)

local a={"Dungeon Fuuton Heart","Dungeon Raiton Heart","Dungeon Katon Heart","Dungeon Suiton Heart","Dungeon Kakuzu"}
local b=10

atackMacro=macro(1,function()
  if isInPz() then return end
  local m=nil
  for _,name in ipairs(a) do
    for _,v in pairs(getSpectators()) do
      if v:isMonster() and v:canShoot() and v:getName():lower():find(name:lower()) then
        if getDistanceBetween(player:getPosition(),v:getPosition())<=b then
          m=v
          break
        end
      end
    end
    if m then break end
  end
  if m then
    if not g_game.isAttacking() or g_game.getAttackingCreature()~=m then g_game.attack(m) end
  end
end)

atack1=addIcon("Orthes",{item=3270,text="Orthes",hotkey=""},atackMacro)
atack1:breakAnchors()
atack1:move(90,300)

macro(200,function()
  local t=g_game.getAttackingCreature()
  if t and t:getName():lower()~="trainer" and g_game.isAttacking() then
    say("")
    say("tsukuyomi infinito")
    say("")
    say("")
  end
end)



-- recoveryOFUS.lua (ofuscado leve)

-- Blessings
if player:getBlessings()==0 then
  say("!bless")
  schedule(2000,function()
    if player:getBlessings()==0 then error("!! Blessings not bought !!") end
  end)
end

-- Comida
storage.foodItems={13958,14059}

macro(62000,function()
  if not storage.foodItems or #storage.foodItems==0 then return end
  local u={}
  for _,c in pairs(g_game.getContainers()) do
    for __,i in ipairs(c:getItems()) do
      for _,id in ipairs(storage.foodItems) do
        if i:getId()==id and not u[id] then g_game.use(i) print("[COMIDA] Usou item ID: "..id) u[id]=true end
      end
    end
  end
end)

-- Bag
local a="halloween backpack protect v4"
local function b()
  local bp=getBack()
  if not bp then return end
  for _,c in pairs(g_game.getContainers()) do
    if c:getContainerItem():getId()==bp:getId() then return end
  end
  g_game.open(bp)
end

UI.Button("Abrir Bag",b)
b()
macro(2000,b)

-- Abrir caixas automaticamente
local c={1234,5678,13999}
macro(1000,function()
  for _,cont in pairs(g_game.getContainers()) do
    for _,i in pairs(cont:getItems()) do
      if table.contains(c,i:getId()) then g_game.open(i) return end
    end
  end
end)
