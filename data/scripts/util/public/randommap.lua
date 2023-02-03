local base = _G
local math = require('math')
local os = require('os')
local table = require('table')
-----------------------------------------------------------------------------
-- Module declaration
-----------------------------------------------------------------------------

-- module("RandomMap")
RandomMap = {}

-- 记录每个坐标对应的房间ID的二维数组，由坐标x,y索引
local m_iValueArray = {}
-- 记录每个坐标对应的Tile类型的二维数组，由坐标x,y索引
local m_tTileArray = {}
local m_PendingPos = {}
local m_wall_blocks = nil
local m_w
local m_h
local TileType = {
    Wall = 0, -- 墙
    Pending = 1, -- TODO: 什么意思？
    Corner = 2, -- 拐角
    Way = 5, -- 通路
    Door = 6, -- 门
    RoomConnect = 7 -- 房间连接
}
local RandomSeed = 0
-- 当前所有已生成的房间
local m_rRooms = {}
-- Boss房间
local m_rBossRoom = nil
local m_RoomClass = {
    RoomTryTimes = 1000, -- 扔房间的尝试次数。当要求房间都连接时，需要这个数很大（比如1000)才能生成比较满的地图
    MaxRoomCnt = -1, -- <0 不限制，否则最多房间数目为MaxRoomCnt
    MinRoomSize = 12, -- add wall width
    MaxRoomSize = 25,
    CornerSize = 2,
    WallSize = 2,
    WallWidth = 1,
    DistanceOfWalls = 2,
    BossRoom = false, -- 是否加入boss房间
    DoorRate = 0 -- 最高100，100时会尽可能在每个有墙不外接的房间加上门
}

m_RoomClass.BossRoomInfo = {
    w = 25,
    h = 30,
    doorsize = 6,
    max_road_len = 24
}

m_RoomClass.Rooms = {
    -- ================================================
    -- 特定长宽房间，可定义为通道，强行连接
    -- ================================================
    {
        w = 6,
        h = 16,
        add_type = "connect",
        Roomtype = "road"
    },
    {
        w = 6,
        h = 16,
        add_type = "connect",
        Roomtype = "road"
    },
    {
        w = 6,
        h = 24,
        add_type = "connect",
        Roomtype = "road"
    },
    {
        w = 6,
        h = 24,
        add_type = "connect",
        Roomtype = "road"
    },
    {
        w = 20,
        h = 6,
        add_type = "connect",
        Roomtype = "road"
    },
    {
        w = 20,
        h = 6,
        add_type = "connect",
        Roomtype = "road"
    },
    {
        w = 16,
        h = 6,
        add_type = "connect",
        Roomtype = "road"
    },
    {
        w = 16,
        h = 6,
        add_type = "connect",
        Roomtype = "road"
    },
    {
        w = 24,
        h = 6,
        add_type = "connect",
        Roomtype = "road"
    },
    -- ================================================
    -- 不要求强行连接，随机到这个时，会出现不连接的房间
    -- ================================================
    {
        Roomtype = "room"
    },
    {
        add_type = "",
        Roomtype = "room"
    },
    -- ================================================
    -- 普通房间，长宽随机,强行连接
    -- ================================================
    {
        add_type = "connect",
        Roomtype = "room"
    },
    {
        add_type = "connect",
        Roomtype = "room"
    },
    {
        add_type = "connect",
        Roomtype = "room"
    },
    {
        add_type = "connect",
        Roomtype = "room"
    }
}

-- 默认皮肤配置
local m_ObjectInfo = {
    wall_l = {
        objId = 4001,
        offsetX = 0,
        offsetY = 24
    },
    wall_r = {
        objId = 5001,
        offsetX = 0,
        offsetY = 24
    },
    wall_t = {
        objId = 4000,
        offsetX = 36,
        offsetY = 0
    },
    wall_b = {
        objId = 5000,
        offsetX = 36,
        offsetY = 0
    },
    swall_h = {
        objId = 4011,
        offsetX = 24,
        offsetY = 0
    },
    swall_v = {
        objId = 4011,
        offsetX = 24,
        offsetY = 0
    },
    corner_lt = {
        objId = 4002,
        offsetX = 22,
        offsetY = 22,
        rot = 0
    },
    corner_lb = {
        objId = 4004,
        offsetX = 22,
        offsetY = 24,
        rot = 0
    },
    corner_rt = {
        objId = 4003,
        offsetX = 32,
        offsetY = 22,
        rot = 0
    },
    corner_rb = {
        objId = 4005,
        offsetX = 32,
        offsetY = 24,
        rot = 0
    },
    corner_lt1 = {
        objId = 4008,
        offsetX = 22,
        offsetY = 22,
        rot = 0
    },
    corner_lb1 = {
        objId = 4010,
        offsetX = 22,
        offsetY = 24,
        rot = 0
    },
    corner_rt1 = {
        objId = 4009,
        offsetX = 32,
        offsetY = 22,
        rot = 0
    },
    corner_rb1 = {
        objId = 4011,
        offsetX = 32,
        offsetY = 24,
        rot = 0
    },
    door_h = {
        objId = 4009,
        offsetX = 24,
        offsetY = 0,
        rot = 0
    },
    door_v = {
        objId = 5001,
        offsetX = 24,
        offsetY = 0,
        rot = 0
    }
}
local DistanceToMapEdgeX = 1
local DistanceToMapEdgeY = 1

-- 房间ID计数器
local CurRegionId = 1000

function GetRandomSeed()
    return RandomSeed
end

-- 方向
local Dirs = {
    l = 0, -- Left
    r = 1, -- Right
    t = 2, -- Top
    b = 3 -- Bottom
}

-- 拐角方向
local CorDirs = {
    lt = 0, -- Left-Top
    rt = 1, -- Right-Top
    lb = 2, -- Left-Bottom
    rb = 3 -- Right-Bottom
}
function PrintTable(table, level, key)

    if base.type(table) ~= "table" then
        base.print(table)
        return
    end
    level = level or 1
    local indent = ""
    for i = 1, level do
        indent = indent .. "  "
    end

    if key ~= nil and key ~= "" then
        base.print(indent .. key .. " " .. "=" .. " " .. "{")
    else
        base.print(indent .. "{")
    end

    key = ""
    for k, v in base.pairs(table) do
        if base.type(v) == "table" then
            PrintTable(v, level + 1, k)
        else
            local content = base.string.format("%s%s = %s", indent .. "  ", base.tostring(k), base.tostring(v))
            base.print(content)
        end
    end
    base.print(indent .. "}")
end

function deepCopy(originObj)
    local lookupTable = {}

    local _copy
    _copy = function(obj)
        -- 基础数据类型的属性进行简单赋值操作
        if type(obj) ~= "table" then
            return obj
        end

        -- 表类型的属性进行迭代拷贝
        -- 这里的查找表是为了避免重复拷贝
        if lookupTable[obj] then
            return lookupTable[obj]
        end

        local newTable = {}
        lookupTable[obj] = newTable

        for _k, _v in base.pairs(obj) do
            -- 要考虑key和value为表的情况
            newTable[_copy(_k)] = _copy(_v)
        end

        -- 不要忘记复制元表
        return setmetatable(newTable, getmetatable(obj))
    end

    return _copy(originObj)
end

function ChangeOffset(target, offset)
    if target ~= nil and offset ~= nil then
        for _, pos in base.pairs(target.p) do
            pos.x = pos.x + offset.x
            pos.y = pos.y + offset.y
        end
    end
    return target
end

-- 房间偏移
---@param RoomInfo table 房间信息（原坐标信息）
---@param x number 新X坐标
---@param y number 新Y坐标
function ChangeRoomOffset(RoomInfo, x, y)
    if RoomInfo ~= nil then
        -- 计算偏移值
        local offset = {}
        offset.x = x - RoomInfo.x
        offset.y = y - RoomInfo.y
        RoomInfo.x = x
        RoomInfo.y = y
        if RoomInfo.Walls ~= nil then
            for _, Walls in base.pairs(RoomInfo.Walls) do
                for _, value in base.pairs(Walls.w) do
                    -- 墙块偏移
                    ChangeOffset(value, offset)
                end
            end
        end
        if RoomInfo.Corners ~= nil then
            for _, value in base.pairs(RoomInfo.Corners) do
                value.x = value.x + offset.x
                value.y = value.y + offset.y
                -- 拐角偏移
                ChangeOffset(value, offset)
            end
        end
    end
end

-- roominfo{
--	x = 0  -- startpos x
--	y = 0  -- startpos y
--	w = x  -- length x
--	h = y  -- length y
--  Corners[4] -- corner info
--  Walls[] -- wall info
--  Doors[] -- door info
--  _inside{x,y,w,h} --inside area conclude at runtime
-- }

-- wall{
-- d = Dirs.l  -- 方向
-- p[] = {x,y}s -- 墙包含的点
-- }
-- 生成房间
---@param RoomClass table 房间类型的预定义和生成参数配置（默认值m_RoomClass，配置值units_list.random_RoomClass）
---@param inW number 当前要生成房间的宽
---@param inH number 当前要生成房间的高
---@return table RoomInfo
function GenerateRoom(RoomClass, inW, inH)
    -- 房间生成结果
    local RoomInfo = {
        x = nil, -- X轴起始坐标，默认0
        y = nil, -- Y轴起始坐标，默认0
        w = nil, -- 实际宽度，inW 或 随机
        h = nil, -- 实际高度，inH 或 随机
        Walls = nil, -- 墙面数据，包含各侧墙块子数组。1左|2上|3右|4下
        Corners = nil -- 拐角数据。数组:元素{x:坐标X<number>, y:坐标Y<number>, d:拐角方向<CorDirs>, p:包含坐标数组<table>}
    }
    -- 墙壁
    local Walls = {}
    local w = inW
    local h = inH
    if w == nil or h == nil then
        -- TODO: 待分析算法含义，待检查是否有漏洞
        local MinWallCont = math.floor((RoomClass.MinRoomSize - RoomClass.CornerSize * 2 - 1) / RoomClass.WallSize + 1)
        local MaxWallCont = math.ceil((RoomClass.MaxRoomSize - RoomClass.CornerSize * 2 + 1) / RoomClass.WallSize)
        -- print(MinWallCont,MaxWallCont)
        -- 随机房间实际宽高
        w = math.random(MinWallCont, MaxWallCont) * RoomClass.WallSize + RoomClass.CornerSize * 2
        h = math.random(MinWallCont, MaxWallCont) * RoomClass.WallSize + RoomClass.CornerSize * 2
    end
    RoomInfo.x = 0
    RoomInfo.y = 0
    RoomInfo.w = w
    RoomInfo.h = h
    -- 4个拐角属性
    -- 4角方向，左上|右上|左下|右下
    RoomInfo.Corners = {
        {},
        {},
        {},
        {}
    }
    -- 左上
    -- 房间坐标系原点
    -- x轴向右，y轴向下
    RoomInfo.Corners[1].x = 0
    RoomInfo.Corners[1].y = 0
    RoomInfo.Corners[1].d = CorDirs.lt
    -- 右上
    -- x = 房间宽度-右上拐角尺寸
    RoomInfo.Corners[2].x = w - RoomClass.CornerSize
    RoomInfo.Corners[2].y = 0
    RoomInfo.Corners[2].d = CorDirs.rt
    -- 右下
    -- x = 房间宽度-右下拐角尺寸
    -- h = 房间高度-右下拐角尺寸
    RoomInfo.Corners[3].x = w - RoomClass.CornerSize
    RoomInfo.Corners[3].y = h - RoomClass.CornerSize
    RoomInfo.Corners[3].d = CorDirs.rb
    -- 左下
    -- h = 房间高度-左下拐角尺寸
    RoomInfo.Corners[4].x = 0
    RoomInfo.Corners[4].y = h - RoomClass.CornerSize
    RoomInfo.Corners[4].d = CorDirs.lb
    RoomInfo.Corners[1].p = {}
    RoomInfo.Corners[2].p = {}
    RoomInfo.Corners[3].p = {}
    RoomInfo.Corners[4].p = {}
    local p1 = RoomInfo.Corners[1].p
    local p2 = RoomInfo.Corners[2].p
    local p3 = RoomInfo.Corners[3].p
    local p4 = RoomInfo.Corners[4].p
    -- 条件：
    -- RoomClass.CornerSize = 2
    -- w,h = 10,10
    -- 结果：
    -- 左上p1 = { (0,0), (0,1), (1,0) }
    -- 右上p2 = { (10,0), (10,1), (8,0) }
    -- 右下p3 = { (10,9), (10,8), (8,10) }
    -- 左下p4 = { (0,9), (0,8), (1,0) }
    -- 拐角块是从4个角沿2条边延伸，厚度为1
    for i = 1, RoomClass.CornerSize do
        p1[#p1 + 1] = {
            x = 0,
            y = i - 1
        }
        p2[#p2 + 1] = {
            x = w,
            y = i - 1
        }
        p3[#p3 + 1] = {
            x = w,
            y = h - i
        }
        p4[#p4 + 1] = {
            x = 0,
            y = h - i
        }
        if i > 1 then
            p1[#p1 + 1] = {
                x = i - 1,
                y = 0
            }
            p2[#p2 + 1] = {
                x = w - i,
                y = 0
            }
            p3[#p3 + 1] = {
                x = w - i,
                y = h
            }
            p4[#p4 + 1] = {
                x = i - 1,
                y = 0
            }
        end
    end

    -- 墙块数据
    local TopWalls = {}
    local BottomWalls = {}
    local LeftWalls = {}
    local RightWalls = {}
    -- 墙块方向
    TopWalls.d = Dirs.t
    BottomWalls.d = Dirs.b
    LeftWalls.d = Dirs.l
    RightWalls.d = Dirs.r
    -- 墙块数组
    TopWalls.w = {}
    BottomWalls.w = {}
    LeftWalls.w = {}
    RightWalls.w = {}
    -- 墙的厚度为1
    -- 计算上下墙块的位置
    for posX = RoomClass.CornerSize, w - RoomClass.CornerSize - 1, RoomClass.WallSize do
        local TopWall = {}
        local BottomWall = {}
        TopWall.p = {}
        BottomWall.p = {}
        -- WallSize:上下墙宽度
        for i = 1, RoomClass.WallSize do
            TopWall.p[i] = {
                x = posX + i - 1,
                y = 0
            }
            BottomWall.p[i] = {
                x = posX + i - 1,
                y = h - 1
            }
        end
        TopWalls.w[#TopWalls.w + 1] = TopWall
        BottomWalls.w[#BottomWalls.w + 1] = BottomWall
    end
    -- 计算左右墙块的位置
    for posY = RoomClass.CornerSize, h - RoomClass.CornerSize - 1, RoomClass.WallSize do
        local LeftWall = {}
        local RightWall = {}
        LeftWall.p = {}
        RightWall.p = {}
        -- WallSize:左右墙高度
        for i = 1, RoomClass.WallSize do
            LeftWall.p[i] = {
                x = 0,
                y = posY + i - 1
            }
            RightWall.p[i] = {
                x = w - 1,
                y = posY + i - 1
            }
        end
        LeftWalls.w[#LeftWalls.w + 1] = LeftWall
        RightWalls.w[#RightWalls.w + 1] = RightWall
    end
    -- 存储顺序：左、上、右、下
    Walls[#Walls + 1] = LeftWalls
    Walls[#Walls + 1] = TopWalls
    Walls[#Walls + 1] = RightWalls
    Walls[#Walls + 1] = BottomWalls
    RoomInfo.Walls = Walls
    return RoomInfo
end

-- 重置地图
---@param w number 宽度
---@param h number 高度
function ResetMap(w, h)
    m_w = w
    m_h = h
    m_iValueArray = {}
    m_tTileArray = {}
    for i = 0, w - 1 do
        m_iValueArray[i] = {}
        m_tTileArray[i] = {}
        for j = 0, h - 1 do
            -- 初始化格子所属房间ID为:0
            m_iValueArray[i][j] = 0
            -- 初始化格子所属Tile类型为:通路
            m_tTileArray[i][j] = TileType.Way
        end
    end
end

function PrepareRandom(Seed)
	if Seed == nil then
		RandomSeed = os.time()
	else
		RandomSeed = Seed
	end
    math.randomseed(RandomSeed)
	
end

-- 获取A、B区域的重叠区域
-- 区域结构:{x,y,w,h}
function GetOverlapRect(A, B)
    local RetRect = {}
    local MinX = math.max(A.x, B.x)
    local MaxX = math.min(A.x + A.w, B.x + B.w)
    local MinY = math.max(A.y, B.y)
    local MaxY = math.min(A.y + A.h, B.y + B.h)

    if MaxX <= MinX or MaxY <= MinY then
        return
    else
        RetRect.x = MinX
        RetRect.w = MaxX - MinX
        RetRect.y = MinY
        RetRect.h = MaxY - MinY
        return RetRect
    end
end
-- 记录每个坐标所属的房间ID和Tile类型
---@param x number 坐标X
---@param y number 坐标Y
---@param RegoinId number 房间ID
---@param tiletype table 房间类型<TileType>
function _record(x, y, RegoinId, tiletype)
    if tiletype ~= nil then
        m_tTileArray[x][y] = tiletype
    end
    if RegoinId ~= nil then
        m_iValueArray[x][y] = RegoinId
    end
end

function CheckListPosState(WallPos, CheckType)
    if WallPos == nil then
        return false
    end
    local RealCheckType = TileType.Wall
    if CheckType ~= nil then
        RealCheckType = CheckType
    end
    for key, pos in base.pairs(WallPos) do
        if (m_tTileArray[pos.x][pos.y] ~= RealCheckType) then
            return false
        end
    end
    return true
end

-- 计算A、B区域分别在X轴和Y轴上的距离
-- 若B的左边缘 < A的右边缘，则x间距为0
-- 若B的上边缘 < A的下边缘，则y间距为0
-- 返回值:x >= 0,y >= 0
function _distance_of_room(A, B)
    local RetSize = {}
    local MinX = math.min(A.x, B.x)
    local MaxX = math.max(A.x + A.w, B.x + B.w)
    local MinY = math.min(A.y, B.y)
    local MaxY = math.max(A.y + A.h, B.y + B.h)

    RetSize.x = math.max(MaxX - MinX - A.w - B.w + 1, 0)
    RetSize.y = math.max(MaxY - MinY - A.h - B.h + 1, 0)

    return RetSize
end

-- 检查生成结果的合法性
---@param _RoomClass table 预定义生成规则和参数
---@param CheckRect table 待检查的已生成房间信息：位置和宽高
---@param bForceConnect boolean 连通性
function _CheckRectValid(_RoomClass, CheckRect, bForceConnect)
    -- 计算与墙间隔距离的外包围框，基于房间向四周扩展出与墙间隔的空间
    local CheckRectWithDis = {}
    CheckRectWithDis.x = CheckRect.x - _RoomClass.DistanceOfWalls
    CheckRectWithDis.y = CheckRect.y - _RoomClass.DistanceOfWalls
    CheckRectWithDis.w = CheckRect.w + _RoomClass.DistanceOfWalls * 2
    CheckRectWithDis.h = CheckRect.h + _RoomClass.DistanceOfWalls * 2
    if m_rBossRoom then
        local Intersect = GetOverlapRect(CheckRectWithDis, m_rBossRoom)
        if Intersect then
            return false
        end
    end
    -- 临时变量，记录当前最小的曼哈顿距离
    local CurDis = 100000000
    local NearestRoom -- 距离最近的非连通房间
    local NearestDis -- 和最近的非连通房间的距离信息:{x,y}
    -- 和已生成房间的连通数
    local ConnectCnt = 0
    -- 遍历当前已生成的房间
    for _, value in base.pairs(m_rRooms) do
        -- 检查与外包围框的重叠区域
        local Intersect = GetOverlapRect(CheckRectWithDis, value)
        if Intersect then
            -- 检查与待添加房间的重叠区域
            Intersect = GetOverlapRect(CheckRect, value)
            -- 若两个房间是连通关系，则重叠区域的厚度必定是1
            if Intersect and (Intersect.w == 1 or Intersect.h == 1) -- TODO: 为什么比较面积时要+1？
            and Intersect.w * Intersect.h > (_RoomClass.WallSize + 1) then
                -- 连通数+1
                ConnectCnt = ConnectCnt + 1
            else
                -- 重叠区域过大，该房间无效
                return false
            end
        else
            -- 不重叠，则计算距离
            local Dis = _distance_of_room(CheckRect, value)
            if (Dis.x + Dis.y < CurDis) then
                -- 计算曼哈顿距离
                CurDis = Dis.x + Dis.y
                NearestRoom = value
                NearestDis = Dis
            end
        end
    end
    if #m_rRooms == 0 or (not bForceConnect) or ConnectCnt > 0 then
        -- 成功条件：
        -- 1.创建第一个房间
        -- 2.不强制创建连通房间
        -- 3.强制创建连通房间，且每个新创建的房间的连通数必须大于0
        return true
    else
        -- 失败，返回距离最近的非连通房间和距离信息
        return false, NearestRoom, NearestDis
    end
end

---@param w number 可供生成的地图区域宽度
---@param h number 可供生成的地图区域高度
---@param RoomClass table 房间类型的预定义和生成参数配置（默认值m_RoomClass，配置值units_list.random_RoomClass）
---@param InX number 当前要生成房间的宽
---@param InY number 当前要生成房间的高
function _addRoom(w, h, _RoomClass, bForceConnect, InX, InY)
    -- 生成的房间信息
    local RoomInfo = GenerateRoom(_RoomClass, InX, InY)

    if RoomInfo ~= nil then
        -- 限定生成范围
        local minx = DistanceToMapEdgeX
        -- 位置从0开始，故-1
        local maxx = w - RoomInfo.w - DistanceToMapEdgeX - 1
        local miny = DistanceToMapEdgeY
        local maxy = h - RoomInfo.h - DistanceToMapEdgeY - 1

        -- 随机位置
        local x = math.random(math.floor(minx), math.floor(maxx))
        local y = math.random(math.floor(miny), math.floor(maxy))
        local overlaps = false
        -- 实际占用区块信息
        local CheckRect = {}
        -- 实际位置（考虑到地图边缘的距离，即DistanceToMapEdgeX和DistanceToMapEdgeY）
        CheckRect.x = x
        CheckRect.y = y
        -- 实际宽高
        CheckRect.w = RoomInfo.w
        CheckRect.h = RoomInfo.h

        -- 检查合法性
        -- 失败时，额外返回“距离最近的非连通房间和距离信息”
        local bValid, NearestRoom, NearestDis = _CheckRectValid(_RoomClass, CheckRect, bForceConnect)

        if bValid then
            ChangeRoomOffset(RoomInfo, x, y)
            CurRegionId = CurRegionId + 1
            RoomInfo.RegionId = CurRegionId
            -- 添加房间
            m_rRooms[#m_rRooms + 1] = RoomInfo
        elseif bForceConnect and NearestRoom ~= nil then
            -- TODO: 失败的处理逻辑能否省略？
            -- 若创建强制连通房间失败，且返回最近的非连通房间
            -- snap to nearese room
            -- 位置对齐到最近的非连通房间，不改变宽高
            -- 确保新生成房间的一侧与最近的非连通房间相连
            if x < NearestRoom.x then
                x = x + NearestDis.x
            else
                x = x - NearestDis.x
            end
            if y < NearestRoom.y then
                y = y + NearestDis.y
            else
                y = y - NearestDis.y
            end
            -- 更新新房间位置
            CheckRect.x = x
            CheckRect.y = y
            bValid = _CheckRectValid(_RoomClass, CheckRect, bForceConnect)
            -- 验证更新后的新房间是否合法
            if bValid then
                ChangeRoomOffset(RoomInfo, x, y)
                CurRegionId = CurRegionId + 1
                RoomInfo.RegionId = CurRegionId
                -- 添加房间
                m_rRooms[#m_rRooms + 1] = RoomInfo
            end
        end
    end

end

function _addBossRoom(w, h, _RoomClass, doorsize, max_road_len, InX, InY)
    local BossRoomInfo = GenerateRoom(_RoomClass, InX, InY)
    local roadlen = 0
    if max_road_len == nil or max_road_len <= doorsize * 2 then
        roadlen = doorsize * 2
    else
        roadlen = math.random(doorsize * 2, max_road_len)
    end
    local road_dir = math.random(4)
    local x_min = DistanceToMapEdgeX
    local x_max = w - BossRoomInfo.w - DistanceToMapEdgeX - 1
    local y_min = DistanceToMapEdgeY
    local y_max = h - BossRoomInfo.h - DistanceToMapEdgeY - 1
    -- 一定靠边
    if 1 == road_dir then -- left
        x_min = x_max - 1
    elseif 2 == road_dir then -- top
        y_min = y_max - 1
    elseif 3 == road_dir then -- right
        x_max = x_min + 1
    else -- bottom
        y_max = y_min + 1
    end

    -- print(x_min, x_max)
    -- print(y_min, y_max)
    local x = math.random(math.floor(x_min), math.floor(x_max))
    local y = math.random(math.floor(y_min), math.floor(y_max))
    ChangeRoomOffset(BossRoomInfo, x, y)
    CurRegionId = CurRegionId + 1
    BossRoomInfo.RegionId = CurRegionId
    BossRoomInfo.Roomtype = "boss"
    m_rBossRoom = BossRoomInfo

    -- 开门
    local DoorWallCnt = math.ceil(doorsize / _RoomClass.WallSize)
    local wall = m_rBossRoom.Walls[road_dir]
    local DoorId = math.random(#wall.w - DoorWallCnt + 1)
    m_rBossRoom.Doors = {}
    m_rBossRoom.Doors[1] = {}
    m_rBossRoom.Doors[1].p = {}
    for i = 0, DoorWallCnt - 1 do
        for _, pos in base.pairs(wall.w[DoorId + i].p) do
            m_rBossRoom.Doors[1].p[#m_rBossRoom.Doors[1].p + 1] = pos
        end
        wall.w[DoorId + i].del = true
    end

    local RoomInfo = {}
    local _x = 0
    local _y = 0
    if 1 == road_dir then -- left
        _x = x - roadlen + 1
        _y = m_rBossRoom.Doors[1].p[1].y
        RoomInfo = GenerateRoom(_RoomClass, roadlen, doorsize)
    elseif 2 == road_dir then -- top
        _x = m_rBossRoom.Doors[1].p[1].x
        _y = y - roadlen + 1
        RoomInfo = GenerateRoom(_RoomClass, doorsize, roadlen)
    elseif 3 == road_dir then -- right
        _x = x + m_rBossRoom.w - 1
        _y = m_rBossRoom.Doors[1].p[1].y
        RoomInfo = GenerateRoom(_RoomClass, roadlen, doorsize)
    else -- bottom
        _x = m_rBossRoom.Doors[1].p[1].x
        _y = y + m_rBossRoom.h - 1
        RoomInfo = GenerateRoom(_RoomClass, doorsize, roadlen)
    end
    ChangeRoomOffset(RoomInfo, _x, _y)
    CurRegionId = CurRegionId + 1
    RoomInfo.RegionId = CurRegionId
    RoomInfo.Roomtype = "road" -- 通往boss房的路
    m_rRooms[#m_rRooms + 1] = RoomInfo
end
function _GetCenter(p1, p2)
    local p = {}
    p.x = (p1.x + p2.x) * 0.5
    p.y = (p1.y + p2.y) * 0.5
    return p
end

-- 判断坐标x,y处是否是地图边缘
---@param x number 地图坐标X
---@param y number 地图坐标Y
---@return boolean
function _check_edge(x, y)
    -- 以x,y坐标为中心的九宫格区域
    for i = -1, 1 do
        for j = -1, 1 do
            -- 只要存在一个块不属于任何房间，则该坐标为地图边缘格子
            if m_iValueArray[x + i][y + j] == 0 then
                return true
            end
        end
    end
    return false
end

---@param w number 可供生成的地图区域宽度
---@param h number 可供生成的地图区域高度
---@param RoomClass table 房间类型的预定义和生成参数配置（默认值m_RoomClass），units_list.random_RoomClass
function _addRooms(w, h, RoomClass)
    local _RoomClass = m_RoomClass
    if RoomClass ~= nil then
        _RoomClass = RoomClass
    end
    -- 地图边缘距离 = 墙的距离
    DistanceToMapEdgeX = _RoomClass.DistanceOfWalls
    DistanceToMapEdgeY = _RoomClass.DistanceOfWalls
    -- 可供生成的区域必须满足最大生成尺寸的情况
    if w == nil or h == nil or w <= _RoomClass.MaxRoomSize + DistanceToMapEdgeX * 2 or h <= _RoomClass.MaxRoomSize +
        DistanceToMapEdgeY * 2 then
        return
    end
    m_rRooms = {}
    -- 生成boss房间
    if _RoomClass.BossRoom == true and _RoomClass.BossRoomInfo then
        _addBossRoom(w, h, _RoomClass, _RoomClass.BossRoomInfo.doorsize, _RoomClass.BossRoomInfo.max_road_len,
            _RoomClass.BossRoomInfo.w, _RoomClass.BossRoomInfo.h)
    end
    local numRoomTries = 100
    -- 扔房间的尝试次数。当要求房间都连接时，需要这个数很大（比如1000)才能生成比较满的地图
    if _RoomClass.RoomTryTimes then
        numRoomTries = _RoomClass.RoomTryTimes
    end
    local MaxRoomCnt = -1
    -- 若<0，则不限制，否则最多房间数目为MaxRoomCnt
    -- TODO: 使用强制中断生成容易出现不可控的效果，应当在生成前就预先进行“布局设计”
    if _RoomClass.MaxRoomCnt then
        MaxRoomCnt = _RoomClass.MaxRoomCnt
    end

    if numRoomTries > 0 and #(_RoomClass.Rooms) then
        local ConstRoomCnt = #(_RoomClass.Rooms)
        for i = 1, numRoomTries do
            if MaxRoomCnt > 0 and MaxRoomCnt <= #m_rRooms then
                break
            end
            -- 在预定义的所有房间种类中随机选择
            -- 默认值m_RoomClass.Rooms{...}
            -- 配置值units_list.random_RoomClass.Rooms{...}
            local CurConstRoom = _RoomClass.Rooms[math.random(ConstRoomCnt)]
            _addRoom(w, h, _RoomClass, CurConstRoom.add_type == "connect", CurConstRoom.w, CurConstRoom.h)
        end
    end
    -- carve rooms 
    -- 最后添加Boss房间
    if m_rBossRoom then
        m_rRooms[#m_rRooms + 1] = m_rBossRoom
        m_rBossRoom = nil
    end

    -- 保存每个房间覆盖的区域中每个坐标的信息:所属房间ID和Tile类型
    for _, RoomValue in base.pairs(m_rRooms) do
        for j = 0, RoomValue.w - 1 do
            for k = 0, RoomValue.h - 1 do
                local x = j + RoomValue.x
                local y = k + RoomValue.y;
                _record(x, y, RoomValue.RegionId, TileType.Way)
            end
        end
    end

    -- 找到墙
    -- 记录处于地图边缘的墙块，预删除非边缘墙块

    -- 墙壁块数组：{ {x=x1,y=y1},{x=x2,y=y2},... }
    local wall_blocks = {}
    for _, RoomValue in base.pairs(m_rRooms) do
        -- 只需要检查边

        -- 该房间包含的墙块总数
        local wallblock_temp = #wall_blocks
        -- 上下墙壁的最左侧非边缘墙块
        local top_bottom1
        -- 上下墙壁的最右侧非边缘墙块
        local top_bottom2
        -- 左右墙壁的最上侧非边缘墙块
        local left_right1
        -- 左右墙壁的最下侧非边缘墙块
        local left_right2
        -- 该房间预删除的墙块总数
        local delwalls = 0
        -- 上下墙壁
        for in_x = 0, RoomValue.w - 1 do
            local map_x = in_x + RoomValue.x
            -- 此处能确定map的Y轴方向朝下
            -- 上侧Y坐标
            local map_y_top = RoomValue.y
            -- 下侧Y坐标
            local map_y_bottom = RoomValue.y + RoomValue.h - 1
            -- 上侧
            if _check_edge(map_x, map_y_top) then
                wall_blocks[#wall_blocks + 1] = {
                    x = map_x,
                    y = map_y_top
                }
                _record(map_x, map_y_top, RoomValue.RegionId, TileType.Wall)
            else
                if top_bottom1 == nil then
                    top_bottom1 = in_x
                end
                top_bottom2 = in_x
                delwalls = delwalls + 1
                -- 上侧墙壁
                RoomValue.Walls[2].HasDel = true
            end
            -- 下侧
            if _check_edge(map_x, map_y_bottom) then
                wall_blocks[#wall_blocks + 1] = {
                    x = map_x,
                    y = map_y_bottom
                }
                _record(map_x, map_y_bottom, RoomValue.RegionId, TileType.Wall)
            else
                if top_bottom1 == nil then
                    top_bottom1 = in_x
                end
                top_bottom2 = in_x
                delwalls = delwalls + 1
                -- 下侧墙壁
                RoomValue.Walls[4].HasDel = true
            end
        end
        -- 左右墙壁
        for in_y = 1, RoomValue.h - 2 do
            -- 此处能确定map的X轴方向朝右
            -- 左侧X坐标
            local map_x_left = RoomValue.x
            -- 右侧X坐标
            local map_x_right = RoomValue.x + RoomValue.w - 1
            local map_y = in_y + RoomValue.y;
            -- 左侧
            if _check_edge(map_x_left, map_y) then
                wall_blocks[#wall_blocks + 1] = {
                    x = map_x_left,
                    y = map_y
                }
                _record(map_x_left, map_y, RoomValue.RegionId, TileType.Wall)
            else
                if left_right1 == nil then
                    left_right1 = in_y
                end
                left_right2 = in_y
                delwalls = delwalls + 1
                -- 左侧墙壁
                RoomValue.Walls[1].HasDel = true
            end
            -- 右侧
            if _check_edge(map_x_right, map_y) then
                wall_blocks[#wall_blocks + 1] = {
                    x = map_x_right,
                    y = map_y
                }
                _record(map_x_right, map_y, RoomValue.RegionId, TileType.Wall)
            else
                if left_right1 == nil then
                    left_right1 = in_y
                end
                left_right2 = in_y
                delwalls = delwalls + 1
                -- 右侧墙壁
                RoomValue.Walls[3].HasDel = true
            end
        end
        wallblock_temp = #wall_blocks - wallblock_temp
        -- 判断房间类型
        -- TODO: 有什么作用？
        local delRate = 3
        if RoomValue.Roomtype == nil then
            local Terminal = {}
            if wallblock_temp <= RoomValue.w + RoomValue.h then
                RoomValue.Roomtype = "normal"
                -- base.print("0000000000000000000000000000111111111111111111111111111222222222222222222222")
                -- base.print("w ="..RoomValue.w..", h="..RoomValue.w.." | blockCnt="..wallblock_temp)
            elseif RoomValue.w >= RoomValue.h * 2 then
                -- TODO: WHY？
                if delwalls * delRate >= (RoomValue.w + RoomValue.h - 1) * 2 then
                    RoomValue.Roomtype = "normal"
                else
                    RoomValue.Roomtype = "road"
                end
                if (top_bottom1 == nil or top_bottom1 > 3) and RoomValue.Walls[1].HasDel == nil then
                    Terminal[#Terminal + 1] = {
                        x = RoomValue.x + 2,
                        y = RoomValue.y + math.floor(RoomValue.h * 0.5)
                    }
                end
                if (top_bottom2 == nil or top_bottom2 < RoomValue.w - 4) and RoomValue.Walls[3].HasDel == nil then
                    Terminal[#Terminal + 1] = {
                        x = RoomValue.x + RoomValue.w - 3,
                        y = RoomValue.y + math.floor(RoomValue.h * 0.5)
                    }
                end
            elseif RoomValue.h >= RoomValue.w * 2 then
                if delwalls * delRate >= (RoomValue.w + RoomValue.h - 1) * 2 then
                    RoomValue.Roomtype = "normal"
                else
                    RoomValue.Roomtype = "road"
                end
                if (left_right1 == nil or left_right1 > 3) and RoomValue.Walls[2].HasDel == nil then
                    Terminal[#Terminal + 1] = {
                        x = RoomValue.x + math.floor(RoomValue.w * 0.5),
                        y = RoomValue.y + 2
                    }
                end
                if (left_right2 == nil or left_right2 < RoomValue.h - 4) and RoomValue.Walls[4].HasDel == nil then
                    Terminal[#Terminal + 1] = {
                        x = RoomValue.x + math.floor(RoomValue.w * 0.5),
                        y = RoomValue.y + RoomValue.h - 3
                    }
                end
            else
                RoomValue.Roomtype = "normal"
            end
            if #Terminal > 0 then
                RoomValue.TerminalPos = Terminal
            end
        end
    end
    m_wall_blocks = wall_blocks
    -- TODO: 开门效果待测试
    for keyRoom, RoomValue in base.pairs(m_rRooms) do
        local WallsCntOpenDoor = 0
        for _, Walls in base.pairs(RoomValue.Walls) do
            if not Walls.HasDel and #Walls.w > 1 then
                WallsCntOpenDoor = WallsCntOpenDoor + #Walls.w - 1
            end
        end
        if RoomValue.Doors == nil then
            RoomValue.Doors = {}
        end
        -- 开门
        -- 条件：尚未开门 && 
        if #RoomValue.Doors == 0 and WallsCntOpenDoor > 0 and math.random(100) < RoomClass.DoorRate then
            local DoorId = math.random(WallsCntOpenDoor)
            local WallsIdx = 1
            for _, Walls in base.pairs(RoomValue.Walls) do
                if not Walls.HasDel then
                    if DoorId < #Walls.w then
                        -- 两块墙开一个门
                        local curIdx = #RoomValue.Doors + 1
                        -- local Door = {,Walls.w[DoorId+1].p[#(Walls.w[DoorId+1].p)]}
                        RoomValue.Doors[curIdx] = {}
                        RoomValue.Doors[curIdx].p = {}
                        for i = 0, 1 do
                            for _, pos in base.pairs(Walls.w[DoorId + i].p) do
                                RoomValue.Doors[curIdx].p[#RoomValue.Doors[curIdx].p + 1] = pos
                                _record(pos.x, pos.y, RoomValue.RegionId, TileType.Door)
                            end
                            Walls.w[DoorId + i].del = true
                        end
                        break
                    else
                        DoorId = DoorId - #Walls.w + 1
                    end
                end
                WallsIdx = WallsIdx + 1
            end
        end
    end

end

---@param RoomClass table 定义:units_list.random_RoomClass
function RandomMap.EasyMap(w, h, RoomClass, Seed)
    ResetMap(w, h)
    base.print("-----------------RandomMap-------------------------")
    PrepareRandom(Seed)
    base.print("random map seed:" .. GetRandomSeed())
    _addRooms(w, h, RoomClass)
    -- PrintTable(m_rRooms)
    return m_rRooms
end

function _set_door(UnitList, _beginX, _beginY, _objInfo, doorpos0, doorpos1, _pixSize, RoomValue)
    if doorpos0.x ~= doorpos1.x then
        UnitList[#UnitList + 1] = {
            4,
            _objInfo.door_h.objId,
            0,
            _beginX + doorpos0.x * _pixSize + _objInfo.door_h.offsetX,
            _beginY + doorpos0.y * _pixSize + _objInfo.door_h.offsetY,
            _objInfo.door_h.rot,
            0
        }
        UnitList[#UnitList + 1] = {
            4,
            _objInfo.door_h.objId,
            0,
            _beginX + doorpos1.x * _pixSize + _objInfo.door_h.offsetX,
            _beginY + doorpos1.y * _pixSize + _objInfo.door_h.offsetY,
            _objInfo.door_h.rot,
            0
        }
    else
        UnitList[#UnitList + 1] = {
            4,
            _objInfo.door_v.objId,
            0,
            _beginX + doorpos0.x * _pixSize + _objInfo.door_v.offsetX,
            _beginY + doorpos0.y * _pixSize + _objInfo.door_v.offsetY,
            _objInfo.door_v.rot,
            0
        }
        UnitList[#UnitList + 1] = {
            4,
            _objInfo.door_v.objId,
            0,
            _beginX + doorpos1.x * _pixSize + _objInfo.door_v.offsetX,
            _beginY + doorpos1.y * _pixSize + _objInfo.door_v.offsetY,
            _objInfo.door_v.rot,
            0
        }
    end
end

---@param objstr string 即CheckStr，包含字符['1','0']
---@param objInfo table 战车随机地图房间avatarInfoId指定皮肤信息。randmaproom_config.lua -> hVar.RANDMAP_ROOM_AVATAR_INFO[avatarInfoId]
---@param TypeStr string 即TypeStr，包含字符['w','r','e']
---@return table,table pos:{x=0,y=0}, obj:room_config.lua -> corner_XX或corner_XX1
function _CheckAndAddCornerObject(objstr, objInfo, TypeStr)
    local pos = nil
    local obj = nil
    if objstr == "1110" then -- 朝左上的角
        pos = {
            x = 0,
            y = 0
        }
        -- 第4个子字符串，对应"0"的位置，判断是否是房间类型
        if string.sub(TypeStr, 4, 4) == "r" then
            obj = objInfo.corner_lt --left_top
        else
            obj = objInfo.corner_lt1
        end
    elseif objstr == "1101" then -- 朝右上的角
        pos = {
            x = 0,
            y = 0
        }
        -- 第3个子字符串，对应"0"的位置，判断是否是房间类型
        if string.sub(TypeStr, 3, 3) == "r" then
            obj = objInfo.corner_rt --right_top
        else
            obj = objInfo.corner_rt1
        end
    elseif objstr == "1011" then -- 朝左下的角
        pos = {
            x = 0,
            y = 0
        }
        -- 第2个子字符串，对应"0"的位置，判断是否是房间类型
        if string.sub(TypeStr, 2, 2) == "r" then
            obj = objInfo.corner_lb --left_bottom
        else
            obj = objInfo.corner_lb1
        end
    elseif objstr == "0111" then -- 朝右下的角
        pos = {
            x = 0,
            y = 0
        }
        -- 第1个子字符串，对应"0"的位置，判断是否是房间类型
        if string.sub(TypeStr, 1, 1) == "r" then
            obj = objInfo.corner_rb --right_bottom
        else
            obj = objInfo.corner_rb1
        end
    end
    return pos, obj
end

function _CheckAndAddCornerObject1(objstr, objInfo, TypeStr) -- 当角只占一格时，output里面的pos才需要carve，其它不用
    local pos = nil
    local obj = nil
    if objstr == "1110" then -- 角
        pos = {
            x = 0,
            y = 0
        }
        if string.sub(TypeStr, 4, 4) == "r" then
            obj = objInfo.corner_lt
        else
            obj = objInfo.corner_lt1
        end
    elseif objstr == "1101" then
        pos = {
            x = 1,
            y = 0
        }
        if string.sub(TypeStr, 3, 3) == "r" then
            obj = objInfo.corner_rt
        else
            obj = objInfo.corner_rt1
        end
    elseif objstr == "1011" then
        pos = {
            x = 0,
            y = 1
        }
        if string.sub(TypeStr, 2, 2) == "r" then
            obj = objInfo.corner_lb
        else
            obj = objInfo.corner_lb1
        end
    elseif objstr == "0111" then
        pos = {
            x = 1,
            y = 1
        }
        if string.sub(TypeStr, 1, 1) == "r" then
            obj = objInfo.corner_rb
        else
            obj = objInfo.corner_rb1
        end
    end
    return pos, obj
end

function _CheckAndAddObject(objstr, objInfo, TypeStr)
    local pos = nil
    local obj = nil
    if objstr == "1000" then -- 单块
        pos = {
            x = 0,
            y = 0
        }
        if string.sub(TypeStr, 2, 2) == "w" then
            obj = objInfo.swall_h
        else
            obj = objInfo.swall_v
        end
    elseif objstr == "0100" then
        pos = {
            x = 1,
            y = 0
        }
        if string.sub(TypeStr, 1, 1) == "w" then
            obj = objInfo.swall_h
        else
            obj = objInfo.swall_v
        end
    elseif objstr == "0010" then
        pos = {
            x = 0,
            y = 1
        }
        if string.sub(TypeStr, 4, 4) == "w" then
            obj = objInfo.swall_h
        else
            obj = objInfo.swall_v
        end
    elseif objstr == "0001" then
        pos = {
            x = 1,
            y = 1
        }
        if string.sub(TypeStr, 3, 3) == "w" then
            obj = objInfo.swall_h
        else
            obj = objInfo.swall_v
        end
    elseif objstr == "1100" then -- 横条
        pos = {
            x = 0,
            y = 0
        }
        if string.sub(TypeStr, 4, 4) == "r" or string.sub(TypeStr, 3, 3) == "r" then
            obj = objInfo.wall_t
        else
            obj = objInfo.wall_b
        end
    elseif objstr == "0011" then
        pos = {
            x = 0,
            y = 1
        }
        obj = objInfo.wall_t
        if string.sub(TypeStr, 1, 1) == "r" or string.sub(TypeStr, 2, 2) == "r" then
            obj = objInfo.wall_b
        else
            obj = objInfo.wall_t
        end
    elseif objstr == "1010" then -- 竖条
        pos = {
            x = 0,
            y = 0
        }
        if string.sub(TypeStr, 4, 4) == "r" or string.sub(TypeStr, 2, 2) == "r" then
            obj = objInfo.wall_l
        else
            obj = objInfo.wall_r
        end
    elseif objstr == "0101" then
        pos = {
            x = 1,
            y = 0
        }
        if string.sub(TypeStr, 1, 1) == "r" or string.sub(TypeStr, 3, 3) == "r" then
            obj = objInfo.wall_r
        else
            obj = objInfo.wall_l
        end
    end
    return pos, obj
end

-- 构建检查用的字符串，构建顺序：左上、右上、左下、右下
---@param i number 地图坐标X
---@param j number 地图坐标Y
---@return string,string,string CheckStr["1","0"], changeArr, TypeStr["w","r","e"]
function _BuildCheckStr(i, j)
    local CheckStr = ""
    local changeArr = {}
    -- 记录类型
    local TypeStr = ""
    -- 检测当前块
    if m_tTileArray[i][j] == TileType.Wall or m_tTileArray[i][j] == TileType.Corner then
        CheckStr = CheckStr .. "1"
        TypeStr = TypeStr .. "w" --wall
        changeArr[#changeArr + 1] = {
            x = i,
            y = j
        }
    else
        CheckStr = CheckStr .. "0"
        if m_iValueArray[i][j] > 0 then
            if m_tTileArray[i][j] == TileType.Pending or m_tTileArray[i][j] == TileType.Door then
                TypeStr = TypeStr .. "w" --wall
            else
                TypeStr = TypeStr .. "r" --room
            end
        else
            TypeStr = TypeStr .. "e" --empty
        end
    end
    -- 检测右侧相邻块
    if m_tTileArray[i + 1][j] == TileType.Wall or m_tTileArray[i + 1][j] == TileType.Corner then
        CheckStr = CheckStr .. "1"
        TypeStr = TypeStr .. "w" --wall
        changeArr[#changeArr + 1] = {
            x = i + 1,
            y = j
        }
    else
        CheckStr = CheckStr .. "0"
        if m_iValueArray[i + 1][j] > 0 then
            if m_tTileArray[i + 1][j] == TileType.Pending or m_tTileArray[i + 1][j] == TileType.Door then
                TypeStr = TypeStr .. "w" --wall
            else
                TypeStr = TypeStr .. "r" --room
            end
        else
            TypeStr = TypeStr .. "e" --empty
        end
    end
    -- 检测下侧相邻块
    if m_tTileArray[i][j + 1] == TileType.Wall or m_tTileArray[i][j + 1] == TileType.Corner then
        CheckStr = CheckStr .. "1"
        TypeStr = TypeStr .. "w" --wall
        changeArr[#changeArr + 1] = {
            x = i,
            y = j + 1
        }
    else
        CheckStr = CheckStr .. "0"
        if m_iValueArray[i][j + 1] > 0 then
            if m_tTileArray[i][j + 1] == TileType.Pending or m_tTileArray[i][j + 1] == TileType.Door then
                TypeStr = TypeStr .. "w" --wall
            else
                TypeStr = TypeStr .. "r" --room
            end
        else
            TypeStr = TypeStr .. "e" --empty
        end
    end
    -- 检测右下角块
    if m_tTileArray[i + 1][j + 1] == TileType.Wall or m_tTileArray[i + 1][j + 1] == TileType.Corner then
        CheckStr = CheckStr .. "1"
        TypeStr = TypeStr .. "w" --wall
        changeArr[#changeArr + 1] = {
            x = i + 1,
            y = j + 1
        }
    else
        CheckStr = CheckStr .. "0"
        if m_iValueArray[i + 1][j + 1] > 0 then
            if m_tTileArray[i + 1][j + 1] == TileType.Pending or m_tTileArray[i + 1][j + 1] == TileType.Door then
                TypeStr = TypeStr .. "w" --wall
            else
                TypeStr = TypeStr .. "r" --room
            end
        else
            TypeStr = TypeStr .. "e" --empty
        end
    end
    return CheckStr, changeArr, TypeStr
end

-- 根据格子类型添加地图单位
---@param objInfo table 战车随机地图房间avatarInfoId指定皮肤信息。randmaproom_config.lua -> hVar.RANDMAP_ROOM_AVATAR_INFO[avatarInfoId]
---@param UnitList table 所有地图单位数组:元素{unitType, id, owner, worldX, worldY, facing, triggerID}
---@param _beginX number 起始地图位置偏移X轴坐标
---@param _beginY number 起始地图位置偏移Y轴坐标
---@param _pixSize number 像素大小
---@param bSingleCorner boolean 是否启用单块
function _AddObjectByTileType(objInfo, UnitList, _beginX, _beginY, _pixSize, bSingleCorner)
    -- 墙壁块数组：{ {x=x1,y=y1},{x=x2,y=y2},... }
    for _, p0 in base.pairs(m_wall_blocks) do
        for i = -1, 0 do
            for j = -1, 0 do
                -- 以当前墙壁块为右下角的四宫格
                local x = p0.x + i
                local y = p0.y + j
                -- 2个四宫格遍历正好覆盖以p0为中心的九宫格区域
                -- CheckStr包含字符['1','0']
                -- changeArr中的格子均对应['1']和['w']
                -- TypeStr包含字符['w','r','e']
                local CheckStr, changeArr, TypeStr = _BuildCheckStr(x, y)
                if bSingleCorner then
                    local pos, obj = _CheckAndAddCornerObject1(CheckStr, objInfo, TypeStr)
                    if pos ~= nil and obj ~= nil then
                        UnitList[#UnitList + 1] = {
                            4,
                            obj.objId, --配置于randmaproom_config.lua
                            0,
                            -- TODO: 什么原理？
                            _beginX + (pos.x + x) * _pixSize + obj.offsetX,
                            _beginY + (pos.y + y) * _pixSize + obj.offsetY,
                            0,
                            0
                        }
                        _record(x + pos.x, y + pos.y, nil, TileType.Pending)
                    end
                else
                    local pos, obj = _CheckAndAddCornerObject(CheckStr, objInfo, TypeStr)
                    if pos ~= nil and obj ~= nil then
                        UnitList[#UnitList + 1] = {
                            4,
                            obj.objId, --配置于randmaproom_config.lua
                            0,
                            -- TODO: 什么原理？
                            _beginX + (pos.x + x) * _pixSize + obj.offsetX,
                            _beginY + (pos.y + y) * _pixSize + obj.offsetY,
                            0,
                            0
                        }
                        for _, p in base.pairs(changeArr) do
                            _record(p.x, p.y, nil, TileType.Pending)
                        end
                    end
                end
            end
        end
    end

    for _, p0 in base.pairs(m_wall_blocks) do
        if m_tTileArray[p0.x][p0.y] == TileType.Wall then
            local CheckStr, changeArr, TypeStr = _BuildCheckStr(p0.x, p0.y)
            local pos, obj = _CheckAndAddObject(CheckStr, objInfo, TypeStr)
            if pos ~= nil and obj ~= nil then
                UnitList[#UnitList + 1] = {
                    4,
                    obj.objId,
                    0,
                    _beginX + (pos.x + p0.x) * _pixSize + obj.offsetX,
                    _beginY + (pos.y + p0.y) * _pixSize + obj.offsetY,
                    0,
                    0
                }
            end
            for _, p in base.pairs(changeArr) do
                _record(p.x, p.y, nil, TileType.Pending)
            end
        end
    end
end

-- 获取所有物体
---@param objInfo table 战车随机地图房间avatarInfoId指定皮肤信息。randmaproom_config.lua -> hVar.RANDMAP_ROOM_AVATAR_INFO[avatarInfoId]
---@param PixSize number 像素大小
---@param RoomClass table 定义：units_list.random_RoomClass
---@param beginX number 起始地图位置偏移X轴像素
---@param beginY number 起始地图位置偏移Y轴像素
---@return table,table 1所有地图单位|2所有已生成房间
function RandomMap.GetAllObject(objInfo, PixSize, RoomClass, beginX, beginY)
    -- 默认像素大小
    local _pixSize = 16
    if PixSize ~= nil then
        _pixSize = PixSize
    end
    -- 起始地图位置偏移X轴坐标
    -- 起始地图位置偏移Y轴坐标
    local _beginX = 0
    local _beginY = 0
    if beginX and beginY then
        _beginX = beginX * _pixSize
        _beginY = beginY * _pixSize
    end
    -- 默认皮肤配置
    local _objInfo = m_ObjectInfo
    if objInfo ~= nil then
        _objInfo = objInfo
    end
    -- 默认房间配置
    local _RoomClass = m_RoomClass
    if RoomClass ~= nil then
        _RoomClass = RoomClass
    end

    -- 所有地图单位
    local UnitList = {}
    -- TODO: 什么作用？
    local bUseSingleCorner = false -- 是否启用单块
    _AddObjectByTileType(_objInfo, UnitList, _beginX, _beginY, _pixSize, bUseSingleCorner)
    for _, RoomValue in base.pairs(m_rRooms) do
        local strRoomType = RoomValue.Roomtype -- 区域类型
        if (strRoomType ~= "boss") then
            for _, Door in base.pairs(RoomValue.Doors) do
                -- 每个门加两个门柱
                if Door and #Door.p > 0 then
                    _set_door(UnitList, _beginX, _beginY, _objInfo, Door.p[1], Door.p[#Door.p], _pixSize, RoomValue)
                end
            end
        end
        RoomValue.Walls = nil
        RoomValue.Corners = nil

    end
    -- PrintTable(UnitList)
    m_iValueArray = {}
    m_tTileArray = {}
    return UnitList, m_rRooms
end
