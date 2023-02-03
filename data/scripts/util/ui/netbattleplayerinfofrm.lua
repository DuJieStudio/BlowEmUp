-------------------------------
--�����սս�������Ϣ�鿴���
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

	--���ͷ��� + ����۵�ͼ
	_childUI["HeroSlot"] = hUI.image:new({
		parent = _parent,
		model = "UI:zjexp",
		x = 160,
		y = -76,
	})
	
	--��Ҿ�����
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
	
	--�������ϵ�����
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

	--����ȼ�
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
	
	--ս���ȼ�
	_childUI["PVPFightGrade"]= hUI.label:new({
		parent = _parent,
		x = _w - 180,
		y = -30,
		text = hVar.tab_string["PVP_CUR_Title"],
		font = hVar.FONTC,
		size = 24,
		border = 1,
	})

	--ս���ȼ��ı���ͼƬ
	_childUI["cjkk"] = hUI.image:new({
		parent = _parent,
		model = "UI:cjkk",
		x = _w - 150,
		y = -86,

	})

	--�ֽ���
	_childUI["apartline_back"] = hUI.image:new({
		parent = _parent,
		model = "UI:panel_part_09",
		x = _w/2,
		y = -150,
		w = _w,
		h = 8,
	})
	
	--���ݸſ�����ͼ
	_childUI["cjbt"] = hUI.image:new({
		parent = _parent,
		model = "UI:cjbt",
		x = 206,
		y = -180,
	})
	

	--���ݸſ�
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
	--�������� �ֱ��� ս������ʤ����ʤ��
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

	--�������ĵ�ͼ
	_childUI["pvp_result_bg"] = hUI.image:new({
		parent = _parent,
		model = "UI:selectbg",
		x = 214,
		y = -_h + 30,
		w = 470,
		h = 30,
		z = -1,
	})

	--������ lab
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
	
	-- ʤ
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
	
	-- ��
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
	
	--��
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
	
	--�����ʵװ� zjdb
	_childUI["zjdb"] = hUI.image:new({
		parent = _parent,
		model = "UI:zjdb",
		x = 540,
		y = -300,
	})

	--��ɫID �鿴
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
		
		--����������hero Name
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

		--���������� hero count
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
	
	--��������lab
	_childUI["PVPEnterNum"]= hUI.label:new({
		parent = _parent,
		x = 496,
		y = -166,
		text = hVar.tab_string["PVPEnterNum"],
		font = hVar.FONTC,
		size = 22,
		border = 1,
	})

	--����ս������С����
	local _DrawPowerImage = function(Power)
		--ս����
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
	
	--����Ӣ�۳������ַ���
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

	--����Ӣ�۳����� ��Ϣ
	
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
	
	--���� 1 2 3 �� ��ҵ����� ��������ʾ
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
		--Ӣ��ͷ��
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
		
		--������
		local sun = (playerInfo.pvp_win or 0) + (playerInfo.pvp_fail or 0) + (playerInfo.pvp_giveup or 0)
		_childUI["pvp_sun"]:setText(hVar.tab_string["PVP_SUN"].." : "..tostring(sun))
		--ʤ
		_childUI["pvp_win"]:setText(hVar.tab_string["PVPWin"].." : "..(playerInfo.pvp_win or 0))
		--��
		_childUI["pvp_fail"]:setText(hVar.tab_string["__TEXT_Fail"].." : "..(playerInfo.pvp_fail or 0))
		--��
		--_childUI["escape"]:setText(hVar.tab_string["PVPFlee"].." : "..(playerInfo.pvp_giveup or 0))
		--����
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
		--ս����
		if playerInfo.pvp_rank > 3 then
			_childUI["playerInfoLabNum_1"]:setText(playerInfo.pvp_rank)
		elseif playerInfo.pvp_rank > 0 and playerInfo.pvp_rank <= 3 then
			_childUI["playerInfoLabNum_1"]:setText("")
			_childUI["rank_n_"..playerInfo.pvp_rank].handle._n:setVisible(true)
		else
			_childUI["playerInfoLabNum_1"]:setText(playerInfo.pvp_rank)
		end
		--����ս����ͼƬ
		_DrawPowerImage(playerInfo.power)

		--ʤ��
		_childUI["playerInfoLabNum_2"]:setText(playerInfo.pvp_win)
		--ʤ��
		local probability = 0
		
		if sun > 0 then
			probability = math.floor(playerInfo.pvp_win/sun*100)
		end
		_childUI["playerInfoLabNum_3"]:setText(probability.."%")

		--Ӣ�۳�������Ϣ
		local tempHeroEnterList = _LoadDetailsFromStr(playerInfo.unit_hot)
		_DrawHeroEnterProbability(tempHeroEnterList,sun)
		
		--�����������
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
