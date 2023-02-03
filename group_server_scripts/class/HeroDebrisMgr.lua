--英雄将魂管理类
local HeroDebrisMgr = class("HeroDebrisMgr")
	
	--构造函数
	function HeroDebrisMgr:ctor()
		--其他
		return self
	end
	
	--初始化函数
	function HeroDebrisMgr:Init()
		return self
	end
	
	------------------------------------------------------------private-------------------------------------------------------
	--获得玩家英雄将魂信息
	function HeroDebrisMgr:_DBGetUserHeroDebris(uid, rid)
		local tHeroInfo = {}
		local strHeroInfo = ""
		
		--查找玩家英雄碎片信息
		local sql = string.format("SELECT `heroInfo` FROM `t_pvp_user` where `id` = %d AND `uid` = %d", rid, uid)
		local err, sInfo = xlDb_Query(sql)
		if (err == 0) then
			--4;18008:2:0:100;18001:2:1:101;18002:2:1:101;18003:2:0:100;
			strHeroInfo = sInfo
			local tCmd = hApi.Split(strHeroInfo, ";")
			local heroNum = tonumber(tCmd[1]) or 0 --英雄数量
			
			local rIdx = 1
			for i = 1, heroNum, 1 do
				local tHero = hApi.Split(tCmd[rIdx+1], ":")
				local heroId = tonumber(tHero[1]) or 0 --英雄id
				local star = tonumber(tHero[2]) or 0 --英雄星级
				local debrisNum = tonumber(tHero[3]) or 0 --英雄碎片数量
				local debrisTotalNum = tonumber(tHero[4]) or 0 --英雄碎片历史总数量
				
				tHeroInfo[#tHeroInfo+1] = {heroId = heroId, star = star, debrisNum = debrisNum, debrisTotalNum = debrisTotalNum,}
				
				rIdx = rIdx + 1
			end
		end
		
		return tHeroInfo, strHeroInfo
	end
	
	------------------------------------------------------------public-------------------------------------------------------
	
	--获得玩家英雄将魂信息
	function HeroDebrisMgr:DBGetUserHeroDebris(uid, rid)
		return self:_DBGetUserHeroDebris(uid, rid)
	end
	
	--扣除玩家英雄将魂数量
	function HeroDebrisMgr:DBDecreaseUserHeroDebris(uid, rid, tCardList)
		local tHeroInfo, strHeroInfo = self:_DBGetUserHeroDebris(uid, rid)
		
		--依次遍历扣除
		for t = 1, #tCardList, 1 do
			local heroId = tCardList[t].id
			local heroNum = tCardList[t].num
			if (heroNum > 0) then
				if (heroId > 0) then
					--扣除数量
					for k = 1, #tHeroInfo, 1 do
						local tHero = tHeroInfo[k]
						local id = tHero.heroId --英雄id
						local star = tHero.star --英雄星级
						local debrisNum = tHero.debrisNum --英雄碎片数量
						local debrisTotalNum = tHero.debrisTotalNum --英雄碎片历史总数量
						
						if (heroId == id) then --找到了
							tHero.debrisNum = debrisNum - heroNum
							break
						end
					end
				end
			end
		end
		
		--存档
		local saveHeroInfo = ""
		for k = 1, #tHeroInfo, 1 do
			local tHero = tHeroInfo[k]
			local id = tHero.heroId --英雄id
			local star = tHero.star --英雄星级
			local debrisNum = tHero.debrisNum --英雄碎片数量
			local debrisTotalNum = tHero.debrisTotalNum --英雄碎片历史总数量
			
			saveHeroInfo = saveHeroInfo .. tostring(id) .. ":" .. tostring(star) .. ":" .. tostring(debrisNum) .. ":" .. tostring(debrisTotalNum) .. ";"
		end
		
		saveHeroInfo = tostring(#tHeroInfo) .. ";" .. saveHeroInfo
		local sql = string.format("update `t_pvp_user` set `heroInfo` = '%s' where `id` = %d AND `uid` = %d", saveHeroInfo, rid, uid)
		xlDb_Execute(sql)
	end
	
return HeroDebrisMgr