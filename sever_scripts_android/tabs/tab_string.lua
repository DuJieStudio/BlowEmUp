hVar.tab_string = {}
hVar.tab_stringA = {}	--活动
hVar.tab_stringQ = {}	--任务
setmetatable(hVar.tab_string,{
	__index = function(t,k)
		return tostring(k)
	end,
})
local _tab_string = hVar.tab_string
local _tab_stringA = hVar.tab_stringA
local _tab_stringQ = hVar.tab_stringQ

--------------------------------
--活动
--------------------------------
--_tab_stringA[1] = {
--	"act:{$《策马三国志》竞技场火热开放中！}:2;",
--}




--------------------------------------------------
--任务
--------------------------------------------------

_tab_stringQ[1] = {"洗炼入门","洗炼道具 5 次"}
_tab_stringQ[2] = {"洗炼能手","洗炼道具 10 次"}
_tab_stringQ[3] = {"洗炼精通","洗炼道具 15 次"}









--------------------------------
--字符串
--------------------------------
_tab_string["__ERR__NotEnoughCoin"] = "游戏币不足"
_tab_string["__ERR__PaymentFail"] = "购买失败"
_tab_string["__TEXT__PVPCoin"] = "兵符"
_tab_string["__TEXT_DAILY_VIP1"] = "VIP1每日奖励"
_tab_string["__TEXT_DAILY_VIP2"] = "VIP2每日奖励"
_tab_string["__TEXT_DAILY_VIP3"] = "VIP3每日奖励"
_tab_string["__TEXT_DAILY_VIP4"] = "VIP4每日奖励"
_tab_string["__TEXT_DAILY_VIP5"] = "VIP5每日奖励"
_tab_string["__TEXT_DAILY_VIP6"] = "VIP6每日奖励"
_tab_string["__TEXT_DAILY_VIP7"] = "VIP7每日奖励"

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

_tab_string["__TEXT_MONTHCARD_PRIZE_TITLE"] = "氪石萃取机每日生产;"
_tab_string["__TEXT_MONTHCARD_PRIZE_CONTENT"] = "氪石萃取机又精炼出 30 氪石\n \n并产生了一些副产品 20 装备宝箱碎片\n \n \n氪石萃取机剩余工作时效：%d天;"
_tab_string["__TEXT_MONTHCARD_PRIZE_PRIZE"] = "7:30:0:0;108:20:0:0;"

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
_tab_string["__TEXT_GMTOOL_PRIZE"] = "GM奖励-%s;%d:%d:%d:%d;"
_tab_string["__TEXT_GUIDE_PRIZE"] = "恭喜您通关新手图;10:20212:0:0;10:20213:0:0;"
_tab_string["__TEXT_TASK_REWARD_YESTERDAY"] = "昨日任务奖励;尊敬的玩家，您昨日有部分已完成的任务忘记领取，现已为您补发邮件。;%s"
_tab_string["__TEXT_TASK_REWARD_YESTERDAY_DRAWCARD"] = "昨日任务奖励-%s;%s"
_tab_string["__TEXT_TASK_REWARD_DRAWCARD"] = "任务奖励-%s;%s"
_tab_string["__TEXT_TASK_REWARD_WEEK"] = "周任务第%d档奖励"
_tab_string["__TEXT_MAIL_TILI_AUTOSEND"] = "传送气体补给包;看到【%s】四处征战的成绩，黑龙从自己的气矿储备里，划拨了20个单位给你！\n \n请及时领取！;25:20:0:0;"
_tab_string["__TEXT_MAIL_COMMENT_PRIZE"] = "感谢信;感谢您对游戏发表意见和看法！;7:100:0:0;"
_tab_string["__TEXT_MAIL_SHARE_PRIZE"] = "分享奖励;感谢您的分享，以下为您的分享奖励！;108:10:0:0;"
_tab_string["__TEXT_GIFT_EQUIP_REWARD"] = "特惠装备第%d档奖励"
