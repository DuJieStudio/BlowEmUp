hUI.__static = {}
--hUI.__static.uiLayer = CCLayer:create()
--hUI.__static.mainScene = xlGetScene()				--设置基本scene
--hUI.__static.mainScene:addChild(hUI.__static.uiLayer,50000)	--UI层在最顶上
--hUI.__static.uiTouchLayer = CCLayer:create()
--hUI.__static.mainScene:addChild(hUI.__static.uiTouchLayer,50001)--最上面在来一层touch的
hUI.__callback_TouchCode = hApi.DoNothing			--UI层的触摸回调函数，请在游戏开始的时候注册
hUI.__static.__disable_tick = 0
hUI.__static.__disable_tag = 0
local size = CCDirector:sharedDirector():getOpenGLView():getDesignResolutionSize() --CCDirector:sharedDirector():getOpenGLView():getFrameSize()
-- w h为宽屏显示长宽   vw vh为竖屏显示长宽
if size.width > size.height then
	hVar.SCREEN.w = size.width
	hVar.SCREEN.h = size.height
	hVar.SCREEN.vw = size.height
	hVar.SCREEN.vh = size.width
else
	--hVar.SCREEN.w = size.height
	--hVar.SCREEN.h = size.width
	hVar.SCREEN_MODE = hVar.SCREEN_MODE_DEFINE.VERTICAL
	hVar.SCREEN.w = size.width
	hVar.SCREEN.h = size.height
	hVar.SCREEN.vw = size.width
	hVar.SCREEN.vh = size.height
end
g_canSpinScreen = 0
g_backToLogin = 0

if hVar.SCREEN.w == 1024 and hVar.SCREEN.h == 768 then --ipad
	g_phone_mode = 0 

elseif hVar.SCREEN.w == 960 and hVar.SCREEN.h == 640 then -- iphone4
	g_phone_mode = 1
elseif hVar.SCREEN.w == 1136 and hVar.SCREEN.h == 640 then -- iphone5
	g_phone_mode = 2
elseif hVar.SCREEN.w == 1280 and hVar.SCREEN.h == 720 then --iphone6-pphone8
	g_phone_mode = 3
	hVar.OPTIONS.AUTO_RELEASE_TEXTURE = 0
elseif hVar.SCREEN.w == 1560 and hVar.SCREEN.h == 720 then -- iphoneX
	g_phone_mode = 4
	hVar.SCREEN.offx = 60
	hVar.SCREEN.battleUI_offy = 30
end

--竖屏模式
if hVar.SCREEN.w == 768 and hVar.SCREEN.h == 1024 then --ipad
	g_phone_mode = 0 

elseif hVar.SCREEN.w == 640 and hVar.SCREEN.h == 960 then -- iphone4
	g_phone_mode = 1
elseif hVar.SCREEN.w == 640 and hVar.SCREEN.h == 1136 then -- iphone5
	g_phone_mode = 2
elseif hVar.SCREEN.w == 720 and hVar.SCREEN.h == 1280 then --iphone6-pphone8
	g_phone_mode = 3
	hVar.OPTIONS.AUTO_RELEASE_TEXTURE = 0
elseif hVar.SCREEN.w == 720 and hVar.SCREEN.h == 1560 then -- iphoneX
	g_phone_mode = 4
	hVar.SCREEN.offx = 60
	hVar.SCREEN.battleUI_offy = 30
end

--阻塞用户操作一段时间，并且分配一个MsgId
hGlobal.NET_MSG_COUNT = 0
hUI.NetDisable = function(tick,sTag,nCmdId)
	--print("NetDisable", tick,sTag,nCmdId, debug.traceback())
	if hGlobal.UI.NetWaitingIcon==nil then
		hGlobal.UI.NetWaitingIcon = hUI.image:new({
			model = "MODEL_EFFECT:waiting",
			x = hVar.SCREEN.w/2,
			y = hVar.SCREEN.h/2,
			z = 9999,
		})
		
		--对充值条目的特别处理
		if (sTag == "purchase") then
			hGlobal.UI.NetWaitingIcon:del()
			hGlobal.UI.NetWaitingIcon = nil
			
			hGlobal.UI.NetWaitingIcon = hUI.button:new({
				model = "misc/mask.png",
				x = hVar.SCREEN.w/2,
				y = hVar.SCREEN.h/2,
				--label = {text = "正在充值", x = 0, y = 0, align = "MC", border = 1, fonty = hVar.FONTC, size = 28,},
				z = 9999,
			})
			hGlobal.UI.NetWaitingIcon.handle.s:setOpacity(0) --只挂载子控件，不显示
			
			--图片
			local s9 = hApi.CCScale9SpriteCreate("data/image/misc/selectbg3.png", 0, 0, 400, 100, hGlobal.UI.NetWaitingIcon)
			--s9:setColor(ccc3(192, 192, 192))
			s9:setOpacity(212)
			
			--文字
			hGlobal.UI.NetWaitingIcon.childUI["label"] = hUI.label:new({
				parent = hGlobal.UI.NetWaitingIcon.handle._n,
				x = 0,
				y = -1,
				size = 30,
				align = "MC",
				border = 1,
				font = hVar.FONTC,
				text = hVar.tab_string["__TEXT_WAITING_PURCHASE"], --"交易进行中...",
			})
		end
	end
	if tick<=0 then
		if nCmdId~=nil and nCmdId~=hGlobal.NET_MSG_COUNT then
			return 0
		end
		if hGlobal.UI.NetWaitingIcon then
			hGlobal.UI.NetWaitingIcon.handle._n:setVisible(false)
			hGlobal.UI.NetWaitingIcon:del()
			hGlobal.UI.NetWaitingIcon = nil
		end
		hUI.__static.__disable_tick = 0
		hApi.clearTimer("__UI__HideWaitingIcon")
		return 1
	else
		hGlobal.UI.NetWaitingIcon.handle._n:setVisible(true)
		hGlobal.NET_MSG_COUNT = hGlobal.NET_MSG_COUNT + 1
		local tickLeft = hApi.gametime()+tick
		if tickLeft>hUI.__static.__disable_tick then
			hUI.__static.__disable_tick = tickLeft
			hUI.__static.__disable_tag = sTag or 0
		end
		hApi.addTimerOnce("__UI__HideWaitingIcon",hUI.__static.__disable_tick-hApi.gametime(),function(tick)
			if hGlobal.UI.NetWaitingIcon then
				hGlobal.UI.NetWaitingIcon.handle._n:setVisible(false)
				hGlobal.UI.NetWaitingIcon:del()
				hGlobal.UI.NetWaitingIcon = nil
			end
		end,1)
		return hGlobal.NET_MSG_COUNT
	end
end
hUI.IsDisabled = function()
	if hUI.__static.__disable_tick-hApi.gametime()>0 then
		return 1
	else
		return 0
	end
end
hUI.Disable = function(tick,sTag)
	if tick<=0 then
		hUI.__static.__disable_tick = 0
	else
		local tickLeft = hApi.gametime()+tick
		if tickLeft>hUI.__static.__disable_tick then
			hUI.__static.__disable_tick = tickLeft
			hUI.__static.__disable_tag = sTag or 0
		end
	end
end
hUI.UIBreath = function(pNode,fScale,x,y,fScaleA)
	local decal,count = 11,0
	local r,g,b,parent = 150,128,64,pNode
	local offsetX,offsetY,duration,scale = x or 0,y or 0,fScaleA or 0.7,1.1
	local pSprite = xlAddNormalLightEffect(decal,count,offsetX,offsetY,duration,scale,r,g,b,parent)
	pSprite:setScale(fScale)
	return pSprite
end
hUI.InitUISystem = function()
	hUI.__static.mainScene = xlGetScene()				--设置基本scene
	hUI.__static.uiLayer = hUI.InitLayer("UI_LAYER",function(pLayer)
		--这是一段毫无意义的代码，但是如果不这样做所有的ClipperLayer都会显示错误，其实我也不知道这是作甚的
		--李宁 2014/9/12
		--[[
		local pClipper,pClipperMask,pClipperMaskN = hApi.CreateClippingNode(pLayer,{0,0,16,16},nil,0)
		if pClipper and pClipperMask and pClipperMaskN then
			pClipper:setVisible(false)
			pClipperMask:setVisible(false)
			pClipper:setStencil(pClipperMaskN)
		end
		]]
	end)
	hUI.__static.uiTouchLayer = hUI.InitLayer("UI_TOUCH_LAYER",function(self)
		self:setTouchEnabled(true)
		self:registerScriptTouchHandler(function(...)
			return hUI.__callback_TouchCode(...)
		end,false,0,true)
	end)
	hUI.__static.mainScene:addChild(hUI.__static.uiLayer,50000)	--UI层在最顶上
	hUI.__static.mainScene:addChild(hUI.__static.uiTouchLayer,50002)--最上面在来一层touch的

	--默认imageButton模式下的dragBox
	if hGlobal.UI.UI_DragBox==nil then
		hGlobal.UI.UI_DragBox = hUI.dragBox:new({
			node = CCNode:create(),
			oy = hVar.SCREEN.h,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			autoactive = 0,
			buttononly = 1,
		})
	else
		hGlobal.UI.UI_DragBox:sortbutton()
	end
end
-----------------------------------------------
-- 内存优化
-----------------------------------------------
hUI.SYSAutoReleaseUI = {
	Grid = {},
	plist = {idx = {}},
	png = {idx = {}},
	addModel = function(self,mode,sModelName,sAnimation)
		if mode=="hero" then
			local tPlist = self.plist
			local tabM = hApi.GetModelByName(sModelName)
			if tabM then
				
				if tabM.loadmode=="plist" and tPlist.idx[sModelName]==nil then
					local n = #tPlist+1
					tPlist.idx[sModelName] = {}
					tPlist[n] = sModelName
				end
			end
		elseif mode=="portrait" then
			local tPng = self.png
			if tPng.idx[sModelName]==nil then
				local n = #tPng+1
				tPng.idx[sModelName] = 1
				tPng[n] = sModelName
			end
		end
	end,
}
hUI.CheckImagePath = function(sUIName,oUI,sImagePath)
	--if type(sImagePath)=="string" then
		--if oUI.classname=="bagGrid" and oUI.__ID>0 and oUI.data.codeOnAutoRelease~=0 then
			--hGlobal.SYSTempGrid[oUI.ID] = oUI.__ID
			----if string.find(sImagePath,"icon/")==1 then
				----hGlobal.SYSTempGrid[oUI.ID] = oUI.__ID
				------需要清理的临时图标
				----print(oUI.classname,sImagePath)
			----end
		--end
	--end
end
--内存快爆掉的时候，释放bagGrid里面的东西
hGlobal.event:listen("LocalEvent_MemoryWarning","__TEMPGRID__MEMFlush",function(nCount)
	local sus = 1
	for ID,__ID in pairs(hUI.SYSAutoReleaseUI.Grid)do
		local oGrid = hUI.bagGrid:find(ID)
		if oGrid and oGrid.__ID==__ID then
			local clr = 1
			local case = type(oGrid.data.codeOnAutoRelease)
			if case=="table" then
				for i = 1,#oGrid.data.codeOnAutoRelease do
					if oGrid.data.codeOnAutoRelease[i].data.show~=0 then
						clr = 0
						sus = 0
					end
				end
			elseif case=="function" then
				if oGrid.data.codeOnAutoRelease(oGrid,0)==0 then
					clr = 0
					sus = 0
				end
			end
			if clr==1 then
				oGrid:updateitem({})
			end
		end
	end
	--释放部分plist
	local tLog = {"auto release on low memory warning:\n"}
	do
		local tRelease = {}
		local tPlist = hUI.SYSAutoReleaseUI.plist
		for i = 1,#tPlist do
			local tPath = tPlist.idx[tPlist[i]]
			if #tPath==0 then
				local tIndex = {}
				local tabM = hApi.GetModelByName(tPlist[i])
				for n = 1,#tabM.animation do
					local sPath = tabM[tabM.animation[n]].plist or tabM.plist
					if sPath and tIndex[sPath]~=1 then
						tIndex[sPath] = 1
						tPath[#tPath+1] = sPath
					end
				end
			end
			for n = 1,#tPath do
				tRelease[tPath[n]] = 1
				
			end
		end
		tLog[#tLog+1] = "plist:\n"
		local tTemp = {}
		hResource.model:copyPlistCache(hVar.TEMP_HANDLE_TYPE.OBJECT_WM,tTemp)
		hResource.model:copyPlistCache(hVar.TEMP_HANDLE_TYPE.OBJECT_TN,tTemp)
		hResource.model:copyPlistCache(hVar.TEMP_HANDLE_TYPE.OBJECT_BF,tTemp)
		for path in pairs(tRelease) do
			if tTemp[path]~=1 then
				tLog[#tLog+1] = "	- "..path
				tLog[#tLog+1] = "\n"
				xlReleaseResourceFromPList("data/image/"..path)
			end
		end
		
	end
	--关闭log
	hResource.model.showlog = 0
	--释放英雄头像
	do
		tLog[#tLog+1] = "png:\n"
		local tRelease = {}
		local tPng = hUI.SYSAutoReleaseUI.png
		for i = 1,#tPng do
			local path = tPng[i]
			tRelease[path] = 1
			tLog[#tLog+1] = "	- "..path
			tLog[#tLog+1] = "\n"
		end
		hResource.model:releasePng(tRelease)
	end
	_DEBUG_MSG(table.concat(tLog))
	--释放头像
	--释放UI_GRID_AUTO_RELEASE
	if sus==1 then
		hResource.model:releaseCache(hVar.TEMP_HANDLE_TYPE.UI_GRID_AUTO_RELEASE)
	end
	--打开log
	hResource.model.showlog = 1
end)
-----------------------------------------------
-- 加载字符串
-----------------------------------------------
if type(language_config)=="table" then
	hVar.FONTC = language_config[g_language_setting][4]
	--hVar.FONTC = "Arial"
end
if type(g_string)=="table" then
	--加载字符串(一切ok!)
	for k,v in pairs(g_string)do
		hVar[k] = v
	end
else
	--啥情况!加载一下tab_string!
	hVar.tab_string = {}
	hVar.tab_stringU = {}		--单位字符串
	hVar.tab_stringH = {}		--不知道是啥
	hVar.tab_stringS = {}		--技能字符串
	hVar.tab_stringI = {}		--物品字符串
	hVar.tab_stringM = {}		--地图字符串
	hVar.tab_stringIE = {}		--道具强化说明表
	hVar.tab_stringME = {}		--勋章信息说明表
	hVar.tab_stringQ = {}		--任务说明表
	hVar.tab_stringGIFT = {}	--礼包说明表
	hVar.tab_stringT = {}		--战术技能表

	local _tab_string = hVar.tab_string
	local _tab_stringU = hVar.tab_stringU
	local _tab_stringH = hVar.tab_stringH
	local _tab_stringS = hVar.tab_stringS
	local _tab_stringI = hVar.tab_stringI
	local _tab_stringM = hVar.tab_stringM
	local _tab_stringIE = hVar.tab_stringIE
	local _tab_stringME = hVar.tab_stringME
	local _tab_stringGIFT = hVar.tab_stringGIFT
	local _tab_stringT = hVar.tab_stringT

	local Default_tab_string = {}
	local Default_tab_stringT = {"name","hint"}
	local Default_tab_stringTX = {"name",{"hint"}}
	for i = 1,49999 do
		_tab_stringU[i] = Default_tab_string
	end
	for i = 1,9999 do
		_tab_stringS[i] = Default_tab_string
		_tab_stringI[i] = Default_tab_string
	end
	for i = 1,999 do
		hVar.tab_stringT[i] = Default_tab_stringTX
	end
	setmetatable(_tab_string,{
		__index = function(t,k)
			return tostring(k)
		end,
	})
	--程序用的别动
	g_input_erro_info = {}
	g_input_erro_info[1] = "same name"
	g_input_erro_info[2] = "blank name"
	g_input_erro_info[3] = "have blank in name"
	g_input_erro_info[4] = "support max length is 15 words"
	g_input_erro_info[5] = "illegal char"
	g_input_erro_info[6] = "illegal text"
end
-----------------------------------------------
-- 拖拽模块
-----------------------------------------------
hUI.DragIndex = 0
hUI.IsDragSomething = 0
hUI.SpecialDragCode = 0
hUI.DragBoxList = {[0] = 0,n=0}		--请搜索"--DragBox定义"
hUI.LastTouchPos = {0,0}
local __ViewNodeScale = 1
local __box = hUI.DragBoxList
local __TouchCode
local __TouchX,__TouchY,__ScreenX,__ScreenY
local __ExecuteTouchCode = function()
	return __TouchCode(__TouchX,__TouchY,__ScreenX,__ScreenY)
end
local __CallTouchCode = function(code,x,y,sx,sy)
	__TouchCode = code
	__TouchX,__TouchY,__ScreenX,__ScreenY = x,y,sx,sy
	xpcall(__ExecuteTouchCode,hGlobal.__TRACKBACK__)
end

local __SelectDragBox
__SelectDragBox = function(pCode,touchX,touchY,fromWitchIndex)
	local i,relX,relY = pCode(touchX,touchY,fromWitchIndex)
	if i~=0 and __box[i]~=0 then
		local v = __box[i]
		local oTouchBox = hUI.dragBox:find(v[2])
		if oTouchBox~=nil and oTouchBox.ID~=0 then
			local d = oTouchBox.data
			local btn,tx,ty,bx,by = oTouchBox:getbutton(relX,relY)
			if d.buttononly == 2 then  
				if btn then
					hUI.IsDragSomething = 1
					hUI.SpecialDragCode = d.codeOnDragEx
					v[11],v[12] = -1*relX,-1*relY
					v[13],v[14] = touchX,touchY
					oTouchBox:select()
					if d.autoactive==1 then
						oTouchBox:active()	--这后面就不敢保证oTouchBox是不是还在[i]这个位置上了
					end
					return oTouchBox:focusbutton(btn,relX,relY,tx,ty,bx,by)
				elseif d.codeOnTouch~=0 and type(d.dragArea) == "table" then
					--判断滑动范围
					if hApi.IsInBox(relX,relY, d.dragArea) then
						hUI.IsDragSomething = 1
						hUI.SpecialDragCode = d.codeOnDragEx
						v[11],v[12] = -1*relX,-1*relY
						v[13],v[14] = touchX,touchY
						oTouchBox:select()
						if d.autoactive==1 then
							oTouchBox:active()	--这后面就不敢保证oTouchBox是不是还在[i]这个位置上了
						end
						if d.codeOnTouch~=0 then
							return __CallTouchCode(d.codeOnTouch,relX,relY,touchX,touchY)
						end
					else
						return __SelectDragBox(pCode,touchX,touchY,i-1)	
					end
				else
					return __SelectDragBox(pCode,touchX,touchY,i-1)	
				end
			elseif btn==nil and (d.buttononly==1 or d.worldnode~=0) then
				return __SelectDragBox(pCode,touchX,touchY,i-1)
			else
				hUI.IsDragSomething = 1
				hUI.SpecialDragCode = d.codeOnDragEx
				v[11],v[12] = -1*relX,-1*relY
				v[13],v[14] = touchX,touchY
				oTouchBox:select()
				if d.autoactive==1 then
					oTouchBox:active()	--这后面就不敢保证oTouchBox是不是还在[i]这个位置上了
				end
				if btn then
					return oTouchBox:focusbutton(btn,relX,relY,tx,ty,bx,by)
				elseif d.codeOnTouch~=0 then
					return __CallTouchCode(d.codeOnTouch,relX,relY,touchX,touchY)
				end
			end
		end
	end
end

local __WorldNodeCount = 0
local __TestDragBoxUI = function(touchX,touchY,fromWitchIndex)
	for i = fromWitchIndex,1,-1 do
		local v = __box[i]
		if v~=0 then
			if v[1]~=0 then
				local x,y,w,h,ox,oy = v[5],v[6],v[7],v[8],v[9],v[10]
				if touchX>=x+ox and touchX<=x+ox+w and touchY>=y+oy-h and touchY<=y+oy then
					return i,math.floor(touchX-x),math.floor(touchY-y)
				end
			elseif v[3]~=0 then
				__WorldNodeCount = __WorldNodeCount + 1
			end
		end
	end
	return 0,0,0
end

local __TestDragBoxWN = function(touchX,touchY,fromWitchIndex)
	--worldnode一定会触发按钮检索!(w,h,ox,oy)均无效
	for i = fromWitchIndex,1,-1 do
		local v = __box[i]
		if v~=0 and v[1]==0 and v[3]~=0 then
			local x,y,w,h,ox,oy = v[5],v[6],v[7],v[8],v[9],v[10]
			local wx,wy = v[3]:getPosition()
			local cx,cy = hApi.world2view(wx,-1*wy)
			local s = hApi.getViewScale() or 1
			x,y = x*s,y*s
			return i,math.floor(touchX-cx-x),math.floor(touchY-cy-y)
		end
	end
	return 0,0,0
end

local __TryToLoadDragIndex = function(touchX,touchY,fromWitchIndex)
	__WorldNodeCount = 0
	__SelectDragBox(__TestDragBoxUI,touchX,touchY,fromWitchIndex)
	if hUI.IsDragSomething~=1 and __WorldNodeCount>0 then
		__SelectDragBox(__TestDragBoxWN,touchX,touchY,fromWitchIndex)
	end
end

local __GetValBetween = function(v,a,b)
	if a>b then
		return math.min(a,math.max(v,b))
	elseif a<b then
		return math.min(b,math.max(v,a))
	else
		return a
	end
end

local __LastFocusBattlefield = {}
local __callback_TouchCode
local __TouchModeConv = {began=0,moved=1,ended=2}
__callback_TouchCode = function(touchMode,touchX,touchY)
	--新版cocos2.x需要用到此转换
	touchMode = __TouchModeConv[touchMode] or touchMode
	--xlLG("TouchCode","touchMode = "..tostring(touchMode)..",touchX = "..tostring(touchX)..",touchY = "..tostring(touchY).."\n")
	--touchMode:0按下，1滑动，2弹起
	if type(touchX)=="table" then
		touchX,touchY = unpack(touchX)
		--_DEBUG_MSG("[LUA WARNING:ERROR]UI_TOUCH_LAYER被设置成多触点模式，异常！")
	end
	if touchMode==0 then
		hGlobal.event:event("LocalEvent_UITouchBegin",touchX,touchY)
		local tickCur = hApi.gametime()
		local tickLeft = hUI.__static.__disable_tick-tickCur
		if tickLeft>0 then
			_DEBUG_MSG("[LUA UI] 玩家触摸事件禁止中！剩余 ("..tickLeft..") ms")
			hUI.DragIndex = 0
			hUI.IsDragSomething = 1
			return 1
		end
		if hUI.DragIndex~=0 then
			__callback_TouchCode(2,touchX,touchY)
		end
		hUI.DragIndex = 0
		hUI.IsDragSomething = 0
		hUI.SpecialDragCode = 0
		hApi.SetObjectEx(__LastFocusBattlefield,nil)
		--如果当前世界拥有强引导UI
		local w
		if hGlobal.LocalPlayer then
			w = hGlobal.LocalPlayer:getfocusworld()
			if w and w.worldUI["GUIDE_UI"]~=nil and hApi.CheckGuideUI(w.worldUI["GUIDE_UI"],touchX,touchY)==0 then
				hUI.IsDragSomething = 1
				return 1
			end
		end
		hUI.LastTouchPos[1] = touchX
		hUI.LastTouchPos[2] = touchY
		__TryToLoadDragIndex(touchX,touchY,__box.n)
		if hUI.IsDragSomething==1 then
			local _SpecialDragCode = hUI.SpecialDragCode
			if _SpecialDragCode~=0 and type(_SpecialDragCode)=="function" then
				_SpecialDragCode(touchX,touchY,touchMode)
			end
			return 1
		else
			--如果是战场里面
			if w and w.data.type=="battlefield" then
				--战场中捕获所有的拖拽事件
				local worldX,worldY = hApi.view2world(touchX,hVar.SCREEN.h-touchY)
				if worldX and worldY then
					hApi.SetObjectEx(__LastFocusBattlefield,w)
					local gridX,gridY = w:xy2grid(worldX,worldY)
					hGlobal.LocalPlayer.localoperate:touch(w,hVar.LOCAL_OPERATE_TYPE.TOUCH_DOWN,gridX,gridY,worldX,worldY)
					hUI.IsDragSomething = 2
					return 1
				end
			end
		end
	elseif hUI.DragIndex~=0 or hUI.IsDragSomething~=0 then
		if touchMode==1 then
			local v = __box[hUI.DragIndex]
			if v~=0 and v[2]~=0 then
				v[5],v[6] = touchX+v[11],touchY+v[12]
				v[13],v[14] = touchX,touchY
				if v[1]~=0 then
					local n = v[1]
					v[1] = 0
					if v[15]~=0 then
						v[5] = __GetValBetween(v[5],v[15][1],v[15][1]+v[15][3])
						v[6] = __GetValBetween(v[6],v[15][2],v[15][2]-v[15][4])
					end
					n:setPosition(v[5],v[6])
					v[1] = n
				else
					local oTouchBox = hUI.dragBox:find(v[2])
					local d = oTouchBox.data
					if d.codeOnDrag~=0 then
						d.codeOnDrag(math.floor(v[5]),math.floor(v[6]),touchX,touchY)
					end
				end
				local _SpecialDragCode = hUI.SpecialDragCode
				if _SpecialDragCode~=0 and type(_SpecialDragCode)=="function" then
					_SpecialDragCode(touchX,touchY,touchMode)
				end
				return 1
			elseif hUI.IsDragSomething==1 then
				local _SpecialDragCode = hUI.SpecialDragCode
				if _SpecialDragCode~=0 and type(_SpecialDragCode)=="function" then
					_SpecialDragCode(touchX,touchY,touchMode)
				end
				return 1
			elseif hUI.IsDragSomething==2 then
				local w = hApi.GetObjectEx(hClass.world,__LastFocusBattlefield)
				if w and hGlobal.LocalPlayer then
					local worldX,worldY = hApi.view2world(touchX,hVar.SCREEN.h-touchY)
					if worldX and worldY then
						local gridX,gridY = w:xy2grid(worldX,worldY)
						hGlobal.LocalPlayer.localoperate:touch(w,hVar.LOCAL_OPERATE_TYPE.TOUCH_MOVE,gridX,gridY,worldX,worldY)
					end
				end
				return 1
			end
		else
			local i = hUI.DragIndex
			local dI = hUI.IsDragSomething
			local _SpecialDragCode = hUI.SpecialDragCode
			hUI.DragIndex = 0
			hUI.IsDragSomething = 0
			hUI.SpecialDragCode = 0
			local v = __box[i]
			if v~=0 then
				local oTouchBox = hUI.dragBox:find(v[2])
				if oTouchBox~=nil and oTouchBox.ID~=0 then
					local d = oTouchBox.data
					local code = d.codeOnDrop
					v[5],v[6] = touchX+v[11],touchY+v[12]
					v[13],v[14] = touchX,touchY
					local cx,cy = v[5],v[6]
					local n = v[1]
					if v[1]~=0 then
						if v[15]~=0 then
							v[5] = __GetValBetween(v[5],v[15][1],v[15][1]+v[15][3])
							v[6] = __GetValBetween(v[6],v[15][2],v[15][2]-v[15][4])
						end
						n:setPosition(v[5],v[6])
					end
					d.x,d.y = v[5],v[6]
					if d.autorelease~=0 then
						__box[i][1] = 0
						__box[i] = 0
						d.index = 0
						oTouchBox:del()
					end
					if code~=0 then
						__CallTouchCode(code,math.floor(cx),math.floor(cy),touchX,touchY)
					end
				end
			elseif dI==2 then
				local w = hApi.GetObjectEx(hClass.world,__LastFocusBattlefield)
				if w and hGlobal.LocalPlayer then
					local worldX,worldY = hApi.view2world(touchX,hVar.SCREEN.h-touchY)
					if worldX and worldY then
						local gridX,gridY = w:xy2grid(worldX,worldY)
						hGlobal.LocalPlayer.localoperate:touch(w,hVar.LOCAL_OPERATE_TYPE.TOUCH_UP,gridX,gridY,worldX,worldY)
					end
				end
			end
			if _SpecialDragCode~=0 and type(_SpecialDragCode)=="function" then
				_SpecialDragCode(touchX,touchY,touchMode)
			end
		end
	end
	return 0
end
hUI.__callback_TouchCode = __callback_TouchCode
--======================================================================
--拖拽支持函数
local __DBOX__SetNodeZ = function(v,z)
	if v~=0 and v[4]==1 then
		if v[1]~=0 then
			v[1]:getParent():reorderChild(v[1],z)
		end
		if v[16]~=0 then
			for i = 1,#v[16] do
				v[16][i]:getParent():reorderChild(v[16][i],z)
			end
		end
	end
end
--======================================================================
--拖拽模块
--======================================================================
hUI.dragBox = eClass:new("static")
local _udb = hUI.dragBox
local __DefaultParam = {
	node = 0,
	worldnode = 0,			--绑在世界物件上使用
	linknode = 0,			--{}会被一起设置zOrder的node
	x = 0,
	y = 0,
	ox = 0,
	oy = 0,
	box = 0,
	w = 0,
	h = 0,
	--top = 0,			--创建的时候是否一定在最顶层，这个只在param中读取，并不记录入data中
	visitable = 0,			--这个值等于1才能被hUI.drageBox:current()函数返回
	autoactive = 1,			--点击的时候自动置顶
	autosort = 1,			--是否会被在frame列表中自动排序(自定义的frame需要将这个数值设置为0)
	autorelease = 0,		--放下的时候自动释放
	buttononly = 0,			--点击时仅判断有无按钮，若无按钮则自动跳转到下一层
	codeOnTouch = 0,
	codeOnDrop = 0,
	codeOnDrag = 0,			--这个会不停滴被调用，当node==0时才会有此调用
	codeOnDragEx = 0,		--隶属于该dragBox的任何控件被拖拽时将产生此回调
	--buttons = 0,			--{...,btnID}记录了在自己管理下的buttton
	--buttons__ID = 0,		--保存着上面按钮的唯一ID，判断是否合法
}
local __box = hUI.DragBoxList
_udb.init = function(self,p)
	self.data = hUI.ReadParam(__DefaultParam,p,rawget(self,"data") or {})
	local d = self.data
	d.index = 0
	d.buttons = 0
	d.buttons__ID = 0
	if p~=nil and p.top==1 then
		--for i = __box.n,1,-1 do
			--if __box[i]==0 then
				--d.index = i
			--else
				--break
			--end
		--end
	else
		--一般的排序方式，插到最下面一个没用过的位置
		for i = __box.n,1,-1 do
			if __box[i]==0 then
				d.index = i
				break
			end
		end
	end
	if d.index==0 then
		__box.n = __box.n + 1
		d.index = __box.n
	end
	--worldnode特殊处理
	--worldnode一定会触发按钮检索!(w,h,ox,oy)均无效
	if type(d.worldnode)~="userdata" then
		d.worldnode = 0
	else
		d.node = 0
		d.autoactive = 0
		d.buttononly = 1
		d.w = 0
		d.h = 0
		d.ox = 0
		d.oy = 0
	end
	if type(d.node)~="userdata" then
		d.node = 0
	end
	if type(d.linknode)=="table" then
		local tNode = d.linknode
		for i = 1,#tNode do
			if type(tNode[i])~="userdata" then
				d.linknode = 0
				break
			end
		end
	else
		d.linknode = 0
	end
	if d.codeOnDrag~=0 and type(d.codeOnDrag)~="function" then
		d.codeOnDrag = 0
	end
	if d.codeOnDragEx~=0 and type(d.codeOnDragEx)~="function" then
		d.codeOnDragEx = 0
	end
	local NeedSort = 0
	if d.node~=0 then
		if d.node:getParent()==nil then
			hUI.__static.uiLayer:addChild(d.node,d.index)
			d.x,d.y = d.node:getPosition()
			d.worldnode = 0
		elseif d.node:getParent()==hUI.__static.uiLayer then
			if d.autosort==1 then
				hUI.__static.uiLayer:reorderChild(d.node,d.index)
			end
			d.x,d.y = d.node:getPosition()
			d.worldnode = 0
		else
			if d.autosort==1 then
				NeedSort = 1
			end
			d.x,d.y = d.node:getPosition()
			d.worldnode = 0
			--d.node = 0
			--_DEBUG_MSG("[LUA WARNING] DragBox 只能以 uiLayer 上的node为合法目标")
		end
	end
	--DragBox定义
	--{1   ,2        ,3        ,4       ,5,6,7,8,9 ,10,11   ,12   ,13  ,14  ,15           ,16        ,}
	--{node,dragBoxID,worldnode,autosort,x,y,w,h,ox,oy,baseX,baseY,curX,curY,{tx,ty,bx,by},{linknode},}
	__box[d.index] = {d.node,self.ID,d.worldnode,d.autosort,d.x,d.y,d.w,d.h,d.ox,d.oy,0,0,0,0,d.box,d.linknode}
	if NeedSort==1 then
		__DBOX__SetNodeZ(__box[d.index],d.index)
	end
end

local __box = hUI.DragBoxList
_udb.destroy = function(self)
	local d = self.data
	d.node = 0
	d.pNode = 0
	d.linknode = 0
	self:clearbutton()
	if d.index~=0 then
		__box[d.index][1] = 0
		__box[d.index][3] = 0
		__box[d.index] = 0
		if hUI.DragIndex==d.index then
			hUI.DragIndex = 0
		end
	end
	--内存清理:移除不需要的函数
	d.codeOnTouch = 0
	d.codeOnDrop = 0
	d.codeOnDrag = 0
	d.codeOnDragEx = 0
end

_udb.clearbutton = function(self)
	local d = self.data
	d.buttons = 0
	d.buttons__ID = 0
end

_udb.getoffset = function(self)
	local d = self.data
	local tData = __box[d.index]
	if tData and tData~=0 then
		return tData[11],tData[12]
	end
end

_udb.setoffset = function(self,x,y)
	local d = self.data
	local tData = __box[d.index]
	if tData and tData~=0 then
		tData[11] = x or tData[11]
		tData[12] = y or tData[12]
	end
end

_udb.sortbutton = function(self)
	local d = self.data
	if d.buttons==0 then
		return
	end
	for i = 1,#d.buttons do
		local btn = hUI.button:find(d.buttons[i])
		if btn==nil or btn.__ID~=d.buttons__ID[i][1] then
			d.buttons[i] = 0
			d.buttons__ID[i] = 0
		end
	end
	local iLast
	for i = 1,#d.buttons do
		if d.buttons[i]==0 then
			iLast = iLast or i
		elseif iLast~=nil then
			d.buttons[iLast] = d.buttons[i]
			d.buttons__ID[iLast] = d.buttons__ID[i]
			d.buttons[i] = 0
			d.buttons__ID[i] = 0
			iLast = iLast + 1
		end
	end
	if iLast~=nil then
		for i = #d.buttons,iLast,-1 do
			d.buttons[i] = nil
			d.buttons__ID[i] = nil
		end
	end
end

local __GetButtonRelPos = function(oButton,ox,oy)
	local bw,bh = oButton.data.w,oButton.data.h
	local bx,by = oButton:getTLXY()
	return bx+(ox or 0),by+(oy or 0),bw,bh
end

local __box = hUI.DragBoxList
local __GetButtonRelBox = function(d,self)
	local s = 1
	local i = self.data.index
	if self.ID~=0 and i~=0 and __box[i]~=0 and __box[i]~=nil then
		local v = __box[i]
		if v[3]~=0 and type(v[3])=="userdata" then
			s = hApi.getViewScale() or 1
		end
	end
	return d[2]*s,d[3]*s,(d[2]+d[4])*s,(d[3]-d[5])*s
end
_udb.addbutton = function(self,oButton,ox,oy)
	if oButton~=hUI.button:find(oButton.ID) then
		_DEBUG_MSG("[LUA WARNING] 调用 drawBox:addbutton 时传入非 button 类的控件")
		return
	end
	ox = ox or 0
	oy = oy or 0
	local d = self.data
	if d.buttons==0 then
		d.buttons = {}
		d.buttons__ID = {}
	end
	local index = #d.buttons+1
	d.buttons[index] = oButton.ID
	local bx,by,bw,bh = __GetButtonRelPos(oButton,ox,oy)
	d.buttons__ID[index] = {oButton.__ID,bx,by,bw,bh}
end

_udb.setbutton = function(self,oButton,ox,oy)
	local d = self.data
	if d.buttons==0 then
		return
	end
	for i = 1,#d.buttons do
		if d.buttons[i]==oButton.ID then
			local vx = d.buttons__ID[i]
			if vx[1]==oButton.__ID then
				vx[2],vx[3],vx[4],vx[5] = __GetButtonRelPos(oButton,ox,oy)
			end
			return i
		end
	end
end


local __btnParamX,__btnParamY,__btnParamSUS
hUI.RegisterButtonCode = function(self,k)
	local d = self.data
	if d[k]~=0 and d[k]~=hApi.DoNothing then
		local _code = d[k]
		d["_"..k] = function()
			return _code(self,__btnParamX,__btnParamY,__btnParamSUS)
		end
	end
end
_udb.getbutton = function(self,relX,relY,WithFocus)
	local d = self.data
	if d.buttons~=0 and d.buttons__ID~=0 then
		for i = #d.buttons,1,-1 do
			local btn = hUI.button:find(d.buttons[i])
			local vx = d.buttons__ID[i]
			if btn~=nil and vx[1]==btn.__ID and (btn.data.state==1 or btn.data.state==2) then
				local tx,ty,bx,by = __GetButtonRelBox(vx,self)
				if relX>=tx and relX<=bx and relY<=ty and relY>=by then
					if WithFocus==1 then
						self:focusbutton(btn,relX,relY,tx,ty,bx,by)
					end
					return btn,tx,ty,bx,by
				end
			end
		end
	end
end

--获取nodeXY,如果拥有worldnode则还需要进行转换
local __GetWorldNodeXY = function(node,ox,oy,x,y)
	if node~=0 then
		local wx,wy = node:getPosition()
		local px,py = hApi.world2view(wx,-1*wy)
		local s = hApi.getViewScale() or 1
		ox,oy = ox*s,oy*s
		return x-px-ox,y-py-oy
	end
	return x-ox,y-oy
end


--判断按钮拖拽的点是否在自己的box内部
local __Border,__IsXYInBox
_udb.SetAllButtonBorder = function(_,value)
	if type(value)=="number" then
		if value>0 then
			__Border = value
			__IsXYInBox = function(x,y,tx,ty,bx,by)
				return x>=tx-__Border and x<=bx+__Border and y<=ty+__Border and y>=by-__Border
			end
		else
			__IsXYInBox = function(x,y,tx,ty,bx,by)
				return x>=tx and x<=bx and y<=ty and y>=by
			end
		end
	end
end
_udb:SetAllButtonBorder(hVar.BUTTON_BORDER)


_udb.focusbutton = function(self,oButton,touchX,touchY,tx,ty,bx,by)
	
	local btn = oButton
	local d = self.data
	if tx==nil or ty==nil or bx==nil or by==nil then
		local f = 0
		if d.buttons~=0 then
			for i = #d.buttons,1,-1 do
				if hUI.button:find(d.buttons[i])==btn then
					tx,ty,bx,by = __GetButtonRelBox(d.buttons__ID[i],self)
					f = i
					break
				end
			end
		end
		if f==0 then
			--tx,ty,bx,by = __GetButtonRelPos(oButton,0,0)
			_DEBUG_MSG("[LUA WARNING]无法聚焦dragBox管理以外的button")
			return
		end
	end
	local oBtn = hApi.SetObject({},btn)
	local bd = btn.data
	local ox,oy = d.x,d.y
	local dx,dy = d.x,d.y
	local worldnode = d.worldnode
	local _IsInBox = hVar.RESULT_SUCESS
	local _IsBug = 0
	--这里可能有一个奇怪的BUG
	btn.childUI["__DragBox__"] = hUI.dragBox:new({
		node = 0,
		autoactive = 0,
		autorelease = 1,
		codeOnDrag = function(relX,relY)
			if _IsBug==1 then
				return
			end
			if hApi.GetObject(oBtn)==nil then
				_IsBug = 1
				_DEBUG_MSG("[LUA WARNING!ERROR]按钮被意外删除，请检查代码！")
				return
			end
			local x,y = __GetWorldNodeXY(worldnode,ox,oy,relX,relY)
			local IsInBox = hVar.RESULT_FAIL
			if __IsXYInBox(x,y,tx,ty,bx,by) then
				IsInBox = hVar.RESULT_SUCESS
			end
			if _IsInBox~=IsInBox then
				_IsInBox = IsInBox
				if IsInBox==hVar.RESULT_SUCESS then
					btn:setstate(2,0)
				else
					btn:setstate(1,0)
				end
			end
			if btn.data._codeOnDrag~=0 then
				__btnParamX = x
				__btnParamY = y
				__btnParamSUS = IsInBox
				return xpcall(btn.data._codeOnDrag,hGlobal.__TRACKBACK__)
			end
		end,
		codeOnDrop = function(relX,relY)
			if _IsBug==1 then
				return
			end
			if hApi.GetObject(oBtn)==nil then
				_IsBug = 1
				_DEBUG_MSG("[LUA WARNING!ERROR]按钮被意外删除，请检查代码！")
				return
			end
			local x,y = __GetWorldNodeXY(worldnode,ox,oy,relX,relY)
			--即使自己已经被删了也有可能走到这段代码里面
			if btn.ID~=0 then
				btn:setstate(1,0)
				btn.childUI["__DragBox__"] = nil
				if btn.data._code~=0 then
					if __IsXYInBox(x,y,tx,ty,bx,by) then
						__btnParamX = x
						__btnParamY = y
						__btnParamSUS = hVar.RESULT_SUCESS
						return xpcall(btn.data._code,hGlobal.__TRACKBACK__)
					elseif btn.data.failcall==1 then
						__btnParamX = x
						__btnParamY = y
						__btnParamSUS = hVar.RESULT_FAIL
						return xpcall(btn.data._code,hGlobal.__TRACKBACK__)
					end
				end
			end
		end,
	}):select()
	btn:setstate(2,0)
	if btn.data._codeOnTouch~=0 then
		local x = touchX or btn.data.x
		local y = touchY or btn.data.y
		__btnParamX = x
		__btnParamY = y
		if x>=tx and x<=bx and y<=ty and y>=by then
			__btnParamSUS = hVar.RESULT_SUCESS
		else
			__btnParamSUS = hVar.RESULT_FAIL
		end
		return xpcall(btn.data._codeOnTouch,hGlobal.__TRACKBACK__)
	end
end

local __checkNum2 = {"number","number"}
local __checkNum4 = {"number","number","number","number"}
local __checkTab = {}
_udb.setbox = function(self,x,y,w,h,ox,oy)
	local d = self.data
	if d.index~=0 then
		__checkTab[1],__checkTab[2],__checkTab[3],__checkTab[4] = x,y,w,h
		if hApi.CheckTable(__checkTab,__checkNum4)==hVar.RESULT_SUCESS then
			d.x = x
			d.y = y
			d.w = w
			d.h = h
			local v = hUI.DragBoxList[d.index]
			--神奇的设置~到底是为什么呢~
			v[5],v[6],v[7],v[8] = x,y,w,h
		else
			_DEBUG_MSG("[LUA WARNING]尝试对dragBox设置非法的数值")
		end
		__checkTab[1],__checkTab[2] = ox,oy
		if hApi.CheckTable(__checkTab,__checkNum2)==hVar.RESULT_SUCESS then
			d.ox = ox
			d.oy = oy
			local v = hUI.DragBoxList[d.index]
			v[9],v[10] = ox,oy	--设置box
		end
	end
end

local __box = hUI.DragBoxList
_udb.unselect = function()
	if hUI.DragIndex~=0 then
		local v = __box[hUI.DragIndex]
		if v~=0 and v[2]~=0 then
			local oBox = hUI.dragBox:find(v[2])
			if oBox.data.autorelease==1 then
				local x,y = v[5]-v[11],v[6]-v[12]
				local code = oBox.data.codeOnDrop
				oBox:del()
				if code~=0 then
					code(x,y)
				end
			end
		end
		hUI.DragIndex = 0
	end
	return self
end

_udb.current = function()
	if hUI.DragIndex~=0 then
		local v = __box[hUI.DragIndex]
		if v~=0 and v[2]~=0 then
			local oDragBox = hUI.dragBox:find(v[2])
			if oDragBox~=nil and oDragBox.ID~=0 and oDragBox.data.visitable==1 then
				return oDragBox
			end
		end
	end
end

_udb.isCurrent = function(self)
	if hUI.DragIndex~=0 then
		local v = __box[hUI.DragIndex]
		if v~=0 and v[2]~=0 and self.ID==v[2] then
			return hVar.RESULT_SUCESS
		end
	end
	return hVar.RESULT_FAIL
end

_udb.currentXY = function()
	if hUI.DragIndex~=0 then
		local v = __box[hUI.DragIndex]
		if v~=0 and v[2]~=0 then
			return -1*v[11],-1*v[12],v[13],v[14]
		end
	end
end

_udb.select = function(self)
	--这个接口只有在touch事件中调用才有效！
	local d = self.data
	if d.index~=0 and d.index~=hUI.DragIndex then
		hUI.dragBox:unselect()
		hUI.DragIndex = d.index
	end
	return self
end

_udb.enable = function(self,IsEnable)
	local d = self.data
	if d.index~=0 then
		if IsEnable==1 then
			hUI.DragBoxList[d.index][1] = d.node
		else
			hUI.DragBoxList[d.index][1] = 0
		end
	end
	return self
end

local __box = hUI.DragBoxList
_udb.active = function(self)
	local d = self.data
	local iLast = d.index
	local tData = __box[d.index]
	local IsSelected = 0
	if hUI.DragIndex==d.index then
		IsSelected = 1
	end
	__box[d.index] = 0
	for i = d.index+1,__box.n,1 do
		if __box[i]~=0 then
			__box[iLast] = __box[i]
			__box[i] = 0
			if hUI.DragIndex==i then
				hUI.DragIndex = iLast
			end
			__DBOX__SetNodeZ(__box[iLast],iLast)
			local oTouchBox = hUI.dragBox:find(__box[iLast][2])
			if oTouchBox~=nil then
				oTouchBox.data.index = iLast
			end
			iLast = iLast + 1
		end
	end
	__box.n = iLast
	__box[iLast] = tData
	d.index = iLast
	if IsSelected==1 then
		hUI.DragIndex = d.index
	end
	__DBOX__SetNodeZ(__box[iLast],iLast)
	return self
end
-----------------------------------------------
-- UI函数
-----------------------------------------------
hUI.uiGetXYWH = function(oUI)
	return oUI.data.x,oUI.data.y,oUI.data.w,oUI.data.h
end

hUI.uiSetXY = function(oUI,x,y)
	x = x or oUI.data.x
	y = y or oUI.data.y
	oUI.data.x = x
	oUI.data.y = y
	
	if oUI.handle._n then
		oUI.handle._n:setPosition(x,y)
	end
end

hUI.safeParent = function(p)
	return p or hUI.__static.uiLayer
end

hUI.ReadParam = function(template,p,d)
	for k,v in pairs(template) do
		if k=="parent" then
			d[k] = (p and p[k]) or hUI.__static.uiLayer
		else
			d[k] = (p and p[k]) or v
		end
	end
	return d
end

hUI.deleteUIObject = function(oUI,code)
	local h = oUI.handle
	--if h.batchmode~="child" then
		--_DEBUG_MSG("[LUA WARNING] 尝试特殊删除非 batchImage 的 UI")
	--end
	if code then
		local r1,r2,r3,r4,r5 = code(oUI)
		for k in pairs(h)do
			h[k] = nil
		end
		oUI:del()
		return r1,r2,r3,r4,r5
	else
		for k in pairs(h)do
			h[k] = nil
		end
		return oUI:del()
	end
end

hUI.destroyDefault = function(self)
	local cui = rawget(self,"childUI")
	local h = self.handle
	self.data.parent = 0
	if cui then
		for k,v in pairs(cui)do
			v:del()
			cui[k] = nil
		end
	end

	--先把node解锁
	local _n = h._n
	h._n = nil
	--然后清理一下handle
	if h.batchmode=="child" then
		--如果是batchmode-"child"模式，则删除模式和普通不同
		--image和bar可以属于batchmode--"child"模式
		for k,v in pairs(h)do
			if k~="_bn" and type(v)=="userdata" and v:getParent()~=nil then
				v:getParent():removeChild(v,true)
			end
			h[k] = nil
		end
	else
		for k,v in pairs(h)do
			h[k] = nil
		end
	end
	--最后把node删掉
	if _n~=nil then
		_n:removeAllChildrenWithCleanup(true)
		if _n:getParent()~=nil then
			_n:getParent():removeChild(_n,true)
		end
	end
end

hUI.destroyDefaultU = function(self)
	local d = self.data
	if d.bindU and d.bindU~=0 then
		local u = hClass.unit:find(d.bindU)
		if u and u.chaUI[d.bindTag]==self then
			u.chaUI[d.bindTag] = nil
		end
		d.bindU = 0
		d.bindTag = 0
	end
	return hUI.destroyDefault(self)
end

hUI.destroyDefaultW = function(self)
	local d = self.data
	if d.bindW and d.bindW~=0 then
		local w = hClass.world:find(d.bindW)
		if w and w.worldUI[d.bindTag]==self then
			w.worldUI[d.bindTag] = nil
		end
		d.bindW = 0
		d.bindTag = 0
	end
	return hUI.destroyDefault(self)
end

--hUI.setMotion = function(pSprite,baseX,baseY,tMotion)
--	if tMotion and tMotion~=0 and type(tMotion)=="table" and pSprite then
--		local aArray = CCArray:create()
--		for i = 1,#tMotion do
--			local px,py,dur = unpack(tMotion[i])
--			if type(px)=="number" and type(py)=="number" then
--				if type(dur)~="number" then
--					dur = 0.1
--				end
--				aArray:addObject(CCMoveTo:create(dur,ccp(baseX+px,baseY+py)))
--			end
--		end
--		local seq = tolua.cast(CCSequence:create(aArray),"CCActionInterval")
--		pSprite:runAction(CCRepeatForever:create(seq))
--	end
--end

hUI.setMotion = function(pSprite,baseX,baseY,tMotion)
	if tMotion and tMotion~=0 and type(tMotion)=="table" and pSprite then
		if type(tMotion[1])=="table" then
			--不停移动
			local aArray = CCArray:create()
			for i = 1,#tMotion do
				local px,py,dur = unpack(tMotion[i])
				if type(px)=="number" and type(py)=="number" then
					if type(dur)~="number" then
						dur = 0.1
					end
					aArray:addObject(CCMoveTo:create(dur,ccp(baseX+px,baseY+py)))
				end
			end
			local seq = tolua.cast(CCSequence:create(aArray),"CCActionInterval")
			pSprite:runAction(CCRepeatForever:create(seq))
		elseif tMotion[1]=="breath" then
			--呼吸(一大一小)
			local dur,rev,size = tMotion[2],tMotion[3],tMotion[4]
			if type(dur)=="number" and type(rev)=="number" and type(size)=="number" then
				local aArray = CCArray:create()
				aArray:addObject(CCScaleTo:create(dur,size))
				aArray:addObject(CCScaleTo:create(rev,1.0))
				local seq = tolua.cast(CCSequence:create(aArray),"CCActionInterval")
				pSprite:runAction(CCRepeatForever:create(seq))
			end
		end
	end
end


hUI.bindWithUnit = function(self,u)
	local d = self.data
	d.bindU = u.ID
	if u.chaUI[d.bindTag] then
		u.chaUI[d.bindTag].data.bindU = 0
		u.chaUI[d.bindTag]:del()
	end
	u.chaUI[d.bindTag] = self
end

hUI.clearHandleTable = function(self)
	local h = self.handle
	for k,v in pairs(h)do
		h[k] = nil
	end
end

hUI.createNode = function(self)
	self.handle._n = CCNode:create()
	self.handle._n:setPosition(self.data.x,self.data.y)
	self.data.parent:addChild(self.handle._n,self.data.z or 0)
	return self.handle._n
end

local _tokenChildT = {}
hUI.createChildUI = function(self,childT)
	if childT and childT~=0 then
		if type(childT[1])~="table" then
			_tokenChildT[1] = childT
			childT = _tokenChildT
		end
		local _childUI = self.childUI
		local count = 0
		local lastName
		local lastUI
		for i = 1,#childT do
			local v = childT[i]
			if v.__NAME==nil then
				v.__NAME = "childUI_"..i
			end
			if not(_childUI[v.__NAME]) and v.__UI and hUI[v.__UI] then
				if lastUI=="label" and (v.__plusX or v.__plusY) then
					local w,h = _childUI[lastName]:getWH()
					if v.__plusX then
						v.x = (v.x or 0) + w + v.__plusX
					end
					if v.__plusY then
						v.y = (v.y or 0) - h + v.__plusY
					end
				end
				lastName = v.__NAME
				lastUI = v.__UI
				if v.mode=="batchImage" then
					if v.parent==nil and self.handle._bn~=nil then
						v.parent = self.handle._bn
					end
				else
					v.parent = self.handle._n
				end
				--针对imageButton的特殊处理
				if v.__UI=="button" or (v.__UI=="grid" and (v.mode=="button" or v.mode=="imageButton")) then
					v.dragbox = v.dragbox or _childUI["dragBox"]
				end
				_childUI[v.__NAME] = hUI[v.__UI]:new(v)
				count = count + 1
			end
		end
		return hVar.RESULT_SUCESS
	end
	return hVar.RESULT_FAIL
end


--======================================================================
--对齐方式
--======================================================================
local __Align = hVar.UI_ALIGN
--======================================================================
--图像
--======================================================================
hUI.image = eClass:new("static")
local _uimg = hUI.image
local __DefaultParam = {
	parent = 0,--hUI.__static.uiLayer,
	mode = "model",		--"model","image","batch","batchImage","file","portrait"
	model = "MODEL:default",
	id = 0,			--仅用于记录
	mask = 0,
	animation = 0,
	_animation = 0,
	motion = 0,		--仅图片有效，生成后图片会自动跳动
	align = "LT",
	facing = -1,
	x = 0,
	y = 0,
	z = 0,
	w = -1,
	h = -1,
	scale = 1,
	child = 0,
	smartWH = 0,		--指定这一项==1后，无论x,y都只会使用最小的坐标来缩放，以确保缩放在格子里,只有w,h都不等于0且image,model或者file才有效
	anchor = 0,		--这一项如果等于table，那么强制使用此值设置anchor点
	IsTemp = 0,		--如果这一项==1那么该model所对应的资源将会被释放
	alpha = 0,
	color = 0,		--zhenkira, 新增
}
_uimg.destroy = function(self)
	local d = self.data
	--内存清理:释放不需要的表格
	d.child = 0
	d.model = 0
	d.animation = 0
	d._animation = 0
	d.motion = 0
	return hUI.destroyDefault(self)
end
_uimg.init = function(self,p)
	self.data = hUI.ReadParam(__DefaultParam,p,rawget(self,"data") or {})
	self.handle = hApi.clearTable("H",self.handle)
	self.childUI = hApi.clearTable(0,self.childUI)
	local h = self.handle
	local d = self.data
	h.__IsTemp = d.IsTemp
	d.x,d.y = math.floor(d.x),math.floor(d.y)
	if d.mode=="batchImage" then
		--注意，batchImage的父节点必须是batchnode，并且batchImage上不能再添加任何child，否则直接弹掉
		--而且batchImage的纹理必须和父节点相同
		--batchImage只有单帧图片
		--这种模式下是没有self.handle.s的
		h.batchmode = "child"
		if type(p.parent)~="userdata" then
			_DEBUG_MSG("[LUA ERROR]batch image: "..d.model.." 必须拥有一个合法的parent!")
			return
		end
		local _,tabM = hApi.SpriteSetBatchParent(h,d.model,d.parent)
		h._n = hApi.SpriteBatchNodeAddChild(h,d.animation,d.align,d.w,d.h)
		h._n:setPosition(d.x,d.y)
		local tMotion = d.motion
		if tMotion==0 then
			tMotion = tabM.motion
		end
		self:setMotion(tMotion)
	elseif d.mode=="batch" then
		h.batchmode = "batch"
		local _,tabM = hApi.SpriteInitBatchNode(h,d.model)
		if p~=nil and p.model then
			h.s,d.w,d.h = hApi.SpriteBatchNodeAddChild(h,d.animation,d.align,d.w,d.h)
		end
		if d.child~=0 and type(d.child)=="table" then
			for i = 1,#d.child do
				local v = d.child[i]
				if v.model then
					hApi.SpriteSetBatchParent(h,v.model,h._bn)
					local s = hApi.SpriteBatchNodeAddChild(h,v.animation or __DefaultParam.animation,v.align or animation.align,v.w or __DefaultParam.w,v.h or __DefaultParam.h)
					s:setPosition(v.x or 0,v.y or 0)
					h["_bc_"..i] = s
				end
			end
		end
		--hApi.setModel(h,d.model,-1)
		h._n = CCNode:create()
		h._n:addChild(h._bn)
		h._n:setPosition(d.x,d.y)
		d.parent:addChild(h._n,d.z)
		local tMotion = d.motion
		if tMotion==0 then
			tMotion = tabM.motion
		end
		self:setMotion(tMotion)
	else
		if d.mode=="model" then
			--一般的model
			h.s = CCSprite:create()
			h._n = h.s
			h.animation = 0
			h._n:setPosition(d.x,d.y)
			d.parent:addChild(h._n,d.z)
			self:setmodel(d.model,nil,nil,nil,nil,1)
		elseif d.mode=="file" then
			--读取单张图片专用(一般是给xlobj的)
			if type(d.model)=="string" then
				h.s = xlCreateSprite(d.model)
				hUI.CheckImagePath("image",self,d.model)
			end
			if h.s==nil then
				h.s = xlCreateSprite("data/image/misc/mask.png")
				if h.s==nil then
					h.s = CCSprite:create()
				end
			else
				local size = h.s:getContentSize()
				if size then
					local sizeW,sizeH = size.width,size.height
					local imageW,imageH = d.w,d.h
					if d.smartWH==2 and sizeW<=imageW and sizeH<=imageH then
						imageW = -1
						imageH = -1
					elseif d.smartWH>0 then
						if imageW>0 and imageW>0 and sizeW and sizeH then
							if sizeW<=sizeH then
								imageW = -1
							else
								imageH = -1
							end
						end
					end
					
					if __Align[d.align] then
						local v = __Align[d.align]
						h.s:setAnchorPoint(ccp(v[1]/2,v[2]/2))
					end
					
					--添加mask
					if d.mask ~= 0 and type(d.mask) == "string" and h.s then
						local mask = xlCreateSprite(d.mask)
						if mask then
							h.s:addChild(mask)
							mask:setPosition(size.width/2,size.height/2)
						end
					end
					
					local _
					_,_,d.w,d.h = hApi.SpriteSetScaleByWH(h,d.scale,imageW,imageH,sizeW,sizeH)
				end
			end
			h._n = h.s
			h._n:setPosition(d.x,d.y)
			d.parent:addChild(h._n,d.z)
			self:setMotion(d.motion)
		else--if d.mode=="image" then
			--这种只支持单帧图片,使用第一帧的
			local tabM = hApi.setModel(h,d.model)
			h.s,d.w,d.h = hApi.SpriteLoadOneFrame(h,d.animation,d.scale,d.align,d.w,d.h)
			if __Align[d.align] then
				local v = __Align[d.align]
				h.s:setAnchorPoint(ccp(v[1]/2,v[2]/2))
			end
			h._n = h.s
			h._n:setPosition(d.x,d.y)
			d.parent:addChild(h._n,d.z)
			local tMotion = d.motion
			if tMotion==0 then
				tMotion = tabM.motion
			end
			self:setMotion(tMotion)
		end
	end
	
	d.alpha = p.alpha or 0
	--如果透明通道非0
	if d.alpha ~= 0 then
		h.s:setOpacity(d.alpha)
	end
	--设置颜色混合
	local color = d.color
	if color~=nil and type(color)=="table" and #color==3 then
		h.s:setColor(ccc3(color[1],color[2],color[3]))
	end
end

--设定Image的位置    added by pangyong 2015/4/28
_uimg.setXY = function(self,x,y)
	local d = self.data
	local h = self.handle

	--将数据保存到表中
	d.x = x
	d.y = y

	--设定位置
	h._n:setPosition(d.x,d.y)
end

_uimg.setalign = function(self,align)
	local d = self.data
	local h = self.handle
	if align and __Align[align] then
		d.align = align
		local v = __Align[d.align]
		h.s:setAnchorPoint(ccp(v[1]/2,v[2]/2))
	end
end

_uimg.setMotion = function(self,tMotion)
	return hUI.setMotion(self.handle._n,self.data.x,self.data.y,tMotion)
end

_uimg.setmodel = function(self,model,animation,facing,newW,newH,IsForceToSet,OnlySafeAnimation)
	local h = self.handle
	local d = self.data
	IsForceToSet = IsForceToSet or 1
	if d.mode=="model" and model~=nil then
		local oModel = d.model
		d.model = model
		if animation~=nil then
			d.animation = animation
			if d._animation~=0 then
				d._animation = animation
			end
		end
		if type(facing)=="number" then
			d.facing = facing
		end
		if IsForceToSet==1 then
			hApi.setModel(h,d.model,d.facing)
		end
		local animation = d.animation
		local aniKey,IsSafe,tabM = hApi.safeAnimation(h,animation)
		local modelmode = tabM.modelmode
		if modelmode~=nil and modelmode~=0 and aniKey~=animation and d._animation~=0 then
			local _animation = "DIRECTION:"..hApi.calAngleD(modelmode,d.facing).."_"..d._animation
			if type(tabM[_animation])=="table" then
				aniKey = _animation
				IsSafe = hVar.RESULT_SUCESS
			end
		end
		if OnlySafeAnimation==1 and IsSafe~=hVar.RESULT_SUCESS then
			return
		end
		hUI.CheckImagePath("image",self,tabM.image)
		local NeedResize = 0
		if d.facing>=0 then
			if h.animation==aniKey and oModel==d.model then
				NeedResize = 0
				if h.modelmode==0 then
					hApi.ObjectSetFacing(h,d.facing,IsForceToSet)
				end
			else
				NeedResize = 1
				if h.modelmode==0 then
					--x方向模型模式
					--如果2方向模型则需要先播放一次，否则只处理旋转
					hApi.SpritePlayAnimation(h,aniKey,nil,IsForceToSet)
					hApi.ObjectSetFacing(h,d.facing,IsForceToSet)
				else
					h._animation = animation
					hApi.ObjectSetFacing(h,d.facing,IsForceToSet)
				end
			end
		else
			NeedResize = 1
			hApi.SpritePlayAnimation(h,aniKey,nil,IsForceToSet)
		end
		if h.s and d.anchor~=0 then
			h.s:setAnchorPoint(ccp(d.anchor[1],1-d.anchor[2]))
		end
		local _,_,sizeW,sizeH = unpack(tabM[aniKey][1])
		if NeedResize==1 then
			if sizeW<=0 then
				sizeW = 256
			end
			if sizeH<=0 then
				sizeH = 256
			end
			if type(newW)=="number" and type(newH)=="number" then
				d.w = newW
				d.h = newH
			end
			if d.w<0 and d.h<0 and d.scale~=1 then
				_,_,d.w,d.h = hApi.SpriteSetScaleByWH(h,1,sizeW*d.scale,sizeH*d.scale,sizeW,sizeH)
			else
				local imageW,imageH = d.w,d.h
				if d.smartWH==2 and sizeW<=imageW and sizeH<=imageH then
					imageW = -1
					imageH = -1
				elseif d.smartWH>0 then
					if imageW>0 and imageH>0 and sizeW and sizeH then
						if sizeW<=sizeH then
							imageW = -1
						else
							imageH = -1
						end
					end
				end
				_,_,d.w,d.h = hApi.SpriteSetScaleByWH(h,1,imageW*d.scale,imageH*d.scale,sizeW,sizeH)
			end
		end
		local tMotion = d.motion
		if tMotion==0 then
			tMotion = tabM.motion
		end
		self:setMotion(tMotion)
		return tabM
	end
end

_uimg.setfacing = function(self,facing)
	local h = self.handle
	local d = self.data
	if d.mode=="model" and facing~=nil then
		d.facing = tonumber(facing)
		if h.modelmode==0 then
			--一般的model
			hApi.ObjectSetFacing(h,d.facing)
		else
			self:setmodel(d.model,nil,nil,nil,nil,0)
		end
	end
end
--======================================================================
--bar
--======================================================================
hUI.bar = eClass:new("static")
local _ubar = hUI.bar
local __DefaultParam = {
	parent = 0,--hUI.__static.uiLayer,
	mode = "bar",	--"bar","batchImage"
	model = "MODEL:default",
	align = "MC",
	x = 0,
	y = 0,
	z = 0,
	w = -1,
	h = -1,
	lx = 0,
	rx = 0,
	v = 1,
	vmax = 1,
	cut = 0,
}
_ubar.destroy = hUI.destroyDefault
_ubar.init = function(self,p)
	self.data = hUI.ReadParam(__DefaultParam,p,rawget(self,"data") or {})
	self.handle = hApi.clearTable(0,self.handle)
	self.childUI = hApi.clearTable(0,self.childUI)
	local h = self.handle
	local d = self.data
	--local tabM = hApi.setModel(h,d.model)
	--h._n = CCNode:create()
	--h._n:setPosition(d.x,d.y)
	--d.parent:addChild(h._n,d.z)

	--if d.h<=0 then
		--d.h = -1
	--end

	--local d_h = nil
	--h.sL,h.wL, d.h,h.scaleL = hApi.SpriteLoadOneFrame(h,"L",1,"LB",-1,d.h)
	--h.sR,h.wR, d_h,h.scaleR = hApi.SpriteLoadOneFrame(h,"R",1,"RB",-1,d.h)

	--if d.cut==1 and d.w>0 and d.w-h.wL-h.wR>0 then
		--h.sC,h.wC, d_h,h.scaleC = hApi.SpriteLoadOneFrame(h,"M",1,"LB",-1,d.h,nil,d.w-h.wL-h.wR)
	--else
		--h.sC,h.wC, d_h,h.scaleC = hApi.SpriteLoadOneFrame(h,"M",1,"LB",-1,d.h)
	--end

	--local w = d.w
	--d.w = -1
	--self:setW(w)
	if d.mode=="batchImage" then
		--注意，batchImage的父节点必须是batchnode，并且batchImage上不能再添加任何child，否则直接弹掉
		--而且batchImage的纹理必须和父节点相同
		--batchImage只有单帧图片
		--这种模式下是没有self.handle.s的
		h.batchmode = "child"
		if type(p.parent)~="userdata" then
			_DEBUG_MSG("[LUA ERROR]batch image: "..d.model.." 必须拥有一个合法的parent!")
			return
		end
		hApi.SpriteSetBatchParent(h,d.model,d.parent)
	else
		hApi.SpriteInitBatchNode(h,d.model)
		h.s = h._bn
		h._n = CCNode:create()
		h._n:addChild(h._bn)
		h._n:setPosition(d.x,d.y)
		d.parent:addChild(h._n,d.z)
	end
	if d.h<=0 then
		d.h = -1
	end
	local d_h = nil
	
	h.sL,h.wL, d.h,h.scaleL = hApi.SpriteBatchNodeAddChild(h,"L","LB",-1,d.h)
	h.sR,h.wR, d_h,h.scaleR = hApi.SpriteBatchNodeAddChild(h,"R","RB",-1,d.h)
	
	if d.cut==1 and d.w>0 and d.w-h.wL-h.wR>0 then
		h.sC,h.wC, d_h,h.scaleC = hApi.SpriteBatchNodeAddChild(h,"M","LB",-1,d.h,nil,d.w-h.wL-h.wR)
	else
		h.sC,h.wC, d_h,h.scaleC = hApi.SpriteBatchNodeAddChild(h,"M","LB",-1,d.h)
	end
	local w = d.w
	d.w = -1
	self:setW(w)
end

_ubar.setW = function(self,w)
	local d = self.data
	local h = self.handle
	local ox,oy = 0,0
	if d.w==w then
		return
	end
	d.w = w+0
	if d.mode=="batchImage" then
		ox,oy = d.x,d.y
	end
	local aW,aH = 1,1
	if __Align[d.align] then
		aW,aH = __Align[d.align][1],__Align[d.align][2]
		aW = 2-aW
		aH = 2-aH
	end
	if h.sC==nil then
		return
	end
	h.sC:setVisible(true)
	h.sL:setVisible(true)
	h.sR:setVisible(true)
	h.sL:setPosition(ox+d.lx+d.w*(aW-2)/2,		oy+d.h*(aH-2)/2)
	h.sR:setPosition(ox+d.rx+d.w*(aW)/2,		oy+d.h*(aH-2)/2)
	local bw = h.wL+h.wR
	if bw<d.w then
		local _w = d.w-h.wL-h.wR
		local _scaleC = h.scaleC*_w/h.wC
		h.sC:setPosition(ox+d.lx+d.w*(aW-2)/2+h.wL,	oy+d.h*(aH-2)/2)
		h.sC:setScaleX(_scaleC)
		h.sL:setScaleX(h.scaleL)
		h.sL:setScaleX(h.scaleR)
	else
		if d.w>1 then
			h.sC:setVisible(false)
			h.sL:setScaleX(h.scaleL*d.w/bw)
			h.sR:setScaleX(h.scaleR*d.w/bw)
		else
			h.sC:setVisible(false)
			h.sL:setVisible(false)
			h.sR:setVisible(false)
		end
	end
end

--仿照valbar   add by pangyong 2016/1/12
_ubar.setV = function(self, v, maxV, onlyGetValue)
	local d = self.data

	--必须设置最大长度
	if 0 == d.maxw or nil == v or nil == maxV or nil == self.childUI["Label_Num"] then
		self.childUI["Label_Num"]:setText("-1/-1")
		self:setW(0)
		return 
	end

	--设置label数值
	local nResult = 0
	if 0 > maxV or 0 > v then
		--分母 或 分子 小于0
		nResult = 0
		self.childUI["Label_Num"]:setText("0/0")
	elseif maxV == 0 then
		--分母 为 0（已满用于满级的情况）
		nResult = d.maxw
		self.childUI["Label_Num"]:setText(v)
	elseif maxV < v then
		--分子 大于 分母
		nResult = d.maxw
		self.childUI["Label_Num"]:setText(v.."/"..maxV)
	else
		--正常情况
		nResult = math.ceil((d.maxw*v)/maxV)
		self.childUI["Label_Num"]:setText(v.."/"..maxV)
	end

	if 1 == onlyGetValue then
		--返回计算的长度值（用于设置 游标 的位置）
		return nResult
	else
		--设置bar的长度
		self:setW(nResult)
	end
end

--设置颜色
_ubar.setColor = function(self,c3)
	local h = self.handle
	if h.sC then
		h.sC:setColor(c3)
	end
	if h.sL then
		h.sL:setColor(c3)
	end
	if h.sR then
		h.sR:setColor(c3)
	end
	
	--如果侧bar是用作 类valbar的小部件上，如果有文字，同样设置颜色
	if self.childUI["Label_Num"] then
		self.childUI["Label_Num"].handle.s:setColor(c3)
	end
end

--为var添加动作
_ubar.enumSprite = function(self,code,p1,p2,p3,p4,p5,p6,p7,p8)
	local h = self.handle
	if h.sC then
		code(h.sC,p1,p2,p3,p4,p5,p6,p7,p8)
	end
	if h.sL then
		code(h.sL,p1,p2,p3,p4,p5,p6,p7,p8)
	end
	if h.sR then
		code(h.sR,p1,p2,p3,p4,p5,p6,p7,p8)
	end
end

_ubar.setXY = function(self,x,y)
	local d = self.data
	local h = self.handle

	--将数据保存到表中
	d.x = x
	d.y = y

	--设定位置
	h._n:setPosition(d.x,d.y)
end

--======================================================================
--valbar
--======================================================================
hUI.valbar = eClass:new("static")
local _uvbr = hUI.valbar
local __DefaultParam = {
	parent = 0,--hUI.__static.uiLayer,
	model = "MODEL:default",
	animation = "normal",
	back = 0,
	image = 0,
	align = "LC",
	x = 0,
	y = 0,
	z = 0,
	w = 0,
	h = 0,
	v = 1,
	curW = 0,
	max = 1,
}
_uvbr.destroy = hUI.destroyDefault
_uvbr.init = function(self,p)
	self.data = hUI.ReadParam(__DefaultParam,p,rawget(self,"data") or {})
	self.handle = hApi.clearTable(0,self.handle)
	self.childUI = hApi.clearTable(0,self.childUI)
	--这种只支持单帧图片,使用第一帧的
	local h = self.handle
	local d = self.data
	d.rect = d.rect or {}
	local scale = 1
	if d.back~=0 and type(d.back)=="table" and type(d.back.model)=="string" then
		h._n = CCNode:create()
		local b = d.back
		local bw,bh
		hApi.setModel(h,b.model)
		h._sB = hApi.SpriteLoadOneFrame(h,b.animation or "normal",scale,d.align,b.w or -1,b.h or -1)
		h._sB:setPosition(b.x or 0,b.y or 0)
		h._n:addChild(h._sB)

		hApi.setModel(h,d.model)
		h.s = hApi.SpriteLoadOneFrame(h,d.animation,scale,d.align,d.w,d.h,d.rect)
		h._n:addChild(h.s)
	else
		hApi.setModel(h,d.model)
		h.s = hApi.SpriteLoadOneFrame(h,d.animation,scale,d.align,d.w,d.h,d.rect)
		h._n = h.s
	end
	h._n:setPosition(d.x,d.y)
	d.parent:addChild(h._n,d.z)
	if type(d.align)=="string" then
		d._align = string.sub(d.align,1,1) or "L"
	else
		d._align = "L"
	end
	local v = d.v
	d.v = d.max
	self:setV(v)
end

_uvbr.setV = function(self,v,maxV)
	local d = self.data
	local h = self.handle
	local maxV = maxV or d.max
	if d.v==v and d.max==maxV then
		return
	end
	local r = self.data.rect
	d.max = maxV+0
	d.v = math.max(math.min(v+0,d.max),0)
	local clip = r.w
	if d.max>0 then
		clip = hApi.getint(r.w*(d.max-d.v)/d.max)
	end
	if clip+1>r.w then
		h.s:setVisible(false)
	else
		h.s:setVisible(true)
	end
	d.curW = hApi.getint(d.w*(d.max-d.v)/d.max)
	if d._align=="R" then
		h.s:setTextureRect(CCRectMake(r.x+clip,r.y,r.w-clip,r.h))
	elseif d._align=="M" then
		h.s:setTextureRect(CCRectMake(r.x+math.floor(clip/2),r.y,r.w-math.floor(clip/2),r.h))
	else--if d._align=="L" then
		h.s:setTextureRect(CCRectMake(r.x,r.y,r.w-clip,r.h))
	end
end
--======================================================================
--timerbar
--======================================================================
hUI.timerbar = eClass:new("static")
local _utbr = hUI.timerbar
local __DefaultParam = {
	parent = 0,--hUI.__static.uiLayer,
	type = hVar.UI_TIMERBAR_TYPE.kCCProgressTimerTypeRadialCW,
	model = "MODEL:default",
	animation = "normal",
	align = "MC",
	x = 0,
	y = 0,
	z = 0,
	w = 0,
	h = 0,
	color = 0,
	alpha = 0,
	callback = hApi.DoNothing,
	scale = 1,
}
_utbr.destroy = hUI.destroyDefault

_utbr.init = function(self,p)
	self.data = hUI.ReadParam(__DefaultParam,p,rawget(self,"data") or {})
	self.handle = hApi.clearTable(0,self.handle)
	self.childUI = hApi.clearTable(0,self.childUI)

	local h = self.handle
	local d = self.data
	d.rect = d.rect or {}

	hApi.setModel(h,d.model)
	h.s = hApi.SpriteLoadOneFrame(h,d.animation,d.scale,d.align,d.w,d.h,d.rect)
	--如果透明通道非0
	if d.alpha ~= 0 then
		h.s:setOpacity(d.alpha)
	end
	--设置颜色混合
	local color = d.color
	if color~=nil and type(color)=="table" and #color==3 then
		h.s:setColor(ccc3(color[1],color[2],color[3]))
	end

	h._n = CCProgressTimer:create(h.s)
	--h._n:setType(CCProgressTimerType(d.type))
	h._n:setType(d.type)
	h._n:setPercentage(100)
	h._n:setPosition(d.x,d.y)
	h._n:setScale(d.scale)
	d.parent:addChild(h._n,d.z)
	

	if type(d.align)=="string" then
		d._align = string.sub(d.align,1,1) or "L"
	else
		d._align = "L"
	end
end

_utbr.start = function(self, time, starting, ending)
	
	--print("____________________utbr.start:".. tostring(time))
	local d = self.data
	local h = self.handle
	
	if h._a then
		h._n:stopAction(h._a)
		CCDirector:sharedDirector():getActionManager():removeAction(h._a)
		h._a = nil
	end 
	
	local function _removeAni()
		if h._a then
			h._n:stopAction(h._a)
			CCDirector:sharedDirector():getActionManager():removeAction(h._a)
			h._a = nil
		end
		
		if d.callback and type(d.callback) == "function" then
			d.callback()
		end
	end
	
	if time and time > 0 then
		d.time = time or 0
	end
	
	if d.time == 0 then
		_removeAni()
		return
	end
	
	if ((starting or 0) >= (ending or 100) or (starting or 0) >= 100) then
		h._n:setPercentage(100)
		_removeAni()
		return
	end
	
	--h._n:setPercentage(0)
	
	--转圈的CD实现
	--local t  = CCProgressTo:create(d.time,100)
	local t  = CCProgressFromTo:create(d.time,(starting or 0),(ending or 100))
	--local t  = CCProgressFromTo:create(d.time,0,100)
	--h._n:runAction(CCRepeatForever:create(t))
	
	h._a = CCSequence:createWithTwoActions(t,CCCallFunc:create(_removeAni))
	h._n:runAction(h._a)
end

_utbr.setPercentage = function(self, val)
	local h = self.handle
	h._n:setPercentage(val)
end

--======================================================================
--按钮
--======================================================================
hUI.button = eClass:new("static")
local _ubtn = hUI.button
local __DefaultParam = {
	parent = 0,--hUI.__static.uiLayer,
	userdata = 0,
	mode = "button",	--["button"]
	animation = 0,		--[string][{"normal","selected","disable"}]
	ox = 0,
	oy = 0,
	x = 0,
	y = 0,
	z = 0,
	w = 0,
	h = 0,
	smartWH = 0,
	sizeW = 0,
	sizeH = 0,
	align = "NONE",
	scale = 1,
	scaleT = 1,			--点击按钮时，按钮的放缩比例（一般填写0.9）
	model = "UI:BTN_ButtonRed",	--"MODEL:default",
	label = 0,
	labelX = 0,			--如果指定此值，label将向右侧偏移，如果有icon的话会将此值加上icon的宽度
	icon = 0,			--如果指定了此值，将在最左端添加一个小图标
	iconX = 0,			--icon在X轴上的偏移量
	iconY = 0,			--icon在Y轴上的偏移量
	iconZ = 1,
	iconWH = 0,			--如果制定了此值，将使用此值作为图标的大小
	font = hVar.DEFAULT_FONT,
	border = 0,
	state = 1,
	code = 0,		--弹起的触发函数[image:(self,x,y,sus)][其他:(self)]
				--注意:此处传入的x,y为相对于按钮父节点的(x,y)也就是说相对于按钮的坐标就是(x-d.x,y-d.y)
	failcall = 0,		--即使弹起时不在矩形区域内，也会给回调，同时会给出结果成功或失败(仅image模式有效)
	codeOnTouch = 0,	--按下的触发函数(仅image模式有效，不要乱用这个)[image:(self,x,y)]
	codeOnDrag = 0,		--拖拽时的触发函数(仅image模式有效，不要乱用这个)[image:(self,x,y)]
	checkbox = 0,		--如果指定了checkbox，那么会出现勾选框
	dragbox = 0,		--必须传，不然这个按钮不能点击
	------------
	-- 创建后自动生成的值
	--_code = 0,
	--_codeOnTouch = 0,
	--_codeOnDrag = 0,
	--scaleX = 1,
	--scaleY = 1,

	--anchorX = nil,
	--anchorY = nil,
}
local __ButtonAnimation = {
	"normal",
	"selected",
	"disable",
}
local __ButtonAnimationToken = {}
_ubtn.destroy = function(self)
	local d = self.data
	if d.dragbox==hGlobal.UI.UI_DragBox and d.parent==hUI.__static.uiLayer then
		hGlobal.UI.UI_DragBox:sortbutton()
	end
	d.dragbox = 0
	--内存清理:移除不需要的函数
	d.code = 0
	d.codeOnTouch = 0
	d.codeOnDrag = 0
	d._code = 0
	d._codeOnTouch = 0
	d._codeOnDrag = 0
	--内存清理:移除不需要的表格
	d.model = 0
	d.animation = 0
	d.userdata = 0
	d.label = 0
	d.icon = 0
	d.font = 0
	d.border = 0
	self.handle._cho = nil
	self.handle._cbg = nil
	return hUI.destroyDefault(self)
end
_ubtn.init = function(self,p)
	self.data = hUI.ReadParam(__DefaultParam,p,rawget(self,"data") or {})
	self.handle = hApi.clearTable("H",self.handle)
	self.childUI = hApi.clearTable(0,self.childUI)
	local h = self.handle
	local d = self.data
	--按钮才能识别parent为table的情况
	if type(p.parent)=="table" then
		d.parent = p.parent.handle._n
		d.dragbox = p.parent.childUI.dragBox
	end
	d._code = 0		--弹起的触发函数
	d._codeOnTouch = 0	--按下的触发函数(仅image模式有效，不要乱用这个)
	d._codeOnDrag = 0	--拖拽时的触发函数(仅image模式有效，不要乱用这个)
	local _,_,sizeW,sizeH = 0,0,1,1
	d.mode = "imageButton"
	if d.parent==hUI.__static.uiLayer and d.dragbox==0 then
		d.dragbox = hGlobal.UI.UI_DragBox or 0
	end
	--现在只支持imageButton了
	h._n = CCNode:create()
	if d.model==-1 then
	else
		self:loadsprite()
	end
	--如果指定了icon，那么会在左端添加一个icon
	if d.icon~=0 then
		local iconWH = d.iconWH
		local ox = self:getTLXY()
		if iconWH<=0 then
			iconWH = math.min(d.w,d.h)
		end
		local plusX2 = math.max(0,d.h-iconWH)
		self.childUI["icon"] = hUI.image:new({
			parent = h._n,
			model = d.icon,
			x = ox-d.x+math.floor((iconWH+plusX2)/2)+d.iconX,
			y = d.iconY,
			w = iconWH,
			h = iconWH,
			z = d.iconZ,
			smartWH = 1,
		})
		local iconW = self.childUI["icon"].data.w
		if d.labelX==0 then
			d.labelX = self.childUI["icon"].data.w + d.iconX-- + math.floor(plusX2/2)
		end
	end
	self:setstate(d.state,1)

	--添加文字
	if d.label~=0 then
		self:loadlabel(d.label)
	end

	h._n:setPosition(d.x,d.y)
	d.parent:addChild(h._n,d.z)
	--添加触摸事件(image)
	hUI.RegisterButtonCode(self,"code")
	hUI.RegisterButtonCode(self,"codeOnTouch")
	hUI.RegisterButtonCode(self,"codeOnDrag")
	--imageButton只能在dragbox存在的时候被触发
	if d.dragbox~=0 then
		d.dragbox:addbutton(self,d.ox,d.oy)
	elseif d.parent==__DefaultParam.parent then
		--直接创建在UI层上的按钮使用默认dragbox
		hGlobal.UI.UI_DragBox:addbutton(self,d.ox,d.oy)
	end
	if d.checkbox~=0 then
		self:setCheckBox(d.checkbox)
	end
end

_ubtn.setXY = function(self,x,y,moveTime)
	local d = self.data
	local h = self.handle
	d.x = type(x)=="number" and x or d.x
	d.y = type(y)=="number" and y or d.y
	if moveTime and type(moveTime)=="number" and moveTime>0 then
		h._n:runAction(CCMoveTo:create(moveTime,ccp(d.x,d.y)))
	else
		h._n:setPosition(d.x,d.y)
	end
	
	self:update()
end
--自身的刷新方法
_ubtn.update = function(self)
	local d = self.data
	if d.dragbox~=0 then
		--local ox, oy = self:getTLXY()
		--local ox = -1*d.x
		--local oy = math.floor(hVar.SCREEN.h-d.y)
		--d.ox = ox
		--d.oy = oy
		d.dragbox:setbutton(self,d.ox,d.oy)
	end
end

_ubtn.setstate = function(self,state,forceToSet)
	--print("_ubtn.setstate", tostring(self),state,forceToSet)
	
	local d = self.data
	local h = self.handle
	local oState = d.state
	--系统调用的话，如果state已经是0了就什么都不做
	if oState==0 and forceToSet==0 then
		return
	end
	d.state = state
	if (oState==d.state and forceToSet~=1) then
		--print("不重复设置")
		--print(debug.traceback())
		return
	end
	if oState==-1 and d.state~=-1 and h._n~=nil then
		h._n:setVisible(true)
	end
	if forceToSet~=0 and d.state==2 then
		--非系统调用状态下设置state==2仅处理缩放，不做任何状态改变处理
		d.state = 1
		local oriSize,hovSize = 1,d.scaleT
		if hovSize~=oriSize and hovSize~=0 then
			local aArray = CCArray:create()
			aArray:addObject(CCScaleTo:create(0.09,hovSize,hovSize))
			aArray:addObject(CCScaleTo:create(0.09,oriSize,oriSize))
			self.handle._n:runAction(CCSequence:create(aArray))
		end
	else
		if h[1]~=nil then
			if h[1]==h[2] and h[1]==h[3] then
				if (oState==1 and d.state==2) or (oState==2 and d.state==1) then
					--在1和2之间来回切换不变色
				else
					local _state = (d.state~=1 and d.state~=2) and 3 or d.state
					if _state~=3 then
						h[1]:setColor(ccc3(255,255,255))
						if self.childUI["label"] then
							self.childUI["label"].handle.s:setColor(ccc3(255,255,255))
						end
						if self.childUI["icon"] then
							self.childUI["icon"].handle.s:setColor(ccc3(255,255,255))
						end
					else
						h[1]:setColor(ccc3(100,100,100))
						if self.childUI["label"] then
							self.childUI["label"].handle.s:setColor(ccc3(50,50,50))
						end
						if self.childUI["icon"] then
							self.childUI["icon"].handle.s:setColor(ccc3(50,50,50))
						end
					end
				end
			else
				local _state = (d.state~=1 and d.state~=2) and 3 or d.state
				if h[_state]~=nil then
					for i = 1,3 do
						if h[i] then
							h[i]:setVisible(false)
						end
					end
					h[_state]:setVisible(true)
				end
			end
		end
		if d.state==-1 and h._n~=nil then
			h._n:setVisible(false)
		end
	end
	if forceToSet==1 then
		return
	end
	local oriSize,hovSize = 1,d.scaleT
	--系统调用的(forceToSet==0)才会走到这里
	if hovSize~=oriSize and hovSize~=0 then
		if forceToSet==0 then
			if d.state==2 then
				local size = hovSize
				h._n:runAction(CCScaleTo:create(0.06,size,size))
			else
				local size = oriSize
				h._n:runAction(CCScaleTo:create(0.06,size,size))
			end
		end
	end
end

_ubtn.select = function(self,mode)
	local d = self.data
	if mode~="unscale" then
		self:setstate(2)
	end
	if self.data._code~=0 then
		return xpcall(self.data._code,hGlobal.__TRACKBACK__)
	end
end

_ubtn.setanchor = function(self,sprite)
	local d = self.data
	if d.anchorX~=nil and d.anchorY~=nil then
		sprite:setAnchorPoint(ccp(d.anchorX,1-d.anchorY))
	elseif __Align[d.align] then
		local v = __Align[d.align]
		sprite:setAnchorPoint(ccp(v[1]/2,v[2]/2))
	end
	return self
end

_ubtn.getTLXY = function(self)
	local d = self.data
	if d.anchorX~=nil and d.anchorY~=nil then
		return math.floor(d.x-d.w*d.anchorX),math.floor(d.y+d.h*d.anchorY)
	elseif __Align[d.align] then
		local v = __Align[d.align]
		return math.floor(d.x-d.w*v[1]/2),math.floor(d.y+d.h*(2-v[2])/2)
	end
	return math.floor(d.x-d.w/2),math.floor(d.y+d.h/2)
end

_ubtn.loadsprite = function(self,newModel,codeOnLoad)
	local h = self.handle
	local d = self.data
	if type(newModel)=="string" then
		d.model = newModel
	end
	if codeOnLoad~=nil and type(newModel)~="function" then
		codeOnLoad = nil
	end
	local plusN = 3
	local bAnimation = __ButtonAnimation
	local tabM = hApi.setModel(self.handle,d.model,-1)
	if d.animation==0 then
		--什么都不做
	elseif type(d.animation)=="string" then
		__ButtonAnimationToken[1] = d.animation
		bAnimation = __ButtonAnimationToken
	elseif type(d.animation)=="table" and type(d.animation[1])=="table" then
		bAnimation = d.animation
	end
	d.anchorX = nil
	d.anchorY = nil
	for i = 1,3 do
		if h[i+plusN]~=nil then
			h[i+plusN]:setVisible(false)
		end
		h[i] = nil
	end
	local nSizeW,nSizeH
	for i = 1,#bAnimation do
		if i>3 then
			break
		end
		local v = bAnimation[i]
		local aniKey,IsSafe,tabM = hApi.safeAnimation(h,v)
		if i==1 or IsSafe==hVar.RESULT_SUCESS then
			if h[i+plusN]~=nil then
				h.s = h[i+plusN]
				h.s:setVisible(true)
			else
				h.s = CCSprite:create()
				h[i+plusN] = h.s
				if h._n~=nil then
					h._n:addChild(h.s)
				end
			end
			h[i] = h.s
			hApi.SpritePlayAnimation(h,v,nil,1)
			if i==1 then
				local _
				_,_,nSizeW,nSizeH = unpack(tabM[aniKey][1])
				--_,_,d.sizeW,d.sizeH= unpack(tabM[aniKey][1])
				if #bAnimation==1 and tabM[aniKey].anchor~=nil then
					d.anchorX,d.anchorY = unpack(tabM[aniKey].anchor)
				else
					d.anchorX = nil
					d.anchorY = nil
				end
			end
			if tabM and tabM.motion then
				hUI.setMotion(h.s,0,0,tabM.motion)
			end
			if codeOnLoad then
				codeOnLoad(h[i],bAnimation,i,tabM,aniKey)
			end
		end
	end
	if h._n~=nil then
		for i = 1,3 do
			if h[i]~=nil then
				self:setanchor(h[i])
				h.s = h[i]
				local sizeW,sizeH = nSizeW,nSizeH--d.sizeW,d.sizeH
				local imageW,imageH
				local IfSetSize = 0
				if d.sizeW==0 and d.sizeH==0 then
					IfSetSize = 1
					imageW,imageH = d.w,d.h
				else
					imageW,imageH = d.sizeW,d.sizeH
				end
				if d.smartWH==2 and sizeW<=imageW and sizeH<=imageH then
					imageW = -1
					imageH = -1
				elseif d.smartWH>0 then
					if imageW>0 and imageW>0 and sizeW and sizeH then
						if sizeW<=sizeH then
							imageW = -1
						else
							imageH = -1
						end
					end
				end
				if i==1 or d.scaleX==nil then
					local imgW,imgH
					d.scaleX,d.scaleY,imgW,imgH = hApi.SpriteSetScaleByWH(h,d.scale,imageW,imageH,sizeW,sizeH)
					if IfSetSize==1 then
						d.w,d.h = imgW,imgH
					end
				else
					hApi.SpriteSetScaleByWH(h,d.scale,imageW,imageH,sizeW,sizeH)
				end
			else
				h[i] = h[1]
			end
		end
	end
	--h.s = nil
	return self
end

_ubtn.loadlabel = function(self,sLabel)
	local h = self.handle
	local d = self.data
	local _childUI = self.childUI
	if _childUI["label"]~=nil then
		_childUI["label"]:del()
		_childUI["label"] = nil
	end
	local tLabel
	local case = type(sLabel)
	if case=="table" then
		tLabel = sLabel
	else
		if case=="string" then
			d.label = sLabel
		end
		tLabel = {text = tostring(d.label),font = d.font, border = d.border}
	end
	if tLabel.size==nil then
		local wMax = math.floor((d.w-d.labelX-8)*string.len(tLabel.text)*8/32)
		local hMax = math.floor((d.h-8)*24/32)
		tLabel.size = math.max(22,math.min(wMax,hMax))
	end
	tLabel.parent = h._n
	local tx,ty = self:getTLXY()
	tLabel.x = (tLabel.x or 0) + hApi.getint((d.w + d.labelX)/2) + tx - d.x
	tLabel.y = (tLabel.y or 0) - hApi.getint(d.h/2) + ty - d.y - 1 --geyachao: 按钮上的文字有1像素的偏差
	tLabel.align = tLabel.align or "MC"
	_childUI["label"] = hUI.label:new(tLabel)
end

--设置按钮的lab
_ubtn.setText = function(self,text)
	local _childUI = self.childUI
	if _childUI["label"] then
		if hVar.ReSetBtnLab[text] then
			text = hVar.ReSetBtnLab[text]
		end
		_childUI["label"]:setText(text)
	end
end

local __tCheckBoxWH = {48,-1,36,-1}
_ubtn.setCheckBox = function(self,tParam)
	local sOptionName
	local d = self.data
	local h = self.handle
	local case = type(tParam)
	local nOptionState = 0
	if case=="string" or case=="table" then
		if case=="string" then
			sOptionName = tParam
			if sOptionName=="self" then
				sOptionName = 1
			end
			tParam = {sOptionName,"UI:finish","misc/photo_frame.png",-1*d.w/2+26,0}
		end
		if type(tParam)=="table" then
			d.checkbox = tParam
			sOptionName = tParam[1]
			local sModelName = tParam[2]
			local sBGName = tParam[3]
			local x = tParam[4]
			local y = tParam[5]
			local tIconWH = __tCheckBoxWH
			if type(tParam[6])=="table" and #tParam[6]==4 then
				tIconWH = tParam[6]
			end
			local tUIList = {}
			if sModelName~=-1 then
				tUIList[#tUIList+1] = {"image","_cho",sModelName,{x,y,tIconWH[1],tIconWH[2],2}}
			end
			if sBGName~=-1 then
				tUIList[#tUIList+1] = {"image","_cbg",sBGName,{x,y,tIconWH[3],tIconWH[4],0}}
			end
			if h._cho~=nil then
				h._n:removeChild(h._cho,true)
				h._cho = nil
			end
			if h._cbg~=nil then
				h._n:removeChild(h._cbg,true)
				h._cbg = nil
			end
			hUI.CreateMultiUIByParam(h._n,0,0,tUIList,h)
		end
		if sOptionName~=nil then
			if type(sOptionName)=="number" then
				nOptionState = sOptionName
				d.userdata = sOptionName
			elseif hVar.OPTIONS[sOptionName] then
				nOptionState = hVar.OPTIONS[sOptionName] or d.userdata
			end
		end
	elseif type(d.checkbox)=="table" then
		sOptionName = d.checkbox[1]
		if case=="number" then
			nOptionState = tParam
		elseif case=="nil" then
			if hVar.OPTIONS[sOptionName]~=nil then
				if hVar.OPTIONS[sOptionName]==0 then
					nOptionState = 1
				end
			else
				if d.userdata==0 then
					nOptionState = 1
				end
			end
		end
		if hVar.OPTIONS[sOptionName]~=nil then
			if nOptionState==1 then
				hVar.OPTIONS[sOptionName] = 1
				hApi.SaveGameOptions()
			else
				hVar.OPTIONS[sOptionName] = 0
				hApi.SaveGameOptions()
			end
		else
			if nOptionState==1 then
				d.userdata = 1
			else
				d.userdata = 0
			end
		end
	end
	if h._cho~=nil then
		if nOptionState==1 then
			self.handle._cho:setVisible(true)
		else
			self.handle._cho:setVisible(false)
		end
	end
end
--======================================================================
--文本
--======================================================================
hUI.label = eClass:new("static")
local __RGB = {255,255,255}
local _ulb = hUI.label
local __DefaultParam = {
	parent = 0,--hUI.__static.uiLayer,
	x = 0,
	y = 0,
	z = 0,
	skew = 0,
	text = "",
	font = hVar.DEFAULT_FONT,--"Arial",--"方正准圆简体",--"华康少女文字W5(P)",----"Vrinda",
	align = "LT",
	size = 24,
	width = 0,
	height = 0,
	RGB = __RGB,
	border = 0,
	scale = 0,
	scaleB = 1,
}
local __numFont = {
	["num"]		= {hApi.GetImagePath("font/numFontNormal.fnt"),26},
	["numGreen"]	= {hApi.GetImagePath("font/numFontGreen.fnt"),26},
	["numWhite"]	= {hApi.GetImagePath("font/numFontWhite.fnt"),26},
	["numRed"]	= {hApi.GetImagePath("font/numFontRed.fnt"),26},
	["numBlue"]	= {hApi.GetImagePath("font/numFontBlue.fnt"),26},
}
local __defaultBorderRGB = {30,30,30}
_ulb.destroy = function(self)
	local d = self.data
	d.RGB = __RGB
	return hUI.destroyDefault(self)
end
_ulb.init = function(self,p)
	self.data = hUI.ReadParam(__DefaultParam,p,rawget(self,"data") or {})
	self.handle = hApi.clearTable(0,self.handle)
	local d = self.data
	local h = self.handle
	--pad 20分钟左右弹框的特殊排错
	h.IsBug = nil
	--战车特殊处理  中文版比英文版偏移2像素

	if g_Cur_Language == 1 or g_Cur_Language == 4 then
		if xlGetChannelId() >= 100 and g_lua_src ~= 1 then
			d.y = (d.y or 0) - 4
		else
			d.y = (d.y or 0) - 2
		end
	else
		if xlGetChannelId() >= 100 and g_lua_src ~= 1 then
			d.y = (d.y or 0) - 2
		end
	end
	if __numFont[d.font] then
		h.s = CCLabelBMFont:create(d.text,__numFont[d.font][1])
		if __Align[d.align] then
			local v = __Align[d.align]
			h.s:setAnchorPoint(ccp(v[1]/2,v[2]/2))
		end
		d.scaleB = (d.scale>0 and d.scale or 1)*d.size/__numFont[d.font][2]
		h.s:setScale(d.scaleB)
		h._n = h.s
		h._n:setPosition(d.x,d.y)
	else
		h._n = CCNode:create()
		h.s = self:createText(d.text,d.RGB)
		if d.border~=0 then
			local borderRGB = d.border
			if borderRGB==1 or type(borderRGB)~="table" then
				borderRGB = __defaultBorderRGB
			end
			h.sLT = self:copyTextToSprite(h.s,nil,borderRGB,-1,1,-1)
			h.sRT = self:copyTextToSprite(h.s,nil,borderRGB,1,1,-1)
			h.sLB = self:copyTextToSprite(h.s,nil,borderRGB,-1,-1,-1)
			h.sRB = self:copyTextToSprite(h.s,nil,borderRGB,1,-1,-1)
		end
		self:resetXY()
	end
	d.parent:addChild(self.handle._n,d.z)
end
_ulb.copyTextToSprite = function(self,pFromSprite,pToSprite,RGB,x,y,z)
	local texture = pFromSprite:getTexture()
	if texture==nil then
		return
	end
	local tSize = texture:getContentSize()
	--local sSize = pFromSprite:getContentSize()
	local d = self.data
	if pToSprite==nil then
		pToSprite = CCSprite:createWithTexture(texture,CCRectMake(0,0,tSize.width,tSize.height))
		if RGB then
			pToSprite:setColor(ccc3(RGB[1],RGB[2],RGB[3]))
		end
		--pToSprite:setContentSize(CCSizeMake(sSize.width,sSize.height))
		pToSprite:setAnchorPoint(ccp(0,1))
		pToSprite:setPosition(x,y)
		if d.scale~=0 and d.scale~=1 then
			if type(d.scale)=="table" then
				pToSprite:setScaleX(d.scale[1])
				pToSprite:setScaleY(d.scale[2])
			else
				pToSprite:setScale(d.scale)
			end
		end
		self.handle._n:addChild(pToSprite,z)
	else
		pToSprite:setTexture(texture)
		pToSprite:setTextureRect(CCRectMake(0,0,tSize.width,tSize.height))
		if RGB then
			pToSprite:setColor(ccc3(RGB[1],RGB[2],RGB[3]))
		end
		--pToSprite:setContentSize(CCSizeMake(sSize.width,sSize.height))
		pToSprite:setAnchorPoint(ccp(0,1))
		pToSprite:setPosition(x,y)
		if z and pToSprite:getParent() then
			pToSprite:getParent():reorderChild(pToSprite,z)
		end
		if d.scale~=0 and d.scale~=1 then
			if type(d.scale)=="table" then
				pToSprite:setScaleX(d.scale[1])
				pToSprite:setScaleY(d.scale[2])
			else
				pToSprite:setScale(d.scale)
			end
		end
	end
	return pToSprite
end
_ulb.createText = function(self,text,RGB,x,y,z)
	local d = self.data
	text = text or d.text
	RGB = RGB or d.RGB
	if d.font == hVar.FONTC then
		local TargetPlatform = CCApplication:sharedApplication():getTargetPlatform()
		if g_tTargetPlatform.kTargetWindows ~= TargetPlatform then
			d.font = g_TTF_App
		end
	end
	
	--多语言版本的 字体大小切换
	--if g_lua_src ~= 1 then
		local tempSize = hVar.FONTC_SIZE[g_Cur_Language][d.size]
		if d.font==hVar.FONTC and tempSize then
			d.size = tempSize
		end
	--end
	local s = CCLabelTTF:create(xlGB2UTF(text),d.font,d.size)
	local R,G,B = unpack(RGB)
	s:setColor(ccc3(R,G,B))
	s:setAnchorPoint(ccp(0,1))	--anchor左上角
	--旧版的位置信息
	if __Align[d.align] then
		local v = __Align[d.align]
		s:setHorizontalAlignment(v[1])
		s:setVerticalAlignment(v[2])
	end
	if d.skew~=0 then
		s:setSkewX(d.skew)
	end
	if d.width>0 then
		s:setDimensions(CCSizeMake(d.width,d.height or 0))
	else
		if text ~= "" and s then
			--为了解决文字被裁剪 测试代码
			local v = s:getContentSize()
			if v then
				s:setDimensions(CCSizeMake(v.width or 0,math.max(v.height or 0,d.size + 4)))
			end
		end
	end
	if d.scale~=0 and d.scale~=1 then
		if type(d.scale)=="table" then
			s:setScaleX(d.scale[1])
			s:setScaleY(d.scale[2])
		else
			s:setScale(d.scale)
		end
	end
	if x and y then
		s:setPosition(x,y)
	end
	if self.handle._n then
		self.handle._n:addChild(s,(z or 0))
	end
	return s
end
_ulb.setW = function(self,width)
	local d = self.data
	d.width = width
	return self.handle.s:setDimensions(CCSizeMake(d.width,0))
end
_ulb.setXY = function(self,x,y)
	local d = self.data
	d.x = x
	d.y = y
	return self:resetXY()
end
_ulb.resetXY = function(self)
	local d = self.data
	local h = self.handle
	if h.s==nil then
		--pad 20分钟左右弹框的特殊排错
		--if h.IsBug~=1 then
			--h.IsBug = 1
			--xlLG("ui_error","发现BMFont错误(resetXY), ID="..self.ID..", __ID="..self.__ID.."\n")
		--end
		return
	end
	if d.align~="LT" and __Align[d.align] then
		if __numFont[d.font] then
			return h._n:setPosition(d.x,d.y)
		else
			local width,height = self:getWH()
			local aW,aH = 2-__Align[d.align][1],__Align[d.align][2]
			return h._n:setPosition(math.floor(d.x+width*(aW-2)/2),math.floor(d.y-height*(aH-2)/2))
		end
	else
		return h._n:setPosition(d.x,d.y)
	end
end
_ulb.getWH = function(self)
	local h = self.handle
	if h.s==nil then
		--pad 20分钟左右弹框的特殊排错
		if h.IsBug~=1 then
			h.IsBug = 1
			xlLG("ui_error","发现BMFont错误(getWH), ID="..self.ID..", __ID="..self.__ID.."\n")
		end
		return 0,0
	end
	local v = self.handle.s:getContentSize()
	return v.width,v.height
end
_ulb.setText = function(self,s,IsSetText)
	local d = self.data
	local h = self.handle
	if h.s==nil then
		--pad 20分钟左右弹框的特殊排错
		if h.IsBug~=1 then
			h.IsBug = 1
			xlLG("ui_error","发现BMFont错误(setText), ID="..self.ID..", __ID="..self.__ID.."\n")
		end
		return
	end
	if s==nil then
		s = ""
	else
		local case = type(s)
		if case~="string" then
			if __numFont[d.font] then
				if case=="number" then
					s = tostring(s)
				else
					s = "*"
				end
			else
				s = tostring(s)
			end
		end
	end
	if IsSetText==1 then
		d.text = s
	elseif IsSetText==2 then
		if d.text==s then
			return
		end
		d.text = s
	end
	if __numFont[d.font] then
		return h.s:setString(s)
	else
		h.s:setString(xlGB2UTF(s))
		if d.border~=0 then
			local borderRGB = d.border
			if borderRGB==1 or type(borderRGB)~="table" then
				borderRGB = __defaultBorderRGB
			end
			h.sLT = self:copyTextToSprite(h.s,h.sLT,borderRGB,-1,1,-1)
			h.sRT = self:copyTextToSprite(h.s,h.sRT,borderRGB,1,1,-1)
			h.sLB = self:copyTextToSprite(h.s,h.sLB,borderRGB,-1,-1,-1)
			h.sRB = self:copyTextToSprite(h.s,h.sRB,borderRGB,1,-1,-1)
		end
		return self:resetXY()
	end
end
--======================================================================
--漂浮文本
--======================================================================
hUI.floatNumber = eClass:new("static")
-----------------------------------------------------
hApi.ClassAutoReleaseByTick(hUI.floatNumber,"gametime","tick")
-----------------------------------------------------
local _ufn = hUI.floatNumber
local __DefaultParam = {
	parent = 0,--hUI.__static.uiLayer,
	unit = 0,
	lifetime = 1000,
	fadeout = "",
	text = "",
	font = "num",
	mode = 0,		--[0,"boom"]
	size = 24,
	x = 0,
	y = 0,
	moveX = 0,
	moveY = 0,
	jumpH = 0,
	scale = 1,
	----------
	icon = 0,
	iconWH = 0,
	iconX = 0,
	iconY = 0,
	iconAnimation = 0,
	iconScale = 1,
}
local _iconH = {}
local function __fNumberFadeout(s,fWait,fTime)
	if s then
		local array = CCArray:create()
		if fWait>0 then
			array:addObject(CCDelayTime:create(fWait/1000))
		end
		array:addObject(CCFadeOut:create(fTime/1000))
		s:runAction(CCSequence:create(array))
	end
end
_ufn.init = function(self,p)
	self.data = hUI.ReadParam(__DefaultParam,p,rawget(self,"data") or {})
	self.handle = hApi.clearTable(0,self.handle)
	local d = self.data
	local h = self.handle
	self:settick(math.max(1,d.lifetime))
	local u = d.unit
	if u and u~=0 then --geyachao: 加上非空判断
		local w = u:getworld()
		if w then
			if u.handle and u.handle._c then --geyachao: 加上非空判断
				local x,y = xlCha_GetPos(u.handle._c)
				d.x = d.x + x
				d.y = d.y - y
				d.parent = w.handle.worldLayer
			end
		end
	end
	if __numFont[d.font] then
		h.s = CCLabelBMFont:create(d.text,__numFont[d.font][1])
		if __Align[d.align] then
			local v = __Align[d.align]
			h.s:setAnchorPoint(ccp(v[1]/2,v[2]/2))
		end
		local scale = d.size/__numFont[d.font][2]
		h.s:setScale(scale)
		h._n = CCNode:create()
		h._n:addChild(h.s)
		h._n:setPosition(d.x,d.y)
		d.parent:addChild(self.handle._n,hZorder.FloatNumber)
		local plusX = 0
		local case = type(p.textII)
		if case=="string" then
			local _,_,_,tx = self:addtext(p.textII,hVar.FONTC,d.size,"LC")
			plusX = tx
		elseif case=="table" then
			local _,_,_,tx = self:addtext(unpack(p.textII))
			plusX = tx
		end
		if d.icon~=0 and d.iconScale>0 then
			local iconWH = -1
			if d.iconWH>0 then
				iconWH = d.iconWH
			end
			hApi.setModel(_iconH,d.icon,-1)
			h._icon = hApi.SpriteLoadOneFrame(_iconH,d.iconAnimation,d.iconScale,"RC",-1,iconWH)
			h._icon:setPosition(-1*h.s:getContentSize().width/4+d.iconX+plusX,d.iconY)
			h._n:addChild(h._icon)
		end
		
		if d.mode=="boom" then
			if d.scale>0 and d.scale~=1 then
				local a = CCArray:create()
				a:addObject(CCScaleBy:create(0.15,d.scale,d.scale))
				a:addObject(CCDelayTime:create(0.75))
				a:addObject(CCScaleBy:create(0.5,1.2,1.2))
				h.s:runAction(CCSequence:create(a))
			end
		else
			if d.scale>0 and d.scale~=1 then
				h.s:runAction(CCScaleBy:create(0.25,d.scale,d.scale))
			end
		end
		if d.jumpH>0 then
			h._n:runAction(CCJumpBy:create(0.25,ccp(d.moveX,d.moveY),d.jumpH,1))
		elseif d.moveX~=0 or d.moveY~=0 then
			h._n:runAction(CCMoveBy:create(d.lifetime/1000,ccp(d.moveX,d.moveY)))
		end
		if d.fadeout~="" and d.fadeout<d.lifetime and d.fadeout>=-1*d.lifetime then
			local fTime,fWait = 0,0
			if d.fadeout>=0 then
				fTime = d.lifetime - d.fadeout
				fWait = d.fadeout
			else
				fWait = math.max(0,d.lifetime + d.fadeout)
				fTime = d.lifetime - fWait
			end
			if fTime>0 then
				__fNumberFadeout(h.s,fWait,fTime)
				__fNumberFadeout(h._icon,fWait,fTime)
			end
		end
	end
end

_ufn.addtext = function(self,text,font,size,align,x,y,color,textbg)
	local h = self.handle
	local d = self.data
	size = size or d.size
	font = font or __DefaultParam.font
	local _ConvtedText = xlGB2UTF(tostring(text))
	local s = CCLabelTTF:create(_ConvtedText,font,size)
	s:setAnchorPoint(ccp(0,1))			--anchor左上角
	if type(x)~="number" or type(y)~="number" then
		x = 0
		y = 0
	end
	local IsDrawBG = 0
	--如果有背景条子,调整部分属性
	if (textbg or 0)~=0 then
		IsDrawBG = 1
		--size = 24
	end
	--如果创建背景条，则排除非法对齐(下面的背景条只对这三个对齐方式做了相应的位置调整)
	if IsDrawBG==1 and "LC" ~= align and "MC" ~= align and "RC" ~= align then
		IsDrawBG = 0
	end

	local v = s:getContentSize()
	local width,height = v.width,v.height
	if align~="LT" and __Align[align] then
		local aW,aH = 2-__Align[align][1],__Align[align][2]
		x = math.floor(x+width*(aW-2)/2)
		y = math.floor(y-height*(aH-2)/2)
	end
	if g_Cur_Language == 1 then
		if g_lua_src ~= 1 and xlGetChannelId() >= 100 then
			s:setPosition(x,y - 4)
		else
			s:setPosition(x,y - 2)
		end
	elseif xlGetChannelId() >= 100 and g_lua_src ~= 1 then
		s:setPosition(x,y - 2)
	else
		s:setPosition(x,y)
	end
	if color~=nil and type(color)=="table" and #color==3 then
		s:setColor(ccc3(color[1],color[2],color[3]))
	end
	self.handle._n:addChild(s)

	--背景条子
	local oBarBG
	if IsDrawBG==1 then
		local bx,bw

		--设置宽度
		if textbg==1 then
			bw = width + 60
		else
			bw = textbg
		end

		--设置位置
		if "LC" == align then
			bx = x - 20
		elseif "MC" == align then
			bx = x + width/2
		elseif "RC" == align then
			bx = x + width + 20
		end
		
		--创建背景条
		oBarBG = hUI.bar:new({
			parent = self.handle._n,
			model = "ICON:floatnumber_bg",
			align = align,
			x = bx,
			y = y - size * 1.2/2,
			w = bw,
			h = size * 1.2,
			z = -1,
		})
	end

	if d.fadeout~="" and d.fadeout<d.lifetime and d.fadeout>=-1*d.lifetime then
		local fTime,fWait = 0,0
		if d.fadeout>=0 then
			fTime = d.lifetime - d.fadeout
			fWait = d.fadeout
		else
			fWait = math.max(0,d.lifetime + d.fadeout)
			fTime = d.lifetime - fWait
		end
		if fTime>0 then
			__fNumberFadeout(s,fWait,fTime)
			if oBarBG then
				oBarBG:enumSprite(__fNumberFadeout,fWait,fTime)
			end
		end
	end
	--如果有背景条子用完要删掉
	if oBarBG~=nil then
		hUI.deleteUIObject(oBarBG)
	end
	return s,width,height,x,y
end

_ufn.destroy = function(self)
	local h = self.handle
	if h._n and h._n:getParent() then
		h._n:getParent():removeChild(h._n,true)
	end
	h._n = nil
	h._icon = nil
	h.s = nil
end

--======================================================================
-- 面板组
--======================================================================
local __code,__self,__id,__vChild,__gridX,__gridY
local __CallOnGridChildCreate = function()
	local code,self,id,vChild,gridX,gridY = __code,__self,__id,__vChild,__gridX,__gridY
	__code,__self,__id,__vChild,__gridX,__gridY = nil,nil,nil,nil,nil,nil
	return code(self,id,vChild,gridX,gridY)
end
local __OnGridChildCreate = function(code,self,id,vChild,gridX,gridY)
	__code,__self,__id,__vChild,__gridX,__gridY = code,self,id,vChild,gridX,gridY
	return xpcall(__CallOnGridChildCreate,hGlobal.__TRACKBACK__)
end
--------------------------------
hUI.grid = eClass:new("static")
local _ugr = hUI.grid
local __TokenT = {}
local __DefaultParam = {
	parent = 0,--hUI.__static.uiLayer,
	userdata = 0,
	-------------------------
	x = 0,
	y = 0,
	-------------------------
	mode = "image",	--["button"],["image"],["batchImage"]
	tab = 0,
	customTab = 0,			--自定义表，目前记录是技能还是塔 --zhenkira:新加
	tabModelKey = "icon",
	animation = 0,			--[string][{"normal","selected","disable"}][function(id,model,gridX,gridY)]
	grid = __TokenT,		--[{1,2,3,4}][{{1,2,3,4},{5,6,7,8}}]
	offsetX = __TokenT,		--格式为{x0,x1,x2}
	align = 0,
	count = 0,
	scaleT = 0.8,
	centerX = 0,
	centerY = 0,
	iconW = -1,
	iconH = -1,
	gridW = 34,
	gridH = 34,
	smartWH = 0,
	buttonNum = 0,			--将在创建grid后记录数量
	buttonState = {},		--按钮状态	--zhenkira:新加
	spreadFrom = 0,			--如果定义了此值，则按钮创建时将从指定的位置展开
	dragbox = 0,
	code = 0,			--按钮按下时会调用此值,function(id,btn,d.userdata,gx,gy)
	codeOnTouch = 0,		--仅["button"]模式有效
	codeOnDrag = 0,			--仅["button"]模式有效
	codeOnButtonCreate = 0,		--function(self,id,btn,gx,gy)按钮创建时会被调用此值
	codeOnImageCreate = 0,		--function(self,id,sprite,gx,gy)图像创建时会被调用此值
}
_ugr.destroy = function(self)
	local d = self.data
	--内存清理:移除不需要的函数
	d.code = 0
	d.codeOnTouch = 0
	d.codeOnButtonCreate = 0
	d.codeOnImageCreate = 0
	--内存清理:移除不需要的表格
	d.model = 0
	d.animation = 0
	d.userdata = 0
	d.grid = __TokenT
	d.offsetX = __TokenT
	d.spreadFrom = 0
	d.dragbox = 0

	--清理监听
	for k, v in pairs(d.listenerContainer) do
		for i = 1, #v do
			hGlobal.event:listen(k, v[i], nil)
			--print("_ugr.removelisten:".. tostring(k).. ",".. tostring(v[i]))
		end
	end
	d.listenerContainer = {}

	return hUI.destroyDefault(self)
end
local __ENUM__CountGrid = function(id,gx,gy,_,self)
	local d = self.data
	d.count = d.count + 1
end
local __ENUM__CreateItem = function(id,gx,gy,_,self)
	local d = self.data
	d.count = d.count + 1
	if d.mode=="button" or d.mode=="imageButton" then
		self:addbutton(id,gx,gy)
	elseif id~=0 then
		self:addimage(id,gx,gy)
	end
end
_ugr.init = function(self,p)
	self.data = hUI.ReadParam(__DefaultParam,p,rawget(self,"data") or {})
	self.handle = hApi.clearTable("H",self.handle)
	self.childUI = hApi.clearTable(0,self.childUI)
	local d = self.data
	local h = self.handle
	local _childUI = self.childUI

	if d.mode=="batchImage" then
		--注意，batchImage的父节点必须是batchnode，并且batchImage上不能再添加任何child，否则直接弹掉
		--而且batchImage的纹理必须和父节点相同
		--batchImage只有单帧图片
		--这种模式下是没有self.handle.s的
		h.batchmode = "child"
		if type(p.parent)~="userdata" then
			_DEBUG_MSG("[LUA ERROR]batch image: "..d.model.." 必须拥有一个合法的parent!")
			return
		end
		hApi.SpriteSetBatchParent(h,"MODEl:default",p.parent)
	else
		--创建node
		h._n = CCNode:create()
		h._n:setPosition(d.x,d.y)
		d.parent:addChild(h._n)
	end

	d.buttonNum = 0
	d.count = 0
	hApi.EnumTable2V(d.grid,__ENUM__CountGrid,self)
	if d.count>0 then
		d.count = 0
		hApi.EnumTable2V(d.grid,__ENUM__CreateItem,self)
		d.count = 0
	end
	
	--print("add ugr:".. tostring(self))
	
	if not d.listenerContainer then
		d.listenerContainer = {}		--内置监听器	--zhenkira:新加
	end
end

_ugr.getmodel = function(self,id)
	local d = self.data
	if d.tab~=0 then
		if id and d.tab[id] then
			return d.tab[id][d.tabModelKey] or 0
		end
	else
		return id
	end
end

_ugr.addbutton = function(self,id,gx,gy,param)
	local d = self.data
	local h = self.handle
	local _childUI = self.childUI
	local model = self:getmodel(id)
	if model==nil then
		return
	end
	--xlLG("addbutton","1 = "..model.."\n")
	if gx==nil or gy==nil then
		gx = d.buttonNum
		gy = 0
	end
	local x,y = self:grid2xy(gx,gy,"ex")
	d.buttonNum = d.buttonNum + 1
	local btn,code,codeOnTouch,codeOnDrag
	if type(param)=="table" then
		code = param.code
		codeOnTouch = param.codeOnTouch
		codeOnDrag = param.codeOnDrag
	end
	if code==nil and d.code~=0 then
		local _code = d.code
		code = function()
			return _code(id,btn,d.userdata,gx,gy,d.customTab)
		end
	end
	if codeOnTouch==nil and d.codeOnTouch~=0 then
		local _codeOnTouch = d.codeOnTouch
		codeOnTouch = function()
			return _codeOnTouch(id,btn,d.userdata,gx,gy)
		end
	end
	if codeOnDrag==nil and d.codeOnDrag~=0 then
		local _codeOnDrag = d.codeOnDrag
		codeOnDrag = function(_,x,y,sus)
			return _codeOnDrag(id,btn,d.userdata,gx,gy,x,y,sus)
		end
	end
	local iconBG
	local animation
	if d.animation==0 then
		--什么都不做
	elseif type(d.animation)=="function" then
		local ex_model,ex_iconBG
		animation,ex_model,ex_iconBG = d.animation(id,model,gx,gy)
		if ex_model~=nil then
			model = ex_model
		end
		if ex_iconBG~=nil then
			iconBG = ex_iconBG
		end
	elseif type(d.animation)=="string" or type(d.animation)=="table" then
		animation = d.animation
	end
	
	local dragbox = (param and param.dragbox) or d.dragbox
	
	--创建模式等于按钮
	btn = hUI.button:new({
		parent = h._n,
		userdata = id,
		model = model,
		animation = animation,
		align = (param and param.align) or (d.align~=0 and d.align) or nil,
		dragbox = dragbox~=0 and dragbox or nil,
		ox = d.x,
		oy = d.y,
		scaleT = d.scaleT,
		x = x,
		y = y,
		w = d.iconW,
		h = d.iconH,
		icon = iconBG,
		iconZ = -1,
		smartWH = d.smartWH,
		code = code,
		codeOnTouch = codeOnTouch,
		codeOnDrag = codeOnDrag,
	})
	
	if d.buttonState[d.buttonNum] and d.buttonState[d.buttonNum] == -1 then
		btn:setstate(0)
	end
	
	--if param~=nil and param.dragbox~=nil then
		--param.dragbox:addbutton(btn,d.x,d.y)
	--end
	local btnName = "btn_"..d.buttonNum
	_childUI[btnName] = btn
	if d.spreadFrom~=0 then
		local ox,oy,movetime = (d.spreadFrom[1] or x),(d.spreadFrom[2] or y),(d.spreadFrom[3] or 250)
		btn.handle._n:setPosition(ox,oy)
		btn.handle._n:runAction(CCMoveTo:create(movetime/1000,ccp(btn.data.x,btn.data.y)))
	end
	if d.codeOnButtonCreate~=0 then
		__OnGridChildCreate(d.codeOnButtonCreate,self,id,btn,gx,gy)
	end
	return btn,x,y,btnName
end

_ugr.addlisten = function(self,name,listenerName,code)
	--print("_ugr.addlisten:".. tostring(name).. ",".. tostring(listenerName))
	hGlobal.event:listen(name, listenerName, code)
	local d = self.data

	--print("add addlisten:".. tostring(self))

	if not d.listenerContainer then
		d.listenerContainer = {}
	end

	if not d.listenerContainer[name] then
		d.listenerContainer[name] = {}
	end

	table.insert(d.listenerContainer[name], listenerName)
end

local __Align = hVar.UI_ALIGN
_ugr.addimage = function(self,id,gx,gy,param)
	local d = self.data
	local h = self.handle
	local model = self:getmodel(id)
	local unrecord = 0
	if model==nil then
		return
	end
	local x,y = self:grid2xy(gx,gy,"ex")

	--创建模式等于普通的精灵，并且使用第一个动作作为动画
	local iconBG
	local animation = "normal"
	local vAnimation = param and param.animation or d.animation
	if vAnimation==0 then
		--什么都不做
	elseif vAnimation==-1 then
		--这个模式没有动画
		animation = 0
	elseif type(vAnimation)=="function" then
		local ex_model,ex_iconBG
		animation,ex_model,ex_iconBG = vAnimation(id,model,gx,gy)
		if ex_model~=nil then
			model = ex_model
		end
		if ex_iconBG~=nil then
			iconBG = ex_iconBG
		end
	elseif type(vAnimation)=="string" then
		animation = vAnimation
	end
	local sprite = nil
	local sAlign = (d.align~=0 and d.align) or 0
	local tAlign
	local iconW,iconH,ox,oy = d.iconW,d.iconH,d.centerX,d.centerY
	local smartWH = d.smartWH
	if type(param)=="table" then
		sAlign = param.align or sAlign
		unrecord = param.unrecord or unrecord
		smartWH = param.smartWH or smartWH
		if type(param.size)=="table" then
			iconW = param.size[1] or -1
			iconH = param.size[2] or -1
			ox = param.size[3] or ox
			oy = param.size[4] or oy
		end
	end
	if animation==0 then
		--无图标的item
		h.s = CCSprite:create()
		h._n:addChild(h.s)
		sprite = h.s
	else
		--需要创建图标
		hApi.setModel(h,model,-1)
		local aniKey,IsSafe,tabM = hApi.safeAnimation(h,animation)
		if d.mode=="batchImage" then
			sprite = hApi.SpriteBatchNodeAddChild(h,animation,"NONE",iconW,iconH)
		else
			if aniKey and tabM then
				local _,_,sizeW,sizeH= unpack(tabM[aniKey][1])
				if d.tab~=0 and type(d.tab)=="table" and type(id)=="number" and type(d.tab[id])=="table" and type(d.tab[id].scaleUI)=="number" then
					local nImageScale = d.tab[id].scaleUI
					if nImageScale~=1 and nImageScale>0 then
						sizeW = math.floor(sizeW/nImageScale)
						sizeH = math.floor(sizeH/nImageScale)
					end
				end
				hUI.CheckImagePath("grid",self,tabM.image)
				h.s = CCSprite:create()
				hApi.SpritePlayAnimation(h,animation,nil,1)
				local imageW,imageH = iconW,iconH
				if d.smartWH==2 and sizeW<=imageW and sizeH<=imageH then
					imageW = -1
					imageH = -1
				elseif d.smartWH>0 then
					if imageW>0 and imageW>0 and sizeW and sizeH then
						if sizeW<=sizeH then
							imageW = -1
						else
							imageH = -1
						end
					end
				end
				if sizeW==0 and sizeH==0 then
					local _,_,iw,ih = unpack(tabM[aniKey][1])
					sizeW = iw
					sizeH = ih
				end
				hApi.SpriteSetScaleByWH(h,1,imageW,imageH,sizeW,sizeH)
				h._n:addChild(h.s)
				sprite = h.s
				tAlign = tabM[aniKey].anchor
			end
		end
	end
	if sprite~=nil then
		local posX,posY = ox+x,oy+y
		sprite:setPosition(posX,posY)
		if sAlign~=0 and __Align[sAlign] then
			local a = __Align[sAlign]
			sprite:setAnchorPoint(ccp(a[1]/2,a[2]/2))
		elseif tAlign~=nil then
			local ax,ay = tAlign[1],tAlign[2]
			sprite:setAnchorPoint(ccp(ax,1-ay))
		end
		if unrecord~=1 then
			h["s_x"..gx.."y"..gy] = sprite
			if d.codeOnImageCreate~=0 then
				__OnGridChildCreate(d.codeOnImageCreate,self,id,sprite,gx,gy)
			end
		end
		return sprite,posX,posY
	end
end

_ugr.getimage = function(self,gx,gy,IsRelease)
	local k = "s_x"..gx.."y"..gy
	local s = self.handle[k]
	if type(s)=="userdata" then
		if IsRelease==1 then
			self.handle[k] = nil
		end
		return s
	end
end

_ugr.removeimage = function(self,gx,gy)
	local k = "s_x"..gx.."y"..gy
	local s = self.handle[k]
	if type(s)=="userdata" and s:getParent()~=nil then
		self.handle[k] = nil
		s:getParent():removeChild(s,true)
	end
end

_ugr.setimage = function(self,gx,gy,s,IsSetPosition)
	local k = "s_x"..gx.."y"..gy
	if s~=nil and (self.handle[k]==s or self.handle[k]==nil) then
		self.handle[k] = s
		if (IsSetPosition or 0)~=0 and type(IsSetPosition)=="number" then
			local x,y = self:grid2xy(gx,gy,"ex")
			s:setPosition(x,y)
			if IsSetPosition==2 then
				local align = self.data.align
				if __Align[align] then
					local a = __Align[align]
					s:setAnchorPoint(ccp(a[1]/2,a[2]/2))
				end
			end
		end
		return hVar.RESULT_SUCESS
	end
	return hVar.RESULT_FAIL
end

_ugr.select = function(self,i,mode)
	local d = self.data
	if d.mode=="button" or d.mode=="imageButton" then
		local _childUI = self.childUI
		local btn = _childUI["btn_"..tonumber(i)]
		if btn~=nil then
			return btn:select(mode)
		end
	end
end

_ugr.xy2grid = function(self,x,y,mode)
	local d = self.data
	local h = self.handle
	if mode==nil then
		x,y = x,hVar.SCREEN.h-y
	else--if mode=="frm" or mode=="parent" then
		x,y = x-d.x,y-d.y
	end
	if d.grid~=0 then
		x = x+math.floor(d.gridW/2)
		y = -1*y+math.floor(d.gridH/2)
		local gy = math.floor(y/d.gridH)
		local offsetX = d.offsetX[gy+1] or 0
		local gx = math.floor((x-offsetX)/d.gridW)

		if type(d.grid[1])=="table" then
			if d.grid[gy+1]~=nil and d.grid[gy+1][gx+1]~=nil then
				return gx,gy,d.grid[gy+1][gx+1],h["s_x"..gx.."y"..gy]
			end
		elseif gy==0 and d.grid[gx+1]~=nil then
			return gx,gy,d.grid[gx+1],h["s_x"..gx.."y"..gy]
		end
	end
end

_ugr.grid2xy = function(self,gx,gy,mode)
	local d = self.data
	local offsetX = d.offsetX[gy+1] or 0
	local nx,ny = offsetX+gx*d.gridW,-1*gy*d.gridH
	if mode=="ex" and d.mode=="batchImage" then
		return d.x+nx,d.y+ny
	end
	return nx,ny
end

_ugr.IsSafeGrid = function(self,gx,gy)
	local d = self.data
	if d.grid~=0 then
		if type(d.grid[1])=="table" then
			if d.grid[gy+1]~=nil then
				return true
			end
		elseif gy==0 and d.grid[gx+1]~=nil then
			return true
		end
	end
	return false
end

_ugr.shift = function(self,x,y,tx,ty,moveTime)
	local d = self.data
	local h = self.handle
	if (d.mode=="image" or d.mode=="batchImage") and not(x==tx and y==ty) then
		local g = d.grid
		if type(d.grid[1])=="table" then
			if g[y+1] and g[ty+1] and g[y+1][x+1] and g[ty+1][tx+1] then
				g[y+1][x+1],g[ty+1][tx+1] = g[ty+1][tx+1],g[y+1][x+1]
			else
				return hVar.RESULT_FAIL
			end
		else
			if y==0 and ty==0 and g[x+1] and g[tx+1] then
				g[x+1],g[tx+1] = g[tx+1],g[x+1]
			else
				return hVar.RESULT_FAIL
			end
		end
		local key,tkey = "s_x"..x.."y"..y,"s_x"..tx.."y"..ty
		h[tkey],h[key] = h[key],h[tkey]
		if moveTime~=-1 then
			if h[key]~=nil then
				if moveTime~=nil and moveTime~=0 then
					h[key]:runAction(CCMoveTo:create(moveTime/1000,ccp(self:grid2xy(x,y,"ex"))))
				else
					h[key]:setPosition(self:grid2xy(x,y,"ex"))
				end
			end
			if h[tkey]~=nil then
				if moveTime~=nil and moveTime~=0 then
					h[tkey]:runAction(CCMoveTo:create(moveTime/1000,ccp(self:grid2xy(tx,ty,"ex"))))
				else
					h[tkey]:setPosition(self:grid2xy(tx,ty,"ex"))
				end
			end
		end
		return hVar.RESULT_SUCESS
	end
	return hVar.RESULT_FAIL
end

--======================================================================
-- node:用来创建child用
--======================================================================
hUI.node = eClass:new("static")
local _und = hUI.node
_und.destroy = function(self)
	local d = self.data
	--内存清理:释放不需要的表格
	d.child = 0
	return hUI.destroyDefault(self)
end
local __DefaultParam = {
	parent = 0,--hUI.__static.uiLayer,
	x = 0,
	y = 0,
	z = 0,
	w = 0,
	h = 0,
	child = 0,
	mode = 0,
	code = 0,
	gridW = 0,
	gridH = 0,
}
_und.init = function(self,p)
	self.data = hUI.ReadParam(__DefaultParam,p,rawget(self,"data") or {})
	self.handle = hApi.clearTable(0,self.handle)
	self.childUI = hApi.clearTable(0,self.childUI)
	hUI.createNode(self)
	hUI.createChildUI(self,self.data.child)
end

_und.setXY = function(self,x,y)
	local d = self.data
	local h = self.handle
	if type(x)=="number" and type(y)=="number" then
		d.x = x
		d.y = y
		h._n:setPosition(d.x,d.y)
	end
end

--======================================================================
--操作面板
--======================================================================
hUI.panel = eClass:new("static")
hApi.ClassAutoReleaseByTick(hUI.panel,"gametime","tick")
local _ugp = hUI.panel
_ugp.destroy = function(self)
	local d = self.data
	local ExitCode = d.codeOnExit
	--内存清理:释放不需要的函数
	d.codeOnExit = 0
	--内存清理:释放不需要的表格
	d.child = 0
	d.unit = 0
	d.world = 0
	if ExitCode~=0 and type(ExitCode)=="function" then
		if d.bindU~=0 then
			hUI.destroyDefaultU(self)
		elseif d.bindW~=0 then
			hUI.destroyDefaultW(self)
		else
			hUI.destroyDefault(self)
		end
		return ExitCode()
	else
		if d.bindU~=0 then
			return hUI.destroyDefaultU(self)
		elseif d.bindW~=0 then
			return hUI.destroyDefaultW(self)
		else
			return hUI.destroyDefault(self)
		end
	end
end
local __DefaultParam = {
	userparam = 0,
	mode = "ground",
	parent = 0,--hUI.__static.uiLayer,
	unit = 0,
	world = 0,
	menu = 0,
	x = 0,
	y = 0,
	z = 0,
	child = 0,
	bindTag = 0,
	codeOnExit = 0,
	--tick = 0,
	--bindU = 0,
	--bindW = 0,
}
_ugp.init = function(self,p)
	self.data = hUI.ReadParam(__DefaultParam,p,rawget(self,"data") or {})
	self.handle = hApi.clearTable(0,self.handle)
	self.childUI = hApi.clearTable(0,self.childUI)
	local d = self.data
	local h = self.handle
	local u = d.unit
	local w = d.world
	d.tick = 0
	d.bindU = 0
	d.bindW = 0
	if u~=0 then
		if u.ID~=0 and u.IsDestroyed~=1 and u.handle._n then
			d.bindU = u.ID
			if d.mode=="effect" then
				d.parent = u.handle._n
			elseif u.handle._tn~=nil then
				d.parent = u.handle._tn
			else
				d.parent = u.handle._n
			end
			if d.bindTag==0 then
				d.bindTag = "__Panel_"..self.ID
			end
			if u.chaUI[d.bindTag]~=nil and u.chaUI[d.bindTag].ID~=0 then
				u.chaUI[d.bindTag]:del()
			end
			u.chaUI[d.bindTag] = self
			h._n = CCNode:create()
			h._n:setPosition(d.x,d.y)
			d.parent:addChild(h._n,d.z + 0)
			if d.menu==1 then
				--menu模式下创建一个dragbox
				self.childUI["dragBox"] = hUI.dragBox:new({
					worldnode = u.handle._n,
					x = d.x,
					y = d.y,
				})
			end
			hUI.createChildUI(self,d.child)
			if type(p.tick)=="number" then
				self:settick(p.tick)
			end
		else
			d.bindU = 0
			d.bindTag = 0
			d.tick = 1
		end
	elseif w~=0 then
		if w.ID~=0 and w.IsDestroyed~=1 and w.handle.worldLayer then
			d.bindW = w.ID
			local IsBindToWorld = 0
			if p and rawget(p,"parent")==nil then
				IsBindToWorld = 1
				d.parent = w.handle.worldLayer
			end
			if d.bindTag==0 then
				d.bindTag = "__Panel_"..self.ID
			end
			if w.worldUI[d.bindTag]~=nil and w.worldUI[d.bindTag].ID~=0 then
				w.worldUI[d.bindTag]:del()
			end
			w.worldUI[d.bindTag] = self
			h._n = CCNode:create()
			if IsBindToWorld==1 then
				h._n:setPosition(d.x,-1*d.y)
			else
				h._n:setPosition(d.x,d.y)
			end
			d.parent:addChild(h._n,hVar.ObjectZ.UI + d.z)
			if d.menu==1 then
				--menu模式下创建一个dragbox
				self.childUI["dragBox"] = hUI.dragBox:new({
					worldnode = h._n,
				})
			end
			hUI.createChildUI(self,d.child)
			if type(p.tick)=="number" then
				self:settick(p.tick)
			end
		else
			d.bindU = 0
			d.bindTag = 0
			d.tick = 1
		end
	else
		h._n = CCNode:create()
		if d.mode=="ground" and d.parent~=hUI.__static.uiLayer then
			h._n:setPosition(d.x,-1*d.y)
			d.parent:addChild(h._n,hVar.ObjectZ.UI + d.z)
			if d.menu==1 then
				--menu模式下创建一个dragbox
				self.childUI["dragBox"] = hUI.dragBox:new({
					worldnode = h._n,
				})
			end
			hUI.createChildUI(self,d.child)
		else
			h._n:setPosition(d.x,d.y)
			d.parent:addChild(h._n,d.z + 0)
			if d.menu==1 then
				--menu模式下创建一个dragbox
				self.childUI["dragBox"] = hUI.dragBox:new({
					node = h._n,
					buttononly = 1,
					autoactive = 0,
					ox = -1*hVar.SCREEN.w,
					oy = hVar.SCREEN.h,
					w = 2*hVar.SCREEN.w,
					h = 2*hVar.SCREEN.h,
				})
			end
			hUI.createChildUI(self,d.child)
		end
	end
end
_ugp.setXY = function(self,x,y)
	local d = self.data
	local h = self.handle
	if type(x)=="number" and type(y)=="number" then
		d.x = x
		d.y = y
		if d.bindW~=0 then
			h._n:setPosition(d.x,-1*d.y)
		else
			h._n:setPosition(d.x,d.y)
			if self.childUI["dragBox"] then
				self.childUI["dragBox"]:setbox(d.x,d.y,2*hVar.SCREEN.w,2*2*hVar.SCREEN.h)
			end
		end
	end
end
--======================================================================
--操作面板
--======================================================================
hUI.frame = eClass:new("static")
hUI.frame.__tFunc = {}									--Frame通用函数
local _ufrm = hUI.frame
local _ufrmFunc = hUI.frame.__tFunc
local __DefaultParam = {								--默认参数
	--parent = 0,--hUI.__static.uiLayer,
	ox = 0,
	oy = 0,
	x = 0,
	y = 0,
	w = 0,
	h = 0,
	batchmodel = 0,
	background = 1,
	bgMode = 0,		--[0,"tile"](无特殊模式，平铺)
	bgAlpha = 0,		--背景透明度(仅创建时有效)
	border = 0,		--可额外在外围绘制border
	closebtn = 0,		--[0,1,model]
	closeart = 0,		--如果此值不为0,那么点击closeBtn隐藏时，会尝试使用此模式来隐藏self:show(0,d.closeart)
	show = 1,
	dragable = 1,		--0:不能拖拽,1:可拖拽,2:全屏幕,{tx,ty,bx,by}:允许拖拽的区域,3:全屏可点击，但是点到该框外面的话就会关闭窗口,4:全屏可点击，但是点到该框外面的话就会抖一下
	autorelease = 0,
	titlebar = 1,
	buttononly = 0,
	autoactive = 1,
	--top = 0,		--如果此值为1，那么创建后一定在最顶上,且仅在param中读取，不记录入data
	codeOnTouch = 0,	--[function(self,relTouchX,relTouchY,IsInside)]
	codeOnDrop = 0,		--[function(self,x,y)]dragable==2时无效,0,1会传入相对于frm左上角的坐标,{}时传入屏幕绝对坐标
	codeOnDragEx = 0,	--[function(x,y)],任何对该frame上的拖拽都会触发此回调(包括拖动上面的button),存在效率问题不推荐使用
	lastShow = 0,		--上一次调用show时传入的参数
	--__showtick = 0,	--下一次处理显示的时间
	child = 0,
	clipper = 0,		--如果此值不为0，那么将启用剪切机制
	autoalign = 0,		--自动对齐，仅当clipper~=0且dragable==1时生效{sAlignMode,sGridKey,nMoveMin,nOffX,nOffY}
	scrollview = 0,		--填写此项后，触摸时可触发卷动{[1]={enable=1,dragable={0,0,0,0},clipper={0,0,0,0},autoalign={"V","RewardGrid",30,0,-30},codeOnPick=nil,codeOnUp=nil,codeOnDrop=nil}}
	closebtnX = 0,
	closebtnY = 0,
	closebtnW = -1,
	closebtnH = -1,
	codeOnClose = 0,
	--codeOnShow = 0,
}
_ufrm.destroy = function(self)
	local d = self.data
	local h = self.handle
	--内存清理:移除不需要的函数
	d.codeOnTouch = 0
	d.codeOnDrop = 0
	d.codeOnDragEx = 0
	--内存清理:释放不需要的表格
	d.child = 0
	--如果拥有剪切layer,那么移除该layer
	if type(h._clipper)=="table" and h._n then
		if #h._clipper>0 and h._n:getParent()==h._clipper[1][1] then
			d.parent = hUI.__static.uiLayer
			hApi.ReloadParent(h._n,hUI.__static.uiLayer)
			h._clipper[1][1]:getParent():removeChild(h._clipper[1][1],true)
		end
		h._clipper = nil
	end
	return hUI.destroyDefault(self)
end

-----------------------------------------
--frame功能函数
do
	_ufrmFunc.SetBoxByClipper = function(oFrm)
		local d = oFrm.data
		if d.clipper~=0 then
			local cx,cy,cw,ch = d.clipper[1],d.clipper[2],d.clipper[3],d.clipper[4]
			local ltx = math.max(cx,d.x+d.ox)
			local lty = math.min(cy,d.y+d.oy)
			local rbx = math.min(cx+cw,d.x+d.ox+d.w)
			local rby = math.max(cy-ch,d.y+d.oy-d.h)
			oFrm.childUI["dragBox"]:setbox(d.x,d.y,rbx-ltx,lty-rby,ltx-d.x,lty-d.y)
		end
	end

	_ufrmFunc.CalScrollNum = function(sAlignMode,tTempPos,cw,gw)
		if tTempPos==0 then
			return 0
		else
			if sAlignMode=="H" then
				if tTempPos.tx>tTempPos.dx then
					--向左卷动
					return math.ceil(cw/gw)
				else
					--向右卷动
					return math.floor(cw/gw)
				end
			elseif sAlignMode=="V" then
				if tTempPos.ty<tTempPos.dy then
					--向上卷动
					return math.ceil(cw/gw)
				else
					--向下卷动
					return math.floor(cw/gw)
				end
			else
				return 0
			end
		end
	end

	local __TokenGrid = {data={x=0,y=0,gridW=10,gridH=10}}
	local __TokenTempPos = {x=0,y=0,tx=0,ty=0,dx=0,dy=0}
	_ufrmFunc.GetAlignXYByGrid = function(x,y,nGridW,nGridH,ox,oy,tAlign,tDragable,tTempPos,ImmediateSetPos)
		local sAlignMode,sGridKey,nMoveMin,nOffX,nOffY = tAlign[1],tAlign[2],tAlign[3] or 60,tAlign[4] or 0,tAlign[5] or 0
		local tPos
		if tTempPos~=0 then
			tPos = tTempPos or __TokenTempPos
		else
			ImmediateSetPos = 1
			tPos = __TokenTempPos
		end
		if sAlignMode=="H" then
			--横向对齐
			local curX
			if ImmediateSetPos==1 or math.abs(x-tPos.x)>=nMoveMin then
				local nBaseX = tDragable[1]+tDragable[3]
				local nClipW = math.max(0,nBaseX-x)
				local scrollNum = _ufrmFunc.CalScrollNum(sAlignMode,tTempPos,nClipW,nGridW)
				local nMove = scrollNum*nGridW
				if nMove<0 then
					nMove = 0
				elseif nMove>tDragable[3]-nOffX then
					nMove = math.floor((tDragable[3]-nOffY)/nGridW)*nGridW
				end
				curX = nBaseX - ox - nMove
			else
				curX = tPos.x
			end
			curX = hApi.NumBetween(curX,tDragable[1],tDragable[1] + tDragable[3])
			if ImmediateSetPos==1 then
				return curX,y,0
			elseif tPos~=__TokenTempPos and math.abs(curX-tPos.x)>=nMoveMin then
				return curX,y,0.2
			else
				return curX,y,0.05
			end
		elseif sAlignMode=="V" then
			--纵向对齐
			local curY
			if ImmediateSetPos==1 or math.abs(y-tPos.y)>=nMoveMin then
				local nBaseY = tDragable[2]-tDragable[4]
				local nClipH = math.max(0,y-nBaseY)
				local scrollNum = _ufrmFunc.CalScrollNum(sAlignMode,tTempPos,nClipH,nGridH)
				local nMove = scrollNum*nGridH
				if nMove<0 then
					nMove = 0
				elseif nMove>tDragable[4]+nOffY then
					nMove = math.floor((tDragable[4]+nOffY)/nGridH)*nGridH
				end
				curY = nBaseY - oy + nMove
			else
				curY = tPos.y
			end
			curY = hApi.NumBetween(curY,tDragable[2]-tDragable[4],tDragable[2])
			if ImmediateSetPos==1 then
				return x,curY,0
			elseif tPos~=__TokenTempPos and math.abs(curY-tPos.y)>=nMoveMin then
				return x,curY,0.2
			else
				return x,curY,0.05
			end
		end
	end

	_ufrmFunc.AutoAlignByChildGrid = function(self,tTempPos,ImmediateSetPos)
		local d = self.data
		local sAlignMode = d.autoalign[1]
		local sGridKey = d.autoalign[2]
		local oGrid
		if type(sGridKey)=="table" then
			__TokenGrid.data.x = sGridKey[1] or 0
			__TokenGrid.data.y = sGridKey[2] or 0
			__TokenGrid.data.gridW = sGridKey[3] or 10
			__TokenGrid.data.gridH = sGridKey[4] or 10
			oGrid = __TokenGrid
		else
			oGrid = self.childUI[sGridKey]
		end
		if oGrid then
			local nGridW = oGrid.data.gridW
			local nGridH = oGrid.data.gridH
			local ox = oGrid.data.x
			local oy = oGrid.data.y
			if sAlignMode=="H" then
				ox = ox - math.floor(nGridW/2)
			elseif sAlignMode=="V" then
				oy = oy + math.floor(nGridH/2)
			end
			local newX,newY,nDelay = _ufrmFunc.GetAlignXYByGrid(d.x,d.y,nGridW,nGridH,ox,oy,d.autoalign,d.dragable,tTempPos,ImmediateSetPos)
			if newX and newY and nDelay then
				if d.show~=1 or nDelay<=0 then
					self:setXY(newX,newY)
				else
					self:setXY(newX,newY,nDelay)
				end
			end
		end
	end

	_ufrmFunc.AlignNodeByGrid = function(self,sNodeName,sGridName,tAutoAlign,tDragable,tTempPos,IsImmediateSetPos)
		local oNode = self.childUI[sNodeName]
		local oGrid = self.childUI[sGridName]
		if oGrid~=nil and oNode~=nil then
			local d = oGrid.data
			local ox,oy = (tAutoAlign[4] or 0),(tAutoAlign[5] or 0)
			local newX,newY,nDelay = _ufrmFunc.GetAlignXYByGrid(d.x,d.y,d.gridW,d.gridH,ox,oy,tAutoAlign,tDragable,tTempPos,IsImmediateSetPos)
			if newX and newY and nDelay then
				d.x = newX
				d.y = newY
				if nDelay<=0 then
					oNode.handle._n:setPosition(newX,newY)
				else
					oNode.handle._n:runAction(CCMoveTo:create(nDelay,ccp(newX,newY)))
				end
				return nDelay
			end
		end
	end
	
	_ufrmFunc.ShowFrmNode = function(self,bShow)
		local h = self.handle
		if h then
			local d = self.data
			if d then
				if h._n then
					h._n:setVisible(bShow)
					
					if type(h._clipper)=="table" and #h._clipper>0 then
						for i = 1,#h._clipper do
							if bShow==true then
								hApi.EnableClipNode(h._clipper[i],1)
							else
								hApi.EnableClipNode(h._clipper[i],0)
							end
						end
					end
				end
			end
		end
	end
	
	local _code_OnDragFrmScrollView = function(self,tTempPos,tPickParam)
		if tPickParam.state==0 then
			if (tTempPos.x-tTempPos.tx)^2+(tTempPos.y-tTempPos.ty)^2>144 then
				if hApi.gametime()-tTempPos.tick>60 and (tTempPos.x-tPickParam.ox)^2+(tTempPos.y-tPickParam.oy)^2<2800 then
					local tScrollview = tPickParam.scrollview
					if type(tScrollview.codeOnPick)=="function" and tScrollview.codeOnPick(self,tTempPos,tPickParam)==hVar.RESULT_SUCESS then
						tPickParam.state = 2
						tTempPos.tx = tTempPos.x
						tTempPos.ty = tTempPos.y
						return 0
					end
				end
				tPickParam.state = 1
				tTempPos.tx = tTempPos.x
				tTempPos.ty = tTempPos.y
			else
				return 0
			end
		elseif tPickParam.state==2 then
			if type(tPickParam.oImage)=="table" then
				tPickParam.oImage.handle._n:setPosition(tTempPos.x,tTempPos.y)
			end
			return 0
		end
	end

	local _code_OnDropFrmScrollView = function(self,tTempPos,tPickParam)
		if type(tPickParam.oImage)=="table" and tPickParam.oImage.ID~=0 then
			tPickParam.oImage:del()
			tPickParam.oImage = nil
		end
		local tScrollview = tPickParam.scrollview
		if tPickParam.state==0 then
			if type(tScrollview.codeOnUp)=="function" then
				return tScrollview.codeOnUp(self,tTempPos,tPickParam)
			end
		elseif tPickParam.state==1 then
			if type(tScrollview.ui)=="string" and type(tScrollview.autoalign)=="table" and type(tScrollview.dragable)=="table" then
				return _ufrmFunc.AlignNodeByGrid(self,tScrollview.ui,tScrollview.autoalign[2],tScrollview.autoalign,tScrollview.dragable,tTempPos)
			end
		elseif tPickParam.state==2 then
			if type(tScrollview.codeOnDrop)=="function" then
				return tScrollview.codeOnDrop(self,tTempPos,tPickParam)
			end
		end
	end

	local __FRM__ShakeLock = 0
	_ufrmFunc.CodeOnTouchFrm = function(x,y,screenX,screenY,self,tTempPos)
		local d = self.data
		local tick = hApi.gametime()
		if d.__showtick>tick then
			return hUI.dragBox:unselect()
		end
		if d.show~=1 then
			return hUI.dragBox:unselect()
		end
		tTempPos.tick = tick
		tTempPos.x = d.x
		tTempPos.y = d.y
		tTempPos.tx = screenX
		tTempPos.ty = screenY
		if d.dragable==0 then
			hUI.dragBox:unselect()
		elseif d.dragable==2 then
			hUI.dragBox:unselect()
		elseif d.dragable==3 then
			hUI.dragBox:unselect()
			local dLTX,dLTY,dRBX,dRBY = 0,0,d.w,-1*d.h
			if not(x>=dLTX and x<=dRBX and y>=dRBY and y<=dLTY) then
				local oBtnClose = self.childUI["btnClose"]
				if oBtnClose~=nil and type(oBtnClose.data.code)=="function" then
					oBtnClose.data.code(oBtnClose,1)
				else
					local sCloseArt
					if type(self.data.closeart)=="string" then
						sCloseArt = self.data.closeart
					end
					if type(self.data.codeOnClose) == "function" then
						self.data.codeOnCloseEx = self.data.codeOnClose(self) or 0
					end
					self:show(0,sCloseArt or "fade")
				end
				return
			end
		elseif d.dragable==4 then
			hUI.dragBox:unselect()
			local dLTX,dLTY,dRBX,dRBY = 0,0,d.w,-1*d.h
			if not(x>=dLTX and x<=dRBX and y>=dRBY and y<=dLTY) then
				if self.data.show==1 and __FRM__ShakeLock<=hApi.gametime() then
					__FRM__ShakeLock = hApi.gametime() + 160
					self.handle._n:runAction(CCSequence:createWithTwoActions(CCJumpBy:create(0.15,ccp(0,0),10,1),CCMoveTo:create(0,ccp(d.x,d.y))))
				end
				return
			end
		end
		if d.scrollview~=0 then
			local cx,cy = screenX-d.x,screenY-d.y
			for i = 1,#d.scrollview do
				local v = d.scrollview[i]
				if type(v)=="table" and v.ui~=nil and self.childUI[v.ui]~=nil and v.enable~=0 and (v.rect==nil or hApi.IsInBox(cx,cy,v.rect)) then
					local tPickParam = {
						scrollview = v,
						state=0,
						ox=screenX,
						oy=screenY,
					}
					if type(v.codeOnTouch)=="function" then
						if v.codeOnTouch(self,tTempPos,tPickParam)==hVar.RESULT_FAIL then
							return
						end
					end
					return self:pick(v.ui,v.dragable,tTempPos,{_code_OnDragFrmScrollView,_code_OnDropFrmScrollView,tPickParam})
				end
			end
		end
		if d.codeOnTouch~=0 then
			local IsInside = 1
			if type(d.dragable)=="number" and d.dragable>=2 then
				local dLTX,dLTY,dRBX,dRBY = 0,0,d.w,-1*d.h
				if not(x>=dLTX and x<=dRBX and y>=dRBY and y<=dLTY) then
					IsInside = 0
				end
			end
			return hpcall(d.codeOnTouch,self,x,y,IsInside,tTempPos)
		end
	end

	_ufrmFunc.CodeOnDropFrm = function(x,y,screenX,screenY,self,tTempPos,tBox)
		local d = self.data
		tTempPos.dx = screenX
		tTempPos.dy = screenY
		d.x,d.y = self.handle._n:getPosition()
		_ufrmFunc.SetBoxByClipper(self)
		if (d.dragable==1 or tBox~=nil) and d.autoalign~=0 then
			_ufrmFunc.AutoAlignByChildGrid(self,tTempPos,0)
		end
		if d.codeOnDrop~=0 then
			if d.dragable==0 or d.dragable==1 then
				return hpcall(d.codeOnDrop,self,x,y,tTempPos)
			else
				return hpcall(d.codeOnDrop,self,screenX,screenY,tTempPos)
			end
		end
	end
end
--------------------------------
--frame成员函数
local __checkNum4 = {"number","number","number","number"}
--local COUNTER = 0
--local DDDDDDDDDDC = 0
_ufrm.init = function(self,p)
	--[[
	if (p.border == 1) or (p.border == nil) then
		
		COUNTER = (COUNTER + 1) % 10
		if (COUNTER == 2) then
			DDDDDDDDDDC = (DDDDDDDDDDC + 1) % 5
			if (DDDDDDDDDDC == 2) then
				p.border = 0
				xlLG("frame", debug.traceback() .. "\n\n\n")
			end
		end
		
	end
	]]
	self.data = hUI.ReadParam(__DefaultParam,p,rawget(self,"data") or {})		--__DefaultParam:默认参数， p:创建窗口时的自定义的参数
	self.handle = hApi.clearTable(0,self.handle)
	self.childUI = hApi.clearTable(0,self.childUI)
	local d = self.data
	local h = self.handle
	if p.x==nil and p.y==nil and p.w~=nil and p.h~=nil then				--如果只设置了窗口宽高，没有设置坐标，则设置默认坐标为屏幕居中
		d.x = math.floor(hVar.SCREEN.w/2-d.w/2)
		d.y = math.floor(hVar.SCREEN.h/2+d.h/2)
	end
	local pFrmClipper,pFrmClipperMask,pFrmClipperMaskN
	local tLinkNode
	h._n = CCNode:create()								--为窗口创建一个节点，用于挂载子部件（在创建子部件时，设置parent = _fram.handle._n,）
	h._clipper = nil
	if type(d.clipper)=="table" and hApi.CheckTable(d.clipper,__checkNum4)==hVar.RESULT_SUCESS then
		d.buttononly = 0
		pFrmClipper,pFrmClipperMask,pFrmClipperMaskN = hApi.CreateClippingNode(hUI.__static.uiLayer,d.clipper,nil,d.clipper[5])
		if pFrmClipper then
			tLinkNode = {pFrmClipper}
			h._clipper = {{pFrmClipper,pFrmClipperMask,pFrmClipperMaskN}}
			d.parent = pFrmClipper
		else
			d.clipper = 0							--剪切节点（参考讲解：http://blog.csdn.net/lengxue789/article/details/41481329）
			d.parent = hUI.__static.uiLayer					--设置窗口的父节点
		end
	else
		d.clipper = 0
		d.parent = hUI.__static.uiLayer
	end
	h.__IsTemp = d.autorelease
	if d.batchmodel==0 then
		--创建默认frame
		if d.background==1 then
			if d.w<=0 and d.h<=0 then
				d.w = 400
				d.h = 260
			end
			d.w = math.max(32,d.w)
			d.h = math.max(16,d.h)
			d.bgMode = "tile"
			if p.border==nil then
				d.border = 1
			end
			--默认窗口
			
			h._n:setPosition(d.x,d.y)
			self:__InitBG("UI:TileFrmBasic")
			if d.border~=0 then
				self:addBorder(d.border)
			end
		elseif type(d.background)=="string" then
			h._n:setPosition(d.x,d.y)
			self:__InitBG(d.background)
			if d.border~=0 then
				self:addBorder(d.border)
			end
		else
			h.batchmode = "batch"
			hApi.SpriteInitBatchNode(h,"MODEL:default")
			h._n:addChild(h._bn)
			h._n:setPosition(d.x,d.y)					--设置用于挂载子部件的节点的位置
		end
	else
		--创建自定义frame
		h.batchmode = "batch"
		hApi.SpriteInitBatchNode(h,d.batchmodel)
		h._n:addChild(h._bn)
		h._n:setPosition(d.x,d.y)

		if type(d.background)=="string" then
			self.childUI["background"] = hUI.image:new({
				parent = h._n,
				mode = "image",
				model = d.background,
				align = "LT",
			})
			d.w,d.h = self.childUI["background"].data.w,self.childUI["background"].data.h
		end
	end

	--对于直接指定z值的frame关闭dragbox的自动排序功能
	local _autosort = 1
	if p and type(p.z)=="number" then
		_autosort = 0
		d.parent:addChild(h._n,p.z)
	else
		d.parent:addChild(h._n)
	end

	--存在裁剪层
	if pFrmClipper then
		pFrmClipper:getParent():reorderChild(pFrmClipper,h._n:getZOrder())
	end

	if d.dragable==-1 then
	elseif (type(d.dragable)=="number" and d.dragable>=2) and d.clipper==0 then
		local d = self.data
		local tTempPos = {tick=0,x=0,y=0,tx=0,ty=0,dx=0,dy=0,ox=0,oy=0}
		self.childUI["dragBox"] = hUI.dragBox:new({
			node = h._n,
			x = _x,
			y = _y,
			oy = hVar.SCREEN.h,
			ox = -1*hVar.SCREEN.w,
			w = 2*hVar.SCREEN.w,
			h = 2*hVar.SCREEN.h,
			top = p.top,
			buttononly = d.buttononly,
			autoactive = d.autoactive,
			autosort = _autosort,
			codeOnDragEx = d.codeOnDragEx,
			codeOnTouch = function(x,y,screenX,screenY)
				return _ufrmFunc.CodeOnTouchFrm(x,y,screenX,screenY,self,tTempPos)
			end,
		})
	else
		local tBox
		if type(d.dragable)=="table" then
			tBox = d.dragable
			tBox[1] = tBox[1] + d.x
			tBox[2] = tBox[2] + d.y
			if tBox[3]<0 or tBox[4]<0 then
				_DEBUG_MSG("[LUA WARNING]frm:dragable中出现负数:{"..tBox[1]..","..tBox[2]..","..tBox[3]..","..tBox[4].."}")
			end
			tBox[3] = math.max(0,tBox[3])
			tBox[4] = math.max(0,tBox[4])
		end
		local h = self.handle
		local d = self.data
		local tTempPos = {tick=0,x=0,y=0,tx=0,ty=0,dx=0,dy=0,ox=0,oy=0}
		local _codeOnDragEx = d.codeOnDragEx
		self.childUI["dragBox"] = hUI.dragBox:new({
			node = h._n,
			ox = d.ox,
			oy = d.oy,
			w = d.w,
			h = d.h,
			top = p.top,
			box = tBox,
			linknode = tLinkNode,
			buttononly = d.buttononly,
			autoactive = d.autoactive,
			autosort = _autosort,
			codeOnDragEx = _codeOnDragEx,
			codeOnTouch = function(x,y,screenX,screenY)
				return _ufrmFunc.CodeOnTouchFrm(x,y,screenX,screenY,self,tTempPos)
			end,
			codeOnDrop = function(x,y,screenX,screenY)
				return _ufrmFunc.CodeOnDropFrm(x,y,screenX,screenY,self,tTempPos,tBox)
			end,
		})
		_ufrmFunc.SetBoxByClipper(self)
	end
	if d.closebtn==0 then
	elseif d.closebtn==1 then
		self.childUI["btnClose"] = hUI.button:new({
			parent = h._n,
			model = "BTN:PANEL_CLOSE",--"UI:BTN_Close",
			x = d.w-15,
			y = -17,
			w = 30,
			h = 30,
			scaleT = 0.95,
			dragbox = self.childUI["dragBox"],
			code = function()
				local sCloseArt
				if type(self.data.closeart)=="string" then
					sCloseArt = self.data.closeart
				end
				if type(self.data.codeOnClose) == "function" then
					self.data.codeOnCloseEx = self.data.codeOnClose(self) or 0
				end
				self:show(0,sCloseArt or "normal")
			end,
		})
	elseif type(d.closebtn)=="string" then
		local btn = hUI.button:new({
			parent = h._n,
			model = d.closebtn,
			w = d.closebtnW,
			h = d.closebtnH,
			scaleT = 0.95,
			dragbox = self.childUI["dragBox"],
			code = function()
				local sCloseArt
				if type(self.data.closeart)=="string" then
					sCloseArt = self.data.closeart
				end
				if type(self.data.codeOnClose) == "function" then
					self.data.codeOnCloseEx = self.data.codeOnClose(self) or 0
				end
				self:show(0,sCloseArt or "normal")
				if type(d.codeOnClose) == "function" then
					d.codeOnClose(self)
				end
			end,
		})
		self.childUI["btnClose"] = btn
		if d.closebtnX ~=0 and d.closebtnY ~= 0 then
			self.childUI["btnClose"]:setXY(d.closebtnX,d.closebtnY)
		else
			local x,y = d.w-math.floor(btn.data.w/2),-1*math.floor(btn.data.h/3)
			self.childUI["btnClose"]:setXY(x,y)
		end
	elseif type(d.closebtn)=="table" then
		local tParam = {
			parent = h._n,
			model = "UI:PANEL_Close",
			w = -1,
			h = -1,
			scaleT = 0.95,
			dragbox = self.childUI["dragBox"],
			code = function()
				local sCloseArt
				if type(self.data.closeart)=="string" then
					sCloseArt = self.data.closeart
				end
				if type(self.data.codeOnClose) == "function" then
					self.data.codeOnCloseEx = self.data.codeOnClose(self) or 0
				end
				self:show(0,sCloseArt or "normal")
				if type(d.codeOnClose) == "function" then
					d.codeOnClose(self)
				end
			end,
		}
		for k,v in pairs(d.closebtn)do
			tParam[k] = v
		end
		local btn = hUI.button:new(tParam)
		self.childUI["btnClose"] = btn
		if tParam.x==nil and tParam.y==nil then
			if d.closebtnX~=0 and d.closebtnY~= 0 then
				self.childUI["btnClose"]:setXY(d.closebtnX,d.closebtnY)
			else
				local x,y = d.w-math.floor(btn.data.w/2),-1*math.floor(btn.data.h/3)
				self.childUI["btnClose"]:setXY(x,y)
			end
		end
	end
	local isShow = d.show
	d.show = 1
	d.lastShow = 0
	d.__showtick = 0
	self:show(isShow)
	hUI.createChildUI(self,d.child)
end
local __TokenDragData = {}
_ufrm.autoalign = function(self,tDragData)
	local d = self.data
	if type(d.autoalign)=="table" then
		local IsImmedaiteSetPos = 0
		if tDragData==1 then
			IsImmedaiteSetPos = 1
		end
		if type(tDragData)~="table" then
			tDragData = __TokenDragData
			__TokenDragData.tx = -999
			__TokenDragData.ty = 999
			__TokenDragData.dx = 0
			__TokenDragData.dy = 0
			__TokenDragData.x = d.x
			__TokenDragData.y = d.y
		end
		_ufrmFunc.AutoAlignByChildGrid(self,tDragData,IsImmedaiteSetPos)
	end
end
local __FrameModelSmart = {
	name = "UI:SmartFrameBG",
	image = "frmBG.png",
	animation = {
		"normal",
		"smart",
	},
	normal = {
		[1] = {0,0,160,160},
	},
	smart = {
		[1] = {0,0,160,160},
	},
}
hVar.tab_model:add(__FrameModelSmart)
local __CalRepeatCount = function(w,nLength)
	if w<nLength then
		return 0,w
	elseif w>0 and nLength>0 then
		local r = math.mod(w,nLength)
		return math.floor((w-r)/nLength),r
	else
		return 0,0
	end
end
_ufrm.__InitBG = function(self,sBackground)
	local h = self.handle
	local d = self.data
	if d.bgMode=="tile" then
		h.batchmode = "batch"
		local tModelB = hApi.GetSafeModelByKey(sBackground)
		local aBase = tModelB.normal or tModelB[tModelB.animation[1]]
		local tModelS = hApi.GetSafeModelByKey("UI:SmartFrameBG")
		local aSmart = tModelS.smart
		tModelS.image = tostring(tModelB.image)
		local _baseX,_baseY = aBase[1][1],aBase[1][2]
		local _baseW,_baseH = aBase[1][3],aBase[1][4]
		local _wRep,_wLeft = __CalRepeatCount(d.w,_baseW)
		local _hRep,_hLeft = __CalRepeatCount(d.h,_baseH)
		local curX,curY = 0,0
		local hRep,hLeft = _hRep,_hLeft
		if h._bn~=nil then
			h._bn:removeAllChildrenWithCleanup(true)
		else
			hApi.SpriteInitBatchNode(h,"UI:SmartFrameBG")
			h._n:addChild(h._bn,-1)
		end
		h.s = h._n
		while(hRep>0 or hLeft>0)do
			local baseX,baseY = _baseX,_baseY
			local baseW,baseH = 0,0
			local IsDrawY = 0
			if hRep<=0 and hLeft>0 then
				baseW = _baseW
				baseH = hLeft
				------------
				hLeft = 0
				IsDrawY = 1
			elseif hRep>0 then
				baseW = _baseW
				baseH = _baseH
				------------
				hRep = hRep - 1
				IsDrawY = 1
			end
			if IsDrawY==1 then
				local wRep,wLeft = _wRep,_wLeft
				local curW,curH = 0,0
				while(wRep>0 or wLeft>0)do
					local IsDrawX = 0
					if wRep<=0 and wLeft>0 then
						curW = wLeft
						curH = baseH
						------------
						wLeft = 0
						IsDrawX = 1
					elseif wRep>0 then
						curW = baseW
						curH = baseH
						------------
						wRep = wRep - 1
						IsDrawX = 1
					end
					if IsDrawX==1 then
						aSmart[1][1],aSmart[1][2] = baseX,baseY
						aSmart[1][3],aSmart[1][4] = curW,curH
						local s = hApi.SpriteBatchNodeAddChild(h,"smart","LT",-1,-1)
						if s~=nil then
							s:setPosition(curX,curY)
							if d.bgAlpha>0 then
								s:setOpacity(math.min(d.bgAlpha,255))
							end
						end
						curX = curX + curW
					end
				end
				curX = 0
				curY = curY - baseH
			end
		end
	else
		--hApi.SpriteInitBatchNode(h,sBackground)
		--h.s,d.w,d.h = hApi.SpriteBatchNodeAddChild(h,"normal","LT",d.w,d.h)
		--h._n:addChild(h._bn)
		h.batchmode = nil
		hApi.setModel(h,sBackground)
		h.s,d.w,d.h = hApi.SpriteLoadOneFrame(h,"normal",1,"LT",d.w,d.h)
		h._bn = h.s
		h._n:addChild(h.s)
	end
end

local __FrameBorderUIList = {"LC","RC","MT","MB","LB","RB","LT","RT"}
local __FrameBorderUITemp = {
	LT = {0,0},
	RT = {0,0},
	LB = {0,0},
	RB = {0,0},
	LC = {0,0,0,0},
	RC = {0,0,0,0},
	MT = {0,0,0,0},
	MB = {0,0,0,0},
}
local __CODE__GetUIHandle = function(oUI)
	return oUI.handle._n
end
_ufrm.addBorder = function(self,sModelName)
	if type(sModelName)~="string" then
		sModelName = "UI:TileFrmBasic"
	end
	local tImageList = __FrameBorderUIList
	local tImageTemp = __FrameBorderUITemp
	local tabM = hApi.GetModelByName(sModelName)
	if tabM==nil then
		_DEBUG_MSG("[FRAME ADDBORDER]模型"..tostring(sModelName).."不存在")
		return
	end
	for i = 1,#tImageList do
		if tabM[tImageList[i]]==nil then
			_DEBUG_MSG("[FRAME ADDBORDER]模型"..tostring(sModelName).."格式不正确")
			return
		end
	end
	local d = self.data
	local h = self.handle

	tImageTemp.LT[1] = 0
	tImageTemp.LT[2] = 0

	tImageTemp.RT[1] = d.w
	tImageTemp.RT[2] = 0

	tImageTemp.LB[1] = 0
	tImageTemp.LB[2] = -1*d.h

	tImageTemp.RB[1] = d.w
	tImageTemp.RB[2] = -1*d.h

	tImageTemp.LC[1] = 0
	tImageTemp.LC[2] = -1*math.floor(d.h/2)
	tImageTemp.LC[3] = tabM.LC[1][3]
	tImageTemp.LC[4] = d.h - tabM.LT[1][4] - tabM.LB[1][4]

	tImageTemp.RC[1] = d.w
	tImageTemp.RC[2] = -1*math.floor(d.h/2)
	tImageTemp.RC[3] = tabM.RC[1][3]
	tImageTemp.RC[4] = d.h - tabM.RT[1][4] - tabM.RB[1][4]

	tImageTemp.MT[1] = math.floor(d.w/2)
	tImageTemp.MT[2] = 0
	tImageTemp.MT[3] = d.w - tabM.LT[1][3] - tabM.RT[1][3]
	tImageTemp.MT[4] = tabM.MT[1][4]

	tImageTemp.MB[1] = math.floor(d.w/2)
	tImageTemp.MB[2] = -1*d.h
	tImageTemp.MB[3] = d.w - tabM.LB[1][3] - tabM.RB[1][3]
	tImageTemp.MB[4] = tabM.MB[1][4]

	for i = 1,#tImageList do
		local k = tImageList[i]
		if tabM[k].plus~=nil then
			for n = 1,#tImageTemp[k] do
				tImageTemp[k][n] = tImageTemp[k][n] + (tabM[k].plus[n] or 0)
			end
		end
	end

	for i = 1,#tImageList do
		local k = tImageList[i]
		local v = tImageTemp[k]
		local s = h["_s"..k]
		if s~=nil then
			s:getParent():removeChild(s,true)
		end
		h["_s"..k] = hUI.deleteUIObject(hUI.image:new({
			parent = self.handle._n,
			mode = "image",
			model = sModelName,
			animation = k,
			align = k,
			x = v[1],
			y = v[2],
			w = v[3],
			h = v[4],
		}),__CODE__GetUIHandle)
	end
end

_ufrm.showBorder = function(self,show)
	local h = self.handle
	local d = self.data
	local HaveBorder = 1
	local tImageList = __FrameBorderUIList
	for i = 1,#tImageList do
		local k = tImageList[i]
		if h["_s"..k]==nil then
			HaveBorder = 0
			break
		end
	end
	if HaveBorder==1 then
		if show==1 then
			for i = 1,#tImageList do
				h["_s"..tImageList[i]]:setVisible(true)
			end
		else
			for i = 1,#tImageList do
				h["_s"..tImageList[i]]:setVisible(false)
			end
		end
	elseif show==1 then
		self:addBorder(d.border)
	end
end

_ufrm.setXY = function(self,x,y,nDelay,tDragRect)
	if x==nil or y==nil then
		return
	end
	local d = self.data
	local h = self.handle
	d.x,d.y = x,y
	if type(nDelay)=="number" and nDelay>0 then
		h._n:runAction(CCMoveTo:create(nDelay,ccp(d.x,d.y)))
	else
		h._n:setPosition(d.x,d.y)
	end
	if self.childUI["dragBox"]~=nil then
		if type(d.dragable)=="number" and d.dragable>=2 then
			local ox = -1*d.x
			local oy = math.floor(hVar.SCREEN.h-d.y)
			local w = hVar.SCREEN.w
			local h = hVar.SCREEN.h
			self.childUI["dragBox"]:setbox(d.x,d.y,w,h,ox,oy)
		else
			if type(d.dragable)=="table" and type(tDragRect)=="table" then
				local tBox = d.dragable
				tBox[1] = tDragRect[1] + d.x
				tBox[2] = tDragRect[2] + d.y
				tBox[3] = math.max(0,tDragRect[3] or tBox[3])
				tBox[4] = math.max(0,tDragRect[4] or tBox[4])
			end
			if d.clipper~=0 then
				_ufrmFunc.SetBoxByClipper(self)
			else
				self.childUI["dragBox"]:setbox(d.x,d.y,d.w,d.h)
			end
		end
	end
end

_ufrm.setDragRect = function(self,tDragRect)
	local d = self.data
	if type(d.dragable)=="table" and type(tDragRect)=="table" then
		local tBox = d.dragable
		tBox[1] = tDragRect[1]
		tBox[2] = tDragRect[2]
		tBox[3] = math.max(0,tDragRect[3] or tBox[3])
		tBox[4] = math.max(0,tDragRect[4] or tBox[4])
	end
end

_ufrm.setWH = function(self,width,height)
	if width==nil or height==nil then
		return
	end
	local d = self.data
	local h = self.handle
	if d.background==1 then
		d.w = math.max(32,width)
		d.h = math.max(16,height)
		self:__InitBG("UI:TileFrmBasic")
		if d.border~=0 then
			self:addBorder(d.border)
		end
		--默认窗口
		if self.childUI["dragBox"]~=nil then
			if type(d.dragable)=="number" and d.dragable>=2 then
				local ox = -1*d.x
				local oy = math.floor(hVar.SCREEN.h-d.y)
				local w = hVar.SCREEN.w
				local h = hVar.SCREEN.h
				self.childUI["dragBox"]:setbox(d.x,d.y,w,h,ox,oy)
			else
				if d.clipper~=0 then
					_ufrmFunc.SetBoxByClipper(self)
				else
					self.childUI["dragBox"]:setbox(d.x,d.y,d.w,d.h)
				end
			end
		end
	elseif type(d.background)=="string" then
		d.w = math.max(32,width)
		d.h = math.max(16,height)
		if h._bn~=nil then
			if d.bgMode=="tile" then
				if h._bn then
					h._n:removeChild(h._bn,true)
					h._bn = nil
				end
				self:__InitBG(d.background)
			else
				--local _batchNode = h._bn
				--_batchNode:removeAllChildrenWithCleanup(true)
				--h.s,d.w,d.h = hApi.SpriteBatchNodeAddChild(h,"normal","LT",d.w,d.h)
				if h.s~=nil then
					h.s:getParent():removeChild(h.s,true)
					h.s = nil
				end
				self:__InitBG(d.background)
			end
		end
		if d.border~=0 then
			self:addBorder(d.border)
		end
		if self.childUI["dragBox"]~=nil then
			if type(d.dragable)=="number" and d.dragable>=2 then
				local ox = -1*d.x
				local oy = math.floor(hVar.SCREEN.h-d.y)
				local w = hVar.SCREEN.w
				local h = hVar.SCREEN.h
				self.childUI["dragBox"]:setbox(d.x,d.y,w,h,ox,oy)
			else
				if d.clipper~=0 then
					_ufrmFunc.SetBoxByClipper(self)
				else
					self.childUI["dragBox"]:setbox(d.x,d.y,d.w,d.h)
				end
			end
		end
	end
end

local __CALLBACK__PickChildOnDrag = function(pNode,tData,tDragable,tTempPos,IsSmooth)
	if tDragable and tDragable~=0 then
		if IsSmooth ~=1 then
			tData.x = hApi.NumBetween(tTempPos.x+tTempPos.ox-tTempPos.tx,tDragable[1],tDragable[1]+tDragable[3])
			tData.y = hApi.NumBetween(tTempPos.y+tTempPos.oy-tTempPos.ty,tDragable[2]-tDragable[4],tDragable[2])
		else
			if tDragable[3]==0 and tDragable[4]~=0 then
				local nSmooth = 32
				tData.x = tDragable[1]
				local curY = tTempPos.y+tTempPos.oy-tTempPos.ty
				if tData.y<tDragable[2]-tDragable[4] then
					local v = tDragable[2] - tDragable[4] - curY
					tData.y = tDragable[2] - tDragable[4] - math.floor(v*math.max(0.2,nSmooth/(2*v+nSmooth)))
				elseif curY>tDragable[2] then
					local v = curY - tDragable[2]
					tData.y = tDragable[2] + math.floor(v*math.max(0.2,nSmooth/(2*v+nSmooth)))
				else
					tData.y = curY
				end
			elseif tDragable[3]~=0 and tDragable[4]==0 then
				local nSmooth = 32
				tData.y = tDragable[2]
				local curX = tTempPos.x+tTempPos.ox-tTempPos.tx
				if tData.x<tDragable[1] then
					local v = tDragable[1] - curX
					tData.x = tDragable[1] - math.floor(v*math.max(0.2,nSmooth/(2*v+nSmooth)))
				elseif curX>tDragable[1]+tDragable[3] then
					local v = curX - tDragable[1] - tDragable[3]
					tData.x = tDragable[1] + tDragable[3] + math.floor(v*math.max(0.2,nSmooth/(2*v+nSmooth)))
				else
					tData.x = curX
				end
			else
				tData.x = hApi.NumBetween(tTempPos.x+tTempPos.ox-tTempPos.tx,tDragable[1],tDragable[1]+tDragable[3])
				tData.y = hApi.NumBetween(tTempPos.y+tTempPos.oy-tTempPos.ty,tDragable[2]-tDragable[4],tDragable[2])
			end
		end
	else
		tData.x = tTempPos.x+tTempPos.ox-tTempPos.tx
		tData.y = tTempPos.y+tTempPos.oy-tTempPos.ty
	end
	pNode:setPosition(tData.x,tData.y)
end
_ufrm.pick = function(self,sChildName,tDragable,tTempPos,tParam,IsSmooth)
	local oChildUI = self.childUI[sChildName]
	if oChildUI then
		local tData = oChildUI.data
		local pNode = oChildUI.handle._n
		if tData and pNode then
			if tTempPos==nil then
				tTempPos = {}
			end
			tTempPos.tick = hApi.gametime()
			tTempPos.x = tData.x
			tTempPos.y = tData.y
			tTempPos.tx = hUI.LastTouchPos[1]
			tTempPos.ty = hUI.LastTouchPos[2]
			tTempPos.dx = 0
			tTempPos.dy = 0
			tTempPos.ox = oChildUI.data.x
			tTempPos.oy = oChildUI.data.y
			local fCodeOnDrag = nil
			local fCodeOnDrop = nil
			local tCodeParam = nil
			local case = type(tParam)
			if case=="function" then
				fCodeOnDrag = nil
				fCodeOnDrop = tParam
				tCodeParam = nil
			elseif case=="table" then
				local caseP = type(tParam[1])
				if caseP=="number" then
					local nAreaR = tParam[1]*tParam[1]
					fCodeOnDrag = function(self,tTempPos,tCodeParam)
						if (tTempPos.x-tTempPos.tx)^2+(tTempPos.y-tTempPos.ty)^2>nAreaR then
							fCodeOnDrag = nil
							tTempPos.tx = tTempPos.x
							tTempPos.ty = tTempPos.y
							if type(tCodeParam)=="table" then
								tCodeParam.state = 1
							end
						else
							return 0
						end
					end
				elseif caseP=="function" then
					fCodeOnDrag = tParam[1]
				else
					fCodeOnDrag = nil
				end
				fCodeOnDrop = tParam[2]
				tCodeParam = tParam[3]
			else
				fCodeOnDrag = nil
				fCodeOnDrop = nil
				tCodeParam = nil
			end
			hUI.dragBox:new({
				node = 0,
				autorelease = 1,
				codeOnDrag = function(x,y,screenX,screenY)
					tTempPos.x = screenX
					tTempPos.y = screenY
					local nCanMove = 1
					if fCodeOnDrag then
						nCanMove = rpcall(fCodeOnDrag,self,tTempPos,tCodeParam)
					end
					if nCanMove~=0 then
						return __CALLBACK__PickChildOnDrag(pNode,tData,tDragable,tTempPos,IsSmooth)
					end
				end,
				codeOnDrop = function(x,y,screenX,screenY)
					tTempPos.x = screenX
					tTempPos.y = screenY
					tTempPos.dx = screenX
					tTempPos.dy = screenY
					local nCanMove = 1
					if fCodeOnDrag then
						nCanMove = rpcall(fCodeOnDrag,self,tTempPos,tCodeParam)
					end
					if nCanMove~=0 then
						__CALLBACK__PickChildOnDrag(pNode,tData,tDragable,tTempPos,IsSmooth)
					end
					if fCodeOnDrop then
						return hpcall(fCodeOnDrop,self,tTempPos,tCodeParam)
					end
				end,
			}):select()
		end
	end
end

_ufrm.aligngrid = function(self,tAutoAlign,tDragable,tTempPos,IsImmediateSetPos)
	return _ufrmFunc.AlignNodeByGrid(self,tAutoAlign[2],tAutoAlign[2],tAutoAlign,tDragable,tTempPos,IsImmediateSetPos)
end

_ufrm.reset = function(self)
	local d = self.data
	local h = self.handle
	if d.lastShow==0 then
		
	end
	h._n:setPosition(d.x,d.y)
	h._n:setScale(1)
end

local __GameTime
local __UI_FrameShowCodeProcess = function(self)
	local d = self.data
	if d.__showtick~=0 then
		local t = d.__showtick
		d.__showtick = 0
		if t<=__GameTime then
			if d.show==0 then
				return self.handle._n:setVisible(false)
			end
			if d.show==1 then
				return self.childUI["dragBox"]~=nil and self.childUI["dragBox"]:enable(1)
			end
		else
			d.__showtick = t
		end
	end
end

hApi.addTimerForever("__UI_FrameShowCodeProcess",hVar.TIMER_MODE.GAMETIME,1,function(tick)
	__GameTime = tick
	hUI.frame:enum(__UI_FrameShowCodeProcess)
end,1)

--local __self,__code
--local __CodeOnShow = function()
	--return __code(self)
--end

local __TokenDragbox = {enable = hApi.DoNothing}
_ufrm.show = function(self,isShow,showStyle,showParam)
	local d = self.data
	local h = self.handle
	--if isShow==1 and d.codeOnShow~=0 and type(d.codeOnShow) == "function" then
		--__self = self
		--__code = d.codeOnShow
		--xpcall(__CodeOnShow,hGlobal.__TRACKBACK__)
	--end
	
	local _dragbox = self.childUI["dragBox"] or __TokenDragbox
	if showStyle=="delay" then
		if type(showParam)=="number" then
			if isShow==1 then
				self:reset()
				d.show = isShow
				d.__showtick = hApi.gametime() + hApi.getint(showParam)
				_ufrmFunc.ShowFrmNode(self,true)
			else
				d.__showtick = hApi.gametime() + hApi.getint(showParam)
				d.show = isShow
				_dragbox:enable(0)
			end
			return	--_ufrm.show:return
		end
	elseif showStyle=="normal" then
		local time = 0.15
		if isShow==1 then
			if d.show~=1 then
				--self:reset()
				d.show = isShow
				d.__showtick = hApi.gametime() + hApi.getint(time*1000)
				_ufrmFunc.ShowFrmNode(self,true)
				if h._n then
					h._n:setScale(0)
					h._n:setPosition(d.x+d.w,d.y)
					h._n:runAction(CCScaleTo:create(time,1))
					h._n:runAction(CCMoveTo:create(time,ccp(d.x,d.y)))
				end
			end
		else
			if d.show~=0 then
				d.show = isShow
				_dragbox:enable(0)
				d.__showtick = hApi.gametime() + hApi.getint(time*1000)
				if h._n then
					h._n:runAction(CCScaleTo:create(time,0))
					h._n:runAction(CCMoveTo:create(time,ccp(d.x+d.w,d.y)))
				end
			end
		end
		return		--_ufrm.show:return
	elseif showStyle=="fade" then
		if isShow==1 then
			local time = 0.25
			if d.show~=1 then
				if type(showParam)=="table" then
					time = showParam.time or 0.25
				end
				self:reset()
				d.show = isShow
				d.__showtick = hApi.gametime() + hApi.getint(time*1000)
				_ufrmFunc.ShowFrmNode(self,true)
				if h._n then
					h._n:setScale(0)
					h._n:runAction(CCScaleTo:create(time,1))
					h._n:setPosition(d.x+d.w/2,d.y-d.h/2)
					h._n:runAction(CCMoveTo:create(time,ccp(d.x,d.y)))
				end
			end
		else
			local time = 0.25
			if d.show~=0 then
				if type(showParam)=="table" then
					time = showParam.time or 0.25
				end
				d.show = isShow
				_dragbox:enable(0)
				d.__showtick = hApi.gametime() + hApi.getint(time*1000)
				--local scale = 1
				--h._n:runAction(CCScaleTo:create(time,scale))
				--local tx,ty = math.floor(d.x-d.w*(scale-1)/2),math.floor(d.y+d.h*(scale-1)/2)
				--h._n:runAction(CCMoveTo:create(time,ccp(tx,ty))))
				--h._bn:runAction(CCFadeOut:create(time))
				local tx,ty = d.x,d.y
				if h._n then
					h._n:runAction(CCJumpTo:create(time,ccp(tx,ty-64),32,1))
				end
			end
		end
		return		--_ufrm.show:return
	elseif showStyle=="appear" then
		if isShow==1 then
			if d.show~=1 then
				self:reset()
				d.show = isShow
				local time = 0.08
				local fromX,fromY,jumpH = d.x,d.y-8,4
				if type(showParam)=="table" then
					time = showParam.time or 0.25
					fromX = showParam.x or fromX
					fromY = showParam.y or fromY
					jumpH = showParam.h or 0
				end
				d.__showtick = hApi.gametime() + hApi.getint(time*1000)
				_ufrmFunc.ShowFrmNode(self,true)
				if h._n then
					h._n:setPosition(fromX,fromY)
					if jumpH~=0 then
						h._n:runAction(CCJumpTo:create(time,ccp(d.x,d.y),jumpH,1))
					else
						h._n:runAction(CCMoveTo:create(time,ccp(d.x,d.y)))
					end
				end
			end
		else
			if d.show~=0 then
				d.show = isShow
				_dragbox:enable(0)
				local time = 0.25
				local toX,toY,jumpH = d.x,d.y-64,32
				if type(showParam)=="table" then
					time = showParam.time or 0.25
					toX = showParam.x or toX
					toY = showParam.y or toY
					jumpH = showParam.h or 0
				end
				d.__showtick = hApi.gametime() + hApi.getint(time*1000)
				if h._n then
					if jumpH~=0 then
						h._n:runAction(CCJumpTo:create(time,ccp(toX,toY),jumpH,1))
					else
						h._n:runAction(CCMoveTo:create(time,ccp(toX,toY)))
					end
				end
			end
		end
		return		--_ufrm.show:return
	end
	if isShow==1 then
		if d.show~=1 then
			self:reset()
			d.show = isShow
			_dragbox:enable(1)
			d.__showtick = 0
			_ufrmFunc.ShowFrmNode(self,true)
		end
	else
		if d.show~=0 then
			d.show = isShow
			_dragbox:enable(0)
			d.__showtick = 0
			_ufrmFunc.ShowFrmNode(self,false)
		end
	end
end

_ufrm.active = function(self,nDragable)
	local d = self.data
	local dargBox = self.childUI["dragBox"]
	if dargBox~=nil then
		dargBox:active()
		if nDragable~=nil then
			if nDragable==1 then
				dargBox:setbox(d.x,d.y,d.w,d.h,d.ox,d.oy)
			elseif nDragable==2 or nDragable==3 or nDragable==4 then
				dargBox:setbox(d.x,d.y,2*hVar.SCREEN.w,2*hVar.SCREEN.h,-1*hVar.SCREEN.w,hVar.SCREEN.h)
			end
		end
	end
end

_ufrm.onscreen = function(self,borderW)
	local d = self.data
	local v = borderW or 20
	local x = math.max(math.min(d.x,hVar.SCREEN.w-v),v-d.w)
	local y = math.max(math.min(d.y,hVar.SCREEN.h+d.h-v),v)
	if x~=d.x or y~=d.y then
		self:setXY(x,y)
	end
end

local __CloseAllActiveFrame = function()
end
hUI.CloseAllActivedFrame = function()
	hUI.frame:enum(__CloseAllActiveFrame)
end


--local frm = hGlobal.O:replace("xxxxx",hUI.frame:new({
	--x = 350,
	--y = 600,
	--closebtn = 0,--"BTN:PANEL_CLOSE",
	--background = "UI:TileFrmBack",
	--bgMode = "tile",
	--w = 470,
	--h = 400,
--}))
--local t = {
	--img = {
		--"LC","RC","MT","MB","LB","RB","LT","RT",
	--},
	--LT = {-24,			24},
	--RT = {frm.data.w+23,		24},
	--LB = {-24+1,			-1*frm.data.h-24},
	--RB = {frm.data.w+23,		-1*frm.data.h-24},
	--LC = {-30,			-1*frm.data.h/2,		48,				frm.data.h-96*2+48},
	--RC = {frm.data.w+33,		-1*frm.data.h/2,		48,				frm.data.h-96*2+48},
	--MT = {frm.data.w/2,		25,				frm.data.w-96*2+46+2,		48},
	--MB = {frm.data.w/2,		-1*frm.data.h-27,		frm.data.w-96*2+46,		48},
--}

--for i = 1,#t.img do
	--local k = t.img[i]
	--local v = t[k]
	--if v then
		--hUI.deleteUIObject(hUI.image:new({
			--parent = frm.handle._n,
			--mode = "image",
			--model = "UI:TileFrmBack",
			--animation = k,
			--align = k,
			--x = v[1],
			--y = v[2],
			--w = v[3],
			--h = v[4],
		--}))
	--end
--end
---------------------------------------------
--特殊支持函数
local __UI__GetUIHandle = function(oUI)
	return oUI.handle._n
end
local __UI__ExecuteParamFunc = function(nMode,pCode,tParam)
	nMode = nMode or 0
	if nMode==1 then
		
	elseif nMode==2 then
		
	elseif nMode==3 then
		return tParam[1](tParam[2],tParam[3])
	else
		return tParam[1](tParam[2],tParam[3])
	end
end

-- tParam默认值
local __UI__tParam = {}
-- 可基于UI模板+参数创建多个同类UI
-- @param pParent table
-- @param x number
-- @param y number
-- @param tUIList table UI定义参数表的列表
-- @param tHandleTable table
-- @param tParam table
hUI.CreateMultiUIByParam = function(pParent,x,y,tUIList,tHandleTable,tParam)
	if tParam==nil then
		tParam = __UI__tParam
	end
	if tHandleTable==nil then
		tHandleTable = {}
	end
	local tChildUI
	if type(pParent)=="table" then
		tChildUI = pParent.childUI
		-- 父节点
		pParent = pParent.handle._n
	end
	-- 是否用模板
	local IsTemp
	if type(tParam.IsTemp)=="number" then
		IsTemp = tParam.IsTemp
	end
	for i = 1,#tUIList do
		if tParam.IsEnd==1 then
			return
		end
		local v = tUIList[i]
		local sUIType = v[1]
		local sUIName = v[2]
		if tHandleTable[sUIName]==nil then
			if sUIType=="node" then
				local px,py,pz = 0,0,0
				if type(v[4])=="table" then
					px,py,pz = unpack(v[4])
				end
				px,py,pz = px or 0,py or 0,pz or 0
				local n = px + py + pz	--排错
				local pNodeC = CCNode:create()
				pNodeC:setPosition(x+px,y+py)
				pParent:addChild(pNodeC,pz)
				tHandleTable[sUIName] = pNodeC
				if tChildUI~=nil then
					pNodeC = {handle={_n=pNodeC},childUI=tChildUI}
				end
				tParam.ox = (tParam.ox or 0)+px
				tParam.oy = (tParam.oy or 0)+py
				hUI.CreateMultiUIByParam(pNodeC,0,0,v[3],tHandleTable,tParam)
				tParam.ox = tParam.ox-px
				tParam.oy = tParam.oy-py
			elseif sUIType=="image" or sUIType=="imageX" then
				local sModelName = v[3]
				local sModelAnimation = nil
				local px,py,w,h,z,tRGB = unpack(v[4])
				if type(v[3])=="table" then
					if type(v[3][1])=="function" then
						if tParam.ModelFunc then
							local vx,vy,vw,vh,vz,vRGB,vAnimation
							sModelName,vx,vy,vw,vh,vz,vRGB,vAnimation = tParam.ModelFunc(tParam,v[3])
							if vx and vy and vw and vh then
								px = px + vx
								py = py + vy
								w = vw
								h = vh
							end
							if vz then
								z = vz
							end
							if vRGB and vRGB~=0 then
								tRGB = vRGB
							end
							if vAnimation and vAnimation~=0 then
								sModelAnimation = vAnimation
							end
						end
					else
						sModelName = v[3][1]
						sModelAnimation = v[3][2]
					end
				else
					sModelName = v[3]
				end
				if sModelName~=0 then
					local oImage = hUI.image:new({
						parent = pParent,
						model = sModelName,
						animation = sModelAnimation,
						x = x+px,
						y = y+py,
						z = z,
						w = w,
						h = h,
						IsTemp = IsTemp,
					})
					if tRGB and tRGB~=0 then
						if not(tRGB[1]==255 and tRGB[2]==255 and tRGB[3]==255) then
							oImage.handle.s:setColor(ccc3(tRGB[1],tRGB[2],tRGB[3]))
						end
						if tRGB[4] then
							oImage.handle.s:setOpacity(tRGB[4])
						end
						if tRGB[5] then
							oImage.handle.s:setRotation(tRGB[5])
						end
					end
					if sUIType=="imageX" then
						tHandleTable[sUIName] = oImage
					else
						tHandleTable[sUIName] = hUI.deleteUIObject(oImage,__UI__GetUIHandle)
					end
				end
			elseif sUIType=="label" or sUIType=="labelS" or sUIType=="labelX" then
				local px,py = 0,0
				local sUIString,tUIRGB,sUIFont,nUISize,nUIBorder
				if type(v[3])=="table" then
					if tParam.ModelFunc then
						local vx,vy
						sUIString,tUIRGB,vx,vy,sUIFont,nUISize,nUIBorder = tParam.ModelFunc(tParam,v[3])
						if vx and vy then
							px = vx
							py = vy
						end
					else
						sModelName = 0
					end
				else
					sUIString = v[3]
				end
				local tLabelXYSBAFCW = v[4]
				if sUIString~=0 then
					local tRGB = tUIRGB or tLabelXYSBAFCW[7]
					if tRGB==0 then
						tRGB = nil
					end
					local oLabel = hUI.label:new({
						parent = pParent,
						x = x+px+tLabelXYSBAFCW[1],
						y = y+py+tLabelXYSBAFCW[2],
						size = nUISize or tLabelXYSBAFCW[3],
						border = nUIBorder or tLabelXYSBAFCW[4],
						align = tLabelXYSBAFCW[5],
						font = sUIFont or tLabelXYSBAFCW[6],
						RGB = tRGB,
						text = sUIString,
						z = 1,
						width = tLabelXYSBAFCW[8] or 1024,
						height = tLabelXYSBAFCW[9] or 0,
					})
					if sUIType=="labelX" then
						tHandleTable[sUIName] = oLabel
					else
						if sUIType=="labelS" then
							tHandleTable[sUIName.."__s"] = oLabel.handle.s
						end
						tHandleTable[sUIName] = hUI.deleteUIObject(oLabel,__UI__GetUIHandle)
					end
				end
			elseif sUIType=="valbar" then
				local sModelName = v[3]
				local sModelAnimation = nil
				local tModelBack = nil
				local px,py,w,h,z,cur,mx = unpack(v[4])
				if type(v[3])=="table" then
					if type(v[3][1])=="function" then
						if tParam.ModelFunc then
							local vcur,vmx,vx,vy,vw,vh,vz
							sModelName,sModelAnimation,tModelBack,vcur,vmx,vx,vy,vw,vh,vz = tParam.ModelFunc(tParam,v[3])
							if vx and vy and vw and vh then
								px = px + vx
								py = py + vy
								w = vw
								h = vh
							end
							if vz then
								z = vz
							end
							if vcur and vmx then
								cur = vcur
								mx = vmx
							end
						end
					else
						sModelName = v[3][1]
						sModelAnimation = v[3][2]
						tModelBack = v[3][3]
					end
				else
					sModelName = v[3]
				end
				if sModelName~=0 then
					tHandleTable[sUIName] = hUI.valbar:new({
						parent = pParent,
						x = x+px,
						y = y+py,
						z = z,
						w = w,
						h = h,
						align = "LC",
						model = sModelName,
						animation = sModelAnimation,
						back = tModelBack,
						v = cur or 0,
						max = mx or 100,
					})
				end
			elseif sUIType=="button" then
				if tParam.dragbox then
					local sModelName = v[3]
					local sAnimation
					local sLabel
					local px,py,w,h,scaleT,z = unpack(v[4])
					if type(v[3])=="table" then
						if type(v[3][1])=="function" then
							if tParam.ModelFunc then
								local vx,vy,vw,vh,vz
								sModelName,vx,vy,vw,vh,vz = tParam.ModelFunc(tParam,v[3])
								if vx and vy and vw and vh then
									px = px + vx
									py = py + vy
									w = vw
									h = vh
								end
								if vz then
									z = vz
								end
							else
								sModelName = 0
							end
						else
							sModelName = v[3][1]
							sLabel = v[3][2]
						end
						if sModelName~=0 and type(sModelName)=="table" then
							local t = sModelName
							sModelName = t[1]
							sAnimation = t[2]
						end
					else
						sModelName = v[3]
					end
					if sModelName~=0 then
						local pCode
						if type(v[5])=="function" and tParam.BtnFunc then
							pCode = tParam.BtnFunc(tParam,v[5])
						end
						tHandleTable[sUIName] = hUI.button:new({
							parent = pParent,
							dragbox = tParam.dragbox,
							model = sModelName,
							animation = sAnimation,
							label = sLabel,
							ox = tParam.ox or 0,
							oy = tParam.oy or 0,
							x = x+px,
							y = y+py,
							z = z or 2,
							w = w,
							h = h,
							scaleT = scaleT,
							code = pCode,
						})
					end
				end
			end
		end
	end
	if tChildUI then
		for i = 1,#tUIList do
			local k = tUIList[i][2]
			if tChildUI[k]==nil and type(tHandleTable[k])=="table" then
				tChildUI[k] = tHandleTable[k]
			end
		end
	end
	return tHandleTable
end

hUI.MultiUIParamByFrm = function(oFrame)
	if type(oFrame)~="table" then
		return {
			IsEnd = 0,
			ModelFunc = function(self,param)
				return param[1](param[2])
			end,
		}
	else
		return {
			IsEnd = 0,
			dragbox = oFrame.childUI["dragBox"],
			ModelFunc = function(self,param)
				return param[1](param[2])
			end,
			BtnFunc = function(self,pCode)
				return function(self)
					return pCode(self)
				end
			end,
		}
	end
end

hUI.SetDragRectForGrid = function(mode,tDragRect,oGrid,x,y,w,h,ox,oy,tItem)
	tItem = tItem or oGrid.data.item
	if mode=="V" then
		local cols = #oGrid.data.grid[1]
		local nGridV = math.ceil(#tItem/cols)*oGrid.data.gridH
		local nGridH = math.ceil(math.max(0,(nGridV-h))/oGrid.data.gridH)*oGrid.data.gridH
		tDragRect[1] = x
		tDragRect[2] = y + nGridH - oy
		tDragRect[3] = 0
		tDragRect[4] = nGridH - oy*2
	end
	return tDragRect
end

hUI.BloatUI = function(pNode,fTick,fScale,fScaleB)
	if fScaleB==nil then
		fScaleB = pNode:getScale()
	end
	pNode:runAction(CCSequence:createWithTwoActions(CCScaleTo:create(fTick/2,fScale),CCScaleTo:create(fTick/2,fScaleB)))
end

hUI.GetItemSkillAnimation = function(id)
	local tabS = hVar.tab_skill[id]
	if tabS then
		if (tabS.item or 0)~=0 then
			local tabI = hVar.tab_item[tabS.item]
			if tabI then
				local iconBG
				if hVar.ITEMLEVEL[tabI.itemLv] then
					iconBG = hVar.ITEMLEVEL[tabI.itemLv].BACKMODEL
				end
				return nil,tabI.icon,iconBG
			end
		end
		return nil,tabS.icon
	end
end