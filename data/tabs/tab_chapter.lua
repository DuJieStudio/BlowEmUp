hVar.tab_chapter = {}
local _tab_chapter = hVar.tab_chapter
--Ϊ���� gird��� ������ʾ 0 ������ skill icon �� ��������һ�� �������Ŀ� icon

_tab_chapter[0] = {
	icon = "MODEL:default"
	--template = "RangeAttack",		--ʩչ��ʽ���ƶ�ʩչ(UnitAttack),Զ��ȫ��ʩչ(RangeAtack)
	--cast_sort = 5,			--���������Ϊ�Զ�ʩչ������������������ô����ݴ���ֵ�����ڶ����е�˳���Դ���С����
	--enhanceID = {1},			--��������ܻ���������ܵõ�ǿ������ô��ǿ���ļ���id��д������
	--cooldown = 0,				--���ܵ���ȴ�غ�
	--manacost = 1,				--���ܵķ�������
	--_manacost = 1,			--�ض�Ч�����㷨������ʱ����ʹ�ô���ֵ����manacost������ʩ������ħ����Χ���ܣ�
	--count = 1,				--���ܵ��޶�ʩչ����(����Ϊ���޴�,-1��Ϊ��ʼû�жѵ�����Ҫ������Ӵ���)
	--maxcount = 1,				--���ܵ����ʩ�Ŵ���(�������countһ��)
	--enhanceParam = {{"@name",100}},	--��������ܻ�ǿ���������ܣ���ô��ǿ�����ܵ�paramд������
	--counterID = 0,			--�����λ�չ�����Ϊ�˼��ܣ���ô��ʹ�ø�ID���з���,-1�޷�����
	--encounterID = 0,			--�����λ�չ�����Ϊ�˼��ܣ��Ҽ���ʩչ��ʽΪԶ�̣���ô������Χʱ��ʹ�ø�ID�����滻����,-1�޷�����
	--area = {1,1},				--���ܵ����÷�Χ�����籬ը��Χ
	--range = {1,2},			--���ܵ�ʩչ��Χ���ɶ�a~b���ڵĵ���ʩչ(������0��)����ս���ܲ���Ч
	--target = {"ENEMY"},			--�������������Ŀ��:[����(ALL)],[����(SELF),OTHER(������)],[�Ѿ�(ALLY),����(ENEMY)],[����(BUILDING),��λ(UNIT)]
	--targetEX = {"FIGHTER",5000},		--�������������Ŀ��ex����TargetArea��Ч����д��λ�����λid
	--activemode = 1,			--�����������Active,�򼤻��ܴ�Ч�����ơ�1.ÿ�غ���1�� 2.ÿ�غϿɼ����� 3.ÿ�غϿɼ����Σ����ҵȴ�Ҳ�ܼ���
	--cast_check = 1,			--�����ֵΪ1,��ô��CastSkillʱ������Ŀ���Ƿ�����target����
	--trigger_mode = 1,			--�����ֵΪ1,��ô��������(SetAssist)ʱ�ض�����,����ѣ��״̬
	--target_mode = 0,			--�����ֵΪ1,��ô��CastSkillʱ�����õ�targetC������Ϊ��ǰtarget�����������Ϊ�����ܵ�targetC
	--tip = {{},{}},			--����д����ô���᳢���滻����˵���е�[P1],[P2]�ַ���
}

--��1�� ��е֩��
_tab_chapter[1] =
{
	background = "misc/button_null",
	map = "town/select_map1",
	icon = "icon/xlobj/spider04.png",
	scrollW = 2768,
	scrollH = 2768,
	firstmap = "world/yxys_spider_01", --��һ��
	lastmap = "world/yxys_spider_04", --���һ��
	endlessMap = {},
	camera = --��ͷ����
	{
		--Ĭ�Ͼ�ͷλ��
		[1] =
		{
			["mapName"] = 0,
			["pad"] = {dx = 0, dy = 0,},
			["phone"] = {dx = 0, dy = 0,},
		},
	},
	mapX = 1350+256, --�ڷ�����ڵ�ͼ�ϵ�����X
	mapY = 720, --�ڷ�����ڵ�ͼ�ϵ�����Y
	mapFacing = 90, --�ڷ�����ڵ�ͼ�ϵ�����Ƕ�
}

--��2�� �ɴ�
_tab_chapter[2] =
{
	background = "misc/button_null",
	map = "town/select_map1",
	icon = "icon/xlobj/airship04.png",
	scrollW = 2768,
	scrollH = 2768,
	firstmap = "world/yxys_airship_01", --��һ��
	lastmap = "world/yxys_airship_04", --���һ��
	endlessMap = {},
	camera = --��ͷ����
	{
		--Ĭ�Ͼ�ͷλ��
		[1] =
		{
			["mapName"] = 0,
			["pad"] = {dx = 0, dy = 0,},
			["phone"] = {dx = 0, dy = 0,},
		},
	},
	mapX = 1630+256, --�ڷ�����ڵ�ͼ�ϵ�����X
	mapY = 690, --�ڷ�����ڵ�ͼ�ϵ�����Y
	mapFacing = 90, --�ڷ�����ڵ�ͼ�ϵ�����Ƕ�
}

--��3�� ����
_tab_chapter[3] =
{
	background = "misc/button_null",
	map = "town/select_map1",
	icon = "icon/xlobj/zerg04.png",
	scrollW = 2768,
	scrollH = 2768,
	firstmap = "world/yxys_zerg_001", --��һ��
	lastmap = "world/yxys_zerg_004", --���һ��
	endlessMap = {},
	camera = --��ͷ����
	{
		--Ĭ�Ͼ�ͷλ��
		[1] =
		{
			["mapName"] = 0,
			["pad"] = {dx = 0, dy = 0,},
			["phone"] = {dx = 0, dy = 0,},
		},
	},
	mapX = 1830+256, --�ڷ�����ڵ�ͼ�ϵ�����X
	mapY = 500, --�ڷ�����ڵ�ͼ�ϵ�����Y
	mapFacing = 90, --�ڷ�����ڵ�ͼ�ϵ�����Ƕ�
}

--��4�� �������۾�
_tab_chapter[4] =
{
	background = "misc/button_null",
	map = "town/select_map1",
	icon = "icon/xlobj/bio01.png",
	scrollW = 2768,
	scrollH = 2768,
	firstmap = "world/yxys_bio_001", --��һ��
	lastmap = "world/yxys_bio_004", --���һ��
	endlessMap = {},
	camera = --��ͷ����
	{
		--Ĭ�Ͼ�ͷλ��
		[1] =
		{
			["mapName"] = 0,
			["pad"] = {dx = 0, dy = 0,},
			["phone"] = {dx = 0, dy = 0,},
		},
	},
	mapX = 2090+256, --�ڷ�����ڵ�ͼ�ϵ�����X
	mapY = 460, --�ڷ�����ڵ�ͼ�ϵ�����Y
	mapFacing = 90, --�ڷ�����ڵ�ͼ�ϵ�����Ƕ�
}

--��5�� ��е�ɴ�
_tab_chapter[5] =
{
	background = "misc/button_null",
	map = "town/select_map1",
	icon = "icon/xlobj/mechanics04.png",
	scrollW = 2768,
	scrollH = 2768,
	firstmap = "world/yxys_mechanics_001", --��һ��
	lastmap = "world/yxys_mechanics_004", --���һ��
	endlessMap = {},
	camera = --��ͷ����
	{
		--Ĭ�Ͼ�ͷλ��
		[1] =
		{
			["mapName"] = 0,
			["pad"] = {dx = 0, dy = 0,},
			["phone"] = {dx = 0, dy = 0,},
		},
	},
	mapX = 2030+256, --�ڷ�����ڵ�ͼ�ϵ�����X
	mapY = 650, --�ڷ�����ڵ�ͼ�ϵ�����Y
	mapFacing = 0, --�ڷ�����ڵ�ͼ�ϵ�����Ƕ�
}

--��6�� �ɵ�
_tab_chapter[6] =
{
	background = "misc/button_null",
	map = "town/select_map1",
	icon = "icon/xlobj/plate04.png",
	scrollW = 2768,
	scrollH = 2768,
	firstmap = "world/yxys_plate_01", --��һ��
	lastmap = "world/yxys_plate_04", --���һ��
	endlessMap = {},
	camera = --��ͷ����
	{
		--Ĭ�Ͼ�ͷλ��
		[1] =
		{
			["mapName"] = 0,
			["pad"] = {dx = 0, dy = 0,},
			["phone"] = {dx = 0, dy = 0,},
		},
	},
	mapX = 2020+256, --�ڷ�����ڵ�ͼ�ϵ�����X
	mapY = 850, --�ڷ�����ڵ�ͼ�ϵ�����Y
	mapFacing = 270, --�ڷ�����ڵ�ͼ�ϵ�����Ƕ�
}

--[[
--��7�� �ȴ�
_tab_chapter[6] =
{
	background = "misc/button_null",
	map = "town/select_map1",
	icon = "icon/xlobj/plate04.png",
	scrollW = 2768,
	scrollH = 2768,
	firstmap = "world/yxys_yoda_01", --��һ��
	lastmap = "world/yxys_yoda_02", --���һ��
	endlessMap = {},
	camera = --��ͷ����
	{
		--Ĭ�Ͼ�ͷλ��
		[1] =
		{
			["mapName"] = 0,
			["pad"] = {dx = 0, dy = 0,},
			["phone"] = {dx = 0, dy = 0,},
		},
	},
	mapX = 3492, --�ڷ�����ڵ�ͼ�ϵ�����X
	mapY = 3228, --�ڷ�����ڵ�ͼ�ϵ�����Y
	mapFacing = 90, --�ڷ�����ڵ�ͼ�ϵ�����Ƕ�
}
]]

--��7�� ����
_tab_chapter[7] =
{
	background = "misc/button_null",
	map = "town/select_map1",
	icon = "icon/xlobj/plate04.png",
	scrollW = 2768,
	scrollH = 2768,
	firstmap = "world/yxys_walle_001", --��һ��
	lastmap = "world/yxys_walle_004", --���һ��
	endlessMap = {},
	camera = --��ͷ����
	{
		--Ĭ�Ͼ�ͷλ��
		[1] =
		{
			["mapName"] = 0,
			["pad"] = {dx = 0, dy = 0,},
			["phone"] = {dx = 0, dy = 0,},
		},
	},
	mapX = 3492, --�ڷ�����ڵ�ͼ�ϵ�����X
	mapY = 3228, --�ڷ�����ڵ�ͼ�ϵ�����Y
	mapFacing = 90, --�ڷ�����ڵ�ͼ�ϵ�����Ƕ�
}

--��8�� �ȴ�
_tab_chapter[8] =
{
	background = "misc/button_null",
	map = "town/select_map1",
	icon = "icon/xlobj/plate04.png",
	scrollW = 2768,
	scrollH = 2768,
	firstmap = "world/yxys_yoda_01", --��һ��
	lastmap = "world/yxys_yoda_04", --���һ��
	endlessMap = {},
	camera = --��ͷ����
	{
		--Ĭ�Ͼ�ͷλ��
		[1] =
		{
			["mapName"] = 0,
			["pad"] = {dx = 0, dy = 0,},
			["phone"] = {dx = 0, dy = 0,},
		},
	},
	mapX = 3492, --�ڷ�����ڵ�ͼ�ϵ�����X
	mapY = 3228, --�ڷ�����ڵ�ͼ�ϵ�����Y
	mapFacing = 90, --�ڷ�����ڵ�ͼ�ϵ�����Ƕ�
}



















--��99�� ����vip
_tab_chapter[99] =
{
	background = "town/tback_blackdragon_nest",
	map = "town/blackdragon_nest",
	scrollW = 2768,
	scrollH = 2768,
	firstmap = "world/csys_001", --��һ��
	lastmap = "world/csys_006", --���һ��
	endlessMap = {},
	camera = --��ͷ����
	{
		--Ĭ�Ͼ�ͷλ��
		[1] =
		{
			["mapName"] = 0,
			["pad"] = {dx = 0, dy = 0,},
			["phone"] = {dx = 0, dy = 0,},
		},
		
		--ͨ��"����ƽ�"��ľ�ͷλ��
		[2] =
		{
			["mapName"] = "world/td_009_jmhj",
			["pad"] = {dx = 0, dy = 0,},
			["phone"] = {dx = 0, dy = 0,},
		},
	},
}

