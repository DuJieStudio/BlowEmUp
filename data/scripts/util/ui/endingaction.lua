hGlobal.UI.InitEndingFrm = function()
	local _bCanCloseAction = false
	local _CODE_ClearFunc = hApi.DoNothing
	local _CODE_CreateEndingAction = hApi.DoNothing

	_CODE_ClearFunc = function()
		_bCanCloseAction = false
		if hGlobal.UI.EndingFrm then
			hGlobal.UI.EndingFrm:del()
			hGlobal.UI.EndingFrm = nil
		end
	end

	_CODE_CreateEndingAction = function()
		if hGlobal.UI.EndingFrm then
			hGlobal.UI.EndingFrm:del()
			hGlobal.UI.EndingFrm = nil
		end
		hGlobal.UI.EndingFrm = hUI.frame:new({
			x = 0,
			y = 0,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			show = 0,
			dragable = 2,
			buttononly = 1,
			autoactive = 0,
			border = 0,
		})

		local _frm = hGlobal.UI.EndingFrm
		local _childUI = _frm.childUI
		local _parent = _frm.handle._n

		_childUI["btn_close"] = hUI.button:new({
			parent = _parent,
			--model = "misc/mask.png",
			model = "misc/mask_white.png",
			dragbox = _childUI["dragBox"],
			x = hVar.SCREEN.w/2,
			y = hVar.SCREEN.h/2,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			code = function()
				if _bCanCloseAction then
					hApi.safeRemoveT(_childUI,"node")
					--_CODE_ClearFunc()
					hGlobal.event:event("LocalEvent_ShowTotalSettlement")
				end
			end,
		})
		local fadetime = 1
		local scale = 0.6
		local movetime = 0.3
		_childUI["btn_close"].handle.s:setColor(ccc3(0,0,0))
		_childUI["btn_close"].handle.s:runAction(CCEaseSineOut:create(CCFadeIn:create(fadetime)))

		_childUI["node"] = hUI.button:new({
			parent = _parent,
			model = "misc/button_null.png",
			x = hVar.SCREEN.w/2,
			y = hVar.SCREEN.h/2 + 40,
		})
		_childUI["node"].handle._n:setScale(scale)

		local tobeicon = "misc/ending/tobe.png"
		local continuedicon = "misc/ending/continued.png"
		if g_Cur_Language ~= 1 then
			tobeicon = "misc/ending/tobe_en.png"
			continuedicon = "misc/ending/continued_en.png"
		end
		_childUI["node"].childUI["img_tobe"] = hUI.image:new({
			parent = _childUI["node"].handle._n,
			model = tobeicon,
			x = -360 +  hVar.SCREEN.w / scale,
			y = 176/2,
		})

		_childUI["node"].childUI["img_continued"] = hUI.image:new({
			parent = _childUI["node"].handle._n,
			model = continuedicon,
			x = - hVar.SCREEN.w / scale,
			y = -224/2,
		})

		local act1 = CCDelayTime:create(fadetime)
		local act2 = CCCallFunc:create(function()
			_childUI["node"].childUI["img_tobe"].handle.s:runAction(CCMoveTo:create(movetime,ccp(-360,176/2)))
			_childUI["node"].childUI["img_continued"].handle.s:runAction(CCMoveTo:create(movetime,ccp(0, -224/2)))
		end)
		local act3 = CCDelayTime:create(movetime)
		local act4 = CCCallFunc:create(function()
			_bCanCloseAction = true
		end)

		local a = CCArray:create()
		a:addObject(act1)
		a:addObject(act2)
		a:addObject(act3)
		a:addObject(act4)
		local sequence = CCSequence:create(a)
		_childUI["node"].handle.s:runAction(sequence)

		_frm:show(1)
		_frm:active()
	end

	hGlobal.event:listen("LocalEvent_CloseEndingAction","showaction",function()
		_CODE_ClearFunc()
	end)

	hGlobal.event:listen("LocalEvent_ShowEndingAction","showaction",function()
		_CODE_CreateEndingAction()
	end)
end