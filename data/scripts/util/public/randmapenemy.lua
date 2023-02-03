
--随机地图物件
--返回值: 区域id
---@param world table 战场地图<hClass.world>
---@param random_ObjectInfo table 战车随机地图房间avatarInfoId指定皮肤信息。randmaproom_config.lua -> hVar.RANDMAP_ROOM_AVATAR_INFO[avatarInfoId]
---@param random_RoomClass table 定义：units_list.random_RoomClass
---@param offsetX number 地图位置偏移X轴 -- TODO: 单位为像素？使用前几乎都需要"/PIX_SIZE"
---@param offsetY number 地图位置偏移Y轴 -- TODO: 单位为像素？使用前几乎都需要"/PIX_SIZE"
---@param regionPoint number Range[1~4]，小关序号
---@param avatarInfoId number Range[1~13]，战车随机地图房间各皮肤Id，与hVar.RANDMAP_ROOM_AVATAR_INFO关联
---@return number regionId区域ID，即小关序号
hApi.CreateRandomMap = function(world, random_ObjectInfo, random_RoomClass, offsetX, offsetY, regionPoint, avatarInfoId)
	--print("avatarInfoId = ", avatarInfoId)
	local d = world.data
	local randommapInfo = d.randommapInfo --随机地图信息
	
	-- 当前层的区域ID，即小关序号（如2-3的小关序号是3），与regionPoint等值
	local regionId = #randommapInfo + 1
	-- 战车区域生成点系数表 hVar.RANDMAP_REGION_POINT_MULTIPLY
	local tMultiply = hVar.RANDMAP_REGION_POINT_MULTIPLY[regionPoint]
	local width_rate = tMultiply.width_rate --宽度比例
	local height_rate = tMultiply.height_rate --高度比例
	local terminal = tMultiply.terminal --最后一关？
	local PIX_SIZE = 16 * 3 -- TODO: 什么作用？
	-- TODO: 为什么d.w和d.h要除以3乘以0.5
	RandomMap.EasyMap(d.w / 3 * width_rate, d.h / 3 * height_rate, random_RoomClass, os.time())
	-- 所有地图单位, 所有已生成房间(m_rRooms)
	local unitList, rooms = RandomMap.GetAllObject(random_ObjectInfo, PIX_SIZE, random_RoomClass, offsetX / PIX_SIZE, offsetY / PIX_SIZE)
	
	-- TODO: 为什么要这样拆分？
	--房间拆分: 将断头路拆分为 正方形的路和普通房间
	local rooms_new = {}
	for i = 1, #rooms, 1 do
		local tRegion = rooms[i]
		local strRoomType = tRegion.Roomtype --区域类型
		local roomPosX = tRegion.x + offsetX / PIX_SIZE
		local roomPosY = tRegion.y + offsetY / PIX_SIZE
		local roomWidth = tRegion.w
		local roomHeight = tRegion.h
		local tTerminalPos = tRegion.TerminalPos --终点坐标集
		
		if (strRoomType == "normal") or (strRoomType == "road") then --普通房间、通路、断头路
			-- 若该区域有终点，即断头路
			if tTerminalPos then
				--中心点
				local roomPosXM = (tRegion.x + tRegion.w) / 2
				local roomPosYM = (tRegion.y + tRegion.h) / 2
				
				--拆分
				if (roomWidth > roomHeight) then --横条矩形
					if (tTerminalPos[1].x <= roomPosXM) then --断头点在左侧
						--左拆分
						local tRegionL = {x = tRegion.x, y = tRegion.y, w = tRegion.h, h = tRegion.h, Roomtype = "road", TerminalPos = tRegion.TerminalPos,}
						local tRegionR = {x = tRegion.x + tRegion.h, y = tRegion.y, w = tRegion.w - tRegion.h, h = tRegion.h, Roomtype = tRegion.Roomtype, TerminalPos = nil,}
						-- TODO: 什么作用？
						tRegionL.xm = tRegion.x + tRegion.w/2 --定义相邻组（传送门需要）
						tRegionL.ym = tRegion.y + tRegion.h/2 --定义相邻组（传送门需要）
						rooms_new[#rooms_new+1] = tRegionL
						rooms_new[#rooms_new+1] = tRegionR
					else --断头点在右侧
						--右拆分
						local tRegionL = {x = tRegion.x, y = tRegion.y, w = tRegion.w - tRegion.h, h = tRegion.h, Roomtype = tRegion.Roomtype, TerminalPos = nil,}
						local tRegionR = {x = tRegion.x + tRegion.w - tRegion.h, y = tRegion.y, w = tRegion.h, h = tRegion.h, Roomtype = "road", TerminalPos = tRegion.TerminalPos,}
						tRegionR.xm = tRegion.x + tRegion.w/2 --定义相邻组（传送门需要）
						tRegionR.ym = tRegion.y + tRegion.h/2 --定义相邻组（传送门需要）
						rooms_new[#rooms_new+1] = tRegionL
						rooms_new[#rooms_new+1] = tRegionR
					end
				elseif (roomWidth < roomHeight) then --竖条矩形
					if (tTerminalPos[1].y <= roomPosYM) then --断头点在上侧
						--上拆分
						local tRegionU = {x = tRegion.x, y = tRegion.y, w = tRegion.w, h = tRegion.w, Roomtype = "road", TerminalPos = tRegion.TerminalPos,}
						local tRegionD = {x = tRegion.x, y = tRegion.y + tRegion.w, w = tRegion.w, h = tRegion.h - tRegion.w, Roomtype = tRegion.Roomtype, TerminalPos = nil,}
						tRegionU.xm = tRegion.x + tRegion.w/2 --定义相邻组（传送门需要）
						tRegionU.ym = tRegion.y + tRegion.h/2 --定义相邻组（传送门需要）
						rooms_new[#rooms_new+1] = tRegionU
						rooms_new[#rooms_new+1] = tRegionD
					else --断头点在下侧
						--下拆分
						local tRegionU = {x = tRegion.x, y = tRegion.y, w = tRegion.w, h = tRegion.h - tRegion.w, Roomtype = tRegion.Roomtype, TerminalPos = nil,}
						local tRegionD = {x = tRegion.x, y = tRegion.y + tRegion.h - tRegion.w, w = tRegion.w, h = tRegion.w, Roomtype = "road", TerminalPos = tRegion.TerminalPos,}
						tRegionD.xm = tRegion.x + tRegion.w/2 --定义相邻组（传送门需要）
						tRegionD.ym = tRegion.y + tRegion.h/2 --定义相邻组（传送门需要）
						rooms_new[#rooms_new+1] = tRegionU
						rooms_new[#rooms_new+1] = tRegionD
					end
				elseif (roomWidth == roomHeight) then --正方形
					rooms_new[#rooms_new+1] = tRegion
				end
			else
				rooms_new[#rooms_new+1] = tRegion
			end
		elseif (strRoomType == "boss") then --BOSS大房间
			rooms_new[#rooms_new+1] = tRegion
		end
	end
	
	--找到最右下角的区域
	--[[
	local MAX_PX = -math.huge
	local MAX_PY = -math.huge
	local MAX_PW = 0
	local MAX_PH = 0
	for _, RoomValue in pairs(rooms) do
		local PX = RoomValue.x + offsetX / PIX_SIZE
		local PY = RoomValue.y + offsetY / PIX_SIZE
		local PW = RoomValue.w
		local PH = RoomValue.h
		--print(PX, PY, PW, PH)
		
		if (PX > MAX_PX) and (PY > MAX_PY) then
			MAX_PX = PX
			MAX_PY = PY
			MAX_PW = PW
			MAX_PH = PH
		end
	end
	local max_px = MAX_PX * PIX_SIZE + MAX_PW / 2 * PIX_SIZE
	local max_py = MAX_PY * PIX_SIZE + MAX_PH / 2 * PIX_SIZE
	]]
	-- TODO: 为何命名为max？不是middle？
	-- TODO: d.sizeW和d.sizeH的单位是像素？
	local max_px = offsetX + d.sizeW / 2
	local max_py = offsetY + d.sizeH / 2
	
	--为地图刷上障碍
	-- TODO: 什么作用和效果？
	-- TODO: 为什么步长是24？正好是"PIX_SIZE = 16*3"的一半？游戏中"1Unit = 24Pixel"？
	for x = offsetX, max_px, 24 do
		for y = offsetY, max_py, 24 do
			-- TODO: API作用？
			xlScene_SetMapBlock(x/24, y/24, 1)
		end
	end
	--清除房间的障碍
	for _, RoomValue in pairs(rooms) do
		local PX = RoomValue.x + offsetX / PIX_SIZE
		local PY = RoomValue.y + offsetY / PIX_SIZE
		local PW = RoomValue.w
		local PH = RoomValue.h
		--print(PX, PY, PW, PH)
		
		-- 单位Unit转Pixel
		for x = PX*PIX_SIZE, (PX+PW-1)*PIX_SIZE, 24 do
			for y = PY*PIX_SIZE, (PY+PH-1)*PIX_SIZE, 24 do
				xlScene_SetMapBlock(x/24, y/24, 0)
			end
		end
	end
	
	--生成全部房间包围墙物件
	-- TODO: 需要明确world的数据结构
	local worldLayer = world.handle.worldLayer
	local wallimg = random_ObjectInfo.wallimg
	local xlobj_units = {}
	local xlobj_sprites = {} --墙体特效贴图集
	for i = 1, #unitList, 1 do
		local unitType, id, owner, worldX, worldY, facing, triggerID = unpack(unitList[i])
		local cha = hApi.addChaByID(world, owner, id, worldX, worldY, facing, nil, {editorID = id, indexOfCreate = i,})
		local nLv = 1
		local nStar = 1
		--god.data.worldY
		--local oUnit = world:addunit(id, owner, nil ,nil, facing, worldX, worldY, nil, nil, nLv, nStar)
		--oUnit.handle.s:setScale(0.01)
		--只是为了生成障碍
		xlobj_units[#xlobj_units+1] = cha
		
		--添加墙体特效
		local tEffect = nil
		for k, v in pairs(random_ObjectInfo) do
			if (type(v) == "table") then
				local objId = v.objId
				if (objId == id) then
					local effect = v.effect
					if (type(effect) == "table") then
						local imgFileName = wallimg
						local eff_x = effect.x
						local eff_y = effect.y
						local eff_w = effect.w
						local eff_h = effect.h
						local eff_offX = effect.offX
						local eff_offY = effect.offY
						local zOrder = v.zOrder or 0 --z值
						local texture = CCTextureCache:sharedTextureCache():textureForKey(imgFileName)
						if (not texture) then
							texture = CCTextureCache:sharedTextureCache():addImage(imgFileName)
							--print("加载" .. imgFileName .. "！")
						end
						local sprite = CCSprite:createWithTexture(texture, CCRectMake(eff_x, eff_y, eff_w, eff_h))
						sprite:setAnchorPoint(ccp(0.5, 0.5))
						local cha_x, cha_y  = xlCha_GetPos(cha)
						sprite:setPosition(ccp(cha_x + eff_offX, -(cha_y + eff_offY))) --修复在地图最上面看不到砖块图片了
						local zValue = math.max(30, 30 + (cha_y + eff_offY) + zOrder)
						worldLayer:addChild(sprite, zValue)
						xlobj_sprites[#xlobj_sprites+1] = sprite --墙体特效贴图集
					end
				end
			end
		end
	end
	
	--local tile_rooms = {}
	--local tile_room_count = 0
	
	--生成地图内铺地板的物件
	local tex_sprites = {} --地板贴图信息数组
	local ground = random_ObjectInfo.ground
	if ground then
		--local worldLayer = world.handle.worldLayer
		local imgFileName = wallimg
		local ground1 = ground[1]
		--local tex_x = ground1.x
		--local tex_y = ground1.y
		local tex_w = ground1.w
		local tex_h = ground1.h
		local texture = CCTextureCache:sharedTextureCache():textureForKey(imgFileName)
		if (not texture) then
			texture = CCTextureCache:sharedTextureCache():addImage(imgFileName)
			--print("加载" .. imgFileName .. "！")
		end
		--local tSize = texture:getContentSize()
		--地图内铺地板的物件
		-- TODO: 贴图边缘大小？
		local edge_x = 32 --单位：像素
		local edge_y = 42 --单位：像素
		local grid_width = (tex_w - edge_x * 2) / PIX_SIZE --单位：Unit
		local grid_height = (tex_h - edge_y * 2) / PIX_SIZE --单位：Unit
		local grid_offset_x = -PIX_SIZE
		local grid_offset_y = -PIX_SIZE - PIX_SIZE / 2
		for _, RoomValue in pairs(rooms) do
			-- 房间起始地图单位坐标
			local PX = RoomValue.x + offsetX / PIX_SIZE --单位：Unit
			local PY = RoomValue.y + offsetY / PIX_SIZE --单位：Unit
			local PW = RoomValue.w --单位：Unit
			local PH = RoomValue.h --单位：Unit
			--print(PX, PY, PW, PH)
			
			-- 边缘范围限制
			local RIGHT = (PX + PW) * PIX_SIZE - edge_x + edge_x / 2 --多加edge / 2。避免有空白
			local BOTTOM = (PY + PH) * PIX_SIZE - edge_y

			for dx = 1, PW, grid_width do
				for dy = 1, PH, grid_height do
					-- 格子范围，单位：像素，左x，上y，右x，下y
					local xl = PX * PIX_SIZE + dx * PIX_SIZE + grid_offset_x --左上角x坐标
					local yt = PY * PIX_SIZE + dy * PIX_SIZE + grid_offset_y --左上角y坐标
					local xr = xl + tex_w --右下角x坐标
					local yb = yt + tex_h --右下角y坐标
					
					if (xr > RIGHT) then
						xr = RIGHT
					end
					if (yb > BOTTOM) then
						yb = BOTTOM
					end
					if (xr > 0) and (yb > 0) then
						-- 格子宽高，单位：像素
						local tile_w = xr - xl
						local tile_h = yb - yt
						
						
						--print(0, 0, xr - xl, yb - yt)
						--随机索引
						--生成随机数
						local rand = math.random(1, 100)
						
						--计算结果区间
						local index = 0 --结果索引值
						local pivot = rand
						-- 随机地板ground配置
						for i = 1, #ground, 1 do
							if (pivot <= ground[i].probablity) then --找到了
								index = i
								if (index==3) then
									if (tile_w < 200) or (tile_h < 200) then
										index = 2
										xlLG("random_maze", "msgReplace Transparent Tile\n")
									end
								end
								break
							else
								pivot = pivot - ground[i].probablity
							end
						end
						
						local ground_i = ground[index]
						local tex_x = ground_i.x
						local tex_y = ground_i.y
						
						local sprite = CCSprite:createWithTexture(texture, CCRectMake(tex_x, tex_y, xr - xl, yb - yt))
						sprite:setAnchorPoint(ccp(0, 1))
						
						sprite:setPosition(ccp(xl, -yt))
						worldLayer:addChild(sprite, 20)
						
						tex_sprites[#tex_sprites+1] = {sprite = sprite, x = xl, y = yt, w = tile_w, h = tile_h, index = index,}
						
						--if (index ~= 3) then
						--	if (tile_w > 190) and (tile_h > 190) then
								--tile_room_count = tile_room_count + 1
								--tile_rooms[#tile_rooms+1] = {sprite = sprite, x = xl, y = yt, w = tile_w, h = tile_h, index = index,}
						--	end
						--end
						
					end
				end
			end
		end
	end
	
	--生成地面装饰物件贴图
	local render_sprites = {}
	local renders = random_ObjectInfo.renders
	--print("avatarInfoId=", avatarInfoId)
	--print("renders=", renders)
	if renders then
		--local worldLayer = world.handle.worldLayer
		local imgFileName = wallimg
		local texture = CCTextureCache:sharedTextureCache():textureForKey(imgFileName)
		if (not texture) then
			texture = CCTextureCache:sharedTextureCache():addImage(imgFileName)
			--print("加载" .. imgFileName .. "！")
		end
		--local tSize = texture:getContentSize()
		
		--地面装饰物件
		for tt = 1, #tex_sprites, 1 do
			-- 即ground配置中的索引
			if (tex_sprites[tt].index ~= 3) then
				local obj_rand = math.random(1, 100)
				if (obj_rand <= 20) then
					local tile_x = tex_sprites[tt].x
					local tile_y = tex_sprites[tt].y
					
					local PX = tile_x + 124 -- offsetX / PIX_SIZE
					local PY = tile_y + 90 -- offsetY / PIX_SIZE
					local PW = tex_sprites[tt].w
					local PH = tex_sprites[tt].h
				--[[
			--for _, RoomValue in pairs(rooms) do
			--	local PX = RoomValue.x + offsetX / PIX_SIZE
				--local PY = RoomValue.y + offsetY / PIX_SIZE
				--local PW = RoomValue.w
				--local PH = RoomValue.h
				--print(PX, PY, PW, PH)
				
				local renderPos = {}
				local randIdx = math.random(1, 8)
				if (randIdx == 1) then --正中央
					local renderX = (PX + PW / 2) * PIX_SIZE
					local renderY = (PY + PH / 2) * PIX_SIZE
					renderPos[#renderPos+1] = {x = renderX, y = renderY,}
				elseif (randIdx == 2) then --左1/4
					local renderX = (PX + PW / 4) * PIX_SIZE
					local renderY = (PY + PH / 2) * PIX_SIZE
					renderPos[#renderPos+1] = {x = renderX, y = renderY,}
				elseif (randIdx == 3) then --右1/4
					local renderX = (PX + PW / 4 * 3) * PIX_SIZE
					local renderY = (PY + PH / 2) * PIX_SIZE
					renderPos[#renderPos+1] = {x = renderX, y = renderY,}
				elseif (randIdx == 4) then --上1/4
					local renderX = (PX + PW / 2) * PIX_SIZE
					local renderY = (PY + PH / 4) * PIX_SIZE
					renderPos[#renderPos+1] = {x = renderX, y = renderY,}
				elseif (randIdx == 5) then --下1/4
					local renderX = (PX + PW / 2) * PIX_SIZE
					local renderY = (PY + PH / 4 * 3) * PIX_SIZE
					renderPos[#renderPos+1] = {x = renderX, y = renderY,}
				elseif (randIdx == 6) then --左1/4+右1/4
					local renderX = (PX + PW / 4) * PIX_SIZE
					local renderY = (PY + PH / 2) * PIX_SIZE
					renderPos[#renderPos+1] = {x = renderX, y = renderY,}
					
					local renderX = (PX + PW / 4 * 3) * PIX_SIZE
					local renderY = (PY + PH / 2) * PIX_SIZE
					renderPos[#renderPos+1] = {x = renderX, y = renderY,}
				elseif (randIdx == 7) then --上1/4+下1/4
					local renderX = (PX + PW / 2) * PIX_SIZE
					local renderY = (PY + PH / 4) * PIX_SIZE
					renderPos[#renderPos+1] = {x = renderX, y = renderY,}
					
					local renderX = (PX + PW / 2) * PIX_SIZE
					local renderY = (PY + PH / 4 * 3) * PIX_SIZE
					renderPos[#renderPos+1] = {x = renderX, y = renderY,}
				elseif (randIdx == 8) then --无
					--
				end
				
				--for p = 1, #renderPos, 1 do
				]]
					--此点是否为障碍
					if (xlScene_IsGridBlock(g_world, PX / 24, PY / 24) == 0) then
						--随机一个装饰物件
						local randsceIdx = math.random(1, #renders)
						local render_i = renders[randsceIdx]
						local tex_x = render_i.x
						local tex_y = render_i.y
						local tex_w = render_i.w
						local tex_h = render_i.h
						--local renderX = renderPos[p].x
						--local renderY = renderPos[p].y
						
						--地块足够装的下此装饰物
						if (PW >= tex_w) and (PH >= tex_h) then
							local sprite = CCSprite:createWithTexture(texture, CCRectMake(tex_x, tex_y, tex_w, tex_h))
							sprite:setAnchorPoint(ccp(0.5, 0.5))
							
							--50％几率翻转
							if (math.random(1, 100)<= 50) then
								sprite:setFlipX(true)
							end
							
							--sprite:setPosition(ccp(renderX, -renderY))
							sprite:setPosition(ccp(PX, -PY))
							worldLayer:addChild(sprite, 21)
							
							--存储地面装饰物件贴图
							render_sprites[#render_sprites+1] = sprite
						end
					end
				--end
				end
			end
		end
	end
	
	--传送点
	local roomType = nil
	--找到最boss房最远的房间
	local BOSS_CX = 0 -- BOSS房间中心点X
	local BOSS_CY = 0 -- BOSS房间中心点Y
	--先找boss房
	for i = 1, #rooms, 1 do
		local tRegion = rooms[i]
		local strRoomType = tRegion.Roomtype --区域类型
		local roomPosX = tRegion.x + offsetX / PIX_SIZE
		local roomPosY = tRegion.y + offsetY / PIX_SIZE
		local roomWidth = tRegion.w
		local roomHeight = tRegion.h
		local tTerminalPos = tRegion.TerminalPos --终点坐标集
		
		if (strRoomType == "normal") then --普通房间
			if (roomWidth*PIX_SIZE < hVar.RANDMAP_ROOM_NORMAL_BIG_EDGE) or (roomHeight*PIX_SIZE < hVar.RANDMAP_ROOM_NORMAL_BIG_EDGE) then
				roomType = hVar.RANDMAP_ROOMTYPE.ROOM_NORMAL_SMALL
			else
				roomType = hVar.RANDMAP_ROOMTYPE.ROOM_NORMAL_BIG
			end
		elseif (strRoomType == "road") then --通路、断头路
			if tTerminalPos then
				roomType = hVar.RANDMAP_ROOMTYPE.ROOM_ROAD_TERMINAL
			else
				if (roomWidth >= roomHeight) then
					roomType = hVar.RANDMAP_ROOMTYPE.ROOM_ROAD_W
				else
					roomType = hVar.RANDMAP_ROOMTYPE.ROOM_ROAD_H
				end
			end
		elseif (strRoomType == "boss") then --BOSS大房间
			roomType = hVar.RANDMAP_ROOMTYPE.ROOM_BOSS
			
			--终极boss房间
			if terminal then
				roomType = hVar.RANDMAP_ROOMTYPE.ROOM_BOSS_TERNIMAL
			end
		end
		
		--print(PX, PY, PW, PH)
		
		--找boss房
		if (roomType == hVar.RANDMAP_ROOMTYPE.ROOM_BOSS) or (roomType == hVar.RANDMAP_ROOMTYPE.ROOM_BOSS_TERNIMAL) then
			BOSS_CX = roomPosX + roomWidth / 2
			BOSS_CY = roomPosY + roomHeight / 2
		end
	end
	--再找最远的房间
	local MAX_PX = 0
	local MAX_PY = 0
	local MAX_DIS = 0
	for i = 1, #rooms, 1 do
		local tRegion = rooms[i]
		local strRoomType = tRegion.Roomtype --区域类型
		local roomPosX = tRegion.x + offsetX / PIX_SIZE
		local roomPosY = tRegion.y + offsetY / PIX_SIZE
		local roomWidth = tRegion.w
		local roomHeight = tRegion.h
		local tTerminalPos = tRegion.TerminalPos --终点坐标集
		
		if (strRoomType == "normal") then --普通房间
			if (roomWidth*PIX_SIZE < hVar.RANDMAP_ROOM_NORMAL_BIG_EDGE) or (roomHeight*PIX_SIZE < hVar.RANDMAP_ROOM_NORMAL_BIG_EDGE) then
				roomType = hVar.RANDMAP_ROOMTYPE.ROOM_NORMAL_SMALL
			else
				roomType = hVar.RANDMAP_ROOMTYPE.ROOM_NORMAL_BIG
			end
		elseif (strRoomType == "road") then --通路、断头路
			if tTerminalPos then
				roomType = hVar.RANDMAP_ROOMTYPE.ROOM_ROAD_TERMINAL
			else
				if (roomWidth >= roomHeight) then
					roomType = hVar.RANDMAP_ROOMTYPE.ROOM_ROAD_W
				else
					roomType = hVar.RANDMAP_ROOMTYPE.ROOM_ROAD_H
				end
			end
		elseif (strRoomType == "boss") then --BOSS大房间
			roomType = hVar.RANDMAP_ROOMTYPE.ROOM_BOSS
			
			--终极boss房间
			if terminal then
				roomType = hVar.RANDMAP_ROOMTYPE.ROOM_BOSS_TERNIMAL
			end
		end
		
		--print(PX, PY, PW, PH)
		
		--不是boss房
		if (roomType ~= hVar.RANDMAP_ROOMTYPE.ROOM_BOSS) and (roomType ~= hVar.RANDMAP_ROOMTYPE.ROOM_BOSS_TERNIMAL) then
			local roomPosCX = roomPosX + roomWidth / 2
			local roomPosCY = roomPosY + roomHeight / 2
			local dx = roomPosCX - BOSS_CX
			local dy = roomPosCY - BOSS_CY
			local dis = dx * dx + dy * dy
			if (dis > MAX_DIS) then
				MAX_PX = roomPosCX
				MAX_PY = roomPosCY
				MAX_DIS = dis
			end
		end
	end
	local transport_px = MAX_PX * PIX_SIZE
	local transport_py = MAX_PY * PIX_SIZE
	
	--将战车设置到此传送点
	local me = world:GetPlayerMe()
	local heros = me.heros
	local oHero = heros[1]
	local oUnit = oHero:getunit()
	local bForceSetPos = true
	oUnit:setPos(transport_px, transport_py, nil, bForceSetPos)
	
	--宠物也传送过来
	local rpgunits = world.data.rpgunits
	for u, u_worldC in pairs(rpgunits) do
		for _, walle_id in ipairs(hVar.MY_TANK_FOLLOW_ID) do
			if (u.data.id == walle_id) then
				u:setPos(transport_px, transport_py, nil, bForceSetPos)
				--print("randommap宠物也传送:", u.data.name, walle_id, transport_px, transport_py)
			end
		end
	end
	
	--镜头聚焦
	hApi.setViewNodeFocus(transport_px, transport_py)
	--print("镜头聚焦1")
	
	--地球远景层
	local universe_farobj = nil
	local farobj = random_ObjectInfo.farobj
	if farobj then
		--地球层远景物件
		local tImg = farobj.img
		local loopnum = farobj.num or 0
		local scale = farobj.scale or 1
		local rollRatio = farobj.rollRatio or 0.1 --卷轴速率
		if (type(tImg) == "table") then
			local tNodeFar = {}
			local IMGNUM = (#tImg)
			for loop = 1, loopnum, 1 do
				--计算图片索引
				local idx = loop % IMGNUM
				if (idx == 0) then
					idx = IMGNUM
				end
				
				--如果只有一张图，那么随机
				if (loopnum == 1) then
					idx = math.random(1, IMGNUM)
				end
				
				--[[
				--用指定背景
				if (g_backgroundId ~= nil) then
					idx = g_backgroundId
					g_backgroundId = nil
				end
				]]
				
				--计算缩放
				local scale0 = 1
				if (type(scale) == "number") then
					scale0 = scale
				elseif (type(scale) == "table") then
					local scaleMin = scale[1] or 1
					local scaleMax = scale[2] or 1
					scale0 = math.random(math.floor(scaleMin * 100), math.floor(scaleMax * 100)) / 100
				end
				
				--启动图，更大些
				if (world.data.map == hVar.LoginMap) then
					scale0 = scale0 * 2
				end
				
				--宇宙层远景物件
				local imgFileName = tImg[idx]
				local texture = CCTextureCache:sharedTextureCache():textureForKey(imgFileName)
				if (not texture) then
					texture = CCTextureCache:sharedTextureCache():addImage(imgFileName)
					print("加载宇宙层远景物件图！", imgFileName)
				end
				local tSize = texture:getContentSize()
				local spriteFar = CCSprite:createWithTexture(texture, CCRectMake(0, 0, tSize.width, tSize.height))
				spriteFar:setAnchorPoint(ccp(0.5, 0.5))
				spriteFar:setPosition(ccp(transport_px, -transport_py))
				--spriteFar:setContentSize(CCSizeMake(d.sizeW, d.sizeH))
				--spriteFar:setScaleX(d.sizeW/tSize.width)
				--spriteFar:setScaleY(d.sizeH/tSize.height)
				spriteFar:setScale(scale0)
				worldLayer:addChild(spriteFar, 0)
				tNodeFar[#tNodeFar+1] = spriteFar
			end
			
			--存储
			--local camX, camY = xlGetViewNodeFocus()
			universe_farobj = {node = tNodeFar, camX = transport_px, camY = transport_py, rollRatio = rollRatio,}
		end
	end
	
	--星星中景层
	local universe_middleobj = nil
	local middleobj = random_ObjectInfo.middleobj
	if middleobj then
		--星星层中景物件
		local tImg = middleobj.img
		local loopnum = middleobj.num or 0
		local scale = middleobj.scale or 1
		local rollRatio = middleobj.rollRatio or 0.16 --卷轴速率
		if (type(tImg) == "table") then
			--宇宙层中景物件
			local tNodeMiddle = {}
			local IMGNUM = (#tImg)
			for loop = 1, loopnum, 1 do
				--计算图片索引
				local idx = loop % IMGNUM
				if (idx == 0) then
					idx = IMGNUM
				end
				
				--计算缩放
				local scale0 = 1
				if (type(scale) == "number") then
					scale0 = scale
				elseif (type(scale) == "table") then
					local scaleMin = scale[1] or 1
					local scaleMax = scale[2] or 1
					scale0 = math.random(math.floor(scaleMin * 100), math.floor(scaleMax * 100)) / 100
				end
				
				--星星图片
				local imgFileName = tImg[idx]
				local texture = CCTextureCache:sharedTextureCache():textureForKey(imgFileName)
				if (not texture) then
					texture = CCTextureCache:sharedTextureCache():addImage(imgFileName)
					print("加载宇宙层中景物件图！", imgFileName)
				end
				local tSize = texture:getContentSize()
				local sprite = CCSprite:createWithTexture(texture, CCRectMake(0, 0, tSize.width, tSize.height))
				local randX = math.random(math.floor(offsetX), math.floor(max_px))
				local randY = math.random(math.floor(offsetY), math.floor(max_py))
				local rot = math.random(0, 360)
				--local scale = math.random(20, 75) / 100
				sprite:setAnchorPoint(ccp(0.5, 0.5))
				sprite:setPosition(ccp(randX, -randY))
				sprite:setRotation(rot)
				sprite:setScale(scale0)
				--sprite:setContentSize(CCSizeMake(d.sizeW, d.sizeH))
				--sprite:setScaleX(d.sizeW/tSize.width)
				--sprite:setScaleY(d.sizeH/tSize.height)
				--sprite:setScaleX(2.5)
				--sprite:setScaleY(2.5)
				worldLayer:addChild(sprite, 1)
				tNodeMiddle[#tNodeMiddle+1] = sprite
				
				--动画
				--近景物件图标随机动画
				--local delayTime1 = math.random(800, 1600)
				--local delayTime2 = math.random(800, 1600)
				local moveTime = math.random(5000, 7500) / 1000
				local scaleTo = scale0 + math.random(10, 25) / 100
				--local act1 = CCDelayTime:create(delayTime1/1000)
				local act2A = CCScaleTo:create(moveTime/2, scaleTo)
				local act2B = CCScaleTo:create(moveTime/2, scale0)
				local act2 = CCSequence:createWithTwoActions(act2A, act2B) --同步1
				local act3 = nil
				if (math.random(1, 2) == 1) then
					act3 = CCRotateBy:create(moveTime, math.random(10, 15))
				else
					act3 = CCRotateBy:create(moveTime, -math.random(10, 15))
				end
				local act4 = CCSpawn:createWithTwoActions(act2, act3) --同步1
				local a = CCArray:create()
				--a:addObject(act1)
				--a:addObject(act2)
				--a:addObject(act3)
				a:addObject(act4)
				local sequence = CCSequence:create(a)
				--oItem.handle.s:stopAllActions() --先停掉之前的动作
				sprite:runAction(CCRepeatForever:create(sequence))
			end
			
			--存储
			universe_middleobj = {node = tNodeMiddle, camX = transport_px, camY = transport_py, rollRatio = rollRatio,}
		end
	end
	
	--陨石近景层
	local universe_nearobj = nil
	local nearobj = random_ObjectInfo.nearobj
	if nearobj then
		--陨石层近景物件
		local tImg = nearobj.img
		local loopnum = nearobj.num or 0
		local scale = nearobj.scale or 1
		local rollRatio = nearobj.rollRatio or 0.3 --卷轴速率
		if (type(tImg) == "table") then
			--陨石层近景物件
			local tNodeNear = {}
			local IMGNUM = (#tImg)
			for loop = 1, loopnum, 1 do
				--计算图片索引
				local idx = loop % IMGNUM
				if (idx == 0) then
					idx = IMGNUM
				end
				
				--计算缩放
				local scale0 = 1
				if (type(scale) == "number") then
					scale0 = scale
				elseif (type(scale) == "table") then
					local scaleMin = scale[1] or 1
					local scaleMax = scale[2] or 1
					scale0 = math.random(math.floor(scaleMin * 100), math.floor(scaleMax * 100)) / 100
				end
				--print(scale0)
				--陨石图片
				local imgFileName = tImg[idx]
				local sprite = nil
				if (type(imgFileName) == "string") then
					local texture = textureCCTextureCache:sharedTextureCache():textureForKey(imgFileName)
					if (not texture) then
						texture = CCTextureCache:sharedTextureCache():addImage(imgFileName)
						print("加载宇宙层近景物件图！", imgFileName)
					end
					local tSize = texture:getContentSize()
					sprite = CCSprite:createWithTexture(texture, CCRectMake(0, 0, tSize.width, tSize.height))
				elseif (type(imgFileName) == "table") then
					local tex_x = imgFileName.x
					local tex_y = imgFileName.y
					local tile_w = imgFileName.w
					local tile_h = imgFileName.h
					local imgFileName2 = wallimg
					local texture = CCTextureCache:sharedTextureCache():textureForKey(imgFileName2)
					if (not texture) then
						texture = CCTextureCache:sharedTextureCache():addImage(imgFileName2)
						--print("加载" .. imgFileName2 .. "！")
					end
					sprite = CCSprite:createWithTexture(texture, CCRectMake(tex_x, tex_y, tile_w, tile_h))
				end
				local randX = math.random(math.floor(offsetX), math.floor(max_px))
				local randY = math.random(math.floor(offsetY), math.floor(max_py))
				local rot = math.random(0, 360)
				--local scale = math.random(40, 160) / 100
				sprite:setAnchorPoint(ccp(0.5, 0.5))
				sprite:setPosition(ccp(randX, -randY))
				sprite:setRotation(rot)
				sprite:setScale(scale0)
				--sprite:setContentSize(CCSizeMake(d.sizeW, d.sizeH))
				--sprite:setScaleX(d.sizeW/tSize.width)
				--sprite:setScaleY(d.sizeH/tSize.height)
				--sprite:setScaleX(2.5)
				--sprite:setScaleY(2.5)
				worldLayer:addChild(sprite, 1)
				tNodeNear[#tNodeNear+1] = sprite
				
				--动画
				--近景物件图标随机动画
				--local delayTime1 = math.random(800, 1600)
				--local delayTime2 = math.random(800, 1600)
				local moveTime = math.random(200000, 350000) / 1000
				local moveTo = nil
				local moveRandomValue = math.random(1, 8)
				if (moveRandomValue == 1) then
					moveTo = CCMoveBy:create(moveTime/2, ccp(math.random(600, 1200), 0))
				elseif (moveRandomValue == 2) then
					moveTo = CCMoveBy:create(moveTime/2, ccp(math.random(-1200, -600), 0))
				elseif (moveRandomValue == 3) then
					moveTo = CCMoveBy:create(moveTime/2, ccp(0, math.random(600, 1200)))
				elseif (moveRandomValue == 4) then
					moveTo = CCMoveBy:create(moveTime/2, ccp(0, math.random(-1200, -600)))
				elseif (moveRandomValue == 5) then
					moveTo = CCMoveBy:create(moveTime/2, ccp(math.random(600, 1200), math.random(600, 1200)))
				elseif (moveRandomValue == 6) then
					moveTo = CCMoveBy:create(moveTime/2, ccp(math.random(600, 1200), math.random(-1200, -600)))
				elseif (moveRandomValue == 7) then
					moveTo = CCMoveBy:create(moveTime/2, ccp(math.random(-1200, -600), math.random(600, 1200)))
				elseif (moveRandomValue == 8) then
					moveTo = CCMoveBy:create(moveTime/2, ccp(math.random(-1200, -600), math.random(-1200, -600)))
				end
				
				local moveBack = moveTo:reverse()
				--local act1 = CCDelayTime:create(delayTime1/1000)
				local act2 = CCSequence:createWithTwoActions(moveTo, moveBack) --同步1
				local act3 = nil
				local rotRandomValue = math.random(1, 8)
				if (rotRandomValue == 1) then
					act3 = CCRotateBy:create(moveTime, 3600)
				elseif (rotRandomValue == 2) then
					act3 = CCRotateBy:create(moveTime, -3600)
				elseif (rotRandomValue == 3) then
					act3 = CCRotateBy:create(moveTime, 2520)
				elseif (rotRandomValue == 4) then
					act3 = CCRotateBy:create(moveTime, -2520)
				elseif (rotRandomValue == 5) then
					act3 = CCRotateBy:create(moveTime, 1800)
				elseif (rotRandomValue == 6) then
					act3 = CCRotateBy:create(moveTime, -1800)
				elseif (rotRandomValue == 7) then
					act3 = CCRotateBy:create(moveTime, 1080)
				elseif (rotRandomValue == 8) then
					act3 = CCRotateBy:create(moveTime, -1080)
				end
				local act4 = CCSpawn:createWithTwoActions(act2, act3) --同步1
				local a = CCArray:create()
				--a:addObject(act1)
				--a:addObject(act2)
				--a:addObject(act3)
				a:addObject(act4)
				local sequence = CCSequence:create(a)
				--oItem.handle.s:stopAllActions() --先停掉之前的动作
				sprite:runAction(CCRepeatForever:create(sequence))
			end
			
			--存储
			universe_nearobj = {node = tNodeNear, camX = transport_px, camY = transport_py, rollRatio = rollRatio,}
		end
	end
	
	--xlScene_SetMapBlock(gx, gy, 0)
	
	--存储数据
	-- 地图区域数据
	local regionData =
	{
		xlobj_units = xlobj_units, --场景物件单位集
		xlobj_sprites = xlobj_sprites, --墙体特效贴图集
		pointer_in_units = {}, --指向boss入口的箭头单位集
		pointer_out_units = {}, --指向boss出口的箭头单位集
		npc_units = {}, --npc单位集
		
		tex_sprites = tex_sprites, --地板贴图集
		render_sprites = render_sprites, --地面装饰物贴图集
		
		blood_effects = {}, --飙血特效集
		drop_units = {}, --掉落的道具单位集
		
		boss_groupId = 0, --BOSS的groupId（用于boss的唯一性）
		
		universe_farobj = universe_farobj, --宇宙层远景物件
		universe_middleobj = universe_middleobj, --宇宙层中景物件
		universe_nearobj = universe_nearobj, --宇宙层近景物件
		
		rooms = rooms, --房间信息
		rooms_new = rooms_new, --房间信息new（断头路拆分为正方形和长方形）
		unitList = unitList, --单位信息
		--roomgroup = {}, --房间组信息
		
		regionPoint = regionPoint,
		avatarInfoId = avatarInfoId,
		mutation_count = 0, --突变次数
		
		transport_unit = nil, --传送点单位
		transport_id = 0, --传送点id
		transport_back_unit = nil, --传送点返回单位
		boosroom_doorblocks = {}, --boss房间门口路障
		
		transport_px = transport_px, --传送点x坐标
		transport_py = transport_py, --传送点y坐标
		transport_back_px = transport_px, --传送点返回x坐标
		transport_back_py = transport_py, --传送点返回y坐标
		regoin_xl = offsetX, --左上角x坐标
		regoin_yt = offsetY, --左上角y坐标
		regoin_xr = max_px, --右下角x坐标
		regoin_yb = max_py, --右下角y坐标
		
		roomgroupSendArmyList = {}, --房间组发兵表 --{[n] = {groupId = XXX, x = XXX, y = XXX, beginTick = XXX, currentWave = XXX, unitperWave = {[1] = {...}, [2] = {...}, ...}, ...}
	}
	
	--存储数据
	local prevoisIdx = d.randommapIdx
	d.randommapInfo[regionId] = regionData --随机地图信息
	d.randommapIdx = regionId --当前所在随机地图索引
	
	--移除前一个宇宙层控件
	if (prevoisIdx > 0) then
		local regionDataPrev = d.randommapInfo[prevoisIdx]
		
		--前一层远景物件
		local farObj = regionDataPrev.universe_farobj
		if (type(farObj) == "table") then
			local node = farObj.node
			for n = 1, #node, 1 do
				local nodei = node[n]
				worldLayer:removeChild(nodei, true)
			end
			
			farObj.camX = 0
			farObj.camY = 0
		end
		
		--前一层中景物件
		local middleObj = regionDataPrev.universe_middleobj
		if (type(middleObj) == "table") then
			local node = middleObj.node
			for n = 1, #node, 1 do
				local nodei = node[n]
				worldLayer:removeChild(nodei, true)
			end
			
			middleObj.camX = 0
			middleObj.camY = 0
		end
		
		--前一层近景物件
		local nearObj = regionDataPrev.universe_nearobj
		if (type(nearObj) == "table") then
			local node = nearObj.node
			for n = 1, #node, 1 do
				local nodei = node[n]
				worldLayer:removeChild(nodei, true)
			end
			
			nearObj.camX = 0
			nearObj.camY = 0
		end
		
		--隐藏前一层的部分界面和单位
		local render_sprites = regionDataPrev.render_sprites --地面装饰物件贴图集
		local tex_sprites = regionDataPrev.tex_sprites --地板贴图集
		local pointer_in_units = regionDataPrev.pointer_in_units --指向boss入口的箭头单位集
		local pointer_out_units = regionDataPrev.pointer_out_units --指向boss出的箭头单位集
		local boosroom_doorblocks = regionDataPrev.boosroom_doorblocks --boss房间门口路障
		local xlobj_units = regionDataPrev.xlobj_units --场景物件单位集
		local xlobj_sprites = regionDataPrev.xlobj_sprites --墙体特效贴图集
		local npc_units = regionDataPrev.npc_units --npc单位集
		local blood_effects = regionDataPrev.blood_effects --飙血特效集
		local drop_units = regionDataPrev.drop_units --掉落的道具单位集
		
		--隐藏地面装饰物件贴图集
		for r = 1, #render_sprites, 1 do
			local sprite = render_sprites[r]
			sprite:setVisible(false)
		end
		
		--隐藏地板贴图集
		for r = 1, #tex_sprites, 1 do
			local sprite = tex_sprites[r].sprite
			sprite:setVisible(false)
		end
		
		--隐藏指向boss入口的箭头单位集
		for r = 1, #pointer_in_units, 1 do
			local oUnit = pointer_in_units[r]
			oUnit:sethide(1)
		end
		
		--隐藏boss房间门口路障
		for r = 1, #boosroom_doorblocks, 1 do
			local oUnit = boosroom_doorblocks[r]
			oUnit:sethide(1)
		end
		
		--隐藏围墙
		for r = 1, #xlobj_units, 1 do
			local cha = xlobj_units[r]
			local eu = hApi.findSceobjByCha(cha)
			if eu then
				eu:sethide(1)
			end
		end
		
		--隐藏墙体特效贴图集
		for r = 1, #xlobj_sprites, 1 do
			local sprite = xlobj_sprites[r]
			sprite:setVisible(false)
		end
		
		--隐藏npc单位集
		for r = 1, #npc_units, 1 do
			local oUnit = npc_units[r]
			oUnit:sethide(1)
		end
		
		--隐藏小兵
		world:enumunit(function(eu)
			if (eu.attr.regionIdBelong == prevoisIdx) then
				--只隐藏英雄和小兵和砖块
				if (eu.data.type == hVar.UNIT_TYPE.UNIT) or (eu.data.type == hVar.UNIT_TYPE.HERO) or (eu.data.type == hVar.UNIT_TYPE.UNITBROKEN) then
					eu:sethide(1)
				end
			end
		end)
	end
	
	--释放资源
	--释放远景层资源
	local farobj = random_ObjectInfo.farobj
	if farobj then
		local tImg = farobj.img
		for i = 1, #tImg, 1 do
			local imgFileName = tImg[i]
			local texture = CCTextureCache:sharedTextureCache():textureForKey(imgFileName)
			if (texture) then
				CCTextureCache:sharedTextureCache():removeTexture(texture)
				print("释放宇宙层远景物件图！", imgFileName)
			end
		end
	end
	
	--释放中景层资源
	local middleobj = random_ObjectInfo.middleobj
	if middleobj then
		local tImg = middleobj.img
		for i = 1, #tImg, 1 do
			local imgFileName = tImg[i]
			local texture = CCTextureCache:sharedTextureCache():textureForKey(imgFileName)
			if (texture) then
				CCTextureCache:sharedTextureCache():removeTexture(texture)
				print("释放宇宙层中景物件图！", imgFileName)
			end
		end
	end
	
	--释放近景层资源
	local nearobj = random_ObjectInfo.nearobj
	if nearobj then
		local tImg = nearobj.img
		for i = 1, #tImg, 1 do
			local imgFileName = tImg[i]
			if (type(imgFileName) == "string") then
				local texture = CCTextureCache:sharedTextureCache():textureForKey(imgFileName)
				if (texture) then
					CCTextureCache:sharedTextureCache():removeTexture(texture)
					print("释放宇宙层近景物件图！", imgFileName)
				end
			end
		end
	end
	
	--释放地板资源
	local wallimg = random_ObjectInfo.wallimg
	if wallimg then
		local imgFileName = wallimg
		local texture = CCTextureCache:sharedTextureCache():textureForKey(imgFileName)
		if (texture) then
			CCTextureCache:sharedTextureCache():removeTexture(texture)
			print("释放墙体物件图！", imgFileName)
		end
	end
	
	--释放png, plist的纹理缓存
	hApi.ReleasePngTextureCache()
	
	return regionId
end

--传送到指定地图区域id
hApi.TransportRandomMap = function(world, regionId)
	local d = world.data
	local worldLayer = world.handle.worldLayer
	local randommapInfo = d.randommapInfo --随机地图信息
	local prevoisIdx = d.randommapIdx
	
	--返回值
	local retX, retY = 0, 0
	
	local regionData = d.randommapInfo[regionId]
	if regionData then
		local transport_px = regionData.transport_px --传送点x坐标
		local transport_py = regionData.transport_py --传送点y坐标
		local transport_back_px = regionData.transport_back_px --传送点返回x坐标
		local transport_back_py = regionData.transport_back_py --传送点返回y坐标
		local offsetX = regionData.regoin_xl --左上角x坐标
		local offsetY = regionData.regoin_yt --左上角y坐标
		local max_px = regionData.regoin_xr --右下角x坐标
		local max_py = regionData.regoin_yb --右下角y坐标
		
		--如果是返回，到返回点坐标
		if (regionId < prevoisIdx) then
			transport_px = transport_back_px
			transport_py = transport_back_py
		end
		
		--将战车设置到此传送点
		local me = world:GetPlayerMe()
		local heros = me.heros
		local oHero = heros[1]
		local oUnit = oHero:getunit()
		local bForceSetPos = true
		oUnit:setPos(transport_px, transport_py, nil, bForceSetPos)
		--print("传送", regionId, transport_px, transport_py, prevoisIdx)
		
		--宠物也传送过来
		local rpgunits = world.data.rpgunits
		for u, u_worldC in pairs(rpgunits) do
			for _, walle_id in ipairs(hVar.MY_TANK_FOLLOW_ID) do
				if (u.data.id == walle_id) then
					u:setPos(transport_px, transport_py, nil, bForceSetPos)
				end
			end
		end
		
		--镜头聚焦
		hApi.setViewNodeFocus(transport_px, transport_py)
		--print("镜头聚焦2")
		
		--返回值
		retX = transport_px
		retY = transport_py
		
		--地球远景层
		local regionPoint = regionData.regionPoint
		local avatarInfoId = regionData.avatarInfoId
		local tMultiply = hVar.RANDMAP_REGION_POINT_MULTIPLY[regionPoint]
		--local avatarInfoId = tMultiply.avatarInfoId or 0 --皮肤id
		--if (avatarInfoId <= 0) then
		--	avatarInfoId = oWorld:random(1, hVar.RANDMAP_ROOM_AVATAR_INFO.RandRange)
		--end
		local random_ObjectInfo = hVar.RANDMAP_ROOM_AVATAR_INFO[avatarInfoId]
		local universe_farobj = nil
		local farobj = random_ObjectInfo.farobj
		if farobj then
			--地球层远景物件
			local tImg = farobj.img
			local loopnum = farobj.num or 0
			local scale = farobj.scale or 1
			local rollRatio = farobj.rollRatio or 0.1 --卷轴速率
			if (type(tImg) == "table") then
				local tNodeFar = {}
				local IMGNUM = (#tImg)
				for loop = 1, loopnum, 1 do
					--计算图片索引
					local idx = loop % IMGNUM
					if (idx == 0) then
						idx = IMGNUM
					end
					
					--如果只有一张图，那么随机
					if (loopnum == 1) then
						idx = math.random(1, IMGNUM)
					end
					
					--计算缩放
					local scale0 = 1
					if (type(scale) == "number") then
						scale0 = scale
					elseif (type(scale) == "table") then
						local scaleMin = scale[1] or 1
						local scaleMax = scale[2] or 1
						scale0 = math.random(math.floor(scaleMin * 100), math.floor(scaleMax * 100)) / 100
					end
					
					--宇宙层远景物件
					local imgFileName = tImg[idx]
					local texture = CCTextureCache:sharedTextureCache():textureForKey(imgFileName)
					if (not texture) then
						texture = CCTextureCache:sharedTextureCache():addImage(imgFileName)
						print("加载宇宙层远景物件图！", imgFileName)
					end
					local tSize = texture:getContentSize()
					local spriteFar = CCSprite:createWithTexture(texture, CCRectMake(0, 0, tSize.width, tSize.height))
					spriteFar:setAnchorPoint(ccp(0.5, 0.5))
					-- 定位到传送位置
					spriteFar:setPosition(ccp(transport_px, -transport_py))
					--spriteFar:setContentSize(CCSizeMake(d.sizeW, d.sizeH))
					--spriteFar:setScaleX(d.sizeW/tSize.width)
					--spriteFar:setScaleY(d.sizeH/tSize.height)
					spriteFar:setScale(scale0)
					worldLayer:addChild(spriteFar, 0)
					tNodeFar[#tNodeFar+1] = spriteFar
				end
				
				--存储
				--local camX, camY = xlGetViewNodeFocus()
				universe_farobj = {node = tNodeFar, camX = transport_px, camY = transport_py, rollRatio = rollRatio,}
			end
		end
		
		--星星中景层
		local universe_middleobj = nil
		local middleobj = random_ObjectInfo.middleobj
		if middleobj then
			--星星层中景物件
			local tImg = middleobj.img
			local loopnum = middleobj.num or 0
			local scale = middleobj.scale or 1
			local rollRatio = middleobj.rollRatio or 0.16 --卷轴速率
			if (type(tImg) == "table") then
				--宇宙层中景物件
				local tNodeMiddle = {}
				local IMGNUM = (#tImg)
				for loop = 1, loopnum, 1 do
					--计算图片索引
					local idx = loop % IMGNUM
					if (idx == 0) then
						idx = IMGNUM
					end
					
					--计算缩放
					local scale0 = 1
					if (type(scale) == "number") then
						scale0 = scale
					elseif (type(scale) == "table") then
						local scaleMin = scale[1] or 1
						local scaleMax = scale[2] or 1
						scale0 = math.random(math.floor(scaleMin * 100), math.floor(scaleMax * 100)) / 100
					end
					
					--星星图片
					local imgFileName = tImg[idx]
					local texture = CCTextureCache:sharedTextureCache():textureForKey(imgFileName)
					if (not texture) then
						texture = CCTextureCache:sharedTextureCache():addImage(imgFileName)
						print("加载宇宙层中景物件图！", imgFileName)
					end
					local tSize = texture:getContentSize()
					local sprite = CCSprite:createWithTexture(texture, CCRectMake(0, 0, tSize.width, tSize.height))
					local randX = math.random(math.floor(offsetX), math.floor(max_px))
					local randY = math.random(math.floor(offsetY), math.floor(max_py))
					local rot = math.random(0, 360)
					--local scale = math.random(20, 75) / 100
					sprite:setAnchorPoint(ccp(0.5, 0.5))
					sprite:setPosition(ccp(randX, -randY))
					sprite:setRotation(rot)
					sprite:setScale(scale0)
					--sprite:setContentSize(CCSizeMake(d.sizeW, d.sizeH))
					--sprite:setScaleX(d.sizeW/tSize.width)
					--sprite:setScaleY(d.sizeH/tSize.height)
					--sprite:setScaleX(2.5)
					--sprite:setScaleY(2.5)
					worldLayer:addChild(sprite, 1)
					tNodeMiddle[#tNodeMiddle+1] = sprite
					
					--动画
					--近景物件图标随机动画
					--local delayTime1 = math.random(800, 1600)
					--local delayTime2 = math.random(800, 1600)
					local moveTime = math.random(5000, 7500) / 1000
					local scaleTo = scale0 + math.random(10, 25) / 100
					--local act1 = CCDelayTime:create(delayTime1/1000)
					local act2A = CCScaleTo:create(moveTime/2, scaleTo)
					local act2B = CCScaleTo:create(moveTime/2, scale0)
					local act2 = CCSequence:createWithTwoActions(act2A, act2B) --同步1
					local act3 = nil
					if (math.random(1, 2) == 1) then
						act3 = CCRotateBy:create(moveTime, math.random(10, 15))
					else
						act3 = CCRotateBy:create(moveTime, -math.random(10, 15))
					end
					local act4 = CCSpawn:createWithTwoActions(act2, act3) --同步1
					local a = CCArray:create()
					--a:addObject(act1)
					--a:addObject(act2)
					--a:addObject(act3)
					a:addObject(act4)
					local sequence = CCSequence:create(a)
					--oItem.handle.s:stopAllActions() --先停掉之前的动作
					sprite:runAction(CCRepeatForever:create(sequence))
				end
				
				--存储
				universe_middleobj = {node = tNodeMiddle, camX = transport_px, camY = transport_py, rollRatio = rollRatio,}
			end
		end
		
		--陨石近景层
		local universe_nearobj = nil
		local nearobj = random_ObjectInfo.nearobj
		if nearobj then
			--陨石层近景物件
			local tImg = nearobj.img
			local loopnum = nearobj.num or 0
			local scale = nearobj.scale or 1
			local rollRatio = nearobj.rollRatio or 0.3 --卷轴速率
			if (type(tImg) == "table") then
				--陨石层近景物件
				local tNodeNear = {}
				local IMGNUM = (#tImg)
				for loop = 1, loopnum, 1 do
					--计算图片索引
					local idx = loop % IMGNUM
					if (idx == 0) then
						idx = IMGNUM
					end
					
					--计算缩放
					local scale0 = 1
					if (type(scale) == "number") then
						scale0 = scale
					elseif (type(scale) == "table") then
						local scaleMin = scale[1] or 1
						local scaleMax = scale[2] or 1
						scale0 = math.random(math.floor(scaleMin * 100), math.floor(scaleMax * 100)) / 100
					end
					--print(scale0)
					--陨石图片
					local imgFileName = tImg[idx]
					local sprite = nil
					if (type(imgFileName) == "string") then
						local texture = textureCCTextureCache:sharedTextureCache():textureForKey(imgFileName)
						if (not texture) then
							texture = CCTextureCache:sharedTextureCache():addImage(imgFileName)
							print("加载宇宙层近景物件图！", imgFileName)
						end
						local tSize = texture:getContentSize()
						sprite = CCSprite:createWithTexture(texture, CCRectMake(0, 0, tSize.width, tSize.height))
					elseif (type(imgFileName) == "table") then
						local tex_x = imgFileName.x
						local tex_y = imgFileName.y
						local tile_w = imgFileName.w
						local tile_h = imgFileName.h
						local wallimg = random_ObjectInfo.wallimg
						local imgFileName2 = wallimg
						local texture = CCTextureCache:sharedTextureCache():textureForKey(imgFileName2)
						if (not texture) then
							texture = CCTextureCache:sharedTextureCache():addImage(imgFileName2)
							--print("加载" .. imgFileName2 .. "！")
						end
						sprite = CCSprite:createWithTexture(texture, CCRectMake(tex_x, tex_y, tile_w, tile_h))
					end
					local randX = math.random(math.floor(offsetX), math.floor(max_px))
					local randY = math.random(math.floor(offsetY), math.floor(max_py))
					local rot = math.random(0, 360)
					--local scale = math.random(40, 160) / 100
					sprite:setAnchorPoint(ccp(0.5, 0.5))
					sprite:setPosition(ccp(randX, -randY))
					sprite:setRotation(rot)
					sprite:setScale(scale0)
					--sprite:setContentSize(CCSizeMake(d.sizeW, d.sizeH))
					--sprite:setScaleX(d.sizeW/tSize.width)
					--sprite:setScaleY(d.sizeH/tSize.height)
					--sprite:setScaleX(2.5)
					--sprite:setScaleY(2.5)
					worldLayer:addChild(sprite, 1)
					tNodeNear[#tNodeNear+1] = sprite
					
					--动画
					--近景物件图标随机动画
					--local delayTime1 = math.random(800, 1600)
					--local delayTime2 = math.random(800, 1600)
					local moveTime = math.random(200000, 350000) / 1000
					local moveTo = nil
					local moveRandomValue = math.random(1, 8)
					if (moveRandomValue == 1) then
						moveTo = CCMoveBy:create(moveTime/2, ccp(math.random(600, 1200), 0))
					elseif (moveRandomValue == 2) then
						moveTo = CCMoveBy:create(moveTime/2, ccp(math.random(-1200, -600), 0))
					elseif (moveRandomValue == 3) then
						moveTo = CCMoveBy:create(moveTime/2, ccp(0, math.random(600, 1200)))
					elseif (moveRandomValue == 4) then
						moveTo = CCMoveBy:create(moveTime/2, ccp(0, math.random(-1200, -600)))
					elseif (moveRandomValue == 5) then
						moveTo = CCMoveBy:create(moveTime/2, ccp(math.random(600, 1200), math.random(600, 1200)))
					elseif (moveRandomValue == 6) then
						moveTo = CCMoveBy:create(moveTime/2, ccp(math.random(600, 1200), math.random(-1200, -600)))
					elseif (moveRandomValue == 7) then
						moveTo = CCMoveBy:create(moveTime/2, ccp(math.random(-1200, -600), math.random(600, 1200)))
					elseif (moveRandomValue == 8) then
						moveTo = CCMoveBy:create(moveTime/2, ccp(math.random(-1200, -600), math.random(-1200, -600)))
					end
					
					local moveBack = moveTo:reverse()
					--local act1 = CCDelayTime:create(delayTime1/1000)
					local act2 = CCSequence:createWithTwoActions(moveTo, moveBack) --同步1
					local act3 = nil
					local rotRandomValue = math.random(1, 8)
					if (rotRandomValue == 1) then
						act3 = CCRotateBy:create(moveTime, 3600)
					elseif (rotRandomValue == 2) then
						act3 = CCRotateBy:create(moveTime, -3600)
					elseif (rotRandomValue == 3) then
						act3 = CCRotateBy:create(moveTime, 2520)
					elseif (rotRandomValue == 4) then
						act3 = CCRotateBy:create(moveTime, -2520)
					elseif (rotRandomValue == 5) then
						act3 = CCRotateBy:create(moveTime, 1800)
					elseif (rotRandomValue == 6) then
						act3 = CCRotateBy:create(moveTime, -1800)
					elseif (rotRandomValue == 7) then
						act3 = CCRotateBy:create(moveTime, 1080)
					elseif (rotRandomValue == 8) then
						act3 = CCRotateBy:create(moveTime, -1080)
					end
					local act4 = CCSpawn:createWithTwoActions(act2, act3) --同步1
					local a = CCArray:create()
					--a:addObject(act1)
					--a:addObject(act2)
					--a:addObject(act3)
					a:addObject(act4)
					local sequence = CCSequence:create(a)
					--oItem.handle.s:stopAllActions() --先停掉之前的动作
					sprite:runAction(CCRepeatForever:create(sequence))
				end
				
				--存储
				universe_nearobj = {node = tNodeNear, camX = transport_px, camY = transport_py, rollRatio = rollRatio,}
			end
		end
		
		--更新存储
		regionData.universe_farobj = universe_farobj --宇宙层远景物件
		regionData.universe_middleobj = universe_middleobj --宇宙层中景物件
		regionData.universe_nearobj = universe_nearobj --宇宙层近景物件
		
		d.randommapIdx = regionId
		
		--显示本层的部分界面和单位
		local render_sprites = regionData.render_sprites --地面装饰物件贴图集
		local tex_sprites = regionData.tex_sprites --地板贴图集
		local pointer_in_units = regionData.pointer_in_units --指向boss入口的箭头单位集
		local pointer_out_units = regionData.pointer_out_units --指向boss出的箭头单位集
		local boosroom_doorblocks = regionData.boosroom_doorblocks --boss房间门口路障
		local xlobj_units = regionData.xlobj_units --场景物件单位集
		local xlobj_sprites = regionData.xlobj_sprites --墙体特效贴图集
		local npc_units = regionData.npc_units --npc单位集
		local blood_effects = regionData.blood_effects --飙血特效集
		local drop_units = regionData.drop_units --掉落的道具单位集
		
		--显示地面装饰物件贴图集
		for r = 1, #render_sprites, 1 do
			local sprite = render_sprites[r]
			sprite:setVisible(true)
		end
		
		--显示地板贴图集
		for r = 1, #tex_sprites, 1 do
			local sprite = tex_sprites[r].sprite
			sprite:setVisible(true)
		end
		
		--显示指向boss入口的箭头单位集
		for r = 1, #pointer_in_units, 1 do
			local oUnit = pointer_in_units[r]
			oUnit:sethide(0)
		end
		
		--显示boss房间门口路障
		for r = 1, #boosroom_doorblocks, 1 do
			local oUnit = boosroom_doorblocks[r]
			oUnit:sethide(0)
		end
		
		--显示围墙
		for r = 1, #xlobj_units, 1 do
			local cha = xlobj_units[r]
			local eu = hApi.findSceobjByCha(cha)
			if eu then
				eu:sethide(0)
			end
		end
		
		--显示墙体特效贴图集
		for r = 1, #xlobj_sprites, 1 do
			local sprite = xlobj_sprites[r]
			sprite:setVisible(true)
		end
		
		--显示npc单位集
		for r = 1, #npc_units, 1 do
			local oUnit = npc_units[r]
			oUnit:sethide(0)
		end
		
		--显示小兵
		world:enumunit(function(eu)
			if (eu.attr.regionIdBelong == regionId) then
				--只显示英雄和小兵和砖块
				if (eu.data.type == hVar.UNIT_TYPE.UNIT) or (eu.data.type == hVar.UNIT_TYPE.HERO) or (eu.data.type == hVar.UNIT_TYPE.UNITBROKEN) then
					eu:sethide(0)
				end
			end
		end)
		
		--返回值
		retX = transport_px
		retY = transport_py
	end
	
	--移除之前的宇宙层控件
	if (prevoisIdx > 0) then
		local regionDataPrev = d.randommapInfo[prevoisIdx]
		
		--前一层远景物件
		local farObj = regionDataPrev.universe_farobj
		if (type(farObj) == "table") then
			local node = farObj.node
			for n = 1, #node, 1 do
				local nodei = node[n]
				worldLayer:removeChild(nodei, true)
			end
			
			farObj.camX = 0
			farObj.camY = 0
		end
		
		--前一层中景物件
		local middleObj = regionDataPrev.universe_middleobj
		if (type(middleObj) == "table") then
			local node = middleObj.node
			for n = 1, #node, 1 do
				local nodei = node[n]
				worldLayer:removeChild(nodei, true)
			end
			
			middleObj.camX = 0
			middleObj.camY = 0
		end
		
		--前一层近景物件
		local nearObj = regionDataPrev.universe_nearobj
		if (type(nearObj) == "table") then
			local node = nearObj.node
			for n = 1, #node, 1 do
				local nodei = node[n]
				worldLayer:removeChild(nodei, true)
			end
			
			nearObj.camX = 0
			nearObj.camY = 0
		end
		
		--隐藏前一层的部分界面和单位
		local render_sprites = regionDataPrev.render_sprites --地面装饰物件贴图集
		local tex_sprites = regionDataPrev.tex_sprites --地板贴图集
		local pointer_in_units = regionDataPrev.pointer_in_units --指向boss入口的箭头单位集
		local pointer_out_units = regionDataPrev.pointer_out_units --指向boss出的箭头单位集
		local boosroom_doorblocks = regionDataPrev.boosroom_doorblocks --boss房间门口路障
		local xlobj_units = regionDataPrev.xlobj_units --场景物件单位集
		local xlobj_sprites = regionDataPrev.xlobj_sprites --墙体特效贴图集
		local npc_units = regionDataPrev.npc_units --npc单位集
		local blood_effects = regionDataPrev.blood_effects --飙血特效集
		local drop_units = regionDataPrev.drop_units --掉落的道具单位集
		
		--隐藏地面装饰物件贴图集
		for r = 1, #render_sprites, 1 do
			local sprite = render_sprites[r]
			sprite:setVisible(false)
		end
		
		--隐藏地板贴图集
		for r = 1, #tex_sprites, 1 do
			local sprite = tex_sprites[r].sprite
			sprite:setVisible(false)
		end
		
		--隐藏指向boss入口的箭头单位集
		for r = 1, #pointer_in_units, 1 do
			local oUnit = pointer_in_units[r]
			oUnit:sethide(1)
		end
		
		--隐藏boss房间门口路障
		for r = 1, #boosroom_doorblocks, 1 do
			local oUnit = boosroom_doorblocks[r]
			oUnit:sethide(1)
		end
		
		--隐藏围墙
		for r = 1, #xlobj_units, 1 do
			local cha = xlobj_units[r]
			local eu = hApi.findSceobjByCha(cha)
			if eu then
				eu:sethide(1)
			end
		end
		
		--隐藏墙体特效贴图集
		for r = 1, #xlobj_sprites, 1 do
			local sprite = xlobj_sprites[r]
			sprite:setVisible(false)
		end
		
		--隐藏npc单位集
		for r = 1, #npc_units, 1 do
			local oUnit = npc_units[r]
			oUnit:sethide(1)
		end
		
		--隐藏小兵
		world:enumunit(function(eu)
			if (eu.attr.regionIdBelong == prevoisIdx) then
				--只隐藏英雄和小兵和砖块
				if (eu.data.type == hVar.UNIT_TYPE.UNIT) or (eu.data.type == hVar.UNIT_TYPE.HERO) or (eu.data.type == hVar.UNIT_TYPE.UNITBROKEN) then
					eu:sethide(1)
				end
			end
		end)
	end
	
	--释放资源
	local regionPoint = regionData.regionPoint
	local avatarInfoId = regionData.avatarInfoId
	local tMultiply = hVar.RANDMAP_REGION_POINT_MULTIPLY[regionPoint]
	--local avatarInfoId = tMultiply.avatarInfoId or 0 --皮肤id
	--if (avatarInfoId <= 0) then
	--	avatarInfoId = oWorld:random(1, hVar.RANDMAP_ROOM_AVATAR_INFO.RandRange)
	--end
	local random_ObjectInfo = hVar.RANDMAP_ROOM_AVATAR_INFO[avatarInfoId]
	--释放远景层资源
	local farobj = random_ObjectInfo.farobj
	if farobj then
		local tImg = farobj.img
		for i = 1, #tImg, 1 do
			local imgFileName = tImg[i]
			local texture = CCTextureCache:sharedTextureCache():textureForKey(imgFileName)
			if (texture) then
				CCTextureCache:sharedTextureCache():removeTexture(texture)
				print("释放宇宙层远景物件图！", imgFileName)
			end
		end
	end
	
	--释放中景层资源
	local middleobj = random_ObjectInfo.middleobj
	if middleobj then
		local tImg = middleobj.img
		for i = 1, #tImg, 1 do
			local imgFileName = tImg[i]
			local texture = CCTextureCache:sharedTextureCache():textureForKey(imgFileName)
			if (texture) then
				CCTextureCache:sharedTextureCache():removeTexture(texture)
				print("释放宇宙层中景物件图！", imgFileName)
			end
		end
	end
	
	--释放近景层资源
	local nearobj = random_ObjectInfo.nearobj
	if nearobj then
		local tImg = nearobj.img
		for i = 1, #tImg, 1 do
			local imgFileName = tImg[i]
			if (type(imgFileName) == "string") then
				local texture = CCTextureCache:sharedTextureCache():textureForKey(imgFileName)
				if (texture) then
					CCTextureCache:sharedTextureCache():removeTexture(texture)
					print("释放宇宙层近景物件图！", imgFileName)
				end
			end
		end
	end
	
	return retX, retY
end

--生成一个单位
--offX: 统一偏移x
--offY: 统一偏移y
---@param ret table 结果返回
---@param strType string 单位类型["group","unit"]
---@param id number 出怪组配置ID，hVar.RANDMAP_ROOM_ENEMY_GROUP[id]
---@param wave number 波数
---@param offsetX number|table 偏移X，若table则为随机参数
---@param offsetY number|table 偏移Y，若table则为随机参数
---@param angle number facing朝向角度
---@param side number TODO: 阵营？
---@param roadPointType number 随机地图小兵路点类型<hVar.RANDMAP_ROADPOINT_TYPE>
function __AddOneEnemy(ret, world, strType, id, wave, offsetX, offsetY, angle, side, roadPointType, x0, y0, w0, h0, tTerminalPos, offX, offY, roomXLPos, roomYTPos, bIgnoreBlock, regionId)
	local mapInfo = world.data.tdMapInfo
	local regionData = world.data.randommapInfo[regionId]
	local regionPoint = regionData.regionPoint
	local mutation_count = regionData.mutation_count --突变次数
	local tMultiply = hVar.RANDMAP_REGION_POINT_MULTIPLY[regionPoint]
	local grouplimit = tMultiply.grouplimit or {} --组数量上限限制
	local mutation_maxcount = tMultiply.mutation_maxcount or 0 --最大突变次数
	
	local PIX_SIZE = 16 * 3
	
	if (strType == "group") then
		local tGroup = hVar.RANDMAP_ROOM_ENEMY_GROUP[id]
		if tGroup then
			-- 总偏移
			if (type(offsetX) == "number") then
				offX = offX + offsetX
			elseif (type(offsetX) == "table") then
				offX = offX + world:random(offsetX[1], offsetX[2])
			end
			
			if(type(offsetY) == "number") then
				offY = offY + offsetY
			elseif (type(offsetY) == "table") then
				offY = offY + world:random(offsetY[1], offsetY[2])
			end
			
			--优先读组第n波，没有就读第1波数据
			local tGroupWave = tGroup.waves[wave] or tGroup.waves[1]
			for tg = 1, #tGroupWave, 1 do
				local strType_i = tGroupWave[tg].type or "unit"
				local id_i = 0
				if (strType_i == "group") then
					id_i = tGroupWave[tg].groupId
				elseif (strType_i == "unit") then
					id_i = tGroupWave[tg].unidId
				elseif (strType_i == "randunit") then
					local randId_i = tGroupWave[tg].randId
					local tRand_i = hVar.RANDMAP_ROOM_ENEMY_UNIT[randId_i]
					local radnIdx_i = world:random(1, #tRand_i)
					
					strType_i = "unit"
					id_i = tRand_i[radnIdx_i]
				end
				local offsetX_i = tGroupWave[tg].offsetX or 0
				local offsetY_i = tGroupWave[tg].offsetY or 0
				local angle_i = tGroupWave[tg].angle or 0
				local side_i = tGroupWave[tg].side or side or 22 --魏国
				local roadPointType_i = tGroupWave[tg].roadPointType_i
				
				--print("group __AddOneEnemy", strType_i, id_i)
				__AddOneEnemy(ret, world, strType_i, id_i, wave, offsetX_i, offsetY_i, angle_i, side_i, roadPointType_i, x0, y0, w0, h0, tTerminalPos, offX, offY, roomXLPos, roomYTPos, nil, regionId)
			end
		end
	elseif (strType == "unit") then
		--单位有几率突变
		-- TODO: 突变是什么效果？
		if (mutation_count < mutation_maxcount) then
			local tMutation = hVar.RANDMAP_ROOM_UNIT_MUTATION[id]
			if tMutation then
				local probability = tMutation.probability
				local tounit = tMutation.tounit
				local randVaule = world:random(1, 100)
				
				--突变
				if (randVaule <= probability) then
					if (type(tounit) == "number") then
						id = tounit
					elseif (type(tounit) == "table") then
						local randIdx = world:random(1, #tounit)
						id = tounit[randIdx]
					end
					
					--存储新突变次数
					local mutation_count_new = mutation_count + 1
					mutation_count = mutation_count_new
					regionData.mutation_count = mutation_count_new --突变次数
				end
			end
		end
		
		--检测本关卡单位是否已达添加最大次数
		local randPosX = 0
		local randPosY = 0
		
		local ox = offsetX
		local oy = offsetY
		local ox0 = ox
		local oy0 = oy
		
		if (type(ox) == "number") and (type(oy) == "number") then
			randPosX = x0 + ox0 + offX
			randPosY = y0 + oy0 + offY
		else
			--随机坐标（不超出区域边界）
			
			if (type(ox) == "table") then
				ox0 = world:random(ox[1], ox[2])
			end
			if (type(oy) == "table") then
				oy0 = world:random(oy[1], oy[2])
			end
				
			randPosX = x0 + ox0 + offX
			randPosY = y0 + oy0 + offY
		end
		
		--print("id=", id)
		
		local tabU = hVar.tab_unit[id]
		if (tabU == nil) then
			print("tabU=nil, id=", id)
		end
		local box = tabU.box or {}
		local eu_bx, eu_by, eu_bw, eu_bh = box[1], box[2], box[3], box[4] --单位的包围盒
		
		--[[
		--创建单位
		local randPosX = 0
		local randPosY = 0
		
		--随机坐标，box不与边界重叠
		while true do
			randPosX = world:random(xl, xr)
			randPosY = world:random(yt, yb)
			
			local eu_center_x = randPosX + (eu_bx + eu_bw / 2) --单位的中心点x位置
			local eu_center_y = randPosY + (eu_by + eu_bh / 2) --单位的中心点y位置
			local eu_xl = eu_center_x - eu_bw / 2
			local eu_xr = eu_center_x + eu_bw / 2
			local eu_yl = eu_center_y - eu_bh / 2
			local eu_yr = eu_center_y + eu_bh / 2
			
			--box在里面
			if (eu_xl > (xl+PIX_SIZE)) or (eu_xr < (xr-PIX_SIZE)) or (eu_yl > (yt+PIX_SIZE)) or (eu_yr < (yb-PIX_SIZE)) then
				break
			end
		end
		]]
		
		--[[
		--放置在终点
		if tTerminalPos then
			local rd = world:random(1, #tTerminalPos)
			randPosX = tTerminalPos[rd].x * PIX_SIZE + roomXLPos / PIX_SIZE * PIX_SIZE + ox0 + offX
			randPosY = tTerminalPos[rd].y * PIX_SIZE + roomYTPos / PIX_SIZE * PIX_SIZE + oy0 + offY
		end
		]]
		
		local facing = angle --world:random(0, 360)
		local nOwner = side or 22 --魏国
		local nLv = 1
		local nStar = 1
		--god.data.facing
		--生成小兵
		if (tabU.type == hVar.UNIT_TYPE.UNIT) then
			randPosX, randPosY = hApi.Scene_GetSpace(randPosX, randPosY, 120)
		end
		
		--可破坏物件，和障碍坐标一致
		if (tabU.type == hVar.UNIT_TYPE.UNITBROKEN) then
			randPosX = math.floor(randPosX/24) * 24 + 12
			randPosY = math.floor(randPosY/24) * 24 - 12
		end
		
		local oUnit = nil
		
		--场景物件
		--if (tabU.xlobj ~= nil) then
		--	hApi.setEditorID(id)
		--	world:addsceobj(id,nil,nil,tabU.xlobj,"xlobj",tabU.scale,facing,randPosX,randPosY,tabU.zOrder)
		--else
		--	oUnit = world:addunit(id, nOwner, nil ,nil, facing, randPosX, randPosY, nil, nil, nLv, nStar)
		--end
		
		oUnit = world:addunit(id, nOwner, nil ,nil, facing, randPosX, randPosY, nil, nil, nLv, nStar)
		--触发事件：添加单位
		hGlobal.event:call("Event_UnitBorn", oUnit)
		
		--单位所属的随机地图的小关数（用于效率优化）
		oUnit.attr.regionIdBelong = regionId
		
		--小兵、英雄、塔加路点
		if (tabU.type == hVar.UNIT_TYPE.UNIT) or (tabU.type == hVar.UNIT_TYPE.HERO) or (tabU.type == hVar.UNIT_TYPE.TOWER) then
			local pathList = mapInfo.pathList
			local pathId = #pathList + 1 --路线索引
			local formation = hVar.TD_DEPLOY_TYPE.ONE_SAME_DISTANCE --阵型
			local formationPos = 1 --阵型位置
			local rpIdx = 1 --当前路点索引
			
			--编辑路点
			local path = {}
			path[formation] = {}
			path[formation][formationPos] = {}
			local roadPointList = path[formation][formationPos]
			
			--print("roadPointType=", roadPointType)
			--roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM
			
			-- 判断战车随机地图小兵路点类型
			if (roadPointType == hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL) then --横向走
				roadPointList[#roadPointList+1] = {x = x0 + PIX_SIZE, y = randPosY,}
				roadPointList[#roadPointList+1] = {x = x0 + w0 - PIX_SIZE, y = randPosY,}
			elseif (roadPointType == hVar.RANDMAP_ROADPOINT_TYPE.VERTICAL) then --竖向走
				roadPointList[#roadPointList+1] = {x = randPosX, y = y0 + PIX_SIZE,}
				roadPointList[#roadPointList+1] = {x = randPosX, y = y0 + h0 - PIX_SIZE,}
			elseif (roadPointType == hVar.RANDMAP_ROADPOINT_TYPE.SKEW_LEFT) then --左斜走
				roadPointList[#roadPointList+1] = {x = x0, y = y0,}
				roadPointList[#roadPointList+1] = {x = x0 + w0, y = y0 + h0,}
			elseif (roadPointType == hVar.RANDMAP_ROADPOINT_TYPE.SKEW_RIGHT) then --右斜走
				roadPointList[#roadPointList+1] = {x = x0 + w0, y = y0,}
				roadPointList[#roadPointList+1] = {x = x0, y = y0 + h0,}
			elseif (roadPointType == hVar.RANDMAP_ROADPOINT_TYPE.CIRCLE_CLOCKWISE) then --圆型走（顺时针）
				roadPointList[#roadPointList+1] = {x = x0, y = y0,}
				roadPointList[#roadPointList+1] = {x = x0 + w0, y = y0,}
				roadPointList[#roadPointList+1] = {x = x0 + w0, y = y0 + h0,}
				roadPointList[#roadPointList+1] = {x = x0, y = y0 + h0,}
			elseif (roadPointType == hVar.RANDMAP_ROADPOINT_TYPE.CIRCLE_ANTI_CLOCKWISE) then --圆型走（逆时针）
				roadPointList[#roadPointList+1] = {x = x0, y = y0,}
				roadPointList[#roadPointList+1] = {x = x0, y = y0 + h0,}
				roadPointList[#roadPointList+1] = {x = x0 + w0, y = y0 + h0,}
				roadPointList[#roadPointList+1] = {x = x0 + w0, y = y0,}
			elseif (roadPointType == hVar.RANDMAP_ROADPOINT_TYPE.RANDOM) then --随机走
				--随机20个路点
				for r = 1, 20, 1 do
					while true do
						local rx = world:random(x0, x0 + w0)
						local ry = world:random(y0, y0 + h0)
						local result = xlScene_IsGridBlock(g_world, rx / 24, ry / 24) --某个坐标是否是障碍
						if (result == 0) then
							roadPointList[#roadPointList+1] = {x = rx, y = ry,}
							break
						end
					end
				end
			else
				--无路点
			end
			
			--存储
			pathList[pathId] = path
			
			--设置路点
			if (#roadPointList > 0) then
				oUnit:setRoadPoint(pathId, formation, formationPos, rpIdx)
				oUnit.data.roadPoint[4] = hVar.ROLE_ROAD_POINT_TYPE.ROAD_POINT_CIRCLE --循环路点
			end
		end
		
		--[[
		if (tabU.xlobj ~= nil) then
			local zOrder = 0
			if tabU.zOrder and type(tabU.zOrder)=="number" then
				zOrder = tabU.zOrder
			end
			if oUnit.handle._c and (zOrder ~= 0) then
				xlChaSetZOrderOffset(oUnit.handle._c, zOrder)
				--print("xlChaSetZOrderOffset", tabU.type, tabU.zOrder)
				oUnit:setPos(randPosX-1, randPosY) --程序bug，需要设置一次pos才生效zorder
			end
		end
		]]
		
		--print("addunit", id, nOwner, nil ,nil, facing, randPosX, randPosY, nil, nil, nLv, nStar)
		--设置绝对坐标
		--oUnit:setPos(randPosX, randPosY, facing)
		
		--可破坏物件四周加物件
		if (not bIgnoreBlock) then
			if (id == hVar.UNITBROKEN_STONE_ORINGIN_ID) or (id == hVar.UNITBROKEN_STONE_CHANGETO_ID) or (id == hVar.UNITBROKEN_STONE_GOLD_ID) then
				oUnit:_addBlockArount()
			end
		end
		
		--刷新动态障碍
		if oUnit then
			oUnit:_addblock()
		end
		
		--添加的单位表
		ret[#ret+1] = oUnit
		
		return oUnit
	end
end

--生成指定区域的随机地图的野怪
--参数 bGenerateNornal: 是否生成普通房间野怪
--参数 bGenerateBoss: 是否生成BOSS房间野怪
function hApi.CreateRandMapEnemys(world, regionId, bGenerateNornal, bGenerateBoss)
	local d = world.data
	local mapInfo = world.data.tdMapInfo
	local regionData = d.randommapInfo[regionId]
	
	local worldLayer = world.handle.worldLayer
	local rooms = regionData.rooms_new --房间信息
	--local roomgroup = regionData.roomgroup --房间组信息
	local offsetX = regionData.regoin_xl --左上角x坐标
	local offsetY = regionData.regoin_yt --左上角y坐标
	local regoin_xr = regionData.max_px --右下角x坐标
	local regoin_yb = regionData.max_py --右下角y坐标
	--local transport_px = regionData.transport_px --传送点x坐标
	--local transport_py = regionData.transport_py --传送点y坐标
	local avatarInfoId = regionData.avatarInfoId
	local random_ObjectInfo = hVar.RANDMAP_ROOM_AVATAR_INFO[avatarInfoId]
	local PIX_SIZE = 16 * 3
	
	--返回值
	local retX, retY = regionData.transport_px, regionData.transport_py
	
	--遍历全部区域
	local bTransported = false --传送点
	local bTransportedBack = false --传送点返回
	
	local regionPoint = regionData.regionPoint
	local tMultiply = hVar.RANDMAP_REGION_POINT_MULTIPLY[regionPoint]
	local tonext = tMultiply.tonext
	local toprevious = tMultiply.toprevious
	local terminal = tMultiply.terminal --最后一关？
	local grouplimit = tMultiply.grouplimit or {} --组数量上限限制
	
	local render_sprites = regionData.render_sprites --地面装饰物件贴图集
	local tex_sprites = regionData.tex_sprites --地板贴图集
	local pointer_in_units = regionData.pointer_in_units --指向boss入口的箭头单位集
	local pointer_out_units = regionData.pointer_out_units --指向boss出的箭头单位集
	local boosroom_doorblocks = regionData.boosroom_doorblocks --boss房间门口路障
	--local boss_groupId = regionData.boss_groupId --BOSS的groupId（用于boss的唯一性）
	local roomgroupSendArmyList = regionData.roomgroupSendArmyList --房间组发兵表
	local currenttime = world:gametime()
	
	--统计组添加次数
	local tGroupAddCountList = {}
	
	--第一个区域没有返回点
	if (not toprevious) then
		bTransportedBack = true
	end
	
	--最后一个区域没有传送点
	if (not tonext) then
		bTransported = true
	end
	
	for i = 1, #rooms, 1 do
		local tRegion = rooms[i]
		local roomType = 0
		local strRoomType = tRegion.Roomtype --区域类型
		local roomPosX = tRegion.x + offsetX / PIX_SIZE
		local roomPosY = tRegion.y + offsetY / PIX_SIZE
		local roomWidth = tRegion.w
		local roomHeight = tRegion.h
		local tTerminalPos = tRegion.TerminalPos --终点坐标集
		
		if (strRoomType == "normal") then --普通房间
			if (roomWidth*PIX_SIZE < hVar.RANDMAP_ROOM_NORMAL_BIG_EDGE) or (roomHeight*PIX_SIZE < hVar.RANDMAP_ROOM_NORMAL_BIG_EDGE) then
				roomType = hVar.RANDMAP_ROOMTYPE.ROOM_NORMAL_SMALL
			else
				roomType = hVar.RANDMAP_ROOMTYPE.ROOM_NORMAL_BIG
			end
		elseif (strRoomType == "road") then --通路、断头路
			if tTerminalPos then
				roomType = hVar.RANDMAP_ROOMTYPE.ROOM_ROAD_TERMINAL
			else
				if (roomWidth >= roomHeight) then
					roomType = hVar.RANDMAP_ROOMTYPE.ROOM_ROAD_W
				else
					roomType = hVar.RANDMAP_ROOMTYPE.ROOM_ROAD_H
				end
			end
		elseif (strRoomType == "boss") then --BOSS大房间
			roomType = hVar.RANDMAP_ROOMTYPE.ROOM_BOSS
			
			--终极boss房间
			if terminal then
				roomType = hVar.RANDMAP_ROOMTYPE.ROOM_BOSS_TERNIMAL
			end
		end
		
		--普通房间逻辑、boss房间逻辑
		if (bGenerateNornal and (roomType ~= hVar.RANDMAP_ROOMTYPE.ROOM_BOSS) and (roomType ~= hVar.RANDMAP_ROOMTYPE.ROOM_BOSS_TERNIMAL))
		or (bGenerateBoss and ((roomType == hVar.RANDMAP_ROOMTYPE.ROOM_BOSS) or (roomType == hVar.RANDMAP_ROOMTYPE.ROOM_BOSS_TERNIMAL))) then
			--区域四个角
			local xl = roomPosX * PIX_SIZE
			local yt = roomPosY * PIX_SIZE
			local xr = xl + roomWidth * PIX_SIZE
			local yb = yt + roomHeight * PIX_SIZE
			
			--随机一个单位
			local stageId = world.data.randommapStage
			local tRoomEnemyCfg = hVar.RANDMAP_ENEMY_CONFIG[stageId] or hVar.RANDMAP_ENEMY_CONFIG[#hVar.RANDMAP_ENEMY_CONFIG]
			local tConfig = tRoomEnemyCfg[roomType]
			if tConfig then
				local enemys = tConfig.enemys
				if enemys then
					--随机一组
					local enemyIdx = 0
					
					--boss房间，检测唯一性
					if (roomType == hVar.RANDMAP_ROOMTYPE.ROOM_BOSS) or (roomType == hVar.RANDMAP_ROOMTYPE.ROOM_BOSS_TERNIMAL) then
						while true do
							enemyIdx = world:random(1, #enemys)
							local groupId1 = enemys[enemyIdx][1] --取本组的第一个元素作为比较的groupId
							
							--依次比较是否和前几小关的boss组重复
							local bExisted = false
							for i = 1, regionId, 1 do
								local regionData_i = d.randommapInfo[i]
								local boss_groupId_i = regionData_i.boss_groupId --BOSS的groupId（用于boss的唯一性）
								if (boss_groupId_i == groupId1) then --重复了
									--print("重复了[" .. i .. "] = " .. groupId1)
									bExisted = true
									break
								end
							end
							
							--不重复才能通过校验
							if (not bExisted) then
								--存储
								regionData.boss_groupId = groupId1 --BOSS的groupId（用于boss的唯一性）
								
								break
							end
						end
					else
						enemyIdx = world:random(1, #enemys)
					end
					local enemys_n = enemys[enemyIdx]
					local unitId = 0
					
					--优先生成传送点
					if (roomType == hVar.RANDMAP_ROOMTYPE.ROOM_ROAD_TERMINAL) then
						if (bGenerateNornal and (roomType ~= hVar.RANDMAP_ROOMTYPE.ROOM_BOSS) and (roomType ~= hVar.RANDMAP_ROOMTYPE.ROOM_BOSS_TERNIMAL)) then --普通房间
							--if (not bTransported) then
							--	bTransported = true
							--	
							--	unitId = hVar.RANDMAP_ENEMY_TRANSPORT_ID
							--elseif (not bTransportedBack) then
							if (not bTransportedBack) then
								bTransportedBack = true
								
								unitId = hVar.RANDMAP_ENEMY_TRANSPORT_BACK_ID
							end
						end
						
						if (unitId > 0) then
							local randPosX = (xl+xr)/2
							local randPosY = (yt+yb)/2
							
							--放置在终点
							if tTerminalPos then
								local rd = world:random(1, #tTerminalPos)
								randPosX = tTerminalPos[rd].x * PIX_SIZE + offsetX / PIX_SIZE * PIX_SIZE
								randPosY = tTerminalPos[rd].y * PIX_SIZE + offsetY / PIX_SIZE * PIX_SIZE
							end
							
							local facing = world:random(0, 360)
							local nOwner = 22 --魏国
							local nLv = 1
							local nStar = 1
							--god.data.facing
							--生成传送点或传送点返回
							local oUnit = world:addunit(unitId, nOwner, nil ,nil, facing, randPosX, randPosY, nil, nil, nLv, nStar)
							--触发事件：添加单位
							hGlobal.event:call("Event_UnitBorn", oUnit)
							--print("addunit", unitId, nOwner, nil ,nil, facing, randPosX, randPosY, nil, nil, nLv, nStar)
							local zOrder = -100
							xlChaSetZOrderOffset(oUnit.handle._c, zOrder)
							--print("xlChaSetZOrderOffset", tabU.type, tabU.zOrder)
							oUnit:setPos(randPosX-1, randPosY) --程序bug，需要设置一次pos才生效zorder
							
							--添加传送点信息
							--if (unitId == hVar.RANDMAP_ENEMY_TRANSPORT_ID) then
								--[[
								d.tdMapInfo.portal[#d.tdMapInfo.portal + 1] =
								{
									x = randPosX,
									y = randPosY,
									owner = 1,
									searchRadius = 100,
									startConditionType = 2, --区域传送
									startCondition = nil,
									portalType = 2, --区域传送
									toX = nil,
									toY = nil,
									toMap = nil,
									isShow = false,
									eu = oUnit,
									viewReset = nil,
									enterMusic = "bgm006",
								}
								
								--修改传送返回点
								regionData.transport_back_px = (xl+xr)/2 --传送点返回x坐标
								regionData.transport_back_py = (yt+yb)/2 --传送点返回y坐标
								
								print("传送返回点", regionId, regionData.transport_back_px, regionData.transport_back_py)
								]]
								
							if (unitId == hVar.RANDMAP_ENEMY_TRANSPORT_BACK_ID) then
								local tNormalMusicList = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}
								local randMusicIdx = math.random(1, #tNormalMusicList)
								d.tdMapInfo.portal[#d.tdMapInfo.portal + 1] =
								{
									x = randPosX,
									y = randPosY,
									owner = 1,
									searchRadius = 100,
									startConditionType = 3, --区域传送返回
									startCondition = nil,
									portalType = 3, --区域传送返回
									toX = nil,
									toY = nil,
									toMap = nil,
									isShow = false,
									eu = oUnit,
									viewReset = nil,
									enterMusic = tNormalMusicList[randMusicIdx],
								}
								
								--修改传送点
								local xm = tRegion.xm --相邻房间
								local ym = tRegion.ym --相邻房间
								if xm and ym then
									--相邻房间区域四个角
									local xm_near = xm * PIX_SIZE + offsetX / PIX_SIZE * PIX_SIZE
									local ym_near = ym * PIX_SIZE + offsetY / PIX_SIZE * PIX_SIZE
									
									regionData.transport_px = xm_near --传送点x坐标
									regionData.transport_py = ym_near --传送点y坐标
									regionData.transport_px, regionData.transport_py = hApi.Scene_GetSpace(regionData.transport_px, regionData.transport_py, 120)
									
									--将战车设置到此处
									local me = world:GetPlayerMe()
									local heros = me.heros
									local oHero = heros[1]
									local oUnit = oHero:getunit()
									local bForceSetPos = true
									oUnit:setPos(regionData.transport_px, regionData.transport_py, nil, bForceSetPos)
									print("传送点", regionId, regionData.transport_px, regionData.transport_py)
									
									--宠物也传送过来
									local rpgunits = world.data.rpgunits
									for u, u_worldC in pairs(rpgunits) do
										for _, walle_id in ipairs(hVar.MY_TANK_FOLLOW_ID) do
											if (u.data.id == walle_id) then
												u:setPos(regionData.transport_px, regionData.transport_py, nil, bForceSetPos)
											end
										end
									end
									
									--返回值
									retX = regionData.transport_px
									retY = regionData.transport_py
									
									--镜头聚焦
									hApi.setViewNodeFocus(regionData.transport_px, regionData.transport_py)
									--print("镜头聚焦3")
								end
							end
						end
					end
					
					if (unitId == 0) then
						--随机生成可放下box的区域组
						local xli = xl + PIX_SIZE
						local yti = yt + PIX_SIZE
						
						--列loop
						while true do
							--从行最左侧位置开始处理
							xli = xl + PIX_SIZE
							
							--本行的全部box
							local roomgroup_row = {}
							
							--铺完本行
							while true do
								--最左侧位置
								local roomWidthi = xr - xli
								local roomHeighti = yb - yti
								
								local enemys_valid_id = {}
								
								--提炼出可放得下的group
								for i = 1, #enemys_n, 1 do
									local unidGroupId = enemys_n[i] --单位组id
									local tGroup = hVar.RANDMAP_ROOM_ENEMY_GROUP[unidGroupId]
									local box = tGroup.box
									local box_x = box[1]
									local box_y = box[2]
									local box_w = box[3]
									local box_h = box[4]
									local box_width = box_w - box_x
									local box_height = box_h - box_y
									
									--box是否可被房间容纳
									if (box_width <= (roomWidthi - PIX_SIZE)) and (box_height <= (roomHeighti - PIX_SIZE)) then
										--box不与战车重叠
										local xli_l = xli+box_x
										local xli_r = xli+box_x+box_w
										local yti_t = yti+box_y
										local yti_b = yti+box_y+box_h
										local tank_box_wh = 480 --战车box
										local tank_x = regionData.transport_px
										local tank_y = regionData.transport_py
										local tank_xl = tank_x - tank_box_wh/2
										local tank_xr = tank_x + tank_box_wh/2
										local tank_yt = tank_y - tank_box_wh/2
										local tank_yb = tank_y + tank_box_wh/2
										
										--if ((tank_x >= xli_l) and (tank_x <= xli_r) and (tank_y >= yti_t) and (tank_y <= yti_b))
										--or ((tank_xl >= xli_l) and (tank_xl <= xli_r) and (tank_yt >= yti_t) and (tank_yt <= yti_b))
										--or ((tank_xr >= xli_l) and (tank_xr <= xli_r) and (tank_yt >= yti_t) and (tank_yt <= yti_b))
										--or ((tank_xl >= xli_l) and (tank_xl <= xli_r) and (tank_yb >= yti_t) and (tank_yb <= yti_b))
										--or ((tank_xr >= xli_l) and (tank_xr <= xli_r) and (tank_yb >= yti_t) and (tank_yb <= yti_b)) then
										--两个矩形是否重叠(相交)
										--BOSS房不受限制
										if (roomType ~= hVar.RANDMAP_ROOMTYPE.ROOM_BOSS) and (roomType ~= hVar.RANDMAP_ROOMTYPE.ROOM_BOSS_TERNIMAL)
										and hApi.RectIntersectRect(
										{X = tank_xl, Y = tank_yt}, {X = tank_xr, Y = tank_yt}, {X = tank_xr, Y = tank_yb}, {X = tank_xl, Y = tank_yb},
										{X = xli_l, Y = yti_t}, {X = xli_r, Y = yti_t}, {X = xli_r, Y = tank_yb}, {X = xli_l, Y = tank_yb}) then
											--
											--print("战车重叠！！！！！！！！！！！！！！！！！！")
										else
											--组未超过本区域最大次数
											local glmaxcount = grouplimit[unidGroupId] and grouplimit[unidGroupId].maxcount or math.huge
											local glcurrentcount = tGroupAddCountList[unidGroupId] or 0
											if (glcurrentcount < glmaxcount) then
												enemys_valid_id[#enemys_valid_id+1] = unidGroupId
											else
												--
												--print("组[" .. unidGroupId .. "]达最大次数！！！！！！！！！！！！！！！！！！")
											end
										end
									end
								end
								
								--随机一个
								if (#enemys_valid_id > 0) then
									local randIdx = world:random(1, #enemys_valid_id)
									local unidGroupId = enemys_valid_id[randIdx]
									local tGroup = hVar.RANDMAP_ROOM_ENEMY_GROUP[unidGroupId]
									local box = tGroup.box
									local box_x = box[1]
									local box_y = box[2]
									local box_w = box[3]
									local box_h = box[4]
									local box_width = box_w - box_x
									local box_height = box_h - box_y
									local px = xli - box_x
									local py = yti - box_y
									roomgroupSendArmyList[#roomgroupSendArmyList+1] = {groupId = unidGroupId, beginTick = currenttime, x = px, y = py, currentWave = 0, unitperWave = {},}
									roomgroup_row[#roomgroup_row+1] = {groupId = unidGroupId, x = px, y = py,}
									
									--[[
									--生成怪物
									for tg = 1, #tGroup, 1 do
										local strType = tGroup[tg].type or "unit"
										local id = 0
										if (strType == "group") then
											id = tGroup[tg].groupId
										elseif (strType == "unit") then
											id = tGroup[tg].unidId
										elseif (strType == "randunit") then
											local randId = tGroup[tg].randId
											local tRand = hVar.RANDMAP_ROOM_ENEMY_UNIT[randId]
											local radnIdx = world:random(1, #tRand)
											
											strType = "unit"
											id = tRand[radnIdx]
										end
										local ox = tGroup[tg].offsetX or 0
										local oy = tGroup[tg].offsetY or 0
										local ox0 = ox
										local oy0 = oy
										local angle = tGroup[tg].angle or 0
										local side = tGroup[tg].side or 22 --魏国
										local roadPointType = tGroup[tg].roadPointType
										local offX = 0
										local offY = 0
										local wave = 1
										
										--添加单个单位
										local ret = {}
										__AddOneEnemy(ret, world, strType, id, wave, ox, oy, angle, side, roadPointType, px, py, box_width, box_height, tTerminalPos, offX, offY, offsetX, offsetY, nil, regionId)
									end
									]]
									
									--添加统计组生成的次数
									local glcurrentcount = tGroupAddCountList[unidGroupId] or 0
									tGroupAddCountList[unidGroupId] = glcurrentcount + 1
									
									--重新计算最左侧
									xli = xli + box_width + 2
								else
									--本行已经没有可铺的box了，跳到下行
									--计算本行box的最下侧坐标y
									local cyb_max = yti
									for i = 1, #roomgroup_row, 1 do
										local groupId = roomgroup_row[i].groupId
										local gx = roomgroup_row[i].x
										local gy = roomgroup_row[i].y
										local tGroup = hVar.RANDMAP_ROOM_ENEMY_GROUP[groupId]
										local box = tGroup.box
										local box_x = box[1]
										local box_y = box[2]
										local box_w = box[3]
										local box_h = box[4]
										local box_width = box_w - box_x
										local box_height = box_h - box_y
										local cxr = gx + box_x + box_width
										local cyb = gy + box_y + box_height
										if (cyb > cyb_max) then
											cyb_max = cyb
										end
									end
									
									--跳到下一列
									yti = cyb_max + 2
									
									break
								end
							end
							
							--如果本行未铺任何box，说明无法继续铺下去，结束
							if (#roomgroup_row == 0) then
								break
							end
						end
					end
				end
			end
		end
		
		--普通房间逻辑，boss门口生成可破坏砖块
		if (bGenerateNornal) then
			if (roomType == hVar.RANDMAP_ROOMTYPE.ROOM_BOSS) or (roomType == hVar.RANDMAP_ROOMTYPE.ROOM_BOSS_TERNIMAL) then
				--print("bGenerateNornal=", bGenerateNornal, "roomType == hVar.RANDMAP_ROOMTYPE.ROOM_BOSS")
				local Doors = tRegion.Doors
				--print("Doors=", Doors)
				if Doors then
					--[[
					--门口封路生成可破坏砖块
					for d = 1, #Doors, 1 do
						local Door = Doors[d]
						local tDoor = Door.p
						for p = 2, #tDoor - 1, 1 do
							--添加单个单位
							local px = tDoor[p].x * PIX_SIZE + offsetX
							local py = tDoor[p].y * PIX_SIZE + offsetY
							--print(p, px, py)
							local angle = 0
							local side = 23 --中立无敌意
							local id = 5191 -- 5110 --可破坏砖块
							local bIgnoreBlock = true
							local ret = {}
							__AddOneEnemy(ret, world, "unit", id, 0, 0, 0, angle, side, 0, px, py, 0, 0, nil, 0, 0, 0, 0, bIgnoreBlock, regionId)
						end
					end
					]]
					
					--取中央门坐标
					local doorIdx_mid = math.ceil(#Doors / 2)
					local Door_mid = Doors[doorIdx_mid]
					local tDoor_mid = Door_mid.p
					local pIdx_mid = math.ceil(#tDoor_mid / 2)
					local px_mid = tDoor_mid[pIdx_mid].x * PIX_SIZE + offsetX
					local py_mid = tDoor_mid[pIdx_mid].y * PIX_SIZE + offsetY
					--print("px_mid=", px_mid)
					--print("py_mid=", py_mid)
					
					--取boss房的中心点坐标
					local boss_cx = roomPosX * PIX_SIZE + roomWidth * PIX_SIZE / 2
					local boss_cy = roomPosY * PIX_SIZE + roomHeight * PIX_SIZE / 2
					--print("boss_cx=", boss_cx)
					--print("boss_cy=", boss_cy)
					
					--计算区域触发点中心点
					local dis = math.sqrt((boss_cx - px_mid) * (boss_cx - px_mid) + (boss_cy - py_mid) * (boss_cy - py_mid))
					dis = math.floor(dis * 100) / 100 --保留2位有效数字，用于同步
					local RADIUS = dis --200 + PIX_SIZE * 2
					local reg_cx = px_mid + (boss_cx - px_mid) / dis * RADIUS
					local reg_cy = py_mid + (boss_cy - py_mid) / dis * RADIUS
					reg_cx = math.floor(reg_cx * 100) / 100 --保留2位有效数字，用于同步
					reg_cy = math.floor(reg_cy * 100) / 100 --保留2位有效数字，用于同步
					
					--添加区域触发事件
					if (not mapInfo.areatrigger) then
						mapInfo.areatrigger = {}
					end
					
					local areatrigger = {}
					mapInfo.areatrigger[#mapInfo.areatrigger+1] = areatrigger
					
					local tBossMusicList = {"music/boss_01", "music/boss_02","music/boss_03","music/boss_04",}
					local randMusicIdx = math.random(1, #tBossMusicList)
					areatrigger.areaTriggerRadius = RADIUS - PIX_SIZE * 2 --区域触发半径
					areatrigger.areaTriggerWorldX = reg_cx --区域点坐标x
					areatrigger.areaTriggerWorldY = reg_cy --区域点坐标y
					areatrigger.areaTriggerEnterCount = 1 --进入区域触发次数
					areatrigger.areaTriggerEnterSkillId  = 18060 --进入区域触发技能id
					areatrigger.areaTriggerEnterMusic = tBossMusicList[randMusicIdx] --进入区域触发背景音乐
					areatrigger.areaTriggerEnterIsBoss = 1 --进入区域是否是BOSS
					areatrigger.areaTriggerLeaveCount = 0 --离开区域触发次数
					areatrigger.areaTriggerLeaveSkillId = 0 --离开区域触发技能id
					areatrigger.areaTriggerLeaveMusic = "" --离开区域触发背景音乐
					
					areatrigger.areaTriggerFinishState = false --区域触发当前状态(true:在区域里 /false:不在区域里)
					
					areatrigger.areaTriggerEnterFinishCount = 0 --进入区域触发完成的次数
					areatrigger.areaTriggerLeaveFinishCount = 0 --离开区域触发完成的次数
					
					--门口生成箭头
					local dir = 0
					if (#Doors > 0) then
						local Door1 = Doors[1]
						local tDoor1 = Door1.p
						if (#tDoor1 >= 2) then
							--添加单个单位
							local px1_n = tDoor1[1].x
							local py1_n = tDoor1[1].y
							local px2_n = tDoor1[2].x
							local py2_n = tDoor1[2].y
							if (px1_n == px2_n) then --竖向
								if (px_mid > boss_cx) then
									dir = "r"
								else
									dir = "l"
								end
							elseif (py1_n == py2_n) then --横向
								if (py_mid > boss_cy) then
									dir = "d"
								else
									dir = "u"
								end
							end
						end
					end
					--print("dir=", dir)
					if (dir == "l") then --左侧
						--添加单个单位（箭头）
						for p = 1, 3, 1 do
							--箭头（已改为三个并一张图了，不需要创建3个了）
							if (p == 2) then
								local px = px_mid - PIX_SIZE - 12 - (p - 1) * PIX_SIZE
								local py = py_mid + PIX_SIZE - 18 --反的
								local angle = 0
								local side = 23 --中立无敌意
								local id = hVar.RANDMAP_ENEMY_JIANTOU_RIGHT
								local bIgnoreBlock = true
								local ret = {}
								local oUnit = __AddOneEnemy(ret, world, "unit", id, 0, 0, 0, angle, side, 0, px, py, 0, 0, nil, 0, 0, 0, 0, bIgnoreBlock, regionId)
								
								local zOrder = -100
								xlChaSetZOrderOffset(oUnit.handle._c, zOrder)
								--print("xlChaSetZOrderOffset", tabU.type, tabU.zOrder)
								oUnit:setPos(px-1, py) --程序bug，需要设置一次pos才生效zorder
								
								--存储箭头（左侧）
								pointer_in_units[#pointer_in_units+1] = oUnit
								
								--光照效果
								--if (p == 2) then
								local oUnit = __AddOneEnemy(ret, world, "unit", hVar.RANDMAP_ENEMY_JIANTOU_EFFECT, 0, 0, 0, angle, side, 0, px, py, 0, 0, nil, 0, 0, 0, 0, bIgnoreBlock, regionId)
								xlChaSetZOrderOffset(oUnit.handle._c, zOrder)
								--print("xlChaSetZOrderOffset", tabU.type, tabU.zOrder)
								oUnit:setPos(px-1, py) --程序bug，需要设置一次pos才生效zorder
								
								--存储光照（左侧）
								pointer_in_units[#pointer_in_units+1] = oUnit
							end
						end
					elseif (dir == "r") then --右侧
						--添加单个单位（箭头）
						for p = 1, 3, 1 do
							--箭头（已改为三个并一张图了，不需要创建3个了）
							if (p == 2) then
								local px = px_mid + PIX_SIZE + 64 + (p - 1) * PIX_SIZE
								local py = py_mid + PIX_SIZE - 12
								local angle = 0
								local side = 23 --中立无敌意
								local id = hVar.RANDMAP_ENEMY_JIANTOU_LEFT
								local bIgnoreBlock = true
								local ret = {}
								local oUnit = __AddOneEnemy(ret, world, "unit", id, 0, 0, 0, angle, side, 0, px, py, 0, 0, nil, 0, 0, 0, 0, bIgnoreBlock, regionId)
								
								local zOrder = -100
								xlChaSetZOrderOffset(oUnit.handle._c, zOrder)
								--print("xlChaSetZOrderOffset", tabU.type, tabU.zOrder)
								oUnit:setPos(px-1, py) --程序bug，需要设置一次pos才生效zorder
								
								--存储箭头（右侧）
								pointer_in_units[#pointer_in_units+1] = oUnit
								
								--光照效果
								--if (p == 2) then
								local oUnit = __AddOneEnemy(ret, world, "unit", hVar.RANDMAP_ENEMY_JIANTOU_EFFECT, 0, 0, 0, angle, side, 0, px, py, 0, 0, nil, 0, 0, 0, 0, bIgnoreBlock, regionId)
								xlChaSetZOrderOffset(oUnit.handle._c, zOrder)
								--print("xlChaSetZOrderOffset", tabU.type, tabU.zOrder)
								oUnit:setPos(px-1, py) --程序bug，需要设置一次pos才生效zorder
								
								--存储光照（右侧）
								pointer_in_units[#pointer_in_units+1] = oUnit
							end
						end
					elseif (dir == "u") then --上侧
						--添加单个单位（箭头）
						for p = 1, 3, 1 do
							--箭头（已改为三个并一张图了，不需要创建3个了）
							if (p == 2) then
								local px = px_mid + PIX_SIZE - 4
								local py = py_mid - PIX_SIZE - 36 - (p - 1) * PIX_SIZE
								local angle = 0
								local side = 23 --中立无敌意
								local id = hVar.RANDMAP_ENEMY_JIANTOU_DOWN
								local bIgnoreBlock = true
								local ret = {}
								local oUnit = __AddOneEnemy(ret, world, "unit", id, 0, 0, 0, angle, side, 0, px, py, 0, 0, nil, 0, 0, 0, 0, bIgnoreBlock, regionId)
								
								local zOrder = -100
								xlChaSetZOrderOffset(oUnit.handle._c, zOrder)
								--print("xlChaSetZOrderOffset", tabU.type, tabU.zOrder)
								oUnit:setPos(px-1, py) --程序bug，需要设置一次pos才生效zorder
								
								--存储箭头（上侧）
								pointer_in_units[#pointer_in_units+1] = oUnit
								
								--光照效果
								--if (p == 2) then
								local oUnit = __AddOneEnemy(ret, world, "unit", hVar.RANDMAP_ENEMY_JIANTOU_EFFECT, 0, 0, 0, angle, side, 0, px, py, 0, 0, nil, 0, 0, 0, 0, bIgnoreBlock, regionId)
								xlChaSetZOrderOffset(oUnit.handle._c, zOrder)
								--print("xlChaSetZOrderOffset", tabU.type, tabU.zOrder)
								oUnit:setPos(px-1, py) --程序bug，需要设置一次pos才生效zorder
								oUnit.handle._n:setRotation(90)
								
								--存储光照（上侧）
								pointer_in_units[#pointer_in_units+1] = oUnit
							end
						end
					elseif (dir == "d") then --下侧
						--添加单个单位（箭头）
						for p = 1, 3, 1 do
							--箭头（已改为三个并一张图了，不需要创建3个了）
							if (p == 2) then
								local px = px_mid + PIX_SIZE - 4
								local py = py_mid + PIX_SIZE + 58 + (p - 1) * PIX_SIZE
								local angle = 0
								local side = 23 --中立无敌意
								local id = hVar.RANDMAP_ENEMY_JIANTOU_UP
								local bIgnoreBlock = true
								local ret = {}
								local oUnit = __AddOneEnemy(ret, world, "unit", id, 0, 0, 0, angle, side, 0, px, py, 0, 0, nil, 0, 0, 0, 0, bIgnoreBlock, regionId)
								
								local zOrder = -100
								xlChaSetZOrderOffset(oUnit.handle._c, zOrder)
								--print("xlChaSetZOrderOffset", tabU.type, tabU.zOrder)
								oUnit:setPos(px-1, py) --程序bug，需要设置一次pos才生效zorder
								
								--存储箭头（下侧）
								pointer_in_units[#pointer_in_units+1] = oUnit
								
								--光照效果
								--if (p == 2) then
								local oUnit = __AddOneEnemy(ret, world, "unit", hVar.RANDMAP_ENEMY_JIANTOU_EFFECT, 0, 0, 0, angle, side, 0, px, py, 0, 0, nil, 0, 0, 0, 0, bIgnoreBlock, regionId)
								xlChaSetZOrderOffset(oUnit.handle._c, zOrder)
								--print("xlChaSetZOrderOffset", tabU.type, tabU.zOrder)
								oUnit:setPos(px-1, py) --程序bug，需要设置一次pos才生效zorder
								oUnit.handle._n:setRotation(90)
								
								--存储光照（下侧）
								pointer_in_units[#pointer_in_units+1] = oUnit
							end
						end
					end
					
					--检测入口箭头是否与地面装饰物重叠，删除重叠的装饰物
					for p = 1, #pointer_in_units, 1 do
						local oUnit = pointer_in_units[p]
						local hero_x, hero_y = hApi.chaGetPos(oUnit.handle) --箭头的位置
						local hero_bx, hero_by, hero_bw, hero_bh = oUnit:getbox() --单位的包围盒
						--print("单位的包围盒", hero_bx, hero_by, hero_bw, hero_bh)
						local hero_center_x = hero_x + (hero_bx + hero_bw / 2) --单位的中心点x位置
						local hero_center_y = hero_y + (hero_by + hero_bh / 2) --单位中心点y位置
						local eu_left_x = hero_center_x - hero_bw / 2 --左侧x
						local eu_right_x = hero_center_x + hero_bw / 2 --右侧x
						local eu_left_y = hero_center_y + hero_bh / 2 --上侧y
						local eu_right_y = hero_center_y - hero_bh / 2 --下侧y
						
						--依次遍历装饰物件
						for r = #render_sprites, 1, -1 do
							local sprite = render_sprites[r]
							local sprite_x, sprite_y = sprite:getPosition()
							local tSize = sprite:getContentSize()
							local sprite_bx, sprite_by, sprite_bw, sprite_bh = 0, 0, tSize.width, tSize.height --贴图的包围盒
							--print("贴图的包围盒", sprite_bx, sprite_by, sprite_bw, sprite_bh)
							local sprite_center_x = sprite_x --贴图的中心点x位置
							local sprite_center_y = -sprite_y --贴图中心点y位置
							local sprite_left_x = sprite_center_x - sprite_bw / 2 --左侧x
							local sprite_right_x = sprite_center_x + sprite_bw / 2 --右侧x
							local sprite_left_y = sprite_center_y + sprite_bh / 2 --上侧y
							local sprite_right_y = sprite_center_y - sprite_bh / 2 --下侧y
							
							--箭头与地面装饰物重叠
							if hApi.RectIntersectRect(
							{X = sprite_left_x, Y = sprite_left_y}, {X = sprite_right_x, Y = sprite_left_y}, {X = sprite_right_x, Y = sprite_right_y}, {X = sprite_left_x, Y = sprite_right_y},
							{X = eu_left_x, Y = eu_left_y}, {X = eu_right_x, Y = eu_left_y}, {X = eu_right_x, Y = eu_right_y}, {X = eu_left_x, Y = eu_right_y}) then
								--
								--print("箭头与地面装饰物重叠 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")
								--删除重叠的地面装饰物
								worldLayer:removeChild(sprite, true)
								table.remove(render_sprites, r)
							end
						end
						
						--依次遍历地表贴图，是否和箭头重叠，替换为普通地表贴图
						for r = #tex_sprites, 1, -1 do
							local index = tex_sprites[r].index
							local sprite = tex_sprites[r].sprite
							--local tex_x = tex_sprites[r].tex_x
							--local tex_y = tex_sprites[r].tex_y
							local tile_w = tex_sprites[r].w
							local tile_h = tex_sprites[r].h
							
							if (index == 3) then
								local sprite_x, sprite_y = sprite:getPosition()
								--local tSize = sprite:getContentSize()
								--local sprite_bx, sprite_by, sprite_bw, sprite_bh = 0, 0, tSize.width, tSize.height --贴图的包围盒
								--print("贴图的包围盒", sprite_bx, sprite_by, sprite_bw, sprite_bh)
								local sprite_center_x = sprite_x  + tile_w / 2 --贴图的中心点x位置
								local sprite_center_y = -sprite_y + tile_h / 2 --贴图中心点y位置
								local sprite_left_x = sprite_center_x - tile_w / 2 --左侧x
								local sprite_right_x = sprite_center_x + tile_w / 2 --右侧x
								local sprite_left_y = sprite_center_y + tile_h / 2 --上侧y
								local sprite_right_y = sprite_center_y - tile_h / 2 --下侧y
								
								--箭头与地表贴图重叠
								if hApi.RectIntersectRect(
								{X = sprite_left_x, Y = sprite_left_y}, {X = sprite_right_x, Y = sprite_left_y}, {X = sprite_right_x, Y = sprite_right_y}, {X = sprite_left_x, Y = sprite_right_y},
								{X = eu_left_x, Y = eu_left_y}, {X = eu_right_x, Y = eu_left_y}, {X = eu_right_x, Y = eu_right_y}, {X = eu_left_x, Y = eu_right_y}) then
									--删除重叠的地表贴图
									--print("地板和箭头重叠 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")
									worldLayer:removeChild(sprite, true)
									table.remove(tex_sprites, r)
									
									--替换为普通地板2
									local wallimg = random_ObjectInfo.wallimg
									local imgFileName = wallimg
									local texture = CCTextureCache:sharedTextureCache():textureForKey(imgFileName)
									if (not texture) then
										texture = CCTextureCache:sharedTextureCache():addImage(imgFileName)
										--print("加载" .. imgFileName .. "！")
									end
									local ground = random_ObjectInfo.ground
									local indexNew = 2
									local tex_x = ground[indexNew].x
									local tex_y = ground[indexNew].y
									local sprite = CCSprite:createWithTexture(texture, CCRectMake(tex_x, tex_y, tile_w, tile_h))
									sprite:setAnchorPoint(ccp(0, 1))
									sprite:setPosition(ccp(sprite_x, sprite_y))
									worldLayer:addChild(sprite, 20)
									
									tex_sprites[#tex_sprites+1] = {sprite = sprite, x = sprite_x, y = -sprite_y, w = tile_w, h = tile_h, index = indexNew,}
									
									--释放地板资源
									local wallimg = random_ObjectInfo.wallimg
									if wallimg then
										local imgFileName = wallimg
										local texture = CCTextureCache:sharedTextureCache():textureForKey(imgFileName)
										if (texture) then
											CCTextureCache:sharedTextureCache():removeTexture(texture)
											print("释放墙体物件图！", imgFileName)
										end
									end
									
									--[[
									--调试用的代码
									local texture = CCTextureCache:sharedTextureCache():textureForKey("data/image/effect/zhadan.png")
									if (not texture) then
										texture = CCTextureCache:sharedTextureCache():addImage("data/image/effect/zhadan.png")
										--print("加载" .. imgFileName .. "！")
									end
									local sprite = CCSprite:createWithTexture(texture, CCRectMake(0, 0, tile_w, tile_h))
									--print(tex_x, tex_y, tile_w, tile_h)
									sprite:setAnchorPoint(ccp(0.5, 0.5))
									sprite:setPosition(ccp(sprite_center_x, -sprite_center_y))
									sprite:setColor(ccc3(255, 0, 0))
									worldLayer:addChild(sprite, 21)
									]]
								end
							end
						end
					end
				end
			end
		end
	end
	
	--普通房间逻辑，检测是否已经生成了传送点
	if (bGenerateNornal) then
		--检测是否已经生成了传送点
		if (not bTransported) then
			--在boss房生成
			for i = 1, #rooms, 1 do
				local tRegion = rooms[i]
				--local roomType = 0
				local strRoomType = tRegion.Roomtype --区域类型
				local roomPosX = tRegion.x + offsetX / PIX_SIZE
				local roomPosY = tRegion.y + offsetY / PIX_SIZE
				local roomWidth = tRegion.w
				local roomHeight = tRegion.h
				local tTerminalPos = tRegion.TerminalPos --终点坐标集
				
				if (strRoomType == "boss") then --BOSS大房间
					--roomType = hVar.RANDMAP_ROOMTYPE.ROOM_BOSS
					
					--区域四个角
					local xl = roomPosX * PIX_SIZE
					local yt = roomPosY * PIX_SIZE
					local xr = xl + roomWidth * PIX_SIZE
					local yb = yt + roomHeight * PIX_SIZE
					
					--左上角生成
					bTransported = true
					local unitId = hVar.RANDMAP_ENEMY_TRANSPORT_ID
					
					--最后一关
					if terminal then
						unitId = hVar.RANDMAP_ENEMY_TRANSPORT_ID_TERMINAL
					end
					
					--房间右下角
					local randPosX = xr - 160
					local randPosY = yb - 200
					
					local facing = world:random(0, 360)
					local nOwner = 22 --魏国
					local nLv = 1
					local nStar = 1
					--god.data.facing
					--生成传送点
					local oUnit = world:addunit(unitId, nOwner, nil ,nil, facing, randPosX, randPosY, nil, nil, nLv, nStar)
					--触发事件：添加单位
					hGlobal.event:call("Event_UnitBorn", oUnit)
					--print("addunit", unitId, nOwner, nil ,nil, facing, randPosX, randPosY, nil, nil, nLv, nStar)
					local zOrder = -100
					xlChaSetZOrderOffset(oUnit.handle._c, zOrder)
					--print("xlChaSetZOrderOffset", tabU.type, tabU.zOrder)
					oUnit:setPos(randPosX-1, randPosY) --程序bug，需要设置一次pos才生效zorder
					
					--传送点默认隐藏
					oUnit:sethide(1)
					
					--添加传送点信息
					local tNormalMusicList = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}
					local randMusicIdx = math.random(1, #tNormalMusicList)
					d.tdMapInfo.portal[#d.tdMapInfo.portal + 1] =
					{
						x = randPosX,
						y = randPosY,
						owner = 1,
						searchRadius = 100,
						startConditionType = 2, --区域传送
						startCondition = nil,
						portalType = 2, --区域传送
						toX = nil,
						toY = nil,
						toMap = nil,
						isShow = false,
						eu = oUnit,
						viewReset = nil,
						enterMusic = tNormalMusicList[randMusicIdx],
					}
					--print("添加传送点信息", randPosX, randPosY)
					
					--最后一关
					if terminal then
						d.tdMapInfo.portal[#d.tdMapInfo.portal].startConditionType = 4 --区域传送（最后一关）
						d.tdMapInfo.portal[#d.tdMapInfo.portal].portalType = 4 --区域传送（最后一关）
					end
					
					--修改传送返回点
					regionData.transport_back_px = xr - 360 --传送点返回x坐标
					regionData.transport_back_py = yb - 200 --传送点返回y坐标
					regionData.transport_unit = oUnit --传送点单位
					regionData.transport_id = #d.tdMapInfo.portal --传送点id
					
					--添加boss房指向出口的箭头
					for p = 1, 3, 1 do
						local px = randPosX - 14
						local py = randPosY - PIX_SIZE - 64 - (p - 1) * PIX_SIZE
						local angle = 0
						local side = 23 --中立无敌意
						local id = hVar.RANDMAP_ENEMY_JIANTOU_EXIT
						local bIgnoreBlock = true
						local ret = {}
						local oUnit = __AddOneEnemy(ret, world, "unit", id, 0, 0, 0, angle, side, 0, px, py, 0, 0, nil, 0, 0, 0, 0, bIgnoreBlock, regionId)
						
						local zOrder = -100
						xlChaSetZOrderOffset(oUnit.handle._c, zOrder)
						--print("xlChaSetZOrderOffset", tabU.type, tabU.zOrder)
						oUnit:setPos(px-1, py) --程序bug，需要设置一次pos才生效zorder
						oUnit:sethide(1) --一开始隐藏
						
						--存储箭头(出口)（上侧）
						pointer_out_units[#pointer_out_units+1] = oUnit
						
						--光照效果(出口)
						if (p == 2) then
							local oUnit = __AddOneEnemy(ret, world, "unit", hVar.RANDMAP_ENEMY_JIANTOU_EXIT_EFFECT, 0, 0, 0, angle, side, 0, px, py, 0, 0, nil, 0, 0, 0, 0, bIgnoreBlock, regionId)
							xlChaSetZOrderOffset(oUnit.handle._c, zOrder)
							--print("xlChaSetZOrderOffset", tabU.type, tabU.zOrder)
							oUnit:setPos(px-1, py) --程序bug，需要设置一次pos才生效zorder
							oUnit.handle._n:setRotation(90)
							oUnit:sethide(1) --一开始隐藏
							
							--存储光照（上侧）
							pointer_out_units[#pointer_out_units+1] = oUnit
						end
					end
				end
			end
		end
	end
	
	--普通房间逻辑，检测是否已经生成了传送点返回
	if (bGenerateNornal) then
		--检测是否已经生成了传送点返回
		if (not bTransportedBack) then
			--在普通房生成
			for i = 1, #rooms, 1 do
				local tRegion = rooms[i]
				--local roomType = 0
				local strRoomType = tRegion.Roomtype --区域类型
				local roomPosX = tRegion.x + offsetX / PIX_SIZE
				local roomPosY = tRegion.y + offsetY / PIX_SIZE
				local roomWidth = tRegion.w
				local roomHeight = tRegion.h
				local tTerminalPos = tRegion.TerminalPos --终点坐标集
				
				if (strRoomType == "normal") then --普通房间
					--roomType = hVar.RANDMAP_ROOMTYPE.ROOM_BOSS
					
					--区域四个角
					local xl = roomPosX * PIX_SIZE
					local yt = roomPosY * PIX_SIZE
					local xr = xl + roomWidth * PIX_SIZE
					local yb = yt + roomHeight * PIX_SIZE
					
					--左下角生成
					bTransportedBack = true
					local unitId = hVar.RANDMAP_ENEMY_TRANSPORT_BACK_ID
					
					local randPosX = xl + 160
					local randPosY = yb - 200
					
					local facing = world:random(0, 360)
					local nOwner = 22 --魏国
					local nLv = 1
					local nStar = 1
					--god.data.facing
					--生成传送点返回
					local oUnit = world:addunit(unitId, nOwner, nil ,nil, facing, randPosX, randPosY, nil, nil, nLv, nStar)
					--触发事件：添加单位
					hGlobal.event:call("Event_UnitBorn", oUnit)
					--print("addunit", unitId, nOwner, nil ,nil, facing, randPosX, randPosY, nil, nil, nLv, nStar)
					local zOrder = -100
					xlChaSetZOrderOffset(oUnit.handle._c, zOrder)
					--print("xlChaSetZOrderOffset", tabU.type, tabU.zOrder)
					oUnit:setPos(randPosX-1, randPosY) --程序bug，需要设置一次pos才生效zorder
					
					--添加传送点信息
					local tNormalMusicList = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}
					local randMusicIdx = math.random(1, #tNormalMusicList)
					d.tdMapInfo.portal[#d.tdMapInfo.portal + 1] =
					{
						x = randPosX,
						y = randPosY,
						owner = 1,
						searchRadius = 100,
						startConditionType = 3, --区域传送返回
						startCondition = nil,
						portalType = 3, --区域传送返回
						toX = nil,
						toY = nil,
						toMap = nil,
						isShow = false,
						eu = oUnit,
						viewReset = nil,
						enterMusic = tNormalMusicList[randMusicIdx],
					}
					
					--修改传送点
					regionData.transport_px = xl + 360 --传送点x坐标
					regionData.transport_py = yb - 200 --传送点y坐标
					regionData.transport_back_unit = oUnit --传送点返回单位
					
					--[[
					--将战车设置到一个随机的通路，或普通房间
					local me = world:GetPlayerMe()
					local heros = me.heros
					local oHero = heros[1]
					local oUnit = oHero:getunit()
					local tank_trans_tox = -1
					local tank_trans_toy = -1
					
					for j = 1, #rooms, 1 do
						local tRegion_j = rooms[j]
						local strRoomType_j = tRegion_j.Roomtype --区域类型
						if (strRoomType_j == "road") then --通路、断头路
							local roomPosX_j = tRegion_j.x + offsetX / PIX_SIZE
							local roomPosY_j = tRegion_j.y + offsetY / PIX_SIZE
							local roomWidth_j = tRegion_j.w
							local roomHeight_j = tRegion_j.h
							
							--区域四个角
							local xl_j = roomPosX_j * PIX_SIZE
							local yt_j = roomPosY_j * PIX_SIZE
							local xr_j = xl_j + roomWidth_j * PIX_SIZE
							local yb_j = yt_j + roomHeight_j * PIX_SIZE
							
							tank_trans_tox = (xl_j + xr_j) / 2
							tank_trans_toy = (yt_j + yb_j) / 2
							tank_trans_tox, tank_trans_toy = hApi.Scene_GetSpace(tank_trans_tox, tank_trans_toy, 120)
							
							break
						end
					end
					
					--地图没有通路
					if (tank_trans_tox == -1) then
						for j = 1, #rooms, 1 do
							local tRegion_j = rooms[j]
							local strRoomType_j = tRegion_j.Roomtype --区域类型
							if (strRoomType_j == "normal") then --普通房间
								local roomPosX_j = tRegion_j.x + offsetX / PIX_SIZE
								local roomPosY_j = tRegion_j.y + offsetY / PIX_SIZE
								local roomWidth_j = tRegion_j.w
								local roomHeight_j = tRegion_j.h
								
								--区域四个角
								local xl_j = roomPosX_j * PIX_SIZE
								local yt_j = roomPosY_j * PIX_SIZE
								local xr_j = xl_j + roomWidth_j * PIX_SIZE
								local yb_j = yt_j + roomHeight_j * PIX_SIZE
								
								tank_trans_tox = (xl_j + xr_j) / 2
								tank_trans_toy = (yt_j + yb_j) / 2
								tank_trans_tox, tank_trans_toy = hApi.Scene_GetSpace(tank_trans_tox, tank_trans_toy, 120)
								
								break
							end
						end
					end
					]]
					
					--将战车设置到此普通房间
					local tank_trans_tox = randPosX
					local tank_trans_toy = randPosY
					local bForceSetPos = true
					oUnit:setPos(tank_trans_tox, tank_trans_toy, nil, bForceSetPos)
					--print("传送返回点x2", regionId, tank_trans_tox, tank_trans_toy)
					
					--宠物也传送过来
					local rpgunits = world.data.rpgunits
					for u, u_worldC in pairs(rpgunits) do
						for _, walle_id in ipairs(hVar.MY_TANK_FOLLOW_ID) do
							if (u.data.id == walle_id) then
								u:setPos(tank_trans_tox, tank_trans_toy, nil, bForceSetPos)
							end
						end
					end
					
					--镜头聚焦
					hApi.setViewNodeFocus(tank_trans_tox, tank_trans_toy)
					--print("镜头聚焦4")
					
					--返回值
					retX = tank_trans_tox
					retY = tank_trans_toy
					
					--print("传送点x2", regionId, regionData.transport_px, regionData.transport_py)
					
					--跳出循环
					break
				end
			end
		end
	end
	
	--普通房间逻辑，检测单位指定添加次数是否达成
	if (bGenerateNornal) then
		--在boss房生成
		for i = 1, #rooms, 1 do
			local tRegion = rooms[i]
			--local roomType = 0
			local strRoomType = tRegion.Roomtype --区域类型
			local roomPosX = tRegion.x + offsetX / PIX_SIZE
			local roomPosY = tRegion.y + offsetY / PIX_SIZE
			local roomWidth = tRegion.w
			local roomHeight = tRegion.h
			local tTerminalPos = tRegion.TerminalPos --终点坐标集
			
			if (strRoomType == "boss") then --BOSS大房间
				--roomType = hVar.RANDMAP_ROOMTYPE.ROOM_BOSS
				
				--区域四个角
				local xl = roomPosX * PIX_SIZE
				local yt = roomPosY * PIX_SIZE
				local xr = xl + roomWidth * PIX_SIZE
				local yb = yt + roomHeight * PIX_SIZE
				
				--依次遍历本小关位指定添加次数
				for unidGroupId, tLimit in pairs(grouplimit) do
					local glmincount = tLimit.mincount or 0
					--local side = tLimit.side or 22 --魏国
					local glcurrentcount = tGroupAddCountList[unidGroupId] or 0
					
					--未达成指定添加
					if (glcurrentcount < glmincount) then
						local glleftcount = glmincount - glcurrentcount
						for n = 1, glleftcount, 1 do
							--右上角生成
							local px = xr - world:random(120, 360)
							local py = yt + world:random(120, 360)
							
							local tGroup = hVar.RANDMAP_ROOM_ENEMY_GROUP[unidGroupId]
							if tGroup then
								--生成怪物
								local wave = 1
								local tGroupWave = tGroup.waves[wave]
								for tg = 1, #tGroupWave, 1 do
									local strType = tGroupWave[tg].type or "unit"
									local id = 0
									if (strType == "group") then
										id = tGroupWave[tg].groupId
									elseif (strType == "unit") then
										id = tGroupWave[tg].unidId
									elseif (strType == "randunit") then
										local randId = tGroupWave[tg].randId
										local tRand = hVar.RANDMAP_ROOM_ENEMY_UNIT[randId]
										local radnIdx = world:random(1, #tRand)
										
										strType = "unit"
										id = tRand[radnIdx]
									end
									local ox = tGroupWave[tg].offsetX or 0
									local oy = tGroupWave[tg].offsetY or 0
									local ox0 = ox
									local oy0 = oy
									local angle = tGroupWave[tg].angle or 0
									local side = tGroupWave[tg].side or 22 --魏国
									local roadPointType = tGroupWave[tg].roadPointType
									local offX = 0
									local offY = 0
									local ret = {}
									
									--添加单个单位
									__AddOneEnemy(ret, world, strType, id, wave, ox, oy, angle, side, roadPointType, px, py, 0, 0, nil, 0, 0, 0, 0, nil, regionId)
								end
							end
						end
						
						tGroupAddCountList[unidGroupId] = glmaxcount
					end
				end
			end
		end
	end
	
	--boss房间逻辑，boss门口生成障碍物
	if (bGenerateBoss) then
		--在boss房生成
		for i = 1, #rooms, 1 do
			local tRegion = rooms[i]
			--local roomType = 0
			local strRoomType = tRegion.Roomtype --区域类型
			local roomPosX = tRegion.x + offsetX / PIX_SIZE
			local roomPosY = tRegion.y + offsetY / PIX_SIZE
			local roomWidth = tRegion.w
			local roomHeight = tRegion.h
			local tTerminalPos = tRegion.TerminalPos --终点坐标集
			
			if (strRoomType == "boss") then --BOSS大房间
				--roomType = hVar.RANDMAP_ROOMTYPE.ROOM_BOSS
				
				--区域四个角
				local xl = roomPosX * PIX_SIZE
				local yt = roomPosY * PIX_SIZE
				local xr = xl + roomWidth * PIX_SIZE
				local yb = yt + roomHeight * PIX_SIZE
				
				--print("bGenerateNornal=", bGenerateNornal, "roomType == hVar.RANDMAP_ROOMTYPE.ROOM_BOSS")
				local Doors = tRegion.Doors
				--print("Doors=", Doors)
				if Doors then
					local dir = 0
					if (#Doors > 0) then
						--取中央门坐标
						local doorIdx_mid = math.ceil(#Doors / 2)
						local Door_mid = Doors[doorIdx_mid]
						local tDoor_mid = Door_mid.p
						local pIdx_mid = math.ceil(#tDoor_mid / 2)
						local px_mid = tDoor_mid[pIdx_mid].x * PIX_SIZE + offsetX
						local py_mid = tDoor_mid[pIdx_mid].y * PIX_SIZE + offsetY
						--print("px_mid=", px_mid)
						--print("py_mid=", py_mid)
						
						--取boss房的中心点坐标
						local boss_cx = roomPosX * PIX_SIZE + roomWidth * PIX_SIZE / 2
						local boss_cy = roomPosY * PIX_SIZE + roomHeight * PIX_SIZE / 2
						
						local Door1 = Doors[1]
						local tDoor1 = Door1.p
						if (#tDoor1 >= 2) then
							--添加单个单位
							local px1_n = tDoor1[1].x
							local py1_n = tDoor1[1].y
							local px2_n = tDoor1[2].x
							local py2_n = tDoor1[2].y
							if (px1_n == px2_n) then --竖向
								if (px_mid > boss_cx) then
									dir = "r"
								else
									dir = "l"
								end
							elseif (py1_n == py2_n) then --横向
								if (py_mid > boss_cy) then
									dir = "d"
								else
									dir = "u"
								end
							end
						end
					end
					
					--门口封路
					--print("门口封路 dir=", dir)
					for d = 1, #Doors, 1 do
						local Door = Doors[d]
						local tDoor = Door.p
						for p = 1, #tDoor, 1 do
							local tick = 48 * p
							hApi.addTimerOnce("__RANDMAP_DOORS_BLOCK_" .. p, tick, function()
								--添加单个单位
								local px = tDoor[p].x * PIX_SIZE + offsetX
								local py = tDoor[p].y * PIX_SIZE + offsetY
								local angle = 0
								local side = 23 --中立无敌意
								local id = 5212 --挡路口的障碍（横板）
								
								if (dir == "l") or (dir == "l") then
									id = 5213 --挡路口的障碍（竖版）
								end
								
								local bIgnoreBlock = true
								local ret = {}
								local nu = __AddOneEnemy(ret, world, "unit", id, 0, 0, 0, angle, side, 0, px, py, 0, 0, nil, 0, 0, 0, 0, bIgnoreBlock, regionId)
								
								--封路特效
								world:addeffect(3139, 1, nil, px, py) --effectId
								
								--存储
								boosroom_doorblocks[#boosroom_doorblocks+1] = nu
							end)
						end
					end
				end
				
				--宠物传送过来
				--geyachao: 大菠萝瓦力传送
				local heros = world:GetPlayerMe().heros
				if heros then
					local oHero = heros[1]
					if oHero then
						local oUnit = oHero:getunit()
						if oUnit then
							local toX, toY = hApi.chaGetPos(oUnit.handle) --角色当前的位置
							
							local rpgunits = world.data.rpgunits
							for u, u_worldC in pairs(rpgunits) do
							--world:enumunit(function(u)
								--print("大菠萝瓦力传送", u.data.name, u.data.id)
								--if (u.data.id == hVar.MY_TANK_FOLLOW_ID) then
								for _, walle_id in ipairs(hVar.MY_TANK_FOLLOW_ID) do
									if (u.data.id == walle_id) then
										--print("TD_Portal_Loop:9",toX, toY)
										--设置位置
										local randPosX = toX + 0
										local randPosY = toY + 0
										randPosX, randPosY = hApi.Scene_GetSpace(randPosX, randPosY, 24)
										local bForceSetPos = true
										u:setPos(randPosX, randPosY, nil, bForceSetPos)
										print("宠物封路传送:", u.data.name, walle_id, randPosX, randPosY)
										
										--将单位身上的眩晕、僵直等状态清空
										local a = u.attr
										a.stun_stack = 0 --眩晕的堆叠层数
										a.suffer_chaos_stack = 0 --混乱的堆叠层数
										a.suffer_blow_stack = 0 --吹风的堆叠层数
										a.suffer_chuanci_stack = 0 --穿刺的堆叠层数
										a.suffer_sleep_stack = 0 --沉睡的堆叠层数
										a.suffer_chenmo_stack = 0 --沉默的堆叠层数
										a.suffer_jinyan_stack = 0 --禁言的堆叠层数（不能普通攻击）
										a.suffer_touming_stack = 0  --透明的堆叠层数（不能碰撞）
										
										--设置ai状态为闲置
										u:setAIState(hVar.UNIT_AI_STATE.IDLE)
										
										--地图内单位传送之后回调函数
										if On_UnitTransport_Special_Event then
											--安全执行
											local round_ahead = world.data.pvp_round
											hpcall(On_UnitTransport_Special_Event, world, round_ahead, u, randPosX, randPosY)
											--On_UnitTransport_Special_Event(world, round_ahead, u, randPosX, randPosY)
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
	
	return retX, retY
end

--击杀boss后开启下一区域
function hApi.RandMapKillBoss(world, regionId, target)
	local mapInfo = world.data.tdMapInfo
	
	local regionId = world.data.randommapIdx
	local regionData = world.data.randommapInfo[regionId]
	local xlobj_units = regionData.xlobj_units --场景物件单位集
	local npc_units = regionData.npc_units --npc单位集
	local rooms = regionData.rooms --房间信息
	local regionPoint = regionData.regionPoint
	local boosroom_doorblocks = regionData.boosroom_doorblocks --boss房间门口路障
	local tMultiply = hVar.RANDMAP_REGION_POINT_MULTIPLY[regionPoint]
	local pointer_out_units = regionData.pointer_out_units --指向boss出的箭头单位集
	local tonext = tMultiply.tonext
	local toprevious = tMultiply.toprevious
	local terminal = tMultiply.terminal --最后一关？
	local offsetX = regionData.regoin_xl --左上角x坐标
	local offsetY = regionData.regoin_yt --左上角y坐标
	
	local PIX_SIZE = 16 * 3
	local target_x, target_y = hApi.chaGetPos(target.handle) --目标的位置
	
	if (tonext) then --通往下一区域
		--清除封路路口的障碍
		for i = #boosroom_doorblocks, 1, -1 do
			local nu = boosroom_doorblocks[i]
			nu:del()
			
			boosroom_doorblocks[i] = nil
		end
		
		--显示传送点单位
		local eu = regionData.transport_unit --传送点单位
		local transport_id = regionData.transport_id --传送点id
		eu:sethide(0)
		
		--显示指向下一关的箭头
		for r = 1, #pointer_out_units, 1 do
			local oUnit = pointer_out_units[r]
			oUnit:sethide(0)
		end
		
		--检测战车是否此刻已经在传送门里
		local me = world:GetPlayerMe()
		local heros = me.heros
		local oHero = heros[1]
		local oUnit = oHero:getunit()
		if oUnit then
			local hero_x, hero_y = hApi.chaGetPos(oUnit.handle) --战车的位置
			local trasport_x, trasport_y = hApi.chaGetPos(eu.handle) --传送点的位置
			--print("战车的位置", hero_x, hero_y)
			local hero_dx = hero_x - trasport_x
			local hero_dy = hero_y - trasport_y
			local dis = math.sqrt(hero_dx * hero_dx + hero_dy * hero_dy)
			local searchRadius = world.data.tdMapInfo.portal[transport_id].searchRadius
			dis = math.floor(dis * 100) / 100 --保留2位有效数字，用于同步
			--print("dis=", dis)
			if (dis <= searchRadius) then
				--print("初始是否已经在传送门里=", true)
				world.data.tdMapInfo.portal[transport_id].bBeginInside = true --初始是否已经在传送门里（如果初始已经在，需要先出来再进去才能触发传送）
			end
		end
		
		--添加击杀后的组
		if (hVar.RANDMAP_ENEMY_BOSS_KILL_ADDUNIT_GROUPID > 0) then
			local facing = target.data.facing
			local nOwner = 0
			local nLv = 1
			local nStar = 1
			
			--在boss房中央生成
			for i = 1, #rooms, 1 do
				local tRegion = rooms[i]
				--local roomType = 0
				local strRoomType = tRegion.Roomtype --区域类型
				local roomPosX = tRegion.x + offsetX / PIX_SIZE
				local roomPosY = tRegion.y + offsetY / PIX_SIZE
				local roomWidth = tRegion.w
				local roomHeight = tRegion.h
				local tTerminalPos = tRegion.TerminalPos --终点坐标集
				
				if (strRoomType == "boss") then --BOSS大房间
					--roomType = hVar.RANDMAP_ROOMTYPE.ROOM_BOSS
					
					--区域四个角
					local xl = roomPosX * PIX_SIZE
					local yt = roomPosY * PIX_SIZE
					local xr = xl + roomWidth * PIX_SIZE
					local yb = yt + roomHeight * PIX_SIZE
					
					--中央生成
					local px = (xl + xr) / 2
					local py = (yt + yb) / 2
					
					local tGroup = hVar.RANDMAP_ROOM_ENEMY_GROUP[hVar.RANDMAP_ENEMY_BOSS_KILL_ADDUNIT_GROUPID]
					if tGroup then
						--生成怪物
						local wave = 1
						local tGroupWave = tGroup.waves[wave]
						for tg = 1, #tGroupWave, 1 do
							local strType = tGroupWave[tg].type or "unit"
							local id = 0
							if (strType == "group") then
								id = tGroupWave[tg].groupId
							elseif (strType == "unit") then
								id = tGroupWave[tg].unidId
							elseif (strType == "randunit") then
								local randId = tGroupWave[tg].randId
								local tRand = hVar.RANDMAP_ROOM_ENEMY_UNIT[randId]
								local radnIdx = world:random(1, #tRand)
								
								strType = "unit"
								id = tRand[radnIdx]
							end
							local ox = tGroupWave[tg].offsetX or 0
							local oy = tGroupWave[tg].offsetY or 0
							local ox0 = ox
							local oy0 = oy
							local angle = tGroupWave[tg].angle or 0
							local side = tGroupWave[tg].side or 22 --魏国
							local roadPointType = tGroupWave[tg].roadPointType
							local offX = 0
							local offY = 0
							local ret = {}
							
							--添加单个单位
							__AddOneEnemy(ret, world, strType, id, wave, ox, oy, angle, side, roadPointType, px, py, 0, 0, nil, 0, 0, 0, 0, nil, regionId)
							--local nu = world:addunit(hVar.RANDMAP_ENEMY_BOSS_KILL_ADDUNIT_GROUPID, nOwner, nil ,nil, facing, target_x, target_y, nil, nil, nLv, nStar)
							--npc_units[#npc_units+1] = nu
						end
					end
				end
			end
		end
	else --全部杀死boss，胜利
		--添加击杀后组
		if (hVar.RANDMAP_ENEMY_BOSS_KILL_ADDUNIT_GROUPID > 0) then
			local facing = target.data.facing
			local nOwner = 0
			local nLv = 1
			local nStar = 1
			
			--在boss房中央生成
			for i = 1, #rooms, 1 do
				local tRegion = rooms[i]
				--local roomType = 0
				local strRoomType = tRegion.Roomtype --区域类型
				local roomPosX = tRegion.x + offsetX / PIX_SIZE
				local roomPosY = tRegion.y + offsetY / PIX_SIZE
				local roomWidth = tRegion.w
				local roomHeight = tRegion.h
				local tTerminalPos = tRegion.TerminalPos --终点坐标集
				
				if (strRoomType == "boss") then --BOSS大房间
					--roomType = hVar.RANDMAP_ROOMTYPE.ROOM_BOSS
					
					--区域四个角
					local xl = roomPosX * PIX_SIZE
					local yt = roomPosY * PIX_SIZE
					local xr = xl + roomWidth * PIX_SIZE
					local yb = yt + roomHeight * PIX_SIZE
					
					--中央生成
					local px = (xl + xr) / 2
					local py = (yt + yb) / 2
					
					local tGroup = hVar.RANDMAP_ROOM_ENEMY_GROUP[hVar.RANDMAP_ENEMY_BOSS_KILL_ADDUNIT_GROUPID]
					if tGroup then
						--生成怪物
						local wave = 1
						local tGroupWave = tGroup.waves[wave]
						for tg = 1, #tGroupWave, 1 do
							local strType = tGroupWave[tg].type or "unit"
							local id = 0
							if (strType == "group") then
								id = tGroupWave[tg].groupId
							elseif (strType == "unit") then
								id = tGroupWave[tg].unidId
							elseif (strType == "randunit") then
								local randId = tGroupWave[tg].randId
								local tRand = hVar.RANDMAP_ROOM_ENEMY_UNIT[randId]
								local radnIdx = world:random(1, #tRand)
								
								strType = "unit"
								id = tRand[radnIdx]
							end
							local ox = tGroupWave[tg].offsetX or 0
							local oy = tGroupWave[tg].offsetY or 0
							local ox0 = ox
							local oy0 = oy
							local angle = tGroupWave[tg].angle or 0
							local side = tGroupWave[tg].side or 22 --魏国
							local roadPointType = tGroupWave[tg].roadPointType
							local offX = 0
							local offY = 0
							local ret = {}
							
							--添加单个单位
							__AddOneEnemy(ret, world, strType, id, wave, ox, oy, angle, side, roadPointType, px, py, 0, 0, nil, 0, 0, 0, 0, nil, regionId)
							--local nu = world:addunit(hVar.RANDMAP_ENEMY_BOSS_KILL_ADDUNIT_GROUPID, nOwner, nil ,nil, facing, target_x, target_y, nil, nil, nLv, nStar)
							--npc_units[#npc_units+1] = nu
						end
					end
				end
			end
		end
		
		local result = hVar.MAP_TD_STATE.SUCCESS
		--快速游戏结束
		--保存随机地图的通关BOSS
		--local nBossID = u.data.id
		local diablodata = hGlobal.LocalPlayer.data.diablodata
		if diablodata then
			if type(diablodata.randMap) == "table" then
				local tInfo = LuaGetPlayerRandMapInfo(g_curPlayerName)
				local nStage = tInfo.stage or 1
				if tInfo.stageInfo == nil then
					tInfo.stageInfo = {}
				end
				--记录bossid
				tInfo.stageInfo[nStage] = tInfo.stageInfo[nStage] or {}
				--tInfo.stageInfo[nStage].bossid = nBossID
				LuaSavePlayerList()
			end
			
			--[[
			--记录本局还未使用的道具技能
			local activeskill = {}
			local me = world:GetPlayerMe()
			local oHero = me.heros[1]
			--local typeId = oHero.data.id --英雄类型id
			local itemSkillT = oHero.data.itemSkillT
			if (itemSkillT) then
				for k = hVar.TANKSKILL_EMPTY + 1, #itemSkillT, 1 do
					local activeItemId = itemSkillT[k].activeItemId --主动技能的CD
					local activeItemLv = itemSkillT[k].activeItemLv --主动技能的等级
					local activeItemNum = itemSkillT[k].activeItemNum --主动技能的使用次数
					local activeItemCD = itemSkillT[k].activeItemCD --主动技能的CD
					local activeItemLastCastTime = itemSkillT[k].activeItemLastCastTime --主动技能的上次释放的时间（单位:秒）
					
					--存储
					activeskill[#activeskill+1] = {id = activeItemId, lv = activeItemLv, num = activeItemNum,}
				end
			end
			
			diablodata.activeskill = activeskill --坦克的上一局主动技能
			]]
		end
		mapInfo.mapState = result
	end
	
	--最后一关
	if terminal then
		--添加击杀大boss后单位
		if (hVar.RANDMAP_ENEMY_BIGBOSS_KILL_ADDUNIT_GROUPID > 0) then
			local facing = 0
			local nOwner = 0
			local nLv = 1
			local nStar = 1
			
			--在boss房中央偏右生成
			for i = 1, #rooms, 1 do
				local tRegion = rooms[i]
				--local roomType = 0
				local strRoomType = tRegion.Roomtype --区域类型
				local roomPosX = tRegion.x + offsetX / PIX_SIZE
				local roomPosY = tRegion.y + offsetY / PIX_SIZE
				local roomWidth = tRegion.w
				local roomHeight = tRegion.h
				local tTerminalPos = tRegion.TerminalPos --终点坐标集
				
				if (strRoomType == "boss") then --BOSS大房间
					--roomType = hVar.RANDMAP_ROOMTYPE.ROOM_BOSS
					
					--区域四个角
					local xl = roomPosX * PIX_SIZE
					local yt = roomPosY * PIX_SIZE
					local xr = xl + roomWidth * PIX_SIZE
					local yb = yt + roomHeight * PIX_SIZE
					
					--中央偏右
					local px = (xl + xr) / 2 + 200
					local py = (yt + yb) / 2 - 530
					
					local tGroup = hVar.RANDMAP_ROOM_ENEMY_GROUP[hVar.RANDMAP_ENEMY_BIGBOSS_KILL_ADDUNIT_GROUPID]
					if tGroup then
						--生成怪物
						local wave = 1
						local tGroupWave = tGroup.waves[wave]
						for tg = 1, #tGroupWave, 1 do
							local strType = tGroupWave[tg].type or "unit"
							local id = 0
							if (strType == "group") then
								id = tGroupWave[tg].groupId
							elseif (strType == "unit") then
								id = tGroupWave[tg].unidId
							elseif (strType == "randunit") then
								local randId = tGroupWave[tg].randId
								local tRand = hVar.RANDMAP_ROOM_ENEMY_UNIT[randId]
								local radnIdx = world:random(1, #tRand)
								
								strType = "unit"
								id = tRand[radnIdx]
							end
							local ox = tGroupWave[tg].offsetX or 0
							local oy = tGroupWave[tg].offsetY or 0
							local ox0 = ox
							local oy0 = oy
							local angle = tGroupWave[tg].angle or 0
							local side = tGroupWave[tg].side or 22 --魏国
							local roadPointType = tGroupWave[tg].roadPointType
							local offX = 0
							local offY = 0
							local ret = {}
							
							--添加单个单位
							__AddOneEnemy(ret, world, strType, id, wave, ox, oy, angle, side, roadPointType, px, py, 0, 0, nil, 0, 0, 0, 0, nil, regionId)
							--local nu = world:addunit(hVar.RANDMAP_ENEMY_BOSS_KILL_ADDUNIT_GROUPID, nOwner, nil ,nil, facing, target_x, target_y, nil, nil, nLv, nStar)
							--npc_units[#npc_units+1] = nu
						end
					end
				end
			end
		end
	end
end

--清除随机地图信息
--参数 bInitialized: 是否初始化（第0层）
function hApi.ClearRandomMap(world, prevoisIdx, bInitialized)
	local mapInfo = world.data.tdMapInfo
	local worldLayer = world.handle.worldLayer
	
	if (prevoisIdx > 0) then
		--依次遍历全部区域，删除贴图
		for regionId = 1, world.data.randommapIdx, 1 do
			local regionData = world.data.randommapInfo[regionId]
			local render_sprites = regionData.render_sprites --地面装饰物件贴图集
			local tex_sprites = regionData.tex_sprites --地板贴图集
			local pointer_in_units = regionData.pointer_in_units --指向boss入口的箭头单位集
			local pointer_out_units = regionData.pointer_out_units --指向boss出的箭头单位集
			local boosroom_doorblocks = regionData.boosroom_doorblocks --boss房间门口路障
			local xlobj_units = regionData.xlobj_units --场景物件单位集
			local xlobj_sprites = regionData.xlobj_sprites --墙体特效贴图集
			local npc_units = regionData.npc_units --npc单位集
			local blood_effects = regionData.blood_effects --飙血特效集
			local drop_units = regionData.drop_units --掉落的道具单位集
			
			--删除地面装饰物件贴图集
			for r = 1, #render_sprites, 1 do
				local sprite = render_sprites[r]
				worldLayer:removeChild(sprite, true)
			end
			
			--删除地板贴图集
			for r = 1, #tex_sprites, 1 do
				local sprite = tex_sprites[r].sprite
				worldLayer:removeChild(sprite, true)
			end
			
			--删指向boss入口的箭头单位集
			for r = 1, #pointer_in_units, 1 do
				local oUnit = pointer_in_units[r]
				oUnit:del()
			end
			
			--删指向boss出口的箭头单位集
			for r = 1, #pointer_out_units, 1 do
				local oUnit = pointer_out_units[r]
				oUnit:del()
			end
			
			--删除boss房间门口路障
			for r = 1, #boosroom_doorblocks, 1 do
				local oUnit = boosroom_doorblocks[r]
				oUnit:del()
			end
			
			--删除围墙
			for r = 1, #xlobj_units, 1 do
				local cha = xlobj_units[r]
				local eu = hApi.findSceobjByCha(cha)
				if eu then
					eu:del()
				end
			end
			
			--删除墙体特效贴图集
			for r = 1, #xlobj_sprites, 1 do
				local sprite = xlobj_sprites[r]
				worldLayer:removeChild(sprite, true)
			end
			
			--删指npc单位集
			for r = 1, #npc_units, 1 do
				local oUnit = npc_units[r]
				oUnit:del()
			end
			
			--删除飙血特效集
			for i = 1, #blood_effects, 1 do
				local eff = blood_effects[i]
				eff:del()
			end
			
			--删除掉落道具集
			for oItem, unit_worldC in pairs(drop_units) do
				if (oItem:getworldC() == unit_worldC) then --防止单位被复用
					oItem:del()
				end
			end
			
			--删除区域触发事件
			if mapInfo.portal then
				mapInfo.portal = {}
			end
			
			--移除前一个宇宙层控件
			if (prevoisIdx > 0) then
				local regionDataPrev = world.data.randommapInfo[prevoisIdx]
				local avatarInfoId = regionDataPrev.avatarInfoId
				local random_ObjectInfo = hVar.RANDMAP_ROOM_AVATAR_INFO[avatarInfoId]
				
				--远景物件
				local farObj = regionDataPrev.universe_farobj
				if (type(farObj) == "table") then
					local node = farObj.node
					for n = 1, #node, 1 do
						local nodei = node[n]
						worldLayer:removeChild(nodei, true)
					end
					
					farObj.camX = 0
					farObj.camY = 0
				end
				
				--中景物件
				local middleObj = regionDataPrev.universe_middleobj
				if (type(middleObj) == "table") then
					local node = middleObj.node
					for n = 1, #node, 1 do
						local nodei = node[n]
						worldLayer:removeChild(nodei, true)
					end
					
					middleObj.camX = 0
					middleObj.camY = 0
				end
				
				--近景物件
				local nearObj = regionDataPrev.universe_nearobj
				if (type(nearObj) == "table") then
					local node = nearObj.node
					for n = 1, #node, 1 do
						local nodei = node[n]
						worldLayer:removeChild(nodei, true)
					end
					
					nearObj.camX = 0
					nearObj.camY = 0
				end
				
				--释放资源
				--释放远景层资源
				local farobj = random_ObjectInfo.farobj
				if farobj then
					local tImg = farobj.img
					for i = 1, #tImg, 1 do
						local imgFileName = tImg[i]
						local texture = CCTextureCache:sharedTextureCache():textureForKey(imgFileName)
						if (texture) then
							CCTextureCache:sharedTextureCache():removeTexture(texture)
							print("释放宇宙层远景物件图！", imgFileName)
						end
					end
				end
				
				--释放中景层资源
				local middleobj = random_ObjectInfo.middleobj
				if middleobj then
					local tImg = middleobj.img
					for i = 1, #tImg, 1 do
						local imgFileName = tImg[i]
						local texture = CCTextureCache:sharedTextureCache():textureForKey(imgFileName)
						if (texture) then
							CCTextureCache:sharedTextureCache():removeTexture(texture)
							print("释放宇宙层中景物件图！", imgFileName)
						end
					end
				end
				
				--释放近景层资源
				local nearobj = random_ObjectInfo.nearobj
				if nearobj then
					local tImg = nearobj.img
					for i = 1, #tImg, 1 do
						local imgFileName = tImg[i]
						if (type(imgFileName) == "string") then
							local texture = CCTextureCache:sharedTextureCache():textureForKey(imgFileName)
							if (texture) then
								CCTextureCache:sharedTextureCache():removeTexture(texture)
								print("释放宇宙层近景物件图！", imgFileName)
							end
						end
					end
				end
			end
		end
		
		--遍历地图上的全部单位，删除敌人
		local me = world:GetPlayerMe()
		local myForce = me:getforce()
		world:enumunit(function(eu)
			local euForce = eu:getowner():getforce()
			if (euForce > 0) and (myForce ~= euForce) then --存在敌方活着的单位
				eu:del()
			end
		end)
		
		--删除互动物件
		world:enumunit(function(eu)
			local euForce = eu:getowner():getforce()
			if (euForce == 0) then
				eu:dead()
			end
		end)
		
		--删除vip5雕像
		world:enumunit(function(eu)
			if (eu.data.id == 13018) then
				eu:dead()
			end
		end)
	end
	
	--清除单位的死亡技能表（用于检测问题）
	world.data.Trigger_OnUnitDead_UnitList = {}
	
	--层数加1
	world.data.randommapStage = world.data.randommapStage + 1
	world.data.randommapIdx = 0
	world.data.randommapInfo = {}
	
	--如果传入了指定的层数，设定为指定的层数
	local diablodata = hGlobal.LocalPlayer.data.diablodata
	if diablodata then
		--print("如果传入了指定的层数，设定为指定的层数")
		--print("randommapStage", diablodata.randommapStage)
		--print("randommapIdx", diablodata.randommapIdx)
		if (type(diablodata.randommapStage) == "number") and (type(diablodata.randommapIdx) == "number") then
			--继续进度所在的层数和小关数
			local randommapStage = diablodata.randommapStage --当前所在随机地图层数
			local randommapIdx = diablodata.randommapIdx --地图当前所在小关数
			if (randommapIdx == 4) then
				randommapStage = randommapStage + 1
				randommapIdx = 1
			end
			
			print("如果传入了指定的层数，设定为指定的层数", randommapStage)
			
			world.data.randommapStage = randommapStage
			
			diablodata.randommapStage = nil --一次性加完
			diablodata.randommapIdx = nil --一次性加完
		end
	end
	
	--敌人增益buff
	local mapName = world.data.map
	--print("mapName=", mapName)
	local tabM = hVar.MAP_INFO[mapName]
	local diffTacticByStage = tabM.diffTacticByStage
	--print("diffTacticByStage=", diffTacticByStage)
	if diffTacticByStage then
		local diffTactic = diffTacticByStage[world.data.randommapStage] or diffTacticByStage[#diffTacticByStage]
		--print("diffTactic=", diffTactic)
		if diffTactic then
			--print("world:settactics(diffTactic)")
			local me = world:GetPlayerMe()
			world:cleartactics(me:getpos())
			
			world:settactics(me, diffTactic)
			
			--初始化，会在选人界面加上怪物buff战术卡，这里就不重复添加了
			if (not bInitialized) then
				--geyachao: 排行榜带上附加的怪物buff战术卡（随机迷宫）
				if (mapInfo.banLimitTable) and (mapInfo.banLimitTable.diff_tactic) then
					local tTacticAllList = {}
					for i = 1, #mapInfo.banLimitTable.diff_tactic, 1 do
						local id = mapInfo.banLimitTable.diff_tactic[i][1] or 0
						local lv = mapInfo.banLimitTable.diff_tactic[i][2] or 1
						if (id > 0) then
							--排行榜带上附加的怪物buff战术卡
							--table.insert(tTacticAllList, {id, lv, 0})
							tTacticAllList[#tTacticAllList + 1] = {id, lv, 0}
						end
					end
					
					world:settactics(me, tTacticAllList)
					--print("排行榜带上附加的怪物buff战术卡（随机迷宫）")
				end
			end
		end
	end
end

--区域组发兵timer
function hApi.RandomMapRoomSendArmyTimer(deltaTime)
	local world = hGlobal.WORLD.LastWorldMap
	
	--无效的world
	if (world == nil) then
		return
	end
	
	local d = world.data
	local mapInfo = d.tdMapInfo
	local randommapStage = d.randommapStage
	local regionId = world.data.randommapIdx
	local randommapInfo = d.randommapInfo
	
	--非随机地图
	if (regionId <= 0) then
		return
	end
	
	local regionData = d.randommapInfo[regionId]
	--防止跳下层
	if (regionData == nil) then
		return
	end
	
	local worldLayer = world.handle.worldLayer
	local offsetX = regionData.regoin_xl --左上角x坐标
	local offsetY = regionData.regoin_yt --左上角y坐标
	local regoin_xr = regionData.max_px --右下角x坐标
	local regoin_yb = regionData.max_py --右下角y坐标
	--local transport_px = regionData.transport_px --传送点x坐标
	--local transport_py = regionData.transport_py --传送点y坐标
	local render_sprites = regionData.render_sprites --地面装饰物件贴图集
	local tex_sprites = regionData.tex_sprites --地板贴图集
	local avatarInfoId = regionData.avatarInfoId
	local random_ObjectInfo = hVar.RANDMAP_ROOM_AVATAR_INFO[avatarInfoId]
	local PIX_SIZE = 16 * 3
	local roomgroupSendArmyList = regionData.roomgroupSendArmyList --房间组发兵表 --{[n] = {groupId = XXX, x = XXX, y = XXX, beginTick = XXX, currentWave = XXX, unitperWave = {[1] = {...}, [2] = {...}, ...}, ...}
	local currenttime = world:gametime() --当前时间
	
	--依次遍历本层的全部区域组
	for i = 1, #roomgroupSendArmyList, 1 do
		local tSendArmyList = roomgroupSendArmyList[i]
		local groupId = tSendArmyList.groupId
		local beginTick = tSendArmyList.beginTick --开始时间
		local currentWave = tSendArmyList.currentWave --当前波数
		local px = tSendArmyList.x
		local py = tSendArmyList.y
		local unitperWave = tSendArmyList.unitperWave
		
		local tGroup = hVar.RANDMAP_ROOM_ENEMY_GROUP[groupId]
		local totalWave = tGroup.totalWave --总波数
		--print("i=" .. i, currentWave, totalWave)
		if (currentWave < totalWave) then
			local box = tGroup.box
			local box_x = box[1]
			local box_y = box[2]
			local box_w = box[3]
			local box_h = box[4]
			local box_width = box_w - box_x
			local box_height = box_h - box_y
			
			--本波信息
			local tPewWaveNow = unitperWave[currentWave]
			
			--下一波信息
			local nextWave = currentWave + 1
			local tGroupWaveNext = tGroup.waves[nextWave]
			local delayTimeNext = tGroupWaveNext.delayTime or 0 --下一波的发兵时间（毫秒）（填-1表示永远等待）
			local deadOnNext = tGroupWaveNext.deadOnNext --本波死亡后是否下一波提前发兵
			local deltetime = currenttime - beginTick
			
			--下一波时间到了，可以发兵
			--或者本波小兵都死亡，也可以发兵
			if ((delayTimeNext >= 0) and (deltetime >= delayTimeNext))
			or ((deadOnNext == true) and tPewWaveNow and (tPewWaveNow.num == 0)) then
				--记录下一波的怪物信息
				unitperWave[nextWave] = {num = 0,}
				
				--生成怪物
				for tg = 1, #tGroupWaveNext, 1 do
					local strType = tGroupWaveNext[tg].type or "unit"
					local id = 0
					if (strType == "group") then
						id = tGroupWaveNext[tg].groupId
					elseif (strType == "unit") then
						id = tGroupWaveNext[tg].unidId
					elseif (strType == "randunit") then
						local randId = tGroupWaveNext[tg].randId
						local tRand = hVar.RANDMAP_ROOM_ENEMY_UNIT[randId]
						local radnIdx = world:random(1, #tRand)
						
						strType = "unit"
						id = tRand[radnIdx]
					end
					--print(strType)
					local ox = tGroupWaveNext[tg].offsetX or 0
					local oy = tGroupWaveNext[tg].offsetY or 0
					local ox0 = ox
					local oy0 = oy
					local angle = tGroupWaveNext[tg].angle or 0
					local side = tGroupWaveNext[tg].side or 22 --魏国
					local roadPointType = tGroupWaveNext[tg].roadPointType
					local offX = 0
					local offY = 0
					local ret = {}
					
					--添加单个单位
					__AddOneEnemy(ret, world, strType, id, nextWave, ox, oy, angle, side, roadPointType, px, py, box_width, box_height, nil, offX, offY, offsetX, offsetY, nil, regionId)
					
					--存储本波的怪物
					for r = 1, #ret, 1 do
						local nu = ret[r]
						--只记录英雄和小兵
						if (nu.data.type == hVar.UNIT_TYPE.UNIT) or (nu.data.type == hVar.UNIT_TYPE.HERO) then
							unitperWave[nextWave][nu] = nu:getworldC()
							unitperWave[nextWave].num = unitperWave[nextWave].num + 1
						end
					end
				end
				
				if (nextWave == 1) then
					--第1波发兵，检测地面装饰物是否和障碍物重叠，删除重叠的装饰物
					for r = #render_sprites, 1, -1 do
						local sprite = render_sprites[r]
						local sprite_x, sprite_y = sprite:getPosition()
						local tSize = sprite:getContentSize()
						local sprite_bx, sprite_by, sprite_bw, sprite_bh = 0, 0, tSize.width, tSize.height --贴图的包围盒
						--print("贴图的包围盒", sprite_bx, sprite_by, sprite_bw, sprite_bh)
						local sprite_center_x = sprite_x --贴图的中心点x位置
						local sprite_center_y = -sprite_y --贴图中心点y位置
						local sprite_left_x = sprite_center_x - sprite_bw / 2 --左侧x
						local sprite_right_x = sprite_center_x + sprite_bw / 2 --右侧x
						local sprite_left_y = sprite_center_y + sprite_bh / 2 --上侧y
						local sprite_right_y = sprite_center_y - sprite_bh / 2 --下侧y
						
						--抽样12个点
						local p1 = (xlScene_IsGridBlock(g_world, sprite_left_x / 24, sprite_left_y / 24) == 1) --左上
						local p2 = (xlScene_IsGridBlock(g_world, sprite_center_x / 24, sprite_left_y / 24) == 1) --中上
						local p3 = (xlScene_IsGridBlock(g_world, sprite_right_x / 24, sprite_left_y / 24) == 1) --右上
						local p4 = (xlScene_IsGridBlock(g_world, sprite_left_x / 24, sprite_center_y / 24) == 1) --左中
						local p5 = (xlScene_IsGridBlock(g_world, sprite_center_x / 24, sprite_center_y / 24) == 1) --中中
						local p6 = (xlScene_IsGridBlock(g_world, sprite_right_x / 24, sprite_center_y / 24) == 1) --右中
						local p7 = (xlScene_IsGridBlock(g_world, sprite_left_x / 24, sprite_right_y / 24) == 1) --左下
						local p8 = (xlScene_IsGridBlock(g_world, sprite_center_x / 24, sprite_right_y / 24) == 1) --中下
						local p9 = (xlScene_IsGridBlock(g_world, sprite_right_x / 24, sprite_right_y / 24) == 1) --右下
						--田字形每个中间4个点
						local p10 = (xlScene_IsGridBlock(g_world, (sprite_left_x+sprite_center_x)/2 / 24, (sprite_left_y+sprite_center_y)/2 / 24) == 1) --右下
						local p11 = (xlScene_IsGridBlock(g_world, (sprite_left_x+sprite_center_x)/2 / 24, (sprite_center_y+sprite_right_y)/2 / 24) == 1) --右下
						local p12 = (xlScene_IsGridBlock(g_world, (sprite_center_x+sprite_right_x)/2 / 24, (sprite_left_y+sprite_center_y)/2 / 24) == 1) --右下
						local p13 = (xlScene_IsGridBlock(g_world, (sprite_center_x+sprite_right_x)/2 / 24, (sprite_center_y+sprite_right_y)/2 / 24) == 1) --右下
						
						--相交
						if p1 or p2 or p3 or p4 or p5 or p6 or p7 or p8 or p9 or p10 or p11 or p12 or p13 then
							--删除重叠的地面装饰物
							--print("障碍里 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")
							worldLayer:removeChild(sprite, true)
							table.remove(render_sprites, r)
							
							--[[
							--调试用的代码
							local texture = CCTextureCache:sharedTextureCache():textureForKey("data/image/effect/circle3.png")
							if (not texture) then
								texture = CCTextureCache:sharedTextureCache():addImage("data/image/effect/circle3.png")
								--print("加载" .. imgFileName .. "！")
							end
							local sprite = CCSprite:createWithTexture(texture, CCRectMake(sprite_bx, sprite_by, sprite_bw, sprite_bh))
							sprite:setAnchorPoint(ccp(0.5, 0.5))
							sprite:setPosition(ccp(sprite_x, sprite_y))
							worldLayer:addChild(sprite, 21)
							]]
						end
					end
					
					--[[
					--第1波发兵检测地板贴图的第3种贴图，是否是否和障碍物重叠，替换为普通贴图
					for r = #tex_sprites, 1, -1 do
						local index = tex_sprites[r].index
						local sprite = tex_sprites[r].sprite
						--local tex_x = tex_sprites[r].tex_x
						--local tex_y = tex_sprites[r].tex_y
						local tile_w = tex_sprites[r].w
						local tile_h = tex_sprites[r].h
						
						if (index == 3) then
							local sprite_x, sprite_y = sprite:getPosition()
							--local tSize = sprite:getContentSize()
							--local sprite_bx, sprite_by, sprite_bw, sprite_bh = 0, 0, tSize.width, tSize.height --贴图的包围盒
							--print("贴图的包围盒", sprite_bx, sprite_by, sprite_bw, sprite_bh)
							local sprite_center_x = sprite_x  + tile_w / 2 --贴图的中心点x位置
							local sprite_center_y = -sprite_y + tile_h / 2 --贴图中心点y位置
							local sprite_left_x = sprite_center_x - tile_w / 2 --左侧x
							local sprite_right_x = sprite_center_x + tile_w / 2 --右侧x
							local sprite_left_y = sprite_center_y + tile_h / 2 --上侧y
							local sprite_right_y = sprite_center_y - tile_h / 2 --下侧y
							
							--抽样12个点
							local p1 = (xlScene_IsGridBlock(g_world, sprite_left_x / 24, sprite_left_y / 24) == 1) --左上
							local p2 = (xlScene_IsGridBlock(g_world, sprite_center_x / 24, sprite_left_y / 24) == 1) --中上
							local p3 = (xlScene_IsGridBlock(g_world, sprite_right_x / 24, sprite_left_y / 24) == 1) --右上
							local p4 = (xlScene_IsGridBlock(g_world, sprite_left_x / 24, sprite_center_y / 24) == 1) --左中
							local p5 = (xlScene_IsGridBlock(g_world, sprite_center_x / 24, sprite_center_y / 24) == 1) --中中
							local p6 = (xlScene_IsGridBlock(g_world, sprite_right_x / 24, sprite_center_y / 24) == 1) --右中
							local p7 = (xlScene_IsGridBlock(g_world, sprite_left_x / 24, sprite_right_y / 24) == 1) --左下
							local p8 = (xlScene_IsGridBlock(g_world, sprite_center_x / 24, sprite_right_y / 24) == 1) --中下
							local p9 = (xlScene_IsGridBlock(g_world, sprite_right_x / 24, sprite_right_y / 24) == 1) --右下
							--田字形每个中间4个点
							local p10 = (xlScene_IsGridBlock(g_world, (sprite_left_x+sprite_center_x)/2 / 24, (sprite_left_y+sprite_center_y)/2 / 24) == 1) --右下
							local p11 = (xlScene_IsGridBlock(g_world, (sprite_left_x+sprite_center_x)/2 / 24, (sprite_center_y+sprite_right_y)/2 / 24) == 1) --右下
							local p12 = (xlScene_IsGridBlock(g_world, (sprite_center_x+sprite_right_x)/2 / 24, (sprite_left_y+sprite_center_y)/2 / 24) == 1) --右下
							local p13 = (xlScene_IsGridBlock(g_world, (sprite_center_x+sprite_right_x)/2 / 24, (sprite_center_y+sprite_right_y)/2 / 24) == 1) --右下
							
							--相交
							if p1 or p2 or p3 or p4 or p5 or p6 or p7 or p8 or p9 or p10 or p11 or p12 or p13 then
								--删除重叠的地面装饰物
								--print("地板在障碍里 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")
								worldLayer:removeChild(sprite, true)
								table.remove(tex_sprites, r)
								
								--替换为普通地板2
								local wallimg = random_ObjectInfo.wallimg
								local imgFileName = wallimg
								local texture = CCTextureCache:sharedTextureCache():textureForKey(imgFileName)
								if (not texture) then
									texture = CCTextureCache:sharedTextureCache():addImage(imgFileName)
									--print("加载" .. imgFileName .. "！")
								end
								local ground = random_ObjectInfo.ground
								local indexNew = 2
								local tex_x = ground[indexNew].x
								local tex_y = ground[indexNew].y
								local sprite = CCSprite:createWithTexture(texture, CCRectMake(tex_x, tex_y, tile_w, tile_h))
								sprite:setAnchorPoint(ccp(0, 1))
								sprite:setPosition(ccp(sprite_x, sprite_y))
								worldLayer:addChild(sprite, 20)
								
								tex_sprites[#tex_sprites+1] = {sprite = sprite, x = sprite_x, y = -sprite_y, w = tile_w, h = tile_h, index = indexNew,}
								
								--释放地板资源
								local wallimg = random_ObjectInfo.wallimg
								if wallimg then
									local imgFileName = wallimg
									local texture = CCTextureCache:sharedTextureCache():textureForKey(imgFileName)
									if (texture) then
										CCTextureCache:sharedTextureCache():removeTexture(texture)
										print("释放墙体物件图！", imgFileName)
									end
								end
								
								--调试用的代码
								local texture = CCTextureCache:sharedTextureCache():textureForKey("data/image/effect/zhadan.png")
								if (not texture) then
									texture = CCTextureCache:sharedTextureCache():addImage("data/image/effect/zhadan.png")
									--print("加载" .. imgFileName .. "！")
								end
								local sprite = CCSprite:createWithTexture(texture, CCRectMake(0, 0, tile_w, tile_h))
								--print(tex_x, tex_y, tile_w, tile_h)
								sprite:setAnchorPoint(ccp(0.5, 0.5))
								sprite:setPosition(ccp(sprite_center_x, -sprite_center_y))
								sprite:setColor(ccc3(255, 0, 0))
								worldLayer:addChild(sprite, 21)
							end
						end
					end
					]]
				end
				
				--清除战车周围可能的砖块、围墙
				local me = world:GetPlayerMe()
				local heros = me.heros
				local oHero = heros[1]
				local oUnit = oHero:getunit()
				if oUnit then
					local hero_x, hero_y = hApi.chaGetPos(oUnit.handle) --战车的位置
					local radius = 120
					world:enumunitArea(nil, hero_x, hero_y, radius, function(eu)
						--清除战车周围可能的砖块，防止战车在障碍里
						if (eu.data.type == hVar.UNIT_TYPE.UNITBROKEN) or (eu.data.type == hVar.UNIT_TYPE.UNITBROKEN_HOUSE) then
							if (eu.data.id == hVar.UNITBROKEN_STONE_ORINGIN_ID) or (eu.data.id == hVar.UNITBROKEN_STONE_CHANGETO_ID) or (eu.data.id == hVar.UNITBROKEN_STONE_GOLD_ID)
							or (eu.data.id == hVar.UNITBROKEN_STONE_NORMAL) or (eu.data.id == hVar.UNITBROKEN_STONE_SPECIAL)
							or (eu.data.id == hVar.UNITBROKENHOUSE_X1) or (eu.data.id == hVar.UNITBROKENHOUSE_X2)then
								eu:del()
								--print("删除砖块 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")
							end
						end
					end)
				end
				
				--存储新波数
				tSendArmyList.currentWave = nextWave
			end
		end
	end
end

--坐标是否在随机地图房间之外
function hApi.RandomMapIsPointOutRoom(worldX, worldY)
	local world = hGlobal.WORLD.LastWorldMap
	local nIsOutRoom = 1
	
	--无效的world
	if (world == nil) then
		nIsOutRoom = 0
		return nIsOutRoom
	end
	
	local d = world.data
	local mapInfo = d.tdMapInfo
	local randommapStage = d.randommapStage
	local regionId = world.data.randommapIdx
	local randommapInfo = d.randommapInfo
	
	--非随机地图
	if (regionId <= 0) then
		nIsOutRoom = 0
		return nIsOutRoom
	end
	
	local regionData = d.randommapInfo[regionId]
	--防止跳下层
	if (regionData == nil) then
		nIsOutRoom = 0
		return nIsOutRoom
	end
	
	local PIX_SIZE = 16 * 3
	local rooms = regionData.rooms_new --房间信息
	local offsetX = regionData.regoin_xl --左上角x坐标
	local offsetY = regionData.regoin_yt --左上角y坐标
	local regoin_xr = regionData.max_px --右下角x坐标
	local regoin_yb = regionData.max_py --右下角y坐标
	
	--无房间
	if (rooms == nil) then
		nIsOutRoom = 0
		return nIsOutRoom
	end
	
	--依次检测每个房间
	for i = 1, #rooms, 1 do
		local tRegion = rooms[i]
		--local roomType = 0
		local strRoomType = tRegion.Roomtype --区域类型
		local roomPosX = tRegion.x + offsetX / PIX_SIZE
		local roomPosY = tRegion.y + offsetY / PIX_SIZE
		local roomWidth = tRegion.w
		local roomHeight = tRegion.h
		local tTerminalPos = tRegion.TerminalPos --终点坐标集
		
		--区域四个角
		local xl = roomPosX * PIX_SIZE
		local yt = roomPosY * PIX_SIZE
		local xr = xl + roomWidth * PIX_SIZE
		local yb = yt + roomHeight * PIX_SIZE
		
		--print("x:", xl, xr)
		--print("y:", yt, yb)
		--print("worldX:", worldX)
		--print("worldY:", worldY)
		
		if (worldX >= xl) and (worldX <= xr) and (worldY >= yt) and (worldY <= yb) then --在房间内
			nIsOutRoom = 0
			break
		end
	end
	
	return nIsOutRoom
end

--获得boss房的坐标
function hApi.GetBossRoomPosition()
	local world = hGlobal.WORLD.LastWorldMap
	local d = world.data
	local mapInfo = world.data.tdMapInfo
	local regionId = world.data.randommapIdx
	if (regionId > 0) then
		local regionData = d.randommapInfo[regionId]
		local PIX_SIZE = 16 * 3
		local rooms = regionData.rooms_new --房间信息
		local offsetX = regionData.regoin_xl --左上角x坐标
		local offsetY = regionData.regoin_yt --左上角y坐标
		local regoin_xr = regionData.max_px --右下角x坐标
		local regoin_yb = regionData.max_py --右下角y坐标
		
		--boss房间
		for i = 1, #rooms, 1 do
			local tRegion = rooms[i]
			--local roomType = 0
			local strRoomType = tRegion.Roomtype --区域类型
			local roomPosX = tRegion.x + offsetX / PIX_SIZE
			local roomPosY = tRegion.y + offsetY / PIX_SIZE
			local roomWidth = tRegion.w
			local roomHeight = tRegion.h
			local tTerminalPos = tRegion.TerminalPos --终点坐标集
			
			if (strRoomType == "boss") then --BOSS大房间
				--roomType = hVar.RANDMAP_ROOMTYPE.ROOM_BOSS
				
				--区域四个角
				local xl = roomPosX * PIX_SIZE
				local yt = roomPosY * PIX_SIZE
				local xr = xl + roomWidth * PIX_SIZE
				local yb = yt + roomHeight * PIX_SIZE
				
				return xl, yt, xr, yb
			end
		end
	end
	
	return 0, 0, 0, 0
end

--将玩家的随机迷宫信息存档
function hApi.RandomMapToSaveData()
	local world = hGlobal.WORLD.LastWorldMap
	
	--无效的world
	if (world == nil) then
		return
	end
	
	--记录本局还未使用的道具技能
	local activeskill = {}
	local me = world:GetPlayerMe()
	local oHero = me.heros[1]
	--local typeId = oHero.data.id --英雄类型id
	local itemSkillT = oHero.data.itemSkillT
	if (itemSkillT) then
		for k = hVar.TANKSKILL_EMPTY + 1, #itemSkillT, 1 do
			local activeItemId = itemSkillT[k].activeItemId --主动技能的CD
			local activeItemLv = itemSkillT[k].activeItemLv --主动技能的等级
			local activeItemNum = itemSkillT[k].activeItemNum --主动技能的使用次数
			local activeItemCD = itemSkillT[k].activeItemCD --主动技能的CD
			local activeItemLastCastTime = itemSkillT[k].activeItemLastCastTime --主动技能的上次释放的时间（单位:秒）
			
			--不是造塔类战术卡
			local isBuildTower = 0
			local tabI = hVar.tab_item[activeItemId]
			if tabI then
				if tabI.activeSkill then
					isBuildTower = tabI.activeSkill.isBuildTower or 0
				end
			end
			--不是造塔类战术卡
			if (isBuildTower ~= 1) then
				--存储
				activeskill[#activeskill+1] = {id = activeItemId, lv = activeItemLv, num = activeItemNum,}
			end
		end
	end
	
	--记录本局武器等级
	local basic_weapon_level = 1
	local oUnit = oHero:getunit()
	if oUnit then
		if (oUnit.data.bind_weapon ~= 0) then
			basic_weapon_level = oUnit.data.bind_weapon.attr.attack[6]
		end
	end
	--print("（非随机地图） basic_weapon_level=", basic_weapon_level)
	
	--记录本局还存在的宠物
	local follow_pet_units = {}
	
	--geyachao: 普通地图，宠物不需要记录。下一关会自动携带出战的宠物
	--[[
	--geyachao: 大菠萝瓦力传送
	local rpgunits = world.data.rpgunits
	for u, u_worldC in pairs(rpgunits) do
		for _, walle_id in ipairs(hVar.MY_TANK_FOLLOW_ID) do
			if (u.data.id == walle_id) then
				follow_pet_units[#follow_pet_units+1] = {id = u.data.id, lv = u.attr.lv, star = u.attr.star,}
			end
		end
	end
	]]
	
	--记录本局营救科学家的数据
	local statistics_rescue_count = world.data.statistics_rescue_count --大菠萝营救的科学家数量(随机关单局数据)
	local statistics_rescue_num = world.data.statistics_rescue_num --大菠萝营救的科学家数量(随机关累加数据)
	local statistics_rescue_costnum = world.data.statistics_rescue_costnum --大菠萝营救的科学家消耗数量
	local statistics_crystal_num = me:getresource(hVar.RESOURCE_TYPE.GOLD) --水晶数量
	local weapon_attack_state = world.data.weapon_attack_state --自动开枪标记
	
	--命
	local lifecount = hGlobal.LocalPlayer.data.diablodata.lifecount --剩余命次数
	local deathcount = hGlobal.LocalPlayer.data.diablodata.deathcount --死亡次数
	local canbuylife = hGlobal.LocalPlayer.data.diablodata.canbuylife --可购买命的次数
	
	--自动开枪标记
	hGlobal.LocalPlayer.data.diablodata.weapon_attack_state = weapon_attack_state
	
	--战术卡信息
	local tTacticInfo = GameManager.GetGameInfo("tacticInfo")
	
	--宝箱信息
	local tChestInfo = GameManager.GetGameInfo("chestInfo")
	
	--存档日期
	--客户端的时间
	local localTime = os.time()
	--服务器的时间
	local hostTime = localTime - g_localDeltaTime --客户端和服务器的时间误差(Local = Host + deltaTime)
	--转化为北京时间
	local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
	local delteZone = localTimeZone - hVar.SYS_TIME_ZONE --与北京时间的时差
	hostTime = hostTime - delteZone * 3600 --服务器时间(北京时区)
	local strHostTime = os.date("%Y-%m-%d %H:%M:%S", hostTime)
	
	--层数
	local mapName = world.data.map --地图名
	local mapDifficulty = world.data.MapDifficulty --地图难度
	local battlecfg_id = 0 --服务器战斗id
	if world.data.banLimitTable then
		battlecfg_id = world.data.banLimitTable.battlecfg_id
	end
	local randommapStage = world.data.randommapStage --当前所在随机地图层数
	local randommapIdx = world.data.randommapIdx --地图当前所在小关数
	
	--生命百分比
	local hpRate = nil
	if oUnit then
		hpRate = math.floor(oUnit.attr.hp / oUnit:GetHpMax() * 100)
	end
	
	--存档
	local tInfo = {
		randommapFlag = 1, --有存档
		time = strHostTime, --存档日期（字符串）
		mapName = mapName, --地图名
		mapDifficulty = mapDifficulty, --地图难度
		mapBattleId = battlecfg_id, --服务器战斗id
		randommapStage = randommapStage,--当前所在随机地图层数
		randommapIdx = randommapIdx, --地图当前所在小关数
		activeskill = activeskill, --本局还未使用的道具技能
		basic_weapon_level = basic_weapon_level, --武器等级
		statistics_rescue_count = statistics_rescue_count, --营救的科学家数量(随机关单局数据)
		statistics_rescue_num = statistics_rescue_num, --营救的科学家数量(随机关累加数据)
		statistics_rescue_costnum = statistics_rescue_costnum, --营救的科学家消耗数量
		statistics_crystal_num = statistics_crystal_num, --水晶数量
		weapon_attack_state = weapon_attack_state, --自动开枪标记
		lifecount = lifecount, --剩余命次数
		deathcount = deathcount, --死亡次数
		canbuylife = canbuylife, --可购买命的次数
		tTacticInfo = tTacticInfo, --战术卡信息
		tChestInfo = tChestInfo, --宝箱信息
		hpRate = hpRate, --生命百分比
	}
	
	--设置随机迷宫缓存信息（防止闪退记录的第n-1小关的进度信息）
	LuaSetRandommapInfo(g_curPlayerName, tInfo)
end

