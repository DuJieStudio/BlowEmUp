g_CombatPower = 0
function CloseWorldMapUI()
	
end
--初始化地图信息 势力信息
function InitMapInfo()
	for k,v in pairs(hVar.MAP_INFO) do
		if hVar.tab_stringM[k] then
			v.name = hVar.tab_stringM[k][1]
			v.info = hVar.tab_stringM[k][2]
			hVar.MAP_INTENT[k] = hVar.tab_stringM[k][3]
		else
			v.name = tostring(k)
			v.info = "unknown"
			hVar.MAP_INTENT[k] = "unknown"
		end
	end
end

hGlobal.UI_INIT_FUNC = {}
hGlobal.UI_INIT_LOG = {}
hGlobal.UI_INIT_FILTER = {}

do
	--非源代码模式不加载WDLD,PVP,
	local v = hGlobal.UI_INIT_FILTER
	if g_lua_src~=1 then
		--v[#v+1] = "_WDLD"
		--v[#v+1] = "_PVP"
	end
	--pad模式不加载IP
	if g_phone_mode==0 then
		v[#v+1] = "_IP"
	end
end
g_current_init_ui_name = nil
g_current_init_ui_mode = nil
local __INIT__Name,__INIT__Code,__INIT__Tag
local __INIT__ExecuteFunc = function()
	g_current_init_ui_name = __INIT__Name		--查bug用
	g_current_init_ui_mode = __INIT__Tag		--查bug用
	hGlobal.UI_INIT_LOG[__INIT__Name] = 0
	if __INIT__Tag=="include" then
		--include模式直接加载
		__INIT__Code(__INIT__Tag)
	else
		--初始化模式不加载此类UI
		for i = 1,#hGlobal.UI_INIT_FILTER do
			if string.find(__INIT__Name,hGlobal.UI_INIT_FILTER[i]) then
				g_loading_continue = 1
				return
			end
		end
		local result = __INIT__Code(__INIT__Tag)
		if result~=nil then
			if result==hVar.RESULT_FAIL then
				g_loading_continue = 1
				hGlobal.UI_INIT_LOG[__INIT__Name] = __INIT__Code
			elseif type(result)=="table" and type(result[1])=="string" and type(result[2])=="string" then
				g_loading_continue = 1
				hGlobal.UI_INIT_LOG[__INIT__Name] = __INIT__Code
				local sInitName = __INIT__Name
				local tInitEventName = result
				hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(p1,p2,p3,p4,p5,p6,p7,p8,p9,p10)
					hGlobal.event:listen(tInitEventName[1],tInitEventName[2],nil)
					print("[UI]初始化:"..tostring(sInitName))
					hGlobal.UI.include(sInitName)
					local pFunc = hGlobal.event:getfunc(tInitEventName[1],tInitEventName[2])
					if type(pFunc)=="function" then
						return hpcall(pFunc,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10)
					end
				end)
			end
		end
	end
end
function UI_Init()
	local rFunc = {}
	local tFunc = {}
	rFunc[#rFunc+1] = function()
		--初始化地图名字和地图信息 以及胜利目标
		InitMapInfo()
		--初始化 商店显示物品的行数
		hVar.SHOP_ITEM_ROW = math.ceil(#hVar.tab_shopitem/2) - 8
		--底部资源条数据表:hGlobal.LocalRecource = {0,0,0,0}
		hGlobal.UI_BatchMain = hResource.model:batchNode("misc/mask.png")
		hUI.__static.uiLayer:addChild(hGlobal.UI_BatchMain)
		setmetatable(hGlobal.UI,nil)
		hGlobal.event:event("LocalEvent_UIInitStart",tFunc)
	end
	for i = 1,#hGlobal.UI_INIT_FUNC do
		local nIndex = i
		tFunc[nIndex] = {hGlobal.UI_INIT_FUNC[nIndex][1],function()
			__INIT__Name = hGlobal.UI_INIT_FUNC[nIndex][1]
			__INIT__Code = hGlobal.UI_INIT_FUNC[nIndex][2]
			__INIT__Tag = "init"
			g_current_init_ui_name = __INIT__Name
			xpcall(__INIT__ExecuteFunc,hGlobal.__TRACKBACK__)
		end}
		rFunc[#rFunc+1] = function()
			if type(tFunc[nIndex])=="table" and type(tFunc[nIndex][2])=="function" then
				return tFunc[nIndex][2]()
			end
		end
	end
	rFunc[#rFunc+1] = function()
		g_current_init_ui_name = nil
		hGlobal.UI_INIT_FUNC = {}
	end
	return rFunc
end
hGlobal.UI.include = function(sInitName)
	if sInitName and hGlobal.UI_INIT_LOG[sInitName]~=0 and type(hGlobal.UI_INIT_LOG[sInitName])=="function" then
		__INIT__Name = sInitName
		__INIT__Code = hGlobal.UI_INIT_LOG[sInitName]
		__INIT__Tag = "include"
		xpcall(__INIT__ExecuteFunc,hGlobal.__TRACKBACK__)
	end
end
setmetatable(hGlobal.UI,{
	__newindex = function(t,k,v)
		if type(v)=="function" and string.sub(k,1,4)=="Init" then
			hGlobal.UI_INIT_FUNC[#hGlobal.UI_INIT_FUNC+1] = {k,v}
			rawset(t,k,v)
		else
			rawset(t,k,v)
		end
	end,
})

--这是一个毫无意义的初始化，但是如果不这样做，所有的clipNode显示都是错误的，我也不知道为什么
--所有的2级遮罩面板z值都必须是5000，并且autosort=0，别问我为什么
--如果背景是透明的那么就会穿帮
hGlobal.UI.InitDebugClipNode = function()
	local _FrmBG = hUI.frame:new({
		x = 0,
		y = 0,
		w = 1,
		h = 1,
		dragable = 0,
		z = 5000,
		border = 0,
		background = -1,
	})

	local pClipper = hApi.CreateClippingNode(_FrmBG,{0,0,1,1},1,0)

	_FrmBG.childUI["none"] = hUI.image:new({
		parent = pClipper,
		model = 1,
		w = 1,
		h = 1,
	})
end

----------------------------------
---- 加载底部资源条
----------------------------------
--hGlobal.UI.InitResourceBar = function()
	--local x,y,w,h = 0,746,440,50
	--if g_phone_mode ~= 0 then
		--w = 180
		--h = 600
	--end
	
	--hGlobal.UI.ResourceBar = hUI.frame:new({
		--x = x,
		--y = y,
		--w = w,
		--h = h,
		--z = -1,
		--background = -1,
		--dragable = -1,
		--autoactive = 0,
		--show = 0,
	--})

	--local gridW = math.floor(w/6) - 4
	--gridW = 58
	--local _frame = hGlobal.UI.ResourceBar
	--local _parent = _frame.handle._n
	--local _childUI = _frame.childUI

	--local _ResourceBarBG = nil
	--if g_phone_mode ~= 0 then
		--_ResourceBarBG = hUI.frame:new({
			--dragable = 0,
			--border = 0,
			--x = 0,
			--y = y,
			--w = 120,
			--h = h + 180,
			--z = -2,
			--show = 0,
		--})

		--_ResourceBarBG.childUI["ResourceBar_back_lin"] = hUI.image:new({
			--parent = _ResourceBarBG.handle._n,
			--model = "UI:panel_part_09",
			--x = 120,
			--y = -350,
			--w = h + 180,
			--h = 16,
			--z = -1,
		--})

		--_ResourceBarBG.childUI["ResourceBar_back_lin"].handle._n:setRotation(90)
	--end

	--local ResourceEnable = {
		--hVar.RESOURCE_TYPE.WOOD,
		--hVar.RESOURCE_TYPE.FOOD,
		--hVar.RESOURCE_TYPE.STONE,
		--hVar.RESOURCE_TYPE.IRON,
		--hVar.RESOURCE_TYPE.CRYSTAL,
		--hVar.RESOURCE_TYPE.GOLD,
	--}
	--hGlobal.LocalResourceIndex = {}
	--hGlobal.LocalRecource = {}
	--local __LocalPlayerResource
	--if hGlobal.LocalPlayer~=nil then
		--__LocalPlayerResource = hGlobal.LocalPlayer.data.resource
	--end
	----红晶，蓝晶，紫晶，金钱
	--local _Icon = {}--{"ICON:icon01_x6y2","ICON:icon01_x15y2","ICON:icon01_x3y2","ICON:resource_gold",}--"ICON:icon01_x15y1","ICON:icon01_x9y2","ICON:icon01_x12y1"}

	--for i = 1,#ResourceEnable do
		--_Icon[i] = {}
		--local v = ResourceEnable[i]
		--hGlobal.LocalResourceIndex[v] = i
		--_Icon[i][1] = (hVar.RESOURCE_ART[v] or hVar.RESOURCE_ART[hVar.RESOURCE_TYPE.NONE]).icon
		----尝试使用本地玩家的资源数据
		--hGlobal.LocalRecource[i] = (__LocalPlayerResource~=nil and __LocalPlayerResource[v]) or 0
	--end

	--_frame.data.count = 0

	----资源条在大地图和城镇显示
	--hGlobal.event:listen("LocalEvent_PlayerFocusWorld","__hideResourceBar",function(sSceneType,oWorld,oMap)
		--if oWorld and oWorld.data.map == "world/level_tyjy" then
			
		--end

		----有问题待查(已查)2014/7/11
		--if oWorld and (sSceneType=="worldmap" or sSceneType=="town") then
			--if oWorld.data.map == "town/town_highland" and g_phone_mode == 0 then
				--if g_phone_mode ~= 0 then
					--_frame:setXY(0,620)
				--else
					--_frame:setXY(0,746)
				--end
			--else
				--if g_phone_mode ~= 0 then
					--_frame:setXY(0,620)
				--else
					--_frame:setXY(0,746)
				--end	
			--end
			--_frame:show(1)
			----ip5左边有个黑条子
			--if _ResourceBarBG~=nil then
				--if sSceneType=="town" then
					--_ResourceBarBG:show(1)
				--else
					--_ResourceBarBG:show(0)
				--end
			--end
		--else
			--_frame:show(0)
			--if _ResourceBarBG~=nil then
				--_ResourceBarBG:show(0)
			--end
		--end
	--end)

	--hUI.deleteUIObject(hUI.grid:new({
		--parent = _frame.handle._n,
		--mode = "Image",
		--x = 25,
		--y = 0,
		--grid = _Icon,
		--gridW = gridW,
		--gridH = 54,
		--iconW = 48,
		--iconH = 48,
		--codeOnImageCreate = function(self,icon,iconSprite,gridX,gridY)
			--local rIndex = gridY+1
			--_frame.data.count = rIndex
			--hGlobal.LocalRecource[rIndex] = hGlobal.LocalRecource[rIndex] or 0
			--_childUI["resourceLabel_"..rIndex] = hUI.label:new({
				--parent = _parent,
				--font = "numWhite",
				--text = tostring(hGlobal.LocalRecource[rIndex]),
				--align = "LT",
				--size = 16,
				--x = self.data.x + 29,
				--y = self.data.y-54*gridY + 10,
			--})
			--local r = _childUI["resourceLabel_"..rIndex]
			--r.handle._icon = iconSprite
			--r.data.num = hGlobal.LocalRecource[rIndex]
			--r.data._num = hGlobal.LocalRecource[rIndex]
			--r.data._nStep = 1
			--r.data._posTime = 0
		--end,
	--}))

	--local __plus = function(v,a,vx)
		--if a>0 and v<vx then
			--return math.min(vx,v+a)
		--elseif a<0 and v>vx then
			--return math.max(vx,v+a)
		--else
			--return vx
		--end
	--end
	--local __step = function(s,e)
		--local n = e-s
		--if n==0 then
			--return 0
		--else
			--local v = math.abs(n)
			--local dur = 750
			--local p = v
			--if p>9 then
				--p = math.max(9,math.ceil(v*100/dur))
			--end
			--if n>0 then
				--return p
			--else
				--return -1*p
			--end
		--end
	--end

	--local __ImmediateLoadValue = 0
	--local __count = _frame.data.count
	--local __RefreshLocalResource = function(tick)
		--for i = 1,__count do
			--local r = _childUI["resourceLabel_"..i]
			--if _frame.data.show==1 and __ImmediateLoadValue~=1 then
				--if r.data.num~=hGlobal.LocalRecource[i] then
					--local _v = hGlobal.LocalRecource[i] - r.data.num
					--r.data.num = hGlobal.LocalRecource[i]
					--r.data._nStep = __step(r.data._num,r.data.num)
					--hUI.floatNumber:new({
						--parent = _frame.handle._n,
						--font = _v>0 and "numGreen" or "numRed",
						--text = (_v>=0 and "+".._v or _v),
						--size = 12,
						--x = r.data.x,--+ 24,
						--y = r.data.y + 16 -32,
						--align = "LB",
						--moveY = 32,
						--lifetime = 1000,
						--fadeout = -330,
					--})
					--if tick and r.data._posTime<=tick then
						--r.data._posTime = tick + 4000
						--local a = CCScaleBy:create(0.1,1.5,1.5)
						--r.handle._icon:runAction(CCSequence:createWithTwoActions(a,a:reverse()))
					--end
				--end
				--if r.data._num~=r.data.num then
					--r.data._num = __plus(r.data._num,r.data._nStep,r.data.num)
					--r:setText(tostring(r.data._num))
				--end
			--else
				--if r.data.num~=hGlobal.LocalRecource[i] then
					--r.data.num,r.data._num = hGlobal.LocalRecource[i],hGlobal.LocalRecource[i]
					--r:setText(tostring(r.data._num))
				--end
			--end
		--end
		--__ImmediateLoadValue = 0
	--end
	--hApi.addTimerForever("__UI_ResourceBarRefresh",hVar.TIMER_MODE.GAMETIME,1,__RefreshLocalResource,1)

	----初始化本地玩家时重新设置显示数值
	--hGlobal.event:listen("LocalEvent_InitLocalPlayer","__InitPlayerResourceUI",function(oPlayer)
		--local res = oPlayer.data.resource
		--if type(res)=="table" then
			--__ImmediateLoadValue = 1
			--for i = 1,#ResourceEnable do
				--local v = ResourceEnable[i]
				--hGlobal.LocalResourceIndex[v] = i
				--_Icon[i] = (hVar.RESOURCE_ART[v] or hVar.RESOURCE_ART[hVar.RESOURCE_TYPE.NONE]).icon
				----尝试使用本地玩家的资源数据
				--hGlobal.LocalRecource[i] = res[v] or 0
			--end
			--__RefreshLocalResource()
		--end
	--end)

	----重新设置本地玩家资源
	--hGlobal.UI.ResetLocalResource = function()
		--__ImmediateLoadValue = 1
		--for i = 1,#ResourceEnable do
			--local v = ResourceEnable[i]
			--hGlobal.LocalRecource[i] = hGlobal.LocalPlayer.data.resource[v]
		--end
		--__RefreshLocalResource()
	--end
--end

--------------------------------
-- 加载大地图点击
--------------------------------
hGlobal.UI.InitWorldMapOperation = function()
	--点击单位后创建操作条
	--创建动画
	local _createImageAction = function(oUnit,mode,x,y)
		oUnit.chaUI[mode] = hUI.thumbImage:new({
			parent = oUnit.handle._tn,
			align = "MC",
			w = 46,
			h = 46,
			x = x,
			y = y,
			scale = 0.6,
			model = mode,--"Action:Hammer",
			animation = "updown",
		})
	end
	
	hGlobal.event:listen("LocalEvent_HitOnTarget","__WM__CommonOperate",function(oWorld,oUnit,worldX,worldY)
		--print("LocalEvent_HitOnTarget", oUnit.data.name)
		--print("建筑等")
		local w = oWorld
		if (w == nil) then
			return
		end
		if w.data.type=="worldmap" then
			if hApi.IsInEditorDrag() then
				return
			end
			--首先是菜单判断
			if g_phone_mode ~= 0 then
				--如果是选择关卡
				--if hGlobal.LocalPlayer:getfocusworld().data.map == hVar.PHONE_SELECTLEVEL then
				if hApi.CheckMapIsChapter(hGlobal.LocalPlayer:getfocusworld().data.map) then
					--if oUnit.data.id == 60111 then
					--	hGlobal.event:event("LocalEvent_phone_SelectLevel_OpenQuestionFrm")
					--	return
					--end
					---------------------------------------------------------------------------------
					if hVar.tab_unit[oUnit.data.id].mapkey ~= nil then
						if hVar.MAP_INFO[hVar.tab_unit[oUnit.data.id].mapkey].mapType == 1  then
							if  LuaGetPlayerMapAchi(hVar.tab_unit[oUnit.data.id].mapkey,hVar.ACHIEVEMENT_TYPE.LEVEL) == 0 then
								if hApi.CheckUnlockMap(hVar.tab_unit[oUnit.data.id].mapkey) == 1 then
									if oUnit and oUnit.chaUI["arrow_bottom"] ~= nil then
										oUnit.chaUI["arrow_bottom"].handle._n:setVisible(false)
									end
									
									if oUnit and oUnit.chaUI["UDaction"] ~= nil then
										oUnit.chaUI["UDaction"].handle._n:setVisible(false)
									end
								end
							end
						end
					end
					---------------------------------------------------------------------------------
					hGlobal.event:event("LocalEvent_Phone_ShowMapInfoFrm",hVar.tab_unit[oUnit.data.id].mapkey)
					return
				elseif hGlobal.LocalPlayer:getfocusworld().data.map == hVar.PHONE_VIPMAP then
					if oUnit.data.id == 60600 then
						hGlobal.event:event("LocalEvent_phone_OpenQuestionFrm")
						return
					end
					hGlobal.event:event("LocalEvent_Phone_ShowMapInfoFrm",hVar.tab_unit[oUnit.data.id].mapkey)
					return
				end
			end

			local t = oUnit
			--编辑器模式下不发生转换(检查单位是否有守卫)
			if hGlobal.EditorIsOn~=1 then
				if t then
					local oldT = t
					local tD = t:gettriggerdata()
					--城镇没有"守卫"，只有守城英雄
					if t:gettown()~=nil then
						--城镇不做是否拥有守卫的判断
					elseif tD~=nil and tD.guard~=nil then
						for i = 1,#tD.guard do
							local gu = w:tgrid2unit(tD.guard[i])
							if gu~=nil and gu.data.IsDead~=1 then
								if gu.data.type==hVar.UNIT_TYPE.GROUP then
									if gu.data.nTarget~=0 then
										local cu = hClass.unit:find(gu.data.nTarget)
										if cu and cu.data.nTarget==gu.ID then
											t = cu
											break
										end
									end
								else
									if gu.data.IsHide==1 then
										_DEBUG_MSG("[LUA WARNING] "..tostring(t.data.name).." 的守卫单位不能为隐藏单位！(是驻守英雄吗?)")
									else
										t = gu
										break
									end
								end
							end
						end
					end
				end
			end
			
			local u = hGlobal.LocalPlayer:getfocusunit()
			
			if u~=nil then
				if u and u~=t then
					if t.data.type==hVar.UNIT_TYPE.BUILDING then
						local bWorldX, bWorldY = t:getstopXY()
						w:drawwaypoint(u,bWorldX,bWorldY,t)
					else
						local tx,ty = t:getXY()
						w:drawwaypoint(u,tx,ty,t)
					end
				end
			end
			hGlobal.O:replace("__WM__MoveOperatePanel",nil)
			local panel = hGlobal.O["__WM__TargetOperatePanel"]
			
			if t and panel and panel.data.bindU==t.ID and (hGlobal.LocalPlayer:getfocusunit() or 0)==panel.data.orderUnit then
				if panel.data.tick==0 then
					panel:select(panel.data.opr,500)
				end
			else
				if t then
					--判断是否为敌方单位
					local towner = t:getowner()
					--local w = t:getworld()
					--if w then
					--	print("getowner", t.data.name, t.data.owner)
					--end
					local tforce = towner:getforce()
					local oPlayerMe = w:GetPlayerMe()
					local nForceMe = oPlayerMe:getforce()
					local oNeutralPlayer = w:GetForce(nForceMe) --中立阵营玩家对象（蜀国/魏国）
					
					local bEnableClick = false --是否可以点击
					
					if (towner == oPlayerMe) then --自己操控的单位，显示操作
						bEnableClick = true
					elseif (towner == oNeutralPlayer) then --势力方的阵营，根据地图配置来
						--if w and w.data.tdMapInfo and (w.data.tdMapInfo.buildTogether) then
							bEnableClick = true
						--end
					elseif (t.data.type == hVar.UNIT_TYPE.NPC_TALK) then --可交互单位
						--if w and w.data.tdMapInfo and (w.data.tdMapInfo.buildTogether) then
							bEnableClick = true
						--end
					elseif (t.data.type == hVar.UNIT_TYPE.UNITBROKEN_HOUSE) then --可破坏房子
						--if w and w.data.tdMapInfo and (w.data.tdMapInfo.buildTogether) then
							bEnableClick = true
						--end
					end
					
					--可以显示操作
					if bEnableClick then
						panel = hGlobal.O:replace("__WM__TargetOperatePanel",hUI.targetPanel:new({
							world = w,
							target = t,
							orderUnit = u,
						}))
						--如果是道具 则显示道具名字
						local oItem = t:getitem()
						if oItem then
							local itemName = hVar.tab_string["__TEXT_noAppraise"]
							if hVar.tab_stringI[oItem.data.id] and hVar.tab_stringI[oItem.data.id][1] then
								itemName = hVar.tab_stringI[oItem.data.id][1]
							end
						
							panel.childUI["itemName"] = hUI.label:new({
								parent = panel.handle._n,
								size = 24,
								align = "MB",
								font = hVar.FONTC,
								x = 0,
								y = 64,
								width = 200,
								text = itemName,
							})
						end
						
						--建筑类特殊
						if t.data.type == hVar.UNIT_TYPE.BUILDING then
							--计算绑定盒子
							local px,py = 0,0
							px = -1*hApi.getint(40/2)
							local bx,by,bw,bh = hApi.SpriteGetBoundingBox(t.handle)
							if bx then
								py = hApi.getint(-by+40/2)
							end
							--如果是可访问建筑则显示访问CD
							local rult = 0
							if hVar.tab_unit[t.data.id].interaction then
								for i = 1, #hVar.tab_unit[t.data.id].interaction do
									if hVar.tab_unit[t.data.id].interaction[i] == hVar.INTERACTION_TYPE.VISIT then
										rult = 1
									end
								end
							end
							if rult == 1 and u then
								if t:iscooldown(u) then
									
								else
									panel.childUI["COOLDOWN"] = hUI.label:new({
										parent = panel.handle._n,
										size = 26,
										align = "LT",
										font = hVar.FONTC,
										x = px - 18,
										y = py + 50,
										width = 100,
										text = hVar.tab_string["__TEXT_Visited"],
									})
								end
							end
							--如果是可雇佣建筑则显示是否可以雇佣
							local hireList = t.data.hireList
							if hireList ~= nil and hireList ~= 0 then
								for i = 1,#hireList do
									local v = hireList[i]
									if v[2] > 0 then
										local tempY = py + 50
										if g_phone_mode ~= 0 then
											tempY = tempY +15
										end
										panel.childUI["CanHire"] = hUI.label:new({
											parent = panel.handle._n,
											size = 26,
											align = "LT",
											font = hVar.FONTC,
											x = px - 18,
											y = tempY,
											width = 100,
											text = hVar.tab_string["__TEXT_CanHire"],
										})
									end
								end
							end
						end
					end
				else
					--if panel then
					--	print("hGlobal.O[__WM__TargetOperatePanel] = nil")
					--	panel:del()
					--	hGlobal.O["__WM__TargetOperatePanel"] = nil
					--end
				end
			end
		end
	end)

	--点到了世界地图上，创建一个移动按钮
	hGlobal.event:listen("LocalEvent_TouchOnWorld","__WM__CommonOperate",function(oWorld,worldX,worldY)
		local w = oWorld
		--if w.data.type=="worldmap" and w.data.map ~= hVar.PHONE_VIPMAP and w.data.map ~= hVar.PHONE_SELECTLEVEL then
		if w.data.type=="worldmap" and w.data.map ~= hVar.PHONE_VIPMAP and not hApi.CheckMapIsChapter(w.data.map) then
			if hApi.IsInEditorDrag() then
				return
			end
			local p = hGlobal.LocalPlayer
			local u = hGlobal.LocalPlayer:getfocusunit()
			--print("u=" .. u.data.name)
			if u~=nil then
				hGlobal.O:replace("__WM__TargetOperatePanel",nil)
				hGlobal.O:replace("__WM__MoveOperatePanel",nil)
				local gridX,gridY = w:xy2grid(worldX,worldY)
				local x,y = w:grid2xy(gridX,gridY)
				--local canMove = w:drawwaypoint(u,x,y) --zhenkira
				local canMove = hVar.RESULT_FAIL
				local panel
				local code
				local model = "ICON:action_move"
				
				--角色类型判断 zhenkira
				--local isTower = hVar.tab_unit[u.data.id].isTower or 0
				if (u.data.type ~= hVar.UNIT_TYPE.TOWER) and (u.data.type ~= hVar.UNIT_TYPE.BUILDING) and (u.data.type ~= hVar.UNIT_TYPE.NPC_TALK) and (u.data.type ~= hVar.UNIT_TYPE.UNITBROKEN_HOUSE) then --geyachao: 已修改塔类型的读取方式
				--if (isTower ~= 1) then
					canMove = hVar.RESULT_SUCESS
				end
				
				--geyachao: 下面的流程不走
				canMove = hVar.RESULT_FAIL
				
				local panel
				
				if canMove==hVar.RESULT_SUCESS then
					_PanelEnable = 1

					panel = hGlobal.O:replace("__WM__MoveOperatePanel",hUI.panel:new({
						world = w,
						bindTag = "UI_WORLD_WAYPOINT",
						menu = 1,
						x = x,
						y = y,
						child = {
							__NAME = "moveToGrid",
							__UI = "button",
							mode = "imageButton",
							model = model,
							x = 10,
							y = -10,
							scale = 0.75,
							scaleT = 0.75,
							model = model,
							--geyachao
							--[[
							code = function(self)
								if _PanelEnable==1 and panel.data.tick==0 then
									panel:settick(800)
									local a = CCArray:create()
									a:addObject(CCDelayTime:create(0.3))
									a:addObject(CCFadeOut:create(0.5))
									self.handle.s:runAction(CCSequence:create(a))
									p:order(w,hVar.OPERATE_TYPE.UNIT_MOVE,u,hVar.ZERO,nil,gridX,gridY,worldX,worldY)
								end
							end,
							]]
						},
					}))

					if panel.data.tick==0 then
						--print("am I move cha :".. tostring(p)..", !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
						panel:settick(800)
						local a = CCArray:create()
						a:addObject(CCDelayTime:create(0.3))
						a:addObject(CCFadeOut:create(0.5))
						panel.childUI["moveToGrid"].handle.s:runAction(CCSequence:create(a))
						local ret = p:order(w,hVar.OPERATE_TYPE.UNIT_MOVE,u,hVar.ZERO,nil,gridX,gridY,worldX,worldY)
						--print("am I move cha :".. tostring(ret)..",", w,hVar.OPERATE_TYPE.UNIT_MOVE,u,hVar.ZERO,nil,gridX,gridY,worldX,worldY)
					end
				end
				
				
			end
		end
	end)

	--新的一天刷新地图上的移动按钮
	hGlobal.event:listen("Event_NewDay","__RefreshWayPanel__",function(nDayCount)
		local w = hGlobal.LocalPlayer:getfocusworld()
		local panel = hGlobal.O:get("__WM__MoveOperatePanel")
		local oUnit = hGlobal.LocalPlayer:getfocusunit()
		if panel~=nil and _PanelEnable==0 and oUnit~=nil then
			if hApi.chaShowPath(oUnit.handle,1)~=0 then
				_PanelEnable = 1
				panel.childUI["moveToGrid"].handle.s:setColor(ccc3(255,255,255))
			end
		end
	end)

	--播放拾取音效
	hGlobal.event:listen("Event_HeroLoot","__WM__LootSound",function(oWorld,oUnit,oTarget)
		if oWorld==hGlobal.LocalPlayer:getfocusworld() then
			hApi.PlaySound("eff_pickup")
		end
	end)

	--播放占据音效
	hGlobal.event:listen("Event_HeroOccupy","__WM__OccupySound",function(oWorld,oUnit,oTarget)
		if oWorld==hGlobal.LocalPlayer:getfocusworld() then
			hApi.PlaySound("eff_pickup")
		end
	end)

	--播放访问音效
	hGlobal.event:listen("Event_HeroVisit","__WM__VisitSound",function(oWorld,oUnit,oTarget)
		if oWorld==hGlobal.LocalPlayer:getfocusworld() then
			hApi.PlaySound("eff_pickup")
		end
	end)

	--播放移动音效(已废弃)
	--hGlobal.event:listen("Event_UnitStartMove","__WM__MoveSound",function(oWorld,oUnit,gridX,gridY,oTarget,nOperate)
		--if oWorld==hGlobal.LocalPlayer:getfocusworld() and not(oUnit.data.gridX==gridX and oUnit.data.gridY==gridY) then
			--local tId = oTarget~=nil and oTarget.data.triggerID or "nil"
			----oUnit:playsound("move","move_horse01",1)
		--end
	--end)

	----停止移动音效(已废弃)
	--hGlobal.event:listen("Event_UnitArrive","__WM__MoveSound",function(oWorld,oUnit,gridX,gridY,oTarget,nOperate,nOperateId)
		--if oUnit.handle.sound["move"]~=nil then
			--local tId = oTarget~=nil and oTarget.data.triggerID or "nil"
			--oUnit:stopsound("move")
		--end
	--end)
end

hGlobal.UI.InitUnitInfoCard = function()
	--local _card = hGlobal.O:replace("UI_HEROCARD",hUI.gameUnitCard:new({
	--	id = 1,
	--	x = 150,
	--	y = 550,
	--}))
	--_card:show(0)
	----切地图隐藏
	--hGlobal.event:listen("LocalEvent_PlayerFocusWorld","__UI__CloseHeroCard",function(sSceneType,oWorld,oMap)
	--	_card:show(0)
	--end)
end

--------------------------------
-- 加载城镇UI
--------------------------------
hGlobal.UI.InitTownFrame = function()
	if hGlobal.UI.TownFrame~=nil then
		hGlobal.UI.TownFrame:del()
	end
	local tVisitor = {}
	hGlobal.UI.TownFrame = hUI.frame:new({
		x = hVar.SCREEN.w - 1022,
		y = 92,
		z = -1,	--指定此值后就一定会呆在UI最底层
		show = 0,
		buttononly = 1,
		dragable = 2,
		autoactive = 0,
		background = "UI:FRM_TownFrame_BG",

	})
	local _frm = hGlobal.UI.TownFrame
	local _childUI = _frm.childUI

	local townNameX = 20
	if g_phone_mode == 1 then
		townNameX = 70
	end
	_childUI["TowmName"] = hUI.label:new({
		parent = _frm.handle._n,
		x = townNameX,
		y = -35,
		font = hVar.FONTC,
		size = 44,
		text = "",
	})
	
	--创建动画
	local _createImageAction = function(oUnit,mode)
		oUnit.chaUI[mode] = hUI.thumbImage:new({
			parent = oUnit.handle._tn,
			align = "MC",
			w = 64,
			h = 64,
			y = 40,
			scale = 0.6,
			model = mode,--"Action:Hammer",
			animation = "updown",
		})
	end
	
	--创建建筑名字
	local _createBuildingName = function()
		local scale = 1
		local x,y,w,h = 0,0,0,0
		local tabU = {}
		hGlobal.WORLD.LastTown:enumunit(function(eU)
			--创造建筑名字
			x,y,w,h = eU:getbox()
			tabU = eU:gettab()
			if tabU and type(tabU.scale)=="number" then
				scale = tabU.scale
				eU.handle.s:setScale(scale)
			end
			eU.chaUI["nameLabel"] = hUI.label:new({
				parent = eU.handle._tn,
				text = hVar.tab_stringU[eU.data.id][1] or "UNIT_"..eU.data.id,
				size = 26,
				y = -1*y*scale,
				font = hVar.FONTC,
				align = "MB",
			})
		end)
	end
	--删除建筑名字
	local _clearBuildingName = function()
		hGlobal.WORLD.LastTown:enumunit(function(eU)
			hApi.safeRemoveT(eU.chaUI,"nameLabel")
			hApi.safeRemoveT(eU.chaUI,"Action:Hammer")
		end)
	end

	--建筑可以建造的 提示动画
	--小锤子
	local _createBuildingRemind = function()
		local oBuilding = hGlobal.WORLD.LastTown:getlordU("building")
		local oTown = oBuilding:gettown()
		if oTown then
			local buildingState = oTown.data.upgradeState
			local _style = hVar.tab_unit[oBuilding.data.id].townstyle
			hGlobal.WORLD.LastTown:enumunit(function(wu)
				--自己的资源列表
				local resourceCost = {}
				local ptLen = #hVar.UNIT_PRICE_DEFINE
				for i = 1,ptLen do
					resourceCost[i] = 0
				end
				local tabU = hVar.tab_unit[wu.data.id]
				if tabU==nil then
					return
				end
				-- 从tab表中读取价格
				local price = tabU.price
				if price~=nil then
					for i = 1,ptLen do
						resourceCost[i] = resourceCost[i] + (price[i] or 0)
					end
				end
				local IsPlayerHaveEnoughResource = 1
				local RequireCount = 0
				local requireBase = 0
				--如果 有价格 
				if price ~=nil and #price>0 then
					for i = 1,ptLen do
						if hGlobal.LocalPlayer:getresource(hVar.UNIT_PRICE_DEFINE[i])<resourceCost[i] then
							IsPlayerHaveEnoughResource = 0
							break
						end
					end
				end
				--获取前置科技条件
				local requirelist = tabU.require
				local upgradelist = tabU.upgrade
				--判断当前城内的前置建筑
				if requirelist~=nil and requirelist~=0 then
					--遍历单位判断
					hGlobal.WORLD.LastTown:enumunit(function(eu)
						--还没有建造的单位的建造条件
						for i = 1,#requirelist do
							if type(requirelist[i]) == "table" then
								if _style == requirelist[i][1] and eu.data.id == requirelist[i][2] and buildingState[eu.data.indexOfCreate] == 1 then
									RequireCount = RequireCount +1
								end
								local tabupgrade = hVar.tab_unit[requirelist[i][2]].upgrade
								local tempLen = 2
								for j = 1,tempLen do
									if tabupgrade and  tabupgrade[2] then
										if eu.data.id == tabupgrade[2]then
											RequireCount = RequireCount +1
										end
										tabupgrade = hVar.tab_unit[tabupgrade[2]].upgrade
										if tabupgrade then
											tempLen = tempLen + 1
										end
									end
								end
							elseif type(requirelist[i]) == "number" then
								if eu.data.id == requirelist[i] and buildingState[eu.data.indexOfCreate] == 1 then
									RequireCount = RequireCount +1
								end
								local tabupgrade = hVar.tab_unit[requirelist[i]].upgrade
								if tabupgrade then
									local tempLen = 2
									for j = 1,tempLen do
										if tabupgrade and tabupgrade[2] then
											if eu.data.id == tabupgrade[2] then
												RequireCount = RequireCount+1
											end
											tabupgrade = hVar.tab_unit[tabupgrade[2]].upgrade
											if tabupgrade then
												tempLen = tempLen + 1
											end
										end
									end
								end
							end
						end
					end)
					--升级信息相关
					for i = 1,#requirelist do
						if type(requirelist[i]) == "table" then
							if _style == requirelist[i][1] then
								requireBase = requireBase +1
							end
						elseif type(requirelist[i]) == "number" then
							requireBase = #requirelist
						end
					end

					--还有下一等级吗？
					if RequireCount ~= requireBase or IsPlayerHaveEnoughResource == 0 or (buildingState[wu.data.indexOfCreate] == 1 and upgradelist == nil ) then

					else
						_createImageAction(wu,"Action:Hammer")
					end
				end
				RequireCount = 0
				requireBase = 0
				--如果有升级列表 已经建造好的建筑的 升级条件
				if upgradelist~=nil and upgradelist~=0 and buildingState[wu.data.indexOfCreate] == 1 then 
					requirelist = hApi.GetTableValue(hVar.tab_unit,upgradelist[2]).require
					if requirelist~=nil and requirelist~=0 then
						--遍历单位判断
						hGlobal.WORLD.LastTown:enumunit(function(eu)
							for i = 1,#requirelist do
								if type(requirelist[i]) == "table" then
									if _style == requirelist[i][1] and eu.data.id == requirelist[i][2] and buildingState[eu.data.indexOfCreate] == 1 then
										RequireCount = RequireCount +1
									end
									local tabupgrade = hVar.tab_unit[requirelist[i][2]].upgrade
									local tempLen = 2
									for j = 1,tempLen do
										if tabupgrade and  tabupgrade[2] then
											if eu.data.id == tabupgrade[2]then
												RequireCount = RequireCount +1
											end
											tabupgrade = hVar.tab_unit[tabupgrade[2]].upgrade
											if tabupgrade then
												tempLen = tempLen + 1
											end
										end
									end
								elseif type(requirelist[i]) == "number" then
									if eu.data.id == requirelist[i] and buildingState[eu.data.indexOfCreate] == 1 then
										RequireCount = RequireCount +1
									end
									local tabupgrade = hVar.tab_unit[requirelist[i]].upgrade
									if tabupgrade then
										local tempLen = 2
										for j = 1,tempLen do
											if tabupgrade and tabupgrade[2] then
												if eu.data.id == tabupgrade[2] then
													RequireCount = RequireCount+1
												end
												tabupgrade = hVar.tab_unit[tabupgrade[2]].upgrade
												if tabupgrade then
													tempLen = tempLen + 1
												end
											end
										end
									end
								end
							end
						end)
						--升级信息相关
						for i = 1,#requirelist do
							if type(requirelist[i]) == "table" then
								if _style == requirelist[i][1] then
									requireBase = requireBase +1
								end
							elseif type(requirelist[i]) == "number" then
									requireBase = #requirelist
							end
						end

						if RequireCount ~= requireBase or IsPlayerHaveEnoughResource == 0 then

						else
							_createImageAction(wu,"Action:Hammer")
						end
					end
				end
				--如果没有前置科技 且 还未建造
				if requirelist == nil and buildingState[wu.data.indexOfCreate] == 0 then
					_createImageAction(wu,"Action:Hammer")
				end
			end)
		end
	end

	local _clearBuildingRemind = function()
		hGlobal.WORLD.LastTown:enumunit(function(wu)
			hApi.safeRemoveT(wu.chaUI,"Action:Hammer")
		end)
	end

	local IsshowBuildingNmae = 0
	_childUI["BuildingName"] = hUI.button:new({
		parent = _frm.handle._n,
		model = "UI:SHOW_BUILDINGNAME",
		x = 290,
		y = -55,
		scaleT = 0.9,
		mode = "imageButton",
		dragbox = _childUI["dragBox"],
		code = function()
			if hGlobal.WORLD.LastTown then 
				if IsshowBuildingNmae == 0 then
					IsshowBuildingNmae = 1
					_createBuildingName()
					if g_last_scene ~= g_chooselevel and g_current_scene == g_town then
						_createBuildingRemind()
					end
				else
					IsshowBuildingNmae = 0
					_clearBuildingName()
					if g_last_scene ~= g_chooselevel and g_current_scene == g_town then
						_clearBuildingRemind()
					end
				end
			end
		end,
	})

	hGlobal.event:listen("LocalEvent_PlayerFocusWorld","__UI__ShowTownFrame",function(sSceneType,oWorld,oMap)
		--有问题待查(已查)2014/7/11
		hGlobal.O:replace("__WM__TargetOperatePanel",nil)
		if sSceneType=="town" and oWorld then
			_frm:show(1)
			local vU = oWorld:getlordU("visitor")
			local oBuilding = hGlobal.WORLD.LastTown:getlordU("building")
			if oBuilding then
				local s = hApi.GetUnitName(oBuilding)
				_childUI["TowmName"]:setText(s)
			end
			hApi.SetObject(tVisitor,vU)
		else
			IsshowBuildingNmae = 0
			_frm:show(0)
		end
	end)

	_childUI["option"] = hUI.button:new({
		parent = _frm.handle._n,
		mode = "imageButton",
		model = "UI:BTN_DragableHint",
		animation = "L",
		x = hVar.SCREEN.w - 88,
		y = 120,
		scaleT = 1.1,
		w = 16,
		h = 64,
	})
	_childUI["option"]:setstate(-1)

	hGlobal.event:listen("LocalEvent_HitOnTarget","__TN__CommonOperate",function(oWorld,oUnit,worldX,worldY)
		local w = oWorld
		if (w  == nil) then
			return
		end
		if w.data.type=="town" then
			local building = w:getlordU("building")
			local guard = w:getlordU("guard")
			local visitor = w:getlordU("visitor")
			local u
			local t = oUnit
			if building~=nil then
				u = building
			elseif guard~=nil then
				u = guard
			elseif visitor~=nil then
				u = visitor
			end

			local panel = hGlobal.O:get("__TN__TargetOperatePanel")
			if panel and panel.data.bindU==t.ID then
				if panel.data.tick==0 then
					panel:select(1)
				end
			else
				hGlobal.O:replace("__TN__TargetOperatePanel",hUI.targetPanel:new({
					world = w,
					target = t,
					orderUnit = u,
				}))
			end
		end
	end)
end

--------------------------------
-- 加载主城列表按钮
--------------------------------
hGlobal.UI.InitTownListFrame = function()
	if hGlobal.UI.TownListFrame~=nil then
		hGlobal.UI.TownListFrame:del()
	end
	local _SlotModelTab = {
		[1] = {model = "UI:BTN_ControlSlot"},
	}
	setmetatable(_SlotModelTab,{
		__index = function(t,k)
			if k~=0 then
				return rawget(t,1)
			end
		end,
	})
	local _MaxTownNum = 8
	local _gridSlot = {}
	local _tempU = {}
	for i = 1,_MaxTownNum do
		_tempU[i] = 0
		_gridSlot[i] = 0
	end
	hGlobal.UI.TownListFrame = hUI.frame:new({
		x = hVar.SCREEN.w-_MaxTownNum*92+4,
		y = 2,
		z = -1,
		background = 0,--"UI:FRM_TownFrame_BG",
		show = 0,
		buttononly = 1,
		dragable = 2,
		autoactive = 0,
		child = {
			{
				__NAME = "gridOfTownBtn",
				__UI = "grid",
				mode = "imageButton",
				tab = _SlotModelTab,
				tabModelKey = "model",
				animation = "blue",
				x = -20,
				y = 50,
				align = "MC",
				iconW = 92,
				iconH = 92,
				gridW = 100,
				gridH = 100,
				smartWH = 1,
				scaleT = 0.9,
				grid = _gridSlot,
				codeOnButtonCreate = function(self,id,btn,gx,gy)
					local tabU = hApi.GetTableValue(hVar.tab_unit,id)
					if tabU then
						btn.handle.s:setOpacity(0)	--设置透明度
						btn.childUI["thumb"] = hUI.thumbImage:new({
							parent = btn.handle._n,
							align = "MC",
							w = 96,
							h = 96,
							id = id,
						})
						btn.childUI["label"] = hUI.label:new({
							parent = btn.handle._n,
							align = "MC",
							y = -32,
							font = hVar.FONTC,
							size = 28,
							text = _tempU[gx+1].name,
							border = 1,
						})

						--给主城列表按钮增加一个提示是否可以建造的小锤子动画
						btn.childUI["Action:Hammer"] = hUI.image:new({
							parent = btn.handle._n,
							align = "MC",
							w = 46,
							h = 46,
							y = 10,
							model = "Action:Hammer",
							animation = "updown",
						})
						btn.childUI["Action:Hammer"].handle._n:setVisible(false)

						--给主城列表按钮增加一个全部建造完毕的标记
						btn.childUI["UI:finish"] = hUI.image:new({
							parent = btn.handle._n,
							align = "MC",
							w = 46,
							h = 46,
							model = "UI:finish",
						})
						btn.childUI["UI:finish"].handle._n:setVisible(false)
					end
				end,
			},
		},
	})
	local _frm = hGlobal.UI.TownListFrame
	local _grid = _frm.childUI["gridOfTownBtn"]

	local _RemoveTownFromList = function(oUnit)
		local findI
		for i = 1,_MaxTownNum,1 do
			if _tempU[i]~=0 and hApi.GetObject(_tempU[i].unit)==oUnit then
				findI = i
				break
			end
		end
		if findI then
			hApi.safeRemoveT(_grid.childUI,_tempU[findI].childName)
			_tempU[findI] = 0
			local iLast
			for i = _MaxTownNum,1,-1 do
				if _tempU[i]~=0 then
					local v = _tempU[i]
					if iLast then
						local btn = _grid.childUI[v.childName]
						local tx,ty = _grid:grid2xy(iLast-1,0)
						local cx,cy = btn.data.x,btn.data.y
						btn:setXY(tx,ty,0.15)
						_tempU[iLast] = _tempU[i]
						_tempU[i] = 0
						iLast = iLast - 1
					end
				else
					iLast = i
				end
			end
			_frm.childUI["dragBox"]:sortbutton()
		end
	end

	local _AddTownToList = function(oUnit)
		local findI
		for i = _MaxTownNum,1,-1 do
			if _tempU[i]==nil or _tempU[i]==0 then
				findI = i
				break
			end
		end
		if findI then
			_tempU[findI] = {unit = {},childName = 0,name = hApi.GetUnitName(oUnit)}
			local _tUnit = hApi.SetObject(_tempU[findI].unit,oUnit)
			local btn,x,y,childName = _grid:addbutton(oUnit.data.id,findI-1,0,{
				dragbox = _frm.childUI["dragBox"],
				code = function(self)
					local oBuilding = hApi.GetObject(_tUnit)
					if oBuilding and hGlobal.LocalPlayer:allience(oBuilding:getowner())==hVar.PLAYER_ALLIENCE_TYPE.OWNER then
						local oTown = oBuilding:gettown()
						if oTown then
							return hGlobal.event:event("LocalEvent_PlayerEnterTown",oBuilding,oTown,nil)
						end
					end
				end,
			})
			local oTown = oUnit:gettown()
			if oTown.data.buildingCount == 0 then
				if oTown:checkBuilding() == 0 then
					if btn.childUI["Action:Hammer"].handle._n then
						btn.childUI["Action:Hammer"].handle._n:setVisible(true)
					end
				end
			elseif oTown.data.buildingCount == 1 or oTown:checkBuilding() == 1 then
				if btn.childUI["Action:Hammer"].handle._n then
					btn.childUI["Action:Hammer"].handle._n:setVisible(false)
				end
			end

			if oTown:checkBuilding() == 1 then
				if btn.childUI["UI:finish"].handle._n then
					btn.childUI["UI:finish"].handle._n:setVisible(true)
				end
			end


			_tempU[findI].childName = childName
		end
	end

	--抢占一个城之后,添加到面板
	hGlobal.event:listen("Event_HeroOccupy","__WM__AddTownButtonAfterOccupy",function(oWorld,oUnit,oTarget)
		--将抢占的城池添加至玩家表中
		local oPlayer = oUnit:getowner()
		local oTown = oTarget:gettown()
		if oTown then
			local index = #oPlayer.data.ownTown
			oPlayer.data.ownTown[index+1] = {}
			hApi.SetObjectUnit(oPlayer.data.ownTown[index+1],oTarget)

			if oPlayer==hGlobal.LocalPlayer then
				_AddTownToList(oTarget)
			else
				--如果是被抢了，则尝试从显示列表中移除这个城
				_RemoveTownFromList(oTarget)
			end
		end
	end)

	--获得一个城之后，添加到面板
	hGlobal.event:listen("Event_PlayerGetBuilding","__WM__AddTownButtonAfterGetTown",function(oWorld,oPlayer,oTarget)
		local oTown = oTarget:gettown()
		if oTown then
			local index = #oPlayer.data.ownTown
			oPlayer.data.ownTown[index+1] = {}
			hApi.SetObjectUnit(oPlayer.data.ownTown[index+1],oTarget)

			if oPlayer==hGlobal.LocalPlayer then
				_AddTownToList(oTarget)
			else
				--如果是被抢了，则尝试从显示列表中移除这个城
				_RemoveTownFromList(oTarget)
			end
		end
	end)

	hGlobal.event:listen("LocalEvent_PlayerFocusWorld","__UI__ShowTownListFrame",function(sSceneType,oWorld,oMap)
		--有问题待查(已查)2014/7/11
		if sSceneType=="worldmap" and oWorld then
			_frm:show(1)
			local buildingRet,movepointRet = CheckPlayerEndDay()
			if buildingRet == 0 and movepointRet == 0 then
				hGlobal.event:event("LocalEvent_NextDayBreathe",1)
			end

			--针对右下角的主城显示是否可以建造的信息提示
			for i = _MaxTownNum,1,-1 do
				if _tempU[i]~=0 then
					local v = _tempU[i]
					local btn = _grid.childUI[v.childName]
					local oBuilding = hApi.GetObject(_tempU[i].unit)
					if oBuilding and hGlobal.LocalPlayer:allience(oBuilding:getowner())==hVar.PLAYER_ALLIENCE_TYPE.OWNER then
						local oTown = oBuilding:gettown()
						if oTown then
							if oTown.data.buildingCount == 0 then
								if oTown:checkBuilding() == 0 then
									if btn.childUI["Action:Hammer"].handle._n then
										btn.childUI["Action:Hammer"].handle._n:setVisible(true)
									end
								end
							elseif oTown.data.buildingCount == 1 or oTown:checkBuilding() == 1 then
								if btn.childUI["Action:Hammer"].handle._n then
									btn.childUI["Action:Hammer"].handle._n:setVisible(false)
								end
							end

							if oTown:checkBuilding() == 1 then
								if btn.childUI["UI:finish"].handle._n then
									btn.childUI["UI:finish"].handle._n:setVisible(true)
								end
							end
						end
					end
				end
			end
		else
			_frm:show(0)
		end
	end)

	hGlobal.event:listen("Event_NewDay","isBuilding",function(nDayCount)
		--针对右下角的主城显示是否可以建造的信息提示
		for i = _MaxTownNum,1,-1 do
			if _tempU[i]~=0 then
				local v = _tempU[i]
				local btn = _grid.childUI[v.childName]
				local oBuilding = hApi.GetObject(_tempU[i].unit)
				if oBuilding and hGlobal.LocalPlayer:allience(oBuilding:getowner())==hVar.PLAYER_ALLIENCE_TYPE.OWNER then
					
					local oTown = oBuilding:gettown()
					if oTown then
						if oTown.data.buildingCount == 0 then
							if oTown:checkBuilding() == 0 then
								if btn.childUI["Action:Hammer"].handle._n then
									btn.childUI["Action:Hammer"].handle._n:setVisible(true)
								end
							end
						elseif oTown.data.buildingCount == 1 or oTown:checkBuilding() == 1 then
							if btn.childUI["Action:Hammer"].handle._n then
								btn.childUI["Action:Hammer"].handle._n:setVisible(false)
							end
						end

						if oTown:checkBuilding() == 1 then
							if btn.childUI["UI:finish"].handle._n then
								btn.childUI["UI:finish"].handle._n:setVisible(true)
							end
						end
					end
				end
			end
		end
	end)

	--世界重新创建的时候重新刷一遍选取信息
	hGlobal.event:listen("Event_WorldCreated","__UI_TownIconRefresh",function(oWorld,IsCreatedFromLoad)
		if oWorld.data.type=="worldmap" then
			for i = 1,_MaxTownNum,1 do
				if _tempU[i]~=nil and _tempU[i]~=0 then
					hApi.safeRemoveT(_grid.childUI,_tempU[i].childName)
					_tempU[i] = 0
				end
			end
			_frm.childUI["dragBox"]:sortbutton()
			--创建世界后，刷新条子
			oWorld:enumunit(function(oUnit)
				local p = oUnit:getowner()
				if oUnit:gettown() and p==hGlobal.LocalPlayer then
					_AddTownToList(oUnit)
				end
			end)
		end
	end)

	--移除已存在的城池UI
	hGlobal.event:listen("LocalEvent_ClearTownList","__clear",function()
		for i = 1,_MaxTownNum,1 do
			if _tempU[i]~=nil and _tempU[i]~=0 then
				hApi.safeRemoveT(_grid.childUI,_tempU[i].childName)
				_tempU[i] = 0
			end
		end
		_frm.childUI["dragBox"]:sortbutton()
	end)
end

--------------------------------
-- 加载事件面板
--------------------------------
hGlobal.UI.InitMsgBox = function()
	local _MsgBoxStyle
	_MsgBoxStyle = {
		normal = {hVar.SCREEN.w/2-320,hVar.SCREEN.h/2+270,652,548,0,160,"UI:PANEL_INFO_L"},
		mini = {hVar.SCREEN.w/2-200,hVar.SCREEN.h/2+120,420,300,0,0,"misc/skillup/msgbox4.png"},
		normal2 = {hVar.SCREEN.w/2-240,hVar.SCREEN.h/2+160,480,320,0,0,"misc/skillup/msgbox4.png"},
	}
	hApi.GetMsgBoxXYWH = function(style,tRet)
		if _MsgBoxStyle[style] then
			if tRet then
				for i = 1,4 do
					tRet[i] = _MsgBoxStyle[style][i]
				end
			end
			return _MsgBoxStyle[style]
		end
	end
	local _AnalyzeBtn = function(param,dString,dCode)
		if param==1 then
			return {dString,dCode}
		elseif param==0 then
			return nil
		elseif type(param)=="function" then
			return {dString,param}
		elseif type(param)=="string" then
			return {param,dCode}
		elseif type(param)=="table" then
			return param
		end
	end
	--解决msgbox button文字安卓下偏移问题
	local iChannelId = getChannelInfo()
	local _nlabY = 0
	if iChannelId >= 100 then
		local TargetPlatform = CCApplication:sharedApplication():getTargetPlatform()
		if g_tTargetPlatform.kTargetWindows ~= TargetPlatform then
			_nlabY = 3
		end
	end
	local _CreateBtn = function(p,key,x,y,tData)
		local f = p.childUI["frmMsgBox"]
		local exitCode = tData[2]
		local pData = f.childUI["SelectData"]
		
		
		f.childUI[key] = hUI.button:new({
			parent = f.handle._n,
			dragbox = f.childUI["dragBox"],
			model = tData[3] or "misc/addition/cg.png",
			font = hVar.FONTC,
			label = {text = tData[1],size = 28,y = _nlabY + 4,},
			x = math.floor(x),
			y = math.floor(y) - 20,
			border = 1,
			--scale = tData[4] or 1,
			scale = 0.8,
			w = 168,
			h = 60,
			align = "MC",
			scaleT = 0.9,
			code = function(self)
				f:show(0)
				p:settick(700)
				if type(exitCode)=="function" then
					return exitCode(pData.select,pData.data)
				end
			end,
		})
	end
	local _CreateItemImage = function(oParentUI,tSelection,gridX,gridY,iconW,iconH,plusX,plusY)
		local v = tSelection[gridX+1]
		if v==nil then
			return
		end
		local x,y,w,h = (tSelection.iconX or 0),(tSelection.iconY or 0),iconW,iconH
		local model,animation
		local id
		local num = 0
		if type(v)=="table" then
			x = v.x or x
			y = v.y or y
			model = v.model
			animation = v.animation or tSelection.animation
			id = v.id
			if type(v.num)=="number" then
				num = v.num
			end
		else
			id = v
			animation = tSelection.animation
		end
		if type(id)=="number" then
			if tSelection.tab~=nil then
				local mKey = tSelection.tabModelKey or "model"
				local mTab = tSelection.tab[id]
				if mTab~=nil then
					model = mTab[mKey] or "MODEL:Default"
				end
			end
		end
		if model==nil then
			return
		end
		hUI.deleteUIObject(hUI.image:new({
			parent = oParentUI.handle._n,
			model = model,
			animation = animation,
			w = w,
			h = h,
			smartWH = 1,
			x = x+plusX,
			y = y+plusY,
		}))
		if num>0 then
			hUI.deleteUIObject(hUI.label:new({
				parent = oParentUI.handle._n,
				font = "numWhite",
				size = 16,
				text = "x"..num,
				x = plusX,
				y = -20+plusY,
				align = "MC"
			}))
		end
	end
	local _TokenT,_TokenM = {data={}},{align = "MC"}
	local _CreateGrid = function(frm,x,y,tSelection,codeOnSelect)
		local pData = frm.childUI["SelectData"]
		local slot = {}
		for i = 1,#tSelection do
			slot[i] = "UI_frm:slot"
		end
		local sGrid
		local mode = tSelection.select==0 and "image" or "button"
		local exitCode = (frm.childUI["btnOk"] or frm.childUI["btnCancel"] or _TokenT).data.code or hApi.DoNothing
		local IsFirstClick = 0
		local _LastX,_LastY
		sGrid = hUI.grid:new({
			parent = frm.handle._n,
			mode = mode,
			dragbox = frm.childUI["dragBox"],
			animation = "lightSlim",
			align = "MC",
			gridW = 80,
			gridH = 80,
			iconW = 74,
			iconH = 74,
			smartWH = 1,
			x = math.floor(x-40*(#slot-1)),
			y = math.floor(y-36),
			scaleT = 0.90,
			--offsetX = {0,40},
			grid = slot,
			code = function(_,_,_,gridX,gridY)
				if _LastX==gridX and _LastY==gridY and IsFirstClick==0 then
					return exitCode()
				end
			end,
			codeOnTouch = function(_,_,_,gridX,girdY)
				if _LastX~=gridX or _LastY~=girdY then
					IsFirstClick = 1
					pData.select = (gridX+1)
					if _LastX and _LastY then
						local sprite = sGrid:getimage(_LastX,_LastY,1)
						if sprite~=nil then
							sprite:getParent():removeChild(sprite,true)
						end
					end
					_LastX = gridX
					_LastY = girdY
					sGrid:addimage("UI:Button_SelectBorder",gridX,girdY,_TokenM)
				else
					IsFirstClick = 0
				end
			end,
			codeOnImageCreate = function(self,id,sprite,gridX,gridY)
				local x,y = self:grid2xy(gridX,gridY)
				_CreateItemImage(self,tSelection,gridX,gridY,72,72,x,y)
			end,
			codeOnButtonCreate = function(self,id,btn,gridX,gridY)
				_CreateItemImage(btn,tSelection,gridX,gridY,72,72,0,0)
			end,
		})
		frm.childUI["SelectGrid"] = sGrid
		frm.childUI["SelectGrid"].data.tab = 0
		frm.childUI["SelectGrid"].data.iconW = 78
		frm.childUI["SelectGrid"].data.iconH = 78
		frm.childUI["SelectGrid"].data.codeOnImageCreate = 0
		frm.childUI["SelectGrid"].data.codeOnButtonCreate = 0
		if mode=="button" then
			pData.select = -1
			sGrid.data.codeOnTouch(nil,nil,nil,0,0)
		end
	end
	local _CreateMsgBox = function(style,text,textX,textY,textFont,textSize,textAlign,btnOk,btnCancel,codeOnExit,other)
		style = style or "mini"
		textSize = textSize or 28
		local sData = _MsgBoxStyle[style] or _MsgBoxStyle.mini
		local x,y,pw,ph,tx,ty,model = unpack(sData)
		tx = tx + textX
		ty = ty + textY
		local _panel = hUI.panel:new({codeOnExit = codeOnExit})
		local _LastShakeTick = 0
		
		local _frame = hUI.frame:new({
			x = x,
			y = y,
			w = pw,--652,
			h = ph,--548,
			z = hZorder.Msgbox,
			closebtn = 0,
			dragable = 4,
			top = 1,
			background = model,
			--codeOnDragEx = function(x,y)
				--print("测试啊",x,y)
			--end,
			--codeOnTouch = function(self,x,y,isInside)
				--if isInside==0 and self.data.show==1 and _LastShakeTick<=hApi.gametime() then
					--_LastShakeTick = hApi.gametime()+160
					--self.handle._n:runAction(CCJumpBy:create(0.15,ccp(0,0),10,1))
				--end
			--end,
		})
		_panel.childUI["frmMsgBox"] = _frame
		
		local w,h = _frame.data.w,_frame.data.h
		local _childUI = _frame.childUI
		local pData = {select=0,data=nil,del=hApi.DoNothing}
		_childUI["SelectData"] = pData
		
		--当是大框体时 加一条分界线
		if style == "normal" then
			_childUI["apartline"] = hUI.image:new({
				parent = _frame.handle._n,
				model = "UI:panel_part_09",
				x = 325,
				y = -155,
				w = w + 20,
				h = 16,
			})
		end
		
		if btnOk~=nil and btnCancel~=nil then
			--print("1111111")
			--双按钮
			_CreateBtn(_panel,"btnOk",w/2+86,90-h,btnOk)
			_CreateBtn(_panel,"btnCancel",w/2-86,90-h,btnCancel)
		elseif btnOk~=nil then
			--print("22222")
			if btnOk[5] and btnOk[6] then
				_CreateBtn(_panel,"btnOk",w/2- btnOk[5],btnOk[6]-h,btnOk)
			else
				_CreateBtn(_panel,"btnOk",w/2,90-h,btnOk)
			end
		else
			--print("333333")
			btnCancel = btnCancel or {hVar.tab_string["__TEXT_Close"]}
			_CreateBtn(_panel,"btnCancel",w/2,90-h,btnCancel)
		end
		if text~=nil then
			local tX,tY
			if textAlign=="LT" or textAlign=="LC" or textAlign=="LB" then
				tX = math.floor(w/10)+tx + 10
				tY = 40-math.floor(h/2)+ty
			elseif textAlign=="RT" or textAlign=="RC" or textAlign=="RB" then
				tX = math.floor(w*9/10)+tx
				tY = 40-math.floor(h/2)+ty
			else
				tX = math.floor(w/2)+tx
				tY = 40-math.floor(h/2)+ty
			end
			
			if type(other) == "table" then
				_childUI["image"] = hUI.image:new({
					parent = _frame.handle._n,
					model = other[1],
					x = other[2] or _frame.data.w/2 - 10,
					y = other[3] or - 40,
					w = other[4] or -1,
					h = other[5] or -1,
					scale = other[6] or 1,
				})
			end
			_childUI["sHint"] = hUI.label:new({
				parent = _frame.handle._n,
				x = tX,
				y = tY,
				size = textSize,
				border = 1,
				width = w-64,
				align = textAlign,
				font = textFont,
				text = tostring(text),
			})
		end
		return _frame
	end
	hGlobal.UI.MsgBox = function(text,tSelection,codeOnSelect,btStyle,other)
		_MsgBoxStyle.normal[1] = hVar.SCREEN.w/2-320
		_MsgBoxStyle.normal[2] = hVar.SCREEN.h/2+270
		_MsgBoxStyle.mini[1] = hVar.SCREEN.w/2-200
		_MsgBoxStyle.mini[2] = hVar.SCREEN.h/2+120
		_MsgBoxStyle.normal2[1] = hVar.SCREEN.w/2-240
		_MsgBoxStyle.normal2[2] = hVar.SCREEN.h/2+160
		local btnOk,btnCancel
		local frmStyle = "mini"
		local textSize = 28
		local textX,textY = 0,0
		local textAlign = "MC"
		local textOk = nil --确定的文字
		local textCancel = nil --取消的文字
		local textFont	--默认字体arial
		local codeOnExit
		local tIcon
		if type(tSelection)=="table" then
			codeOnExit = tSelection.codeOnExit
			textX = tSelection.textX or textX
			textY = tSelection.textY or textY
			textAlign = tSelection.textAlign or textAlign
			textSize = tSelection.textSize or textSize
			textFont = tSelection.textFont or textFont
			textOk = tSelection.textOk or hVar.tab_string["confirm"] --确定的文字
			textCancel = tSelection.textCancel or hVar.tab_string["__TEXT_Close"] --取消的文字
			btnOk = _AnalyzeBtn(tSelection.ok, textOk,codeOnSelect)
			btnCancel = _AnalyzeBtn(tSelection.cancel, textCancel,tSelection.cancelFun)
			if btnOk==nil and btnCancel==nil and codeOnSelect~=nil and type(codeOnSelect)=="function" then
				btnOk = _AnalyzeBtn(1,hVar.tab_string["__TEXT_Close"],codeOnSelect)
			end
			if type(tSelection.style)=="string" then
				frmStyle = tSelection.style
			elseif #tSelection>0 then
				frmStyle = "normal"
			end
			tIcon = tSelection.icon
		else
			btnCancel = _AnalyzeBtn(1,hVar.tab_string["__TEXT_Close"],codeOnSelect)
		end
		--如果有按钮风格
		if btStyle then
			btnOk[1] = btStyle[1]
			btnOk[3] = btStyle[2]
			btnOk[4] = btStyle[3]
			btnOk[5] = btStyle[4]
			btnOk[6] = btStyle[5]
		end
		
		local oFrm = _CreateMsgBox(frmStyle,text,textX,textY,textFont,textSize,textAlign,btnOk,btnCancel,codeOnExit,other)
		if type(tSelection)=="table" and #tSelection>0 then
			_CreateGrid(oFrm,(tSelection.gridX or 0)+oFrm.data.w/2-10,(tSelection.gridY or 0)-oFrm.data.h/2,tSelection,codeOnSelect)
		end
		if tIcon~=nil then
			local model,iconX,iconY,iconW,iconH
			if type(tIcon)=="string" then
				model = tIcon
				iconX = math.floor(oFrm.data.w/2)
				iconY = -1*math.floor(oFrm.data.h/5)
			elseif type(tIcon)=="table" then
				model = tIcon[1]
				if type(tIcon[2])=="number" and type(tIcon[3])=="number" then
					iconX = tIcon[2]
					iconY = tIcon[3]
				else
					iconX = math.floor(oFrm.data.w/2)
					iconY = -1*math.floor(oFrm.data.h/5)
				end
				iconW = tIcon[4]
				iconH = tIcon[5]
			end
			if model then
				oFrm.childUI["icoWarning"] = hUI.image:new({
					parent = oFrm.handle._n,
					model = model,
					x = iconX,
					y = iconY,
					w = iconW,
					h = iconH,
				})
			end
		end
		
		--oFrm:active()
		
		--print("oFrm=", oFrm)
		return oFrm
	end
	--tSelection = {
		--ok = 1,
		--cancel = 1,
		--style = "mini",
		--iconX = 0,
		--iconY = 0,
		--gridX = 0,
		--gridY = 0,
		--textX = 0,
		--textY = 0,
		--textAlign = 0,
		--textSize = 28,
		--tab = hVar.tab_unit,
		--tabModelKey = "model",
		--animation = nil,
		--[1] = {id = 10,num = 1,model = nil,animation = nil}
	--}
	--范例:hGlobal.UI.MsgBox("请选择你的奖励\n啊啊啊这是毛",{
		--ok = 1,
		--style = "mini",
		--select = 1,
		--gridY = -60,
		----[1] = {id=5001,num=30},
		----[2] = {id=5000},
	--},function(nSelect)
		--print("选择的奖励是",nSelect)
	--end)
end

--
----------------------------------
---- 加载队伍面板
----------------------------------
--hGlobal.UI.InitTeamFrame = function()
--	if hGlobal.UI.TeamFrame~=nil then
--		for i = 1,#hGlobal.UI.TeamFrame do
--			hGlobal.UI.TeamFrame[i][1]:del()
--		end
--	end
--
--	if hGlobal.UI.TeamFrameBG~=nil then
--		hGlobal.UI.TeamFrameBG:del()
--	end
--
--	hGlobal.UI.TeamFrame = {unit = {}}
--	setmetatable(hGlobal.UI.TeamFrame,{
--		__newindex = function(self,k,v)
--			rawset(self,k,v)
--			rawget(self,"unit")[k] = {}
--		end,
--	})
--
--	local _UpdateImageUpdate = hApi.DoNothing						--add by pangyong 2015/4/7		(刷新队伍)
--	local _tFrm = hGlobal.UI.TeamFrame
--	local __callback__DropTeamUnit = hApi.DoNothing
--	local _GridColNum = 7
--	local _GridW,_GridH = 74,74
--	local _BagGrid = function(w,grid,slot,codeOnItemDrop)
--		local t = {
--			__UI = "bagGrid",
--			__NAME = "teamGrid",
--			tab = hVar.tab_unit,
--			tabModelKey = "model",
--			animation = function(id,model)
--				return hApi.animationByFacing(model,"stand",180)
--			end,
--			animationSelect = function(id,model)
--				return hApi.animationByFacing(model,"walk",180)
--			end,
--			align = "MC",
--			x = 37,
--			y = -37,
--			gridW = w,
--			gridH = 74,
--			iconW = 72,
--			iconH = 72,
--			smartWH = 1,
--			grid = grid,
--			slot = slot,
--		}
--		local lasttime = 0
--		t.codeOnItemSelect = function(self,item,relX,relY,gridX,gridY,cur_time)
--			lasttime = cur_time
--		end
--		t.codeOnUpdate = function(self,tItem,nCount,sItemName,gx,gy)
--			--add by pangyong 2015/3/19
--			--刷新军队列表
--			_UpdateImageUpdate(self,tItem,nCount,sItemName,gx,gy)
--		end
--		if codeOnItemDrop then
--			t.codeOnItemDrop = codeOnItemDrop
--		else
--			t.codeOnItemDrop = function(self,item,relX,relY,screenX,screenY,Sprite,cur_time)
--				lasttime = cur_time - lasttime
--				return __callback__DropTeamUnit(self,item,relX,relY,screenX,screenY,Sprite,lasttime)
--			end
--		end
--		return t
--	end
--	--用来关闭在大地图上拽出来的队伍面板
--	hGlobal.UI.TeamFrameBG = hUI.frame:new({
--		x = 0,												--added by pangyong 2015/4/13		(点击其他位置 关闭队伍面板)
--		y = 0,
--		w = 2048,
--		h = 2048,
--		batchmodel = "UI_frm:info_BG",
--		dragable = 2,											--只能是2，否则点击窗口以外无法响应codeOnTouch()
--		show = 0,
--		autoactive = 0,
--		codeOnTouch = function(self,x,y,isInside)
--			for i = 1,#_tFrm do
--				_tFrm[i]:show(0)
--			end
--			self:show(0)
--		end,
--	})
--	
--	local _FMAIN,_FEX,_FTOWN = 1,2,3
--	--主要面板
--	_tFrm[_FMAIN] = hUI.frame:new({
--		w = _GridColNum*_GridW,
--		h = _GridH,
--		batchmodel = "UI_frm:info_BG",
--		dragable = 0,
--		show = 0,
--		autoactive = 0,
--		child = {
--			_BagGrid(_GridW,{0,0,0,0,0,0,0},nil,nil),
--		},
--	})
--	
--	--次要面板
--	_tFrm[_FEX] = hUI.frame:new({
--		w = _GridColNum*_GridW,
--		h = _GridH,
--		batchmodel = "UI_frm:info_BG",
--		dragable = 0,
--		show = 0,
--		autoactive = 0,
--		child = {
--			_BagGrid(_GridW,{0,0,0,0,0,0,0},nil,nil),
--		},
--	})
--
--	--城镇面板
--	_tFrm[_FTOWN] = hUI.frame:new({
--		x = hVar.SCREEN.w - 1024 + 428,
--		y = 80,
--		w = _GridColNum*_GridW,
--		h = _GridH,
--		dragable = 0,
--		show = 1,
--		autoactive = 0,
--		background = -1,
--		child = {
--			_BagGrid(_GridW,{0,0,0,0,0,0,0},0,nil),
--		},
--	})
--
--	--获取队伍UI位置
--	hApi.GetTeamUIPos = function(case,nIndex)
--		local oFrm
--		local oGrid
--		if case=="town" then
--			oFrm = _tFrm[_FTOWN]
--			oGrid = _tFrm[_FTOWN].childUI["teamGrid"]
--		end
--		if oFrm and oGrid then
--			local x,y = oGrid:grid2xy((nIndex-1),0)
--			if x and y then
--				return oFrm.data.x+oGrid.data.x+x,oFrm.data.y+oGrid.data.y+y
--			end
--		end
--	end
--
--	local _frmCommon = _tFrm[_FMAIN]
--	local _frmTown = _tFrm[_FTOWN]
--	local _frmEx = _tFrm[_FEX]
--
--	--changed by pangyong 2015/4/3
--	--hGlobal.event:listen("LocalEvent_HitOnHeroPhoto","__callback__TeamFrameClose",function(oUnit,nSlot)
--		--_frmCommon:show(0)
--	--end)
--
--	local _visitorBtnStartX = 0
--	local _guarderBTnStartX = 0
--	
--	local _guarderFram
--	local _visitorBtn
--	local _guarderBtn
--
--	local _visitorBtnStartY = 0
--	local _guarderBTnStartY = 0
--	
--	hGlobal.UI.GuarderFram = hUI.frame:new({
--		x = hVar.SCREEN.w - 72,
--		y = 152,
--		w = 64,
--		h = 150,
--		titlebar = 0,
--		autoactive = 0,
--		dragable = 2,
--		buttononly = 1,
--		show = 0,
--		background = -1,
--	})
--	_guarderFram = hGlobal.UI.GuarderFram
--
--	--离开城镇按钮
--	local LeaveTownBtn = hUI.button:new({
--		parent = _guarderFram.handle._n,
--		mode = "imageButton",
--		dragbox = _guarderFram.childUI["dragBox"],
--		model = "UI:LEAVETOWNBTN",
--		x = -590,
--		y = -115,
--		w = 64,
--		h = 64,
--		scaleT = 0.9,
--		failcall = 1,
--		code = function(self,x,y,sus)
--			xlLuaEvent_LeaveTown()
--		end,
--	})
--	
--	local _optionbtn_L = hUI.button:new({
--		parent = _guarderFram.handle._n,
--		mode = "imageButton",
--		model = "UI:BTN_DragableHint",
--		animation = "L",
--		x = -12,
--		y = -22,
--		scaleT = 1.1,
--		scale = 0.8,
--		w = 16,
--		h = 64,
--		
--	})
--	_optionbtn_L.handle.s:setOpacity(150)
--	local _optionbtn_D = hUI.button:new({
--		parent = _guarderFram.handle._n,
--		mode = "imageButton",
--		model = "UI:BTN_DragableHint",
--		animation = "U",
--		x = 31,
--		y = -62,
--		scaleT = 1.1,
--		scale = 0.8,
--		w = 16,
--		h = 64,
--	})
--	_optionbtn_D.handle.s:setOpacity(150)
--
--	--_optionbtn:setstate(-1)
--	--访问者位按钮
--	_visitorBtn = hUI.button:new({
--		parent = _guarderFram.handle._n,
--		mode = "imageButton",
--		dragbox = _guarderFram.childUI["dragBox"],
--		model = -1,
--		x = 32,--hVar.SCREEN.w - 40,
--		y = -22,--120,
--		w = 64,
--		h = 64,
--		scaleT = 0.9,
--		failcall = 1,
--		codeOnTouch = function(self,x,y)
--			_frmCommon:show(0)
--			_visitorBtnStartX = x
--			_,_visitorBtnStartY = self.handle._n:getPosition()
--
--			hApi.PlaySound("button")
--		end,	
--		code = function(self,x,y,sus)
--			if hApi.getUpgradeFrmState() == 1 then return end
--			if _frmCommon.data.show == 1 then
--				self:setXY(32,-22)
--				_guarderBtn:setXY(32,-110)
--				self.handle._n:setPosition(32,-22)
--				_guarderBtn.handle._n:setPosition(32,-110)
--				return 
--			end
--			local oTown = hApi.GetObject(_tFrm.unit[_FTOWN])
--			local TownData = oTown:gettown()
--			local w = oTown:getworld()
--			if TownData then
--				local vU = hApi.GetObjectUnit(TownData.data.visitor)
--				local gU = hApi.GetObjectUnit(TownData.data.guard)
--				if y < -75 then
--					--访问者设置成驻守的逻辑
--					if gU == nil then
--						local tempLen = 0
--						if type(oTown.data.team) == "table" then
--							for i = 1,#oTown.data.team do
--								if oTown.data.team[i] ~= 0 then
--									tempLen = tempLen + 1
--								end
--							end
--
--							for i = 1,#vU.data.team do
--								if vU.data.team[i] ~= 0 then
--									tempLen = tempLen + 1
--								end
--							end
--
--							for i = 1,#vU.data.team do
--								if vU.data.team[i] ~= 0 then
--									for j = 1,#oTown.data.team do
--										if oTown.data.team[j] ~= 0 then
--											if vU.data.team[i][1] == oTown.data.team[j][1] then
--												tempLen = tempLen - 1 
--											end
--										end
--									end
--								end
--							end
--
--							if tempLen > 7 then
--								self:setXY(32,-22)
--								_guarderBtn:setXY(32,-110)
--								self.handle._n:setPosition(32,-22)
--								_guarderBtn.handle._n:setPosition(32,-110)
--								print("兵种总数超过可交换上限【7】，目前已经有【"..tempLen.."】种兵")
--								return
--							end
--						end
--					end
--					self:setXY(32,-110)
--					_guarderBtn:setXY(32,-22)
--					self.handle._n:setPosition(32,-110)
--					_guarderBtn.handle._n:setPosition(32,-22)
--					local _,tempY = self.handle._n:getPosition()
--					if math.abs(_visitorBtnStartY) ~= math.abs(tempY) then
--						--当没有守卫时 将访问者设置成守卫
--						hGlobal.LocalPlayer:order(w,hVar.OPERATE_TYPE.SET_GUARD,gU,vU,oTown,0,0,0,0)
--					end
--				else
--					self:setXY(32,-22)
--					_guarderBtn:setXY(32,-110)
--					self.handle._n:setPosition(32,-22)
--					_guarderBtn.handle._n:setPosition(32,-110)	
--					local _,tempY = self.handle._n:getPosition()
--					if math.abs(_visitorBtnStartY) ~= math.abs(tempY) then
--						--当没有访问者时 或者访问者被设置成了驻守时
--						hGlobal.LocalPlayer:order(w,hVar.OPERATE_TYPE.SET_VISITOR,gU,vU,oTown,0,0,0,0)
--					end
--				end
--			end
--			
--		end,
--		codeOnDrag = function(self,x,y)
--			if _frmCommon.data.show == 1 then return end
--			_optionbtn_L:setstate(-1)
--			_optionbtn_D:setstate(-1)
--			if y < 0 and y > -118 and hApi.getUpgradeFrmState() == 0 then
--				self.handle._n:setPosition(32,y)
--				_guarderBtn.handle._n:setPosition(32,-y-142)
--			end
--
--			--左移动可以拖出队伍列表
--			if math.abs(x - _visitorBtnStartX) > 60 and math.abs(y - _visitorBtnStartY) < 10 then
--				local oTown = hApi.GetObject(_tFrm.unit[_FTOWN])
--				local TownData = oTown:gettown()
--				local oUnit = hApi.GetObjectUnit(TownData.data.visitor)
--				if oUnit then
--					hGlobal.event:event("LocalEvent_DragOutHeroPhoto",oUnit,1,hVar.SCREEN.w - 76,130)
--				end
--			end
--			
--		end,
--	})
--
--	_visitorBtn.childUI["bg"] = hUI.image:new({
--		parent = _visitorBtn.handle._n,
--		model = "UI_frm:slot",
--		animation = "lightSlim",
--		w = 68,
--		h = 68,
--		z = -1,
--	})
--	
--
--	--驻守英雄位按钮
--	_guarderBtn = hUI.button:new({
--		parent = _guarderFram.handle._n,
--		mode = "imageButton",
--		dragbox = _guarderFram.childUI["dragBox"],
--		model = -1,
--		x = 32,
--		y = -110,
--		w = 64,
--		h = 64,
--		scaleT = 0.9,
--		failcall = 1,
--		codeOnTouch = function(self,x,y)
--			_frmCommon:show(0)
--			_guarderBTnStartX = x
--			_,_guarderBTnStartY = self.handle._n:getPosition()
--
--			hApi.PlaySound("button")
--		end,
--		
--		code = function(self,x,y,sus)
--			if hApi.getUpgradeFrmState() == 1 then return end
--			if  _frmCommon.data.show == 1 then
--				self:setXY(32,-22)
--				_visitorBtn:setXY(32,-110)
--				self.handle._n:setPosition(32,-22)
--				_visitorBtn.handle._n:setPosition(32,-110)
--				return
--			end
--			local oTown = hApi.GetObject(_tFrm.unit[_FTOWN])
--			local TownData = oTown:gettown()
--			local w = oTown:getworld()
--			if TownData then
--				local vU = hApi.GetObjectUnit(TownData.data.visitor)
--				local gU = hApi.GetObjectUnit(TownData.data.guard)
--				if y < -75 then
--					self:setXY(32,-110)
--					_visitorBtn:setXY(32,-22)
--					self.handle._n:setPosition(32,-110)
--					_visitorBtn.handle._n:setPosition(32,-22)
--					local _,tempY = self.handle._n:getPosition()
--					if  math.abs(_guarderBTnStartY) ~=  math.abs(tempY) then 
--						--移动至原位
--						hGlobal.LocalPlayer:order(w,hVar.OPERATE_TYPE.SET_GUARD,gU,vU,oTown,0,0,0,0)
--						
--					end
--				else
--					self:setXY(32,-22)
--					_visitorBtn:setXY(32,-110)
--					self.handle._n:setPosition(32,-22)
--					_visitorBtn.handle._n:setPosition(32,-110)
--					local _,tempY = self.handle._n:getPosition()
--					if math.abs(_guarderBTnStartY) ~=  math.abs(tempY) then 
--						hGlobal.LocalPlayer:order(w,hVar.OPERATE_TYPE.SET_VISITOR,gU,vU,oTown,0,0,0,0)
--					end
--				end 
--			end
--		end,
--		codeOnDrag = function(self,x,y)
--			if _frmCommon.data.show == 1 then return end
--
--			if y < 0 and y > -118 then
--				self.handle._n:setPosition(32,y)
--				_visitorBtn.handle._n:setPosition(32,-y-142)
--			end
--			
--			--左移动可以拖出队伍列表
--			if math.abs(x - _visitorBtnStartX) > 60 and math.abs(y - _visitorBtnStartY) < 10 and hApi.getUpgradeFrmState() == 0 then
--				local oTown = hApi.GetObject(_tFrm.unit[_FTOWN])
--				local TownData = oTown:gettown()
--				local oUnit = hApi.GetObjectUnit(TownData.data.visitor)
--				if oUnit then
--					hGlobal.event:event("LocalEvent_DragOutHeroPhoto",oUnit,1,hVar.SCREEN.w - 76,130)
--				end
--			end
--			_optionbtn_L:setstate(-1)
--			_optionbtn_D:setstate(-1)
--		end,
--	})
--	_guarderBtn.childUI["bg"] = hUI.image:new({
--		parent = _guarderBtn.handle._n,
--		model = "UI_frm:slot",
--		animation = "lightSlim",
--		w = 68,
--		h = 68,
--		z = -1,
--	})
--
--	hGlobal.NOOB_TIP_UI["TownVisitorBtn"] = _visitorBtn
--	hGlobal.NOOB_TIP_UI["TownGuardBtn"] = _guarderBtn
--
--	--交换守卫与访问者
--	hGlobal.event:listen("Event_TownShiftGuardAndVisitor","__AfterChange",function(oWorld,oTown,oGuard,oVisitor,nOperate)
--		if oTown:getowner() == hGlobal.LocalPlayer then
--			_frmTown.childUI["teamGrid"]:updateitem(oVisitor.data.team)
--			_frmTown:show(1)
--			hGlobal.event:event("LocalEvent_DragOutHeroPhoto",oGuard,1,hVar.SCREEN.w - 76,130)
--			hGlobal.LocalPlayer:focusunit(oGuard,"worldmap")
--
--			_optionbtn_L:setstate(1)
--			_optionbtn_D:setstate(1)
--		end
--	end)
--	--设置访问者
--	hGlobal.event:listen("Event_TownSetVisitor","__afterSetVisitor",function(oWorld,oTown,oVisitor,nOperate)
--		if oTown:getowner() == hGlobal.LocalPlayer then
--			local TownData = oTown:gettown()
--			if nOperate == hVar.OPERATE_TYPE.SET_VISITOR then
--				local oGuard = hApi.GetObjectUnit(TownData.data.guard)
--				if oGuard then
--					_frmTown.childUI["teamGrid"]:updateitem(oVisitor.data.team)
--				else
--					_frmTown.childUI["teamGrid"]:updateitem(oTown.data.team)
--				end
--				
--				hGlobal.event:event("LocalEvent_DragOutHeroPhoto",oVisitor,1,hVar.SCREEN.w - 76,130)
--				hGlobal.LocalPlayer:focusunit(oVisitor,"worldmap")
--			elseif  nOperate == hVar.OPERATE_TYPE.HERO_REVIVE then
--				if _visitorBtn.data.state == 1 then
--					_guarderBtn:loadsprite(oVisitor:gethero().data.icon)
--					_guarderBtn:setstate(1)
--				else
--					_visitorBtn:loadsprite(oVisitor:gethero().data.icon)
--					_visitorBtn:setstate(1)
--				end
--				hGlobal.event:event("LocalEvent_DragOutHeroPhoto",oVisitor,1,hVar.SCREEN.w - 76,130)
--				hGlobal.LocalPlayer:focusunit(oVisitor,"worldmap")
--			end
--			_frmTown:show(1)
--			_optionbtn_L:setstate(1)
--			_optionbtn_D:setstate(1)
--		end
--	end)
--	--设置守卫
--	hGlobal.event:listen("Event_TownSetGuard","__afterSetGuard",function(oWorld,oTown,oGuard,nOperate)
--		if oTown:getowner() == hGlobal.LocalPlayer then
--			if nOperate == hVar.OPERATE_TYPE.SET_GUARD then
--				_frmTown.childUI["teamGrid"]:updateitem(oGuard.data.team)
--				_frmTown:show(1)
--			elseif nOperate == hVar.OPERATE_TYPE.HERO_REVIVE then
--				_guarderBtn:loadsprite(oGuard:gethero().data.icon)
--				_guarderBtn:setstate(1)
--				_frmTown.childUI["teamGrid"]:updateitem(oGuard.data.team)
--				_frmTown:show(1)
--			end
--			_optionbtn_L:setstate(-1)
--			_optionbtn_D:setstate(-1)
--		end
--	end)
--
--	--切地图隐藏基本条子
--	hGlobal.event:listen("LocalEvent_PlayerFocusWorld","__UI__HideTeamFrame",function(sSceneType,oWorld,oMap)
--		--有问题待查(已查)2014/7/11
--		_frmTown:show(0)
--		_frmEx:show(0)
--		_guarderFram:show(0)
--		_frmCommon:show(0)
--		if sSceneType=="town" and oWorld then
--			local oTarget = oWorld:getlordU("building")
--			hApi.SetObject(_tFrm.unit[_FTOWN],oTarget)
--			_frmTown:show(1)
--			if oTarget then
--				--显示 并初始化 驻守英雄面板
--				_guarderFram:show(1)
--				_visitorBtn:setXY(32,-22)
--				_visitorBtn.handle._n:setPosition(32,-22)
--				_guarderBtn:setXY(32,-110)
--				_guarderBtn.handle._n:setPosition(32,-110)
--				_visitorBtn:setstate(-1)
--				_guarderBtn:setstate(-1)
--				_optionbtn_L:setstate(-1)
--				_optionbtn_D:setstate(-1)
--				local visitor = nil
--				local TownData = oTarget:gettown()
--				
--				if TownData then
--					visitor = TownData:getunit("visitor")
--					if visitor then
--						_visitorBtn:loadsprite(visitor:gethero().data.icon)
--						_visitorBtn:setstate(1)
--
--						_optionbtn_L:setstate(1)
--						_optionbtn_D:setstate(1)
--					end
--
--					local gU = TownData:getunit("guard")
--					if gU then
--						_guarderBtn:loadsprite(gU:gethero().data.icon)
--						_guarderBtn:setstate(1)
--						--如果有守备，则城市的team 显示为 守备身上的
--						oTarget = gU
--					end
--				end
--
--				--显示升级按钮
--				if type(oTarget.data.team) == "table" then
--					for i = 1,#oTarget.data.team do
--						if oTarget.data.team[i] ~= 0 then 
--							local upgradelist = hVar.tab_unit[oTarget.data.team[i][1]].upgrade
--							if upgradelist then
--								local upID = upgradelist[1]
--								local curprice = hVar.tab_unit[oTarget.data.team[i][1]].price
--								local upprice = hVar.tab_unit[upID].price
--								local price = {}
--								for i = 1,#upprice do
--									price[i] = upprice[i] - (curprice[i] or 0)
--								end
--
--								local result = 1
--								local buildingResult = 0
--								--根据编辑器顺序进行资源保存
--								local tempPlayRes = {
--									hGlobal.LocalPlayer:getresource(hVar.RESOURCE_TYPE.GOLD),
--									hGlobal.LocalPlayer:getresource(hVar.RESOURCE_TYPE.FOOD),
--									hGlobal.LocalPlayer:getresource(hVar.RESOURCE_TYPE.STONE),
--									hGlobal.LocalPlayer:getresource(hVar.RESOURCE_TYPE.WOOD),
--									hGlobal.LocalPlayer:getresource(hVar.RESOURCE_TYPE.LIFE),
--									hGlobal.LocalPlayer:getresource(hVar.RESOURCE_TYPE.CRYSTAL)
--								}
--								local varList = {}
--								for j = 1,6 do
--									varList[j] = (price[j] or 0)*oTarget.data.team[i][2]
--								end
--								for j = 1,6 do
--									if tempPlayRes[j]<varList[j] then
--										result = 0
--									end
--								end
--								
--								oWorld:enumunit(function(eu)
--									if hVar.tab_unit[eu.data.id].hireList then
--										for j = 1 ,#hVar.tab_unit[eu.data.id].hireList do
--											if hVar.tab_unit[eu.data.id].hireList[j][1] == upID then
--												buildingResult = 1
--											end
--										end
--									end
--								end)
--							end
--						end
--					end
--				end
--				_frmTown.childUI["teamGrid"]:updateitem(oTarget.data.team)
--			end
--		else
--
--		end
--	end)
--	
--	--保存英雄头像的位置 
--	hGlobal.event:listen("LocalEvent_DragOutHeroPhoto","__callback__TeamFrameShow",function(oUnit,nSlot,posX,posY)
--		local oWorld = hGlobal.LocalPlayer:getfocusworld()
--		if oWorld then
--			local teamGrid = _frmCommon.childUI["teamGrid"]
--			hApi.SetObject(_tFrm.unit[_FMAIN],oUnit)
--			if oWorld.data.type=="worldmap" then
--				hGlobal.UI.TeamFrameBG:show(1)
--				hGlobal.UI.TeamFrameBG:active()
--			elseif oWorld.data.type=="town" then
--				
--			end
--			_frmCommon:show(1)
--			_frmCommon:active()
--			if posX and posY then
--				_frmCommon:setXY(posX-_GridColNum*teamGrid.data.gridW,posY+teamGrid.data.gridH/2)
--			end
--			teamGrid:updateitem(oUnit.data.team)
--			teamGrid:fadein(0.25,180,0)
--		end
--	end)
--
--	--added by pangyong 2015/4/3
--	hGlobal.event:listen("LocalEvent_RefreshHeroTeamList","__callback__RefreshHeroTeamList",function()
--		local teamGrid_visitor = _frmCommon.childUI["teamGrid"]							--访问者的军队框
--		local teamGrid_guard = _frmTown.childUI["teamGrid"]							--守卫者的军队框
--		local oTown = hApi.GetObject(_tFrm.unit[_FTOWN])
--		local TownData = oTown:gettown()
--
--		local oUnitV = hApi.GetObjectUnit(TownData.data.visitor)						--获取访问者
--		local oUnitG = hApi.GetObjectUnit(TownData.data.guard)							--获取守卫者
--
--		if oUnitV then
--			teamGrid_visitor:updateitem(oUnitV.data.team)							--刷新访问者的兵
--		end
--		if oUnitG then
--			teamGrid_guard:updateitem(oUnitG.data.team)							--刷新守卫者的兵
--		else
--			teamGrid_guard:updateitem(oTown.data.team)							--刷新城镇内的兵
--		end
--	end)
--
--	--隐藏队伍操作面板
--	hGlobal.event:listen("LocalEvent_HideHeroTeamList","__callback__HideHeroTeamList",function()
--		_frmCommon:show(0)
--		_frmEx:show(0)
--	end)
--
--	hGlobal.event:listen("Event_UnitArrive","__UI__ShowTeamWhenJoin",function(oWorld,oUnit,gridX,gridY,oTarget,nOperate,nOperateId)
--		local u = oUnit
--		local w = oWorld
--		if w.data.type=="worldmap" and nOperate==hVar.OPERATE_TYPE.UNIT_JOIN and oTarget~=nil and hGlobal.LocalPlayer:getfocusworld()==oWorld then
--			local oHero = oUnit:gethero()
--			local oHeroEx = oTarget:gethero()
--			if oHero and oHero.heroUI["btnIcon"] and oHero:getowner()==hGlobal.LocalPlayer and oHeroEx and oHeroEx.heroUI["btnIcon"] and oHeroEx:getowner()==hGlobal.LocalPlayer then
--				hApi.SetObject(_tFrm.unit[_FMAIN],oUnit)
--				hApi.SetObject(_tFrm.unit[_FEX],oTarget)
--				hGlobal.UI.TeamFrameBG:show(1)
--				hGlobal.UI.TeamFrameBG:active()
--				_frmCommon:show(1)
--				_frmCommon:active()
--				_frmEx:show(1)
--				_frmEx:active()
--				local baseX,baseY = 0,0
--				if hGlobal.UI.HeroFrame then
--					baseX,baseY = hGlobal.UI.HeroFrame.data.x,hGlobal.UI.HeroFrame.data.y
--				end
--
--				local teamGrid = _frmCommon.childUI["teamGrid"]
--				local posX = oHero.heroUI["btnIcon"].data.x + baseX - oHero.heroUI["btnIcon"].data.w/2-4
--				local posY = oHero.heroUI["btnIcon"].data.y + baseY
--				_frmCommon:setXY(posX-_GridColNum*teamGrid.data.gridW,posY+teamGrid.data.gridH/2)
--				teamGrid:updateitem(oUnit.data.team)
--				teamGrid:fadein(0.25,180,0)
--
--				local teamGrid = _frmEx.childUI["teamGrid"]
--				local posX = oHeroEx.heroUI["btnIcon"].data.x + baseX - oHero.heroUI["btnIcon"].data.w/2-4
--				local posY = oHeroEx.heroUI["btnIcon"].data.y + baseY
--				_frmEx:setXY(posX-_GridColNum*teamGrid.data.gridW,posY+teamGrid.data.gridH/2)
--				teamGrid:updateitem(oTarget.data.team)
--				teamGrid:fadein(0.25,180,0)
--			end
--		end
--	end)
--
--	hGlobal.event:listen("LocalEvent_TeamChange","__callback__TeamFrameChange",function(mode,oUnit,nParam1,nParam2)
--		for i = 1,#_tFrm do
--			if _tFrm[i].data.show==1 and hApi.GetObject(_tFrm.unit[i])==oUnit then
--				local teamGrid = _tFrm[i].childUI["teamGrid"]
--				if mode=="shift" and nParam1 and nParam2 then
--					local gx,gy,tx,ty
--					local c,t = teamGrid.data.gIndex[nParam1],teamGrid.data.gIndex[nParam2]
--					if type(c)=="table" and type(t)=="table" then
--						teamGrid:shift(c[1],c[2],t[1],t[2])
--					else
--						teamGrid:updateitem(oUnit.data.team)
--					end
--				else
--					teamGrid:updateitem(oUnit.data.team)
--				end
--				--玩家移动过单位后的隐藏升级和分兵按钮
--				if i == _FTOWN then
--					
--				end
--			end
--		end
--		--购买单位时如果 主城有守卫
--		local oTown = hApi.GetObject(_tFrm.unit[_FTOWN])
--		if oTown then
--			local TownData = oTown:gettown()
--			if TownData then
--				local gU = TownData:getunit("guard")
--				if oUnit == gU and gU then
--					_frmTown.childUI["teamGrid"]:updateitem(gU.data.team)
--				end
--			end
--		end
--	end)
--
--	--初始化背包点击事件
--	for i = 1,#_tFrm do
--		local v = _tFrm[i]
--		local _code = v.childUI["dragBox"].data.codeOnTouch
--		if type(_code)~="function" then
--			_code = hApi.DoNothing
--		end
--		local _tUnit = _tFrm.unit[i]
--		local _teamGrid = v.childUI["teamGrid"]
--		v.childUI["dragBox"].data.codeOnTouch = function(x,y,screenX,screenY)
--			local oUnit = hApi.GetObject(_tUnit)
--			if oUnit==nil or oUnit.data.team==0 then
--				return hVar.RESULT_FAIL
--			end
--			if _teamGrid:selectitem(x,y,screenX,screenY) then
--				return hVar.RESULT_FAIL
--			else
--				return _code(x,y)
--			end
--		end
--	end
--	--遣散英雄的主界面
--
--	local DisbandFram = hUI.frame:new({
--		x = 300,
--		y = 500,
--		show = 0,
--		w = 480,
--		h = 330,
--	})
--
--	--确定按钮
--	DisbandFram.childUI["btnOk"] = hUI.button:new({
--		parent = DisbandFram.handle._n,
--		dragbox = DisbandFram.childUI["dragBox"],
--		model = "UI:BTN_ButtonRed",
--		label = hVar.tab_string["__TEXT_Confirm"],
--		align = "MC",
--		scaleT = 0.9,
--		x = DisbandFram.data.w/2 + 80,
--		y = -DisbandFram.data.h+56,
--		code = function(self)
--			
--		end,
--	})
--
--	--取消按钮
--	DisbandFram.childUI["btnCancel"] = hUI.button:new({
--		parent = DisbandFram.handle._n,
--		dragbox = DisbandFram.childUI["dragBox"],
--		model = "UI:BTN_ButtonRed",
--		label = hVar.tab_string["__TEXT_Cancel"],
--		align = "MC",
--		scaleT = 0.9,
--		x = DisbandFram.data.w/2 - 80,
--		y = -DisbandFram.data.h+56,
--		code = function(self)
--			DisbandFram:show(0,"appear")
--		end,
--	})
--
--	DisbandFram.childUI["thumbImage_back"] = hUI.image:new({
--		parent = DisbandFram.handle._n,
--		model =  "UI_frm:slot",
--		animation = "lightSlim",
--		x = 85,
--		y = -85,
--		w = 72,
--		h = 72,
--	})
--
--	--提示性文字
--	DisbandFram.childUI["label"] = hUI.label:new({
--		parent = DisbandFram.handle._n,
--		text = "",
--		x = DisbandFram.data.w/2,
--		y = -40,
--		width = DisbandFram.data.w-36,
--		align = "MT",
--		size = 28,
--		font = hVar.FONTC,
--	})
--
--	local RemoveList = {}
--	local _createDisbandFram = function (DisbandInfo)
--		for i = 1,#RemoveList do
--			hApi.safeRemoveT(DisbandFram.childUI,RemoveList[i])
--		end
--		RemoveList = {}
--
--		local uId,uNum, teamOldPos= DisbandInfo.item[1],DisbandInfo.item[2],DisbandInfo.item[3]
--		local tabU = hApi.GetTableValue(hVar.tab_unit,uId)
--
--		DisbandFram.childUI["btnOk"].data._code = function()
--			hGlobal.LocalPlayer:order(DisbandInfo.oUnit:getworld(),hVar.OPERATE_TYPE.TEAM_SHIFT,DisbandInfo.oUnit,{teamOldPos,-1},nil,0,0)
--			DisbandFram:show(0,"appear")
--		end
--		
--		local uicon = hVar.tab_unit[DisbandInfo.oUnit.data.id].icon
--		if uicon == nil then
--			DisbandFram.childUI["townObj"] = hUI.thumbImage:new({
--				parent = DisbandFram.handle._n,
--				x = 85,
--				y = -85,
--				w = 72,
--				h = 72,
--				id = DisbandInfo.oUnit.data.id,
--			})
--			RemoveList[#RemoveList+1] = "townObj"
--		else
--			--英雄头像
--			DisbandFram.childUI["thumbImage_main"] = hUI.image:new({
--				parent = DisbandFram.handle._n,
--				model =  uicon,
--				x = 85,
--				y = -85,
--				w = 72,
--				h = 72,
--			})
--			RemoveList[#RemoveList+1] = "thumbImage_main"
--		end
--
--		local text = hVar.tab_string["__TEXT_Disband"]..hVar.tab_stringU[uId][1].."("..uNum..") ?"
--
--		DisbandFram.childUI["label"]:setText(text)
--
--		local grid = {}
--		grid[1] = 0
--		DisbandFram.childUI["image__"] = hUI.bagGrid:new({
--			parent = DisbandFram.handle._n,
--			x =  DisbandFram.data.w/2,
--			y =  -DisbandFram.data.h/2,
--			tab = hVar.tab_unit,
--			tabModelKey = "model",
--			animation = function(id,model)
--				return hApi.animationByFacing(model,"stand",180)
--			end,
--			iconW = 64,
--			iconH = 64,
--			gridW = 68,
--			gridH = 68,
--			centerY = -8,
--			smartWH = 1,
--			num = {font = "numWhite",size = -1,y=4},
--			slot = {model = "UI_frm:slot",animation = "lightSlim"},
--			grid = grid,
--			item = {{uId,uNum}},
--		})
--		RemoveList[#RemoveList+1] = "image__"
--
--		DisbandFram:show(1,"fade",{time=0.08})
--		DisbandFram:active()
--	end
--	
--
--	local __ReleaseTeamUnit = function(oUnit,item)
--		local teamOldPos = item[3]
--		local uId,uNum = item[1],item[2]
--		local tabU = hApi.GetTableValue(hVar.tab_unit,uId)
--		local uModel = tabU.model or "MODEL:default"
--		local MsgSelections = {
--			select = 0,
--			ok = 1,
--			cancel = 1,
--			style = "normal",
--			{model = uModel,num = uNum,animation = hApi.animationByFacing(uModel,"stand",180)},
--		}
--		local DisbandInfo = {
--			oUnit = oUnit,
--			item = item,
--		}
--		--if uId==oUnit.data.id then
--		if tabU.type==hVar.UNIT_TYPE.HERO then
--			_DEBUG_MSG("不能遣散英雄")
--		else
--			_createDisbandFram(DisbandInfo)
--			--local confirmText = "你要遣散部队:\n"..tostring(tabU.name).."("..uNum..") 吗?"
--			--local msgBox = hGlobal.UI.MsgBox(confirmText,MsgSelections,function()
--			--	--遣散部队命令
--			--	hGlobal.LocalPlayer:order(oUnit:getworld(),hVar.OPERATE_TYPE.TEAM_SHIFT,oUnit,{teamOldPos,-1},nil,0,0)
--			--end)
--			--msgBox:active()
--			--msgBox:show(1,"fade",{time=0.08})
--
--		end
--	end
--
--	--------------------------------------------------------------------
--	--name:		IsShowUpdateImage
--	--parameter:	self:	用于判断兵属于哪个军队表中的兵
--	--		id:	兵的id
--	--function:	判断是否需要升级兵或武器
--	--Created by:	pangyong 2015/3/31
--	--------------------------------------------------------------------
--	local IsShowUpdateImage = function(self, id)
--		local bool   = false
--		local toUnit = hApi.GetObject( hGlobal.UI.TeamFrame.unit[1])
--
--		--判断兵属于哪个军队表中（战斗损失军队表中不需要添加升级图标）
--		if self == hGlobal.UI.TeamFrame[1].childUI["teamGrid"] then							--当前这个兵或武器在 主公军队表中
--			toUnit = hApi.GetObject( hGlobal.UI.TeamFrame.unit[1])
--		elseif self == hGlobal.UI.TeamFrame[2].childUI["teamGrid"] then							--友军的队列
--			toUnit = hApi.GetObject( hGlobal.UI.TeamFrame.unit[2])
--		elseif self == hGlobal.UI.TeamFrame[3].childUI["teamGrid"] then
--			toUnit = hApi.GetObject( hGlobal.UI.TeamFrame.unit[3])							--当前这个兵或武器在 城墙军队表中
--		end
--	 
--		if type(id) == "number" and toUnit and hApi.CheckIfArmyHaveUpgrade(id)==1 then					--增加对toUnit的判断，防止升级建筑时，还没有打开过主军队的军队列表，以致toUint为nil
--			local oHero = toUnit:gethero()
--			local oTown
--			if oHero~=nil then
--				oTown = toUnit:getvisit()
--			else
--				oTown = toUnit:gettown()
--			end
--			--判断是否在主城内
--			if oTown and toUnit.data.type~=hVar.UNIT_TYPE.HERO then
--				local oGuard = oTown:getunit("guard")
--				if oGuard then
--					toUnit = oGuard
--				end
--			end
--			--判断英雄是否可以升级兵种
--			if toUnit.data.type==hVar.UNIT_TYPE.HERO then
--				if hApi.CheckIfCanUpgradeArmyByHero(oHero,id)~=0 then	--判断主公是否满足，升级所需要的所有条件
--					bool = true
--				end
--			end
--			--判断主城是否可以升级兵种
--			if oTown~=nil then
--				if hApi.CheckIfCanUpgradeArmyByTown(oTown,id)~=0 then
--					bool = true
--				end
--			end
--		end	
--		return bool
--	end
--	
--	_UpdateImageUpdate = function(self, tItem, nCount, sItemName,gx,gy)
--		local d = self.data
--		local _childUI = self.childUI
--		local oItemC = d.item[nCount]
--		d.uiExtra = {"UpdataImage"}											--利用这个表进行索引的设定，在刷新时可以按照既存代码即可清除已经创建的内容
--		local sItemName1 = "UpdataImage"..gx.."|"..gy
--		local x, y = self:grid2xy(gx,gy)										--将网格位置转为相应的坐标
--		--创建升级图标	
--		if _childUI[sItemName1] == nil then					
--			--升级图标(有兵就有升级提示，是否显示，则另外判断)
--			_childUI[sItemName1] = hUI.image:new({
--				parent	= self.handle._n,
--				model	= "ICON:image_update",
--				x = x + d.numX - 58,
--				y = y + d.numY + 56,
--				w = 15,
--				h = 15,
--				z = 1,
--			})
--		end
--
--		--刷新升级图标
--		if IsShowUpdateImage(self, oItemC[hVar.ITEM_DATA_INDEX.ID]) then									--检查是否能升级本兵种
--			_childUI[sItemName1].handle._n:setVisible(true)								--设置选择框可视
--		else
--			_childUI[sItemName1].handle._n:setVisible(false)							--设置选择框不可视
--		end
--	end
--
--	__callback__DropTeamUnit = function(self,item,relX,relY,screenX,screenY,Sprite,lasttime)
--		local fromUnit,toUnit,fromPos,toPos
--		local teamGridIndex = 0
--		local oWorld = hGlobal.LocalPlayer:getfocusworld()
--		if oWorld and oWorld.worldUI["GUIDE_UI"] then
--			local sGuideMode = oWorld.worldUI["GUIDE_UI"].data.mode
--			local pCode = oWorld.worldUI["GUIDE_UI"].data.code
--			if sGuideMode=="GUIDE:DropTeamUnit" and type(pCode)=="function" then
--				if pCode(screenX,screenY)~=hVar.RESULT_SUCESS then
--					return
--				end
--			end
--		end
--		if item and item~=0 then
--			for i = 1,#_tFrm do
--				local v = _tFrm[i]
--				local g = v.childUI["teamGrid"]
--				local oUnit = hApi.GetObject(_tFrm.unit[i])
--
--				if g==self then
--					fromUnit = oUnit
--					--如果城里有守卫的时候...
--					local TownData = fromUnit:gettown()
--					if TownData then
--						local gU = TownData:getunit("guard")
--						if gU then
--							fromUnit = gU
--						end
--					end
--
--					fromPos = item[3]
--					teamGridIndex = i
--				end
--				if v.data.show==1 then
--					local x = screenX-v.data.x-g.data.x+g.data.gridW/2
--					local y = screenY-v.data.y-g.data.y-g.data.gridH/2
--					local gx,gy = g:xy2grid(x,y,"parent")
--					if gx and gy then
--						toUnit = oUnit
--						
--						toPos = g.data.gIndex[gx.."|"..gy]
--					end
--				end
--				if fromUnit and toUnit and fromPos and toPos then
--					break
--				end
--			end
--			if fromUnit and toUnit and fromPos and toPos then
--				--如果城里有守卫的时候...
--				local oHero = toUnit:gethero()
--				local oTown
--				if oHero~=nil then
--					oTown = toUnit:getvisit()
--				else
--					oTown = toUnit:gettown()
--				end
--				--我是城。。。
--				if oTown~=nil and oHero==nil then
--					local oUnitG = oTown:getunit("guard")
--					if oUnitG then
--						toUnit = oUnitG
--						oHero = oUnitG:gethero()
--					end
--				end
--
--				if fromUnit==toUnit then
--					--在自己身上换兵
--					print("交换单位(自己)",toUnit.handle.name,(fromUnit or toUnit).handle.name)
--					hGlobal.LocalPlayer:order(toUnit:getworld(),hVar.OPERATE_TYPE.TEAM_SHIFT,fromUnit,{fromPos,toPos},nil,0,0)
--					fromUnit = nil
--				else
--					--两个单位换兵
--					local tabU = hApi.GetTableValue(hVar.tab_unit,item[1])
--					--if (fromUnit and item[1]==fromUnit.data.id) or (toUnit and item[1]==toUnit.data.id)  then
--						--_DEBUG_MSG("不能上下调换英雄")
--						--return
--					--end
--					if hVar.tab_unit[fromUnit.data.team[fromPos][1]].type == 2 then
--						print("不能交换将领")
--						return 
--					end
--
--					if toUnit.data.team[toPos] ~= 0 and hVar.tab_unit[toUnit.data.team[toPos][1]].type==2 then
--						local sus = 0
--						for i = 1,#toUnit.data.team do
--							if toUnit.data.team[i]==0 then
--								toPos = i
--								sus = 1
--								break
--							end
--						end
--						if sus==1 then
--							print("拖动普通单位到英雄身上，位置转换为"..toPos)
--						else
--							return
--						end
--					end
--					
--					print("交换单位(友军)",toUnit.handle.name,(fromUnit or toUnit).handle.name)
--					--交换单位的两个英雄距离不能过远
--					if fromUnit.data.type==hVar.UNIT_TYPE.HERO and toUnit.data.type==hVar.UNIT_TYPE.HERO then
--						local cx,cy = fromUnit:getXY()
--						local tx,ty = toUnit:getXY()
--						if ((cx-tx)^2+(cy-ty)^2)>10000 then
--							print("交换单位的英雄距离过远")
--							return
--						end
--					end
--					hGlobal.LocalPlayer:order(toUnit:getworld(),hVar.OPERATE_TYPE.TEAM_SHIFT,fromUnit,{fromPos,toPos},toUnit,0,0)
--					hApi.RefreshCombatScore(fromUnit)
--					hApi.RefreshCombatScore(toUnit)
--				end
--
--				--点击命令 且只有在主城栏上点击(点击 城内兵)
--				if fromPos == toPos and toUnit.data.type == hVar.UNIT_TYPE.BUILDING and  fromUnit == nil then
--					--显示分兵按钮
--					if toUnit.data.team[fromPos] ~= 0 then
--						--显示操控面板用的grid
--						local grid = {}
--						local msg = {}
--						local id = toUnit.data.team[fromPos][1]
--						local num = toUnit.data.team[fromPos][2]
--
--						if hVar.tab_unit[id].type == 1 and num > 1 then
--							grid[#grid+1] = hVar.INTERACTION_TYPE.PartArmy
--							msg[#msg+1] = {
--								key = hVar.INTERACTION_TYPE.PartArmy,
--								index = fromPos,
--								teamGridIndex = teamGridIndex,
--							}
--						end
--
--						--显示升级按钮
--						if hApi.CheckIfArmyHaveUpgrade(id)~=0 then
--							local sus = 0
--							if oTown and hApi.CheckIfCanUpgradeArmyByTown(oTown,id)~=0 then
--								sus = 1
--							elseif oHero and hApi.CheckIfCanUpgradeArmyByHero(oHero,id)~=0 then
--								sus = 1
--							end
--							if sus==1 then
--								grid[#grid+1] = hVar.INTERACTION_TYPE.UpgradeArmy
--								msg[#msg+1] = {
--									key = hVar.INTERACTION_TYPE.UpgradeArmy,
--									index = fromPos,
--									UnitID = id,
--									UnitNum = num,
--									teamGridIndex = teamGridIndex,
--								}
--							end
--						end
--
--						--给所有传入的grid末尾加入 详细信息按钮
--						grid[#grid+1] = hVar.INTERACTION_TYPE.DETAIL
--						msg[#msg+1] = {
--							key = hVar.INTERACTION_TYPE.DETAIL,
--							id = id,
--							unit = toUnit,
--						}
--						
--						--hGlobal.UI.TeamFrameBG:show(0)							--changed by pangyong 2015/4/13
--						if lasttime < 1 then 
--							local x = _frmTown.data.x+20*(3-#grid)+(fromPos-1)*75 - 8
--							hGlobal.event:event("LocalEvent_ShowCtrlFrm",grid,x,100,toUnit,msg)
--						end
--
--					end
--				elseif fromPos == toPos and toUnit.data.type == hVar.UNIT_TYPE.HERO and fromUnit == nil then
--					--显示操控面板用的grid
--					local grid = {}
--					local msg = {}
--					local id = toUnit.data.team[fromPos][1]
--					local num = toUnit.data.team[fromPos][2]
--
--					--是否显示分兵按钮
--					if hVar.tab_unit[id].type == 1 and num > 1 then
--						grid[#grid+1] = hVar.INTERACTION_TYPE.PartArmy
--						msg[#msg+1] = {
--							key = hVar.INTERACTION_TYPE.PartArmy,
--							index = fromPos,
--							teamGridIndex = teamGridIndex,
--						}
--					end
--
--					--显示升级按钮
--					if hApi.CheckIfArmyHaveUpgrade(id)~=0 then
--						local sus = 0
--						if oTown and hApi.CheckIfCanUpgradeArmyByTown(oTown,id)~=0 then
--							sus = 1
--						elseif oHero and hApi.CheckIfCanUpgradeArmyByHero(oHero,id)~=0 then
--							sus = 1
--						end
--						if sus==1 then
--							grid[#grid+1] = hVar.INTERACTION_TYPE.UpgradeArmy
--							msg[#msg+1] = {
--								key = hVar.INTERACTION_TYPE.UpgradeArmy,
--								index = fromPos,
--								UnitID = id,
--								UnitNum = num,
--								teamGridIndex = teamGridIndex,
--							}
--						end
--					end
--
--					--给所有传入的grid末尾加入 详细信息按钮
--					grid[#grid+1] = hVar.INTERACTION_TYPE.DETAIL
--					msg[#msg+1] = {
--						key = hVar.INTERACTION_TYPE.DETAIL,
--						id = id,
--						unit = toUnit,
--					}
--
--					if lasttime < 1 then 
--						--changed by pangyong 2015/4/2
--						hGlobal.UI.TeamFrameBG:show(0)
--
--						local x
--						if self == hGlobal.UI.TeamFrame[_FTOWN].childUI["teamGrid"] then				--当前这个兵或武器在 城墙军队表中
--							x = _frmTown.data.x + 20*(3-#grid) + (fromPos-1)*75 - 8					--根据兵所在的位置设定点击兵种后弹出框的x坐标
--						else
--							x = _frmCommon.data.x + 20*(3-#grid) + (fromPos-1)*75 - 8
--						end
--						local tempy = oHero.heroUI["btnIcon"].data.y + hVar.SCREEN.h - 115				--设置弹出框的y坐标
--						local oWorld = hGlobal.LocalPlayer:getfocusworld()
--						if oTown and oWorld and oWorld.data.type=="town" then
--							local oUnitG = oTown:getunit("guard")
--							local oUnitV = oTown:getunit("visitor")
--							--当城中只有 守卫英雄时
--							if oUnitV and oUnitG == nil then
--								tempy = 190
--							elseif oUnitG and teamGridIndex == 1 then
--								tempy = 190
--							end
--							if teamGridIndex == 3 then
--								tempy = 100
--							end
--						end
--						hGlobal.event:event("LocalEvent_ShowCtrlFrm",grid,x,tempy,toUnit,msg)
--					end
--				end
--			elseif fromUnit then
--				__ReleaseTeamUnit(fromUnit,item)
--			end
--		end
--	end
--	hGlobal.event:listen("LocalEvent_CtrlFrmClose","__close",function()
--		local w = hGlobal.LocalPlayer:getfocusworld()
--		if w.data.type == "worldmap" then
--			hGlobal.UI.TeamFrameBG:show(1)
--		end
--	end)
--	
--	--分兵
--	hGlobal.event:listen("LocalEvent_PartArmy","PartArmy",function(oWorld,oUnit,frmIndex)
--		local w = hGlobal.LocalPlayer:getfocusworld()
--		hApi.PlaySound("army")
--		if w.data.type == "worldmap" then
--			hGlobal.UI.TeamFrameBG:show(1)
--		end
--		_tFrm[frmIndex].childUI["teamGrid"]:updateitem(oUnit.data.team)
--	end)
--	hGlobal.event:listen("LocalEvent_PartArmy_close","PartArmy_close",function(oWorld,oUnit,frmIndex)
--		local w = hGlobal.LocalPlayer:getfocusworld()
--		if w.data.type == "worldmap" then
--			hGlobal.UI.TeamFrameBG:show(1)
--		end
--	end)
--	--兵种升级的具体逻辑
--	hGlobal.event:listen("LocalEvent_UpgradeArmy","UpgradeArmy",function(oWorld,oUnit,frmIndex)
--		local w = hGlobal.LocalPlayer:getfocusworld()
--		hApi.PlaySound("army")
--		if w.data.type == "worldmap" then
--			hGlobal.UI.TeamFrameBG:show(1)
--		end
--		_tFrm[frmIndex].childUI["teamGrid"]:updateitem(oUnit.data.team)
--	end)
--
--	hGlobal.event:listen("LocalEvent_UpgradeArmy_close","UpgradeArmy_close",function()
--		local w = hGlobal.LocalPlayer:getfocusworld()
--		if w.data.type == "worldmap" then
--			hGlobal.UI.TeamFrameBG:show(1)
--		end
--	end)
--	
--	hGlobal.event:listen("LocalEvent_UnitInfo_close","UnitInfo_close",function()
--		local w = hGlobal.LocalPlayer:getfocusworld()
--		if w and w.data.type == "worldmap" then
--			hGlobal.UI.TeamFrameBG:show(1)
--		end
--	end)
--end
--
----胜利面板
--hGlobal.UI.InitVictoryFrame = function()
--	local __AddUnitGrid = function(frm,x,y,units,name,text,slot)
--		local _IWH,_GWH = 60,64
--		local _fontSize = 28
--		local grid = {}
--		for i = 1,#units do
--			grid[#grid+1] = 0
--		end
--		
--		frm.childUI["label"..name] = hUI.label:new({
--			parent = frm.handle._n,
--			x = x+50,
--			y = y,
--			text = text,
--			size = _fontSize,
--			align = "MC",
--			border = 1,
--			font = hVar.FONTC,
--		})
--		if #grid==0 then
--			--grid[1] = 1
--			frm.childUI["perfect"..name] = hUI.label:new({
--				parent = frm.handle._n,
--				x = 380,
--				y = y,
--				text = hVar.tab_string["__TEXT_perfect"],
--				size = _fontSize,
--				align = "MC",
--				border = 1,
--				font = hVar.FONTC,
--			})
--			return 
--		end
--
--		frm.childUI["image"..name] = hUI.bagGrid:new({
--			parent = frm.handle._n,
--			x = x + 110,--x-_GWH*(#grid-1)/2,
--			y = y,
--			animation = -1,
--			iconW = _IWH,
--			iconH = _IWH,
--			gridW = _GWH,
--			gridH = _GWH,
--			centerY = -8,
--			smartWH = 1,
--			num = {font = "numWhite",size = -1,x=-35,y=6},
--			slot = slot,
--			grid = grid,
--			item = units,
--			codeOnImageCreate = function(self,id,pNode,gridX,gridY)
--				local w,h = hApi.GetUnitImageWH(id,_IWH,_IWH)
--				hUI.deleteUIObject(hUI.thumbImage:new({
--					parent = pNode,
--					id = id,
--					w = w,
--					h = h,
--					smartWH = 1,
--					facing = 180,
--				}))
--			end,
--		})
--	end
--	local __CalculateLootExp = function(tLoot)
--		local r = 0
--		if tLoot then
--			for i = 1,#tLoot do
--				if tLoot[i][1]=="attr" and tLoot[i][2]=="exp" then
--					r = r + tLoot[i][3]
--				end
--			end
--		end
--		return r
--	end
--	local __AddLogUI = function(frm,oUnitD,nExpGet,tLostUnits,tKillUnits,roundcount,BattlefieldType,Target,isVictory,oDefeatHero)
--		local HeroId = 0
--		local HeroIcon = ""
--		local HeroName = ""
--		if oDefeatHero and (Target == 0 or Target == nil or oUnitD == Target) then 
--			Target = oDefeatHero 
--		end
--		local EnemyHeroIcon = hVar.tab_unit[Target.data.id].icon
--		local EnemyName = hVar.tab_stringU[Target.data.id][1]
--		local panimation = "normal"
--		local imageX,imageY = 72,-345
--		local pmode = "model"
--		local palign = "LT"
--
--		if oUnitD~=nil then
--			local oHero = oUnitD:gethero()
--			if oHero~=nil then
--				HeroId = oHero.data.id
--				HeroIcon = oHero.data.icon
--				HeroName = hVar.tab_stringU[HeroId][1]
--			else
--				HeroId = 0
--				HeroIcon = hApi.GetTableValue(hVar.tab_unit,oUnitD.data.id).model or ""
--				if HeroIcon == "" then
--					local thumbPath = hApi.GetImagePath("icon/xlobj/"..oUnitD.handle.xlPath..".png")
--					HeroIcon = hApi.FileExists(thumbPath) and thumbPath or hApi.GetFilePath("xlobj/"..oUnitD.handle.xlPath..".png")
--					pmode = "file"
--					palign = "MC"
--				end
--				HeroName = hVar.tab_stringU[oUnitD.data.id][1]
--			end
--		end
--		
--		--如果胜利则从损失表中去掉英雄
--		if (isVictory == 1) then
--			local templist = tLostUnits
--			for i = 1,#templist do
--				if templist[i][1] == HeroId then
--					templist[i] = 0
--				end
--			end
--			tLostUnits = {}
--			for i = 1,#templist do
--				if templist[i] ~= 0 then
--					tLostUnits[#tLostUnits+1] = templist[i]
--				end
--			end
--		else
--			--如果输掉 且损失列表中有 主城 则清除掉
--			local templist = tLostUnits
--			for i = 1,#templist do
--				if hVar.tab_unit[templist[i][1]].type == 3 then
--					templist[i] = 0
--				end
--			end
--			tLostUnits = {}
--			for i = 1,#templist do
--				if templist[i] ~= 0 then
--					tLostUnits[#tLostUnits+1] = templist[i]
--				end
--			end
--			
--			--如果是攻城战 且输掉 则将守城英雄的team 变为损失列表
--			local tempT = oUnitD:gettown()
--			if tempT then
--				local gu = tempT:getunit("guard")
--				if gu then
--					tLostUnits = {}
--					for k,v in pairs(gu.data.team) do
--						if type(v) == "table" then
--							tLostUnits[#tLostUnits+1] = v
--						end
--					end
--				end
--			end
--		end
--		
--		frm.childUI["imageHeroIconbg0"] = hUI.image:new({
--			parent = frm.handle._n,
--			model = "UI:slotBig",
--			animation = "lightSlim",
--			--w = 78,
--			--h = 78,
--			x = 72,
--			y = -84,
--		})
--		
--		frm.childUI["imageHeroIcon"] = hUI.image:new({
--			parent = frm.handle._n,
--			x = 72,
--			y = -84,
--			w = 72,
--			h = 72,
--			smartWH = 1,
--			model = HeroIcon,
--			mode = pmode,
--			align = palign,
--		})
--		
--		--战斗评价
--		frm.childUI["CombatEvaluation"] = hUI.label:new({
--			parent = frm.handle._n,
--			x = 130,
--			y = -110,
--			--text = hVar.tab_string["__TEXT_CombatEvaluation"],
--			text = hVar.tab_string["PVPFightMark"],--..hVar.tab_string["ios_score"],
--			size = 30,
--			--align = "MC",
--			border = 1,
--			font = hVar.FONTC,
--		})
--		
--		--自己的英雄图标
--		frm.childUI["imageHeroIconbg"] = hUI.image:new({
--			parent = frm.handle._n,
--			model = "UI:slotBig",
--			animation = "lightSlim",
--			--w = 78,
--			--h = 78,
--			x = 72,
--			y = -231,
--		})
--
--		frm.childUI["imageHeroIconbig"] = hUI.image:new({
--			parent = frm.handle._n,
--			x = 72,
--			y = -231,
--			w = 72,
--			h = 72,
--			smartWH = 1,
--			model = HeroIcon,
--			mode = pmode,
--			align = palign,
--		})
--		
--		frm.childUI["heroNmae"] = hUI.label:new({
--			parent = frm.handle._n,
--			x = 74,
--			y = -285,
--			text = HeroName,
--			size = 26,
--			font = hVar.FONTC,
--			align = "MC",
--			border = 1,
--		})
--		
--		--战斗回合数
--		frm.childUI["CombatEvaluation"] = hUI.label:new({
--			parent = frm.handle._n,
--			x = 70,
--			y = -440,
--			text = hVar.tab_string["__TEXT_Roundcount"],
--			size = 26,
--			--align = "MC",
--			border = 1,
--			font = hVar.FONTC,
--			width = 300,
--		})
--			
--			frm.childUI["GetScore1"] = hUI.label:new({
--				parent = frm.handle._n,
--				x = 220,
--				y = -440,
--				text = roundcount,
--				size = 26,
--				--align = "MC",
--				border = 1,
--				font = hVar.FONTC,
--				width = 300,
--			})
--
--		--攻城战
--		if Target.data.type == 3 then
--			local gu = Target:gettown():getunit("guard")
--			if gu then
--				EnemyHeroIcon =  hVar.tab_unit[gu.data.id].icon
--				EnemyName = hVar.tab_stringU[gu.data.id][1]
--			elseif Target.handle.__manager == "xlobj" then
--				local thumbPath = hApi.GetImagePath("icon/xlobj/"..Target.handle.xlPath..".png")
--				EnemyHeroIcon = hApi.FileExists(thumbPath) and thumbPath or hApi.GetFilePath("xlobj/"..Target.handle.xlPath..".png")
--				pmode = "file"
--				palign = "MC"
--			else
--
--			end
--		end
--		--普通单位
--		if hVar.tab_unit[Target.data.id].type == 1 then
--			EnemyHeroIcon = hVar.tab_unit[Target.data.id].model
--			panimation = hApi.animationByFacing(EnemyHeroIcon,"stand",180)
--			imageY = -361
--			pmode = "model"
--			palign = "LT"
--		end
--		--是英雄 
--		if hVar.tab_unit[Target.data.id].type == 2 then
--			if hVar.tab_unit[Target.data.id].icon then
--				EnemyHeroIcon = hVar.tab_unit[Target.data.id].icon
--				pmode = "model"
--				palign = "LT"
--				panimation = "normal"
--			else
--				EnemyHeroIcon = hVar.tab_unit[Target.data.id].model
--				imageY = -361
--				pmode = "model"
--				palign = "LT"
--				panimation = hApi.animationByFacing(EnemyHeroIcon,"stand",180)
--			end
--		end
--		--敌人武将背景底图 头像
--		frm.childUI["imageHeroIconbg1"] = hUI.image:new({
--			parent = frm.handle._n,
--			model = "UI:slotBig",
--			animation = "lightSlim",
--			--w = 78,
--			--h = 78,
--			x = 72,
--			y = -341,
--			RGB = {255,255,255},
--		})
--
--		frm.childUI["imageHeroIconbig1"] = hUI.image:new({
--			parent = frm.handle._n,
--			x = imageX,
--			y = imageY+4,
--			w = 72,
--			h = 72,
--			smartWH = 1,
--			model = EnemyHeroIcon,
--			animation = panimation,
--			mode = pmode,
--			align = palign,
--		})
--
--		frm.childUI["heroNmae1"] = hUI.label:new({
--			parent = frm.handle._n,
--			x = 74,
--			y = -397,
--			text = EnemyName,
--			size = 26,
--			font = hVar.FONTC,
--			align = "MC",
--			border = 1,
--		})
--
--		if BattlefieldType ~= 0 and isVictory == 1 then
--			local oTown = hClass.town:find(BattlefieldType)
--			local TownUnit = oTown:getunit()
--			local text = ""
--
--			if oUnitD.data.type == 2 then
--				text = hVar.tab_string["__TEXT_Get"]
--			elseif oUnitD.data.type == 3 then
--				text = hVar.tab_string["__TEXT_Keep"]
--			end
--
--			frm.childUI["get"] = hUI.label:new({
--				parent = frm.handle._n,
--				x = 490,
--				y = -70,
--				align = "MC",
--				text = text,
--				font = hVar.FONTC,
--				RGB = {100,255,0},
--				size = 34,
--				border = 1,
--			})
--
--			local townName =  hApi.GetUnitName(TownUnit)
--			frm.childUI["TownName"] = hUI.label:new({
--				parent = frm.handle._n,
--				x = 545,
--				y = -130,
--				text = townName,
--				font = hVar.FONTC,
--				size = 26,
--				border = 1,
--			})
--
--			frm.childUI["Townbg"] = hUI.image:new({
--				parent = frm.handle._n,
--				model = "UI:slotBig",
--				animation = "lightSlim",
--				--w = 80,
--				--h = 80,
--				x = 570,
--				y = -84,
--			})
--
--			frm.childUI["Town"] = hUI.thumbImage:new(
--			{
--				parent = frm.handle._n,
--				unit = TownUnit, --hVar.tab_unit[5000].icon,
--				w = 72,
--				h = 72,
--				x = 570,
--				y = -84,
--			})
--		end
--		--__AddUnitGrid(frm,100,-235,tLostUnits,"ArmyLost",hVar.tab_string["__TEXT_ArmyLost"],{model = "UI_frm:slot",animation = "lightSlim"})
--		--__AddUnitGrid(frm,100,-347,tKillUnits,"EnemyKilled",hVar.tab_string["__TEXT_EnemyKilled"],{model = "UI_frm:slot",animation = "lightSlim"})
--		__AddUnitGrid(frm,100,-235,tLostUnits,"ArmyLost",hVar.tab_string["__TEXT_ArmyLost"],{model = "UI:slotSmall",x = 0,y = 5})
--		__AddUnitGrid(frm,100,-347,tKillUnits,"EnemyKilled",hVar.tab_string["__TEXT_EnemyKilled"],{model = "UI:slotSmall",x = 0,y = 5})
--	end
--	local __AddTittleUI = function(frm,oUnitC,oUnitV,oUnitD,nStar,nScore)
--		if oUnitC==oUnitV then
--			--胜利
--			local victoryText
--			local oTown = oUnitC:gettown()
--			if oTown~=nil then
--				local oGuard = oTown:getunit("guard")
--				if oGuard~=nil then
--					victoryText = hApi.GetUnitName(oGuard)..hVar.tab_string["__VICTORY_TEXT__"]
--				else
--					victoryText = hApi.GetUnitName(oUnitC)..hVar.tab_string["__VICTORY_TEXT__"]
--				end
--			else
--				victoryText = hApi.GetUnitName(oUnitC)..hVar.tab_string["__VICTORY_TEXT__"]
--			end
--			frm.childUI["labelBattleResult"] = hUI.label:new({
--				parent = frm.handle._n,
--				x = frm.data.w/2-44,
--				y = -70,
--				align = "MC",
--				text = victoryText,
--				font = hVar.FONTC,
--				RGB = {100,255,0},
--				size = 34,
--				border = 1,
--			})
--		elseif oUnitC==oUnitD then
--			--失败
--			local defeatedText
--			local oTown = oUnitC:gettown()
--			if oTown~=nil then
--				local oGuard = oTown:getunit("guard")
--				if oGuard~=nil then
--					defeatedText = hApi.GetUnitName(oGuard)..hVar.tab_string["__DEFEATEED_TEXT__"].." , "..hApi.GetUnitName(oUnitC)..hVar.tab_string["__TOWN_DEFEATEED_TEXT__"]
--				else
--					defeatedText = hApi.GetUnitName(oUnitC)..hVar.tab_string["__TOWN_DEFEATEED_TEXT__"]
--				end
--			else
--				defeatedText =hApi.GetUnitName(oUnitC)..hVar.tab_string["__DEFEATEED_TEXT__"]
--			end
--			frm.childUI["labelBattleResult"] = hUI.label:new({
--				parent = frm.handle._n,
--				x = frm.data.w/2+10,
--				y = -70,
--				align = "MC",
--				text = defeatedText,
--				font = hVar.FONTC,
--				RGB = {100,255,0},
--				size = 34,
--				border = 1,
--			})
--		end
--		--胜利的时候显示评分(星星)
--		if oUnitC==oUnitV and type(nStar)=="number" then
--			local starX,starY = (frm.data.w/2) + 160 , -120
--			--评价星星的空槽
--			for i = 1,3 do
--				frm.childUI["star_slot_"..i]=hUI.image:new({
--					parent = frm.handle._n,
--					model = "UI:star_slot",
--					x =  285 + (i-1)*70,
--					y = -120,
--					w = 64,
--					h = 64,
--					scale = 0.9
--				})
--			end
--
--			local miniSta,maxStar ,starmini,starmax = nStar%2,math.ceil(nStar/2),"UI:star_half","UI:STAR_YELLOW"
--			for i = 1,maxStar do
--				--奇数
--				local model = starmax
--				if miniSta == 1 and i == maxStar then
--					model = starmini
--				end
--				
--				frm.childUI["star_"..i] = hUI.image:new({
--					parent = frm.handle._n,
--					model = model,
--					w = 64,
--					h = 64,
--					x = 0,
--					y = -700,
--					scale = 0.9,
--				})
--				
--				local config = ccBezierConfig:new()
--				config.controlPoint_1 = ccp(1024,0)     
--				config.controlPoint_2 = ccp(200,240)
--				config.endPosition = ccp(starX - 200 + (i-1)*70,starY)
--				frm.childUI["star_"..i].handle._n:runAction(CCBezierTo:create(0.5,config))
--			end
--			
--			if nScore > 0 then
--				--获得积分
--				frm.childUI["GetScore"] = hUI.label:new({
--					parent = frm.handle._n,
--					x = 70,
--					y = -480,
--					text = hVar.tab_string["__TEXT_GetScore"],
--					font = hVar.FONTC,
--					border = 1,
--					size = 26,
--					width = 300,
--				})
--					frm.childUI["GetScore1"] = hUI.label:new({
--						parent = frm.handle._n,
--						x = 220,
--						y = -480,
--						text = nScore,
--						font = hVar.FONTC,
--						border = 1,
--						size = 26,
--						width = 300,
--					})
--
--				for j = 1,#g_HeroWeekStar do
--					if oUnitV.data.id == g_HeroWeekStar[j][1] then
--						frm.childUI["double_score"] = hUI.image:new({
--							parent = frm.handle._n,
--							model = "ICON:WeekStar",
--							x = 300,
--							y = -490,
--						})
--					end
--				end
--
--			end
--
--		end
--	end
--
--	checkMadel = function(MedalID)--检测勋章是否点亮
--		if LuaGetPlayerMedal(hVar.MEDAL_TYPE[MedalID]) < 1 then--勋章没完成
--			local medal = hVar.tab_medal[MedalID]--勋章
--			if medal ~= nil then
--				if medal["conditions"] ~= nil then
--					local bLight = 0--是否点亮次勋章 采用累加 如果勋章要3个条件 最后bRight == 3才表示需要点亮
--					local bRight = {}--比如这个勋章有3个条件 {0,0,0} 当检测后变成{1,1,1}才表示通过
--					for i = 1,#medal["conditions"] do
--						local teamT = {}--清兵种表
--						local bigOrSmallT = {}--清大小关系表
--						local numberT = {}--清数量表
--						bRight[#bRight+1] = 0
--						local conditionsStr = medal["conditions"][i][1]--获得点亮要求
--						if conditionsStr == "killunit" then--累计击杀
--							local conditionNum = #medal["conditions"][i]
--							for j = 2,conditionNum do
--								if j%2 == 0 then
--									teamT[#teamT + 1] = medal["conditions"][i][j]--需要的哪些部队
--								elseif j%2 == 1 then
--									dealNumberRelT(medal["conditions"][i][j],bigOrSmallT,numberT)--大小关系 和比较数量
--								end
--							end
--							if type(hGlobal.WORLD.LastWorldMap.data.daykillcount) == "table" then
--								for j = 1,#teamT do
--									local mNum = 0
--									for k,v in pairs(hGlobal.WORLD.LastWorldMap.data.daykillcount) do
--										if v[1] == teamT[j] then
--											mNum = mNum + v[2]
--										end
--									end
--									if mNum + LuaGetPlayerCountVal("killunit",teamT[j]) >= numberT[j] then
--										bRight[#bRight] = 1
--									end
--								end
--							end
--						elseif conditionsStr == "forged" then
--							if LuaGetForgeCount() >= hVar.tab_medal[MedalID]["conditions"][1][2] then
--								bRight[#bRight] = 1
--								LuaSetPlayerMedal(hVar.MEDAL_TYPE[MedalID],1)
--							end
--						elseif conditionsStr == "diff" then
--							local difficultConditionStr = medal["conditions"][i][2]
--							dealNumberRelT(difficultConditionStr,bigOrSmallT,numberT)
--							bRight[#bRight] = bigSmallEqual(hGlobal.WORLD.LastWorldMap.data.MapDifficulty,numberT[1],bigOrSmallT[1])
--						elseif conditionsStr == "occupyCity" then
--							local cityStr = medal["conditions"][i][2]
--							dealNumberRelT(cityStr,bigOrSmallT,numberT)
--							local cityNum = #hGlobal.LocalPlayer.data.ownTown
--							bRight[#bRight] = bigSmallEqual(cityNum,numberT[1],bigOrSmallT[1])
--						end
--					end
--					for i = 1,#bRight do
--						bLight = bLight + bRight[i]
--					end
--					if bLight == #bRight then--点亮
--						LuaSetPlayerMedal(hVar.MEDAL_TYPE[MedalID],1)
--						--showBigMedalFrame(MedalID,1,1)
--						hGlobal.event:event("LocalEvent_showBigMedalFrame",MedalID,1,1)
--					end
--				end
--			end
--		end
--	end
--	---------------------------------------
--	--本地玩家参与的战场结束时弹出面板
--	hGlobal.event:listen("LocalEvent_BattlefieldResult","__BF_Result",function(oWorld,oUnitV,oUnitD,tLoot)
--		--不鸟快速战场
--		if oWorld.data.IsQuickBattlefield==1 then
--			return
--		end
--		--if hGlobal.LocalPlayer:getfocusworld()==oWorld then
--			--hGlobal.event:call("LocalEvent_PlayerLeaveBattlefield",hGlobal.LocalPlayer)
--		--end
--		local oUnitVx = hApi.GetBattleUnit(oUnitV)
--		local oUnitDx = hApi.GetBattleUnit(oUnitD)
--		local tgrDataDx
--		if oUnitDx~=nil then
--			tgrDataDx = oUnitDx:gettriggerdata()
--		end
--		local oUnitC,oUnitE,isVictory
--		local nAlly = hGlobal.LocalPlayer:allience(oUnitVx:getowner())
--		if nAlly==hVar.PLAYER_ALLIENCE_TYPE.OWNER or nAlly==hVar.PLAYER_ALLIENCE_TYPE.ALLY then
--			--胜利
--			hApi.PlaySoundBG(g_channel_battle,0)
--			hApi.PlaySound("battle_win")
--			oUnitC = oUnitV
--			oUnitE = oUnitD
--			isVictory = 1
--		else
--			--失败
--			hApi.PlaySoundBG(g_channel_battle,0)
--			hApi.PlaySound("battle_lose")
--			oUnitC = oUnitD
--			oUnitE = oUnitV
--			isVictory = 0
--		end
--		local resultTable = {select=0,style="normal",ok=hVar.tab_string["__TEXT_Confirm"]}
--		resultTable.codeOnExit = function()
--			if xlLuaEvent_Snapshot~=nil then
--				xlLuaEvent_Snapshot(2)
--			end
--			--hGlobal.event:event("LocalEvent_AfterBattlefieldClear",hGlobal.LocalPlayer)
--		end
--		local nExpGet = __CalculateLootExp(tLoot)
--		local idx,tLostUnits,tKillUnits,IsSurrender,roundcount,BattlefieldType,Target,nStar,nScore = hApi.CountKillAndLost(oWorld,oUnitC:getowner())
--		--记录当天击杀的单位 以及数量
--		if hGlobal.WORLD.LastWorldMap.data.daykillcount == nil then
--			hGlobal.WORLD.LastWorldMap.data.daykillcount = {}
--		end
--		--
--		for k,v in pairs(tKillUnits) do
--			local killID,killnum = unpack(v)
--			hGlobal.WORLD.LastWorldMap.data.daykillcount[#hGlobal.WORLD.LastWorldMap.data.daykillcount+1] = {killID,killnum}
--		end
--		checkMadel(5)
--		checkMadel(10)
--		--失败单位显示对话
--		local vTalk = hApi.InitTalkAfterBattle(oUnitVx,oUnitDx,oWorld.__LOG)
--		local btStyle = {
--			[1] = 0,
--			[2] = "UI:ConfimBtn1",
--			[3] = 1.1,
--			[4] = -35,
--			[5] = 72,
--		}
--		local tWorldLog = oWorld.__LOG		--为了防止战场莫名其妙被删除取不到战报，所以在这里把战报留下来
--		local IsNetBattlefield = 0
--		if type(oWorld.data.netdata)=="table" then
--			IsNetBattlefield = 1
--		end
--		hApi.addTimerOnce("__BF__HeroShowBattleLogFrame",750,function()
--			local _frm = hGlobal.UI.MsgBox("",resultTable,function()
--				hApi.EnterWorld()
--			end,btStyle)
--			if IsNetBattlefield==1 then
--				--网络战场什么都不做
--			else
--				if vTalk~=nil then
--					hGlobal.SceneEvent:add("worldmap",1,function()
--						hApi.CreateUnitTalk(vTalk,function()
--							hApi.ClearLocalDeadIllusion()
--							hGlobal.SceneEvent:continue()
--						end)
--					end)
--				end
--				local IsContinue = 0
--				if oUnitC==oUnitV then
--					local oHero = oUnitVx:gethero()
--					if oHero then
--						hGlobal.SceneEvent:add("worldmap",1,function()
--							local oWorld = hGlobal.WORLD.LastWorldMap
--							if oWorld==nil then
--								--世界地图已经不存在
--								hApi.ClearLocalDeadIllusion()
--								hGlobal.SceneEvent:clear()
--								hGlobal.event:event("Event_HeroAttackConfirm",nil,oUnitC,false)
--							elseif oWorld.data.PausedByWhat=="Victory" or oWorld.data.PausedByWhat=="Defeat" then
--								--游戏已结束
--								hApi.ClearLocalDeadIllusion()
--								hGlobal.SceneEvent:clear()
--								hGlobal.event:event("Event_HeroAttackConfirm",nil,oUnitC,false)
--							else
--								--本地玩家胜利战斗才能获得奖励(友军击杀也可以的说)
--								hGlobal.event:event("localEvent_HeroVictoryReward",tWorldLog,oHero,oUnitDx.data.id,oUnitDx,tgrDataDx)
--							--else
--								----否则直接跳过
--								--hGlobal.SceneEvent:continue()
--							end
--						end)
--					end
--				end
--				hGlobal.SceneEvent:add("worldmap",1,function()
--					hApi.ClearLocalDeadIllusion()
--					hGlobal.SceneEvent:continue()
--					hGlobal.event:event("Event_HeroAttackConfirm",nil,oUnitE,oUnitV==oUnitE)
--				end)
--			end
--
--			--_frm.childUI["btnOk"]:setXY(_frm.childUI["btnOk"].data.x+180,_frm.childUI["btnOk"].data.y)
--			--这是陶晶在实在没办法的情况下改出来的代码，有想骂人的时候 可以来找他 ... 2014-11-28
--			_frm.childUI["btnOk"]:setstate(-1)
--			if _frm.childUI["btnOk1"]==nil then
--				_frm.childUI["btnOk1"] = hUI.button:new({
--					parent = _frm,
--					model = "UI:ConfimBtn1",
--					font = hVar.FONTC,
--					x = _frm.childUI["btnOk"].data.x+190,
--					y = _frm.childUI["btnOk"].data.y,
--					scaleT = 0.95,
--					code = _frm.childUI["btnOk"].data.code,
--				})
--			end
--			
--			if oUnitC==oUnitV then
--				__AddLogUI(_frm,oUnitC,nExpGet,tLostUnits,tKillUnits,roundcount,BattlefieldType,oUnitE,1,oUnitV)
--			else
--				__AddLogUI(_frm,oUnitC,nExpGet,tLostUnits,tKillUnits,roundcount,BattlefieldType,oUnitE,0,oUnitV)
--			end
--			__AddTittleUI(_frm,oUnitC,oUnitV,oUnitD,nStar,nScore)
--			_frm:show(1,"fade",{time = 0.15})
--		end)
--		if SHOW_WDLD_END == 1 then
--			SHOW_WDLD_END = 0
--			hGlobal.event:event("LocalEvent_ShowWDLDEndFrm",1)
--		end
--	end)
--	-----------------------------------
--	--如果是本地玩家击败了单位，则创造一个镜像,等待玩家出战场显示死亡动画
--	hGlobal.event:listen("Event_UnitDefeated","__LocalDefeat__",function(oWorld,oUnit,oDefeatHero)
--		if oWorld.data.IsQuickBattlefield==1 then
--			return
--		end
--		if hGlobal.LocalPlayer:getfocusworld()==oWorld and oUnit:gettown()==nil then
--			if oUnit:getworld()==hGlobal.WORLD.LastWorldMap then
--				table.insert(hGlobal.LOCAL_DEAD_ILLUSION,{id = oUnit.data.id,s = oUnit:copyimage(),tgrData = oUnit:gettriggerdata(),__manager = "lua",})
--			else
--				xlLG("ui_illusion","error!创建镜像的单位"..oUnit.data.id.."并不在世界地图上\n")
--			end
--		end
--	end)
--end
--
--
----------------------------------
---- 加载奖励面板
----------------------------------
--hGlobal.UI.InitRewardPanel = function()
--	local x,y,w,h = hVar.SCREEN.w/2 - 277,hVar.SCREEN.h/2 + 231,554,462
--	hGlobal.UI.__RewardPanel = hUI.frame:new({
--		x = x,
--		y = y,
--		w = w,
--		h = h,
--		dragable = 2,
--		show = 0,
--		--background = "UI:PANEL_INFO_S",
--		w = 544,
--		h = 462,
--		titlebar = 0,
--		z = -1,
--	})
--
--	local _frame = hGlobal.UI.__RewardPanel
--	local _parent = _frame.handle._n
--	local _childUI = _frame.childUI
--	local nCurSelectIndex = nil
--	local _exitFunc = nil
--	local _rewardTable = nil
--	
--	--分界线
--	_childUI["apartline_back"] = hUI.image:new({
--		parent = _parent,
--		model = "UI:panel_part_09",
--		x = 270,
--		y = -150,
--		w = w,
--		h = 8,
--	})
--
--	--创建ok按钮
--	_childUI["btnOk"] = hUI.button:new({
--		parent = _parent,
--		mode = "imageButton",
--		dragbox = _childUI["dragBox"],
--		model = "UI:BTN_ok",
--		scaleT = 0.9,
--		x = w/2-10,
--		y = -420,
--		
--		code = function(self)
--			if type(_exitFunc)=="function" then
--				print("奖励面板OK按钮点击 回调")
--				_exitFunc(nCurSelectIndex,_rewardTable)
--			end
--			print("奖励面板OK按钮点击 nCurSelectIndex:" .. nCurSelectIndex)
--			_frame:show(0,"appear")
--		end,
--	})
--
--	_childUI["rewardTipText"] = hUI.label:new({
--		parent = _parent,
--		size = 26,
--		align = "MC",
--		font = hVar.FONTC,
--		x = w/2 - 10,
--		y = -350,
--		width = 500,
--		border = 1,
--		text = hVar.tab_string["__TEXT_AttrExpirationTip"],
--	})
--	_childUI["rewardTipText"].handle._n:setVisible(false)
--	
--	
--	--添加选中效果函数
--	local _GP = {align = "MC"}
--	local function __GridAddBorder(grid,gridX,girdY)
--		grid:addimage("UI:Button_SelectBorder",gridX,girdY,_GP)
--	end
--	
--	hGlobal.UI.RewardPanel = function(rewardTable,selectRewardCode,isShowTip)
--		
--		if isShowTip == 1 then
--			_childUI["rewardTipText"].handle._n:setVisible(true)
--		else
--			_childUI["rewardTipText"].handle._n:setVisible(false)
--		end
--		
--		--创建头像
--		local tabTarget = rewardTable.target--hVar.tab_unit[rewardTable.target.data.id]
--		local title = rewardTable.title
--		local content = rewardTable.content
--		local heroName = hApi.GetUnitName(rewardTable.unit)
--		local targetName = hApi.GetUnitName(rewardTable.target)
--		local week = GetWeek()
--		local day = GetDay()
--		title = hGlobal.UI.Format(title,heroName,targetName,nil,week,day)
--		content = hGlobal.UI.Format(content,heroName,targetName)
--
--		hApi.safeRemoveT(_childUI,"rewardInfo")
--		hApi.safeRemoveT(_childUI,"guardImagenBG")
--		hApi.safeRemoveT(_childUI,"icon")
--		hApi.safeRemoveT(_childUI,"title")
--		hApi.safeRemoveT(_childUI,"content")
--
--		_childUI["guardImagenBG"] = hUI.image:new({
--			parent = _parent,
--			model = "UI_frm:slot",
--			animation = "lightSlim",
--			w = 70,
--			h = 70,
--			x = 74,
--			y = -85,
--		})
--
--		if type(tabTarget) == "number" then
--			_childUI["icon"] = hUI.thumbImage:new({
--				parent = _parent,
--				--model = tabTarget.model or tabTarget.xlobj,
--				id = tabTarget,
--				--unit = rewardTable.target,
--				w = 68,
--				h = 68,
--				x = 74,
--				y = -85,
--			})
--		else
--			_childUI["icon"] = hUI.thumbImage:new({
--				parent = _parent,
--				unit = rewardTable.target,
--				w = 68,
--				h = 68,
--				x = 74,
--				y = -85,
--			})	
--		end
--		
--		local size = 26
--		local textlen = math.ceil(string.len(title)/28) 
--		if textlen>3 then
--			--size = 24
--		end
--		--创建显示标题的信息
--		_childUI["title"] = hUI.label:new({
--			parent = _parent,
--			text = title or "$no_hint",--"两行两行两行两行两行两行两行两行两行两行两行两行两行两行\n",
--			x = w/2 - 155,
--			y = -90 + textlen*10,
--			width = 380,
--			align = "LT",
--			size = size,
--			border = 1,
--			font = hVar.FONTC,
--		})
--		
--		--创建显示内容的信息
--		if 0 == rewardTable.rewardType and rewardTable.content then
--			_childUI["content"] = hUI.label:new({
--			parent = _parent,
--			text = content,
--			x = w/2,
--			y = -190,
--			width = w - 50,
--			align = "MT",
--			size = 26,
--			font = hVar.FONTC,
--			border = 1,
--		})
--		end
--		
--		--创建物品按钮的函数
--		local function _CreateItemImage(i,baseN,plusX,plusY)
--			local a = rewardTable[i]
--
--			local x,y,w,h = a.x,a.y,a.w,a.h
--			if w==nil and h==nil then
--				w = 70
--				h = 70
--			end
--			x = x or 0
--			y = y or 0
--			if a.num and a.num>0 then
--				--y = (y or 0)+10
--				hUI.deleteUIObject(hUI.image:new({
--					parent = baseN,
--					model = a.model,
--					animation = a.animation,
--					w = w,
--					h = h,
--					x = x+plusX,
--					y = y+plusY,
--				}))
--				hUI.deleteUIObject(hUI.label:new({
--					parent = baseN,
--					--font = "numWhite",
--					size = 26,
--					text = a.name,
--					x = plusX,
--					y = -50+plusY,
--					align = "MC",
--					border = 1,
--					font = hVar.FONTC,
--				}))
--				local sHint = "+"..a.num
--				if a.hint and type(a.hint)=="string" then
--					sHint = a.hint
--				end
--				hUI.deleteUIObject(hUI.label:new({
--					parent = baseN,
--					font = a.hintFont or rewardTable.hintFont or "numWhite",
--					size = a.hintSize or rewardTable.hintSize or 18,
--					text = sHint,
--					x = plusX,
--					y = -72+plusY,
--					align = "MC",
--					border = 1,
--				}))
--			else
--				hUI.deleteUIObject(hUI.image:new({
--					parent = baseN,
--					model = a.model,
--					animation = a.animation,
--					w = w,
--					h = h,
--					x = x+plusX,
--					y = y+plusY,
--				}))
--				hUI.deleteUIObject(hUI.label:new({
--					parent = baseN,
--					--font = "numWhite",
--					size = 26,
--					text = a.name,
--					x = plusX,
--					y = -62+plusY,
--					align = "MC",
--					border = 1,
--					font = hVar.FONTC,
--				}))
--			end
--		end
--
--		--创建奖励信息函数
--		local function _CreateRewardInfo()
--			local _lastGridX,_lastGridY = 0,0
--			
--			local _slot = {}
--			for i = 1,#rewardTable do
--				_slot[i] = "UI_frm:slot"
--			end
--			local _lastGridX,_lastGridY = 0,0
--			local gridX = math.floor(w / #rewardTable) - 10
--			if 2 == #rewardTable then
--				gridX = math.floor(w / 3) - 10
--			end
--			local gridY = -240
--			local scale = nil
--			if rewardTable.rewardType >= 1 then
--				scale = 0.90
--			else
--				scale = 1.0
--			end
--			
--			local orix = gridX / 2 - 10
--			if 5 == #rewardTable then
--				orix = orix + 20
--			elseif 4 == #rewardTable then
--				orix = orix + 15
--			elseif 3 == #rewardTable then
--				orix = orix + 10
--			elseif 2 == #rewardTable then
--				orix = orix + 90
--			end
--		
--			_childUI["rewardGrid"] = hUI.grid:new({
--				parent = _parent,
--				mode = "imageButton",
--				dragbox = _childUI["dragBox"],
--				animation = "lightSlim",
--				align = "MC",
--				gridW = gridX,
--				gridH = 70,
--				iconH = 70,
--				x = orix,
--				y = gridY,
--				scaleT = scale,
--				--offsetX = {0,40},
--				grid = _slot,
--				
--				codeOnTouch = function(_,_,_,gridX,girdY)
--					local info = string.format("begin _lastGridX:%d,_lastGridY:%d gridX:%d,gridY:%d  nCurSelectIndex%d",_lastGridX,_lastGridY,gridX,girdY,(nCurSelectIndex or -1))
--					print(info)
--					if rewardTable.rewardType < 1 then return end
--					if 0 == nCurSelectIndex then _childUI["btnOk"]:setstate(1) end
--					local grid = _childUI["rewardGrid"]
--					local sprite = grid:getimage(_lastGridX,_lastGridY,1)
--					if sprite~=nil then
--						sprite:getParent():removeChild(sprite,true)
--						sprite = nil
--					end
--					_lastGridX,_lastGridY = gridX,girdY
--					nCurSelectIndex = _lastGridX + 1
--					__GridAddBorder(grid,_lastGridX,_lastGridY)
--				end,
--
--				codeOnImageCreate = function(self,id,sprite,gx,gy)
--					local x,y = self:grid2xy(gx,gy)
--					_CreateItemImage(gx+1,self.handle._n,x,y)
--				end,
--				codeOnButtonCreate = function(self,id,btn,gx,gy)
--					_CreateItemImage(gx+1,btn.handle._n,0,0)
--				end,
--			})
--			
--			_childUI["rewardGrid"].data.tab = 0
--			_childUI["rewardGrid"].data.iconW = 70
--			_childUI["rewardGrid"].data.iconH = 70
--			_childUI["rewardGrid"].data.codeOnImageCreate = 0
--			_childUI["rewardGrid"].data.codeOnButtonCreate = 0
--		end
--
--
--		
--		
--		--创建奖励面板
--		hApi.safeRemoveT(_childUI,"rewardGrid")
--		_childUI["dragBox"]:sortbutton()
--		_childUI["rewardGrid"] = nil
--
--		nCurSelectIndex = 0
--		_exitFunc = selectRewardCode
--		_rewardTable = rewardTable
--		
--		--奖励信息
--		_childUI["rewardInfo"] = hUI.label:new({
--			parent = _parent,
--			size = 26,
--			align = "MC",
--			font = hVar.FONTC,
--			x = _frame.data.w/2-10,
--			y = -180,
--			width = 500,
--			border = 1,
--			text = "",--hVar.tab_string["__TEXT_Account_Balance"],
--		})
--
--		if -1 == rewardTable.rewardType then --不需要选择 全部都给予
--			_childUI["btnOk"]:setstate(1)
--			_childUI["rewardInfo"]:setText(hVar.tab_string["__TEXT_All_get"])
--			_CreateRewardInfo()
--		elseif 0 == rewardTable.rewardType then --不给予
--			_childUI["btnOk"]:setstate(1)
--		elseif 1 == rewardTable.rewardType then --只能选择一个
--			_childUI["btnOk"]:setstate(0)
--			_childUI["rewardInfo"]:setText(hVar.tab_string["__TEXT_Can_Choose"])
--			_CreateRewardInfo()
--		end
--		
--
--		hApi.addTimerOnce("__UI__RewardPanelShow",1,function()
--			if _frame.data.show==0 then
--				_frame:show(1)
--			end
--		end)
--		return _frame
--	end
--
--	--占领事件
--	hGlobal.event:listen("Event_HeroOccupy","__ShowRewardsInfo__",function(oWorld,oUnit,oTarget)
--		local u = oUnit
--		local t = oTarget
--		local tTab = t:gettab()
--
--		print("Event_HeroOccupy current Target id:" .. oTarget.data.id)
--
--		if oUnit.data.IsAi == 1  then
--			if oTarget:gettown() then
--				--hApi.CreateArmyByGroup(oWorld,nil,oTarget,{{0,10026,10027,10029,10030,10031,10032,4}},120,0.01)
--			end
--			return 
--		end
--		
--		if tTab.provide then
--			local rewardTable = {world = oWorld,unit = oUnit,target = oTarget}
--			rewardTable.rewardType = -1
--			rewardTable.hintFont = hVar.FONTC
--			rewardTable.hintSize = 26
--			local tableHint = hVar.tab_stringU[t.data.id]
--			if tableHint then rewardTable.title = tableHint[3] end
--			local num = #tTab.provide
--			for i = 1,num do
--				local nCount = tTab.provide[i][2]
--				if 0 == nCount then nCount = nil end
--				local sType = tTab.provide[i][1]
--				local loot = {"res",unpack(tTab.provide[i])}
--				if type(nCount) == "number" and oWorld and type(oWorld.data.ProvidePec) == "number" then
--					nCount = math.floor(nCount * oWorld.data.ProvidePec / 100)
--					if rewardTable.title then
--						rewardTable.title = string.gsub(rewardTable.title,"%%(%w+)%%",nCount)
--					end
--				end
--				rewardTable[#rewardTable+1] = {model=hApi.GetLootModel(loot),animation = hApi.GetLootAnimation(loot),name = hApi.GetLootName(loot),num = nCount,hint = hGlobal.UI.Format(hVar.tab_string["__Resource_Cycle_PerDay"],nil,nil,tostring(nCount)),index = i}
--			end
--			
--			hGlobal.UI.RewardPanel(rewardTable,function(i,reward)	--奖励面板
--				print("Event_HeroOccupy 你选择了奖励["..i.."]")
--				hUI.Disable(300,"关闭访问面板")
--			end):show(1,"fade")
--		end
--	end)
--
--	hGlobal.event:listen("Event_HeroOccupy","WDLD_OCC_BUILDING",function(oWorld,oUnit,oTarget)
--		local mapname = hGlobal.WORLD.LastWorldMap.data.map
--		if hApi.Is_WDLD_Map(mapname) ~= -1 and g_WDLD_BeginATK == 1 then
--			local u = oUnit
--			local t = oTarget
--			local tTab = t:gettab()
--			local bid = t.data.id
--			for i = 1,#hVar.WDLD_BUILDING_REWARD do
--				if hVar.WDLD_BUILDING_REWARD[i][1] == bid then
--					local re = hVar.WDLD_BUILDING_REWARD[i]
--					local t = re[1] or 0
--					local wood = re[2] or 0--wood
--					local food = re[3] or 0
--					local stone = re[4] or 0
--					local iron = re[5] or 0
--					local crystal = re[6] or 0
--					local gold = re[7] or 0
--					local expl = re[8] or 0
--					Game_Zone_OnGameEvent(GZone_Event_TypeDef.Lua,{GZone_Event_TypeDef.BattleLog,luaGetplayerDataID(),lookPlayer.roleid,t,1,gold,food,wood,stone,iron,crystal,expl,log_ex,0})
--					break
--				end
--			end
--		end
--	end)
--
--	--捡取事件
--	hGlobal.event:listen("Event_HeroLoot","__ShowRewardsInfo__",function(oWorld,oUnit,oTarget)
--		local u = oUnit
--		local t = oTarget
--		local tTab = t:gettab()
--
--		--补充默认行为
--		if nil == tTab.interactionBox and tTab.loot and #(tTab.loot) > 0 then
--			tTab.interactionBox = {hVar.INTERACTIONBOX_TYPE.NONE,hVar.UNIT_REWARD_TYPE.ALL,}
--		end
--
--		if type(tTab.interactionBox)=="table" and type(tTab.loot)=="table" then
--			local nOp,nType = unpack(tTab.interactionBox)
--			local tTitleTable = hVar.tab_stringU[t.data.id]--tTab.interactionHint
--			local tLoot = tTab.loot
--			local tgrDataU = t:gettriggerdata()
--			if tgrDataU and type(tgrDataU.loot)=="table" then
--				tLoot = tgrDataU.loot
--			end
--
--			if hVar.INTERACTIONBOX_TYPE.NONE == nOp or oUnit.data.IsAi==1 then --不弹框
--				t:dead(hVar.OPERATE_TYPE.UNIT_LOOT,u)
--				if hVar.UNIT_REWARD_TYPE.ALL == nType then -- 全给
--					local num = #tLoot
--					for i = 1,num do
--						local resType,resTypeEx,resMin,resMax = unpack(tLoot[i])
--						local resValue = hApi.random(tLoot[i][3],tLoot[i][4])
--						hApi.UnitGetLoot(oUnit,resType,resTypeEx,resValue,oUnit)
--					end
--				elseif hVar.UNIT_REWARD_TYPE.NONE == nType then --不给
--					return
--				elseif hVar.UNIT_REWARD_TYPE.RANDOM == nType or hVar.UNIT_REWARD_TYPE.CHOOSE == nType then --随机给一个
--					local num = #tLoot
--					local index = hApi.random(1,num)
--					local resType,resTypeEx,resMin,resMax = unpack(tLoot[index])
--					local resValue = hApi.random(tLoot[index][3],tLoot[index][4])
--					hApi.UnitGetLoot(oUnit,resType,resTypeEx,resValue,oUnit)
--				else
--					return
--				end
--			elseif hVar.INTERACTIONBOX_TYPE.REWARD == nOp then --谈reward框
--				local rewardTable = {world = oWorld,unit = oUnit,target = oTarget}
--				if tTitleTable then rewardTable.title = tTitleTable[3] end
--				--判断给予类型
--				if hVar.UNIT_REWARD_TYPE.ALL == nType then --全给
--					rewardTable.rewardType = -1
--					local num = #tLoot
--					for i = 1,num do
--						local nCount = hApi.random(tLoot[i][3],tLoot[i][4])
--						if 0 == nCount then
--							nCount = nil
--						end
--						rewardTable[#rewardTable+1] = {model=hApi.GetLootModel(tLoot[i]),animation = hApi.GetLootAnimation(tLoot[i]),name = hApi.GetLootName(tLoot[i]),num = nCount,index = i}
--					end
--				elseif hVar.UNIT_REWARD_TYPE.NONE == nType then --不给
--					rewardTable.rewardType = 0
--					if tTitleTable then rewardTable.title = tTitleTable[4] rewardTable.content = tTitleTable[5] end
--				elseif hVar.UNIT_REWARD_TYPE.CHOOSE == nType then --玩家选一个
--					rewardTable.rewardType = 1
--					local num = #tLoot
--					for i = 1,num do
--						local nCount = hApi.random(tLoot[i][3],tLoot[i][4])
--						if 0 == nCount then nCount = nil end
--						rewardTable[#rewardTable+1] = {model=hApi.GetLootModel(tLoot[i]),animation = hApi.GetLootAnimation(tLoot[i]),name = hApi.GetLootName(tLoot[i]),num = nCount,index = i}
--					end
--				elseif hVar.UNIT_REWARD_TYPE.RANDOM == nType then --系统随机选一个给玩家
--					rewardTable.rewardType = -1
--					local num = #tLoot
--					local nIndex = hApi.random(1,num)
--					local nCount = hApi.random(tLoot[nIndex][3],tLoot[nIndex][4])
--					if 0 == nCount then nCount = nil end
--					rewardTable[#rewardTable+1] = {model=hApi.GetLootModel(tLoot[nIndex]),animation = hApi.GetLootAnimation(tLoot[nIndex]),name = hApi.GetLootName(tLoot[nIndex]),num = nCount,index = nIndex}
--				else
--					return
--				end
--				
--				hGlobal.UI.RewardPanel(rewardTable,function(i,reward)	--奖励面板
--					print("Event_HeroVisit 你选择了奖励["..i.."]")
--					t:dead(hVar.OPERATE_TYPE.UNIT_LOOT,u)
--					--判断给予类型
--					if hVar.UNIT_REWARD_TYPE.ALL == nType then --全给
--						for i = 1,#reward do
--							local resType,resTypeEx,resMin,resMax = unpack(tLoot[i])
--							local resValue = rewardTable[i].num
--							hApi.UnitGetLoot(oUnit,resType,resTypeEx,resValue,oUnit)
--						end
--					elseif hVar.UNIT_REWARD_TYPE.NONE == nType then --不给
--					elseif hVar.UNIT_REWARD_TYPE.CHOOSE == nType then --玩家选一个
--						local resType,resTypeEx,resMin,resMax = unpack(tLoot[i])
--						local resValue = rewardTable[i].num
--						hApi.UnitGetLoot(oUnit,resType,resTypeEx,resValue,oUnit)
--					elseif hVar.UNIT_REWARD_TYPE.RANDOM == nType then --系统随机选一个给玩家
--						local resType,resTypeEx,resMin,resMax = unpack(tLoot[reward[1].index])
--						local resValue = rewardTable[1].num
--						hApi.UnitGetLoot(oUnit,resType,resTypeEx,resValue,oUnit)
--					end
--					hUI.Disable(300,"关闭访问面板")
--				end):show(1,"fade")
--			else
--				return
--			end
--		end
--
--		local _item =  oTarget:getitem()
--		--拾取道具流程 陶晶 2013-5-20
--		if _item and _item.data.id ~=1 then
--			local tTitleTable = hVar.tab_stringI[_item.data.id]--tTab.interactionHint
--			local rewardTable = {world = oWorld,unit = oUnit,target = oTarget}
--			
--			local itemName = hVar.tab_string["__TEXT_noAppraise"]
--			if hVar.tab_stringI[_item.data.id] and hVar.tab_stringI[_item.data.id][1] then
--				itemName = hVar.tab_stringI[_item.data.id][1]
--			end
--			
--			if tTitleTable then
--				rewardTable.title = tTitleTable[2]
--			end
--			rewardTable.rewardType = -1
--			rewardTable[#rewardTable+1] = {model=_item.data.icon,animation = nil,name =itemName ,num = _item.data.stack,index = 1}
--			local tabI = hVar.tab_item[_item.data.id]
--			if oUnit.data.IsAi ~= 1 and tabI then
--				local oHero = oUnit:gethero()
--				local CanPick = 0
--				if CanPick==0 then
--					for i = 1,#oHero.data.equipment do
--						if oHero.data.equipment[i]==0 and hApi.GetHeroEquipmentIndexType(tabI.type)== i then
--							CanPick = 1
--						end
--					end
--				end
--				if CanPick==0 then
--					for i = 1,#oHero.data.item do
--						if oHero.data.item[i] == 0 then
--							CanPick = 1
--						end
--					end
--				end
--				--英雄背包有空位的时候才能捡东西否则 弹个提示
--				if CanPick == 1 then
--					hGlobal.UI.RewardPanel(rewardTable,function(i,reward)	--奖励面板
--						hGlobal.LocalPlayer:order(oWorld,hVar.OPERATE_TYPE.HERO_GETITEM,oUnit,nil,oTarget)
--					end):show(1,"fade")
--				else
--					hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_ITEMLISTISFULL"],{
--						font = hVar.FONTC,
--						ok = function()
--						end,
--					})
--				end
--			end
--		end
--	end)
--
--	--访问事件
--	hGlobal.event:listen("Event_HeroVisit","__ShowRewardsInfo__",function(oWorld,oUnit,oTarget)
--		local u = oUnit
--		local t = oTarget
--		local tTab = t:gettab()
--		
--		print("Event_HeroVisit current Target id:" .. oTarget.data.id .. " " .. type(tTab.interactionBox))
--		local tLoot = tTab.loot
--		local tgrDataU = t:gettriggerdata()
--		if tgrDataU and type(tgrDataU.loot)=="table" then
--			tLoot = tgrDataU.loot
--		end
--		if t:iscooldown(oUnit) then
--			if type(tTab.interactionBox)=="table" and type(tLoot)=="table" then
--				local nOp,nType = unpack(tTab.interactionBox)
--				local tTitleTable = hVar.tab_stringU[t.data.id]--tTab.interactionHint
--
--				if hVar.INTERACTIONBOX_TYPE.NONE == nOp or oUnit.data.IsAi == 1 then --不弹框
--					if hVar.UNIT_REWARD_TYPE.ALL == nType then -- 全给
--						local num = #tLoot
--						for i = 1,num do
--							local resType,resTypeEx,resMin,resMax = unpack(tLoot[i])
--							local resValue = hApi.random(tLoot[i][3],tLoot[i][4])
--							hApi.UnitGetLoot(oUnit,resType,resTypeEx,resValue,oUnit)	
--						end
--						t:setcooldown(u)
--					elseif hVar.UNIT_REWARD_TYPE.NONE == nType then --不给
--						return
--					elseif hVar.UNIT_REWARD_TYPE.CHOOSE == nType or hVar.UNIT_REWARD_TYPE.RANDOM == nType then --随机给一个
--						local num = #tLoot
--						local index = hApi.random(1,num)
--						local resType,resTypeEx,resMin,resMax = unpack(tLoot[index])
--						local resValue = hApi.random(tLoot[index][3],tLoot[index][4])
--						hApi.UnitGetLoot(oUnit,resType,resTypeEx,resValue,oUnit)
--						t:setcooldown(u)
--					else
--						return
--					end
--				elseif hVar.INTERACTIONBOX_TYPE.REWARD == nOp then --谈reward框
--
--					local rewardTable = {world = oWorld,unit = oUnit,target = oTarget}
--					if tTitleTable then rewardTable.title = tTitleTable[3] end
--					--判断给予类型
--					if hVar.UNIT_REWARD_TYPE.ALL == nType then --全给
--						rewardTable.rewardType = -1
--						local num = #tLoot
--						for i = 1,num do
--							local nCount = hApi.random(tLoot[i][3],tLoot[i][4])
--							if 0 == nCount then nCount = nil end
--							rewardTable[#rewardTable+1] = {model=hApi.GetLootModel(tLoot[i]),animation = hApi.GetLootAnimation(tLoot[i]),name = hApi.GetLootName(tLoot[i]),num = nCount,index = i}
--						end
--					elseif hVar.UNIT_REWARD_TYPE.NONE == nType then --不给
--						rewardTable.rewardType = 0
--						if tTitleTable then rewardTable.title = tTitleTable[4] rewardTable.content = tTitleTable[5] end
--					elseif hVar.UNIT_REWARD_TYPE.CHOOSE == nType then --玩家选一个
--						rewardTable.rewardType = 1
--						local num = #tLoot
--						for i = 1,num do
--							local nCount = hApi.random(tLoot[i][3],tLoot[i][4])
--							if 0 == nCount then nCount = nil end
--							rewardTable[#rewardTable+1] = {model=hApi.GetLootModel(tLoot[i]),animation = hApi.GetLootAnimation(tLoot[i]),name = hApi.GetLootName(tLoot[i]),num = nCount,index = i}
--						end
--					elseif hVar.UNIT_REWARD_TYPE.RANDOM == nType then --系统随机选一个给玩家
--						rewardTable.rewardType = -1
--						local num = #tLoot
--						local nIndex = hApi.random(1,num)
--						local nCount = hApi.random(tLoot[nIndex][3],tLoot[nIndex][4])
--						if 0 == nCount then nCount = nil end
--						rewardTable[#rewardTable+1] = {model=hApi.GetLootModel(tLoot[nIndex]),animation = hApi.GetLootAnimation(tLoot[nIndex]),name = hApi.GetLootName(tLoot[nIndex]),num = nCount,index = nIndex}
--					else
--						return
--					end
--
--					local isShowTip = 0
--					--只在桃园结义中增加提示 并且是访问凉亭
--					if oWorld.data.map == "world/level_tyjy" and t.data.id == 43203 then
--						for i = 1,#tLoot do
--							if tLoot[i][1] == "attr" then
--								isShowTip = 1
--							end
--						end
--					end
--
--					hGlobal.UI.RewardPanel(rewardTable,function(i,reward)	--奖励面板
--						print("Event_HeroVisit 你选择了奖励["..i.."]")
--						t:setcooldown(u)
--						--判断给予类型
--						if hVar.UNIT_REWARD_TYPE.ALL == nType then --全给
--							for i = 1,#reward do
--								local resType,resTypeEx,resMin,resMax = unpack(tLoot[i])
--								local resValue = rewardTable[i].num
--								hApi.UnitGetLoot(oUnit,resType,resTypeEx,resValue,oUnit)	
--							end
--						elseif hVar.UNIT_REWARD_TYPE.NONE == nType then --不给
--						elseif hVar.UNIT_REWARD_TYPE.CHOOSE == nType then --玩家选一个
--							local resType,resTypeEx,resMin,resMax = unpack(tLoot[i])
--							local resValue = rewardTable[i].num
--							hApi.UnitGetLoot(oUnit,resType,resTypeEx,resValue,oUnit)
--						elseif hVar.UNIT_REWARD_TYPE.RANDOM == nType then --系统随机选一个给玩家
--							local resType,resTypeEx,resMin,resMax = unpack(tLoot[reward[1].index])
--							local resValue = rewardTable[1].num
--							hApi.UnitGetLoot(oUnit,resType,resTypeEx,resValue,oUnit)
--						end
--						hUI.Disable(300,"关闭访问面板")
--					end,isShowTip):show(1,"fade")
--				else
--					return
--				end
--			end
--		else
--			local rewardTable = {world = oWorld,unit = oUnit,target = oTarget}
--			if type(tTab.interactionBox)=="table" and type(tLoot)=="table" then
--				local tableHint = hVar.tab_stringU[t.data.id]
--				if type(tableHint) == "table" then
--					rewardTable.title = tableHint[4]
--					rewardTable.content = tableHint[5]
--				end
--			end
--			rewardTable.rewardType = 0
--			hGlobal.UI.RewardPanel(rewardTable,function(i,reward)	--奖励面板
--				hUI.Disable(300,"关闭访问面板")
--			end):show(1,"fade")
--		end
--	end)
--
--end
--
----测试先放这吧...
--hGlobal.UI.Format = function(text,hero,target,num,week,day)
--	text = text or "[内容木有]"
--	local t = {visitor=hero,target=target,number=num,week=week,day=day}
--	return string.gsub(text,"%@(%w+)%@",t)
--end
--
--
--





--
----------------------------------
---- 加载游戏结束对话面板
----------------------------------
--G_UI_ReverseItemFrmState = 0
--hGlobal.UI.InitGameOverPanel = function()
--	local w,h = hVar.SCREEN.w+10, hVar.SCREEN.h
--	local x,y = hVar.SCREEN.w/2-w/2, hVar.SCREEN.h
--	local scale = 1
--	local btnScale = 0.9							--按钮缩放
--	local bIsStarShow = false						--必须在星星显示完后才可以进行其他操作
--	local nScreenY = 0							--根据机器类型（手机，平板）调正整体位置
--	if 0 == g_phone_mode then
--		nScreenY = -70
--	end
--	
--	hGlobal.UI.__GameOverPanel = hUI.frame:new({
--		x = x,
--		y = y,
--		w = w,
--		h = h,
--		dragable = 2,
--		show = 0,
--		background = "UI:tip_item",					--透明面板
--		border	= "UI:TileFrmBasic_thin",				--细边框
--	})
--	
--	local _frame = hGlobal.UI.__GameOverPanel
--	local _parent = _frame.handle._n
--	local _childUI = _frame.childUI
--	local _CODE_ExitGame = hApi.DoNothing					--场景切换，删除地图
--	local _CODE_ShowGameOverPanel = hApi.DoNothing				--显示面板（包括很多处理动作）
--	local _chestPoolExitFun = hApi.DoNothing				--挑战难度抽卡面板退出函数
--	
--	--【背景】
--	local nBackGroundX, nBackGroundY = w/2, nScreenY-110
--	--光芒底线
--	_childUI["LightLine_image"] = hUI.image:new({
--		model = "UI:lightline",
--		parent = _parent,
--		w = 700,
--		h = 14,
--		x = nBackGroundX,
--		y = nBackGroundY - 63,
--	})
--	
--	--光芒
--	_childUI["LightStar_image"] = hUI.image:new({
--		model = "UI:lightstar",
--		parent = _parent,
--		x = nBackGroundX,
--		y = nBackGroundY,
--		z = 0
--	})
--	
--	--奖励背景
--	_childUI["Resource_background1"] = hUI.bar:new({
--		parent = _parent,
--		model = "UI:card_select_back",
--		x = nBackGroundX,
--		y = nBackGroundY - 370,
--		w = 576,
--		h = 113,
--	})
--	--_childUI["Resource_background1"].handle._n:setVisible(false)
--	
--	--全部获取时的提示文字
--	_childUI["labRewardAll"] =hUI.label:new({
--		parent = _parent,
--		x = nBackGroundX - 100,
--		y = nBackGroundY - 370,
--		text = hVar.tab_string["__GetAllReward"],
--		font = hVar.FONTC,
--		border = 1,
--		width = 200,
--	})
--	_childUI["labRewardAll"].handle._n:setVisible(false)
--
--	--【描述】-------------------------------------------------------------------------------------------
--	local nGameDescribeX, nGameDescribeY = w/2, nScreenY-79
--	--“通关”，“失败”
--	local resultDy = 0
--	if (0 ~= g_phone_mode) then --手机模式
--		resultDy = -30
--	end
--	_childUI["WinOrLose_image"] = hUI.image:new({
--		model = "MODEL:Default",
--		parent = _parent,
--		x = nGameDescribeX,
--		y = nGameDescribeY + 24,
--		z = 1
--	})
--
--	--“星星空槽子”
--	for i = 1,3 do
--		_childUI["star_slot_"..i]=hUI.image:new({
--			parent = _parent,
--			model = "UI:star_slot",
--			x =  nGameDescribeX - 75 + (i-1)*79,
--			y = nGameDescribeY - 54,
--			w = 64,
--			h = 64,
--			scale = 0.9
--		})
--	end
--
--	--"使用英雄"
--	_childUI["UseHero"] = hUI.label:new({
--		parent = _parent,
--		x = nGameDescribeX - 285,
--		y = nGameDescribeY - 130,
--		--text = "使用英雄:", --language
--		text = hVar.tab_string["__TEXT_Use"] .. hVar.tab_string["hero"] .. ":", --language
--		font = hVar.FONTC,
--		border = 1,
--		width = 150,
--	})
--	
--	-- "关卡积分奖励"
--	--获得奖励
--	_childUI["ScoreReward"] = hUI.label:new({
--		parent = _parent,
--		x = nGameDescribeX - 285,
--		y = nGameDescribeY - 240,
--		--text = hVar.tab_string["__TEXT_GetScore"]..":",
--		text = hVar.tab_string["__TEXT_Savehint1"]..":", --"获得奖励"
--		font = hVar.FONTC,
--		border = 1,
--		width = 150,
--	})
--	
--	--“通关提示面板”
--	--local tipFrm = hUI.frame:new({
--	--	x = hVar.SCREEN.w/2-580/2,
--	--	y = hVar.SCREEN.h/2+130,
--	--	dragable = 3,
--	--	w = 580,
--	--	h = 300,
--	--	show = 0,
--	--	closebtn = "BTN:PANEL_CLOSE",
--	--	closebtnX = 580,
--	--	closebtnY = -7,
--	--})
--	
--	--tipFrm.childUI["tipLab"] = hUI.label:new({
--	--	border = 1,
--	--	parent = tipFrm.handle._n,
--	--	x = tipFrm.data.w/2,
--	--	y = -25,
--	--	text = hVar.tab_string["__TEXT_Tips"],
--	--	width = tipFrm.data.w-10,
--	--	size = 30,
--	--	font = hVar.FONTC,
--	--	align = "MC",
--	--	RGB = {255,205,55},
--	--})
--	--tipFrm.childUI["yqts"] = hUI.label:new({
--	--	border = 1,
--	--	parent =tipFrm.handle._n,
--	--	x = 10,
--	--	y = -80,
--	--	text = "",
--	--	width = tipFrm.data.w-10,
--	--	size = 26,
--	--	font = hVar.FONTC,
--	--	align = "LT",
--	--})
--	--tipFrm.childUI["yqts_btn"] = hUI.button:new({
--	--	parent =tipFrm,
--	--	x = tipFrm.data.w/2,
--	--	y = -tipFrm.data.h + 28 ,
--	--	label = hVar.tab_string["LostTipWebURL"],
--	--	font = hVar.FONTC,
--	--	border = 1,
--	--	model = "UI:ButtonBack",
--	--	icon = "misc/gamebbs.png",
--	--	iconWH = 26,
--	--	scaleT = 0.9,
--	--	scale = 0.9,
--	--	code = function(self)
--	--		local web = hVar.MAP_INFO[hGlobal.WORLD.LastWorldMap.data.map].lostWeb
--	--		xlOpenUrl(web)
--	--	end,
--	--})
--	--tipFrm.childUI["yqts_btn"]:setstate(-1)
--	
--	--“通关提示按钮”
--	--_childUI["tipBtn"] = hUI.button:new({					--通关失败后会出现一个问号按钮
--	--	parent = _parent,
--	--	model = "ICON:action_info",
--	--	dragbox = _childUI["dragBox"],
--	--	x = nGameDescribeX + 152,
--	--	y = nGameDescribeY + 18,
--	--	scaleT = 0.9,
--	--	code = function(self)
--	--		local text = hVar.tab_string[hVar.MAP_INFO[hGlobal.WORLD.LastWorldMap.data.map].lostTip or "unknown"]
--	--		if text ~= "unknown" and text ~= "" then
--	--			tipFrm.childUI["yqts"]:setText(text)
--	--			tipFrm:show(1)
--	--			tipFrm:active()
--	--		end
--	--	end,
--	--})
--	--_childUI["tipBtn"]:setstate(-1)
--	
--	--【奖励】的东西-------------------------------------------------------------------------
--	local nAwardX, nAwardY = w/2, nScreenY - 440
--	
--	--积分图标
--	local iconW, iconH = 64, 64
--	_childUI["Score_image"] = hUI.image:new({
--		model = "UI:score",
--		parent = _parent,
--		x = nGameDescribeX - 115,
--		y = nGameDescribeY - 280 - 10,
--		w = iconW,
--		h = iconH
--		--scale = 0.8,
--	})
--	_childUI["GetScoreName"] = hUI.label:new({
--		parent = _parent,
--		align  = "MT",
--		x = _childUI["Score_image"].data.x,
--		y = nGameDescribeY - 280 + 48,
--		text = hVar.tab_string["ios_score"], --"积分"
--		font = hVar.FONTC,
--		border = 1,
--		width = 180,
--		RGB = {255,255,0},
--	})
--	_childUI["GetScore1"] = hUI.label:new({ --积分数值
--		parent = _parent,
--		align  = "MT",
--		x = _childUI["Score_image"].data.x,
--		y = _childUI["Score_image"].data.y - 35,
--		text = "",
--		font = "numWhite",
--		size = 16,
--		border = 1,
--		width = 300,
--	})
--	
--	--本关防守进度
--	_childUI["labDefProgress"] = hUI.label:new({
--		parent = _parent,
--		--align  = "MC",
--		x = nGameDescribeX - 285,
--		y = nBackGroundY - 283,
--		text = "",
--		font = hVar.FONTC,
--		border = 1,
--		width = 300,
--	})
--	--本关防守进度
--	_childUI["labDefProgressNum"] = hUI.label:new({
--		parent = _parent,
--		align  = "LC",
--		x = nGameDescribeX - 146,
--		y = nBackGroundY - 296,
--		text = "",
--		size = 20,
--		font = "numWhite",
--		border = 1,
--		width = 300,
--	})
--	
--	--本关击杀单位
--	_childUI["labKillUnit"] = hUI.label:new({
--		parent = _parent,
--		--align  = "RT",
--		x = nGameDescribeX + 50,
--		y = nBackGroundY - 283,
--		text = "",
--		font = hVar.FONTC,
--		border = 1,
--		width = 300,
--	})
--	_childUI["labKillUnitNum"] = hUI.label:new({
--		parent = _parent,
--		align  = "LC",
--		x = nBackGroundX + 190,
--		y = nBackGroundY - 296,
--		text = "",
--		size = 20,
--		font = "numWhite",
--		border = 1,
--		width = 300,
--	})
--	
--	--本关获得战绩
--	_childUI["GetCombatEva"] = hUI.label:new({
--		parent = _parent,
--		align  = "RT",
--		x = nBackGroundX,
--		y = nBackGroundY - 360,
--		text = "",
--		--font = "numWhite",
--		font = hVar.FONTC,
--		size = 32,
--		border = 1,
--		width = 300,
--	})
--	_childUI["GetCombatEvaNum"] = hUI.label:new({
--		parent = _parent,
--		align  = "LT",
--		x = nBackGroundX + 10,
--		y = nBackGroundY - 358,
--		text = "",
--		font = "numWhite",
--		size = 26,
--		border = 1,
--		width = 300,
--	})
--	
--	--【按钮】--------------------------------------------------------------------
--	local nButtonX, nButtonY  = w/2, nScreenY-410
--	--“主界面”按钮
--	_childUI["btnOk"] = hUI.button:new({
--		parent = _parent,
--		dragbox = _childUI["dragBox"],
--		model = "UI:ButtonBack",
--		icon = "ui/hall.png",
--		iconWH = 28,
--		label = " "..hVar.tab_string["__TEXT_MainInterface"],
--		font = hVar.FONTC,
--		border = 1,
--		align = "MC",
--		scaleT = 0.9,
--		x = nButtonX,
--		y = nButtonY - 260,
--		scale = btnScale,
--		code = function(self)
--			if false == bIsStarShow then										--如果评价星星没有处理完，则不能点击按钮
--				return
--			end
--			
--			--geyachao: 这里会弹框？？？暂时注释掉
--			--local mapName = hGlobal.WORLD.LastWorldMap.data.map	--zhenkira
--			
--			_chestPoolExitFun()
--			
--			_frame:show(0)
--			_CODE_ExitGame()				--删除地图等操作
--		end,
--	})
--	_childUI["btnOk"]:setstate(-1)
--	_childUI["btnOk"].childUI["label"].handle._n:setPosition(-35,12)
--	_childUI["btnOk"].childUI["icon"].handle._n:setPosition(-60,1)
--	
--	--“下一关”按钮
--	_childUI["btnNext"] = hUI.button:new({
--		parent = _parent,
--		dragbox = _childUI["dragBox"],
--		model = "UI:ButtonBack",
--		icon = "ui/nextday.png",
--		iconWH = 28,
--		label = " "..hVar.tab_string["__TEXT_NextChapter"],
--		font = hVar.FONTC,
--		border = 1,
--		align = "MC",
--		scaleT = 0.9,
--		x = nButtonX + 140,
--		y = nButtonY - 190,
--		scale = btnScale,
--		code = function(self)
--			if false == bIsStarShow then
--				return
--			end
--			
--			_chestPoolExitFun()
--			
--			_frame:show(0)
--			local cur_mapname = hGlobal.WORLD.LastWorldMap.data.map
--			local next_mapname = hApi.GetNextMapNameEx(cur_mapname)
--			
--			if type(next_mapname) == "table" then
--				if hGlobal.WORLD.LastWorldMap then
--					hGlobal.WORLD.LastWorldMap:del()
--					hGlobal.WORLD.LastWorldMap = nil
--					
--				end
--				local default_diff = hVar.MAP_INFO[next_mapname[1]].default_diff or 3
--				xlScene_LoadMap(g_world,next_mapname[1],default_diff)
--			end
--		end,
--	})
--	_childUI["btnNext"]:setstate(-1)	--不可见
--	_childUI["btnNext"].childUI["label"].handle._n:setPosition(-35,12)
--	_childUI["btnNext"].childUI["icon"].handle._n:setPosition(-60,1)
--	
--	--“重玩本关”按钮
--	_childUI["RePlayBtn"] = hUI.button:new({
--		parent = _parent,
--		dragbox = _childUI["dragBox"],
--		model = "UI:ButtonBack",
--		icon = "ui/bimage_replay.png",
--		iconWH = 33,
--		label = hVar.tab_string["__TEXT_ResetLevel"],
--		font = hVar.FONTC,
--		border = 1,
--		align = "MC",
--		scaleT = 0.9,
--		x = nButtonX + 140,
--		y = nButtonY - 190,
--		scale = btnScale,
--		code = function(self)
--			if false == bIsStarShow then
--				return
--			end
--			
--			--如果是无尽模式，那么不允许重玩本关
--			local w = hGlobal.WORLD.LastWorldMap
--			if w and w.data.tdMapInfo and (w.data.tdMapInfo.mapMode == hVar.MAP_TD_TYPE.ENDLESS) then
--				hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_ENDLESS_DISBALE_REPLY"],{
--					font = hVar.FONTC,
--					ok = function()
--						--
--					end,
--				})
--				
--				return
--			end
--			
--			--如果是pvp模式，那么不允许重玩本关
--			if w and w.data.tdMapInfo and (w.data.tdMapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then
--				hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_PVP_DISBALE_REPLY"],{
--					font = hVar.FONTC,
--					ok = function()
--						--
--					end,
--				})
--				
--				return
--			end
--			
--			hGlobal.event:event("LocalEvent_NextDayBreathe", 0)
--			_frame:show(0)
--			--print("游戏结束后点重玩2")
--			--[[
--			hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_ResetGameTip"],{
--				font = hVar.FONTC,
--				ok = function()
--					--geyachao: 游戏结束已存档，不需要重复存档
--					--存档
--					--LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
--					
--					_chestPoolExitFun()
--					local mapname = hGlobal.WORLD.LastWorldMap.data.map
--					local MapDifficulty = hGlobal.WORLD.LastWorldMap.data.MapDifficulty
--					local MapMode = hGlobal.WORLD.LastWorldMap.data.MapMode
--					if hGlobal.WORLD.LastWorldMap ~= nil and hGlobal.WORLD.LastWorldMap.ID > 0 then
--						hGlobal.WORLD.LastWorldMap:del()
--						hGlobal.WORLD.LastWorldMap = nil
--						
--					end
--					xlScene_LoadMap(g_world, mapname,MapDifficulty,MapMode)
--				end,
--				cancel = function()
--					_frame:show(1)
--				end
--			})
--			]]
--			--geyachao: 游戏结束点重玩，直接重玩，不需要提示了
--			_chestPoolExitFun()
--			local world = hGlobal.WORLD.LastWorldMap
--			if world and (world.ID > 0) then
--				local mapname = world.data.map
--				local MapDifficulty = world.data.MapDifficulty
--				local MapMode = world.data.MapMode
--				
--				world:del()
--				world = nil
--				
--				xlScene_LoadMap(g_world, mapname,MapDifficulty,MapMode)
--			end
--		end,
--	})
--	_childUI["RePlayBtn"].childUI["label"].handle._n:setPosition(-35,12)
--	_childUI["RePlayBtn"].childUI["icon"].handle._n:setPosition(-60,1)
--	
--	local nInterval1 = 68/2		--68为间隔数据（除以2是为了定义下面的数据）
--	local tempxlist = {
--		[1] = {w/2},				
--		[2] = {w/2-nInterval1, w/2+nInterval1},
--		[3] = {w/2-nInterval1*2, w/2, w/2+nInterval1*2},
--		[4] = {w/2-nInterval1*3, w/2-nInterval1, w/2+nInterval1, w/2+nInterval1*3},
--		[5] = {w/2-nInterval1*4, w/2-nInterval1*2, w/2, w/2+nInterval1*2, w/2+nInterval1*4}
--	}		--英雄位置
--	
--	local removeHeroUIList = {}
--	local _removeHeroUIFunc = function()
--		for i = 1,#removeHeroUIList do
--			hApi.safeRemoveT(_childUI,removeHeroUIList[i]) 
--		end
--		removeHeroUIList = {}
--	end
--	--定义英雄
--	local _createHeroItem = function (heroId,i,numHero,nIsWin)
--		--local heroName = hVar.tab_stringU[h.data.id][1]
--		local id = heroId or 0
--		local tmpModel = "MODEL:Default"
--		if hVar.tab_unit[heroId] then
--			tmpModel = hVar.tab_unit[heroId].icon
--		end
--		
--		local interval = 125
--		
--		_childUI["hero_imageBG"..i] = hUI.image:new({
--			parent = _parent,
--			align = "MC",
--			model = "UI:slotSmall",
--			animation = "lightSlim",
--			--x = tempxlist[numHero][i],
--			x = nGameDescribeX - 115 + interval * (i - 1),
--			y = nGameDescribeY - 160,
--			w = 67,
--			h = 67,
--		})
--		removeHeroUIList[#removeHeroUIList + 1] = "hero_imageBG"..i
--		
--		_childUI["icon"..i] = hUI.image:new({
--			parent = _parent,
--			model = tmpModel,
--			w = 58,
--			h = 58,
--			--x = tempxlist[numHero][i],
--			x = nGameDescribeX - 115 + interval * (i - 1),
--			y = nGameDescribeY - 160,
--		})
--		removeHeroUIList[#removeHeroUIList + 1] = "icon"..i
--		
--		if nIsWin == 1 then
--		end
--		local exp = 0
--		local lastLv = 0
--		local world = hGlobal.WORLD.LastWorldMap
--		if world then
--			local mapInfo = world.data.tdMapInfo
--			if mapInfo then
--				--根据游戏模式分别处理
--				local mapMode = mapInfo.mapMode --当前游戏模式
--				local mapDifficulty = mapInfo.mapDifficulty --当前游戏难度
--				if nIsWin == 1 then
--					--exp = (mapInfo.exp or 0) + (mapInfo.expAdd or 0)
--					exp = (mapInfo.exp or 0) + (world:GetPlayerMe():getExpAdd() or 0)
--					if hVar.MAP_TEST and hVar.MAP_TEST[world.data.map] then
--						exp = 0
--					end
--					lastLv = mapInfo.getStarReward["heroLastLv"] and mapInfo.getStarReward["heroLastLv"][id] or 0	--升级前等级
--				elseif  nIsWin == 0 then
--					--如果
--					if mapInfo.totalWave > 3 then
--						--英雄经验值
--						--local expAdd = (mapInfo.exp or 0) + (mapInfo.expAdd or 0)
--						local expAdd = (mapInfo.exp or 0) + (world:GetPlayerMe():getExpAdd() or 0)
--						if mapInfo.wave == mapInfo.totalWave then
--							expAdd = math.floor(expAdd * 0.3) or 0
--						elseif mapInfo.wave == mapInfo.totalWave - 1 then
--							expAdd = math.floor(expAdd * 0.2) or 0
--						elseif mapInfo.wave == mapInfo.totalWave - 2 then
--							expAdd = math.floor(expAdd * 0.1) or 0
--						else
--							expAdd = 0
--						end
--						exp = expAdd
--					end
--					if hVar.MAP_TEST and hVar.MAP_TEST[world.data.map] then
--						exp = 0
--					end
--					if exp > 0 then
--						lastLv = mapInfo.getStarReward["heroLastLv"] and mapInfo.getStarReward["heroLastLv"][id] or 0	--升级前等级
--					end
--				end
--			
--				
--			end
--		end
--		
--		local nowLv = LuaGetHeroLevel(id)			--当前升级后的等级
--		if not lastLv or lastLv == 0 then
--			lastLv = nowLv
--		end
--		
--		--英雄等级背景图
--		_childUI["labLvUpFlagBG"..i]= hUI.image:new({
--			parent = _parent,
--			model = "ui/pvp/pvpselect.png",
--			x = nGameDescribeX - 87 + interval * (i - 1),
--			y = nGameDescribeY - 130,
--			w = 34,
--			h = 34,
--		})
--		removeHeroUIList[#removeHeroUIList + 1] = "labLvUpFlagBG"..i
--		
--		--英雄等级
--		local fontSize = 24
--		if nowLv and (nowLv >= 10) then --如果等级是2位数的，那么缩一下文字
--			fontSize = 16
--		end
--		_childUI["labLvUpFlag"..i] = hUI.label:new({
--			parent = _parent,
--			align  = "MC",
--			x = nGameDescribeX - 87 + interval * (i - 1),
--			y = nGameDescribeY - 130 - 1,
--			--text = "lv".. tostring(nowLv),
--			text = tostring(nowLv),
--			size = fontSize,
--			font = "numWhite",
--			border = 1,
--		})
--		removeHeroUIList[#removeHeroUIList + 1] = "labLvUpFlag"..i
--		
--		--提示英雄可升级
--		if (nowLv > lastLv) then
--			_childUI["imglvUpFlag"..i] = hUI.image:new({
--				parent = _parent,
--				model = "ICON:image_update",
--				--x = tempxlist[numHero][i],
--				x = nGameDescribeX - 101 + interval * (i - 1),
--				y = nGameDescribeY - 171,
--				scale = 0.8,
--			})
--			removeHeroUIList[#removeHeroUIList + 1] = "imglvUpFlag"..i
--		end
--		
--		--经验值图
--		_childUI["labExpFlag"..i] = hUI.image:new({
--			parent = _parent,
--			model = "ICON:HeroAttr",
--			--x = tempxlist[numHero][i],
--			x = nGameDescribeX - 133 + interval * (i - 1),
--			y = nGameDescribeY - 205,
--			scale = 0.35,
--		})
--		removeHeroUIList[#removeHeroUIList + 1] = "labExpFlag"..i
--		
--		_childUI["GetExp"..i] = hUI.label:new({
--			parent = _parent,
--			align  = "MT",
--			x = nGameDescribeX - 106 + interval * (i - 1),
--			y = nGameDescribeY - 198,
--			text = "+".. tostring(exp),
--			size = 12,
--			font = "numGreen",
--			border = 1,
--		})
--		removeHeroUIList[#removeHeroUIList + 1] = "GetExp"..i
--	end
--	
--	
--	------------------------------------------------------------------------------------------
--	--抽卡动画相关
--	------------------------------------------------------------------------------------------
--	local _slotX,_slotY = w/2+50, nBackGroundY - 370
--	local _slotOffX = 100
--	local _CardList = {}		--卡片列表
--	local _CardEndList = {}		--卡片最终列表
--	local _btnList = {}		--卡片btn逻辑列表
--	local _CurActionIndex = -1
--	local _reverseCount = 0
--	local _reverseMaxCount = 0
--	local _dealAction = nil
--	local _dealCount
--	
--	--清除一些本地数据表
--	local _clearTab = function(tab)
--		for i = 1,#tab do
--			hApi.safeRemoveT(_childUI,tab[i][1])
--		end
--		tab = {}
--	end
--	--抽奖面板的关闭方法
--	
--	_chestPoolExitFun = function()
--		G_UI_ReverseItemFrmState = 0
--		_clearTab(_CardList)
--		_clearTab(_CardEndList)
--		_clearTab(_btnList)
--		
--		_CurActionIndex = -1
--		_dealCount = 0
--		_reverseMaxCount = 0
--		_reverseCount = 0
--	end
--	
--	local _setColor = function(node)
--		if _childUI[node] then
--			for k,v in pairs(_childUI[node].childUI) do
--				--v.handle.s:setColor(ccc3(128,128,128))
--				hApi.AddShader(v.handle.s,"gray")			--光芒底线变灰
--			end
--		end
--	end
--	
--	local _ActionCallBackEx_2 = function()
--		--_childUI["closeBtn"]:setstate(1)
--		_childUI["btnOk"]:setstate(1)
--		_childUI["RePlayBtn"]:setstate(1)
--	end
--	
--	
--	local _ActionCallBackEx_1 = function()
--		for i = 1,#_btnList do
--			if _btnList[i][2] == 0 then
--				local node = _CardList[i]
--				_childUI[node[2]].handle._n:setVisible(false)
--				_childUI[node[1]].handle._n:setVisible(true)
--				_setColor(node[1])
--				_childUI[node[1]].handle._n:runAction(CCSequence:createWithTwoActions(CCOrbitCamera:create(0.2,-1,0,90,90,0,0),CCCallFunc:create(_ActionCallBackEx_2)))
--			end
--		end
--	end
--	
--	local _createNodeActionEx = function()
--		for i = 1,#_btnList do
--			if _btnList[i][2] == 0 then
--				local node = _CardList[i]
--				_childUI[node[2]].handle._n:runAction(CCSequence:createWithTwoActions(CCOrbitCamera:create(0.2,1,0,0,90,0,0),CCCallFunc:create(_ActionCallBackEx_1)))
--			end
--		end
--	end
--	
--	--移动到空槽子位
--	local _ActionCallBack_3 = function()
--		local node = _CardList[_CurActionIndex]
--		_childUI[node[1]].handle._n:setVisible(false) --把用来移动的卡片 隐藏掉
--		local endNode = _CardEndList[_CurActionIndex]
--		_childUI[endNode[1]].handle._n:setVisible(true)	--显示出 之前绘制好的 不模糊的卡片
--		
--		_childUI[endNode[1]].childUI["flag"] = hUI.image:new({
--			parent = _childUI[endNode[1]].handle._n,
--			model = "UI:ok",
--			x = 28,
--			y = -40,
--			scale = 0.5,
--		})
--		
--		_reverseCount = _reverseCount + 1
--		if _reverseCount == _reverseMaxCount then
--			
--			_createNodeActionEx(i)
--		end
--		_CurActionIndex = 0
--	end
--	
--	--2次旋转的回调
--	local _ActionCallBack_2 = function()
--		if _reverseCount == _reverseMaxCount then return end
--		local node = _CardList[_CurActionIndex]
--		_ActionCallBack_3()
--		
--		--_childUI[node[1]].handle._n:runAction(CCSequence:createWithTwoActions(CCMoveTo:create(0.2,ccp(_CardList[_CurActionIndex][3],_CardList[_CurActionIndex][4]+40)),CCCallFunc:create(_ActionCallBack_3)))
--	end
--	
--	--第二次旋转
--	local _ActionCallBack_1 = function()
--		local node = _CardList[_CurActionIndex]
--		_childUI[node[2]].handle._n:setVisible(false)
--		_childUI[node[1]].handle._n:setVisible(true)
--		_childUI[node[1]].handle._n:runAction(CCSequence:createWithTwoActions(CCOrbitCamera:create(0.2,-1,0,90,90,0,0),CCCallFunc:create(_ActionCallBack_2)))
--		
--	end
--	
--	--第一次旋转
--	local _createNodeAction = function(index)
--		_CurActionIndex = index
--		local node = _CardList[index]
--		_childUI[node[2]].handle._n:runAction(CCSequence:createWithTwoActions(CCOrbitCamera:create(0.2,1,0,0,90,0,0),CCCallFunc:create(_ActionCallBack_1)))
--		
--	end
--	
--	--发牌动画回调
--	local _dealActionCallBack = function()
--		hApi.addTimerOnce("ActionTimer",200,function()
--			
--			_dealCount = _dealCount +1
--			_dealAction()
--		end)
--	end
--	
--	--发牌动画
--	_dealAction = function()
--		local node = _CardList[_dealCount]
--		--print("_dealAction:"..tostring(_dealCount)..tostring(node))
--		if node then
--			hApi.PlaySound("dealcard")
--			_childUI[node[2]].handle._n:setVisible(true)
--			_childUI[node[2]].handle._n:runAction(CCSequence:createWithTwoActions(CCMoveTo:create(0.05,ccp(_CardList[_dealCount][3],_CardList[_dealCount][4])),CCCallFunc:create(_dealActionCallBack)))
--			
--		else
--			hApi.clearTimer("ActionTimer")
--			_CurActionIndex = 0
--			--_frm:active()
--		end
--	end
--	
--	local _createCard = function(name,id,rewardType,num,x,y)
--		--卡片node 
--		_childUI[name] = hUI.node:new({
--			parent = _parent,
--			x = x,
--			y = y,
--		})
--		
--		--卡片底图
--		_childUI[name].childUI["bg"] = hUI.image:new({
--			parent = _childUI[name].handle._n,
--			--model = hApi.GetTacticsCardGB(maxlv,lv),
--			model = "UI:pvpprivatesb1",
--			scale = 0.6,
--		})
--		
--		--道具显示品质背景图
--		--(1:积分 / 2:战术技能卡 / 3:道具 / 4:英雄 / 5:英雄将魂 / 6:战术技能卡碎片 / 7:游戏币 / 8:网络宝箱 / 9:抽奖类战术技能卡 / 10:神器 / 11:神器晶石)
--		if (rewardType == 3) then
--			_childUI[name].childUI["colorBG"] = hUI.image:new({
--				parent = _childUI[name].handle._n,
--				model = "UI:item1",
--				x = 0,
--				y = 15,
--				w = 64,
--				h = 64,
--			})
--			
--			local itemLv = hVar.tab_item[id].itemLv or 1
--			local itemtModel = hVar.ITEMLEVEL[itemLv].ITEMMODEL
--			_childUI[name].childUI["color"] = hUI.image:new({
--				parent = _childUI[name].handle._n,
--				model = itemtModel,
--				x = 0,
--				y = 15,
--				w = 64,
--				h = 64,
--			})
--			--卡片icon
--			_childUI[name].childUI["icon"] = hUI.image:new({
--				parent = _childUI[name].handle._n,
--				model = hVar.tab_item[id].icon,
--				y = 15,
--				w = 64 - 8,
--				h = 64 - 8,
--			})
--		else
--			--卡片icon
--			_childUI[name].childUI["icon"] = hUI.image:new({
--				parent = _childUI[name].handle._n,
--				model = hVar.tab_item[id].icon,
--				y = 15,
--				w = 64,
--				h = 64,
--			})
--		end
--		
--		
--		----类型图标
--		--_childUI[name].childUI["typeicon"]= hUI.image:new({
--		--	parent = _childUI[name].handle._n,
--		--	model = hApi.GetTacticsCardTypeIcon(id,"model"),
--		--	x = -3,
--		--	y = 57,
--		--	--scale = 0.4,
--		--})
--		
--		--碎片显示碎片图标
--		--(1:积分 / 2:战术技能卡 / 3:道具 / 4:英雄 / 5:英雄将魂 / 6:战术技能卡碎片 / 7:游戏币 / 8:网络宝箱 / 9:抽奖类战术技能卡 / 10:神器 / 11:神器晶石)
--		if (rewardType == 5) or (rewardType == 6) then
--			_childUI[name].childUI["debris"] = hUI.image:new({
--				parent = _childUI[name].handle._n,
--				model = "UI:SoulStoneFlag",
--				x = 16,
--				y = 5,
--				w = 41,
--				h = 60,
--			})
--		end
--		
--		--获取数量
--		_childUI[name].childUI["num"] = hUI.label:new({
--			parent =_childUI[name].handle._n,
--			x = 25 + 5,
--			y = -5,
--			--size = 18,
--			size = 18,
--			align = "RC",
--			border = 1,
--			--font = hVar.FONTC,
--			font = "numWhite",
--			width = 400,
--			--text = tostring(num),
--			text = "+" .. tostring(num),
--		})
--		
--		--名字
--		local strName = (hVar.tab_stringI[id][1])
--		local nameSize = 22
--		--print(#strName)
--		if (#strName > 12) then
--			nameSize = 18
--		elseif (#strName > 9) then
--			nameSize = 19
--		end
--		_childUI[name].childUI["info"] = hUI.label:new({
--			parent =_childUI[name].handle._n,
--			y = -32,
--			size = nameSize,
--			align = "MC",
--			border = 1,
--			font = hVar.FONTC,
--			width = 400,
--			text = strName,
--		})
--		--道具显示颜色
--		if (rewardType == 3) and hVar.tab_item[id] then
--			local itemLv = hVar.tab_item[id].itemLv or 1
--			local RGB = hVar.ITEMLEVEL[itemLv].NAMERGB
--			_childUI[name].childUI["info"].handle.s:setColor(ccc3(RGB[1], RGB[2], RGB[3]))
--		end
--	end
--	
--	--创建难度模式，通关后的抽卡列表
--	local _createCardList = function(name,px,py,poffx,list,slotNum)
--		_reverseMaxCount = slotNum
--		for i = 1,#_CardList do
--			hApi.safeRemoveT(_childUI,_CardList[i][1])
--			hApi.safeRemoveT(_childUI,_CardList[i][2])
--		end
--		_CardList = {}
--		
--		for i = 1,#_CardEndList do
--			hApi.safeRemoveT(_childUI,_CardEndList[i][1])
--		end
--		_CardEndList = {}
--		
--		for i = 1,#_btnList do
--			hApi.safeRemoveT(_childUI,_btnList[i][1])
--		end
--		_btnList = {}
--		
--		_CurActionIndex = -1
--		local num = #list
--		
--		for i = 1,num do
--			--卡片背景 card_back
--			local x,y =  math.floor(px -num *poffx/2 + (i-1)*poffx),math.floor(py)
--			
--			local rewardType = list[i][1] or 1
--			local itemId = list[i][2] or 0
--			local itemNum = 1
--			local exValueRatio = 0
--			
--			if hVar.tab_item[itemId] == nil then 
--				_ActionCallBackEx_2()
--				--print("_createCardList faild there is error item:",itemId)
--				return 
--			end
--			
--			--积分
--			if rewardType == 1 then
--				--如果是道具id则取道具中填的值
--				if hVar.tab_item[itemId] and hVar.tab_item[itemId].type == hVar.ITEM_TYPE.RESOURCES then
--					local resT = hVar.tab_item[itemId].resource
--					if resT and type(resT) == "table" and resT[1] == "score" then
--						itemNum = resT[2] or 0
--					else
--						itemNum = 0
--					end
--				--如果不是道具id则直接认为是积分的金额
--				else
--					itemNum = list[i][2] or 0
--				end
--			--武器装备
--			elseif rewardType == 3 then
--				exValueRatio = list[i][3] or 0
--			--英雄将魂碎片或战术技能卡碎片
--			elseif rewardType == 5 or rewardType == 6 then
--				itemNum = list[i][3] or 1
--			end
--			
--			--用作旋转动画的卡片
--			_CardList[#_CardList+1] = {name..i,name.."_back_"..i,x,y}
--			_createCard(name..i,itemId,rewardType,itemNum,x,y)
--			_childUI[name..i].handle._n:setVisible(false)
--			
--			--最后会显示出现的卡片
--			_CardEndList[#_CardEndList + 1] = {name.."end_"..i}
--			--_createCard(name.."end_"..i,itemId,rewardType,itemNum,x,y+40) --zhenkira 不让它向上移了
--			_createCard(name.."end_"..i,itemId,rewardType,itemNum,x,y)
--			_childUI[name.."end_"..i].handle._n:setVisible(false)
--			
--			--背景
--			_childUI[name.."_back_"..i] = hUI.node:new({
--				parent = _parent,
--				x = w-20,
--				y = y,
--			})
--			--卡片背景
--			_childUI[name.."_back_"..i].childUI["back"] = hUI.image:new({
--				parent = _childUI[name.."_back_"..i].handle._n,
--				--model = "UI:card_back",
--				model = "UI:cardbg1",
--				scale = 0.6,
--				
--			})
--			_childUI[name.."_back_"..i].handle._n:setVisible(false)
--			
--			--具体的操作按钮
--			_childUI[name.."_btn_"..i] = hUI.button:new({
--				x = x,
--				y = y,
--				w = 120,
--				h = 150,
--				model = -1,
--				parent = _parent,
--				dragbox = _childUI["dragBox"],
--				--按下道具图标事件
--				codeOnTouch = function(self, touchX, touchY, sus)
--					if _btnList[i][2] == 1 and _CurActionIndex == 0 then
--						if _btnList[i][7] then
--							if g_phone_mode ~= 0 then
--								hGlobal.event:event("LocalEvent_ShowItemTipFram", {_btnList[i][7]}, nil, 1, hVar.SCREEN.w /2 - 210, 480, 0)
--								--hGlobal.event:event("localEvent_ShowBattlefieldSkillInfoFrm",skillID,skillLV,hVar.SCREEN.w /2 - 210 ,480,1,0)
--							else
--								hGlobal.event:event("LocalEvent_ShowItemTipFram", {_btnList[i][7]}, nil, 1, 300, 550, 0)
--								--hGlobal.event:event("localEvent_ShowBattlefieldSkillInfoFrm",skillID,skillLV,300,550,1,0)
--							end
--							
--						end
--					end
--				end,
--				code = function(self)
--					if _CurActionIndex == 0 and _reverseMaxCount > _reverseCount and _btnList[i][2] == 0 then
--						
--						--领取奖励
--						local rewardType = _btnList[i][3] or 0		--获取类型
--						--print("TD_OnGameOver rewardType[".. tostring(i) .."]:".. tostring(rewardType))
--						if rewardType == 1 then				--1积分
--							local addScore = _btnList[i][5] or 0
--							if addScore>0 then
--								LuaAddPlayerScore(addScore)
--								local map_get_score = LuaGetPlayerMapAchi(mapname,hVar.ACHIEVEMENT_TYPE.Map_GetScore) or 0
--								map_get_score = map_get_score + addScore
--								LuaSetPlayerMapAchi(mapname,hVar.ACHIEVEMENT_TYPE.Map_GetScore,map_get_score)
--							end
--						elseif rewardType == 3 then			--3道具
--							local itemId = _btnList[i][4] or 0
--							local exValueRatio = _btnList[i][6] or 0
--							if itemId > 0 and hVar.tab_item[itemId] then
--							local a, b	
--							a, b,_btnList[i][7] = LuaAddItemToPlayerBag(itemId,nil,nil,exValueRatio)
--							end
--						elseif rewardType == 5 then			--5将魂
--							local itemId = _btnList[i][4] or 0
--							local itemNum = _btnList[i][5] or 0
--							if itemId > 0 and hVar.tab_item[itemId] and itemNum > 0 then
--								local heroId = hVar.tab_item[itemId].heroID or 0
--								if heroId > 0 and hVar.tab_unit[heroId] then
--									--添加英雄将魂
--									LuaAddHeroCardSoulStone(heroId, itemNum)
--								end
--							end
--						elseif rewardType == 6 then			--6战术技能卡碎片
--							local itemId = _btnList[i][4] or 0
--							local itemNum = _btnList[i][5] or 0
--							if itemId > 0 and hVar.tab_item[itemId] and itemNum > 0 then
--								local tacticId = hVar.tab_item[itemId].tacticID or 0
--								if tacticId > 0 and hVar.tab_tactics[tacticId] then
--									--添加战术技能卡碎片
--									local ret = LuaAddPlayerTacticDebris(tacticId, itemNum)
--								end
--							end
--						end
--						
--						--领完保存
--						LuaSaveHeroCard()
--						xlDeleteFileWithFullPath(g_localfilepath..g_curPlayerName..hVar.SAVE_DATA_PATH.MAP_SAVE)
--						xlDeleteFileWithFullPath(g_localfilepath..g_curPlayerName..hVar.SAVE_DATA_PATH.FOG)
--						--删除最近3天的存档
--						LuaDeletePlayerAutoSave(g_curPlayerName)
--						LuaClearLootFromUnit(g_curPlayerName)
--						
--						LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
--						
--						--各种动画效果
--						_childUI["break_down_eff_"..i] =hUI.image:new({
--							parent = _parent,
--							model = "MODEL_EFFECT:break_down",
--							x = x,
--							y = y,
--							w = 180,
--							h = 180,
--						})
--						hApi.PlaySound("eff_pickup")
--						hApi.addTimerOnce("break_down_eff",250,function()
--							hApi.safeRemoveT(_childUI,"break_down_eff_"..i)
--						end)
--						_btnList[i][2] = 1
--						_createNodeAction(i)
--						
--					elseif _btnList[i][2] == 1 and _CurActionIndex == 0 then
--						
--						hGlobal.event:event("LocalEvent_ShowItemTipFram", nil, nil, 0)
--						--if _btnList[i][7] then
--						--	if g_phone_mode ~= 0 then
--						--		hGlobal.event:event("LocalEvent_ShowItemTipFram", {_btnList[i][7]}, nil, 1, hVar.SCREEN.w /2 - 210, 480, 0)
--						--		--hGlobal.event:event("localEvent_ShowBattlefieldSkillInfoFrm",skillID,skillLV,hVar.SCREEN.w /2 - 210 ,480,1,0)
--						--	else
--						--		hGlobal.event:event("LocalEvent_ShowItemTipFram", {_btnList[i][7]}, nil, 1, 300, 550, 0)
--						--		--hGlobal.event:event("localEvent_ShowBattlefieldSkillInfoFrm",skillID,skillLV,300,550,1,0)
--						--	end
--						--end
--					end
--				end,
--			})
--			_btnList[#_btnList+1] =  {name.."_btn_"..i,0,rewardType,itemId,itemNum,exValueRatio}
--			
--		end
--		_dealCount = 1
--		_dealAction()
--		--创建槽子数
--		--_createCardSlot(px,py,poffx,slotNum)
--	end
--	CCDirector:sharedDirector():setDepthTest(false)
--	
--	------------------------------------------------------------------------------------------
--	--显示游戏结束面板
--	------------------------------------------------------------------------------------------
--	local StarList = {}
--	_CODE_ShowGameOverPanel = function(nIsWin)
--		
--		print("游戏结束——————游戏结束———————游戏结束显示界面")
--		
--		local world = hGlobal.WORLD.LastWorldMap
--		local mapInfo = world.data.tdMapInfo
--		
--		hApi.PlaySoundBG(g_channel_world,0)
--		
--		--清空之前创造的 评价星星 和 任务奖励
--		for i = 1, #StarList, 1 do
--			hApi.safeRemoveT(_childUI, StarList[i])
--		end
--		StarList = {}
--		
--		local content = nil									--保存标题：“通关” 或 “失败”
--		local nSize = nil									--记录标题（“通关”，“失败”）大小
--		local nAwardNum = 1									--记录奖励的种类个数（用以排版）
--		local listAward = {}									--记录奖励单位的名字，图标，还有个数（用以排版）
--		local cur_mapname = world.data.map					--例如：“world/level_hjzl”(黄巾之乱)
--		local scoreV = 0
--		
--		--[通关奖励]
--		--数值,游戏时间,战斗分数
--		local pLog = world:getplayerlog(heroGameRule.selfPlayerIndex)
--		if pLog ~= nil then
--			scoreV = pLog.scoreV
--		end
--		scoreV = mapInfo.getScoreV or 0
--		
--		--【根据输赢，控制部件的显示，和任务奖励的创建】
--		if nIsWin==1 then									--通关
--			--_childUI["Resource_background1"].handle._n:setVisible(true)
--			_childUI["GetScore1"]:setText("+"..tostring(scoreV))
--			_childUI["labDefProgress"]:setText("")
--			_childUI["labDefProgressNum"]:setText("")
--			_childUI["labKillUnit"]:setText("")
--			_childUI["labKillUnitNum"]:setText("")
--			
--			--设置“通关”的图标
--			if 4 == LANGUAG_SITTING then							--语言设置： 1按照默认 2简体(强制) 3繁体(强制) 4英语(强制)
--				content = "UI:wine"
--				nSize = {202,118}
--			else
--				content = "UI:winj"
--				nSize = {192,100}
--			end
--			--hApi.PlaySound("win_sound")
--			
--			if mapInfo and mapInfo.getStarReward then
--				local tempW,tempH,tmpModel,itemName = -1,-1, "MODEL:Default", ""
--				for i = 1, #mapInfo.getStarReward do
--					local reward = mapInfo.getStarReward[i]
--					local itemType = reward[1]
--					local itemID = reward[2]					--ID
--					local itemNum = reward[3] or 1					--数量(道具类型默认为1)
--					local itemLv = reward[4]					--数量
--					
--					if itemType == 1 then
--						tmpModel = "UI:score"
--						itemName = hVar.tab_string["ios_score"]
--						itemNum = itemID
--					elseif itemType == 2 then						--战术技能卡
--						if hVar.tab_tactics[itemID] then
--							tmpModel = hVar.tab_tactics[itemID].icon
--						end
--						if hVar.tab_stringT[itemID] then
--							itemName = hVar.tab_stringT[itemID][1]
--						else
--							itemName = "T"..tostring(itemID)
--						end	
--					elseif itemType == 3 then		--道具
--						tempW,tempH = 68,68
--						
--						if hVar.tab_item[itemID] then
--							tmpModel = hVar.tab_item[itemID].icon
--						end
--						if hVar.tab_stringI[itemID] then
--							itemName = hVar.tab_stringI[itemID][1]
--						else
--							itemName = "I"..tostring(itemID)
--						end
--					elseif itemType == 5 or itemType == 6 then		--将魂、战术技能卡碎片
--						if hVar.tab_item[itemID] and hVar.tab_item[itemID].type == hVar.ITEM_TYPE.RESOURCES and hVar.tab_item[itemID].icon == "ui/score.png" then
--							tempW,tempH = 51,51
--						end
--						if hVar.tab_item[itemID] then
--							tmpModel = hVar.tab_item[itemID].icon
--						end
--						if hVar.tab_stringI[itemID] then
--							itemName = hVar.tab_stringI[itemID][1]
--						else
--							itemName = "I"..tostring(itemID)
--						end
--					elseif itemType == 4 then
--						if hVar.tab_unit[itemID] then
--							tempW,tempH = 51,51
--							tmpModel = hVar.tab_unit[itemID].icon
--						end
--						if hVar.tab_stringU[itemID] then
--							itemName = hVar.tab_stringU[itemID][1]
--						else
--							itemName = "H"..tostring(itemID)
--						end
--						
--					end
--					
--					local offX = -320
--					local offY = -40 + 6 --普通关卡模式
--					local interval = 160
--					
--					local MapMode = hGlobal.WORLD.LastWorldMap.data.MapMode
--					if MapMode == hVar.MAP_TD_TYPE.DIFFICULT then --困难关卡模式
--						offX = -115
--						offY = 80
--						interval = 125
--					end
--				
--					local __x = nAwardX + offX + nAwardNum*interval
--					local __y = nAwardY + offY
--					
--					--道具显示品质背景图
--					--(1:积分 / 2:战术技能卡 / 3:道具 / 4:英雄 / 5:英雄将魂 / 6:战术技能卡碎片 / 7:游戏币 / 8:网络宝箱 / 9:抽奖类战术技能卡 / 10:神器 / 11:神器晶石)
--					--print(itemType, tempW, tempH)
--					if (itemType == 3) then
--						_childUI["itemImageBG_"..i] = hUI.image:new({
--							parent = _parent,
--							model = "UI:item1",
--							x = __x,
--							y = __y - 10,
--							w = tempW,
--							h = tempH,
--						})
--						StarList[#StarList+1] = "itemImageBG_"..i
--						
--						--任务奖励（比如 青铜箱子）
--						_childUI["itemImage_"..i] = hUI.image:new({
--							parent = _parent,
--							model = tmpModel,
--							x = __x,
--							y = __y - 10,
--							w = tempW - 8,
--							h = tempH - 8,
--						})
--						StarList[#StarList+1] = "itemImage_"..i
--						
--						local itemLv = hVar.tab_item[itemID].itemLv or 1
--						local itemtModel = hVar.ITEMLEVEL[itemLv].ITEMMODEL
--						_childUI["itemImageColor_"..i] = hUI.image:new({
--							parent = _parent,
--							model = itemtModel,
--							x = __x,
--							y = __y - 10,
--							w = tempW,
--							h = tempH,
--						})
--						StarList[#StarList+1] = "itemImageColor_"..i
--					else
--						--任务奖励（比如 青铜箱子）
--						_childUI["itemImage_"..i] = hUI.image:new({
--							parent = _parent,
--							model = tmpModel,
--							x = __x,
--							y = __y - 10,
--							w = tempW,
--							h = tempH,
--						})
--						StarList[#StarList+1] = "itemImage_"..i
--					end
--					
--					--名字
--					local strName = (itemName or itemID)
--					local nameSize = 24
--					--print(#strName)
--					if (#strName > 15) then
--						nameSize = 22
--					end
--					_childUI["itemName_"..i] = hUI.label:new({
--						parent = _parent,
--						align = "MT",
--						text = strName,
--						font = hVar.FONTC,
--						border = 1,
--						width = 300,
--						x = _childUI["itemImage_"..i].data.x,
--						y = __y + 48,
--						size = nameSize,
--						--RGB = {0,255,0},
--					})
--					--道具显示颜色
--					if (itemType == 3) and hVar.tab_item[itemID] then
--						local itemLv = hVar.tab_item[itemID].itemLv or 1
--						local RGB = hVar.ITEMLEVEL[itemLv].NAMERGB
--						_childUI["itemName_"..i].handle.s:setColor(ccc3(RGB[1], RGB[2], RGB[3]))
--					end
--					
--					--_childUI["itemName_"..i]:setText(itemName or itemID)
--					StarList[#StarList+1] = "itemName_"..i
--					
--					--碎片显示碎片图标
--					--(1:积分 / 2:战术技能卡 / 3:道具 / 4:英雄 / 5:英雄将魂 / 6:战术技能卡碎片 / 7:游戏币 / 8:网络宝箱 / 9:抽奖类战术技能卡 / 10:神器 / 11:神器晶石)
--					--print(itemType)
--					if (itemType == 5) or (itemType == 6) then
--						_childUI["itemDeribs_"..i] = hUI.image:new({
--							parent = _parent,
--							model = "UI:SoulStoneFlag",
--							x = _childUI["itemImage_"..i].data.x + 18,
--							y = _childUI["itemImage_"..i].data.y - 10,
--							w = 41,
--							h = 60,
--						})
--						StarList[#StarList+1] = "itemDeribs_"..i
--					end
--					
--					--数量
--					_childUI["itemNum_"..i] = hUI.label:new({
--						parent = _parent,
--						align = "MT",
--						text = "+"..itemNum,
--						font = "numWhite",
--						border = 1,
--						width = 100,
--						size = 16,
--						x = _childUI["itemImage_"..i].data.x,
--						y = _childUI["itemImage_"..i].data.y - 33,
--					})
--					StarList[#StarList+1] = "itemNum_"..i
--					
--					nAwardNum = nAwardNum + 1
--					listAward[nAwardNum] = {[1] = "itemImage_"..i,[2] = "itemName_"..i, [3] = "itemNum_"..i}
--				end
--			end
--			
--			if nAwardNum > 1 then
--				_childUI["labRewardAll"].handle._n:setVisible(false)
--			else
--				_childUI["labRewardAll"].handle._n:setVisible(true)
--			end
--			
--			--(显示属性)“下一关”,"主界面","退回一天","退回三天","重玩本关"
--			local nextmap = hApi.GetNextMapNameEx(cur_mapname)
--			if nextmap ~= nil then
--				--_childUI["btnNext"]:setstate(1) --zhenkira
--				--_childUI["btnOk"]:setstate(-1) --zhenkira
--				_childUI["btnNext"]:setstate(-1)
--				_childUI["btnOk"]:setstate(1)
--			else
--				_childUI["btnNext"]:setstate(-1)		
--				_childUI["btnOk"]:setstate(1)
--			end
--			
--			_childUI["RePlayBtn"]:setstate(1)
--			--_childUI["tipBtn"]:setstate(-1)							--“？”按钮
--			
--			--(位置属性)“重玩本关”,“下一关”,“主界面”(在打到没有下一关的时候,会显示"主界面"按钮)
--			_childUI["RePlayBtn"]:setXY(nButtonX - 140, nButtonY - 175)
--			_childUI["btnNext"]:setXY(nButtonX + 140, nButtonY - 175)
--			_childUI["btnOk"]:setXY(nButtonX + 140,nButtonY - 175)
--			
--			_childUI["LightStar_image"].handle._n:setVisible(true)				--显示光芒
--			hApi.AddShader(_childUI["LightLine_image"].handle.s,"normal")			--光芒底线变亮
--			
--		else
--			--_childUI["Resource_background1"].handle._n:setVisible(false)
--			_childUI["GetScore1"]:setText("+"..tostring(scoreV))
--			
--			if (hGlobal.WORLD.LastWorldMap.data.MapMode ~= hVar.MAP_TD_TYPE.ENDLESS) then
--				_childUI["labDefProgress"]:setText(hVar.tab_string["__TEXT_DefProgress"] .. ":") --"防守进度"
--				_childUI["labDefProgressNum"]:setText((mapInfo.wave).."/"..(mapInfo.totalWave))
--				_childUI["labKillUnit"]:setText(hVar.tab_string["__TEXT_KillUnit"] .. ":")
--				_childUI["labKillUnitNum"]:setText((world.data.statistics.killEnemyNum))
--			else
--				_childUI["labDefProgress"]:setText("")
--				_childUI["labDefProgressNum"]:setText("")
--				_childUI["labKillUnit"]:setText("")
--				_childUI["labKillUnitNum"]:setText("")
--			end
--			
--			--hApi.PlaySound("game_lose")
--			
--			--设置“失败”的图标
--			if 4 == LANGUAG_SITTING then							--语言设置 1按照默认 2简体(强制) 3繁体(强制) 4英语(强制)
--				content = "UI:losee"
--				nSize = {238,132}
--			else
--				content = "UI:losej"
--				nSize = {200,104}
--			end
--			
--			----判断是否开启通关提示("?"按钮)
--			--if hVar.MAP_INFO[cur_mapname].lostTip then
--			--	_childUI["tipBtn"]:setstate(1)
--			--	_childUI["tipBtn"].handle._n:runAction(CCRepeatForever:create(CCJumpBy:create(0.3,ccp(0,0),4,1)))	--使提示按钮 跳动
--			--	if hVar.MAP_INFO[cur_mapname].lostWeb then 
--			--		tipFrm.childUI["yqts_btn"]:setstate(1)
--			--	else
--			--		tipFrm.childUI["yqts_btn"]:setstate(-1)
--			--	end
--			--else
--			--	_childUI["tipBtn"]:setstate(-1)
--			--end
--			
--			--（显示属性）
--			_childUI["btnOk"]:setstate(1)							--主界面
--			_childUI["btnNext"]:setstate(-1)						--下一关
--			
--			--(位置属性)“重玩本关”,“下一关”,“主界面”(在打到没有下一关的时候,会显示"主界面"按钮)
--			_childUI["RePlayBtn"]:setXY(nButtonX - 140, nButtonY - 175)
--			_childUI["btnNext"]:setXY(nButtonX + 140, nButtonY - 175)
--			_childUI["btnOk"]:setXY(nButtonX + 140,nButtonY - 175)
--			
--			_childUI["LightStar_image"].handle._n:setVisible(false)				--隐藏光芒
--			hApi.AddShader(_childUI["LightLine_image"].handle.s,"gray")			--光芒底线变灰
--			
--			_childUI["labRewardAll"].handle._n:setVisible(false)
--		end
--		
--		--[标题“成功”或“失败”]
--		_childUI["WinOrLose_image"].handle._n:setVisible(true)
--		_childUI["WinOrLose_image"]:setmodel(content,nil,nil,nSize[1],nSize[2])			--nSize[1],nSize[2]中保持有content中图标的款和高
--		
--		--[创建使用英雄]begin-----------------------------------------------------
--		
--		--清理英雄
--		_removeHeroUIFunc()
--		
--		local maxNum = 5
--		--创建英雄
--		local heroes = world:GetSelectedHeroList()			--获取自己的英雄列表
--		local num = math.min(#heroes,maxNum)
--		if num > 0 then
--			for i = 1,num do
--				_createHeroItem(heroes[i], i, num, nIsWin)
--			end
--		end
--		--[创建使用英雄]end-----------------------------------------------------
--		
--		--[评价星星]
--		--zhenkira
--		local miniSta = 1
--		local maxStar = 1
--		if nIsWin == 1 then
--			local totalLife = mapInfo.totalLife
--			--local life = mapInfo.life
--			local life = 0
--			local me = world:GetPlayerMe()
--			if me then
--				local force = me:getforce()
--				local forcePlayer = world:GetForce(force)
--				if forcePlayer then
--					life = forcePlayer:getresource(hVar.RESOURCE_TYPE.LIFE)
--				end
--			end
--			--if life >= math.ceil(totalLife * 0.9) then
--			--	maxStar = 3
--			--elseif life >= math.ceil(totalLife * 0.5) then
--			--	maxStar = 2
--			--end
--			if life >= 9 then
--				maxStar = 3
--			elseif life >= 5 and life <= 8 then
--				maxStar = 2
--			end
--		else
--			miniSta = 0
--			maxStar = 0
--		end
--		
--		--如果是boss关卡，星级直接为3
--		local isBoss = hApi.CheckMapIsBoss(cur_mapname)
--		if isBoss then
--			if nIsWin == 1 then
--				maxStar = 3
--			else
--				miniSta = 0
--				maxStar = 0
--			end
--		end
--		
--		--local miniSta,maxStar ,starmini,starmax = nScore%2,math.ceil(nScore/2),"UI:star_half","UI:STAR_YELLOW"	--ceil是向上取值的
--		local starmini,starmax = "UI:star_half","UI:STAR_YELLOW"	--ceil是向上取值的
--		for i = 1,maxStar do
--			--奇数（miniSta == 1）
--			local model = starmax
--			--if miniSta == 1 and i == maxStar then
--			--	model = starmini
--			--end
--			
--			_childUI["star_"..i] = hUI.image:new({
--				parent = _parent,
--				model = model,
--				w = 64,
--				h = 64,
--				x =  nGameDescribeX - 75 + (i-1)*79,
--				y = nGameDescribeY -54,
--				scale = 0.9,
--			})
--			_childUI["star_"..i].handle._n:setVisible(false)
--			_childUI["star_"..i].handle.s:runAction(CCScaleTo:create(0,2.5))		--缩放
--			StarList[#StarList+1] = "star_"..i
--		end
--		
--		--显示画面
--		if _frame.data.show==0 then
--			--关闭由程序创建的4个 按钮，分别是网络商店，结束一天，系统菜单按钮
--			_frame:show(1)
--		end
--		
--		--评价星星入场动画
--		local nIndex = 0
--		local ActionStar = hApi.DoNothing
--		ActionStar = function()
--			if nIndex < maxStar then
--				nIndex = nIndex + 1
--				hApi.addTimerOnce("ActionOne",((nIndex == 1) and 100) or 10,function()		--第一个星星弹出之前的时间间隔长一些，因为画面的打开需要一定的时间
--					_childUI["star_"..nIndex].handle._n:setVisible(true)
--					local scaleA = CCScaleTo:create(0.1,0.85)
--					local funcA = CCCallFunc:create(ActionStar)
--					local action = CCSequence:createWithTwoActions(scaleA,funcA)
--					_childUI["star_"..nIndex].handle.s:runAction(action)
--				end)
--			else
--				bIsStarShow = true
--				
--				--星星动画播放结束后，如果是挑战难度，则出现抽卡界面。
--				local MapMode = hGlobal.WORLD.LastWorldMap.data.MapMode
--				if nIsWin == 1 then
--					if MapMode == hVar.MAP_TD_TYPE.DIFFICULT then
--						if mapInfo.chestPool and type(mapInfo.chestPool) == "table" and #mapInfo.chestPool == 5 then
--							_childUI["btnOk"]:setstate(0)
--							_childUI["RePlayBtn"]:setstate(0)
--							_childUI["labRewardAll"].handle._n:setVisible(false)
--							_chestPoolExitFun()
--							G_UI_ReverseItemFrmState = 1
--							local mapDifficulty = mapInfo.mapDifficulty --当前游戏难度
--							--_createCardList("card_Node_",_slotX,_slotY,_slotOffX,mapInfo.chestPool,math.max(mapDifficulty or 1, 1))
--							_createCardList("card_Node_",_slotX,_slotY,_slotOffX,mapInfo.chestPool,3)
--						end
--					end
--				end
--			end
--		end
--		ActionStar()
--		
--		local MapMode = hGlobal.WORLD.LastWorldMap.data.MapMode
--		if (MapMode == hVar.MAP_TD_TYPE.ENDLESS) then --geyachao: 无尽模式，显示一些额外的控件
--			_childUI["Score_image"].handle._n:setVisible(false)
--			_childUI["GetScoreName"].handle._n:setVisible(false)
--			_childUI["GetScore1"].handle._n:setVisible(false)
--			_childUI["ScoreReward"].handle._n:setVisible(false)
--			_childUI["labRewardAll"].handle._n:setVisible(false)
--			
--			_childUI["GetCombatEva"].handle._n:setVisible(true)
--			--_childUI["GetCombatEva"]:setText("本次战绩") --language
--			_childUI["GetCombatEva"]:setText(hVar.tab_string["PVPFightMarkThisTime"]) --language
--			_childUI["GetCombatEvaNum"].handle._n:setVisible(true)
--			_childUI["GetCombatEvaNum"]:setText(tostring(mapInfo.combatEva))
--			
--			--无尽模式，不显示失败小贴士
--			hApi.CreateFailHintFrame(0)
--		else
--			_childUI["Score_image"].handle._n:setVisible(true)
--			_childUI["GetScoreName"].handle._n:setVisible(true)
--			_childUI["GetScore1"].handle._n:setVisible(true)
--			_childUI["ScoreReward"].handle._n:setVisible(true)
--			_childUI["GetCombatEva"].handle._n:setVisible(false)
--			_childUI["GetCombatEvaNum"].handle._n:setVisible(false)
--			
--			if (nIsWin == 1) then --胜利
--				--"获得奖励"文字
--				_childUI["ScoreReward"]:setXY(nGameDescribeX - 285, nGameDescribeY - 240)
--				
--				--积分图标
--				_childUI["Score_image"].handle._n:setScale(1.0)
--				_childUI["Score_image"]:setXY(nGameDescribeX - 115, nGameDescribeY - 280 - 10)
--				
--				--积分名称
--				_childUI["GetScoreName"].handle._n:setVisible(true)
--				
--				--积分数值
--				_childUI["GetScore1"]:setXY(_childUI["Score_image"].data.x, _childUI["Score_image"].data.y - 35)
--			else --失败
--				--"获得奖励"文字
--				_childUI["ScoreReward"]:setXY(nGameDescribeX - 285, nGameDescribeY - 240 + 10)
--				
--				--积分图标
--				_childUI["Score_image"].handle._n:setScale(0.5)
--				_childUI["Score_image"]:setXY(nGameDescribeX - 115 - 15, nGameDescribeY - 280 - 10 + 50)
--				
--				--积分名称
--				_childUI["GetScoreName"].handle._n:setVisible(false)
--				
--				--积分数值
--				_childUI["GetScore1"]:setXY(_childUI["Score_image"].data.x + 36, _childUI["Score_image"].data.y - 35 + 42)
--			end
--			
--			--显示失败小贴士
--			hApi.CreateFailHintFrame(1 - nIsWin)
--		end
--		
--		--geyacho: 如果是无尽模式，显示额外的
--		local w = hGlobal.WORLD.LastWorldMap
--		local mapInfo = w.data.tdMapInfo
--		local mapMode = mapInfo.mapMode --当前游戏模式
--		if (mapMode == hVar.MAP_TD_TYPE.ENDLESS) then --无尽模式
--			local pLog = w:getplayerlog(hGlobal.LocalPlayer.data.playerId)
--			if pLog then
--				local combatEva = pLog.endlessCurrentScore --无尽模式本次值
--				local combatHistory = pLog.endlessLastScore or 0 --无尽模式历史最高值
--				--读取今日最高战绩
--				local mapName = hGlobal.WORLD.LastWorldMap.data.map --地图名
--				local bId = 0 --billId
--				local bUpload = false
--				for i = 1, #hVar.BILL_BOARD_MAP, 1 do
--					if (hVar.BILL_BOARD_MAP[i].mapName == mapName) then
--						bId = hVar.BILL_BOARD_MAP[i].bid
--						bUpload = hVar.BILL_BOARD_MAP[i].bUpload
--						break
--					end
--				end
--				local scoreTodayMax = LuaGetPlayerBillBoard(g_curPlayerName, bId) --今日的最高战绩
--				
--				--无尽模式，去掉失败的图标
--				_childUI["WinOrLose_image"].handle._n:setVisible(false)
--				
--				--有光芒
--				_childUI["LightStar_image"].handle._n:setVisible(true) --显示光芒
--				hApi.AddShader(_childUI["LightLine_image"].handle.s,"normal") --光芒底线变亮
--				
--				--绘制今日最高战绩
--				_childUI["HistoryBestScore"] = hUI.label:new({
--					parent = _parent,
--					align  = "RT",
--					x = nBackGroundX + 30,
--					y = nBackGroundY - 270,
--					--text = "今日最高战绩", --language
--					text = hVar.tab_string["__TEXT_HistoryEvaluation"], --language
--					--font = "numWhite",
--					font = hVar.FONTC,
--					size = 32,
--					border = 1,
--					width = 300,
--				})
--				_childUI["HistoryBestScore"].handle.s:setColor(ccc3(192, 192, 192))
--				StarList[#StarList+1] = "HistoryBestScore"
--				
--				--今日最高战绩值
--				_childUI["HistoryBestScoreNum"] = hUI.label:new({
--					parent = _parent,
--					align  = "LT",
--					x = nBackGroundX + 40,
--					y = nBackGroundY - 265,
--					text = scoreTodayMax,
--					font = "numWhite",
--					size = 28,
--					border = 1,
--					width = 300,
--				})
--				_childUI["HistoryBestScoreNum"].handle.s:setColor(ccc3(192, 192, 192))
--				StarList[#StarList+1] = "HistoryBestScoreNum"
--				
--				--本次评价
--				_childUI["GetCombatEva"].handle.s:setColor(ccc3(255, 255, 0))
--				_childUI["GetCombatEvaNum"].handle.s:setColor(ccc3(255, 255, 0))
--				
--				--检测是否是同一天
--				local scoreValid = true
--				
--				--取服务器当前时间
--				local localTime = os.time()
--				local intTimeNow = localTime - g_localDeltaTime --现在服务器时间戳(Local = Host + deltaTime)
--				local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
--				local delteZone = localTimeZone - 8 --与北京时间的时差
--				intTimeNow = intTimeNow - delteZone * 3600 --服务器时间(北京时区)
--				local tabNow = os.date("*t", intTimeNow)
--				local yearNow = tabNow.year
--				local monthNow = tabNow.month
--				local dayNow = tabNow.day
--				
--				local intTimeOld = hApi.GetNewDate(g_endlessBeginTime) --取开始游戏的时间（北京时区）
--				local tabOld = os.date("*t", intTimeOld)
--				local yearOld = tabOld.year
--				local monthOld = tabOld.month
--				local dayOld = tabOld.day
--				
--				if (yearNow ~= yearOld) or (monthNow ~= monthOld) or (dayNow ~= dayOld) then
--					scoreValid = false
--				end
--				--print("检测是否是同一天", intTimeNow, intTimeOld, scoreValid)
--				
--				--如果本次评价比今日最高战绩还要高，那么显示新纪录
--				if (scoreValid) and (bUpload) then
--					if (combatEva >= scoreTodayMax) then
--						
--						--新纪录文字
--						_childUI["NewRecordLabel"] = hUI.label:new({
--							parent = _parent,
--							align  = "MT",
--							x = nBackGroundX + 190,
--							y = nBackGroundY - 310,
--							--text = "新战绩", --language
--							text = hVar.tab_string["PVPFightNewScore"], --language
--							--font = "numWhite",
--							font = hVar.FONTC,
--							size = 26,
--							border = 1,
--							width = 300,
--						})
--						_childUI["NewRecordLabel"].handle.s:setColor(ccc3(0, 255, 0))
--						_childUI["NewRecordLabel"].handle._n:setRotation(15)
--						StarList[#StarList+1] = "NewRecordLabel" --待删除表
--						
--						--新纪录
--						_childUI["NewRecordImg"] = hUI.image:new({
--							parent = _parent,
--							model = "UI:TaskTanHao",
--							x = nBackGroundX + 230,
--							y = nBackGroundY - 360,
--							scale = 1.0,
--						})
--						local act1 = CCMoveBy:create(0.2, ccp(0, 6))
--						local act2 = CCMoveBy:create(0.2, ccp(0, -6))
--						local act3 = CCMoveBy:create(0.2, ccp(0, 6))
--						local act4 = CCMoveBy:create(0.2, ccp(0, -6))
--						local act5 = CCDelayTime:create(0.6)
--						local act6 = CCRotateBy:create(0.1, 10)
--						local act7 = CCRotateBy:create(0.1 * 1, -10 * 2)
--						local act8 = CCRotateBy:create(0.1 * 1, 10 * 2)
--						local act9 = CCRotateBy:create(0.1, -10)
--						local act10 = CCDelayTime:create(0.8)
--						local a = CCArray:create()
--						a:addObject(act1)
--						a:addObject(act2)
--						a:addObject(act3)
--						a:addObject(act4)
--						a:addObject(act5)
--						a:addObject(act6)
--						a:addObject(act7)
--						a:addObject(act8)
--						a:addObject(act9)
--						a:addObject(act10)
--						local sequence = CCSequence:create(a)
--						_childUI["NewRecordImg"].handle.s:runAction(CCRepeatForever:create(sequence))
--						StarList[#StarList+1] = "NewRecordImg" --待删除表
--					end
--				else --已过期，该得分无效
--					--当前已过重刷时间，本次得分仅本地有效
--					_childUI["ThisScoreExpired"] = hUI.label:new({
--						parent = _parent,
--						align  = "MT",
--						x = nBackGroundX - 5,
--						y = nBackGroundY - 395,
--						--text = "已过重刷时间，本次得分仅本地有效", --language
--						text = hVar.tab_string["PVPDaoJiShiExpired"], --language
--						--font = "numWhite",
--						font = hVar.FONTC,
--						size = 28,
--						border = 1,
--						width = 600,
--					})
--					_childUI["ThisScoreExpired"].handle.s:setColor(ccc3(212, 212, 212))
--					StarList[#StarList+1] = "ThisScoreExpired"
--				end
--			end
--		end
--		
--		return _frame
--	end
--	
--	--关闭地图
--	_CODE_ExitGame = function()
--		_frame:show(0)
--		hUI.Disable(0,"离开游戏")
--		--if hGlobal.WORLD.LastWorldMap then
--		--	hGlobal.WORLD.LastWorldMap:del()
--		--	hGlobal.WORLD.LastWorldMap = nil
--		--	hGlobal.LocalPlayer:setfocusworld(nil)
--		--	hApi.clearCurrentWorldScene()
--		--end
--		--hGlobal.event:event("LocalEvent_OpenPhoneMainMenu")
--		
--		if hGlobal.WORLD.LastWorldMap then
--			local w = hGlobal.WORLD.LastWorldMap
--			local currentMapMode = w.data.tdMapInfo and (w.data.tdMapInfo.mapMode)
--			local map = w.data.map
--			local tabM = hVar.MAP_INFO[map]
--			local chapterId = 1
--			if tabM then
--				chapterId = tabM.chapter or 1
--			end
--
--			hGlobal.WORLD.LastWorldMap:del()
--			hGlobal.WORLD.LastWorldMap = nil
--			hGlobal.LocalPlayer:setfocusworld(nil)
--			hApi.clearCurrentWorldScene()
--			
--			if (currentMapMode == hVar.MAP_TD_TYPE.ENDLESS) or (currentMapMode == hVar.MAP_TD_TYPE.PVP) then --无尽地图、pvp
--				--切换到新主界面事件
--				hGlobal.event:event("LocalEvent_OpenPhoneMainMenu")
--			else
--				hGlobal.event:event("LocalEvent_Phone_ShowPhone_SelecteMap", chapterId)
--				--hGlobal.event:event("LocalEvent_Phone_ShowReturnContinue",1)
--				--hApi.setViewNodeFocus(hVar.SCREEN.w/2,hVar.SCREEN.h/2)
--			end
--		end
--	end
--	
--	--监听游戏结束事件，显示结束界面
--	hGlobal.event:listen("LocalEvent_GameOver","__Show", function(nIsWin)
--		--关闭同步日志文件
--		hApi.SyncLogClose()
--		--关闭非同步日志文件
--		hApi.AsyncLogClose()
--		
--		bIsStarShow = false
--		--zhenkira new 2016.3.3
--		_CODE_ShowGameOverPanel(nIsWin)
--		
--		--zhenkira: old 2016.3.3
--		--if nIsWin==1 and hApi.IsMapFirstFinishWithUnlock(hGlobal.WORLD.LastWorldMap)==hVar.RESULT_SUCESS then
--		--	--如果是首次胜利
--		--	local nWin = nIsWin
--		--	hGlobal.event:event("LocalEvent_ShowAmuLockFrm",function()			--打开当前世界是否有解锁地图信息的提示面板(例如：通关黄巾之乱可以解锁娱乐地图………………)
--		--		_CODE_ShowGameOverPanel(nWin)
--		--	end)
--		--else
--		--	_CODE_ShowGameOverPanel(nIsWin)
--		--end
--	end)
--end
----[[
----测试 --test
--if hGlobal.UI.__GameOverPanel then
--	hGlobal.UI.__GameOverPanel:del()
--	hGlobal.UI.__GameOverPanel = nil
--end
--hGlobal.UI.InitGameOverPanel()
--hGlobal.event:listen("LocalEvent_GameOver", 1)
--]]
--
--
--
--
----监听pvp游戏结束事件，显示结束界面
--hGlobal.event:listen("LocalEvent_GameOver_PVP","__Show", function(nIsWin)
--	--关闭同步日志文件
--	hApi.SyncLogClose()
--	--关闭非同步日志文件
--	hApi.AsyncLogClose()
--	
--	--删除可能的投降对话框界面
--	if hGlobal.UI.PhonePlayerTouXiangFrm then
--		hGlobal.UI.PhonePlayerTouXiangFrm:del()
--		hGlobal.UI.PhonePlayerTouXiangFrm = nil
--	end
--	
--	--删除可能的pvp等待玩家的界面
--	if hGlobal.UI.PhoneDelayPlayerFrm then
--		hGlobal.UI.PhoneDelayPlayerFrm:del()
--		hGlobal.UI.PhoneDelayPlayerFrm = nil
--	end
--	
--	--清除上一次的pvp结束界面
--	if hGlobal.UI.__GameOverPanel_pvp then
--		hGlobal.UI.__GameOverPanel_pvp:del()
--		hGlobal.UI.__GameOverPanel_pvp = nil
--	end
--	
--	--删除可能的响应时间过长框界面
--	if hGlobal.UI.PhonePlayerNoHeartFrm then
--		hGlobal.UI.PhonePlayerNoHeartFrm:del()
--		hGlobal.UI.PhonePlayerNoHeartFrm = nil
--	end
--	
--	local world = hGlobal.WORLD.LastWorldMap
--	
--	--防止弹框
--	if (not world) then
--		return
--	end
--	
--	local oPlayerMe = world:GetPlayerMe()
--	local heros = oPlayerMe.heros --我出站的英雄
--	local tactics = oPlayerMe.data.tactics --我出站的战术卡和塔
--	
--	local w,h = hVar.SCREEN.w+10, hVar.SCREEN.h
--	local x,y = hVar.SCREEN.w/2-w/2, hVar.SCREEN.h
--	local scale = 1
--	local btnScale = 0.9							--按钮缩放
--	local bIsStarShow = false						--必须在星星显示完后才可以进行其他操作
--	local nScreenY = -5							--根据机器类型（手机，平板）调正整体位置
--	if (0 == g_phone_mode) then --平板模式
--		nScreenY = -80
--	end
--	
--	--加载 pvp.plist
--	xlLoadResourceFromPList("data/image/misc/pvp.plist")
--	
--	--pvp结束界面
--	hGlobal.UI.__GameOverPanel_pvp = hUI.frame:new({
--		x = x,
--		y = y,
--		w = w,
--		h = h,
--		dragable = 2,
--		show = 1,
--		background = "UI:tip_item",					--透明面板
--		border	= "UI:TileFrmBasic_thin",				--细边框
--	})
--	
--	local _frame = hGlobal.UI.__GameOverPanel_pvp
--	local _parent = _frame.handle._n
--	local _childUI = _frame.childUI
--	local _CODE_ExitGame = hApi.DoNothing					--场景切换，删除地图
--	
--	--【描述】-------------------------------------------------------------------------------------------
--	local nGameDescribeX, nGameDescribeY = w/2, nScreenY-79
--	--“成功”，“失败”
--	_childUI["WinOrLose_image"] = hUI.image:new({
--		parent = _parent,
--		model = "MODEL:Default",
--		x = nGameDescribeX,
--		y = nGameDescribeY + 24,
--		z = 1
--	})
--	
--	local content = nil									--保存标题：“通关” 或 “失败”
--	local nSize = nil									--记录标题（“通关”，“失败”）大小
--	--【根据输赢，控制部件的显示，和任务奖励的创建】
--	if (nIsWin == 1) then									--通关
--		content = "UI:Pvp_Win"
--		nSize = {146, 76}
--	elseif (nIsWin == 0) then
--		content = "UI:losej"
--		nSize = {146, 76}
--	else
--		content = "UI:Pvp_Draw"
--		nSize = {146, 86}
--	end
--	
--	--[标题“成功”或“失败”]
--	_childUI["WinOrLose_image"].handle._n:setVisible(true)
--	_childUI["WinOrLose_image"]:setmodel(content,nil,nil,nSize[1],nSize[2]) --nSize[1],nSize[2]中保持有content中图标的款和高
--	
--	--[[
--	--游戏结果背景
--	_childUI["Resource_background1"] = hUI.bar:new({
--		parent = _parent,
--		model = "UI:card_select_back",
--		w = 576,
--		h = 111,
--		x = nGameDescribeX,
--		y = nGameDescribeY + 24,
--	})
--	]]
--	
--	local nBackGroundX, nBackGroundY = w/2, nScreenY-110
--	
--	--[[
--	--光芒底线
--	_childUI["LightLine_image"] = hUI.image:new({
--		model = "UI:lightline",
--		parent = _parent,
--		w = 700,
--		h = 14,
--		x = nBackGroundX,
--		y = nBackGroundY - 63,
--	})
--	]]
--	--[[
--	--玩家名
--	_childUI["PlayerName"] = hUI.label:new({
--		parent = _parent,
--		x = nBackGroundX,
--		y = nBackGroundY - 110,
--		--text = hVar.tab_string["__TEXT_GetScore"]..":",
--		text = g_curPlayerName,
--		font = hVar.FONTC,
--		border = 1,
--		width = 550,
--		align = "MC",
--		size = 30,
--	})
--	_childUI["PlayerName"].handle.s:setColor(ccc3(0, 255, 0))
--	]]
--	--分割线1
--	_childUI["Separate1"] = hUI.image:new({
--		model = "UI:lightline",
--		parent = _parent,
--		w = 400,
--		h = 4,
--		x = nBackGroundX,
--		y = nBackGroundY - 10,
--	})
--	
--	--使用英雄
--	_childUI["UsedHeroLabel"] = hUI.label:new({
--		parent = _parent,
--		x = nBackGroundX - 200,
--		y = nBackGroundY - 70,
--		--text = "使用英雄", --language
--		text = hVar.tab_string["__TEXT_Use"] .. hVar.tab_string["hero"], --language
--		font = hVar.FONTC,
--		border = 1,
--		width = 550,
--		align = "LC",
--		size = 24,
--	})
--	
--	--依次绘制英雄
--	local WIDTH = 55
--	local OFFSET_Y = 65 --每一栏的y间距
--	local offsetX_hero = 0
--	--[[
--	if ((#heros % 2) == 1) then --奇数
--		offsetX_hero = (#heros - 1) / 2 * (WIDTH + 6) - (WIDTH + 6) / 2
--	else --偶数
--		offsetX_hero = (#heros - 2) / 2 * (WIDTH + 6)
--	end
--	]]
--	for i = 1, #heros, 1 do
--		local oHero = heros[i]
--		local heroId = oHero.data.id
--		
--		--英雄背景图
--		_childUI["heroImgBG" .. i] = hUI.image:new({
--			parent = _parent,
--			model = "UI:slotSmall",
--			animation = "lightSlim",
--			x = nBackGroundX - 10 + (i - 1) * (WIDTH + 6) + offsetX_hero,
--			y = nBackGroundY - 70 - OFFSET_Y * 0,
--			w = WIDTH,
--			h = WIDTH,
--		})
--		
--		--英雄头像
--		_childUI["heroImgBG" .. i] = hUI.image:new({
--			parent = _parent,
--			model = hVar.tab_unit[heroId].icon,
--			x = nBackGroundX - 10 + (i - 1) * (WIDTH + 6) + offsetX_hero,
--			y = nBackGroundY - 70 - OFFSET_Y * 0,
--			w = WIDTH - 5,
--			h = WIDTH - 5,
--		})
--	end
--	
--	--未使用英雄，显示文本
--	if (#heros == 0) then
--		_childUI["UsedHeroNoneLabel"] = hUI.label:new({
--			parent = _parent,
--			x = nBackGroundX - 30,
--			y = nBackGroundY - 70 - OFFSET_Y * 0,
--			--text = "无", --language
--			text = hVar.tab_string["__TEXT_Nothing"], --language
--			font = hVar.FONTC,
--			border = 1,
--			width = 550,
--			align = "MC",
--			size = 24,
--		})
--	end
--	
--	------------------------
--	--提取出塔
--	local towers = {}
--	for i = 1, #tactics, 1 do
--		local id = tactics[i][1]
--		local tabT = hVar.tab_tactics[id]
--		if tabT then
--			local type = tabT.type --战术技能卡类型
--			if (type == hVar.TACTICS_TYPE.TOWER) then --只处理塔类战术技能卡
--				towers[#towers + 1] = id
--			end
--		end
--	end
--	
--	--使用塔
--	_childUI["UsedTacticLabel"] = hUI.label:new({
--		parent = _parent,
--		x = nBackGroundX - 200,
--		y = nBackGroundY - 70 - OFFSET_Y * 1,
--		--text = "使用塔",
--		text = hVar.tab_string["__TEXT_Use"] .. hVar.tab_string["__TEXT_SOLDIER_TOWER"], --language
--		font = hVar.FONTC,
--		border = 1,
--		width = 550,
--		align = "LC",
--		size = 24,
--	})
--	
--	--依次绘制塔
--	local offsetX_tower = 0
--	--[[
--	if ((#towers % 2) == 1) then --奇数
--		offsetX_tower = (#towers - 1) / 2 * (WIDTH + 6) - (WIDTH + 6) / 2
--	else --偶数
--		offsetX_tower = (#towers - 2) / 2 * (WIDTH + 6)
--	end
--	]]
--	for i = 1, #towers, 1 do
--		local towerId = towers[i]
--		
--		--塔的图标
--		_childUI["towerImg" .. i] = hUI.image:new({
--			parent = _parent,
--			model = hVar.tab_tactics[towerId].icon,
--			x = nBackGroundX - 10 + (i - 1) * (WIDTH + 6) - offsetX_tower,
--			y = nBackGroundY - 70 - OFFSET_Y * 1,
--			w = WIDTH,
--			h = WIDTH,
--		})
--	end
--	
--	--未使用塔，显示文本
--	if (#towers == 0) then
--		_childUI["UsedTowerNoneLabel"] = hUI.label:new({
--			parent = _parent,
--			x = nBackGroundX - 30,
--			y = nBackGroundY - 70 - OFFSET_Y * 1,
--			--text = "无", --language
--			text = hVar.tab_string["__TEXT_Nothing"], --language
--			font = hVar.FONTC,
--			border = 1,
--			width = 550,
--			align = "MC",
--			size = 24,
--		})
--	end
--	
--	------------------------
--	--提取出兵种
--	local armys = {}
--	for i = 1, #tactics, 1 do
--		local id = tactics[i][1]
--		local tabT = hVar.tab_tactics[id]
--		if tabT then
--			local type = tabT.type --战术技能卡类型
--			if (type == hVar.TACTICS_TYPE.ARMY) then --只处理兵种类战术技能卡
--				armys[#armys + 1] = id
--			end
--		end
--	end
--	
--	--使用兵种
--	_childUI["UsedTacticLabel"] = hUI.label:new({
--		parent = _parent,
--		x = nBackGroundX - 200,
--		y = nBackGroundY - 70 - OFFSET_Y * 2,
--		--text = "使用兵种",
--		text = hVar.tab_string["__TEXT_Use"] .. hVar.tab_string["ArmyCardPage"], --language
--		font = hVar.FONTC,
--		border = 1,
--		width = 550,
--		align = "LC",
--		size = 24,
--	})
--	
--	--依次绘制兵种
--	local offsetX_army = 0
--	--[[
--	if ((#armys % 2) == 1) then --奇数
--		offsetX_army = (#armys - 1) / 2 * (WIDTH + 6) - (WIDTH + 6) / 2
--	else --偶数
--		offsetX_army = (#armys - 2) / 2 * (WIDTH + 6)
--	end
--	]]
--	for i = 1, #armys, 1 do
--		local tacticId = armys[i]
--		
--		--兵种的图标
--		_childUI["tacticImg" .. i] = hUI.image:new({
--			parent = _parent,
--			model = hVar.tab_tactics[tacticId].icon,
--			x = nBackGroundX - 10 + (i - 1) * (WIDTH + 6) - offsetX_army,
--			y = nBackGroundY - 70 - OFFSET_Y * 2,
--			w = WIDTH,
--			h = WIDTH,
--		})
--	end
--	
--	--未使用兵种，显示文本
--	if (#armys == 0) then
--		_childUI["UsedArmyNoneLabel"] = hUI.label:new({
--			parent = _parent,
--			x = nBackGroundX - 30,
--			y = nBackGroundY - 70 - OFFSET_Y * 2,
--			--text = "无", --language
--			text = hVar.tab_string["__TEXT_Nothing"], --language
--			font = hVar.FONTC,
--			border = 1,
--			width = 550,
--			align = "MC",
--			size = 24,
--		})
--	end
--	
--	--绘制获得的称号
--	--{破营, 兵圣, 夺粮, 推阵, 神将, 顽强, 对手掉线, 对手逃跑, 对手投降,}
--	local nChengHaoNumMax = {1, 10, 1, 10, 10, 1, 1, 1, 1,}
--	local tChengHaoMisc = {"PVP:Designation_1", "PVP:Designation_2", "PVP:Designation_3", "PVP:Designation_4", "PVP:Designation_5", "PVP:Designation_6", "PVP:Designation_8", "PVP:Designation_9", "PVP:Designation_7",}
--	local tChengHaoStars = {2, 2, 2, 1, 1, 1, 1, 1, 1,}
--	--蜀国主城: 11000
--	
--	local mySide = oPlayerMe:getforce() --死的单位的阵营
--	local pPosSelf = 1
--	--这里写死2边的玩家位置
--	if (mySide == hVar.FORCE_DEF.SHU) then
--		pPosSelf = 1
--	elseif (mySide == hVar.FORCE_DEF.WEI) then
--		pPosSelf = 11
--	end
--	local ownerSelf = world:GetPlayer(pPosSelf) --对方阵营的有效玩家对象
--	
--	local count0 = ownerSelf:getuserdata(5) or 0 --夺塔奇兵: 统计, 本方打掉主城的次数
--	local count1 = ownerSelf:getuserdata(1) or 0 --夺塔奇兵: 统计, 本方使用的发兵次数
--	local count2 = ownerSelf:getuserdata(2) or 0 --夺塔奇兵: 统计, 本方打掉粮仓的次数
--	local count3 = ownerSelf:getuserdata(3) or 0 --夺塔奇兵: 统计, 本方对面阵营击杀塔的次数
--	local count4 = ownerSelf:getuserdata(4) or 0 --夺塔奇兵: 统计, 本方对面阵营击杀英雄的次数
--	local count5 = ownerSelf:getuserdata(6) or 0 --夺塔奇兵: 统计, 本方主城被打掉的次数
--	local count6 = 0 --对手投降次数
--	local count7 = 0 --对手掉线次数
--	local count8 = 0 --对手逃跑次数
--	if (world:gametime() < 1000 * 60 * 6) or (count1 < 3) then --游戏时间小于6分钟，或者发兵次数小于3，不获得顽强称号
--		count5 = 0
--	end
--	local nChengHaoNumNow = {count0, count1, count2, count3, count4, count5, count6, count7, count8,}
--	local bChengHaoVisible = {true, true, true, true, true, true, true, true, true,}
--	
--	--绘制每一个称号
--	for i = 1, #tChengHaoMisc, 1 do
--		local IMG_WIDTH = 150
--		local IMG_HEIGHT = 86
--		local WIDTH = 24
--		local offsetX_chenghao = 0
--		local starCount = tChengHaoStars[i]
--		if ((starCount % 2) == 1) then --奇数
--			offsetX_chenghao = (starCount - 1) / 2 * (WIDTH + 2) - (WIDTH + 2) / 2
--		else --偶数
--			offsetX_chenghao = (starCount - 2) / 2 * (WIDTH + 2)
--		end
--		
--		--称号按钮
--		_childUI["chenghaoBtnn" .. i] = hUI.button:new({
--			parent = _parent,
--			model = "misc/mask.png",
--			dragbox = _childUI["dragBox"],
--			x = nBackGroundX - 400 + (i - 1) * (IMG_WIDTH + 10),
--			y = nBackGroundY - 150 - OFFSET_Y * 2,
--			w = IMG_WIDTH + 8,
--			h = IMG_HEIGHT + 20,
--			scaleT = 0.95,
--			code = function()
--				--显示本称号的说明tip
--				hGlobal.UI.PVPChengHaoTipFrame = hUI.frame:new({
--					x = 0,
--					y = 0,
--					w = hVar.SCREEN.w,
--					h = hVar.SCREEN.h,
--					--z = -1,
--					show = 1,
--					--dragable = 2,
--					dragable = 2,
--					--buttononly = 1,
--					autoactive = 0,
--					--background = "UI:PANEL_INFO_MINI",
--					failcall = 1, --出按钮区域抬起也会响应事件
--					background = -1, --无底图
--					border = 0, --无边框
--					
--					--点击事件（有可能在控件外部点击）
--					codeOnDragEx = function(screenX, screenY, touchMode)
--						--print("codeOnDragEx", screenX, screenY, touchMode)
--						if (touchMode == 0) then --按下
--							--
--						elseif (touchMode == 1) then --滑动
--							--
--						elseif (touchMode == 2) then --抬起
--							--清除技能说明面板
--							hGlobal.UI.PVPChengHaoTipFrame:del()
--							hGlobal.UI.PVPChengHaoTipFrame = nil
--							--print("点击事件（有可能在控件外部点击）")
--						end
--					end,
--				})
--				hGlobal.UI.PVPChengHaoTipFrame:active()
--				
--				local _PVPChengHaoTipParent = hGlobal.UI.PVPChengHaoTipFrame.handle._n
--				local _PVPChengHaoTipChildUI = hGlobal.UI.PVPChengHaoTipFrame.childUI
--				
--				local _offX = hVar.SCREEN.w / 2
--				local _offY = hVar.SCREEN.h / 2 + 220
--				
--				--创建游戏币图片背景
--				--[[
--				_PVPChengHaoTipChildUI["ItemBG_1"] = hUI.image:new({
--					parent = _PVPChengHaoTipParent,
--					--model = "UI_frm:slot",
--					--animation = "normal",
--					model = "UI:TacticBG",
--					x = _offX,
--					y = _offY - 235,
--					w = 350,
--					h = 220,
--				})
--				_PVPChengHaoTipChildUI["ItemBG_1"].handle.s:setOpacity(204) --战术卡tip背景图片透明度为204
--				]]
--				local img9 = hApi.CCScale9SpriteCreateWithSpriteFrameName("data/image/ui/TacticBG.png", _offX, _offY - 235, 350, 220, hGlobal.UI.PVPChengHaoTipFrame)
--				img9:setOpacity(204)
--				
--				--"称号"名字
--				_PVPChengHaoTipChildUI["chenghaoLabel"] = hUI.label:new({
--					parent = _PVPChengHaoTipParent,
--					x = _offX - 160,
--					y = _offY - 182,
--					font = hVar.FONTC,
--					border = 1,
--					width = 550,
--					align = "LC",
--					size = 28,
--					--text = "勋章", --language
--					text = hVar.tab_string["PVPXunZhang"], --language
--				})
--				_PVPChengHaoTipChildUI["chenghaoLabel"].handle.s:setColor(ccc3(255, 255, 212))
--				
--				--"称号"名字
--				_PVPChengHaoTipChildUI["chenghaoIcon"] = hUI.image:new({
--					parent = _PVPChengHaoTipParent,
--					model = tChengHaoMisc[i],
--					x = _offX + 40,
--					y = _offY - 182,
--					scale = 0.8,
--				})
--				
--				--"称号"需要条件
--				_PVPChengHaoTipChildUI["chenghaoRequireLabel"] = hUI.label:new({
--					parent = _PVPChengHaoTipParent,
--					x = _offX - 160,
--					y = _offY - 256,
--					font = hVar.FONTC,
--					border = 1,
--					width = 550,
--					align = "LT",
--					size = 28,
--					--text = "达成条件", --language
--					text = hVar.tab_string["PVPXunZhangRequire"], --language
--				})
--				_PVPChengHaoTipChildUI["chenghaoRequireLabel"].handle.s:setColor(ccc3(255, 255, 212))
--				
--				--"称号"需要的条件说明
--				_PVPChengHaoTipChildUI["chenghaoRequireHint"] = hUI.label:new({
--					parent = _PVPChengHaoTipParent,
--					x = _offX - 27,
--					y = _offY - 283,
--					font = hVar.FONTC,
--					border = 1,
--					width = 200,
--					align = "LC",
--					size = 26,
--					text = hVar.tab_string["__TEXT_PVP_DesignationHint" .. i], --language
--				})
--			end,
--		})
--		_childUI["chenghaoBtnn" .. i].handle.s:setOpacity(0) --只用于控制，不显示
--		
--		--称号的图标
--		_childUI["chenghaoBtnn" .. i].childUI["icon"] = hUI.button:new({
--			parent = _childUI["chenghaoBtnn" .. i].handle._n,
--			model = tChengHaoMisc[i],
--			x = 0,
--			y = 0,
--			w = IMG_WIDTH,
--			h = IMG_HEIGHT,
--		})
--		hApi.AddShader(_childUI["chenghaoBtnn" .. i].childUI["icon"].handle.s, "gray") --一开始灰掉
--		
--		--称号的勾勾
--		_childUI["chenghaoBtnn" .. i].childUI["ok"] = hUI.image:new({
--			parent = _childUI["chenghaoBtnn" .. i].handle._n,
--			model = "misc/ok.png",
--			x = 55,
--			y = 20,
--			w = 28,
--			h = 28,
--		})
--		_childUI["chenghaoBtnn" .. i].childUI["ok"].handle.s:setVisible(false) --一开始隐藏
--		
--		--[[
--		--称号的星星的图标
--		for j = 1, starCount, 1 do
--			_childUI["chenghaoBtnn" .. i].childUI["star" .. j] = hUI.image:new({
--				parent = _childUI["chenghaoBtnn" .. i].handle._n,
--				model = "UI:STAR_YELLOW",
--				x = -12 +  (j - 1) * (WIDTH + 2) - offsetX_chenghao,
--				y = -40,
--				w = WIDTH,
--				h = WIDTH,
--			})
--			hApi.AddShader(_childUI["chenghaoBtnn" .. i].childUI["star" .. j].handle.s, "gray") --一开始灰掉
--		end
--		]]
--		
--		--称号当前的数量
--		if (bChengHaoVisible[i]) then
--			_childUI["chenghaoBtnn" .. i].childUI["num"] = hUI.label:new({
--				parent = _childUI["chenghaoBtnn" .. i].handle._n,
--				x = 0,
--				y = -45,
--				font = "numWhite",
--				border = 0,
--				width = 550,
--				align = "MC",
--				size = 18,
--				text = nChengHaoNumNow[i] .. "/" .. nChengHaoNumMax[i],
--			})
--		end
--	end
--	
--	--胜利者不显示"顽强"称号
--	if (nIsWin == 1) then
--		_childUI["chenghaoBtnn" .. "6"]:setstate(-1)
--		for i = 1, #tChengHaoMisc, 1 do
--			--称号按钮
--			_childUI["chenghaoBtnn" .. i]:setXY(_childUI["chenghaoBtnn" .. i].data.x + 72, _childUI["chenghaoBtnn" .. i].data.y)
--		end
--	else --失败者不显示"破营"称号
--		_childUI["chenghaoBtnn" .. "1"]:setstate(-1)
--		for i = 1, #tChengHaoMisc, 1 do
--			--称号按钮
--			_childUI["chenghaoBtnn" .. i]:setXY(_childUI["chenghaoBtnn" .. i].data.x - 88, _childUI["chenghaoBtnn" .. i].data.y)
--		end
--	end
--	
--	--检测是否有电脑
--	local bHaveComputer = false
--	if (world.data.session_cfgId == 1) then --pvp配置id(1:娱乐房 / 4:匹配房)
--		for i = 1, 20, 1 do
--			local player = world.data.PlayerList[i]
--			--如果玩家存在并且玩家是电脑
--			if player and (player:gettype() >= 2) and (player:gettype() <= 6) then
--				bHaveComputer = true --有电脑
--			end
--		end
--	end
--	
--	--检测游戏时间是否足够长
--	local bLongTime = true
--	local gametime = world:gametime()
--	local settime = 1000 * 60 * 3 --3分钟
--	if (gametime < settime) then
--		bLongTime = false --游戏时长不够
--	end
--	
--	--是否为夺塔奇兵的娱乐房娱乐赛
--	local bIsFunBattle = ((world.data.session_cfgId == 1) and (not world.data.bIsArena))
--	
--	--胜利额外多2个星，有效局，非娱乐局，非电脑局
--	if (nIsWin == 1) and (bLongTime) and (not bIsFunBattle) and (not bHaveComputer) then
--		--星星1
--		_childUI["WinStar1"] = hUI.image:new({
--			parent = _parent,
--			model = "UI:STAR_YELLOW",
--			x = nGameDescribeX - 22,
--			y = nGameDescribeY - 20,
--			z = 1,
--			scale = 0.5,
--		})
--		
--		--星星2
--		_childUI["WinStar2"] = hUI.image:new({
--			parent = _parent,
--			model = "UI:STAR_YELLOW",
--			x = nGameDescribeX + 22,
--			y = nGameDescribeY - 20,
--			scale = 0.5,
--			z = 1,
--		})
--		
--		--星星1动画
--		local act1 = CCDelayTime:create(0.5)
--		local act2 = CCScaleTo:create(0.08, 1.2)
--		local act3 = CCScaleTo:create(0.08, 0.5)
--		local a = CCArray:create()
--		a:addObject(act1)
--		a:addObject(act2)
--		a:addObject(act3)
--		local sequence = CCSequence:create(a)
--		_childUI["WinStar1"].handle.s:runAction(sequence)
--		
--		--星星2动画
--		local act5 = CCDelayTime:create(0.5 + 0.08)
--		local act6 = CCScaleTo:create(0.08, 1.2)
--		local act7 = CCScaleTo:create(0.08, 0.5)
--		local a = CCArray:create()
--		a:addObject(act5)
--		a:addObject(act6)
--		a:addObject(act7)
--		local sequence = CCSequence:create(a)
--		_childUI["WinStar2"].handle.s:runAction(sequence)
--	end
--	
--	--游戏不足3分钟，非电脑局，图标为"无效"
--	--[标题“无效”]
--	if (not bLongTime) and (not bHaveComputer) then
--		local content = "UI:Pvp_Invalid"
--		_childUI["WinOrLose_image"].handle._n:setVisible(true)
--		_childUI["WinOrLose_image"]:setmodel(content,nil,nil,nSize[1],nSize[2]) --nSize[1],nSize[2]中保持有content中图标的款和高
--	end
--	
--	--"战绩结算:"
--	local winCount = g_myPvP_BaseInfo.winE
--	if (nIsWin == 1) and (not bHaveComputer) and (bLongTime) then --赢了，没有电脑，游戏时长足够
--		winCount = winCount + 1
--	end
--	_childUI["WinCountLabelPrefix"] = hUI.label:new({
--		parent = _parent,
--		x = nBackGroundX - 10,
--		y = nBackGroundY - 370,
--		font = hVar.FONTC,
--		border = 1,
--		width = 550,
--		align = "RC",
--		size = 28,
--		--text = "战绩结算:", --language
--		text = hVar.tab_string["__TEXT_PVP_WinCal"] .. ":", --language
--	})
--	--_childUI["WinCountLabel"].handle.s:setColor(ccc3(255, 255, 96))
--	
--	--战绩结算的星星图标
--	_childUI["WinCountStar"] = hUI.image:new({
--		parent = _parent,
--		model = "UI:STAR_YELLOW",
--		x = nBackGroundX + 25,
--		y = nBackGroundY - 370 + 4,
--		w = 32,
--		h = 32,
--	})
--	
--	--战绩结算的结果星星值
--	_childUI["WinStarLabel"] = hUI.label:new({
--		parent = _parent,
--		x = nBackGroundX + 50,
--		y = nBackGroundY - 370,
--		font = "num",
--		--border = 1,
--		width = 550,
--		align = "LC",
--		size = 24,
--		text = "+0",
--	})
--	--_childUI["WinStarLabel"].handle.s:setColor(ccc3(255, 255, 96))
--	
--	--战绩结算的等待菊花
--	_childUI["WinStarWaitingImg"] = hUI.image:new({
--		parent = _parent,
--		x = nBackGroundX + 113,
--		y = nBackGroundY - 370 + 3,
--		model = "MODEL_EFFECT:waiting",
--		w = 42,
--		h = 42,
--	})
--	
--	--一开始不显示对手离开的相关界面
--	_childUI["chenghaoBtnn" .. "7"]:setstate(-1)
--	_childUI["chenghaoBtnn" .. "8"]:setstate(-1)
--	_childUI["chenghaoBtnn" .. "9"]:setstate(-1)
--	
--	--有电脑显示一句话
--	if bHaveComputer then
--		_childUI["WinCountComputerHintLabel"] = hUI.label:new({
--			parent = _parent,
--			x = nBackGroundX,
--			y = nBackGroundY - 415,
--			font = hVar.FONTC,
--			border = 1,
--			width = 550,
--			align = "MC",
--			size = 28,
--			--text = "（电脑局不计入胜场）", --language
--			text = hVar.tab_string["__TEXT_PVP_ComputerDoNotCalWin"], --language
--		})
--		_childUI["WinCountComputerHintLabel"].handle.s:setColor(ccc3(255, 0, 0))
--		
--		--电脑局不得星
--		_childUI["WinStarLabel"]:setText("+0")
--		_childUI["WinStarWaitingImg"].handle.s:setVisible(false) --电脑局无数据，隐藏菊花
--	--[[
--	elseif (not bLongTime) then
--		--如果游戏时间不足3分钟，提示不是有效局
--		_childUI["WinCountNotEnoughTimeHintLabel"] = hUI.label:new({
--			parent = _parent,
--			x = nBackGroundX,
--			y = nBackGroundY - 415,
--			font = hVar.FONTC,
--			border = 1,
--			width = 550,
--			align = "MC",
--			size = 28,
--			--text = "（游戏不足3分钟，非有效局）", --language
--			text = hVar.tab_string["__TEXT_PVP_NotEnoughTimeDoNotCalWin"], --language
--		})
--		_childUI["WinCountNotEnoughTimeHintLabel"].handle.s:setColor(ccc3(255, 0, 0))
--	]]
--	else --无电脑局
--		--无效局的原因描述
--		_childUI["WinCountInvalidHintLabel"] = hUI.label:new({
--			parent = _parent,
--			x = nBackGroundX,
--			y = nBackGroundY - 415,
--			font = hVar.FONTC,
--			border = 1,
--			width = 1600,
--			align = "MC",
--			size = 28,
--			text = "",
--		})
--		_childUI["WinCountInvalidHintLabel"].handle.s:setColor(ccc3(255, 0, 0))
--		
--		--无效局的描述
--		local errorStr = world.data.result_invalid_str
--		if (errorStr ~= "") then
--			_childUI["WinCountInvalidHintLabel"]:setText(errorStr)
--			
--			--_childUI["WinStarLabel"]:setText("+0")
--			_childUI["WinStarWaitingImg"].handle.s:setVisible(false) --提前收到无效局，隐藏菊花
--		end
--		--监听pvp游戏结果为无效局的描述信息-GameEnd
--		hGlobal.event:listen("LocalEvent_Pvp_GameResult_Invalid", "TD_Pvp_GameResult_Invalid_OnGameEnd", function(errorStr)
--			--print("监听pvp游戏结果为无效局的描述信息", errorStr)
--			local world = hGlobal.WORLD.LastWorldMap
--			if world then
--				local _frame = hGlobal.UI.__GameOverPanel_pvp
--				if _frame then
--					local _parent = _frame.handle._n
--					local _childUI = _frame.childUI
--					if _childUI["WinCountInvalidHintLabel"] then
--						_childUI["WinCountInvalidHintLabel"]:setText(errorStr)
--					end
--					
--					--if _childUI["WinStarLabel"] then
--					--	_childUI["WinStarLabel"]:setText("+0")
--					--end
--					
--					if _childUI["WinStarWaitingImg"] then
--						_childUI["WinStarWaitingImg"].handle.s:setVisible(false) --收到无效局，隐藏菊花
--					end
--				end
--			end
--		end)
--		
--		--战绩结果
--		local result_envaluate_table = world.data.result_envaluate_table
--		if result_envaluate_table then
--			for i = 1, #tChengHaoMisc, 1 do
--				if (result_envaluate_table.medalList[i]) then
--					--称号图标点亮
--					hApi.AddShader(_childUI["chenghaoBtnn" .. i].childUI["icon"].handle.s, "normal")
--					
--					--[[
--					--称号图标的星星点亮
--					local starCount = tChengHaoStars[i]
--					for j = 1, starCount, 1 do
--						hApi.AddShader(_childUI["chenghaoBtnn" .. i].childUI["star" .. j].handle.s, "normal")
--					end
--					]]
--					
--					--称号图标的勾勾显示
--					_childUI["chenghaoBtnn" .. i].childUI["ok"].handle.s:setVisible(true)
--					
--					--不显示本称号的数量
--					if (bChengHaoVisible[i]) then
--						_childUI["chenghaoBtnn" .. i].childUI["num"].handle.s:setVisible(false)
--					end
--				end
--			end
--			
--			--显示总星星
--			local starReward = result_envaluate_table.evaluatePoint or 0
--			_childUI["WinStarLabel"]:setText("+" .. starReward)
--			_childUI["WinStarWaitingImg"].handle.s:setVisible(false) --提前收到数据，隐藏菊花
--			
--			--1--是否推掉敌方老家+1
--			--2--发兵10次评价+2
--			--3--击杀粮仓评价+2
--			--4--击杀塔10次评价+1
--			--5--击杀英雄10次评价+1
--			--6--顽强
--			--7--对方投降
--			--8--对方掉线
--			--9--对方逃跑补偿
--			--显示对手离开的情况
--			if (nIsWin == 1) then
--				if (result_envaluate_table.medalList[7]) then --投降
--					_childUI["chenghaoBtnn" .. "7"]:setstate(1)
--					_childUI["chenghaoBtnn" .. "7"]:setXY(_childUI["chenghaoBtnn" .. "1"].data.x, _childUI["chenghaoBtnn" .. "1"].data.y)
--					_childUI["chenghaoBtnn" .. "8"]:setstate(-1)
--					_childUI["chenghaoBtnn" .. "9"]:setstate(-1)
--					_childUI["chenghaoBtnn" .. "1"]:setstate(-1)
--				end
--				if (result_envaluate_table.medalList[8]) then --掉线
--					_childUI["chenghaoBtnn" .. "8"]:setstate(1)
--					_childUI["chenghaoBtnn" .. "8"]:setXY(_childUI["chenghaoBtnn" .. "1"].data.x, _childUI["chenghaoBtnn" .. "1"].data.y)
--					_childUI["chenghaoBtnn" .. "7"]:setstate(-1)
--					_childUI["chenghaoBtnn" .. "9"]:setstate(-1)
--					_childUI["chenghaoBtnn" .. "1"]:setstate(-1)
--				end
--				if (result_envaluate_table.medalList[9]) then --逃跑
--					_childUI["chenghaoBtnn" .. "9"]:setstate(1)
--					_childUI["chenghaoBtnn" .. "9"]:setXY(_childUI["chenghaoBtnn" .. "1"].data.x, _childUI["chenghaoBtnn" .. "1"].data.y)
--					_childUI["chenghaoBtnn" .. "7"]:setstate(-1)
--					_childUI["chenghaoBtnn" .. "8"]:setstate(-1)
--					_childUI["chenghaoBtnn" .. "1"]:setstate(-1)
--				end
--			end
--		end
--		--监听pvp战绩结果下发-事件
--		hGlobal.event:listen("LocalEvent_Pvp_GameResult_RewardStar", "TD_Pvp_GameResult_RewardStar_OnGameEnd", function(t)
--			--print("监听pvp战绩结果下发")
--			local world = hGlobal.WORLD.LastWorldMap
--			if world then
--				if (t.session_dbId == world.data.session_dbId) then
--					local _frame = hGlobal.UI.__GameOverPanel_pvp
--					if _frame then
--						local _parent = _frame.handle._n
--						local _childUI = _frame.childUI
--						for i = 1, #tChengHaoMisc, 1 do
--							if (t.medalList[i]) then
--								--称号图标点亮
--								hApi.AddShader(_childUI["chenghaoBtnn" .. i].childUI["icon"].handle.s, "normal")
--								
--								--[[
--								--称号图标的星星点亮
--								local starCount = tChengHaoStars[i]
--								for j = 1, starCount, 1 do
--									hApi.AddShader(_childUI["chenghaoBtnn" .. i].childUI["star" .. j].handle.s, "normal")
--								end
--								]]
--								
--								--称号图标的勾勾显示
--								_childUI["chenghaoBtnn" .. i].childUI["ok"].handle.s:setVisible(true)
--								
--								--不显示本称号的数量
--								if (bChengHaoVisible[i]) then
--									_childUI["chenghaoBtnn" .. i].childUI["num"].handle.s:setVisible(false)
--								end
--							end
--						end
--						
--						--显示总星星
--						local starReward = t.evaluatePoint or 0
--						_childUI["WinStarLabel"]:setText("+" .. starReward)
--						_childUI["WinStarWaitingImg"].handle.s:setVisible(false) --收到数据，隐藏菊花
--						
--						--1--是否推掉敌方老家+1
--						--2--发兵10次评价+2
--						--3--击杀粮仓评价+2
--						--4--击杀塔10次评价+1
--						--5--击杀英雄10次评价+1
--						--6--顽强
--						--7--对方投降
--						--8--对方掉线
--						--9--对方逃跑补偿
--						--显示对手离开的情况
--						if (nIsWin == 1) then
--							if (t.medalList[7]) then --投降
--								_childUI["chenghaoBtnn" .. "7"]:setstate(1)
--								_childUI["chenghaoBtnn" .. "7"]:setXY(_childUI["chenghaoBtnn" .. "1"].data.x, _childUI["chenghaoBtnn" .. "1"].data.y)
--								_childUI["chenghaoBtnn" .. "8"]:setstate(-1)
--								_childUI["chenghaoBtnn" .. "9"]:setstate(-1)
--								_childUI["chenghaoBtnn" .. "1"]:setstate(-1)
--							end
--							if (t.medalList[8]) then --掉线
--								_childUI["chenghaoBtnn" .. "8"]:setstate(1)
--								_childUI["chenghaoBtnn" .. "8"]:setXY(_childUI["chenghaoBtnn" .. "1"].data.x, _childUI["chenghaoBtnn" .. "1"].data.y)
--								_childUI["chenghaoBtnn" .. "7"]:setstate(-1)
--								_childUI["chenghaoBtnn" .. "9"]:setstate(-1)
--								_childUI["chenghaoBtnn" .. "1"]:setstate(-1)
--							end
--							if (t.medalList[9]) then --逃跑
--								_childUI["chenghaoBtnn" .. "9"]:setstate(1)
--								_childUI["chenghaoBtnn" .. "9"]:setXY(_childUI["chenghaoBtnn" .. "1"].data.x, _childUI["chenghaoBtnn" .. "1"].data.y)
--								_childUI["chenghaoBtnn" .. "7"]:setstate(-1)
--								_childUI["chenghaoBtnn" .. "8"]:setstate(-1)
--								_childUI["chenghaoBtnn" .. "1"]:setstate(-1)
--							end
--						end
--					end
--				end
--			end
--		end)
--	end
--	
--	--【按钮】--------------------------------------------------------------------
--	local nButtonX, nButtonY  = w/2, nScreenY-410
--	--“主界面”按钮
--	_childUI["btnOk"] = hUI.button:new({
--		parent = _parent,
--		dragbox = _childUI["dragBox"],
--		model = "UI:ButtonBack",
--		icon = "ui/hall.png",
--		iconWH = 28,
--		label = " "..hVar.tab_string["__TEXT_MainInterface"],
--		font = hVar.FONTC,
--		border = 1,
--		align = "MC",
--		scaleT = 0.9,
--		x = nButtonX,
--		y = nButtonY - 170,
--		scale = btnScale,
--		code = function(self)
--			--geyachao: 这里会弹框？？？暂时注释掉
--			--local mapName = hGlobal.WORLD.LastWorldMap.data.map	--zhenkira
--			
--			--_chestPoolExitFun()
--			_frame:show(0)
--			_CODE_ExitGame()				--删除地图等操作
--		end,
--	})
--	_childUI["btnOk"]:setstate(1)
--	_childUI["btnOk"].childUI["label"].handle._n:setPosition(-35,12)
--	_childUI["btnOk"].childUI["icon"].handle._n:setPosition(-60,1)
--	
--	--关闭地图
--	_CODE_ExitGame = function()
--		if hGlobal.UI.__GameOverPanel_pvp then
--			hGlobal.UI.__GameOverPanel_pvp:del()
--			hGlobal.UI.__GameOverPanel_pvp = nil
--		end
--		
--		--删除pvp资源
--		xlReleaseResourceFromPList("data/image/misc/pvp.plist")
--		
--		hUI.Disable(0, "离开游戏")
--		--if hGlobal.WORLD.LastWorldMap then
--		--	hGlobal.WORLD.LastWorldMap:del()
--		--	hGlobal.WORLD.LastWorldMap = nil
--		--	hGlobal.LocalPlayer:setfocusworld(nil)
--		--	hApi.clearCurrentWorldScene()
--		--end
--		--hGlobal.event:event("LocalEvent_OpenPhoneMainMenu")
--		
--		if hGlobal.WORLD.LastWorldMap then
--			local w = hGlobal.WORLD.LastWorldMap
--			local currentMapMode = w.data.tdMapInfo and (w.data.tdMapInfo.mapMode)
--			local map = w.data.map
--			local tabM = hVar.MAP_INFO[map]
--			local chapterId = 1
--			if tabM then
--				chapterId = tabM.chapter or 1
--			end
--			
--			hGlobal.WORLD.LastWorldMap:del()
--			hGlobal.WORLD.LastWorldMap = nil
--			hGlobal.LocalPlayer:setfocusworld(nil)
--			hApi.clearCurrentWorldScene()
--			
--			if (currentMapMode == hVar.MAP_TD_TYPE.ENDLESS) or (currentMapMode == hVar.MAP_TD_TYPE.PVP) then --无尽地图、pvp
--				--切换到新主界面事件
--				hGlobal.event:event("LocalEvent_OpenPhoneMainMenu")
--			else
--				hGlobal.event:event("LocalEvent_Phone_ShowPhone_SelecteMap", chapterId)
--				--hGlobal.event:event("LocalEvent_Phone_ShowReturnContinue",1)
--				--hApi.setViewNodeFocus(hVar.SCREEN.w/2,hVar.SCREEN.h/2)
--			end
--		end
--	end
--	
--	--------------------------------------------------------
--	--geyachao: pvp模式，为了防止玩家恶意刷游戏局
--	--在掉线的时候，记录一下本局游戏对战的对手
--	--找到对手
--	local userId_Enemy = 0 --对手的uid
--	local userName_Enemy = "" --对手的名字
--	local forceMe = world:GetPlayerMe():getforce()
--	for i = 1, 20, 1 do
--		local player_i = world.data.PlayerList[i]
--		if player_i then
--			local force_i = player_i:getforce()
--			if(force_i ~= forceMe) then
--				if (player_i:gettype() == 1) then --0空 1玩家 2简单电脑 3中等电脑 4困难电脑 5大师电脑 6专家电脑
--					userId_Enemy = player_i.data.dbid --找到了
--					userName_Enemy = player_i.data.name
--					break
--				end
--			end
--		end
--	end
--	if (userId_Enemy > 0) then
--		local session_dbId = world.data.session_dbId --本局的游戏局唯一id
--		local userId = userId_Enemy --本局的对手id
--		local userName = userName_Enemy --本局的对手名字
--		local bUseEquip = world.data.bUseEquip --本局是否携带状态
--		local pvpcoinCost = world:GetPlayerMe():getuserdata(1) or 0 --用户自定义数据[1] 本局消耗的兵符
--		local gametime = math.floor(world:gametime() / 1000) --本局的游戏时长(秒)
--		LuaAddPVPUserInfo(g_curPlayerName, session_dbId, userId, userName, bUseEquip, pvpcoinCost, gametime)
--	end
--	--------------------------------------------------------
--end)
--
--
----------------------------------
---- 加载战斗对话面板
----------------------------------
----hGlobal.UI._InitBattlePanel = function()
--	--local x,y,w,h = 276,567,500,380
--	
--	--hGlobal.UI.__BattlePanel = hUI.frame:new({
--		--x = x,
--		--y = y,
--		--w = w,
--		--h = h,
--		--dragable = 2,
--		--show = 0,
--		--h = 330,
--		--w = 480,
--		--titlebar = 0,
--	--})
--
--	--local _frame = hGlobal.UI.__BattlePanel
--	--local _parent = _frame.handle._n
--	--local _childUI = _frame.childUI
--	--local nCurSelectIndex = nil
--	--local _exitFunc = nil
--	--local _rewardTable = nil
--	
--	----创建ok按钮
--	--_childUI["btnOk"] = hUI.button:new({
--		--parent = _parent,
--		--mode = "imageButton",
--		--dragbox = _childUI["dragBox"],
--		--model = "UI:BTN_ok",
--		--label = "",
--		--align = "MC",
--		--scaleT = 0.9,
--		--x = w/2 - 40,
--		--y = -335,
--		
--		--code = function(self)
--			--if type(_exitFunc)=="function" then
--				--print("战斗对话面板OK按钮点击 回调")
--				--_exitFunc(1,_rewardTable)
--			--end
--			--_frame:show(0,"appear")
--		--end,
--	--})
--	----创建cancel按钮	
--	--_childUI["btnCancel"] = hUI.button:new({
--		--parent = _parent,
--		--mode = "imageButton",
--		--dragbox = _childUI["dragBox"],
--		--model = "UI:BTN_cancel",
--		--label = "",
--		--align = "MC",
--		--scaleT = 0.9,
--		--x = w/2 + 40,
--		--y = -335,
--		
--		--code = function(self)
--			--if type(_exitFunc)=="function" then
--				--print("战斗对话面板Cancel按钮点击 回调")
--				--_exitFunc(2,_rewardTable)
--			--end
--			--_frame:show(0,"appear")
--		--end,
--	--})
--
--
--	----添加选中效果函数
--	--local _GP = {align = "MC"}
--	--local function __GridAddBorder(grid,gridX,girdY)
--		--grid:addimage("UI:Button_SelectBorder",gridX,girdY,_GP)
--	--end
--	
--	--hGlobal.UI.BattlePanel = function(rewardTable,selectRewardCode)
--		----初始化
--		--_exitFunc = selectRewardCode
--		--_rewardTable = rewardTable
--		
--		--local title = rewardTable.title
--		--local content = rewardTable.content
--		--local heroName = hVar.tab_stringU[rewardTable.unit.data.id][1]
--		--local targetName = nil
--		--if type(rewardTable.target) == "number" then
--			--targetName = hVar.tab_unit[rewardTable.target].name
--		--else
--			--targetName = hVar.tab_stringU[rewardTable.target.data.id][1]
--		--end
--		--title = hGlobal.UI.Format(title,heroName,targetName)
--		--content = hGlobal.UI.Format(content,heroName,targetName)
--		
--		----创建头像
--		--local tabTarget = rewardTable.target--hVar.tab_unit[rewardTable.target.data.id]
--		
--		--hApi.safeRemoveT(_childUI,"icon")
--		--hApi.safeRemoveT(_childUI,"title")
--		--hApi.safeRemoveT(_childUI,"content")
--		
--		--if type(tabTarget) == "number" then
--			--_childUI["icon"] = hUI.thumbImage:new({
--				--parent = _parent,
--				----model = tabTarget.model or tabTarget.xlobj,
--				--id = tabTarget,
--				----unit = rewardTable.target,
--				--w = 70,
--				--h = 70,
--				--x = 15,
--				--y = -20,
--			--})
--		--else
--			--_childUI["icon"] = hUI.thumbImage:new({
--				--parent = _parent,
--				----model = tabTarget.model or tabTarget.xlobj,
--				----id = tabTarget,
--				--unit = rewardTable.target,
--				--w = 70,
--				--h = 70,
--				--x = 15,
--				--y = -20,
--			--})	
--		--end
--
--		----创建显示标题的信息
--		--_childUI["title"] = hUI.label:new({
--			--parent = _parent,
--			--text = title,--rewardTable.title or "马上要战斗了不会吓傻了吧",--"两行两行两行两行两行两行两行两行两行两行两行两行两行两行\n",
--			--x = w/2 - 155,
--			--y = -30,
--			--width = w-125,
--			--align = "LT",
--			--size = 18,
--		--})
--		
--		----创建显示内容的信息
--		--_childUI["content"] = hUI.label:new({
--			--parent = _parent,
--			--text = content,
--			--x = w/2,
--			--y = -160,
--			--width = w - 50,
--			--align = "MT",
--			--size = 22,
--		--})
--
--		
--		--hApi.addTimerOnce("__UI__BattlePanelShow",1,function()
--			--if _frame.data.show==0 then
--				--_frame:show(1)
--				
--			--end
--		--end)
--		--return _frame
--	--end
--	
--	--hGlobal.event:listen("localEvent_HeroCaptureEnemy","__ShowBattleInfo__",function(oWorld,oUnit,oTarget)
--		--if oUnit:getowner()==hGlobal.LocalPlayer then
--			--local model = oTarget:gettab().model
--			--local animation = hApi.animationByFacing(model,"stand",180)
--
--			--local id,num = oTarget:calculate("CaptureUnit")
--			--local tTab = oTarget:gettab()
--			--local rewardTable = {world = oWorld,unit = oUnit,target = oTarget}
--			--rewardTable.diaType = 2
--			--if num and num>0 then
--				--rewardTable[#rewardTable+1] = {model=model,animation=animation,name = hApi.GetLootName(tTab.loot[nIndex]),num = num,index = 1}
--			--end
--			--hGlobal.UI.BattlePanel(rewardTable,function(i,reward)	--战斗对话面板
--				--print("你选择了" .. i)
--				--if 1 == i then
--					--local captureIndex = rewardTable[i].index or 0
--					--hGlobal.LocalPlayer:order(oWorld,hVar.OPERATE_TYPE.UNIT_CAPTURE,oUnit,captureIndex,oTarget,oTarget.data.gridX,oTarget.data.gridY)
--				--else
--					--hGlobal.LocalPlayer:order(oWorld,hVar.OPERATE_TYPE.UNIT_ATTACK,oUnit,hVar.ZERO,oTarget,oTarget.data.gridX,oTarget.data.gridY)
--				--end
--				--hUI.Disable(300,"关闭战斗对话面板")
--			--end):show(1,"fade")
--		--end
--	--end)
----end
--
--
--
----监听pvp铜雀台游戏结束事件，显示结束界面
--hGlobal.event:listen("LocalEvent_GameOver_PVP_Endless","__Show", function(nIsWin)
--	--关闭同步日志文件
--	hApi.SyncLogClose()
--	--关闭非同步日志文件
--	hApi.AsyncLogClose()
--	
--	--删除可能的投降对话框界面
--	if hGlobal.UI.PhonePlayerTouXiangFrm then
--		hGlobal.UI.PhonePlayerTouXiangFrm:del()
--		hGlobal.UI.PhonePlayerTouXiangFrm = nil
--	end
--	
--	--删除可能的pvp等待玩家的界面
--	if hGlobal.UI.PhoneDelayPlayerFrm then
--		hGlobal.UI.PhoneDelayPlayerFrm:del()
--		hGlobal.UI.PhoneDelayPlayerFrm = nil
--	end
--	
--	--清除上一次的pvp结束界面
--	if hGlobal.UI.__GameOverPanel_pvp then
--		hGlobal.UI.__GameOverPanel_pvp:del()
--		hGlobal.UI.__GameOverPanel_pvp = nil
--		--print("清除上一次的pvp结束界面")
--	end
--	
--	--删除可能的响应时间过长框界面
--	if hGlobal.UI.PhonePlayerNoHeartFrm then
--		hGlobal.UI.PhonePlayerNoHeartFrm:del()
--		hGlobal.UI.PhonePlayerNoHeartFrm = nil
--	end
--	
--	local world = hGlobal.WORLD.LastWorldMap
--	
--	--防止弹框
--	if (not world) then
--		return
--	end
--	
--	local mapInfo = world.data.tdMapInfo
--	local oPlayerMe = world:GetPlayerMe()
--	local heros = oPlayerMe.heros --我出战的英雄
--	local tactics = oPlayerMe.data.tactics --我出战的战术卡和塔
--	
--	local w,h = hVar.SCREEN.w+10, hVar.SCREEN.h
--	local x,y = hVar.SCREEN.w/2-w/2, hVar.SCREEN.h
--	local scale = 1
--	local btnScale = 0.9							--按钮缩放
--	local bIsStarShow = false						--必须在星星显示完后才可以进行其他操作
--	local nScreenY = -5							--根据机器类型（手机，平板）调正整体位置
--	if (0 == g_phone_mode) then --平板模式
--		nScreenY = -80
--	end
--	
--	--加载 pvp.plist
--	xlLoadResourceFromPList("data/image/misc/pvp.plist")
--	
--	--pvp结束界面
--	hGlobal.UI.__GameOverPanel_pvp = hUI.frame:new({
--		x = x,
--		y = y,
--		w = w,
--		h = h,
--		dragable = 2,
--		show = 1,
--		background = "UI:tip_item",					--透明面板
--		border	= "UI:TileFrmBasic_thin",				--细边框
--	})
--	
--	local _frame = hGlobal.UI.__GameOverPanel_pvp
--	local _parent = _frame.handle._n
--	local _childUI = _frame.childUI
--	local _CODE_ExitGame = hApi.DoNothing					--场景切换，删除地图
--	
--	--【描述】-------------------------------------------------------------------------------------------
--	local nGameDescribeX, nGameDescribeY = w/2, nScreenY-79
--	--“成功”，“失败”
--	_childUI["WinOrLose_image"] = hUI.image:new({
--		parent = _parent,
--		model = "MODEL:Default",
--		x = nGameDescribeX,
--		y = nGameDescribeY + 24,
--		z = 1
--	})
--	
--	local content = nil									--保存标题：“通关” 或 “失败”
--	local nSize = nil									--记录标题（“通关”，“失败”）大小
--	--【根据输赢，控制部件的显示，和任务奖励的创建】
--	if (nIsWin == 1) then									--通关
--		content = "UI:Pvp_Win"
--		nSize = {146, 76}
--	else
--		content = "UI:losej"
--		nSize = {146, 76}
--	end
--	
--	--[标题“成功”或“失败”]
--	_childUI["WinOrLose_image"].handle._n:setVisible(true)
--	_childUI["WinOrLose_image"]:setmodel(content,nil,nil,nSize[1],nSize[2]) --nSize[1],nSize[2]中保持有content中图标的款和高
--	
--	--[[
--	--游戏结果背景
--	_childUI["Resource_background1"] = hUI.bar:new({
--		parent = _parent,
--		model = "UI:card_select_back",
--		w = 576,
--		h = 111,
--		x = nGameDescribeX,
--		y = nGameDescribeY + 24,
--	})
--	]]
--	
--	local nBackGroundX, nBackGroundY = w/2, nScreenY-110
--	
--	--[[
--	--光芒底线
--	_childUI["LightLine_image"] = hUI.image:new({
--		model = "UI:lightline",
--		parent = _parent,
--		w = 700,
--		h = 14,
--		x = nBackGroundX,
--		y = nBackGroundY - 63,
--	})
--	]]
--	--[[
--	--玩家名
--	_childUI["PlayerName"] = hUI.label:new({
--		parent = _parent,
--		x = nBackGroundX,
--		y = nBackGroundY - 110,
--		--text = hVar.tab_string["__TEXT_GetScore"]..":",
--		text = g_curPlayerName,
--		font = hVar.FONTC,
--		border = 1,
--		width = 550,
--		align = "MC",
--		size = 30,
--	})
--	_childUI["PlayerName"].handle.s:setColor(ccc3(0, 255, 0))
--	]]
--	--分割线1
--	_childUI["Separate1"] = hUI.image:new({
--		model = "UI:lightline",
--		parent = _parent,
--		w = 400,
--		h = 4,
--		x = nBackGroundX,
--		y = nBackGroundY - 10,
--	})
--	
--	--使用英雄
--	_childUI["UsedHeroLabel"] = hUI.label:new({
--		parent = _parent,
--		x = nBackGroundX - 200,
--		y = nBackGroundY - 70,
--		--text = "使用英雄", --language
--		text = hVar.tab_string["__TEXT_Use"] .. hVar.tab_string["hero"], --language
--		font = hVar.FONTC,
--		border = 1,
--		width = 550,
--		align = "LC",
--		size = 24,
--	})
--	
--	--依次绘制英雄
--	local WIDTH = 55
--	local OFFSET_Y = 65 --每一栏的y间距
--	local offsetX_hero = 0
--	--[[
--	if ((#heros % 2) == 1) then --奇数
--		offsetX_hero = (#heros - 1) / 2 * (WIDTH + 6) - (WIDTH + 6) / 2
--	else --偶数
--		offsetX_hero = (#heros - 2) / 2 * (WIDTH + 6)
--	end
--	]]
--	for i = 1, #heros, 1 do
--		local oHero = heros[i]
--		local heroId = oHero.data.id
--		local heroLv = 1
--		
--		local tHeroCards = Save_PlayerData.herocard
--		if tHeroCards then
--			for i = 1, #tHeroCards, 1 do
--				if (type(tHeroCards[i])=="table") then
--					local typeId = tHeroCards[i].id
--					if (typeId == heroId) then
--						heroLv = tHeroCards[i].attr.level
--						break
--					end
--				end
--			end
--		end
--		
--		--英雄背景图
--		_childUI["heroImgBG" .. i] = hUI.image:new({
--			parent = _parent,
--			model = "UI:slotSmall",
--			animation = "lightSlim",
--			x = nBackGroundX - 10 + (i - 1) * (WIDTH + 6 + 10) + offsetX_hero,
--			y = nBackGroundY - 70 - OFFSET_Y * 0,
--			w = WIDTH,
--			h = WIDTH,
--		})
--		
--		--英雄头像
--		_childUI["heroImgBG" .. i] = hUI.image:new({
--			parent = _parent,
--			model = hVar.tab_unit[heroId].icon,
--			x = nBackGroundX - 10 + (i - 1) * (WIDTH + 6 + 10) + offsetX_hero,
--			y = nBackGroundY - 70 - OFFSET_Y * 0,
--			w = WIDTH - 5,
--			h = WIDTH - 5,
--		})
--		
--		--英雄等级背景图
--		_childUI["labLvUpFlagBG"..i]= hUI.image:new({
--			parent = _parent,
--			model = "ui/pvp/pvpselect.png",
--			x = nBackGroundX - 10 + (i - 1) * (WIDTH + 6 + 10) + offsetX_hero + 20,
--			y = nBackGroundY - 70 - OFFSET_Y * 0 + 20,
--			w = 34,
--			h = 34,
--		})
--		
--		--英雄等级
--		local fontSize = 24
--		if heroLv and (heroLv >= 10) then --如果等级是2位数的，那么缩一下文字
--			fontSize = 16
--		end
--		_childUI["labLvUpFlag"..i] = hUI.label:new({
--			parent = _parent,
--			align  = "MC",
--			x = nBackGroundX - 10 + (i - 1) * (WIDTH + 6 + 10) + offsetX_hero + 20,
--			y = nBackGroundY - 70 - OFFSET_Y * 0 + 20 - 1,
--			--text = "lv".. tostring(heroLv),
--			text = tostring(heroLv),
--			size = fontSize,
--			font = "numWhite",
--			border = 1,
--		})
--	end
--	
--	--未使用英雄，显示文本
--	if (#heros == 0) then
--		_childUI["UsedHeroNoneLabel"] = hUI.label:new({
--			parent = _parent,
--			x = nBackGroundX - 30,
--			y = nBackGroundY - 70 - OFFSET_Y * 0,
--			--text = "无", --language
--			text = hVar.tab_string["__TEXT_Nothing"], --language
--			font = hVar.FONTC,
--			border = 1,
--			width = 550,
--			align = "MC",
--			size = 24,
--		})
--	end
--	
--	------------------------
--	--提取出塔
--	local towers = {}
--	for i = 1, #tactics, 1 do
--		local id = tactics[i][1]
--		local lv = tactics[i][2]
--		local tabT = hVar.tab_tactics[id]
--		if tabT then
--			local type = tabT.type --战术技能卡类型
--			if (type == hVar.TACTICS_TYPE.TOWER) then --只处理塔类战术技能卡
--				towers[#towers + 1] = {id, lv}
--			end
--		end
--	end
--	
--	--使用塔
--	_childUI["UsedTacticLabel"] = hUI.label:new({
--		parent = _parent,
--		x = nBackGroundX - 200,
--		y = nBackGroundY - 70 - OFFSET_Y * 1,
--		--text = "使用塔",
--		text = hVar.tab_string["__TEXT_Use"] .. hVar.tab_string["__TEXT_SOLDIER_TOWER"], --language
--		font = hVar.FONTC,
--		border = 1,
--		width = 550,
--		align = "LC",
--		size = 24,
--	})
--	
--	--依次绘制塔
--	local offsetX_tower = 0
--	--[[
--	if ((#towers % 2) == 1) then --奇数
--		offsetX_tower = (#towers - 1) / 2 * (WIDTH + 6) - (WIDTH + 6) / 2
--	else --偶数
--		offsetX_tower = (#towers - 2) / 2 * (WIDTH + 6)
--	end
--	]]
--	for i = 1, #towers, 1 do
--		local towerId = towers[i][1]
--		local towerLv = towers[i][2]
--		
--		--塔的图标
--		_childUI["towerImg" .. i] = hUI.image:new({
--			parent = _parent,
--			model = hVar.tab_tactics[towerId].icon,
--			x = nBackGroundX - 10 + (i - 1) * (WIDTH + 6 + 10) - offsetX_tower,
--			y = nBackGroundY - 70 - OFFSET_Y * 1,
--			w = WIDTH,
--			h = WIDTH,
--		})
--		
--		--塔等级背景图
--		_childUI["towerFlagBG"..i]= hUI.image:new({
--			parent = _parent,
--			model = "ui/pvp/pvpselect.png",
--			x = nBackGroundX - 10 + (i - 1) * (WIDTH + 6 + 10) - offsetX_tower + 20,
--			y = nBackGroundY - 70 - OFFSET_Y * 1 + 20,
--			w = 34,
--			h = 34,
--		})
--		
--		--塔等级
--		local fontSize = 24
--		if towerLv and (towerLv >= 10) then --如果等级是2位数的，那么缩一下文字
--			fontSize = 16
--		end
--		_childUI["towerUpFlag"..i] = hUI.label:new({
--			parent = _parent,
--			align  = "MC",
--			x = nBackGroundX - 10 + (i - 1) * (WIDTH + 6 + 10) - offsetX_tower + 20,
--			y = nBackGroundY - 70 - OFFSET_Y * 1 + 20 - 1,
--			--text = "lv".. tostring(towerLv),
--			text = tostring(towerLv),
--			size = fontSize,
--			font = "numWhite",
--			border = 1,
--		})
--	end
--	
--	--未使用塔，显示文本
--	if (#towers == 0) then
--		_childUI["UsedTowerNoneLabel"] = hUI.label:new({
--			parent = _parent,
--			x = nBackGroundX - 30,
--			y = nBackGroundY - 70 - OFFSET_Y * 1,
--			--text = "无", --language
--			text = hVar.tab_string["__TEXT_Nothing"], --language
--			font = hVar.FONTC,
--			border = 1,
--			width = 550,
--			align = "MC",
--			size = 24,
--		})
--	end
--	
--	--【奖励】的东西-------------------------------------------------------------------------
--	local nAwardX, nAwardY = w/2, nScreenY - 440
--	
--	--奖励背景
--	_childUI["Resource_background1"] = hUI.bar:new({
--		parent = _parent,
--		model = "UI:card_select_back",
--		x = nBackGroundX,
--		y = nBackGroundY - 370,
--		w = 576,
--		h = 113,
--	})
--	
--	--[[
--	--积分图标
--	local iconW, iconH = 64, 64
--	_childUI["Score_image"] = hUI.image:new({
--		model = "UI:score",
--		parent = _parent,
--		x = nGameDescribeX - 115,
--		y = nGameDescribeY - 280 - 10,
--		w = iconW,
--		h = iconH
--		--scale = 0.8,
--	})
--	
--	_childUI["GetScoreName"] = hUI.label:new({
--		parent = _parent,
--		align  = "MT",
--		x = _childUI["Score_image"].data.x,
--		y = nGameDescribeY - 280 + 48,
--		text = hVar.tab_string["ios_score"], --"积分"
--		font = hVar.FONTC,
--		border = 1,
--		width = 180,
--		RGB = {255,255,0},
--	})
--	_childUI["GetScore1"] = hUI.label:new({ --积分数值
--		parent = _parent,
--		align  = "MT",
--		x = _childUI["Score_image"].data.x,
--		y = _childUI["Score_image"].data.y - 35,
--		text = "",
--		font = "numWhite",
--		size = 16,
--		border = 1,
--		width = 300,
--	})
--	]]
--	
--	--本关防守进度
--	_childUI["labDefProgress"] = hUI.label:new({
--		parent = _parent,
--		--align  = "MC",
--		x = nGameDescribeX - 285,
--		y = nBackGroundY - 283,
--		text = "",
--		font = hVar.FONTC,
--		border = 1,
--		width = 300,
--	})
--	--本关防守进度值
--	_childUI["labDefProgressNum"] = hUI.label:new({
--		parent = _parent,
--		align  = "LC",
--		x = nGameDescribeX - 146,
--		y = nBackGroundY - 296,
--		text = "",
--		size = 20,
--		font = "numWhite",
--		border = 1,
--		width = 300,
--	})
--	
--	--本关击杀单位
--	_childUI["labKillUnit"] = hUI.label:new({
--		parent = _parent,
--		--align  = "RT",
--		x = nGameDescribeX + 50,
--		y = nBackGroundY - 283,
--		text = "",
--		font = hVar.FONTC,
--		border = 1,
--		width = 300,
--	})
--	_childUI["labKillUnitNum"] = hUI.label:new({
--		parent = _parent,
--		align  = "LC",
--		x = nBackGroundX + 190,
--		y = nBackGroundY - 296,
--		text = "",
--		size = 20,
--		font = "numWhite",
--		border = 1,
--		width = 300,
--	})
--	
--	if (nIsWin == 1) then --胜利
--		_childUI["Resource_background1"].handle._n:setVisible(false)
--		--_childUI["GetScore1"]:setText("+"..tostring(scoreV))
--		_childUI["labDefProgress"]:setText("")
--		_childUI["labDefProgressNum"]:setText("")
--		_childUI["labKillUnit"]:setText("")
--		_childUI["labKillUnitNum"]:setText("")
--	else
--		_childUI["Resource_background1"].handle._n:setVisible(true)
--		_childUI["labDefProgress"]:setText(hVar.tab_string["__TEXT_DefProgress"] .. ":") --"防守进度"
--		_childUI["labDefProgressNum"]:setText((mapInfo.wave).."/"..(mapInfo.totalWave))
--		_childUI["labKillUnit"]:setText(hVar.tab_string["__TEXT_KillUnit"] .. ":")
--		_childUI["labKillUnitNum"]:setText((world.data.statistics.killEnemyNum))
--		
--		--显示失败小贴士
--		hApi.CreateFailHintFrame(1, hGlobal.UI.__GameOverPanel_pvp)
--	end
--	
--	--【按钮】--------------------------------------------------------------------
--	local nButtonX, nButtonY  = w/2, nScreenY-410
--	--“主界面”按钮
--	_childUI["btnOk"] = hUI.button:new({
--		parent = _parent,
--		dragbox = _childUI["dragBox"],
--		model = "UI:ButtonBack",
--		icon = "ui/hall.png",
--		iconWH = 28,
--		label = " "..hVar.tab_string["__TEXT_MainInterface"],
--		font = hVar.FONTC,
--		border = 1,
--		align = "MC",
--		scaleT = 0.9,
--		x = nButtonX,
--		y = nButtonY - 170,
--		scale = btnScale,
--		code = function(self)
--			--geyachao: 这里会弹框？？？暂时注释掉
--			--local mapName = hGlobal.WORLD.LastWorldMap.data.map	--zhenkira
--			
--			--_chestPoolExitFun()
--			_frame:show(0)
--			_CODE_ExitGame()				--删除地图等操作
--		end,
--	})
--	_childUI["btnOk"]:setstate(1)
--	_childUI["btnOk"].childUI["label"].handle._n:setPosition(-35,12)
--	_childUI["btnOk"].childUI["icon"].handle._n:setPosition(-60,1)
--	
--	--关闭地图
--	_CODE_ExitGame = function()
--		if hGlobal.UI.__GameOverPanel_pvp then
--			hGlobal.UI.__GameOverPanel_pvp:del()
--			hGlobal.UI.__GameOverPanel_pvp = nil
--		end
--		
--		--删除pvp资源
--		xlReleaseResourceFromPList("data/image/misc/pvp.plist")
--		
--		hUI.Disable(0, "离开游戏")
--		--if hGlobal.WORLD.LastWorldMap then
--		--	hGlobal.WORLD.LastWorldMap:del()
--		--	hGlobal.WORLD.LastWorldMap = nil
--		--	hGlobal.LocalPlayer:setfocusworld(nil)
--		--	hApi.clearCurrentWorldScene()
--		--end
--		--hGlobal.event:event("LocalEvent_OpenPhoneMainMenu")
--		
--		if hGlobal.WORLD.LastWorldMap then
--			local w = hGlobal.WORLD.LastWorldMap
--			local currentMapMode = w.data.tdMapInfo and (w.data.tdMapInfo.mapMode)
--			local map = w.data.map
--			local tabM = hVar.MAP_INFO[map]
--			local chapterId = 1
--			if tabM then
--				chapterId = tabM.chapter or 1
--			end
--			
--			hGlobal.WORLD.LastWorldMap:del()
--			hGlobal.WORLD.LastWorldMap = nil
--			hGlobal.LocalPlayer:setfocusworld(nil)
--			hApi.clearCurrentWorldScene()
--			
--			if (currentMapMode == hVar.MAP_TD_TYPE.ENDLESS) or (currentMapMode == hVar.MAP_TD_TYPE.PVP) then --无尽地图、pvp
--				--切换到新主界面事件
--				hGlobal.event:event("LocalEvent_OpenPhoneMainMenu")
--			else
--				hGlobal.event:event("LocalEvent_Phone_ShowPhone_SelecteMap", chapterId)
--				--hGlobal.event:event("LocalEvent_Phone_ShowReturnContinue",1)
--				--hApi.setViewNodeFocus(hVar.SCREEN.w/2,hVar.SCREEN.h/2)
--			end
--		end
--	end
--	
--	if (nIsWin == 1) then --胜利
--		--显示正在获取奖励
--		_childUI["WinStarWaitingImg"] = hUI.image:new({
--			parent = _parent,
--			x = nBackGroundX,
--			y = nBackGroundY - 320,
--			model = "MODEL_EFFECT:waiting",
--			w = 64,
--			h = 64,
--		})
--		
--		_childUI["WinStarWaitingLabel"] = hUI.label:new({
--			parent = _parent,
--			x = nBackGroundX,
--			y = nBackGroundY - 270,
--			font = hVar.FONTC,
--			width = 300,
--			align = "MC",
--			size = 26,
--			--text = "正在获取奖励...", --language
--			text = hVar.tab_string["__TEXT_GettingRewarss"], --language
--			border = 1,
--			RGB = {192, 192, 192},
--		})
--		
--		--如果在显示此界面时已经发抽奖结果了，那么直接显示界面
--		local pvp_rewardInfo = world.data.pvp_rewardInfo
--		if pvp_rewardInfo and (pvp_rewardInfo ~= 0) then
--			--显示界面
--			hApi.safeRemoveT(_childUI, "WinStarWaitingImg")
--			hApi.safeRemoveT(_childUI, "WinStarWaitingLabel")
--			hGlobal.event:event("localEvent_ShowChoiceAwardFrm_PVP", pvp_rewardInfo, hGlobal.UI.__GameOverPanel_pvp)
--		end
--		
--		--监听可能的发抽奖结果事件
--		hGlobal.event:listen("localEvent_ShowChoiceAwardFrm", "TD_GameEnd_ShowChoiceAward", function(rewardInfo)
--			hGlobal.event:listen("localEvent_ShowChoiceAwardFrm", "TD_GameEnd_ShowChoiceAward", nil)
--			local world = hGlobal.WORLD.LastWorldMap
--			if world then
--				--存储pvp铜雀台游戏结束抽奖结果
--				world.data.pvp_rewardInfo = rewardInfo
--				
--				--显示界面
--				hApi.safeRemoveT(_childUI, "WinStarWaitingImg")
--				hApi.safeRemoveT(_childUI, "WinStarWaitingLabel")
--				hGlobal.event:event("localEvent_ShowChoiceAwardFrm_PVP", rewardInfo, hGlobal.UI.__GameOverPanel_pvp)
--			end
--		end)
--	end
--	--------------------------------------------------------
--end)
--
--
--






--监听大菠萝游戏结束事件，显示结束界面
hGlobal.event:listen("LocalEvent_GameOver_Diablo","__Show", function(nIsWin)
	--关闭同步日志文件
	hApi.SyncLogClose()
	--关闭非同步日志文件
	hApi.AsyncLogClose()

	hGlobal.event:event("CloseSystemMenuIntegrateFrm")
	
	--删除可能的投降对话框界面
	if hGlobal.UI.PhonePlayerTouXiangFrm then
		hGlobal.UI.PhonePlayerTouXiangFrm:del()
		hGlobal.UI.PhonePlayerTouXiangFrm = nil
	end
	
	--删除可能的pvp等待玩家的界面
	if hGlobal.UI.PhoneDelayPlayerFrm then
		hGlobal.UI.PhoneDelayPlayerFrm:del()
		hGlobal.UI.PhoneDelayPlayerFrm = nil
	end
	
	--清除上一次的pvp结束界面
	if hGlobal.UI.__GameOverPanel_Diablo then
		hGlobal.UI.__GameOverPanel_Diablo:del()
		hGlobal.UI.__GameOverPanel_Diablo = nil
		--print("清除上一次的pvp结束界面")
	end
	
	--删除可能的响应时间过长框界面
	if hGlobal.UI.PhonePlayerNoHeartFrm then
		hGlobal.UI.PhonePlayerNoHeartFrm:del()
		hGlobal.UI.PhonePlayerNoHeartFrm = nil
	end
	
	--移除监听
	hGlobal.event:listen("LocalEvent_OnSendGameEndInfoRet", "__SendGameEndInfoRet", nil) --通知上传战斗结果返回
	hGlobal.event:listen("LocalEvent_OnReceiveTankMapFinishReward", "__TankMapFinishReward", nil)
	hGlobal.event:listen("LocalEvent_RequireBattleNormalRet", "__RequireBattleNormalRet_GameEnd", nil)
	hGlobal.event:listen("LocalEvent_SpinScreen","GameOverPanel_Diablo", nil)
	
	local world = hGlobal.WORLD.LastWorldMap
	
	--防止弹框
	if (not world) then
		return
	end
	local mapInfo = world.data.tdMapInfo
	mapInfo.mapState = hVar.MAP_TD_STATE.END

	if (nIsWin == 0) then
		local diablodata = hGlobal.LocalPlayer.data.diablodata
		if diablodata and type(diablodata.randMap) == "table" then
			hGlobal.event:event("LocalEvent_ShowTotalSettlement")
			return
		end
	end
	
	local mapInfo = world.data.tdMapInfo
	local mapName = world.data.map --地图名
	local mapMode = mapInfo.mapMode --当前游戏模式
	local mapDifficulty = mapInfo.mapDifficulty --当前游戏难度
	local oPlayerMe = world:GetPlayerMe()
	local heros = oPlayerMe.heros --我出战的英雄
	local tactics = oPlayerMe.data.tactics --我出战的战术卡和塔
	
	local w,h = hVar.SCREEN.w, hVar.SCREEN.h
	local x,y = hVar.SCREEN.w/2-w/2, hVar.SCREEN.h
	local scale = 1
	local btnScale = 0.9							--按钮缩放
	local bIsStarShow = false						--必须在星星显示完后才可以进行其他操作
	
	--加载 pvp.plist
	xlLoadResourceFromPList("data/image/misc/pvp.plist")
	
	--print("大菠萝结束界面")
	
	--大菠萝结束界面
	hGlobal.UI.__GameOverPanel_Diablo = hUI.frame:new({
		x = x,
		y = y,
		w = w,
		h = h,
		dragable = 2,
		show = 1,
		--background = "UI:tip_item",					--透明面板
		background = -1,
		--border	= "UI:TileFrmBasic_thin",				--细边框
		border = 0,
	})
	
	local _frame = hGlobal.UI.__GameOverPanel_Diablo
	local _parent = _frame.handle._n
	local _childUI = _frame.childUI
	local _CODE_ExitGame = hApi.DoNothing --场景切换，删除地图
	local _CODE_RestartGame = hApi.DoNothing --重玩本关
	local _CODE_NextMapGame = hApi.DoNothing --跳到下一关
	
	--黑色底板
	_childUI["imgBackground"] = hUI.image:new({
		parent = _parent,
		model = "misc/mask_white.png",
		x = hVar.SCREEN.w / 2,
		y = -hVar.SCREEN.h / 2,
		w = hVar.SCREEN.w,
		h = hVar.SCREEN.h,
	})
	_childUI["imgBackground"].handle.s:setOpacity(168)
	_childUI["imgBackground"].handle.s:setColor(ccc3(0, 0, 0))
	
	--【描述】-------------------------------------------------------------------------------------------
	local nGameDescribeX = w / 2
	local nGameDescribeY = -195
	
	if (g_phone_mode == 1) then --iPhone4
		nGameDescribeY = -125
	elseif (g_phone_mode == 2) then --iPhone5
		nGameDescribeY = -130
	elseif (g_phone_mode == 3) then --iPhone6, iPhone7, iPhone8
		nGameDescribeY = -105
	elseif (g_phone_mode == 4) then --iPhoneX
		nGameDescribeY = -105
	end
	
	if hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.VERTICAL then
		nGameDescribeY = nGameDescribeY - 260
	end
	
	local content = nil									--保存标题：“通关” 或 “失败”
	local nSize = nil									--记录标题（“通关”，“失败”）大小

	local lostDelayY = 0

	if (nIsWin == 0) then
		nGameDescribeY = nGameDescribeY + 30
		lostDelayY = - 60
	end
	
	--“成功”，“失败”
	--_childUI["WinOrLose_image"] = hUI.image:new({
		--parent = _parent,
		--model = "MODEL:Default",
		--x = nGameDescribeX,
		--y = nGameDescribeY + 40 + lostDelayY,
		--z = 1
	--})
	
	--评价三星
	local starmax = "misc/gameover/star_light.png"
	local maxStar = 0
	local starDelta = 126
	if (nIsWin == 1) then
		--暗星星
		for i = 1, 3, 1 do
			_childUI["stardark_" .. i] = hUI.image:new({
				parent = _parent,
				model = "misc/gameover/star_dark.png",
				w = 100,
				h = 100,
				x =  nGameDescribeX - starDelta + (i - 1) * starDelta,
				y = nGameDescribeY + 10,
				scale = 1.0,
			})
		end

		--检测评价星级
		local starCondition = hVar.MAP_INFO[mapName].starCondition or {}
		for s = 1, 3, 1 do
			local tCondition = starCondition[s] or {}
			local condition = tCondition.condition or 0 --条件
			local value1 = tCondition.value1 or 0 --参数1
			local value2 = tCondition.value2 or 0 --参数2
			
			if (condition == hVar.MEDAL_TYPE.passSuccess) then --成功通关关卡
				maxStar = maxStar + 1
				print("★+1 : 成功通关关卡")
			elseif (condition == hVar.MEDAL_TYPE.passTimeLess) then --通关时间少于指定值
				local gametime = world:gametime()
				local seconds = math.ceil(gametime / 1000)
				if (seconds <= value1) then
					maxStar = maxStar + 1
					print("★+1 : 通关时间少于" .. value1 .. "秒")
				else
					print("未获星 : 通关时间未小于" .. value1 .. "秒，实际时间为" .. seconds .. "秒")
				end
			elseif (condition == hVar.MEDAL_TYPE.passTimeMore) then --通关时间大于指定值
				local gametime = world:gametime()
				local seconds = math.ceil(gametime / 1000)
				if (seconds >= value1) then
					maxStar = maxStar + 1
					print("★+1 : 通关时间大于" .. value1 .. "秒")
				else
					print("未获星 : 通关时间未大于" .. value1 .. "秒，实际时间为" .. seconds .. "秒")
				end
			elseif (condition == hVar.MEDAL_TYPE.passHeroDeathLess) then --通关英雄死亡次数少于指定值
				local me = world:GetPlayerMe()
				local upos = me:getpos()
				local deadCount = world.data.statistics.deadCount[upos] or 0
				if (deadCount < value1) then
					maxStar = maxStar + 1
					print("★+1 : 英雄死亡次数少于" .. value1 .. "次")
				else
					print("未获星 : 英雄死亡次数未小于" .. value1 .. "次")
				end
			elseif (condition == hVar.MEDAL_TYPE.passKillUnit) then --通关击杀指定单位n次
				local count = world.data.unitdeathcounts[2][value1] or 0
				if (count >= value2) then
					maxStar = maxStar + 1
					print("★+1 : 击杀" .. value1 .. "达到" .. value2 .. "次")
				else
					print("未获星 : 击杀" .. value1 .. "未达到" .. value2 .. "次")
				end
			elseif (condition == hVar.MEDAL_TYPE.passProtectUnit) then --通关保护指定单位不死
				local count = world.data.unitdeathcounts[2][value1] or 0
				if (count <= 0) then
					maxStar = maxStar + 1
					print("★+1 : 保护" .. value1 .. "不死")
				else
					print("未获星 : 保护" .. value1 .. "死亡次数达到" .. count .. "次")
				end
			end
		end
	end

	--【根据输赢，控制部件的显示，和任务奖励的创建】
	if (nIsWin == 1) then									--通关
		--content = "misc/gameover/win.png"
		--nSize = {342, 70}
		if maxStar == 1 then
			content = "misc/gameover/survive.png"
			nSize = {348,72}
		elseif maxStar == 2 then
			content = "misc/gameover/good.png"
			nSize = {256,72}
		elseif maxStar == 3 then
			content = "misc/gameover/excellent.png"
			nSize = {436,72}
		end
	else
		content = "misc/gameover/game_over.png"
		nSize = {430, 68}
	end
	--[标题“成功”或“失败”]
	--_childUI["WinOrLose_image"].handle._n:setVisible(true)
	--_childUI["WinOrLose_image"]:setmodel(content,nil,nil,nSize[1],nSize[2]) --nSize[1],nSize[2]中保持有content中图标的款和高
	
	--[[
	--geyachao: 这里改为服务器结算后再下发客户端，存储通关进度
	--大菠萝，记录星星和难度
	if (mapMode == hVar.MAP_TD_TYPE.NORMAL) then --普通模式
		--本次星星比存档的多，更新最高星星
		local oldStar = LuaGetPlayerMapAchi(mapName, hVar.ACHIEVEMENT_TYPE.MAPSTAR) or 0
		if (maxStar > oldStar) then
			LuaSetPlayerMapAchi(mapName, hVar.ACHIEVEMENT_TYPE.MAPSTAR, maxStar, true)
		end
		
		--三星开启挑战1模式
		if (maxStar >= 3) then
			if (maxStar > oldStar) then
				--普通模式记录星星
				LuaSetPlayerMapAchi(mapName, hVar.ACHIEVEMENT_TYPE.Map_Difficult, 1, true)
				LuaSetPlayerMapAchi(mapName, hVar.ACHIEVEMENT_TYPE.IMPERIAL, 0, true)
			end
		end
	elseif (mapMode == hVar.MAP_TD_TYPE.DIFFICULT) then --挑战模式
		--如果选择难度小于已达到的最大难度，则直接跳过，不需要给星级奖励，但会给积分
		local diffMax = (LuaGetPlayerMapAchi(mapName,hVar.ACHIEVEMENT_TYPE.Map_Difficult) or 0)
		if (mapDifficulty < diffMax) then
			--当前难度比历史最高难度小，不处理
			--...
		else
			--获取挑战模式当前难度历史所得星数
			local oldStar = (LuaGetPlayerMapAchi(mapName,hVar.ACHIEVEMENT_TYPE.IMPERIAL) or 0)
			if (maxStar > oldStar) then
				--更新星数,获取奖励
				LuaSetPlayerMapAchi(mapName, hVar.ACHIEVEMENT_TYPE.IMPERIAL, maxStar, true)
				
				--如果当前获得三星，则开启下一难度
				if (maxStar >= 3) then
					local diff = diffMax + 1
					--未达到最大难度则开启下一难度，否则停留在当前难度
					if diff <= mapInfo.mapMaxDiff then
						LuaSetPlayerMapAchi(mapName,hVar.ACHIEVEMENT_TYPE.Map_Difficult,diff,true)
						LuaSetPlayerMapAchi(mapName,hVar.ACHIEVEMENT_TYPE.IMPERIAL,0,true)
					end
				end
			end
		end
	end
	]]
	
	---------------------------------------------------------------------------------------------------
	--geyachao: 临时结算界面
	if (nIsWin == 1) then
		--存宝箱
		print("存宝箱")
		local weapongunChestNum = 0 --武器枪宝箱
		local tacticChestNum = 0 --战术卡宝箱
		local petChestNum = 0 --宠物宝箱
		local equipChestNum = 0 --装备宝箱
		local tInfo = GameManager.GetGameInfo("chestInfo")
		for itemId, itemNum in pairs(tInfo) do
			--print(itemId, itemNum)
			local tabI = hVar.tab_item[itemId] or {}
			local itemType = tabI.type
			
			--统计武器枪宝箱
			if (itemType == hVar.ITEM_TYPE.CHEST_WEAPON_GUN) then
				 weapongunChestNum = weapongunChestNum + itemNum
				
			end
			
			--统计战术卡宝箱
			if (itemType == hVar.ITEM_TYPE.CHEST_TACTIC) then
				 tacticChestNum = tacticChestNum + itemNum
			end
			
			--统计宠物宝箱
			if (itemType == hVar.ITEM_TYPE.CHEST_PET) then
				petChestNum = petChestNum + itemNum
			end
			
			--统计装备宝箱
			if (itemType == hVar.ITEM_TYPE.CHEST_EQUIP) then
				equipChestNum = equipChestNum + itemNum
			end
		end
		
		
		--存科学家
		print("存科学家")
		local scientistNum = world.data.statistics_rescue_num --武器枪宝箱
		
		print("weapongunChestNum=", weapongunChestNum)
		print("tacticChestNum=", tacticChestNum)
		print("petChestNum=", petChestNum)
		print("equipChestNum=", equipChestNum)
		print("scientistNum=", scientistNum)
		
		--[[
		--geyachao: 加战术卡已改为服务器发奖了，会下发客户端增加奖励
		--存战术卡碎片
		local tInfo = GameManager.GetGameInfo("tacticInfo")
		for itemId, itemNum in pairs(tInfo) do
			local tabI = hVar.tab_item[itemId] or {}
			local itemType = tabI.type
			
			--统计使用的战术卡
			if (itemType == hVar.ITEM_TYPE.TACTIC_USE) then
				 local tacticId = tabI.tacticId or 0
				if (tacticId > 0) then
					local notSaveFlag = true --不存档，最后统一存档
					LuaAddPlayerTacticDebris(tacticId, itemNum, notSaveFlag) --加战术卡碎片
				end
			end
		end
		]]
		
		--存档
		local notSaveFlag = true --不存档，最后统一存档
		LuaAddTankWeaponGunChestNum(weapongunChestNum, notSaveFlag)
		LuaAddTankTacticChestNum(tacticChestNum, notSaveFlag)
		LuaAddTankPetChestNum(petChestNum, notSaveFlag)
		LuaAddTankEquipChestNum(equipChestNum, notSaveFlag)
		--LuaAddTankScientistNum(scientistNum, notSaveFlag) --geyachao: 改为服务器下发奖励时再增加数量
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		
		--上传存档
		local keyList = {"material",}
		LuaSavePlayerData_Android_Upload(keyList, "临时结算界面")
	end
	---------------------------------------------------------------------------------------------------
	
	for i = 1, maxStar, 1 do
		--奇数（miniSta == 1）
		local model = starmax
		--if miniSta == 1 and i == maxStar then
		--	model = starmini
		--end
		
		--亮星星
		_childUI["star_" .. i] = hUI.image:new({
			parent = _parent,
			model = model,
			w = 100,
			h = 100,
			x =  nGameDescribeX - starDelta + (i - 1) * starDelta,
			y = nGameDescribeY + 10,
			scale = 1.0,
		})
		_childUI["star_"..i].handle._n:setVisible(false)
		_childUI["star_"..i].handle.s:runAction(CCScaleTo:create(0,2.5))		--缩放
	end
	
	--评价星星入场动画
	local tShowUpgradeList = {}
	local nIndex = 0
	local ActionStar = hApi.DoNothing
	ActionStar = function()
		if nIndex < maxStar then
			nIndex = nIndex + 1
			hApi.addTimerOnce("ActionOne",((nIndex == 1) and 100) or 100,function()		--第一个星星弹出之前的时间间隔长一些，因为画面的打开需要一定的时间
				if _childUI["star_"..nIndex] then
					_childUI["star_"..nIndex].handle._n:setVisible(true)
					local scaleA = CCScaleTo:create(0.1,0.85)
					local funcA = CCCallFunc:create(ActionStar)
					local action = CCSequence:createWithTwoActions(scaleA,funcA)
					_childUI["star_"..nIndex].handle.s:runAction(action)
				end
			end)
		else
			bIsStarShow = true
			--if #tShowUpgradeList == 0 then
				--bIsStarShow = true
			--else
				--if type(tShowUpgradeList[1]) == "table" then
					--local nUnitId,nAddExp,nLevel,nCurExp = unpack(tShowUpgradeList[1])
					----需要显示升级
					--hApi.addTimerOnce("IsStarShow",1000,function()
						--OnCreateDiabloLevelUpFrame(nUnitId,nAddExp,nLevel,nCurExp)
						--bIsStarShow = true
					--end)
				--else
					--bIsStarShow = true
				--end
			--end
			
			--星星动画播放结束后，如果是挑战难度，则出现抽卡界面。
			local MapMode = hGlobal.WORLD.LastWorldMap.data.MapMode
			if nIsWin == 1 then
				if MapMode == hVar.MAP_TD_TYPE.DIFFICULT then
					if mapInfo.chestPool and type(mapInfo.chestPool) == "table" and #mapInfo.chestPool == 5 then
						_childUI["btnOk"]:setstate(0)
						_childUI["RePlayBtn"]:setstate(0)
						_childUI["labRewardAll"].handle._n:setVisible(false)
						_chestPoolExitFun()
						G_UI_ReverseItemFrmState = 1
						local mapDifficulty = mapInfo.mapDifficulty --当前游戏难度
						--_createCardList("card_Node_",_slotX,_slotY,_slotOffX,mapInfo.chestPool,math.max(mapDifficulty or 1, 1))
						_createCardList("card_Node_",_slotX,_slotY,_slotOffX,mapInfo.chestPool,3)
					end
				end
			end
		end
	end
	ActionStar()
	--[[
	--游戏结果背景
	_childUI["Resource_background1"] = hUI.bar:new({
		parent = _parent,
		model = "UI:card_select_back",
		w = 576,
		h = 111,
		x = nGameDescribeX,
		y = nGameDescribeY + 24,
	})
	]]

	local imgStartY = - 125
	local imgDeltaY = -100
	local imgIndex = 0
	
	--游戏时间图标
	_childUI["imgGameTime"] = hUI.image:new({
		model = "misc/gameover/icon_time.png",
		parent = _parent,
		w = 56,
		h = 56,
		x = nGameDescribeX - 60,
		y = nGameDescribeY + imgStartY + imgDeltaY * imgIndex,
	})

	
	
	--游戏时间文字前缀
	--_childUI["labelGameTimePrefix"] = hUI.label:new({
		--parent = _parent,
		--x = nGameDescribeX - 20,
		--y = nGameDescribeY - 150 - 3,
		--font = "numWhite",
		--border = 0,
		--width = 550,
		--align = "LC",
		--size = 26,
		--text = ":",
	--})
	
	--游戏时间文字
	local gametime = world:gametime()
	local seconds = math.ceil(gametime / 1000)
	local minute = math.floor(seconds / 60)
	local second = seconds - minute * 60
	local strSecond = tostring(second)
	if (second < 10) then
		strSecond = "0" .. strSecond
	end
	_childUI["labelGameTime"] = hUI.label:new({
		parent = _parent,
		x = nGameDescribeX + 10,
		y = nGameDescribeY + imgStartY + imgDeltaY * imgIndex - 4,
		font = "num",
		border = 0,
		width = 550,
		align = "LC",
		size = 26,
		text = minute .. ":" .. strSecond,
	})
	
	----经验值图标
	--_childUI["imgExp"] = hUI.image:new({
		--model = "misc/gameover/icon_exp.png",
		--parent = _parent,
		--w = 56,
		--h = 56,
		--x = nGameDescribeX - 60,
		--y = nGameDescribeY - 215,
	--})
	
	--经验文字前缀
	--_childUI["labelExpPrefix"] = hUI.label:new({
		--parent = _parent,
		--x = nGameDescribeX - 20,
		--y = nGameDescribeY - 215 - 3,
		--font = "numWhite",
		--border = 0,
		--width = 550,
		--align = "LC",
		--size = 26,
		--text = ":",
	--})
	
	----经验值文字
	--local expAdd = hVar.MAP_INFO[mapName].exp or 0
	--if (nIsWin < 1) then
		--expAdd = 0
	--end
	--_childUI["labelExp"] = hUI.label:new({
		--parent = _parent,
		--x = nGameDescribeX + 10,
		--y = nGameDescribeY - 215 - 4,
		--font = "num",
		--border = 0,
		--width = 550,
		--align = "LC",
		--size = 26,
		--text = expAdd,
	--})

	imgIndex = imgIndex + 1
	--游戏营救人数图标
	_childUI["imgMan"] = hUI.image:new({
		model = "misc/gameover/icon_man.png",
		parent = _parent,
		--w = 56,
		--h = 56,
		x = nGameDescribeX - 60,
		y = nGameDescribeY + imgStartY + imgDeltaY * imgIndex,
	})
	
	_childUI["labelManNum"] = hUI.label:new({
		parent = _parent,
		x = nGameDescribeX + 10,
		y = nGameDescribeY + imgStartY + imgDeltaY * imgIndex - 4,
		font = "num",
		border = 0,
		width = 550,
		align = "LC",
		size = 26,
		text = "", --world.data.statistics_rescue_count or 0, --一开始不显示营救科学家（上传服务器等服务器处理vip额外加成营救科学家）
	})
	
	imgIndex = imgIndex + 1
	
	--金币图标
	_childUI["imgGold"] = hUI.image:new({
		--model = "misc/skillup/mu_coin.png",
		model = "misc/skillup/exp.png", --改成经验值
		parent = _parent,
		--w = 56,
		--h = 56,
		x = nGameDescribeX - 62,
		y = nGameDescribeY + imgStartY + imgDeltaY * imgIndex,
	})
	
	--金币文字前缀
	--_childUI["labelGoldPrefix"] = hUI.label:new({
		--parent = _parent,
		--x = nGameDescribeX - 20,
		--y = nGameDescribeY - 280 - 3,
		--font = "numWhite",
		--border = 0,
		--width = 550,
		--align = "LC",
		--size = 26,
		--text = ":",
	--})
	
	--[[
	--金币文字
	local goldAdd = hVar.MAP_INFO[mapName].scoreV or 0
	goldAdd = goldAdd + world.data.statistics_rescue_count * hVar.COIN_WITH_RESCUED /2
	if (nIsWin < 1) then
		local scoreingame = 0
		--引导关失败不给钱
		if world.data.map ~= hVar.GuideMap then
			local score = GameManager.GetGameInfo("scoreingame")
			if type(score) == "number" then
				scoreingame = score
			end
		end
		goldAdd = scoreingame
		LuaAddPlayerScoreByWay(goldAdd,hVar.GET_SCORE_WAY.CLEARSTAGE)
	end
	]]
	--改为显示经验值
	local expAdd = 0
	if (nIsWin == 1) then
		local me = world:GetPlayerMe()
		local expBasic = (mapInfo.exp or 0) + (me:getExpAdd() or 0)
		local expEnemy = me:getresource(hVar.RESOURCE_TYPE.EXP) or 0 --经验值
		expAdd = expBasic + expEnemy
		print("expBasic:", expBasic)
		print("expEnemy:", expEnemy)
	else
		--失败，普通图经验值为0
		if (world.data.map == hVar.QianShaoZhenDiMap) then --前哨阵地，获得1/10*wave经验值
			local expBasic = math.floor((mapInfo.exp or 0) * mapInfo.wave / 10)
			expAdd = expBasic
		elseif (world.data.map == hVar.MuChaoZhiZhanMap) then --母巢之战，获得wave/totalWave经验值
			local expBasic = math.floor((mapInfo.exp or 0) * mapInfo.wave / mapInfo.totalWave)
			expAdd = expBasic
		elseif (world.data.map == hVar.DuoBaoQiBingMap) then --夺宝奇兵，获得1/4经验值
			local expBasic = math.floor((mapInfo.exp or 0) * mapInfo.wave / 4)
			expAdd = expBasic
		end
	end
	
	--当前在使用的战车id
	local tankIdx = LuaGetHeroTankIdx()
	local tankId = hVar.tab_unit[hVar.MY_TANK_ID].tank_unit[tankIdx]
	
	_childUI["labelGold"] = hUI.label:new({
		parent = _parent,
		x = nGameDescribeX + 10,
		y = nGameDescribeY + imgStartY + imgDeltaY * imgIndex - 4,
		font = "num",
		border = 0,
		width = 550,
		align = "LC",
		size = 26,
		--text = goldAdd,
		text = "", --expAdd, --一开始不显示经验（上传服务器等服务器处理vip额外加成经验）
	})
	
	--奖励的父控件
	_childUI["btnReward"] = hUI.button:new({
		parent = _parent,
		model = -1,
		x = nGameDescribeX,
		y = nGameDescribeY - 430,
		w = 1,
		h = 1,
	})
	
	--增加英雄经验和积分
	if (nIsWin == 1) then
		--[[
		--修改添加积分的同时加上来源以便统计
		LuaAddPlayerScoreByWay(goldAdd,hVar.GET_SCORE_WAY.CLEARSTAGE)
		print("LuaAddPlayerScore", goldAdd)
		]]
		--加经验值
		if (expAdd > 0) then
			--SendCmdFunc["tank_talentpoint_addexp"](tankId, expAdd)
			print("GameEnd AddExp:", expAdd)
		end
		
		--加积分
		hApi.addTimerOnce("AddGameOverGold",500,function()
			--LuaAddPlayerScore(goldAdd)
			--print("LuaAddPlayerScore", goldAdd)
			hGlobal.event:event("LocalEvent_RefreshCurGameScore")
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		end)
		
		--加英雄经验
		local oPlayerMe = world:GetPlayerMe()
		local heros = oPlayerMe.heros
		local oUnit
		if heros then
			for i = 1, #heros, 1 do
				local oHero = heros[i]
				local typeId = oHero.data.id
				--获取当前数据  之后判断是否显示升级
				local tHeroCard = hApi.GetHeroCardById(typeId)
				if tHeroCard then
					if i == 1 then
						oUnit = oHero:getunit()
					end
					--local heroLv = tHeroCard.attr.level or 1
					--local heroExp = tHeroCard.attr.exp - hVar.HERO_EXP[heroLv].minExp
					--local heroExpMax = hVar.HERO_EXP[heroLv].nextExp or 0
					--local currentStar = tHeroCard and tHeroCard.attr.star or 1
					--local heroMaxLv = hVar.HERO_STAR_INFO[typeId][currentStar]["maxLv"]
					----如果可以升级
					--if heroExp + expAdd >= heroExpMax and heroLv < heroMaxLv then
						--tShowUpgradeList[#tShowUpgradeList + 1] = {typeId,expAdd,heroLv,heroExp}
					--end
				end
				--LuaAddHeroExp(typeId, expAdd)
				--print("LuaAddHeroExp", typeId, expAdd)
			end
		end
		
		--保存随机地图信息
		local diablodata = hGlobal.LocalPlayer.data.diablodata
		if diablodata and type(diablodata.randMap) == "table" then
			local tInfo = LuaGetPlayerRandMapInfo(g_curPlayerName)
			local nRandId = tInfo.id or 1
			local nStage = tInfo.stage or 1
			local nClearStage = nStage
			local nLittleBoss = tInfo.bossid_l
			local nCKScore = tInfo.ckscore or 0
			--local nRollingCount = tInfo.rollingcount or 0 --本关碾压数量
			local nOnePassStage = tInfo.onepass_stage or 0
			--保存当前关的数据
			local tInfo = LuaGetPlayerRandMapInfo(g_curPlayerName)
			if tInfo.stageInfo == nil then
				tInfo.stageInfo = {}
			end
			if tInfo.stageInfo[nStage] == nil then
				tInfo.stageInfo[nStage] = {}
			end
			tInfo.stageInfo[nStage]["mapname"] = world.data.map	--记录随机地图名字
			tInfo.stageInfo[nStage]["gametime"] = gametime		--保存游戏时间
			tInfo.stageInfo[nStage]["littleboss"] = nLittleBoss	--小bossid
			tInfo.stageInfo[nStage]["ckscore"] = nCKScore		--连斩总积分
			--tInfo.stageInfo[nStage]["rollingcount"] = nRollingCount	--本关碾压数量
			LuaSavePlayerList()
			
			print("ccccccccccccccccccccccccccccccc",diablodata.lifecount)
			--保存一名闯关数
			if diablodata.lifecount > 0 then
				nOnePassStage = nStage
				--获取最佳数据
				LuaUpdateRandMapSingleBestRecord("onepass_stage",nStage)
			end
			
			--保存下一关的数据
			local mapName = ""
			local nWeaponlevel = 1
			if oUnit then
				nWeaponlevel = oUnit.data.bind_weapon.attr.attack[6] or nWeaponlevel
			end
			nStage = nStage + 1
			local tRandMap = hVar.tab_randmap[nRandId][nStage]
			if tRandMap and type(tRandMap.randmap) == "table" then
				local r = math.random(1,#tRandMap.randmap)
				mapName = tRandMap.randmap[r]
				local talentskill = {}
				if type(diablodata.randMap.talentskill) == "table" then
					talentskill = hApi.ReadParamWithDepth(diablodata.randMap.talentskill,nil,{},3)
				end
				--存储信息
				local tInfos = {
					{"stage",nStage},
					{"clearstage",nClearStage},
					{"mapname",mapName},
					{"weaponlevel",nWeaponlevel},
					{"rescuedcount",world.data.statistics_rescue_num},
					{"rescuedcostcount",world.data.statistics_rescue_costnum},
					{"talentpoint",diablodata.randMap.talentpoint or 0},
					{"talentskill",talentskill},
					{"bossid_l",0},
					{"ckscore",0},
					--{"rollingcount",0}, --本关碾压数量
					{"onepass_stage",nOnePassStage}
				}
				--table_print(tInfos)
				LuaSetPlayerRandMapInfos(g_curPlayerName,tInfos)
			else

				local tInfos = {
					{"stage",nStage},
					{"weaponlevel",nWeaponlevel},
					{"rescuedcount",world.data.statistics_rescue_num},
					{"rescuedcostcount",world.data.statistics_rescue_costnum},
					{"isclear",1},
					{"onepass_stage",nOnePassStage}
				}
				LuaSetPlayerRandMapInfos(g_curPlayerName,tInfos)
				--存档
				LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)

				hApi.clearTimer("ActionOne")
				--清除上一次的pvp结束界面
				if hGlobal.UI.__GameOverPanel_Diablo then
					hGlobal.UI.__GameOverPanel_Diablo:del()
					hGlobal.UI.__GameOverPanel_Diablo = nil
					--print("清除上一次的pvp结束界面")
				end
				
				--移除监听
				hGlobal.event:listen("LocalEvent_OnSendGameEndInfoRet", "__SendGameEndInfoRet", nil) --通知上传战斗结果返回
				hGlobal.event:listen("LocalEvent_OnReceiveTankMapFinishReward", "__TankMapFinishReward", nil)
				hGlobal.event:listen("LocalEvent_RequireBattleNormalRet", "__RequireBattleNormalRet_GameEnd", nil)
				hGlobal.event:listen("LocalEvent_SpinScreen","GameOverPanel_Diablo", nil)
				
				--hGlobal.event:event("LocalEvent_ShowEndingAction")
				--hGlobal.event:event("LocalEvent_ShowTotalSettlement")
				return
			end
		end
		
		--上传游戏结束数据到服务器（普通地图）（胜利）
		hApi.SendGameResultInfo(nIsWin, maxStar, expAdd)
		hGlobal.event:event("Event_GameEnd",true)
		
		--存档
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
	else
		--上传游戏结束数据到服务器（普通地图）（失败）
		--上传游戏结束数据到服务器（前哨阵地）（母巢之战）（夺宝奇兵）
		hApi.SendGameResultInfo(nIsWin, maxStar, expAdd)
		hGlobal.event:event("Event_GameEnd",false)
	end
	
	if world.data.map == hVar.GuideMap then
		local btnOky = nGameDescribeY - 500
		if hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.VERTICAL then
			btnOky = btnOky - 160
		end
		
		if (nIsWin == 1) then
			local keyList = {"map","material","log"}
			LuaSavePlayerData_Android_Upload(keyList, "通新手关")
			_childUI["btnNext"] = hUI.button:new({
				parent = _parent,
				dragbox = _childUI["dragBox"],
				model = "misc/addition/cg.png",
				label = {text = hVar.tab_string["continuegame"],size = 24,border = 1,font = hVar.FONTC,y = 4,height= 32,},
				scale = 0.74,
				--model = "misc/gameover/btn_next.png",
				--icon = "ui/hall.png",
				--iconWH = 28,
				--label = " "..hVar.tab_string["__TEXT_MainInterface"],
				--font = hVar.FONTC,
				--border = 1,
				--align = "MC",
				scaleT = 0.95,
				x = nGameDescribeX,
				y = btnOky,
				--w = 174,
				--h = 52,
				code = function(self)
					--动画未完成，不能点按钮
					if (not bIsStarShow) then
						return
					end
					--geyachao: 这里会弹框？？？暂时注释掉
					--local mapName = hGlobal.WORLD.LastWorldMap.data.map	--zhenkira
					
					--_chestPoolExitFun()
					_frame:show(0)
					
					--跳到下一关
					local data2 = hApi.ReadParamWithDepth(hGlobal.LocalPlayer.data.diablodata,nil,{},10)
					GameManager.GameStart(hVar.GameType.FOURSR, data2)
				end,
			})
		else
			_childUI["btnReplay"] = hUI.button:new({
				parent = _parent,
				dragbox = _childUI["dragBox"],
				model = "misc/addition/cg.png",
				label = {text = hVar.tab_string["__TEXT_ResetLevel"],size = 24,border = 1,font = hVar.FONTC,y = 4,height= 32,},
				scale = 0.74,
				scaleT = 0.95,
				x = nGameDescribeX,
				y = btnOky,
				--w = 174,
				--h = 52,
				code = function(self)
					--动画未完成，不能点按钮
					if (not bIsStarShow) then
						return
					end
					--geyachao: 这里会弹框？？？暂时注释掉
					--local mapName = hGlobal.WORLD.LastWorldMap.data.map	--zhenkira
					
					--_chestPoolExitFun()
					_frame:show(0)
					
					_CODE_RestartGame()
				end,
			})
		end
	else
		local btnOkx = nGameDescribeX
		if (nIsWin == 1) then --胜利
			btnOkx = nGameDescribeX - 160
		elseif (nIsWin == 0) then --失败
			if (world.data.MapMode == hVar.MAP_TD_TYPE.NORMAL) or (world.data.MapMode == hVar.MAP_TD_TYPE.DIFFICULT) then --剧情地图
				btnOkx = nGameDescribeX - 160
			end
		end
		
		local btnOky = nGameDescribeY - 500
		if hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.VERTICAL then
			btnOky = btnOky - 160
		end
		--【按钮】--------------------------------------------------------------------
		--“离开游戏”按钮
		_childUI["btnOk"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			--model = "misc/gameover/btn_leave.png",
			model = "misc/addition/cg.png",
			label = {text = hVar.tab_string["leave"],size = 24,border = 1,font = hVar.FONTC,y = 4,width = 200,height= 26,},
			scale = 0.74,
			--icon = "ui/hall.png",
			--iconWH = 28,
			--label = " "..hVar.tab_string["__TEXT_MainInterface"],
			--font = hVar.FONTC,
			--border = 1,
			--align = "MC",
			scaleT = 0.95,
			--x = nGameDescribeX - 160,
			x = btnOkx,
			y = btnOky,
			--w = 174,
			--h = 52,
			code = function(self)
				--动画未完成，不能点按钮
				if (not bIsStarShow) then
					return
				end
				--geyachao: 这里会弹框？？？暂时注释掉
				--local mapName = hGlobal.WORLD.LastWorldMap.data.map	--zhenkira
				
				if hGlobal.WORLD.LastWorldMap then
					if (not hGlobal.WORLD.LastWorldMap.data.keypadEnabled) then
						hApi.SetTouchEnable_Diablo(1)
					end
				end
				
				--_chestPoolExitFun()
				_frame:show(0)
				_CODE_ExitGame()
			end,
		})
		
		--geyachao: 暂时只有返回，没有下一关按钮了
		--“下一关”按钮（成功才会有）
		if (nIsWin == 1) then
			_childUI["btnNext"] = hUI.button:new({
				parent = _parent,
				dragbox = _childUI["dragBox"],
				model = "misc/addition/cg.png",
				label = {text = hVar.tab_string["nextStage"],size = 24,border = 1,font = hVar.FONTC,y = 4,height= 32,},
				scale = 0.74,
				--model = "misc/gameover/btn_next.png",
				--icon = "ui/hall.png",
				--iconWH = 28,
				--label = " "..hVar.tab_string["__TEXT_MainInterface"],
				--font = hVar.FONTC,
				--border = 1,
				--align = "MC",
				scaleT = 0.95,
				x = nGameDescribeX + 160,
				y = btnOky,
				--w = 174,
				--h = 52,
				code = function(self)
					--动画未完成，不能点按钮
					if (not bIsStarShow) then
						return
					end
					--geyachao: 这里会弹框？？？暂时注释掉
					--local mapName = hGlobal.WORLD.LastWorldMap.data.map	--zhenkira
					
					--_chestPoolExitFun()
					--_frame:show(0)
					
					--跳到下一关
					_CODE_NextMapGame()
				end,
			})
		end
		
		--“重玩本关”按钮（成功才会有）
		if (nIsWin == 0) then
			if (world.data.MapMode == hVar.MAP_TD_TYPE.NORMAL) or (world.data.MapMode == hVar.MAP_TD_TYPE.DIFFICULT) then --剧情地图
				_childUI["btnReply"] = hUI.button:new({
					parent = _parent,
					dragbox = _childUI["dragBox"],
					model = "misc/addition/cg.png",
					label = {text = hVar.tab_string["__TEXT_ResetLevel"],size = 24,border = 1,font = hVar.FONTC,y = 4,height= 32,},
					scale = 0.74,
					--model = "misc/gameover/btn_next.png",
					--icon = "ui/hall.png",
					--iconWH = 28,
					--label = " "..hVar.tab_string["__TEXT_MainInterface"],
					--font = hVar.FONTC,
					--border = 1,
					--align = "MC",
					scaleT = 0.95,
					x = nGameDescribeX + 160,
					y = btnOky,
					--w = 174,
					--h = 52,
					code = function(self)
						--动画未完成，不能点按钮
						if (not bIsStarShow) then
							return
						end
						--geyachao: 这里会弹框？？？暂时注释掉
						--local mapName = hGlobal.WORLD.LastWorldMap.data.map	--zhenkira
						
						--_chestPoolExitFun()
						--_frame:show(0)
						
						--重玩本关
						_CODE_RestartGame()
					end,
				})
			end
		end
	end
	
	--清空随机迷宫缓存信息（防止闪退记录的第n-1小关的进度信息）
	if (world.data.map == hVar.RandomMap) then
		--游戏结束
		LuaClearRandommapInfo(g_curPlayerName)
	end
	
	--[[
	--返回按钮的图片文字
	_childUI["btnOk"].childUI["btnImg"] = hUI.image:new({
		parent = _childUI["btnOk"].handle._n,
		model = "misc/addition/menu_btn_back.png",
		x = 0,
		y = 0,
		scale = 0.9,
	})
	]]
	
	--_childUI["btnOk"]:setstate(1)
	--_childUI["btnOk"].childUI["label"].handle._n:setPosition(-35,12)
	--_childUI["btnOk"].childUI["icon"].handle._n:setPosition(-60,1)
	
	--关闭地图(大菠萝)
	_CODE_ExitGame = function()
		
		if hGlobal.UI.__GameOverPanel_Diablo then
			hGlobal.UI.__GameOverPanel_Diablo:del()
			hGlobal.UI.__GameOverPanel_Diablo = nil
		end
		--移除监听
		hGlobal.event:listen("LocalEvent_OnSendGameEndInfoRet", "__SendGameEndInfoRet", nil) --通知上传战斗结果返回
		hGlobal.event:listen("LocalEvent_OnReceiveTankMapFinishReward", "__TankMapFinishReward", nil)
		hGlobal.event:listen("LocalEvent_RequireBattleNormalRet", "__RequireBattleNormalRet_GameEnd", nil)
		hGlobal.event:listen("LocalEvent_SpinScreen","GameOverPanel_Diablo", nil)
		
		--删除pvp资源
		xlReleaseResourceFromPList("data/image/misc/pvp.plist")
		
		local diablodata = hGlobal.LocalPlayer.data.diablodata
		if diablodata and type(diablodata.randMap) == "table" then
			local tInfos = {
				{"lifecount",0},
			}
			LuaSetPlayerRandMapInfos(g_curPlayerName,tInfos)
			hGlobal.event:event("LocalEvent_ShowTotalSettlement",1)
			return
		end
		
		hUI.Disable(0, "离开游戏")
		
		if hGlobal.WORLD.LastWorldMap then
			local w = hGlobal.WORLD.LastWorldMap
			local currentMapMode = w.data.tdMapInfo and (w.data.tdMapInfo.mapMode)
			local map = w.data.map
			
			hGlobal.WORLD.LastWorldMap:del()
			hGlobal.WORLD.LastWorldMap = nil
			hGlobal.LocalPlayer:setfocusworld(nil)
			hApi.clearCurrentWorldScene()
			
			GameManager.GameStart(hVar.GameType.MAINBASS)
		end
	end
	
	--重玩本关(大菠萝)
	_CODE_RestartGame = function()
		--[[
		if hGlobal.UI.__GameOverPanel_Diablo then
			hGlobal.UI.__GameOverPanel_Diablo:del()
			hGlobal.UI.__GameOverPanel_Diablo = nil
		end
		--移除监听
		hGlobal.event:listen("LocalEvent_OnSendGameEndInfoRet", "__SendGameEndInfoRet", nil) --通知上传战斗结果返回
		hGlobal.event:listen("LocalEvent_OnReceiveTankMapFinishReward", "__TankMapFinishReward", nil)
		hGlobal.event:listen("LocalEvent_RequireBattleNormalRet", "__RequireBattleNormalRet_GameEnd", nil)
		hGlobal.event:listen("LocalEvent_SpinScreen","GameOverPanel_Diablo", nil)
		]]
		
		local world = hGlobal.WORLD.LastWorldMap
		if world and (world.ID > 0) then
			local currentmap = world.data.map
			local MapDifficulty = world.data.MapDifficulty --和当前地图难度一致
			local MapMode = world.data.MapMode --和当前地图模式一致
			
			--检测gameserver版本号是否为最新
			if (not hApi.CheckGameServerVersionControl()) then
				return
			end
			
			--挡操作
			hUI.NetDisable(30000)
			
			--发送指令，重玩本关（普通剧情地图）
			SendCmdFunc["require_battle_normal"](currentmap, MapDifficulty)
		end
	end
	
	--跳到下一关(大菠萝)
	_CODE_NextMapGame = function()
		--[[
		if hGlobal.UI.__GameOverPanel_Diablo then
			hGlobal.UI.__GameOverPanel_Diablo:del()
			hGlobal.UI.__GameOverPanel_Diablo = nil
		end
		hGlobal.event:listen("LocalEvent_SpinScreen","GameOverPanel_Diablo",nil)
		]]
		
		--检测下一章地图
		local world = hGlobal.WORLD.LastWorldMap
		if world and (world.ID > 0) then
			local diablodata = hGlobal.LocalPlayer.data.diablodata
			if diablodata and type(diablodata.randMap) == "table" then
				--world:del()
				--world = nil
				
				--关闭本界面
				if hGlobal.UI.__GameOverPanel_Diablo then
					hGlobal.UI.__GameOverPanel_Diablo:del()
					hGlobal.UI.__GameOverPanel_Diablo = nil
				end
				--移除监听
				hGlobal.event:listen("LocalEvent_OnSendGameEndInfoRet", "__SendGameEndInfoRet", nil) --通知上传战斗结果返回
				hGlobal.event:listen("LocalEvent_OnReceiveTankMapFinishReward", "__TankMapFinishReward", nil)
				hGlobal.event:listen("LocalEvent_RequireBattleNormalRet", "__RequireBattleNormalRet_GameEnd", nil)
				hGlobal.event:listen("LocalEvent_SpinScreen","GameOverPanel_Diablo", nil)
				
				hGlobal.event:event("LocalEvent_EnterRandMap")
			else
				--跳转到下一个地图
				local currentmap = world.data.map
				local tabM = hVar.MAP_INFO[currentmap]
				
				--下一个地图是否存在
				if (tabM == nil) then
					--调试错误信息
					local strText = string.format(hVar.tab_string["__TEXT_MAP_NOTEXIST"], tostring(currentmap)) --"地图 " .. "\"" .. tostring(currentmap) .. "\" " .. " 未定义！"
					hGlobal.UI.MsgBox(strText, {
						font = hVar.FONTC,
						ok = function()
							--self:setstate(1)
						end,
					})
					
					return
				end
				
				local nextmap = tabM.nextmap and tabM.nextmap[1] --下一张图
				
				--下一个地图是否有效
				if (nextmap == nil) or (nextmap == currentmap) then
					--调试错误信息
					local strText = hVar.tab_string["__TEXT_MAP_LASTMAP"] --"危机四伏，新战役即将展开"
					hGlobal.UI.MsgBox(strText, {
						font = hVar.FONTC,
						ok = function()
							--self:setstate(1)
						end,
					})
					
					return
				end
				
				--通过验证，进入下一关
				--hGlobal.event:event("LocalEvent_NextDayBreathe", 0)
				--_frame:show(0)
				--print("游戏结束后点下一关2")
				
				--geyachao: 游戏结束点重玩，直接重玩，不需要提示了
				--_chestPoolExitFun()
				
				local world = hGlobal.WORLD.LastWorldMap
				if world and (world.ID > 0) then
					local mapname = nextmap
					local MapDifficulty = world.data.MapDifficulty --和当前地图难度一致
					local MapMode = world.data.MapMode --和当前地图模式一致
					
					--检测gameserver版本号是否为最新
					if (not hApi.CheckGameServerVersionControl()) then
						return
					end
					
					--挡操作
					hUI.NetDisable(30000)
					
					--发送指令，挑战下一关（普通剧情地图）
					SendCmdFunc["require_battle_normal"](mapname, MapDifficulty)
				end
			end
		end
	end
	
	--添加事件监听：通知上传战斗结果返回
	hGlobal.event:listen("LocalEvent_OnSendGameEndInfoRet", "__SendGameEndInfoRet", function(result, tankId, mapName, nExpAdd, nScientistNum, nTankDeadthNum)
		if (result == 1) then
			--经验值控件
			if _childUI["labelGold"] then
				_childUI["labelGold"]:setText(nExpAdd)
			end
			
			--营救科学家控件
			if _childUI["labelManNum"] then
				_childUI["labelManNum"]:setText(nScientistNum)
			end
		end
	end)
	
	--添加事件监听：收到玩家地图结束奖励返回结果
	hGlobal.event:listen("LocalEvent_OnReceiveTankMapFinishReward", "__TankMapFinishReward", function(rewardN, reward)
		if (nIsWin == 1) then
			if (rewardN > 0) then
				--依次绘制奖励
				local show_count = math.min(rewardN, 8)
				local rest_count = rewardN > 8 and rewardN - 8 or 0

				local spacing_x = 84
				local w = 51
				local h = 54
				local total_width = spacing_x * (show_count - 1)
				local center_x = total_width / 2
				local offset_x = center_x

				-- 依次绘制奖励
				for i = 1, show_count, 1 do
					local rewardT = reward[i]
					local rewardType = rewardT[1] -- 奖励的类型
					-- print(rewardT[1], rewardT[2], rewardT[3], rewardT[4])
					local scale = 1.6
					local tmpModel, itemName, itemNum, itemWidth, itemHeight, sub_tmpModel, sub_pos_x, sub_pos_y, sub_pos_w,
						sub_pos_h = hApi.GetRewardParams(rewardT)

					-- 活动
					-- 奖励物品的图标按钮（只用于响应事件，不显示）

					_childUI["btnReward"].childUI["rewardIcon" .. i] = hUI.button:new({
						parent = _childUI["btnReward"].handle._n,
						model = "misc/mask.png",
						x = (i - 1) * spacing_x - offset_x,
						y = 0 + 3,
						w = w,
						h = h,
						scaleT = 0.95,
						dragbox = _childUI["dragBox"],
						code = function()
							-- 显示各种类型的奖励的tip
							hApi.ShowRewardTip(rewardT)
						end
					})
					_childUI["btnReward"].childUI["rewardIcon" .. i].handle.s:setOpacity(0) -- 默认不显示（只用于响应事件，不显示）

					-- 物品图标
					_childUI["btnReward"].childUI["rewardIcon" .. i].childUI["icon"] = hUI.image:new({
						parent = _childUI["btnReward"].childUI["rewardIcon" .. i].handle._n,
						model = tmpModel,
						x = 0,
						y = 0,
						w = itemWidth * scale,
						h = itemHeight * scale
					})

					-- 绘制奖励图标的子控件
					-- if sub_tmpModel then
					--     _childUI["btnReward"].childUI["rewardIcon" .. i].childUI["subIcon"] = hUI.image:new({
					--         parent = _childUI["btnReward"].childUI["rewardIcon" .. i].handle._n,
					--         model = sub_tmpModel,
					--         x = sub_pos_x * scale,
					--         y = sub_pos_y * scale,
					--         w = sub_pos_w * scale,
					--         h = sub_pos_h * scale
					--     })
					-- end

					-- 绘制奖励的数量
					local strRewardNum = tostring(itemNum) -- "+" .. itemNum

					-- 如果是装备，不显示加的数量文字了
					if (rewardType == 10) then
						strRewardNum = ""
					end

					--[[
							--测试 --test
							strRewardNum = "+0000"
							]]

					local rewardNumLength = #strRewardNum
					local rewardNumFont = "numWhite" -- 字体
					local rewardNumFontSize = 24 -- 字体大小
					local rewardNumBorder = 1 -- 是否显示边框
					_childUI["btnReward"].childUI["rewardIcon" .. i].childUI["num"] = hUI.label:new({
						parent = _childUI["btnReward"].childUI["rewardIcon" .. i].handle._n,
						size = rewardNumFontSize,
						x = 0,
						y = -12,
						width = 500,
						align = "MC",
						font = rewardNumFont,
						text = strRewardNum,
						border = rewardNumBorder
					})
				end
				-- print("rest_count : " .. rest_count)
				if rest_count > 0 then
					_childUI["btnReward"].childUI["lblMore"] = hUI.label:new({
						parent = _childUI["btnReward"].handle._n,
						size = 24,
						x = total_width / 2 + spacing_x,
						y = 10,
						align = "MC",
						font = "numWhite",
						text = "...",
						border = 1
					})
				end
			else
				--已领取全部奖励
				_childUI["btnReward"].childUI["rewardLabel"] = hUI.label:new({
					parent = _childUI["btnReward"].handle._n,
					size = 26,
					x = 0,
					y = 0,
					width = 500,
					align = "MC",
					font = hVar.FONTC,
					text = hVar.tab_string["__TEXT_REWARD_TAKE_ALL"], --"已领取全部奖励"
					border = 1,
				})
			end
		end
	end)
	
	--添加事件监听：收到请求挑战普通剧情地图结果返回
	hGlobal.event:listen("LocalEvent_RequireBattleNormalRet", "__RequireBattleNormalRet_GameEnd", function(result, pvpcoin, mapName, mapDiff, battlecfg_id)
		--操作成功
		if (result == 1) then
			local world = hGlobal.WORLD.LastWorldMap
			local mapname = mapName
			local MapDifficulty = mapDiff
			local MapMode = world.data.MapMode --和当前地图模式一致
			
			local chapterId = hVar.MAP_INFO[world.data.map].chapter or 1
			local nextChapterId = hVar.MAP_INFO[mapName].chapter or 1
			
			--跳转的是同一章（是不是同一章都可以了）
			--if (chapterId == nextChapterId) then
				--记录本局还未使用的道具技能
				local activeskill = {}
				local me = world:GetPlayerMe()
				local oHero = me.heros[1]
				--local typeId = oHero.data.id --英雄类型id
				local itemSkillT = oHero.data.itemSkillT
				if (itemSkillT) then
					for k = hVar.TANKSKILL_EMPTY + 1, #itemSkillT, 1 do
						local activeItemId = itemSkillT[k].activeItemId --主动技能的CD
						local activeItemLv = itemSkillT[k].activeItemLv --主动技能的等级
						local activeItemNum = itemSkillT[k].activeItemNum --主动技能的使用次数
						local activeItemCD = itemSkillT[k].activeItemCD --主动技能的CD
						local activeItemLastCastTime = itemSkillT[k].activeItemLastCastTime --主动技能的上次释放的时间（单位:秒）
						
						--不是造塔类战术卡
						local isBuildTower = 0
						local tabI = hVar.tab_item[activeItemId]
						if tabI then
							if tabI.activeSkill then
								isBuildTower = tabI.activeSkill.isBuildTower or 0
							end
						end
						--不是造塔类战术卡
						if (isBuildTower ~= 1) then
							--存储
							activeskill[#activeskill+1] = {id = activeItemId, lv = activeItemLv, num = activeItemNum,}
						end
					end
				end
				
				--记录本局武器等级
				local basic_weapon_level = 1
				local oUnit = oHero:getunit()
				if oUnit then
					if (oUnit.data.bind_weapon ~= 0) then
						basic_weapon_level = oUnit.data.bind_weapon.attr.attack[6]
					end
				end
				--print("（非随机地图） basic_weapon_level=", basic_weapon_level)
				
				--记录本局还存在的宠物
				local follow_pet_units = {}
				
				--geyachao: 普通地图，宠物不需要记录。下一关会自动携带出战的宠物
				--[[
				--geyachao: 大菠萝瓦力传送
				local rpgunits = world.data.rpgunits
				for u, u_worldC in pairs(rpgunits) do
					for _, walle_id in ipairs(hVar.MY_TANK_FOLLOW_ID) do
						if (u.data.id == walle_id) then
							follow_pet_units[#follow_pet_units+1] = {id = u.data.id, lv = u.attr.lv, star = u.attr.star,}
						end
					end
				end
				]]
				
				--记录本局营救科学家的数据
				local statistics_rescue_count = 0 --world.data.statistics_rescue_count --大菠萝营救的科学家数量(随机关单局数据)
				local statistics_rescue_num = 0 --world.data.statistics_rescue_num --大菠萝营救的科学家数量(随机关累加数据)
				local statistics_rescue_costnum = 0 --world.data.statistics_rescue_costnum --大菠萝营救的科学家消耗数量
				local weapon_attack_state = world.data.weapon_attack_state --自动开枪标记
				
				--大菠萝数据初始化
				--geyachao: 进入下一关，复用上一局的大菠萝数据（战役图）
				--hGlobal.LocalPlayer.data.diablodata = LuaInitDiabloData()
				hGlobal.LocalPlayer.data.diablodata.activeskill = activeskill --坦克的上一局主动技能
				hGlobal.LocalPlayer.data.diablodata.basic_weapon_level = basic_weapon_level --坦克的上一局的武器等级
				hGlobal.LocalPlayer.data.diablodata.follow_pet_units = follow_pet_units --坦克的上一局的宠物
				hGlobal.LocalPlayer.data.diablodata.statistics_rescue_count = statistics_rescue_count --营救的科学家数量(随机关单局数据)
				hGlobal.LocalPlayer.data.diablodata.statistics_rescue_num = statistics_rescue_num --营救的科学家数量(随机关累加数据)
				hGlobal.LocalPlayer.data.diablodata.statistics_rescue_costnum = statistics_rescue_costnum --营救的科学家消耗数量
				hGlobal.LocalPlayer.data.diablodata.statistics_crystal_num = me:getresource(hVar.RESOURCE_TYPE.GOLD) --水晶数量
				--命恢复满
				hGlobal.LocalPlayer.data.diablodata.lifecount = hVar.DEFAULT_LIFT_NUM
				hGlobal.LocalPlayer.data.diablodata.deathcount = 0
				hGlobal.LocalPlayer.data.diablodata.canbuylife = hVar.CAN_BUY_LIFE_NUM
				--自动开枪标记
				hGlobal.LocalPlayer.data.diablodata.weapon_attack_state = weapon_attack_state
				--战术卡信息
				hGlobal.LocalPlayer.data.diablodata.tTacticInfo = nil
				--宝箱信息
				hGlobal.LocalPlayer.data.diablodata.tChestInfo = nil
				--战车生命百分比
				hGlobal.LocalPlayer.data.diablodata.hpRate = nil
				--随机迷宫层数和小关数
				hGlobal.LocalPlayer.data.diablodata.randommapStage = nil
				hGlobal.LocalPlayer.data.diablodata.randommapIdx = nil
				
				--清空
				GameManager.SetGameInfo("tacticInfo","clear")
				GameManager.SetGameInfo("chestInfo","clear")
				GameManager.SetGameInfo("ckscore","clear")
				world.data.statistics_rescue_count = 0
				world.data.statistics_rescue_num = 0
				world.data.statistics_rescue_costnum = 0
			--end
			
			--删除world
			world:del()
			world = nil
			
			--关闭本界面
			if hGlobal.UI.__GameOverPanel_Diablo then
				hGlobal.UI.__GameOverPanel_Diablo:del()
				hGlobal.UI.__GameOverPanel_Diablo = nil
			end
			--移除监听
			hGlobal.event:listen("LocalEvent_OnSendGameEndInfoRet", "__SendGameEndInfoRet", nil) --通知上传战斗结果返回
			hGlobal.event:listen("LocalEvent_OnReceiveTankMapFinishReward", "__TankMapFinishReward", nil)
			hGlobal.event:listen("LocalEvent_RequireBattleNormalRet", "__RequireBattleNormalRet_GameEnd", nil)
			hGlobal.event:listen("LocalEvent_SpinScreen","GameOverPanel_Diablo", nil)
			
			--切换前，先更新仓库战车的坐标（切新章节，需要更换单位）
			local tabChapter = hVar.tab_chapter[nextChapterId] or {}
			local mapX = tabChapter.mapX --摆放物件在地图上的坐标X
			local mapY = tabChapter.mapY --摆放物件在地图上的坐标Y
			local mapFacing = tabChapter.mapFacing or 0 --摆放物件在地图上的面向角度
			if mapX and mapY then
				hGlobal.LocalPlayer.data.mainbasePosX = mapX
				hGlobal.LocalPlayer.data.mainbasePosY = mapY
				hGlobal.LocalPlayer.data.mainbaseFacing = mapFacing
			end
			
			--切换地图
			local banLimitTable = {battlecfg_id = battlecfg_id,}
			
			--如果加载的是挑战模式，并且挑战模式指定了其他地图，那么加载指定地图
			local tomap = mapname
			if (MapMode == hVar.MAP_TD_TYPE.DIFFICULT) then
				local tMap = hVar.MAP_INFO[mapname] or {}
				local DiffMode = tMap.DiffMode or {}
				local diffMapName = DiffMode[mapDiff].diffMapName
				if (diffMapName ~= nil) then
					tomap = diffMapName
					banLimitTable.mapName = mapname
				end
			end
			xlScene_LoadMap(g_world, tomap, MapDifficulty, MapMode,nil,banLimitTable)
		end
	end)
	
	--横竖屏切换事件
	hGlobal.event:listen("LocalEvent_SpinScreen","GameOverPanel_Diablo",function()
		local _frm = hGlobal.UI.__GameOverPanel_Diablo
		if _frm and _frm.data.show == 1 then
			hGlobal.event:event("LocalEvent_GameOver_Diablo",nIsWin)
		end
	end)
	
end)
--[[
--测试 --test
hGlobal.event:event("LocalEvent_GameOver_Diablo", 1)
]]


----------------------------------
---- 加载资源交换
----------------------------------
--hGlobal.UI.InitChangeResourcesFrame = function()
--	local _bar
--	local barLength = 360--拖动条长度
--	local nowNum,maxNum = 0,0--当前换个数/最大换个数
--	local ratioMy,ratioNeed = 0,0--交换资源系数
--	local my_chose,need_chose = 0,0--我交换的东西,我要换的东西
--	local gold,food,stone,wood,iron,jewel = 1,2,3,4,5,6
--	local mV,nV = 0,0--我资源的价值，要换的资源的价值
--	local left,right = 0,0--兑换显示的左右的数字
--	local Res = {}--己方资源数量
--	local groupList = {} --保存资源定义，在关闭界面时，删除以节省空间
--	local creatResourceSwop = nil	--定义交换时的资源
--	local creatResource = nil	--定义“我的资源”，“可兑换资源”
--	local res_Kind = {
--		hVar.RESOURCE_TYPE.GOLD,
--		hVar.RESOURCE_TYPE.FOOD,
--		hVar.RESOURCE_TYPE.STONE,
--		hVar.RESOURCE_TYPE.WOOD,
--		hVar.RESOURCE_TYPE.LIFE,
--		hVar.RESOURCE_TYPE.CRYSTAL,
--	}
--	local _frm,_childUI
--	
--	local _resName = {"Gold","Food","Stone","Wood","Iron","Jewel"}
--	local _resShowName = hVar.tab_stringM["MARKET_res_show_name"]
--	local _resTag = {"GOLD","FOOD","STONE","WOOD","IRON","CYSTAL"}
--	local _tDiscount = {}
--	local _FUNC_UpdateDiscount = function()
--		_tDiscount = {}
--		local oWorld = hGlobal.WORLD.LastWorldMap
--		if oWorld==nil then
--			return
--		end
--		local tTactics = oWorld:gettactics(hGlobal.LocalPlayer.data.playerId)
--		if tTactics==nil then
--			return
--		end
--		for n = 1,#tTactics do
--			if tTactics[n]~=0 then
--				local id,lv = tTactics[n][1],tTactics[n][2]
--				local tabT = hVar.tab_tactics[id]
--				if tabT and tabT.marketdiscount then
--					local nLv = math.min(tabT.level or 1,lv)
--					local tDiscount = tabT.marketdiscount
--					for i = 1,#tDiscount[nLv] do
--						local k = tDiscount[nLv][i][1].."->"..tDiscount[nLv][i][2]
--						local v = tDiscount[nLv][i][3]
--						if v>(_tDiscount[k] or 0) then
--							_tDiscount[k] = v
--						end
--					end
--				end
--			end
--		end
--	end
--	--每天刷新市场折扣(多主城折扣改变这个以后再说)
--	--hGlobal.event:listen("Event_NewDay","__MARKET__RefreshDiscount__",function(nDayCount)
--		--return _FUNC_UpdateDiscount()
--	--end)
--	--强制刷新市场折扣
--	--hGlobal.event:listen("LocalEvent_ReloadTacticsCard","__MARKET__RefreshDiscount__",function(IsActiveOpr)
--		--return _FUNC_UpdateDiscount()
--	--end)
--	--游戏开始时刷新市场折扣
--	hGlobal.event:listen("Event_WorldCreated","__MARKET__RefreshDiscount__",function(oWorld,IsCreatedFromLoad)
--		if oWorld.data.type=="worldmap" then
--			_FUNC_UpdateDiscount()
--		end
--	end)
--	local getExchangeVal = function(from,to)
--		local v = hVar.RESOURCE_CHANGE_VALUE[from][to]
--		local c = _tDiscount[_resTag[from].."->".._resTag[to]]
--		if c and c>0 then
--			v = v*math.max(1,(100-c))/100
--		end
--		return v
--	end
--	local float2string = function(num)
--		if hApi.floor(num)~=num then
--			return string.format("%.2f",num)
--		else
--			return tostring(num)
--		end
--	end
--	local showExchangeNum = function(num)
--		_childUI["Lab_my_cost"]:setText(tostring(math.abs(hApi.ceil(num*ratioMy))))
--		_childUI["Lab_need_cost"]:setText(tostring(math.abs(hApi.floor(num*ratioNeed))))
--
--		--设置白色，标示交换的数据
--		_childUI["Lab_my_cost"].handle.s:setColor(ccc3(255,255,255))
--		_childUI["Lab_need_cost"].handle.s:setColor(ccc3(255,255,255))
--	end
--	local ExchangeConfirm = function()
--		--坑爹的交换资源，目前是直接走本地的
--		local offerNum = hApi.ceil(nowNum*ratioMy)
--		local toNum = hApi.floor(nowNum*ratioNeed)
--		hGlobal.LocalPlayer:addresource(res_Kind[my_chose],-1*offerNum)
--		hGlobal.LocalPlayer:addresource(res_Kind[need_chose],toNum)
--		
--
--		--加入玩家行为
--		local oWorld = hGlobal.WORLD.LastWorldMap
--		if oWorld and hVar.PlayerBehaviorList[oWorld.data.map] then
--			--桃园结义
--			if oWorld.data.map == "world/level_tyjy" then
--				LuaAddBehaviorID(100000013)
--			end
--		end
--		return res_Kind[my_chose],offerNum,res_Kind[need_chose],toNum
--	end
--	local getRatioNum = function(i)				--返回两种资源的兑换比例
--		local c = hVar.RESOURCE_VALUE.DISCOUNT		--兑换资源折扣
--		local changeValue = getExchangeVal(my_chose,i)
--		if changeValue == 0 then
--			mV = 0
--			nV = 0
--			return ""
--		end
--		if changeValue <= 1 then
--			return float2string(1/changeValue)
--		end
--		if changeValue > 1 then
--			return "1/"..float2string(changeValue)
--		end
--	end
--	local showRatioInfo = function(m,n)--返回具体交换信息
--		local changeValue2 = getExchangeVal(m,n)
--		local small
--		if changeValue2 <= 1 then
--			mV = 1
--			nV = 1/changeValue2
--			small = math.max(mV,nV)
--			ratioMy = nV/small
--			ratioNeed = mV*small
--		end
--		if changeValue2 > 1 then
--			mV = 1/changeValue2
--			nV = 1
--			small = math.min(mV,nV)
--			ratioMy = nV/small
--			ratioNeed = mV/small
--		end
--		
--		local showStr = ""
--		left = float2string(ratioMy)
--		right = float2string(ratioNeed)
--		--return left.._resShowName[m]..hVar.tab_string["MARKET_change"]..right.._resShowName[n]	--changed by pangyong 2015/7/28
--	end
--
--	---------------------------------------------
--	--在画面中间显示资源之间的兑换数据关系
--	---------------------------------------------
--	local showRatioNum = function(nMyChose, nNeedChose)
--		local sRationNum = getRatioNum(nNeedChose)
--		if sRationNum and sRationNum ~= "" then
--			if string.find(sRationNum, "/") then
--				local _,_,sMyNum = string.find(sRationNum, "(%d+)".."/")
--				local _,_,sNeedNum = string.find(sRationNum, "/".."(%d+)")
--				_childUI["Lab_my_cost"]:setText(sNeedNum)
--				_childUI["Lab_need_cost"]:setText(sMyNum)
--			else
--				_childUI["Lab_my_cost"]:setText("1")
--				_childUI["Lab_need_cost"]:setText(sRationNum)
--			end
--			_childUI["Lab_my_cost"].handle.s:setColor(ccc3(255,0,0))	--设置红色，标示比率
--			_childUI["Lab_need_cost"].handle.s:setColor(ccc3(255,0,0))
--		end
--	end
--
--	---------------------------------------------
--	--默认设置购买一个数量
--	---------------------------------------------
--	local setbuyOneNum = function()
--		local bSuccSet = false
--		if 0 < maxNum then
--			nowNum = 1							--强制为玩家设置一个交换数量
--			_bar:setV(350/maxNum + 5,barLength)
--
--			local tempX = 350/maxNum + 5 + _bar.data.x
--			_childUI["scrollBtn"].handle._n:setPosition(tempX, _bar.data.y - 17)
--			_num:setText(tostring(nowNum.."/"..maxNum))
--			showExchangeNum(nowNum)						--更新消耗和获得的数量
--
--			bSuccSet = true
--		end
--		return bSuccSet
--	end
--	
--	local unableMyBtn = nil
--	local tyjyHide = nil		--桃园结义的特殊ui布局函数
--	local myResFun = function()	--更新并显示己方资源
--		Res[1] = hGlobal.LocalPlayer:getresource(hVar.RESOURCE_TYPE.GOLD)
--		Res[2] = hGlobal.LocalPlayer:getresource(hVar.RESOURCE_TYPE.FOOD)
--		Res[3] = hGlobal.LocalPlayer:getresource(hVar.RESOURCE_TYPE.STONE)
--		Res[4] = hGlobal.LocalPlayer:getresource(hVar.RESOURCE_TYPE.WOOD)
--		Res[5] = hGlobal.LocalPlayer:getresource(hVar.RESOURCE_TYPE.LIFE)
--		Res[6] = hGlobal.LocalPlayer:getresource(hVar.RESOURCE_TYPE.CRYSTAL)
--		
--		for i = 1,#_resName do	--刷新己方资源
--			_childUI["Lab_my_res_".._resName[i]]:setText(tostring(Res[i]))
--		end 
--	end
--	
--	--市场资源兑换界面
--	hGlobal.UI.ChangeResourcesFrame = hUI.frame:new({
--		x = hVar.SCREEN.w/2 - 326,
--		y = hVar.SCREEN.h/2 + 282,
--		w = 652,
--		h = 588,
--		show = 0,
--		closebtn = "BTN:PANEL_CLOSE",
--		closebtnX = 650,
--		closebtnY = -7,
--		dragable = 3,
--		autoactive = 0,
--		background = "UI:tip_item",
--		border	= "UI:TileFrmBasic_thin",
--		codeOnClose = function(self)
--			--删除资源定义
--			for i = 1, #groupList do
--				hApi.safeRemoveT(_childUI,groupList[i])							--删除以前的显示内容
--			end
--			groupList = {}											--清空列表
--		end
--	})
--	_frm = hGlobal.UI.ChangeResourcesFrame
--	_childUI = _frm.childUI
--
--	--资源标题
--	_childUI["Lab_My"] = hUI.label:new({--显示说明提示“我方资源”
--		parent = _frm.handle._n,
--		font = hVar.FONTC,
--		text = hVar.tab_string["MARKET_my_res"],
--		size = 28,
--		align = "MC",
--		x = _frm.data.w/2 -220,
--		y = -40,
--	})
--	
--	_childUI["Lab_Need"] = hUI.label:new({--显示说明提示“可兑换资源”
--		parent = _frm.handle._n,
--		font = hVar.FONTC,
--		text = hVar.tab_string["MARKET_need_res"],
--		size = 28,
--		align = "MC",
--		x = _frm.data.w/2 + 210,
--		y = -40,
--	})
--		
--	unableMyBtn = function(a)--禁用一组按钮中的一个
--		for i = 1,#_resName do
--			_childUI["Btn_my_res_".._resName[i]]:setstate(1)
--			_childUI["Img_my_res".._resName[i]].handle.s:setColor(ccc3(255,255,255))	--使所有可兑换资源图标恢复正常
--			_childUI["Img_my_res".._resName[i]].handle.s:setOpacity(255)			--使资源图片完全不透明（解除在“桃园结义”中的设定）
--		end
--		if a>=1 and a <=#_resName then
--			_childUI["Btn_my_res_".._resName[a]]:setstate(0)				
--			_childUI["Img_my_res".._resName[a]].handle.s:setColor(ccc3(100,100,100))	--相应的图标暗下去，使资源看起来是无效的
--		end
--	end
--	
--	local unableNeedBtn = function(a)--禁用一组按钮中的一个
--		for i = 1,#_resName do
--			_childUI["Btn_need_res_".._resName[i]]:setstate(1)
--			_childUI["Img_need_res".._resName[i]].handle.s:setColor(ccc3(255,255,255))
--			_childUI["Img_need_res".._resName[i]].handle.s:setOpacity(255)
--		end
--		if a>=1 and a <=#_resName then
--			_childUI["Btn_need_res_".._resName[a]]:setstate(0)
--			_childUI["Img_need_res".._resName[a]].handle.s:setColor(ccc3(100,100,100))
--		end
--	end
--	
--	local showMyChoiceResImg = function(a)--在画面中间部位显示选中己方资源的图片
--		for i = 1,#_resName do
--			_childUI["Img_my_res_".._resName[i]].handle.s:setVisible(false)
--		end
--		if a >= 1 and a <= #_resName then
--			_childUI["Img_my_res_".._resName[a]].handle.s:setVisible(true)
--		end
--	end
--	
--	local showNeedChoiceResImg = function(a)--在画面中间部位显示选中交换资源的图片
--		for i = 1,#_resName do
--			_childUI["Img_need_res_".._resName[i]].handle.s:setVisible(false)
--		end
--		if a >= 1 and a <= #_resName then
--			_childUI["Img_need_res_".._resName[a]].handle.s:setVisible(true)
--		end
--	end
--	
--	local getMaxNum = function(m,n)--获得当前最大可交换数量
--		local changeValue3 = getExchangeVal(m,n)--兑换比率
--		if changeValue3 <= 1 then
--			mV = 1
--			nV = 1/changeValue3
--			local small = math.max(mV,nV)
--			left = nV/small
--			right = mV*small
--		end
--		if changeValue3 > 1 then
--			mV = 1/changeValue3
--			nV = 1
--			local big = math.min(mV,nV)
--			left = nV/big
--			right = mV/big
--		end
--		
--		if Res[m] <= 0 then
--			Res[m] = 0
--		end
--		
--		if left == 1 then
--			return Res[m]				--之前如果少换多的话，把“少”的最大数设置为最大数
--		else
--			return math.floor(Res[m]/left)
--		end
--	end
--	
--	--成交购买按钮
--	_childUI["btnPlus_Confim"] = hUI.button:new({
--		parent = _frm.handle._n,
--		mode = "imageButton",
--		dragbox = _frm.childUI["dragBox"],
--		model = "UI:bargain",
--		x = _frm.data.w/2,
--		y = -_frm.data.h + 192,
--		scaleT = 0.9,
--		codeOnTouch = function(self,x,y,sus)
--			ExchangeConfirm()				--交换资源
--			nowNum = 0
--			_childUI["bar"]:setV(0,barLength)		--清空条
--			_childUI["scrollBtn"].handle._n:setPosition(_bar.data.x + 5,_bar.data.y - 17)
--			myResFun()					--更新并显示己方资源
--			maxNum = getMaxNum(my_chose,need_chose)
--			_num:setText(tostring("0".."/"..maxNum))
--			hApi.PlaySound("pay_gold")
--			if setbuyOneNum() == false then			--设置默认一个交换数量
--				showRatioNum(my_chose,need_chose)	--设置比率（红色）
--			end
--			tyjyHide()
--		end,
--	})
--	_childUI["btnPlus_Confim"]:setstate(0)--默认不可点按钮
--
--	--[拖拉条定义]
--	do
--		--拖拉条的数值条
--		_childUI["bar"] = hUI.valbar:new({
--			parent = _frm.handle._n,
--			model = "UI:ValueBar",
--			back = {model = "UI:ValueBar_Back", x=0, y=0, w=barLength, h=46},
--			w = barLength,
--			h = 46,
--			x = _frm.data.w/2 - barLength/2,
--			y = -_frm.data.h/2 - 208,
--			align = "LT",
--		})
--		_bar = _childUI["bar"]
--
--		--拖拉条下中数值条的尾部
--		_childUI["scrollBtn"] = hUI.image:new({
--			parent = _frm.handle._n,
--			model = "UI:scrollBtn",
--			w = 20,
--			h = 54,
--			x = _bar.data.x + 5,
--			y = _bar.data.y - 115,
--		})
--
--		--拖拉条上的透明按钮
--		--拖拉条的左右各有5个像素的透明边，计算时要考虑到，否则影响显示效果
--		_childUI["bar_btn"] = hUI.button:new({
--			parent = _frm.handle._n,
--			mode = "imageButton",
--			dragbox = _frm.childUI["dragBox"],
--			model = "UI:Button_MaxValue",
--			x = _frm.data.w/2,
--			y = -_frm.data.h/2 - 228,
--			w = barLength,
--			h = 46,
--			codeOnDrag = function(self,x,y,sus)
--				local dx = x - (_frm.data.w/2-barLength/2)
--				if dx <= 5 then										--点到了左透明边
--					dx = 0
--					nowNum = 0
--				elseif dx >= barLength - 5 then								--点到了右透明边
--					dx = barLength
--					nowNum = maxNum
--				else											--点到了中间位置
--					nowNum = math.ceil((dx-5)*(maxNum/350))
--				end
--				if maxNum ~= 0 then
--					_bar:setV(dx, barLength)							--设置拖拉条的数值长度		
--					
--					--设置卷轴的位置
--					local tempX = x
--					if tempX > (350 + _bar.data.x + 5) then tempX = 350 + _bar.data.x + 5 end	--防止跑到右透明区
--					if tempX < _bar.data.x + 5 then tempX = _bar.data.x + 5 end			--防止跑到左透明区
--					_childUI["scrollBtn"].handle._n:setPosition(tempX,_bar.data.y - 17)		--重新设定数值条的尾部
--				end
--				_num:setText(nowNum.."/"..maxNum)							--更新拖拽条上显示的数字
--				showExchangeNum(nowNum)									--更新消耗和获得的数量
--			end,
--			codeOnTouch = function(self,x,y,sus)
--				local dx = x - (_frm.data.w/2-barLength/2)
--				if dx <= 5 then
--					dx = 0
--					nowNum = 0
--				elseif dx >= barLength - 5 then	
--					dx = barLength
--					nowNum = maxNum
--				else
--					nowNum = math.ceil((dx-5)*(maxNum/350))
--				end
--				if maxNum ~= 0 then
--					_bar:setV(dx,barLength)	
--					
--					--设置卷轴的位置
--					local tempX = x
--					if tempX > (350 + _bar.data.x + 5) then tempX = 350 + _bar.data.x + 5 end
--					if tempX < _bar.data.x + 5 then tempX = _bar.data.x + 5 end
--					_childUI["scrollBtn"].handle._n:setPosition(tempX,_bar.data.y - 17)
--				end
--				_num:setText(nowNum.."/"..maxNum)
--				showExchangeNum(nowNum)	
--			end,
--		})
--		_childUI["bar_btn"].handle.s:setVisible(false)
--		
--		--拖拽条上显示的数字
--		_childUI["labNum"] = hUI.label:new({
--			parent = _frm.handle._n,
--			font = "numWhite",
--			size = 30,
--			text = "--",
--			align = "MC",
--			x = _bar.data.x+barLength/2,
--			y = _bar.data.y - 24,
--		})
--		_num = _childUI["labNum"]
--		
--		
--		--"-"按钮
--		_childUI["btnSubOne"] = hUI.button:new({
--			parent = _frm.handle._n,
--			mode = "imageButton",
--			dragbox = _frm.childUI["dragBox"],
--			model = "UI:subone",
--			x = _frm.data.w/2 - 216,
--			y = -_frm.data.h + 60,
--			scaleT = 0.9,
--			codeOnTouch = function(self,x,y,sus)
--				nowNum = nowNum - 1
--				if 0 > nowNum then nowNum = 0 end							--数值不能为负数
--				local dx = 0
--				if maxNum ~= 0 then
--					dx = math.floor(nowNum*(350/maxNum))						--除去左透明边的点击距离
--					if dx == 350 then								--数值最大		
--						_bar:setV(barLength,barLength)
--					elseif dx == 0 then								--数值最小
--						_bar:setV(dx,barLength)
--					else										--普通数值
--						_bar:setV(dx+5,barLength)						--设置托条时，要加上左边的透明边（5个像素）
--					end
--					local tempX = dx + _bar.data.x + 5						--卷轴的位置x
--					_childUI["scrollBtn"].handle._n:setPosition(tempX,_bar.data.y - 17)		--设置卷轴位置
--				end
--				_num:setText(nowNum.."/"..maxNum)
--				showExchangeNum(nowNum)
--			end,
--		})
--		_childUI["btnSubOne"]:setstate(0)--默认不可点按钮
--		
--		--"+"按钮
--		_childUI["btnAddOne"] = hUI.button:new({
--			parent = _frm.handle._n,
--			mode = "imageButton",
--			dragbox = _frm.childUI["dragBox"],
--			model = "UI:addone",
--			x = _frm.data.w/2 + 215,
--			y = -_frm.data.h + 60,
--			scaleT = 0.9,
--			codeOnTouch = function(self,x,y,sus)
--				nowNum = nowNum + 1
--				if maxNum < nowNum then nowNum = maxNum end						--数值不能超过最大数
--				local dx = 0
--				if maxNum ~= 0 then
--					dx = math.floor(nowNum*(350/maxNum))
--					if dx == 350 then
--						_bar:setV(barLength,barLength)
--					elseif dx == 0 then
--						_bar:setV(dx,barLength)
--					else 
--						_bar:setV(dx+5,barLength)
--					end
--					local tempX = dx + _bar.data.x + 5
--					_childUI["scrollBtn"].handle._n:setPosition(tempX,_bar.data.y - 17)		--设置卷轴位置
--				end
--				_num:setText(nowNum.."/"..maxNum)
--				showExchangeNum(nowNum)
--			end,
--		})
--		_childUI["btnAddOne"]:setstate(0)--默认不可点按钮
--	end
--
--	--------------------------------------------------------
--	--资源交换定义
--	--------------------------------------------------------
--	creatResourceSwop = function()
--		local nChangeX, nChangeY = _frm.data.w/2, - 202
--
--		--交换资源的背景
--		_childUI["Resource_background1"] = hUI.bar:new({
--			parent = _frm.handle._n,
--			model = "UI:card_select_back",
--			w = 260,
--			h = 86,
--			x = nChangeX,
--			y = nChangeY - 44,
--		})
--		groupList[#groupList+1] = "Resource_background1"
--		
--		--显示被选中的资源
--		for i = 1,#_resName do
--			_childUI["Img_my_res_".._resName[i]] = hUI.image:new({
--				parent = _frm.handle._n,
--				model = "UI:ICON_main_frm_Resource".._resName[i],
--				w = 64,
--				h = 64,
--				x = nChangeX - 85,
--				y = nChangeY - 24,
--			})
--			groupList[#groupList+1] = "Img_my_res_".._resName[i]
--			
--			_childUI["Img_need_res_".._resName[i]] = hUI.image:new({
--				parent = _frm.handle._n,
--				model = "UI:ICON_main_frm_Resource".._resName[i],
--				w = 64,
--				h = 64,
--				x = nChangeX + 85,
--				y = nChangeY - 24,
--			})
--			groupList[#groupList+1] = "Img_need_res_".._resName[i]
--		end
--		
--		--我方消耗数值
--		_childUI["Lab_my_cost"] = hUI.label:new({
--			parent = _frm.handle._n,
--			text = "",
--			size = 20,
--			align = "MC",
--			x = _frm.data.w/2 - 85 ,
--			y = -_frm.data.h + 318,
--		})
--		_childUI["Lab_my_cost"].handle.s:setVisible(false)
--		groupList[#groupList+1] = "Lab_my_cost"
--		
--		--对兑换的数量
--		_childUI["Lab_need_cost"] = hUI.label:new({
--			parent = _frm.handle._n,
--			text = "",
--			size = 20,
--			align = "MC",
--			x = _frm.data.w/2 + 85,
--			y = -_frm.data.h + 318,
--		})
--		_childUI["Lab_need_cost"].handle.s:setVisible(false)
--		groupList[#groupList+1] = "Lab_need_cost"
--		
--		--资源交换导向箭头
--		_childUI["Direction"] = hUI.image:new({
--			parent = _frm.handle._n,
--			model = "UI:direction",
--			x = nChangeX + 3,
--			y = nChangeY - 45,
--		})
--		groupList[#groupList+1] = "Direction"
--	end
--	
--	local choiceMy = nil
--	local choiceNeed = nil
--	local nResorceX, nResorceY = 86, -106
--	local nX,nY,nWidth,nHeight = 110, -72, 170, 387
--	local nSpace = 428
--	
--	--["我方资源"和"可兑换的资源"]
--	creatResource = function()
--		--资源背景边框
--		for i = 1, 2 do
--			_childUI["Resource_backgroundLT"..i] = hUI.image:new({
--				parent = _frm.handle._n,
--				animation = "LT",
--				mode  = "image",
--				model = "UI:TileFrmBasic_thin",
--				align = "LT",
--				x = nX - 105 + (i-1)*nSpace,
--				y = nY + 20,
--			})
--			groupList[#groupList+1] = "Resource_backgroundLT"..i
--			
--			_childUI["Resource_backgroundLC"..i] = hUI.image:new({
--				parent = _frm.handle._n,
--				animation = "LC",
--				mode  = "image",
--				model = "UI:TileFrmBasic_thin",
--				align = "LT",
--				w = 48,
--				h = nHeight - 72,
--				x = nX - 111 + (i-1)*nSpace,
--				y = nY - 72,
--			})
--			groupList[#groupList+1] = "Resource_backgroundLC"..i
--			
--			
--			_childUI["Resource_backgroundRT"..i] = hUI.image:new({
--				parent = _frm.handle._n,
--				animation = "RT",
--				mode  = "image",
--				model = "UI:TileFrmBasic_thin",
--				align = "LT",
--				x = nX + 1 + (i-1)*nSpace,
--				y = nY + 20,
--			})
--			groupList[#groupList+1] = "Resource_backgroundRT"..i
--			
--			_childUI["Resource_backgroundRC"..i] = hUI.image:new({
--				parent = _frm.handle._n,
--				animation = "RC",
--				mode  = "image",
--				model = "UI:TileFrmBasic_thin",
--				align = "LT",
--				w = 48,
--				h = nHeight - 72,
--				x = nX + 59 + (i-1)*nSpace,
--				y = nY - 72,
--			})
--			groupList[#groupList+1] = "Resource_backgroundRC"..i
--			
--			_childUI["Resource_backgroundMT"..i] = hUI.image:new({
--				parent = _frm.handle._n,
--				animation = "MT",
--				mode  = "image",
--				model = "UI:TileFrmBasic_thin",
--				align = "LT",
--				w = nWidth - 150,						--故意增长10，使颜色过渡更自然
--				h = 48,
--				x = nX - 9 + (i-1)*nSpace,
--				y = nY + 21,
--			})
--			groupList[#groupList+1] = "Resource_backgroundMT"..i
--		end
--		
--		--采光
--		_childUI["Img_my_floorpolish"] = hUI.image:new({
--			parent = _frm.handle._n,
--			mode  = "image",
--			model = "UI:marketfloorpolishL",
--			align = "MT",
--			x = nX + 6,
--			y = nY - 3 ,
--			z = 1,								--背景z = 0, 采光z = 1, 资源图标和数值z = 2, 透明按钮z = 3
--		})
--		_childUI["Img_my_floorpolish"].handle.s:setVisible(false)		--初始没有资源被选中，所以隐藏
--		groupList[#groupList+1] = "Img_my_floorpolish"
--
--		_childUI["Img_need_floorpolish"] = hUI.image:new({
--			parent = _frm.handle._n,
--			mode  = "image",
--			model = "UI:marketfloorpolishR",
--			align = "MT",
--			x = nX + 423,
--			y = nY - 3 ,
--			z = 1,								--背景z = 0, 采光z = 1, 资源图标和数值z = 2, 透明按钮z = 3
--		})
--		_childUI["Img_need_floorpolish"].handle.s:setVisible(false)		--初始没有资源被选中，所以隐藏
--		groupList[#groupList+1] = "Img_need_floorpolish"
--		
--		--资源定义
--		for i = 1,#_resName do
--			--“我的资源”
--			_childUI["Img_my_floor".._resName[i]] = hUI.image:new({		--地板背景
--				parent = _frm.handle._n,
--				mode  = "image",
--				model = "UI:marketfloor",
--				align = "MT",
--				x = nX + 1,
--				y = nY - 3 - (i-1)*64,
--				z = 0,
--			})
--			groupList[#groupList+1] = "Img_my_floor".._resName[i]
--			
--			_childUI["Img_my_res".._resName[i]] = hUI.image:new({		--资源图标
--				parent = _frm.handle._n,
--				mode  = "image",
--				model = "UI:ICON_main_frm_Resource".._resName[i],
--				align = "MC",
--				w = 64,
--				h = 64,
--				x = nResorceX + 50,
--				y = nResorceY - 8 - (i -1)*64,
--				z = 2,
--			})
--			groupList[#groupList+1] = "Img_my_res".._resName[i]
--			_childUI["Btn_my_res_".._resName[i]] = hUI.button:new({		--资源上的透明按钮
--				parent = _frm.handle._n,
--				mode	= "imageButton",
--				dragbox = _frm.childUI["dragBox"],
--				model = -1,
--				w = 170,
--				h = 64,
--				x = nResorceX + 24,
--				y = nResorceY - (i -1)*64,
--				z = 3,
--				align = "MC",
--				scaleT = 0.8,						--按上去后的缩放比例
--				failcall = 1,
--				codeOnTouch = function(self,x,y,sus)
--					choiceMy(i)					--设置选中后的一系列数值（这里用到了“闭合函数”）
--				end,
--			})
--			groupList[#groupList+1] = "Btn_my_res_".._resName[i]
--			_childUI["Lab_my_res_".._resName[i]] = hUI.label:new({		--资源右边的数值
--				parent = _frm.handle._n,
--				text = "0",
--				size = 20,
--				align = "LC",
--				x = nResorceX - 49,
--				y = nResorceY + 12 - (i -1)*64,
--				z = 2,
--			})
--			groupList[#groupList+1] = "Lab_my_res_".._resName[i]
--			
--			--“可兑换资源”
--			_childUI["Img_need_floor".._resName[i]] = hUI.image:new({	--地板
--				parent = _frm.handle._n,
--				animation = "MT",
--				mode  = "image",
--				model = "UI:marketfloor",
--				align = "MT",
--				x = nX + 429,
--				y = nY - 3 - (i-1)*64,
--				z = 0,
--			})
--			groupList[#groupList+1] = "Img_need_floor".._resName[i]
--			_childUI["Img_need_res".._resName[i]] = hUI.image:new({
--				parent = _frm.handle._n,
--				mode  = "image",
--				model = "UI:ICON_main_frm_Resource".._resName[i],
--				align = "MC",
--				w = 64,
--				h = 64,
--				x = nResorceX + 424,
--				y = nResorceY - 8 - (i -1)*64,
--				z = 2,
--			})
--			groupList[#groupList+1] = "Img_need_res".._resName[i]
--			_childUI["Btn_need_res_".._resName[i]] = hUI.button:new({
--				parent = _frm.handle._n,
--				mode = "imageButton",
--				dragbox = _frm.childUI["dragBox"],
--				model = -1,
--				w = 170,
--				h = 64,
--				x = nResorceX + 452,
--				y = nResorceY - (i -1)*64,
--				z = 3,
--				align = "MC",
--				scaleT = 0.8,
--				failcall = 1,
--				codeOnTouch = function(self,x,y,sus)
--					choiceNeed(i)
--				end,
--			})
--			groupList[#groupList+1] = "Btn_need_res_".._resName[i]
--		end
--		
--		--geyachao: 金币显示黄色
--		_childUI["Lab_my_res_" .. _resName[6]].handle.s:setColor(ccc3(255, 128, 0))
--	end
--	
--	--选中资源后的处理
--	choiceMy = function(i)
--		my_chose = i
--		unableNeedBtn(i)
--		_childUI["Img_my_floorpolish"].handle.s:setVisible(true)
--		_childUI["Img_my_floorpolish"].handle.s:setPosition(nX + 6, nY - 3 - (i -1)*64)
--		showMyChoiceResImg(my_chose)									--在拖拉条的左边显示选中己方资源的图片
--		
--		if(my_chose ~= 0 and need_chose ~= 0 and need_chose ~= my_chose) then				--需求和提供都有，而且不相同，可进行交换
--			
--			_childUI["btnSubOne"]:setstate(1)							--"-"按钮
--			_childUI["btnAddOne"]:setstate(1)							--"+"按钮
--			_childUI["btnPlus_Confim"]:setstate(1)							--成功购买按钮
--			showRatioInfo(my_chose,need_chose)							--设置兑换比率
--			--显示兑换比率
--			showRatioNum(my_chose, need_chose)
--			
--			maxNum = getMaxNum(my_chose,need_chose)							--获得可兑换资源的最大数量
--			--作为新手引导
--			if setbuyOneNum() == true then
--				--设置成功(为玩家设置一个默认购买数量)
--			else
--				nowNum = 0
--				_childUI["bar"]:setV(nowNum,barLength)						--清空条，设置数值条的长度（长度，最大长度）
--				_childUI["scrollBtn"].handle._n:setPosition(_bar.data.x + 5 ,_bar.data.y - 17)	--数值拖拉条的尾部
--			end
--			_childUI["bar_btn"]:setstate(1)								--设置拖拉条可拖拉
--			_num:setText(tostring(nowNum.."/"..maxNum))						--（当前可获得值，最大可获得值）
--			_childUI["Lab_my_cost"].handle.s:setVisible(true)
--			_childUI["Lab_need_cost"].handle.s:setVisible(true)
--		else
--			_childUI["btnSubOne"]:setstate(0)							--"-"按钮
--			_childUI["btnAddOne"]:setstate(0)							--"+"按钮
--			_childUI["btnPlus_Confim"]:setstate(0)
--			_num:setText("--")
--			_childUI["bar_btn"]:setstate(0)
--			_childUI["Lab_my_cost"].handle.s:setVisible(false)
--			_childUI["Lab_need_cost"].handle.s:setVisible(false)
--		end
--		tyjyHide()											--桃园结义的特殊处理
--	end
--	
--	choiceNeed = function(i)
--		need_chose = i
--		unableMyBtn(i)
--		_childUI["Img_need_floorpolish"].handle.s:setVisible(true)
--		_childUI["Img_need_floorpolish"].handle.s:setPosition(nX + 423, nY - 3 - (i -1)*64)
--		showNeedChoiceResImg(need_chose)
--		
--		if(my_chose ~= 0 and need_chose ~= 0 and need_chose ~= my_chose) then				--需求和提供都有，而且不想同时，可进行交
--			_childUI["btnSubOne"]:setstate(1)							--"-"按钮
--			_childUI["btnAddOne"]:setstate(1)							--"+"按钮
--			_childUI["btnPlus_Confim"]:setstate(1)
--			showRatioInfo(my_chose,need_chose)
--			--显示兑换比率
--			showRatioNum(my_chose, need_chose)
--
--			maxNum = getMaxNum(my_chose,need_chose)
--			local map_name = hGlobal.WORLD.LastWorldMap.data.map
--			if map_name == "world/level_tyjy" and  maxNum == 40 then
--				nowNum = 20
--				_childUI["scrollBtn"].handle._n:setPosition(320,_bar.data.y - 17)
--				_bar:setV(barLength/2,barLength)
--				showExchangeNum(nowNum)								--更新消耗和获得的数量
--			elseif setbuyOneNum() == true then							--作为引导，强制为玩家设置一个交换数量
--				--设置成功(为玩家设置一个默认购买数量)
--			else
--				nowNum = 0
--				_bar:setV(0,barLength)--清空条
--				_childUI["scrollBtn"].handle._n:setPosition(_bar.data.x + 5 ,_bar.data.y - 17)
--			end
--			_childUI["bar_btn"]:setstate(1)
--			_num:setText(tostring(nowNum.."/"..maxNum))
--			_childUI["Lab_my_cost"].handle.s:setVisible(true)
--			_childUI["Lab_need_cost"].handle.s:setVisible(true)
--		else
--			_childUI["btnSubOne"]:setstate(0)							--"-"按钮
--			_childUI["btnAddOne"]:setstate(0)							--"+"按钮
--			_childUI["btnPlus_Confim"]:setstate(0)
--			_num:setText("--")
--			_childUI["bar_btn"]:setstate(0)
--			_childUI["Lab_my_cost"].handle.s:setVisible(false)
--			_childUI["Lab_need_cost"].handle.s:setVisible(false)
--		end
--		
--		tyjyHide()
--	end
--	
--	--桃园结义的特殊处理
--	tyjyHide = function()
--		local map_name = hGlobal.WORLD.LastWorldMap.data.map
--		if map_name == "world/level_tyjy" then
--			_childUI["Btn_my_res_".._resName[4]]:setstate(-1)
--			_childUI["Btn_my_res_".._resName[5]]:setstate(-1)
--			_childUI["Btn_my_res_".._resName[6]]:setstate(-1)
--			_childUI["Img_my_res".._resName[4]].handle.s:setOpacity(0)				--使资源图片完全透明
--			_childUI["Img_my_res".._resName[5]].handle.s:setOpacity(0)
--			_childUI["Img_my_res".._resName[6]].handle.s:setOpacity(0)
--			
--			_childUI["Btn_need_res_".._resName[4]]:setstate(-1)
--			_childUI["Btn_need_res_".._resName[5]]:setstate(-1)
--			_childUI["Btn_need_res_".._resName[6]]:setstate(-1)
--			_childUI["Img_need_res".._resName[4]].handle.s:setOpacity(0)
--			_childUI["Img_need_res".._resName[5]].handle.s:setOpacity(0)
--			_childUI["Img_need_res".._resName[6]].handle.s:setOpacity(0)
--			
--			_childUI["Lab_my_res_".._resName[4]]:setText("")
--			_childUI["Lab_my_res_".._resName[5]]:setText("")
--			_childUI["Lab_my_res_".._resName[6]]:setText("")
--		end
--	end
--	
--	hGlobal.event:listen("Event_HeroTakeShop","__CHANGE_RES__MARKET",function(oWorld,oUnit,oTarget,nOperate,tData)
--		local u = oUnit
--		local w = oWorld
--		local self_frame = hGlobal.UI.ChangeResourcesFrame
--		if nOperate==hVar.OPERATE_TYPE.UNIT_MARKET then
--			--创建资源
--			creatResourceSwop()								--交换时的资源及背景
--			creatResource()									--“我的资源”和“可兑换资源”
--			
--			_childUI["scrollBtn"].handle._n:setPosition(_bar.data.x + 5 ,_bar.data.y - 17)
--			_childUI["btnSubOne"]:setstate(0)							--"-"按钮
--			_childUI["btnAddOne"]:setstate(0)							--"+"按钮
--			_childUI["btnPlus_Confim"]:setstate(0)
--			--刷新折扣
--			_FUNC_UpdateDiscount()
--			--显示
--			tyjyHide()
--			self_frame:show(1)
--			self_frame:active()
--			my_chose = 0
--			need_chose = 0
--			left = 0
--			right = 0
--			mV = 0
--			nV = 0
--			nowNum = 0
--			maxNum = 0
--			ratioMy = 0
--			ratioNeed = 0
--			_childUI["Img_my_floorpolish"].handle.s:setVisible(false)
--			_childUI["Img_need_floorpolish"].handle.s:setVisible(false)
--			_childUI["Lab_my_cost"].handle.s:setVisible(false)
--			_childUI["Lab_need_cost"].handle.s:setVisible(false)
--			myResFun()
--			showMyChoiceResImg(0)
--			showNeedChoiceResImg(0)
--			_childUI["bar"]:setV(0,barLength)
--			_num:setText("--")
--			_childUI["bar_btn"]:setstate(0)
--			unableMyBtn(0)
--			unableNeedBtn(0)
--			if _childUI["iconImg"] == nil then
--				--市场图标
--				_childUI["iconImg"] = hUI.thumbImage:new({
--					parent = _frm.handle._n,
--					id = tData.id,
--					x = _frm.data.w/2,
--					y = -82,
--				})
--			end
--			
--			local map_name = hGlobal.WORLD.LastWorldMap.data.map
--			
--			--如果桃园结义的话，设置一个默认的选择
--			if map_name == "world/level_tyjy" then
--				choiceMy(3)
--				choiceNeed(1)
--			end
--		end
--	end)
--end
--
----------------------------------
---- 建筑的升级界面
----------------------------------
--hGlobal.UI.InitBuildingUpGrade = function()
--	local _frm,_childUI
--	local _upgradeslot = {}
--	local _upgradebutton = {}
--	local _upgradethumbImage = {}
--	local _requirebutton = {}
--	local _requirethumbImage = {}
--	local _requirelab = {}
--	--显示总价的lab条
--	--lab控件对象
--	local labRes_gold,labRes_food,labRes_stone,labRes_wood,labRes_iron,labRes_jewel = 1,2,3,4,5,6
--	local _labResList = {0,0,0,0,0,0}
--	--图标
--	local Image_gold,Image_food,Image_stone,Image_wood,Image_iron,Image_jewel = 1,2,3,4,5,6
--	local _ImageList = {0,0,0,0,0,0}
--	
--	--购买所需要的资源
--	local gold,food,stone,wood,iron,jewel= 1,2,3,4,5,6
--	local _varList = {0,0,0,0,0,0}
--	--玩家当前的资源，打开界面后更新
--	local _PlayRes = {0,0,0,0,0,0}
--
--	--主界面
--	local __x,__y = 250,650
--	if g_phone_mode ~= 0 then
--		__x,__y = 170,590
--	end
--	__x = hVar.SCREEN.w/2 - 544/2
--	__y = hVar.SCREEN.h/2 + 462/2
--	hGlobal.UI.BuildingUpGradeFrame = hUI.frame:new({
--		x = __x,
--		y = __y,
--		w = 554,
--		h = 462,
--		show = 0,
--		closebtn = "BTN:PANEL_CLOSE",
--		closebtnX = 534,
--		closebtnY = -14,
--		dragable = 2,
--		
--		--background = "UI:PANEL_INFO_S",
--		z = -1,
--	})
--	
--	_frm = hGlobal.UI.BuildingUpGradeFrame
--	_childUI = _frm.childUI
--	
--	_childUI["apartline_back"] = hUI.image:new({
--		parent = _frm.handle._n,
--		model = "UI:panel_part_09",
--		x = 270,
--		y = -150,
--		w = 544,
--		h = 8,
--	})
--	
--	local _oWorld = 0 
--	local _buyUnit = 0
--	local _buyTarget = 0
--	local _upgradeID = 0
--	local _buyTown = 0
--	--金 图片 陶晶2013-4-8
--	_childUI["ImageRes_gold_"] = hUI.image:new({
--		parent = _frm.handle._n,
--		--mode = "batchImage",
--		model = "UI:ICON_main_frm_ResourceGold",
--		animation = "lightSlim",
--		w = 50,
--		x = 30,
--		y = -200,
--	})
--	_ImageList[Image_gold] = _childUI["ImageRes_gold_"]
--	_ImageList[Image_gold].handle._n:setVisible(false)
--	
--	--食物 图片 陶晶2013-4-8
--	_childUI["ImageRes_food_"] = hUI.image:new({
--		parent = _frm.handle._n,
--		--mode = "batchImage",
--		model = "UI:ICON_main_frm_ResourceFood",
--		animation = "lightSlim",
--		w = 50,
--		x = 30,
--		y =-200,
--	})
--	_ImageList[Image_food] = _childUI["ImageRes_food_"]
--	_ImageList[Image_food].handle._n:setVisible(false)
--	
--	--石头 图片 陶晶2013-4-8
--	_childUI["ImageRes_rook_"] = hUI.image:new({
--		parent = _frm.handle._n,
--		--mode = "batchImage",
--		model = "UI:ICON_main_frm_ResourceStone",
--		animation = "lightSlim",
--		w = 50,
--		x = 30,
--		y = -200,
--	})
--	_ImageList[Image_stone] = _childUI["ImageRes_rook_"]
--	_ImageList[Image_stone].handle._n:setVisible(false)
--	
--	--木材 图片 陶晶2013-4-8
--	_childUI["ImageRes_wood_"] = hUI.image:new({
--		parent = _frm.handle._n,
--		--mode = "batchImage",
--		model = "UI:ICON_main_frm_ResourceWood",
--		animation = "lightSlim",
--		w = 50,
--		x = 30,
--		y = -200,
--	})
--	_ImageList[Image_wood] = _childUI["ImageRes_wood_"]
--	_ImageList[Image_wood].handle._n:setVisible(false)
--	
--	--镔铁 图片 陶晶2013-4-8
--	_childUI["ImageRes_iron_"] = hUI.image:new({
--		parent = _frm.handle._n,
--		--mode = "batchImage",
--		model = "UI:ICON_main_frm_ResourceIron",
--		animation = "lightSlim",
--		w = 50,
--		x = 30,
--		y = -200,
--	})
--	_ImageList[Image_iron] = _childUI["ImageRes_iron_"]
--	_ImageList[Image_iron].handle._n:setVisible(false)
--	
--	--宝石 图片 陶晶2013-4-8
--	_childUI["ImageRes_jewel_"] = hUI.image:new({
--		parent = _frm.handle._n,
--		--mode = "batchImage",
--		model = "UI:ICON_main_frm_ResourceJewel",
--		animation = "lightSlim",
--		w = 50,
--		x = 30,
--		y = -200,
--	})
--	_ImageList[Image_jewel] = _childUI["ImageRes_jewel_"]
--	_ImageList[Image_jewel].handle._n:setVisible(false)
--	
--	--所消耗的金币lab 陶晶2013-4-8 
--	_childUI["labRes_gold_"] = hUI.label:new({
--		parent = _frm.handle._n,
--		font = "numWhite",
--		size = 14,
--		text = "0",
--		align = "MC",
--		x = 136,
--		y = -246,
--	})
--	_labResList[labRes_gold] = _childUI["labRes_gold_"]
--	_labResList[labRes_gold].handle._n:setVisible(false)
--	
--	--所消耗的食物lab 陶晶2013-4-8 
--	_childUI["labRes_food_"] = hUI.label:new({
--		parent = _frm.handle._n,
--		font = "numWhite",
--		size = 14,
--		text = "0",
--		align = "MC",
--		x = 136,
--		y = -246,
--	})
--	_labResList[labRes_food] = _childUI["labRes_food_"]
--	_labResList[labRes_food].handle._n:setVisible(false)
--	
--	--所消耗的石头lab 陶晶2013-4-8 
--	_childUI["labRes_stone_"] = hUI.label:new({
--		parent = _frm.handle._n,
--		font = "numWhite",
--		size = 14,
--		text = "0",
--		align = "MC",
--		x = 136,
--		y = -246,
--	})
--	_labResList[labRes_stone] = _childUI["labRes_stone_"]
--	_labResList[labRes_stone].handle._n:setVisible(false)
--	
--	--所消耗的木材lab 陶晶2013-4-8 
--	_childUI["labRes_wood_"] = hUI.label:new({
--		parent = _frm.handle._n,
--		font = "numWhite",
--		size = 14,
--		text = "0",
--		align = "MC",
--		x = 136,
--		y = -246,
--	})
--	_labResList[labRes_wood] = _childUI["labRes_wood_"]
--	_labResList[labRes_wood].handle._n:setVisible(false)
--	
--	--所消耗的镔铁lab 陶晶2013-4-8 
--	_childUI["labRes_iron_"] = hUI.label:new({
--		parent = _frm.handle._n,
--		font = "numWhite",
--		size = 14,
--		text = "0",
--		align = "MC",
--		x = 136,
--		y = -246,
--	})
--	_labResList[labRes_iron] = _childUI["labRes_iron_"]
--	_labResList[labRes_iron].handle._n:setVisible(false)
--	
--	--所消耗的宝石lab 陶晶2013-4-8 
--	_childUI["labRes_jewel_"] = hUI.label:new({
--		parent = _frm.handle._n,
--		font = "numWhite",
--		size = 14,
--		text = "0",
--		align = "MC",
--		x = 136,
--		y = -246,
--	})
--	_labResList[labRes_jewel] = _childUI["labRes_jewel_"]
--	_labResList[labRes_jewel].handle._n:setVisible(false)
--	
--	--目标信息头像底框
--	_childUI["slot_main"] = hUI.image:new({
--		parent = _frm.handle._n,
--		--mode = "batchImage",
--		model = "UI_frm:slot",
--		animation = "lightSlim",
--		w = 74,
--		x = 89,
--		y = -75,
--	})
--	_childUI["requireList"] = hUI.label:new({
--		parent = _frm.handle._n,
--		size = 28,
--		align = "LT",
--		font = hVar.FONTC,
--		x = 48,
--		y =-190,
--		width = 60,
--		text = hVar.tab_string["__TEXT_BuildingRequire"],
--		border = 1,
--
--	})
--		
--	_childUI["upgrade"] = hUI.label:new({
--		parent = _frm.handle._n,
--		size = 28,
--		align = "LT",
--		font = hVar.FONTC,
--		x = 48,
--		y =-270,
--		width = 60,
--		text = hVar.tab_string["__TEXT_UseResources"],
--		border = 1,
--	})
--	
--	--箭头图片
--	_childUI["UpgradeArrow"] = hUI.image:new({
--		parent = _frm.handle._n,
--		model = "UI:UI_Arrow",
--		--scale = 0.3,
--		x = 250,
--		y = -130,
--	})
--	_childUI["UpgradeArrow"].handle.s:setVisible(false)
--	
--	_childUI["upgrade_hint"] = hUI.label:new({
--		parent = _frm.handle._n,
--		size = 24,
--		font = hVar.FONTC,
--		align = "MC",
--		x = 380,
--		y = -130,
--		width = 248,
--		text = "",
--		border = 1,
--	})
--	
--	_childUI["CannotUpgradelab"] = hUI.label:new({
--		parent = _frm.handle._n,
--		size = 24,
--		font = hVar.FONTC,
--		align = "LT",
--		x = 60,
--		y = -1*(_frm.data.h-84),
--		width = 380,
--		text = hVar.tab_string["__TEXT_CanNotBuilding"],
--		RGB = {255,255,0},
--		border = 1,
--	})
--	_childUI["CannotUpgradelab"].handle._n:setVisible(false)
--	
--	--根据传入的 UnitID 在面板上显示升级或者建造所需要的资源
--	local ShowVarList = function(UnitID)
--
--		if type(UnitID) ~= "number" then
--			return
--		end
--		for i = 1,6 do
--			if hVar.tab_unit[UnitID].price then
--				_varList[i] = hVar.tab_unit[UnitID].price[i] or 0
--			else
--				_varList[i] = 0
--			end
--		end
--		
--		local tempindex = 0
--		
--		for i = 1,6 do
--			if _varList[i] and _varList[i] ~= 0 then	
--				--总价显示
--				_ImageList[i].handle._n:setVisible(true)
--				_ImageList[i].handle._n:setPosition(150+80*tempindex,-280)
--				_labResList[i].handle._n:setVisible(true)
--				_labResList[i].handle._n:setPosition(152+80*tempindex,-315)
--				
--				if _PlayRes[i]< (_varList[i]) then
--					_labResList[i].handle.s:setColor(ccc3(255,0,0))
--				else
--					_labResList[i].handle.s:setColor(ccc3(255,255,255))
--				end	
--				_labResList[i]:setText(tostring(_varList[i]))
--				tempindex = tempindex+1	
--			else -- tab 表中没有填写价格时 会隐藏所有价格显示控件
--				_ImageList[i].handle._n:setVisible(false)
--				_labResList[i].handle._n:setVisible(false)
--			end
--		end
--		
--	end
--	
--	--显示升级相关信息
--	local ShowUpgradeInfo = function(pupgradeID,poTarget)
--		--先清空上一次看到的界面
--		_childUI["UpgradeArrow"].handle.s:setVisible(false)
--		_childUI["upgrade_hint"]:setText("")
--		if pupgradeID == nil then
--			return
--		end
--		if pupgradeID == poTarget.data.id then
--			return
--		end
--		_childUI["UpgradeArrow"].handle.s:setVisible(true)
--		
--		
--		local upgradeHint = ""
--		if hVar.tab_stringU[pupgradeID] then
--			upgradeHint = hVar.tab_stringU[pupgradeID][1] or "UNIT_"..pupgradeID.."_HINT"
--		end
--		_childUI["upgrade_hint"]:setText(upgradeHint)
--		--_childUI["upgrade_hint"].handle.s:setColor(ccc3(255,0,0))
--	end
--	
--	--显示前置科技相关信息
--	local removelist = {}
--	local ShowRequireInfo = function(pRequireList,poTarget)
--		--先清空上一次看到的界面
--		for i = 1,#removelist do
--			hApi.safeRemoveT(_childUI,removelist[i])
--		end
--		removelist = {}
--		hApi.safeRemoveT(_childUI,"requiresText")
--		
--		if type(pRequireList) ~= "table" then
--			_childUI["requiresText"] = hUI.label:new({
--				parent = _frm.handle._n,
--				size = 28,
--				align = "LT",
--				font = hVar.FONTC,
--				x = 158,
--				y =-200,
--				width = 380,
--				text = hVar.tab_string["__TEXT_DoNotUserRequire"],
--				RGB = {0,255,255},
--				border = 1,
--			})
--			_childUI["BtnBuy"]:setstate(1)
--			return 
--		end
--		
--		--对主城建造条件进行判断
--		local buildingState = (_buyTown:gettown()).data.upgradeState
--		local tempRedList = {}
--		
--		local _style = hVar.tab_unit[_buyTown.data.id].townstyle
--		--先根据科技列表初始化临时建造状态表
--		for i = 1,#pRequireList do
--			tempRedList[i] = 1
--		end
--		--遍历单位判断需要变色的内容
--		_oWorld:enumunit(function(eu)
--			for i = 1,#pRequireList do
--				if type(pRequireList[i]) == "table" then
--					if _style == pRequireList[i][1] and eu.data.id == pRequireList[i][2] and buildingState[eu.data.indexOfCreate] == 1 then
--						tempRedList[i] = 0
--					end
--					local tabupgrade = hVar.tab_unit[pRequireList[i][2]].upgrade
--					local tempLen = 2
--					for j = 1,tempLen do
--						if tabupgrade and  tabupgrade[2] then
--							if eu.data.id == tabupgrade[2]then
--								tempRedList[i] = 0
--							end
--							tabupgrade = hVar.tab_unit[tabupgrade[2]].upgrade
--							if tabupgrade then
--								tempLen = tempLen + 1
--							end
--						end
--					end
--					
--				elseif type(pRequireList[i]) == "number" then
--					if eu.data.id == pRequireList[i] and buildingState[eu.data.indexOfCreate] == 1 then
--						tempRedList[i] = 0
--					end
--					
--					local tabupgrade = hVar.tab_unit[pRequireList[i]].upgrade
--					if tabupgrade then
--						local tempLen = 2
--						for j = 1,tempLen do
--							if tabupgrade and  tabupgrade[2] then
--								if eu.data.id == tabupgrade[2] then
--									tempRedList[i] = 0
--								end
--								tabupgrade = hVar.tab_unit[tabupgrade[2]].upgrade
--								if tabupgrade then
--									tempLen = tempLen + 1
--								end
--							end
--						end
--					end
--				end
--				
--			end		
--		end)
--		
--		--升级信息相关
--		local _offx = 0
--		local _offxx = 180
--		for i = 1,#pRequireList do
--			if type(pRequireList[i]) == "table" then
--				if _style == pRequireList[i][1] then
--					local RequireID = 0
--					if type(pRequireList[i][2]) == "number" then
--						RequireID = pRequireList[i][2]
--					elseif type(pRequireList[i][2]) == "table" then
--						RequireID = pRequireList[i][2][1]
--					end
--					--头像面板
--					_childUI["requireslot_".._offx] = hUI.image:new({
--						parent = _frm.handle._n,
--						--mode = "batchImage",
--						model = "UI_frm:slot",
--						animation = "lightSlim",
--						w = 58,
--						h = 58,
--						x = 169+(_offx)*_offxx,
--						y = -217,
--					})
--					removelist[#removelist+1] = "requireslot_".._offx
--					
--					_childUI["requireslotthumbImage_".._offx] = hUI.thumbImage:new(
--						{
--						parent = _frm.handle._n,
--						id = RequireID,
--						animation = hApi.animationByFacing(RequireID,"stand",180),
--						w = 80,
--						h = 80,
--						x = 170+(_offx)*_offxx,
--						y = -218,
--						z = 1,
--					})
--					removelist[#removelist+1] = "requireslotthumbImage_".._offx
--					
--					local requireHint = hVar.tab_stringU[RequireID][1] or "UNIT_"..pRequireList[i].."_HINT"
--					
--					_childUI["require_hint_".._offx] = hUI.label:new({
--						parent = _frm.handle._n,
--						size = 24,
--						font = hVar.FONTC,
--						align = "LT",
--						x = 210+(_offxx+10)*(_offx),
--						y = -185,
--						width = 248,
--						text = requireHint,
--						border = 1,
--					})
--					removelist[#removelist+1] = "require_hint_".._offx
--					
--					if tempRedList[i] == 1 then
--						--_childUI["requireslotthumbImage_"..i].handle.s:setColor(ccc3(255,0,0))
--						_childUI["require_hint_".._offx].handle.s:setColor(ccc3(255,0,0))
--						_childUI["BtnBuy"]:setstate(0)
--					else
--						_childUI["BtnBuy"]:setstate(1)
--					end
--					_offx = _offx + 1
--				end
--			elseif type(pRequireList[i]) == "number" then
--				--头像面板
--				_childUI["requireslot_"..i] = hUI.image:new({
--					parent = _frm.handle._n,
--					--mode = "batchImage",
--					model = "UI_frm:slot",
--					animation = "light",
--					w = 58,
--					h = 58,
--					x = 169+(i-1)*_offxx,
--					y = -217,
--				})
--				removelist[#removelist+1] = "requireslot_"..i
--				
--				_childUI["requireslotthumbImage_"..i] = hUI.thumbImage:new(
--					{
--					parent = _frm.handle._n,
--					id = pRequireList[i],
--					animation = hApi.animationByFacing(pRequireList[i],"stand",180),
--					w = 80,
--					h = 80,
--					x = 170+(i-1)*_offxx,
--					y = -218,
--					z = 1,
--				})
--				removelist[#removelist+1] = "requireslotthumbImage_"..i
--				
--				local requireHint = hVar.tab_stringU[pRequireList[i]][1] or "UNIT_"..pRequireList[i].."_HINT"
--				_childUI["require_hint_"..i] = hUI.label:new({
--					parent = _frm.handle._n,
--					size = 24,
--					font = hVar.FONTC,
--					align = "LT",
--					x = 210+(_offxx+10)*(i-1),
--					y = -185,
--					width = 248,
--					border = 1,
--					text = requireHint,
--				})
--				removelist[#removelist+1] = "require_hint_"..i
--				
--				if tempRedList[i] == 1 then
--					--_childUI["requireslotthumbImage_"..i].handle.s:setColor(ccc3(255,0,0))
--					_childUI["require_hint_"..i].handle.s:setColor(ccc3(255,0,0))
--					_childUI["BtnBuy"]:setstate(0)
--				else
--					_childUI["BtnBuy"]:setstate(1)
--				end	
--			end
--		end
--	end
--	--确定建造按钮
--	_childUI["BtnBuy"] = hUI.button:new({
--		parent = _frm.handle._n,
--		mode = "imageButton",
--		model = "UI:confirmbut",
--		dragbox = _frm.childUI["dragBox"],
--		x = _frm.data.w - 100,
--		y = -1*(_frm.data.h-74),
--		scaleT = 0.9,
--		code = function(self)
--			return hGlobal.LocalPlayer:order(_oWorld,hVar.OPERATE_TYPE.UNIT_UPGRADE,_buyUnit,_upgradeID,_buyTarget)
--		end,
--	})	
--	_childUI["BtnBuy"]:setstate(0)
--	
--	--单位名字
--	_childUI["Unit_Name"] = hUI.label:new({
--		parent = _frm.handle._n,
--		size = 28,
--		font = hVar.FONTC,
--		align = "MC",
--		x = 88,
--		y = -130,
--		width = 248,
--		text = "",--uName,
--		border = 1,
--		RGB = {255,255,0},
--	})
--	
--	-- 建造（升级）单位介绍
--	_childUI["Unit_hint"] = hUI.label:new({
--		parent = _frm.handle._n,
--		size = 26,
--		font = hVar.FONTC,
--		align = "LT",
--		x = 150,
--		y = 0,---76+ textlen*10,
--		width = 340,
--		text = "",--uHint,
--		border = 1,
--	})
--	
--	hGlobal.event:listen("LocalEvent_ShowBuildingUpgrade","__SHOW_UPGRADE_UI",function(nOperate,oWorld,oUnit,oTown,oTarget)
--		if nOperate==hVar.INTERACTION_TYPE.UPGRADE then
--			_childUI["BtnBuy"]:setstate(0)
--			_oWorld = oWorld
--			_buyTarget = oTarget
--			_buyTown = oTown
--			_buyUnit = oUnit
--			--根据编辑器顺序进行资源保存
--			_PlayRes = {
--				hGlobal.LocalPlayer:getresource(hVar.RESOURCE_TYPE.GOLD),
--				hGlobal.LocalPlayer:getresource(hVar.RESOURCE_TYPE.FOOD),
--				hGlobal.LocalPlayer:getresource(hVar.RESOURCE_TYPE.STONE),
--				hGlobal.LocalPlayer:getresource(hVar.RESOURCE_TYPE.WOOD),
--				hGlobal.LocalPlayer:getresource(hVar.RESOURCE_TYPE.LIFE),
--				hGlobal.LocalPlayer:getresource(hVar.RESOURCE_TYPE.CRYSTAL)
--			}
--			--获取临时升级表和前置科技表
--			local tempupgrade = (oTown:gettown()).data.upgrade or 0
--			local UpGradeList = {}
--			
--			for i = 1, #tempupgrade do
--				if tempupgrade[i].indexOfCreate == oTarget.data.indexOfCreate then
--					UpGradeList = tempupgrade[i].upgradelist
--				end
--			end
--
--			--判断自己是否需要建造 则优先保存自己的建造价格
--			if UpGradeList[1] == 0 then
--				_upgradeID = oTarget.data.id
--				
--			else
--				_upgradeID = UpGradeList[2]
--				
--			end
--			
--			ShowVarList(_upgradeID)
--			
--			hApi.safeRemoveT(_childUI,"thumbImage_main")
--			--目标建筑信息相关
--			_childUI["thumbImage_main"] = hUI.thumbImage:new(
--				{
--				parent = _frm.handle._n,
--				id = oTarget.data.id,
--				animation = hApi.animationByFacing(oTarget,"stand",180),
--				w = 104,
--				h = 104,
--				x = 83,
--				y = -68,
--				z = 1,
--			})
--			
--			local uName = "UNIT_"..oTarget.data.id.."_HINT"
--			if hVar.tab_stringU[oTarget.data.id] then
--					uName = hVar.tab_stringU[oTarget.data.id][1]
--			end
--			local uHint = ""
--			if _upgradeID then
--				if hVar.tab_stringU[_upgradeID] then
--					uHint = hVar.tab_string["__TEXT_AfterBuilding"]..hVar.tab_stringU[_upgradeID][2]
--				end
--				
--				if oWorld and type(oWorld.data.ProvidePec) == "number" then
--					if hVar.tab_unit[_upgradeID].provide then
--						local nCount = hVar.tab_unit[_upgradeID].provide[1][2]
--						nCount = math.floor(nCount * oWorld.data.ProvidePec / 100 )
--						uHint = string.gsub(uHint,"%%(%w+)%%",nCount)
--					end
--				end
--			end
--			_childUI["Unit_Name"]:setText(uName)
--			
--			local textlen = math.ceil(string.len(uHint)/26) 
--			
--			_childUI["Unit_hint"]:setText(uHint)
--			_childUI["Unit_hint"].handle._n:setPosition(150,-76+textlen*10)
--			
--			_childUI["BtnBuy"]:setstate(1)
--			_childUI["CannotUpgradelab"].handle._n:setVisible(false)
--			--显示升级信息
--			ShowUpgradeInfo(_upgradeID,oTarget)
--			--显示前置信息
--			if _upgradeID then
--				ShowRequireInfo(hVar.tab_unit[_upgradeID].require,oTarget)
--				_frm:show(1)
--			end
--			
--			if (oTown:gettown()).data.buildingCount > 0 then
--				_childUI["BtnBuy"]:setstate(0)
--				_childUI["CannotUpgradelab"].handle._n:setVisible(true)
--			end
--		end
--	end)
--	
--	
--	--购买成功后的监听事件 陶晶 2013-4-8
--	hGlobal.event:listen("Event_BuildingUpgrade","__BuildingUpGradeConfirm",function(oOperatingUnit,oWorld,oTown,vOrderId)
--		--added by pangyong 2015/4/3 
--		hGlobal.event:event("LocalEvent_RefreshHeroTeamList")
--		
--		_frm:show(0)
--	end)
--	
--	--切地图隐藏
--	hGlobal.event:listen("LocalEvent_PlayerFocusWorld","__hidefrm",function(sSceneType,oWorld,oMap)
--		_frm:show(0)
--	end)
--end

--------------------------------
-- 结束提醒面板
--------------------------------
hGlobal.UI.InitSystemMgxBox = function()
	--不能建造的提示面板
	hGlobal.UI.SystemMgxBox = hUI.frame:new({
		x = hVar.SCREEN.w/2 - 210,
		y = hVar.SCREEN.h/2 + 135,
		closebtn = 0,--"BTN:PANEL_CLOSE",
		background = "UI:PANEL_INFO_MINI",
		
	})
	hGlobal.UI.SystemMgxBox:show(0)
		
	local _fram = hGlobal.UI.SystemMgxBox
	local _childUI = _fram.childUI
	
	
	_childUI["SystemMgxBoxlab"] = hUI.label:new({
		parent = _fram.handle._n,
		size = 24,
		font = hVar.FONTC,
		align = "LT",
		x = 30,
		y = -80,
		width = 340,
		text = "",
		border = 1,
	})
	
	_childUI["SystemMgxBoxlabTitle"] = hUI.label:new({
		parent = _fram.handle._n,
		size = 28,
		font = hVar.FONTC,
		align = "MC",
		x =  _fram.data.w/2 - 20,
		y = -40,
		width = 450,
		text = hVar.tab_string["__TEXT_MSGTitle"],
		border = 1,
	})
	
	_childUI["BtnYes"] = hUI.button:new({
		parent = _fram,
		model = "UI:ButtonBack2",
		label = {text = hVar.tab_string["__TEXT_Confirm"],size = 26,font = hVar.FONTC,border = 1,},
		x = _fram.data.w/2 + 70,
		y = -1*(_fram.data.h-60),
		scaleT = 0.9,
		ox = -10,
		oy = 10,
		w = 142,
		h = 52,
		sizeW = 116,
		sizeH = 36,
		code = function(self)
			xlLuaEvent_EndDay(g_game_days)
			hGlobal.event:event("LocalEvent_NextDayBreathe",0)
			_fram:show(0)
		end,
	})
	_childUI["BtnNo"] = hUI.button:new({
		parent = _fram,
		model = "UI:ButtonBack2",
		label = {text = hVar.tab_string["__TEXT_Back"],size = 26,font = hVar.FONTC,border = 1,},
		x = _fram.data.w/2 - 90,
		y = -1*(_fram.data.h-60),
		ox = -10,
		oy = 10,
		w = 142,
		h = 52,
		sizeW = 116,
		sizeH = 36,
		scaleT = 0.9,
		code = function(self)
			_fram:show(0)
		end,
	})
	
	hGlobal.event:listen("LocalEvent_SystemMsgBox","__SHOW_SystemMsgBox_FRAM",function(buildingRes,movepointRes)
		local text = ""
		if buildingRes == 1 and movepointRes == 0 then
			text = hVar.tab_string["__TEXT_BuildingWarn"]
		elseif buildingRes == 0 and movepointRes == 1 then
			text = hVar.tab_string["__TEXT_MovepointWarn"]
		elseif buildingRes == 1 and movepointRes == 1 then
			text = hVar.tab_string["__TEXT_DoubleWarn"]
		end
		_childUI["SystemMgxBoxlab"]:setText(text)
		_fram:show(1)
		
	end)
	
end









--------------------------------
-- 技能介绍面板
--------------------------------
--技能说明面板
hGlobal.UI.InitSkillInfoFram = function()
	--删除上一次的
	if hGlobal.UI.SkillInfoFram then
		hGlobal.UI.SkillInfoFram:del()
		hGlobal.UI.SkillInfoFram = nil
	end
	
	--主界面
	local __x,__y = 150, 600
	if g_phone_mode == 0 then
		__x,__y = 150,530
	elseif g_phone_mode == 1 then
		__x,__y = 150,480
	elseif g_phone_mode == 2 then
		__x,__y = 240,488
	elseif g_phone_mode == 3 then
		__x,__y = 320,530
	end
	
	local _currentSkillId = 0 --技能id
	local _currentLv = 1 --当前查看的等级
	
	--绘制技能面板
	hGlobal.UI.SkillInfoFram = hUI.frame:new({
		x = __x,
		y = __y,
		z = 102,
		closebtn = "BTN:PANEL_CLOSE",
		border = "UI:TileFrmBasic_thin",
		closebtnX = 450,
		closebtnY = -20,
		w = 460,
		h = 320,
		dragable = 3,
		show = 0,
	})
	
	local Fram = hGlobal.UI.SkillInfoFram
	local SkillInfoparent = Fram.handle._n
	local SkillInfochildUI = Fram.childUI
	
	local SkillAttr = {
		--攻击类型 
		hApi._add_Icon("IconSkillType","ICON:icon01_x1y10","normal",51,-276),
		hApi._add_Label("LabelSkillType",hVar.tab_string["__Attr_Strtype"],75,-282),
		hApi._add_Val("AttrSkillType",hVar.FONTC,166,-276 - 1,"","LC", 19.6),
		hApi._add_Icon("IconSkillTypeEx","UI:ach_lightning","normal",166,-276,22),
		hApi._add_Val("AttrSkillTypeEx",hVar.FONTC,178, -276 - 1,"","LC", 19.6),
		
		--[[
		--攻击范围 
		hApi._add_Icon("IconSkillRange","ICON:MOVERANGE","normal",51,-276),
		hApi._add_Label("LabelSkillRange",hVar.tab_string["__Attr_AtkRange"],75,-282),
		hApi._add_Val("AttrSkillRange1",hVar.FONTC,166,-276,"","LC",19.6),
		hApi._add_Val("AttrSkillRange2","num",166,-276,"","LC",19.6),
		
		--消耗魔法 
		hApi._add_Icon("IconManaCost","ICON:HeroAttr","mp_pec",280,-246),
		hApi._add_Label("LabelManaCost",hVar.tab_string["__Attr_ManaCost"],306,-250),
		hApi._add_Val("AttrManaCost","num",400,-246,"","LC",19.6),
		]]
		
		--技能时间
		hApi._add_Icon("Iconcooldown", "ui/bimage_replay.png", "mp_pec", 280, -276),
		hApi._add_Label("Labelcooldown", hVar.tab_string["__Attr_cooldown"],306, -282),
		hApi._add_Val("Attrcooldown", "num", 400, -276 - 1, "","LC", 19.6),
	}
	
	SkillInfochildUI["SkillAttr"] = hUI.node:new({
		parent = SkillInfoparent,
		child = SkillAttr,
	})
	--技能说明
	SkillInfochildUI["skillInfoLab"] = hUI.label:new({
		parent = SkillInfoparent,
		size = 22,
		align = "LT",
		font = hVar.FONTC,
		x = 120,
		y =-68,
		width = 300,
		border = 1,
		text = "",--temptext_info,
	})
	
	--技能等级前缀
	SkillInfochildUI["skillLvPrefix"] = hUI.label:new({
		parent = SkillInfoparent,
		size = 26,
		align = "RC",
		font = hVar.FONTC,
		x = 245,
		y = -232,
		width = 300,
		border = 1,
		--text = "等级", --language
		text = hVar.tab_string["__Attr_Hint_Lev"], --language
		RGB = {255, 168, 48},
	})
	SkillInfochildUI["skillLvPrefix"].handle.s:setColor(ccc3(255, 224, 128))
	
	--技能等级值
	SkillInfochildUI["skillLvValue"] = hUI.label:new({
		parent = SkillInfoparent,
		size = 22,
		align = "MC",
		font = "numWhite",
		x = 245 + 20,
		y = -232,
		width = 300,
		border = 0,
		text = "1",
	})
	SkillInfochildUI["skillLvValue"].handle.s:setColor(ccc3(255, 224, 128))
	
	--技能等级左翻页按钮
	SkillInfochildUI["pageLeftBtn"] = hUI.button:new({
		parent = SkillInfoparent,
		model = "misc/mask.png", --"UI:playerBagD"
		x = 130,
		y = -230,
		w = 206,
		h = 220,
		scaleT = 0.95,
		dragbox = Fram.childUI["dragBox"],
		code = function()
			--如果技能只有1项，是不支持翻页的
			local maxLv = (hVar.tab_stringS[_currentSkillId]) and (#hVar.tab_stringS[_currentSkillId] - 1) or 0
			if (maxLv <= 1) then
				return
			end
			
			--当前已到1级，不能翻页
			if (_currentLv <= 1) then
				return
			end
			
			--绘制技能等级
			_currentLv = _currentLv - 1
			SkillInfochildUI["skillLvValue"]:setText(_currentLv)
			
			--绘制技能描述
			local temptext_info = ""
			if hVar.tab_stringS[_currentSkillId] then
				temptext_info = hVar.tab_stringS[_currentSkillId][_currentLv + 1] or ""
			else
				temptext_info = "this skill " .. "[" .. _currentLv .. "]" .. " haven't info ".._currentSkillId
			end
			SkillInfochildUI["skillInfoLab"]:setText(temptext_info)
			
			--检测左翻页按钮
			if (_currentLv > 1) then
				SkillInfochildUI["pageLeftBtn"].childUI["img"].handle.s:setOpacity(255)
				SkillInfochildUI["pageLeftBtn"].childUI["img"].handle.s:setColor(ccc3(255, 255, 255))
			else
				SkillInfochildUI["pageLeftBtn"].childUI["img"].handle.s:setOpacity(96)
				SkillInfochildUI["pageLeftBtn"].childUI["img"].handle.s:setColor(ccc3(128, 128, 128))
			end
			
			--显示右翻页按钮
			SkillInfochildUI["pageRightBtn"].childUI["img"].handle.s:setOpacity(255)
			SkillInfochildUI["pageRightBtn"].childUI["img"].handle.s:setColor(ccc3(255, 255, 255))
		end,
	})
	SkillInfochildUI["pageLeftBtn"].handle.s:setOpacity(0) --翻页按钮实际响应区域，只用于控制，不显示
	
	--技能等级左翻页按钮图片
	SkillInfochildUI["pageLeftBtn"].childUI["img"] = hUI.image:new({
		parent = SkillInfochildUI["pageLeftBtn"].handle._n,
		model = "UI:playerBagD",
		x = 45,
		y = 0,
		scale = 1.0,
	})
	SkillInfochildUI["pageLeftBtn"].childUI["img"].handle.s:setRotation(90)
	
	--技能等级右翻页按钮
	SkillInfochildUI["pageRightBtn"] = hUI.button:new({
		parent = SkillInfoparent,
		model = "misc/mask.png", --"UI:playerBagD"
		x = 340,
		y = -230,
		w = 206,
		h = 220,
		scaleT = 0.95,
		dragbox = Fram.childUI["dragBox"],
		code = function()
			--如果技能只有1项，是不支持翻页的
			local maxLv = (hVar.tab_stringS[_currentSkillId]) and (#hVar.tab_stringS[_currentSkillId] - 1) or 0
			if (maxLv <= 1) then
				return
			end
			
			--当前已到最后一级，不能翻页
			if (_currentLv >= maxLv) then
				return
			end
			
			--绘制技能等级
			_currentLv = _currentLv + 1
			SkillInfochildUI["skillLvValue"]:setText(_currentLv)
			
			--绘制技能描述
			local temptext_info = ""
			if hVar.tab_stringS[_currentSkillId] then
				temptext_info = hVar.tab_stringS[_currentSkillId][_currentLv + 1] or ""
			else
				temptext_info = "this skill " .. "[" .. _currentLv .. "]" .. " haven't info ".._currentSkillId
			end
			SkillInfochildUI["skillInfoLab"]:setText(temptext_info)
			
			--显示左翻页按钮
			SkillInfochildUI["pageLeftBtn"].childUI["img"].handle.s:setOpacity(255)
			SkillInfochildUI["pageLeftBtn"].childUI["img"].handle.s:setColor(ccc3(255, 255, 255))
			
			--检测右翻页按钮
			if (_currentLv < maxLv) then
				SkillInfochildUI["pageRightBtn"].childUI["img"].handle.s:setOpacity(255)
				SkillInfochildUI["pageRightBtn"].childUI["img"].handle.s:setColor(ccc3(255, 255, 255))
			else
				SkillInfochildUI["pageRightBtn"].childUI["img"].handle.s:setOpacity(96)
				SkillInfochildUI["pageRightBtn"].childUI["img"].handle.s:setColor(ccc3(128, 128, 128))
			end
		end,
	})
	SkillInfochildUI["pageRightBtn"].handle.s:setOpacity(0) --翻页按钮实际响应区域，只用于控制，不显示
	
	--技能等级右翻页按钮图片
	SkillInfochildUI["pageRightBtn"].childUI["img"] = hUI.image:new({
		parent = SkillInfochildUI["pageRightBtn"].handle._n,
		model = "UI:playerBagD",
		x = -40,
		y = 0,
		scale = 1.0,
	})
	SkillInfochildUI["pageRightBtn"].childUI["img"].handle.s:setRotation(-90)
	
	--技能强化信息
	SkillInfochildUI["skillInfoLab1"] = hUI.label:new({
		parent = SkillInfoparent,
		size = 22,
		align = "LT",
		font = hVar.FONTC,
		x = 40,
		y =-170,
		width = 380,
		border = 1,
		text = "",--temptext_info,
	})
	
	--技能名
	SkillInfochildUI["skillnameLab"] = hUI.label:new({
		parent = SkillInfoparent,
		size = 32,
		align = "MC",
		font = hVar.FONTC,
		x = 240,
		y = -36,
		width = 600,
		border = 1,
		RGB = {255, 168, 48},
		text = "",--temptext_name,
	})
	
	local _code_ReplaceTipStr = function(str,tip)
		for i = 1,#tip do
			str = string.gsub(str,"%[P"..i.."%]",tostring(tip[i]))
		end
		return str
	end
	
	--监听打开技能面板事件
	hGlobal.event:listen("LocalEvent_ShowSkillInfoFram","__show_skillFram",function(HeroID, skillID, x, y, mode, upinfo)
		--print(debug.traceback())
		if HeroID == nil and skillID == nil then Fram:show(0) return end
		hGlobal.UI.UnitInfoFram:show(0)
		hApi.safeRemoveT(SkillInfochildUI,"skillInfoImage")
		
		if mode == "RB" then
			Fram:setXY(x - Fram.data.w,y + Fram.data.h)
		else
			Fram:setXY(__x,__y)
		end
		
		local animation,model,modelBG = hUI.GetItemSkillAnimation(skillID)
		--技能图标
		local oImage = hUI.image:new({
			parent = SkillInfoparent,
			model = model,
			x = 68,
			y = -102,
			w = 64,
			h = 64,
		})
		SkillInfochildUI["skillInfoImage"] = oImage
		
		--是否需要绘制背景
		if modelBG~=nil then
			hUI.deleteUIObject(hUI.image:new({
				parent = oImage.handle._n,
				model = modelBG,
				z = -1,
				x = 33,
				y = 33,
				w = 64,
				h = 64,
			}))
		end
		
		--是否是强化过的
		if upinfo == 1 then
			hUI.deleteUIObject(hUI.image:new({
				parent = oImage.handle._n,
				model = "UI:skillup",
				y = 33,
				x = 33,
				w = 80,
				h = 80,
			}))
		end
		
		--技能名字和说明
		local temptext_name = ""
		local temptext_info = ""
		local temptext_info1 = ""
		if hVar.tab_stringS[skillID] then
			temptext_name = hVar.tab_stringS[skillID][1]
			temptext_info = hVar.tab_stringS[skillID][2] or ""
			temptext_info1 = hVar.tab_stringS[skillID][3] or ""
			local tabS = hVar.tab_skill[skillID]
			if tabS and tabS.tip then
				if type(tabS.tip[1])=="table" then
					temptext_info = _code_ReplaceTipStr(temptext_info,tabS.tip[1])
				end
				if type(tabS.tip[2])=="table" then
					temptext_info1 = _code_ReplaceTipStr(temptext_info1,tabS.tip[2])
				end
			end
		else
			temptext_name = "tab_stringS["..skillID.."] is null"
			temptext_info = "this skill " .. "[1]" .. " haven't info "..skillID
			temptext_info1 = ""
		end
		SkillInfochildUI["skillnameLab"]:setText(temptext_name)
		local nSize = 22
		if string.sub(temptext_info,1,5)=="@size" then
			local l = string.len(temptext_info)
			local e = string.find(temptext_info,"@",6)
			if e and e>6 then
				nSize = tonumber(string.sub(temptext_info,6,e-1))
				temptext_info = string.sub(temptext_info,e+1,l)
			end
		end
		if type(nSize)=="number" and SkillInfochildUI["skillInfoLab"].data.size~=nSize then
			SkillInfochildUI["skillInfoLab"]:del()
			SkillInfochildUI["skillInfoLab"] = hUI.label:new({
				parent = SkillInfoparent,
				size = nSize,
				align = "LT",
				font = hVar.FONTC,
				x = 120,
				y =-60,
				width = 300,
				border = 1,
				text = temptext_info,
			})
		else
			SkillInfochildUI["skillInfoLab"]:setText(temptext_info)
		end
		local size = SkillInfochildUI["skillInfoLab"].handle.s:getContentSize()
		local exHint = SkillInfochildUI["skillInfoLab1"]
		if size.height<=72 then
			exHint.data.align = "LC"
			exHint.data.y = SkillInfochildUI["skillInfoLab"].data.y - 116
		else
			exHint.data.align = "LT"
			exHint.data.y = SkillInfochildUI["skillInfoLab"].data.y - math.max(72,size.height) - 9
		end
		--exHint.handle._n:setPosition(exHint.data.x,exY)
		--exHint:setText(temptext_info1)
		exHint:setText("")
		
		--获取技能类型
		local SkillType = hVar.tab_skill[skillID].cast_type
		local Typetext = ""
		if (SkillType == nil) or (SkillType == hVar.CAST_TYPE.NONE) then
			Typetext = hVar.tab_string["__TEXT_CAST_TYPE_NONE"]
		elseif (SkillType == hVar.CAST_TYPE.MOVE) then
			Typetext = hVar.tab_string["__TEXT_CAST_TYPE_MOVE"]
		elseif (SkillType == hVar.CAST_TYPE.IMMEDIATE) then
			Typetext = hVar.tab_string["__TEXT_CAST_TYPE_IMMEDIATE"]
		elseif (SkillType == hVar.CAST_TYPE.SKILL_TO_GRID) then
			Typetext = hVar.tab_string["__TEXT_CAST_TYPE_SKILL_TO_GRID"]
		elseif (SkillType == hVar.CAST_TYPE.SKILL_TO_GROUND) then --geyachao: 新加的施法类型，对地面施法
			Typetext = hVar.tab_string["__TEXT_CAST_TYPE_SKILL_TO_GROUND"]
		elseif (SkillType == hVar.CAST_TYPE.SKILL_TO_GROUND_BLOCK) then --geyachao: 新加的施法类型，对有效地面施法
			Typetext = hVar.tab_string["__TEXT_CAST_TYPE_SKILL_TO_GROUND_BLOCK"]
		elseif (SkillType == hVar.CAST_TYPE.SKILL_TO_GROUND_MOVE_TO_POINT) then --geyachao: 新加的施法类型，移动到射程内对地面释放
			Typetext = hVar.tab_string["__TEXT_CAST_TYPE_SKILL_TO_GROUND_MOVE_TO_POINT"]
		elseif (SkillType == hVar.CAST_TYPE.SKILL_TO_GROUND_MOVE_TO_POINT_BLOCK) then --geyachao: 新加的施法类型，移动到射程内的有效点对地面释放
			Typetext = hVar.tab_string["__TEXT_CAST_TYPE_SKILL_TO_GROUND_MOVE_TO_POINT_BLOCK"]
		elseif (SkillType == hVar.CAST_TYPE.SKILL_TO_UNIT_MOVE_TO_POINT) then --geyachao: 新加的施法类型，移动到射程内对随机敌人释放
			Typetext = hVar.tab_string["__TEXT_CAST_TYPE_SKILL_TO_UNIT_MOVE_TO_POINT"]
		elseif (SkillType == hVar.CAST_TYPE.SKILL_TO_GROUND_BLOCK_ENERGY) then --TD对地面有效的非障碍点地方，靠近能量圈附近
			Typetext = hVar.tab_string["__TEXT_CAST_TYPE_SKILL_TO_GROUND_BLOCK_ENERGY"]
		elseif (SkillType == hVar.CAST_TYPE.SKILL_TO_UNIT) then
			Typetext = hVar.tab_string["__TEXT_CAST_TYPE_SKILL_TO_UNIT"]
		elseif (SkillType == hVar.CAST_TYPE.SKILL_TO_UNIT_IMMEDIATE) then
			Typetext = hVar.tab_string["__TEXT_CAST_TYPE_SKILL_TO_UNIT_IMMEDIATE"]
		elseif (SkillType == hVar.CAST_TYPE.AUTO) then
			Typetext = hVar.tab_string["__TEXT_CAST_TYPE_SKILL_AUTO"]
		end
		
		--[[
		--获取技能范围
		local rMin,rMax = hApi.GetSkillRange(skillID, HeroID)
		
		SkillInfochildUI["SkillAttr"].childUI["AttrSkillRange1"].handle._n:setVisible(false)
		SkillInfochildUI["SkillAttr"].childUI["AttrSkillRange2"].handle._n:setVisible(false)
		--最小距离和最大距离都为 -1 时 为全屏攻击
		if rMin == -1 and rMax == -1 then
			SkillInfochildUI["SkillAttr"].childUI["AttrSkillRange1"]:setText(hVar.tab_string["__Text_AllSpace"])
			SkillInfochildUI["SkillAttr"].childUI["AttrSkillRange1"].handle._n:setVisible(true)
		--其他情况则显示出范围
		else
			SkillInfochildUI["SkillAttr"].childUI["AttrSkillRange2"]:setText(rMin.." - "..rMax)
			SkillInfochildUI["SkillAttr"].childUI["AttrSkillRange2"].handle._n:setVisible(true)
		end
		]]
		
		local tabS = hVar.tab_skill[skillID]
		local tabU = hVar.tab_unit[HeroID]
		
		--[[
		--耗蓝
		local ManaCost = tabS.manacost or 0
		]]
		
		--geyachao: TD改为读取冷却时间
		local cooldown = 0
		if tabU.talent then
			for i = 1, #tabU.talent, 1 do
				if (tabU.talent[i][1] == skillID) then
					cooldown = tabU.talent[i][3] / 1000
				end
			end
		end
		if tabU.tactics then
			for i = 1, #tabU.tactics, 1 do
				local tacticId = tabU.tactics[i]
				if hVar.tab_tactics[tacticId] and hVar.tab_tactics[tacticId].activeSkill and (hVar.tab_tactics[tacticId].activeSkill.id == skillID) then 
					cooldown = hVar.tab_tactics[tacticId].activeSkill.cd[1]
				end
			end
		end
		if tabU.arrr and tabU.arrr.skill then
			for i = 1, #tabU.arrr.skill, 1 do
				if (tabU.arrr.skill[i][1] == skillID) then
					cooldown = tabU.arrr.skill[i][3] / 1000
				end
			end
		end
		local castType = tabS.cast_type
		if (castType == hVar.CAST_TYPE.NONE) or (castType == hVar.CAST_TYPE.AUTO) then --无, 自动
			cooldown = "-"
		end
		
		if tabS.reactive==1 then
			--施展后可在动的技能
			SkillInfochildUI["SkillAttr"].childUI["AttrSkillTypeEx"]:setText(Typetext)
			SkillInfochildUI["SkillAttr"].childUI["AttrSkillType"].handle._n:setVisible(false)
			SkillInfochildUI["SkillAttr"].childUI["IconSkillTypeEx"].handle._n:setVisible(true)
			SkillInfochildUI["SkillAttr"].childUI["AttrSkillTypeEx"].handle._n:setVisible(true)
		else
			--一般技能
			SkillInfochildUI["SkillAttr"].childUI["AttrSkillType"]:setText(Typetext)
			SkillInfochildUI["SkillAttr"].childUI["AttrSkillType"].handle._n:setVisible(true)
			SkillInfochildUI["SkillAttr"].childUI["IconSkillTypeEx"].handle._n:setVisible(false)
			SkillInfochildUI["SkillAttr"].childUI["AttrSkillTypeEx"].handle._n:setVisible(false)
		end
		--[[
		SkillInfochildUI["SkillAttr"].childUI["AttrManaCost"]:setText(ManaCost)
		]]
		SkillInfochildUI["SkillAttr"].childUI["Attrcooldown"]:setText(cooldown) --冷却时间
		
		--绘制技能等级
		_currentSkillId = skillID
		_currentLv = 1
		SkillInfochildUI["skillLvValue"]:setText(_currentLv)
		
		--隐藏左翻页按钮
		SkillInfochildUI["pageLeftBtn"].childUI["img"].handle.s:setOpacity(96)
		SkillInfochildUI["pageLeftBtn"].childUI["img"].handle.s:setColor(ccc3(128, 128, 128))
		
		--检测右翻页按钮
		local maxLv = (hVar.tab_stringS[_currentSkillId]) and (#hVar.tab_stringS[_currentSkillId] - 1) or 0
		if (maxLv > _currentLv) then
			SkillInfochildUI["pageRightBtn"].childUI["img"].handle.s:setOpacity(255)
			SkillInfochildUI["pageRightBtn"].childUI["img"].handle.s:setColor(ccc3(255, 255, 255))
		else
			SkillInfochildUI["pageRightBtn"].childUI["img"].handle.s:setOpacity(96)
			SkillInfochildUI["pageRightBtn"].childUI["img"].handle.s:setColor(ccc3(128, 128, 128))
		end
		
		Fram:show(1)
		Fram:active()
	end)
end
--[[
--测试
hGlobal.UI.InitSkillInfoFram()
hGlobal.event:event("LocalEvent_ShowSkillInfoFram", 18001, 14015, 150, 600)
]]





--------------------------------
-- 单位信息介绍面板
--------------------------------
--单位介绍面板
hGlobal.UI.InitUnitInfoFram = function()
	local _add_Label = function(name,text,x,y,scale)
		return {
			__UI = "label",
			__NAME = name,
			text = text,
			size = 32,
			font = hVar.FONTC,
			scale = scale or 0.7,
			x = x,
			y = y,
			align = "LC",
			border = 1,
		}
	end
	local _add_Val = function(name,font,x,y,text,align,size)
		return {
			__UI = "label",
			__NAME = name,
			text = text or "999/999",
			font = font,
			size = size or 16,
			x = x,
			y = y,
			align = align or "MC",
			border = 1,
		}
	end
	local _add_Icon = function(name,model,animation,x,y,width)
		return {
			__UI = "image",
			__NAME = name,
			model = model,
			animation = animation,
			x = x,
			y = y,
			align = "LT",
			w = width or 32,
		}
	end
	
	--主界面
	hGlobal.UI.UnitInfoFram = hUI.frame:new({
		x = 0,
		y = 0,
		closebtn = "BTN:PANEL_CLOSE",
		closebtnX = 450,
		closebtnY = -14,
		--background = "UI:PANEL_INFO_S",
		w = 460,										--changed by pangyong 2015/4/10		(兵种详细信息界面的宽度调整)
		h = 430,
		dragable = 3,
		show = 0,
		border	= "UI:TileFrmBasic_thin",							--added by pangyong 2015/4/9		(兵种详细信息界面的系细边框)
		codeOnClose = function()
			--changed by pangyong 2015/4/13		(兵种详细信息界面的关闭后对军队列表关闭的影响，hGlobal.UI.Phone_herocardFrm已经废弃，现用hGlobal.UI.HeroCardNewFrm = hUI.frame:new)
			--if hGlobal.UI.Phone_herocardFrm and hGlobal.UI.Phone_herocardFrm.data.show == 0 then
				--hGlobal.event:event("LocalEvent_UnitInfo_close")
			--end
			hGlobal.event:event("LocalEvent_UnitInfo_close")
		end,
	})
	
	hGlobal.UI.UnitInfoFram["apartline_back"] = hUI.image:new({
		parent = hGlobal.UI.UnitInfoFram.handle._n,
		model = "UI:panel_part_09",								--分界线
		x = 230,
		y = -150,
		w = 460,
		h = 8,
	})

	--背景底图
	hGlobal.UI.UnitInfoFram.childUI["armybuttonBG_"] = hUI.image:new({
		parent = hGlobal.UI.UnitInfoFram.handle._n,
		model = "UI_frm:slot",									--任务或武器的背景框
		animation = "light",
		w = 58,
		h = 58,
		x = 45,
		y = -75,
	})
	
	local _linfoX,_linfoY = 30,-180
	local _tabx = 250
	local _UnitLabel = {
		--生命值法力值
		_add_Icon("iconHp","ICON:HeroAttr","hp_pec",_linfoX,_linfoY),
		_add_Label("LabelHp",hVar.tab_string["__Attr_Hint_Hp:"],_linfoX+28,_linfoY-5),
		_add_Val("attrHp","numRed",_linfoX+128,_linfoY,"0","LC"),
		
		--法力
		_add_Icon("iconMp","ICON:HeroAttr","mp_pec",_linfoX+_tabx,_linfoY),
		_add_Label("LabelMp",hVar.tab_string["__Attr_Hint_Mp:"],_linfoX+_tabx+28,_linfoY-5),
		_add_Val("attrMp","numBlue",_linfoX+_tabx+127,_linfoY,"0","LC"),
		
		--攻击力
		_add_Icon("iconAtk","ICON:action_attack","normal",_linfoX,_linfoY-35),
		_add_Label("LabelAtk",hVar.tab_string["__Attr_Atk"],_linfoX+28,_linfoY-42),
		_add_Val("attrAtk","num",_linfoX+128,_linfoY-35,"0","LC"),
		
		--护甲
		_add_Icon("iconDef","ICON:DETICON","normal",_linfoX+_tabx,_linfoY-35),
		_add_Label("LabelDef",hVar.tab_string["__Attr_Def"],_linfoX+_tabx+28,_linfoY-42),
		_add_Val("attrDef","num",_linfoX+_tabx+127,_linfoY-35,"0","LC"),
		
		--攻击类型 striking distance type
		_add_Icon("iconStrtype","ICON:icon01_x1y10","normal",_linfoX,_linfoY-70),
		_add_Label("LabelStrtype",hVar.tab_string["__Attr_Strtype"],_linfoX+28,_linfoY-77),
		_add_Val("attrStrtype",hVar.FONTC,_linfoX+128,_linfoY-75,"","LC",24),
		
		--体积
		_add_Icon("iconblock","ICON:icon01_x2y4","normal",_linfoX+_tabx,_linfoY-70),
		_add_Label("Labelblock",hVar.tab_string["__Attr_Block"],_linfoX+_tabx+28,_linfoY-77),
		_add_Val("attrblock","num",_linfoX+_tabx+127,_linfoY-70,"","LC"),
		
		--行动速度
		_add_Icon("iconSpeed","ICON:MOVESPEED","normal",_linfoX,_linfoY-105),
		_add_Label("LabelSpeed",hVar.tab_string["__Attr_Speed"],_linfoX+28,_linfoY-112),
		_add_Val("attrSpeed","num",_linfoX+128,_linfoY-108,"0","LC"),
		
		
		--移动范围 moving range
		_add_Icon("iconRange","ICON:MOVERANGE","normal",_linfoX+_tabx,_linfoY-105),
		_add_Label("LabelRange",hVar.tab_string["__Attr_MoveRange"],_linfoX+_tabx+28,_linfoY-112),
		_add_Val("attrRange","num",_linfoX+_tabx+127,_linfoY-108,"0","LC"),
	}
	
	hGlobal.UI.UnitInfoFram.childUI["unitAttr"] = hUI.node:new({
		parent = hGlobal.UI.UnitInfoFram.handle._n,
		child = _UnitLabel,
	})
	
	local removelist = {}
	hGlobal.event:listen("LocalEvent_ShowUnitInfoFram","__show_unitFram",function(oUnit,oUnitID,x,y)
		hGlobal.UI.SkillInfoFram:show(0)
		for i = 1,#removelist do
			hApi.safeRemoveT(hGlobal.UI.UnitInfoFram.childUI,removelist[i])
		end
		removelist = {}
		--根据技能创建技能图标
		local utype = hVar.tab_unit[oUnitID].type
		local UA = hVar.tab_unit[oUnitID].attr
		local CurHp = UA.hp
		local CurMp = UA.mp
		local CurAttack1,CurAttack2 = UA.attack[4] or 0,UA.attack[5] or 0
		local CurDef = UA.def or 0
		if utype == 2 and oUnit then
			local oHero = oUnit:gethero()
			if oHero.data.id==oUnitID then
				CurHp = oHero.attr.mxhp
				CurMp = oHero.attr.mxmp
				CurAttack1 = oHero.attr.minAtk
				CurAttack2 = oHero.attr.maxAtk
				CurDef = oHero.attr.def
			else
				local cHero = oHero:getteammemberbyid(oUnitID)
				if cHero then
					CurHp = cHero.attr.mxhp
					CurMp = cHero.attr.mxmp
					UA = hVar.tab_unit[cHero.data.id].attr
					CurAttack1,CurAttack2 = cHero.attr.minAtk,cHero.attr.maxAtk
					CurDef = cHero.attr.def
				end
			end
		end
		local block = hVar.tab_unit[oUnitID].block or 1
		local U_skill = UA.skill or {}
		
		local tempY = 0
		local name = "nil"
		if #U_skill > 0 then
			for i = 1,#U_skill do
				if hVar.tab_skill[U_skill[i][1]].uihide ~= 1 then
					hGlobal.UI.UnitInfoFram.childUI["skill_icon_"..i] = hUI.image:new({
						parent = hGlobal.UI.UnitInfoFram.handle._n,
						model = hVar.tab_skill[U_skill[i][1]].icon,
						animation = "normal",
						x = 28,
						y = -325-(i-1)*35-tempY*18,
						align = "LT",
						w = 32,
					})
					removelist[#removelist+1] = "skill_icon_"..i
					
					if hVar.tab_stringS[U_skill[i][1]] then
						if hVar.tab_stringS[U_skill[i][1]][2] then
							name = hVar.tab_stringS[U_skill[i][1]][1].." :  "..hVar.tab_stringS[U_skill[i][1]][2]
						elseif hVar.tab_stringS[U_skill[i][1]][1] then
							name = hVar.tab_stringS[U_skill[i][1]][1]
						else
							name = "skill_"..tonumber(U_skill[i][1])
						end
					else
						name = hVar.tab_skill[U_skill[i][1]].name
					end
					
					hGlobal.UI.UnitInfoFram.childUI["skill_name_"..i] =  hUI.label:new({
						parent = hGlobal.UI.UnitInfoFram.handle._n,
						text = name,
						size = 22,
						font = hVar.FONTC,
						x = 58,
						y = -315-(i-1)*35-tempY*18,
						align = "LT",
						border = 1,
						width = 380,
					})
					removelist[#removelist+1] = "skill_name_"..i
					
					if tempY < math.ceil(string.len(name)/52) -1 then
						tempY = math.ceil(string.len(name)/52) -1
					end
					
				end
			end
		end
		--图标
		hGlobal.UI.UnitInfoFram.childUI["unitInfoImage"] = hUI.thumbImage:new({
			parent = hGlobal.UI.UnitInfoFram.handle._n,
			id = oUnitID,
			facing = 180,
			x = 45,
			y = -85,
			w = 64,
			h = 64,
		})
		removelist[#removelist+1] = "unitInfoImage"
		--名字和说明
		hGlobal.UI.UnitInfoFram.childUI["unitnameLab"] = hUI.label:new({
			parent = hGlobal.UI.UnitInfoFram.handle._n,
			size = 28,
			align = "MC",
			font = hVar.FONTC,
			x = 235,
			y =-35,
			width = 310,
			RGB = {255,255,0},
			text = hVar.tab_stringU[oUnitID][1],
			border = 1,
		})
		removelist[#removelist+1] = "unitnameLab"
		
		hGlobal.UI.UnitInfoFram.childUI["unitInfoLab"] = hUI.label:new({
			parent = hGlobal.UI.UnitInfoFram.handle._n,
			size = 28,
			align = "LT",
			font = hVar.FONTC,
			x = 95,
			y =-50,
			width = 350,
			text = hVar.tab_stringU[oUnitID][2],
			border = 1,
		})
		removelist[#removelist+1] = "unitInfoLab"
		--设置生命值和法力值
		hGlobal.UI.UnitInfoFram.childUI["unitAttr"].childUI["attrHp"]:setText(CurHp or 0)
		hGlobal.UI.UnitInfoFram.childUI["unitAttr"].childUI["attrMp"]:setText(CurMp or 0)
		--设置单位攻击力
		hGlobal.UI.UnitInfoFram.childUI["unitAttr"].childUI["attrAtk"]:setText(CurAttack1.." - "..CurAttack2)
		--设置单位防御力
		hGlobal.UI.UnitInfoFram.childUI["unitAttr"].childUI["attrDef"]:setText(CurDef)
		--攻击类型
		local _,attackType = hApi.GetUnitAttackTypeById(oUnitID)
		hGlobal.UI.UnitInfoFram.childUI["unitAttr"].childUI["attrStrtype"]:setText(attackType)
		--体积
		hGlobal.UI.UnitInfoFram.childUI["unitAttr"].childUI["attrblock"]:setText(block)
		--行动速度
		hGlobal.UI.UnitInfoFram.childUI["unitAttr"].childUI["attrSpeed"]:setText(UA.activity)
		--移动距离
		hGlobal.UI.UnitInfoFram.childUI["unitAttr"].childUI["attrRange"]:setText(UA.move)
		hGlobal.UI.UnitInfoFram:setXY(x,y)
		hGlobal.UI.UnitInfoFram:show(1)
		hGlobal.UI.UnitInfoFram:active()
	end)
end