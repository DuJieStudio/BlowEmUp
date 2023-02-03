----------------------------
--兵种升级界面
----------------------------
hGlobal.UI.InitUpgradeArmyFrm = function(mode)
	local tInitEventName = {"LocalEvent_ShowUpgradeArmyFrm","_showthisfrm"}
	if mode~="include" then
		return tInitEventName
	end
	hGlobal.UI.UpgradeArmyFrm = hUI.frame:new({
		x = hVar.SCREEN.w/2 - 544/2,
		y = hVar.SCREEN.h/2 + 462/2,
		closebtn = "BTN:PANEL_CLOSE",
		closebtnX = 534,
		closebtnY = -14,
		--background = "UI:PANEL_INFO_S",
		w = 544,
		h = 462,
		--changed by pangyong 2015/3/5
		dragable = 3,
		show = 0,
		codeOnClose = function()
			hGlobal.event:event("LocalEvent_UpgradeArmy_close")
		end,
	})
	
	local _frm = hGlobal.UI.UpgradeArmyFrm
	local _parent = _frm.handle._n
	local _childUI = _frm.childUI
	
	_childUI["apartline_back"] = hUI.image:new({
		parent = _parent,
		model = "UI:panel_part_09",
		x = 270,
		y = -150,
		w = 544,
		h = 8,
	})

	local _NNUM,_NMAX = 1,2
	local _uNum = {0,0}
	local _bar,_num
	
	--lab控件对象
	local labRes_gold,labRes_food,labRes_stone,labRes_wood,labRes_iron,labRes_jewel = 1,2,3,4,5,6
	--图标
	local Image_gold,Image_food,Image_stone,Image_wood,Image_iron,Image_jewel = 1,2,3,4,5,6
	--单价图标
	local minImage_gold,minImage_food,minImage_stone,minImage_wood,minImage_iron,minImage_jewel = 1,2,3,4,5,6
	--单价lab
	local minlabRes_gold,minlabRes_food,minlabRes_stone,minlabRes_wood,minlabRes_iron,minlabRes_jewel = 1,2,3,4,5,6
	
	local _ImageList,_labResList, _minImageList,_minlabResList= {},{},{},{}
	
	--升级价格
	local _varList = {}
	--当前所剩资源
	local tempPlayRes = {}
	
	--拖拽条
	_childUI["PartArmy_bar"] = hUI.valbar:new({
		parent = _parent,
		model = "UI:ValueBar",
		back = {model = "UI:ValueBar_Back",x=0,y=0,w=360,h=36},
		w = 360,
		h = 36,
		x = 90,
		y = -250,
		align = "LT",
	})
	_bar = _childUI["PartArmy_bar"]
	_bar:setV(160,360)
	
	_childUI["scrollBtn"] = hUI.image:new({
		parent = _parent,
		model = "UI:scrollBtn",
		x = 95,
		y = -261,
	})

	--拖拽条上显示的数字
	_childUI["PartArmy_labNum"] = hUI.label:new({
		parent = _parent,
		font = "numWhite",
		size = 18,
		text = "",
		align = "MC",
		x = _bar.data.x+_bar.data.w/2,
		y = _bar.data.y-_bar.data.h/2,
	})
	_num = _childUI["PartArmy_labNum"]
	
	
	--当前单位的信息面板
	local slotx1,sloty1,slotx2,sloty2= 82,-88,380,-88
	--头像面板
	_childUI["UpgradeArmyslot_1"] = hUI.image:new({
		parent = _parent,
		model = "UI_frm:slot",
		animation = "lightSlim",
		w = 74,
		h = 74,
		x = slotx1,
		y = sloty1,
	})

	_childUI["UpgradeArmy_name_1"] = hUI.label:new({
		parent = _parent,
		size = 26,
		font = hVar.FONTC,
		align = "MC",
		x = slotx1,
		y = sloty1-50,
		width = 248,
		text = "",--hVar.tab_stringU[UnitID][1] or "UNIT_"..UnitID.."_NAME",
		border = 1,
		RGB = {255,255,0},
	})

	--箭头图片
	_childUI["UpgradeArrow"] = hUI.image:new({
		parent = _parent,
		model = "UI:UI_Arrow",
		--scale = 0.5,
		x = 230,
		y = -90,
	})	
	--升级成目标单位的信息
	--头像面板
	_childUI["UpgradeArmyslot_2"] = hUI.image:new({
		parent = _parent,
		model = "UI_frm:slot",
		animation = "lightSlim",
		w = 74,
		h = 74,
		x = slotx2,
		y = sloty2,
	})

	_childUI["UpgradeArmy_name_2"] = hUI.label:new({
		parent = _parent,
		size = 26,
		font = hVar.FONTC,
		align = "MC",
		x = slotx2,
		y = sloty2-50,
		width = 248,
		text = "",--hVar.tab_stringU[upID][1] or "UNIT_"..upID.."_NAME",
		border = 1,
		RGB = {255,255,0},
	})

	--金 图片 
	_childUI["ImageRes_gold_"] = hUI.image:new({
		parent = _frm.handle._n,
		--mode = "batchImage",
		model = "UI:ICON_main_frm_ResourceGold",
		animation = "lightSlim",
		w = 50,
		x = 30,
		y = -200,
	})
	_ImageList[Image_gold] = _childUI["ImageRes_gold_"]
	_ImageList[Image_gold].handle._n:setVisible(false)

	--食物 图片
	_childUI["ImageRes_food_"] = hUI.image:new({
		parent = _frm.handle._n,
		--mode = "batchImage",
		model = "UI:ICON_main_frm_ResourceFood",
		animation = "lightSlim",
		w = 50,
		x = 30,
		y =-200,
	})
	_ImageList[Image_food] = _childUI["ImageRes_food_"]
	_ImageList[Image_food].handle._n:setVisible(false)
	
	--石头 图片 陶晶2013-4-8
	_childUI["ImageRes_rook_"] = hUI.image:new({
		parent = _frm.handle._n,
		--mode = "batchImage",
		model = "UI:ICON_main_frm_ResourceStone",
		animation = "lightSlim",
		w = 50,
		x = 30,
		y = -200,
	})
	_ImageList[Image_stone] = _childUI["ImageRes_rook_"]
	_ImageList[Image_stone].handle._n:setVisible(false)
	
	--木材 图片 陶晶2013-4-8
	_childUI["ImageRes_wood_"] = hUI.image:new({
		parent = _frm.handle._n,
		--mode = "batchImage",
		model = "UI:ICON_main_frm_ResourceWood",
		animation = "lightSlim",
		w = 50,
		x = 30,
		y = -200,
	})
	_ImageList[Image_wood] = _childUI["ImageRes_wood_"]
	_ImageList[Image_wood].handle._n:setVisible(false)
	
	--镔铁 图片 陶晶2013-4-8
	_childUI["ImageRes_iron_"] = hUI.image:new({
		parent = _frm.handle._n,
		--mode = "batchImage",
		model = "UI:ICON_main_frm_ResourceIron",
		animation = "lightSlim",
		w = 50,
		x = 30,
		y = -200,
	})
	_ImageList[Image_iron] = _childUI["ImageRes_iron_"]
	_ImageList[Image_iron].handle._n:setVisible(false)

	--宝石 图片 陶晶2013-4-8
	_childUI["ImageRes_jewel_"] = hUI.image:new({
		parent = _frm.handle._n,
		--mode = "batchImage",
		model = "UI:ICON_main_frm_ResourceJewel",
		animation = "lightSlim",
		w = 50,
		x = 30,
		y = -200,
	})
	_ImageList[Image_jewel] = _childUI["ImageRes_jewel_"]
	_ImageList[Image_jewel].handle._n:setVisible(false)
	
	--所消耗的金币lab 陶晶2013-4-8 
	_childUI["labRes_gold_"] = hUI.label:new({
		parent = _frm.handle._n,
		font = "numWhite",
		size = 14,
		text = "0",
		align = "MC",
		x = 136,
		y = -246,
	})
	_labResList[labRes_gold] = _childUI["labRes_gold_"]
	_labResList[labRes_gold].handle._n:setVisible(false)
	
	--所消耗的食物lab 陶晶2013-4-8 
	_childUI["labRes_food_"] = hUI.label:new({
		parent = _frm.handle._n,
		font = "numWhite",
		size = 14,
		text = "0",
		align = "MC",
		x = 136,
		y = -246,
	})
	_labResList[labRes_food] = _childUI["labRes_food_"]
	_labResList[labRes_food].handle._n:setVisible(false)
	
	--所消耗的石头lab 陶晶2013-4-8 
	_childUI["labRes_stone_"] = hUI.label:new({
		parent = _frm.handle._n,
		font = "numWhite",
		size = 14,
		text = "0",
		align = "MC",
		x = 136,
		y = -246,
	})
	_labResList[labRes_stone] = _childUI["labRes_stone_"]
	_labResList[labRes_stone].handle._n:setVisible(false)
	
	--所消耗的木材lab 陶晶2013-4-8 
	_childUI["labRes_wood_"] = hUI.label:new({
		parent = _frm.handle._n,
		font = "numWhite",
		size = 14,
		text = "0",
		align = "MC",
		x = 136,
		y = -246,
	})
	_labResList[labRes_wood] = _childUI["labRes_wood_"]
	_labResList[labRes_wood].handle._n:setVisible(false)
	
	--所消耗的镔铁lab 陶晶2013-4-8 
	_childUI["labRes_iron_"] = hUI.label:new({
		parent = _frm.handle._n,
		font = "numWhite",
		size = 14,
		text = "0",
		align = "MC",
		x = 136,
		y = -246,
	})
	_labResList[labRes_iron] = _childUI["labRes_iron_"]
	_labResList[labRes_iron].handle._n:setVisible(false)

	--所消耗的宝石lab 陶晶2013-4-8 
	_childUI["labRes_jewel_"] = hUI.label:new({
		parent = _frm.handle._n,
		font = "numWhite",
		size = 14,
		text = "0",
		align = "MC",
		x = 136,
		y = -246,
	})
	_labResList[labRes_jewel] = _childUI["labRes_jewel_"]
	_labResList[labRes_jewel].handle._n:setVisible(false)

	
	--用于显示单价的图标和 lab 陶晶2013-4-9
	--金 图片 
	_childUI["minImageRes_gold_"] = hUI.image:new({
		parent = _frm.handle._n,
		--mode = "batchImage",
		model = "UI:ICON_main_frm_ResourceGold",
		animation = "lightSlim",
		w = 50,
		x = 30,
		y = -200,
	})
	_minImageList[minImage_gold] = _childUI["minImageRes_gold_"]
	_minImageList[minImage_gold].handle._n:setVisible(false)

	--食物 图片
	_childUI["minImageRes_food_"] = hUI.image:new({
		parent = _frm.handle._n,
		--mode = "batchImage",
		model = "UI:ICON_main_frm_ResourceFood",
		animation = "lightSlim",
		w = 50,
		x = 30,
		y =-200,
	})
	_minImageList[minImage_food] = _childUI["minImageRes_food_"]
	_minImageList[minImage_food].handle._n:setVisible(false)
	
	--石头 图片
	_childUI["minImageRes_rook_"] = hUI.image:new({
		parent = _frm.handle._n,
		--mode = "batchImage",
		model = "UI:ICON_main_frm_ResourceStone",
		animation = "lightSlim",
		w = 50,
		x = 30,
		y = -200,
	})
	_minImageList[minImage_stone] = _childUI["minImageRes_rook_"]
	_minImageList[minImage_stone].handle._n:setVisible(false)
	
	--木材 图片
	_childUI["minImageRes_wood_"] = hUI.image:new({
		parent = _frm.handle._n,
		--mode = "batchImage",
		model = "UI:ICON_main_frm_ResourceWood",
		animation = "lightSlim",
		w = 50,
		x = 30,
		y = -200,
	})
	_minImageList[minImage_wood] = _childUI["minImageRes_wood_"]
	_minImageList[minImage_wood].handle._n:setVisible(false)
	
	--镔铁 图片
	_childUI["minImageRes_iron_"] = hUI.image:new({
		parent = _frm.handle._n,
		--mode = "batchImage",
		model = "UI:ICON_main_frm_ResourceIron",
		animation = "lightSlim",
		w = 50,
		x = 30,
		y = -200,
	})
	_minImageList[minImage_iron] = _childUI["minImageRes_iron_"]
	_minImageList[minImage_iron].handle._n:setVisible(false)

	--宝石 图片
	_childUI["minImageRes_jewel_"] = hUI.image:new({
		parent = _frm.handle._n,
		--mode = "batchImage",
		model = "UI:ICON_main_frm_ResourceJewel",
		animation = "lightSlim",
		w = 50,
		x = 30,
		y = -200,
	})
	_minImageList[minImage_jewel] = _childUI["minImageRes_jewel_"]
	_minImageList[minImage_jewel].handle._n:setVisible(false)
	
	--所消耗的金币lab 
	_childUI["minlabRes_gold_"] = hUI.label:new({
		parent = _frm.handle._n,
		font = "numWhite",
		size = 14,
		text = "0",
		align = "MC",
		x = 136,
		y = -246,
	})
	_minlabResList[minlabRes_gold] = _childUI["minlabRes_gold_"]
	_minlabResList[minlabRes_gold].handle._n:setVisible(false)
	
	--所消耗的食物lab  
	_childUI["minlabRes_food_"] = hUI.label:new({
		parent = _frm.handle._n,
		font = "numWhite",
		size = 14,
		text = "0",
		align = "MC",
		x = 136,
		y = -246,
	})
	_minlabResList[minlabRes_food] = _childUI["minlabRes_food_"]
	_minlabResList[minlabRes_food].handle._n:setVisible(false)
	
	--所消耗的石头lab 
	_childUI["minlabRes_stone_"] = hUI.label:new({
		parent = _frm.handle._n,
		font = "numWhite",
		size = 14,
		text = "0",
		align = "MC",
		x = 136,
		y = -246,
	})
	_minlabResList[minlabRes_stone] = _childUI["minlabRes_stone_"]
	_minlabResList[minlabRes_stone].handle._n:setVisible(false)
	
	--所消耗的木材lab 
	_childUI["minlabRes_wood_"] = hUI.label:new({
		parent = _frm.handle._n,
		font = "numWhite",
		size = 14,
		text = "0",
		align = "MC",
		x = 136,
		y = -246,
	})
	_minlabResList[minlabRes_wood] = _childUI["minlabRes_wood_"]
	_minlabResList[minlabRes_wood].handle._n:setVisible(false)
	
	--所消耗的镔铁lab  
	_childUI["minlabRes_iron_"] = hUI.label:new({
		parent = _frm.handle._n,
		font = "numWhite",
		size = 14,
		text = "0",
		align = "MC",
		x = 136,
		y = -246,
	})
	_minlabResList[minlabRes_iron] = _childUI["minlabRes_iron_"]
	_minlabResList[minlabRes_iron].handle._n:setVisible(false)

	--所消耗的宝石lab  
	_childUI["minlabRes_jewel_"] = hUI.label:new({
		parent = _frm.handle._n,
		font = "numWhite",
		size = 14,
		text = "0",
		align = "MC",
		x = 136,
		y = -246,
	})
	_minlabResList[minlabRes_jewel] = _childUI["minlabRes_jewel_"]
	_minlabResList[minlabRes_jewel].handle._n:setVisible(false)
	
	--单价 title
	_childUI["UnitPrice_"] = hUI.label:new({
		parent = _frm.handle._n,
		size = 28,
		align = "LT",
		font = hVar.FONTC,
		x = 40,
		y =-190,
		width = 60,
		text = hVar.tab_string["__TEXT_UnitPrice"],
		border = 1,
	})
	--总价 title
	_childUI["TotalPrices"] = hUI.label:new({
		parent = _frm.handle._n,
		size = 28,
		align = "LT",
		font = hVar.FONTC,
		x = 40,
		y =-300,
		width = 60,
		text = hVar.tab_string["__TEXT_TotalPrices"],
		border = 1,
	})
	local _index = 0
	local _frmIndex = 0
	local _oUnit = {}
	local _upID = 0
	--确定按钮
	_childUI["btnConfirm"] = hUI.button:new({
		parent = _parent,
		model = "UI:ConfimBtn1",
		dragbox = _childUI["dragBox"],
		x = _frm.data.w/2 - 10,
		y = -1*(_frm.data.h-40),
		scaleT = 0.9,
		code = function(self)
			_frm:show(0)
			local u = hApi.GetObject(_oUnit)
			hGlobal.LocalPlayer:order(u:getworld(),hVar.OPERATE_TYPE.ARMY_UPGRADE,u,{_index,u.data.team[_index][1],_upID,_uNum[_NNUM],_uNum[_NMAX],_varList},_frmIndex)
		end,
	})
	--_childUI["btnConfirm"]:setstate(0)

	local _showBtnConfirm = function()
		--根据当前的购买数量进行 lab控件内容设置 陶晶2013-4-8
		for i = 1,6,1 do
			if tempPlayRes[i]< (_varList[i]*_uNum[_NNUM]) then
				_labResList[i].handle.s:setColor(ccc3(255,0,0))
			else
				_labResList[i].handle.s:setColor(ccc3(255,255,255))
			end
			_labResList[i]:setText(tostring(_varList[i]*_uNum[_NNUM]))
		end
		--设置按钮是否可以点击
		local result = 1		
		for i = 1,6 do
			if tempPlayRes[i]<_varList[i]*_uNum[_NNUM] then
				result = 0
			end
		end

		if result == 1 and _uNum[_NNUM] > 0 then
			_childUI["btnConfirm"]:setstate(1)
		else
			_childUI["btnConfirm"]:setstate(0)
		end
	end
	--根据编辑器顺序进行资源保存
	local _setresourcelist = function()
		tempPlayRes = {
			hGlobal.LocalPlayer:getresource(hVar.RESOURCE_TYPE.GOLD),
			hGlobal.LocalPlayer:getresource(hVar.RESOURCE_TYPE.FOOD),
			hGlobal.LocalPlayer:getresource(hVar.RESOURCE_TYPE.STONE),
			hGlobal.LocalPlayer:getresource(hVar.RESOURCE_TYPE.WOOD),
			hGlobal.LocalPlayer:getresource(hVar.RESOURCE_TYPE.LIFE),
			hGlobal.LocalPlayer:getresource(hVar.RESOURCE_TYPE.CRYSTAL)
		}
		_showBtnConfirm()
	end
	--缩放条操作时的函数
	local _scorllFunc = function(self,x)
		x = math.min(360,math.max(0,x-self.data.x))
		_bar:setV(x,360)
		local tempX = x
		if tempX > 350 then tempX = 350 end
		_childUI["scrollBtn"].handle._n:setPosition(tempX+95,-261)
		_uNum[_NNUM] = math.ceil(_uNum[_NMAX]*x/_bar.data.w)
		_num:setText(tostring(_uNum[_NNUM].."/".._uNum[_NMAX]))
		_setresourcelist()
		
	end

	_childUI["PartArmy_btnScorll"] = hUI.button:new({
		parent = _parent,
		mode = "imageButton",
		dragbox = _frm.childUI["dragBox"],
		model = "MODEL:Default",
		w = _bar.data.w,
		h = 32,
		x = _bar.data.x,
		y = _bar.data.y,
		align = "LT",
		failcall = 1,
		codeOnTouch = function(self,x,y,sus)
			_scorllFunc(self,x)
		end,
		codeOnDrag = function(self,x,y,sus)
			_scorllFunc(self,x)
		end,
	})
	_childUI["PartArmy_btnScorll"].handle.s:setVisible(false)
	
	--拖拽条左箭头
	_childUI["PartArmy__btnMinus"] = hUI.button:new({
		parent = _parent,
		mode = "imageButton",
		dragbox = _frm.childUI["dragBox"],
		model = "UI:subone",
		animation = "L",
		w = 32,
		h = 32,
		x = _bar.data.x-28,
		y = _bar.data.y-18,
		scaleT = 0.75,
		codeOnTouch = function(self,x,y,sus)
			if _uNum[_NNUM]>0 then
				_uNum[_NNUM] = _uNum[_NNUM] - 1
				_bar:setV(_uNum[_NNUM],_uNum[_NMAX])
				_childUI["scrollBtn"].handle._n:setPosition(_bar.data.rect.w -_bar.data.curW+95,-261)
				_num:setText(tostring(_uNum[_NNUM].."/".._uNum[_NMAX]))
				_setresourcelist()
			end
		end,
	})
	--拖拽条右箭头
	_childUI["PartArmy__btnPlus"] = hUI.button:new({
		parent = _parent,
		mode = "imageButton",
		dragbox = _frm.childUI["dragBox"],
		model = "UI:addone",
		animation = "R",
		w = 32,
		h = 32,
		x = _bar.data.x+_bar.data.w+28,
		y = _bar.data.y-18,
		scaleT = 0.75,
		codeOnTouch = function(self,x,y,sus)
			if _uNum[_NNUM]<_uNum[_NMAX] then
				_uNum[_NNUM] = _uNum[_NNUM] + 1
				_bar:setV(_uNum[_NNUM],_uNum[_NMAX])
				local tempX = _bar.data.rect.w -_bar.data.curW
				if tempX>350 then tempX = 350 end
				_childUI["scrollBtn"].handle._n:setPosition(tempX+95,-261)
				_num:setText(tostring(_uNum[_NNUM].."/".._uNum[_NMAX]))
				_setresourcelist()
			end
		end,
	})
	
	--显示单价和总价 
	local _showUnitPrice = function()
		local tempindex = 0
		for i = 1,6,1 do
			if _varList[i] and _varList[i] ~= 0 then
				--单价显示
				_minImageList[i].handle._n:setVisible(true)
				_minImageList[i].handle._n:setPosition(130+130*tempindex,-200)
				_minlabResList[i].handle._n:setVisible(true)
				_minlabResList[i].handle._n:setPosition(130+130*tempindex,-230)
				_minlabResList[i]:setText(tostring(_varList[i]))
				--总价
				_ImageList[i].handle._n:setVisible(true)
				_ImageList[i].handle._n:setPosition(130+130*tempindex,-310)
				_labResList[i].handle._n:setVisible(true)
				_labResList[i].handle._n:setPosition(130+130*tempindex,-340)
				_labResList[i]:setText(tostring(_varList[i]*_uNum[_NNUM]))
				tempindex = tempindex+1
			end
		end
	end

	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(oUnit,index,nUnitID,UnitNum,frmIndex)
		hApi.safeRemoveT(_childUI,"UpgradeArmythumbImage_1")
		hApi.safeRemoveT(_childUI,"UpgradeArmythumbImage_2")

		local nUpgradeID
		local tIDList = hApi.GetArmyUpgradeListById(nUnitID)
		if #tIDList>0 then
			local oHero = oUnit:gethero()
			local oTown
			if oHero~=nil then
				oTown = oUnit:getvisit()
			else
				oTown = oUnit:gettown()
			end
			for i = 1,#tIDList do
				local id = tIDList[i]
				if oTown~=nil and hApi.CheckIfCanUpgradeArmyByTown(oTown,nUnitID,id)~=0 then
					nUpgradeID = id
					break
				elseif oHero~=nil and hApi.CheckIfCanUpgradeArmyByHero(oHero,nUnitID,id)~=0 then
					nUpgradeID = id
					break
				end
			end
		end
		if (nUpgradeID or 0)==0 then
			return
		end

		hApi.SetObject(_oUnit,oUnit)

		--之前的做法 upgradelist[2] 记录单位的升级价格 现在已经废弃，用ID 获取价格 来进行计算 得出差价
		local curprice = hVar.tab_unit[nUnitID].price
		local upprice = hVar.tab_unit[nUpgradeID].price
		local price = {}
		for i = 1,#upprice do
			price[i] = upprice[i] - (curprice[i] or 0)
		end
		
		_index = index
		_uNum[_NMAX] = UnitNum
		_frmIndex = frmIndex
		_upID = nUpgradeID

		_childUI["UpgradeArmythumbImage_1"] = hUI.thumbImage:new({
			parent = _parent,
			id = nUnitID,
			animation = hApi.animationByFacing(nUnitID,"stand",180),
			w = 84,
			h = 84,
			x = slotx1,
			y = sloty1-20,
			z = 1,
		})

		_childUI["UpgradeArmythumbImage_2"] = hUI.thumbImage:new({
			parent = _parent,
			id = nUpgradeID,
			animation = hApi.animationByFacing(nUpgradeID,"stand",180),
			w = 84,
			h = 84,
			x = slotx2,
			y = sloty2-20,
			z = 1,
		})

		_childUI["UpgradeArmy_name_1"]:setText(hVar.tab_stringU[nUnitID][1])
		_childUI["UpgradeArmy_name_2"]:setText(hVar.tab_stringU[nUpgradeID][1])

		for i = 1,6 do
			_varList[i] = (price[i] or 0)
			_minImageList[i].handle._n:setVisible(false)
			_minlabResList[i].handle._n:setVisible(false)
			_ImageList[i].handle._n:setVisible(false)
			_labResList[i].handle._n:setVisible(false)
		end

		local tempnum = 0 --玩家身上的资源 一共可购买的兵种个数
		local tempIndex = 0 --临时索引
		local tempNumlist = {-1,-1,-1,-1,-1,-1} --临时购买个数表 ，每种资源可以购买的最大个数
		--根据编辑器顺序进行资源保存
		tempPlayRes = {
			hGlobal.LocalPlayer:getresource(hVar.RESOURCE_TYPE.GOLD),
			hGlobal.LocalPlayer:getresource(hVar.RESOURCE_TYPE.FOOD),
			hGlobal.LocalPlayer:getresource(hVar.RESOURCE_TYPE.STONE),
			hGlobal.LocalPlayer:getresource(hVar.RESOURCE_TYPE.WOOD),
			hGlobal.LocalPlayer:getresource(hVar.RESOURCE_TYPE.LIFE),
			hGlobal.LocalPlayer:getresource(hVar.RESOURCE_TYPE.CRYSTAL)
		}
		--存储用来排序的购买个数表
		for i = 1,6,1 do
			if _varList[i] ~= 0 then
				tempIndex = tempIndex+1
				tempNumlist[tempIndex] = math.floor(tempPlayRes[i]/_varList[i])
			end
		end

		--找到最小值
		tempnum = tempNumlist[1]
		for i = 1,#tempNumlist, 1 do
			if tempNumlist[i] < tempnum and tempNumlist[i]~= -1 then
				tempnum = tempNumlist[i]
			end
		end

		--对购买数进行赋值
		if tempnum > _uNum[_NMAX] then
			_uNum[_NNUM] = _uNum[_NMAX]
		else
			_uNum[_NNUM] = tempnum
		end
		_bar:setV(_uNum[_NNUM],_uNum[_NMAX])

		local tempX = _bar.data.rect.w -_bar.data.curW
		if tempX>350 then tempX = 350 end
		_childUI["scrollBtn"].handle._n:setPosition(tempX+95,-261)
		_num:setText(tostring(_uNum[_NNUM].."/".._uNum[_NMAX]))

		_showBtnConfirm()
		_showUnitPrice()
		_frm:show(1)
		_frm:active()
	end)
end
hApi.getUpgradeFrmState = function()
	if hGlobal.UI.UpgradeArmyFrm then
		return hGlobal.UI.UpgradeArmyFrm.data.show
	end
	return 0
end