hVar.tab_army = {}

local _tab_army = hVar.tab_army

_tab_army[1] = {
	level = 8,
	quality = 1,				--������ɫ��ÿ����һ���൱�ڴ�ֵ+1
	--unlock = {0,{lv=0,elo=0}},		--����/�����������ﵽ����������������
	--unlock_coin = 0,			--����������
	unit = {10000,0,0,10002},
	num = {10,0,0,0,0,0,0,450},
	
}

--------------------------------
--��������־-��ѱ��� 101~300
--------------------------------
--�ӵ���(lv1)/���ܱ�(lv4)
_tab_army[101] = {
	level = 5,
	cost_pec = 20,
	quality = 1,
	unlock = {0,{lv=1},{lv=2},{lv=3},{lv=4}},
	unit = {10002},
	num = {100,0,0,0,180},
	attr = {
		0,{move=1},{atk=1},{atk=1},{hp=3},
	},
}