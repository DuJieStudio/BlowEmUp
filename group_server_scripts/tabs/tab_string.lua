hVar.tab_string = {}
hVar.tab_stringA = {}	--活动
hVar.tab_stringQ = {}	--任务
hVar.tab_stringR = {}	--房间配置
setmetatable(hVar.tab_string,{
	__index = function(t,k)
		return tostring(k)
	end,
})
local _tab_string = hVar.tab_string
local _tab_stringA = hVar.tab_stringA
local _tab_stringQ = hVar.tab_stringQ
local _tab_stringR = hVar.tab_stringR

--------------------------------
--活动
--------------------------------
--_tab_stringA[1] = {
--	"act:{$《策马三国志》竞技场火热开放中！}:2;",
--}

--------------------------------
--任务（老）
--------------------------------

_tab_stringQ[1] = {"洗炼入门","洗炼道具 5 次"}
_tab_stringQ[2] = {"洗炼能手","洗炼道具 10 次"}
_tab_stringQ[3] = {"洗炼精通","洗炼道具 15 次"}

_tab_stringQ[4] = {"合成入门","合成道具 5 次"}
_tab_stringQ[5] = {"合成能手","合成道具 10 次"}
_tab_stringQ[6] = {"合成精通","合成道具 15 次"}

_tab_stringQ[7] = {"破敌","消灭 1000 个敌人"}
_tab_stringQ[8] = {"弱敌","完美通过 3 次挑战模式"}
_tab_stringQ[9] = {"乱敌","消灭 5 个主将"}

_tab_stringQ[10] = {"摸金校尉","开 50 个宝箱"}
_tab_stringQ[11] = {"幸运儿","抽 6 张卡"}
_tab_stringQ[12] = {"巧匠","装备打孔 3 次"}

_tab_stringQ[13] = {"剧毒塔","建造毒塔 30 次"}
_tab_stringQ[14] = {"巨炮塔","建造巨炮塔 20 次"}
_tab_stringQ[15] = {"火焰塔","建造火塔 25 次"}

_tab_stringQ[16] = {"测试任务","测试任务"}




_tab_stringQ[17] = {"摸金校尉","开 10 个宝箱"}
_tab_stringQ[18] = {"发丘将军","开 30 个宝箱"}

_tab_stringQ[19] = {"百炼成钢","洗炼装备 10 次"}
_tab_stringQ[20] = {"千锤百炼","洗炼装备 30 次"}

_tab_stringQ[21] = {"能工","合成装备 5 次"}
_tab_stringQ[22] = {"巧匠","合成装备 15 次"}

_tab_stringQ[23] = {"点石成金","为装备打孔 1 次"}




_tab_stringQ[24] = {"青龙乱舞","使用关羽的青龙乱舞技能消灭 100 个敌人"}

_tab_stringQ[25] = {"张飞投军","只使用张飞, 不使用其他英雄, 通关 英雄现世"}
_tab_stringQ[26] = {"大兴山II","只选择连弩塔, 不选择其他塔, 通关 大兴山"}
_tab_stringQ[27] = {"屠狼勇士","消灭祸斗, 并且没有英雄阵亡"}
_tab_stringQ[28] = {"桃园英雄","只使用刘关张, 并且不选择任何高级塔通关 桃园结义"}
_tab_stringQ[29] = {"孟德起兵","只使用曹操, 不使用其他英雄, 通关 陈留起兵"}


_tab_stringQ[30] = {"自救青州","不使用任何英雄, 通关 救援青州"}
_tab_stringQ[31] = {"火烧颖川","只使用火焰塔, 不选择其他塔, 通关 颖川之战"}
_tab_stringQ[32] = {"怒斩华雄","只使用关羽, 不使用其他英雄, 通关 汜水之战"}
_tab_stringQ[33] = {"双雄灭董","只使用刘备和曹操, 不使用其他英雄, 通关 董卓之殇"}
_tab_stringQ[34] = {"全身而退","通关将计就计, 并且没有英雄阵亡"}


_tab_stringQ[35] = {"赏月论英雄", "消灭 10 个主将"}
_tab_stringQ[36] = {"月明星稀", "3星通关 3 次任意关卡 难度3"}
_tab_stringQ[37] = {"阖家吃月饼", "在无尽模式获得 1000 分"}




_tab_stringQ[38] = {"国庆喜唰唰", "洗炼装备 20 次"}
_tab_stringQ[39] = {"国庆小挑战", "在无尽挑战获得 3000 分"}
_tab_stringQ[40] = {"国庆乐陶陶", "为装备打孔 1 次"}
_tab_stringQ[41] = {"国庆美滋滋", "3星通关 3 次任意关卡 难度3"}
_tab_stringQ[42] = {"国庆笑嘻嘻", "消灭 10 个主将"}
_tab_stringQ[43] = {"国庆买买买", "商店购买神器宝箱 1 次"}
_tab_stringQ[44] = {"国庆红彤彤", "累计消灭 1000 个敌人"}
_tab_stringQ[45] = {"国庆嘿咻咻", "累计在关卡内进行 30 次塔的升级"}
_tab_stringQ[46] = {"国庆金灿灿", "商店限时商品 刷新 1 次"}

_tab_stringQ[47] = {"双11勇破敌", "累计消灭 1111 个敌人"}
_tab_stringQ[48] = {"双11勤洗练", "洗炼装备 111 次"}
_tab_stringQ[49] = {"双11战无尽", "闯关 无尽挑战 在结束时达到 11111 分"}

_tab_stringQ[50] = {"春节勇破敌", "累计消灭 2022 个敌人"}
_tab_stringQ[51] = {"春节勤洗练", "洗炼装备 122 次"}
_tab_stringQ[52] = {"春节战无尽", "闯关 无尽挑战 在结束时达到 12022 分"}

--[[
_tab_stringQ[1] = {"击杀敌人","击杀100敌人"}
_tab_stringQ[2] = {"击杀主将","击杀10个主将"}
_tab_stringQ[3] = {"充值","充值100元"}
_tab_stringQ[4] = {"宝箱","累计开10个宝箱"}
_tab_stringQ[5] = {"英雄技能","升级英雄技能3次"}
_tab_stringQ[6] = {"合成道具","合成道具3次"}
_tab_stringQ[7] = {"洗炼道具","洗炼道具3次"}
_tab_stringQ[8] = {"打孔道具","打孔道具3次"}
_tab_stringQ[9] = {"升级卡牌","累计升级卡牌3次"}
_tab_stringQ[10] = {"抽卡","抽10张卡"}
--]]
--------------------------------------------------
--任务（新）
--------------------------------------------------
--=====================================================
--【通用好任务,奖励金币,神器晶石】  100-299
--=====================================================
_tab_stringQ[100] = {"摸金校尉","开 10 个青铜宝箱"}
_tab_stringQ[101] = {"百炼成钢","洗炼装备 10 次"}
_tab_stringQ[102] = {"巧匠","合成装备 10 次"}
_tab_stringQ[103] = {"点石成金","解锁装备孔 1 次"}
_tab_stringQ[104] = {"百炼成钢II","洗炼装备 20 次"}
_tab_stringQ[105] = {"点石成金II","解锁装备孔 2 次"}
_tab_stringQ[106] = {"挥金如土","消耗 1000 积分"}
_tab_stringQ[107] = {"神兵出世","商店购买神器宝箱 1 次"}
_tab_stringQ[108] = {"喜新厌旧","商店限时商品 刷新 1 次"}
_tab_stringQ[109] = {"挥金如土II","消耗 3000 积分"}
_tab_stringQ[110] = {"无尽使命","闯关 无尽挑战 在结束时达到 3000 分"}
_tab_stringQ[111] = {"无尽使命II","闯关 无尽挑战 在结束时达到 6000 分"}
--=====================================================
--【普通任务】（只奖励积分,普通卡包,铜宝箱）  300-499
--=====================================================
_tab_stringQ[300] = {"破敌","累计消灭 500 个敌人"}
_tab_stringQ[301] = {"弱敌","以三星评价通关任意关卡挑战难度 2 次"}
_tab_stringQ[302] = {"乱敌","累计消灭 3 个主将"}
_tab_stringQ[303] = {"剧毒塔","建造剧毒塔 20 次"}
_tab_stringQ[304] = {"巨炮塔","建造巨炮塔 10 次"}
_tab_stringQ[305] = {"火焰塔","建造火焰塔 15 次"}
_tab_stringQ[306] = {"连弩塔","建造连弩塔 15 次"}
_tab_stringQ[307] = {"轰天塔","建造轰天塔 10 次"}
_tab_stringQ[308] = {"寒冰塔","建造寒冰塔 15 次"}
_tab_stringQ[309] = {"天雷塔","建造天雷塔 12 次"}
_tab_stringQ[310] = {"狙击塔","建造狙击塔 15 次"}
_tab_stringQ[311] = {"滚石塔","建造滚石塔 10 次"}
_tab_stringQ[312] = {"粮仓","建造粮仓 15 次"}
_tab_stringQ[313] = {"地刺塔","建造地刺塔 20 次"}
_tab_stringQ[314] = {"擂鼓塔","建造擂鼓塔 15 次"}
_tab_stringQ[315] = {"升级科技","累计在关卡内进行 25 次塔的升级"}
_tab_stringQ[316] = {"黄巾之乱","通关第一章任意关卡 2 次"}
_tab_stringQ[317] = {"群雄逐鹿","通关第二章任意关卡 2 次"}
_tab_stringQ[318] = {"乱世枭雄","通关第三章任意关卡 2 次"}
_tab_stringQ[319] = {"官渡之战","通关第四章任意关卡 2 次"}
_tab_stringQ[320] = {"称霸江东","通关第五章任意关卡 1 次"}
_tab_stringQ[321] = {"赤壁之战","通关第六章任意关卡 1 次"}
_tab_stringQ[322] = {"称霸江东II","通关第五章任意关卡挑战3难度 1 次"}
_tab_stringQ[323] = {"赤壁之战II","通关第六章任意关卡挑战3难度 1 次"}

--=====================================================
---【通关类】（全部可填,尽量少填游戏币）   500-699
--=====================================================
_tab_stringQ[500] = {"张飞投军","通关 英雄现世 并且只使用张飞, 不使用其他英雄"}
_tab_stringQ[501] = {"大兴山"," 通关 大兴山 并且只选择连弩塔, 不选择其他塔"}
_tab_stringQ[502] = {"屠狼勇士","通关 扫除狼患 消灭祸斗, 并且没有英雄阵亡"}
_tab_stringQ[503] = {"桃园英雄","通关 桃园结义 只使用刘关张, 并且不选择任何高级塔"}
_tab_stringQ[504] = {"孟德起兵","通关 陈留起兵 并且只使用曹操, 不使用其他英雄,"}


_tab_stringQ[505] = {"自救青州","通关 救援青州 并且不使用任何英雄"}
_tab_stringQ[506] = {"火烧颖川","通关 颖川之战 并且只使用火焰塔, 不携带其他塔"}
_tab_stringQ[507] = {"怒斩华雄"," 通关 汜水之战 并且只使用关羽, 不使用其他英雄"}
_tab_stringQ[508] = {"双雄灭董","通关 董卓之殇 并且只使用刘备和曹操, 不使用其他英雄"}
_tab_stringQ[509] = {"全身而退","通关 将计就计, 并且没有英雄阵亡"}

_tab_stringQ[510] = {"大败袁术","通关 讨伐袁术, 并且英雄不能死亡超过2次"}
_tab_stringQ[511] = {"古城聚义","通关 古城之战, 并且英雄不能死亡超过2次"}
_tab_stringQ[512] = {"生死边缘","通关 绝处逢生, 并且英雄不能死亡超过2次"}

_tab_stringQ[513] = {"固守坚城","通关 守卫许都,并且不能使用:妙手回春"}
_tab_stringQ[514] = {"固守坚城II","通关 守卫许都 ( 挑战难度 1 ) 并且不能使用 妙手回春"}

_tab_stringQ[515] = {"决战时刻","通关 仓亭之战,并且不能使用 妙手回春"}
_tab_stringQ[516] = {"决战时刻II","通关 仓亭之战 ( 挑战难度 1 ) 并且不能使用 妙手回春"}
_tab_stringQ[517] = {"决战时刻III","通关 仓亭之战 ( 挑战难度 2 ) 并且不能使用 妙手回春"}

_tab_stringQ[518] = {"守卫官渡","通关 守卫官渡,并且不能使用 术塔精通"}
_tab_stringQ[519] = {"守卫官渡II","通关 守卫官渡 ( 挑战难度 1 ) 并且不能使用 术塔精通,炮塔精通"}
_tab_stringQ[520] = {"守卫官渡III","通关 守卫官渡 ( 挑战难度 2 ) 并且不能使用 炮塔精通 箭塔精通"}

_tab_stringQ[521] = {"决战官渡","通关 决战官渡,并且不能使用 妙手回春"}
_tab_stringQ[522] = {"决战官渡II","通关 决战官渡 ( 挑战难度 1 ),并且不能使用 妙手回春 乱敌"}
_tab_stringQ[523] = {"决战官渡III","通关 决战官渡 ( 挑战难度 2 )"}

_tab_stringQ[524] = {"神亭之战","通关 神亭之战,并且不能使用:妙手回春"}
_tab_stringQ[525] = {"神亭之战II","通关 神亭之战 ( 挑战难度 1 ) 并且不能使用 妙手回春 固若金汤"}
_tab_stringQ[526] = {"神亭之战III","通关 神亭之战 ( 挑战难度 2 )"}

_tab_stringQ[527] = {"临江水战","通关 临江水战,并且不能使用:破敌"}
_tab_stringQ[528] = {"临江水战II","通关 临江水战 ( 挑战难度 1 ) 并且不能使用 破敌 乱敌"}
_tab_stringQ[529] = {"临江水战III","通关 临江水战 ( 挑战难度 2 ) 并且不能使用 破敌 乱敌 弱敌"}

_tab_stringQ[530] = {"困兽之斗","通关 狩猎 并且不能使用:寒冰塔"}
_tab_stringQ[531] = {"困兽之斗II","通关 狩猎 ( 挑战难度 1 ) 并且不能使用 寒冰塔 乱敌 "}
_tab_stringQ[532] = {"困兽之斗III","通关 狩猎 ( 挑战难度 2 )"}

_tab_stringQ[533] = {"智破八门","通关 智破八门,并且不能使用:妙手回春"}
_tab_stringQ[534] = {"智破八门II","通关 智破八门 ( 挑战难度 1 ) 并且不能使用 妙手回春 固若金汤"}
_tab_stringQ[535] = {"智破八门III","通关 智破八门 ( 挑战难度 2 )"}

_tab_stringQ[536] = {"借东风","通关 借东风,并且不能使用 妙手回春"}
_tab_stringQ[537] = {"借东风II","通关 借东风 ( 挑战难度 1 ) 并且不能使用 妙手回春 固若金汤"}
_tab_stringQ[538] = {"借东风III","通关 借东风 ( 挑战难度 2 )"}

_tab_stringQ[539] = {"草船借箭","通关 草船借箭,并且不能使用 箭塔精通"}
_tab_stringQ[540] = {"草船借箭II","通关 草船借箭 ( 挑战难度 1 )"}
_tab_stringQ[541] = {"草船借箭III","通关 草船借箭 ( 挑战难度 2 )"}

_tab_stringQ[542] = {"火烧博望","通关 火烧博望,并且不能使用:寒冰塔"}
_tab_stringQ[543] = {"火烧博望II","通关 火烧博望 (  挑战难度 1  ) 并且不能使用 滚石塔"}
_tab_stringQ[544] = {"火烧博望III","通关 火烧博望 ( 挑战难度 2 )"}

_tab_stringQ[545] = {"赤壁之战","通关 赤壁之战 并且不能使用 固若金汤"}
_tab_stringQ[546] = {"赤壁之战II","通关 赤壁之战 ( 挑战难度 1 ) 并且不能使用 妙手回春"}
_tab_stringQ[547] = {"赤壁之战III","通关 赤壁之战 ( 挑战难度 2 ) "}

_tab_stringQ[548] = {"决战黄祖","通关 决战黄祖并且不能使用 寒冰塔"}
_tab_stringQ[549] = {"决战黄祖II","通关 决战黄祖 ( 挑战难度 1 ) 并且不能使用 固若金汤"}
_tab_stringQ[550] = {"决战黄祖III","通关 决战黄祖 ( 挑战难度 2 )"}
--挑战
_tab_stringQ[551] = {"火烧博望IV","通关 火烧博望 ( 挑战难度 3 ) 并且不能使用 妙手回春 滚石塔"}
_tab_stringQ[552] = {"借东风IV","通关 借东风 ( 挑战难度 3 )"}

--------------------------------
--字符串
--------------------------------
_tab_string["__TEXT_DAILY_VIP1"] = "尊贵的VIP1用户，请领取今日奖励"
_tab_string["__TEXT_DAILY_VIP2"] = "尊贵的VIP2用户，请领取今日奖励"
_tab_string["__TEXT_DAILY_VIP3"] = "尊贵的VIP3用户，请领取今日奖励"
_tab_string["__TEXT_DAILY_VIP4"] = "尊贵的VIP4用户，请领取今日奖励"
_tab_string["__TEXT_DAILY_VIP5"] = "尊贵的VIP5用户，请领取今日奖励"
_tab_string["__TEXT_DAILY_VIP6"] = "尊贵的VIP6用户，请领取今日奖励"
_tab_string["__TEXT_DAILY_VIP7"] = "尊贵的VIP7用户，请领取今日奖励"
_tab_string["__TEXT_DAILY_VIP8"] = "尊贵的VIP8用户，请领取今日奖励"

_tab_string["__TEXT_WX_TOPUP1"] = "充值6元额外奖励;"
_tab_string["__TEXT_WX_TOPUP2"] = "充值18元额外奖励;"
_tab_string["__TEXT_WX_TOPUP3"] = "充值30元额外奖励;"
_tab_string["__TEXT_WX_TOPUP4"] = "充值68元额外奖励;"
_tab_string["__TEXT_WX_TOPUP5"] = "充值98元额外奖励;"
_tab_string["__TEXT_WX_TOPUP6"] = "充值198元额外奖励;"
_tab_string["__TEXT_WX_TOPUP7"] = "充值388元额外奖励;"

_tab_string["__TEXT_MONTHCARD_TOPUP_TITLE"] = "感谢您充值月卡;"
_tab_string["__TEXT_MONTHCARD_TOPUP_CONTENT"] = "尊敬的月卡玩家，感谢您对游戏的喜爱和支持，请领取您的月卡奖励。;"
_tab_string["__TEXT_MONTHCARD_TOPUP_PRIZE"] = "7:300:0:0;"

_tab_string["__TEXT_MONTHCARD_PRIZE_TITLE"] = "今日月卡奖励;"
_tab_string["__TEXT_MONTHCARD_PRIZE_CONTENT"] = "尊敬的月卡玩家，您的月卡有效期还剩%d天。请领取今日月卡奖励。;"
_tab_string["__TEXT_MONTHCARD_PRIZE_PRIZE"] = "7:30:0:0;"

_tab_string["__TEXT_REWARD_REDEQUIP"] = "获得红装神器"
_tab_string["__TEXT_ENDLESS_RANKBOARD"] = "每日排行地图奖励"
_tab_string["__TEXT_MAIL_REWARD"] = "邮件奖励"
_tab_string["__TEXT_MAIL_DALIYREWARD"] = "每日领奖"
_tab_string["__TEXT_MAIL_NEWPLAYERREWARD"] = "新人礼包奖励"
_tab_string["__TEXT_MAIL_SUPPORTGAMEREWARD"] = "支持游戏奖励"
_tab_string["__TEXT_MAIL_RECOMMNDREWARD"] = "填写推荐人奖励"
_tab_string["__TEXT_MAIL_PURCHASECRITALREWARD"] = "充值暴击奖励"
_tab_string["__TEXT_PURCHASE_REWARD"] = "充值%d元档"
_tab_string["__TEXT_GIFT_REWARD"] = "礼包奖励"
_tab_string["__TEXT_SLOT_XILIAN"] = "锁孔洗炼"
_tab_string["__TEXT_SLOT4_MOUNT"] = "4孔坐骑"
_tab_string["__TEXT_MERGE_SLOT3"] = "献祭3孔红装"

_tab_string["__TEXT_REWARDTYPE_MAIL"] = "邮件直接领取"
_tab_string["__TEXT_REWARDTYPE_ENDLESSRANKBOARD"] = "邮件无尽排名奖励"
_tab_string["__TEXT_REWARDTYPE_PVEMULTYWORK"] = "邮件魔龙宝库勤劳奖励"
_tab_string["__TEXT_REWARDTYPE_MAILREAD"] = "邮件标题正文领取"
_tab_string["__TEXT_REWARDTYPE_SEVENDAYPAY"] = "七日充值活动奖励"
_tab_string["__TEXT_REWARDTYPE_SINGINREWARD"] = "签到活动获得"
_tab_string["__TEXT_REWARDTYPE_SINGINDRAW"] = "签到活动抽到"
_tab_string["__TEXT_REWARDTYPE_TURNTABLE"] = "转盘活动抽到"
_tab_string["__TEXT_REWARDTYPE_REDSCROLL"] = "红装兑换券选择"
_tab_string["__TEXT_REWARDTYPE_MAILDRAWCARD"] = "邮件n选1领取"
_tab_string["__TEXT_REWARDTYPE_MAILCHEST"] = "邮件锦囊抽到"
_tab_string["__TEXT_REWARDTYPE_REDCHEST"] = "神器锦囊抽到"
_tab_string["__TEXT_REWARDTYPE_REDDEBRIS"] = "神器晶石兑换"
_tab_string["__TEXT_REWARDTYPE_GROUPCHEST"] = "军团宝箱抽到"
_tab_string["__TEXT_REWARDTYPE_MERGE"] = "合成"
_tab_string["__TEXT_REWARDTYPE_PURCHASE198"] = "首充198元奖励"
_tab_string["__TEXT_REWARDTYPE_PURCHASE388"] = "首充388元奖励"
_tab_string["__TEXT_REWARDTYPE_TRANFSORM"] = "老装备转换"
_tab_string["__TEXT_REWARDTYPE_CANGBAOTU"] = "藏宝图抽到"
_tab_string["__TEXT_REWARDTYPE_CANGBAOTU_HIGH"] = "高级藏宝图抽到"
_tab_string["__TEXT_REWARDTYPE_QUNYINGGEREWARD"] = "通关群英阁获得"
_tab_string["__TEXT_REWARDTYPE_TURNCHOUJIANG"] = "夺宝活动抽到"
_tab_string["__TEXT_REWARDTYPE_PVPSHOP"] = "夺塔奇兵积分商城抽到"
_tab_string["__TEXT_REWARDTYPE_CHATDRAGON"] = "邮件聊天龙王奖励"
_tab_string["__TEXT_REWARDTYPE_GROUPMULTYWORK"] = "邮件军团秘境试炼勤劳奖励"
_tab_string["__TEXT_REWARDTYPE_MAILBATTLESUCCESS_MLBK"] = "邮件通关魔龙宝库抽到"
_tab_string["__TEXT_REWARDTYPE_MAILBATTLESUCCESS_JTMJSL"] = "邮件通关军团秘境试炼抽到"

_tab_string["__TEXT_REWARDTYPE_TREASURE_STAR1"] = "宝物升1星"
_tab_string["__TEXT_REWARDTYPE_TREASURE_STAR2"] = "宝物升2星"
_tab_string["__TEXT_REWARDTYPE_TREASURE_STAR3"] = "宝物升3星"
_tab_string["__TEXT_REWARDTYPE_TREASURE_STAR4"] = "宝物升4星"
_tab_string["__TEXT_REWARDTYPE_TREASURE_STAR5"] = "宝物升5星"

_tab_string["__TEXT_QUNYINGGE_PRIZE"] = "五一活动-今日首通群英阁奖励战术卡包*3;15:9973:3:0;"
_tab_string["__TEXT_TODISGUSS_PRIZE"] = "今日前往【游戏讨论】奖励;11:10:0:0;"
_tab_string["__TEXT_GMTOOL_PRIZE"] = "GM奖励-%s;%d:%d:%d:%d;"
_tab_string["__TEXT_ADVVIEW_PRIZE"] = "看广告奖励;%d:%d:%d:%d;"
_tab_string["__TEXT_GIFT_REWARD"] = "礼包奖励"
_tab_string["__TEXT_RUCHANGQUAN"] = "入场券"
_tab_string["__TEXT_REVIVE_HERO"] = "英雄立即复活"
_tab_string["__TEXT_DUOTAQIBING_SENDARMY"] = "夺塔奇兵发兵"
_tab_string["__TEXT_QUNYINGGE"] = "群英阁"
_tab_string["__TEXT_TASK_REWARD_YESTERDAY"] = "昨日任务奖励;尊敬的玩家，您昨日有部分已完成的任务忘记领取，现已为您补发邮件。;%s"
_tab_string["__TEXT_TASK_REWARD_YESTERDAY_DRAWCARD"] = "昨日任务奖励-%s;%s"
_tab_string["__TEXT_TASK_REWARD_DRAWCARD"] = "任务奖励-%s;%s"
_tab_string["__TEXT_PVPSHOP_BUYITEM"] = "兑换战功商城道具-%s;"
_tab_string["__TEXT_STARUP_STAR_ERROR"] = "升星数据不一致;%d:%d;%d;"
_tab_string["__TEXT_BUYITEM_REWARD"] = "恭喜您获得新英雄;4:%d:1:1;"



--------------------------------
--PVP服务器 房间配置
--------------------------------
_tab_stringR[1] = {"夺塔奇兵", ""}
_tab_stringR[2] = {"魔龙宝库", ""}
_tab_stringR[3] = {"铜雀台", ""}
_tab_stringR[4] = {"夺塔奇兵自动匹配", ""}
_tab_stringR[10] = {"人族无敌", ""}
_tab_stringR[11] = {"魔塔杀阵", ""}
_tab_stringR[12] = {"守卫剑阁", ""}
_tab_stringR[13] = {"双人守卫剑阁", ""}
_tab_stringR[14] = {"仙之侠道", ""}
_tab_stringR[15] = {"决战虚鲲", ""}





--------------------------------
--PVP服务器 字符串
--------------------------------
_tab_string["__ERR__NotEnoughCoin"] = "游戏币不足"
_tab_string["__ERR__PaymentFail"] = "购买失败"
_tab_string["__TEXT__PVPCoin"] = "兵符"
_tab_string["__TEXT_SHU"] = "蜀国"
_tab_string["__TEXT_WEI"] = "魏国"
_tab_string["__TEXT_WU"] = "吴国"
_tab_string["__TEXT_CLOSE"] = "关闭"
_tab_string["__TEXT_BLANK"] = "等待其它玩家"
_tab_string["__TEXT_PLAYER"] = "玩家"
_tab_string["__TEXT_EASY_COMPUTER"] = "简单电脑"
_tab_string["__TEXT_NORMAL_COMPUTER"] = "中等电脑"
_tab_string["__TEXT_DIFFICULT_COMPUTER"] = "困难电脑"
_tab_string["__TEXT_EXPERTS_COMPUTER"] = "变态电脑"
_tab_string["__TEXT_PROFESSIONAL_COMPUTER"] = "专家电脑"

_tab_string["__TEXT_ARENA_EX_SCORE"] = "您已获得竞技场今日活跃奖励：排行榜积分＋3"
_tab_string["__TEXT_PVE_DOUBLEREWARD"] = "再领一次"
_tab_string["__TEXT_PVE_MULTI_REWARD"] = "魔龙宝库通关奖励"
_tab_string["__TEXT_PVE_MULTI_REWARD2"] = "铜雀台通关奖励"
_tab_string["__TEXT_PVE_MULTI_REWARD5"] = "铁副本通关奖励"
_tab_string["__TEXT_PVE_MULTI_REWARD6"] = "木材副本通关奖励"
_tab_string["__TEXT_PVE_MULTI_REWARD7"] = "粮食副本通关奖励"
_tab_string["__TEXT_PVE_MULTI_REWARD8"] = "秘境试炼通关奖励"
_tab_string["__TEXT_PVE_MULTI_REWARD9"] = "秘境试炼通关奖励"
_tab_string["__TEXT_PVE_MULTI_REWARD_ITEM"] = "魔龙宝库夺宝赏金奖励"
_tab_string["__TEXT_PVE_MULTI_REWARD10"] = "人族无敌通关奖励"
_tab_string["__TEXT_PVE_MULTI_REWARD11"] = "魔塔杀阵通关奖励"
_tab_string["__TEXT_PVE_MULTI_REWARD12"] = "守卫剑阁通关奖励"
_tab_string["__TEXT_PVE_MULTI_REWARD13"] = "双人守卫剑阁通关奖励"
_tab_string["__TEXT_PVE_MULTI_REWARD14"] = "仙之侠道通关奖励"
_tab_string["__TEXT_PVE_MULTI_REWARD15"] = "决战虚鲲通关奖励"

_tab_string["__TEXT_OUTSYNC_REWARD"] = "游戏发生不同步补偿5游戏币;7:5:0:0;"
_tab_string["__TEXT_PVEMULTY_REWARD_TITLE"] = "魔龙宝库每日勤劳奖"
_tab_string["__TEXT_CHATDRAGON_REWARD_TITLE"] = "今日聊天龙王奖"
_tab_string["__TEXT_GROUPMULTY_REWARD_TITLE"] = "军团秘境试炼每日勤劳奖"
_tab_string["__TEXT_PVEMULTY_REWARD"] = "7:10:0:0;1:1000:0:0;"
_tab_string["__TEXT_CHATDRAGON_REWARD"] = "7:10:0:0;25:10:0:0;"
_tab_string["__TEXT_GROUPMULTY_REWARD"] = "7:10:0:0;1:1000:0:0;"
_tab_string["__TEXT_PVPCOINREWARD"] = "竞技场锦囊掉落"
_tab_string["__TEXT_ARENACOINBACK"] = "擂台赛游戏币退还"
_tab_string["__TEXT_PVPRANKUPGRATE_REWARD"] = "%d;夺塔奇兵升至段位【%s】奖励;尊敬的玩家，恭喜您升至段位【%s】，以下为您的升段奖励。;"
_tab_string["__TEXT_PVPRANKMAX_REWARD"] = "%d;夺塔奇兵%d月赛季奖励;尊敬的玩家，在夺塔奇兵%d月赛季，您的最高段位为【%s】，恭喜您获得以下奖励。;"
_tab_string["__TEXT_PVPRANKUPGRATE_REWARD_SEASON"] = "%d;夺塔奇兵新赛季段位【%s】奖励;尊敬的玩家，在新赛季您将从段位【%s】开始比赛，以下为您的升段奖励。;"
_tab_string["__TEXT_PVPRANKSHOP_NOTICE"] = "战功积分未兑换通知;尊敬的玩家，在夺塔奇兵%d月赛季，您有%d点战功积分还未兑换。系统将于中午12:00开赛前自动清零战功积分，未兑换的战功积分将自动兑换成战功锦囊。;"
_tab_string["__TEXT_PVPRANKSHOP_REWARD"] = "夺塔奇兵%d月商城自动兑换;尊敬的玩家，在夺塔奇兵%d月赛季，您有%d点战功积分还未兑换，系统已为您自动兑换了%d个战功锦囊，请查收。;15:9977:%d:0;"
_tab_string["__TEXT_PVPRANKCHAMPION_REWARD"] = "夺塔奇兵%d月赛季称号奖励;尊敬的玩家，恭喜您在夺塔奇兵%d月赛季获得天下无双段位并排名第%d名。\n为表彰您的英勇战绩，系统特颁发【天下无双】称号，称号有效期一个月，期待您新的赛季更加优秀的表现。;"
_tab_string["__TEXT_JZXK_RANK_REWARD_TITLE"] = "决战虚鲲%d月排名奖励;"
_tab_string["__TEXT_JZXK_RANK_REWARD_CONTENT"] = "尊敬的玩家，您在%d月决战虚鲲副本中累计获得%d点神将积分，在所有玩家中排名第%d名！恭喜您获得以下奖励。;"
_tab_string["__TEXT_JZXK_RANK_CHAMPION_REWARD"] = "决战虚鲲%d月排名称号奖励;尊敬的玩家，恭喜您在决战虚鲲副本%d月神将榜中排名第%d名。\n为表彰您的英勇战绩，系统特颁发【绝世神将】称号，称号有效期一个月，期待您新的赛季更加优秀的表现。;"

_tab_string["__TEXT_COUNT"] = "个"
_tab_string["__TEXT_POINT"] = "点"
_tab_string["__TEXT_CARD"] = "卡"
_tab_string["__TEXT_SCORE"] = "积分"
_tab_string["__TEXT_HERO"] = "英雄"
_tab_string["__TEXT_HERODEBRIS"] = "英雄将魂"
_tab_string["__TEXT_TACTICDEBRIS"] = "战术卡碎片"
_tab_string["__TEXT_GAMESCORE"] = "游戏币"
_tab_string["__TEXT_REDEQUIPDEBIRS"] = "神器晶石"
_tab_string["__TEXT_MAT_IRON"] = "铁"
_tab_string["__TEXT_MAT_WOOD"] = "木材"
_tab_string["__TEXT_MAT_FOOD"] = "粮食"
_tab_string["__TEXT_MAT_GROUPCOIN"] = "军团币"




--------------------------------
--军团服务器 字符串
--------------------------------
_tab_string["__TEXT_CHAT_SYSTEM"] = "系统"
_tab_string["__TEXT_CHAT_SYSTEM_NOTICE1"] = "夺塔奇兵已开启，快和好友一决高下吧！"
_tab_string["__TEXT_CHAT_SYSTEM_NOTICE2"] = "魔龙宝库已开启，快和好友组队挑战吧！"
_tab_string["__TEXT_CHAT_SYSTEM_NOTICE3"] = "游戏服务器将于5点进行维护！"
_tab_string["__TEXT_CHAT_SYSTEM_NOTICE4"] = "军团秘境试炼已开启，快和好友组队挑战吧！"
_tab_string["__TEXT_CHAT_SYSTEM_FORBIDDEN"] = "世界频道进入关闭状态，需要游戏攻略的玩家可以前往taptap论坛，遇到账号问题可以加qq群。" --"管理员开启了全员禁言！"
_tab_string["__TEXT_CHAT_SYSTEM_CANCELFORBIDDEN"] = "世界频道已重新开放。" --"管理员取消了全员禁言！"
_tab_string["__TEXT_CHAT_FORBIDDEN"] = "【%s】被禁言%d分钟！"
_tab_string["__TEXT_CHAT_FORBIDDEN_DAY"] = "【%s】被禁言%d天！"
_tab_string["__TEXT_CHAT_PRIVATE_INVITE"] = "【%s】向【%s】发起私聊请求！"
_tab_string["__TEXT_CHAT_PRIVATE_INVITE_OP"] = "【%s】%s了【%s】的私聊请求！"
_tab_string["__TEXT_CHAT_PRIVATE_DELETE"] = "【%s】删除了【%s】！"
_tab_string["__TEXT_CHAT_GROUP_CREATE"] = "【%s】创建了军团！"
_tab_string["__TEXT_CHAT_GROUP_REMOVE"] = "【%s】解散了军团！"
_tab_string["__TEXT_CHAT_GROUP_REMOVE_WORLD"] = "军团【%s】已被会长【%s】解散！"
_tab_string["__TEXT_CHAT_GROUP_REMOVE_ADMIN"] = "会长已超过30天未登录，成员都已走完，系统解散了军团！"
_tab_string["__TEXT_CHAT_GROUP_REMOVE_ADMIN_WORLD"] = "军团【%s】的会长【%s】已超过30天未登录，成员都已走完，系统解散了该军团！"
_tab_string["__TEXT_CHAT_GROUP_CREATE_WORLD"] = "【%s】创建了军团【%s】！"
_tab_string["__TEXT_CHAT_GROUP_ADD_MEMBER"] = "【%s】加入了军团！"
_tab_string["__TEXT_CHAT_GROUP_INBITE_ADD_MEMBER"] = "【%s】通过邀请函加入了军团！"
_tab_string["__TEXT_CHAT_GROUP_REMOVE_MEMBER_ADMIN"] = "【%s】被会长移出了军团！"
_tab_string["__TEXT_CHAT_GROUP_REMOVE_MEMBER_ASSIST"] = "【%s】被助理移出了军团！"
_tab_string["__TEXT_CHAT_GROUP_REMOVE_MEMBER_OFFLINE"] = "【%s】已超过30天未登录被系统移出了军团！"
_tab_string["__TEXT_CHAT_GROUP_ASSET_ADMIN"] = "会长已超过30天未登录，【%s】被系统任命为新的会长！"
_tab_string["__TEXT_CHAT_GROUP_ASSET_ADMIN_WORLD"] = "因会长已超过30天未登录，【%s】被系统任命为军团【%s】新的会长！"
_tab_string["__TEXT_CHAT_GROUP_TRANSFER"] = "会长已将军团转让给助理，【%s】成为新的会长！"
_tab_string["__TEXT_CHAT_GROUP_TRANSFER_WORLD"] = "军团【%s】的会长职务已转让给助理，【%s】成为该军团新的会长！"
_tab_string["__TEXT_CHAT_GROUP_ASSISTANT_MEMBER"] = "【%s】被会长任命为军团助理！"
_tab_string["__TEXT_CHAT_GROUP_ASSISTANT_SYSTEN_MEMBER"] = "【%s】被系统任命为军团助理！"
--_tab_string["__TEXT_CHAT_GROUP_ASSISTANT_SYSTEN_MEMBER_WORLD"] = "【%s】被系统任命为军团【%s】的助理！"
_tab_string["__TEXT_CHAT_GROUP_ASSISTANT_CANCEL_MEMBER"] = "【%s】被会长取消任命军团助理！"
_tab_string["__TEXT_CHAT_GROUP_ASSISTANT_LEAVE_MEMBER"] = "【%s】退出军团被系统取消任命军团助理！"
_tab_string["__TEXT_CHAT_GROUP_ASSISTANT_SYSTEM_CANCEL_MEMBER"] = "【%s】因长期不在线被系统取消任命军团助理！"
--_tab_string["__TEXT_CHAT_GROUP_ASSISTANT_SYSTEN_CANCEL_MEMBER_WORLD"] = "【%s】因长期不在线被系统取消任命军团【%s】的助理！"
_tab_string["__TEXT_CHAT_GROUP_ACTIVITY_TAKE_REWARD"] = "恭喜军团【%s】达成军团活跃任务！全体军团成员获得丰厚奖励！"
_tab_string["__TEXT_CHAT_GROUP_ACTIVITY_TAKE_REWARD_WORLD"] = "恭喜军团【%s】达成军团活跃任务！全体军团成员获得丰厚奖励！"
_tab_string["__TEXT_CHAT_GROUP_SHENGWANGWEEK_DOTAME_MAX"] = "【%s】上周累计获得%d点声望，遥遥领先其它玩家，在全体玩家中排名第一，系统授予其本周声望最高荣誉奖！"
_tab_string["__TEXT_CHAT_GROUP_LEAVE_MEMBER"] = "【%s】离开了军团！"
_tab_string["__TEXT_CHAT_GROUP_MODIFY_NAME"] = "会长将军团名修改为\"%s\"！"
_tab_string["__TEXT_CHAT_GROUP_MODIFY_INTRODUCE_ADMIN"] = "会长修改了军团介绍，快去看看吧！"
_tab_string["__TEXT_CHAT_GROUP_MODIFY_INTRODUCE_ASSIST"] = "助理修改了军团介绍，快去看看吧！"
_tab_string["__TEXT_CHAT_GROUP_BUILDING_LEVELUP"] = "经过大家的不懈努力，军团的%s升至%d级！"
_tab_string["__TEXT_CHAT_GROUP_BUY_BATTLE_COUNT_ADMIN"] = "会长已为军团提振士气，今日军团副本可挑战次数+%d！"
_tab_string["__TEXT_CHAT_GROUP_BUY_BATTLE_COUNT_ASSIST"] = "助理已为军团提振士气，今日军团副本可挑战次数+%d！"
_tab_string["__TEXT_CHAT_GROUP_BUY_BATTLE_COUNT_WORLD"] = "军团【%s】今日已提振士气！"
_tab_string["__TEXT_CHAT_GROUP_SEND_REDPACKET"] = "【%s】发送了一个红包"
_tab_string["__TEXT_CHAT_GROUP_RECEIVE_REDPACKET"] = "【%s】领取了【%s】的红包，获得%s！"
_tab_string["__TEXT_CHAT_GROUP_RECEIVE_EMPTY_REDPACKET"] = "【%s】领取了【%s】的红包，获得%s。该红包已被领完！"
_tab_string["__TEXT_CHAT_GROUP_SHENGWANG_WEEK_DONATE"] = "经过大家的不懈努力，军团上周累计获得%d点声望，在所有军团中排名第%d名！可喜可贺！"
_tab_string["__TEXT_CHAT_PAY_SEND_REDPACKET_PURCHASE388"] = "喜获限量四孔神器%s！"
_tab_string["__TEXT_CHAT_PAY_SEND_REDPACKET_PURCHASE198"] = "喜获限量四孔神器%s！"
_tab_string["__TEXT_CHAT_PAY_SEND_REDPACKET_REDCHEST"] = "抽到四孔%s手气爆棚！"
_tab_string["__TEXT_CHAT_PAY_SEND_REDPACKET_REDDEBRIS"] = "神器晶石兑换四孔%s！"
_tab_string["__TEXT_CHAT_PAY_SEND_REDPACKET_GROUPCHEST"] = "军团宝箱抽到四孔%s！"
_tab_string["__TEXT_CHAT_PAY_SEND_REDPACKET_MAILDRAWCARD"] = "喜获心仪四孔神器%s！"
_tab_string["__TEXT_CHAT_PAY_SEND_REDPACKET_MERGE"] = "献祭四孔%s大功告成！"
_tab_string["__TEXT_CHAT_PAY_SEND_REDPACKET_PVPSHOP"] = "夺塔奇兵商城抽到四孔%s！"
_tab_string["__TEXT_CHAT_PAY_SEND_REDPACKET_MAILBATTLESUCCESS_MLBK"] = "通关魔龙宝库抽到四孔%s！"
_tab_string["__TEXT_CHAT_PAY_SEND_REDPACKET_MAILBATTLESUCCESS_JTMJSL"] = "通关秘境试炼抽到四孔%s！"
_tab_string["__TEXT_CHAT_PAY_SEND_REDPACKET_CANGBAOTU_HIGH"] = "高级藏宝图抽到四孔%s！"
_tab_string["__TEXT_CHAT_PAY_SEND_REDPACKET_TREASURE_STAR1"] = "宝物%s升至1星！"
_tab_string["__TEXT_CHAT_PAY_SEND_REDPACKET_TREASURE_STAR2"] = "宝物%s升至2星！"
_tab_string["__TEXT_CHAT_PAY_SEND_REDPACKET_TREASURE_STAR3"] = "宝物%s升至3星！"
_tab_string["__TEXT_CHAT_PAY_SEND_REDPACKET_TREASURE_STAR4"] = "宝物%s升至4星！"
_tab_string["__TEXT_CHAT_PAY_SEND_REDPACKET_TREASURE_STAR5"] = "宝物%s升至5星！"
_tab_string["__TEXT_CHAT_PAY_REDPACKET_12"] = "  午间红包福利"
_tab_string["__TEXT_CHAT_PAY_REDPACKET_18"] = "  晚间红包福利"
_tab_string["__TEXT_CHAT_PAY_REDPACKET_21"] = "  夜间红包福利"
_tab_string["__TEXT_CHAT_GROUP_INVITE_SEND"] = "军团邀请函"

_tab_string["__TEXT_ACCEPT"] = "接受"
_tab_string["__TEXT_REFUSE"] = "拒绝"
_tab_string["__TEXT_LOGINTIME_ONLINE"] = "在线"
_tab_string["__TEXT_LOGINTIME_SECOND"] = "%d秒前"
_tab_string["__TEXT_LOGINTIME_MINUTE"] = "%d分钟前"
_tab_string["__TEXT_LOGINTIME_HOUR"] = "%d小时前"
_tab_string["__TEXT_LOGINTIME_DAY"] = "%d天前"
_tab_string["__TEXT_GROUP_REDPACKET"] = "领军团红包"
_tab_string["__TEXT_WORLD_REDPACKET"] = "领世界红包"
_tab_string["__TEXT_GROUP_DALIYREWARD_MAIL"] = "军团昨日军饷;尊敬的玩家，您昨日的军团军饷忘记领取，现已补发邮件。下次记得要按时领取哦。;7:%d:0:0;"
_tab_string["__TEXT_GROUP_DALIYREWARD"] = "领取军团军饷;%d"
_tab_string["__TEXT_GROUP_EVENYDAY_REWARD"] = "军团每日资源奖励;尊敬的会长，您的军团【%s】在%s日产出以下资源。;16:%d:0:0;17:%d:0:0;18:%d:0:0;"
_tab_string["__TEXT_GROUP_RANKBOARD_CONTENT"] = "军团排名奖励;尊敬的%s，经过大家的不懈努力，您的军团【%s】上周累计获得%d点声望，在所有军团中排名第%d名，以下是您的奖励。;%s"
_tab_string["__TEXT_GROUP_SHENGWANGWEEK_SINGLE_CONTENT"] = "本周声望最高荣誉奖;尊敬的玩家，您上周累计获得%d点声望，遥遥领先其它玩家，在全体玩家中排名第一。\n为表彰您的卓越成绩，系统特发放以下奖励。;7:100:0:0;1:10000:0:0;20:100:0:0;"
_tab_string["__TEXT_GROUP_AUTHEN_ADMIN"] = "会长"
_tab_string["__TEXT_GROUP_AUTHEN_ASSIST"] = "助理"
_tab_string["__TEXT_GROUP_AUTHEN_MEMBER"] = "成员"
_tab_string["__TEXT_GROUP_BATTLE_REWARD_AUTO"] = "尊敬的玩家，您的军团已提升士气，因您今日已挑战过该副本，系统自动发放副本通关奖励。"
_tab_string["__TEXT_GROUP_BATTLE_BUYCOUNT"] = "士气提升"
_tab_string["__TEXT_GROUP_FREE"] = "免费"
_tab_string["__TEXT_GROUP_MAP_BATTLE_SUCCESS_COUNT"] = "【%s】成功挑战%s，今日累计挑战%d次！"
_tab_string["__TEXT_GROUP_MAP_NAME5"] = "矿洞争夺战"
_tab_string["__TEXT_GROUP_MAP_NAME6"] = "守护伐木场"
_tab_string["__TEXT_GROUP_MAP_NAME7"] = "运粮"
_tab_string["__TEXT_GROUP__MAIL_APPLY_ACCEPT"] = "军团加入通知;尊敬的玩家，您加入军团【%s】的申请已被%s通过。"
_tab_string["__TEXT_GROUP__MAIL_APPLY_INVITE_ACCEPT"] = "军团加入通知;尊敬的玩家，您通过邀请函加入了军团【%s】。"
_tab_string["__TEXT_GROUP__MAIL_APPLY_ACCEPT_SYSTEM"] = "系统军团加入通知;尊敬的玩家，您加入系统军团【%s】的申请已通过。"
_tab_string["__TEXT_GROUP__MAIL_KICK"] = "军团离开通知;尊敬的玩家，您被%s移出了军团【%s】。"
_tab_string["__TEXT_GROUP__MAIL_KICK_OFFLINE"] = "军团离开通知;尊敬的玩家，由于您已超过30天未登录，被系统移出了军团【%s】。"
_tab_string["__TEXT_GROUP__MAIL_DISOLUTE"] = "军团解散通知;尊敬的玩家，您所在的军团【%s】已被会长解散。"
_tab_string["__TEXT_GROUP__MAIL_DISOLUTE_OFFLINE"] = "军团解散通知;尊敬的会长，由于您已超过30天未登录，成员都已走完，军团【%s】已被系统解散。"
_tab_string["__TEXT_GROUP__MAIL_ASSISTANT"] = "军团任命助理通知;尊敬的玩家，您被会长任命为军团【%s】的助理！"
_tab_string["__TEXT_GROUP__MAIL_ASSISTANT_CANCEL"] = "军团取消任命助理通知;尊敬的玩家，您被会长取消任命军团【%s】的助理！"
_tab_string["__TEXT_GROUP__MAIL_ASSISTANT_SYSTEM"] = "军团任命助理通知;尊敬的玩家，由于会长已超过7天未登录，您被系统任命为军团【%s】的助理！"
_tab_string["__TEXT_GROUP__MAIL_ASSISTANT_SYSTEM_CANCEL"] = "军团取消任命助理通知;尊敬的玩家，由于您已超过7天未登录，被系统取消任命军团【%s】的助理！"
_tab_string["__TEXT_GROUP__MAIL_ASSISTANT_TRANSFER"] = "军团转让通知;尊敬的助理，会长已将职务转让给您，您成为军团【%s】新的会长！"
_tab_string["__TEXT_GROUP__MAIL_ASSISTANT_TRANSFER_SYSTEM"] = "军团转让通知;尊敬的助理，由于会长已超过30天未登录，您被系统任命为军团【%s】新的会长！"
