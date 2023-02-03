-----------------------------------
--@ by Kingfisher·J·Tao 2013/5/20
--@游戏中的道具类
hClass.item = eClass:new("static enum sync")

local _hI = hClass.item
local __DefaultParam = {
	name = 0,
	id = 0,
	model = "MODEL:Default",
	icon = "MODEL:Default",
	reward = 0,
	require = 0,		--装备所需的条件
	level = 0,
	grade = 0,
	type = 0,
	skillId = 0,
	stack = 0,
	getday = -1,
	rewardEx = 0,
	continuedays = 0,
	version = 0,
	uniqueID = 0,
	--unit = {},
}

_hI.init = function(self,p)
	self.data = hApi.ReadParam(__DefaultParam,p,rawget(self,"data") or {})

	local d = self.data
	local tabI = hVar.tab_item[d.id] or hVar.tab_item[1]

	if tabI~=nil then
		if tabI.model ~= nil then
			d.model = tabI.model
		end
		if tabI.icon~=nil then
			d.icon = tabI.icon
		end
		if tabI.reward~=nil then
			d.reward = hApi.ReadParamWithDepth(tabI.reward,nil,{},2)
		end
		if tabI.require~=nil then
			d.require = hApi.ReadParamWithDepth(tabI.require,nil,{},1)
		end
		
		d.name = tabI.name
		d.level = tabI.level
		d.type = tabI.type
		d.skillId = tabI.skillId or 0
	end

	d.unit = {}
	d.stack = p.stack or 1
	d.rewardEx =  p.rewardEx or {}
	if p and p.unit~=nil then
		self:bind(p.unit)
		--如果是可堆叠类的道具 则从data中读取堆叠个数
		local ItemData = p.unit:gettriggerdata()
		if ItemData then
			d.stack = ItemData.stack or 1
		end
	end
	d.grade = 1
	--得到该道具的时机 只是可堆叠道具需要判断 避免玩家反复宝箱
	d.getday = (p.getday or -1)
	d.continuedays = p.continuedays or -1
	d.version = p.item_version or 0
	d.uniqueID = 0
end

_hI.destroy = function(self)
	self:bind(nil)
end

_hI.bind = function(self,oUnit)
	local u = hApi.GetObjectUnit(self.data.unit)
	if u and u.data.itemID==self.ID then
		u.data.itemID = 0
	end
	if oUnit~=nil then
		oUnit.data.itemID = self.ID
		return hApi.SetObjectUnit(self.data.unit,oUnit)
	else
		return hApi.SetObjectUnit(self.data.unit,nil)
	end
end

_hI.getunit = function(self)
	return hApi.GetObjectUnit(self.data.unit)
end

--根据输入的道具 GridX,Y 返回英雄身上道具栏的 索引 这里的5 指 一行可以显示的grid数量，由于英雄道具是12个，一行显示6个，但是下标是从0开始的，所以是5...
hApi.HeroItemGrid2Index = function(gridX,gridY,off)
	return (gridX+1)+gridY*(off or 6)
end

hApi.PlayerBagItemGrid2Index = function(gridX,gridY,gridZ)
	local pageCount = hVar.PLAYERBAG_X_NUM * hVar.PLAYERBAG_Y_NUM --geyachao: 一页的数量改为定义变量
	return gridX + gridY*3 + (gridY+1) + gridZ * pageCount - pageCount
end

--输入 槽子index，返回该槽子可以装备的道具类型的接口 陶晶拥有最终解释权...
--zhenkira:修改槽子和格子对应关系的获取方式
hApi.GetHeroEquipmentIndexType = function(iType)
	return hVar.ITEM_EQUIPMENT_UI_INDEX[iType] or -1
	--if Index >= 5 then
	--	return Index
	--else
	--	return Index+1
	--end
end

--输入道具ID 判断
hApi.GetItemTypeByID = function(itemID)
	if hVar.tab_item[itemID] then 
		return hVar.tab_item[itemID].type
	end
	return nil
end