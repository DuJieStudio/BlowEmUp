





--------------------------------------------
local __RCF__TempNetMSG = {} --在此界面未加载前，先缓存网络发过来的信息，等待加载后一并处理UI显示
do
	hGlobal.event:listen("recommend_me", "recommend_me_label" ,function(proctol,uid_me,uid,itag,iErrorCode)
		__RCF__TempNetMSG[#__RCF__TempNetMSG + 1] = {"recommend_me", proctol,uid_me,uid,itag,iErrorCode}
	end)
	hGlobal.event:listen("recommend_count", "recommend_count_label", function(proctol,uid_me,itag,uid,count)
		__RCF__TempNetMSG[#__RCF__TempNetMSG + 1] = {"recommend_count", proctol,uid_me,uid,itag,iErrorCode}
	end)
	--[[
	hGlobal.event:listen("LocalEvent_SetgiftFrmBtnState", "recommend_statelist_label", function(statelist)
		__RCF__TempNetMSG[#__RCF__TempNetMSG + 1] = {"recommend_statelist", statelist}
	end)
	]]
end
--------------------------------------------
hGlobal.UI.InitRecommendFrm = function(mode)
	local tInitEventName = {"LocalEvent_showRecommendFrm","__UI__showRecommendFrm"}
	if mode~="include" then
		return tInitEventName
	end
	local _CODE_OnRecvRecommendMe = hApi.DoNothing
	local _CODE_OnRecvRecommendCount = hApi.DoNothing
	
	--奖励表
	local REWARD_TABLE =
	{
		[1] =
		{
			num = 5,
			reward = {2, 1042, 2, 1,}, --战术技能卡 
			showPercent = 10,
		},
		
		[2] =
		{
			num = 10,
			reward = {3, 11006, 0, 0,}, --道具
			showPercent = 30,
		},
		
		[3] =
		{
			num = 20,
			reward = {2, 1042, 4, 1,}, --战术技能卡 
			showPercent = 50,
		},
		
		[4] =
		{
			num = 50,
			reward = {7, 300, 0, 0,}, --游戏币
			showPercent = 70,
		},
		
		[5] =
		{
			num = 100,
			reward = {3, 12405, 0, 0,}, --道具
			showPercent = 96,
		},
	}
	
	local _RCF_FrmXYWH = {hVar.SCREEN.w/2-880/2,hVar.SCREEN.h/2+240,880,524}
	hGlobal.UI.RecommendFrm = hUI.frame:new({
		x = _RCF_FrmXYWH[1],
		y = _RCF_FrmXYWH[2],
		dragable = 2,
		w = _RCF_FrmXYWH[3],
		h = _RCF_FrmXYWH[4],
		border = "UI:TileFrmBasic_thin",
		show = 0,
	})

	local _frm = hGlobal.UI.RecommendFrm
	local _parent = _frm.handle._n
	local _childUI = _frm.childUI
	local frmIndex = 1
	
	local changeMandP = nil
	
	--竖线
	_childUI["apartline_back_h"] = hUI.image:new({
		parent = _parent,
		model = "UI:panel_part_03",
		x = 446,
		y = -262,
		w = 16,
		h = 524,
	})
	
	--[[
	_childUI["apartline_back_w"] = hUI.image:new({
		parent = _parent,
		model = "UI:panel_part_09",
		x = 266,
		y = -60,
		w = 556,
		h = 8,
	})
	]]
	
	--进度条
	_childUI["bar"] = hUI.valbar:new({
		parent = _frm.handle._n,
		model = "UI:ValueBar",
		back = {model = "UI:ValueBar_Back",x=-17,y=11,w=405,h=52},
		x = 476,
		y = -238,
		w = 368,
		h = 20,
		align = "LT",
	})
	_childUI["bar"]:setV(0, 100)
	
	--local t = {1,5,10,20,50}
	--local index = 1
	local textField = nil
	local recomm = function()
		--通关【救援青州】才能推荐
		if (LuaGetPlayerMapAchi("world/td_006_jyqz", hVar.ACHIEVEMENT_TYPE.LEVEL) == 0) then
			return
		end
		
		local s = string.gsub(textField:getString(), "^%s*(.-)%s*$", "%1")
		local n = textField:getCharCount()
		--hUI.floatNumber:new({
			----unit = u,
			--text = "",
			--x = 240,
			--font = "numRed",
			--moveY = 64,
		--}):addtext(s..tostring(s == "").." "..n.."    "..textField:getPlaceHolder(),hVar.FONTC,36,"LC",-10,6):setColor(ccc3(255,255,255))
		local id = tonumber(s)
		if (id == nil) or (n <= 0) then
			_frm.childUI["error_1"]:setText(hVar.tab_string["ios_tip_input_recomm_uid"])
		else
			hUI.floatNumber:new({
				--unit = u,
				text = "",
				x = 240,
				font = "numRed",
				moveY = 64,
			}):addtext(id,hVar.FONTC,36,"LC",-10,6):setColor(ccc3(255,255,255))
			SendCmdFunc["recommend_me"](id)
		end
		--SendCmdFunc["recommend_me"](48247651)  --测试用
		
		
		--_childUI["bar"]:setV(t[index],50)
		--index = index + 1
		--if index > #t then
			--index = 1
		--end	
	end
	local sw = 1024
	local sh = 768
	if g_phone_mode == 0 then--0 ipad/1 ip4,4s/2 5,5s,6,6p/3 android
		sw = 700
		sh = 500
	end
	local r = 1
	
	-- add by red
	local share_url_ios_cn = "https://itunes.apple.com/cn/app/ce-ma-shou-tian-guan-ta-fang/id1104158404?mt=8" --策马守天关app下载地址
	if (hVar.SYS_IS_NEWTD_APP == 1) then --新塔防app程序
		share_url_ios_cn = "https://itunes.apple.com/app/id1262272804?mt=8" --魔塔前线app下载地址
	end
	
	local share_url_xinline = "http://app.xingames.com/download/sc.html"
	local system_lang = ""
	if xlSystemLanguage then
		system_lang = xlSystemLanguage()
		if system_lang == "zh-Hant" or system_lang == "zh-Hant-CN" or system_lang == "zh-TW" or system_lang == "zh-HK" then
			share_url_xinline = "http://app.xingames.com/download/tc.html"
		end
	end
	
	function xlUrlAppendUid()
		local append = "?xluid=0"
		if xlPlayer_GetUID then
			local uid = xlPlayer_GetUID()
			if uid ~= nil then
				append = string.format("?xluid=%s",tostring(uid))
			end
		end
		return append
	end
	
	function xlUrlAppendFrom(iType)
		local append = string.format("&xlfrom=%d",iType)
		return append
	end
	
	CCUserDefault:sharedUserDefault():setStringForKey("xl_share_url",share_url_xinline .. xlUrlAppendUid() .. xlUrlAppendFrom(1))
	CCUserDefault:sharedUserDefault():setStringForKey("xl_share_url_qzone",share_url_xinline .. xlUrlAppendUid() .. xlUrlAppendFrom(2))
	
	local _HRF_UIHandle = {}
	local _HRF_UIList = {
		{"button", "close", "BTN:PANEL_CLOSE", {870,-12,-1,-1,1,1},function() --关闭按钮
			hGlobal.event:event("LocalEvent_showRecommendFrm",0)
		end},
		--{"image","heroImg",hVar.tab_unit[5000].portrait,{140,-236,220,220}},
		{"imageX", "logo1", "ui/bimage_bbs.png",{130, -48, 42, 42},}, --logo1 
		{"labelX", "2ptemp", hVar.tab_string["__TEXT_share_p"], {230, -50, 30, 1,"MC",hVar.FONTC}}, --填写推荐人
		{"labelX", "hero_name", hVar.tab_string["enter_recomm_id"], {20, -100, 26, 1,"LT", hVar.FONTC, nil, 420}}, --请填写推荐人的8位数字账号
		{"labelX", "hero_intro1", hVar.tab_string["rec_m_new_daily_info1"], {20, -320, 26, 1, "LT", hVar.FONTC, nil, 420}}, --填写推荐人，您可获得20游戏币的奖励。对方也可以获得20游戏币的奖励。每个玩家只能填写推荐人一次。
		--{"button","2p",{"UI:ButtonBack2",{text = hVar.tab_string["__TEXT_share_p"],size = 30}},{136,-30,262,60,1,1},function() changeMandP(1) end},
		--{"button","2m",{"UI:ButtonBack2",{text = hVar.tab_string["__TEXT_share_m"],size = 30}},{396,-30,262,60,0.95,1},function() changeMandP(2) end},
		{"labelX", "error_1", "", {26, -220, 22,1,"LC", hVar.FONTC, {255, 0, 0}}}, --错误提示
		{"button","tfbg", "ui/tfback.png", {190, -170, 350, 50, 1, 1}, function() --输入框
			--通关【救援青州】才能推荐
			if (LuaGetPlayerMapAchi("world/td_006_jyqz", hVar.ACHIEVEMENT_TYPE.LEVEL) <= 0) then
				_frm.childUI["error_1"]:setText(hVar.tab_string["recomm_level_jyqz_tuijian"]) --通关【救援青州】才能推荐
			elseif (g_loginDays < 3) then --登入不满3天，不能推荐
				_frm.childUI["error_1"]:setText(hVar.tab_string["recomm_level_jyqz_dengru"]) --登入天数达到3天才能推荐
			else
				textField:attachWithIME()
				_frm.childUI["error_1"]:setText("")
			end
		end},
		{"button", "recomm", "UI:BTN_ok", {400, -172,-1,-1,0.9,1}, function() recomm() end}, --OK按钮
		{"imageX", "recomm_gamecoin", "UI:game_coins",{200, -280, 56, 56},}, --游戏币图标
		{"labelX", "recomm_gamecoin_num", "x20", {250, -290, 20,1,"MC", "numWhite", nil, 400,}}, --游戏币数量
		{"imageX", "recomm_gamecoin_gougou", "UI:finish", {210, -285, 48, 36},}, --游戏币图标勾勾
		
		{"imageX", "logo2", "ui/bimage_bbs.png", {580, -48, 42, 42},}, --logo2
		{"labelX", "hero_name_rec", hVar.tab_string["enter_recomm_id_rec"], {680, -50, 30, 1, "MC", hVar.FONTC, nil, 400,}}, --作为推荐人
		{"labelX", "hero_name_num", hVar.tab_string["enter_recomm_count"], {460, -100, 26, 1,"LT",hVar.FONTC,nil, 400}}, --推荐游戏给朋友，按累计人数可以获得多档奖励
		--{"labelX","hero_name_total", "您累计推荐：", {460, -150, 26,1,"LT", hVar.FONTC, nil, 400}}, --累积推荐给朋友，按人数可获得奖励 {230,180,50}
		
		{"labelX", "count", "0/100", {668, -250, 22, 1, "MC", "numWhite"}}, --0/50
		{"labelX", "gamecoin_intro", hVar.tab_string["recomm_info1"], {460, -410, 26, 1, "LT", hVar.FONTC, nil, 420}}, --除了上述的累计奖励，每次被其他玩家填写为推荐人，都可以获得20游戏币的奖励。
		
	}
	
	hUI.CreateMultiUIByParam(_frm, 0, 0, _HRF_UIList, _HRF_UIHandle, hUI.MultiUIParamByFrm(_frm))
	
	--输入框提示文字
	textField = CCTextFieldTTF:textFieldWithPlaceHolder(hVar.tab_string["enter_recomm_id_once"], "Arial", 22) --每位玩家只能输入推荐人ID一次
	textField:setPosition(185, -171)
	textField:setColorSpaceHolder(ccc3(88, 88, 88)) --灰色
	_frm.handle._n:addChild(textField, 50)
	--[[
	_frm.childUI["ok1"].handle.s:setVisible(false)
	_frm.childUI["ok2"].handle.s:setVisible(false)
	_frm.childUI["ok3"].handle.s:setVisible(false)
	for i = 1,5 do
		_frm.childUI["qq_count"..i].handle.s:setColor(ccc3(0,255,0))
		_frm.childUI["wx1_count"..i].handle.s:setColor(ccc3(0,255,0))
		
		_frm.childUI["qq_count"..i].handle.s:setVisible(false)
		_frm.childUI["wx1_count"..i].handle.s:setVisible(false)
	end
	--_frm.childUI["hero_name"]:setText("!")
	--]]
	
	--创建挡操作的面板（用于刷新菊花）
	_frm.childUI["CoverMask"] = hUI.button:new({
		parent = _frm.handle._n,
		model = "misc/mask_16.png",
		x = 220,
		y = -171,
		w = 440,
		h = 200,
		
		dragbox = _frm.childUI["dragBox"],
		code = function(self, screenX, screenY, isInside)
			--挡操作用，不处理事件
			--print("DDD")
		end,
	})
	_frm.childUI["CoverMask"].handle.s:setOpacity(0) --只用于控制，不显示
	
	--挡操作的面板子控件: 菊花
	_frm.childUI["CoverMask"].childUI["waiting"] = hUI.image:new({
		parent = _frm.childUI["CoverMask"].handle._n,
		model = "MODEL_EFFECT:waiting",
		x = -20,
		y = -58,
		w = 64,
		h = 64,
	})
	
	local offsetX = 80
	for i = 1, #REWARD_TABLE, 1 do
		--每档的数字
		_childUI["num" .. i] = hUI.label:new({
			parent = _frm.handle._n,
			x = 456 + 400 * REWARD_TABLE[i].showPercent / 100, --按比例显示
			y = -210,
			size = 18,
			font = "numWhite",
			align = "MC",
			width = 300,
			--border = 1,
			text = REWARD_TABLE[i].num,
		})
		_childUI["num" .. i].handle.s:setColor(ccc3(255, 255, 255))
		
		--箭头
		_childUI["jiantou" .. i] = hUI.image:new({
			parent = _frm.handle._n,
			x = 456 + 400 * REWARD_TABLE[i].showPercent / 100, --按比例显示
			--y = -373 + 60,
			y = -353 + 67,
			model = "UI:Tactic_RPointer", --"UI:playerBagD",
			w = 30, --32,
			h = 20, --48,
		})
		--_childUI["jiantou" .. i].handle.s:setRotation(180)
		_childUI["jiantou" .. i].handle.s:setRotation(270)
		
		--竖线i
		_childUI["shuxian" .. i] = hUI.image:new({
			parent = _frm.handle._n,
			x = 456 + 400 * REWARD_TABLE[i].showPercent / 100, --按比例显示
			--y = -373 + 60,
			y = -353 + 127,
			model = "UI:panel_part_03", --"UI:playerBagD",
			w = 20, --32,
			h = 8, --48,
		})
		
		--每一档的奖励
		local rewardT = REWARD_TABLE[i].reward
		local scaleModel = 1.2
		local tmpModel, itemName, itemNum, itemWidth, itemHeight, sub_tmpModel, sub_pos_x, sub_pos_y, sub_pos_w, sub_pos_h = hApi.GetRewardParams(rewardT)
		--print(tmpModel, itemName, itemNum, itemWidth, itemHeight, sub_tmpModel, sub_pos_x, sub_pos_y, sub_pos_w, sub_pos_h)
		
		--响应点击事件的控件（只作为响应事件，不显示）
		_childUI["button" .. i] = hUI.button:new({
			parent = _frm.handle._n,
			model = "misc/mask.png", --"UI:playerBagD"
			dragbox = _frm.childUI["dragBox"],
			x = 456 + 400 * REWARD_TABLE[i].showPercent / 100, --按比例显示
			y = -330,
			w = 78,
			h = 120,
			scaleT = 0.95,
			code = function(self, screenX, screenY, isInside)
				local rewardType = rewardT[1] or 0 --获取类型
				
				--(1:积分 / 2:战术技能卡 / 3:道具 / 4:英雄 / 5:英雄将魂 / 6:战术技能卡碎片 / 7:游戏币 / 8:网络宝箱 / 9:抽奖类战术技能卡 / 10:神器 / 11:神器晶石)
				if (rewardType == 1) then --1:积分
					--显示积分介绍的tip
					hApi.ShowJiFennTip()
				elseif (rewardType == 2) then --2:战术技能卡
					--显示战术技能卡tip
					local tacticId = rewardT[2] or 0
					local tacticNum = rewardT[3] or 0
					local tacticLv = rewardT[4] or 1
					hApi.ShowTacticCardTip(rewardType, tacticId, tacticLv)
				elseif (rewardType == 3) then --3:道具
					--显示道具tip
					local itemtipX = 400 + (hVar.SCREEN.w - 1024) / 2 --适配其他分辨率
					local itemtipY = 660 + (hVar.SCREEN.h - 768) / 2 --适配其他分辨率
					hGlobal.event:event("LocalEvent_ShowItemTipFram", {{rewardT[2], 1}}, nil, 1, itemtipX, itemtipY, 0)
				elseif (rewardType == 4) then --4:英雄
					--显示英雄tip
					local herotipX = 400 + (hVar.SCREEN.w - 1024) / 2 --适配其他分辨率
					local herotipY = 600 + (hVar.SCREEN.h - 768) / 2 --适配其他分辨率
					hGlobal.event:event("LocalEvent_HeroCardInfo", rewardT[2])
				elseif (rewardType == 5) then --5:英雄将魂
					--
				elseif (rewardType == 6) then --6:战术技能卡碎片
					--显示战术技能卡碎片tip
					local tacticId = rewardT[2] or 0
					local tacticNum = rewardT[3] or 0
					local tacticLv = rewardT[4] or 1
					hApi.ShowTacticCardTip(rewardType, tacticId, tacticLv)
				elseif (rewardType == 7) then --7:游戏币(服务器处理，客户端只拼日志)
					--显示游戏币介绍的tip
					hApi.ShowGameCoinTip()
				elseif (rewardType == 8) then --8:网络宝箱(服务器处理，客户端只拼日志)
					--显示道具tip
					local itemtipX = 400 + (hVar.SCREEN.w - 1024) / 2 --适配其他分辨率
					local itemtipY = 660 + (hVar.SCREEN.h - 768) / 2 --适配其他分辨率
					hGlobal.event:event("LocalEvent_ShowItemTipFram", {{rewardT[2], 1}}, nil, 1, itemtipX, itemtipY, 0)
				elseif (rewardType == 9) then --9:抽奖类战术技能卡
					--显示道具tip
					local itemtipX = 400 + (hVar.SCREEN.w - 1024) / 2 --适配其他分辨率
					local itemtipY = 660 + (hVar.SCREEN.h - 768) / 2 --适配其他分辨率
					hGlobal.event:event("LocalEvent_ShowItemTipFram", {{rewardT[2], 1}}, nil, 1, itemtipX, itemtipY, 0)
				elseif (rewardType == 10) then --10:红装神器
					--显示道具tip
					local itemtipX = 400 + (hVar.SCREEN.w - 1024) / 2 --适配其他分辨率
					local itemtipY = 660 + (hVar.SCREEN.h - 768) / 2 --适配其他分辨率
					hGlobal.event:event("LocalEvent_ShowItemTipFram", {{rewardT[2], 1}}, nil, 1, itemtipX, itemtipY, 0)
				elseif (rewardType == 11) then --11:神器晶石
					--显示神器晶石介绍的tip
					hApi.ShowRedEquipDeribsTip()
				end
			end,
		})
		_childUI["button" .. i].handle.s:setOpacity(0) --只用于控制，不显示
		
		--绘制奖励控件图标
		local WWW = itemWidth * scaleModel
		local HHH = itemHeight * scaleModel
		if (rewardT[1] == 7) then --游戏币图标小一点
			WWW = 56
			HHH = 56
		end
		--神器边框换个图
		if (rewardT[1] == 3) and (hVar.tab_item[rewardT[2]].isArtifact == 1) then
			tmpModel = "ICON:Back_red3"
			WWW = 52
			HHH = 52
		end
		_childUI["button" .. i].childUI["rewardIcon"] = hUI.image:new({
			parent = _childUI["button" .. i].handle._n,
			model = tmpModel,
			x = 0,
			y = 0,
			w = WWW,
			h = HHH,
		})
		
		--绘制奖励控件图标的子控件
		if sub_tmpModel then
			_childUI["button" .. i].childUI["subIcon"] = hUI.image:new({
				parent = _childUI["button" .. i].handle._n,
				model = sub_tmpModel,
				x = sub_pos_x * scaleModel,
				y = sub_pos_y * scaleModel,
				w = sub_pos_w * scaleModel,
				h = sub_pos_h * scaleModel,
			})
		end
		
		--绘制已获得的勾勾
		_childUI["button" .. i].childUI["OK"] = hUI.image:new({
			parent = _childUI["button" .. i].handle._n,
			model = "UI:finish",
			x = 12,
			y = -6,
			scale = 0.9,
		})
		_childUI["button" .. i].childUI["OK"].handle.s:setVisible(false) --默认隐藏勾勾
		
		--绘制奖励数量
		_childUI["button" .. i].childUI["rewardNum"] = hUI.label:new({
			parent = _childUI["button" .. i].handle._n,
			model = tmpModel,
			x = 0,
			y = -40,
			size = 18,
			font = "numWhite",
			align = "MC",
			width = 300,
			--border = 1,
			text = "x" .. itemNum,
		})
	end
	
	--[[
	changeMandP = function(index)
		textField:setString("")
		frmIndex = index
		if frmIndex == 1 then
			_frm.childUI["hero_name"].handle._n:setVisible(true)
			textField:setVisible(true)
			_frm.childUI["tfbg"]:setstate(1)
			_frm.childUI["recomm"]:setstate(1)
			_frm.childUI["error_1"].handle._n:setVisible(true)
			_frm.childUI["hero_name_rec"].handle._n:setVisible(true)
			_frm.childUI["hero_name_num"].handle._n:setVisible(true)
			--_frm.childUI["r5"]:setstate(1)
			--_frm.childUI["r10"]:setstate(1)
			--_frm.childUI["r20"]:setstate(1)
			--_frm.childUI["r50"]:setstate(1)
			--_frm.childUI["r5f"].handle._n:setVisible(true)
			--_frm.childUI["r10f"].handle._n:setVisible(true)
			--_frm.childUI["r20f"].handle._n:setVisible(true)
			--_frm.childUI["r50f"].handle._n:setVisible(true)
			--_frm.childUI["g1"].handle._n:setVisible(true)
			_frm.childUI["g5"].handle._n:setVisible(true)
			_frm.childUI["g10"].handle._n:setVisible(true)
			_frm.childUI["g20"].handle._n:setVisible(true)
			_frm.childUI["g50"].handle._n:setVisible(true)
			--_frm.childUI["c1bar"].handle._n:setVisible(true)
			_frm.childUI["c5bar"].handle._n:setVisible(true)
			_frm.childUI["c10bar"].handle._n:setVisible(true)
			_frm.childUI["c20bar"].handle._n:setVisible(true)
			_frm.childUI["c50bar"].handle._n:setVisible(true)
			--_frm.childUI["g1Info"].handle._n:setVisible(true)
			_frm.childUI["g5Info"].handle._n:setVisible(true)
			_frm.childUI["g10Info"].handle._n:setVisible(true)
			_frm.childUI["g20Info"].handle._n:setVisible(true)
			_frm.childUI["g50Info"].handle._n:setVisible(true)
			--_frm.childUI["info1"].handle._n:setVisible(true)
			--_frm.childUI["info2"].handle._n:setVisible(true)
			_frm.childUI["count"].handle._n:setVisible(true)
			_childUI["bar"].handle._n:setVisible(true)
			
		elseif frmIndex == 2 then
			_frm.childUI["hero_name"].handle._n:setVisible(false)
			textField:setVisible(false)
			_frm.childUI["tfbg"]:setstate(-1)
			_frm.childUI["recomm"]:setstate(-1)
			_frm.childUI["error_1"].handle._n:setVisible(false)
			_frm.childUI["hero_name_rec"].handle._n:setVisible(false)
			_frm.childUI["hero_name_num"].handle._n:setVisible(false)
			--_frm.childUI["r5"]:setstate(-1)
			--_frm.childUI["r10"]:setstate(-1)
			--_frm.childUI["r20"]:setstate(-1)
			--_frm.childUI["r50"]:setstate(-1)
			--_frm.childUI["r5f"].handle._n:setVisible(false)
			--_frm.childUI["r10f"].handle._n:setVisible(false)
			--_frm.childUI["r20f"].handle._n:setVisible(false)
			--_frm.childUI["r50f"].handle._n:setVisible(false)
			--_frm.childUI["g1"].handle._n:setVisible(false)
			_frm.childUI["g5"].handle._n:setVisible(false)
			_frm.childUI["g10"].handle._n:setVisible(false)
			_frm.childUI["g20"].handle._n:setVisible(false)
			_frm.childUI["g50"].handle._n:setVisible(false)
			--_frm.childUI["c1bar"].handle._n:setVisible(false)
			_frm.childUI["c5bar"].handle._n:setVisible(false)
			_frm.childUI["c10bar"].handle._n:setVisible(false)
			_frm.childUI["c20bar"].handle._n:setVisible(false)
			_frm.childUI["c50bar"].handle._n:setVisible(false)
			--_frm.childUI["g1Info"].handle._n:setVisible(false)
			_frm.childUI["g5Info"].handle._n:setVisible(false)
			_frm.childUI["g10Info"].handle._n:setVisible(false)
			_frm.childUI["g20Info"].handle._n:setVisible(false)
			_frm.childUI["g50Info"].handle._n:setVisible(false)
			--_frm.childUI["info1"].handle._n:setVisible(false)
			--_frm.childUI["info2"].handle._n:setVisible(false)
			_frm.childUI["count"].handle._n:setVisible(false)
			_childUI["bar"].handle._n:setVisible(false)
			
		end
	end
	]]
	
	--监听推荐面板打开/关闭事件，显示/隐藏 推荐界面
	hGlobal.event:listen(tInitEventName[1], tInitEventName[2], function(isShow)
		--显示/隐藏 推荐界面
		_frm:show(isShow)
		
		if (isShow == 1) then
			_frm:active()
			
			_frm.childUI["error_1"]:setText("") --清空文字提示
			textField:setString("")
			
			--先隐藏左侧的勾勾
			_frm.childUI["recomm_gamecoin_gougou"].handle.s:setVisible(false) --左边勾勾隐藏
			
			--打开菊花
			_frm.childUI["CoverMask"]:setstate(1)
			
			--changeMandP(1)
			--取本地推荐状态
			SendCmdFunc["recommend_state"]()
		end
	end)
	
	--我填了推荐人ID的回调
	_CODE_OnRecvRecommendMe = function(proctol,uid_me,uid,itag,iErrorCode)
		--print("_CODE_OnRecvRecommendMe", proctol,uid_me,uid,itag,iErrorCode)
		if (iErrorCode == 0) then
			_frm.childUI["error_1"]:setText(hVar.tab_string["__TEXT_WanJia"]..uid..hVar.tab_string["recomm_succ"])
			
			--再取本地推荐状态
			SendCmdFunc["recommend_state"]()
		elseif (iErrorCode == 3) then
			_frm.childUI["error_1"]:setText(hVar.tab_string["ios_err_client_uid_0"])
		elseif (iErrorCode == 4) then
			_frm.childUI["error_1"]:setText(hVar.tab_string["ios_err_recomm_by_invalid_id"])
		elseif (iErrorCode == 6) or (iErrorCode == 7) or (iErrorCode == 8) then
			_frm.childUI["error_1"]:setText(hVar.tab_string["ios_err_recomm_by_only_one"]..","..hVar.tab_string["ios_err_recomm_cannot_each_other"])
		elseif (iErrorCode == 10) then --登入未满3天，不能推荐
			_frm.childUI["error_1"]:setText(hVar.tab_string["ios_err_recomm_by_login_less_3_days"])
		end
	end
	
	--收到我推荐了多少人的回调
	_CODE_OnRecvRecommendCount = function(proctol,uid_me,itag,uid,count,dayRecom,wx,qq)
		--print("_CODE_OnRecvRecommendCount", proctol,uid_me,itag,uid, "count=" .. count,dayRecom,wx,qq)
		
		--测试 --test
		--count = 60
		
		--dayRecom = 1 wx = 5 qq = 5
		--print(proctol,uid_me,itag,uid,count,dayRecom,wx,qq,"!!!!!!!!!!!!!!!!!!!!!SSSS")
		if (uid > 0) then --存在填写了推荐uid
			_frm.childUI["tfbg"]:setstate(0) --不显示输入框
			textField:setString("")
			textField:setPlaceHolder(hVar.tab_string["__TEXT_WanJia"] .. uid .. hVar.tab_string["recomm_succ"])
			textField:setColorSpaceHolder(ccc3(234, 234, 234)) --淡白色
			_frm.childUI["recomm"]:setstate(0) --OK按钮
			_frm.childUI["recomm_gamecoin_gougou"].handle.s:setVisible(true) --左边勾勾显示
		else --没填写uid
			if (frmIndex == 1) then
				_frm.childUI["tfbg"]:setstate(1) --显示输入框
				textField:setString("")
				textField:setPlaceHolder(hVar.tab_string["enter_recomm_id_once"])
				textField:setColorSpaceHolder(ccc3(88, 88, 88)) --灰色
				_frm.childUI["recomm"]:setstate(1) --OK按钮
				_frm.childUI["recomm_gamecoin_gougou"].handle.s:setVisible(false) --左边勾勾隐藏
			end
		end
		
		--设置进度的文字
		_frm.childUI["count"]:setText(count .. "/" .. 100)
		
		--设置进度条和每个档的道具获得的勾勾
		--geyachao: 非等比例的进度条
		if (count <= 0) then
			_childUI["bar"]:setV(0, 100)
			
			--隐藏全部勾勾
			for i = 1, #REWARD_TABLE, 1 do
				_childUI["button" .. i].childUI["OK"].handle.s:setVisible(false) --隐藏勾勾
			end
		elseif (count >= 100) then
			_childUI["bar"]:setV(100, 100)
			
			--显示全部勾勾
			for i = 1, #REWARD_TABLE, 1 do
				_childUI["button" .. i].childUI["OK"].handle.s:setVisible(true) --显示勾勾
			end
		else
			local pivot = 0
			for i = 1, #REWARD_TABLE, 1 do
				local num = REWARD_TABLE[i].num
				if (count >= num) then
					pivot = i
				end
			end
			
			if (pivot == 0) then
				local num = REWARD_TABLE[1].num
				local showPercent = REWARD_TABLE[1].showPercent --显示的百分比
				local percent = count * showPercent / num
				--print("i=".. pivot, "num=" .. num, "showPercent=" .. showPercent, "percent=" .. percent)
				_childUI["bar"]:setV(percent, 100)
			else
				local num = REWARD_TABLE[pivot].num
				local showPercent = REWARD_TABLE[pivot].showPercent --显示的百分比
				local nextshowPercent = REWARD_TABLE[pivot + 1].showPercent --下一个显示的百分比
				local nextNum = REWARD_TABLE[pivot + 1].num --下一个的百分比
				
				local percent = showPercent + (count - num) * (nextshowPercent - showPercent) / (nextNum - num)
				--print("i=".. pivot, "num=" .. num, "showPercent=" .. showPercent, "percent=" .. percent)
				_childUI["bar"]:setV(percent, 100)
			end
			
			--设置勾勾
			for i = 1, pivot, 1 do
				_childUI["button" .. i].childUI["OK"].handle.s:setVisible(true) --显示勾勾
			end
			for i = pivot + 1, #REWARD_TABLE, 1 do
				_childUI["button" .. i].childUI["OK"].handle.s:setVisible(false) --隐藏勾勾
			end
		end
		
		--隐藏菊花
		_frm.childUI["CoverMask"]:setstate(-1)
		
		--[[
		
		for i = 1,wx do
			_frm.childUI["wx1_count"..i].handle.s:setVisible(true)
			--_frm.childUI["wx2_count"..i].handle.s:setVisible(true)
		end
		
		for i = 1,qq do
			_frm.childUI["qq_count"..i].handle.s:setVisible(true)
		end
		
		if dayRecom > 0 then
			--_frm.childUI["daily_coin"].handle.s:setColor(ccc3(255,255,255))
			_frm.childUI["ok3"].handle.s:setVisible(true)
		else
			--_frm.childUI["daily_coin"].handle.s:setColor(ccc3(125,125,125))
			_frm.childUI["ok3"].handle.s:setVisible(false)
		end
		
		if qq >= 5 then
			--_frm.childUI["daily_coin_1"].handle.s:setColor(ccc3(255,255,255))
			_frm.childUI["ok1"].handle.s:setVisible(true)
		else
			--_frm.childUI["daily_coin_1"].handle.s:setColor(ccc3(125,125,125))
			_frm.childUI["ok1"].handle.s:setVisible(false)
		end
		
		
		if wx >= 5 then
			--_frm.childUI["daily_coin_2"].handle.s:setColor(ccc3(255,255,255))
			_frm.childUI["ok2"].handle.s:setVisible(true)
		else
			--_frm.childUI["daily_coin_2"].handle.s:setColor(ccc3(125,125,125))
			_frm.childUI["ok2"].handle.s:setVisible(false)
		end
		--local program = hApi.getShader("gray")
		----local center = program:glGetUniformLocation("center")
		----local resolution = program:glGetUniformLocation("resolution")
		----local cx,cy = sprite:getParent():getPosition()
		----local size = sprite:getContentSize()
		----local rx,ry = size.width,size.height
		----program:setUniformLocationWithFloats(center,cx,cy)
		----program:setUniformLocationWithFloats(resolution,rx,ry)
		--local r = program:glGetUniformLocation("r")
		--program:setUniformLocationWithFloats(r,0.8)
		--local g = program:glGetUniformLocation("g")
		--program:setUniformLocationWithFloats(g,0.9)
		--local b = program:glGetUniformLocation("b")
		--program:setUniformLocationWithFloats(b,0.0)
		--_frm.childUI["recomm"].handle.s:setShaderProgram(program)
		--]]
	end
	
	hGlobal.event:listen("recommend_me", "recommend_me_label", _CODE_OnRecvRecommendMe)
	
	hGlobal.event:listen("recommend_count", "recommend_count_label", _CODE_OnRecvRecommendCount)
	
	--处理一下之前缓存的信息
	for i = 1,#__RCF__TempNetMSG do
		local sMsg,proctol,uid_me,uid,itag,iErrorCode = unpack(__RCF__TempNetMSG[i])
		if (sMsg == "recommend_me") then
			_CODE_OnRecvRecommendMe(proctol,uid_me,uid,itag,iErrorCode)
		elseif (sMsg == "recommend_count") then
			_CODE_OnRecvRecommendCount(proctol,uid_me,uid,itag,iErrorCode)
		--elseif (sMsg == "recommend_statelist") then
			--_CODE_OnRecvRecommendCount(proctol)
		end
	end
end


--[[
--test
if hGlobal.UI.RecommendFrm then --删除上一个的
	hGlobal.UI.RecommendFrm:del()
	hGlobal.UI.RecommendFrm = nil
end
hGlobal.UI.InitRecommendFrm("include")
hGlobal.event:event("LocalEvent_showRecommendFrm", 1)
]]

