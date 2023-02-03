--公告界面
hGlobal.UI.InitWebViewNews = function()
	local _y = hVar.SCREEN.h - 112
	local _h = hVar.SCREEN.h - 138
	local _w = 1024 - 40
	local _WebViewW = 500
	local _NetData = {}
	local _frm,_childUI,_parent = nil,nil,nil
	
	--针对4S 做特别处理
	if g_phone_mode == 1 then
		_WebViewW = _WebViewW  - 60
		_w = _w - 60
	end
	local _gridFrmX,_gridFrmY,_gridFrmW = _WebViewW + (_w - _WebViewW)/2,-70,_w - _WebViewW
	
	
	--系统礼物面板的固有UI
	local _WebView_FrmChildUI = {
		--分界线
		{__UI="image",__NAME="ApartLine1",x=_gridFrmX,y=_gridFrmY,model="UI:sBar",w=_gridFrmW, h = 2},
		--系统邮件标题
		{__UI="label",__NAME="ShopTittle",x=_gridFrmX - 10,y=-40,z=1,text=hVar.tab_string["system_mail"],font=hVar.FONTC,size=34,align="MC",RGB={255,205,55}},
		--webView 的分界线
		{__UI="image",__NAME="apartline_back",x=_WebViewW,y=-_h/2,model="UI:panel_part_09",w=_h,h=8},
		--公告
		{__UI="label",__NAME="NoticeTittle",x=_WebViewW/2 - 10,y=-40,z=1,text=hVar.tab_string["__TEXT_Notice"],font=hVar.FONTC,size=34,align="MC",RGB={255,205,55}},
		--webView 的分界线
		{__UI="image",__NAME="ApartLine2",x=_WebViewW/2 + 10,y=_gridFrmY,model="UI:sBar",w=_WebViewW, h = 2},
		
		{__UI="image",__NAME="tipNew_Ver",x=_WebViewW - 60,y=-40,model="MODEL_EFFECT:new_tip_eff",},
		
	}
	
	local _getDataByid = function(id)
		for i = 1,#_NetData do
			local v = _NetData[i]
			if v[1] == id then
				return v,i
			end
		end
		return nil
	end
	
	--更新函数
	local _gridPosY ,_gridH= -116,112
	local removeList = {}
	local _UpdateWebViewData = function(self,id,oGrid,pSprite,gx,gy)
		local nx,ny = pSprite:getPosition()
		local data = _NetData[id]
		
		if data then
			local index,prizetype,prizeid,prizecode = unpack(data)
			local itemID,itemNum,itemName,itemHole,coin,score,itemBack,itemModel,GiftTip,GiftTip_Ex,ex_num,_,_,giftType = hApi.UnpackPrizeData(prizetype,prizeid,prizecode)
			
			--邮件的背景
			hUI.deleteUIObject(hUI.image:new({
				parent = pSprite,
				--model = "ui/system_mail_bg1.png",
				model = "misc/card_select_back.png",				x = _gridFrmW/2,
				w = 472,
				h = 98,			}))
				
			if itemBack ~= 0 then
				hUI.deleteUIObject(hUI.image:new({
					parent = pSprite,
					model = itemBack,
					w = 66,
					h = 66,
					x = 62,
					y = 2,
				}))
			end
			
			local model_w,model_h = 58,58
			if itemID >= 9300 and itemID <= 9305 then
				model_w,model_h = 32,36
			end
			
			hUI.deleteUIObject(hUI.image:new({
				parent = pSprite,
				model = itemModel,
				w = model_w,
				h = model_h,
				x = 62,
				y = 2,
			}))
			
			
			
			local textX,textY = 100,30
			if itemID == -1 or (itemID == -2 and string.len(GiftTip) <= 36 ) then
				textX = 106
				textY = 10
			end
			
			if itemID == 9108 then
				textX,textY = 94,10
			end
			hUI.deleteUIObject(hUI.label:new({
				parent = pSprite,
				x = textX,
				y = textY,
				size = 24,
				font = hVar.FONTC,
				align = "LT",
				width = 300,
				border = 1,
				text = GiftTip,
			}))
			
			if (type(itemNum) == "number" and itemNum > 1) or type(itemNum) == "string" then
				hUI.deleteUIObject(hUI.label:new({
					parent = pSprite,
					x = 80,
					y = -8,
					size = 18,
					align = "RT",
					width = 300,
					border = 1,
					text = itemNum,
				}))
			end
			
			--邮件的领取按钮
			local btnText = hVar.tab_string["__Get__"]
			if itemID == -1 or itemID == -2 then
				btnText = hVar.tab_string["__Read__"]
			end
			
			--print("prizetype:",prizetype,ex_num)
			if (prizetype == 20008 or prizetype == 20009) and ex_num <= 0 then
				btnText = hVar.tab_string["__Read__"]
			end
			oGrid.childUI["btnConfirm"..gx.."|"..gy] = hUI.button:new({
				parent = oGrid.handle._n,
				dragbox = _childUI["dragBox"],
				model = "UI:button_tiny",
				x = nx + _gridFrmW - 58,
				y = ny,
				label = {
					text = btnText,
					size = 24,
					border = 1,
					font = hVar.FONTC,
					y = 2,
					x = 2,
				},
				code = function(self)
					self:setstate(0)
					if index <= (math.abs((_gridPosY-oGrid.data.y) / _gridH)) then return end
					if itemID == -1 then
						hGlobal.event:event("LocalEvent_WebViewNewVerFrm", GiftTip, GiftTip_Ex)
						return
					elseif itemID == -2 then
						SendCmdFunc["sysMailOpen"](nil,prizeid,prizetype)
						return
					end
					
					--检测版本号，是否为最新版本
					local local_srcVer = tostring(hVar.CURRENT_ITEM_VERSION) --1.0.070502
					local version_control = tostring(g_version_control) --1.0.070502-v018-018-app
					local vbpos = string.find(version_control, "-")
					if vbpos then
						version_control = string.sub(version_control, 1, vbpos - 1)
					end
					if (local_srcVer < version_control) then
						--弹系统框
						local msgTitle = hVar.tab_string["__TEXT_SystemNotice"]
						if (g_lua_src == 1) or (g_is_account_test == 1) or (g_is_account_test == 2) then --源代码模式、测试员、管理员，显示具体的版本号
							msgTitle = hVar.tab_string["__TEXT_SystemNotice"] .. " (" .. local_srcVer .. "|" .. version_control .. ")"
						end
						hApi.ShowSysMsgBox(msgTitle, hVar.tab_string["__TEXT_ScriptsTooOld"])
						
						--按钮状态恢复
						self:setstate(1)
						
						--关闭邮箱界面
						hGlobal.event:event("LocalEvent_ShowWebViewNews", 0)
						hGlobal.event:event("LocalEvent_NewWebAction", nil, 0)
						SendCmdFunc["get_prize_list"]()
						
						return
					end
					
					--一般的道具奖励
					if giftType == 0 then
						if type(itemID) == "number" and itemID > 0 and ( hVar.tab_item[itemID].type <= hVar.ITEM_TYPE.FOOT or itemID == 9100 ) then
							if LuaCheckPlayerBagCanUse() == 0 then
								local msgbox = hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_BAGLISTISFULL"],{
									font = hVar.FONTC,
									ok = function()
										
									end,
								})
								msgbox:setXY(540,msgbox.data.y)
								msgbox.childUI["dragBox"]:sortbutton()
								msgbox:active()
								self:setstate(1)
								return
							end
						end
					--VIP8充值奖励
					elseif giftType == 1 then
						print("heroCard")
						
					elseif giftType == 2 then
						print("BFS")
					--只会显示UI并不发送状态
					elseif giftType == 3 then
						print("new BFS")
					end
					
					if ((prizetype >= 20001) and (prizetype <= 200011)) or prizetype == 1036 then --排行榜、邮件奖励、推荐奖励、首冲388
						if LuaCheckPlayerBagCanUse() == 0 then
							local msgbox = hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_BAGLISTISFULL"],{
								font = hVar.FONTC,
								ok = function()
									
								end,
							})
							msgbox:setXY(540,msgbox.data.y)
							msgbox.childUI["dragBox"]:sortbutton()
							msgbox:active()
							self:setstate(1)
							return
						end
						SendCmdFunc["get_mail_annex"](prizeid,prizetype)
					else
						SendCmdFunc["set_prize_list"](prizeid,luaGetplayerDataID())
					end
				end,
			})
			
			oGrid.childUI["btnConfirm"..gx.."|"..gy].childUI["ConFirmImage"] = hUI.image:new({
				parent = oGrid.childUI["btnConfirm"..gx.."|"..gy].handle._n,
				model = "UI:ok",
				x = 6,
				y = 8,
				scale = 0.8,
			})
			oGrid.childUI["btnConfirm"..gx.."|"..gy].childUI["ConFirmImage"].handle._n:setVisible(false)
			
			removeList[#removeList+1] = {oGrid.childUI,"btnConfirm"..gx.."|"..gy,}
		end
	end

	--grid UI 声明
	local _WebView_PageUI = {
		["NetMsg"] = {
			cliprect = {_WebViewW,_gridFrmY-4,_gridFrmW,_h - 76,0},	-- 第五个参数填 1 可以呈现出绿色 clip 区域
			dragable = {0,0,0,0},
			autoalign = {"V","NetMsgGrid",0,0,0},	-- 下面会根据 sPageMode.."Grid" 创建一个 grid
			grid = {
				cols = 1,
				rows = 50,
				x = _WebViewW,
				y = _gridPosY,
				gridW = _gridFrmW,
				gridH = _gridH,
			},
			tag = {},
			img = {},
			btn = {},
			ui = {"NetMsgGrid",},
			update = function(self,id,oGrid,pSprite,gx,gy)
				return _UpdateWebViewData(self,id,oGrid,pSprite,gx,gy)
			end,
		},
	}
	
	local _DragableGrid = {}
	for k in pairs(_WebView_PageUI)do
		_DragableGrid[k.."Grid"] = 1
	end
	--拖拽方法
	local _DragFunc = function(self,tTempPos,tPickParam)
		if tPickParam.state==0 then
			if (tTempPos.x-tTempPos.tx)^2+(tTempPos.y-tTempPos.ty)^2>144 then
				if tPickParam.code and tPickParam.code~=0 then
					local pCode = tPickParam.code
					tPickParam.code = 0
					pCode(self,tTempPos,tPickParam)
				end
				if tPickParam.state==0 then
					tPickParam.state = 1
					tTempPos.tx = tTempPos.x
					tTempPos.ty = tTempPos.y
				else
					return 0
				end
			else
				return 0
			end
		elseif tPickParam.state==2 then
			if tPickParam.oImage then
				tPickParam.oImage.handle._n:setPosition(tTempPos.x,tTempPos.y)
			end
			return 0
		end
		if _DragableGrid[tPickParam.sGridName]~=1 then
			return 0
		end
	end
	
	--松开方法
	local _DropFunc = function(self,tTempPos,tPickParam)
		if _DragableGrid[tPickParam.sGridName]==1 then
			local tUIList = _WebView_PageUI[tPickParam.sPageMode]
			if tUIList and tUIList.autoalign then
				self:aligngrid(tUIList.autoalign,tUIList.dragable,tTempPos)
			end
		end
		
		local oGrid = _childUI["NetMsgGrid"]
		local tRect = _WebView_PageUI["NetMsg"].cliprect
		for i = 1,#oGrid.data.item do
			local oBtn = oGrid.childUI["btnConfirm0|"..(i-1)]
			if oBtn then
				oBtn.data.ox = oGrid.data.x
				oBtn.data.oy = oGrid.data.y
				_childUI["dragBox"]:setbutton(oBtn,oBtn.data.ox,oBtn.data.oy)
				if oBtn.data.model=="Action:button_gift" then
					if hApi.IsInBox(oBtn.data.x+oBtn.data.ox,oBtn.data.y+oBtn.data.oy,tRect) then
						oBtn.data.state = 1
					else
						oBtn.data.state = 0
					end
				end
			end
		end
	end
	
	--点击方法
	local _HitFunc = function(self,tTempPos,x,y)
		local oGrid = _childUI["NetMsgGrid"]
		local tUIList = _WebView_PageUI["NetMsg"]
		if hApi.IsInBox(x,y,tUIList.cliprect) then
			local tPickParam = {sGridName="NetMsgGrid",sPageMode="NetMsg",sPickMode="rank",nPickI=0,tCard=0,state=0,nDelay=0}
			local gx,gy,oItem = oGrid:xy2grid(x,y,"parent")
			if oItem and oItem~=0 then
				tPickParam.nPickI = oItem[hVar.ITEM_DATA_INDEX.ID]
			end
			return tPickParam
		end
	end
	
	hGlobal.UI.PhoneWebViewNews = hUI.frame:new({
		x = 20,
		y = _y,
		h = _h,
		w = _w,
		show = 0,
		dragable = 2,
		titlebar = 0,
		bgAlpha = 0,
		bgMode = "tile",
		background = "UI:tip_item",
		border = "UI:TileFrmBasic_thin",
		--border = 1,
		autoactive = 0,
		closebtn = {
			model = "BTN:PANEL_CLOSE",
			x = _w - 14,
			y = -14,
			scaleT = 0.95,
			code = function()
				hGlobal.event:event("LocalEvent_ShowWebViewNews", 0)
				hGlobal.event:event("LocalEvent_NewWebAction", nil, 0)
				SendCmdFunc["get_prize_list"]()
			end,
		},
		child = _WebView_FrmChildUI,
		codeOnTouch = function(self,x,y,sus,tTempPos)
			if (sus == 0) then
				return
				--return hGlobal.event:event("LocalEvent_ShowWebViewNews", 0)
			end
			
			if x > _WebViewW and x < _WebViewW + _gridFrmW 
			and y < -74 and y > -600 then
				local tPickParam = _HitFunc(self,tTempPos,x,y)
				if tPickParam~=nil then
					local tDragRect
					if _WebView_PageUI[tPickParam.sPageMode] then
						tDragRect = _WebView_PageUI[tPickParam.sPageMode].dragable
					end
					if tDragRect==nil then
						tDragRect = {0,0,0,0}
					end
					return self:pick(tPickParam.sGridName,tDragRect,tTempPos,{_DragFunc,_DropFunc,tPickParam})
				end
			end
			
		end,
	})
	
	_frm = hGlobal.UI.PhoneWebViewNews
	_childUI = _frm.childUI
	_parent = _frm.handle._n
	
	_childUI["apartline_back"].handle._n:setRotation(-90)
	_childUI["tipNew_Ver"].handle._n:setVisible(false)
	
	--根据参数创建具体的grid 过程 
	for sModeName,tUIList in pairs(_WebView_PageUI) do
		local pNode = _frm.handle._n
		if type(tUIList.cliprect)=="table" then
			local pClipNode, pClipMask, pClipMaskN = hApi.CreateClippingNode(_frm, tUIList.cliprect, 5, tUIList.cliprect[5])
			tUIList.clipnode = {pClipNode,pClipMask,pClipMaskN}
			pNode = pClipNode
		end
		if type(tUIList.grid)=="table" then
			local tCardGrid = {}
			for i = 1,tUIList.grid.rows do
				tCardGrid[i] = hApi.NumTable(tUIList.grid.cols)
			end
			local sPageMode = sModeName
			local pUpdateFunc = tUIList.update
			if type(pUpdateFunc)~="function" then
				pUpdateFunc = nil
			end
			local uiExtra = {"PlusUI"}
			if tUIList.grid.uiExtra then
				for i = 1,#tUIList.grid.uiExtra do
					uiExtra[#uiExtra+1] = tUIList.grid.uiExtra[i]
				end
			end
			
			_childUI[sPageMode.."Grid"] = hUI.bagGrid:new(hApi.ReadParam(tUIList.grid,nil,{
				parent = pNode,
				align = "MC",
				grid = tCardGrid,
				animation = -1,
				item = {},
				slot = 0,
				num = 0,
				uiExtra = uiExtra,
				codeOnImageCreate = function(oGrid,nCardIndex,pSprite,gx,gy)
					if pUpdateFunc then
						return pUpdateFunc(tUIList,nCardIndex,oGrid,pSprite,gx,gy)
					end
				end,
			}))
		end
	end
	
	--打开此面板
	hGlobal.event:listen("LocalEvent_ShowWebViewNews", "__Show_WebViewNews",function(isShow)
		_frm:show(isShow)
		if isShow == 1 then										--显示
			if type(xlShowWebView) == "function" and type(Lua_xlShowWebView) == "function" then
				Lua_xlShowWebView(1)
			end
			_frm:active()
			
			if g_cur_webnum ~= LuaGetWebViewN() then
				_childUI["tipNew_Ver"].handle._n:setVisible(true)
				LuaSetWebViewN(g_cur_webnum)
			else
				_childUI["tipNew_Ver"].handle._n:setVisible(false)
			end
			SendCmdFunc["get_prize_list"]()
			
			--触发事件，显示游戏币界面
			hGlobal.event:event("LocalEvent_ShowGameCoinFrm")
		else												--点击以外的区域，则自动消失
			if type(xlShowWebView) == "function" and type(Lua_xlShowWebView) == "function" then
				Lua_xlShowWebView(0)
			end
			hGlobal.event:event("LocalEvent_ShowMapAllUI",true)
			
			--不显示金币界面
			hGlobal.event:event("LocalEvent_CloseGameCoinFrm")
			
			_childUI["NetMsgGrid"]:updateitem({})
			for i = 1,#removeList do
				hApi.safeRemoveT(removeList[i][1],removeList[i][2]) 
			end
			removeList = {}
			hGlobal.event:event("LocalEvent_MainMenuSubFrmClose")
		end
	end)
	
	--设置√ 状态
	hGlobal.event:listen("LocalEvent_SetConFirmImage","__setImageState",function(Cprizeid)
		for i = 1,#_NetData do
			local index,prizetype,prizeid,prizecode = unpack(_NetData[i])
			if prizeid == Cprizeid then
				if type(removeList[index]) == "table" 
				and type(removeList[index][1]) == "table" 
				and type(removeList[index][2]) == "string" 
				and type(removeList[index][1][removeList[index][2]]) == "table" 
				and type(removeList[index][1][removeList[index][2]].childUI["ConFirmImage"]) == "table" then
					removeList[index][1][removeList[index][2]].childUI["ConFirmImage"].handle._n:setVisible(true)
				end
			end
		end
	end)
	
	hGlobal.event:listen("LocalEvent_SetSystemMailData", "__setData", function(proctol, uID, itag, dataTab)
		--print("LocalEvent_SetSystemMailData", proctol, uID, itag, dataTab, #dataTab)
		_NetData = {}
		local tipSwitch = 0
		for i = 1, #dataTab, 1 do
			local v = dataTab[i]
			--print(i, "prizetype=", v.prizetype, "prizeid=", v.prizeid, "prizecode=", v.prizecode)
			--当推送类型不只是2000 时，需要显示提示的开关
			--zhenkira系统邮件也显示公告
			--if v.prizetype ~= 2000 and v.prizetype ~= 4000 then
			if (v.prizetype ~= 2000) and (v.prizetype ~= 4000) then
				tipSwitch = 1
			end
			
			--geyachao: 如果是2000号邮件，那么检测是否已经读过了
			if (v.prizetype == 2000) then
				if (type(v.prizecode) == "string") then
					local lasttitle = LuaGetSystemMailTitle(g_curPlayerName) --上一次阅读的系统邮件标题
					local currenttitle = "" --本次系统邮件的标题
					local pivot = string.find(v.prizecode, ";")
					currenttitle = string.sub(v.prizecode, 1, pivot - 1)
					currenttitle = string.gsub(currenttitle, "\n", "") --过滤掉回车符
					--LuaSetSystemMailTitle(g_curPlayerName, currenttitle)
					--print("currenttitle=", currenttitle, "lasttitle=", lasttitle, lasttitle ~= currenttitle)
					
					 --未阅读过，才标记为需要提示
					if (lasttitle ~= currenttitle) then
						tipSwitch = 1
					end
				end
			end
			_NetData[i] = {i, v.prizetype, v.prizeid, v.prizecode}
		end
		
		if (#_NetData > 0) and (tipSwitch == 1) then
			hGlobal.event:event("LocalEvent_NewWebAction", nil, 1)
		else
			--hGlobal.event:event("LocalEvent_NewWebAction", nil, 0)
		end
		
		_childUI["NetMsgGrid"]:updateitem(_NetData)
		
		local tUIList = _WebView_PageUI["NetMsg"]
		local ggx,ggy = tUIList.grid.x,tUIList.grid.y
		local ggw,ggh = tUIList.cliprect[3],tUIList.cliprect[4]
		local ox,oy = 0,tUIList.autoalign[5]
		
		hUI.SetDragRectForGrid("V",tUIList.dragable,_childUI["NetMsgGrid"],ggx,ggy,ggw,ggh,ox,oy,_NetData)
		_childUI["dragBox"]:sortbutton()
		_frm:aligngrid(tUIList.autoalign,tUIList.dragable,0,1)
		
	end)
	
	--监听抽奖事件，关闭邮箱界面
	hGlobal.event:listen("localEvent_ShowReverseCardFrm", "closefrm", function()
		--print("监听抽奖事件，关闭邮箱界面", _frm.data.show)
		if (_frm.data.show == 1) then
			hGlobal.event:event("LocalEvent_ShowWebViewNews", 0)
			hGlobal.event:event("LocalEvent_NewWebAction", nil, 0)
			SendCmdFunc["get_prize_list"]()
		end
	end)
end

--系统公告脚本版
hGlobal.UI.InitWebViewNewVerFrm = function()
	local _y = hVar.SCREEN.h - 116
	local _h = hVar.SCREEN.h - 142
	local _WebViewW = 480
	local _w = 1024 - _WebViewW
	
	--针对4S 做特别处理
	if g_phone_mode == 1 then
		_w = _w - 60
	end
	
	local _removeList = {}
	local _childUI
	hGlobal.UI.WebViewNewVerFrm  = hUI.frame:new({
		x = _w-20,
		y = hVar.SCREEN.h/2 + _h/2 - 42,
		w = _WebViewW,
		h = _h,
		dragable = 2,
		show = 0,
		border = "UI:TileFrmBasic_thin",
		closebtn = "BTN:PANEL_CLOSE",
		closebtnX = _WebViewW - 14,
		closebtnY = -14,
		codeOnClose = function()
			for i = 1,#_removeList do
				hApi.safeRemoveT(_childUI,_removeList[i])
			end
			_removeList = {}
		end,
	})
	
	local _frm = hGlobal.UI.WebViewNewVerFrm 
	local _parent = _frm.handle._n
	_childUI = _frm.childUI

	--顶部分界线
	_childUI["apartline_back"] = hUI.image:new({
		parent = _parent,
		model = "UI:panel_part_09",
		x = _WebViewW/2,
		y = -70,
		w = _WebViewW,
		h = 8,
	})
	
	--title
	_childUI["title"] = hUI.label:new({
		parent = _parent,
		--font = hVar.FONTC,
		size = 32,
		text = hVar.tab_string["system_mail"],
		align = "MC",
		border = 1,
		x = _WebViewW/2,
		y = -40,
		font = hVar.FONTC,
	})
	
	--邮件内容
	_childUI["infoText"] = hUI.label:new({
		parent = _parent,
		--font = hVar.FONTC,
		size = 24,
		text = "",
		align = "LT",
		border = 1,
		x = 30,
		y = -76,
		width = _WebViewW - 40,
		font = hVar.FONTC,
	})
	
	--确定按钮
	_childUI["btnOK"] = hUI.button:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		label = hVar.tab_string["Exit_Ack"],
		font = hVar.FONTC,
		x = _WebViewW/2,
		y = 32 -_h,
		scaleT = 0.9,
		code = function(self)
			_frm:show(0)
			for i = 1,#_removeList do
				hApi.safeRemoveT(_childUI,_removeList[i])
			end
			_removeList = {}
		end,
	})
	
	--进度条 
	local _bar,_num = nil,nil
	local barLength = _WebViewW - 40 --拖动条长度
	_childUI["bar"] = hUI.valbar:new({
		parent = _parent,
		model = "UI:ValueBar",
		back = {model = "UI:ValueBar_Back",x=0,y=0,w=barLength,h=36},
		w = barLength,
		h = 36,
		x = _w/2 - barLength/2 - 30,
		y = -_h+140,
		align = "LT",
	})
	_bar = _childUI["bar"]
	
	_childUI["scrollBtn"] = hUI.image:new({
		parent = _parent,
		model = "UI:scrollBtn",
		x = _bar.data.x + 5,
		y = _bar.data.y - 11,
	})
	
	--拖拽条上显示的数字
	_childUI["labNum"] = hUI.label:new({
		parent = _frm.handle._n,
		font = "numWhite",
		size = 26,
		text = "--",
		align = "MC",
		x = _bar.data.x+barLength/2 - 10,
		y = _bar.data.y-20,
	})
	_num = _childUI["labNum"]
	
	--根据参数设置缩放条
	local _setScroll = function(curNum,maxNum)
		local dx = math.abs(barLength/maxNum)
		local tempx = math.ceil(curNum*dx)
		_bar:setV(tempx,barLength)
		_childUI["scrollBtn"].handle._n:setPosition(tempx+16,_bar.data.y - 11)
		_num:setText(curNum.."/"..maxNum)
		
		_bar.handle._n:setVisible(true)
		_num.handle._n:setVisible(true)
		_childUI["scrollBtn"].handle._n:setVisible(true)
	end
	_bar.handle._n:setVisible(false)
	_num.handle._n:setVisible(false)
	_childUI["scrollBtn"].handle._n:setVisible(false)
	
	--设置进度条的位置
	local _setVBarPos = function(x,y)
		_bar.data.x,_bar.data.y = (_w/2 - barLength/2 - 30 + (x or 0)),(-_h+140+ (y or 0))
		_bar.handle._n:setPosition((_w/2 - barLength/2 - 30 + (x or 0)),(-_h+140+ (y or 0)))
		
		_num.data.x,_num.data.y = _bar.data.x+barLength/2 - 10,_bar.data.y-20
		_num.handle._n:setPosition(_bar.data.x+barLength/2 - 10 ,_bar.data.y-20)
		
		_childUI["scrollBtn"].data.x,_childUI["scrollBtn"].data.y = _bar.data.x + 5,_bar.data.y - 11
		_childUI["scrollBtn"].handle._n:setPosition(_bar.data.x + 5,_bar.data.y - 11)
	end
	
	--根据传入的 字符串 设定档位
	local _setVBarGear = function(maxNum,gStr)
		for i = 1,#_removeList do
			hApi.safeRemoveT(_childUI,_removeList[i])
		end
		_removeList = {}
		
		if type(gStr) ~= "string" then return end
		local temp = {}
		for v in string.gfind(gStr,"([^%;]+);+") do
			v = tonumber(v)
			temp[#temp+1] = v
		end
		-- 1 总个数， 2-N 代表每个档位的位置
		local maxN = temp[1]
		if #temp > 0 then
			for i = 2,maxN+1 do
				
				local n = temp[i]
				local tempx = math.ceil(n*math.abs(barLength/maxNum))
				local imgW = 0
				local imgY = 0
				local labY = 0
				if i == 2 then
					labY = _bar.data.y - 60
					imgW = 20
					imgY = _bar.data.y - 46
				else	
					labY = _bar.data.y - 80
					imgW = 40
					imgY = _bar.data.y - 56
				end
				
				_childUI["apartline_back_"..(i-1)] = hUI.image:new({
						parent = _parent,
						model = "UI:panel_part_09",
						x = tempx+18,
						y = imgY,
						w = imgW,
						h = 8,
					})
				_childUI["apartline_back_"..(i-1)].handle._n:setRotation(-90)
				_removeList[#_removeList+1] = "apartline_back_"..(i-1)
				
				_childUI["Gear_labNum_"..(i-1)] = hUI.label:new({
					parent = _parent,
					font = "numWhite",
					size = 12,
					text = n,
					align = "MC",
					x = tempx+18,
					y = labY,
				})
				_removeList[#_removeList+1] = "Gear_labNum_"..(i-1)
			end
		end
	end
	
	--查看邮件的正文
	hGlobal.event:listen("LocalEvent_WebViewNewVerFrm", "showthisfrm", function(text1, text2, ex1Num, ex2Num, exY, exG)
		--print("LocalEvent_WebViewNewVerFrm", "text1=", text1, "text2=", text2, ex1Num, ex2Num, exY, exG)
		--geyachao: 标记最近一次阅读的邮件的标题
		text1 = string.gsub(text1, "\n", "") --过滤掉回车符
		LuaSetSystemMailTitle(g_curPlayerName, text1)
		
		_bar.handle._n:setVisible(false)
		_num.handle._n:setVisible(false)
		_childUI["scrollBtn"].handle._n:setVisible(false)
		
		_childUI["title"]:setText(text1)
		_childUI["infoText"]:setText(text2)
		
		_childUI["btnOK"]:setstate(1)
		if type(ex1Num) == "number" and type(ex2Num) == "number" then
			_setScroll(ex1Num,ex2Num)
			_childUI["btnOK"]:setstate(-1)
		end
		
		if type(exY) == "number" then
			_setVBarPos(0,exY)
			
		end
		
		_setVBarGear(ex2Num,exG)
		
		_frm:show(1)
		_frm:active()
	end)
end