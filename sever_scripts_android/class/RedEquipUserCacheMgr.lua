--玩家红装内存管理表
local RedEquipUserCacheMgr = class("RedEquipUserCacheMgr")
	
	--构造函数
	function RedEquipUserCacheMgr:ctor()
		
		self._userRedEquipMgrCache = -1	--玩家红装表
		
		return self
	end
	
	--初始化函数
	function RedEquipUserCacheMgr:Init()
		
		self._userRedEquipMgrCache = {}	--玩家红装表
		
		return self
	end
	
	--析构函数
	function RedEquipUserCacheMgr:Release()
		
		for uidrid, em in pairs(self._userRedEquipMgrCache) do
			if em and type(em) == "table" and em:getCName() == "RedEquipMgr" then
				em:Release()
				em = nil
			else
				em = nil
			end
		end
		
		self._userRedEquipMgrCache = -1
		
		return self
	end
	
	--获得玩家的全部红装
	function RedEquipUserCacheMgr:GetRedEquipMgr(uid, rid)
		
		--优先读内存里的数据
		local key = tostring(uid) .. "|" .. tostring(rid)
		local redequipMgr = self._userRedEquipMgrCache[key]
		if (redequipMgr == nil) then
			redequipMgr = hClass.RedEquipMgr:create(true):Init(uid, rid)
			self._userRedEquipMgrCache[key] = redequipMgr
			--print("GetRedEquipMgr sql load:", uid, rid)
		end
		
		return redequipMgr
	end
	
	--清除玩家的全部红装缓存数据
	function RedEquipUserCacheMgr:ClearRedEquipMgr(uid, rid)
		local key = tostring(uid) .. "|" .. tostring(rid)
		self._userRedEquipMgrCache[key] = nil
	end
	
return RedEquipUserCacheMgr