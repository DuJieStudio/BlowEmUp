--��ɵ�ͼ�󣬽���ĳ��ͼ��˵��
hGlobal.UI.InitAmuLockFrm = function()
	local _w,_h = 660,460
	local _removeList = {}
	local _childUI = nil
	local _CODE_OnExit = nil
	hGlobal.UI.AmuLockFrm = hUI.frame:new({
		x = hVar.SCREEN.w/2 - _w/2,
		y = hVar.SCREEN.h/2 + _h/2,
		w = _w,
		h = _h,
		dragable = 4,
		show = 0,
		closebtn = "BTN:PANEL_CLOSE",
		closebtnX = _w-10,
		closebtnY = -15,
		codeOnClose = function(self)
			for i = 1,#_removeList do
				hApi.safeRemoveT(_childUI,_removeList[i])
			end
			_removeList = {}
			local code = _CODE_OnExit
			_CODE_OnExit = nil
			if type(code)=="function" then
				code()
			end
		end,
	})

	local _frm = hGlobal.UI.AmuLockFrm
	local _parent = _frm.handle._n
	_childUI = _frm.childUI

	
	--�����ֽ���
	_childUI["apartline_back"] = hUI.image:new({
		parent = _parent,
		model = "UI:panel_part_09",
		x = _w/2,
		y = -70,
		w = _w,
		h = 8,
	})

	--title
	_childUI["title"] = hUI.label:new({
		parent = _parent,
		size = 30,
		text = "",
		align = "MC",
		border = 1,
		x = _w/2 - 10,
		y = -38,
		font = hVar.FONTC,
		RGB = {230,180,50},
	})

	
	--title_botton �ײ���ʾ
	_childUI["title_botton"] = hUI.label:new({
		parent = _parent,
		size = 26,
		text = hVar.tab_string["UnlockAum_Tip"],
		align = "MC",
		border = 1,
		x = _w/2 - 10,
		y = -_h+34,
		font = hVar.FONTC,
		RGB = {255,0,0},
	})
	
	--��������ĵ�ͼicon����ͼ����
	
	local _createMapObj = function(map,x,y)
		_childUI["node_"..map] = hUI.node:new({
			parent = _parent,
			x = x,
			y = y,
		})
		_removeList[#_removeList+1] = "node_"..map
		
		--��ͼicon
		hUI.deleteUIObject(hUI.image:new({
			parent = _childUI["node_"..map].handle._n,
			model = hVar.MAP_INFO[map].icon,
		}))
		
		--����ͼ�ӱ߿������
		hUI.deleteUIObject(hUI.image:new({
			parent = _childUI["node_"..map].handle._n,
			model = "UI:level_back",
		}))
		hUI.deleteUIObject(hUI.label:new({
			parent = _childUI["node_"..map].handle._n,
			y = 44,
			font = hVar.FONTC,
			text = hVar.MAP_INFO[map].name,
			size = 23,
			align = "MC",
			border = 1,
			RGB = {230,180,50},
		}))
			
		--��������˵�ͼ�Ѷ�����
		local diffMap = ""
		diffMap = hVar.MAP_INFO[map].diff
			
		if type(diffMap) == "number" then
			for k = 1, diffMap do
				hUI.deleteUIObject(hUI.image:new({
					parent = _childUI["node_"..map].handle._n,
					model = "UI:HERO_STAR",
					align = "LT",
					x = 49,
					y = 24 - (k-1) * 15.5
				}))
			end
		end
	end
	
	--����һ��2��3�еĵ�ͼ ��ʽ
	local _createFrm = function(mapname)
		for i = 1,#hVar.UnlockAumMapList[mapname] do
			local map = hVar.UnlockAumMapList[mapname][i]
			local x,y = 120 + ((i-1)%3)*210,-164 - (math.floor((i-1)/3))*158
			_createMapObj(map,x,y)
		end
	end

	hApi.IsMapFirstFinishWithUnlock = function(oWorld)
		if oWorld~=nil then
			local mapName = oWorld.data.map
			if hVar.UnlockAumMapList[mapName] and LuaGetPlayerMapAchi(mapName,hVar.ACHIEVEMENT_TYPE.LEVEL)==1 then
				return hVar.RESULT_SUCESS
			end
		end
		return hVar.RESULT_FAIL
	end
	
	--�򿪵�ǰ�����Ƿ��н�����ͼ��Ϣ����ʾ���
	hGlobal.event:listen("LocalEvent_ShowAmuLockFrm","showthisfrm",function(pExitFunc)
		local oWorld = hGlobal.WORLD.LastWorldMap
		if oWorld~=nil then
			local mapName = oWorld.data.map
			if hVar.UnlockAumMapList[mapName] then
				_CODE_OnExit = pExitFunc
				_childUI["title"]:setText(hVar.tab_string["AmuLock"]..hVar.tab_string["["]..hVar.tab_string[hVar.UnlockAumMapList[mapName][0]]..hVar.tab_string["]"])
				_createFrm(mapName)
				_frm:show(1)
				_frm:active()
				return
			end
		end
		if type(_CODE_OnExit)=="function" then
			_CODE_OnExit()
		end
	end)
end