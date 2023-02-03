





--创建主城引导任务成就领取
function CreateGuideFrame_TaskFrm()
	--主城引导成就领取
	hGlobal.UI.GuideTaskStateType =
	{
		NONE = 0, --初始状态
		GUIDE_CLICK_TASK_BTN = 1, --提示点击成就按钮
		GUIDE_WAIT_CLICK_TASKBTN = 2, --等待点击任务按钮
		GUIDE_WAIT_CLICK_MEDAL = 3, --等待点击成就分页按钮
		GUIDE_WAIT_CLICK_FIRST_ACHIV = 4, --等待点击第一个成就按钮
		GUIDE_WAIT_CLICK_LINGJIANG = 5, --等待点击领奖按钮
		GUIDE_WAIT_ANIM = 6, --等待动画完成
		GUIDE_EXTRA_INTRO = 7, --介绍任务成就的一些附加说明
		GUIDE_WAIT_CLICK_CLOSE = 8, --等待点击关闭按钮
		GUIDE_END = 9, --引导结束
	}
	
	--引导的当前状态
	hGlobal.UI.GuideTaskFrmState = hGlobal.UI.GuideTaskStateType.NONE --一开始为初始状态 --flag1 GUIDE_END  NONE   flag1
	
	--test: 重复测试，删除前一个控件
	if hGlobal.UI.GuideTaskHandEffect then --提示点击任务的手的特效
		hGlobal.UI.GuideTaskHandEffect:del()
		hGlobal.UI.GuideTaskHandEffect = nil
	end
	if hGlobal.UI.GuideTaskRoundEffect then --提示点击任务的转圈圈特效
		hGlobal.UI.GuideTaskRoundEffect:del()
		hGlobal.UI.GuideTaskRoundEffect = nil
	end
	if hGlobal.UI.GuideClickMedalPageHandEffect then --提示点击成就分页按钮的手的特效
		hGlobal.UI.GuideClickMedalPageHandEffect:del()
		hGlobal.UI.GuideClickMedalPageHandEffect = nil
	end
	if hGlobal.UI.GuideClickMedalPageBtnRoundEffect then --提示点击成就分页按钮的转圈圈特效
		hGlobal.UI.GuideClickMedalPageBtnRoundEffect:del()
		hGlobal.UI.GuideClickMedalPageBtnRoundEffect = nil
	end
	if hGlobal.UI.GuideClickFirstAchivHandEffect then --提示点击第一个成就按钮的手的特效
		hGlobal.UI.GuideClickFirstAchivHandEffect:del()
		hGlobal.UI.GuideClickFirstAchivHandEffect = nil
	end
	if hGlobal.UI.GuideClickFirstAchivBtnRoundEffect then --提示点击第一个成就按钮的转圈圈特效
		hGlobal.UI.GuideClickFirstAchivBtnRoundEffect:del()
		hGlobal.UI.GuideClickFirstAchivBtnRoundEffect = nil
	end
	if hGlobal.UI.GuideClickLingJiangHandEffect then --提示点击领取成就按钮的手特效
		hGlobal.UI.GuideClickLingJiangHandEffect:del()
		hGlobal.UI.GuideClickLingJiangHandEffect = nil
	end
	if hGlobal.UI.GuideClickLingJiangBtnRoundEffect then --提示点击领取成就按钮按钮的转圈圈特效
		hGlobal.UI.GuideClickLingJiangBtnRoundEffect:del()
		hGlobal.UI.GuideClickLingJiangBtnRoundEffect = nil
	end
	if hGlobal.UI.GuideClickCloseHandEffect then --提示点击关闭按钮的手特效
		hGlobal.UI.GuideClickCloseHandEffect:del()
		hGlobal.UI.GuideClickCloseHandEffect = nil
	end
	if hGlobal.UI.GuideClickCloseBtnRoundEffect then --提示点击关闭按钮按钮的转圈圈特效
		hGlobal.UI.GuideClickCloseBtnRoundEffect:del()
		hGlobal.UI.GuideClickCloseBtnRoundEffect = nil
	end
	
	
	if hGlobal.UI.GuideTaskFrmMenuBar then --引导成就的主界面
		hGlobal.UI.GuideTaskFrmMenuBar:del()
		hGlobal.UI.GuideTaskFrmMenuBar = nil
	end
	
	--创建引导成就的主界面
	--创建父容器
	hGlobal.UI.GuideTaskFrmMenuBar = hUI.frame:new({
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
				--点击引导成就操作界面事件
				--local worldX, worldY = hApi.view2world(screenX, hVar.SCREEN.h - screenY) --大地图的坐标
				OnClickGuideTaskFrmFrame_Event(screenX, screenY)
			end
		end
	})
	hGlobal.UI.GuideTaskFrmMenuBar:active() --最前端显示
	
	--点击引导成就操作界面的事件
	function OnClickGuideTaskFrmFrame_Event(clickScreenX, clickScreenY)
		if (hGlobal.UI.GuideTaskFrmState == hGlobal.UI.GuideTaskStateType.NONE) then --初始状态
			--geyachao: 标记当前正在引导中
			hVar.IS_IN_GUIDE_STATE = 1
			--print("XXXXXXXXXXXXXXX -----> hVar.IS_IN_GUIDE_STATE = 1, 点击引导成就操作界面")
			
			--进入下个状态: 开场简介
			hGlobal.UI.GuideTaskFrmState = hGlobal.UI.GuideTaskStateType.GUIDE_CLICK_TASK_BTN
			
			--显示对话框：引导提示成就按钮
			__Dialogue_GuideTaskFrm_TaskIntroduce()
		elseif (hGlobal.UI.GuideTaskFrmState == hGlobal.UI.GuideTaskStateType.GUIDE_CLICK_TASK_BTN) then --提示点击成就按钮
			--创建提示点击任务按钮的转圈圈特效
			hGlobal.UI.GuideTaskRoundEffect = hUI.image:new({
				parent = hGlobal.UI.GuideTaskFrmMenuBar.handle._n,
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
			hGlobal.UI.GuideTaskRoundEffect.handle.s:setColor(ccc3(0, 255, 0)) --绿色
			hGlobal.UI.GuideTaskRoundEffect.handle.s:setOpacity(0) --geyachao: 应x3的邪恶需求，换个特效
			local decal, count = 11, 0 --光晕效果
			local r, g, b, parent = 150, 128, 64
			local parent = hGlobal.UI.GuideTaskRoundEffect.handle._n
			local offsetX, offsetY, duration, scale = 32, 30, 0.4, 1.05
			local nnn = xlAddNormalLightEffect(decal,count,offsetX,offsetY,duration,scale,r,g,b,parent)
			nnn:setScale(2.3)
			
			--创建提示点击任务按钮的手特效
			hGlobal.UI.GuideTaskHandEffect = hUI.image:new({
				parent = hGlobal.UI.GuideTaskFrmMenuBar.handle._n,
				model = "MODEL_EFFECT:Hand",
				x = hVar.SCREEN.w - 60 - 110,
				y = 65 + 40 + 5, --统一调整底部条y坐标
				scale = 1.5,
				z = 100,
			})
			--hGlobal.UI.GuideTaskHandEffect.handle.s:setColor(ccc3(255, 255, 0))
			
			--进入下个状态: 等待点击任务按钮
			hGlobal.UI.GuideTaskFrmState = hGlobal.UI.GuideTaskStateType.GUIDE_WAIT_CLICK_TASKBTN
			
			--显示对话框：引导主城任务界面点击任务按钮
			__Dialogue_GuideTaskFrm_Click_TaskBtn()
			
			--geyachao: 无主城模式（有可能不响应frame点击事件，莫名其妙任务按钮在最前端，只会响应按钮点击事件，所以这里特殊处理一下）
			--监听英雄界面打开事件
			hGlobal.event:listen("LocalEvent_Click_Guide_TaskButton", "GuideShowTaskFrm", function()
				--print("删除引导主界面")
				--删除监听事件
				hGlobal.event:listen("LocalEvent_Click_Guide_TaskButton", "GuideShowTaskFrm", nil)
				
				--强制跳转到下个状态
				local bx = hVar.SCREEN.w - 60 - 110
				local by = 65 + 5 --统一调整底部条y坐标
				local w = 90
				local h = 90
				local button_left = bx - w / 2 --英雄选中区域的最左侧
				local button_right = bx + w / 2 --英雄选中区域的最右侧
				local button_top = by - h / 2 --英雄选中区域的最上侧
				local button_bottom = by + h / 2 --英雄选中区域的最下侧
				OnClickGuideTaskFrmFrame_Event((button_left + button_right) / 2, (button_top + button_bottom) / 2)
			end)
		elseif (hGlobal.UI.GuideTaskFrmState == hGlobal.UI.GuideTaskStateType.GUIDE_WAIT_CLICK_TASKBTN) then --提示点击任务按钮
			local bx = hVar.SCREEN.w - 60 - 110
			local by = 75
			local w = 90
			local h = 90
			local button_left = bx - w / 2 --英雄选中区域的最左侧
			local button_right = bx + w / 2 --英雄选中区域的最右侧
			local button_top = by - h / 2 --英雄选中区域的最上侧
			local button_bottom = by + h / 2 --英雄选中区域的最下侧
			
			--检测是否点击到了任务按钮
			if (clickScreenX >= button_left) and (clickScreenX <= button_right) and (clickScreenY >= button_top) and (clickScreenY <= button_bottom) then
				--删除提示点击任务按钮的手特效
				if hGlobal.UI.GuideTaskHandEffect then --点击任务的手的特效
					hGlobal.UI.GuideTaskHandEffect:del()
					hGlobal.UI.GuideTaskHandEffect = nil
				end
				
				--删除提示点击任务按钮的转圈圈特效
				if hGlobal.UI.GuideTaskRoundEffect then --点击任务的手的特效
					hGlobal.UI.GuideTaskRoundEffect:del()
					hGlobal.UI.GuideTaskRoundEffect = nil
				end
				
				--删除监听事件
				hGlobal.event:listen("LocalEvent_Click_Guide_TaskButton", "GuideShowTaskFrm", nil)
				
				--geyachao: 无主城模式的新流程
				hGlobal.event:event("LocalEvent_Phone_ShowMyTask")
				
				--删除引导任务操作主界面
				if hGlobal.UI.GuideTaskFrmMenuBar then
					hGlobal.UI.GuideTaskFrmMenuBar:del()
					hGlobal.UI.GuideTaskFrmMenuBar = nil
				end
				
				--重新创建父容器
				hGlobal.UI.GuideTaskFrmMenuBar = hUI.frame:new({
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
							OnClickGuideTaskFrmFrame_Event(screenX, screenY)
						end
					end
				})
				hGlobal.UI.GuideTaskFrmMenuBar:active() --最前端显示
				
				--创建提示点击成就分页按钮的转圈圈特效
				hGlobal.UI.GuideClickMedalPageBtnRoundEffect = hUI.image:new({
					parent = nil,
					model = "MODEL_EFFECT:strengthen",
					x = hVar.SCREEN.w / 2 - 800 / 2 + 120,
					y = hVar.SCREEN.h / 2 + 550 / 2 - 20 - 18,
					--w = 200,
					--h = 70,
					--scale = 1.2,
					w = 100,
					h = 100,
					scale = 1.0,
					z = 100,
				})
				hGlobal.UI.GuideClickMedalPageBtnRoundEffect.handle.s:setColor(ccc3(0, 255, 0)) --绿色
				hGlobal.UI.GuideClickMedalPageBtnRoundEffect.handle.s:setOpacity(0) --geyachao: 应x3的邪恶需求，换个特效
				local decal, count = 11, 0 --光晕效果
				local r, g, b, parent = 150, 128, 64
				local parent = hGlobal.UI.GuideClickMedalPageBtnRoundEffect.handle._n
				local offsetX, offsetY, duration, scale = 30, 30, 0.4, 1.05
				local nnn = xlAddNormalLightEffect(decal,count,offsetX,offsetY,duration,scale,r,g,b,parent)
				nnn:setScale(1.4)
				
				--创建提示点击成就分页按钮的手特效
				hGlobal.UI.GuideClickMedalPageHandEffect = hUI.image:new({
					parent = nil,
					model = "MODEL_EFFECT:Hand",
					x = hVar.SCREEN.w / 2 - 800 / 2 + 120,
					y = hVar.SCREEN.h / 2 + 550 / 2 - 20,
					scale = 1.5,
					z = 100,
				})
				--hGlobal.UI.GuideClickMedalPageHandEffect.handle.s:setColor(ccc3(255, 255, 0))
				
				--进入下一状态：提示点击成就按钮
				hGlobal.UI.GuideTaskFrmState = hGlobal.UI.GuideTaskStateType.GUIDE_WAIT_CLICK_MEDAL
				
				--无对话
				--...
			end
		elseif (hGlobal.UI.GuideTaskFrmState == hGlobal.UI.GuideTaskStateType.GUIDE_WAIT_CLICK_MEDAL) then --等待点击成就分页按钮
			local bx = hVar.SCREEN.w / 2 - 800 / 2 + 120
			local by = hVar.SCREEN.h / 2 + 550 / 2 - 20 - 18
			local w = 200
			local h = 70
			local button_left = bx - w / 2 --英雄选中区域的最左侧
			local button_right = bx + w / 2 --英雄选中区域的最右侧
			local button_top = by - h / 2 --英雄选中区域的最上侧
			local button_bottom = by + h / 2 --英雄选中区域的最下侧
			
			--检测是否点击到了成就分页按钮
			if (clickScreenX >= button_left) and (clickScreenX <= button_right) and (clickScreenY >= button_top) and (clickScreenY <= button_bottom) then
				--删除提示点击成就分页按钮的手特效
				if hGlobal.UI.GuideClickMedalPageHandEffect then --点击成就分页按钮的手特效
					hGlobal.UI.GuideClickMedalPageHandEffect:del()
					hGlobal.UI.GuideClickMedalPageHandEffect = nil
				end
				
				--删除提示点击成就分页按钮的转圈圈特效
				if hGlobal.UI.GuideClickMedalPageBtnRoundEffect then --点击成就分页按钮的转圈圈特效
					hGlobal.UI.GuideClickMedalPageBtnRoundEffect:del()
					hGlobal.UI.GuideClickMedalPageBtnRoundEffect = nil
				end
				
				--模拟点击成就分页
				local _frm = hGlobal.UI.PhoneTaskFrm
				_frm.childUI["PageBtn1"].data.code()
				
				--创建提示点击第一个成就按钮按钮的转圈圈特效
				hGlobal.UI.GuideClickFirstAchivBtnRoundEffect = hUI.image:new({
					parent = nil,
					model = "MODEL_EFFECT:strengthen",
					x = hVar.SCREEN.w / 2 - 800 / 2 + 115,
					y = hVar.SCREEN.h / 2 + 550 / 2 - 125,
					--w = 260,
					--h = 90,
					--scale = 1.2,
					w = 100,
					h = 100,
					scale = 1.0,
					z = 100,
				})
				hGlobal.UI.GuideClickFirstAchivBtnRoundEffect.handle.s:setColor(ccc3(0, 255, 0)) --绿色
				hGlobal.UI.GuideClickFirstAchivBtnRoundEffect.handle.s:setOpacity(0) --geyachao: 应x3的邪恶需求，换个特效
				local decal, count = 11, 0 --光晕效果
				local r, g, b, parent = 150, 128, 64
				local parent = hGlobal.UI.GuideClickFirstAchivBtnRoundEffect.handle._n
				local offsetX, offsetY, duration, scale = 30, 30, 0.4, 1.05
				local nnn = xlAddNormalLightEffect(decal,count,offsetX,offsetY,duration,scale,r,g,b,parent)
				nnn:setScale(1.5)
				
				--创建提示点击第一个成就按钮的手特效
				hGlobal.UI.GuideClickFirstAchivHandEffect = hUI.image:new({
					parent = nil,
					model = "MODEL_EFFECT:Hand",
					x = hVar.SCREEN.w / 2 - 800 / 2 + 115,
					y = hVar.SCREEN.h / 2 + 550 / 2 - 125 + 20,
					scale = 1.5,
					z = 100,
				})
				--hGlobal.UI.GuideClickFirstAchivHandEffect.handle.s:setColor(ccc3(255, 255, 0))
				
				--进入下一状态：提示点击第一个成就按钮
				hGlobal.UI.GuideTaskFrmState = hGlobal.UI.GuideTaskStateType.GUIDE_WAIT_CLICK_FIRST_ACHIV
				
				--无对话
				--...
			end
		elseif (hGlobal.UI.GuideTaskFrmState == hGlobal.UI.GuideTaskStateType.GUIDE_WAIT_CLICK_FIRST_ACHIV) then --等待点击第一个成就按钮
			local bx = hVar.SCREEN.w / 2 - 800 / 2 + 115
			local by = hVar.SCREEN.h / 2 + 550 / 2 - 125
			local w = 260
			local h = 90
			local button_left = bx - w / 2 --英雄选中区域的最左侧
			local button_right = bx + w / 2 --英雄选中区域的最右侧
			local button_top = by - h / 2 --英雄选中区域的最上侧
			local button_bottom = by + h / 2 --英雄选中区域的最下侧
			
			--检测是否点击到了第一个成就按钮
			if (clickScreenX >= button_left) and (clickScreenX <= button_right) and (clickScreenY >= button_top) and (clickScreenY <= button_bottom) then
				--删除提示点击第一个成就按钮的手特效
				if hGlobal.UI.GuideClickFirstAchivHandEffect then --点击第一个成就按钮的手特效
					hGlobal.UI.GuideClickFirstAchivHandEffect:del()
					hGlobal.UI.GuideClickFirstAchivHandEffect = nil
				end
				
				--删除提示点击第一个成就按钮的转圈圈特效
				if hGlobal.UI.GuideClickFirstAchivBtnRoundEffect then --点击第一个成就按钮的转圈圈特效
					hGlobal.UI.GuideClickFirstAchivBtnRoundEffect:del()
					hGlobal.UI.GuideClickFirstAchivBtnRoundEffect = nil
				end
				
				--模拟点击第一个成就
				local _frm = hGlobal.UI.PhoneTaskFrm
				local _frmNode = _frm.childUI["PageNode"]
				local ctrli = _frmNode.childUI["AchievementNode1"]
				local cx = ctrli.data.x --中心点x坐标
				local cy = ctrli.data.y --中心点y坐标
				_frmNode.childUI["AchievementDragPanel"].data.code(self, cx, cy, 1)
				
				--创建提示点击领取成就按钮按钮的转圈圈特效
				hGlobal.UI.GuideClickLingJiangBtnRoundEffect = hUI.image:new({
					parent = nil,
					model = "MODEL_EFFECT:strengthen",
					x = hVar.SCREEN.w / 2 - 800 / 2 + 660,
					y = hVar.SCREEN.h / 2 + 550 / 2 - 501,
					--w = 280,
					--h = 90,
					--scale = 1.2,
					w = 100,
					h = 100,
					scale = 1.0,
					z = 100,
				})
				hGlobal.UI.GuideClickLingJiangBtnRoundEffect.handle.s:setColor(ccc3(0, 255, 0)) --绿色
				hGlobal.UI.GuideClickLingJiangBtnRoundEffect.handle.s:setOpacity(0) --geyachao: 应x3的邪恶需求，换个特效
				local decal, count = 11, 0 --光晕效果
				local r, g, b, parent = 150, 128, 64
				local parent = hGlobal.UI.GuideClickLingJiangBtnRoundEffect.handle._n
				local offsetX, offsetY, duration, scale = 30, 30, 0.4, 1.05
				local nnn = xlAddNormalLightEffect(decal,count,offsetX,offsetY,duration,scale,r,g,b,parent)
				nnn:setScale(1.6)
				
				--创建提示点击领取成就按钮的手特效
				hGlobal.UI.GuideClickLingJiangHandEffect = hUI.image:new({
					parent = nil,
					model = "MODEL_EFFECT:Hand",
					x = hVar.SCREEN.w / 2 - 800 / 2 + 660,
					y = hVar.SCREEN.h / 2 + 550 / 2 - 501 + 20,
					scale = 1.5,
					z = 100,
				})
				--hGlobal.UI.GuideClickLingJiangHandEffect.handle.s:setColor(ccc3(255, 255, 0))
				
				--进入下一状态：提示点击领奖按钮
				hGlobal.UI.GuideTaskFrmState = hGlobal.UI.GuideTaskStateType.GUIDE_WAIT_CLICK_LINGJIANG
				
				--无对话
				--...
			end
		elseif (hGlobal.UI.GuideTaskFrmState == hGlobal.UI.GuideTaskStateType.GUIDE_WAIT_CLICK_LINGJIANG) then --等待点击领奖按钮
			local bx = hVar.SCREEN.w / 2 - 800 / 2 + 660
			local by = hVar.SCREEN.h / 2 + 550 / 2 - 501
			local w = 280
			local h = 90
			local button_left = bx - w / 2 --英雄选中区域的最左侧
			local button_right = bx + w / 2 --英雄选中区域的最右侧
			local button_top = by - h / 2 --英雄选中区域的最上侧
			local button_bottom = by + h / 2 --英雄选中区域的最下侧
			
			--检测是否点击到了领奖按钮
			if (clickScreenX >= button_left) and (clickScreenX <= button_right) and (clickScreenY >= button_top) and (clickScreenY <= button_bottom) then
				--删除提示点击领奖按钮的手特效
				if hGlobal.UI.GuideClickLingJiangHandEffect then --点击领奖按钮的手特效
					hGlobal.UI.GuideClickLingJiangHandEffect:del()
					hGlobal.UI.GuideClickLingJiangHandEffect = nil
				end
				
				--删除提示点击领奖按钮的转圈圈特效
				if hGlobal.UI.GuideClickLingJiangBtnRoundEffect then --点击领奖按钮的转圈圈特效
					hGlobal.UI.GuideClickLingJiangBtnRoundEffect:del()
					hGlobal.UI.GuideClickLingJiangBtnRoundEffect = nil
				end
				
				--领取第一个成就
				local _frm = hGlobal.UI.PhoneTaskFrm
				local _frmNode = _frm.childUI["PageNode"]
				_frmNode.childUI["AchievementBtnLingJiang"].data.code()
				
				--延时创建对话框
				--（为了看清楚领奖的奖品动画）
				local delay = CCDelayTime:create(2.6)
				local actCall = CCCallFunc:create(function(ctrl)
					--print("__TIMER_GUIDE_TASK_ONCE____TIMER_GUIDE_TASK_ONCE____TIMER_GUIDE_TASK_ONCE__")
					
					--进入下一个状态：介绍任务成就的一些附加说明
					hGlobal.UI.GuideTaskFrmState = hGlobal.UI.GuideTaskStateType.GUIDE_EXTRA_INTRO
					
					--对话：介绍任务成就的一些附加说明
					__Dialogue_GuideTaskFrm_Introduce_GuideExtraInfo()
				end)
				local actSeq = CCSequence:createWithTwoActions(delay, actCall)
				hGlobal.UI.GuideTaskFrmMenuBar.handle._n:runAction(actSeq)
				
				--进入下一个状态:等到动画完成
				hGlobal.UI.GuideTaskFrmState = hGlobal.UI.GuideTaskStateType.GUIDE_WAIT_ANIM
				
				--无对话
				--...
			end
		elseif (hGlobal.UI.GuideTaskFrmState == hGlobal.UI.GuideTaskStateType.GUIDE_WAIT_ANIM) then --等待动画完成
			--不作处理：timer到了会进入下一个状态
			--...
		elseif (hGlobal.UI.GuideTaskFrmState == hGlobal.UI.GuideTaskStateType.GUIDE_EXTRA_INTRO) then --介绍任务成就的一些附加说明
			--创建提示点击关闭按钮按钮的转圈圈特效
			local closeDx = -5
			local closeDy = -5
			if (g_phone_mode ~= 0) then
				closeDx = 0
				closeDy = -20
			end
			local _frm = hGlobal.UI.PhoneTaskFrm
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
				y = _frm.data.y + closeDy - 30,
				scale = 1.5,
				z = 100,
			})
			hGlobal.UI.GuideClickCloseHandEffect.handle.s:setRotation(180)
			--hGlobal.UI.GuideClickCloseHandEffect.handle.s:setColor(ccc3(255, 255, 0))
			
			--进入下一个状态：等待关闭按钮
			hGlobal.UI.GuideTaskFrmState = hGlobal.UI.GuideTaskStateType.GUIDE_WAIT_CLICK_CLOSE
			
			--无对话
			--...
		elseif (hGlobal.UI.GuideTaskFrmState == hGlobal.UI.GuideTaskStateType.GUIDE_WAIT_CLICK_CLOSE) then --提示点击关闭按钮
			local closeDx = -5
			local closeDy = -5
			if (g_phone_mode ~= 0) then
				closeDx = 0
				closeDy = -20
			end
			local _frm = hGlobal.UI.PhoneTaskFrm
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
				hGlobal.UI.GuideTaskFrmState = hGlobal.UI.GuideTaskStateType.GUIDE_END
				
				--强制跳转到下一个状态
				OnClickGuideTaskFrmFrame_Event(0, 0)
			end
		
		elseif (hGlobal.UI.GuideTaskFrmState == hGlobal.UI.GuideTaskStateType.GUIDE_END) then --引导结束
			--删除整个界面
			if hGlobal.UI.GuideTaskFrmMenuBar then --引导升级塔高级技能的
				hGlobal.UI.GuideTaskFrmMenuBar:del()
				hGlobal.UI.GuideTaskFrmMenuBar = nil
			end
			
			--在领取成就后就标记引导任务成就界面完成（防止领取后直接关闭窗口）
			--标记主城引导任务成就界面完成
			LuaSetPlayerGuideState(g_curPlayerName, "town/town_mainmenu", 3)
			
			--模拟关闭界面
			local _frm = hGlobal.UI.PhoneTaskFrm
			_frm.childUI["closeBtn"].data.code()
			
			--geyachao: 标记当前不在引导中
			hVar.IS_IN_GUIDE_STATE = 0
			--print("XXXXXXXXXXXXXXX -----> hVar.IS_IN_GUIDE_STATE = 0, 点击引导成就操作界面")
			
			--因为要触发下一个主城的引导第二关的事件，这里模拟触发事件
			--hGlobal.event:event("LocalEvent_EnterGuideProgress", hVar.PHONE_MAINMENU, __G_MainMenuWorld, "map")
			hGlobal.event:event("LocalEvent_EnterGuideProgress", hVar.PHONE_SELECTLEVEL, __G_SelectMapWorld, "map", 0)
		end
	end
	
	--开始引导主城查看英雄界面和穿装、升级技能
	function BeginGuideTaskFrm()
		--读取存档里是否新手引导的标记
		local guideFlag = LuaGetPlayerGuideFlag(g_curPlayerName)
		
		--Ok的回调
		local function okCallback(checkboxState)
			--标记状态为引导结束
			hGlobal.UI.GuideTaskFrmState = hGlobal.UI.GuideTaskStateType.GUIDE_END
			
			--清除整个任务成就界面
			if hGlobal.UI.GuideTaskFrmMenuBar then --界面
				hGlobal.UI.GuideTaskFrmMenuBar:del()
				hGlobal.UI.GuideTaskFrmMenuBar = nil
			end
			
			--标记主城引导英雄界面完成（取消引导）
			LuaSetPlayerGuideState(g_curPlayerName, "town/town_mainmenu", 2)
			
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
			if (hGlobal.UI.GuideTaskFrmState == hGlobal.UI.GuideTaskStateType.NONE) then --初始状态
				--hGlobal.UI.GuideTaskFrmState = hGlobal.UI.GuideTaskStateType.GUIDE_CLICK_HERO
				--选中无
				
				OnClickGuideTaskFrmFrame_Event(0, 0)
			end
			
			--如果勾选了下次不再显示，那么存档本次设置
			if (checkboxState == 1) then
				--标记存档的新手引导标记
				LuaSetPlayerGuideFlag(g_curPlayerName, 1) --是否需要引导的标记（0:未设置 / -1:不需要引导 /1:需要引导）
			end
		end
		
		--创建提示是否取消引导的框
		if (guideFlag == 0) then
			MsgBox_GuideSkip(okCallback, cancelCallback, "任务操作指导")
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
	
	--显示对话框：引导主城任务界面任务介绍
	function __Dialogue_GuideTaskFrm_TaskIntroduce()
		print("显示对话框：引导主城任务界面任务介绍")
		__createMapTalkHeroFrm("step1", "$_001_lsc_31", OnClickGuideTaskFrmFrame_Event, 0, 0)
	end
	
	--显示对话框：引导主城任务界面点击任务按钮
	function __Dialogue_GuideTaskFrm_Click_TaskBtn()
		print("显示对话框：引导主城任务界面点击任务按钮")
		__createMapTalkHeroFrm("step2", "$_001_lsc_32", OnClickGuideTaskFrmFrame_Event, 0, 0)
	end
	
	
	--显示对话框：介绍任务成就的一些附加说明
	function __Dialogue_GuideTaskFrm_Introduce_GuideExtraInfo()
		print("显示对话框：介绍任务成就的一些附加说明")
		__createMapTalkHeroFrm("step3", "$_001_lsc_33", OnClickGuideTaskFrmFrame_Event, 0, 0)
	end
	
	--开始引导任务成就界面
	BeginGuideTaskFrm()
end

--test
--测试引导任务成就流程
--CreateGuideFrame_TaskFrm()



