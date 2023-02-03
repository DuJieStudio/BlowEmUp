hVar.tab_army = {}

local _tab_army = hVar.tab_army

_tab_army[1] = {
	level = 8,
	quality = 1,				--星星颜色，每进化一次相当于此值+1
	--unlock = {0,{lv=0,elo=0}},		--解锁/升级条件，达到此条件才允许解锁
	--unlock_coin = 0,			--解锁所需金币
	unit = {10000,0,0,10002},
	num = {10,0,0,0,0,0,0,450},
	
}

--------------------------------
--策马三国志-免费兵种 101~300
--------------------------------
--朴刀兵(lv1)/刀盾兵(lv4)
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