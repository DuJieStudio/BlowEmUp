--------------------------------
-- 加载英雄头像/英雄复活
--------------------------------
local __HUI__ActivedBtn = {}
local heroReliveEx = {}
local __HUI__EnableSwitch = 0
local __HUI__ChoosedHero = {}


--绘制大菠萝血条
local function ShowHeroHpBar(oHero)
	local w = hGlobal.WORLD.LastWorldMap
	if w then
		if w.data.map == hVar.LoginMap then
			return
		end
		if w.data.map == hVar.MainBase then
			return
		end
	end
	
	--local _frm = oHero.heroUI["btnIcon"]
	local _frm = hGlobal.UI.HeroFrame
	local WIDTH = 460
	local HEIGHT = 40
	local _PosX = 250 - 25
	local _PosY = -605
	if (g_phone_mode == 1) then --iPhone4
		--
	elseif (g_phone_mode == 2) then --iPhone5
		--
	elseif (g_phone_mode == 3) then --iphone6
		_PosX = 360 - 25
		_PosY = -560
	elseif (g_phone_mode == 4) then --iphoneX
		_PosX = 510 - 25
		_PosY = -560
	end
	
	--竖屏不绘制
	if (hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.VERTICAL) then
		_PosX = 64
		_PosY = -hVar.SCREEN.h + 160 + hVar.SCREEN.battleUI_offy
	end
	
	--删除上一次的
	if oHero.heroUI["hpBar_back"] then
		oHero.heroUI["hpBar_back"]:del()
		oHero.heroUI["hpBar_back"] = nil
	end
	if oHero.heroUI["hpBar_green"] then
		oHero.heroUI["hpBar_green"]:del()
		oHero.heroUI["hpBar_green"] = nil
	end
	if oHero.heroUI["hpBar_green_right"] then
		oHero.heroUI["hpBar_green_right"]:del()
		oHero.heroUI["hpBar_green_right"] = nil
	end
	if oHero.heroUI["hpBar_yellow"] then
		oHero.heroUI["hpBar_yellow"]:del()
		oHero.heroUI["hpBar_yellow"] = nil
	end
	if oHero.heroUI["hpBar_yellow_right"] then
		oHero.heroUI["hpBar_yellow_right"]:del()
		oHero.heroUI["hpBar_yellow_right"] = nil
	end
	--[[
	if oHero.heroUI["hpBar_orange"] then
		oHero.heroUI["hpBar_orange"]:del()
		oHero.heroUI["hpBar_orange"] = nil
	end
	if oHero.heroUI["hpBar_orange_right"] then
		oHero.heroUI["hpBar_orange_right"]:del()
		oHero.heroUI["hpBar_orange_right"] = nil
	end
	]]
	if oHero.heroUI["hpBar_red"] then
		oHero.heroUI["hpBar_red"]:del()
		oHero.heroUI["hpBar_red"] = nil
	end
	if oHero.heroUI["hpBar_red_right"] then
		oHero.heroUI["hpBar_red_right"]:del()
		oHero.heroUI["hpBar_red_right"] = nil
	end
	--[[
	if oHero.heroUI["hpBar_front"] then
		oHero.heroUI["hpBar_front"]:del()
		oHero.heroUI["hpBar_front"] = nil
	end
	]]
	
	--竖屏不绘制
	--if hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.VERTICAL then
	--	return
	--end
	
	--存储血条进度
	oHero.data.hp_precent = 100
	
	--血条底图
	oHero.heroUI["hpBar_back"] = hUI.image:new({
		parent = _frm.handle._n,
		x = _PosX + WIDTH/ 2 + 26,
		y = _PosY,
		w = 512,
		h = 128,
		model = "misc/hpbar/hpbar_back.png",
	})
	--oHero.heroUI["hpBar_back"].handle.s:setOpacity(96)
	
	--血条-绿
	oHero.heroUI["hpBar_green"] = hUI.valbar:new({
		parent = _frm.handle._n,
		x = _PosX + 42,
		y = _PosY,
		--w = 512,
		--h = 128,
		model = "UI:hpbar_green",
		--model = "misc/progress.png",
		--back = {model = "misc/hpbar/hpbar_back.png",x=0,y=0,w=WIDTH,h=HEIGHT},
		v = 100,
		max = 100,
	})
	--oHero.heroUI["hpBar_green"].handle.s:setColor(ccc3(255, 0, 0)) --测试 --test
	
	--[[
	--血条-绿的右边
	oHero.heroUI["hpBar_green_right"] = hUI.image:new({
		parent = _frm.handle._n,
		x = _PosX,
		y = _PosY,
		w = 56,
		h = 23,
		model = "misc/hpbar/hpbar_green_right.png",
	})
	oHero.heroUI["hpBar_green_right"].handle.s:setVisible(false) --默认不显示
	]]
	
	--血条-黄
	oHero.heroUI["hpBar_yellow"] = hUI.valbar:new({
		parent = _frm.handle._n,
		x = _PosX + 42,
		y = _PosY,
		--w = 512,
		--h = 128,
		model = "UI:hpbar_yellow",
		--model = "misc/progress.png",
		--back = {model = "misc/hpbar/hpbar_back.png",x=0,y=0,w=WIDTH,h=HEIGHT},
		v = 50,
		max = 100,
	})
	--oHero.heroUI["hpBar_yellow"].handle.s:setColor(ccc3(255, 0, 0)) --测试 --test
	oHero.heroUI["hpBar_yellow"].handle.s:setVisible(false) --默认不显示
	
	--[[
	--血条-黄的右边
	oHero.heroUI["hpBar_yellow_right"] = hUI.image:new({
		parent = _frm.handle._n,
		x = _PosX,
		y = _PosY,
		w = 56,
		h = 23,
		model = "misc/hpbar/hpbar_yellow_right.png",
	})
	oHero.heroUI["hpBar_yellow_right"].handle.s:setVisible(false) --默认不显示
	]]
	
	--[[
	--血条-橙
	oHero.heroUI["hpBar_orange"] = hUI.valbar:new({
		parent = _frm.handle._n,
		x = _PosX,
		y = _PosY,
		w = WIDTH,
		h = HEIGHT,
		model = "misc/hpbar/hpbar_orange.png",
		--model = "misc/progress.png",
		--back = {model = "misc/hpbar/hpbar_back.png",x=0,y=0,w=WIDTH,h=HEIGHT},
		v = 50,
		max = 100,
	})
	oHero.heroUI["hpBar_orange"].handle.s:setVisible(false) --默认不显示
	
	--血条-橙的右边
	oHero.heroUI["hpBar_orange_right"] = hUI.image:new({
		parent = _frm.handle._n,
		x = _PosX,
		y = _PosY,
		w = 56,
		h = 28,
		model = "misc/hpbar/hpbar_orange_right.png",
	})
	oHero.heroUI["hpBar_orange_right"].handle.s:setVisible(false) --默认不显示
	]]
	
	--血条-红
	oHero.heroUI["hpBar_red"] = hUI.valbar:new({
		parent = _frm.handle._n,
		x = _PosX + 42,
		y = _PosY,
		--w = 512,
		--h = 128,
		model = "UI:hpbar_red",
		--model = "misc/progress.png",
		--back = {model = "misc/hpbar/hpbar_back.png",x=0,y=0,w=WIDTH,h=HEIGHT},
		v = 50,
		max = 100,
	})
	oHero.heroUI["hpBar_red"].handle.s:setVisible(false) --默认不显示
	
	--[[
	--血条-红的右边
	oHero.heroUI["hpBar_red_right"] = hUI.image:new({
		parent = _frm.handle._n,
		x = _PosX,
		y = _PosY,
		w = 56,
		h = 23,
		model = "misc/hpbar/hpbar_red_right.png",
	})
	oHero.heroUI["hpBar_red_right"].handle.s:setVisible(false) --默认不显示
	]]
	
	--[[
	--血条前图
	oHero.heroUI["hpBar_front"] = hUI.image:new({
		parent = _frm.handle._n,
		x = _PosX + WIDTH/ 2,
		y = _PosY,
		--y = _PosY + 100, --测试 --test
		w = WIDTH,
		h = HEIGHT,
		model = "misc/hpbar/hpbar_front.png",
	})
	]]
	
	--触发事件
	--hGlobal.event:event("Event_UnitTankHpBarCreate", oHero)
	print("Event_UnitTankHpBarCreate")
end

--单次设置血量
local __SingleSetHeroHpBarPercent = function(oHero, hp, hpMax)
	--local _frm = oHero.heroUI["btnIcon"]
	local _frm = hGlobal.UI.HeroFrame
	local WIDTH = 460
	local HEIGHT = 40
	local _PosX = 250
	local _PosY = -605
	if (g_phone_mode == 2) then --iPhone5
		_PosX = 305
		_PosY = -475
	elseif (g_phone_mode == 3) then --iphone8
		_PosX = 360
			_PosY = -560
	elseif (g_phone_mode == 4) then --iphoneX
		_PosX = 510
			_PosY = -560
	end
	
	local PERCENT_GREEN = 70
	local PRECENT_YELLOW = 30
	--local PRECENT_ORANGE = 25
	local PRECENT_RED = 0
	
	--当前比例
	local precent = math.ceil(hp / hpMax * 100)
	local fp = precent / 100
	
	--存储当前血量进度
	oHero.data.hp_precent = precent
	
	--[[
	--print(fp)
	if (precent == 100) then --绿色
		oHero.heroUI["hpBar_green"].handle._n:setVisible(true) --蓝
		oHero.heroUI["hpBar_yellow"].handle._n:setVisible(false) --黄
		--oHero.heroUI["hpBar_orange"].handle._n:setVisible(false) --橙
		oHero.heroUI["hpBar_red"].handle._n:setVisible(false) --红
		oHero.heroUI["hpBar_green_right"].handle._n:setVisible(false) --蓝右边
		oHero.heroUI["hpBar_yellow_right"].handle._n:setVisible(false) --黄右边
		--oHero.heroUI["hpBar_orange_right"].handle._n:setVisible(false) --橙右边
		oHero.heroUI["hpBar_red_right"].handle._n:setVisible(false) --红右边
		
		oHero.heroUI["hpBar_green"]:setV(100, 100)
	elseif (precent >= PERCENT_FULL) then --绿色
		oHero.heroUI["hpBar_green"].handle._n:setVisible(true) --蓝
		oHero.heroUI["hpBar_yellow"].handle._n:setVisible(false) --黄
		--oHero.heroUI["hpBar_orange"].handle._n:setVisible(false) --橙
		oHero.heroUI["hpBar_red"].handle._n:setVisible(false) --红
		oHero.heroUI["hpBar_green_right"].handle._n:setVisible(true) --蓝右边
		oHero.heroUI["hpBar_yellow_right"].handle._n:setVisible(false) --黄右边
		--oHero.heroUI["hpBar_orange_right"].handle._n:setVisible(false) --橙右边
		oHero.heroUI["hpBar_red_right"].handle._n:setVisible(false) --红右边
		
		fp = percent90_fp[precent - 89]
		oHero.heroUI["hpBar_green"]:setV(fp * 100, 100)
		--100, 5
		--75, -87
		oHero.heroUI["hpBar_green_right"]:setXY(_PosX + WIDTH + percent90_fpright[precent - 89] + fp * 100, _PosY + 0)
	elseif (precent >= PERCENT_GREEN) then --绿色
		oHero.heroUI["hpBar_green"].handle._n:setVisible(true) --蓝
		oHero.heroUI["hpBar_yellow"].handle._n:setVisible(false) --黄
		--oHero.heroUI["hpBar_orange"].handle._n:setVisible(false) --橙
		oHero.heroUI["hpBar_red"].handle._n:setVisible(false) --红
		oHero.heroUI["hpBar_green_right"].handle._n:setVisible(true) --蓝右边
		oHero.heroUI["hpBar_yellow_right"].handle._n:setVisible(false) --黄右边
		--oHero.heroUI["hpBar_orange_right"].handle._n:setVisible(false) --橙右边
		oHero.heroUI["hpBar_red_right"].handle._n:setVisible(false) --红右边
		
		fp = fp - 0.05
		oHero.heroUI["hpBar_green"]:setV(fp * 100, 100)
		--100, 5
		--75, -87
		oHero.heroUI["hpBar_green_right"]:setXY(_PosX - 14 + math.floor((WIDTH - 20) * (0.1 + fp)) + fp * 70, _PosY + 0)
	elseif (precent >= PRECENT_YELLOW) then --黄色
		oHero.heroUI["hpBar_green"].handle._n:setVisible(false) --蓝
		oHero.heroUI["hpBar_yellow"].handle._n:setVisible(true) --黄
		--oHero.heroUI["hpBar_orange"].handle._n:setVisible(false) --橙
		oHero.heroUI["hpBar_red"].handle._n:setVisible(false) --红
		
		oHero.heroUI["hpBar_green_right"].handle._n:setVisible(false) --蓝右边
		oHero.heroUI["hpBar_yellow_right"].handle._n:setVisible(true) --黄右边
		--oHero.heroUI["hpBar_orange_right"].handle._n:setVisible(false) --橙右边
		oHero.heroUI["hpBar_red_right"].handle._n:setVisible(false) --红右边
		
		fp = fp - 0.04
		oHero.heroUI["hpBar_yellow"]:setV(fp * 100, 100)
		oHero.heroUI["hpBar_yellow_right"]:setXY(_PosX + 20 + math.floor((WIDTH - 20) * (0.052 + fp)), _PosY + 0)
	elseif (precent >= PRECENT_RED) then --红色
		oHero.heroUI["hpBar_green"].handle._n:setVisible(false) --蓝
		oHero.heroUI["hpBar_yellow"].handle._n:setVisible(false) --黄
		--oHero.heroUI["hpBar_orange"].handle._n:setVisible(false) --橙
		oHero.heroUI["hpBar_red"].handle._n:setVisible(true) --红
		
		oHero.heroUI["hpBar_green_right"].handle._n:setVisible(false) --蓝右边
		oHero.heroUI["hpBar_yellow_right"].handle._n:setVisible(false) --黄右边
		--oHero.heroUI["hpBar_orange_right"].handle._n:setVisible(false) --橙右边
		if (precent >= 15) then
			oHero.heroUI["hpBar_red_right"].handle._n:setVisible(true) --红右边
			
			fp = fp
			oHero.heroUI["hpBar_red"]:setV(fp * 100, 100)
			oHero.heroUI["hpBar_red_right"]:setXY(_PosX + 27 + math.floor((WIDTH - 20) * (0.028 + fp)), _PosY + 0)
		elseif (precent >= 2) then
			fp = fp / 4 + 0.13
			oHero.heroUI["hpBar_red_right"].handle._n:setVisible(false) --红右边
			oHero.heroUI["hpBar_red"]:setV(fp * 100, 100)
		elseif (precent > 0) then
			oHero.heroUI["hpBar_red"]:setV(13.2, 100)
		else
			oHero.heroUI["hpBar_red"]:setV(0, 100)
		end
	end
	]]
	if (precent >= PERCENT_GREEN) then --绿色
		oHero.heroUI["hpBar_green"].handle._n:setVisible(true) --蓝
		oHero.heroUI["hpBar_yellow"].handle._n:setVisible(false) --黄
		--oHero.heroUI["hpBar_orange"].handle._n:setVisible(false) --橙
		oHero.heroUI["hpBar_red"].handle._n:setVisible(false) --红
		--oHero.heroUI["hpBar_green_right"].handle._n:setVisible(false) --蓝右边
		--oHero.heroUI["hpBar_yellow_right"].handle._n:setVisible(false) --黄右边
		--oHero.heroUI["hpBar_orange_right"].handle._n:setVisible(false) --橙右边
		--oHero.heroUI["hpBar_red_right"].handle._n:setVisible(false) --红右边
		
		oHero.heroUI["hpBar_green"]:setV(fp * 100, 100)
	elseif (precent >= PRECENT_YELLOW) then --黄色
		oHero.heroUI["hpBar_green"].handle._n:setVisible(false) --蓝
		oHero.heroUI["hpBar_yellow"].handle._n:setVisible(true) --黄
		--oHero.heroUI["hpBar_orange"].handle._n:setVisible(false) --橙
		oHero.heroUI["hpBar_red"].handle._n:setVisible(false) --红
		
		--oHero.heroUI["hpBar_green_right"].handle._n:setVisible(false) --蓝右边
		--oHero.heroUI["hpBar_yellow_right"].handle._n:setVisible(false) --黄右边
		--oHero.heroUI["hpBar_orange_right"].handle._n:setVisible(false) --橙右边
		--oHero.heroUI["hpBar_red_right"].handle._n:setVisible(false) --红右边
		
		oHero.heroUI["hpBar_yellow"]:setV(fp * 100, 100)
	elseif (precent >= PRECENT_RED) then --红色
		oHero.heroUI["hpBar_green"].handle._n:setVisible(false) --蓝
		oHero.heroUI["hpBar_yellow"].handle._n:setVisible(false) --黄
		--oHero.heroUI["hpBar_orange"].handle._n:setVisible(false) --橙
		oHero.heroUI["hpBar_red"].handle._n:setVisible(true) --红
		
		--oHero.heroUI["hpBar_green_right"].handle._n:setVisible(false) --蓝右边
		--oHero.heroUI["hpBar_yellow_right"].handle._n:setVisible(false) --黄右边
		--oHero.heroUI["hpBar_orange_right"].handle._n:setVisible(false) --橙右边
		
		if (fp < 0.12) and (fp > 0) then
			fp = 0.12
		end
		oHero.heroUI["hpBar_red"]:setV(fp * 100, 100)
	end
end

--设置血量
function SetHeroHpBarPercent(oHero, hp, hpMax, bPlayAction)
	local oldPercent = oHero.data.hp_precent
	local precent = math.ceil(hp / hpMax * 100)
	
	if (precent ~= oldPercent) then --不重复设置
		if oHero.heroUI["hpBar_green"] then
			 --先停掉之前可能的动画
			oHero.heroUI["hpBar_green"].handle.s:stopAllActions()
			
			if bPlayAction then
				--动画
				local deltahp = precent - oldPercent
				local timesum = 0.3
				
				if (deltahp > 0) then --血量增加
					local t = timesum / deltahp
					local a = CCArray:create()
					for p = oldPercent, precent, 1 do
						local act1 = CCDelayTime:create(t)
						local act2 = CCCallFunc:create(function()
							__SingleSetHeroHpBarPercent(oHero, p, 100)
						end)
						a:addObject(act1)
						a:addObject(act2)
					end
					local sequence = CCSequence:create(a)
					local ease = CCEaseSineInOut:create(sequence)
					oHero.heroUI["hpBar_green"].handle.s:runAction(ease)
				else --血量降低
					local t = timesum / (-deltahp)
					local a = CCArray:create()
					for p = oldPercent, precent, -1 do
						local act1 = CCDelayTime:create(t)
						local act2 = CCCallFunc:create(function()
							__SingleSetHeroHpBarPercent(oHero, p, 100)
						end)
						a:addObject(act1)
						a:addObject(act2)
					end
					local sequence = CCSequence:create(a)
					local ease = CCEaseSineInOut:create(sequence)
					oHero.heroUI["hpBar_green"].handle.s:runAction(ease)
				end
			else
				__SingleSetHeroHpBarPercent(oHero, hp, hpMax)
			end
		end
	end
end




--返回最后选择的英雄对象
hApi.GetLocalHero = function(mode)
	if mode=="choosed" then
		if __HUI__EnableSwitch~=1 then
			return
		end
		local oHero = hApi.GetObjectEx(hClass.hero,__HUI__ChoosedHero)
		local w = hGlobal.WORLD.LastWorldMap
		if w then
			local me = w:GetPlayerMe()
			if oHero and me and oHero:getowner()==me then
				return oHero
			end
		end
	end
end

hGlobal.UI.InitHeroUI = function()
	
	local _frm = hGlobal.UI.HeroFrame
	
	if hGlobal.UI.HeroFrame~=nil then
		_frm.childUI["dragBox"]:sortbutton()
	else
		--这个东西禁止加载两次,也禁止删除
		hGlobal.UI.HeroFrame = hUI.frame:new({
			x = 40,
			y = hVar.SCREEN.h - 105,
			z = -2,
			w = 1,
			h = 1,
			buttononly = 1,
			dragable = 2,
			background = 0,
			show = 0,
		})
		_frm = hGlobal.UI.HeroFrame
	end

	hGlobal.event:listen("LocalEvent_PlayerFocusWorld","__UI__ShowHeroFrame",function(sSceneType,oWorld,oMap)
		if sSceneType=="worldmap" then
			__HUI__EnableSwitch = 1
			_frm:show(1)
		else
			__HUI__EnableSwitch = 0
			_frm:show(0)
		end
	end)

	--local btnGridH = 90
	--local function _calBtnY(n)
	--	return -1*btnGridH*(n-1)
	--end
	
	local _RefreshCanHireHero = function()
		local mapname = hGlobal.WORLD.LastWorldMap.data.map
		if hApi.Is_YXWD_Map(mapname) ~= -1 then
			local templ = {5000,5001,5002,5003,5006,5007,5008,5011,5012,5014,5016,5017,5019,5023,5024,5025,5026,5029,5030,5032,5033,5024,5034,5004,5005,5021,6085}
			local heroID = {}
			local b = {}
			for j = 1,#templ do
				b[j] = 0
			end
			hClass.hero:enum(function(oHero)
				for j = 1,#templ do
					if oHero.data.id == templ[j] then
						b[j] = 1
					end
				end
			end)
			for j = 1,#templ do
				if b[j] == 0 then
					heroID[#heroID+1] = templ[j]
				end
			end
			heroReliveEx = {}
			for i = 1,#heroID do
				if heroID[i] ~= Hid then
					if LuaCheckUnitIDInHeroCard(heroID[i]) == 1 then
						heroReliveEx[#heroReliveEx+1] = heroID[i]
					end
				end
			end
		end
	end
	
--	local _RefreshHeroMovePointBar = function(oHero)
--		if oHero.heroUI["movepoint"]~=nil then
--			local oUnit = oHero:getunit("worldmap")
--			if oUnit~=nil then
--				local curP = hApi.chaGetMovePoint(oUnit.handle)
--				local maxP = hApi.chaGetMaxMovePoint(oUnit.handle)
--				oHero.heroUI["movepoint"]:setV(curP,maxP)
--			else
--				oHero.heroUI["movepoint"]:setV(0,100)
--				if oHero.heroUI["btnIcon"].handle.s then 
--					oHero.heroUI["btnIcon"].handle.s:setColor(ccc3(127,127,127))
--				end
--			end
--		end	
--	end
	
	--刷新本地英雄头像的血条
	local _RefreshHeroHpBar = function(oHero)
		hGlobal.event:event("LocalEvent_UpdateTankHp",oHero)
		if oHero.heroUI["hpBar_green"]~=nil then
			local oUnit = oHero:getunit("worldmap")
			if oUnit~=nil then
				local curP = oUnit.attr.hp
				local maxP = oUnit:GetHpMax()
				local precent = math.ceil(curP / maxP * 100)
				--print("precent=", precent)
				
				--设置大菠萝的血条
				SetHeroHpBarPercent(oHero, curP, maxP, true)
			else
				--设置大菠萝的血条
				SetHeroHpBarPercent(oHero, 0, 100)
				
				if oHero.heroUI["btnIcon"].handle.s then 
					oHero.heroUI["btnIcon"].handle.s:setColor(ccc3(127,127,127))
				end
			end
		end	
	end
	
	--刷新单个英雄的移动力条子
	--hGlobal.event:listen("LocalEvent_HeroMovePointUpdate","__update__",function(oHero)
	--	_RefreshHeroMovePointBar(oHero)
	--end)
	
	--一天结束后刷新所有英雄的移动力条子
	--hGlobal.event:listen("Event_NewDay","__RefreshHeroMovePoint__",function(nDayCount)
	--	hClass.hero:enum(_RefreshHeroMovePointBar)
	--end)
	
	--从新读档后的刷新英雄行动力条子
	--hGlobal.event:listen("Event_WorldCreated","__reload_RefreshHeroMovePoint",function(oWorld,IsCreatedFromLoad)
	--	if oWorld.data.type=="worldmap" then
	--		xlSetTouchEnabled(true)
	--		hUI.Disable(0,"AI")
	--		hClass.hero:enum(_RefreshHeroMovePointBar)
	--	end
	--end)
	
	--移动时刷新行动力条子
	--hGlobal.event:listen("Event_UnitStepMove","__UI__RefreshHeroMovePoint",function(oWorld,oUnit,worldX,worldY)
	--	local oHero = oUnit:gethero()
	--	if oHero and oHero.heroUI["movepoint"]~=nil then
	--		oHero.heroUI["movepoint"]:setV(hApi.chaGetMovePoint(oUnit.handle),hApi.chaGetMaxMovePoint(oUnit.handle))
	--	end
	--end)
	
	--移动时刷新行动力条子
	--hGlobal.event:listen("Event_UnitArrive","__UI__RefreshHeroMovePoint",function(oWorld,oUnit,gridX,gridY,oTarget,nOperate,nOperateId)
	--	if oWorld.data.type=="worldmap" then
	--		local oHero = oUnit:gethero()
	--		if oHero and oHero.heroUI["movepoint"]~=nil then
	--			oHero.heroUI["movepoint"]:setV(hApi.chaGetMovePoint(oUnit.handle),hApi.chaGetMaxMovePoint(oUnit.handle))
	--		end
	--	end
	--end)
	
	--英雄死亡提示面板
	local HeroDeadFrm = hUI.frame:new({
		x = 270,
		y = 660,
		dragable = 0,
		show = 0,
		z = 101,
		background = "UI:PANEL_INFO_MINI",
	})
	
	HeroDeadFrm.childUI["tipText"] = hUI.label:new({
		parent = HeroDeadFrm.handle._n,
		size = 28,
		align = "LT",
		font = hVar.FONTC,
		border = 1,
		x = 50,
		y = -30,
		width = 300,
		text = hVar.tab_string["__TEXT_RenewHero_Text"],
	})
	
	HeroDeadFrm.childUI["OKbtn"] = hUI.button:new({
		parent = HeroDeadFrm.handle._n,
		model = "UI:ButtonBack2",
		label = hVar.tab_string["__TEXT_Confirm"],
		font = hVar.FONTC,
		border = 1,
		dragbox = HeroDeadFrm.childUI["dragBox"],
		x = HeroDeadFrm.data.w/2-10,
		y = -1*(HeroDeadFrm.data.h-60),
		scale = 0.8,
		scaleT = 0.9,
		code = function(self)
			HeroDeadFrm:show(0)
		end,
	})
	
	local _code_IsAssistHero = function(oHero)
		--如果加入了我方英雄的队伍，那么视为副将
		if oHero.data.HeroTeamLeader~=0 then
			local oHeroL = hClass.hero:find(oHero.data.HeroTeamLeader)
			if oHeroL and oHeroL.data.owner==oHero.data.owner then
				return hVar.RESULT_SUCESS
			end
		end
		return hVar.RESULT_FAIL
	end
	
	local _HeroLocalUI = {
		UI_KEY = {"movepoint","option","btnIcon"},
		clearUI = function(self,oHero)
			for i = 1,#self.UI_KEY do
				hApi.safeRemoveT(oHero.heroUI,self.UI_KEY[i])
			end
		end,
		choosehero = function(self, oHero)
			local oBtnL = hApi.GetObjectEx(hUI.button, __HUI__ActivedBtn)
			--print(oHero, oBtnL)
			if (oHero == nil) then
				--print("choosehero")
				if oBtnL then
					oBtnL.childUI["flag"].handle.s:setVisible(false)
					oBtnL.childUI["SelectBorder"].handle._n:setVisible(false)
				end
				hApi.SetObjectEx(__HUI__ChoosedHero,nil)
				hApi.SetObjectEx(__HUI__ActivedBtn,nil)
				return 0
			else
				local oBtn = oHero.heroUI["btnIcon"]
				if (oBtn ~= oBtnL) then
					--print("隐藏上一次")
					--隐藏上一次
					if oBtnL then
						oBtnL.childUI["flag"].handle.s:setVisible(false)
						oBtnL.childUI["SelectBorder"].handle._n:setVisible(false)
					end
					
					--pvp模式，隐藏可能选中的头像栏的复活按钮
					local w = hGlobal.WORLD.LastWorldMap
					for i = 1, #(w:GetPlayerMe().heros), 1 do
						local oHero = w:GetPlayerMe().heros[i]
						if oHero then
							if oHero.heroUI["pvp_rebirth_btn_yes"] then
								oHero.heroUI["pvp_rebirth_btn_yes"]:setstate(-1) --不显示
							end
						end
					end
					
					--显示本次的
					hApi.SetObjectEx(__HUI__ChoosedHero,oHero)
					hApi.SetObjectEx(__HUI__ActivedBtn,oBtn)
					--oBtn.childUI["flag"].handle.s:setVisible(true) --zhenkira
					oBtn.childUI["flag"].handle.s:setVisible(false)
					oBtn.childUI["SelectBorder"].handle._n:setVisible(true)
					return 1
				else
					return 0
				end
			end
		end,
		
		sortBtn = function(self,oPlayer)
			local n = #oPlayer.heros
			_frm.childUI["dragBox"]:sortbutton()
			local tBtnPos = {}
			local tHero = {}
			for i = 1, n, 1 do
				local oHero = oPlayer.heros[i]
				if type(oHero)=="table" and oHero.heroUI["btnIcon"]~=nil then
					tBtnPos[oHero.ID] = {0,0,0,0}	--x,y,nTeamMember,nIndexInTeam
					tHero[#tHero+1] = oHero
				end
			end
			for i = 1,#tHero do
				local oHero = tHero[i]
				local v = tBtnPos[oHero.ID]
				local nTeamMemberCount = 0
				if type(oHero.data.HeroTeam)=="table" then
					local nIndexInTeam = 0
					for x = 1,#oHero.data.HeroTeam do
						local t = oHero.data.HeroTeam[x]
						if t~=0 and tBtnPos[t[1]] then
							v[3] = v[3] + 1
							nIndexInTeam = nIndexInTeam + 1
							tBtnPos[t[1]][4] = nIndexInTeam
						end
					end
				end
			end
			local nCurBtnY = 0
			for i = 1, #tHero, 1 do
				local oHero = tHero[i]
				local v = tBtnPos[oHero.ID]
				if _code_IsAssistHero(oHero)==hVar.RESULT_FAIL then
					v[1] = 0
					v[2] = nCurBtnY
					--nCurBtnY = nCurBtnY-64-28-v[3]*(48+8)
					nCurBtnY = nCurBtnY-56-12-v[3]*(48+8)
					if v[3]>0 then
						nCurBtnY = nCurBtnY - 8
					end
				end
			end
			for i = 1, #tHero, 1 do
				local oHero = tHero[i]
				local v = tBtnPos[oHero.ID]
				if _code_IsAssistHero(oHero)==hVar.RESULT_SUCESS then
					--队员模式
					local nIndexInTeam = v[4]
					local tPosL = tBtnPos[oHero.data.HeroTeamLeader]
					if tPosL and nIndexInTeam~=0 then
						local btnX = tPosL[1]+10
						local btnY = tPosL[2]-nIndexInTeam*(48+8)-10
						if oHero.heroUI["btnIcon"] then
							oHero.heroUI["btnIcon"]:setXY(btnX,btnY)
						end
						--[[
						if oHero.heroUI["movepoint"] then
							oHero.heroUI["movepoint"].handle._n:setVisible(false)
						end
						]]
						--if oHero.heroUI["hpBar"] then
						--	oHero.heroUI["hpBar"].handle._n:setVisible(false)
						--end
					end
				else
					local btnX = v[1]
					local btnY = v[2]
					
					--print("btnX", btnX, btnY)
					
					if (g_phone_mode == 0) then --平板模式
						btnX = btnX + 0 - 200 --大菠萝不显示头像
						btnY = btnY - 20 - (i - 1) * 5
						
						if oHero.heroUI["btnIcon"] then
							oHero.heroUI["btnIcon"]:setXY(btnX, btnY)
						end
						if oHero.heroUI["option"] then
							oHero.heroUI["option"]:setXY(btnX - 1048, btnY)
						end
						--[[
						if oHero.heroUI["movepoint"] then
							oHero.heroUI["movepoint"].handle._n:setPosition(btnX - 32, btnY + 38)
						end
						]]
						
						--[[
						if oHero.heroUI["hpBar_green"] then
							oHero.heroUI["hpBar_green"].handle._n:setPosition(btnX - 28 + 450 + 6,btnY - 37 + 55 - 630) --大菠萝血条
							oHero.heroUI["hpBar_yellow"].handle._n:setPosition(btnX - 28 + 450 + 6 ,btnY - 37 + 55 - 630) --大菠萝血条
							oHero.heroUI["hpBar_orange"].handle._n:setPosition(btnX - 28 + 450 + 6 ,btnY - 37 + 55 - 630) --大菠萝血条
							oHero.heroUI["hpBar_red"].handle._n:setPosition(btnX - 28 + 450 + 6 ,btnY - 37 + 55 - 630) --大菠萝血条
							
							oHero.heroUI["hpBar_back"].handle._n:setPosition(btnX - 28 + 450 + 6 + 460/2,btnY - 37 + 55 - 630) --大菠萝血条
							
							oHero.heroUI["hpBar_front"].handle._n:setPosition(btnX - 28 + 450 + 6 + 460/2,btnY - 37 + 55 - 630) --大菠萝血条
						end
						]]
					else --手机模式
						btnX = btnX + 7 - 200 --大菠萝不显示头像
						btnY = btnY - 27 - (i - 1) * 21
						
						if oHero.heroUI["btnIcon"] then
							oHero.heroUI["btnIcon"]:setXY(btnX, btnY)
						end
						if oHero.heroUI["option"] then
							oHero.heroUI["option"]:setXY(btnX - 1048, btnY)
						end
						--[[
						if oHero.heroUI["movepoint"] then
							oHero.heroUI["movepoint"].handle._n:setPosition(btnX - 32, btnY + 38)
						end
						]]
						--[[
						if oHero.heroUI["hpBar_green"] then
							oHero.heroUI["hpBar_green"].handle._n:setPosition(btnX - 36 + 530 + 5, btnY - 45 + 70 - 500) --大菠萝血条
							oHero.heroUI["hpBar_yellow"].handle._n:setPosition(btnX - 36 + 530 + 5, btnY - 45 + 70 - 500) --大菠萝血条
							oHero.heroUI["hpBar_orange"].handle._n:setPosition(btnX - 36 + 530 + 5, btnY - 45 + 70 - 500) --大菠萝血条
							oHero.heroUI["hpBar_red"].handle._n:setPosition(btnX - 36 + 530 + 5, btnY - 45 + 70 - 500) --大菠萝血条
							
							oHero.heroUI["hpBar_back"].handle._n:setPosition(btnX - 36 + 530 + 5 + 460/2, btnY - 45 + 70 - 500) --大菠萝血条
							
							oHero.heroUI["hpBar_front"].handle._n:setPosition(btnX - 36 + 530 + 5 + 460/2, btnY - 45 + 70 - 500) --大菠萝血条
						end
						]]
					end
					
					--print("更新英雄头像的坐标")
				end
			end
			
			--pvp模式
			local w = hGlobal.WORLD.LastWorldMap
			if w and w.data.tdMapInfo and (w.data.tdMapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then --PVP模式
				--英雄头像主界面挪到左下角
				--local _frm = hGlobal.UI.HeroFrame
				--_frm:setXY(0, 0)
				
				--pvp模式，单独布局
				for i = 1, #tHero, 1 do
					local oHero = tHero[i]
					
					if (g_phone_mode == 0) then --平板模式
						local tPosXList = {40, 120}
						local tPosYList = {140, 50}
						
						local btnX = tPosXList[i]
						local btnY = tPosYList[i]
						
						if oHero.heroUI["btnIcon"] then
							oHero.heroUI["btnIcon"]:setXY(btnX, btnY)
						end
						if oHero.heroUI["option"] then
							oHero.heroUI["option"]:setXY(btnX - 1048, btnY)
						end
						--[[
						if oHero.heroUI["movepoint"] then
							oHero.heroUI["movepoint"].handle._n:setPosition(btnX - 32, btnY + 38)
						end
						]]
						--if oHero.heroUI["hpBar"] then
						--	oHero.heroUI["hpBar"].handle._n:setPosition(btnX - 36 ,btnY - 46)
						--end
						
						--携带装备模式
						if w.data.bUseEquip then
							--英雄的装备
							local equipment = oHero.data.equipment or {}
							local equippos = {1, 2, 4, 3}
							for eq = 1, 4, 1 do
								--[[
								--测试 --test
								if oHero.heroUI["equipBG" .. eq] then
									oHero.heroUI["equipBG" .. eq]:del()
									oHero.heroUI["equipBG" .. eq] = nil
								end
								if oHero.heroUI["equip" .. eq] then
									oHero.heroUI["equip" .. eq]:del()
									oHero.heroUI["equip" .. eq] = nil
								end
								--if oHero.heroUI["equipBan" .. eq] then
								--	oHero.heroUI["equipBan" .. eq]:del()
								--	oHero.heroUI["equipBan" .. eq] = nil
								--end
								if oHero.heroUI["equipEmpty" .. eq] then
									oHero.heroUI["equipEmpty" .. eq]:del()
									oHero.heroUI["equipEmpty" .. eq] = nil
								end
								--
								]]
								
								local itemId = 0
								local equp = equipment[equippos[eq]]
								if (type(equp) == "table") then
									itemId = equp[1]
								end
								
								--绘制道具背景图
								local eq_wh = 20
								local eq_px = eq_wh + 28 - (i - 1) * 96
								local eq_py = -(eq - 1) * (eq_wh + 1) + 27
								
								--存在道具
								if hVar.tab_item[itemId] then
									--装备的品质图片
									if (not oHero.heroUI["equipBG" .. eq]) then
										local itemLv = hVar.tab_item[itemId].itemLv or 1
										local itemModel = hVar.ITEMLEVEL[itemLv].BORDERMODEL --模型
										--if (hVar.tab_item[itemId].isArtifact == 1) then --神器边框换个图
										--	itemModel = "ICON:Back_red2"
										--end
										oHero.heroUI["equipBG" .. eq] = hUI.image:new({
											parent = _frm.handle._n,
											model = itemModel, --"UI:SkillSlot",
											x = btnX + eq_px,
											y = btnY + eq_py,
											w = eq_wh,
											h = eq_wh,
										})
										oHero.heroUI["equipBG" .. eq].handle.s:setOpacity(64)
									end
									
									--绘制道具
									if (not oHero.heroUI["equip" .. eq]) then
										--绘制道具图标
										oHero.heroUI["equip" .. eq] = hUI.image:new({
											parent = _frm.handle._n,
											model = hVar.tab_item[itemId].icon,
											x = btnX + eq_px,
											y = btnY + eq_py,
											w = eq_wh - 2,
											h = eq_wh - 2,
										})
										--默认灰掉
										--hApi.AddShader(oHero.heroUI["equip" .. eq].handle.s, "gray")
										oHero.heroUI["equip" .. eq].handle.s:setOpacity(64)
									end
									
									--[[
									--绘制道具禁用的图标
									if (not oHero.heroUI["equipBan" .. eq]) then
										--绘制道具图标
										oHero.heroUI["equipBan" .. eq] = hUI.image:new({
											parent = _frm.handle._n,
											model = "misc/close.png",
											x = btnX + eq_px,
											y = btnY + eq_py,
											w = eq_wh - 2,
											h = eq_wh - 2,
										})
									end
									]]
								else
									--不存在道具，画个空板子
									if (not oHero.heroUI["equipEmpty" .. eq]) then
										oHero.heroUI["equipEmpty" .. eq] = hUI.image:new({
											parent = _frm.handle._n,
											model = "misc/photo_frame.png",
											x = btnX + eq_px,
											y = btnY + eq_py,
											w = eq_wh,
											h = eq_wh,
										})
										--hApi.AddShader(oHero.heroUI["equipEmpty" .. eq].handle.s, "gray") --灰色图片
										oHero.heroUI["equipEmpty" .. eq].handle.s:setOpacity(64)
									end
								end
							end
						end
						
						--pvp立即复活的文字
						--测试 --test
						--[[
						if oHero.heroUI["btnIcon"].childUI["pvp_rebirth_label"] then
							oHero.heroUI["btnIcon"].childUI["pvp_rebirth_label"]:del()
							oHero.heroUI["btnIcon"].childUI["pvp_rebirth_label"] = nil
						end
						if oHero.heroUI["btnIcon"].childUI["pvp_rebirth_count"] then
							oHero.heroUI["btnIcon"].childUI["pvp_rebirth_count"]:del()
							oHero.heroUI["btnIcon"].childUI["pvp_rebirth_count"] = nil
						end
						if oHero.heroUI["pvp_is_rebirth_hero_label"] then
							oHero.heroUI["pvp_is_rebirth_hero_label"]:del()
							oHero.heroUI["pvp_is_rebirth_hero_label"] = nil
						end
						if oHero.heroUI["pvp_rebirth_btn_yes"] then
							oHero.heroUI["pvp_rebirth_btn_yes"]:del()
							oHero.heroUI["pvp_rebirth_btn_yes"] = nil
						end
						if oHero.heroUI["pvp_rebirth_btn_no"] then
							oHero.heroUI["pvp_rebirth_btn_no"]:del()
							oHero.heroUI["pvp_rebirth_btn_no"] = nil
						end
						]]
						
						--立即复活的文字
						if (not oHero.heroUI["btnIcon"].childUI["pvp_rebirth_label"]) then
							oHero.heroUI["btnIcon"].childUI["pvp_rebirth_label"] = hUI.label:new({
								parent = oHero.heroUI["btnIcon"].handle._n,
								font = hVar.FONTC,
								--font = hVar.DEFAULT_FONT,
								x = 0,
								y = -20,
								width = 300,
								align = "MC",
								size = 21,
								text = "立即复活",
								border = 1,
							})
							oHero.heroUI["btnIcon"].childUI["pvp_rebirth_label"].handle._n:setVisible(false) --一开始不显示
						end
						--立即复活的次数
						if (not oHero.heroUI["btnIcon"].childUI["pvp_rebirth_count"]) then
							local pos = oHero:getowner():getpos()
							oHero.heroUI["btnIcon"].childUI["pvp_rebirth_count"] = hUI.label:new({
								parent = oHero.heroUI["btnIcon"].handle._n,
								font = "numWhite",
								x = 0,
								y = -38,
								width = 300,
								align = "MC",
								size = 18,
								text = "x" .. w.data.pvp_buy_rebirth_count[pos],
								border = 1,
							})
							oHero.heroUI["btnIcon"].childUI["pvp_rebirth_count"].handle._n:setVisible(false) --一开始不显示
						end
						--oHero.heroUI["btnIcon"].childUI["pvp_bolder"].handle.s:setVisible(false)
						--[[
						--提示是否复活英雄的文字
						if (not oHero.heroUI["pvp_is_rebirth_hero_label"]) then
							oHero.heroUI["pvp_is_rebirth_hero_label"] = hUI.label:new({
								parent = _frm.handle._n,
								x = btnX + 50,
								y = btnY + 25,
								width = 300,
								font = hVar.FONTC,
								align = "LC",
								size = 22,
								text = "是否消耗5兵符复活英雄？",
								border = 1,
							})
							oHero.heroUI["pvp_is_rebirth_hero_label"].handle._n:setVisible(false) --一开始不显示
						end
						]]
						--是按钮
						if (not oHero.heroUI["pvp_rebirth_btn_yes"]) then
							oHero.heroUI["pvp_rebirth_btn_yes"] = hUI.button:new({
								parent = _frm.handle._n,
								model = itemtModel, --"UI:SkillSlot",
								x = btnX + 100,
								y = btnY - 15,
								--icon = "UI:pvptoken",
								--iconWH = 26,
								label = {text = hVar.tab_string["__TEXT_Revive"], size = 28, font = hVar.FONTC, border = 1, x = 0, y = -1,}, --"复活"
								w = 110,
								h = 50,
								dragbox = _frm.childUI["dragBox"],
								scaleT = 0.95,
								code = function()
									--隐藏购买界面
									--if oHero.heroUI["pvp_is_rebirth_hero_label"] then
									--	oHero.heroUI["pvp_is_rebirth_hero_label"].handle._n:setVisible(false) --不显示
									--end
									if oHero.heroUI["pvp_rebirth_btn_yes"] then
										oHero.heroUI["pvp_rebirth_btn_yes"]:setstate(-1) --不显示
									end
									--if oHero.heroUI["pvp_rebirth_btn_no"] then
									--	oHero.heroUI["pvp_rebirth_btn_no"]:setstate(-1) --不显示
									--end
									
									--发送立即复活英雄的协议
									--print(oHero.data.id)
									local oDeadoUint = nil --死亡后的单位
									local world = hGlobal.WORLD.LastWorldMap
									for i = #world.data.rebirthT, 1 , -1 do --复活表
										local t = world.data.rebirthT[i]
										local oDeadHero = t.oDeadHero --死亡的英雄
										local deadoUint = t.deadoUint --倒计时的单位
										if (oHero == oDeadHero) then --找到了
											oDeadoUint = deadoUint
											break
										end
									end
									if oDeadoUint then
										hApi.AddCommand(hVar.Operation.HeroRebirth, oHero.data.id, oDeadoUint:getworldI(), oDeadoUint:getworldC())
									end
								end,
							})
							oHero.heroUI["pvp_rebirth_btn_yes"]:setstate(-1) --一开始不显示
							--是按钮的兵符图标
							oHero.heroUI["pvp_rebirth_btn_yes"].childUI["icon"] = hUI.image:new({
								parent = oHero.heroUI["pvp_rebirth_btn_yes"].handle._n,
								model = itemtModel, --"UI:SkillSlot",
								x = -18,
								y = 33,
								model = "UI:pvptoken",
								w = 22,
								h = 26,
							})
							--是按钮的兵符数量
							oHero.heroUI["pvp_rebirth_btn_yes"].childUI["pvpcoin"] = hUI.label:new({
								parent = oHero.heroUI["pvp_rebirth_btn_yes"].handle._n,
								text = "x5",
								size = 18,
								x = -6,
								y = 44,
								width = 300,
								font = "numWhite",
								border = 0,
							})
							oHero.heroUI["pvp_rebirth_btn_yes"].childUI["pvpcoin"].handle.s:setColor(ccc3(255, 255, 224))
						end
						--[[
						--否按钮
						if (not oHero.heroUI["pvp_rebirth_btn_no"]) then
							oHero.heroUI["pvp_rebirth_btn_no"] = hUI.button:new({
								parent = _frm.handle._n,
								model = itemtModel, --"UI:SkillSlot",
								x = btnX + 225,
								y = btnY - 25,
								label = {text = hVar.tab_string["__TEXT_Cancel"], size = 26, font = hVar.FONTC, border = 1,}, --"取消"
								w = 110,
								h = 45,
								dragbox = _frm.childUI["dragBox"],
								scaleT = 0.95,
								code = function()
									--隐藏购买界面
									if oHero.heroUI["pvp_is_rebirth_hero_label"] then
										oHero.heroUI["pvp_is_rebirth_hero_label"].handle._n:setVisible(false) --不显示
									end
									if oHero.heroUI["pvp_rebirth_btn_yes"] then
										oHero.heroUI["pvp_rebirth_btn_yes"]:setstate(-1) --不显示
									end
									if oHero.heroUI["pvp_rebirth_btn_no"] then
										oHero.heroUI["pvp_rebirth_btn_no"]:setstate(-1) --不显示
									end
								end,
							})
							oHero.heroUI["pvp_rebirth_btn_no"]:setstate(-1) --一开始不显示
						end
						]]
					else --手机模式
						local tPosXList = {50, 150}
						local tPosYList = {167, 62}
						
						local btnX = tPosXList[i]
						local btnY = tPosYList[i]
						
						if oHero.heroUI["btnIcon"] then
							oHero.heroUI["btnIcon"]:setXY(btnX, btnY)
						end
						if oHero.heroUI["option"] then
							oHero.heroUI["option"]:setXY(btnX - 1048, btnY)
						end
						--[[
						if oHero.heroUI["movepoint"] then
							oHero.heroUI["movepoint"].handle._n:setPosition(btnX - 32, btnY + 38)
						end
						]]
						--if oHero.heroUI["hpBar"] then
						--	oHero.heroUI["hpBar"].handle._n:setPosition(btnX - 47 ,btnY - 57)
						--end
						
						--携带装备模式
						if w.data.bUseEquip then
							--英雄的装备
							local equipment = oHero.data.equipment or {}
							local equippos = {1, 2, 4, 3}
							for eq = 1, 4, 1 do
								--[[
								--测试 --test
								if oHero.heroUI["equipBG" .. eq] then
									oHero.heroUI["equipBG" .. eq]:del()
									oHero.heroUI["equipBG" .. eq] = nil
								end
								if oHero.heroUI["equip" .. eq] then
									oHero.heroUI["equip" .. eq]:del()
									oHero.heroUI["equip" .. eq] = nil
								end
								--if oHero.heroUI["equipBan" .. eq] then
								--	oHero.heroUI["equipBan" .. eq]:del()
								--	oHero.heroUI["equipBan" .. eq] = nil
								--end
								if oHero.heroUI["equipEmpty" .. eq] then
									oHero.heroUI["equipEmpty" .. eq]:del()
									oHero.heroUI["equipEmpty" .. eq] = nil
								end
								--
								]]
								
								
								local itemId = 0
								local equp = equipment[equippos[eq]]
								if (type(equp) == "table") then
									itemId = equp[1]
								end
								
								local eq_wh = 25
								local eq_px = eq_wh + 36 - (i - 1) * 122
								local eq_py = -(eq - 1) * (eq_wh + 1) + 34
								
								--存在道具
								if hVar.tab_item[itemId] then
									--绘制装备品质等级颜色
									if (not oHero.heroUI["equipBG" .. eq]) then
										local itemLv = hVar.tab_item[itemId].itemLv or 1
										local itemModel = hVar.ITEMLEVEL[itemLv].BORDERMODEL --模型
										--if (hVar.tab_item[itemId].isArtifact == 1) then --神器边框换个图
										--	itemModel = "ICON:Back_red2"
										--end
										oHero.heroUI["equipBG" .. eq] = hUI.image:new({
											parent = _frm.handle._n,
											model = itemModel, --"UI:SkillSlot",
											x = btnX + eq_px,
											y = btnY + eq_py,
											w = eq_wh,
											h = eq_wh,
										})
										oHero.heroUI["equipBG" .. eq].handle.s:setOpacity(64)
									end
									
									--绘制道具
									if (not oHero.heroUI["equip" .. eq]) then
										--绘制道具图标
										oHero.heroUI["equip" .. eq] = hUI.image:new({
											parent = _frm.handle._n,
											model = hVar.tab_item[itemId].icon,
											x = btnX + eq_px,
											y = btnY + eq_py,
											w = eq_wh - 2,
											h = eq_wh - 2,
										})
										
										--默认灰掉
										--hApi.AddShader(oHero.heroUI["equip" .. eq].handle.s, "gray")
										oHero.heroUI["equip" .. eq].handle.s:setOpacity(64)
									end
									
									--[[
									--绘制道具禁用的图标
									if (not oHero.heroUI["equipBan" .. eq]) then
										--绘制道具图标
										oHero.heroUI["equipBan" .. eq] = hUI.image:new({
											parent = _frm.handle._n,
											model = "misc/close.png",
											x = btnX + eq_px,
											y = btnY + eq_py,
											w = eq_wh - 2,
											h = eq_wh - 2,
										})
									end
									]]
								else
									--不存在道具，画个空板子
									if (not oHero.heroUI["equipEmpty" .. eq]) then
										oHero.heroUI["equipEmpty" .. eq] = hUI.image:new({
											parent = _frm.handle._n,
											model = "misc/photo_frame.png",
											x = btnX + eq_px,
											y = btnY + eq_py,
											w = eq_wh,
											h = eq_wh,
										})
										--hApi.AddShader(oHero.heroUI["equipEmpty" .. eq].handle.s, "gray") --灰色图片
										oHero.heroUI["equipEmpty" .. eq].handle.s:setOpacity(64)
									end
								end
							end
						end
						
						--pvp立即复活的文字
						--[[
						--测试 --test
						if oHero.heroUI["btnIcon"].childUI["pvp_rebirth_label"] then
							oHero.heroUI["btnIcon"].childUI["pvp_rebirth_label"]:del()
							oHero.heroUI["btnIcon"].childUI["pvp_rebirth_label"] = nil
						end
						if oHero.heroUI["btnIcon"].childUI["pvp_rebirth_count"] then
							oHero.heroUI["btnIcon"].childUI["pvp_rebirth_count"]:del()
							oHero.heroUI["btnIcon"].childUI["pvp_rebirth_count"] = nil
						end
						if oHero.heroUI["pvp_is_rebirth_hero_label"] then
							oHero.heroUI["pvp_is_rebirth_hero_label"]:del()
							oHero.heroUI["pvp_is_rebirth_hero_label"] = nil
						end
						if oHero.heroUI["pvp_rebirth_btn_yes"] then
							oHero.heroUI["pvp_rebirth_btn_yes"]:del()
							oHero.heroUI["pvp_rebirth_btn_yes"] = nil
						end
						if oHero.heroUI["pvp_rebirth_btn_no"] then
							oHero.heroUI["pvp_rebirth_btn_no"]:del()
							oHero.heroUI["pvp_rebirth_btn_no"] = nil
						end
						]]
						
						--立即复活的文字
						if (not oHero.heroUI["btnIcon"].childUI["pvp_rebirth_label"]) then
							oHero.heroUI["btnIcon"].childUI["pvp_rebirth_label"] = hUI.label:new({
								parent = oHero.heroUI["btnIcon"].handle._n,
								font = hVar.FONTC,
								--font = hVar.DEFAULT_FONT,
								x = 0,
								y = -25,
								width = 300,
								align = "MC",
								size = 24,
								text = "立即复活",
								border = 1,
							})
							oHero.heroUI["btnIcon"].childUI["pvp_rebirth_label"].handle._n:setVisible(false) --一开始不显示
						end
						--立即复活的次数
						if (not oHero.heroUI["btnIcon"].childUI["pvp_rebirth_count"]) then
							local pos = oHero:getowner():getpos()
							oHero.heroUI["btnIcon"].childUI["pvp_rebirth_count"] = hUI.label:new({
								parent = oHero.heroUI["btnIcon"].handle._n,
								font = "numWhite",
								x = 0,
								y = -45,
								width = 300,
								align = "MC",
								size = 22,
								text = "x" .. w.data.pvp_buy_rebirth_count[pos],
								border = 1,
							})
							oHero.heroUI["btnIcon"].childUI["pvp_rebirth_count"].handle._n:setVisible(false) --一开始不显示
						end
						--[[
						--提示是否复活英雄的文字
						if (not oHero.heroUI["pvp_is_rebirth_hero_label"]) then
							oHero.heroUI["pvp_is_rebirth_hero_label"] = hUI.label:new({
								parent = _frm.handle._n,
								x = btnX + 60,
								y = btnY + 30,
								width = 300,
								font = hVar.FONTC,
								align = "LC",
								size = 24,
								text = "是否消耗5兵符复活英雄？",
								border = 1,
							})
							oHero.heroUI["pvp_is_rebirth_hero_label"].handle._n:setVisible(false) --一开始不显示
						end
						]]
						--是按钮
						if (not oHero.heroUI["pvp_rebirth_btn_yes"]) then
							oHero.heroUI["pvp_rebirth_btn_yes"] = hUI.button:new({
								parent = _frm.handle._n,
								model = itemtModel, --"UI:SkillSlot",
								x = btnX + 115,
								y = btnY - 20,
								--icon = "UI:pvptoken",
								--iconWH = 26,
								label = {text = hVar.tab_string["__TEXT_Revive"], size = 32, font = hVar.FONTC, border = 1, x = 0, y = -1,}, --"复活"
								w = 120,
								h = 55,
								dragbox = _frm.childUI["dragBox"],
								scaleT = 0.95,
								code = function()
									--隐藏购买界面
									--if oHero.heroUI["pvp_is_rebirth_hero_label"] then
									--	oHero.heroUI["pvp_is_rebirth_hero_label"].handle._n:setVisible(false) --不显示
									--end
									if oHero.heroUI["pvp_rebirth_btn_yes"] then
										oHero.heroUI["pvp_rebirth_btn_yes"]:setstate(-1) --不显示
									end
									--if oHero.heroUI["pvp_rebirth_btn_no"] then
									--	oHero.heroUI["pvp_rebirth_btn_no"]:setstate(-1) --不显示
									--end
									
									--发送立即复活英雄的协议
									--print(oHero.data.id)
									local oDeadoUint = nil --死亡后的单位
									local world = hGlobal.WORLD.LastWorldMap
									for i = #world.data.rebirthT, 1 , -1 do --复活表
										local t = world.data.rebirthT[i]
										local oDeadHero = t.oDeadHero --死亡的英雄
										local deadoUint = t.deadoUint --倒计时的单位
										if (oHero == oDeadHero) then --找到了
											oDeadoUint = deadoUint
											break
										end
									end
									if oDeadoUint then
										hApi.AddCommand(hVar.Operation.HeroRebirth, oHero.data.id, oDeadoUint:getworldI(), oDeadoUint:getworldC())
									end
								end,
							})
							oHero.heroUI["pvp_rebirth_btn_yes"]:setstate(-1) --一开始不显示
							--是按钮的兵符图标
							oHero.heroUI["pvp_rebirth_btn_yes"].childUI["icon"] = hUI.image:new({
								parent = oHero.heroUI["pvp_rebirth_btn_yes"].handle._n,
								model = itemtModel, --"UI:SkillSlot",
								x = -18,
								y = 40,
								model = "UI:pvptoken",
								w = 24,
								h = 30,
							})
							--是按钮的兵符数量
							oHero.heroUI["pvp_rebirth_btn_yes"].childUI["pvpcoin"] = hUI.label:new({
								parent = oHero.heroUI["pvp_rebirth_btn_yes"].handle._n,
								text = "x5",
								size = 20,
								x = -4,
								y = 51,
								width = 300,
								font = "numWhite",
								border = 0,
							})
							oHero.heroUI["pvp_rebirth_btn_yes"].childUI["pvpcoin"].handle.s:setColor(ccc3(255, 255, 224))
						end
						--[[
						--否按钮
						if (not oHero.heroUI["pvp_rebirth_btn_no"]) then
							oHero.heroUI["pvp_rebirth_btn_no"] = hUI.button:new({
								parent = _frm.handle._n,
								model = itemtModel, --"UI:SkillSlot",
								x = btnX + 245,
								y = btnY - 28,
								label = {text = hVar.tab_string["__TEXT_Cancel"], size = 30, font = hVar.FONTC, border = 1,}, --"取消"
								w = 115,
								h = 50,
								dragbox = _frm.childUI["dragBox"],
								scaleT = 0.95,
								code = function()
									--隐藏购买界面
									if oHero.heroUI["pvp_is_rebirth_hero_label"] then
										oHero.heroUI["pvp_is_rebirth_hero_label"].handle._n:setVisible(false) --不显示
									end
									if oHero.heroUI["pvp_rebirth_btn_yes"] then
										oHero.heroUI["pvp_rebirth_btn_yes"]:setstate(-1) --不显示
									end
									if oHero.heroUI["pvp_rebirth_btn_no"] then
										oHero.heroUI["pvp_rebirth_btn_no"]:setstate(-1) --不显示
									end
								end,
							})
							oHero.heroUI["pvp_rebirth_btn_no"]:setstate(-1) --一开始不显示
						end
						]]
					end
					
					--geyachao: 注，第1级也触发事件了，所以这不用特殊处理
					--刷新pvp某个英雄的装备获得冒泡
					--hApi.UpdateHeroEquipBubble_PVP(oHero)
				end
				
				--刷新英雄头像的装备可用状态
				--hApi.UpdateHeroEquipStateUI_PVP()
			end
		end,
		
		addBtn = function(self,oHero)
			--print("addBtn", oHero.data.name)
			local btnX, btnY = 0, 0
			local btnW, btnH = 56, 56
			local btnScale = 0.9
			local codeOnUp = nil
			local codeOnDrag = nil
			local codeOnTouch = nil
			
			--手机模式
			if (g_phone_mode ~= 0) then
				btnX = 0
				btnY = 0
				btnW = 72
				btnH = 72
			end
			
			if _code_IsAssistHero(oHero)==hVar.RESULT_SUCESS then
				--副将按钮
				btnX = 8
				btnY = 22
				btnW = 48
				btnH = 48
				btnScale = 0.75
				codeOnTouch = function(IsFromEvent)
					if IsFromEvent~=1 then
						hApi.PlaySound("button")
					end
				end
				codeOnUp = function(self,x,y,sus)
					--print("codeOnUp", self,x,y,sus)
					if sus==1 and oHero.data.HeroTeamLeader~=0 then
						hGlobal.event:event("LocalEvent_HideHeroTeamList")
						local mapbag = 0
						local oWorld = hGlobal.WORLD.LastWorldMap
						if oWorld and oWorld.ID>0 and type(oWorld.data.mapbag)=="table" then
							mapbag = 1
						end
						if oHero.data.IsDefeated == 1 then
							--print("点击死亡副将的头像")
							--点击死亡副将的头像
							local oHeroL = hClass.hero:find(oHero.data.HeroTeamLeader)
							return hGlobal.event:event("LocalEvent_HitOnDefeatExHero",oHero,oHeroL)
						else
							return hGlobal.event:event("LocalEvent_showHeroCardFrm",oHero,nil,mapbag)
						end
					end
				end
			else
				local btnHitCount = 0
				local btnHitState = 0
				
				--主将按钮(抬起事件)
				codeOnUp = function(self, x, y, nIsinside)
					--print("codeOnUp", x, y, nIsinside)
					btnHitCount = btnHitCount + 1
					btnHitState = 0
					oHero.heroUI["option"]:setstate(-1)
					
					--在按钮内部点击
					if (nIsinside == 1) then
						local oUnit = oHero:getunit()
						local w = hGlobal.WORLD.LastWorldMap
						
						--pvp模式，英雄已死，显示本英雄的立即复活的控件
						if (oUnit == nil) then
							if w and w.data.tdMapInfo and (w.data.tdMapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then --PVP模式
								--pvp模式，隐藏可能选中的头像栏的复活按钮
								for i = 1, #(w:GetPlayerMe().heros), 1 do
									local oHero = w:GetPlayerMe().heros[i]
									if oHero then
										if oHero.heroUI["pvp_rebirth_btn_yes"] then
											oHero.heroUI["pvp_rebirth_btn_yes"]:setstate(-1) --不显示
										end
									end
								end
								
								--本局还可以购买英雄
								local pos = oHero:getowner():getpos()
								if (w.data.pvp_buy_rebirth_count[pos] > 0) then
									--显示立即复活相关的控件
									--if oHero.heroUI["pvp_is_rebirth_hero_label"] then
									--	oHero.heroUI["pvp_is_rebirth_hero_label"].handle._n:setVisible(true) --显示
									--end
									if oHero.heroUI["pvp_rebirth_btn_yes"] then
										oHero.heroUI["pvp_rebirth_btn_yes"]:setstate(1) --显示
									end
									--if oHero.heroUI["pvp_rebirth_btn_no"] then
									--	oHero.heroUI["pvp_rebirth_btn_no"]:setstate(1) --显示
									--end
								end
								
								--不选中按钮
								local oBtnL = hApi.GetObjectEx(hUI.button, __HUI__ActivedBtn)
								if oBtnL then
									oBtnL.childUI["flag"].handle.s:setVisible(false)
									oBtnL.childUI["SelectBorder"].handle._n:setVisible(false)
								end
								hApi.SetObjectEx(__HUI__ChoosedHero,nil)
								hApi.SetObjectEx(__HUI__ActivedBtn,nil)
							end
						end
					end
				end
				
				local LastHitLockTick = 0
				local LastHitCount = 0
				codeOnTouch = function(IsFromEvent)
					--print("codeOnTouch", IsFromEvent)
					--geyachao: 取消选中的战术技能卡技能
					local tacticCardCtrls = hGlobal.WORLD.LastWorldMap.data.tacticCardCtrls --战术技能卡控件集
					for i = 1, #tacticCardCtrls, 1 do
						local cardi = tacticCardCtrls[i]
						if cardi and (cardi ~= 0) then
							if (cardi.data.selected == 1) then --战术技能卡是选中状态
								hApi.safeRemoveT(cardi.childUI, "selectbox") --删除选中特效
								cardi.data.selected = 0
							end
						end
					end
					
					hGlobal.O:replace("__WM__TargetOperatePanel",nil)
					hGlobal.O:replace("__WM__MoveOperatePanel",nil)
					if IsFromEvent~=1 then
						hApi.PlaySound("button")
						oHero.heroUI["option"]:setstate(1)
						oHero.heroUI["option"]:setstate(2)
					end
					
					--点击选择英雄(按下)
					if (oHero.data.IsDefeated == 1) then
						if (IsFromEvent ~= 1) then
							hApi.safeRemoveT(HeroDeadFrm.childUI,"deadheroimage")
							HeroDeadFrm.childUI["deadheroimage"] = hUI.image:new({
								parent = HeroDeadFrm.handle._n,
								model = oHero.data.icon,
								x = HeroDeadFrm.data.w/2-10,
								y = -HeroDeadFrm.data.h/2,
							})
							HeroDeadFrm:show(1)
							--print("单位已死")
						end
						return
					end
					--连续点击的话直接弹出英雄属性面板
					if IsFromEvent~=1 then
						local cTick = hApi.gametime()
						if LastHitLockTick>=cTick then
							LastHitCount = LastHitCount + 1
							LastHitLockTick = cTick + math.max(0,500 - LastHitCount*250)
							if LastHitCount>=1 then		--双击头像打开角色面板
								LastHitLockTick = 0
								LastHitCount = 0
								hGlobal.event:event("LocalEvent_HideHeroTeamList")
								local mapbag = 0
								local oWorld = hGlobal.WORLD.LastWorldMap
								if oWorld and oWorld.ID>0 and type(oWorld.data.mapbag)=="table" then
									mapbag = 1
								end
								--hGlobal.event:event("LocalEvent_showHeroCardFrm",oHero,nil,mapbag) --geyachao: 大地图，双击英雄头像不会弹出面板
								
								--geyachao: pvp模式，双击英雄头像，聚焦到英雄单位
								if oWorld and oWorld.data.tdMapInfo and (oWorld.data.tdMapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then --PVP模式
									--设置镜头
									local oUnit = oHero:getunit()
									if oUnit then
										local px, py = hApi.chaGetPos(oUnit.handle)
										--聚焦
										hApi.setViewNodeFocus(px, py)
									end
								end
								
								return 
							end
						else
							LastHitLockTick = cTick + 500
							LastHitCount = 0
							if btnHitState==0 then
								btnHitState = 1
								local nHitCount = btnHitCount
								hApi.addTimerOnce("__UI_HERO__ShowInfoFramByTouch",1500,function()
									if btnHitCount==nHitCount and btnHitState==1 then
										hUI.dragBox:unselect()
										hGlobal.event:event("LocalEvent_HideHeroTeamList")
										local mapbag = 0
										local oWorld = hGlobal.WORLD.LastWorldMap
										if oWorld and oWorld.ID>0 and type(oWorld.data.mapbag)=="table" then
											mapbag = 1
										end
										--hGlobal.event:event("LocalEvent_showHeroCardFrm",oHero,nil,mapbag) --geyachao: 大地图，长按英雄头像不会弹出面板
										return
									end
								end)
							end
						end
					end
					
					--英雄单位
					local oUnit = oHero:getunit()
					local w = hGlobal.WORLD.LastWorldMap
					if oUnit and (oUnit:getworld() == w:GetPlayerMe():getfocusworld()) then
						if oHero.data.HeroTeamLeader==0 then
							--英雄为主将
							self:choosehero(oHero)
							local oUnitCur = w:GetPlayerMe():getfocusunit("worldmap")
							if oUnit~=oUnitCur then
								--如果这货被隐藏起来了
								if oUnit.data.IsHide==1 then
									if oUnitCur~=nil then
										--当点中了被隐藏的单位 则清除之前单位的路点，并且做一些邪恶的事
										local oUnitOld = nil
										for k,v in pairs(oUnit:getworld():GetPlayerMe().localdata.focusUnitT) do
											oUnitOld = hApi.GetObject(v)
											if oUnitOld~=nil then
												hApi.chaShowPath(oUnitOld.handle,0)
											end
										end
										oUnit:getworld():GetPlayerMe().localdata.focusUnitT = {}
									end
								else
									w:GetPlayerMe():focusunit(oUnit,"worldmap")
								end
							end
							
							--changed by pangyong 2015/4/3 
							--hGlobal.event:event("LocalEvent_HitOnHeroPhoto",oUnit,oHero.data.LocalIndex)
							hGlobal.event:event("LocalEvent_HideHeroTeamList")
							hGlobal.event:event("Event_TDUnitActived",oUnit:getworld(),1, oUnit) --zhenkira add
							
							--存储主动选中的英雄单位
							w.data.activeSelectedUnit = oUnit
							
							--镜头移动到当前坐标 --zhenkira 不移动镜头
							--local cx,cy = oUnit:getXY()
							--hApi.setViewNodeFocus(cx,cy)
							
							--如果单位是某城池守卫 则开启该城池的顶部操作条
							--if oUnit:isTownGuard() == 1 then
							--	local oTown = hClass.town:find(oUnit.data.curTown)
							--	if oTown then
							--		local TU = oTown:getunit()
							--		if TU then
							--			local wx,wy = TU:getXY()
							--			hGlobal.event:event("LocalEvent_HitOnTarget",w:GetPlayerMe():getfocusworld(),TU,wx,wy)
							--		end
							--	end
							--end
						else
							----英雄为副将
							--local oHeroL = hClass.hero:find(oHero.data.HeroTeamLeader)
							--if oHeroL then
							--	local oTargetL = oHeroL:getunit("worldmap")
							--	if oTargetL then
							--		--镜头移动到队长坐标
							--		local cx,cy = oTargetL:getXY()
							--		hApi.setViewNodeFocus(cx,cy)
							--		--显示提示圈
							--		if oTargetL.chaUI["LeaderTip"]==nil then
							--			local oNode = hUI.panel:new({
							--				mode = "effect",
							--				parent = oTargetL.handle._n,
							--				unit = oTargetL,
							--				bindTag = "LeaderTip",
							--				tick = 1200,
							--				z = -1,
							--			})
							--			local _,_,w,h = oTargetL:getbox()
							--			w = math.min(96,w)
							--			local oImg = hUI.image:new({
							--				parent = oNode.handle._n,
							--				model = "MODEL_EFFECT:SelectCircle",
							--				animation = blue,
							--				w = w,
							--				smartWH = 1,
							--			})
							--			local scale = math.min(0.95,(w-6)/w)
							--			local a = CCScaleBy:create(0.25,scale,scale)
							--			local aR = a:reverse()
							--			local seq = tolua.cast(CCSequence:createWithTwoActions(a,aR),"CCActionInterval")
							--			oImg.handle._n:runAction(CCRepeatForever:create(seq))
							--			hUI.deleteUIObject(oImg)
							--		end
							--	end
							--end
						end
					end
				end
			end
			
			--print("创建英雄头像的坐标")
			
			--pvp模式
			local w = hGlobal.WORLD.LastWorldMap
			if w and w.data.tdMapInfo and (w.data.tdMapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then --PVP模式
				--英雄头像主界面挪到左下角
				--local _frm = hGlobal.UI.HeroFrame
				--_frm:setXY(0, 0)
				
				--挡操作按钮1
				if (not _frm.childUI["hero_bg_img_btn1"]) then
					--点击挡板的事件
					local OnClickImgBgCallback = function(self, x, y, IsInside)
						local w = hGlobal.WORLD.LastWorldMap
						if w then
							local oPlayerMe = w:GetPlayerMe()
							if oPlayerMe then
								local heros = oPlayerMe.heros
								if heros then
									--判断点击到了上半区域还是下半区域
									if (x <= y) then --上半区域
										local hero1 = heros[1]
										--print(hero1, "hero1", hero1.data.name)
										if hero1 then
											hero1.heroUI["btnIcon"].data.codeOnTouch(0)
										end
									else --下半区域
										local hero2 = heros[2]
										if hero2 then
											--print(hero2, "hero2", hero2.data.name)
											hero2.heroUI["btnIcon"].data.codeOnTouch(0)
										else --如果没有第二个英雄，就选中地面
											--
										end
									end
								end
							end
						end
					end
					
					--print("创建英雄头像的底板1")
					if (g_phone_mode == 0) then --平板模式
						_frm.childUI["hero_bg_img_btn1"] = hUI.button:new({
							parent = _frm.handle._n,
							model = "misc/mask.png",
							dragbox = _frm.childUI["dragBox"],
							x = 160 / 2,
							y = 160 / 2,
							z = -2,
							w = 160,
							h = 160,
							code = OnClickImgBgCallback,
						})
						_frm.childUI["hero_bg_img_btn1"].handle.s:setOpacity(0) --只用于控制，不显示
					else --手机模式
						_frm.childUI["hero_bg_img_btn1"] = hUI.button:new({
							parent = _frm.handle._n,
							model = "misc/mask.png",
							dragbox = _frm.childUI["dragBox"],
							x = 200 / 2,
							y = 200 / 2,
							z = -2,
							w = 200,
							h = 200,
							code = OnClickImgBgCallback,
						})
						_frm.childUI["hero_bg_img_btn1"].handle.s:setOpacity(0) --只用于控制，不显示
					end
					
					--[[
					--背景图（9宫格）
					local img9 = CCScale9Sprite:createWithSpriteFrameName("data/image/ui/item_slot.png")
					local bg_x = -_frm.childUI["hero_bg_img_btn1"].data.x + 50
					local bg_y = -_frm.childUI["hero_bg_img_btn1"].data.y + 50
					img9:setPosition(ccp(bg_x, bg_y))
					img9:setContentSize(CCSizeMake(210, 210))
					_frm.childUI["hero_bg_img_btn1"].handle._n:addChild(img9)
					]]
				end
				
				--[[
				--挡操作按钮2
				if (not _frm.childUI["hero_bg_img_btn2"]) then
					print("创建英雄头像的底板2")
					--创建英雄头像的底板2
					_frm.childUI["hero_bg_img_btn2"] = hUI.button:new({
						parent = _frm.handle._n,
						model = "misc/mask.png",
						dragbox = _frm.childUI["dragBox"],
						x = 200 / 2,
						y = 100 / 2,
						z = -2,
						w = 200,
						h = 100,
					})
				end
				]]
			else
				--普通模式
				--local _frm = hGlobal.UI.HeroFrame
				--_frm:setXY(40, hVar.SCREEN.h - 105)
				
				--删除左下角操作框
				--if (_frm.childUI["hero_bg_img_btn1"]) then
				--	_frm.childUI["hero_bg_img_btn1"]:del()
				--	_frm.childUI["hero_bg_img_btn1"] = nil
				--end
			end
			
			--[[
			--英雄头像的血条
				oHero.heroUI["hpBar"] = hUI.valbar:new({
					parent = _frm.handle._n,
					x = btnX,
					y = btnY,
					w = 400,
					h = 22,
					align = "LB",
					back = {model = "misc/valuebar_back2.png",x=-18,y=-17,w=440,h=48},
					model = "misc/valuebar.png",
					--model = "misc/progress.png",
					v = 100,
					max = 100,
				})
				oHero.heroUI["hpBar"].handle.s:setOpacity(128)
				]]
				
				ShowHeroHpBar(oHero)
				
			--英雄头像的???
			oHero.heroUI["option"] = hUI.button:new({
				parent = _frm.handle._n,
				model = "UI:BTN_DragableHint",
				animation = "L",
				scaleT = 1.1,
				w = 16,
				h = btnH,
			})
			oHero.heroUI["option"]:setstate(-1)
			--print("333333333333333333333333333333333333333333333")
			
			--英雄头像
			if w and w.data.tdMapInfo and (w.data.tdMapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then --PVP模式
				--pvp模式
				oHero.heroUI["btnIcon"] = hUI.button:new({ --英雄按钮
					userdata = oHero.ID,
					parent = _frm.handle._n,
					mode = "imageButton",
					dragbox = _frm.childUI["dragBox"],
					model = oHero.data.icon,
					x = btnX,
					y = btnY,
					z = 10,
					w = btnW * 1.3,
					h = btnH * 1.3,
					scaleT = btnScale,
					failcall = 1,
					code = codeOnUp,
					codeOnDrag = codeOnDrag,
					codeOnTouch = codeOnTouch,
				})
			else --普通模式
				oHero.heroUI["btnIcon"] = hUI.button:new({ --英雄按钮
					userdata = oHero.ID,
					parent = _frm.handle._n,
					mode = "imageButton",
					dragbox = _frm.childUI["dragBox"],
					model = oHero.data.icon,
					x = btnX,
					y = btnY,
					z = 10,
					w = btnW,
					h = btnH,
					scaleT = btnScale,
					failcall = 1,
					code = codeOnUp,
					codeOnDrag = codeOnDrag,
					codeOnTouch = codeOnTouch,
				})
			end
			oHero.heroUI["btnIcon"].childUI["flag"] = hUI.image:new({					--打开军队列表的指导图标“《”
				parent = oHero.heroUI["btnIcon"].handle._n,
				mode = "image",
				x = 32,
				y = -32,
				w = 16,
				h = 16,
				model = "UI:BTN_DragableHint",
				align = "RB",
			})
			oHero.heroUI["btnIcon"].childUI["flag"].handle.s:setVisible(false)
			
			--选中框
			if w and w.data.tdMapInfo and (w.data.tdMapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then --PVP模式
				--pvp
				oHero.heroUI["btnIcon"].childUI["SelectBorder"] = hUI.image:new({				--英雄选择框
					parent = oHero.heroUI["btnIcon"].handle._n,
					--model = "UI:Button_SelectBorder",
					model = "UI:skillup2",
					w = btnW + 12,
					h = btnH + 12,
					x = 8, --pvp
					y = 4, --pvp
					scale = 1.3, --pvp
				})
				oHero.heroUI["btnIcon"].childUI["SelectBorder"].handle._n:setVisible(false) --一开始默认隐藏
			else
				oHero.heroUI["btnIcon"].childUI["SelectBorder"] = hUI.image:new({				--英雄选择框
					parent = oHero.heroUI["btnIcon"].handle._n,
					--model = "UI:Button_SelectBorder",
					model = "UI:skillup2",
					w = btnW + 12,
					h = btnH + 12,
					x = 5,
					y = 3,
					scale = 1,
				})
				oHero.heroUI["btnIcon"].childUI["SelectBorder"].handle._n:setVisible(false) --一开始默认隐藏
			end
			if oHero.data.IsDefeated==1 then
				oHero.heroUI["btnIcon"].handle.s:setColor(ccc3(127,127,127))
				--oHero.heroUI["movepoint"]:setV(0,100)
				--oHero.heroUI["hpBar"]:setV(0, 100)
				--设置大菠萝的血条
				SetHeroHpBarPercent(oHero, 0, 100)
			end
			
			--英雄等级
			if w and w.data.tdMapInfo and (w.data.tdMapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then --PVP模式
				--英雄的pvp等级
				if (g_phone_mode == 0) then --平板模式
					--pvp等级背景图
					oHero.heroUI["btnIcon"].childUI["pvp_bolder"] = hUI.image:new({
						parent = oHero.heroUI["btnIcon"].handle._n,
						model = "ui/pvp/pvpselect.png",
						x = 33,
						y = 33,
						w = 32,
						h = 32,
					})
					--oHero.heroUI["btnIcon"].childUI["pvp_bolder"].handle.s:setVisible(false)
					
					--pvp等级文字
					oHero.heroUI["btnIcon"].childUI["pvp_label"] = hUI.label:new({
						parent = oHero.heroUI["btnIcon"].handle._n,
						font = "numWhite",
						x = 33,
						y = 33 - 1, --数字字体有1像素的偏差
						width = 200,
						align = "MC",
						size = 21,
						text = "1",
					})
					--oHero.heroUI["btnIcon"].childUI["pvp_bolder"].handle.s:setVisible(false)
				else --手机模式
					--pvp等级背景图
					oHero.heroUI["btnIcon"].childUI["pvp_bolder"] = hUI.image:new({
						parent = oHero.heroUI["btnIcon"].handle._n,
						model = "ui/pvp/pvpselect.png",
						x = 38,
						y = 39,
						w = 40,
						h = 40,
					})
					--oHero.heroUI["btnIcon"].childUI["pvp_bolder"].handle.s:setVisible(false)
					
					--pvp等级文字
					oHero.heroUI["btnIcon"].childUI["pvp_label"] = hUI.label:new({
						parent = oHero.heroUI["btnIcon"].handle._n,
						font = "numWhite",
						x = 38,
						y = 39 - 1, --数字字体有1像素的偏差
						width = 200,
						align = "MC",
						size = 26,
						text = "1",
					})
					--oHero.heroUI["btnIcon"].childUI["pvp_bolder"].handle.s:setVisible(false)
				end
			end
			
			--复活倒计时文本
			if w and w.data.tdMapInfo and (w.data.tdMapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then --PVP模式
				if (g_phone_mode == 0) then --平板模式
					oHero.heroUI["btnIcon"].childUI["rebirth_time"] = hUI.label:new({
						parent = oHero.heroUI["btnIcon"].handle._n,
						font = hVar.DEFAULT_FONT,
						border = 1,
						size = 50,
						align = "MC",
						x = 0,
						y = 12,
						text = "",
					})
				else --手机模式
					oHero.heroUI["btnIcon"].childUI["rebirth_time"] = hUI.label:new({
						parent = oHero.heroUI["btnIcon"].handle._n,
						font = hVar.DEFAULT_FONT,
						border = 1,
						size = 66,
						align = "MC",
						x = 0,
						y = 15,
						text = "",
					})
				end
			else --普通地图
				if (g_phone_mode == 0) then --平板模式
					oHero.heroUI["btnIcon"].childUI["rebirth_time"] = hUI.label:new({
						parent = oHero.heroUI["btnIcon"].handle._n,
						font = hVar.DEFAULT_FONT,
						border = 1,
						size = 48,
						align = "MC",
						x = 0,
						y = 0,
						text = "",
					})
				else --手机模式
					oHero.heroUI["btnIcon"].childUI["rebirth_time"] = hUI.label:new({
						parent = oHero.heroUI["btnIcon"].handle._n,
						font = hVar.DEFAULT_FONT,
						border = 1,
						size = 62,
						align = "MC",
						x = 0,
						y = 0,
						text = "",
					})
				end
			end
		end,
		trySelectHero = function(self,oHero)
			--geyachao: TD地图，进游戏，不默认选中玩家的第一个英雄
			--[[
			--如果玩家未选中任何英雄，并且此英雄是第一个，则直接选中该英雄
			if hGlobal.LocalPlayer:getfocusunit("worldmap")==nil and oHero.data.LocalIndex==1 and oHero.data.HeroTeamLeader==0 then
				if self:choosehero(oHero)==1 then
					local oUnit = oHero:getunit("worldmap")
					if oUnit then
						hGlobal.LocalPlayer:focusunit(oUnit,"worldmap")
						hGlobal.event:event("Event_TDUnitActived",oUnit:getworld(),1, oUnit)
					end
				end
			end
			]]
		end,
	}
	
	--[[
	--选择英雄事件
	hGlobal.event:listen("LocalEvent_PlayerChooseHero","__UI__SelectHeroForPalyer", function(oHero)
		for i = 1,#hGlobal.LocalPlayer.heros do
			local oHeroC = hGlobal.LocalPlayer.heros[i]
			if oHero==oHeroC then
				if _HeroLocalUI:choosehero(oHeroC)==1 then
					local oUnit = oHeroC:getunit("worldmap")
					if oUnit then
						hGlobal.LocalPlayer:focusunit(oUnit,"worldmap")
					end
				end
				return
			end
		end
	end)
	]]
	hGlobal.event:listen("LocalEvent_PlayerChooseHero", "__UI__SelectHeroForPalyer", function(oHero)
		_HeroLocalUI:choosehero(oHero)
	end)
	
	--创建英雄时，加载英雄头像
	hGlobal.event:listen("Event_HeroCreated","__UI__InitHeroButton", function(oHero, CreatedOnMapInit)
		--print("创建英雄时，加载英雄头像", oHero:getunit().data.name)
		--创建世界的时候并不直接加载头像，因为这时候会涉及到头像的排序
		--CreatedOnMapInit:0,游戏时 1,世界创建时 2,读档时
		local w = hGlobal.WORLD.LastWorldMap
		if w then
			local me = w:GetPlayerMe()
			if CreatedOnMapInit==0 and w and me and oHero:getowner()==me then
				_HeroLocalUI:clearUI(oHero)
				if w.data.map ~= hVar.MainBase then
					_HeroLocalUI:addBtn(oHero)
					_HeroLocalUI:sortBtn(me)
					_HeroLocalUI:trySelectHero(oHero)
				end
			end
		end
	end)
	
	--横竖屏切换
	hGlobal.event:listen("LocalEvent_SpinScreen","SystemMenuFrm_HeroBar",function()
		local w = hGlobal.WORLD.LastWorldMap
		if w then
			if w.data.map == hVar.LoginMap then
				return
			end
			if w.data.map == hVar.MainBase then
				return
			end
		end
		
		if hGlobal.UI.HeroFrame then
			hGlobal.UI.HeroFrame:setXY(40, hVar.SCREEN.h - 105)
		end
		
		if w then
			local me = w:GetPlayerMe()
			if me then
				local heros = me.heros
				if heros then
					local oHero = heros[1]
					if oHero then
						ShowHeroHpBar(oHero)
					end
				end
			end
		end
	end)
	
	--加载所有本地头像代码
	local _code_InitHeroBtn = function(oWorld)
		_HeroLocalUI:choosehero(nil)
		if oWorld then
			local me = oWorld:GetPlayerMe()
			if me then
				local heros = me.heros
				for i = 1,#heros do
					local oHero = heros[i]
					if type(oHero)=="table" and (heros[i].ID or 0)>0 then
						if heros[i].data.IsDefeated==2 then
							_HeroLocalUI:clearUI(oHero)
						else
							_HeroLocalUI:clearUI(oHero)
							_HeroLocalUI:addBtn(oHero)
							_HeroLocalUI:trySelectHero(oHero)
						end
					end
				end
				_HeroLocalUI:sortBtn(me)
			end
		end
	end

	--读取地图结束时，加载英雄头像
	hGlobal.event:listen("Event_WorldCreated","__UI__InitHeroButton",function(oWorld,IsCreatedFromLoad)
		if IsCreatedFromLoad==1 and oWorld.data.type=="worldmap" then
			_code_InitHeroBtn(oWorld)
		end
	end)

	--世界地图首次加载后，创建所有英雄的头像
	hGlobal.event:listen("LocalEvent_WorldMapStart","__UI__InitHeroButton",function(oWorld)
		_code_InitHeroBtn(oWorld)
	end)

	--手动调用，刷新所有英雄的头像
	hGlobal.event:listen("LocalEvent_UpdateAllHeroIcon","__UI__Update",function()
		_HeroLocalUI:choosehero(nil)
		if oWorld then
			local me = oWorld:GetPlayerMe()
			if me then
				local heros = me.heros
				for i = 1,#heros do
					local oHero = heros[i]
					if type(oHero)=="table" and (heros[i].ID or 0)>0 then
						if heros[i].data.IsDefeated==2 then
							_HeroLocalUI:clearUI(oHero)
						else
							_HeroLocalUI:clearUI(oHero)
							_HeroLocalUI:addBtn(oHero)
							_HeroLocalUI:trySelectHero(oHero)
						end
					end
				end
				_HeroLocalUI:sortBtn(me)
			end
		end
	end)
	
	--英雄转换控制权时，加载英雄头像
	hGlobal.event:listen("Event_HeroChangeOwner","__UI__InitHeroButton",function(oHero,oPlayer,oPlayerOld)
		
		local w = hGlobal.WORLD.LastWorldMap
		local me = w:GetPlayerMe()
		
		local aln = me:allience(oPlayer)
		local oUnit = oHero:getunit()
		if oUnit then
			local x,y = oUnit:getbox()
			hApi.safeRemoveT(oUnit.chaUI,"__HERO_LEVEL__")
			local numFont = "numWhite"
			if oPlayer==me then
				numFont = "numGreen"
			elseif aln==hVar.PLAYER_ALLIENCE_TYPE.ALLY then
				numFont = "numBlue"
			elseif aln==hVar.PLAYER_ALLIENCE_TYPE.ENEMY then
				numFont = "numRed"
			end
			oUnit.chaUI["__HERO_LEVEL__"] = hUI.label:new({
				parent = oUnit.handle._tn,
				font = numFont,
				text = "", --geyachao: 不显示英雄等级 "lv"..oHero.attr.level,
				size = 12,
				align = "MB",
				y = -1*y-6,
			})
		end
		if oPlayer==me then
			if oPlayerOld~=me then
				_HeroLocalUI:clearUI(oHero)
				_HeroLocalUI:addBtn(oHero)
				_HeroLocalUI:sortBtn(me)
				_HeroLocalUI:trySelectHero(oHero)
			end
		elseif oPlayerOld==me then
			_HeroLocalUI:clearUI(oHero)
			_HeroLocalUI:sortBtn(oPlayerOld)
			if oUnit and oUnit==me:getfocusunit() then
				local tHero = me.heros
				for i = 1,#tHero do
					if type(tHero[i])=="table" and tHero[i].heroUI and tHero[i].heroUI["btnIcon"] then
						if oHero:getunit() then
							me:focusunit(oHero:getunit(),"worldmap")
						end
						tHero[i].heroUI["btnIcon"].data.codeOnTouch(1)
					end
				end
			end
		end
	end)

	----发生了队伍更换的时候，会重新创建小头像
	--hGlobal.event:listen("LocalEvent_HeroOprBtnUpdate","__ReCreateHeroIcon",function(oHero,IfWithChangeOwner)
	--	if IfWithChangeOwner~=1 then
	--		--因为改变队伍的时候会触发一次重新创建头像，这里就不重新创建了
	--		_HeroLocalUI:clearUI(oHero)
	--		_HeroLocalUI:addBtn(oHero)
	--		_HeroLocalUI:sortBtn(hGlobal.LocalPlayer)
	--	end
	--end)

	--玩家看地图的时候自动把视角切到第一个英雄的地方
	hGlobal.event:listen("LocalEvent_PlayerFocusWorld","__PlayerLookSelectedHero",function(sSceneType,oWorld,oMap)
		if sSceneType=="worldmap" and oWorld~=nil and oWorld:GetPlayerMe() then
			local u = oWorld:GetPlayerMe():getfocusunit("worldmap")
			if u then
				local cx,cy = u:getXY()
				hApi.setViewNodeFocus(cx,cy)
			else
				--for i = 1,#hGlobal.LocalPlayer.data.ownTown do
				--	local townU = hApi.GetObjectUnit(hGlobal.LocalPlayer.data.ownTown[i])
				--	if townU then
				--		local cx,cy = townU:getXY()
				--		hApi.setViewNodeFocus(cx,cy)
				--		break
				--	end
				--end
			end
		end
	end)

	----英雄在城里操作的时候，设置选择状态
	--hGlobal.event:listen("Event_TownSetVisitor","__afterSetVisitor2",function(oWorld,oTown,oVisitor,nOperate)
	--	if oTown:getowner() == hGlobal.LocalPlayer then
	--		local TownData = oTown:gettown()
	--		--设置英雄选择按钮状态
	--		local vU = TownData:getunit("visitor")
	--		if vU then
	--			local oHero = vU:gethero()
	--			if oHero then
	--				_HeroLocalUI:choosehero(oHero)
	--			end
	--		end
	--	end
	--end)

	----英雄在城里操作的时候，设置选择状态
	--hGlobal.event:listen("Event_TownShiftGuardAndVisitor","__AfterChange2",function(oWorld,oTown,oGuard,oVisitor,nOperate)
	--	if oTown:getowner() == hGlobal.LocalPlayer then
	--		local TownData = oTown:gettown()
	--		local vU = TownData:getunit("visitor")
	--		if vU then
	--			local oHero = vU:gethero()
	--			if oHero then
	--				_HeroLocalUI:choosehero(oHero)
	--			end
	--		end
	--	end
	--end)

	--本地玩家的英雄死亡后图标灰掉
	hGlobal.event:listen("Event_HeroDefeated","__UI_HeroDefeated",function(oHero,oDefeatHero)
		local w = hGlobal.WORLD.LastWorldMap
		if w then
			local me = w:GetPlayerMe()
			--print(nil .. nil)
			if me and oHero:getowner()==me then
				if oHero.heroUI["btnIcon"]~=nil then
					oHero.heroUI["btnIcon"].handle.s:setColor(ccc3(127,127,127))
				end
				if oHero.heroUI["hpBar_green"]~=nil then
					--设置大菠萝的血条
					SetHeroHpBarPercent(oHero, 0, 100)
				end
			end
		end
	end)

	--hGlobal.event:listen("Event_UnitDefeated","WDLD_ATK_BUILDING",function(oWorld,oUnit,oDefeatHero)--世界，死亡单位，击败他的英雄
		----坑死我也
		----print(oDefeatHero.data.id,"idddddddddd")
		----print(oDefeatHero:getowner())
		----print(hGlobal.LocalPlayer)
	
		--local mapname = hGlobal.WORLD.LastWorldMap.data.map
		--if hApi.Is_RSYZ_Map(mapname) ~= -1 then
		--	local oTown = oUnit:gettown()
		--	local du = nil
		--	if oTown and oTown:getunit("guard") then
		--		du = oTown:getunit("guard")
		--	end
		--	local logStr = ""
		--	local logStrDef = ""
		--	for i = 1,#hGlobal.LastBattleLog do
		--		local vLog = hGlobal.LastBattleLog[i]
		--		if vLog.key == "unit_killed" and vLog.target.indexOfTeam~=0 then
		--			if hGlobal.player[vLog.unit.owner] == hGlobal.LocalPlayer then--我方击杀
		--				logStr = logStr.."1:"..vLog.unit.id..":"..vLog.target.id..";"
		--			else
		--				logStr = logStr.."2:"..vLog.unit.id..":"..vLog.target.id..";"
		--			end
		--		elseif vLog.key == "EnterBattle" then
		--			for j = 1,#vLog.team do
		--				if type(vLog.team[j]) == "table" then
		--					if hGlobal.player[vLog.unit.owner] == hGlobal.LocalPlayer then
		--						logStrDef = logStrDef..vLog.team[j][1]..","
		--					end
		--				end
		--			end
		--			logStrDef = logStrDef..":"
		--			for j = 1,#vLog.team do
		--				if type(vLog.team[j]) == "table" then
		--					if hGlobal.player[vLog.unit.owner] ~= hGlobal.LocalPlayer then
		--						logStrDef = logStrDef..vLog.team[j][1]..","
		--					end
		--				end
		--			end
		--		end
		--	end
		--	local hd,md,mh,mm = hApi.CalcHeroMaxHPAndLastHP(oWorld,hGlobal.LocalPlayer) --损失血% 损失蓝% 满血量 满蓝量
		--	local battle_gongxian = math.ceil((hd + md)/2)
		--	if oUnit:getowner()==hGlobal.LocalPlayer then--我方被消灭 失败
		--		local oduTid = 0
		--		if oDefeatHero then
		--			oduTid = oDefeatHero:getunit().data.triggerID
		--		elseif du then
		--			oduTid = du.data.triggerID
		--		end
		--		--print("oduTid",oDefeatHero == nil)
		--		local index = 0
		--		for i = 1,#RSDYZ_DEF_LIST do
		--			if RSDYZ_DEF_LIST[i][1] == oduTid then
		--				index = i
		--				break
		--			end
		--		end
		--		if index ~= 0 then--被玩家消灭
		--			local duu = nil
		--			if oDefeatHero then
		--				duu = oDefeatHero:getunit()
		--			elseif du then
		--				duu = du
		--			end
		--			logStrDef = logStrDef.."@"..duu:gettriggerdata().numFlag
		--			--BattleLog_Fire,自己id,别人id,别人名字,0,玩家-玩家 1  玩家-boss 2,进攻玩家胜1 进攻玩家输0,描述字符
		--			g_RSDYZ_LastCom = {GZone_Event_TypeDef.BattleLog_Fire,luaGetplayerDataID(),RSDYZ_DEF_LIST[index][2],RSDYZ_DEF_LIST[index][3],0,1,0,logStrDef,battle_gongxian,rsdyz_playerIdAndName[index].str} 
		--			Game_Zone_OnGameEvent(GZone_Event_TypeDef.Lua,g_RSDYZ_LastCom)
		--			--print(3,logStrDef)
		--		end
		--	else
		--		local oduTid = oUnit.data.triggerID or 0
		--		local index = 0
		--		for i = 1,#RSDYZ_DEF_LIST do
		--			if RSDYZ_DEF_LIST[i][1] == oduTid then
		--				index = i
		--				break
		--			end
		--		end
		--		if index ~= 0 then--打败防守玩家
		--			logStr = "@"..oUnit:gettriggerdata().numFlag
		--			g_RSDYZ_LastCom = {GZone_Event_TypeDef.BattleLog_Fire,luaGetplayerDataID(),RSDYZ_DEF_LIST[index][2],RSDYZ_DEF_LIST[index][3],0,1,1,logStr,battle_gongxian,rsdyz_playerIdAndName[index].str}
		--			Game_Zone_OnGameEvent(GZone_Event_TypeDef.Lua,g_RSDYZ_LastCom)
		--			--print(1,logStr)
		--		else--打败boss
		--			if oTown == nil then
		--				logStr = "@"..oUnit.data.id
		--				g_RSDYZ_LastCom = {GZone_Event_TypeDef.BattleLog_Fire,luaGetplayerDataID(),0,"boss",oUnit.data.id,2,1,logStr,0}
		--				Game_Zone_OnGameEvent(GZone_Event_TypeDef.Lua,g_RSDYZ_LastCom)
		--				--print(2,logStr)
		--			end
		--		end
		--	end
		--end
		--if hApi.Is_WDLD_Map(mapname) ~= -1 and g_WDLD_BeginATK == 1 then
			--if hVar.WDLD_ATK_Building.needNextBattleFinish ~= 10 then
				--if oUnit:getowner()~=hGlobal.LocalPlayer then
					--local log_ex = 0
					--local log_ex_1 = 0
					--local ncs = 0
					--for i = 1,#hGlobal.LastBattleLog do
						--local v = hGlobal.LastBattleLog[i]
						--if v.key=="EnterBattle" and v.unit.owner ~= hGlobal.LocalPlayer.data.playerId then
							--ncs = v.CombatScoreBasic
							--break
						--end
					--end
					--if oDefeatHero then
						--log_ex_1  = oDefeatHero.data.id * 100000 + math.floor(ncs/1000) + 1
						--log_ex = 1
						--log_ex_1 = string.format("%010d",log_ex_1)
					--end
					----print("gx   "..log_ex_1)
					----Game_Zone_OnGameEvent(GZone_Event_TypeDef.Lua,{GZone_Event_TypeDef.BattleLog,luaGetplayerDataID(),lookPlayer.roleid,0,1,0,0,0,0,0,0,0,log_ex,log_ex_1..";"})
					--local au = nil
					--if oUnit:gettriggerdata() and oUnit.data.triggerID > 0 then
						--hClass.unit:enum(function(eu)
							--if  eu:gettab().seizable == 1 then --资源建筑
								--local tgrData = eu:gettriggerdata()
								--if tgrData ~= nil and tgrData.guard then
									--if tgrData.guard[1] == oUnit.data.triggerID then
										--au = eu
									--end
								--end
							--end
						--end)
					--end
					--if au ~= nil then
						--hVar.WDLD_ATK_Building.attackWhat = au
						--hVar.WDLD_ATK_Building.needNextBattleFinish = 0
						--hVar.WDLD_ATK_Building.attackWhat:setowner(1)
						--hVar.WDLD_ATK_Building.attackWhat:gettriggerdata().guard[1] = 0
						--hGlobal.WORLD.LastWorldMap:WDLD_RemoveLastGuard(hVar.WDLD_ATK_Building.attackWhat)
						
						--if hVar.WDLD_ATK_Building.attackWhat.data and hVar.WDLD_ATK_Building.attackWhat.data.id then
							--bid = hVar.WDLD_ATK_Building.attackWhat.data.id
							--for i = 1,#hVar.WDLD_BUILDING_REWARD do
								--if hVar.WDLD_BUILDING_REWARD[i][1] == bid then
									--local re = hVar.WDLD_BUILDING_REWARD[i]
									--local t = re[1] or 0
									--local wood = re[2] or 0--wood
									--local food = re[3] or 0
									--local stone = re[4] or 0
									--local iron = re[5] or 0
									--local crystal = re[6] or 0
									--local gold = re[7] or 0
									--local expl = re[8] or 0
									--Game_Zone_OnGameEvent(GZone_Event_TypeDef.Lua,{GZone_Event_TypeDef.BattleLog,luaGetplayerDataID(),lookPlayer.roleid,t,1,gold,food,wood,stone,iron,crystal,expl,0})
									--break
								--end
							--end
						--end
						--hVar.WDLD_ATK_Building.attackWhat = nil
						--hVar.WDLD_ATK_Building.attackU = nil
						--hVar.WDLD_ATK_Building.theWorld = nil
					--else
						--Game_Zone_OnGameEvent(GZone_Event_TypeDef.Lua,{GZone_Event_TypeDef.BattleLog,luaGetplayerDataID(),lookPlayer.roleid,0,1,0,0,0,0,0,0,0,log_ex,log_ex_1..";"})
					--end
				--end
			--end
		--end
	--end)
	
	--本地玩家的英雄复活后图标变亮
	hGlobal.event:listen("Event_HeroRevive","__UI_HeroRevived",function(oWorld,oHero,oUnit,oBuilding,gridX,gridY)
		local w = hGlobal.WORLD.LastWorldMap
		if w then
			local me = w:GetPlayerMe()
			--print(nil .. nil)
			if me and oHero:getowner()==me then
				if oHero.heroUI["btnIcon"]~=nil then
					oHero.heroUI["btnIcon"].handle.s:setColor(ccc3(255,255,255))
				end
				--_RefreshHeroMovePointBar(oHero)
				_RefreshHeroHpBar(oHero)
			end
		end
	end)
	
	--本地玩家的英雄受伤后扣血（左上角图标） --zhenkira
	hGlobal.event:listen("Event_UnitDamaged", "__UI_HeroDamaged", function(oUnit,nSkillId,nDmgMode,nDmg,nLost,oAttacker,nAbsorb, oAttackerSide, oAttackerPos)
		local w = hGlobal.WORLD.LastWorldMap
		if w then
			local me = w:GetPlayerMe()
			local oHero = oUnit:gethero()
			if oHero and me and (oHero:getowner() == me) then
				--刷新左上角英雄血条图标
				_RefreshHeroHpBar(oHero)
			end
		end
	end)
	
	--pvp模式本地玩机的英雄升级后刷新血条进度（左上角图标）
	hGlobal.event:listen("Event_HeroPvpLvUp", "__UI_HeroPvpLvUp", function(oHero, lastLv, nowLv)
		local w = hGlobal.WORLD.LastWorldMap
		if w then
			local me = w:GetPlayerMe()
			if oHero and me and (oHero:getowner() == me) then
				--刷新左上角英雄血条图标
				_RefreshHeroHpBar(oHero)
			end
		end
	end)
	
	--世界重新创建的时候重新刷一遍选取信息
	hGlobal.event:listen("Event_WorldCreated","__UI_HeroIconRefresh",function(oWorld,IsCreatedFromLoad)
		if oWorld.data.type=="worldmap" then
			_frm.childUI["dragBox"]:sortbutton()
		end
	end)
end

--复活部分
--hGlobal.UI.InitHeroReviveFrm = function()
--
--	local _CODE_UpdateHeroList = hApi.DoNothing
--	local _CODE_ConfirmOnHero = hApi.DoNothing
--	local _CODE_ClearHeroList = hApi.DoNothing
--
--	local _FrmBG
--	local _childUI
--	local _HRF_PageState = nil
--	local _HRF_ChoosedOpr = nil
--	local _HRF_oBuilding = {}
--	local _HRF_FrmXYWH = {hVar.SCREEN.w/2 - 272,hVar.SCREEN.h/2 + 260,544,462}
--	local _HRF_GridXYWH = {_HRF_FrmXYWH[3]/2,-258,100,72}
--	local _HRF_GridIconXY = {			--复活显示图标的位置
--		[1] = {{_HRF_GridXYWH[1],_HRF_GridXYWH[2]},},
--		[2] = {{_HRF_GridXYWH[1]-_HRF_GridXYWH[3]/2,_HRF_GridXYWH[2]},{_HRF_GridXYWH[1]+_HRF_GridXYWH[3]/2,_HRF_GridXYWH[2]},},
--		[3] = {{_HRF_GridXYWH[1]-_HRF_GridXYWH[3],_HRF_GridXYWH[2]},{_HRF_GridXYWH[1],_HRF_GridXYWH[2]},{_HRF_GridXYWH[1]+_HRF_GridXYWH[3],_HRF_GridXYWH[2]},},
--		[4] = {{_HRF_GridXYWH[1]-_HRF_GridXYWH[3]*3/2,_HRF_GridXYWH[2]},{_HRF_GridXYWH[1]-_HRF_GridXYWH[3]/2,_HRF_GridXYWH[2]},{_HRF_GridXYWH[1]+_HRF_GridXYWH[3]/2,_HRF_GridXYWH[2]},{_HRF_GridXYWH[1]+_HRF_GridXYWH[3]*3/2,_HRF_GridXYWH[2]},},
--		[5] = {{_HRF_GridXYWH[1]-_HRF_GridXYWH[3]*9/5,_HRF_GridXYWH[2]},{_HRF_GridXYWH[1]-_HRF_GridXYWH[3]*9/10,_HRF_GridXYWH[2]},{_HRF_GridXYWH[1],_HRF_GridXYWH[2]},{_HRF_GridXYWH[1]+_HRF_GridXYWH[3]*9/10,_HRF_GridXYWH[2]},{_HRF_GridXYWH[1]+_HRF_GridXYWH[3]*9/5,_HRF_GridXYWH[2]},},
--	}
--	local _HRF_UIHandle = {}
--	local _HRF_UIList = {
--		{"image","apartline_top","UI:panel_part_09",{544/2,-150,544,8}},
--		{"image","apartline_buttom","UI:panel_part_09",{544/2,-462+56,544,8}},
--		{"image","imgHostelSlot",{"UI_frm:slot","lightSlim"},{85,-85,72,72}},
--		{"labelX","labHostelTittle","",{150,-46,26,1,"LT",hVar.FONTC,0,544-150-30}},
--		{"image","imgPayGold","UI:ICON_main_frm_ResourceGold",{544/2-48,-462+92,48,48}},
--		{"labelX","labPayGold","1000",{544/2-16,-462+92,20,1,"LC","numWhite"}},
--		{"labelX","labHireNum","0",{544-58,-462+92,20,1,"LC","numWhite"}},
--		{"label","labHireTip",hVar.tab_string["__TEXT_HireCount"],{544-160,-462+92,24,1,"LC",hVar.FONTC}},
--		{"button","btnConfirm","UI:ButtonBack",{544/2,-462+32,128,42,0.95},function()return _CODE_ConfirmOnHero()end},
--		{"button","btnShowRevive","UI:ButtonBack2",{82,-176,128,36,0.95},function()return _CODE_UpdateHeroList("revive",1)end},
--		{"button","btnShowHire","UI:ButtonBack2",{82+136,-176,128,36,0.95},function()return _CODE_UpdateHeroList("hire",1)end},
--	}
--
--	hGlobal.UI.HeroReviveFrame = hUI.frame:new({
--		x = _HRF_FrmXYWH[1],
--		y = _HRF_FrmXYWH[2],
--		w = _HRF_FrmXYWH[3],
--		h = _HRF_FrmXYWH[4],
--		closebtn = "BTN:PANEL_CLOSE",
--		closebtnX = 534,
--		closebtnY = -14,
--		--changed by pangyong 2015/3/30
--		dragable = 3,
--		show = 0,
--		codeOnClose = function()
--			_CODE_UpdateHeroList(nil)
--			hApi.SetObjectEx(_HRF_oBuilding,nil)
--			hApi.safeRemoveT(_childUI,"imgCurBuilding")
--		end,
--	})
--	_FrmBG = hGlobal.UI.HeroReviveFrame
--	_childUI = _FrmBG.childUI
--
--	hUI.CreateMultiUIByParam(_FrmBG,0,0,_HRF_UIList,_HRF_UIHandle,hUI.MultiUIParamByFrm(_FrmBG))
--
--	_childUI["btnConfirm"]:loadlabel({text=hVar.tab_string["__TEXT_Employ"],font=hVar.FONTC,border=1})
--	_HRF_UIHandle["labConfirmHire"] = _childUI["btnConfirm"].childUI["label"]
--	_childUI["btnConfirm"].childUI["label"] = nil
--	_childUI["btnConfirm"]:loadlabel({text=hVar.tab_string["__TEXT_Revive"],font=hVar.FONTC,border=1})
--	_HRF_UIHandle["labConfirmRevive"] = _childUI["btnConfirm"].childUI["label"]
--	_childUI["btnConfirm"].childUI["label"] = nil
--
--	_childUI["btnShowRevive"]:loadlabel({text=hVar.tab_string["Hero_Revive"],font=hVar.FONTC,border=1})
--	_childUI["btnShowRevive"].childUI["icon"] = hUI.image:new({
--		parent = _childUI["btnShowRevive"].handle._n,
--		model = "UI:Button_SelectBorder",
--		w = _childUI["btnShowRevive"].data.w+4,
--		h = _childUI["btnShowRevive"].data.h+4,
--		z = -1,
--	})
--
--	_childUI["btnShowHire"]:loadlabel({text=hVar.tab_string["Hero_Hire"],font=hVar.FONTC,border=1})
--	_childUI["btnShowHire"].childUI["icon"] = hUI.image:new({
--		parent = _childUI["btnShowHire"].handle._n,
--		model = "UI:Button_SelectBorder",
--		w = _childUI["btnShowHire"].data.w+4,
--		h = _childUI["btnShowHire"].data.h+4,
--		z = -1,
--	})
--
--	-------------------------------
--	-- 事件
--	-------------------------------
--	--观看世界的时候关闭复活面板
--	hGlobal.event:listen("LocalEvent_PlayerFocusWorld","__UI__HideHeroReviveFrm",function(sSceneType,oWorld,oMap)
--		if sSceneType=="worldmap" then
--			_FrmBG:show(0)
--			_FrmBG.data.codeOnClose()
--		end
--	end)
--	-------------------------------
--	--监测英雄移动到达酒馆事件
--	hGlobal.event:listen("Event_UnitArrive","__WM__HeroVisitHostel",function(oWorld,oUnit,gridX,gridY,oTarget,nOperate,nOperateId)
--		if oWorld.data.type=="worldmap" then
--			if oTarget~=nil and nOperate == hVar.OPERATE_TYPE.HERO_REVIVE and oUnit:getowner()==hGlobal.LocalPlayer then
--				hGlobal.event:event("LocalEvent_PlayerReviveHero",hVar.OPERATE_TYPE.HERO_REVIVE,oWorld,oUnit,oTarget,oTarget)
--			end
--		end
--	end)
--	-------------------------------
--	--本地玩家打开英雄复活面板事件
--	hGlobal.event:listen("LocalEvent_PlayerReviveHero","__UI_CallHotel",function(opr,w,oUnit,oBuilding,oTarget)
--		local sWelcomeText = "hostel!"
--		if hVar.tab_stringM["HOSTEL_WELCOME"] then
--			local v = hVar.tab_stringM["HOSTEL_WELCOME"]
--			sWelcomeText = v[hApi.random(1,#v)]
--		end
--		_childUI["labHostelTittle"]:setText(sWelcomeText,2)
--		hApi.SetObjectEx(_HRF_oBuilding,oBuilding)
--		hApi.safeRemoveT(_childUI,"imgCurBuilding")
--		if oBuilding then
--			local x,y = _HRF_UIHandle["imgHostelSlot"]:getPosition()
--			_childUI["imgCurBuilding"] = hUI.thumbImage:new({
--				parent = _FrmBG.handle._n,
--				id = oBuilding.data.id,
--				facing = 180,
--				x = x,
--				y = y,
--				w = 72,
--				h = 72,
--				z = 5,
--			})
--		end
--		if hGlobal.LocalPlayer and type(hGlobal.LocalPlayer.data.hirelist)=="table" then
--			_childUI["btnShowRevive"]:setstate(1)
--			_childUI["btnShowHire"]:setstate(1)
--			if _CODE_UpdateHeroList("revive")==0 then
--				_CODE_UpdateHeroList("hire")
--			end
--		else
--			_childUI["btnShowRevive"]:setstate(1)
--			_childUI["btnShowHire"]:setstate(-1)
--			_CODE_UpdateHeroList("revive")
--		end
--		_FrmBG:show(1)
--		_FrmBG:active()
--	end)
--	-------------------------------
--	--本地玩家的英雄复活后，刷新复活面板
--	hGlobal.event:listen("Event_HeroRevive","__UI_RefreshHotel",function(oWorld,oHero,oUnit,oBuilding,gridX,gridY)
--		if _FrmBG.data.show~=1 then
--			return
--		end
--		if oHero:getowner()==hGlobal.LocalPlayer then
--			_childUI["btnShowRevive"]:setstate(1)
--			_childUI["btnShowHire"]:setstate(1)
--			if _CODE_UpdateHeroList("revive")==0 then
--				local _,nReviveCount = _CODE_UpdateHeroList("hire")
--				if nReviveCount==0 then
--					_FrmBG:show(0)
--					_FrmBG.data.codeOnClose()
--				end
--			end
--		end
--	end)
--	--------------------------------
--	--功能函数
--	--------------------------------
--	local _code_ChooseHeroByIndex = function(nIndex,tOpr)
--		if tOpr~=_HRF_ChoosedOpr then
--			_HRF_ChoosedOpr = tOpr
--			local sOpr = tOpr[2]
--			local nCost = tOpr[3]
--			_childUI["labPayGold"]:setText(tostring(nCost),2)
--			if hGlobal.LocalPlayer:getresource(hVar.RESOURCE_TYPE.GOLD)>=nCost then
--				if sOpr=="show" then
--					_childUI["btnConfirm"]:setstate(0)
--				else
--					_childUI["btnConfirm"]:setstate(1)
--				end
--				_childUI["labPayGold"].handle.s:setColor(ccc3(255,255,255))
--			else
--				_childUI["btnConfirm"]:setstate(0)
--				_childUI["labPayGold"].handle.s:setColor(ccc3(255,0,0))
--			end
--			for i = 1,#_HRF_GridIconXY do
--				local oBtn = _childUI["btnHeroPay_"..i]
--				if oBtn then
--					if i==nIndex then
--						oBtn.childUI["icon"].handle._n:setVisible(true)
--					else
--						oBtn.childUI["icon"].handle._n:setVisible(false)
--					end
--				end
--			end
--		end
--	end
--	local _code_AddHeroBtnByList = function(tList)
--		_HRF_ChoosedOpr = nil
--		local nNumMax = #_HRF_GridIconXY
--		local nRemoveCount = 0
--		for i = 1,nNumMax do
--			if _childUI["btnHeroPay_"..i]~=nil then
--				nRemoveCount = nRemoveCount + 1
--				hApi.safeRemoveT(_childUI,"btnHeroPay_"..i)
--			end
--			hApi.safeRemoveT(_childUI,"labHeroName_"..i)
--		end
--		if nRemoveCount>0 then
--			_childUI["dragBox"]:sortbutton()
--		end
--		if not(type(tList)=="table" and #tList>0) then
--			return
--		end
--		local nCount = math.min(#tList,nNumMax)
--		local tPos = _HRF_GridIconXY[nCount]
--		for i = 1,nCount do
--			local id = tList[i][1]
--			local tHero = tList[i][4]
--			local tLabel
--			if type(tHero)=="table" then
--				local oHero = hApi.GetObjectEx(hClass.hero,tHero)
--				if oHero then
--					tLabel = {
--						text = "", --geyachao: 不显示英雄等级 "lv"..tostring(oHero.attr.level),
--						font = "numBlue",
--						x = -2,
--						y = -36,
--						size = 14,
--						align = "RB",
--					}
--				end
--			end
--			_childUI["btnHeroPay_"..i] = hUI.button:new({
--				parent = _FrmBG,
--				x = tPos[i][1],
--				y = tPos[i][2],
--				model = hVar.tab_unit[id].icon,
--				w = 72,
--				h = 72,
--				scaleT = 0.95,
--				label = tLabel,
--				icon = "UI:Button_SelectBorder",
--				iconWH = 76,
--				codeOnTouch = function()
--					_code_ChooseHeroByIndex(i,tList[i])
--				end,
--			})
--			_childUI["labHeroName_"..i] = hUI.label:new({
--				parent = _FrmBG.handle._n,
--				x = tPos[i][1],
--				y = tPos[i][2]-56,
--				align = "MC",
--				size = 24,
--				text = hVar.tab_stringU[id][1] or "unit_"..id,
--				font = hVar.FONTC,
--				border = 1,
--			})
--		end
--	end
--	_CODE_UpdateHeroList = function(mode,IsFromClick)
--		if IsFromClick==1 and mode==_HRF_PageState then
--			return
--		end
--		_HRF_PageState = mode
--		_code_AddHeroBtnByList(nil)
--		_childUI["btnConfirm"].childUI["label"] = nil
--		_childUI["btnConfirm"]:setstate(-1)
--		local oWorld = hGlobal.WORLD.LastWorldMap
--		if oWorld==nil then
--			return
--		end
--		if mode=="revive" then
--			_childUI["btnShowRevive"].childUI["icon"].handle.s:setVisible(true)
--			_childUI["btnShowHire"].childUI["icon"].handle.s:setVisible(false)
--			_HRF_UIHandle["labHireTip"]:setVisible(false)
--			_childUI["labHireNum"].handle._n:setVisible(false)
--			_HRF_UIHandle["labConfirmHire"].handle._n:setVisible(false)
--			_HRF_UIHandle["labConfirmRevive"].handle._n:setVisible(true)
--			_childUI["btnConfirm"].childUI["label"] = _HRF_UIHandle["labConfirmRevive"]
--			local tReviveCost = hApi.GetHeroReviveCost(oWorld)
--			local nReviveCount = 0
--			local tList = {}
--			if hGlobal.LocalPlayer then
--				for i = 1,#hGlobal.LocalPlayer.heros do
--					local oHero = hGlobal.LocalPlayer.heros[i]
--					if type(oHero)=="table" and oHero.data.IsDefeated==1 and oHero.data.HeroTeamLeader==0 then
--						local id = oHero.data.id
--						local tHero = hApi.SetObjectEx({},oHero)
--						local nCost = tReviveCost[oHero.attr.level] or tReviveCost[#tReviveCost]
--						tList[#tList+1] = {id,"revive",nCost,tHero}
--					end
--				end
--				_code_AddHeroBtnByList(tList)
--			end
--			if _childUI["btnHeroPay_1"] then
--				_childUI["btnConfirm"]:setstate(1)
--				_childUI["btnHeroPay_1"].data.codeOnTouch()
--				return #tList,nReviveCount
--			else
--				_childUI["btnConfirm"]:setstate(0)
--				_childUI["labPayGold"]:setText("*",2)
--				_childUI["labPayGold"].handle.s:setColor(ccc3(255,255,255))
--				return 0,nReviveCount
--			end
--		elseif mode=="hire" then
--			_childUI["btnShowRevive"].childUI["icon"].handle.s:setVisible(false)
--			_childUI["btnShowHire"].childUI["icon"].handle.s:setVisible(true)
--			_HRF_UIHandle["labConfirmHire"].handle._n:setVisible(true)
--			_HRF_UIHandle["labConfirmRevive"].handle._n:setVisible(false)
--			_childUI["btnConfirm"].childUI["label"] = _HRF_UIHandle["labConfirmHire"]
--			local nHireCount = 0
--			local tList = {}
--			if hGlobal.LocalPlayer and type(hGlobal.LocalPlayer.data.hirelist)=="table" then
--				local tHireList = hGlobal.LocalPlayer.data.hirelist
--				nHireCount = tHireList[2]-tHireList[1]
--				local tHireCost = hApi.GetHeroHireCost(oWorld)
--				local nCost = tHireCost[tHireList[1]+1] or tHireCost[#tHireCost]
--				for i = 3,#tHireList do
--					local id = tHireList[i]
--					if id~=0 and hVar.tab_unit[id] and hVar.tab_unit[id].type==hVar.UNIT_TYPE.HERO then
--						if nHireCount>0 then
--							tList[#tList+1] = {id,"hire",nCost}
--						else
--							tList[#tList+1] = {id,"show",nCost}
--						end
--					end
--				end
--				_code_AddHeroBtnByList(tList)
--			end
--			_HRF_UIHandle["labHireTip"]:setVisible(true)
--			_childUI["labHireNum"].handle._n:setVisible(true)
--			_childUI["labHireNum"]:setText(tostring(nHireCount),2)
--			if _childUI["btnHeroPay_1"] then
--				_childUI["btnConfirm"]:setstate(1)
--				_childUI["btnHeroPay_1"].data.codeOnTouch()
--				return #tList,nHireCount
--			else
--				_childUI["btnConfirm"]:setstate(0)
--				_childUI["labPayGold"]:setText("*",2)
--				_childUI["labPayGold"].handle.s:setColor(ccc3(255,255,255))
--				return 0,nHireCount
--			end
--		end
--	end
--	_CODE_ConfirmOnHero = function()
--		if type(_HRF_ChoosedOpr)~="table" then
--			return
--		end
--		local oBuilding = hApi.GetObjectEx(hClass.unit,_HRF_oBuilding)
--		if oBuilding==nil then
--			return
--		end
--		local oWorld = oBuilding:getworld()
--		if oWorld==nil then
--			return
--		end
--		local id,sOpr,nCost,tHero = unpack(_HRF_ChoosedOpr)
--		if sOpr=="hire" then
--			hApi.PlaySound("pay_gold")
--			hGlobal.LocalPlayer:order(oWorld,hVar.OPERATE_TYPE.HERO_REVIVE,oBuilding,hVar.ZERO,id)
--		elseif sOpr=="revive" then
--			hApi.PlaySound("pay_gold")
--			if type(tHero)=="table" then
--				local oHero = hApi.GetObjectEx(hClass.hero,tHero)
--				if oHero and oHero.data.IsDefeated==1 then
--					hGlobal.LocalPlayer:order(oWorld,hVar.OPERATE_TYPE.HERO_REVIVE,oBuilding,hVar.ZERO,oHero)
--				end
--			end
--		end
--	end
--end