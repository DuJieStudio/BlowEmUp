--Vip管理类
local VipMgr = class("VipMgr")
	
	--构造函数
	function VipMgr:ctor()
		--其他
		return self
	end
	
	--初始化函数
	function VipMgr:Init()
		return self
	end
	
	------------------------------------------------------------private-------------------------------------------------------
	--获得玩家充值数额
	function VipMgr:_DBGetUserTopup(udbid)
		
		--查找玩家充值数量
		local sql = string.format("SELECT SUM(`money`),SUM(`coin_base`),SUM(`coin_base` + `coin_ext`) FROM `iap_record` where `uid`=%d AND `flag` IN (1,4)",udbid)
		local err, money, coin_base, coin = xlDb_Query(sql)
		if err == 0 then
			return tonumber(money) or 0, tonumber(coin_base) or 0, tonumber(coin) or 0
		else
			return 0,0,0
		end
	end
	
	--获得玩家vip等级
	function VipMgr:_DBGetUserVip(udbid)
		local vipLv = 0
		
		local money, coin_base, coin = self:_DBGetUserTopup(udbid)
		
		local vipcfg = hVar.Vip_Conifg
		if vipcfg then
			local vipMax = vipcfg.maxVipLv
			local conditionCoin = vipcfg.condition.coin
			for i = 1, vipMax do
				--print("VipMgr:_DBGetUserVip:",coin_base,conditionCoin[i],type(coin_base),type(conditionCoin[i]))
				if coin_base >= conditionCoin[i] then
					vipLv = i
				else
					break
				end
			end
		end
		
		return vipLv, money, coin_base, coin
	end
	
	------------------------------------------------------------public-------------------------------------------------------
	
	--获得玩家vip等级
	function VipMgr:DBGetUserVip(udbid)
		return self:_DBGetUserVip(udbid)
	end
	
return VipMgr