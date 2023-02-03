hVar.tab_chest = {}

local _tab_chest = hVar.tab_chest

--���ڽ���չʾ����
hVar.tab_chestEx =
{
	1,2,3,4,5,
}


--����ǹ����
_tab_chest[1] = {
	name = "����ǹ����",
	icon = "misc/chest/chest_01.png",
	width = 274,
	height = 230,
	quality = hVar.ITEM_QUALITY.WHITE, --Ʒ��
	itemType = hVar.ITEM_TYPE.CHEST_WEAPON_GUN,
	shopItemId = 398, --��Ʒid
}

--ս������
_tab_chest[2] = {
	name = "ս������",
	icon = "misc/chest/chest_02.png",
	width = 274,
	height = 230,
	quality = hVar.ITEM_QUALITY.WHITE, --Ʒ��
	itemType = hVar.ITEM_TYPE.CHEST_TACTIC,
	shopItemId = 399, --��Ʒid
}

--���ﱦ��
_tab_chest[3] = {
	name = "���ﱦ��",
	icon = "misc/chest/chest_03.png",
	width = 274,
	height = 230,
	quality = hVar.ITEM_QUALITY.WHITE, --Ʒ��
	itemType = hVar.ITEM_TYPE.CHEST_PET,
	shopItemId = 400, --��Ʒid
}

--װ������
_tab_chest[4] = {
	name = "װ������",
	icon = "misc/chest/chest_04.png",
	width = 274,
	height = 230,
	quality = hVar.ITEM_QUALITY.WHITE, --Ʒ��
	itemType = hVar.ITEM_TYPE.CHEST_EQUIP,
	shopItemId = 401, --��Ʒid
}

--��������
_tab_chest[5] = {
	name = "��������",
	icon = "misc/chest/chest_05.png",
	width = 274,
	height = 230,
	quality = hVar.ITEM_QUALITY.WHITE, --Ʒ��
	itemType = hVar.ITEM_TYPE.CHEST_REDEQUIP,
	shopItemId = 402, --��Ʒid
}



------------------------------------------------------------------------------------------------------------------------------------------
--��ѽ���
_tab_chest[9913] = 
{
	openCost = 0,					--�򿪽�����Ҫgamecoin
	openDelay = 0,					--��ñ�����ÿ��Դ�(��λ����)
	reward = {
		{"Gold_Free",1,1,1},			--{����,��С����,������,�ֶ���(��2��)(�ֶ���ֱ�ӱ����Ƭ���������Ϊ�ֶ���*���������)}
		{"Amy_Nommal",5,10,2},			--{����,��С����,������,�ֶ���(��2��)(�ֶ���ֱ�ӱ����Ƭ���������Ϊ�ֶ���*���������)}
		{"Amy_Rare",1,3,1},			--{����,��С����,������,�ֶ���(��2��)(�ֶ���ֱ�ӱ����Ƭ���������Ϊ�ֶ���*���������)}
		{"Hero_Free",0,1,1},			--{����,��С����,������,�ֶ���(��2��)(�ֶ���ֱ�ӱ����Ƭ���������Ϊ�ֶ���*���������)}
	},
}

--ս������
_tab_chest[9914] = 
{
	openCost = 18,					--�򿪽�����Ҫgamecoin
	openDelay = 180,				--��ñ�����ÿ��Դ�(��λ����)
	reward = {
		{"Gold_Small",1,1,1},			--{����,��С����,������,�ֶ���(��2��)(�ֶ���ֱ�ӱ����Ƭ���������Ϊ�ֶ���*���������)}
		{"Amy_Nommal",12,15,2},			--{����,��С����,������,�ֶ���(��2��)(�ֶ���ֱ�ӱ����Ƭ���������Ϊ�ֶ���*���������)}
		{"Amy_Rare",1,3,1},			--{����,��С����,������,�ֶ���(��2��)(�ֶ���ֱ�ӱ����Ƭ���������Ϊ�ֶ���*���������)}
		--{"Hero_Free",1,1,1},			--{����,��С����,������,�ֶ���(��2��)(�ֶ���ֱ�ӱ����Ƭ���������Ϊ�ֶ���*���������)}
		{"Hero_Normal",0,2,1},			--{����,��С����,������,�ֶ���(��2��)(�ֶ���ֱ�ӱ����Ƭ���������Ϊ�ֶ���*���������)}
		{"Ruby_001",1,1,1},			--{����,��С����,������,�ֶ���(��2��)(�ֶ���ֱ�ӱ����Ƭ���������Ϊ�ֶ���*���������)}
	},
}

--������
_tab_chest[9915] = 
{
	openCost = 48,					--�򿪽�����Ҫgamecoin
	openDelay = 480,				--��ñ�����ÿ��Դ�(��λ����)
	reward = {
		{"Gold_Big",1,1,1},			--{����,��С����,������,�ֶ���(��2��)(�ֶ���ֱ�ӱ����Ƭ���������Ϊ�ֶ���*���������)}
		{"Amy_Nommal",36,45,3},			--{����,��С����,������,�ֶ���(��2��)(�ֶ���ֱ�ӱ����Ƭ���������Ϊ�ֶ���*���������)}
		{"Amy_Rare",4,8,2},			--{����,��С����,������,�ֶ���(��2��)(�ֶ���ֱ�ӱ����Ƭ���������Ϊ�ֶ���*���������)}
		{"Hero_Normal",1,4,1},			--{����,��С����,������,�ֶ���(��2��)(�ֶ���ֱ�ӱ����Ƭ���������Ϊ�ֶ���*���������)}
		{"Ruby_002",1,1,1},			--{����,��С����,������,�ֶ���(��2��)(�ֶ���ֱ�ӱ����Ƭ���������Ϊ�ֶ���*���������)}
	},
}

--��̨����
_tab_chest[9916] = 
{
	openCost = 0,					--�򿪽�����Ҫgamecoin
	openDelay = 0,					--��ñ�����ÿ��Դ�(��λ����)
	reward = {
		{"Gold_Free",1,1,1},			--{����,��С����,������,�ֶ���(��2��)(�ֶ���ֱ�ӱ����Ƭ���������Ϊ�ֶ���*���������)}
		{"Amy_Nommal",5,10,2},			--{����,��С����,������,�ֶ���(��2��)(�ֶ���ֱ�ӱ����Ƭ���������Ϊ�ֶ���*���������)}
		{"Amy_Rare",1,3,1},			--{����,��С����,������,�ֶ���(��2��)(�ֶ���ֱ�ӱ����Ƭ���������Ϊ�ֶ���*���������)}
		{"Hero_Normal",0,1,1},			--{����,��С����,������,�ֶ���(��2��)(�ֶ���ֱ�ӱ����Ƭ���������Ϊ�ֶ���*���������)}
		{"Ruby_001",1,1,1},			--{����,��С����,������,�ֶ���(��2��)(�ֶ���ֱ�ӱ����Ƭ���������Ϊ�ֶ���*���������)}
	},
}

--��װ����
_tab_chest[9917] = 
{
	openCost = 30,					--�򿪽�����Ҫgamecoin
	openDelay = 0,					--��ñ�����ÿ��Դ�(��λ����)
	openCostCrystals = 100,				--�򿪽�����Ҫ���Ķ���������ʯ
	--��װ����(ÿ������أ����ض�����е�����㡣ÿ��)
	rewardEx = {
		--�����
		[1] = {
			tag = "Equip",	--���׼���ʱ��Ҫʹ�ø�ֵ��ʶ���ڴ����װ
			mustDrop = {"Equip_Red",1}, --���ױض�����Ľ���
			rollCount = 1, --����ص������
			--������ӳ�����
			pool = {
				totalValue = 100,
				{value = 38, reward = {"Equip_Blue",1}},
				{value = 55, reward = {"Equip_Yellow",1}},
				{value = 7, reward = {"Equip_Red",1}},
			},
		},
		--�����2
		[2] = {
			tag = "Other",
			rollCount = 2, 
			pool = {
				totalValue = 100,
				{value = 60, reward = {"Score_Free",1}},
				{value = 10, reward = {"Amy_Nommal",3}},
				{value = 10, reward = {"Amy_Nommal",5}},
				{value = 10, reward = {"Hero_Free",1}},
				{value = 10, reward = {"Hero_Free",2}},
			},
		},
	},
}

--������������
_tab_chest[9919] = 
{
	openCost = 0,					--�򿪽�����Ҫgamecoin
	openDelay = 0,					--��ñ�����ÿ��Դ�(��λ����)
	openCostCrystals = 0,				--�򿪽�����Ҫ���Ķ���������ʯ
	
	--��װ����(ÿ������أ����ض�����е�����㡣ÿ��)
	rewardEx = {
		--�����
		[1] = {
			tag = "Equip",	--���׼���ʱ��Ҫʹ�ø�ֵ��ʶ���ڴ����װ
			mustDrop = {"Equip_Red",1}, --���ױض�����Ľ���
			rollCount = 1, --����ص������
			--������ӳ�����
			pool = {
				totalValue = 100,
				{value = 100, reward = {"Equip_Red",1}},
			},
		},
		
		--�����2
		[2] = {
			tag = "Other",
			rollCount = 2, 
			pool = {
				totalValue = 100,
				{value = 60, reward = {"Score_Free",1}},
				{value = 10, reward = {"Amy_Nommal",3}},
				{value = 10, reward = {"Amy_Nommal",5}},
				{value = 10, reward = {"Hero_Free",1}},
				{value = 10, reward = {"Hero_Free",2}},
			},
		},
	},
}

--����ǹ����
_tab_chest[9920] = 
{
	openCost = 0,					--�򿪽�����Ҫgamecoin
	openDelay = 0,					--��ñ�����ÿ��Դ�(��λ����)
	openCostCrystals = 0,				--�򿪽�����Ҫ���Ķ���������ʯ
	
	--��װ����(ÿ������أ����ض�����е�����㡣ÿ��)
	rewardEx = {
		--�����1
		[1] = {
			tag = "Other",
			rollCount = 1, 
			pool = {
				totalValue = 100,
				{value = 50, reward = {"Weapon_Normal",1,1}},
				{value = 30, reward = {"Weapon_Normal",2,2}},
				{value = 20, reward = {"Weapon_Normal",5,5}},
			},
		},
		
		--�����2
		[2] = {
			tag = "Other",
			rollCount = 1, 
			pool = {
				totalValue = 100,
				{value = 50, reward = {"Weapon_Normal",1,1}},
				{value = 30, reward = {"Weapon_Normal",2,2}},
				{value = 20, reward = {"Weapon_Normal",5,5}},
			},
		},
		
		--�����3
		[3] = {
			tag = "Other",
			rollCount = 1, 
			pool = {
				totalValue = 100,
				{value = 50, reward = {"Weapon_Normal",0,0}},
				{value = 25, reward = {"Weapon_Normal",1,1}},
				{value = 15, reward = {"Weapon_Normal",2,2}},
				{value = 10, reward = {"Weapon_Normal",5,5}},
			},
		},
	},
}

--ս��������
_tab_chest[9921] = 
{
	openCost = 0,					--�򿪽�����Ҫgamecoin
	openDelay = 0,					--��ñ�����ÿ��Դ�(��λ����)
	openCostCrystals = 0,				--�򿪽�����Ҫ���Ķ���������ʯ
	
	--��װ����(ÿ������أ����ض�����е�����㡣ÿ��)
	rewardEx = {
		--�����1
		[1] = {
			tag = "Other",
			rollCount = 1, 
			pool = {
				totalValue = 100,
				{value = 50, reward = {"Tactic_Normal",2,2}},
				{value = 30, reward = {"Tactic_Normal",5,5}},
				{value = 20, reward = {"Tactic_Normal",10,10}},
			},
		},
		
		--�����2
		[2] = {
			tag = "Other",
			rollCount = 1, 
			pool = {
				totalValue = 100,
				{value = 50, reward = {"Tactic_Normal",2,2}},
				{value = 30, reward = {"Tactic_Normal",5,5}},
				{value = 20, reward = {"Tactic_Normal",10,10}},
			},
		},
		
		--�����3
		[3] = {
			tag = "Other",
			rollCount = 1, 
			pool = {
				totalValue = 100,
				{value = 50, reward = {"Tactic_Normal",0,0}},
				{value = 25, reward = {"Tactic_Normal",2,2}},
				{value = 15, reward = {"Tactic_Normal",5,5}},
				{value = 10, reward = {"Tactic_Normal",10,10}},
			},
		},
		
	},
}

--�������
_tab_chest[9922] = 
{
	openCost = 0,					--�򿪽�����Ҫgamecoin
	openDelay = 0,					--��ñ�����ÿ��Դ�(��λ����)
	openCostCrystals = 0,				--�򿪽�����Ҫ���Ķ���������ʯ
	
	--��װ����(ÿ������أ����ض�����е�����㡣ÿ��)
	rewardEx = {
		--�����1
		[1] = {
			tag = "Other",
			rollCount = 1, 
			pool = {
				totalValue = 100,
				{value = 50, reward = {"Pet_Normal",1,1}},
				{value = 30, reward = {"Pet_Normal",2,2}},
				{value = 20, reward = {"Pet_Normal",5,5}},
			},
		},
		
		--�����2
		[2] = {
			tag = "Other",
			rollCount = 1, 
			pool = {
				totalValue = 100,
				{value = 50, reward = {"Pet_Normal",1,1}},
				{value = 30, reward = {"Pet_Normal",2,2}},
				{value = 20, reward = {"Pet_Normal",5,5}},
			},
		},
		
		--�����3
		[3] = {
			tag = "Other",
			rollCount = 1, 
			pool = {
				totalValue = 100,
				{value = 50, reward = {"Pet_Normal",0,0}},
				{value = 25, reward = {"Pet_Normal",1,1}},
				{value = 15, reward = {"Pet_Normal",2,2}},
				{value = 10, reward = {"Pet_Normal",5,5}},
			},
		},
	},
}

--װ������
_tab_chest[9923] = 
{
	openCost = 0,					--�򿪽�����Ҫgamecoin
	openDelay = 0,					--��ñ�����ÿ��Դ�(��λ����)
	openCostCrystals = 0,				--�򿪽�����Ҫ���Ķ���������ʯ
	
	--��װ����(ÿ������أ����ض�����е�����㡣ÿ��)
	rewardEx = {
		--�����1
		[1] = {
			tag = "Other",
			rollCount = 1, 
			pool = {
				totalValue = 100,
				{value = 45, reward = {"Equip_Normal",1,1}},
				{value = 33, reward = {"Equip_Normal2",1,1}},
				{value = 21, reward = {"Equip_Normal3",1,1}},
				{value = 1, reward = {"Equip_High",1,1}},
			},
		},
		
	},
}

--��������
_tab_chest[9925] = 
{
	openCost = 0,					--�򿪽�����Ҫgamecoin
	openDelay = 0,					--��ñ�����ÿ��Դ�(��λ����)
	openCostCrystals = 0,				--�򿪽�����Ҫ���Ķ���������ʯ
	
	--��װ����(ÿ������أ����ض�����е�����㡣ÿ��)
	rewardEx = {
		--�����1
		[1] = {
			tag = "Other",
			rollCount = 1, 
			pool = {
				totalValue = 100,
				{value = 62, reward = {"Equip_Normal2",1,1}},
				{value = 36, reward = {"Equip_Normal3",1,1}},
				{value = 2, reward = {"Equip_High",1,1}},
			},
		},
		--�����2
		[2] = {
			tag = "Other",
			rollCount = 1, 
			pool = {
				totalValue = 100,
				{value = 50, reward = {"Weapon_Normal",1,1}},
				{value = 30, reward = {"Weapon_Normal",2,2}},
				{value = 20, reward = {"Weapon_Normal",5,5}},
			},
		},
		--�����3
		[3] = {
			tag = "Other",
			rollCount = 1, 
			pool = {
				totalValue = 100,
				{value = 50, reward = {"Weapon_Normal",0,0}},
				{value = 25, reward = {"Weapon_Normal",1,1}},
				{value = 15, reward = {"Weapon_Normal",2,2}},
				{value = 10, reward = {"Weapon_Normal",5,5}},
			},
		},
		
	},
}

--�����ڿ���
_tab_chest[9926] =
{
	openCost = 0,					--�򿪽�����Ҫgamecoin
	openDelay = 0,					--��ñ�����ÿ��Դ�(��λ����)
	openCostCrystals = 0,				--�򿪽�����Ҫ���Ķ���������ʯ
	
	--��װ����(ÿ������أ����ض�����е�����㡣ÿ��)
	rewardEx = {
		--�����1
		[1] = {
			tag = "Other",
			rollCount = 1, 
			pool = {
				totalValue = 100,
				{value = 20, reward = {"Weapon_Normal",1,1}},
				{value = 20, reward = {"Tactic_Normal",1,1}},
				{value = 20, reward = {"Pet_Normal",1,1}},
				{value = 20, reward = {"Chip_Wakuang",1,1}},
				{value = 5, reward = {"Weapon_Normal",2,2}},
				{value = 5, reward = {"Tactic_Normal",2,2}},
				{value = 5, reward = {"Pet_Normal",2,2}},
				{value = 5, reward = {"Chip_Wakuang",2,2}},
				
			},
		},
	},
}
