hVar.tab_mapbehavior = {}
local _tab_mapbehavior = hVar.tab_mapbehavior

-----------------------------------------------------------------
--������ 
-----------------------------------------------------------------
--[1] = 100270001,	--ȫ����֩���
--[2] = 100270002,	--�ƻ��赲��
--[3] = 100270003,	--������ǹ��
--[4] = 100270004,	--Ӫ�ȿ�ѧ��
--[5] = 100270005,	--������ˮ��
--[6] = 100270006,	--ʹ�û��ս����
--[7] = 100270007,	--�����ڶ���֩���
--[8] = 100270008,	--������֩���
--[9] = 100270009,	--�����������
_tab_mapbehavior[100270001] = {--ȫ����֩���
	sType = "killunit", --��ɱ��
	unitidlist = {11113,11114},
	times = 2,
	inArea = {
		{450,600,1600,600}, --����1
	}
	--condition = { -- �������� 
		--relation = "and",--"or"	--�����ڶ����������  ���ݴ˲����ж���ͬʱ���㻹��ֻ��������һ
		
	--},
}

_tab_mapbehavior[100270002] = {--�ƻ��赲��
	sType = "killunit", --��ɱ��
	unitidlist = {5177,5199},
	times = 2,
	inArea = {
		{1400,400,400,400}, --����1
	},
}

_tab_mapbehavior[100270003] = {--������ǹ��
	sType = "killunit", --��ɱ��
	unitidlist = {11103},
	times = 1,
}

_tab_mapbehavior[100270004] = {--Ӫ�ȿ�ѧ��
	sType = "getsource", --��ȡ��Դ
	list = {"scientist"},
	times = 1,
}

_tab_mapbehavior[100270005] = {--������ˮ��
	sType = "killunit", --��ɱ��
	unitidlist = {11100},
	times = 1,
}

_tab_mapbehavior[100270006] = {--ʹ�û��ս����
	sType = "usetactics", --ʹ��ս����
	tacticsidlist = {12013},--��λid ��ս��������
	times = 1,
}

_tab_mapbehavior[100270007] = {--�����ڶ���֩���
	sType = "killunit", --��ɱ��
	unitidlist = {11113,11114},
	times = 6,
	inArea = {
		{2750,1950,1000,1000}, --����1
	},
}

_tab_mapbehavior[100270008] = {--������֩���
	sType = "killunit", --��ɱ��
	unitidlist = {11105},
	times = 1,
}

_tab_mapbehavior[100270009] = {--�����������
	sType = "enterarea", --��������
	times = 1,
	inArea = {
		{840,2520,100,240}, --����1
	},
}
