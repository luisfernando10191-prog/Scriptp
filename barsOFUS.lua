-- barras.lua (ofuscado leve)  
  
local a={healthBar=true,manaBar=true,targetBar=true}  
local b={{p=35,c='red'},{p=75,c='yellow'},{p=100,c='green'}}  
local c={{p=35,c='#000099'},{p=75,c='#3333CC'},{p=100,c='#4D4DFF'}}  
  
local d=[[  
ProgressBar  
  id: bar  
  background-color: red  
  height: 16  
  width: 240  
  focusable: true  
  phantom: false  
  draggable: true  
  text-align: left  
  text:  
]]  
  
local e=[[  
ProgressBar  
  id: bar  
  background-color: blue  
  height: 16  
  width: 240  
  focusable: true  
  phantom: false  
  draggable: true  
  text-align: left  
  text:  
]]  
  
local f=[[  
UIWidget  
  id: t  
  background-color: alpha  
  width: 240  
  height: 48  
  border-radius: 4  
  padding: 4  
  focusable: false  
  phantom: false  
  draggable: true  
  
  ProgressBar  
    id: p  
    height: 12  
    width: 240  
    anchors.left: parent.left  
    anchors.bottom: parent.bottom  
    background-color: #880000  
    text-align: left  
    text-color: white  
  
  UICreature  
    id: s  
    width: 64  
    height: 64  
    anchors.left: parent.left  
    anchors.bottom: p.top  
    margin-left: -35  
  
  UILabel  
    id: n  
    anchors.left: s.right  
    anchors.bottom: p.top  
    color: white  
    text:   
    text-wrap: true  
    width: 250  
]]  
  
storage.q=storage.q or{}  
local g={}  
g.h=setupUI(d,g_ui.getRootWidget())g.h:setVisible(a.healthBar)  
g.m=setupUI(e,g_ui.getRootWidget())g.m:setVisible(a.manaBar)  
g.t=setupUI(f,g_ui.getRootWidget())g.t:setVisible(a.targetBar)  
  
local i=modules._G.g_app.isMobile()g_keyboard=g_keyboard or modules.corelib.g_keyboard  
local j=function()return i and g_keyboard.isKeyPressed("F2") or g_keyboard.isCtrlPressed()end  
  
local function k(l)g[l].onDragEnter=function(w,m)if(not j())then return end w:breakAnchors()w.r={x=m.x-w:getX(),y=m.y-w:getY()}return true end  
g[l].onDragMove=function(w,m)local r=w:getParent():getRect()local x=math.min(math.max(r.x,m.x-w.r.x),r.x+r.width-w:getWidth())local y=math.min(math.max(r.y-w:getParent():getMarginTop(),m.y-w.r.y),r.y+r.height-w:getHeight())w:move(x,y)return true end  
g[l].onDragLeave=function(w,p)storage.q[l]={x=w:getX(),y=w:getY()}return true end end  
  
for l,v in pairs(g)do k(l)g[l]:setPosition(storage.q[l] or{500,500})end  
  
local function o(n,t)for i=1,#t do if n<=t[i].p then return t[i].c end end return t[#t].c end  
local function p(w,n,l,t)if(not w)then return end w:setPercent(n)w:setText(string.format("%s: %d%%",l,n))w:setBackgroundColor(o(n,t))end  
local function q(u,n,z)local t=g.t t.s:setOutfit(u)if n=="Sem Target"then t.n:setText(n)else t.n:setText(string.format("%s: %d%%",n,z))end t.p:setPercent(z)t.p:setBackgroundColor(o(z,b))end  
  
macro(100,function()local u,n,z={},'Sem Target',100  
if g_game.isAttacking()then local v=g_game.getAttackingCreature()if v then u=v:getOutfit()n=v:getName()z=v:getHealthPercent()end end  
p(g.m,manapercent(),"Mana",c)p(g.h,hppercent(),"Vida",b)q(u,n,z)end)