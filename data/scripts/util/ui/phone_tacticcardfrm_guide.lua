





--创建主城引导战术技能卡
function CreateGuideFrame_TacticFrm()
	--主城引导战术技能卡
	hGlobal.UI.GuideTacticStateType =
	{
		NONE = 0, --初始状态
		GUIDE_CLICK_TASK_BTN = 1, --提示点击战术卡按钮
		GUIDE_WAIT_CLICK_TACTICBTN = 2, --等待点击战术卡按钮
		GUIDE_WAIT_CLICK_JIANTA = 3, --等待点击箭塔分页按钮
		GUIDE_WAIT_CLICK_FIRST_ACHIV = 4, --等待点击毒塔按钮
		GUIDE_WAIT_CLICK_LINGJIANG = 5, --等待点击升级毒塔按钮
		GUIDE_WAIT_ANIM = 6, --等待动画完成
		GUIDE_EXTRA_INTRO = 7, --介绍战术卡的一些附加说明
		GUIDE_WAIT_CLICK_CLOSE = 8, --等待点击关闭按钮
		GUIDE_END = 9, --引导结束
	}

	--引导的当前状态
	hGlobal.UI.GuideTacticFrmState = hGlobal.UI.GuideTacticStateType.NONE --一开始为初始状态 --flag1 GUIDE_END  NONE   flag1
	
	--test: 重复测试，删除前一个控件
	if hGlobal.UI.GuideTacticHandEffect then --提示点击战术卡的手的特效
		hGlobal.UI.GuideTacticHandEffect:del()
		hGlobal.UI.GuideTacticHandEffect = nil
	end
	if hGlobal.UI.GuideTacticRoundEffect then --提示点击战术卡的转圈圈特效
		hGlobal.UI.GuideTacticRoundEffect:del()
		hGlobal.UI.GuideTacticRoundEffect = nil
	end
	if hGlobal.UI.GuideClickJianTaPageHandEffect then --提示点击箭塔分页按钮的手的特效
		hGlobal.UI.GuideClickJianTaPageHandEffect:del()
		hGlobal.UI.GuideClickJianTaPageHandEffect = nil
	end
	if hGlobal.UI.GuideClickJianTaPageBtnRoundEffect then --提示点击箭塔分页按钮的转圈圈特效
		hGlobal.UI.GuideClickJianTaPageBtnRoundEffect:del()
		hGlobal.UI.GuideClickJianTaPageBtnRoundEffect = nil
	end
	if hGlobal.UI.GuideClickDuTaCardHandEffect then --提示点击毒塔按钮的手的特效
		hGlobal.UI.GuideClickDuTaCardHandEffect:del()
		hGlobal.UI.GuideClickDuTaCardHandEffect = nil
	end
	if hGlobal.UI.GuideClickDuTaCardRoundEffect then --提示点击毒塔按钮的转圈圈特效
		hGlobal.UI.GuideClickDuTaCardRoundEffect:del()
		hGlobal.UI.GuideClickDuTaCardRoundEffect = nil
	end
	if hGlobal.UI.GuideClickLvUpDuTaHandEffect then --提示点击升级毒塔按钮的手特效
		hGlobal.UI.GuideClickLvUpDuTaHandEffect:del()
		hGlobal.UI.GuideClickLvUpDuTaHandEffect = nil
	end
	if hGlobal.UI.GuideClickLvUpDuTaBtnRoundEffect then --提示点击升级毒塔按钮按钮的转圈圈特效
		hGlobal.UI.GuideClickLvUpDuTaBtnRoundEffect:del()
		hGlobal.UI.GuideClickLvUpDuTaBtnRoundEffect = nil
	end
	if hGlobal.UI.GuideClickCloseHandEffect then --提示点击关闭按钮的手特效
		hGlobal.UI.GuideClickCloseHandEffect:del()
		hGlobal.UI.GuideClickCloseHandEffect = nil
	end
	if hGlobal.UI.GuideClickCloseBtnRoundEffect then --提示点击关闭按钮按钮的转圈圈特效
		hGlobal.UI.GuideClickCloseBtnRoundEffect:del()
		hGlobal.UI.GuideClickCloseBtnRoundEffect = nil
	end
	
	if hGlobal.UI.GuideTacticFrmMenuBar then --引导战术卡的主界面
		hGlobal.UI.GuideTacticFrmMenuBar:del()
		hGlobal.UI.GuideTacticFrmMenuBar = nil
	end
	
	--创建引导战术技能卡的主界面
	--创建父容器
	hGlobal.UI.GuideTacticFrmMenuBar = hUI.frame:new({
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
				--点击引导战术卡操作界面事件
				--local worldX, worldY = hApi.view2world(screenX, hVar.SCREEN.h - screenY) --大地图的坐标
				OnClickGuideTacticFrmFrame_Event(screenX, screenY)
			end
		end
	})
	hGlobal.UI.GuideTacticFrmMenuBar:active() --最前端显示
	
	--点击引导战术技能卡操作界面的事件
	function OnClickGuideTacticFrmFrame_Event(clickScreenX, clickScreenY)
		if (hGlobal.UI.GuideTacticFrmState == hGlobal.UI.GuideTacticStateType.NONE) then --初始状态
			--geyachao: 标记当前正在引导中
			hVar.IS_IN_GUIDE_STATE = 1
			--print("XXXXXXXXXXXXXXX -----> hVar.IS_IN_GUIDE_STATE = 1, 点击引导战术卡操作界面")
			
			--进入下个状态: 开场简介
			hGlobal.UI.GuideTacticFrmState = hGlobal.UI.GuideTacticStateType.GUIDE_CLICK_TASK_BTN
			
			--显示对话框：引导提示战术卡按钮
			__Dialogue_GuideTacticFrm_TacticIntroduce()
		elseif (hGlobal.UI.GuideTacticFrmState == hGlobal.UI.GuideTacticStateType.GUIDE_CLICK_TASK_BTN) then --提示点击战术卡按钮
			--创建提示点击战术卡按钮的转圈圈特效
			hGlobal.UI.GuideTacticRoundEffect = hUI.image:new({
				parent = hGlobal.UI.GuideTacticFrmMenuBar.handle._n,
				model = "MODEL_EFFECT:strengthen",
				x = hVar.SCREEN.w - 60 - 110,
				y = 65 + 5, --统一调整底部条y坐标
				--w = 90,
				--h = 90,
				--scale = 2.2,
				w = 100,
				h = 100,
				scale = 1.0,
				z = 100,
			})
			hGlobal.UI.GuideTacticRoundEffect.handle.s:setColor(ccc3(0, 255, 0)) --绿色
			hGlobal.UI.GuideTacticRoundEffect.handle.s:setOpacity(0) --geyachao: 应x3的邪恶需求，换个特效
			local decal, count = 11, 0 --光晕效果
			local r, g, b, parent = 150, 128, 64
			local parent = hGlobal.UI.GuideTacticRoundEffect.handle._n
			local offsetX, offsetY, duration, scale = 32, 30, 0.4, 1.05
			local nnn = xlAddNormalLightEffect(decal,count,offsetX,offsetY,duration,scale,r,g,b,parent)
			nnn:setScale(2.3)
			
			--创建提示点击战术卡按钮的手特效
			hGlobal.UI.GuideTacticHandEffect = hUI.image:new({
				parent = hGlobal.UI.GuideTacticFrmMenuBar.handle._n,
				model = "MODEL_EFFECT:Hand",
				x = hVar.SCREEN.w - 60 - 110,
				y = 65 + 40 + 5, --统一调整底部条y坐标
				scale = 1.5,
				z = 100,
			})
			--hGlobal.UI.GuideTacticHandEffect.handle.s:setColor(ccc3(255, 255, 0))
			
			--进入下个状态: 等待点击战术卡按钮
			hGlobal.UI.GuideTacticFrmState = hGlobal.UI.GuideTacticStateType.GUIDE_WAIT_CLICK_TACTICBTN
			
			--显示对话框：引导主城战术卡界面点击战术卡按钮
			__Dialogue_GuideTacticFrm_Click_TacticBtn()
			
			--监听点击战术技能卡按钮事件，也进入下个状态（因为有时候莫名其妙的战术卡按钮在最顶层，只能监听到该点击事件）
			hGlobal.event:listen("LocalEvent_Click_Guide_TacticButton", "ClickTacticButton", function()
				--删除监听
				hGlobal.event:listen("LocalEvent_Click_Guide_TacticButton", "ClickTacticButton", nil)
				--print("--删除监听--删除监听--删除监听--删除监听")
				local bx = hVar.SCREEN.w - 60 - 110
				local by = 65 + 5 --统一调整底部条y坐标
				local w = 90
				local h = 90
				local button_left = bx - w / 2 --战术卡选中区域的最左侧
				local button_right = bx + w / 2 --战术卡选中区域的最右侧
				local button_top = by - h / 2 --战术卡选中区域的最上侧
				local button_bottom = by + h / 2 --战术卡选中区域的最下侧
				
				--强制跳转到下一个状态
				OnClickGuideTacticFrmFrame_Event((button_left + button_right) / 2, (button_top + button_bottom) / 2)
			end)
		elseif (hGlobal.UI.GuideTacticFrmState == hGlobal.UI.GuideTacticStateType.GUIDE_WAIT_CLICK_TACTICBTN) then --提示点击战术卡按钮
			local bx = hVar.SCREEN.w - 60 - 110
			local by = 75
			local w = 90
			local h = 90
			local button_left = bx - w / 2 --战术卡选中区域的最左侧
			local button_right = bx + w / 2 --战术卡选中区域的最右侧
			local button_top = by - h / 2 --战术卡选中区域的最上侧
			local button_bottom = by + h / 2 --战术卡选中区域的最下侧
			
			--检测是否点击到了战术卡按钮
			if (clickScreenX >= button_left) and (clickScreenX <= button_right) and (clickScreenY >= button_top) and (clickScreenY <= button_bottom) then
				--删除提示点击战术卡按钮的手特效
				if hGlobal.UI.GuideTacticHandEffect then --点击战术卡的手的特效
					hGlobal.UI.GuideTacticHandEffect:del()
					hGlobal.UI.GuideTacticHandEffect = nil
				end
				
				--删除提示点击战术卡按钮的转圈圈特效
				if hGlobal.UI.GuideTacticRoundEffect then --点击战术卡的手的特效
					hGlobal.UI.GuideTacticRoundEffect:del()
					hGlobal.UI.GuideTacticRoundEffect = nil
				end
				
				--删除监听
				hGlobal.event:listen("LocalEvent_Click_Guide_TacticButton", "ClickTacticButton", nil)
				
				--geyachao: 无主城模式的新流程
				hGlobal.event:event("localEvent_ShowPhone_BattlefieldSkillBook", 1, "playercard")
				
				--删除引导战术卡操作主界面
				if hGlobal.UI.GuideTacticFrmMenuBar then
					hGlobal.UI.GuideTacticFrmMenuBar:del()
					hGlobal.UI.GuideTacticFrmMenuBar = nil
				end
				
				--重新创建父容器
				hGlobal.UI.GuideTacticFrmMenuBar = hUI.frame:new({
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
							OnClickGuideTacticFrmFrame_Event(screenX, screenY)
						end
					end
				})
				hGlobal.UI.GuideTacticFrmMenuBar:active() --最前端显示
				
				--创建提示点击箭塔分页按钮的转圈圈特效
				hGlobal.UI.GuideClickJianTaPageBtnRoundEffect = hUI.image:new({
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
				hGlobal.UI.GuideClickJianTaPageBtnRoundEffect.handle.s:setColor(ccc3(0, 255, 0)) --绿色
				hGlobal.UI.GuideClickJianTaPageBtnRoundEffect.handle.s:setOpacity(0) --geyachao: 应x3的邪恶需求，换个特效
				local decal, count = 11, 0 --光晕效果
				local r, g, b, parent = 150, 128, 64
				local parent = hGlobal.UI.GuideClickJianTaPageBtnRoundEffect.handle._n
				local offsetX, offsetY, duration, scale = 32, 30, 0.4, 1.05
				local nnn = xlAddNormalLightEffect(decal,count,offsetX,offsetY,duration,scale,r,g,b,parent)
				nnn:setScale(1.3)
				
				--创建提示点击箭塔分页按钮的手特效
				hGlobal.UI.GuideClickJianTaPageHandEffect = hUI.image:new({
					parent = nil,
					model = "MODEL_EFFECT:Hand",
					x = hVar.SCREEN.w / 2 - 800 / 2 + 120 + 140 - 150,
					y = hVar.SCREEN.h / 2 + 550 / 2 - 20,
					scale = 1.5,
					z = 100,
				})
				--hGlobal.UI.GuideClickJianTaPageHandEffect.handle.s:setColor(ccc3(255, 255, 0))
				
				--进入下一状态：提示点击箭塔按钮
				hGlobal.UI.GuideTacticFrmState = hGlobal.UI.GuideTacticStateType.GUIDE_WAIT_CLICK_JIANTA
				
				--无对话
				--...
			end
		elseif (hGlobal.UI.GuideTacticFrmState == hGlobal.UI.GuideTacticStateType.GUIDE_WAIT_CLICK_JIANTA) then --等待点击箭塔分页按钮
			local bx = hVar.SCREEN.w / 2 - 800 / 2 + 120 + 140 - 150
			local by = hVar.SCREEN.h / 2 + 550 / 2 - 20 - 18
			local w = 200
			local h = 70
			local button_left = bx - w / 2 --英雄选中区域的最左侧
			local button_right = bx + w / 2 --英雄选中区域的最右侧
			local button_top = by - h / 2 --英雄选中区域的最上侧
			local button_bottom = by + h / 2 --英雄选中区域的最下侧
			
			--检测是否点击到了箭塔分页按钮
			if (clickScreenX >= button_left) and (clickScreenX <= button_right) and (clickScreenY >= button_top) and (clickScreenY <= button_bottom) then
				--删除提示点击箭塔分页按钮的手特效
				if hGlobal.UI.GuideClickJianTaPageHandEffect then --点击箭塔分页按钮的手特效
					hGlobal.UI.GuideClickJianTaPageHandEffect:del()
					hGlobal.UI.GuideClickJianTaPageHandEffect = nil
				end
				
				--删除提示点击箭塔分页按钮的转圈圈特效
				if hGlobal.UI.GuideClickJianTaPageBtnRoundEffect then --点击箭塔分页按钮的转圈圈特效
					hGlobal.UI.GuideClickJianTaPageBtnRoundEffect:del()
					hGlobal.UI.GuideClickJianTaPageBtnRoundEffect = nil
				end
				
				--模拟点击箭塔分页
				local _frm = hGlobal.UI.PhoneSelectedTacticFrm_New
				_frm.childUI["PageBtn1"].data.code()
				
				--创建提示点击第毒塔按钮的转圈圈特效
				hGlobal.UI.GuideClickDuTaCardRoundEffect = hUI.image:new({
					parent = nil,
					model = "MODEL_EFFECT:strengthen",
					x = hVar.SCREEN.w / 2 - 800 / 2 + 90,
					y = hVar.SCREEN.h / 2 + 550 / 2 - 362,
					--w = 120,
					--h = 120,
					--scale = 1.2,
					w = 100,
					h = 100,
					scale = 1.0,
					z = 100,
				})
				hGlobal.UI.GuideClickDuTaCardRoundEffect.handle.s:setColor(ccc3(0, 255, 0)) --绿色
				hGlobal.UI.GuideClickDuTaCardRoundEffect.handle.s:setOpacity(0) --geyachao: 应x3的邪恶需求，换个特效
				local decal, count = 11, 0 --光晕效果
				local r, g, b, parent = 150, 128, 64
				local parent = hGlobal.UI.GuideClickDuTaCardRoundEffect.handle._n
				local offsetX, offsetY, duration, scale = 30, 30, 0.4, 1.05
				local nnn = xlAddNormalLightEffect(decal,count,offsetX,offsetY,duration,scale,r,g,b,parent)
				nnn:setScale(1.5)
				
				--创建提示点击毒塔按钮的手特效
				hGlobal.UI.GuideClickDuTaCardHandEffect = hUI.image:new({
					parent = nil,
					model = "MODEL_EFFECT:Hand",
					x = hVar.SCREEN.w / 2 - 800 / 2 + 90,
					y = hVar.SCREEN.h / 2 + 550 / 2 - 362 + 30,
					scale = 1.5,
					z = 100,
				})
				--hGlobal.UI.GuideClickDuTaCardHandEffect.handle.s:setColor(ccc3(255, 255, 0))
				
				--进入下一状态：提示点击毒塔按钮
				hGlobal.UI.GuideTacticFrmState = hGlobal.UI.GuideTacticStateType.GUIDE_WAIT_CLICK_FIRST_ACHIV
				
				--无对话
				--...
			end
		elseif (hGlobal.UI.GuideTacticFrmState == hGlobal.UI.GuideTacticStateType.GUIDE_WAIT_CLICK_FIRST_ACHIV) then --等待点击毒塔按钮
			local bx = hVar.SCREEN.w / 2 - 800 / 2 + 90
			local by = hVar.SCREEN.h / 2 + 550 / 2 - 362
			local w = 120
			local h = 120
			local button_left = bx - w / 2 --英雄选中区域的最左侧
			local button_right = bx + w / 2 --英雄选中区域的最右侧
			local button_top = by - h / 2 --英雄选中区域的最上侧
			local button_bottom = by + h / 2 --英雄选中区域的最下侧
			
			--检测是否点击到了毒塔按钮
			if (clickScreenX >= button_left) and (clickScreenX <= button_right) and (clickScreenY >= button_top) and (clickScreenY <= button_bottom) then
				--删除提示点击毒塔按钮的手特效
				if hGlobal.UI.GuideClickDuTaCardHandEffect then --点击毒塔按钮的手特效
					hGlobal.UI.GuideClickDuTaCardHandEffect:del()
					hGlobal.UI.GuideClickDuTaCardHandEffect = nil
				end
				
				--删除提示点击毒塔按钮的转圈圈特效
				if hGlobal.UI.GuideClickDuTaCardRoundEffect then --点击毒塔按钮的转圈圈特效
					hGlobal.UI.GuideClickDuTaCardRoundEffect:del()
					hGlobal.UI.GuideClickDuTaCardRoundEffect = nil
				end
				
				--模拟点击毒塔
				local _frm = hGlobal.UI.PhoneSelectedTacticFrm_New
				local _frmNode = _frm.childUI["PageNode"]
				local ctrli = _frmNode.childUI["archyTowerIcon1"]
				local cx = ctrli.data.x --中心点x坐标
				local cy = ctrli.data.y --中心点y坐标
				ctrli.data.code(self, cx, cy, 1)
				
				--创建提示点击升级毒塔按钮按钮的转圈圈特效
				hGlobal.UI.GuideClickLvUpDuTaBtnRoundEffect = hUI.image:new({
					parent = nil,
					model = "MODEL_EFFECT:strengthen",
					x = hVar.SCREEN.w / 2 - 800 / 2 + 595,
					y = hVar.SCREEN.h / 2 + 550 / 2 - 520,
					--w = 280,
					--h = 90,
					--scale = 1.2,
					w = 100,
					h = 100,
					scale = 1.0,
					z = 100,
				})
				hGlobal.UI.GuideClickLvUpDuTaBtnRoundEffect.handle.s:setColor(ccc3(0, 255, 0)) --绿色
				hGlobal.UI.GuideClickLvUpDuTaBtnRoundEffect.handle.s:setOpacity(0) --geyachao: 应x3的邪恶需求，换个特效
				local decal, count = 11, 0 --光晕效果
				local r, g, b, parent = 150, 128, 64
				local parent = hGlobal.UI.GuideClickLvUpDuTaBtnRoundEffect.handle._n
				local offsetX, offsetY, duration, scale = 32, 30, 0.4, 1.05
				local nnn = xlAddNormalLightEffect(decal,count,offsetX,offsetY,duration,scale,r,g,b,parent)
				nnn:setScale(1.6)
				
				--创建提示点击升级毒塔按钮的手特效
				hGlobal.UI.GuideClickLvUpDuTaHandEffect = hUI.image:new({
					parent = nil,
					model = "MODEL_EFFECT:Hand",
					x = hVar.SCREEN.w / 2 - 800 / 2 + 595,
					y = hVar.SCREEN.h / 2 + 550 / 2 - 520 + 30,
					scale = 1.5,
					z = 100,
				})
				--hGlobal.UI.GuideClickLvUpDuTaHandEffect.handle.s:setColor(ccc3(255, 255, 0))
				
				--进入下一状态：提示点击升级毒塔按钮
				hGlobal.UI.GuideTacticFrmState = hGlobal.UI.GuideTacticStateType.GUIDE_WAIT_CLICK_LINGJIANG
				
				--无对话
				--...
			end
		elseif (hGlobal.UI.GuideTacticFrmState == hGlobal.UI.GuideTacticStateType.GUIDE_WAIT_CLICK_LINGJIANG) then --等待点击升级毒塔按钮
			local bx = hVar.SCREEN.w / 2 - 800 / 2 + 595
			local by = hVar.SCREEN.h / 2 + 550 / 2 - 520
			local w = 280
			local h = 90
			local button_left = bx - w / 2 --英雄选中区域的最左侧
			local button_right = bx + w / 2 --英雄选中区域的最右侧
			local button_top = by - h / 2 --英雄选中区域的最上侧
			local button_bottom = by + h / 2 --英雄选中区域的最下侧
			
			--检测是否点击到了升级毒塔按钮
			if (clickScreenX >= button_left) and (clickScreenX <= button_right) and (clickScreenY >= button_top) and (clickScreenY <= button_bottom) then
				--删除提示点击升级毒塔按钮的手特效
				if hGlobal.UI.GuideClickLvUpDuTaHandEffect then --点击升级毒塔按钮的手特效
					hGlobal.UI.GuideClickLvUpDuTaHandEffect:del()
					hGlobal.UI.GuideClickLvUpDuTaHandEffect = nil
				end
				
				--删除提示点击升级毒塔按钮的转圈圈特效
				if hGlobal.UI.GuideClickLvUpDuTaBtnRoundEffect then --点击升级毒塔按钮的转圈圈特效
					hGlobal.UI.GuideClickLvUpDuTaBtnRoundEffect:del()
					hGlobal.UI.GuideClickLvUpDuTaBtnRoundEffect = nil
				end
				
				--模拟升级毒塔
				local overage = 80
				local strTag = "ci:1011;cd:10;sc:100;"
				local order_id = 6852
				--模拟战术技能卡升级成功事件
				hGlobal.event:event("localEvent_afterTacticLvUpSucceed", overage, strTag, order_id)
				
				--延时创建对话框
				--（为了看清升级战术技能卡动画）
				local delay = CCDelayTime:create(0.6)
				local actCall = CCCallFunc:create(function(ctrl)
					--print("__TIMER_GUIDE_TASK_ONCE____TIMER_GUIDE_TASK_ONCE____TIMER_GUIDE_TASK_ONCE__")
					
					--进入下一个状态：介绍战术卡的一些附加说明
					hGlobal.UI.GuideTacticFrmState = hGlobal.UI.GuideTacticStateType.GUIDE_EXTRA_INTRO
					
					--对话：介绍战术卡的一些附加说明
					__Dialogue_GuideTacticFrm_Introduce_GuideExtraInfo()
				end)
				local actSeq = CCSequence:createWithTwoActions(delay, actCall)
				hGlobal.UI.GuideTacticFrmMenuBar.handle._n:runAction(actSeq)
				
				--进入下一个状态:等到动画完成
				hGlobal.UI.GuideTacticFrmState = hGlobal.UI.GuideTacticStateType.GUIDE_WAIT_ANIM
				
				--无对话
				--...
			end
		elseif (hGlobal.UI.GuideTacticFrmState == hGlobal.UI.GuideTacticStateType.GUIDE_WAIT_ANIM) then --等待动画完成
			--不作处理：timer到了会进入下一个状态
			--...
		elseif (hGlobal.UI.GuideTacticFrmState == hGlobal.UI.GuideTacticStateType.GUIDE_EXTRA_INTRO) then --介绍战术卡的一些附加说明
			--创建提示点击关闭按钮按钮的转圈圈特效
			local closeDx = -5
			local closeDy = -5
			if (g_phone_mode ~= 0) then
				closeDx = 0
				closeDy = -20
			end
			local _frm = hGlobal.UI.PhoneSelectedTacticFrm_New
			hGlobal.UI.GuideClickCloseBtnRoundEffect = hUI.image:new({
				parent = nil,
				model = "MODEL_EFFECT:strengthen",
				x = _frm.data.x + _frm.data.w + closeDx,
				y = _frm.data.y + closeDy,
				--w = 120,
				--h = 120,
				--scale = 1.2,
				w = 100,
				h = 100,
				scale = 1.0,
				z = 100,
			})
			hGlobal.UI.GuideClickCloseBtnRoundEffect.handle.s:setColor(ccc3(0, 255, 0)) --绿色
			hGlobal.UI.GuideClickCloseBtnRoundEffect.handle.s:setOpacity(0) --geyachao: 应x3的邪恶需求，换个特效
			local decal, count = 11, 0 --光晕效果
			local r, g, b, parent = 150, 128, 64
			local parent = hGlobal.UI.GuideClickCloseBtnRoundEffect.handle._n
			local offsetX, offsetY, duration, scale = 31, 33, 0.4, 1.05
			local nnn = xlAddNormalLightEffect(decal,count,offsetX,offsetY,duration,scale,r,g,b,parent)
			nnn:setScale(1.4)
			
			--创建提示点击关闭按钮的手特效
			hGlobal.UI.GuideClickCloseHandEffect = hUI.image:new({
				parent = nil,
				model = "MODEL_EFFECT:Hand",
				x = _frm.data.x + _frm.data.w + closeDx,
				y = _frm.data.y + closeDy - 40,
				scale = 1.5,
				z = 100,
			})
			hGlobal.UI.GuideClickCloseHandEffect.handle.s:setRotation(180)
			--hGlobal.UI.GuideClickCloseHandEffect.handle.s:setColor(ccc3(255, 255, 0))
			
			--进入下一个状态：等待关闭按钮
			hGlobal.UI.GuideTacticFrmState = hGlobal.UI.GuideTacticStateType.GUIDE_WAIT_CLICK_CLOSE
			
			--无对话
			--...
		elseif (hGlobal.UI.GuideTacticFrmState == hGlobal.UI.GuideTacticStateType.GUIDE_WAIT_CLICK_CLOSE) then --提示点击关闭按钮
			local closeDx = -5
			local closeDy = -5
			if (g_phone_mode ~= 0) then
				closeDx = 0
				closeDy = -20
			end
			local _frm = hGlobal.UI.PhoneSelectedTacticFrm_New
			local bx = _frm.data.x + _frm.data.w + closeDx
			local by = _frm.data.y + closeDy
			local w = 120
			local h = 120
			local button_left = bx - w / 2 --英雄选中区域的最左侧
			local button_right = bx + w / 2 --英雄选中区域的最右侧
			local button_top = by - h / 2 --英雄选中区域的最上侧
			local button_bottom = by + h / 2 --英雄选中区域的最下侧
			
			--检测是否点击到了关闭按钮
			if (clickScreenX >= button_left) and (clickScreenX <= button_right) and (clickScreenY >= button_top) and (clickScreenY <= button_bottom) then
				--删除提示点击关闭按钮的手特效
				if hGlobal.UI.GuideClickCloseHandEffect then --点击关闭按钮的手特效
					hGlobal.UI.GuideClickCloseHandEffect:del()
					hGlobal.UI.GuideClickCloseHandEffect = nil
				end
				
				--删除提示点击关闭按钮的转圈圈特效
				if hGlobal.UI.GuideClickCloseBtnRoundEffect then --点击领关闭钮的转圈圈特效
					hGlobal.UI.GuideClickCloseBtnRoundEffect:del()
					hGlobal.UI.GuideClickCloseBtnRoundEffect = nil
				end
				
				--进入下一个状态：关闭引导
				hGlobal.UI.GuideTacticFrmState = hGlobal.UI.GuideTacticStateType.GUIDE_END
				
				--强制跳转到下一个状态
				OnClickGuideTacticFrmFrame_Event(0, 0)
			end
		
		elseif (hGlobal.UI.GuideTacticFrmState == hGlobal.UI.GuideTacticStateType.GUIDE_END) then --引导结束
			--删除整个界面
			if hGlobal.UI.GuideTacticFrmMenuBar then --引导升级塔高级技能的
				hGlobal.UI.GuideTacticFrmMenuBar:del()
				hGlobal.UI.GuideTacticFrmMenuBar = nil
			end
			
			--标记主城引导战术技能卡界面完成
			LuaSetPlayerGuideState(g_curPlayerName, "town/town_mainmenu", 6)
			
			--geyachao: 标记当前不在引导中
			hVar.IS_IN_GUIDE_STATE = 0
			--print("XXXXXXXXXXXXXXX -----> hVar.IS_IN_GUIDE_STATE = 0, 点击引导战术卡操作界面")
			
			--模拟关闭界面
			local _frm = hGlobal.UI.PhoneSelectedTacticFrm_New
			_frm.childUI["closeBtn"].data.code()
			
			--因为要触发下一个主城的引导第二关的事件，这里模拟触发事件
			--hGlobal.event:event("LocalEvent_EnterGuideProgress", hVar.PHONE_MAINMENU, __G_MainMenuWorld, "map")
			hGlobal.event:event("LocalEvent_EnterGuideProgress", hVar.PHONE_SELECTLEVEL, __G_SelectMapWorld, "map", 0)
		end
	end
	
	--开始引导战术技能卡界面
	function BeginGuideTacticFrm()
		--读取存档里是否新手引导的标记
		local guideFlag = LuaGetPlayerGuideFlag(g_curPlayerName)
		
		--Ok的回调
		local function okCallback(checkboxState)
			--标记状态为引导结束
			hGlobal.UI.GuideTacticFrmState = hGlobal.UI.GuideTacticStateType.GUIDE_END
			
			--清除整个战术卡界面
			if hGlobal.UI.GuideTacticFrmMenuBar then --界面
				hGlobal.UI.GuideTacticFrmMenuBar:del()
				hGlobal.UI.GuideTacticFrmMenuBar = nil
			end
			
			--标记主城引导战术卡界面完成（取消引导）
			LuaSetPlayerGuideState(g_curPlayerName, "town/town_mainmenu", 6)
			
			--因为要触发下一个主城的引导第二关的事件，这里模拟触发事件
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
			if (hGlobal.UI.GuideTacticFrmState == hGlobal.UI.GuideTacticStateType.NONE) then --初始状态
				--hGlobal.UI.GuideTacticFrmState = hGlobal.UI.GuideTacticStateType.GUIDE_CLICK_HERO
				--选中无
				
				OnClickGuideTacticFrmFrame_Event(0, 0)
			end
			
			--如果勾选了下次不再显示，那么存档本次设置
			if (checkboxState == 1) then
				--标记存档的新手引导标记
				LuaSetPlayerGuideFlag(g_curPlayerName, 1) --是否需要引导的标记（0:未设置 / -1:不需要引导 /1:需要引导）
			end
		end
		
		--创建提示是否取消引导的框
		if (guideFlag == 0) then
			MsgBox_GuideSkip(okCallback, cancelCallback, "战术卡操作指导")
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
	
	--显示对话框：引导主城战术卡界面战术卡介绍
	function __Dialogue_GuideTacticFrm_TacticIntroduce()
		print("显示对话框：引导主城战术卡界面战术卡介绍")
		__createMapTalkHeroFrm("step1", "$_001_lsc_50", OnClickGuideTacticFrmFrame_Event, 0, 0)
	end
	
	--显示对话框：引导主城战术卡界面点击战术卡按钮
	function __Dialogue_GuideTacticFrm_Click_TacticBtn()
		print("显示对话框：引导主城战术卡界面点击战术卡按钮")
		__createMapTalkHeroFrm("step2", "$_001_lsc_51", OnClickGuideTacticFrmFrame_Event, 0, 0)
	end
	
	
	--显示对话框：介绍战术卡的一些附加说明
	function __Dialogue_GuideTacticFrm_Introduce_GuideExtraInfo()
		print("显示对话框：介绍战术卡的一些附加说明")
		__createMapTalkHeroFrm("step3", "$_001_lsc_52", OnClickGuideTacticFrmFrame_Event, 0, 0)
	end
	
	--开始引导第战术卡界面
	BeginGuideTacticFrm()
end

--test
--测试引导战术技能卡流程
--CreateGuideFrame_TacticFrm()


