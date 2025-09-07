-- desviarOFUS.lua (ofuscado leve)

storage.desviarDelay=storage.desviarDelay or 1000
storage.effectBlacklist=storage.effectBlacklist or {}
storage.debuggedBlacklist=storage.debuggedBlacklist or {}

local a=UI.Label("Delay: "..storage.desviarDelay.."ms")
UI.Button("Trocar Delay",function()
  storage.desviarDelay=(storage.desviarDelay==1000) and 500 or 1000
  a:setText("Delay: "..storage.desviarDelay.."ms")
end)

local b,c=1541,1533
local d=10
local e=1500
local f=5

local ignoredPositions={{x=907,y=1589,z=15}}

local function getNow() return g_clock.millis() end
local function hasEffect(tile,id1,id2)
  for _,fx in ipairs(tile:getEffects()) do
    local id=fx:getId()
    if id==id1 or id==id2 then return true end
  end
  return false
end

local function posStr(p) return p.x..","..p.y..","..p.z end
local function blacklistPos(p) storage.effectBlacklist[posStr(p)]=getNow() end
local function isBlack(p)
  local k=posStr(p)
  local t=storage.effectBlacklist[k]
  if t and getNow()-t<e then return true elseif t then storage.effectBlacklist[k]=nil storage.debuggedBlacklist[k]=nil end
  return false
end
local function isIgnored(p)
  for _,q in ipairs(ignoredPositions) do
    if p.x==q.x and p.y==q.y and p.z==q.z then return true end
  end
  return false
end

macro(200,function()
  local p=pos()
  if not g_map.getTile(p) then return end
  for dx=-f,f do
    for dy=-f,f do
      local cp={x=p.x+dx,y=p.y+dy,z=p.z}
      local t=g_map.getTile(cp)
      if t and hasEffect(t,b,c) then blacklistPos(cp) end
    end
  end
end)

local function findWalk(p)
  for dist=1,d do
    for dx=-dist,dist do
      for dy=-dist,dist do
        if math.abs(dx)==dist or math.abs(dy)==dist then
          local cp={x=p.x+dx,y=p.y+dy,z=p.z}
          local tile=g_map.getTile(cp)
          if tile and g_map.isWalkable(cp) and not hasEffect(tile,b,c) and not isBlack(cp) then
            local path=findPath(p,cp,250)
            if path and #path>0 then autoWalk(cp,50,{ignoreNonPathable=true,precision=1}) delay(storage.desviarDelay) return end
          end
        end
      end
    end
  end
end

desviarMacro=macro(100,"Desviar",function()
  local p=pos()
  if not g_map.getTile(p) then return end
  if isIgnored(p) then return end
  if isBlack(p) then findWalk(p) end
end)

desviar1=addIcon("Desviar",{item=12435,text="Desviar",hotkey=""},desviarMacro)
desviar1:breakAnchors()
desviar1:move(290,300)

onCreaturePositionChange(function(c,newPos,oldPos)
  if c:isLocalPlayer() and oldPos then
    local reset=false
    if newPos.z~=oldPos.z then reset=true end
    if math.abs(newPos.x-oldPos.x)>=5 or math.abs(newPos.y-oldPos.y)>=5 then reset=true end
    if reset then storage.effectBlacklist={} storage.debuggedBlacklist={} end
  end
end)