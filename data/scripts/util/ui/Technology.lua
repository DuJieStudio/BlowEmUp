local __TownTechLevel = {}
__TownTechLevel["atklevel"] = {
	price = {
		[1] = {100,0,10,10,5},
		[2] = {100,0,10,10,5},
		[3] = {100,0,10,10,5},
		[4] = {100,0,10,10,5},
	},
}
__TownTechLevel["deflevel"] = {
	price = {
		[1] = {0,0,0,0,0},--������ľ��ʯ����
		[2] = {500,0,5,5,0},
		[3] = {1000,0,10,10,0},
		[4] = {1500,0,15,15,0},
		[5] = {2000,0,20,20,0},
	},
}


--------------------------------
-- ���ǿƼ��������
--------------------------------
hGlobal.UI.InitTechnologyUpgradeFram = function(mode)
	local tInitEventName = {"LocalEvent_TechnologyUpgrade","__SHOW_Technology_UI"}
	if mode~="include" then
		return tInitEventName
	end
	--������
	hGlobal.UI.TechnologyUpgradeFram = hUI.frame:new({
		x = 300,
		y = 600,
		closebtn = "BTN:PANEL_CLOSE",
		closebtnX = 470,
		closebtnY = -14,
		show = 0,
		h = 330,
		w = 480,
		--changed by pangyong 2015/3/30 
		dragable = 3,
	})

	local _fram = hGlobal.UI.TechnologyUpgradeFram
	local _parent = _fram.handle._n
	local _childUI = _fram.childUI

	_childUI["BuildingImageBG"] = hUI.image:new({
		parent = _parent,
		model = "UI_frm:slot",
		animation = "lightSlim",
		w = 72,
		h = 72,
		x = 85,
		y = -85,
		align = "MC",
	})

	--���ֺ�˵��
	_childUI["BuildingnameLab"] = hUI.label:new({
		parent = _parent,
		size = 28,
		align = "LT",
		font = hVar.FONTC,
		x = 300,
		y =-10,
		width = 400,
		text = "",
	})
	
	_childUI["BuildingInfoLab"] = hUI.label:new({
		parent = _parent,
		size = 26,
		align = "LT",
		font = hVar.FONTC,
		x = 100,
		y =-40,
		width = 540,
		text = "",
	})
	
	--����ͼ��
	local minImage_gold,minImage_food,minImage_stone,minImage_wood,minImage_iron,minImage_jewel = 1,2,3,4,5,6
	--����lab
	local minlabRes_gold,minlabRes_food,minlabRes_stone,minlabRes_wood,minlabRes_iron,minlabRes_jewel = 1,2,3,4,5,6
	local _minImageList,_minlabResList= {},{}
	
	--������ʾ���۵�ͼ��� lab �վ�2013-4-9
	--�� ͼƬ 
	_childUI["minImageRes_gold_"] = hUI.image:new({
		parent = _fram.handle._n,
		--mode = "batchImage",
		model = "UI:ICON_main_frm_ResourceGold",
		animation = "lightSlim",
		w = 50,
		x = 30,
		y = -200,
	})
	_minImageList[minImage_gold] = _childUI["minImageRes_gold_"]
	_minImageList[minImage_gold].handle._n:setVisible(false)

	--ʳ�� ͼƬ
	_childUI["minImageRes_food_"] = hUI.image:new({
		parent = _fram.handle._n,
		--mode = "batchImage",
		model = "UI:ICON_main_frm_ResourceFood",
		animation = "lightSlim",
		w = 50,
		x = 30,
		y =-200,
	})
	_minImageList[minImage_food] = _childUI["minImageRes_food_"]
	_minImageList[minImage_food].handle._n:setVisible(false)
	
	--ʯͷ ͼƬ
	_childUI["minImageRes_rook_"] = hUI.image:new({
		parent = _fram.handle._n,
		--mode = "batchImage",
		model = "UI:ICON_main_frm_ResourceStone",
		animation = "lightSlim",
		w = 50,
		x = 30,
		y = -200,
	})
	_minImageList[minImage_stone] = _childUI["minImageRes_rook_"]
	_minImageList[minImage_stone].handle._n:setVisible(false)
	
	--ľ�� ͼƬ
	_childUI["minImageRes_wood_"] = hUI.image:new({
		parent = _fram.handle._n,
		--mode = "batchImage",
		model = "UI:ICON_main_frm_ResourceWood",
		animation = "lightSlim",
		w = 50,
		x = 30,
		y = -200,
	})
	_minImageList[minImage_wood] = _childUI["minImageRes_wood_"]
	_minImageList[minImage_wood].handle._n:setVisible(false)
	
	--���� ͼƬ
	_childUI["minImageRes_iron_"] = hUI.image:new({
		parent = _fram.handle._n,
		--mode = "batchImage",
		model = "UI:ICON_main_frm_ResourceIron",
		animation = "lightSlim",
		w = 50,
		x = 30,
		y = -200,
	})
	_minImageList[minImage_iron] = _childUI["minImageRes_iron_"]
	_minImageList[minImage_iron].handle._n:setVisible(false)

	--��ʯ ͼƬ
	_childUI["minImageRes_jewel_"] = hUI.image:new({
		parent = _fram.handle._n,
		--mode = "batchImage",
		model = "UI:ICON_main_frm_ResourceJewel",
		animation = "lightSlim",
		w = 50,
		x = 30,
		y = -200,
	})
	_minImageList[minImage_jewel] = _childUI["minImageRes_jewel_"]
	_minImageList[minImage_jewel].handle._n:setVisible(false)
	
	--�����ĵĽ��lab 
	_childUI["minlabRes_gold_"] = hUI.label:new({
		parent = _fram.handle._n,
		font = "numWhite",
		size = 14,
		text = "0",
		align = "MC",
		x = 136,
		y = -246,
	})
	_minlabResList[minlabRes_gold] = _childUI["minlabRes_gold_"]
	_minlabResList[minlabRes_gold].handle._n:setVisible(false)
	
	--�����ĵ�ʳ��lab  
	_childUI["minlabRes_food_"] = hUI.label:new({
		parent = _fram.handle._n,
		font = "numWhite",
		size = 14,
		text = "0",
		align = "MC",
		x = 136,
		y = -246,
	})
	_minlabResList[minlabRes_food] = _childUI["minlabRes_food_"]
	_minlabResList[minlabRes_food].handle._n:setVisible(false)
	
	--�����ĵ�ʯͷlab 
	_childUI["minlabRes_stone_"] = hUI.label:new({
		parent = _fram.handle._n,
		font = "numWhite",
		size = 14,
		text = "0",
		align = "MC",
		x = 136,
		y = -246,
	})
	_minlabResList[minlabRes_stone] = _childUI["minlabRes_stone_"]
	_minlabResList[minlabRes_stone].handle._n:setVisible(false)
	
	--�����ĵ�ľ��lab 
	_childUI["minlabRes_wood_"] = hUI.label:new({
		parent = _fram.handle._n,
		font = "numWhite",
		size = 14,
		text = "0",
		align = "MC",
		x = 136,
		y = -246,
	})
	_minlabResList[minlabRes_wood] = _childUI["minlabRes_wood_"]
	_minlabResList[minlabRes_wood].handle._n:setVisible(false)
	
	--�����ĵ�����lab  
	_childUI["minlabRes_iron_"] = hUI.label:new({
		parent = _fram.handle._n,
		font = "numWhite",
		size = 14,
		text = "0",
		align = "MC",
		x = 136,
		y = -246,
	})
	_minlabResList[minlabRes_iron] = _childUI["minlabRes_iron_"]
	_minlabResList[minlabRes_iron].handle._n:setVisible(false)

	--�����ĵı�ʯlab  
	_childUI["minlabRes_jewel_"] = hUI.label:new({
		parent = _fram.handle._n,
		font = "numWhite",
		size = 14,
		text = "0",
		align = "MC",
		x = 136,
		y = -246,
	})
	_minlabResList[minlabRes_jewel] = _childUI["minlabRes_jewel_"]
	_minlabResList[minlabRes_jewel].handle._n:setVisible(false)

	--��������
	_childUI["unitnameLab"] = hUI.label:new({
		parent = _parent,
		size = 26,
		align = "MC",
		font = hVar.FONTC,
		x = _fram.data.w/2+10,
		y =-60,
		width = 300,
		RGB = {255,255,0},
		text = "",
		border = 1,
	})
	--������Ϣ
	_childUI["unitInfoLab"] = hUI.label:new({
		parent = _parent,
		size = 26,
		align = "LT",
		font = hVar.FONTC,
		x = 130,
		y =-70,
		width = 320,
		text = "",
		border = 1,
	})

	local _creatTUBuildingInfo = function(oUnit)
		hApi.safeRemoveT(_childUI,"unitInfoImage")
		local oUnitID = oUnit.data.id
		--ͼ��
		_childUI["unitInfoImage"] = hUI.thumbImage:new({
			parent = _parent,
			unit = oUnit,
			animation = "normal",
			x = 85,
			y = -85,
			w = 72,
			h = 72,
		})

		--����
		local name = oUnitID
		if hVar.tab_stringU[oUnitID] then
			name = hVar.tab_stringU[oUnitID][1]
		else
			name = oUnit.data.name
		end
		_childUI["unitnameLab"]:setText(name)

		--������Ϣ
		local text = oUnitID
		if hVar.tab_stringU[oUnitID] then
			text = hVar.tab_stringU[oUnitID][2]
		else
			text = "Tab_stringU["..oUnitID.."] is nil..."
		end
		_childUI["unitInfoLab"]:setText(text)
		
	end
	
	--��ǰ�Ƽ�������
	_childUI["TechImageBG1"] = hUI.image:new({
		parent = _parent,
		model = "UI_frm:slot",
		animation = "lightSlim",
		w = 68,
		h = 68,
		x = 125,
		y = -165,
		align = "MC",
	})

	--�Ƽ�ͼƬ
	_childUI["Technimage1"]= hUI.image:new({
		parent = _parent,
		model = "UI:wall",
		x = 125,
		y = -165,
	})
	
	--������Ϣlab1 ��ǰ�Ƽ�
	_childUI["TechnologyUpgradeInfoLab1"] = hUI.label:new({
		parent = _parent,
		size = 26,
		align = "MC",
		font = hVar.FONTC,
		border = 1,
		x = 125,
		y =-215,
		width = 200,
		text = "",
	})

	--��ͷͼƬ
	_childUI["UpgradeArrow"] = hUI.image:new({
		parent = _parent,
		model = "UI:UI_Arrow",
		--scale = 0.5,
		x = 230,
		y = -155,
	})
	--������2
	_childUI["TechImageBG2"] = hUI.image:new({
		parent = _parent,
		model = "UI_frm:slot",
		animation = "lightSlim",
		w = 68,
		h = 68,
		x = 340,
		y = -165,
		align = "MC",
	})

	--�Ƽ�ͼƬ2
	_childUI["Technimage2"]= hUI.image:new({
		parent = _parent,
		model = "UI:wall",
		x = 340,
		y = -165,
	})

	
	--������Ϣlab2 ��Ҫ�������ĿƼ�
	_childUI["TechnologyUpgradeInfoLab2"] = hUI.label:new({
		parent = _parent,
		size = 26,
		align = "MC",
		font = hVar.FONTC,
		border = 1,
		x = 340,
		y =-215,
		width = 400,
		text = "",
	})

	--������߼�����ʾ
	_childUI["TechnologyUpgradeInfoLabMAX"] = hUI.label:new({
		parent = _parent,
		size = 26,
		align = "MC",
		font = hVar.FONTC,
		border = 1,
		x = 320,
		y =-170,
		width = 400,
		text = hVar.tab_string["__TEXT_GradeTechMAX"],
	})
	
	_childUI["CannotUpgradelab"] = hUI.label:new({
		parent = _parent,
		size = 24,
		font = hVar.FONTC,
		align = "LT",
		x = 35,
		y = -1*(_fram.data.h-80),
		width = 380,
		text = hVar.tab_string["__TEXT_CanNotBuilding"],
		RGB = {255,255,0},
		border = 1,
	})
	_childUI["CannotUpgradelab"].handle._n:setVisible(false)

	--�����۸�
	local _varList = {}
	--��ҵ���Դ
	local tempPlayRes = {}

	local _buyFunction = function() end

	--�����Ƽ���Ϣ
	local _createTUIcon = function(oUnit)
		local oTown = oUnit:gettown()
		local tech = oTown.data.technologyLevel
		local tcur_def = oTown:gettech("deflevel")
		
		_childUI["TechnologyUpgradeInfoLab1"]:setText(hVar.tab_string["deflevel"].." "..tcur_def)
		--���ݱ༭��˳�������Դ����
		tempPlayRes = {
			hGlobal.LocalPlayer:getresource(hVar.RESOURCE_TYPE.GOLD),
			hGlobal.LocalPlayer:getresource(hVar.RESOURCE_TYPE.FOOD),
			hGlobal.LocalPlayer:getresource(hVar.RESOURCE_TYPE.STONE),
			hGlobal.LocalPlayer:getresource(hVar.RESOURCE_TYPE.WOOD),
			hGlobal.LocalPlayer:getresource(hVar.RESOURCE_TYPE.LIFE),
			hGlobal.LocalPlayer:getresource(hVar.RESOURCE_TYPE.CRYSTAL)
		}
		--���ð�ť�Ƿ���Ե��
		local result = 1

		--��տƼ����� ��ȡ��һ���ȼ��� �Ƽ��۸� 
		local defLv = __TownTechLevel["deflevel"]
		local price = {}
		if tcur_def < #defLv.price then
			--��ǰ�ĳǷ��Ƽ��ȼ���Ϣ
			_childUI["TechnologyUpgradeInfoLab2"]:setText(hVar.tab_string["deflevel"].." "..(tcur_def+1))

			_childUI["TechImageBG2"].handle._n:setVisible(true)
			_childUI["Technimage2"].handle._n:setVisible(true)
			_childUI["TechnologyUpgradeInfoLab2"].handle._n:setVisible(true)
			_childUI["UpgradeArrow"].handle._n:setVisible(true)
			_childUI["TechnologyUpgradeInfoLabMAX"].handle._n:setVisible(false)
			price = defLv.price[tcur_def+1]
		else
			--_childUI["TechnologyUpgradeInfoLab2"]:setText(hVar.tab_string["__TEXT_Current"]..hVar.tab_string["deflevel"].." - "..tcur_def.." \n  MAX")
			_childUI["TechImageBG2"].handle._n:setVisible(false)
			_childUI["Technimage2"].handle._n:setVisible(false)
			_childUI["TechnologyUpgradeInfoLab2"].handle._n:setVisible(false)
			_childUI["UpgradeArrow"].handle._n:setVisible(false)
			_childUI["TechnologyUpgradeInfoLabMAX"].handle._n:setVisible(true)
			result = 0
		end
		
		
		for i = 1,6 do
			_varList[i] = price[i] or 0
		end


		
		for i = 1,6 do
			if tempPlayRes[i]<_varList[i] then
				result = 0
			end
		end
		-- �Ա�������������Щ��Դicon������ʾ �Լ���Щ lab��ʾ���߼�
		--��ȡ������Դ��Ϣ����ʾ
		for i = 1,6,1 do
			_minImageList[i].handle._n:setVisible(false)
			_minlabResList[i].handle._n:setVisible(false)
		end
		
		if oTown.data.buildingCount > 0 then
			result = 0
			_childUI["CannotUpgradelab"].handle._n:setVisible(true)
		else
			_childUI["CannotUpgradelab"].handle._n:setVisible(false)
			local tempindex = 0
			for i = 1,6,1 do
				--������ʾ
				if _varList[i] and _varList[i] ~= 0 then
					--������ʾ
					_minImageList[i].handle._n:setVisible(true)
					_minImageList[i].handle._n:setPosition(60+60*tempindex,-250)
					_minlabResList[i].handle._n:setVisible(true)
					_minlabResList[i].handle._n:setPosition(60+60*tempindex,-280)
					_minlabResList[i]:setText(tostring(_varList[i]))
					tempindex = tempindex + 1
				end

				--�ı�ϡȱ��Դ����ɫ
				if tempPlayRes[i]<_varList[i] then
					_minlabResList[i].handle.s:setColor(ccc3(255,0,0))
				else
					_minlabResList[i].handle.s:setColor(ccc3(255,255,255))
				end
			end
		end

		if result == 1 then
			_childUI["BuyTechnology"]:setstate(1)
		else
			_childUI["BuyTechnology"]:setstate(0)
		end
		
	end
	
	local _oUnit = {}
	_buyFunction = function()
		local oUnit = hApi.GetObject(_oUnit)
		local oTown = oUnit:gettown()
		local tcur_def = oTown:gettech("deflevel")
		if oTown:settech("deflevel",tcur_def+1) == 1 then
			oTown.data.buildingCount = oTown.data.buildingCount + 1
			for i = 1,#hVar.UNIT_PRICE_DEFINE do
				hGlobal.LocalPlayer:addresource(hVar.UNIT_PRICE_DEFINE[i],-1*(_varList[i]))

			end
			_childUI["BuyTechnology"]:setstate(0)
			_childUI["CannotUpgradelab"].handle._n:setVisible(true)
			for i = 1,6 do
				_minImageList[i].handle._n:setVisible(false)
				_minlabResList[i].handle._n:setVisible(false)
			end
		end
	end

	--����ť
	_childUI["BuyTechnology"] = hUI.button:new({
		parent = _parent,
		model =  "UI:ConfimBtn1",
		dragbox = _fram.childUI["dragBox"],
		x = 380,
		y = -260,
		scaleT = 0.9,
		code = function(self,x,y,sus)
			_buyFunction()
		end,
	})

	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(nOperate,oWorld,oUnit,Town,oTarget)
		hApi.SetObject(_oUnit,Town)
		_creatTUBuildingInfo(oTarget)
		_createTUIcon(Town)
		_fram:show(1)
	end)

	hGlobal.event:listen("LocalEvent_PlayerFocusWorld","__UI__HideTechFrame",function(sSceneType,oWorld,oMap)
		_fram:show(0)
	end)

	hGlobal.event:listen("Event_SetTownTech","__UI__RefreshTechFrame",function(oTown)
		--local u = oTown:getunit()
		--_createTUIcon(u)
		local tcur_def = oTown:gettech("deflevel")
		local defLv = __TownTechLevel["deflevel"]

		if tcur_def < #defLv.price then
			_childUI["TechnologyUpgradeInfoLab1"]:setText(hVar.tab_string["deflevel"].." "..tcur_def)
			_childUI["TechnologyUpgradeInfoLab2"]:setText(hVar.tab_string["deflevel"].." "..(tcur_def+1))
		else
			_childUI["TechnologyUpgradeInfoLab1"]:setText(hVar.tab_string["deflevel"].." "..tcur_def)
			_childUI["TechImageBG2"].handle._n:setVisible(false)
			_childUI["Technimage2"].handle._n:setVisible(false)
			_childUI["TechnologyUpgradeInfoLab2"].handle._n:setVisible(false)
			_childUI["UpgradeArrow"].handle._n:setVisible(false)
			_childUI["TechnologyUpgradeInfoLabMAX"].handle._n:setVisible(true)
		end
	end)
	
end
