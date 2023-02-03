--*************************************************************
-- Copyright (c) 2014, XinLine Co.,Ltd
-- Author: Red
-- Detail: ui 模块 目前只有scrollview先都放这个文件了
---------------------------------------------------------------
require "data/scripts/util/extern"

redui = {}
local ui = redui

ui.state = {}
ui.state.canlog = true

function ui.log(info)
	if true == ui.state.canlog then
		xlLG("redui",info)
	end
end

local _setAnchorPoint = nil
local _ccTouchEnded = nil
rui_scrollview = class("rui_scrollview",function()
	local sv = CCScrollView:create()
	_setAnchorPoint = sv.setAnchorPoint
	_ccTouchEnded = sv.ccTouchEnded
	return sv
end)
rui_scrollview.__index = rui_scrollview
-- TODO 实在没空研究 关于c++的虚函数的重载就先放放了...
function rui_scrollview:ccTouchEnded(t,e)
	ui.log("ui.scrollview.ccTouchEnded begin \n")
	getmetatable(self).ccTouchEnded(self,t,e)
	ui.log("ui.scrollview.ccTouchEnded end \n")	
end
-- 重载了 CCScrollView 的setAnchorPoint 方法 其实重载意义也不大 纯粹研究用了
function rui_scrollview:setAnchorPoint(p)
	ui.log("rui_scrollview.setAnchorPoint begin \n")
	_setAnchorPoint(self,p)
	ui.log("rui_scrollview.setAnchorPoint end \n")	
end

ui.scrollview = {}
function ui.scrollview.create()
	local sv = {}
	sv.scrollview = rui_scrollview.new() --CCScrollView:create() 使用下自己派生的类
	sv.container = CCLayer:create()
	sv.state = {}
	sv.state.adjust = 0
	if sv.scrollview == nil then
		ui.log("ui.scrollview.create faild \n")
		return nil
	else
		ui.log(string.format("ui.scrollview.create ok type:%s \n",tostring(type(sv.scrollview))))
		
		sv.container:setAnchorPoint(ccp(0,0))
		sv.container:setPosition(ccp(0,0))

		sv.scrollview:setAnchorPoint(ccp(0,0))
		sv.scrollview:setPosition(ccp(0,0))

		sv.scrollview:setContainer(sv.container)
		
		local function onscript(tag)
			ui.log(string.format("onscript type:%s \n",tostring(tag)))
			if "ccTouchEnded" == tag then
				ui.scrollview.adjustview(sv)
			end
		end
		local layer = sv.scrollview
		layer:registerScriptHandler(onscript)

		return sv
	end
end

function ui.scrollview.setadjust(sv,v)
	if "number" == type(v) then
		if v >= 0 then
			sv.state.adjust = v
		end
	end
end

function ui.scrollview.adjustview(sv)
	local dir = sv.scrollview:getDirection()
	if 0 == dir then -- 水平滚动
	elseif 1 == dir then -- 垂直滚动
		-- 垂直总以上面对齐
		local view_h = sv.scrollview:getViewSize().height
		local content_h = sv.scrollview:getContentSize().height
		local max_h = sv.scrollview:maxContainerOffset().y
		local min_h = sv.scrollview:minContainerOffset().y
		--ui.log(string.format("ui.scrollview.adjustview view_h:%d content_h:%d max_h:%d min_h:%d \n",view_h,content_h,max_h,min_h))
		local adjust = sv.state.adjust
		if 0 == adjust or adjust > view_h then
			return -- 不处理对齐
		end

		-- 先关闭动画
		sv.scrollview:setZoomScale(1,false)
		
		local y = sv.scrollview:getContentOffset().y
		local offset = 0
		if y < 0 then
			offset = y - min_h
			local left = math.fmod(offset,adjust)
			local count = math.modf(offset/adjust)
			if left >= adjust/2 then
				y = min_h + (count + 1) * adjust
			else
				y = min_h + (count) * adjust
			end
			if y < min_h then
				y = min_h
			end
		else
			if content_h >= view_h then
				y = 0
			end
		end
		--ui.log(string.format("ui.scrollview.adjustview y:%d offset:%d \n",y,offset))
		sv.scrollview:setContentOffsetInDuration(ccp(0,y),0.3)
	end
end

-- 看样子是不需要再开这些函数了
function ui.scrollview.setanchorpoint(sv,p)
	sv.scrollview:setAnchorPoint(p)
end
function ui.scrollview.setposition(sv,p)
	sv.scrollview:setPosition(p)
end
