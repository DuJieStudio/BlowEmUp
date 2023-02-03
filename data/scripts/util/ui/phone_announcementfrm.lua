hGlobal.UI.InitAnnouncementFrm = function(mode)
	local tInitEventName = {"LocalEvent_showAnnouncementFrm","showFrm"}
	if mode~="include" then
		return tInitEventName
	end

	local _frm,_parent,_childUI = nil,nil,nil
	local _nBoardW,_nBoardH,_sBoardBg,_s9Sprite = nil,nil,nil,nil
	local _nBoardX,_nBoardY = nil,nil
	local _nLabW = nil
	local _tUIConfig = {}
	local _tClipNode = {}
	local _nLefttime = 0
	--默认参数
	local _nDefaultBoardW = 700
	local _nDefaultBoardH = 600
	local _sDefaultBoardBg = "UI:zhezhao"
	local _sDefault9Sprite = "data/image/misc/chest/itemtip.png"

	local _CODE_ClearFunc = hApi.DoNothing
	local _CODE_CreateFrm = hApi.DoNothing
	local _CODE_GetConfig = hApi.DoNothing
	local _CODE_CreateInfo = hApi.DoNothing
	local _CODE_CreateDragLine = hApi.DoNothing

	local _CODE_HitPage = hApi.DoNothing
	local _CODE_DragPage = hApi.DoNothing
	local _CODE_DropPage = hApi.DoNothing
	local _CODE_CreateDragArea = hApi.DoNothing
	local _CODE_CreateImage = hApi.DoNothing
	local _CODE_CreateButton = hApi.DoNothing
	local _CODE_CreateLabel = hApi.DoNothing
	local _CODE_GetModelPath = hApi.DoNothing

	_CODE_ClearFunc = function()
		if hGlobal.UI.AnnouncementFrm then
			hGlobal.UI.AnnouncementFrm:del()
			hGlobal.UI.AnnouncementFrm = nil
		end
		_frm,_parent,_childUI = nil,nil,nil
		_nBoardW,_nBoardH,_sBoardBg = nil,nil,nil
		_nBoardX,_nBoardY = nil,nil
		_nLabW = nil
		_nLefttime = 0
		_tClipNode = {}
		g_DisableShowNetAlreadyFrm = 0
		hApi.clearTimer("activeAnnouncementFrm")
	end

	_CODE_GetConfig = function(tInfo)
		_nBoardW = _nDefaultBoardW
		_nBoardH = _nDefaultBoardH
		_sBoardBg = _sDefaultBoardBg
		_s9Sprite = _sDefault9Sprite
		_tUIConfig = {}
		if type(tInfo) == "table" then
			if tInfo.boardw then
				_nBoardW = tInfo.boardw
			end
			if tInfo.boardh then
				_nBoardH = tInfo.boardh
			end
			if tInfo.boardbg then
				_sBoardBg = tInfo.boardbg
			end
			if tInfo.border9Sprite then
				_s9Sprite =  tInfo.border9Sprite
			end
			if tInfo.labw then
				_nLabW =  tInfo.labw
			end
			if tInfo.label then
				_tUIConfig.label = tInfo.label
			end
			if tInfo.image then
				_tUIConfig.image = tInfo.image
			end
			if tInfo.button then
				_tUIConfig.button = tInfo.button
			end
			if tInfo.timecount then
				_tUIConfig.timecount = tInfo.timecount
			end
			if tInfo.dragarea then
				_tUIConfig.dragarea = tInfo.dragarea
			end
			_nLefttime = tonumber(tInfo.lefttime or 0)
		end
		print(_nBoardW,_nBoardH)

		_nBoardX,_nBoardY = hVar.SCREEN.w / 2 - _nBoardW / 2,hVar.SCREEN.h / 2 + _nBoardH / 2
	end

	local sec2str = function(text,time_sec,alignDigits)
		print("sec2str",text,time_sec,alignDigits)
		local str = text
		local nDay,nHour,nMin,nSec = hApi.Seconds2DHMS(time_sec,alignDigits)
		if alignDigits then
			local sformat = "%0"..alignDigits.."d"
			--print(sformat)
			nDay = string.format(sformat,nDay)
			nHour = string.format(sformat,nHour)
			nMin = string.format(sformat,nMin)
			nSec = string.format(sformat,nSec)
		end
		str = string.gsub(str,"#Day",tostring(nDay))
		str = string.gsub(str,"#Hour",tostring(nHour))
		str = string.gsub(str,"#Min",tostring(nMin))
		str = string.gsub(str,"#Sec",tostring(nSec))
		return str
	end

	_CODE_GetModelPath = function(tModelInfo,ntype)
		local imgPath = "misc/mask.png"
		if ntype == 1 then
			imgPath = "data/image/misc/mask.png"
		end
		if type(tModelInfo) == "table" then
			local pathtype,path = unpack(tModelInfo)
			if pathtype == "wpath" then
				imgPath = "data/image/misc/"..path
			elseif pathtype == "imgpath" then
				imgPath = "misc/"..path
			elseif pathtype == "custom" then
				imgPath = path
			end
		end
		return imgPath
	end

	_CODE_CreateDragArea = function(i,dragarea)
		local x = dragarea.x
		local y = dragarea.y
		local w = dragarea.w
		local h = dragarea.h
		local tClippingRect = {x, y, w, h, 0}
		_tClipNode[i] = {}
		_tClipNode[i].rect = tClippingRect
		local clipNode = hApi.CreateClippingNode(_frm, tClippingRect, dragarea.z, tClippingRect[5], "_Announcement_pClipNode"..i)
	
		_childUI["node"..i] = hUI.node:new({
			parent = clipNode,
			x = x,
			y = y,
		})
		_tClipNode[i].node = _childUI["node"..i]
		_tClipNode[i].nodename = "node"..i
	end

	_CODE_CreateImage = function(Parent,Child,imgname,imageParam)
		--table_print(imageParam)
		if imageParam.createmode == "scale9" then
			Child[imgname] = hUI.button:new({
				parent = Parent,
				model = "misc/button_null.png",
				--model = "misc/mask.png",
				x = imageParam.x,
				y = imageParam.y,
				w = imageParam.w,
				h = imageParam.h,
				scale = imageParam.scale,
				z = imageParam.z,
			})
			local s9 = hApi.CCScale9SpriteCreate(_CODE_GetModelPath(imageParam.model,1), 0, 0, imageParam.w, imageParam.h, Child[imgname])
			if imageParam.alpha then
				s9:setOpacity(imageParam.alpha)
			end
		else
			Child[imgname] = hUI.image:new({
				parent = Parent,
				model = _CODE_GetModelPath(imageParam.model),
				x = imageParam.x,
				y = imageParam.y,
				w = imageParam.w,
				h = imageParam.h,
				scale = imageParam.scale,
				z = imageParam.z,
			})
			if imageParam.alpha then
				Child[imgname].handle.s:setOpacity(imageParam.alpha)
			end
		end
	end

	_CODE_CreateLabel = function(Parent,Child,labname,labelParam,txt,offH,RGB)
		local nwidth = -1
		if labelParam.width then
			nwidth = labelParam.width
		elseif _nLabW then
			nwidth = _nLabW
		else
			nwidth = nil
		end
		--print("nwidth",nwidth)
		Child[labname] = hUI.label:new({
			parent = Parent,
			text = txt,
			align = labelParam.align,
			size = labelParam.size,
			font = labelParam.font or hVar.FONTC,
			x = labelParam.x,
			y = labelParam.y + offH,
			width = nwidth,
			height = labelParam.height,
			border = labelParam.border,
			z = labelParam.z,
			RGB = RGB or labelParam.RGB,
		})
	end

	_CODE_CreateButton = function(Parent,Child,btnname,buttonParam)
		local labinfo = {}
		if type(buttonParam.label) == "table" then
			local txt,size = unpack(buttonParam.label)
			labinfo = {text = hVar.tab_string[txt],size = size,font = hVar.FONTC,y = 2,}
		else
			labinfo = nil
		end
		local IsTester = CCUserDefault:sharedUserDefault():getIntegerForKey("xl_account_test")
		if IsTester > 0 and labinfo then
			local eventParam = buttonParam.codeEvent
			if type(eventParam == "table") then
				local sEvent = eventParam[1]
				if sEvent == "close" then
					labinfo.text = "测试通道"
				end
			end
		end
		Child[btnname] = hUI.button:new({
			parent = Parent,
			dragbox = _childUI["dragBox"],
			model = _CODE_GetModelPath(buttonParam.model),
			label = labinfo,
			x = buttonParam.x,
			y = buttonParam.y,
			w = buttonParam.w,
			h = buttonParam.h,
			z = buttonParam.z,
			scaleT = buttonParam.scaleT,
			code = function()
				local eventParam = buttonParam.codeEvent
				if type(eventParam == "table") then
					local sEvent = eventParam[1]
					if sEvent == "confirm" then
						hGlobal.event:event("LocalEvent_closeAnnouncementFrm")
					elseif sEvent == "openurl" then
						local url = eventParam[2]
						hGlobal.event:event("LocalEvent_AnnouncementOpenUrl",url)
					elseif sEvent == "close" then
						local IsTester = CCUserDefault:sharedUserDefault():getIntegerForKey("xl_account_test")
						if (IsTester == 1) or (IsTester == 2) then
							hGlobal.event:event("LocalEvent_closeAnnouncementFrm")
						else
							xlExit()
						end
					elseif sEvent == "custom" then
						--GM预留
						local IsTester = CCUserDefault:sharedUserDefault():getIntegerForKey("xl_account_test")
						if IsTester == 2 then
							hGlobal.event:event(eventParam[2],eventParam[3],eventParam[4],eventParam[5])
						end
					end
				end
			end,
			
		})
	end

	_CODE_CreateInfo = function()
		if type(_tUIConfig.dragarea) == "table" then
			for i = 1,#_tUIConfig.dragarea do
				local dragarea = _tUIConfig.dragarea[i]
				_CODE_CreateDragArea(i,dragarea)
				if type(dragarea.backbg) == "table" then
					dragarea.backbg.x = dragarea.x + dragarea.w/2
					dragarea.backbg.y = dragarea.y - dragarea.h/2
					dragarea.backbg.w = dragarea.w
					dragarea.backbg.h = dragarea.h + 10
					local imgname = "backbg"
					_CODE_CreateImage(_parent,_childUI,imgname,dragarea.backbg)
				end
			end
		end

		if type(_tUIConfig.image) == "table" then
			for i = 1,#_tUIConfig.image do
				local imageParam = _tUIConfig.image[i]
				local clip = imageParam.clip
				local Child =_childUI
				local Parent = _parent
				local inClip = 0
				if clip and _tClipNode[clip] then
					local node = _tClipNode[clip].node
					Parent = node.handle._n
					Child = node.childUI
					inClip = clip
				end
				local imgname = "image_"..i
				_CODE_CreateImage(Parent,Child,imgname,imageParam)
				if inClip > 0 then
					local clip = _tClipNode[inClip]
					local h = Child[imgname].data.h
					local totalH = -imageParam.y + h
					clip.totalH = math.max((clip.totalH or 0),totalH)
				end
			end
		end

		if type(_tUIConfig.label) == "table" then
			for i = 1,#_tUIConfig.label do
				local labelParam = _tUIConfig.label[i]
				local clip = labelParam.clip
				local parent = _parent
				local Child =_childUI
				local Parent = _parent
				local inClip = 0
				if clip and _tClipNode[clip] then
					local node = _tClipNode[clip].node
					Parent = node.handle._n
					Child = node.childUI
					inClip = clip
				end
				local Text = labelParam.text
				if type(Text) == "string" then
					local labname = "lab_"..i
					_CODE_CreateLabel(Parent,Child,labname,labelParam,labelParam.text,0)
					
					if inClip > 0 then
						local clip = _tClipNode[inClip]
						local _,h = Child[labname]:getWH()
						local totalH = -labelParam.y + h
						clip.totalH = math.max((clip.totalH or 0),totalH)
					end
				elseif type(Text) == "table" then
					local totalH = 0
					for j = 1,#Text do
						local labname = "lab_"..i.."_"..j
						local txt = Text[j][1]
						local RGB = Text[j][2]
						_CODE_CreateLabel(Parent,Child,labname,labelParam,txt,-totalH,RGB)
						local _,h = Child[labname]:getWH()
						totalH = totalH + h
					end
					if inClip > 0 then
						local clip = _tClipNode[inClip]
						clip.totalH = math.max((clip.totalH or 0),-labelParam.y + totalH)
					end
				end
				
			end
		end

		if type(_tUIConfig.button) == "table" then
			--
			for i = 1,#_tUIConfig.button do
				local buttonParam = _tUIConfig.button[i]
				local btnname = "btn_"..i
				_CODE_CreateButton(_parent,_childUI,btnname,buttonParam)
			end
		end
		if type(_tUIConfig.timecount) == "table" then
			local timeCountParam = _tUIConfig.timecount
			local alignDigits = timeCountParam.alignDigits
			local text = sec2str(timeCountParam.text or "",_nLefttime,alignDigits)
			_childUI["lab_timecount"] = hUI.label:new({
				parent = _parent,
				text = text,
				align = timeCountParam.align,
				size = timeCountParam.size,
				font = timeCountParam.font,
				x = timeCountParam.x,
				y = timeCountParam.y,
				z = timeCountParam.z,
				RGB = timeCountParam.RGB,
			})
			local nTimeLeft = _nLefttime
			local nSystemTime = hApi.gametime()
			print(nTimeLeft,nSystemTime)
			local ChangeTime = function()
				if nTimeLeft >= 0 then
					local nPassSeconds = math.floor((hApi.gametime()-nSystemTime)/1000)
					nTimeLeft = _nLefttime - nPassSeconds

					local text = sec2str(timeCountParam.text,nTimeLeft,alignDigits)
					--显示时间
					_childUI["lab_timecount"]:setText(text)
					
					--倒计时结束
					if 0 == nTimeLeft then
						local eventParam = timeCountParam.codeEvent
						if type(eventParam == "table") then
							local sEvent = eventParam[1]
							hGlobal.event:event(sEvent,eventParam[2],eventParam[3],eventParam[4])
						end
					end
				end
			end
			_childUI["lab_timecount"].handle.s:stopAllActions()
			_childUI["lab_timecount"].handle.s:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCDelayTime:create(1), CCCallFunc:create(ChangeTime))))

		end

		for index,info in pairs(_tClipNode) do
			if type(info) == "table" then
				local rect = info.rect
				local gh = math.max(0,(info.totalH or 0) - rect[4])
				info.dragrect = {rect[1],rect[2]+gh,0,math.max(0,gh)}
				if gh > 0 then
					_CODE_CreateDragLine(index,info)
				end
			end
		end
	end

	_CODE_CreateDragLine = function(index,info)
		local rect = info.rect
		local totalh = info.totalH
		
		--print(oscale,rect[4],750)
		_childUI["line_bar"..index] = hUI.image:new({
			parent = _parent,
			x = rect[1] + rect[3] + 5,
			y = rect[2] - rect[4] /2,
			--model = "misc/chest/xp_progress_bg.png",
			model = "misc/valuebar_back.png",
			h = 14,
			w = rect[4],
		})   
		_childUI["line_bar"..index].handle.s:setRotation(90)
		_childUI["line_bar"..index].handle.s:setOpacity(220)

		local scale = 0.87
		local reallength = rect[4]
		local length = reallength/totalh*reallength
		_childUI["line_buoy"..index] = hUI.image:new({
			parent = _parent,
			x = rect[1] + rect[3] + 5,
			y = rect[2] - length * scale /2 - rect[4] * (1-scale)/2 - 2,
			model = "misc/mask_white.png",
			w = 2,
			h = length * scale,
		})
		_childUI["line_buoy"..index].handle.s:setOpacity(180)
	end

	_CODE_CreateFrm = function()
		--创建公告面板
		hGlobal.UI.AnnouncementFrm = hUI.frame:new(
		{
			x = _nBoardX,
			y = _nBoardY,
			w = _nBoardW,
			h = _nBoardH,
			dragable = 2,
			show = 0, --一开始不显示
			border = 0, --显示frame边框
			background = _sBoardBg,
			--background = "UI:herocardfrm",
			autoactive = 0,
			z = hZorder.Announcement,
			codeOnTouch = function(self,relTouchX,relTouchY,IsInside)
				local tPickParam = _CODE_HitPage(self, tTempPos, relTouchX, relTouchY)
				if tPickParam~=nil then
					--table_print(tPickParam)
					return self:pick(tPickParam.sGridName, tPickParam.dragrect, tTempPos, {_CODE_DragPage,_CODE_DropPage,tPickParam})
				end
			end,
		})
		
		_frm = hGlobal.UI.AnnouncementFrm
		_parent = _frm.handle._n
		_childUI = _frm.childUI

		if type(_s9Sprite) == "string" then 
			local img9 = hApi.CCScale9SpriteCreate(_s9Sprite, _nBoardW/2, -_nBoardH/2 , _nBoardW, _nBoardH, _frm)
		end

		_CODE_CreateInfo()

		_frm:show(1)
		_frm:active()

		hApi.addTimerForever("activeAnnouncementFrm",hVar.TIMER_MODE.GAMETIME,100,function()
			if _frm then
				_frm:active()
			end
		end)
	end

	_CODE_HitPage = function(self,tTempPos,x,y)
		for i = 1,#_tClipNode do
			local rect = _tClipNode[i].rect
			local nodename = _tClipNode[i].nodename
			local dragrect = _tClipNode[i].dragrect
			if hApi.IsInBox(x, y, rect) then
				local tPickParam = {sGridName = nodename,dragrect = dragrect, nPickI=i,state=0, nDelay=0, code=0}
				return tPickParam
			end
		end
	end
	--拖拽
	_CODE_DragPage = function(self,tTempPos,tPickParam)
		if 0 == tPickParam.state then
			if (tTempPos.x-tTempPos.tx)^2+(tTempPos.y-tTempPos.ty)^2>144 then	--触摸移动点如果大于12个像素，即作为滑动处理
				if tPickParam.code and tPickParam.code~=0 then			--如果存在拖拉函数，则处理拖拉函数
					local pCode = tPickParam.code
					tPickParam.code = 0
					pCode(self,tTempPos,tPickParam)
				end
				if tPickParam.state==0 then
					tPickParam.state = 1					--设置状态：进入拖拉状态
					tTempPos.tx = tTempPos.x
					tTempPos.ty = tTempPos.y
				else
					return 0
				end
			else
				return 0
			end
		elseif 1 == tPickParam.state then
			local index = tPickParam.nPickI
			if _childUI["line_buoy"..index] then
				local tnode = _tClipNode[index]
				local rect = tnode.rect
				local nodename = _tClipNode[index].nodename
				local y = _childUI[nodename].data.y - rect[2]
				local totalh = tnode.totalH

				local scale = 0.87
				local moveh = totalh - rect[4]
				local reallength = rect[4]
				local length = reallength/totalh*reallength
				local oy = y / moveh * (reallength - length) * scale
				--print(moveh,y,totalh,reallength,oy)
				local oldy = rect[2] - length * scale /2 - rect[4] * (1-scale)/2 - 2
				_childUI["line_buoy"..index]:setXY(rect[1] + rect[3] + 5,oldy - oy)--  - offh/2*oscale* scale - (1 - scale) * rect[4]/2 - oy
			end
		end
	end
	--抬起
	_CODE_DropPage = function(self,tTempPos,tPickParam)
		if 1 == tPickParam.state then
			
		end
	end

	hGlobal.event:listen("LocalEvent_closeAnnouncementFrm","AnnouncementFrm",function()
		_CODE_ClearFunc()
		g_AnnouncementTest = nil
		hGlobal.event:event("LocalEvent_HaveShowAnnouncementFrm")
	end)

	hGlobal.event:listen("LocalEvent_AnnouncementOpenUrl","AnnouncementFrm",function(url)
		xlOpenUrl(url)
	end)

	hGlobal.event:listen("LocalEvent_SpinScreen","AnnouncementFrm",function()
		if g_AnnouncementTest == 1 and _frm and _frm.data.show == 1 then
			_CODE_ClearFunc()
			g_AnnouncementTest = nil
		end
	end)

	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(tInfo)
		_CODE_ClearFunc()
		--关闭掉线框
		hGlobal.event:event("LocalEvent_showAndroidNetAlreadyFrm",0)
		g_DisableShowNetAlreadyFrm = 1
		--table_print(tInfo)
		_CODE_GetConfig(tInfo)
		_CODE_CreateFrm()
	end)
end