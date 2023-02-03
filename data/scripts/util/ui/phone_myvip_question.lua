hGlobal.UI.InitMyVIPQuestion = function()
	local sv = nil
	local _OnlyRun = 1
	local PromptMessageRedEquipY = 0
	local _RedEquipIcon = {1,3,1,2,4,3}
	local _touchY = 0
	local _index = 1
	local _PageNumber = 1
	local HideChild = {}
	
	hGlobal.UI.PhoneMyVIP_QuestionFrm =hUI.frame:new({
			x = hVar.SCREEN.w/2 - 440,
			y = hVar.SCREEN.h/2 + 280,
			h = 570,
			w = 880,
			show = 0,
			dragable = 3,										--changed by pangyong 2015/4/9
			titlebar = 0,
			bgAlpha = 0,
			bgMode = "tile",
			background = "UI:tip_item",
			border = 1,
			autoactive = 0,
			codeOnDragEx = function(touchX,touchY,touchMode)
				if touchMode == 0 then
					if sv ~= nil then
						_touchY = touchY
					end
				end

				if touchMode == 2 then
					if sv ~= nil then
						_touchY = _touchY - touchY
						if math.abs(_touchY) > 75 then
							_PageNumber = math.ceil(_touchY/75)
							_PageNumber = math.abs(_PageNumber)
							if _touchY < 0 then
								if _index+4 <= 6 - _PageNumber then
									_index = _index + _PageNumber
								else
									_index = 3
								end
								sv.scrollview:setContentOffsetInDuration(ccp(0,(125*_index)-9625),0.3)
	
							elseif _touchY > 0 then
								if _index - _PageNumber > 1 then
									_index = _index - _PageNumber
								else
									_index = 1
								end
								sv.scrollview:setContentOffsetInDuration(ccp(0,(125*_index)-9625),0.3)
							end
						else
							if _touchY ~= 0 then
								sv.scrollview:setContentOffsetInDuration(ccp(0,(125*_index)-9625),0.3)
							end
						end
					end
				end
			end,
	})

	local _frm = hGlobal.UI.PhoneMyVIP_QuestionFrm
	local _childUI = _frm.childUI
	local _parent = _frm.handle._n

	

	--退出按钮
	_childUI["btnClose1"] = hUI.button:new({
		parent = _parent,
		model = "BTN:PANEL_CLOSE",
		dragbox = _childUI["dragBox"],
		scaleT = 0.9,
		x = 870,
		y = -10,
		--w = hVar.CloseButtonWH[1],
		--h = hVar.CloseButtonWH[2],
		code = function()
			_frm:show(0)
			--if #HideChild > 0 then
				--for i = 1,#HideChild do
					--hApi.safeRemoveT(_childUI,HideChild[i])
				--end
				--HideChild = {}
			--end
		end,
	})

	--分界线1
	_childUI["apartline_1"] = hUI.image:new({
		parent = _parent,
		model = "UI:panel_part_09",
		x = _frm.data.w/2,
		y = -65,
		w = 930,
		h = 8,
	})

	--提示
	_childUI["PromptInfo"]  = hUI.label:new({
		parent = _parent,
		size = 45,
		align = "LT",
		font = hVar.FONTC,
		x = _frm.data.w/2 - 150,
		y = -10,
		--width = 300,
		text = hVar.tab_string["__TEXT_Question_Prompt"],
		--RGB = {255,0,0},
	})
	
	local PromptMessageNodeY = 9985
	local function PromptMessage()
		--if #HideChild > 0 then
			--for i = 1,#HideChild do
				--hApi.safeRemoveT(_childUI,HideChild[i])
			--end
			--HideChild = {}
		--end

		for i = 1,6 do
			_childUI["PromptMessageNode"..i] = hUI.node:new({
				parent = sv.container,
				x = 30,
				y = PromptMessageNodeY - (i-1)*125,
			})
				
			HideChild[#HideChild+1] = _childUI["PromptMessageNode"..i]
			
			_childUI["PromptMessageNode"..i].childUI["PromptMessageDetailed"]= hUI.label:new({
				parent = _childUI["PromptMessageNode"..i].handle._n,
				size = 24,
				align = "LT",
				font = hVar.FONTC,
				x = 0,
				y = -2,
				text = hVar.tab_string["__TEXT_Sprog_Prompt"..i..i],
				width = 830,
			})

			_childUI["PromptMessageNode"..i].childUI["PromptMessageName"]= hUI.label:new({
				parent = _childUI["PromptMessageNode"..i].handle._n,
				size = 28,
				align = "LT",
				font = hVar.FONTC,
				x = 0,
				y = 0,
				text = hVar.tab_string["__TEXT_Sprog_Prompt"..i],
				RGB = {230,180,50},
			})

			PromptMessageRedEquipY =_childUI["PromptMessageNode"..i].childUI["PromptMessageDetailed"].handle.s:getContentSize()
			
			if PromptMessageRedEquipY.height == 48 then
				PromptMessageNodeY = PromptMessageNodeY + 24
			end

			if PromptMessageRedEquipY.height == 50 then
				PromptMessageNodeY = PromptMessageNodeY + 24
			end

			_childUI["PromptMessageNode"..i].childUI["PromptMessageRedEquip"]= hUI.label:new({
				parent = _childUI["PromptMessageNode"..i].handle._n,
				size = 24,
				align = "LT",
				font = hVar.FONTC,
				x = 0,
				y = -PromptMessageRedEquipY.height - 5,
				text = hVar.tab_string["__TEXT_RedEquip_Prompt"],
				width = 850,
				RGB = {255,0,0},
			})

			for j = 1,_RedEquipIcon[i] do
				_childUI["PromptMessageNode"..i].childUI["PromptMessageRedEquipIcon"..j] = hUI.image:new({
				parent = _childUI["PromptMessageNode"..i].handle._n,
				model = "UI:RedEquip",
				x = 175 + (j-1)*30,
				y = -PromptMessageRedEquipY.height - 14,
				scale = 0.9,
				})
			end
		end
	end

	--创建裁剪面
	local function CreateScrollFrm()
		local csv = {}
		local createScroll = {}
		createScroll.scrollview = {}
		csv.scrollview = CCScrollView:create()
		csv.container = CCLayer:create()
		csv.state = {}
		csv.state.adjust = 0
		if csv.scrollview == nil then
			return nil
		else
			csv.container:setAnchorPoint(ccp(0,0))
			csv.container:setPosition(ccp(0,0))

			csv.scrollview:setAnchorPoint(ccp(0,0))
			csv.scrollview:setPosition(ccp(0,0))

			csv.scrollview:setContainer(csv.container)
			
			local function onscript(tag)
				if "ccTouchEnded" == tag then
					createScroll.scrollview.adjustview(csv)
				end
			end
			local layer = csv.scrollview
			layer:registerScriptHandler(onscript)

			return csv
		end
	end
	local function ShowGuide()
		--if _OnlyRun == 1 then
			
			sv = CreateScrollFrm()
			--_OnlyRun = 0
		--end
		sv.state.adjust = 40
		
		sv.scrollview:setDirection(1)
		_frm.handle._n:addChild(sv.scrollview,1)
		sv.scrollview:setContentSize(CCSizeMake(880,10000))
		sv.scrollview:setViewSize(CCSizeMake(880,500))
		sv.scrollview:setPosition(ccp(0,-568))
		sv.scrollview:setContentOffset(ccp(0,-9500))
		sv.scrollview:setBounceable(false)
	end

	ShowGuide()
	PromptMessage()
	
	hGlobal.event:listen("LocalEvent_phone_OpenQuestionFrm","__Phone_OpenQuestionFrm",function()

		_index = 1

		if sv then
			sv.scrollview:setContentOffsetInDuration(ccp(0,(125*_index)-9625),0.3)
		end

		_frm:show(1)
		_frm:active()
	end)
end