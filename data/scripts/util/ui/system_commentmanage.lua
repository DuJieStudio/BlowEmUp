--获取弹幕 类型id的条件设定
--对应unlock_manage.lua文件中的_unlock_type表
local _tBarrage_TypeIdCondition = {
	[hVar.CommentTargetTypeDefine.DRAGON] = {
		[1] = -1,		--无条件
		[2] = "entertainmentarea",	--和娱乐图地区一样
	},
}

--获取评论 类型id的配置表
local _tComment_TypeIdConfig = {
	[hVar.CommentTargetTypeDefine.CAMPAIGN] = {
		["world/dlc_yxys_spider"] = 1001,	--机械蜘蛛地图
		["world/dlc_yxys_airship"] = 1002,	--飞机地图
		["world/dlc_yxys_zerg"] = 1003,		--虫族地图
		["world/dlc_bio_airship"] = 1004,	--生化战役地图
		["world/dlc_yxys_mechanics"] = 1005,	--机械战舰地图
		["world/dlc_yxys_plate"] = 1006,	--飞碟地图
	},
	[hVar.CommentTargetTypeDefine.PET] = {
		[13043] = 1,
		[13041] = 2,
		[13042] = 3,
		[13044] = 4,
	},
}

local _tReadyComment = {
	[hVar.CommentTargetTypeDefine.TANKTALENT] = 1,
	[hVar.CommentTargetTypeDefine.TANKAVATER] = 1,
	[hVar.CommentTargetTypeDefine.REFINERY] = 1,
	[hVar.CommentTargetTypeDefine.PIECES] = 1,
	[hVar.CommentTargetTypeDefine.WEAPON_ALL] = 1,
	[hVar.CommentTargetTypeDefine.MONTH_CARD] = 1,
}

CommentManage = {}
CommentManage.Init = function(nCommentType,nBarrageType)
	CommentManage.InitData(nCommentType,nBarrageType)
	CommentManage.AddEvent()
end

CommentManage.InitData = function(nCommentType,nBarrageType)
	CommentManage.data = {}
	CommentManage.barragecache = {}
	CommentManage.cache = {}
	CommentManage.owncache = {}
	CommentManage.likecache = {}
	CommentManage.data._nCommentType = nCommentType
	CommentManage.data._nBarrageType = nBarrageType
	CommentManage.data._nBarrageTypeId = CommentManage.GetBarrageTypeId()
	CommentManage.data.CommentInfo = {}
	CommentManage.data.CommentInfo[nCommentType] = {}
end

CommentManage.InitLoseData = function(nCommentType)
	if CommentManage.data == nil then
		CommentManage.data = {}
	end
	if CommentManage.barragecache == nil then
		CommentManage.barragecache = {}
	end
	if CommentManage.cache == nil then
		CommentManage.cache = {}
	end
	if CommentManage.owncache == nil then
		CommentManage.owncache = {}
	end
	if CommentManage.likecache == nil then
		CommentManage.likecache = {}
	end
	if CommentManage.data.CommentInfo == nil then
		CommentManage.data.CommentInfo = {}
	end
	if CommentManage.data.CommentInfo[nCommentType] == nil then
		CommentManage.data.CommentInfo[nCommentType] = {}
	end
end

CommentManage.GetCommentTypeId = function(nCommentType,tParam)
	local id = 1
	if nCommentType == hVar.CommentTargetTypeDefine.CAMPAIGN then
		local config = _tComment_TypeIdConfig[nCommentType]
		if type(config) == "table" then
			local map = tParam[1]
			if type(config[map]) == "number" then
				id = config[map]
			end
		end
	elseif nCommentType == hVar.CommentTargetTypeDefine.STAGE then
		if type(tParam) == "table" then
			local mapname = tParam[1]
			local mapInfo = hVar.MAP_INFO[mapname]
			if type(mapInfo) == "table" then
				local uid = mapInfo.uniqueID
				id = 10000 + uid
			end
		end
	elseif nCommentType == hVar.CommentTargetTypeDefine.VIP then
		if type(tParam) == "table" then
			id = tParam[1]
		end
	elseif nCommentType == hVar.CommentTargetTypeDefine.PET then
		local config = _tComment_TypeIdConfig[nCommentType]
		if type(config) == "table" then
			local petid = tParam[1]
			if type(config[petid]) == "number" then
				id = config[petid]
			end
		end
	end
	return id
end

CommentManage.GetBarrageTypeId = function(nBarrageType)
	local id = 1
	local tCondition = _tBarrage_TypeIdCondition[nBarrageType]
	if type(tCondition) == "table" then
		for i = 1,#tCondition do
			local conditionname = tCondition[i]
			if type(conditionname) == "string" then
				local unlocktactisc = hApi.GetUnlockStateByName(conditionname)
				if unlocktactisc ~= 1 then
					break
				end
				id = i
			end
		end
	end
	return id
end

CommentManage.GetCommentInfo = function(nCommentType,nCommentTypeId)
	local tInfo = {}
	if CommentManage.data and CommentManage.data.CommentInfo and CommentManage.data.CommentInfo[nCommentType] and CommentManage.data.CommentInfo[nCommentType][nCommentTypeId] then
		tInfo = CommentManage.data.CommentInfo[nCommentType][nCommentTypeId]
	end
	return tInfo
end

CommentManage.RequireCommentData = function(nCommentType,nCommentTypeId,nCommentStartIdx,nShowMode)
	local offnum = 0
	if CommentManage.cache and CommentManage.cache[nCommentType] then
		local tCache = CommentManage.cache[nCommentType][nCommentTypeId]
		if type(tCache) == "table" then
			if tCache.tShowIdx and tCache.tShowIdx[nShowMode] then
				if tCache.tShowIdx[nShowMode][nCommentStartIdx + 1] then
					--有缓存
					return
				end
				offnum = tCache.tShowIdx[nShowMode].repeatnum or 0
			end
		end
	end
	local realstartIdx = nCommentStartIdx + offnum
	SendCmdFunc["comment_system_look_comment"](nCommentType,nCommentTypeId,nCommentStartIdx,nShowMode)
end

CommentManage.RequireSubCommentData = function(nCommentType,nCommentTypeId,nCommentId,nCommentStartIdx)
	--print("CommentManage.RequireSubCommentData",nCommentType,nCommentTypeId,nCommentId,nCommentStartIdx)
	local nGetSubOnce = 18
	if CommentManage.cache and CommentManage.cache[nCommentType] then
		local tCache = CommentManage.cache[nCommentType][nCommentTypeId]
		if type(tCache) == "table" then
			if tCache.tSubShowIdx[nCommentId] then
				--print("aaaa")
				local count = #tCache.tSubShowIdx[nCommentId]
				--顺序排序断了 且并无次数据 
				--if count < nCommentStartIdx and tCache.tSubShowIdx[nCommentId][nCommentStartIdx] == nil then
					local maxI = math.floor((tCache.Data[nCommentId].subTotal-1) / nGetSubOnce) + 1
					local realStartIdx = 0
					for i = 1,maxI do
						if nCommentStartIdx >= (i-1) * nGetSubOnce and nCommentStartIdx < i * nGetSubOnce then
							realStartIdx = (i-1) * nGetSubOnce
						end
					end
					realStartIdx = realStartIdx + (tCache.Data[nCommentId].offnum or 0)
					print(nCommentId,nCommentStartIdx,realStartIdx)
					SendCmdFunc["comment_system_look_comment"](hVar.CommentTargetTypeDefine.COMMENT,nCommentId,realStartIdx,0,nGetSubOnce)
				--end
			end
		end
	end
end

CommentManage.GetBarrageCache = function(nBarrageType,nBarrageTypeId)
	if CommentManage.barragecache and CommentManage.barragecache[nBarrageType] then
		local tBarrageCache = CommentManage.barragecache[nBarrageType][nBarrageTypeId]
		return tBarrageCache
	end
end

CommentManage.GetCache = function(nCommentType,nCommentTypeId)
	if CommentManage.cache and CommentManage.cache[nCommentType] then
		local tCache = CommentManage.cache[nCommentType][nCommentTypeId]
		return tCache
	end
end

CommentManage.GetCommentCache = function(nCommentType,nCommentTypeId,nId)
	local tData
	local tCache = CommentManage.cache[nCommentType][nCommentTypeId]
	if tCache and tCache.Data then
		tData = tCache.Data[nId]
	end
	return tData
end

CommentManage.ReceiveSubCommentData = function(tSubCommentData)
	--table_print(tSubCommentData)
	if type(tSubCommentData) == "table" then
		local nCommentId = tSubCommentData.typeID
		local nSubCommentCount = tSubCommentData.commentCount
		local nStartIdx = tSubCommentData.pageIndex
		local tData = tSubCommentData.lookData

		local t = CommentManage.cache.CommentGuide[nCommentId]
		local nMainCommentType,nMainCommentTypeId = unpack(t)
		local tCache = CommentManage.GetCache(nMainCommentType,nMainCommentTypeId)

		local oldSubT = tCache.Data[nCommentId].subTotal
		local oldSubC = tCache.Data[nCommentId].subCount

		local count = nStartIdx
		if oldSubT ~= nSubCommentCount then
			count = count + nSubCommentCount - oldSubT
			tCache.Data[nCommentId].offnum = nSubCommentCount - oldSubT + (tCache.Data[nCommentId].offnum or 0)
			tCache.Data[nCommentId].subTotal = nSubCommentCount
		end

		for i = 1,#tData do
			local t = tData[i]
			local subCommentID,tSubInfo = CommentManage.AnalyzeComment(t)

			if tCache.Data[subCommentID] == nil then
				tCache.Data[nCommentId].subCount = tCache.Data[nCommentId].subCount + 1
			end
			
			--存入子评论缓存
			count = count + 1
			tCache.tSubShowIdx[nCommentId][count] = subCommentID
			tCache.Data[subCommentID] = tSubInfo
		end

		hGlobal.event:event("LocalEvent_UpdateSubComment",nCommentId,nStartIdx,tCache.Data[nCommentId].subCount)
	end
end

CommentManage.ReceiveCommentData = function(tCommentData)
	if type(tCommentData) == "table" then
		--table_print(tCommentData)
		local nCommentType = tCommentData.commentType
		local nCommentTypeId = tCommentData.typeID
		local nCommentCount = tCommentData.commentCount
		local nStartIdx = tCommentData.pageIndex
		local nOrderType = tCommentData.orderType
		local tData = tCommentData.lookData
		if CommentManage.cache[nCommentType] == nil then
			CommentManage.cache[nCommentType] = {}
		end
		if CommentManage.cache[nCommentType][nCommentTypeId] == nil then
			CommentManage.cache[nCommentType][nCommentTypeId] = {}
		end
		if CommentManage.cache.CommentGuide == nil then
			CommentManage.cache.CommentGuide = {}
		end
		local tCache = CommentManage.cache[nCommentType][nCommentTypeId]
		tCache.totalCommentNum = nCommentCount
		tCache.curOrderType = nOrderType
		if tCache.Data == nil then
			tCache.Data = {}
		end
		if tCache.tShowIdx == nil then
			tCache.tShowIdx = {}
		end
		if tCache.tSubShowIdx == nil then
			tCache.tSubShowIdx = {}
		end
		if tCache.tShowIdx[nOrderType] == nil then
			tCache.tShowIdx[nOrderType] = {}
		end
		--获取数据时有个问题  如果获取的时候有人发送了几条新评论 那么从上一次的节点获取接下来的数据  可能就会出现重复
		--为了避免这种情况  就需要每次都对showIdx  进行一次排重 并且记录下排重数 以便后续获取正常
		local tShow = {}
		for i = 1,#tCache.tShowIdx[nOrderType] do
			local commentID = tCache.tShowIdx[nOrderType][i]
			tShow[commentID] = i
		end
		local _index = 0
		for i = 1,#tData do
			local t = tData[i]
			local commentID,tInfo = CommentManage.AnalyzeComment(t)
			if commentID and commentID > 0 then
				if tShow[commentID] == nil then
					--存入缓存
					_index = _index + 1
					local realIdx = nStartIdx + _index
					tCache.tShowIdx[nOrderType][realIdx] = commentID
					tCache.Data[commentID] = tInfo
					CommentManage.cache.CommentGuide[commentID] = {nCommentType,nCommentTypeId}
				else
					--记录重复数 以便下次获取时跳过
					tCache.tShowIdx[nOrderType].repeatnum = (tCache.tShowIdx[nOrderType].repeatnum or 0) + 1
					--根据排序方式看情况进行优化
				end
			end

			if tCache.tSubShowIdx[commentID] == nil then
				tCache.tSubShowIdx[commentID] = {}
			end
			if t.subCount > 0 and type(t.subComment) == "table" then
				
				local count = #tCache.tSubShowIdx[commentID]
				local randlist = {}
				for j = 1,#t.subComment do
					local subCommentID,tSubInfo = CommentManage.AnalyzeComment(t.subComment[j])
					--存入子评论缓存
					count = count + 1
					tCache.tSubShowIdx[commentID][count] = subCommentID
					tCache.Data[subCommentID] = tSubInfo
					randlist[#randlist + 1] = {subCommentID,tSubInfo}
				end
				--[[
				local randnum = 16
				for j = count + 1,randnum do
					count = count + 1
					local rand = math.random(1,#randlist)
					local subCommentID,tSubInfo = unpack(randlist[rand])
					tCache.tSubShowIdx[commentID][count] = subCommentID
					tCache.Data[subCommentID] = tSubInfo
				end
				tCache.Data[commentID].subTotal = randnum
				tCache.Data[commentID].subCount = randnum
				--]]
			end
		end
		--local count = #tCache.tShowIdx[nOrderType]
		--for i = count + 1,100 do
			--local commentId = tCache.tShowIdx[nOrderType][math.random(1,count)]
			--tCache.tShowIdx[nOrderType][i] = commentId
		--end
		--print("CommentManage.cache.CommentGuide")
		--table_print(CommentManage.cache.CommentGuide)
		--print("tCache.tSubShowIdx")
		--table_print(tCache.tSubShowIdx)
		hGlobal.event:event("LocalEvent_UpdateCommentInfo")
	end
end

CommentManage.ReceiveBarrageData = function(nBarrageType,nBarrageTypeID,nBeginIndex,nDataCount,tLookData)
	if type(tLookData) == "table" then
		print("CommentManage.ReceiveBarrageData",nBarrageType,nBarrageTypeID,nBeginIndex,nDataCount)
		--table_print(tLookData)
		if CommentManage.barragecache[nBarrageType] == nil then
			CommentManage.barragecache[nBarrageType] = {}
		end
		if CommentManage.barragecache[nBarrageType][nBarrageTypeID] == nil then
			CommentManage.barragecache[nBarrageType][nBarrageTypeID] = {}
		end
		local tBarrageCache = CommentManage.barragecache[nBarrageType][nBarrageTypeID]
		tBarrageCache.lastIndex = math.max((nBeginIndex + nDataCount),(tBarrageCache.lastIndex or 0))
		if tBarrageCache.Data == nil then
			tBarrageCache.Data = {}
			tBarrageCache.totalnum = 0
		end
		if tBarrageCache.tShowIdx == nil then
			tBarrageCache.tShowIdx = {}
		end
		for i = 1,#tLookData do
			local tData = tLookData[i]
			local barrageID,tInfo = CommentManage.AnalyzeBarrage(tData)
			if barrageID > 0 and tBarrageCache.Data[barrageID] == nil then
				tBarrageCache.Data[barrageID] = tInfo
				tBarrageCache.totalnum = tBarrageCache.totalnum + 1
				tBarrageCache.tShowIdx[tBarrageCache.totalnum] = barrageID
			end
		end
		hGlobal.event:event("LocalEvent_UpdateBarrageInfo")
	end
end

local CommentType2String = {
	[1] = "tab_unit",
	[2] = "tab_tactics",
	[3] = "tab_chariottalent",
	--[4] 读取战车模型
	--[5] 读取tab_model
}

CommentManage.AnalyzeString = function(key,content)
	local isCommand = false
	local tInfo = nil
	local strType
	local keystr = hApi.Split(key,"##")
	local resultStrList = hApi.Split(content,"##")
	if #keystr > 0 and keystr[1] ~= "" then
		--table_print(keystr)
		isCommand = true
		--strType = string.gsub(resultStrList[1],"\r\n","")
		strType = keystr[1]
		if strType == "iconmode" then
--图标			iconmode##3##1003##1,0.8,1,2
--标题			iconmode##3##1003##2,20,1,2
--内容			iconmode##3##1003##3,20,1,2
			local itemType = tonumber(keystr[2])
			local itemID = tonumber(keystr[3])
			local tShowConfig = {}
			local IsSpeical = false
			for i = 4,#keystr do
				local configstr = keystr[i]
				print("keystr",i,configstr)
				local t = hApi.Split(configstr,",")
				local typeId = tonumber(t[1])
				local p1 = tonumber(t[2])
				local p2 = tonumber(t[3])
				local p3 = tonumber(t[4])
				if typeId == 1 then
					tShowConfig.tIcon = {
						scale = p1 or 1,
						x = p2 or 0,
						y = p3 or 0,
					}
				elseif typeId == 2 then
					tShowConfig.tTitle = {
						size = p1 or 24,
						x = p2 or 0,
						y = p3 or 0,
					}
				elseif typeId == 3 then
					tShowConfig.tContent = {
						size = p1 or 24,
						x = p2 or 0,
						y = p3 or 0,
					}
				end
				IsSpeical = true
			end

			local icon = nil
			if CommentType2String[itemType] and hVar[CommentType2String[itemType]] and hVar[CommentType2String[itemType]][itemID] then
				icon = hVar[CommentType2String[itemType]][itemID].icon
			end
			if itemType == 5 then
				if type(hVar.tab_model[itemID]) == "table" then
					icon = hVar.tab_model[itemID].name
				end
			end
			if #resultStrList > 1 then
				local name = resultStrList[1]
				local text = resultStrList[2]
				tInfo = {
					icon = icon,
					name = name,
					text = text,
				}
			else
				local text = resultStrList[1]
				tInfo = {
					icon = icon,
					name = "",
					text = text,
				}
			end
			if itemType == 4 then
				tInfo.model = {"tank_avater",itemID}
			end
			if IsSpeical then
				tInfo.showConfig = tShowConfig
				--table_print(tShowConfig)
			end
		end
	else
		local iconId = 1 -- commentData.icon
		local tRoleIcon = hVar.tab_roleicon[iconId]
		if (tRoleIcon == nil) then
			tRoleIcon = hVar.tab_roleicon[0]
		end
		icon = tRoleIcon.icon
		tInfo = {
			icon = icon,
		}
	end
	return isCommand,strType,tInfo
end

CommentManage.CacheOwnComment = function(sMode,tParam)
	if sMode == "addcomment" then
		if CommentManage.owncache["addcomment"] == nil then
			CommentManage.owncache["addcomment"] = {}
		end
		local count = #CommentManage.owncache["addcomment"]
		--local nCommentType,nCommentTypeId,message = unpack(tParam)
		CommentManage.owncache["addcomment"][count + 1] = tParam
	end
end

CommentManage.MockCommentInfo = function(commentID,message)
	local tInfo = {}
	tInfo.commentID = commentID
	tInfo.uid = xlPlayer_GetUID()
	tInfo.rid = luaGetplayerDataID()
	tInfo.subTotal = 0
	tInfo.subCount = 0
	tInfo.isLike = "0"
	tInfo.star = 0
	tInfo.updateDate = ""
	tInfo.icon = ""
	local tRoleIcon = hVar.tab_roleicon[1]
	if tRoleIcon then
		tInfo.icon = tRoleIcon.icon
	end
	tInfo.name = ""
	local playerInfo = LuaGetPlayerByName(g_curPlayerName)	
	if playerInfo and playerInfo.showName and playerInfo.showName ~= "" then
		tInfo.name = playerInfo.showName
	end
	tInfo.str = message
	return tInfo
end

CommentManage.GetOwnComment = function(sMode,tParam)
	print("CommentManage.GetOwnComment")
	local bFlag = false
	local tInfo
	if sMode == "addcomment" then
		local commentType,commentTypeID,commentID = unpack(tParam)
		local tCache = CommentManage.owncache[sMode]
		if tCache then
			--table_print(tParam)
			--table_print(tCache)
			for i = #tCache,1,-1 do
				local t = tCache[i]
				local nCommentType,nCommentTypeId,message = unpack(t)
				if nCommentType == commentType and nCommentTypeId == commentTypeID then
					bFlag = true
					tInfo = CommentManage.MockCommentInfo(commentID,message)
					break
				end
			end
		end
	end
	return bFlag,tInfo
end

CommentManage.AnalyzeComment = function(tData)
	local commentID = 0
	local tInfo = {}
	if type(tData) == "table" then
		commentID = tData.commentID
		tInfo.commentID = tData.commentID
		tInfo.uid = tData.uid
		tInfo.rid = tData.rid
		tInfo.subTotal = tData.subTotal	--子评论总数
		tInfo.subCount = tData.subCount
		tInfo.isLike = tData.isLike
		tInfo.star = tData.star
		tInfo.updateDate = tData.updateDate
		local isCommand,strType,tAnalyseInfo = CommentManage.AnalyzeString(tData.key,tData.content)
		if isCommand then
			--if strType == "iconmode" then
				if tAnalyseInfo then
					tInfo.name = tAnalyseInfo.name
					tInfo.str = tAnalyseInfo.text
					tInfo.icon = tAnalyseInfo.icon
					tInfo.showConfig = tAnalyseInfo.showConfig
					tInfo.model = tAnalyseInfo.model
				end
			--end
		else
			tInfo.name = tData.name
			tInfo.str = tData.content
			if tAnalyseInfo then
				tInfo.icon = tAnalyseInfo.icon
			end
		end
	end
	return commentID,tInfo
end

CommentManage.AnalyzeBarrage = function(tData)
	local barrageID = 0
	local tInfo = {}
	if type(tData) == "table" then
		--table_print(tData)
		barrageID = tData.commentID
		tInfo.barrageID = tData.commentID
		tInfo.uid = tData.uid
		tInfo.rid = tData.rid
		local isCommand,strType,tAnalyseInfo = CommentManage.AnalyzeString(tData.key,tData.content)
		--print("isCommand,strType",isCommand,strType)
		--table_print(tAnalyseInfo)
		if isCommand then
			--if strType == "iconmode" then
				if tAnalyseInfo then
					tInfo.name = tAnalyseInfo.name
					tInfo.str = tAnalyseInfo.text
					tInfo.icon = tAnalyseInfo.icon
				end
			--end
		else
			tInfo.name = tData.name
			tInfo.str = tData.content
			if tAnalyseInfo then
				tInfo.icon = tAnalyseInfo.icon
			end
		end
	end
	return barrageID,tInfo
end

CommentManage.AddEvent = function()
	hGlobal.event:listen("LocalEvent_UpdateCommentTitle","__CommentManage",CommentManage.UpdateCommentTitle)
	hGlobal.event:listen("LocalEvent_SwitchBarrageShow","__CommentManage",CommentManage.SwitchBarrageShow)
	hGlobal.event:listen("LocalEvent_DoCommentProcess","__CommentManage",CommentManage.ShowComment)
	hGlobal.event:listen("LocalEvent_SetCommentId","__CommentManage",CommentManage.SetCommentId)
	hGlobal.event:listen("LocalEvent_HideBarrage","__CommentManage",CommentManage.HideBarrage)
	hGlobal.event:listen("LocalEvent_RecoverBarrage","__CommentManage",CommentManage.RecoverBarrage)
	hGlobal.event:listen("localEvent_ReceiveBarrageData","__CommentManage",CommentManage.ReceiveBarrageData)
	hGlobal.event:listen("localEvent_ReceiveCommentData","__CommentManage",CommentManage.ReceiveCommentData)
	hGlobal.event:listen("localEvent_ReceiveSubCommentData","__CommentManage",CommentManage.ReceiveSubCommentData)
	hGlobal.event:listen("localEvent_Like_Comment_Ret","__CommentManage",CommentManage.LikeCommentRet)
	hGlobal.event:listen("localEvent_Add_Comment_Ret","__CommentManage",CommentManage.AddCommentRet)
	hGlobal.event:listen("LocalEvent_SetCommentShieldBoardEnable","__CommentManage",CommentManage.SetCommentShieldBoardEnable)
end

CommentManage.IsSpecialCommentTitle = function(commentType,commentTypeID)
	local bFlag = false
	local tConfig = {}
	if commentType == hVar.CommentTargetTypeDefine.STAGE then
		local oWorld = hGlobal.WORLD.LastWorldMap
		print("CommentManage.IsSpecialCommentTitle",oWorld.data.map)
		if oWorld.data.map then
			local tInfo = hVar.MAP_INFO[oWorld.data.map]
			if type(tInfo) == "table" then
				bFlag = true
				tConfig.Icon = tInfo.icon
				tConfig.IconTitle = tInfo.icon_title
			end
		end
	end
	
	return bFlag,tConfig
end

CommentManage.UpdateCommentTitle = function(sTitle,nMode,nCommentType,nCommentTypeId)
	--缓存数据
	--print(sTitle,nMode,nCommentType,nCommentTypeId)
	if CommentManage.data.CommentInfo and CommentManage.data.CommentInfo[nCommentType] then
		CommentManage.data.CommentInfo[nCommentType][nCommentTypeId] = {sTitle,nMode}
	end
end

CommentManage.ShowComment = function(tParam)
	local _nCommentType = CommentManage.data._nCommentType
	local _nCommentTypeId = 0
	local _nCommentStartIdx = 0
	if tParam then
		_nCommentTypeId = CommentManage.GetCommentTypeId(_nCommentType,tParam)
		CommentManage.data._nCommentTypeId = _nCommentTypeId
	else
		_nCommentTypeId = CommentManage.data._nCommentTypeId
	end
	print("CommentManage.ShowComment",_nCommentType,_nCommentTypeId)
	CommentManage.data._nCommentStartIdx = 0
	hGlobal.event:event("LocalEvent_HideBarrage")
	hGlobal.event:event("LocalEvent_OpenComment",_nCommentType,_nCommentTypeId)
	--判断缓存
	local tCache = CommentManage.GetCache(_nCommentType,_nCommentTypeId)
	if tCache then
		hGlobal.event:event("LocalEvent_UpdateCommentInfo")
		return
	end
	hGlobal.event:event("LocalEvent_Comment_Open","",_nCommentType,_nCommentTypeId,_nCommentStartIdx)
end

CommentManage.SetCommentId = function(tParam)
	local _nCommentType = CommentManage.data._nCommentType
	local _nCommentTypeId = CommentManage.GetCommentTypeId(_nCommentType,tParam)
	CommentManage.data._nCommentTypeId = _nCommentTypeId
end

CommentManage.SwitchBarrageShow = function()
	if g_closedanmu == 0 then
		g_closedanmu = 1
	else
		g_closedanmu = 0
	end
	hApi.SwitchDanmu(g_closedanmu)
	if g_closedanmu == 0 then
--		if hGlobal.UI.BarrageFrm == nil then
--			CommentManage.ShowBarrage()
--		else
--			hGlobal.event:event("LocalEvent_Barrage_Open")
--		end
		
		hGlobal.event:event("LocalEvent_RecoverBarrage")
	else
		hGlobal.event:event("LocalEvent_HideBarrage")
		--hGlobal.event:event("LocalEvent_Barrage_PausePlay")  --隐藏弹幕
	end
	hGlobal.event:event("LocalEvent_SetDanmuBtnState",nil,1)
end

CommentManage.HideBarrage = function()
	if g_closedanmu == 0 then
		hGlobal.event:event("LocalEvent_Barrage_Pause")  --隐藏弹幕
	end
end

CommentManage.RecoverBarrage = function()
	if g_closedanmu == 0 then
		if hGlobal.UI.BarrageFrm then
			hGlobal.event:event("LocalEvent_Barrage_Open")
		end
	end
end

CommentManage.DoLikeComment = function(nMode,nCommentid,tInfo)
	SendCmdFunc["comment_system_like_comment"](nCommentid)
	CommentManage.likecache[nCommentid] = {nMode,tInfo}
end

CommentManage.LikeCommentRet = function(ret,commentID,starCount)
	--print("CommentManage.LikeCommentRet",ret,commentID,starCount)
	if ret == "0" then
		local tlikecache = CommentManage.likecache[commentID]
		if type(tlikecache) == "table" and tlikecache[1] == 2 then
			local nCommentType,nCommentTypeId,nfstCommentID = unpack(tlikecache[2])
			local tInfo = CommentManage.GetCommentCache(nCommentType,nCommentTypeId,commentID)
			if tInfo then
				tInfo.star = starCount
				--table_print(tCache)
				hGlobal.event:event("LocalEvent_UpdateSubCommentStar",nCommentType,nCommentTypeId,nfstCommentID,commentID,starCount)
			end	
		else
			local t = CommentManage.cache.CommentGuide[commentID]
			if type(t) == "table" then
				local nCommentType,nCommentTypeId = unpack(t)
				print(nCommentType,nCommentTypeId)
				local tInfo = CommentManage.GetCommentCache(nCommentType,nCommentTypeId,commentID)
				if tInfo then
					tInfo.star = starCount
					--table_print(tCache)
					hGlobal.event:event("LocalEvent_UpdateCommentStar",nCommentType,nCommentTypeId,commentID,starCount)
				end	
			end
		end
	end
end

CommentManage.AddCommentRet = function(ret,commentID,commentType,commentTypeID)
	print("CommentManage.AddCommentRet")
	if ret == "0" then
		print(ret,commentID,commentType,commentTypeID)
		local bFlag,tInfo = CommentManage.GetOwnComment("addcomment",{commentType,commentTypeID,commentID})
		if bFlag then
			if commentType == hVar.CommentTargetTypeDefine.COMMENT then
				local t = CommentManage.cache.CommentGuide[commentTypeID]
				if type(t) == "table" then
					local nMainCommentType,nMainCommentTypeId = unpack(t)
					local tCache = CommentManage.GetCache(nMainCommentType,nMainCommentTypeId)
					if tCache then
						--print("tCache",commentID)
						--table_print(tInfo)
						tCache.Data[commentID] = tInfo
						--print(nMainCommentType,nMainCommentTypeId)
						--table_print(tCache.tSubShowIdx)

						table.insert(tCache.tSubShowIdx[commentTypeID],1,commentID)
						local tData = CommentManage.GetCommentCache(nMainCommentType,nMainCommentTypeId,commentTypeID)
						if tData then
							--table_print(tData)
							tData.subTotal = tData.subTotal + 1	--子评论总数
							tData.subCount = tData.subCount + 1
						end
						--刷新子评论
						hGlobal.event:event("LocalEvent_BeforeAddSubCommentRet",commentTypeID)
					end
				end
			else
				local tCache = CommentManage.GetCache(commentType,commentTypeID)
				if tCache then
					local nOrderType = tCache.curOrderType
					if nOrderType == 0 then
						tCache.totalCommentNum = tCache.totalCommentNum + 1
						table.insert(tCache.tShowIdx[nOrderType],1,commentID)
						tCache.Data[commentID] = tInfo
						tCache.tSubShowIdx[commentID] = {}
						CommentManage.cache.CommentGuide[commentID] = {commentType,commentTypeID}
						--刷新主评论
						hGlobal.event:event("LocalEvent_BeforeAddCommentRet")
					end
				else
					if CommentManage.cache[commentType] == nil then
						CommentManage.cache[commentType] = {}
					end
					if CommentManage.cache[commentType][commentTypeID] == nil then
						CommentManage.cache[commentType][commentTypeID] = {}
					end
					if CommentManage.cache.CommentGuide == nil then
						CommentManage.cache.CommentGuide = {}
					end
					local tCache = CommentManage.cache[commentType][commentTypeID]
					tCache.totalCommentNum = 1
					tCache.curOrderType = 0
					if tCache.Data == nil then
						tCache.Data = {}
					end
					if tCache.tShowIdx == nil then
						tCache.tShowIdx = {}
					end
					if tCache.tSubShowIdx == nil then
						tCache.tSubShowIdx = {}
					end
					if tCache.tShowIdx[0] == nil then
						tCache.tShowIdx[0] = {}
					end
					tCache.tShowIdx[0][1] = commentID
					tCache.Data[commentID] = tInfo
					tCache.tSubShowIdx[commentID] = {}
					CommentManage.cache.CommentGuide[commentID] = {commentType,commentTypeID}
					--刷新主评论
					hGlobal.event:event("LocalEvent_BeforeAddCommentRet")
				end
			end
		end
	end
end

CommentManage.SetCommentShieldBoardEnable = function(bFlag)
	CommentManage.data.EnableShieldBoard = bFlag
end

CommentManage.ClearEvent = function()
	hGlobal.event:listen("LocalEvent_UpdateCommentTitle","__CommentManage",nil)
	hGlobal.event:listen("LocalEvent_SwitchBarrageShow","__CommentManage",nil)
	hGlobal.event:listen("LocalEvent_DoCommentProcess","__CommentManage",nil)
	hGlobal.event:listen("LocalEvent_SetCommentId","__CommentManage",nil)
	hGlobal.event:listen("LocalEvent_HideBarrage","__CommentManage",nil)
	hGlobal.event:listen("LocalEvent_RecoverBarrage","__CommentManage",nil)
	hGlobal.event:listen("localEvent_ReceiveCommentData","__CommentManage",nil)
	hGlobal.event:listen("localEvent_ReceiveSubCommentData","__CommentManage",nil)
	hGlobal.event:listen("localEvent_Like_Comment_Ret","__CommentManage",nil)
	hGlobal.event:listen("localEvent_Add_Comment_Ret","__CommentManage",nil)
	hGlobal.event:listen("LocalEvent_SetCommentShieldBoardEnable","__CommentManage",nil)
end

CommentManage.EnterArea = function(sAreaName)
	local nCommentType = 0
	local nBarrageType = 0
	if sAreaName == "tacticsarea" then
		--战术卡区域
		nCommentType = hVar.CommentTargetTypeDefine.TACTICS_ALL
		nBarrageType = hVar.CommentTargetTypeDefine.TACTICS_ALL
	elseif sAreaName == "petarea" then
		--宠物区域
		nCommentType = hVar.CommentTargetTypeDefine.PET
		--nBarrageType = hVar.CommentTargetTypeDefine.PET
	elseif sAreaName == "engineer" then
		--随机地图区域
		nCommentType = hVar.CommentTargetTypeDefine.MAZE
		nBarrageType = hVar.CommentTargetTypeDefine.ENGINEER
	elseif sAreaName == "blackdragonarea" then
		--黑龙区域
		nCommentType = hVar.CommentTargetTypeDefine.VIP
		nBarrageType = hVar.CommentTargetTypeDefine.DRAGON
	elseif sAreaName == "battlearea" then
		--战役地图区域
		nCommentType = hVar.CommentTargetTypeDefine.CAMPAIGN
		nBarrageType = hVar.CommentTargetTypeDefine.CAMPAIGN
	elseif sAreaName == "defencearea" then
		nCommentType = hVar.CommentTargetTypeDefine.DEFENCE
	else
		return
	end
	CommentManage.Init(nCommentType,nBarrageType)
	CommentManage.data.sAreaName = sAreaName
	CommentManage.StartShowBarrage()
	CommentManage.Preloading()
end

CommentManage.ReadyComment = function(nCommentType)
	if _tReadyComment[nCommentType] then
		if CommentManage.data == nil then
			CommentManage.data = {}
		end
		if CommentManage.data._nCommentType == nCommentType then
			return
		end
		CommentManage.data._nCommentType = nCommentType
		CommentManage.data._nCommentTypeId = 1
		CommentManage.InitLoseData(nCommentType)
		CommentManage.AddEvent()
		SendCmdFunc["comment_system_query_title"](nCommentType,1)
	end
end

CommentManage.LeaveArea = function(sAreaName)
	if CommentManage.data and CommentManage.data.sAreaName == sAreaName then
		print("CommentManage.LeaveArea",sAreaName)
		CommentManage.ClearEvent()
		CommentManage.ClearData()
		hGlobal.event:event("LocalEvent_SetDanmuBtnState",-1)
		hGlobal.event:event("LocalEvent_Barrage_Clean")
		hGlobal.event:event("LocalEvent_Comment_Clean")
	end
end

CommentManage.EnterBattle = function(oWorld)
	CommentManage.ClearEvent()
	CommentManage.ClearData()
	hGlobal.event:event("LocalEvent_Barrage_Clean")
	hGlobal.event:event("LocalEvent_Comment_Clean")
	if oWorld == nil then
		return
	end

	if oWorld.data.map == hVar.MainBase then
		return
	end

	local mapInfo = oWorld.data.tdMapInfo
	if (not mapInfo) then
		return
	end



	if (mapInfo.mapMode == hVar.MAP_TD_TYPE.NORMAL) or (mapInfo.mapMode == hVar.MAP_TD_TYPE.DIFFICULT) then
		print("CommentManage.EnterBattle",oWorld.data.map)
		local nCommentType = hVar.CommentTargetTypeDefine.STAGE
		local nBarrageType = hVar.CommentTargetTypeDefine.STAGE
		CommentManage.Init(nCommentType,nBarrageType)
		CommentManage.SetCommentId({oWorld.data.map})
		CommentManage.Preloading()

		--
	end
end

CommentManage.ClearData = function()
	CommentManage.data = {}
end

CommentManage.StartShowBarrage = function()
	hGlobal.event:event("LocalEvent_SetDanmuBtnState",1,1)
	CommentManage.data._nBarrageStartIdx = 0
	if g_closedanmu == 0 then
		CommentManage.ShowBarrage()
	end
end

CommentManage.ShowBarrage = function()
	local _nBarrageType = CommentManage.data._nBarrageType
	local _nBarrageTypeId = CommentManage.data._nBarrageTypeId
	local _startIndex = CommentManage.data._nBarrageStartIdx
	--hGlobal.event:event("LocalEvent_Barrage_Open",_nBarrageType,_nBarrageTypeId,_startIndex)
	if _nBarrageType > 0 then
		hGlobal.event:event("LocalEvent_OpenBarrage",_nBarrageType,_nBarrageTypeId)
		SendCmdFunc["comment_system_query_barrage"](_nBarrageType,_nBarrageTypeId,_startIndex)
	end
end

CommentManage.Preloading = function()
	--print("CommentManage.Preloading")
	local _nCommentType = CommentManage.data._nCommentType
	if _nCommentType == hVar.CommentTargetTypeDefine.TACTICS_ALL then
		SendCmdFunc["comment_system_query_title"](_nCommentType,1)
	elseif _nCommentType == hVar.CommentTargetTypeDefine.VIP then
		for i = 1,5 do
			SendCmdFunc["comment_system_query_title"](_nCommentType,i)
		end
	elseif _nCommentType == hVar.CommentTargetTypeDefine.MAZE then
		SendCmdFunc["comment_system_query_title"](_nCommentType,1)
	elseif _nCommentType == hVar.CommentTargetTypeDefine.CAMPAIGN then
		--预加载标题名 以及评论类型
		local config = _tComment_TypeIdConfig[_nCommentType]
		if type(config) == "table" then
			for mapname,id in pairs(config) do
				SendCmdFunc["comment_system_query_title"](_nCommentType,id)
			end
		end
	elseif _nCommentType == hVar.CommentTargetTypeDefine.PET then
		for i = 1,4 do
			SendCmdFunc["comment_system_query_title"](_nCommentType,i)
		end
	elseif _nCommentType == hVar.CommentTargetTypeDefine.DEFENCE then
		SendCmdFunc["comment_system_query_title"](_nCommentType,1)
	elseif _nCommentType == hVar.CommentTargetTypeDefine.STAGE then
		local _nCommentTypeId = CommentManage.data._nCommentTypeId or 0
		SendCmdFunc["comment_system_query_title"](_nCommentType,_nCommentTypeId)
	end
end