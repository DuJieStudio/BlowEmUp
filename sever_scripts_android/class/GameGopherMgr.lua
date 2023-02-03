--ս�����ܿ�������
local GameGopherMgr = class("GameGopherMgr")


--ը�����Ѷ����ñ�
hVar.GameGopherDiffDefine = {
	[1] = {
		unitid = 11109,		--����id
		unitid_ds = 11111,	--˫�����ֹ�
		unit_ds_num = 1,	--˫�����ֳֹ��ִ���
		gametime = 90,		--��Ϸʱ�� ��
		costcoin = 0,		--���Ļ���1
		refreshline = {	--ˢ���߳�  ÿһ���߳��Լ���������ˢ��ʱ�����ʧʱ��  �͹�������
			[1] = {
				refreshtime = 3500,	--ˢ��ʱ�� ����
				refreshstart = 500,	--��һ��ˢ��ʱ�� ����
				refreshend = 65000,	--����ʱ�� ����
				--mode 1����
				disappeartime = 7000,	--��ʧʱ�� ����
			},
			[2] = {
				refreshtime = 2500,	--ˢ��ʱ�� ����
				refreshstart = 63000,	--��һ��ˢ��ʱ�� ����
				--mode 1����
				disappeartime = 6000,	--��ʧʱ�� ����
			},
		},
		rule = {	--�ܼ�30��
			unit_score = 1,--��ͨ�������
			unitds_score = 2,--����������
			awards = {--��������ֻѡһ��
				{--�ﵽ�����Ľ���
					shouldscole = 999,	--ָ��
					must = {	--�ظ�
							{108,3},
						
					},
					rand = {	--�����
						num = 1,	--�·�������ѡ1��
						canrepeat = 1,	--���ظ����佱��
						pool = {	--�������
							{105,3},
							{106,3},
							{107,3},
							{108,3},
						},
					},
				},
				{--�ﵽ�����Ľ���
					shouldscole = 999,	--ָ��
					must = {	--�ظ�
							{108,5},
						
					},
					rand = {	--�����
						num = 1,	--�·�������ѡ1��
						canrepeat = 1,	--���ظ����佱��
						pool = {	--�������
							{105,5},
							{106,5},
							{107,5},
							{108,5},
						},
					},
				},
				{--�ﵽ�����Ľ���
					shouldscole = 999,	--ָ��
					must = {	--�ظ�
							{108,7},
						
					},
					rand = {	--�����
						num = 1,	--�·�������ѡ1��
						canrepeat = 1,	--���ظ����佱��
						pool = {	--�������
							{105,7},
							{106,7},
							{107,7},
							{108,7},
						},
					},
				},
			},
		},
	},
	[2] = {
		unitid = 11109,		--����id
		unitid_ds = 11111,	--˫�����ֹ�
		unit_ds_num = 2,	--˫�����ֳֹ��ִ���
		gametime = 90,		--��Ϸʱ�� ��
		costcoin = 1,		--���Ļ���1
		refreshline = {	--ˢ���߳�  ÿһ���߳��Լ���������ˢ��ʱ�����ʧʱ��  �͹�������
			[1] = {
				refreshtime = 3500,	--ˢ��ʱ�� ����
				refreshstart = 500,	--��һ��ˢ��ʱ�� ����
				refreshend = 65000,	--����ʱ�� ����
				--mode 1����
				disappeartime = 4000,	--��ʧʱ�� ����
			},
			[2] = {
				refreshtime = 2500,	--ˢ��ʱ�� ����
				refreshstart = 63000,	--��һ��ˢ��ʱ�� ����
				--mode 1����
				disappeartime = 4000,	--��ʧʱ�� ����
			},
		},
		rule = {	--�ܼ�30��
			unit_score = 1,--��ͨ�������
			unitds_score = 2,--����������
			awards = {--��������ֻѡһ��
				{--�ﵽ�����Ľ���
					shouldscole = 28,	--ָ��
					must = {	--�ظ�
							{108,4},
						
					},
					rand = {	--�����
						num = 2,	--�·�������ѡ1��
						canrepeat = 1,	--���ظ����佱��
						pool = {	--�������
							{105,4},
							{106,4},
							{107,4},
							{108,4},
						},
					},
				},
				{--�ﵽ�����Ľ���
					shouldscole = 30,	--ָ��
					must = {	--�ظ�
							{108,7},
						
					},
					rand = {	--�����
						num = 2,	--�·�������ѡ1��
						canrepeat = 1,	--���ظ����佱��
						pool = {	--�������
							{105,7},
							{106,7},
							{107,7},
							{108,7},
						},
					},
				},
				{--�ﵽ�����Ľ���
					shouldscole = 32,	--ָ��
					must = {	--�ظ�
							{108,10},
						
					},
					rand = {	--�����
						num = 2,	--�·�������ѡ1��
						canrepeat = 1,	--���ظ����佱��
						pool = {	--�������
							{105,10},
							{106,10},
							{107,10},
							{108,10},
						},
					},
				},
			},
		},
	},
	[3] = {
		unitid = 11109,		--����id
		unitid_ds = 11111,	--˫�����ֹ�
		unit_ds_num = 3,	--˫�����ֳֹ��ִ���
		gametime = 90,		--��Ϸʱ�� ��
		costcoin = 1,		--���Ļ���1
		refreshline = {	--ˢ���߳�  ÿһ���߳��Լ���������ˢ��ʱ�����ʧʱ��  �͹�������
			[1] = {
				refreshtime = 3000,	--ˢ��ʱ�� ����
				refreshstart = 500,	--��һ��ˢ��ʱ�� ����
				refreshend = 65000,	--����ʱ�� ����
				--mode 1����
				disappeartime = 4000,	--��ʧʱ�� ����
				--mode 2����
				movespeed = 60,	--�ƶ��ٶ�
				movelength = 200,	--�ƶ�����
				standtime = 500,	--�ƶ���Ŀ�ĵغ�ĵȴ�ʱ�� ����
				--actionmode ����Ĭ��ģʽ1
				--actionmode ����ֱ��������
				--actionmode = 2
				--actionmode �������� ��Ȩ��
				actionmode = {	-- 1 ԭ�ز��� Ȩ��40 ����ʧʱ��Ӱ��   2 �ƶ� Ȩ�� 60  ���ƶ����� �� �ƶ��ٶ�Ӱ��
					{1,30},
					{2,70},
				}
			},
			[2] = {
				refreshtime = 2000,	--ˢ��ʱ�� ����
				refreshstart = 65000,	--��һ��ˢ��ʱ�� ����
				--mode 1����
				disappeartime = 4000,	--��ʧʱ�� ����
				--mode 2����
				movespeed = 60,	--�ƶ��ٶ�
				movelength = 200,	--�ƶ�����
				standtime = 500,	--�ƶ���Ŀ�ĵغ�ĵȴ�ʱ�� ����
				actionmode = {	-- 1 ԭ�ز��� Ȩ��40 ����ʧʱ��Ӱ��   2 �ƶ� Ȩ�� 60  ���ƶ����� �� �ƶ��ٶ�Ӱ��
					{1,30},
					{2,70},
				}
			},
		},
		rule = {	--�ܼ�35��
			unit_score = 1,--��ͨ�������
			unitds_score = 2,--����������
			awards = {--��������ֻѡһ��
				{--�ﵽ�����Ľ���
					shouldscole = 34,	--ָ��
					must = {	--�ظ�
							{108,7},
						
					},
					rand = {	--�����
						num = 3,	--�·�������ѡ1��
						canrepeat = 1,	--���ظ����佱��
						pool = {	--�������
							{105,7},
							{106,7},
							{107,7},
							{108,7},
						},
					},
				},
				{--�ﵽ�����Ľ���
					shouldscole = 36,	--ָ��
					must = {	--�ظ�
							{108,11},
						
					},
					rand = {	--�����
						num = 3,	--�·�������ѡ1��
						canrepeat = 1,	--���ظ����佱��
						pool = {	--�������
							{105,11},
							{106,11},
							{107,11},
							{108,11},
						},
					},
				},
				{--�ﵽ�����Ľ���
					shouldscole = 38,	--ָ��
					must = {	--�ظ�
							{108,15},
						
					},
					rand = {	--�����
						num = 3,	--�·�������ѡ1��
						canrepeat = 1,	--���ظ����佱��
						pool = {	--�������
							{105,15},
							{106,15},
							{107,15},
							{108,15},
						},
					},
				},
			},
		},
	},
	[4] = {
		unitid = 11109,		--����id
		unitid_ds = 11111,	--˫�����ֹ�
		unit_ds_num = 5,	--˫�����ֳֹ��ִ���
		gametime = 90,		--��Ϸʱ�� ��
		costcoin = 1,		--���Ļ���1
		refreshline = {	--ˢ���߳�  ÿһ���߳��Լ���������ˢ��ʱ�����ʧʱ��  �͹�������
			[1] = {
				refreshtime = 3000,	--ˢ��ʱ�� ����
				refreshstart = 500,	--��һ��ˢ��ʱ�� ����
				refreshend = 62000,	--����ʱ�� ����
				--mode 1����
				disappeartime = 4000,	--��ʧʱ�� ����
				--mode 2����
				movespeed = 100,	--�ƶ��ٶ�
				movelength = 200,	--�ƶ�����
				standtime = 200,	--�ƶ���Ŀ�ĵغ�ĵȴ�ʱ�� ����
				--actionmode ����Ĭ��ģʽ1
				--actionmode ����ֱ��������
				--actionmode = 2
				--actionmode �������� ��Ȩ��
				actionmode = {	-- 1 ԭ�ز��� Ȩ��40 ����ʧʱ��Ӱ��   2 �ƶ� Ȩ�� 60  ���ƶ����� �� �ƶ��ٶ�Ӱ��
					{1,20},
					{2,80},
				}
			},
			[2] = {
				refreshtime = 5000,	--ˢ��ʱ�� ����
				refreshstart = 5000,	--��һ��ˢ��ʱ�� ����
				refreshend = 62000,	--����ʱ�� ����
				--mode 1����
				disappeartime = 4000,	--��ʧʱ�� ����
				--mode 2����
				movespeed = 100,	--�ƶ��ٶ�
				movelength = {200,350},	--�ƶ�����
				standtime = 200,	--�ƶ���Ŀ�ĵغ�ĵȴ�ʱ�� ����
				--actionmode ����Ĭ��ģʽ1
				--actionmode ����ֱ��������
				--actionmode = 2
				--actionmode �������� ��Ȩ��
				actionmode = 2,
			},
			[3] = {
				refreshtime = 2500,	--ˢ��ʱ�� ����
				refreshstart = 65000,	--��һ��ˢ��ʱ�� ����
				refreshend = 89000,	--����ʱ�� ����
				--mode 1����
				disappeartime = 4000,	--��ʧʱ�� ����
				--mode 2����
				movespeed = 100,	--�ƶ��ٶ�
				movelength = 200,	--�ƶ�����
				standtime = 200,	--�ƶ���Ŀ�ĵغ�ĵȴ�ʱ�� ����
				--actionmode ����Ĭ��ģʽ1
				--actionmode ����ֱ��������
				--actionmode = 2
				--actionmode �������� ��Ȩ��
				actionmode = {	-- 1 ԭ�ز��� Ȩ��40 ����ʧʱ��Ӱ��   2 �ƶ� Ȩ�� 60  ���ƶ����� �� �ƶ��ٶ�Ӱ��
					{1,20},
					{2,80},
				}
			},
			[4] = {
				refreshtime = 4000,	--ˢ��ʱ�� ����
				refreshstart = 64000,	--��һ��ˢ��ʱ�� ����
				--mode 1����
				disappeartime = 4000,	--��ʧʱ�� ����
				--mode 2����
				movespeed = 100,	--�ƶ��ٶ�
				movelength = {200,350},	--�ƶ�����
				standtime = 200,	--�ƶ���Ŀ�ĵغ�ĵȴ�ʱ�� ����
				--actionmode ����Ĭ��ģʽ1
				--actionmode ����ֱ��������
				--actionmode = 2
				--actionmode �������� ��Ȩ��
				actionmode = 2,
			},
		},
		rule = {	--�ܼ�50��
			unit_score = 1,--��ͨ�������
			unitds_score = 2,--����������
			awards = {--��������ֻѡһ��
				{--�ﵽ�����Ľ���
					shouldscole = 53,	--ָ��
					must = {	--�ظ�
							{108,10},
						
					},
					rand = {	--�����
						num = 4,	--�·�������ѡ1��
						canrepeat = 1,	--���ظ����佱��
						pool = {	--�������
							{105,10},
							{106,10},
							{107,10},
							{108,10},
						},
					},
				},
				{--�ﵽ�����Ľ���
					shouldscole = 54,	--ָ��
					must = {	--�ظ�
							{108,15},
						
					},
					rand = {	--�����
						num = 4,	--�·�������ѡ1��
						canrepeat = 1,	--���ظ����佱��
						pool = {	--�������
							{105,15},
							{106,15},
							{107,15},
							{108,15},
						},
					},
				},
				{--�ﵽ�����Ľ���
					shouldscole = 55,	--ָ��
					must = {	--�ظ�
							{108,20},
						
					},
					rand = {	--�����
						num = 4,	--�·�������ѡ1��
						canrepeat = 1,	--���ظ����佱��
						pool = {	--�������
							{105,20},
							{106,20},
							{107,20},
							{108,20},
						},
					},
				},
			},
		},
	},
}

--���캯��
function GameGopherMgr:ctor()
	self._uid = -1
	self._rid = -1
	
	return self
end
	
--��ʼ������
function GameGopherMgr:Init(uid, rid)
	self._uid = uid
	self._rid = rid

	return self
end

--����Ϸ  �۵����
function GameGopherMgr:EnterGame(diff)
	local ret = 0
	local sCmd = ""

	local tDiffDefine = hVar.GameGopherDiffDefine[diff]
	if type(tDiffDefine) == "table" then
		local costcoin = tDiffDefine.costcoin or 0

		if costcoin > 0 then
			--��ѯ���������
			local nDiShuCoin = 0
			local sQuery = string.format("SELECT `dishu_coin` from `t_user` where `uid` = %d", self._uid)
			local err, nDiShuCoin = xlDb_Query(sQuery)

			if err ~= 0 then
				ret = -2
			elseif nDiShuCoin < costcoin then
				ret = -3
			else
				ret = 1
			end
		else
			ret = 1
		end
	else
		ret = -1
	end

	sCmd = tostring(ret) .. ";" .. tostring(diff) .. ";" .. sCmd
		
	return sCmd
end

local _GetReward = function(diff,score)
	local tReward = {}

	local tDiffDefine = hVar.GameGopherDiffDefine[diff]
	if type(tDiffDefine) == "table" then
		local tRule = tDiffDefine.rule
		if type(tRule) == "table" then
			local tAward = tRule.awards
			local bestScore = 0
			local bestAwardIdx = 0
			for i = 1,#tAward do
				local t = tAward[i]
				if type(t) == "table" then
					local shouldscole = t.shouldscole
					if score >= shouldscole and (shouldscole > bestScore or bestAwardIdx == 0) then
						bestAwardIdx = i
						bestScore = shouldscole
					end
				end
			end
			local tGetAward = tAward[bestAwardIdx]
			if tGetAward then
				local tMust = tGetAward.must
				local tRand = tGetAward.rand
				for i = 1,#tMust do
					local t = tMust[i]
					tReward[#tReward + 1] = {t[1],t[2],t[3],t[4]}
				end
				local tIndex = {}
				local num = tRand.num
				local bCanRepeat = (tRand.canrepeat == 1)
				if bCanRepeat then
					for i = 1,num do
						local r = math.random(1,#tRand.pool)
						local t = tRand.pool[r]
						tReward[#tReward + 1] = {t[1],t[2],t[3],t[4]}
					end
				else
					for i = 1,#tRand.pool do
						tIndex[i] = i
					end
					for i = 1,num do
						local r = math.random(1,#tIndex)
						local t = tRand.pool[tIndex[r]]
						tReward[#tReward + 1] = {t[1],t[2],t[3],t[4]}
						table.remove(tIndex,r)
					end
				end
			end
		end
	end
	return tReward
end

function GameGopherMgr:GetReward(diff,score)
	local ret = 0
	local sCmd = ""

	local tDiffDefine = hVar.GameGopherDiffDefine[diff]
	if type(tDiffDefine) == "table" then
		local costcoin = tDiffDefine.costcoin or 0

		local canGetAward = 1
		if costcoin > 0 then
			--��ѯ���������
			local nDiShuCoin = 0
			local sQuery = string.format("SELECT `dishu_coin` from `t_user` where `uid` = %d", self._uid)
			local err, nDiShuCoin = xlDb_Query(sQuery)

			if err == 0 then
				if nDiShuCoin >= costcoin then
					local sUpdate = string.format("UPDATE `t_user` SET `dishu_coin` = `dishu_coin` + %d WHERE `uid` = %d", -costcoin, self._uid)
					xlDb_Execute(sUpdate)
				else
					canGetAward = 0
					ret = -3
				end
			else
				canGetAward = 0
				ret = -2
			end
		end
		
		if canGetAward == 1 then
			local reward = _GetReward(diff,score)

			--����
			--��ȡ����
			local prizeType = 20008 --��������
			local detail = ""
			detail = detail .. "diff".. tostring(diff) .. ";"
			for r = 1, #reward, 1 do
				local tReward = reward[r]
				detail = detail .. tostring(tReward[1] or 0) .. ":" .. tostring(tReward[2] or 0) .. ":" .. tostring(tReward[3] or 0) .. ":" .. tostring(tReward[4] or 0) .. ";"
			end
			
			--����
			local sInsert = string.format("insert into `prize`(uid,type,mykey,used,create_id) values (%d,%d,'%s',%d,%d)",self._uid,prizeType,detail,0,0)
			xlDb_Execute(sInsert)
			
			--����id
			local err1, pid = xlDb_Query("select last_insert_id()")
			if (err1 == 0) then
				--�洢������Ϣ
				local prizeId = pid --����id
				
				--����������
				local fromIdx = 2
				local prizeContent = hApi.GetRewardInPrize(self._uid, self._rid, prizeId, fromIdx, nil, hVar.tab_string["__TEXT_REWARDTYPE_MAIL"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_MAIL)
				sCmd = sCmd .. prizeContent

				
			end

			ret = 1
		end
	else
		ret = -1
	end

	sCmd = tostring(ret) .. ";" .. sCmd
		
	return sCmd
end

return GameGopherMgr