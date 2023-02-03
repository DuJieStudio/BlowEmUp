hGlobal.UI.InitLoadingEffectFrm = function(mode)
	local tInitEventName = {"localEvent_ShowLoadingEffectFrm", "__ShowLoadingEffectFrm",}
	if (mode ~= "include") then
		return tInitEventName
	end

	local CODE_CreateEffect = hApi.DoNothing
	local CODE_ClearNode = hApi.DoNothing

	hGlobal.UI.LoadingEffectFrm = hUI.frame:new({
		x = 0,
		y = 0,
		w = hVar.SCREEN.w,
		h = hVar.SCREEN.h,
		show = 0,
		dragable = 2,
		buttononly = 1,
		autoactive = 0,
		border = 0,
	})

	CODE_ClearNode = function()
		local _frm = hGlobal.UI.LoadingEffectFrm
		if _frm then
			for i = 1,2 do
				local node = _frm.childUI["node"..i]
				if node then
					local n = node.handle._nBlink
					if n then
						xlGroundEffect_Remove(n)
						node.handle._nBlink = nil
					end
					hApi.safeRemoveT(_frm.childUI,"node"..i)
				end
			end
		end
	end

	CODE_CreateEffect = function()
		local _frm = hGlobal.UI.LoadingEffectFrm
		if _frm then
			local posList  = {
				{60,-162},
				{267,-132},
				scale = 1.8
			}
			if hVar.SCREEN.w == 960 and hVar.SCREEN.h == 640 then
				posList  = {
					{-30,-134},
					{101,-106},
					scale = {1.3,1.46},
				}
			elseif hVar.SCREEN.w == 1560 and hVar.SCREEN.h == 720 then
				posList  = {
					{-50,-184},
					{165,-152},
					scale = 2
				}
			elseif hVar.SCREEN.w == 1136 and hVar.SCREEN.h == 640 then
				posList  = {
					{55,-144},
					{239,-117},
					scale = 1.7
				}
			elseif hVar.SCREEN.w == 1024 and hVar.SCREEN.h == 768 then
				posList  = {
					{218,-159},
					{432,-128},
					scale = 2
				}
			end
			for i = 1,#posList do
				_frm.childUI["node"..i] = hUI.node:new({
					parent = _frm.handle._n,
					x = hVar.SCREEN.w/2 + posList[i][1],
					y = hVar.SCREEN.h/2 + posList[i][2],
				})
				local node = _frm.childUI["node"..i]
				local pBlink = xlAddGroundEffect(0,-1,0,0,600/1000,0.7,255,255,255,1)
				node.handle._nBlink = pBlink
				pBlink:getParent():removeChild(pBlink,false)
				if type(posList.scale) == "number" then
					pBlink:setScale(posList.scale)
				elseif type(posList.scale) == "table" then
					pBlink:setScaleX(posList.scale[1])
					pBlink:setScaleX(posList.scale[2])
				end
				node.handle._n:addChild(pBlink)
			end
		end
	end

	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(show)
		local _frm = hGlobal.UI.LoadingEffectFrm
		if _frm then
			CODE_ClearNode()
			if show == 1 then
				--CODE_CreateEffect()
				_frm:show(1)
				_frm:active()
			else
				_frm:show(0)
			end
		end
	end)
end