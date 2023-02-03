MoveEquipManager = {}
MoveEquipManager._Pos1 = nil
MoveEquipManager._Pos2 = nil

MoveEquipManager.RecordPos1 = function(tPos)
	MoveEquipManager._Pos1 = tPos
end

MoveEquipManager.RecordPos2 = function(tPos)
	MoveEquipManager._Pos2 = tPos
end

MoveEquipManager.GetPos1 = function()
	return MoveEquipManager._Pos1
end

MoveEquipManager.GetPos2 = function()
	return MoveEquipManager._Pos2
end

MoveEquipManager.ResetData = function()
	MoveEquipManager._Pos1 = nil
	MoveEquipManager._Pos2 = nil
end

MoveEquipManager.MoveEquip = function()
	LuaMoveEquip(MoveEquipManager._Pos1,MoveEquipManager._Pos2)
	MoveEquipManager.ResetData()
	hGlobal.event:event("localEvent_CloseChariotItemFrm")
	hGlobal.event:event("LocalEvent_UpdateChariotEquipFrm")
	--上传存档
	local keyList = {"card","material"}
	LuaSavePlayerData_Android_Upload(keyList, "更换装备")
	LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
end

MoveEquipManager.DeleteEquip = function(uid)
	local pos,oEquip = LuaFindEquipByUniqueId(uid)
	if type(oEquip) == "table" then
		local itemid = oEquip[1]
		local tabI = hVar.tab_item[itemid]
		if tabI then
			local lv = tabI.itemLv
			print("lv",lv,itemid)
			local mats = hVar.DeleteEquipMat[lv]
			if type(mats) == "table" then
				if mats.score then
					local addscore = 0
					if type(mats.score) == "table" then
						addscore = hApi.random(mats.score[1],mats.score[2])
					elseif type(mats.score) == "number" then
						addscore = mats.score
					end
--					if addscore > 0 then
--						LuaAddPlayerScore(tonumber(addscore))
--						--hGlobal.event:event("LocalEvent_RefreshCurGameScore")
--						hGlobal.event:event("LocalEvent_RefreshScoreAction",1)
--						local strText = "x " .. tostring(addscore)
--						local offW = #strText * 12 - 5
--						local showX = hVar.SCREEN.w / 2
--						local showY = hVar.SCREEN.h / 2
--						hUI.floatNumber:new({
--							x = showX + offW,
--							y = showY,
--							align = "LC",
--							text = strText,
--							lifetime = 1000,
--							fadeout = -550,
--							moveY = 32,
--							font = "numBlue",
--							size = 24,
--						})
--
--						hUI.floatNumber:new({
--							font = "numGreen",
--							text = "",
--							size = 16,
--							x = showX - 5,
--							y = showY,
--							align = "LC",
--							icon = "misc/skillup/mu_coin.png",
--							iconWH = 36,
--							lifetime = 1000,
--							fadeout = -550,
--							moveY = 32,
--						})
--					end
				end
			end
		end
		LuaDeleteEquip(uid)
		LuaRecordEquipPosInfo(uid)
		local keyList = {"bag","material"}
		LuaSavePlayerData_Android_Upload(keyList, "分解装备")
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		hGlobal.event:event("LocalEvent_UpdateChariotEquipFrm")
		hGlobal.event:event("localEvent_UpdateChariotItemFrm")
	end
end