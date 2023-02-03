
--------------------------------
-- 错误弹出面板
--------------------------------
hGlobal.UI.InitErroFram = function(mode)
	local tInitEventName = {"LocalEvent_ErroFram", "show_errofram"}
	if (mode ~= "include") then
		return tInitEventName
	end
	
	local _boardW,_boardH = 600,520
	local _fram,_parent,_childUI = nil,nil,nil
	local _text = ""

	local _CODE_ClearFunc = hApi.DoNothing
	local _CODE_CreateFrm = hApi.DoNothing
	
	_CODE_ClearFunc = function()
		if hGlobal.UI.ErroFram then
			hGlobal.UI.ErroFram:del()
			hGlobal.UI.ErroFram = nil
		end
		_fram,_parent,_childUI = nil,nil,nil
	end
	
	_CODE_CreateFrm = function()
		hGlobal.UI.ErroFram = hUI.frame:new({
			x = hVar.SCREEN.w / 2 - _boardW/2,
			y = hVar.SCREEN.h / 2 + _boardH/2,
			dragable = 4,
			w = _boardW,
			h = _boardH,
			show = 0,
			background = 0,
			z = 999999,
		})
		
		_fram = hGlobal.UI.ErroFram
		_parent = _fram.handle._n
		_childUI = _fram.childUI
		
		local s9 = hApi.CCScale9SpriteCreate("data/image/misc/chariotconfig/boardbg.png", _boardW/2, -_boardH/2, _boardW, _boardH, _fram)
		
		--错误标题
		_childUI["erroInfoEx"] = hUI.label:new({
			parent = _parent,
			x = 20,
			y = -30,
			text = hVar.tab_string["__TEXT_SorryForErro"],
			font = hVar.FONTC,
			size = 26,
			align = "LT",
			width = 550,
			RGB = {255, 64, 0},
		})
		
		--账号信息
		local uId = xlPlayer_GetUID() --我的uid
		local rId = luaGetplayerDataID() --我使用角色rid
		--安卓，存档名都是online，这里读取showname
		local myName = g_curPlayerName
		if Save_playerList and Save_playerList[1] then
			myName = Save_playerList[1].showName
		end
		local rgName = hApi.StringEncodeEmoji(myName) --我的玩家名 --处理表情
		_childUI["erroInfoUID"] = hUI.label:new({
			parent = _parent,
			x = 20,
			y = -90,
			text = hVar.tab_string["__TEXT_ShiftData0"] .. "ID: " .. uId,
			font = hVar.FONTC,
			size = 22,
			align = "LT",
			width = 550,
			RGB = {255, 255, 0},
		})
		
		--玩家名
		_childUI["erroInfoName"] = hUI.label:new({
			parent = _parent,
			x = 20 + 310,
			y = -90,
			text = hVar.tab_string["__TEXT_PlayerName"] .. ": " .. rgName, --"玩家名"
			font = hVar.FONTC,
			size = 22,
			align = "LT",
			width = 550,
			RGB = {255, 255, 0},
		})
		
		--错误信息
		_childUI["erroInfo"] = hUI.label:new({
			parent = _parent,
			x = 20,
			y = -130,
			font = hVar.FONTC,
			text = "",
			size = 22,
			align = "LT",
			width = _boardW - 40,
			RGB = {224, 224, 224},
		})
		
		--退出按钮
		_childUI["btnOk"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/button_back.png",
			label = {text = hVar.tab_string["__TEXT_ExitGame"], x = 0, y = 1, border = 1, font = hVar.FONTC, size = 28, align = "MC",}, --"退出游戏"
			font = hVar.FONTC,
			border = 1,
			align = "MC",
			w = 160,
			h = 56,
			scaleT = 0.95,
			x = _fram.data.w/2 - 10,
			y = -_fram.data.h + 54,
			
			code = function(self)
				xlExit()
			end,
		})
	end
	
	local _showFrmCallBack = function()
		_fram:active()
	end

	hGlobal.event:listen("LocalEvent_SpinScreen","ErroFram",function()
		if _fram and _fram.data.show == 1 then
			local text = _text
			--删除重绘
			if hGlobal.UI.ErroFram then
				hGlobal.UI.ErroFram:del()
				hGlobal.UI.ErroFram = nil
			end
			hGlobal.UI.InitErroFram("include")
			hGlobal.event:event("LocalEvent_ErroFram", text)
		end
	end)
	
	--这个按钮只有在没有加载游戏的时候生效
	hGlobal.event:listen("LocalEvent_ErroFram","show_errofram",function(text)
		_CODE_ClearFunc()
		_CODE_CreateFrm()
		_text = text
		_childUI["erroInfo"]:setText(text)
		_fram:show(1)
		_fram.handle._n:runAction(CCSequence:createWithTwoActions(CCJumpTo:create(0.1,ccp(_fram.data.x,_fram.data.y),5,1),CCCallFunc:create(_showFrmCallBack)))
		
		if xlAppAnalysis and xlPlayer_GetUID and xlUpdateGetInfo then
			local errorInfo = string.sub(text,32,512)
			local clientID = xlPlayer_GetUID()
			local vision = hVar.CURRENT_ITEM_VERSION
			
			if hGlobal.WORLD.LastWorldMap~=nil then
				local mapname = hGlobal.WORLD.LastWorldMap.data.map
				local dayStr = tostring(hGlobal.WORLD.LastWorldMap.data.roundcount)
				local analysisStrStart = string.find(mapname,"level")
				local analysisStr
				if analysisStrStart then
					analysisStr = string.sub(mapname,analysisStrStart)
					analysisStr = string.sub(analysisStr,7)
				else
					analysisStr = mapname
				end
				local errStr = tostring(clientID).."-"..analysisStr.."-"..dayStr.."-"..tostring(vision).."-"..errorInfo
				xlAppAnalysis("error",0,1,"info",string.sub(errStr,0,100))
			else
				local errStr = tostring(clientID).."-"..tostring(vision).."-"..errorInfo
				xlAppAnalysis("error",0,1,"info",string.sub(errStr,0,100))
			end
		end
		
		--上传服务器错误日志
		local strInfo = debug.traceback()
		
		--替换特殊符号
		local separateType = "\'"
		while true do
			local pos = string.find(strInfo, separateType)
			--print(pos)
			if pos and (pos > 0) then
				--找到分隔符
				strInfo = string.sub(strInfo, 1, pos - 1) .. "‘" .. string.sub(strInfo, pos + 1, -1)
			else
				--找不到分隔符了
				break
			end
		end
		
		--替换特殊符号
		local separateType = ";"
		while true do
			local pos = string.find(strInfo, separateType)
			--print(pos)
			if pos and (pos > 0) then
				--找到分隔符
				strInfo = string.sub(strInfo, 1, pos - 1) .. "；" .. string.sub(strInfo, pos + 1, -1)
			else
				--找不到分隔符了
				break
			end
		end
		
		--替换特殊符号
		local separateType = "%("
		while true do
			local pos = string.find(strInfo, separateType)
			if pos and (pos > 0) then
				--找到分隔符
				strInfo = string.sub(strInfo, 1, pos - 1) .. "（" .. string.sub(strInfo, pos + 1, -1)
			else
				--找不到分隔符了
				break
			end
		end
		
		--替换特殊符号
		local separateType = "%)"
		while true do
			local pos = string.find(strInfo, separateType)
			--print(pos)
			if pos and (pos > 0) then
				--找到分隔符
				strInfo = string.sub(strInfo, 1, pos - 1) .. "）" .. string.sub(strInfo, pos + 1, -1)
			else
				--找不到分隔符了
				break
			end
		end
		
		SendCmdFunc["send_errer_log"](strInfo)
	end)
end
--[[
--测试 --test
if hGlobal.UI.ErroFram then
	hGlobal.UI.ErroFram:del()
	hGlobal.UI.ErroFram = nil
end
hGlobal.UI.InitErroFram("include")
hGlobal.event:event("LocalEvent_ErroFram", debug.traceback())
]]

