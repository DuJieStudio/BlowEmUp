










--创建主城引导点将台、穿装备、升级技能
function CreateGuideFrame_HeroFrm()
	local GUIDE_TOWER1_POS_X = 900 --第一个塔基x坐标
	local GUIDE_TOWER1_POS_Y = 516 --第一个塔基y坐标
	
	--主城引导点将台、穿装备、升级技能
	hGlobal.UI.GuideHeroFrmStateType =
	{
		NONE = 0, --初始状态
		GUIDE_CLICK_DIANJIANGTAI = 1, --提示点击点将台
		GUIDE_WAIT_CLICK_DIANJIANGTAI = 2, --等待点击点将台按钮
		GUIDE_WAIT_CLICK_YINGXIONGLING = 3, --提示点击英雄令分页
		GUIDE_HERO_UI_INTRODUCE = 4, --提示英雄界面介绍
		GUIDE_HERO_EQIPMENT_INTRODUCE = 5, --提示英雄穿装备
		GUIDE_CLICK_SKILL_BUTTON = 6, --提示点击第一个技能按钮
		GUIDE_CLICK_LVUP_BUTTON = 7, --提示点击技能升级按钮
		GUIDE_CLICK_CLOSE_HERO_UI = 8, --提示关闭英雄界面
		GUIDE_END = 9, --引导结束
	}
	
	--引导的当前状态
	hGlobal.UI.GuideHeroFrmState = hGlobal.UI.GuideHeroFrmStateType.NONE --一开始为初始状态 --flag1 GUIDE_END  NONE   flag1
	
	--test: 重复测试，删除前一个控件
	if hGlobal.UI.GuideDJTHandEffect then --提示点击点将台的手的特效
		hGlobal.UI.GuideDJTHandEffect:del()
		hGlobal.UI.GuideDJTHandEffect = nil
	end
	if hGlobal.UI.GuideDJTRoundEffect then --提示点击点将台的转圈圈特效
		hGlobal.UI.GuideDJTRoundEffect:del()
		hGlobal.UI.GuideDJTRoundEffect = nil
	end
	if hGlobal.UI.GuideClickJYXLPageHandEffect then --提示点击英雄令分页按钮的手的特效
		hGlobal.UI.GuideClickJYXLPageHandEffect:del()
		hGlobal.UI.GuideClickJYXLPageHandEffect = nil
	end
	if hGlobal.UI.GuideClickYXLPageBtnRoundEffect then --提示点击英雄令分页按钮的转圈圈特效
		hGlobal.UI.GuideClickYXLPageBtnRoundEffect:del()
		hGlobal.UI.GuideClickYXLPageBtnRoundEffect = nil
	end
	if hGlobal.UI.GuideClickHeroCardHandEffect then --提示点击英雄卡片的手的特效
		hGlobal.UI.GuideClickHeroCardHandEffect:del()
		hGlobal.UI.GuideClickHeroCardHandEffect = nil
	end
	if hGlobal.UI.GuideClickHeroCardRoundEffect then --提示点击英雄卡片的转圈圈特效
		hGlobal.UI.GuideClickHeroCardRoundEffect:del()
		hGlobal.UI.GuideClickHeroCardRoundEffect = nil
	end
	hApi.safeRemoveT(hGlobal.UI.HeroCardNewFrm.childUI, "btnSkillLvUp_Fake") --英雄详细界面积分升级按钮（假的）（挡操作用）
	hApi.safeRemoveT(hGlobal.UI.HeroCardNewFrm.childUI, "btnStarLvUp_Fake") --英雄详细界面升星按钮（假的）（挡操作用）
	hApi.safeRemoveT(hGlobal.UI.HeroCardNewFrm.childUI, "btnClose_Fake") --英雄详细界面关闭按钮（假的）（挡操作用）
	hApi.safeRemoveT(hGlobal.UI.HeroCardNewFrm.childUI, "playerbag_table_R_Fake") --英雄详细界面翻页按钮下（假的）（挡操作用）
	hApi.safeRemoveT(hGlobal.UI.HeroCardNewFrm.childUI, "playerbag_table_L_Fake") --英雄详细界面翻页按钮上（假的）（挡操作用）
	if hGlobal.UI.GuideClickItemRoundEffect then --提示选取道具转圈圈特效
		hGlobal.UI.GuideClickItemRoundEffect:del()
		hGlobal.UI.GuideClickItemRoundEffect = nil
	end
	if hGlobal.UI.GuideClickItemHandEffect then --提示选取道具的手的特效
		hGlobal.UI.GuideClickItemHandEffect:del()
		hGlobal.UI.GuideClickItemHandEffect = nil
	end
	hApi.safeRemoveT(hGlobal.UI.HeroCardNewFrm.childUI, "btnItem_Fake") --英雄详细界面道具按钮（假的）（挡操作用）
	hApi.safeRemoveT(hGlobal.UI.HeroCardNewFrm.childUI, "btnSkill_Fake") --英雄详细界面技能按钮（假的）（挡操作用）
	if hGlobal.UI.GuideClickSkillRoundEffect then --提示点击第一个技能图标的转圈圈特效
		hGlobal.UI.GuideClickSkillRoundEffect:del()
		hGlobal.UI.GuideClickSkillRoundEffect = nil
	end
	if hGlobal.UI.GuideClickSkillHandEffect then --提示点击第一个技能图标的手特效
		hGlobal.UI.GuideClickSkillHandEffect:del()
		hGlobal.UI.GuideClickSkillHandEffect = nil
	end
	hApi.safeRemoveT(hGlobal.UI.HeroCardNewFrm.childUI, "btnSkillLvUp_FakeGuide") --英雄详细界面积分升级按钮（假的）（引导用）
	if hGlobal.UI.GuideLvUpSkillRoundEffect then --提示点击技能升级按钮的转圈圈特效
		hGlobal.UI.GuideLvUpSkillRoundEffect:del()
		hGlobal.UI.GuideLvUpSkillRoundEffect = nil
	end
	if hGlobal.UI.GuideLvUpSkillHandEffect then --提示点击技能升级按钮的手的特效
		hGlobal.UI.GuideLvUpSkillHandEffect:del()
		hGlobal.UI.GuideLvUpSkillHandEffect = nil
	end
	hApi.safeRemoveT(hGlobal.UI.HeroCardNewFrm.childUI, "btnSkillLvUp_Fake2") --英雄详细界面积分升级按钮（假的）（挡操作用）
	hApi.safeRemoveT(hGlobal.UI.HeroCardNewFrm.childUI, "btnClose_Fake2") --英雄详细界面关闭按钮（假的）（引导用）
	if hGlobal.UI.GuideCloseHeroRoundEffect then --提示点击关闭按钮的转圈圈特效
		hGlobal.UI.GuideCloseHeroRoundEffect:del()
		hGlobal.UI.GuideCloseHeroRoundEffect = nil
	end
	if hGlobal.UI.GuideCloseHeroHandEffect then --提示点击关闭按钮的手的特效
		hGlobal.UI.GuideCloseHeroHandEffect:del()
		hGlobal.UI.GuideCloseHeroHandEffect = nil
	end
	
	if hGlobal.UI.GuideSelectHeroFrmMenuBar then --引导升级塔高级技能的
		hGlobal.UI.GuideSelectHeroFrmMenuBar:del()
		hGlobal.UI.GuideSelectHeroFrmMenuBar = nil
	end
	
	--创建引导英雄界面的引导主界面
	--创建父容器
	hGlobal.UI.GuideSelectHeroFrmMenuBar = hUI.frame:new({
		x = 0,
		y = 0,
		w = hVar.SCREEN.w,
		h = hVar.SCREEN.h,
		--z = -1,
		show = 1,
		dragable = 2,
		--buttononly = 1,
		autoactive = 0,
		--background = "UI:PANEL_INFO_MINI",
		failcall = 1, --出按钮区域抬起也会响应事件
		
		--点击事件（有可能在控件外部点击）
		codeOnDragEx = function(screenX, screenY, touchMode)
			--print("codeOnDragEx", screenX, screenY, touchMode)
			if (touchMode == 0) then --按下
				--
			elseif (touchMode == 1) then --滑动
				--
			elseif (touchMode == 2) then --抬起
				--点击引导第二关界面事件
				--local worldX, worldY = hApi.view2world(screenX, hVar.SCREEN.h - screenY) --大地图的坐标
				OnClickGuideHeroFrmFrame_Event(screenX, screenY)
			end
		end
	})
	hGlobal.UI.GuideSelectHeroFrmMenuBar:active() --最前端显示
	
	--点击引导英雄点将台的事件
	function OnClickGuideHeroFrmFrame_Event(clickScreenX, clickScreenY)
		if (hGlobal.UI.GuideHeroFrmState == hGlobal.UI.GuideHeroFrmStateType.NONE) then --初始状态
			--geyachao: 标记当前正在引导中
			hVar.IS_IN_GUIDE_STATE = 1
			--print("XXXXXXXXXXXXXXX -----> hVar.IS_IN_GUIDE_STATE = 1, 点击引导英雄界面")
			
			--进入下个状态: 开场简介
			hGlobal.UI.GuideHeroFrmState = hGlobal.UI.GuideHeroFrmStateType.GUIDE_CLICK_DIANJIANGTAI
			
			--显示对话框：引导提示点将台
			__Dialogue_GuideHeroFrm_DianJiangTaiIntroduce()
		elseif (hGlobal.UI.GuideHeroFrmState == hGlobal.UI.GuideHeroFrmStateType.GUIDE_CLICK_DIANJIANGTAI) then --提示点击点将台
			--[[
			--找到点将台角色
			local oMap = __G_MainMenuWorld --主界面地图
			local tAllChaHandle = oMap.data.chaHandle
			local djtTypeId = 60001 --点将台角色类型id
			local tChaDianJiangTaiHandle = nil --点将台单位
			local battleworldX, battleworldY = 0, 0
			for i = 1, #tAllChaHandle, 1 do
				local tChaHandle = tAllChaHandle[i]
				local typeId = tChaHandle.data.id
				local worldX = tChaHandle.data.worldX
				local worldY = tChaHandle.data.worldY
				
				if (typeId == djtTypeId) then
					battleworldX = worldX
					battleworldY = worldY
					tChaDianJiangTaiHandle = tChaHandle
					break
				end
			end
			
			local towerScreenX, towerScreenY = hApi.world2view(battleworldX, battleworldY) --屏幕坐标
			
			--创建提示点击点将台按钮的手特效
			hGlobal.UI.GuideDJTHandEffect = hUI.image:new({
				parent = hGlobal.UI.GuideSelectHeroFrmMenuBar.handle._n,
				model = "MODEL_EFFECT:Hand",
				x = towerScreenX + 35,
				y = towerScreenY + 95,
				scale = 1.5,
				z = 100,
			})
			--hGlobal.UI.GuideDJTHandEffect.handle.s:setColor(ccc3(255, 255, 0))
			
			
			--点将台单位描边
			local program = hApi.getShader("outline")
			tChaDianJiangTaiHandle.s:setShaderProgram(program)
			local act1 = CCFadeTo:create(0.5, 168)
			local act2 = CCFadeTo:create(0.5, 255)
			local sequence = CCSequence:createWithTwoActions(act1, act2)
			tChaDianJiangTaiHandle.s:runAction(CCRepeatForever:create(sequence))
			]]
			--创建提示点击点将台按钮的转圈圈特效
			hGlobal.UI.GuideDJTRoundEffect = hUI.image:new({
				parent = hGlobal.UI.GuideSelectHeroFrmMenuBar.handle._n,
				model = "MODEL_EFFECT:strengthen",
				x = hVar.SCREEN.w - 60,
				y = 65 + 5, --统一调整底部条y坐标
				--w = 90,
				--h = 90,
				--scale = 2.2,
				w = 100,
				h = 100,
				scale = 1.0,
				z = 100,
			})
			hGlobal.UI.GuideDJTRoundEffect.handle.s:setColor(ccc3(0, 255, 0)) --绿色
			hGlobal.UI.GuideDJTRoundEffect.handle.s:setOpacity(0) --geyachao: 应x3的邪恶需求，换个特效
			local decal, count = 11, 0 --光晕效果
			local r, g, b, parent = 150, 128, 64
			local parent = hGlobal.UI.GuideDJTRoundEffect.handle._n
			local offsetX, offsetY, duration, scale = 32, 30, 0.4, 1.05
			local nnn = xlAddNormalLightEffect(decal,count,offsetX,offsetY,duration,scale,r,g,b,parent)
			nnn:setScale(2.3)
			
			--创建提示点击点将台按钮的手特效
			hGlobal.UI.GuideDJTHandEffect = hUI.image:new({
				parent = hGlobal.UI.GuideSelectHeroFrmMenuBar.handle._n,
				model = "MODEL_EFFECT:Hand",
				x = hVar.SCREEN.w - 60,
				y = 65 + 40 + 5, --统一调整底部条y坐标
				scale = 1.5,
				z = 100,
			})
			--hGlobal.UI.GuideDJTHandEffect.handle.s:setColor(ccc3(255, 255, 0))
			
			--进入下个状态: 等待点击点将台按钮
			hGlobal.UI.GuideHeroFrmState = hGlobal.UI.GuideHeroFrmStateType.GUIDE_WAIT_CLICK_DIANJIANGTAI
			
			--显示对话框：引导主城英雄界面点击点将台按钮
			__Dialogue_GuideHeroFrm_Click_DianJiangTai()
			
			--geyachao: 无主城模式（因为有可能不响应frame点击事件，按钮在最顶层，只能监听到按钮点击事件，所以这里特殊处理一下）
			--监听英雄界面打开事件
			hGlobal.event:listen("LocalEvent_Click_Guide_HeroButton", "GuideOpenPhoneMyHerocar", function()
				--print("删除引导主界面")
				--删除监听事件
				hGlobal.event:listen("LocalEvent_Click_Guide_HeroButton", "GuideOpenPhoneMyHerocar", nil)
				
				--强制跳转到下个状态
				local bx = hVar.SCREEN.w - 60
				local by = 65 + 5 --统一调整底部条y坐标
				local w = 90
				local h = 90
				local button_left = bx - w / 2 --英雄选中区域的最左侧
				local button_right = bx + w / 2 --英雄选中区域的最右侧
				local button_top = by - h / 2 --英雄选中区域的最上侧
				local button_bottom = by + h / 2 --英雄选中区域的最下侧
				OnClickGuideHeroFrmFrame_Event((button_left + button_right) / 2, (button_top + button_bottom) / 2)
			end)
		elseif (hGlobal.UI.GuideHeroFrmState == hGlobal.UI.GuideHeroFrmStateType.GUIDE_WAIT_CLICK_DIANJIANGTAI) then --提示点击点将台按钮
			--[[
			--检测是否点击到了点将台按钮
			local worldX, worldY = hApi.view2world(clickScreenX, hVar.SCREEN.h - clickScreenY) --大地图的坐标
			local oMap = __G_MainMenuWorld --主界面地图
			local tChaDianJiangTaiHandle = oMap:hit2cha(worldX, worldY)
			local djtTypeId = 60001 --点将台角色类型id
			if tChaDianJiangTaiHandle then
				if (tChaDianJiangTaiHandle.data.id == djtTypeId) then
			]]
			local bx = hVar.SCREEN.w - 60
			local by = 75
			local w = 90
			local h = 90
			local button_left = bx - w / 2 --英雄选中区域的最左侧
			local button_right = bx + w / 2 --英雄选中区域的最右侧
			local button_top = by - h / 2 --英雄选中区域的最上侧
			local button_bottom = by + h / 2 --英雄选中区域的最下侧
			
			if true then
				--检测是否点击到了点将台按钮
				if (clickScreenX >= button_left) and (clickScreenX <= button_right) and (clickScreenY >= button_top) and (clickScreenY <= button_bottom) then
					--删除提示点击点将台按钮的手特效
					if hGlobal.UI.GuideDJTHandEffect then --点击点将台的手的特效
						hGlobal.UI.GuideDJTHandEffect:del()
						hGlobal.UI.GuideDJTHandEffect = nil
					end
					
					--删除提示点击点将台按钮的转圈圈特效
					if hGlobal.UI.GuideDJTRoundEffect then --点击点将台的手的特效
						hGlobal.UI.GuideDJTRoundEffect:del()
						hGlobal.UI.GuideDJTRoundEffect = nil
					end
					
					--[[
					--geyachao: 旧版有主城模式
					--停止点将台单位的运动
					tChaDianJiangTaiHandle.s:stopAllActions()
					--剧情战役单位不描边
					local program = hApi.getShader("normal")
					tChaDianJiangTaiHandle.s:setShaderProgram(program)
					
					
					--在显示完英雄卡牌后再重新创建主界面（为了覆盖到最前面）
					--监听显示英雄列表面板事件
					hGlobal.event:listen("LocalEvent_Phone_ShowMyHerocard", "GuideShowPhoneMyHerocar", function()
						--print("删除引导主界面")
						--删除监听事件
						hGlobal.event:listen("LocalEvent_Phone_ShowMyHerocard", "GuideShowPhoneMyHerocar", nil)
					]]
					--geyachao: 无主城模式的新流程
					hGlobal.event:event("LocalEvent_Phone_ShowMyHerocard")
					
					--删除监听事件
					hGlobal.event:listen("LocalEvent_Click_Guide_HeroButton", "GuideOpenPhoneMyHerocar", nil)
					
					--删除引导主界面
					if hGlobal.UI.GuideSelectHeroFrmMenuBar then
						hGlobal.UI.GuideSelectHeroFrmMenuBar:del()
						hGlobal.UI.GuideSelectHeroFrmMenuBar = nil
					end
					
					--重新创建父容器
					hGlobal.UI.GuideSelectHeroFrmMenuBar = hUI.frame:new({
						x = 0,
						y = 0,
						z = 100,
						w = hVar.SCREEN.w,
						h = hVar.SCREEN.h,
						--z = -1,
						show = 1,
						dragable = 2,
						--buttononly = 1,
						autoactive = 0,
						--background = "UI:PANEL_INFO_MINI",
						failcall = 1, --出按钮区域抬起也会响应事件
						
						--点击事件（有可能在控件外部点击）
						codeOnDragEx = function(screenX, screenY, touchMode)
							--print("codeOnDragEx", screenX, screenY, touchMode)
							if (touchMode == 0) then --按下
								--
							elseif (touchMode == 1) then --滑动
								--
							elseif (touchMode == 2) then --抬起
								--点击引导第二关界面事件
								--local worldX, worldY = hApi.view2world(screenX, hVar.SCREEN.h - screenY) --大地图的坐标
								OnClickGuideHeroFrmFrame_Event(screenX, screenY)
							end
						end
					})
					hGlobal.UI.GuideSelectHeroFrmMenuBar:active() --最前端显示
					
					--创建提示点击英雄令分页按钮的转圈圈特效
					hGlobal.UI.GuideClickYXLPageBtnRoundEffect = hUI.image:new({
						parent = nil,
						model = "MODEL_EFFECT:strengthen",
						x = hVar.SCREEN.w / 2 - 800 / 2 + 120 + 140 - 150,
						y = hVar.SCREEN.h / 2 + 550 / 2 - 20 - 18,
						--w = 200,
						--h = 70,
						--scale = 1.2,
						w = 100,
						h = 100,
						scale = 1,
						z = 100,
					})
					hGlobal.UI.GuideClickYXLPageBtnRoundEffect.handle.s:setColor(ccc3(0, 255, 0)) --绿色
					hGlobal.UI.GuideClickYXLPageBtnRoundEffect.handle.s:setOpacity(0) --geyachao: 应x3的邪恶需求，换个特效
					local decal, count = 11, 0 --光晕效果
					local r, g, b, parent = 150, 128, 64
					local parent = hGlobal.UI.GuideClickYXLPageBtnRoundEffect.handle._n
					local offsetX, offsetY, duration, scale = 32, 30, 0.4, 1.05
					local nnn = xlAddNormalLightEffect(decal,count,offsetX,offsetY,duration,scale,r,g,b,parent)
					nnn:setScale(1.3)
					
					--创建提示点击英雄令分页按钮的手特效
					hGlobal.UI.GuideClickJYXLPageHandEffect = hUI.image:new({
						parent = nil,
						model = "MODEL_EFFECT:Hand",
						x = hVar.SCREEN.w / 2 - 800 / 2 + 120 + 140 - 150,
						y = hVar.SCREEN.h / 2 + 550 / 2 - 20,
						scale = 1.5,
						z = 100,
					})
					--hGlobal.UI.GuideClickJYXLPageHandEffect.handle.s:setColor(ccc3(255, 255, 0))
					
					--进入下一状态：提示点击英雄令分页按钮
					hGlobal.UI.GuideHeroFrmState = hGlobal.UI.GuideHeroFrmStateType.GUIDE_WAIT_CLICK_YINGXIONGLING
					
					--无对话
					--...
				end
			end
		elseif (hGlobal.UI.GuideHeroFrmState == hGlobal.UI.GuideHeroFrmStateType.GUIDE_WAIT_CLICK_YINGXIONGLING) then --提示点击英雄令分页按钮
			local bx = hVar.SCREEN.w / 2 - 800 / 2 + 120 + 140 - 150
			local by = hVar.SCREEN.h / 2 + 550 / 2 - 20 - 18
			local w = 200
			local h = 70
			local button_left = bx - w / 2 --英雄选中区域的最左侧
			local button_right = bx + w / 2 --英雄选中区域的最右侧
			local button_top = by - h / 2 --英雄选中区域的最上侧
			local button_bottom = by + h / 2 --英雄选中区域的最下侧
			
			--检测是否点击到了英雄令分页按钮
			if (clickScreenX >= button_left) and (clickScreenX <= button_right) and (clickScreenY >= button_top) and (clickScreenY <= button_bottom) then
				--删除提示点击英雄令分页按钮的手特效
				if hGlobal.UI.GuideClickJYXLPageHandEffect then --点击英雄令分页按钮的手特效
					hGlobal.UI.GuideClickJYXLPageHandEffect:del()
					hGlobal.UI.GuideClickJYXLPageHandEffect = nil
				end
				
				--删除提示点击英雄令分页按钮的转圈圈特效
				if hGlobal.UI.GuideClickYXLPageBtnRoundEffect then --点击英雄令分页按钮的转圈圈特效
					hGlobal.UI.GuideClickYXLPageBtnRoundEffect:del()
					hGlobal.UI.GuideClickYXLPageBtnRoundEffect = nil
				end
				
				--模拟点击英雄令分页
				local _frm = hGlobal.UI.Phone_MyHeroCardFrm_New
				_frm.childUI["PageBtn1"].data.code()
				
				--创建提示点击英雄卡牌的转圈圈特效
				hGlobal.UI.GuideClickHeroCardRoundEffect = hUI.image:new({
					parent = nil,
					model = "MODEL_EFFECT:strengthen",
					x = hVar.SCREEN.w / 2 - 440 + 120,
					y = hVar.SCREEN.h / 2 + 240 - 147,
					--w = 150,
					--h = 200,
					--scale = 2.2,
					w = 100,
					h = 100,
					scale = 1.0,
					z = 100,
				})
				hGlobal.UI.GuideClickHeroCardRoundEffect.handle.s:setColor(ccc3(0, 255, 0)) --绿色
				hGlobal.UI.GuideClickHeroCardRoundEffect.handle.s:setOpacity(0) --geyachao: 应x3的邪恶需求，换个特效
				local decal, count = 11, 0 --光晕效果
				local r, g, b, parent = 150, 128, 64
				local parent = hGlobal.UI.GuideClickHeroCardRoundEffect.handle._n
				local offsetX, offsetY, duration, scale = 30, 30, 0.4, 1.05
				local nnn = xlAddNormalLightEffect(decal,count,offsetX,offsetY,duration,scale,r,g,b,parent)
				nnn:setScale(2.0)
				
				--创建提示点击英雄卡牌的手特效
				hGlobal.UI.GuideClickHeroCardHandEffect = hUI.image:new({
					parent = nil,
					model = "MODEL_EFFECT:Hand",
					x = hVar.SCREEN.w / 2 - 440 + 115,
					y = hVar.SCREEN.h / 2 + 240 - 147 + 40,
					scale = 1.5,
					z = 100,
				})
				--hGlobal.UI.GuideClickHeroCardHandEffect.handle.s:setColor(ccc3(255, 255, 0))
				
				--进入下个状态: 提示英雄界面介绍
				hGlobal.UI.GuideHeroFrmState = hGlobal.UI.GuideHeroFrmStateType.GUIDE_HERO_UI_INTRODUCE
				
				--无对话
				--...
				
				--[[
				--geyachao: 旧版有主城模式
				end)
				
				--模拟执行点击大地图事件
				
				oMap.data.codeOnTouchUp(oMap, worldX, worldY, clickScreenX, clickScreenY)
				
				--进入下个状态: 提示英雄界面介绍
				--hGlobal.UI.GuideHeroFrmState = hGlobal.UI.GuideHeroFrmStateType.GUIDE_HERO_UI_INTRODUCE
				
				--无对话
				--...
				]]
			end
		elseif (hGlobal.UI.GuideHeroFrmState == hGlobal.UI.GuideHeroFrmStateType.GUIDE_HERO_UI_INTRODUCE) then --提示英雄令界面介绍
			local bx = hVar.SCREEN.w / 2 - 440 + 120
			local by = hVar.SCREEN.h / 2 + 240 - 147
			local w = 140
			local h = 180
			local button_left = bx - w / 2 --英雄选中区域的最左侧
			local button_right = bx + w / 2 --英雄选中区域的最右侧
			local button_top = by - h / 2 --英雄选中区域的最上侧
			local button_bottom = by + h / 2 --英雄选中区域的最下侧
			
			--检测是否点击到第一个卡牌
			if (clickScreenX >= button_left) and (clickScreenX <= button_right) and (clickScreenY >= button_top) and (clickScreenY <= button_bottom) then
				--模拟关闭本界面
				local _frm = hGlobal.UI.Phone_MyHeroCardFrm_New
				_frm.childUI["closeBtn"].data.code()
				
				--模拟打开英雄详细面板
				hGlobal.event:event("LocalEvent_showHeroCardFrm", 0, 18001, 0)
				
				--删除提示点击英雄卡片的手的特效
				if hGlobal.UI.GuideClickHeroCardHandEffect then
					hGlobal.UI.GuideClickHeroCardHandEffect:del()
					hGlobal.UI.GuideClickHeroCardHandEffect = nil
				end
				
				--删除提示点击英雄卡片的转圈圈特效
				if hGlobal.UI.GuideClickHeroCardRoundEffect then
					hGlobal.UI.GuideClickHeroCardRoundEffect:del()
					hGlobal.UI.GuideClickHeroCardRoundEffect = nil
				end
				
				--创建
				--删除引导主界面
				if hGlobal.UI.GuideSelectHeroFrmMenuBar then
					hGlobal.UI.GuideSelectHeroFrmMenuBar:del()
					hGlobal.UI.GuideSelectHeroFrmMenuBar = nil
				end
				
				--重新创建父容器
				hGlobal.UI.GuideSelectHeroFrmMenuBar = hUI.frame:new({
					x = 0,
					y = 0,
					z = 100,
					w = hVar.SCREEN.w,
					h = hVar.SCREEN.h,
					--z = -1,
					show = 1,
					dragable = 2,
					--buttononly = 1,
					autoactive = 0,
					--background = "UI:PANEL_INFO_MINI",
					failcall = 1, --出按钮区域抬起也会响应事件
					
					--点击事件（有可能在控件外部点击）
					codeOnDragEx = function(screenX, screenY, touchMode)
						--print("codeOnDragEx", screenX, screenY, touchMode)
						if (touchMode == 0) then --按下
							--
						elseif (touchMode == 1) then --滑动
							--
						elseif (touchMode == 2) then --抬起
							--点击引导第二关界面事件
							--local worldX, worldY = hApi.view2world(screenX, hVar.SCREEN.h - screenY) --大地图的坐标
							OnClickGuideHeroFrmFrame_Event(screenX, screenY)
						end
					end
				})
				--hGlobal.UI.GuideSelectHeroFrmMenuBar:active() --最前端显示
				
				local _frm = hGlobal.UI.HeroCardNewFrm
				local _parent = _frm.handle._n
				local _childUI = _frm.childUI
				
				--英雄详细界面积分升级按钮（假的）（挡操作用）
				_childUI["btnSkillLvUp_Fake"] = hUI.button:new({
					parent = _parent,
					model = "UI:BTN_ButtonRed", 
					animation = "normal",
					dragbox = _childUI["dragBox"],
					font = hVar.FONTC,
					border = 1,
					align = "MC",
					label = hVar.tab_string["__UPGRADE"],
					--y = -455,
					--scale = 1,
					x = 475,
					y = -490,
					scale = 1,
					scaleT = 0.99,
					code = function(self)
						--
					end,
				})
				local _btnSkillLvUpScore = _childUI["btnSkillLvUp_Fake"]
				
				--英雄详细界面关闭按钮（假的）（挡操作用）
				local _w,_h = 892, 558
				local _x,_y = hVar.SCREEN.w/2 - _w/2,hVar.SCREEN.h/2+ _h/2 - 20
				
				local closeDx = -5
				local closeDy = -5
				if (g_phone_mode ~= 0) then
					closeDx = 0
					closeDy = -20
				end
				_childUI["btnClose_Fake"] = hUI.button:new({
					parent = _frm,
					model = "BTN:PANEL_CLOSE",
					x = _w + closeDx,
					y = closeDy,
					z = 5,
					scaleT = 0.99,
					code = function(self)
						--
					end,
				})
				
				--英雄详细界面翻页按钮下（假的）（挡操作用）
				_childUI["playerbag_table_R_Fake"] = hUI.button:new({
					parent = _frm,
					model = "misc/mask.png",
					x = 873 + 20,
					y = -355,
					w = 40 + 40,
					h = 150,
					scaleT = 0.99,
					code = function(self)
						--
					end,
				})
				_childUI["playerbag_table_R_Fake"].handle.s:setOpacity(0) --翻页按钮实际响应区域，只用于控制，不显示
				--翻页按钮下图片
				_childUI["playerbag_table_R_Fake"].childUI["image"] = hUI.image:new({
					parent = _childUI["playerbag_table_R_Fake"].handle._n,
					model = "UI:playerBagD",
					x = -20,
					y = 40,
					scale = 1.0,
				})
				---英雄详细界面翻页按钮上（假的）（挡操作用）
				_childUI["playerbag_table_L_Fake"] = hUI.button:new({
					parent = _frm,
					model = "misc/mask.png",
					x = 873 + 20,
					y = -195,
					w = 40 + 40,
					h = 150,
					scaleT = 0.99,
					code = function(self)
						--
					end,
				})
				_childUI["playerbag_table_L_Fake"].handle.s:setOpacity(0) --翻页按钮实际响应区域，只用于控制，不显示
				--翻页按钮上图片
				_childUI["playerbag_table_L_Fake"].childUI["image"] = hUI.image:new({
					parent = _childUI["playerbag_table_L_Fake"].handle._n,
					model = "UI:playerBagD",
					x = -20,
					y = -40,
					scale = 1.0,
				})
				_childUI["playerbag_table_L_Fake"].childUI["image"] .handle.s:setFlipX(true)
				_childUI["playerbag_table_L_Fake"].childUI["image"] .handle._n:setRotation(180)
				
				--获得英雄当前装备了几个装备
				local heroEquippedNum = 0
				local HeroCard = hApi.GetHeroCardById(18001)
				if HeroCard and (type(HeroCard) == "table") and HeroCard.equipment and (type(HeroCard.equipment) == "table") then
					for k = 1, #HeroCard.equipment, 1 do
						--存档里的装备表
						local item = HeroCard.equipment[k]
						
						if (type(item) == "table") then
							local item_id = item[1] --道具id
							
							if (item_id ~= 0) then
								heroEquippedNum = heroEquippedNum + 1
							end
						end
					end
				end
				
				--获取道具在哪个位置
				--创建提示滑动道具的手的特效
				local xIdx = 0 --x索引值
				local yIdx = 0 --y索引值
				local itemIdx = 0 --获取第一个道具在哪个位置
				local item = LuaGetPlayerBagFromTableIndex(1)
				for k = 1, 28, 1 do
					if item[k] and (item[k] ~= 0) then
						itemIdx = k
						break
					end
				end
				if (itemIdx > 0) then
					xIdx = itemIdx % 4
					if (xIdx == 0) then
						xIdx = 4
					end
					yIdx = (itemIdx - xIdx) / 4 + 1
				end
				
				--函数：引导点击第一个技能图标的流程（因为后面有分支）
				local _CODE_GuideNext_Skill = function()
					--英雄详细界面道具按钮（假的）（挡操作用）
					_childUI["btnItem_Fake"] = hUI.button:new({
						parent = _parent,
						model = "misc/mask.png",
						dragbox = _childUI["dragBox"],
						x = _w - 267 - 87,
						y = -114 + 63,
						scale = 0.9,
						scaleT = 1.0,
						w = 200,
						h = 200,
						z = 100,
						code = function(self)
							--
						end,
					})
					_childUI["btnItem_Fake"].handle.s:setOpacity(0)
					
					--英雄详细界面技能按钮（假的）（挡操作用）
					_childUI["btnSkill_Fake"] = hUI.button:new({
						parent = _parent,
						model = "misc/mask.png",
						dragbox = _childUI["dragBox"],
						x = _w - 723 + 220 - 92,
						y = -379 + 5,
						scale = 0.9,
						scaleT = 1.0,
						w = 400,
						h = 100,
						z = 100,
						code = function(self)
							--
						end,
					})
					_childUI["btnSkill_Fake"].handle.s:setOpacity(0)
					
					--创建提示点击第一个技能图标的转圈圈特效
					hGlobal.UI.GuideClickSkillRoundEffect = hUI.image:new({
						parent = _parent,
						model = "MODEL_EFFECT:strengthen",
						x = _w - 723 - 96,
						y = -379 + 11,
						--w = 180,
						--h = 180,
						--scale = 1.0,
						w = 100,
						h = 100,
						scale = 1.0,
						z = 100,
					})
					hGlobal.UI.GuideClickSkillRoundEffect.handle.s:setColor(ccc3(0, 255, 0)) --绿色
					hGlobal.UI.GuideClickSkillRoundEffect.handle.s:setOpacity(0) --geyachao: 应x3的邪恶需求，换个特效
					local decal, count = 11, 0 --光晕效果
					local r, g, b, parent = 150, 128, 64
					local parent = hGlobal.UI.GuideClickSkillRoundEffect.handle._n
					local offsetX, offsetY, duration, scale = 30, 30, 0.4, 1.05
					local nnn = xlAddNormalLightEffect(decal,count,offsetX,offsetY,duration,scale,r,g,b,parent)
					nnn:setScale(1.6)
					
					--创建点击第一个技能图标的手特效
					hGlobal.UI.GuideClickSkillHandEffect = hUI.image:new({
						parent = _parent,
						x = _w - 723 - 96,
						y = -330,
						model = "MODEL_EFFECT:Hand",
						scale = 1.3,
						z = 100,
					})
					
					--监听点击英雄技能按钮事件
					hGlobal.event:listen("LocalEvent_ShowSkillInfo", "GuideClickSkillBtn", function(oHero, nHeroId, idx, bType, tIdx)
						--其它按钮都被挡住了，只能点到第一个按钮
						--删除监听事件
						hGlobal.event:listen("LocalEvent_ShowSkillInfo", "GuideClickSkillBtn", nil)
						
						--删除控件
						--删除提示点击第一个技能图标的转圈圈特效
						if hGlobal.UI.GuideClickSkillRoundEffect then
							hGlobal.UI.GuideClickSkillRoundEffect:del()
							hGlobal.UI.GuideClickSkillRoundEffect = nil
						end
						
						--删除点击第一个技能图标的手特效
						if hGlobal.UI.GuideClickSkillHandEffect then
							hGlobal.UI.GuideClickSkillHandEffect:del()
							hGlobal.UI.GuideClickSkillHandEffect = nil
						end
						
						--删除英雄详细界面积分升级按钮（假的）（挡操作用）
						hApi.safeRemoveT(hGlobal.UI.HeroCardNewFrm.childUI, "btnSkillLvUp_Fake")
						
						--新建一个新的英雄详细界面积分升级按钮（假的）（引导用）
						local clickSkillLvUp_Guide = nil --点击积分升级按钮（引导）的回调函数
						_childUI["btnSkillLvUp_FakeGuide"] = hUI.button:new({
							parent = _parent,
							model = "UI:BTN_ButtonRed", 
							animation = "normal",
							dragbox = _childUI["dragBox"],
							font = hVar.FONTC,
							border = 1,
							align = "MC",
							label = hVar.tab_string["__UPGRADE"],
							--y = -455,
							--scale = 1,
							x = 475,
							y = -490,
							scale = 1,
							scaleT = 0.95,
							code = function(self)
								clickSkillLvUp_Guide()
							end,
						})
						
						--创建提示点击技能升级按钮的转圈圈特效
						hGlobal.UI.GuideLvUpSkillRoundEffect = hUI.image:new({
							parent = _parent,
							model = "MODEL_EFFECT:strengthen",
							x = 415 + 65,
							y = -489,
							--w = 170,
							--h = 60,
							--scale = 2.0,
							w = 100,
							h = 100,
							scale = 1.0,
							z = 100,
						})
						hGlobal.UI.GuideLvUpSkillRoundEffect.handle.s:setColor(ccc3(0, 255, 0)) --绿色
						hGlobal.UI.GuideLvUpSkillRoundEffect.handle.s:setOpacity(0) --geyachao: 应x3的邪恶需求，换个特效
						local decal, count = 11, 0 --光晕效果
						local r, g, b, parent = 150, 128, 64
						local parent = hGlobal.UI.GuideLvUpSkillRoundEffect.handle._n
						local offsetX, offsetY, duration, scale = 30, 30, 0.4, 1.05
						local nnn = xlAddNormalLightEffect(decal,count,offsetX,offsetY,duration,scale,r,g,b,parent)
						nnn:setScale(1.8)
						
						--创建提示点击技能升级按钮的手的特效
						hGlobal.UI.GuideLvUpSkillHandEffect = hUI.image:new({
							parent = _parent,
							x = 415 + 65,
							y = -490 + 30,
							model = "MODEL_EFFECT:Hand",
							scale = 1.3,
							z = 100,
						})
						
						--点击升级英雄技能按钮事件（引导用）
						clickSkillLvUp_Guide = function()
							--模拟直接升级
							local overage = 0
							local strTag = "hi:18001;si:1103;st:1;sp:1;sc:100;"
							local order_id = 0
							--模拟英雄技能升级成功事件
							hGlobal.event:event("localEvent_afterSkillLvUpSucceed", overage, strTag, order_id)
							
							--删除控件
							--删除英雄详细界面积分升级按钮（假的）（引导用）
							hApi.safeRemoveT(hGlobal.UI.HeroCardNewFrm.childUI, "btnSkillLvUp_FakeGuide")
						
							--删除提示点击技能升级按钮的转圈圈特效
							if hGlobal.UI.GuideLvUpSkillRoundEffect then
								hGlobal.UI.GuideLvUpSkillRoundEffect:del()
								hGlobal.UI.GuideLvUpSkillRoundEffect = nil
							end
							
							--删除提示点击技能升级按钮的手的特效
							if hGlobal.UI.GuideLvUpSkillHandEffect then
								hGlobal.UI.GuideLvUpSkillHandEffect:del()
								hGlobal.UI.GuideLvUpSkillHandEffect = nil
							end
							
							--创建英雄详细界面积分升级按钮（假的）（挡操作用）
							_childUI["btnSkillLvUp_Fake2"] = hUI.button:new({
								parent = _parent,
								model = "UI:BTN_ButtonRed", 
								animation = "normal",
								dragbox = _childUI["dragBox"],
								font = hVar.FONTC,
								border = 1,
								align = "MC",
								label = hVar.tab_string["__UPGRADE"],
								--y = -455,
								--scale = 1,
								x = 475,
								y = -490,
								scale = 1,
								scaleT = 0.99,
								code = function(self)
									--
								end,
							})
							
							--删除之前的关闭按钮
							hApi.safeRemoveT(hGlobal.UI.HeroCardNewFrm.childUI, "btnClose_Fake") --英雄详细界面关闭按钮（假的）（挡操作用）
							
							--创建新的关闭按钮
							--英雄详细界面关闭按钮（假的）（引导用）
							local _w,_h = 892, 558
							local _x,_y = hVar.SCREEN.w/2 - _w/2,hVar.SCREEN.h/2+ _h/2 - 20
							
							local closeDx = -5
							local closeDy = -5
							if (g_phone_mode ~= 0) then
								closeDx = 0
								closeDy = -20
							end
							_childUI["btnClose_Fake2"] = hUI.button:new({
								parent = _frm,
								model = "BTN:PANEL_CLOSE",
								x = _w + closeDx,
								y = closeDy,
								z = 5,
								scaleT = 0.99,
								code = function(self)
									--点击关闭英雄界面按钮
									--关闭英雄界面
									_frm:show(0)
									hApi.safeRemoveT(_childUI, "HeroInfoiconImg")
									hGlobal.event:event("LocalEvent_CloseGameCoinFrm")
									
									--触发事件：关闭了主菜单按钮
									hGlobal.event:event("LocalEvent_MainMenuSubFrmClose")
									
									--删除控件
									--删除之前的关闭按钮
									hApi.safeRemoveT(hGlobal.UI.HeroCardNewFrm.childUI, "btnClose_Fake2") --英雄详细界面关闭按钮（假的）（引导用）
									hApi.safeRemoveT(hGlobal.UI.HeroCardNewFrm.childUI, "btnStarLvUp_Fake") --英雄详细界面升星按钮（假的）（挡操作用）
									hApi.safeRemoveT(hGlobal.UI.HeroCardNewFrm.childUI, "playerbag_table_R_Fake") --英雄详细界面翻页按钮下（假的）（挡操作用）
									hApi.safeRemoveT(hGlobal.UI.HeroCardNewFrm.childUI, "playerbag_table_L_Fake") --英雄详细界面翻页按钮上（假的）（挡操作用）
									hApi.safeRemoveT(hGlobal.UI.HeroCardNewFrm.childUI, "btnItem_Fake") --英雄详细界面道具按钮（假的）（挡操作用）
									hApi.safeRemoveT(hGlobal.UI.HeroCardNewFrm.childUI, "btnSkill_Fake") --英雄详细界面技能按钮（假的）（挡操作用）
									hApi.safeRemoveT(hGlobal.UI.HeroCardNewFrm.childUI, "btnSkillLvUp_Fake2") --英雄详细界面积分升级按钮（假的）（挡操作用）
									
									--删除提示点击关闭按钮的转圈圈特效
									if hGlobal.UI.GuideCloseHeroRoundEffect then
										hGlobal.UI.GuideCloseHeroRoundEffect:del()
										hGlobal.UI.GuideCloseHeroRoundEffect = nil
									end
									
									--删除提示点击关闭按钮的手的特效
									if hGlobal.UI.GuideCloseHeroHandEffect then
										hGlobal.UI.GuideCloseHeroHandEffect:del()
										hGlobal.UI.GuideCloseHeroHandEffect = nil
									end
									
									--进入下个状态: 引导结束
									hGlobal.UI.GuideHeroFrmState = hGlobal.UI.GuideHeroFrmStateType.GUIDE_END
									
									--对话：英雄界面引导完成
									__Dialogue_GuideHeroFrm_Introduce_GuideEnd()
								end,
							})
							
							--创建提示点击关闭按钮的转圈圈特效
							hGlobal.UI.GuideCloseHeroRoundEffect = hUI.image:new({
								parent = _parent,
								model = "MODEL_EFFECT:strengthen",
								x = _w + closeDx,
								y = closeDy,
								--w = 60,
								--h = 60 + 10,
								--scale = 2.0,
								w = 100,
								h = 100,
								scale = 1.0,
								z = 100,
							})
							hGlobal.UI.GuideCloseHeroRoundEffect.handle.s:setColor(ccc3(0, 255, 0)) --绿色
							hGlobal.UI.GuideCloseHeroRoundEffect.handle.s:setOpacity(0) --geyachao: 应x3的邪恶需求，换个特效
							local decal, count = 11, 0 --光晕效果
							local r, g, b, parent = 150, 128, 64
							local parent = hGlobal.UI.GuideCloseHeroRoundEffect.handle._n
							local offsetX, offsetY, duration, scale = 30, 33, 0.4, 1.05
							local nnn = xlAddNormalLightEffect(decal,count,offsetX,offsetY,duration,scale,r,g,b,parent)
							nnn:setScale(1.6)
							
							--创建提示点击关闭按钮的手的特效
							hGlobal.UI.GuideCloseHeroHandEffect = hUI.image:new({
								parent = _parent,
								x = _w + closeDx,
								y = closeDy - 30,
								model = "MODEL_EFFECT:Hand",
								scale = 1.3,
								z = 100,
							})
							hGlobal.UI.GuideCloseHeroHandEffect.handle.s:setRotation(180)
							
							--在升级技能后就标记引导英雄界面完成（防止升级后直接关闭窗口）
							--标记主城引导英雄界面完成
							LuaSetPlayerGuideState(g_curPlayerName, "town/town_mainmenu", 2)
							
							--进入下个状态: 提示关闭英雄界面
							hGlobal.UI.GuideHeroFrmState = hGlobal.UI.GuideHeroFrmStateType.GUIDE_CLICK_CLOSE_HERO_UI
							
							--无对话
							--...
						end
						
						--进入下个状态: 提示点击技能升级按钮
						hGlobal.UI.GuideHeroFrmState = hGlobal.UI.GuideHeroFrmStateType.GUIDE_CLICK_LVUP_BUTTON
						
						--无对话
						--...
					end)
					
					--进入下个状态: 提示点击第一个技能按钮
					hGlobal.UI.GuideHeroFrmState = hGlobal.UI.GuideHeroFrmStateType.GUIDE_CLICK_SKILL_BUTTON
					
					--无对话
					--...
				end
				
				--如果存在道具，并且英雄身上没有道具，才会引导穿装备
				if (itemIdx > 0) and (heroEquippedNum == 0) then
					--创建提示选取道具转圈圈特效
					local orientRx = _w - 267 + 105
					if (g_phone_mode ~= 1) then --非平板模式
						orientRx = orientRx - 105
					end
					local orientRy = -114
					local OFFSET_X = 64
					local OFFSET_Y = -64
					hGlobal.UI.GuideClickItemRoundEffect = hUI.image:new({
						parent = _parent,
						model = "MODEL_EFFECT:strengthen",
						x = orientRx + (xIdx - 1) * OFFSET_X,
						y = orientRy + (yIdx - 1) * OFFSET_Y,
						--w = 60,
						--h = 60,
						--scale = 2.2,
						w = 100,
						h = 100,
						scale = 1.0,
						z = 100,
					})
					hGlobal.UI.GuideClickItemRoundEffect.handle.s:setColor(ccc3(0, 255, 0)) --绿色
					hGlobal.UI.GuideClickItemRoundEffect.handle.s:setOpacity(0) --geyachao: 应x3的邪恶需求，换个特效
					local decal, count = 11, 0 --光晕效果
					local r, g, b, parent = 150, 128, 64
					local parent = hGlobal.UI.GuideClickItemRoundEffect.handle._n
					local offsetX, offsetY, duration, scale = 30, 30, 0.4, 1.05
					local nnn = xlAddNormalLightEffect(decal,count,offsetX,offsetY,duration,scale,r,g,b,parent)
					nnn:setScale(1.5)
					
					local orientHx, orientHy = _w - 267 + 105, -114 --第一个背包格子的位置
					if (g_phone_mode ~= 1) then --非平板模式
						orientHx = orientHx - 105
					end
					local toHx, toHy  = orientHx - 87, orientHy + 63 --目标应该放到的位置
					local curHx = orientHx + (xIdx - 1) * OFFSET_X
					local curHy = orientHy + (yIdx - 1) * OFFSET_Y
					hGlobal.UI.GuideClickItemHandEffect = hUI.image:new({
						parent = _parent,
						model = "MODEL_EFFECT:HandStatic",
						x = curHx,
						y = curHy,
						scale = 1.0,
						z = 100,
					})
					hGlobal.UI.GuideClickItemHandEffect.handle.s:setRotation(180)
					--创建动画
					local aArray = CCArray:create()
					aArray:addObject(CCDelayTime:create(0.8))
					aArray:addObject(CCMoveTo:create(0.4, ccp(toHx, toHy)))
					aArray:addObject(CCDelayTime:create(0.6))
					aArray:addObject(CCMoveTo:create(0.01, ccp(curHx, curHy)))
					local seq = tolua.cast(CCSequence:create(aArray), "CCActionInterval")
					local node = hGlobal.UI.GuideClickItemHandEffect.handle._n
					node:runAction(CCRepeatForever:create(seq))
					
					--监听穿装备成功事件（不一定穿成功，有可能只是挪背包位置或者穿错栏位）
					hGlobal.event:listen("Event_HeroCardSortItem", "__GUIDE_SORT_ITEM", function()
						--检查刘备身上是否有装备，有装备才认为是成功
						local equipNum = 0
						local type_id = 18001 --刘备
						local HeroCard = hApi.GetHeroCardById(type_id)
						if HeroCard and (type(HeroCard) == "table") and HeroCard.equipment and (type(HeroCard.equipment) == "table") then
							for k = 1, #HeroCard.equipment, 1 do
								--存档里的装备表
								local item = HeroCard.equipment[k]
								
								if (type(item) == "table") then
									local item_id = item[1] --道具id
									
									if (item_id ~= 0) then
										equipNum = equipNum + 1
									end
								end
							end
						end
						
						--英雄身上有装备
						if (equipNum > 0) then --装备道具成功
							--移除监听出售道具事件
							hGlobal.event:listen("Local_Event_ItemSell_Result", "__GUIDE_SELL_ITEM", nil)
							--移除监听合成道具事件
							hGlobal.event:listen("Local_Event_ItemMerge_Result", "__GUIDE_MERGE_ITEM", nil)
							--删除监听排序道具事件
							hGlobal.event:listen("Event_HeroCardSortItem", "__GUIDE_SORT_ITEM", nil)
								
							--删除提示选取道具转圈圈特效
							if hGlobal.UI.GuideClickItemRoundEffect then
								hGlobal.UI.GuideClickItemRoundEffect:del()
								hGlobal.UI.GuideClickItemRoundEffect = nil
							end
							
							--删除提示选取道具的手的特效
							if hGlobal.UI.GuideClickItemHandEffect then
								hGlobal.UI.GuideClickItemHandEffect:del()
								hGlobal.UI.GuideClickItemHandEffect = nil
							end
							
							_CODE_GuideNext_Skill()
						else
							--因为挪动了背包，放到别的格子，所以刷新新的背包的位置并提示引导特效
							--删除提示选取道具转圈圈特效
							if hGlobal.UI.GuideClickItemRoundEffect then
								hGlobal.UI.GuideClickItemRoundEffect:del()
								hGlobal.UI.GuideClickItemRoundEffect = nil
							end
							
							--删除提示选取道具的手的特效
							if hGlobal.UI.GuideClickItemHandEffect then
								hGlobal.UI.GuideClickItemHandEffect:del()
								hGlobal.UI.GuideClickItemHandEffect = nil
							end
							
							--获取道具在哪个位置
							--创建提示滑动道具的手的特效
							local xIdx = 0 --x索引值
							local yIdx = 0 --y索引值
							local itemIdx = 0
							local item = LuaGetPlayerBagFromTableIndex(1)
							for k = 1, 28, 1 do
								if item[k] and (item[k] ~= 0) then
									itemIdx = k
									break
								end
							end
							if (itemIdx > 0) then
								xIdx = itemIdx % 4
								if (xIdx == 0) then
									xIdx = 4
								end
								yIdx = (itemIdx - xIdx) / 4 + 1
							end
							
							--创建提示选取道具转圈圈特效
							local orientRx = _w - 267 + 105
							if (g_phone_mode ~= 1) then --非平板模式
								orientRx = orientRx - 105
							end
							local orientRy = -114
							local OFFSET_X = 64
							local OFFSET_Y = -64
							hGlobal.UI.GuideClickItemRoundEffect = hUI.image:new({
								parent = _parent,
								model = "MODEL_EFFECT:strengthen",
								x = orientRx + (xIdx - 1) * OFFSET_X,
								y = orientRy + (yIdx - 1) * OFFSET_Y,
								--w = 60,
								--h = 60,
								--scale = 2.2,
								w = 100,
								h = 100,
								scale = 1.0,
								z = 100,
							})
							hGlobal.UI.GuideClickItemRoundEffect.handle.s:setColor(ccc3(0, 255, 0)) --绿色
							hGlobal.UI.GuideClickItemRoundEffect.handle.s:setOpacity(0) --geyachao: 应x3的邪恶需求，换个特效
							local decal, count = 11, 0 --光晕效果
							local r, g, b, parent = 150, 128, 64
							local parent = hGlobal.UI.GuideClickItemRoundEffect.handle._n
							local offsetX, offsetY, duration, scale = 30, 30, 0.4, 1.05
							local nnn = xlAddNormalLightEffect(decal,count,offsetX,offsetY,duration,scale,r,g,b,parent)
							nnn:setScale(1.5)
							
							local orientHx, orientHy = _w - 267 + 105, -114  --第一个背包格子的位置
							if (g_phone_mode ~= 1) then --非平板模式
								orientHx = orientHx - 105
							end
							local toHx, toHy  = orientHx - 87, orientHy + 63 --目标应该放到的位置
							local curHx = orientHx + (xIdx - 1) * OFFSET_X
							local curHy = orientHy + (yIdx - 1) * OFFSET_Y
							hGlobal.UI.GuideClickItemHandEffect = hUI.image:new({
								parent = _parent,
								model = "MODEL_EFFECT:HandStatic",
								x = curHx,
								y = curHy,
								scale = 1.0,
								z = 100,
							})
							hGlobal.UI.GuideClickItemHandEffect.handle.s:setRotation(180)
							--创建动画
							local aArray = CCArray:create()
							aArray:addObject(CCDelayTime:create(0.8))
							aArray:addObject(CCMoveTo:create(0.4, ccp(toHx, toHy)))
							aArray:addObject(CCDelayTime:create(0.6))
							aArray:addObject(CCMoveTo:create(0.01, ccp(curHx, curHy)))
							local seq = tolua.cast(CCSequence:create(aArray), "CCActionInterval")
							local node = hGlobal.UI.GuideClickItemHandEffect.handle._n
							node:runAction(CCRepeatForever:create(seq))
						end
					end)
					
					--监听出售道具事件，也进入下个流程
					hGlobal.event:listen("Local_Event_ItemSell_Result", "__GUIDE_SELL_ITEM", function()
						--移除监听出售道具事件
						hGlobal.event:listen("Local_Event_ItemSell_Result", "__GUIDE_SELL_ITEM", nil)
						--移除监听合成道具事件
						hGlobal.event:listen("Local_Event_ItemMerge_Result", "__GUIDE_MERGE_ITEM", nil)
						--删除监听排序道具事件
						hGlobal.event:listen("Event_HeroCardSortItem", "__GUIDE_SORT_ITEM", nil)
						
						--删除提示选取道具转圈圈特效
						if hGlobal.UI.GuideClickItemRoundEffect then
							hGlobal.UI.GuideClickItemRoundEffect:del()
							hGlobal.UI.GuideClickItemRoundEffect = nil
						end
						
						--删除提示选取道具的手的特效
						if hGlobal.UI.GuideClickItemHandEffect then
							hGlobal.UI.GuideClickItemHandEffect:del()
							hGlobal.UI.GuideClickItemHandEffect = nil
						end
						
						_CODE_GuideNext_Skill()
					end)
					
					--监听合成道具事件，也进入下个流程
					hGlobal.event:listen("Local_Event_ItemMerge_Result", "__GUIDE_MERGE_ITEM", function()
						--移除监听出售道具事件
						hGlobal.event:listen("Local_Event_ItemSell_Result", "__GUIDE_SELL_ITEM", nil)
						--移除监听合成道具事件
						hGlobal.event:listen("Local_Event_ItemMerge_Result", "__GUIDE_MERGE_ITEM", nil)
						--删除监听排序道具事件
						hGlobal.event:listen("Event_HeroCardSortItem", "__GUIDE_SORT_ITEM", nil)
						
						--删除提示选取道具转圈圈特效
						if hGlobal.UI.GuideClickItemRoundEffect then
							hGlobal.UI.GuideClickItemRoundEffect:del()
							hGlobal.UI.GuideClickItemRoundEffect = nil
						end
						
						--删除提示选取道具的手的特效
						if hGlobal.UI.GuideClickItemHandEffect then
							hGlobal.UI.GuideClickItemHandEffect:del()
							hGlobal.UI.GuideClickItemHandEffect = nil
						end
						
						_CODE_GuideNext_Skill()
					end)
					
					--进入下个状态: 提示英雄穿装备
					hGlobal.UI.GuideHeroFrmState = hGlobal.UI.GuideHeroFrmStateType.GUIDE_HERO_EQIPMENT_INTRODUCE
					
					--无对话
					--...
				else --无道具（说明之前已经引导过了）（上次意外退出）
					_CODE_GuideNext_Skill()
				end
			end
		elseif (hGlobal.UI.GuideHeroFrmState == hGlobal.UI.GuideHeroFrmStateType.GUIDE_HERO_EQIPMENT_INTRODUCE) then --提示英雄穿装备
			--该状态会监听英雄穿装备事件后，跳转到下一状态
			--这里不做处理
			--...
		elseif (hGlobal.UI.GuideHeroFrmState == hGlobal.UI.GuideHeroFrmStateType.GUIDE_CLICK_SKILL_BUTTON) then --提示点击第一个英雄技能按钮
			--该状态会监听点击英雄技能事件里，跳转到下一状态
			--这里不做处理
			--...
		elseif (hGlobal.UI.GuideHeroFrmState == hGlobal.UI.GuideHeroFrmStateType.GUIDE_CLICK_LVUP_BUTTON) then --提示点击技能升级按钮
			--该状态会监听点击技能升级事件里，跳转到下一状态
			--这里不做处理
			--...
		elseif (hGlobal.UI.GuideHeroFrmState == hGlobal.UI.GuideHeroFrmStateType.GUIDE_CLICK_CLOSE_HERO_UI) then --提示点击关闭英雄界面
			--该状态会监听关闭按钮点击事件，跳转到下一状态
			--这里不做处理
			--...
		elseif (hGlobal.UI.GuideHeroFrmState == hGlobal.UI.GuideHeroFrmStateType.GUIDE_END) then --引导结束
			--删除整个界面
			if hGlobal.UI.GuideSelectHeroFrmMenuBar then --引导升级塔高级技能的
				hGlobal.UI.GuideSelectHeroFrmMenuBar:del()
				hGlobal.UI.GuideSelectHeroFrmMenuBar = nil
			end
			
			--在升级技能后就标记引导英雄界面完成（防止升级后直接关闭窗口）
			--标记主城引导英雄界面完成
			--LuaSetPlayerGuideState(g_curPlayerName, "town/town_mainmenu", 2)
			
			--geyachao: 标记当前不在引导中
			hVar.IS_IN_GUIDE_STATE = 0
			--print("XXXXXXXXXXXXXXX -----> hVar.IS_IN_GUIDE_STATE = 0, 点击引导英雄界面")
			
			--因为要触发下一个主城的引导任务点将台的事件，这里模拟触发事件
			--hGlobal.event:event("LocalEvent_EnterGuideProgress", hVar.PHONE_MAINMENU, __G_MainMenuWorld, "map")
			hGlobal.event:event("LocalEvent_EnterGuideProgress", hVar.PHONE_SELECTLEVEL, __G_SelectMapWorld, "map", 0)
		end
	end
	
	--开始引导主城查看英雄界面和穿装、升级技能
	function BeginGuideHeroFrm()
		--读取存档里是否新手引导的标记
		local guideFlag = LuaGetPlayerGuideFlag(g_curPlayerName)
		
		--Ok的回调
		local function okCallback(checkboxState)
			--标记状态为引导结束
			hGlobal.UI.GuideHeroFrmState = hGlobal.UI.GuideHeroFrmStateType.GUIDE_END
			
			--清除整个界面
			if hGlobal.UI.GuideSelectHeroFrmMenuBar then --界面
				hGlobal.UI.GuideSelectHeroFrmMenuBar:del()
				hGlobal.UI.GuideSelectHeroFrmMenuBar = nil
			end
			
			--标记主城引导英雄界面完成（取消引导）
			LuaSetPlayerGuideState(g_curPlayerName, "town/town_mainmenu", 2)
			
			--因为要触发下一个主城的引导任务点将台的事件，这里模拟触发事件
			--hGlobal.event:event("LocalEvent_EnterGuideProgress", hVar.PHONE_MAINMENU, __G_MainMenuWorld, "map")
			hGlobal.event:event("LocalEvent_EnterGuideProgress", hVar.PHONE_SELECTLEVEL, __G_SelectMapWorld, "map", 0)
			
			--如果勾选了下次不再显示，那么存档本次设置
			if (checkboxState == 1) then
				--标记存档的新手引导标记
				LuaSetPlayerGuideFlag(g_curPlayerName, -1) --是否需要引导的标记（0:未设置 / -1:不需要引导 /1:需要引导）
			end
		end
		
		--Cancel的回调
		local function cancelCallback(checkboxState)
			if (hGlobal.UI.GuideHeroFrmState == hGlobal.UI.GuideHeroFrmStateType.NONE) then --初始状态
				--hGlobal.UI.GuideHeroFrmState = hGlobal.UI.GuideHeroFrmStateType.GUIDE_CLICK_HERO
				--选中无
				
				OnClickGuideHeroFrmFrame_Event(0, 0)
			end
			
			--如果勾选了下次不再显示，那么存档本次设置
			if (checkboxState == 1) then
				--标记存档的新手引导标记
				LuaSetPlayerGuideFlag(g_curPlayerName, 1) --是否需要引导的标记（0:未设置 / -1:不需要引导 /1:需要引导）
			end
		end
		
		--创建提示是否取消引导的框
		if (guideFlag == 0) then
			MsgBox_GuideSkip(okCallback, cancelCallback, "点将台操作指导")
		elseif (guideFlag == -1) then --不需要引导
			okCallback()
		elseif (guideFlag == 1) then --需要引导
			cancelCallback()
		end
	end
	
	--创建大地图对话
	local function __createMapTalkHeroFrm(flag, talkType, _func, ...)
		local arg = {...}
		local oWorld = hClass.world:new({type="none"})
		local oUnit = oWorld:addunit(1,1)
		
		local vTalk = hApi.AnalyzeTalk(oUnit, oUnit, {flag, talkType,}, {id = {townTypeId,townTypeId},})
		if vTalk then
			oWorld:del()
			oUnit:del()
			hApi.CreateUnitTalk(vTalk,function()
				if _func and type(_func) == "function" then
					_func(unpack(arg))
				end
			end)
		else
			if _func and type(_func) == "function" then
				_func(unpack(arg))
			end
		end
	end
	
	--显示对话框：引导主城英雄界面点将台介绍
	function __Dialogue_GuideHeroFrm_DianJiangTaiIntroduce()
		print("显示对话框：引导主城英雄界面点将台介绍")
		__createMapTalkHeroFrm("step1", "$_001_lsc_27", OnClickGuideHeroFrmFrame_Event, 0, 0)
	end
	
	--显示对话框：引导主城英雄界面点击点将台按钮
	function __Dialogue_GuideHeroFrm_Click_DianJiangTai()
		print("显示对话框：引导主城英雄界面点击点将台按钮")
		__createMapTalkHeroFrm("step2", "$_001_lsc_28", OnClickGuideHeroFrmFrame_Event, 0, 0)
	end
	
	
	--显示对话框：引导主城英雄界面引导完成
	function __Dialogue_GuideHeroFrm_Introduce_GuideEnd()
		print("显示对话框：引导主城英雄界面引导完成")
		__createMapTalkHeroFrm("step3", "$_001_lsc_29", OnClickGuideHeroFrmFrame_Event, 0, 0)
	end
	
	--开始引导主城英雄界面
	BeginGuideHeroFrm()
end

--test
--测试主城引导点将台、穿装备、升级技能
--CreateGuideFrame_HeroFrm()

