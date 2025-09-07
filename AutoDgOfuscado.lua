-- dungeonsOFUS.lua (ofuscado leve)

local a={"Mudoku","Special Anko","Solo Black Wolf","Black Lobisomem","Special Chisana","Dungeon Farukon","Dungeon Kakuzu","Solo Lobisomem","Special Haku","Dungeon Shita","Elite Black Dragon","Madara Rikudou","Special Minato","Special Itachi","Special Obito","Special Hagoromo","Naruto Barion","Majo Tsuyoi"}
local b={}

local c=setupUI([[Panel
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
local d=false

c.toggleButton.onClick=function()
  local w=c.checkboxPanel
  local v=not w:isVisible()
  if v and not d then
    for _,n in ipairs(a) do
      local id=n:gsub("%s+","")
      local cb=g_ui.createWidget("CheckBox",w)
      cb:setId(id)
      cb:setText(n)
      cb:setWidth(140)
      cb:setChecked(storage["dungeon_"..n] or false)
      cb.onCheckChange=function(_,val) storage["dungeon_"..n]=val end
    end
    d=true
  end
  w:setVisible(v)
  if v then w:setHeight(#a*20) c:setHeight(#a*20+40) else w:setHeight(0) c:setHeight(30) end
end

local e={
{name="Mudoku",label="startMudoku",endLabel="endMudoku"},
{name="Special Anko",label="startAnko",endLabel="endAnko"},
{name="Solo Black Wolf",label="startSoloWolf",endLabel="endSoloWolf"},
{name="Black Lobisomem",label="startBlackLobisomem",endLabel="endBlackLobisomem"},
{name="Special Chisana",label="startChisana",endLabel="endChisana"},
{name="Dungeon Farukon",label="startDungeonFarukon",endLabel="endDungeonFarukon"},
{name="Solo Lobisomem",label="startSoloLobisomem",endLabel="endLobisomem"},
{name="Special Haku",label="startSpecialHaku",endLabel="endSpecialHaku"},
{name="Dungeon Shita",label="startDungeonShita",endLabel="endDungeonShita"},
{name="Elite Black Dragon",label="startEliteBlackDragon",endLabel="endEliteBlackDragon"},
{name="Madara Rikudou",label="startMadaraRikudou",endLabel="endMadaraRikudou"},
{name="Special Minato",label="startSpecialMinato",endLabel="endSpecialMinato"},
{name="Special Itachi",label="startItachi",endLabel="endItachi"},
{name="Special Obito",label="startSpecialObito",endLabel="endSpecialObito"},
{name="Special Hagoromo",label="startHagoromo",endLabel="endHagoromo"},
{name="Majo Tsuyoi",label="startMajoTsuyoi",endLabel="endMajoTsuyoi"},
{name="Dungeon Kakuzu",label="startKakuzu",endLabel="endKakuzu"},
{name="Naruto Barion",label="startNarutoBarion",endLabel="endNarutoBarion"}
}

local f={"Mudoku","Special Anko","Special Itachi","Black Lobisomem","Special Chisana","Elite Black Dragon","Special Haku","Dungeon Fuuton Heart","Solo Black Wolf","Solo Lobisomem","Madara Rikudou","Special Minato","Special Obito","Majo Tsuyoi","Dungeon Shita","Dungeon Farukon","Naruto Barion","Special Hagoromo"}
local g=30000
local h=15000
local i=nil
local j=nil
local k=1

macro(g,"Auto Dungeon",function()
  local now=os.clock()*1000
  if i and j and now-j>h then CaveBot.gotoLabel(i.label) j=now return end
  if i then return end
  local attempts=0
  while attempts<#e do
    local dng=e[k]
    local enabled=storage["dungeon_"..dng.name] or false
    if enabled then
      local ok=false
      for _,child in pairs(g_ui.getRootWidget():recursiveGetChildren()) do
        if type(child.getText)=="function" and child:isVisible() then
          local t=child:getText()
          if t and t:find(dng.name) then
            local p=child:getParent()
            if p then
              for _,c in pairs(p:getChildren()) do
                if type(c.getText)=="function" and c:isVisible() and c:getText()=="OK" then ok=true break end
              end
            end
          end
        end
        if ok then break end
      end
      if ok then CaveBot.setOn(true) i=dng j=now return end
    end
    k=k+1 if k>#e then k=1 end attempts=attempts+1
  end
end)