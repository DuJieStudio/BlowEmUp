-------------------------------
--网络对战战中玩家信息查看面板
-------------------------------

hGlobal.UI.InitNetBattlefieldPlayerInfoFrm = function(mode)
	local tInitEventName = {"LocalEvent_ShowNetBattlefieldPlayerInfoFrm","__show_NetBattlefieldPlayerInfoFrm"}
	if mode~="include" then
		return tInitEventName
	end
	local _w,_h = 670,420
	local _x,_y = hVar.SCREEN.w/2 - _w/2,hVar.SCREEN.h/2 + _h/2

	local _frm = nil
	local _parent = nil
	local _childUI = nil

	local _removeList = {}
	local _exitFunc = function()
		for i = 1,#_removeList do
			hApi.safeRemoveT(_childUI,_removeList[i]) 
		end
		_removeList = {}
	end

	hGlobal.UI.NetBattlefieldPlayerInfoFrm  = hUI.frame:new({
		x = _x,
		y = _y,
		dragable = 3,
		show = 0,
		w = _w,
		h = _h,
		border = "UI:TileFrmBasic_thin",
		closebtn = {
			x = _w - 16,
			y = -20,
			w = 62,
			h = 56,
			model = "BTN:PANEL_CLOSE",
			code = function()
				_frm:show(0)
				_exitFunc()
			end,
		},
	})

	_frm = hGlobal.UI.NetBattlefieldPlayerInfoFrm
	_parent = _frm.handle._n
	_childUI = _frm.childUI

	--玩家头像槽 + 经验槽底图
	_childUI["HeroSlot"] = hUI.image:new({
		parent = _parent,
		model = "UI:zjexp",
		x = 160,
		y = -76,
	})
	
	--玩家经验条
	local _bar,_num = nil,nil
	local barLength = 174
	_childUI["expbar"] = hUI.valbar:new({
		parent = _parent,
		model = "UI:pvpbxjnan",
		back = {model = "UI:ValueBar_Back",x=0,y=0,w=barLength,h=14},
		w = barLength,
		h = 14,
		x = 122,
		y = -96,
		align = "LT",
	})
	_bar = _childUI["expbar"]
	_bar:setV(barLength,barLength)
	
	--经验条上的文字
	_childUI["expbar_num"] = hUI.label:new({
		parent = _parent,
		font = "numWhite",
		size = 16,
		text = barLength.."/"..barLength,
		align = "MC",
		x = _bar.data.x+_bar.data.w/2,
		y = _bar.data.y-_bar.data.h/2 - 1,
	})
	_num = _childUI["expbar_num"]

	--经验等级
	_childUI["PVPExperience"]= hUI.label:new({
		parent = _parent,
		x = 120,
		y = -70,
		text = hVar.tab_string["PVPFightGrade"],
		font = hVar.FONTC,
		size = 22,
		width = 400,
		border = 1,
	})
	
	--战斗等级
	_childUI["PVPFightGrade"]= hUI.label:new({
		parent = _parent,
		x = _w - 180,
		y = -30,
		text = hVar.tab_string["PVP_CUR_Title"],
		font = hVar.FONTC,
		size = 24,
		border = 1,
	})

	--战斗等级的背景图片
	_childUI["cjkk"] = hUI.image:new({
		parent = _parent,
		model = "UI:cjkk",
		x = _w - 150,
		y = -86,

	})

	--分界线
	_childUI["apartline_back"] = hUI.image:new({
		parent = _parent,
		model = "UI:panel_part_09",
		x = _w/2,
		y = -150,
		w = _w,
		h = 8,
	})
	
	--数据概况背景图
	_childUI["cjbt"] = hUI.image:new({
		parent = _parent,
		model = "UI:cjbt",
		x = 206,
		y = -180,
	})
	

	--数据概况
	_childUI["PVPDataSta"]= hUI.label:new({
		parent = _parent,
		x = 158,
		y = -170,
		text = hVar.tab_string["PVPDataSta"],
		font = hVar.FONTC,
		size = 24,
		border = 1,
	})
	
	local _tempStrList = {"__TEXT_RankNum","PVPWin","PVPVictory"}
	--三面旗子 分别是 战斗力，胜利，胜率
	for i = 1,3 do
		_childUI["banner_"..i] = hUI.image:new({
			parent = _parent,
			model = "UI:banner",
			x = 80 + (i-1) * 130,
			y = -280,
		})

		_childUI["playerInfoLab_"..i]= hUI.label:new({
			parent = _parent,
			x = 80 + (i-1) * 130,
			y = -240,
			align = "MC",
			text = hVar.tab_string[_tempStrList[i]],
			font = hVar.FONTC,
			size = 22,
			border = 1,
		})

		_childUI["playerInfoLabNum_"..i]= hUI.label:new({
			parent = _parent,
			x = 80 + (i-1) * 130,
			y = -280,
			align = "MC",
			text = 99999,
			width = 400,
			font = hVar.FONTC,
			size = 22,
			border = 1,
			RGB = {218,218,154},
		})
	end

	--总盘数的底图
	_childUI["pvp_result_bg"] = hUI.image:new({
		parent = _parent,
		model = "UI:selectbg",
		x = 214,
		y = -_h + 30,
		w = 470,
		h = 30,
		z = -1,
	})

	--总盘数 lab
	_childUI["pvp_sun"]= hUI.label:new({
		parent = _parent,
		x = 32,
		y = -380,
		text = hVar.tab_string["PVP_SUN"].." : 9999",
		font = hVar.FONTC,
		size = 22,
		width = 400,
		border = 1,
	})
	
	-- 胜
	_childUI["pvp_win"]= hUI.label:new({
		parent = _parent,
		x = 172,
		y = -380,
		text = hVar.tab_string["PVPWin"].." : 9999",
		font = hVar.FONTC,
		size = 22,
		width = 400,
		border = 1,
	})
	
	-- 败
	_childUI["pvp_fail"]= hUI.label:new({
		parent = _parent,
		x = 292,
		y = -380,
		text = hVar.tab_string["__TEXT_Fail"].." : 9999",
		font = hVar.FONTC,
		size = 22,
		width = 400,
		border = 1,
	})
	
	--逃
	--_childUI["escape"]= hUI.label:new({
		--parent = _parent,
		--x = 330,
		--y = -380,
		--text = hVar.tab_string["PVPFlee"].." : 9999",
		--font = hVar.FONTC,
		--size = 22,
		--width = 400,
		--border = 1,
	--})
	
	--出场率底板 zjdb
	_childUI["zjdb"] = hUI.image:new({
		parent = _parent,
		model = "UI:zjdb",
		x = 540,
		y = -300,
	})

	--角色ID 查看
	_childUI["role_id_lab"]= hUI.label:new({
		parent = _parent,
		x = 120,
		y = -44,
		text = "",
		size = 28,
		width = 600,
		align = "LC",
		border = 1,
		font = hVar.FONTC,
		RGB = {0,255,0},
	})

	local _maxHeroProbabilityN = 5
	for i = 1,_maxHeroProbabilityN do
		_childUI["zjdb_item_"..i] = hUI.image:new({
			parent = _parent,
			model = "UI:cjbt",
			x = 539,
			y = -220 - (i-1) * 42,
			w = 200,
			h = 28,
		})
		
		--出场次数的hero Name
		_childUI["zjdb_item_name_lab"..i]= hUI.label:new({
			parent = _parent,
			x = 450,
			y = -218 - (i-1) * 42,
			text = "",
			align = "LC",
			font = hVar.FONTC,
			size = 22,
			width = 400,
			border = 1,
		})

		--出场次数的 hero count
		_childUI["zjdb_item_count_"..i]= hUI.label:new({
			parent = _parent,
			x = 580,
			y = -218 - (i-1) * 42,
			text = "",
			align = "LC",
			font = hVar.FONTC,
			size = 22,
			width = 400,
			border = 1,
		})
	end

	_childUI["pvpenterBg"] = hUI.image:new({
		parent = _parent,
		model = "UI:cjbt",
		x = 542,
		y = -176,
	})
	
	--出场次数lab
	_childUI["PVPEnterNum"]= hUI.label:new({
		parent = _parent,
		x = 496,
		y = -166,
		text = hVar.tab_string["PVPEnterNum"],
		font = hVar.FONTC,
		size = 22,
		border = 1,
	})

	--绘制战斗力的小板子
	local _DrawPowerImage = function(Power)
		--战斗力
		local lv = hApi.GetLvByPower(Power)
		
		_childUI["Power_bg"] = hUI.image:new({
			parent = _parent,
			model = hVar.PVPRankUI[lv][1],
			x = 450,
			y = -84,
		})
		_removeList[#_removeList+1] = "Power_bg"

		_childUI["Power_num"] = hUI.image:new({
			parent = _parent,
			model = hVar.PVPRankUI[lv][2],
			x = 450,
			y = -82,
		})
		_removeList[#_removeList+1] = "Power_num"

		_childUI["Power_lab"] = hUI.image:new({
			parent = _parent,
			model = hVar.PVPRankUI[lv][3],
			x = 556,
			y = -82,
		})
		_removeList[#_removeList+1] = "Power_lab"
	end
	
	--解析英雄出场率字符串
	local _LoadDetailsFromStr = function(str)
		local tempStr = {}
		for str in string.gfind(str,"([^%;]+);+") do
			tempStr[#tempStr+1] = str
		end
		
		local tab = {}
		for i = 1,#tempStr do
			local heroid = tonumber(string.sub(tempStr[i],1,string.find(tempStr[i],":")-1))
			local entercount = tonumber(string.sub(tempStr[i],string.find(tempStr[i],":")+1,string.len(tempStr[i])))
			tab[i] = {heroid,entercount}
		end
		
		table.sort(tab, function(a, b)
			 return a[2] > b[2]
		end)
		return tab
	end

	--绘制英雄出场率 信息
	
	local _DrawHeroEnterProbability = function(heroList,PVP_SUM)
		for i = 1,_maxHeroProbabilityN do
			local sus = 0
			if type(heroList[i])=="table" then
				local id,count = unpack(heroList[i])
				if hVar.tab_unit[id] and count > 0 then
					sus = 1
					_childUI["zjdb_item_name_lab"..i]:setText(hVar.tab_stringU[id][1])
					--local text = math.floor(count/PVP_SUM * 100)
					_childUI["zjdb_item_count_"..i]:setText(count)
				end
			end
			if sus==0 then
				_childUI["zjdb_item_name_lab"..i]:setText("")
				_childUI["zjdb_item_count_"..i]:setText("")
			end
		end
	end
	
	--排行 1 2 3 的 玩家的名次 用特殊显示
	for i = 1,3 do
		_childUI["rank_n_"..i] = hUI.image:new({
			parent = _parent,
			model = "UI:rank_n_"..i,
			x = 80,
			y = -280,
			scale = 0.9,
		})
		_childUI["rank_n_"..i].handle._n:setVisible(false)
	end
	local _createPlayerInfo = function(playerInfo)
		_exitFunc()
		local heroID = playerInfo.heroID or 0 
		--英雄头像
		local icon = "ui/revivehero.png"
		if hVar.tab_unit[heroID] then
			icon = hVar.tab_unit[heroID].icon
		end
		_childUI["heroIcon"] = hUI.image:new({
			parent = _parent,
			model = icon,
			x = 66,
			y = -72,
			w = 78,
			h = 78,
		})
		_removeList[#_removeList+1] = "heroIcon"
		
		--总盘数
		local sun = (playerInfo.pvp_win or 0) + (playerInfo.pvp_fail or 0) + (playerInfo.pvp_giveup or 0)
		_childUI["pvp_sun"]:setText(hVar.tab_string["PVP_SUN"].." : "..tostring(sun))
		--胜
		_childUI["pvp_win"]:setText(hVar.tab_string["PVPWin"].." : "..(playerInfo.pvp_win or 0))
		--败
		_childUI["pvp_fail"]:setText(hVar.tab_string["__TEXT_Fail"].." : "..(playerInfo.pvp_fail or 0))
		--逃
		--_childUI["escape"]:setText(hVar.tab_string["PVPFlee"].." : "..(playerInfo.pvp_giveup or 0))
		--经验
		local expLv = hApi.PVPGetLevelByExp((playerInfo.pvp_exp or 0))
		local lv = hApi.GetLvByPower(playerInfo.power)
		_childUI["PVPExperience"]:setText(hVar.tab_string["PVPFightGrade"].." :   "..lv)
		local cur_p,max_p = playerInfo.power,hVar.PowerLvList[lv][2]
		if cur_p > hVar.PowerLvList[15][1] then
			cur_p = 0
			max_p = hVar.PowerLvList[15][1]
		end
		
		_bar:setV(cur_p,max_p)
		_num:setText(cur_p.." / "..max_p)
		
		for i = 1,3 do
			_childUI["rank_n_"..i].handle._n:setVisible(false)
		end
		--战斗力
		if playerInfo.pvp_rank > 3 then
			_childUI["playerInfoLabNum_1"]:setText(playerInfo.pvp_rank)
		elseif playerInfo.pvp_rank > 0 and playerInfo.pvp_rank <= 3 then
			_childUI["playerInfoLabNum_1"]:setText("")
			_childUI["rank_n_"..playerInfo.pvp_rank].handle._n:setVisible(true)
		else
			_childUI["playerInfoLabNum_1"]:setText(playerInfo.pvp_rank)
		end
		--绘制战斗力图片
		_DrawPowerImage(playerInfo.power)

		--胜利
		_childUI["playerInfoLabNum_2"]:setText(playerInfo.pvp_win)
		--胜率
		local probability = 0
		
		if sun > 0 then
			probability = math.floor(playerInfo.pvp_win/sun*100)
		end
		_childUI["playerInfoLabNum_3"]:setText(probability.."%")

		--英雄出场率信息
		local tempHeroEnterList = _LoadDetailsFromStr(playerInfo.unit_hot)
		_DrawHeroEnterProbability(tempHeroEnterList,sun)
		
		--设置玩家名字
		_childUI["role_id_lab"]:setText((playerInfo.pvp_name or "test").." - "..playerInfo.role_id)
	end

	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(isShow,playerInfo)
		
		if isShow == 1 then
			_createPlayerInfo(playerInfo)
			_frm:show(1)
			_frm:active()
		else
			_frm:show(0)
		end
		
	end)
	
end
