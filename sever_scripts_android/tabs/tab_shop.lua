hVar.tab_shop = {}
local _tab_shop = hVar.tab_shop

--shop_type
--NORMAL = 0,--��ͨ�̵꣺goods���ǹ̶���Ʒ�б��ж����·�����
--AUTO_REFRESH = 1,--�Զ�ˢ���̵�goods����Ʒ�أ���Ҫ���

--DB�̳Ƿ�ҳ
_tab_shop[1] = {
	
	type = 1,				--����(�Զ�ˢ���̵�)
	
	goodsNumMax = 6,			--ÿ�����ˢ��3����Ʒ��Ŀǰ���֧��8����
	quota = 3,				--ÿ����Ʒ�޹�����(����)
	refreshTime = "23:59:59",		--ÿ��̶�ʱ��ˢ��
	rmbRefreshCount = 8,			--ÿ����ý��ˢ��n��
	goods = {
		
		--ֻ������ǹ��Ƭ
		[1] =
		{
			rollCount = 2, --����ص������
			totalValue = 0+40+20,					--��Ȩֵ���̶���Ʒ�б����ͨ�̵��������壩
			
			--[[
			{value = 10,	shopItemId = 449, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --����ǹ��Ƭ ��ͨ��ǹ��Ƭ
			{value = 10,	shopItemId = 450, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --����ǹ��Ƭ ɢ��ǹ��Ƭ
			{value = 10,	shopItemId = 451, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --����ǹ��Ƭ ����ǹ��Ƭ
			{value = 10,	shopItemId = 452, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --����ǹ��Ƭ ����ǹ��Ƭ
			{value = 10,	shopItemId = 453, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --����ǹ��Ƭ ����ǹ��Ƭ
			{value = 10,	shopItemId = 454, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --����ǹ��Ƭ ����ǹ��Ƭ
			{value = 10,	shopItemId = 455, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --����ǹ��Ƭ ��Һǹ��Ƭ
			{value = 10,	shopItemId = 456, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --����ǹ��Ƭ ��Сǹ��Ƭ
			{value = 10,	shopItemId = 457, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --����ǹ��Ƭ ����ǹ��Ƭ
			{value = 10,	shopItemId = 458, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --����ǹ��Ƭ ���ǹ��Ƭ
			{value = 10,	shopItemId = 459, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --����ǹ��Ƭ ���ǹ��Ƭ
			{value = 10,	shopItemId = 460, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --����ǹ��Ƭ ����ǹ��Ƭ
			]]
			
			{value = 4,	shopItemId = 492, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --����ǹ��Ƭ ��ͨ��ǹ��Ƭ*10
			{value = 4,	shopItemId = 493, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --����ǹ��Ƭ ɢ��ǹ��Ƭ*10
			{value = 4,	shopItemId = 494, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --����ǹ��Ƭ ����ǹ��Ƭ*10
			{value = 4,	shopItemId = 495, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --����ǹ��Ƭ ����ǹ��Ƭ*10
			{value = 4,	shopItemId = 496, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --����ǹ��Ƭ ����ǹ��Ƭ*10
			{value = 4,	shopItemId = 497, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --����ǹ��Ƭ ����ǹ��Ƭ*10
			{value = 4,	shopItemId = 498, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --����ǹ��Ƭ ��Һǹ��Ƭ*10
			{value = 4,	shopItemId = 499, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --����ǹ��Ƭ ��Сǹ��Ƭ*10
			{value = 4,	shopItemId = 500, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --����ǹ��Ƭ ����ǹ��Ƭ*10
			{value = 4,	shopItemId = 501, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --����ǹ��Ƭ ���ǹ��Ƭ*10
			--{value = 4,	shopItemId = 502, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --����ǹ��Ƭ ���ǹ��Ƭ*10
			--{value = 4,	shopItemId = 503, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --����ǹ��Ƭ ����ǹ��Ƭ*10
			
			{value = 2,	shopItemId = 522, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --����ǹ��Ƭ ��ͨ��ǹ��Ƭ*50
			{value = 2,	shopItemId = 523, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --����ǹ��Ƭ ɢ��ǹ��Ƭ*50
			{value = 2,	shopItemId = 524, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --����ǹ��Ƭ ����ǹ��Ƭ*50
			{value = 2,	shopItemId = 525, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --����ǹ��Ƭ ����ǹ��Ƭ*50
			{value = 2,	shopItemId = 526, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --����ǹ��Ƭ ����ǹ��Ƭ*50
			{value = 2,	shopItemId = 527, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --����ǹ��Ƭ ����ǹ��Ƭ*50
			{value = 2,	shopItemId = 528, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --����ǹ��Ƭ ��Һǹ��Ƭ*50
			{value = 2,	shopItemId = 529, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --����ǹ��Ƭ ��Сǹ��Ƭ*50
			{value = 2,	shopItemId = 530, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --����ǹ��Ƭ ����ǹ��Ƭ*50
			{value = 2,	shopItemId = 531, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --����ǹ��Ƭ ���ǹ��Ƭ*50
			--{value = 2,	shopItemId = 532, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --����ǹ��Ƭ ���ǹ��Ƭ*50
			--{value = 2,	shopItemId = 533, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --����ǹ��Ƭ ����ǹ��Ƭ*50
			
			--vipר���̵���Ʒ
			vipShop =
			{
				--vip5�̳�
				[5] =
				{
					totalValue = 6,	--��Ȩֵ
					{value = 4,	shopItemId = 651, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --����ǹ��Ƭ ��ͨ��ǹ��Ƭ*10
					{value = 2,	shopItemId = 652, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --����ǹ��Ƭ ��ͨ��ǹ��Ƭ*50
				},
			}
		},
		
		--������Ƭ
		[2] =
		{
			rollCount = 1, --����ص������
			totalValue = 0+16+8,					--��Ȩֵ���̶���Ʒ�б����ͨ�̵��������壩
			
			--[[
			{value = 10,	shopItemId = 461, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --������Ƭ ����������Ƭ
			{value = 10,	shopItemId = 462, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --������Ƭ �ȴ������Ƭ
			{value = 10,	shopItemId = 463, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --������Ƭ ֧Ԯս��������Ƭ
			{value = 10,	shopItemId = 464, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --������Ƭ ���߱���������Ƭ
			]]
			
			{value = 4,	shopItemId = 504, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --������Ƭ ����������Ƭ*10
			{value = 4,	shopItemId = 505, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --������Ƭ �ȴ������Ƭ*10
			{value = 4,	shopItemId = 506, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --������Ƭ ֧Ԯս��������Ƭ*10
			{value = 4,	shopItemId = 508, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --������Ƭ ���߱���������Ƭ*10
			
			{value = 2,	shopItemId = 534, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --������Ƭ ����������Ƭ*50
			{value = 2,	shopItemId = 535, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --������Ƭ �ȴ������Ƭ*50
			{value = 2,	shopItemId = 536, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --������Ƭ ֧Ԯս��������Ƭ*50
			{value = 2,	shopItemId = 537, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --������Ƭ ���߱���������Ƭ*50
		},
		
		--ս������Ƭ
		[3] =
		{
			rollCount = 3, --����ص������
			totalValue = 0+52+26,					--��Ȩֵ���̶���Ʒ�б����ͨ�̵��������壩
			
			--[[
			{value = 10,	shopItemId = 465, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --ս������Ƭ �˱���Ƭ
			{value = 10,	shopItemId = 466, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --ս������Ƭ �ٻ���ǹ����Ƭ
			{value = 10,	shopItemId = 467, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --ս������Ƭ �ٻ���������Ƭ
			{value = 10,	shopItemId = 468, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --ս������Ƭ ׷�ٵ�����Ƭ
			{value = 10,	shopItemId = 469, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --ս������Ƭ ������Ƭ
			{value = 10,	shopItemId = 470, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --ս������Ƭ ʮ��ը����Ƭ
			{value = 10,	shopItemId = 471, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --ս������Ƭ ��������Ƭ
			{value = 10,	shopItemId = 472, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --ս������Ƭ ��С��Ƭ
			{value = 10,	shopItemId = 473, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --ս������Ƭ ��ʱը����Ƭ
			{value = 10,	shopItemId = 474, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --ս������Ƭ ������Ƭ
			{value = 10,	shopItemId = 475, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --ս������Ƭ ��������Ƭ
			{value = 10,	shopItemId = 476, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --ս������Ƭ �ڶ���Ƭ
			{value = 10,	shopItemId = 477, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --ս������Ƭ ������Ƭ
			]]
			
			{value = 4,	shopItemId = 509, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --ս������Ƭ �˱���Ƭ*10
			{value = 4,	shopItemId = 510, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --ս������Ƭ �ٻ���ǹ����Ƭ*10
			{value = 4,	shopItemId = 511, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --ս������Ƭ �ٻ���������Ƭ*10
			{value = 4,	shopItemId = 512, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --ս������Ƭ ׷�ٵ�����Ƭ*10
			{value = 4,	shopItemId = 513, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --ս������Ƭ ������Ƭ*10
			{value = 4,	shopItemId = 514, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --ս������Ƭ ʮ��ը����Ƭ*10
			{value = 4,	shopItemId = 515, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --ս������Ƭ ��������Ƭ*10
			{value = 4,	shopItemId = 516, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --ս������Ƭ ��С��Ƭ*10
			{value = 4,	shopItemId = 517, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --ս������Ƭ ��ʱը����Ƭ*10
			{value = 4,	shopItemId = 518, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --ս������Ƭ ������Ƭ*10
			{value = 4,	shopItemId = 519, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --ս������Ƭ ��������Ƭ*10
			{value = 4,	shopItemId = 520, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --ս������Ƭ �ڶ���Ƭ*10
			{value = 4,	shopItemId = 521, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --ս������Ƭ ������Ƭ*10
			
			{value = 2,	shopItemId = 538, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --ս������Ƭ �˱���Ƭ*50
			{value = 2,	shopItemId = 539, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --ս������Ƭ �ٻ���ǹ����Ƭ*50
			{value = 2,	shopItemId = 540, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --ս������Ƭ �ٻ���������Ƭ*50
			{value = 2,	shopItemId = 541, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --ս������Ƭ ׷�ٵ�����Ƭ*50
			{value = 2,	shopItemId = 542, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --ս������Ƭ ������Ƭ*50
			{value = 2,	shopItemId = 543, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --ս������Ƭ ʮ��ը����Ƭ*50
			{value = 2,	shopItemId = 544, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --ս������Ƭ ��������Ƭ*50
			{value = 2,	shopItemId = 545, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --ս������Ƭ ��С��Ƭ*50
			{value = 2,	shopItemId = 546, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --ս������Ƭ ��ʱը����Ƭ*50
			{value = 2,	shopItemId = 547, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --ս������Ƭ ������Ƭ*50
			{value = 2,	shopItemId = 548, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --ս������Ƭ ��������Ƭ*50
			{value = 2,	shopItemId = 549, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --ս������Ƭ �ڶ���Ƭ*50
			{value = 2,	shopItemId = 550, quota = 1},		--value ������ƷȨֵ, shopItemId ��Ʒid --ս������Ƭ ������Ƭ*50
		},
	},
}

--��ͨ�����̵�
_tab_shop[2] = {
	
	type = 0,				--����(��ͨ�̵�)
	
	goods = {
		345,				--��װ����
		410,				--�һ�������ʯ
		430,				--��װ����*5
		431,				--�һ�������ʯ*5
		438,				--��װ����
		439,				--��װ����*5
		
		--���̵������Ʒ
		441,				--���������һ��
		442,				--���������ʮ��
		443,				--ս������һ��
		444,				--ս������ʮ��
		445,				--����������ѳ�һ��
		446,				--����������ѳ�ʮ��
		447,				--ս������ѳ�һ��
		448,				--ս������ѳ�ʮ��
		
		498,				--�һ�������ʯ*10
		499,				--�һ�������ʯ*50
	},
}

--�ر�ͼ�̵�
_tab_shop[3] = {
	
	type = 23,				--����(�ر�ͼ�̵�)
	
	goods = {
		412,				--�ر�ͼ��һ��
	},
}

--�߼��ر�ͼ�̵�
_tab_shop[4] = {
	
	type = 24,				--����(�߼��ر�ͼ�̵�)
	
	goods = {
		413,				--�߼��ر�ͼ��һ��
	},
}
