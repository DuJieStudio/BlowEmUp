hVar.tab_shop = {}
local _tab_shop = hVar.tab_shop

--shop_type
--NORMAL = 0,--��ͨ�̵꣺goods���ǹ̶���Ʒ�б��ж����·�����
--AUTO_REFRESH = 1,--�Զ�ˢ���̵�goods����Ʒ�أ���Ҫ���

--DB�̳Ƿ�ҳ
_tab_shop[1] = {
	
	type = 1,				--����(�Զ�ˢ���̵�)
	
	goodsNumMax = 6,			--ÿ�����ˢ��3����Ʒ��Ŀǰ���֧��6����
	quota = 3,				--ÿ����Ʒ�޹�����(����)
	refreshTime = "23:59:59",		--ÿ��̶�ʱ��ˢ��
	rmbRefreshCount = 8,			--ÿ����ý��ˢ��n��
	goods = {
		--�ͻ��˲���Ҫ������
		--[[
		totalValue = 135,					--��Ȩֵ���̶���Ʒ�б����ͨ�̵��������壩
		{value = 7,	shopItemId = 351, quota = 2},		--value ������ƷȨֵ, shopItemId ��Ʒid --���10507
		{value = 7,	shopItemId = 352, quota = 2},		--value ������ƷȨֵ, shopItemId ��Ʒid --������10509
		{value = 7,	shopItemId = 353, quota = 2},		--value ������ƷȨֵ, shopItemId ��Ʒid --����10512
		{value = 7,	shopItemId = 354, quota = 2},		--value ������ƷȨֵ, shopItemId ��Ʒid --��ʿ10504
		{value = 7,	shopItemId = 355, quota = 2},		--value ������ƷȨֵ, shopItemId ��Ʒid --�Ա���10505
		{value = 7,	shopItemId = 356, quota = 2},		--value ������ƷȨֵ, shopItemId ��Ʒid --����10506
		{value = 7,	shopItemId = 357, quota = 2},		--value ������ƷȨֵ, shopItemId ��Ʒid --��������10508
		{value = 7,	shopItemId = 358, quota = 2},		--value ������ƷȨֵ, shopItemId ��Ʒid --������ʿ10513
		{value = 7,	shopItemId = 359, quota = 2},		--value ������ƷȨֵ, shopItemId ��Ʒid --����10514
		{value = 7,	shopItemId = 360, quota = 2},		--value ������ƷȨֵ, shopItemId ��Ʒid --������ʿ10515
		{value = 7,	shopItemId = 361, quota = 2},		--value ������ƷȨֵ, shopItemId ��Ʒid --����10517
		{value = 7,	shopItemId = 362, quota = 2},		--value ������ƷȨֵ, shopItemId ��Ʒid --���޼�10518
		{value = 3,	shopItemId = 363, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --Ӣ�۽��� ����10201
		{value = 3,	shopItemId = 364, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --Ӣ�۽��� ����10202
		{value = 3,	shopItemId = 365, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --Ӣ�۽��� �ŷ�10203
		{value = 3,	shopItemId = 366, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --Ӣ�۽��� ����10208
		{value = 3,	shopItemId = 367, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --Ӣ�۽��� �ܲ�10205
		{value = 3,	shopItemId = 368, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --Ӣ�۽��� �ĺ10210
		{value = 3,	shopItemId = 369, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --Ӣ�۽��� ����10207
		{value = 3,	shopItemId = 370, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --Ӣ�۽��� ̫ʷ��10206
		--{value = 3,	shopItemId = 371, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --Ӣ�۽��� ����10217
		{value = 3,	shopItemId = 372, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --Ӣ�۽��� ����10211
		{value = 3,	shopItemId = 373, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --Ӣ�۽��� ����10212
		{value = 3,	shopItemId = 375, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --Ӣ�۽��� ����10214
		{value = 3,	shopItemId = 376, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --Ӣ�۽��� ����10215
		{value = 3,	shopItemId = 377, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --Ӣ�۽��� ��Τ10216
		{value = 3,	shopItemId = 374, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --Ӣ�۽��� ���10218
		{value = 3,	shopItemId = 378, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --Ӣ�۽��� ���10219
		{value = 3,	shopItemId = 379, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --Ӣ�۽��� ����10220
		{value = 3,	shopItemId = 380, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --Ӣ�۽��� �����10221
		--{value = 3,	shopItemId = 381, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --Ӣ�۽��� С��10222
		]]
		
	},
}

--��ͨ�����̵�
_tab_shop[2] = {
	
	type = 0,				--����(��ͨ�̵�)
	
	goods = {
		345,				--��װ����
	},
}