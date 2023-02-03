--Ӣ�۽��������
local HeroDebrisMgr = class("HeroDebrisMgr")
	
	--���캯��
	function HeroDebrisMgr:ctor()
		--����
		return self
	end
	
	--��ʼ������
	function HeroDebrisMgr:Init()
		return self
	end
	
	------------------------------------------------------------private-------------------------------------------------------
	--������Ӣ�۽�����Ϣ
	function HeroDebrisMgr:_DBGetUserHeroDebris(uid, rid)
		local tHeroInfo = {}
		local strHeroInfo = ""
		
		--�������Ӣ����Ƭ��Ϣ
		local sql = string.format("SELECT `heroInfo` FROM `t_pvp_user` where `id` = %d AND `uid` = %d", rid, uid)
		local err, sInfo = xlDb_Query(sql)
		if (err == 0) then
			--4;18008:2:0:100;18001:2:1:101;18002:2:1:101;18003:2:0:100;
			strHeroInfo = sInfo
			local tCmd = hApi.Split(strHeroInfo, ";")
			local heroNum = tonumber(tCmd[1]) or 0 --Ӣ������
			
			local rIdx = 1
			for i = 1, heroNum, 1 do
				local tHero = hApi.Split(tCmd[rIdx+1], ":")
				local heroId = tonumber(tHero[1]) or 0 --Ӣ��id
				local star = tonumber(tHero[2]) or 0 --Ӣ���Ǽ�
				local debrisNum = tonumber(tHero[3]) or 0 --Ӣ����Ƭ����
				local debrisTotalNum = tonumber(tHero[4]) or 0 --Ӣ����Ƭ��ʷ������
				
				tHeroInfo[#tHeroInfo+1] = {heroId = heroId, star = star, debrisNum = debrisNum, debrisTotalNum = debrisTotalNum,}
				
				rIdx = rIdx + 1
			end
		end
		
		return tHeroInfo, strHeroInfo
	end
	
	------------------------------------------------------------public-------------------------------------------------------
	
	--������Ӣ�۽�����Ϣ
	function HeroDebrisMgr:DBGetUserHeroDebris(uid, rid)
		return self:_DBGetUserHeroDebris(uid, rid)
	end
	
	--�۳����Ӣ�۽�������
	function HeroDebrisMgr:DBDecreaseUserHeroDebris(uid, rid, tCardList)
		local tHeroInfo, strHeroInfo = self:_DBGetUserHeroDebris(uid, rid)
		
		--���α����۳�
		for t = 1, #tCardList, 1 do
			local heroId = tCardList[t].id
			local heroNum = tCardList[t].num
			if (heroNum > 0) then
				if (heroId > 0) then
					--�۳�����
					for k = 1, #tHeroInfo, 1 do
						local tHero = tHeroInfo[k]
						local id = tHero.heroId --Ӣ��id
						local star = tHero.star --Ӣ���Ǽ�
						local debrisNum = tHero.debrisNum --Ӣ����Ƭ����
						local debrisTotalNum = tHero.debrisTotalNum --Ӣ����Ƭ��ʷ������
						
						if (heroId == id) then --�ҵ���
							tHero.debrisNum = debrisNum - heroNum
							break
						end
					end
				end
			end
		end
		
		--�浵
		local saveHeroInfo = ""
		for k = 1, #tHeroInfo, 1 do
			local tHero = tHeroInfo[k]
			local id = tHero.heroId --Ӣ��id
			local star = tHero.star --Ӣ���Ǽ�
			local debrisNum = tHero.debrisNum --Ӣ����Ƭ����
			local debrisTotalNum = tHero.debrisTotalNum --Ӣ����Ƭ��ʷ������
			
			saveHeroInfo = saveHeroInfo .. tostring(id) .. ":" .. tostring(star) .. ":" .. tostring(debrisNum) .. ":" .. tostring(debrisTotalNum) .. ";"
		end
		
		saveHeroInfo = tostring(#tHeroInfo) .. ";" .. saveHeroInfo
		local sql = string.format("update `t_pvp_user` set `heroInfo` = '%s' where `id` = %d AND `uid` = %d", saveHeroInfo, rid, uid)
		xlDb_Execute(sql)
	end
	
return HeroDebrisMgr