-- AutoDungeonOFUS.lua (ofuscado leve)

-- ================= UI Setup ==================
local a={"Mudoku","Special Anko","Solo Black Wolf","Black Lobisomem","Special Chisana","Dungeon Farukon","Dungeon Kakuzu","Solo Lobisomem","Special Haku","Dungeon Shita","Elite Black Dragon","Madara Rikudou","Special Minato","Special Itachi","Special Obito","Special Hagoromo","Naruto Barion","Majo Tsuyoi"}
local b=setupUI([[
Panel
  id: dungeonSetupPanel
  height: 30
  width: 160
  margin: 5
  padding: 3
  background-color: #1e1e1ecc
  anchors.top: parent.top
  anchors.left: parent.left
  draggable: true
  Button
    id: toggleButton
    text: Setup
    width: 60
    height: 20
    anchors.left: parent.left
    anchors.top: parent.top
  Panel
    id: checkboxPanel
    layout:
      type: verticalBox
    anchors.top: toggleButton.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: 0
    visible: false
]])
local c=false
b.toggleButton.onClick=function()
  local p=b.checkboxPanel
  local s=not p:isVisible()
  if s and not c then
    for _,n in ipairs(a) do
      local id=n:gsub("%s+","")
      local cb=g_ui.createWidget("CheckBox",p)
      cb:setId(id)
      cb:setText(n)
      cb:setWidth(140)
      cb:setChecked(storage["dungeon_"..n] or false)
      cb.onCheckChange=function(w,v) storage["dungeon_"..n]=v end
    end
    c=true
  end
  p:setVisible(s)
  if s then
    p:setHeight(#a*20)
    b:setHeight(#a*20+40)
  else
    p:setHeight(0)
    b:setHeight(30)
  end
end

-- ================= Lógica Dungeons ==================
local d={
  {n="Mudoku",l="startMudoku",e="endMudoku"},
  {n="Special Anko",l="startAnko",e="endAnko"},
  {n="Solo Black Wolf",l="startSoloWolf",e="endSoloWolf"},
  {n="Black Lobisomem",l="startBlackLobisomem",e="endBlackLobisomem"},
  {n="Special Chisana",l="startChisana",e="endChisana"},
  {n="Dungeon Farukon",l="startDungeonFarukon",e="endDungeonFarukon"},
  {n="Solo Lobisomem",l="startSoloLobisomem",e="endLobisomem"},
  {n="Special Haku",l="startSpecialHaku",e="endSpecialHaku"},
  {n="Dungeon Shita",l="startDungeonShita",e="endDungeonShita"},
  {n="Elite Black Dragon",l="startEliteBlackDragon",e="endEliteBlackDragon"},
  {n="Madara Rikudou",l="startMadaraRikudou",e="endMadaraRikudou"},
  {n="Special Minato",l="startSpecialMinato",e="endSpecialMinato"},
  {n="Special Itachi",l="startItachi",e="endItachi"},
  {n="Special Obito",l="startSpecialObito",e="endSpecialObito"},
  {n="Special Hagoromo",l="startHagoromo",e="endHagoromo"},
  {n="Majo Tsuyoi",l="startMajoTsuyoi",e="endMajoTsuyoi"},
  {n="Dungeon Kakuzu",l="startKakuzu",e="endKakuzu"},
  {n="Naruto Barion",l="startNarutoBarion",e="endNarutoBarion"}
}
local e={"Mudoku","Special Anko","Special Itachi","Black Lobisomem","Special Chisana","Elite Black Dragon","Special Haku","Dungeon Fuuton Heart","Solo Black Wolf","Solo Lobisomem","Madara Rikudou","Special Minato","Special Obito","Majo Tsuyoi","Dungeon Shita","Dungeon Farukon","Naruto Barion","Special Hagoromo"}
local f=30000
local g=15000
local h=nil
local i=nil
local j=1

-- ================= Controle Treino ==================
local k={{x=1449,y=1228,z=8},{x=1449,y=1230,z=8},{x=1449,y=1232,z=8},{x=1449,y=1234,z=8},{x=1449,y=1236,z=8},{x=1449,y=1238,z=8}}
local l=nil
local m=false
local function n(p)
  for _,q in ipairs(k) do
    if p.x==q.x and p.y==q.y and p.z==q.z then return true end
  end
  return false
end

-- Detecta boss com vida baixa
macro(500,function()
  for _,v in pairs(getSpectators()) do
    if v:isMonster() then
      local nn=v:getName():lower()
      for _,bname in ipairs(e) do
        if nn:find(bname:lower()) and v:getHealthPercent()<=95 then
          CaveBot.setOn(false)
          h=nil
          i=nil
          return
        end
      end
    end
  end
end)

-- Desliga ao entrar/sair do treino
macro(200,function()
  local p=pos()
  if not p then return end
  local t=n(p)
  if l==nil then l=t return end
  if not l and t then CaveBot.setOn(false)
  elseif l and not t then
    if m then m=false else CaveBot.setOn(false) end
  end
  l=t
end)

-- Macro principal das dungeons
macro(f,"Auto Dungeon",function()
  local now=os.clock()*1000
  if h and i and (now-i>g) then
    CaveBot.gotoLabel(h.l)
    i=now
    return
  end
  if h then return end
  local attempts=0
  while attempts<#d do
    local dungeon=d[j]
    local enabled=storage["dungeon_"..dungeon.n] or false
    if enabled then
      local avail=false
      for _,w in pairs(g_ui.getRootWidget():recursiveGetChildren()) do
        if type(w.getText)=="function" and w:isVisible() then
          local txt=w:getText()
          if txt and txt:find(dungeon.n) then
            local parent=w:getParent()
            if parent then
              for _,label in pairs(parent:getChildren()) do
                if type(label.getText)=="function" and label:isVisible() and label:getText()=="OK" then
                  avail=true
                  break
                end
              end
            end
          end
        end
        if avail then break end
      end
      if avail then
        local pos_=pos()
        if pos_ and n(pos_) then m=true end
        CaveBot.setOn(true)
        CaveBot.gotoLabel(dungeon.l)
        h=dungeon
        i=now
        return
      end
    end
    j=j+1
    if j>#d then j=1 end
    attempts=attempts+1
  end
  local pos_=pos()
  if pos_ and not n(pos_) then
    CaveBot.setOn(true)
    CaveBot.gotoLabel("startTreino")
  end
end)
