hVar.tab_roomcfg = {}

local _tab_room = hVar.tab_roomcfg


-----------------------------------------------------------���������-���֡�--------------------------------------------------------
--���ַ�����̨��
_tab_room[1] = 
{
	mapkey = "world/td_pvp_001",
	--mapkey = "td_pvp_001",
	
	kickoutCD = 75, --��ҳ�ʱ�߳������ȴ�ʱ��(��)
	
	groupMapFlag = 0, --�Ƿ�Ϊ���ŵ�ͼ
	
	confgInfo = 
	{
		--����1
		[1] = 
		{
			maxNum = 1,					--������������
			des = hVar.tab_string["__TEXT_SHU"],		--��������
			defaultType = hVar.POS_TYPE.BLANK,				--Ĭ������ 0�� 1��� 2�򵥵��� 3��ͨ���� 4�߼�����
			computerOnly = false,				--�Ƿ�ֻ�������

		},
		--����2
		[2] = 
		{
			--Ĭ��
			maxNum = 1,					--������������
			des = hVar.tab_string["__TEXT_WEI"],		--��������
			defaultType = hVar.POS_TYPE.BLANK,				--Ĭ������ 0�� 1��� 2�򵥵��� 3��ͨ���� 4�߼�����
			computerOnly = false,				--�Ƿ�ֻ�������

		},
	},
	
	--����ʱ���(ÿ�տ����ö��ʱ���)
	openTime = 
	{
		normal = {
			{beginTime = "00:00:00", endTime = "23:59:59",},
		},
		arena = {
			{beginTime = "00:00:00", endTime = "23:59:59",},
			--{beginTime = "12:00:00", endTime = "12:59:59",},
			--{beginTime = "18:30:00", endTime = "20:29:59",},
		},
		
	},
	
	--��Ч������(�������)
	validCondition = 
	{
		--3����
		timeLimit = 180000,					--�����Ϸʱ������λ���룩
	},
	
	reward = {
	},
}


-----------------------------------------------------------��ħ�����⡿--------------------------------------------------------
--ħ������
_tab_room[2] = 
{
	
	mapkey = "world/td_wj_003",	---�ϵĵ�ͼ
	--mapkey = "world/td_wj_003_ex4",	---����
	
	kickoutCD = 180, --��ҳ�ʱ�߳������ȴ�ʱ��(��)
	
	--��ս����
	challengeMaxCount = 1,
	
	groupMapFlag = 1, --�Ƿ�Ϊ���ŵ�ͼ
	
	confgInfo = 
	{
		--����1
		[1] = 
		{
			maxNum = 2,					--������������
			des = hVar.tab_string["__TEXT_SHU"],		--��������
			defaultType = hVar.POS_TYPE.BLANK,		--Ĭ������ 0�� 1��� 2�򵥵��� 3��ͨ���� 4�߼�����
			computerOnly = false,				--������������ҽ���
			
		},
		--����2
		[2] = 
		{
			--Ĭ��
			maxNum = 1,					--������������
			des = hVar.tab_string["__TEXT_WEI"],		--��������
			defaultType = hVar.POS_TYPE.AI_EASY,		--Ĭ������ 0�� 1��� 2�򵥵��� 3��ͨ���� 4�߼�����
			computerOnly = true,				--��������������ҽ���
			
		},
	},
	
	--��ʾ����
	rewardShow = 
	{
		--[[
		--����
		[hVar.POS_TYPE.AI_EASY] = {
			{10,12412}, --��������
			--{1,1000},
			{10,12613,}, --���׽�ţ
			{5,10231,1,}, --��Ὣ��
		},
		]]
		
		
		--�ͻ��˽�����ʾ
		[hVar.POS_TYPE.AI_EASY] = {
			--{10,12406},
			--{1,1000},
			--{11,100},
			{10,12412}, --��������
			{10,12406}, --�׼�֮ʯ
			{5,10231,1,}, --��Ὣ��
		},
		
	},
	
	--ħ�������������
	reward = {
		[hVar.POS_TYPE.AI_EASY] = {
			--�м������س�������rewardNum��ʾ���г鼸��
			rewardNum = 2,				--�������
			
			
			--�ϵĵ���
			{"Boss_001",1,1},			--{����,��С����,������)} --�׼�֮ʯ
			{"juntuan_sunjian",1,1},		--{����,��С����,������)} --��Ὣ��
			{"Equip_juntuanfuben",1,1},		--{����,��С����,������)} --��������
			{"Boss_003",1,2},			--{����,��С����,������)} --������ʯ
			
			
			--[[
			--��������--���׽�ţ
			{"Boss_nianshou",1,1},			--{����,��С����,������)} --���׽�ţ
			{"Boss_001",1,1},			--{����,��С����,������)} --�׼�֮ʯ
			{"juntuan_sunjian",1,1},		--{����,��С����,������)} --��Ὣ��
			{"Equip_juntuanfuben",1,1},		--{����,��С����,������)} --��������
			]]
		},
	},
	
	--ħ�������������,ÿ�ܱص�
	rewardPerWeek = {
		[hVar.POS_TYPE.AI_EASY] = {
			min = 5,
			max = 10,
			
			---�ϵĵ���
			--{5,10207},	--����
			--{5,10206},	--̫ʷ��
			--{5,10214},	--����
			--{5,10216},	--��Τ
			--{5,10215},	--����
			--{5,10220},	--����
			--{5,10221},	--�����
			
			---�µĵ���
			{5,10206},	--̫ʷ��
			{5,10220},	--����
			{5,10224},	--��ͳ
			{5,10221},	--�����
			{5,10227},	--��ڼ
			{5,10226},	--����Ӣ
		},
	},
	
	--����ʱ���(ÿ�տ����ö��ʱ���)
	openTime = 
	{
		normal = {
			--{beginTime = "12:00:00", endTime = "13:59:59",},
			--{beginTime = "20:00:00", endTime = "22:59:59",},
			{beginTime = "05:00:00", endTime = "23:59:59",},
		},
	},
	
	--��Ч������(ħ������)
	validCondition = 
	{
		--10����
		--timeLimit = 600000,					--�����Ϸʱ������λ���룩
		timeLimit = 0,					--�����Ϸʱ������λ���룩
	},
	
	--ʹ�õ��߼����Ƿ���Ϸ�ҽ���
	bUseItemRewardFlag = false,
}



-----------------------------------------------------------��ͭȸ̨��--------------------------------------------------------
--ͭȸ̨
_tab_room[3] = 
{
	mapkey = "world/td_sl_01",
	
	groupMapFlag = 0, --�Ƿ�Ϊ���ŵ�ͼ
	
	confgInfo = 
	{
		--����1
		[1] = 
		{
			maxNum = 1,					--������������
			des = hVar.tab_string["__TEXT_SHU"],		--��������
			defaultType = hVar.POS_TYPE.BLANK,		--Ĭ������ 0�� 1��� 2�򵥵��� 3��ͨ���� 4�߼�����
			computerOnly = false,				--�Ƿ�ֻ�������
			
		},
		--����2
		[2] = 
		{
			--Ĭ��
			maxNum = 1,					--������������
			des = hVar.tab_string["__TEXT_WEI"],		--��������
			defaultType = hVar.POS_TYPE.AI_HARD,		--Ĭ������ 0�� 1��� 2�򵥵��� 3��ͨ���� 4�߼�����
			computerOnly = true,				--�Ƿ�ֻ�������
			
		},
	},
	
	kickoutCD = 86400, --��ҳ�ʱ�߳������ȴ�ʱ��(��)
	
	--��ս����
	challengeMaxCount = 99999,
	
	--��ʾ����
	rewardShow = 
	{
		[hVar.POS_TYPE.AI_EASY] = {
			{1,1000},
			{11,100},
			{23,1},
		},
		[hVar.POS_TYPE.AI_NORMAL] = {
			{1,1000},
			{11,100},
			{23,1},
			{24,1},
		},
		[hVar.POS_TYPE.AI_HARD] = {
			{10,12406},
			{11,100},
			{23,1},
			{24,1},
		},
	},
	
	--ͭȸ̨��������
	reward = {
		[hVar.POS_TYPE.AI_EASY] = {
			--�м������س�������rewardNum��ʾ���г鼸��
			rewardNum = 3,				--�������
			{"Boss_002",1,2},			--{����,��С����,������)} --����
			{"Boss_003",1,2},			--{����,��С����,������)} --������ʯ
			{"treasure_tongquetai_eazy",1,1},	--{����,��С����,������)} --�ر�ͼ��ͭȸ̨�򵥵��䣩
			{"treasure_tongquetai_eazy",1,1},	--{����,��С����,������)} --�ر�ͼ��ͭȸ̨�򵥵��䣩
			{"treasure_tongquetai_eazy",1,1},	--{����,��С����,������)} --�ر�ͼ��ͭȸ̨�򵥵��䣩
		},
		[hVar.POS_TYPE.AI_NORMAL] = {
			--�м������س�������rewardNum��ʾ���г鼸��
			rewardNum = 3,				--�������
			{"Boss_002",1,2},			--{����,��С����,������)} --����
			{"Boss_003",1,2},			--{����,��С����,������)} --������ʯ
			{"treasure_tongquetai_middle",1,1},	--{����,��С����,������)} --�ر�ͼ��ͭȸ̨�еȵ��䣩
			{"treasure_tongquetai_middle",1,1},	--{����,��С����,������)} --�ر�ͼ��ͭȸ̨�еȵ��䣩
			{"treasure_tongquetai_middle",1,1},	--{����,��С����,������)} --�ر�ͼ��ͭȸ̨�еȵ��䣩
		},
		[hVar.POS_TYPE.AI_HARD] = {
			--�м������س�������rewardNum��ʾ���г鼸��
			rewardNum = 3,				--�������
			{"Boss_004",1,1},			--{����,��С����,������)} --�׼�֮ʯ
			{"Boss_003",1,2},			--{����,��С����,������)} --������ʯ
			{"treasure_tongquetai_hard",1,1},	--{����,��С����,������)} --�ر�ͼ��ͭȸ̨���ѵ��䣩
			{"treasure_tongquetai_hard",1,1},	--{����,��С����,������)} --�ر�ͼ��ͭȸ̨���ѵ��䣩
			{"treasure_tongquetai_hard",1,1},	--{����,��С����,������)} --�ر�ͼ��ͭȸ̨���ѵ��䣩
		},
	},
	
	--[[
	--ͭȸ̨����������Ƭ����
	rewardTreasure = {
		[hVar.POS_TYPE.AI_EASY] = {
			--�м������س�������rewardNum��ʾ���г鼸��
			rewardNum = 1,				--�������
			{"treasure_tongquetai_eazy", 1, 1,},			--{����,��С����,������)}
		},
		
		[hVar.POS_TYPE.AI_NORMAL] = {
			--�м������س�������rewardNum��ʾ���г鼸��
			rewardNum = 1,				--�������
			{"treasure_tongquetai_middle", 1, 1,},			--{����,��С����,������)}
		},
		
		[hVar.POS_TYPE.AI_HARD] = {
			--�м������س�������rewardNum��ʾ���г鼸��
			rewardNum = 1,				--�������
			{"treasure_tongquetai_hard", 1, 1,},			--{����,��С����,������)}
		},
	},
	]]
	
	--[[
	--ͭȸ̨��������,ÿ�ܱص�1��
	rewardPerWeek = {
		--���Ѷ�
		[hVar.POS_TYPE.AI_EASY] = {
			min = 5,
			max = 9,
			{5,10214},	--����
			{5,10216},	--��Τ
			{5,10215},	--����
			{5,10207},	--����
			{5,10228},	--������
		},
		
		--�е��Ѷ�
		[hVar.POS_TYPE.AI_NORMAL] = {
			min = 6,
			max = 12,
			{5,10214},	--����
			{5,10216},	--��Τ
			{5,10215},	--����
			{5,10207},	--����
			{5,10228},	--������
		},
		
		--�����Ѷ�
		[hVar.POS_TYPE.AI_HARD] = {
			min = 7,
			max = 15,
			{5,10214},	--����
			{5,10216},	--��Τ
			{5,10215},	--����
			{5,10207},	--����
			{5,10228},	--������
		},
	},
	]]
	
	--��ͼȫ��ս������(ͭȸ̨)
	tacticPool = 
	{
		--��һ��
		[1] = {
			totalValue = 60,
			{value = 10, reward = {3180,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3181,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3182,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3183,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3184,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3185,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
		},
		
		--�ڶ���
		[2] = {
			totalValue = 20,
			{value = 10, reward = {3190,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3191,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
		},
	},
	
	--����ʱ���(ÿ�տ����ö��ʱ���)
	openTime = 
	{
		normal = {
			{beginTime = "00:00:00", endTime = "23:59:59",},
		},
	},
	
	--��Ч������(ͭȸ̨)
	validCondition = 
	{
		--2����
		--timeLimit = 120000,					--�����Ϸʱ������λ���룩
		timeLimit = 0,					--�����Ϸʱ������λ���룩
	},
}




-----------------------------------------------------------���������-ƥ�䡿--------------------------------------------------------
_tab_room[4] = 
{
	mapkey = "world/td_pvp_001",
	--mapkey = "td_pvp_001",
	
	kickoutCD = 75, --��ҳ�ʱ�߳������ȴ�ʱ��(��)
	
	groupMapFlag = 0, --�Ƿ�Ϊ���ŵ�ͼ
	
	confgInfo = 
	{
		--����1
		[1] = 
		{
			maxNum = 1,					--������������
			des = hVar.tab_string["__TEXT_SHU"],		--��������
			defaultType = hVar.POS_TYPE.BLANK,		--Ĭ������ 0�� 1��� 2�򵥵��� 3��ͨ���� 4�߼�����
			computerOnly = false,				--�Ƿ�ֻ�������

		},
		--����2
		[2] = 
		{
			--Ĭ��
			maxNum = 1,					--������������
			des = hVar.tab_string["__TEXT_WEI"],		--��������
			defaultType = hVar.POS_TYPE.BLANK,		--Ĭ������ 0�� 1��� 2�򵥵��� 3��ͨ���� 4�߼�����
			computerOnly = false,				--�Ƿ�ֻ�������
			
		},
	},
	
	--�Ƿ��Զ�ƥ���־
	matchFlag = true,
	
	--[[
	--ƥ������
	matchSetting = {
		
		--��ҷ���
		playerType = {
			
			CLevel5 = hVar.POS_TYPE.AI_PROFESSIONAL,		--����AI
			CLevel4 = hVar.POS_TYPE.AI_EXPERTS,			--�߼�AI
			CLevel3 = hVar.POS_TYPE.AI_HARD,			--�е�AI
			CLevel2 = hVar.POS_TYPE.AI_NORMAL,			--��AI
			CLevel1 = hVar.POS_TYPE.AI_EASY,			--����AI
			
			SKIP = 0,						--����
			
			PLevel1 = {"normalSection","tStar1"},		--�����(��1��)
			PLevel2 = {"normalSection","tStar2"},		--�������
			PLevel3 = {"normalSection","tStar3"},		--��ͨ���
			PLevel4 = {"normalSection","tStar4"},		--�����
			
			PLevel11 = {"extraSection","rStar1"},		--Э��ˢ����ң��ߴ��۸���ң�
			PLevel12 = {"extraSection","rStar2"},		--һ�����
			PLevel13 = {"extraSection","rStar3"},		--��ˮƽ��ҡ�ˢ�����
		},
		
		--���ƥ�䷿��ʤ��������[��������ҿ�)
		normalSection = {
			tStar1 = {min = -9999, max = 1},			--�����(��1��)
			tStar2 = {min = 1, max = 10},				--�������
			tStar3 = {min = 10, max = 50},				--��ͨ���
			tStar4 = {min = 50, max = math.huge},		--�����
		},
		
		--���5��������[��������ҿ�)
		extraSection = {
			rStar1 = {min = -9999, max = 10},			--Э��ˢ����ң��ߴ��۸���ң�
			rStar2 = {min = 10, max = 40},				--һ�����
			rStar3 = {min = 40, max = math.huge},		--��ˮƽ��ҡ�ˢ�����()
		},
		
		--ƥ����ʱ�����Σ������е����ÿ������ʱ���㳢�Է���һ��ƥ�䣩����������ҿ���
		timeSection = {
			--(min��Сֵ max���ֵ idx�����õ���������)
			time1 = {min = 0, max = 10, idx = 1},			--��ʼ����
			time2 = {min = 10, max = 20, idx = 2},			--10��ʱ
			time3 = {min = 20, max = 30, idx = 3},			--20��ʱ
			time4 = {min = 30, max = 40, idx = 4},			--30��ʱ
			time5 = {min = 40, max = 50, idx = 5},			--40��ʱ
			time6 = {min = 50, max = 60, idx = 6},			--50��ʱ
			time7 = {min = 60, max = math.huge, idx = 7},		--60��ʱ
		},
		
		--һ��ƥ�����
		normalRule = {
			--�����(��1��)
			tStar1 = {
				--time1 = {"CLevel1"},					--��ʼ����
				--time2 = {"CLevel1"},					--10��ʱ
				--time3 = {"CLevel1"},					--20��ʱ
				--time4 = {"CLevel1"},					--30��ʱ
				time1 = {"CLevel1"},					--��ʼ����
				time2 = {"CLevel1"},					--10��ʱ
				time3 = {"CLevel1"},					--20��ʱ
				time4 = {"CLevel1"},					--30��ʱ
				time5 = {"CLevel1"},					--40��ʱ
				time6 = {"CLevel1"},					--50��ʱ
				time7 = {"CLevel1"},					--60��ʱ
			},
			
			--�������
			tStar2 = {
				time1 = {"PLevel2"},						--��ʼ����
				time2 = {"PLevel2","PLevel3"},				--10��ʱ
				--time3 = {"PLevel2","PLevel3","CLevel2"},	--20��ʱ
				time3 = {"PLevel2","PLevel3"},				--20��ʱ
				time4 = {"PLevel2","PLevel3"},				--30��ʱ
				time5 = {"PLevel2","PLevel3","PLevel4"},	--40��ʱ
				time6 = {"PLevel2","PLevel3","PLevel4"},	--50��ʱ
				time7 = {"PLevel2","PLevel3","PLevel4"},	--50��ʱ
			},
			
			--��ͨ���
			tStar3 = {
				time1 = {"PLevel3"},						--��ʼ����
				time2 = {"PLevel3","PLevel2","PLevel4"},		--10��ʱ
				--time3 = {"PLevel3","PLevel2","PLevel4","CLevel3"},	--20��ʱ
				time3 = {"PLevel3","PLevel2","PLevel4"},	--20��ʱ
				time4 = {"PLevel3","PLevel2","PLevel4"},	--30��ʱ
				time5 = {"PLevel3","PLevel2","PLevel4"},--40��ʱ
				time6 = {"PLevel3","PLevel2","PLevel4"},--50��ʱ
				time7 = {"PLevel3","PLevel2","PLevel4"},--50��ʱ
			},
			
			--�����
			tStar4 = {
				time1 = {"PLevel4"},					--��ʼ����
				time2 = {"PLevel4","PLevel3",},			--10��ʱ
				--time3 = {"PLevel4","PLevel3","CLevel4"},	--20��ʱ
				time3 = {"PLevel4","PLevel3"},			--20��ʱ
				time4 = {"PLevel4","PLevel3"},			--30��ʱ
				time5 = {"PLevel4","PLevel3","PLevel2"},	--40��ʱ
				time6 = {"PLevel4","PLevel3","PLevel2"},	--50��ʱ
				time7 = {"PLevel4","PLevel3","PLevel2"},	--50��ʱ
			},
		},
		
		--�������
		extraRule = {
			--���5�� Э��ˢ����ң��ߴ��۸���ң�
			rStar1 = {
				time1 = {"PLevel11"},					--��ʼ����
				--time2 = {"PLevel11","CLevel2"},		--10��ʱ
				time2 = {"PLevel11"},					--10��ʱ
				time3 = {"PLevel11"},					--20��ʱ
				time4 = {"PLevel11"},					--30��ʱ
				time5 = {"PLevel11"},					--40��ʱ
				time6 = {"PLevel11"},					--50��ʱ
				time7 = {"PLevel11"},					--60��ʱ
			},
			
			--���5�� һ�����
			rStar2 = {
				time1 = {"PLevel12"},					--��ʼ����
				time2 = {"PLevel12"},					--10��ʱ
				time3 = {"PLevel12"},					--20��ʱ
				time4 = {"PLevel12"},					--30��ʱ
				time5 = {"PLevel12"},					--40��ʱ
				time6 = {"PLevel12"},					--50��ʱ
				time7 = {"PLevel12"},					--60��ʱ
			},
			
			--���5�� ��ˮƽ��ҡ�ˢ�����
			rStar3 = {
				time1 = {"PLevel4"},					--��ʼ����
				--time2 = {"PLevel4","CLevel5"},		--10��ʱ
				time2 = {"PLevel4"},					--10��ʱ
				time3 = {"PLevel4"},					--20��ʱ
				time4 = {"PLevel4"},					--30��ʱ
				time5 = {"PLevel4"},					--40��ʱ
				time6 = {"PLevel4"},					--50��ʱ
				time7 = {"PLevel4"},					--60��ʱ
			},
			
		},
	},
	]]
	
	--ƥ�����ã��£�
	matchSetting = {
		
		--��ҷ���
		playerType = {
			
			
			CLevelAI_01 = hVar.POS_TYPE.AI_EASY,			--����AI
			CLevelAI_02 = hVar.POS_TYPE.AI_NORMAL,			--��AI
			CLevelAI_03 = hVar.POS_TYPE.AI_HARD,			--�е�AI
			CLevelAI_04 = hVar.POS_TYPE.AI_EXPERTS,			--�߼�AI
			CLevelAI_05 = hVar.POS_TYPE.AI_PROFESSIONAL,		--����AI
			
			SKIP = 0,						--����
			
			PLevel_01 = {"normalSection", "tStar1"},		--��λ1
			PLevel_02 = {"normalSection", "tStar2"},		--��λ2
			PLevel_03 = {"normalSection", "tStar3"},		--��λ3
			PLevel_04 = {"normalSection", "tStar4"},		--��λ4
			PLevel_05 = {"normalSection", "tStar5"},		--��λ5
			PLevel_06 = {"normalSection", "tStar6"},		--��λ6
			PLevel_07 = {"normalSection", "tStar7"},		--��λ7
			PLevel_08 = {"normalSection", "tStar8"},		--��λ8
			PLevel_09 = {"normalSection", "tStar9"},		--��λ9
			PLevel_10 = {"normalSection", "tStar10"},		--��λ10
			PLevel_11 = {"normalSection", "tStar11"},		--��λ11
			PLevel_12 = {"normalSection", "tStar12"},		--��λ12
			PLevel_13 = {"normalSection", "tStar13"},		--��λ13
			PLevel_14 = {"normalSection", "tStar14"},		--��λ14
			PLevel_15 = {"normalSection", "tStar15"},		--��λ15
			PLevel_16 = {"normalSection", "tStar16"},		--��λ16
			
			--PLevel11 = {"extraSection","rStar1"},		--Э��ˢ����ң��ߴ��۸���ң�
			--PLevel12 = {"extraSection","rStar2"},		--һ�����
			--PLevel13 = {"extraSection","rStar3"},		--��ˮƽ��ҡ�ˢ�����
		},
		
		--���ƥ�䷿��ʤ�������� [��������ҿ�)
		normalSection = {
			tStar1 = {min = 0, max = 2,},				--��λ1
			tStar2 = {min = 2, max = 3,},				--��λ2
			tStar3 = {min = 3, max = 4},				--��λ3
			tStar4 = {min = 4, max = 5},				--��λ4
			tStar5 = {min = 5, max = 6},				--��λ5
			tStar6 = {min = 6, max = 7},				--��λ6
			tStar7 = {min = 7, max = 8},				--��λ7
			tStar8 = {min = 8, max = 9},				--��λ8
			tStar9 = {min = 9, max = 10},				--��λ9
			tStar10 = {min = 10, max = 11},				--��λ10
			tStar11 = {min = 11, max = 12},				--��λ11
			tStar12 = {min = 12, max = 13},				--��λ12
			tStar13 = {min = 13, max = 14},				--��λ13
			tStar14 = {min = 14, max = 15},				--��λ14
			tStar15 = {min = 15, max = 16},				--��λ15
			tStar16 = {min = 16, max = math.huge},			--��λ16
		},
		
		--���5��������[��������ҿ�)
		extraSection = {
			rStar1 = {min = -9999, max = math.huge},		--��
		},
		
		--ƥ����ʱ�����Σ������е����ÿ������ʱ���㳢�Է���һ��ƥ�䣩 [��������ҿ���
		timeSection = {
			--(min��Сֵ max���ֵ idx�����õ���������)
			time1 = {min = 1, max = 5, idx = 1},			--��ʼ����
			time2 = {min = 5, max = 10, idx = 2},			--5��ʱ
			time3 = {min = 10, max = 15, idx = 3},			--10��ʱ
			time4 = {min = 15, max = 20, idx = 4},			--15��ʱ
			time5 = {min = 20, max = 25, idx = 5},			--20��ʱ
			time6 = {min = 25, max = 30, idx = 6},			--25��ʱ
			time7 = {min = 30, max = 35, idx = 7},			--30��ʱ
			time8 = {min = 35, max = 40, idx = 8},			--35��ʱ
			time9 = {min = 40, max = 45, idx = 9},			--40��ʱ
			time10 = {min = 45, max = 50, idx = 10},		--45��ʱ
			time11 = {min = 50, max = 55, idx = 11},		--50��ʱ
			time12 = {min = 55, max = 60, idx = 12},		--55��ʱ
			time13 = {min = 60, max = math.huge, idx = 13},		--60��ʱ
		},
		
		--һ��ƥ�����
		normalRule = {
			--��λ1 ����С��III ƥ������ܱ���1-4����15���ڣ�
			tStar1 = {
				time1 = {"PLevel_01","PLevel_02",},				--��ʼ���루�ܱ���-2��
				time2 = {"PLevel_01","PLevel_02","PLevel_03",},			--5��ʱ���ܱ���-1��
				time3 = {"PLevel_01","PLevel_02","PLevel_03","PLevel_04",},	--10��ʱ(end!)���ܱ�����
				time4 = {"CLevelAI_01",},					--15��ʱ
				time5 = {"CLevelAI_01",},					--20��ʱ
				time6 = {"CLevelAI_01",},					--25��ʱ
				time7 = {"CLevelAI_01",},					--30��ʱ
				time8 = {"CLevelAI_01",},					--35��ʱ
				time9 = {"CLevelAI_01",},					--40��ʱ
				time10 = {"CLevelAI_01",},					--45��ʱ
				time11 = {"CLevelAI_01",},					--50��ʱ
				time12 = {"CLevelAI_01",},					--55��ʱ
				time13 = {"CLevelAI_01",},					--60��ʱ
			},
			
			--��λ2 ����С��II ƥ�����20���ڣ�
			tStar2 = {
				time1 = {"PLevel_02","PLevel_01","PLevel_03","PLevel_04","PLevel_05",},		--��ʼ����
				time2 = {"PLevel_02","PLevel_01","PLevel_03","PLevel_04","PLevel_05","PLevel_06",},		--5��ʱ
				time3 = {"PLevel_02","PLevel_01","PLevel_03","PLevel_04","PLevel_05","PLevel_06","PLevel_07",},		--10��ʱ
				time4 = {"PLevel_02","PLevel_01","PLevel_03","PLevel_04","PLevel_05","PLevel_06","PLevel_07","PLevel_08",},		--15��ʱ(end!)
				time5 = {"CLevelAI_01",},					--20��ʱ
				time6 = {"CLevelAI_01",},					--25��ʱ
				time7 = {"CLevelAI_01",},					--30��ʱ
				time8 = {"CLevelAI_01",},					--35��ʱ
				time9 = {"CLevelAI_01",},					--40��ʱ
				time10 = {"CLevelAI_01",},					--45��ʱ
				time11 = {"CLevelAI_01",},					--50��ʱ
				time12 = {"CLevelAI_01",},					--55��ʱ
				time13 = {"CLevelAI_01",},					--60��ʱ
			},
			
			--��λ3 ����С��I ƥ�����20���ڣ�
			tStar3 = {
				time1 = {"PLevel_03","PLevel_01","PLevel_02","PLevel_04","PLevel_05","PLevel_06",},		--��ʼ����
				time2 = {"PLevel_03","PLevel_01","PLevel_02","PLevel_04","PLevel_05","PLevel_06","PLevel_07",},		--5��ʱ
				time3 = {"PLevel_03","PLevel_01","PLevel_02","PLevel_04","PLevel_05","PLevel_06","PLevel_07","PLevel_08",},		--10��ʱ
				time4 = {"PLevel_03","PLevel_01","PLevel_02","PLevel_04","PLevel_05","PLevel_06","PLevel_07","PLevel_08","PLevel_09",},		--15��ʱ(end!)
				time5 = {"CLevelAI_01",},					--20��ʱ
				time6 = {"CLevelAI_01",},					--25��ʱ
				time7 = {"CLevelAI_01",},					--30��ʱ
				time8 = {"CLevelAI_01",},					--35��ʱ
				time9 = {"CLevelAI_01",},					--40��ʱ
				time10 = {"CLevelAI_01",},					--45��ʱ
				time11 = {"CLevelAI_01",},					--50��ʱ
				time12 = {"CLevelAI_01",},					--55��ʱ
				time13 = {"CLevelAI_01",},					--60��ʱ
			},
			
			--��λ4 һ�ﵱ��III ƥ�����20���ڣ�
			tStar4 = {
				time1 = {"PLevel_04","PLevel_01","PLevel_02","PLevel_03","PLevel_05","PLevel_06","PLevel_07",},		--��ʼ����
				time2 = {"PLevel_04","PLevel_01","PLevel_02","PLevel_03","PLevel_05","PLevel_06","PLevel_07","PLevel_08",},		--5��ʱ
				time3 = {"PLevel_04","PLevel_01","PLevel_02","PLevel_03","PLevel_05","PLevel_06","PLevel_07","PLevel_08","PLevel_09",},		--10��ʱ
				time4 = {"PLevel_04","PLevel_01","PLevel_02","PLevel_03","PLevel_05","PLevel_06","PLevel_07","PLevel_08","PLevel_09","PLevel_10",},		--15��ʱ(end!)
				time5 = {"CLevelAI_02",},					--20��ʱ
				time6 = {"CLevelAI_02",},					--25��ʱ
				time7 = {"CLevelAI_02",},					--30��ʱ
				time8 = {"CLevelAI_02",},					--35��ʱ
				time9 = {"CLevelAI_02",},					--40��ʱ
				time10 = {"CLevelAI_02",},					--45��ʱ
				time11 = {"CLevelAI_02",},					--50��ʱ
				time12 = {"CLevelAI_02",},					--55��ʱ
				time13 = {"CLevelAI_02",},					--60��ʱ
			},
			
			--��λ5 һ�ﵱ��II ƥ�����20���ڣ�
			tStar5 = {
				time1 = {"PLevel_05","PLevel_02","PLevel_03","PLevel_04","PLevel_06","PLevel_07","PLevel_08",},		--��ʼ����
				time2 = {"PLevel_05","PLevel_02","PLevel_03","PLevel_04","PLevel_06","PLevel_07","PLevel_08","PLevel_09",},		--5��ʱ
				time3 = {"PLevel_05","PLevel_02","PLevel_03","PLevel_04","PLevel_06","PLevel_07","PLevel_08","PLevel_09","PLevel_10",},		--10��ʱ
				time4 = {"PLevel_05","PLevel_02","PLevel_03","PLevel_04","PLevel_06","PLevel_07","PLevel_08","PLevel_09","PLevel_10","PLevel_11",},		--15��ʱ(end!)
				time5 = {"CLevelAI_02",},					--20��ʱ
				time6 = {"CLevelAI_02",},					--25��ʱ
				time7 = {"CLevelAI_02",},					--30��ʱ
				time8 = {"CLevelAI_02",},					--35��ʱ
				time9 = {"CLevelAI_02",},					--40��ʱ
				time10 = {"CLevelAI_02",},					--45��ʱ
				time11 = {"CLevelAI_02",},					--50��ʱ
				time12 = {"CLevelAI_02",},					--55��ʱ
				time13 = {"CLevelAI_02",},					--60��ʱ
			},
			
			--��λ6 һ�ﵱ��I ƥ�����20���ڣ�
			tStar6 = {
				time1 = {"PLevel_06","PLevel_03","PLevel_04","PLevel_05","PLevel_07","PLevel_08","PLevel_09",},		--��ʼ����
				time2 = {"PLevel_06","PLevel_02","PLevel_03","PLevel_04","PLevel_05","PLevel_07","PLevel_08","PLevel_09","PLevel_10",},		--5��ʱ
				time3 = {"PLevel_06","PLevel_02","PLevel_03","PLevel_04","PLevel_05","PLevel_07","PLevel_08","PLevel_09","PLevel_10","PLevel_11",},		--10��ʱ
				time4 = {"PLevel_06","PLevel_02","PLevel_03","PLevel_04","PLevel_05","PLevel_07","PLevel_08","PLevel_09","PLevel_10","PLevel_11","PLevel_12",},		--15��ʱ(end!)
				time5 = {"CLevelAI_02",},					--20��ʱ
				time6 = {"CLevelAI_02",},					--25��ʱ
				time7 = {"CLevelAI_02",},					--30��ʱ
				time8 = {"CLevelAI_02",},					--35��ʱ
				time9 = {"CLevelAI_02",},					--40��ʱ
				time10 = {"CLevelAI_02",},					--45��ʱ
				time11 = {"CLevelAI_02",},					--50��ʱ
				time12 = {"CLevelAI_02",},					--55��ʱ
				time13 = {"CLevelAI_02",},					--60��ʱ
			},
			
			--��λ7 �¹�����III ƥ�����25���ڣ�
			tStar7 = {
				time1 = {"PLevel_07","PLevel_04","PLevel_05","PLevel_06","PLevel_08","PLevel_09","PLevel_10",},		--��ʼ����
				time2 = {"PLevel_07","PLevel_03","PLevel_04","PLevel_05","PLevel_06","PLevel_08","PLevel_09","PLevel_10","PLevel_11",},		--5��ʱ
				time3 = {"PLevel_07","PLevel_02","PLevel_03","PLevel_04","PLevel_05","PLevel_06","PLevel_08","PLevel_09","PLevel_10","PLevel_11","PLevel_12",},		--10��ʱ
				time4 = {"PLevel_07","PLevel_02","PLevel_03","PLevel_04","PLevel_05","PLevel_06","PLevel_08","PLevel_09","PLevel_10","PLevel_11","PLevel_12","PLevel_13",},		--15��ʱ
				time5 = {"PLevel_07","PLevel_02","PLevel_03","PLevel_04","PLevel_05","PLevel_06","PLevel_08","PLevel_09","PLevel_10","PLevel_11","PLevel_12","PLevel_13","PLevel_14",},		--20��ʱ(end!)
				time6 = {"CLevelAI_03",},					--25��ʱ
				time7 = {"CLevelAI_03",},					--30��ʱ
				time8 = {"CLevelAI_03",},					--35��ʱ
				time9 = {"CLevelAI_03",},					--40��ʱ
				time10 = {"CLevelAI_03",},					--45��ʱ
				time11 = {"CLevelAI_03",},					--50��ʱ
				time12 = {"CLevelAI_03",},					--55��ʱ
				time13 = {"CLevelAI_03",},					--60��ʱ
			},
			
			--��λ8 �¹�����II ƥ�����25���ڣ�
			tStar8 = {
				time1 = {"PLevel_08","PLevel_05","PLevel_06","PLevel_07","PLevel_09","PLevel_10","PLevel_11",},		--��ʼ����
				time2 = {"PLevel_08","PLevel_04","PLevel_05","PLevel_06","PLevel_07","PLevel_09","PLevel_10","PLevel_11","PLevel_12",},		--5��ʱ
				time3 = {"PLevel_08","PLevel_03","PLevel_04","PLevel_05","PLevel_06","PLevel_07","PLevel_09","PLevel_10","PLevel_11","PLevel_12","PLevel_13",},		--10��ʱ
				time4 = {"PLevel_08","PLevel_02","PLevel_03","PLevel_04","PLevel_05","PLevel_06","PLevel_07","PLevel_09","PLevel_10","PLevel_11","PLevel_12","PLevel_13","PLevel_14",},		--15��ʱ
				time5 = {"PLevel_08","PLevel_02","PLevel_03","PLevel_04","PLevel_05","PLevel_06","PLevel_07","PLevel_09","PLevel_10","PLevel_11","PLevel_12","PLevel_13","PLevel_14","PLevel_15",},		--20��ʱ(end!)
				time6 = {"CLevelAI_03",},					--25��ʱ
				time7 = {"CLevelAI_03",},					--30��ʱ
				time8 = {"CLevelAI_03",},					--35��ʱ
				time9 = {"CLevelAI_03",},					--40��ʱ
				time10 = {"CLevelAI_03",},					--45��ʱ
				time11 = {"CLevelAI_03",},					--50��ʱ
				time12 = {"CLevelAI_03",},					--55��ʱ
				time13 = {"CLevelAI_03",},					--60��ʱ
			},
			
			--��λ9 �¹�����I ƥ�����25���ڣ�
			tStar9 = {
				time1 = {"PLevel_09","PLevel_06","PLevel_07","PLevel_08","PLevel_10","PLevel_11","PLevel_12",},		--��ʼ����
				time2 = {"PLevel_09","PLevel_05","PLevel_06","PLevel_07","PLevel_08","PLevel_10","PLevel_11","PLevel_12","PLevel_13",},		--5��ʱ
				time3 = {"PLevel_09","PLevel_04","PLevel_05","PLevel_06","PLevel_07","PLevel_08","PLevel_10","PLevel_11","PLevel_12","PLevel_13","PLevel_14",},		--10��ʱ
				time4 = {"PLevel_09","PLevel_03","PLevel_04","PLevel_05","PLevel_06","PLevel_07","PLevel_08","PLevel_10","PLevel_11","PLevel_12","PLevel_13","PLevel_14","PLevel_15",},		--15��ʱ
				time5 = {"PLevel_09","PLevel_02","PLevel_03","PLevel_04","PLevel_05","PLevel_06","PLevel_07","PLevel_08","PLevel_10","PLevel_11","PLevel_12","PLevel_13","PLevel_14","PLevel_15","PLevel_16",},		--20��ʱ(end!)
				time6 = {"CLevelAI_03",},					--25��ʱ
				time7 = {"CLevelAI_03",},					--30��ʱ
				time8 = {"CLevelAI_03",},					--35��ʱ
				time9 = {"CLevelAI_03",},					--40��ʱ
				time10 = {"CLevelAI_03",},					--45��ʱ
				time11 = {"CLevelAI_03",},					--50��ʱ
				time12 = {"CLevelAI_03",},					--55��ʱ
				time13 = {"CLevelAI_03",},					--60��ʱ
			},
			
			--��λ10 ����˷�III ƥ�����25���ڣ�
			tStar10 = {
				time1 = {"PLevel_10","PLevel_07","PLevel_08","PLevel_09","PLevel_11","PLevel_12","PLevel_13",},		--��ʼ����
				time2 = {"PLevel_10","PLevel_06","PLevel_07","PLevel_08","PLevel_09","PLevel_11","PLevel_12","PLevel_13","PLevel_14",},		--5��ʱ
				time3 = {"PLevel_10","PLevel_05","PLevel_06","PLevel_07","PLevel_08","PLevel_09","PLevel_11","PLevel_12","PLevel_13","PLevel_14","PLevel_15",},		--10��ʱ
				time4 = {"PLevel_10","PLevel_04","PLevel_05","PLevel_06","PLevel_07","PLevel_08","PLevel_09","PLevel_11","PLevel_12","PLevel_13","PLevel_14","PLevel_15","PLevel_16",},		--15��ʱ
				time5 = {"PLevel_10","PLevel_03","PLevel_04","PLevel_05","PLevel_06","PLevel_07","PLevel_08","PLevel_09","PLevel_11","PLevel_12","PLevel_13","PLevel_14","PLevel_15","PLevel_16",},		--20��ʱ(end!)
				time6 = {"CLevelAI_04",},					--25��ʱ
				time7 = {"CLevelAI_04",},					--30��ʱ
				time8 = {"CLevelAI_04",},					--35��ʱ
				time9 = {"CLevelAI_04",},					--40��ʱ
				time10 = {"CLevelAI_04",},					--45��ʱ
				time11 = {"CLevelAI_04",},					--50��ʱ
				time12 = {"CLevelAI_04",},					--55��ʱ
				time13 = {"CLevelAI_04",},					--60��ʱ
			},
			
			--��λ11 ����˷�II ƥ�����25���ڣ�
			tStar11 = {
				time1 = {"PLevel_11","PLevel_08","PLevel_09","PLevel_10","PLevel_12","PLevel_13","PLevel_14",},		--��ʼ����
				time2 = {"PLevel_11","PLevel_07","PLevel_08","PLevel_09","PLevel_10","PLevel_12","PLevel_13","PLevel_14","PLevel_15",},		--5��ʱ
				time3 = {"PLevel_11","PLevel_06","PLevel_07","PLevel_08","PLevel_09","PLevel_10","PLevel_12","PLevel_13","PLevel_14","PLevel_15","PLevel_16",},		--10��ʱ
				time4 = {"PLevel_11","PLevel_05","PLevel_06","PLevel_07","PLevel_08","PLevel_09","PLevel_10","PLevel_12","PLevel_13","PLevel_14","PLevel_15","PLevel_16",},		--15��ʱ
				time5 = {"PLevel_11","PLevel_04","PLevel_05","PLevel_06","PLevel_07","PLevel_08","PLevel_09","PLevel_10","PLevel_12","PLevel_13","PLevel_14","PLevel_15","PLevel_16",},		--20��ʱ(end!)
				time6 = {"CLevelAI_04",},					--25��ʱ
				time7 = {"CLevelAI_04",},					--30��ʱ
				time8 = {"CLevelAI_04",},					--35��ʱ
				time9 = {"CLevelAI_04",},					--40��ʱ
				time10 = {"CLevelAI_04",},					--45��ʱ
				time11 = {"CLevelAI_04",},					--50��ʱ
				time12 = {"CLevelAI_04",},					--55��ʱ
				time13 = {"CLevelAI_04",},					--60��ʱ
			},
			
			--��λ12 ����˷�I ƥ�����30���ڣ�
			tStar12 = {
				time1 = {"PLevel_12","PLevel_09","PLevel_10","PLevel_11","PLevel_13","PLevel_14","PLevel_15",},		--��ʼ����
				time2 = {"PLevel_12","PLevel_08","PLevel_09","PLevel_10","PLevel_11","PLevel_13","PLevel_14","PLevel_15","PLevel_16",},		--5��ʱ
				time3 = {"PLevel_12","PLevel_07","PLevel_08","PLevel_09","PLevel_10","PLevel_11","PLevel_13","PLevel_14","PLevel_15","PLevel_16",},		--10��ʱ
				time4 = {"PLevel_12","PLevel_06","PLevel_07","PLevel_08","PLevel_09","PLevel_10","PLevel_11","PLevel_13","PLevel_14","PLevel_15","PLevel_16",},		--15��ʱ
				time5 = {"PLevel_12","PLevel_05","PLevel_06","PLevel_07","PLevel_08","PLevel_09","PLevel_10","PLevel_11","PLevel_13","PLevel_14","PLevel_15","PLevel_16",},		--20��ʱ
				time6 = {"PLevel_12","PLevel_04","PLevel_05","PLevel_06","PLevel_07","PLevel_08","PLevel_09","PLevel_10","PLevel_11","PLevel_13","PLevel_14","PLevel_15","PLevel_16",},		--25��ʱ(end!)
				time7 = {"CLevelAI_04",},					--30��ʱ
				time8 = {"CLevelAI_04",},					--35��ʱ
				time9 = {"CLevelAI_04",},					--40��ʱ
				time10 = {"CLevelAI_04",},					--45��ʱ
				time11 = {"CLevelAI_04",},					--50��ʱ
				time12 = {"CLevelAI_04",},					--55��ʱ
				time13 = {"CLevelAI_04",},					--60��ʱ
			},
			
			--��λ13 ��ɨǧ��III ƥ�����30���ڣ�
			tStar13 = {
				time1 = {"PLevel_13","PLevel_10","PLevel_11","PLevel_12","PLevel_14","PLevel_15","PLevel_16",},		--��ʼ����
				time2 = {"PLevel_13","PLevel_09","PLevel_10","PLevel_11","PLevel_12","PLevel_14","PLevel_15","PLevel_16",},		--5��ʱ
				time3 = {"PLevel_13","PLevel_08","PLevel_09","PLevel_10","PLevel_11","PLevel_12","PLevel_14","PLevel_15","PLevel_16",},		--10��ʱ
				time4 = {"PLevel_13","PLevel_07","PLevel_08","PLevel_09","PLevel_10","PLevel_11","PLevel_12","PLevel_14","PLevel_15","PLevel_16",},		--15��ʱ
				time5 = {"PLevel_13","PLevel_06","PLevel_07","PLevel_08","PLevel_09","PLevel_10","PLevel_11","PLevel_12","PLevel_14","PLevel_15","PLevel_16",},		--20��ʱ
				time6 = {"PLevel_13","PLevel_05","PLevel_06","PLevel_07","PLevel_08","PLevel_09","PLevel_10","PLevel_11","PLevel_12","PLevel_14","PLevel_15","PLevel_16",},		--25��ʱ(end!)
				time7 = {"CLevelAI_04",},					--30��ʱ
				time8 = {"CLevelAI_04",},					--35��ʱ
				time9 = {"CLevelAI_04",},					--40��ʱ
				time10 = {"CLevelAI_04",},					--45��ʱ
				time11 = {"CLevelAI_04",},					--50��ʱ
				time12 = {"CLevelAI_04",},					--55��ʱ
				time13 = {"CLevelAI_04",},					--60��ʱ
			},
			
			--��λ14 ��ɨǧ��II ƥ�����30���ڣ�
			tStar14 = {
				time1 = {"PLevel_14","PLevel_11","PLevel_12","PLevel_13","PLevel_15","PLevel_16",},		--��ʼ����
				time2 = {"PLevel_14","PLevel_10","PLevel_11","PLevel_12","PLevel_13","PLevel_15","PLevel_16",},		--5��ʱ
				time3 = {"PLevel_14","PLevel_09","PLevel_10","PLevel_11","PLevel_12","PLevel_13","PLevel_15","PLevel_16",},		--10��ʱ
				time4 = {"PLevel_14","PLevel_08","PLevel_09","PLevel_10","PLevel_11","PLevel_12","PLevel_13","PLevel_15","PLevel_16",},		--15��ʱ
				time5 = {"PLevel_14","PLevel_07","PLevel_08","PLevel_09","PLevel_10","PLevel_11","PLevel_12","PLevel_13","PLevel_15","PLevel_16",},		--20��ʱ
				time6 = {"PLevel_14","PLevel_06","PLevel_07","PLevel_08","PLevel_09","PLevel_10","PLevel_11","PLevel_12","PLevel_13","PLevel_15","PLevel_16",},		--25��ʱ(end!)
				time7 = {"CLevelAI_05",},					--30��ʱ
				time8 = {"CLevelAI_05",},					--35��ʱ
				time9 = {"CLevelAI_05",},					--40��ʱ
				time10 = {"CLevelAI_05",},					--45��ʱ
				time11 = {"CLevelAI_05",},					--50��ʱ
				time12 = {"CLevelAI_05",},					--55��ʱ
				time13 = {"CLevelAI_05",},					--60��ʱ
			},
			
			--��λ15 ��ɨǧ��I ƥ�����30���ڣ�
			tStar15 = {
				time1 = {"PLevel_15","PLevel_12","PLevel_13","PLevel_14","PLevel_16",},	--��ʼ����
				time2 = {"PLevel_15","PLevel_11","PLevel_12","PLevel_13","PLevel_14","PLevel_16",},		--5��ʱ
				time3 = {"PLevel_15","PLevel_10","PLevel_11","PLevel_12","PLevel_13","PLevel_14","PLevel_16",},		--10��ʱ
				time4 = {"PLevel_15","PLevel_09","PLevel_10","PLevel_11","PLevel_12","PLevel_13","PLevel_14","PLevel_16",},		--15��ʱ
				time5 = {"PLevel_15","PLevel_08","PLevel_09","PLevel_10","PLevel_11","PLevel_12","PLevel_13","PLevel_14","PLevel_16",},		--20��ʱ
				time6 = {"PLevel_15","PLevel_07","PLevel_08","PLevel_09","PLevel_10","PLevel_11","PLevel_12","PLevel_13","PLevel_14","PLevel_16",},		--25��ʱ(end!)
				time7 = {"CLevelAI_05",},					--30��ʱ
				time8 = {"CLevelAI_05",},					--35��ʱ
				time9 = {"CLevelAI_05",},					--40��ʱ
				time10 = {"CLevelAI_05",},					--45��ʱ
				time11 = {"CLevelAI_05",},					--50��ʱ
				time12 = {"CLevelAI_05",},					--55��ʱ
				time13 = {"CLevelAI_05",},					--60��ʱ
			},
			
			--��λ16 ������˫ ƥ�����30���ڣ�
			tStar16 = {
				time1 = {"PLevel_16","PLevel_13","PLevel_14","PLevel_15",},	--��ʼ����
				time2 = {"PLevel_16","PLevel_12","PLevel_13","PLevel_14","PLevel_15",},		--5��ʱ
				time3 = {"PLevel_16","PLevel_11","PLevel_12","PLevel_13","PLevel_14","PLevel_15",},		--10��ʱ
				time4 = {"PLevel_16","PLevel_10","PLevel_11","PLevel_12","PLevel_13","PLevel_14","PLevel_15",},		--15��ʱ
				time5 = {"PLevel_16","PLevel_09","PLevel_10","PLevel_11","PLevel_12","PLevel_13","PLevel_14","PLevel_15",},		--20��ʱ
				time6 = {"PLevel_16","PLevel_07","PLevel_08","PLevel_09","PLevel_10","PLevel_11","PLevel_12","PLevel_13","PLevel_14","PLevel_15",},		--25��ʱ(end!)������+1��
				time7 = {"CLevelAI_05",},					--30��ʱ
				time8 = {"CLevelAI_05",},					--35��ʱ
				time9 = {"CLevelAI_05",},					--40��ʱ
				time10 = {"CLevelAI_05",},					--45��ʱ
				time11 = {"CLevelAI_05",},					--50��ʱ
				time12 = {"CLevelAI_05",},					--55��ʱ
				time13 = {"CLevelAI_05",},					--60��ʱ
			},
		},
		
		--�������
		extraRule = {
			--���5�� Э��ˢ����ң��ߴ��۸���ң�
			--��
		},
	},
	
	--����ʱ���(ÿ�տ����ö��ʱ���)
	openTime = 
	{
		normal = {
			{beginTime = "12:00:00", endTime = "12:59:59",},
			{beginTime = "19:00:00", endTime = "19:59:59",},
		},
	},
	
	--��Ч������(�������-ƥ��)
	validCondition = 
	{
		--3����
		timeLimit = 180000,					--�����Ϸʱ������λ���룩
	},
	reward = {
	},
}


-----------------------------------------------------------������-����--------------------------------------------------------
--geyachao: �¼ӷ���������� ����
--����-��
_tab_room[5] = 
{
	mapkey = "world/td_jt_003",
	
	groupMapFlag = 1, --�Ƿ�Ϊ���ŵ�ͼ
	fps = 60, --ָ��֡��fps
	
	confgInfo = 
	{
		--����1
		[1] = 
		{
			maxNum = 1,					--������������
			des = hVar.tab_string["__TEXT_SHU"],		--��������
			defaultType = hVar.POS_TYPE.BLANK,		--Ĭ������ 0�� 1��� 2�򵥵��� 3��ͨ���� 4�߼�����
			computerOnly = false,				--�Ƿ�ֻ�������
			
		},
		--����2
		[2] = 
		{
			--Ĭ��
			maxNum = 1,					--������������
			des = hVar.tab_string["__TEXT_WEI"],		--��������
			defaultType = hVar.POS_TYPE.AI_HARD,		--Ĭ������ 0�� 1��� 2�򵥵��� 3��ͨ���� 4�߼�����
			computerOnly = true,				--�Ƿ�ֻ�������
			
		},
	},
	
	kickoutCD = 86400, --��ҳ�ʱ�߳������ȴ�ʱ��(��)
	
	--��ս����
	challengeMaxCount = 1,
	
	--��ʾ����
	rewardShow = 
	{
		[hVar.POS_TYPE.AI_EASY] = {
			{16,1},
			{1,1},
			{20,5},
		},
		[hVar.POS_TYPE.AI_NORMAL] = {
			{16,2},
			{1,1},
			{20,5},
		},
		[hVar.POS_TYPE.AI_HARD] = {
			{16,3},
			{1,1},
			{20,5},
			{11,100},
		},
	},
	
	--����������
	reward = {
		[hVar.POS_TYPE.AI_EASY] = {
			--�м������س�������rewardNum��ʾ���г鼸��
			rewardNum = 3,				--�������
			{"tie_001",1,1},			--{����,��С����,������)}
			{"tie_001",1,1},			--{����,��С����,������)}
			{"Boss_002",1,1},			--{����,��С����,������)}
			{"Boss_002",1,1},			--{����,��С����,������)}
			{"Boss_002",1,1},			--{����,��С����,������)}
		},
		[hVar.POS_TYPE.AI_NORMAL] = {
			--�м������س�������rewardNum��ʾ���г鼸��
			rewardNum = 3,				--�������
			{"tie_001",1,1},			--{����,��С����,������)}
			{"tie_001",1,1},			--{����,��С����,������)}
			{"tie_001",1,1},			--{����,��С����,������)}
			{"Boss_002",1,1},			--{����,��С����,������)}
			{"Boss_002",1,1},			--{����,��С����,������)}
		},
		[hVar.POS_TYPE.AI_HARD] = {
			--�м������س�������rewardNum��ʾ���г鼸��
			rewardNum = 3,				--�������
			{"tie_001",1,1},			--{����,��С����,������)}
			{"tie_001",1,1},			--{����,��С����,������)}
			{"tie_001",1,1},			--{����,��С����,������)}
			{"Boss_003",1,1},			--{����,��С����,������)}
			{"Boss_003",1,1},			--{����,��С����,������)}
		},
	},
	
	--��ͼȫ��ս������(ͭȸ̨)
	tacticPool = 
	{
		--��һ��
		[1] = {
			totalValue = 30,
			{value = 10, reward = {3220,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3221,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3222,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
		},
		
		--�ڶ���
		[2] = {
			totalValue = 40,
			{value = 10, reward = {3210,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3211,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3212,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3213,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
		},
	},
	
	--����ʱ���(ÿ�տ����ö��ʱ���)
	openTime = 
	{
		normal = {
			{beginTime = "00:00:00", endTime = "23:59:59",},
		},
	},
	
	--��Ч������(ͭȸ̨)
	validCondition = 
	{
		--2����
		--timeLimit = 120000,					--�����Ϸʱ������λ���룩
		timeLimit = 0,					--�����Ϸʱ������λ���룩
	},
}

-----------------------------------------------------------������-ľ�ġ�--------------------------------------------------------
--geyachao: �¼ӷ���������� ����
--����-ľ��
_tab_room[6] = 
{
	mapkey = "world/td_jt_001",
	
	groupMapFlag = 1, --�Ƿ�Ϊ���ŵ�ͼ
	fps = 60, --ָ��֡��fps
	
	confgInfo = 
	{
		--����1
		[1] = 
		{
			maxNum = 1,					--������������
			des = hVar.tab_string["__TEXT_SHU"],		--��������
			defaultType = hVar.POS_TYPE.BLANK,		--Ĭ������ 0�� 1��� 2�򵥵��� 3��ͨ���� 4�߼�����
			computerOnly = false,				--�Ƿ�ֻ�������
			
		},
		--����2
		[2] = 
		{
			--Ĭ��
			maxNum = 1,					--������������
			des = hVar.tab_string["__TEXT_WEI"],		--��������
			defaultType = hVar.POS_TYPE.AI_HARD,		--Ĭ������ 0�� 1��� 2�򵥵��� 3��ͨ���� 4�߼�����
			computerOnly = true,				--�Ƿ�ֻ�������
			
		},
	},
	
	kickoutCD = 86400, --��ҳ�ʱ�߳������ȴ�ʱ��(��)
	
	--��ս����
	challengeMaxCount = 1,
	
	--��ʾ����
	rewardShow = 
	{
		[hVar.POS_TYPE.AI_EASY] = {
			{17,1},
			{1,1},
			{20,5},
		},
		[hVar.POS_TYPE.AI_NORMAL] = {
			{17,2},
			{1,1},
			{20,5},
		},
		[hVar.POS_TYPE.AI_HARD] = {
			{17,3},
			{1,1},
			{20,5},
			{11,100},
		},
	},
	
	--ľ�Ľ�������
	reward = {
		[hVar.POS_TYPE.AI_EASY] = {
			--�м������س�������rewardNum��ʾ���г鼸��
			rewardNum = 3,				--�������
			{"mucai_001",1,1},			--{����,��С����,������)}
			{"mucai_001",1,1},			--{����,��С����,������)}
			{"Boss_002",1,1},			--{����,��С����,������)}
			{"Boss_002",1,1},			--{����,��С����,������)}
			{"Boss_002",1,1},			--{����,��С����,������)}
		},
		[hVar.POS_TYPE.AI_NORMAL] = {
			--�м������س�������rewardNum��ʾ���г鼸��
			rewardNum = 3,				--�������
			{"mucai_001",1,1},			--{����,��С����,������)}
			{"mucai_001",1,1},			--{����,��С����,������)}
			{"mucai_001",1,1},			--{����,��С����,������)}
			{"Boss_002",1,1},			--{����,��С����,������)}
			{"Boss_002",1,1},			--{����,��С����,������)}
		},
		[hVar.POS_TYPE.AI_HARD] = {
			--�м������س�������rewardNum��ʾ���г鼸��
			rewardNum = 3,				--�������
			{"mucai_001",1,1},			--{����,��С����,������)}
			{"mucai_001",1,1},			--{����,��С����,������)}
			{"mucai_001",1,1},			--{����,��С����,������)}
			{"Boss_003",1,1},			--{����,��С����,������)}
			{"Boss_003",1,1},			--{����,��С����,������)}
		},
	},
	
	--��ͼȫ��ս������(ͭȸ̨)
	tacticPool = 
	{
		--��һ��
		[1] = {
			totalValue = 30,
			{value = 10, reward = {3220,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3221,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3222,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
		},
		
		--�ڶ���
		[2] = {
			totalValue = 40,
			{value = 10, reward = {3210,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3211,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3212,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3213,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
		},
	},
	
	--����ʱ���(ÿ�տ����ö��ʱ���)
	openTime = 
	{
		normal = {
			{beginTime = "00:00:00", endTime = "23:59:59",},
		},
	},
	
	--��Ч������(ͭȸ̨)
	validCondition = 
	{
		--2����
		--timeLimit = 120000,					--�����Ϸʱ������λ���룩
		timeLimit = 0,					--�����Ϸʱ������λ���룩
	},
}

-----------------------------------------------------------������-��ʳ��--------------------------------------------------------
--geyachao: �¼ӷ���������� ����
--����-��ʳ
_tab_room[7] = 
{
	mapkey = "world/td_jt_002",
	
	groupMapFlag = 1, --�Ƿ�Ϊ���ŵ�ͼ
	fps = 60, --ָ��֡��fps
	
	confgInfo = 
	{
		--����1
		[1] = 
		{
			maxNum = 1,					--������������
			des = hVar.tab_string["__TEXT_SHU"],		--��������
			defaultType = hVar.POS_TYPE.BLANK,		--Ĭ������ 0�� 1��� 2�򵥵��� 3��ͨ���� 4�߼�����
			computerOnly = false,				--�Ƿ�ֻ�������
			
		},
		--����2
		[2] = 
		{
			--Ĭ��
			maxNum = 1,					--������������
			des = hVar.tab_string["__TEXT_WEI"],		--��������
			defaultType = hVar.POS_TYPE.AI_HARD,		--Ĭ������ 0�� 1��� 2�򵥵��� 3��ͨ���� 4�߼�����
			computerOnly = true,				--�Ƿ�ֻ�������
			
		},
	},
	
	kickoutCD = 86400, --��ҳ�ʱ�߳������ȴ�ʱ��(��)
	
	--��ս����
	challengeMaxCount = 1,
	
	--��ʾ����
	rewardShow = 
	{
		[hVar.POS_TYPE.AI_EASY] = {
			{18,1},
			{1,1},
			{20,5},
		},
		[hVar.POS_TYPE.AI_NORMAL] = {
			{18,2},
			{1,1},
			{20,5},
		},
		[hVar.POS_TYPE.AI_HARD] = {
			{18,3},
			{1,1},
			{20,5},
			{11,100},
		},
	},
	
	--��ʳ��������
	reward = {
		[hVar.POS_TYPE.AI_EASY] = {
			--�м������س�������rewardNum��ʾ���г鼸��
			rewardNum = 3,				--�������
			{"liangshi_001",1,1},			--{����,��С����,������)}
			{"liangshi_001",1,1},			--{����,��С����,������)}
			{"Boss_002",1,1},			--{����,��С����,������)}
			{"Boss_002",1,1},			--{����,��С����,������)}
			{"Boss_002",1,1},			--{����,��С����,������)}
		},
		[hVar.POS_TYPE.AI_NORMAL] = {
			--�м������س�������rewardNum��ʾ���г鼸��
			rewardNum = 3,				--�������
			{"liangshi_001",1,1},			--{����,��С����,������)}
			{"liangshi_001",1,1},			--{����,��С����,������)}
			{"liangshi_001",1,1},			--{����,��С����,������)}
			{"Boss_002",1,1},			--{����,��С����,������)}
			{"Boss_002",1,1},			--{����,��С����,������)}
		},
		[hVar.POS_TYPE.AI_HARD] = {
			--�м������س�������rewardNum��ʾ���г鼸��
			rewardNum = 3,				--�������
			{"liangshi_001",1,1},			--{����,��С����,������)}
			{"liangshi_001",1,1},			--{����,��С����,������)}
			{"liangshi_001",1,1},			--{����,��С����,������)}
			{"Boss_003",1,1},			--{����,��С����,������)}
			{"Boss_003",1,1},			--{����,��С����,������)}
		},
	},
	
	
	--��ͼȫ��ս������(ͭȸ̨)
	tacticPool = 
	{
		--��һ��
		[1] = {
			totalValue = 30,
			{value = 10, reward = {3220,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3221,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3222,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
		},
		
		--�ڶ���
		[2] = {
			totalValue = 40,
			{value = 10, reward = {3210,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3211,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3212,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3213,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
		},
	},
	
	--����ʱ���(ÿ�տ����ö��ʱ���)
	openTime = 
	{
		normal = {
			{beginTime = "00:00:00", endTime = "23:59:59",},
		},
	},
	
	--��Ч������(ͭȸ̨)
	validCondition = 
	{
		--2����
		--timeLimit = 120000,					--�����Ϸʱ������λ���룩
		timeLimit = 0,					--�����Ϸʱ������λ���룩
	},
}

-----------------------------------------------------------������-���ű��⸱����--------------------------------------------------------
--geyachao: �¼ӷ���������� ����
--����-���ű���
_tab_room[8] = 
{
	mapkey = "world/td_jt_004",
	
	groupMapFlag = 1, --�Ƿ�Ϊ���ŵ�ͼ
	
	confgInfo = 
	{
		--����1
		[1] = 
		{
			maxNum = 2,					--������������
			des = hVar.tab_string["__TEXT_SHU"],		--��������
			defaultType = hVar.POS_TYPE.BLANK,		--Ĭ������ 0�� 1��� 2�򵥵��� 3��ͨ���� 4�߼�����
			computerOnly = false,				--������������ҽ���
			
		},
		--����2
		[2] = 
		{
			--Ĭ��
			maxNum = 1,					--������������
			des = hVar.tab_string["__TEXT_WEI"],		--��������
			defaultType = hVar.POS_TYPE.AI_EASY,		--Ĭ������ 0�� 1��� 2�򵥵��� 3��ͨ���� 4�߼�����
			computerOnly = true,				--��������������ҽ���
			
		},
	},
	
	kickoutCD = 180, --��ҳ�ʱ�߳������ȴ�ʱ��(��)
	
	--��ս����
	challengeMaxCount = 1,
	
	--��ʾ����
	rewardShow = 
	{
		[hVar.POS_TYPE.AI_EASY] = {
			{10,12412},
			{10,12406},
			{5,10231,1,},
			{5,10235,1,},
		},
	},
	
	--���ű����������
	reward = {
		[hVar.POS_TYPE.AI_EASY] = {
			--�м������س�������rewardNum��ʾ���г鼸��
			rewardNum = 3,				--�������
			{"Boss_001",1,1},			--{����,��С����,������)} --�׼�֮ʯ
			{"Equip_juntuanfuben",1,1},		--{����,��С����,������)} --��������
			{"juntuan_dongzhuo",1,1},		--{����,��С����,������)} --��׿����
			{"juntuan_sunjian",1,1},		--{����,��С����,������)} --��Ὣ��
			{"Boss_003",1,2},			--{����,��С����,������)} --������ʯ
		},
	},
	
	--��ͼȫ��ս������(���ű���)
	tacticPool = 
	{
		--��һ��
		[1] = {
			totalValue = 110,
			{value = 10, reward = {3001,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3002,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3003,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3004,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3005,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3006,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			--{value = 10, reward = {3007,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3008,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3009,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3010,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3011,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3012,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
		},
		--�ڶ���
		[2] = {
			totalValue = 180,
			{value = 10, reward = {3021,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3022,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3023,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3024,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3025,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3026,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3027,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3028,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3029,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3030,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3031,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3032,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3033,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3034,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3035,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3036,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3037,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3038,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
		},
		--������
		[3] = {
			totalValue = 140,
			{value = 10, reward = {3041,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3042,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3043,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3044,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3045,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3046,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3047,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3048,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3049,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3050,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3051,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3052,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3053,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3054,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			   
		},
	},
	
	--����ʱ���(ÿ�տ����ö��ʱ���)
	openTime = 
	{
		normal = {
			--{beginTime = "12:00:00", endTime = "13:59:59",},
			--{beginTime = "20:00:00", endTime = "22:59:59",},
			{beginTime = "05:00:00", endTime = "23:59:59",},
		},
	},
	
	--ÿ�ܼ����ŵ�����
	openDayOfWeek =
	{
		5,6,7,
	},
	
	--��Ч������(���ű���)
	validCondition = 
	{
		--2����
		--timeLimit = 120000,					--�����Ϸʱ������λ���룩
		timeLimit = 0,					--�����Ϸʱ������λ���룩
	},
}

-----------------------------------------------------------������-����פ��ģʽ��ͼ��--------------------------------------------------------
--����-����פ��ģʽ
_tab_room[9] = 
{
	
	mapkey = "world/td_wj_005",
	
	groupMapFlag = 1, --�Ƿ�Ϊ���ŵ�ͼ
	
	confgInfo = 
	{
		--����1
		[1] = 
		{
			maxNum = 2,					--������������
			des = hVar.tab_string["__TEXT_SHU"],		--��������
			defaultType = hVar.POS_TYPE.BLANK,		--Ĭ������ 0�� 1��� 2�򵥵��� 3��ͨ���� 4�߼�����
			computerOnly = false,				--������������ҽ���
			
		},
		--����2
		[2] = 
		{
			--Ĭ��
			maxNum = 1,					--������������
			des = hVar.tab_string["__TEXT_WEI"],		--��������
			defaultType = hVar.POS_TYPE.AI_EASY,		--Ĭ������ 0�� 1��� 2�򵥵��� 3��ͨ���� 4�߼�����
			computerOnly = true,				--��������������ҽ���
			
		},
	},
	
	kickoutCD = 180, --��ҳ�ʱ�߳������ȴ�ʱ��(��)
	
	--��ս����
	challengeMaxCount = 1,
	
	--��ʾ����
	rewardShow = 
	{
		[hVar.POS_TYPE.AI_EASY] = {
			{10,12412},
			{10,12406},
			{5,10231,1,},
			{5,10235,1,},
		},
	},
	
	--���ű����������
	reward = {
		[hVar.POS_TYPE.AI_EASY] = {
			--�м������س�������rewardNum��ʾ���г鼸��
			rewardNum = 3,				--�������
			{"Boss_001",1,1},			--{����,��С����,������)} --�׼�֮ʯ
			{"Equip_juntuanfuben",1,1},		--{����,��С����,������)} --��������
			{"juntuan_dongzhuo",1,1},		--{����,��С����,������)} --��׿����
			{"juntuan_sunjian",1,1},		--{����,��С����,������)} --��Ὣ��
			{"Boss_003",1,2},			--{����,��С����,������)} --������ʯ
		},
	},
	
	--��ͼȫ��ս������(����פ��ģʽ)
	tacticPool = 
	{
		--��һ��
		[1] = {
			totalValue = 110,
			{value = 10, reward = {3001,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3002,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3003,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3004,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3005,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3006,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			--{value = 10, reward = {3007,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3008,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3009,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3010,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3011,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3012,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
		},
		--�ڶ���
		[2] = {
			totalValue = 180,
			{value = 10, reward = {3021,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3022,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3023,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3024,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3025,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3026,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3027,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3028,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3029,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3030,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3031,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3032,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3033,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3034,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3035,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3036,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3037,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3038,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
		},
		--������
		[3] = {
			totalValue = 140,
			{value = 10, reward = {3041,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3042,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3043,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3044,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3045,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3046,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3047,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3048,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3049,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3050,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3051,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3052,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3053,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3054,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			   
		},
	},
	
	--����ʱ���(ÿ�տ����ö��ʱ���)
	openTime = 
	{
		normal = {
			--{beginTime = "12:00:00", endTime = "13:59:59",},
			--{beginTime = "20:00:00", endTime = "22:59:59",},
			{beginTime = "05:00:00", endTime = "23:59:59",},
		},
	},
	
	--ÿ�ܼ����ŵ�����
	openDayOfWeek =
	{
		5,6,7,
	},
	
	--��Ч������(����פ��ģʽ)
	validCondition = 
	{
		--2����
		--timeLimit = 120000,					--�����Ϸʱ������λ���룩
		timeLimit = 0,					--�����Ϸʱ������λ���룩
	},
}


-----------------------------------------------------------�������޵С�--------------------------------------------------------
--�����޵�
_tab_room[10] = 
{
	mapkey = "world/td_wj_007",
	
	groupMapFlag = 0, --�Ƿ�Ϊ���ŵ�ͼ
	fps = 30, --ָ��֡��fps
	
	confgInfo = 
	{
		--����1
		[1] = 
		{
			maxNum = 2,					--������������
			des = hVar.tab_string["__TEXT_SHU"],		--��������
			defaultType = hVar.POS_TYPE.BLANK,		--Ĭ������ 0�� 1��� 2�򵥵��� 3��ͨ���� 4�߼�����
			computerOnly = false,				--������������ҽ���
			
		},
		--����2
		[2] = 
		{
			--Ĭ��
			maxNum = 1,					--������������
			des = hVar.tab_string["__TEXT_WEI"],		--��������
			defaultType = hVar.POS_TYPE.AI_EASY,		--Ĭ������ 0�� 1��� 2�򵥵��� 3��ͨ���� 4�߼�����
			computerOnly = true,				--��������������ҽ���
			
		},
	},
	
	kickoutCD = 300, --��ҳ�ʱ�߳������ȴ�ʱ��(��)
	
	--��ս����
	challengeMaxCount = 99999,
	
	--��ʾ����
	rewardShow = 
	{
		[hVar.POS_TYPE.AI_EASY] = {
			{1,1000},
		},
	},
	
	--�����޵н�������
	reward = {
		[hVar.POS_TYPE.AI_EASY] = {
			--�м������س�������rewardNum��ʾ���г鼸��
			rewardNum = 3,				--�������
			{"Boss_004",1,1},			--{����,��С����,������)} --�׼�֮ʯ
			{"Boss_003",1,2},			--{����,��С����,������)} --������ʯ
			{"treasure_renzuwudi",1,1},		--{����,��С����,������)} --�ر�ͼ�������޵е��䣩
			{"treasure_renzuwudi",1,1},		--{����,��С����,������)} --�ر�ͼ�������޵е��䣩
			{"treasure_renzuwudi",1,1},		--{����,��С����,������)} --�ر�ͼ�������޵е��䣩
		},
	},
	
	--[[
	--�����޵н���������Ƭ����
	rewardTreasure = {
		[hVar.POS_TYPE.AI_EASY] = {
			--�м������س�������rewardNum��ʾ���г鼸��
			rewardNum = 1,				--�������
			{"treasure_renzuwudi", 1, 1,},			--{����,��С����,������)}
		},
	},
	]]
	
	--��ͼȫ��ս������(�����޵�)
	tacticPool = 
	{
		--��һ��
		[1] = {
			totalValue = 110,
			{value = 10, reward = {3001,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3002,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3003,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3004,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3005,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3006,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			--{value = 10, reward = {3007,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3008,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3009,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3010,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3011,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3012,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
		},
		--�ڶ���
		[2] = {
			totalValue = 180,
			{value = 10, reward = {3021,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3022,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3023,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3024,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3025,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3026,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3027,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3028,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3029,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3030,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3031,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3032,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3033,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3034,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3035,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3036,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3037,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3038,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
		},
		--������
		[3] = {
			totalValue = 140,
			{value = 10, reward = {3041,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3042,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3043,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3044,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3045,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3046,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3047,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3048,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3049,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3050,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3051,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3052,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3053,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3054,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			   
		},
	},
	
	--����ʱ���(ÿ�տ����ö��ʱ���)
	openTime = 
	{
		normal = {
			{beginTime = "05:00:00", endTime = "23:59:59",},
		},
	},
	
	--��Ч������(�����޵�)
	validCondition = 
	{
		--2����
		--timeLimit = 120000,					--�����Ϸʱ������λ���룩
		timeLimit = 0,					--�����Ϸʱ������λ���룩
	},
}

-----------------------------------------------------------��ħ��ɱ��--------------------------------------------------------
--ħ��ɱ��
_tab_room[11] = 
{
	mapkey = "world/td_wj_004",
	
	groupMapFlag = 0, --�Ƿ�Ϊ���ŵ�ͼ
	
	confgInfo = 
	{
		--����1
		[1] = 
		{
			maxNum = 1,					--������������
			des = hVar.tab_string["__TEXT_SHU"],		--��������
			defaultType = hVar.POS_TYPE.BLANK,		--Ĭ������ 0�� 1��� 2�򵥵��� 3��ͨ���� 4�߼�����
			computerOnly = false,				--�Ƿ�ֻ�������
			
		},
		--����2
		[2] = 
		{
			--Ĭ��
			maxNum = 1,					--������������
			des = hVar.tab_string["__TEXT_WEI"],		--��������
			defaultType = hVar.POS_TYPE.AI_EASY,		--Ĭ������ 0�� 1��� 2�򵥵��� 3��ͨ���� 4�߼�����
			computerOnly = true,				--�Ƿ�ֻ�������
			
		},
	},
	
	kickoutCD = 86400, --��ҳ�ʱ�߳������ȴ�ʱ��(��)
	
	--��ս����
	challengeMaxCount = 99999,
	
	--��ʾ����
	rewardShow = 
	{
		[hVar.POS_TYPE.AI_EASY] = {
			{1,1000},
			--{5,10232},	--����
			{11,100},
			{23,1},
			{24,1},
		},
	},
	
	--ħ��ɱ���������
	reward = {
		[hVar.POS_TYPE.AI_EASY] = {
			--�м������س�������rewardNum��ʾ���г鼸��
			rewardNum = 3,				--�������
			{"Boss_002",1,2},			--{����,��С����,������)} --����
			{"Boss_003",1,2},			--{����,��С����,������)} --������ʯ
			{"treasure_motashazhen",1,1},		--{����,��С����,������)} --�ر�ͼ��ħ��ɱ����䣩
			{"treasure_motashazhen",1,1},		--{����,��С����,������)} --�ر�ͼ��ħ��ɱ����䣩
			{"treasure_motashazhen",1,1},		--{����,��С����,������)} --�ر�ͼ��ħ��ɱ����䣩
		},
	},
	
	--[[
	--ħ��ɱ�����������Ƭ����
	rewardTreasure = {
		[hVar.POS_TYPE.AI_EASY] = {
			--�м������س�������rewardNum��ʾ���г鼸��
			rewardNum = 1,				--�������
			{"treasure_motashazhen", 1, 1,},			--{����,��С����,������)}
		},
	},
	]]
	
	--[[
	--ħ��ɱ���������,ÿ�ܱص�1��
	rewardPerWeek = {
		--���Ѷ�
		[hVar.POS_TYPE.AI_EASY] = {
			min = 3,
			max = 5,
			{5,10232},	--����
		},
	},
	]]
	
	--��ͼȫ��ս������(ħ��ɱ��)
	tacticPool = 
	{
		--��һ��
		[1] = {
			totalValue = 40,
			{value = 10, reward = {3041,5},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3041,6},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3041,7},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3041,8},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
		},
		
		--�ڶ���
		[2] = {
			totalValue = 40,
			{value = 10, reward = {3043,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3043,2},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3043,3},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3043,4},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
		},
		
		--������
		[3] = {
			totalValue = 30,
			{value = 10, reward = {3046,3},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3048,3},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3050,3},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
		},
	},
	
	--����ʱ���(ÿ�տ����ö��ʱ���)
	openTime = 
	{
		normal = {
			{beginTime = "00:00:00", endTime = "23:59:59",},
		},
	},
	
	--��Ч������(ħ��ɱ��)
	validCondition = 
	{
		--2����
		--timeLimit = 120000,					--�����Ϸʱ������λ���룩
		timeLimit = 0,					--�����Ϸʱ������λ���룩
	},
}

-----------------------------------------------------------����������--------------------------------------------------------
--��������
_tab_room[12] = 
{
	mapkey = "world/td_swjg",
	
	groupMapFlag = 0, --�Ƿ�Ϊ���ŵ�ͼ
	fps = 30, --ָ��֡��fps
	
	confgInfo = 
	{
		--����1
		[1] = 
		{
			maxNum = 1,					--������������
			des = hVar.tab_string["__TEXT_SHU"],		--��������
			defaultType = hVar.POS_TYPE.BLANK,		--Ĭ������ 0�� 1��� 2�򵥵��� 3��ͨ���� 4�߼�����
			computerOnly = false,				--�Ƿ�ֻ�������
			
		},
		--����2
		[2] = 
		{
			--Ĭ��
			maxNum = 1,					--������������
			des = hVar.tab_string["__TEXT_WEI"],		--��������
			defaultType = hVar.POS_TYPE.AI_EASY,		--Ĭ������ 0�� 1��� 2�򵥵��� 3��ͨ���� 4�߼�����
			computerOnly = true,				--�Ƿ�ֻ�������
			
		},
	},
	
	kickoutCD = 86400, --��ҳ�ʱ�߳������ȴ�ʱ��(��)
	
	--��ս����
	challengeMaxCount = 99999,
	
	--��ʾ����
	rewardShow = 
	{
		[hVar.POS_TYPE.AI_EASY] = {
			{1,1000},
			{11,100},
			{23,1},
		},
		[hVar.POS_TYPE.AI_NORMAL] = {
			{1,1000},
			{11,100},
			{23,1},
			{24,1},
		},
		[hVar.POS_TYPE.AI_HARD] = {
			{10,12406},
			{11,100},
			{23,1},
			{24,1},
		},
	},
	
	--���������������
	reward = {
		[hVar.POS_TYPE.AI_EASY] = {
			--�м������س�������rewardNum��ʾ���г鼸��
			rewardNum = 3,				--�������
			{"Boss_002",1,2},			--{����,��С����,������)} --����
			{"Boss_003",1,2},			--{����,��С����,������)} --������ʯ
			{"treasure_shouweijiange_eazy",1,1},	--{����,��С����,������)} --�ر�ͼ������������䣩
			{"treasure_shouweijiange_eazy",1,1},	--{����,��С����,������)} --�ر�ͼ������������䣩
			{"treasure_shouweijiange_eazy",1,1},	--{����,��С����,������)} --�ر�ͼ������������䣩
		},
		
		[hVar.POS_TYPE.AI_NORMAL] = {
			--�м������س�������rewardNum��ʾ���г鼸��
			rewardNum = 3,				--�������
			{"Boss_002",1,2},			--{����,��С����,������)} --����
			{"Boss_003",1,2},			--{����,��С����,������)} --������ʯ
			{"treasure_shouweijiange_middle",1,1},	--{����,��С����,������)} --�ر�ͼ������������䣩
			{"treasure_shouweijiange_middle",1,1},	--{����,��С����,������)} --�ر�ͼ������������䣩
			{"treasure_shouweijiange_middle",1,1},	--{����,��С����,������)} --�ر�ͼ������������䣩
		},
		
		[hVar.POS_TYPE.AI_HARD] = {
			--�м������س�������rewardNum��ʾ���г鼸��
			rewardNum = 3,				--�������
			{"Boss_004",1,1},			--{����,��С����,������)} --�׼�֮ʯ
			{"Boss_003",1,2},			--{����,��С����,������)} --������ʯ
			{"treasure_shouweijiange_hard",1,1},	--{����,��С����,������)} --�ر�ͼ������������䣩
			{"treasure_shouweijiange_hard",1,1},	--{����,��С����,������)} --�ر�ͼ������������䣩
			{"treasure_shouweijiange_hard",1,1},	--{����,��С����,������)} --�ر�ͼ������������䣩
		},
	},
	
	--[[
	--�����������������Ƭ����
	rewardTreasure = {
		[hVar.POS_TYPE.AI_EASY] = {
			--�м������س�������rewardNum��ʾ���г鼸��
			rewardNum = 1,				--�������
			{"treasure_shouweijiange", 1, 1,},			--{����,��С����,������)}
		},
	},
	]]
	
	--[[
	--���������������,ÿ�ܱص�1��
	rewardPerWeek = {
		--���Ѷ�
		[hVar.POS_TYPE.AI_EASY] = {
			min = 3,
			max = 5,
			{5,10237},	--�ϻ�
			{5,10238},	--ף�ڷ���
		},
	},
	]]
	
	--��ͼȫ��ս������(��������)
	tacticPool = 
	{
		--��һ��
		[1] = {
			totalValue = 100,
			{value = 100, reward = {1245,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
		},
	},
	
	--����ʱ���(ÿ�տ����ö��ʱ���)
	openTime = 
	{
		normal = {
			{beginTime = "00:00:00", endTime = "23:59:59",},
		},
	},
	
	--��Ч������(ħ��ɱ��)
	validCondition = 
	{
		--2����
		--timeLimit = 120000,					--�����Ϸʱ������λ���룩
		timeLimit = 0,					--�����Ϸʱ������λ���룩
	},
}

-----------------------------------------------------------��˫����������--------------------------------------------------------
--˫����������
_tab_room[13] = 
{
	mapkey = "world/td_swjg2",
	--mapkey = "world/td_swjg2_s", --�����
	
	groupMapFlag = 0, --�Ƿ�Ϊ���ŵ�ͼ
	fps = 30, --ָ��֡��fps
	
	confgInfo = 
	{
		--����1
		[1] = 
		{
			maxNum = 2,					--������������
			des = hVar.tab_string["__TEXT_SHU"],		--��������
			defaultType = hVar.POS_TYPE.BLANK,		--Ĭ������ 0�� 1��� 2�򵥵��� 3��ͨ���� 4�߼�����
			computerOnly = false,				--������������ҽ���
			
		},
		--����2
		[2] = 
		{
			--Ĭ��
			maxNum = 1,					--������������
			des = hVar.tab_string["__TEXT_WEI"],		--��������
			defaultType = hVar.POS_TYPE.AI_EASY,		--Ĭ������ 0�� 1��� 2�򵥵��� 3��ͨ���� 4�߼�����
			computerOnly = true,				--��������������ҽ���
			
		},
	},
	
	kickoutCD = 300, --��ҳ�ʱ�߳������ȴ�ʱ��(��)
	
	--��ս����
	challengeMaxCount = 99999,
	
	--��ʾ����
	rewardShow = 
	{
		[hVar.POS_TYPE.AI_EASY] = {
			{1,1000},
		},
	},
	
	--˫�����������������
	reward = {
		[hVar.POS_TYPE.AI_EASY] = {
			--�м������س�������rewardNum��ʾ���г鼸��
			rewardNum = 3,				--�������
			{"Boss_004_swjg2",1,1},			--{����,��С����,������)} --�׼�֮ʯ
			{"Boss_003",1,2},			--{����,��С����,������)} --������ʯ
			{"treasure_shouweijiange2",1,1},	--{����,��С����,������)} --�ر�ͼ��˫������������䣩
			{"treasure_shouweijiange2",1,1},	--{����,��С����,������)} --�ر�ͼ��˫������������䣩
			{"treasure_shouweijiange2",1,1},	--{����,��С����,������)} --�ر�ͼ��˫������������䣩
		},
	},
	
	--[[
	--˫����������������� �����
	reward = {
		[hVar.POS_TYPE.AI_EASY] = {
			--�м������س�������rewardNum��ʾ���г鼸��
			rewardNum = 3,				--�������
			{"Boss_004_swjg2",1,1},			--{����,��С����,������)} --�׼�֮ʯ
			{"Boss_laohu",1,1},			--{����,��С����,������)} --���뻢
			{"treasure_shouweijiange2",1,1},	--{����,��С����,������)} --�ر�ͼ��˫������������䣩
			{"treasure_shouweijiange2",1,1},	--{����,��С����,������)} --�ر�ͼ��˫������������䣩
			{"treasure_shouweijiange2",1,1},	--{����,��С����,������)} --�ر�ͼ��˫������������䣩
		},
	},
	]]
	
	--[[
	--˫������������������Ƭ����
	rewardTreasure = {
		[hVar.POS_TYPE.AI_EASY] = {
			--�м������س�������rewardNum��ʾ���г鼸��
			rewardNum = 1,				--�������
			{"treasure_shouweijiange2", 1, 1,},			--{����,��С����,������)}
		},
	},
	]]
	
	--��ͼȫ��ս������(˫��������)
	tacticPool = 
	{
		--��һ��
		[1] = {
			totalValue = 100,
			{value = 100, reward = {1246,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
		},
	},
	
	--����ʱ���(ÿ�տ����ö��ʱ���)
	openTime = 
	{
		normal = {
			{beginTime = "05:00:00", endTime = "23:59:59",},
		},
	},
	
	--��Ч������(�����޵�)
	validCondition = 
	{
		--2����
		--timeLimit = 120000,					--�����Ϸʱ������λ���룩
		timeLimit = 0,					--�����Ϸʱ������λ���룩
	},
}


-----------------------------------------------------------����֮������--------------------------------------------------------
--��֮����
_tab_room[14] = 
{
	mapkey = "world/td_swjg2",
	--mapkey = "world/td_swjg2_s", --�����
	
	groupMapFlag = 0, --�Ƿ�Ϊ���ŵ�ͼ
	fps = 30, --ָ��֡��fps
	
	confgInfo = 
	{
		--����1
		[1] = 
		{
			maxNum = 2,					--������������
			des = hVar.tab_string["__TEXT_SHU"],		--��������
			defaultType = hVar.POS_TYPE.BLANK,		--Ĭ������ 0�� 1��� 2�򵥵��� 3��ͨ���� 4�߼�����
			computerOnly = false,				--������������ҽ���
			
		},
		--����2
		[2] = 
		{
			--Ĭ��
			maxNum = 1,					--������������
			des = hVar.tab_string["__TEXT_WEI"],		--��������
			defaultType = hVar.POS_TYPE.AI_EASY,		--Ĭ������ 0�� 1��� 2�򵥵��� 3��ͨ���� 4�߼�����
			computerOnly = true,				--��������������ҽ���
			
		},
	},
	
	kickoutCD = 300, --��ҳ�ʱ�߳������ȴ�ʱ��(��)
	
	--��ս����
	challengeMaxCount = 99999,
	
	--��ʾ����
	rewardShow = 
	{
		[hVar.POS_TYPE.AI_EASY] = {
			{1,1000},
		},
	},
	
	--˫�����������������
	reward = {
		[hVar.POS_TYPE.AI_EASY] = {
			--�м������س�������rewardNum��ʾ���г鼸��
			rewardNum = 3,				--�������
			{"Boss_004_swjg2",1,1},			--{����,��С����,������)} --�׼�֮ʯ
			{"Boss_003",1,2},			--{����,��С����,������)} --������ʯ
			{"treasure_shouweijiange2",1,1},	--{����,��С����,������)} --�ر�ͼ��˫������������䣩
			{"treasure_shouweijiange2",1,1},	--{����,��С����,������)} --�ر�ͼ��˫������������䣩
			{"treasure_shouweijiange2",1,1},	--{����,��С����,������)} --�ر�ͼ��˫������������䣩
		},
	},
	
	--[[
	--˫����������������� �����
	reward = {
		[hVar.POS_TYPE.AI_EASY] = {
			--�м������س�������rewardNum��ʾ���г鼸��
			rewardNum = 3,				--�������
			{"Boss_004_swjg2",1,1},			--{����,��С����,������)} --�׼�֮ʯ
			{"Boss_laohu",1,1},			--{����,��С����,������)} --���뻢
			{"treasure_shouweijiange2",1,1},	--{����,��С����,������)} --�ر�ͼ��˫������������䣩
			{"treasure_shouweijiange2",1,1},	--{����,��С����,������)} --�ر�ͼ��˫������������䣩
			{"treasure_shouweijiange2",1,1},	--{����,��С����,������)} --�ر�ͼ��˫������������䣩
		},
	},
	]]
	
	--[[
	--˫������������������Ƭ����
	rewardTreasure = {
		[hVar.POS_TYPE.AI_EASY] = {
			--�м������س�������rewardNum��ʾ���г鼸��
			rewardNum = 1,				--�������
			{"treasure_shouweijiange2", 1, 1,},			--{����,��С����,������)}
		},
	},
	]]
	
	--��ͼȫ��ս������(˫��������)
	tacticPool = 
	{
		--��һ��
		[1] = {
			totalValue = 100,
			{value = 100, reward = {1246,1},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
		},
	},
	
	--����ʱ���(ÿ�տ����ö��ʱ���)
	openTime = 
	{
		normal = {
			{beginTime = "05:00:00", endTime = "23:59:59",},
		},
	},
	
	--��Ч������(�����޵�)
	validCondition = 
	{
		--2����
		--timeLimit = 120000,					--�����Ϸʱ������λ���룩
		timeLimit = 0,					--�����Ϸʱ������λ���룩
	},
}

-----------------------------------------------------------����ս���--------------------------------------------------------
--��ս����
_tab_room[15] = 
{
	mapkey = "world/td_wj_008",
	
	groupMapFlag = 0, --�Ƿ�Ϊ���ŵ�ͼ
	
	confgInfo = 
	{
		--����1
		[1] = 
		{
			maxNum = 1,					--������������
			des = hVar.tab_string["__TEXT_SHU"],		--��������
			defaultType = hVar.POS_TYPE.BLANK,		--Ĭ������ 0�� 1��� 2�򵥵��� 3��ͨ���� 4�߼�����
			computerOnly = false,				--�Ƿ�ֻ�������
			
		},
		--����2
		[2] = 
		{
			--Ĭ��
			maxNum = 1,					--������������
			des = hVar.tab_string["__TEXT_WEI"],		--��������
			defaultType = hVar.POS_TYPE.AI_EASY,		--Ĭ������ 0�� 1��� 2�򵥵��� 3��ͨ���� 4�߼�����
			computerOnly = true,				--�Ƿ�ֻ�������
			
		},
	},
	
	kickoutCD = 86400, --��ҳ�ʱ�߳������ȴ�ʱ��(��)
	
	--��ս����
	challengeMaxCount = 99999,
	
	--��ʾ����
	rewardShow = 
	{
		[hVar.POS_TYPE.AI_EASY] = {
			{1,1000},
			--{5,10232},	--����
			{11,100},
			{23,1},
			{24,1},
		},
	},
	
	--��ս�����������
	reward = {
		[hVar.POS_TYPE.AI_EASY] = {
			--�м������س�������rewardNum��ʾ���г鼸��
			rewardNum = 3,				--�������
			{"Boss_002",1,2},			--{����,��С����,������)} --����
			{"Boss_003",1,2},			--{����,��С����,������)} --������ʯ
			{"treasure_motashazhen",1,1},		--{����,��С����,������)} --�ر�ͼ��ħ��ɱ����䣩
			{"treasure_motashazhen",1,1},		--{����,��С����,������)} --�ر�ͼ��ħ��ɱ����䣩
			{"treasure_motashazhen",1,1},		--{����,��С����,������)} --�ر�ͼ��ħ��ɱ����䣩
		},
	},
	
	--[[
	--��ս�������������Ƭ����
	rewardTreasure = {
		[hVar.POS_TYPE.AI_EASY] = {
			--�м������س�������rewardNum��ʾ���г鼸��
			rewardNum = 1,				--�������
			{"treasure_motashazhen", 1, 1,},			--{����,��С����,������)}
		},
	},
	]]
	
	--[[
	--��ս�����������,ÿ�ܱص�1��
	rewardPerWeek = {
		--���Ѷ�
		[hVar.POS_TYPE.AI_EASY] = {
			min = 3,
			max = 5,
			{5,10232},	--����
		},
	},
	]]
	
	--��ͼȫ��ս������(��ս����)
	tacticPool = 
	{
		--��һ��
		[1] = {
			totalValue = 100,
			{value = 100, reward = {3041,49},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
		},
		
		--�ڶ���
		[2] = {
			totalValue = 100,
			{value = 100, reward = {3043,96},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
		},
		
		--������
		[3] = {
			totalValue = 30,
			{value = 10, reward = {3140,5},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3171,3},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
			{value = 10, reward = {3172,9},},			--ս�����ܿ�id��ս�����ܿ��ȼ�
		},
	},
	
	--����ʱ���(ÿ�տ����ö��ʱ���)
	openTime = 
	{
		normal = {
			{beginTime = "00:00:00", endTime = "23:59:59",},
		},
	},
	
	--��Ч������(��ս����)
	validCondition = 
	{
		--2����
		--timeLimit = 120000,					--�����Ϸʱ������λ���룩
		timeLimit = 0,					--�����Ϸʱ������λ���룩
	},
}