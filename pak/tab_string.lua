--UTF8格式文件！
--print("UTF8格式文件！")
g_string = {}
g_string.tab_string = {}
g_string.tab_stringU = {}		--单位字符串
g_string.tab_stringH = {}		--不知道是啥
g_string.tab_stringS = {}		--技能字符串
g_string.tab_stringSH = {}		--技能简介字符串
g_string.tab_stringI = {}		--物品字符串
g_string.tab_stringM = {}		--地图字符串
g_string.tab_stringIE = {}		--道具强化说明表
g_string.tab_stringME = {}		--勋章信息说明表
g_string.tab_stringQ = {}		--任务说明表
g_string.tab_stringGIFT = {}		--礼包说明表
g_string.tab_stringT = {}		--战术技能表
g_string.tab_stringTF = {}		--战术技能卡的来源表
g_string.tab_stringCH = {}		--章节描述
g_string.tab_stringTR = {}		--宝物表

local _tab_string = g_string.tab_string
local _tab_stringU = g_string.tab_stringU
local _tab_stringH = g_string.tab_stringH
local _tab_stringS = g_string.tab_stringS
local _tab_stringI = g_string.tab_stringI
local _tab_stringM = g_string.tab_stringM
local _tab_stringIE = g_string.tab_stringIE
local _tab_stringME = g_string.tab_stringME
local _tab_stringGIFT = g_string.tab_stringGIFT
local _tab_stringT = g_string.tab_stringT
local _tab_stringTF = g_string.tab_stringTF
local _tab_stringSH = g_string.tab_stringSH
local _tab_stringQ = g_string.tab_stringQ
local _tab_stringCH = g_string.tab_stringCH
local _tab_stringTR = g_string.tab_stringTR

local Default_tab_string = {}
local Default_tab_stringT = {"name","hint"}
local Default_tab_stringTX = {"name",{"hint"}}
for i = 1,49999 do
	_tab_stringU[i] = Default_tab_string
end
for i = 1,9999 do
	_tab_stringS[i] = Default_tab_string
	_tab_stringI[i] = Default_tab_string
end
for i = 1,999 do
	_tab_stringT[i] = Default_tab_string
end
for i = 1,999 do
	_tab_stringQ[i] = Default_tab_string
end
setmetatable(_tab_string,{
	__index = function(t,k)
		return tostring(k)
	end,
})


--程序用的别动
g_input_erro_info = {}
g_input_erro_info[1] = "名字与已有存档同名"
g_input_erro_info[2] = "您还没有输入名字"
g_input_erro_info[3] = "名字不能包含空格"
g_input_erro_info[4] = "名字最长支持14个英文或7个汉字"
g_input_erro_info[5] = "名字不能使用特殊字符"
g_input_erro_info[6] = "你输入的内容含有敏感词汇"
g_input_erro_info[7] = "名字不能以数字和标点符号开头"
g_input_erro_info[8] = "请勿透露您的个人信息"
g_input_erro_info[9] = "名字最少要4个英文或2个汉字"




--第一关失败后的小贴士
g_fail_hint_info_map01 = {}
g_fail_hint_info_map01[1] = "积极指挥英雄前往各个防守点，配合防御塔发挥威力"
g_fail_hint_info_map01[2] = "刘备召唤的小兵，既可以事先准备在路口，也可以用来救急"
g_fail_hint_info_map01[3] = "应对快速袭击的骑兵，防线可以适当押后"
g_fail_hint_info_map01[4] = "在关卡里，长按塔不放可拆除塔、查看塔属性"


--第二关失败后的小贴士
g_fail_hint_info_map02 = {}
g_fail_hint_info_map02[1] = "积极指挥英雄前往各个防守点，配合防御塔发挥威力"
g_fail_hint_info_map02[2] = "双线交汇的地方，重点防守"
g_fail_hint_info_map02[3] = "张飞的战术技能，在小兵堆积最多的时候释放效果最好"
g_fail_hint_info_map02[4] = "在关卡里，长按塔不放可拆除塔、查看塔属性"


--第三关失败后的小贴士
g_fail_hint_info_map03 = {}
g_fail_hint_info_map03[1] = "积极指挥英雄前往各个防守点，配合防御塔发挥威力"
g_fail_hint_info_map03[2] = "双线交汇的地方，重点防守"
g_fail_hint_info_map03[3] = "利用英雄复活的时间差，与主将缠斗"
g_fail_hint_info_map03[4] = "在关卡里，长按塔不放可拆除塔、查看塔属性"


--失败后的小贴士
g_fail_hint_info = {}

---第一章节
g_fail_hint_info[1] = "挑战模式，可以获得更多星星和奖励"
g_fail_hint_info[2] = "提升英雄的等级，可以穿上更好的装备"
g_fail_hint_info[3] = "升级塔和战术技能卡，可以尽快获得实力的提升"
g_fail_hint_info[4] = "洗炼出的装备属性，红色为最好"
g_fail_hint_info[5] = "从每日任务以及成就系统中可以获得丰厚奖励"
g_fail_hint_info[6] = "搭配练兵卡，英雄等级会提升的更快"
g_fail_hint_info[7] = "首次充值各档位，可获得独一无二的装备"
g_fail_hint_info[8] = "进入奖励界面，每天可以分享游戏给微信好友，获得游戏币"
g_fail_hint_info[9] = "箭塔，炮塔，法术塔以及特种塔，是天关塔诀的四大分类"
g_fail_hint_info[10] = "在关卡里，塔可以按住不放来拆除或查看属性"
g_fail_hint_info[11] = "合成装备时，有几率把装备提升到更高品质"
g_fail_hint_info[12] = "在关卡里，长按塔不放可拆除塔、查看塔属性"


---第二章节
g_fail_hint_info[13] = "英雄满10级之后，需要升星才能继续提高等级"
g_fail_hint_info[14] = "每日挑战无尽地图，排名前100名会获得丰厚奖励"
g_fail_hint_info[15] = "竞技场提供了玩家1对1的公平对战模式"
g_fail_hint_info[16] = "开启竞技场的战功锦囊，可获得英雄将魂，兵种碎片等多种奖励"
g_fail_hint_info[17] = "魔龙宝库，提供了双人配合的塔防玩法"
g_fail_hint_info[18] = "收集英雄将魂，可用于竞技场界面升星，提升英雄等级上限"
g_fail_hint_info[19] = "铜雀台，提供了五位英雄勇闯地下城的玩法，需要一定实力再去挑战"
g_fail_hint_info[20] = "开启神器锦囊，有几率获得英雄装备中的终极神器"
g_fail_hint_info[21] = "神器图鉴，陈列了游戏中的终极神器装备"
g_fail_hint_info[22] = "新手在1对1竞技场会获得额外的buff加成，可以放手一博"




--月英传失败后的小贴士
--月英传第一关
g_fail_hint_info_map_yyz1 = {}
g_fail_hint_info_map_yyz1[1] = "注意躲避隐藏在草丛里的捕兽夹"
g_fail_hint_info_map_yyz1[2] = "缓慢推进，不要一次引来太多敌人"
g_fail_hint_info_map_yyz1[3] = "BOSS的技能在生效前会提前预警，注意躲避"
g_fail_hint_info_map_yyz1[4] = "BOSS隐身时，你无法对他攻击"

--月英传第二关
g_fail_hint_info_map_yyz2 = {}
g_fail_hint_info_map_yyz2[1] = "耐心等待旋转飞刃折返"
g_fail_hint_info_map_yyz2[2] = "BOSS身上掉落的宝物，可以用来穿越尖刺、躲避攻击和技能"
g_fail_hint_info_map_yyz2[3] = "解除封印才能进入BOSS所在的位置"
g_fail_hint_info_map_yyz2[4] = "不要太靠近BOSS"

--月英传第三关
g_fail_hint_info_map_yyz3 = {}
g_fail_hint_info_map_yyz3[1] = "注意地上的尖刺，站在里面会持续掉血"
g_fail_hint_info_map_yyz3[2] = "右上位置的BOSS身上掉落的宝物可以用来清除尖刺"
g_fail_hint_info_map_yyz3[3] = "滚石滚动的距离非常远，算准时间再前进吧"

--月英传第四关
g_fail_hint_info_map_yyz4 = {}
g_fail_hint_info_map_yyz4[1] = "隐藏的房间里有威力强大的宝物"
g_fail_hint_info_map_yyz4[2] = "准火焰喷射的时间，一点一点推进"
g_fail_hint_info_map_yyz4[3] = "旋转飞刃之间的墙壁空隙处不会被旋转飞刃击中"



--孙尚香传第一关
g_fail_hint_info_map_ssxz1 = {}
g_fail_hint_info_map_ssxz1[1] = "合理运用捕兽夹，来控制野兽的行动"
g_fail_hint_info_map_ssxz1[2] = "野兽在被捕兽夹捕获后会变得非常脆弱"
g_fail_hint_info_map_ssxz1[3] = "注意分担友军的压力，不要让友军面对太多敌人"

--孙尚香传第二关
g_fail_hint_info_map_ssxz2 = {}
g_fail_hint_info_map_ssxz2[1] = "注意躲避BOSS的大招"
g_fail_hint_info_map_ssxz2[2] = "BOSS的攻击力很强大，注意躲避控制技能"
g_fail_hint_info_map_ssxz2[3] = "BOSS在施放技能时会进入僵直，是你进行输出的好时机"





--字符串
_tab_string["XiaoTieShi"] = "通关小贴士"
_tab_string["MadelGift"] = "奖励："
_tab_string["MadelGiftGet"] = "领取"
_tab_string["__TEXT_ShareSNS"] = "分享"
_tab_string["__TEXT_ShareSNS_MAP_001"] = "首通 桃园结义 分享朋友圈奖励"
_tab_string["__TEXT_ShareSNS_MAP_002"] = "首通 救援青州 分享朋友圈奖励"
_tab_string["__TEXT_ShareSNS_MAP_003"] = "首通 广宗之战 分享朋友圈奖励"


_tab_string["system_mail"] = "系统邮件"
_tab_string["system_mail2"] = "系统消息"
_tab_string["__TEXT_Notice"] = "公告"
_tab_string["ios_prize_from_system"] = "来自系统的奖励"
_tab_string["ios_prize_first_enter_game"] = "首次进入游戏奖励"
_tab_string["ios_prize_share_weibo"] = "分享到腾讯微博奖励"
_tab_string["ios_prize_share_sina"] = "分享到新浪微博奖励"
_tab_string["ios_prize_share_weixin"] = "分享到微信朋友圈奖励"
_tab_string["ios_prize_share_weixin_haoyouquan"] = "分享到微信好友奖励"
_tab_string["ios_prize_share_qq"] = "分享到QQ奖励"
_tab_string["ios_prize_share_qq_space"] = "分享到QQ空间奖励"

_tab_string["set_photo"] = "设置头像"
_tab_string["local_photo"] = "本地相册"
_tab_string["camera_photo"] = "拍照"
_tab_string["Auditing"] = "审核中"
_tab_string["Auditing_Info"] = "提示:上传的照片需要3天审核时间，通过审核后，会显示在游戏胜利、失败等界面上。"
_tab_string["photo2usual"] = "不要操作过于频繁"

_tab_string["ios_prize_share_renren"] = "分享到人人网奖励"
_tab_string["ios_prize_share_apple_store"] = "苹果商店评价奖励"
_tab_string["ios_gamecoin"] = "游戏币"
_tab_string["ios_score"] = "积分"
_tab_string["ios_cangbaotu_normal"] = "藏宝图碎片"
_tab_string["ios_cangbaotu_high"] = "高级藏宝图碎片"
_tab_string["ios_iron"] = "铁"
_tab_string["ios_wood"] = "木材"
_tab_string["ios_food"] = "粮食"
_tab_string["ios_bingfu"] = "兵符"
_tab_string["ios_groupcoin"] = "军团币"
_tab_string["ios_freeticket"] = "免费券"
_tab_string["ios_gift_packet"] = "礼包"
_tab_string["ios_gift_packet_with_parentheses"] = "(礼包)"
_tab_string["ios_format_prize_coin_score"] = "(%d游戏币,%d积分)"
_tab_string["ios_format_prize_coin"] = "(%d游戏币)"
_tab_string["ios_format_prize_score"] = "(%d积分)"
_tab_string["ios_format_buy_membership_success"] = "成功购买30天月卡！"
_tab_string["ios_err_network"] = "网络错误"
_tab_string["ios_err_sync"] = "同步数据异常"
_tab_string["ios_gamecoin_intro"] = "游戏币可用于主公改名、购买英雄、购买卡包、洗炼装备、购买商城道具、购买地图包、兑换竞技场兵符、立即打开竞技场锦囊、英雄升星，等用途。"
_tab_string["ios_jifen_intro"] = "积分可用于为英雄、技能、道具、战术卡、竞技场等提升属性而消耗的通用素材。挑战关卡、每日任务、完成成就、活动、竞技场等多个途径都可以获得积分。"
_tab_string["ios_AP_intro"] = "成就点是记录您整个游戏的历程。每完成一个指定成就，都会获得成就点。同时您获得的总成就点数会上传至GameCenter排行榜，与全球玩家一决高下。"
_tab_string["ios_AP_heroexp"] = "英雄升级需要经验。成功通关关卡，本局出战的英雄都会获得经验。"
_tab_string["ios_AP_enemy_lifepoint"] = "游戏中敌人从终点漏过，将扣除您生命点数。您的生命点数扣至0点，通关失败。"
_tab_string["ios_AP_enemy_killgold"] = "游戏中消灭敌人，将获得金。（有一定的几率获得双倍金币奖励）"
_tab_string["ios_err_network_cannot_conn"] = "不能连接到网络"
_tab_string["ios_err_network_cannot_conn2"] = "请保持网络畅通..."
_tab_string["ios_err_network_cannot_group"] = "加入军团后才能进入此分页！"
_tab_string["ios_err_network_cannot_couple"] = "您不在组队副本中！"
_tab_string["ios_err_network_cannot_chat_useout"] = "您今日聊天次数已用完！"
_tab_string["ios_err_network_cannot_chat_forbidden"] = "您被禁言，%d分钟后才能发送消息！"
_tab_string["ios_err_network_cannot_redpacker_maxcount"] = "今日发红包次数已达上限"
_tab_string["ios_err_network_cannot_chat_forbidden_all"] = "全员禁言中，只允许管理员发言！"
_tab_string["ios_err_network_cannot_chat_private_target"] = "没有私聊发送目标！"
_tab_string["ios_err_network_cannot_conn_server"] = "不能连接到服务器"
_tab_string["ios_tip_input_recomm_uid"] = "请输入有效的8位数字账号"
_tab_string["ios_tip_network_waiting_server_response"] = "等待服务器响应..."
_tab_string["ios_tip_network_waiting_server_response1"] = "请等待服务器响应\n或稍后再次尝试..."
_tab_string["ios_tip_click_too_fast"] = "您点击的太快了"
_tab_string["ios_err_client_uid_0"] = "客户端ID为0"
_tab_string["ios_err_input_cannot_self_uid"] = "不能输入自己的ID"
_tab_string["ios_success_social_share_sina"] = "您成功分享到社交媒体 \n新浪微博"
_tab_string["ios_success_social_share_tencent"] = "您成功分享到社交媒体 \n腾讯微博"
_tab_string["ios_success_social_share_weixin"] = "您成功分享到社交媒体 \n微信"

_tab_string["ios_success_social_share_weixin_friends"] = "您成功分享到社交媒体 \n微信朋友圈"
_tab_string["ios_success_social_share_qq"] = "您成功分享到社交媒体 \nQQ"
_tab_string["ios_success_social_share_qq_space"] = "您成功分享到社交媒体 \nQQ空间"
_tab_string["ios_success_social_share_renren"] = "您成功分享到社交媒体 \n人人网"
_tab_string["ios_success_social_share_facebook"] = "您成功分享到社交媒体 facebook"
_tab_string["ios_success_social_share_twitter"] = "您成功分享到社交媒体 twitter"
_tab_string["ios_tip_prize_reward_recomm_success"] = "推荐奖励领取成功"
_tab_string["ios_tip_prize_reward_success"] = "领取成功"
_tab_string["ios_tip_prize_reward_everyday_success"] = "每日奖励已发放到邮箱！"
_tab_string["ios_err_prize_everyday_available_only_once"] = "每日奖励无法重复领取"
_tab_string["ios_tip_prize_reward_multy_pve_success"] = "本次奖励已发放到邮箱！"
_tab_string["ios_tip_prize_reward_redequip"] = "请选择要领取的神器"

_tab_string["text_pvp_player_timeout"] = "操作超时"
_tab_string["ios_err_prize_everyday_rewarded"] = "每日奖励已领取"
_tab_string["ios_err_prize_rewarded"] = "奖励已领取"
_tab_string["ios_err_activity_not_enabled"] = "活动未开启"
_tab_string["ios_err_network_conn_timeout"] = "服务器超时"
_tab_string["ios_err_network_server_exec_sql"] = "服务器SQL语句执行出错"
_tab_string["ios_err_recomm_by_invalid_id"] = "无效的推荐人ID"
_tab_string["ios_err_recomm_invalid"] = "无效的推荐"
_tab_string["ios_err_recomm_by_login_less_3_days"] = "登入未满3天，不能推荐"
_tab_string["ios_err_recomm_by_same_person"] = "不能被同一个人重复推荐"
_tab_string["ios_err_recomm_by_only_one"] = "你只能被一个人推荐"
_tab_string["ios_err_recomm_cannot_each_other"] = "不能相互推荐"

_tab_string["ios_err_rename"] = "您输入的名字与已有玩家重名，请更换名字"
_tab_string["ios_err_prize_invalid"] = "无效的奖励"
_tab_string["ios_err_unknow"] = "未知错误"
_tab_string["ios_tip_recomm_confirmed"] = "确认了您的推荐"
_tab_string["ios_buy_gamecoin"] = "购买游戏币"
_tab_string["ios_payment_select_pay_mode"] = "请选择"
_tab_string["ios_in_app_purchase"] = "游戏内购买"
_tab_string["ios_payment_apple"] = "苹果"
_tab_string["ios_payment_alipay"] = "支付宝"
_tab_string["ios_payment_mipay"] = "米币"
_tab_string["ios_payment_huawei"] = "华为"
_tab_string["ios_payment_jiuyou"] = "九游"
_tab_string["ios_payment_txpay"] = "应用宝"
_tab_string["ios_payment_lhhpay"]= "乐嗨嗨"
_tab_string["ios_format_buy_gamecoin_success"] = "成功购买%@游戏币"
_tab_string["ios_confirm"] = "确认"
_tab_string["remaining_currency"] = "应用宝充值货币余额："
_tab_string["request_currency_failed"] = "应用宝充值币余额查询失败，请关闭界面重新打开！"
_tab_string["currency_tip"] = "充值到账会有延时，如果充值没有到账，请关闭充值界面，重新打开。"
_tab_string["request_errcode"] = "错误码："
_tab_string["request_outtime"] = "查询超时"
_tab_string["recharge_success"] = "充值成功，请前往【信箱】领取奖励"
_tab_string["recharge_success_short"] = "充值成功！"
_tab_string["ios_deal_ing"] = "上一个交易正在处理中！"
_tab_string["ios_pruchase_connect"] = "连接"
_tab_string["ios_pruchase_pay1"] = "AppSotre"
_tab_string["ios_pruchase_pay2"] = "feiqide"
_tab_string["ios_pruchase_fail"] = "失败，请检查您的网络设置。"

_tab_string["ios_chat_not_empty"] = "聊天内容不能为空"
_tab_string["ios_chat_too_long"] = "您输入的内容过长"
_tab_string["ios_chat_no_empty"] = "不能包含空格"
_tab_string["ios_chat_no_text"] = "您还没有输入内容"



_tab_string["ios_error"] = "错误"
_tab_string["ios_not_enough_game_coin"] = "游戏币不足"
_tab_string["ios_payment_fail"] = "购买失败"
_tab_string["ios_payment_success"] = "购买成功！"
_tab_string["ios_exchange_success"] = "兑换成功！"
_tab_string["ios_ui_recomm_id"] = "推荐人ID:"
_tab_string["__TEXT_share_p"] = "填写推荐人"
_tab_string["__TEXT_share_m"] = "推荐到平台"
_tab_string["recomm_succ"] = "向你推荐了游戏"
_tab_string["enter_recomm_id"] = "请填写推荐人的8位数字账号"
_tab_string["enter_recomm_id_once"] = "每位玩家只能输入推荐人ID一次"
_tab_string["enter_recomm_id_rec"] = "作为推荐人"
_tab_string["rec_m_new_daily_info1"] = "填写推荐人，您可获得20游戏币的奖励。对方也可以获得20游戏币的奖励。每个玩家只能填写推荐人一次。"
_tab_string["rec_m_new_1"] = "【分享奖励】"
_tab_string["rec_m_new_2"] = "【推荐奖励】作为推荐人，奖励20游戏币。"
_tab_string["rec_m_new_3"] = "【推荐奖励】"
_tab_string["enter_recomm_count"] = "推荐游戏给朋友，按累计人数可以获得多档奖励"
_tab_string["recomm_info1"] = "除了上述的累计奖励，每次被其他玩家填写为推荐人，都可以获得20游戏币的奖励。"
_tab_string["recomm_g1info"] = "推荐达到1位玩家,获得20游戏币"
_tab_string["recomm_g5info"] = "推荐达到5位玩家,获得120游戏币"
_tab_string["recomm_g10info"] = "推荐达到10位玩家,获得20个黄金宝箱"
_tab_string["recomm_g20info"] = "推荐达到20位玩家,获得50个黄金宝箱"
_tab_string["recomm_g50info"] = "推荐达到50位玩家,获得3孔麒麟心1个(找GM领取)"
_tab_string["sns_str"] = "我正在绞尽脑汁玩《策马守天关》,可以去苹果商店下载,地址:  "
_tab_string["sns_str_1"] = "我正在绞尽脑汁玩《策马守天关》,可以去苹果商店下载,地址:  "
_tab_string["sns_str_2"] = "我正在玩《策马守天关》，三国版的英雄无敌，喜欢策略游戏的都来试试吧！"
_tab_string["sns_str_3"] = "收了可观的小费后，酒馆老板小声说道：《策马守天关》是三国版的英雄无敌，喜欢策略游戏的都来试试吧！"
_tab_string["recomm_level_jyqz_tuijian"] = "通关【救援青州】才能推荐"
_tab_string["recomm_level_jyqz_dengru"] = "登入天数达到3天才能推荐"
_tab_string["recomm_level_jyqz_pingjia"] = "通关【救援青州】才能评价"
_tab_string["ios_ui_recomm_id_placeholder"] = "点击输入推荐者ID"
_tab_string["ios_ui_recomm_self_id"] = "您的ID:"
_tab_string["ios_ui_recomm_introduce"] = "推荐给朋友玩，2人均可获得游戏币奖励！"
_tab_string["ios_ui_recomm_social_share_introduce"] = "分享到每个社交媒体，均可获得游戏币奖励！"
_tab_string["ios_ui_gift_code_placeholder"] = "8位数字或字符"
_tab_string["ios_success_social_share_facebook"] = "您成功分享到社交媒体 facebook"
_tab_string["ios_success_social_share_twitter"] = "您成功分享到社交媒体 twitter"
_tab_string["ios_payment_verify_sign_fail"] = "验证签名失败"
_tab_string["monthly_coin"] = "每日领取 30 游戏币"
_tab_string["monthly_debrirs"] = "每日领取6个英雄将魂"

_tab_string["allRmb"] = "充值累计金额"
_tab_string["allRmb2"] = "已充值:"
_tab_string["Rmb"] = "元"
_tab_string["TeQuan"] = "特权"
_tab_string["PurchaseIntro1"] = "获得充值游戏币60。\n获得500积分。"
_tab_string["PurchaseIntro2"] = "获得充值游戏币180，额外赠送游戏币20。\n获得1000积分。"
--_tab_string["PurchaseIntro3"] = "获得充值游戏币300，额外赠送游戏币50。\n获得2000积分。"
_tab_string["PurchaseIntro3"] = "获得充值游戏币680，额外赠送游戏币120。\n获得3000积分。"
_tab_string["PurchaseIntro4"] = "获得充值游戏币980，额外赠送游戏币220。\n获得4000积分。"
_tab_string["PurchaseIntro5"] = "获得充值游戏币1980，额外赠送游戏币520。\n获得8000积分。"
_tab_string["PurchaseIntro6"] = "获得充值游戏币3880，额外赠送游戏币1120。\n获得16000积分。"


_tab_string["JianTaPage"] = "箭塔"
_tab_string["FashuTaPage"] = "法术塔"
_tab_string["PaoTaPage"] = "炮塔"
_tab_string["TeShuTaPage"] = "特种塔"
_tab_string["TacticCardPage"] = "战术卡"
_tab_string["SpecialTacticIntro"] = "解锁更多关卡后，将有几率获特种塔。"
_tab_string["CurrentEffect"] = "当前效果"
_tab_string["UnLockEffect"] = "解锁后效果"
_tab_string["NextLvEffect"] = "下一等级效果"
_tab_string["UpToMaxLv"] = "已到顶级"
_tab_string["UpToMaxStar"] = "已到顶星"
_tab_string["InBattle"] = "游戏局中"
_tab_string["CanLvUpMax"] = "最高可升级"
_tab_string["CanNotLvUp"] = "未解锁升级"
_tab_string["UnLock"] = "15级解锁"
_tab_string["ThisSkill"] = "该技能"
_tab_string["HeroStarLv"] = "英雄星级"
_tab_string["HeroStarIntro1"] = "通过打开竞技场锦囊，或在游戏商店开启神器锦囊，可以收集到英雄将魂来给英雄令提升星级，提高等级上限。\n目前该英雄等级上限为10级。"
_tab_string["HeroStarIntro2"] = "通过打开竞技场锦囊，或在游戏商店开启神器锦囊，可以收集到英雄将魂来给英雄令提升星级，提高等级上限。\n目前该英雄等级上限为15级。"
_tab_string["RequireCostSomeJiFen"] = "需要消耗一定数量的积分。"
_tab_string["RequireCostSomeDebris"] = "需要消耗一定数量的该碎片。"
_tab_string["RequireCostSomeHeroDebris"] = "需要消耗一定数量的该将魂。"
_tab_string["DebrisMergeHint"] = "[合成整卡后效果]"
_tab_string["Card"] = "卡"
_tab_string["ClickTowerSeeDetail"] = "点击左侧塔查看详情。"
_tab_string["ClickSpecialTowerSeeDetail"] = "点击左侧特种塔查看详情。"
_tab_string["ClickTacticCardSeeDetail"] = "点击左侧战术卡查看详情。"
_tab_string["ClickCardSeeDetail"] = "请在右侧上方区域，\n选择配置出战竞技场的英雄、防御塔、兵种。"
_tab_string["ClickCardSeeDetail2"] = "请在右侧上方区域，\n选择配置挑战魔龙的英雄、防御塔。"
_tab_string["ClickCardSeeDetail3"] = "请在右侧上方区域，\n选择配置挑战铜雀台的英雄。"
_tab_string["Tower_TaJi_Intro"] = "游戏局中固定位置摆放的塔基，可建造箭塔、法术塔、炮塔、特种塔。"
_tab_string["Tower_Base_Intro"] = "最初级的塔，由塔基建造而成。"
_tab_string["Tower_Medium_Intro"] = "通过初级塔再次建造而成，并可选择某个高级塔分支再次建造。（需要在游戏中携带该分支的卡牌）"
_tab_string["SkillUpgrateEffect"] = "技能升级后效果"
_tab_string["ClickEnemyiconSeeDetail"] = "点击左侧单位头像查看详情。"
_tab_string["ShouCangPingFen"] = "收藏评分"
_tab_string["RoomPage"] = "娱乐房"




_tab_string["__TEXT_Back_Login"] = "返回登陆"
_tab_string["__TEXT_Try_Connect"] = "尝试重连"

--_tab_string["new_login_local_tourist_info1"] = "推荐使用微信登陆游戏，游客账号删除游戏后会丢失数据，并且无法找回。"
_tab_string["new_login_local_tourist_info2"] = "游客状态无法充值，请尽快体验游戏到第一章节结束！"
_tab_string["new_login_local_tourist_info1"] = "推荐使用微信登陆游戏。"
_tab_string["new_login_local_tourist_btn_str2"] = "游客登入"
_tab_string["new_login_local_tourist_btn_str1"] = "游客进入"
_tab_string["old_login"] = "帐号登陆"
_tab_string["other_login_info"] = "合作帐号登录"
_tab_string["weixin"] = "微信"
_tab_string["xiaomi"] = "小米"
_tab_string["no_bind_warring"] = "游客账号删除游戏后将丢失数据，请尽快绑定微信。"
_tab_string["no_bind_warring_setPassword"] = "游客账号不能设置密码"
_tab_string["__TEXT_Game_Privacy"] = "请详细阅读并同意，鑫线游戏隐私协议及用户协议"
_tab_string["__TEXT_GamePrivacy_Title"] = "鑫线游戏隐私政策及用户协议"
_tab_string["bind"] = "绑定"
_tab_string["new_other_plantform_reg"] = "新建帐号"
_tab_string["bind_info1"] = "把["
_tab_string["bind_info2"] = "]绑定到你的"
_tab_string["n_p_r_info1"] = "创建新帐号,并绑定到你的"
_tab_string["name_length"] = "最多5个汉字"
_tab_string["bind_name_info1"] = "为["
_tab_string["bind_name_info2"] = "]起个新名字吧"
_tab_string["new_name_info1"] = "请输入新账号的名字"
_tab_string["no_network_new_login"] = "未能连接到游戏服务器"


_tab_string["LockThisSlot"] = "锁定本条属性，不被重洗。"
_tab_string["UnlockThisSlot"] = "取消锁定本条属性。"
_tab_string["Lock"] = "锁定"
_tab_string["APPont"] = "成就点"
_tab_string["TOTAL_APPont"] = "总成就点："
_tab_string["enter_gift_8"] = " 8位数字或字符"
_tab_string["__TEXT_Enter_Gift"] = "请输入礼品码"
_tab_string["gift_err_not_exist"]="该礼品码不存在"
_tab_string["gift_err_only_use_once"]="同类型礼品码只能领取1次"
_tab_string["gift_err_cannot_use"]="该礼品码已经被使用"

_tab_string["NoSelectHeroFirstBattle"] = "首次挑战本关不能使用该英雄"
_tab_string["NoHaveGetThisHero"] = "您还没有获得该英雄"
_tab_string["SelectHeroBanMode"] = "该英雄当前模式禁用"
_tab_string["TacticCardRow"] = "战术"
_tab_string["ArmyCardPage"] = "兵种"
_tab_string["NoSelectAnyCard"] = "您还没有选择卡牌！"
_tab_string["SelectTotalExpireMax"] = "您选择的卡牌超过可选上限！"
_tab_string["SelectHeroExpireMax"] = "您选择的英雄数量超过可选上限！"
_tab_string["SelectHeroFirstBattleNotAllowed"] = "您选择的英雄首次挑战不能使用！"
_tab_string["SelectHeroNotHaveGet"] = "您选择的英雄还没有获得！"
_tab_string["SelectHeroModeBan"] = "您选择的英雄当前模式禁用！"
_tab_string["SelectHeroNotNull"] = "您至少需要选择一位英雄出战！"
_tab_string["SelectHeroNotFull"] = "本关需要带满英雄才能开战！"
_tab_string["NoHaveGetThisTower"] = "您还没有获得该塔"
_tab_string["SelecTowerDiffNotUsed"] = "当前模式不能使用该塔"
_tab_string["SelectTowerBanMode"] = "该塔当前模式禁用"
_tab_string["SelectTowerExpireMax"] = "您选择的塔数量超过可选上限！"
_tab_string["SelectTowerDiffModeBan"] = "您选择的塔当前模式不能使用！"
_tab_string["SelectTowerModeBan"] = "您选择的塔当前模式禁用！"
_tab_string["SelecTacticDiffNotUsed"] = "当前模式不能使用该战术卡"
_tab_string["SelecTacticActiveLimit"] = "每场战斗只能使用一张主动类战术卡"
_tab_string["SelecTacticNoDebris"] = "该兵种卡未解锁"
_tab_string["SelectTacticBanMode"] = "该战术卡当前模式禁用"
_tab_string["SelectTacticExpireMax"] = "您选择的战术卡数量超过可选上限！"
_tab_string["SelectTacticDiffModeBan"] = "您选择的战术卡当前难度不能使用！"
_tab_string["SelectTacticModeBan"] = "您选择的战术卡当前模式禁用！"
_tab_string["SelectArmyExpireMax_Atk"] = "您选择的进攻兵种卡数量超过可选上限！"
_tab_string["SelectArmyExpireMax_Def"] = "您选择的防守兵种卡数量超过可选上限！"
_tab_string["SelectTacticDebrisNoEnough"] = "您选择的兵种卡未解锁！"
_tab_string["SelecCardDiffNotUsed"] = "当前模式不能使用该%s卡"
_tab_string["SelectCardExpireMax"] = "您选择的%s卡数量超过可选上限！"
_tab_string["SelectCardDiffModeBan"] = "您选择的%s卡当前模式不能使用！"
_tab_string["SelectDebrisNotEngouth"] = "已选择碎片数量不足！"
_tab_string["UnlockRequire"] = "解锁需要"
_tab_string["CurrentGet"] = "已获得"
_tab_string["CurrentNotGet"] = "未获得"
_tab_string["CurrentWin"] = "已胜利"
_tab_string["CurrentBattleStage"] = "已通关"
_tab_string["CurrentXiLian"] = "已洗炼"
_tab_string["CurrentOpenChest"] = "已开启"
_tab_string["CurrentDraw"] = "已抽到"
_tab_string["CurrentConsume"] = "已消耗"
_tab_string["CurrentAddSlot"] = "已打孔"
_tab_string["CurrentMergeRedEquip"] = "已献祭"
_tab_string["CurrentRedPacket"] = "已抢到"
_tab_string["BattleList"] = "出战阵容"
_tab_string["BattleHeros"] = "出战英雄"
_tab_string["NoSelectTowerInEndlessBattle"] = "已获得的塔都可以在无尽模式中建造"
_tab_string["TowerInEndlessBan"] = "当前模式  禁用左侧塔"
_tab_string["UnlockSlotRequire"] = "解锁该栏位需要"
_tab_string["NumStars"] = "颗星"
_tab_string["BeginBattle"] = "开战"
_tab_string["RebirthCanUse"] = "复活后才能使用"
_tab_string["BattleCanUse"] = "开战后才能使用"
_tab_string["StunFrozenCanUse"] = "眩晕中不能使用"
_tab_string["ChaosCanUse"] = "混乱中不能使用"
_tab_string["SleepCanUse"] = "睡眠中不能使用"
_tab_string["ChenmoCanUse"] = "沉默中不能使用"
_tab_string["NotFinishChapter"] = "您还未解锁本章！"
_tab_string["NotStationHeroFull"] = "英雄尚未驻守完毕！"





_tab_string["vipReward"] = "VIP 回馈"
_tab_string["vipReward_add"] = "(VIP8之后，总额每超出2000元将额外获得一张红装兑换券)"
_tab_string["vipStr1"] = "仓库3页"
_tab_string["vipStr2"] = "每天可免费领取500积分"
_tab_string["vipStr3"] = "每天可免费领取700积分"
_tab_string["vipStr4"] = "每天可免费领取1000积分"
_tab_string["vipStr5"] = "每天可免费领取1500积分"
_tab_string["vipStr6"] = "每天可免费领取2000积分"
_tab_string["vipStr7"] = "每天可以免费领取2500积分"
_tab_string["vipStr8"] = "游戏内3倍速率加速"
_tab_string["vipStr9"] = ""
_tab_string["vipStr10"] = "仓库4页"
_tab_string["vipStr11"] = "每天可免费领取普通战术卡包1个"
_tab_string["vipStr12"] = "每天可免费领取普通战术卡包2个"
_tab_string["vipStr13"] = "每天可免费领取高级战术卡包1个"
_tab_string["vipStr14"] = "每天可免费领取高级战术卡包2个"
_tab_string["vipStr15"] = "重转宝箱免费"
_tab_string["vipStr16"] = "仓库5页"
_tab_string["vipStr17"] = "仓库6页"
_tab_string["vipStr18"] = "每天可免费领取高级战术卡包3个"
_tab_string["vipStr19"] = "免费刷新限时商店3次"
_tab_string["vipStr20"] = "免费刷新限时商店4次"
_tab_string["vipStr21"] = "免费刷新限时商店5次"
_tab_string["vipStr22"] = "免费刷新限时商店6次"
_tab_string["vipStr23"] = "锁孔洗练不限制次数"
_tab_string["vipStr24"] = "获得5级战术卡【破军】"
_tab_string["vipStr25"] = "获得2星英雄令【小乔】"
_tab_string["vipStr26"] = "开启竞技场锦囊不需要等待时间"

_tab_string["vipStr27"] = "仓库7页"
_tab_string["vipStr28"] = "每天可以免费领取3000积分"
_tab_string["vipStr29"] = "每天可免费领取高级战术卡包4个"
_tab_string["vipStr30"] = "免费刷新限时商店7次"
_tab_string["vipStr31"] = "获得2张红装兑换卷（可兑换4孔红装）"
_tab_string["vipStr32"] = "VIP7以后充值每达到2000元都可获得1张红装兑换券"


_tab_string["vipGet1"] = "领卡包"
_tab_string["vipGet2"] = "换卡包"
_tab_string["vipGetInfo"] = "每日领取"
_tab_string["vipOneOffReward20010"] = "VIP5获得5级战术卡【破军】"
_tab_string["vipOneOffReward20011"] = "VIP6获得英雄令【小乔】"
_tab_string["vipOneOffReward20012"] = "VIP7获得2张红装兑换券"
_tab_string["vipOneOffReward20020"] = "VIP7及以上每充值2000元获得1张红装兑换券"
_tab_string["noenoughscore"] = "没有足够积分"
_tab_string["Can'tUseVip5"] = "VIP5及以上玩家才能使用红装祭坛"
_tab_string["check_out_err23"] = "帐号不对"
_tab_string["check_out_err24"] = "密码不对"
_tab_string["check_out_err25"] = "迁移操作时,当前游戏币数量必须大于等于10"
_tab_string["check_out_err26"] = "游戏币填写不匹配"
_tab_string["check_out_err90"] = "数据迁移间隔过短"
_tab_string["check_out_err91"] = "转档中"
_tab_string["check_in_err23"] = "不能恢复当前正在玩的账号"
_tab_string["check_in_err24"] = "帐号密码不匹配"
_tab_string["check_in_err25"] = "游戏币填写不对"
_tab_string["check_in_err92"] = "没有相关转档记录"
_tab_string["check_in_err93"] = "恢复流程出错"
_tab_string["check_in_err94"] = "获取账号失败"
_tab_string["uid_uuid_wrong"] = "该游戏账号【"
_tab_string["uid_uuid_wrong1"] = "】已绑定其它设备,无法进入游戏!"
_tab_string["uid_uuid_wrong2"] = "】已迁出当前设备,无法进入游戏!"
_tab_string["uid_testor_change0"] = "您的账号已变更成正式账号，需重启游戏生效！"
_tab_string["uid_testor_change1"] = "您的账号已变更成测试账号，需重启游戏生效！"
_tab_string["uid_old_version"] = "游戏版本过旧,无法使用最新功能\n版本需求:[%s]\n当前版本:[%s]\n请联网更新游戏到最新版本!"
_tab_string["script_login_error_40"] = "版本太老登陆失败[%d,%d]"
_tab_string["script_login_error_other"] = "登陆失败[%d,%d]"

--geyachao: 道具面板用到的文字
_tab_string["__ITEM_UKNOWN"] = "未知道具"
_tab_string["__ITEM_PANEL__PAGE_SELL"] = "出售"
_tab_string["__ITEM_PANEL__PAGE_RESELL"] = "回收"
_tab_string["__ITEM_PANEL__PAGE_COLLECT"] = "一键添加"
_tab_string["__ITEM_PANEL__PAGE_MERGE"] = "合成"
_tab_string["__ITEM_PANEL__PAGE_XILIAN"] =  "洗炼"
_tab_string["__ITEM_PANEL__PAGE_XIANJI"] =  "献祭"
_tab_string["__ITEM_PANEL__PAGE_CURRENT"] =  "当前"
_tab_string["__ITEM_PANEL__PAGE_QIANGHUA"] =  "强化"
_tab_string["__ITEM_PANEL__PAGE_CHONGZHU"] = "解锁"
_tab_string["__ITEM_PANEL__PAGE_RESTORE"] = "还原"
_tab_string["__ITEM_PANEL__PAGE_ARRANGE"] =  "整理"
_tab_string["__ITEM_PANEL__PAGE_DRAWCARD"] =  "抽到"
_tab_string["__ITEM_PANEL__PAGE_TURNTABLE"] =  "在转盘活动中抽到了"
_tab_string["__ITEM_PANEL__PAGE_GROUPCHEST"] =  "在军团市场抽到了"
_tab_string["__ITEM_PANEL__PAGE_GROUPREDPACKET"] =  "在军团红包中获得"
_tab_string["__ITEM_PANEL__PAGE_PAYREDPACKET"] =  "在红包中获得"
_tab_string["__ITEM_PANEL__PAGE_SEVENDAYPAY"] =  "在活动中领取"
_tab_string["__ITEM_PANEL__PAGE_SHENQIGIFTSELECT"] =  "从神器礼包中选取了"
_tab_string["__ITEM_PANEL__PAGE_TACTICCARDGIFTSELECT"] =  "从战术礼包中选取了"
_tab_string["__ITEM_PANEL__PAGE_TURNCHOUJIANG"] =  "在抽奖活动中抽到了"
_tab_string["__ITEM_PANEL__SELL_PREFIX"] = "出售将获得"
_tab_string["__ITEM_PANEL__SELL_DISABLE"] = "红装不能出售！"
_tab_string["__ITEM_PANEL__SELL_DISABLE_XIANLIANG"] = "限量装备不能出售！"
_tab_string["__ITEM_PANEL__SELL_MATERIAL_DISABLE"] = "合成材料不能出售！"
_tab_string["__ITEM_PANEL__SELL_HINT"] = "将道具拖拽到此处以出售"
_tab_string["__ITEM_PANEL__SELL_NOTE"] = "出售后可得"
_tab_string["__ITEM_PANEL__SELL_TIP_TITLE"] = "道具出售介绍"
_tab_string["__ITEM_PANEL__SELL_TIP_1"] = "1、将道具拖拽到左侧以出售并兑换积分。出售的装备品质越高，兑换的积分越多。"
_tab_string["__ITEM_PANEL__SELL_TIP_2"] = "2、一键添加会自动补齐白色、蓝色、黄色装备到出售栏。"
_tab_string["__ITEM_PANEL__SELL_TIP_3"] = "3、红装不能出售。"
_tab_string["__ITEM_PANEL__MERGE_MAIN_ITEM"] = "将该道具放在主合成栏"
_tab_string["__ITEM_PANEL__MERGE_MAIN_RED_EQUIP_ITEM"] = "将该神器放入祭坛"
_tab_string["__ITEM_PANEL__MERGE_METERIAL_ITEM"] = "将该道具放在辅合成栏"
_tab_string["__ITEM_PANEL__MERGE_METERIAL_RED_EQUIP_ITEM"] = "将该神器放入祭坛"
_tab_string["__ITEM_PANEL__MERGE_BAN1"] = "非装备道具不能合成"
_tab_string["__ITEM_PANEL__MERGE_BAN2"] = "红装、橙装不能在此合成"
_tab_string["__ITEM_PANEL__MERGE_ORANGE_QUIP_BAN2"] = "该道具不是橙装"
_tab_string["__ITEM_PANEL__MERGE_ORANGE_QUIP_BAN3"] = "该橙装不能合成"
_tab_string["__ITEM_PANEL__MERGE_RED_QUIP_BAN2"] = "该道具不是神器"
_tab_string["__ITEM_PANEL__MERGE_RED_QUIP_BAN3"] = "该神器不能放入祭坛"
_tab_string["__ITEM_PANEL__MERGE_HINT"] = "将道具拖拽到此处以合成"
_tab_string["__ITEM_PANEL__MERGE_ORANGE_EQUIP_HINT"] = "将橙装拖拽到此处以合成"
_tab_string["__ITEM_PANEL__MERGE_RED_EQUIP_HINT"] = "将神器拖拽到此处以合成"
_tab_string["__ITEM_PANEL__MERGE_TIP_TITLE"] = "装备合成介绍"
_tab_string["__ITEM_PANEL__MERGE_TIP_1"] = "1、将道具拖拽到左侧以合成新的道具。合成时有几率将装备提升到更高品质。"
_tab_string["__ITEM_PANEL__MERGE_TIP_2"] = "2、主合成栏为你想要合成出的装备部位。"
_tab_string["__ITEM_PANEL__MERGE_TIP_3"] = "3、辅合成栏为该装备提供的材料，需放入2件。"
_tab_string["__ITEM_PANEL__MERGE_TIP_4"] = "4、主合成栏放入5级以下装备时，无法合出5级以上装备。"
_tab_string["__ITEM_PANEL__MERGE_TIP_5"] = "5、合成失败后，主道具不消失，合成材料消失。"
_tab_string["__ITEM_PANEL__MERGE_TIP_ORANGE_EQUIP_TITLE"] = "橙装合成介绍"
_tab_string["__ITEM_PANEL__MERGE_TIP_ORANGE_EQUIP_1"] = "1、将橙装拖拽到左侧以合成新的橙装。合成时需要在橙装池中放入2件橙装。"
_tab_string["__ITEM_PANEL__MERGE_TIP_ORANGE_EQUIP_2"] = "2、合出的新橙装孔数为0到3孔之间。"
_tab_string["__ITEM_PANEL__MERGE_TIP_ORANGE_EQUIP_3"] = "3、合出的新橙装不会与投入的橙装重复。"
_tab_string["__ITEM_PANEL__MERGE_TIP_RED_EQUIP_TITLE"] = "神器祭坛介绍"
_tab_string["__ITEM_PANEL__MERGE_TIP_RED_EQUIP_1"] = "1、将神器拖拽到左侧以献祭新的神器。献祭时需要在祭坛中放入2件神器。"
_tab_string["__ITEM_PANEL__MERGE_TIP_RED_EQUIP_2"] = "2、献祭的新神器孔数为2到4孔之间。"
_tab_string["__ITEM_PANEL__MERGE_TIP_RED_EQUIP_3"] = "3、献祭的新神器不会与投入的神器重复。"
_tab_string["__ITEM_PANEL__XILIAN_OP"] = "将该道具放在洗炼池"
_tab_string["__ITEM_PANEL__XILIAN_BAN1"] = "非装备道具不能洗炼"
_tab_string["__ITEM_PANEL__XILIAN_BAN2"] = "该品质道具不能洗炼"
_tab_string["__ITEM_PANEL__XILIAN_HINT"] = "将道具拖拽到此处以洗炼"
_tab_string["__ITEM_PANEL__XILIAN_TIP_TITLE"] = "装备洗炼介绍"
_tab_string["__ITEM_PANEL__XILIAN_TIP_1"] = "1、装备洗炼可以重洗装备孔的属性。"
_tab_string["__ITEM_PANEL__XILIAN_TIP_2"] = "2、锁定某条属性后，该条属性不会被重洗。"
_tab_string["__ITEM_PANEL__XILIAN_TIP_3"] = "3、属性解锁，为本装备解锁一条附加属性。"
_tab_string["__ITEM_PANEL__XILIAN_TIP_4"] = "4、装备品质越高，孔的数量上限越多。"
_tab_string["__ITEM_PANEL__XILIAN_TIP_5"] = "5、孔属性档次依次为：白色、蓝色、黄色、橙色、红色。"
_tab_string["__ITEM_PANEL__XILIAN_TIP_RED_EQUIP_TITLE"] = "神器洗炼介绍"
_tab_string["__ITEM_PANEL__XILIAN_TIP_RED_EQUIP_1"] = "1、神器洗炼可以重洗神器孔的属性。"
_tab_string["__ITEM_PANEL__XILIAN_TIP_RED_EQUIP_2"] = "2、锁定某条属性后，该条属性不会被重洗。"
_tab_string["__ITEM_PANEL__XILIAN_TIP_RED_EQUIP_3"] = "3、获得的神器为2-4孔随机，无法解锁新属性。"
_tab_string["__ITEM_PANEL__XILIAN_TIP_RED_EQUIP_4"] = "4、孔属性档次依次为：白色、蓝色、黄色、橙色、红色。"
_tab_string["__ITEM_PANEL__CHONGZHU_Msg1"] = "是否花费"
_tab_string["__ITEM_PANEL__CHONGZHU_Msg2"] = "解锁一条新属性？"
_tab_string["__ITEM_PANEL__CHONGZHU_Msg3"] = "洗炼？"
_tab_string["__ITEM_PANEL__CHONGZHU_Msg4"] = "你有"
_tab_string["__ITEM_PANEL__CHONGZHU_Msg5"] = "条红色属性即将被重洗，是否继续？"
_tab_string["__ITEM_PANEL__MERGE_Msg6"] = "您有一件4红锻造属性的神器即将被献祭，是否继续？"
_tab_string["__ITEM_PANEL__GOLD_CHEST_TIP"] = "点击开启黄金宝箱。"
_tab_string["__ITEM_PANEL__SILVER_CHEST_TIP"] = "点击开启白银宝箱。"
_tab_string["__ITEM_PANEL__BRONZE_CHEST_TIP"] = "点击开启青铜宝箱。"
_tab_string["__ITEM_PANEL__JIFEN_CHEST_TIP"] = "点击开启积分宝箱。"
_tab_string["__ITEM_PANEL__GOLD_CHEST_NOTGET"] = "您还未获得黄金宝箱。"
_tab_string["__ITEM_PANEL__SILVER_CHEST_NOTGET"] = "您还未获得白银宝箱。"
_tab_string["__ITEM_PANEL__BRONZE_CHEST_NOTGET"] = "您还未获得青铜宝箱。"
_tab_string["__ITEM_PANEL__JIFEN_CHEST_NOTGET"] = "您还未获得积分宝箱。"
_tab_string["__ITEM_PANEL__OP_DISABLE_ARRANGE"] = "有装备待操作，无法整理！"
_tab_string["__LABEL_COLOR_WHITE"] = "白色"
_tab_string["__LABEL_COLOR_BLUE"] = "蓝色"
_tab_string["__LABEL_COLOR_GOLD"] = "黄色"
_tab_string["__LABEL_COLOR_RED"] = "红色"
_tab_string["__LABEL_COLOR_ORANGE"] = "橙色"
_tab_string["__ITEM_PANEL_MINI__XILIAN_INTRO"] = "随机生成装备孔的新属性"
_tab_string["__ITEM_PANEL_MINI__XILIAN_INTRO_RED_EQUIP"] = "随机生成神器孔的新属性"
_tab_string["__ITEM_PANEL__LOCK_THIS_SLOT"] = "锁定本条属性，不被重洗"
_tab_string["__ITEM_PANEL__UNLOCK_THIS_SLOT"] = "取消锁定本条属性"
_tab_string["__ITEM_PANEL__LOCK"] = "锁定"
_tab_string["__UNLOCK_MORE_CHAPTER"] = "通关更多关卡可查看。"
_tab_string["__ARMYCARD_PANEL__TIP_TITLE"] = "兵种强化介绍"
_tab_string["__ARMYCARD_PANEL__TIP_1"] = "1、兵种强化可通过消耗碎片，随机改变兵种卡自身被强化的三项属性。"
_tab_string["__ARMYCARD_PANEL__TIP_2"] = "2、您可以根据出兵策略的需要，尝试各种强化属性的组合。"
_tab_string["__TOWERCARD_PANEL__TIP_TITLE"] = "防御塔强化介绍"
_tab_string["__TOWERCARD_PANEL__TIP_1"] = "1、防御塔升到5级后可通过消耗碎片解锁属性强化，拥有额外三项属性。"
_tab_string["__TOWERCARD_PANEL__TIP_2"] = "2、您可以根据策略的需要，尝试各种强化属性的组合。"
_tab_string["__TOWERCARD_PANEL__TIP_3"] = "3、月卡玩家每日可免费强化任意防御塔6次，不消耗碎片和积分。"
_tab_string["__SHENQI_CRTSTAL"] = "神器晶石"
_tab_string["__SHENQI_CRTSTAL_INTRODUCE"] = "每100个神器晶石，可以开启1个神器锦囊。"
_tab_string["__FB_EXCHANGE"] = "红装兑换券"
_tab_string["__FB_EXCHANGE_INTRODUCE"] = "在所有的神器中挑选一件4孔神器。（首充，特殊活动以及军团限定的神器除外）"
_tab_string["__FB_CHOUJIANGTICKET"] = "抽奖免费券"
_tab_string["__FB_CHOUJIANGTICKET_INTRODUCE"] = "可在抽奖活动中免费抽取一次。"
_tab_string["__FB_EXCHANGE_SELECT_ONE"] = "使用红装兑换券选取了"
_tab_string["__FB_EXCHANGE_QUNYINGGE_REWARD"] = "通关群英阁获得"
_tab_string["__CANGBAOTU_NORMAL_INTRODUCE"] = "每50张藏宝图碎片，可以开启一次宝物宝箱。"
_tab_string["__CANGBAOTU_NORMAL_INTRODUCE_DETAIL_1"] = "娱乐专区的各地图通关，均可以随机获得藏宝图碎片。"
_tab_string["__CANGBAOTU_NORMAL_INTRODUCE_DETAIL_2"] = "每50张藏宝图碎片，可以拼成一张完整的藏宝图，从而开启一次宝物专属宝箱。"
_tab_string["__CANGBAOTU_NORMAL_INTRODUCE_DETAIL_3"] = "宝物宝箱可随机获得宝物碎片以及娱乐专区的专属英雄黄忠、甄姬的碎片。"
_tab_string["__CANGBAOTU_HIGH_INTRODUCE"] = "每100张高级藏宝图碎片，可以开启一次高级宝物宝箱。"
_tab_string["__CANGBAOTU_HIGH_INTRODUCE_DETAIL_1"] = "娱乐专区的各地图通关，均可以随机获得高级藏宝图碎片。"
_tab_string["__CANGBAOTU_HIGH_INTRODUCE_DETAIL_2"] = "每100张高级藏宝图碎片，可以拼成一张完整的高级藏宝图，从而开启一次宝物专属高级宝箱。"
_tab_string["__CANGBAOTU_HIGH_INTRODUCE_DETAIL_3"] = "高级宝物宝箱可随机获得宝物碎片以及娱乐专区的专属英雄黄忠、甄姬的碎片。"
_tab_string["__HERO_WAKEN"] = "英雄配装觉醒"
_tab_string["__HERO_WAKEN_HINT"] = "英雄每装备一件4孔全红锻造属性的神器，可获得一层神兽之力。"
_tab_string["__TURNTABLE__INTRO_TITLE"] = "消费转盘活动介绍"
_tab_string["__TURNCHOUJIANG__INTRO_TITLE"] = "夺宝活动介绍"
_tab_string["__QIANGHUA_FREE_TICKET_INTRODUCE"] = "可免费强化任意防御塔1次，不消耗碎片和积分。"
_tab_string["__GROUP_IRON_INTRODUCE"] = "军团材料，可用来建造军团建筑和升级科技。"
_tab_string["__GROUP_WOOD_INTRODUCE"] = "军团材料，可用来建造军团建筑和升级科技。"
_tab_string["__GROUP_FOOD_INTRODUCE"] = "军团材料，可用来建造军团建筑和升级科技。"
_tab_string["__GROUP_COIN_INTRODUCE"] = "军团材料，可在军团市场里兑换军团宝箱。"
_tab_string["__GROUP_MARKET__DONATE_TIP_TITLE"] = "军团市场介绍"
_tab_string["__GROUP_MARKET__DONATE_TIP_1"] = "1、玩家每天可捐献已满级的战术卡碎片和英雄将魂。VIP等级越高，每天可捐献的次数越多。"
_tab_string["__GROUP_MARKET__DONATE_TIP_2"] = "2、每次捐献需消耗一定数量的碎片和游戏币。"
_tab_string["__GROUP_MARKET__DONATE_TIP_3"] = "3、捐献战术卡碎片可获得5军团币。捐献英雄将魂可获得15军团币。"
_tab_string["__GROUP_MARKET__DONATE_TIP_4"] = "4、每次捐献都会获得随机数量的军团资源奖励。"
_tab_string["__GROUP_MARKET__DONATE_TIP_5"] = "5、每日0点重置可捐献次数。"
_tab_string["__GROUP_MARKET__DONATE_TIP_6"] = "6、100个军团币可开启一次军团宝箱。军团宝箱有几率开出独一无二的神器和橙装。"
_tab_string["__GROUP_BUY_COUNT"] = "士气提升"
_tab_string["__GROUP_BUY_COUNT_INTRODUCE"] = "军团会长、助理可为军团提振士气，购买双倍战力，本军团今日可以获得1次额外的军团副本战斗次数。\n当前民居等级为%d级，需要消耗: 铁*%d, 木材*%d, 粮食*%d"
_tab_string["__GROUP_REDPACKET_TIP_TITLE"] = "军团红包介绍"
_tab_string["__GROUP_REDPACKET_TIP_NUM"] = "请选择红包个数"
_tab_string["__GROUP_REDPACKET_TIP_1"] = "1、VIP3及以上的玩家，每天可以发放红包。VIP等级越高，每天可发放的次数越多。"
_tab_string["__GROUP_REDPACKET_TIP_2"] = "2、红包共有两个档位：88游戏币/5个、288游戏币/20个。"
_tab_string["__GROUP_REDPACKET_TIP_3"] = "3、红包发送后，发放者可立即获得随机军团资源奖励，同时军团成员可领取红包。"
_tab_string["__GROUP_REDPACKET_TIP_4"] = "4、红包领取后可随机获得奖励。"
_tab_string["__GROUP_REDPACKET_TIP_5"] = "5、红包发放后，需在48小时内领完，过期消失。"
_tab_string["__GROUP_REDPACKET_TIP_6"] = "6、需加入军团24小时以上才能发放或领取红包。"
_tab_string["__GROUP_REDPACKET_TIP_7"] = "7、每日0点重置发红包次数。"
_tab_string["__GROUP_REDPACKET_SEND"] = "发送了一个红包"
_tab_string["__GROUP_REDPACKET_DETAIL"] = "查看领取详情"
_tab_string["__GROUP_REDPACKET_RECEIVE_YOU"] = "您已领取该红包"
_tab_string["__GROUP_REDPACKET_RECEIVE_EMPTY"] = "红包已被领完"
_tab_string["__GROUP_REDPACKET_RECEIVE_DETAIL_SOME"] = "%d个红包，已领取%d/%d"
_tab_string["__GROUP_REDPACKET_RECEIVE_DETAIL_ALL"] = "%d个红包，已全部领完"



_tab_string["ios_game_name"] = "策马守天关"
_tab_string["ios_share_wxchat_title"] = "策马守天关"
_tab_string["__BLANK__"] = ""
_tab_string["__FONTC__"] = "coh_2016.ttf"
_tab_string["__FONTC1__"] = "coh_2016"
_tab_string["cmd_40105"] = "￥%d.00"
_tab_string["__RMB__"] = "￥"
_tab_string["__BTN_TEST"] = "测试按钮"
_tab_string["__NETBATTLEFIELD_VICTORY_TEXT__"] = "战斗胜利"
_tab_string["__NETBATTLEFIELD_DEFEATEED_TEXT__"] = "战斗失败"

_tab_string["__DEFEATEED_TEXT__"] = "战败了，逃回我方主城"
_tab_string["__TOWN_DEFEATEED_TEXT__"] = "陷落"
_tab_string["__VICTORY_TEXT__"] = "取得战斗的胜利"
_tab_string["__NEED_MANA__"] = "魔法值不足"
_tab_string["__NEED_ESCAPE__"] = "被包围时无法使用"
_tab_string["__NEED_COOLDOWN__"] = "技能尚未冷却"
_tab_string["__SUPER_COUNTER__"] = "无限反击"
_tab_string["__IMMOBILIZE__"] = "定身"
_tab_string["__STUN__"] = "眩晕"
_tab_string["__INVINCIBLE__"] = "无敌"
_tab_string["__SILENT__"] = "沉默"
_tab_string["__STONE__"] = "石化"
_tab_string["__REMOVE_IMMOBILIZE__"] = "解除定身"
_tab_string["__REMOVE_STUN__"] = "解除眩晕"
_tab_string["__REMOVE_INVINCIBLE__"] = "无敌消失"
_tab_string["__REMOVE_SILENT__"] = "沉默消失"
_tab_string["__REMOVE_STONE__"] = "解除石化"
_tab_string["__RE_QIANGHUA__"] = "重新强化"
_tab_string["__DRAWCARD__"] = "抽取"
_tab_string["__DRAWCARDONCE__"] = "抽取一次"
_tab_string["__RE_DRAWCARD__"] = "再抽一次"
_tab_string["__RE_EXCHANGE__"] = "再兑一次"
_tab_string["__RE_DRAWCARD_FIVE__"] = "再抽五次"
_tab_string["__RE_EXCHANGE_FIVE__"] = "再兑五次"
_tab_string["__RE_EXCHANGE2__"] = "重抽一次"

_tab_string["hero"] = "英雄"

_tab_string["__GAME_BEGINNING__"] = "建安十三年，决定三国鼎立局势的赤壁之战刚刚结束，中原大地突然遭受外域魔物入侵。三方大军无法抵挡，战火肆虐生灵涂炭。生死存亡之际，南华仙人现身，号召各路英雄集结。想要逆转这场抵抗外域魔物入侵的战争，必须寻得上古宝物【天关塔诀】，它被藏匿于鬼谷幻境之中，被重重机关及神兽守护。"
_tab_string["__GAME_BEGINNING2__"] = "群雄混战，民不聊生。。。乱世必出异象，上古传说中的二件宝物重现世间。 其一为《天关塔诀》秘籍，传为上古巧匠所著，精研其建造秘术，即可瓦解千军万马。 另一件为远古铁人神像，此物附有来自未知世界之科学技能，向其祈福可获得战术点拨。 一旦发挥这2件宝物的最大威力，君王统帅们将会战无不胜！攻无不克！ 试看中原大地谁能平定战乱，安邦定国！ 欢迎来到【策马守天关】的乱世幻境！"

_tab_string["RSDYZ_Attack"] = "闯关"
_tab_string["RSDYZ_Def"] = "守关"
_tab_string["RSDYZ_Attack_Go"] = "开始闯关"
_tab_string["RSDYZ_Def_Set"] = "配置将领"
_tab_string["RSDYZ_Def_Reset"] = "重新配置将领"
_tab_string["RSDYZ_Choice_Atk"] = "选择闯关英雄"
_tab_string["RSDYZ_Choice_Def"] = "选择3名英雄守关"
_tab_string["RSDYZ_Now_Def"] = "当前守关队伍"
_tab_string["RSDYZ_Public"] = "过关斩将公告"
_tab_string["RSDYZ_Public_Def"] = "燃烧的远征于9月18日开放测试，第一周可以获得宝石碎片双倍奖励！"
_tab_string["RSDYZ_Shop"] = "兑换奖励"
_tab_string["RSDYZ_Rest"] = "今天剩余令牌:"
_tab_string["RSDYZ_Defence_OK"] = "击退玩家"
_tab_string["RSDYZ_Defence_POS"] = "位置"
_tab_string["RSDYZ_Defence_TIME"] = "时间"
_tab_string["RSDYZ_Defence_GET"] = "收益"
_tab_string["RSDYZ_Defence_GUOGUAN"] = "过关(消灭主将)"
_tab_string["RSDYZ_Defence_ZHANJIANG"] = "斩将(消灭玩家)"
_tab_string["RSDYZ_BUY_POINTS"] = "购买令牌"
_tab_string["RSDYZ_BUY_POINTS_10_10"] = "20游戏币=5令牌,当天有效"
_tab_string["RSDYZ_RECONNECT"] = "重新连接"
_tab_string["RSDYZ_LEAVEGAME"] = "离开游戏"
_tab_string["RSDYZ_All_DEAD"] = "您的英雄已全部阵亡"
_tab_string["RSDYZ_All_KILL"] = "您已闯过所有关卡"
_tab_string["RSDYZ_Cal"] = "本次过关斩将结算："
_tab_string["RSDYZ_ERROR"] = "发生错误:"
_tab_string["RSDYZ_DEF_GX"] = "守关贡献"
_tab_string["RSDYZ_HOW2PLAY"] = "过关斩将玩法说明"
_tab_string["RSDYZ_NO_NETWORK"] = "网络连接中断"
_tab_string["RSDYZ_NO_NETWORK1"] = "当前无网络,不能进入过关斩将"
_tab_string["RSDYZ_NO_NETWORK2"] = "过关斩将服务器未响应"
_tab_string["RSDYZ_WAIT"] = "继续等待"
_tab_string["RSDYZ_WAIT1"] = "网络消息【"
_tab_string["RSDYZ_WAIT2"] = "】没有响应"
_tab_string["RSDYZ_ERROR_HAPPENED"] = "发生游戏错误，请截图找游戏管理。"
_tab_string["RSDYZ_Attack_End"] = "结束闯关"
_tab_string["RSDYZ_ErrorCode30336_iTag2"] = "之前设置的防守将领未能生效"
_tab_string["RSDYZ_ErrorCode4"] = "已经登录了"
_tab_string["RSDYZ_ErrorCode5"] = "没登录过"
_tab_string["RSDYZ_ErrorCode100"] = "没有领地数据"
_tab_string["RSDYZ_ErrorCode101"] = "多个领地数据"
_tab_string["RSDYZ_ErrorCode102"] = "请求的数据和登录的账号不一致"
_tab_string["RSDYZ_ErrorCode103"] = "没有相关数据"
_tab_string["RSDYZ_ErrorCode104"] = "数据不唯一"
_tab_string["RSDYZ_ErrorCode105"] = "数据错误"
_tab_string["RSDYZ_ErrorCode106"] = "已经在战役中"
_tab_string["RSDYZ_ErrorCode107"] = "战役没开始"
_tab_string["RSDYZ_ErrorCode108"] = "对方处于保护状态"
_tab_string["RSDYZ_ErrorCode109"] = "请求的战役不存在"
_tab_string["RSDYZ_ErrorCode110"] = "没领地点数"
_tab_string["RSDYZ_ErrorCode800"] = "数据库操作失败"
_tab_string["RSDYZ_ErrorCode801"] = "领地币不够"
_tab_string["RSDYZ_ErrorCode4441"] = "没登录过领地"
_tab_string["RSDYZ_ErrorCode4442"] = "当前有事件未完成"
_tab_string["RSDYZ_ErrorCode4443"] = "当前事件状态不对"
_tab_string["RSDYZ_ErrorCode4444"] = "lua参数错误"

_tab_string["RSDYZ_how_attack"] = "用自己的英雄组合(每次最多上场一主将和两副将),击败别的玩家设置的防守英雄组合地图主将来获得符石,一旦己方英雄阵亡后能用自己别的英雄继续战斗,直到你的所有英雄全部阵亡或者击败所有玩家和主将。"
_tab_string["RSDYZ_how_def"] = "选择你的一个主将和两个副将参与防守,这些将领会在离线过程中由电脑AI控制,当别的玩家在闯关过程中会阻挡他们前进的道路,一旦你的防守将领成功防守了玩家的进攻(战斗中消灭了进攻玩家的英雄们),你将获得符石。"

_tab_string["__ATTR__power"] = "伤害"
_tab_string["__ATTR__def"] = "护甲值"
_tab_string["__ATTR__mxhp"] = "生命上限"
_tab_string["__ATTR__mp"] = "法力"
_tab_string["__ATTR__Atk"] = "攻击力"
_tab_string["__ATTR__AtkRange"] = "攻击力"
_tab_string["__ATTR__counter"] = "反击次数"
_tab_string["__ATTR__counterpower"] = "反击伤害"
_tab_string["__ATTR__castpower"] = "技能伤害"
_tab_string["__ATTR__healpower"] = "治疗效果"
_tab_string["__ATTR__move"] = "移动范围"
_tab_string["__ATTR__siege"] = "攻城伤害"
_tab_string["__ATTR__activity"] = "攻速"
_tab_string["__ATTR__hpSteal"] = "吸血"
_tab_string["__ATTR__attackHeal"] = "攻击回血"
_tab_string["__ATTR__exhp"] = "护盾"
_tab_string["__ATTR__eliteDef"] = "精英减伤"
_tab_string["__ATTR__meleeDef"] = "近战减伤"
_tab_string["__ATTR__rangeDef"] = "远程减伤"
_tab_string["__ATTR__pvpEliteDef"] = "(pvp)精英减伤"
_tab_string["__ATTR__AtkBounce"] = "附加攻击"
_tab_string["__ATTR__AllCooldown"] = "所有冷却"
_tab_string["__ATTR__CanNotCounter"] = "无法反击"
_tab_string["__ATTR__Space_Ground"] = "地面单位"
_tab_string["__ATTR__Space_Fly"] = "空中单位"
_tab_string["__ATTR__AtkSpace_Type"] = "攻击类型"
_tab_string["__ATTR__AtkSpace_Ground"] = "对地"
_tab_string["__ATTR__AtkSpace_Fly"] = "对空"
_tab_string["__ATTR__AtkSpace_FlyGround"] = "对地对空"
_tab_string["__ATTR__EscapePunish"] = "怪物生命点"
_tab_string["__ATTR__KillGold"] = "怪物金币"
_tab_string["__ATTR__Wave"] = "波"
_tab_string["__ATTR__LastWave"] = "最后一波"

--geyachao: TD的显示属性
_tab_string["__ATTR__attr"] = "属性"
_tab_string["__ATTR__hp_max"] = "生命值"
_tab_string["__Attr_Hint_atk"] = "攻击"
_tab_string["__Attr_Hint_atk_min"] = "最小攻击"
_tab_string["__Attr_Hint_atk_max"] = "最大攻击"
_tab_string["__Attr_Hint_atk_interval"] = "攻击间隔"
_tab_string["__Attr_Hint_atk_speed"] = "攻击速度"
_tab_string["__Attr_Hint_move_speed"] = "移动速度"
_tab_string["__Attr_Hint_move_speed_short"] = "移速"
_tab_string["__Attr_Hint_atk_radius"] = "攻击范围"
_tab_string["__Attr_Hint_def_physic"] = "物理防御"
_tab_string["__Attr_Hint_def_magic"] = "法术防御"
_tab_string["__Attr_Hint_dodge_rate"] = "物理闪避"
_tab_string["__Attr_Hint_dodge_magic_rate"] = "法术闪避"
_tab_string["__Attr_Hint_hit_rate"] = "命中几率"
_tab_string["__Attr_Hint_crit"] = "暴击"
_tab_string["__Attr_Hint_crit_rate"] = "暴击几率"
_tab_string["__Attr_Hint_crit_value"] = "暴击伤害"
_tab_string["__Attr_Hint_crit_immue"] = "暴击免伤"
_tab_string["__Attr_Hint_kill_gold"] = "灭敌奖励"
_tab_string["__Attr_Hint_escape_punish"] = "逃怪惩罚"
_tab_string["__Attr_Hint_hp_restore"] = "回血速度"
_tab_string["__Attr_Hint_suck_blood_rate"] = "攻击吸血"
_tab_string["__Attr_Hint_rebirth_time"] = "复活时间"
_tab_string["__Attr_Hint_AI_attribute"] = "AI行为"
_tab_string["__Attr_Hint_active_skill_cd_delta"] = "战术技能冷却"
_tab_string["__Attr_Hint_passive_skill_cd_delta"] = "被动技能冷却"
_tab_string["__Attr_Hint_active_skill_cd_delta_rate"] = "战术技能冷却"
_tab_string["__Attr_Hint_passive_skill_cd_delta_rate"] = "被动技能冷却"
_tab_string["__Attr_Hint_hp_restore_delta_rate"] = "回血效果"
_tab_string["__Attr_Hint_cd_delta_rate"] = "冷却"
_tab_string["__Attr_Hint_active_attack"] = "主动攻击"
_tab_string["__Attr_Hint_passive_attack"] = "不主动攻击"
_tab_string["__Attr_Hint_army_discount"] = "价格"
_tab_string["__Attr_Hint_army_cooldown"] = "发兵间隔"
_tab_string["__Attr_Hint_skill_cooldown"] = "发动间隔"
_tab_string["__Attr_Hint_skill_damage"] = "伤害"
_tab_string["__Attr_Hint_skill_range"] = "范围"
_tab_string["__Attr_Hint_skill_chaos"] = "混乱持续"
_tab_string["__Attr_Hint_skill_num"] = "数量"
_tab_string["__Attr_Hint_skill_poison"] = "毒箭"
_tab_string["__Attr_Hint_skill_lasttime"] = "持续时间"
_tab_string["__Attr_Hint_damage_type"] = "伤害类型"
_tab_string["__Attr_Hint_poision_time"] = "中毒时间"
_tab_string["__Attr_Hint_lianshe_rate"] = "连射几率"
_tab_string["__Attr_Hint_fireball_range"] = "巨大火球范围"
_tab_string["__Attr_Hint_slow_time"] = "减速时间"
_tab_string["__Attr_Hint_stun_time"] = "电晕时间"
_tab_string["__Attr_Hint_jopao_rate"] = "巨炮触发几率"
_tab_string["__Attr_Hint_sandan_num"] = "散弹数量"
_tab_string["__Attr_Hint_jitui_range"] = "击退距离"
_tab_string["__Attr_Hint_add_gold"] = "每秒产出金"
_tab_string["__Attr_Hint_qiangji_range"] = "强击光环范围"
_tab_string["__Attr_Hint_qiangji_atk"] = "强击光环攻击"
_tab_string["__Attr_Hint_leigu_range"] = "擂鼓振奋范围"
_tab_string["__Attr_Hint_leigu_atkrange"] = "擂鼓振奋攻速"
_tab_string["__Attr_Hint_liaoshangshu_range"] = "疗伤术范围"
_tab_string["__Attr_Hint_liaoshangshu_hprestore"] = "疗伤术回血"
_tab_string["__Attr_Hint_dici_range"] = "刺骨长钉范围"
_tab_string["__Attr_Hint_dici_stun_time"] = "刺骨长钉眩晕"


_tab_string["gold"] = "金"
_tab_string["dodge_physic"] = "物闪"
_tab_string["dodge_magic"] = "法闪"
_tab_string["blood"] = "生命"
_tab_string["__RebirthMinValue"] = "最低"

_tab_string["__Unit1003_Name"] = "天马骑士"
_tab_string["__Unit1003_Hint"] = "天马骑士:\n    行动力迅速的飞行单位，克制绝大部分步兵"




_tab_string["__ExtraQuest__"] = "额外目标"
_tab_string["__LOOK_AT__"] = "查看位置"
_tab_string["__Reward__"] = "奖励"
_tab_string["__FirstTimeReward__"] = "首通奖励"
_tab_string["__RandDrop__"] = "随机掉落"
_tab_string["__Get__"] = "领取"
_tab_string["__Read__"] = "查看"
_tab_string["__Exchange__"] = "兑换"
_tab_string["__GetReward__"] = "领取奖励"
_tab_string["__target__"] = "目标"
_tab_string["__MAStERY__"] = "战术技能"
_tab_string["__AutoRelease__"] = "自动释放"
_tab_string["__PassSkil__"] = "被动技能"
_tab_string["__MAStERY_REST__"] = "剩余点数"
_tab_string["__MAStERYBOOK"] = "选择战术技能"
_tab_string["__UPGRADEBFSKILL"] = "选择材料升级战术技能卡"
_tab_string["hero_levelup"] = "你的英雄升到"
_tab_string["hero_levelMax"] = "你的英雄已经满级了"
_tab_string["hero_level_unlockskill"] = "级解锁此技能"
_tab_string["hero_unlockskill"] = "学会新技能"
_tab_string["hero_starupintro"] = "升星可以提升英雄等级上限。"
_tab_string["hero_starupintro_full"] = "将魂用于升星英雄。升星可以提升英雄等级上限，并解锁新的技能。"
_tab_string["hero_starupintro_unlock"] = "解锁或升星"
_tab_string["hero_starupsuccess"] = "升星成功！"
_tab_string["hero_skilllevelMax"] = "技能等级不能超过英雄等级"
_tab_string["hero_skilllevelFalid"] = "技能升级失败"
_tab_string["hero_evelnotfull"] = "英雄等级不够！"
_tab_string["hero_lessSoulstone"] = "英雄将魂不足！"
_tab_string["hero_materialDisableEquip"] = "合成材料不能装备！"
_tab_string["tactic_lessDebris"] = "碎片不足"
_tab_string["army_unlocksuccess"] = "解锁成功"
_tab_string["army_levelupsuccess"] = "升级成功"
_tab_string["__DISIABLE_UNLOCK_TACTICS"] = "特殊卡片，必须先获得才能升级"
_tab_string["__UPGRADESTAR"] = "升星"
_tab_string["__UPGRADE"] = "升级"
_tab_string["__UNLOCK"] = "解锁"
_tab_string["__OPEN"] = "开启"
_tab_string["__UNLOCK_REQUIRE"] = "解锁需求"
_tab_string["__UPGRADE_REQUIRE"] = "升级需求"
_tab_string["__UPGRADEBFSKILL_REQUIRELV"] = "本卡片从"
_tab_string["__UPGRADEBFSKILL_REQUIRELV2"] = "星开始可以升级"
_tab_string["__UPGRADEBFSKILL_OR"] = "或"
_tab_string["__UPGRADEBFSKILL_CANT"] = "已升到最大等级"
_tab_string["__UPGRADEBFSTAR_CANT"] = "已升到最大星级"
_tab_string["__UsedSkillBook"] = "(已配置)"
_tab_string["__UsedSkillBookNo"] = "(未配置)"
_tab_string["__GetAllReward"] = "已领取全部奖励"
_tab_string["__StarEffect"] = "星效果"
_tab_string["__GetAllReward_NewGuideMap"] = "新任务：历练【天关塔诀】，征战历史，改变未来！"
_tab_string["__LvNowAttr"] = "当前等级效果"
_tab_string["__LvNextAttr"] = "下一等级效果"
_tab_string["_TEXT_YEAR_"] = "年"
_tab_string["_TEXT_MONTH_"] = "月"
_tab_string["_TEXT_DAY_"] = "日"
_tab_string["_TEXT_Jump"] = "跳转"
_tab_string["_TEXT_web_details"] = "详情请见网页"
_tab_string["__Minute"] = "分"
_tab_string["__Second"] = "秒"
_tab_string["__Today"] = "今日"
_tab_string["__Yesterday"] = "昨日"
_tab_string["__Rate"] = "" --字体原因，显示"倍"字效果很丑，还是不显示了
_tab_string["__Bei"] = "倍"
_tab_string["__Step"] = "层"
_tab_string["__SecondToRelive"] = "秒后复活"
_tab_string["__SecondToChange"] = "秒后变异"
_tab_string["__SecondToDie"] = "已阵亡"
_tab_string["__HaveToken"] = "已领取"
_tab_string["__HaveFinishThis"] = "已完成该"
_tab_string["__Loading___"] = "加载... "
_tab_string["__Progress___"] = "进度"
_tab_string["__Military___"] = "军饷"
_tab_string["__TodayRewardCount"] = "今日可领奖次数"
_tab_string["__TodayBuyBattleCount"] = "购买领奖次数"
_tab_string["__TodayRewardFinish"] = "今日可领奖次数已用完"
_tab_string["__LoseNoReward"] = "挑战失败"
_tab_string["__WEELWARHINT1"] = "本局共有"
_tab_string["__WEELWARHINT2"] = "个英雄存活，通关时间额外减少"
_tab_string["__TodayBattleCount"] = "今日可挑战次数"
_tab_string["__TodayBattleFinish"] = "今日可挑战次数已用完"
_tab_string["__TodayExchangeFinish"] = "今日可捐献次数已用完"
_tab_string["__TodayBattleCountBuyNotice"] = "是否消耗%d游戏币额外增加1次今日%s副本可领奖次数？"
_tab_string["__TodayBuySignInGift"] = "是否消耗%d%s购买此特惠礼包？"



_tab_string["__TEXT_CHALLENGE_EXIT"] = "离开秘境"
_tab_string["__TEXT_CHALLENGE_ROLL_KEY"] = "抽1张1令牌"
_tab_string["__TEXT_CHALLENGE_ROLL_GOLD"] = "抽一张100金"

_tab_string["__TEXT_FIGHT_COUNT"] = "累计胜场："
_tab_string["__TEXT_FIGHT_TIP"] = "累计更高胜场,可以在秘境中获得更好的宝物。"

_tab_string["__TEXT_SOLDIER_FIGHTER"] = "步兵"
_tab_string["__TEXT_SOLDIER_SHOOTER"] = "射手"
_tab_string["__TEXT_SOLDIER_RIDER"] = "骑兵"
_tab_string["__TEXT_SOLDIER_WIZARD"] = "法师"
_tab_string["__TEXT_SOLDIER_LEGEND"] = "圣兽"
_tab_string["__TEXT_SOLDIER_MACHINE"] = "机械"
_tab_string["__TEXT_SOLDIER_OTHER"] = "其他"
_tab_string["__TEXT_SOLDIER_TOWER"] = "塔"

_tab_string["__TEXT_VictoryCondition"] = "胜利条件 : "
_tab_string["__TEXT_PVP_BattleConfig"] = "阵容配置"
_tab_string["__TEXT_PVP_Create"] = "创建"
_tab_string["__TEXT_PVP_Leave"] = "离开"
_tab_string["__TEXT_PVP_Room"] = "房间"
_tab_string["__TEXT_PVP_WinCal"] = "战绩结算"
_tab_string["__TEXT_PVP_ComputerDoNotCalWin"] = "（电脑局不计入胜场）"
_tab_string["__TEXT_PVP_NotEnoughTimeDoNotCalWin"] = "（游戏不足3分钟，非有效局）"
_tab_string["__TEXT_PVP_NoRoom"] = "暂无房间"
_tab_string["__TEXT_PVP_NoUserBoardData"] = "还未产生玩家排行榜数据"
_tab_string["__TEXT_PVP_Everyday"] = "每日"
_tab_string["__TEXT_PVP_NoRoom_OpenTime_Normal"] = "娱乐房开放时段：每天"
_tab_string["__TEXT_PVP_NoRoom_OpenTime_Match"] = "竞技房开放时段：每天"
_tab_string["__TEXT_PVP_NoRoom_OpenTime_Arena"] = "擂台赛开放时段：每天"
_tab_string["__TEXT_PVP_NoRoom_OpenTime_MultyPve"] = "挑战魔龙开放时段：每天"
_tab_string["__TEXT_PVP_NoRoom_OpenTime_MultyPve_Group"] = "挑战南华仙尊开放时段：每周五-周日"
_tab_string["__TEXT_PVP_NoRoom_OpenTime_Standard_Normal"] = "（北京时间：0:00 - 24:00）"
_tab_string["__TEXT_PVP_NoRoom_OpenTime_Standard_Match"] = "（北京时间：12:00 - 13:00, 18:00 - 20:00）"
--_tab_string["__TEXT_PVP_NoRoom_OpenTime_Standard_Arena"] = "（北京时间：12:00 - 13:00, 18:30 - 20:30）"
_tab_string["__TEXT_PVP_NoRoom_OpenTime_Standard_MultyPve"] = "（北京时间：12:00 - 14:00, 20:00 - 23:00）"
_tab_string["__TEXT_PVP_NoRoom_OpenTime_Standard_MultyPve_Group"] = "（北京时间：12:00 - 14:00, 20:00 - 23:00）"
_tab_string["__TEXT_PVP_NoRoom_OpenTime_RenZuWuDi"] = "挑战伊利丹开放时段：每天"
_tab_string["__TEXT_PVP_NoRoom_OpenTime_Standard_RenZuWuDi"] = "（北京时间：18:00 - 24:00）"
_tab_string["__TEXT_PVP_SupportNetEnvironment"] = "" --"目前支持网络: 电信WiFi , 移动4G"
_tab_string["__TEXT_NetDelayTime"] = "延时"
_tab_string["__TEXT_NetConnecting"] = "正在连接中..."
_tab_string["__TEXT_GettingRoomLists"] = "正在获取房间列表..."
_tab_string["__TEXT_GettingRoomDetails"] = "正在获取房间信息..."
_tab_string["__TEXT_GettingRewarss"] = "正在获取奖励..."
_tab_string["__TEXT_NetLogining"] = "正在登入中..."
_tab_string["__TEXT_NetLoginSuccess"] = "登入成功"
_tab_string["__TEXT_ConnectFail_ErrorCode"] = "连接失败！错误码: "
_tab_string["__TEXT_LoginFail_ErrorCode"] = "登入失败！错误码: "
_tab_string["__TEXT_NetRoleIconGetting"] = "正在获取头像..."
_tab_string["__TEXT_PVP_ConfirmConfig"] = "确认配置"
_tab_string["__TEXT_PVP_RoomCreater"] = "房主"
_tab_string["__TEXT_PVP_RoomNotReady"] = "未准备"
_tab_string["__TEXT_PVP_RoomReady"] = "已准备"
_tab_string["__TEXT_PVP_Ready"] = "准备"
_tab_string["__TEXT_PVP_SROOM"] = "的房间"
_tab_string["__TEXT_PVP_SARENA"] = "的擂台"
_tab_string["__TEXT_PVP_VS_Computer1"] = "简单电脑"
_tab_string["__TEXT_PVP_VS_Computer2"] = "中等电脑"
_tab_string["__TEXT_PVP_VS_Computer3"] = "困难电脑"
_tab_string["__TEXT_PVP_VS_Computer4"] = "变态电脑"
_tab_string["__TEXT_PVP_VS_Computer0"] = "电脑"
_tab_string["__TEXT_PVP_VS_DiffA"] = "简单"
_tab_string["__TEXT_PVP_VS_Diff1"] = "普通"
_tab_string["__TEXT_PVP_VS_Diff2"] = "困难"
_tab_string["__TEXT_PVP_VS_Diff3"] = "噩梦"
_tab_string["__TEXT_PVP_VS_Diff0"] = "难度"
_tab_string["__TEXT_PVP_ConfigSuccess"] = "阵容配置成功！"
_tab_string["__TEXT_PVP_NotYetConfig"] = "您还未配置"
_tab_string["__TEXT_PVP_Full"] = "人数已满"
_tab_string["__TEXT_PVP_RoomFull"] = "该房间人数已满！"
_tab_string["__TEXT_PVP_RoomInGame"] = "该房间正在游戏中！"
_tab_string["__TEXT_PVP_DisConnect"] = "您已断开连接，请重新登入"
_tab_string["__TEXT_PVP_OnlyRoomCreaterCanBegin"] = "只有房主才能开始游戏"
_tab_string["__TEXT_PVP_AllPlayerReadyCanBegin"] = "所有玩家都已准备才能开始游戏"
_tab_string["__TEXT_PVP_WaitingOtherCanBegin"] = "等待其它玩家加入"
_tab_string["__TEXT_PVP_AllPlayerReadyDisabelModify"] = "所有玩家已准备不能修改此配置"
_tab_string["__TEXT_PVP_ReadyStateNoConfig"] = "您已准备，不能配置阵容"
_tab_string["__TEXT_PVP_BeginBattle"] = "开始对战"
_tab_string["__TEXT_PVP_BeginGame"] = "开始游戏"
--_tab_string["__TEXT_PVP_MapIntroduce"] = "地图介绍"
_tab_string["__TEXT_PVP_MyConfig"] = "我的阵容"
_tab_string["__TEXT_PVP_AllyConfig"] = "队友阵容"
_tab_string["__TEXT_PVP_IsEquip"] = "携带装备"
_tab_string["__TEXT_PVP_CurrentCfgEquip"] = "本局可携带装备"
_tab_string["__TEXT_PVP_CurrentCfgNoEquip"] = "本局不可携带装备"
_tab_string["__TEXT_PVP_LefeTime"] = "剩余时间"
_tab_string["__TEXT_PVP_IsWaitingPlayer"] = "正在等待玩家..."
_tab_string["__TEXT_PVP_Shu"] = "蜀国"
_tab_string["__TEXT_PVP_Wei"] = "魏国"
_tab_string["__TEXT_PVP_Wu"] = "吴国"
_tab_string["__TEXT_PVP_Atk"] = "进攻"
_tab_string["__TEXT_PVP_Def"] = "防守"
_tab_string["__TEXT_PVP_Online"] = "在线"
_tab_string["__TEXT_PVP_KickOutRoom"] = "您被房主踢出房间！"
_tab_string["__TEXT_PVP_CfgNotFilled"] = "您还未配置阵容或阵容不完整，请先配置阵容"
_tab_string["__TEXT_PVP_CfgMin1Tower"] = "您需要携带至少一个塔！"
_tab_string["__TEXT_PVP_CfgMin1Tactic"] = "您需要携带至少一个兵种！"
_tab_string["__TEXT_PVP_PvpCoinNotEnough"] = "您的竞技场兵符数量不足！\n（点击上方兵符按钮，每天可领取一次）"
_tab_string["__TEXT_PVP_PvpBattleClosed"] = "当前时段未开放竞技场对战！"
_tab_string["__TEXT_PVP_PvpMultyBattleClosed"] = "当前时段未开放挑战魔龙！"
_tab_string["__TEXT_PVP_PvpMultyBattleClosed_Group"] = "当前时段未开放挑战南华仙尊！"
_tab_string["__TEXT_PVP_PvpMultyBattleClosed_Group_Today"] = "每周五-周日开放秘境试炼！"
_tab_string["__TEXT_PVP_PvpCheat"] = "系统检测到您存在作弊行为！禁止对战！"
_tab_string["__TEXT_PVP_PvpBrush1"] = "对方已挂起免战牌！"
_tab_string["__TEXT_PVP_PvpBrush2"] = "分钟内不能和该玩家对战！"
_tab_string["__TEXT_PVP_PvpCoinGetOnceDay"] = "每天只能领取一次！"
_tab_string["__TEXT_PVP_PvpCoinGetMax"] = "兵符不足100个才能领取！"
_tab_string["__TEXT_PVP_PvpEscapePunish1"] = "您因为逃跑或掉线次数过多，需要等待"
_tab_string["__TEXT_PVP_PvpEscapePunish2"] = "分钟才能对战！"
_tab_string["__TEXT_PVP_PvpSurrenderPunish1"] = "您因为投降次数过多，需要等待"
_tab_string["__TEXT_PVP_PvpSurrenderPunish2"] = "分钟才能对战！"
_tab_string["__TEXT_PVP_PvpEscapeMaxCount"] = "您因为逃跑或掉线次数太多，禁止对战！"
_tab_string["__TEXT_PVP_PvpCoinGetMsgBox1"] = "1、夺塔奇兵每次发兵消耗1个兵符。"
_tab_string["__TEXT_PVP_PvpCoinGetMsgBox2"] = "2、夺塔奇兵英雄免等待复活消耗5个兵符。"
_tab_string["__TEXT_PVP_PvpCoinGetMsgBox3"] = "3、娱乐地图每次挑战消耗5~10个兵符。"
_tab_string["__TEXT_PVP_PvpCoinGetMsgBox4"] = "4、每天分享到朋友圈后可领取一次，补满到100个兵符。"
_tab_string["__TEXT_PVP_PvpCoinGetMsgBox4_Free"] = "4、每天可免费领取一次，补满到100个兵符。"
_tab_string["__TEXT_PVP_PvpCoinIntro_Short"] = "兵符可用于竞技场发兵、英雄免等待复活、挑战娱乐地图。"
_tab_string["__TEXT_PVP_DesignationHint1"] = "有效局中推掉对方主城。"
_tab_string["__TEXT_PVP_DesignationHint2"] = "有效局中发兵10次。"
_tab_string["__TEXT_PVP_DesignationHint3"] = "有效局中推掉对方粮仓。"
_tab_string["__TEXT_PVP_DesignationHint4"] = "有效局中推掉对方防御塔10次。"
_tab_string["__TEXT_PVP_DesignationHint5"] = "有效局中击败对方英雄10次。"
_tab_string["__TEXT_PVP_DesignationHint6"] = "本方大本营被推掉，发兵达到3次，游戏时长大于6分钟。"
_tab_string["__TEXT_PVP_DesignationHint7"] = "对手投降。"
_tab_string["__TEXT_PVP_DesignationHint8"] = "游戏时长大于90秒，对手掉线。"
_tab_string["__TEXT_PVP_DesignationHint9"] = "游戏时长大于90秒，对手逃跑。"
_tab_string["__TEXT_PVP_WaitToOpen"] = "等待开启"
_tab_string["__TEXT_PVP_Open"] = "打开"
_tab_string["__TEXT_PVP_Kick"] = "踢人"
_tab_string["__TEXT_PVP_Chest"] = "锦囊"
_tab_string["__TEXT_PVP_OpenNow"] = "立刻打开"
_tab_string["__TEXT_PVP_ClickToOpen"] = "点击打开"
_tab_string["__TEXT_PVP_NextTimeToOpen"] = "等待领取"
_tab_string["__TEXT_PVP_WaitingHint"] = "您需要等待才能打开锦囊"
_tab_string["__TEXT_PVP_NoEnoughStar"] = "您的战功积分不足"
_tab_string["__TEXT_PVP_PvpCoinPerGameCost"] = "每局使用兵符"
_tab_string["__TEXT_PVP_Arena_Battle"] = "擂台赛"
_tab_string["__TEXT_PVP_Fun_Battle"] = "切磋练习"
_tab_string["__TEXT_PVP_Fun_Free"] = "免费"
_tab_string["__TEXT_PVP_Fun_Free_Today"] = "今日剩余免费次数"
_tab_string["__TEXT_PVP_ArenaLeaveRoomLimit"] = "进入擂台赛30秒后才能离开！"
_tab_string["__TEXT_PVP_BeginMatch"] = "寻找对手"
_tab_string["__TEXT_PVP_CancelMatch"] = "取消匹配"
_tab_string["__TEXT_PVP_Matching"] = "正在搜索对手中"
_tab_string["__TEXT_PVP_DaoJiShi"] = "倒计时"
_tab_string["__TEXT_PVP_MatchingFailHint"] = "未能成功匹配对手，将获得1点战功积分补偿"
_tab_string["__TEXT_PVP_AttrQianghuaNotOpen"] = "暂未开放此兵种强化属性"
_tab_string["__TEXT_PVP_AttrQianghuaOrigin"] = "当前为初始强化属性，不需要还原！"
_tab_string["__TEXT_PVP_DRAGON"] = "魔龙"
_tab_string["__TEXT_PVP_RENZUWUD"] = "伊利丹"
_tab_string["__TEXT_PVP_GROUP_DRAGON"] = "南华仙尊"
--_tab_string["__TEXT_PVP_PLAYINTRO"] = "玩法介绍"
_tab_string["__TEXT_PVP_THIS_WEEK_EFFECT"] = "本周关卡内获得以下效果"
_tab_string["__NTEXT_ChoseGift"] = "选择奖励"
_tab_string["__NTEXT_PleaseChoseXCard"] = "请抽取 n 张奖励卡"
_tab_string["__TEXT_ENDLESS_THIS_DAT_EFFECT"] = "今日关卡内获得以下效果"
_tab_string["__TEXT_CHAT_INVALID_UID"] = "未知好友！"
_tab_string["__TEXT_PICKUP_TOO_MAMY_ITEMS"] = "已获得道具太多，无法再拾取！"
_tab_string["__TEXT_PVP_LOSECONNECT"] = "本地网络无响应"
_tab_string["__TEXT_PVP_LOSECONNECT_TRY"] = "您的网络长时间没有响应，%d 秒内未连上将被踢出游戏。"
_tab_string["__TEXT_PVP_LOSECONNECT_RECONNECT"] = "您的网络长时间没有响应，请重新连接。"
_tab_string["__TEXT_PVP_LOSECONNECT_KICK"] = "您的网络长时间没有响应，已被踢出游戏。"

_tab_string["__TEXT_CHOOSE_PVP_SET"] = "请选择装备配置 "
_tab_string["__TEXT_PLEASE_SELECT_TECHONOGY_CARD"] = "请选择一张科技效果"
_tab_string["__TEXT_UpdateInfoTile"] = "更新提示"
_tab_string["__TEXT_SystemNotice"] = "系统公告"
_tab_string["__TEXT_VersionTooOld"] = "您的版本太老，已无法使用当前功能，请更新至最新版本! \n \n从 pp助手 等其它渠道下载游戏的,也请继续保持从这些渠道进行更新! \n \n \n          【 注意: 千万不要删除原有游戏 】"
_tab_string["__TEXT_ScriptsTooOld"] = "游戏有更新！ \n \n请重新启动游戏，进行自动更新！"
_tab_string["__TEXT_HostVerTooOld"] = "服务器正在重启中！ \n \n请耐心等待几分钟后再操作！"

_tab_string["__TEXT_PVP_ACTIVITY_TITLE"] = "竞技场公告"
_tab_string["__TEXT_PVP_ACTIVITY_TITLE_2"] = "天梯房规则确认"
_tab_string["__TEXT_PVP_ACTIVITY_VERSION"] = "竞技场版本不一致,联网: #P1# ,本地: #P2#"
_tab_string["__TEXT_PVP_ACTIVITY_WELCOME"] = "策马守天关竞技场火热测试中，拥有6个以上英雄令的玩家即可体验！"
_tab_string["__TEXT_PVP_ACTIVITY_1"] = "每日 #P1# 限时开启"
_tab_string["__TEXT_PVP_ACTIVITY_2"] = "每日 #P1# 对决可获得 #P2#% 积分"
_tab_string["__TEXT_PVP_ACTIVITY_3"] = "部分付费兵种可以免费使用"
_tab_string["__TEXT_PVP_ACTIVITY_4"] = "竞技场从#P1#月#P2#日到#P3#月#P4#日，进行删档测试。\n (每日 #P5# 时段开放)"
_tab_string["__TEXT_PVP_ACTIVITY_5"] = "测试完成后会清除玩家战绩，兵种等级，兵符等数据，消费游戏币解锁的兵种会保留。\n (例如：购买的鹰卫保留，但会清除兵种的等级)"

_tab_string["__TEXT_PVP_DEPLOYMENT"] = "队伍配置"
_tab_string["__TEXT_PVP_LADDER"] = "排行榜"
_tab_string["__TEXT_PVP_ROOM"] = "天梯房"
_tab_string["__TEXT_PVP_ROOM_INTRO"] = " 玩家可以在竞技场进行一对一的决斗！"
_tab_string["__TEXT_PVP_ROOM2"] = "训练场"
_tab_string["__TEXT_PVP_ROOM2_INTRO"] = " 在训练场中，玩家只能使用系统预设的装备，所有战术卡片和兵种将被调整为固定等级。\n \n - 训练场内 6 级以下的玩家可以获得战斗力。\n \n - 训练场的输赢不会影响天梯分数。\n \n - 训练场内可以获得兵符。\n \n(有关于预设配装的想法欢迎到策马守天关论坛发表)"
_tab_string["__TEXT_PVP_HERO_DISABLED"] = "在竞技场中不能使用 #NAME# \n(对战时将强行替换为空位)"
_tab_string["__TEXT_PVP_CannotVSNpc"] = "不能与此电脑对战"
_tab_string["__TEXT_PVP_CannotLoadReplay"] = "不能观看此录像"
_tab_string["__TEXT_PVP_OpponentDropped"] = "你的对手已经掉线！"
_tab_string["__TEXT_CAST_INVALID_POINT"] = "无效的目标点"
_tab_string["__TEXT_CAST_NO_CASTER"] = "没有施法者！"
_tab_string["__TEXT_CAST_NO_TARGET"] = "没有目标可释放技能"
_tab_string["__TEXT_CAST_DISABLEMOVETO_TARGET"] = "目标无法到达！"
_tab_string["__TEXT_CAST_DISABLEMOVETO_POINT"] = "目标点无法到达"
_tab_string["__TEXT_BUILD_INVALID_POINT"] = "该目标点不能建造塔"
_tab_string["__TEXT_BUILD_INVALID_ROAD"] = "该路面不能建造塔"
_tab_string["__TEXT_BUILD_COLLAPSE_UNIT"] = "目标点和单位重叠"
_tab_string["__TEXT_BUILD_COLLAPSE_TOWER"] = "目标点和附近建筑重叠"
_tab_string["__TEXT_BUILD_TRIANGLE_TOONEAR"] = "目标点距离附近装置太近"
_tab_string["__TEXT_BUILD_TRIANGLE_TOOFAR"] = "目标点距离附近装置太远"
_tab_string["__TEXT_BUILD_TRIANGLE_INVALID_ANGLE"] = "目标点和现有装置组成的三角形区域太小"
_tab_string["__TEXT_Caocao"] = "曹操"
_tab_string["__TEXT_CaocaoArmy"] = "曹操军"
_tab_string["__TEXT_CaocaoLegion"] = "曹操势力"
_tab_string["__TEXT_LiubeiArmy"] = "刘备军"
_tab_string["__TEXT_CaoLiuAlliance"] = "曹刘联军"
_tab_string["__TEXT_SunLiuAlliance"] = "孙刘联军"
_tab_string["__TEXT_SunceArmy"] = "孙策军"
_tab_string["__TEXT_SunquanArmy"] = "孙权军"
_tab_string["__TEXT_HuangzuArmy"] = "黄祖军"
_tab_string["__TEXT_LiuxunArmy"] = "刘勋军"
_tab_string["__TEXT_Pangshencun"] = "胖神村"
_tab_string["__TEXT_DongZhuoArmy"] = "董卓军"
_tab_string["__TEXT_DongZhuoHunter"] = "董卓追兵"
_tab_string["__TEXT_GongSunZan"] = "公孙瓒"
_tab_string["__TEXT_GongSunZanArmy"] = "公孙瓒军"
_tab_string["__TEXT_LvBu"] = "吕布"
_tab_string["__TEXT_LvBuArmy"] = "吕布军"
_tab_string["__TEXT_FriendArmy"] = "友军"
_tab_string["__TEXT_HanArmy"] = "汉军"
_tab_string["__TEXT_HanKing"] = "汉献帝"
_tab_string["__TEXT_XiongNuArmy"] = "匈奴"
_tab_string["__TEXT_LongChengArmy"] = "龙城守军"
_tab_string["__TEXT_YuanShaoArmy"] = "袁绍军"
_tab_string["__TEXT_YuanShuArmy"] = "袁术军"
_tab_string["__TEXT_ChenLanArmy"] = "陈兰叛军"
_tab_string["__TEXT_PanJunArmy"] = "叛军"
_tab_string["__TEXT_ZhangXiuArmy"] = "张绣军"
_tab_string["__TEXT_LiubiaoArmy"] = "刘表军"
_tab_string["__TEXT_LiuyaoArmy"] = "刘繇军"
_tab_string["__TEXT_Yanandwangarmy"] = "严王联军"
_tab_string["__TEXT_LuanShiXiaoXiong"] = "乱世枭雄"
_tab_string["__TEXT_ZhuHouShangJiang"] = "诸侯上将"
_tab_string["__TEXT_ShanZei"] = "山贼"
_tab_string["__TEXT_Qiangdao"] = "强盗势力"
_tab_string["__TEXT_HeroAlliance"] = "英雄联盟"
_tab_string["__TEXT_EvilShrine"] = "邪恶圣域"
_tab_string["__TEXT_AllHeroAlliance"] = "群雄联盟"
_tab_string["__TEXT_Trialer"] = "试炼者"
_tab_string["__TEXT_Nemesis"] = "追击者"
_tab_string["__TEXT_Enemy"] = "敌人"
_tab_string["__TEXT_ShiChangShi"] = "十常侍"
_tab_string["__TEXT_CaoAndLiu"] = "曹刘联军"
_tab_string["__TEXT_Strayer"] = "迷路者"
_tab_string["__TEXT_Eliminater"] = "清除机制"
_tab_string["__TEXT_Qingdragon"] = "青龙神势力"
_tab_string["__TEXT_Xiaoqiao"] = "小乔"
_tab_string["__TEXT_Sunce"] = "孙策"
_tab_string["__TEXT_Qiaogong"] = "乔公"
_tab_string["__TEXT_Assassin"] = "刺客"
_tab_string["__TEXT_XiaoqiaoZhouyu"] = "小乔周瑜"
_tab_string["__TEXT_WanJia"] = "玩家"
_tab_string["__TEXT_ShouGeJingYing"] = "守阁精英"
_tab_string["__TEXT_ShouGeShenJiang"] = "守阁神将"
_tab_string["__TEXT_YuJi"] = "于吉"
_tab_string["__TEXT_JiuShiZhu"] = "救世主"
_tab_string["__TEXT_MoShou"] = "魔兽"
_tab_string["__TEXT_QiXianZhe"] = "七贤者"
_tab_string["__TEXT_Taoqian"] = "陶谦军"
_tab_string["__TEXT_Ganning"] = "甘宁军"
_tab_string["__TEXT_Zhuguang"] = "朱光军"
_tab_string["__TEXT_SunLiuaArmy"] = "孙刘联军"

_tab_string["__TEXT_EastCanton"] = "东郡"
_tab_string["__TEXT_SouthCanton"] = "南郡"
_tab_string["__TEXT_WestCanton"] = "西郡"
_tab_string["__TEXT_NorthCanton"] = "北郡"

_tab_string["__TEXT__FLEEING__"] = "由于惧怕您强大的实力，【#NAME#】四散逃窜，要追击吗？"
_tab_string["__TEXT__CREEP_LEAVE__"] = "多谢大人！"


_tab_string["__TEXT__CREEP_WANT_JOIN__"] = "由于您威名远扬，一队【#NAME#】慕名加入你的队伍，你想让他们加入吗？"
_tab_string["__TEXT__CREEP_JOIN_SUCESS__"] = "吾等愿誓死追随！"
_tab_string["__TEXT__NEED_RESOURCE__"] = "需要资源："
_tab_string["__TEXT__JOIN_FAIL_TEAM_FULL__"] = "加入失败(你的队伍满了)"
_tab_string["__TEXT__JOIN_FAIL_NEED_MORE_RESOURCE__"] = "加入失败(你的资源不足)"

_tab_string["__TEXT_HireCount"] = "可招募："

_tab_string["__TEXT_TDConfirmTip"] = "再次点击确认"

_tab_string["__TEXT_MAINUI_BTN_HERO"] = "点将台"
_tab_string["__TEXT_MAINUI_BTN_TACITC"] = "战术卡"
_tab_string["__TEXT_MAINUI_BTN_MISSION"] = "任务活动"
_tab_string["__TEXT_MAINUI_BTN_CHALLENGE"] = "挑战台"
_tab_string["__TEXT_MAINUI_BTN_ITEM"] = "道具"
_tab_string["__TEXT_MAINUI_BTN_MAIL"] = "邮件"
_tab_string["__TEXT_MAINUI_BTN_PVP"] = "竞技场"
_tab_string["__TEXT_MAINUI_BTN_WORLD"] = "世界"
_tab_string["__TEXT_MAINUI_BTN_PRIVATECHAT"] = "私聊"
_tab_string["__TEXT_MAINUI_BTN_GROUP"] = "军团"
_tab_string["__TEXT_MAINUI_BTN_COUPLE"] = "组队"
_tab_string["__TEXT_MAINUI_BTN_DONATE"] = "捐献"
_tab_string["__TEXT_MAINUI_BTN_REDPACKET"] = "红包"

_tab_string["NetInfo"] = "网络信息"
_tab_string["VersionInfo"] = "版本信息"
_tab_string["GameOptionNet"] = "联网模式"
_tab_string["GameOptionSa"] = "进入游戏"
_tab_string["GameOptionBbs"] = "去写心得"
_tab_string["Version_Local_Label"] = "当前版本		"
_tab_string["Version_Local_Version"] = "未知"
_tab_string["Version_Server_Label"] = "最新版本		"
_tab_string["Version_Server_Size"] =  "版本大小		"
_tab_string["Version_Server_Version"] = "未知"
_tab_string["Version_Status_Ok"] = "版本状态   正常"
_tab_string["Version_Status_Deformity"] = "版本状态   不完整"
_tab_string["Version_Update_Continue"] = "继续更新"
_tab_string["Version_Update_Continue2"] = "版本不完整 请更新"
_tab_string["Version_Update_Start"] = "开始更新"
_tab_string["Version_Update_Unnecessary"] = "无须更新"
_tab_string["Version_Update_Rflesh"] = "刷新"
_tab_string["Version_Update_FromApp"] = "请从苹果商店更新最新版本"
_tab_string["Version_Update_FromApp_Andriod"] = "请更新最新版本"
_tab_string["Version_Update_WithoutApp"] = "已经是苹果商店最新版本"
_tab_string["Version_Update_WithoutApp_Andriod"] = "已经是最新版本"
_tab_string["Main_Runing_NetWorkType0"] = "网络类型   无"
_tab_string["Main_Runing_NetWorkType1"] = "网络类型   WIFI"
_tab_string["Main_Runing_NetWorkType2"] = "网络类型   3G"
_tab_string["Main_Runing_GetAnnouncement"] = "获取公告信息......"
_tab_string["Main_Runing_GetLocalInfo"] = "获取本地版本信息......"
_tab_string["Main_Runing_GetNetInfo"] = "获取网络类型......"
_tab_string["Main_Runing_GetServerInfo"] = "获取服务器版本信息......"
_tab_string["Main_Runing_End"] = ""
_tab_string["Confirm_Update_Later"] = "暂不更新"
_tab_string["Exit_Info"] = "更新完成，请重新启动游戏"
_tab_string["Exit_Ack"] = "确定"
_tab_string["LostTipWebURL"] = "查看攻略"
_tab_string["Confirm_Info_Up_"] = "游戏最新版本"
_tab_string["Confirm_Info_Down_"] = "游戏当前版本"
_tab_string["__Text_Exit"] = "离    开"
_tab_string["__Text_GiveUp"] = "放    弃"
_tab_string["__Text_SaveFileBackOK"] = "确认恢复"
_tab_string["__TEXT_WattingPlease"] = "连接超时，请稍后再试"


_tab_string["Confirm_Enter"] = "进入游戏"
_tab_string["Confirm_Leave"] = "更新"
_tab_string["CopyDir_Loading_Info"] = "设置游戏运行环境…"
_tab_string["Updating_Loading_Info"] = "正在更新…"
_tab_string["GameStart_Loading_Info"] = "正在加载游戏…"
_tab_string["Announcement"] = "公      告"
_tab_string["Announcement_Info"] = "《策马守天关》用英雄策马天下的\n 游戏方式诠释三国时代的经典战役\n ...粉丝征集中...\n\n  英雄等级开放至12级"
_tab_string["Announcement_Info_2_1"] = ""
_tab_string["Announcement_Info_2_2"] = "我们很有诚意的制作了《策马守天关》这款游戏,"
_tab_string["Announcement_Info_2_3"] = "用英雄策马天下的游戏方式诠释三国时代名将与"
_tab_string["Announcement_Info_2_4"] = "战役,重现英雄无敌征战三国的战棋经典! 现粉丝"
_tab_string["Announcement_Info_2_5"] = "火热征集中!!        上海鑫线游戏 www.xingames.com"
_tab_string["Announcement_Info_2_6"] = ""
_tab_string["Announcement_Info_2_7"] = "官方QQ群号:274108227"
_tab_string["Announcement_Info_2_9"] = "1.089版更新内容:"
_tab_string["Announcement_Info_2_10"] = ""
_tab_string["Announcement_Info_2_11"] = "1. 增加一批首通关卡后的装备奖励"
_tab_string["Announcement_Info_2_12"] = "2. 增加新英雄令：太史慈"
_tab_string["Announcement_Info_2_13"] = "3. 开放一张新娱乐地图: 秘境试炼"
_tab_string["Announcement_Info_2_14"] = "4. 增加一些新手引导"
_tab_string["Announcement_Info_2_15"] = "5. 部分关卡小幅调整"
_tab_string["Announcement_Info_2_16"] = "6. 购买英雄令将获得附加装备"

_tab_string["GameSettingInfo"] = "语言设置在重启游戏后生效"
_tab_string["GameSettingInfo1"] = "数据恢复在重启游戏后生效"
_tab_string["LanguageSetting"] = "语言选择"
_tab_string["Text_Animation"] = "加速动画"
_tab_string["Exit_Now"] = "退出"
_tab_string["Exit_Wait"] = "稍后"

_tab_string["Elite_Mode"] = "精英模式"
_tab_string["__TEXT_SELECT_MAP_MODE"] = "模式选择"
_tab_string["__TEXT_MAP_INFO"] = "地图信息"
_tab_string["__TEXT_MAP_INFO2"] = "玩法说明"
_tab_string["__TEXT_STAR1_REWARD"] = "一星奖励"
_tab_string["__TEXT_STAR2_REWARD"] = "二星奖励"
_tab_string["__TEXT_STAR3_REWARD"] = "三星奖励"
_tab_string["__TEXT_GET_REWARD"] = "(已获得)"
_tab_string["__TEXT_BTN_STROY_MODE"] = "剧情"
_tab_string["__TEXT_BTN_DIFF_MODE"] = "挑战"
_tab_string["__TEXT_BTN_PASS"] = "通关"
_tab_string["__TEXT_BTN_STATISTICS"] = "统计"
_tab_string["__TEXT_BTN_ZHENRONG"] = "阵容"
_tab_string["__TEXT_UNLOCK_DIFF_MODE_TIP"] = "剧情模式三星后解锁难度挑战模式"
_tab_string["__TEXT_UNLOCK_DIFF_MODE_TIP1"] = "前一难度三星后解锁当前难度"
_tab_string["__TEXT_UNLOCK_DIFF_MODE_TIP2"] = "通关更多地图才能挑战本关"
_tab_string["__TEXT_UNLOCK_DIFF_MODE_TIP3"] = "该地图今日未开放"
_tab_string["__TEXT_UNLOCK_DIFF_MODE_TIP4"] = "挑战难度3模式三星后解锁精英模式"
_tab_string["__TEXT_GUIDE_DISABLE_LOGIN"] = "正在引导中，不能返回登陆"
_tab_string["__TEXT_PERSONAL_SETTING"] = "个人设置"

_tab_string["Hero_Revive"] = "重返战场"
_tab_string["Hero_Hire"] = "招募将领"
_tab_string["MyBattlefieldskillbook"] = "我的战术技能卡"
_tab_string["MyHeroCard"] = "英雄令"
_tab_string["MyHeroCardTipInfo"] = "随着游戏剧情战役的进行，你可以逐渐收集到三国名将的英雄令 \n 每位英雄将领都有自己的独特属性与技能！"
_tab_string["MyVIP"] = "VIP"
_tab_string["MyAchievement"] = "达人成就"
_tab_string["MyMapAchievement"] = "游戏成就"
_tab_string["Battlefieldskillbook"] = "战术技能卡"
_tab_string["admin_err"] = "账号填写错误"
_tab_string["password_err"] = "密码填写错误"
_tab_string["admin&password_err"] = "账号或密码错误"
_tab_string["enter_realname"] = "请输入真实姓名"
_tab_string["enter_idcard"] = "请输入身份证号" 
_tab_string["realnamecheck_err0"] = "验证通过"
_tab_string["realnamecheck_err1"] = "验证审核中"
_tab_string["realnamecheck_err2"] = "验证失败"
_tab_string["realnamecheck_err2001"] = "身份验证不通过"
_tab_string["realnamecheck_err20010"] = "身份证填写为空或非法"
_tab_string["realnamecheck_errcode"]="版署实名验证失败\n错误码："
_tab_string["try_again_later"]= "系统繁忙,请稍后再试"
_tab_string["remaining_time"]= "剩余游戏时间"
_tab_string["DefendACityTitle"] = "铜墙铁壁"
_tab_string["DefendACityInfo1"] = "受到来自城外的普通攻击伤害减少"
_tab_string["DefendACityInfo2"] = "%。"
_tab_string["DefendACityInfo3"] = "每损坏一面城墙，则失去16%的减免保护"

_tab_string["ZHU_JIAN"] = "主将"
_tab_string["FU_JIAN"] = "副将"
_tab_string["welcome_cow"] = "欢迎来到策马守天关的世界，请输入名称"
_tab_string["welcome_cow1"] = "请准备好迎接新的挑战！！！"
_tab_string["welcome_cow1_newtd"] = "请准备好迎接新的挑战！！！"
_tab_string["welcome_cow2"] = "为您的主公起个名字"
_tab_string["welcome_cow3"] = "修改您主公的名字"

_tab_string["__TEXT_TARCTICS_ICON_LAB_1"] = "步兵(包括刀盾兵,白耳兵,虎卫,东吴水兵,先登死士等)"
_tab_string["__TEXT_TARCTICS_ICON_LAB_2"] = "射手(包括神射手,无当飞军,鹰卫等)"
_tab_string["__TEXT_TARCTICS_ICON_LAB_3"] = "骑兵(包括重骑兵,巨象兵,虎豹骑等)"
_tab_string["__TEXT_TARCTICS_ICON_LAB_4"] = "法师(包括妖术师,仙术师,散仙等)"
_tab_string["__TEXT_TARCTICS_ICON_LAB_5"] = "机械(包括三弓床弩,霹雳车等)"
_tab_string["__TEXT_TARCTICS_ICON_LAB_6"] = "圣兽(包括朱雀,青龙,玄武等)"
_tab_string["__TEXT_TARCTICS_ICON_LAB_7"] = "其他()"
_tab_string["__TEXT_TARCTICS_ICON_LAB_END"] = "使用规则：每个种类的战术卡片只能同时装备三张！"
_tab_string["Tactical_Card_System"] = "战术技能卡升级说明"
_tab_string["Tactical_Card_System_Info"] = "策马守天关中有4种星级等级上限的卡1,3,5,10，这些卡作用于步兵、骑兵等7大类不同战术方向。"
_tab_string["Tactical_Card_System_Info_1"] = "3星卡中，当前等级1星或以上开始可以升级，消耗3张同样当前等级和星级上限的卡。"
_tab_string["Tactical_Card_System_Info_2"] = "5星卡中，当前等级2星或以上开始可以升级，消耗2张同样当前等级和星级上限的卡。"
_tab_string["Tactical_Card_System_Info_3"] = "10星卡中，当前等级5星或以上开始可以升级，消耗1张同样当前等级和星级上限的卡。"
_tab_string["realname_1"] = "根据国家新闻出版署《关于防止未成年人沉迷网络游戏的通知》，响应国家号召，帮助未成年人树立正确的网络游戏消费观念和行为习惯，需要对账号进行实名认证，请输入您的身份证号码，进行实名认证"
_tab_string["realname_2"] = "根据国家新闻出版署《关于防止未成年人沉迷网络游戏的通知》，响应国家号召，帮助未成年人树立正确的网络游戏消费观念和行为习惯。\n您当前游戏时长已经超过规定的游戏时长，或者您处于非规定的游戏时间段内。\n系统将会强制您下线，给您带来的不便，敬请见谅。"
_tab_string["realname_3"] = "根据您的账号信息，您已被识别为【未成年人】。本游戏对未成年人做了如下限制：\n1、每日22时至次日8时无法进行游戏\n2、工作日游戏时长不得超过1.5小时，周末游戏时长不得超过3小时\n3、游戏内的充值消费会有额度限制"
-----------------------------------------------------------------------------

-------------------------------------------------------------

-------------------------------------------------------------
--各种普通攻击
_tab_stringS[21] = {"攻击","对目标发动远程攻击。"}
_tab_stringS[23] = {"攻击","对目标发动近战攻击，也可以攻击城墙。"}
_tab_stringS[24] = {"投石","对目标发动投石攻击，也可以攻击城墙。"}
_tab_stringS[25] = {"弩击","对目标发动射弩攻击，也可以攻击城墙。"}
_tab_stringS[27] = {"攻击","对目标发动远程攻击。"}
_tab_stringS[28] = {"攻击","对目标发动近战攻击。"}
_tab_stringS[29] = {"攻击","对目标发动法术攻击。"}
_tab_stringS[30] = {"攻击","对目标发动远程攻击。"}
_tab_stringS[31] = {"攻击","对目标发动远程攻击。"}
_tab_stringS[32] = {"攻击","对目标发动法术攻击。"}
_tab_stringS[33] = {"攻击","对目标发动远程攻击。"}
_tab_stringS[112] = {"双剑连击","以双剑舞对敌人发起近战攻击。"}
_tab_stringS[291] = {"连射","攻击时可连续射出2支箭，造成150％伤害。"}
_tab_stringS[292] = {"连射","攻击时可连续射出3支箭，造成180％伤害。"}
_tab_stringS[333] = {"冰弹攻击","对目标发动法术攻击。"}
_tab_stringS[1000] = {"连射","攻击时可连续射出2支箭。"}
_tab_stringS[1001] = {"连弩","攻击时可连续射出3支箭。"}
_tab_stringS[1007] = {"爆裂攻击","发射火球攻击目标，造成爆裂伤害。"}
_tab_stringS[1012] = {"隼击","攻击时连续射出2支箭，对9格范围外的敌人额外射出1支箭。"}
_tab_stringS[1021] = {"勾爪击","可攻击距离2的敌人，造成75％的伤害并将其拽到身边。"}
_tab_stringS[1032] = {"撕咬","对目标发动近战攻击，对不能反击的目标额外造成 50％ 伤害。"}
_tab_stringS[1034] = {"爆裂攻击","发射火球攻击目标，造成爆裂伤害。"}
_tab_stringS[1043] = {"火焰投石","对目标发动投石攻击，也可以攻击城墙。"}
_tab_stringS[1046] = {"穿刺弩击","对目标发动射弩攻击，并伤害一条直线上的敌人，也可以攻击城墙。"}
_tab_stringS[1095] = {"寒霜攻击","对目标发射冰弹，伤害敌人并降低移动范围。"}
_tab_stringS[1525] = {"穿刺攻击","对目标发动攻击，并且伤害沿途的敌人。"}
_tab_stringS[2015] = {"乱射攻击","对目标发动远程攻击，同时对数个随机敌人射出箭矢。"}
_tab_stringS[2050] = {"震撼击","对目标发动近战攻击，造成范围伤害，也可以攻击城墙。"}
_tab_stringS[2059] = {"爆裂箭","对目标发射爆裂箭矢，造成范围伤害。"}
_tab_stringS[2112] = {"雷霆万钧","发射闪电链，对数个目标造成伤害"}
_tab_stringS[2156] = {"剧毒攻击","对目标发射剧毒箭矢，造成伤害并使其中毒 3 回合，每回合结束时毒素都能造成更高的伤害。"}


--系统技能


--物品技能
_tab_stringS[2004] = {"培元","每回合自动恢复10点生命值，每5点体质额外恢复1点。"}
_tab_stringS[2003] = {"迅影","每过4回合，可以额外行动1次。"}
_tab_stringS[2000] = {"定身符","使目标在当前回合无法移动。"}
_tab_stringS[2005] = {"冲锋","首回合增加额外1点移动范围。"}
_tab_stringS[2001] = {"五雷咒","发动范围雷电伤害，造成范围内敌人【智力*2】的伤害。"}
_tab_stringS[2002] = {"七星","使用后，增加自身75％的伤害输出，持续1回合。"}
_tab_stringS[2010] = {"蓄势","每 3 回合对自身进行强化，提升 50％ 伤害和 5 点出手速度，持续 1 回合。"}
_tab_stringS[2011] = {"励士","战斗开始的前3回合，己方军队提升10％伤害。"}
_tab_stringS[2013] = {"鹰卫","可将神射手升级为强大的鹰卫，升级需要耗费资源。"}
_tab_stringS[2014] = {"乱射","攻击方式变为远程,造成80％的物理伤害,额外向随机3个目标射出箭矢,造成20％伤害。"}
_tab_stringS[2017] = {"仙术","发动仙术，为全体友军恢复【智力*2+30】点生命值。"}
_tab_stringS[2018] = {"天罡","提升2格内的友军2点攻击力。"}
_tab_stringS[2023] = {"雷霆万钧","发动闪电束攻击，并在敌人之间跳动，共跳动5次，每次造成【智力*2+30】伤害。"}
_tab_stringS[2025] = {"二段反击","受到近战攻击时发动二段反击，造成150％伤害。"}
_tab_stringS[2027] = {"雷劫","开始行动时，随机对敌人发动落雷，共落下5道，每次造成【智力*0.3+9】伤害。"}
_tab_stringS[2029] = {"粉碎","普通攻击转为近战攻城攻击，可以对城墙造成【武力*0.3+20】点伤害。"}
_tab_stringS[2030] = {"狼牙","每回合可额外反击1次。"}
_tab_stringS[2031] = {"饥渴难耐","战斗开始的前5回合，提升自己10点攻击力和25点吸血。"}
_tab_stringS[2032] = {"守护","每回合开始时，随机提升3个友军15点护甲，持续1回合。"}
_tab_stringS[2034] = {"雷鸣","发动闪电束攻击，并在敌人之间跳动，共跳动3次，每次造成【智力*2+30】伤害。"}
_tab_stringS[2035] = {"冲撞","武将使用近身技能并向敌人移动时触发冲撞，对目标敌人造成【体质*1.0+25】点伤害。"}
_tab_stringS[2037] = {"五连斩","每过3回合,普通攻击和反击转为五连斩,能造成240％伤害。"}
_tab_stringS[2039] = {"疾风","战斗开始后，每回合增加1点出手速度和1点移动范围，最多提升5次。"}
_tab_stringS[2040] = {"龙鳞覆体","进入战场后，生命上限提升15％"}
_tab_stringS[2042] = {"幼麟【套装】","伤害+20％\n护甲+10 \n生命偷取+7％"}
_tab_stringS[2043] = {"幼麟【套装】","伤害+20％\n护甲+10 \n生命偷取+7％"}
_tab_stringS[2044] = {"幼麟【套装】","伤害+20％\n护甲+10 \n生命偷取+7％"}
_tab_stringS[2045] = {"苦肉计","进行防御时，额外提高20点护甲，并使自身受到的所有治疗效果提高 33％，持续2回合。"}
_tab_stringS[2049] = {"地动山摇","每过3回合，普通攻击可以造成 200％ 范围伤害，对城墙造成【武力*0.3+30】点伤害。"}
_tab_stringS[2051] = {"飞火","每回合首次行动时，对随机目标发射飞火，造成 【智力*0.4+30】点范围伤害。"}
_tab_stringS[2053] = {"冰澈","开始行动时，对随机目标发射冰弹，造成 【智力*0.75+15】点伤害，并降低其1点移动范围和2点出手速度。"}
_tab_stringS[2055] = {"激励","对自己以外的友军使用单体技能时，使目标获得 30％ 伤害加成，持续2回合。"}
_tab_stringS[2057] = {"天遁术","将自身传送至指定地点，可以使用 2 次。"}
_tab_stringS[2058] = {"金乌落炎","攻击方式变为远程,对主要目标造成120％的爆裂伤害,对附近目标造成80％伤害。"}
_tab_stringS[2061] = {"双影","攻击方式变为近战二段连击,总共造成115％伤害。"}
_tab_stringS[2063] = {"雀炎","发射火焰弹，对目标及一格范围内的敌人造成【智力*1.8+50】的伤害。"}
_tab_stringS[2065] = {"疾驰","首回合增加额外5点移动范围，每回合减少1点移动范围，最多减少5点。"}
_tab_stringS[2066] = {"贪狼","每回合增加3％反击伤害，并可额外反击1次。"}
_tab_stringS[2067] = {"玄武之赐","进入战场时赋予随机2名友军玄冰弹技能,并使其护甲值提升7点。"}
_tab_stringS[2069] = {"玄冰弹","发射冰弹攻击目标，使目标在2回合内处于冰冻状态。"}
_tab_stringS[2070] = {"龟甲阵","使全体友军提升30点护甲，持续2回合。"}
_tab_stringS[2072] = {"不动如山","消耗1点移动范围，使生命上限和伤害提升9％，最多叠加3次。","该技能不受复制和疯魔影响，也无法被补充使用次数。"}
_tab_stringS[2073] = {"弃防强攻","激活后在3回合内获得 15％ 吸血和 60 点攻击力,但是减少 1 次反击。"}
_tab_stringS[2074] = {"激励","对自己以外的友军使用单体技能时，使目标获得 30％ 伤害加成，持续2回合。"}
_tab_stringS[2075] = {"百战","对敌人使用目标指定类技能后获得 15 点攻击力和 2％ 吸血,持续 2 回合。 \n(最多叠加 6 次)"}
_tab_stringS[2077] = {"猛击","普通攻击和目标指定类技能在计算攻击力时，额外附加【护甲差值*2】点攻击力。 \n(最多150点攻击力)"}
_tab_stringS[2078] = {"石化","使一个非机械类普通单位石化，防御降低200点，持续3回合。 \n(石化单位只能被攻城方式攻击)"}
_tab_stringS[2080] = {"冥想","满血时使用技能可回复 2 点魔法值。 \n(消耗魔法的技能才会触发此效果)"}
_tab_stringS[2083] = {"百夫长","可将刀盾兵升级为强大的百夫长，升级需要耗费资源。"}
_tab_stringS[2084] = {"鼓舞","提升3格范围内近战友军，2点攻击力。"}
_tab_stringS[2086] = {"西凉铁骑","可将重骑兵升级为强大的西凉铁骑，升级需要耗费资源。"}
_tab_stringS[2087] = {"拖刀","回合开始时提升 10％ 技能伤害。 \n使用技能后提升 10％ 技能伤害。 \n技能伤害提升百分比超过【武力*0.5】后获得最多 30％ 吸血，回合结束时重置。"}
_tab_stringS[2090] = {"地裂","释放一道冲击波，造成 【130％+体质*2】 点伤害。"}
_tab_stringS[2092] = {"蛇信","对步兵,骑兵和射手单位额外造成 35％ 的伤害。"}
_tab_stringS[2093] = {"剑倚长天","提升战场内所有友军 5％ 的伤害和1％的吸血，每消灭一队敌人额外提升 1 层效果。"}
_tab_stringS[2094] = {"咒刃","伤害+20％ \n首回合损失5％生命值，损失生命值每回合增加1％。"}
_tab_stringS[2095] = {"龙魂","普通攻击转为近战二段连击,造成150％伤害。 \n龙魄 \n自身受到的所有治疗效果提高 33％。"}
_tab_stringS[2096] = {"龙魂击","发动二段连击，造成150％伤害。"}
_tab_stringS[2097] = {"挚情"," 对自身和持有莫邪的武将提供10％伤害\n 双剑合璧 \n使用近战攻击和技能时，拥有莫邪的武将会同时发起攻击。"}
_tab_stringS[2098] = {"挚情"," 对自身和持有干将的武将提供2点出手速度\n 双剑合璧 \n使用近战攻击和技能时，拥有干将的武将会同时发起攻击。"}
_tab_stringS[2099] = {"亢龙【套装】","技能伤害+30％ \n每场战斗开始时获得5点法力值"}
_tab_stringS[2100] = {"亢龙【套装】","技能伤害+30％ \n每场战斗开始时获得5点法力值"}
_tab_stringS[2101] = {"亢龙【套装】","技能伤害+30％ \n每场战斗开始时获得5点法力值"}
_tab_stringS[2103] = {"龙魄","自身受到的所有治疗效果提高 15％"}
_tab_stringS[2104] = {"奔雷击","近战攻击或近战技能会触发雷击，造成 150％ 伤害，并使目标眩晕 1 回合【3回合冷却】"}
_tab_stringS[2107] = {"神技","技能伤害+10％"}
_tab_stringS[2108] = {"黄天【套装】","伤害+10％ \n每2回合提升15点攻击力和1点出手速度，最多提升5次"}
_tab_stringS[2109] = {"黄天【套装】","伤害+10％ \n每2回合提升15点攻击力和1点出手速度，最多提升5次"}
_tab_stringS[2110] = {"尖刺","反击伤害提升15％\n\n黄天【套装】 \n伤害+10％\n每2回合提升15点攻击力和1点出手速度，最多提升5次"}
_tab_stringS[2111] = {"雷击","普通攻击转为闪电链攻击，对目标造成【智力*3】点伤害，对附近2个敌人造成一半伤害"}
_tab_stringS[2114] = {"寒冰守护","瞬间恢复【智力*9】生命值，冻结自己，并增加200点护甲，持续两回合。"}
_tab_stringS[2117] = {"怒兽","回合开始时若武将血量低于33％，立即恢复【体质*9】生命值，并提升90点攻击力，持续3回合，仅触发一次。"}
_tab_stringS[2119] = {"寒气","战斗开始时使所有移动范围 6 点或以上的单位降低 2 点移动范围，持续 2 回合。"}
_tab_stringS[2121] = {"少典【套装】"," 所有友军：伤害+10％ \n 所有友军：护甲+10 \n 所有友军：吸血+5％"}
_tab_stringS[2122] = {"强壮","自身受到的所有治疗效果提高 10％\n\n少典【套装】\n所有友军：伤害+10％\n所有友军：护甲+10 \n所有友军：吸血+5％"}
_tab_stringS[2123] = {"怒击","普通攻击变为近战连击，造成 70％ 单体伤害和 50％ 范围伤害。 \n \n少典【套装】 \n所有友军：伤害+10％ \n所有友军：护甲+10 \n所有友军：吸血+5％"}
_tab_stringS[2125] = {"癫狂","回合开始时，自身每损失 20％ 生命值就提高自身 1 点出手速度和 20 点攻击力。"}
_tab_stringS[2126] = {"灵魄","当身边没有敌人时，减少20％来自敌人的伤害。"}
_tab_stringS[2127] = {"挣脱","开始行动时，自动移除所有定身效果。 \n【3回合冷却】"}
_tab_stringS[2128] = {"神技","技能伤害+25％"}
_tab_stringS[2129] = {"虎威","每回合首次施展消耗法力的技能时，获得相当于【消耗法力*2】的额外攻击力。"}
_tab_stringS[2132] = {"召唤神兽","召唤两只强大的神兽帮助战斗，持续4回合。","悟道 : (需求统率 100 ) \n召唤后可以再次行动。"}
_tab_stringS[2134] = {"癫狂","首次承受使生命降低到 55％ 或以下的伤害时，提高自身 3 点出手速度，60 点攻击力。"}
_tab_stringS[2135] = {"黄龙之力","进入战场时召唤一头异常强大的黄龙，该黄龙额外获得【智力*10】的生命值和【智力*2】点攻击力。"}
_tab_stringS[2136] = {"血咒","使用后，对自身造成 【50％当前生命值】 点伤害，每造成 12 点伤害便提高 1 点攻击力。","该技能不受复制，疯魔影响。"}
_tab_stringS[2137] = {"玄术","对距离 3 格以上的目标额外造成 15％ 伤害。"}
_tab_stringS[2138] = {"疾行如风","进入战场后，使 1 格范围内的其他友军出手速度提升 1 点。"}
_tab_stringS[2139] = {"凯旋","使全体友方普通单位的韧性增加 5 点。"}

_tab_stringS[2140] = {"生生不息","每次使用技能时，恢复7格内友军单位【智力*0.75】的生命值。"}
_tab_stringS[2142] = {"烈斩","普通攻击转为近战，并且在攻击和反击时额外造成10~100点伤害。"}
_tab_stringS[2144] = {"不死鬼将","消灭敌人时召唤一个鬼将，鬼将额外获得【智力*10】的生命值和【智力*2】点攻击力。"}
_tab_stringS[2146] = {"混沌之力","普通攻击或使用单体技能时，对目标随机发动火球、冰箭、落雷、毒素四种效果中的一种，伤害与智力相关。"}

_tab_stringS[2151] = {"腾跃","的卢择主，战斗中额外提升 4 点移动范围。"}
_tab_stringS[2152] = {"枯萎","降低 1 格内敌人至少 75％ 的生命恢复效果。"}
_tab_stringS[2154] = {"削铁如泥","造成伤害时，无视敌人20点护甲。"}
_tab_stringS[2155] = {"毒矢击","攻击方式变为远程，造成 110％ 伤害并使目标中毒，持续 3 回合。 \n (毒素伤害会持续提高)"}

_tab_stringS[2159] = {"战地修理","自我修理，恢复 9％ 的总体生命值。"}
_tab_stringS[2160] = {"集气","回合结束时，可恢复本回合消耗法力的一半. \n (冷却 2 回合)"}
_tab_stringS[2161] = {"未卜先知","每回合可闪避 1 次普通攻击，最多生效 3 次。"}
_tab_stringS[2163] = {"大爆炎","发动多次猛烈的爆炸，总共造成【智力*5】的大范围伤害。"}
_tab_stringS[2164] = {"以逸待劳","防御后提高 10％ 吸血,并获得 2 次额外的反击次数,持续 1 回合。 \n(每回合可触发 1 次)"}
_tab_stringS[2166] = {"喝令","进入战场时使 1 名友方普通单位获得 5 点额外的韧性，并立刻触发其韧性效果。"}
_tab_stringS[2168] = {"讯影","获得讯影技能。"}

_tab_stringS[2169] = {"天雷滚滚","开始行动时，随机对敌人发动落雷，共落下3道，每次造成【武将等级*3+9】伤害。"}

_tab_stringS[2171] = {"镇魂","回合开始时，使附近3格范围内的敌人所造成的伤害降低20％。"}
_tab_stringS[2173] = {"重生","当生命值降低到25％以下时，立即恢复40％生命值。\n(每场战斗限 1 次)"}
_tab_stringS[2174] = {"闪电链","发动闪电攻击，并在敌人之间弹跳3次，每次造成【智力*1.5+10】伤害，可使用 3 次。"}



_tab_stringS[6064] = {"天佑","使目标的攻击力和护甲值获得提升。"}


_tab_stringS[24] = {"爆裂弹","攻城攻击造成范围伤害。"}
_tab_stringS[48] = {"超级火焰爆轰","发动连续的火焰爆轰。"}

_tab_stringS[1003] = {"投枪","掷矛攻击敌人，造成50％伤害。"}
_tab_stringS[1004] = {"涅槃","每3回合恢复45点生命值。"}
_tab_stringS[1005] = {"神威","提升周围友军10％攻击力。"}
_tab_stringS[1009] = {"玄冰弹","发射冰弹攻击目标，使目标在2回合内处于冰冻状态。"}
_tab_stringS[1010] = {"散射","自动发射箭矢，对至多5个敌人造成20％伤害。"}
_tab_stringS[1014] = {"绊马索","丢出锁链攻击敌人，使其在当前回合无法移动。"}
_tab_stringS[1015] = {"治疗","对单体目标造成150％的治疗。"}
_tab_stringS[1016] = {"治疗","对单体目标造成150％的治疗。"}
_tab_stringS[1017] = {"极冰锥","对大范围内的敌人造成300％智力值的伤害"}
_tab_stringS[1018] = {"天雷咒","召唤雷电，造成150％伤害。"}
_tab_stringS[1019] = {"五雷咒","召唤雷电，造成100％伤害。"}
_tab_stringS[1020] = {"定身符","使目标在当前回合无法移动。"}
_tab_stringS[1022] = {"协同攻击","身边的敌人受到近战攻击时，可对其发动1次额外的攻击。"}
_tab_stringS[1024] = {"盾墙","提升周围友军10点护甲值。"}
_tab_stringS[1026] = {"践踏","对移动范围比自己低 3 点或更多的敌人额外造成 25％ 伤害。"}
_tab_stringS[1027] = {"冲锋","首回合移动范围提高 2 点。"}
_tab_stringS[1029] = {"天雷","回合开始时引发3次雷击，对2格内的随机单位造成25％伤害。"}
_tab_stringS[1030] = {"咆哮","攻击不能反击的敌人时，额外造成 50％ 伤害。"}
_tab_stringS[1033] = {"朱雀之愈","立刻治疗全体友军。"}
_tab_stringS[1035] = {"吸血","恢复造成伤害量15％的生命值。"}
_tab_stringS[1037] = {"碧海潮生","我方全员每回合自动恢复【智力*1+15】点生命值。"}
_tab_stringS[1038] = {"炎爆","发动范围火焰爆炸。"}
_tab_stringS[1038] = {"持续治疗","持续对单体目标进行治疗。"}
_tab_stringS[1040] = {"反击","提高150％反击伤害，持续2回合。"}
_tab_stringS[1049] = {"箭雨","将箭矢射向天空，对范围内的敌人造成100％伤害。"}
_tab_stringS[1051] = {"超级炎爆","发动连续的炎爆术。"}
_tab_stringS[1052] = {"冰弹","发射冰弹造成90％的伤害，并在2回合内降低目标1点移动范围。"}
_tab_stringS[1054] = {"铁骑突击","发动攻击前每移动 1 格，便有 20％ 的几率额外对周围的随机目标发动 1 次攻击（最多3连击）"}
_tab_stringS[1058] = {"灭世血阵","将邻近围内敌人拉至自己身边发动攻击,并造成伤害。"}
_tab_stringS[1059] = {"镇军战旗","在指定区域投掷战旗,每回合开始时提升附近友军伤害,并回复生命值。"}
_tab_stringS[1060] = {"怒击","对目标造成150％伤害并拖拽至自己身边。"}
_tab_stringS[1061] = {"熊咆哮","对身边 4 格范围内的敌人造成伤害，并使他们定身 1 回合。"}
_tab_stringS[1062] = {"困兽犹斗","提升 20 点护甲，并且在回合结束时回复本回合损失的所有生命。"}
_tab_stringS[1063] = {"巨木碎","猛击敌人，造成伤害。"}
_tab_stringS[1066] = {"践踏","攻击移动范围比自己低 3 点或更多的敌人时,使自身伤害提高 25％,持续 1 回合。"}
_tab_stringS[1068] = {"投弹攻击","对距离 1 格以上的最多 3 名敌人发动投弹攻击，造成 100％ 伤害。"}
_tab_stringS[1069] = {"炽热","每回合提高 5％ 伤害，持续 5 回合。"}
_tab_stringS[1080] = {"群体冰弹","对多个目标发射冰弹，并将其冻结2回合。"}
_tab_stringS[1084] = {"地炎","每回合开始时，在地面留下一道火焰，火焰会对进入的敌人造成伤害，持续9回合。"}
_tab_stringS[1086] = {"兽魂","每个回合可行动2次。"}

----战术技能
_tab_stringS[6257] = {"强力冲锋","当前回合提高自身伤害和移动范围。"}

----阵法
_tab_stringS[5000] = {"鱼鳞阵","步兵单位的攻击力提高 2 点。"}
_tab_stringS[5002] = {"雁型阵","所有射手的攻击力提高 1 点。"}
_tab_stringS[5004] = {"蛇型阵","步兵和射手的移动范围提高 1 点。"}
_tab_stringS[5006] = {"方圆阵","步兵和骑兵单位的护甲提高 10 点。"}
_tab_stringS[5008] = {"锋矢阵","骑兵单位的移动范围提高 1 点。"}

_tab_stringS[5200] = {"驱兽阵","野兽单位攻击力提高 3 点，生命值提高 5 点，移动范围提高 1 点。"}
_tab_stringS[5202] = {"机械术","攻城单位的伤害提高 20％ ，移动范围提高 1 点。"}
_tab_stringS[5204] = {"背水阵","步兵和骑兵单位伤害提高 30％，护甲减少 15 点。"}
_tab_stringS[5206] = {"锥形阵","骑兵单位的移动范围提高 1 点，伤害提高 15％。"}
_tab_stringS[5208] = {"玄襄阵","法师和圣兽单位的伤害提高 20％。"}

_tab_stringS[5400] = {"一字长蛇阵","步兵单位的移动范围提高 2 点，出手速度提高 2 点。"}
_tab_stringS[5402] = {"九字连环阵","骑兵单位的移动范围提高 2 点，攻击力提高 20％，出手速度提高 1 点。"}
_tab_stringS[5404] = {"八门金锁阵","步兵和射手单位的攻击力提高 1 点，生命值提高 5 点，护甲提高 5 点。"}
_tab_stringS[5406] = {"七星北斗阵","射手单位的攻击力提高 2 点，出手速度提高 2 点。"}
_tab_stringS[5408] = {"混元一气阵","法师和圣兽单位的攻击力提高 25％，移动范围提高 1 点。"}

-----天赋技能说明
_tab_stringS[6000] = {"弓箭强化","射手单位的攻击力+6％\n【每级提升3％攻击】\n【消耗天赋点：1】"}
_tab_stringS[6002] = {"步兵强化","步兵单位的攻击力+8％\n【每级提升4％攻击】\n【消耗天赋点：1】"}
_tab_stringS[6004] = {"骑兵强化","骑兵单位的攻击力+10％\n【每级提升6％攻击】\n【消耗天赋点：1】"}
_tab_stringS[6006] = {"法术强化","法术和圣兽单位的攻击力+10％\n【每级提升5％攻击】\n【消耗天赋点：1】"}

_tab_stringS[6008] = {"弓兵护甲","弓兵单位的护甲+2\n【每级提升2点护甲】\n【消耗天赋点：1】"}
_tab_stringS[6010] = {"步兵护甲","步兵单位的护甲+4\n【每级提升2点护甲】\n【消耗天赋点：1】"}
_tab_stringS[6012] = {"骑兵护甲","骑兵单位的护甲+6\n【每级提升3点护甲】\n【消耗天赋点：1】"}
_tab_stringS[6014] = {"五行护甲","法术和圣兽单位的护甲+6\n【每级提升3点护甲】\n【消耗天赋点：1】"}


_tab_stringS[6020] = {"青龙之痕","增加青龙10点攻击力，10点护甲，50点生命值\n【消耗天赋点：3】"}

_tab_stringS[6022] = {"朱雀之痕","增加朱雀15点攻击力，5点护甲，30点生命值\n【消耗天赋点：3】"}
_tab_stringS[6023] = {"玄武之痕","增加玄武5点攻城伤害，15点护甲，60点生命值\n【消耗天赋点：3】"}
_tab_stringS[6024] = {"强化虎豹","增加虎豹骑12点攻击力，30点生命值，1点移动范围\n【消耗天赋点：3】"}

_tab_stringS[6200] = {"兵贵神速","每级增加部队的行动速度和范围1点，不包括武将自身\n【消耗天赋点：2】"}
_tab_stringS[6202] = {"全攻","每级增加部队5％伤害，不包括武将自身\n【消耗天赋点：2】"}
_tab_stringS[6204] = {"全防","每级增加部队5点护甲，不包括武将自身\n【消耗天赋点：2】"}
_tab_stringS[6205] = {"快马加鞭","每级增加武将的行动范围1点\n【消耗天赋点：2】"}
_tab_stringS[6206] = {"神武","每点武力额外增加0.2攻击力\n【消耗天赋点：3】"}
_tab_stringS[6207] = {"急智","每点智力额外增加0.3法力值\n【消耗天赋点：3】"}
_tab_stringS[6208] = {"刚体","进入战场后，每点体质额外增加5生命值\n【消耗天赋点：3】"}
_tab_stringS[6211] = {"攻守兼备","武将每级增加5点攻击力和5点护甲\n【消耗天赋点：2】"}
_tab_stringS[6212] = {"寒冰领域","降低敌部队的行动速度和范围1点\n【消耗天赋点：3】"}
_tab_stringS[6213] = {"迅捷如风","每级增加武将的行动速度1点\n【消耗天赋点：1】"}

_tab_stringS[6300] = {"以德服人","刘备受到近战攻击时，不再进行反击，而是使攻击目标的伤害降低75％,持续2回合。\n【消耗天赋点：3】"}
_tab_stringS[6302] = {"强化白耳","提升白耳兵6点攻击力，20点护甲，1点移动范围\n【消耗天赋点：3】"}
_tab_stringS[6303] = {"威势","使敌人在你的威慑下胆怯，降低所有敌人10点护甲\n【消耗天赋点：3】"}

_tab_stringS[6304] = {"一夫当关","进入战场后提升武将20％最大生命值\n【消耗天赋点：3】"}

_tab_stringS[7777] = {"陶晶之怒","雷霆万钧"}
_tab_stringS[7780] = {"叹息之墙","你永远无法伤到我！"}
_tab_stringS[7781] = {"真·陶晶之怒","雷霆万钧"}

--=====================================================
_tab_stringS[9001] = {"速射","加快射速，增加攻击"}
_tab_stringS[9002] = {"连射","一定几率连射多箭，每箭固定伤害15"}
_tab_stringS[9105] = {"巨石","增加射程，增加攻击"}
_tab_stringS[9102] = {"碎石","每次额外抛射两块碎石"}
_tab_stringS[9205] = {"雷电","增加攻击"}
_tab_stringS[9201] = {"链闪","攻击会弹射附近的敌人"}
_tab_stringS[9301] = {"减速","加强减速效果，增加攻击"}
_tab_stringS[9303] = {"冰冻","一定几率冰冻敌人2秒，并造成40伤害"}
_tab_stringS[9401] = {"远射","增加射程，增加攻击"}
_tab_stringS[9402] = {"狙击","几率暴击，几率击倒"}


--=====================================================

--[[
_tab_stringU[6901] = {"军营","可以训练出朴刀兵"}
_tab_stringU[6902] = {"高级军营","可以训练出刀盾兵"}
_tab_stringU[6903] = {"马厩","可以训练出轻骑兵"}
_tab_stringU[6904] = {"高级马厩","可以训练出重骑兵"}
_tab_stringU[6905] = {"铁甲营","可以训练出铁甲卫"}
_tab_stringU[6906] = {"虎卫营","可以训练出虎卫"}
_tab_stringU[6907] = {"虎狼营","可以训练出虎狼骑"}
_tab_stringU[6908] = {"虎豹营","可以训练出虎豹骑"}
_tab_stringU[6909] = {"玄龟池","可以召唤玄龟"}
_tab_stringU[6910] = {"玄武池","可以召唤圣兽玄武"}
_tab_stringU[6911] = {"观星台","可以训练出术士和方士"}
_tab_stringU[6912] = {"摘星阁","可以训练出妖术士和仙术士"}
_tab_stringU[6913] = {"水兵营","可以训练出水兵"}
_tab_stringU[6914] = {"水鬼营","可以训练出鳞甲水兵"}
_tab_stringU[6915] = {"祈雨坛","可以训练出符咒师"}
_tab_stringU[6916] = {"七星坛","可以训练出散仙"}
_tab_stringU[6917] = {"盘龙崖","可以召唤黄龙"}
_tab_stringU[6918] = {"青龙崖","可以召唤圣兽青龙"}
_tab_stringU[6919] = {"靶场","可以训练出射手"}
_tab_stringU[6920] = {"高级靶场","可以训练出精锐射手"}
_tab_stringU[6921] = {"枪兵营","可以训练出枪兵"}
_tab_stringU[6922] = {"高级枪兵营","可以训练出精锐枪兵"}
_tab_stringU[6923] = {"连弩营","可以训练出连弩手"}
_tab_stringU[6924] = {"无当营","可以训练出无当飞军"}
_tab_stringU[6925] = {"战象营","可以训练出战象"}
_tab_stringU[6926] = {"巨象营","可以训练出巨象"}
_tab_stringU[6927] = {"铜雀台","可以召唤炎雀"}
_tab_stringU[6928] = {"朱雀台","可以召唤圣兽朱雀"}
_tab_stringU[6929] = {"军营","可以训练出朴刀兵"}
_tab_stringU[6930] = {"高级军营","可以训练出刀盾兵"}
_tab_stringU[6931] = {"马厩","可以训练出轻骑兵"}
_tab_stringU[6932] = {"高级马厩","可以训练出重骑兵"}
_tab_stringU[6933] = {"观星台","可以训练出术士和方士"}
_tab_stringU[6934] = {"摘星阁","可以训练出妖术士和仙术士"}
_tab_stringU[6935] = {"靶场","可以训练出射手"}
_tab_stringU[6936] = {"高级靶场","可以训练出精锐射手"}
_tab_stringU[6937] = {"枪兵营","可以训练出枪兵"}
_tab_stringU[6938] = {"高级枪兵营","可以训练出精锐枪兵"}
_tab_stringU[6939] = {"兵工坊","可以生产投石车和弩车"}
_tab_stringU[6940] = {"神匠工坊","可以生产霹雳车和三弓床弩"}
_tab_stringU[6941] = {"兵工坊","可以生产投石车和弩车"}
_tab_stringU[6942] = {"神匠工坊","可以生产霹雳车和三弓床弩"}
_tab_stringU[6943] = {"府邸1级","每天获得税收：%provide%金钱","每天获得税收：%provide%金钱"}--平原41000
_tab_stringU[6944] = {"府邸2级","每天获得税收：%provide%金钱","每天获得税收：%provide%金钱"}--平原41001
_tab_stringU[6945] = {"府邸3级","每天获得税收：%provide%金钱","每天获得税收：%provide%金钱"}--平原41002
_tab_stringU[6946] = {"府邸1级","每天获得税收：%provide%金钱","每天获得税收：%provide%金钱"}--山城41005
_tab_stringU[6947] = {"府邸2级","每天获得税收：%provide%金钱","每天获得税收：%provide%金钱"}--山城41006
_tab_stringU[6948] = {"府邸3级","每天获得税收：%provide%金钱","每天获得税收：%provide%金钱"}--山城41007
_tab_stringU[6949] = {"府邸1级","每天获得税收：%provide%金钱","每天获得税收：%provide%金钱"}--水城41010
_tab_stringU[6950] = {"府邸2级","每天获得税收：%provide%金钱","每天获得税收：%provide%金钱"}--水城41011
_tab_stringU[6951] = {"府邸3级","每天获得税收：%provide%金钱","每天获得税收：%provide%金钱"}--水城41012
_tab_stringU[6952] = {"寺庙","每周会产生随机资源，使驻守城池的武将每天结束时恢复100%生命值和20%法力值"}
]]


------------------------------------------------------------------------
--[[
_tab_stringU[10000] = {"朴刀兵","使用朴刀的初级近战兵种。"}
_tab_stringU[10001] = {"弓手","使用长弓的初级远程兵种。"}
_tab_stringU[10002] = {"刀盾兵","配备了盾牌的刀兵，攻防兼备。"}
_tab_stringU[10003] = {"轻骑","速度较快，但其它能力平平的初级骑兵。"}
_tab_stringU[10004] = {"神射手","攻击能力较强的远程兵种，能进行二连射，但比较脆弱。"}
_tab_stringU[10005] = {"重骑兵","机动性和防御能力较强，是远程兵种的克星。"}
_tab_stringU[10006] = {"术士","使用法术进行攻击的远程作战兵种。"}
_tab_stringU[10007] = {"弩车","射程很远但行动缓慢的移动型炮台。"}
_tab_stringU[10008] = {"投石车","射程很远的攻城武器，能有效的破坏城墙。"}
_tab_stringU[10009] = {"铁甲卫","配备了全身的甲胄和坚固的盾牌，防御能力很强的近战兵种。"}
_tab_stringU[10010] = {"虎狼骑","攻击和机动能力都很强的近战兵种。"}
_tab_stringU[10011] = {"炎雀","具有非凡神力的神鸟，据说是朱雀的后代。"}
_tab_stringU[10012] = {"弓骑兵","行动迅速，机动力较强的远程兵种。"}
_tab_stringU[10013] = {"象兵","皮糙肉厚的近战单位，擅长吸收伤害。"}
_tab_stringU[10014] = {"连弩手","行动迅速，擅长中距离作战。"}
_tab_stringU[10015] = {"黄龙","神通广大，能飞腾于天地间，据说是圣兽青龙的后代。"}
_tab_stringU[10016] = {"近卫兵","通常作为将领的贴身护卫，具有很强的肉搏能力。"}
_tab_stringU[10017] = {"铁箭卫","使用精心打造的铁质箭矢，非常擅长远距离作战的兵种。"}
_tab_stringU[10018] = {"东吴水兵","东吴特有的水军，擅长近身肉搏战。"}
_tab_stringU[10019] = {"玄龟","具有非凡神力的龟类，据说是圣兽玄武的后代。"}
_tab_stringU[10020] = {"符咒师","既擅长医疗又擅长攻击的兵种。"}
_tab_stringU[10021] = {"农民","三国时代的农民。"}
_tab_stringU[10022] = {"狼","在森林出没的狼，速度飞快。"}
_tab_stringU[10023] = {"狼王","狼中之王，具有比一般的狼强大得多的战斗力！"}
_tab_stringU[10024] = {"应熊力士","据称应熊是上古有熊氏的后裔，是战斗力极强的氏族。"}
_tab_stringU[10025] = {"白虎","上古传说中的圣兽，四象之一，具有很强的攻击能力。"}
_tab_stringU[10026] = {"黄巾步卒","黄巾军的步兵，战斗力比一般步兵弱。"}
_tab_stringU[10027] = {"黄巾弓手","黄巾军的弓手，战斗力比一般弓手弱。"}
_tab_stringU[10028] = {"黄巾术士","会施展法术的黄巾妖术师，是黄巾军中最有威力的兵种。"}
_tab_stringU[10029] = {"山贼","据山立寨或出没于山林的盗贼。"}
_tab_stringU[10030] = {"强盗","打家劫舍，经常与官府作对的强盗。"}
_tab_stringU[10031] = {"水贼","出没于江河，打劫过往商船的盗贼。"}
_tab_stringU[10032] = {"近卫","刘备的近卫部队，作战骁勇，是白耳兵的前身。"}
_tab_stringU[10033] = {"白耳兵","三国时代刘备手下的一支精锐部队，属于刘备的近卫军。"}
_tab_stringU[10035] = {"陷阵营","东汉末期一支独特的部队，个个骁勇善战，装备精良。"}
_tab_stringU[10036] = {"鹰卫","东汉末期一支隐秘的皇室部队，极擅长远射。"}
_tab_stringU[10037] = {"禁卫死士","只听命于曹操的禁卫死士，具有比普通士兵更强的战斗力。"}
_tab_stringU[10038] = {"先登死士","只听命于曹操的先登死士，非常擅长突击。"}
_tab_stringU[10039] = {"西凉铁骑","蜀国大将马超率领的精锐骑兵，突击能力极强。"}
_tab_stringU[10040] = {"百夫长","中国古代军衔，管理百人的下级军官。"}
_tab_stringU[10043] = {"投弹手","使用火器作战的士兵，可以投掷炸弹攻击附近的敌人。"}
_tab_stringU[10044] = {"丹阳武卒","吴国的一支隐秘部队，可以投掷炸弹攻击附近的敌人。"}
_tab_stringU[10100] = {"妖术师","使用法术进行攻击的远程作战兵种。"}
_tab_stringU[10101] = {"方士","能使用单体医疗的远程作战兵种。"}
_tab_stringU[10102] = {"仙术师","擅长医疗的远程作战兵种，能治愈一群友军的伤病。"}
_tab_stringU[10103] = {"三弓床弩","破坏性极强的远程武器"}
_tab_stringU[10105] = {"霹雳车","射程极远的攻城武器，威力巨大"}
_tab_stringU[10120] = {"虎卫","三国时期魏国的特殊兵种之一，具有很强防御能力的近战兵种。"}
_tab_stringU[10122] = {"虎豹骑","三国时期魏国的特殊兵种之一，机动灵活，能适应各种战场。"}
_tab_stringU[10124] = {"朱雀","上古传说中的圣兽，四象之一，具有很强的范围伤害技能。"}
_tab_stringU[10126] = {"白马义从","三国时期的特殊兵种之一，行动迅速，并且是机动力最强的远程兵种。"}
_tab_stringU[10140] = {"巨象兵","皮糙肉厚的近战单位，擅长吸收伤害，体型巨大。"}
_tab_stringU[10142] = {"无当飞军","三国时期蜀汉的一支特种部队，擅长山地作战。"}
_tab_stringU[10144] = {"青龙","上古传说中的圣兽，四象之一，综合能力很强。"}
_tab_stringU[10146] = {"近卫兵","刘备麾下的近卫军。"}
_tab_stringU[10160] = {"神箭卫","擅长远距离作战的兵种。"}
_tab_stringU[10162] = {"鳞甲水兵","东吴的精锐水军，具有很强的综合能力。"}
_tab_stringU[10164] = {"玄武","上古传说中的圣兽，四象之一，拥有很强的生命力。"}
_tab_stringU[10166] = {"散仙","擅长各种法术，是非常强大的法术型兵种。"}

--新加
_tab_stringU[10200] = {"羽林卫","守护皇城的禁卫军。"}

_tab_stringU[11000] = {"张飞","三国时期蜀汉重要将领，与刘备，关羽结为兄弟。"}
_tab_stringU[11001] = {"陈宫","东汉末年著名谋士。性格刚直，足智多谋。"}
_tab_stringU[11002] = {"吕伯奢","曹操的故人。"}
_tab_stringU[11003] = {"苏双","涿县商人。"}
_tab_stringU[11004] = {"左慈","字元放，东汉末道教领袖，后人尊称他为[雅帝]。"}


_tab_stringU[11009] = {"太史慈","刘繇部下，后被孙策收降，自此为孙氏大将，助其扫荡江东。"}
_tab_stringU[11010] = {"太史慈","刘繇部下，后被孙策收降，自此为孙氏大将，助其扫荡江东。"}
_tab_stringU[11011] = {"老者","年老的长者。"}
_tab_stringU[11012] = {"中年男子","身材健壮的中年男子。"}
_tab_stringU[11013] = {"女子","穿着朴素的女子。"}
_tab_stringU[11014] = {"小孩","正在一旁玩耍的小孩。"}
_tab_stringU[11016] = {"于禁","曹魏五子良将之一，多年来南征北伐，屡立战功，勇猛果决。"}
_tab_stringU[11017] = {"屠各胡","匈奴休屠王的后裔。"}
_tab_stringU[11018] = {"守将","将在龙城在!"}
_tab_stringU[11019] = {"呼韩顿","匈奴萨满。"}
_tab_stringU[11020] = {"李协","匈奴右当户，右贤王之后。"}
_tab_stringU[11021] = {"呼衍丹","匈奴左当户。"}
_tab_stringU[11022] = {"於夫罗","匈奴左贤王，单于羌渠之子。"}
_tab_stringU[11023] = {"屠夫","神秘的屠夫，在血腥的战场上分解了无数士兵的尸体。"}
_tab_stringU[11024] = {"白狼王","塞外匈奴能驱役狼群的头领。"}

_tab_stringU[11029] = {"祸斗","外形象犬的妖兽，可以喷出火焰，所到之处常常带来恐怖的火灾！"}
_tab_stringU[11030] = {"应熊统领","传说中应熊的统领，其战斗力据说比普通的应熊力士强上百倍！"}

_tab_stringU[11032] = {"女娲后人","女娲一族的后代，不知什么原因而失去了记忆。"}
_tab_stringU[11033] = {"风伯","人面鸟身的天神，传说中是掌管风的神！"}
_tab_stringU[11034] = {"祸斗","外形象犬的妖兽，可以喷出火焰，所到之处常常带来恐怖的火灾！"}

_tab_stringU[11035] = {"朱灵","三国时期曹魏名将。！"}

_tab_stringU[11038] = {"帝江","上古四凶兽之一，又被称作混沌。通体透红，六足四翼，没有五官，却能通晓歌舞。"}
_tab_stringU[11046] = {"风睑","出没于崇山峻岭的妖兽，飞奔于山崖时必有狂风相随，周身狂风会伤人。"}
_tab_stringU[11047] = {"风睑幼狼","未成年的风睑，周身笼罩的狂风会伤人。"}


---黄月英召唤
_tab_stringU[11100] = {"火神炮","能发射火焰弹的机关弩炮。"}
_tab_stringU[11101] = {"机关神牛","能喷射火焰的强大机关兽。"}
--]]


_tab_string["["] = "【"
_tab_string["]"] = "】"
_tab_stringIE[1] = {"善攻"}
_tab_stringIE[2] = {"善攻"}
_tab_stringIE[3] = {"善攻"}
_tab_stringIE[4] = {"善守"}
_tab_stringIE[5] = {"善守"}
_tab_stringIE[6] = {"善守"}

_tab_stringIE[7] = {"勇猛"}
_tab_stringIE[8] = {"勇猛"}
_tab_stringIE[9] = {"勇猛"}
_tab_stringIE[10] = {"睿智"}
_tab_stringIE[11] = {"睿智"}
_tab_stringIE[12] = {"睿智"}
_tab_stringIE[13] = {"强壮"}
_tab_stringIE[14] = {"强壮"}
_tab_stringIE[15] = {"强壮"}
_tab_stringIE[16] = {"刚体"}
_tab_stringIE[17] = {"刚体"}
_tab_stringIE[18] = {"刚体"}
_tab_stringIE[19] = {"活力"}
_tab_stringIE[20] = {"活力"}
_tab_stringIE[21] = {"活力"}
_tab_stringIE[22] = {"灵韵"}
_tab_stringIE[23] = {"灵韵"}
_tab_stringIE[24] = {"灵韵"}
_tab_stringIE[25] = {"强攻"}
_tab_stringIE[26] = {"强攻"}
_tab_stringIE[27] = {"强攻"}
_tab_stringIE[28] = {"神农"}
_tab_stringIE[29] = {"神农"}
_tab_stringIE[30] = {"天灵"}
_tab_stringIE[31] = {"天灵"}
_tab_stringIE[32] = {"全才"}
_tab_stringIE[33] = {"吸生"}
_tab_stringIE[34] = {"吸生"}
_tab_stringIE[35] = {"吸生"}
_tab_stringIE[36] = {"神行"}
_tab_stringIE[37] = {"霸体"}
_tab_stringIE[38] = {"霸体"}

_tab_stringIE[39] = {"征伐"}
_tab_stringIE[40] = {"镇守"}
_tab_stringIE[41] = {"神魄"}
_tab_stringIE[42] = {"神勇"}
_tab_stringIE[43] = {"神睿"}








_tab_stringT[13] = {"合成素材",
	"可以用于上限为3星的卡片合成，太厉害了！",
	"可以用于上限为3星的卡片合成，太厉害了！",
	"可以用于上限为3星的卡片合成，太厉害了！",
	"可以用于上限为3星的卡片合成，太厉害了！",
	"可以用于上限为3星的卡片合成，太厉害了！",
}

_tab_stringT[15] = {"合成素材",
	"可以用于上限为5星的卡片合成，太厉害了！",
	"可以用于上限为5星的卡片合成，太厉害了！",
	"可以用于上限为5星的卡片合成，太厉害了！",
	"可以用于上限为5星的卡片合成，太厉害了！",
	"可以用于上限为5星的卡片合成，太厉害了！",
}

_tab_stringT[20] = {"合成素材",
	"可以用于上限为10星的卡片合成，太厉害了！",
	"可以用于上限为10星的卡片合成，太厉害了！",
	"可以用于上限为10星的卡片合成，太厉害了！",
	"可以用于上限为10星的卡片合成，太厉害了！",
	"可以用于上限为10星的卡片合成，太厉害了！",
	"可以用于上限为10星的卡片合成，太厉害了！",
	"可以用于上限为10星的卡片合成，太厉害了！",
	"可以用于上限为10星的卡片合成，太厉害了！",
	"可以用于上限为10星的卡片合成，太厉害了！",
	"可以用于上限为10星的卡片合成，太厉害了！",
}





_tab_string["__TEXT_PleaseChoose"] = "请选择要领取的道具..."
_tab_string["__TEXT_GetItem1"] = "你获得了首冲礼包的珍贵道具"
_tab_string["__TEXT_GetItem2"] = "恭喜您获得了道具奖励"
_tab_string["__TEXT_GetItem3"] = "献祭成功！获得新的红色装备"
_tab_string["__TEXT_GetItem4"] = "恭喜您获得活动奖励"
_tab_string["__TEXT_GetItem5"] = "您成功购买了"
_tab_string["__TEXT_GetItem6"] = "30元充值补偿"
_tab_string["__TEXT_GetItem_End"] = "已放入道具仓库"
_tab_string["__TEXT_Removepoint"] = "恢复行动力"
_tab_string["__TEXT_movepointshort"] = "行动力不足,请按右上角沙漏休息"
_tab_string["__UI_FrameTitle_team"] = "军队"
_tab_string["__TEXT_academySkill"] = "可学阵法"
_tab_string["__TEXT_visitorHero"] = "访问英雄"
_tab_string["__TEXT_guardHero"] = "驻守"


_tab_string["__Talk_000001"] = "****:\n    叫我女王大人啊！\n    啊啊啊啊啊！"
_tab_string["__TEXT_Reflash"] = "刷新"
_tab_string["__Attr_Hint_Hp"] = "血量"
_tab_string["__Attr_Hint_Mp"] = "法力值"
_tab_string["__Attr_Hint_Exp"] = "经验"
_tab_string["__Attr_Hint_Lev"] = "等级"

_tab_string["__TEXT_EXATTRPOINT"] = "剩余点数"
_tab_string["__Attr_Atk_Range"] = "射程"
_tab_string["__Attr_MovePoint"] = "速度"
_tab_string["__Attr_Hint_Lea"] = "统率"
_tab_string["__Attr_Hint_Led"] = "防御"
_tab_string["__Attr_Hint_Str"] = "武力"
_tab_string["__Attr_Hint_Int"] = "智力"
_tab_string["__Attr_Hint_Con"] = "体质"
_tab_string["__Attr_Hint_MovePoint"] = "速度"
_tab_string["__Attr_Hint_HpRecover"] = "生命回复/天"
_tab_string["__Attr_Hint_MpRecover"] = "法力回复/天"
_tab_string["__Attr_Hint_AllAttr"] = "全属性"
_tab_string["__Attr_Hint_LiveTime"] = "生存时间"

_tab_string["__Attr_tactics"] = "战术等级"
_tab_string["__Attr_hpSteal"] = "生命偷取"
_tab_string["__Attr_Hint_Hp:"] = "生命"
_tab_string["__Attr_Hint_Mp:"] = "法力"
_tab_string["__Attr_Hint_Exp:"] = "经验:"
_tab_string["__Attr_Hint_Lev:"] = "等级:"
_tab_string["__Attr_Hint_Num"] = "数量"
_tab_string["__Attr_GovernmentPost"] = "官职:"
_tab_string["__Attr_GovernmentPost_NO"] = "无头衔"
_tab_string["__Attr_Atk"] = "攻击"
_tab_string["__Attr_Def"] = "物防"
_tab_string["__Attr_Type"] = "类型"
_tab_string["__Attr_Strtype"] = "施法类型"
_tab_string["__Attr_Toughness"] = "法防"
_tab_string["__Attr_ATTACKMODE_NONE"] = "未知类型"
_tab_string["__Attr_ATTACKMODE_23"] = "近战攻城"
_tab_string["__Attr_ATTACKMODE_24"] = "远程攻城"
_tab_string["__Attr_ATTACKMODE_28"] = "近战"
_tab_string["__Attr_ATTACKMODE_29"] = "法术"
_tab_string["__Attr_ATTACKMODE_30"] = "远程"
_tab_string["__Attr_ATTACKMODE_31"] = "物理"
_tab_string["__Text_AllSpace"] = "全屏"
_tab_string["__Attr_Block"] = "体积"
_tab_string["__Attr_Crit"] = "暴"
_tab_string["__Attr_Absorb"] = "吸收"
_tab_string["__Attr_CritImmue"] = "免伤"
_tab_string["__Attr_Speed"] = "攻速"
_tab_string["__Attr_hpRecover"] = "生命回复"
_tab_string["__Attr_mpRecover"] = "法力回复"
_tab_string["__Attr_MoveRange"] = "移动范围"
_tab_string["__Attr_AtkRange"] = "释放距离"
_tab_string["__Attr_ManaCost"] = "消耗魔法"
_tab_string["__Attr_Skill"] = "技能"
_tab_string["__Attr_Have't_Skill"] = "无技能"
_tab_string["__Attr_cooldown"] = "冷却时间"
_tab_string["__Attr_duration"] = "持续时间"
_tab_string["__TEXT_PLAYERBAG_TIP"] = "仓库"
_tab_string["__TEXT_MAOBAG_TIP"] = "地图仓库"

_tab_string["__Item_Require_Level"] = "需求等级"
_tab_string["__Item_Require_Str"] = "需求武力"
_tab_string["__Item_Require_Def"] = "需求防御"
_tab_string["__Item_Require_Int"] = "需求智力"
_tab_string["__Item_Require_Led"] = "需求体质"
_tab_string["__Item_Require_Lea"] = "需求统率"

_tab_string["__Resource_Hint_Iron"] = "铁"
_tab_string["__Resource_Hint_Wood"] = "木头"
_tab_string["__Resource_Hint_Food"] = "食物"
_tab_string["__Resource_Hint_Gold"] = "黄金"
_tab_string["__Resource_Hint_Stone"] = "石头"
_tab_string["__Resource_Hint_Crystal"] = "水晶"

_tab_string["__Resource_Cycle_PerDay"] = "@number@ / 天"
_tab_string["__Resource_Cycle_PerWeek"] = "@number@ / 周"

_tab_string["__Dimensions_Mass"] = "一大群"
_tab_string["__Dimensions_Some"] = "一些"
_tab_string["__Dimensions_Less"] = "一小群"

_tab_string["__BtnLabel_Split"] = "分离"
_tab_string["__EventLabel_Test"] = "EFF 2013/8/2"

_tab_string["__TEXT_Get"] = "拿下"
_tab_string["__TEXT_Keep"] =  "保住"

_tab_string["__TEXT_GetScore"] = "获得积分"
_tab_string["__TEXT_FirstScore"] = "首通"

_tab_string["__TEXT_PlayTime"] = "所用时间"
_tab_string["__TEXT_GetAchi"] = "获得成就"
_tab_string["__TEXT_Difficulty"] = "关卡难度"
_tab_string["__TEXT_Evaluate"] = "总评价"

_tab_string["__TEXT_CreateNewPlayer"] = "创建新玩家"
_tab_string["__TEXT_noAppraise"] = "此物品还未被鉴定"
_tab_string["__TEXT_noUnderstand"] = "此技能还未领悟"

_tab_string["__TEXT_Card"] = "英雄令"
_tab_string["__TEXT_TuJian"] = "图鉴"
_tab_string["__TEXT_ShenQi"] = "神器"
_tab_string["__TEXT_OrangeEquip"] = "橙装"
_tab_string["__TEXT_Achievement"] = "成就"
_tab_string["__TEXT_Task"] = "任务"
_tab_string["__TEXT_Activity"] = "活动"
_tab_string["__TEXT_PlayerList"] = "玩家列表"
_tab_string["__TEXT_TemporaryNone"] = "暂无"

_tab_string["__TEXT_GameStart"] = "游戏开始"
_tab_string["__TEXT_PlaceStep"] = "排兵布阵"
_tab_string["__TEXT_GameScienticEffect"] = "本局科技效果"
_tab_string["__TEXT_WinCurrentStage"] = "通关本难度"
_tab_string["__TEXT_NoWinStageRecord"] = "暂无通关战绩记录！"
_tab_string["__TEXT_Skip"] = "跳过"
_tab_string["__TEXT_Fail"] = "失败"
_tab_string["__TEXT_Draw"] = "平局"
_tab_string["__TEXT_Exception"] = "异常"
_tab_string["__TEXT_Outsync"] = "不同步"
_tab_string["__TEXT_Surrand"] = "投降"
_tab_string["__TEXT_NoBattle"] = "暂无交战"
_tab_string["__TEXT_RecentBattle"] = "最近战绩"
_tab_string["__TEXT_Duel"] = "决斗"
_tab_string["__TEXT_Quick"] = "疾速"
_tab_string["__TEXT_Alive"] = "牺牲"
_tab_string["__TEXT_Delay"] = "顽强"
_tab_string["__TEXT_Heal"] = "军医"
_tab_string["__TEXT_Surrender"] = "逃跑"
_tab_string["__TEXT_Weak"] = "虚弱"
_tab_string["__TEXT_Defend"] = "抵抗"
_tab_string["__TEXT_Extra"] = "额外"
_tab_string["__TEXT_SurrenderConfirm"] = "投降后本局游戏判定为失败"
_tab_string["__TEXT_SurrenderConfirm2"] = "逃跑后本局游戏判定为无效，并扣除1点战功积分（如果您通过其它方式离开游戏，将受到更大惩罚）"
_tab_string["__TEXT_SurrenderConfirm3"] = "是否投降？"
_tab_string["__TEXT_SurrenderConfirm4"] = "是否逃跑？"
_tab_string["__TEXT_SurrenderConfirm5"] = "是否离开游戏？"
_tab_string["__TEXT_SurrenderConfirm6"] = "与电脑对战不计入您的战绩"
_tab_string["__TEXT_SurrenderConfirm7"] = "电脑将托管你的队伍继续战斗，通关后您不会获得奖励"
_tab_string["__TEXT_SurrenderConfirm8"] = "退出后您当前的战斗进度将会丢失"
_tab_string["__TEXT_PVPSurrenderDisable"] = "对决进行 1 回合后，才允许投降！"
_tab_string["__TEXT_PVPSurrenderTip_1"] = "投降会扣除一定的天梯分，并使你在 1 个小时内的收益降低，请慎重考虑"
_tab_string["__TEXT_PVPSurrenderTip_2"] = "投降会按照对决失败处理，并使你在 1 个小时内的收益降低，请慎重考虑"
_tab_string["__TEXT_AIOprConfirm"] = "你确定要让 [电脑] 托管你的队伍吗?"
_tab_string["__TEXT_LeaveBattlefield"] = "离开战场"
_tab_string["__TEXT_NetBattlefieldTimeOut"] = "房间已超时，操作耗时较长的一方扣除天梯分数。"
_tab_string["__TEXT_ArmyLost"] = "损失 "
_tab_string["__TEXT_EnemyKilled"] = "损失 "
_tab_string["__TEXT_CombatEvaluation"] = "战斗评价 "
_tab_string["__TEXT_HistoryEvaluation"] = "今日最高战绩 "
_tab_string["__TEXT_DefProgress"] = "防守进度"
_tab_string["__TEXT_KillUnit"] = "消灭单位"
_tab_string["__TEXT_perfect"] = "未损一兵一卒！"
_tab_string["__TEXT_Roundcount"] = "战斗回合数"
_tab_string["__TEXT_Roundcount1"] = "回合数"
_tab_string["__TEXT_Duration"] = "持续时间"
_tab_string["__TEXT_Round"] = "回合"
_tab_string["__TEXT_Confirm"] = "确认"
_tab_string["__TEXT_Use"] = "使用"
_tab_string["__TEXT_UnUse"] = "卸下"
_tab_string["__TEXT_RestConfirm"] = "重转"
_tab_string["__TEXT_RestConfirm1"] = "重转资源"
_tab_string["__TEXT_RestConfirm2"] = "重转宝箱"
_tab_string["__TEXT_RestConfirm3"] = "免费重转宝箱"
_tab_string["__TEXT_TOBEGIN"] = "后开始"
_tab_string["__TEXT_TOFINISH"] = "后结束"
_tab_string["__TEXT_HASFINISHED"] = "已结束"
_tab_string["__TEXT_NOTYETBEGIN"] = "未开始"
_tab_string["__TEXT_LONGTIMEACTIVE"] = "长期有效"
_tab_string["__TEXT_SIGNIN"] = "签到"
_tab_string["__TEXT_SEND"] = "发送"
_tab_string["__TEXT_BTN_MEMBERLIST"] = "成员列表"
_tab_string["__TEXT_BTN_GROUPBATTLE"] = "军团副本"
_tab_string["__TEXT_BTN_GROUPLIST"] = "军团排名"
_tab_string["__TEXT_BTN_MYSHENGWANG"] = "我的声望"


_tab_string["__TEXT_SynthesisOfCard"] = "合成卡片付费"
_tab_string["__TEXT_Wishing"] = "祭坛"
_tab_string["__TEXT_Learning"] = "学习"
_tab_string["__TEXT_GROUP_IN"] = "所属军团"
_tab_string["__TEXT_Accept"] = "接受"
_tab_string["__TEXT_Refuse"] = "拒绝"
_tab_string["__TEXT_Cancel"] = "取消"
_tab_string["__TEXT_Ready"] = "准备就绪"
_tab_string["__TEXT_Continue"] = "继续游戏"
_tab_string["__TEXT_Waiting"] = "接受挑战"
_tab_string["__TEXT_ViewReplay"] = "观看录像"
_tab_string["__TEXT_ChallengeNPC"] = "挑战电脑"
_tab_string["__TEXT_ChallengeRankKing"] = "挑战名人"
_tab_string["__TEXT_ChallengeRank"] = "第#RANK#名  "
_tab_string["__TEXT_PVPNPCTip"] = "你要挑战 #NAME# 吗？"
_tab_string["__TEXT_PVPNPCRule"] = "挑战电脑对手仅用于练习，分数不计"
_tab_string["__TEXT_PVPChallengeTip"] = "可以获得积分，输赢不会影响天梯分数"
_tab_string["__TEXT_AFK"] = ""
_tab_string["__TEXT_GameHall"] = "游戏大厅"
_tab_string["__TEXT_SelectedMap"] = "选择关卡"
_tab_string["__TEXT_StartMap"] = "进入关卡"
_tab_string["__TEXT_GameOptional"] = "游戏选项"
_tab_string["__TEXT_GamePause"] = "游戏暂停"
_tab_string["__TEXT_FileRestore"] = "游戏数据管理"
_tab_string["__TEXT_ShiftData0"] = "账号"
_tab_string["__TEXT_ShiftDataC"] = "数据迁出"
_tab_string["__TEXT_ShiftDataCheckIn"] = "恢复数据"
_tab_string["__TEXT_ShiftDataCheckIn_INFO"] = "使用已有账号恢复游戏数据"
_tab_string["oldidcheck"] = "账号安全信息"
_tab_string["check_in_info1"] = "必须先在此账号原来绑定的设备上，执行“游戏数据迁出”操作，确保游戏数据已同步到最新。"
_tab_string["check_in_info2"] = "在此设备上恢复游戏数据，将覆盖此设备上原有的任何游戏数据。"
_tab_string["__TEXT_ShiftData"] = "账号管理 - 数据迁出"
_tab_string["__TEXT_ShiftDataTip"] = "注意！ 数据转移功能会把当前使用的主公的数据以及游戏币，充值记录等信息转移到其他设备，当前设备上的所有游戏数据则会全部被清空！如果同意请点击 【确定】 按钮。\n\n\n  本功能只支持转移一个主公数据请慎重选择\n\n            整个操作过程请保持网络畅通！"
_tab_string["__TEXT_FileRestoreTip"] = "恢复您最后一份存档 \n如果同意请点击 【确定】按钮 \n\n本功能7天内只能使用一次"
_tab_string["__TEXT_FileRestoreTipFirst"] = "您确定要申请恢复最近一份存档吗？"
_tab_string["__TEXT_FileRestoreTipFirstCheck"] = "曾经用此设备进行过游戏, 但当前设备上无游戏数据, 如果您是不小心删除了游戏, 可以申请数据恢复服务!"
_tab_string["__TEXT_FileRestoreTipEnd"] = "由于您在7天之内已经恢复过存档，故不能再次使用此功能..."
_tab_string["__TEXT_FileRestoreTipEnd1"] = "您尚未开通游戏数据恢复服务, 请联系管理员!"
_tab_string["__TEXT_SendSaveFileBack"] = "申请在此设备上恢复数据"
_tab_string["__TEXT_SendSaveFileBackNo"] = "不用了,谢谢!"
_tab_string["__TEXT_ShiftDataTip1"] = "进行过迁出和迁入的设备，7天之后才能再次迁移."
_tab_string["__TEXT_ShiftDataTip1a"] = "发生过数据迁入，7天之内不能向其转移."
_tab_string["__TEXT_ShiftDataTip1b"] = "新游戏账号"
_tab_string["__TEXT_ShiftDataTip1c"] = "当前账号于"
_tab_string["__TEXT_ShiftDataTip1d"] = "发生数据迁移, 7天之内不能再发起。"
_tab_string["__TEXT_ShiftDataTip2"] = "迁出成功后会将当前设备的游戏数据完全清除."
_tab_string["__TEXT_ShiftDataTip3"] = "游戏数据迁入新设备时, 新设备的原有数据会被覆盖."
_tab_string["__TEXT_ShiftDataTip4_0"] = "您的游戏账号:"
_tab_string["__TEXT_ShiftDataTip4"] = "本设备绑定账号:"
_tab_string["__TEXT_ShiftDataTip41"] = "本设备游戏账号:"
_tab_string["__TEXT_ShiftDataTip5"] = "新设备游戏账号:"
_tab_string["__TEXT_ShiftDataTip6"] = "游戏密码:"
_tab_string["__TEXT_ShiftDataTip7"] = "新设备需设置密码,才能使用【数据迁出】功能."
_tab_string["__TEXT_ShiftDataTip8"] = "注意事项:"
_tab_string["__TEXT_ShiftDataTip9"] = "开始迁移"
_tab_string["__TEXT_ShiftDataTip10"] = "本游戏单机可玩, 当玩家更换设备后, 则需要先用【数据迁出】功能, 然后在新设备上【恢复数据】。"
_tab_string["__TEXT_ShiftDataTip11"] = "迁移角色为: 【"
_tab_string["__TEXT_ShiftDataTip42"] = "当前游戏角色:"
_tab_string["__TEXT_ShiftDataTipCoin"] = "游戏币数量:"
_tab_string["["] = "【"
_tab_string["]"] = "】"
_tab_string["__TEXT_ShiftDataError97"] = "上次转档未完成"
_tab_string["__TEXT_ShiftDataError97Info"] = "上次迁移时间是"
_tab_string["__TEXT_ShiftDataError98"] = "数据已转出，不能再次迁移"
_tab_string["__TEXT_ShiftDataError99"] = "您的账号异常，无法使用此功能"
_tab_string["__TEXT_ShiftDataError100"] = "目标设备账号密码不匹配"
_tab_string["__TEXT_ShiftDataError101"] = "不能迁移到相同账号"
_tab_string["__TEXT_FileRestoreRuleTitleTip"] = "恢复规则:"
_tab_string["__TEXT_FileRestoreRuleTip"] = "1. 您可以恢复最近正在玩的一个君主角色数据 \n2. 此项服务需要后台与您以前的奖励, 充值, 历史商店购买记录等做匹配, 无法频繁操作, 每隔七天才能使用一次, 敬请谅解!"
_tab_string["__TEXT_ShiftDataErrorTooBig"] = "转移数据出错，请联系管理员!" 
_tab_string["__TEXT_ShiftDataErrorNoData"] = "数据不存在，请联系管理员!"
_tab_string["old_id"] = "游戏账号"
_tab_string["old_pass"] = "游戏密码"
_tab_string["old_coin"] = "游戏币数量"
_tab_string["old_score"] = "老设备剩余积分"
_tab_string["confirm_checkin"] = "确认恢复"
_tab_string["__TEXT_ShiftDataMapLimitTip"] = "通关【桃园结义】，才能进行数据迁移"
_tab_string["__TEXT_ShiftDataBugClosed"] = "该功能正在修复中，即将恢复开放"
_tab_string["__TEXT_MapBuildMaxNum"] = "本地图最多建造"

_tab_string["__TEXT_Player_DeleteAllTitle"] = "数据迁移"
_tab_string["__TEXT_Player_DeleteAll"] = "游戏数据已成功迁出，现在您可以去新的设备上使用［恢复数据］来继续游戏！"
_tab_string["__TEXT_Player_DeleteAll1"] = "请务必记住您的信息："
_tab_string["__TEXT_Player_DeleteAll2"] = "点击确定后以上信息将帮您截图保存到相册"
_tab_string["__TEXT_Player_GetGameData"] = "大人我们又见面了！现在可以继续征战了！～"
_tab_string["__TEXT_Player_GetGameData1"] = "数据迁移已完成！"

_tab_string["__TEXT_UpdateTipInfo"] = "点击确认后将关闭游戏，\n重新启动后，会进行自动更新！"
_tab_string["__TEXT_UpdateTipInfoVer2"] = "版本更新，请重新下载游戏"

_tab_string["__TEXT_DateErrorInfo"] = "您的游戏数据发生识别错误!"

_tab_string["__TEXT_shareEx"] = "推荐"
_tab_string["__TEXT_human"] = "人"
_tab_string["__TEXT_FinishCount"] = "通关次数"
_tab_string["__TEXT_KillBoss"] = "击杀主将"
_tab_string["__TEXT_DrawPurple"] = "抽到紫卡"
_tab_string["__TEXT_TDSL02_NOTICE1"] = "凡人，帮我解开封印，你将得到我的力量！" --开场提示文字1
_tab_string["__TEXT_TDSL02_NOTICE2"] = "我已不知被困在此多久……五百年？一千年？" --开场提示文字2
_tab_string["__TEXT_TDSL02_NOTICE3"] = "封印的力量太强大了，我无法独自解开！" --开场提示文字3
_tab_string["__TEXT_TDSL02_NOTICE4"] = "我……渴望自由！" --开场提示文字4
_tab_string["__TEXT_TDSL02_OPEN"] = "凡人！四象之门已开启，去挑战四方使者，解开封印吧！" --开启四神兽传送门
_tab_string["__TEXT_TDSL02_ANGRY"] = "尝尝我被封印了千年的怒火吧！"
_tab_string["__TEXT_TDSL02_QINGLONG"] = "青龙之印已经解开" --青龙
_tab_string["__TEXT_TDSL02_BAIHU"] = "白虎之印已经解开" --白虎
_tab_string["__TEXT_TDSL02_ZHUQUE"] = "朱雀之印已经解开" --朱雀
_tab_string["__TEXT_TDSL02_XUANWU"] = "玄武之印已经解开" --玄武


_tab_string["__TEXT_share"] = "好友推荐"
_tab_string["__TEXT_ResetLevel"] = "重玩本关"
_tab_string["__TEXT_ResetTry"] = "继 续"
_tab_string["__TEXT_ResetTryBack"] = "大 厅"
_tab_string["__TEXT_ResetTryCount"] = "（还可尝试%d次）"
_tab_string["__TEXT_BBS"] = "游戏论坛"
_tab_string["__TEXT_PlayerRank"] = "排行榜"
_tab_string["__TEXT_Me"] = "我"
_tab_string["__TEXT_Ally"] = "队友"
_tab_string["__TEXT_KillEnemy"] = "杀敌"
_tab_string["__TEXT_Solider"] = "小兵"
_tab_string["__TEXT_MyRank"] = "我的排名"
_tab_string["__TEXT_Score"] = "得分"
_tab_string["__TEXT_MyScore"] = "我的得分"
_tab_string["__TEXT_RankNum"] = "排名"
_tab_string["__TEXT_Back"] = "返回"
_tab_string["__TEXT_Close"] = "关闭"
_tab_string["__TEXT_QinLaoJiang"] = "勤劳奖"
_tab_string["__TEXT_Savehint1"] = "获得奖励"
_tab_string["__TEXT_RewardTabletitle"] = "@visitor@ 漂亮的击败了 @target@ 获得以下奖励"
_tab_string["__TEXT_RewardTabletitle1"] = "击败了\n \n 获得以下战利品"
_tab_string["__TEXT_RewardTabletitle2"] = " \n \n 获得以下战利品"
--_tab_string["__TEXT_Savehint2"] = "继续游戏"
_tab_string["__TEXT_MainMenu"] = "主菜单"
_tab_string["__TEXT_MainInterface"] = "主界面"
_tab_string["__TEXT_ExitGame"] = "退出游戏"
_tab_string["__TEXT_Delete"] = "删除"
_tab_string["__TEXT_Rename"] = "改名"
_tab_string["__TEXT_Setname"] = "主公起名"
_tab_string["__TEXT_NextChapter"] = "下一关"
_tab_string["__TEXT_LastChapter"] = "上一关"
_tab_string["__TEXT_NextPage"] = "下一页"
_tab_string["__TEXT_LastPage"] = "上一页"
_tab_string["__TEXT_UnitPrice"] = "单价"
_tab_string["__TEXT_TotalPrices"] = "总价"
_tab_string["__TEXT_UseResources"] = "消耗资源"
_tab_string["__TEXT_BuildingRequire"] = "需要建筑"
_tab_string["__TEXT_CanNotBuilding"] = "今天工事已毕，请明日再来..."
_tab_string["__TEXT_MSGTitle"] = "禀大人"
_tab_string["__TEXT_DoNotUserRequire"] = "不需要前置建筑"
_tab_string["__TEXT_AfterBuilding"] = "建造成功后，"
_tab_string["_AI_ActionInfo"] = "@visitor@正在行动中..."
_tab_string["__TEXT_BuildingWarn"] = "您的主城还未安排工事建造，是否结束当天工事安排？"
_tab_string["__TEXT_MovepointWarn"] = "您的英雄还能继续移动，是否确定就此安营扎寨？"
_tab_string["__TEXT_DoubleWarn"] = "您今天没有安排主城工事，将领们也还能继续移动，是否就此结束今天的全部安排？"
_tab_string["__TEXT_PartArmy"] = "分兵"

_tab_string["__TEXT_RankBoardIntro"] = "每日排行介绍"
_tab_string["__TEXT_RankBoardIntro_PVP"] = "竞技场排行榜"
_tab_string["__TEXT_RankBoardHint1.1"] = "每日挑战“"
_tab_string["__TEXT_RankBoardHint1.2"] = "”得分前"
_tab_string["__TEXT_RankBoardHint1.3"] = "名的玩家将获得奖励。"
_tab_string["__TEXT_RankBoardHint2"] = "得分每日重置。奖励次日发放。"
_tab_string["__TEXT_RankBoardHint3"] = "排名奖励："
_tab_string["__TEXT_WORD_DI"] = "第"
_tab_string["__TEXT_WORD_TO"] = "至"
_tab_string["__TEXT_WORD_MING"] = "名"
_tab_string["__TEXT_WORD_DANG"] = "档"
_tab_string["__TEXT_ENDLESS_DISBALE_REPLY"] = "无尽模式不支持游戏内重玩"
_tab_string["__TEXT_PVP_DISBALE_REPLY"] = "PVP模式不支持游戏内重玩"
_tab_string["__TEXT_HERO_DISBALE_REPLY"] = "精英模式游戏结束后不能重玩"
_tab_string["__TEXT_HERO__BEGIN_DISBALE_REPLY"] = "精英模式开战后不能重玩"
_tab_string["__TEXT_QYG_GUIDE_DISBALE_REPLY"] = "完成引导后才能重玩"
_tab_string["__TEXT_QYG_GUIDE_DISBALE_RETURN"] = "尚未完成试炼战场，无法离开！"
_tab_string["__TEXT_NOT_ALLOWED"] = "禁用的"
_tab_string["__TEXT_NOT_ALLOWE"] = "禁用"
_tab_string["__TEXT_MAX_LV"] = "最高等级"
_tab_string["__TEXT_ENEMY_BUFF"] = "敌人增益"
_tab_string["__TEXT_SGININ_ACTIVITY_NOTICE"] = "每日签到一次即可领取相关奖励"
_tab_string["__TEXT_Trialrule"] = "注意: 娱乐地图适合满级玩家英雄进入,无经验值。"
_tab_string["__TEXT_GameResult"] = "游戏结果"
_tab_string["__TEXT_Disband"] = "你要遣散部队:\n"
_tab_string["__TEXT_DisbandTitle"] = "遣散部队"
_tab_string["__TEXT_Visited"] = "已访问"
_tab_string["__TEXT_YourHero"] = "您的英雄"
_tab_string["__TEXT_HeroVisited"] = "这里已被访问过..."
_tab_string["__TEXT_HeroNotVisit"] = "还未访问过这里..."
_tab_string["__TEXT_GuardHero"] = "守城将领："
_tab_string["__TEXT_LastSave"] = "退回一天"
_tab_string["__TEXT_Last3DaysSave"] = "退回三天"
_tab_string["__TEXT_GetHeroCardText"] = "获得英雄令"
_tab_string["__TEXT_GetBattlefieldSkill"] = "获得战术技能卡"
_tab_string["__TEXT_GetBattlefieldArmyCard"] = "获得兵种卡"
_tab_string["__TEXT_RankNum_Head"] = "第 "
_tab_string["__TEXT_Chinese_Day_Index"] = "第 "
_tab_string["__TEXT_RankNum_Week"] = " 周 "
_tab_string["__TEXT_RankNum_Day"] = " 天"
_tab_string["__TEXT_RankNum_End"] = " 名:"
_tab_string["__TEXT_Branch"] = " 页"
_tab_string["__TEXT_BranchTipText"] = "上下滑动可翻页"
_tab_string["__TEXT_Rank_Res"] = "资源:"
_tab_string["__TEXT_Rank_Hero"] = "英雄："
_tab_string["__TEXT_Rank_Military"] = "军力:"
_tab_string["__TEXT_RenewHero_Text"] = "在你拥有的城池内的客栈里可以找回你的英雄"
_tab_string["__TEXT_ImperialAcademyTitle"] = "在这里可以学到新的阵法"
_tab_string["__TEXT_CAST_TYPE_NONE"] = "未知"
_tab_string["__TEXT_CAST_TYPE_MOVE"] = "移动类"
_tab_string["__TEXT_CAST_TYPE_IMMEDIATE"] = "自身施放"
_tab_string["__TEXT_CAST_TYPE_SKILL_TO_GRID"] = "范围施放"
_tab_string["__TEXT_CAST_TYPE_SKILL_TO_GROUND"] = "地面施放"
_tab_string["__TEXT_CAST_TYPE_SKILL_TO_GROUND_BLOCK"] = "有效点施放"
_tab_string["__TEXT_CAST_TYPE_SKILL_TO_GROUND_BLOCK_NOOVERLAPS"] = "有效点施放"
_tab_string["__TEXT_CAST_TYPE_SKILL_TO_GROUND_MOVE_TO_POINT"] = "范围内施放"
_tab_string["__TEXT_CAST_TYPE_SKILL_TO_GROUND_MOVE_TO_POINT_BLOCK"] = "范围有效点"
_tab_string["__TEXT_CAST_TYPE_SKILL_TO_UNIT_MOVE_TO_POINT"] = "范围内施放"
_tab_string["__TEXT_CAST_TYPE_SKILL_TO_UNIT"] = "目标施放"
_tab_string["__TEXT_CAST_TYPE_SKILL_TO_UNIT_IMMEDIATE"] = "随机目标施放"
_tab_string["__TEXT_CAST_TYPE_SKILL_AUTO"] = "被动"
_tab_string["__TEXT_HireHero"] = "招募英雄："
_tab_string["__TEXT_ReviveHero"] = "复活英雄："
_tab_string["__TEXT_WeeklyHireComplete"] = "(本周已招募过英雄)"

_tab_string["test_max1"] = "输入军团名称"
_tab_string["__TEXT_Guild_Join"] = "申请"
_tab_string["__TEXT_Guild_JoinAgree"] = "同意"
_tab_string["__TEXT_Guild_DoSuccess"] = "操作成功"
_tab_string["__TEXT_Guild_JoinSuccess"] = "申请成功"
_tab_string["__TEXT_Guild_JoinError105"] = "军团人数已满，无法加入"
_tab_string["__TEXT_Guild_CreateSuccess"] = "创建成功"
_tab_string["__TEXT_Guild_HasJoinedOneGuild"] = "已加入过军团不能创建"
_tab_string["__TEXT_Guild_Kickout"] = "移除"
_tab_string["__TEXT_Guild_Kickout_Success"] = "移除成功"
_tab_string["__TEXT_Guild_Name"] = "名字"
_tab_string["__TEXT_Guild_Descripe"] = "介绍"
_tab_string["__TEXT_Guild_Creator"] = "创建者"
_tab_string["__TEXT_Guild_Create"] = "创建"
_tab_string["__TEXT_Guild_Member/Max"] = "成员/上限"
_tab_string["__TEXT_Guild_Lively"] = "活跃度"
_tab_string["__TEXT_Create_GuildName"] = "请输入你要创建的军团名字"
_tab_string["__TEXT_Change_GuildDesc"] = "请输入军团的介绍"
_tab_string["__TEXT_Change_GuildName"] = "请输入军团的名字"
_tab_string["__TEXT_Create_Guild_Tip"] = "需要消耗"
_tab_string["__TEXT_Guild_JoinTime"] = "加入日期"
_tab_string["__TEXT_Guild_CreateDay"] = "创建日期"
_tab_string["__TEXT_Guild_LastLogin"] = "最后登录"
_tab_string["__TEXT_Guild_graduate"] = "毕业人数"
_tab_string["__TEXT_Guild_Manage_fix"] = "修改"
_tab_string["__TEXT_Guild_Manage"] = "管理"
_tab_string["__TEXT_Guild_NewMan"] = "新人"
_tab_string["__TEXT_Guild_Vip"] = "会员"
_tab_string["__TEXT_Guild_Chairman"] = "会长"
_tab_string["__TEXT_Guild_Assitant"] = "助理"
_tab_string["__TEXT_Guild_Member"] = "成员"
_tab_string["__TEXT_ChooseLegion"] = "请选择你要加入的军团"
_tab_string["__TEXT_LegionName"] = "军团名"
_tab_string["__TEXT_LegionLv"] = "主城等级"
_tab_string["__TEXT_NeedBuilding"] = "建造以下建筑需要的前置科技"
_tab_string["__TEXT_ProvideResource"] = "资源产出"
_tab_string["test_max"] = "最多输入16个字"
_tab_string["__TEXT_ChangeDesc_Success"] = "修改成功"
_tab_string["__TEXT_Guild_JoinCancel"] = "取消成功"
_tab_string["__TEXT_Assistant_Success"] = "任命军团助理成功"
_tab_string["__TEXT_Assistant_Cancel_Success"] = "取消任命军团助理成功"
_tab_string["__TEXT_Guild_JoinCance2"] = "已经加入或申请军团"
_tab_string["__TEXT_Guild_Kickout"] = "移除"
_tab_string["__TEXT_Guild_Assistant"] = "任命助理"
_tab_string["__TEXT_Guild_AssistantCancel"] = "取消任命"
_tab_string["__TEXT_Guild_Kickout_Success"] = "移除成功"
_tab_string["__TEXT_Guild_Kickout_Fail"] = "最近7天还在登录游戏的玩家不能移除"
_tab_string["__TEXT_Guild_Kickout_Fail_State"] = "不是会员无法清除"
_tab_string["__HaveUnlock"] = "已解锁"
_tab_string["__HaveNotUnlock"] = "未解锁"
_tab_string["__IsNotEnable"]="暂未开放"
_tab_string["__TEXT_GROUP_ASSISTANT_HINT1"]="1、会长可委任任意一位成员担任军团助理，协助管理日常事务。"
_tab_string["__TEXT_GROUP_ASSISTANT_HINT2"]="2、会长长期缺席的军团，系统会自动委任一名助理。"
_tab_string["__TEXT_GROUP_ASSISTANT_HINT3"]="3、系统委任的助理玩家需符合以下条件："
_tab_string["__TEXT_GROUP_ASSISTANT_HINT4"]="        (1). 军团创建时间达到30天"
_tab_string["__TEXT_GROUP_ASSISTANT_HINT5"]="        (2). 主城等级达到3级"
_tab_string["__TEXT_GROUP_ASSISTANT_HINT6"]="        (3). 会长近7日未登录"
_tab_string["__TEXT_GROUP_ASSISTANT_HINT7"]="        (4). 军团助理尚未委任"
_tab_string["__TEXT_GROUP_ASSISTANT_HINT8"]="        (5). 该成员声望达到3000"
_tab_string["__TEXT_GROUP_ASSISTANT_HINT9"]="        (6). 该成员近7日的贡献值是本军团最高"
_tab_string["__TEXT_GROUP_ASSISTANT_HINT10"]="        (7). 该成员近48小时登录过"
_tab_string["__TEXT_GROUP_ASSISTANT_HINT11"]="4、会长可取消委任军团助理。"
_tab_string["__TEXT_GROUP_ASSISTANT_HINT12"]="5、军团助理近7日未登录，将被系统自动取消委任。"
_tab_string["__TEXT_NormalProcess"] = "正常流程"
_tab_string["__TEXT_Fakedata"] = "假数据"
_tab_string["__TEXT_QuitLegionReally"] = "退出军团后，您在军团的贡献度将被清0，累计的声望和对应的官阶也被清零。\n确认要退出吗？"
_tab_string["__TEXT_KickMemberReally"] = "你确定要移除该成员吗？"
_tab_string["__TEXT_AppointAssitantReally"] = "你确定要任命该成员为军团助理？"
_tab_string["__TEXT_DisappointAssitantReally"] = "你确定要取消任命该成员军团助理？"
_tab_string["__TEXT_FORCE"] = "势力"
_tab_string["__TEXT_Guild_JoinError103"] = "每天只能加入或者退出1次军团，请明天再来吧！"
_tab_string["__TEXT_SUCCESSED"] = "成功"
_tab_string["__TEXT_PRESTIGE"] = "声望"
_tab_string["__TEXT_PRESTIGE_TIPS"] = "声望算法：个人向军团贡献的资源！"
_tab_string["__TEXT_DISBAND"] = "解散"
_tab_string["__TEXT_DisbandLegionReally"] = "解散军团后，您和全体成员在军团的贡献度将被清0，累计的声望和对应的官阶也被清零。\n确认要解散吗？"
_tab_string["__TEXT_DisbandLegionError"] = "军团成员只剩1人时，才能解散！"

_tab_string["__TEXT_CanHire"] = "可雇佣"
_tab_string["__TEXT_EnterMap"] = "进入战役"
_tab_string["__TEXT_EnterChallenge"] = "进入挑战"
_tab_string["__TEXT_OpenMapBag"] = "确认购买"
_tab_string["__TEXT_EnterTraining"] = "进入地图"
_tab_string["__TEXT_ContinueMap"] = "继续战役"
_tab_string["__TEXT_CanGetCard"] = "可得英雄令"
_tab_string["__TEXT_ReadyToFight"] = "接受挑战"
_tab_string["__TEXT_GoodFortune"] = "手气不错"
_tab_string["__TEXT_AutoMatch"] = "自动匹配"
_tab_string["__TEXT_WorthyOppoent"] = "实力相近的对手"
_tab_string["__TEXT_ShowReplay"] = "显示录像"
_tab_string["__TEXT_NotReadyToFight"] = "取消"
_tab_string["__TEXT_ChallengePlayer"] = "确定要挑战玩家\n"
_tab_string["__TEXT_PVPDuelConfim"] = "向玩家 #NAME# 发起挑战"
_tab_string["__TEXT_PVPDuelRule"] = "对决规则"
_tab_string["__TEXT_PVPRule01"] = "每类兵种的战术卡片最多使用 #P1# 张"


_tab_string["__TEXT_DeleteItemMaybe"] = "分解道具可得"

_tab_string["__TEXT_RequireHeroCard"] = "需要英雄令"
_tab_string["__TEXT_RequireHeroCardEx"] = "您没有英雄令，无法打开商店"
_tab_string["__TEXT_RequireAliveHero"] = "需要选择一个英雄才能打开商店"
_tab_string["__TEXT_BuyItemMaxN"] = "宝箱堆叠数量最多99个,请用掉后再来购买！"

_tab_string["__TEXT_RequireHeroCardEx2"] = "无英雄令的英雄不能使用仓库"

_tab_string["__TEXT_CanGetReward"] = "可得奖励"

_tab_string["__TEXT_NextDayTipInfoText"] = "英雄当天的行动力已用完，可以点击右上角的沙漏按钮来结束一天!"
_tab_string["__TEXT_DeletePlayer_Pre"] = "你确定要删除玩家"
_tab_string["__TEXT_DeletePlayer_Back"] = "的个人档案吗?"
_tab_string["__TEXT_DeleteItem_Pre"] = "你确定要分解道具"
_tab_string["__TEXT_DeleteItem_All"] = "你确定要分解背包和仓库内的全部低品质（白色,蓝色）道具吗？\n"
_tab_string["__TEXT_CanNotDeleteItem"] = "道具 #NAME# 不能被分解"
_tab_string["__TEXT_CanNotWishItem"] = "道具 #NAME# 不能用于献祭"
_tab_string["__TEXT_BattlefieldSkill_Confirm"] = "每局游戏只能部署一次战术技能卡，您确认按照这个配置进行游戏？"
_tab_string["__TEXT_Can'tUseWishingWell"] = "只有红色顶级装备才可放入"
_tab_string["__TEXT_Can'tUseWishingWell1"] = "不能使用限时道具"
_tab_string["__TEXT_CreatePlayerInfo"] = "请先创建一个玩家"

_tab_string["__TEXT_Stuff_Name"] = "锻造材料"

_tab_string["__TEXT_DeleteBFSCard"] = "兑换积分"
_tab_string["__TEXT_Can'tDeleteBFSCard"] = "稀有卡不能兑换积分"
_tab_string["__TEXT_MakeCardNeedNet"] = "合成卡片需要联网"

_tab_string["__TEXT_DeleteItemForged_Pre"] = "重铸道具"
_tab_string["__TEXT_Recast_Lose"] = "损失属性"
_tab_string["__TEXT_Recast_Keep"] = "保留属性"
_tab_string["__TEXT_DeleteItemForged_Pre1"] = "会损失"

_tab_string["__TEXT_FORGED"] = "锻造"
_tab_string["__TEXT_ZHIWU"] = "职务"
_tab_string["__TEXT_ACTIVEDAY"] = "活跃天数"
_tab_string["__TEXT_FORGED_ITP"] = "把道具拖入此槽中，可以锻造。"
_tab_string["__TEXT_Decompos_Tip"] = "把卡牌拖入此槽中，可以分解成积分。"
_tab_string["__TEXT_Stuff_Tip"] = "分解装备，可以得到各种锻造材料。"

_tab_string["__TEXT_RECAST"] = "重铸"
_tab_string["__TEXT_RECAST_Cfm"] = "确认重铸"
_tab_string["__TEXT_RECAST_KEEP"] = "重铸锁孔"
_tab_string["__TEXT_RECAST_NET"] = "锁孔功能未激活"
_tab_string["__TEXT_YouCanForgedCount"] = "还可锻造"
_tab_string["__TEXT_YouCanForgedCount1"] = "次"
_tab_string["__TEXT_TURNTBLE_HUOJIANGJILU"] = "获 奖 记 录"
_tab_string["__TEXT_TURNTBLE_CONSUME1"] = "当前累计消耗"
_tab_string["__TEXT_TURNTBLE_CONSUME2"] = "游戏币，再消耗"
_tab_string["__TEXT_TURNTBLE_CONSUME3"] = "游戏币可获得转盘次数！"
_tab_string["__TEXT_SEVENDAYPAY_CONSUME1"] = "今日已充值"
_tab_string["__TEXT_SEVENDAYPAY_CONSUME2"] = "元，再充值"
_tab_string["__TEXT_SEVENDAYPAY_CONSUME3"] = "元可获得奖励！"
_tab_string["__TEXT_SEVENDAYPAY_CONSUME4"] = "元，已达成今日活动充值金额！"
_tab_string["__TEXT_CHOUJIANG_CONSUME1"] = "再抽"
_tab_string["__TEXT_CHOUJIANG_CONSUME2"] = "次必抽到限量礼包！"
_tab_string["__TEXT_CHOUJIANG_CONSUME3"] = "下次必抽到限量礼包！"
_tab_string["__TEXT_YouCanKeep"] = "在本关内还可持有"
_tab_string["__TEXT_Dat"] = "天"
_tab_string["__TEXT_Hour"] = "小时"
_tab_string["__TEXT_Hour_Short"] = "时"
_tab_string["__TEXT_please_enter_replay_ID"] = "请输入录像ID:"
_tab_string["__TEXT_MyMaster"] = "主公"
_tab_string["__TEXT_LastPlayMaster"] = "您最后进行游戏的君主角色为:"
_tab_string["__TEXT_RestoreSaveDataing"] = "正在恢复存档中..."
_tab_string["__TEXT_GameTime"] = "游戏时间"
_tab_string["__TEXT_GameRound"] = "通关情况"
_tab_string["__TEXT_UpdateTime"] = "最后游戏时间:"
_tab_string["__TEXT_Pruchase"] = "充值"
_tab_string["__TEXT_ActivityCriticalReward"] = "活动期间第一笔充值可获得暴击奖励"
_tab_string["__TEXT_DownloadResourcePackage"] = "需要更新资源才能进入\n即将下载所需要的资源包！"
_tab_string["__TEXT_YouHaveBuyGift"] = "您已购买此礼包"

_tab_string["__TEXT_ModifyNameSuccess"] = "您的主公已更名为："
_tab_string["__TEXT_ScoreRangeOut"] = "积分超上限"
_tab_string["__TEXT_ScoreNotEnough"] = "积分不足"
_tab_string["__TEXT_GroupCoinNotEnough"] = "军团币不足"
_tab_string["__TEXT_Can'tBuyAgain"] = "此礼包只能购买1次"
_tab_string["__TEXT_Reminder"] = "友情提示"
_tab_string["__TEXT_ReminderSave"] = "如果进入战役，会覆盖之前的自动存档，您是否进入战役？"
_tab_string["__TEXT_DemoInfo1"] = "由于本版本为试玩版，故此关卡暂未开放..."
_tab_string["__TEXT_DemoInfo2"] = "【过关斩将】尚未开放 \n 敬请期待！"
_tab_string["__TEXT_DemoInfo3"] = "尚未开放，敬请期待！"
_tab_string["__TEXT_ITEMLISTISFULL_GAME"] = "只能在关卡中购买"
_tab_string["__TEXT_LOG_BUYITEMERRO"] = "发现网络数据通信异常，请截图联系官方客服..."

_tab_string["__TEXT_kjzfTip"] = " 如果iPad上使用支付宝充值发生 \n \n “数据格式错误”问题 \n \n 请先卸载掉 <支付宝HD> 这个应用 \n \n 并且安装支付宝旗下的 <快捷支付>"


_tab_string["__TEXT_NotEnoughHeroCard"] = "开启竞技场至少需要拥有6个英雄令"
_tab_string["__TEXT_NotEnoughHeroCard1"] = "进入【过关斩将】，需要拥有至少6张英雄令"
_tab_string["__TEXT_EnterTip"] = "在【训练场】中获得3场战斗的胜利才能解锁！"
_tab_string["__TEXT_ITEMLISTISFULL"] = "道具栏已满了...."
_tab_string["__TEXT_Can'tSendNetShop"] = "当前无可用网络，无法使用商店"
_tab_string["__TEXT_CantSendNetShop_PVP"] = "连接竞技场服务器失败，无法打开限时商店"
_tab_string["__TEXT_CantSendNetShop_Chest"] = "限时商店，在竞技场开启第一个战功锦囊后解锁"
_tab_string["__TEXT_Can'tReceiveGift"] = "当前无可用网络，无法使用奖励功能"
_tab_string["__TEXT_Can_tLimitTimeGift"] = "当前无可用网络，无法使用限时礼包功能"
_tab_string["__TEXT_Can_tMonthCardGift"] = "当前无可用网络，无法使用月卡功能"
_tab_string["__TEXT_Can_tOpenEndlessMap"] = "当前无可用网络，无法挑战无尽试炼"
_tab_string["__TEXT_Can'tEnterPVP"] = "没有连接网络，无法进入\n‘竞技场’！"
_tab_string["__TEXT_BAGLISTISFULL"] = "背包已满，无法领取道具"
_tab_string["__TEXT_BAGLISTISFULL1"] = "背包已满，无法购买道具"
_tab_string["__TEXT_BAGLISTISFULL2"] = "背包已满，无法使用宝箱"
_tab_string["__TEXT_BAGLISTISFULL3"] = "背包已满，无法使用兑换券"
_tab_string["__TEXT_BAGLISTISFULL4"] = "背包已满，无法开始游戏"
_tab_string["__TEXT_BAGLISTISFULL5"] = "背包已满，无法开启神器锦囊"
_tab_string["__TEXT_BAGLISTISFULL6"] = "背包已满，无法创建房间"
_tab_string["__TEXT_BAGLISTISFULL7"] = "背包已满，无法进入房间"
_tab_string["__TEXT_BAGLISTISFULL8"] = "背包已满，无法抽奖"
_tab_string["__TEXT_BAGLISTISFULL9"] = "背包已满，无法打开藏宝图"
_tab_string["__TEXT_BAGLISTISFULL10"] = "背包已满，无法打开高级藏宝图"
_tab_string["__TEXT_Cant_BagItemIsFull_Net"] = "背包已满，装备无法放到背包中"
_tab_string["__TEXT_Cant_BagItemIsFull_Net1"] = "背包已满，神器无法放到背包中。请清理背包后重新登录，获取剩余神器。"

_tab_string["__TEXT_NetWaiting"] = "正在检测可用存档..."

_tab_string["__TEXT_Can'tDorpItem"] = "此类道具不能丢弃..."
_tab_string["__TEXT_Can'tOpenItem"] = "工匠正在寻找打开此宝箱的方法，请大人明天再试吧..."
_tab_string["__TEXT_ISQuipment"] = "已装备"
_tab_string["__TEXT_SELECTDIFF"] = "难度选择"
_tab_string["__TEXT_ONLINE_USERNAME"] = "用户账号"
_tab_string["__TEXT_Net_ERRO_1"] = "网络响应超时... \n与竞技场服务器断开连接！"
_tab_string["__TEXT_Net_ERRO_2"] = "网络不稳定... \n与竞技场服务器断开连接！"
_tab_string["__TEXT_Net_ERRO_3"] = "游戏发生不同步！"
_tab_string["__TEXT_Net_ERRO_4"] = "您已被踢出游戏... \n与竞技场服务器断开连接！"

_tab_string["__TEXT_Topup_Success_Tip"] = "请前往【邮箱】界面，领取充值对应的奖励！"
_tab_string["__TEXT_Topup_Success_Tip1"] = "恭喜您获得充值回馈奖励 \n"
_tab_string["__TEXT_CMSTG_PLAY"] = "恭喜获得策马守天关体验奖励\n"
_tab_string["__TEXT_CMSTG_PLAY1"] = "策马守天关体验奖励"
_tab_string["__TEXT_YouHaven'tHeroCard"] = "您并没有此英雄的英雄令\n该英雄不能使用商店"
_tab_string["__TEXT_YouHaven'tHeroCard_bag"] = "您并没有此英雄的英雄令\n该英雄不能使用道具仓库"
_tab_string["__TEXT_Can'tForgedItem"] = "只有 1 孔及以上的装备才能被锻造"
_tab_string["__TEXT_Can'tForgedItemAgain"] = "已锻造至顶级"
_tab_string["__TEXT_Can'tForgedItemCheat"] = "检测到数据不一致，无法使用锻造，请联系游戏客服"
_tab_string["__TEXT_Can'tSendNetForged"] = "锻造功能必须\n联网才能使用"
_tab_string["__TEXT_Cant'UseDepletion"] = "检测到数据不一致，无法使用宝箱"
_tab_string["__TEXT_Cant_SellItem_Net"] = "必须联网才能出售道具"
_tab_string["__TEXT_Repeat_Buy_DLCMap_Net"] = "您已购买过此地图包"
_tab_string["__TEXT_Cant_BuyDLCMap_Net"] = "必须联网才能购买地图包"
_tab_string["__TEXT_Cant_MergeItem_Net"] = "必须联网才能合成道具"
_tab_string["__TEXT_Cant_VIPFrm_Net"] = "必须联网才能使用会员功能"
_tab_string["__TEXT_Cant_Share_Net"] = "必须联网才能使用分享功能"
_tab_string["__TEXT_Cant_MergeItem2_Net"] = "只有装备才能进行合成"
_tab_string["__TEXT_Cant_MergeItem3_Net"] = "红装、橙装不能进行合成"
_tab_string["__TEXT_Cant_MergeItem4_Net"] = "合成材料不能用于主合成道具"
_tab_string["__TEXT_Cant_MergeItem5_Net"] = "辅合成道具数量不足"
_tab_string["__TEXT_Cant_XiLianItem_Net"] = "必须联网才能洗炼道具"
_tab_string["__TEXT_Cant_XiLianItem2_Net"] = "只有装备才能进行洗炼"
_tab_string["__TEXT_Cant_XiLianItem3_Net"] = "白装不能洗炼"
_tab_string["__TEXT_Cant_XiLianItem4_Net"] = "合成材料不能用于洗炼"
_tab_string["__TEXT_Cant_MergeItem1_Red_Equip_Net"] = "只有神器才能在神器祭坛里合成"
_tab_string["__TEXT_Cant_MergeItem2_Red_Equip_Net"] = "存在不能放入祭坛的神器"
_tab_string["__TEXT_Cant_MergeItem3_Red_Equip_Net"] = "神器1来源未知"
_tab_string["__TEXT_Cant_MergeItem4_Red_Equip_Net"] = "神器2来源未知"
_tab_string["__TEXT_Cant_MergeItem5_Red_Equip_Net"] = "祭坛放入的神器数量不足"
_tab_string["__TEXT_Cant_MergeItem1_Orange_Equip_Net"] = "只有橙装才能在此处合成"
_tab_string["__TEXT_Cant_MergeItem2_Orange_Equip_Net"] = "存在不能合成的橙装"
_tab_string["__TEXT_Cant_MergeItem5_Orange_Equip_Net"] = "合成的橙装数量不足"
_tab_string["__TEXT_TodayLockXiLian"] = "该装备今日还可以锁孔洗炼"
_tab_string["__TEXT_TodayLockXiLianUsedUp"] = "该装备今日锁孔洗炼次数已用完，不能继续锁孔！"
_tab_string["__TEXT_TodayBuyItemUsedUp"] = "该商品今日购买次数已用完！"
_tab_string["__TEXT_TodayRefreshCountUsedUp"] = "今日刷新次数已用完！"
_tab_string["__TEXT_Cant_NoMainMergeItem_Net"] = "没有主合成道具"
_tab_string["__TEXT_Cant_NoMaterialMergeItem_Net"] = "没有辅合成道具"
_tab_string["__TEXT_Cant_NoMainMergeItem_Orange_Equip_Net"] = "放入的橙装数量不足"
_tab_string["__TEXT_Cant_NoMainMergeItem_Red_Equip_Net"] = "祭坛放入的神器数量不足"
_tab_string["__TEXT_Cant_NoMaterialMergeItem_Red_Equip_Net"] = "祭坛放入的神器数量不足"
_tab_string["__TEXT_Cant_XiLianRequireAtLeastOneSlot_Net"] = "洗炼需要至少一条属性"
_tab_string["__TEXT_Cant'UseDepletion_Net"] = "必须联网才能使用宝箱"
_tab_string["__TEXT_Cant'UseDepletion2_Net"] = "必须联网才能使用兑换券"
_tab_string["__TEXT_Cant'UseDepletion3_Net"] = "兑换券数量不足"
_tab_string["__TEXT_Cant'UseDepletion4_Net"] = "升级卡片需要联网"
_tab_string["__TEXT_Cant_UseDepletion5_Net"] = "升级技能需要联网"
_tab_string["__TEXT_Cant'UseDepletion6_Net"] = "升星需要联网"
_tab_string["__TEXT_Cant_UseDepletion7_Net"] = "领取奖励需要联网"
_tab_string["__TEXT_Cant'UseWishing"] = "检测到数据不一致\n无法使用红装祭坛"
_tab_string["__TEXT_Can'tEnterEliteMode"] = "开启精英模式，需要VIP1及以上等级玩家"
_tab_string["__TEXT_Cant_UseDepletion8_Net"] = "查看排行榜需要联网"
_tab_string["__TEXT_Cant_UseDepletion9_Net"] = "查看活动需要联网"
_tab_string["__TEXT_Cant_UseDepletion10_Net"] = "查看任务需要联网"
_tab_string["__TEXT_Cant_UseDepletion11_Net"] = "修改名字需要联网"
_tab_string["__TEXT_Cant_UseDepletion12_Net"] = "购买商品需要联网"
_tab_string["__TEXT_Cant_UseDepletion13_Net"] = "领取神器需要联网"
_tab_string["__TEXT_Cant_UseDepletion14_Net"] = "必须联网才能开启神器锦囊"
_tab_string["__TEXT_Cant_UseDepletion15_Net"] = "主公起名需要联网"
_tab_string["__TEXT_Cant_UseDepletion16_Net"] = "挑战无尽试炼需要联网"
_tab_string["__TEXT_Cant_UseDepletion17_Net"] = "挑战精英模式需要联网"
_tab_string["__TEXT_Cant_UseDepletion18_Net"] = "升星宝物需要联网"
_tab_string["__TEXT_Cant_UseDepletion19_Net"] = "查看宝物需要联网"
_tab_string["__TEXT_Cant_TurnTable"] = "次数不足，无法抽奖！"
_tab_string["__TEXT_Cant_Redraw_ThisGame"] = "本局重抽次数已用完！"
_tab_string["__TEXT_Cant_Select_Difficulty"] = "通关当前难度后解锁下个难度"
_tab_string["__TEXT_Cant_ShowMessageType"] = "【收到不支持的消息类型，暂无法显示】"
_tab_string["__TEXT_morethanlimit"] = "充值受限"
_tab_string["__TEXT__Register"] = "注册"
_tab_string["__TEXT__BattleWin"] = "战胜了"
_tab_string["__TEXT__OneVsOne"] = "单挑"
_tab_string["__TEXT__In"] = "在"
_tab_string["__TEXT__De"] = "的"
_tab_string["__TEXT__Slot"] = "孔"
_tab_string["__TEXT__AddSlot"] = "打孔"
_tab_string["__TEXT__UpgrateTo"] = "升到了"
_tab_string["__TEXT__OpenTagNotice1"] = "已开启，快和好友一决高下吧"
_tab_string["__TEXT__OpenTagNotice2"] = "已开启，快和好友组队挑战吧"
_tab_string["__TEXT__UnlockedTowerAddones"] = "解锁了强化属性"




_tab_string["__TEXT_Getting__"] = "正在获取"
--_tab_string["__TEXT_ConnetingNet"] = "正在连接中"
_tab_string["__TEXT_TypeLetter"] = "输入文字"
_tab_string["__TEXT_PrivateInvite1"] = "您已向对方发起私聊请求！正在等待回应！"
_tab_string["__TEXT_PrivateInvite2"] = "【%s】向您发起私聊请求，是否接受？"
_tab_string["__TEXT_PrivateInviteAccept1"] = "【%s】接受了您的私聊请求，现在可以开始聊天了。"
_tab_string["__TEXT_PrivateInviteAccept2"] = "您接受了对方的的私聊请求，现在可以开始聊天了。"
_tab_string["__TEXT_PrivateInviteRefuse1"] = "【%s】拒绝了您的私聊请求！"
_tab_string["__TEXT_PrivateInviteRefuse2"] = "您拒绝了对方的的私聊请求！"
_tab_string["__TEXT_PrivateDelete1"] = "【%s】已关闭和您的私聊，无法再发送消息！"
_tab_string["__TEXT_PrivateDelete2"] = "您已关闭和对方的私聊，无法再发送消息！"
_tab_string["__TEXT_PrivateChatting"] = "与%s聊天中..."
_tab_string["__TEXT_PrivateClose"] = "是否关闭和【%s】的私聊？"
_tab_string["__TEXT_PrivateCloseNotice"] = "关闭后无法给对方发送消息。世界聊天可以重新发起私聊。"
_tab_string["MARKET_no_bargain"] = "！"

--_tab_string["__TEXT_ThankForPlayer"] = "恭喜您成功挑战了当前版本的所有关卡!后续关卡即将开放!欢迎访问《策马守天关》的官方论坛提供宝贵的建议!"
_tab_string["__TEXT_ThankForPlayer"] = "恭喜你完成了策马守天关第一篇:《乱世》的全部剧情战役!战功赫赫的你想必已经网罗了所有登场的英雄将领,请继续挑战英雄试炼关卡,印证英雄无敌的传说!"
_tab_string["__TEXT_DeleteSaveVersion"] = "关卡已更新,进行到一半的关卡需重新开始,已解锁的关卡和英雄令不受影响!"
_tab_string["__TEXT_Can'tOpenOtherPlayerList"] = "无法读取其他玩家的存档!"
_tab_string["__TEXT_Can'tUseOtherPlayerData"] = "无法使用其他玩家的存档!"
_tab_string["__TEXT_PleaseCreatePlayer"] = "请先创建一个名字!"
_tab_string["__TEXT_NoPlayerDisabelEnter"] = "当前没有存档，无法进入战役！"
_tab_string["__TEXT_ResetGameTip"] = "如果您重新开始本关卡,会丢失目前的进度!"
_tab_string["__TEXT_LeavePvp"] = "是否离开PVP大厅?"
_tab_string["__TEXT_lostTip_world/level_tyjy"] = "1.卖掉石头换取更多金钱来雇佣弓箭手。\n \n2.优先消灭敌人远程火力，保存己方弓箭手。"
_tab_string["__TEXT_lostTip_world/level_xsnd"] = "1.注意兵种的远近搭配，保护好远程兵种。\n \n2.敌人的数量会随着游戏天数增加而增加。"
_tab_string["__TEXT_Tips"] = "通关提示"
_tab_string["__TEXT_lostTip_world/level_yxcs"] = "1.城内战斗时，要尽快打掉敌人的投石车。\n \n2.敌人的数量会随着游戏天数增加而增加。"
_tab_string["__TEXT_lostTip_world/level_swbh"] = "1.尽快通过桥梁，解救援军后，速度折返。\n \n2.城内战斗时自己部队受到的伤害会降低。"

_tab_string["__TEXT_lostTip_world/level_hjzl"] = "1.推荐购买兵种：妖术师，神射手。\n \n2.有一定实力之后要尽快攻下曲阳。"

_tab_string["__TEXT_lostTip_world/level_ccjq"] = "1.保证弓箭手在战斗中不被近身。\n \n2.把吕布引到城内打，优先打掉投石车。"

_tab_string["__TEXT_lostTip_world/level_zhhm"] = "1.关羽出现后尽快携带兵种与主将会合。\n \n2.攻打城池时要保护好自己的投石车。"

_tab_string["__TEXT_lostTip_world/level_qxfdz"] = "1.英雄尽快去野外抢资源，攻占城池。\n \n2.左上角有个传送阵可以到达东郡。"
_tab_string["__TEXT_lostTip_world/level_wczzx"] = "1.保护曹操撤退时，不可让敌军靠近。\n \n2.尽量在刘表出现前消灭张绣。"
_tab_string["__TEXT_lostTip_world/level_bhzw"] = "1.安排好武将搜索地图、占领资源点。\n \n2.中后期合理安排好英雄的位置，方便运兵。"
_tab_string["__TEXT_lostTip_world/level_xpzz"] = "1.刘备尽快带兵，走右边传送阵与曹操会合。\n \n2.野外打不过吕布时，可以引入城内打。"
_tab_string["__TEXT_lostTip_world/level_hmzl"] = "1.能守住城的情况下，初期尽量多抢资源。\n \n2.中期打不过敌将乐就时，可以用武将引他在野外兜圈子。"


_tab_string["__TEXT_SorryForErro"] = "游戏出错了，十分抱歉，推荐您退出进程重新开启游戏... "
_tab_string["__TEXT_BackInfo"] = "返回上一级菜单可以查看是否有更新"
_tab_string["__TEXT_Can_Choose"] = "请从以下奖励中选择一个"
_tab_string["__TEXT_All_get"] = "您获得了"
_tab_string["__TEXT_SelectedHeroTitle"] = "请选择出场英雄..."
_tab_string["__TEXT_SelectedReverseCard"] = "请选择卡片..."
_tab_string["__TEXT_NetBFTimeoutError"] = "战场网络消息错误，请选择等待或直接退出... \n(退出后本场对决将被判定为无效局)"
_tab_string["__TEXT_ReplayOutOfTime"] = "请求录像无响应，是否继续等待服务器发送数据？"
_tab_string["__TEXT_Wait"] = "等待"
_tab_string["deflevel"] = "城防科技"
_tab_string["atklevel"] = "箭塔科技"
_tab_string["__TEXT_SelectedLegion"] = "可选势力"
_tab_string["__TEXT_ITEM_TYPE_NONE"] = "没有类型"
_tab_string["__TEXT_ITEM_TYPE_HEAD"] = "头部"
_tab_string["__TEXT_ITEM_TYPE_BODY"] = "防具"
_tab_string["__TEXT_ITEM_TYPE_WEAPON"] = "武器"
_tab_string["__TEXT_ITEM_TYPE_ORNAMENTS"] = "宝物"
_tab_string["__TEXT_ITEM_TYPE_MOUNT"] = "坐骑"
_tab_string["__TEXT_ITEM_TYPE_FOOT"] = "鞋子"
_tab_string["__TEXT_ITEM_TYPE_PLAYERITEM"] = "强化材料"
_tab_string["__TEXT_ITEM_TYPE_HEROCARD"] = "英雄令"
_tab_string["__TEXT_ITEM_TYPE_DEPLETION"] = "消耗品"
_tab_string["__TEXT_ITEM_TYPE_RESOURCES"] = "资源"
_tab_string["__TEXT_ITEM_TYPE_REWARD"] = "奖励"
_tab_string["__TEXT_ITEM_TYPE_GIFTITEM"] = "礼包"
_tab_string["__TEXT_ITEM_TYPE_GIFTITEM_BIG"] = "大礼包"
_tab_string["__TEXT_ITEM_TYPE_SOULSTONE"] = "将魂"
_tab_string["__TEXT_ITEM_TYPE_TACTICDEBRIS"] = "碎片"
_tab_string["__TEXT_ITEM_TYPE_CHEST"] = "宝箱"

_tab_string["__TEXT_upgrade_herocard"] = "英雄令升级"
_tab_string["__TEXT_upgrade_herocard1"] = "升级卡片"
_tab_string["__TEXT_buy_herocard"] = "购买英雄令"
_tab_string["__TEXT_buy_herocard_price"] = "英雄令价格"
_tab_string["__TEXT_can't_buy_herocard_tip"] = "您已拥有此英雄，不必再次购买!"

_tab_string["__TEXT_inform_herocard1"] = "通关【"
_tab_string["__TEXT_inform_herocard2"] = "】后，才能购买英雄令"
_tab_string["__TEXT_inform_archiLock"] = "通关【桃园结义】后，才能解锁"
_tab_string["__TEXT_inform_archiLock1"] = "通关【黄巾起义】后，才能解锁"
_tab_string["__TEXT_currentdiff"] = "当前难度"
_tab_string["__TEXT_startunits"] = "敌军初始兵力 "
_tab_string["__TEXT_rosespeed"] = "涨兵速度 "
_tab_string["__TEXT_inform_rose"] = "（敌军的兵力会随着天数自动增加）"
_tab_string["__TEXT_receive_certain"] = "确定领取"
_tab_string["__TEXT_equip_title"] = "请选择以下任意一件3孔红装"
_tab_string["__TEXT_ContinueMap"] = "继续战役"
_tab_string["__TEXT_HeroSkill"] = "技能"

_tab_string["__TEXT_WEEKSTARHERO"] = "本周推荐英雄令"
_tab_string["__TEXT_WEEKSTARHEROINFO1"] = "本周使用推荐英雄令可获得"
_tab_string["__TEXT_WEEKSTARHEROINFO2"] = "倍的积分加成"
_tab_string["__TEXT_WEEKSTARHEROINFO3"] = "此英雄令为本周推荐英雄令\n使用即可获得"

_tab_string["__TEXT_AttrExpirationTip"] = "增加的属性，只在当前关卡内有效"

_tab_string["__TEXT_Account_Balance"] = "游戏币  "
_tab_string["__TEXT_Account_Balance_Now"] = "当前游戏币"
_tab_string["__TEXT_Account_Balance_Need"] = "消耗游戏币"
_tab_string["__TEXT_PlayScore"] = "积分 "
_tab_string["__TEXT_PlayOverplusScore"] = "剩余积分:"
_tab_string["__TEXT_NetShopTitle"] = "游戏商城"
_tab_string["__TEXT_Need"] = "需"
_tab_string["__TEXT_Current"] = "当前"
_tab_string["__TEXT_GetRMB"] = "购买游戏币"
_tab_string["__TEXT_GradeTechMAX"] = "已升至最高级"
_tab_string["__TEXT_NeedBuyHeroCard"] = "需要拥有英雄令才能在本地图中使用此英雄!"
_tab_string["__TEXT_NeedBuyHeroCardWithDiscount25"] = "当前处于关卡剧情过程中, 此时购买英雄令将获得 10％ 折扣！"
_tab_string["__TEXT_ReadyToRakeReward"] = "是否领取 %s ？"
_tab_string["__TEXT_ItemMergeRate_NormalEquip"] = "有%d％的几率合成%d-%d级%s品质[%s]"
_tab_string["__TEXT_ItemMergeRate_OrangeEquip"] = "有%d％的几率合成新的橙装"
_tab_string["__TEXT_ItemMergeRate_RedEquip"] = "有%d％的几率献祭新的神器"
_tab_string["__TEXT_Page_Guide"] = "新手礼包"
_tab_string["__TEXT_Page_Item_1"] = "1元礼包"
_tab_string["__TEXT_Page_Item_5"] = "5元礼包"
_tab_string["__TEXT_Page_Basic"] = "基础"
_tab_string["__TEXT_Page_Equip"] = "装备"
_tab_string["__TEXT_Page_HeroCard"] = "英雄令"
_tab_string["__TEXT_Page_Rune"] = "限时商品"
_tab_string["__TEXT_Page_Elite"] = "精英"
_tab_string["__TEXT_Page_OperationTime"] = "操作时间"
_tab_string["__TEXT_Page_ChangeNum"] = "变化数量"
_tab_string["__TEXT_Page_GameCoinLeft"] = "游戏币剩余"
_tab_string["__TEXT_Page_OperationReason"] = "操作原因"
_tab_string["__TEXT_Page_GameCoinRecord"] = "游戏币记录"
_tab_string["__TEXT_Page_ExchangeCount"] = "可兑换次数："
_tab_string["__TEXT_Page_RefreshItem"] = "刷新商品"
_tab_string["__TEXT_Page_AcreenSpeedUp"] = "点击屏幕加速"

_tab_string["__TEXT_Attr_Lea_Info"] = "提升英雄与部队的伤害(每点最多提高1％伤害)"
_tab_string["__TEXT_Attr_Led_Info"] = "提升英雄与部队的防御力(相当于提高等量的护甲，每点护甲降低1％伤害)"
_tab_string["__TEXT_Attr_Str_Info"] = "提升武将的攻击力(1武力=2攻击力)"
_tab_string["__TEXT_Attr_Int_Info"] = "提升武将的法力值上限(1智力=1法力值上限)"
_tab_string["__TEXT_Attr_Con_Info"] = "提升武将的生命值和护甲(1体质=20生命值，0.1护甲)"

_tab_string["__TEXT_Attr_HP_Info"] = "英雄能承受的伤害总量。"
_tab_string["__TEXT_Attr_MP_Info"] = "英雄使用技能所消耗的数值。"
_tab_string["__TEXT_Attr_Atk_Info"] = "可以提高普通攻击和大部分技能造成的伤害。"
_tab_string["__TEXT_Attr_Def_Info"] = "降低英雄受到的物理攻击伤害。"
_tab_string["__TEXT_Attr_MovePoint_Info"] = "英雄每天在世界地图上移动的距离。"
_tab_string["__TEXT_Attr_toughness_Info"] = "当单位眩晕时，有一定几率（韧性*20％）获得1回合控制免疫的效果，持续回合数在被眩晕或冰冻结束后才开始计算。"
_tab_string["__TEXT_Attr_activity_Info"] = "决定英雄在战场上的出手顺序。"
_tab_string["__TEXT_Attr_hpRecover_Info"] = "每天回复一定百分比的生命值。"
_tab_string["__TEXT_Attr_MoveRange_Info"] = "决定英雄在战场上的移动格数。"
_tab_string["__TEXT_Attr_mpRecover_Info"] = "每天回复一定法力值。"


_tab_string["__TEXT_MONTHCARD"] = "月卡"
_tab_string["__TEXT_MONTHCARD_title"] = "月卡福利"
_tab_string["__TEXT_MONTHCARD_info1"] = "1、购买月卡后立即获得300游戏币。"
_tab_string["__TEXT_MONTHCARD_info2"] = "2、30天内每日可免费领取30游戏币。"
_tab_string["__TEXT_MONTHCARD_info3"] = "3、30天内每日可免费领取6个英雄将魂。"
_tab_string["__TEXT_MONTHCARD_info4"] = "4、30天内每日可免费强化任意防御塔6次，不消耗碎片和积分。"
_tab_string["__TEXT_MONTHCARD_leftday"] = "剩余月卡时间:"
_tab_string["__TEXT_NOBUY"] = "未购买"
_tab_string["__TEXT_YUANJIA_MONEY"] = "原价: ￥%d元"
_tab_string["__TEXT_GIFT_EXCHANGE"] = "礼包兑换"
_tab_string["__TEXT_CONTACT_KEFU"] = "联系客服"
_tab_string["__TEXT_MODIFY_ROLEICON"] = "修改头像"
_tab_string["__TEXT_SELECT_ROLEICON"] = "请选择头像"
_tab_string["__TEXT_LOCK_ROLEICON"] = "已解锁头像"
_tab_string["__TEXT_UNLOCK_ROLEICON"] = "未解锁头像"
_tab_string["__TEXT_CLICK_SCREEN_FINISH"] = "点击屏幕完成"
_tab_string["__TEXT_CLICK_SCREEN_CLOSE"] = "点击屏幕关闭"
_tab_string["__TEXT_CLICK_SCREEN_CONTINUE"] = "点击屏幕继续"
_tab_string["__TEXT_CONTACT_KEFU_METHOD"] = "客服电话：021-58463281\n客服邮箱：gm@xingames.com"


_tab_string["BeginMate"] = "开始匹配"
--_tab_string["PVPHeroInfo"] = "请选择2个英雄4个兵种"
--_tab_string["PVPArmyInfo"] = "请选择兵种"

_tab_string["__TEXT_RANK_1"] = "无尽试炼每日排行"
_tab_string["__TEXT_RANK_2"] = "无尽杀阵每日排行"

--_tab_string["PVPSuperman"] = "神将榜"
_tab_string["PVPHot"] = "热门"
--_tab_string["PVPHotHero"] = "热门英雄榜"
--_tab_string["PVPSword"] = "战斗力排名"
--_tab_string["PVPExport"] = "最高输出"
--_tab_string["PVPTreat"] = "最高治疗"
_tab_string["PVPMyRanking"] = "我的排名:"
_tab_string["PVPMyGrade"] = "我的战力:"
_tab_string["PVPExperience"] = "经验等级"
_tab_string["PVPFightGrade"] = "战斗等级"
_tab_string["PVP_CUR_Title"] = "当前称号"
_tab_string["PVP_Point"] = "天梯分"
_tab_string["PVP_Point_Mine"] = "我的天梯分"
_tab_string["PVPFightMarkMax"] = "最高战绩"
_tab_string["PVPFightMark"] = "今日战绩"
_tab_string["PVPFightNewScore"] = "新战绩"
_tab_string["PVPFightNewChapter"] = "解锁新章节"
_tab_string["PVPFightMarkThisTime"] = "本次战绩"
_tab_string["PVPFightLinit"] = "今日限制"
_tab_string["PVPNOLinit"] = "不限"
_tab_string["PVPDaoJiShi"] = "重刷时间"
_tab_string["PVPDaoJiShiExpired"] = "（已过重刷时间，本次得分仅本地有效）"
_tab_string["PVPChongShuaDaoJiShi"] = "重刷倒计时"
--_tab_string["PVPDataSta"] = "数据概况"
--_tab_string["PVPEnterNum"] = "出场次数"
_tab_string["PVPWin"] = "胜利"
_tab_string["PVPFlee"] = "逃"
_tab_string["PVPVictory"] = "胜率"
_tab_string["PVPArenaRoom"] = "竞技房"
_tab_string["PVPSesonRewardI"] = "竞技场赛季月中奖励"
_tab_string["PVPSesonRewardII"] = "竞技场赛季月末奖励"
_tab_string["PVPSesonRewardIntroI1"] = "夺塔奇兵竞技房进行有效局的战斗将获得天梯分数。每个月的月中和月末按照累计天梯分数的排名发放奖励。"
_tab_string["PVPSesonRewardIntroI2"] = "月中奖励为16号结算发放。"
_tab_string["PVPSesonRewardIntroII2"] = "月末奖励为次月1号结算发放，并重新开始排行。"
_tab_string["PVPEndlessWeekRewardI"] = "《魔龙宝库》排行榜"
_tab_string["PVPEndlessWeekIntroI1"] = "1、魔龙宝库为军团双人组队副本。玩家可以与他人一起挑战，搭配英雄、塔，与队友配合阻挡敌人一波波的进攻。副本每天限时开放，通关后才会扣除领奖次数。"
_tab_string["PVPEndlessWeekIntroI2"] = "2、排行榜上展示了本周最快通关的前20组队伍。点击玩家的英雄头像、装备、塔，可查看详细属性。"
_tab_string["PVPEndlessWeekRewardII"] = "《铜雀台》排行榜"
_tab_string["PVPEndlessWeekIntroII1"] = "1、铜雀台为单人闯关副本。铜雀台共有9层，战胜每层的主将才能进入下一层。玩家可选择5位英雄进入铜雀台，并派遣第1位置的英雄出战。英雄阵亡后，将自动出战下一位。副本分为普通难度、困难难度、噩梦难度。难度越高，敌人属性越强，同时奖励越丰厚。副本全天开放，通关副本可领取奖励。"
_tab_string["PVPEndlessWeekIntroII2"] = "2、挑战铜雀台需要10兵符入场券，成功通关后才会扣除兵符，失败不会扣除兵符。"
_tab_string["PVPEndlessWeekIntroII3"] = "2、排行榜上展示了本周最快通关的前50组队伍。点击玩家的英雄头像、装备，可查看详细属性。"
_tab_string["PVPEndlessWeekIntroII11"] = "1、魔塔杀阵为单人防守副本。随着防守进程，玩家会拾取到5种碎片晶石，可对防御塔进行属性增强，提升防御塔的威力。地图上方可发兵帮助玩家坚守阵地。副本全天开放，通关副本可领取奖励。"
_tab_string["PVPEndlessWeekIntroII12"] = "2、挑战魔塔杀阵需要10兵符入场券，成功通关后才会扣除兵符，失败不会扣除兵符。"
_tab_string["PVPEndlessWeekIntroIX11"] = "1、凛凛人如在，谁云汉已亡！守卫剑阁地图复原了原作经典玩法，并加入了大量创新内容。游戏结合了普通塔防和防守图的特点，涵盖了神像祈福、圣兽降临、装备强化、野外探索等大量局内养成元素。丰富的随机元素，让你的每一局游戏都获得不同的体验，百玩不腻。"
_tab_string["PVPEndlessWeekIntroIX12"] = "2、每次挑战守卫剑阁消耗5兵符。"
_tab_string["PVPRenZuWuDiDailyReward"] = "《人族无敌》排行榜"
_tab_string["PVPRenZuWuDiDailyIntro1"] = "1、人族无敌为双人组队合作模式，可与队友配合阻挡敌人一波波的进攻，主要借鉴魔兽经典塔防《人族无敌》的玩法框架加上每波随机抽取技能卡的游戏模式。每波开始时，地图上的远古铁人神像会提供随机3个科技效果，玩家可以3选1。地图上的大小BOSS也会有几率掉落各类特种塔和英雄增强碎片，选择方向不同，每次的游戏体验也大为不同。"
_tab_string["PVPRenZuWuDiDailyIntro2"] = "2、排行榜上展示了今日通关人族无敌的队伍。点击玩家的英雄头像、装备、战术卡，可查看详细属性。"
_tab_string["PVPEndlessWeekIntroIII1"] = "1、矿洞争夺战为军团单人副本。玩家保护采矿的农民，并消灭来犯的敌人。副本分为普通难度、困难难度、噩梦难度。难度越高，敌人属性越强，同时通关后奖励越丰厚。副本全天开放，通关后才会扣除可挑战次数。"
_tab_string["PVPEndlessWeekIntroIII2"] = "1、守护伐木场为军团单人副本。玩家保护伐木的农民，并消灭来犯的敌人。副本分为普通难度、困难难度、噩梦难度。难度越高，敌人属性越强，同时通关后奖励越丰厚。副本全天开放，通关后才会扣除可挑战次数。"
_tab_string["PVPEndlessWeekIntroIII3"] = "1、运粮为军团单人副本。玩家保护运粮的木牛，并消灭来犯的敌人。副本分为普通难度、困难难度、噩梦难度。难度越高，敌人属性越强，同时通关后奖励越丰厚。副本全天开放，通关后才会扣除可挑战次数。"
_tab_string["PVPEndlessWeekIntroIII4"] = "1、秘境试炼为军团双人组队副本。玩家可以与他人一起挑战，搭配英雄、塔，与队友配合阻挡敌人一波波的进攻。副本每周五-周日开放，通关后才会扣除可挑战次数。"
_tab_string["PVPEndlessWeekIntroIA"] = "2、每日前2次挑战成功副本，可领取奖励。"
_tab_string["PVPEndlessWeekIntroIA2"] = "2、每日首次挑战成功副本，可领取奖励。"
_tab_string["PVPEndlessWeekIntroIB"] = "3、挑战失败不会扣除领奖次数。"
_tab_string["PVPEndlessWeekIntroIC"] = "4、每日0点重置领奖次数。"
_tab_string["PVPEndlessWeekIntroID"] = "5、军团会长、助理每日可提升士气，本军团全体成员都将额外获得1次可领取次数。"
_tab_string["PVPEndlessWeekIntroID2"] = "5、军团会长、助理每日可提升士气，本军团全体成员都将额外获得1次挑战次数并可领取奖励。"
_tab_string["PVPEndlessWeekIntroIF"] = "6、可消耗游戏币额外增加今日副本可领奖次数。"
_tab_string["PVPEndlessRZWD_HINT1"] = "人族无敌为双人组队合作模式，主要借鉴魔兽经典塔防《人族无敌》的玩法。每波开始时，地图上的远古铁人神像会提供随机3个科技效果，玩家可以3选1。地图上的大小BOSS也会有几率掉落各类特种塔和技能书。"
_tab_string["PVPEndlessRZWD_HINT2"] = "想尽快解锁【人族无敌】的玩家请注意，须先把主线战役进展到第二章节《群雄逐鹿》的【北海之围】地图。"
_tab_string["PVPEndlessWeekIntroIE1"] = "1、通关一次军团单人副本。"
_tab_string["PVPEndlessWeekIntroIE2"] = "2、通关一次军团组队副本。"
_tab_string["PVPQunYingGeDailyReward"] = "《群英阁》排行榜"
_tab_string["PVPQunYingGeDailyIntro1"] = "1、群英阁为自由造塔模式，玩家可在非道路的任意空地上建造防御塔，抵挡敌人进攻。每波开始时，地图上的铁人神像会提供随机3个科技效果，玩家可以3选1。地图上的大小BOSS也会有几率掉落各类新型特种塔和英雄增强碎片。根据获得的科技点随机应变，尝试各种新奇的通关组合是本图主要玩点。"
_tab_string["PVPQunYingGeDailyIntro2"] = "2、排行榜上展示了今日通关群英阁的前50组队伍。点击玩家的英雄头像、装备、塔，可查看详细属性。"

_tab_string["PVPSesonI"] = "月中"
_tab_string["PVPSesonII"] = "月末"
_tab_string["PVP_SUN"] = "总盘数"
_tab_string["PVPOfflineRate"] = "掉线"
_tab_string["PVPXunZhang"] = "勋章"
_tab_string["PVPXunZhangRequire"] = "达成条件"
_tab_string["PVPSelHeroCue"] = "您只能选择两个英雄"
_tab_string["PVPSelArmsCue"] = "您只能选择四个兵种"
_tab_string["PVPBuyArms"] = "购买兵种卡"
_tab_string["PVPSelAll"] = "选择完成后，英雄和兵种可以交换位置"
_tab_string["PVPStar"] = "战功积分"
_tab_string["PVPSLevel"] = "竞技场等级"
_tab_string["PVPArena"] = "擂台"
_tab_string["PVPSLevelIntroduce"] = "打开锦囊可以提升竞技场等级。"
_tab_string["PVPStarIntroduce"] = "与玩家对战时，达到有效对战时间3分钟，按评价给予一定数量的战功积分。（上限200积分）\n战功积分可用于兑换锦囊。"
_tab_string["PVPWinRateIntroduce"] = "与玩家对战时，达到有效对战时间3分钟，总场次加1。\n获得胜利，胜利场次加1。"
_tab_string["PVPEscapeIntroduce1"] = "与玩家对战时，未达到有效对战时间3分钟的情况下，点击逃跑按钮离开游戏，逃跑次数加1，并扣除1点战功积分。\n逃跑或掉线每累计达到4次，"
_tab_string["PVPEscapeIntroduce2"] = "分钟内无法对战，并且之后打开的第一个锦囊掉率减半。"
_tab_string["PVPOfflineIntroduce1"] = "与玩家对战时，网络断开连接或其它异常离开，掉线次数加1，并扣除2点战功积分。\n逃跑或掉线每累计达到4次，"
_tab_string["PVPOfflineIntroduce2"] = "分钟内无法对战，并且之后打开的第一个锦囊掉率减半。"
--_tab_string["PVPStatisticsCard"] = "统计显示娱乐房玩家使用卡牌最多的前3张。"
_tab_string["PVPArenaChestIntroduce"] = "擂台赛有效局的胜利方，将获得一个擂台锦囊。\n获得的擂台锦囊可以立刻打开。\n擂台锦囊最多堆叠10个。"
_tab_string["PVPArenaBattleIntroduce"] = "擂台赛有效局获得战功积分，胜利方还将额外获得1个擂台锦囊。\n创建擂台赛、加入他人擂台赛，消耗10游戏币。\n游戏未开始前离开房间，将退还消耗的游戏币。"
_tab_string["PVPFunBattleIntroduce"] = "仅供切磋练习，不扣除兵符，也不获得战功积分。"
_tab_string["PVPRankLevel1"] = "百夫长"
_tab_string["PVPRankLevel2"] = "军候"
_tab_string["PVPRankLevel3"] = "校尉"
_tab_string["PVPRankLevel4"] = "中郎将"
_tab_string["PVPRankLevel5"] = "荡寇"
_tab_string["PVPRankLevel6"] = "虎威"
_tab_string["PVPRankLevel7"] = "骠骑"
_tab_string["PVPRankLevel8"] = "大将军"
_tab_string["PVP_Event_Leave"] = "离开了游戏！"
_tab_string["PVP_Event_Surrand"] = "投降了！"
_tab_string["PVP_Event_Escape"] = "逃跑了！"
_tab_string["PVP_Event_Offline"] = "掉线了！"
_tab_string["PVP_CostTime"] = "通关时间"
_tab_string["PVP_MyCostTime"] = "我的通关时间"


_tab_string["__TEXT_PlayerName"] = "玩家名"
_tab_string["__TEXT_BuyFuStone"] = "兑换兵符"
_tab_string["__TEXT_NEED"] = "需要"
_tab_string["__TEXT_COUNT"] = "个"
_tab_string["__TEXT_CANBUILD"] = "才能建造"
_tab_string["__TEXT_HAVE"] = "拥有"
_tab_string["__TEXT_ACTIVE"] = "激活"
_tab_string["__TEXT_CONSUME"] = "消耗"
_tab_string["__TEXT_cheatPlayer"] = "你的游戏数据出现严重异常\n无法进入...\n点击【确认】离开游戏!\n"
_tab_string["__TEXT_PVP_archiLock"] = "通关【虎牢关】后，才能解锁夺塔奇兵！"
_tab_string["__TEXT_MOLONGBAOKU_archiLock"] = "通关【下邳之战】后，才能解锁军团！"
_tab_string["__TEXT_SHOP_archiLock"] = "通关【虎牢关】后，才能解锁商店分页！"
_tab_string["__TEXT_SHENQI_archiLock"] = "通关【桃园结义】后，才能解锁神器分页！"
_tab_string["__TEXT_SETTINT_archiLock"] = "通关【涿郡投军】后，才能解锁设置菜单！"
_tab_string["__TEXT_TQT_DIFF5_archiLock"] = "通关【绝处逢生】后，才能挑战精英地图！"
_tab_string["__TEXT_CHAT_archiLock"] = "通关【涿郡投军】后，才能解锁聊天！"
_tab_string["__TEXT_ROLEICON_archiLock"] = "通关【涿郡投军】后，才能解锁头像！"
_tab_string["__TEXT_ENTERTAINMENT_archiLock"] = "通关【广宗之战】后，才能解锁娱乐专区！"
_tab_string["__TEXT_ENDLESS_MOTA_archiLock"] = "通关【汜水之战】后，才能解锁魔塔杀阵！"
_tab_string["__TEXT_QUNYINGGE_archiLock"] = "通关【火烧洛阳】后，才能解锁群英阁！"
_tab_string["__TEXT_RENZUWUDI_archiLock"] = "通关【北海之围】后，才能解锁人族无敌！"
_tab_string["__TEXT_TONGQUETAI_archiLock"] = "通关【下邳之战】后，才能解锁铜雀台！"
_tab_string["__TEXT_ENDLESS_BATTLE_archiLock"] = "通关【穷途末路】后，才能解锁无尽试炼！"
_tab_string["__TEXT_TQT_DIFF3_archiLock"] = "通关【皇叔败走】后，才能挑战困难难度！"
_tab_string["__TEXT_TQT_DIFF4_archiLock"] = "通关【千里走单骑】后，才能挑战噩梦难度！"
_tab_string["__TEXT_SHOUWEIJIANGE_archiLock"] = "通关【仓亭之战】后，才能解锁守卫剑阁！"
_tab_string["__TEXT_RENZUWUDI_qunyingg_archiLock"] = "通关群英阁任意难度后，才能挑战人族无敌！"

-----------------------------------------------------------------------------------
--手机版，查看英雄属性的提示信息
_tab_string["__TEXT_Attr_MovePoint_Info1"] = "英雄在地图中移动的速度。"
_tab_string["__TEXT_Attr_toughness_Info1"] = "降低英雄受到的法术攻击伤害。"
_tab_string["__TEXT_Attr_activity_Info1"] = "英雄战斗时普通攻击的攻击间隔。"
_tab_string["__TEXT_Attr_hpRecover_Info1"] = "每天回复"
_tab_string["__TEXT_Attr_MoveRange_Info1"] = "英雄在战场上可移动"
_tab_string["__TEXT_Attr_mpRecover_Info1"] = "每天回复10％+"

_tab_string["__TEXT_Attr_MovePoint_Info2"] = "距离。"
_tab_string["__TEXT_Attr_toughness_Info2"] = "*20％）获得1回合控制免疫的效果，如果韧性大于5，则累计到下一个回合。持续回合数在被眩晕或冰冻结束后才开始计算。"
_tab_string["__TEXT_Attr_activity_Info2"] = ""
_tab_string["__TEXT_Attr_hpRecover_Info2"] = "％的生命值。"
_tab_string["__TEXT_Attr_MoveRange_Info2"] = "格。"
_tab_string["__TEXT_Attr_mpRecover_Info2"] = "点法力值。"
------------------------------------------------------------------------------------

_tab_string["__TEXT_Relive_Tip"] = "剩余英雄重振总次数:"
_tab_string["__TEXT_Relive_Tip_0"] = "重振英雄需要游戏币"

_tab_string["__TEXT_ACADEMYSKILLTIP"] = "阵法"
_tab_string["__Can'tEnterMap1"] = "需要拥有"
_tab_string["__Can'tEnterMap2"] = "个以上的英雄令\n才能进入此关卡"
_tab_string["__Can'tEnterMap3"] = "需要通关地图【"
_tab_string["__Can'tEnterMap4"] = "】\n才能进入此关卡"
_tab_string["__Can'tEnterMap5"] = "】\n才能解锁此篇章"
_tab_string["__Can'tEnterMap6"] = "】才能解锁"

_tab_string["__TEXT_Can_not_use_share"] = "只有在黄巾起义中击败张曼成才能使用好友推荐功能"
_tab_string["__TEXT_Can_use_share"] = "好友推荐可以获得游戏币奖励哦!"

_tab_string["__TEXT_Quest_Reward"] = "任务奖励"
_tab_string["__TEXT_Map_Quest"] = "关卡任务"

_tab_string["__TEXT_Nothing"] = "无"

_tab_string["__TEXT_UserdInCruMap"] = "只能在本关中使用 \n分解可得"

_tab_string["__TEXT_LevelStar"] = "关卡评价"
_tab_string["__TEXT_LevelRich"] = "富可敌国"
_tab_string["__TEXT_LevelBlitz"] = "闪电战"
_tab_string["__TEXT_LevelImperial"] = "皇冠"

_tab_string["__TEXT_LevelStarInfo1"] = "在关卡挑战过程中,需要获得 "
_tab_string["__TEXT_LevelStarInfo2"] = " 次 3 星的战斗评价。"
_tab_string["__TEXT_LevelImperialInfo"] = "4 颗辣椒或以上难度通关!"
_tab_string["__TEXT_LevelBlitzInfo"] = " 天之内完成关卡挑战!"
_tab_string["__TEXT_LevelRichInfo"] = "在关卡挑战过程中,拥有过 "

_tab_string["__HINT__HoldToShowSkillInfo"] = "按住图标不放，可以查看技能详细信息"
_tab_string["__HINT__DragToShowUnitList"] = "向左(←)拖拽头像，可以打开队伍列表"

_tab_string["__TEXT_Get1"] = "获得"
_tab_string["__TEXT__Account_Name"] = "账号名"
_tab_string["__TEXT__PASSWORD"] = "密码"
_tab_string["__TEXT__Account_UserName"] = "用户名"
_tab_string["__TEXT__Account_Strength"] = "战斗力"
_tab_string["__TEXT__Account_LastPosition"] = "名次"
_tab_string["__TEXT__Account_uID"] = "用户ID"
_tab_string["__TEXT__APPROACH"] = "达到"
_tab_string["__TEXT__DONATED"] = "已贡献"
_tab_string["__TEXT__UNLOCK_ROLEICON"] = "解锁此头像"
_tab_string["__TEXT__Account_military"] = "军衔"
_tab_string["__TEXT__PVP_RS_info1"] = "由于获得兵符数量少于20，此局为非有效奖励局！"
_tab_string["__TEXT_NewYear_Activity"] = "活动特价"
_tab_string["__TEXT_GET_ITEM__"] = "获得物品"
_tab_string["__TEXT_SELECT_ITEM__"] = "选择物品"
_tab_string["__TEXT_SELECT_ITEM_BY_NUM__"] = "请选择 #NUM# 件战利品"
_tab_string["__TEXT_strategy_up"] = "战况已升级！！！"
_tab_string["__TEXT_strategy_up_info"] = "恭喜你已经迈过新手阶段，成为策马守天关的熟手玩家，接下来的战斗会更加艰巨，对手也会更加强大！ 一路征战四方，你的英雄已经威名远扬，追随的民众向你献上一批精良的武器装备！"


_tab_string["__TEXT_PleaseSelectAReward"] = "请选择一件奖励"
_tab_string["__TEXT_PleaseSelectReward"] = "请选择奖励"
_tab_string["__TEXT_PleaseConfirmRewardWithDoubleClick"] = "请双击道具图标来确认奖励"
_tab_string["__TEXT_unlock"] = "是否购买?"
_tab_string["__TEXT_BuyMapPack"] = "购买地图包"
_tab_string["__TEXT_BuyMapPack1"] = "购买新的游戏章节"
_tab_string["__TEXT_not_enough_money"] = "游戏币数量不足"
_tab_string["__TEXT_BuyGameCoinTip"] = "您想购买更多的游戏币吗？"
_tab_string["__TEXT_Story"] = "故事："
_tab_string["__TEXT_BuyThisMapBag"] = "1、购买此地图包"
_tab_string["__TEXT_Finish"] = "2、通关"
_tab_string["__TEXT_MapBag"] = "地图包"
_tab_string["__TEXT_ContainContent"] = "包含内容"
_tab_string["__TEXT_GameList"] = "游戏"
_tab_string["__TEXT_GameContent"] = "游戏介绍"


_tab_string["__TEXT_GameDataIllegalTip1"] = "游戏数据检测到不一致! \n需修复（1）"
_tab_string["__TEXT_GameDataIllegalTip2"] = "游戏数据检测到不一致! \n需修复（2）"
_tab_string["__TEXT_GameDataIllegalTip3"] = "游戏数据检测到不一致! \n请重新开始游戏局"
_tab_string["__TEXT_GameDataIllegalTip4"] = "游戏数据检测到不一致! \n需修复（4）"
_tab_string["__TEXT_GameDataIllegalTip5"] = "游戏数据检测到不一致! \n需修复（5）"
_tab_string["__TEXT_ChangeGameCoin"] = "积分来换取游戏币，每天一次。"
_tab_string["__TEXT__HitThisTarget"] = "点击这个单位"
_tab_string["__TEXT__LeiJi"] = "累计"
_tab_string["__TEXT__AccountTip"] = "登陆"
_tab_string["__TEXT__GameCount"] = "局"


_tab_string["__TEXT_Prompt_GUID1"] = "请输入玩家ID的后4位数字来确认删除"
_tab_string["__TEXT_Clear"] = "清除"
_tab_string["__TEXT_Prompt_Clear"] = "玩家ID不正确，请重新输入"
_tab_string["__TEXT_Player_Delete"] = "删除玩家"

_tab_string["__TEXT_Amusement_map"] = "娱乐地图"
_tab_string["__TEXT_Question_Prompt"] = "娱乐地图指南"
_tab_string["__TEXT_Question_Prompt2"] = "提示："
_tab_string["__TEXT_Question_Prompt3"] = "剧情地图指南"
_tab_string["__TEXT_RedEquip_Prompt"] = "红装需求指数："

_tab_string["__TEXT_Describeinfo"] = "打开宝箱后首次得到"


_tab_string["__TEXT_Sprog_Prompt888"] = "本游戏以三国群雄争霸为背景，融合了策略战棋和卡牌收集玩法，并且每张地图都做了精心设计，有防守、保护、限时通关等多种创新玩法。"
_tab_string["__TEXT_Sprog_Prompt999"] = "             推荐大家玩3辣椒难度，在此难度下通关可以获得各种任务奖励。如果感觉困难，可以尝试降低难度。游戏过程中玩家还可以免费获得积分，积分可以在商店为英雄购买装备！"
_tab_string["__TEXT_Employ"] = "招募"
_tab_string["__TEXT_Revive"] = "立即复活"

_tab_string["__TEXT_MyHero"] = "我的英雄"
_tab_string["__TEXT_MyBattle"] = "我的战役"
_tab_string["__TEXT_MyManor"] = "我的领地"
_tab_string["__TEXT_MyAward"] = "我的奖励"

_tab_string["__TEXT_zhan"] = "战"
_tab_string["__TEXT_kuang"] = "况"
_tab_string["__TEXT_sheng"] = "升"
_tab_string["__TEXT_ji"] = "级"
_tab_string["__TEXT_star"] = "星"

_tab_string["__TEXT_zui"] = "最"
_tab_string["__TEXT_hou"] = "后"
_tab_string["__TEXT_open"] = "开启"
_tab_string["__TEXT_yi"] = "一"
_tab_string["__TEXT_GoodsBuy"] = "购买"
_tab_string["__TEXT_GoodsPrice"] = "商品价格"
_tab_string["__TEXT_confirmBuyTip"] = "您确定要购买"

_tab_string["GoodsKind1"] = "装备"
_tab_string["GoodsKind2"] = "英雄令"
_tab_string["GoodsKind3"] = "消耗品"
_tab_string["__TEXT_Re_Login"] = "重新登录"
_tab_string["__TEXT__AccountTip3"] = "您的账号已在其他设备登陆"
_tab_string["__TEXT_SetPassWord"] = "设置密码"
_tab_string["__TEXT_SetNewPassWord"] = "设置新密码"
_tab_string["__TEXT_SetPassWordInfo"] = "请输入6位数字设定为当前密码"
_tab_string["__TEXT_SetPassWordRs_1"] = "设置密码成功"
_tab_string["__TEXT_SetPassWordRs_2"] = "设置密码失败"
_tab_string["__TEXT_manger"] = "账号管理"
_tab_string["__TEXT_GoToRecharge"] = "去充值"
_tab_string["__TEXT_UseHostory"] = "使用记录"
_tab_string["guest"] = "游客"
_tab_string["guest_info"] = "说明:通关剧情战役的第一章节之后,账号将解除[游客]状态,之后进行游戏时如果保持联网,游戏数据会定时同步到服务器,防止丢失。"
_tab_string["guest_info1"] = "使用已有游戏账号来恢复游戏数据"
_tab_string["guest_check_in"] = "游戏账号登入"
_tab_string["Totoltopup"] = "累计充值"
_tab_string["HaveGetTodayReward"] = "已领取今日奖励！"

_tab_string["HeroTokenV"] = "英\n雄\n令"
_tab_string["SkillCardV"] = "战\n术\n卡"
_tab_string["ArmyV"] = "兵\n种"
_tab_string["App_Download_CMSTG_lab"] = "策马三国系列精品，策略战棋巅峰之作！\n这里才是你想要的真正的英雄无敌！"

_tab_string["App_Download_CMSTG"] = "去AppStore下载"
_tab_string["App_Comment_CMSTG"] = "前往苹果商店评论"
_tab_string["App_Comment_CMSTG_Android"] = "前往评论"
_tab_string["App_PINGJIA_Android"] = "您的支持是我们前进的动力! 请您去给游戏评个分吧！\n（通关“救援青州”，可评分）"
_tab_string["App_PINGJIA_Android_Prefix"] = "发表对游戏的真实看法，您的评价对我们很重要。"
_tab_string["App_PINGJIA_Android_Postfix1"] = "应用商店每增加100个评价，我们将给【全体】"
_tab_string["App_PINGJIA_Android_Postfix2"] = "玩家送出50个游戏币。\n（通关“救援青州”，可评分）"
_tab_string["commentInfo1"] = "你是三国迷么，我们的剧情战役够三国么？"
_tab_string["commentInfo2"] = "这款很讲究策略的塔防是不是你玩过的最特别的塔防游戏？"
_tab_string["commentInfo3"] = "是否喜欢这种三国名将在塔防战场上冲锋陷阵的感觉？最喜欢哪个三国英雄？还想要更多玩法多样的防御塔么？"
_tab_string["commentInfo4"] = "竞技场的公平对战有没有给你带来MOBA+皇室战争的刺激？"
_tab_string["commentInfo5"] = "欢迎对我们的游戏发表各种感受和意见！您的评论是对我们最真挚的鼓励！"
_tab_string["commentTitle1"] = "这些来自玩家的真实评论,是对我们最真挚的鼓励!"
_tab_string["commentTitle2"] = "欢迎对游戏发表评论"

-----------------------------------------------------------------------------------------------------------------------------



------------------------
--公用选项字符串
_tab_stringM["$__YesOrNo"] = {
	"是",
	"否",
}

_tab_stringM["$__PursueOrLeave"] = {
	"追击",
	"放走",
}

_tab_stringM["$__YesOrNo02"] = {
	"刀盾兵×120",
	"神射手×60",
	"重骑兵×50",
}

_tab_stringM["$__YesOrNo03"] = {
	"近战兵种(通用)",
	"近战兵种(特殊)",
	"远程兵种(通用)",
	"远程兵种(特殊)",
}

_tab_stringM["$__YesOrNoX"] = {
	"是",
	"否",
	"是(本局游戏不再提示)",
	"否(本局游戏不再提示)",
}





--公用字符串(从tab_string中移动过来)
_tab_stringM["town_type"] = {"平原城", "水寨", "山城" }
_tab_stringM["MARKET_res_show_name"] = {"金钱","粮食","石头","木材","铁","水晶"}
_tab_stringM["HOSTEL_WELCOME"] = {"您可以招募新的英雄, 也能找到曾经战败的将领们，并鼓舞他们重新振作起来！"}
_tab_stringM["HOSTEL_HERO_HIRE"] = {"斗志昂扬的出城了。","大喝一声，冲了出去!","默默拿起了盔甲..."}


_tab_stringM["$_zhucheng"] = {"主城"}
_tab_stringM["$_zhucheng_info"] = {"这是一座主城。"}


----精英地图通用对白
--攻击风伯
_tab_stringM["$_jydt_ex_01"] = {
	"@L1:11033@凡人？来找死吗？哼！",
}
--攻击祸斗
_tab_stringM["$_jydt_ex_02"] = {
	"@L1:11034@咯咯咯～活人？看起来味道不错！",
}
--攻击女娲后人
_tab_stringM["$_jydt_ex_03"] = {
	"@L1:11032@停下！再靠近我便要出手了！",
}

--攻击张角
_tab_stringM["$_jydt_ex_04"] = {
	"@L1:5027@哼！本座渡劫的关键时刻，岂容你们捣乱，看招！",
}

--攻击帝江
_tab_stringM["$_jydt_ex_05"] = {
	"@L1:11038@几个蝼蚁，也敢来挑战我？死吧！",
}

_tab_stringM["$_zhuojun"] = "涿郡"
_tab_stringM["$_zhuojun_info"] = "涿州是[三国文化]的发祥地。[桃园三结义]的故事广为流传。"
_tab_stringM["$_julu"] = "巨鹿"
_tab_stringM["$_julu_info"] = "巨鹿人张角以太平清领道为掩护，发动农民大起义，巨鹿成为黄巾起义的策源地。"
_tab_stringM["$_guangzong"] = "广宗"
_tab_stringM["$_guangzong_info"] = "黄巾起义时，张角所占据的城池"
_tab_stringM["$_quyang"] = "曲阳"
_tab_stringM["$_quyang_info"] = "黄巾起义时，张梁所占据的城池。"

_tab_stringM["$_jingzhou"] = {"荆州城"}
_tab_stringM["$_jingzhou_info"] = {"即南郡治所江陵所在，南临长江，北依汉水，西控巴蜀，南通湘粤，古称“七省通衢”。"}

_tab_stringM["$_xiangyang"] = {"襄阳"}
_tab_stringM["$_xiangyang_info"] = {"因地处襄水之阳而得名，汉水穿城而过，与樊城隔江相望。"}

_tab_stringM["$_fancheng"] = {"樊城"}
_tab_stringM["$_fancheng_info"] = {"地处鄂西北，踞汉水中游，与襄阳隔江相望。"}

_tab_stringM["$_xinye"] = {"新野"}
_tab_stringM["$_xinye_info"] = {"属南阳郡，三国时期蜀汉政权的发祥地。"}

_tab_stringM["$_runan"] = {"汝南"}
_tab_stringM["$_runan_info"] = {"辖颍水、淮河之间的37县，属豫州刺史监察范围，因大部分辖地都在“汝河之南”而得名。"}

_tab_stringM["$_hefei"] = {"合肥"}
_tab_stringM["$_hefei_info"] = {"三国时，属魏国淮南郡，为扬州治。"}

_tab_stringM["$_maicheng"] = {"麦城"}
_tab_stringM["$_maicheng_info"] = {"地处沮漳二水之间，传为春秋时楚昭王所筑。"}

_tab_stringM["$_yiling"] = {"夷陵"}
_tab_stringM["$_yiling_info"] = {"地扼渝鄂咽喉，上控巴夔，下引荆襄。"}

_tab_stringM["$_baling"] = {"巴陵"}
_tab_stringM["$_baling_info"] = {"传说夏后羿斩巴蛇于洞庭，积骨如丘陵，故名。"}

_tab_stringM["$_changsha"] = {"长沙"}
_tab_stringM["$_changsha_info"] = {"曾为长沙国都城。东汉初期废“长沙国”改立为“长沙郡”。"}

_tab_stringM["$_baqiu"] = {"巴丘"}
_tab_stringM["$_baqiu_info"] = {"三国时期的吴蜀边境，鲁肃曾率万人驻守于此，并在此建城。"}

_tab_stringM["$_luling"] = {"庐陵"}
_tab_stringM["$_luling_info"] = {"秦皇始置庐陵县，后孙策分豫章郡置庐陵郡。"}

_tab_stringM["$_chaisang"] = {"柴桑"}
_tab_stringM["$_chaisang_info"] = {"西汉置，因有柴桑山而得名。"}

_tab_stringM["$_wuling"] = {"武陵"}
_tab_stringM["$_wuling_info"] = {"武陵郡又称“义陵郡”，为汉高祖刘邦所设，隶属荆州。"}

_tab_stringM["$_hengyang"] = {"衡阳"}
_tab_stringM["$_hengyang_info"] = {"地处南岳衡山之南，因山南水北为“阳”，故得此名。"}

_tab_stringM["$_jiangxia"] = {"江夏"}
_tab_stringM["$_jiangxia_info"] = {"于汉武帝元狩二年置，隶属荆州。"}

_tab_stringM["$_guiyang"] = {"桂阳"}
_tab_stringM["$_guiyang_info"] = {"因在桂水之北而得名，隶属荆州。"}


_tab_stringM["$_linling"] = {"零陵"}
_tab_stringM["$_linling_info"] = {"得名于舜葬九疑，隶属荆州。"}

_tab_stringM["$_linling"] = {"零陵"}
_tab_stringM["$_linling_info"] = {"得名于舜葬九疑，隶属荆州。"}


_tab_stringM["$_jizhou"] = {"冀州城"}
_tab_stringM["$_jizhou_info"] = {"大禹治水以后划分的九州之一。"}
_tab_stringM["$_sishui"] = {"汜水"}
_tab_stringM["$_sishui_info"] = {"古称[雄镇]，东接七朝古都开封，西连九朝古都洛阳。"}
_tab_stringM["$_suanzao"] = {"酸枣"}
_tab_stringM["$_suanzao_info"] = {"豫州、兖州、冀州三州交界，自古兵家必争之地。"}
_tab_stringM["$_pingyuan"] = {"平原"}
_tab_stringM["$_pingyuan_info"] = {"三国时刘备曾在此担任县令。"}
_tab_stringM["$_meiwu"] = {"鹛坞"}
_tab_stringM["$_meiwu_info"] = {"鹛坞离长安二百五十里，城墙之高下厚薄一如长安。是董卓役使民夫二十五万所筑。"}
_tab_stringM["$_chenliu"] = {"陈留"}
_tab_stringM["$_chenliu_info"] = {"三国时，董卓暴乱天下。曹操在此兴义兵，联合群雄，讨伐董卓。"}
_tab_stringM["$_xingyang"] = {"荥阳"}
_tab_stringM["$_xingyang_info"] = {"地理位置险要，素有[两京襟带，三秦咽喉]之称，是中国古代著名的军事重镇。"}
_tab_stringM["$_changan"] = {"长安"}
_tab_stringM["$_changan_info"] = {"中国古代的政治、文化中心，先后有21个王朝和政权建都于此，有[八水绕长安]之美称。"}
_tab_stringM["$_luoyang"] = {"洛阳"}
_tab_stringM["$_luoyang_info"] = {"九朝古都，北据邙山，南望伊阙，洛水贯其中，东据虎牢关，西控函谷关，兵家必争之地。"}
_tab_stringM["$_niuzhu"] = {"牛渚"}
_tab_stringM["$_niuzhu_info"] = {"牛渚牛渚，为中国历史上向为南北纷争，兵家必争之地。"}
_tab_stringM["$_que"] = {"曲阿"}
_tab_stringM["$_que_info"] = {"中国古代历史名城，三国时期因北方战乱，各地人世纷纷迁徙于此，繁华一时。"}
_tab_stringM["$_lujiang"] = {"庐江"}
_tab_stringM["$_lujiang_info"] = {"三国时期，吴魏激烈争夺的地方。"}
_tab_stringM["$_haihun"] = {"上缭"}
_tab_stringM["$_haihun_info"] = {"鄱阳湖东岸的一个险要之地，地势险要，易守难攻。"}
_tab_stringM["$_shaxian"] = {"沙羡"}
_tab_stringM["$_shaxian_info"] = {"西汉置，治所在今湖北武昌西金口。"}
_tab_stringM["$_danyang"] = {"丹阳"}
_tab_stringM["$_danyang_info"] = {"吴文化的发源地之一，是一座具有悠久历史的文化古城。"}
_tab_stringM["$_wujun"] = {"吴郡"}
_tab_stringM["$_wujun_info"] = {"东汉永建四年，分原会稽郡的浙江以西部分设吴郡。"}
_tab_stringM["$_wucheng"] = {"乌程"}
_tab_stringM["$_wucheng_info"] = {"位于江浙地区的古老城池,始建于战国楚考烈王十五年。"}
_tab_stringM["$_jiaxing"] = {"嘉兴"}
_tab_stringM["$_jiaxing_info"] = {"位于江浙地区,自古为富庶繁华之地，素有“鱼米之乡”、“丝绸之府”之美誉。"}
_tab_stringM["$_kuaiji"] = {"会稽"}
_tab_stringM["$_kuaiji_info"] = {"位于吴越地，会稽因绍兴会稽山得名。"}
_tab_stringM["$_chadu"] = {"查渎"}
_tab_stringM["$_chadu_info"] = {"为会稽重要的屯粮之所。"}
_tab_stringM["$_dongjun"] = {"东郡"}
_tab_stringM["$_dongjun_info"] = {"今西南，滑县东部一带。"}
_tab_stringM["$_dongjun_yxwd"] = {"东郡"}
_tab_stringM["$_dongjun_yxwd_info"] = {""}
_tab_stringM["$_nanjun_yxwd"] = {"南郡"}
_tab_stringM["$_nanjun_yxwd_info"] = {""}
_tab_stringM["$_xijun_yxwd"] = {"西郡"}
_tab_stringM["$_xijun_yxwd_info"] = {""}
_tab_stringM["$_beijun_yxwd"] = {"北郡"}
_tab_stringM["$_beijun_yxwd_info"] = {""}
_tab_stringM["$_xibei_yxwd"] = {"西北郡"}
_tab_stringM["$_xibei_yxwd_info"] = {""}
_tab_stringM["$_dongbei_yxwd"] = {"东北郡"}
_tab_stringM["$_dongbei_yxwd_info"] = {""}
_tab_stringM["$_xinan_yxwd"] = {"西南郡"}
_tab_stringM["$_xinan_yxwd_info"] = {""}
_tab_stringM["$_dongnan_yxwd"] = {"东南郡"}
_tab_stringM["$_dongnan_yxwd_info"] = {""}
_tab_stringM["$_shuizhidu"] = {"水之都"}
_tab_stringM["$_shuizhidu_info"] = {"一家位于异世界的神奇旅店，店的附近时不时的有通往其他位面的船只出没。"}
_tab_stringM["$_lvyeshanzhuang"] = {"绿叶山庄"}
_tab_stringM["$_lvyeshanzhuang_info"] = {"一家上市的股份有限公司，经管着绿叶山的产业。"}
_tab_stringM["$_xiahaishi"] = {"下海市"}
_tab_stringM["$_xiahaishi_info"] = {"原来是此位面繁华的城，但是在一年多以前遭受了侵略变得衰败。"}
_tab_stringM["$_feixue"] = {"飞雪城"}
_tab_stringM["$_feixue_info"] = {"原来在青龙神的庇佑下是座繁华的城，但随着青龙神变邪恶，人们开始离开这里。"}
_tab_stringM["$_luoxue"] = {"落雪城"}
_tab_stringM["$_luoxue_info"] = {"原来在青龙神的庇佑下是座繁华的城，但随着青龙神变邪恶，人们开始离开这里。"}
_tab_stringM["$_longdu"] = {"龙都"}
_tab_stringM["$_longdu_info"] = {"距离青龙神山非常接近的一座城，曾住着那些最崇拜青龙神的人。"}
_tab_stringM["$_panshencun"] = {"胖神村"}
_tab_stringM["$_panshencun_info"] = {"隐藏于江南山林地区的神秘村庄，居住着胖氏一族。"}
_tab_stringM["$_nongcuncun"] = {"桃源村"}
_tab_stringM["$_nongcuncun_info"] = {"隐匿于深山之间的神秘村落。"}
_tab_stringM["$_qiangdaoshanzai"] = {"山寨"}
_tab_stringM["$_qiangdaoshanzai_info"] = {"强盗的山寨。"}
_tab_stringM["$_heishanshanzhuang"] = {"太平山庄"}
_tab_stringM["$_heishanshanzhuang_info"] = {"于吉居所，山庄中充满了仙风道气。"}
_tab_stringM["$_shuizhai"] = {"水寨"}
_tab_stringM["$_shuizhai_info"] = {"水贼聚集的地方。"}

_tab_stringM["$_pingyuancheng"] = {"平原城"}
_tab_stringM["$_pingyuancheng_info"] = {"这是一座平原城。"}
_tab_stringM["$_shuicheng"] = {"水城"}
_tab_stringM["$_shuicheng_info"] = {"这是一座水城。"}

_tab_stringM["$_shancheng"] = {"山城"}
_tab_stringM["$_shancheng_info"] = {"这是一座山城。"}

_tab_stringM["$_dongwushuizhai"] = {"东吴水寨"}
_tab_stringM["$_dongwushuizhai_info"] = {"东吴水军所在的水寨。"}

_tab_stringM["$_caojunshuizhai"] = {"曹军水寨"}
_tab_stringM["$_caojunshuizhai_info"] = {"曹军所在的水寨。"}

_tab_stringM["$_xiakou"] = {"夏口"}
_tab_stringM["$_xiakou_info"] = {"三国时期东吴军事重镇，因夏水在此处注入长江，而得名。"}




------------------------------------------------------------------------------------------
--_tab_stringGIFT[1] = {"每日奖励", "使用500 积分来换取游戏币，每天一次。", "领取", "10", "0",}
_tab_stringGIFT[1] = {"每日奖励", "分享给微信好友，获得游戏币，每天一次。", "    分享", "10", "0",}
_tab_stringGIFT[2] = {"新人礼包", "通关广宗之战后领取，每台设备只能领取一次。","  领取", "50","1000",}--名称、条件、领取、金币数、积分数、道具表{{id，number}}
_tab_stringGIFT[3] = {"支持游戏", "您的支持是我们前进的动力! 去苹果商店给游戏评个分吧！（通关“救援青州”，可评分）", "去评价", "50","500",}
_tab_stringGIFT[4] = {"推荐礼包", "推荐游戏给好友，获得丰厚奖励。（通关“救援青州”，并且累计登入天数达到3天，可推荐）", "去推荐", "20-2000", "0",}
_tab_stringGIFT[5] = {"首充礼包", "每一档首次充值将获得独一无二的装备，充值后在邮箱领取。", "去充值", "0", "0", "6元档", "18元档","68元档","98元档","198元档","388元档"}

--=============================================================================================--
--	TD专用
--	_tab_string:	文本
--	_tab_stringM:	地图
--	_tab_stringU:	角色	10001 - 20000
--	_tab_stringS:	技能	10001 - 20000
--	_tab_stringT:	战术卡	1001 - 2000
--	_tab_stringI:	道具	10001 - 20000
--=============================================================================================--


_tab_string["__TEXT_Liubei"] = "刘备"
_tab_string["__TEXT_HuangjinArmy"] = "黄巾军"
_tab_string["__TEXT_Langwang"] = "狼王"

--=============================================================================================--
_tab_stringM["world/td_billboard"] = {"每日排行", "每日排行", "每日排行"}
_tab_stringM["world/TEST_SPEED"] = {"速度测试","TD测试","八卦迷阵"}
_tab_stringM["world/td_demo"] = {"小试牛刀","TD测试","八卦迷阵"}
_tab_stringM["world/td_pvp_001"] = {"夺塔奇兵", "夺塔奇兵", "夺塔奇兵"}
_tab_stringM["world/td_wj_003"] = {"魔龙宝库", "魔龙宝库", "魔龙宝库"}
_tab_stringM["world/td_wj_003_ex"] = {"魔龙宝库", "魔龙宝库", "魔龙宝库"}
_tab_stringM["world/td_wj_003_ex2"] = {"魔龙宝库", "魔龙宝库", "魔龙宝库"}
_tab_stringM["world/td_wj_003_ex3"] = {"魔龙宝库", "魔龙宝库", "魔龙宝库"}
_tab_stringM["world/td_pvp_003"] = {"夺塔奇兵", "夺塔奇兵", "夺塔奇兵"}
_tab_stringM["world/td_sl_01"] = {"铜雀台（上层）", "铜雀台（上层）", "机关重重，英雄救美"} --"铜雀台"
_tab_stringM["world/td_sl_02"] = {"铜雀台（下层）", "铜雀台（下层）", "铜雀台（下层）"}
_tab_stringM["world/td_jx_01"] = {"鬼谷幻境", "新手地图", "新手地图"}
_tab_stringM["world/td_jt_001"] = {"守护伐木场", "守护伐木场", "守护伐木场"}
_tab_stringM["world/td_jt_002"] = {"运粮", "运粮", "运粮"}
_tab_stringM["world/td_jt_003"] = {"矿洞争夺战", "矿洞争夺战", "矿洞争夺战"}
_tab_stringM["world/td_jt_004"] = {"秘境试炼", "秘境试炼", "秘境试炼"}
_tab_stringM["test/testmap"] = {"测试地图","这就是一张测试用的空白地图，你还想得到什么信息吗？",""}
_tab_stringM["test/empty"] = {"空白地图","这就是一张测试用的空白地图，你还想得到什么信息吗？",""}
_tab_stringM["world/td_wj_001"] = {"无尽试炼","本图为无尽模式，玩家需要守护大本营，并抵挡一波又一波敌人的进攻。游戏结束后，根据玩家坚持的时间、以及消灭敌人的数量，结算出本局的得分。玩家每天可以反复挑战无尽地图，取最好得分作为您的今日战绩。每日战绩排名前列的玩家，将获得丰厚奖励。","三路对攻，无尽防守"}
_tab_stringM["world/td_wj_002"] = {"无尽山谷","本图为无尽模式，玩家可以不断挑战自己的防守极限。\n坚持更长时间消灭更多的敌人,以获得更高的战绩。\n战绩达到一定的数值,可以在成就系统里领取奖励。\nGameCenter 记录下您的战绩，与伙伴一较高下。","无尽山谷"}
_tab_stringM["world/td_wj_004"] = {"魔塔杀阵","本图为无尽模式，随着防守进程，玩家会拾取到5种碎片晶石，可对防御塔进行属性增强，提升防御塔的威力。地图上方可发兵帮助玩家坚守阵地。游戏结束后，根据玩家坚持的时间、以及消灭敌人的数量，结算出本局的得分。玩家每天可以反复挑战无尽地图，取最好得分作为您的今日战绩。每日战绩排名前列的玩家，将获得丰厚奖励。","宝石塔阵，万夫莫开"}
_tab_stringM["world/td_wj_005"] = {"秘境试炼", "秘境试炼", "秘境试炼"}
_tab_stringM["world/td_wj_006"] = {"群英阁","本图为自由造塔模式，玩家可在非道路的任意空地上建造防御塔，抵挡敌人进攻。每波开始时，地图上的铁人神像会提供随机3个科技效果，玩家可以3选1。地图上的大小BOSS也会有几率掉落各类新型特种塔和英雄增强碎片。根据获得的科技点随机应变，尝试各种新奇的通关组合是本图主要玩点，祝你好运！","自由造塔，未来随机科技"}
_tab_stringM["world/td_wj_007"] = {"人族无敌","本图为双人组队合作模式，可与队友配合阻挡敌人一波波的进攻，主要借鉴魔兽经典塔防《人族无敌》的玩法框架加上每波随机抽取技能卡的游戏模式。每波开始时，地图上的远古铁人神像会提供随机3个科技效果，玩家可以3选1。地图上的大小BOSS也会有几率掉落各类特种塔和英雄增强碎片，选择方向不同，每次的游戏体验也大为不同。","魔兽经典塔防，双人协作"}
_tab_stringM["world/td_wj_006_02"] = {"群英阁","本图为自由造塔模式，玩家可在非道路的任意空地上建造防御塔，抵挡敌人进攻。每波开始时，地图上的铁人神像会提供随机3个科技效果，玩家可以3选1。地图上的大小BOSS也会有几率掉落各类新型特种塔和英雄增强碎片。根据获得的科技点随机应变，尝试各种新奇的通关组合是本图主要玩点，祝你好运！","魔兽经典塔防，双人协作"}
_tab_stringM["world/td_wj_006_03"] = {"群英阁","本图为自由造塔模式，玩家可在非道路的任意空地上建造防御塔，抵挡敌人进攻。每波开始时，地图上的铁人神像会提供随机3个科技效果，玩家可以3选1。地图上的大小BOSS也会有几率掉落各类新型特种塔和英雄增强碎片。根据获得的科技点随机应变，尝试各种新奇的通关组合是本图主要玩点，祝你好运！","魔兽经典塔防，双人协作"}
_tab_stringM["world/td_wj_006_04"] = {"群英阁","本图为自由造塔模式，玩家可在非道路的任意空地上建造防御塔，抵挡敌人进攻。每波开始时，地图上的铁人神像会提供随机3个科技效果，玩家可以3选1。地图上的大小BOSS也会有几率掉落各类新型特种塔和英雄增强碎片。根据获得的科技点随机应变，尝试各种新奇的通关组合是本图主要玩点，祝你好运！","魔兽经典塔防，双人协作"}
_tab_stringM["world/td_swjg"] = {"守卫剑阁","凛凛人如在，谁云汉已亡！","原图作者，复刻经典"}
_tab_stringM["world/td_pvp_02"] = {"PVP","PVP","PVP"}
_tab_stringM["world/td_newguide"] = {"试炼战场","试炼战场","试炼战场"}

_tab_stringM["world/td_to_cema_sanguo"] = {"策马三国志","策马三国志","策马三国志"}

_tab_stringM["world/td_001_yxcs"] = {"英雄现世","刘备在家中无所事事，想外出游历一番，却遇到了一个黑脸大汉。","B"}
_tab_stringM["world/td_002_zjtj"] = {"涿郡投军","在前往涿郡投军的路上，刘备和张飞击退了黄巾军。","B"}
_tab_stringM["world/td_003_tflw"] = {"扫除狼患","听说附近的小山村闹狼患，于是二人决定一起前往救助百姓。","B"}
_tab_stringM["world/td_003_tflw_hero"] = {"扫除狼患","挑战精英模式的扫除狼患。","B"}

_tab_stringM["world/td_004_tyjy"] = {"桃园结义","刘关张三人意气相投，他们选了一个阳光灿烂的好日子，结拜为异姓兄弟。","B"}
_tab_stringM["world/td_005_dxs"] = {"大兴山","黄巾军的大军囤积在了大兴山，对涿郡蠢蠢欲动，兄弟三人决定在半路拦截。","B"}
_tab_stringM["world/td_006_jyqz"] = {"救援青州","青州告急，兄弟三人马不停蹄的前往救援！","B"}
_tab_stringM["world/td_006_jyqz_hero"] = {"救援青州","挑战精英模式的救援青州。","B"}

_tab_stringM["world/td_007_yczz"] = {"颖川之战","颍川盘踞着黄巾军的大部队张宝和张梁（点火点可释放火攻）","B"}
_tab_stringM["world/td_008_jdz"] = {"救援董卓","黄巾军好像在追一个胖子，救还是不救呢？","B"}
_tab_stringM["world/td_009_jmhj"] = {"广宗之战","最后的决战，打败张角，还百姓一个太平（点火点可释放火攻）","B"}
_tab_stringM["world/td_009_jmhj_hero"] = {"广宗之战","挑战精英模式的广宗之战。","B"}

_tab_stringM["world/td_test001"] = {"救援青州","青州告急，兄弟三人马不停蹄的前往救援！","B"}

_tab_stringM["world/td_101_clqb"] = {"陈留起兵","曹操终于逃脱了董卓的魔爪，对他来说，这将是一个崭新的开始！","B"}
_tab_stringM["world/td_102_sszz"] = {"汜水之战","董卓的行为激起了天下群雄的不满，董卓与群雄的战争开始了！","B"}
_tab_stringM["world/td_103_hlg"] = {"虎牢关","虎牢关前，群雄聚义，他们将要面对的是天下无双的猛将——吕布！","B"}
_tab_stringM["world/td_103_hlg_hero"] = {"虎牢关","挑战精英模式的虎牢关。","B"}

_tab_stringM["world/td_104_hsly"] = {"火烧洛阳","董卓烧毁了洛阳，迁都长安，百姓也因此遭殃……","B"}
_tab_stringM["world/td_105_dzzs"] = {"董卓之殇","在董卓进京的道路上，一个计谋正在悄悄进行……","B"}
_tab_stringM["world/td_106_bhzw"] = {"北海之围","黄巾余党管亥率众大举围攻北海，北海危在旦夕！","B"}
_tab_stringM["world/td_106_bhzw_hero"] = {"北海之围","挑战精英模式的北海之围。","B"}

_tab_stringM["world/td_107_jjjj"] = {"将计就计","攻打濮阳让曹操吃了大亏，于是他决定将计就计，引吕布前来。","B"}
_tab_stringM["world/td_108_tfzx"] = {"讨伐张绣","张绣打算趁着曹操麻痹大意，率军突袭曹操的营寨，危机已近在眼前！","B"}
_tab_stringM["world/td_108_tfzx_hero"] = {"讨伐张绣","挑战精英模式的讨伐张绣。","B"}

_tab_stringM["world/td_109_xpzz"] = {"下邳之战","曹操和刘备的军队将吕布困在了下邳，穷途末路的吕布决定作最后的反抗。（本关我方英雄在据点复活）","B"}


_tab_stringM["world/td_tzdt_001"] = {"张角的逆袭","张角：哇哈哈哈！你们这群蝼蚁，接受上天的惩罚吧！\n关羽：他看上去很不正常！\n\n刘备：反派都这毛病……","B"}
_tab_stringM["world/td_test_new"] = {"测试","测试新塔",""}


_tab_stringM["world/td_dlc_50"] = {"吕布传","下邳之战结束后，吕布成了曹操的阶下囚。在漆黑的地牢里，他一直在寻找逃跑的机会……","C"}
_tab_stringM["world/td_dlc_50_1"] = {"逃脱牢笼", "吕布像往常一样在呆坐在地牢深处，这一天，他听到了一个特别的声音。", "C"}
_tab_stringM["world/td_dlc_50_2"] = {"再战三英", "虎牢关下，吕布再一次的遭遇了三英，一场大战在所难免。", "C"}
_tab_stringM["world/td_dlc_50_3"] = {"荒漠突围", "吕布的逃脱引来了曹操几路大军的围剿，一直追到了这片荒漠中的废墟。", "C"}
_tab_stringM["world/td_dlc_50_4"] = {"霜与火", "在这片古老的废墟下，曹操部下了天罗地网，等待着吕布的到来。（本关需要摧毁敌方双龙塔才能胜利！）", "C"}

_tab_stringM["world/td_dlc_60"] = {"古墓俪影","为了寻找古老的机关秘术，黄月英正四处游历，不经意间，卷入了一场纷争。（本作游戏元素主要为动作闯关）","C"}
_tab_stringM["world/td_dlc_60_1"] = {"村庄除魔", "黄月英从百姓口中打听到了妖魔入侵的消息，决定前去除魔。", "C"}
_tab_stringM["world/td_dlc_60_2"] = {"山谷密道", "在烟雾缭绕的山谷中，更多的妖魔被聚集起来了。", "C"}
_tab_stringM["world/td_dlc_60_3"] = {"荆棘之路", "山谷深处，满地的荆棘阻挡了去路，得想办法过去。", "C"}
_tab_stringM["world/td_dlc_60_4"] = {"古墓探秘", "终于来到了妖魔的老巢，然而黄月英内心却更加迷惑，真相究竟是什么？", "C"}


_tab_stringM["world/td_dlc_70"] = {"枭姬传","学得一身武艺的孙尚香回来与兄长团聚。","C"}
_tab_stringM["world/td_dlc_70_1"] = {"山谷围猎", "孙尚香与哥哥孙策一同前往山谷打猎，然而未知的危险正在等着他们。", "C"}
_tab_stringM["world/td_dlc_70_2"] = {"地宫试练", "为了取得天关塔决，孙尚香进入地宫进行试练。", "C"}
_tab_stringM["world/td_dlc_70_3"] = {"夜袭", "孙尚香与老将军黄盖一同前往偷袭敌军后方。", "C"}
_tab_stringM["world/td_dlc_70_4"] = {"赤壁拦截战", "为了防止曹军的卷土重来，孙刘联军决定拦截黑色斗舰，阻止其逃离。", "C"}



_tab_stringM["world/td_201_tfys"] = {"讨伐袁术","曹操得知袁术称帝，便派遣刘备讨伐袁术。",""}
_tab_stringM["world/td_201_tfys_hero"] = {"讨伐袁术","挑战精英模式的讨伐袁术。","B"}

_tab_stringM["world/td_202_tfys2"] = {"穷途末路","日渐势危的袁术，谋划着最后的反击。",""}
_tab_stringM["world/td_203_qjyd"] = {"清剿余党","陈兰雷薄落草之后四处为祸，百姓民不聊生，纷纷出逃，刘备等人决定为民除害。",""}
_tab_stringM["world/td_204_hsbz"] = {"皇叔败走","为了对付刘备，曹操亲自率军前来，等待他的将是刘备军团的猛烈反扑。",""}
_tab_stringM["world/td_205_bmzw"] = {"白马之围","曹操与袁绍的对决已经在白马展开，然而出师不利，面对如此局面，他将如何应对？",""}
_tab_stringM["world/td_205_bmzw_hero"] = {"白马之围","挑战精英模式的白马之围。","B"}

_tab_stringM["world/td_206_qlzdq"] = {"千里走单骑","在与袁绍军的作战中，关羽得知了刘备的去向，于是决定前往投靠。（本关可召唤廖化协助战斗）",""}
_tab_stringM["world/td_207_sfzc"] = {"卧牛山","在经过卧牛山时，关羽遭到了当地山贼的袭击。",""}
_tab_stringM["world/td_208_zcy"] = {"古城之战","为了重新获得张飞的信任，关羽决定独自解决追兵。（本关我方英雄在据点复活）",""}
_tab_stringM["world/td_209_gcjy"] = {"绝处逢生","刘备以寻找外援为借口离开了袁绍，然而袁绍的手下并不相信刘备，于是一场围追堵截发生了。",""}
_tab_stringM["world/td_209_gcjy_hero"] = {"绝处逢生","挑战精英模式的绝处逢生。","B"}

_tab_stringM["world/td_301_tswl"] = {"霹雳车","袁军筑起土山，以弓箭骚扰曹军，曹军将士苦不堪言，于是谋士刘晔献上了[霹雳车]之计。（保护霹雳车，摧毁敌方箭塔和大本营！）",""}
_tab_stringM["world/td_302_jl"] = {"劫粮","袁绍手下大将韩猛押运粮草从山谷经过，于是曹操打起了劫粮的主意。（击破运粮车，并将其带回我方据点！）",""}
_tab_stringM["world/td_303_swxd"] = {"守卫许都","许攸建议袁绍偷袭曹操的后方，袁绍没有听取，然而袁绍手下的审配却偷偷实行了这一计划。",""}
_tab_stringM["world/td_303_swxd_hero"] = {"守卫许都","挑战精英模式的守卫许都。","B"}

_tab_stringM["world/td_304_xylt"] = {"许攸来投","在袁绍手下得不到重用的许攸感到前途渺茫，心灰意冷之际决定投奔曹操。",""}
_tab_stringM["world/td_305_qxwc"] = {"奇袭乌巢","曹操听取许攸的建议，亲自率领一支轻骑前去偷袭袁绍囤粮之地乌巢。（本关需要摧毁敌方大本营才能胜利！）（地图右下角可发兵）",""}
_tab_stringM["world/td_306_swgd"] = {"守卫官渡","当曹操率领轻骑偷袭官渡的时候，袁军也在趁虚而入，直捣曹操的大本营。",""}
_tab_stringM["world/td_306_swgd_hero"] = {"守卫官渡","挑战精英模式的守卫官渡。","B"}

_tab_stringM["world/td_307_jzgd"] = {"决战官渡","击退袁军主力的进攻之后，曹操发动了对袁军最后的反击。（本关我方英雄在据点复活）（保护霹雳车，摧毁敌方箭塔和大本营！）",""}
_tab_stringM["world/td_308_cszj"] = {"半道伏击","官渡大败，袁绍领着残余部队向后逃窜，然而曹操早已派人埋伏在那里。",""}
_tab_stringM["world/td_308_cszj_hero"] = {"半道伏击","挑战精英模式的半道伏击。","B"}

_tab_stringM["world/td_309_ctzz"] = {"仓亭之战","大溃败之后的袁绍，在仓亭集结了剩余的部队，准备与曹操进行最后的决战。（本关需要摧毁敌方大本营才能胜利！）",""}

_tab_stringM["world/td_401_jbcz"] = {"借兵出征","孙策在袁术手下郁郁不得志，于是以玉玺为质，率领旧部南下。（本关需要摧毁敌方大本营才能胜利！）",""}
_tab_stringM["world/td_402_stzz"] = {"神亭之战","刘繇的失败让太史慈十分失望，他决定独自前来对付孙策。",""}
_tab_stringM["world/td_402_2_pdkj"] = {"平定会稽","击败刘繇后，孙策继续进攻江东各地，他的下一个目标是会稽。",""}
_tab_stringM["world/td_402_2_pdkj_hero"] = {"平定会稽","挑战精英模式的平定会稽。","B"}

_tab_stringM["world/td_403_dzybh"] = {"大战严白虎","收服了太史慈之后，孙策继续了自己一统江东的脚步。",""}
_tab_stringM["world/td_404_xqlj"] = {"水陆并进","趁着刘勋进攻上缭，孙策指挥大军偷袭其后方。（本关需要摧毁敌方大本营才能胜利！）",""}
_tab_stringM["world/td_404_2_ljsz"] = {"临江水战","击败刘勋的孙策军士气大振，于是乘胜进攻黄祖。",""}
_tab_stringM["world/td_404_2_ljsz_hero"] = {"临江水战","挑战精英模式的临江水战。","B"}

_tab_stringM["world/td_405_jzhz"] = {"决战黄祖","得胜的孙策继续向黄祖发动进攻，而刘表也派兵来支援黄祖。（本关需要摧毁敌方大本营才能胜利！）（本关我军可攻击敌塔）",""}
_tab_stringM["world/td_406_sl"] = {"狩猎","平定了江东的孙策，暂时没有了新的目标，于是前往丹徒山中打猎。",""}
_tab_stringM["world/td_406_sl_hero"] = {"狩猎","挑战精英模式的狩猎。","B"}
--_tab_stringM["world/td_407_jxpp"] = {"江夏平叛","刘表治下的江夏出现了叛乱，为了博取刘表的信任，刘备主动要求前往江夏,正好在林间遇见叛贼",""}
_tab_stringM["world/td_408_ymtx"] = {"跃马檀溪","蔡瑁假借宴请众官的名义，邀请刘备前往襄阳赴宴，半路从伊籍口中得知此乃鸿门宴。（本关成功护送刘备即可胜利！）",""}
_tab_stringM["world/td_409_zpbm"] = {"智破八门","曹仁将刘备等人围困在八门金锁阵之中，徐庶告知刘备，此乃残阵。",""}
_tab_stringM["world/td_410_wlcs"] = {"卧龙出山","曹操的阴谋让徐庶不得不离开刘备，临走之时告知山中卧龙可助复兴大业。",""}
_tab_stringM["world/td_411_hsbw"] = {"火烧博望坡","关、张二人对诸葛亮很不信服，而此时正逢夏侯惇领十万大军来讨伐刘备。（点火点可释放火攻）",""}
_tab_stringM["world/td_411_hsbw_hero"] = {"火烧博望坡","挑战精英模式的火烧博望坡。","B"}

_tab_stringM["world/td_412_cbp"] = {"长坂坡","刘表病逝，刘琮将荆襄九郡献了曹操，携民逃亡的刘备在长坂坡被曹军追上。",""}
_tab_stringM["world/td_412_cbp_hero"] = {"长坂坡","挑战精英模式的长坂坡。","B"}
--_tab_stringM["world/td_413_ljsz"] = {"临江水战","曹操率八十万大军南下，在诸葛亮和鲁肃的努力下，孙、刘决定联合对抗曹操。",""}
_tab_stringM["world/td_414_ccjj"] = {"草船借箭","曹操率八十万大军南下，孙、刘决定联合对抗曹操。大战前，周瑜限诸葛亮十日内造出十万支箭，而诸葛亮却说只需三日...",""}
_tab_stringM["world/td_415_jdf"] = {"借东风","大战将至，诸葛亮在七星台祭风，却遭到了曹军的阻拦。两方的争斗惹怒了风神。",""}
_tab_stringM["world/td_415_jdf_hero"] = {"借东风","挑战精英模式的借东风。","B"}

_tab_stringM["world/td_416_cbzz"] = {"赤壁之战","大战终于打响，孙刘联军在万事齐备后发动了总攻击。而曹操也祭出了自己的最强兵器。",""}

_tab_stringM["world/td_501_caswz"] = {"长安守卫战","建安十六年，马超为报杀父之仇，联合韩遂，起兵进犯长安。",""}
_tab_stringM["world/td_502_gxqp"] = {"割须弃袍","丢失长安和潼关之后，曹操亲率大军前来迎战马超。",""}
_tab_stringM["world/td_503_zzbc"] = {"智筑冰城","曹操得到高人指点，命军士趁着天寒运土泼水，一夜之间建成了一座冰城。",""}
_tab_stringM["world/td_504_dzxyj"] = {"威震逍遥津","趁着曹操远征之际，孙权率领着十万大军进攻合淝。",""}
_tab_stringM["world/td_504_2_gmsl"] = {"古墓试炼","曹操手下的掘子军无意间挖到了一个古墓。",""}
_tab_stringM["world/td_505_hzzdz"] = {"汉中争夺战","曹操为争夺汉中，与刘备展开了全力以赴的作战，准备进行最后的反击。（本关需要击败敌方刘备才能胜利！）",""}
_tab_stringM["world/td_506_syqj"] = {"水淹七军","建安二十四年七月，曹操派于禁、庞德前去解救樊城危机，不料遭关羽水攻，陷于危难。",""}
_tab_stringM["world/td_507_mcswz"] = {"麦城守卫战","建安二十四年，襄樊之战时吕蒙“白衣渡江”，关羽退守麦城，此时吴国全面进攻。",""}
_tab_stringM["world/td_508_ylzz"] = {"夷陵之战","公元222年六月，蜀军已深入吴境，此时刘备百里连营、兵力分散，从而为陆逊实施战略反击提供了可乘之机。",""}
_tab_stringM["world/td_509_bzt"] = {"八阵图","夷陵之战以蜀军的失败而告终，陆逊乘胜追击，却在无意间闯进了诸葛亮提前布好的八阵图中。",""}

_tab_stringM["world/td_test"] = {"测试地图","测试地图",""}

--大地图引导内容
_tab_stringM["$MAP_GUIDE_001"] = {
	"@R1:16024@欢迎来到策马守天关。点击城镇，挑战第一关。",
}
_tab_stringM["$MAP_GUIDE_002"] = {
	"@R1:16024@东汉末年，天下大乱，狼烟四起，宦官当权，各路诸侯因纷纷揭竿而起割据一方！",
	"主公，拯救黎民于水火的重任，全系您一人身上！",
	
}
_tab_stringM["$MAP_GUIDE_003"] = {
	"@R1:16024@战斗胜利后，根据本场战斗的表现会评星，一共有三颗星。星级越高，获得的奖励越丰厚。",
}
_tab_stringM["$MAP_GUIDE_004"] = {
	"@R1:16024@点击进入战役，开始挑战第一关。",
}
_tab_stringM["$MAP_GUIDE_005"] = {
	"@R1:16024@欢迎来到魔塔前线。挑战第一关，开启你的旅程。",
}
_tab_stringM["$MAP_GUIDE_209"] = {
	"@R1:16024@恭喜您解锁精英模式。",
	"点击带有“精英”字样的关卡，可选择精英模式挑战。",
	"挑战精英模式需消耗一定资源，每次成功通关都有几率抽到独一无二的橙装。",
}

--楼桑村剧情
_tab_stringM["$_001_lsc_01"] = {
	"@L1:0@东汉末年，宦官专权，灾乱四起，民不聊生。走投无路的贫苦百姓，在大贤良师张角的号令下，头扎黄巾，揭竿而起。",
	"@L1:18004@苍天已死，黄天当立。岁在甲子，天下大吉。\n今汉运将终，大圣人出。汝等皆宜顺天从正，以乐太平。",
	"@L1:0@黄巾军势浩大，官军望风而靡。大将军何进奏帝火速降诏，令各处备御，讨贼立功。榜文行到涿郡，引出涿郡中一个英雄。",
	"@L1:18001@大丈夫处世，当努力建功立业。近日黄巾倡乱，待我安顿好母亲，便去投军讨贼。",
}
_tab_stringM["$_001_lsc_02"] = {
	"@L1:0@东汉末年，宦官专权，灾乱四起，民不聊生。走投无路的贫苦百姓，在大贤良师张角的号令下，头扎黄巾，揭竿而起。",
	"@L1:16022@不好了！黄巾军打过来了！",
	"@L1:16023@玄德啊，楼桑村的安危，就全看你的了！",
	"@L1:18001@长老放心，只要我刘备还站在这里，就不会让贼寇踏进村子一步！",
	
	--"@L1:18001@村子外面有黄巾流寇盘踞，必须加强一下村子的防御。",
}
_tab_stringM["$_001_lsc_03"] = {
	"@L1:18001@这边应该没危险了，听说涿郡在招军，正好去转转。",	
	--"@L1:18001@娘亲，孩儿去涿郡投军了,您要好好照顾自己。",
}
_tab_stringM["$_001_lsc_04"] = {
	"@L1:18001@这不可能！",
}
_tab_stringM["$_001_lsc_05"] = {
	"@L1:18001@沿路再设几处箭塔，固若金汤。",
}


_tab_stringM["$_001_lsc_06"] = {
	"@R1:16024@选择刘备，移动到指定地点防守。",
}
_tab_stringM["$_001_lsc_08"] = {
	"@R1:16024@在道口建造一座炮塔，可保楼桑村平安。",
	"点击塔基，再点击炮塔图标，建造一座炮塔。",
}
_tab_stringM["$_001_lsc_10"] = {
	"@R1:16024@很好，再改造一下箭塔，提升防御能力！",
}
_tab_stringM["$_001_lsc_12"] = {
	"@L1:16024@点击刘备的技能，选择一个地点释放，可召唤民兵。",
}
_tab_stringM["$_001_lsc_14"] = {
	"@L1:16024@战术技能使用后会进入冷却，需要等待一段时间才能再次释放。",
}
_tab_stringM["$_001_lsc_15"] = {
	"@R1:16024@上方左侧是剩余生命。每漏过1个敌人，生命减少1点。生命值为0，防守失败。",
	"右侧是金币。消灭敌人会获得金币。金币用来建造、升级塔和塔的科技。",
	"第二行是当前出怪波次和总共波次。",
}
_tab_stringM["$_001_lsc_16"] = {
	"@L1:16024@点击【开战】，进行防守！",
}



_tab_stringM["$_001_lsc_26"] = {
	"@R1:16024@恭喜你，通过第一关！",
	"您本次战斗到三星评价！获得丰厚奖励。快来提升你的战力。",
}
_tab_stringM["$_001_lsc_27"] = {
	"@L1:16024@点将台是查看英雄，装备，塔的地方。",
}
_tab_stringM["$_001_lsc_28"] = {
	"@L1:16024@按照指引，提升你刚获得的英雄吧。",
}
_tab_stringM["$_001_lsc_29"] = {
	"@L1:16024@很好。以后每次打完一关，都别忘了来换装备、升级英雄技能。",
}
_tab_stringM["$_001_lsc_30"] = {
	"@R1:16024@接下来，开始第二关的挑战吧。",
}



_tab_stringM["$_001_lsc_31"] = {
	"@L1:16024@恭喜你开启了任务活动。",
}
_tab_stringM["$_001_lsc_32"] = {
	"@L1:16024@点击任务活动按钮，领取您完成的第一个成就。",
}
_tab_stringM["$_001_lsc_33"] = {
	"@L1:16024@在联网状态下，点击任务、活动分页按钮，可查看每日任务和活动。",
	"任务每天0点刷新。活动奖励丰厚。",
}



_tab_stringM["$_001_lsc_40"] = {
	"@L1:16024@恭喜你开启了商店。",
}
_tab_stringM["$_001_lsc_41"] = {
	"@L1:16024@点击商店，开始购买第一件商品。",
}

_tab_stringM["$_001_lsc_50"] = {
	"@L1:16024@恭喜你开启了战术卡片。",
}
_tab_stringM["$_001_lsc_51"] = {
	"@L1:16024@点击战术卡片，开始合成第一张战术技能卡。",
}
_tab_stringM["$_001_lsc_52"] = {
	"@L1:16024@很好，挑战关卡胜利会得到战术技能卡碎片。商店也能买到碎片。通过碎片合成战术技能卡，增加战斗的实力。",
}

_tab_stringM["$_001_lsc_60"] = {
	"@R1:16024@贼寇越来越多了，还得多造些箭塔才好防守。",
}

_tab_stringM["$_001_lsc_61"] = {
	"@R1:14018@很好，这里也有不少精壮男子，抓回去定能得不少赏赐。",
	"@R1:14018@小的们快上！一个也别放过，哈哈哈！",
}

_tab_stringM["$_001_lsc_62"] = {
	"@L1:16024@主公技艺如此精湛，不知如何尊称。",
}

------------------------------------------------------------------------
_tab_stringM["$_001_lsc_63"] = {
	"@L1:16024@接下来，为我方阵地增加一座防守塔：剧毒塔！点击箭塔类图标，选择路边空地建造！",
}

_tab_stringM["$_001_lsc_64"] = {
	"@L1:16024@每一波敌人出现时，远古铁人神像会提供1个科技点，点击神像从三个随机技能选择一个！",
}

_tab_stringM["$_001_lsc_65"] = {
	"@L1:16024@点选造好的箭塔，选择第一个分支，将普通箭塔升级为剧毒塔！",
}

--[[
_tab_stringM["$_001_lsc_66"] = {
	"@L1:16024@点击【开战】，防守敌人一波波的进攻！",
}
]]

_tab_stringM["$_001_lsc_67"] = {
	"@L1:16024@英雄可以自由移动，请选中您的英雄，移动到指定位置！",
}

_tab_stringM["$_001_lsc_68"] = {
	"@L1:16024@点击英雄技能图标，选择一个地点释放！",
}

_tab_stringM["$_001_lsc_69"] = {
	"@L1:16024@有需要的话可以翻阅地上的【天关塔诀】卷轴！现在战斗已经打响，接下来就看你的指挥了！",
}

_tab_stringM["$_001_lsc_70"] = {
	"@L1:16024@注意！有一波敌人即将偷袭！",
}

_tab_stringM["$_001_lsc_71"] = {
	"@L1:16024@你的指挥还真不错，成功防守到了第@wave波敌军。积极运用英雄卡位防守很关键！继续加油吧！",
}

_tab_stringM["$_001_lsc_72"] = {
	"@L1:16024@这次成功防守到了第@wave波敌军。还可以再接再厉！冰塔、地刺塔可以缓速敌人，连弩塔性价比很高！",
}

_tab_stringM["$_001_lsc_73"] = {
	"@L1:16024@这次成功防守到了第@wave波敌军。英雄复活时间越短，越能拖延敌军！再继续加油吧！",
}

_tab_stringM["$_001_lsc_74"] = {
	"@L1:16024@已经防守到了第@wave波敌军。希望铁人神像赐予我们更多的科技战术，再继续加油一次吧！",
}

_tab_stringM["$_001_lsc_75"] = {
	"@L1:16024@已经逐步领会到了天关塔诀的奥义了吧！恭喜你！你就快成为老练的战场指挥官了！",
	"我们现在要撤离这片战场了，等到将来时机成熟，再打回来！接下来准备指挥更多新的英雄，迎接新的挑战吧！",
}




--涿郡投军剧情
_tab_stringM["$002_zjtj_01"] = {
	"@L1:18001@近日黄巾倡乱，待我们安顿好家人，便一起前去投军讨贼。",
	"@R1:18003@有俺老张在此，贼人们休想通过！",
}
_tab_stringM["$002_zjtj_02"] = {
	"@L1:18001@壮士真是好武艺，不知高姓大名？",
	"@R1:18003@我姓张名飞，字翼德，世居涿郡，颇有家资，专好结交天下豪杰。兄弟你武艺也算不俗，想必也不是无名之辈。",
	"@L1:18001@我本汉室宗亲，姓刘名备，有志欲破贼安民。如今灭了狼患，备欲投军灭贼，建立功业。",
	"@R1:18003@哈哈哈，你又和俺老张想到一块儿去了！走走走，先去吃酒，然后一同投军！",
}

_tab_stringM["$002_zjtj_04"] = {
	"@R1:16024@进入战斗前需要配置本次出战的队伍。",
	--"出战队伍共由三个部分组成。",
}
_tab_stringM["$002_zjtj_05"] = {
	"@R1:16024@第一部分：配置可以出战的英雄。",
	--"可出战的英雄都会在这块区域显示。",
}
_tab_stringM["$002_zjtj_06"] = {
	"@R1:16024@第二部分：配置可以出战的防御塔。",
	--"可出战的塔都会在这块区域显示。",
}
_tab_stringM["$002_zjtj_07"] = {
	"@R1:16024@第三部分：配置可以出战的战术技能卡。",
	--"可出战的战术技能卡都会在这块区域显示。",
}
_tab_stringM["$002_zjtj_08"] = {
	"@R1:16024@每个部分都有可选数量上限，每一关数量上限都不同。",
}
_tab_stringM["$002_zjtj_09"] = {
	"@R1:16024@点击某个卡牌，该卡牌就会进入出战列表中。",
}
_tab_stringM["$002_zjtj_10"] = {
	"@R1:16024@想要取消出战列表中的某个卡牌，再次点击这张卡牌即可。",
}
_tab_stringM["$002_zjtj_11"] = {
	"@L1:16024@右边区域显示的是你当前选中卡牌的属性。",
}
_tab_stringM["$002_zjtj_12"] = {
	"@R1:16024@很好。接下来选择刘备、张飞、剧毒塔、巨炮塔这四张卡牌开始战斗。",
}
_tab_stringM["$002_zjtj_12_0"] = {
	"@R1:16024@很好。接下来选择刘备、剧毒塔、巨炮塔这三张卡牌开始战斗。",
}
_tab_stringM["$002_zjtj_13"] = {
	"@L1:16024@您获得的总星数越多，可携带的卡牌越多。合理分配卡牌，在战斗中发挥最大效果。",
}
_tab_stringM["$002_zjtj_14"] = {
	"@L1:16024@阵容配置完毕。点击开战按钮，开始战斗！",
}

_tab_stringM["$002_zjtj_23"] = {
	"@R1:16024@开始战斗前，先来改造箭塔，提升防御能力。",
	"选中箭塔，点击中级箭塔图标，将箭塔改造为中级箭塔。",
}
_tab_stringM["$002_zjtj_24"] = {
	"@R1:16024@点击中级箭塔，选择剧毒塔分支，将箭塔改造为剧毒塔。",
}
_tab_stringM["$002_zjtj_25"] = {
	"@L1:16024@剧毒塔改造完成。点击出兵，开始防守！",
}

_tab_stringM["$002_zjtj_30"] = {
	"@R1:16024@恭喜你通过第二关！",
}

_tab_stringM["$002_zjtj_31"] = {
	"@L1:14019@上吧！狼崽子们！",
}


--讨伐狼王剧情S
_tab_stringM["$003_tflw_01"] = {

}
_tab_stringM["$003_tflw_02"] = {
	"@L1:18003@痛快痛快，居然有这么厉害的狼！",
	"@R1:18001@解决了这里的狼患，也算是为百姓做了点事。",
	"@R1:18001@翼德，我们还是早点回涿郡吧。",
	"@L1:18003@好！俺老张听你的！",
}

_tab_stringM["$003_tflw_03"] = {
	"@R1:16024@此地荒废多时，有一座破损的炮塔。",
}

_tab_stringM["$003_tflw_04"] = {
	"@R1:16024@长按炮塔来将它拆除。",
}

_tab_stringM["$003_tflw_05"] = {
	"@R1:16024@拆除完毕，开始防守。",
}

--桃园结义剧情
_tab_stringM["$004_tyjy_01"] = {
	"@L1:18002@城外似有流寇来袭。酒保，快斟酒来吃，待我灭了贼子，作个投名状去投军。",
	"@R1:18003@哈哈哈，没想到又有人和俺老张想到一块儿去了！来一个灭一个，来两个灭一双！",
}
_tab_stringM["$004_tyjy_02"] = {
	"@L1:18001@壮士真是好武艺，吾二人欲招募乡勇，与公同举大事，如何？",
	"@R1:18002@吾姓关名羽，字云长，河东解良人也。今闻此处招军破贼，特来应募。兄之言甚得吾心，云长愿与君共事！",
	"@L1:18003@吾庄后有一桃园，花开正盛。明日当于园中祭告天地，我三人结为兄弟，协力同心，然后可图大事。",
	"@R1:18002@如此甚好！",
}

_tab_stringM["$004_tyjy_03"] = {
	"@L1:18001@有一大波黄巾军来袭，我等需严阵以待！",
	"@L1:18003@俺听你的。",
	"@R1:18002@来的正好！",
}

--大兴山剧情
_tab_stringM["$005_dxs_01"] = {
--	"@L1:0@【提示：每一关都会获得一些战术卡片，记得到主城查看，两张相同的卡片可以合成到更高级哦。】",
	"@L1:18001@此处似乎囤积着大量的贼寇，怕是要对涿郡不利。",
	"@L1:18003@哼！来多少灭多少！",
}

_tab_stringM["$005_dxs_02"] = {
	"@R1:18001@黄巾军步步紧逼，我等万不可大意！",
	"@L1:18002@大哥说得是。",
}

--救援青州剧情
_tab_stringM["$006_jyqz_01"] = {
	"@L1:18001@我等一定要守住青州，绝不能让百姓遭殃！",
	"@R1:18002@大哥放心，有我和三弟在，一个贼寇也别想进来！",
}

_tab_stringM["$006_jyqz_02"] = {
	"@L1:18003@终于打完了，大哥、二哥我们吃酒去！",
}

--颍川之战剧情
_tab_stringM["$007_yczz_01"] = {
	"@L1:18001@这位将军，我等已备好引火之物，可埋伏贼人。",
	"@R1:18005@好！就等他们自己送上门来！",
	"@L1:0@【提示：发动火攻可对大范围的敌人造成持续的伤害。】",
}


_tab_stringM["$007_yczz_02"] = {
	"@L1:18001@可惜！让这两个人跑了！",
	"@R1:18005@无妨，现在各路义军已成合围之势，张角时日不长了！",
	"@L1:18001@后会有期！",
}

--救董卓剧情
_tab_stringM["$008_jdz_01"] = {
	"@L1:15010@可恶啊！这些敌人！",
	"@R1:18001@前面有人被黄巾军追击！",
	"@R1:18001@好像还是个官，快去助他！",
	"@L1:0@【提示：拦截追兵，协助董卓逃脱。】",
}


_tab_stringM["$008_jdz_02"] = {
	"@L1:15010@多谢几位英雄相助！不知现居何职？",
	"@R1:18001@我三人皆是白身。",
	"@L1:15010@白身？哼！",
	"@R1:18001@……",
}

--讨伐张角剧情
_tab_stringM["$009_tfzj_01"] = {
	"@L1:18004@你们这群鼠辈，屡屡坏我大事，这次绝不轻饶！",
	"@L1:18002@哼！有本事便来吧！",
	"@L1:18001@二弟、三弟小心！这张角不好对付！",
}


_tab_stringM["$009_tfzj_02"] = {
	"@L1:18003@真是不堪一击！",
	"@L1:18002@如此一来，百姓又可安居乐业了吧！",
	"@L1:18001@不，云长，乱世才刚刚开始啊！",
}



--陈留起兵剧情
_tab_stringM["$101_clqb_01"] = {
	"@L1:18010@孟德，你终于来了，我们这帮人还都等着你发号施令呢！",
	"@L1:18005@嗯，不过在此之前，得先把这些追兵解决了！",
}


_tab_stringM["$101_clqb_02"] = {
	"@L1:18005@乱世终于开始了，属于我曹孟德的乱世！",
}

--汜水之战剧情
_tab_stringM["$102_sszz_01"] = {
	"@L1:18005@听说这次的对手是董卓手下的猛将华雄！",
	"@L1:18002@让我去会会他！",
}


_tab_stringM["$102_sszz_02"] = {
	"@L1:18002@华雄，不过如此而已！",
}


--虎牢关剧情
_tab_stringM["$103_hlg_01"] = {
	"@L1:14037@可恶啊，这群鼠辈，一个个的都背叛我！",
	"@L1:14030@父亲不必愤怒，我这就去把他们的人头取来！",
	"@L1:14037@好！有奉先在此，我可高枕无忧！",
}


_tab_stringM["$103_hlg_02"] = {
	"@L1:18003@嘿嘿，真是痛快哪！",
	"@L1:18002@这吕布还真是一个好对手！",
	"@L1:18001@……",
}


--火烧洛阳剧情
_tab_stringM["$104_hsly_01"] = {
	"@L1:18005@这群鼠辈，竟然用百姓作掩护！",
	"@L1:18005@能救多少救多少吧！",
	"@L1:0@【提示：拦截追兵，协助百姓逃脱。】",
}


_tab_stringM["$104_hsly_02"] = {
	"@L1:18005@可惜，还是来晚了！",
}



--董卓之殇剧情
_tab_stringM["$105_dzzs_01"] = {
	"@L1:18005@诸将小心应战，待会自有援军助阵！",
	"@L1:18010@孟德放心吧！",
}


_tab_stringM["$105_dzzs_02"] = {
	"@L1:14030@董卓，你的命就由我吕布取下了！",
	"@L1:14037@奉先，为何背叛我！",
	"@L1:14030@认命吧！",
	"@L1:14037@啊！",
}


--北海之围剧情
_tab_stringM["$106_bhzw_01"] = {
	"@L1:14038@哼！孔融老儿竟敢不借我粮草，自找的！",
	"@L1:18001@敌军来势甚大啊，二弟三弟小心应战！",
	"@L1:18002@",
	"@L3:18003@",
	"@L2:关羽、张飞@大哥放心！",
}


_tab_stringM["$106_bhzw_02"] = {
	"@L1:18001@敌军总算是退去了！",
}

--将计就计剧情
_tab_stringM["$107_jjjj_01"] = {
	"@L1:18005@没想到栽在吕布手上，必定是陈宫的谋略！",
	"@L1:18005@这次只好将计就计，引吕布前来！",
}


_tab_stringM["$107_jjjj_02"] = {
	"@L1:18005@可惜，让他跑了！",
}


--讨伐张绣剧情
_tab_stringM["$108_tfzx_01"] = {
	"@L1:18016@丞相还没醒来，诸军守住路口！",
	"@L1:14020@",
	"@L1:士兵@是！",
}


_tab_stringM["$108_tfzx_02"] = {
	"@L1:18005@赢了，但因为我的失策，竟然损失了这么多手下！",
	"@L1:18010@孟德不必担忧。以我军的声望，很快会有新的人加入的！",
}

--下邳之战剧情
_tab_stringM["$109_xpzz_01"] = {
	"@L1:14030@哼！你们这群杂碎，想与我为敌，真是不自量力！",
	"@L1:18001@吕布，你休要猖狂，不记得虎牢关了么！",
	"@L1:18005@玄德不必与他多言，他这不过是困兽之斗罢了！",
}


_tab_stringM["$109_xpzz_02"] = {
	"@L1:14030@没想到……真的败下阵来了，哈哈哈……",
	"@L1:18002@吕布……天下再也找不到这样的对手了！",
}


--------------------------------------------------------------
--讨伐袁术剧情
_tab_stringM["$201_tfys_01"] = {
	"@L1:18001@这次的来将是袁术手下的名将纪灵，不可小觑！",
	"@L1:18002@就让我来会他一会！",
}


_tab_stringM["$201_tfys_02"] = {
	"@L1:18002@还算有些实力。",
}



--穷途末路剧情
_tab_stringM["$202_tfys2_01"] = {
	"@L1:18003@真无聊，袁术手下就没一个能打的吗？",
	"@L1:18001@三弟不可大意，小心对手的反扑！",
}


_tab_stringM["$202_tfys2_02"] = {
	"@L1:18003@认命吧，袁术！",
	"@L1:14124@这就是我的宿命么……",
}


--清剿余党剧情
_tab_stringM["$203_qjyd_01"] = {
	"@L1:18001@大家小心，陈兰雷薄的人马恐怕就要到了。",
	"@L1:18003@哼！几个毛贼，怕他作甚！",
}


_tab_stringM["$203_qjyd_02"] = {
	"@L1:18003@毛贼就是毛贼，真不经打！",
}


--皇叔败走剧情
_tab_stringM["$204_hsbz_01"] = {
	"@L1:18005@守住各处要道，今夜刘备肯定会突围！",
}


_tab_stringM["$204_hsbz_02"] = {
	"@L1:18005@云长，现在你已是孤身一人，为何仍不肯投降？",
	"@L1:18002@一臣不事二主，关羽宁死不降！",
	"@L1:18005@你降我，乃是降汉，不算背主。况且，你若去了，刘备的家小又该怎么办？望将军三思！",
	"@L1:18002@……",
}

--白马之围剧情
_tab_stringM["$205_bmzw_01"] = {
	"@L1:18005@这颜良已连败我几员大将，如何是好?",
	"@L1:18002@丞相勿虑。我视颜良，如插标卖首而已，愿去万军中取其首级，献于丞相！",
}


_tab_stringM["$205_bmzw_02"] = {
	"@L1:18005@将军真乃神人也！",
}

--千里走单骑剧情
_tab_stringM["$206_qlzdq_01"] = {
	"@L1:0@却说关羽辞曹操而去，却找不见车仗，急忙四下寻找。",
	"@L1:14136@关将军且住！",
	"@L1:18002@你是何人？",
	"@L1:14136@在下廖化，两位夫人正在山寨歇息！将军少歇，在下这就去叫人将两位夫人送下山来。",
}


_tab_stringM["$206_qlzdq_02"] = {
	"@L1:14145@哼！今日就此别过，有朝一日，定与你疆场再见！",
}

--收复周仓剧情
_tab_stringM["$207_sfzc_01"] = {
	"@L1:14151@来者快将宝马留下，放你离去！",
	"@L1:18002@哪里来的毛贼，敢打我千里马的主意！",
}


_tab_stringM["$207_sfzc_02"] = {
	"@L1:14151@周仓拜见关将军！愿将军不弃，收为步卒，早晚执鞭随镫，肝脑涂地。",
}

--斩蔡阳剧情
_tab_stringM["$208_zcy_01"] = {
	"@L1:0@关羽来古城寻张飞，不想张飞却对关羽大打出手……",
	"@L1:18003@哼！这来的可是军马，如今还敢抵赖么！",
	"@L1:18002@贤弟且住，看我斩此来将，以表真心！",

}


_tab_stringM["$208_zcy_02"] = {
	"@L1:18003@二哥！",
	"@L1:18002@贤弟不用多说，你我同去迎大哥回来吧！",
}

--古城聚义剧情
_tab_stringM["$209_gcjy_01"] = {
	"@L1:18001@唔，前方便是古城了，云长、翼德，我来了！",
	"@L1:18001@不好！有追兵！",
}


_tab_stringM["$209_gcjy_02"] = {
	"@L1:18002@大哥！",
	"@L1:18003@大哥！",
	"@L1:18001@二弟！三弟！这一别真是太久了！",
	"@L1:0@刘备等人进入古城，三兄弟终得重聚。众人欢喜无限，连饮数日。",
}




---------------------------
--霹雳车
_tab_stringM["$301_tswl_01"] = {
	"@L1:18005@袁军筑起土山，日夜袭扰，诸位可有对策？",
	"@L1:14101@",
	"@L1:刘晔@可作发石车破之，丞相请看此图！",
	"@L1:18005@唔，霹雳车？甚妙！吩咐军中工匠，依此图连夜赶造百辆！",
}


_tab_stringM["$301_tswl_02"] = {
	"@L1:18005@此战虽胜，却不伤袁军根本。想要破袁，不知要到何时！",
}
--------------------------
--劫粮
_tab_stringM["$302_jl_01"] = {
	"@L1:14101@",
	"@L1:荀攸@听闻敌将韩猛运粮从山谷经过，丞相何不半道击之？",
	"@L1:18005@唔，我也正有此意！",
}


_tab_stringM["$302_jl_02"] = {
	"@L1:18014@丞相，已将敌将韩猛击退，夺得粮草数车！",
	"@L1:18005@好极了！此番虽是小胜，却是抓到袁军命脉！",
}
--------------------------
--守卫许都
_tab_stringM["$303_swxd_01"] = {
	"@L1:14101@",
	"@L1:荀彧@没想到，袁军真的来偷袭许都！还好早有防备！",
	"@L1:荀彧@全军戒备，不可让袁军有可趁之机！",
}
_tab_stringM["$303_swxd_02"] = {
	"@L1:14101@",
	"@L1:荀彧@精锐都去了前线，还真是艰难啊！",
	"@L1:荀彧@不过对方终于还是退去了！",
}
--------------------------------------------------------------------------------------------------------------------------
--许攸来投
_tab_stringM["$304_xylt_01"] = {
	"@L1:14200@",
	"@L1:许攸@哼！袁绍不听良言，早晚必被曹操所擒，与其坐以待毙，我还不如去投曹操！",
}
_tab_stringM["$304_xylt_02"] = {
	"@L1:14200@",
	"@L1:许攸@孟德！南阳许攸来投！望赐收录啊！",
	"@L1:18005@子远肯来，乃天助我也！快请进！",
}
-----------------------
--奇袭乌巢
_tab_stringM["$305_qxwc_01"] = {
	"@L1:18005@众将士听令！此战关系我军死生存亡，只准向前，不可退后！",
}
_tab_stringM["$305_qxwc_02"] = {
	"@L1:18014@丞相！几路追兵皆已杀散！",
	"@L1:18005@很好！此番大胜，我军胜机已现，择日当与袁绍决战！",
}
------------------------
--守卫官渡
_tab_stringM["$306_swgd_01"] = {
	"@L1:14101@",
	"@L1:荀攸@丞相轻骑在外，我等不可轻敌！",
}
_tab_stringM["$306_swgd_02"] = {
	"@L1:14101@",
	"@L1:荀攸@啊！丞相回来了！",
	"@L1:18005@诸位辛苦了！不过现在还没到放松的时候，决战的时刻已经到了！",
}
------------------------
--决战官渡
_tab_stringM["$307_jzgd_01"] = {
	"@L1:18005@袁军连番大败，已失锐气，今当一鼓作气，击破袁军！",
}
_tab_stringM["$307_jzgd_02"] = {
	"@L1:18014@丞相！袁绍已带着残部渡河而去！是否追击！",
	"@L1:18005@如今的袁绍已不足为虑，随他去吧。连番大战，我军也需休整几日。",
}
------------------------
--半道伏击
_tab_stringM["$308_cszj_01"] = {
	"@L1:18014@袁军果然从此路过！众将士准备迎敌！",
}
_tab_stringM["$308_cszj_02"] = {
	"@L1:18014@很好，该去和丞相汇合了！",
}
------------------------
--仓亭之战
_tab_stringM["$309_ctzz_01"] = {
	"@L1:18005@袁绍！你大势已去，不如降了我，我必奉为上宾！",
	"@L1:14226@曹阿瞒！我决不会让你如愿的！",
}
_tab_stringM["$309_ctzz_02"] = {
	"@L1:18005@袁绍啊！你终究不是我曹孟德的对手！",
	"@L1:18005@刘备……刘备……",
}
------------------------
--借兵出征
_tab_stringM["$401_jbcz_01"] = {
	"@L1:18018@袁术啊，利用了我这么久，你也该知足了！",
	"@L1:18018@父亲……儿不会让你失望的！",
}
_tab_stringM["$401_jbcz_02"] = {
	"@L1:18018@公瑾！没想到你会来！",
	"@L1:18019@听闻你南下的消息，我便马不停蹄的赶来了！",
	"@L1:18018@真是好极了！一起干番事业吧！",
}
------------------------
--神亭之战
_tab_stringM["$402_stzz_01"] = {
	"@L1:18019@这个太史慈可不简单啊，伯符你要小心！",
	"@L1:18018@没什么好怕的，我早就想会会他了！",
}
_tab_stringM["$402_stzz_02"] = {
	"@L1:18018@刘瑶蠢辈不肯重用将军，才有此败！我知将军乃真豪杰，何不与我共图大业！",
	"@L1:18006@明公厚待如此，我又怎忍相弃！愿为先锋，助明公扫平江东！",
}

------------------------
--大战严白虎
_tab_stringM["$403_dzybh_01"] = {
	"@L1:14101@",
	"@L1:王朗@孙策，我与你向来井水不犯河水，今何故犯我疆界！",
	"@L1:18018@你助逆贼严白虎，与我为敌，又是何故？",
	"@L1:14029@",
	"@L1:严白虎@哼！何必与他多费唇舌！",
}
_tab_stringM["$403_dzybh_02"] = {
	"@L1:18019@伯符，江东之地已尽归你有，接下来有何打算？",
	"@L1:18018@…………我父亲的仇，该报了！",
}
------------------------
--水陆并进
_tab_stringM["$404_xqlj_01"] = {
	"@L1:18018@没想到这庐江防守如此严密，如何是好！",
	"@L1:18019@伯符不必心急，先解决其水上的防御，然后才好进兵！",
}
_tab_stringM["$404_xqlj_02"] = {
	"@L1:18018@公瑾，还好有你！",
}
------------------------
--决战黄祖
_tab_stringM["$405_jzhz_01"] = {
	"@L1:18019@伯符，对岸的箭塔对我们威胁太大了，必须压制住他们！",
	"@L1:18018@没问题！这次我带了足够多的物资。",
}
_tab_stringM["$405_jzhz_02"] = {
	"@L1:18018@哼！还是让他跑了！",
}
------------------------
--狩猎
_tab_stringM["$406_sl_01"] = {
	"@L1:18018@好久没出来打猎了，今日天气凉爽，正好游猎一番！",
}
_tab_stringM["$406_sl_02"] = {
	"@L1:18019@伯符！你没事吧！",
	"@L1:18018@区区小伤……呃……何足挂齿！",
}









-----------------------------------------------------------------
--平定会稽
_tab_stringM["$407_pdkj_01"] = {
	"@L1:14323@那孙策在我寨附近扎营，是可忍，孰不可忍！",
	"@L1:18018@很好，那虞翻果然中计！",
}

_tab_stringM["$407_pdkj_02"] = {
	"@L1:14323@哼！既然被捉，要杀要剐悉听尊便！",
	"@L1:18018@你若归降我军，便绕你一条性命！",
}

--跃马檀溪
_tab_stringM["$408_ymtx_01"] = {
	"@L1:18001@没想到这蔡瑁竟摆鸿门宴加害于我！现在半路出城一定会有所阻扰，还得万加小心！",
	"@L1:14328@刘备！我好心摆宴席请你，你为何不来？！还是另有所图？！给我抓起来！",
}

_tab_stringM["$408_ymtx_02"] = {
	"@L1:18001@真是好险，这蔡瑁用心险恶，却不知是否是那刘表下的令？",
}
--智破八门
_tab_stringM["$409_zpbm_01"] = {
	"@L1:18001@这曹仁把我等引入这奇石乱阵之中，我军走了三天也无法出去该如何是好？",
	"@L1:18020@此等残阵不足挂齿！",
	"@L1:18001@先生是何人?",
	"@L1:18020@吾乃颍川之士，此阵乃是残缺的八门金锁阵，只需将敌人拒之阵眼即可。",
}

_tab_stringM["$409_zpbm_02"] = {
	"@L1:14336@可恶，竟能破这八门金锁阵！此人定是不凡！",
}

--卧龙出山
_tab_stringM["$410_wlcs_01"] = {
	"@L1:18021@若是出山也不是不可，但先把这附近一带的隐患清除。",
	"@L1:18001@是何隐患，让孔明如此谨慎？",
	"@L1:18021@天已渐冷，山中的山贼活动越是频繁，还有劳各位了。",
}
_tab_stringM["$410_wlcs_02"] = {
	"@L1:18021@隐患已除，还多谢各位的相助，孔明愿随刘皇叔匡扶汉室。",
}

--火烧博望
_tab_stringM["$411_hsbw_01"] = {
	"@R1:18021@二位将军请按我的计策行事，主公剑印在此，违令者斩！",
	"@L1:18003@孔明这么年轻，能有什么才学。",
	"@R1:18002@我们且看他的计应也不应，到时再拿他是问也不迟。",
}

_tab_stringM["$411_hsbw_02"] = {
	"@R1:18002@想不到能取得如此大胜。",
	"@L1:18003@孔明真英杰也！",
}

--长坂坡
_tab_stringM["$412_cbp_01"] = {
	"@L1:18008@主公将二位夫人和小主人托付于我，现在却又走散，一定要寻得他们下落！",
}

_tab_stringM["$412_cbp_02"] = {
	"@L1:18021@曹军已退，如今先去江夏暂歇，再议往后之事。",
}


--临江水战
_tab_stringM["$413_ljsz_01"] = {
	"@L1:18018@黄祖从水路派了部下来阻拦，今天就让他知道我们的厉害。",
}

_tab_stringM["$413_ljsz_02"] = {
	"@L1:18018@就凭这种人还想挡住我们，简直是痴心妄想。",
}

--草船借箭
_tab_stringM["$414_ccjj_01"] = {
	"@L1:14101@",
	"@L1:鲁肃@公召我来何意？",
	"@R1:18021@特请子敬同往取箭。",
}

_tab_stringM["$414_ccjj_02"] = {
	"@R1:18021@谢丞相箭！",
	"@L1:18005@唉！又中了这诸葛亮的计也。",
}

--借东风
_tab_stringM["$415_jdf_01"] = {
	"@L1:18021@请诸位保护好在下，在下这就施法借来东风！",
}

_tab_stringM["$415_jdf_02"] = {
	"@L1:18021@好！大功告成！东风将至！",
}

--赤壁之战
_tab_stringM["$416_cbzz_01"] = {
	"@L1:18019@曹贼，今天就是你的死期！",
	"@R1:18005@没想到竟中了这周瑜小儿的计！快，把战船开出来！",
}

_tab_stringM["$416_cbzz_02"] = {
	"@R1:18005@唉！大势已去，必须要撤退了。",
}


--汉中争夺战
_tab_stringM["$505_hzzdz_01"] = {
	"@L1:12101@曹公，汉中已归蜀地，不如就此退兵共谋大计？",
	"@R1:18005@诶！不是我不愿，是我这万载的将士们不愿退去，不如将汉中让出，我等再谋大计？",
	"【提示】本关需要击败敌方刘备才能胜利。",
}

_tab_stringM["$505_hzzdz_02"] = {
	"@R1:12101@唉！大势已去，必须要撤退了。",
}

--水淹七军
_tab_stringM["$506_syqj_01"] = {
	"@L1:12102@哼哼..你看看这些人的惨样，今日一战日后必成佳话！",
}

_tab_stringM["$506_syqj_02"] = {
	"@R1:12102@这等绝境之下，竟能无懈可击！快撤！",
}


--长安守卫战
_tab_stringM["$501_caswz_01"] = {
	"@R1:22036@西凉军快来了，诸位需尽力防守！",
	"@L1:0@【提示：将英雄移动到驻守点，使其驻守在此处，并大幅增强驻守英雄的能力。】",
}

_tab_stringM["$501_caswz_02"] = {
	"@R1:22036@西凉军的主力部队快到了，我们必须撤退！",
}
--割须弃袍
_tab_stringM["$502_gxqp_01"] = {
	"@R1:18033@长胡子的是曹操，快抓住他！",
}

_tab_stringM["$502_gxqp_02"] = {
	"@R1:18005@还好有曹洪，不然今天死在马超手里！",
}
--冰城
_tab_stringM["$503_zzbc_01"] = {
	"@R1:18005@幸好有先生为我指点迷津，不知该如何报答！",
	"@L1:14200@",
	"@L1:娄子伯@区区小计，何足挂齿，只希望丞相能早日平定天下，让百姓脱离战乱之苦。",
}

_tab_stringM["$503_zzbc_02"] = {
	"@R1:18028@军士来报，孙权想要起兵犯合淝，丞相何不早作打算？",
	"@R1:18005@此事我已知晓，此间事一了，我便会率军前去援助。",
}
--逍遥津
_tab_stringM["$504_dzxyj_01"] = {
	"@R1:22033@将军弃我乎！",
	"@R1:18014@尔等随我前去营救！",
}

_tab_stringM["$504_dzxyj_02"] = {
	"@R1:18014@多亏诸位鼎力相助，才有今日之胜！",
	"@R1:22047@哈哈！这下孙权怕是要被吓破胆了！",
	"@R1:22046@今日东吴虽然大败，孙权必定不甘心，恐怕还会去而复返。",
	"@R1:18014@嗯，丞相大军就快到了，在此之前，我等还不可松懈！",
}

--古墓试炼
_tab_stringM["$504_2_gmsl_01"] = {
	"@R1:18014@没想到此地竟有如此宏伟的墓地，实在叹为观止。",
	"@R1:18014@有动静！",
	"@R1:18028@唔，不好！我等此番必是惊动了墓地的主人，诸位小心！",
}

_tab_stringM["$504_2_gmsl_02"] = {
	"@R1:18014@还好我们守住了，若是让这些魔物出了墓地，必定为祸人间！",
}

--八阵图
_tab_stringM["$509_bzt_01"] = {
	"@R1:16023@",
	"@R1:黄承彦@将军可守住阵眼，再派将士守住生门，待到酉时一过便可出阵了。",
	"@R1:18035@多谢先生指点。",
}

_tab_stringM["$509_bzt_02"] = {
	"@R1:18035@诸葛孔明果真是旷世奇才，我不如也。",
	"@R1:18035@传令各部，即刻退兵！",
	"@R1:14729@",
	"@R1:部将@蜀军人困马乏，正好趁势追击，为何见了此阵便要退却？",
	"@R1:18035@我不是真的怕了这八阵图，只是怕曹丕趁虚而入，攻打江东。",
}
-----------------------------------------------------------------


--吕布传剧情
_tab_stringM["$dlc_50_1_01"] = {
	"@L1:18011@……",
	"@R1:15038@啧啧啧……没想到天下无双的吕布，竟然落魄至此。",
	"@L1:18011@什么人！",
	"@L1:0@【提示：协助部下逃脱，并守住路口，不让敌兵通过】",
}
_tab_stringM["$dlc_50_1_02"] = {
	"@R1:18012@没想到还能见到将军！",
	"@R1:18011@貂蝉……",
	"@R1:18011@我们走吧！",
}


_tab_stringM["$dlc_50_2_01"] = {
	"@L1:18001@吕布！这里是大汉的土地，岂容你这贼寇踏足！",
	"@R1:18011@又是你们三个！",
	"@R1:18003@哈哈哈，又可以大战一场了！",
	"@R1:18011@放马过来吧，我吕布岂会怕你们！",
}
_tab_stringM["$dlc_50_2_02"] = {
	"@R1:18011@哼！逃得倒是挺快！",
}

_tab_stringM["$dlc_50_3_01"] = {
	"@L1:18011@先在这里安营，曹军应该没这么快到。",
	"@R1:14101@将军不可大意！这曹操向来诡计多端。",
}
_tab_stringM["$dlc_50_3_02"] = {
	"@L1:14102@将军有什么打算？",
	"@L1:18011@向西，能走多远走多远吧！",
}

_tab_stringM["$dlc_50_4_01"] = {
	"@R1:14102@将军，前面的路已经让曹军封锁了！",
	"@R1:18011@那就把它撕开！",
	"@L1:0@【提示：击破双龙塔才能获得胜利！】",
	"@L1:0@【提示：点击己方据点，可购买部队进攻双龙塔！】",
}

_tab_stringM["$dlc_50_4_02"] = {
	"@R1:18011@好大的风沙！",
	"@R1:18011@前路万分凶险，貂蝉，你还想跟着我吗？",
	"@R1:18012@将军，长路漫漫，让我们一起走吧！",
}




--月英传剧情
--关卡1
_tab_stringM["$dlc_60_1_01"] = {
	"@L1:39091@老人家，听说这里有妖魔作乱？",
	"@R1:16023@可不是，魔头正占着村子不走呢！",
	"@L1:39091@看来果然是真的！",
}
_tab_stringM["$dlc_60_1_02"] = {
	"@R1:15917@怎么可能！",
	"@L1:39091@好厉害，这绝对不是普通的妖魔！",
	"@L1:16023@姑娘你可真是厉害啊！不过魔头不止这一个，前面山谷中还藏着好几个魔头，姑娘你一走，我们可就遭殃了！",
	"@L1:39091@老人家不用担心，我去会他们一会！",
}

--关卡2
_tab_stringM["$dlc_60_2_01"] = {
	"@L1:39091@这里妖气弥漫，果然是有妖魔聚集！",
}
_tab_stringM["$dlc_60_2_02"] = {
	"@R1:15901@你区区一个凡人，竟敢……啊！",
	"@L1:39091@……！",
	"@L1:39091@（似乎有什么不对劲的地方！）",
}

--关卡3
_tab_stringM["$dlc_60_3_01"] = {
	"@L1:39091@好多荆棘，得想办法过去！",
	"@R1:16023@姑娘，前几日老朽亲眼见过用魔头法术破除荆棘，想必是带着破除荆棘的法宝！",
	"@L1:39091@多谢大伯提醒！",
}
_tab_stringM["$dlc_60_3_02"] = {
	"@R1:15909@你究竟是……什么人，呃啊！",
	"@L1:39091@（为什么有种奇怪的感觉，到底是怎么回事！）",
}

_tab_stringM["$dlc_60_4_01"] = {
	"@L1:39091@这里就是他们的巢穴了吧，我一定要找出真相！",
	"@R1:15910@终于来了吗？我在墓穴的尽头等着你，哈哈哈哈！",
	"@L1:39091@……",
}
_tab_stringM["$dlc_60_4_02"] = {
	"@R1:15910@哼！愚蠢的凡人，知道你杀的都是什么人吗？",
	"@L1:39091@到底是怎么回事！",
	"@R1:15910@告诉你也无妨，他们都是天界的神将，而你，才是那个屠戮天神的大魔头啊！哈哈哈哈！",
	"@L1:39091@怎么会！你又是谁？",
	"@L1:39091@消失了……",
}



--孙尚香传剧情
--关卡1--奇袭
_tab_stringM["$dlc_70_1_01"] = {
	"@L1:14520@小妹，不如我们来比一比谁猎取的野兽多！",
	"@R1:18031@比就比，怕你不成！",
}
_tab_stringM["$dlc_70_1_02"] = {
	"@L1:14520@好厉害的魔物，此地不可久留！",
	"@L1:39088@年轻人，请等一下！",
	"@L1:39088@这个洞内藏有仙界的至宝【天关塔诀】，只是里面机关众多，取之不易！",
	"@L1:39088@但若你能取得此物，说不定便能平息天下的纷争……",
	"@R1:18031@好啊，就让我去见识下！",
	"@L1:14520@哎，小妹，等一下！",

}

--关卡2
_tab_stringM["$dlc_70_2_01"] = {
	"@L1:39088@我的法力只能将你带到这鬼谷幻境的入口，这里布满了重重机关，切记小心行事！",
	"@R1:18031@你就放心吧，大伯！",
}
_tab_stringM["$dlc_70_2_02"] = {
	"@L1:39088@我已助你们获得此宝，也算功德圆满，接下来的事要看你们自己了。",
	"@R1:14520@多谢仙尊相助！我定会好好使用它，不辜负仙尊重托！",
}

--关卡3
_tab_stringM["$dlc_70_3_01"] = {
	"@R1:18031@老将军您快点啊！",
	"@L1:15963@郡主慢点走，老夫实在跟不上你了。",
}
_tab_stringM["$dlc_70_3_02"] = {
	"@R1:18031@哈哈！胜利！",
	"@L1:15963@郡主真是好武艺！剩下的杂兵就交给老夫吧！",
}

_tab_stringM["$dlc_70_4_01"] = {
	"@R1:18031@快跟上，你们太慢了！",
	"@R1:18001@没想到与我一起前来的会是郡主殿下，刘某真是三生有幸！",
}
_tab_stringM["$dlc_70_4_02"] = {
	"@L1:18001@郡主小心！",
	"@L1:0@咔！",
	"@R1:18031@荒什么，我看着呢！",
	"@L1:18001@厉害！郡主武艺远胜刘某！那个……那个啥……",
	"@R1:18031@哼！一个大男人磨磨唧唧的，真是个大猪蹄子！",
}





---------------新手引导对话-------------

_tab_stringM["$_001_jx_01"] = {
	"@L1:39088@我的法力只能将你带到这鬼谷幻境的入口，这里布满了重重机关，切记小心行事！",
	"@R1:18031@你就放心吧，大伯！",
}
	
_tab_stringM["$_002_jx_01"] = {
	"@L1:39087@有人闯入，快开启幻境机关，阻止盗宝人通过！",
	"@R1:18031@看来这老人家说的是真的！",
}

_tab_stringM["$_003_jx_01"] = {
	"【天关塔诀】就在下一层，请尽快前往。",
}

_tab_stringM["$_004_jx_01"] = {
	"@R1:18031@终于到手了！很简单嘛，哈哈！",
	"@R1:14520@别大意！附近还有敌人！",
	"@L1:39088@秘境守卫已经派出大军试图夺回宝物！你们快用宝物的能力击退他们！",
}

_tab_stringM["$_005_jx_01"] = {
	"@L1:39088@我已助你们获得此宝，也算功德圆满，接下来的事要看你们自己了。",
	"@R1:14520@多谢仙尊相助！我定会好好使用它，不辜负仙尊重托！",
}

_tab_stringM["$_006_jx_01"] = {
	"@L1:39088@敌人的力量还是挺强大的，切记小心防守。",
	"@R1:39089@仙尊莫急，云长会继续努力，定要拿到【天关塔诀】。",
	"@R1:0@",
	"@L1:0@【提示：注意各种塔之间的搭配，只有狙击塔和黄月英才能攻击空中单位】",
}

_tab_stringM["$_007_jx_01"] = {
	"@R1:39089@仙尊过奖，云长定会倾力而为，帮助月英带出【天关塔诀】。",
	"@L1:39091@久仰将军威名，能与将军一同携手此战，三生有幸。",
	"@L1:39088@现在就可以运用《天关塔诀》中的秘术来建造防御塔，保护它不被夺回！其中玄妙之处还有待你们自行领悟!",
	"@R1:0@",
	"@L1:0@【提示：进入多英雄塔防模式，英雄不再处于持续选中状态】",
}


---------------------第二关--------------------------
_tab_stringM["$_001_yxcsg_01"] = {
	"@L1:0@东汉末年，宦官专权，民不聊生。走投无路的贫苦百姓，在张角的号令下，头扎黄巾，揭竿而起。",
	"@L1:18001@大丈夫处世，当努力建功立业。",
	"@R1:18003@这位壮士，俺也愿与你共同干一番事业！",
}

_tab_stringM["$_001_yxcsg_02"] = {
	"@R1:16023@刘大人！不好了，涿郡突然涌现黄巾军！",
	"@L1:18003@别怕，我们定保护村民安全！",
	}


--=============================================================================================--




_tab_stringU[1] = {"英雄", "英雄"}
_tab_stringU[14] = {"上帝", "上帝"}
_tab_stringU[17] = {"船","载人用的木船。"}

_tab_stringU[4900] = {"游戏助理小昭","策马守天关，游戏小助手。"}
_tab_stringU[4901] = {"小昭","策马守天关，游戏小助手。"}
_tab_stringU[4902] = {"英雄无敌","首通奖励。"}
_tab_stringU[4999] = {"替换用英雄","虽然长得像刘备，但他只是用来被替换的。"}





_tab_stringU[9999] = {"终点", "终点"}

--箭塔
_tab_stringU[10001] = {"初级箭塔", "物理系单体攻击塔。每次攻击射出一根箭矢命中目标。攻速快，射程远。"}
_tab_stringU[10002] = {"中级箭塔", "经过升级后的箭塔，属性得到了全面加强。"}

--剧毒塔
_tab_stringU[10011] = {"剧毒塔", "射出毒箭，每秒造成攻击力60％的真实伤害，持续5秒。"}
_tab_stringU[10012] = {"剧毒塔", "射出毒箭，每秒造成攻击力60％的真实伤害，持续5秒。"}
_tab_stringU[10013] = {"剧毒塔", "射出毒箭，每秒造成攻击力60％的真实伤害，持续5秒。"}
_tab_stringU[10014] = {"剧毒塔", "射出毒箭，每秒造成攻击力60％的真实伤害，持续5秒。"}
_tab_stringU[10015] = {"剧毒塔", "射出毒箭，每秒造成攻击力60％的真实伤害，持续5秒。"}
_tab_stringU[10016] = {"剧毒塔", "射出毒箭，每秒造成攻击力60％的真实伤害，持续5秒。"}
_tab_stringU[10017] = {"剧毒塔", "射出毒箭，每秒造成攻击力60％的真实伤害，持续5秒。"}
_tab_stringU[10018] = {"剧毒塔", "射出毒箭，每秒造成攻击力60％的真实伤害，持续5秒。"}
_tab_stringU[10019] = {"剧毒塔", "射出毒箭，每秒造成攻击力60％的真实伤害，持续5秒。"}
_tab_stringU[10020] = {"剧毒塔", "射出毒箭，每秒造成目标最大生命值2％的真实伤害，持续4秒。"} --竞技场用的

--炮塔
_tab_stringU[10101] = {"初级炮塔", "物理系范围伤害塔。每次攻击发出一个炮弹，炮弹落地后对55范围内地面上的敌人造成物理伤害。"}
_tab_stringU[10102] = {"中级炮塔", "经过升级后的炮塔，属性得到了全面加强。"}

--巨炮塔
_tab_stringU[10111] = {"巨炮塔", "经过改造后的巨型炮塔，每次攻击发射一颗威力巨大的炮弹。",}
_tab_stringU[10112] = {"巨炮塔", "经过改造后的巨型炮塔，每次攻击发射一颗威力巨大的炮弹。",}
_tab_stringU[10113] = {"巨炮塔", "经过改造后的巨型炮塔，每次攻击发射一颗威力巨大的炮弹。",}
_tab_stringU[10114] = {"巨炮塔", "经过改造后的巨型炮塔，每次攻击发射一颗威力巨大的炮弹。",}
_tab_stringU[10115] = {"巨炮塔", "经过改造后的巨型炮塔，每次攻击发射一颗威力巨大的炮弹。",}
_tab_stringU[10116] = {"巨炮塔", "经过改造后的巨型炮塔，每次攻击发射一颗威力巨大的炮弹。",}
_tab_stringU[10117] = {"巨炮塔", "经过改造后的巨型炮塔，每次攻击发射一颗威力巨大的炮弹。",}
_tab_stringU[10118] = {"巨炮塔", "经过改造后的巨型炮塔，每次攻击发射一颗威力巨大的炮弹。",}
_tab_stringU[10119] = {"巨炮塔", "经过改造后的巨型炮塔，每次攻击发射一颗威力巨大的炮弹。",}
_tab_stringU[10120] = {"巨炮塔", "经过改造后的巨型炮塔，每次攻击发射一颗威力巨大的炮弹。",}



--轰天塔
_tab_stringU[10131] = {"轰天塔", "每次发射出4颗散弹。但无法瞄准靠得太近的目标。"}
_tab_stringU[10132] = {"轰天塔", "每次发射出4颗散弹。但无法瞄准靠得太近的目标。"}
_tab_stringU[10133] = {"轰天塔", "每次发射出4颗散弹。但无法瞄准靠得太近的目标。"}
_tab_stringU[10134] = {"轰天塔", "每次发射出4颗散弹。但无法瞄准靠得太近的目标。"}
_tab_stringU[10135] = {"轰天塔", "每次发射出4颗散弹。但无法瞄准靠得太近的目标。"}
_tab_stringU[10136] = {"轰天塔", "每次发射出4颗散弹。但无法瞄准靠得太近的目标。"}
_tab_stringU[10137] = {"轰天塔", "每次发射出4颗散弹。但无法瞄准靠得太近的目标。"}
_tab_stringU[10138] = {"轰天塔", "每次发射出4颗散弹。但无法瞄准靠得太近的目标。"}
_tab_stringU[10139] = {"轰天塔", "每次发射出4颗散弹。但无法瞄准靠得太近的目标。"}
_tab_stringU[10140] = {"轰天塔", "每次发射出4颗散弹。但无法瞄准靠得太近的目标。"}



--滚石塔
_tab_stringU[10121] = {"滚石塔", "每次攻击发出一块巨石滚向前方，对地面上的敌人造成伤害。"}
_tab_stringU[10122] = {"滚石塔", "每次攻击发出一块巨石滚向前方，对地面上的敌人造成伤害。"}
_tab_stringU[10123] = {"滚石塔", "每次攻击发出一块巨石滚向前方，对地面上的敌人造成伤害。"}
_tab_stringU[10124] = {"滚石塔", "每次攻击发出一块巨石滚向前方，对地面上的敌人造成伤害。"}
_tab_stringU[10125] = {"滚石塔", "每次攻击发出一块巨石滚向前方，对地面上的敌人造成伤害。"}
_tab_stringU[10126] = {"滚石塔", "每次攻击发出一块巨石滚向前方，对地面上的敌人造成伤害。"}
_tab_stringU[10127] = {"滚石塔", "每次攻击发出一块巨石滚向前方，对地面上的敌人造成伤害。"}
_tab_stringU[10128] = {"滚石塔", "每次攻击发出一块巨石滚向前方，对地面上的敌人造成伤害。"}
_tab_stringU[10129] = {"滚石塔", "每次攻击发出一块巨石滚向前方，对地面上的敌人造成伤害。"}
_tab_stringU[10130] = {"滚石塔", "每次攻击发出一块巨石滚向前方，对地面上的敌人造成伤害。"}




--法术塔
_tab_stringU[10201] = {"初级法术塔", "法术系单体攻击塔。每次攻击发出一个魔法水晶命中目标。伤害高。"}
_tab_stringU[10202] = {"中级法术塔", "经过升级后的法术塔，属性得到了全面加强。"}

--火焰塔
_tab_stringU[10203] = {"火焰塔", "每次攻击同时发射两个火球。"}
_tab_stringU[10204] = {"火焰塔", "每次攻击同时发射两个火球。"}
_tab_stringU[10205] = {"火焰塔", "每次攻击同时发射两个火球。"}
_tab_stringU[10206] = {"火焰塔", "每次攻击同时发射两个火球。"}
_tab_stringU[10207] = {"火焰塔", "每次攻击同时发射两个火球。"}
_tab_stringU[10208] = {"火焰塔", "每次攻击同时发射两个火球。"}
_tab_stringU[10209] = {"火焰塔", "每次攻击同时发射两个火球。"}
_tab_stringU[10210] = {"火焰塔", "每次攻击同时发射两个火球。"}
_tab_stringU[10211] = {"火焰塔", "每次攻击同时发射两个火球。"}
_tab_stringU[10212] = {"火焰塔", "每次攻击同时发射两个火球。"}



--连弩塔
_tab_stringU[10301] = {"连弩塔", "每次攻击有10％的几率连射出3支弩箭。"}
_tab_stringU[10302] = {"连弩塔", "每次攻击有10％的几率连射出3支弩箭。"}
_tab_stringU[10303] = {"连弩塔", "每次攻击有10％的几率连射出3支弩箭。"}
_tab_stringU[10304] = {"连弩塔", "每次攻击有10％的几率连射出3支弩箭。"}
_tab_stringU[10305] = {"连弩塔", "每次攻击有10％的几率连射出3支弩箭。"}
_tab_stringU[10306] = {"连弩塔", "每次攻击有10％的几率连射出3支弩箭。"}
_tab_stringU[10307] = {"连弩塔", "每次攻击有10％的几率连射出3支弩箭。"}
_tab_stringU[10308] = {"连弩塔", "每次攻击有10％的几率连射出3支弩箭。"}
_tab_stringU[10309] = {"连弩塔", "每次攻击有10％的几率连射出3支弩箭。"}
_tab_stringU[10310] = {"连弩塔", "每次攻击有10％的几率连射出3支弩箭。"}

--寒冰塔
_tab_stringU[10401] = {"寒冰塔", "每次攻击附带减速，降低目标40％的移动速度，持续4秒。"}
_tab_stringU[10402] = {"寒冰塔", "每次攻击附带减速，降低目标42％的移动速度，持续4秒。"}
_tab_stringU[10403] = {"寒冰塔", "每次攻击附带减速，降低目标44％的移动速度，持续4秒。"}
_tab_stringU[10404] = {"寒冰塔", "每次攻击附带减速，降低目标46％的移动速度，持续4秒。"}
_tab_stringU[10405] = {"寒冰塔", "每次攻击附带减速，降低目标48％的移动速度，持续4秒。"}
_tab_stringU[10406] = {"寒冰塔", "每次攻击附带减速，降低目标50％的移动速度，持续4秒。"}
_tab_stringU[10407] = {"寒冰塔", "每次攻击附带减速，降低目标52％的移动速度，持续4秒。"}
_tab_stringU[10408] = {"寒冰塔", "每次攻击附带减速，降低目标54％的移动速度，持续4秒。"}
_tab_stringU[10409] = {"寒冰塔", "每次攻击附带减速，降低目标56％的移动速度，持续4秒。"}
_tab_stringU[10410] = {"寒冰塔", "每次攻击附带减速，降低目标58％的移动速度，持续4秒。"}

--天雷塔
_tab_stringU[10501] = {"天雷塔", "每次攻击释放电弧，电晕目标0.2秒。（主将除外）"}
_tab_stringU[10502] = {"天雷塔", "每次攻击释放电弧，电晕目标0.2秒。（主将除外）"}
_tab_stringU[10503] = {"天雷塔", "每次攻击释放电弧，电晕目标0.2秒。（主将除外）"}
_tab_stringU[10504] = {"天雷塔", "每次攻击释放电弧，电晕目标0.2秒。（主将除外）"}
_tab_stringU[10505] = {"天雷塔", "每次攻击释放电弧，电晕目标0.2秒。（主将除外）"}
_tab_stringU[10506] = {"天雷塔", "每次攻击释放电弧，电晕目标0.2秒。（主将除外）"}
_tab_stringU[10507] = {"天雷塔", "每次攻击释放电弧，电晕目标0.2秒。（主将除外）"}
_tab_stringU[10508] = {"天雷塔", "每次攻击释放电弧，电晕目标0.2秒。（主将除外）"}
_tab_stringU[10509] = {"天雷塔", "每次攻击释放电弧，电晕目标0.2秒。（主将除外）"}
_tab_stringU[10510] = {"天雷塔", "每次攻击释放电弧，电晕目标0.2秒。（主将除外）"}

--狙击塔
_tab_stringU[10601] = {"狙击塔", "攻速很慢，但是攻击力超高、射程超远的箭塔。"}
_tab_stringU[10602] = {"狙击塔", "攻速很慢，但是攻击力超高、射程超远的箭塔。"}
_tab_stringU[10603] = {"狙击塔", "攻速很慢，但是攻击力超高、射程超远的箭塔。"}
_tab_stringU[10604] = {"狙击塔", "攻速很慢，但是攻击力超高、射程超远的箭塔。"}
_tab_stringU[10605] = {"狙击塔", "攻速很慢，但是攻击力超高、射程超远的箭塔。"}
_tab_stringU[10606] = {"狙击塔", "攻速很慢，但是攻击力超高、射程超远的箭塔。"}
_tab_stringU[10607] = {"狙击塔", "攻速很慢，但是攻击力超高、射程超远的箭塔。"}
_tab_stringU[10608] = {"狙击塔", "攻速很慢，但是攻击力超高、射程超远的箭塔。"}
_tab_stringU[10609] = {"狙击塔", "攻速很慢，但是攻击力超高、射程超远的箭塔。"}
_tab_stringU[10610] = {"狙击塔", "攻速很慢，但是攻击力超高、射程超远的箭塔。"}



--中级特种塔
_tab_stringU[10700] = {"中级特种塔", "经过升级后的特种塔，属性得到了全面加强。"}
--粮仓
_tab_stringU[10701] = {"粮仓", "没有攻击力。但是每秒可以产出1金。"}
_tab_stringU[10702] = {"粮仓", "没有攻击力。但是每秒可以产出1金。"}
_tab_stringU[10703] = {"粮仓", "没有攻击力。但是每秒可以产出1金。"}
_tab_stringU[10704] = {"粮仓", "没有攻击力。但是每秒可以产出1金。"}
_tab_stringU[10705] = {"粮仓", "没有攻击力。但是每秒可以产出1金。"}
_tab_stringU[10706] = {"粮仓", "没有攻击力。但是每秒可以产出1金。"}
_tab_stringU[10707] = {"粮仓", "没有攻击力。但是每秒可以产出1金。"}
_tab_stringU[10708] = {"粮仓", "没有攻击力。但是每秒可以产出1金。"}
_tab_stringU[10709] = {"粮仓", "没有攻击力。但是每秒可以产出1金。"}
_tab_stringU[10710] = {"粮仓", "没有攻击力。但是每秒可以产出1金。"}

_tab_stringU[11000] = {"PVP-据点（蜀国）", "PVP-据点（蜀国）"}
_tab_stringU[11001] = {"PVP-基础兵营", "PVP模式中最基础的兵营"}
_tab_stringU[11002] = {"PVP-步兵营", "PVP模式中的步兵营"}
_tab_stringU[11003] = {"PVP-弓兵营", "PVP模式中的弓兵营"}
_tab_stringU[11004] = {"PVP-骑兵营", "PVP模式中的骑兵营"}
_tab_stringU[11005] = {"PVP-据点（魏国）", "PVP-据点（魏国）"}
_tab_stringU[11006] = {"PVP-粮仓", "PVP-粮仓"}
_tab_stringU[11007] = {"PVP-塔基", "PVP-塔基"}


_tab_stringU[11101] = {"朴刀兵", "朴刀兵"}
_tab_stringU[11102] = {"弓箭手", "弓箭手"}
_tab_stringU[11103] = {"陷阵兵", "陷阵兵"}
_tab_stringU[11104] = {"百夫长", "百夫长"}
_tab_stringU[11105] = {"飞熊军", "飞熊军"}
_tab_stringU[11106] = {"飞熊军2", "飞熊军2"}
_tab_stringU[11107] = {"投石车", "投石车"}



_tab_stringU[12101] = {"刘备", "三国时期蜀汉开国皇帝，与关羽、张飞结为兄弟。"}
_tab_stringU[12102] = {"关羽", "三国时期蜀汉重要将领，与刘备，张飞结为兄弟。"}
_tab_stringU[12103] = {"张飞", "三国时期蜀汉重要将领，与刘备，关羽结为兄弟。"}
_tab_stringU[12104] = {"曹操","三国时期曹魏政权的缔造者，在政治、军事、文学上都有很高造诣。"}
_tab_stringU[12105] = {"太史慈","刘繇部下，后被孙策收降，助其扫荡江东。"}

_tab_stringU[13997] = {"无尽地图敌方超级连弩塔", "无尽地图敌方超级连弩塔"}
_tab_stringU[13999] = {"点火点", "点火点"}
_tab_stringU[14000] = {"测试单位", "测试单位"}


_tab_stringU[14001] = {"黄巾流寇", "最普通的黄巾小喽喽，大部分都是饥民出身，所以饿的精瘦精瘦的。"}
_tab_stringU[14002] = {"幼狼", "群居于山上的野狼，行动迅速。"}
_tab_stringU[14003] = {"黄巾头目", "黄巾军的小头目。提着一把大环刀，看上去很有气势。"}
_tab_stringU[14004] = {"巨狼", "强壮且高大的狼，没有人可以降服他。"}
_tab_stringU[14005] = {"祸斗", "具有神兽血统的双头狼，有控制火的能力。一个头会喷射火球，另一个头会点燃地面。"}
_tab_stringU[14006] = {"黄巾弓手", "手持短弓的流寇，虽会使弓，可惜射术不精。"}
_tab_stringU[14007] = {"邓茂", "使一把劲弩，擅长连射。虽然是大兴山二把手，抢人头的能力却是第一。"}
_tab_stringU[14008] = {"程远志", "高头大马，武艺非凡，喜欢对自认为有实力的人出手。口头禅是“中单，不给就送！”"}
_tab_stringU[14009] = {"黄巾力士", "身高八尺，腰围也是八尺。手持一把板斧，能轻易撕碎靠近的敌人。"}
_tab_stringU[14010] = {"速狼", "有着狼王直系血统的狼。速度奇快。用一般的手段没办法伤到它们。"}
_tab_stringU[14011] = {"招狼者", "养着众多狼崽。当危险来临时，便放出狼崽对付敌人。"}
_tab_stringU[14012] = {"黄巾术士", "得到张角传授的一些法术的皮毛。对于狂热的信众来说，他们是神仙一般的人物。"}
_tab_stringU[14013] = {"黄巾骑兵", "担任着黄巾军中冲锋陷阵的角色。可惜数量实在太少了。"}
_tab_stringU[14014] = {"黄巾旗手", "扛着黄巾军旗帜的头目。通常他的出现意味着大量黄巾流寇的到来。"}
_tab_stringU[14015] = {"双头狼", "祸斗的后代。当上一代的祸斗死亡后，只有一头会成为新的祸斗，而其他的都会被它咬死。"}
_tab_stringU[14016] = {"黄巾狂徒", "张角手下狂热的信徒。行动迅速，且对物理攻击有闪避能力。不过对法术却没有抵抗力。"}
_tab_stringU[14017] = {"黑羽", "黑羽简介"}
_tab_stringU[14018] = {"管亥", "东汉末年黄巾起义军的将领。曾率军围攻孔融。"}
_tab_stringU[14019] = {"波才", "黄巾高级将领。也只有他才能降服速狼。虽然自身武艺也不俗，不过他的狼更可怕。"}

_tab_stringU[14020] = {"朴刀兵", "手持朴刀作战。是战场上最普通的士兵。"}
_tab_stringU[14021] = {"弓箭手", "使用长弓进行远程射击的士兵。被人近身后便没什么战斗力了。"}
_tab_stringU[14022] = {"精锐刀兵", "配备了护具的刀兵。比普通的朴刀兵要强大得多。"}
_tab_stringU[14023] = {"精锐骑兵", "具有很强的冲击力。能轻易冲破防线。"}
_tab_stringU[14024] = {"百夫长", "管理百人的下级军官。身经百战，具有很强的战斗力。"}
_tab_stringU[14025] = {"陷阵兵", "名将高顺所率领的一支特殊作战兵种。行动迅捷，会躲闪物理攻击，还会暴击，战斗力十分强大。"}
_tab_stringU[14026] = {"华雄", "身长九尺，虎体狼腰，豹头猿臂。是董卓手下的虎将。"}
_tab_stringU[14027] = {"爆弹兵", "使用炸弹进行远程攻击，能对一个小范围造成伤害，但是常常打不中人。"}
_tab_stringU[14028] = {"歌妓", "军中的歌妓。以动人的歌声和曼妙的舞姿来鼓励前方的将士。"}
_tab_stringU[14029] = {"高顺", "吕布手下的猛将。所率部队被称为陷阵营。"}
_tab_stringU[14030] = {"吕布", "坐骑赤兔宝马，手持方天画戟，天下无双。被誉为三国第一猛将。"}
_tab_stringU[14031] = {"凤凰", "凤凰简介"}
_tab_stringU[14032] = {"飞熊军", "董卓的私人精锐部队。旗帜上绣有肋生双翅的飞熊图案。"}
_tab_stringU[14033] = {"李傕", "董卓手下。凉州系心腹大将。"}
_tab_stringU[14034] = {"郭汜", "董卓手下大将。以善于用兵而闻名。"}
_tab_stringU[14035] = {"胡车儿", "张绣麾下的猛将。以勇武著称。"}
_tab_stringU[14036] = {"李儒", "董卓的女婿、首席谋士。为董卓所亲信，大小事宜均与之参谋。"}
_tab_stringU[14037] = {"董卓", "东汉末年凉州军阀。掌控朝中大权。"}
_tab_stringU[14038] = {"管亥", "东汉末年黄巾起义军的将领。曾率军围攻孔融。"}
_tab_stringU[14039] = {"管亥亲卫队", "管亥手下的一支精锐骑兵。"}
_tab_stringU[14040] = {"贾诩", "三国时著名谋士，被人称为毒士。后官至太尉，谥曰肃侯。"}

_tab_stringU[14041] = {"张绣", "东汉末年地方豪强之一。枪法卓越，武艺高强。"}
_tab_stringU[14042] = {"吕布", "坐骑赤兔宝马，手持方天画戟，天下无双，被誉为三国第一猛将。"}
_tab_stringU[14043] = {"张辽", "曹魏五子良将之一，智勇双全。原属吕布，后投曹操，从此南征北伐。"}
_tab_stringU[14044] = {"陈宫", "东汉末年著名谋士。性格刚直，足智多谋。"}
_tab_stringU[14045] = {"臧霸", "本为吕布手下健将。后来投降曹操。"}
_tab_stringU[14046] = {"郝萌", "东汉末年吕布部将，河内（治今河南武陟西南）人。"}
_tab_stringU[14047] = {"神射手", "臂力强劲，能将箭矢射得极远。"}
_tab_stringU[14048] = {"孔明灯", "俗称许愿灯，但在古代却多被作为军事用途。"}
_tab_stringU[14049] = {"小孔明灯", "俗称小许愿灯，但在古代却多被作为军事用途。"}



--==================吕布传==================--
_tab_stringU[14050] = {"百夫长-曹", "吕布传 百夫长-曹"}
_tab_stringU[14051] = {"神射手-曹", "吕布传 神射手-曹"}
_tab_stringU[14052] = {"巡逻的神射手-曹", "吕布传 巡逻的神射手-曹"}
_tab_stringU[14060] = {"袁绍近卫军", "袁绍近卫军简介"}
_tab_stringU[14061] = {"袁绍神射手", "袁绍神射手简介"}
_tab_stringU[14062] = {"袁绍骑兵", "袁绍骑兵袁简介"}
_tab_stringU[14063] = {"袁绍百夫长", "袁绍百夫长简介"}
_tab_stringU[14064] = {"袁绍爆弹兵", "袁绍爆弹兵简介"}
_tab_stringU[14065] = {"袁绍奇袭军", "袁绍奇袭军简介"}
_tab_stringU[14066] = {"袁绍投石车", "袁绍投石车简介"}
_tab_stringU[14067] = {"袁绍秘箭手", "袁绍秘箭手简介"}
_tab_stringU[14068] = {"袁术召唤的绿球", "袁术召唤的绿球简介"}
_tab_stringU[14069] = {"农妇", "逃跑的难民（女）简介"}
_tab_stringU[14070] = {"农夫", "逃跑的难民（胖子）简介"}
_tab_stringU[14071] = {"袁绍大力士", "袁绍大力士简介"}
_tab_stringU[14072] = {"袁绍山贼", "袁绍山贼简介"}
_tab_stringU[14073] = {"袁绍白耳兵", "袁绍白耳兵简介"}
_tab_stringU[14074] = {"袁绍高级百夫长", "袁绍高级百夫长简介"}
_tab_stringU[14075] = {"袁绍精锐骑兵", "袁绍骑兵精锐简介"}

_tab_stringU[14101] = {"陈宫", "吕布传 陈宫"}
_tab_stringU[14102] = {"高顺", "吕布传 高顺"}
_tab_stringU[14103] = {"神弩兵", "吕布传 神弩兵"}
_tab_stringU[14104] = {"陷阵禁卫", "吕布传 陷阵禁卫"}
_tab_stringU[14105] = {"陈到", "吕布传 陈到"}
_tab_stringU[14106] = {"白耳兵", "吕布传 白耳兵"}
_tab_stringU[14107] = {"神射手", "吕布传 神射手"}
_tab_stringU[14108] = {"陈登", "吕布传 陈登"}

_tab_stringU[14111] = {"刘备", "吕布传 刘备"}
_tab_stringU[14112] = {"关羽", "吕布传 关羽"}
_tab_stringU[14113] = {"张飞", "吕布传 张飞"}

--==========================================--

_tab_stringU[14121] = {"纪灵", "纪灵"}
_tab_stringU[14122] = {"袁胤", "袁胤"}
_tab_stringU[14123] = {"张勋", "张勋"}
_tab_stringU[14124] = {"袁术", "袁术"}
_tab_stringU[14125] = {"陈兰", "陈兰"}
_tab_stringU[14126] = {"雷薄", "雷薄"}
_tab_stringU[14127] = {"颜良", "颜良"}
_tab_stringU[14128] = {"文丑", "文丑"}


_tab_stringU[14130] = {"孔秀", "孔秀"}
_tab_stringU[14131] = {"孟坦", "孟坦"}
_tab_stringU[14132] = {"韩福", "韩福"}
_tab_stringU[14133] = {"卞喜", "卞喜"}
_tab_stringU[14134] = {"王植", "王植"}
_tab_stringU[14135] = {"秦琪", "秦琪"}
_tab_stringU[14136] = {"廖化", "廖化"}
_tab_stringU[14137] = {"甘夫人", "甘夫人"}
_tab_stringU[14138] = {"糜夫人", "糜夫人"}

_tab_stringU[14139] = {"箭塔", "五关之一"}
_tab_stringU[14140] = {"箭塔", "五关之二"}
_tab_stringU[14141] = {"箭塔", "五关之三"}
_tab_stringU[14142] = {"箭塔", "五关之四"}
_tab_stringU[14143] = {"箭塔", "五关之五"}
_tab_stringU[14144] = {"山贼", "山贼 简介"}
_tab_stringU[14145] = {"夏侯惇", "夏侯惇 简介"}
_tab_stringU[14148] = {"巡逻的神射手", "巡逻的神射手 简介"}
_tab_stringU[14149] = {"巡逻的精锐刀兵", "巡逻的精锐刀兵 简介"}
_tab_stringU[14150] = {"裴元绍", "裴元绍"}
_tab_stringU[14151] = {"周仓", "周仓 简介"}
_tab_stringU[14152] = {"投石兵", "投石兵 简介"}


_tab_stringU[14160] = {"蔡阳", "蔡阳 简介"}
_tab_stringU[14161] = {"李典", "李典 简介"}
_tab_stringU[14162] = {"于禁", "于禁 简介"}
_tab_stringU[14163] = {"夏侯惇", "夏侯惇 简介"}
_tab_stringU[14164] = {"夏侯亲卫", "夏侯亲卫 简介"}

_tab_stringU[14170] = {"吕翔", "吕翔 简介"}
_tab_stringU[14171] = {"吕旷", "吕旷 简介"}
_tab_stringU[14172] = {"审配", "审配 简介"}
_tab_stringU[14173] = {"审配亲卫", "审配亲卫 简介"}
_tab_stringU[14174] = {"刘备", "刘备 简介"}

_tab_stringU[14180] = {"霹雳车", "霹雳车 简介"}
_tab_stringU[14181] = {"狙击塔", "狙击塔 简介"}
_tab_stringU[14182] = {"箭雨塔", "箭雨塔 简介"}
_tab_stringU[14183] = {"袁军大寨", "袁军大寨 简介"}
_tab_stringU[14184] = {"据点-投石问路", "据点-投石问路"}
_tab_stringU[14185] = {"火焰术士", "火焰术士 简介"}
_tab_stringU[14186] = {"精锐刀兵", "精锐刀兵 简介"}
_tab_stringU[14187] = {"精锐射手", "精锐射手 简介"}
_tab_stringU[14190] = {"运粮牛车", "运粮牛车 简介"}
_tab_stringU[14191] = {"韩猛", "韩猛 简介"}
_tab_stringU[14192] = {"运粮牛车", "运粮牛车 简介"}
_tab_stringU[14193] = {"三弓床弩", "霹雳车 简介"}

_tab_stringU[14200] = {"许攸", "许攸 简介"}
_tab_stringU[14201] = {"刺客", "刺客 简介"}



_tab_stringU[14202] = {"蒋琦", "蒋琦 简介"}
_tab_stringU[14203] = {"眭元进", "眭元进 简介"}
_tab_stringU[14204] = {"赵睿", "赵睿 简介"}
_tab_stringU[14205] = {"淳于琼", "淳于琼 简介"}
_tab_stringU[14206] = {"虎豹骑", "虎豹骑 简介"}
_tab_stringU[14207] = {"死士", "死士 简介"}
_tab_stringU[14215] = {"大戟士", "大戟士 简介"}
_tab_stringU[14216] = {"高览", "高览 简介"}
_tab_stringU[14217] = {"张合", "张合 简介"}

_tab_stringU[14218] = {"郭图", "郭图 简介"}
_tab_stringU[14219] = {"袁谭", "袁谭 简介"}
_tab_stringU[14220] = {"辛明", "辛明 简介"}
_tab_stringU[14221] = {"袁尚", "袁尚 简介"}
_tab_stringU[14226] = {"袁绍", "袁绍 简介"}
_tab_stringU[14228] = {"逃跑者", "逃跑者 简介"}
_tab_stringU[14229] = {"袁熙", "袁熙 简介"}
_tab_stringU[14230] = {"袁尚", "袁尚 简介"}



_tab_stringU[14301] = {"隐身刺客", "刺客 简介"}
_tab_stringU[14302] = {"羽林卫", "羽林卫 简介"}
_tab_stringU[14303] = {"仙术师", "仙术师 简介"}
_tab_stringU[14304] = {"太史慈", "太史慈 简介"}
_tab_stringU[14305] = {"孙策据点", "据点 简介"}
_tab_stringU[14306] = {"程普", "程普 简介"}
_tab_stringU[14307] = {"韩当", "韩当 简介"}
_tab_stringU[14308] = {"黄盖", "黄盖 简介"}
_tab_stringU[14309] = {"蒋钦", "蒋钦 简介"}
_tab_stringU[14310] = {"周泰", "周泰 简介"}
_tab_stringU[14311] = {"周瑜", "周瑜 简介"}
_tab_stringU[14312] = {"火龙塔", "火龙塔 简介"}
_tab_stringU[14313] = {"水兵", "水兵 简介"}
_tab_stringU[14314] = {"鳞甲水兵", "鳞甲水兵 简介"}
_tab_stringU[14315] = {"羽林射手", "射手 简介"}
_tab_stringU[14316] = {"闪电术士", "闪电术士 简介"}
_tab_stringU[14317] = {"张英", "张英 简介"}
_tab_stringU[14318] = {"玄武", "玄武 简介"}
_tab_stringU[14319] = {"魂*玄武", "玄武 简介"}
_tab_stringU[14320] = {"孙策据点", "玄武 简介"}
_tab_stringU[14321] = {"刘繇", "刘繇 简介"}

--_tab_stringU[14322] = {"陈孙", "三国时期江夏贼二头领"}
--_tab_stringU[14323] = {"张武", "张武是第一个乘坐的卢的主人,江夏贼二头领之一"}
_tab_stringU[14322] = {"周昕", "会稽太守王朗麾下之将，增援王朗与孙策的作战"}
_tab_stringU[14323] = {"虞翻", "会稽太守王朗部下功曹，后投奔孙策"}
_tab_stringU[14324] = {"刘备", ""}
_tab_stringU[14325] = {"精锐铁骑", "速度非常快,是受过特殊训练的铁骑精锐"}
_tab_stringU[14326] = {"奥义术师", "能够聚气一波能量,然后释放出强大的能量波"}
_tab_stringU[14328] = {"蔡瑁", "蔡瑁协助刘表平定荆州，仕奉刘表期间，历任江夏、南郡、章陵等诸郡太守"}
_tab_stringU[14329] = {"文聘", "荆州刘表的大将，镇守荆北，刘表用他来抵御北方诸侯的进攻"}
_tab_stringU[14333] = {"神威投掷手", "装备精良的投弹手,还随身携带可埋置在地面的地雷"}
_tab_stringU[14336] = {"曹仁", "东汉末年，天下大乱，带队跟随曹操，任别部司马，行厉锋校尉"}
_tab_stringU[14337] = {"曹洪", "汉末至三国曹魏时期名将，魏武帝曹操从弟"}
_tab_stringU[14338] = {"牛金", "若非当日牛金力，怀愍沈沦晋已亡"}
_tab_stringU[14341] = {"冰雪舞姬", "会跳死亡之舞,凛冬伴随其后"}
_tab_stringU[14342] = {"河神巨龟", "会召唤寒冰旋风,冻结一切碰触的敌人"}
_tab_stringU[14344] = {"金仙风神", "掌管万物之风,金仙之身,有风卷残云之力,气吞山河之势"}
_tab_stringU[14347] = {"徐庶", "汉末年刘备帐下谋士，后归曹操，并仕于曹魏", ""}



_tab_stringU[14327] = {"草船借箭据点", "草船借箭据点"}
_tab_stringU[14331] = {"曹军弓手", "曹军弓手"}
_tab_stringU[14334] = {"一颗会爆炸的丸子", "一颗会爆炸的丸子"}
_tab_stringU[14346] = {"亡魂先知", "没有简介讷。"}


------PVE双人副本 怪物 BOSS信息-----
_tab_stringU[14348] = {"屠凉", "BOSS 1号。"}
_tab_stringU[14349] = {"恶来", "BOSS 2号。"}
_tab_stringU[14351] = {"玄冥", "BOSS 4号。"}
_tab_stringU[14352] = {"养由基", "BOSS 5号。"}
_tab_stringU[14353] = {"裘剑速", "BOSS 6号。"}
_tab_stringU[14354] = {"洛河", "BOSS 7号。"}
_tab_stringU[14355] = {"风后", "BOSS 8号。"}
_tab_stringU[14356] = {"穷奇", "BOSS 9号。"}
_tab_stringU[14357] = {"魔龙", "BOSS 10号。"}
_tab_stringU[14358] = {"农民", "没有简介讷。"}
_tab_stringU[14359] = {"农民", "没有简介讷。"}
_tab_stringU[14360] = {"刀兵", "没有简介讷。"}
_tab_stringU[14361] = {"刀兵", "没有简介讷。"}
_tab_stringU[14362] = {"刀兵", "没有简介讷。"}
_tab_stringU[14363] = {"弓兵", "没有简介讷。"}
_tab_stringU[14364] = {"弓兵", "没有简介讷。"}
_tab_stringU[14365] = {"弓兵", "没有简介讷。"}
_tab_stringU[14366] = {"骑兵", "没有简介讷。"}
_tab_stringU[14367] = {"骑兵", "没有简介讷。"}
_tab_stringU[14368] = {"骑兵", "没有简介讷。"}
_tab_stringU[14369] = {"孔明灯", "没有简介讷。"}
_tab_stringU[14370] = {"孔明灯", "没有简介讷。"}
_tab_stringU[14371] = {"孔明灯", "没有简介讷。"}
_tab_stringU[14372] = {"治疗师", "没有简介讷。"}
_tab_stringU[14373] = {"治疗师", "没有简介讷。"}
_tab_stringU[14374] = {"治疗师", "没有简介讷。"}
_tab_stringU[14375] = {"狼", "没有简介讷。"}
_tab_stringU[14376] = {"狼", "没有简介讷。"}
_tab_stringU[14377] = {"狼", "没有简介讷。"}
_tab_stringU[14378] = {"鹰卫", "没有简介讷。"}
_tab_stringU[14379] = {"黑法师", "没有简介讷。"}
_tab_stringU[14380] = {"凤凰", "没有简介讷。"}
_tab_stringU[14381] = {"小祸斗", "没有简介讷。"}
_tab_stringU[14382] = {"妖法师", "没有简介讷。"}

-------------------超级塔--------------------------
_tab_stringU[14384] = {"超级滚石塔", "没有简介讷。"}
_tab_stringU[14385] = {"超级轰天塔", "没有简介讷。"}
_tab_stringU[14386] = {"超级巨炮塔", "没有简介讷。"}
_tab_stringU[14387] = {"超级狙击塔", "没有简介讷。"}
_tab_stringU[14388] = {"超级连弩塔", "没有简介讷。"}
_tab_stringU[14389] = {"超级剧毒塔", "没有简介讷。"}
_tab_stringU[14390] = {"超级雷塔", "没有简介讷。"}
_tab_stringU[14391] = {"超级冰塔", "没有简介讷。"}
_tab_stringU[14392] = {"超级火塔", "没有简介讷。"}
_tab_stringU[14393] = {"超级塔基", "没有简介讷。"}

_tab_stringU[14401] = {"精锐刀盾兵", "配备了盾牌的刀兵，攻防兼备。"}
_tab_stringU[14402] = {"李典", "曹操麾下将领，为人低调，从不争功，被誉为有长者之风。"}
_tab_stringU[14403] = {"于禁", "曾于张绣造反时讨伐不守军纪的青州兵，同时为迎击敌军而固守营垒，因此曹操称赞他可与古代名将相比。"}
_tab_stringU[14404] = {"夏侯惇", "曹操部下大将，同时也是曹操的同族兄弟，骁勇善战。"}
_tab_stringU[14405] = {"甘夫人", "刘备之妾，蜀汉后主刘禅的生母。"}
_tab_stringU[14406] = {"糜竺", "东汉末年刘备帐下重臣。"}
_tab_stringU[14407] = {"淳于导", "曹仁部下将士。"}
_tab_stringU[14408] = {"夏侯恩", "曹操部下的武将，负责保管曹操的“青釭”宝剑"}
_tab_stringU[14409] = {"水兵船", "水兵船"}
_tab_stringU[14410] = {"水兵", "水兵"}

_tab_stringU[14417] = {"张硕", "黄祖的部将"}
_tab_stringU[14418] = {"陈就", "黄祖的部将"}
_tab_stringU[14419] = {"张硕", "黄祖的部将"}
_tab_stringU[14420] = {"陈就", "黄祖的部将"}
_tab_stringU[14421] = {"毛玠", "东汉末年大臣，以清廉公正著称，投奔曹操后深得赏识。"}
_tab_stringU[14422] = {"上级点火点", "上级点火点"}
_tab_stringU[14423] = {"黑色斗舰", "曹操为南下建造的巨大战船，十分坚固，火力强大。"}
_tab_stringU[14424] = {"楼船建筑", "楼船建筑"}
_tab_stringU[14425] = {"孔明灯", "孔明灯"}
_tab_stringU[14426] = {"自爆船", "自爆船"}
_tab_stringU[14427] = {"诸葛亮","三国时期蜀国的丞相，是人们心目中智慧和忠诚的代表", ""}
_tab_stringU[14428] = {"农民", "没有简介讷。"}

_tab_stringU[14502] = {"王朗", "王朗 简介"}
_tab_stringU[14503] = {"严白虎", "严白虎 简介"}
_tab_stringU[14504] = {"黄射", "黄射 简介"}
_tab_stringU[14505] = {"刘勋", "刘勋 简介"}
_tab_stringU[14506] = {"黄射的艨艟战舰", "艨艟战舰 简介"}
_tab_stringU[14507] = {"水兵统领", "水兵统领 简介"}
_tab_stringU[14508] = {"艨艟战舰", "艨艟战舰 简介"}
_tab_stringU[14509] = {"游艇", "游艇 简介"}
_tab_stringU[14510] = {"水兵战船", "水兵战船 简介"}
_tab_stringU[14511] = {"黄祖", "黄祖 简介"}
_tab_stringU[14514] = {"刘虎", "刘虎 简介"}
_tab_stringU[14515] = {"韩唏", "韩唏 简介"}
_tab_stringU[14516] = {"灰狼", "灰狼 简介"}
_tab_stringU[14517] = {"狂狼", "狂狼 简介"}
_tab_stringU[14518] = {"隐狼", "隐狼 简介"}
_tab_stringU[14519] = {"许贡家客", "许贡家客 简介"}

_tab_stringU[14520] = {"孙策", "打猎的孙策 简介"}
_tab_stringU[14523] = {"孙策", "剧情出场一次的孙策 简介"}
_tab_stringU[14524] = {"周瑜", "剧情出场一次的周瑜 简介"}

_tab_stringU[14600] = {"运粮木牛", "军团地图专用 简介"}
_tab_stringU[14601] = {"卫士", "军团地图专用 简介"}
_tab_stringU[14602] = {"盗贼军团-弓手", "军团地图专用 简介"}
_tab_stringU[14603] = {"饥饿的暴民", "军团地图专用 简介"}
_tab_stringU[14604] = {"山贼", "军团地图专用 简介"}
_tab_stringU[14605] = {"隐身刺客", "军团地图专用 简介"}
_tab_stringU[14606] = {"大力士", "军团地图专用 简介"}
_tab_stringU[14607] = {"投弹手", "军团地图专用 简介"}
_tab_stringU[14608] = {"飞斧力士", "军团地图专用 简介"}
_tab_stringU[14609] = {"大戟士", "军团地图专用 简介"}
_tab_stringU[14610] = {"伐木场", "军团地图专用 简介"}
_tab_stringU[14611] = {"伐木的农民", "军团地图专用 简介"}
_tab_stringU[14612] = {"看不见的木头", "军团地图专用 简介"}
_tab_stringU[14613] = {"石头矿", "军团地图专用 简介"}
_tab_stringU[14614] = {"采矿的农民", "军团地图专用 简介"}
_tab_stringU[14615] = {"古添乐", "军团地图专用 简介"}
_tab_stringU[14616] = {"渣渣飞", "军团地图专用 简介"}
_tab_stringU[14617] = {"陈小椿", "军团地图专用 简介"}
_tab_stringU[14618] = {"陆晗", "军团地图专用 简介"}
_tab_stringU[14619] = {"徐鲲", "军团地图专用 简介"}
_tab_stringU[14620] = {"易凡", "军团地图专用 简介"}
_tab_stringU[14621] = {"骑兵", "军团地图专用 简介"}
_tab_stringU[14622] = {"孔明灯", "军团地图专用 简介"}
_tab_stringU[14623] = {"神射", "军团地图专用 简介"}
_tab_stringU[14624] = {"隐身刺客", "军团地图专用 简介"}

_tab_stringU[14649] = {"驻守点", "英雄驻守点 简介"} --军团驻守模式地图
_tab_stringU[14650] = {"驻守点", "英雄驻守点 简介"}




--精英本怪物
_tab_stringU[14700] = {"灰狼", "灰狼 简介"}
_tab_stringU[14701] = {"狂狼", "狂狼 简介"}
_tab_stringU[14702] = {"隐狼", "隐狼 简介"}
_tab_stringU[14703] = {"小祸斗", " 简介"}
_tab_stringU[14704] = {"祸斗", " 简介"}
_tab_stringU[14705] = {"黑暗祸斗", " 简介"}
_tab_stringU[14706] = {"波才", " 简介"}
_tab_stringU[14707] = {"凶狼", " 简介"}
_tab_stringU[14708] = {"黄巾力士", " 简介"}
_tab_stringU[14709] = {"黄巾旗手", " 简介"}
_tab_stringU[14710] = {"黄巾弓手", " 简介"}
_tab_stringU[14711] = {"黄巾流寇", " 简介"}
_tab_stringU[14712] = {"暗之张角", " 简介"}
_tab_stringU[14713] = {"暗之张宝", " 简介"}
_tab_stringU[14714] = {"暗之张梁", " 简介"}
_tab_stringU[14715] = {"黄巾骑兵", " 简介"}
_tab_stringU[14716] = {"黄巾死士", " 简介"}
_tab_stringU[14717] = {"黄巾术士", " 简介"}
_tab_stringU[14718] = {"招狼者", " 简介"}
_tab_stringU[14719] = {"偷袭的鸟人", " 简介"}
_tab_stringU[14720] = {"朴刀兵", " 简介"}
_tab_stringU[14721] = {"弓箭手", " 简介"}
_tab_stringU[14722] = {"精锐刀兵", " 简介"}
_tab_stringU[14723] = {"凉州精锐骑兵", " 简介"}
_tab_stringU[14724] = {"百夫长", " 简介"}
_tab_stringU[14725] = {"陷阵兵", " 简介"}
_tab_stringU[14726] = {"华雄", " 简介"}
_tab_stringU[14727] = {"爆弹兵", " 简介"}
_tab_stringU[14728] = {"舞娘", " 简介"}
_tab_stringU[14729] = {"高顺", " 简介"}
_tab_stringU[14730] = {"吕布", " 简介"}
_tab_stringU[14731] = {"狂暴管亥", " 简介"}
_tab_stringU[14732] = {"管亥亲卫队", " 简介"}
_tab_stringU[14735] = {"胡车儿", " 简介"}
_tab_stringU[14740] = {"贾诩", " 简介"}
_tab_stringU[14741] = {"张绣", " 简介"}

_tab_stringU[14742] = {"纪灵", " 简介"}
_tab_stringU[14743] = {"袁胤", " 简介"}
_tab_stringU[14744] = {"张勋", " 简介"}
_tab_stringU[14745] = {"袁术", " 简介"}
_tab_stringU[14746] = {"颜良", " 简介"}
_tab_stringU[14747] = {"文丑", " 简介"}
_tab_stringU[14748] = {"吕翔", " 简介"}
_tab_stringU[14749] = {"吕旷", " 简介"}
_tab_stringU[14750] = {"审配", " 简介"}
_tab_stringU[14751] = {"力士", " 简介"}
_tab_stringU[14752] = {"刘备", " 简介"}

_tab_stringU[14760] = {"近卫军", " 简介"}
_tab_stringU[14761] = {"神射手", " 简介"}
_tab_stringU[14762] = {"骑兵", " 简介"}
_tab_stringU[14763] = {"百夫长", " 简介"}
_tab_stringU[14764] = {"爆弹兵", " 简介"}
_tab_stringU[14765] = {"奇袭", " 简介"}
_tab_stringU[14766] = {"投石车", " 简介"}
_tab_stringU[14767] = {"秘箭手", " 简介"}
_tab_stringU[14771] = {"大力士", " 简介"}
_tab_stringU[14772] = {"山贼", " 简介"}
_tab_stringU[14773] = {"白耳兵", " 简介"}
_tab_stringU[14774] = {"高级百夫长", " 简介"}
_tab_stringU[14775] = {"轻骑兵", " 简介"}

_tab_stringU[14776] = {"审配", " 简介"}
_tab_stringU[14777] = {"超级弩车", " 简介"}
_tab_stringU[14778] = {"火焰术士", " 简介"}
_tab_stringU[14779] = {"韩猛", " 简介"}
_tab_stringU[14780] = {"暗影祸斗", " 简介"}

_tab_stringU[14781] = {"寒冰术士", " 简介"}
_tab_stringU[14782] = {"投石兵", " 简介"}
_tab_stringU[14783] = {"杀手", " 简介"}
_tab_stringU[14784] = {"高览", " 简介"}
_tab_stringU[14785] = {"张合", " 简介"}
_tab_stringU[14786] = {"郭图", " 简介"}
_tab_stringU[14787] = {"冰霜巨狼", " 简介"}
_tab_stringU[14788] = {"袁尚", " 简介"}

_tab_stringU[14802] = {"羽林卫", "羽林卫 简介"}
_tab_stringU[14803] = {"仙术师", "仙术师 简介"}
_tab_stringU[14813] = {"水兵", "水兵 简介"}
_tab_stringU[14814] = {"鳞甲水兵", "鳞甲水兵 简介"}
_tab_stringU[14815] = {"羽林射手", "射手 简介"}
_tab_stringU[14816] = {"闪电术士", " 简介"}

_tab_stringU[14822] = {"周昕", "会稽太守王朗麾下之将，增援王朗与孙策的作战"}
_tab_stringU[14823] = {"虞翻", "会稽太守王朗部下功曹，后投奔孙策"}

_tab_stringU[14829] = {"船", "羽林卫 简介"}
_tab_stringU[14830] = {"船", "羽林卫 简介"}
_tab_stringU[14831] = {"船", "羽林卫 简介"}
_tab_stringU[14832] = {"船", "羽林卫 简介"}
_tab_stringU[14833] = {"船", "羽林卫 简介"}
_tab_stringU[14834] = {"船", "羽林卫 简介"}
_tab_stringU[14835] = {"船", "羽林卫 简介"}
_tab_stringU[14836] = {"船", "羽林卫 简介"}
_tab_stringU[14837] = {"蔡瑁", "羽林卫 简介"}
_tab_stringU[14838] = {"张允", "羽林卫 简介"}
_tab_stringU[14839] = {"蔡瑁", "羽林卫 简介"}
_tab_stringU[14840] = {"张允", "羽林卫 简介"}
_tab_stringU[14841] = {"冰雪舞姬", "羽林卫 简介"}
_tab_stringU[14842] = {"玄龟", "羽林卫 简介"}
_tab_stringU[14844] = {"金仙风神", "羽林卫 简介"}

_tab_stringU[14846] = {"灰狼", "灰狼 简介"}
_tab_stringU[14847] = {"狂狼", "狂狼 简介"}
_tab_stringU[14848] = {"隐狼", "隐狼 简介"}
_tab_stringU[14849] = {"许贡家客", "许贡家客 简介"}
_tab_stringU[14851] = {"刀盾兵", " 简介"}
_tab_stringU[14852] = {"李典", " 简介"}
_tab_stringU[14853] = {"于禁", " 简介"}
_tab_stringU[14854] = {"夏侯惇", " 简介"}
_tab_stringU[14855] = {"精锐铁骑", " 简介"}
_tab_stringU[14856] = {"神威投掷手", " 简介"}
_tab_stringU[14857] = {"淳于导", " 简介"}
_tab_stringU[14858] = {"夏侯恩", " 简介"}

--==========================================--

_tab_stringU[15003] = {"程远志", "程远志简介"}
_tab_stringU[15004] = {"张角", "黄巾军的领袖。号“天公将军”，太平道的创始人。可以呼风唤雨，还可以复活已故的黄巾将士。"}
_tab_stringU[15006] = {"管亥", "东汉末年黄巾起义军的将领，曾率军围攻孔融。"}
_tab_stringU[15007] = {"召唤的狼", "召唤的狼简介"}
_tab_stringU[15008] = {"张宝", "张角的弟弟，号“地公将军”。擅骑术，一身横练功夫，可以一个打十个。"}
_tab_stringU[15009] = {"张梁", "张角的弟弟，号“人公将军”。对于法术有着特殊的才能，尤其擅长回春之术。"}
_tab_stringU[15010] = {"逃跑的董卓", "逃跑的董卓简介"}
_tab_stringU[15011] = {"据点（大）", "据点（大）简介"}
_tab_stringU[15012] = {"据点（小）", "据点（小）简介"}
_tab_stringU[15013] = {"张曼成", "东汉末年黄巾起义时南阳黄巾军首领。"}
_tab_stringU[15014] = {"召唤的凶狼", "召唤的凶狼简介"}
_tab_stringU[15015] = {"3C刀兵", "3C刀兵简介"}
_tab_stringU[15016] = {"3C射手", "3C射手简介"}
_tab_stringU[15017] = {"3C刀盾兵", "3C刀盾兵简介"}
_tab_stringU[15018] = {"3C神射手", "3C神射手简介"}
_tab_stringU[15020] = {"朴刀兵（主动）", "朴刀兵（主动）简介"}
_tab_stringU[15021] = {"神射手（主动）", "神射手（主动）简介"}
_tab_stringU[15022] = {"精锐刀兵（主动）", "精锐刀（主动）兵简介"}
_tab_stringU[15023] = {"飞熊军（主动）", "飞熊军（主动）简介"}
_tab_stringU[15024] = {"舞娘（主动）", "舞娘（主动）简介"}
_tab_stringU[15025] = {"陷阵兵（主动）", "陷阵兵（主动）简介"}
_tab_stringU[15026] = {"陷阵兵（主动）", "陷阵兵（主动）简介"}
_tab_stringU[15027] = {"爆弹兵（主动）", "爆弹兵（主动）简介"}
_tab_stringU[15028] = {"鸟人", "鸟人简介"}
_tab_stringU[15030] = {"难民", "逃跑的难民（男）简介"}
_tab_stringU[15033] = {"无尽地图泉水", "无尽地图泉水"}
_tab_stringU[15034] = {"无尽地图据点", "无尽地图据点"}
_tab_stringU[15035] = {"满载金币的木牛", "驮着满满两大袋黄金的木牛。每被打一下都会掉落一些金。见到它实在是太幸运了！快去抢啊！"}
_tab_stringU[15036] = {"胖子看守", "胖子看守简介"}
_tab_stringU[15037] = {"普通看守", "普通看守简介"}
_tab_stringU[15038] = {"神秘人", "神秘人(高顺)简介"}
_tab_stringU[15039] = {"巡逻的士兵", "巡逻的士兵简介"}
_tab_stringU[15040] = {"高顺", "高顺简介"}
_tab_stringU[15041] = {"陈宫", "陈宫简介"}
_tab_stringU[15042] = {"貂蝉", "貂蝉简介"}
_tab_stringU[15043] = {"等待救援的士兵", "等待救援的士兵简介"}
_tab_stringU[15044] = {"李典", "李典简介"}
_tab_stringU[15045] = {"夏侯惇", "夏侯惇简介"}
_tab_stringU[15046] = {"魏续", "魏续简介"}
_tab_stringU[15047] = {"宋宪", "宋宪简介"}
_tab_stringU[15048] = {"侯成", "侯成简介"}
_tab_stringU[15049] = {"于禁", "于禁简介"}
_tab_stringU[15050] = {"曹操", "曹操简介"}
_tab_stringU[15051] = {"郭嘉", "郭嘉简介"}
_tab_stringU[15052] = {"风伯", "风伯简介"}
_tab_stringU[15053] = {"风伯召唤的鸟人", "风伯召唤的鸟人简介"}

_tab_stringU[15060] = {"李典", "于禁简介"}
_tab_stringU[15061] = {"夏侯惇", "夏侯惇简介"}
_tab_stringU[15062] = {"于禁", "郭嘉简介"}
_tab_stringU[15063] = {"曹操", "曹操简介"}
_tab_stringU[15064] = {"郭嘉", "郭嘉简介"}
_tab_stringU[15065] = {"双龙塔", "双龙塔简介"}
_tab_stringU[15066] = {"超级炮塔", "超级炮塔简介"}
_tab_stringU[15067] = {"超级攻城车", "无尽模式只打塔的超级攻城车"}


_tab_stringU[15071] = {"中路据点", "中路据点"}
_tab_stringU[15072] = {"飞熊军", "飞熊军"}
_tab_stringU[15073] = {"左路据点", "左路据点"}
_tab_stringU[15074] = {"右路据点", "右路据点"}
_tab_stringU[15075] = {"爆弹兵", "爆弹兵"}




_tab_stringU[15076] = {"强化双头狼", "强化双头狼介绍"}
_tab_stringU[15077] = {"鸟人", "鸟人介绍"}


_tab_stringU[15300] = {"祸斗", "介绍"}
_tab_stringU[15301] = {"句芒", "介绍"}
_tab_stringU[15302] = {"玄冥", "介绍"}
_tab_stringU[15303] = {"将臣", "介绍"}
_tab_stringU[15304] = {"地宫死士", "介绍"}
_tab_stringU[15305] = {"死士统领", "介绍"}
_tab_stringU[15306] = {"风伯-小", "介绍"}
_tab_stringU[15307] = {"近卫", "介绍"}
_tab_stringU[15308] = {"暗之祸斗", "介绍"}
_tab_stringU[15309] = {"暗之句芒", "介绍"}
_tab_stringU[15310] = {"玄冥", "介绍"}
_tab_stringU[15311] = {"玄冥", "介绍"}
_tab_stringU[15312] = {"其它", "介绍"}

_tab_stringU[15320] = {"炸弹机关", "介绍"}
_tab_stringU[15321] = {"祸斗-小", "介绍"}
_tab_stringU[15322] = {"孔明灯-蓝", "介绍"}
_tab_stringU[15323] = {"其它", "介绍"}
_tab_stringU[15324] = {"其它", "介绍"}
_tab_stringU[15325] = {"其它", "介绍"}
_tab_stringU[15326] = {"其它", "介绍"}
_tab_stringU[15327] = {"其它", "介绍"}

_tab_stringU[15330] = {"其它", "介绍"}
_tab_stringU[15331] = {"其它", "介绍"}
_tab_stringU[15332] = {"其它", "介绍"}
_tab_stringU[15333] = {"其它", "介绍"}
_tab_stringU[15334] = {"其它", "介绍"}


_tab_stringU[15350] = {"青龙使者", "介绍"}
_tab_stringU[15351] = {"白虎使者", "介绍"}
_tab_stringU[15352] = {"朱雀使者", "介绍"}
_tab_stringU[15353] = {"玄武使者", "介绍"}
_tab_stringU[15354] = {"邪灵守将", "介绍"}
_tab_stringU[15355] = {"邪灵守将", "介绍"}
_tab_stringU[15356] = {"帝江", "介绍"}

_tab_stringU[15501] = {"PVP出兵", "1"}
_tab_stringU[15502] = {"PVP出兵", "2"}
_tab_stringU[15503] = {"PVP出兵", "2"}
_tab_stringU[15504] = {"PVP出兵", "2"}
_tab_stringU[15505] = {"PVP出兵", "2"}
_tab_stringU[15506] = {"PVP出兵", "2"}
_tab_stringU[15507] = {"PVP出兵", "2"}
_tab_stringU[15508] = {"PVP出兵", "2"}
_tab_stringU[15509] = {"PVP出兵", "2"}
_tab_stringU[15510] = {"PVP出兵", "2"}
_tab_stringU[15511] = {"PVP出兵", "2"}
_tab_stringU[15512] = {"PVP出兵", "2"}
_tab_stringU[15513] = {"PVP出兵", "2"}
_tab_stringU[15514] = {"PVP出兵", "2"}
_tab_stringU[15515] = {"PVP出兵", "2"}
_tab_stringU[15516] = {"PVP出兵", "2"}
_tab_stringU[15517] = {"PVP出兵", "2"}
_tab_stringU[15518] = {"PVP出兵", "2"}
_tab_stringU[15519] = {"PVP出兵", "2"}
_tab_stringU[15520] = {"PVP出兵", "2"}
_tab_stringU[15521] = {"PVP出兵", "2"}
_tab_stringU[15522] = {"PVP出兵", "2"}
_tab_stringU[15523] = {"PVP出兵", "2"}
_tab_stringU[15524] = {"PVP出兵", "2"}
_tab_stringU[15525] = {"PVP出兵", "2"}
_tab_stringU[15531] = {"PVP出兵", "2"}
_tab_stringU[15532] = {"PVP出兵", "2"}
_tab_stringU[15533] = {"PVP出兵", "2"}
_tab_stringU[15534] = {"PVP出兵", "2"}
_tab_stringU[15535] = {"PVP出兵", "2"}
_tab_stringU[15536] = {"PVP出兵", "2"}
_tab_stringU[15537] = {"PVP出兵", "2"}
_tab_stringU[15538] = {"PVP出兵", "2"}
_tab_stringU[15539] = {"PVP出兵", "2"}
_tab_stringU[15540] = {"PVP出兵", "2"}
_tab_stringU[15541] = {"PVP出兵", "2"}
_tab_stringU[15542] = {"PVP出兵", "2"}
_tab_stringU[15543] = {"PVP出兵", "2"}
_tab_stringU[15544] = {"PVP出兵", "2"}
_tab_stringU[15545] = {"PVP出兵", "2"}
_tab_stringU[15546] = {"PVP出兵", "2"}
_tab_stringU[15547] = {"PVP出兵", "2"}
_tab_stringU[15548] = {"PVP出兵", "2"}
_tab_stringU[15549] = {"PVP出兵", "2"}
_tab_stringU[15550] = {"PVP出兵", "2"}
_tab_stringU[15551] = {"PVP出兵", "2"}
_tab_stringU[15552] = {"PVP出兵", "2"}
_tab_stringU[15553] = {"PVP出兵", "2"}
_tab_stringU[15554] = {"PVP出兵", "2"}
_tab_stringU[15555] = {"PVP出兵", "2"}

_tab_stringU[15560] = {"PVP投石车", "2"}
_tab_stringU[15561] = {"PVP霹雳车", "2"}
_tab_stringU[15562] = {"PVP孔明灯", "2"}
_tab_stringU[15563] = {"PVP偷袭兵", "2"}
_tab_stringU[15564] = {"满载金币的木牛", "驮着满满两大袋黄金的木牛。每被打一下都会掉落一些金。见到它实在是太幸运了！快去抢啊！"}
_tab_stringU[15565] = {"PVP野怪", "2"}
_tab_stringU[15566] = {"PVP野怪", "2"}
_tab_stringU[15567] = {"祸斗", "祸斗"}
_tab_stringU[15568] = {"PVP野怪", "2"}
_tab_stringU[15569] = {"PVP野怪", "2"}
_tab_stringU[15570] = {"PVP自爆", "2"}
_tab_stringU[15571] = {"PVP力士", "2"}
_tab_stringU[15572] = {"冰霜巨狼", "野怪"}
_tab_stringU[15573] = {"PVP自爆", "会炸人"}
_tab_stringU[15574] = {"象兵", "2"}
_tab_stringU[15575] = {"护城弩手", "2"}
_tab_stringU[15576] = {"虎豹骑", "2"}
_tab_stringU[15577] = {"朴刀兵", "2"}
_tab_stringU[15578] = {"射手", "2"}
_tab_stringU[15578] = {"护城盾卫", "2"}


_tab_stringU[15601] = {"无尽出兵", "2"}
_tab_stringU[15602] = {"无尽出兵", "2"}
_tab_stringU[15603] = {"无尽出兵", "2"}
_tab_stringU[15604] = {"无尽出兵", "2"}
_tab_stringU[15605] = {"无尽出兵", "2"}
_tab_stringU[15606] = {"无尽出兵", "2"}
_tab_stringU[15607] = {"无尽出兵", "2"}
_tab_stringU[15608] = {"无尽出兵", "2"}
_tab_stringU[15609] = {"无尽出兵", "2"}
_tab_stringU[15610] = {"无尽出兵", "2"}
_tab_stringU[15611] = {"无尽出兵", "2"}
_tab_stringU[15612] = {"无尽出兵", "2"}
_tab_stringU[15613] = {"无尽出兵", "2"}
_tab_stringU[15614] = {"无尽出兵", "2"}
_tab_stringU[15615] = {"无尽出兵", "2"}
_tab_stringU[15616] = {"无尽出兵", "2"}

_tab_stringU[15650] = {"程远志", "2"}
_tab_stringU[15651] = {"邓茂", "2"}
_tab_stringU[15652] = {"张曼成", "2"}
_tab_stringU[15653] = {"张宝", "2"}
_tab_stringU[15654] = {"张梁", "2"}
_tab_stringU[15655] = {"华雄", "2"}
_tab_stringU[15656] = {"李傕", "2"}
_tab_stringU[15657] = {"郭汜", "2"}
_tab_stringU[15658] = {"胡车儿", "2"}
_tab_stringU[15659] = {"李儒", "2"}
_tab_stringU[15660] = {"董卓", "2"}
_tab_stringU[15661] = {"张绣", "2"}
_tab_stringU[15662] = {"颜良", "2"}
_tab_stringU[15663] = {"文丑", "2"}
_tab_stringU[15664] = {"夏侯惇", "2"}
_tab_stringU[15665] = {"张角", "2"}
_tab_stringU[15666] = {"吕布", "2"}
_tab_stringU[15667] = {"风伯", "2"}

_tab_stringU[15668] = {"机关巨兽", "2"}
_tab_stringU[15669] = {"小型木牛", "2"}
_tab_stringU[15670] = {"魂*吕布", "2"}
_tab_stringU[15671] = {"魂*张角", "2"}

_tab_stringU[15701] = {"新无尽黄巾流寇", ""}
_tab_stringU[15702] = {"新无尽刀兵", ""}
_tab_stringU[15703] = {"新无尽死士", ""}
_tab_stringU[15704] = {"新无尽骑兵", ""}
_tab_stringU[15705] = {"新无尽水兵", ""}
_tab_stringU[15706] = {"新无尽精锐刀兵", ""}
_tab_stringU[15707] = {"新无尽虎狼骑", ""}
_tab_stringU[15708] = {"新无尽先登死士", ""}
_tab_stringU[15709] = {"新无尽近卫军", ""}
_tab_stringU[15710] = {"新无尽力士", ""}
_tab_stringU[15711] = {"新无尽大戟士", ""}
_tab_stringU[15712] = {"新无尽虎豹骑", ""}
_tab_stringU[15713] = {"新无尽高级黄巾贼", ""}
_tab_stringU[15714] = {"新无尽强壮刀兵", ""}
_tab_stringU[15715] = {"新无尽高级死士", ""}
_tab_stringU[15716] = {"新无尽高级水兵", ""}
_tab_stringU[15717] = {"新无尽高级虎狼骑", ""}
_tab_stringU[15718] = {"新无尽精英刀兵", ""}
_tab_stringU[15719] = {"新无尽精英骑兵", ""}
_tab_stringU[15720] = {"新无尽高级先登死士", ""}
_tab_stringU[15721] = {"新无尽高级近卫军", ""}
_tab_stringU[15722] = {"新无尽高级大戟士", ""}
_tab_stringU[15723] = {"新无尽高级胖子", ""}
_tab_stringU[15724] = {"新无尽高级虎豹骑", ""}
_tab_stringU[15725] = {"新无尽高级白耳兵", ""}


_tab_stringU[15731] = {"新无尽弓手", ""}
_tab_stringU[15732] = {"新无尽投弹", ""}
_tab_stringU[15733] = {"新无尽妖术师", ""}
_tab_stringU[15734] = {"新无尽飞军", ""}
_tab_stringU[15735] = {"新无尽仙术师", ""}
_tab_stringU[15736] = {"新无尽爆弹兵", ""}
_tab_stringU[15737] = {"新无尽符咒师", ""}
_tab_stringU[15738] = {"新无尽精锐射手", ""}
_tab_stringU[15739] = {"新无尽散仙师", ""}
_tab_stringU[15740] = {"新无尽鹰卫", ""}
_tab_stringU[15741] = {"新无尽强壮弓手", ""}
_tab_stringU[15742] = {"新无尽神射手", ""}
_tab_stringU[15743] = {"新无尽强力妖术师", ""}
_tab_stringU[15744] = {"新无尽强壮飞军", ""}
_tab_stringU[15745] = {"新无尽强壮法师", ""}
_tab_stringU[15746] = {"新无尽精锐爆弹兵", ""}
_tab_stringU[15747] = {"新无尽精锐符咒师", ""}
_tab_stringU[15748] = {"新无尽精锐神射手", ""}
_tab_stringU[15749] = {"新无尽精锐散仙", ""}
_tab_stringU[15750] = {"新无尽精锐鹰卫", ""}
_tab_stringU[15751] = {"新无尽精锐飞军", ""}
_tab_stringU[15752] = {"新无尽精锐妖术师", ""}
_tab_stringU[15753] = {"新无尽高级爆弹兵", ""}
_tab_stringU[15754] = {"新无尽高级散仙", ""}
_tab_stringU[15755] = {"新无尽高级鹰卫", ""}



_tab_stringU[15820] = {"玄武", "2"}


--月英传
_tab_stringU[15900] = {"滚石陷阱", "2"}
_tab_stringU[15901] = {"瑶光", "BOSS"}
_tab_stringU[15902] = {"炎之结界", "2"}
_tab_stringU[15903] = {"冰之结界", "2"}
_tab_stringU[15904] = {"玉衡", "精英"}
_tab_stringU[15905] = {"封印石", "精英"}
_tab_stringU[15906] = {"尖刺", "2"}
_tab_stringU[15907] = {"开阳", "精英"}
_tab_stringU[15908] = {"天权", "精英"}
_tab_stringU[15909] = {"天玑", "BOSS"}
_tab_stringU[15910] = {"神秘人", "BOSS"}
_tab_stringU[15911] = {"滚石陷阱2", "2"}
_tab_stringU[15912] = {"飞刃", "2"}
_tab_stringU[15913] = {"地刺制造者", "2"}
_tab_stringU[15914] = {"山贼", "2"}
_tab_stringU[15915] = {"高级飞刃", "2"}
_tab_stringU[15916] = {"捕兽夹", "2"}
_tab_stringU[15917] = {"天璇", "2"}
_tab_stringU[15918] = {"投石兵", "2"}
_tab_stringU[15919] = {"备用？？", "2"}
_tab_stringU[15920] = {"黄月英", "2"}
_tab_stringU[15921] = {"天枢", "2"}
_tab_stringU[15922] = {"山贼制造者", "2"}
_tab_stringU[15923] = {"幻影射手", "2"}
_tab_stringU[15924] = {"大戟士", "2"}
_tab_stringU[15925] = {"火焰术士", "2"}
_tab_stringU[15926] = {"冰霜眼", "2"}
_tab_stringU[15927] = {"飞斧力士", "2"}
_tab_stringU[15928] = {"1", "2"}

_tab_stringU[15960] = {"青祸斗", "BOSS"}
_tab_stringU[15961] = {"捕兽夹", "BOSS"} --月英传
_tab_stringU[15962] = {"捕兽夹", "BOSS"} --孙尚香传
_tab_stringU[15963] = {"黄盖", "BOSS"}
_tab_stringU[15964] = {"据点", "据点"}
_tab_stringU[15965] = {"据点", "据点"}
_tab_stringU[15966] = {"据点", "据点"}
_tab_stringU[15967] = {"黑色斗舰", "黑色斗舰"}
_tab_stringU[15968] = {"张辽", "BOSS"}
_tab_stringU[15969] = {"爆弹兵", "BOSS"}
_tab_stringU[15970] = {"走轲", "走轲"}
_tab_stringU[15971] = {"艨艟战舰", "艨艟"}
_tab_stringU[15972] = {"孙尚香", "剧情"}
_tab_stringU[15973] = {"鳞甲水兵", "鳞甲水兵"}
_tab_stringU[15974] = {"刘备", "刘备"}
_tab_stringU[15975] = {"太史慈", "太史慈"} --太史慈
_tab_stringU[15977] = {"丧尸", "丧尸"}

_tab_stringU[16001] = {"陷阱", "陷阱"}
_tab_stringU[16002] = {"民兵", "民兵"}
_tab_stringU[16003] = {"祸斗所释放的火堆", "祸斗所释放的火堆"}
_tab_stringU[16005] = {"吕布所施放的（主将）", "吕布所施放的（主将）"}
_tab_stringU[16006] = {"投石车", "投石车"}
_tab_stringU[16007] = {"董卓所施放的炸弹（主将）", "董卓所施放的炸弹（主将）"}
_tab_stringU[16008] = {"神吕布所施放的单位（主将）", "神吕布所施放的单位（主将）"}
_tab_stringU[16009] = {"曹操召唤的弓箭手", "曹操召唤的弓箭手"}
_tab_stringU[16010] = {"曹操兵", "曹操兵"}
_tab_stringU[16011] = {"小型攻城车", "无尽模式只打塔的攻城车LV1"}
_tab_stringU[16012] = {"大型攻城车", "无尽模式只打塔的攻城车LV2"}
_tab_stringU[16013] = {"飞鹰卫", "飞鹰卫"}
_tab_stringU[16014] = {"神鹰卫", "神鹰卫"}
_tab_stringU[16015] = {"凤凰火堆", "凤凰火堆"}
_tab_stringU[16016] = {"旗帜", "旗帜"}
_tab_stringU[16017] = {"爆炎留下的火", "爆炎留下的火"}
_tab_stringU[16018] = {"东吴水兵", "东吴水兵"}
_tab_stringU[16019] = {"镇军战旗", "镇军战旗"}
_tab_stringU[16020] = {"民兵", "民兵"}
_tab_stringU[16021] = {"弓箭手", "弓箭手"}
_tab_stringU[16022] = {"村民", "村民"}
_tab_stringU[16023] = {"老者", "老者"}
_tab_stringU[16024] = {"孙尚香", "孙尚香"}
_tab_stringU[16025] = {"东吴水兵", "东吴水兵"}

_tab_stringU[16042] = {"旱魃残魂", "旱魃残魂"}

_tab_stringU[18001] = {"刘备", "三国时期蜀汉开国皇帝, 与关羽, 张飞结为兄弟", "在剧情地图  英雄现世中\n通关后可以免费获得"}
_tab_stringU[18002] = {"关羽", "三国时期蜀汉重要将领, 与刘备, 张飞结为兄弟", "在剧情地图  桃园结义中\n通关后可以免费获得"}
_tab_stringU[18003] = {"张飞", "三国时期蜀汉重要将领, 与刘备, 关羽结为兄弟", "在剧情地图  英雄现世中\n通关后可以免费获得"}
_tab_stringU[18004] = {"张角", "中国东汉末年农民起义军[黄巾军]的领袖, 太平道的创始人", ""}
_tab_stringU[18005] = {"曹操","曹魏政权的缔造者, 在政治、军事、文学上都有很高的造诣", "在剧情地图  广宗之战中\n通关后可以免费获得"}
_tab_stringU[18006] = {"太史慈","刘繇部下, 后被孙策收降, 助其扫荡江东", "在剧情地图  北海之围中\n通关后可以在商城购买该英雄"}
_tab_stringU[18007] = {"郭嘉","曹操手下重要的谋士, 为曹操统一中国北方立下了功勋", "在剧情地图  火烧洛阳中\n通关后可以在商城购买该英雄"}
_tab_stringU[18008] = {"赵云", "鬼哭与神嚎, 天惊并地惨, 常山赵子龙, 一身都是胆", "首次充值98元档可以获得该英雄"}
_tab_stringU[18009] = {"赵云分身", "鬼哭与神嚎, 天惊并地惨, 常山赵子龙, 一身都是胆", ""}
_tab_stringU[18010] = {"夏侯惇", "曹操部下大将, 同时也是曹操的同族兄弟, 骁勇善战", "在剧情地图  陈留起兵中\n通关后可以免费获得"}
_tab_stringU[18011] = {"吕布", "三国第一猛将, 坐骑赤兔宝马, 手持方天画戟, 天下无双", "在吕布传地图包  逃脱牢笼中\n通关后可以免费获得"}
_tab_stringU[18012] = {"貂蝉", "古代四大美女之一, 司徒王允的义女, 为拯救汉朝, 巧施连环计", "在吕布传地图包  逃脱牢笼中\n三星通关后可以免费获得"}
_tab_stringU[18013] = {"吕布", "三国第一猛将, 坐骑赤兔宝马, 手持方天画戟, 天下无双", "在吕布传地图包  逃脱牢笼中\n通关后可以免费获得"}
_tab_stringU[18014] = {"张辽","曹魏五子良将之一, 智勇双全, 南征北伐, 逍遥津一战成名", "在剧情地图  下邳之战中\n通关后可以在商城购买该英雄"}
_tab_stringU[18015] = {"许褚","曹操手下猛将, 长八尺腰十围, 容貌雄毅, 勇力过人", "在剧情地图  下邳之战中\n通关后可以在商城购买该英雄"}
_tab_stringU[18016] = {"典韦","曹操手下猛将, 形貌魁梧, 膂力过人, 有大志气节, 性格任侠", "在剧情地图  讨伐张绣中\n通关后可以在商城购买该英雄"}
_tab_stringU[18017] = {"甘宁","东吴名将, 少年时因打劫来往商船而被称为【锦帆贼】", "搜集400个甘宁将魂后可以解锁获得"}
_tab_stringU[18018] = {"孙策","东汉末年割据江东一带的军阀，孙吴的奠基者之一", "在剧情地图  借兵出征中\n通关后可以免费获得"}
_tab_stringU[18019] = {"周瑜","吴四英将之一, 幼年与孙策相识, 后随孙策奔赴战场平定江东", "在剧情地图  神亭之战中\n通关后可以免费获得"}
_tab_stringU[18020] = {"徐庶", "汉末年刘备帐下谋士，后归曹操，并仕于曹魏", "在剧情地图  智破八门中\n通关后可以在商城购买该英雄"}
_tab_stringU[18021] = {"诸葛亮","三国时期蜀国的丞相，是人们心目中智慧和忠诚的代表", "在剧情地图  卧龙出山中\n通关后可以在商城购买该英雄"}
_tab_stringU[18022] = {"小乔","三国时期东吴绝世美女，名将周瑜的夫人", "6级会员可以免费获得该英雄"}
_tab_stringU[18023] = {"黄月英","名士黄承彦之女，诸葛亮之妻", "在古墓俪影地图包  古墓探秘中\n三星通关后可以免费获得"}
_tab_stringU[18024] = {"孙权","三国时代东吴的建立者，自幼文武双全，早年随父兄征战天下", "在剧情地图  狩猎中\n通关后可以在商城购买该英雄"}
_tab_stringU[18025] = {"庞统","三国时刘备手下的重要谋士，与诸葛亮同拜为军师中郎将", "搜集400个庞统将魂后可以解锁获得"}
_tab_stringU[18026] = {"赵云分身", "鬼哭与神嚎, 天惊并地惨, 常山赵子龙, 一身都是胆", ""}
_tab_stringU[18027] = {"董卓","东汉末年凉州军阀。掌控朝中大权。", "搜集400个董卓将魂后可以解锁获得"}
_tab_stringU[18028] = {"荀彧","东汉末年著名政治家、战略家，曹操统一北方的首席谋臣和功臣。", "在剧情地图 劫粮中\n通关后可以在商城购买该英雄"}
_tab_stringU[18029] = {"贾诩","东汉末年至三国初年著名谋士、军事战略家，曹魏开国功臣。", "在剧情地图 清剿余党中\n通关后可以在商城购买该英雄"}
_tab_stringU[18031] = {"孙尚香","讨虏将军孙权之妹，曾为左将军刘备之妻，人称孙夫人。", "在枭姬传地图包  地宫试炼中\n通关后可以免费获得"}
_tab_stringU[18032] = {"黄忠","本为刘表部下中郎将，后归刘备，并助刘备攻破益州刘璋。", "搜集400个黄忠将魂后可以解锁获得"}
_tab_stringU[18033] = {"马超","伏波将军马援之后，卫尉马腾之子，三国蜀汉名将。", "在剧情地图 智筑冰城中\n三星通关后可以免费获得"}
_tab_stringU[18034] = {"孙坚","东汉末年将领、军阀，三国中之吴国的奠基人。", "搜集400个孙坚将魂后可以解锁获得"}
_tab_stringU[18035] = {"陆逊","三国时期吴国政治家、军事家。夷陵之战中大破刘备，由此一战成名。", "在剧情地图 八阵图\n通关后可以在商城购买该英雄"}
_tab_stringU[18036] = {"司马懿","三国时期魏国政治家、军事谋略家，魏国权臣，西晋王朝的奠基人。", "在剧情地图 八阵图\n通关后可以在商城购买该英雄"}
_tab_stringU[18037] = {"大乔","孙策之妻，与小乔并称为“江东二乔。", "？？"}
_tab_stringU[18038] = {"曹丕","曹操次子，三国时期曹魏开国皇帝。", "？？"}
_tab_stringU[18040] = {"曹丕","？", "？？"}
_tab_stringU[18041] = {"孟获","三国时期南中地区的首领。", "搜集400个孟获将魂后可以解锁获得"}
_tab_stringU[18045] = {"祝融夫人","南蛮王孟获之妻，相传为火神祝融氏的后裔。", "搜集400个祝融夫人将魂后可以解锁获得"}
_tab_stringU[18046] = {"甄姬","文昭甄皇后，史称甄夫人，魏文帝曹丕的妻子，魏明帝曹叡的生母。", "搜集400个甄姬将魂后可以解锁获得"}
_tab_stringU[18048] = {"修罗吕布","？", "？？"}

--PVP
_tab_stringU[18101] = {"刘备", "三国时期蜀汉开国皇帝, 与关羽, 张飞结为兄弟", ""}
_tab_stringU[18102] = {"关羽", "三国时期蜀汉重要将领, 与刘备, 张飞结为兄弟", ""}
_tab_stringU[18103] = {"张飞", "三国时期蜀汉重要将领, 与刘备, 关羽结为兄弟", ""}
_tab_stringU[18105] = {"曹操","曹魏政权的缔造者, 在政治、军事、文学上都有很高的造诣", ""}
_tab_stringU[18106] = {"太史慈","刘繇部下, 后被孙策收降, 助其扫荡江东", ""}
_tab_stringU[18107] = {"郭嘉","曹操手下重要的谋士, 为曹操统一中国北方立下了功勋", ""}
_tab_stringU[18108] = {"赵云", "鬼哭与神嚎, 天惊并地惨, 常山赵子龙, 一身都是胆", ""}
_tab_stringU[18110] = {"夏侯惇", "曹操部下大将, 同时也是曹操的同族兄弟, 骁勇善战", ""}
_tab_stringU[18111] = {"吕布", "三国第一猛将, 坐骑赤兔宝马, 手持方天画戟, 天下无双", ""}
_tab_stringU[18112] = {"貂蝉", "古代四大美女之一, 司徒王允的义女, 为拯救汉朝, 巧施连环计", ""}
_tab_stringU[18114] = {"张辽","曹魏五子良将之一, 智勇双全, 南征北伐, 逍遥津一战成名", ""}
_tab_stringU[18115] = {"许褚","曹操手下猛将, 长八尺腰十围, 容貌雄毅, 勇力过人", ""}
_tab_stringU[18116] = {"典韦","曹操手下猛将, 形貌魁梧, 膂力过人, 有大志气节, 性格任侠", ""}
_tab_stringU[18117] = {"甘宁","东吴名将, 少年时因打劫来往商船而被称为【锦帆贼】", "甘宁为竞技场专属英雄，只能从竞技场战斗中积攒将魂碎片获取。"}
_tab_stringU[18118] = {"孙策","东汉末年割据江东一带的军阀，汉末群雄之一，三国时期孙吴的奠基者之一。", ""}
_tab_stringU[18119] = {"周瑜","东吴四英将之一, 幼年与孙策相识, 后随孙策奔赴战场平定江东", ""}
_tab_stringU[18120] = {"徐庶", "汉末年刘备帐下谋士，后归曹操，并仕于曹魏", ""}
_tab_stringU[18121] = {"诸葛亮","三国时期蜀国的丞相，是人们心目中智慧和忠诚的代表", ""}
_tab_stringU[18122] = {"小乔","三国时期东吴绝世美女，名将周瑜的夫人", ""}
_tab_stringU[18123] = {"黄月英","名士黄承彦之女，诸葛亮之妻", ""}
_tab_stringU[18124] = {"孙权","三国时代东吴的建立者，自幼文武双全，早年随父兄征战天下", ""}
_tab_stringU[18125] = {"庞统","三国时刘备手下的重要谋士，与诸葛亮同拜为军师中郎将", ""}
_tab_stringU[18127] = {"董卓","东汉末年凉州军阀。掌控朝中大权。", ""}
_tab_stringU[18128] = {"荀彧","东汉末年著名政治家、战略家，曹操统一北方的首席谋臣和功臣。", ""}
_tab_stringU[18129] = {"贾诩","东汉末年至三国初年著名谋士、军事战略家，曹魏开国功臣。", ""}
_tab_stringU[18131] = {"孙尚香","讨虏将军孙权之妹，曾为左将军刘备之妻，人称孙夫人。", ""}
_tab_stringU[18132] = {"黄忠","本为刘表部下中郎将，后归刘备，并助刘备攻破益州刘璋。", "？？"}
_tab_stringU[18133] = {"马超","伏波将军马援之后，卫尉马腾之子，三国蜀汉名将。", "在剧情地图 智筑冰城中\n通关后可以免费获得"}
_tab_stringU[18134] = {"孙坚","东汉末年将领、军阀，三国中之吴国的奠基人。", "？？"}
_tab_stringU[18135] = {"陆逊","三国时期吴国政治家、军事家。夷陵之战中大破刘备，由此一战成名。", "在剧情地图 八阵图\n通关后可以在商城购买该英雄"}
_tab_stringU[18136] = {"司马懿","三国时期魏国政治家、军事谋略家，魏国权臣，西晋王朝的奠基人。", "在剧情地图 八阵图\n通关后可以在商城购买该英雄"}
_tab_stringU[18137] = {"大乔","孙策之妻，与小乔并称为“江东二乔。", "？？"}
_tab_stringU[18138] = {"曹丕","曹操次子，三国时期曹魏开国皇帝。", "？？"}
_tab_stringU[18140] = {"曹丕","？", "？？"}
_tab_stringU[18141] = {"孟获","三国时期南中地区的首领。", "搜集400个孟获将魂后可以解锁获得"}
_tab_stringU[18145] = {"祝融夫人","南蛮王孟获之妻，相传为火神祝融氏的后裔。", "搜集400个祝融夫人将魂后可以解锁获得"}
_tab_stringU[18146] = {"甄姬","文昭甄皇后，史称甄夫人，魏文帝曹丕的妻子，魏明帝曹叡的生母。", "搜集400个甄姬将魂后可以解锁获得"}


_tab_stringU[18301] = {"刘备", "三国时期蜀汉开国皇帝, 与关羽, 张飞结为兄弟", "在剧情地图  英雄现世中\n通关后可以免费获得"}
_tab_stringU[18302] = {"关羽", "三国时期蜀汉重要将领, 与刘备, 张飞结为兄弟", "在剧情地图  桃园结义中\n通关后可以免费获得"}
_tab_stringU[18303] = {"张飞", "三国时期蜀汉重要将领, 与刘备, 关羽结为兄弟", "在剧情地图  英雄现世中\n通关后可以免费获得"}
_tab_stringU[18304] = {"张角", "中国东汉末年农民起义军[黄巾军]的领袖, 太平道的创始人", ""}
_tab_stringU[18305] = {"曹操","曹魏政权的缔造者, 在政治、军事、文学上都有很高的造诣", "在剧情地图  广宗之战中\n通关后可以免费获得"}
_tab_stringU[18306] = {"太史慈","刘繇部下, 后被孙策收降, 助其扫荡江东", "在剧情地图  北海之围中\n通关后可以在商城购买该英雄"}
_tab_stringU[18307] = {"郭嘉","曹操手下重要的谋士, 为曹操统一中国北方立下了功勋", "在剧情地图  火烧洛阳中\n通关后可以在商城购买该英雄"}
_tab_stringU[18308] = {"赵云", "鬼哭与神嚎, 天惊并地惨, 常山赵子龙, 一身都是胆", "首次充值98元档可以获得该英雄"}
_tab_stringU[18309] = {"赵云分身", "鬼哭与神嚎, 天惊并地惨, 常山赵子龙, 一身都是胆", ""}
_tab_stringU[18310] = {"夏侯惇", "曹操部下大将, 同时也是曹操的同族兄弟, 骁勇善战", "在剧情地图  陈留起兵中\n通关后可以免费获得"}
_tab_stringU[18311] = {"吕布", "三国第一猛将, 坐骑赤兔宝马, 手持方天画戟, 天下无双", "在吕布传地图包  逃脱牢笼中\n通关后可以免费获得"}
_tab_stringU[18312] = {"貂蝉", "古代四大美女之一, 司徒王允的义女, 为拯救汉朝, 巧施连环计", "在吕布传地图包  逃脱牢笼中\n三星通关后可以免费获得"}
_tab_stringU[18313] = {"吕布", "三国第一猛将, 坐骑赤兔宝马, 手持方天画戟, 天下无双", "在吕布传地图包  逃脱牢笼中\n通关后可以免费获得"}
_tab_stringU[18314] = {"张辽","曹魏五子良将之一, 智勇双全, 南征北伐, 逍遥津一战成名", "在剧情地图  下邳之战中\n通关后可以在商城购买该英雄"}
_tab_stringU[18315] = {"许褚","曹操手下猛将, 长八尺腰十围, 容貌雄毅, 勇力过人", "在剧情地图  下邳之战中\n通关后可以在商城购买该英雄"}
_tab_stringU[18316] = {"典韦","曹操手下猛将, 形貌魁梧, 膂力过人, 有大志气节, 性格任侠", "在剧情地图  讨伐张绣中\n通关后可以在商城购买该英雄"}
_tab_stringU[18317] = {"甘宁","东吴名将, 少年时因打劫来往商船而被称为【锦帆贼】", "搜集400个甘宁将魂后可以解锁获得"}
_tab_stringU[18318] = {"孙策","东汉末年割据江东一带的军阀，孙吴的奠基者之一", "在剧情地图  借兵出征中\n通关后可以免费获得"}
_tab_stringU[18319] = {"周瑜","吴四英将之一, 幼年与孙策相识, 后随孙策奔赴战场平定江东", "在剧情地图  神亭之战中\n通关后可以免费获得"}
_tab_stringU[18320] = {"徐庶", "汉末年刘备帐下谋士，后归曹操，并仕于曹魏", "在剧情地图  智破八门中\n通关后可以在商城购买该英雄"}
_tab_stringU[18321] = {"诸葛亮","三国时期蜀国的丞相，是人们心目中智慧和忠诚的代表", "在剧情地图  卧龙出山中\n通关后可以在商城购买该英雄"}
_tab_stringU[18322] = {"小乔","三国时期东吴绝世美女，名将周瑜的夫人", "6级会员可以免费获得该英雄"}
_tab_stringU[18323] = {"黄月英","名士黄承彦之女，诸葛亮之妻", "在古墓俪影地图包  古墓探秘中\n三星通关后可以免费获得"}
_tab_stringU[18324] = {"孙权","三国时代东吴的建立者，自幼文武双全，早年随父兄征战天下", "在剧情地图  狩猎中\n通关后可以在商城购买该英雄"}
_tab_stringU[18325] = {"庞统","三国时刘备手下的重要谋士，与诸葛亮同拜为军师中郎将", "搜集400个庞统将魂后可以解锁获得"}
_tab_stringU[18326] = {"赵云分身", "鬼哭与神嚎, 天惊并地惨, 常山赵子龙, 一身都是胆", ""}
_tab_stringU[18327] = {"董卓","东汉末年凉州军阀。掌控朝中大权。", "搜集400个董卓将魂后可以解锁获得"}
_tab_stringU[18328] = {"荀彧","东汉末年著名政治家、战略家，曹操统一北方的首席谋臣和功臣。", "在剧情地图 劫粮中\n通关后可以在商城购买该英雄"}
_tab_stringU[18329] = {"贾诩","东汉末年至三国初年著名谋士、军事战略家，曹魏开国功臣。", "在剧情地图 清剿余党中\n通关后可以在商城购买该英雄"}
_tab_stringU[18331] = {"孙尚香","讨虏将军孙权之妹，曾为左将军刘备之妻，人称孙夫人。", "在枭姬传地图包  地宫试炼中\n通关后可以免费获得"}
_tab_stringU[18332] = {"黄忠","本为刘表部下中郎将，后归刘备，并助刘备攻破益州刘璋。", "？？"}
_tab_stringU[18333] = {"马超","伏波将军马援之后，卫尉马腾之子，三国蜀汉名将。", "在剧情地图 智筑冰城中\n通关后可以免费获得"}
_tab_stringU[18334] = {"孙坚","东汉末年将领、军阀，三国中之吴国的奠基人。", "搜集400个孙坚将魂后可以解锁获得"}
_tab_stringU[18335] = {"陆逊","三国时期吴国政治家、军事家。夷陵之战中大破刘备，由此一战成名。", "在剧情地图 八阵图\n通关后可以在商城购买该英雄"}
_tab_stringU[18336] = {"司马懿","三国时期魏国政治家、军事谋略家，魏国权臣，西晋王朝的奠基人。", "在剧情地图 八阵图\n通关后可以在商城购买该英雄"}
_tab_stringU[18337] = {"大乔","孙策之妻，与小乔并称为“江东二乔。", "？？"}
_tab_stringU[18338] = {"曹丕","曹操次子，三国时期曹魏开国皇帝。", "？？"}
_tab_stringU[18340] = {"曹丕","？", "？？"}
_tab_stringU[18341] = {"孟获","三国时期南中地区的首领。", "搜集400个孟获将魂后可以解锁获得"}
_tab_stringU[18345] = {"祝融夫人","南蛮王孟获之妻，相传为火神祝融氏的后裔。", "搜集400个祝融夫人将魂后可以解锁获得"}
_tab_stringU[18346] = {"甄姬","文昭甄皇后，史称甄夫人，魏文帝曹丕的妻子，魏明帝曹叡的生母。", "搜集400个甄姬将魂后可以解锁获得"}

--船怪--20000
_tab_stringU[20000] = {"黑色斗舰","在水上活跃的巨形船怪，速度极快，船上有大炮数门，火力强大。"}

_tab_stringU[20001] = {"卧牛山寨","散发着邪恶气息的骷髅山寨，设有各种机关。"}





_tab_stringU[21001] = {"新无尽第3波水兵战船","新无尽第3波水兵战船"}
_tab_stringU[21002] = {"新无尽孔明灯据点","新无尽孔明灯据点"}
_tab_stringU[21003] = {"新无尽孔明灯","新无尽孔明灯"}
_tab_stringU[21004] = {"新无尽第9波水兵战船","新无尽第9波水兵战船"}
_tab_stringU[21005] = {"新无尽第15波水兵战船","新无尽第15波水兵战船"}
_tab_stringU[21006] = {"新无尽第21波水兵战船","新无尽第21波水兵战船"}
_tab_stringU[21007] = {"新无尽魂*黄巾流寇","新无尽魂*黄巾流寇"}
_tab_stringU[21008] = {"新无尽水兵","新无尽水兵"}
_tab_stringU[21009] = {"新无尽逃跑的乌龟","新无尽逃跑的乌龟"}
_tab_stringU[21010] = {"新无尽灯","新无尽灯"}


_tab_stringU[21021] = {"子鼠","子鼠1"}
_tab_stringU[21022] = {"丑牛","丑牛1"}
_tab_stringU[21023] = {"寅虎","寅虎1"}
_tab_stringU[21024] = {"卯兔","卯兔1"}
_tab_stringU[21025] = {"子鼠","子鼠1"}
_tab_stringU[21026] = {"丑牛","丑牛1"}
_tab_stringU[21027] = {"寅虎","寅虎1"}
_tab_stringU[21028] = {"卯兔","卯兔1"}
_tab_stringU[21029] = {"子鼠","子鼠1"}
_tab_stringU[21030] = {"丑牛","丑牛1"}
_tab_stringU[21031] = {"寅虎","寅虎1"}
_tab_stringU[21032] = {"卯兔","卯兔1"}

_tab_stringU[21040] = {"祸斗","祸斗"}
_tab_stringU[21041] = {"风伯","风伯"}
_tab_stringU[21042] = {"魂*吕布","吕布"}
_tab_stringU[21043] = {"魂*张角","张角"}
_tab_stringU[21044] = {"巨鳌","巨鳌"} --巨龟

_tab_stringU[21050] = {"塔诀晶石-速", "没有简介讷。"}
_tab_stringU[21051] = {"塔诀晶石-攻", "没有简介讷。"}
_tab_stringU[21052] = {"塔诀晶石-暴", "没有简介讷。"}
_tab_stringU[21053] = {"塔诀晶石-远", "没有简介讷。"}
_tab_stringU[21054] = {"塔诀晶石-防", "没有简介讷。"}


_tab_stringU[22010] = {"西凉枪兵","西凉枪兵"}
_tab_stringU[22011] = {"西凉重盾枪兵","西凉重盾枪兵"}
_tab_stringU[22012] = {"西凉轻骑","西凉轻骑"}
_tab_stringU[22013] = {"西凉铁骑","西凉铁骑"}
_tab_stringU[22014] = {"马超亲卫铁骑","马超亲卫铁骑"}
_tab_stringU[22015] = {"西凉弩手","西凉弩手"}
_tab_stringU[22016] = {"精英弩手","精英弩手"}
_tab_stringU[22017] = {"匈奴别类","匈奴别类"}
_tab_stringU[22018] = {"雪地天灯","雪地天灯"}

_tab_stringU[22020] = {"侯选","简介"}
_tab_stringU[22021] = {"程银","简介"}
_tab_stringU[22022] = {"李堪","简介"}
_tab_stringU[22023] = {"张横","简介"}
_tab_stringU[22024] = {"梁兴","简介"}
_tab_stringU[22025] = {"成宜","简介"}
_tab_stringU[22026] = {"马玩","简介"}
_tab_stringU[22027] = {"杨秋","简介"}
_tab_stringU[22028] = {"马岱","简介"}
_tab_stringU[22029] = {"庞德","简介"}
_tab_stringU[22030] = {"韩遂","简介"}
_tab_stringU[22031] = {"马超","简介"}
_tab_stringU[22032] = {"曹操","简介"}
_tab_stringU[22033] = {"小卒","简介"}
_tab_stringU[22034] = {"曹洪","简介"}
_tab_stringU[22035] = {"雪地据点","简介"}
_tab_stringU[22036] = {"钟繇","简介"}

_tab_stringU[22040] = {"黑暗祸斗","简介"}
_tab_stringU[22041] = {"古墓死士","简介"}
_tab_stringU[22042] = {"死士统领","简介"}
_tab_stringU[22043] = {"祸斗","简介"}
_tab_stringU[22044] = {"鸟人","简介"}
_tab_stringU[22045] = {"小卒","简介"}
_tab_stringU[22046] = {"李典","简介"}
_tab_stringU[22047] = {"乐进","简介"}
_tab_stringU[22048] = {"陆逊","简介"}
_tab_stringU[22049] = {"孔明之影","简介"}
_tab_stringU[22050] = {"黄月英","简介"}
_tab_stringU[22051] = {"孙权","简介"}
_tab_stringU[22052] = {"甘宁","简介"}
_tab_stringU[22053] = {"周泰","简介"}

_tab_stringU[30003] = {"应龙", "没有简介讷。"}
_tab_stringU[30004] = {"应龙(可控制)", ""}
_tab_stringU[30005] = {"应龙", "没有简介讷。"}
_tab_stringU[30006] = {"小凤凰", "没有简介讷。"}
_tab_stringU[30007] = {"透明攻击者1", ""}
_tab_stringU[30008] = {"透明攻击者1", ""}
_tab_stringU[30009] = {"王八快跑", "没有简介讷。"}

_tab_stringU[30011] = {"炽热的屠凉", "BOSS 1号。"}
_tab_stringU[30021] = {"极寒的屠凉", "BOSS 1号。"}
_tab_stringU[30031] = {"引力的屠凉", "BOSS 1号。"}
_tab_stringU[30041] = {"狂暴的屠凉", "BOSS 1号。"}
_tab_stringU[30051] = {"召唤的屠凉", "BOSS 1号。"}
_tab_stringU[30061] = {"聚财的屠凉", "BOSS 1号。"}
_tab_stringU[30071] = {"免控的屠凉", "BOSS 1号。"}
_tab_stringU[30081] = {"自爆的屠凉", "BOSS 1号。"}

_tab_stringU[30012] = {"炽热的恶来", "BOSS 1号。"}
_tab_stringU[30022] = {"极寒的恶来", "BOSS 1号。"}
_tab_stringU[30032] = {"引力的恶来", "BOSS 1号。"}
_tab_stringU[30042] = {"狂暴的恶来", "BOSS 1号。"}
_tab_stringU[30052] = {"召唤的恶来", "BOSS 1号。"}
_tab_stringU[30062] = {"聚财的恶来", "BOSS 1号。"}
_tab_stringU[30072] = {"免控的恶来", "BOSS 1号。"}
_tab_stringU[30082] = {"自爆的恶来", "BOSS 1号。"}

_tab_stringU[30014] = {"炽热的玄冥", "BOSS 1号。"}
_tab_stringU[30024] = {"极寒的玄冥", "BOSS 1号。"}
_tab_stringU[30034] = {"引力的玄冥", "BOSS 1号。"}
_tab_stringU[30044] = {"狂暴的玄冥", "BOSS 1号。"}
_tab_stringU[30054] = {"召唤的玄冥", "BOSS 1号。"}
_tab_stringU[30064] = {"聚财的玄冥", "BOSS 1号。"}
_tab_stringU[30074] = {"免控的玄冥", "BOSS 1号。"}
_tab_stringU[30084] = {"自爆的玄冥", "BOSS 1号。"}

_tab_stringU[30015] = {"炽热的任我缪", "BOSS 1号。"}
_tab_stringU[30025] = {"极寒的任我缪", "BOSS 1号。"}
_tab_stringU[30035] = {"引力的任我缪", "BOSS 1号。"}
_tab_stringU[30045] = {"狂暴的任我缪", "BOSS 1号。"}
_tab_stringU[30055] = {"召唤的任我缪", "BOSS 1号。"}
_tab_stringU[30065] = {"聚财的任我缪", "BOSS 1号。"}
_tab_stringU[30075] = {"免控的任我缪", "BOSS 1号。"}
_tab_stringU[30085] = {"自爆的任我缪", "BOSS 1号。"}


_tab_stringU[30016] = {"炽热的裘剑速", "BOSS 1号。"}
_tab_stringU[30026] = {"极寒的裘剑速", "BOSS 1号。"}
_tab_stringU[30036] = {"引力的裘剑速", "BOSS 1号。"}
_tab_stringU[30046] = {"狂暴的裘剑速", "BOSS 1号。"}
_tab_stringU[30056] = {"召唤的裘剑速", "BOSS 1号。"}
_tab_stringU[30066] = {"聚财的裘剑速", "BOSS 1号。"}
_tab_stringU[30076] = {"免控的裘剑速", "BOSS 1号。"}
_tab_stringU[30086] = {"自爆的裘剑速", "BOSS 1号。"}

_tab_stringU[30017] = {"炽热的洛河", "BOSS 1号。"}
_tab_stringU[30027] = {"极寒的洛河", "BOSS 1号。"}
_tab_stringU[30037] = {"引力的洛河", "BOSS 1号。"}
_tab_stringU[30047] = {"狂暴的洛河", "BOSS 1号。"}
_tab_stringU[30057] = {"召唤的洛河", "BOSS 1号。"}
_tab_stringU[30067] = {"聚财的洛河", "BOSS 1号。"}
_tab_stringU[30077] = {"免控的洛河", "BOSS 1号。"}
_tab_stringU[30087] = {"自爆的洛河", "BOSS 1号。"}

_tab_stringU[30018] = {"炽热的风后", "BOSS 1号。"}
_tab_stringU[30028] = {"极寒的风后", "BOSS 1号。"}
_tab_stringU[30038] = {"引力的风后", "BOSS 1号。"}
_tab_stringU[30048] = {"狂暴的风后", "BOSS 1号。"}
_tab_stringU[30058] = {"召唤的风后", "BOSS 1号。"}
_tab_stringU[30068] = {"聚财的风后", "BOSS 1号。"}
_tab_stringU[30078] = {"免控的风后", "BOSS 1号。"}
_tab_stringU[30088] = {"自爆的风后", "BOSS 1号。"}

_tab_stringU[30019] = {"炽热的穷奇", "BOSS 1号。"}
_tab_stringU[30029] = {"极寒的穷奇", "BOSS 1号。"}
_tab_stringU[30039] = {"引力的穷奇", "BOSS 1号。"}
_tab_stringU[30049] = {"狂暴的穷奇", "BOSS 1号。"}
_tab_stringU[30059] = {"召唤的穷奇", "BOSS 1号。"}
_tab_stringU[30069] = {"聚财的穷奇", "BOSS 1号。"}
_tab_stringU[30079] = {"免控的穷奇", "BOSS 1号。"}
_tab_stringU[30089] = {"自爆的穷奇", "BOSS 1号。"}

_tab_stringU[30020] = {"炽热的魔龙", "BOSS 1号。"}
_tab_stringU[30030] = {"极寒的魔龙", "BOSS 1号。"}
_tab_stringU[30040] = {"引力的魔龙", "BOSS 1号。"}
_tab_stringU[30050] = {"狂暴的魔龙", "BOSS 1号。"}
_tab_stringU[30060] = {"召唤的魔龙", "BOSS 1号。"}
_tab_stringU[30070] = {"聚财的魔龙", "BOSS 1号。"}
_tab_stringU[30080] = {"免控的魔龙", "BOSS 1号。"}
_tab_stringU[30090] = {"自爆的魔龙", "BOSS 1号。"}

---
_tab_stringU[30093] = {"寒冰区域", ""}
_tab_stringU[30094] = {"魔龙宝库地刺塔", ""}
_tab_stringU[30095] = {"超级地刺塔", ""}
_tab_stringU[30096] = {"超级剧毒塔", ""} --敌方单位
_tab_stringU[30097] = {"超级连弩塔", ""} --敌方单位
_tab_stringU[30098] = {"超级狙击塔", ""} --敌方单位
_tab_stringU[30099] = {"超级火焰塔", ""} --敌方单位
_tab_stringU[30100] = {"超级寒冰塔", ""} --敌方单位
_tab_stringU[30101] = {"超级天雷塔", ""} --敌方单位
_tab_stringU[30102] = {"超级巨炮塔", ""} --敌方单位
_tab_stringU[30103] = {"超级轰天塔", ""} --敌方单位
_tab_stringU[30104] = {"超级滚石塔", ""} --敌方单位
_tab_stringU[30105] = {"超级粮仓", ""} --敌方单位
_tab_stringU[30106] = {"超级擂鼓塔", ""} --敌方单位
_tab_stringU[30107] = {"超级地刺塔", ""} --敌方单位
_tab_stringU[30108] = {"剧毒塔", ""} --敌方单位
_tab_stringU[30109] = {"连弩塔", ""} --敌方单位
_tab_stringU[30110] = {"狙击塔", ""} --敌方单位
_tab_stringU[30111] = {"火焰塔", ""} --敌方单位
_tab_stringU[30112] = {"寒冰塔", ""} --敌方单位
_tab_stringU[30113] = {"天雷塔", ""} --敌方单位
_tab_stringU[30114] = {"巨炮塔", ""} --敌方单位
_tab_stringU[30115] = {"轰天塔", ""} --敌方单位
_tab_stringU[30116] = {"滚石塔", ""} --敌方单位
_tab_stringU[30117] = {"粮仓", ""} --敌方单位
_tab_stringU[30118] = {"擂鼓塔", ""} --敌方单位
_tab_stringU[30119] = {"地刺塔", ""} --敌方单位
_tab_stringU[30120] = {"魔龙宝库粮仓", ""}
_tab_stringU[30121] = {"邪灵应龙", ""}
_tab_stringU[30123] = {"吉祥猪", ""}
_tab_stringU[30124] = {"仓鼠军团1", ""}

_tab_stringU[30124] = {"仓鼠军团*火", ""}
_tab_stringU[30125] = {"仓鼠军团*林", ""}
_tab_stringU[30126] = {"仓鼠军团*风", ""}
_tab_stringU[30127] = {"仓鼠军团*山", ""}
_tab_stringU[30128] = {"仓鼠军团1", ""}
_tab_stringU[30129] = {"仓鼠军团1", ""}
_tab_stringU[30130] = {"仓鼠军团1", ""}
_tab_stringU[30131] = {"仓鼠军团1", ""}

_tab_stringU[30144] = {"刘备", ""}
_tab_stringU[30145] = {"关羽", ""}
_tab_stringU[30146] = {"张飞", ""}
_tab_stringU[30149] = {"赵云", ""}
_tab_stringU[30169] = {"水兵", ""}
_tab_stringU[30175] = {"难民", ""}
_tab_stringU[30183] = {"刘封", ""}
_tab_stringU[30184] = {"雷铜", ""}

_tab_stringU[30193] = {"擂鼓塔", ""}
_tab_stringU[30194] = {"超级擂鼓塔", ""}

_tab_stringU[30189] = {"马忠", ""}
_tab_stringU[30190] = {"吕蒙之影", ""}
_tab_stringU[30192] = {"潘璋之影", ""}
_tab_stringU[30195] = {"陆逊", ""}

_tab_stringU[30154] = {"神威营长", ""}
_tab_stringU[30185] = {"神威射手", ""}
_tab_stringU[30156] = {"重型盾步兵", ""}
_tab_stringU[30157] = {"关羽", ""}
_tab_stringU[30155] = {"重型投石车", ""}
_tab_stringU[30178] = {"关羽", ""}
_tab_stringU[30402] = {"迷你旱魃", ""}
_tab_stringU[30403] = {"蜉蝣飞机", ""}
_tab_stringU[30404] = {"二傻子", ""}
_tab_stringU[30405] = {"一粒蛋", ""}
_tab_stringU[30406] = {"东方不败", ""}
_tab_stringU[30430] = {"风暴塔", ""}
_tab_stringU[30431] = {"超级风暴塔", ""}
_tab_stringU[30434] = {"姜维", ""}
_tab_stringU[30437] = {"周芷若", ""}
_tab_stringU[30438] = {"欧阳锋", ""}
_tab_stringU[30439] = {"梅超风", ""}




_tab_stringU[30256] = {"刘备", "三国时期蜀汉开国皇帝, 与关羽, 张飞结为兄弟", ""}
_tab_stringU[30257] = {"关羽", "三国时期蜀汉重要将领, 与刘备, 张飞结为兄弟", ""}
_tab_stringU[30258] = {"张飞", "三国时期蜀汉重要将领, 与刘备, 关羽结为兄弟", ""}
_tab_stringU[30259] = {"曹操","曹魏政权的缔造者, 在政治、军事、文学上都有很高的造诣", ""}
_tab_stringU[30260] = {"太史慈","刘繇部下, 后被孙策收降, 助其扫荡江东", ""}
_tab_stringU[30261] = {"郭嘉","曹操手下重要的谋士, 为曹操统一中国北方立下了功勋", ""}
_tab_stringU[30262] = {"夏侯惇", "曹操部下大将, 同时也是曹操的同族兄弟, 骁勇善战", ""}
_tab_stringU[30263] = {"张辽","曹魏五子良将之一, 智勇双全, 南征北伐, 逍遥津一战成名", ""}
_tab_stringU[30264] = {"许褚","曹操手下猛将, 长八尺腰十围, 容貌雄毅, 勇力过人", ""}
_tab_stringU[30265] = {"典韦","曹操手下猛将, 形貌魁梧, 膂力过人, 有大志气节, 性格任侠", ""}
_tab_stringU[30266] = {"甘宁","东吴名将, 少年时因打劫来往商船而被称为【锦帆贼】", "？"}
_tab_stringU[30267] = {"孙策","东汉末年割据江东一带的军阀，汉末群雄之一，三国时期孙吴的奠基者之一。", ""}
_tab_stringU[30268] = {"周瑜","东吴四英将之一, 幼年与孙策相识, 后随孙策奔赴战场平定江东", ""}
_tab_stringU[30269] = {"徐庶", "汉末年刘备帐下谋士，后归曹操，并仕于曹魏", ""}
_tab_stringU[30270] = {"诸葛亮","三国时期蜀国的丞相，是人们心目中智慧和忠诚的代表", ""}
_tab_stringU[30271] = {"小乔","三国时期东吴绝世美女，名将周瑜的夫人", ""}
_tab_stringU[30272] = {"孙权","三国时代东吴的建立者，自幼文武双全，早年随父兄征战天下", ""}
_tab_stringU[30273] = {"貂蝉", "古代四大美女之一, 司徒王允的义女, 为拯救汉朝, 巧施连环计", ""}
_tab_stringU[30274] = {"荀彧","东汉末年著名政治家、战略家，曹操统一北方的首席谋臣和功臣。", ""}
_tab_stringU[30275] = {"贾诩","东汉末年至三国初年著名谋士、军事战略家，曹魏开国功臣。", ""}
_tab_stringU[30276] = {"马超","伏波将军马援之后，卫尉马腾之子，三国蜀汉名将。", "？"}
_tab_stringU[30277] = {"黄忠","本为刘表部下中郎将，后归刘备，并助刘备攻破益州刘璋。", "？？"}
_tab_stringU[30308] = {"章鱼怪","", ""}
_tab_stringU[30366] = {"超级机器人","", ""}

_tab_stringU[30350] = {"庞统","三国时刘备手下的重要谋士，与诸葛亮同拜为军师中郎将", ""}
_tab_stringU[30351] = {"赵云", "鬼哭与神嚎, 天惊并地惨, 常山赵子龙, 一身都是胆", ""}
_tab_stringU[30352] = {"吕布", "三国第一猛将, 坐骑赤兔宝马, 手持方天画戟, 天下无双", ""}
_tab_stringU[30353] = {"黄月英","名士黄承彦之女，诸葛亮之妻", ""}
_tab_stringU[30354] = {"董卓","东汉末年凉州军阀。掌控朝中大权。", ""}
_tab_stringU[30355] = {"孙尚香","讨虏将军孙权之妹，曾为左将军刘备之妻，人称孙夫人。", ""}
_tab_stringU[30356] = {"孙坚","东汉末年将领、军阀，三国中之吴国的奠基人。", "？？"}
_tab_stringU[30357] = {"陆逊","三国时期吴国政治家、军事家。夷陵之战中大破刘备，由此一战成名。", "？"}
_tab_stringU[30358] = {"司马懿","三国时期魏国政治家、军事谋略家，魏国权臣，西晋王朝的奠基人。", "？"}
_tab_stringU[30367] = {"超级导弹塔",""}

_tab_stringU[30370] = {"佩奇","？？", "？"}
_tab_stringU[30372] = {"乔治","？？", "？"}
--_tab_stringU[30370] = {"圣诞老人","？？", "？"} --圣诞版
--_tab_stringU[30372] = {"圣诞老人","？？", "？"} --圣诞版

_tab_stringU[30373] = {"鸟人","？？", "？"}
_tab_stringU[30374] = {"蟠龙","人形态", "？"}
_tab_stringU[30375] = {"蟠龙","龙形态", "？"}
_tab_stringU[30376] = {"旱魃","旱魃（人形态）", "？"}
_tab_stringU[30377] = {"旱魃","旱魃（旱魃形态）", "？"}
_tab_stringU[30381] = {"摸金校尉","介绍", "？"}
_tab_stringU[30382] = {"督军校尉","介绍", "？"}
_tab_stringU[30383] = {"步兵校尉","介绍", "？"}
_tab_stringU[30384] = {"胡骑校尉","介绍", "？"}
_tab_stringU[30385] = {"射身校尉","介绍", "？"}
_tab_stringU[30412] = {"孟获","介绍", "？"}
_tab_stringU[30413] = {"祝融夫人","介绍", "？"}
_tab_stringU[30423] = {"圣诞树","介绍", "？"}
_tab_stringU[30424] = {"超级圣诞树","介绍", "？"}
_tab_stringU[30428] = {"雪宝","介绍", "？"}
_tab_stringU[30429] = {"小龙女","介绍", "？"}

_tab_stringU[30999] = {"据点","守卫剑阁据点", "？"}
_tab_stringU[31000] = {"神机营","守卫剑阁军营", "？"}
_tab_stringU[31001] = {"魂*蒙恬","BOSS", "？"}
_tab_stringU[31002] = {"魂*赵高","BOSS", "？"}
_tab_stringU[31003] = {"魂*嬴政","BOSS", "？"}

_tab_stringU[31020] = {"韩德","BOSS", "？"}
_tab_stringU[31021] = {"夏侯楙","BOSS", "？"}
_tab_stringU[31022] = {"魂*张角","BOSS", "？"}
_tab_stringU[31023] = {"魂*张宝","BOSS", "？"}
_tab_stringU[31024] = {"魂*张梁","BOSS", "？"}
_tab_stringU[31025] = {"王朗","BOSS", "？"}
_tab_stringU[31026] = {"郭淮","BOSS", "？"}
_tab_stringU[31027] = {"曹真","BOSS", "？"}
_tab_stringU[31028] = {"雅丹","BOSS", "？"}
_tab_stringU[31029] = {"越吉","BOSS", "？"}
_tab_stringU[31030] = {"张合","BOSS", "？"}
_tab_stringU[31031] = {"张虎","BOSS", "？"}
_tab_stringU[31032] = {"乐琳","BOSS", "？"}
_tab_stringU[31033] = {"王双","BOSS", "？"}
_tab_stringU[31034] = {"郝昭","BOSS", "？"}
_tab_stringU[31035] = {"许仪","BOSS", "？"}
_tab_stringU[31036] = {"钟会","BOSS", "？"}
_tab_stringU[31037] = {"邓艾","BOSS", "？"}
_tab_stringU[31038] = {"魂*吕布","BOSS", "？"}
_tab_stringU[31039] = {"司马师","BOSS", "？"}
_tab_stringU[31040] = {"司马昭","BOSS", "？"}
_tab_stringU[31041] = {"司马懿","BOSS", "？"}
_tab_stringU[31042] = {"南华老仙","BOSS", "？"}
_tab_stringU[31043] = {"邓忠","BOSS", "？"}


_tab_stringU[31050] = {"野怪1","野怪", "？"}
_tab_stringU[31051] = {"野怪1","野怪", "？"}
_tab_stringU[31052] = {"野怪1","野怪", "？"}
_tab_stringU[31053] = {"野怪1","野怪", "？"}
_tab_stringU[31054] = {"野怪1","野怪", "？"}
_tab_stringU[31055] = {"野怪1","野怪", "？"}
_tab_stringU[31056] = {"野怪1","野怪", "？"}
_tab_stringU[31057] = {"野怪1","野怪", "？"}
_tab_stringU[31058] = {"野怪1","野怪", "？"}
_tab_stringU[31059] = {"金甲卫士首领","野怪", "？"}

_tab_stringU[31060] = {"祸斗","神兽", "？"}
_tab_stringU[31061] = {"风伯","神兽", "？"}
_tab_stringU[31062] = {"帝江","神兽", "？"}
_tab_stringU[31063] = {"黄龙","神兽", "？"}
_tab_stringU[31064] = {"玄龟","神兽", "？"}
_tab_stringU[31065] = {"凤凰","神兽", "？"}

_tab_stringU[31066] = {"祸斗","神兽", "？"}
_tab_stringU[31067] = {"风伯","神兽", "？"}
_tab_stringU[31068] = {"帝江","神兽", "？"}
_tab_stringU[31069] = {"黄龙","神兽", "？"}
_tab_stringU[31070] = {"玄龟","神兽", "？"}
_tab_stringU[31071] = {"凤凰","神兽", "？"}

_tab_stringU[31205] = {"市场","守卫剑阁市场", "？"}

_tab_stringU[31210] = {"祸斗","神兽", "？"}
_tab_stringU[31211] = {"风伯","神兽", "？"}
_tab_stringU[31212] = {"帝江","神兽", "？"}
_tab_stringU[31213] = {"黄龙","神兽", "？"}
_tab_stringU[31214] = {"玄龟","神兽", "？"}
_tab_stringU[31215] = {"凤凰","神兽", "？"}
_tab_stringU[31216] = {"武侯之魂","武侯之魂", "？"}
_tab_stringU[31217] = {"神秘商人","？？？", "？"}

_tab_stringU[39001] = {"圣火使者", "BOSS 1号。"}
_tab_stringU[39002] = {"光辉使者", "BOSS 1号。"}
_tab_stringU[39003] = {"刺杀使者", "BOSS 1号。"}
_tab_stringU[39004] = {"防御圣使", "BOSS 1号。"}
_tab_stringU[39005] = {"疯狂猎手", "BOSS 1号。"}
_tab_stringU[39006] = {"冰霜使者", "BOSS 1号。"}
_tab_stringU[39007] = {"陷阱大师", "BOSS 1号。"}

_tab_stringU[39008] = {"风神", "BOSS 1号。"}

_tab_stringU[39009] = {"魑", "BOSS 1号。"}
_tab_stringU[39010] = {"魅", "BOSS 1号。"}
_tab_stringU[39011] = {"魍", "BOSS 1号。"}
_tab_stringU[39012] = {"魉", "BOSS 1号。"}

_tab_stringU[39013] = {"新无尽爆裂力士", "新无尽爆裂力士"}
_tab_stringU[39014] = {"新无尽霹雳车", "新无尽霹雳车"}
_tab_stringU[39015] = {"新无尽自爆蝙蝠1", "新无尽自爆蝙蝠1"}
_tab_stringU[39016] = {"新无尽隐身先登死士", "新无尽隐身先登死士"}
_tab_stringU[39017] = {"新无尽铁甲卫", "新无尽铁甲卫"}
_tab_stringU[39018] = {"新无尽自爆蝙蝠2", "新无尽自爆蝙蝠2"}
_tab_stringU[39019] = {"魅", "魅"}
_tab_stringU[39020] = {"年兽", "BOSS 1号。"}
_tab_stringU[39021] = {"南华仙尊", "南华仙尊"}
_tab_stringU[39050] = {"溶火地牢1", "溶火地牢1"}
_tab_stringU[39051] = {"溶火地牢2", "溶火地牢2"}
_tab_stringU[39052] = {"溶火地牢3", "溶火地牢3"}
_tab_stringU[39053] = {"溶火地牢4", "溶火地牢4"}
_tab_stringU[39057] = {"敌方轰天塔", "敌方轰天塔"}
_tab_stringU[39058] = {"敌方滚石塔1", "敌方滚石塔1"}
_tab_stringU[39059] = {"敌方狙击塔", "敌方狙击塔"}
_tab_stringU[39060] = {"自爆蝙蝠", "自爆蝙蝠"}
_tab_stringU[39061] = {"刀阵飞刃（慢）", "刀阵飞刃（慢）"}
_tab_stringU[39062] = {"刀阵飞刃（快）", "刀阵飞刃（快）"}
_tab_stringU[39063] = {"轰天塔", "轰天塔"}
_tab_stringU[39064] = {"狙击塔", "狙击塔"}
_tab_stringU[39065] = {"滚石塔", "滚石塔"}
_tab_stringU[39066] = {"地刺塔", "地刺塔"}
_tab_stringU[39067] = {"轰天塔塔基", "轰天塔塔基"}
_tab_stringU[39068] = {"狙击塔塔基", "狙击塔塔基"}
_tab_stringU[39069] = {"滚石塔塔基", "滚石塔塔基"}
_tab_stringU[39070] = {"地刺塔塔基", "地刺塔塔基"}
_tab_stringU[39071] = {"孔明灯", "孔明灯"}
_tab_stringU[39072] = {"死侍", "死侍"}
_tab_stringU[39073] = {"骑兵", "骑兵"}
_tab_stringU[39074] = {"铁甲卫", "铁甲卫"}
_tab_stringU[39075] = {"王八", "王八"}
_tab_stringU[39076] = {"黄巾流寇", "黄巾流寇"}
_tab_stringU[39077] = {"虎豹骑", "虎豹骑"}
_tab_stringU[39078] = {"凤凰", "凤凰"}
_tab_stringU[39079] = {"小凤凰", "小凤凰"}
_tab_stringU[39080] = {"透明塔", "透明塔"}
_tab_stringU[39081] = {"黄月英", "黄月英"}
_tab_stringU[39082] = {"关羽", "关羽"}
_tab_stringU[39054] = {"黑暗玄武", "黑暗玄武"}
_tab_stringU[39055] = {"黑翼魔王", "黑翼魔王"}
_tab_stringU[39056] = {"黑暗力士", "黑暗力士"}
_tab_stringU[39075] = {"黑暗祸斗", "黑暗祸斗"}
_tab_stringU[39083] = {"敌方地刺塔", "敌方地刺塔"}
_tab_stringU[39084] = {"敌方滚石塔2", "敌方滚石塔2"}
_tab_stringU[39085] = {"守门小兵", "守门小兵"}
_tab_stringU[39086] = {"幻境守卫", "幻境守卫"}
_tab_stringU[39087] = {"幻境守卫", "幻境守卫"}
_tab_stringU[39088] = {"左慈", "左慈"}
_tab_stringU[39089] = {"关羽", "关羽"}
_tab_stringU[39090] = {"远程守门小兵", "远程守门小兵"}
_tab_stringU[39091] = {"黄月英", "黄月英"}
_tab_stringU[30092] = {"召唤的小兵", "召唤的小兵"}
_tab_stringU[39096] = {"新手塔基", "新手塔基"}
_tab_stringU[39097] = {"新手骑兵", "新手骑兵"}
_tab_stringU[39098] = {"郭石", "郭石"}
_tab_stringU[39099] = {"新手铁甲卫", "新手铁甲卫"}
_tab_stringU[39100] = {"管亥", "管亥"}
_tab_stringU[39101] = {"天关塔诀", "天关塔诀"}
_tab_stringU[39102] = {"新手黄巾流寇", "新手黄巾流寇"}
_tab_stringU[39103] = {"新手狼", "新手狼"}
_tab_stringU[39104] = {"新手黄巾弓手", "新手黄巾弓手"}
_tab_stringU[39105] = {"燃烧的火堆", "燃烧的火堆"}
_tab_stringU[39107] = {"测试盾兵", "测试盾兵"}








_tab_stringU[41000] = {"府邸1级","每天获得税收：%provide%金钱","每天获得税收：%provide%金钱"}
_tab_stringU[41001] = {"府邸2级","每天获得税收：%provide%金钱","每天获得税收：%provide%金钱"}
_tab_stringU[41002] = {"府邸3级","每天获得税收：%provide%金钱","每天获得税收：%provide%金钱"}
_tab_stringU[41005] = {"府邸1级","每天获得税收：%provide%金钱","每天获得税收：%provide%金钱"}
_tab_stringU[41006] = {"府邸2级","每天获得税收：%provide%金钱","每天获得税收：%provide%金钱"}
_tab_stringU[41007] = {"府邸3级","每天获得税收：%provide%金钱","每天获得税收：%provide%金钱"}
_tab_stringU[41010] = {"府邸1级","每天获得税收：%provide%金钱","每天获得税收：%provide%金钱"}
_tab_stringU[41011] = {"府邸2级","每天获得税收：%provide%金钱","每天获得税收：%provide%金钱"}
_tab_stringU[41012] = {"府邸3级","每天获得税收：%provide%金钱","每天获得税收：%provide%金钱"}
_tab_stringU[41015] = {"翰林院1级","可以学习1级的阵法"}
_tab_stringU[41016] = {"翰林院2级","可以学习2级的阵法"}
_tab_stringU[41017] = {"翰林院3级","可以学习3级的阵法"}
_tab_stringU[41020] = {"翰林院1级","可以学习1级的阵法"}
_tab_stringU[41021] = {"翰林院2级","可以学习2级的阵法"}
_tab_stringU[41022] = {"翰林院3级","可以学习3级的阵法"}
_tab_stringU[41025] = {"翰林院1级","可以学习1级的阵法"}
_tab_stringU[41026] = {"翰林院2级","可以学习2级的阵法"}
_tab_stringU[41027] = {"翰林院3级","可以学习3级的阵法"}
_tab_stringU[41030] = {"军营","可以训练出朴刀兵"}
_tab_stringU[41031] = {"高级军营","可以训练出刀盾兵"}
_tab_stringU[41035] = {"马厩","可以训练出轻骑兵"}
_tab_stringU[41036] = {"高级马厩","可以训练出重骑兵"}
_tab_stringU[41040] = {"靶场","可以训练出弓手"}
_tab_stringU[41041] = {"高级靶场","可以训练出神射手"}
_tab_stringU[41045] = {"民居","提升每周能生产的士兵数量"}
_tab_stringU[41050] = {"农田","每天获得粮食%provide%"}
_tab_stringU[41051] = {"梯田","每天获得粮食%provide%"}
_tab_stringU[41052] = {"渔船","每天获得粮食%provide%"}
_tab_stringU[41055] = {"兵工坊","可以生产投石车和弩车"}
_tab_stringU[41056] = {"神匠工坊","可以生产霹雳车和三弓床弩"}
_tab_stringU[41060] = {"箭楼","每修建一个新的箭楼，就会提升城池的箭楼威力"}
_tab_stringU[41061] = {"箭楼","每修建一个新的箭楼，就会提升城池的箭楼威力"}
_tab_stringU[41062] = {"箭楼","每修建一个新的箭楼，就会提升城池的箭楼威力"}
_tab_stringU[41063] = {"箭楼","每修建一个新的箭楼，就会提升城池的箭楼威力"}
_tab_stringU[41064] = {"箭楼","每修建一个新的箭楼，就会提升城池的箭楼威力"}
_tab_stringU[41065] = {"观星台1级","可以训练出术士和方士"}
_tab_stringU[41066] = {"观星台2级","可以训练出妖术师和仙术师"}
_tab_stringU[41070] = {"客栈","可以在此招募和复活武将"}
_tab_stringU[41071] = {"市集","可以在此进行资源交易"}
_tab_stringU[41072] = {"寺庙","每周会产生随机资源，使驻守城池的武将每天结束时恢复生命值和法力值"}
_tab_stringU[41073] = {"城楼","提高城池的防御能力"}
_tab_stringU[41074] = {"城楼","提高城池的防御能力"}
_tab_stringU[41075] = {"城楼","提高城池的防御能力"}
_tab_stringU[41076] = {"兵工坊","可以生产投石车和弩车"}
_tab_stringU[41077] = {"神匠工坊","可以生产霹雳车和三弓床弩"}
_tab_stringU[41078] = {"观星台1级","可以训练出术士和方士"}
_tab_stringU[41079] = {"观星台2级","可以训练出妖术师和仙术师"}
_tab_stringU[41080] = {"雇佣营地","制造和升级各种防御设施"}
_tab_stringU[41100] = {"铁甲营","可以训练出铁甲卫"}
_tab_stringU[41101] = {"虎卫营","可以训练出虎卫"}
_tab_stringU[41105] = {"虎狼营","可以训练出虎狼骑"}
_tab_stringU[41106] = {"虎豹营","可以训练出虎豹骑"}
_tab_stringU[41110] = {"铜雀台","可以召唤炎雀"}
_tab_stringU[41111] = {"朱雀台","可以召唤圣兽朱雀"}
_tab_stringU[41120] = {"战象营","可以训练出战象"}
_tab_stringU[41121] = {"巨象营","可以训练出巨象"}
_tab_stringU[41125] = {"连弩营","可以训练出连弩手"}
_tab_stringU[41126] = {"无当营","可以训练出无当飞军"}
_tab_stringU[41130] = {"盘龙崖","可以召唤黄龙"}
_tab_stringU[41131] = {"青龙崖","可以召唤圣兽青龙"}
_tab_stringU[41140] = {"祈雨坛","可以训练出符咒师"}
_tab_stringU[41141] = {"七星坛","可以训练出散仙"}
_tab_stringU[41145] = {"水鬼营","可以训练出鳞甲水兵"}
_tab_stringU[41146] = {"青蛟营","可以训练出青蛟水兵"}
_tab_stringU[41150] = {"玄龟池","可以召唤玄龟"}
_tab_stringU[41151] = {"玄武池","可以召唤圣兽玄武"}
_tab_stringU[11999] = {"陶晶","测试用单位"}
_tab_stringU[41152] = {
	"",
	"占领后可以提升5点随机属性",
	"您的武将@visitor@占领了@target@，能力得到提升。",
	"您已经访问过这里了，请到别处去吧！",
	"不能再提升了！",
}
_tab_stringU[41153] = {
	"",
	"占领后可以提升20点随机属性",
	"您的武将@visitor@占领了@target@，能力得到提升。",
	"您已经访问过这里了，请到别处去吧！",
	"不能再提升了！",
}

_tab_stringU[41154] = {"玄武池","可以召唤圣兽玄武"}
_tab_stringU[41155] = {"青龙崖","可以召唤圣兽青龙"}
_tab_stringU[41156] = {"朱雀台","可以召唤圣兽朱雀"}
_tab_stringU[41157] = {"村落","可以招募农民。\n农民可被特定英雄训练为特殊兵种。",""," "," "}
_tab_stringU[41158] = {"山寨","可以招募山贼。\n山贼可被特定英雄训练为特殊兵种。",""," "," "}
_tab_stringU[41159] = {"七星坛","可以训练出散仙"}
_tab_stringU[41160] = {"观星台","可以训练出妖术师和仙术师"}
_tab_stringU[41162] = {"宫殿","占领后可以随机或者金钱或者粮食","您的武将@visitor@占领了@target@。","您已经访问过这里了，请到别处去吧！","无法再获得了！"}
_tab_stringU[41164] = {"高级马厩","可以训练出重骑兵"}
_tab_stringU[41165] = {"神匠工坊","可以生产霹雳车和三弓床弩"}
_tab_stringU[41166] = {"七星坛","可以训练出散仙"}
_tab_stringU[41167] = {"巨象营","可以训练出巨象"}
_tab_stringU[41168] = {"虎豹营","可以训练出虎豹骑"}
_tab_stringU[41169] = {"虎卫营","可以训练出虎卫"}
_tab_stringU[41170] = {"高级军营","可以训练出刀盾兵"}
_tab_stringU[41171] = {"高级靶场","可以训练出神射手"}
_tab_stringU[41172] = {"玄龟池","可以召唤玄龟"}

------------非正式图兵营41300-41400
_tab_stringU[41300] = {"紫狼穴","可以召唤亚圣兽紫狼王"}
_tab_stringU[41301] = {"紫狼穴","可以召唤亚圣兽紫狼王"}

_tab_stringU[42000] = {"黄金","一堆黄金"," "," "," "}
_tab_stringU[42001] = {"粮食","一堆粮食"," "," "," "}
_tab_stringU[42002] = {"粮食","一堆粮食"," "," "," "}
_tab_stringU[42003] = {"木材","一堆木材"," "," "," "}
_tab_stringU[42004] = {"石料","一堆石料"," "," "," "}
_tab_stringU[42005] = {"镔铁","一堆镔铁"," "," "," "}
_tab_stringU[42006] = {"宝石","一颗宝石"," "," "," "}
_tab_stringU[42007] = {"幸存者","随机获得各种奖励","你从水中救起一个幸存者，他对你万分感激！"," "," "}
_tab_stringU[42008] = {"漂浮物","随机获得资源","你从水中搜索到了一堆漂浮物，仔细检查发现里面居然有需要的资源。"," "," "}
_tab_stringU[42009] = {"黄金","一堆黄金"," "," "," "}
_tab_stringU[42010] = {"木材","一堆木材"," "," "," "}
_tab_stringU[42011] = {"神秘宝箱","开启可获得神秘奖励","你从水中发现了一个年代久远的宝箱，打开之后您学会了新的技能。"," "," "}


_tab_stringU[42100] = {"青铜宝藏","500金","你的武将@visitor@拾取了一个青铜宝藏，请从以下奖励中选择一项。"," "," "}
_tab_stringU[42101] = {"白银宝藏","1000金","你的武将@visitor@拾取了一个白银宝藏，请从以下奖励中选择一项。"," "," "}
_tab_stringU[42102] = {"黄金宝藏","2000金","你的武将@visitor@拾取了一个黄金宝藏，请从以下奖励中选择一项。"," "," "}
_tab_stringU[42103] = {"武力宝石","增加2点武力，所提升的属性只限当前关卡","你的武将@visitor@获得了一个火欧泊，@visitor@的武力提升了！"," "," "}
_tab_stringU[42104] = {"防御宝石","增加2点防御，所提升的属性只限当前关卡","你的武将@visitor@获得了一个翡翠，@visitor@的防御提升了！"," "," "}
_tab_stringU[42105] = {"智力宝石","增加2点智力，所提升的属性只限当前关卡","你的武将@visitor@获得了一个海蓝宝石，@visitor@的智力提升了！"," "," "}
_tab_stringU[42106] = {"体质宝石","增加2点体质，所提升的属性只限当前关卡","你的武将@visitor@获得了一个田黄，@visitor@的体质提升了！"," "," "}
_tab_stringU[42107] = {"统率宝石","增加2点统率，所提升的属性只限当前关卡","你的武将@visitor@获得了一个紫晶，@visitor@的统率提升了！"," "," "}
_tab_stringU[42108] = {"全属性宝石","增加1点全属性，所提升的属性只限当前关卡","你的武将@visitor@获得了一个五彩石，@visitor@的全属性提升了！"," "," "}
_tab_stringU[42109] = {"经验果","增加100点经验值，所提升的属性只限当前关卡","你的武将@visitor@获得了一个经验果，@visitor@的经验值提升了！"," "," "}
_tab_stringU[42110] = {"鸡腿","恢复10％生命值","你的武将@visitor@拾到一只鸡腿，@visitor@的生命值恢复了","",""}
_tab_stringU[42111] = {"包子","恢复30％生命值","你的武将@visitor@拾到一盘包子，@visitor@的生命值恢复了","",""}
_tab_stringU[42112] = {"神行果","增加50点大地图移动力，所提升的属性只限当前关卡","你的武将@visitor@获得了一个神行果，@visitor@能走的更远了！"," "," "}
_tab_stringU[42113] = {"天遁石","增加500点大地图移动力，所提升的属性只限当前关卡","你的武将@visitor@获得了一个天遁石，@visitor@能走的更远了！"," "," "}

_tab_stringU[42114] = {"温酒","增加10点武力，恢复100％生命，所提升的属性只限当前关卡","你的武将@visitor@属性增加，@visitor@的生命值恢复了！"," "," "}
_tab_stringU[42115] = {"酒","增加5点武力，恢复50％生命，所提升的属性只限当前关卡","你的武将@visitor@属性增加，@visitor@的生命值恢复了！"," "," "}
_tab_stringU[42116] = {"圣石","增加10点全属性，所提升的属性只限当前关卡","你的武将@visitor@获得了一个圣石，@visitor@的全属性提升了！"," "," "}
_tab_stringU[42117] = {"遁石","增加200点大地图移动力，所提升的属性只限当前关卡","你的武将@visitor@获得了一个遁石，@visitor@能走的更远了！"," "," "}
_tab_stringU[42118] = {"包子","恢复50％生命和法力","你的武将@visitor@获得了一盘包子，@visitor@你的生命和法力恢复了！"," "," "}

_tab_stringU[43000] = {"金矿洞","占领后，它将每天为你提供%provide%金钱","你的武将@visitor@占领了一座金矿，它将每天为你提供%provide%金钱"," "," "}
_tab_stringU[43001] = {"农场","占领后，它将每天为你提供%provide%食物","你的武将@visitor@占领了一个农场，它将每天为你提供%provide%食物"," ","","粮食是招募士兵所需的基本资源之一。"}
_tab_stringU[43002] = {"伐木场","占领后，它将每天为你提供%provide%木材","你的武将@visitor@占领了一个伐木场，它将每天为你提供%provide%木材"," ","","木材是建造城池设施时所需要的基本资源之一，也是建造攻城单位和招募高等兵种所需要的资源。"}
_tab_stringU[43003] = {"采石场","占领后，它将每天为你提供%provide%石材","你的武将@visitor@占领了一个采石场，它将每天为你提供%provide%石材"," ","","石材是建造城池设施时所需要的基本资源之一，也是建造攻城单位和招募高等兵种所需要的资源。"}
_tab_stringU[43004] = {"铁矿洞","占领后，它将每天为你提供%provide%镔铁","你的武将@visitor@占领了一个铁矿洞，它将每天为你提供%provide%镔铁"," ","","镔铁是建设城池的高级资源，也是建造一些高等兵种所需要的资源。"}
_tab_stringU[43005] = {"宝石矿洞","占领后，它将每天为你提供%provide%宝石","你的武将@visitor@占领了一个宝石矿洞，它将每天为你提供%provide%宝石"," "," "}
_tab_stringU[43006] = {"残破的府邸","占领后，它将每天为你提供%provide%金钱","你的武将@visitor@占领了一座府邸，它将每天为你提供%provide%金钱"," "," "}
_tab_stringU[43007] = {"渔船","占领后，它将每天为你提供%provide%食物","你的武将@visitor@占领了一个渔船，它将每天为你提供%provide%食物"," ","","粮食是招募士兵所需的基本资源之一。"}

_tab_stringU[43100] = {"村落","可以招募农民。\n农民可被特定英雄训练为特殊兵种。",""," "," "}
_tab_stringU[43101] = {"山寨","可以招募山贼。\n山贼可被特定英雄训练为特殊兵种。",""," "," "}
_tab_stringU[43102] = {"驯兽师","可以招募野狼。",""," "," "}
_tab_stringU[43103] = {"水贼营","可以招募水贼。\n水贼可被特定英雄训练为特殊兵种。",""," "," "}
_tab_stringU[43104] = {"靶场","可以招募弓手。",""," "," "}
_tab_stringU[43105] = {"高级靶场","可以招募神射手。",""," "," "}
_tab_stringU[43200] = {"神像","访问后可以获得一个随机的属性奖励，每个英雄只能访问一次","你的武将@visitor@无意间靠近了这座神像，它缓缓低下头，从眼中射出光芒；@visitor@从光芒所展现的画面中学会了许多知识！","你的武将@visitor@再次来到神像旁边，但是神像只是静静的矗立在那里…","你无法再次获得奖励！"}
_tab_stringU[43201] = {"演武场","访问后可以选择提升10点武力或体质，每个英雄只能访问一次","你的武将@visitor@来到了这个演武场，与里面的师傅进行了切磋。经过训练，@visitor@的能力有了明显的提升！","你的武将@visitor@再次来到这个演武场，想要学习更多的武艺，但武馆师傅表示已经没什么可以教他的了。","你无法再次获得奖励！"}
_tab_stringU[43202] = {"哨塔","访问后可以提升10点防御，每个英雄只能访问一次","你的武将@visitor@来到这座哨塔内，遇到了一位闻名已久的老将军，他向@visitor@讲述了许多军队防守之道。","你的武将@visitor@再次来到这座哨塔内，但老将军已经不知去向了。","你无法再次获得奖励！"}
_tab_stringU[43203] = {"凉亭","访问后可以提升10点智力，每个英雄只能访问一次","你的武将@visitor@来到一个凉亭，看到一老一少正在对弈，他旁观许久，终于有所顿悟。","你的武将@visitor@再次来到凉亭，对弈之人已不知去向，只剩下一张空棋盘。","你无法再次获得奖励！"}
_tab_stringU[43204] = {"神庙","访问后可以提升10点随机属性，每个英雄只能访问一次","你的武将@visitor@来到了一座神庙，参拜了庙里的佛像，似乎受到了神灵的祝福。","你的武将@visitor@再次来到这座神庙，想要获得神灵的祝福，但是庙宇的门紧锁着。","你无法再次获得奖励！"}
_tab_stringU[43205] = {"废弃的军营","访问后可以提升10点统率，每个英雄只能访问一次","你的武将@visitor@来到一个废弃的军营，拾到一本残缺不全的兵法书，领悟了许多带兵打仗的方法","你的武将@visitor@进入废弃的军营，剩下的文字已经模糊不清，再也没有什么可以领悟的了。","你无法再次获得奖励！"}
_tab_stringU[43206] = {"古井","访问后可以恢复100％法力值，每周只可访问一次","你的武将@visitor@喝了古井的水，感到一阵清凉，法力值恢复了！","井水已经干涸了！","请下周再来吧！"}
_tab_stringU[43207] = {"水车","访问后可以获得5木材、5石材、5镔铁，每周只能访问一次","大人这是我们这周的收成，希望大人满意。","大人，我们暂时无法提供钱粮了！","请下周再来吧！"}
_tab_stringU[43208] = {"寺庙","访问后可以随机获得一种资源","大人这是我们这周的供奉，希望大人满意。","大人，我们暂时无法进贡了！","请下周再来吧！"}
_tab_stringU[43209] = {"市集","可以进行资源交易"," "," "," "}
_tab_stringU[43210] = {"帐篷","访问后可以恢复100％生命值，每周只能访问一次","你的武将@visitor@进入帐篷休息，美美的睡上了一觉，生命值恢复了！","你的武将@visitor@进入帐篷想要休息，但外面喧闹的声音使其无法入睡！","请下周再来吧！"}
_tab_stringU[43211] = {"昆仑镜","通过这里可以跳转到另一个地点"," "," "," "}
_tab_stringU[43212] = {"摊贩","访问后可以获得150食物和500黄金","大人这是我们这周的供奉，希望大人满意。","大人，我们暂时无法进贡了！","请下周再来吧！"}
_tab_stringU[43213] = {"古井","这是一口干枯的古井"," "," "," "}
_tab_stringU[43216] = {"码头","可以乘坐战船或者上岸。"," "," "," "}
_tab_stringU[43217] = {"城墙","防御工事。"," "," "," "}
_tab_stringU[43218] = {"城墙","防御工事。"," "," "," "}
_tab_stringU[43219] = {"城墙","防御工事。"," "," "," "}
_tab_stringU[43220] = {"城墙","防御工事。"," "," "," "}
_tab_stringU[43220] = {"城墙","散发着神奇的光的城墙。"," "," "," "}
_tab_stringU[43221] = {"城墙","散发着神奇的光的城墙。"," "," "," "}
_tab_stringU[43222] = {"城墙","散发着神奇的光的城墙。"," "," "," "}
_tab_stringU[43223] = {"城墙","散发着神奇的光的城墙。"," "," "," "}
_tab_stringU[43224] = {"城墙","散发着神奇的光的城墙。"," "," "," "}
_tab_stringU[43225] = {"城墙","散发着神奇的光的城墙。"," "," "," "}
_tab_stringU[43226] = {"城墙","散发着神奇的光的城墙。"," "," "," "}
_tab_stringU[43229] = {"蓝玲珑塔","访问后可以恢复100％法力值，每周只可访问一次","你的武将@visitor@喝了蓝玲珑塔里的水，感到一阵清凉，法力值恢复了！","蓝玲珑塔里的水已经干涸了！","请下周再来吧！"}
_tab_stringU[43230] = {"红玲珑塔","访问后可以恢复100％生命值，每周只可访问一次","你的武将@visitor@喝了红玲珑塔里的水，感到一阵清凉，生命值恢复了！","红玲珑塔里的水已经干涸了！","请下周再来吧！"}


_tab_stringU[49017] = {"火之结界","强大的结界阻挡了你的去路，打败主将可以消除结界！"," "," "," "}
_tab_stringU[49018] = {"风之结界","强大的结界阻挡了你的去路，打败主将可以消除结界！"," "," "," "}
_tab_stringU[49019] = {"水之结界","强大的结界阻挡了你的去路，打败主将可以消除结界！"," "," "," "}
_tab_stringU[49020] = {"土之结界","强大的结界阻挡了你的去路，打败主将可以消除结界！"," "," "," "}

_tab_stringU[50168] = {"TD地牢图-castle_dark_03", "TD地牢图-castle_dark_03"}

_tab_stringU[50188] = {"dengzhu01","dengzhu01"}
_tab_stringU[50189] = {"qinglong","qinglong"}
_tab_stringU[50190] = {"castle_dark_03_02","castle_dark_03_02"}
_tab_stringU[50191] = {"TD地牢图-castle_dark_09", "TD地牢图-castle_dark_09"}
_tab_stringU[50192] = {"dilie01(小)","dilie01(小)"}
_tab_stringU[50193] = {"dilie02(小)","dilie02(小)"}
_tab_stringU[50194] = {"castle_dark_03","castle_dark_03"}


_tab_stringU[55555] = {"我方复活旗子", "我方复活旗子"}
_tab_stringU[55556] = {"敌方复活旗子", "敌方复活旗子"}


-----------------------------------------
-----------主界面专用建筑----------------
----------------------------------------------------------

_tab_stringU[60000] = {"成就","查看我获得的成就"," "," "," "}
_tab_stringU[60001] = {"点将台","查看我拥有的英雄卡片"," "," "," "}
_tab_stringU[60002] = {"奖励","查看任务完成情况"," "," "," "}
_tab_stringU[60003] = {"战术卡片","查看我拥有的战术卡片"," "," "," "}
_tab_stringU[60004] = {"VIP","进入VIP地图专区"," "," "," "}
_tab_stringU[60005] = {"剧情战役","进入关卡选择"," "," "," "}


--_tab_stringU[60006] = {"桃园结义"," "," "," "," "}
--_tab_stringU[60007] = {"小试牛刀"," "," "," "," "}
--_tab_stringU[60008] = {"龙城飞将"," "," "," "," "}
--_tab_stringU[60009] = {"铜雀台"," "," "," "," "}
--_tab_stringU[60010] = {"返回主菜单"," "," "," "," "}
_tab_stringU[60011] = {"挑战模式",""," "," "," "}
_tab_stringU[60012] = {"商店",""," "," "," "}
_tab_stringU[60013] = {"赤壁之战",""," "," "," "}
_tab_stringU[60014] = {"信箱",""," "," "," "}
_tab_stringU[60015] = {"设置",""," "," "," "}
_tab_stringU[60016] = {"竞技场",""," "," "," "}


_tab_stringU[69001] = {"弓箭塔","射的快,补刀强"}
_tab_stringU[69002] = {"投石塔","炸的多,清兵爽"}
_tab_stringU[69003] = {"闪电塔","伤的高,弹射狂"}
_tab_stringU[69004] = {"减速塔","冻的住,控场良"}
_tab_stringU[69005] = {"狙击塔","打的远,狙击王"}

_tab_stringU[69995] = {"无尽地图塔基", "用来建造箭塔、法术塔、炮塔、特种塔。"}
_tab_stringU[69996] = {"废弃的塔基", "修整后才能建造塔"}
_tab_stringU[69997] = {"塔基", "用来建造箭塔、法术塔、炮塔、特种塔。"}


_tab_stringU[70001] = {"TD路点-起点-显示", "TD路点-起点-显示"}



-------军团专用--80000----89999-----
_tab_stringU[80058] = {"农田","每天可获得一定数量的粮食","建造成功后每天可获得#FOOD粮食","每天可获得"}
_tab_stringU[80062] = {"民居","军团等级越高，能容纳的成员上限也越高","建造成功后可容纳#MEMBERS名成员","军团可容纳成员"}
_tab_stringU[80063] = {"伐木场","每天可获得一定数量的木材","建造成功后每天可获得#WOOD木材","每天可获得"}
_tab_stringU[80065] = {"铁矿洞","每天可获得一定数量的铁矿","建造成功后每天可获得#IRON铁矿","每天可获得"}
_tab_stringU[80066] = {"市场","军团专属道具兑换处","建造成功后可兑换军团专属道具","可兑换军团专属道具"}
_tab_stringU[80067] = {"兵工坊","普通战术卡产出基地","建造成功后可兑换军团战术卡","可兑换军团战术卡"}
_tab_stringU[80068] = {"主城","2","建造成功后军团成员每天获得#COIN游戏币","军团成员每天完成以下任务后可领取军饷",}
_tab_stringU[80069] = {"翰林院","给军团成员在战斗地图中提供各种战术技能加成","建造军团功能建筑，需要的前置科技","建造军团功能建筑，需要的前置科技"}

_tab_stringU[80203] = {"渔船","每天可获得一定数量的粮食","建造成功后每天可获得#FOOD粮食","每天可获得"}
_tab_stringU[80207] = {"寺庙","军团每天可从粮食、木材、铁矿随机获得一种资源","建造成功后每天随机获得#FOOD个资源","每天随机获得"}

_tab_stringU[80208] = {"玄龟池","吴国高级战术卡产出基地","建造成功后可兑换吴国专属军团战术卡","可兑换吴国军团专属战术卡"}
_tab_stringU[80209] = {"盘龙崖","蜀国高级战术卡产出基地","建造成功后可兑换蜀国专属军团战术卡","可兑换蜀国军团专属战术卡"}
_tab_stringU[80210] = {"铜雀台","魏国高级战术卡产出基地","建造成功后可兑换魏国专属军团战术卡","可兑换魏国军团专属战术卡"}





--擂鼓塔
_tab_stringU[90000] = {"擂鼓塔", "没有攻击力。但是能使周围友方塔和英雄获得增益。"}
_tab_stringU[90001] = {"擂鼓塔", "没有攻击力。但是能使周围友方塔和英雄获得增益。"}
_tab_stringU[90002] = {"擂鼓塔", "没有攻击力。但是能使周围友方塔和英雄获得增益。"}
_tab_stringU[90003] = {"擂鼓塔", "没有攻击力。但是能使周围友方塔和英雄获得增益。"}
_tab_stringU[90004] = {"擂鼓塔", "没有攻击力。但是能使周围友方塔和英雄获得增益。"}

--地刺塔
_tab_stringU[90005] = {"地刺塔", "每次攻击穿出4道尖刺，每道尖刺对地面造成小范围群伤。"}
_tab_stringU[90006] = {"地刺塔", "每次攻击穿出4道尖刺，每道尖刺对地面造成小范围群伤。"}
_tab_stringU[90007] = {"地刺塔", "每次攻击穿出4道尖刺，每道尖刺对地面造成小范围群伤。"}
_tab_stringU[90008] = {"地刺塔", "每次攻击穿出4道尖刺，每道尖刺对地面造成小范围群伤。"}
_tab_stringU[90009] = {"地刺塔", "每次攻击穿出4道尖刺，每道尖刺对地面造成小范围群伤。"}

_tab_stringU[91000] = {"江夏据点", "江夏据点"}
_tab_stringU[91003] = {"雪白神树据点", "雪白神树据点"}
_tab_stringU[91004] = {"超级堡垒连弩塔", "超级堡垒连弩塔"}
_tab_stringU[91005] = {"超级堡垒巨炮塔", "超级堡垒巨炮塔"}
_tab_stringU[91006] = {"借东风栅栏", "借东风栅栏"}
_tab_stringU[91007] = {"借东风诸葛亮", "借东风诸葛亮"}
_tab_stringU[91008] = {"借东风敌船巨炮塔", "借东风敌船巨炮塔"}
_tab_stringU[91009] = {"借东风敌船箭塔", "借东风敌船箭塔"}


_tab_stringU[91014] = {"苍穹之龙", "。"}
_tab_stringU[91015] = {"北海玄武", "。"}
_tab_stringU[91016] = {"幽冥凤凰", "。"}

--=============================================================================================--









--各种普通攻击
_tab_stringS[10001] = {"弓箭射击","用弓箭射击目标"}

_tab_stringS[10002] = {"蛇毒",
	"升级后在箭矢上涂抹蛇毒，让敌人变得无力，降低目标的移动速度和攻击速度，并每秒受到剧毒塔自身攻击力一定比例的真实伤害，持续5秒。",
	"每秒造成攻击力40％的伤害。降低20％移速和40％攻速。",
	"每秒造成攻击力80％的伤害。降低25％移速和50％攻速。",
	"每秒造成攻击力120％的伤害。降低30％移速和60％攻速。",
	"每秒造成攻击力160％的伤害。降低35％移速和70％攻速。",
	"每秒造成攻击力200％的伤害。降低40％移速和80％攻速。",
}
_tab_stringS[10003] = {"蝎毒",
	"升级后在箭矢上涂抹蝎毒，让敌人变得衰弱，降低目标的物理防御和法术防御，并每秒受到剧毒塔自身攻击力一定比例的真实伤害，持续5秒。",
	"每秒造成攻击力40％的伤害。降低10点物防和法防。",
	"每秒造成攻击力80％的伤害。降低15点物防和法防。",
	"每秒造成攻击力120％的伤害。降低20点物防和法防。",
	"每秒造成攻击力160％的伤害。降低25点物防和法防。",
	"每秒造成攻击力200％的伤害。降低30点物防和法防。",
}

_tab_stringS[10006] = {"连射",
	"30％几率连续射出6箭，每箭造成15点伤害。",
	"30％几率连续射出9箭，每箭造成20点伤害。",
}



_tab_stringS[10011] = {"投石攻击","用投石攻击，造成范围伤害"}

_tab_stringS[10012] = {"火力提升",
	"升级后通过炮弹工艺的改装，提升炮弹的射程和攻击力。",
	"增加15码射程和45点攻击力。",
	"增加30码射程和100点攻击力。",
	"增加45码射程和165点攻击力。",
	"增加45码射程和165点攻击力。",
	"增加45码射程和165点攻击力。",
}

_tab_stringS[10013] = {"巨炮",
	"升级后巨炮塔每次攻击有一定的几率发射出一颗巨炮，落地后对周围120范围内地面上的敌人造成巨炮塔自身攻击力一定比例的物理伤害，并降低移动速度，持续0.5秒。",
	"20％的几率触发。造成攻击力2.5倍伤害。降低80％移速。",
	"25％的几率触发。造成攻击力3倍伤害。降低90％移速。",
	"30％的几率触发。造成攻击力3.5倍伤害。降低100％移速。",
	"35％的几率触发。造成攻击力4倍伤害。降低110％移速。",
	"40％的几率触发。造成攻击力4.5倍伤害。降低120％移速。",
}



_tab_stringS[10021] = {"火焰攻击","用火球射击，造成法术伤害"}

_tab_stringS[10023] = {"巨大火球",
	"升级后火焰塔每发火球都会积累火焰力量，当力量聚集到一定程度，会发射出一个巨大的火球砸向目标，对目标和目标周围80范围内的敌人造成法术伤害。",
	"每10发火球后发射。造成攻击力300％的群伤。",
	"每9发火球后发射。造成攻击力400％的群伤。",
	"每8发火球后发射。造成攻击力500％的群伤。",
	"每7发火球后发射。造成攻击力600％的群伤。",
	"每6发火球后发射。造成攻击力700％的群伤。",
}

_tab_stringS[10025] = {"连珠火球",
	"升级后火焰塔每次攻击同时发射出更多的火球。",
	"每次攻击同时发射3个火球。",
	"每次攻击同时发射4个火球。",
	"每次攻击同时发射5个火球。",
	"每次攻击同时发射6个火球。",
	"每次攻击同时发射7个火球。",
}


_tab_stringS[10032] = {"增强弩臂",
	"升级后强化连弩塔的韧性，使弩臂可以承受更大的压力，提高连弩的连射几率。",
	"有20％的几率连射。",
	"有30％的几率连射。",
	"有40％的几率连射。",
	"有50％的几率连射。",
	"有60％的几率连射。",
}
_tab_stringS[10033] = {"强化弩匣",
	"升级后改良弩箭的工艺，增加弩匣中弩箭的数量。同时每支弩箭造成更大的伤害。",
	"增加2～3点攻击力。连射的弩箭增至4支。",
	"增加4～6点攻击力。连射的弩箭增至5支。",
	"增加6～9点攻击力。连射的弩箭增至6支。",
	"增加8～12点攻击力。连射的弩箭增至7支。",
	"增加10～15点攻击力。连射的弩箭增至8支。",
}

_tab_stringS[10041] = {"冰冻射击","用冰弹射击目标"}

_tab_stringS[10042] = {"寒冰爆",
	"升级后寒冰塔每次攻击都会积累寒冰力量，当力量聚集到一定程度，会发射出一枚巨大的冰锥砸向目标，对目标和目标周围50范围内的敌人造成法术伤害，并降低移动速度，持续5秒。",
	"每10次攻击后发射。造成10点群伤。降低40％的移动速度。",
	"每9次攻击后发射。造成20点群伤。降低42％的移动速度。",
	"每8次攻击后发射。造成30点群伤。降低43％的移动速度。",
	"每7次攻击后发射。造成40点群伤。降低44％的移动速度。",
	"每6次攻击后发射。造成50点群伤。降低45％的移动速度。",
}
_tab_stringS[10043] = {"冰冻",
	"升级后寒冰塔每次攻击有一定的几率完全冻结目标一段时间。冻结期间目标不能攻击、移动、释放技能。",
	"8％的几率触发。目标冻结4秒。（主将冰冻0.4秒）",
	"9％的几率触发。目标冻结6秒。（主将冰冻0.6秒）",
	"10％的几率触发。目标冻结8秒。（主将冰冻0.8秒）",
	"11％的几率触发。目标冻结10秒。（主将冰冻1秒）",
	"12％的几率触发。目标冻结12秒。（主将冰冻1.2秒）",
}

_tab_stringS[10051] = {"雷电攻击","用雷电攻击目标"}

_tab_stringS[10052] = {"雷电力量",
	"升级后通过借助雷电的力量，每次攻击造成更大的伤害。",
	"增加20～60点攻击力。",
	"增加40～120点攻击力。",
	"增加60～180点攻击力。",
	"增加30～90点攻击力。",
	"增加35～105点攻击力。",
}

_tab_stringS[10053] = {"闪电链",
	"升级后天雷塔每次攻击命中目标后，电弧会弹射到目标附近另一个随机敌人身上，造成闪电塔自身攻击力60％的法术伤害，并电晕敌人0.2秒。（主将除外）",
	"闪电链弹射1次。",
	"闪电链弹射2次。",
	"闪电链弹射3次。",
	"闪电链弹射4次。",
	"闪电链弹射5次。",
}

_tab_stringS[10062] = {"远射",
	"升级后增加狙击塔的射程和攻击力。",
	"增加30码射程和45～60点攻击力。",
	"增加60码射程和90～120点攻击力。",
	"增加90码射程和135～180点攻击力。",
	"增加120码射程和30～60点攻击力。",
	"增加150码射程和35～70点攻击力。",
}

_tab_stringS[10063] = {"穿心一击",
	"升级后增加狙击塔的暴击几率，打出2倍伤害。并有一定的几率直接消灭低血量的敌人。（主将除外）",
	"10％几率暴击。20％几率消灭当前血量低于300点的敌人。",
	"15％几率暴击。30％几率消灭当前血量低于500点的敌人。",
	"20％几率暴击。40％几率消灭当前血量低于700点的敌人。",
	"25％几率暴击。50％几率消灭当前血量低于900点的敌人。",
	"30％几率暴击。60％几率消灭当前血量低于1100点的敌人。",
}

_tab_stringS[10072] = {"击退",
	"升级后滚石对碰到的地面上的敌人造成击退（主将除外），目标沿着滚石运动的方向，被推开一段距离。击退期间目标不能攻击、移动、释放技能。",
	"击退敌人40码的距离，持续0.4秒。",
	"击退敌人60码的距离，持续0.6秒。",
	"击退敌人80码的距离，持续0.8秒。",
	"击退敌人100码的距离，持续1秒。",
	"击退敌人120码的距离，持续1.2秒。",
}

_tab_stringS[10073] = {"蓄能",
	"升级后滚石塔拥有更强大的动能，增加滚石向前滚动的时间，滚动更远的距离。",
	"增加0.4秒的滚动时间，多滚动80码的距离。",
	"增加0.8秒的滚动时间，多滚动160码的距离。",
	"增加1.2秒的滚动时间，多滚动240码的距离。",
	"增加1.6秒的滚动时间，多滚动320码的距离。",
	"增加2秒的滚动时间，多滚动400码的距离。",
}

_tab_stringS[10081] = {"轰天塔普通攻击",
}

_tab_stringS[10082] = {"精准射击",
	"升级后增加轰天塔的射程，使其可以射到更远的目标，也能攻击到更近的目标。同时提升散弹的精准度，让散弹更为集中。",
	"增加10码的最远和最近射程。提升20％的精准度。",
	"增加11码的最远和最近射程。提升22％的精准度。",
	"增加12码的最远和最近射程。提升24％的精准度。",
	"增加13码的最远和最近射程。提升26％的精准度。",
	"增加14码的最远和最近射程。提升28％的精准度。",
}

_tab_stringS[10083] = {"强化散弹",
	"升级后增加轰天塔每颗散弹的威力。同时增加每次发射出散弹的数量。",
	"增加12～24点攻击力。增加2颗散弹。",
	"增加24～48点攻击力。增加4颗散弹。",
	"增加36～72点攻击力。增加6颗散弹。",
	"增加48～96点攻击力。增加8颗散弹。",
	"增加60～120点攻击力。增加10颗散弹。",
}


_tab_stringS[10092] = {"赚钱",
	"升级后粮仓每秒额外产出更多的金。",
	"每秒额外产出1金。",
	"每秒额外产出2金。",
	"每秒额外产出3金。",
	"每秒额外产出4金。",
	"每秒额外产出5金。",
}

_tab_stringS[10093] = {"强击光环",
	"升级后提升粮仓周围一定范围内的友方塔的攻击力。",
	"提升粮仓周围220范围内的友方塔20％的攻击力。",
	"提升粮仓周围250范围内的友方塔40％的攻击力。",
	"提升粮仓周围280范围内的友方塔60％的攻击力。",
	"提升粮仓周围310范围内的友方塔80％的攻击力。",
	"提升粮仓周围340范围内的友方塔100％的攻击力。",
}

_tab_stringS[11002] =
{
	"双剑舞",
	"对目标快速连击3次，每次造成攻击力60％的物理伤害。",
	"对目标快速连击3次，每次造成攻击力65％的物理伤害。",
	"对目标快速连击3次，每次造成攻击力70％的物理伤害。",
	"对目标快速连击3次，每次造成攻击力75％的物理伤害。",
	"对目标快速连击3次，每次造成攻击力80％的物理伤害。",
	"对目标快速连击3次，每次造成攻击力85％的物理伤害。",
	"对目标快速连击3次，每次造成攻击力90％的物理伤害。",
	"对目标快速连击3次，每次造成攻击力95％的物理伤害。",
	"对目标快速连击3次，每次造成攻击力100％的物理伤害。",
	"对目标快速连击3次，每次造成攻击力105％的物理伤害。",
	"对目标快速连击3次，每次造成攻击力110％的物理伤害。",
	"对目标快速连击3次，每次造成攻击力115％的物理伤害。",
	"对目标快速连击3次，每次造成攻击力120％的物理伤害。",
	"对目标快速连击3次，每次造成攻击力125％的物理伤害。",
	"对目标快速连击3次，每次造成攻击力130％的物理伤害。",
}

_tab_stringS[11003] =
{
	"仁心",
	"对自己或一名友军进行治疗，恢复攻击力300％+75点的生命值。",
	"对自己或一名友军进行治疗，恢复攻击力300％+150点的生命值。",
	"对自己或一名友军进行治疗，恢复攻击力300％+225点的生命值。",
	"对自己或一名友军进行治疗，恢复攻击力300％+300点的生命值。",
	"对自己或一名友军进行治疗，恢复攻击力300％+375点的生命值。",
	"对自己或一名友军进行治疗，恢复攻击力300％+450点的生命值。",
	"对自己或一名友军进行治疗，恢复攻击力300％+525点的生命值。",
	"对自己或一名友军进行治疗，恢复攻击力300％+600点的生命值。",
	"对自己或一名友军进行治疗，恢复攻击力300％+675点的生命值。",
	"对自己或一名友军进行治疗，恢复攻击力300％+750点的生命值。",
	"对自己或一名友军进行治疗，恢复攻击力300％+825点的生命值。",
	"对自己或一名友军进行治疗，恢复攻击力300％+900点的生命值。",
	"对自己或一名友军进行治疗，恢复攻击力300％+975点的生命值。",
	"对自己或一名友军进行治疗，恢复攻击力300％+1050点的生命值。",
	"对自己或一名友军进行治疗，恢复攻击力300％+1125点的生命值。",
}

_tab_stringS[11004] =
{
	"3",
	"3",
}

_tab_stringS[11005] =
{
	"4",
	"4",
}







_tab_stringS[11012] =
{
	"升龙斩",
	"挥舞大刀，对自身60范围内的敌人造成攻击力120％+35点的物理伤害。",
	"挥舞大刀，对自身60范围内的敌人造成攻击力130％+40点的物理伤害。",
	"挥舞大刀，对自身60范围内的敌人造成攻击力140％+45点的物理伤害。",
	"挥舞大刀，对自身60范围内的敌人造成攻击力150％+50点的物理伤害。",
	"挥舞大刀，对自身60范围内的敌人造成攻击力160％+55点的物理伤害。",
	"挥舞大刀，对自身60范围内的敌人造成攻击力170％+60点的物理伤害。",
	"挥舞大刀，对自身60范围内的敌人造成攻击力180％+65点的物理伤害。",
	"挥舞大刀，对自身60范围内的敌人造成攻击力190％+70点的物理伤害。",
	"挥舞大刀，对自身60范围内的敌人造成攻击力200％+75点的物理伤害。",
	"挥舞大刀，对自身60范围内的敌人造成攻击力210％+80点的物理伤害。",
	"挥舞大刀，对自身60范围内的敌人造成攻击力220％+85点的物理伤害。",
	"挥舞大刀，对自身60范围内的敌人造成攻击力230％+90点的物理伤害。",
	"挥舞大刀，对自身60范围内的敌人造成攻击力240％+95点的物理伤害。",
	"挥舞大刀，对自身60范围内的敌人造成攻击力250％+100点的物理伤害。",
	"挥舞大刀，对自身60范围内的敌人造成攻击力260％+105点的物理伤害。",
}
_tab_stringS[11013] =
{
	"潜龙勿用",
	"积蓄力量，使下一次普通攻击或技能必定暴击，并增加20％的暴击伤害，持续10秒。进行一次普通攻击或施放技能后，状态消失。",
	"积蓄力量，使下一次普通攻击或技能必定暴击，并增加25％的暴击伤害，持续10秒。进行一次普通攻击或施放技能后，状态消失。",
	"积蓄力量，使下一次普通攻击或技能必定暴击，并增加30％的暴击伤害，持续10秒。进行一次普通攻击或施放技能后，状态消失。",
	"积蓄力量，使下一次普通攻击或技能必定暴击，并增加35％的暴击伤害，持续10秒。进行一次普通攻击或施放技能后，状态消失。",
	"积蓄力量，使下一次普通攻击或技能必定暴击，并增加40％的暴击伤害，持续10秒。进行一次普通攻击或施放技能后，状态消失。",
	"积蓄力量，使下一次普通攻击或技能必定暴击，并增加45％的暴击伤害，持续10秒。进行一次普通攻击或施放技能后，状态消失。",
	"积蓄力量，使下一次普通攻击或技能必定暴击，并增加50％的暴击伤害，持续10秒。进行一次普通攻击或施放技能后，状态消失。",
	"积蓄力量，使下一次普通攻击或技能必定暴击，并增加55％的暴击伤害，持续10秒。进行一次普通攻击或施放技能后，状态消失。",
	"积蓄力量，使下一次普通攻击或技能必定暴击，并增加60％的暴击伤害，持续10秒。进行一次普通攻击或施放技能后，状态消失。",
	"积蓄力量，使下一次普通攻击或技能必定暴击，并增加65％的暴击伤害，持续10秒。进行一次普通攻击或施放技能后，状态消失。",
	"积蓄力量，使下一次普通攻击或技能必定暴击，并增加70％的暴击伤害，持续10秒。进行一次普通攻击或施放技能后，状态消失。",
	"积蓄力量，使下一次普通攻击或技能必定暴击，并增加75％的暴击伤害，持续10秒。进行一次普通攻击或施放技能后，状态消失。",
	"积蓄力量，使下一次普通攻击或技能必定暴击，并增加80％的暴击伤害，持续10秒。进行一次普通攻击或施放技能后，状态消失。",
	"积蓄力量，使下一次普通攻击或技能必定暴击，并增加85％的暴击伤害，持续10秒。进行一次普通攻击或施放技能后，状态消失。",
	"积蓄力量，使下一次普通攻击或技能必定暴击，并增加90％的暴击伤害，持续10秒。进行一次普通攻击或施放技能后，状态消失。",
}

_tab_stringS[11014] =
{
	"3",
	"3",
}

_tab_stringS[11015] =
{
	"4",
	"4",
}


_tab_stringS[11022] =
{
	"动地跺",
	"震击地面，对自身60范围内的敌人造成攻击力50％+25点的物理伤害，并震晕2秒。",
	"震击地面，对自身60范围内的敌人造成攻击力55％+30点的物理伤害，并震晕2.1秒。",
	"震击地面，对自身60范围内的敌人造成攻击力60％+35点的物理伤害，并震晕2.2秒。",
	"震击地面，对自身60范围内的敌人造成攻击力65％+40点的物理伤害，并震晕2.3秒。",
	"震击地面，对自身60范围内的敌人造成攻击力70％+45点的物理伤害，并震晕2.4秒。",
	"震击地面，对自身60范围内的敌人造成攻击力75％+50点的物理伤害，并震晕2.5秒。",
	"震击地面，对自身60范围内的敌人造成攻击力80％+55点的物理伤害，并震晕2.6秒。",
	"震击地面，对自身60范围内的敌人造成攻击力85％+60点的物理伤害，并震晕2.7秒。",
	"震击地面，对自身60范围内的敌人造成攻击力90％+65点的物理伤害，并震晕2.8秒。",
	"震击地面，对自身60范围内的敌人造成攻击力95％+70点的物理伤害，并震晕2.9秒。",
	"震击地面，对自身60范围内的敌人造成攻击力100％+75点的物理伤害，并震晕3秒。",
	"震击地面，对自身60范围内的敌人造成攻击力105％+80点的物理伤害，并震晕3.1秒。",
	"震击地面，对自身60范围内的敌人造成攻击力110％+85点的物理伤害，并震晕3.2秒。",
	"震击地面，对自身60范围内的敌人造成攻击力115％+90点的物理伤害，并震晕3.3秒。",
	"震击地面，对自身60范围内的敌人造成攻击力120％+95点的物理伤害，并震晕3.4秒。",
}


_tab_stringS[11024] =
{
	"硬汉",
	"永久增加自身17点物理防御。同时张飞每次释放燕人咆哮时，获得一个能吸收物理伤害的护盾，护盾拥有物防*50的生命值。护盾持续30秒。",
	"永久增加自身19点物理防御。同时张飞每次释放燕人咆哮时，获得一个能吸收物理伤害的护盾，护盾拥有物防*50的生命值。护盾持续30秒。",
	"永久增加自身21点物理防御。同时张飞每次释放燕人咆哮时，获得一个能吸收物理伤害的护盾，护盾拥有物防*50的生命值。护盾持续30秒。",
	"永久增加自身23点物理防御。同时张飞每次释放燕人咆哮时，获得一个能吸收物理伤害的护盾，护盾拥有物防*50的生命值。护盾持续30秒。",
	"永久增加自身25点物理防御。同时张飞每次释放燕人咆哮时，获得一个能吸收物理伤害的护盾，护盾拥有物防*50的生命值。护盾持续30秒。",
	"永久增加自身27点物理防御。同时张飞每次释放燕人咆哮时，获得一个能吸收物理伤害的护盾，护盾拥有物防*50的生命值。护盾持续30秒。",
	"永久增加自身29点物理防御。同时张飞每次释放燕人咆哮时，获得一个能吸收物理伤害的护盾，护盾拥有物防*50的生命值。护盾持续30秒。",
	"永久增加自身31点物理防御。同时张飞每次释放燕人咆哮时，获得一个能吸收物理伤害的护盾，护盾拥有物防*50的生命值。护盾持续30秒。",
	"永久增加自身33点物理防御。同时张飞每次释放燕人咆哮时，获得一个能吸收物理伤害的护盾，护盾拥有物防*50的生命值。护盾持续30秒。",
	"永久增加自身35点物理防御。同时张飞每次释放燕人咆哮时，获得一个能吸收物理伤害的护盾，护盾拥有物防*50的生命值。护盾持续30秒。",
	"永久增加自身37点物理防御。同时张飞每次释放燕人咆哮时，获得一个能吸收物理伤害的护盾，护盾拥有物防*50的生命值。护盾持续30秒。",
	"永久增加自身39点物理防御。同时张飞每次释放燕人咆哮时，获得一个能吸收物理伤害的护盾，护盾拥有物防*50的生命值。护盾持续30秒。",
	"永久增加自身41点物理防御。同时张飞每次释放燕人咆哮时，获得一个能吸收物理伤害的护盾，护盾拥有物防*50的生命值。护盾持续30秒。",
	"永久增加自身43点物理防御。同时张飞每次释放燕人咆哮时，获得一个能吸收物理伤害的护盾，护盾拥有物防*50的生命值。护盾持续30秒。",
	"永久增加自身45点物理防御。同时张飞每次释放燕人咆哮时，获得一个能吸收物理伤害的护盾，护盾拥有物防*50的生命值。护盾持续30秒。",
}

_tab_stringS[11025] =
{
	"3",
	"3",
}

_tab_stringS[11026] =
{
	"4",
	"4",
}


_tab_stringS[11042] =
{
	"连珠箭",
	"连射出10支箭，每支箭命中射程内的随机敌人，每次造成攻击力6％+12点的物理伤害。",
	"连射出10支箭，每支箭命中射程内的随机敌人，每次造成攻击力7％+14点的物理伤害。",
	"连射出10支箭，每支箭命中射程内的随机敌人，每次造成攻击力8％+16点的物理伤害。",
	"连射出10支箭，每支箭命中射程内的随机敌人，每次造成攻击力9％+18点的物理伤害。",
	"连射出10支箭，每支箭命中射程内的随机敌人，每次造成攻击力10％+20点的物理伤害。",
	"连射出10支箭，每支箭命中射程内的随机敌人，每次造成攻击力11％+22点的物理伤害。",
	"连射出10支箭，每支箭命中射程内的随机敌人，每次造成攻击力12％+24点的物理伤害。",
	"连射出10支箭，每支箭命中射程内的随机敌人，每次造成攻击力13％+26点的物理伤害。",
	"连射出10支箭，每支箭命中射程内的随机敌人，每次造成攻击力14％+28点的物理伤害。",
	"连射出10支箭，每支箭命中射程内的随机敌人，每次造成攻击力15％+30点的物理伤害。",
	"连射出10支箭，每支箭命中射程内的随机敌人，每次造成攻击力16％+32点的物理伤害。",
	"连射出10支箭，每支箭命中射程内的随机敌人，每次造成攻击力17％+34点的物理伤害。",
	"连射出10支箭，每支箭命中射程内的随机敌人，每次造成攻击力18％+36点的物理伤害。",
	"连射出10支箭，每支箭命中射程内的随机敌人，每次造成攻击力19％+38点的物理伤害。",
	"连射出10支箭，每支箭命中射程内的随机敌人，每次造成攻击力20％+40点的物理伤害。",
}


_tab_stringS[11052] =
{
	"望梅止渴",
	"提升自己和附近300范围内的友军每秒攻击力50%+6点回血，持续7秒。",
	"提升自己和附近300范围内的友军每秒攻击力50%+10点回血，持续7秒。",
	"提升自己和附近300范围内的友军每秒攻击力50%+14点回血，持续7秒。",
	"提升自己和附近300范围内的友军每秒攻击力50%+18点回血，持续7秒。",
	"提升自己和附近300范围内的友军每秒攻击力50%+22点回血，持续7秒。",
	"提升自己和附近300范围内的友军每秒攻击力50%+26点回血，持续7秒。",
	"提升自己和附近300范围内的友军每秒攻击力50%+30点回血，持续7秒。",
	"提升自己和附近300范围内的友军每秒攻击力50%+34点回血，持续7秒。",
	"提升自己和附近300范围内的友军每秒攻击力50%+38点回血，持续7秒。",
	"提升自己和附近300范围内的友军每秒攻击力50%+42点回血，持续7秒。",
	"提升自己和附近300范围内的友军每秒攻击力50%+46点回血，持续7秒。",
	"提升自己和附近300范围内的友军每秒攻击力50%+50点回血，持续7秒。",
	"提升自己和附近300范围内的友军每秒攻击力50%+54点回血，持续7秒。",
	"提升自己和附近300范围内的友军每秒攻击力50%+58点回血，持续7秒。",
	"提升自己和附近300范围内的友军每秒攻击力50%+62点回血，持续7秒。",
}


_tab_stringS[11062] =
{
	"寒冰爆",
	"向正前方放出6道冰锥，每道都对小范围敌人造成攻击力30％+30点的法术伤害，并冻结1.5秒。",
	"向正前方放出6道冰锥，每道都对小范围敌人造成攻击力30％+45点的法术伤害，并冻结1.6秒。",
	"向正前方放出6道冰锥，每道都对小范围敌人造成攻击力30％+60点的法术伤害，并冻结1.7秒",
	"向正前方放出6道冰锥，每道都对小范围敌人造成攻击力30％+75点的法术伤害，并冻结1.8秒。",
	"向正前方放出6道冰锥，每道都对小范围敌人造成攻击力30％+90点的法术伤害，并冻结1.9秒。",
	"向正前方放出6道冰锥，每道都对小范围敌人造成攻击力30％+105点的法术伤害，并冻结2秒。",
	"向正前方放出6道冰锥，每道都对小范围敌人造成攻击力30％+120点的法术伤害，并冻结2.1秒。",
	"向正前方放出6道冰锥，每道都对小范围敌人造成攻击力30％+135点的法术伤害，并冻结2.2秒。",
	"向正前方放出6道冰锥，每道都对小范围敌人造成攻击力30％+150点的法术伤害，并冻结2.3秒。",
	"向正前方放出6道冰锥，每道都对小范围敌人造成攻击力30％+165点的法术伤害，并冻结2.4秒。",
	"向正前方放出6道冰锥，每道都对小范围敌人造成攻击力30％+180点的法术伤害，并冻结2.5秒。",
	"向正前方放出6道冰锥，每道都对小范围敌人造成攻击力30％+195点的法术伤害，并冻结2.6秒。",
	"向正前方放出6道冰锥，每道都对小范围敌人造成攻击力30％+210点的法术伤害，并冻结2.7秒。",
	"向正前方放出6道冰锥，每道都对小范围敌人造成攻击力30％+225点的法术伤害，并冻结2.8秒。",
	"向正前方放出6道冰锥，每道都对小范围敌人造成攻击力30％+240点的法术伤害，并冻结2.9秒。",
}

_tab_stringS[11082] =
{
	"七探蛇盘枪",
	"挥舞长枪，增加自身45％的移动速度和45％的物理闪避。同时持续发动长枪连刺，每秒迅速突刺7次自身120范围内的随机敌人，每次造成攻击力4％+8点的物理伤害，持续12秒。",
	"挥舞长枪，增加自身48％的移动速度和48％的物理闪避。同时持续发动长枪连刺，每秒迅速突刺7次自身120范围内的随机敌人，每次造成攻击力5％+10点的物理伤害，持续12秒。",
	"挥舞长枪，增加自身51％的移动速度和51％的物理闪避。同时持续发动长枪连刺，每秒迅速突刺7次自身120范围内的随机敌人，每次造成攻击力6％+12点的物理伤害，持续12秒。",
	"挥舞长枪，增加自身54％的移动速度和54％的物理闪避。同时持续发动长枪连刺，每秒迅速突刺7次自身120范围内的随机敌人，每次造成攻击力7％+14点的物理伤害，持续12秒。",
	"挥舞长枪，增加自身57％的移动速度和57％的物理闪避。同时持续发动长枪连刺，每秒迅速突刺7次自身120范围内的随机敌人，每次造成攻击力8％+16点的物理伤害，持续12秒。",
	"挥舞长枪，增加自身60％的移动速度和60％的物理闪避。同时持续发动长枪连刺，每秒迅速突刺7次自身120范围内的随机敌人，每次造成攻击力9％+18点的物理伤害，持续12秒。",
	"挥舞长枪，增加自身63％的移动速度和63％的物理闪避。同时持续发动长枪连刺，每秒迅速突刺7次自身120范围内的随机敌人，每次造成攻击力10％+20点的物理伤害，持续12秒。",
	"挥舞长枪，增加自身66％的移动速度和66％的物理闪避。同时持续发动长枪连刺，每秒迅速突刺7次自身120范围内的随机敌人，每次造成攻击力11％+22点的物理伤害，持续12秒。",
	"挥舞长枪，增加自身69％的移动速度和69％的物理闪避。同时持续发动长枪连刺，每秒迅速突刺7次自身120范围内的随机敌人，每次造成攻击力12％+24点的物理伤害，持续12秒。",
	"挥舞长枪，增加自身72％的移动速度和72％的物理闪避。同时持续发动长枪连刺，每秒迅速突刺7次自身120范围内的随机敌人，每次造成攻击力13％+26点的物理伤害，持续12秒。",
	"挥舞长枪，增加自身75％的移动速度和75％的物理闪避。同时持续发动长枪连刺，每秒迅速突刺7次自身120范围内的随机敌人，每次造成攻击力14％+28点的物理伤害，持续12秒。",
	"挥舞长枪，增加自身78％的移动速度和78％的物理闪避。同时持续发动长枪连刺，每秒迅速突刺7次自身120范围内的随机敌人，每次造成攻击力15％+30点的物理伤害，持续12秒。",
	"挥舞长枪，增加自身81％的移动速度和81％的物理闪避。同时持续发动长枪连刺，每秒迅速突刺7次自身120范围内的随机敌人，每次造成攻击力16％+32点的物理伤害，持续12秒。",
	"挥舞长枪，增加自身84％的移动速度和84％的物理闪避。同时持续发动长枪连刺，每秒迅速突刺7次自身120范围内的随机敌人，每次造成攻击力17％+34点的物理伤害，持续12秒。",
	"挥舞长枪，增加自身87％的移动速度和87％的物理闪避。同时持续发动长枪连刺，每秒迅速突刺7次自身120范围内的随机敌人，每次造成攻击力18％+36点的物理伤害，持续12秒。",
}

_tab_stringS[11086] =
{
	"月轮斩",
	"向正前方挥出1道月轮，对一条直线上碰到的敌人造成攻击力100％+30点的物理伤害。",
	"向正前方挥出1道月轮，对一条直线上碰到的敌人造成攻击力110％+40点的物理伤害。",
	"向正前方挥出1道月轮，对一条直线上碰到的敌人造成攻击力120％+50点的物理伤害。",
	"向正前方挥出1道月轮，对一条直线上碰到的敌人造成攻击力130％+60点的物理伤害。",
	"向正前方挥出1道月轮，对一条直线上碰到的敌人造成攻击力140％+70点的物理伤害。",
	"向正前方挥出1道月轮，对一条直线上碰到的敌人造成攻击力150％+80点的物理伤害。",
	"向正前方挥出1道月轮，对一条直线上碰到的敌人造成攻击力160％+90点的物理伤害。",
	"向正前方挥出1道月轮，对一条直线上碰到的敌人造成攻击力170％+100点的物理伤害。",
	"向正前方挥出1道月轮，对一条直线上碰到的敌人造成攻击力180％+110点的物理伤害。",
	"向正前方挥出1道月轮，对一条直线上碰到的敌人造成攻击力190％+120点的物理伤害。",
	"向正前方挥出1道月轮，对一条直线上碰到的敌人造成攻击力200％+130点的物理伤害。",
	"向正前方挥出1道月轮，对一条直线上碰到的敌人造成攻击力210％+140点的物理伤害。",
	"向正前方挥出1道月轮，对一条直线上碰到的敌人造成攻击力220％+150点的物理伤害。",
	"向正前方挥出1道月轮，对一条直线上碰到的敌人造成攻击力230％+160点的物理伤害。",
	"向正前方挥出1道月轮，对一条直线上碰到的敌人造成攻击力240％+170点的物理伤害。",
}

_tab_stringS[11101] =
{
	"战神一击",
	"对目标造成攻击力120％的物理伤害，并击晕1秒。如果消灭目标，则减少无双战神冷却时间5秒。",
	"对目标造成攻击力130％的物理伤害，并击晕1秒。如果消灭目标，则减少无双战神冷却时间5秒。",
	"对目标造成攻击力140％的物理伤害，并击晕1秒。如果消灭目标，则减少无双战神冷却时间5秒。",
	"对目标造成攻击力150％的物理伤害，并击晕1秒。如果消灭目标，则减少无双战神冷却时间5秒。",
	"对目标造成攻击力160％的物理伤害，并击晕1秒。如果消灭目标，则减少无双战神冷却时间5秒。",
	"对目标造成攻击力170％的物理伤害，并击晕1秒。如果消灭目标，则减少无双战神冷却时间5秒。",
	"对目标造成攻击力180％的物理伤害，并击晕1秒。如果消灭目标，则减少无双战神冷却时间5秒。",
	"对目标造成攻击力190％的物理伤害，并击晕1秒。如果消灭目标，则减少无双战神冷却时间5秒。",
	"对目标造成攻击力200％的物理伤害，并击晕1秒。如果消灭目标，则减少无双战神冷却时间5秒。",
	"对目标造成攻击力210％的物理伤害，并击晕1秒。如果消灭目标，则减少无双战神冷却时间5秒。",
	"对目标造成攻击力220％的物理伤害，并击晕1秒。如果消灭目标，则减少无双战神冷却时间5秒。",
	"对目标造成攻击力230％的物理伤害，并击晕1秒。如果消灭目标，则减少无双战神冷却时间5秒。",
	"对目标造成攻击力240％的物理伤害，并击晕1秒。如果消灭目标，则减少无双战神冷却时间5秒。",
	"对目标造成攻击力250％的物理伤害，并击晕1秒。如果消灭目标，则减少无双战神冷却时间5秒。",
	"对目标造成攻击力260％的物理伤害，并击晕1秒。如果消灭目标，则减少无双战神冷却时间5秒。",

}

_tab_stringS[11112] =
{
	"魅影一击",
	"每次攻击魅惑敌人，对同一目标连续攻击3次后，对目标和目标周围100范围内的敌人造成攻击力30％的物理伤害，并眩晕0.5秒。",
	"每次攻击魅惑敌人，对同一目标连续攻击3次后，对目标和目标周围100范围内的敌人造成攻击力33％的物理伤害，并眩晕0.5秒。",
	"每次攻击魅惑敌人，对同一目标连续攻击3次后，对目标和目标周围100范围内的敌人造成攻击力36％的物理伤害，并眩晕0.5秒。",
	"每次攻击魅惑敌人，对同一目标连续攻击3次后，对目标和目标周围100范围内的敌人造成攻击力39％的物理伤害，并眩晕0.5秒。",
	"每次攻击魅惑敌人，对同一目标连续攻击3次后，对目标和目标周围100范围内的敌人造成攻击力42％的物理伤害，并眩晕0.5秒。",
	"每次攻击魅惑敌人，对同一目标连续攻击3次后，对目标和目标周围100范围内的敌人造成攻击力45％的物理伤害，并眩晕0.5秒。",
	"每次攻击魅惑敌人，对同一目标连续攻击3次后，对目标和目标周围100范围内的敌人造成攻击力48％的物理伤害，并眩晕0.5秒。",
	"每次攻击魅惑敌人，对同一目标连续攻击3次后，对目标和目标周围100范围内的敌人造成攻击力51％的物理伤害，并眩晕0.5秒。",
	"每次攻击魅惑敌人，对同一目标连续攻击3次后，对目标和目标周围100范围内的敌人造成攻击力54％的物理伤害，并眩晕0.5秒。",
	"每次攻击魅惑敌人，对同一目标连续攻击3次后，对目标和目标周围100范围内的敌人造成攻击力57％的物理伤害，并眩晕0.5秒。",
	"每次攻击魅惑敌人，对同一目标连续攻击3次后，对目标和目标周围100范围内的敌人造成攻击力60％的物理伤害，并眩晕0.5秒。",
	"每次攻击魅惑敌人，对同一目标连续攻击3次后，对目标和目标周围100范围内的敌人造成攻击力63％的物理伤害，并眩晕0.5秒。",
	"每次攻击魅惑敌人，对同一目标连续攻击3次后，对目标和目标周围100范围内的敌人造成攻击力66％的物理伤害，并眩晕0.5秒。",
	"每次攻击魅惑敌人，对同一目标连续攻击3次后，对目标和目标周围100范围内的敌人造成攻击力69％的物理伤害，并眩晕0.5秒。",
	"每次攻击魅惑敌人，对同一目标连续攻击3次后，对目标和目标周围100范围内的敌人造成攻击力72％的物理伤害，并眩晕0.5秒。",
}

_tab_stringS[11122] =
{
	"化守为攻",
	"用盾牌猛击附近敌人，对自身60范围内的敌人造成1.5倍物理防御+10点的物理伤害。",
	"用盾牌猛击附近敌人，对自身60范围内的敌人造成1.8倍物理防御+15点的物理伤害。",
	"用盾牌猛击附近敌人，对自身60范围内的敌人造成2.1倍物理防御+20点的物理伤害。",
	"用盾牌猛击附近敌人，对自身60范围内的敌人造成2.4倍物理防御+25点的物理伤害。",
	"用盾牌猛击附近敌人，对自身60范围内的敌人造成2.7倍物理防御+30点的物理伤害。",
	"用盾牌猛击附近敌人，对自身60范围内的敌人造成3.0倍物理防御+35点的物理伤害，并眩晕0.5秒。",
	"用盾牌猛击附近敌人，对自身60范围内的敌人造成3.3倍物理防御+40点的物理伤害，并眩晕0.5秒。",
	"用盾牌猛击附近敌人，对自身60范围内的敌人造成3.6倍物理防御+45点的物理伤害，并眩晕0.5秒。",
	"用盾牌猛击附近敌人，对自身60范围内的敌人造成3.9倍物理防御+50点的物理伤害，并眩晕0.5秒。",
	"用盾牌猛击附近敌人，对自身60范围内的敌人造成4.2倍物理防御+55点的物理伤害，并眩晕0.5秒。",
	"用盾牌猛击附近敌人，对自身60范围内的敌人造成4.5倍物理防御+60点的物理伤害，并眩晕0.5秒。",
	"用盾牌猛击附近敌人，对自身60范围内的敌人造成4.8倍物理防御+65点的物理伤害，并眩晕0.5秒。",
	"用盾牌猛击附近敌人，对自身60范围内的敌人造成5.1倍物理防御+70点的物理伤害，并眩晕0.5秒。",
	"用盾牌猛击附近敌人，对自身60范围内的敌人造成5.4倍物理防御+75点的物理伤害，并眩晕0.5秒。",
	"用盾牌猛击附近敌人，对自身60范围内的敌人造成5.7倍物理防御+80点的物理伤害，并眩晕0.5秒。",
}

_tab_stringS[11123] =
{
	"巨木",
	"许褚挥舞巨木，每次攻击都会溅射50范围造成群伤。同时每次攻击有12％的几率造成击退，敌人被推开30码的距离，并眩晕0.5秒。在裸衣状态下，每次攻击都会击退敌人。",
	"许褚挥舞巨木，每次攻击都会溅射55范围造成群伤。同时每次攻击有16％的几率造成击退，敌人被推开30码的距离，并眩晕0.5秒。在裸衣状态下，每次攻击都会击退敌人。",
	"许褚挥舞巨木，每次攻击都会溅射60范围造成群伤。同时每次攻击有20％的几率造成击退，敌人被推开30码的距离，并眩晕0.5秒。在裸衣状态下，每次攻击都会击退敌人。",
	"许褚挥舞巨木，每次攻击都会溅射65范围造成群伤。同时每次攻击有24％的几率造成击退，敌人被推开30码的距离，并眩晕0.5秒。在裸衣状态下，每次攻击都会击退敌人。",
	"许褚挥舞巨木，每次攻击都会溅射70范围造成群伤。同时每次攻击有28％的几率造成击退，敌人被推开30码的距离，并眩晕0.5秒。在裸衣状态下，每次攻击都会击退敌人。",
	"许褚挥舞巨木，每次攻击都会溅射75范围造成群伤。同时每次攻击有32％的几率造成击退，敌人被推开30码的距离，并眩晕0.5秒。在裸衣状态下，每次攻击都会击退敌人。",
	"许褚挥舞巨木，每次攻击都会溅射80范围造成群伤。同时每次攻击有36％的几率造成击退，敌人被推开30码的距离，并眩晕0.5秒。在裸衣状态下，每次攻击都会击退敌人。",
	"许褚挥舞巨木，每次攻击都会溅射85范围造成群伤。同时每次攻击有40％的几率造成击退，敌人被推开30码的距离，并眩晕0.5秒。在裸衣状态下，每次攻击都会击退敌人。",
	"许褚挥舞巨木，每次攻击都会溅射90范围造成群伤。同时每次攻击有44％的几率造成击退，敌人被推开30码的距离，并眩晕0.5秒。在裸衣状态下，每次攻击都会击退敌人。",
	"许褚挥舞巨木，每次攻击都会溅射95范围造成群伤。同时每次攻击有48％的几率造成击退，敌人被推开30码的距离，并眩晕0.5秒。在裸衣状态下，每次攻击都会击退敌人。",
	"许褚挥舞巨木，每次攻击都会溅射100范围造成群伤。同时每次攻击有52％的几率造成击退，敌人被推开30码的距离，并眩晕0.5秒。在裸衣状态下，每次攻击都会击退敌人。",
	"许褚挥舞巨木，每次攻击都会溅射105范围造成群伤。同时每次攻击有56％的几率造成击退，敌人被推开30码的距离，并眩晕0.5秒。在裸衣状态下，每次攻击都会击退敌人。",
	"许褚挥舞巨木，每次攻击都会溅射110范围造成群伤。同时每次攻击有60％的几率造成击退，敌人被推开30码的距离，并眩晕0.5秒。在裸衣状态下，每次攻击都会击退敌人。",
	"许褚挥舞巨木，每次攻击都会溅射115范围造成群伤。同时每次攻击有64％的几率造成击退，敌人被推开30码的距离，并眩晕0.5秒。在裸衣状态下，每次攻击都会击退敌人。",
	"许褚挥舞巨木，每次攻击都会溅射120范围造成群伤。同时每次攻击有68％的几率造成击退，敌人被推开30码的距离，并眩晕0.5秒。在裸衣状态下，每次攻击都会击退敌人。",
}

_tab_stringS[11127] =
{
	"旋风击",
	"每次攻击有15％的概率发动旋风击，对自身120范围内的敌人造成攻击力36％的物理伤害，并震晕0.5秒。在血煞状态下，概率提升为50％。",
	"每次攻击有15％的概率发动旋风击，对自身120范围内的敌人造成攻击力40％的物理伤害，并震晕0.5秒。在血煞状态下，概率提升为50％。",
	"每次攻击有15％的概率发动旋风击，对自身120范围内的敌人造成攻击力44％的物理伤害，并震晕0.5秒。在血煞状态下，概率提升为50％。",
	"每次攻击有15％的概率发动旋风击，对自身120范围内的敌人造成攻击力48％的物理伤害，并震晕0.5秒。在血煞状态下，概率提升为50％。",
	"每次攻击有15％的概率发动旋风击，对自身120范围内的敌人造成攻击力52％的物理伤害，并震晕0.5秒。在血煞状态下，概率提升为50％。",
	"每次攻击有15％的概率发动旋风击，对自身120范围内的敌人造成攻击力56％的物理伤害，并震晕0.5秒。在血煞状态下，概率提升为50％。",
	"每次攻击有15％的概率发动旋风击，对自身120范围内的敌人造成攻击力60％的物理伤害，并震晕0.5秒。在血煞状态下，概率提升为50％。",
	"每次攻击有15％的概率发动旋风击，对自身120范围内的敌人造成攻击力62％的物理伤害，并震晕0.5秒。在血煞状态下，概率提升为50％。",
	"每次攻击有15％的概率发动旋风击，对自身120范围内的敌人造成攻击力66％的物理伤害，并震晕0.5秒。在血煞状态下，概率提升为50％。",
	"每次攻击有15％的概率发动旋风击，对自身120范围内的敌人造成攻击力70％的物理伤害，并震晕0.5秒。在血煞状态下，概率提升为50％。",
	"每次攻击有15％的概率发动旋风击，对自身120范围内的敌人造成攻击力74％的物理伤害，并震晕0.5秒。在血煞状态下，概率提升为50％。",
	"每次攻击有15％的概率发动旋风击，对自身120范围内的敌人造成攻击力78％的物理伤害，并震晕0.5秒。在血煞状态下，概率提升为50％。",
	"每次攻击有15％的概率发动旋风击，对自身120范围内的敌人造成攻击力82％的物理伤害，并震晕0.5秒。在血煞状态下，概率提升为50％。",
	"每次攻击有15％的概率发动旋风击，对自身120范围内的敌人造成攻击力86％的物理伤害，并震晕0.5秒。在血煞状态下，概率提升为50％。",
	"每次攻击有15％的概率发动旋风击，对自身120范围内的敌人造成攻击力90％的物理伤害，并震晕0.5秒。在血煞状态下，概率提升为50％。",
}

_tab_stringS[11129] =
{
	"横扫千军",
	"挥舞长枪发动大范围的横扫，对自身120范围内的敌人造成攻击力116％的物理伤害和1.5秒的眩晕，并造成击退，敌人被推开30码的距离。",
	"挥舞长枪发动大范围的横扫，对自身120范围内的敌人造成攻击力124％的物理伤害和1.6秒的眩晕，并造成击退，敌人被推开30码的距离。",
	"挥舞长枪发动大范围的横扫，对自身120范围内的敌人造成攻击力132％的物理伤害和1.7秒的眩晕，并造成击退，敌人被推开30码的距离。",
	"挥舞长枪发动大范围的横扫，对自身120范围内的敌人造成攻击力140％的物理伤害和1.8秒的眩晕，并造成击退，敌人被推开30码的距离。",
	"挥舞长枪发动大范围的横扫，对自身120范围内的敌人造成攻击力148％的物理伤害和1.9秒的眩晕，并造成击退，敌人被推开30码的距离。",
	"挥舞长枪发动大范围的横扫，对自身120范围内的敌人造成攻击力156％的物理伤害和2秒的眩晕，并造成击退，敌人被推开30码的距离。",
	"挥舞长枪发动大范围的横扫，对自身120范围内的敌人造成攻击力164％的物理伤害和2.1秒的眩晕，并造成击退，敌人被推开30码的距离。",
	"挥舞长枪发动大范围的横扫，对自身120范围内的敌人造成攻击力172％的物理伤害和2.2秒的眩晕，并造成击退，敌人被推开30码的距离。",
	"挥舞长枪发动大范围的横扫，对自身120范围内的敌人造成攻击力180％的物理伤害和2.3秒的眩晕，并造成击退，敌人被推开30码的距离。",
	"挥舞长枪发动大范围的横扫，对自身120范围内的敌人造成攻击力188％的物理伤害和2.4秒的眩晕，并造成击退，敌人被推开30码的距离。",
	"挥舞长枪发动大范围的横扫，对自身120范围内的敌人造成攻击力196％的物理伤害和2.5秒的眩晕，并造成击退，敌人被推开30码的距离。",
	"挥舞长枪发动大范围的横扫，对自身120范围内的敌人造成攻击力204％的物理伤害和2.6秒的眩晕，并造成击退，敌人被推开30码的距离。",
	"挥舞长枪发动大范围的横扫，对自身120范围内的敌人造成攻击力212％的物理伤害和2.7秒的眩晕，并造成击退，敌人被推开30码的距离。",
	"挥舞长枪发动大范围的横扫，对自身120范围内的敌人造成攻击力220％的物理伤害和2.8秒的眩晕，并造成击退，敌人被推开30码的距离。",
	"挥舞长枪发动大范围的横扫，对自身120范围内的敌人造成攻击力228％的物理伤害和2.9秒的眩晕，并造成击退，敌人被推开30码的距离。",
}


_tab_stringS[11135] =
{
	"风卷残云",
	"向前发出3道旋风，每道旋风都对一条直线上碰到的敌人造成攻击力80％的物理伤害，并将其吹到空中，持续0.6秒。",
	"向前发出3道旋风，每道旋风都对一条直线上碰到的敌人造成攻击力90％的物理伤害，并将其吹到空中，持续0.7秒。",
	"向前发出3道旋风，每道旋风都对一条直线上碰到的敌人造成攻击力100％的物理伤害，并将其吹到空中，持续0.8秒。",
	"向前发出3道旋风，每道旋风都对一条直线上碰到的敌人造成攻击力110％的物理伤害，并将其吹到空中，持续0.9秒。",
	"向前发出3道旋风，每道旋风都对一条直线上碰到的敌人造成攻击力120％的物理伤害，并将其吹到空中，持续1秒。",
	"向前发出3道旋风，每道旋风都对一条直线上碰到的敌人造成攻击力130％的物理伤害，并将其吹到空中，持续1.1秒。",
	"向前发出3道旋风，每道旋风都对一条直线上碰到的敌人造成攻击力140％的物理伤害，并将其吹到空中，持续1.2秒。",
	"向前发出3道旋风，每道旋风都对一条直线上碰到的敌人造成攻击力150％的物理伤害，并将其吹到空中，持续1.3秒。",
	"向前发出3道旋风，每道旋风都对一条直线上碰到的敌人造成攻击力160％的物理伤害，并将其吹到空中，持续1.4秒。",
	"向前发出3道旋风，每道旋风都对一条直线上碰到的敌人造成攻击力170％的物理伤害，并将其吹到空中，持续1.5秒。",
	"向前发出3道旋风，每道旋风都对一条直线上碰到的敌人造成攻击力180％的物理伤害，并将其吹到空中，持续1.6秒。",
	"向前发出3道旋风，每道旋风都对一条直线上碰到的敌人造成攻击力190％的物理伤害，并将其吹到空中，持续1.7秒。",
	"向前发出3道旋风，每道旋风都对一条直线上碰到的敌人造成攻击力200％的物理伤害，并将其吹到空中，持续1.8秒。",
	"向前发出3道旋风，每道旋风都对一条直线上碰到的敌人造成攻击力210％的物理伤害，并将其吹到空中，持续1.9秒。",
	"向前发出3道旋风，每道旋风都对一条直线上碰到的敌人造成攻击力220％的物理伤害，并将其吹到空中，持续2秒。",
}


_tab_stringS[11136] =
{
	"踏浪",
	"永久增加自身4％的移动速度和物理闪避。同时甘宁每次自动施放风卷残云技能时，额外增加8％的移动速度和物理闪避，持续3秒。",
	"永久增加自身5％的移动速度和物理闪避。同时甘宁每次自动施放风卷残云技能时，额外增加10％的移动速度和物理闪避，持续3秒。",
	"永久增加自身6％的移动速度和物理闪避。同时甘宁每次自动施放风卷残云技能时，额外增加12％的移动速度和物理闪避，持续3秒。",
	"永久增加自身7％的移动速度和物理闪避。同时甘宁每次自动施放风卷残云技能时，额外增加14％的移动速度和物理闪避，持续3秒。",
	"永久增加自身8％的移动速度和物理闪避。同时甘宁每次自动施放风卷残云技能时，额外增加16％的移动速度和物理闪避，持续3秒。",
	"永久增加自身9％的移动速度和物理闪避。同时甘宁每次自动施放风卷残云技能时，额外增加18％的移动速度和物理闪避，持续3秒。",
	"永久增加自身10％的移动速度和物理闪避。同时甘宁每次自动施放风卷残云技能时，额外增加20％的移动速度和物理闪避，持续3秒。",
	"永久增加自身11％的移动速度和物理闪避。同时甘宁每次自动施放风卷残云技能时，额外增加22％的移动速度和物理闪避，持续3秒。",
	"永久增加自身12％的移动速度和物理闪避。同时甘宁每次自动施放风卷残云技能时，额外增加24％的移动速度和物理闪避，持续3秒。",
	"永久增加自身13％的移动速度和物理闪避。同时甘宁每次自动施放风卷残云技能时，额外增加26％的移动速度和物理闪避，持续3秒。",
	"永久增加自身14％的移动速度和物理闪避。同时甘宁每次自动施放风卷残云技能时，额外增加28％的移动速度和物理闪避，持续3秒。",
	"永久增加自身15％的移动速度和物理闪避。同时甘宁每次自动施放风卷残云技能时，额外增加30％的移动速度和物理闪避，持续3秒。",
	"永久增加自身16％的移动速度和物理闪避。同时甘宁每次自动施放风卷残云技能时，额外增加32％的移动速度和物理闪避，持续3秒。",
	"永久增加自身17％的移动速度和物理闪避。同时甘宁每次自动施放风卷残云技能时，额外增加34％的移动速度和物理闪避，持续3秒。",
	"永久增加自身18％的移动速度和物理闪避。同时甘宁每次自动施放风卷残云技能时，额外增加36％的移动速度和物理闪避，持续3秒。",
}


_tab_stringS[11137] =
{
	"风驰电掣",
	"以极快的速度闪现到目标地点，并连续发动12次攻击，每次对附近随机的一个敌人造成攻击力100％的物理伤害。在此期间甘宁处于无敌状态。\n（施法范围：600）",
	"以极快的速度闪现到目标地点，并连续发动12次攻击，每次对附近随机的一个敌人造成攻击力115％的物理伤害。在此期间甘宁处于无敌状态。\n（施法范围：600）",
	"以极快的速度闪现到目标地点，并连续发动12次攻击，每次对附近随机的一个敌人造成攻击力130％的物理伤害。在此期间甘宁处于无敌状态。\n（施法范围：600）",
	"以极快的速度闪现到目标地点，并连续发动12次攻击，每次对附近随机的一个敌人造成攻击力145％的物理伤害。在此期间甘宁处于无敌状态。\n（施法范围：600）",
	"以极快的速度闪现到目标地点，并连续发动12次攻击，每次对附近随机的一个敌人造成攻击力160％的物理伤害。在此期间甘宁处于无敌状态。\n（施法范围：600）",
	"以极快的速度闪现到目标地点，并连续发动12次攻击，每次对附近随机的一个敌人造成攻击力175％的物理伤害。在此期间甘宁处于无敌状态。\n（施法范围：600）",
	"以极快的速度闪现到目标地点，并连续发动12次攻击，每次对附近随机的一个敌人造成攻击力190％的物理伤害。在此期间甘宁处于无敌状态。\n（施法范围：600）",
	"以极快的速度闪现到目标地点，并连续发动12次攻击，每次对附近随机的一个敌人造成攻击力205％的物理伤害。在此期间甘宁处于无敌状态。\n（施法范围：600）",
	"以极快的速度闪现到目标地点，并连续发动12次攻击，每次对附近随机的一个敌人造成攻击力220％的物理伤害。在此期间甘宁处于无敌状态。\n（施法范围：600）",
	"以极快的速度闪现到目标地点，并连续发动12次攻击，每次对附近随机的一个敌人造成攻击力235％的物理伤害。在此期间甘宁处于无敌状态。\n（施法范围：600）",
	"以极快的速度闪现到目标地点，并连续发动20次攻击，每次对附近随机的一个敌人造成攻击力250％的物理伤害。在此期间甘宁处于无敌状态。\n（施法范围：600）",
	"以极快的速度闪现到目标地点，并连续发动20次攻击，每次对附近随机的一个敌人造成攻击力265％的物理伤害。在此期间甘宁处于无敌状态。\n（施法范围：600）",
	"以极快的速度闪现到目标地点，并连续发动20次攻击，每次对附近随机的一个敌人造成攻击力280％的物理伤害。在此期间甘宁处于无敌状态。\n（施法范围：600）",
	"以极快的速度闪现到目标地点，并连续发动20次攻击，每次对附近随机的一个敌人造成攻击力295％的物理伤害。在此期间甘宁处于无敌状态。\n（施法范围：600）",
	"以极快的速度闪现到目标地点，并连续发动20次攻击，每次对附近随机的一个敌人造成攻击力310％的物理伤害。在此期间甘宁处于无敌状态。\n（施法范围：600）",
}



_tab_stringS[11313] =
{
	"鞭策",
	"激励自己或一名友军，使其提升6％的移动速度和24％的攻击速度，持续12秒。",
	"激励自己或一名友军，使其提升7％的移动速度和28％的攻击速度，持续12秒。",
	"激励自己或一名友军，使其提升8％的移动速度和32％的攻击速度，持续12秒。",
	"激励自己或一名友军，使其提升9％的移动速度和36％的攻击速度，持续12秒。",
	"激励自己或一名友军，使其提升10％的移动速度和40％的攻击速度，持续12秒。",
	"激励自己或一名友军，使其提升11％的移动速度和44％的攻击速度，持续12秒。",
	"激励自己或一名友军，使其提升12％的移动速度和48％的攻击速度，持续12秒。",
	"激励自己或一名友军，使其提升13％的移动速度和52％的攻击速度，持续12秒。",
	"激励自己或一名友军，使其提升14％的移动速度和56％的攻击速度，持续12秒。",
	"激励自己或一名友军，使其提升15％的移动速度和60％的攻击速度，持续12秒。",
	"激励自己或一名友军，使其提升16％的移动速度和64％的攻击速度，持续12秒。",
	"激励自己或一名友军，使其提升17％的移动速度和68％的攻击速度，持续12秒。",
	"激励自己或一名友军，使其提升18％的移动速度和72％的攻击速度，持续12秒。",
	"激励自己或一名友军，使其提升19％的移动速度和76％的攻击速度，持续12秒。",
	"激励自己或一名友军，使其提升20％的移动速度和80％的攻击速度，持续12秒。",
}


_tab_stringS[11315] =
{
	"冰霜镜像",
	"郭嘉每次释放冰河爆裂破或寒冰爆时，在身边召唤1个600点生命、28-40点攻击力的冰霜镜像为你战斗。冰霜镜像附加郭嘉16％的生命值和攻击力。冰霜镜像存在30秒。",
	"郭嘉每次释放冰河爆裂破或寒冰爆时，在身边召唤1个680点生命、36-52点攻击力的冰霜镜像为你战斗。冰霜镜像附加郭嘉17％的生命值和攻击力。冰霜镜像存在30秒。",
	"郭嘉每次释放冰河爆裂破或寒冰爆时，在身边召唤1个760点生命、44-64点攻击力的冰霜镜像为你战斗。冰霜镜像附加郭嘉18％的生命值和攻击力。冰霜镜像存在30秒。",
	"郭嘉每次释放冰河爆裂破或寒冰爆时，在身边召唤1个840点生命、52-76点攻击力的冰霜镜像为你战斗。冰霜镜像附加郭嘉19％的生命值和攻击力。冰霜镜像存在30秒。",
	"郭嘉每次释放冰河爆裂破或寒冰爆时，在身边召唤1个920点生命、60-88点攻击力的冰霜镜像为你战斗。冰霜镜像附加郭嘉20％的生命值和攻击力。冰霜镜像存在30秒。",
	"郭嘉每次释放冰河爆裂破或寒冰爆时，在身边召唤1个1000点生命、68-100点攻击力的冰霜镜像为你战斗。冰霜镜像附加郭嘉21％的生命值和攻击力。冰霜镜像存在30秒。",
	"郭嘉每次释放冰河爆裂破或寒冰爆时，在身边召唤1个1080点生命、76-112点攻击力的冰霜镜像为你战斗。冰霜镜像附加郭嘉22％的生命值和攻击力。冰霜镜像存在30秒。",
	"郭嘉每次释放冰河爆裂破或寒冰爆时，在身边召唤1个1160点生命、84-124点攻击力的冰霜镜像为你战斗。冰霜镜像附加郭嘉23％的生命值和攻击力。冰霜镜像存在30秒。",
	"郭嘉每次释放冰河爆裂破或寒冰爆时，在身边召唤1个1240点生命、92-136点攻击力的冰霜镜像为你战斗。冰霜镜像附加郭嘉24％的生命值和攻击力。冰霜镜像存在30秒。",
	"郭嘉每次释放冰河爆裂破或寒冰爆时，在身边召唤1个1320点生命、100-148点攻击力的冰霜镜像为你战斗。冰霜镜像附加郭嘉25％的生命值和攻击力。冰霜镜像存在30秒。",
	"郭嘉每次释放冰河爆裂破或寒冰爆时，在身边召唤1个1400点生命、108-160点攻击力的冰霜镜像为你战斗。冰霜镜像附加郭嘉26％的生命值和攻击力。冰霜镜像存在30秒。",
	"郭嘉每次释放冰河爆裂破或寒冰爆时，在身边召唤1个1480点生命、116-172点攻击力的冰霜镜像为你战斗。冰霜镜像附加郭嘉27％的生命值和攻击力。冰霜镜像存在30秒。",
	"郭嘉每次释放冰河爆裂破或寒冰爆时，在身边召唤1个1560点生命、124-184点攻击力的冰霜镜像为你战斗。冰霜镜像附加郭嘉28％的生命值和攻击力。冰霜镜像存在30秒。",
	"郭嘉每次释放冰河爆裂破或寒冰爆时，在身边召唤1个1640点生命、132-196点攻击力的冰霜镜像为你战斗。冰霜镜像附加郭嘉29％的生命值和攻击力。冰霜镜像存在30秒。",
	"郭嘉每次释放冰河爆裂破或寒冰爆时，在身边召唤1个1720点生命、140-208点攻击力的冰霜镜像为你战斗。冰霜镜像附加郭嘉30％的生命值和攻击力。冰霜镜像存在30秒。",
}



_tab_stringS[11314] =
{
	"弱点窥视",
	"暴露敌人的弱点，降低目标15点物理防御，持续12秒。",
	"暴露敌人的弱点，降低目标18点物理防御，持续12秒。",
	"暴露敌人的弱点，降低目标21点物理防御，持续12秒。",
	"暴露敌人的弱点，降低目标24点物理防御，持续12秒。",
	"暴露敌人的弱点，降低目标27点物理防御，持续12秒。",
	"暴露敌人的弱点，降低目标30点物理防御，持续12秒。",
	"暴露敌人的弱点，降低目标33点物理防御，持续12秒。",
	"暴露敌人的弱点，降低目标36点物理防御，持续12秒。",
	"暴露敌人的弱点，降低目标39点物理防御，持续12秒。",
	"暴露敌人的弱点，降低目标42点物理防御，持续12秒。",
	"暴露敌人的弱点，降低目标45点物理防御，持续12秒。",
	"暴露敌人的弱点，降低目标48点物理防御，持续12秒。",
	"暴露敌人的弱点，降低目标51点物理防御，持续12秒。",
	"暴露敌人的弱点，降低目标54点物理防御，持续12秒。",
	"暴露敌人的弱点，降低目标57点物理防御，持续12秒。",
}

_tab_stringS[11316] =
{
	"暂未开放",
	"赵云该技能暂未开放。",
}

_tab_stringS[11317] =
{
	"贪狼",
	"每次攻击使星轮斩冷却缩短0.5秒；同时夏侯惇施放星轮斩时，额外增加10％的吸血和20％的攻击速度，持续7秒。",
	"每次攻击使星轮斩冷却缩短0.5秒；同时夏侯惇施放星轮斩时，额外增加11％的吸血和22％的攻击速度，持续7秒。",
	"每次攻击使星轮斩冷却缩短0.5秒；同时夏侯惇施放星轮斩时，额外增加12％的吸血和24％的攻击速度，持续7秒。",
	"每次攻击使星轮斩冷却缩短0.5秒；同时夏侯惇施放星轮斩时，额外增加13％的吸血和26％的攻击速度，持续7秒。",
	"每次攻击使星轮斩冷却缩短0.5秒；同时夏侯惇施放星轮斩时，额外增加14％的吸血和28％的攻击速度，持续7秒。",
	"每次攻击使星轮斩冷却缩短0.5秒；同时夏侯惇施放星轮斩时，额外增加15％的吸血和30％的攻击速度，持续7秒。",
	"每次攻击使星轮斩冷却缩短0.5秒；同时夏侯惇施放星轮斩时，额外增加16％的吸血和32％的攻击速度，持续7秒。",
	"每次攻击使星轮斩冷却缩短0.5秒；同时夏侯惇施放星轮斩时，额外增加17％的吸血和34％的攻击速度，持续7秒。",
	"每次攻击使星轮斩冷却缩短0.5秒；同时夏侯惇施放星轮斩时，额外增加18％的吸血和36％的攻击速度，持续7秒。",
	"每次攻击使星轮斩冷却缩短0.5秒；同时夏侯惇施放星轮斩时，额外增加19％的吸血和38％的攻击速度，持续7秒。",
	"每次攻击使星轮斩冷却缩短0.5秒；同时夏侯惇施放星轮斩时，额外增加20％的吸血和40％的攻击速度，持续7秒。",
	"每次攻击使星轮斩冷却缩短0.5秒；同时夏侯惇施放星轮斩时，额外增加21％的吸血和42％的攻击速度，持续7秒。",
	"每次攻击使星轮斩冷却缩短0.5秒；同时夏侯惇施放星轮斩时，额外增加22％的吸血和44％的攻击速度，持续7秒。",
	"每次攻击使星轮斩冷却缩短0.5秒；同时夏侯惇施放星轮斩时，额外增加23％的吸血和46％的攻击速度，持续7秒。",
	"每次攻击使星轮斩冷却缩短0.5秒；同时夏侯惇施放星轮斩时，额外增加24％的吸血和48％的攻击速度，持续7秒。",
}


_tab_stringS[11318] =
{
	"战神怒火",
	"永久增加自身6%的暴击几率和16％的暴击伤害。同时吕布每次施放无双战神时，随机在200范围内施放12道怒火，每道怒火都对小范围敌人造成攻击力100％的物理伤害和1秒眩晕。",
	"永久增加自身7%的暴击几率和20％的暴击伤害。同时吕布每次施放无双战神时，随机在200范围内施放12道怒火，每道怒火都对小范围敌人造成攻击力120％的物理伤害和1秒眩晕。",
	"永久增加自身8%的暴击几率和24％的暴击伤害。同时吕布每次施放无双战神时，随机在200范围内施放12道怒火，每道怒火都对小范围敌人造成攻击力140％的物理伤害和1秒眩晕。",
	"永久增加自身9%的暴击几率和28％的暴击伤害。同时吕布每次施放无双战神时，随机在200范围内施放12道怒火，每道怒火都对小范围敌人造成攻击力160％的物理伤害和1秒眩晕。",
	"永久增加自身10%的暴击几率和32％的暴击伤害。同时吕布每次施放无双战神时，随机在200范围内施放12道怒火，每道怒火都对小范围敌人造成攻击力180％的物理伤害和1秒眩晕。",
	"永久增加自身11%的暴击几率和36％的暴击伤害。同时吕布每次施放无双战神时，随机在200范围内施放12道怒火，每道怒火都对小范围敌人造成攻击力200％的物理伤害和1秒眩晕。",
	"永久增加自身12%的暴击几率和40％的暴击伤害。同时吕布每次施放无双战神时，随机在200范围内施放12道怒火，每道怒火都对小范围敌人造成攻击力220％的物理伤害和1秒眩晕。",
	"永久增加自身13%的暴击几率和44％的暴击伤害。同时吕布每次施放无双战神时，随机在200范围内施放12道怒火，每道怒火都对小范围敌人造成攻击力240％的物理伤害和1秒眩晕。",
	"永久增加自身14%的暴击几率和48％的暴击伤害。同时吕布每次施放无双战神时，随机在200范围内施放12道怒火，每道怒火都对小范围敌人造成攻击力260％的物理伤害和1秒眩晕。",
	"永久增加自身15%的暴击几率和52％的暴击伤害。同时吕布每次施放无双战神时，随机在200范围内施放12道怒火，每道怒火都对小范围敌人造成攻击力280％的物理伤害和1秒眩晕。",
	"永久增加自身16%的暴击几率和56％的暴击伤害。同时吕布每次施放无双战神时，随机在200范围内施放12道怒火，每道怒火都对小范围敌人造成攻击力300％的物理伤害和1秒眩晕。",
	"永久增加自身17%的暴击几率和60％的暴击伤害。同时吕布每次施放无双战神时，随机在200范围内施放12道怒火，每道怒火都对小范围敌人造成攻击力320％的物理伤害和1秒眩晕。",
	"永久增加自身18%的暴击几率和64％的暴击伤害。同时吕布每次施放无双战神时，随机在200范围内施放12道怒火，每道怒火都对小范围敌人造成攻击力340％的物理伤害和1秒眩晕。",
	"永久增加自身19%的暴击几率和68％的暴击伤害。同时吕布每次施放无双战神时，随机在200范围内施放12道怒火，每道怒火都对小范围敌人造成攻击力360％的物理伤害和1秒眩晕。",
	"永久增加自身20%的暴击几率和72％的暴击伤害。同时吕布每次施放无双战神时，随机在200范围内施放12道怒火，每道怒火都对小范围敌人造成攻击力380％的物理伤害和1秒眩晕。",
}

_tab_stringS[11319] =
{
	"飞燕起舞",
	"永久增加自身11％的移动速度和20％的攻击速度。同时貂蝉每次施放月下美人时免疫控制和减速效果，持续5秒。",
	"永久增加自身12％的移动速度和22％的攻击速度。同时貂蝉每次施放月下美人时免疫控制和减速效果，持续5秒。",
	"永久增加自身13％的移动速度和24％的攻击速度。同时貂蝉每次施放月下美人时免疫控制和减速效果，持续5秒。",
	"永久增加自身14％的移动速度和26％的攻击速度。同时貂蝉每次施放月下美人时免疫控制和减速效果，持续5秒。",
	"永久增加自身15％的移动速度和28％的攻击速度。同时貂蝉每次施放月下美人时免疫控制和减速效果，持续5秒。",
	"永久增加自身16％的移动速度和30％的攻击速度。同时貂蝉每次施放月下美人时免疫控制和减速效果，持续5秒。",
	"永久增加自身17％的移动速度和32％的攻击速度。同时貂蝉每次施放月下美人时免疫控制和减速效果，持续5秒。",
	"永久增加自身18％的移动速度和34％的攻击速度。同时貂蝉每次施放月下美人时免疫控制和减速效果，持续5秒。",
	"永久增加自身19％的移动速度和36％的攻击速度。同时貂蝉每次施放月下美人时免疫控制和减速效果，持续5秒。",
	"永久增加自身20％的移动速度和38％的攻击速度。同时貂蝉每次施放月下美人时免疫控制和减速效果，持续5秒。",
	"永久增加自身21％的移动速度和40％的攻击速度。同时貂蝉每次施放月下美人时免疫控制和减速效果，持续5秒。",
	"永久增加自身22％的移动速度和42％的攻击速度。同时貂蝉每次施放月下美人时免疫控制和减速效果，持续5秒。",
	"永久增加自身23％的移动速度和44％的攻击速度。同时貂蝉每次施放月下美人时免疫控制和减速效果，持续5秒。",
	"永久增加自身24％的移动速度和46％的攻击速度。同时貂蝉每次施放月下美人时免疫控制和减速效果，持续5秒。",
	"永久增加自身25％的移动速度和48％的攻击速度。同时貂蝉每次施放月下美人时免疫控制和减速效果，持续5秒。",
}

_tab_stringS[11320] =
{
	"镇军战旗",
	"在身边放置一面战旗，提升附近300范围内的友军和据点2点物理防御和每秒2点回血。战旗存在20秒。",
	"在身边放置一面战旗，提升附近300范围内的友军和据点4点物理防御和每秒4点回血。战旗存在20秒。",
	"在身边放置一面战旗，提升附近300范围内的友军和据点6点物理防御和每秒6点回血。战旗存在20秒。",
	"在身边放置一面战旗，提升附近300范围内的友军和据点8点物理防御和每秒8点回血。战旗存在20秒。",
	"在身边放置一面战旗，提升附近300范围内的友军和据点10点物理防御和每秒10点回血。战旗存在20秒。",
	"在身边放置一面战旗，提升附近300范围内的友军和据点12点物理防御和每秒12点回血。战旗存在20秒。",
	"在身边放置一面战旗，提升附近300范围内的友军和据点14点物理防御和每秒14点回血。战旗存在20秒。",
	"在身边放置一面战旗，提升附近300范围内的友军和据点16点物理防御和每秒16点回血。战旗存在20秒。",
	"在身边放置一面战旗，提升附近300范围内的友军和据点18点物理防御和每秒18点回血。战旗存在20秒。",
	"在身边放置一面战旗，提升附近300范围内的友军和据点20点物理防御和每秒20点回血。战旗存在20秒。",
	"在身边放置一面战旗，提升附近300范围内的友军和据点22点物理防御和每秒22点回血。战旗存在20秒。",
	"在身边放置一面战旗，提升附近300范围内的友军和据点24点物理防御和每秒24点回血。战旗存在20秒。",
	"在身边放置一面战旗，提升附近300范围内的友军和据点26点物理防御和每秒26点回血。战旗存在20秒。",
	"在身边放置一面战旗，提升附近300范围内的友军和据点28点物理防御和每秒28点回血。战旗存在20秒。",
	"在身边放置一面战旗，提升附近300范围内的友军和据点30点物理防御和每秒30点回血。战旗存在20秒。",
}

_tab_stringS[11321] =
{
	"虎痴",
	"永久增加自身200点生命值。同时许褚每次攻击额外造成自身当前生命值1.4％的溅射伤害。",
	"永久增加自身300点生命值。同时许褚每次攻击额外造成自身当前生命值1.8％的溅射伤害。",
	"永久增加自身400点生命值。同时许褚每次攻击额外造成自身当前生命值2.2％的溅射伤害。",
	"永久增加自身500点生命值。同时许褚每次攻击额外造成自身当前生命值2.6％的溅射伤害。",
	"永久增加自身600点生命值。同时许褚每次攻击额外造成自身当前生命值3％的溅射伤害。",
	"永久增加自身700点生命值。同时许褚每次攻击额外造成自身当前生命值3.4％的溅射伤害。",
	"永久增加自身800点生命值。同时许褚每次攻击额外造成自身当前生命值3.8％的溅射伤害。",
	"永久增加自身900点生命值。同时许褚每次攻击额外造成自身当前生命值4.2％的溅射伤害。",
	"永久增加自身1000点生命值。同时许褚每次攻击额外造成自身当前生命值4.6％的溅射伤害。",
	"永久增加自身1100点生命值。同时许褚每次攻击额外造成自身当前生命值5％的溅射伤害。",
	"永久增加自身1200点生命值。同时许褚每次攻击额外造成自身当前生命值5.4％的溅射伤害。",
	"永久增加自身1300点生命值。同时许褚每次攻击额外造成自身当前生命值5.8％的溅射伤害。",
	"永久增加自身1400点生命值。同时许褚每次攻击额外造成自身当前生命值6.2％的溅射伤害。",
	"永久增加自身1500点生命值。同时许褚每次攻击额外造成自身当前生命值6.6％的溅射伤害。",
	"永久增加自身1600点生命值。同时许褚每次攻击额外造成自身当前生命值7％的溅射伤害。",
}

_tab_stringS[11322] =
{
	"恶来",
	"典韦生命值低于50％时触发恶来效果，提升12％的暴击几率和18％的暴击伤害，持续12秒。（恶来效果30秒内只能触发一次）",
	"典韦生命值低于50％时触发恶来效果，提升13％的暴击几率和21％的暴击伤害，持续12秒。（恶来效果30秒内只能触发一次）",
	"典韦生命值低于50％时触发恶来效果，提升14％的暴击几率和24％的暴击伤害，持续12秒。（恶来效果30秒内只能触发一次）",
	"典韦生命值低于50％时触发恶来效果，提升15％的暴击几率和27％的暴击伤害，持续12秒。（恶来效果30秒内只能触发一次）",
	"典韦生命值低于50％时触发恶来效果，提升16％的暴击几率和30％的暴击伤害，持续12秒。（恶来效果30秒内只能触发一次）",
	"典韦生命值低于50％时触发恶来效果，提升17％的暴击几率和33％的暴击伤害，持续12秒。（恶来效果30秒内只能触发一次）",
	"典韦生命值低于50％时触发恶来效果，提升18％的暴击几率和36％的暴击伤害，持续12秒。（恶来效果30秒内只能触发一次）",
	"典韦生命值低于50％时触发恶来效果，提升19％的暴击几率和39％的暴击伤害，持续12秒。（恶来效果30秒内只能触发一次）",
	"典韦生命值低于50％时触发恶来效果，提升20％的暴击几率和42％的暴击伤害，持续12秒。（恶来效果30秒内只能触发一次）",
	"典韦生命值低于50％时触发恶来效果，提升21％的暴击几率和45％的暴击伤害，持续12秒。（恶来效果30秒内只能触发一次）",
	"典韦生命值低于50％时触发恶来效果，提升22％的暴击几率和48％的暴击伤害，持续12秒。（恶来效果30秒内只能触发一次）",
	"典韦生命值低于50％时触发恶来效果，提升23％的暴击几率和51％的暴击伤害，持续12秒。（恶来效果30秒内只能触发一次）",
	"典韦生命值低于50％时触发恶来效果，提升24％的暴击几率和54％的暴击伤害，持续12秒。（恶来效果30秒内只能触发一次）",
	"典韦生命值低于50％时触发恶来效果，提升25％的暴击几率和57％的暴击伤害，持续12秒。（恶来效果30秒内只能触发一次）",
	"典韦生命值低于50％时触发恶来效果，提升26％的暴击几率和60％的暴击伤害，持续12秒。（恶来效果30秒内只能触发一次）",
}
_tab_stringS[11350] =
{
	"霸王怒喝",
	"发出一声怒喝，对自身60范围内的敌人造成攻击力50％的真实伤害，并混乱1.5秒。混乱期间目标不受操控并四处乱走。",
	"发出一声怒喝，对自身60范围内的敌人造成攻击力55％的真实伤害，并混乱1.6秒。混乱期间目标不受操控并四处乱走。",
	"发出一声怒喝，对自身60范围内的敌人造成攻击力60％的真实伤害，并混乱1.7秒。混乱期间目标不受操控并四处乱走。",
	"发出一声怒喝，对自身60范围内的敌人造成攻击力65％的真实伤害，并混乱1.8秒。混乱期间目标不受操控并四处乱走。",
	"发出一声怒喝，对自身60范围内的敌人造成攻击力70％的真实伤害，并混乱1.9秒。混乱期间目标不受操控并四处乱走。",
	"发出一声怒喝，对自身60范围内的敌人造成攻击力75％的真实伤害，并混乱2秒。混乱期间目标不受操控并四处乱走。",
	"发出一声怒喝，对自身60范围内的敌人造成攻击力80％的真实伤害，并混乱2.1秒。混乱期间目标不受操控并四处乱走。",
	"发出一声怒喝，对自身60范围内的敌人造成攻击力85％的真实伤害，并混乱2.2秒。混乱期间目标不受操控并四处乱走。",
	"发出一声怒喝，对自身60范围内的敌人造成攻击力90％的真实伤害，并混乱2.3秒。混乱期间目标不受操控并四处乱走。",
	"发出一声怒喝，对自身60范围内的敌人造成攻击力95％的真实伤害，并混乱2.4秒。混乱期间目标不受操控并四处乱走。",
	"发出一声怒喝，对自身60范围内的敌人造成攻击力100％的真实伤害，并混乱2.5秒。混乱期间目标不受操控并四处乱走。",
	"发出一声怒喝，对自身60范围内的敌人造成攻击力105％的真实伤害，并混乱2.6秒。混乱期间目标不受操控并四处乱走。",
	"发出一声怒喝，对自身60范围内的敌人造成攻击力110％的真实伤害，并混乱2.7秒。混乱期间目标不受操控并四处乱走。",
	"发出一声怒喝，对自身60范围内的敌人造成攻击力115％的真实伤害，并混乱2.8秒。混乱期间目标不受操控并四处乱走。",
	"发出一声怒喝，对自身60范围内的敌人造成攻击力120％的真实伤害，并混乱2.9秒。混乱期间目标不受操控并四处乱走。",
}

--孙策战术技能
_tab_stringS[11352] =
{
	"霸气剑光",
	"随机在目标地点100范围内召唤12把落剑，每一把落剑都对小范围敌人造成攻击力100％+60点的真实伤害。\n（施法范围：200）",
	"随机在目标地点100范围内召唤12把落剑，每一把落剑都对小范围敌人造成攻击力110％+75点的真实伤害。\n（施法范围：200）",
	"随机在目标地点100范围内召唤12把落剑，每一把落剑都对小范围敌人造成攻击力120％+90点的真实伤害。\n（施法范围：200）",
	"随机在目标地点100范围内召唤12把落剑，每一把落剑都对小范围敌人造成攻击力130％+105点的真实伤害。\n（施法范围：200）",
	"随机在目标地点100范围内召唤12把落剑，每一把落剑都对小范围敌人造成攻击力140％+120点的真实伤害。\n（施法范围：200）",
	"随机在目标地点100范围内召唤12把落剑，每一把落剑都对小范围敌人造成攻击力150％+135点的真实伤害。\n（施法范围：200）",
	"随机在目标地点100范围内召唤12把落剑，每一把落剑都对小范围敌人造成攻击力160％+150点的真实伤害。\n（施法范围：200）",
	"随机在目标地点100范围内召唤12把落剑，每一把落剑都对小范围敌人造成攻击力170％+165点的真实伤害。\n（施法范围：200）",
	"随机在目标地点100范围内召唤12把落剑，每一把落剑都对小范围敌人造成攻击力180％+180点的真实伤害。\n（施法范围：200）",
	"随机在目标地点100范围内召唤12把落剑，每一把落剑都对小范围敌人造成攻击力190％+195点的真实伤害。\n（施法范围：200）",
	"随机在目标地点100范围内召唤12把落剑，每一把落剑都对小范围敌人造成攻击力200％+210点的真实伤害。\n（施法范围：200）",
	"随机在目标地点100范围内召唤12把落剑，每一把落剑都对小范围敌人造成攻击力210％+225点的真实伤害。\n（施法范围：200）",
	"随机在目标地点100范围内召唤12把落剑，每一把落剑都对小范围敌人造成攻击力220％+240点的真实伤害。\n（施法范围：200）",
	"随机在目标地点100范围内召唤12把落剑，每一把落剑都对小范围敌人造成攻击力230％+255点的真实伤害。\n（施法范围：200）",
	"随机在目标地点100范围内召唤12把落剑，每一把落剑都对小范围敌人造成攻击力240％+270点的真实伤害。\n（施法范围：200）",
}


_tab_stringS[11353] =
{
	"护体罡气",
	"获得一层护盾，使自己进入无敌状态，持续1秒。",
	"获得一层护盾，使自己进入无敌状态，持续1.2秒。",
	"获得一层护盾，使自己进入无敌状态，持续1.4秒。",
	"获得一层护盾，使自己进入无敌状态，持续1.6秒。",
	"获得一层护盾，使自己进入无敌状态，持续1.8秒。",
	"获得一层护盾，使自己进入无敌状态，持续2秒。",
	"获得一层护盾，使自己进入无敌状态，持续2.2秒。",
	"获得一层护盾，使自己进入无敌状态，持续2.4秒。",
	"获得一层护盾，使自己进入无敌状态，持续2.6秒。",
	"获得一层护盾，使自己进入无敌状态，持续2.8秒。",
	"获得一层护盾，使自己进入无敌状态，持续3秒。",
	"获得一层护盾，使自己进入无敌状态，持续3.2秒。",
	"获得一层护盾，使自己进入无敌状态，持续3.4秒。",
	"获得一层护盾，使自己进入无敌状态，持续3.6秒。",
	"获得一层护盾，使自己进入无敌状态，持续3.8秒。",
}




_tab_stringS[11370] =
{
	"业火",
	"以诡奇兵法对目标释放一团业火，对目标和目标80范围内的敌人造成攻击力100％+120点的法术伤害。",
	"以诡奇兵法对目标释放一团业火，对目标和目标80范围内的敌人造成攻击力115％+150点的法术伤害。",
	"以诡奇兵法对目标释放一团业火，对目标和目标80范围内的敌人造成攻击力130％+180点的法术伤害。",
	"以诡奇兵法对目标释放一团业火，对目标和目标80范围内的敌人造成攻击力145％+210点的法术伤害。",
	"以诡奇兵法对目标释放一团业火，对目标和目标80范围内的敌人造成攻击力160％+240点的法术伤害。",
	"以诡奇兵法对目标释放一团业火，对目标和目标80范围内的敌人造成攻击力175％+270点的法术伤害。",
	"以诡奇兵法对目标释放一团业火，对目标和目标80范围内的敌人造成攻击力190％+300点的法术伤害。",
	"以诡奇兵法对目标释放一团业火，对目标和目标80范围内的敌人造成攻击力205％+330点的法术伤害。",
	"以诡奇兵法对目标释放一团业火，对目标和目标80范围内的敌人造成攻击力220％+360点的法术伤害。",
	"以诡奇兵法对目标释放一团业火，对目标和目标80范围内的敌人造成攻击力235％+390点的法术伤害。",
	"以诡奇兵法对目标释放一团业火，对目标和目标80范围内的敌人造成攻击力250％+420点的法术伤害。",
	"以诡奇兵法对目标释放一团业火，对目标和目标80范围内的敌人造成攻击力265％+450点的法术伤害。",
	"以诡奇兵法对目标释放一团业火，对目标和目标80范围内的敌人造成攻击力280％+480点的法术伤害。",
	"以诡奇兵法对目标释放一团业火，对目标和目标80范围内的敌人造成攻击力295％+510点的法术伤害。",
	"以诡奇兵法对目标释放一团业火，对目标和目标80范围内的敌人造成攻击力310％+540点的法术伤害。",
}


--周瑜战术技能
_tab_stringS[11371] = {"召唤水兵",
	"召唤4个水兵为你战斗。水兵附加周瑜44％的生命值、攻击力、物理防御、法术防御。水兵存在25秒。\n（施法范围：全地图）",
	"召唤4个水兵为你战斗。水兵附加周瑜48％的生命值、攻击力、物理防御、法术防御。水兵存在25秒。\n（施法范围：全地图）",
	"召唤4个水兵为你战斗。水兵附加周瑜52％的生命值、攻击力、物理防御、法术防御。水兵存在25秒。\n（施法范围：全地图）",
	"召唤4个水兵为你战斗。水兵附加周瑜56％的生命值、攻击力、物理防御、法术防御。水兵存在25秒。\n（施法范围：全地图）",
	"召唤4个水兵为你战斗。水兵附加周瑜60％的生命值、攻击力、物理防御、法术防御。水兵存在25秒。\n（施法范围：全地图）",
	"召唤4个水兵为你战斗。水兵附加周瑜64％的生命值、攻击力、物理防御、法术防御。水兵存在25秒。\n（施法范围：全地图）",
	"召唤4个水兵为你战斗。水兵附加周瑜68％的生命值、攻击力、物理防御、法术防御。水兵存在25秒。\n（施法范围：全地图）",
	"召唤4个水兵为你战斗。水兵附加周瑜72％的生命值、攻击力、物理防御、法术防御。水兵存在25秒。\n（施法范围：全地图）",
	"召唤4个水兵为你战斗。水兵附加周瑜76％的生命值、攻击力、物理防御、法术防御。水兵存在25秒。\n（施法范围：全地图）",
	"召唤4个水兵为你战斗。水兵附加周瑜80％的生命值、攻击力、物理防御、法术防御。水兵存在25秒。\n（施法范围：全地图）",
	"召唤4个鳞甲水兵为你战斗。鳞甲水兵拥有免疫控制和减速效果，并附加周瑜84％的生命值、攻击力、物理防御、法术防御。鳞甲水兵存在25秒。\n（施法范围：全地图）",
	"召唤4个鳞甲水兵为你战斗。鳞甲水兵拥有免疫控制和减速效果，并附加周瑜88％的生命值、攻击力、物理防御、法术防御。鳞甲水兵存在25秒。\n（施法范围：全地图）",
	"召唤4个鳞甲水兵为你战斗。鳞甲水兵拥有免疫控制和减速效果，并附加周瑜92％的生命值、攻击力、物理防御、法术防御。鳞甲水兵存在25秒。\n（施法范围：全地图）",
	"召唤4个鳞甲水兵为你战斗。鳞甲水兵拥有免疫控制和减速效果，并附加周瑜96％的生命值、攻击力、物理防御、法术防御。鳞甲水兵存在25秒。\n（施法范围：全地图）",
	"召唤4个鳞甲水兵为你战斗。鳞甲水兵拥有免疫控制和减速效果，并附加周瑜100％的生命值、攻击力、物理防御、法术防御。鳞甲水兵存在25秒。\n（施法范围：全地图）",
}

_tab_stringS[11372] =
{
	"英姿",
	"用英勇的身姿激励附近友军的战斗欲望。提升自己和附近100范围内的友军10％的攻击力和10％的攻击速度，持续18秒。",
	"用英勇的身姿激励附近友军的战斗欲望。提升自己和附近100范围内的友军12％的攻击力和12％的攻击速度，持续18秒。",
	"用英勇的身姿激励附近友军的战斗欲望。提升自己和附近100范围内的友军14％的攻击力和14％的攻击速度，持续18秒。",
	"用英勇的身姿激励附近友军的战斗欲望。提升自己和附近100范围内的友军16％的攻击力和16％的攻击速度，持续18秒。",
	"用英勇的身姿激励附近友军的战斗欲望。提升自己和附近100范围内的友军18％的攻击力和18％的攻击速度，持续18秒。",
	"用英勇的身姿激励附近友军的战斗欲望。提升自己和附近100范围内的友军20％的攻击力和20％的攻击速度，持续18秒。",
	"用英勇的身姿激励附近友军的战斗欲望。提升自己和附近100范围内的友军22％的攻击力和22％的攻击速度，持续18秒。",
	"用英勇的身姿激励附近友军的战斗欲望。提升自己和附近100范围内的友军24％的攻击力和24％的攻击速度，持续18秒。",
	"用英勇的身姿激励附近友军的战斗欲望。提升自己和附近100范围内的友军26％的攻击力和26％的攻击速度，持续18秒。",
	"用英勇的身姿激励附近友军的战斗欲望。提升自己和附近100范围内的友军28％的攻击力和28％的攻击速度，持续18秒。",
	"用英勇的身姿激励附近友军的战斗欲望。提升自己和附近100范围内的友军30％的攻击力和30％的攻击速度，持续18秒。",
	"用英勇的身姿激励附近友军的战斗欲望。提升自己和附近100范围内的友军32％的攻击力和32％的攻击速度，持续18秒。",
	"用英勇的身姿激励附近友军的战斗欲望。提升自己和附近100范围内的友军34％的攻击力和34％的攻击速度，持续18秒。",
	"用英勇的身姿激励附近友军的战斗欲望。提升自己和附近100范围内的友军36％的攻击力和36％的攻击速度，持续18秒。",
	"用英勇的身姿激励附近友军的战斗欲望。提升自己和附近100范围内的友军38％的攻击力和38％的攻击速度，持续18秒。",
}

--徐庶技能
_tab_stringS[30037] = {"剑影瞬杀阵",
	"化身为剑影，对目标地点150范围内的敌人连续发动7段攻击，每段造成攻击力50％+20～40点的物理伤害。最后1段额外造成穿刺，并将敌人抛向空中，落地后继续眩晕1秒。\n（施法范围：360）",
	"化身为剑影，对目标地点150范围内的敌人连续发动7段攻击，每段造成攻击力55％+30～60点的物理伤害。最后1段额外造成穿刺，并将敌人抛向空中，落地后继续眩晕1秒。\n（施法范围：360）",
	"化身为剑影，对目标地点150范围内的敌人连续发动7段攻击，每段造成攻击力60％+40～80点的物理伤害。最后1段额外造成穿刺，并将敌人抛向空中，落地后继续眩晕1秒。\n（施法范围：360）",
	"化身为剑影，对目标地点150范围内的敌人连续发动7段攻击，每段造成攻击力65％+50～100点的物理伤害。最后1段额外造成穿刺，并将敌人抛向空中，落地后继续眩晕1秒。\n（施法范围：360）",
	"化身为剑影，对目标地点150范围内的敌人连续发动7段攻击，每段造成攻击力70％+60～120点的物理伤害。最后1段额外造成穿刺，并将敌人抛向空中，落地后继续眩晕1秒。\n（施法范围：360）",
	"化身为剑影，对目标地点150范围内的敌人连续发动7段攻击，每段造成攻击力75％+70～140点的物理伤害。最后1段额外造成穿刺，并将敌人抛向空中，落地后继续眩晕1秒。\n（施法范围：360）",
	"化身为剑影，对目标地点150范围内的敌人连续发动7段攻击，每段造成攻击力80％+80～160点的物理伤害。最后1段额外造成穿刺，并将敌人抛向空中，落地后继续眩晕1秒。\n（施法范围：360）",
	"化身为剑影，对目标地点150范围内的敌人连续发动7段攻击，每段造成攻击力85％+90～180点的物理伤害。最后1段额外造成穿刺，并将敌人抛向空中，落地后继续眩晕1秒。\n（施法范围：360）",
	"化身为剑影，对目标地点150范围内的敌人连续发动7段攻击，每段造成攻击力90％+100～200点的物理伤害。最后1段额外造成穿刺，并将敌人抛向空中，落地后继续眩晕1秒。\n（施法范围：360）",
	"化身为剑影，对目标地点150范围内的敌人连续发动7段攻击，每段造成攻击力95％+110～220点的物理伤害。最后1段额外造成穿刺，并将敌人抛向空中，落地后继续眩晕1秒。\n（施法范围：360）",
	"化身为剑影，对目标地点150范围内的敌人连续发动7段攻击，每段造成攻击力100％+120～240点的物理伤害。最后1段额外造成穿刺，并将敌人抛向空中，落地后继续眩晕1秒。\n（施法范围：360）",
	"化身为剑影，对目标地点150范围内的敌人连续发动7段攻击，每段造成攻击力105％+130～260点的物理伤害。最后1段额外造成穿刺，并将敌人抛向空中，落地后继续眩晕1秒。\n（施法范围：360）",
	"化身为剑影，对目标地点150范围内的敌人连续发动7段攻击，每段造成攻击力110％+140～280点的物理伤害。最后1段额外造成穿刺，并将敌人抛向空中，落地后继续眩晕1秒。\n（施法范围：360）",
	"化身为剑影，对目标地点150范围内的敌人连续发动7段攻击，每段造成攻击力115％+150～300点的物理伤害。最后1段额外造成穿刺，并将敌人抛向空中，落地后继续眩晕1秒。\n（施法范围：360）",
	"化身为剑影，对目标地点150范围内的敌人连续发动7段攻击，每段造成攻击力120％+160～320点的物理伤害。最后1段额外造成穿刺，并将敌人抛向空中，落地后继续眩晕1秒。\n（施法范围：360）",
}

_tab_stringS[30039] = {"冰心剑魄",
	"使寒冰血脉流淌全身，增加自身12％的攻击速度。如果自身150范围内只存在一个敌人，那么额外增加自身24％的攻击速度，持续5秒。",
	"使寒冰血脉流淌全身，增加自身14％的攻击速度。如果自身150范围内只存在一个敌人，那么额外增加自身28％的攻击速度，持续5秒。",
	"使寒冰血脉流淌全身，增加自身16％的攻击速度。如果自身150范围内只存在一个敌人，那么额外增加自身32％的攻击速度，持续5秒。",
	"使寒冰血脉流淌全身，增加自身18％的攻击速度。如果自身150范围内只存在一个敌人，那么额外增加自身36％的攻击速度，持续5秒。",
	"使寒冰血脉流淌全身，增加自身20％的攻击速度。如果自身150范围内只存在一个敌人，那么额外增加自身40％的攻击速度，持续5秒。",
	"使寒冰血脉流淌全身，增加自身22％的攻击速度。如果自身150范围内只存在一个敌人，那么额外增加自身44％的攻击速度，持续5秒。",
	"使寒冰血脉流淌全身，增加自身24％的攻击速度。如果自身150范围内只存在一个敌人，那么额外增加自身48％的攻击速度，持续5秒。",
	"使寒冰血脉流淌全身，增加自身26％的攻击速度。如果自身150范围内只存在一个敌人，那么额外增加自身52％的攻击速度，持续5秒。",
	"使寒冰血脉流淌全身，增加自身28％的攻击速度。如果自身150范围内只存在一个敌人，那么额外增加自身56％的攻击速度，持续5秒。",
	"使寒冰血脉流淌全身，增加自身30％的攻击速度。如果自身150范围内只存在一个敌人，那么额外增加自身60％的攻击速度，持续5秒。",
	"使寒冰血脉流淌全身，增加自身32％的攻击速度。如果自身150范围内只存在一个敌人，那么额外增加自身64％的攻击速度，持续5秒。",
	"使寒冰血脉流淌全身，增加自身34％的攻击速度。如果自身150范围内只存在一个敌人，那么额外增加自身68％的攻击速度，持续5秒。",
	"使寒冰血脉流淌全身，增加自身36％的攻击速度。如果自身150范围内只存在一个敌人，那么额外增加自身72％的攻击速度，持续5秒。",
	"使寒冰血脉流淌全身，增加自身38％的攻击速度。如果自身150范围内只存在一个敌人，那么额外增加自身76％的攻击速度，持续5秒。",
	"使寒冰血脉流淌全身，增加自身40％的攻击速度。如果自身150范围内只存在一个敌人，那么额外增加自身80％的攻击速度，持续5秒。",
}

_tab_stringS[30041] = {"寒霜剑意",
	"增强【剑影瞬杀阵】：徐庶每次攻击有52％的几率使剑影瞬杀阵冷却缩短1秒。\n增强【冰心剑魄】：发动冰心剑魄时，使24范围内的敌人冻结1秒。",
	"增强【剑影瞬杀阵】：徐庶每次攻击有54％的几率使剑影瞬杀阵冷却缩短1秒。\n增强【冰心剑魄】：发动冰心剑魄时，使28范围内的敌人冻结1秒。",
	"增强【剑影瞬杀阵】：徐庶每次攻击有56％的几率使剑影瞬杀阵冷却缩短1秒。\n增强【冰心剑魄】：发动冰心剑魄时，使32范围内的敌人冻结1秒。",
	"增强【剑影瞬杀阵】：徐庶每次攻击有58％的几率使剑影瞬杀阵冷却缩短1秒。\n增强【冰心剑魄】：发动冰心剑魄时，使36范围内的敌人冻结1秒。",
	"增强【剑影瞬杀阵】：徐庶每次攻击有60％的几率使剑影瞬杀阵冷却缩短1秒。\n增强【冰心剑魄】：发动冰心剑魄时，使40范围内的敌人冻结1秒。",
	"增强【剑影瞬杀阵】：徐庶每次攻击有62％的几率使剑影瞬杀阵冷却缩短1秒。\n增强【冰心剑魄】：发动冰心剑魄时，使44范围内的敌人冻结1秒。",
	"增强【剑影瞬杀阵】：徐庶每次攻击有64％的几率使剑影瞬杀阵冷却缩短1秒。\n增强【冰心剑魄】：发动冰心剑魄时，使48范围内的敌人冻结1秒。",
	"增强【剑影瞬杀阵】：徐庶每次攻击有66％的几率使剑影瞬杀阵冷却缩短1秒。\n增强【冰心剑魄】：发动冰心剑魄时，使52范围内的敌人冻结1秒。",
	"增强【剑影瞬杀阵】：徐庶每次攻击有68％的几率使剑影瞬杀阵冷却缩短1秒。\n增强【冰心剑魄】：发动冰心剑魄时，使56范围内的敌人冻结1秒。",
	"增强【剑影瞬杀阵】：徐庶每次攻击有70％的几率使剑影瞬杀阵冷却缩短1秒。\n增强【冰心剑魄】：发动冰心剑魄时，使60范围内的敌人冻结1秒。",
	"增强【剑影瞬杀阵】：徐庶每次攻击有72％的几率使剑影瞬杀阵冷却缩短1秒。\n增强【冰心剑魄】：发动冰心剑魄时，使64范围内的敌人冻结1秒。",
	"增强【剑影瞬杀阵】：徐庶每次攻击有74％的几率使剑影瞬杀阵冷却缩短1秒。\n增强【冰心剑魄】：发动冰心剑魄时，使68范围内的敌人冻结1秒。",
	"增强【剑影瞬杀阵】：徐庶每次攻击有76％的几率使剑影瞬杀阵冷却缩短1秒。\n增强【冰心剑魄】：发动冰心剑魄时，使72范围内的敌人冻结1秒。",
	"增强【剑影瞬杀阵】：徐庶每次攻击有78％的几率使剑影瞬杀阵冷却缩短1秒。\n增强【冰心剑魄】：发动冰心剑魄时，使76范围内的敌人冻结1秒。",
	"增强【剑影瞬杀阵】：徐庶每次攻击有80％的几率使剑影瞬杀阵冷却缩短1秒。\n增强【冰心剑魄】：发动冰心剑魄时，使80范围内的敌人冻结1秒。",
}

--PVP徐庶技能
_tab_stringS[30049] = {"剑影瞬杀阵（竞技场）",
	"化身为剑影，对目标地点150范围内地面上的的敌人连续发动7段攻击，每段造成攻击力50％+20～40点的物理伤害。最后1段额外造成穿刺，并将敌人抛向空中，落地后继续眩晕1秒。\n（施法范围：180）",
	"化身为剑影，对目标地点150范围内地面上的敌人连续发动7段攻击，每段造成攻击力55％+30～60点的物理伤害。最后1段额外造成穿刺，并将敌人抛向空中，落地后继续眩晕1秒。\n（施法范围：180）",
	"化身为剑影，对目标地点150范围内地面上的敌人连续发动7段攻击，每段造成攻击力60％+40～80点的物理伤害。最后1段额外造成穿刺，并将敌人抛向空中，落地后继续眩晕1秒。\n（施法范围：180）",
	"化身为剑影，对目标地点150范围内地面上的敌人连续发动7段攻击，每段造成攻击力65％+50～100点的物理伤害。最后1段额外造成穿刺，并将敌人抛向空中，落地后继续眩晕1秒。\n（施法范围：180）",
	"化身为剑影，对目标地点150范围内地面上的敌人连续发动7段攻击，每段造成攻击力70％+60～120点的物理伤害。最后1段额外造成穿刺，并将敌人抛向空中，落地后继续眩晕1秒。\n（施法范围：180）",
	"化身为剑影，对目标地点150范围内地面上的敌人连续发动7段攻击，每段造成攻击力75％+70～140点的物理伤害。最后1段额外造成穿刺，并将敌人抛向空中，落地后继续眩晕1秒。\n（施法范围：180）",
	"化身为剑影，对目标地点150范围内地面上的敌人连续发动7段攻击，每段造成攻击力80％+80～160点的物理伤害。最后1段额外造成穿刺，并将敌人抛向空中，落地后继续眩晕1秒。\n（施法范围：180）",
	"化身为剑影，对目标地点150范围内地面上的敌人连续发动7段攻击，每段造成攻击力85％+90～180点的物理伤害。最后1段额外造成穿刺，并将敌人抛向空中，落地后继续眩晕1秒。\n（施法范围：180）",
	"化身为剑影，对目标地点150范围内地面上的敌人连续发动7段攻击，每段造成攻击力90％+100～200点的物理伤害。最后1段额外造成穿刺，并将敌人抛向空中，落地后继续眩晕1秒。\n（施法范围：180）",
	"化身为剑影，对目标地点150范围内地面上的敌人连续发动7段攻击，每段造成攻击力95％+110～220点的物理伤害。最后1段额外造成穿刺，并将敌人抛向空中，落地后继续眩晕1秒。\n（施法范围：180）",
	"化身为剑影，对目标地点150范围内地面上的敌人连续发动7段攻击，每段造成攻击力100％+120～240点的物理伤害。最后1段额外造成穿刺，并将敌人抛向空中，落地后继续眩晕1秒。\n（施法范围：180）",
	"化身为剑影，对目标地点150范围内地面上的敌人连续发动7段攻击，每段造成攻击力105％+130～260点的物理伤害。最后1段额外造成穿刺，并将敌人抛向空中，落地后继续眩晕1秒。\n（施法范围：180）",
	"化身为剑影，对目标地点150范围内地面上的敌人连续发动7段攻击，每段造成攻击力110％+140～280点的物理伤害。最后1段额外造成穿刺，并将敌人抛向空中，落地后继续眩晕1秒。\n（施法范围：180）",
	"化身为剑影，对目标地点150范围内地面上的敌人连续发动7段攻击，每段造成攻击力115％+150～300点的物理伤害。最后1段额外造成穿刺，并将敌人抛向空中，落地后继续眩晕1秒。\n（施法范围：180）",
	"化身为剑影，对目标地点150范围内地面上的敌人连续发动7段攻击，每段造成攻击力120％+160～320点的物理伤害。最后1段额外造成穿刺，并将敌人抛向空中，落地后继续眩晕1秒。\n（施法范围：180）",
}

_tab_stringS[11363] = {"御魂甘露",
	"凝水为盾，为自己和所有友方英雄施加甘露，提升16点法术防御、每秒20点回血，持续7秒。",
	"凝水为盾，为自己和所有友方英雄施加甘露，提升20点法术防御、每秒35点回血，持续7秒。",
	"凝水为盾，为自己和所有友方英雄施加甘露，提升24点法术防御、每秒50点回血，持续7秒。",
	"凝水为盾，为自己和所有友方英雄施加甘露，提升28点法术防御、每秒65点回血，持续7秒。",
	"凝水为盾，为自己和所有友方英雄施加甘露，提升32点法术防御、每秒80点回血，持续7秒。",
	"凝水为盾，为自己和所有友方英雄施加甘露，提升36点法术防御、每秒95点回血，持续7秒。",
	"凝水为盾，为自己和所有友方英雄施加甘露，提升40点法术防御、每秒110点回血，持续7秒。",
	"凝水为盾，为自己和所有友方英雄施加甘露，提升44点法术防御、每秒125点回血，持续7秒。",
	"凝水为盾，为自己和所有友方英雄施加甘露，提升48点法术防御、每秒140点回血，持续7秒。",
	"凝水为盾，为自己和所有友方英雄施加甘露，提升52点法术防御、每秒155点回血，持续7秒。",
	"凝水为盾，为自己和所有友方英雄施加甘露，提升56点法术防御、每秒170点回血，持续7秒。",
	"凝水为盾，为自己和所有友方英雄施加甘露，提升60点法术防御、每秒185点回血，持续7秒。",
	"凝水为盾，为自己和所有友方英雄施加甘露，提升64点法术防御、每秒200点回血，持续7秒。",
	"凝水为盾，为自己和所有友方英雄施加甘露，提升68点法术防御、每秒215点回血，持续7秒。",
	"凝水为盾，为自己和所有友方英雄施加甘露，提升72点法术防御、每秒230点回血，持续7秒。",
}

_tab_stringS[11360] = {"漫天花雨",
	"凝聚花瓣之力，每次攻击将发出的花瓣分裂成3道更小的花瓣命中同一个目标，每道小花瓣造成攻击力30％+20点的法术伤害。",
	"凝聚花瓣之力，每次攻击将发出的花瓣分裂成3道更小的花瓣命中同一个目标，每道小花瓣造成攻击力35％+25点的法术伤害。",
	"凝聚花瓣之力，每次攻击将发出的花瓣分裂成3道更小的花瓣命中同一个目标，每道小花瓣造成攻击力40％+30点的法术伤害。",
	"凝聚花瓣之力，每次攻击将发出的花瓣分裂成3道更小的花瓣命中同一个目标，每道小花瓣造成攻击力45％+35点的法术伤害。",
	"凝聚花瓣之力，每次攻击将发出的花瓣分裂成3道更小的花瓣命中同一个目标，每道小花瓣造成攻击力50％+40点的法术伤害。",
	"凝聚花瓣之力，每次攻击将发出的花瓣分裂成3道更小的花瓣命中同一个目标，每道小花瓣造成攻击力55％+45点的法术伤害。",
	"凝聚花瓣之力，每次攻击将发出的花瓣分裂成3道更小的花瓣命中同一个目标，每道小花瓣造成攻击力60％+50点的法术伤害。",
	"凝聚花瓣之力，每次攻击将发出的花瓣分裂成3道更小的花瓣命中同一个目标，每道小花瓣造成攻击力65％+55点的法术伤害。",
	"凝聚花瓣之力，每次攻击将发出的花瓣分裂成3道更小的花瓣命中同一个目标，每道小花瓣造成攻击力70％+60点的法术伤害。",
	"凝聚花瓣之力，每次攻击将发出的花瓣分裂成3道更小的花瓣命中同一个目标，每道小花瓣造成攻击力75％+65点的法术伤害。",
	"凝聚花瓣之力，每次攻击将发出的花瓣分裂成3道更小的花瓣命中同一个目标，每道小花瓣造成攻击力80％+70点的法术伤害。",
	"凝聚花瓣之力，每次攻击将发出的花瓣分裂成3道更小的花瓣命中同一个目标，每道小花瓣造成攻击力85％+75点的法术伤害。",
	"凝聚花瓣之力，每次攻击将发出的花瓣分裂成3道更小的花瓣命中同一个目标，每道小花瓣造成攻击力90％+80点的法术伤害。",
	"凝聚花瓣之力，每次攻击将发出的花瓣分裂成3道更小的花瓣命中同一个目标，每道小花瓣造成攻击力95％+85点的法术伤害。",
	"凝聚花瓣之力，每次攻击将发出的花瓣分裂成3道更小的花瓣命中同一个目标，每道小花瓣造成攻击力100％+90点的法术伤害。",
}

_tab_stringS[11374] = {"春花秋月",
	"将花瓣注入敌人体内伺机爆发，每次攻击有15％的几率对目标和目标周围135范围内的敌人造成攻击力80％+45点的法术伤害。如果目标当前生命值低于25％，造成的范围伤害额外增加31％。",
	"将花瓣注入敌人体内伺机爆发，每次攻击有16％的几率对目标和目标周围135范围内的敌人造成攻击力90％+55点的法术伤害。如果目标当前生命值低于26％，造成的范围伤害额外增加32％。",
	"将花瓣注入敌人体内伺机爆发，每次攻击有17％的几率对目标和目标周围135范围内的敌人造成攻击力100％+65点的法术伤害。如果目标当前生命值低于27％，造成的范围伤害额外增加33％。",
	"将花瓣注入敌人体内伺机爆发，每次攻击有18％的几率对目标和目标周围135范围内的敌人造成攻击力110％+75点的法术伤害。如果目标当前生命值低于28％，造成的范围伤害额外增加34％。",
	"将花瓣注入敌人体内伺机爆发，每次攻击有19％的几率对目标和目标周围135范围内的敌人造成攻击力120％+85点的法术伤害。如果目标当前生命值低于29％，造成的范围伤害额外增加35％。",
	"将花瓣注入敌人体内伺机爆发，每次攻击有20％的几率对目标和目标周围135范围内的敌人造成攻击力130％+95点的法术伤害。如果目标当前生命值低于30％，造成的范围伤害额外增加36％。",
	"将花瓣注入敌人体内伺机爆发，每次攻击有21％的几率对目标和目标周围135范围内的敌人造成攻击力140％+105点的法术伤害。如果目标当前生命值低于31％，造成的范围伤害额外增加37％。",
	"将花瓣注入敌人体内伺机爆发，每次攻击有22％的几率对目标和目标周围135范围内的敌人造成攻击力150％+115点的法术伤害。如果目标当前生命值低于32％，造成的范围伤害额外增加38％。",
	"将花瓣注入敌人体内伺机爆发，每次攻击有23％的几率对目标和目标周围135范围内的敌人造成攻击力160％+125点的法术伤害。如果目标当前生命值低于33％，造成的范围伤害额外增加39％。",
	"将花瓣注入敌人体内伺机爆发，每次攻击有24％的几率对目标和目标周围135范围内的敌人造成攻击力170％+135点的法术伤害。如果目标当前生命值低于34％，造成的范围伤害额外增加40％。",
	"将花瓣注入敌人体内伺机爆发，每次攻击有25％的几率对目标和目标周围135范围内的敌人造成攻击力180％+145点的法术伤害。如果目标当前生命值低于35％，造成的范围伤害额外增加41％。",
	"将花瓣注入敌人体内伺机爆发，每次攻击有26％的几率对目标和目标周围135范围内的敌人造成攻击力190％+155点的法术伤害。如果目标当前生命值低于36％，造成的范围伤害额外增加42％。",
	"将花瓣注入敌人体内伺机爆发，每次攻击有27％的几率对目标和目标周围135范围内的敌人造成攻击力200％+165点的法术伤害。如果目标当前生命值低于37％，造成的范围伤害额外增加43％。",
	"将花瓣注入敌人体内伺机爆发，每次攻击有28％的几率对目标和目标周围135范围内的敌人造成攻击力210％+175点的法术伤害。如果目标当前生命值低于38％，造成的范围伤害额外增加44％。",
	"将花瓣注入敌人体内伺机爆发，每次攻击有29％的几率对目标和目标周围135范围内的敌人造成攻击力220％+185点的法术伤害。如果目标当前生命值低于39％，造成的范围伤害额外增加45％。",
}

_tab_stringS[11375] = {"东皇之力",
	"借助东皇之力，使所有友军英雄的战术技能冷却缩短26秒，并使自己和所有友方英雄获得1秒无敌状态。",
	"借助东皇之力，使所有友军英雄的战术技能冷却缩短28秒，并使自己和所有友方英雄获得1.2秒无敌状态。",
	"借助东皇之力，使所有友军英雄的战术技能冷却缩短30秒，并使自己和所有友方英雄获得1.4秒无敌状态。",
	"借助东皇之力，使所有友军英雄的战术技能冷却缩短32秒，并使自己和所有友方英雄获得1.6秒无敌状态。",
	"借助东皇之力，使所有友军英雄的战术技能冷却缩短34秒，并使自己和所有友方英雄获得1.8秒无敌状态。",
	"借助东皇之力，使所有友军英雄的战术技能冷却缩短36秒，并使自己和所有友方英雄获得2秒无敌状态。",
	"借助东皇之力，使所有友军英雄的战术技能冷却缩短38秒，并使自己和所有友方英雄获得2.2秒无敌状态。",
	"借助东皇之力，使所有友军英雄的战术技能冷却缩短40秒，并使自己和所有友方英雄获得2.4秒无敌状态。",
	"借助东皇之力，使所有友军英雄的战术技能冷却缩短42秒，并使自己和所有友方英雄获得2.6秒无敌状态。",
	"借助东皇之力，使所有友军英雄的战术技能冷却缩短44秒，并使自己和所有友方英雄获得2.8秒无敌状态。",
	"借助东皇之力，使所有友军英雄的战术技能冷却缩短46秒，并使自己和所有友方英雄获得3秒无敌状态。",
	"借助东皇之力，使所有友军英雄的战术技能冷却缩短48秒，并使自己和所有友方英雄获得3.2秒无敌状态。",
	"借助东皇之力，使所有友军英雄的战术技能冷却缩短50秒，并使自己和所有友方英雄获得3.4秒无敌状态。",
	"借助东皇之力，使所有友军英雄的战术技能冷却缩短52秒，并使自己和所有友方英雄获得3.6秒无敌状态。",
	"借助东皇之力，使所有友军英雄的战术技能冷却缩短54秒，并使自己和所有友方英雄获得3.8秒无敌状态。",
}

_tab_stringS[11377] = {"九歌",
	"获得东皇的祝福，提升自己或一名友军6％的闪避、每秒8点回血，持续18秒。",
	"获得东皇的祝福，提升自己或一名友军7％的闪避、每秒10点回血，持续18秒。",
	"获得东皇的祝福，提升自己或一名友军8％的闪避、每秒12点回血，持续18秒。",
	"获得东皇的祝福，提升自己或一名友军9％的闪避、每秒14点回血，持续18秒。",
	"获得东皇的祝福，提升自己或一名友军10％的闪避、每秒16点回血，持续18秒。",
	"获得东皇的祝福，提升自己或一名友军11％的闪避、每秒18点回血，持续18秒。",
	"获得东皇的祝福，提升自己或一名友军12％的闪避、每秒20点回血，持续18秒。",
	"获得东皇的祝福，提升自己或一名友军13％的闪避、每秒22点回血，持续18秒。",
	"获得东皇的祝福，提升自己或一名友军14％的闪避、每秒24点回血，持续18秒。",
	"获得东皇的祝福，提升自己或一名友军15％的闪避、每秒26点回血，持续18秒。",
	"获得东皇的祝福，提升自己或一名友军16％的闪避、每秒28点回血，持续18秒。",
	"获得东皇的祝福，提升自己或一名友军17％的闪避、每秒30点回血，持续18秒。",
	"获得东皇的祝福，提升自己或一名友军18％的闪避、每秒32点回血，持续18秒。",
	"获得东皇的祝福，提升自己或一名友军19％的闪避、每秒34点回血，持续18秒。",
	"获得东皇的祝福，提升自己或一名友军20％的闪避、每秒36点回血，持续18秒。",
}

_tab_stringS[11379] = {"太一之剑",
	"向正前方召唤6把落剑，每把落剑都对小范围敌人造成攻击力25％+60点的真实伤害，并降低20点物理防御和法术防御，持续5秒。",
	"向正前方召唤6把落剑，每把落剑都对小范围敌人造成攻击力25％+90点的真实伤害，并降低22点物理防御和法术防御，持续5秒。",
	"向正前方召唤6把落剑，每把落剑都对小范围敌人造成攻击力25％+120点的真实伤害，并降低24点物理防御和法术防御，持续5秒。",
	"向正前方召唤6把落剑，每把落剑都对小范围敌人造成攻击力25％+150点的真实伤害，并降低26点物理防御和法术防御，持续5秒。",
	"向正前方召唤6把落剑，每把落剑都对小范围敌人造成攻击力25％+180点的真实伤害，并降低28点物理防御和法术防御，持续5秒。",
	"向正前方召唤6把落剑，每把落剑都对小范围敌人造成攻击力25％+210点的真实伤害，并降低30点物理防御和法术防御，持续5秒。",
	"向正前方召唤6把落剑，每把落剑都对小范围敌人造成攻击力25％+240点的真实伤害，并降低32点物理防御和法术防御，持续5秒。",
	"向正前方召唤6把落剑，每把落剑都对小范围敌人造成攻击力25％+270点的真实伤害，并降低34点物理防御和法术防御，持续5秒。",
	"向正前方召唤6把落剑，每把落剑都对小范围敌人造成攻击力25％+300点的真实伤害，并降低36点物理防御和法术防御，持续5秒。",
	"向正前方召唤6把落剑，每把落剑都对小范围敌人造成攻击力25％+330点的真实伤害，并降低38点物理防御和法术防御，持续5秒。",
	"向正前方召唤6把落剑，每把落剑都对小范围敌人造成攻击力25％+360点的真实伤害，并降低40点物理防御和法术防御，持续5秒。",
	"向正前方召唤6把落剑，每把落剑都对小范围敌人造成攻击力25％+390点的真实伤害，并降低42点物理防御和法术防御，持续5秒。",
	"向正前方召唤6把落剑，每把落剑都对小范围敌人造成攻击力25％+420点的真实伤害，并降低44点物理防御和法术防御，持续5秒。",
	"向正前方召唤6把落剑，每把落剑都对小范围敌人造成攻击力25％+450点的真实伤害，并降低46点物理防御和法术防御，持续5秒。",
	"向正前方召唤6把落剑，每把落剑都对小范围敌人造成攻击力25％+480点的真实伤害，并降低48点物理防御和法术防御，持续5秒。",
}

_tab_stringS[11386] = {"连弩",
	"每次攻击有20％的几率发射连弩，连射出3支箭，每支箭命中射程内的随机敌人，每次造成攻击力50％的物理伤害。",
	"每次攻击有20％的几率发射连弩，连射出3支箭，每支箭命中射程内的随机敌人，每次造成攻击力55％的物理伤害。",
	"每次攻击有20％的几率发射连弩，连射出3支箭，每支箭命中射程内的随机敌人，每次造成攻击力60％的物理伤害。",
	"每次攻击有20％的几率发射连弩，连射出3支箭，每支箭命中射程内的随机敌人，每次造成攻击力65％的物理伤害。",
	"每次攻击有20％的几率发射连弩，连射出3支箭，每支箭命中射程内的随机敌人，每次造成攻击力70％的物理伤害。",
	"每次攻击有20％的几率发射连弩，连射出3支箭，每支箭命中射程内的随机敌人，每次造成攻击力75％的物理伤害。",
	"每次攻击有20％的几率发射连弩，连射出3支箭，每支箭命中射程内的随机敌人，每次造成攻击力80％的物理伤害。",
	"每次攻击有20％的几率发射连弩，连射出3支箭，每支箭命中射程内的随机敌人，每次造成攻击力85％的物理伤害。",
	"每次攻击有20％的几率发射连弩，连射出3支箭，每支箭命中射程内的随机敌人，每次造成攻击力90％的物理伤害。",
	"每次攻击有20％的几率发射连弩，连射出3支箭，每支箭命中射程内的随机敌人，每次造成攻击力95％的物理伤害。",
	"每次攻击有20％的几率发射连弩，连射出3支箭，每支箭命中射程内的随机敌人，每次造成攻击力100％的物理伤害。",
	"每次攻击有20％的几率发射连弩，连射出3支箭，每支箭命中射程内的随机敌人，每次造成攻击力105％的物理伤害。",
	"每次攻击有20％的几率发射连弩，连射出3支箭，每支箭命中射程内的随机敌人，每次造成攻击力110％的物理伤害。",
	"每次攻击有20％的几率发射连弩，连射出3支箭，每支箭命中射程内的随机敌人，每次造成攻击力115％的物理伤害。",
	"每次攻击有20％的几率发射连弩，连射出3支箭，每支箭命中射程内的随机敌人，每次造成攻击力120％的物理伤害。",
}

_tab_stringS[11388] = {"机关术",
	"增强【机关弩炮】：机关弩炮的持续时间+1秒，额外附加黄月英30％的攻击力。\n增强【连弩】：连弩触发的几率+1％，触发后多射出1支箭。",
	"增强【机关弩炮】：机关弩炮的持续时间+2秒，额外附加黄月英30％的攻击力。\n增强【连弩】：连弩触发的几率+2％，触发后多射出1支箭。",
	"增强【机关弩炮】：机关弩炮的持续时间+3秒，额外附加黄月英30％的攻击力。\n增强【连弩】：连弩触发的几率+3％，触发后多射出1支箭。",
	"增强【机关弩炮】：机关弩炮的持续时间+4秒，额外附加黄月英30％的攻击力。\n增强【连弩】：连弩触发的几率+4％，触发后多射出1支箭。",
	"增强【机关弩炮】：机关弩炮的持续时间+5秒，额外附加黄月英30％的攻击力。\n增强【连弩】：连弩触发的几率+5％，触发后多射出1支箭。",
	"增强【机关弩炮】：机关弩炮的持续时间+6秒，额外附加黄月英30％的攻击力。\n增强【连弩】：连弩触发的几率+6％，触发后多射出1支箭。",
	"增强【机关弩炮】：机关弩炮的持续时间+7秒，额外附加黄月英30％的攻击力。\n增强【连弩】：连弩触发的几率+7％，触发后多射出1支箭。",
	"增强【机关弩炮】：机关弩炮的持续时间+8秒，额外附加黄月英30％的攻击力。\n增强【连弩】：连弩触发的几率+8％，触发后多射出1支箭。",
	"增强【机关弩炮】：机关弩炮的持续时间+9秒，额外附加黄月英30％的攻击力。\n增强【连弩】：连弩触发的几率+9％，触发后多射出1支箭。",
	"增强【机关弩炮】：机关弩炮的持续时间+10秒，额外附加黄月英30％的攻击力。\n增强【连弩】：连弩触发的几率+10％，触发后多射出1支箭。",
	"增强【机关弩炮】：机关弩炮的持续时间+11秒，额外附加黄月英30％的攻击力。\n增强【连弩】：连弩触发的几率+11％，触发后多射出1支箭。",
	"增强【机关弩炮】：机关弩炮的持续时间+12秒，额外附加黄月英30％的攻击力。\n增强【连弩】：连弩触发的几率+12％，触发后多射出1支箭。",
	"增强【机关弩炮】：机关弩炮的持续时间+13秒，额外附加黄月英30％的攻击力。\n增强【连弩】：连弩触发的几率+13％，触发后多射出1支箭。",
	"增强【机关弩炮】：机关弩炮的持续时间+14秒，额外附加黄月英30％的攻击力。\n增强【连弩】：连弩触发的几率+14％，触发后多射出1支箭。",
	"增强【机关弩炮】：机关弩炮的持续时间+15秒，额外附加黄月英30％的攻击力。\n增强【连弩】：连弩触发的几率+15％，触发后多射出1支箭。",
}


_tab_stringS[11393] = {"杀威棒",
	"发动重击，对自身180范围内的敌人造成攻击力60％+48点的物理伤害，并震晕1秒。同时降低敌人15％的攻击力，持续6秒。",
	"发动重击，对自身180范围内的敌人造成攻击力60％+54点的物理伤害，并震晕1秒。同时降低敌人18％的攻击力，持续6秒。",
	"发动重击，对自身180范围内的敌人造成攻击力60％+60点的物理伤害，并震晕1秒。同时降低敌人21％的攻击力，持续6秒。",
	"发动重击，对自身180范围内的敌人造成攻击力60％+66点的物理伤害，并震晕1秒。同时降低敌人24％的攻击力，持续6秒。",
	"发动重击，对自身180范围内的敌人造成攻击力60％+72点的物理伤害，并震晕1秒。同时降低敌人27％的攻击力，持续6秒。",
	"发动重击，对自身180范围内的敌人造成攻击力60％+78点的物理伤害，并震晕1秒。同时降低敌人30％的攻击力，持续6秒。",
	"发动重击，对自身180范围内的敌人造成攻击力60％+84点的物理伤害，并震晕1秒。同时降低敌人33％的攻击力，持续6秒。",
	"发动重击，对自身180范围内的敌人造成攻击力60％+90点的物理伤害，并震晕1秒。同时降低敌人36％的攻击力，持续6秒。",
	"发动重击，对自身180范围内的敌人造成攻击力60％+96点的物理伤害，并震晕1秒。同时降低敌人39％的攻击力，持续6秒。",
	"发动重击，对自身180范围内的敌人造成攻击力60％+102点的物理伤害，并震晕1秒。同时降低敌人42％的攻击力，持续6秒。",
	"发动重击，对自身180范围内的敌人造成攻击力60％+108点的物理伤害，并震晕1秒。同时降低敌人45％的攻击力，持续6秒。",
	"发动重击，对自身180范围内的敌人造成攻击力60％+114点的物理伤害，并震晕1秒。同时降低敌人48％的攻击力，持续6秒。",
	"发动重击，对自身180范围内的敌人造成攻击力60％+120点的物理伤害，并震晕1秒。同时降低敌人51％的攻击力，持续6秒。",
	"发动重击，对自身180范围内的敌人造成攻击力60％+126点的物理伤害，并震晕1秒。同时降低敌人54％的攻击力，持续6秒。",
	"发动重击，对自身180范围内的敌人造成攻击力60％+132点的物理伤害，并震晕1秒。同时降低敌人57％的攻击力，持续6秒。",
}

_tab_stringS[11394] = {"肥硕之躯",
	"永久增加自身240点生命值。血池的持续时间+5秒。",
	"永久增加自身360点生命值。血池的持续时间+5秒。",
	"永久增加自身480点生命值。血池的持续时间+5秒。",
	"永久增加自身700点生命值。血池的持续时间+5秒。",
	"永久增加自身720点生命值。血池的持续时间+5秒。",
	"永久增加自身840点生命值。血池的持续时间+5秒。",
	"永久增加自身960点生命值。血池的持续时间+5秒。",
	"永久增加自身1080点生命值。血池的持续时间+5秒。",
	"永久增加自身1200点生命值。血池的持续时间+5秒。",
	"永久增加自身1320点生命值。血池的持续时间+5秒。",
	"永久增加自身1440点生命值。血池的持续时间+5秒。",
	"永久增加自身1560点生命值。血池的持续时间+5秒。",
	"永久增加自身1680点生命值。血池的持续时间+5秒。",
	"永久增加自身1800点生命值。血池的持续时间+5秒。",
	"永久增加自身1920点生命值。血池的持续时间+5秒。",
}

_tab_stringS[11407] = {"判阴阳",
	"对自己或友军进行治疗，恢复攻击力200％+50点生命值，并对治疗者周围90范围内的敌人造成荀彧攻击力120％的法术伤害。",
	"对自己或友军进行治疗，恢复攻击力200％+100点生命值，并对治疗者周围90范围内的敌人造成荀彧攻击力135％的法术伤害。",
	"对自己或友军进行治疗，恢复攻击力200％+150点生命值，并对治疗者周围90范围内的敌人造成荀彧攻击力150％的法术伤害。",
	"对自己或友军进行治疗，恢复攻击力200％+200点生命值，并对治疗者周围90范围内的敌人造成荀彧攻击力165％的法术伤害。",
	"对自己或友军进行治疗，恢复攻击力200％+250点生命值，并对治疗者周围90范围内的敌人造成荀彧攻击力180％的法术伤害。",
	"对自己或友军进行治疗，恢复攻击力200％+300点生命值，并对治疗者周围90范围内的敌人造成荀彧攻击力195％的法术伤害。",
	"对自己或友军进行治疗，恢复攻击力200％+350点生命值，并对治疗者周围90范围内的敌人造成荀彧攻击力210％的法术伤害。",
	"对自己或友军进行治疗，恢复攻击力200％+400点生命值，并对治疗者周围90范围内的敌人造成荀彧攻击力225％的法术伤害。",
	"对自己或友军进行治疗，恢复攻击力200％+450点生命值，并对治疗者周围90范围内的敌人造成荀彧攻击力240％的法术伤害。",
	"对自己或友军进行治疗，恢复攻击力200％+500点生命值，并对治疗者周围90范围内的敌人造成荀彧攻击力255％的法术伤害。",
	"对自己或友军进行治疗，恢复攻击力200％+550点生命值，并对治疗者周围90范围内的敌人造成荀彧攻击力270％的法术伤害。",
	"对自己或友军进行治疗，恢复攻击力200％+600点生命值，并对治疗者周围90范围内的敌人造成荀彧攻击力285％的法术伤害。",
	"对自己或友军进行治疗，恢复攻击力200％+650点生命值，并对治疗者周围90范围内的敌人造成荀彧攻击力300％的法术伤害。",
	"对自己或友军进行治疗，恢复攻击力200％+700点生命值，并对治疗者周围90范围内的敌人造成荀彧攻击力315％的法术伤害。",
	"对自己或友军进行治疗，恢复攻击力200％+750点生命值，并对治疗者周围90范围内的敌人造成荀彧攻击力330％的法术伤害。",
}

_tab_stringS[11408] = {"厚德载物",
	"提升自己或一名友军16点物理防御、法术防御和攻击力，持续24秒。",
	"提升自己或一名友军17点物理防御、法术防御和攻击力，持续24秒。",
	"提升自己或一名友军18点物理防御、法术防御和攻击力，持续24秒。",
	"提升自己或一名友军19点物理防御、法术防御和攻击力，持续24秒。",
	"提升自己或一名友军20点物理防御、法术防御和攻击力，持续24秒。",
	"提升自己或一名友军21点物理防御、法术防御和攻击力，持续24秒。",
	"提升自己或一名友军22点物理防御、法术防御和攻击力，持续24秒。",
	"提升自己或一名友军23点物理防御、法术防御和攻击力，持续24秒。",
	"提升自己或一名友军24点物理防御、法术防御和攻击力，持续24秒。",
	"提升自己或一名友军25点物理防御、法术防御和攻击力，持续24秒。",
	"提升自己或一名友军26点物理防御、法术防御和攻击力，持续24秒。",
	"提升自己或一名友军27点物理防御、法术防御和攻击力，持续24秒。",
	"提升自己或一名友军28点物理防御、法术防御和攻击力，持续24秒。",
	"提升自己或一名友军29点物理防御、法术防御和攻击力，持续24秒。",
	"提升自己或一名友军30点物理防御、法术防御和攻击力，持续24秒。",
}

_tab_stringS[11411] = {"连珠火球",
	"向前方扇形位置随机发射3~7枚火球，每一枚火球造成30％法术伤害。",
	"向前方扇形位置随机发射3~7枚火球，每一枚火球造成35％法术伤害。",
	"向前方扇形位置随机发射3~7枚火球，每一枚火球造成40％法术伤害。",
	"向前方扇形位置随机发射3~7枚火球，每一枚火球造成45％法术伤害。",
	"向前方扇形位置随机发射3~7枚火球，每一枚火球造成50％法术伤害。",
	"向前方扇形位置随机发射3~7枚火球，每一枚火球造成55％法术伤害。",
	"向前方扇形位置随机发射3~7枚火球，每一枚火球造成60％法术伤害。",
	"向前方扇形位置随机发射3~7枚火球，每一枚火球造成65％法术伤害。",
	"向前方扇形位置随机发射3~7枚火球，每一枚火球造成70％法术伤害。",
	"向前方扇形位置随机发射3~7枚火球，每一枚火球造成75％法术伤害。",
	"向前方扇形位置随机发射3~7枚火球，每一枚火球造成80％法术伤害。",
	"向前方扇形位置随机发射3~7枚火球，每一枚火球造成85％法术伤害。",
	"向前方扇形位置随机发射3~7枚火球，每一枚火球造成90％法术伤害。",
	"向前方扇形位置随机发射3~7枚火球，每一枚火球造成95％法术伤害。",
	"向前方扇形位置随机发射3~7枚火球，每一枚火球造成100％法术伤害。",
}

_tab_stringS[11412] = {"点燃",
	"对目标造成每秒50％的法术伤害，并降低目标20点法术防御，持续20秒。",
	"对目标造成每秒50％的法术伤害，并降低目标24点法术防御，持续20秒。",
	"对目标造成每秒50％的法术伤害，并降低目标28点法术防御，持续20秒。",
	"对目标造成每秒50％的法术伤害，并降低目标32点法术防御，持续20秒。",
	"对目标造成每秒50％的法术伤害，并降低目标36点法术防御，持续20秒。",
	"对目标造成每秒50％的法术伤害，并降低目标40点法术防御，持续20秒。",
	"对目标造成每秒50％的法术伤害，并降低目标44点法术防御，持续20秒。",
	"对目标造成每秒50％的法术伤害，并降低目标48点法术防御，持续20秒。",
	"对目标造成每秒50％的法术伤害，并降低目标52点法术防御，持续20秒。",
	"对目标造成每秒50％的法术伤害，并降低目标56点法术防御，持续20秒。",
	"对目标造成每秒50％的法术伤害，并降低目标60点法术防御，持续20秒。",
	"对目标造成每秒50％的法术伤害，并降低目标64点法术防御，持续20秒。",
	"对目标造成每秒50％的法术伤害，并降低目标68点法术防御，持续20秒。",
	"对目标造成每秒50％的法术伤害，并降低目标72点法术防御，持续20秒。",
	"对目标造成每秒50％的法术伤害，并降低目标76点法术防御，持续20秒。",
}

_tab_stringS[11415] = {"闪击",
	"每次攻击有30％的几率闪现至目标身边，并对目标造成攻击力130％的物理伤害。",
	"每次攻击有30％的几率闪现至目标身边，并对目标造成攻击力135％的物理伤害。",
	"每次攻击有30％的几率闪现至目标身边，并对目标造成攻击力140％的物理伤害。",
	"每次攻击有30％的几率闪现至目标身边，并对目标造成攻击力145％的物理伤害。",
	"每次攻击有30％的几率闪现至目标身边，并对目标造成攻击力150％的物理伤害。",
	"每次攻击有30％的几率闪现至目标身边，并对目标造成攻击力155％的物理伤害。",
	"每次攻击有30％的几率闪现至目标身边，并对目标造成攻击力160％的物理伤害。",
	"每次攻击有30％的几率闪现至目标身边，并对目标造成攻击力165％的物理伤害。",
	"每次攻击有30％的几率闪现至目标身边，并对目标造成攻击力170％的物理伤害。",
	"每次攻击有30％的几率闪现至目标身边，并对目标造成攻击力175％的物理伤害。",
	"每次攻击有30％的几率闪现至目标身边，并对目标造成攻击力180％的物理伤害。",
	"每次攻击有30％的几率闪现至目标身边，并对目标造成攻击力185％的物理伤害。",
	"每次攻击有30％的几率闪现至目标身边，并对目标造成攻击力190％的物理伤害。",
	"每次攻击有30％的几率闪现至目标身边，并对目标造成攻击力195％的物理伤害。",
	"每次攻击有30％的几率闪现至目标身边，并对目标造成攻击力200％的物理伤害。",
}

_tab_stringS[11416] = {"双刀流",
	"永久增加自身6％的暴击几率，同时孙尚香每次施放闪击时，随机对60范围内的另一个敌人造成攻击力130％的物理伤害。",
	"永久增加自身7％的暴击几率，同时孙尚香每次施放闪击时，随机对60范围内的另一个敌人造成攻击力135％的物理伤害。",
	"永久增加自身8％的暴击几率，同时孙尚香每次施放闪击时，随机对60范围内的另一个敌人造成攻击力140％的物理伤害。",
	"永久增加自身9％的暴击几率，同时孙尚香每次施放闪击时，随机对60范围内的另一个敌人造成攻击力145％的物理伤害。",
	"永久增加自身10％的暴击几率，同时孙尚香每次施放闪击时，随机对60范围内的另一个敌人造成攻击力150％的物理伤害。",
	"永久增加自身11％的暴击几率，同时孙尚香每次施放闪击时，随机对60范围内的另一个敌人造成攻击力155％的物理伤害。",
	"永久增加自身12％的暴击几率，同时孙尚香每次施放闪击时，随机对60范围内的另一个敌人造成攻击力160％的物理伤害。",
	"永久增加自身13％的暴击几率，同时孙尚香每次施放闪击时，随机对60范围内的另一个敌人造成攻击力165％的物理伤害。",
	"永久增加自身14％的暴击几率，同时孙尚香每次施放闪击时，随机对60范围内的另一个敌人造成攻击力170％的物理伤害。",
	"永久增加自身15％的暴击几率，同时孙尚香每次施放闪击时，随机对60范围内的另一个敌人造成攻击力175％的物理伤害。",
	"永久增加自身16％的暴击几率，同时孙尚香每次施放闪击时，随机对60范围内的另一个敌人造成攻击力180％的物理伤害。",
	"永久增加自身17％的暴击几率，同时孙尚香每次施放闪击时，随机对60范围内的另一个敌人造成攻击力185％的物理伤害。",
	"永久增加自身18％的暴击几率，同时孙尚香每次施放闪击时，随机对60范围内的另一个敌人造成攻击力190％的物理伤害。",
	"永久增加自身19％的暴击几率，同时孙尚香每次施放闪击时，随机对60范围内的另一个敌人造成攻击力195％的物理伤害。",
	"永久增加自身20％的暴击几率，同时孙尚香每次施放闪击时，随机对60范围内的另一个敌人造成攻击力200％的物理伤害。",
}










--诸葛亮技能
_tab_stringS[31101] =
{
	"卧龙光线",
	"同时发射5道光线，每道都对一条直线上碰到的敌人造成攻击力80％+40点的法术伤害。\n（施法范围：300）",
	"同时发射5道光线，每道都对一条直线上碰到的敌人造成攻击力92％+60点的法术伤害。\n（施法范围：300）",
	"同时发射5道光线，每道都对一条直线上碰到的敌人造成攻击力104％+80点的法术伤害。\n（施法范围：300）",
	"同时发射5道光线，每道都对一条直线上碰到的敌人造成攻击力116％+100点的法术伤害。\n（施法范围：300）",
	"同时发射5道光线，每道都对一条直线上碰到的敌人造成攻击力128％+120点的法术伤害。\n（施法范围：300）",
	"同时发射5道光线，每道都对一条直线上碰到的敌人造成攻击力140％+140点的法术伤害。\n（施法范围：300）",
	"同时发射5道光线，每道都对一条直线上碰到的敌人造成攻击力152％+160点的法术伤害。\n（施法范围：300）",
	"同时发射5道光线，每道都对一条直线上碰到的敌人造成攻击力164％+180点的法术伤害。\n（施法范围：300）",
	"同时发射5道光线，每道都对一条直线上碰到的敌人造成攻击力176％+200点的法术伤害。\n（施法范围：300）",
	"同时发射5道光线，每道都对一条直线上碰到的敌人造成攻击力188％+220点的法术伤害。\n（施法范围：300）",
	"同时发射5道光线，每道都对一条直线上碰到的敌人造成攻击力200％+240点的法术伤害。\n（施法范围：300）",
	"同时发射5道光线，每道都对一条直线上碰到的敌人造成攻击力212％+260点的法术伤害。\n（施法范围：300）",
	"同时发射5道光线，每道都对一条直线上碰到的敌人造成攻击力224％+280点的法术伤害。\n（施法范围：300）",
	"同时发射5道光线，每道都对一条直线上碰到的敌人造成攻击力236％+300点的法术伤害。\n（施法范围：300）",
	"同时发射5道光线，每道都对一条直线上碰到的敌人造成攻击力248％+320点的法术伤害。\n（施法范围：300）",
}

_tab_stringS[31102] =
{
	"降雷术",
	"同时召唤多道雷电，每道雷电击中自身周围300范围内的随机敌人，造成40点法术伤害，并电晕0.1秒（主将除外）。周围的敌人越多，召唤的雷电数量就越多，最多同时召唤10道雷电。",
	"同时召唤多道雷电，每道雷电击中自身周围300范围内的随机敌人，造成55点法术伤害，并电晕0.2秒（主将除外）。周围的敌人越多，召唤的雷电数量就越多，最多同时召唤10道雷电。",
	"同时召唤多道雷电，每道雷电击中自身周围300范围内的随机敌人，造成70点法术伤害，并电晕0.3秒（主将除外）。周围的敌人越多，召唤的雷电数量就越多，最多同时召唤10道雷电。",
	"同时召唤多道雷电，每道雷电击中自身周围300范围内的随机敌人，造成85点法术伤害，并电晕0.4秒（主将除外）。周围的敌人越多，召唤的雷电数量就越多，最多同时召唤10道雷电。",
	"同时召唤多道雷电，每道雷电击中自身周围300范围内的随机敌人，造成100点法术伤害，并电晕0.5秒（主将除外）。周围的敌人越多，召唤的雷电数量就越多，最多同时召唤10道雷电。",
	"同时召唤多道雷电，每道雷电击中自身周围300范围内的随机敌人，造成115点法术伤害，并电晕0.6秒（主将除外）。周围的敌人越多，召唤的雷电数量就越多，最多同时召唤10道雷电。",
	"同时召唤多道雷电，每道雷电击中自身周围300范围内的随机敌人，造成130点法术伤害，并电晕0.7秒（主将除外）。周围的敌人越多，召唤的雷电数量就越多，最多同时召唤10道雷电。",
	"同时召唤多道雷电，每道雷电击中自身周围300范围内的随机敌人，造成145点法术伤害，并电晕0.8秒（主将除外）。周围的敌人越多，召唤的雷电数量就越多，最多同时召唤10道雷电。",
	"同时召唤多道雷电，每道雷电击中自身周围300范围内的随机敌人，造成160点法术伤害，并电晕0.9秒（主将除外）。周围的敌人越多，召唤的雷电数量就越多，最多同时召唤10道雷电。",
	"同时召唤多道雷电，每道雷电击中自身周围300范围内的随机敌人，造成175点法术伤害，并电晕1秒（主将除外）。周围的敌人越多，召唤的雷电数量就越多，最多同时召唤10道雷电。",
	"同时召唤多道雷电，每道雷电击中自身周围300范围内的随机敌人，造成190点法术伤害，并电晕1.1秒（主将除外）。周围的敌人越多，召唤的雷电数量就越多，最多同时召唤10道雷电。",
	"同时召唤多道雷电，每道雷电击中自身周围300范围内的随机敌人，造成205点法术伤害，并电晕1.2秒（主将除外）。周围的敌人越多，召唤的雷电数量就越多，最多同时召唤10道雷电。",
	"同时召唤多道雷电，每道雷电击中自身周围300范围内的随机敌人，造成220点法术伤害，并电晕1.3秒（主将除外）。周围的敌人越多，召唤的雷电数量就越多，最多同时召唤10道雷电。",
	"同时召唤多道雷电，每道雷电击中自身周围300范围内的随机敌人，造成235点法术伤害，并电晕1.4秒（主将除外）。周围的敌人越多，召唤的雷电数量就越多，最多同时召唤10道雷电。",
	"同时召唤多道雷电，每道雷电击中自身周围300范围内的随机敌人，造成250点法术伤害，并电晕1.5秒（主将除外）。周围的敌人越多，召唤的雷电数量就越多，最多同时召唤10道雷电。",
}

_tab_stringS[31104] =
{
	"石兵八阵",
	"在身边召唤3-5个300点生命、拥有嘲讽、诅咒技能的阵石协助战斗。阵石存在20秒。阵石会施放诅咒，降低周围250范围内的敌人8点法术防御和32％的移动速度。",
	"在身边召唤3-5个350点生命、拥有嘲讽、诅咒技能的阵石协助战斗。阵石存在20秒。阵石会施放诅咒，降低周围250范围内的敌人10点法术防御和34％的移动速度。",
	"在身边召唤3-5个400点生命、拥有嘲讽、诅咒技能的阵石协助战斗。阵石存在20秒。阵石会施放诅咒，降低周围250范围内的敌人12点法术防御和36％的移动速度。",
	"在身边召唤3-5个450点生命、拥有嘲讽、诅咒技能的阵石协助战斗。阵石存在20秒。阵石会施放诅咒，降低周围250范围内的敌人14点法术防御和38％的移动速度。",
	"在身边召唤3-5个500点生命、拥有嘲讽、诅咒技能的阵石协助战斗。阵石存在20秒。阵石会施放诅咒，降低周围250范围内的敌人16点法术防御和40％的移动速度。",
	"在身边召唤3-5个550点生命、拥有嘲讽、诅咒技能的阵石协助战斗。阵石存在20秒。阵石会施放诅咒，降低周围250范围内的敌人18点法术防御和42％的移动速度。",
	"在身边召唤3-5个600点生命、拥有嘲讽、诅咒技能的阵石协助战斗。阵石存在20秒。阵石会施放诅咒，降低周围250范围内的敌人20点法术防御和44％的移动速度。",
	"在身边召唤3-5个650点生命、拥有嘲讽、诅咒技能的阵石协助战斗。阵石存在20秒。阵石会施放诅咒，降低周围250范围内的敌人22点法术防御和46％的移动速度。",
	"在身边召唤3-5个700点生命、拥有嘲讽、诅咒技能的阵石协助战斗。阵石存在20秒。阵石会施放诅咒，降低周围250范围内的敌人24点法术防御和48％的移动速度。",
	"在身边召唤3-5个750点生命、拥有嘲讽、诅咒技能的阵石协助战斗。阵石存在20秒。阵石会施放诅咒，降低周围250范围内的敌人26点法术防御和50％的移动速度。",
	"在身边召唤3-5个800点生命、拥有嘲讽、诅咒技能的阵石协助战斗。阵石存在20秒。阵石会施放诅咒，降低周围250范围内的敌人28点法术防御和52％的移动速度。",
	"在身边召唤3-5个850点生命、拥有嘲讽、诅咒技能的阵石协助战斗。阵石存在20秒。阵石会施放诅咒，降低周围250范围内的敌人30点法术防御和54％的移动速度。",
	"在身边召唤3-5个900点生命、拥有嘲讽、诅咒技能的阵石协助战斗。阵石存在20秒。阵石会施放诅咒，降低周围250范围内的敌人32点法术防御和56％的移动速度。",
	"在身边召唤3-5个950点生命、拥有嘲讽、诅咒技能的阵石协助战斗。阵石存在20秒。阵石会施放诅咒，降低周围250范围内的敌人34点法术防御和58％的移动速度。",
	"在身边召唤3-5个1000点生命、拥有嘲讽、诅咒技能的阵石协助战斗。阵石存在20秒。阵石会施放诅咒，降低周围250范围内的敌人36点法术防御和60％的移动速度。",
}

--庞统技能
_tab_stringS[31113] = 
{
	"黑炎漩涡",
	"在目标地点创造一个漩涡，持续将150范围内的敌人吸入漩涡。在此期间目标不能攻击、移动、释放技能，并每秒受到庞统攻击力300％的法术伤害。漩涡持续3秒。\n（施法范围：600）",
	"在目标地点创造一个漩涡，持续将150范围内的敌人吸入漩涡。在此期间目标不能攻击、移动、释放技能，并每秒受到庞统攻击力300％的法术伤害。漩涡持续3.5秒。\n（施法范围：600）",
	"在目标地点创造一个漩涡，持续将150范围内的敌人吸入漩涡。在此期间目标不能攻击、移动、释放技能，并每秒受到庞统攻击力300％的法术伤害。漩涡持续4秒。\n（施法范围：600）",
	"在目标地点创造一个漩涡，持续将150范围内的敌人吸入漩涡。在此期间目标不能攻击、移动、释放技能，并每秒受到庞统攻击力300％的法术伤害。漩涡持续4.5秒。\n（施法范围：600）",
	"在目标地点创造一个漩涡，持续将150范围内的敌人吸入漩涡。在此期间目标不能攻击、移动、释放技能，并每秒受到庞统攻击力300％的法术伤害。漩涡持续5秒。\n（施法范围：600）",
	"在目标地点创造一个漩涡，持续将150范围内的敌人吸入漩涡。在此期间目标不能攻击、移动、释放技能，并每秒受到庞统攻击力300％的法术伤害。漩涡持续5.5秒。\n（施法范围：600）",
	"在目标地点创造一个漩涡，持续将150范围内的敌人吸入漩涡。在此期间目标不能攻击、移动、释放技能，并每秒受到庞统攻击力300％的法术伤害。漩涡持续6秒。\n（施法范围：600）",
	"在目标地点创造一个漩涡，持续将150范围内的敌人吸入漩涡。在此期间目标不能攻击、移动、释放技能，并每秒受到庞统攻击力300％的法术伤害。漩涡持续6.5秒。\n（施法范围：600）",
	"在目标地点创造一个漩涡，持续将150范围内的敌人吸入漩涡。在此期间目标不能攻击、移动、释放技能，并每秒受到庞统攻击力300％的法术伤害。漩涡持续7秒。\n（施法范围：600）",
	"在目标地点创造一个漩涡，持续将150范围内的敌人吸入漩涡。在此期间目标不能攻击、移动、释放技能，并每秒受到庞统攻击力300％的法术伤害。漩涡持续7.5秒。\n（施法范围：600）",
	"在目标地点创造一个漩涡，持续将150范围内的敌人吸入漩涡。在此期间目标不能攻击、移动、释放技能，并每秒受到庞统攻击力300％的法术伤害。漩涡持续8秒。\n（施法范围：600）",
	"在目标地点创造一个漩涡，持续将150范围内的敌人吸入漩涡。在此期间目标不能攻击、移动、释放技能，并每秒受到庞统攻击力300％的法术伤害。漩涡持续8.5秒。\n（施法范围：600）",
	"在目标地点创造一个漩涡，持续将150范围内的敌人吸入漩涡。在此期间目标不能攻击、移动、释放技能，并每秒受到庞统攻击力300％的法术伤害。漩涡持续9秒。\n（施法范围：600）",
	"在目标地点创造一个漩涡，持续将150范围内的敌人吸入漩涡。在此期间目标不能攻击、移动、释放技能，并每秒受到庞统攻击力300％的法术伤害。漩涡持续9.5秒。\n（施法范围：600）",
	"在目标地点创造一个漩涡，持续将150范围内的敌人吸入漩涡。在此期间目标不能攻击、移动、释放技能，并每秒受到庞统攻击力300％的法术伤害。漩涡持续10秒。\n（施法范围：600）",
}

_tab_stringS[31116] =
{
	"天照",
	"用黑色火焰引爆目标，对目标和目标周围60范围内的敌人造成攻击力60％+65点～245点的法术伤害。目标周围的敌人越多，造成的范围伤害越高。",
	"用黑色火焰引爆目标，对目标和目标周围60范围内的敌人造成攻击力67％+80点～300点的法术伤害。目标周围的敌人越多，造成的范围伤害越高。",
	"用黑色火焰引爆目标，对目标和目标周围60范围内的敌人造成攻击力74％+95点～355点的法术伤害。目标周围的敌人越多，造成的范围伤害越高。",
	"用黑色火焰引爆目标，对目标和目标周围60范围内的敌人造成攻击力81％+110点～410点的法术伤害。目标周围的敌人越多，造成的范围伤害越高。",
	"用黑色火焰引爆目标，对目标和目标周围60范围内的敌人造成攻击力88％+125点～465点的法术伤害。目标周围的敌人越多，造成的范围伤害越高。",
	"用黑色火焰引爆目标，对目标和目标周围60范围内的敌人造成攻击力95％+140点～520点的法术伤害。目标周围的敌人越多，造成的范围伤害越高。",
	"用黑色火焰引爆目标，对目标和目标周围60范围内的敌人造成攻击力102％+155点～575点的法术伤害。目标周围的敌人越多，造成的范围伤害越高。",
	"用黑色火焰引爆目标，对目标和目标周围60范围内的敌人造成攻击力109％+170点～630点的法术伤害。目标周围的敌人越多，造成的范围伤害越高。",
	"用黑色火焰引爆目标，对目标和目标周围60范围内的敌人造成攻击力116％+185点～685点的法术伤害。目标周围的敌人越多，造成的范围伤害越高。",
	"用黑色火焰引爆目标，对目标和目标周围60范围内的敌人造成攻击力123％+200点～740点的法术伤害。目标周围的敌人越多，造成的范围伤害越高。",
	"用黑色火焰引爆目标，对目标和目标周围60范围内的敌人造成攻击力130％+215点～795点的法术伤害。目标周围的敌人越多，造成的范围伤害越高。",
	"用黑色火焰引爆目标，对目标和目标周围60范围内的敌人造成攻击力137％+230点～850点的法术伤害。目标周围的敌人越多，造成的范围伤害越高。",
	"用黑色火焰引爆目标，对目标和目标周围60范围内的敌人造成攻击力141％+245点～905点的法术伤害。目标周围的敌人越多，造成的范围伤害越高。",
	"用黑色火焰引爆目标，对目标和目标周围60范围内的敌人造成攻击力148％+260点～960点的法术伤害。目标周围的敌人越多，造成的范围伤害越高。",
	"用黑色火焰引爆目标，对目标和目标周围60范围内的敌人造成攻击力155％+275点～1015点的法术伤害。目标周围的敌人越多，造成的范围伤害越高。",
}

_tab_stringS[31117] =
{
	"涅槃",
	"庞统生命值低于30％时触发涅槃效果，每秒回复120点生命值，并进入无敌状态，持续3秒。\n触发涅槃时，永久提升自身10点攻击力，可叠加1次。阵亡后此效果消失。（涅槃效果30秒内只能触发一次）",
	"庞统生命值低于30％时触发涅槃效果，每秒回复150点生命值，并进入无敌状态，持续3秒。\n触发涅槃时，永久提升自身10点攻击力，可叠加2次。阵亡后此效果消失。（涅槃效果30秒内只能触发一次）",
	"庞统生命值低于30％时触发涅槃效果，每秒回复180点生命值，并进入无敌状态，持续3秒。\n触发涅槃时，永久提升自身10点攻击力，可叠加3次。阵亡后此效果消失。（涅槃效果30秒内只能触发一次）",
	"庞统生命值低于30％时触发涅槃效果，每秒回复210点生命值，并进入无敌状态，持续3秒。\n触发涅槃时，永久提升自身10点攻击力，可叠加4次。阵亡后此效果消失。（涅槃效果30秒内只能触发一次）",
	"庞统生命值低于30％时触发涅槃效果，每秒回复240点生命值，并进入无敌状态，持续3秒。\n触发涅槃时，永久提升自身10点攻击力，可叠加5次。阵亡后此效果消失。（涅槃效果30秒内只能触发一次）",
	"庞统生命值低于30％时触发涅槃效果，每秒回复270点生命值，并进入无敌状态，持续3秒。\n触发涅槃时，永久提升自身10点攻击力，可叠加6次。阵亡后此效果消失。（涅槃效果30秒内只能触发一次）",
	"庞统生命值低于30％时触发涅槃效果，每秒回复300点生命值，并进入无敌状态，持续3秒。\n触发涅槃时，永久提升自身10点攻击力，可叠加7次。阵亡后此效果消失。（涅槃效果30秒内只能触发一次）",
	"庞统生命值低于30％时触发涅槃效果，每秒回复330点生命值，并进入无敌状态，持续3秒。\n触发涅槃时，永久提升自身10点攻击力，可叠加8次。阵亡后此效果消失。（涅槃效果30秒内只能触发一次）",
	"庞统生命值低于30％时触发涅槃效果，每秒回复360点生命值，并进入无敌状态，持续3秒。\n触发涅槃时，永久提升自身10点攻击力，可叠加9次。阵亡后此效果消失。（涅槃效果30秒内只能触发一次）",
	"庞统生命值低于30％时触发涅槃效果，每秒回复390点生命值，并进入无敌状态，持续3秒。\n触发涅槃时，永久提升自身10点攻击力，可叠加10次。阵亡后此效果消失。（涅槃效果30秒内只能触发一次）",
	"庞统生命值低于30％时触发涅槃效果，每秒回复420点生命值，并进入无敌状态，持续3秒。\n触发涅槃时，永久提升自身10点攻击力，可叠加11次。阵亡后此效果消失。（涅槃效果30秒内只能触发一次）",
	"庞统生命值低于30％时触发涅槃效果，每秒回复450点生命值，并进入无敌状态，持续3秒。\n触发涅槃时，永久提升自身10点攻击力，可叠加12次。阵亡后此效果消失。（涅槃效果30秒内只能触发一次）",
	"庞统生命值低于30％时触发涅槃效果，每秒回复480点生命值，并进入无敌状态，持续3秒。\n触发涅槃时，永久提升自身10点攻击力，可叠加13次。阵亡后此效果消失。（涅槃效果30秒内只能触发一次）",
	"庞统生命值低于30％时触发涅槃效果，每秒回复510点生命值，并进入无敌状态，持续3秒。\n触发涅槃时，永久提升自身10点攻击力，可叠加14次。阵亡后此效果消失。（涅槃效果30秒内只能触发一次）",
	"庞统生命值低于30％时触发涅槃效果，每秒回复540点生命值，并进入无敌状态，持续3秒。\n触发涅槃时，永久提升自身10点攻击力，可叠加15次。阵亡后此效果消失。（涅槃效果30秒内只能触发一次）",
}

--PVP庞统技能
_tab_stringS[31124] = 
{
	"黑炎漩涡（竞技场）",
	"在目标地点创造一个漩涡，持续将110范围内地面上的敌人吸入漩涡。在此期间目标不能攻击、移动、释放技能，并每秒受到庞统攻击力150％的法术伤害。漩涡持续3.5秒。\n（施法范围：200）",
	"在目标地点创造一个漩涡，持续将110范围内地面上的敌人吸入漩涡。在此期间目标不能攻击、移动、释放技能，并每秒受到庞统攻击力200％的法术伤害。漩涡持续4秒。\n（施法范围：200）",
	"在目标地点创造一个漩涡，持续将110范围内地面上的敌人吸入漩涡。在此期间目标不能攻击、移动、释放技能，并每秒受到庞统攻击力250％的法术伤害。漩涡持续4.5秒。\n（施法范围：200）",
	"在目标地点创造一个漩涡，持续将110范围内地面上的敌人吸入漩涡。在此期间目标不能攻击、移动、释放技能，并每秒受到庞统攻击力300％的法术伤害。漩涡持续5秒。\n（施法范围：200）",
	"在目标地点创造一个漩涡，持续将110范围内地面上的敌人吸入漩涡。在此期间目标不能攻击、移动、释放技能，并每秒受到庞统攻击力350％的法术伤害。漩涡持续5.5秒。\n（施法范围：200）",
	"在目标地点创造一个漩涡，持续将110范围内地面上的敌人吸入漩涡。在此期间目标不能攻击、移动、释放技能，并每秒受到庞统攻击力400％的法术伤害。漩涡持续6秒。\n（施法范围：200）",
	"在目标地点创造一个漩涡，持续将110范围内地面上的敌人吸入漩涡。在此期间目标不能攻击、移动、释放技能，并每秒受到庞统攻击力450％的法术伤害。漩涡持续6秒。\n（施法范围：200）",
	"在目标地点创造一个漩涡，持续将110范围内地面上的敌人吸入漩涡。在此期间目标不能攻击、移动、释放技能，并每秒受到庞统攻击力500％的法术伤害。漩涡持续6秒。\n（施法范围：200）",
	"在目标地点创造一个漩涡，持续将110范围内地面上的敌人吸入漩涡。在此期间目标不能攻击、移动、释放技能，并每秒受到庞统攻击力550％的法术伤害。漩涡持续6秒。\n（施法范围：200）",
	"在目标地点创造一个漩涡，持续将110范围内地面上的敌人吸入漩涡。在此期间目标不能攻击、移动、释放技能，并每秒受到庞统攻击力600％的法术伤害。漩涡持续6秒。\n（施法范围：200）",
	"在目标地点创造一个漩涡，持续将110范围内地面上的敌人吸入漩涡。在此期间目标不能攻击、移动、释放技能，并每秒受到庞统攻击力650％的法术伤害。漩涡持续6秒。\n（施法范围：200）",
	"在目标地点创造一个漩涡，持续将110范围内地面上的敌人吸入漩涡。在此期间目标不能攻击、移动、释放技能，并每秒受到庞统攻击力700％的法术伤害。漩涡持续6秒。\n（施法范围：200）",
	"在目标地点创造一个漩涡，持续将110范围内地面上的敌人吸入漩涡。在此期间目标不能攻击、移动、释放技能，并每秒受到庞统攻击力750％的法术伤害。漩涡持续6秒。\n（施法范围：200）",
	"在目标地点创造一个漩涡，持续将110范围内地面上的敌人吸入漩涡。在此期间目标不能攻击、移动、释放技能，并每秒受到庞统攻击力800％的法术伤害。漩涡持续6秒。\n（施法范围：200）",
	"在目标地点创造一个漩涡，持续将110范围内地面上的敌人吸入漩涡。在此期间目标不能攻击、移动、释放技能，并每秒受到庞统攻击力850％的法术伤害。漩涡持续6秒。\n（施法范围：200）",
}


_tab_stringS[12001] = {"群体加速", "加自己和100范围内的友军50％移动速度，持续5秒。"}
_tab_stringS[12006] = {"召唤群狼", "召唤群狼"}
_tab_stringS[12007] = {"召唤黄巾军", "每3秒召唤6个随机的黄巾军。一共召唤3波。"}
_tab_stringS[12008] = {"召唤凶狼", "召唤1只100点生命，10-15点攻击的凶狼。"}
_tab_stringS[12009] = {"无双", "增加自身45点攻击力、20点移动速度、50％闪避，持续3秒。"}
_tab_stringS[12011] = {"野性之力", "增加自身70点移动速度、50％闪避，持续5秒。"}
_tab_stringS[12013] = {"召唤幼狼", "召唤1只30点生命，2-3点攻击的幼狼。"}
_tab_stringS[12014] = {"群体回血", "增加自己和100范围内的友军15点/秒的回血速度，持续5秒。"}
_tab_stringS[12016] = {"无双", "增加自身45点攻击力、20点移动速度、50％闪避，持续3秒。"}
_tab_stringS[12018] = {"群体护盾", "增加自己和100范围内的友军20点物理防御、20点法术防御、30点/秒回血速度，持续8秒。"}
_tab_stringS[12021] = {"群体加攻", "增加自己和100范围内的友军20点攻击，持续5秒。"}
_tab_stringS[12023] = {"群体点燃", "祸斗点燃四周，立即对125范围内的敌人造成80点伤害。并持续燃烧地面，对处在燃烧区域的敌人每秒造成24点伤害。地面持续燃烧16秒。"}
_tab_stringS[12029] = {"双火球术", "祸斗的两个头分别向目标喷射出大火球，每个火球造成45-60点伤害。"}
_tab_stringS[12037] = {"群体禁锢", "对120范围内的敌人造成20点伤害，并冰冻5秒。"}
_tab_stringS[12039] = {"重击", "击晕目标2秒。"}
_tab_stringS[12040] = {"瞬移", "瞬间向前移动450的距离。"}
_tab_stringS[12044] = {"鼓舞", "增加自己和100范围内的友军30％攻击力、25％移动速度、50％闪避，持续5秒。"}
_tab_stringS[12046] = {"赤兔之速", "增加自身200点移动速度，持续1秒。"}
_tab_stringS[12048] = {"疯狂打击", "吕布疯狂地打击着身边的敌人。每0.3秒对自身100范围内的敌人造成200点伤害，持续2秒。"}
_tab_stringS[12050] = {"召唤术", "召唤5个精锐单位为你战斗。"}
_tab_stringS[12051] = {"扎营", "增加自身75点物理防御、75点法术防御、50点/秒回血速度，持续3秒。在此期间停止移动，驻守在原地。"}
_tab_stringS[12055] = {"火球四连击", "向目标发出4个大火球，每个火球造成45-60点伤害。"}
_tab_stringS[12057] = {"召唤弓箭手", "召唤5个300点生命,15-20点攻击的弓箭手为你战斗。"}
_tab_stringS[12058] = {"超级肉盾", "增加自身360点攻击力、60点物理防御、60点法术防御，持续5秒。在此期间降低自身20点移动速度。"}
_tab_stringS[12060] = {"炎爆术", "释放一个巨大的炎爆球，对90范围内的敌人造成500点伤害。"}
_tab_stringS[12062] = {"疯狂打击", "文丑疯狂地打击着身边的敌人。每0.3秒对自身120范围内的敌人造成235点伤害，持续2秒。"}
_tab_stringS[12064] = {"群体减速", "对120范围内的敌人造成20点伤害，并降低75点移动速度，减速效果持续5秒。"}
_tab_stringS[12080] = {"血月斩", "向目标发动1-3道血月，每道造成150点伤害。"}
_tab_stringS[12081] = {"召唤精锐", "每6秒召唤5个随机的精锐部队。一共召唤3波。"}
_tab_stringS[12083] = {"射术精通", "增加自身50％闪避、200码的射程，持续5秒。"}
_tab_stringS[12093] = {"吸血", "增加自身60点攻击力、600％吸血，持续5秒。"}
_tab_stringS[12115] = {"破胆一喝", "猛击地面，对80范围内的敌人造成40-60点伤害，并震晕2秒。"}
_tab_stringS[12117] = {"召唤孔明灯", "每1秒召唤3个随机的孔明灯。一共召唤3波。"}
_tab_stringS[12131] = {"小旋风", "朝目标方向发出一道旋风，对一条直线上碰到的敌人造成20点伤害。"}
_tab_stringS[12132] = {"大旋风", "在变身状态下，同时发出5道旋风，每道都对一条直线上碰到的敌人造成60点伤害。"}
_tab_stringS[12133] = {"变身", "纪灵变身为狂魔，增加500点生命上限，并拥有技能“大旋风”。"}
_tab_stringS[12150] = {"高级鼓舞", "增加自己和100范围内的友军100％攻击速度、25％移动速度、100码的射程，持续5秒。"}
_tab_stringS[12155] = {"二连刺旋风", "每轮朝目标方向发出两道旋风，对一条直线上碰到的敌人造成20-60点伤害。一共发出2轮。"}
_tab_stringS[12157] = {"召唤绿球", "召唤1个1300点生命，12-15点攻击的绿球。绿球拥有技能“回复术”：每秒给自己和周围80范围内的友军回复50点生命。"}
_tab_stringS[12161] = {"六道青龙乱舞", "每轮朝目标方向发出两道超远的刀舞，对一条直线上碰到的敌人造成关羽自身攻击力75％的伤害。一共发出6轮。"}
_tab_stringS[12162] = {"默契", "增加颜良、文丑自己和他们100范围内的友军200％攻击力、35％移动速度、200点/秒回血速度，持续8秒。"}



_tab_stringS[14015] =
{
	"援军",
	"召唤2个民兵为你战斗。民兵附加刘备44％的生命值、攻击力、物理防御、法术防御。民兵存在55秒。\n（施法范围：全地图）",
	"召唤2个民兵为你战斗。民兵附加刘备48％的生命值、攻击力、物理防御、法术防御。民兵存在55秒。\n（施法范围：全地图）",
	"召唤2个民兵为你战斗。民兵附加刘备52％的生命值、攻击力、物理防御、法术防御。民兵存在55秒。\n（施法范围：全地图）",
	"召唤2个民兵为你战斗。民兵附加刘备56％的生命值、攻击力、物理防御、法术防御。民兵存在55秒。\n（施法范围：全地图）",
	"召唤2个民兵为你战斗。民兵附加刘备60％的生命值、攻击力、物理防御、法术防御。民兵存在55秒。\n（施法范围：全地图）",
	"召唤2个民兵为你战斗。民兵附加刘备64％的生命值、攻击力、物理防御、法术防御。民兵存在55秒。\n（施法范围：全地图）",
	"召唤2个民兵为你战斗。民兵附加刘备68％的生命值、攻击力、物理防御、法术防御。民兵存在55秒。\n（施法范围：全地图）",
	"召唤2个民兵为你战斗。民兵附加刘备72％的生命值、攻击力、物理防御、法术防御。民兵存在55秒。\n（施法范围：全地图）",
	"召唤2个民兵为你战斗。民兵附加刘备76％的生命值、攻击力、物理防御、法术防御。民兵存在55秒。\n（施法范围：全地图）",
	"召唤2个民兵为你战斗。民兵附加刘备80％的生命值、攻击力、物理防御、法术防御。民兵存在55秒。\n（施法范围：全地图）",
	"召唤2个白耳兵为你战斗。白耳兵拥有超高物理闪避，并附加刘备84％的生命值、攻击力、物理防御、法术防御。白耳兵存在55秒。\n（施法范围：全地图）",
	"召唤2个白耳兵为你战斗。白耳兵拥有超高物理闪避，并附加刘备88％的生命值、攻击力、物理防御、法术防御。白耳兵存在55秒。\n（施法范围：全地图）",
	"召唤2个白耳兵为你战斗。白耳兵拥有超高物理闪避，并附加刘备92％的生命值、攻击力、物理防御、法术防御。白耳兵存在55秒。\n（施法范围：全地图）",
	"召唤2个白耳兵为你战斗。白耳兵拥有超高物理闪避，并附加刘备96％的生命值、攻击力、物理防御、法术防御。白耳兵存在55秒。\n（施法范围：全地图）",
	"召唤2个白耳兵为你战斗。白耳兵拥有超高物理闪避，并附加刘备100％的生命值、攻击力、物理防御、法术防御。白耳兵存在55秒。\n（施法范围：全地图）",
}

_tab_stringS[14021] =
{
	"燕人咆哮",
	"发出恐怖的咆哮，对自身135范围内的敌人造成攻击力120％+60点的真实伤害，并混乱2秒。混乱期间目标不受操控并四处乱走。",
	"发出恐怖的咆哮，对自身135范围内的敌人造成攻击力140％+80点的真实伤害，并混乱2.2秒。混乱期间目标不受操控并四处乱走。",
	"发出恐怖的咆哮，对自身135范围内的敌人造成攻击力160％+100点的真实伤害，并混乱2.4秒。混乱期间目标不受操控并四处乱走。",
	"发出恐怖的咆哮，对自身135范围内的敌人造成攻击力180％+120点的真实伤害，并混乱2.6秒。混乱期间目标不受操控并四处乱走。",
	"发出恐怖的咆哮，对自身135范围内的敌人造成攻击力200％+140点的真实伤害，并混乱2.8秒。混乱期间目标不受操控并四处乱走。",
	"发出恐怖的咆哮，对自身135范围内的敌人造成攻击力220％+160点的真实伤害，并混乱3秒。混乱期间目标不受操控并四处乱走。",
	"发出恐怖的咆哮，对自身135范围内的敌人造成攻击力240％+180点的真实伤害，并混乱3.2秒。混乱期间目标不受操控并四处乱走。",
	"发出恐怖的咆哮，对自身135范围内的敌人造成攻击力260％+200点的真实伤害，并混乱3.4秒。混乱期间目标不受操控并四处乱走。",
	"发出恐怖的咆哮，对自身135范围内的敌人造成攻击力280％+220点的真实伤害，并混乱3.6秒。混乱期间目标不受操控并四处乱走。",
	"发出恐怖的咆哮，对自身135范围内的敌人造成攻击力300％+240点的真实伤害，并混乱3.8秒。混乱期间目标不受操控并四处乱走。",
	"发出恐怖的咆哮，对自身135范围内的敌人造成攻击力320％+260点的真实伤害，并混乱4秒。混乱期间目标不受操控并四处乱走。",
	"发出恐怖的咆哮，对自身135范围内的敌人造成攻击力340％+280点的真实伤害，并混乱4.2秒。混乱期间目标不受操控并四处乱走。",
	"发出恐怖的咆哮，对自身135范围内的敌人造成攻击力360％+300点的真实伤害，并混乱4.4秒。混乱期间目标不受操控并四处乱走。",
	"发出恐怖的咆哮，对自身135范围内的敌人造成攻击力380％+320点的真实伤害，并混乱4.6秒。混乱期间目标不受操控并四处乱走。",
	"发出恐怖的咆哮，对自身135范围内的敌人造成攻击力400％+340点的真实伤害，并混乱4.8秒。混乱期间目标不受操控并四处乱走。",
}

_tab_stringS[14022] =
{
	"青龙乱舞",
	"挥出5轮刀舞，每轮都对自身120范围内的敌人造成攻击力69％+27点的物理伤害。",
	"挥出5轮刀舞，每轮都对自身120范围内的敌人造成攻击力78％+36点的物理伤害。",
	"挥出5轮刀舞，每轮都对自身120范围内的敌人造成攻击力87％+45点的物理伤害。",
	"挥出5轮刀舞，每轮都对自身120范围内的敌人造成攻击力96％+54点的物理伤害。",
	"挥出5轮刀舞，每轮都对自身120范围内的敌人造成攻击力105％+63点的物理伤害。",
	"挥出5轮刀舞，每轮都对自身120范围内的敌人造成攻击力114％+72点的物理伤害。",
	"挥出5轮刀舞，每轮都对自身120范围内的敌人造成攻击力123％+81点的物理伤害。",
	"挥出5轮刀舞，每轮都对自身120范围内的敌人造成攻击力132％+90点的物理伤害。",
	"挥出5轮刀舞，每轮都对自身120范围内的敌人造成攻击力141％+99点的物理伤害。",
	"挥出5轮刀舞，每轮都对自身120范围内的敌人造成攻击力150％+108点的物理伤害。",
	"挥出5轮刀舞，每轮都对自身120范围内的敌人造成攻击力159％+117点的物理伤害。",
	"挥出5轮刀舞，每轮都对自身120范围内的敌人造成攻击力168％+126点的物理伤害。",
	"挥出5轮刀舞，每轮都对自身120范围内的敌人造成攻击力177％+135点的物理伤害。",
	"挥出5轮刀舞，每轮都对自身120范围内的敌人造成攻击力186％+144点的物理伤害。",
	"挥出5轮刀舞，每轮都对自身120范围内的敌人造成攻击力195％+153点的物理伤害。",
}

_tab_stringS[14023] = {"全军突击",
	"提升自己和附近120范围内的友军12％的移动速度、攻击速度、射程，持续15秒。",
	"提升自己和附近120范围内的友军13％的移动速度、攻击速度、射程，持续16秒。",
	"提升自己和附近120范围内的友军14％的移动速度、攻击速度、射程，持续17秒。",
	"提升自己和附近120范围内的友军15％的移动速度、攻击速度、射程，持续18秒。",
	"提升自己和附近120范围内的友军16％的移动速度、攻击速度、射程，持续19秒。",
	"提升自己和附近120范围内的友军17％的移动速度、攻击速度、射程，持续20秒。",
	"提升自己和附近120范围内的友军18％的移动速度、攻击速度、射程，持续21秒。",
	"提升自己和附近120范围内的友军19％的移动速度、攻击速度、射程，持续22秒。",
	"提升自己和附近120范围内的友军20％的移动速度、攻击速度、射程，持续23秒。",
	"提升自己和附近120范围内的友军21％的移动速度、攻击速度、射程，持续24秒。",
	"提升自己和附近120范围内的友军22％的移动速度、攻击速度、射程，持续25秒。",
	"提升自己和附近120范围内的友军23％的移动速度、攻击速度、射程，持续26秒。",
	"提升自己和附近120范围内的友军24％的移动速度、攻击速度、射程，持续27秒。",
	"提升自己和附近120范围内的友军25％的移动速度、攻击速度、射程，持续28秒。",
	"提升自己和附近120范围内的友军26％的移动速度、攻击速度、射程，持续29秒。",
}

_tab_stringS[14025] =
{
	"军令如山",
	"召唤3个弓箭手为你战斗。弓箭手附加曹操22％生命值和44％攻击力、物理防御、法术防御。弓箭手存在25秒。\n（施法范围：全地图）",
	"召唤3个弓箭手为你战斗。弓箭手附加曹操24％生命值和48％攻击力、物理防御、法术防御。弓箭手存在25秒。\n（施法范围：全地图）",
	"召唤3个弓箭手为你战斗。弓箭手附加曹操26％生命值和52％攻击力、物理防御、法术防御。弓箭手存在25秒。\n（施法范围：全地图）",
	"召唤3个弓箭手为你战斗。弓箭手附加曹操28％生命值和56％攻击力、物理防御、法术防御。弓箭手存在25秒。\n（施法范围：全地图）",
	"召唤3个弓箭手为你战斗。弓箭手附加曹操30％生命值和60％攻击力、物理防御、法术防御。弓箭手存在25秒。\n（施法范围：全地图）",
	"召唤3个弓箭手为你战斗。弓箭手附加曹操32％生命值和64％攻击力、物理防御、法术防御。弓箭手存在25秒。\n（施法范围：全地图）",
	"召唤3个弓箭手为你战斗。弓箭手附加曹操34％生命值和68％攻击力、物理防御、法术防御。弓箭手存在25秒。\n（施法范围：全地图）",
	"召唤3个弓箭手为你战斗。弓箭手附加曹操36％生命值和72％攻击力、物理防御、法术防御。弓箭手存在25秒。\n（施法范围：全地图）",
	"召唤3个弓箭手为你战斗。弓箭手附加曹操38％生命值和76％攻击力、物理防御、法术防御。弓箭手存在25秒。\n（施法范围：全地图）",
	"召唤3个弓箭手为你战斗。弓箭手附加曹操40％生命值和80％攻击力、物理防御、法术防御。弓箭手存在25秒。\n（施法范围：全地图）",
	"召唤3个精锐弓箭手为你战斗。弓箭手拥有散射技能，并附加曹操42％生命值和84％攻击力、物理防御、法术防御。精锐弓箭手存在25秒。\n（施法范围：全地图）",
	"召唤3个精锐弓箭手为你战斗。弓箭手拥有散射技能，并附加曹操44％生命值和88％攻击力、物理防御、法术防御。精锐弓箭手存在25秒。\n（施法范围：全地图）",
	"召唤3个精锐弓箭手为你战斗。弓箭手拥有散射技能，并附加曹操46％生命值和92％攻击力、物理防御、法术防御。精锐弓箭手存在25秒。\n（施法范围：全地图）",
	"召唤3个精锐弓箭手为你战斗。弓箭手拥有散射技能，并附加曹操48％生命值和96％攻击力、物理防御、法术防御。精锐弓箭手存在25秒。\n（施法范围：全地图）",
	"召唤3个精锐弓箭手为你战斗。弓箭手拥有散射技能，并附加曹操50％生命值和100％攻击力、物理防御、法术防御。精锐弓箭手存在25秒。\n（施法范围：全地图）",
}

_tab_stringS[14026] =
{
	"冰河爆裂破",
	"发动连续的冰暴轰炸，对一直线上的敌人造成攻击力115％+180点的法术伤害，并冻结2.8秒。\n（施法范围：400）",
	"发动连续的冰暴轰炸，对一直线上的敌人造成攻击力130％+210点的法术伤害，并冻结2.9秒。\n（施法范围：400）",
	"发动连续的冰暴轰炸，对一直线上的敌人造成攻击力145％+240点的法术伤害，并冻结3秒。\n（施法范围：400）",
	"发动连续的冰暴轰炸，对一直线上的敌人造成攻击力160％+270点的法术伤害，并冻结3.1秒。\n（施法范围：400）",
	"发动连续的冰暴轰炸，对一直线上的敌人造成攻击力175％+300点的法术伤害，并冻结3.2秒。\n（施法范围：400）",
	"发动连续的冰暴轰炸，对一直线上的敌人造成攻击力190％+330点的法术伤害，并冻结3.3秒。\n（施法范围：400）",
	"发动连续的冰暴轰炸，对一直线上的敌人造成攻击力205％+360点的法术伤害，并冻结3.4秒。\n（施法范围：400）",
	"发动连续的冰暴轰炸，对一直线上的敌人造成攻击力220％+390点的法术伤害，并冻结3.5秒。\n（施法范围：400）",
	"发动连续的冰暴轰炸，对一直线上的敌人造成攻击力235％+420点的法术伤害，并冻结3.6秒。\n（施法范围：400）",
	"发动连续的冰暴轰炸，对一直线上的敌人造成攻击力250％+450点的法术伤害，并冻结3.7秒。\n（施法范围：400）",
	"发动连续的冰暴轰炸，对一直线上的敌人造成攻击力265％+480点的法术伤害，并冻结3.8秒。\n（施法范围：400）",
	"发动连续的冰暴轰炸，对一直线上的敌人造成攻击力280％+510点的法术伤害，并冻结3.9秒。\n（施法范围：400）",
	"发动连续的冰暴轰炸，对一直线上的敌人造成攻击力295％+540点的法术伤害，并冻结4秒。\n（施法范围：400）",
	"发动连续的冰暴轰炸，对一直线上的敌人造成攻击力310％+570点的法术伤害，并冻结4.1秒。\n（施法范围：400）",
	"发动连续的冰暴轰炸，对一直线上的敌人造成攻击力325％+600点的法术伤害，并冻结4.2秒。\n（施法范围：400）",
}


_tab_stringS[14040] = {"无双分身",
	"召唤1个拥有嘲讽、可操控的分身为你战斗。分身拥有赵云38％的生命值、攻击力、攻击速度、暴击几率、暴击倍率等属性，并拥有赵云的全部技能。分身受到200％的伤害。分身存在9秒。\n（施法范围：全地图）",
	"召唤1个拥有嘲讽、可操控的分身为你战斗。分身拥有赵云41％的生命值、攻击力、攻击速度、暴击几率、暴击倍率等属性，并拥有赵云的全部技能。分身受到200％的伤害。分身存在9.5秒。\n（施法范围：全地图）",
	"召唤1个拥有嘲讽、可操控的分身为你战斗。分身拥有赵云44％的生命值、攻击力、攻击速度、暴击几率、暴击倍率等属性，并拥有赵云的全部技能。分身受到200％的伤害。分身存在10秒。\n（施法范围：全地图）",
	"召唤1个拥有嘲讽、可操控的分身为你战斗。分身拥有赵云47％的生命值、攻击力、攻击速度、暴击几率、暴击倍率等属性，并拥有赵云的全部技能。分身受到200％的伤害。分身存在10.5秒。\n（施法范围：全地图）",
	"召唤1个拥有嘲讽、可操控的分身为你战斗。分身拥有赵云50％的生命值、攻击力、攻击速度、暴击几率、暴击倍率等属性，并拥有赵云的全部技能。分身受到200％的伤害。分身存在11秒。\n（施法范围：全地图）",
	"召唤1个拥有嘲讽、可操控的分身为你战斗。分身拥有赵云53％的生命值、攻击力、攻击速度、暴击几率、暴击倍率等属性，并拥有赵云的全部技能。分身受到200％的伤害。分身存在11.5秒。\n（施法范围：全地图）",
	"召唤1个拥有嘲讽、可操控的分身为你战斗。分身拥有赵云56％的生命值、攻击力、攻击速度、暴击几率、暴击倍率等属性，并拥有赵云的全部技能。分身受到200％的伤害。分身存在12秒。\n（施法范围：全地图）",
	"召唤1个拥有嘲讽、可操控的分身为你战斗。分身拥有赵云59％的生命值、攻击力、攻击速度、暴击几率、暴击倍率等属性，并拥有赵云的全部技能。分身受到200％的伤害。分身存在12.5秒。\n（施法范围：全地图）",
	"召唤1个拥有嘲讽、可操控的分身为你战斗。分身拥有赵云62％的生命值、攻击力、攻击速度、暴击几率、暴击倍率等属性，并拥有赵云的全部技能。分身受到200％的伤害。分身存在13秒。\n（施法范围：全地图）",
	"召唤1个拥有嘲讽、可操控的分身为你战斗。分身拥有赵云65％的生命值、攻击力、攻击速度、暴击几率、暴击倍率等属性，并拥有赵云的全部技能。分身受到200％的伤害。分身存在13.5秒。\n（施法范围：全地图）",
	"召唤1个拥有嘲讽、可操控的分身为你战斗。分身拥有赵云68％的生命值、攻击力、攻击速度、暴击几率、暴击倍率等属性，并拥有赵云的全部技能。分身受到200％的伤害。分身存在14秒。\n（施法范围：全地图）",
	"召唤1个拥有嘲讽、可操控的分身为你战斗。分身拥有赵云71％的生命值、攻击力、攻击速度、暴击几率、暴击倍率等属性，并拥有赵云的全部技能。分身受到200％的伤害。分身存在14.5秒。\n（施法范围：全地图）",
	"召唤1个拥有嘲讽、可操控的分身为你战斗。分身拥有赵云74％的生命值、攻击力、攻击速度、暴击几率、暴击倍率等属性，并拥有赵云的全部技能。分身受到200％的伤害。分身存在15秒。\n（施法范围：全地图）",
	"召唤1个拥有嘲讽、可操控的分身为你战斗。分身拥有赵云77％的生命值、攻击力、攻击速度、暴击几率、暴击倍率等属性，并拥有赵云的全部技能。分身受到200％的伤害。分身存在15.5秒。\n（施法范围：全地图）",
	"召唤1个拥有嘲讽、可操控的分身为你战斗。分身拥有赵云80％的生命值、攻击力、攻击速度、暴击几率、暴击倍率等属性，并拥有赵云的全部技能。分身受到200％的伤害。分身存在16秒。\n（施法范围：全地图）",
}


_tab_stringS[14041] = {"星轮斩",
	"同时发出5道月轮，每道都对一条直线上碰到的敌人造成攻击力120％+30点的物理伤害。",
	"同时发出5道月轮，每道都对一条直线上碰到的敌人造成攻击力130％+40点的物理伤害。",
	"同时发出5道月轮，每道都对一条直线上碰到的敌人造成攻击力140％+50点的物理伤害。",
	"同时发出5道月轮，每道都对一条直线上碰到的敌人造成攻击力150％+60点的物理伤害。",
	"同时发出5道月轮，每道都对一条直线上碰到的敌人造成攻击力160％+70点的物理伤害。",
	"同时发出5道月轮，每道都对一条直线上碰到的敌人造成攻击力170％+80点的物理伤害。",
	"同时发出5道月轮，每道都对一条直线上碰到的敌人造成攻击力180％+90点的物理伤害。",
	"同时发出5道月轮，每道都对一条直线上碰到的敌人造成攻击力190％+100点的物理伤害。",
	"同时发出5道月轮，每道都对一条直线上碰到的敌人造成攻击力200％+110点的物理伤害。",
	"同时发出5道月轮，每道都对一条直线上碰到的敌人造成攻击力210％+120点的物理伤害。",
	"同时发出5道月轮，每道都对一条直线上碰到的敌人造成攻击力220％+130点的物理伤害。",
	"同时发出5道月轮，每道都对一条直线上碰到的敌人造成攻击力230％+140点的物理伤害。",
	"同时发出5道月轮，每道都对一条直线上碰到的敌人造成攻击力240％+150点的物理伤害。",
	"同时发出5道月轮，每道都对一条直线上碰到的敌人造成攻击力250％+160点的物理伤害。",
	"同时发出5道月轮，每道都对一条直线上碰到的敌人造成攻击力260％+170点的物理伤害。",
}


_tab_stringS[14042] ={
	"无双战神",
	"激发战意，增加自身33％的攻击速度和移动速度、4点物理防御和法术防御、50％溅射，持续30秒。",
	"激发战意，增加自身36％的攻击速度和移动速度、8点物理防御和法术防御、50％溅射，持续30秒。",
	"激发战意，增加自身39％的攻击速度和移动速度、12点物理防御和法术防御、50％溅射，持续30秒。",
	"激发战意，增加自身42％的攻击速度和移动速度、16点物理防御和法术防御、50％溅射，持续30秒。",
	"激发战意，增加自身45％的攻击速度和移动速度、20点物理防御和法术防御、50％溅射，持续30秒。",
	"激发战意，增加自身48％的攻击速度和移动速度、24点物理防御和法术防御、50％溅射，持续30秒。",
	"激发战意，增加自身51％的攻击速度和移动速度、28点物理防御和法术防御、50％溅射，持续30秒。",
	"激发战意，增加自身54％的攻击速度和移动速度、32点物理防御和法术防御、50％溅射，持续30秒。",
	"激发战意，增加自身57％的攻击速度和移动速度、36点物理防御和法术防御、50％溅射，持续30秒。",
	"激发战意，增加自身60％的攻击速度和移动速度、40点物理防御和法术防御、50％溅射，持续30秒。",
	"激发战意，增加自身63％的攻击速度和移动速度、44点物理防御和法术防御、50％溅射，并获得免疫控制的效果，持续30秒。",
	"激发战意，增加自身66％的攻击速度和移动速度、48点物理防御和法术防御、50％溅射，并获得免疫控制的效果，持续30秒。",
	"激发战意，增加自身69％的攻击速度和移动速度、52点物理防御和法术防御、50％溅射，并获得免疫控制的效果，持续30秒。",
	"激发战意，增加自身72％的攻击速度和移动速度、56点物理防御和法术防御、50％溅射，并获得免疫控制的效果，持续30秒。",
	"激发战意，增加自身75％的攻击速度和移动速度、60点物理防御和法术防御、50％溅射，并获得免疫控制的效果，持续30秒。",
}

_tab_stringS[14043] = {"月下美人",
	"用曼妙的身姿魅惑120范围内的敌人，造成攻击力90％+120点的真实伤害，并降低90％的移动速度，持续5秒。同时增加自身20％的物理闪避和暴击几率，持续15秒。",
	"用曼妙的身姿魅惑120范围内的敌人，造成攻击力105％+140点的真实伤害，并降低90％的移动速度，持续5秒。同时增加自身22％的物理闪避和暴击几率，持续15秒。",
	"用曼妙的身姿魅惑120范围内的敌人，造成攻击力120％+160点的真实伤害，并降低90％的移动速度，持续5秒。同时增加自身24％的物理闪避和暴击几率，持续15秒。",
	"用曼妙的身姿魅惑120范围内的敌人，造成攻击力135％+180点的真实伤害，并降低90％的移动速度，持续5秒。同时增加自身26％的物理闪避和暴击几率，持续15秒。",
	"用曼妙的身姿魅惑120范围内的敌人，造成攻击力150％+200点的真实伤害，并降低90％的移动速度，持续5秒。同时增加自身28％的物理闪避和暴击几率，持续15秒。",
	"用曼妙的身姿魅惑120范围内的敌人，造成攻击力165％+220点的真实伤害，并降低90％的移动速度，持续5秒。同时增加自身30％的物理闪避和暴击几率，持续15秒。",
	"用曼妙的身姿魅惑120范围内的敌人，造成攻击力180％+240点的真实伤害，并降低90％的移动速度，持续5秒。同时增加自身32％的物理闪避和暴击几率，持续15秒。",
	"用曼妙的身姿魅惑120范围内的敌人，造成攻击力195％+260点的真实伤害，并降低90％的移动速度，持续5秒。同时增加自身34％的物理闪避和暴击几率，持续15秒。",
	"用曼妙的身姿魅惑120范围内的敌人，造成攻击力210％+280点的真实伤害，并降低90％的移动速度，持续5秒。同时增加自身36％的物理闪避和暴击几率，持续15秒。",
	"用曼妙的身姿魅惑120范围内的敌人，造成攻击力225％+300点的真实伤害，并降低90％的移动速度，持续5秒。同时增加自身38％的物理闪避和暴击几率，持续15秒。",
	"用曼妙的身姿魅惑120范围内的敌人，造成攻击力240％+320点的真实伤害，并降低90％的移动速度，持续5秒。同时增加自身40％的物理闪避和暴击几率，持续15秒。",
	"用曼妙的身姿魅惑120范围内的敌人，造成攻击力255％+340点的真实伤害，并降低90％的移动速度，持续5秒。同时增加自身42％的物理闪避和暴击几率，持续15秒。",
	"用曼妙的身姿魅惑120范围内的敌人，造成攻击力270％+360点的真实伤害，并降低90％的移动速度，持续5秒。同时增加自身44％的物理闪避和暴击几率，持续15秒。",
	"用曼妙的身姿魅惑120范围内的敌人，造成攻击力295％+380点的真实伤害，并降低90％的移动速度，持续5秒。同时增加自身46％的物理闪避和暴击几率，持续15秒。",
	"用曼妙的身姿魅惑120范围内的敌人，造成攻击力310％+400点的真实伤害，并降低90％的移动速度，持续5秒。同时增加自身48％的物理闪避和暴击几率，持续15秒。",
}


_tab_stringS[14047] = {"猩红战阵",
	"将150范围内的敌人拉至张辽身边，造成6倍物理防御的物理伤害，并震晕1.2秒。",
	"将150范围内的敌人拉至张辽身边，造成7倍物理防御的物理伤害，并震晕1.4秒。",
	"将150范围内的敌人拉至张辽身边，造成8倍物理防御的物理伤害，并震晕1.6秒。",
	"将150范围内的敌人拉至张辽身边，造成9倍物理防御的物理伤害，并震晕1.8秒。",
	"将150范围内的敌人拉至张辽身边，造成10倍物理防御的物理伤害，并震晕2秒。",
	"将150范围内的敌人拉至张辽身边，造成11倍物理防御的物理伤害，并震晕2.2秒。",
	"将150范围内的敌人拉至张辽身边，造成12倍物理防御的物理伤害，并震晕2.4秒。",
	"将150范围内的敌人拉至张辽身边，造成13倍物理防御的物理伤害，并震晕2.6秒。",
	"将150范围内的敌人拉至张辽身边，造成14倍物理防御的物理伤害，并震晕2.8秒。",
	"将150范围内的敌人拉至张辽身边，造成15倍物理防御的物理伤害，并震晕3秒。",
	"将150范围内的敌人拉至张辽身边，造成16倍物理防御的物理伤害，并震晕3.2秒。",
	"将150范围内的敌人拉至张辽身边，造成17倍物理防御的物理伤害，并震晕3.4秒。",
	"将150范围内的敌人拉至张辽身边，造成18倍物理防御的物理伤害，并震晕3.6秒。",
	"将150范围内的敌人拉至张辽身边，造成19倍物理防御的物理伤害，并震晕3.8秒。",
	"将150范围内的敌人拉至张辽身边，造成20倍物理防御的物理伤害，并震晕4秒。",
}


_tab_stringS[14051] = {"裸衣",
	"对自身200范围内的敌人造成攻击力100％的物理伤害，并爆衣出阵，将自己的物理防御降为0点。失去的每1点物理防御，都会转化为增加自身0.1点攻击力，和降低敌人0.1点物理防御，持续15秒。",
	"对自身200范围内的敌人造成攻击力100％的物理伤害，并爆衣出阵，将自己的物理防御降为0点。失去的每1点物理防御，都会转化为增加自身0.2点攻击力，和降低敌人0.2点物理防御，持续15秒。",
	"对自身200范围内的敌人造成攻击力100％的物理伤害，并爆衣出阵，将自己的物理防御降为0点。失去的每1点物理防御，都会转化为增加自身0.3点攻击力，和降低敌人0.3点物理防御，持续15秒。",
	"对自身200范围内的敌人造成攻击力100％的物理伤害，并爆衣出阵，将自己的物理防御降为0点。失去的每1点物理防御，都会转化为增加自身0.4点攻击力，和降低敌人0.4点物理防御，持续15秒。",
	"对自身200范围内的敌人造成攻击力100％的物理伤害，并爆衣出阵，将自己的物理防御降为0点。失去的每1点物理防御，都会转化为增加自身0.5点攻击力，和降低敌人0.5点物理防御，持续15秒。",
	"对自身200范围内的敌人造成攻击力100％的物理伤害，并爆衣出阵，将自己的物理防御降为0点。失去的每1点物理防御，都会转化为增加自身0.6点攻击力，和降低敌人0.6点物理防御，持续15秒。",
	"对自身200范围内的敌人造成攻击力100％的物理伤害，并爆衣出阵，将自己的物理防御降为0点。失去的每1点物理防御，都会转化为增加自身0.7点攻击力，和降低敌人0.7点物理防御，持续15秒。",
	"对自身200范围内的敌人造成攻击力100％的物理伤害，并爆衣出阵，将自己的物理防御降为0点。失去的每1点物理防御，都会转化为增加自身0.8点攻击力，和降低敌人0.8点物理防御，持续15秒。",
	"对自身200范围内的敌人造成攻击力100％的物理伤害，并爆衣出阵，将自己的物理防御降为0点。失去的每1点物理防御，都会转化为增加自身0.9点攻击力，和降低敌人0.9点物理防御，持续15秒。",
	"对自身200范围内的敌人造成攻击力100％的物理伤害，并爆衣出阵，将自己的物理防御降为0点。失去的每1点物理防御，都会转化为增加自身1点攻击力，和降低敌人1点物理防御，持续15秒。",
	"对自身200范围内的敌人造成攻击力100％的物理伤害，并爆衣出阵，将自己的物理防御降为0点。失去的每1点物理防御，都会转化为增加自身1.1点攻击力，和降低敌人1.1点物理防御，持续15秒。",
	"对自身200范围内的敌人造成攻击力100％的物理伤害，并爆衣出阵，将自己的物理防御降为0点。失去的每1点物理防御，都会转化为增加自身1.2点攻击力，和降低敌人1.2点物理防御，持续15秒。",
	"对自身200范围内的敌人造成攻击力100％的物理伤害，并爆衣出阵，将自己的物理防御降为0点。失去的每1点物理防御，都会转化为增加自身1.3点攻击力，和降低敌人1.3点物理防御，持续15秒。",
	"对自身200范围内的敌人造成攻击力100％的物理伤害，并爆衣出阵，将自己的物理防御降为0点。失去的每1点物理防御，都会转化为增加自身1.4点攻击力，和降低敌人1.4点物理防御，持续15秒。",
	"对自身200范围内的敌人造成攻击力100％的物理伤害，并爆衣出阵，将自己的物理防御降为0点。失去的每1点物理防御，都会转化为增加自身1.5点攻击力，和降低敌人1.5点物理防御，持续15秒。",
}

_tab_stringS[14054] = {"血煞",
	"拼死血战，消耗自己所有生命值，同时提升68％的攻击速度和16％的吸血，持续9秒。在此期间典韦不会死亡，生命值最低为1点。",
	"拼死血战，消耗自己所有生命值，同时提升76％的攻击速度和17％的吸血，持续9秒。在此期间典韦不会死亡，生命值最低为1点。",
	"拼死血战，消耗自己所有生命值，同时提升84％的攻击速度和18％的吸血，持续9秒。在此期间典韦不会死亡，生命值最低为1点。",
	"拼死血战，消耗自己所有生命值，同时提升92％的攻击速度和19％的吸血，持续9秒。在此期间典韦不会死亡，生命值最低为1点。",
	"拼死血战，消耗自己所有生命值，同时提升100％的攻击速度和20％的吸血，持续9秒。在此期间典韦不会死亡，生命值最低为1点。",
	"拼死血战，消耗自己所有生命值，同时提升108％的攻击速度和21％的吸血，持续9秒。在此期间典韦不会死亡，生命值最低为1点。",
	"拼死血战，消耗自己所有生命值，同时提升116％的攻击速度和22％的吸血，持续9秒。在此期间典韦不会死亡，生命值最低为1点。",
	"拼死血战，消耗自己所有生命值，同时提升124％的攻击速度和23％的吸血，持续9秒。在此期间典韦不会死亡，生命值最低为1点。",
	"拼死血战，消耗自己所有生命值，同时提升132％的攻击速度和24％的吸血，持续9秒。在此期间典韦不会死亡，生命值最低为1点。",
	"拼死血战，消耗自己所有生命值，同时提升140％的攻击速度和25％的吸血，持续9秒。在此期间典韦不会死亡，生命值最低为1点。",
	"拼死血战，消耗自己所有生命值，同时提升148％的攻击速度和26％的吸血，持续9秒。在此期间典韦不会死亡，生命值最低为1点。",
	"拼死血战，消耗自己所有生命值，同时提升156％的攻击速度和27％的吸血，持续9秒。在此期间典韦不会死亡，生命值最低为1点。",
	"拼死血战，消耗自己所有生命值，同时提升164％的攻击速度和28％的吸血，持续9秒。在此期间典韦不会死亡，生命值最低为1点。",
	"拼死血战，消耗自己所有生命值，同时提升172％的攻击速度和29％的吸血，持续9秒。在此期间典韦不会死亡，生命值最低为1点。",
	"拼死血战，消耗自己所有生命值，同时提升180％的攻击速度和30％的吸血，持续9秒。在此期间典韦不会死亡，生命值最低为1点。",
}

_tab_stringS[14076] = {"机关弩炮",
	"放置2台240点生命、15-24点攻击力、300码射程、20点物理防御、-60点法术防御的机关弩炮为你战斗。机关弩炮附加黄月英20％的攻击力。机关弩炮存在20秒。\n（施法范围：400）",
	"放置2台360点生命、20-32点攻击力、300码射程、25点物理防御、-60点法术防御的机关弩炮为你战斗。机关弩炮附加黄月英20％的攻击力。机关弩炮存在20秒。\n（施法范围：400）",
	"放置2台480点生命、25-40点攻击力、300码射程、30点物理防御、-60点法术防御的机关弩炮为你战斗。机关弩炮附加黄月英20％的攻击力。机关弩炮存在20秒。\n（施法范围：400）",
	"放置2台600点生命、30-48点攻击力、300码射程、35点物理防御、-60点法术防御的机关弩炮为你战斗。机关弩炮附加黄月英20％的攻击力。机关弩炮存在20秒。\n（施法范围：400）",
	"放置2台720点生命、35-56点攻击力、300码射程、40点物理防御、-60点法术防御的机关弩炮为你战斗。机关弩炮附加黄月英20％的攻击力。机关弩炮存在20秒。\n（施法范围：400）",
	"放置2台840点生命、40-64点攻击力、300码射程、45点物理防御、-60点法术防御的机关弩炮为你战斗。机关弩炮附加黄月英20％的攻击力。机关弩炮存在20秒。\n（施法范围：400）",
	"放置2台960点生命、45-72点攻击力、300码射程、50点物理防御、-60点法术防御的机关弩炮为你战斗。机关弩炮附加黄月英20％的攻击力。机关弩炮存在20秒。\n（施法范围：400）",
	"放置2台1080点生命、50-80点攻击力、300码射程、55点物理防御、-60点法术防御的机关弩炮为你战斗。机关弩炮附加黄月英20％的攻击力。机关弩炮存在20秒。\n（施法范围：400）",
	"放置2台1200点生命、55-88点攻击力、300码射程、60点物理防御、-60点法术防御的机关弩炮为你战斗。机关弩炮附加黄月英20％的攻击力。机关弩炮存在20秒。\n（施法范围：400）",
	"放置2台1320点生命、60-96点攻击力、300码射程、65点物理防御、-60点法术防御的机关弩炮为你战斗。机关弩炮附加黄月英20％的攻击力。机关弩炮存在20秒。\n（施法范围：400）",
	"放置2台1440点生命、65-104点攻击力、300码射程、70点物理防御、-60点法术防御的机关弩炮为你战斗。机关弩炮附加黄月英20％的攻击力。机关弩炮存在20秒。\n（施法范围：400）",
	"放置2台1560点生命、70-112点攻击力、300码射程、75点物理防御、-60点法术防御的机关弩炮为你战斗。机关弩炮附加黄月英20％的攻击力。机关弩炮存在20秒。\n（施法范围：400）",
	"放置2台1680点生命、75-120点攻击力、300码射程、80点物理防御、-60点法术防御的机关弩炮为你战斗。机关弩炮附加黄月英20％的攻击力。机关弩炮存在20秒。\n（施法范围：400）",
	"放置2台1800点生命、80-128点攻击力、300码射程、85点物理防御、-60点法术防御的机关弩炮为你战斗。机关弩炮附加黄月英20％的攻击力。机关弩炮存在20秒。\n（施法范围：400）",
	"放置2台1920点生命、85-136点攻击力、300码射程、90点物理防御、-60点法术防御的机关弩炮为你战斗。机关弩炮附加黄月英20％的攻击力。机关弩炮存在20秒。\n（施法范围：400）",
}

_tab_stringS[14077] = {"血浴",
	"在身边制造一个血池，对处在血池中的敌人每秒造成董卓最大生命值8％的真实伤害，对处在血池中的自己和友军每秒恢复2.2％生命值。血池持续15秒。",
	"在身边制造一个血池，对处在血池中的敌人每秒造成董卓最大生命值8.5％的真实伤害，对处在血池中的自己和友军每秒恢复2.4％点生命值。血池持续15秒。",
	"在身边制造一个血池，对处在血池中的敌人每秒造成董卓最大生命值9％的真实伤害，对处在血池中的自己和友军每秒恢复2.6％生命值。血池持续15秒。",
	"在身边制造一个血池，对处在血池中的敌人每秒造成董卓最大生命值9.5％的真实伤害，对处在血池中的自己和友军每秒恢复2.8％生命值。血池持续15秒。",
	"在身边制造一个血池，对处在血池中的敌人每秒造成董卓最大生命值10％的真实伤害，对处在血池中的自己和友军每秒恢复3％点生命值。血池持续15秒。",
	"在身边制造一个血池，对处在血池中的敌人每秒造成董卓最大生命值10.5％的真实伤害，对处在血池中的自己和友军每秒恢复3.2％生命值。血池持续15秒。",
	"在身边制造一个血池，对处在血池中的敌人每秒造成董卓最大生命值11％的真实伤害，对处在血池中的自己和友军每秒恢复3.4％生命值。血池持续15秒。",
	"在身边制造一个血池，对处在血池中的敌人每秒造成董卓最大生命值11.5％的真实伤害，对处在血池中的自己和友军每秒恢复3.6％生命值。血池持续15秒。",
	"在身边制造一个血池，对处在血池中的敌人每秒造成董卓最大生命值12％的真实伤害，对处在血池中的自己和友军每秒恢复3.8％生命值。血池持续15秒。",
	"在身边制造一个血池，对处在血池中的敌人每秒造成董卓最大生命值12.5％的真实伤害，对处在血池中的自己和友军每秒恢复4％生命值。血池持续15秒。",
	"在身边制造一个血池，对处在血池中的敌人每秒造成董卓最大生命值13％的真实伤害，对处在血池中的自己和友军每秒恢复4.2％生命值。血池持续15秒。",
	"在身边制造一个血池，对处在血池中的敌人每秒造成董卓最大生命值13.5％的真实伤害，对处在血池中的自己和友军每秒恢复4.4％生命值。血池持续15秒。",
	"在身边制造一个血池，对处在血池中的敌人每秒造成董卓最大生命值14％的真实伤害，对处在血池中的自己和友军每秒恢复4.6％生命值。血池持续15秒。",
	"在身边制造一个血池，对处在血池中的敌人每秒造成董卓最大生命值14.5％的真实伤害，对处在血池中的自己和友军每秒恢复4.8％生命值。血池持续15秒。",
	"在身边制造一个血池，对处在血池中的敌人每秒造成董卓最大生命值15％的真实伤害，对处在血池中的自己和友军每秒恢复5％生命值。血池持续15秒。",
}

_tab_stringS[14078] = {"圣者领域",
	"在目标地点召唤一个领域，持续将110范围内的敌人推出领域，并每秒对敌人造成攻击力200％+100点的法术伤害，持续5.2秒。\n（施法范围：240）",
	"在目标地点召唤一个领域，持续将110范围内的敌人推出领域，并每秒对敌人造成攻击力200％+110点的法术伤害，持续5.4秒。\n（施法范围：240）",
	"在目标地点召唤一个领域，持续将110范围内的敌人推出领域，并每秒对敌人造成攻击力200％+120点的法术伤害，持续5.6秒。\n（施法范围：240）",
	"在目标地点召唤一个领域，持续将110范围内的敌人推出领域，并每秒对敌人造成攻击力200％+130点的法术伤害，持续5.8秒。\n（施法范围：240）",
	"在目标地点召唤一个领域，持续将110范围内的敌人推出领域，并每秒对敌人造成攻击力200％+140点的法术伤害，持续6秒。\n（施法范围：240）",
	"在目标地点召唤一个领域，持续将110范围内的敌人推出领域，并每秒对敌人造成攻击力200％+150点的法术伤害，持续6.2秒。\n（施法范围：240）",
	"在目标地点召唤一个领域，持续将110范围内的敌人推出领域，并每秒对敌人造成攻击力200％+160点的法术伤害，持续6.4秒。\n（施法范围：240）",
	"在目标地点召唤一个领域，持续将110范围内的敌人推出领域，并每秒对敌人造成攻击力200％+170点的法术伤害，持续6.6秒。\n（施法范围：240）",
	"在目标地点召唤一个领域，持续将110范围内的敌人推出领域，并每秒对敌人造成攻击力200％+180点的法术伤害，持续6.8秒。\n（施法范围：240）",
	"在目标地点召唤一个领域，持续将110范围内的敌人推出领域，并每秒对敌人造成攻击力200％+190点的法术伤害，持续7秒。\n（施法范围：240）",
	"在目标地点召唤一个领域，持续将110范围内的敌人推出领域，并每秒对敌人造成攻击力200％+200点的法术伤害，持续7.2秒。\n（施法范围：240）",
	"在目标地点召唤一个领域，持续将110范围内的敌人推出领域，并每秒对敌人造成攻击力200％+210点的法术伤害，持续7.4秒。\n（施法范围：240）",
	"在目标地点召唤一个领域，持续将110范围内的敌人推出领域，并每秒对敌人造成攻击力200％+220点的法术伤害，持续7.6秒。\n（施法范围：240）",
	"在目标地点召唤一个领域，持续将110范围内的敌人推出领域，并每秒对敌人造成攻击力200％+230点的法术伤害，持续7.8秒。\n（施法范围：240）",
	"在目标地点召唤一个领域，持续将110范围内的敌人推出领域，并每秒对敌人造成攻击力200％+240点的法术伤害，持续8秒。\n（施法范围：240）",
}


_tab_stringS[14081] = {"火焰旋风",
	"在目标地点召唤一个火焰旋风，每秒对75范围内的敌人造成攻击力120％点的法术伤害，持续20秒。\n（施法范围：240）",
	"在目标地点召唤一个火焰旋风，每秒对75范围内的敌人造成攻击力140％点的法术伤害，持续20秒。\n（施法范围：240）",
	"在目标地点召唤一个火焰旋风，每秒对75范围内的敌人造成攻击力160％点的法术伤害，持续20秒。\n（施法范围：240）",
	"在目标地点召唤一个火焰旋风，每秒对75范围内的敌人造成攻击力180％点的法术伤害，持续20秒。\n（施法范围：240）",
	"在目标地点召唤一个火焰旋风，每秒对75范围内的敌人造成攻击力200％点的法术伤害，持续20秒。\n（施法范围：240）",
	"在目标地点召唤一个火焰旋风，每秒对75范围内的敌人造成攻击力220％点的法术伤害，持续20秒。\n（施法范围：240）",
	"在目标地点召唤一个火焰旋风，每秒对75范围内的敌人造成攻击力240％点的法术伤害，持续20秒。\n（施法范围：240）",
	"在目标地点召唤一个火焰旋风，每秒对75范围内的敌人造成攻击力260％点的法术伤害，持续20秒。\n（施法范围：240）",
	"在目标地点召唤一个火焰旋风，每秒对75范围内的敌人造成攻击力280％点的法术伤害，持续20秒。\n（施法范围：240）",
	"在目标地点召唤一个火焰旋风，每秒对75范围内的敌人造成攻击力300％点的法术伤害，持续20秒。\n（施法范围：240）",
	"在目标地点召唤一个火焰旋风，每秒对75范围内的敌人造成攻击力320％点的法术伤害，持续20秒。\n（施法范围：240）",
	"在目标地点召唤一个火焰旋风，每秒对75范围内的敌人造成攻击力340％点的法术伤害，持续20秒。\n（施法范围：240）",
	"在目标地点召唤一个火焰旋风，每秒对75范围内的敌人造成攻击力360％点的法术伤害，持续20秒。\n（施法范围：240）",
	"在目标地点召唤一个火焰旋风，每秒对75范围内的敌人造成攻击力380％点的法术伤害，持续20秒。\n（施法范围：240）",
	"在目标地点召唤一个火焰旋风，每秒对75范围内的敌人造成攻击力400％点的法术伤害，持续20秒。\n（施法范围：240）",
}

_tab_stringS[14083] = {"如影随形",
	"施展鬼魅般的身法，提升48％攻击速度、30％移动速度、20％物理和法术闪避，并使普通攻击必定触发闪击，持续12秒。",
	"施展鬼魅般的身法，提升56％攻击速度、33％移动速度、22％物理和法术闪避，并使普通攻击必定触发闪击，持续12秒。",
	"施展鬼魅般的身法，提升64％攻击速度、36％移动速度、24％物理和法术闪避，并使普通攻击必定触发闪击，持续12秒。",
	"施展鬼魅般的身法，提升72％攻击速度、39％移动速度、26％物理和法术闪避，并使普通攻击必定触发闪击，持续12秒。",
	"施展鬼魅般的身法，提升80％攻击速度、42％移动速度、28％物理和法术闪避，并使普通攻击必定触发闪击，持续12秒。",
	"施展鬼魅般的身法，提升88％攻击速度、45％移动速度、30％物理和法术闪避，并使普通攻击必定触发闪击，持续12秒。",
	"施展鬼魅般的身法，提升96％攻击速度、48％移动速度、32％物理和法术闪避，并使普通攻击必定触发闪击，持续12秒。",
	"施展鬼魅般的身法，提升104％攻击速度、51％移动速度、34％物理和法术闪避，并使普通攻击必定触发闪击，持续12秒。",
	"施展鬼魅般的身法，提升112％攻击速度、54％移动速度、36％物理和法术闪避，并使普通攻击必定触发闪击，持续12秒。",
	"施展鬼魅般的身法，提升120％攻击速度、57％移动速度、38％物理和法术闪避，并使普通攻击必定触发闪击，持续12秒。",
	"施展鬼魅般的身法，提升128％攻击速度、60％移动速度、40％物理和法术闪避，并使普通攻击必定触发闪击，持续12秒。",
	"施展鬼魅般的身法，提升136％攻击速度、63％移动速度、42％物理和法术闪避，并使普通攻击必定触发闪击，持续12秒。",
	"施展鬼魅般的身法，提升144％攻击速度、66％移动速度、44％物理和法术闪避，并使普通攻击必定触发闪击，持续12秒。",
	"施展鬼魅般的身法，提升152％攻击速度、69％移动速度、46％物理和法术闪避，并使普通攻击必定触发闪击，持续12秒。",
	"施展鬼魅般的身法，提升160％攻击速度、72％移动速度、48％物理和法术闪避，并使普通攻击必定触发闪击，持续12秒。",
}


_tab_stringS[14089] = {"箭术心得",
	"永久增加8点射程，使散射增加1支箭，百步穿杨伤害增加120％",
	"永久增加10点射程，使散射增加1支箭，百步穿杨伤害增加140％",
	"永久增加12点射程，使散射增加1支箭，百步穿杨伤害增加160％",
	"永久增加14点射程，使散射增加1支箭，百步穿杨伤害增加180％",
	"永久增加16点射程，使散射增加1支箭，百步穿杨伤害增加200％",
	"永久增加18点射程，使散射增加2支箭，百步穿杨伤害增加220％",
	"永久增加20点射程，使散射增加2支箭，百步穿杨伤害增加240％",
	"永久增加22点射程，使散射增加2支箭，百步穿杨伤害增加260％",
	"永久增加24点射程，使散射增加2支箭，百步穿杨伤害增加280％",
	"永久增加26点射程，使散射增加2支箭，百步穿杨伤害增加300％",
	"永久增加28点射程，使散射增加2支箭，百步穿杨伤害增加320％",
	"永久增加30点射程，使散射增加3支箭，百步穿杨伤害增加340％",
	"永久增加32点射程，使散射增加3支箭，百步穿杨伤害增加360％",
	"永久增加34点射程，使散射增加3支箭，百步穿杨伤害增加380％",
	"永久增加36点射程，使散射增加3支箭，百步穿杨伤害增加400％",
}

_tab_stringS[14090] = {"百步穿杨",
	"蓄力，并射出强力的一箭，对一直线上的敌人造成360％的伤害。",
	"蓄力，并射出强力的一箭，对一直线上的敌人造成420％的伤害。",
	"蓄力，并射出强力的一箭，对一直线上的敌人造成480％的伤害。",
	"蓄力，并射出强力的一箭，对一直线上的敌人造成540％的伤害。",
	"蓄力，并射出强力的一箭，对一直线上的敌人造成600％的伤害。",
	"蓄力，并射出强力的一箭，对一直线上的敌人造成660％的伤害。",
	"蓄力，并射出强力的一箭，对一直线上的敌人造成720％的伤害。",
	"蓄力，并射出强力的一箭，对一直线上的敌人造成780％的伤害。",
	"蓄力，并射出强力的一箭，对一直线上的敌人造成840％的伤害。",
	"蓄力，并射出强力的一箭，对一直线上的敌人造成900％的伤害。",
	"蓄力，并射出强力的一箭，对一直线上的敌人造成960％的伤害。",
	"蓄力，并射出强力的一箭，对一直线上的敌人造成1020％的伤害。",
	"蓄力，并射出强力的一箭，对一直线上的敌人造成1080％的伤害。",
	"蓄力，并射出强力的一箭，对一直线上的敌人造成1140％的伤害。",
	"蓄力，并射出强力的一箭，对一直线上的敌人造成1200％的伤害。",
}

_tab_stringS[14091] = {"散射",
	"普通攻击有15％概率发射6支箭，每支箭造成24％的范围伤害。",
	"普通攻击有15％概率发射6支箭，每支箭造成26％的范围伤害。",
	"普通攻击有15％概率发射6支箭，每支箭造成28％的范围伤害。",
	"普通攻击有15％概率发射6支箭，每支箭造成30％的范围伤害。",
	"普通攻击有15％概率发射6支箭，每支箭造成32％的范围伤害。",
	"普通攻击有15％概率发射6支箭，每支箭造成34％的范围伤害。",
	"普通攻击有15％概率发射6支箭，每支箭造成36％的范围伤害。",
	"普通攻击有15％概率发射6支箭，每支箭造成38％的范围伤害。",
	"普通攻击有15％概率发射6支箭，每支箭造成40％的范围伤害。",
	"普通攻击有15％概率发射6支箭，每支箭造成42％的范围伤害。",
	"普通攻击有15％概率发射6支箭，每支箭造成44％的范围伤害。",
	"普通攻击有15％概率发射6支箭，每支箭造成46％的范围伤害。",
	"普通攻击有15％概率发射6支箭，每支箭造成48％的范围伤害。",
	"普通攻击有15％概率发射6支箭，每支箭造成50％的范围伤害。",
	"普通攻击有15％概率发射6支箭，每支箭造成52％的范围伤害。",
}

_tab_stringS[14095] = {"闪电奔袭",
	"向目标地点冲刺，对沿途的敌人造成120％伤害，将其击退并击晕0.5秒。每2点移动速度额外增加此技能1％伤害。",
	"向目标地点冲刺，对沿途的敌人造成130％伤害，将其击退并击晕0.5秒。每2点移动速度额外增加此技能1％伤害。",
	"向目标地点冲刺，对沿途的敌人造成140％伤害，将其击退并击晕0.5秒。每2点移动速度额外增加此技能1％伤害。",
	"向目标地点冲刺，对沿途的敌人造成150％伤害，将其击退并击晕0.5秒。每2点移动速度额外增加此技能1％伤害。",
	"向目标地点冲刺，对沿途的敌人造成160％伤害，将其击退并击晕0.5秒。每2点移动速度额外增加此技能1％伤害。",
	"向目标地点冲刺，对沿途的敌人造成170％伤害，将其击退并击晕0.5秒。每2点移动速度额外增加此技能1％伤害。",
	"向目标地点冲刺，对沿途的敌人造成180％伤害，将其击退并击晕0.5秒。每2点移动速度额外增加此技能1％伤害。",
	"向目标地点冲刺，对沿途的敌人造成190％伤害，将其击退并击晕0.5秒。每2点移动速度额外增加此技能1％伤害。",
	"向目标地点冲刺，对沿途的敌人造成200％伤害，将其击退并击晕0.5秒。每2点移动速度额外增加此技能1％伤害。",
	"向目标地点冲刺，对沿途的敌人造成210％伤害，将其击退并击晕0.5秒。每2点移动速度额外增加此技能1％伤害。",
	"向目标地点冲刺，对沿途的敌人造成220％伤害，将其击退并击晕0.5秒。每2点移动速度额外增加此技能1％伤害。",
	"向目标地点冲刺，对沿途的敌人造成230％伤害，将其击退并击晕0.5秒。每2点移动速度额外增加此技能1％伤害。",
	"向目标地点冲刺，对沿途的敌人造成240％伤害，将其击退并击晕0.5秒。每2点移动速度额外增加此技能1％伤害。",
	"向目标地点冲刺，对沿途的敌人造成250％伤害，将其击退并击晕0.5秒。每2点移动速度额外增加此技能1％伤害。",
	"向目标地点冲刺，对沿途的敌人造成260％伤害，将其击退并击晕0.5秒。每2点移动速度额外增加此技能1％伤害。",
}


_tab_stringS[14098] = {"突击",
	"向前突进，对前方敌人造成50％伤害，将敌人击退并击晕0.5秒。每5点移动速度额外增加此技能1％伤害。",
	"向前突进，对前方敌人造成55％伤害，将敌人击退并击晕0.5秒。每5点移动速度额外增加此技能1％伤害。",
	"向前突进，对前方敌人造成60％伤害，将敌人击退并击晕0.5秒。每5点移动速度额外增加此技能1％伤害。",
	"向前突进，对前方敌人造成65％伤害，将敌人击退并击晕0.5秒。每5点移动速度额外增加此技能1％伤害。",
	"向前突进，对前方敌人造成70％伤害，将敌人击退并击晕0.5秒。每5点移动速度额外增加此技能1％伤害。",
	"向前突进，对前方敌人造成75％伤害，将敌人击退并击晕0.5秒。每5点移动速度额外增加此技能1％伤害。",
	"向前突进，对前方敌人造成80％伤害，将敌人击退并击晕0.5秒。每5点移动速度额外增加此技能1％伤害。",
	"向前突进，对前方敌人造成85％伤害，将敌人击退并击晕0.5秒。每5点移动速度额外增加此技能1％伤害。",
	"向前突进，对前方敌人造成90％伤害，将敌人击退并击晕0.5秒。每5点移动速度额外增加此技能1％伤害。",
	"向前突进，对前方敌人造成95％伤害，将敌人击退并击晕0.5秒。每5点移动速度额外增加此技能1％伤害。",
	"向前突进，对前方敌人造成100％伤害，将敌人击退并击晕0.5秒。每5点移动速度额外增加此技能1％伤害。",
	"向前突进，对前方敌人造成105％伤害，将敌人击退并击晕0.5秒。每5点移动速度额外增加此技能1％伤害。",
	"向前突进，对前方敌人造成110％伤害，将敌人击退并击晕0.5秒。每5点移动速度额外增加此技能1％伤害。",
	"向前突进，对前方敌人造成115％伤害，将敌人击退并击晕0.5秒。每5点移动速度额外增加此技能1％伤害。",
	"向前突进，对前方敌人造成120％伤害，将敌人击退并击晕0.5秒。每5点移动速度额外增加此技能1％伤害。",
}


_tab_stringS[14099] = {"铁骑",
	"永久增加22％移动速度，并提升突击和闪电奔袭35%的伤害。",
	"永久增加24％移动速度，并提升突击和闪电奔袭35%的伤害。",
	"永久增加26％移动速度，并提升突击和闪电奔袭35%的伤害。",
	"永久增加28％移动速度，并提升突击和闪电奔袭35%的伤害。",
	"永久增加30％移动速度，并提升突击和闪电奔袭35%的伤害。",
	"永久增加32％移动速度，并提升突击和闪电奔袭35%的伤害。",
	"永久增加34％移动速度，并提升突击和闪电奔袭35%的伤害。",
	"永久增加36％移动速度，并提升突击和闪电奔袭35%的伤害。",
	"永久增加38％移动速度，并提升突击和闪电奔袭35%的伤害。",
	"永久增加40％移动速度，并提升突击和闪电奔袭35%的伤害。",
	"永久增加42％移动速度，并提升突击和闪电奔袭35%的伤害。",
	"永久增加44％移动速度，并提升突击和闪电奔袭35%的伤害。",
	"永久增加46％移动速度，并提升突击和闪电奔袭35%的伤害。",
	"永久增加48％移动速度，并提升突击和闪电奔袭35%的伤害。",
	"永久增加50％移动速度，并提升突击和闪电奔袭35%的伤害。",
}

_tab_stringS[14100] = {"困兽犹斗",
	"提升24点物理防御和法术防御，并获得等同物理防御的攻击力，持续20秒。",
	"提升26点物理防御和法术防御，并获得等同物理防御的攻击力，持续20秒。",
	"提升28点物理防御和法术防御，并获得等同物理防御的攻击力，持续20秒。",
	"提升30点物理防御和法术防御，并获得等同物理防御的攻击力，持续20秒。",
	"提升32点物理防御和法术防御，并获得等同物理防御的攻击力，持续20秒。",
	"提升34点物理防御和法术防御，并获得等同物理防御的攻击力，持续20秒。",
	"提升36点物理防御和法术防御，并获得等同物理防御的攻击力，持续20秒。",
	"提升38点物理防御和法术防御，并获得等同物理防御的攻击力，持续20秒。",
	"提升40点物理防御和法术防御，并获得等同物理防御的攻击力，持续20秒。",
	"提升42点物理防御和法术防御，并获得等同物理防御的攻击力，持续20秒。",
	"提升44点物理防御和法术防御，并获得等同物理防御的攻击力，持续20秒。",
	"提升46点物理防御和法术防御，并获得等同物理防御的攻击力，持续20秒。",
	"提升48点物理防御和法术防御，并获得等同物理防御的攻击力，持续20秒。",
	"提升50点物理防御和法术防御，并获得等同物理防御的攻击力，持续20秒。",
	"提升52点物理防御和法术防御，并获得等同物理防御的攻击力，持续20秒。",
}
_tab_stringS[14102] = {"处决",
	"发动强力一击，对目标造成150％物理伤害，如果目标生命值低于40％，则造成5倍伤害。",
	"发动强力一击，对目标造成165％物理伤害，如果目标生命值低于40％，则造成5倍伤害。",
	"发动强力一击，对目标造成180％物理伤害，如果目标生命值低于40％，则造成5倍伤害。",
	"发动强力一击，对目标造成195％物理伤害，如果目标生命值低于40％，则造成5倍伤害。",
	"发动强力一击，对目标造成210％物理伤害，如果目标生命值低于40％，则造成5倍伤害。",
	"发动强力一击，对目标造成225％物理伤害，如果目标生命值低于40％，则造成5倍伤害。",
	"发动强力一击，对目标造成240％物理伤害，如果目标生命值低于40％，则造成5倍伤害。",
	"发动强力一击，对目标造成255％物理伤害，如果目标生命值低于40％，则造成5倍伤害。",
	"发动强力一击，对目标造成270％物理伤害，如果目标生命值低于40％，则造成5倍伤害。",
	"发动强力一击，对目标造成285％物理伤害，如果目标生命值低于40％，则造成5倍伤害。",
	"发动强力一击，对目标造成300％物理伤害，如果目标生命值低于40％，则造成5倍伤害。",
	"发动强力一击，对目标造成315％物理伤害，如果目标生命值低于40％，则造成5倍伤害。",
	"发动强力一击，对目标造成330％物理伤害，如果目标生命值低于40％，则造成5倍伤害。",
	"发动强力一击，对目标造成345％物理伤害，如果目标生命值低于40％，则造成5倍伤害。",
	"发动强力一击，对目标造成360％物理伤害，如果目标生命值低于40％，则造成5倍伤害。",
}

_tab_stringS[14103] = {"不屈",
	"永久增加8点回血，自身生命值低于30％时，获得双倍治疗效果。",
	"永久增加10点回血，自身生命值低于30％时，获得双倍治疗效果。",
	"永久增加12点回血，自身生命值低于30％时，获得双倍治疗效果。",
	"永久增加14点回血，自身生命值低于30％时，获得双倍治疗效果。",
	"永久增加16点回血，自身生命值低于30％时，获得双倍治疗效果。",
	"永久增加18点回血，自身生命值低于30％时，获得双倍治疗效果。",
	"永久增加20点回血，自身生命值低于30％时，获得双倍治疗效果。",
	"永久增加22点回血，自身生命值低于30％时，获得双倍治疗效果。",
	"永久增加24点回血，自身生命值低于30％时，获得双倍治疗效果。",
	"永久增加26点回血，自身生命值低于30％时，获得双倍治疗效果。",
	"永久增加28点回血，自身生命值低于30％时，获得双倍治疗效果。",
	"永久增加30点回血，自身生命值低于30％时，获得双倍治疗效果。",
	"永久增加32点回血，自身生命值低于30％时，获得双倍治疗效果。",
	"永久增加34点回血，自身生命值低于30％时，获得双倍治疗效果。",
	"永久增加36点回血，自身生命值低于30％时，获得双倍治疗效果。",
}


_tab_stringS[14109] = {"慧剑",
	"每次攻击使星罗剑阵冷却缩短0.5秒；并随机召唤1~3把飞剑攻击附近敌人，每把飞剑对一直线上的敌人造成12％物理伤害。",
	"每次攻击使星罗剑阵冷却缩短0.5秒；并随机召唤1~3把飞剑攻击附近敌人，每把飞剑对一直线上的敌人造成14％物理伤害。",
	"每次攻击使星罗剑阵冷却缩短0.5秒；并随机召唤1~3把飞剑攻击附近敌人，每把飞剑对一直线上的敌人造成16％物理伤害。",
	"每次攻击使星罗剑阵冷却缩短0.5秒；并随机召唤1~3把飞剑攻击附近敌人，每把飞剑对一直线上的敌人造成18％物理伤害。",
	"每次攻击使星罗剑阵冷却缩短0.5秒；并随机召唤1~3把飞剑攻击附近敌人，每把飞剑对一直线上的敌人造成20％物理伤害。",
	"每次攻击使星罗剑阵冷却缩短0.5秒；并随机召唤1~3把飞剑攻击附近敌人，每把飞剑对一直线上的敌人造成22％物理伤害。",
	"每次攻击使星罗剑阵冷却缩短0.5秒；并随机召唤1~3把飞剑攻击附近敌人，每把飞剑对一直线上的敌人造成24％物理伤害。",
	"每次攻击使星罗剑阵冷却缩短0.5秒；并随机召唤1~3把飞剑攻击附近敌人，每把飞剑对一直线上的敌人造成26％物理伤害。",
	"每次攻击使星罗剑阵冷却缩短0.5秒；并随机召唤1~3把飞剑攻击附近敌人，每把飞剑对一直线上的敌人造成28％物理伤害。",
	"每次攻击使星罗剑阵冷却缩短0.5秒；并随机召唤1~3把飞剑攻击附近敌人，每把飞剑对一直线上的敌人造成30％物理伤害。",
	"每次攻击使星罗剑阵冷却缩短0.5秒；并随机召唤1~3把飞剑攻击附近敌人，每把飞剑对一直线上的敌人造成32％物理伤害。",
	"每次攻击使星罗剑阵冷却缩短0.5秒；并随机召唤1~3把飞剑攻击附近敌人，每把飞剑对一直线上的敌人造成34％物理伤害。",
	"每次攻击使星罗剑阵冷却缩短0.5秒；并随机召唤1~3把飞剑攻击附近敌人，每把飞剑对一直线上的敌人造成36％物理伤害。",
	"每次攻击使星罗剑阵冷却缩短0.5秒；并随机召唤1~3把飞剑攻击附近敌人，每把飞剑对一直线上的敌人造成38％物理伤害。",
	"每次攻击使星罗剑阵冷却缩短0.5秒；并随机召唤1~3把飞剑攻击附近敌人，每把飞剑对一直线上的敌人造成40％物理伤害。",
}

_tab_stringS[14110] = {"烁金之体",
	"提升7点物理防御和法术防御，并且免疫控制，持续7秒。",
	"提升9点物理防御和法术防御，并且免疫控制，持续7秒。",
	"提升11点物理防御和法术防御，并且免疫控制，持续7秒。",
	"提升13点物理防御和法术防御，并且免疫控制，持续7秒。",
	"提升15点物理防御和法术防御，并且免疫控制，持续7秒。",
	"提升17点物理防御和法术防御，并且免疫控制，持续7秒。",
	"提升19点物理防御和法术防御，并且免疫控制，持续7秒。",
	"提升21点物理防御和法术防御，并且免疫控制，持续7秒。",
	"提升23点物理防御和法术防御，并且免疫控制，持续7秒。",
	"提升25点物理防御和法术防御，并且免疫控制，持续7秒。",
	"提升27点物理防御和法术防御，并且免疫控制，持续7秒。",
	"提升29点物理防御和法术防御，并且免疫控制，持续7秒。",
	"提升31点物理防御和法术防御，并且免疫控制，持续7秒。",
	"提升33点物理防御和法术防御，并且免疫控制，持续7秒。",
	"提升35点物理防御和法术防御，并且免疫控制，持续7秒。",
}

_tab_stringS[14112] = {"星罗剑阵",
	"在3秒内召唤大量飞剑，攻击附近的敌人，每把飞剑对一直线上的敌人造成12％物理伤害。",
	"在3秒内召唤大量飞剑，攻击附近的敌人，每把飞剑对一直线上的敌人造成14％物理伤害。",
	"在3秒内召唤大量飞剑，攻击附近的敌人，每把飞剑对一直线上的敌人造成16％物理伤害。",
	"在3秒内召唤大量飞剑，攻击附近的敌人，每把飞剑对一直线上的敌人造成18％物理伤害。",
	"在3秒内召唤大量飞剑，攻击附近的敌人，每把飞剑对一直线上的敌人造成20％物理伤害。",
	"在3秒内召唤大量飞剑，攻击附近的敌人，每把飞剑对一直线上的敌人造成22％物理伤害。",
	"在3秒内召唤大量飞剑，攻击附近的敌人，每把飞剑对一直线上的敌人造成24％物理伤害。",
	"在3秒内召唤大量飞剑，攻击附近的敌人，每把飞剑对一直线上的敌人造成26％物理伤害。",
	"在3秒内召唤大量飞剑，攻击附近的敌人，每把飞剑对一直线上的敌人造成28％物理伤害。",
	"在3秒内召唤大量飞剑，攻击附近的敌人，每把飞剑对一直线上的敌人造成30％物理伤害。",
	"在3秒内召唤大量飞剑，攻击附近的敌人，每把飞剑对一直线上的敌人造成32％物理伤害。",
	"在3秒内召唤大量飞剑，攻击附近的敌人，每把飞剑对一直线上的敌人造成34％物理伤害。",
	"在3秒内召唤大量飞剑，攻击附近的敌人，每把飞剑对一直线上的敌人造成36％物理伤害。",
	"在3秒内召唤大量飞剑，攻击附近的敌人，每把飞剑对一直线上的敌人造成38％物理伤害。",
	"在3秒内召唤大量飞剑，攻击附近的敌人，每把飞剑对一直线上的敌人造成40％物理伤害。",
}


_tab_stringS[14113] = {"召唤鬼将",
	"召唤一个600点生命、30-45点攻击力、9点物理防御和法术防御的鬼将为你战斗，鬼将附加20％司马懿的生命值和攻击力，存在30秒；鬼将会不停召唤鬼卒，鬼卒拥有35％鬼将的能力值，存在15秒。",
	"召唤一个900点生命、50-72点攻击力、12点物理防御和法术防御的鬼将为你战斗，鬼将附加25％司马懿的生命值和攻击力，存在30秒；鬼将会不停召唤鬼卒，鬼卒拥有35％鬼将的能力值，存在15秒。",
	"召唤一个1200点生命、70-99点攻击力、15点物理防御和法术防御的鬼将为你战斗，鬼将附加30％司马懿的生命值和攻击力，存在30秒；鬼将会不停召唤鬼卒，鬼卒拥有35％鬼将的能力值，存在15秒。",
	"召唤一个1500点生命、90-126点攻击力、18点物理防御和法术防御的鬼将为你战斗，鬼将附加35％司马懿的生命值和攻击力，存在30秒；鬼将会不停召唤鬼卒，鬼卒拥有35％鬼将的能力值，存在15秒。",
	"召唤一个1800点生命、110-153点攻击力、21点物理防御和法术防御的鬼将为你战斗，鬼将附加40％司马懿的生命值和攻击力，存在30秒；鬼将会不停召唤鬼卒，鬼卒拥有35％鬼将的能力值，存在15秒。",
	"召唤一个2100点生命、130-180点攻击力、24点物理防御和法术防御的鬼将为你战斗，鬼将附加45％司马懿的生命值和攻击力，存在30秒；鬼将会不停召唤鬼卒，鬼卒拥有35％鬼将的能力值，存在15秒。",
	"召唤一个2400点生命、150-207点攻击力、27点物理防御和法术防御的鬼将为你战斗，鬼将附加50％司马懿的生命值和攻击力，存在30秒；鬼将会不停召唤鬼卒，鬼卒拥有35％鬼将的能力值，存在15秒。",
	"召唤一个2700点生命、170-234点攻击力、30点物理防御和法术防御的鬼将为你战斗，鬼将附加55％司马懿的生命值和攻击力，存在30秒；鬼将会不停召唤鬼卒，鬼卒拥有35％鬼将的能力值，存在15秒。",
	"召唤一个3000点生命、190-261点攻击力、33点物理防御和法术防御的鬼将为你战斗，鬼将附加60％司马懿的生命值和攻击力，存在30秒；鬼将会不停召唤鬼卒，鬼卒拥有35％鬼将的能力值，存在15秒。",
	"召唤一个3300点生命、210-288点攻击力、36点物理防御和法术防御的鬼将为你战斗，鬼将附加65％司马懿的生命值和攻击力，存在30秒；鬼将会不停召唤鬼卒，鬼卒拥有35％鬼将的能力值，存在15秒。",
	"召唤一个3600点生命、230-315点攻击力、39点物理防御和法术防御的鬼将为你战斗，鬼将附加70％司马懿的生命值和攻击力，存在30秒；鬼将会不停召唤鬼卒，鬼卒拥有35％鬼将的能力值，存在15秒。",
	"召唤一个3900点生命、250-342点攻击力、42点物理防御和法术防御的鬼将为你战斗，鬼将附加75％司马懿的生命值和攻击力，存在30秒；鬼将会不停召唤鬼卒，鬼卒拥有35％鬼将的能力值，存在15秒。",
	"召唤一个4200点生命、270-369点攻击力、45点物理防御和法术防御的鬼将为你战斗，鬼将附加80％司马懿的生命值和攻击力，存在30秒；鬼将会不停召唤鬼卒，鬼卒拥有35％鬼将的能力值，存在15秒。",
	"召唤一个4500点生命、290-396点攻击力、48点物理防御和法术防御的鬼将为你战斗，鬼将附加85％司马懿的生命值和攻击力，存在30秒；鬼将会不停召唤鬼卒，鬼卒拥有35％鬼将的能力值，存在15秒。",
	"召唤一个4800点生命、310-423点攻击力、51点物理防御和法术防御的鬼将为你战斗，鬼将附加90％司马懿的生命值和攻击力，存在30秒；鬼将会不停召唤鬼卒，鬼卒拥有35％鬼将的能力值，存在15秒。",
}


_tab_stringS[14115] = {"妖术",
	"将目标区域50范围内的敌人变为小动物。被变身的单位不能攻击、释放技能，只能缓慢的移动，持续3.6秒（主将0.72秒）。",
	"将目标区域55范围内的敌人变为小动物。被变身的单位不能攻击、释放技能，只能缓慢的移动，持续3.7秒（主将0.74秒）。",
	"将目标区域60范围内的敌人变为小动物。被变身的单位不能攻击、释放技能，只能缓慢的移动，持续3.8秒（主将0.76秒）。",
	"将目标区域65范围内的敌人变为小动物。被变身的单位不能攻击、释放技能，只能缓慢的移动，持续3.9秒（主将0.78秒）。",
	"将目标区域70范围内的敌人变为小动物。被变身的单位不能攻击、释放技能，只能缓慢的移动，持续4秒（主将0.8秒）。",
	"将目标区域75范围内的敌人变为小动物。被变身的单位不能攻击、释放技能，只能缓慢的移动，持续4.1秒（主将0.82秒）。",
	"将目标区域80范围内的敌人变为小动物。被变身的单位不能攻击、释放技能，只能缓慢的移动，持续4.2秒（主将0.84秒）。",
	"将目标区域85范围内的敌人变为小动物。被变身的单位不能攻击、释放技能，只能缓慢的移动，持续4.3秒（主将0.86秒）。",
	"将目标区域90范围内的敌人变为小动物。被变身的单位不能攻击、释放技能，只能缓慢的移动，持续4.4秒（主将0.88秒）。",
	"将目标区域95范围内的敌人变为小动物。被变身的单位不能攻击、释放技能，只能缓慢的移动，持续4.5秒（主将0.9秒）。",
	"将目标区域100范围内的敌人变为小动物。被变身的单位不能攻击、释放技能，只能缓慢的移动，持续4.6秒（主将0.92秒）。",
	"将目标区域105范围内的敌人变为小动物。被变身的单位不能攻击、释放技能，只能缓慢的移动，持续4.7秒（主将0.94秒）。",
	"将目标区域110范围内的敌人变为小动物。被变身的单位不能攻击、释放技能，只能缓慢的移动，持续4.8秒（主将0.96秒）。",
	"将目标区域115范围内的敌人变为小动物。被变身的单位不能攻击、释放技能，只能缓慢的移动，持续4.9秒（主将0.98秒）。",
	"将目标区域120范围内的敌人变为小动物。被变身的单位不能攻击、释放技能，只能缓慢的移动，持续5秒（主将1秒）。",
}

_tab_stringS[14117] = {"召唤幽魂弓手",
	"召唤两个60点生命、12-18点攻击力、2点物理防御和法术防御的幽魂弓手为你战斗，幽魂弓手附加15％司马懿的生命值和攻击力，存在30秒。",
	"召唤两个90点生命、24-32点攻击力、3点物理防御和法术防御的幽魂弓手为你战斗，幽魂弓手附加18％司马懿的生命值和攻击力，存在30秒。",
	"召唤两个120点生命、36-46点攻击力、4点物理防御和法术防御的幽魂弓手为你战斗，幽魂弓手附加21％司马懿的生命值和攻击力，存在30秒。",
	"召唤两个150点生命、48-60点攻击力、5点物理防御和法术防御的幽魂弓手为你战斗，幽魂弓手附加24％司马懿的生命值和攻击力，存在30秒。",
	"召唤两个180点生命、60-74点攻击力、6点物理防御和法术防御的幽魂弓手为你战斗，幽魂弓手附加27％司马懿的生命值和攻击力，存在30秒。",
	"召唤两个210点生命、72-88点攻击力、7点物理防御和法术防御的幽魂弓手为你战斗，幽魂弓手附加30％司马懿的生命值和攻击力，存在30秒。",
	"召唤两个240点生命、84-102点攻击力、8点物理防御和法术防御的幽魂弓手为你战斗，幽魂弓手附加33％司马懿的生命值和攻击力，存在30秒。",
	"召唤两个270点生命、96-116点攻击力、9点物理防御和法术防御的幽魂弓手为你战斗，幽魂弓手附加36％司马懿的生命值和攻击力，存在30秒。",
	"召唤两个300点生命、108-130点攻击力、10点物理防御和法术防御的幽魂弓手为你战斗，幽魂弓手附加39％司马懿的生命值和攻击力，存在30秒。",
	"召唤两个330点生命、120-144点攻击力、11点物理防御和法术防御的幽魂弓手为你战斗，幽魂弓手附加42％司马懿的生命值和攻击力，存在30秒。",
	"召唤两个360点生命、132-158点攻击力、12点物理防御和法术防御的幽魂弓手为你战斗，幽魂弓手附加45％司马懿的生命值和攻击力，存在30秒。",
	"召唤两个390点生命、144-172点攻击力、13点物理防御和法术防御的幽魂弓手为你战斗，幽魂弓手附加48％司马懿的生命值和攻击力，存在30秒。",
	"召唤两个420点生命、156-186点攻击力、14点物理防御和法术防御的幽魂弓手为你战斗，幽魂弓手附加51％司马懿的生命值和攻击力，存在30秒。",
	"召唤两个450点生命、168-200点攻击力、15点物理防御和法术防御的幽魂弓手为你战斗，幽魂弓手附加54％司马懿的生命值和攻击力，存在30秒。",
	"召唤两个480点生命、180-214点攻击力、16点物理防御和法术防御的幽魂弓手为你战斗，幽魂弓手附加57％司马懿的生命值和攻击力，存在30秒。",
}

_tab_stringS[14124] = {"影杀",
	"幻化出一个影子随机对附近敌人发动快速的5次斩击，每一击造成30%物理伤害,每次发动影杀会减少5秒千影的冷却时间。",
	"幻化出一个影子随机对附近敌人发动快速的5次斩击，每一击造成33%物理伤害,每次发动影杀会减少5秒千影的冷却时间。",
	"幻化出一个影子随机对附近敌人发动快速的5次斩击，每一击造成36%物理伤害,每次发动影杀会减少5秒千影的冷却时间。",
	"幻化出一个影子随机对附近敌人发动快速的5次斩击，每一击造成39%物理伤害,每次发动影杀会减少5秒千影的冷却时间。",
	"幻化出一个影子随机对附近敌人发动快速的5次斩击，每一击造成42%物理伤害,每次发动影杀会减少5秒千影的冷却时间。",
	"幻化出一个影子随机对附近敌人发动快速的5次斩击，每一击造成45%物理伤害,每次发动影杀会减少5秒千影的冷却时间。",
	"幻化出一个影子随机对附近敌人发动快速的5次斩击，每一击造成48%物理伤害,每次发动影杀会减少5秒千影的冷却时间。",
	"幻化出二个影子随机对附近敌人发动快速的5次斩击，每一击造成51%物理伤害,每次发动影杀会减少5秒千影的冷却时间。",
	"幻化出二个影子随机对附近敌人发动快速的5次斩击，每一击造成54%物理伤害,每次发动影杀会减少5秒千影的冷却时间。",
	"幻化出二个影子随机对附近敌人发动快速的5次斩击，每一击造成57%物理伤害,每次发动影杀会减少5秒千影的冷却时间。",
	"幻化出二个影子随机对附近敌人发动快速的5次斩击，每一击造成60%物理伤害,每次发动影杀会减少5秒千影的冷却时间。",
	"幻化出二个影子随机对附近敌人发动快速的5次斩击，每一击造成63%物理伤害,每次发动影杀会减少5秒千影的冷却时间。",
	"幻化出二个影子随机对附近敌人发动快速的5次斩击，每一击造成66%物理伤害,每次发动影杀会减少5秒千影的冷却时间。",
	"幻化出二个影子随机对附近敌人发动快速的5次斩击，每一击造成69%物理伤害,每次发动影杀会减少5秒千影的冷却时间。",
	"幻化出三个影子随机对附近敌人发动快速的5次斩击，每一击造成72%物理伤害,每次发动影杀会减少5秒千影的冷却时间。",
}

_tab_stringS[14127] = {"两极反转",
	"生命值高于50%时，提升30点攻击力，生命值低于50%时，提升20%的物理和法术闪避。",
	"生命值高于50%时，提升33点攻击力，生命值低于50%时，提升22%的物理和法术闪避。",
	"生命值高于50%时，提升36点攻击力，生命值低于50%时，提升24%的物理和法术闪避。",
	"生命值高于50%时，提升39点攻击力，生命值低于50%时，提升26%的物理和法术闪避。",
	"生命值高于50%时，提升42点攻击力，生命值低于50%时，提升28%的物理和法术闪避。",
	"生命值高于50%时，提升45点攻击力，生命值低于50%时，提升30%的物理和法术闪避。",
	"生命值高于50%时，提升48点攻击力，生命值低于50%时，提升32%的物理和法术闪避。",
	"生命值高于50%时，提升51点攻击力，生命值低于50%时，提升34%的物理和法术闪避。",
	"生命值高于50%时，提升54点攻击力，生命值低于50%时，提升36%的物理和法术闪避。",
	"生命值高于50%时，提升57点攻击力，生命值低于50%时，提升38%的物理和法术闪避。",
	"生命值高于50%时，提升60点攻击力，生命值低于50%时，提升40%的物理和法术闪避。",
	"生命值高于50%时，提升63点攻击力，生命值低于50%时，提升42%的物理和法术闪避。",
	"生命值高于50%时，提升66点攻击力，生命值低于50%时，提升44%的物理和法术闪避。",
	"生命值高于50%时，提升69点攻击力，生命值低于50%时，提升46%的物理和法术闪避。",
	"生命值高于50%时，提升72点攻击力，生命值低于50%时，提升48%的物理和法术闪避。",
}

_tab_stringS[14130] = {"千影",
	"变身为影子武士，使得攻击方式变为远程，并在攻击时触发相应等级的影杀，持续20秒。",
	"变身为影子武士，使得攻击方式变为远程，并在攻击时触发相应等级的影杀，持续20秒。",
	"变身为影子武士，使得攻击方式变为远程，并在攻击时触发相应等级的影杀，持续20秒。",
	"变身为影子武士，使得攻击方式变为远程，并在攻击时触发相应等级的影杀，持续20秒。",
	"变身为影子武士，使得攻击方式变为远程，并在攻击时触发相应等级的影杀，持续20秒。",
	"变身为影子武士，使得攻击方式变为远程，并在攻击时触发相应等级的影杀，持续20秒。",
	"变身为影子武士，使得攻击方式变为远程，并在攻击时触发相应等级的影杀，持续20秒。",
	"变身为影子武士，使得攻击方式变为远程，并在攻击时触发相应等级的影杀，持续20秒。",
	"变身为影子武士，使得攻击方式变为远程，并在攻击时触发相应等级的影杀，持续20秒。",
	"变身为影子武士，使得攻击方式变为远程，并在攻击时触发相应等级的影杀，持续20秒。",
	"变身为影子武士，使得攻击方式变为远程，并在攻击时触发相应等级的影杀，持续20秒。",
	"变身为影子武士，使得攻击方式变为远程，并在攻击时触发相应等级的影杀，持续20秒。",
	"变身为影子武士，使得攻击方式变为远程，并在攻击时触发相应等级的影杀，持续20秒。",
	"变身为影子武士，使得攻击方式变为远程，并在攻击时触发相应等级的影杀，持续20秒。",
	"变身为影子武士，使得攻击方式变为远程，并在攻击时触发相应等级的影杀，持续20秒。",
}

_tab_stringS[14135] = {"巨兽咆哮",
	"孟获发出一声咆哮，嘲讽300范围内的敌人，同时自身获得一个能吸收最大生命值32％的物理护盾。如果护盾被击破，将会对240范围内的敌人造成孟获最大生命值32％的物理伤害。",
	"孟获发出一声咆哮，嘲讽300范围内的敌人，同时自身获得一个能吸收最大生命值34％的物理护盾。如果护盾被击破，将会对240范围内的敌人造成孟获最大生命值34％的物理伤害。",
	"孟获发出一声咆哮，嘲讽300范围内的敌人，同时自身获得一个能吸收最大生命值36％的物理护盾。如果护盾被击破，将会对240范围内的敌人造成孟获最大生命值36％的物理伤害。",
	"孟获发出一声咆哮，嘲讽300范围内的敌人，同时自身获得一个能吸收最大生命值38％的物理护盾。如果护盾被击破，将会对240范围内的敌人造成孟获最大生命值38％的物理伤害。",
	"孟获发出一声咆哮，嘲讽300范围内的敌人，同时自身获得一个能吸收最大生命值40％的物理护盾。如果护盾被击破，将会对240范围内的敌人造成孟获最大生命值40％的物理伤害。",
	"孟获发出一声咆哮，嘲讽300范围内的敌人，同时自身获得一个能吸收最大生命值42％的物理护盾。如果护盾被击破，将会对240范围内的敌人造成孟获最大生命值42％的物理伤害。",
	"孟获发出一声咆哮，嘲讽300范围内的敌人，同时自身获得一个能吸收最大生命值44％的物理护盾。如果护盾被击破，将会对240范围内的敌人造成孟获最大生命值44％的物理伤害。",
	"孟获发出一声咆哮，嘲讽300范围内的敌人，同时自身获得一个能吸收最大生命值46％的物理护盾。如果护盾被击破，将会对240范围内的敌人造成孟获最大生命值46％的物理伤害。",
	"孟获发出一声咆哮，嘲讽300范围内的敌人，同时自身获得一个能吸收最大生命值48％的物理护盾。如果护盾被击破，将会对240范围内的敌人造成孟获最大生命值48％的物理伤害。",
	"孟获发出一声咆哮，嘲讽300范围内的敌人，同时自身获得一个能吸收最大生命值50％的物理护盾。如果护盾被击破，将会对240范围内的敌人造成孟获最大生命值50％的物理伤害。",
	"孟获发出一声咆哮，嘲讽300范围内的敌人，同时自身获得一个能吸收最大生命值52％的物理护盾。如果护盾被击破，将会对240范围内的敌人造成孟获最大生命值52％的物理伤害。",
	"孟获发出一声咆哮，嘲讽300范围内的敌人，同时自身获得一个能吸收最大生命值54％的物理护盾。如果护盾被击破，将会对240范围内的敌人造成孟获最大生命值54％的物理伤害。",
	"孟获发出一声咆哮，嘲讽300范围内的敌人，同时自身获得一个能吸收最大生命值56％的物理护盾。如果护盾被击破，将会对240范围内的敌人造成孟获最大生命值56％的物理伤害。",
	"孟获发出一声咆哮，嘲讽300范围内的敌人，同时自身获得一个能吸收最大生命值58％的物理护盾。如果护盾被击破，将会对240范围内的敌人造成孟获最大生命值58％的物理伤害。",
	"孟获发出一声咆哮，嘲讽300范围内的敌人，同时自身获得一个能吸收最大生命值60％的物理护盾。如果护盾被击破，将会对240范围内的敌人造成孟获最大生命值60％的物理伤害。",
}

_tab_stringS[14138] = {"兽魂",
	"孟获每击杀一个敌人，增加2点生命最大值，该效果最多叠加100层。当叠满100层时，身形将变得巨大，额外增加50点攻击力，并免疫控制和减速效果。",
	"孟获每击杀一个敌人，增加4点生命最大值，该效果最多叠加100层。当叠满100层时，身形将变得巨大，额外增加58点攻击力，并免疫控制和减速效果。",
	"孟获每击杀一个敌人，增加6点生命最大值，该效果最多叠加100层。当叠满100层时，身形将变得巨大，额外增加66点攻击力，并免疫控制和减速效果。",
	"孟获每击杀一个敌人，增加8点生命最大值，该效果最多叠加100层。当叠满100层时，身形将变得巨大，额外增加74点攻击力，并免疫控制和减速效果。",
	"孟获每击杀一个敌人，增加10点生命最大值，该效果最多叠加100层。当叠满100层时，身形将变得巨大，额外增加82点攻击力，并免疫控制和减速效果。",
	"孟获每击杀一个敌人，增加12点生命最大值，该效果最多叠加100层。当叠满100层时，身形将变得巨大，额外增加90点攻击力，并免疫控制和减速效果。",
	"孟获每击杀一个敌人，增加14点生命最大值，该效果最多叠加100层。当叠满100层时，身形将变得巨大，额外增加98点攻击力，并免疫控制和减速效果。",
	"孟获每击杀一个敌人，增加16点生命最大值，该效果最多叠加100层。当叠满100层时，身形将变得巨大，额外增加106点攻击力，并免疫控制和减速效果。",
	"孟获每击杀一个敌人，增加18点生命最大值，该效果最多叠加100层。当叠满100层时，身形将变得巨大，额外增加114点攻击力，并免疫控制和减速效果。",
	"孟获每击杀一个敌人，增加20点生命最大值，该效果最多叠加100层。当叠满100层时，身形将变得巨大，额外增加122点攻击力，并免疫控制和减速效果。",
	"孟获每击杀一个敌人，增加22点生命最大值，该效果最多叠加100层。当叠满100层时，身形将变得巨大，额外增加130点攻击力，并免疫控制和减速效果。",
	"孟获每击杀一个敌人，增加24点生命最大值，该效果最多叠加100层。当叠满100层时，身形将变得巨大，额外增加138点攻击力，并免疫控制和减速效果。",
	"孟获每击杀一个敌人，增加26点生命最大值，该效果最多叠加100层。当叠满100层时，身形将变得巨大，额外增加146点攻击力，并免疫控制和减速效果。",
	"孟获每击杀一个敌人，增加28点生命最大值，该效果最多叠加100层。当叠满100层时，身形将变得巨大，额外增加154点攻击力，并免疫控制和减速效果。",
	"孟获每击杀一个敌人，增加30点生命最大值，该效果最多叠加100层。当叠满100层时，身形将变得巨大，额外增加162点攻击力，并免疫控制和减速效果。",
}



_tab_stringS[14142] = {"驱兽",
	"召唤一队动物为你战斗。动物附加孟获16％的生命值和攻击力。动物存在30秒。\n（施法范围：240）",
	"召唤一队动物为你战斗。动物附加孟获20％的生命值和攻击力。动物存在30秒。\n（施法范围：240）",
	"召唤一队动物为你战斗。动物附加孟获24％的生命值和攻击力。动物存在30秒。\n（施法范围：240）",
	"召唤一队动物为你战斗。动物附加孟获28％的生命值和攻击力。动物存在30秒。\n（施法范围：240）",
	"召唤一队动物为你战斗。动物附加孟获32％的生命值和攻击力。动物存在30秒。\n（施法范围：240）",
	"召唤一队动物为你战斗。动物附加孟获36％的生命值和攻击力。动物存在30秒。\n（施法范围：240）",
	"召唤一队动物为你战斗。动物附加孟获40％的生命值和攻击力。动物存在30秒。\n（施法范围：240）",
	"召唤一队动物为你战斗。动物附加孟获44％的生命值和攻击力。动物存在30秒。\n（施法范围：240）",
	"召唤一队动物为你战斗。动物附加孟获48％的生命值和攻击力。动物存在30秒。\n（施法范围：240）",
	"召唤一队动物为你战斗。动物附加孟获52％的生命值和攻击力。动物存在30秒。\n（施法范围：240）",
	"召唤一队动物为你战斗。动物附加孟获56％的生命值和攻击力。动物存在30秒。\n（施法范围：240）",
	"召唤一队动物为你战斗。动物附加孟获60％的生命值和攻击力。动物存在30秒。\n（施法范围：240）",
	"召唤一队动物为你战斗。动物附加孟获64％的生命值和攻击力。动物存在30秒。\n（施法范围：240）",
	"召唤一队动物为你战斗。动物附加孟获68％的生命值和攻击力。动物存在30秒。\n（施法范围：240）",
	"召唤一队动物为你战斗。动物附加孟获72％的生命值和攻击力。动物存在30秒。\n（施法范围：240）",
}

_tab_stringS[14145] = {"回旋飞刃",
	"祝融夫人朝目标方向投掷一枚飞刃，对一条直线上的敌人造成攻击力66％的物理伤害。飞刃到达最远处后飞回祝融夫人身边，再次对途中碰到的敌人造成伤害。",
	"祝融夫人朝目标方向投掷一枚飞刃，对一条直线上的敌人造成攻击力72％的物理伤害。飞刃到达最远处后飞回祝融夫人身边，再次对途中碰到的敌人造成伤害。",
	"祝融夫人朝目标方向投掷一枚飞刃，对一条直线上的敌人造成攻击力78％的物理伤害。飞刃到达最远处后飞回祝融夫人身边，再次对途中碰到的敌人造成伤害。",
	"祝融夫人朝目标方向投掷一枚飞刃，对一条直线上的敌人造成攻击力84％的物理伤害。飞刃到达最远处后飞回祝融夫人身边，再次对途中碰到的敌人造成伤害。",
	"祝融夫人朝目标方向投掷一枚飞刃，对一条直线上的敌人造成攻击力90％的物理伤害。飞刃到达最远处后飞回祝融夫人身边，再次对途中碰到的敌人造成伤害。",
	"祝融夫人朝目标方向投掷一枚飞刃，对一条直线上的敌人造成攻击力96％的物理伤害。飞刃到达最远处后飞回祝融夫人身边，再次对途中碰到的敌人造成伤害。",
	"祝融夫人朝目标方向投掷一枚飞刃，对一条直线上的敌人造成攻击力102％的物理伤害。飞刃到达最远处后飞回祝融夫人身边，再次对途中碰到的敌人造成伤害。",
	"祝融夫人朝目标方向投掷一枚飞刃，对一条直线上的敌人造成攻击力108％的物理伤害。飞刃到达最远处后飞回祝融夫人身边，再次对途中碰到的敌人造成伤害。",
	"祝融夫人朝目标方向投掷一枚飞刃，对一条直线上的敌人造成攻击力116％的物理伤害。飞刃到达最远处后飞回祝融夫人身边，再次对途中碰到的敌人造成伤害。",
	"祝融夫人朝目标方向投掷一枚飞刃，对一条直线上的敌人造成攻击力124％的物理伤害。飞刃到达最远处后飞回祝融夫人身边，再次对途中碰到的敌人造成伤害。",
	"祝融夫人朝目标方向投掷一枚飞刃，对一条直线上的敌人造成攻击力130％的物理伤害。飞刃到达最远处后飞回祝融夫人身边，再次对途中碰到的敌人造成伤害。",
	"祝融夫人朝目标方向投掷一枚飞刃，对一条直线上的敌人造成攻击力136％的物理伤害。飞刃到达最远处后飞回祝融夫人身边，再次对途中碰到的敌人造成伤害。",
	"祝融夫人朝目标方向投掷一枚飞刃，对一条直线上的敌人造成攻击力142％的物理伤害。飞刃到达最远处后飞回祝融夫人身边，再次对途中碰到的敌人造成伤害。",
	"祝融夫人朝目标方向投掷一枚飞刃，对一条直线上的敌人造成攻击力148％的物理伤害。飞刃到达最远处后飞回祝融夫人身边，再次对途中碰到的敌人造成伤害。",
	"祝融夫人朝目标方向投掷一枚飞刃，对一条直线上的敌人造成攻击力154％的物理伤害。飞刃到达最远处后飞回祝融夫人身边，再次对途中碰到的敌人造成伤害。",
}

_tab_stringS[14147] = {"狼牙利刃",
	"永久增加自身9点攻击力。同时祝融夫人每次攻击附带弹射，飞刃在周围随机敌人之间弹射3次，每次造成攻击力100％的物理伤害。",
	"永久增加自身12点攻击力。同时祝融夫人每次攻击附带弹射，飞刃在周围随机敌人之间弹射3次，每次造成攻击力100％的物理伤害。",
	"永久增加自身15点攻击力。同时祝融夫人每次攻击附带弹射，飞刃在周围随机敌人之间弹射3次，每次造成攻击力100％的物理伤害。",
	"永久增加自身18点攻击力。同时祝融夫人每次攻击附带弹射，飞刃在周围随机敌人之间弹射3次，每次造成攻击力100％的物理伤害。",
	"永久增加自身21点攻击力。同时祝融夫人每次攻击附带弹射，飞刃在周围随机敌人之间弹射3次，每次造成攻击力100％的物理伤害。",
	"永久增加自身24点攻击力。同时祝融夫人每次攻击附带弹射，飞刃在周围随机敌人之间弹射3次，每次造成攻击力100％的物理伤害。",
	"永久增加自身27点攻击力。同时祝融夫人每次攻击附带弹射，飞刃在周围随机敌人之间弹射3次，每次造成攻击力100％的物理伤害。",
	"永久增加自身30点攻击力。同时祝融夫人每次攻击附带弹射，飞刃在周围随机敌人之间弹射3次，每次造成攻击力100％的物理伤害。",
	"永久增加自身33点攻击力。同时祝融夫人每次攻击附带弹射，飞刃在周围随机敌人之间弹射3次，每次造成攻击力100％的物理伤害。",
	"永久增加自身36点攻击力。同时祝融夫人每次攻击附带弹射，飞刃在周围随机敌人之间弹射3次，每次造成攻击力100％的物理伤害。",
	"永久增加自身39点攻击力。同时祝融夫人每次攻击附带弹射，飞刃在周围随机敌人之间弹射3次，每次造成攻击力100％的物理伤害。",
	"永久增加自身42点攻击力。同时祝融夫人每次攻击附带弹射，飞刃在周围随机敌人之间弹射3次，每次造成攻击力100％的物理伤害。",
	"永久增加自身45点攻击力。同时祝融夫人每次攻击附带弹射，飞刃在周围随机敌人之间弹射3次，每次造成攻击力100％的物理伤害。",
	"永久增加自身48点攻击力。同时祝融夫人每次攻击附带弹射，飞刃在周围随机敌人之间弹射3次，每次造成攻击力100％的物理伤害。",
	"永久增加自身51点攻击力。同时祝融夫人每次攻击附带弹射，飞刃在周围随机敌人之间弹射3次，每次造成攻击力100％的物理伤害。",
}
_tab_stringS[14148] = {"神火飞刃",
	"祝融夫人为飞刃注入火神之力，提升30％的攻击速度和10％的移动速度，持续15秒。在此期间，祝融夫人攻击的目标、回旋飞刃碰到的敌人，以及飞刃弹射到的敌人，都将额外受到攻击力100％的法术伤害。",
	"祝融夫人为飞刃注入火神之力，提升33％的攻击速度和11％的移动速度，持续15秒。在此期间，祝融夫人攻击的目标、回旋飞刃碰到的敌人，以及飞刃弹射到的敌人，都将额外受到攻击力100％的法术伤害。",
	"祝融夫人为飞刃注入火神之力，提升36％的攻击速度和12％的移动速度，持续15秒。在此期间，祝融夫人攻击的目标、回旋飞刃碰到的敌人，以及飞刃弹射到的敌人，都将额外受到攻击力100％的法术伤害。",
	"祝融夫人为飞刃注入火神之力，提升39％的攻击速度和13％的移动速度，持续15秒。在此期间，祝融夫人攻击的目标、回旋飞刃碰到的敌人，以及飞刃弹射到的敌人，都将额外受到攻击力100％的法术伤害。",
	"祝融夫人为飞刃注入火神之力，提升42％的攻击速度和14％的移动速度，持续15秒。在此期间，祝融夫人攻击的目标、回旋飞刃碰到的敌人，以及飞刃弹射到的敌人，都将额外受到攻击力100％的法术伤害。",
	"祝融夫人为飞刃注入火神之力，提升45％的攻击速度和15％的移动速度，持续15秒。在此期间，祝融夫人攻击的目标、回旋飞刃碰到的敌人，以及飞刃弹射到的敌人，都将额外受到攻击力100％的法术伤害。",
	"祝融夫人为飞刃注入火神之力，提升48％的攻击速度和16％的移动速度，持续15秒。在此期间，祝融夫人攻击的目标、回旋飞刃碰到的敌人，以及飞刃弹射到的敌人，都将额外受到攻击力100％的法术伤害。",
	"祝融夫人为飞刃注入火神之力，提升51％的攻击速度和17％的移动速度，持续15秒。在此期间，祝融夫人攻击的目标、回旋飞刃碰到的敌人，以及飞刃弹射到的敌人，都将额外受到攻击力100％的法术伤害。",
	"祝融夫人为飞刃注入火神之力，提升54％的攻击速度和18％的移动速度，持续15秒。在此期间，祝融夫人攻击的目标、回旋飞刃碰到的敌人，以及飞刃弹射到的敌人，都将额外受到攻击力100％的法术伤害。",
	"祝融夫人为飞刃注入火神之力，提升57％的攻击速度和19％的移动速度，持续15秒。在此期间，祝融夫人攻击的目标、回旋飞刃碰到的敌人，以及飞刃弹射到的敌人，都将额外受到攻击力100％的法术伤害。",
	"祝融夫人为飞刃注入火神之力，提升60％的攻击速度和20％的移动速度，持续15秒。在此期间，祝融夫人攻击的目标、回旋飞刃碰到的敌人，以及飞刃弹射到的敌人，都将额外受到攻击力100％的法术伤害。",
	"祝融夫人为飞刃注入火神之力，提升63％的攻击速度和21％的移动速度，持续15秒。在此期间，祝融夫人攻击的目标、回旋飞刃碰到的敌人，以及飞刃弹射到的敌人，都将额外受到攻击力100％的法术伤害。",
	"祝融夫人为飞刃注入火神之力，提升66％的攻击速度和22％的移动速度，持续15秒。在此期间，祝融夫人攻击的目标、回旋飞刃碰到的敌人，以及飞刃弹射到的敌人，都将额外受到攻击力100％的法术伤害。",
	"祝融夫人为飞刃注入火神之力，提升69％的攻击速度和23％的移动速度，持续15秒。在此期间，祝融夫人攻击的目标、回旋飞刃碰到的敌人，以及飞刃弹射到的敌人，都将额外受到攻击力100％的法术伤害。",
	"祝融夫人为飞刃注入火神之力，提升72％的攻击速度和24％的移动速度，持续15秒。在此期间，祝融夫人攻击的目标、回旋飞刃碰到的敌人，以及飞刃弹射到的敌人，都将额外受到攻击力100％的法术伤害。",
}


_tab_stringS[14150] = {"水之涡流",
	"在身边召唤一个24-30点攻击力的水之涡流协助战斗，水之涡流附加甄姬9％的攻击力，攻击300范围内的敌人。水之涡流存在15秒。",
	"在身边召唤一个27-36点攻击力的水之涡流协助战斗，水之涡流附加甄姬12％的攻击力，攻击300范围内的敌人。水之涡流存在15秒。",
	"在身边召唤一个30-42点攻击力的水之涡流协助战斗，水之涡流附加甄姬15％的攻击力，攻击300范围内的敌人。水之涡流存在15秒。",
	"在身边召唤一个33-48点攻击力的水之涡流协助战斗，水之涡流附加甄姬18％的攻击力，攻击300范围内的敌人。水之涡流存在15秒。",
	"在身边召唤一个36-54点攻击力的水之涡流协助战斗，水之涡流附加甄姬21％的攻击力，攻击300范围内的敌人。水之涡流存在15秒。",
	"在身边召唤一个39-60点攻击力的水之涡流协助战斗，水之涡流附加甄姬24％的攻击力，攻击300范围内的敌人。水之涡流存在15秒。",
	"在身边召唤一个42-66点攻击力的水之涡流协助战斗，水之涡流附加甄姬27％的攻击力，攻击300范围内的敌人。水之涡流存在15秒。",
	"在身边召唤一个45-72点攻击力的水之涡流协助战斗，水之涡流附加甄姬30％的攻击力，攻击300范围内的敌人。水之涡流存在15秒。",
	"在身边召唤一个48-78点攻击力的水之涡流协助战斗，水之涡流附加甄姬33％的攻击力，攻击300范围内的敌人。水之涡流存在15秒。",
	"在身边召唤一个51-84点攻击力的水之涡流协助战斗，水之涡流附加甄姬36％的攻击力，攻击300范围内的敌人。水之涡流存在15秒。",
	"在身边召唤一个54-90点攻击力的水之涡流协助战斗，水之涡流附加甄姬39％的攻击力，攻击300范围内的敌人。水之涡流存在15秒。",
	"在身边召唤一个57-96点攻击力的水之涡流协助战斗，水之涡流附加甄姬42％的攻击力，攻击300范围内的敌人。水之涡流存在15秒。",
	"在身边召唤一个60-102点攻击力的水之涡流协助战斗，水之涡流附加甄姬45％的攻击力，攻击300范围内的敌人。水之涡流存在15秒。",
	"在身边召唤一个63-108点攻击力的水之涡流协助战斗，水之涡流附加甄姬48％的攻击力，攻击300范围内的敌人。水之涡流存在15秒。",
	"在身边召唤一个66-114点攻击力的水之涡流协助战斗，水之涡流附加甄姬51％的攻击力，攻击300范围内的敌人。水之涡流存在15秒。",
}




_tab_stringS[14151] = {"逆流",
	"减少水之涡流技能6％的冷却时间。每次召唤水之涡流时额外召唤一个水之涡流。",
	"减少水之涡流技能7％的冷却时间。每次召唤水之涡流时额外召唤一个水之涡流。",
	"减少水之涡流技能8％的冷却时间。每次召唤水之涡流时额外召唤一个水之涡流。",
	"减少水之涡流技能9％的冷却时间。每次召唤水之涡流时额外召唤一个水之涡流。",
	"减少水之涡流技能10％的冷却时间。每次召唤水之涡流时额外召唤一个水之涡流。",
	"减少水之涡流技能11％的冷却时间。每次召唤水之涡流时额外召唤一个水之涡流。",
	"减少水之涡流技能12％的冷却时间。每次召唤水之涡流时额外召唤一个水之涡流。",
	"减少水之涡流技能13％的冷却时间。每次召唤水之涡流时额外召唤一个水之涡流。",
	"减少水之涡流技能14％的冷却时间。每次召唤水之涡流时额外召唤一个水之涡流。",
	"减少水之涡流技能15％的冷却时间。每次召唤水之涡流时额外召唤一个水之涡流。",
	"减少水之涡流技能16％的冷却时间。每次召唤水之涡流时额外召唤一个水之涡流。",
	"减少水之涡流技能17％的冷却时间。每次召唤水之涡流时额外召唤一个水之涡流。",
	"减少水之涡流技能18％的冷却时间。每次召唤水之涡流时额外召唤一个水之涡流。",
	"减少水之涡流技能19％的冷却时间。每次召唤水之涡流时额外召唤一个水之涡流。",
	"减少水之涡流技能20％的冷却时间。每次召唤水之涡流时额外召唤一个水之涡流。",
}



_tab_stringS[14152] = {"暗流涌动",
	"激发暗流，对甄姬周围180范围内的敌人造成攻击力180％的法术伤害，并降低50％的移动速度，持续6秒。同时引爆全部的水之涡流，每个水之涡流都对周围180范围内的敌人造成攻击力180％的法术伤害，并降低50％的移动速度，持续3秒。",
	"激发暗流，对甄姬周围180范围内的敌人造成攻击力210％的法术伤害，并降低50％的移动速度，持续6秒。同时引爆全部的水之涡流，每个水之涡流都对周围180范围内的敌人造成攻击力210％的法术伤害，并降低50％的移动速度，持续3秒。",
	"激发暗流，对甄姬周围180范围内的敌人造成攻击力240％的法术伤害，并降低50％的移动速度，持续6秒。同时引爆全部的水之涡流，每个水之涡流都对周围180范围内的敌人造成攻击力240％的法术伤害，并降低50％的移动速度，持续3秒。",
	"激发暗流，对甄姬周围180范围内的敌人造成攻击力270％的法术伤害，并降低50％的移动速度，持续6秒。同时引爆全部的水之涡流，每个水之涡流都对周围180范围内的敌人造成攻击力270％的法术伤害，并降低50％的移动速度，持续3秒。",
	"激发暗流，对甄姬周围180范围内的敌人造成攻击力300％的法术伤害，并降低50％的移动速度，持续6秒。同时引爆全部的水之涡流，每个水之涡流都对周围180范围内的敌人造成攻击力300％的法术伤害，并降低50％的移动速度，持续3秒。",
	"激发暗流，对甄姬周围180范围内的敌人造成攻击力330％的法术伤害，并降低50％的移动速度，持续6秒。同时引爆全部的水之涡流，每个水之涡流都对周围180范围内的敌人造成攻击力330％的法术伤害，并降低50％的移动速度，持续3秒。",
	"激发暗流，对甄姬周围180范围内的敌人造成攻击力360％的法术伤害，并降低50％的移动速度，持续6秒。同时引爆全部的水之涡流，每个水之涡流都对周围180范围内的敌人造成攻击力360％的法术伤害，并降低50％的移动速度，持续3秒。",
	"激发暗流，对甄姬周围180范围内的敌人造成攻击力390％的法术伤害，并降低50％的移动速度，持续6秒。同时引爆全部的水之涡流，每个水之涡流都对周围180范围内的敌人造成攻击力390％的法术伤害，并降低50％的移动速度，持续3秒。",
	"激发暗流，对甄姬周围180范围内的敌人造成攻击力420％的法术伤害，并降低50％的移动速度，持续6秒。同时引爆全部的水之涡流，每个水之涡流都对周围180范围内的敌人造成攻击力420％的法术伤害，并降低50％的移动速度，持续3秒。",
	"激发暗流，对甄姬周围180范围内的敌人造成攻击力450％的法术伤害，并降低50％的移动速度，持续6秒。同时引爆全部的水之涡流，每个水之涡流都对周围180范围内的敌人造成攻击力450％的法术伤害，并降低50％的移动速度，持续3秒。",
	"激发暗流，对甄姬周围180范围内的敌人造成攻击力480％的法术伤害，并降低50％的移动速度，持续6秒。同时引爆全部的水之涡流，每个水之涡流都对周围180范围内的敌人造成攻击力480％的法术伤害，并降低50％的移动速度，持续3秒。",
	"激发暗流，对甄姬周围180范围内的敌人造成攻击力510％的法术伤害，并降低50％的移动速度，持续6秒。同时引爆全部的水之涡流，每个水之涡流都对周围180范围内的敌人造成攻击力510％的法术伤害，并降低50％的移动速度，持续3秒。",
	"激发暗流，对甄姬周围180范围内的敌人造成攻击力540％的法术伤害，并降低50％的移动速度，持续6秒。同时引爆全部的水之涡流，每个水之涡流都对周围180范围内的敌人造成攻击力540％的法术伤害，并降低50％的移动速度，持续3秒。",
	"激发暗流，对甄姬周围180范围内的敌人造成攻击力570％的法术伤害，并降低50％的移动速度，持续6秒。同时引爆全部的水之涡流，每个水之涡流都对周围180范围内的敌人造成攻击力570％的法术伤害，并降低50％的移动速度，持续3秒。",
	"激发暗流，对甄姬周围180范围内的敌人造成攻击力600％的法术伤害，并降低50％的移动速度，持续6秒。同时引爆全部的水之涡流，每个水之涡流都对周围180范围内的敌人造成攻击力600％的法术伤害，并降低50％的移动速度，持续3秒。",
}


_tab_stringS[15001] = {"斩铁", "对自身周围的敌人造成攻击力50％的物理伤害，并降低20点物理防御，持续5秒。冷却10秒。",}
_tab_stringS[15003] = {"双龙护体", "提升自己20点物理防御和20点法术防御，持续20秒。冷却50秒。",}
_tab_stringS[15005] = {"白驹过隙", "提升自己40点移动速度和40％的闪避，持续10秒。冷却30秒。",}
_tab_stringS[15007] = {"破邪驱魔", "提升自己30点法术防御和每秒20点回血，持续15秒。冷却40秒。",}
_tab_stringS[15009] = {"魔龙乱舞", "连续发动7次疯狂打击，每次对自身周围的随机敌人造成攻击力100％的物理伤害，并恢复自身攻击力30％的生命。冷却10秒。",}

_tab_stringS[15014] = {"轮斩", "发动轮斩，对自身周围的敌人造成攻击力40％+75点的物理伤害。冷却15秒。",}
_tab_stringS[15015] = {"爆弹", "朝目标投掷一枚爆弹，爆弹落地后对小范围敌人造成30点法术伤害。冷却20秒。",}
_tab_stringS[15016] = {"爆炎弹", "朝目标投掷一枚爆炎弹，爆炎弹落地后对小范围敌人造成40点法术伤害，并点燃敌人，每秒受到15点法术伤害，持续5秒。冷却20秒。",}

_tab_stringS[15020] = {"突刺轮斩", "发动突刺轮斩，对自身周围的敌人造成攻击力50％的物理伤害，并对正前方一条直线上的敌人造成攻击力150％的物理伤害。冷却15秒。",}
_tab_stringS[15021] = {"三尖突刺", "向前方刺出三道刀气，每道都对一条直线上的敌人造成攻击力15％+25点的物理伤害。冷却10秒",}
_tab_stringS[15022] = {"召唤飞鹰卫", "召唤一个具有超远攻击射程的飞鹰卫为你战斗，飞鹰卫附加英雄30％的攻击力和生命值，飞鹰卫存在30秒。冷却40秒。",}
_tab_stringS[15023] = {"召唤神鹰卫", "召唤一个具有超远攻击射程的神鹰卫为你战斗，神鹰卫附加英雄100％的攻击力和30％的生命值，神鹰卫存在30秒。冷却40秒。",}
_tab_stringS[15024] = {"魔龙乱舞", "吕布连续打击着身边的敌人。迅速发动7连击普通攻击，每次攻击吸取15％的生命。",}
_tab_stringS[15025] = {"召唤飞鹰卫（地图BOSS）", "召唤1个400点生命，30-50点攻击力，400射程的飞鹰卫为你战斗。飞鹰卫存在40秒。",}

_tab_stringS[15026] = {"月刃", "发出1道月刃，对一条直线上的敌人造成200％攻击力+60点的真实伤害，并眩晕0.5秒。冷却12秒。",}
_tab_stringS[15027] = {"月刃乱舞", "随机向前发射3~6道月刃，每道都对一条直线上的敌人造成100％攻击力+30点的真实伤害，并眩晕0.5秒。冷却9秒。",}

_tab_stringS[15029] = {"重击", "对目标造成攻击力200％的物理伤害，并眩晕2秒。冷却15秒。",}
_tab_stringS[15030] = {"猛击", "对自身周围3个随机敌人造成攻击力200％的物理伤害，并眩晕2秒。冷却15秒。",}
_tab_stringS[15031] = {"狂战", "牺牲防御换取输出，每件装备降低自身5点物理防御，增加30点攻击力和50％的攻速，持续15秒。冷却30秒。",}
_tab_stringS[15033] = {"百步穿杨", "射出一箭，每件装备对目标造成攻击力100％的物理伤害，对飞行单位造成双倍伤害。冷却6秒。",}
_tab_stringS[15034] = {"灼烧", "每次攻击附带灼烧效果，每秒造成攻击力30％的法术伤害，持续5秒。",}
_tab_stringS[15037] = {"鼓舞", "提升自己和附近友军30％的攻击力，持续6秒。冷却9秒。",}

_tab_stringS[15039] = {"聚财", "每6秒获得10金钱。",}
_tab_stringS[15040] = {"勾镰月", "释放刀气，对自身周围的敌人造成攻击力25％+60点的物理伤害。冷却12秒。",}
_tab_stringS[15041] = {"锤地", "猛击地面，对自身周围的敌人造成攻击力50％+90点的物理伤害，并眩晕2秒。冷却24秒。",}
_tab_stringS[15042] = {"火球术", "向目标发射一枚火球，造成攻击力50％+50点的法术伤害。冷却12秒。",}

_tab_stringS[15043] = {"鬼神一击", "挥舞方天戟向正前方斩出一击，对一条直线上的敌人造成攻击力80％+150点的物理伤害，并眩晕1秒。冷却12秒。",}
_tab_stringS[15044] = {"朱雀之炎", "对目标和目标周围的敌人引发连续五轮猛烈的爆炸，每一轮造成攻击力120％+300点的法术伤害。冷却21秒。",}
_tab_stringS[15045] = {"电弧", "每次攻击释放电弧，对目标造成攻击力50％的法术伤害。并在周围随机敌人之间弹射5次，每次造成攻击力60％的法术伤害，并电晕0.1秒。（主将除外）",}
_tab_stringS[15050] = {"冥蛇剧毒", "每次攻击附带蛇毒效果，每秒对目标造成攻击力50％的真实伤害，持续6秒。",}
_tab_stringS[15055] = {"剑倚长天", "提升自己和附近友军30％的攻击力和15％的吸血，持续12秒。冷却20秒。",}
_tab_stringS[15057] = {"玄武守护", "提升自己60点物理防御和每秒100点回血，持续5秒。冷却25秒。",}
_tab_stringS[15059] = {"炽焰光环", "炽热的火焰持续灼烧敌人，每秒对自身周围150范围内的敌人造成攻击力25％+25点的法术伤害。",}
_tab_stringS[15064] = {"冰爆术", "释放冰爆，对自身周围160范围内的敌人造成攻击力20％+60点的法术伤害，并冻结1秒。冷却8秒。",}
_tab_stringS[15065] = {"辟邪", "使自己免受法术伤害，持续5秒。冷却12秒。",}
_tab_stringS[15066] = {"烽烟四起", "提升自身360范围内所有友方塔50％的攻击力，持续60秒。冷却15秒。",}
_tab_stringS[15068] = {"摸金", "每次攻击获得3金。",}
_tab_stringS[15071] = {"野蛮冲撞", "发起猛烈的冲撞，对自身周围的敌人造成攻击力50％的物理伤害和1秒的眩晕，并造成击退，敌人被推开30码的距离。冷却16秒。",}
_tab_stringS[15072] = {"腾跃", "瞬间跳跃至敌人面前，并对目标点周围120范围内的敌人造成攻击力200％的物理伤害。冷却5秒。",}
_tab_stringS[30054] = {"召唤亡魂先知", "有70％的几率召唤一个亡魂为你战斗，亡魂每次攻击有72％的几率对小范围敌人造成1.5秒混乱，亡魂存在6秒。冷却10秒。",}
_tab_stringS[30057] = {"踏焰", "在脚下释放一团烈焰，对进入烈焰的敌人每秒造成攻击力20％+30点的法术伤害，烈焰持续4秒。冷却2秒。",}
_tab_stringS[15073] = {"祝福", "使自己免疫控制和减速效果，持续5秒。冷却12秒。",}
_tab_stringS[15075] = {"破魔光环", "降低自身周围300范围内的敌人30点法术防御。",}
_tab_stringS[15079] = {"怒击", "奋力一击，对目标造成攻击力450％的物理伤害和2秒的眩晕，并降低45点物理防御，持续5秒。冷却9秒。",}
_tab_stringS[15081] = {"吸血", "提升自己20％的吸血（远程效果减半），持续5秒。冷却12秒。",}
_tab_stringS[15083] = {"金钟罩", "每损失2％生命提升1点物理防御和1点法术防御。",}

_tab_stringS[15086] = {"荼毒", "对自身周围160范围内的敌人释放剧毒，每秒造成攻击力120％+150点的真实伤害，并降低目标15点物理防御和法术防御，持续3秒。冷却8秒。",}
_tab_stringS[15088] = {"罪罚光环", "每秒对自身周围220范围内当前生命高于80％的敌人降下神雷，造成敌人最大生命值15％的法术伤害。",}
_tab_stringS[15090] = {"年兽之力", "对同一目标连续攻击3次后会对其造成攻击力100％的真实伤害。若目标生命值低于20％则将其消灭。（主将除外）",}


_tab_stringS[15094] = {"鬼煞之力", "增加30点攻击力和30％的攻击速度，持续3秒，冷却9秒。",}
_tab_stringS[15096] = {"神芒", "每次攻击使英雄战术技能冷却缩短0.5秒。",}

_tab_stringS[15099] = {"隐身", "使自己处于隐身状态，不再受到任何攻击，并提升30％的移动速度，持续10秒。冷却15秒。",}

_tab_stringS[15102] = {"威道", "获得等同法术防御的攻击力。",}
_tab_stringS[15104] = {"奔袭", "获得等同20％移动速度的攻击力。",}
_tab_stringS[15106] = {"月相", "每次攻击提升自己10％攻击速度和5点攻击力，持续5秒，该效果最多可叠加10次。",}
_tab_stringS[15110] = {"圣者之力", "使该装备所有锻造属性效果翻倍。",}

_tab_stringS[15112] = {"祥瑞之光", "每隔20秒获得一种随机增益效果，持续20秒。\n可能出现的增益效果：\n90点攻击、50％的闪避、60点回血",}

_tab_stringS[15116] = {"清心咒", "对自己或一名友军进行治疗，恢复攻击力200％+120点的生命值，并使目标免疫控制和减速效果，持续5秒。冷却9秒。",}

_tab_stringS[15117] = {"心眼", "每次攻击使英雄战术技能冷却缩短0.2秒。",}

_tab_stringS[15120] = {"威慑", "对周围60码范围敌人造成攻击力100％+50点的物理伤害，并降低敌人30％的攻击力，持续3秒。冷却3秒。",}

_tab_stringS[15122] = {"召唤铁甲卫", "召唤一个具有超强防御能力的铁甲卫为你战斗，铁甲卫附加英雄80％的生命值和20％的攻击力，铁甲卫存在30秒。冷却40秒。",}

_tab_stringS[15123] = {"坚韧", "每秒回复自身60点生命，持续5秒。冷却10秒。",}
_tab_stringS[15237] = {"碎石击", "每次攻击有5％的几率击退目标30码的距离，并使目标在接下来3秒内无法攻击。",}
_tab_stringS[15128] = {"宝体", "当自身生命低于30％时，每过5秒有35％概率获得3秒无敌。",}
_tab_stringS[15130] = {"虹霞秘术", "发射一道激光，持续攻击面前的敌人，每一击造成30％攻击力的法术伤害，最多命中12次，冷却20秒。",}
_tab_stringS[15131] = {"践踏", "对周围120码范围内的敌人造成 100％+100点物理伤害，并眩晕2秒，冷却12秒。",}
_tab_stringS[15133] = {"九天神雷", "自身周围内降下数道神雷，对240码范围敌人造成150％点法术伤害，冷却18秒。",}
_tab_stringS[15134] = {"怒火中烧", "周围150码内每有1个敌人就增加自身3点攻击力，持续3秒，冷却3秒。",}
_tab_stringS[15139] = {"献祭", "自身每损失30点生命，增加1点攻击力。",}
_tab_stringS[15141] = {"拖刀", "增加160点物理攻击，同时减少100％攻击速度，50％移动速度，持续5秒，冷却12秒。",}
_tab_stringS[15143] = {"火焰迸发", "从地底迸发出多重火焰，每一道火焰造成200％法术伤害，冷却6秒。",}
_tab_stringS[15145] = {"尚武", "使自己获得100％闪避，并提升50％攻击速度，持续3秒，冷却12秒。",}
_tab_stringS[15147] = {"燃魂", "生命值低于30％时触发，使自己获得200％攻击速度，80％移动速度，120点攻击力，持续30秒，持续时间结束后英雄阵亡。",}
_tab_stringS[15150] = {"至阴之风", "每次攻击释放飓风，对一直线上的敌人造成攻击力35％的法术伤害",}
_tab_stringS[15153] = {"金石之约", "每过10秒，获得10金。\n每过10秒，当自身至少拥有2000金时，消耗100金并获得以下效果，持续10秒：\n攻击力+60\n攻击速度+30％\n物理防御+50\n法术防御+35\n回血速度+50",}
_tab_stringS[15155] = {"生财之道", "每过10秒，增加3％的金钱。（增加的金钱数最大不超过500）",}
_tab_stringS[15156] = {"励士", "提升附近友军35％的攻击速度和50％的移动速度，持续20秒，冷却20秒。",}
_tab_stringS[15158] = {"突击", "提升自己50点移动速度和30点攻击力，持续9秒，冷却18秒。",}
_tab_stringS[15160] = {"踏雪", "对附近的敌人发动一次冲击，造成60％攻击力的法术伤害，并减少50％移动速度，持续3秒，冷却7秒。",}
_tab_stringS[15162] = {"诅咒", "复活时间固定为30秒。\n凋零\n每秒对自己和自身周围150范围内的敌人造成自身25％最大生命值的法术伤害。",}
_tab_stringS[15166] = {"龟息", "每损失1％的生命值，提升1点回血速度、降低1点移动速度。",}
_tab_stringS[15168] = {"暗月斩", "对自身周围的敌人造成攻击力35％的法术伤害，并降低15点法术防御，持续3秒，冷却4秒。",}

_tab_stringS[15170] = {"巨化", "自身变得巨大化，同时提升物理防御*16的生命值上限。",}
_tab_stringS[15172] = {"轻盈", "提升30％的物理闪避和20％的法术闪避，同时提升50点移动速度，持续5秒，冷却12秒。",}

_tab_stringS[15174] = {"重盾冲击", "用盾牌冲撞，对目标敌人造成5倍物理防御+60点的物理伤害，持续1.5秒，冷却7秒",}
_tab_stringS[15175] = {"血祭", "降低自身50％的生命值。每次攻击可额外造成自身最大生命值3％的伤害。",}
_tab_stringS[15177] = {"白牛的祝福", "每过7秒，使自己和附近友军战术技能冷却-1秒。",}
_tab_stringS[15180] = {"破甲光环", "降低自身周围300范围内的敌人30点物理防御。",}
_tab_stringS[15184] = {"神火炮", "[主动][唯一] 发射出9支火炮，每支火炮造成攻击力150％的范围法术伤害。冷却60秒。",}
_tab_stringS[15186] = {"长虹贯日", "[主动][唯一] 向指定点发出48道强力的剑气，每一道都对一条直线敌人造成攻击力30％的物理伤害。冷却60秒。",}
_tab_stringS[15187] = {"冰棱破碎", "随机发射5~12枚冰箭攻击附近的敌人，每一枚冰箭造成50％攻击力的法术伤害，并冰冻1秒，冷却9秒。",}
_tab_stringS[15189] = {"瘟疫", "使自己和周围150范围内的全体单位感染瘟疫，治疗效果降低50％，并对其造成每秒30+0.5％最大生命值的伤害（最高200点）。\n感染瘟疫的单位会将瘟疫传播给其他单位。",}
_tab_stringS[15194] = {"迷雾", "使180范围内的敌人减少25％命中，50％的攻击速度，30％的移动速度。",}
_tab_stringS[15198] = {"妖术", "使目标变为小动物，持续3秒，冷却12秒。",}
_tab_stringS[15199] = {"旱魃之影", "[主动][唯一] 变身为旱魃之影，持续30秒，冷却120秒。",}


_tab_stringS[16610] = {"青龙系", "射程+200, 生命+100％, 攻击+180, 物防+60, 法防+60, 技能效果翻倍。",}
_tab_stringS[16611] = {"白虎系", "射程+240, 攻击+50, 攻击速度+50％, 暴击几率+5％, 暴击伤害+15％。",}
_tab_stringS[16612] = {"朱雀系", "射程+210, 生命+30％, 攻击+120, 法防+100, 战术技能冷却-15％。",}
_tab_stringS[16613] = {"玄武系", "射程+180, 生命+200％, 生命恢复+100, 物防+100, 治疗效果提升20％。",}

_tab_stringS[33024] = {"鹤鸣", "清除自身受到的控制状态，并在5秒内提升20％物理及法术闪避和50％攻击速度，冷却12秒。",}
_tab_stringS[33027] = {"真实之击", "每次攻击时，额外对目标造成100％攻击力的真实伤害，该伤害无法触发暴击。",}

_tab_stringS[33030] = {"神兽血脉", "当自身最大生命值大于6000时，增加30点物理防御，并获得每秒2％的回血。",}
_tab_stringS[33032] = {"无锋", "获得等同于3%最大生命值的攻击力。",}
_tab_stringS[33034] = {"深渊凝视", "对目标造成600％攻击力的物理伤害，冷却5秒。如果使用此技能杀死目标，则召唤一个目标的复制，持续20秒。",}
_tab_stringS[33036] = {"静寂", "静止不动时，每隔3秒提升50点攻击力，最多叠加5层，持续5秒。",}
_tab_stringS[33038] = {"召唤黄龙", "召唤出黄龙来为你战斗，拥有英雄100%的生命、攻击、防御，持续10秒，冷却30秒。",}
_tab_stringS[33039] = {"缭乱【赵云专属】", "赵云携带时，自身所有技能冷却减少50%，战术技能改为闪现至目标区域对范围内敌人造成800%伤害，并眩晕2秒。",}
_tab_stringS[33040] = {"化身修罗【吕布专属】", "吕布化身为修罗形态，额外获得60点攻击，15%暴击率，60%暴击伤害，15%吸血，同时英雄每秒损失2%生命值。",}

_tab_stringS[33042] = {"青龙升华", "青龙系英雄驻守时额外获得属性：\n生命+50％\n攻击+90\n物防+30\n法防+30",}
_tab_stringS[33043] = {"白虎升华", "白虎系英雄驻守时额外获得属性：\n攻击+25\n攻击速度+25％\n暴击几率+3％\n暴击伤害+8％",}
_tab_stringS[33044] = {"朱雀升华", "朱雀系英雄驻守时额外获得属性：\n生命+15％\n攻击+60\n法防+50\n战术技能冷却-8％",}
_tab_stringS[33045] = {"玄武升华", "玄武系英雄驻守时额外获得属性：\n生命+100％\n生命恢复+50\n物防+50\n治疗效果提升10％",}

_tab_stringS[33046] = {"勇气", "生命值低于50%时，提升50点物理防御和法术防御，并且免疫控制和减速效果，持续10秒，该效果每30秒只能触发一次。",}

_tab_stringS[33151] = {"机关铁人", "召唤机关铁人，它拥有英雄100%的生命、攻击、防御，持续15秒，冷却60秒。",}
_tab_stringS[33694] = {"圣诞礼物", "每20秒出现一个圣诞礼盒，打开礼盒，引发各种未知效果。",}
_tab_stringS[33704] = {"猪突猛进", "向前突进，撞击敌人，造成150%攻击力的物理伤害和0.5秒的眩晕，冷却7秒。",}
_tab_stringS[33705] = {"金牛的祝福", "每过6秒，使自己和附近友军战术技能冷却-1秒，并获得6金。",}
_tab_stringS[33773] = {"破晓", "攻击的目标生命值低于50％时,获得15％暴击几率，和30％暴击伤害，持续2秒。",}
_tab_stringS[33775] = {"金乌落炎", "每次攻击时有20％概率使自身暴击几率提高15％，持续3秒。",}



_tab_stringS[16311] = {"青龙之力",
	"攻击力＋12\n被动技能冷却－6％",
	"攻击力＋18\n被动技能冷却－9％",
	"攻击力＋24\n被动技能冷却－12％",
	"攻击力＋30\n被动技能冷却－15％\n每隔20秒获得一层青龙之力，提升10点攻击力。该效果最多叠加10层。",
}


_tab_stringS[16323] = {"白虎之力",
	"移动速度＋20\n攻击速度＋20％",
	"移动速度＋30\n攻击速度＋30％",
	"移动速度＋40\n攻击速度＋40％",
	"移动速度＋50\n攻击速度＋50％\n每次攻击额外提升1％吸血，持续3秒。该效果最多叠加20层，达到最高层数时，额外提升12％的暴击几率。",
}


_tab_stringS[16337] = {"朱雀之力",
	"法术防御＋12\n战术技能冷却－6％",
	"法术防御＋18\n战术技能冷却－9％",
	"法术防御＋24\n战术技能冷却－12％",
	"法术防御＋30\n战术技能冷却－15％\n释放战术技能时获得一个能吸收法术伤害的护盾，护盾拥有法防*50的生命值，持续60秒。如果护盾破裂将引发爆炸，造成攻击力600％的范围伤害。",
}

_tab_stringS[16351] = {"玄武之力",
	"生命值＋600\n物理防御＋8",
	"生命值＋900\n物理防御＋12",
	"生命值＋1200\n物理防御＋16",
	"生命值＋1500\n物理防御＋20\n当自身血量低于50％时，立即恢复1000点+物理防御*5倍的生命值。该效果30秒内只能触发一次。",
}









_tab_stringS[32089] = {"永久免控", "神，不受任何约束！",}

_tab_stringS[32042] = {"龙吟", "灭世天火向周围的敌人尽情的宣泄！",}

_tab_stringS[21042] =
{
	"连珠箭",
	"连射出10支箭，每支箭命中射程内的随机敌人，每次造成攻击力6％+12点的物理伤害。",
	"连射出10支箭，每支箭命中射程内的随机敌人，每次造成攻击力7％+14点的物理伤害。",
	"连射出10支箭，每支箭命中射程内的随机敌人，每次造成攻击力8％+16点的物理伤害。",
	"连射出10支箭，每支箭命中射程内的随机敌人，每次造成攻击力9％+18点的物理伤害。",
	"连射出10支箭，每支箭命中射程内的随机敌人，每次造成攻击力10％+20点的物理伤害。",
	"连射出10支箭，每支箭命中射程内的随机敌人，每次造成攻击力11％+22点的物理伤害。",
	"连射出10支箭，每支箭命中射程内的随机敌人，每次造成攻击力12％+24点的物理伤害。",
	"连射出10支箭，每支箭命中射程内的随机敌人，每次造成攻击力13％+26点的物理伤害。",
	"连射出10支箭，每支箭命中射程内的随机敌人，每次造成攻击力14％+28点的物理伤害。",
	"连射出10支箭，每支箭命中射程内的随机敌人，每次造成攻击力15％+30点的物理伤害。",
	"连射出10支箭，每支箭命中射程内的随机敌人，每次造成攻击力16％+32点的物理伤害。",
	"连射出10支箭，每支箭命中射程内的随机敌人，每次造成攻击力17％+34点的物理伤害。",
	"连射出10支箭，每支箭命中射程内的随机敌人，每次造成攻击力18％+36点的物理伤害。",
	"连射出10支箭，每支箭命中射程内的随机敌人，每次造成攻击力19％+38点的物理伤害。",
	"连射出10支箭，每支箭命中射程内的随机敌人，每次造成攻击力20％+40点的物理伤害。",
}


_tab_stringS[21062] =
{
	"寒冰爆",
	"向正前方放出6道冰锥，每道都对小范围敌人造成攻击力30％+30点的法术伤害，并冻结1.5秒。",
	"向正前方放出6道冰锥，每道都对小范围敌人造成攻击力30％+45点的法术伤害，并冻结1.6秒。",
	"向正前方放出6道冰锥，每道都对小范围敌人造成攻击力30％+60点的法术伤害，并冻结1.7秒",
	"向正前方放出6道冰锥，每道都对小范围敌人造成攻击力30％+75点的法术伤害，并冻结1.8秒。",
	"向正前方放出6道冰锥，每道都对小范围敌人造成攻击力30％+90点的法术伤害，并冻结1.9秒。",
	"向正前方放出6道冰锥，每道都对小范围敌人造成攻击力30％+105点的法术伤害，并冻结2秒。",
	"向正前方放出6道冰锥，每道都对小范围敌人造成攻击力30％+120点的法术伤害，并冻结2.1秒。",
	"向正前方放出6道冰锥，每道都对小范围敌人造成攻击力30％+135点的法术伤害，并冻结2.2秒。",
	"向正前方放出6道冰锥，每道都对小范围敌人造成攻击力30％+150点的法术伤害，并冻结2.3秒。",
	"向正前方放出6道冰锥，每道都对小范围敌人造成攻击力30％+165点的法术伤害，并冻结2.4秒。",
	"向正前方放出6道冰锥，每道都对小范围敌人造成攻击力30％+180点的法术伤害，并冻结2.5秒。",
	"向正前方放出6道冰锥，每道都对小范围敌人造成攻击力30％+195点的法术伤害，并冻结2.6秒。",
	"向正前方放出6道冰锥，每道都对小范围敌人造成攻击力30％+210点的法术伤害，并冻结2.7秒。",
	"向正前方放出6道冰锥，每道都对小范围敌人造成攻击力30％+225点的法术伤害，并冻结2.8秒。",
	"向正前方放出6道冰锥，每道都对小范围敌人造成攻击力30％+240点的法术伤害，并冻结2.9秒。",
}

_tab_stringS[21101] =
{
	"战神一击",
	"对目标造成攻击力60％的物理伤害，并击晕1秒。如果消灭目标，则减少无双战神冷却时间5秒。",
	"对目标造成攻击力72％的物理伤害，并击晕1秒。如果消灭目标，则减少无双战神冷却时间5秒。",
	"对目标造成攻击力84％的物理伤害，并击晕1秒。如果消灭目标，则减少无双战神冷却时间5秒。",
	"对目标造成攻击力96％的物理伤害，并击晕1秒。如果消灭目标，则减少无双战神冷却时间5秒。",
	"对目标造成攻击力108％的物理伤害，并击晕1秒。如果消灭目标，则减少无双战神冷却时间5秒。",
	"对目标造成攻击力120％的物理伤害，并击晕1秒。如果消灭目标，则减少无双战神冷却时间5秒。",
	"对目标造成攻击力132％的物理伤害，并击晕1秒。如果消灭目标，则减少无双战神冷却时间5秒。",
	"对目标造成攻击力144％的物理伤害，并击晕1秒。如果消灭目标，则减少无双战神冷却时间5秒。",
	"对目标造成攻击力156％的物理伤害，并击晕1秒。如果消灭目标，则减少无双战神冷却时间5秒。",
	"对目标造成攻击力168％的物理伤害，并击晕1秒。如果消灭目标，则减少无双战神冷却时间5秒。",
	"对目标造成攻击力180％的物理伤害，并击晕1秒。如果消灭目标，则减少无双战神冷却时间5秒。",
	"对目标造成攻击力192％的物理伤害，并击晕1秒。如果消灭目标，则减少无双战神冷却时间5秒。",
	"对目标造成攻击力204％的物理伤害，并击晕1秒。如果消灭目标，则减少无双战神冷却时间5秒。",
	"对目标造成攻击力216％的物理伤害，并击晕1秒。如果消灭目标，则减少无双战神冷却时间5秒。",
	"对目标造成攻击力228％的物理伤害，并击晕1秒。如果消灭目标，则减少无双战神冷却时间5秒。",
}

_tab_stringS[21122] =
{
	"化守为攻",
	"用盾牌猛击附近敌人，对自身60范围内的敌人造成1.5倍物理防御+10点的物理伤害。",
	"用盾牌猛击附近敌人，对自身60范围内的敌人造成1.8倍物理防御+15点的物理伤害。",
	"用盾牌猛击附近敌人，对自身60范围内的敌人造成2.1倍物理防御+20点的物理伤害。",
	"用盾牌猛击附近敌人，对自身60范围内的敌人造成2.4倍物理防御+25点的物理伤害。",
	"用盾牌猛击附近敌人，对自身60范围内的敌人造成2.7倍物理防御+30点的物理伤害。",
	"用盾牌猛击附近敌人，对自身60范围内的敌人造成3.0倍物理防御+35点的物理伤害，并眩晕0.5秒。",
	"用盾牌猛击附近敌人，对自身60范围内的敌人造成3.3倍物理防御+40点的物理伤害，并眩晕0.5秒。",
	"用盾牌猛击附近敌人，对自身60范围内的敌人造成3.6倍物理防御+45点的物理伤害，并眩晕0.5秒。",
	"用盾牌猛击附近敌人，对自身60范围内的敌人造成3.9倍物理防御+50点的物理伤害，并眩晕0.5秒。",
	"用盾牌猛击附近敌人，对自身60范围内的敌人造成4.2倍物理防御+55点的物理伤害，并眩晕0.5秒。",
	"用盾牌猛击附近敌人，对自身60范围内的敌人造成4.5倍物理防御+60点的物理伤害，并眩晕0.5秒。",
	"用盾牌猛击附近敌人，对自身60范围内的敌人造成4.8倍物理防御+65点的物理伤害，并眩晕0.5秒。",
	"用盾牌猛击附近敌人，对自身60范围内的敌人造成5.1倍物理防御+70点的物理伤害，并眩晕0.5秒。",
	"用盾牌猛击附近敌人，对自身60范围内的敌人造成5.4倍物理防御+75点的物理伤害，并眩晕0.5秒。",
	"用盾牌猛击附近敌人，对自身60范围内的敌人造成5.7倍物理防御+80点的物理伤害，并眩晕0.5秒。",
}

_tab_stringS[21135] =
{
	"风卷残云（竞技场）",
	"向前发出3道旋风，每道旋风都对一条直线上碰到的敌人造成攻击力40％的物理伤害。对正前方一条直线上的敌人造成双倍伤害，并将其吹到空中，持续0.6秒。",
	"向前发出3道旋风，每道旋风都对一条直线上碰到的敌人造成攻击力45％的物理伤害。对正前方一条直线上的敌人造成双倍伤害，并将其吹到空中，持续0.7秒。",
	"向前发出3道旋风，每道旋风都对一条直线上碰到的敌人造成攻击力50％的物理伤害。对正前方一条直线上的敌人造成双倍伤害，并将其吹到空中，持续0.8秒。",
	"向前发出3道旋风，每道旋风都对一条直线上碰到的敌人造成攻击力55％的物理伤害。对正前方一条直线上的敌人造成双倍伤害，并将其吹到空中，持续0.9秒。",
	"向前发出3道旋风，每道旋风都对一条直线上碰到的敌人造成攻击力60％的物理伤害。对正前方一条直线上的敌人造成双倍伤害，并将其吹到空中，持续1秒。",
	"向前发出3道旋风，每道旋风都对一条直线上碰到的敌人造成攻击力65％的物理伤害。对正前方一条直线上的敌人造成双倍伤害，并将其吹到空中，持续1.1秒。",
	"向前发出3道旋风，每道旋风都对一条直线上碰到的敌人造成攻击力70％的物理伤害。对正前方一条直线上的敌人造成双倍伤害，并将其吹到空中，持续1.2秒。",
	"向前发出3道旋风，每道旋风都对一条直线上碰到的敌人造成攻击力75％的物理伤害。对正前方一条直线上的敌人造成双倍伤害，并将其吹到空中，持续1.3秒。",
	"向前发出3道旋风，每道旋风都对一条直线上碰到的敌人造成攻击力80％的物理伤害。对正前方一条直线上的敌人造成双倍伤害，并将其吹到空中，持续1.4秒。",
	"向前发出3道旋风，每道旋风都对一条直线上碰到的敌人造成攻击力85％的物理伤害。对正前方一条直线上的敌人造成双倍伤害，并将其吹到空中，持续1.5秒。",
	"向前发出3道旋风，每道旋风都对一条直线上碰到的敌人造成攻击力90％的物理伤害。对正前方一条直线上的敌人造成双倍伤害，并将其吹到空中，持续1.6秒。",
	"向前发出3道旋风，每道旋风都对一条直线上碰到的敌人造成攻击力95％的物理伤害。对正前方一条直线上的敌人造成双倍伤害，并将其吹到空中，持续1.7秒。",
	"向前发出3道旋风，每道旋风都对一条直线上碰到的敌人造成攻击力100％的物理伤害。对正前方一条直线上的敌人造成双倍伤害，并将其吹到空中，持续1.8秒。",
	"向前发出3道旋风，每道旋风都对一条直线上碰到的敌人造成攻击力105％的物理伤害。对正前方一条直线上的敌人造成双倍伤害，并将其吹到空中，持续1.9秒。",
	"向前发出3道旋风，每道旋风都对一条直线上碰到的敌人造成攻击力110％的物理伤害。对正前方一条直线上的敌人造成双倍伤害，并将其吹到空中，持续2秒。",
}


--PVP甘宁
_tab_stringS[21137] =
{
	"风驰电掣（竞技场）",
	"以极快的速度闪现到目标地点，并连续发动7次攻击，每次对附近随机的一个敌人造成攻击力100％的物理伤害。在此期间甘宁处于无敌状态。\n（施法范围：320）",
	"以极快的速度闪现到目标地点，并连续发动7次攻击，每次对附近随机的一个敌人造成攻击力115％的物理伤害。在此期间甘宁处于无敌状态。\n（施法范围：320）",
	"以极快的速度闪现到目标地点，并连续发动7次攻击，每次对附近随机的一个敌人造成攻击力130％的物理伤害。在此期间甘宁处于无敌状态。\n（施法范围：320）",
	"以极快的速度闪现到目标地点，并连续发动7次攻击，每次对附近随机的一个敌人造成攻击力145％的物理伤害。在此期间甘宁处于无敌状态。\n（施法范围：320）",
	"以极快的速度闪现到目标地点，并连续发动7次攻击，每次对附近随机的一个敌人造成攻击力160％的物理伤害。在此期间甘宁处于无敌状态。\n（施法范围：320）",
	"以极快的速度闪现到目标地点，并连续发动7次攻击，每次对附近随机的一个敌人造成攻击力175％的物理伤害。在此期间甘宁处于无敌状态。\n（施法范围：320）",
	"以极快的速度闪现到目标地点，并连续发动7次攻击，每次对附近随机的一个敌人造成攻击力190％的物理伤害。在此期间甘宁处于无敌状态。\n（施法范围：320）",
	"以极快的速度闪现到目标地点，并连续发动7次攻击，每次对附近随机的一个敌人造成攻击力205％的物理伤害。在此期间甘宁处于无敌状态。\n（施法范围：320）",
	"以极快的速度闪现到目标地点，并连续发动7次攻击，每次对附近随机的一个敌人造成攻击力220％的物理伤害。在此期间甘宁处于无敌状态。\n（施法范围：320）",
	"以极快的速度闪现到目标地点，并连续发动7次攻击，每次对附近随机的一个敌人造成攻击力235％的物理伤害。在此期间甘宁处于无敌状态。\n（施法范围：320）",
	"以极快的速度闪现到目标地点，并连续发动7次攻击，每次对附近随机的一个敌人造成攻击力250％的物理伤害。在此期间甘宁处于无敌状态。\n（施法范围：320）",
	"以极快的速度闪现到目标地点，并连续发动7次攻击，每次对附近随机的一个敌人造成攻击力265％的物理伤害。在此期间甘宁处于无敌状态。\n（施法范围：320）",
	"以极快的速度闪现到目标地点，并连续发动7次攻击，每次对附近随机的一个敌人造成攻击力280％的物理伤害。在此期间甘宁处于无敌状态。\n（施法范围：320）",
	"以极快的速度闪现到目标地点，并连续发动7次攻击，每次对附近随机的一个敌人造成攻击力295％的物理伤害。在此期间甘宁处于无敌状态。\n（施法范围：320）",
	"以极快的速度闪现到目标地点，并连续发动7次攻击，每次对附近随机的一个敌人造成攻击力310％的物理伤害。在此期间甘宁处于无敌状态。\n（施法范围：320）",
}

--PVP孙策
_tab_stringS[21352] = {"霸气剑光（竞技场）",
	"随机在目标地点80范围内召唤6把落剑，每一把落剑都对小范围敌人造成攻击力80％+60点的物理伤害。\n（施法范围：200）",
	"随机在目标地点80范围内召唤7把落剑，每一把落剑都对小范围敌人造成攻击力90％+75点的物理伤害。\n（施法范围：200）",
	"随机在目标地点80范围内召唤8把落剑，每一把落剑都对小范围敌人造成攻击力100％+90点的物理伤害。\n（施法范围：200）",
	"随机在目标地点80范围内召唤9把落剑，每一把落剑都对小范围敌人造成攻击力110％+105点的物理伤害。\n（施法范围：200）",
	"随机在目标地点80范围内召唤10把落剑，每一把落剑都对小范围敌人造成攻击力120％+120点的物理伤害。\n（施法范围：200）",
	"随机在目标地点80范围内召唤11把落剑，每一把落剑都对小范围敌人造成攻击力130％+135点的物理伤害。\n（施法范围：200）",
	"随机在目标地点80范围内召唤12把落剑，每一把落剑都对小范围敌人造成攻击力140％+150点的物理伤害。\n（施法范围：200）",
	"随机在目标地点80范围内召唤13把落剑，每一把落剑都对小范围敌人造成攻击力150％+165点的物理伤害。\n（施法范围：200）",
	"随机在目标地点80范围内召唤14把落剑，每一把落剑都对小范围敌人造成攻击力160％+180点的物理伤害。\n（施法范围：200）",
	"随机在目标地点80范围内召唤15把落剑，每一把落剑都对小范围敌人造成攻击力170％+195点的物理伤害。\n（施法范围：200）",
	"随机在目标地点80范围内召唤16把落剑，每一把落剑都对小范围敌人造成攻击力180％+210点的物理伤害。\n（施法范围：200）",
	"随机在目标地点80范围内召唤17把落剑，每一把落剑都对小范围敌人造成攻击力190％+225点的物理伤害。\n（施法范围：200）",
	"随机在目标地点80范围内召唤18把落剑，每一把落剑都对小范围敌人造成攻击力200％+240点的物理伤害。\n（施法范围：200）",
	"随机在目标地点80范围内召唤19把落剑，每一把落剑都对小范围敌人造成攻击力210％+255点的物理伤害。\n（施法范围：200）",
	"随机在目标地点80范围内召唤20把落剑，每一把落剑都对小范围敌人造成攻击力220％+270点的物理伤害。\n（施法范围：200）",
}


--PVP周瑜战术技能
_tab_stringS[21371] = {"召唤水兵（竞技场）",
	"召唤4个420点生命、22-27点攻击力、10点物理防御、0点法术防御的水兵为你战斗。水兵存在15秒。\n（施法范围：150）",
	"召唤4个640点生命、40-57点攻击力、14点物理防御、0点法术防御的水兵为你战斗。水兵存在15秒。\n（施法范围：150）",
	"召唤4个860点生命、58-87点攻击力、18点物理防御、0点法术防御的水兵为你战斗。水兵存在15秒。\n（施法范围：150）",
	"召唤4个1080点生命、76-117点攻击力、22点物理防御、0点法术防御的水兵为你战斗。水兵存在15秒。\n（施法范围：150）",
	"召唤4个1300点生命、94-147点攻击力、26点物理防御、0点法术防御的水兵为你战斗。水兵存在15秒。\n（施法范围：150）",
	"召唤4个1520点生命、112-177点攻击力、30点物理防御、0点法术防御的水兵为你战斗。水兵存在15秒。\n（施法范围：150）",
	"召唤4个1740点生命、130-207点攻击力、34点物理防御、0点法术防御的水兵为你战斗。水兵存在15秒。\n（施法范围：150）",
	"召唤4个1960点生命、148-237点攻击力、38点物理防御、0点法术防御的水兵为你战斗。水兵存在15秒。\n（施法范围：150）",
	"召唤4个2180点生命、166-267点攻击力、42点物理防御、0点法术防御的水兵为你战斗。水兵存在15秒。\n（施法范围：150）",
	"召唤4个2400点生命、184-297点攻击力、46点物理防御、0点法术防御的水兵为你战斗。水兵存在15秒。\n（施法范围：150）",
	"召唤4个2620点生命、202-327点攻击力、50点物理防御、0点法术防御的水兵为你战斗。水兵存在15秒。\n（施法范围：150）",
	"召唤4个2840点生命、220-357点攻击力、54点物理防御、0点法术防御的水兵为你战斗。水兵存在15秒。\n（施法范围：150）",
	"召唤4个3060点生命、238-387点攻击力、58点物理防御、0点法术防御的水兵为你战斗。水兵存在15秒。\n（施法范围：150）",
	"召唤4个3280点生命、256-417点攻击力、62点物理防御、0点法术防御的水兵为你战斗。水兵存在15秒。\n（施法范围：150）",
	"召唤4个3500点生命、274-447点攻击力、66点物理防御、0点法术防御的水兵为你战斗。水兵存在15秒。\n（施法范围：150）",
}

_tab_stringS[22002] = {"蛇毒（竞技场）",
	"升级后在箭矢上涂抹蛇毒，让敌人变得无力，降低目标的移动速度和攻击速度，并每秒受到目标最大生命值一定比例的真实伤害，持续4秒。",
	"每秒造成目标最大生命值2％的伤害。降低20％移速和40％攻速。",
	"每秒造成目标最大生命值4％的伤害。降低25％移速和50％攻速。",
	"每秒造成目标最大生命值6％的伤害。降低30％移速和60％攻速。",
	"每秒造成目标最大生命值8％的伤害。降低35％移速和70％攻速。",
	"每秒造成目标最大生命值10％的伤害。降低40％移速和80％攻速。",
}
_tab_stringS[22003] = {"蝎毒（竞技场）",
	"升级后在箭矢上涂抹蝎毒，让敌人变得衰弱，降低目标的物理防御和法术防御，并每秒受到目标最大生命值一定比例的真实伤害，持续4秒。",
	"每秒造成目标最大生命值2％的伤害。降低10点物防和法防。",
	"每秒造成目标最大生命值4％的伤害。降低15点物防和法防。",
	"每秒造成目标最大生命值6％的伤害。降低20点物防和法防。",
	"每秒造成目标最大生命值8％的伤害。降低25点物防和法防。",
	"每秒造成目标最大生命值10％的伤害。降低30点物防和法防。",
}

_tab_stringS[22062] = {"远射（竞技场）",
	"升级后大幅增加狙击塔的射程。",
	"增加120码射程。",
	"增加240码射程。",
	"增加360码射程。",
	"增加480码射程。",
	"增加600码射程。",
}

_tab_stringS[22063] = {"穿心一击",
	"升级后增加狙击塔的暴击几率，打出2倍伤害。并有一定的几率直接消灭低血量的敌人。（主将除外）",
	"10％几率暴击。9％几率击倒血量低于300的敌人。",
	"15％几率暴击。12％几率击倒血量低于400的敌人。",
	"20％几率暴击。15％几率击倒血量低于500的敌人。",
	"25％几率暴击。18％几率击倒血量低于600的敌人。",
	"30％几率暴击。21％几率击倒血量低于700的敌人。",
}

------------------------------------------------------------------------
--pvp英雄技能
_tab_stringS[24015] =
{
	"援军（竞技场）",
	"召唤4个240点生命、12-16点攻击力、10点物理防御、2点法术防御的民兵为你战斗。民兵存在55秒。\n（施法范围：150）",
	"召唤4个420点生命、28-40点攻击力、12点物理防御、3点法术防御的民兵为你战斗。民兵存在55秒。\n（施法范围：150）",
	"召唤4个600点生命、44-64点攻击力、14点物理防御、4点法术防御的民兵为你战斗。民兵存在55秒。\n（施法范围：150）",
	"召唤4个780点生命、60-88点攻击力、16点物理防御、5点法术防御的民兵为你战斗。民兵存在55秒。\n（施法范围：150）",
	"召唤4个960点生命、76-112点攻击力、18点物理防御、6点法术防御的民兵为你战斗。民兵存在55秒。\n（施法范围：150）",
	"召唤4个1140点生命、92-136点攻击力、20点物理防御、7点法术防御的民兵为你战斗。民兵存在55秒。\n（施法范围：150）",
	"召唤4个1320点生命、108-150点攻击力、22点物理防御、8点法术防御的民兵为你战斗。民兵存在55秒。\n（施法范围：150）",
	"召唤4个1500点生命、124-174点攻击力、24点物理防御、9点法术防御的民兵为你战斗。民兵存在55秒。\n（施法范围：150）",
	"召唤4个1680点生命、140-198点攻击力、26点物理防御、10点法术防御的民兵为你战斗。民兵存在55秒。\n（施法范围：150）",
	"召唤4个1860点生命、156-222点攻击力、28点物理防御、11点法术防御的民兵为你战斗。民兵存在55秒。\n（施法范围：150）",
	"召唤4个2040点生命、172-246点攻击力、30点物理防御、12点法术防御的民兵为你战斗。民兵存在55秒。\n（施法范围：150）",
	"召唤4个2220点生命、188-270点攻击力、32点物理防御、13点法术防御的民兵为你战斗。民兵存在55秒。\n（施法范围：150）",
	"召唤4个2400点生命、204-294点攻击力、34点物理防御、14点法术防御的民兵为你战斗。民兵存在55秒。\n（施法范围：150）",
	"召唤4个2580点生命、220-318点攻击力、36点物理防御、15点法术防御的民兵为你战斗。民兵存在55秒。\n（施法范围：150）",
	"召唤4个2760点生命、236-342点攻击力、38点物理防御、16点法术防御的民兵为你战斗。民兵存在55秒。\n（施法范围：150）",
}

_tab_stringS[24021] =
{
	"燕人咆哮",
	"发出恐怖的咆哮，对自身135范围内的敌人造成攻击力120％+60点的真实伤害，并混乱2秒。混乱期间目标不受操控并四处乱走。",
	"发出恐怖的咆哮，对自身135范围内的敌人造成攻击力140％+80点的真实伤害，并混乱2.2秒。混乱期间目标不受操控并四处乱走。",
	"发出恐怖的咆哮，对自身135范围内的敌人造成攻击力160％+100点的真实伤害，并混乱2.4秒。混乱期间目标不受操控并四处乱走。",
	"发出恐怖的咆哮，对自身135范围内的敌人造成攻击力180％+120点的真实伤害，并混乱2.6秒。混乱期间目标不受操控并四处乱走。",
	"发出恐怖的咆哮，对自身135范围内的敌人造成攻击力200％+140点的真实伤害，并混乱2.8秒。混乱期间目标不受操控并四处乱走。",
	"发出恐怖的咆哮，对自身135范围内的敌人造成攻击力220％+160点的真实伤害，并混乱3秒。混乱期间目标不受操控并四处乱走。",
	"发出恐怖的咆哮，对自身135范围内的敌人造成攻击力240％+180点的真实伤害，并混乱3.2秒。混乱期间目标不受操控并四处乱走。",
	"发出恐怖的咆哮，对自身135范围内的敌人造成攻击力260％+200点的真实伤害，并混乱3.4秒。混乱期间目标不受操控并四处乱走。",
	"发出恐怖的咆哮，对自身135范围内的敌人造成攻击力280％+220点的真实伤害，并混乱3.6秒。混乱期间目标不受操控并四处乱走。",
	"发出恐怖的咆哮，对自身135范围内的敌人造成攻击力300％+240点的真实伤害，并混乱3.8秒。混乱期间目标不受操控并四处乱走。",
	"发出恐怖的咆哮，对自身135范围内的敌人造成攻击力320％+260点的真实伤害，并混乱4秒。混乱期间目标不受操控并四处乱走。",
	"发出恐怖的咆哮，对自身135范围内的敌人造成攻击力340％+280点的真实伤害，并混乱4.2秒。混乱期间目标不受操控并四处乱走。",
	"发出恐怖的咆哮，对自身135范围内的敌人造成攻击力360％+300点的真实伤害，并混乱4.4秒。混乱期间目标不受操控并四处乱走。",
	"发出恐怖的咆哮，对自身135范围内的敌人造成攻击力380％+320点的真实伤害，并混乱4.6秒。混乱期间目标不受操控并四处乱走。",
	"发出恐怖的咆哮，对自身135范围内的敌人造成攻击力400％+340点的真实伤害，并混乱4.8秒。混乱期间目标不受操控并四处乱走。",
}

_tab_stringS[24023] = {"全军突击（竞技场）",
	"提升自己和附近120范围内的友军12％的移动速度、攻击速度、射程，持续7秒。",
	"提升自己和附近120范围内的友军13％的移动速度、攻击速度、射程，持续7秒。",
	"提升自己和附近120范围内的友军14％的移动速度、攻击速度、射程，持续7秒。",
	"提升自己和附近120范围内的友军15％的移动速度、攻击速度、射程，持续7秒。",
	"提升自己和附近120范围内的友军16％的移动速度、攻击速度、射程，持续7秒。",
	"提升自己和附近120范围内的友军17％的移动速度、攻击速度、射程，持续7秒。",
	"提升自己和附近120范围内的友军18％的移动速度、攻击速度、射程，持续7秒。",
	"提升自己和附近120范围内的友军19％的移动速度、攻击速度、射程，持续7秒。",
	"提升自己和附近120范围内的友军20％的移动速度、攻击速度、射程，持续7秒。",
	"提升自己和附近120范围内的友军21％的移动速度、攻击速度、射程，持续7秒。",
	"提升自己和附近120范围内的友军22％的移动速度、攻击速度、射程，持续7秒。",
	"提升自己和附近120范围内的友军23％的移动速度、攻击速度、射程，持续7秒。",
	"提升自己和附近120范围内的友军24％的移动速度、攻击速度、射程，持续7秒。",
	"提升自己和附近120范围内的友军25％的移动速度、攻击速度、射程，持续7秒。",
	"提升自己和附近120范围内的友军26％的移动速度、攻击速度、射程，持续7秒。",
}

_tab_stringS[24025] =
{
	"军令如山（竞技场）",
	"召唤3个150点生命、16-24点攻击力、3点物理防御、10点法术防御的弓箭手为你战斗。弓箭手存在25秒。\n（施法范围：150）",
	"召唤3个225点生命、30-56点攻击力、4点物理防御、13点法术防御的弓箭手为你战斗。弓箭手存在25秒。\n（施法范围：150）",
	"召唤3个300点生命、54-88点攻击力、5点物理防御、16点法术防御的弓箭手为你战斗。弓箭手存在25秒。\n（施法范围：150）",
	"召唤3个375点生命、78-120点攻击力、6点物理防御、19点法术防御的弓箭手为你战斗。弓箭手存在25秒。\n（施法范围：150）",
	"召唤3个450点生命、102-152点攻击力、7点物理防御、22点法术防御的弓箭手为你战斗。弓箭手存在25秒。\n（施法范围：150）",
	"召唤3个525点生命、126-184点攻击力、8点物理防御、25点法术防御的弓箭手为你战斗。弓箭手存在25秒。\n（施法范围：150）",
	"召唤3个600点生命、150-216点攻击力、9点物理防御、28点法术防御的弓箭手为你战斗。弓箭手存在25秒。\n（施法范围：150）",
	"召唤3个675点生命、174-248点攻击力、10点物理防御、31点法术防御的弓箭手为你战斗。弓箭手存在25秒。\n（施法范围：150）",
	"召唤3个750点生命、198-280点攻击力、11点物理防御、34点法术防御的弓箭手为你战斗。弓箭手存在25秒。\n（施法范围：150）",
	"召唤3个825点生命、222-312点攻击力、12点物理防御、37点法术防御的弓箭手为你战斗。弓箭手存在25秒。\n（施法范围：150）",
	"召唤3个900点生命、246-344点攻击力、13点物理防御、40点法术防御的弓箭手为你战斗。弓箭手存在25秒。\n（施法范围：150）",
	"召唤3个975点生命、270-376点攻击力、14点物理防御、43点法术防御的弓箭手为你战斗。弓箭手存在25秒。\n（施法范围：150）",
	"召唤3个1050点生命、294-408点攻击力、15点物理防御、46点法术防御的弓箭手为你战斗。弓箭手存在25秒。\n（施法范围：150）",
	"召唤3个1125点生命、318-440点攻击力、16点物理防御、49点法术防御的弓箭手为你战斗。弓箭手存在25秒。\n（施法范围：150）",
	"召唤3个1200点生命、342-472点攻击力、17点物理防御、52点法术防御的弓箭手为你战斗。弓箭手存在25秒。\n（施法范围：150）",
}

_tab_stringS[24026] =
{
	"冰河爆裂破（竞技场）",
	"发动连续的冰暴轰炸，对一直线地面上的敌人造成攻击力115％+180点的法术伤害，并冻结2.8秒。\n（施法范围：400）",
	"发动连续的冰暴轰炸，对一直线地面上的敌人造成攻击力130％+210点的法术伤害，并冻结2.9秒。\n（施法范围：400）",
	"发动连续的冰暴轰炸，对一直线地面上的敌人造成攻击力145％+240点的法术伤害，并冻结3秒。\n（施法范围：400）",
	"发动连续的冰暴轰炸，对一直线地面上的敌人造成攻击力160％+270点的法术伤害，并冻结3.1秒。\n（施法范围：400）",
	"发动连续的冰暴轰炸，对一直线地面上的敌人造成攻击力175％+300点的法术伤害，并冻结3.2秒。\n（施法范围：400）",
	"发动连续的冰暴轰炸，对一直线地面上的敌人造成攻击力190％+330点的法术伤害，并冻结3.3秒。\n（施法范围：400）",
	"发动连续的冰暴轰炸，对一直线地面上的敌人造成攻击力205％+360点的法术伤害，并冻结3.4秒。\n（施法范围：400）",
	"发动连续的冰暴轰炸，对一直线地面上的敌人造成攻击力220％+390点的法术伤害，并冻结3.5秒。\n（施法范围：400）",
	"发动连续的冰暴轰炸，对一直线地面上的敌人造成攻击力235％+420点的法术伤害，并冻结3.6秒。\n（施法范围：400）",
	"发动连续的冰暴轰炸，对一直线地面上的敌人造成攻击力250％+450点的法术伤害，并冻结3.7秒。\n（施法范围：400）",
	"发动连续的冰暴轰炸，对一直线地面上的敌人造成攻击力265％+480点的法术伤害，并冻结3.8秒。\n（施法范围：400）",
	"发动连续的冰暴轰炸，对一直线地面上的敌人造成攻击力280％+510点的法术伤害，并冻结3.9秒。\n（施法范围：400）",
	"发动连续的冰暴轰炸，对一直线地面上的敌人造成攻击力295％+540点的法术伤害，并冻结4秒。\n（施法范围：400）",
	"发动连续的冰暴轰炸，对一直线地面上的敌人造成攻击力310％+570点的法术伤害，并冻结4.1秒。\n（施法范围：400）",
	"发动连续的冰暴轰炸，对一直线地面上的敌人造成攻击力325％+600点的法术伤害，并冻结4.2秒。\n（施法范围：400）",
}

_tab_stringS[24040] = {"无双分身（竞技场）",
	"召唤1个1000点生命、15点攻击、10点物理防御、2点法术防御、拥有嘲讽、七探蛇盘枪技能的分身为你战斗。分身存在12秒。\n（施法范围：200）",
	"召唤1个1100点生命、20点攻击、12点物理防御、3点法术防御、拥有嘲讽、七探蛇盘枪技能的分身为你战斗。分身存在12秒。\n（施法范围：200）",
	"召唤1个1200点生命、25点攻击、14点物理防御、4点法术防御、拥有嘲讽、七探蛇盘枪技能的分身为你战斗。分身存在12秒。\n（施法范围：200）",
	"召唤1个1300点生命、30点攻击、16点物理防御、5点法术防御、拥有嘲讽、七探蛇盘枪技能的分身为你战斗。分身存在12秒。\n（施法范围：200）",
	"召唤1个1400点生命、35点攻击、18点物理防御、6点法术防御、拥有嘲讽、七探蛇盘枪技能的分身为你战斗。分身存在12秒。\n（施法范围：200）",
	"召唤1个1500点生命、40点攻击、20点物理防御、7点法术防御、拥有嘲讽、七探蛇盘枪技能的分身为你战斗。分身存在12秒。\n（施法范围：200）",
	"召唤1个1600点生命、45点攻击、22点物理防御、8点法术防御、拥有嘲讽、七探蛇盘枪技能的分身为你战斗。分身存在12秒。\n（施法范围：200）",
	"召唤1个1700点生命、50点攻击、24点物理防御、9点法术防御、拥有嘲讽、七探蛇盘枪技能的分身为你战斗。分身存在12秒。\n（施法范围：200）",
	"召唤1个1800点生命、55点攻击、26点物理防御、10点法术防御、拥有嘲讽、七探蛇盘枪技能的分身为你战斗。分身存在12秒。\n（施法范围：200）",
	"召唤1个1900点生命、60点攻击、28点物理防御、11点法术防御、拥有嘲讽、七探蛇盘枪技能的分身为你战斗。分身存在12秒。\n（施法范围：200）",
	"召唤1个2000点生命、65点攻击、30点物理防御、12点法术防御、拥有嘲讽、七探蛇盘枪技能的分身为你战斗。分身存在12秒。\n（施法范围：200）",
	"召唤1个2100点生命、70点攻击、32点物理防御、13点法术防御、拥有嘲讽、七探蛇盘枪技能的分身为你战斗。分身存在12秒。\n（施法范围：200）",
	"召唤1个2200点生命、75点攻击、34点物理防御、14点法术防御、拥有嘲讽、七探蛇盘枪技能的分身为你战斗。分身存在12秒。\n（施法范围：200）",
	"召唤1个2300点生命、80点攻击、36点物理防御、15点法术防御、拥有嘲讽、七探蛇盘枪技能的分身为你战斗。分身存在12秒。\n（施法范围：200）",
	"召唤1个2400点生命、85点攻击、38点物理防御、16点法术防御、拥有嘲讽、七探蛇盘枪技能的分身为你战斗。分身存在12秒。\n（施法范围：200）",
}

_tab_stringS[24041] = {
	"星轮斩",
	"同时发出5道月轮，每道都对一条直线上碰到的敌人造成攻击力120％+30点的物理伤害。",
	"同时发出5道月轮，每道都对一条直线上碰到的敌人造成攻击力130％+40点的物理伤害。",
	"同时发出5道月轮，每道都对一条直线上碰到的敌人造成攻击力140％+50点的物理伤害。",
	"同时发出5道月轮，每道都对一条直线上碰到的敌人造成攻击力150％+60点的物理伤害。",
	"同时发出5道月轮，每道都对一条直线上碰到的敌人造成攻击力160％+70点的物理伤害。",
	"同时发出5道月轮，每道都对一条直线上碰到的敌人造成攻击力170％+80点的物理伤害。",
	"同时发出5道月轮，每道都对一条直线上碰到的敌人造成攻击力180％+90点的物理伤害。",
	"同时发出5道月轮，每道都对一条直线上碰到的敌人造成攻击力190％+100点的物理伤害。",
	"同时发出5道月轮，每道都对一条直线上碰到的敌人造成攻击力200％+110点的物理伤害。",
	"同时发出5道月轮，每道都对一条直线上碰到的敌人造成攻击力210％+120点的物理伤害。",
	"同时发出5道月轮，每道都对一条直线上碰到的敌人造成攻击力220％+130点的物理伤害。",
	"同时发出5道月轮，每道都对一条直线上碰到的敌人造成攻击力230％+140点的物理伤害。",
	"同时发出5道月轮，每道都对一条直线上碰到的敌人造成攻击力240％+150点的物理伤害。",
	"同时发出5道月轮，每道都对一条直线上碰到的敌人造成攻击力250％+160点的物理伤害。",
	"同时发出5道月轮，每道都对一条直线上碰到的敌人造成攻击力260％+170点的物理伤害。",
}
_tab_stringS[24076] = {"机关弩炮（竞技场）",
	"放置2台160点生命、15-24点攻击力、240码射程、20点物理防御、-60点法术防御的机关弩炮为你战斗。机关弩炮附加黄月英20％的攻击力。机关弩炮存在15秒。\n（施法范围：180）",
	"放置2台240点生命、20-32点攻击力、240码射程、25点物理防御、-60点法术防御的机关弩炮为你战斗。机关弩炮附加黄月英20％的攻击力。机关弩炮存在15秒。\n（施法范围：180）",
	"放置2台320点生命、25-40点攻击力、240码射程、30点物理防御、-60点法术防御的机关弩炮为你战斗。机关弩炮附加黄月英20％的攻击力。机关弩炮存在15秒。\n（施法范围：180）",
	"放置2台400点生命、30-48点攻击力、240码射程、35点物理防御、-60点法术防御的机关弩炮为你战斗。机关弩炮附加黄月英20％的攻击力。机关弩炮存在15秒。\n（施法范围：180）",
	"放置2台480点生命、35-56点攻击力、240码射程、40点物理防御、-60点法术防御的机关弩炮为你战斗。机关弩炮附加黄月英20％的攻击力。机关弩炮存在15秒。\n（施法范围：180）",
	"放置2台560点生命、40-64点攻击力、240码射程、45点物理防御、-60点法术防御的机关弩炮为你战斗。机关弩炮附加黄月英20％的攻击力。机关弩炮存在15秒。\n（施法范围：180）",
	"放置2台640点生命、45-72点攻击力、240码射程、50点物理防御、-60点法术防御的机关弩炮为你战斗。机关弩炮附加黄月英20％的攻击力。机关弩炮存在15秒。\n（施法范围：180）",
	"放置2台720点生命、50-80点攻击力、240码射程、55点物理防御、-60点法术防御的机关弩炮为你战斗。机关弩炮附加黄月英20％的攻击力。机关弩炮存在15秒。\n（施法范围：180）",
	"放置2台800点生命、55-88点攻击力、240码射程、60点物理防御、-60点法术防御的机关弩炮为你战斗。机关弩炮附加黄月英20％的攻击力。机关弩炮存在15秒。\n（施法范围：180）",
	"放置2台880点生命、60-96点攻击力、240码射程、65点物理防御、-60点法术防御的机关弩炮为你战斗。机关弩炮附加黄月英20％的攻击力。机关弩炮存在15秒。\n（施法范围：180）",
	"放置2台960点生命、65-104点攻击力、240码射程、70点物理防御、-60点法术防御的机关弩炮为你战斗。机关弩炮附加黄月英20％的攻击力。机关弩炮存在15秒。\n（施法范围：180）",
	"放置2台1040点生命、70-112点攻击力、240码射程、75点物理防御、-60点法术防御的机关弩炮为你战斗。机关弩炮附加黄月英20％的攻击力。机关弩炮存在15秒。\n（施法范围：180）",
	"放置2台1120点生命、75-120点攻击力、240码射程、80点物理防御、-60点法术防御的机关弩炮为你战斗。机关弩炮附加黄月英20％的攻击力。机关弩炮存在15秒。\n（施法范围：180）",
	"放置2台1200点生命、80-128点攻击力、240码射程、85点物理防御、-60点法术防御的机关弩炮为你战斗。机关弩炮附加黄月英20％的攻击力。机关弩炮存在15秒。\n（施法范围：180）",
	"放置2台1280点生命、85-136点攻击力、240码射程、90点物理防御、-60点法术防御的机关弩炮为你战斗。机关弩炮附加黄月英20％的攻击力。机关弩炮存在15秒。\n（施法范围：180）",
}

_tab_stringS[30008] = {"擂鼓振奋",
	"擂鼓塔初始自带该技能，每15秒发动振奋，提升自身附近250范围内所有友方塔30％的攻击速度，持续9秒。\n升级后每次振奋可提升更多的攻击速度。",
	"每次振奋提升55％的攻击速度。",
	"每次振奋提升80％的攻击速度。",
	"每次振奋提升105％的攻击速度。",
	"每次振奋提升130％的攻击速度。",
	"每次振奋提升155％的攻击速度。",
}

_tab_stringS[30009] = {"疗伤术",
	"擂鼓塔初始自带该技能，每秒回复自身附近250范围内的一名友方英雄10点生命值。\n升级后每秒可回复更多的生命值。",
	"每秒回复20点生命值。",
	"每秒回复30点生命值。",
	"每秒回复40点生命值。",
	"每秒回复50点生命值。",
	"每秒回复60点生命值。",
}

_tab_stringS[30010] = {"痛苦延伸",
	"升级后增加地刺塔每次攻击穿出尖刺的数量，同时每道尖刺造成额外的物理伤害。",
	"穿出5道尖刺。每道尖刺额外造成攻击力10％的伤害。",
	"穿出6道尖刺。每道尖刺额外造成攻击力20％的伤害。",
	"穿出7道尖刺。每道尖刺额外造成攻击力30％的伤害。",
	"穿出8道尖刺。每道尖刺额外造成攻击力40％的伤害。",
	"穿出9道尖刺。每道尖刺额外造成攻击力50％的伤害。",
}

_tab_stringS[30011] = {"刺骨长钉",
	"升级后地刺塔每8秒会向四周发散出一片大范围的穿刺，对地刺塔周围150范围内地面上的敌人造成物理伤害，并将敌人抛向空中，落地后继续眩晕。",
	"造成攻击力150％的群伤。眩晕3秒。",
	"造成攻击力175％的群伤。眩晕3.5秒。",
	"造成攻击力200％的群伤。眩晕4秒。",
	"造成攻击力225％的群伤。眩晕4.5秒。",
	"造成攻击力250％的群伤。眩晕5秒。",
}

_tab_stringS[32153] = {"穿心一击",
	"升级后增加狙击塔的暴击几率，打出2倍伤害。并有一定的几率直接消灭低血量的敌人。",
	"25％几率暴击。40％几率消灭当前血量低于400点的敌人。",
}

_tab_stringS[32155] = {"强化散弹",
	"升级后提升轰天塔每个散弹的威力，同时增加每次发射的散弹数量。",
	"增加5～8点攻击力。增加3发散弹。",
}

_tab_stringS[32156] = {"强化击退",
	"升级后滚石对碰到的地面上的敌人造成更大的击退，目标沿着滚石运动的方向，被推开一段距离。击退期间目标不能攻击、移动、释放技能。",
	"额外击退敌人40码的距离，持续0.4秒。",
}

_tab_stringS[32157] = {"刺骨长钉",
	"升级后地刺塔每次攻击额外穿出3道尖刺。同时地刺塔每8秒会向四周发散出一片大范围的穿刺，对地刺塔周围150范围内地面上的敌人造成法术伤害，并将敌人抛向空中，落地后继续眩晕。",
	"造成100点伤害。眩晕3秒。",
}







--=============================================================================================--

_tab_stringT[1002] = {"威吓",
	"减少敌人8％生命上限。",
	"减少敌人11％生命上限。",
	"减少敌人14％生命上限。",
	"减少敌人17％生命上限。",
	"减少敌人20％生命上限。",
	"减少敌人23％生命上限。",
	"减少敌人26％生命上限。",
	"减少敌人29％生命上限。",
	"减少敌人32％生命上限。",
	"减少敌人35％生命上限。",
}

_tab_stringT[1003] = {"练兵",
	"每局战斗我方出战的英雄获得1.5倍经验。",
	"每局战斗我方出战的英雄获得2倍经验。",
	"每局战斗我方出战的英雄获得2.5倍经验。",
	"每局战斗我方出战的英雄获得3倍经验。",
	"每局战斗我方出战的英雄获得3.5倍经验。",
}

_tab_stringT[1004] = {"征收",
	"每回合开始时额外获得10金。",
	"每回合开始时额外获得20金。",
	"每回合开始时额外获得30金。",
	"每回合开始时额外获得40金。",
	"每回合开始时额外获得50金。",
	"每回合开始时额外获得60金。",
	"每回合开始时额外获得70金。",
	"每回合开始时额外获得80金。",
	"每回合开始时额外获得90金。",
	"每回合开始时额外获得100金。",
}


_tab_stringT[1005] = {"桃园结义",
	"我方英雄回血速度+6点/秒。",
	"我方英雄回血速度+12点/秒。",
	"我方英雄回血速度+18点/秒。",
	"我方英雄回血速度+24点/秒。",
	"我方英雄回血速度+30点/秒。",
	"我方英雄回血速度+36点/秒。",
	"我方英雄回血速度+42点/秒。",
	"我方英雄回血速度+48点/秒。",
	"我方英雄回血速度+54点/秒。",
	"我方英雄回血速度+60点/秒。",
}


_tab_stringT[1006] = {"箭矢改良",
	"箭塔获得+1攻击，+5射程。",
	"箭塔获得+2攻击，+10射程。",
	"箭塔获得+3攻击，+15射程。",
	"箭塔获得+4攻击，+20射程。",
	"箭塔获得+5攻击，+25射程。",
	"箭塔获得+6攻击，+30射程。",
	"箭塔获得+7攻击，+35射程。",
	"箭塔获得+8攻击，+40射程。",
	"箭塔获得+9攻击，+45射程。",
	"箭塔获得+10攻击，+50射程。",
}


_tab_stringT[1007] = {"箭矢改良",
	"箭塔获得+1攻击，+5射程。",

}

_tab_stringT[1008] = {"箭雨",
	"箭塔获得+1攻击，+5射程。",

}

_tab_stringT[1009] = {"箭矢改良",
	"箭塔获得+1攻击，+5射程。",
}


_tab_stringT[1011] = {"剧毒塔",
	"射出带毒的箭矢，每秒造成攻击力60％的真实伤害，持续5秒。",
	"射出带毒的箭矢，每秒造成攻击力60％的真实伤害，持续5秒。",
	"射出带毒的箭矢，每秒造成攻击力60％的真实伤害，持续5秒。",
	"射出带毒的箭矢，每秒造成攻击力60％的真实伤害，持续5秒。",
	"射出带毒的箭矢，每秒造成攻击力60％的真实伤害，持续5秒。",
	"射出带毒的箭矢，每秒造成攻击力60％的真实伤害，持续5秒。",
	"射出带毒的箭矢，每秒造成攻击力60％的真实伤害，持续5秒。",
	"射出带毒的箭矢，每秒造成攻击力60％的真实伤害，持续5秒。",
	"射出带毒的箭矢，每秒造成攻击力60％的真实伤害，持续5秒。",
	"射出带毒的箭矢，每秒造成攻击力60％的真实伤害，持续5秒。",
}

_tab_stringT[1012] = {"巨炮塔",
	"经过改造后的巨型炮塔，每次攻击发射一颗威力巨大的炮弹。",
	"经过改造后的巨型炮塔，每次攻击发射一颗威力巨大的炮弹。",
	"经过改造后的巨型炮塔，每次攻击发射一颗威力巨大的炮弹。",
	"经过改造后的巨型炮塔，每次攻击发射一颗威力巨大的炮弹。",
	"经过改造后的巨型炮塔，每次攻击发射一颗威力巨大的炮弹。",
	"经过改造后的巨型炮塔，每次攻击发射一颗威力巨大的炮弹。",
	"经过改造后的巨型炮塔，每次攻击发射一颗威力巨大的炮弹。",
	"经过改造后的巨型炮塔，每次攻击发射一颗威力巨大的炮弹。",
	"经过改造后的巨型炮塔，每次攻击发射一颗威力巨大的炮弹。",
	"经过改造后的巨型炮塔，每次攻击发射一颗威力巨大的炮弹。",
}

_tab_stringT[1013] = {"火焰塔",
	"以凶兽祸斗的妖火精华炼制的法术塔。每次攻击同时发射两个火球。",
	"以凶兽祸斗的妖火精华炼制的法术塔。每次攻击同时发射两个火球。",
	"以凶兽祸斗的妖火精华炼制的法术塔。每次攻击同时发射两个火球。",
	"以凶兽祸斗的妖火精华炼制的法术塔。每次攻击同时发射两个火球。",
	"以凶兽祸斗的妖火精华炼制的法术塔。每次攻击同时发射两个火球。",
	"以凶兽祸斗的妖火精华炼制的法术塔。每次攻击同时发射两个火球。",
	"以凶兽祸斗的妖火精华炼制的法术塔。每次攻击同时发射两个火球。",
	"以凶兽祸斗的妖火精华炼制的法术塔。每次攻击同时发射两个火球。",
	"以凶兽祸斗的妖火精华炼制的法术塔。每次攻击同时发射两个火球。",
	"以凶兽祸斗的妖火精华炼制的法术塔。每次攻击同时发射两个火球。",
}

_tab_stringT[1014] = {"连弩塔",
	"射速极快的箭塔。有10％的几率连射出3支弩箭。",
	"射速极快的箭塔。有10％的几率连射出3支弩箭。",
	"射速极快的箭塔。有10％的几率连射出3支弩箭。",
	"射速极快的箭塔。有10％的几率连射出3支弩箭。",
	"射速极快的箭塔。有10％的几率连射出3支弩箭。",
	"射速极快的箭塔。有10％的几率连射出3支弩箭。",
	"射速极快的箭塔。有10％的几率连射出3支弩箭。",
	"射速极快的箭塔。有10％的几率连射出3支弩箭。",
	"射速极快的箭塔。有10％的几率连射出3支弩箭。",
	"射速极快的箭塔。有10％的几率连射出3支弩箭。",
}

_tab_stringT[1015] = {"寒冰塔",
	"散发着寒气的法术塔。每次攻击附带减速，降低目标40％的移动速度，持续4秒。",
	"散发着寒气的法术塔。每次攻击附带减速，降低目标42％的移动速度，持续4秒。",
	"散发着寒气的法术塔。每次攻击附带减速，降低目标44％的移动速度，持续4秒。",
	"散发着寒气的法术塔。每次攻击附带减速，降低目标46％的移动速度，持续4秒。",
	"散发着寒气的法术塔。每次攻击附带减速，降低目标48％的移动速度，持续4秒。",
	"散发着寒气的法术塔。每次攻击附带减速，降低目标50％的移动速度，持续4秒。",
	"散发着寒气的法术塔。每次攻击附带减速，降低目标52％的移动速度，持续4秒。",
	"散发着寒气的法术塔。每次攻击附带减速，降低目标54％的移动速度，持续4秒。",
	"散发着寒气的法术塔。每次攻击附带减速，降低目标56％的移动速度，持续4秒。",
	"散发着寒气的法术塔。每次攻击附带减速，降低目标58％的移动速度，持续4秒。",
}

_tab_stringT[1016] = {"天雷塔",
	"蕴含天雷之力的法术塔。每次攻击释放电弧，电晕目标0.2秒。（主将除外）",
	"蕴含天雷之力的法术塔。每次攻击释放电弧，电晕目标0.2秒。（主将除外）",
	"蕴含天雷之力的法术塔。每次攻击释放电弧，电晕目标0.2秒。（主将除外）",
	"蕴含天雷之力的法术塔。每次攻击释放电弧，电晕目标0.2秒。（主将除外）",
	"蕴含天雷之力的法术塔。每次攻击释放电弧，电晕目标0.2秒。（主将除外）",
	"蕴含天雷之力的法术塔。每次攻击释放电弧，电晕目标0.2秒。（主将除外）",
	"蕴含天雷之力的法术塔。每次攻击释放电弧，电晕目标0.2秒。（主将除外）",
	"蕴含天雷之力的法术塔。每次攻击释放电弧，电晕目标0.2秒。（主将除外）",
	"蕴含天雷之力的法术塔。每次攻击释放电弧，电晕目标0.2秒。（主将除外）",
	"蕴含天雷之力的法术塔。每次攻击释放电弧，电晕目标0.2秒。（主将除外）",
}

_tab_stringT[1017] = {"狙击塔",
	"攻速很慢，但是攻击力超高、射程超远的箭塔。",
	"攻速很慢，但是攻击力超高、射程超远的箭塔。",
	"攻速很慢，但是攻击力超高、射程超远的箭塔。",
	"攻速很慢，但是攻击力超高、射程超远的箭塔。",
	"攻速很慢，但是攻击力超高、射程超远的箭塔。",
	"攻速很慢，但是攻击力超高、射程超远的箭塔。",
	"攻速很慢，但是攻击力超高、射程超远的箭塔。",
	"攻速很慢，但是攻击力超高、射程超远的箭塔。",
	"攻速很慢，但是攻击力超高、射程超远的箭塔。",
	"攻速很慢，但是攻击力超高、射程超远的箭塔。",
}

_tab_stringT[1018] = {"滚石塔",
	"每次攻击从炮口发出一块巨大的石头滚向前方，对碰到的地面上的敌人造成伤害。",
	"每次攻击从炮口发出一块巨大的石头滚向前方，对碰到的地面上的敌人造成伤害。",
	"每次攻击从炮口发出一块巨大的石头滚向前方，对碰到的地面上的敌人造成伤害。",
	"每次攻击从炮口发出一块巨大的石头滚向前方，对碰到的地面上的敌人造成伤害。",
	"每次攻击从炮口发出一块巨大的石头滚向前方，对碰到的地面上的敌人造成伤害。",
	"每次攻击从炮口发出一块巨大的石头滚向前方，对碰到的地面上的敌人造成伤害。",
	"每次攻击从炮口发出一块巨大的石头滚向前方，对碰到的地面上的敌人造成伤害。",
	"每次攻击从炮口发出一块巨大的石头滚向前方，对碰到的地面上的敌人造成伤害。",
	"每次攻击从炮口发出一块巨大的石头滚向前方，对碰到的地面上的敌人造成伤害。",
	"每次攻击从炮口发出一块巨大的石头滚向前方，对碰到的地面上的敌人造成伤害。",
}

_tab_stringT[1019] = {"轰天塔",
	"射程极远的炮塔。每次发射出4颗散弹。但无法瞄准靠得太近的目标。",
	"射程极远的炮塔。每次发射出4颗散弹。但无法瞄准靠得太近的目标。",
	"射程极远的炮塔。每次发射出4颗散弹。但无法瞄准靠得太近的目标。",
	"射程极远的炮塔。每次发射出4颗散弹。但无法瞄准靠得太近的目标。",
	"射程极远的炮塔。每次发射出4颗散弹。但无法瞄准靠得太近的目标。",
	"射程极远的炮塔。每次发射出4颗散弹。但无法瞄准靠得太近的目标。",
	"射程极远的炮塔。每次发射出4颗散弹。但无法瞄准靠得太近的目标。",
	"射程极远的炮塔。每次发射出4颗散弹。但无法瞄准靠得太近的目标。",
	"射程极远的炮塔。每次发射出4颗散弹。但无法瞄准靠得太近的目标。",
	"射程极远的炮塔。每次发射出4颗散弹。但无法瞄准靠得太近的目标。",
}

_tab_stringT[1020] = {"粮仓",
	"没有攻击力。但是每秒可以产出1金。",
	"没有攻击力。但是每秒可以产出1金。",
	"没有攻击力。但是每秒可以产出1金。",
	"没有攻击力。但是每秒可以产出1金。",
	"没有攻击力。但是每秒可以产出1金。",
	"没有攻击力。但是每秒可以产出1金。",
	"没有攻击力。但是每秒可以产出1金。",
	"没有攻击力。但是每秒可以产出1金。",
	"没有攻击力。但是每秒可以产出1金。",
	"没有攻击力。但是每秒可以产出1金。",
}


_tab_stringT[1021] = {"基础兵营",
	"PVP模式专用的兵营。",
}

--擂鼓塔
_tab_stringT[1022] = {"擂鼓塔",
	"没有攻击力。但是能使周围友方塔和英雄获得增益。初始自带技能效果。",
	"没有攻击力。但是能使周围友方塔和英雄获得增益。初始自带技能效果。",
	"没有攻击力。但是能使周围友方塔和英雄获得增益。初始自带技能效果。",
	"没有攻击力。但是能使周围友方塔和英雄获得增益。初始自带技能效果。",
	"没有攻击力。但是能使周围友方塔和英雄获得增益。初始自带技能效果。",
}

--地刺塔
_tab_stringT[1023] = {"地刺塔",
	"每次攻击穿出4道尖刺，每道尖刺对地面造成小范围群伤。",
	"每次攻击穿出4道尖刺，每道尖刺对地面造成小范围群伤。",
	"每次攻击穿出4道尖刺，每道尖刺对地面造成小范围群伤。",
	"每次攻击穿出4道尖刺，每道尖刺对地面造成小范围群伤。",
	"每次攻击穿出4道尖刺，每道尖刺对地面造成小范围群伤。",
}




_tab_stringT[1031] = {"破敌",
	"敌方普通单位生命值-9％。",
	"敌方普通单位生命值-12％。",
	"敌方普通单位生命值-15％。",
	"敌方普通单位生命值-18％。",
	"敌方普通单位生命值-21％。",
	"敌方普通单位生命值-24％。",
	"敌方普通单位生命值-27％。",
	"敌方普通单位生命值-30％。",
	"敌方普通单位生命值-33％。",
	"敌方普通单位生命值-36％。",
}

_tab_stringT[1032] = {"弱敌",
	"敌方普通单位攻击力-12％。",
	"敌方普通单位攻击力-15％。",
	"敌方普通单位攻击力-18％。",
	"敌方普通单位攻击力-21％。",
	"敌方普通单位攻击力-24％。",
	"敌方普通单位攻击力-27％。",
	"敌方普通单位攻击力-30％。",
	"敌方普通单位攻击力-33％。",
	"敌方普通单位攻击力-36％。",
	"敌方普通单位攻击力-39％。",
}

_tab_stringT[1033] = {"乱敌",
	"敌方英雄的技能冷却时间+15％。",
	"敌方英雄的技能冷却时间+20％。",
	"敌方英雄的技能冷却时间+25％。",
	"敌方英雄的技能冷却时间+30％。",
	"敌方英雄的技能冷却时间+35％。",
	"敌方英雄的技能冷却时间+40％。",
	"敌方英雄的技能冷却时间+45％。",
	"敌方英雄的技能冷却时间+50％。",
	"敌方英雄的技能冷却时间+55％。",
	"敌方英雄的技能冷却时间+60％。",
}

_tab_stringT[1034] = {"箭塔精通",
	"我方箭塔系攻击速度+10％，射程+5码。",
	"我方箭塔系攻击速度+20％，射程+10码。",
	"我方箭塔系攻击速度+30％，射程+15码。",
	"我方箭塔系攻击速度+40％，射程+20码。",
	"我方箭塔系攻击速度+50％，射程+25码。",
	"我方箭塔系攻击速度+60％，射程+30码。",
	"我方箭塔系攻击速度+70％，射程+35码。",
	"我方箭塔系攻击速度+80％，射程+40码。",
	"我方箭塔系攻击速度+90％，射程+45码。",
	"我方箭塔系攻击速度+100％，射程+50码。",
}

_tab_stringT[1035] = {"炮塔精通",
	"我方炮塔系暴击几率+12％，暴击倍数+0.1。",
	"我方炮塔系暴击几率+16％，暴击倍数+0.2。",
	"我方炮塔系暴击几率+20％，暴击倍数+0.3。",
	"我方炮塔系暴击几率+24％，暴击倍数+0.4。",
	"我方炮塔系暴击几率+28％，暴击倍数+0.5。",
	"我方炮塔系暴击几率+32％，暴击倍数+0.6。",
	"我方炮塔系暴击几率+36％，暴击倍数+0.7。",
	"我方炮塔系暴击几率+40％，暴击倍数+0.8。",
	"我方炮塔系暴击几率+44％，暴击倍数+0.9。",
	"我方炮塔系暴击几率+48％，暴击倍数+1.0。",
}

_tab_stringT[1036] = {"术塔精通",
	"我方法术塔系攻击力+12％。",
	"我方法术塔系攻击力+16％。",
	"我方法术塔系攻击力+20％。",
	"我方法术塔系攻击力+24％。",
	"我方法术塔系攻击力+28％。",
	"我方法术塔系攻击力+32％。",
	"我方法术塔系攻击力+36％。",
	"我方法术塔系攻击力+40％。",
	"我方法术塔系攻击力+44％。",
	"我方法术塔系攻击力+48％。",
}

_tab_stringT[1037] = {"富豪",
	"每波开始时额外获得10金。",
	"每波开始时额外获得20金。",
	"每波开始时额外获得40金。消灭敌人额外获得5％金。",
	"每波开始时额外获得75金。消灭敌人额外获得10％金。",
	"每波开始时额外获得100金。消灭敌人额外获得15％金。",
	"每波开始时额外获得150金。消灭敌人额外获得20％金。",
	"每波开始时额外获得200金。消灭敌人额外获得25％金。",
	"每波开始时额外获得300金。消灭敌人额外获得30％金。",
	"每波开始时额外获得400金。消灭敌人额外获得35％金。",
	"每波开始时额外获得500金。消灭敌人额外获得40％金。",
}

_tab_stringT[1038] = {"聚利",
	"每回合开始时获得2％利息。",
	"每回合开始时获得4％利息。",
	"每回合开始时获得6％利息。",
	"每回合开始时获得8％利息。",
	"每回合开始时获得10％利息。",
	"每回合开始时获得12％利息。",
	"每回合开始时获得14％利息。",
	"每回合开始时获得16％利息。",
	"每回合开始时获得18％利息。",
	"每回合开始时获得20％利息。",
}

_tab_stringT[1039] = {"妙手回春",
	"我方英雄复活时间-2秒。（复活时间最低为7秒）",
	"我方英雄复活时间-4秒。（复活时间最低为7秒）",
	"我方英雄复活时间-6秒。（复活时间最低为7秒）",
	"我方英雄复活时间-8秒。（复活时间最低为7秒）",
	"我方英雄复活时间-10秒。（复活时间最低为7秒）",
	"我方英雄复活时间-12秒。（复活时间最低为7秒）",
	"我方英雄复活时间-14秒。（复活时间最低为7秒）",
	"我方英雄复活时间-16秒。（复活时间最低为7秒）",
	"我方英雄复活时间-18秒。（复活时间最低为7秒）",
	"我方英雄复活时间-20秒。（复活时间最低为7秒）",
}

_tab_stringT[1040] = {"固若金汤",
	"我方据点生命值+10％，回复速度+2点/秒。",
	"我方据点生命值+20％，回复速度+4点/秒。",
	"我方据点生命值+30％，回复速度+6点/秒。",
	"我方据点生命值+40％，回复速度+8点/秒。",
	"我方据点生命值+50％，回复速度+10点/秒。",
	"我方据点生命值+60％，回复速度+12点/秒。",
	"我方据点生命值+70％，回复速度+14点/秒。",
	"我方据点生命值+80％，回复速度+16点/秒。",
	"我方据点生命值+90％，回复速度+18点/秒。",
	"我方据点生命值+100％，回复速度+20点/秒。",
}

_tab_stringT[1041] = {"塔基加固",
	"我方防御塔生命值+10％，回复速度+5点/秒。",
	"我方防御塔生命值+20％，回复速度+10点/秒。",
	"我方防御塔生命值+30％，回复速度+15点/秒。",
	"我方防御塔生命值+40％，回复速度+20点/秒。",
	"我方防御塔生命值+50％，回复速度+25点/秒。",
	"我方防御塔生命值+60％，回复速度+30点/秒。",
	"我方防御塔生命值+70％，回复速度+35点/秒。",
	"我方防御塔生命值+80％，回复速度+40点/秒。",
	"我方防御塔生命值+90％，回复速度+45点/秒。",
	"我方防御塔生命值+100％，回复速度+50点/秒。",
}

_tab_stringT[1042] = {"王佐之才",
	"我方英雄战术技能冷却时间-10％。",
	"我方英雄战术技能冷却时间-15％。",
	"我方英雄战术技能冷却时间-20％。",
	"我方英雄战术技能冷却时间-25％。",
	"我方英雄战术技能冷却时间-30％。",
	"我方英雄战术技能冷却时间-35％。",
	"我方英雄战术技能冷却时间-40％。",
	"我方英雄战术技能冷却时间-45％。",
	"我方英雄战术技能冷却时间-50％。",
	"我方英雄战术技能冷却时间-55％。",
}

_tab_stringT[1043] = {"月华",
	"我方英雄和部队+7％攻击力、攻击速度。",
	"我方英雄和部队+11％攻击力、攻击速度。",
	"我方英雄和部队+15％攻击力、攻击速度。",
	"我方英雄和部队+19％攻击力、攻击速度。",
	"我方英雄和部队+23％攻击力、攻击速度。",
	"我方英雄和部队+27％攻击力、攻击速度。",
	"我方英雄和部队+31％攻击力、攻击速度。",
	"我方英雄和部队+35％攻击力、攻击速度。",
	"我方英雄和部队+39％攻击力、攻击速度。",
	"我方英雄和部队+43％攻击力、攻击速度。",
}

_tab_stringT[1044] = {"凤翼天翔",
	"[主动] 召唤凤凰，对200范围敌人和敌方建筑造成1600点真实伤害，并持续燃烧地面20秒。冷却90秒。",
	"[主动] 召唤凤凰，对220范围敌人和敌方建筑造成2000点真实伤害，并持续燃烧地面24秒。冷却80秒。",
	"[主动] 召唤凤凰，对240范围敌人和敌方建筑造成2400点真实伤害，并持续燃烧地面28秒。冷却70秒。",
	"[主动] 召唤凤凰，对260范围敌人和敌方建筑造成2800点真实伤害，并持续燃烧地面32秒。冷却60秒。",
	"[主动] 召唤凤凰，对280范围敌人和敌方建筑造成3200点真实伤害，并持续燃烧地面36秒。冷却50秒。",
	"[主动] 召唤凤凰，对300范围敌人和敌方建筑造成3600点真实伤害，并持续燃烧地面40秒。冷却40秒。",
	"[主动] 召唤凤凰，对330范围敌人和敌方建筑造成4000点真实伤害，并持续燃烧地面44秒。冷却30秒。",
	"[主动] 召唤凤凰，对340范围敌人和敌方建筑造成4400点真实伤害，并持续燃烧地面48秒。冷却20秒。",
	"[主动] 召唤凤凰，对360范围敌人和敌方建筑造成4800点真实伤害，并持续燃烧地面52秒。冷却10秒。",
	"[主动] 召唤凤凰，对380范围敌人和敌方建筑造成5200点真实伤害，并持续燃烧地面56秒。冷却5秒。",
}

_tab_stringT[1045] = {"破军",
	"敌人和敌方建筑攻击速度-26％，物理防御-13点。",
	"敌人和敌方建筑攻击速度-32％，物理防御-16点。",
	"敌人和敌方建筑攻击速度-38％，物理防御-19点。",
	"敌人和敌方建筑攻击速度-44％，物理防御-22点。",
	"敌人和敌方建筑攻击速度-50％，物理防御-25点。",
	"敌人和敌方建筑攻击速度-56％，物理防御-28点。",
	"敌人和敌方建筑攻击速度-62％，物理防御-31点。",
	"敌人和敌方建筑攻击速度-68％，物理防御-34点。",
	"敌人和敌方建筑攻击速度-74％，物理防御-37点。",
	"敌人和敌方建筑攻击速度-80％，物理防御-40点。",
}
_tab_stringT[1046] = {"摧城拔寨",
	"敌方建筑生命值-9％。",
	"敌方建筑生命值-12％。",
	"敌方建筑生命值-15％。",
	"敌方建筑生命值-18％。",
	"敌方建筑生命值-21％。",
	"敌方建筑生命值-24％。",
	"敌方建筑生命值-27％。",
	"敌方建筑生命值-30％。",
	"敌方建筑生命值-33％。",
	"敌方建筑生命值-36％。",
}

_tab_stringT[1047] = {"强化毒素",
	"我方剧毒塔每秒毒箭伤害+40％，中毒时间+0.6秒。",
	"我方剧毒塔每秒毒箭伤害+80％，中毒时间+1.2秒。",
	"我方剧毒塔每秒毒箭伤害+120％，中毒时间+1.8秒。",
	"我方剧毒塔每秒毒箭伤害+160％，中毒时间+2.4秒。",
	"我方剧毒塔每秒毒箭伤害+200％，中毒时间+3秒。",
	"我方剧毒塔每秒毒箭伤害+240％，中毒时间+3.6秒。",
	"我方剧毒塔每秒毒箭伤害+280％，中毒时间+4.3秒。",
	"我方剧毒塔每秒毒箭伤害+320％，中毒时间+4.8秒。",
	"我方剧毒塔每秒毒箭伤害+360％，中毒时间+5.4秒。",
	"我方剧毒塔每秒毒箭伤害+400％，中毒时间+6秒。",
}


_tab_stringT[1048] = {"致命连射",
	"我方连弩塔攻击力+9％、暴击几率+15％。",
	"我方连弩塔攻击力+12％、暴击几率+20％。",
	"我方连弩塔攻击力+15％、暴击几率+25％。",
	"我方连弩塔攻击力+18％、暴击几率+30％。",
	"我方连弩塔攻击力+21％、暴击几率+35％。",
	"我方连弩塔攻击力+24％、暴击几率+40％。",
	"我方连弩塔攻击力+27％、暴击几率+45％。",
	"我方连弩塔攻击力+30％、暴击几率+50％。",
	"我方连弩塔攻击力+33％、暴击几率+55％。",
	"我方连弩塔攻击力+36％、暴击几率+60％。",
}

_tab_stringT[1049] = {"穿云一击",
	"我方狙击塔每次攻击有15％的几率射出穿云箭，对一条直线上敌人造成伤害。",
	"我方狙击塔每次攻击有20％的几率射出穿云箭，对一条直线上敌人造成伤害。",
	"我方狙击塔每次攻击有25％的几率射出穿云箭，对一条直线上敌人造成伤害。",
	"我方狙击塔每次攻击有30％的几率射出穿云箭，对一条直线上敌人造成伤害。",
	"我方狙击塔每次攻击有35％的几率射出穿云箭，对一条直线上敌人造成伤害。",
	"我方狙击塔每次攻击有40％的几率射出穿云箭，对一条直线上敌人造成伤害。",
	"我方狙击塔每次攻击有45％的几率射出穿云箭，对一条直线上敌人造成伤害。",
	"我方狙击塔每次攻击有50％的几率射出穿云箭，对一条直线上敌人造成伤害。",
	"我方狙击塔每次攻击有55％的几率射出穿云箭，对一条直线上敌人造成伤害。",
	"我方狙击塔每次攻击有60％的几率射出穿云箭，对一条直线上敌人造成伤害。",
}

_tab_stringT[1050] = {"天雷滚滚",
	"我方天雷塔闪电链弹射次数+1。",
	"我方天雷塔闪电链弹射次数+2。",
	"我方天雷塔闪电链弹射次数+3。",
	"我方天雷塔闪电链弹射次数+4。",
	"我方天雷塔闪电链弹射次数+5。",
	"我方天雷塔闪电链弹射次数+6。",
	"我方天雷塔闪电链弹射次数+7。",
	"我方天雷塔闪电链弹射次数+8。",
	"我方天雷塔闪电链弹射次数+9。",
	"我方天雷塔闪电链弹射次数+10。",
}

_tab_stringT[1051] = {"三味真火",
	"我方火焰塔攻击力+9％、攻击速度+15％。",
	"我方火焰塔攻击力+12％、攻击速度+20％。",
	"我方火焰塔攻击力+15％、攻击速度+25％。",
	"我方火焰塔攻击力+18％、攻击速度+30％。",
	"我方火焰塔攻击力+21％、攻击速度+35％。",
	"我方火焰塔攻击力+24％、攻击速度+40％。",
	"我方火焰塔攻击力+27％、攻击速度+45％。",
	"我方火焰塔攻击力+30％、攻击速度+50％。",
	"我方火焰塔攻击力+33％、攻击速度+55％。",
	"我方火焰塔攻击力+36％、攻击速度+60％。",
}

_tab_stringT[1052] = {"冻土",
	"我方寒冰塔生命值+20％、物理防御+5点。",
	"我方寒冰塔生命值+30％、物理防御+10点。",
	"我方寒冰塔生命值+40％、物理防御+15点。",
	"我方寒冰塔生命值+50％、物理防御+20点。",
	"我方寒冰塔生命值+60％、物理防御+25点。",
	"我方寒冰塔生命值+70％、物理防御+30点。",
	"我方寒冰塔生命值+80％、物理防御+35点。",
	"我方寒冰塔生命值+90％、物理防御+40点。",
	"我方寒冰塔生命值+100％、物理防御+45点。",
	"我方寒冰塔生命值+110％、物理防御+50点。",
}

_tab_stringT[1053] = {"弹道学",
	"我方巨炮塔攻击力+9％、射程+15码。",
	"我方巨炮塔攻击力+12％、射程+30码。",
	"我方巨炮塔攻击力+15％、射程+45码。",
	"我方巨炮塔攻击力+18％、射程+60码。",
	"我方巨炮塔攻击力+21％、射程+75码。",
	"我方巨炮塔攻击力+24％、射程+90码。",
	"我方巨炮塔攻击力+27％、射程+105码。",
	"我方巨炮塔攻击力+30％、射程+120码。",
	"我方巨炮塔攻击力+33％、射程+135码。",
	"我方巨炮塔攻击力+36％、射程+150码。",
}


_tab_stringT[1054] = {"致命轰击",
	"我方轰天塔暴击几率+24％。",
	"我方轰天塔暴击几率+30％。",
	"我方轰天塔暴击几率+36％。",
	"我方轰天塔暴击几率+42％。",
	"我方轰天塔暴击几率+48％。",
	"我方轰天塔暴击几率+48％。",
	"我方轰天塔暴击几率+48％。",
	"我方轰天塔暴击几率+48％。",
	"我方轰天塔暴击几率+48％。",
	"我方轰天塔暴击几率+48％。",
}

_tab_stringT[1055] = {"碾压",
	"我方滚石塔滚石滚动距离+40码，击退敌人距离+20码。",
	"我方滚石塔滚石滚动距离+80码，击退敌人距离+40码。",
	"我方滚石塔滚石滚动距离+120码，击退敌人距离+60码。",
	"我方滚石塔滚石滚动距离+160码，击退敌人距离+80码。",
	"我方滚石塔滚石滚动距离+200码，击退敌人距离+100码。",
	"我方滚石塔滚石滚动距离+240码，击退敌人距离+120码。",
	"我方滚石塔滚石滚动距离+280码，击退敌人距离+140码。",
	"我方滚石塔滚石滚动距离+320码，击退敌人距离+160码。",
	"我方滚石塔滚石滚动距离+360码，击退敌人距离+180码。",
	"我方滚石塔滚石滚动距离+400码，击退敌人距离+200码。",
}

--新手地图
_tab_stringT[1056] = {"弱敌",
	--"我方英雄攻击力+10％。", --geyachao: 王总说要一行显示。。。
	"敌方攻击-20％",
}

--新手地图
_tab_stringT[1057] = {"滚石塔",
	"每次攻击从炮口发出一块巨大的石头滚向前方，对碰到的地面上的敌人造成伤害",
}

--新手地图
_tab_stringT[1058] = {"轰天塔",
	"射程极远的炮塔。每次发射出4颗散弹。但无法瞄准靠得太近的目标",
}

--新手地图
_tab_stringT[1059] = {"狙击塔",
	"攻速很慢，但是攻击力超高、射程超远的箭塔",
}

--新手地图
_tab_stringT[1060] = {"地刺塔",
	"每次攻击穿出3道尖刺，每道尖刺对地面造成小范围群伤，并将敌人抛向空中",
}

_tab_stringT[1061] = {"地刺陷阱",
	"我方地刺塔每次攻击有15％的几率对敌人造成穿刺。",
	"我方地刺塔每次攻击有20％的几率对敌人造成穿刺。",
	"我方地刺塔每次攻击有25％的几率对敌人造成穿刺。",
	"我方地刺塔每次攻击有30％的几率对敌人造成穿刺。",
	"我方地刺塔每次攻击有35％的几率对敌人造成穿刺。",
	"我方地刺塔每次攻击有40％的几率对敌人造成穿刺。",
	"我方地刺塔每次攻击有45％的几率对敌人造成穿刺。",
	"我方地刺塔每次攻击有50％的几率对敌人造成穿刺。",
	"我方地刺塔每次攻击有55％的几率对敌人造成穿刺。",
	"我方地刺塔每次攻击有60％的几率对敌人造成穿刺。",
}

----新战术卡
_tab_stringT[1062] = {"冰魄",
	"我方寒冰塔攻击速度+10％，射程+5码。",
	"我方寒冰塔攻击速度+20％，射程+10码。",
	"我方寒冰塔攻击速度+30％，射程+15码。",
	"我方寒冰塔攻击速度+40％，射程+20码。",
	"我方寒冰塔攻击速度+50％，射程+25码。",
	"我方寒冰塔攻击速度+60％，射程+30码。",
	"我方寒冰塔攻击速度+70％，射程+35码。",
	"我方寒冰塔攻击速度+80％，射程+40码。",
	"我方寒冰塔攻击速度+90％，射程+45码。",
	"我方寒冰塔攻击速度+100％，射程+50码。",
}

_tab_stringT[1063] = {"天之雷",
	"我方天雷塔攻击速度+10％，射程+5码。",
	"我方天雷塔攻击速度+20％，射程+10码。",
	"我方天雷塔攻击速度+30％，射程+15码。",
	"我方天雷塔攻击速度+40％，射程+20码。",
	"我方天雷塔攻击速度+50％，射程+25码。",
	"我方天雷塔攻击速度+60％，射程+30码。",
	"我方天雷塔攻击速度+70％，射程+35码。",
	"我方天雷塔攻击速度+80％，射程+40码。",
	"我方天雷塔攻击速度+90％，射程+45码。",
	"我方天雷塔攻击速度+100％，射程+50码。",
}

_tab_stringT[1064] = {"灭天火",
	"我方火焰塔射程+10码。",
	"我方火焰塔射程+20码。",
	"我方火焰塔射程+30码。",
	"我方火焰塔射程+40码。",
	"我方火焰塔射程+50码。",
	"我方火焰塔射程+60码。",
	"我方火焰塔射程+70码。",
	"我方火焰塔射程+80码。",
	"我方火焰塔射程+90码。",
	"我方火焰塔射程+100码。",
}

_tab_stringT[1065] = {"炮火连天",
	"我方巨炮塔攻击速度+20％。",
	"我方巨炮塔攻击速度+40％。",
	"我方巨炮塔攻击速度+60％。",
	"我方巨炮塔攻击速度+80％。",
	"我方巨炮塔攻击速度+100％。",
	"我方巨炮塔攻击速度+120％。",
	"我方巨炮塔攻击速度+140％。",
	"我方巨炮塔攻击速度+160％。",
	"我方巨炮塔攻击速度+180％。",
	"我方巨炮塔攻击速度+200％。",
}

_tab_stringT[1066] = {"飞沙走石",
	"我方滚石塔攻击力+9％、攻击速度+15％。",
	"我方滚石塔攻击力+12％、攻击速度+20％。",
	"我方滚石塔攻击力+15％、攻击速度+25％。",
	"我方滚石塔攻击力+18％、攻击速度+30％。",
	"我方滚石塔攻击力+21％、攻击速度+35％。",
	"我方滚石塔攻击力+24％、攻击速度+40％。",
	"我方滚石塔攻击力+27％、攻击速度+45％。",
	"我方滚石塔攻击力+30％、攻击速度+50％。",
	"我方滚石塔攻击力+33％、攻击速度+55％。",
	"我方滚石塔攻击力+36％、攻击速度+60％。",
}

_tab_stringT[1067] = {"火借风威",
	"我方火焰塔火球命中目标后持续灼烧目标，每1.5秒造成17点法术伤害。同时目标移动速度越快，伤害越高。",
	"我方火焰塔火球命中目标后持续灼烧目标，每1.5秒造成22点法术伤害。同时目标移动速度越快，伤害越高。",
	"我方火焰塔火球命中目标后持续灼烧目标，每1.5秒造成27点法术伤害。同时目标移动速度越快，伤害越高。",
	"我方火焰塔火球命中目标后持续灼烧目标，每1.5秒造成32点法术伤害。同时目标移动速度越快，伤害越高。",
	"我方火焰塔火球命中目标后持续灼烧目标，每1.5秒造成37点法术伤害。同时目标移动速度越快，伤害越高。",
	"我方火焰塔火球命中目标后持续灼烧目标，每1.5秒造成42点法术伤害。同时目标移动速度越快，伤害越高。",
	"我方火焰塔火球命中目标后持续灼烧目标，每1.5秒造成47点法术伤害。同时目标移动速度越快，伤害越高。",
	"我方火焰塔火球命中目标后持续灼烧目标，每1.5秒造成52点法术伤害。同时目标移动速度越快，伤害越高。",
	"我方火焰塔火球命中目标后持续灼烧目标，每1.5秒造成57点法术伤害。同时目标移动速度越快，伤害越高。",
	"我方火焰塔火球命中目标后持续灼烧目标，每1.5秒造成62点法术伤害。同时目标移动速度越快，伤害越高。",
}

_tab_stringT[1068] = {"剧毒新星",
	"剧毒塔攻击时有8％概率释放剧毒，对80范围内的敌人造成60％攻击力的真实伤害，并使敌人中毒，持续2秒。",
	"剧毒塔攻击时有9％概率释放剧毒，对80范围内的敌人造成70％攻击力的真实伤害，并使敌人中毒，持续2秒。",
	"剧毒塔攻击时有10％概率释放剧毒，对80范围内的敌人造成80％攻击力的真实伤害，并使敌人中毒，持续2秒。",
	"剧毒塔攻击时有11％概率释放剧毒，对80范围内的敌人造成90％攻击力的真实伤害，并使敌人中毒，持续2秒。",
	"剧毒塔攻击时有12％概率释放剧毒，对80范围内的敌人造成100％攻击力的真实伤害，并使敌人中毒，持续2秒。",
	"剧毒塔攻击时有13％概率释放剧毒，对80范围内的敌人造成110％攻击力的真实伤害，并使敌人中毒，持续2秒。",
	"剧毒塔攻击时有14％概率释放剧毒，对80范围内的敌人造成120％攻击力的真实伤害，并使敌人中毒，持续2秒。",
	"剧毒塔攻击时有15％概率释放剧毒，对80范围内的敌人造成130％攻击力的真实伤害，并使敌人中毒，持续2秒。",
	"剧毒塔攻击时有16％概率释放剧毒，对80范围内的敌人造成140％攻击力的真实伤害，并使敌人中毒，持续2秒。",
	"剧毒塔攻击时有17％概率释放剧毒，对80范围内的敌人造成150％攻击力的真实伤害，并使敌人中毒，持续2秒。",
}

_tab_stringT[1069] = {"亡命狙击",
	"我方狙击塔击杀目标后，使下一次攻击伤害增加40％。",
	"我方狙击塔击杀目标后，使下一次攻击伤害增加55％。",
	"我方狙击塔击杀目标后，使下一次攻击伤害增加70％。",
	"我方狙击塔击杀目标后，使下一次攻击伤害增加85％。",
	"我方狙击塔击杀目标后，使下一次攻击伤害增加100％。",
	"我方狙击塔击杀目标后，使下一次攻击伤害增加115％。",
	"我方狙击塔击杀目标后，使下一次攻击伤害增加130％。",
	"我方狙击塔击杀目标后，使下一次攻击伤害增加145％。",
	"我方狙击塔击杀目标后，使下一次攻击伤害增加150％。",
	"我方狙击塔击杀目标后，使下一次攻击伤害增加165％。",
}

_tab_stringT[1070] = {"箭雨",
	"我方连弩塔击杀目标后，提升40％的攻击速度，持续5秒。",
	"我方连弩塔击杀目标后，提升60％的攻击速度，持续5秒。",
	"我方连弩塔击杀目标后，提升80％的攻击速度，持续5秒。",
	"我方连弩塔击杀目标后，提升100％的攻击速度，持续5秒。",
	"我方连弩塔击杀目标后，提升120％的攻击速度，持续5秒。",
	"我方连弩塔击杀目标后，提升140％的攻击速度，持续5秒。",
	"我方连弩塔击杀目标后，提升160％的攻击速度，持续5秒。",
	"我方连弩塔击杀目标后，提升180％的攻击速度，持续5秒。",
	"我方连弩塔击杀目标后，提升200％的攻击速度，持续5秒。",
	"我方连弩塔击杀目标后，提升220％的攻击速度，持续5秒。",
}

_tab_stringT[1071] = {"凛冬之寒",
	"我方寒冰塔每次攻击向目标注入凛寒之力，当目标解除减速效果时，降低25点物防和法防，持续3秒。",
	"我方寒冰塔每次攻击向目标注入凛寒之力，当目标解除减速效果时，降低35点物防和法防，持续3秒。",
	"我方寒冰塔每次攻击向目标注入凛寒之力，当目标解除减速效果时，降低45点物防和法防，持续3秒。",
	"我方寒冰塔每次攻击向目标注入凛寒之力，当目标解除减速效果时，降低55点物防和法防，持续3秒。",
	"我方寒冰塔每次攻击向目标注入凛寒之力，当目标解除减速效果时，降低65点物防和法防，持续3秒。",
	"我方寒冰塔每次攻击向目标注入凛寒之力，当目标解除减速效果时，降低75点物防和法防，持续3秒。",
	"我方寒冰塔每次攻击向目标注入凛寒之力，当目标解除减速效果时，降低85点物防和法防，持续3秒。",
	"我方寒冰塔每次攻击向目标注入凛寒之力，当目标解除减速效果时，降低95点物防和法防，持续3秒。",
	"我方寒冰塔每次攻击向目标注入凛寒之力，当目标解除减速效果时，降低105点物防和法防，持续3秒。",
	"我方寒冰塔每次攻击向目标注入凛寒之力，当目标解除减速效果时，降低115点物防和法防，持续3秒。",
}

_tab_stringT[1072] = {"复仇巨炮",
	"我方巨炮塔击杀了瞄准的主目标，那么下一颗炮弹必定暴击，并且伤害增加20％。",
	"我方巨炮塔击杀了瞄准的主目标，那么下一颗炮弹必定暴击，并且伤害增加30％。",
	"我方巨炮塔击杀了瞄准的主目标，那么下一颗炮弹必定暴击，并且伤害增加40％。",
	"我方巨炮塔击杀了瞄准的主目标，那么下一颗炮弹必定暴击，并且伤害增加50％。",
	"我方巨炮塔击杀了瞄准的主目标，那么下一颗炮弹必定暴击，并且伤害增加60％。",
	"我方巨炮塔击杀了瞄准的主目标，那么下一颗炮弹必定暴击，并且伤害增加70％。",
	"我方巨炮塔击杀了瞄准的主目标，那么下一颗炮弹必定暴击，并且伤害增加80％。",
	"我方巨炮塔击杀了瞄准的主目标，那么下一颗炮弹必定暴击，并且伤害增加90％。",
	"我方巨炮塔击杀了瞄准的主目标，那么下一颗炮弹必定暴击，并且伤害增加100％。",
	"我方巨炮塔击杀了瞄准的主目标，那么下一颗炮弹必定暴击，并且伤害增加110％。",
}

_tab_stringT[1073] = {"神火雷",
	"我方天雷塔攻每次攻击有25％的几率对目标和周围100范围内的敌人造成85点法术伤害。",
	"我方天雷塔攻每次攻击有25％的几率对目标和周围100范围内的敌人造成125点法术伤害。",
	"我方天雷塔攻每次攻击有25％的几率对目标和周围100范围内的敌人造成165点法术伤害。",
	"我方天雷塔攻每次攻击有25％的几率对目标和周围100范围内的敌人造成205点法术伤害。",
	"我方天雷塔攻每次攻击有25％的几率对目标和周围100范围内的敌人造成245点法术伤害。",
	"我方天雷塔攻每次攻击有25％的几率对目标和周围100范围内的敌人造成285点法术伤害。",
	"我方天雷塔攻每次攻击有25％的几率对目标和周围100范围内的敌人造成205点法术伤害。",
	"我方天雷塔攻每次攻击有25％的几率对目标和周围100范围内的敌人造成225点法术伤害。",
	"我方天雷塔攻每次攻击有25％的几率对目标和周围100范围内的敌人造成245点法术伤害。",
	"我方天雷塔攻每次攻击有25％的几率对目标和周围100范围内的敌人造成265点法术伤害。",
}

_tab_stringT[1074] = {"亡者天降",
	"我方轰天塔每次攻击有10％的几率使发射的散弹数量翻倍。",
	"我方轰天塔每次攻击有12％的几率使发射的散弹数量翻倍。",
	"我方轰天塔每次攻击有14％的几率使发射的散弹数量翻倍。",
	"我方轰天塔每次攻击有16％的几率使发射的散弹数量翻倍。",
	"我方轰天塔每次攻击有18％的几率使发射的散弹数量翻倍。",
	"我方轰天塔每次攻击有20％的几率使发射的散弹数量翻倍。",
	"我方轰天塔每次攻击有22％的几率使发射的散弹数量翻倍。",
	"我方轰天塔每次攻击有24％的几率使发射的散弹数量翻倍。",
	"我方轰天塔每次攻击有26％的几率使发射的散弹数量翻倍。",
	"我方轰天塔每次攻击有28％的几率使发射的散弹数量翻倍。",
}

_tab_stringT[1075] = {"孤狼",
	"如果我方英雄周围250范围内没有其他友军英雄，那么提升10％的攻击力和攻击速度。",
	"如果我方英雄周围250范围内没有其他友军英雄，那么提升15％的攻击力和攻击速度。",
	"如果我方英雄周围250范围内没有其他友军英雄，那么提升20％的攻击力和攻击速度。",
	"如果我方英雄周围250范围内没有其他友军英雄，那么提升25％的攻击力和攻击速度。",
	"如果我方英雄周围250范围内没有其他友军英雄，那么提升30％的攻击力和攻击速度。",
	"如果我方英雄周围250范围内没有其他友军英雄，那么提升35％的攻击力和攻击速度。",
	"如果我方英雄周围250范围内没有其他友军英雄，那么提升40％的攻击力和攻击速度。",
	"如果我方英雄周围250范围内没有其他友军英雄，那么提升45％的攻击力和攻击速度。",
	"如果我方英雄周围250范围内没有其他友军英雄，那么提升50％的攻击力和攻击速度。",
	"如果我方英雄周围250范围内没有其他友军英雄，那么提升55％的攻击力和攻击速度。",
}

_tab_stringT[1076] = {"逆转天机",
	"[主动] 提升我方防御塔35％的攻击力和100％的攻击速度，持续10秒。冷却120秒。",
	"[主动] 提升我方防御塔45％的攻击力和110％的攻击速度，持续10秒。冷却115秒。",
	"[主动] 提升我方防御塔55％的攻击力和120％的攻击速度，持续10秒。冷却110秒。",
	"[主动] 提升我方防御塔65％的攻击力和130％的攻击速度，持续10秒。冷却105秒。",
	"[主动] 提升我方防御塔75％的攻击力和140％的攻击速度，持续10秒。冷却100秒。",
	"[主动] 提升我方防御塔75％的攻击力和150％的攻击速度，持续10秒。冷却95秒。",
	"[主动] 提升我方防御塔75％的攻击力和150％的攻击速度，持续10秒。冷却90秒。",
	"[主动] 提升我方防御塔75％的攻击力和150％的攻击速度，持续10秒。冷却85秒。",
	"[主动] 提升我方防御塔75％的攻击力和150％的攻击速度，持续10秒。冷却80秒。",
	"[主动] 提升我方防御塔75％的攻击力和150％的攻击速度，持续10秒。冷却75秒。",
}

_tab_stringT[1077] = {"分秒必争",
	"我方英雄阵亡时，所有敌人眩晕1秒。",
	"我方英雄阵亡时，所有敌人眩晕1.5秒。",
	"我方英雄阵亡时，所有敌人眩晕2秒。",
	"我方英雄阵亡时，所有敌人眩晕2.5秒。",
	"我方英雄阵亡时，所有敌人眩晕3秒。",
	"我方英雄阵亡时，所有敌人眩晕3.5秒。",
	"我方英雄阵亡时，所有敌人眩晕4秒。",
	"我方英雄阵亡时，所有敌人眩晕4.5秒。",
	"我方英雄阵亡时，所有敌人眩晕5秒。",
	"我方英雄阵亡时，所有敌人眩晕5.5秒。",
}


_tab_stringT[1078] = {"先者之音",
	"我方英雄阵亡时，鼓舞我方防御塔，使其攻击力增加35％，持续8秒。",
	"我方英雄阵亡时，鼓舞我方防御塔，使其攻击力增加40％，持续8秒。",
	"我方英雄阵亡时，鼓舞我方防御塔，使其攻击力增加45％，持续8秒。",
	"我方英雄阵亡时，鼓舞我方防御塔，使其攻击力增加50％，持续8秒。",
	"我方英雄阵亡时，鼓舞我方防御塔，使其攻击力增加55％，持续8秒。",
	"我方英雄阵亡时，鼓舞我方防御塔，使其攻击力增加60％，持续8秒。",
	"我方英雄阵亡时，鼓舞我方防御塔，使其攻击力增加65％，持续8秒。",
	"我方英雄阵亡时，鼓舞我方防御塔，使其攻击力增加70％，持续8秒。",
	"我方英雄阵亡时，鼓舞我方防御塔，使其攻击力增加75％，持续8秒。",
	"我方英雄阵亡时，鼓舞我方防御塔，使其攻击力增加80％，持续8秒。",
}

_tab_stringT[1079] = {"月光",
	"我方英雄和部队+9％生命值、移动速度，并提升我方英雄附近300范围内防御塔9点物防和法防。",
	"我方英雄和部队+14％生命值、移动速度，并提升我方英雄附近300范围内防御塔14点物防和法防。",
	"我方英雄和部队+19％生命值、移动速度，并提升我方英雄附近300范围内防御塔19点物防和法防。",
	"我方英雄和部队+24％生命值、移动速度，并提升我方英雄附近300范围内防御塔24点物防和法防。",
	"我方英雄和部队+29％生命值、移动速度，并提升我方英雄附近300范围内防御塔29点物防和法防。",
	"我方英雄和部队+34％生命值、移动速度，并提升我方英雄附近300范围内防御塔34点物防和法防。",
	"我方英雄和部队+39％生命值、移动速度，并提升我方英雄附近300范围内防御塔39点物防和法防。",
	"我方英雄和部队+44％生命值、移动速度，并提升我方英雄附近300范围内防御塔44点物防和法防。",
	"我方英雄和部队+49％生命值、移动速度，并提升我方英雄附近300范围内防御塔49点物防和法防。",
	"我方英雄和部队+54％生命值、移动速度，并提升我方英雄附近300范围内防御塔54点物防和法防。",
}


_tab_stringT[1080] = {"苍穹之巅",
	"[主动] 召唤一个15000点生命，70点攻击力的神龙为你战斗。神龙每次攻击附带减少物理防御。神龙存在20秒。冷却200秒。",
	"[主动] 召唤一个15000点生命，70点攻击力的神龙为你战斗。神龙每次攻击附带减少物理防御。神龙存在30秒。冷却190秒。",
	"[主动] 召唤一个15000点生命，70点攻击力的神龙为你战斗。神龙每次攻击附带减少物理防御。神龙存在40秒。冷却180秒。",
	"[主动] 召唤一个15000点生命，70点攻击力的神龙为你战斗。神龙每次攻击附带减少物理防御。神龙存在50秒。冷却170秒。",
	"[主动] 召唤一个15000点生命，70点攻击力的神龙为你战斗。神龙每次攻击附带减少物理防御。神龙存在60秒。冷却160秒。",

}

_tab_stringT[1081] = {"北海玄武",
	"[主动] 召唤一个15000点生命，70点攻击力的玄武为你战斗。玄武每次攻击附带减少移动速度。玄武存在20秒。冷却200秒。",
	"[主动] 召唤一个15000点生命，70点攻击力的玄武为你战斗。玄武每次攻击附带减少移动速度。玄武存在30秒。冷却190秒。",
	"[主动] 召唤一个15000点生命，70点攻击力的玄武为你战斗。玄武每次攻击附带减少移动速度。玄武存在40秒。冷却180秒。",
	"[主动] 召唤一个15000点生命，70点攻击力的玄武为你战斗。玄武每次攻击附带减少移动速度。玄武存在50秒。冷却170秒。",
	"[主动] 召唤一个15000点生命，70点攻击力的玄武为你战斗。玄武每次攻击附带减少移动速度。玄武存在60秒。冷却160秒。",

}

_tab_stringT[1082] = {"炽热凤凰",
	"[主动] 召唤一个15000点生命，70点攻击力的凤凰为你战斗。凤凰每次攻击附带减少魔法防御。凤凰存在20秒。冷却200秒。",
	"[主动] 召唤一个15000点生命，70点攻击力的凤凰为你战斗。凤凰每次攻击附带减少魔法防御。凤凰存在30秒。冷却190秒。",
	"[主动] 召唤一个15000点生命，70点攻击力的凤凰为你战斗。凤凰每次攻击附带减少魔法防御。凤凰存在40秒。冷却180秒。",
	"[主动] 召唤一个15000点生命，70点攻击力的凤凰为你战斗。凤凰每次攻击附带减少魔法防御。凤凰存在50秒。冷却170秒。",
	"[主动] 召唤一个15000点生命，70点攻击力的凤凰为你战斗。凤凰每次攻击附带减少魔法防御。凤凰存在60秒。冷却160秒。",

}

_tab_stringT[1083] = {"炸弹人",
	"我方英雄阵亡时，对周围200范围内的敌人造成自身最大生命值15％的法术伤害。",
	"我方英雄阵亡时，对周围200范围内的敌人造成自身最大生命值20％的法术伤害。",
	"我方英雄阵亡时，对周围200范围内的敌人造成自身最大生命值25％的法术伤害。",
	"我方英雄阵亡时，对周围200范围内的敌人造成自身最大生命值30％的法术伤害。",
	"我方英雄阵亡时，对周围200范围内的敌人造成自身最大生命值35％的法术伤害。",
	"我方英雄阵亡时，对周围200范围内的敌人造成自身最大生命值15％的法术伤害。",
	"我方英雄阵亡时，对周围200范围内的敌人造成自身最大生命值15％的法术伤害。",
	"我方英雄阵亡时，对周围200范围内的敌人造成自身最大生命值15％的法术伤害。",
	"我方英雄阵亡时，对周围200范围内的敌人造成自身最大生命值15％的法术伤害。",
	"我方英雄阵亡时，对周围200范围内的敌人造成自身最大生命值15％的法术伤害。",
}

_tab_stringT[1084] = {"威震四方",
	"我方英雄周围120范围内的敌人物理防御-10点，法术防御-10点。",
	"我方英雄周围120范围内的敌人物理防御-13点，法术防御-13点。",
	"我方英雄周围120范围内的敌人物理防御-16点，法术防御-16点。",
	"我方英雄周围120范围内的敌人物理防御-19点，法术防御-17点。",
	"我方英雄周围120范围内的敌人物理防御-21点，法术防御-21点。",
	"我方英雄周围120范围内的敌人物理防御-24点，法术防御-24点。",
	"我方英雄周围120范围内的敌人物理防御-27点，法术防御-27点。",
	"我方英雄周围120范围内的敌人物理防御-30点，法术防御-30点。",
	"我方英雄周围120范围内的敌人物理防御-33点，法术防御-33点。",
	"我方英雄周围120范围内的敌人物理防御-36点，法术防御-36点。",
}

_tab_stringT[1085] = {"修罗堡垒",
	"我方防御塔暴击几率+2％。",
	"我方防御塔暴击几率+3％。",
	"我方防御塔暴击几率+4％。",
	"我方防御塔暴击几率+5％。",
	"我方防御塔暴击几率+6％。",
	"我方防御塔暴击几率+7％。",
	"我方防御塔暴击几率+8％。",
	"我方防御塔暴击几率+9％。",
	"我方防御塔暴击几率+10％。",
	"我方防御塔暴击几率+11％。",
}

_tab_stringT[1086] = {"紫气东来",
	"每过18秒，我方英雄回复自身最大生命值7％的血量。",
	"每过18秒，我方英雄回复自身最大生命值9％的血量。",
	"每过18秒，我方英雄回复自身最大生命值11％的血量。",
	"每过18秒，我方英雄回复自身最大生命值13％的血量。",
	"每过18秒，我方英雄回复自身最大生命值15％的血量。",
	"每过18秒，我方英雄回复自身最大生命值17％的血量。",
	"每过18秒，我方英雄回复自身最大生命值19％的血量。",
	"每过18秒，我方英雄回复自身最大生命值21％的血量。",
	"每过18秒，我方英雄回复自身最大生命值23％的血量。",
	"每过18秒，我方英雄回复自身最大生命值25％的血量。",
}

_tab_stringT[1087] = {"砖瓦结构",
	"我方防御塔闪避几率+25％。",
	"我方防御塔闪避几率+28％。",
	"我方防御塔闪避几率+31％。",
	"我方防御塔闪避几率+34％。",
	"我方防御塔闪避几率+37％。",
	"我方防御塔闪避几率+40％。",
	"我方防御塔闪避几率+43％。",
	"我方防御塔闪避几率+46％。",
	"我方防御塔闪避几率+49％。",
	"我方防御塔闪避几率+52％。",
}

_tab_stringT[1088] = {"矩阵冲车",
	"召唤3个超远距离攻击的弩车为你作战，持续10秒，冷却135秒。",
	"召唤3个超远距离攻击的弩车为你作战，持续14秒，冷却125秒。",
	"召唤3个超远距离攻击的弩车为你作战，持续18秒，冷却115秒。",
	"召唤3个超远距离攻击的弩车为你作战，持续22秒，冷却100秒。",
	"召唤3个超远距离攻击的弩车为你作战，持续26秒，冷却90秒。",
	"我方防御塔获得25％的闪避几率。",
	"我方防御塔获得25％的闪避几率。",
	"我方防御塔获得25％的闪避几率。",
	"我方防御塔获得25％的闪避几率。",
	"我方防御塔获得25％的闪避几率。",
}

_tab_stringT[1089] = {"流火强援",
	"召唤3个范围攻击的投石车为你作战，持续10秒，冷却135秒。",
	"召唤3个范围攻击的投石车为你作战，持续14秒，冷却125秒。",
	"召唤3个范围攻击的投石车为你作战，持续18秒，冷却115秒。",
	"召唤3个范围攻击的投石车为你作战，持续22秒，冷却100秒。",
	"召唤3个范围攻击的投石车为你作战，持续26秒，冷却90秒。",
	"我方防御塔获得25％的闪避几率。",
	"我方防御塔获得25％的闪避几率。",
	"我方防御塔获得25％的闪避几率。",
	"我方防御塔获得25％的闪避几率。",
	"我方防御塔获得25％的闪避几率。",
}

_tab_stringT[1090] = {"余温",
	"我方火焰塔每次攻击在地面留下火焰，对经过的敌人每秒造成20点法术伤害，持续5秒。",
	"我方火焰塔每次攻击在地面留下火焰，对经过的敌人每秒造成25点法术伤害，持续6秒。",
	"我方火焰塔每次攻击在地面留下火焰，对经过的敌人每秒造成30点法术伤害，持续7秒。",
	"我方火焰塔每次攻击在地面留下火焰，对经过的敌人每秒造成35点法术伤害，持续8秒。",
	"我方火焰塔每次攻击在地面留下火焰，对经过的敌人每秒造成40点法术伤害，持续9秒。",
	"我方火焰塔每次攻击在地面留下火焰，对经过的敌人每秒造成45点法术伤害，持续10秒。",
	"我方火焰塔每次攻击在地面留下火焰，对经过的敌人每秒造成50点法术伤害，持续11秒。",
	"我方火焰塔每次攻击在地面留下火焰，对经过的敌人每秒造成55点法术伤害，持续12秒。",
	"我方火焰塔每次攻击在地面留下火焰，对经过的敌人每秒造成60点法术伤害，持续13秒。",
	"我方火焰塔每次攻击在地面留下火焰，对经过的敌人每秒造成65点法术伤害，持续14秒。",
}

_tab_stringT[1091] = {"引力炮弹",
	"我方巨炮塔每次攻击发射的炮弹有10％的几率击将120范围内的敌人抛向空中，落地后继续眩晕1秒。",
	"我方巨炮塔每次攻击发射的炮弹有15％的几率击将120范围内的敌人抛向空中，落地后继续眩晕1秒。",
	"我方巨炮塔每次攻击发射的炮弹有20％的几率击将120范围内的敌人抛向空中，落地后继续眩晕1秒。",
	"我方巨炮塔每次攻击发射的炮弹有25％的几率击将120范围内的敌人抛向空中，落地后继续眩晕1秒。",
	"我方巨炮塔每次攻击发射的炮弹有30％的几率击将120范围内的敌人抛向空中，落地后继续眩晕1秒。",
	"我方巨炮塔每次攻击发射的炮弹有35％的几率击将120范围内的敌人抛向空中，落地后继续眩晕1秒。",
	"我方巨炮塔每次攻击发射的炮弹有40％的几率击将120范围内的敌人抛向空中，落地后继续眩晕1秒。",
	"我方巨炮塔每次攻击发射的炮弹有45％的几率击将120范围内的敌人抛向空中，落地后继续眩晕1秒。",
	"我方巨炮塔每次攻击发射的炮弹有50％的几率击将120范围内的敌人抛向空中，落地后继续眩晕1秒。",
	"我方巨炮塔每次攻击发射的炮弹有55％的几率击将120范围内的敌人抛向空中，落地后继续眩晕1秒。",
}

_tab_stringT[1092] = {"神火飞鸦",
	"我方狙击塔每次攻击命中目标后发生爆炸，对目标和目标周围90范围内的敌人造成狙击塔攻击力25％的物理伤害。",
	"我方狙击塔每次攻击命中目标后发生爆炸，对目标和目标周围90范围内的敌人造成狙击塔攻击力30％的物理伤害。",
	"我方狙击塔每次攻击命中目标后发生爆炸，对目标和目标周围90范围内的敌人造成狙击塔攻击力35％的物理伤害。",
	"我方狙击塔每次攻击命中目标后发生爆炸，对目标和目标周围90范围内的敌人造成狙击塔攻击力40％的物理伤害。",
	"我方狙击塔每次攻击命中目标后发生爆炸，对目标和目标周围90范围内的敌人造成狙击塔攻击力45％的物理伤害。",
	"我方狙击塔每次攻击命中目标后发生爆炸，对目标和目标周围90范围内的敌人造成狙击塔攻击力50％的物理伤害。",
	"我方狙击塔每次攻击命中目标后发生爆炸，对目标和目标周围90范围内的敌人造成狙击塔攻击力55％的物理伤害。",
	"我方狙击塔每次攻击命中目标后发生爆炸，对目标和目标周围90范围内的敌人造成狙击塔攻击力60％的物理伤害。",
	"我方狙击塔每次攻击命中目标后发生爆炸，对目标和目标周围90范围内的敌人造成狙击塔攻击力65％的物理伤害。",
	"我方狙击塔每次攻击命中目标后发生爆炸，对目标和目标周围90范围内的敌人造成狙击塔攻击力70％的物理伤害。",
}

_tab_stringT[1093] = {"急救应援",
	"召唤3个每次治疗最大生命10％的仙术师为你作战，持续10秒。冷却135秒。",
	"召唤3个每次治疗最大生命10％的仙术师为你作战，持续14秒。冷却125秒。",
	"召唤3个每次治疗最大生命10％的仙术师为你作战，持续18秒。冷却115秒。",
	"召唤3个每次治疗最大生命10％的仙术师为你作战，持续22秒。冷却100秒。",
	"召唤3个每次治疗最大生命10％的仙术师为你作战，持续26秒。冷却90秒。",
}

_tab_stringT[1094] = {"黑暗降至",
	"召唤3个能恐惧敌人1秒的妖术师为你作战，持续10秒。冷却135秒。",
	"召唤3个能恐惧敌人1秒的妖术师为你作战，持续14秒。冷却125秒。",
	"召唤3个能恐惧敌人1秒的妖术师为你作战，持续18秒。冷却115秒。",
	"召唤3个能恐惧敌人1秒的妖术师为你作战，持续22秒。冷却100秒。",
	"召唤3个能恐惧敌人1秒的妖术师为你作战，持续26秒。冷却90秒。",
}

_tab_stringT[1095] = {"野蛮阻挡",
	"召唤3个能够击退怪物的强壮力士为你作战，持续10秒。冷却135秒。",
	"召唤3个能够击退怪物的强壮力士为你作战，持续14秒。冷却125秒。",
	"召唤3个能够击退怪物的强壮力士为你作战，持续18秒。冷却115秒。",
	"召唤3个能够击退怪物的强壮力士为你作战，持续22秒。冷却100秒。",
	"召唤3个能够击退怪物的强壮力士为你作战，持续26秒。冷却90秒。",
}

_tab_stringT[1096] = {"调息",
	"我方英雄被动技能冷却时间-10％。",
	"我方英雄被动技能冷却时间-15％。",
	"我方英雄被动技能冷却时间-20％。",
	"我方英雄被动技能冷却时间-25％。",
	"我方英雄被动技能冷却时间-30％。",
}
_tab_stringT[1097] = {"复仇",
	"我方英雄阵亡时，我方英雄和部队获得复仇之力，增加25％的攻击力，持续8秒。",
	"我方英雄阵亡时，我方英雄和部队获得复仇之力，增加30％的攻击力，持续9秒。",
	"我方英雄阵亡时，我方英雄和部队获得复仇之力，增加35％的攻击力，持续10秒。",
	"我方英雄阵亡时，我方英雄和部队获得复仇之力，增加40％的攻击力，持续11秒。",
	"我方英雄阵亡时，我方英雄和部队获得复仇之力，增加45％的攻击力，持续12秒。",
}

_tab_stringT[1098] = {"断粮",
	"敌人治疗效果-20％。",
	"敌人治疗效果-25％。",
	"敌人治疗效果-30％。",
	"敌人治疗效果-35％。",
	"敌人治疗效果-40％。",
}

_tab_stringT[1099] = {"召唤祝福",
	"我方英雄召唤的单位生存时间+2秒。",
	"我方英雄召唤的单位生存时间+4秒。",
	"我方英雄召唤的单位生存时间+6秒。",
	"我方英雄召唤的单位生存时间+8秒。",
	"我方英雄召唤的单位生存时间+10秒，召唤数量翻倍。",
}


--------------------------------------------------------------------v

_tab_stringT[1101] = {"陷阱",
	"放置一颗陷阱，对踩到该陷阱的敌方单位造成巨大伤害。",
	"放置一颗陷阱，对踩到该陷阱的敌方单位造成巨大伤害。",
	"放置一颗陷阱，对踩到该陷阱的敌方单位造成巨大伤害。",

}

_tab_stringT[1102] = {"落石",
	"对一片区域的敌方单位造成伤害。",
	"对一片区域的敌方单位造成伤害。",
	"对一片区域的敌方单位造成伤害。",
}


_tab_stringT[1103] = {"援军",
	"召唤2个民兵为你战斗。民兵附加刘备44％的生命值、攻击力、物理防御、法术防御。民兵存在55秒。\n（施法范围：全地图）",
	"召唤2个民兵为你战斗。民兵附加刘备48％的生命值、攻击力、物理防御、法术防御。民兵存在55秒。\n（施法范围：全地图）",
	"召唤2个民兵为你战斗。民兵附加刘备52％的生命值、攻击力、物理防御、法术防御。民兵存在55秒。\n（施法范围：全地图）",
	"召唤2个民兵为你战斗。民兵附加刘备56％的生命值、攻击力、物理防御、法术防御。民兵存在55秒。\n（施法范围：全地图）",
	"召唤2个民兵为你战斗。民兵附加刘备60％的生命值、攻击力、物理防御、法术防御。民兵存在55秒。\n（施法范围：全地图）",
	"召唤2个民兵为你战斗。民兵附加刘备64％的生命值、攻击力、物理防御、法术防御。民兵存在55秒。\n（施法范围：全地图）",
	"召唤2个民兵为你战斗。民兵附加刘备68％的生命值、攻击力、物理防御、法术防御。民兵存在55秒。\n（施法范围：全地图）",
	"召唤2个民兵为你战斗。民兵附加刘备72％的生命值、攻击力、物理防御、法术防御。民兵存在55秒。\n（施法范围：全地图）",
	"召唤2个民兵为你战斗。民兵附加刘备76％的生命值、攻击力、物理防御、法术防御。民兵存在55秒。\n（施法范围：全地图）",
	"召唤2个民兵为你战斗。民兵附加刘备80％的生命值、攻击力、物理防御、法术防御。民兵存在55秒。\n（施法范围：全地图）",
	"召唤2个白耳兵为你战斗。白耳兵拥有超高物理闪避，并附加刘备84％的生命值、攻击力、物理防御、法术防御。白耳兵存在55秒。\n（施法范围：全地图）",
	"召唤2个白耳兵为你战斗。白耳兵拥有超高物理闪避，并附加刘备88％的生命值、攻击力、物理防御、法术防御。白耳兵存在55秒。\n（施法范围：全地图）",
	"召唤2个白耳兵为你战斗。白耳兵拥有超高物理闪避，并附加刘备92％的生命值、攻击力、物理防御、法术防御。白耳兵存在55秒。\n（施法范围：全地图）",
	"召唤2个白耳兵为你战斗。白耳兵拥有超高物理闪避，并附加刘备96％的生命值、攻击力、物理防御、法术防御。白耳兵存在55秒。\n（施法范围：全地图）",
	"召唤2个白耳兵为你战斗。白耳兵拥有超高物理闪避，并附加刘备100％的生命值、攻击力、物理防御、法术防御。白耳兵存在55秒。\n（施法范围：全地图）",
}

_tab_stringT[1104] = {"燕人咆哮",
	"发出恐怖的咆哮，对自身135范围内的敌人造成攻击力120％+60点的真实伤害，并混乱2秒。混乱期间目标不受操控并四处乱走。",
	"发出恐怖的咆哮，对自身135范围内的敌人造成攻击力140％+80点的真实伤害，并混乱2.2秒。混乱期间目标不受操控并四处乱走。",
	"发出恐怖的咆哮，对自身135范围内的敌人造成攻击力160％+100点的真实伤害，并混乱2.4秒。混乱期间目标不受操控并四处乱走。",
	"发出恐怖的咆哮，对自身135范围内的敌人造成攻击力180％+120点的真实伤害，并混乱2.6秒。混乱期间目标不受操控并四处乱走。",
	"发出恐怖的咆哮，对自身135范围内的敌人造成攻击力200％+140点的真实伤害，并混乱2.8秒。混乱期间目标不受操控并四处乱走。",
	"发出恐怖的咆哮，对自身135范围内的敌人造成攻击力220％+160点的真实伤害，并混乱3秒。混乱期间目标不受操控并四处乱走。",
	"发出恐怖的咆哮，对自身135范围内的敌人造成攻击力240％+180点的真实伤害，并混乱3.2秒。混乱期间目标不受操控并四处乱走。",
	"发出恐怖的咆哮，对自身135范围内的敌人造成攻击力260％+200点的真实伤害，并混乱3.4秒。混乱期间目标不受操控并四处乱走。",
	"发出恐怖的咆哮，对自身135范围内的敌人造成攻击力280％+220点的真实伤害，并混乱3.6秒。混乱期间目标不受操控并四处乱走。",
	"发出恐怖的咆哮，对自身135范围内的敌人造成攻击力300％+240点的真实伤害，并混乱3.8秒。混乱期间目标不受操控并四处乱走。",
	"发出恐怖的咆哮，对自身135范围内的敌人造成攻击力320％+260点的真实伤害，并混乱4秒。混乱期间目标不受操控并四处乱走。",
	"发出恐怖的咆哮，对自身135范围内的敌人造成攻击力340％+280点的真实伤害，并混乱4.2秒。混乱期间目标不受操控并四处乱走。",
	"发出恐怖的咆哮，对自身135范围内的敌人造成攻击力360％+300点的真实伤害，并混乱4.4秒。混乱期间目标不受操控并四处乱走。",
	"发出恐怖的咆哮，对自身135范围内的敌人造成攻击力380％+320点的真实伤害，并混乱4.6秒。混乱期间目标不受操控并四处乱走。",
	"发出恐怖的咆哮，对自身135范围内的敌人造成攻击力400％+340点的真实伤害，并混乱4.8秒。混乱期间目标不受操控并四处乱走。",
}

_tab_stringT[1105] = {"青龙乱舞",
	"挥出5轮刀舞，每轮都对自身120范围内的敌人造成攻击力60％+36点的物理伤害。",
	"挥出5轮刀舞，每轮都对自身120范围内的敌人造成攻击力72％+45点的物理伤害。",
	"挥出5轮刀舞，每轮都对自身120范围内的敌人造成攻击力84％+54点的物理伤害。",
	"挥出5轮刀舞，每轮都对自身120范围内的敌人造成攻击力96％+63点的物理伤害。",
	"挥出5轮刀舞，每轮都对自身120范围内的敌人造成攻击力108％+72点的物理伤害。",
	"挥出5轮刀舞，每轮都对自身120范围内的敌人造成攻击力120％+81点的物理伤害。",
	"挥出5轮刀舞，每轮都对自身120范围内的敌人造成攻击力132％+90点的物理伤害。",
	"挥出5轮刀舞，每轮都对自身120范围内的敌人造成攻击力144％+99点的物理伤害。",
	"挥出5轮刀舞，每轮都对自身120范围内的敌人造成攻击力156％+108点的物理伤害。",
	"挥出5轮刀舞，每轮都对自身120范围内的敌人造成攻击力168％+117点的物理伤害。",
	"挥出5轮刀舞，每轮都对自身120范围内的敌人造成攻击力180％+126点的物理伤害。",
	"挥出5轮刀舞，每轮都对自身120范围内的敌人造成攻击力192％+135点的物理伤害。",
	"挥出5轮刀舞，每轮都对自身120范围内的敌人造成攻击力204％+144点的物理伤害。",
	"挥出5轮刀舞，每轮都对自身120范围内的敌人造成攻击力216％+153点的物理伤害。",
	"挥出5轮刀舞，每轮都对自身120范围内的敌人造成攻击力228％+162点的物理伤害。",
}

_tab_stringT[1106] = {"军令如山",
	"召唤3个弓箭手为你战斗。弓箭手附加曹操22％生命值和44％攻击力、物理防御、法术防御。弓箭手存在25秒。\n（施法范围：全地图）",
	"召唤3个弓箭手为你战斗。弓箭手附加曹操24％生命值和48％攻击力、物理防御、法术防御。弓箭手存在25秒。\n（施法范围：全地图）",
	"召唤3个弓箭手为你战斗。弓箭手附加曹操26％生命值和52％攻击力、物理防御、法术防御。弓箭手存在25秒。\n（施法范围：全地图）",
	"召唤3个弓箭手为你战斗。弓箭手附加曹操28％生命值和56％攻击力、物理防御、法术防御。弓箭手存在25秒。\n（施法范围：全地图）",
	"召唤3个弓箭手为你战斗。弓箭手附加曹操30％生命值和60％攻击力、物理防御、法术防御。弓箭手存在25秒。\n（施法范围：全地图）",
	"召唤3个弓箭手为你战斗。弓箭手附加曹操32％生命值和64％攻击力、物理防御、法术防御。弓箭手存在25秒。\n（施法范围：全地图）",
	"召唤3个弓箭手为你战斗。弓箭手附加曹操34％生命值和68％攻击力、物理防御、法术防御。弓箭手存在25秒。\n（施法范围：全地图）",
	"召唤3个弓箭手为你战斗。弓箭手附加曹操36％生命值和72％攻击力、物理防御、法术防御。弓箭手存在25秒。\n（施法范围：全地图）",
	"召唤3个弓箭手为你战斗。弓箭手附加曹操38％生命值和76％攻击力、物理防御、法术防御。弓箭手存在25秒。\n（施法范围：全地图）",
	"召唤3个弓箭手为你战斗。弓箭手附加曹操40％生命值和80％攻击力、物理防御、法术防御。弓箭手存在25秒。\n（施法范围：全地图）",
	"召唤3个精锐弓箭手为你战斗。弓箭手拥有散射技能，并附加曹操42％生命值和84％攻击力、物理防御、法术防御。精锐弓箭手存在25秒。\n（施法范围：全地图）",
	"召唤3个精锐弓箭手为你战斗。弓箭手拥有散射技能，并附加曹操44％生命值和88％攻击力、物理防御、法术防御。精锐弓箭手存在25秒。\n（施法范围：全地图）",
	"召唤3个精锐弓箭手为你战斗。弓箭手拥有散射技能，并附加曹操46％生命值和92％攻击力、物理防御、法术防御。精锐弓箭手存在25秒。\n（施法范围：全地图）",
	"召唤3个精锐弓箭手为你战斗。弓箭手拥有散射技能，并附加曹操48％生命值和96％攻击力、物理防御、法术防御。精锐弓箭手存在25秒。\n（施法范围：全地图）",
	"召唤3个精锐弓箭手为你战斗。弓箭手拥有散射技能，并附加曹操50％生命值和100％攻击力、物理防御、法术防御。精锐弓箭手存在25秒。\n（施法范围：全地图）",
}

_tab_stringT[1107] = {"全军突击",
	"提升自己和附近120范围内的友军12％的移动速度、攻击速度、射程，持续15秒。",
	"提升自己和附近120范围内的友军13％的移动速度、攻击速度、射程，持续16秒。",
	"提升自己和附近120范围内的友军14％的移动速度、攻击速度、射程，持续17秒。",
	"提升自己和附近120范围内的友军15％的移动速度、攻击速度、射程，持续18秒。",
	"提升自己和附近120范围内的友军16％的移动速度、攻击速度、射程，持续19秒。",
	"提升自己和附近120范围内的友军17％的移动速度、攻击速度、射程，持续20秒。",
	"提升自己和附近120范围内的友军18％的移动速度、攻击速度、射程，持续21秒。",
	"提升自己和附近120范围内的友军19％的移动速度、攻击速度、射程，持续22秒。",
	"提升自己和附近120范围内的友军20％的移动速度、攻击速度、射程，持续23秒。",
	"提升自己和附近120范围内的友军21％的移动速度、攻击速度、射程，持续24秒。",
	"提升自己和附近120范围内的友军22％的移动速度、攻击速度、射程，持续25秒。",
	"提升自己和附近120范围内的友军23％的移动速度、攻击速度、射程，持续26秒。",
	"提升自己和附近120范围内的友军24％的移动速度、攻击速度、射程，持续27秒。",
	"提升自己和附近120范围内的友军25％的移动速度、攻击速度、射程，持续28秒。",
	"提升自己和附近120范围内的友军26％的移动速度、攻击速度、射程，持续29秒。",
}

_tab_stringT[1108] = {"冰河爆裂破",
	"发动连续的冰暴轰炸，对一直线上的敌人造成攻击力115％+180点的法术伤害，并冻结2.8秒。\n（施法范围：400）",
	"发动连续的冰暴轰炸，对一直线上的敌人造成攻击力130％+210点的法术伤害，并冻结2.9秒。\n（施法范围：400）",
	"发动连续的冰暴轰炸，对一直线上的敌人造成攻击力145％+240点的法术伤害，并冻结3秒。\n（施法范围：400）",
	"发动连续的冰暴轰炸，对一直线上的敌人造成攻击力160％+270点的法术伤害，并冻结3.1秒。\n（施法范围：400）",
	"发动连续的冰暴轰炸，对一直线上的敌人造成攻击力175％+300点的法术伤害，并冻结3.2秒。\n（施法范围：400）",
	"发动连续的冰暴轰炸，对一直线上的敌人造成攻击力190％+330点的法术伤害，并冻结3.3秒。\n（施法范围：400）",
	"发动连续的冰暴轰炸，对一直线上的敌人造成攻击力205％+360点的法术伤害，并冻结3.4秒。\n（施法范围：400）",
	"发动连续的冰暴轰炸，对一直线上的敌人造成攻击力220％+390点的法术伤害，并冻结3.5秒。\n（施法范围：400）",
	"发动连续的冰暴轰炸，对一直线上的敌人造成攻击力235％+420点的法术伤害，并冻结3.6秒。\n（施法范围：400）",
	"发动连续的冰暴轰炸，对一直线上的敌人造成攻击力250％+450点的法术伤害，并冻结3.7秒。\n（施法范围：400）",
	"发动连续的冰暴轰炸，对一直线上的敌人造成攻击力265％+480点的法术伤害，并冻结3.8秒。\n（施法范围：400）",
	"发动连续的冰暴轰炸，对一直线上的敌人造成攻击力280％+510点的法术伤害，并冻结3.9秒。\n（施法范围：400）",
	"发动连续的冰暴轰炸，对一直线上的敌人造成攻击力295％+540点的法术伤害，并冻结4秒。\n（施法范围：400）",
	"发动连续的冰暴轰炸，对一直线上的敌人造成攻击力310％+570点的法术伤害，并冻结4.1秒。\n（施法范围：400）",
	"发动连续的冰暴轰炸，对一直线上的敌人造成攻击力325％+600点的法术伤害，并冻结4.2秒。\n（施法范围：400）",
}

_tab_stringT[1109] = {"无双分身",
	"召唤1个拥有嘲讽、可操控的分身为你战斗。分身拥有赵云38％的生命值、攻击力、攻击速度、暴击几率、暴击倍率等属性，并拥有赵云的全部技能。分身受到200％的伤害。分身存在9秒。\n（施法范围：全地图）",
	"召唤1个拥有嘲讽、可操控的分身为你战斗。分身拥有赵云41％的生命值、攻击力、攻击速度、暴击几率、暴击倍率等属性，并拥有赵云的全部技能。分身受到200％的伤害。分身存在9.5秒。\n（施法范围：全地图）",
	"召唤1个拥有嘲讽、可操控的分身为你战斗。分身拥有赵云44％的生命值、攻击力、攻击速度、暴击几率、暴击倍率等属性，并拥有赵云的全部技能。分身受到200％的伤害。分身存在10秒。\n（施法范围：全地图）",
	"召唤1个拥有嘲讽、可操控的分身为你战斗。分身拥有赵云47％的生命值、攻击力、攻击速度、暴击几率、暴击倍率等属性，并拥有赵云的全部技能。分身受到200％的伤害。分身存在10.5秒。\n（施法范围：全地图）",
	"召唤1个拥有嘲讽、可操控的分身为你战斗。分身拥有赵云50％的生命值、攻击力、攻击速度、暴击几率、暴击倍率等属性，并拥有赵云的全部技能。分身受到200％的伤害。分身存在11秒。\n（施法范围：全地图）",
	"召唤1个拥有嘲讽、可操控的分身为你战斗。分身拥有赵云53％的生命值、攻击力、攻击速度、暴击几率、暴击倍率等属性，并拥有赵云的全部技能。分身受到200％的伤害。分身存在11.5秒。\n（施法范围：全地图）",
	"召唤1个拥有嘲讽、可操控的分身为你战斗。分身拥有赵云56％的生命值、攻击力、攻击速度、暴击几率、暴击倍率等属性，并拥有赵云的全部技能。分身受到200％的伤害。分身存在12秒。\n（施法范围：全地图）",
	"召唤1个拥有嘲讽、可操控的分身为你战斗。分身拥有赵云59％的生命值、攻击力、攻击速度、暴击几率、暴击倍率等属性，并拥有赵云的全部技能。分身受到200％的伤害。分身存在12.5秒。\n（施法范围：全地图）",
	"召唤1个拥有嘲讽、可操控的分身为你战斗。分身拥有赵云62％的生命值、攻击力、攻击速度、暴击几率、暴击倍率等属性，并拥有赵云的全部技能。分身受到200％的伤害。分身存在13秒。\n（施法范围：全地图）",
	"召唤1个拥有嘲讽、可操控的分身为你战斗。分身拥有赵云65％的生命值、攻击力、攻击速度、暴击几率、暴击倍率等属性，并拥有赵云的全部技能。分身受到200％的伤害。分身存在13.5秒。\n（施法范围：全地图）",
	"召唤1个拥有嘲讽、可操控的分身为你战斗。分身拥有赵云68％的生命值、攻击力、攻击速度、暴击几率、暴击倍率等属性，并拥有赵云的全部技能。分身受到200％的伤害。分身存在14秒。\n（施法范围：全地图）",
	"召唤1个拥有嘲讽、可操控的分身为你战斗。分身拥有赵云71％的生命值、攻击力、攻击速度、暴击几率、暴击倍率等属性，并拥有赵云的全部技能。分身受到200％的伤害。分身存在14.5秒。\n（施法范围：全地图）",
	"召唤1个拥有嘲讽、可操控的分身为你战斗。分身拥有赵云74％的生命值、攻击力、攻击速度、暴击几率、暴击倍率等属性，并拥有赵云的全部技能。分身受到200％的伤害。分身存在15秒。\n（施法范围：全地图）",
	"召唤1个拥有嘲讽、可操控的分身为你战斗。分身拥有赵云77％的生命值、攻击力、攻击速度、暴击几率、暴击倍率等属性，并拥有赵云的全部技能。分身受到200％的伤害。分身存在15.5秒。\n（施法范围：全地图）",
	"召唤1个拥有嘲讽、可操控的分身为你战斗。分身拥有赵云80％的生命值、攻击力、攻击速度、暴击几率、暴击倍率等属性，并拥有赵云的全部技能。分身受到200％的伤害。分身存在16秒。\n（施法范围：全地图）",
}

_tab_stringT[1110] = {"星轮斩",
	"同时发出5道月轮，每道都对一条直线上碰到的敌人造成攻击力100％+30点的物理伤害。",
	"同时发出5道月轮，每道都对一条直线上碰到的敌人造成攻击力110％+40点的物理伤害。",
	"同时发出5道月轮，每道都对一条直线上碰到的敌人造成攻击力120％+50点的物理伤害。",
	"同时发出5道月轮，每道都对一条直线上碰到的敌人造成攻击力130％+60点的物理伤害。",
	"同时发出5道月轮，每道都对一条直线上碰到的敌人造成攻击力140％+70点的物理伤害。",
	"同时发出5道月轮，每道都对一条直线上碰到的敌人造成攻击力150％+80点的物理伤害。",
	"同时发出5道月轮，每道都对一条直线上碰到的敌人造成攻击力160％+90点的物理伤害。",
	"同时发出5道月轮，每道都对一条直线上碰到的敌人造成攻击力170％+100点的物理伤害。",
	"同时发出5道月轮，每道都对一条直线上碰到的敌人造成攻击力180％+110点的物理伤害。",
	"同时发出5道月轮，每道都对一条直线上碰到的敌人造成攻击力190％+120点的物理伤害。",
	"同时发出5道月轮，每道都对一条直线上碰到的敌人造成攻击力200％+130点的物理伤害。",
	"同时发出5道月轮，每道都对一条直线上碰到的敌人造成攻击力210％+140点的物理伤害。",
	"同时发出5道月轮，每道都对一条直线上碰到的敌人造成攻击力220％+150点的物理伤害。",
	"同时发出5道月轮，每道都对一条直线上碰到的敌人造成攻击力230％+160点的物理伤害。",
	"同时发出5道月轮，每道都对一条直线上碰到的敌人造成攻击力240％+170点的物理伤害。",
}

_tab_stringT[1111] = {
	"无双战神",
	"激发战意，增加自身33％的攻击速度和移动速度、4点物理防御和法术防御、50％溅射，持续30秒。",
	"激发战意，增加自身36％的攻击速度和移动速度、8点物理防御和法术防御、50％溅射，持续30秒。",
	"激发战意，增加自身39％的攻击速度和移动速度、12点物理防御和法术防御、50％溅射，持续30秒。",
	"激发战意，增加自身42％的攻击速度和移动速度、16点物理防御和法术防御、50％溅射，持续30秒。",
	"激发战意，增加自身45％的攻击速度和移动速度、20点物理防御和法术防御、50％溅射，持续30秒。",
	"激发战意，增加自身48％的攻击速度和移动速度、24点物理防御和法术防御、50％溅射，持续30秒。",
	"激发战意，增加自身51％的攻击速度和移动速度、28点物理防御和法术防御、50％溅射，持续30秒。",
	"激发战意，增加自身54％的攻击速度和移动速度、32点物理防御和法术防御、50％溅射，持续30秒。",
	"激发战意，增加自身57％的攻击速度和移动速度、36点物理防御和法术防御、50％溅射，持续30秒。",
	"激发战意，增加自身60％的攻击速度和移动速度、40点物理防御和法术防御、50％溅射，持续30秒。",
	"激发战意，增加自身63％的攻击速度和移动速度、44点物理防御和法术防御、50％溅射，并获得免疫控制的效果，持续30秒。",
	"激发战意，增加自身66％的攻击速度和移动速度、48点物理防御和法术防御、50％溅射，并获得免疫控制的效果，持续30秒。",
	"激发战意，增加自身69％的攻击速度和移动速度、52点物理防御和法术防御、50％溅射，并获得免疫控制的效果，持续30秒。",
	"激发战意，增加自身72％的攻击速度和移动速度、56点物理防御和法术防御、50％溅射，并获得免疫控制的效果，持续30秒。",
	"激发战意，增加自身75％的攻击速度和移动速度、60点物理防御和法术防御、50％溅射，并获得免疫控制的效果，持续30秒。",
}

_tab_stringT[1112] = {"月下美人",
	"用曼妙的身姿魅惑120范围内的敌人，造成攻击力90％+120点的真实伤害，并降低90％的移动速度，持续5秒。同时增加自身20％的物理闪避和暴击几率，持续15秒。",
	"用曼妙的身姿魅惑120范围内的敌人，造成攻击力105％+140点的真实伤害，并降低90％的移动速度，持续5秒。同时增加自身22％的物理闪避和暴击几率，持续15秒。",
	"用曼妙的身姿魅惑120范围内的敌人，造成攻击力120％+160点的真实伤害，并降低90％的移动速度，持续5秒。同时增加自身24％的物理闪避和暴击几率，持续15秒。",
	"用曼妙的身姿魅惑120范围内的敌人，造成攻击力135％+180点的真实伤害，并降低90％的移动速度，持续5秒。同时增加自身26％的物理闪避和暴击几率，持续15秒。",
	"用曼妙的身姿魅惑120范围内的敌人，造成攻击力150％+200点的真实伤害，并降低90％的移动速度，持续5秒。同时增加自身28％的物理闪避和暴击几率，持续15秒。",
	"用曼妙的身姿魅惑120范围内的敌人，造成攻击力165％+220点的真实伤害，并降低90％的移动速度，持续5秒。同时增加自身30％的物理闪避和暴击几率，持续15秒。",
	"用曼妙的身姿魅惑120范围内的敌人，造成攻击力180％+240点的真实伤害，并降低90％的移动速度，持续5秒。同时增加自身32％的物理闪避和暴击几率，持续15秒。",
	"用曼妙的身姿魅惑120范围内的敌人，造成攻击力195％+260点的真实伤害，并降低90％的移动速度，持续5秒。同时增加自身34％的物理闪避和暴击几率，持续15秒。",
	"用曼妙的身姿魅惑120范围内的敌人，造成攻击力210％+280点的真实伤害，并降低90％的移动速度，持续5秒。同时增加自身36％的物理闪避和暴击几率，持续15秒。",
	"用曼妙的身姿魅惑120范围内的敌人，造成攻击力225％+300点的真实伤害，并降低90％的移动速度，持续5秒。同时增加自身38％的物理闪避和暴击几率，持续15秒。",
	"用曼妙的身姿魅惑120范围内的敌人，造成攻击力240％+320点的真实伤害，并降低90％的移动速度，持续5秒。同时增加自身40％的物理闪避和暴击几率，持续15秒。",
	"用曼妙的身姿魅惑120范围内的敌人，造成攻击力255％+340点的真实伤害，并降低90％的移动速度，持续5秒。同时增加自身42％的物理闪避和暴击几率，持续15秒。",
	"用曼妙的身姿魅惑120范围内的敌人，造成攻击力270％+360点的真实伤害，并降低90％的移动速度，持续5秒。同时增加自身44％的物理闪避和暴击几率，持续15秒。",
	"用曼妙的身姿魅惑120范围内的敌人，造成攻击力295％+380点的真实伤害，并降低90％的移动速度，持续5秒。同时增加自身46％的物理闪避和暴击几率，持续15秒。",
	"用曼妙的身姿魅惑120范围内的敌人，造成攻击力310％+400点的真实伤害，并降低90％的移动速度，持续5秒。同时增加自身48％的物理闪避和暴击几率，持续15秒。",
}


_tab_stringT[1113] = {"猩红战阵",
	"将150范围内的敌人拉至张辽身边，造成6倍物理防御的物理伤害，并震晕1.2秒。",
	"将150范围内的敌人拉至张辽身边，造成7倍物理防御的物理伤害，并震晕1.4秒。",
	"将150范围内的敌人拉至张辽身边，造成8倍物理防御的物理伤害，并震晕1.6秒。",
	"将150范围内的敌人拉至张辽身边，造成9倍物理防御的物理伤害，并震晕1.8秒。",
	"将150范围内的敌人拉至张辽身边，造成10倍物理防御的物理伤害，并震晕2秒。",
	"将150范围内的敌人拉至张辽身边，造成11倍物理防御的物理伤害，并震晕2.2秒。",
	"将150范围内的敌人拉至张辽身边，造成12倍物理防御的物理伤害，并震晕2.4秒。",
	"将150范围内的敌人拉至张辽身边，造成13倍物理防御的物理伤害，并震晕2.6秒。",
	"将150范围内的敌人拉至张辽身边，造成14倍物理防御的物理伤害，并震晕2.8秒。",
	"将150范围内的敌人拉至张辽身边，造成15倍物理防御的物理伤害，并震晕3秒。",
	"将150范围内的敌人拉至张辽身边，造成16倍物理防御的物理伤害，并震晕3.2秒。",
	"将150范围内的敌人拉至张辽身边，造成17倍物理防御的物理伤害，并震晕3.4秒。",
	"将150范围内的敌人拉至张辽身边，造成18倍物理防御的物理伤害，并震晕3.6秒。",
	"将150范围内的敌人拉至张辽身边，造成19倍物理防御的物理伤害，并震晕3.8秒。",
	"将150范围内的敌人拉至张辽身边，造成20倍物理防御的物理伤害，并震晕4秒。",
}

_tab_stringT[1114] = {"裸衣",
	"对自身200范围内的敌人造成攻击力100％的物理伤害，并爆衣出阵，将自己的物理防御降为0点。失去的每1点物理防御，都会转化为增加自身0.1点攻击力，和降低敌人0.1点物理防御，持续15秒。",
	"对自身200范围内的敌人造成攻击力100％的物理伤害，并爆衣出阵，将自己的物理防御降为0点。失去的每1点物理防御，都会转化为增加自身0.2点攻击力，和降低敌人0.2点物理防御，持续15秒。",
	"对自身200范围内的敌人造成攻击力100％的物理伤害，并爆衣出阵，将自己的物理防御降为0点。失去的每1点物理防御，都会转化为增加自身0.3点攻击力，和降低敌人0.3点物理防御，持续15秒。",
	"对自身200范围内的敌人造成攻击力100％的物理伤害，并爆衣出阵，将自己的物理防御降为0点。失去的每1点物理防御，都会转化为增加自身0.4点攻击力，和降低敌人0.4点物理防御，持续15秒。",
	"对自身200范围内的敌人造成攻击力100％的物理伤害，并爆衣出阵，将自己的物理防御降为0点。失去的每1点物理防御，都会转化为增加自身0.5点攻击力，和降低敌人0.5点物理防御，持续15秒。",
	"对自身200范围内的敌人造成攻击力100％的物理伤害，并爆衣出阵，将自己的物理防御降为0点。失去的每1点物理防御，都会转化为增加自身0.6点攻击力，和降低敌人0.6点物理防御，持续15秒。",
	"对自身200范围内的敌人造成攻击力100％的物理伤害，并爆衣出阵，将自己的物理防御降为0点。失去的每1点物理防御，都会转化为增加自身0.7点攻击力，和降低敌人0.7点物理防御，持续15秒。",
	"对自身200范围内的敌人造成攻击力100％的物理伤害，并爆衣出阵，将自己的物理防御降为0点。失去的每1点物理防御，都会转化为增加自身0.8点攻击力，和降低敌人0.8点物理防御，持续15秒。",
	"对自身200范围内的敌人造成攻击力100％的物理伤害，并爆衣出阵，将自己的物理防御降为0点。失去的每1点物理防御，都会转化为增加自身0.9点攻击力，和降低敌人0.9点物理防御，持续15秒。",
	"对自身200范围内的敌人造成攻击力100％的物理伤害，并爆衣出阵，将自己的物理防御降为0点。失去的每1点物理防御，都会转化为增加自身1点攻击力，和降低敌人1点物理防御，持续15秒。",
	"对自身200范围内的敌人造成攻击力100％的物理伤害，并爆衣出阵，将自己的物理防御降为0点。失去的每1点物理防御，都会转化为增加自身1.1点攻击力，和降低敌人1.1点物理防御，持续15秒。",
	"对自身200范围内的敌人造成攻击力100％的物理伤害，并爆衣出阵，将自己的物理防御降为0点。失去的每1点物理防御，都会转化为增加自身1.2点攻击力，和降低敌人1.2点物理防御，持续15秒。",
	"对自身200范围内的敌人造成攻击力100％的物理伤害，并爆衣出阵，将自己的物理防御降为0点。失去的每1点物理防御，都会转化为增加自身1.3点攻击力，和降低敌人1.3点物理防御，持续15秒。",
	"对自身200范围内的敌人造成攻击力100％的物理伤害，并爆衣出阵，将自己的物理防御降为0点。失去的每1点物理防御，都会转化为增加自身1.4点攻击力，和降低敌人1.4点物理防御，持续15秒。",
	"对自身200范围内的敌人造成攻击力100％的物理伤害，并爆衣出阵，将自己的物理防御降为0点。失去的每1点物理防御，都会转化为增加自身1.5点攻击力，和降低敌人1.5点物理防御，持续15秒。",
}


_tab_stringT[1115] = {"血煞",
	"拼死血战，消耗自己所有生命值，同时提升68％的攻击速度和16％的吸血，持续9秒。在此期间典韦不会死亡，生命值最低为1点。",
	"拼死血战，消耗自己所有生命值，同时提升76％的攻击速度和17％的吸血，持续9秒。在此期间典韦不会死亡，生命值最低为1点。",
	"拼死血战，消耗自己所有生命值，同时提升84％的攻击速度和18％的吸血，持续9秒。在此期间典韦不会死亡，生命值最低为1点。",
	"拼死血战，消耗自己所有生命值，同时提升92％的攻击速度和19％的吸血，持续9秒。在此期间典韦不会死亡，生命值最低为1点。",
	"拼死血战，消耗自己所有生命值，同时提升100％的攻击速度和20％的吸血，持续9秒。在此期间典韦不会死亡，生命值最低为1点。",
	"拼死血战，消耗自己所有生命值，同时提升108％的攻击速度和21％的吸血，持续9秒。在此期间典韦不会死亡，生命值最低为1点。",
	"拼死血战，消耗自己所有生命值，同时提升116％的攻击速度和22％的吸血，持续9秒。在此期间典韦不会死亡，生命值最低为1点。",
	"拼死血战，消耗自己所有生命值，同时提升124％的攻击速度和23％的吸血，持续9秒。在此期间典韦不会死亡，生命值最低为1点。",
	"拼死血战，消耗自己所有生命值，同时提升132％的攻击速度和24％的吸血，持续9秒。在此期间典韦不会死亡，生命值最低为1点。",
	"拼死血战，消耗自己所有生命值，同时提升140％的攻击速度和25％的吸血，持续9秒。在此期间典韦不会死亡，生命值最低为1点。",
	"拼死血战，消耗自己所有生命值，同时提升148％的攻击速度和26％的吸血，持续9秒。在此期间典韦不会死亡，生命值最低为1点。",
	"拼死血战，消耗自己所有生命值，同时提升156％的攻击速度和27％的吸血，持续9秒。在此期间典韦不会死亡，生命值最低为1点。",
	"拼死血战，消耗自己所有生命值，同时提升164％的攻击速度和28％的吸血，持续9秒。在此期间典韦不会死亡，生命值最低为1点。",
	"拼死血战，消耗自己所有生命值，同时提升172％的攻击速度和29％的吸血，持续9秒。在此期间典韦不会死亡，生命值最低为1点。",
	"拼死血战，消耗自己所有生命值，同时提升180％的攻击速度和30％的吸血，持续9秒。在此期间典韦不会死亡，生命值最低为1点。",
}




_tab_stringT[1116] = {"风驰电掣",
	"以极快的速度闪现到目标地点，并连续发动1次攻击，每次对附近随机的一个敌人造成攻击力100％的物理伤害。在此期间甘宁处于无敌状态。\n（施法范围：600）",
	"以极快的速度闪现到目标地点，并连续发动2次攻击，每次对附近随机的一个敌人造成攻击力115％的物理伤害。在此期间甘宁处于无敌状态。\n（施法范围：600）",
	"以极快的速度闪现到目标地点，并连续发动3次攻击，每次对附近随机的一个敌人造成攻击力130％的物理伤害。在此期间甘宁处于无敌状态。\n（施法范围：600）",
	"以极快的速度闪现到目标地点，并连续发动4次攻击，每次对附近随机的一个敌人造成攻击力145％的物理伤害。在此期间甘宁处于无敌状态。\n（施法范围：600）",
	"以极快的速度闪现到目标地点，并连续发动5次攻击，每次对附近随机的一个敌人造成攻击力160％的物理伤害。在此期间甘宁处于无敌状态。\n（施法范围：600）",
	"以极快的速度闪现到目标地点，并连续发动6次攻击，每次对附近随机的一个敌人造成攻击力175％的物理伤害。在此期间甘宁处于无敌状态。\n（施法范围：600）",
	"以极快的速度闪现到目标地点，并连续发动7次攻击，每次对附近随机的一个敌人造成攻击力190％的物理伤害。在此期间甘宁处于无敌状态。\n（施法范围：600）",
	"以极快的速度闪现到目标地点，并连续发动8次攻击，每次对附近随机的一个敌人造成攻击力205％的物理伤害。在此期间甘宁处于无敌状态。\n（施法范围：600）",
	"以极快的速度闪现到目标地点，并连续发动9次攻击，每次对附近随机的一个敌人造成攻击力220％的物理伤害。在此期间甘宁处于无敌状态。\n（施法范围：600）",
	"以极快的速度闪现到目标地点，并连续发动10次攻击，每次对附近随机的一个敌人造成攻击力235％的物理伤害。在此期间甘宁处于无敌状态。\n（施法范围：600）",
	"以极快的速度闪现到目标地点，并连续发动12次攻击，每次对附近随机的一个敌人造成攻击力250％的物理伤害。在此期间甘宁处于无敌状态。\n（施法范围：600）",
	"以极快的速度闪现到目标地点，并连续发动14次攻击，每次对附近随机的一个敌人造成攻击力265％的物理伤害。在此期间甘宁处于无敌状态。\n（施法范围：600）",
	"以极快的速度闪现到目标地点，并连续发动16次攻击，每次对附近随机的一个敌人造成攻击力280％的物理伤害。在此期间甘宁处于无敌状态。\n（施法范围：600）",
	"以极快的速度闪现到目标地点，并连续发动18次攻击，每次对附近随机的一个敌人造成攻击力295％的物理伤害。在此期间甘宁处于无敌状态。\n（施法范围：600）",
	"以极快的速度闪现到目标地点，并连续发动20次攻击，每次对附近随机的一个敌人造成攻击力310％的物理伤害。在此期间甘宁处于无敌状态。\n（施法范围：600）",
}

_tab_stringT[1117] = {"霸气剑光",
	"随机在目标地点100范围内召唤12把落剑，每一把落剑都对小范围敌人造成攻击力100％+60点的真实伤害。\n（施法范围：200）",
	"随机在目标地点100范围内召唤12把落剑，每一把落剑都对小范围敌人造成攻击力110％+75点的真实伤害。\n（施法范围：200）",
	"随机在目标地点100范围内召唤12把落剑，每一把落剑都对小范围敌人造成攻击力120％+90点的真实伤害。\n（施法范围：200）",
	"随机在目标地点100范围内召唤12把落剑，每一把落剑都对小范围敌人造成攻击力130％+105点的真实伤害。\n（施法范围：200）",
	"随机在目标地点100范围内召唤12把落剑，每一把落剑都对小范围敌人造成攻击力140％+120点的真实伤害。\n（施法范围：200）",
	"随机在目标地点100范围内召唤12把落剑，每一把落剑都对小范围敌人造成攻击力150％+135点的真实伤害。\n（施法范围：200）",
	"随机在目标地点100范围内召唤12把落剑，每一把落剑都对小范围敌人造成攻击力160％+150点的真实伤害。\n（施法范围：200）",
	"随机在目标地点100范围内召唤12把落剑，每一把落剑都对小范围敌人造成攻击力170％+165点的真实伤害。\n（施法范围：200）",
	"随机在目标地点100范围内召唤12把落剑，每一把落剑都对小范围敌人造成攻击力180％+180点的真实伤害。\n（施法范围：200）",
	"随机在目标地点100范围内召唤12把落剑，每一把落剑都对小范围敌人造成攻击力190％+195点的真实伤害。\n（施法范围：200）",
	"随机在目标地点100范围内召唤12把落剑，每一把落剑都对小范围敌人造成攻击力200％+210点的真实伤害。\n（施法范围：200）",
	"随机在目标地点100范围内召唤12把落剑，每一把落剑都对小范围敌人造成攻击力210％+225点的真实伤害。\n（施法范围：200）",
	"随机在目标地点100范围内召唤12把落剑，每一把落剑都对小范围敌人造成攻击力220％+240点的真实伤害。\n（施法范围：200）",
	"随机在目标地点100范围内召唤12把落剑，每一把落剑都对小范围敌人造成攻击力230％+255点的真实伤害。\n（施法范围：200）",
	"随机在目标地点100范围内召唤12把落剑，每一把落剑都对小范围敌人造成攻击力240％+270点的真实伤害。\n（施法范围：200）",
}

_tab_stringT[1118] = {"召唤水兵",
	"召唤4个水兵为你战斗。水兵附加周瑜44％的生命值、攻击力、物理防御、法术防御。水兵存在25秒。\n（施法范围：全地图）",
	"召唤4个水兵为你战斗。水兵附加周瑜48％的生命值、攻击力、物理防御、法术防御。水兵存在25秒。\n（施法范围：全地图）",
	"召唤4个水兵为你战斗。水兵附加周瑜52％的生命值、攻击力、物理防御、法术防御。水兵存在25秒。\n（施法范围：全地图）",
	"召唤4个水兵为你战斗。水兵附加周瑜56％的生命值、攻击力、物理防御、法术防御。水兵存在25秒。\n（施法范围：全地图）",
	"召唤4个水兵为你战斗。水兵附加周瑜60％的生命值、攻击力、物理防御、法术防御。水兵存在25秒。\n（施法范围：全地图）",
	"召唤4个水兵为你战斗。水兵附加周瑜64％的生命值、攻击力、物理防御、法术防御。水兵存在25秒。\n（施法范围：全地图）",
	"召唤4个水兵为你战斗。水兵附加周瑜68％的生命值、攻击力、物理防御、法术防御。水兵存在25秒。\n（施法范围：全地图）",
	"召唤4个水兵为你战斗。水兵附加周瑜72％的生命值、攻击力、物理防御、法术防御。水兵存在25秒。\n（施法范围：全地图）",
	"召唤4个水兵为你战斗。水兵附加周瑜76％的生命值、攻击力、物理防御、法术防御。水兵存在25秒。\n（施法范围：全地图）",
	"召唤4个水兵为你战斗。水兵附加周瑜80％的生命值、攻击力、物理防御、法术防御。水兵存在25秒。\n（施法范围：全地图）",
	"召唤4个鳞甲水兵为你战斗。鳞甲水兵拥有免疫控制和减速效果，并附加周瑜84％的生命值、攻击力、物理防御、法术防御。鳞甲水兵存在25秒。\n（施法范围：全地图）",
	"召唤4个鳞甲水兵为你战斗。鳞甲水兵拥有免疫控制和减速效果，并附加周瑜88％的生命值、攻击力、物理防御、法术防御。鳞甲水兵存在25秒。\n（施法范围：全地图）",
	"召唤4个鳞甲水兵为你战斗。鳞甲水兵拥有免疫控制和减速效果，并附加周瑜92％的生命值、攻击力、物理防御、法术防御。鳞甲水兵存在25秒。\n（施法范围：全地图）",
	"召唤4个鳞甲水兵为你战斗。鳞甲水兵拥有免疫控制和减速效果，并附加周瑜96％的生命值、攻击力、物理防御、法术防御。鳞甲水兵存在25秒。\n（施法范围：全地图）",
	"召唤4个鳞甲水兵为你战斗。鳞甲水兵拥有免疫控制和减速效果，并附加周瑜100％的生命值、攻击力、物理防御、法术防御。鳞甲水兵存在25秒。\n（施法范围：全地图）",
}

--徐庶技能
_tab_stringT[1119] = {"剑影瞬杀阵",
	"化身为剑影，对目标地点150范围内的敌人连续发动7段攻击，每段造成攻击力50％+20～40点的物理伤害。最后1段额外造成穿刺，并将敌人抛向空中，落地后继续眩晕1秒。\n（施法范围：360）",
	"化身为剑影，对目标地点150范围内的敌人连续发动7段攻击，每段造成攻击力55％+30～60点的物理伤害。最后1段额外造成穿刺，并将敌人抛向空中，落地后继续眩晕1秒。\n（施法范围：360）",
	"化身为剑影，对目标地点150范围内的敌人连续发动7段攻击，每段造成攻击力60％+40～80点的物理伤害。最后1段额外造成穿刺，并将敌人抛向空中，落地后继续眩晕1秒。\n（施法范围：360）",
	"化身为剑影，对目标地点150范围内的敌人连续发动7段攻击，每段造成攻击力65％+50～100点的物理伤害。最后1段额外造成穿刺，并将敌人抛向空中，落地后继续眩晕1秒。\n（施法范围：360）",
	"化身为剑影，对目标地点150范围内的敌人连续发动7段攻击，每段造成攻击力70％+60～120点的物理伤害。最后1段额外造成穿刺，并将敌人抛向空中，落地后继续眩晕1秒。\n（施法范围：360）",
	"化身为剑影，对目标地点150范围内的敌人连续发动7段攻击，每段造成攻击力75％+70～140点的物理伤害。最后1段额外造成穿刺，并将敌人抛向空中，落地后继续眩晕1秒。\n（施法范围：360）",
	"化身为剑影，对目标地点150范围内的敌人连续发动7段攻击，每段造成攻击力80％+80～160点的物理伤害。最后1段额外造成穿刺，并将敌人抛向空中，落地后继续眩晕1秒。\n（施法范围：360）",
	"化身为剑影，对目标地点150范围内的敌人连续发动7段攻击，每段造成攻击力85％+90～180点的物理伤害。最后1段额外造成穿刺，并将敌人抛向空中，落地后继续眩晕1秒。\n（施法范围：360）",
	"化身为剑影，对目标地点150范围内的敌人连续发动7段攻击，每段造成攻击力90％+100～200点的物理伤害。最后1段额外造成穿刺，并将敌人抛向空中，落地后继续眩晕1秒。\n（施法范围：360）",
	"化身为剑影，对目标地点150范围内的敌人连续发动7段攻击，每段造成攻击力95％+110～220点的物理伤害。最后1段额外造成穿刺，并将敌人抛向空中，落地后继续眩晕1秒。\n（施法范围：360）",
	"化身为剑影，对目标地点150范围内的敌人连续发动7段攻击，每段造成攻击力100％+120～240点的物理伤害。最后1段额外造成穿刺，并将敌人抛向空中，落地后继续眩晕1秒。\n（施法范围：360）",
	"化身为剑影，对目标地点150范围内的敌人连续发动7段攻击，每段造成攻击力105％+130～260点的物理伤害。最后1段额外造成穿刺，并将敌人抛向空中，落地后继续眩晕1秒。\n（施法范围：360）",
	"化身为剑影，对目标地点150范围内的敌人连续发动7段攻击，每段造成攻击力110％+140～280点的物理伤害。最后1段额外造成穿刺，并将敌人抛向空中，落地后继续眩晕1秒。\n（施法范围：360）",
	"化身为剑影，对目标地点150范围内的敌人连续发动7段攻击，每段造成攻击力115％+150～300点的物理伤害。最后1段额外造成穿刺，并将敌人抛向空中，落地后继续眩晕1秒。\n（施法范围：360）",
	"化身为剑影，对目标地点150范围内的敌人连续发动7段攻击，每段造成攻击力120％+160～320点的物理伤害。最后1段额外造成穿刺，并将敌人抛向空中，落地后继续眩晕1秒。\n（施法范围：360）",
}

_tab_stringT[1120] =
{
	"卧龙光线",
	"同时发射5道光线，每道都对一条直线上碰到的敌人造成攻击力80％+40点的法术伤害。\n（施法范围：300）",
	"同时发射5道光线，每道都对一条直线上碰到的敌人造成攻击力92％+60点的法术伤害。\n（施法范围：300）",
	"同时发射5道光线，每道都对一条直线上碰到的敌人造成攻击力104％+80点的法术伤害。\n（施法范围：300）",
	"同时发射5道光线，每道都对一条直线上碰到的敌人造成攻击力116％+100点的法术伤害。\n（施法范围：300）",
	"同时发射5道光线，每道都对一条直线上碰到的敌人造成攻击力128％+120点的法术伤害。\n（施法范围：300）",
	"同时发射5道光线，每道都对一条直线上碰到的敌人造成攻击力140％+140点的法术伤害。\n（施法范围：300）",
	"同时发射5道光线，每道都对一条直线上碰到的敌人造成攻击力152％+160点的法术伤害。\n（施法范围：300）",
	"同时发射5道光线，每道都对一条直线上碰到的敌人造成攻击力164％+180点的法术伤害。\n（施法范围：300）",
	"同时发射5道光线，每道都对一条直线上碰到的敌人造成攻击力176％+200点的法术伤害。\n（施法范围：300）",
	"同时发射5道光线，每道都对一条直线上碰到的敌人造成攻击力188％+220点的法术伤害。\n（施法范围：300）",
	"同时发射5道光线，每道都对一条直线上碰到的敌人造成攻击力200％+240点的法术伤害。\n（施法范围：300）",
	"同时发射5道光线，每道都对一条直线上碰到的敌人造成攻击力212％+260点的法术伤害。\n（施法范围：300）",
	"同时发射5道光线，每道都对一条直线上碰到的敌人造成攻击力224％+280点的法术伤害。\n（施法范围：300）",
	"同时发射5道光线，每道都对一条直线上碰到的敌人造成攻击力236％+300点的法术伤害。\n（施法范围：300）",
	"同时发射5道光线，每道都对一条直线上碰到的敌人造成攻击力248％+320点的法术伤害。\n（施法范围：300）",
}


_tab_stringT[1121] = {"御魂甘露",
	"凝水为盾，为自己和所有友方英雄施加甘露，提升16点法术防御、每秒20点回血，持续7秒。",
	"凝水为盾，为自己和所有友方英雄施加甘露，提升20点法术防御、每秒35点回血，持续7秒。",
	"凝水为盾，为自己和所有友方英雄施加甘露，提升24点法术防御、每秒50点回血，持续7秒。",
	"凝水为盾，为自己和所有友方英雄施加甘露，提升28点法术防御、每秒65点回血，持续7秒。",
	"凝水为盾，为自己和所有友方英雄施加甘露，提升32点法术防御、每秒80点回血，持续7秒。",
	"凝水为盾，为自己和所有友方英雄施加甘露，提升36点法术防御、每秒95点回血，持续7秒。",
	"凝水为盾，为自己和所有友方英雄施加甘露，提升40点法术防御、每秒110点回血，持续7秒。",
	"凝水为盾，为自己和所有友方英雄施加甘露，提升44点法术防御、每秒125点回血，持续7秒。",
	"凝水为盾，为自己和所有友方英雄施加甘露，提升48点法术防御、每秒140点回血，持续7秒。",
	"凝水为盾，为自己和所有友方英雄施加甘露，提升52点法术防御、每秒155点回血，持续7秒。",
	"凝水为盾，为自己和所有友方英雄施加甘露，提升56点法术防御、每秒170点回血，持续7秒。",
	"凝水为盾，为自己和所有友方英雄施加甘露，提升60点法术防御、每秒185点回血，持续7秒。",
	"凝水为盾，为自己和所有友方英雄施加甘露，提升64点法术防御、每秒200点回血，持续7秒。",
	"凝水为盾，为自己和所有友方英雄施加甘露，提升68点法术防御、每秒215点回血，持续7秒。",
	"凝水为盾，为自己和所有友方英雄施加甘露，提升72点法术防御、每秒230点回血，持续7秒。",
}

_tab_stringT[1122] = {"东皇之力",
	"借助东皇之力，使所有友军英雄的战术技能冷却缩短26秒，并使自己和所有友方英雄获得1秒无敌状态。",
	"借助东皇之力，使所有友军英雄的战术技能冷却缩短28秒，并使自己和所有友方英雄获得1.2秒无敌状态。",
	"借助东皇之力，使所有友军英雄的战术技能冷却缩短30秒，并使自己和所有友方英雄获得1.4秒无敌状态。",
	"借助东皇之力，使所有友军英雄的战术技能冷却缩短32秒，并使自己和所有友方英雄获得1.6秒无敌状态。",
	"借助东皇之力，使所有友军英雄的战术技能冷却缩短34秒，并使自己和所有友方英雄获得1.8秒无敌状态。",
	"借助东皇之力，使所有友军英雄的战术技能冷却缩短36秒，并使自己和所有友方英雄获得2秒无敌状态。",
	"借助东皇之力，使所有友军英雄的战术技能冷却缩短38秒，并使自己和所有友方英雄获得2.2秒无敌状态。",
	"借助东皇之力，使所有友军英雄的战术技能冷却缩短40秒，并使自己和所有友方英雄获得2.4秒无敌状态。",
	"借助东皇之力，使所有友军英雄的战术技能冷却缩短42秒，并使自己和所有友方英雄获得2.6秒无敌状态。",
	"借助东皇之力，使所有友军英雄的战术技能冷却缩短44秒，并使自己和所有友方英雄获得2.8秒无敌状态。",
	"借助东皇之力，使所有友军英雄的战术技能冷却缩短46秒，并使自己和所有友方英雄获得3秒无敌状态。",
	"借助东皇之力，使所有友军英雄的战术技能冷却缩短48秒，并使自己和所有友方英雄获得3.2秒无敌状态。",
	"借助东皇之力，使所有友军英雄的战术技能冷却缩短50秒，并使自己和所有友方英雄获得3.4秒无敌状态。",
	"借助东皇之力，使所有友军英雄的战术技能冷却缩短52秒，并使自己和所有友方英雄获得3.6秒无敌状态。",
	"借助东皇之力，使所有友军英雄的战术技能冷却缩短54秒，并使自己和所有友方英雄获得3.8秒无敌状态。",
}

_tab_stringT[1123] = {"黑炎漩涡",
	"在目标地点创造一个漩涡，持续将150范围内的敌人吸入漩涡。在此期间目标不能攻击、移动、释放技能，并每秒受到庞统攻击力300％的法术伤害。漩涡持续3秒。\n（施法范围：600）",
	"在目标地点创造一个漩涡，持续将150范围内的敌人吸入漩涡。在此期间目标不能攻击、移动、释放技能，并每秒受到庞统攻击力300％的法术伤害。漩涡持续3.5秒。\n（施法范围：600）",
	"在目标地点创造一个漩涡，持续将150范围内的敌人吸入漩涡。在此期间目标不能攻击、移动、释放技能，并每秒受到庞统攻击力300％的法术伤害。漩涡持续4秒。\n（施法范围：600）",
	"在目标地点创造一个漩涡，持续将150范围内的敌人吸入漩涡。在此期间目标不能攻击、移动、释放技能，并每秒受到庞统攻击力300％的法术伤害。漩涡持续4.5秒。\n（施法范围：600）",
	"在目标地点创造一个漩涡，持续将150范围内的敌人吸入漩涡。在此期间目标不能攻击、移动、释放技能，并每秒受到庞统攻击力300％的法术伤害。漩涡持续5秒。\n（施法范围：600）",
	"在目标地点创造一个漩涡，持续将150范围内的敌人吸入漩涡。在此期间目标不能攻击、移动、释放技能，并每秒受到庞统攻击力300％的法术伤害。漩涡持续5.5秒。\n（施法范围：600）",
	"在目标地点创造一个漩涡，持续将150范围内的敌人吸入漩涡。在此期间目标不能攻击、移动、释放技能，并每秒受到庞统攻击力300％的法术伤害。漩涡持续6秒。\n（施法范围：600）",
	"在目标地点创造一个漩涡，持续将150范围内的敌人吸入漩涡。在此期间目标不能攻击、移动、释放技能，并每秒受到庞统攻击力300％的法术伤害。漩涡持续6.5秒。\n（施法范围：600）",
	"在目标地点创造一个漩涡，持续将150范围内的敌人吸入漩涡。在此期间目标不能攻击、移动、释放技能，并每秒受到庞统攻击力300％的法术伤害。漩涡持续7秒。\n（施法范围：600）",
	"在目标地点创造一个漩涡，持续将150范围内的敌人吸入漩涡。在此期间目标不能攻击、移动、释放技能，并每秒受到庞统攻击力300％的法术伤害。漩涡持续7.5秒。\n（施法范围：600）",
	"在目标地点创造一个漩涡，持续将150范围内的敌人吸入漩涡。在此期间目标不能攻击、移动、释放技能，并每秒受到庞统攻击力300％的法术伤害。漩涡持续8秒。\n（施法范围：600）",
	"在目标地点创造一个漩涡，持续将150范围内的敌人吸入漩涡。在此期间目标不能攻击、移动、释放技能，并每秒受到庞统攻击力300％的法术伤害。漩涡持续8.5秒。\n（施法范围：600）",
	"在目标地点创造一个漩涡，持续将150范围内的敌人吸入漩涡。在此期间目标不能攻击、移动、释放技能，并每秒受到庞统攻击力300％的法术伤害。漩涡持续9秒。\n（施法范围：600）",
	"在目标地点创造一个漩涡，持续将150范围内的敌人吸入漩涡。在此期间目标不能攻击、移动、释放技能，并每秒受到庞统攻击力300％的法术伤害。漩涡持续9.5秒。\n（施法范围：600）",
	"在目标地点创造一个漩涡，持续将150范围内的敌人吸入漩涡。在此期间目标不能攻击、移动、释放技能，并每秒受到庞统攻击力300％的法术伤害。漩涡持续10秒。\n（施法范围：600）",
}

_tab_stringT[1124] = {"机关弩炮",
	"放置2台240点生命、15-24点攻击力、20点物理防御、-60点法术防御的机关弩炮为你战斗。机关弩炮存在20秒。\n（施法范围：400）",
	"放置2台360点生命、20-32点攻击力、25点物理防御、-60点法术防御的机关弩炮为你战斗。机关弩炮存在20秒。\n（施法范围：400）",
	"放置2台480点生命、25-40点攻击力、30点物理防御、-60点法术防御的机关弩炮为你战斗。机关弩炮存在20秒。\n（施法范围：400）",
	"放置2台600点生命、30-48点攻击力、35点物理防御、-60点法术防御的机关弩炮为你战斗。机关弩炮存在20秒。\n（施法范围：400）",
	"放置2台720点生命、35-56点攻击力、40点物理防御、-60点法术防御的机关弩炮为你战斗。机关弩炮存在20秒。\n（施法范围：400）",
	"放置2台840点生命、40-64点攻击力、45点物理防御、-60点法术防御的机关弩炮为你战斗。机关弩炮存在20秒。\n（施法范围：400）",
	"放置2台960点生命、45-72点攻击力、50点物理防御、-60点法术防御的机关弩炮为你战斗。机关弩炮存在20秒。\n（施法范围：400）",
	"放置2台1080点生命、50-80点攻击力、55点物理防御、-60点法术防御的机关弩炮为你战斗。机关弩炮存在20秒。\n（施法范围：400）",
	"放置2台1200点生命、55-88点攻击力、60点物理防御、-60点法术防御的机关弩炮为你战斗。机关弩炮存在20秒。\n（施法范围：400）",
	"放置2台1320点生命、60-96点攻击力、65点物理防御、-60点法术防御的机关弩炮为你战斗。机关弩炮存在20秒。\n（施法范围：400）",
	"放置2台1440点生命、65-104点攻击力、70点物理防御、-60点法术防御的机关弩炮为你战斗。机关弩炮存在20秒。\n（施法范围：400）",
	"放置2台1560点生命、70-112点攻击力、75点物理防御、-60点法术防御的机关弩炮为你战斗。机关弩炮存在20秒。\n（施法范围：400）",
	"放置2台1680点生命、75-120点攻击力、80点物理防御、-60点法术防御的机关弩炮为你战斗。机关弩炮存在20秒。\n（施法范围：400）",
	"放置2台1800点生命、80-128点攻击力、85点物理防御、-60点法术防御的机关弩炮为你战斗。机关弩炮存在20秒。\n（施法范围：400）",
	"放置2台1920点生命、85-136点攻击力、90点物理防御、-60点法术防御的机关弩炮为你战斗。机关弩炮存在20秒。\n（施法范围：400）",
}

_tab_stringT[1125] = {"血浴",
	"在身边制造一个血池，对处在血池中的敌人每秒造成董卓最大生命值8％的真实伤害，对处在血池中的自己和友军每秒恢复2.2％生命值。血池持续15秒。",
	"在身边制造一个血池，对处在血池中的敌人每秒造成董卓最大生命值8.5％的真实伤害，对处在血池中的自己和友军每秒恢复2.4％点生命值。血池持续15秒。",
	"在身边制造一个血池，对处在血池中的敌人每秒造成董卓最大生命值9％的真实伤害，对处在血池中的自己和友军每秒恢复2.6％生命值。血池持续15秒。",
	"在身边制造一个血池，对处在血池中的敌人每秒造成董卓最大生命值9.5％的真实伤害，对处在血池中的自己和友军每秒恢复2.8％生命值。血池持续15秒。",
	"在身边制造一个血池，对处在血池中的敌人每秒造成董卓最大生命值10％的真实伤害，对处在血池中的自己和友军每秒恢复3％点生命值。血池持续15秒。",
	"在身边制造一个血池，对处在血池中的敌人每秒造成董卓最大生命值10.5％的真实伤害，对处在血池中的自己和友军每秒恢复3.2％生命值。血池持续15秒。",
	"在身边制造一个血池，对处在血池中的敌人每秒造成董卓最大生命值11％的真实伤害，对处在血池中的自己和友军每秒恢复3.4％生命值。血池持续15秒。",
	"在身边制造一个血池，对处在血池中的敌人每秒造成董卓最大生命值11.5％的真实伤害，对处在血池中的自己和友军每秒恢复3.6％生命值。血池持续15秒。",
	"在身边制造一个血池，对处在血池中的敌人每秒造成董卓最大生命值12％的真实伤害，对处在血池中的自己和友军每秒恢复3.8％生命值。血池持续15秒。",
	"在身边制造一个血池，对处在血池中的敌人每秒造成董卓最大生命值12.5％的真实伤害，对处在血池中的自己和友军每秒恢复4％生命值。血池持续15秒。",
	"在身边制造一个血池，对处在血池中的敌人每秒造成董卓最大生命值13％的真实伤害，对处在血池中的自己和友军每秒恢复4.2％生命值。血池持续15秒。",
	"在身边制造一个血池，对处在血池中的敌人每秒造成董卓最大生命值13.5％的真实伤害，对处在血池中的自己和友军每秒恢复4.4％生命值。血池持续15秒。",
	"在身边制造一个血池，对处在血池中的敌人每秒造成董卓最大生命值14％的真实伤害，对处在血池中的自己和友军每秒恢复4.6％生命值。血池持续15秒。",
	"在身边制造一个血池，对处在血池中的敌人每秒造成董卓最大生命值14.5％的真实伤害，对处在血池中的自己和友军每秒恢复4.8％生命值。血池持续15秒。",
	"在身边制造一个血池，对处在血池中的敌人每秒造成董卓最大生命值15％的真实伤害，对处在血池中的自己和友军每秒恢复5％生命值。血池持续15秒。",
}

_tab_stringT[1126] = {"圣者领域",
	"在目标地点召唤一个领域，持续将110范围内的敌人推出领域，并每秒对敌人造成攻击力200％+100点的法术伤害，持续5.2秒。\n（施法范围：240）",
	"在目标地点召唤一个领域，持续将110范围内的敌人推出领域，并每秒对敌人造成攻击力200％+110点的法术伤害，持续5.4秒。\n（施法范围：240）",
	"在目标地点召唤一个领域，持续将110范围内的敌人推出领域，并每秒对敌人造成攻击力200％+120点的法术伤害，持续5.6秒。\n（施法范围：240）",
	"在目标地点召唤一个领域，持续将110范围内的敌人推出领域，并每秒对敌人造成攻击力200％+130点的法术伤害，持续5.8秒。\n（施法范围：240）",
	"在目标地点召唤一个领域，持续将110范围内的敌人推出领域，并每秒对敌人造成攻击力200％+140点的法术伤害，持续6秒。\n（施法范围：240）",
	"在目标地点召唤一个领域，持续将110范围内的敌人推出领域，并每秒对敌人造成攻击力200％+150点的法术伤害，持续6.2秒。\n（施法范围：240）",
	"在目标地点召唤一个领域，持续将110范围内的敌人推出领域，并每秒对敌人造成攻击力200％+160点的法术伤害，持续6.4秒。\n（施法范围：240）",
	"在目标地点召唤一个领域，持续将110范围内的敌人推出领域，并每秒对敌人造成攻击力200％+170点的法术伤害，持续6.6秒。\n（施法范围：240）",
	"在目标地点召唤一个领域，持续将110范围内的敌人推出领域，并每秒对敌人造成攻击力200％+180点的法术伤害，持续6.8秒。\n（施法范围：240）",
	"在目标地点召唤一个领域，持续将110范围内的敌人推出领域，并每秒对敌人造成攻击力200％+190点的法术伤害，持续7秒。\n（施法范围：240）",
	"在目标地点召唤一个领域，持续将110范围内的敌人推出领域，并每秒对敌人造成攻击力200％+200点的法术伤害，持续7.2秒。\n（施法范围：240）",
	"在目标地点召唤一个领域，持续将110范围内的敌人推出领域，并每秒对敌人造成攻击力200％+210点的法术伤害，持续7.4秒。\n（施法范围：240）",
	"在目标地点召唤一个领域，持续将110范围内的敌人推出领域，并每秒对敌人造成攻击力200％+220点的法术伤害，持续7.6秒。\n（施法范围：240）",
	"在目标地点召唤一个领域，持续将110范围内的敌人推出领域，并每秒对敌人造成攻击力200％+230点的法术伤害，持续7.8秒。\n（施法范围：240）",
	"在目标地点召唤一个领域，持续将110范围内的敌人推出领域，并每秒对敌人造成攻击力200％+240点的法术伤害，持续8秒。\n（施法范围：240）",
}

_tab_stringT[1128] = {"火焰旋风",
	"在目标地点召唤一个火焰旋风，每秒对75范围内的敌人造成攻击力120％点的法术伤害，持续20秒。\n（施法范围：240）",
	"在目标地点召唤一个火焰旋风，每秒对75范围内的敌人造成攻击力140％点的法术伤害，持续20秒。\n（施法范围：240）",
	"在目标地点召唤一个火焰旋风，每秒对75范围内的敌人造成攻击力160％点的法术伤害，持续20秒。\n（施法范围：240）",
	"在目标地点召唤一个火焰旋风，每秒对75范围内的敌人造成攻击力180％点的法术伤害，持续20秒。\n（施法范围：240）",
	"在目标地点召唤一个火焰旋风，每秒对75范围内的敌人造成攻击力200％点的法术伤害，持续20秒。\n（施法范围：240）",
	"在目标地点召唤一个火焰旋风，每秒对75范围内的敌人造成攻击力220％点的法术伤害，持续20秒。\n（施法范围：240）",
	"在目标地点召唤一个火焰旋风，每秒对75范围内的敌人造成攻击力240％点的法术伤害，持续20秒。\n（施法范围：240）",
	"在目标地点召唤一个火焰旋风，每秒对75范围内的敌人造成攻击力260％点的法术伤害，持续20秒。\n（施法范围：240）",
	"在目标地点召唤一个火焰旋风，每秒对75范围内的敌人造成攻击力280％点的法术伤害，持续20秒。\n（施法范围：240）",
	"在目标地点召唤一个火焰旋风，每秒对75范围内的敌人造成攻击力300％点的法术伤害，持续20秒。\n（施法范围：240）",
	"在目标地点召唤一个火焰旋风，每秒对75范围内的敌人造成攻击力320％点的法术伤害，持续20秒。\n（施法范围：240）",
	"在目标地点召唤一个火焰旋风，每秒对75范围内的敌人造成攻击力340％点的法术伤害，持续20秒。\n（施法范围：240）",
	"在目标地点召唤一个火焰旋风，每秒对75范围内的敌人造成攻击力360％点的法术伤害，持续20秒。\n（施法范围：240）",
	"在目标地点召唤一个火焰旋风，每秒对75范围内的敌人造成攻击力380％点的法术伤害，持续20秒。\n（施法范围：240）",
	"在目标地点召唤一个火焰旋风，每秒对75范围内的敌人造成攻击力400％点的法术伤害，持续20秒。\n（施法范围：240）",
}

_tab_stringT[1129] = {"如影随形",
	"施展鬼魅般的身法，提升48％攻击速度、30％移动速度、20％物理和法术闪避，并使普通攻击必定触发闪击，持续12秒。",
	"施展鬼魅般的身法，提升56％攻击速度、33％移动速度、22％物理和法术闪避，并使普通攻击必定触发闪击，持续12秒。",
	"施展鬼魅般的身法，提升64％攻击速度、36％移动速度、24％物理和法术闪避，并使普通攻击必定触发闪击，持续12秒。",
	"施展鬼魅般的身法，提升72％攻击速度、39％移动速度、26％物理和法术闪避，并使普通攻击必定触发闪击，持续12秒。",
	"施展鬼魅般的身法，提升80％攻击速度、42％移动速度、28％物理和法术闪避，并使普通攻击必定触发闪击，持续12秒。",
	"施展鬼魅般的身法，提升88％攻击速度、45％移动速度、30％物理和法术闪避，并使普通攻击必定触发闪击，持续12秒。",
	"施展鬼魅般的身法，提升96％攻击速度、48％移动速度、32％物理和法术闪避，并使普通攻击必定触发闪击，持续12秒。",
	"施展鬼魅般的身法，提升104％攻击速度、51％移动速度、34％物理和法术闪避，并使普通攻击必定触发闪击，持续12秒。",
	"施展鬼魅般的身法，提升112％攻击速度、54％移动速度、36％物理和法术闪避，并使普通攻击必定触发闪击，持续12秒。",
	"施展鬼魅般的身法，提升120％攻击速度、57％移动速度、38％物理和法术闪避，并使普通攻击必定触发闪击，持续12秒。",
	"施展鬼魅般的身法，提升128％攻击速度、60％移动速度、40％物理和法术闪避，并使普通攻击必定触发闪击，持续12秒。",
	"施展鬼魅般的身法，提升136％攻击速度、63％移动速度、42％物理和法术闪避，并使普通攻击必定触发闪击，持续12秒。",
	"施展鬼魅般的身法，提升144％攻击速度、66％移动速度、44％物理和法术闪避，并使普通攻击必定触发闪击，持续12秒。",
	"施展鬼魅般的身法，提升152％攻击速度、69％移动速度、46％物理和法术闪避，并使普通攻击必定触发闪击，持续12秒。",
	"施展鬼魅般的身法，提升160％攻击速度、72％移动速度、48％物理和法术闪避，并使普通攻击必定触发闪击，持续12秒。",
}

_tab_stringT[1130] = {"百步穿杨",
	"蓄力，并射出强力的一箭，对一直线上的敌人造成360％的伤害。",
	"蓄力，并射出强力的一箭，对一直线上的敌人造成420％的伤害。",
	"蓄力，并射出强力的一箭，对一直线上的敌人造成480％的伤害。",
	"蓄力，并射出强力的一箭，对一直线上的敌人造成540％的伤害。",
	"蓄力，并射出强力的一箭，对一直线上的敌人造成600％的伤害。",
	"蓄力，并射出强力的一箭，对一直线上的敌人造成660％的伤害。",
	"蓄力，并射出强力的一箭，对一直线上的敌人造成720％的伤害。",
	"蓄力，并射出强力的一箭，对一直线上的敌人造成780％的伤害。",
	"蓄力，并射出强力的一箭，对一直线上的敌人造成840％的伤害。",
	"蓄力，并射出强力的一箭，对一直线上的敌人造成900％的伤害。",
	"蓄力，并射出强力的一箭，对一直线上的敌人造成960％的伤害。",
	"蓄力，并射出强力的一箭，对一直线上的敌人造成1020％的伤害。",
	"蓄力，并射出强力的一箭，对一直线上的敌人造成1080％的伤害。",
	"蓄力，并射出强力的一箭，对一直线上的敌人造成1140％的伤害。",
	"蓄力，并射出强力的一箭，对一直线上的敌人造成1200％的伤害。",
}

_tab_stringT[1131] = {"闪电奔袭",
	"向目标地点冲刺，对沿途的敌人造成120％伤害，将其击退并击晕0.5秒。每2点移动速度额外增加此技能1％伤害。",
	"向目标地点冲刺，对沿途的敌人造成130％伤害，将其击退并击晕0.5秒。每2点移动速度额外增加此技能1％伤害。",
	"向目标地点冲刺，对沿途的敌人造成140％伤害，将其击退并击晕0.5秒。每2点移动速度额外增加此技能1％伤害。",
	"向目标地点冲刺，对沿途的敌人造成150％伤害，将其击退并击晕0.5秒。每2点移动速度额外增加此技能1％伤害。",
	"向目标地点冲刺，对沿途的敌人造成160％伤害，将其击退并击晕0.5秒。每2点移动速度额外增加此技能1％伤害。",
	"向目标地点冲刺，对沿途的敌人造成170％伤害，将其击退并击晕0.5秒。每2点移动速度额外增加此技能1％伤害。",
	"向目标地点冲刺，对沿途的敌人造成180％伤害，将其击退并击晕0.5秒。每2点移动速度额外增加此技能1％伤害。",
	"向目标地点冲刺，对沿途的敌人造成190％伤害，将其击退并击晕0.5秒。每2点移动速度额外增加此技能1％伤害。",
	"向目标地点冲刺，对沿途的敌人造成200％伤害，将其击退并击晕0.5秒。每2点移动速度额外增加此技能1％伤害。",
	"向目标地点冲刺，对沿途的敌人造成210％伤害，将其击退并击晕0.5秒。每2点移动速度额外增加此技能1％伤害。",
	"向目标地点冲刺，对沿途的敌人造成220％伤害，将其击退并击晕0.5秒。每2点移动速度额外增加此技能1％伤害。",
	"向目标地点冲刺，对沿途的敌人造成230％伤害，将其击退并击晕0.5秒。每2点移动速度额外增加此技能1％伤害。",
	"向目标地点冲刺，对沿途的敌人造成240％伤害，将其击退并击晕0.5秒。每2点移动速度额外增加此技能1％伤害。",
	"向目标地点冲刺，对沿途的敌人造成250％伤害，将其击退并击晕0.5秒。每2点移动速度额外增加此技能1％伤害。",
	"向目标地点冲刺，对沿途的敌人造成260％伤害，将其击退并击晕0.5秒。每2点移动速度额外增加此技能1％伤害。",
}

_tab_stringT[1132] = {"困兽犹斗",
	"提升24点物理防御和法术防御，并获得等同物理防御的攻击力，持续20秒。",
	"提升26点物理防御和法术防御，并获得等同物理防御的攻击力，持续20秒。",
	"提升28点物理防御和法术防御，并获得等同物理防御的攻击力，持续20秒。",
	"提升30点物理防御和法术防御，并获得等同物理防御的攻击力，持续20秒。",
	"提升32点物理防御和法术防御，并获得等同物理防御的攻击力，持续20秒。",
	"提升34点物理防御和法术防御，并获得等同物理防御的攻击力，持续20秒。",
	"提升36点物理防御和法术防御，并获得等同物理防御的攻击力，持续20秒。",
	"提升38点物理防御和法术防御，并获得等同物理防御的攻击力，持续20秒。",
	"提升40点物理防御和法术防御，并获得等同物理防御的攻击力，持续20秒。",
	"提升42点物理防御和法术防御，并获得等同物理防御的攻击力，持续20秒。",
	"提升44点物理防御和法术防御，并获得等同物理防御的攻击力，持续20秒。",
	"提升46点物理防御和法术防御，并获得等同物理防御的攻击力，持续20秒。",
	"提升48点物理防御和法术防御，并获得等同物理防御的攻击力，持续20秒。",
	"提升50点物理防御和法术防御，并获得等同物理防御的攻击力，持续20秒。",
	"提升52点物理防御和法术防御，并获得等同物理防御的攻击力，持续20秒。",
}

_tab_stringT[1133] = {"星罗剑阵",
	"在3秒内召唤大量飞剑，攻击附近的敌人，每把飞剑对一直线上的敌人造成12％物理伤害。",
	"在3秒内召唤大量飞剑，攻击附近的敌人，每把飞剑对一直线上的敌人造成14％物理伤害。",
	"在3秒内召唤大量飞剑，攻击附近的敌人，每把飞剑对一直线上的敌人造成16％物理伤害。",
	"在3秒内召唤大量飞剑，攻击附近的敌人，每把飞剑对一直线上的敌人造成18％物理伤害。",
	"在3秒内召唤大量飞剑，攻击附近的敌人，每把飞剑对一直线上的敌人造成20％物理伤害。",
	"在3秒内召唤大量飞剑，攻击附近的敌人，每把飞剑对一直线上的敌人造成22％物理伤害。",
	"在3秒内召唤大量飞剑，攻击附近的敌人，每把飞剑对一直线上的敌人造成24％物理伤害。",
	"在3秒内召唤大量飞剑，攻击附近的敌人，每把飞剑对一直线上的敌人造成26％物理伤害。",
	"在3秒内召唤大量飞剑，攻击附近的敌人，每把飞剑对一直线上的敌人造成28％物理伤害。",
	"在3秒内召唤大量飞剑，攻击附近的敌人，每把飞剑对一直线上的敌人造成30％物理伤害。",
	"在3秒内召唤大量飞剑，攻击附近的敌人，每把飞剑对一直线上的敌人造成32％物理伤害。",
	"在3秒内召唤大量飞剑，攻击附近的敌人，每把飞剑对一直线上的敌人造成34％物理伤害。",
	"在3秒内召唤大量飞剑，攻击附近的敌人，每把飞剑对一直线上的敌人造成36％物理伤害。",
	"在3秒内召唤大量飞剑，攻击附近的敌人，每把飞剑对一直线上的敌人造成38％物理伤害。",
	"在3秒内召唤大量飞剑，攻击附近的敌人，每把飞剑对一直线上的敌人造成40％物理伤害。",
}

_tab_stringT[1134] = {"召唤鬼将",
	"召唤一个600点生命、30-45点攻击力、9点物理防御和法术防御的鬼将为你战斗，鬼将附加20％司马懿的生命值和攻击力，存在30秒；鬼将会不停召唤鬼卒，鬼卒拥有35％鬼将的能力值，存在15秒。",
	"召唤一个900点生命、50-72点攻击力、12点物理防御和法术防御的鬼将为你战斗，鬼将附加25％司马懿的生命值和攻击力，存在30秒；鬼将会不停召唤鬼卒，鬼卒拥有35％鬼将的能力值，存在15秒。",
	"召唤一个1200点生命、70-99点攻击力、15点物理防御和法术防御的鬼将为你战斗，鬼将附加30％司马懿的生命值和攻击力，存在30秒；鬼将会不停召唤鬼卒，鬼卒拥有35％鬼将的能力值，存在15秒。",
	"召唤一个1500点生命、90-126点攻击力、18点物理防御和法术防御的鬼将为你战斗，鬼将附加35％司马懿的生命值和攻击力，存在30秒；鬼将会不停召唤鬼卒，鬼卒拥有35％鬼将的能力值，存在15秒。",
	"召唤一个1800点生命、110-153点攻击力、21点物理防御和法术防御的鬼将为你战斗，鬼将附加40％司马懿的生命值和攻击力，存在30秒；鬼将会不停召唤鬼卒，鬼卒拥有35％鬼将的能力值，存在15秒。",
	"召唤一个2100点生命、130-180点攻击力、24点物理防御和法术防御的鬼将为你战斗，鬼将附加45％司马懿的生命值和攻击力，存在30秒；鬼将会不停召唤鬼卒，鬼卒拥有35％鬼将的能力值，存在15秒。",
	"召唤一个2400点生命、150-207点攻击力、27点物理防御和法术防御的鬼将为你战斗，鬼将附加50％司马懿的生命值和攻击力，存在30秒；鬼将会不停召唤鬼卒，鬼卒拥有35％鬼将的能力值，存在15秒。",
	"召唤一个2700点生命、170-234点攻击力、30点物理防御和法术防御的鬼将为你战斗，鬼将附加55％司马懿的生命值和攻击力，存在30秒；鬼将会不停召唤鬼卒，鬼卒拥有35％鬼将的能力值，存在15秒。",
	"召唤一个3000点生命、190-261点攻击力、33点物理防御和法术防御的鬼将为你战斗，鬼将附加60％司马懿的生命值和攻击力，存在30秒；鬼将会不停召唤鬼卒，鬼卒拥有35％鬼将的能力值，存在15秒。",
	"召唤一个3300点生命、210-288点攻击力、36点物理防御和法术防御的鬼将为你战斗，鬼将附加65％司马懿的生命值和攻击力，存在30秒；鬼将会不停召唤鬼卒，鬼卒拥有35％鬼将的能力值，存在15秒。",
	"召唤一个3600点生命、230-315点攻击力、39点物理防御和法术防御的鬼将为你战斗，鬼将附加70％司马懿的生命值和攻击力，存在30秒；鬼将会不停召唤鬼卒，鬼卒拥有35％鬼将的能力值，存在15秒。",
	"召唤一个3900点生命、250-342点攻击力、42点物理防御和法术防御的鬼将为你战斗，鬼将附加75％司马懿的生命值和攻击力，存在30秒；鬼将会不停召唤鬼卒，鬼卒拥有35％鬼将的能力值，存在15秒。",
	"召唤一个4200点生命、270-369点攻击力、45点物理防御和法术防御的鬼将为你战斗，鬼将附加80％司马懿的生命值和攻击力，存在30秒；鬼将会不停召唤鬼卒，鬼卒拥有35％鬼将的能力值，存在15秒。",
	"召唤一个4500点生命、290-396点攻击力、48点物理防御和法术防御的鬼将为你战斗，鬼将附加85％司马懿的生命值和攻击力，存在30秒；鬼将会不停召唤鬼卒，鬼卒拥有35％鬼将的能力值，存在15秒。",
	"召唤一个4800点生命、310-423点攻击力、51点物理防御和法术防御的鬼将为你战斗，鬼将附加90％司马懿的生命值和攻击力，存在30秒；鬼将会不停召唤鬼卒，鬼卒拥有35％鬼将的能力值，存在15秒。",
}

_tab_stringT[1135] = {"千影",
	"变身为影子武士，使得攻击方式变为远程，并在攻击时触发相应等级的影杀，持续20秒。",
	"变身为影子武士，使得攻击方式变为远程，并在攻击时触发相应等级的影杀，持续20秒。",
	"变身为影子武士，使得攻击方式变为远程，并在攻击时触发相应等级的影杀，持续20秒。",
	"变身为影子武士，使得攻击方式变为远程，并在攻击时触发相应等级的影杀，持续20秒。",
	"变身为影子武士，使得攻击方式变为远程，并在攻击时触发相应等级的影杀，持续20秒。",
	"变身为影子武士，使得攻击方式变为远程，并在攻击时触发相应等级的影杀，持续20秒。",
	"变身为影子武士，使得攻击方式变为远程，并在攻击时触发相应等级的影杀，持续20秒。",
	"变身为影子武士，使得攻击方式变为远程，并在攻击时触发相应等级的影杀，持续20秒。",
	"变身为影子武士，使得攻击方式变为远程，并在攻击时触发相应等级的影杀，持续20秒。",
	"变身为影子武士，使得攻击方式变为远程，并在攻击时触发相应等级的影杀，持续20秒。",
	"变身为影子武士，使得攻击方式变为远程，并在攻击时触发相应等级的影杀，持续20秒。",
	"变身为影子武士，使得攻击方式变为远程，并在攻击时触发相应等级的影杀，持续20秒。",
	"变身为影子武士，使得攻击方式变为远程，并在攻击时触发相应等级的影杀，持续20秒。",
	"变身为影子武士，使得攻击方式变为远程，并在攻击时触发相应等级的影杀，持续20秒。",
	"变身为影子武士，使得攻击方式变为远程，并在攻击时触发相应等级的影杀，持续20秒。",
}

_tab_stringT[1136] = {"驱兽",
	"召唤一队动物为你战斗。动物附加孟获16％的生命值和攻击力。动物存在30秒。\n（施法范围：240）",
	"召唤一队动物为你战斗。动物附加孟获20％的生命值和攻击力。动物存在30秒。\n（施法范围：240）",
	"召唤一队动物为你战斗。动物附加孟获24％的生命值和攻击力。动物存在30秒。\n（施法范围：240）",
	"召唤一队动物为你战斗。动物附加孟获28％的生命值和攻击力。动物存在30秒。\n（施法范围：240）",
	"召唤一队动物为你战斗。动物附加孟获32％的生命值和攻击力。动物存在30秒。\n（施法范围：240）",
	"召唤一队动物为你战斗。动物附加孟获36％的生命值和攻击力。动物存在30秒。\n（施法范围：240）",
	"召唤一队动物为你战斗。动物附加孟获40％的生命值和攻击力。动物存在30秒。\n（施法范围：240）",
	"召唤一队动物为你战斗。动物附加孟获44％的生命值和攻击力。动物存在30秒。\n（施法范围：240）",
	"召唤一队动物为你战斗。动物附加孟获48％的生命值和攻击力。动物存在30秒。\n（施法范围：240）",
	"召唤一队动物为你战斗。动物附加孟获52％的生命值和攻击力。动物存在30秒。\n（施法范围：240）",
	"召唤一队动物为你战斗。动物附加孟获56％的生命值和攻击力。动物存在30秒。\n（施法范围：240）",
	"召唤一队动物为你战斗。动物附加孟获60％的生命值和攻击力。动物存在30秒。\n（施法范围：240）",
	"召唤一队动物为你战斗。动物附加孟获64％的生命值和攻击力。动物存在30秒。\n（施法范围：240）",
	"召唤一队动物为你战斗。动物附加孟获68％的生命值和攻击力。动物存在30秒。\n（施法范围：240）",
	"召唤一队动物为你战斗。动物附加孟获72％的生命值和攻击力。动物存在30秒。\n（施法范围：240）",
}

_tab_stringT[1137] = {"神火飞刃",
	"祝融夫人为飞刃注入火神之力，提升30％的攻击速度和10％的移动速度，持续15秒。在此期间，祝融夫人攻击的目标、回旋飞刃碰到的敌人，以及飞刃弹射到的敌人，都将额外受到攻击力100％的法术伤害。",
	"祝融夫人为飞刃注入火神之力，提升33％的攻击速度和11％的移动速度，持续15秒。在此期间，祝融夫人攻击的目标、回旋飞刃碰到的敌人，以及飞刃弹射到的敌人，都将额外受到攻击力100％的法术伤害。",
	"祝融夫人为飞刃注入火神之力，提升36％的攻击速度和12％的移动速度，持续15秒。在此期间，祝融夫人攻击的目标、回旋飞刃碰到的敌人，以及飞刃弹射到的敌人，都将额外受到攻击力100％的法术伤害。",
	"祝融夫人为飞刃注入火神之力，提升30％的攻击速度和13％的移动速度，持续15秒。在此期间，祝融夫人攻击的目标、回旋飞刃碰到的敌人，以及飞刃弹射到的敌人，都将额外受到攻击力100％的法术伤害。",
	"祝融夫人为飞刃注入火神之力，提升39％的攻击速度和14％的移动速度，持续15秒。在此期间，祝融夫人攻击的目标、回旋飞刃碰到的敌人，以及飞刃弹射到的敌人，都将额外受到攻击力100％的法术伤害。",
	"祝融夫人为飞刃注入火神之力，提升42％的攻击速度和15％的移动速度，持续15秒。在此期间，祝融夫人攻击的目标、回旋飞刃碰到的敌人，以及飞刃弹射到的敌人，都将额外受到攻击力100％的法术伤害。",
	"祝融夫人为飞刃注入火神之力，提升45％的攻击速度和16％的移动速度，持续15秒。在此期间，祝融夫人攻击的目标、回旋飞刃碰到的敌人，以及飞刃弹射到的敌人，都将额外受到攻击力100％的法术伤害。",
	"祝融夫人为飞刃注入火神之力，提升48％的攻击速度和17％的移动速度，持续15秒。在此期间，祝融夫人攻击的目标、回旋飞刃碰到的敌人，以及飞刃弹射到的敌人，都将额外受到攻击力100％的法术伤害。",
	"祝融夫人为飞刃注入火神之力，提升51％的攻击速度和18％的移动速度，持续15秒。在此期间，祝融夫人攻击的目标、回旋飞刃碰到的敌人，以及飞刃弹射到的敌人，都将额外受到攻击力100％的法术伤害。",
	"祝融夫人为飞刃注入火神之力，提升54％的攻击速度和19％的移动速度，持续15秒。在此期间，祝融夫人攻击的目标、回旋飞刃碰到的敌人，以及飞刃弹射到的敌人，都将额外受到攻击力100％的法术伤害。",
	"祝融夫人为飞刃注入火神之力，提升57％的攻击速度和20％的移动速度，持续15秒。在此期间，祝融夫人攻击的目标、回旋飞刃碰到的敌人，以及飞刃弹射到的敌人，都将额外受到攻击力100％的法术伤害。",
	"祝融夫人为飞刃注入火神之力，提升60％的攻击速度和21％的移动速度，持续15秒。在此期间，祝融夫人攻击的目标、回旋飞刃碰到的敌人，以及飞刃弹射到的敌人，都将额外受到攻击力100％的法术伤害。",
	"祝融夫人为飞刃注入火神之力，提升66％的攻击速度和22％的移动速度，持续15秒。在此期间，祝融夫人攻击的目标、回旋飞刃碰到的敌人，以及飞刃弹射到的敌人，都将额外受到攻击力100％的法术伤害。",
	"祝融夫人为飞刃注入火神之力，提升69％的攻击速度和23％的移动速度，持续15秒。在此期间，祝融夫人攻击的目标、回旋飞刃碰到的敌人，以及飞刃弹射到的敌人，都将额外受到攻击力100％的法术伤害。",
	"祝融夫人为飞刃注入火神之力，提升72％的攻击速度和24％的移动速度，持续15秒。在此期间，祝融夫人攻击的目标、回旋飞刃碰到的敌人，以及飞刃弹射到的敌人，都将额外受到攻击力100％的法术伤害。",
}

_tab_stringT[1139] = {"暗流涌动",
	"激发暗流，对甄姬周围180范围内的敌人造成攻击力180％的法术伤害，并降低50％的移动速度，持续6秒。同时引爆全部的水之涡流，每个水之涡流都对周围180范围内的敌人造成攻击力180％的法术伤害，并降低50％的移动速度，持续3秒。",
	"激发暗流，对甄姬周围180范围内的敌人造成攻击力210％的法术伤害，并降低50％的移动速度，持续6秒。同时引爆全部的水之涡流，每个水之涡流都对周围180范围内的敌人造成攻击力210％的法术伤害，并降低50％的移动速度，持续3秒。",
	"激发暗流，对甄姬周围180范围内的敌人造成攻击力240％的法术伤害，并降低50％的移动速度，持续6秒。同时引爆全部的水之涡流，每个水之涡流都对周围180范围内的敌人造成攻击力240％的法术伤害，并降低50％的移动速度，持续3秒。",
	"激发暗流，对甄姬周围180范围内的敌人造成攻击力270％的法术伤害，并降低50％的移动速度，持续6秒。同时引爆全部的水之涡流，每个水之涡流都对周围180范围内的敌人造成攻击力270％的法术伤害，并降低50％的移动速度，持续3秒。",
	"激发暗流，对甄姬周围180范围内的敌人造成攻击力300％的法术伤害，并降低50％的移动速度，持续6秒。同时引爆全部的水之涡流，每个水之涡流都对周围180范围内的敌人造成攻击力300％的法术伤害，并降低50％的移动速度，持续3秒。",
	"激发暗流，对甄姬周围180范围内的敌人造成攻击力330％的法术伤害，并降低50％的移动速度，持续6秒。同时引爆全部的水之涡流，每个水之涡流都对周围180范围内的敌人造成攻击力330％的法术伤害，并降低50％的移动速度，持续3秒。",
	"激发暗流，对甄姬周围180范围内的敌人造成攻击力360％的法术伤害，并降低50％的移动速度，持续6秒。同时引爆全部的水之涡流，每个水之涡流都对周围180范围内的敌人造成攻击力360％的法术伤害，并降低50％的移动速度，持续3秒。",
	"激发暗流，对甄姬周围180范围内的敌人造成攻击力390％的法术伤害，并降低50％的移动速度，持续6秒。同时引爆全部的水之涡流，每个水之涡流都对周围180范围内的敌人造成攻击力390％的法术伤害，并降低50％的移动速度，持续3秒。",
	"激发暗流，对甄姬周围180范围内的敌人造成攻击力420％的法术伤害，并降低50％的移动速度，持续6秒。同时引爆全部的水之涡流，每个水之涡流都对周围180范围内的敌人造成攻击力420％的法术伤害，并降低50％的移动速度，持续3秒。",
	"激发暗流，对甄姬周围180范围内的敌人造成攻击力450％的法术伤害，并降低50％的移动速度，持续6秒。同时引爆全部的水之涡流，每个水之涡流都对周围180范围内的敌人造成攻击力450％的法术伤害，并降低50％的移动速度，持续3秒。",
	"激发暗流，对甄姬周围180范围内的敌人造成攻击力480％的法术伤害，并降低50％的移动速度，持续6秒。同时引爆全部的水之涡流，每个水之涡流都对周围180范围内的敌人造成攻击力480％的法术伤害，并降低50％的移动速度，持续3秒。",
	"激发暗流，对甄姬周围180范围内的敌人造成攻击力510％的法术伤害，并降低50％的移动速度，持续6秒。同时引爆全部的水之涡流，每个水之涡流都对周围180范围内的敌人造成攻击力510％的法术伤害，并降低50％的移动速度，持续3秒。",
	"激发暗流，对甄姬周围180范围内的敌人造成攻击力540％的法术伤害，并降低50％的移动速度，持续6秒。同时引爆全部的水之涡流，每个水之涡流都对周围180范围内的敌人造成攻击力540％的法术伤害，并降低50％的移动速度，持续3秒。",
	"激发暗流，对甄姬周围180范围内的敌人造成攻击力570％的法术伤害，并降低50％的移动速度，持续6秒。同时引爆全部的水之涡流，每个水之涡流都对周围180范围内的敌人造成攻击力570％的法术伤害，并降低50％的移动速度，持续3秒。",
	"激发暗流，对甄姬周围180范围内的敌人造成攻击力600％的法术伤害，并降低50％的移动速度，持续6秒。同时引爆全部的水之涡流，每个水之涡流都对周围180范围内的敌人造成攻击力600％的法术伤害，并降低50％的移动速度，持续3秒。",
}


_tab_stringT[1201] = {"敌人生命加强",
	"敌人生命值+25％。",
	"敌人生命值+50％。",
	"敌人生命值+75％。",
	"敌人生命值+100％。",
	"敌人生命值+125％。",
	"敌人生命值+150％。",
	"敌人生命值+175％。",
	"敌人生命值+200％。",
	"敌人生命值+225％。",
	"敌人生命值+250％。",
}

_tab_stringT[1202] = {"敌人攻击加强",
	"敌人攻击力+25％。",
	"敌人攻击力+50％。",
	"敌人攻击力+75％。",
	"敌人攻击力+100％。",
	"敌人攻击力+125％。",
	"敌人攻击力+150％。",
	"敌人攻击力+175％。",
	"敌人攻击力+200％。",
	"敌人攻击力+225％。",
	"敌人攻击力+250％。",
}

_tab_stringT[1203] = {"敌人速度加强",
	"敌人移动速度+10％。",
	"敌人移动速度+20％。",
	"敌人移动速度+30％。",
	"敌人移动速度+40％。",
	"敌人移动速度+50％。",
	"敌人移动速度+60％。",
	"敌人移动速度+70％。",
	"敌人移动速度+80％。",
	"敌人移动速度+90％。",
	"敌人移动速度+100％。",
}

_tab_stringT[1204] = {"敌人回复加强",
	"敌人回复速度+1点/秒。",
	"敌人回复速度+2点/秒。",
	"敌人回复速度+3点/秒。",
	"敌人回复速度+4点/秒。",
	"敌人回复速度+5点/秒。",
	"敌人回复速度+6点/秒。",
	"敌人回复速度+7点/秒。",
	"敌人回复速度+8点/秒。",
	"敌人回复速度+9点/秒。",
	"敌人回复速度+10点/秒。",
}

_tab_stringT[1205] = {"敌人物防加强",
	"敌人物理防御+10点。",
	"敌人物理防御+20点。",
	"敌人物理防御+30点。",
	"敌人物理防御+40点。",
	"敌人物理防御+50点。",
	"敌人物理防御+60点。",
	"敌人物理防御+70点。",
	"敌人物理防御+80点。",
	"敌人物理防御+90点。",
	"敌人物理防御+100点。",
}

_tab_stringT[1206] = {"敌人法防加强",
	"敌人法术防御+10点。",
	"敌人法术防御+20点。",
	"敌人法术防御+30点。",
	"敌人法术防御+40点。",
	"敌人法术防御+50点。",
	"敌人法术防御+60点。",
	"敌人法术防御+70点。",
	"敌人法术防御+80点。",
	"敌人法术防御+90点。",
	"敌人法术防御+100点。",
}

_tab_stringT[1207] = {"敌人吸血加强",
	"敌人攻击吸血+5％。",
	"敌人攻击吸血+10％。",
	"敌人攻击吸血+15％。",
	"敌人攻击吸血+20％。",
	"敌人攻击吸血+25％。",
	"敌人攻击吸血+30％。",
	"敌人攻击吸血+35％。",
	"敌人攻击吸血+40％。",
	"敌人攻击吸血+45％。",
	"敌人攻击吸血+50％。",
}

_tab_stringT[1208] = {"我方复活延长",
	"我方英雄复活时间+5秒。",
	"我方英雄复活时间+10秒。",
	"我方英雄复活时间+15秒。",
	"我方英雄复活时间+20秒。",
	"我方英雄复活时间+25秒。",
	"我方英雄复活时间+30秒。",
	"我方英雄复活时间+35秒。",
	"我方英雄复活时间+40秒。",
	"我方英雄复活时间+45秒。",
	"我方英雄复活时间+50秒。",
}


_tab_stringT[1209] = {"我方速度减缓",
	"我方英雄和部队移动速度-10％。",
	"我方英雄和部队移动速度-20％。",
	"我方英雄和部队移动速度-30％。",
	"我方英雄和部队移动速度-40％。",
	"我方英雄和部队移动速度-50％。",
	"我方英雄和部队移动速度-60％。",
	"我方英雄和部队移动速度-70％。",
	"我方英雄和部队移动速度-80％。",
	"我方英雄和部队移动速度-90％。",
	"我方英雄和部队移动速度-100％。",
}

_tab_stringT[1210] = {"敌塔射程加强",
	"敌方防御塔射程+10码。",
	"敌方防御塔射程+20码。",
	"敌方防御塔射程+30码。",
	"敌方防御塔射程+40码。",
	"敌方防御塔射程+50码。",
	"敌方防御塔射程+60码。",
	"敌方防御塔射程+70码。",
	"敌方防御塔射程+80码。",
	"敌方防御塔射程+90码。",
	"敌方防御塔射程+100码。",
}

_tab_stringT[1211] = {"敌塔生命加强",
	"敌方防御塔生命值+25％。",
	"敌方防御塔生命值+50％。",
	"敌方防御塔生命值+75％。",
	"敌方防御塔生命值+100％。",
	"敌方防御塔生命值+125％。",
	"敌方防御塔生命值+150％。",
	"敌方防御塔生命值+175％。",
	"敌方防御塔生命值+200％。",
	"敌方防御塔生命值+225％。",
	"敌方防御塔生命值+250％。",
}

_tab_stringT[1212] = {"敌塔攻击加强",
	"敌方防御塔攻击力+25％。",
	"敌方防御塔攻击力+50％。",
	"敌方防御塔攻击力+75％。",
	"敌方防御塔攻击力+100％。",
	"敌方防御塔攻击力+125％。",
	"敌方防御塔攻击力+150％。",
	"敌方防御塔攻击力+175％。",
	"敌方防御塔攻击力+200％。",
	"敌方防御塔攻击力+225％。",
	"敌方防御塔攻击力+250％。",
}

_tab_stringT[1213] = {"我方攻击降低",
	"我方英雄和部队攻击力-10％。",
	"我方英雄和部队攻击力-20％。",
	"我方英雄和部队攻击力-30％。",
	"我方英雄和部队攻击力-40％。",
	"我方英雄和部队攻击力-50％。",
	"我方英雄和部队攻击力-60％。",
	"我方英雄和部队攻击力-70％。",
	"我方英雄和部队攻击力-80％。",
	"我方英雄和部队攻击力-90％。",
	"我方英雄和部队攻击力-100％。",
}

_tab_stringT[1214] = {"敌人射程加强",
	"敌人射程+10码。",
	"敌人射程+20码。",
	"敌人射程+30码。",
	"敌人射程+40码。",
	"敌人射程+50码。",
	"敌人射程+60码。",
	"敌人射程+70码。",
	"敌人射程+80码。",
	"敌人射程+90码。",
	"敌人射程+100码。",
}

_tab_stringT[1215] = {"敌水兵生命加强",
	"从水上登陆的敌人生命值+25％。",
	"从水上登陆的敌人生命值+50％。",
	"从水上登陆的敌人生命值+75％。",
	"从水上登陆的敌人生命值+100％。",
	"从水上登陆的敌人生命值+125％。",
	"从水上登陆的敌人生命值+150％。",
	"从水上登陆的敌人生命值+175％。",
	"从水上登陆的敌人生命值+200％。",
	"从水上登陆的敌人生命值+225％。",
	"从水上登陆的敌人生命值+250％。",
	"从水上登陆的敌人生命值+275％。",
	"从水上登陆的敌人生命值+300％。",
	"从水上登陆的敌人生命值+325％。",
	"从水上登陆的敌人生命值+350％。",
	"从水上登陆的敌人生命值+375％。",
	"从水上登陆的敌人生命值+400％。",
	"从水上登陆的敌人生命值+425％。",
	"从水上登陆的敌人生命值+450％。",
	"从水上登陆的敌人生命值+475％。",
	"从水上登陆的敌人生命值+500％。",
}

_tab_stringT[1216] = {"敌水兵攻击加强",
	"从水上登陆的敌人攻击力+25％。",
	"从水上登陆的敌人攻击力+50％。",
	"从水上登陆的敌人攻击力+75％。",
	"从水上登陆的敌人攻击力+100％。",
	"从水上登陆的敌人攻击力+125％。",
	"从水上登陆的敌人攻击力+150％。",
	"从水上登陆的敌人攻击力+175％。",
	"从水上登陆的敌人攻击力+200％。",
	"从水上登陆的敌人攻击力+225％。",
	"从水上登陆的敌人攻击力+250％。",
}

_tab_stringT[1217] = {"驻守攻击降低",
	"我方驻守英雄攻击力-10％。",
	"我方驻守英雄攻击力-20％。",
	"我方驻守英雄攻击力-30％。",
	"我方驻守英雄攻击力-40％。",
	"我方驻守英雄攻击力-50％。",
	"我方驻守英雄攻击力-60％。",
	"我方驻守英雄攻击力-70％。",
	"我方驻守英雄攻击力-80％。",
	"我方驻守英雄攻击力-90％。",
	"我方驻守英雄攻击力-100％。",
}

_tab_stringT[1218] = {"远程驻守射程降低",
	"我方远程驻守英雄射程-30码。",
	"我方远程驻守英雄射程-50码。",
	"我方远程驻守英雄射程-70码。",
	"我方远程驻守英雄射程-90码。",
	"我方远程驻守英雄射程-110码。",
	"我方远程驻守英雄射程-130码。",
	"我方远程驻守英雄射程-150码。",
	"我方远程驻守英雄射程-170码。",
	"我方远程驻守英雄射程-190码。",
	"我方远程驻守英雄射程-210码。",
}

_tab_stringT[1219] = {"远程驻守暴率降低",
	"我方远程驻守英雄的暴击几率-10％。",
	"我方远程驻守英雄的暴击几率-15％。",
	"我方远程驻守英雄的暴击几率-20％。",
	"我方远程驻守英雄的暴击几率-25％。",
	"我方远程驻守英雄的暴击几率-30％。",
	"我方远程驻守英雄的暴击几率-35％。",
	"我方远程驻守英雄的暴击几率-40％。",
	"我方远程驻守英雄的暴击几率-45％。",
	"我方远程驻守英雄的暴击几率-50％。",
	"我方远程驻守英雄的暴击几率-55％。",
}


_tab_stringT[1220] = {"远程驻守暴伤降低",
	"我方远程驻守英雄暴击伤害-40％。",
	"我方远程驻守英雄暴击伤害-50％。",
	"我方远程驻守英雄暴击伤害-60％。",
	"我方远程驻守英雄暴击伤害-70％。",
	"我方远程驻守英雄暴击伤害-80％。",
	"我方远程驻守英雄暴击伤害-90％。",
	"我方远程驻守英雄暴击伤害-100％。",
	"我方远程驻守英雄暴击伤害-110％。",
	"我方远程驻守英雄暴击伤害-120％。",
	"我方远程驻守英雄暴击伤害-130％。",
}

_tab_stringT[1221] = {"远程驻守攻速降低",
	"我方远程驻守英雄攻速-30％。",
	"我方远程驻守英雄攻速-40％。",
	"我方远程驻守英雄攻速-50％。",
	"我方远程驻守英雄攻速-60％。",
	"我方远程驻守英雄攻速-70％。",
	"我方远程驻守英雄攻速-80％。",
	"我方远程驻守英雄攻速-90％。",
	"我方远程驻守英雄攻速-100％。",
	"我方远程驻守英雄攻速-110％。",
	"我方远程驻守英雄攻速-120％。",
}

_tab_stringT[1222] = {"近战驻守复活增加",
	"我方近战驻守英雄复活+8秒。",
	"我方近战驻守英雄复活+10秒。",
	"我方近战驻守英雄复活+12秒。",
	"我方近战驻守英雄复活+14秒。",
	"我方近战驻守英雄复活+16秒。",
	"我方近战驻守英雄复活+18秒。",
	"我方近战驻守英雄复活+20秒。",
	"我方近战驻守英雄复活+22秒。",
	"我方近战驻守英雄复活+24秒。",
	"我方近战驻守英雄复活+26秒。",
}

_tab_stringT[1223] = {"近战驻守治疗降低",
	"我方近战驻守英雄治疗-10％。",
	"我方近战驻守英雄治疗-20％。",
	"我方近战驻守英雄治疗-30％。",
	"我方近战驻守英雄治疗-40％。",
	"我方近战驻守英雄治疗-50％。",
	"我方近战驻守英雄治疗-60％。",
	"我方近战驻守英雄治疗-70％。",
	"我方近战驻守英雄治疗-80％。",
	"我方近战驻守英雄治疗-90％。",
	"我方近战驻守英雄治疗-100％。",
}

_tab_stringT[1224] = {"近战驻守吸血降低",
	"我方近战驻守英雄攻击吸血-15％。",
	"我方近战驻守英雄攻击吸血-20％。",
	"我方近战驻守英雄攻击吸血-25％。",
	"我方近战驻守英雄攻击吸血-30％。",
	"我方近战驻守英雄攻击吸血-35％。",
	"我方近战驻守英雄攻击吸血-40％。",
	"我方近战驻守英雄攻击吸血-45％。",
	"我方近战驻守英雄攻击吸血-50％。",
	"我方近战驻守英雄攻击吸血-55％。",
	"我方近战驻守英雄攻击吸血-60％。",
}

--[[
_tab_stringT[1225] = {"敌人防御增强",
	"敌人物防与法防+30点。",
	"敌人物防与法防+50点。",
	"敌人物防与法防+70点。",
	"敌人物防与法防+90点。",
	"敌人物防与法防+110点。",
	"敌人物防与法防+130点。",
	"敌人物防与法防+150点。",
	"敌人物防与法防+170点。",
	"敌人物防与法防+190点。",
	"敌人物防与法防+210点。",
}
]]

--[[
_tab_stringT[1226] = {"敌人生命偷取",
	"敌人攻击吸血+15％。",
	"敌人攻击吸血+20％。",
	"敌人攻击吸血+25％。",
	"敌人攻击吸血+25％。",
	"敌人攻击吸血+25％。",
	"敌人攻击吸血+25％。",
	"敌人攻击吸血+25％。",
	"敌人攻击吸血+25％。",
	"敌人攻击吸血+25％。",
	"敌人攻击吸血+25％。",
}
]]

--[[
_tab_stringT[1227] = {"敌人生命增加",
	"敌人物生命值+50％。",
	"敌人物生命值+70％。",
	"敌人物生命值+100％。",
	"敌人物生命值+100％。",
	"敌人物生命值+100％。",
	"敌人物生命值+100％。",
	"敌人物生命值+100％。",
	"敌人物生命值+100％。",
	"敌人物生命值+100％。",
	"敌人物生命值+100％。",
}
]]

_tab_stringT[1228] = {"箭塔迷惑",
	"箭塔系每次攻击有10％的几率无法命中目标。",
	"箭塔系每次攻击有20％的几率无法命中目标。",
	"箭塔系每次攻击有30％的几率无法命中目标。",
	"箭塔系每次攻击有40％的几率无法命中目标。",
	"箭塔系每次攻击有50％的几率无法命中目标。",
	"箭塔系每次攻击有60％的几率无法命中目标。",
	"箭塔系每次攻击有70％的几率无法命中目标。",
	"箭塔系每次攻击有80％的几率无法命中目标。",
	"箭塔系每次攻击有90％的几率无法命中目标。",
	"箭塔系每次攻击有100％的几率无法命中目标。",
}

_tab_stringT[1229] = {"法术塔迷惑",
	"法术塔系每次攻击有10％的几率无法命中目标。",
	"法术塔系每次攻击有20％的几率无法命中目标。",
	"法术塔系每次攻击有30％的几率无法命中目标。",
	"法术塔系每次攻击有40％的几率无法命中目标。",
	"法术塔系每次攻击有50％的几率无法命中目标。",
	"法术塔系每次攻击有60％的几率无法命中目标。",
	"法术塔系每次攻击有70％的几率无法命中目标。",
	"法术塔系每次攻击有80％的几率无法命中目标。",
	"法术塔系每次攻击有90％的几率无法命中目标。",
	"法术塔系每次攻击有100％的几率无法命中目标。",
}

_tab_stringT[1230] = {"炮塔迷惑",
	"炮塔系每次攻击有10％的几率无法命中目标。",
	"炮塔系每次攻击有20％的几率无法命中目标。",
	"炮塔系每次攻击有30％的几率无法命中目标。",
	"炮塔系每次攻击有40％的几率无法命中目标。",
	"炮塔系每次攻击有50％的几率无法命中目标。",
	"炮塔系每次攻击有60％的几率无法命中目标。",
	"炮塔系每次攻击有70％的几率无法命中目标。",
	"炮塔系每次攻击有80％的几率无法命中目标。",
	"炮塔系每次攻击有90％的几率无法命中目标。",
	"炮塔系每次攻击有100％的几率无法命中目标。",
}

_tab_stringT[1231] = {"我方物防降低",
	"我方英雄和部队物理防御-10点。",
	"我方英雄和部队物理防御-20点。",
	"我方英雄和部队物理防御-30点。",
	"我方英雄和部队物理防御-40点。",
	"我方英雄和部队物理防御-50点。",
	"我方英雄和部队物理防御-60点。",
	"我方英雄和部队物理防御-70点。",
	"我方英雄和部队物理防御-80点。",
	"我方英雄和部队物理防御-90点。",
	"我方英雄和部队物理防御-100点。",
}

_tab_stringT[1232] = {"敌方妖壳",
	"敌人受到的负面属性削减效果减半。",
}

_tab_stringT[1233] = {"敌人生命加强",
	"无",
	"敌人生命值+50％。",
	"敌人生命值+75％。",
	"敌人生命值+100％。",
	"敌人生命值+125％。",
	"敌人生命值+150％。",
	"敌人生命值+175％。",
	"敌人生命值+200％。",
	"敌人生命值+225％。",
	"敌人生命值+250％。",
	"敌人生命值+275％。",
	"敌人生命值+300％。",
	"敌人生命值+325％。",
	"敌人生命值+350％。",
	"敌人生命值+375％。",
	"敌人生命值+400％。",
	"敌人生命值+425％。",
	"敌人生命值+450％。",
	"敌人生命值+475％。",
	"敌人生命值+500％。",
}

_tab_stringT[1234] = {"敌人攻击加强",
	"无",
	"无",
	"无",
	"无",
	"敌人攻击力+50％。",
	"敌人攻击力+60％。",
	"敌人攻击力+70％。",
	"敌人攻击力+80％。",
	"敌人攻击力+90％。",
	"敌人攻击力+100％。",
	"敌人攻击力+110％。",
	"敌人攻击力+120％。",
	"敌人攻击力+130％。",
	"敌人攻击力+140％。",
	"敌人攻击力+150％。",
	"敌人攻击力+160％。",
	"敌人攻击力+170％。",
	"敌人攻击力+180％。",
	"敌人攻击力+190％。",
	"敌人攻击力+200％。",
}

_tab_stringT[1235] = {"敌人速度加强",
	"无",
	"无",
	"无",
	"无",
	"无",
	"无",
	"无",
	"无",
	"无",
	"敌人移动速度+20％。",
	"敌人移动速度+25％。",
	"敌人移动速度+30％。",
	"敌人移动速度+35％。",
	"敌人移动速度+40％。",
	"敌人移动速度+45％。",
	"敌人移动速度+50％。",
	"敌人移动速度+55％。",
	"敌人移动速度+60％。",
	"敌人移动速度+65％。",
	"敌人移动速度+70％。",
}

_tab_stringT[1236] = {"敌人奇兵",
	"无",
	"无",
	"无",
	"无",
	"无",
	"无",
	"无",
	"无",
	"无",
	"无",
	"无",
	"无",
	"无",
	"无",
	"敌人奇兵指数+1。",
	"敌人奇兵指数+2。",
	"敌人奇兵指数+3。",
	"敌人奇兵指数+4。",
	"敌人奇兵指数+5。",
	"敌人奇兵指数+6。",
}

_tab_stringT[1237] = {"敌人生命加强",
	"敌人生命值+200％。",
}

_tab_stringT[1238] = {"敌人生命加强",
	"敌人攻击力+100％。",
}

_tab_stringT[1239] = {"敌人速度加强",
	"敌人移动速度+20％。",
}

_tab_stringT[1245] = {"敌人生命浮动",
	"敌人生命值-50％。",
}


_tab_stringT[1301] = {"孔明灯",
	"威力强大的空中单位，对法术攻击、毒塔的毒伤和地面单位免疫，但被箭塔克制。",
}

_tab_stringT[1302] = {"死士",
	"行动迅速的地面突袭单位，对物理攻击免疫，但被法术塔和英雄技能克制。",
}

_tab_stringT[1303] = {"投石车",
	"行动缓慢超远程攻城单位，威力强大，但只攻击建筑。",
}

_tab_stringT[1304] = {"力士",
	"行动缓慢的近战攻城单位，擅长吸收伤害，只攻击建筑，被毒塔克制。",
}

_tab_stringT[1305] = {"自爆兵",
	"行动迅速的地面单位，数量众多，对建筑造成一次性伤害。",
}

_tab_stringT[1306] = {"箭雨",
	"对敌方粮仓或基地发射一阵大范围的箭雨，对单位和建筑造成伤害。可强化出造成敌人中毒的属性。",
}

_tab_stringT[1307] = {"象兵",
	"行动缓慢的远程单位，擅长吸收伤害，能震晕附近敌人，但被毒塔克制。",
}

_tab_stringT[1308] = {"护城弩手",
	"守卫本方粮仓的护城弩手，在主城和粮仓之间来回巡逻。",
}

_tab_stringT[1309] = {"虎豹骑",
	"行动迅速的地面突袭部队，攻击力强大，但被滚石塔克制。",
}

_tab_stringT[1310] = {"刀兵",
	"初级近战兵种，擅长吸收伤害。",
}

_tab_stringT[1311] = {"弓手",
	"初级远程兵种，有较强攻击力，但比较脆弱。",
}

_tab_stringT[1312] = {"爆炎",
	"对敌方粮仓或基地发射威力强大的爆炎，对单位和建筑造成巨大伤害，并持续燃烧地面，持续14秒。（每使用一次价格增加150金，上限600金）",
}

_tab_stringT[1313] = {"护城卫士",
	"守卫本方粮仓的护城卫士，在主城和粮仓之间来回巡逻。",
}

_tab_stringT[1314] = {"狗雨",
	"对敌方粮仓或基地发射一波大范围的群狗，对单位和建筑造成伤害。可强化出造成敌人混乱的属性。",
}

_tab_stringT[1315] = {"微笑力士",
	"行动缓慢的近战攻城单位，只攻击建筑，擅长吸收伤害，每8秒向四周抛出小狗，命中敌人造成混乱。",
}

_tab_stringT[1316] = {"爆裂力士",
	"行动缓慢的近战单位，每8秒会自身引爆一次造成范围伤害，战败时还会引发威力更大的自爆。",
}

_tab_stringT[1317] = {"天网",
	"部署一张天网，存在90秒或捕获空中单位后消失。被捕获的空中单位无法行动并中毒，持续15秒。",
}

_tab_stringT[1318] = {"捕兽夹",
	"部署一片捕兽夹，存在90秒或捕获骑兵、象兵后消失。被捕获的单位无法行动并中毒，持续15秒。",
}



_tab_stringT[2103] = {"援军（竞技场）",
	"召唤4个240生命、12-16点攻击力、10点物理防御、3点法术防御的民兵为你战斗。民兵存在55秒。\n（施法范围：150）",
	"召唤4个420生命、28-40点攻击力、16点物理防御、7点法术防御的民兵为你战斗。民兵存在55秒。\n（施法范围：150）",
	"召唤4个600生命、44-64点攻击力、22点物理防御、11点法术防御的民兵为你战斗。民兵存在55秒。\n（施法范围：150）",
	"召唤4个780生命、60-88点攻击力、28点物理防御、15点法术防御的民兵为你战斗。民兵存在55秒。\n（施法范围：150）",
	"召唤4个960生命、76-112点攻击力、34点物理防御、19点法术防御的民兵为你战斗。民兵存在55秒。\n（施法范围：150）",
	"召唤4个1140生命、92-136点攻击力、40点物理防御、23点法术防御的民兵为你战斗。民兵存在55秒。\n（施法范围：150）",
	"召唤4个1320生命、108-150点攻击力、46点物理防御、27点法术防御的民兵为你战斗。民兵存在55秒。\n（施法范围：150）",
	"召唤4个1500生命、124-174点攻击力、52点物理防御、31点法术防御的民兵为你战斗。民兵存在55秒。\n（施法范围：150）",
	"召唤4个1680生命、140-198点攻击力、58点物理防御、35点法术防御的民兵为你战斗。民兵存在55秒。\n（施法范围：150）",
	"召唤4个1860生命、156-222点攻击力、64点物理防御、39点法术防御的民兵为你战斗。民兵存在55秒。\n（施法范围：150）",
	"召唤4个2040生命、172-246点攻击力、70点物理防御、43点法术防御的民兵为你战斗。民兵存在55秒。\n（施法范围：150）",
	"召唤4个2220生命、188-270点攻击力、76点物理防御、47点法术防御的民兵为你战斗。民兵存在55秒。\n（施法范围：150）",
	"召唤4个2400生命、204-294点攻击力、82点物理防御、51点法术防御的民兵为你战斗。民兵存在55秒。\n（施法范围：150）",
	"召唤4个2580生命、220-318点攻击力、88点物理防御、55点法术防御的民兵为你战斗。民兵存在55秒。\n（施法范围：150）",
	"召唤4个2760生命、236-342点攻击力、94点物理防御、59点法术防御的民兵为你战斗。民兵存在55秒。\n（施法范围：150）",
}

_tab_stringT[2106] = {"军令如山（竞技场）",
	"召唤3个90点生命、16-24点攻击力、3点物理防御、10点法术防御的弓箭手为你战斗。弓箭手存在25秒。\n（施法范围：150）",
	"召唤3个180点生命、30-56点攻击力、5点物理防御、16点法术防御的弓箭手为你战斗。弓箭手存在25秒。\n（施法范围：150）",
	"召唤3个270点生命、54-88点攻击力、7点物理防御、22点法术防御的弓箭手为你战斗。弓箭手存在25秒。\n（施法范围：150）",
	"召唤3个360点生命、78-120点攻击力、9点物理防御、28点法术防御的弓箭手为你战斗。弓箭手存在25秒。\n（施法范围：150）",
	"召唤3个450点生命、102-152点攻击力、11点物理防御、34点法术防御的弓箭手为你战斗。弓箭手存在25秒。\n（施法范围：150）",
	"召唤3个540点生命、126-184点攻击力、13点物理防御、40点法术防御的弓箭手为你战斗。弓箭手存在25秒。\n（施法范围：150）",
	"召唤3个630点生命、150-216点攻击力、15点物理防御、46点法术防御的弓箭手为你战斗。弓箭手存在25秒。\n（施法范围：150）",
	"召唤3个720点生命、174-248点攻击力、17点物理防御、52点法术防御的弓箭手为你战斗。弓箭手存在25秒。\n（施法范围：150）",
	"召唤3个810点生命、198-280点攻击力、19点物理防御、58点法术防御的弓箭手为你战斗。弓箭手存在25秒。\n（施法范围：150）",
	"召唤3个900点生命、222-312点攻击力、21点物理防御、64点法术防御的弓箭手为你战斗。弓箭手存在25秒。\n（施法范围：150）",
	"召唤3个990点生命、246-344点攻击力、23点物理防御、70点法术防御的弓箭手为你战斗。弓箭手存在25秒。\n（施法范围：150）",
	"召唤3个1080点生命、270-376点攻击力、25点物理防御、76点法术防御的弓箭手为你战斗。弓箭手存在25秒。\n（施法范围：150）",
	"召唤3个1170点生命、294-408点攻击力、27点物理防御、82点法术防御的弓箭手为你战斗。弓箭手存在25秒。\n（施法范围：150）",
	"召唤3个1260点生命、318-440点攻击力、29点物理防御、88点法术防御的弓箭手为你战斗。弓箭手存在25秒。\n（施法范围：150）",
	"召唤3个1350点生命、342-472点攻击力、31点物理防御、94点法术防御的弓箭手为你战斗。弓箭手存在25秒。\n（施法范围：150）",
}

_tab_stringT[2107] = {"全军突击（竞技场）",
	"提升自己和附近120范围内的友军12％的移动速度、攻击速度、射程，持续7秒。",
	"提升自己和附近120范围内的友军13％的移动速度、攻击速度、射程，持续7秒。",
	"提升自己和附近120范围内的友军14％的移动速度、攻击速度、射程，持续7秒。",
	"提升自己和附近120范围内的友军15％的移动速度、攻击速度、射程，持续7秒。",
	"提升自己和附近120范围内的友军16％的移动速度、攻击速度、射程，持续7秒。",
	"提升自己和附近120范围内的友军17％的移动速度、攻击速度、射程，持续7秒。",
	"提升自己和附近120范围内的友军18％的移动速度、攻击速度、射程，持续7秒。",
	"提升自己和附近120范围内的友军19％的移动速度、攻击速度、射程，持续7秒。",
	"提升自己和附近120范围内的友军20％的移动速度、攻击速度、射程，持续7秒。",
	"提升自己和附近120范围内的友军21％的移动速度、攻击速度、射程，持续7秒。",
	"提升自己和附近120范围内的友军22％的移动速度、攻击速度、射程，持续7秒。",
	"提升自己和附近120范围内的友军23％的移动速度、攻击速度、射程，持续7秒。",
	"提升自己和附近120范围内的友军24％的移动速度、攻击速度、射程，持续7秒。",
	"提升自己和附近120范围内的友军25％的移动速度、攻击速度、射程，持续7秒。",
	"提升自己和附近120范围内的友军26％的移动速度、攻击速度、射程，持续7秒。",
}

_tab_stringT[2109] = {"无双分身（竞技场）",
	"召唤1个1000点生命、15点攻击、10点物理防御、2点法术防御、拥有嘲讽、七探蛇盘枪技能的分身为你战斗。分身存在12秒。\n（施法范围：200）",
	"召唤1个1100点生命、20点攻击、12点物理防御、3点法术防御、拥有嘲讽、七探蛇盘枪技能的分身为你战斗。分身存在12秒。\n（施法范围：200）",
	"召唤1个1200点生命、25点攻击、14点物理防御、4点法术防御、拥有嘲讽、七探蛇盘枪技能的分身为你战斗。分身存在12秒。\n（施法范围：200）",
	"召唤1个1300点生命、30点攻击、16点物理防御、5点法术防御、拥有嘲讽、七探蛇盘枪技能的分身为你战斗。分身存在12秒。\n（施法范围：200）",
	"召唤1个1400点生命、35点攻击、18点物理防御、6点法术防御、拥有嘲讽、七探蛇盘枪技能的分身为你战斗。分身存在12秒。\n（施法范围：200）",
	"召唤1个1500点生命、40点攻击、20点物理防御、7点法术防御、拥有嘲讽、七探蛇盘枪技能的分身为你战斗。分身存在12秒。\n（施法范围：200）",
	"召唤1个1600点生命、45点攻击、22点物理防御、8点法术防御、拥有嘲讽、七探蛇盘枪技能的分身为你战斗。分身存在12秒。\n（施法范围：200）",
	"召唤1个1700点生命、50点攻击、24点物理防御、9点法术防御、拥有嘲讽、七探蛇盘枪技能的分身为你战斗。分身存在12秒。\n（施法范围：200）",
	"召唤1个1800点生命、55点攻击、26点物理防御、10点法术防御、拥有嘲讽、七探蛇盘枪技能的分身为你战斗。分身存在12秒。\n（施法范围：200）",
	"召唤1个1900点生命、60点攻击、28点物理防御、11点法术防御、拥有嘲讽、七探蛇盘枪技能的分身为你战斗。分身存在12秒。\n（施法范围：200）",
	"召唤1个2000点生命、65点攻击、30点物理防御、12点法术防御、拥有嘲讽、七探蛇盘枪技能的分身为你战斗。分身存在12秒。\n（施法范围：200）",
	"召唤1个2100点生命、70点攻击、32点物理防御、13点法术防御、拥有嘲讽、七探蛇盘枪技能的分身为你战斗。分身存在12秒。\n（施法范围：200）",
	"召唤1个2200点生命、75点攻击、34点物理防御、14点法术防御、拥有嘲讽、七探蛇盘枪技能的分身为你战斗。分身存在12秒。\n（施法范围：200）",
	"召唤1个2300点生命、80点攻击、36点物理防御、15点法术防御、拥有嘲讽、七探蛇盘枪技能的分身为你战斗。分身存在12秒。\n（施法范围：200）",
	"召唤1个2400点生命、85点攻击、38点物理防御、16点法术防御、拥有嘲讽、七探蛇盘枪技能的分身为你战斗。分身存在12秒。\n（施法范围：200）",
}

--PVP孙策
_tab_stringT[2117] = {"霸气剑光（竞技场）",
	"随机在目标地点80范围内召唤6把落剑，每一把落剑都对小范围敌人造成攻击力80％+60点的物理伤害。\n（施法范围：200）",
	"随机在目标地点80范围内召唤7把落剑，每一把落剑都对小范围敌人造成攻击力90％+75点的物理伤害。\n（施法范围：200）",
	"随机在目标地点80范围内召唤8把落剑，每一把落剑都对小范围敌人造成攻击力100％+90点的物理伤害。\n（施法范围：200）",
	"随机在目标地点80范围内召唤9把落剑，每一把落剑都对小范围敌人造成攻击力110％+105点的物理伤害。\n（施法范围：200）",
	"随机在目标地点80范围内召唤10把落剑，每一把落剑都对小范围敌人造成攻击力120％+120点的物理伤害。\n（施法范围：200）",
	"随机在目标地点80范围内召唤11把落剑，每一把落剑都对小范围敌人造成攻击力130％+135点的物理伤害。\n（施法范围：200）",
	"随机在目标地点80范围内召唤12把落剑，每一把落剑都对小范围敌人造成攻击力140％+150点的物理伤害。\n（施法范围：200）",
	"随机在目标地点80范围内召唤13把落剑，每一把落剑都对小范围敌人造成攻击力150％+165点的物理伤害。\n（施法范围：200）",
	"随机在目标地点80范围内召唤14把落剑，每一把落剑都对小范围敌人造成攻击力160％+180点的物理伤害。\n（施法范围：200）",
	"随机在目标地点80范围内召唤15把落剑，每一把落剑都对小范围敌人造成攻击力170％+195点的物理伤害。\n（施法范围：200）",
	"随机在目标地点80范围内召唤16把落剑，每一把落剑都对小范围敌人造成攻击力180％+210点的物理伤害。\n（施法范围：200）",
	"随机在目标地点80范围内召唤17把落剑，每一把落剑都对小范围敌人造成攻击力190％+225点的物理伤害。\n（施法范围：200）",
	"随机在目标地点80范围内召唤18把落剑，每一把落剑都对小范围敌人造成攻击力200％+240点的物理伤害。\n（施法范围：200）",
	"随机在目标地点80范围内召唤19把落剑，每一把落剑都对小范围敌人造成攻击力210％+255点的物理伤害。\n（施法范围：200）",
	"随机在目标地点80范围内召唤20把落剑，每一把落剑都对小范围敌人造成攻击力220％+270点的物理伤害。\n（施法范围：200）",
}


--PVP周瑜战术技能
_tab_stringT[2118] = {"召唤水兵（竞技场）",
	"召唤4个420点生命、22-27点攻击力、10点物理防御、0点法术防御的水兵为你战斗。水兵存在15秒。\n（施法范围：150）",
	"召唤4个640点生命、40-57点攻击力、14点物理防御、0点法术防御的水兵为你战斗。水兵存在15秒。\n（施法范围：150）",
	"召唤4个860点生命、58-87点攻击力、18点物理防御、0点法术防御的水兵为你战斗。水兵存在15秒。\n（施法范围：150）",
	"召唤4个1080点生命、76-117点攻击力、22点物理防御、0点法术防御的水兵为你战斗。水兵存在15秒。\n（施法范围：150）",
	"召唤4个1300点生命、94-147点攻击力、26点物理防御、0点法术防御的水兵为你战斗。水兵存在15秒。\n（施法范围：150）",
	"召唤4个1520点生命、112-177点攻击力、30点物理防御、0点法术防御的水兵为你战斗。水兵存在15秒。\n（施法范围：150）",
	"召唤4个1740点生命、130-207点攻击力、34点物理防御、0点法术防御的水兵为你战斗。水兵存在15秒。\n（施法范围：150）",
	"召唤4个1960点生命、148-237点攻击力、38点物理防御、0点法术防御的水兵为你战斗。水兵存在15秒。\n（施法范围：150）",
	"召唤4个2180点生命、166-267点攻击力、42点物理防御、0点法术防御的水兵为你战斗。水兵存在15秒。\n（施法范围：150）",
	"召唤4个2400点生命、184-297点攻击力、46点物理防御、0点法术防御的水兵为你战斗。水兵存在15秒。\n（施法范围：150）",
	"召唤4个2620点生命、202-327点攻击力、50点物理防御、0点法术防御的水兵为你战斗。水兵存在15秒。\n（施法范围：150）",
	"召唤4个2840点生命、220-357点攻击力、54点物理防御、0点法术防御的水兵为你战斗。水兵存在15秒。\n（施法范围：150）",
	"召唤4个3060点生命、238-387点攻击力、58点物理防御、0点法术防御的水兵为你战斗。水兵存在15秒。\n（施法范围：150）",
	"召唤4个3280点生命、256-417点攻击力、62点物理防御、0点法术防御的水兵为你战斗。水兵存在15秒。\n（施法范围：150）",
	"召唤4个3500点生命、274-447点攻击力、66点物理防御、0点法术防御的水兵为你战斗。水兵存在15秒。\n（施法范围：150）",
}

_tab_stringT[2123] = {"黑炎漩涡（竞技场）",
	"在目标地点创造一个漩涡，持续将110范围内的敌人吸入漩涡。在此期间目标不能攻击、移动、释放技能，并每秒受到庞统攻击力150％的法术伤害。漩涡持续3.5秒。\n（施法范围：200）",
	"在目标地点创造一个漩涡，持续将110范围内的敌人吸入漩涡。在此期间目标不能攻击、移动、释放技能，并每秒受到庞统攻击力200％的法术伤害。漩涡持续4秒。\n（施法范围：200）",
	"在目标地点创造一个漩涡，持续将110范围内的敌人吸入漩涡。在此期间目标不能攻击、移动、释放技能，并每秒受到庞统攻击力250％的法术伤害。漩涡持续4.5秒。\n（施法范围：200）",
	"在目标地点创造一个漩涡，持续将110范围内的敌人吸入漩涡。在此期间目标不能攻击、移动、释放技能，并每秒受到庞统攻击力300％的法术伤害。漩涡持续5秒。\n（施法范围：200）",
	"在目标地点创造一个漩涡，持续将110范围内的敌人吸入漩涡。在此期间目标不能攻击、移动、释放技能，并每秒受到庞统攻击力350％的法术伤害。漩涡持续5.5秒。\n（施法范围：200）",
	"在目标地点创造一个漩涡，持续将110范围内的敌人吸入漩涡。在此期间目标不能攻击、移动、释放技能，并每秒受到庞统攻击力400％的法术伤害。漩涡持续6秒。\n（施法范围：200）",
	"在目标地点创造一个漩涡，持续将110范围内的敌人吸入漩涡。在此期间目标不能攻击、移动、释放技能，并每秒受到庞统攻击力450％的法术伤害。漩涡持续6秒。\n（施法范围：200）",
	"在目标地点创造一个漩涡，持续将110范围内的敌人吸入漩涡。在此期间目标不能攻击、移动、释放技能，并每秒受到庞统攻击力500％的法术伤害。漩涡持续6秒。\n（施法范围：200）",
	"在目标地点创造一个漩涡，持续将110范围内的敌人吸入漩涡。在此期间目标不能攻击、移动、释放技能，并每秒受到庞统攻击力550％的法术伤害。漩涡持续6秒。\n（施法范围：200）",
	"在目标地点创造一个漩涡，持续将110范围内的敌人吸入漩涡。在此期间目标不能攻击、移动、释放技能，并每秒受到庞统攻击力600％的法术伤害。漩涡持续6秒。\n（施法范围：200）",
	"在目标地点创造一个漩涡，持续将110范围内的敌人吸入漩涡。在此期间目标不能攻击、移动、释放技能，并每秒受到庞统攻击力650％的法术伤害。漩涡持续6秒。\n（施法范围：200）",
	"在目标地点创造一个漩涡，持续将110范围内的敌人吸入漩涡。在此期间目标不能攻击、移动、释放技能，并每秒受到庞统攻击力700％的法术伤害。漩涡持续6秒。\n（施法范围：200）",
	"在目标地点创造一个漩涡，持续将110范围内的敌人吸入漩涡。在此期间目标不能攻击、移动、释放技能，并每秒受到庞统攻击力750％的法术伤害。漩涡持续6秒。\n（施法范围：200）",
	"在目标地点创造一个漩涡，持续将110范围内的敌人吸入漩涡。在此期间目标不能攻击、移动、释放技能，并每秒受到庞统攻击力800％的法术伤害。漩涡持续6秒。\n（施法范围：200）",
	"在目标地点创造一个漩涡，持续将110范围内的敌人吸入漩涡。在此期间目标不能攻击、移动、释放技能，并每秒受到庞统攻击力850％的法术伤害。漩涡持续6秒。\n（施法范围：200）",
}

_tab_stringT[2124] = {"机关弩炮（竞技场）",
	"放置2台160点生命、15-24点攻击力、240码射程、20点物理防御、-60点法术防御的机关弩炮为你战斗。机关弩炮附加黄月英20％的攻击力。机关弩炮存在15秒。\n（施法范围：180）",
	"放置2台240点生命、20-32点攻击力、240码射程、25点物理防御、-60点法术防御的机关弩炮为你战斗。机关弩炮附加黄月英20％的攻击力。机关弩炮存在15秒。\n（施法范围：180）",
	"放置2台320点生命、25-40点攻击力、240码射程、30点物理防御、-60点法术防御的机关弩炮为你战斗。机关弩炮附加黄月英20％的攻击力。机关弩炮存在15秒。\n（施法范围：180）",
	"放置2台400点生命、30-48点攻击力、240码射程、35点物理防御、-60点法术防御的机关弩炮为你战斗。机关弩炮附加黄月英20％的攻击力。机关弩炮存在15秒。\n（施法范围：180）",
	"放置2台480点生命、35-56点攻击力、240码射程、40点物理防御、-60点法术防御的机关弩炮为你战斗。机关弩炮附加黄月英20％的攻击力。机关弩炮存在15秒。\n（施法范围：180）",
	"放置2台560点生命、40-64点攻击力、240码射程、45点物理防御、-60点法术防御的机关弩炮为你战斗。机关弩炮附加黄月英20％的攻击力。机关弩炮存在15秒。\n（施法范围：180）",
	"放置2台640点生命、45-72点攻击力、240码射程、50点物理防御、-60点法术防御的机关弩炮为你战斗。机关弩炮附加黄月英20％的攻击力。机关弩炮存在15秒。\n（施法范围：180）",
	"放置2台720点生命、50-80点攻击力、240码射程、55点物理防御、-60点法术防御的机关弩炮为你战斗。机关弩炮附加黄月英20％的攻击力。机关弩炮存在15秒。\n（施法范围：180）",
	"放置2台800点生命、55-88点攻击力、240码射程、60点物理防御、-60点法术防御的机关弩炮为你战斗。机关弩炮附加黄月英20％的攻击力。机关弩炮存在15秒。\n（施法范围：180）",
	"放置2台880点生命、60-96点攻击力、240码射程、65点物理防御、-60点法术防御的机关弩炮为你战斗。机关弩炮附加黄月英20％的攻击力。机关弩炮存在15秒。\n（施法范围：180）",
	"放置2台960点生命、65-104点攻击力、240码射程、70点物理防御、-60点法术防御的机关弩炮为你战斗。机关弩炮附加黄月英20％的攻击力。机关弩炮存在15秒。\n（施法范围：180）",
	"放置2台1040点生命、70-112点攻击力、240码射程、75点物理防御、-60点法术防御的机关弩炮为你战斗。机关弩炮附加黄月英20％的攻击力。机关弩炮存在15秒。\n（施法范围：180）",
	"放置2台1120点生命、75-120点攻击力、240码射程、80点物理防御、-60点法术防御的机关弩炮为你战斗。机关弩炮附加黄月英20％的攻击力。机关弩炮存在15秒。\n（施法范围：180）",
	"放置2台1200点生命、80-128点攻击力、240码射程、85点物理防御、-60点法术防御的机关弩炮为你战斗。机关弩炮附加黄月英20％的攻击力。机关弩炮存在15秒。\n（施法范围：180）",
	"放置2台1280点生命、85-136点攻击力、240码射程、90点物理防御、-60点法术防御的机关弩炮为你战斗。机关弩炮附加黄月英20％的攻击力。机关弩炮存在15秒。\n（施法范围：180）",
}





_tab_stringT[3000] = {"新手卡",
	"每波开始时额外获得500金。",
	"每波开始时额外获得500金。",
	"每波开始时额外获得500金。",
	"每波开始时额外获得500金。",
	"每波开始时额外获得500金。",
	"每波开始时额外获得500金。",
	"每波开始时额外获得500金。",
	"每波开始时额外获得500金。",
	"每波开始时额外获得500金。",
	"每波开始时额外获得500金。",
}

--========================
---双人副本战术技能卡

--第一类
_tab_stringT[3001] = {"箭塔系强化",
	"箭塔系攻击力+50％。",
	"箭塔系攻击力+60％。",
	"箭塔系攻击力+70％。",
	"箭塔系攻击力+80％。",
	"箭塔系攻击力+90％。",
	"箭塔系攻击力+100％。",
	"箭塔系攻击力+110％。",
	"箭塔系攻击力+120％。",
	"箭塔系攻击力+130％。",
	"箭塔系攻击力+140％。",
}

_tab_stringT[3002] = {"箭塔系强化",
	"箭塔系攻击速度+50％。",
	"箭塔系攻击速度+60％。",
	"箭塔系攻击速度+70％。",
	"箭塔系攻击速度+80％。",
	"箭塔系攻击速度+90％。",
	"箭塔系攻击速度+100％。",
	"箭塔系攻击速度+110％。",
	"箭塔系攻击速度+120％。",
	"箭塔系攻击速度+130％。",
	"箭塔系攻击速度+140％。",
}

_tab_stringT[3003] = {"箭塔系强化",
	"箭塔系暴击几率+20％。",
	"箭塔系暴击几率+25％。",
	"箭塔系暴击几率+30％。",
	"箭塔系暴击几率+35％。",
	"箭塔系暴击几率+40％。",
	"箭塔系暴击几率+45％。",
	"箭塔系暴击几率+50％。",
	"箭塔系暴击几率+55％。",
	"箭塔系暴击几率+60％。",
	"箭塔系暴击几率+65％。",
}

_tab_stringT[3004] = {"箭塔系强化",
	"箭塔系射程+50码。",
	"箭塔系射程+60码。",
	"箭塔系射程+70码。",
	"箭塔系射程+80码。",
	"箭塔系射程+90码。",
	"箭塔系射程+100码。",
	"箭塔系射程+110码。",
	"箭塔系射程+120码。",
	"箭塔系射程+130码。",
	"箭塔系射程+140码。",
}

_tab_stringT[3005] = {"法术塔系强化",
	"法术塔系攻击力+50％。",
	"法术塔系攻击力+60％。",
	"法术塔系攻击力+70％。",
	"法术塔系攻击力+80％。",
	"法术塔系攻击力+90％。",
	"法术塔系攻击力+100％。",
	"法术塔系攻击力+110％。",
	"法术塔系攻击力+120％。",
	"法术塔系攻击力+130％。",
	"法术塔系攻击力+140％。",
}

_tab_stringT[3006] = {"法术塔系强化",
	"法术塔系攻击速度+50％。",
	"法术塔系攻击速度+60％。",
	"法术塔系攻击速度+70％。",
	"法术塔系攻击速度+80％。",
	"法术塔系攻击速度+90％。",
	"法术塔系攻击速度+100％。",
	"法术塔系攻击速度+110％。",
	"法术塔系攻击速度+120％。",
	"法术塔系攻击速度+130％。",
	"法术塔系攻击速度+140％。",
}

_tab_stringT[3007] = {"法术塔系强化",
	"法术塔系暴击几率+20％。",
	"法术塔系暴击几率+25％。",
	"法术塔系暴击几率+30％。",
	"法术塔系暴击几率+35％。",
	"法术塔系暴击几率+40％。",
	"法术塔系暴击几率+45％。",
	"法术塔系暴击几率+50％。",
	"法术塔系暴击几率+55％。",
	"法术塔系暴击几率+60％。",
	"法术塔系暴击几率+65％。",
}

_tab_stringT[3008] = {"法术塔系强化",
	"法术塔系射程+50码。",
	"法术塔系射程+60码。",
	"法术塔系射程+70码。",
	"法术塔系射程+80码。",
	"法术塔系射程+90码。",
	"法术塔系射程+100码。",
	"法术塔系射程+110码。",
	"法术塔系射程+120码。",
	"法术塔系射程+130码。",
	"法术塔系射程+140码。",
}

_tab_stringT[3009] = {"炮塔强化",
	"炮塔系攻击力+50％。",
	"炮塔系攻击力+60％。",
	"炮塔系攻击力+70％。",
	"炮塔系攻击力+80％。",
	"炮塔系攻击力+90％。",
	"炮塔系攻击力+100％。",
	"炮塔系攻击力+110％。",
	"炮塔系攻击力+120％。",
	"炮塔系攻击力+130％。",
	"炮塔系攻击力+140％。",
}

_tab_stringT[3010] = {"炮塔系强化",
	"炮塔系攻击速度+50％。",
	"炮塔系攻击速度+60％。",
	"炮塔系攻击速度+70％。",
	"炮塔系攻击速度+80％。",
	"炮塔系攻击速度+90％。",
	"炮塔系攻击速度+100％。",
	"炮塔系攻击速度+110％。",
	"炮塔系攻击速度+120％。",
	"炮塔系攻击速度+130％。",
	"炮塔系攻击速度+140％。",
}

_tab_stringT[3011] = {"炮塔系强化",
	"炮塔系暴击几率+20％。",
	"炮塔系暴击几率+25％。",
	"炮塔系暴击几率+30％。",
	"炮塔系暴击几率+35％。",
	"炮塔系暴击几率+40％。",
	"炮塔系暴击几率+45％。",
	"炮塔系暴击几率+50％。",
	"炮塔系暴击几率+55％。",
	"炮塔系暴击几率+60％。",
	"炮塔系暴击几率+65％。",
}

_tab_stringT[3012] = {"炮塔系强化",
	"炮塔系射程+50码。",
	"炮塔系射程+60码。",
	"炮塔系射程+70码。",
	"炮塔系射程+80码。",
	"炮塔系射程+90码。",
	"炮塔系射程+100码。",
	"炮塔系射程+110码。",
	"炮塔系射程+120码。",
	"炮塔系射程+130码。",
	"炮塔系射程+140码。",
}

_tab_stringT[3013] = {"防御塔强化",
	"全部防御塔攻击速度+50％。",
	"全部防御塔攻击速度+60％。",
	"全部防御塔攻击速度+70％。",
	"全部防御塔攻击速度+80％。",
	"全部防御塔攻击速度+90％。",
	"全部防御塔攻击速度+100％。",
	"全部防御塔攻击速度+110％。",
	"全部防御塔攻击速度+120％。",
	"全部防御塔攻击速度+130％。",
	"全部防御塔攻击速度+140％。",
}

_tab_stringT[3014] = {"防御塔强化",
	"全部防御塔射程+50码。",
	"全部防御塔射程+60码。",
	"全部防御塔射程+70码。",
	"全部防御塔射程+80码。",
	"全部防御塔射程+90码。",
	"全部防御塔射程+100码。",
	"全部防御塔射程+110码。",
	"全部防御塔射程+120码。",
	"全部防御塔射程+130码。",
	"全部防御塔射程+140码。",
	"全部防御塔射程+150码。",
	"全部防御塔射程+160码。",
	"全部防御塔射程+170码。",
	"全部防御塔射程+180码。",
	"全部防御塔射程+190码。",
}

_tab_stringT[3015] = {"防御塔强化",
	"全部防御塔攻击力+50％。",
	"全部防御塔攻击力+60％。",
	"全部防御塔攻击力+70％。",
	"全部防御塔攻击力+80％。",
	"全部防御塔攻击力+90％。",
	"全部防御塔攻击力+100％。",
	"全部防御塔攻击力+110％。",
	"全部防御塔攻击力+120％。",
	"全部防御塔攻击力+130％。",
	"全部防御塔攻击力+140％。",
	"全部防御塔攻击力+150％。",
	"全部防御塔攻击力+160％。",
	"全部防御塔攻击力+170％。",
	"全部防御塔攻击力+180％。",
	"全部防御塔攻击力+190％。",
}






--第二类
_tab_stringT[3021] = {"剧毒塔强化",
	"剧毒塔攻击速度+120％。",
	"剧毒塔攻击速度+130％。",
	"剧毒塔攻击速度+140％。",
	"剧毒塔攻击速度+150％。",
	"剧毒塔攻击速度+160％。",
	"剧毒塔攻击速度+170％。",
	"剧毒塔攻击速度+180％。",
	"剧毒塔攻击速度+190％。",
	"剧毒塔攻击速度+200％。",
	"剧毒塔攻击速度+210％。",
}

_tab_stringT[3022] = {"连弩塔强化",
	"连弩塔攻击力+120％。",
	"连弩塔攻击力+130％。",
	"连弩塔攻击力+140％。",
	"连弩塔攻击力+150％。",
	"连弩塔攻击力+160％。",
	"连弩塔攻击力+170％。",
	"连弩塔攻击力+180％。",
	"连弩塔攻击力+190％。",
	"连弩塔攻击力+200％。",
	"连弩塔攻击力+210％。",
}

_tab_stringT[3023] = {"狙击塔强化",
	"狙击塔攻击速度+120％。",
	"狙击塔攻击速度+130％。",
	"狙击塔攻击速度+140％。",
	"狙击塔攻击速度+150％。",
	"狙击塔攻击速度+160％。",
	"狙击塔攻击速度+170％。",
	"狙击塔攻击速度+180％。",
	"狙击塔攻击速度+190％。",
	"狙击塔攻击速度+300％。",
	"狙击塔攻击速度+210％。",
}

_tab_stringT[3024] = {"火焰塔强化",
	"火焰塔攻击速度+120％。",
	"火焰塔攻击速度+130％。",
	"火焰塔攻击速度+140％。",
	"火焰塔攻击速度+150％。",
	"火焰塔攻击速度+160％。",
	"火焰塔攻击速度+170％。",
	"火焰塔攻击速度+180％。",
	"火焰塔攻击速度+190％。",
	"火焰塔攻击速度+200％。",
	"火焰塔攻击速度+210％。",
}

_tab_stringT[3025] = {"寒冰塔强化",
	"寒冰塔攻击速度+120％。",
	"寒冰塔攻击速度+130％。",
	"寒冰塔攻击速度+140％。",
	"寒冰塔攻击速度+150％。",
	"寒冰塔攻击速度+160％。",
	"寒冰塔攻击速度+170％。",
	"寒冰塔攻击速度+180％。",
	"寒冰塔攻击速度+190％。",
	"寒冰塔攻击速度+200％。",
	"寒冰塔攻击速度+210％。",
}

_tab_stringT[3026] = {"天雷塔强化",
	"天雷塔攻击力+120％。",
	"天雷塔攻击力+130％。",
	"天雷塔攻击力+140％。",
	"天雷塔攻击力+150％。",
	"天雷塔攻击力+160％。",
	"天雷塔攻击力+170％。",
	"天雷塔攻击力+180％。",
	"天雷塔攻击力+190％。",
	"天雷塔攻击力+200％。",
	"天雷塔攻击力+210％。",
}

_tab_stringT[3027] = {"巨炮塔强化",
	"巨炮塔攻击力+120％。",
	"巨炮塔攻击力+130％。",
	"巨炮塔攻击力+140％。",
	"巨炮塔攻击力+150％。",
	"巨炮塔攻击力+160％。",
	"巨炮塔攻击力+170％。",
	"巨炮塔攻击力+180％。",
	"巨炮塔攻击力+190％。",
	"巨炮塔攻击力+200％。",
	"巨炮塔攻击力+210％。",
}

_tab_stringT[3028] = {"轰天塔强化",
	"轰天塔攻击力+120％。",
	"轰天塔攻击力+130％。",
	"轰天塔攻击力+140％。",
	"轰天塔攻击力+150％。",
	"轰天塔攻击力+160％。",
	"轰天塔攻击力+170％。",
	"轰天塔攻击力+180％。",
	"轰天塔攻击力+190％。",
	"轰天塔攻击力+200％。",
	"轰天塔攻击力+210％。",
}

_tab_stringT[3029] = {"滚石塔强化",
	"滚石塔攻击力+120％。",
	"滚石塔攻击力+130％。",
	"滚石塔攻击力+140％。",
	"滚石塔攻击力+150％。",
	"滚石塔攻击力+160％。",
	"滚石塔攻击力+170％。",
	"滚石塔攻击力+180％。",
	"滚石塔攻击力+190％。",
	"滚石塔攻击力+200％。",
	"滚石塔攻击力+210％。",
}

_tab_stringT[3030] = {"剧毒塔强化",
	"剧毒塔射程+120码。",
	"剧毒塔射程+130码。",
	"剧毒塔射程+140码。",
	"剧毒塔射程+150码。",
	"剧毒塔射程+160码。",
	"剧毒塔射程+170码。",
	"剧毒塔射程+180码。",
	"剧毒塔射程+190码。",
	"剧毒塔射程+200码。",
	"剧毒塔射程+210码。",
}

_tab_stringT[3031] = {"连弩塔强化",
	"连弩塔射程+120码。",
	"连弩塔射程+130码。",
	"连弩塔射程+140码。",
	"连弩塔射程+150码。",
	"连弩塔射程+160码。",
	"连弩塔射程+170码。",
	"连弩塔射程+180码。",
	"连弩塔射程+190码。",
	"连弩塔射程+200码。",
	"连弩塔射程+210码。",
}

_tab_stringT[3032] = {"狙击塔强化",
	"狙击塔暴击几率+50％。",
	"狙击塔暴击几率+55％。",
	"狙击塔暴击几率+60％。",
	"狙击塔暴击几率+65％。",
	"狙击塔暴击几率+70％。",
	"狙击塔暴击几率+75％。",
	"狙击塔暴击几率+80％。",
	"狙击塔暴击几率+85％。",
	"狙击塔暴击几率+90％。",
	"狙击塔暴击几率+95％。",
}

_tab_stringT[3033] = {"火焰塔强化",
	"火焰塔攻击力+120％。",
	"火焰塔攻击力+130％。",
	"火焰塔攻击力+140％。",
	"火焰塔攻击力+150％。",
	"火焰塔攻击力+160％。",
	"火焰塔攻击力+170％。",
	"火焰塔攻击力+180％。",
	"火焰塔攻击力+190％。",
	"火焰塔攻击力+200％。",
	"火焰塔攻击力+210％。",
}

_tab_stringT[3034] = {"寒冰塔强化",
	"寒冰塔射程+120码。",
	"寒冰塔射程+130码。",
	"寒冰塔射程+140码。",
	"寒冰塔射程+150码。",
	"寒冰塔射程+160码。",
	"寒冰塔射程+170码。",
	"寒冰塔射程+180码。",
	"寒冰塔射程+190码。",
	"寒冰塔射程+200码。",
	"寒冰塔射程+210码。",
}

_tab_stringT[3035] = {"天雷塔强化",
	"天雷塔攻击速度+120％。",
	"天雷塔攻击速度+130％。",
	"天雷塔攻击速度+140％。",
	"天雷塔攻击速度+150％。",
	"天雷塔攻击速度+160％。",
	"天雷塔攻击速度+170％。",
	"天雷塔攻击速度+180％。",
	"天雷塔攻击速度+190％。",
	"天雷塔攻击速度+200％。",
	"天雷塔攻击速度+210％。",
}

_tab_stringT[3036] = {"巨炮塔强化",
	"巨炮塔攻击速度+120％。",
	"巨炮塔攻击速度+130％。",
	"巨炮塔攻击速度+140％。",
	"巨炮塔攻击速度+150％。",
	"巨炮塔攻击速度+160％。",
	"巨炮塔攻击速度+170％。",
	"巨炮塔攻击速度+180％。",
	"巨炮塔攻击速度+190％。",
	"巨炮塔攻击速度+200％。",
	"巨炮塔攻击速度+210％。",
}

_tab_stringT[3037] = {"轰天塔强化",
	"轰天塔攻击速度+120％。",
	"轰天塔攻击速度+130％。",
	"轰天塔攻击速度+140％。",
	"轰天塔攻击速度+150％。",
	"轰天塔攻击速度+160％。",
	"轰天塔攻击速度+170％。",
	"轰天塔攻击速度+180％。",
	"轰天塔攻击速度+190％。",
	"轰天塔攻击速度+200％。",
	"轰天塔攻击速度+210％。",
}

_tab_stringT[3038] = {"滚石塔强化",
	"滚石塔暴击几率+50％。",
	"滚石塔暴击几率+55％。",
	"滚石塔暴击几率+60％。",
	"滚石塔暴击几率+65％。",
	"滚石塔暴击几率+70％。",
	"滚石塔暴击几率+75％。",
	"滚石塔暴击几率+80％。",
	"滚石塔暴击几率+85％。",
	"滚石塔暴击几率+90％。",
	"滚石塔暴击几率+95％。",
}

_tab_stringT[3039] = {"地刺塔",
	"游戏局中可以直接建造1级地刺塔。",
	"游戏局中可以直接建造2级地刺塔。",
	"游戏局中可以直接建造3级地刺塔。",
	"游戏局中可以直接建造4级地刺塔。",
	"游戏局中可以直接建造5级地刺塔。",
	"游戏局中可以直接建造6级地刺塔。",
	"游戏局中可以直接建造7级地刺塔。",
	"游戏局中可以直接建造8级地刺塔。",
	"游戏局中可以直接建造9级地刺塔。",
	"游戏局中可以直接建造10级地刺塔。",
}

_tab_stringT[3040] = {"粮仓",
	"游戏局中可以直接建造1级粮仓。",
	"游戏局中可以直接建造2级粮仓。",
	"游戏局中可以直接建造3级粮仓。",
	"游戏局中可以直接建造4级粮仓。",
	"游戏局中可以直接建造5级粮仓。",
	"游戏局中可以直接建造6级粮仓。",
	"游戏局中可以直接建造7级粮仓。",
	"游戏局中可以直接建造8级粮仓。",
	"游戏局中可以直接建造9级粮仓。",
	"游戏局中可以直接建造10级粮仓。",
}

--第三类
_tab_stringT[3041] = {"敌人生命加强",
	"敌人生命值+20％。",
	"敌人生命值+30％。",
	"敌人生命值+40％。",
	"敌人生命值+50％。",
	"敌人生命值+60％。",
	"敌人生命值+70％。",
	"敌人生命值+80％。",
	"敌人生命值+90％。",
	"敌人生命值+100％。",
	"敌人生命值+110％。",
	"敌人生命值+120％。",
	"敌人生命值+130％。",
	"敌人生命值+140％。",
	"敌人生命值+150％。",
	"敌人生命值+160％。",
	"敌人生命值+170％。",
	"敌人生命值+180％。",
	"敌人生命值+190％。",
	"敌人生命值+200％。",
	"敌人生命值+210％。",
	"敌人生命值+220％。",
	"敌人生命值+230％。",
	"敌人生命值+240％。",
	"敌人生命值+250％。",
	"敌人生命值+260％。",
	"敌人生命值+270％。",
	"敌人生命值+280％。",
	"敌人生命值+290％。",
	"敌人生命值+300％。",
	"敌人生命值+310％。",
	"敌人生命值+320％。",
	"敌人生命值+330％。",
	"敌人生命值+340％。",
	"敌人生命值+350％。",
	"敌人生命值+360％。",
	"敌人生命值+370％。",
	"敌人生命值+380％。",
	"敌人生命值+390％。",
	"敌人生命值+400％。",
	"敌人生命值+410％。",
}

_tab_stringT[3042] = {"敌人生命削减",
	"敌人生命值-20％。",
	"敌人生命值-25％。",
	"敌人生命值-30％。",
	"敌人生命值-35％。",
	"敌人生命值-40％。",
	"敌人生命值-45％。",
	"敌人生命值-50％。",
	"敌人生命值-55％。",
	"敌人生命值-60％。",
	"敌人生命值-65％。",
}

_tab_stringT[3043] = {"敌人攻击加强",
	"敌人攻击力+25％。",
	"敌人攻击力+30％。",
	"敌人攻击力+35％。",
	"敌人攻击力+40％。",
	"敌人攻击力+45％。",
	"敌人攻击力+50％。",
	"敌人攻击力+55％。",
	"敌人攻击力+60％。",
	"敌人攻击力+65％。",
	"敌人攻击力+70％。",
	"敌人攻击力+75％。",
	"敌人攻击力+80％。",
	"敌人攻击力+85％。",
	"敌人攻击力+90％。",
	"敌人攻击力+95％。",
	"敌人攻击力+100％。",
	"敌人攻击力+105％。",
	"敌人攻击力+110％。",
	"敌人攻击力+115％。",
	"敌人攻击力+120％。",
	"敌人攻击力+125％。",
	"敌人攻击力+130％。",
	"敌人攻击力+135％。",
	"敌人攻击力+140％。",
	"敌人攻击力+145％。",
	"敌人攻击力+150％。",
	"敌人攻击力+155％。",
	"敌人攻击力+160％。",
	"敌人攻击力+165％。",
	"敌人攻击力+170％。",
	"敌人攻击力+175％。",
	"敌人攻击力+180％。",
	"敌人攻击力+185％。",
	"敌人攻击力+190％。",
	"敌人攻击力+195％。",
	"敌人攻击力+200％。",
	"敌人攻击力+205％。",
	"敌人攻击力+210％。",
	"敌人攻击力+215％。",
	"敌人攻击力+220％。",
	"敌人攻击力+225％。",
	"敌人攻击力+230％。",
	"敌人攻击力+235％。",
	"敌人攻击力+240％。",
	"敌人攻击力+245％。",
	"敌人攻击力+250％。",
	"敌人攻击力+255％。",
	"敌人攻击力+260％。",
	"敌人攻击力+265％。",
	"敌人攻击力+270％。",
	"敌人攻击力+275％。",
	"敌人攻击力+280％。",
	"敌人攻击力+285％。",
	"敌人攻击力+290％。",
	"敌人攻击力+295％。",
	"敌人攻击力+300％。",
}

_tab_stringT[3044] = {"敌人攻击削减",
	"敌人攻击力-25％。",
	"敌人攻击力-30％。",
	"敌人攻击力-35％。",
	"敌人攻击力-40％。",
	"敌人攻击力-45％。",
	"敌人攻击力-50％。",
	"敌人攻击力-55％。",
	"敌人攻击力-60％。",
	"敌人攻击力-65％。",
	"敌人攻击力-70％。",
}

_tab_stringT[3045] = {"敌人速度加强",
	"敌人移动速度+20％。",
	"敌人移动速度+25％。",
	"敌人移动速度+30％。",
	"敌人移动速度+35％。",
	"敌人移动速度+40％。",
	"敌人移动速度+45％。",
	"敌人移动速度+50％。",
	"敌人移动速度+55％。",
	"敌人移动速度+60％。",
	"敌人移动速度+65％。",
}

_tab_stringT[3046] = {"敌人速度削减",
	"敌人移动速度-20％。",
	"敌人移动速度-25％。",
	"敌人移动速度-30％。",
	"敌人移动速度-35％。",
	"敌人移动速度-40％。",
	"敌人移动速度-45％。",
	"敌人移动速度-50％。",
	"敌人移动速度-55％。",
	"敌人移动速度-60％。",
	"敌人移动速度-65％。",
}

_tab_stringT[3047] = {"敌人物防加强",
	"敌人物理防御+20点。",
	"敌人物理防御+30点。",
	"敌人物理防御+40点。",
	"敌人物理防御+50点。",
	"敌人物理防御+60点。",
	"敌人物理防御+70点。",
	"敌人物理防御+80点。",
	"敌人物理防御+90点。",
	"敌人物理防御+100点。",
	"敌人物理防御+110点。",
}

_tab_stringT[3048] = {"敌人物防削减",
	"敌人物理防御-20点。",
	"敌人物理防御-25点。",
	"敌人物理防御-30点。",
	"敌人物理防御-35点。",
	"敌人物理防御-40点。",
	"敌人物理防御-45点。",
	"敌人物理防御-50点。",
	"敌人物理防御-55点。",
	"敌人物理防御-60点。",
	"敌人物理防御-65点。",
}

_tab_stringT[3049] = {"敌人法防加强",
	"敌人法术防御+20点。",
	"敌人法术防御+30点。",
	"敌人法术防御+40点。",
	"敌人法术防御+50点。",
	"敌人法术防御+60点。",
	"敌人法术防御+70点。",
	"敌人法术防御+80点。",
	"敌人法术防御+90点。",
	"敌人法术防御+100点。",
	"敌人法术防御+110点。",
}

_tab_stringT[3050] = {"敌人法防削减",
	"敌人法术防御-20点。",
	"敌人法术防御-25点。",
	"敌人法术防御-30点。",
	"敌人法术防御-35点。",
	"敌人法术防御-40点。",
	"敌人法术防御-45点。",
	"敌人法术防御-50点。",
	"敌人法术防御-55点。",
	"敌人法术防御-60点。",
	"敌人法术防御-65点。"
}

_tab_stringT[3051] = {"敌人掉钱增加",
	"消灭敌人获得金钱+20％。",
	"消灭敌人获得金钱+30％。",
	"消灭敌人获得金钱+40％。",
	"消灭敌人获得金钱+50％。",
	"消灭敌人获得金钱+60％。",
	"消灭敌人获得金钱+70％。",
	"消灭敌人获得金钱+80％。",
	"消灭敌人获得金钱+90％。",
	"消灭敌人获得金钱+100％。",
	"消灭敌人获得金钱+110％。",
}

_tab_stringT[3052] = {"敌人掉钱减少",
	"消灭敌人获得金钱-20％。",
	"消灭敌人获得金钱-25％。",
	"消灭敌人获得金钱-30％。",
	"消灭敌人获得金钱-35％。",
	"消灭敌人获得金钱-40％。",
	"消灭敌人获得金钱-45％。",
	"消灭敌人获得金钱-50％。",
	"消灭敌人获得金钱-55％。",
	"消灭敌人获得金钱-60％。",
	"消灭敌人获得金钱-65％。",
}

_tab_stringT[3053] = {"每波发钱增加",
	"每波开始获得金钱+20％。",
	"每波开始获得金钱+30％。",
	"每波开始获得金钱+40％。",
	"每波开始获得金钱+50％。",
	"每波开始获得金钱+60％。",
	"每波开始获得金钱+70％。",
	"每波开始获得金钱+80％。",
	"每波开始获得金钱+90％。",
	"每波开始获得金钱+100％。",
	"每波开始获得金钱+110％。",
}

_tab_stringT[3054] = {"每波发钱减少",
	"每波开始获得金钱-20％。",
	"每波开始获得金钱-25％。",
	"每波开始获得金钱-30％。",
	"每波开始获得金钱-35％。",
	"每波开始获得金钱-40％。",
	"每波开始获得金钱-45％。",
	"每波开始获得金钱-50％。",
	"每波开始获得金钱-55％。",
	"每波开始获得金钱-60％。",
	"每波开始获得金钱-65％。",
}

_tab_stringT[3055] = {"敌人免控",
	"敌人免疫控制和减速效果。",
}

_tab_stringT[3056] = {"敌人精准攻击",
	"敌人无视闪避1.2倍攻击力。",
	"敌人无视闪避1.4倍攻击力。",
	"敌人无视闪避1.6倍攻击力。",
	"敌人无视闪避1.8倍攻击力。",
	"敌人无视闪避双倍攻击力。",
	"敌人无视闪避2.2倍攻击力。",
	"敌人无视闪避2.4倍攻击力。",
	"敌人无视闪避2.6倍攻击力。",
	"敌人无视闪避2.8倍攻击力。",
	"敌人无视闪避三倍攻击力。",
}

_tab_stringT[3057] = {"敌人重击",
	"敌人每次攻击击晕目标0.1秒。",
	"敌人每次攻击击晕目标0.2秒。",
	"敌人每次攻击击晕目标0.3秒。",
	"敌人每次攻击击晕目标0.4秒。",
	"敌人每次攻击击晕目标0.5秒。",
	"敌人每次攻击击晕目标0.6秒。",
	"敌人每次攻击击晕目标0.7秒。",
	"敌人每次攻击击晕目标0.8秒。",
	"敌人每次攻击击晕目标0.9秒。",
	"敌人每次攻击击晕目标1秒。",
}

_tab_stringT[3058] = {"敌人韧性",
	"敌人不会受到负面属性削减。",
}

_tab_stringT[3059] = {"敌将技能窃取",
	"敌方主将学会我方或友军某一个英雄身上的全部技能。",
}

_tab_stringT[3060] = {"敌人神行",
	"对敌人造成的减速效果改为对敌人加速。",
}

_tab_stringT[3061] = {"敌将反击",
	"敌方主将当前生命低于30％时会发动特殊技能。",
}

_tab_stringT[3062] = {"敌将伤害折射",
	"敌方主将受到的10％伤害平摊给周围的我方和友军单位。",
	"敌方主将受到的20％伤害平摊给周围的我方和友军单位。",
	"敌方主将受到的30％伤害平摊给周围的我方和友军单位。",
	"敌方主将受到的40％伤害平摊给周围的我方和友军单位。",
	"敌方主将受到的50％伤害平摊给周围的我方和友军单位。",
	"敌方主将受到的60％伤害平摊给周围的我方和友军单位。",
	"敌方主将受到的70％伤害平摊给周围的我方和友军单位。",
	"敌方主将受到的80％伤害平摊给周围的我方和友军单位。",
	"敌方主将受到的90％伤害平摊给周围的我方和友军单位。",
	"敌方主将受到的100％伤害平摊给周围的我方和友军单位。",
}

_tab_stringT[3063] = {"敌人吸血加强",
	"敌人攻击吸血+20％。",
	"敌人攻击吸血+30％。",
	"敌人攻击吸血+40％。",
	"敌人攻击吸血+50％。",
	"敌人攻击吸血+60％。",
	"敌人攻击吸血+70％。",
	"敌人攻击吸血+80％。",
	"敌人攻击吸血+90％。",
	"敌人攻击吸血+100％。",
	"敌人攻击吸血+110％。",
}

_tab_stringT[3064] = {"敌将吞噬",
	"敌方主将吞噬一名小兵，并将其当前生命值、攻击力的20％转给自己。",
	"敌方主将吞噬一名小兵，并将其当前生命值、攻击力的30％转给自己。",
	"敌方主将吞噬一名小兵，并将其当前生命值、攻击力的40％转给自己。",
	"敌方主将吞噬一名小兵，并将其当前生命值、攻击力的50％转给自己。",
	"敌方主将吞噬一名小兵，并将其当前生命值、攻击力的60％转给自己。",
	"敌方主将吞噬一名小兵，并将其当前生命值、攻击力的70％转给自己。",
	"敌方主将吞噬一名小兵，并将其当前生命值、攻击力的80％转给自己。",
	"敌方主将吞噬一名小兵，并将其当前生命值、攻击力的90％转给自己。",
	"敌方主将吞噬一名小兵，并将其当前生命值、攻击力的100％转给自己。",
	"敌方主将吞噬一名小兵，并将其当前生命值、攻击力的110％转给自己。",
}

_tab_stringT[3065] = {"敌将法术抗性",
	"敌方主将受到的法术伤害降低50％。",
	"敌方主将受到的法术伤害降低55％。",
	"敌方主将受到的法术伤害降低60％。",
	"敌方主将受到的法术伤害降低65％。",
	"敌方主将受到的法术伤害降低70％。",
	"敌方主将受到的法术伤害降低75％。",
	"敌方主将受到的法术伤害降低80％。",
	"敌方主将受到的法术伤害降低85％。",
	"敌方主将受到的法术伤害降低90％。",
	"敌方主将受到的法术伤害降低95％。",
}

_tab_stringT[3066] = {"敌人法术免疫",
	"敌人不会受到法术类型的伤害。",
}

_tab_stringT[3067] = {"敌将夺塔",
	"敌方主将随机将我方或友军的一个防御塔变成敌方塔。",
}

_tab_stringT[3068] = {"敌将沉默光环",
	"敌方主将周围的我方和友军单位无法使用战术技能、道具技能，无法自动释放技能。",
}

_tab_stringT[3069] = {"敌将秀逗变形术",
	"敌方主将随机将地图里的一个单位（无论敌我）变成小动物。被变身的单位不能攻击、释放技能，只能缓慢的移动，持续15秒。",
}

_tab_stringT[3070] = {"造塔价格增加",
	"造塔价格增加200金。",
	"造塔价格增加400金。",
	"造塔价格增加600金。",
	"造塔价格增加800金。",
	"造塔价格增加1000金。",
	"造塔价格增加1200金。",
	"造塔价格增加1400金。",
	"造塔价格增加1600金。",
	"造塔价格增加1800金。",
	"造塔价格增加2000金。",
}


--第四类
_tab_stringT[3071] = {"剧毒精研",
	"剧毒塔系毒箭初始附带减速5％，中毒时间+1秒。",
	"剧毒塔系毒箭初始附带减速10％，中毒时间+2秒。",
	"剧毒塔系毒箭初始附带减速15％，中毒时间+3秒。",
	"剧毒塔系毒箭初始附带减速20％，中毒时间+4秒。",
	"剧毒塔系毒箭初始附带减速25％，中毒时间+5秒。",
	"剧毒塔系毒箭初始附带减速30％，中毒时间+6秒。",
	"剧毒塔系毒箭初始附带减速35％，中毒时间+7秒。",
	"剧毒塔系毒箭初始附带减速40％，中毒时间+8秒。",
	"剧毒塔系毒箭初始附带减速45％，中毒时间+9秒。",
	"剧毒塔系毒箭初始附带减速50％，中毒时间+10秒。",
}

_tab_stringT[3072] = {"连射精研",
	"连弩塔系触发连射后，每发弩箭迅速从高空射向目标点，落地后对60范围内的敌人造成伤害。",
	"连弩塔系触发连射后，每发弩箭迅速从高空射向目标点，落地后对70范围内的敌人造成伤害。",
	"连弩塔系触发连射后，每发弩箭迅速从高空射向目标点，落地后对80范围内的敌人造成伤害。",
	"连弩塔系触发连射后，每发弩箭迅速从高空射向目标点，落地后对90范围内的敌人造成伤害。",
	"连弩塔系触发连射后，每发弩箭迅速从高空射向目标点，落地后对100范围内的敌人造成伤害。",
	"连弩塔系触发连射后，每发弩箭迅速从高空射向目标点，落地后对110范围内的敌人造成伤害。",
	"连弩塔系触发连射后，每发弩箭迅速从高空射向目标点，落地后对120范围内的敌人造成伤害。",
	"连弩塔系触发连射后，每发弩箭迅速从高空射向目标点，落地后对130范围内的敌人造成伤害。",
	"连弩塔系触发连射后，每发弩箭迅速从高空射向目标点，落地后对140范围内的敌人造成伤害。",
	"连弩塔系触发连射后，每发弩箭迅速从高空射向目标点，落地后对150范围内的敌人造成伤害。",
	"连弩塔系触发连射后，每发弩箭迅速从高空射向目标点，落地后对160范围内的敌人造成伤害。",
}

_tab_stringT[3073] = {"狙击精研",
	"狙击塔系每次攻击命中目标后，有5％的几率同时对目标周围50范围内的敌人造成伤害，并击退50码的距离。",
	"狙击塔系每次攻击命中目标后，有10％的几率同时对目标周围60范围内的敌人造成伤害，并击退50码的距离。",
	"狙击塔系每次攻击命中目标后，有15％的几率同时对目标周围70范围内的敌人造成伤害，并击退50码的距离。",
	"狙击塔系每次攻击命中目标后，有20％的几率同时对目标周围80范围内的敌人造成伤害，并击退50码的距离。",
	"狙击塔系每次攻击命中目标后，有25％的几率同时对目标周围90范围内的敌人造成伤害，并击退50码的距离。",
	"狙击塔系每次攻击命中目标后，有30％的几率同时对目标周围100范围内的敌人造成伤害，并击退50码的距离。",
	"狙击塔系每次攻击命中目标后，有35％的几率同时对目标周围110范围内的敌人造成伤害，并击退50码的距离。",
	"狙击塔系每次攻击命中目标后，有40％的几率同时对目标周围120范围内的敌人造成伤害，并击退50码的距离。",
	"狙击塔系每次攻击命中目标后，有45％的几率同时对目标周围130范围内的敌人造成伤害，并击退50码的距离。",
	"狙击塔系每次攻击命中目标后，有50％的几率同时对目标周围140范围内的敌人造成伤害，并击退50码的距离。",
}

_tab_stringT[3074] = {"火球精研",
	"火焰塔系每次攻击发射出火球数+1。",
	"火焰塔系每次攻击发射出火球数+2。",
	"火焰塔系每次攻击发射出火球数+3。",
	"火焰塔系每次攻击发射出火球数+4。",
	"火焰塔系每次攻击发射出火球数+5。",
	"火焰塔系每次攻击发射出火球数+6。",
	"火焰塔系每次攻击发射出火球数+7。",
	"火焰塔系每次攻击发射出火球数+8。",
	"火焰塔系每次攻击发射出火球数+9。",
	"火焰塔系每次攻击发射出火球数+10。",
}

_tab_stringT[3075] = {"寒冰爆精研",
	"寒冰塔系触发寒冰爆后，在目标点制造一片冰霜区域，对处在区域内的敌人每秒造成最大生命值1％的真实伤害，持续10秒。",
	"寒冰塔系触发寒冰爆后，在目标点制造一片冰霜区域，对处在区域内的敌人每秒造成最大生命值2％的真实伤害，持续10秒。",
	"寒冰塔系触发寒冰爆后，在目标点制造一片冰霜区域，对处在区域内的敌人每秒造成最大生命值3％的真实伤害，持续10秒。",
	"寒冰塔系触发寒冰爆后，在目标点制造一片冰霜区域，对处在区域内的敌人每秒造成最大生命值4％的真实伤害，持续10秒。",
	"寒冰塔系触发寒冰爆后，在目标点制造一片冰霜区域，对处在区域内的敌人每秒造成最大生命值5％的真实伤害，持续10秒。",
	"寒冰塔系触发寒冰爆后，在目标点制造一片冰霜区域，对处在区域内的敌人每秒造成最大生命值6％的真实伤害，持续10秒。",
	"寒冰塔系触发寒冰爆后，在目标点制造一片冰霜区域，对处在区域内的敌人每秒造成最大生命值7％的真实伤害，持续10秒。",
	"寒冰塔系触发寒冰爆后，在目标点制造一片冰霜区域，对处在区域内的敌人每秒造成最大生命值8％的真实伤害，持续10秒。",
	"寒冰塔系触发寒冰爆后，在目标点制造一片冰霜区域，对处在区域内的敌人每秒造成最大生命值9％的真实伤害，持续10秒。",
	"寒冰塔系触发寒冰爆后，在目标点制造一片冰霜区域，对处在区域内的敌人每秒造成最大生命值10％的真实伤害，持续10秒。",
}

_tab_stringT[3076] = {"弹射精研",
	"天雷塔系闪电链弹射次数+1，并且可电晕敌方主将。",
	"天雷塔系闪电链弹射次数+2，并且可电晕敌方主将。",
	"天雷塔系闪电链弹射次数+3，并且可电晕敌方主将。",
	"天雷塔系闪电链弹射次数+4，并且可电晕敌方主将。",
	"天雷塔系闪电链弹射次数+5，并且可电晕敌方主将。",
	"天雷塔系闪电链弹射次数+6，并且可电晕敌方主将。",
	"天雷塔系闪电链弹射次数+7，并且可电晕敌方主将。",
	"天雷塔系闪电链弹射次数+8，并且可电晕敌方主将。",
	"天雷塔系闪电链弹射次数+9，并且可电晕敌方主将。",
	"天雷塔系闪电链弹射次数+10，并且可电晕敌方主将。",
}

_tab_stringT[3077] = {"巨炮精研",
	"巨炮塔系巨炮附带造成穿刺，并初始有30％几率发射巨炮。",
	"巨炮塔系巨炮附带造成穿刺，并初始有35％几率发射巨炮。",
	"巨炮塔系巨炮附带造成穿刺，并初始有40％几率发射巨炮。",
	"巨炮塔系巨炮附带造成穿刺，并初始有45％几率发射巨炮。",
	"巨炮塔系巨炮附带造成穿刺，并初始有50％几率发射巨炮。",
	"巨炮塔系巨炮附带造成穿刺，并初始有55％几率发射巨炮。",
	"巨炮塔系巨炮附带造成穿刺，并初始有60％几率发射巨炮。",
	"巨炮塔系巨炮附带造成穿刺，并初始有65％几率发射巨炮。",
	"巨炮塔系巨炮附带造成穿刺，并初始有70％几率发射巨炮。",
	"巨炮塔系巨炮附带造成穿刺，并初始有75％几率发射巨炮。",
}

_tab_stringT[3078] = {"散弹精研",
	"轰天塔系射出散弹数+2，散弹飞行速度+25％。",
	"轰天塔系射出散弹数+4，散弹飞行速度+40％。",
	"轰天塔系射出散弹数+6，散弹飞行速度+55％。",
	"轰天塔系射出散弹数+8，散弹飞行速度+70％。",
	"轰天塔系射出散弹数+10，散弹飞行速度+85％。",
	"轰天塔系射出散弹数+12，散弹飞行速度+100％。",
	"轰天塔系射出散弹数+14，散弹飞行速度+115％。",
	"轰天塔系射出散弹数+16，散弹飞行速度+130％。",
	"轰天塔系射出散弹数+18，散弹飞行速度+145％。",
	"轰天塔系射出散弹数+20，散弹飞行速度+160％。",
}

_tab_stringT[3079] = {"碾压精研",
	"滚石塔系滚石滚动距离+40，击退敌人距离+20。",
	"滚石塔系滚石滚动距离+80，击退敌人距离+40。",
	"滚石塔系滚石滚动距离+120，击退敌人距离+60。",
	"滚石塔系滚石滚动距离+160，击退敌人距离+80。",
	"滚石塔系滚石滚动距离+200，击退敌人距离+100。",
	"滚石塔系滚石滚动距离+240，击退敌人距离+120。",
	"滚石塔系滚石滚动距离+280，击退敌人距离+140。",
	"滚石塔系滚石滚动距离+320，击退敌人距离+160。",
	"滚石塔系滚石滚动距离+360，击退敌人距离+180。",
	"滚石塔系滚石滚动距离+400，击退敌人距离+200。",
}

_tab_stringT[3080] = {"地刺精研",
	"地刺塔系攻击速度+100％，射程+120码，穿出的尖刺数量+3，并可攻击空中单位。",
}


_tab_stringT[3087] = {"火焰精研",
	"火焰塔系每次攻击命中目标后点燃目标，使其持续受到火焰灼烧。目标每秒受到10点真实伤害，持续10秒。",
	"火焰塔系每次攻击命中目标后点燃目标，使其持续受到火焰灼烧。目标每秒受到20点真实伤害，持续10秒。",
	"火焰塔系每次攻击命中目标后点燃目标，使其持续受到火焰灼烧。目标每秒受到30点真实伤害，持续10秒。",
	"火焰塔系每次攻击命中目标后点燃目标，使其持续受到火焰灼烧。目标每秒受到40点真实伤害，持续10秒。",
	"火焰塔系每次攻击命中目标后点燃目标，使其持续受到火焰灼烧。目标每秒受到50点真实伤害，持续10秒。",
	"火焰塔系每次攻击命中目标后点燃目标，使其持续受到火焰灼烧。目标每秒受到60点真实伤害，持续10秒。",
	"火焰塔系每次攻击命中目标后点燃目标，使其持续受到火焰灼烧。目标每秒受到70点真实伤害，持续10秒。",
	"火焰塔系每次攻击命中目标后点燃目标，使其持续受到火焰灼烧。目标每秒受到80点真实伤害，持续10秒。",
	"火焰塔系每次攻击命中目标后点燃目标，使其持续受到火焰灼烧。目标每秒受到90点真实伤害，持续10秒。",
	"火焰塔系每次攻击命中目标后点燃目标，使其持续受到火焰灼烧。目标每秒受到100点真实伤害，持续10秒。",
}

_tab_stringT[3088] = {"静电场精研",
	"天雷塔系每次攻击释放静电场，对自身周围的敌人造成目标当前生命值0.5％的法术伤害。",
	"天雷塔系每次攻击释放静电场，对自身周围的敌人造成目标当前生命值1％的法术伤害。",
	"天雷塔系每次攻击释放静电场，对自身周围的敌人造成目标当前生命值1.5％的法术伤害。",
	"天雷塔系每次攻击释放静电场，对自身周围的敌人造成目标当前生命值2％的法术伤害。",
	"天雷塔系每次攻击释放静电场，对自身周围的敌人造成目标当前生命值2.5％的法术伤害。",
	"天雷塔系每次攻击释放静电场，对自身周围的敌人造成目标当前生命值3％的法术伤害。",
	"天雷塔系每次攻击释放静电场，对自身周围的敌人造成目标当前生命值3.5％的法术伤害。",
	"天雷塔系每次攻击释放静电场，对自身周围的敌人造成目标当前生命值4％的法术伤害。",
	"天雷塔系每次攻击释放静电场，对自身周围的敌人造成目标当前生命值4.5％的法术伤害。",
	"天雷塔系每次攻击释放静电场，对自身周围的敌人造成目标当前生命值5％的法术伤害。",
}

_tab_stringT[3091] = {"击退精研",
	"滚石塔系滚石击退敌人的同时持续对其造成伤害。每击退敌人10码的距离，造成10点真实伤害。",
	"滚石塔系滚石击退敌人的同时持续对其造成伤害。每击退敌人10码的距离，造成20点真实伤害。",
	"滚石塔系滚石击退敌人的同时持续对其造成伤害。每击退敌人10码的距离，造成30点真实伤害。",
	"滚石塔系滚石击退敌人的同时持续对其造成伤害。每击退敌人10码的距离，造成40点真实伤害。",
	"滚石塔系滚石击退敌人的同时持续对其造成伤害。每击退敌人10码的距离，造成50点真实伤害。",
	"滚石塔系滚石击退敌人的同时持续对其造成伤害。每击退敌人10码的距离，造成60点真实伤害。",
	"滚石塔系滚石击退敌人的同时持续对其造成伤害。每击退敌人10码的距离，造成70点真实伤害。",
	"滚石塔系滚石击退敌人的同时持续对其造成伤害。每击退敌人10码的距离，造成80点真实伤害。",
	"滚石塔系滚石击退敌人的同时持续对其造成伤害。每击退敌人10码的距离，造成90点真实伤害。",
	"滚石塔系滚石击退敌人的同时持续对其造成伤害。每击退敌人10码的距离，造成100点真实伤害。",
}


_tab_stringT[3140] = {"我军攻击丢失",
	"我方和友军单位每次攻击有10％的几率无法命中目标。",
	"我方和友军单位每次攻击有20％的几率无法命中目标。",
	"我方和友军单位每次攻击有30％的几率无法命中目标。",
	"我方和友军单位每次攻击有40％的几率无法命中目标。",
	"我方和友军单位每次攻击有50％的几率无法命中目标。",
	"我方和友军单位每次攻击有60％的几率无法命中目标。",
	"我方和友军单位每次攻击有70％的几率无法命中目标。",
	"我方和友军单位每次攻击有80％的几率无法命中目标。",
	"我方和友军单位每次攻击有90％的几率无法命中目标。",
	"我方和友军单位每次攻击有100％的几率无法命中目标。",
}

_tab_stringT[3141] = {"敌将生命汲取",
	"敌方主将随机将我方或友军的一名英雄拉到身边，并每秒汲取100点生命，直至该英雄死亡，或两者距离大于400码结束施法。",
	"敌方主将随机将我方或友军的一名英雄拉到身边，并每秒汲取200点生命，直至该英雄死亡，或两者距离大于400码结束施法。",
	"敌方主将随机将我方或友军的一名英雄拉到身边，并每秒汲取300点生命，直至该英雄死亡，或两者距离大于400码结束施法。",
	"敌方主将随机将我方或友军的一名英雄拉到身边，并每秒汲取400点生命，直至该英雄死亡，或两者距离大于400码结束施法。",
	"敌方主将随机将我方或友军的一名英雄拉到身边，并每秒汲取500点生命，直至该英雄死亡，或两者距离大于400码结束施法。",
	"敌方主将随机将我方或友军的一名英雄拉到身边，并每秒汲取600点生命，直至该英雄死亡，或两者距离大于400码结束施法。",
	"敌方主将随机将我方或友军的一名英雄拉到身边，并每秒汲取700点生命，直至该英雄死亡，或两者距离大于400码结束施法。",
	"敌方主将随机将我方或友军的一名英雄拉到身边，并每秒汲取800点生命，直至该英雄死亡，或两者距离大于400码结束施法。",
	"敌方主将随机将我方或友军的一名英雄拉到身边，并每秒汲取900点生命，直至该英雄死亡，或两者距离大于400码结束施法。",
	"敌方主将随机将我方或友军的一名英雄拉到身边，并每秒汲取1000点生命，直至该英雄死亡，或两者距离大于400码结束施法。",
}

_tab_stringT[3142] = {"敌将自爆术",
	"敌方主将阵亡后原地爆炸，对周围生命值较低的单位和防御塔造成巨大伤害，对生命值较高的造成少量伤害。",
}

_tab_stringT[3143] = {"召唤祝福",
	"我方或友军每使用战术技能召唤一个单位，使敌人生命值-1％、攻击力-10％。",
}

_tab_stringT[3144] = {"敌人战意提升",
	"从第10波开始，敌人生命值+150％、攻击力+1500％。",
}

_tab_stringT[3145] = {"粮仓精研",
	"粮仓系拥有攻击能力，并且每次攻击获得1金。",
}

_tab_stringT[3146] = {"敌将携宝",
	"敌方主将阵亡后掉落一件宝物。",
}

_tab_stringT[3147] = {"夺宝赏金",
	"每使用一件宝物，在成功通关后可获得1游戏币奖励。",
}

_tab_stringT[3148] = {"敌将精神控制",
	"敌方主将阵亡后，将击杀该主将的单位或防御塔变成敌方势力，直至其死亡。",
}

_tab_stringT[3149] = {"敌将救赎",
	"敌方主将每次受到普通攻击时有5％的几率将伤害转化为对自己的治疗，并对攻击者造成等同的伤害。",
	"敌方主将每次受到普通攻击时有10％的几率将伤害转化为对自己的治疗，并对攻击者造成等同的伤害。",
	"敌方主将每次受到普通攻击时有15％的几率将伤害转化为对自己的治疗，并对攻击者造成等同的伤害。",
	"敌方主将每次受到普通攻击时有20％的几率将伤害转化为对自己的治疗，并对攻击者造成等同的伤害。",
	"敌方主将每次受到普通攻击时有25％的几率将伤害转化为对自己的治疗，并对攻击者造成等同的伤害。",
	"敌方主将每次受到普通攻击时有30％的几率将伤害转化为对自己的治疗，并对攻击者造成等同的伤害。",
	"敌方主将每次受到普通攻击时有35％的几率将伤害转化为对自己的治疗，并对攻击者造成等同的伤害。",
	"敌方主将每次受到普通攻击时有40％的几率将伤害转化为对自己的治疗，并对攻击者造成等同的伤害。",
	"敌方主将每次受到普通攻击时有45％的几率将伤害转化为对自己的治疗，并对攻击者造成等同的伤害。",
	"敌方主将每次受到普通攻击时有50％的几率将伤害转化为对自己的治疗，并对攻击者造成等同的伤害。",
}

_tab_stringT[3150] = {"敌将法术外壳",
	"敌方主将拥有一层坚硬的法术外壳，可吸收10000点法术伤害。如果法术外壳打碎，将在原地释放一团烈火持续燃烧地面30秒。",
}

_tab_stringT[3151] = {"敌将瘟疫",
	"敌方主将携带恐怖的瘟疫。",
}

_tab_stringT[3152] = {"擂鼓塔",
	"游戏局中可以直接建造1级擂鼓塔。",
	"游戏局中可以直接建造2级擂鼓塔。",
	"游戏局中可以直接建造3级擂鼓塔。",
	"游戏局中可以直接建造4级擂鼓塔。",
	"游戏局中可以直接建造5级擂鼓塔。",
	"游戏局中可以直接建造6级擂鼓塔。",
	"游戏局中可以直接建造7级擂鼓塔。",
	"游戏局中可以直接建造8级擂鼓塔。",
	"游戏局中可以直接建造9级擂鼓塔。",
	"游戏局中可以直接建造10级擂鼓塔。",
}

_tab_stringT[3153] = {"擂鼓精研",
	"擂鼓塔系拥有攻击能力，每次攻击向外发射一圈辐射波，对波及到的敌人造成巨大伤害。对飞行单位造成双倍伤害。",
}

_tab_stringT[3154] = {"敌人生命提升",
	"前6波敌人生命值-60％。从第7波开始，敌人生命值+150％",
}

_tab_stringT[3155] = {"激光塔",
	"游戏局中可以直接建造1级激光塔。",
	"游戏局中可以直接建造2级激光塔。",
	"游戏局中可以直接建造3级激光塔。",
	"游戏局中可以直接建造4级激光塔。",
	"游戏局中可以直接建造5级激光塔。",
	"游戏局中可以直接建造6级激光塔。",
	"游戏局中可以直接建造7级激光塔。",
	"游戏局中可以直接建造8级激光塔。",
	"游戏局中可以直接建造9级激光塔。",
	"游戏局中可以直接建造10级激光塔。",
}

_tab_stringT[3156] = {"导弹塔",
	"游戏局中可以直接建造1级导弹塔。",
	"游戏局中可以直接建造2级导弹塔。",
	"游戏局中可以直接建造3级导弹塔。",
	"游戏局中可以直接建造4级导弹塔。",
	"游戏局中可以直接建造5级导弹塔。",
	"游戏局中可以直接建造6级导弹塔。",
	"游戏局中可以直接建造7级导弹塔。",
	"游戏局中可以直接建造8级导弹塔。",
	"游戏局中可以直接建造9级导弹塔。",
	"游戏局中可以直接建造10级导弹塔。",
}

_tab_stringT[3157] = {"追踪导弹",
	"导弹塔系每次攻击从炮口发射1枚追踪导弹，导弹命中目标后在地面爆炸。（无法瞄准孔明灯）",
}

_tab_stringT[3158] = {"敌将反伤",
	"敌方主将受到远程单位普通攻击时，攻击者受到100％的反伤。",
}

_tab_stringT[3159] = {"圣诞树",
	"游戏局中可以直接建造1级圣诞树。",
	"游戏局中可以直接建造2级圣诞树。",
	"游戏局中可以直接建造3级圣诞树。",
	"游戏局中可以直接建造4级圣诞树。",
	"游戏局中可以直接建造5级圣诞树。",
	"游戏局中可以直接建造6级圣诞树。",
	"游戏局中可以直接建造7级圣诞树。",
	"游戏局中可以直接建造8级圣诞树。",
	"游戏局中可以直接建造9级圣诞树。",
	"游戏局中可以直接建造10级圣诞树。",
}

_tab_stringT[3160] = {"敌将变异瘟疫",
	"经历漫长的寒冬，敌方主将携带的瘟疫已发生变异。",
}

_tab_stringT[3161] = {"敌将复仇重生",
	"敌方主将阵亡后原地复活一次，并对击杀该主将的单位或防御塔施加诅咒。",
}

_tab_stringT[3162] = {"敌将不稳定电流",
	"敌方主将携带不稳定电流，随机电击周围的我方或友军单位。",
}

_tab_stringT[3163] = {"我方复活缩短",
	"我方和友军单位复活时间-2秒。",
	"我方和友军单位复活时间-4秒。",
	"我方和友军单位复活时间-6秒。",
	"我方和友军单位复活时间-8秒。",
	"我方和友军单位复活时间-10秒。",
	"我方和友军单位复活时间-12秒。",
	"我方和友军单位复活时间-14秒。",
	"我方和友军单位复活时间-16秒。",
	"我方和友军单位复活时间-18秒。",
	"我方和友军单位复活时间-20秒。",
}

_tab_stringT[3164] = {"敌将终极瘟疫",
	"敌方主将携带恐怖的瘟疫，在其周围的我方和友军单位将受到感染。瘟疫持续感染目标，并使目标死亡后发生变异。",
}

_tab_stringT[3165] = {"敌将灵魂互换",
	"敌方主将随机和我方或友军的一名英雄互换身体。",
}

_tab_stringT[3166] = {"风暴塔",
	"游戏局中可以直接建造1级风暴塔。",
	"游戏局中可以直接建造2级风暴塔。",
	"游戏局中可以直接建造3级风暴塔。",
	"游戏局中可以直接建造4级风暴塔。",
	"游戏局中可以直接建造5级风暴塔。",
	"游戏局中可以直接建造6级风暴塔。",
	"游戏局中可以直接建造7级风暴塔。",
	"游戏局中可以直接建造8级风暴塔。",
	"游戏局中可以直接建造9级风暴塔。",
	"游戏局中可以直接建造10级风暴塔。",
}

_tab_stringT[3167] = {"风暴精研",
	"风暴塔系每次攻击发射一道脉冲电弧，持续对多个目标造成伤害。",
}

_tab_stringT[3168] = {"倾城之恋",
	"我方或友军的两名异性英雄同时释放战术技能时，将爆发惊人的威力。",
}

_tab_stringT[3169] = {"我方冷却缩短",
	"我方和友军英雄战术技能冷却时间-2％。",
	"我方和友军英雄战术技能冷却时间-4％。",
	"我方和友军英雄战术技能冷却时间-6％。",
	"我方和友军英雄战术技能冷却时间-8％。",
	"我方和友军英雄战术技能冷却时间-10％。",
	"我方和友军英雄战术技能冷却时间-12％。",
	"我方和友军英雄战术技能冷却时间-14％。",
	"我方和友军英雄战术技能冷却时间-16％。",
	"我方和友军英雄战术技能冷却时间-18％。",
	"我方和友军英雄战术技能冷却时间-20％。",
}





























--铜雀台buff
--增益buff
_tab_stringT[3180] = {"青龙之圭",
	"我军攻击力+20％、射程+30％、物理防御+15点。",
}

_tab_stringT[3181] = {"白虎之琥",
	"我军攻速+20％、暴击几率+20％、暴击伤害+100％。",
}

_tab_stringT[3182] = {"朱雀之璋",
	"我军回血速度+20％、被动技能冷却-30％。",
}

_tab_stringT[3183] = {"玄武之璜",
	"我军生命值+20％、物理防御+25点、法术防御+25点。",
}

_tab_stringT[3184] = {"苍螭之璧",
	"敌人攻速-20％、法术防御-30点、被动技能冷却+30％。",
}

_tab_stringT[3185] = {"黄麟之琮",
	"敌人攻击力-20％、移动速度-30％、物理防御-30点。",
}




-----------------------------------
--减益buff
_tab_stringT[3190] = {"饕餮之嗜",
	"我军攻击吸血效果减半。",
}

_tab_stringT[3191] = {"穷奇之困",
	"我军移动速度-20％。",
}

_tab_stringT[3192] = {"梼杌之祸",
	"我军攻击力-30％、闪避-50％、被动技能冷却+50％",
}

_tab_stringT[3193] = {"混沌之眼",
	"敌人攻击力+25％、物理防御+30点、法术防御+30点",
}

_tab_stringT[3194] = {"螭吻之噬",
	"我军战术技能冷却+20％。",
}



_tab_stringT[3203] = {"后羿的祝福",
	"我方防御塔射程+30％。",
}

_tab_stringT[3210] = {"泥泞",
	"我方单位移动速度降低20％。",
	"我方单位移动速度降低30％。",
	"我方单位移动速度降低40％。",
}

_tab_stringT[3211] = {"炎热",
	"我方单位每秒减少20点生命值。",
	"我方单位每秒减少30点生命值。",
	"我方单位每秒减少40点生命值。",
}

_tab_stringT[3212] = {"重型敌人",
	"敌方单位移动速度降低30％，并增加100点物理防御和法术防御。",
	"敌方单位移动速度降低30％，并增加150点物理防御和法术防御。",
	"敌方单位移动速度降低30％，并增加200点物理防御和法术防御。",
}

_tab_stringT[3213] = {"狡兔",
	"敌方单位移动速度增加20％，并增加40％物理闪避。",
	"敌方单位移动速度增加20％，并增加60％物理闪避。",
	"敌方单位移动速度增加20％，并增加80％物理闪避。",
}



_tab_stringT[3220] = {"冷静",
	"我方单位减少20％的战术技能冷却和20％的被动技能冷却。",
}

_tab_stringT[3221] = {"重装",
	"我方单位增加50％生命上限和25点回血。",
}

_tab_stringT[3222] = {"重炮",
	"我方所有防御塔增加30％攻击力。",
}





----神像科技
_tab_stringT[3300] = {"袖珍箭塔",
	"在空地建造一个箭塔。",
}

_tab_stringT[3301] = {"袖珍法术塔",
	"在空地建造一个法术塔。",
}

_tab_stringT[3302] = {"袖珍炮塔",
	"在空地建造一个炮塔。",
}

_tab_stringT[3303] = {"袖珍特种塔",
	"在空地建造一个特种塔。",
}

_tab_stringT[3401] = {"蛮力",
	"我方英雄攻击力+30％。",
}

_tab_stringT[3402] = {"强攻",
	"我方英雄攻击力+3点。",
}

_tab_stringT[3403] = {"蛮力",
	"我方英雄攻击力+50％。",
}
_tab_stringT[3404] = {"疾风",
	"我方英雄攻击速度+36％。",
}

_tab_stringT[3405] = {"急速",
	"我方英雄攻击速度+6％。",
}

_tab_stringT[3406] = {"疾风",
	"我方英雄攻击速度+72％。",
}
_tab_stringT[3407] = {"鹰眼",
	"我方英雄射程+30码。",
}
_tab_stringT[3408] = {"鹰眼",
	"我方英雄射程+45码。",
}
_tab_stringT[3409] = {"强壮",
	"我方英雄最大生命值+30％。",
}

_tab_stringT[3410] = {"厚甲",
	"我方英雄物理防御+5点。",
}

_tab_stringT[3411] = {"强壮",
	"我方英雄最大生命值+50％。",
}

_tab_stringT[3412] = {"石肤",
	"我方英雄物理防御+30点。",
}

_tab_stringT[3413] = {"魔御",
	"我方英雄法术防御+5点。",
}

_tab_stringT[3414] = {"石肤",
	"我方英雄物理防御+50点。",
}

_tab_stringT[3415] = {"驱邪",
	"我方英雄法术防御+30点。",
}

_tab_stringT[3416] = {"疾行",
	"我方英雄移动速度+10点。",
}

_tab_stringT[3417] = {"驱邪",
	"我方英雄法术防御+50点。",
}

_tab_stringT[3418] = {"活力",
	"我方英雄回血速度+50点/秒。",
}

_tab_stringT[3419] = {"回元",
	"我方英雄回血速度+5点/秒。",
}

_tab_stringT[3420] = {"活力",
	"我方英雄回血速度+100点/秒。",
}

_tab_stringT[3421] = {"神行",
	"我方英雄移动速度+60点。",
}

_tab_stringT[3422] = {"会心",
	"我方英雄暴击几率+1％。",
}

_tab_stringT[3423] = {"神行",
	"我方英雄移动速度+90点。",
}

_tab_stringT[3424] = {"暴跳如雷",
	"我方英雄暴击几率+25％，暴击伤害+75％。",
}

_tab_stringT[3425] = {"凌波微步",
	"我方英雄物理闪避+32％，法术闪避+32％。",
}

_tab_stringT[3426] = {"贪狼",
	"我方英雄吸血提升20％（远程10％）。",
}

_tab_stringT[3427] = {"假寐",
	"我方英雄复活时间-15秒。",
}

_tab_stringT[3428] = {"毒攻",
	"剧毒塔攻击力提升12点。",
}

--[[
_tab_stringT[3429] = {"毒攻",
	"剧毒塔攻击力提升16点。",
}
]]

_tab_stringT[3430] = {"毒攻",
	"剧毒塔攻击力提升20点。",
}

_tab_stringT[3431] = {"强弩",
	"连弩塔攻击力提升12点。",
}

--[[
_tab_stringT[3432] = {"强弩",
	"连弩塔攻击力提升16点",
}
]]

_tab_stringT[3433] = {"强弩",
	"连弩塔攻击力提升20点。",
}

_tab_stringT[3434] = {"爆射",
	"狙击塔暴击率提高8％，暴击伤害提高30％。",
}

--[[
_tab_stringT[3435] = {"爆射",
	"狙击塔暴击率提高10％，暴击伤害提高40％。",
}
]]

_tab_stringT[3436] = {"爆射",
	"狙击塔暴击率提高12％，暴击伤害提高50％。",
}

_tab_stringT[3437] = {"振波",
	"擂鼓塔拥有攻击能力。",
}

_tab_stringT[3440] = {"狂轰",
	"轰天塔攻击力提升27点。",
}

--[[
_tab_stringT[3441] = {"狂轰",
	"轰天塔攻击力提升36点。",
}
]]

_tab_stringT[3442] = {"狂轰",
	"轰天塔攻击力提升45点。",
}

_tab_stringT[3443] = {"热浪",
	"火焰塔攻击力提升18点。",
}

--[[
_tab_stringT[3444] = {"热浪",
	"火焰塔攻击力提升24点。",
}
]]

_tab_stringT[3445] = {"热浪",
	"火焰塔攻击力提升30点。",
}

_tab_stringT[3446] = {"寒风",
	"寒冰塔射程提升30码。",
}

--[[
_tab_stringT[3447] = {"寒风",
	"寒冰塔射程提升40码。",
}
]]

_tab_stringT[3448] = {"寒风",
	"寒冰塔射程提升50码。",
}

_tab_stringT[3449] = {"丰收",
	"粮仓每秒额外产出1金。",
}

_tab_stringT[3450] = {"大丰收",
	"粮仓每秒额外产出2金。",
}

_tab_stringT[3451] = {"五谷丰登",
	"粮仓每秒额外产出5金。",
}

_tab_stringT[3452] = {"迅捷地刺",
	"地刺塔攻击速度+20％，每次攻击有10％的几率造成穿刺，眩晕时间+0.5秒。",
}

_tab_stringT[3453] = {"寒冰爆精研",
	"寒冰塔系触发寒冰爆后，制造一片冰霜区域，对区域内敌人每秒造成当前生命值1％的法术伤害，持续5秒。",
	"寒冰塔系触发寒冰爆后，制造一片冰霜区域，对区域内敌人每秒造成当前生命值2％的法术伤害，持续5秒。",
	"寒冰塔系触发寒冰爆后，制造一片冰霜区域，对区域内敌人每秒造成当前生命值3％的法术伤害，持续5秒。",
	"寒冰塔系触发寒冰爆后，制造一片冰霜区域，对区域内敌人每秒造成当前生命值4％的法术伤害，持续5秒。",
	"寒冰塔系触发寒冰爆后，制造一片冰霜区域，对区域内敌人每秒造成当前生命值5％的法术伤害，持续5秒。",
	"寒冰塔系触发寒冰爆后，制造一片冰霜区域，对区域内敌人每秒造成当前生命值6％的法术伤害，持续5秒。",
	"寒冰塔系触发寒冰爆后，制造一片冰霜区域，对区域内敌人每秒造成当前生命值7％的法术伤害，持续5秒。",
	"寒冰塔系触发寒冰爆后，制造一片冰霜区域，对区域内敌人每秒造成当前生命值8％的法术伤害，持续5秒。",
	"寒冰塔系触发寒冰爆后，制造一片冰霜区域，对区域内敌人每秒造成当前生命值9％的法术伤害，持续5秒。",
	"寒冰塔系触发寒冰爆后，制造一片冰霜区域，对区域内敌人每秒造成当前生命值10％的法术伤害，持续5秒。",
}

_tab_stringT[3454] = {"地刺",
	"[主动] 在目标点周围放置地刺，对经过的敌人造成伤害。",
}

_tab_stringT[3455] = {"捕兽夹",
	"[主动] 在目标点周围放置捕兽夹，捕获第一个经过的敌人后消失，被捕获的敌人眩晕5秒。",
}

_tab_stringT[3456] = {"第一桶金",
	"直接获得2500金。",
}

_tab_stringT[3457] = {"恭喜发财",
	"直接获得8000金。",
}

_tab_stringT[3458] = {"塔诀晶石-速",
	"[主动] 提升目标防御塔100％的攻击速度。",
}

_tab_stringT[3459] = {"塔诀晶石-攻",
	"[主动] 提升目标防御塔200％的攻击力。",
}

_tab_stringT[3460] = {"塔诀晶石-暴",
	"[主动] 增加目标防御塔30％的暴击几率。",
}

_tab_stringT[3461] = {"塔诀晶石-远",
	"[主动] 提升目标防御塔100％的射程。",
}

_tab_stringT[3462] = {"冰霜狙击",
	"狙击塔变为使用冰霜之箭进行攻击，攻击力提升150点，并使目标减速20％，持续3秒。",
}

_tab_stringT[3463] = {"火焰狙击",
	"狙击塔变为使用火焰之箭进行攻击，攻击力提升150点，并造成每秒30％的灼烧伤害，持续3秒。",
}

--[[
_tab_stringT[3464] = {"超视距",
	"狙击塔的射程提升50%。",
}
]]



_tab_stringT[3500] = {"投粮",
	"粮仓拥有攻击能力。",
}

_tab_stringT[3501] = {"召唤瓦力",
	"[主动] 召唤2个瓦力机器人为你战斗。瓦力存在180秒。",
}

_tab_stringT[3502] = {"激光炮",
	"[主动] 在目标点附近召唤激光炮，对1000范围内的敌人造成巨大伤害。",
}

_tab_stringT[3503] = {"导弹塔",
	"[主动] 在空地建造一个导弹塔。",
}

_tab_stringT[3504] = {"变身机器人",
	"[主动] 将自己变身为超级机器人，持续60秒。",
}

_tab_stringT[3505] = {"爆炸亡语",
	"我方英雄下次阵亡时，全体敌人自爆到空血。",
}

_tab_stringT[3506] = {"寒冰亡语",
	"我方英雄下次阵亡时，全体敌人冰冻30秒。",
}

_tab_stringT[3507] = {"冰霜亡语",
	"我方英雄下次阵亡时，全体敌人冰冻60秒。",
}

_tab_stringT[3508] = {"寒冰冻结",
	"[主动] 使目标点周围300范围内的敌人冰冻25秒。",
}

_tab_stringT[3509] = {"冰霜冻结",
	"[主动] 使目标点周围300范围内的敌人冰冻50秒。",
}

_tab_stringT[3510] = {"雁过拔毛",
	"消灭敌人额外获得20％金。",
}

_tab_stringT[3511] = {"精神控制",
	"[主动] 选择一名敌方小兵，将其变成我方单位。",
}

_tab_stringT[3512] = {"生命汲取",
	"[主动] 选择一名敌方英雄，每秒汲取1000点生命。持续30秒。",
}

_tab_stringT[3513] = {"天神下凡",
	"[主动] 使自身巨大化，大幅增强属性并具有远程攻击，同时免疫控制和减速效果，并且不会受到法术伤害。持续90秒。",
}

_tab_stringT[3514] = {"蜘蛛亡语",
	"我方英雄阵亡时，在原地召唤3个蜘蛛为你战斗。蜘蛛存在6秒。",
}

_tab_stringT[3515] = {"彩票特等奖",
	"直接获得16000金。",
}

_tab_stringT[3516] = {"复制敌将",
	"[主动] 选择一名敌方英雄，复制该英雄的镜像为你战斗。镜像存在120秒。",
}

_tab_stringT[3517] = {"光线塔",
	"[主动] 在空地建造一个光线塔。",
}

_tab_stringT[3518] = {"飞剑塔",
	"[主动] 在空地建造一个飞剑塔。",
}

_tab_stringT[3519] = {"兵营",
	"[主动] 在空地建造一个兵营。",
}

_tab_stringT[3520] = {"召唤章鱼怪",
	"[主动] 召唤4个章鱼怪为你战斗。章鱼怪存在240秒。",
}

_tab_stringT[3521] = {"箭塔+3",
	"获得3个箭塔。",
}

_tab_stringT[3522] = {"法术塔+3",
	"获得3个法术塔。",
}

_tab_stringT[3523] = {"炮塔+3",
	"获得3个炮塔。",
}

_tab_stringT[3524] = {"特种塔+3",
	"获得3个特种塔。",
}

_tab_stringT[3525] = {"基础塔+1",
	"获得1个箭塔、1个法术塔、1个炮塔、1个特种塔。",
}

_tab_stringT[3526] = {"空中枷锁",
	"[主动] 在目标点周围撒下天网，进入该区域内的空中单位将被捕获，并被拉到地面。",
}

_tab_stringT[3527] = {"自爆兵亡语",
	"我方英雄下次阵亡时，在原地召唤20个自爆兵。",
}

_tab_stringT[3528] = {"恐怖瘟疫",
	"[主动] 选择一名英雄，使其感染恐怖的瘟疫。",
}

_tab_stringT[3529] = {"群体传送",
	"[主动] 选择一个目标点，将自己和周围300范围内的全体单位传送到该处。冷却300秒。",
}

_tab_stringT[3530] = {"巨石强攻",
	"滚石塔每次攻击从炮口发出超级巨石。",
}

_tab_stringT[3531] = {"超视距精准攻击",
	"狙击塔命中几率+25％，射程为全地图。",
}

_tab_stringT[3532] = {"天上掉馅饼",
	"直接获得4000金。",
}

_tab_stringT[3533] = {"火龙卷",
	"火焰塔触发巨大火球后，在目标身边召唤一个火龙卷。火龙卷持续10秒。",
}

_tab_stringT[3534] = {"真实视域",
	"我军可以看到敌方隐身单位。",
}

_tab_stringT[3535] = {"沉默敌将",
	"[主动] 选择一名敌方英雄，使其无法释放技能，持续75秒。",
}

_tab_stringT[3536] = {"无敌斩",
	"[主动] 瞬移至目标地点，并连续发动50次攻击，每次对附近随机一个敌人造成攻击力300％的真实伤害。在此期间处于无敌状态。",
}

_tab_stringT[3537] = {"暴雨梨花针",
	"[主动] 瞬间从自己身上发射出大量银针。",
}

_tab_stringT[3538] = {"远雷",
	"天雷塔射程提升30码。",
}

_tab_stringT[3539] = {"远雷",
	"天雷塔射程提升60码。",
}

_tab_stringT[3540] = {"速炮",
	"巨炮塔攻速提升50％。",
}

_tab_stringT[3541] = {"速炮",
	"巨炮塔攻速提升100％。",
}

_tab_stringT[3542] = {"走石",
	"滚石塔射程提升60码。",
}

_tab_stringT[3543] = {"走石",
	"滚石塔射程提升120码。",
}

_tab_stringT[3544] = {"硕果累累",
	"粮仓每秒额外产出7金。",
}

_tab_stringT[3545] = {"召唤孔明灯",
	"[主动] 召唤6个孔明灯为你战斗。孔明灯只攻击空中单位，存在100秒。",
}

_tab_stringT[3546] = {"雷神之怒",
	"[主动] 在任意位置建造一个天雷装置。附近的敌人将遭受雷神之怒的攻击。",
}

_tab_stringT[3547] = {"怒吼",
	"[主动] 增加自身100点物防和法防，并嘲讽附近的敌人，强迫他们攻击自己，持续30秒。",
}

_tab_stringT[3548] = {"魅惑",
	"我方英雄周围300范围内的敌人每次攻击有35％的几率无法命中。",
}

_tab_stringT[3549] = {"感恩之心",
	"额外获得3个生命点数。",
}

_tab_stringT[3550] = {"雷劈",
	"[主动] 从空中引一道天雷，对自己和全体敌人造成最大生命值300％的真实伤害。",
}

_tab_stringT[3551] = {"瞬移术",
	"[主动] 瞬间移动到目标点。冷却10秒。",
}

_tab_stringT[3552] = {"困敌",
	"敌人移动速度-12％。",
}

_tab_stringT[3553] = {"连环飞刃",
	"我方远程英雄每次攻击向目标发出飞刃，飞刃在周围随机敌人之间弹射5次。",
}

_tab_stringT[3554] = {"灵魂链接",
	"[主动] 选择一名敌方英雄，使其承担你受到的全部伤害，持续20秒。",
}

_tab_stringT[3555] = {"伤害折射",
	"我方英雄受到的25％伤害（远程15％）平摊给300范围内的敌人。",
}

_tab_stringT[3556] = {"狗雨",
	"[主动] 朝目标点发射一波大范围的群狗，对300范围内的敌人造成大量伤害并混乱8秒。",
}

_tab_stringT[3557] = {"蟠龙之锤",
	"我方英雄每次攻击有25％的几率（远程15％）击晕目标2秒。",
}

_tab_stringT[3558] = {"强化视距",
	"狙击塔射程+200码。",
}

_tab_stringT[3559] = {"精准攻击",
	"狙击塔命中几率+25％。",
}

_tab_stringT[3560] = {"召唤迷你旱魃",
	"[主动] 召唤1个迷你旱魃为你战斗。迷你旱魃存在80秒。",
}

_tab_stringT[3561] = {"召唤蜉蝣飞机",
	"[主动] 召唤5个蜉蝣飞机为你战斗。蜉蝣飞机存在140秒。",
}

_tab_stringT[3562] = {"轮回之心",
	"[主动] 立即刷新我方英雄的战术技能和道具技能的冷却。",
}

_tab_stringT[3563] = {"葵花宝典",
	"[主动] 一本神秘的武功秘籍。修炼者必须为男性，并且要做出巨大牺牲。",
}

_tab_stringT[3565] = {"深刺",
	"地刺塔射程提升30码。",
}

_tab_stringT[3566] = {"深刺",
	"地刺塔射程提升60码。",
}

_tab_stringT[3567] = {"超远巨炮",
	"巨炮塔射程提升180码。",
}

_tab_stringT[3568] = {"霜之哀伤",
	"[主动] 在目标点放置一把霜之哀伤。霜之哀伤释放冰霜之箭攻击敌人。如果敌人被霜之哀伤杀死，会转化为友军，持续35秒。",
}

_tab_stringT[3569] = {"火之高兴",
	"[主动] 在目标点放置一把火之高兴。火之高兴随机释放各类火焰法术攻击敌人。",
}

_tab_stringT[3570] = {"风暴领域",
	"[主动] 在地图上放置3个风暴之眼，使之连成三角形区域。在此三角形区域内的我方单位属性大幅提升，敌人属性大幅衰减。",
}

_tab_stringT[3571] = {"南蛮入侵",
	"[主动] 在目标点召唤南蛮部队为你战斗。南蛮部队存在150秒。",
}

_tab_stringT[3572] = {"愤怒的乔治",
	"[主动] 对全体敌人造成当前金币数*1.5倍的法术伤害。",
}

_tab_stringT[3573] = {"佩奇的祝福",
	"[主动] 提升我方防御塔100％的射程，持续45秒。",
}

_tab_stringT[3574] = {"圣诞树",
	"[主动] 在空地建造一棵圣诞树。",
}

_tab_stringT[3575] = {"玉女心经",
	"[主动] 古墓派的至高绝学。相传只有冰清玉洁的少女才能练成。",
}

_tab_stringT[3577] = {"风暴塔",
	"[主动] 在空地建造一个风暴塔。",
}

_tab_stringT[3578] = {"召唤武侯之魂",
	"[主动] 召唤1个武侯之魂为你战斗。武侯之魂存在200秒。",
}

_tab_stringT[3579] = {"倾城之恋",
	"我方或友军的两名异性英雄同时释放战术技能时，将爆发惊人的威力。",
}

_tab_stringT[3580] = {"机枪塔",
	"[主动] 在空地建造一个机枪塔。",
}

_tab_stringT[3581] = {"九阴真经",
	"[主动] 一门至阴至柔的绝世武功，天下第一武学奇术。共分为上、下两册。",
}

_tab_stringT[3584] = {"九阴白骨爪",
	"[主动] 一门非常阴毒的武功，可千里之外取人首级，狠辣无比。修炼者必须为女性。",
}

_tab_stringT[3586] = {"扫射",
	"[主动] 增加自身100％的攻击速度，持续65秒。",
}

_tab_stringT[3587] = {"爆炎",
	"[主动] 朝目标点发射威力巨大的爆炎，对300范围内的敌人造成巨量伤害并点燃9秒。",
}

_tab_stringT[3588] = {"足智多谋",
	"我方英雄战术技能冷却时间-12％。"
}

_tab_stringT[3589] = {"慧心",
	"我方英雄被动技能冷却时间-12％。"
}

_tab_stringT[3590] = {"召唤死士",
	"每损失1个生命点数，在终点处召唤1个死士为你战斗。死士存在110秒。"
}

_tab_stringT[3591] = {"抗性皮肤",
	"大幅降低我方英雄受到控制的时间，大幅降低我方英雄受到负面属性的衰减。"
}

_tab_stringT[3592] = {"肉钩",
	"[主动] 朝目标点方向挥出一个肉钩，将第一个碰到的单位钩回你身边。如果钩到的是敌人，额外造成大量伤害并击晕5秒。",
}

_tab_stringT[3593] = {"扰咒术",
	"当一个敌方技能以我方英雄为目标时，召唤1个舞女并使其成为新的目标。舞女存在7秒。"
}

_tab_stringT[3594] = {"东方快车",
	"[主动] 从终点发出一辆火车开往起点，将沿途碰到的敌人推开并造成伤害。",
}

_tab_stringT[3595] = {"幻象",
	"[主动] 在目标点召唤1个你的分身。分身拥有你80％的属性，受到200％的伤害。分身存在75秒。",
}






--=============================================================================================--
--战术卡的来源

_tab_stringTF[1003] = {"练兵", "获取方式 \n成就奖励、关卡掉落、商城卡包",}
_tab_stringTF[1005] = {"桃园结义", "获取方式 \n成就奖励、关卡掉落、商城卡包",}
_tab_stringTF[1011] = {"剧毒塔", "获取方式 \n关卡掉落、商城卡包",}
_tab_stringTF[1012] = {"巨炮塔", "获取方式 \n关卡掉落、商城卡包",}
_tab_stringTF[1013] = {"火焰塔", "获取方式 \n成就奖励、关卡掉落、商城卡包",}
_tab_stringTF[1014] = {"连弩塔", "获取方式 \n关卡掉落、商城卡包",}
_tab_stringTF[1015] = {"寒冰塔", "获取方式 \n成就奖励、关卡掉落、商城卡包",}
_tab_stringTF[1016] = {"天雷塔", "获取方式 \n关卡掉落、商城卡包",}
_tab_stringTF[1017] = {"狙击塔", "获取方式 \n关卡掉落、商城卡包",}
_tab_stringTF[1018] = {"滚石塔", "获取方式 \n关卡掉落、商城卡包",}
_tab_stringTF[1019] = {"轰天塔", "获取方式 \n关卡掉落、商城卡包",}
_tab_stringTF[1020] = {"粮仓", "获取方式 \n关卡掉落",}
_tab_stringTF[1022] = {"擂鼓塔", "获取方式 \n关卡掉落",}
_tab_stringTF[1023] = {"地刺塔", "获取方式 \n成就奖励、关卡掉落",}
_tab_stringTF[1031] = {"破敌", "获取方式 \n成就奖励、关卡掉落、商城卡包",}
_tab_stringTF[1032] = {"弱敌", "获取方式 \n关卡掉落、商城卡包",}
_tab_stringTF[1033] = {"乱敌", "获取方式 \n关卡掉落、商城卡包",}
_tab_stringTF[1034] = {"箭塔精通", "获取方式 \n成就奖励、关卡掉落、商城卡包",}
_tab_stringTF[1035] = {"炮塔精通", "获取方式 \n成就奖励、关卡掉落、商城卡包",}
_tab_stringTF[1036] = {"术塔精通", "获取方式 \n成就奖励、关卡掉落、商城卡包",}
_tab_stringTF[1037] = {"富豪", "获取方式 \n关卡掉落、商城卡包",}
_tab_stringTF[1039] = {"妙手回春", "获取方式 \n成就奖励、关卡掉落、商城卡包",}
_tab_stringTF[1040] = {"固若金汤", "获取方式 \n关卡掉落、商城卡包",}
_tab_stringTF[1041] = {"塔基加固", "获取方式 \n关卡掉落、商城卡包",}
_tab_stringTF[1042] = {"王佐之才", "获取方式 \n推荐玩家奖励、活动奖励",}
_tab_stringTF[1043] = {"月华", "获取方式 \n活动奖励",}
_tab_stringTF[1044] = {"凤翼天翔", "获取方式 \n活动奖励",}
_tab_stringTF[1045] = {"破军", "获取方式 \nVIP5奖励",}
_tab_stringTF[1046] = {"摧城拔寨", "获取方式 \n关卡掉落、商城卡包",}
_tab_stringTF[1047] = {"强化毒素", "获取方式 \n关卡掉落、商城卡包",}
_tab_stringTF[1048] = {"致命连射", "获取方式 \n关卡掉落、商城卡包",}
_tab_stringTF[1049] = {"穿云一击", "获取方式 \n活动奖励",}
_tab_stringTF[1050] = {"天雷滚滚", "获取方式 \n活动奖励",}
_tab_stringTF[1051] = {"三味真火", "获取方式 \n关卡掉落、商城卡包",}
_tab_stringTF[1052] = {"冻土", "获取方式 \n关卡掉落、商城卡包",}
_tab_stringTF[1053] = {"弹道学", "获取方式 \n关卡掉落、商城卡包",}
_tab_stringTF[1054] = {"致命轰击", "获取方式 \n关卡掉落、商城卡包",}
_tab_stringTF[1055] = {"碾压", "获取方式 \n活动奖励",}
_tab_stringTF[1061] = {"地刺陷阱", "获取方式 \n活动奖励",}
_tab_stringTF[1066] = {"飞沙走石", "获取方式 \n关卡掉落、商城卡包",}
_tab_stringTF[1067] = {"火借风威", "获取方式 \n关卡掉落、商城卡包",}
_tab_stringTF[1068] = {"剧毒新星", "获取方式 \n关卡掉落、商城卡包",}
_tab_stringTF[1069] = {"亡命狙击", "获取方式 \n关卡掉落、商城卡包",}
_tab_stringTF[1070] = {"箭雨", "获取方式 \n商城卡包",}
_tab_stringTF[1071] = {"凛冬之寒", "获取方式 \n商城卡包",}
_tab_stringTF[1072] = {"复仇巨炮", "获取方式 \n商城卡包",}
_tab_stringTF[1073] = {"神火雷", "获取方式 \n活动奖励",}
_tab_stringTF[1074] = {"亡者天降", "获取方式 \n商城卡包",}
_tab_stringTF[1075] = {"孤狼", "获取方式 \n活动奖励",}
_tab_stringTF[1076] = {"逆转天机", "获取方式 \n活动奖励",}
_tab_stringTF[1077] = {"分秒必争", "获取方式 \n商城卡包",}
_tab_stringTF[1078] = {"先者之音", "获取方式 \n商城卡包",}
_tab_stringTF[1079] = {"月光", "获取方式 \n活动奖励",}

_tab_stringTF[1080] = {"苍穹之巅", "获取方式 \n公会获得",}
_tab_stringTF[1081] = {"北海之眼", "获取方式 \n公会获得",}
_tab_stringTF[1082] = {"冥火凤凰", "获取方式 \n公会获得",}

_tab_stringTF[1083] = {"炸弹人", "获取方式 \n活动奖励",}
_tab_stringTF[1084] = {"威震四方", "获取方式 \n关卡掉落、商城卡包",}
_tab_stringTF[1085] = {"修罗堡垒", "获取方式 \n关卡掉落、商城卡包",}
_tab_stringTF[1086] = {"紫气东来", "获取方式 \n关卡掉落、商城卡包",}
_tab_stringTF[1087] = {"砖瓦结构", "获取方式 \n关卡掉落、商城卡包",}
_tab_stringTF[1088] = {"矩阵冲车", "获取方式 \n公会获得",}
_tab_stringTF[1089] = {"流火强援", "获取方式 \n公会获得",}
_tab_stringTF[1090] = {"余温", "获取方式 \n活动奖励",}
_tab_stringTF[1091] = {"引力炮弹", "获取方式 \n活动奖励",}
_tab_stringTF[1092] = {"神火飞鸦", "获取方式 \n活动奖励",}
_tab_stringTF[1093] = {"急救应援", "获取方式 \n公会获得",}
_tab_stringTF[1094] = {"黑暗降至", "获取方式 \n公会获得",}
_tab_stringTF[1095] = {"野蛮阻挡", "获取方式 \n公会获得",}
_tab_stringTF[1096] = {"调息", "获取方式 \n关卡掉落",}
_tab_stringTF[1097] = {"复仇", "获取方式 \n关卡掉落",}
_tab_stringTF[1098] = {"断粮", "获取方式 \n关卡掉落",}
_tab_stringTF[1099] = {"召唤祝福", "获取方式 \n活动奖励",}

--_tab_stringCH 章节信息
_tab_stringCH[1] = {"黄巾起义", "第一章"}
_tab_stringCH[2] = {"群雄逐鹿", "第二章"}
_tab_stringCH[3] = {"乱世枭雄", "第三章"}
_tab_stringCH[4] = {"官渡之战", "第四章"}
_tab_stringCH[5] = {"称霸江东", "第五章"}
_tab_stringCH[6] = {"赤壁之战", "第六章"}
_tab_stringCH[7] = {"义争夷陵", "第七章"}

--塔的技能简介
_tab_stringSH[10002] = {"蛇毒", "使敌人中蛇毒行动减缓。",}
_tab_stringSH[10003] = {"蝎毒", "使敌人中蝎毒降低防御。",}
_tab_stringSH[10012] = {"火力提升", "增加攻击力和射程。",}
_tab_stringSH[10013] = {"巨炮", "每次攻击有几率发射巨炮。",}
_tab_stringSH[10023] = {"巨大火球", "可发射巨大火球。",}
_tab_stringSH[10025] = {"连珠火球", "增加火球数量。",}
_tab_stringSH[10032] = {"增强弩臂", "提高连射几率。",}
_tab_stringSH[10033] = {"强化弩匣", "增加连射弩箭数量和伤害。",}
_tab_stringSH[10042] = {"寒冰爆", "可发射巨大冰锥。",}
_tab_stringSH[10043] = {"冰冻", "每次攻击有几率冻结目标。",}
_tab_stringSH[10052] = {"雷电力量", "增加攻击力。",}
_tab_stringSH[10053] = {"闪电链", "每次攻击电弧弹射至周围敌人。",}
_tab_stringSH[10062] = {"远射", "增加攻击力和射程。",}
_tab_stringSH[10063] = {"穿心一击", "增加暴击并有几率秒杀敌人。",}
_tab_stringSH[10072] = {"击退", "滚石对敌人造成击退。",}
_tab_stringSH[10073] = {"蓄能", "增加滚石滚动距离。",}
_tab_stringSH[10082] = {"精准射击", "增加射程和精准度。",}
_tab_stringSH[10083] = {"强化散弹", "增加攻击力和散弹数量。",}
_tab_stringSH[10092] = {"赚钱", "每秒额外产出更多的金。",}
_tab_stringSH[10093] = {"强击光环", "提升周围防御塔攻击力。",}
_tab_stringSH[30008] = {"擂鼓振奋", "提升周围防御塔攻击速度。",}
_tab_stringSH[30009] = {"疗伤术", "治疗周围英雄。",}
_tab_stringSH[30010] = {"痛苦延伸", "增加尖刺数量和伤害。",}
_tab_stringSH[30011] = {"刺骨长钉", "向四周发散出大范围的穿刺。",}



--宝物表
_tab_stringTR[1] = {
	"孟德新编",
	"可解锁或升星宝物孟德新编。",
	
	--1星
	"使用曹操打竞技场，每胜利10次，曹操生命+2，攻击+1。（上限100次）",
	"使用曹操通关群英阁10+难度，每通关10次，曹操生命+2，法术防御+1。（上限100次）",
	"英雄令每增加1个魏国英雄，曹操攻击+1。",
	
	
	--2星
	"使用曹操打竞技场，每胜利10次，曹操生命+4，攻击+2。（上限100次）",
	"使用曹操通关群英阁10+难度，每通关10次，曹操生命+4，法术防御+2。（上限100次）",
	"英雄令每增加1个魏国英雄，曹操攻击+2。",
	
	
	--3星
	"使用曹操打竞技场，每胜利10次，曹操生命+6，攻击+3。（上限100次）",
	"使用曹操通关群英阁10+难度，每通关10次，曹操生命+6，法术防御+3。（上限100次）",
	"英雄令每增加1个魏国英雄，曹操攻击+3。",
	
	
	--4星
	"使用曹操打竞技场，每胜利10次，曹操生命+8，攻击+4。（上限100次）",
	"使用曹操通关群英阁10+难度，每通关10次，曹操生命+8，法术防御+4。（上限100次）",
	"英雄令每增加1个魏国英雄，曹操攻击+4。",
	
	
	--5星
	"使用曹操打竞技场，每胜利10次，曹操生命+10，攻击+5。（上限100次）",
	"使用曹操通关群英阁10+难度，每通关10次，曹操生命+10，法术防御+5。（上限100次）",
	"英雄令每增加1个魏国英雄，曹操攻击+5。",
	
}

_tab_stringTR[2] = {
	"英雄救美",
	"可解锁或升星宝物英雄救美。",
	
	--1星
	"通关铜雀台噩梦难度，每通关10次，全体女性英雄生命+2，物理防御+1。（上限100次）",
	"",
	"",
	
	
	--2星
	"通关铜雀台噩梦难度，每通关10次，全体女性英雄生命+4，物理防御+2。（上限100次）",
	"",
	"",
	
	
	--3星
	"通关铜雀台噩梦难度，每通关10次，全体女性英雄生命+6，物理防御+3。（上限100次）",
	"",
	"",
	
	
	--4星
	"通关铜雀台噩梦难度，每通关10次，全体女性英雄生命+8，物理防御+4。（上限100次）",
	"",
	"",
	
	
	--5星
	"通关铜雀台噩梦难度，每通关10次，全体女性英雄生命+10，物理防御+5。（上限100次）",
	"",
	"",
	
}

_tab_stringTR[3] = {
	"桃园香炉",
	"可解锁或升星宝物桃园香炉。",
	
	--1星
	"使用刘备、关羽、张飞通关无尽试炼， 每通关10次， 兄弟三人生命+2，攻击+1。（上限100次）",
	"使用刘备、关羽、张飞之中的任意二人，获得竞技场胜利，每胜利10次，兄弟三人生命+2，攻击+1。（上限100次）",
	"",
	
	
	--2星
	"使用刘备、关羽、张飞通关无尽试炼， 每通关10次， 兄弟三人生命+4，攻击+2。（上限100次）",
	"使用刘备、关羽、张飞之中的任意二人，获得竞技场胜利，每胜利10次，兄弟三人生命+4，攻击+2。（上限100次）",
	"",
	
	
	--3星
	"使用刘备、关羽、张飞通关无尽试炼， 每通关10次， 兄弟三人生命+6，攻击+3。（上限100次）",
	"使用刘备、关羽、张飞之中的任意二人，获得竞技场胜利，每胜利10次，兄弟三人生命+6，攻击+3。（上限100次）",
	"",
	
	
	--4星
	"使用刘备、关羽、张飞通关无尽试炼， 每通关10次， 兄弟三人生命+8，攻击+4。（上限100次）",
	"使用刘备、关羽、张飞之中的任意二人，获得竞技场胜利，每胜利10次，兄弟三人生命+8，攻击+4。（上限100次）",
	"",
	
	
	--5星
	"使用刘备、关羽、张飞通关无尽试炼， 每通关10次， 兄弟三人生命+10，攻击+5。（上限100次）",
	"使用刘备、关羽、张飞之中的任意二人，获得竞技场胜利，每胜利10次，兄弟三人生命+10，攻击+5。（上限100次）",
	"",
	
}

_tab_stringTR[4] = {
	"服部半藏面罩",
	"可解锁或升星宝物服部半藏面罩。",
	
	--1星
	"最多死亡一个英雄通关【铜雀台】的简单难度，每通关10次，全体青龙系英雄移动速度+2。（上限50次）",
	"",
	"",
	
	
	--2星
	"最多死亡一个英雄通关【铜雀台】的简单难度，每通关10次，全体青龙系英雄移动速度+4。（上限50次）",
	"",
	"",
	
	
	--3星
	"最多死亡一个英雄通关【铜雀台】的简单难度，每通关10次，全体青龙系英雄移动速度+6。（上限50次）",
	"",
	"",
	
	
	--4星
	"最多死亡一个英雄通关【铜雀台】的简单难度，每通关10次，全体青龙系英雄移动速度+8。（上限50次）",
	"",
	"",
	
	
	--5星
	"最多死亡一个英雄通关【铜雀台】的简单难度，每通关10次，全体青龙系英雄移动速度+10。（上限50次）",
	"",
	"",
	
}

_tab_stringTR[5] = {
	"神叼侠侣",
	"可解锁或升星宝物神叼侠侣。",
	
	--1星
	"使用诸葛亮、黄月英通关魔塔杀阵，每通关10次，二人生命+2。（上限100次）",
	"使用吕布、貂蝉通关无尽试炼，每通关10次，二人生命+2。（上限100次）",
	"使用周瑜、小乔打竞技场，每胜利10次，二人生命+2。（上限100次）",
	
	
	--2星
	"使用诸葛亮、黄月英通关魔塔杀阵，每通关10次，二人生命+4。（上限100次）",
	"使用吕布、貂蝉通关无尽试炼，每通关10次，二人生命+4。（上限100次）",
	"使用周瑜、小乔打竞技场，每胜利10次，二人生命+4。（上限100次）",
	
	
	--3星
	"使用诸葛亮、黄月英通关魔塔杀阵，每通关10次，二人生命+6。（上限100次）",
	"使用吕布、貂蝉通关无尽试炼，每通关10次，二人生命+6。（上限100次）",
	"使用周瑜、小乔打竞技场，每胜利10次，二人生命+6。（上限100次）",
	
	
	--4星
	"使用诸葛亮、黄月英通关魔塔杀阵，每通关10次，二人生命+8。（上限100次）",
	"使用吕布、貂蝉通关无尽试炼，每通关10次，二人生命+8。（上限100次）",
	"使用周瑜、小乔打竞技场，每胜利10次，二人生命+8。（上限100次）",
	
	
	--5星
	"使用诸葛亮、黄月英通关魔塔杀阵，每通关10次，二人生命+10。（上限100次）",
	"使用吕布、貂蝉通关无尽试炼，每通关10次，二人生命+10。（上限100次）",
	"使用周瑜、小乔打竞技场，每胜利10次，二人生命+10。（上限100次）",
	
}

_tab_stringTR[6] = {
	"拿破仑选集",
	"可解锁或升星宝物拿破仑选集。",
	
	--1星
	"通关群英阁10+难度并且通关时存在10个巨炮塔，并且抽到【巨炮精研】，每通关10次，巨炮塔攻击+1。（上限50次）",
	"",
	"",
	
	
	--2星
	"通关群英阁10+难度并且通关时存在10个巨炮塔，并且抽到【巨炮精研】，每通关10次，巨炮塔攻击+2。（上限50次）",
	"",
	"",
	
	
	--3星
	"通关群英阁10+难度并且通关时存在10个巨炮塔，并且抽到【巨炮精研】，每通关10次，巨炮塔攻击+3。（上限50次）",
	"",
	"",
	
	
	--4星
	"通关群英阁10+难度并且通关时存在10个巨炮塔，并且抽到【巨炮精研】，每通关10次，巨炮塔攻击+4。（上限50次）",
	"",
	"",
	
	
	--5星
	"通关群英阁10+难度并且通关时存在10个巨炮塔，并且抽到【巨炮精研】，每通关10次，巨炮塔攻击+5。（上限50次）",
	"",
	"",
	
}

_tab_stringTR[7] = {
	"兵临城下",
	"可解锁或升星宝物兵临城下。",
	
	--1星
	"通关群英阁5+难度并且通关时存在10个狙击塔，并且抽到【超视距精准攻击】，每通关10次，狙击塔攻速+1。（上限50次）",
	"",
	"",
	
	
	--2星
	"通关群英阁5+难度并且通关时存在10个狙击塔，并且抽到【超视距精准攻击】，每通关10次，狙击塔攻速+2。（上限50次）",
	"",
	"",
	
	
	--3星
	"通关群英阁5+难度并且通关时存在10个狙击塔，并且抽到【超视距精准攻击】，每通关10次，狙击塔攻速+3。（上限50次）",
	"",
	"",
	
	
	--4星
	"通关群英阁5+难度并且通关时存在10个狙击塔，并且抽到【超视距精准攻击】，每通关10次，狙击塔攻速+4。（上限50次）",
	"",
	"",
	
	
	--5星
	"通关群英阁5+难度并且通关时存在10个狙击塔，并且抽到【超视距精准攻击】，每通关10次，狙击塔攻速+5。（上限50次）",
	"",
	"",
	
}

_tab_stringTR[8] = {
	"龙凤灰袍",
	"可解锁或升星宝物龙凤灰袍。",
	
	--1星
	"使用诸葛亮、庞统通关魔塔杀阵，每通关10次， 2人生命+1。（上限100次）",
	"",
	"",
	
	
	--2星
	"使用诸葛亮、庞统通关魔塔杀阵，每通关10次， 2人生命+2。（上限100次）",
	"",
	"",
	
	
	--3星
	"使用诸葛亮、庞统通关魔塔杀阵，每通关10次， 2人生命+3。（上限100次）",
	"",
	"",
	
	
	--4星
	"使用诸葛亮、庞统通关魔塔杀阵，每通关10次， 2人生命+4。（上限100次）",
	"",
	"",
	
	
	--5星
	"使用诸葛亮、庞统通关魔塔杀阵，每通关10次， 2人生命+5。（上限100次）",
	"",
	"",
	
}

_tab_stringTR[9] = {
	"莫邪之血",
	"可解锁或升星宝物莫邪之血。",
	
	--1星
	"每100次锁孔洗炼神器，青龙系英雄攻击+1。（上限2000次）",
	"",
	"",
	
	
	--2星
	"每100次锁孔洗炼神器，青龙系英雄攻击+2。（上限2000次）",
	"",
	"",
	
	
	--3星
	"每100次锁孔洗炼神器，青龙系英雄攻击+3。（上限2000次）",
	"",
	"",
	
	
	--4星
	"每100次锁孔洗炼神器，青龙系英雄攻击+3，法术防御+1。（上限2000次）",
	"",
	"",
	
	
	--5星
	"每100次锁孔洗炼神器，青龙系英雄攻击+3，法术防御+2。（上限2000次）",
	"",
	"",
	
}

_tab_stringTR[10] = {
	"五虎上将令",
	"可解锁或升星宝物五虎上将令。",
	
	--1星
	"五虎上将攻击+2。",
	"使用五虎上将通关铜雀台噩梦难度，每通关10次，五虎英雄生命+2。（上限100次）",
	"",
	
	
	--2星
	"五虎上将攻击+4。",
	"使用五虎上将通关铜雀台噩梦难度，每通关10次，五虎英雄生命+4。（上限100次）",
	"",
	
	
	--3星
	"五虎上将攻击+6。",
	"使用五虎上将通关铜雀台噩梦难度，每通关10次，五虎英雄生命+6。（上限100次）",
	"",
	
	
	--4星
	"五虎上将攻击+8。",
	"使用五虎上将通关铜雀台噩梦难度，每通关10次，五虎英雄生命+8。（上限100次）",
	"",
	
	
	--5星
	"五虎上将攻击+10。",
	"使用五虎上将通关铜雀台噩梦难度，每通关10次，五虎英雄生命+10。（上限100次）",
	"",
	
}

_tab_stringTR[11] = {
	"建筑师证书",
	"可解锁或升星宝物建筑师证书。",
	
	--1星
	"每升满一个防御塔到5星，擂鼓塔建造价格-1，地刺塔射程+1。",
	"",
	"",
	
	
	--2星
	"每升满一个防御塔到5星，擂鼓塔建造价格-2，地刺塔射程+2。",
	"",
	"",
	
	
	--3星
	"每升满一个防御塔到5星，擂鼓塔建造价格-3，地刺塔射程+3。",
	"",
	"",
	
	
	--4星
	"每升满一个防御塔到5星，擂鼓塔建造价格-4，地刺塔射程+4。",
	"",
	"",
	
	
	--5星
	"每升满一个防御塔到5星，擂鼓塔建造价格-5，地刺塔射程+5。",
	"",
	"",
	
}

_tab_stringTR[12] = {
	"战功金腰带",
	"可解锁或升星宝物战功金腰带。",
	
	--1星
	"每开启10个战功锦囊，白虎系英雄生命+2。（上限100次）",
	"",
	"",
	
	
	--2星
	"每开启10个战功锦囊，白虎系英雄生命+4。（上限100次）",
	"",
	"",
	
	
	--3星
	"每开启10个战功锦囊，白虎系英雄生命+6。（上限100次）",
	"",
	"",
	
	
	--4星
	"每开启10个战功锦囊，白虎系英雄生命+8。（上限100次）",
	"",
	"",
	
	
	--5星
	"每开启10个战功锦囊，白虎系英雄生命+10。（上限100次）",
	"",
	"",
	
}

_tab_stringTR[13] = {
	"战斗天使",
	"可解锁或升星宝物战斗天使。",
	
	--1星
	"英雄令每增加1个女性英雄，全体女性英雄攻击+3。",
	"",
	"",
	
	
	--2星
	"英雄令每增加1个女性英雄，全体女性英雄攻击+5。",
	"",
	"",
	
	
	--3星
	"英雄令每增加1个女性英雄，全体女性英雄攻击+7。",
	"",
	"",
	
	
	--4星
	"英雄令每增加1个女性英雄，全体女性英雄攻击+10。",
	"",
	"",
	
	
	--5星
	"英雄令每增加1个女性英雄，全体女性英雄攻击+15。",
	"",
	"",
	
}

_tab_stringTR[14] = {
	"铁人之心",
	"可解锁或升星宝物铁人之心。",
	
	--1星
	"通关群英阁或人族无敌，累计获得紫卡数量每达到10次，天雷塔攻击+1。（上限200次）",
	"",
	"",
	
	
	--2星
	"通关群英阁或人族无敌，累计获得紫卡数量每达到10次，天雷塔攻击+2。（上限200次）",
	"",
	"",
	
	
	--3星
	"通关群英阁或人族无敌，累计获得紫卡数量每达到10次，天雷塔攻击+3。（上限200次）",
	"",
	"",
	
	
	--4星
	"通关群英阁或人族无敌，累计获得紫卡数量每达到10次，天雷塔攻击+4。（上限200次）",
	"",
	"",
	
	
	--5星
	"通关群英阁或人族无敌，累计获得紫卡数量每达到10次，天雷塔攻击+5。（上限200次）",
	"",
	"",
	
}

_tab_stringTR[15] = {
	"神行鞭",
	"可解锁或升星宝物神行鞭。",
	
	--1星
	"每获得一件四孔坐骑，全体英雄移动速度+1。（上限10次）",
	"玄武系英雄移动速度+1。",
	"",
	
	
	--2星
	"每获得一件四孔坐骑，全体英雄移动速度+1。（上限20次）",
	"玄武系英雄移动速度+2。",
	"",
	
	
	--3星
	"每获得一件四孔坐骑，全体英雄移动速度+1。（上限30次）",
	"玄武系英雄移动速度+3。",
	"",
	
	
	--4星
	"每获得一件四孔坐骑，全体英雄移动速度+1。（上限40次）",
	"玄武系英雄移动速度+4。",
	"",
	
	
	--5星
	"每获得一件四孔坐骑，全体英雄移动速度+1。（上限50次）",
	"玄武系英雄移动速度+5。",
	"",
	
}

_tab_stringTR[16] = {
	"朱雀信条",
	"可解锁或升星宝物朱雀信条。",
	
	--1星
	"每解锁一个新战役章节，朱雀系英雄生命+3。",
	"",
	"",
	
	
	--2星
	"每解锁一个新战役章节，朱雀系英雄生命+5。",
	"",
	"",
	
	
	--3星
	"每解锁一个新战役章节，朱雀系英雄生命+7。",
	"",
	"",
	
	
	--4星
	"每解锁一个新战役章节，朱雀系英雄生命+10。",
	"",
	"",
	
	
	--5星
	"每解锁一个新战役章节，朱雀系英雄生命+15。",
	"",
	"",
	
}

_tab_stringTR[17] = {
	"主公玉玺",
	"可解锁或升星宝物主公玉玺。",
	
	--1星
	"刘备、曹操、孙权的攻击+1。",
	"每拥有一个15级英雄， 刘备、曹操、孙权的生命+2。",
	"",
	
	
	--2星
	"刘备、曹操、孙权的攻击+2。",
	"每拥有一个15级英雄， 刘备、曹操、孙权的生命+3。",
	"",
	
	
	--3星
	"刘备、曹操、孙权的攻击+3。",
	"每拥有一个15级英雄， 刘备、曹操、孙权的生命+5。",
	"",
	
	
	--4星
	"刘备、曹操、孙权的攻击+4。",
	"每拥有一个15级英雄， 刘备、曹操、孙权的生命+6。",
	"",
	
	
	--5星
	"刘备、曹操、孙权的攻击+5。",
	"每拥有一个15级英雄， 刘备、曹操、孙权的生命+7。",
	"",
	
}

_tab_stringTR[18] = {
	"屯田令牌",
	"可解锁或升星宝物屯田令牌。",
	
	--1星
	"每消耗1000游戏币，每波开始时额外获得10金。（上限10000游戏币）",
	"粮仓每秒产出金钱+1，强击光环效果+1％。",
	"",
	
	
	--2星
	"每消耗1000游戏币，每波开始时额外获得15金。（上限10000游戏币）",
	"粮仓每秒产出金钱+1，强击光环效果+2％。",
	"",
	
	
	--3星
	"每消耗1000游戏币，每波开始时额外获得20金。（上限10000游戏币）",
	"粮仓每秒产出金钱+1，强击光环效果+3％。",
	"",
	
	
	--4星
	"每消耗1000游戏币，每波开始时额外获得25金。（上限10000游戏币）",
	"粮仓每秒产出金钱+1，强击光环效果+4％。",
	"",
	
	
	--5星
	"每消耗1000游戏币，每波开始时额外获得30金。（上限10000游戏币）",
	"粮仓每秒产出金钱+2，强击光环效果+5％。",
	"",
	
}

_tab_stringTR[19] = {
	"合金钻头",
	"可解锁或升星宝物合金钻头。",
	
	--1星
	"装备每打孔30次，魏国英雄攻速+0.5％。（上限150次）",
	"",
	"",
	
	
	--2星
	"装备每打孔30次，魏国英雄攻速+1％。（上限150次）",
	"",
	"",
	
	
	--3星
	"装备每打孔30次，魏国英雄攻速+1.5％。（上限150次）",
	"",
	"",
	
	
	--4星
	"装备每打孔30次，魏国英雄攻速+2％。（上限150次）",
	"",
	"",
	
	
	--5星
	"装备每打孔30次，魏国英雄攻速+2.5％。（上限150次）",
	"",
	"",
	
}

_tab_stringTR[20] = {
	"干将之鼎",
	"可解锁或升星宝物干将之鼎。",
	
	--1星
	"献祭出三孔及其以上的神器，每献祭5次，朱雀系英雄攻击+1。（上限30次）",
	"",
	"",
	
	
	--2星
	"献祭出三孔及其以上的神器，每献祭5次，朱雀系英雄攻击+2。（上限30次）",
	"",
	"",
	
	
	--3星
	"献祭出三孔及其以上的神器，每献祭5次，朱雀系英雄攻击+3。（上限30次）",
	"",
	"",
	
	
	--4星
	"献祭出三孔及其以上的神器，每献祭5次，朱雀系英雄攻击+4。（上限30次）",
	"",
	"",
	
	
	--5星
	"献祭出三孔及其以上的神器，每献祭5次，朱雀系英雄攻击+5。（上限30次）",
	"",
	"",
	
}

_tab_stringTR[21] = {
	"玄武水晶",
	"可解锁或升星宝物玄武水晶。",
	
	--1星
	"通关群英阁5+难度并且全清一波乌龟怪，每通关10次，玄武系英雄攻击+1。（上限50次）",
	"",
	"",
	
	
	--2星
	"通关群英阁5+难度并且全清一波乌龟怪，每通关10次，玄武系英雄攻击+2。（上限50次）",
	"",
	"",
	
	
	--3星
	"通关群英阁5+难度并且全清一波乌龟怪，每通关10次，玄武系英雄攻击+3。（上限50次）",
	"",
	"",
	
	
	--4星
	"通关群英阁5+难度并且全清一波乌龟怪，每通关10次，玄武系英雄攻击+4。（上限50次）",
	"",
	"",
	
	
	--5星
	"通关群英阁5+难度并且全清一波乌龟怪，每通关10次，玄武系英雄攻击+5。（上限50次）",
	"",
	"",
	
}

_tab_stringTR[22] = {
	"琉璃簪",
	"可解锁或升星宝物琉璃簪。",
	
	--1星
	"寒冰塔射程+10，建造价格-10。",
	"每在世界聊天频道里抢到20次红包，寒冰塔射程+1。（上限200次）",
	"",
	
	
	--2星
	"寒冰塔射程+10，建造价格-10。",
	"每在世界聊天频道里抢到20次红包，寒冰塔射程+2。（上限200次）",
	"",
	
	
	--3星
	"寒冰塔射程+10，建造价格-10。",
	"每在世界聊天频道里抢到20次红包，寒冰塔射程+3。（上限200次）",
	"",
	
	
	--4星
	"寒冰塔射程+10，建造价格-10。",
	"每在世界聊天频道里抢到20次红包，寒冰塔射程+4。（上限200次）",
	"",
	
	
	--5星
	"寒冰塔射程+10，建造价格-10。",
	"每在世界聊天频道里抢到20次红包，寒冰塔射程+4、攻击+1。（上限200次）",
	"",
	
}

_tab_stringTR[23] = {
	"剑仙长明灯",
	"可解锁或升星宝物剑仙长明灯。",
	
	--1星
	"前往【游戏讨论】，获得10神器晶石奖励。每天一次。",
	"通关守卫剑阁，每通关20次，火焰塔射程+1。（上限200次）",
	"",
	
	
	--2星
	"前往【游戏讨论】，获得10神器晶石奖励。每天一次。",
	"通关守卫剑阁，每通关20次，火焰塔射程+2。（上限200次）",
	"",
	
	
	--3星
	"前往【游戏讨论】，获得10神器晶石奖励。每天一次。",
	"通关守卫剑阁，每通关20次，火焰塔射程+3。（上限200次）",
	"",
	
	
	--4星
	"前往【游戏讨论】，获得10神器晶石奖励。每天一次。",
	"通关守卫剑阁，每通关20次，火焰塔射程+4。（上限200次）",
	"",
	
	
	--5星
	"前往【游戏讨论】，获得10神器晶石奖励。每天一次。",
	"通关守卫剑阁，每通关20次，火焰塔射程+4、攻击+1。（上限200次）",
	"",
	
}




--=============================================================================================--

--_tab_stringI[ ] = {"name","","intro"}



_tab_stringI[9] = {"100积分","","增加100积分"}
_tab_stringI[11] = {"积分合成卡片"}
_tab_stringI[12] = {"红装祭坛"}
_tab_stringI[14] = {"付费锁孔"}
_tab_stringI[15] = {"40积分","","增加40积分"}
_tab_stringI[16] = {"60积分","","增加60积分"}
_tab_stringI[17] = {"80积分","","增加80积分"}
_tab_stringI[18] = {"100积分","","增加100积分"}
_tab_stringI[19] = {"400积分","","增加400积分"}
_tab_stringI[20] = {"500积分","","增加500积分"}
_tab_stringI[21] = {"600积分","","增加600积分"}
_tab_stringI[22] = {"800积分","","增加800积分"}
_tab_stringI[23] = {"2000积分","","增加2000积分"}
_tab_stringI[24] = {"3000积分","","增加3000积分"}
_tab_stringI[25] = {"积分","","获得一定数量的积分"}
_tab_stringI[26] = {"兵符","","获得一定数量的兵符"}
_tab_stringI[27] = {"游戏币","","获得一定数量的游戏币"}
_tab_stringI[28] = {"九五至尊","","获得专属称号【九五至尊】1个月使用权"}
_tab_stringI[29] = {"皮革","","用来锻造装备的初级材料"}
_tab_stringI[30] = {"玄铁","","用来锻造装备的高级材料"}
_tab_stringI[31] = {"炎晶","","用来锻造装备的高级材料"}
_tab_stringI[32] = {"天梯分","","额外增加一定的天梯分数（次日生效）"}

--部分商品列表
_tab_stringI[50] = {"吕布传地图包"}
_tab_stringI[51] = {"战神崛起地图包"}
_tab_stringI[52] = {"官渡地图包"}
_tab_stringI[56] = {"赤壁地图包"}

_tab_stringI[1995] = {"正在获取...", "", "该商品正在获取中。"}
_tab_stringI[1996] = {"正在获取...", "", "该商品正在获取中。"}
_tab_stringI[1997] = {"正在获取...", "", "该商品正在获取中。"}
_tab_stringI[1998] = {"正在获取...", "", "该商品正在获取中。"}
_tab_stringI[1999] = {"正在获取...", "", "该商品正在获取中。"}
_tab_stringI[2000] = {"正在获取...", "", "该商品正在获取中。"}

--战术技能卡材料开始
_tab_stringI[6000] = {"重转资源宝箱"}
_tab_stringI[6001] = {"付费重转黄金宝箱"}
_tab_stringI[6002] = {"免费重转黄金宝箱"}
_tab_stringI[6003] = {"合成卡牌付费1/3"}
_tab_stringI[6004] = {"合成卡牌付费2/3"}
_tab_stringI[6005] = {"合成卡牌付费2/5"}
_tab_stringI[6006] = {"合成卡牌付费3/5"}
_tab_stringI[6007] = {"合成卡牌付费4/5"}
_tab_stringI[6008] = {"合成卡牌付费5/10"}
_tab_stringI[6009] = {"合成卡牌付费6/10"}
_tab_stringI[6010] = {"合成卡牌付费7/10"}
_tab_stringI[6011] = {"合成卡牌付费8/10"}
_tab_stringI[6012] = {"合成卡牌付费9/10"}

---礼包附赠道具
_tab_stringI[8200] = {"校尉重铠","你的武将@visitor@拾取了一件校尉重铠。","使用整块的铁片缝合的铠甲，为校尉级的军官所穿。","获取方式 \n开启神器锦囊"}
_tab_stringI[8201] = {"炎雀指环","你的武将@visitor@拾取了一颗炎雀指环。","凝聚着炎雀火焰之力的指环。","获取方式 \n开启神器锦囊"}
_tab_stringI[8202] = {"贪狼","你的武将@visitor@拾取了一把贪狼。","火遇贪狼照命宫，封侯食禄是英雄。","获取方式 \n开启神器锦囊"}
_tab_stringI[8203] = {"神鹰令","你的武将@visitor@拾取了一枚神鹰令。","用来调集皇室特种部队:【鹰卫】的高级令牌。","获取方式 \n开启神器锦囊"}
_tab_stringI[8204] = {"绝影","你的武将@visitor@获得了一匹绝影。","奔跑的速度极快，连影子都追不上，因而得名。","获取方式 \n开启神器锦囊"}


_tab_stringI[8996] = {"被封印的陶晶之剑","你的武将@visitor@拾取了一把陶晶之剑。","被封印的陶晶之剑，相比解封的没有增加行动力....."}
_tab_stringI[8997] = {"无名战甲","你的武将@visitor@拾取了一把无名战甲。","测试用，很强的防御能力，但会丧失进攻能力。"}
_tab_stringI[8998] = {"陶晶之剑","你的武将@visitor@拾取了一把陶晶之剑。","传说中陶晶用上古秘石所铸，威力如何，只有持剑者自己知晓....."}
_tab_stringI[8999] = {"无名","你的武将@visitor@拾取了一把无名。","此剑无名，由泰阿、巨阙、鱼肠三剑熔铸而成，威力足可匹敌任何神兵利器。"}
_tab_string["chest"] = "宝箱"
_tab_string["chest_silver"] = "白银宝箱(打折中)"
_tab_string["chest_gold"] = "黄金宝箱(打折中)"
_tab_stringI[9004] = {"青铜宝箱","你的武将@visitor@得到了一个青铜宝箱。","开启后，可以随机获得1~10级的装备，有一定几率获得黄色品质装备。"}
_tab_stringI[9005] = {"白银宝箱","你的武将@visitor@得到了一个白银宝箱。","开启后，可以随机获得1~10级的装备，有较高几率获得黄金装备，有较低几率获得红色神器装备。"}
_tab_stringI[9006] = {"黄金宝箱","你的武将@visitor@得到了一个黄金宝箱。","开启后，可以随机获得1~10级的装备，有极高几率获得黄金装备，有一定几率获得稀有红色神器装备。\n【可重转】"}
_tab_stringI[9007] = {"皮革  × 100","!!","用来锻造装备的低级材料。"}
_tab_stringI[9008] = {"玄铁  × 20","!!","用来锻造装备的高级材料。"}
_tab_stringI[9009] = {"福包","","可开出积分、游戏币、神器晶石、兵种卡碎片、英雄将魂、战术卡碎片、献祭之石。"}
_tab_stringI[9010] = {"夏侯惇·令","!!","获得夏侯惇的英雄令"}
_tab_stringI[9011] = {"水晶  × 5","!!","雇佣圣兽时所需的资源。【只限当前关卡内使用】"}

_tab_stringI[9012] = {"张辽·令","!!","获得张辽的英雄令"}
_tab_stringI[9013] = {"郭嘉·令","!!","获得郭嘉的英雄令"}
_tab_stringI[9018] = {"太史慈·令","!!","获得太史慈的英雄令"}
_tab_stringI[9026] = {"许褚·令","!!","获得许褚的英雄令"}
_tab_stringI[9027] = {"典韦·令","!!","获得典韦的英雄令"}
_tab_stringI[9028] = {"徐庶·令","!!","获得徐庶的英雄令"}
_tab_stringI[9029] = {"诸葛亮·令","!!","获得诸葛亮的英雄令"}

_tab_stringI[9030] = {"孙权·令","!!","获得孙权的英雄令"}
_tab_stringI[9031] = {"庞统·令","!!","获得庞统的英雄令"}
_tab_stringI[9034] = {"荀彧·令","!!","获得荀彧的英雄令"}
_tab_stringI[9035] = {"贾诩·令","!!","获得贾诩的英雄令"}
_tab_stringI[9036] = {"司马懿·令","!!","获得司马懿的英雄令"}
_tab_stringI[9037] = {"陆逊·令","!!","获得陆逊的英雄令"}

_tab_stringI[9100] = {"积分宝箱","你的武将@visitor@得到了一个积分宝箱。","开启后，可以随机获得 \n100 - 800的游戏积分。"}
_tab_stringI[9101] = {"普通卡包","你的武将@visitor@得到了一个普通战术卡。", "可随机获得1张战术卡或塔。", ""}
_tab_stringI[9102] = {"高级卡包","你的武将@visitor@得到了一个高级战术卡。", "可随机获得3张战术卡或塔。\n【有几率获得稀有战术卡】", ""}
_tab_stringI[9108] = {"VIP7卡包","你的武将@visitor@得到了一个VIP7战术卡。", "开启后, 可以从五张未知的战术卡中选择三张。\n【有很高的几率获得稀有战术卡】","请选择 3 张卡片"}


_tab_stringI[9103] = {"新手礼包","包含: 偃月刀，赤铜重铠，妙手回春卡碎片20个(我方英雄复活时间-4秒)","",}
_tab_stringI[9105] = {"风雷惊天包","包含: 天雷塔碎片60个，术塔精通碎片60个，破敌碎片60个","",}
_tab_stringI[9106] = {"新手上路包","包含: 木棉布衣(解锁1孔)1个, 乌拉草鞋(解锁1孔)1个, 剧毒塔1个","",}
_tab_stringI[9200] = {"管亥的木箱","你的武将@visitor@得到了一个管亥的木箱。","开启后，可以随机获得1~3级的武器和防具。\n特殊掉落：\n【神木剑】【紫藤古杖】"}
_tab_stringI[9201] = {"黄巾秘宝","你的武将@visitor@得到了一个黄巾秘宝。","开启后，可以随机获得1~7级的装备，有较高几率获得稀有黄金装备。\n特殊掉落：\n【太平要术】"}
_tab_stringI[9202] = {"吕布秘宝","你的武将@visitor@得到了一个吕布秘宝。","开启后，可以随机获得1~12级的蓝色和金色品质的装备。\n特殊掉落：\n【方天画戟】\n【七星刀】                   "}
_tab_stringI[9203] = {"金乌秘宝","你的武将@visitor@得到了一个金乌秘宝。","开启后，可以随机获得1~12级的蓝色和金色品质的装备。\n特殊掉落：\n【金乌落炎】                 "}
_tab_stringI[9204] = {"审配秘宝","你的武将@visitor@得到了一个审配秘宝。","开启后，可以随机获得1~12级的蓝色和金色品质的装备。\n特殊掉落：\n【碎金】                  "}
_tab_stringI[9205] = {"曹操秘宝","你的武将@visitor@得到了一个曹操秘宝。","开启后，可以随机获得1~12级的蓝色和金色品质的装备。\n特殊掉落：\n【倚天剑】                  "}
_tab_stringI[9206] = {"女娲秘宝","你的武将@visitor@得到了一个女娲秘宝。","开启后，可以随机获得1~12级的蓝色和金色品质的装备。\n特殊掉落：\n【五色石】                  "}
_tab_stringI[9207] = {"擎天秘宝","你的武将@visitor@得到了一个擎天秘宝。","开启后，可以随机获得1~12级的蓝色和金色品质的装备。\n特殊掉落：\n【擎天甲】                  "}
_tab_stringI[9208] = {"亢龙秘宝","你的武将@visitor@得到了一个亢龙秘宝。","开启后，可以随机获得1~12级的蓝色和金色品质的装备。\n特殊掉落：\n【亢龙套装】                  "}
_tab_stringI[9209] = {"心魔秘宝","你的武将@visitor@得到了一个心魔秘宝。","开启后，可以随机获得1~12级的蓝色和金色品质的装备。\n特殊掉落：\n【八卦镜】                  "}

--黄巾秘宝
_tab_stringI[9300] = {"仙人秘宝Ⅰ","你的武将@visitor@得到了一个仙人秘宝。","开启后，可以随机获得1~12级的装备，较小概率获得橙色精英装备。\n橙装掉落：\n【奔雷】\n【天公之怒】\n【黄天套装】                  ","开启后，可以随机获得1~12级的装备，较小概率获得橙色精英装备。\n橙装掉落：\n【奔雷】【天公之怒】\n【黄天套装】                  "}
--应熊秘宝
_tab_stringI[9301] = {"仙人秘宝Ⅱ","你的武将@visitor@得到了一个仙人秘宝。","开启后，可以随机获得1~12级的装备，较小概率获得橙色精英装备。\n橙装掉落：\n【嗔熊巨斧】\n【疯魔面具】\n【少典套装】                  ","开启后，可以随机获得1~12级的装备，较小概率获得橙色精英装备。\n橙装掉落：\n【嗔熊巨斧】【疯魔面具】\n【少典套装】                  "}
--南华秘宝
_tab_stringI[9302] = {"仙人秘宝Ⅲ","你的武将@visitor@得到了一个仙人秘宝。","开启后，可以随机获得1~12级的装备，较小概率获得橙色精英装备。\n橙装掉落：\n【龙吟】\n【苍龙佩】\n【虎翼】\n【照夜玉狮子】\n【冰玄魔靴】                  ","开启后，可以随机获得1~12级的装备，较小概率获得红装神器。\n特殊掉落：\n【龙吟】【苍龙佩】【虎翼】\n【照夜玉狮子】【冰玄魔靴】                  "}

--道具合成洗练
_tab_stringI[9901] = {"合成道具","合成道具"}
_tab_stringI[9902] = {"洗练道具","洗练道具"}
_tab_stringI[9903] = {"洗练道具锁1","洗练道具锁1"}
_tab_stringI[9904] = {"洗练道具锁2","洗练道具锁2"}
_tab_stringI[9905] = {"洗练道具锁3","洗练道具锁3"}
_tab_stringI[9906] = {"重铸道具1","重铸道具1"}
_tab_stringI[9907] = {"重铸道具2","重铸道具2"}
_tab_stringI[9908] = {"重铸道具3","重铸道具3"}
_tab_stringI[9909] = {"重铸道具4","重铸道具4"}
_tab_stringI[9910] = {"1,000积分","获得1,000积分","购买后获得: \n1,000 游戏积分。"}
_tab_stringI[9911] = {"11,000积分","获得11,000积分","购买后获得: \n11,000 游戏积分。"}
_tab_stringI[9912] = {"120,000积分","获得120,000积分","购买后获得: \n120,000 游戏积分。"}
_tab_stringI[9913] = {"普通锦囊", "", "普通锦囊，每隔8小时可领取一个。\n可开出游戏币，以及少量的兵种卡碎片、英雄将魂碎片。",}
_tab_stringI[9914] = {"战功锦囊", "", "战功锦囊，通过20星兑换得到。需要3小时开启。\n可开出游戏币，以及大量的兵种卡碎片、英雄将魂碎片。",}
_tab_stringI[9915] = {"武侯锦囊", "", "武侯锦囊，通过20星兑换得到。需要8小时开启。\n可开出游戏币，以及巨量的兵种卡碎片、英雄将魂碎片。",}
_tab_stringI[9916] = {"擂台锦囊", "", "擂台锦囊，擂台赛有效局的胜利方，将获得一个擂台锦囊。\n获得的擂台锦囊可以立刻打开。\n擂台锦囊最多堆叠10个。",}
_tab_stringI[9917] = {"神器锦囊", "", "可开出一件蓝色及以上品质的装备（橙装除外），并随机获得积分、英雄将魂、兵种卡碎片，有一定几率开出红色神器。",}
_tab_stringI[9918] = {"红装卷轴", "", "可任意选择一件红色神器。",}
_tab_stringI[9919] = {"幸运神器锦囊", "", "可随机开出一件2-4孔的红色神器，并随机获得积分、英雄将魂、兵种卡碎片。",}
_tab_stringI[9920] = {"军团锦囊", "", "可开出一件蓝色及以上品质的装备，并随机获得积分、英雄将魂、兵种卡碎片，有一定几率开出红色神器。",}
_tab_stringI[9921] = {"擂台模式入场金币", "", "擂台模式入场金币",}
_tab_stringI[9922] = {"玩家更名", "", "玩家更名",}
_tab_stringI[9923] = {"购买兵符1", "", "购买兵符1",}
_tab_stringI[9924] = {"商店刷新", "", "商店刷新",}
_tab_stringI[9925] = {"红装合成", "", "红装合成",}
_tab_stringI[9926] = {"主公起名", "", "主公起名",}
_tab_stringI[9927] = {"橙装合成", "", "橙装合成",}
_tab_stringI[9928] = {"兑换军团战术卡碎片", "", "兑换军团战术卡碎片",}
_tab_stringI[9929] = {"兑换军团英雄将魂", "", "兑换军团英雄将魂",}
_tab_stringI[9930] = {"购买军团副本次数", "", "购买军团副本次数",}
_tab_stringI[9931] = {"精英地图", "", "精英地图",}
_tab_stringI[9932] = {"军团红包（小）", "", "军团红包（小）",}
_tab_stringI[9933] = {"军团红包（大）", "", "军团红包（大）",}
_tab_stringI[9934] = {"魔龙宝库再次领奖", "", "魔龙宝库再次领奖",}
_tab_stringI[9935] = {"魔龙宝库购买可领奖次数", "", "魔龙宝库购买可领奖次数",}
_tab_stringI[9936] = {"秘境试炼再次领奖", "", "秘境试炼再次领奖",}
_tab_stringI[9937] = {"群英阁重抽一次", "", "群英阁重抽一次",}
_tab_stringI[9938] = {"挑战群英阁", "", "挑战群英阁",}
_tab_stringI[9942] = {"人族无敌重抽一次", "", "人族无敌重抽一次",}
_tab_stringI[9943] = {"兑换藏宝图", "", "兑换藏宝图",}
_tab_stringI[9944] = {"兑换高级藏宝图", "", "兑换高级藏宝图",}
_tab_stringI[9951] = {"橙装锦囊", "", "可随机开出一件橙装，并随机获得积分、英雄将魂、兵种卡碎片。",}



--英雄技能卡升级
_tab_stringI[10001] = {"技能升级Lv1","技能升级Lv1"}
_tab_stringI[10002] = {"技能升级Lv2","技能升级Lv2"}
_tab_stringI[10003] = {"技能升级Lv3","技能升级Lv3"}
_tab_stringI[10004] = {"技能升级Lv4","技能升级Lv4"}
_tab_stringI[10005] = {"技能升级Lv5","技能升级Lv5"}
_tab_stringI[10006] = {"技能升级Lv6","技能升级Lv6"}
_tab_stringI[10007] = {"技能升级Lv7","技能升级Lv7"}
_tab_stringI[10008] = {"技能升级Lv8","技能升级Lv8"}
_tab_stringI[10009] = {"技能升级Lv9","技能升级Lv9"}
_tab_stringI[10010] = {"技能升级Lv10","技能升级Lv10"}
_tab_stringI[10011] = {"技能升级Lv11","技能升级Lv11"}
_tab_stringI[10012] = {"技能升级Lv12","技能升级Lv12"}
_tab_stringI[10013] = {"技能升级Lv13","技能升级Lv13"}
_tab_stringI[10014] = {"技能升级Lv14","技能升级Lv14"}
_tab_stringI[10015] = {"技能升级Lv15","技能升级Lv15"}
_tab_stringI[10016] = {"技能升级Lv16","技能升级Lv16"}
_tab_stringI[10017] = {"技能升级Lv17","技能升级Lv17"}
_tab_stringI[10018] = {"技能升级Lv18","技能升级Lv18"}
_tab_stringI[10019] = {"技能升级Lv19","技能升级Lv19"}
_tab_stringI[10020] = {"技能升级Lv20","技能升级Lv20"}
_tab_stringI[10021] = {"技能升级Lv21","技能升级Lv21"}
_tab_stringI[10022] = {"技能升级Lv22","技能升级Lv22"}
_tab_stringI[10023] = {"技能升级Lv23","技能升级Lv23"}
_tab_stringI[10024] = {"技能升级Lv24","技能升级Lv24"}
_tab_stringI[10025] = {"技能升级Lv25","技能升级Lv25"}
_tab_stringI[10026] = {"技能升级Lv26","技能升级Lv26"}
_tab_stringI[10027] = {"技能升级Lv27","技能升级Lv27"}
_tab_stringI[10028] = {"技能升级Lv28","技能升级Lv28"}
_tab_stringI[10029] = {"技能升级Lv29","技能升级Lv29"}
_tab_stringI[10030] = {"技能升级Lv30","技能升级Lv30"}
_tab_stringI[10031] = {"技能升级Lv31","技能升级Lv31"}
_tab_stringI[10032] = {"技能升级Lv32","技能升级Lv32"}
_tab_stringI[10033] = {"技能升级Lv33","技能升级Lv33"}
_tab_stringI[10034] = {"技能升级Lv34","技能升级Lv34"}
_tab_stringI[10035] = {"技能升级Lv35","技能升级Lv35"}
_tab_stringI[10036] = {"技能升级Lv36","技能升级Lv36"}
_tab_stringI[10037] = {"技能升级Lv37","技能升级Lv37"}
_tab_stringI[10038] = {"技能升级Lv38","技能升级Lv38"}
_tab_stringI[10039] = {"技能升级Lv39","技能升级Lv39"}
_tab_stringI[10040] = {"技能升级Lv40","技能升级Lv40"}

--战术技能卡升级
_tab_stringI[10101] = {"战术技能升级Lv1","战术技能升级Lv1"}
_tab_stringI[10102] = {"战术技能升级Lv2","战术技能升级Lv2"}
_tab_stringI[10103] = {"战术技能升级Lv3","战术技能升级Lv3"}
_tab_stringI[10104] = {"战术技能升级Lv4","战术技能升级Lv4"}
_tab_stringI[10105] = {"战术技能升级Lv5","战术技能升级Lv5"}
_tab_stringI[10106] = {"战术技能升级Lv6","战术技能升级Lv6"}
_tab_stringI[10107] = {"战术技能升级Lv7","战术技能升级Lv7"}
_tab_stringI[10108] = {"战术技能升级Lv8","战术技能升级Lv8"}
_tab_stringI[10109] = {"战术技能升级Lv9","战术技能升级Lv9"}
_tab_stringI[10110] = {"战术技能升级Lv10","战术技能升级Lv10"}

--兵种卡升级
_tab_stringI[10151] = {"兵种卡升级Lv1","兵种卡升级Lv1"}
_tab_stringI[10152] = {"兵种卡升级Lv2","兵种卡升级Lv2"}
_tab_stringI[10153] = {"兵种卡升级Lv3","兵种卡升级Lv3"}
_tab_stringI[10154] = {"兵种卡升级Lv4","兵种卡升级Lv4"}
_tab_stringI[10155] = {"兵种卡升级Lv5","兵种卡升级Lv5"}
_tab_stringI[10156] = {"兵种卡升级Lv6","兵种卡升级Lv6"}
_tab_stringI[10157] = {"兵种卡升级Lv7","兵种卡升级Lv7"}
_tab_stringI[10158] = {"兵种卡升级Lv8","兵种卡升级Lv8"}
_tab_stringI[10159] = {"兵种卡升级Lv9","兵种卡升级Lv9"}
_tab_stringI[10160] = {"兵种卡升级Lv10","兵种卡升级Lv10"}

_tab_stringI[10180] = {"还原战术卡附加属性","还原战术卡附加属性"}
_tab_stringI[10181] = {"刷新战术卡附加属性","刷新战术卡附加属性"}
_tab_stringI[10182] = {"新增战术卡附加属性","新增战术卡附加属性"}

--英雄升星
_tab_stringI[10190] = {"英雄解锁","英雄解锁"}
_tab_stringI[10191] = {"英雄升星Lv1","英雄升星Lv1"}
_tab_stringI[10192] = {"英雄升星Lv2","英雄升星Lv2"}
_tab_stringI[10193] = {"英雄升星Lv3","英雄升星Lv3"}
_tab_stringI[10194] = {"英雄升星Lv4","英雄升星Lv4"}
_tab_stringI[10195] = {"英雄升星Lv5","英雄升星Lv5"}
_tab_stringI[10196] = {"英雄升星Lv6","英雄升星Lv6"}
_tab_stringI[10197] = {"英雄升星Lv7","英雄升星Lv7"}
_tab_stringI[10198] = {"英雄升星Lv8","英雄升星Lv8"}
_tab_stringI[10199] = {"英雄升星Lv9","英雄升星Lv9"}
_tab_stringI[10200] = {"英雄升星Lv10","英雄升星Lv10"}

--将魂
_tab_stringI[10201] = {"刘备将魂", "刘备将魂",		"作用：提升英雄星级，兑换专属英雄\n获取途径：竞技场锦囊，限时商店。",}
_tab_stringI[10202] = {"关羽将魂", "关羽将魂",		"作用：提升英雄星级，兑换专属英雄\n获取途径：竞技场锦囊，限时商店。",}
_tab_stringI[10203] = {"张飞将魂", "张飞将魂",		"作用：提升英雄星级，兑换专属英雄\n获取途径：竞技场锦囊，限时商店。",}
_tab_stringI[10205] = {"曹操将魂", "曹操将魂",		"作用：提升英雄星级，兑换专属英雄\n获取途径：竞技场锦囊，限时商店。",}
_tab_stringI[10206] = {"太史慈将魂", "太史慈将魂",	"作用：提升英雄星级，兑换专属英雄\n获取途径：竞技场锦囊，限时商店。",}
_tab_stringI[10207] = {"郭嘉将魂", "郭嘉将魂",		"作用：提升英雄星级，兑换专属英雄\n获取途径：竞技场锦囊，限时商店。",}
_tab_stringI[10208] = {"赵云将魂", "赵云将魂",		"作用：提升英雄星级，兑换专属英雄\n获取途径：竞技场锦囊，限时商店。",}
_tab_stringI[10210] = {"夏侯惇将魂", "夏侯惇将魂",	"作用：提升英雄星级，兑换专属英雄\n获取途径：竞技场锦囊，限时商店。",}
_tab_stringI[10211] = {"吕布将魂", "吕布将魂",		"作用：提升英雄星级，兑换专属英雄\n获取途径：竞技场锦囊，限时商店。",}
_tab_stringI[10212] = {"貂蝉将魂", "貂蝉将魂",		"作用：提升英雄星级，兑换专属英雄\n获取途径：竞技场锦囊，限时商店。",}
_tab_stringI[10214] = {"张辽将魂", "张辽将魂",		"作用：提升英雄星级，兑换专属英雄\n获取途径：竞技场锦囊，限时商店。",}
_tab_stringI[10215] = {"许褚将魂", "许褚将魂",		"作用：提升英雄星级，兑换专属英雄\n获取途径：竞技场锦囊，限时商店。",}
_tab_stringI[10216] = {"典韦将魂", "典韦将魂",		"作用：提升英雄星级，兑换专属英雄\n获取途径：竞技场锦囊，限时商店。",}
_tab_stringI[10217] = {"甘宁将魂", "甘宁将魂",		"作用：提升英雄星级，兑换专属英雄\n获取途径：竞技场锦囊。",}
_tab_stringI[10218] = {"孙策将魂", "孙策将魂",		"作用：提升英雄星级，兑换专属英雄\n获取途径：竞技场锦囊，限时商店。",}
_tab_stringI[10219] = {"周瑜将魂", "周瑜将魂",		"作用：提升英雄星级，兑换专属英雄\n获取途径：竞技场锦囊，限时商店。",}
_tab_stringI[10220] = {"徐庶将魂", "徐庶将魂",		"作用：提升英雄星级，兑换专属英雄\n获取途径：竞技场锦囊，限时商店。",}
_tab_stringI[10221] = {"诸葛亮将魂","诸葛亮将魂",	"作用：提升英雄星级，兑换专属英雄\n获取途径：竞技场锦囊，限时商店。",}
_tab_stringI[10222] = {"小乔将魂", "小乔将魂",		"作用：提升英雄星级，兑换专属英雄\n获取途径：VIP6。",}
_tab_stringI[10223] = {"孙权将魂", "孙权将魂",		"作用：提升英雄星级，兑换专属英雄\n获取途径：竞技场锦囊，限时商店。",}
_tab_stringI[10224] = {"庞统将魂", "庞统将魂",		"作用：提升英雄星级，兑换专属英雄\n获取途径：竞技场锦囊，魔龙宝库。",}
_tab_stringI[10225] = {"荀彧将魂", "荀彧将魂",		"作用：提升英雄星级，兑换专属英雄\n获取途径：竞技场锦囊，限时商店。",}
_tab_stringI[10226] = {"黄月英将魂", "黄月英将魂",	"作用：提升英雄星级，兑换专属英雄\n获取途径：竞技场锦囊，限时商店。",}
_tab_stringI[10227] = {"贾诩将魂", "贾诩将魂",	"作用：提升英雄星级，兑换专属英雄\n获取途径：竞技场锦囊，限时商店。",}
_tab_stringI[10228] = {"孙尚香将魂", "孙尚香将魂",	"作用：提升英雄星级，兑换专属英雄\n获取途径：竞技场锦囊，限时商店。",}
_tab_stringI[10229] = {"英雄将魂", "英雄将魂",	"月卡用户每日可免费领取6个英雄将魂。",}
_tab_stringI[10230] = {"马超将魂", "马超将魂",	"作用：提升英雄星级，兑换专属英雄\n获取途径：竞技场锦囊，限时商店。",}
_tab_stringI[10231] = {"孙坚将魂", "孙坚将魂",	"作用：提升英雄星级，兑换专属英雄\n获取途径：竞技场锦囊，限时商店。",}
_tab_stringI[10232] = {"黄忠将魂", "黄忠将魂",	"作用：提升英雄星级，兑换专属英雄\n获取途径：竞技场锦囊，限时商店。",}
_tab_stringI[10233] = {"陆逊将魂", "陆逊将魂",	"作用：提升英雄星级，兑换专属英雄\n获取途径：竞技场锦囊，限时商店。",}
_tab_stringI[10234] = {"司马懿将魂", "司马懿将魂",	"作用：提升英雄星级，兑换专属英雄\n获取途径：竞技场锦囊，限时商店。",}
_tab_stringI[10235] = {"董卓将魂", "董卓将魂",	"作用：提升英雄星级，兑换专属英雄\n获取途径：竞技场锦囊，限时商店。",}
_tab_stringI[10236] = {"曹丕将魂", "曹丕将魂",	"作用：提升英雄星级，兑换专属英雄\n获取途径：竞技场锦囊，限时商店。",}
_tab_stringI[10237] = {"孟获将魂", "孟获将魂",	"作用：提升英雄星级，兑换专属英雄\n获取途径：竞技场锦囊，限时商店。",}
_tab_stringI[10238] = {"祝融夫人将魂", "祝融夫人将魂",	"作用：提升英雄星级，兑换专属英雄\n获取途径：竞技场锦囊，限时商店。",}
_tab_stringI[10239] = {"甄姬将魂", "甄姬将魂",	"作用：提升英雄星级，兑换专属英雄\n获取途径：竞技场锦囊，限时商店。",}
_tab_stringI[10240] = {"藏宝图碎片", "藏宝图碎片",	"每50张藏宝图碎片，可以开启一次宝物宝箱。",}
_tab_stringI[10241] = {"高级藏宝图碎片", "高级藏宝图碎片",	"每100张高级藏宝图碎片，可以开启一次高级宝物宝箱。",}
_tab_stringI[10242] = {"签到特惠礼包", "签到特惠礼包",	"新玩家签到第2天，可消耗1000积分购买当日特惠礼包。特惠礼包仅限购买一次。",}
_tab_stringI[10243] = {"签到特惠礼包", "签到特惠礼包",	"新玩家签到第3天，可消耗50游戏币购买当日特惠礼包。特惠礼包仅限购买一次。",}
_tab_stringI[10244] = {"签到特惠礼包", "签到特惠礼包",	"新玩家签到第7天，可消耗80游戏币购买当日特惠礼包。特惠礼包仅限购买一次。",}
_tab_stringI[10245] = {"签到特惠礼包", "签到特惠礼包",	"新玩家签到第14天，可消耗188游戏币购买当日特惠礼包。特惠礼包仅限购买一次。",}
_tab_stringI[10246] = {"签到特惠礼包", "签到特惠礼包",	"新玩家签到第5天，可消耗70游戏币购买当日特惠礼包。特惠礼包仅限购买一次。",}
_tab_stringI[10247] = {"签到特惠礼包", "签到特惠礼包",	"新玩家签到第9天，可消耗90游戏币购买当日特惠礼包。特惠礼包仅限购买一次。",}
_tab_stringI[10248] = {"签到特惠礼包", "签到特惠礼包",	"新玩家签到第11天，可消耗100游戏币购买当日特惠礼包。特惠礼包仅限购买一次。",}
_tab_stringI[10249] = {"高级卡包*5","你的武将@visitor@得到了一个高级战术卡*5。", "可随机获得15张战术卡或塔。\n【有几率获得稀有战术卡】", ""}
_tab_stringI[10250] = {"签到特惠礼包", "签到特惠礼包",	"新玩家签到第1天，可消耗1000积分购买当日特惠礼包。特惠礼包仅限购买一次。",}
_tab_stringI[10251] = {"签到特惠礼包", "签到特惠礼包",	"新玩家签到第4天，可消耗60游戏币购买当日特惠礼包。特惠礼包仅限购买一次。",}






_tab_stringI[10301] = {"剧毒塔碎片","","用于 剧毒塔 的合成和升级。"}
_tab_stringI[10302] = {"巨炮塔碎片","","用于 巨炮塔 的合成和升级。"}
_tab_stringI[10303] = {"火焰塔碎片","","用于 火焰塔 的合成和升级。"}
_tab_stringI[10304] = {"连弩塔碎片","","用于 连弩塔 的合成和升级。"}
_tab_stringI[10305] = {"寒冰塔碎片","","用于 寒冰塔 的合成和升级。"}
_tab_stringI[10306] = {"天雷塔碎片","","用于 天雷塔 的合成和升级。"}
_tab_stringI[10307] = {"狙击塔碎片","","用于 狙击塔 的合成和升级。"}
_tab_stringI[10308] = {"滚石塔碎片","","用于 滚石塔 的合成和升级。"}
_tab_stringI[10309] = {"轰天塔碎片","","用于 轰天塔 的合成和升级。"}
_tab_stringI[10310] = {"粮仓碎片","","用于 粮仓 的合成和升级。"}
_tab_stringI[10311] = {"擂鼓塔碎片","","用于 擂鼓塔 的合成和升级。"}
_tab_stringI[10312] = {"地刺塔碎片","","用于 地刺塔 的合成和升级。"}


_tab_stringI[10401] = {"练兵碎片","","用于 练兵 卡的合成和升级。"}
_tab_stringI[10402] = {"桃园结义碎片","","用于 桃园结义 卡的合成和升级。"}
_tab_stringI[10403] = {"破敌碎片","","用于 破敌 卡的合成和升级。"}
_tab_stringI[10404] = {"弱敌碎片","","用于 弱敌 卡的合成和升级。"}
_tab_stringI[10405] = {"乱敌碎片","","用于 乱敌 卡的合成和升级。"}
_tab_stringI[10406] = {"箭塔精通碎片","","用于 箭塔精通 卡的合成和升级。"}
_tab_stringI[10407] = {"炮塔精通碎片","","用于 炮塔精通 卡的合成和升级。"}
_tab_stringI[10408] = {"术塔精通碎片","","用于 术塔精通 卡的合成和升级。"}
_tab_stringI[10409] = {"富豪碎片","","用于 富豪 卡的合成和升级。"}
_tab_stringI[10410] = {"聚利碎片","","用于 聚利 卡的合成和升级。"}
_tab_stringI[10411] = {"妙手回春碎片","","用于 妙手回春 卡的合成和升级。"}
_tab_stringI[10412] = {"固若金汤碎片","","用于 固若金汤 卡的合成和升级。"}
_tab_stringI[10413] = {"塔基加固碎片","","用于 塔基加固 卡的合成和升级。"}
_tab_stringI[10414] = {"破军碎片","","用于 破军 卡的合成和升级。"}
_tab_stringI[10415] = {"摧城拔寨碎片","","用于 摧城拔寨 卡的合成和升级。"}
_tab_stringI[10416] = {"强化毒素碎片","","用于 强化毒素 卡的合成和升级。"}
_tab_stringI[10417] = {"致命连射碎片","","用于 致命连射 卡的合成和升级。"}
_tab_stringI[10418] = {"穿云一击碎片","","用于 穿云一击 卡的合成和升级。"}
_tab_stringI[10419] = {"天雷滚滚碎片","","用于 天雷滚滚 卡的合成和升级。"}
_tab_stringI[10420] = {"三味真火碎片","","用于 三味真火 卡的合成和升级。"}
_tab_stringI[10421] = {"冻土碎片","","用于 冻土 卡的合成和升级。"}
_tab_stringI[10422] = {"弹道学碎片","","用于 弹道学 卡的合成和升级。"}
_tab_stringI[10423] = {"致命轰击碎片","","用于 致命轰击 卡的合成和升级。"}
_tab_stringI[10424] = {"碾压碎片","","用于 碾压 卡的合成和升级。"}
_tab_stringI[10425] = {"王佐之才碎片","","用于 王佐之才 卡的合成和升级。"}
_tab_stringI[10426] = {"月华碎片","","用于 月华 卡的合成和升级。"}
_tab_stringI[10427] = {"凤翼天翔碎片","","用于 凤翼天翔 卡的合成和升级。"}
_tab_stringI[10428] = {"地刺陷阱碎片","","用于 地刺陷阱 卡的合成和升级。"}

_tab_stringI[10429] = {"飞沙走石碎片","","用于 飞沙走石 卡的合成和升级。"}
_tab_stringI[10430] = {"火借风威碎片","","用于 火借风威 卡的合成和升级。"}
_tab_stringI[10431] = {"剧毒新星碎片","","用于 剧毒新星 卡的合成和升级。"}
_tab_stringI[10432] = {"亡命狙击碎片","","用于 亡命狙击 卡的合成和升级。"}
_tab_stringI[10433] = {"箭雨碎片","","用于 箭雨 卡的合成和升级。"}
_tab_stringI[10434] = {"凛冬之寒碎片","","用于 凛冬之寒 卡的合成和升级。"}
_tab_stringI[10435] = {"复仇巨炮碎片","","用于 复仇巨炮 卡的合成和升级。"}
_tab_stringI[10436] = {"神火雷碎片","","用于 神火雷 卡的合成和升级。"}
_tab_stringI[10437] = {"亡者天降碎片","","用于 亡者天降 卡的合成和升级。"}
_tab_stringI[10438] = {"孤狼碎片","","用于 孤狼 卡的合成和升级。"}
_tab_stringI[10439] = {"逆转天机碎片","","用于 逆转天机 卡的合成和升级。"}
_tab_stringI[10440] = {"分秒必争碎片","","用于 分秒必争 卡的合成和升级。"}
_tab_stringI[10441] = {"先者之音碎片","","用于 先者之音 卡的合成和升级。"}
_tab_stringI[10442] = {"月光碎片","","用于 月光 卡的合成和升级。"}
_tab_stringI[10443] = {"砖瓦结构碎片","","用于 砖瓦结构 卡的合成和升级。"}
_tab_stringI[10444] = {"修罗堡垒碎片","","用于 修罗堡垒 卡的合成和升级。"}
_tab_stringI[10445] = {"威震四方碎片","","用于 威震四方 卡的合成和升级。"}
_tab_stringI[10446] = {"炸弹人碎片","","用于 炸弹人 卡的合成和升级。"}
_tab_stringI[10447] = {"紫气东来碎片","","用于 紫气东来 卡的合成和升级。"}
_tab_stringI[10448] = {"余温碎片","","用于 余温 卡的合成和升级。"}
_tab_stringI[10449] = {"神火飞鸦碎片","","用于 神火飞鸦 卡的合成和升级。"}
_tab_stringI[10450] = {"引力炮弹碎片","","用于 引力炮弹 卡的合成和升级。"}
_tab_stringI[10451] = {"调息碎片","","用于 调息 卡的合成和升级。"}
_tab_stringI[10452] = {"复仇碎片","","用于 复仇 卡的合成和升级。"}
_tab_stringI[10453] = {"断粮碎片","","用于 断粮 卡的合成和升级。"}
_tab_stringI[10454] = {"召唤祝福碎片","","用于 召唤祝福 卡的合成和升级。"}

_tab_stringI[10501] = {"孔明灯碎片",	"", "作用：解锁竞技场兵种\n获取途径：竞技场锦囊，限时商店。",}
_tab_stringI[10502] = {"死士碎片",		"", "作用：解锁竞技场兵种\n获取途径：竞技场锦囊，限时商店。",}
_tab_stringI[10503] = {"投石车碎片",	"", "作用：解锁竞技场兵种\n获取途径：竞技场锦囊，限时商店。",}
_tab_stringI[10504] = {"力士碎片",		"", "作用：解锁竞技场兵种\n获取途径：竞技场锦囊，限时商店。",}
_tab_stringI[10505] = {"自爆兵碎片",	"", "作用：解锁竞技场兵种\n获取途径：竞技场锦囊，限时商店。",}
_tab_stringI[10506] = {"箭雨碎片",		"", "作用：解锁竞技场兵种\n获取途径：竞技场锦囊，限时商店。",}
_tab_stringI[10507] = {"象兵碎片",		"", "作用：解锁竞技场兵种\n获取途径：竞技场锦囊，限时商店。",}
_tab_stringI[10508] = {"护城弩手碎片",	"", "作用：解锁竞技场兵种\n获取途径：竞技场锦囊，限时商店。",}
_tab_stringI[10509] = {"虎豹骑碎片",	"", "作用：解锁竞技场兵种\n获取途径：竞技场锦囊，限时商店。",}
_tab_stringI[10510] = {"刀兵碎片",		"", "作用：解锁竞技场兵种\n获取途径：竞技场锦囊，限时商店。",}
_tab_stringI[10511] = {"弓手碎片",		"", "作用：解锁竞技场兵种\n获取途径：竞技场锦囊，限时商店。",}
_tab_stringI[10512] = {"爆炎碎片",		"", "作用：解锁竞技场兵种\n获取途径：竞技场锦囊，限时商店。",}
_tab_stringI[10513] = {"护城卫士碎片",	"", "作用：解锁竞技场兵种\n获取途径：竞技场锦囊，限时商店。",}
_tab_stringI[10514] = {"狗雨碎片",		"", "作用：解锁竞技场兵种\n获取途径：竞技场锦囊，限时商店。",}
_tab_stringI[10515] = {"微笑力士碎片",	"", "作用：解锁竞技场兵种\n获取途径：竞技场锦囊，限时商店。",}
_tab_stringI[10516] = {"爆裂力士碎片",	"", "作用：解锁竞技场兵种\n获取途径：竞技场锦囊，限时商店。",}
_tab_stringI[10517] = {"天网碎片",		"", "作用：解锁竞技场兵种\n获取途径：竞技场锦囊，限时商店。",}
_tab_stringI[10518] = {"捕兽夹碎片",	"", "作用：解锁竞技场兵种\n获取途径：竞技场锦囊，限时商店。",}





_tab_stringI[10801] = {"孟德新编碎片",	"", "",}
_tab_stringI[10802] = {"英雄救美碎片",	"", "",}
_tab_stringI[10803] = {"桃园香炉碎片",	"", "",}
_tab_stringI[10804] = {"服部半藏面罩碎片",	"", "",}
_tab_stringI[10805] = {"神雕侠侣碎片",	"", "",}
_tab_stringI[10806] = {"拿破仑选集碎片",	"", "",}
_tab_stringI[10807] = {"兵临城下碎片",	"", "",}
_tab_stringI[10808] = {"龙凤灰袍碎片",	"", "",}
_tab_stringI[10809] = {"莫邪之血碎片",	"", "",}
_tab_stringI[10810] = {"五虎上将令碎片",	"", "",}
_tab_stringI[10811] = {"建筑师证书碎片",	"", "",}
_tab_stringI[10812] = {"战功金腰带碎片",	"", "",}
_tab_stringI[10813] = {"战斗天使碎片",	"", "",}
_tab_stringI[10814] = {"铁人之心碎片",	"", "",}
_tab_stringI[10815] = {"神行鞭碎片",	"", "",}
_tab_stringI[10816] = {"朱雀信条碎片",	"", "",}
_tab_stringI[10817] = {"主公玉玺碎片",	"", "",}
_tab_stringI[10818] = {"屯田令牌碎片",	"", "",}
_tab_stringI[10819] = {"合金钻头碎片",	"", "",}
_tab_stringI[10820] = {"干将之鼎碎片",	"", "",}
_tab_stringI[10821] = {"玄武水晶碎片",	"", "",}
_tab_stringI[10822] = {"琉璃簪碎片",	"", "",}
_tab_stringI[10823] = {"剑仙长明灯碎片",	"", "",}





_tab_stringI[11001] = {"青釭剑","","削铁如泥的宝剑，与倚天剑并称绝世双剑。","获取方式 \n首次充值6元档"}
_tab_stringI[11002] = {"亮银双龙甲","","亮银打造，两侧护肩为龙头，威武霸气。","获取方式 \n首次充值18元档"}
_tab_stringI[11003] = {"玉兰白龙驹","","通体雪白，日行千里，又名照夜玉狮子。","获取方式 \n成就奖励-获得300星"}
_tab_stringI[11004] = {"破邪苍龙佩","","苍龙有灵，寄魂于佩，破邪除魔。","获取方式 \n首次充值68元档"}
_tab_stringI[11005] = {"魔龙胆","","魔龙胆汲取敌人生命，也会汲取自己生命。",""}
_tab_stringI[11006] = {"飞鹰令","","可以调配飞鹰卫的令牌，功勋卓著的将军方能持有。","获取方式 \n12元礼包"}
--_tab_stringI[11007] = {"神鹰令","","可以调配神鹰卫的令牌，称霸一方的王侯方能持有。","获取方式 \n开启神器锦囊，推荐玩家100人"}

_tab_stringI[11008] = {"中秋月饼","","中秋必备，合成装备很有效果。吃超过三个就有些多了。"}
_tab_stringI[11009] = {"中秋大月饼","","中秋神器，合成装备有奇效。每次最好只吃一个。"}
_tab_stringI[11011] = {"青铜剑","","剑长三尺，剑宽三指。"}
_tab_stringI[11012] = {"青铜双剑","","双剑合璧，更快更强。"}
_tab_stringI[11013] = {"粗布衣","","麻布缝制的衣服，结实耐用，大汉百姓都穿这个。"}
_tab_stringI[11014] = {"木棉布衣","","以木棉为主料的衣服，既结实又轻盈。"}
_tab_stringI[11015] = {"草鞋","","刘备亲手编制的草鞋，款式美观，穿着舒适。"}
_tab_stringI[11016] = {"乌拉草鞋","","加入乌拉草，穿了健步如飞，还能防臭。"}
_tab_stringI[11017] = {"长矛","","涿州步卒的标配武器，只比长棍多了个矛头。"}
_tab_stringI[11018] = {"三丈矛","","长一丈三，据说叫三丈只是为了吓人。"}
_tab_stringI[11019] = {"皮甲","","涿州兵卒的标准防具，只在胸口贴了块皮子。"}
_tab_stringI[11020] = {"镶钉皮甲","","在皮甲上镶嵌了铆钉，防御更强，伍长专用。"}
_tab_stringI[11021] = {"香囊","","用绣花布囊装上各种香草，城里人都带这个。"}
_tab_stringI[11022] = {"绮罗香囊","","绣工精美的香囊，刘备随身会带几个。"}
_tab_stringI[11023] = {"朴刀","","窄长有短把的刀，双手持，可劈砍。"}
_tab_stringI[11024] = {"大砍刀","","比朴刀更大更厚实的刀。"}
_tab_stringI[11025] = {"双股剑","","一剑救国，一剑救民。"}
_tab_stringI[11026] = {"偃月刀","","手起，刀落，酒尚温。"}
_tab_stringI[11027] = {"蛇矛","","其状如蛇，其刃隆起。"}
_tab_stringI[11028] = {"青铜甲","","青铜制的短甲，防御力比皮甲好。"}
_tab_stringI[11029] = {"青铜重甲","","加重加厚，防御力更好，但会影响速度。"}
_tab_stringI[11030] = {"赤铜重铠","","加入赤铜改造，减重的同时却加强了防御。"}
_tab_stringI[11031] = {"狼牙挂饰","","把狼牙串绳上，据说能趋吉避凶。"}
_tab_stringI[11032] = {"狼牙项链","","把多枚狼牙串成项链，可以加强煞气。"}
_tab_stringI[11033] = {"祸斗项链","","用祸斗的爪牙制成，泛红光，可辟邪。"}
_tab_stringI[11034] = {"白马","","幽州产的马，速度和负重都一般，不过很好看。"}
_tab_stringI[11035] = {"乌丸马","","据说公孙瓒特别喜欢白色的乌丸马。"}
_tab_stringI[11036] = {"黑王","","浑身漆黑，高大而有威势。"}
_tab_stringI[11037] = {"镔铁刀","","镔铁打造的制式军刀，比一般的刀更有爆发力。"}
_tab_stringI[11038] = {"镔铁枪","","镔铁打造的制式长枪，比一般的长枪更加厚重。"}
_tab_stringI[11039] = {"凤嘴刀","","刀刃锋利，形似凤嘴，军中猛将常用之。"}
_tab_stringI[11040] = {"狼牙枪","","枪有倒钩如狼牙交错。"}
_tab_stringI[11041] = {"镔铁甲","","镔铁打造的制式铠甲，坚韧有余但灵便不足。"}
_tab_stringI[11042] = {"玄铁甲","","掺入玄铁二次打造的铠甲，防御能力惊人。"}
_tab_stringI[11043] = {"西凉马","","产自西凉的战马，速度快，耐力好，负重佳。"}
_tab_stringI[11044] = {"沙里飞","","色似金沙，奔跑如飞，据说是名将马超的爱马。"}
_tab_stringI[11045] = {"刺客面具","","刺客佩带的面具，可以隐藏面貌。"}
_tab_stringI[11046] = {"赤红面具","","赤铜打造的面具，显得异常威猛。"}
_tab_stringI[11047] = {"镔铁戟","","镔铁打造的大戟，带有月刃，可刺可砍。"}
_tab_stringI[11048] = {"方天戟","","带有两个月刃，拿在手中能感到源源不断的活力。"}
_tab_stringI[11049] = {"大宛马","","西域大宛国产的名马，日行千里，疾驰如飞。"}
_tab_stringI[11050] = {"汗血马","","纯血的大宛马，会流出如血液般的汗液。"}
_tab_stringI[11051] = {"爆弹护腕","","特制的护腕，可以投掷出隐藏于其中的爆弹。"}
_tab_stringI[11052] = {"爆炎护腕","","加入了火药，可以投掷更远，爆炸后持续燃烧。"}
_tab_stringI[11053] = {"培元甲","","在铁甲上附加柔软的肩垫，提升战斗的持久性。"}
_tab_stringI[11054] = {"擎天甲","","名匠打制，兼具坚韧和轻便，大大提升武将的耐力。"}
_tab_stringI[11055] = {"方天画戟","","吕布的武器，可刺可砍，攻防一体。"}
_tab_stringI[11056] = {"赤兔","","汗血马中的极品，唯绝世猛将方可驾驭。"}
_tab_stringI[11057] = {"相思环","","攻击力不高，但是可以让你快到飞起来。"}
_tab_stringI[11058] = {"霓裳羽衣","","以云霓为裳，以羽毛做衣，婷婷袅袅，锦簇花攒。"}
_tab_stringI[11059] = {"三尖刀","","前端有三叉，两面有刃，猛将纪灵擅使之兵器。"}
_tab_stringI[11060] = {"赤金护腕","","赤金打造的护腕，带上可以爆发出更强的力量。"}
_tab_stringI[11061] = {"忠义袍","","刘备赠与关羽的旧袍，穿之如见兄面。"}
_tab_stringI[11062] = {"巨木槌","","用一整棵大树打磨而成，只有大力士才能使得动。"}
_tab_stringI[11063] = {"寒铁巨棍","","用寒铁包覆巨木，重一百二十斤，甚好甚强。"}
_tab_stringI[11064] = {"朱红指环","","加入了少量炎晶制成的指环，能提升对法术的抗性。"}
_tab_stringI[11065] = {"炎雀指环","","寄有一丝朱雀力量的指环，极大提升法术抗性。"}
--9级额外补充
_tab_stringI[11066] = {"黄龙钩镰刀","","装有长柄的长刀，刀身如镰刀一般弯曲。"}
_tab_stringI[11067] = {"玄铁重锤","","玄铁打造的巨大锤子，具有难以想象的重量。"}
_tab_stringI[11068] = {"黄金锁子甲","","打造时融入了特殊材质，使盔甲看起来金光灿灿。"}
_tab_stringI[11069] = {"赤血精石","","如血般鲜红通透的宝石。"}
_tab_stringI[11070] = {"燎原火","","远近闻名的战马，浑身如火般通红。"}
_tab_stringI[11071] = {"钩镰刀","","装有长柄的长刀，刀身如镰刀一般弯曲。"}
_tab_stringI[11072] = {"铁锁甲","","作为防具，显得有些笨重。"}
_tab_stringI[11073] = {"血精石","","一种宝石，散发着暗淡的红色。"}
_tab_stringI[11074] = {"大郦马","","关外的一种名马，强壮而富有攻击性。"}
---7级额外补充
_tab_stringI[11075] = {"鬼头刀","","刀体沉重，刀柄处雕有鬼头，相当锋利，斩金切玉。"}
_tab_stringI[11076] = {"狼牙棒","","棒的头部植有数个铁钉，用以击碎铠甲。"}
_tab_stringI[11077] = {"疾风束衣","","进行隐秘行动时所穿的衣服。"}
_tab_stringI[11078] = {"白银狮头盔","","型如狮头般的头盔，能震慑胆小的敌人。"}
_tab_stringI[11079] = {"白银护心镜","","加入了白银材质的护心镜，工艺精湛。"}
_tab_stringI[11080] = {"飞电","","因行动如闪电般飞快而得名。"}
--充值装
_tab_stringI[11081] = {"月光护甲","","泛着月光的护甲，让自己变得轻灵。"}
--_tab_stringI[11082] = {"月神护甲","","月神之力加持的护甲，可以吸收月光打击敌人。","获取方式 \n活动奖励"}
_tab_stringI[11083] = {"月影","","如明月一般洁白的骏马，可以让骑手变得轻灵。"}
_tab_stringI[11084] = {"狂战斧","","狂战套装的武器，让人像狂战士般奋勇前行。"}
_tab_stringI[11085] = {"狂战甲","","狂战套装的护甲，让人像狂战士般无所畏惧。"}
_tab_stringI[11086] = {"狂战腰带","","狂战套装的腰带，让人像狂战士般越战越勇。"}
--第三章新增
_tab_stringI[11087] = {"金麟剑","","黄金打造的宝剑，剑身刻有麒麟状花纹。"}
_tab_stringI[11088] = {"木灵珠","","一个摸金校尉所发掘的仙珠，年代极其久远。"}
_tab_stringI[11089] = {"毒王","","罕见的冷血马，因全身绿色而得其名，极难驾驭。"}
_tab_stringI[11090] = {"铸铜战盔","","加入铜铸造，非常结实。"}
_tab_stringI[11091] = {"吸血刺","","剑刃很细，适合贴身携带。"}
_tab_stringI[11092] = {"道士法衣","","道士常穿的法衣，有着极高的法术抗性。"}
_tab_stringI[11093] = {"苍蓝晶石","","散发着苍蓝光辉的宝石。"}
_tab_stringI[11094] = {"破岩锤","","力士才能挥舞的大锤，可破山石。"}
--孙尚香传特殊奖励橙装
_tab_stringI[11095] = {"玄月披风","","纹有玄月图案的披风。"}

--新加额外橙装
_tab_stringI[11096] = {"朱雀长袍","","受到朱雀之力加持的衣服。"}
_tab_stringI[11097] = {"鬼煞双镰","","散发着无形煞气的镰刀，能夺取敌人的魂魄。"}
_tab_stringI[11098] = {"铁卫令","","可以调配铁甲卫的令牌，功勋卓著的将军方能持有。"}
_tab_stringI[11099] = {"灰影","","三国名马，张辽坐骑，威震逍遥津。"}

_tab_stringI[11101] = {"百石弓","","据说只有真正的射手，才能用百石之力拉开这张弓。"}
_tab_stringI[11102] = {"百石护腕","","用蚕丝和蛟筋织成，可以让射出的箭更有爆发力。"}
_tab_stringI[11103] = {"乌雅","","通体如黑缎，油光放亮，唯有四个蹄子雪白。"}
_tab_stringI[11104] = {"紫铜战甲","","用赤铜精炼而成，厚重而不失灵活，具有良好的成长性。"}
_tab_stringI[11105] = {"玄铁圆盾","","以玄铁多次锻打而成，尺寸虽小但是能量惊人。"}
_tab_stringI[11106] = {"一尺锋","","锋长一尺，来去无痕。"}
_tab_stringI[11107] = {"一寸衫","","衫厚一寸，风采绝伦。"}
_tab_stringI[11108] = {"一丈鞋","","鞋跃一丈，驰骋张狂。"}
_tab_stringI[11109] = {"火精剑","","剑身流火，隐约能见朱雀之形。"}
_tab_stringI[11110] = {"百战铠甲","","久经战阵者所穿铠甲，虽缝缝补补，却结实耐用。"}
_tab_stringI[11111] = {"大战鼓","","因为十分笨重，所以拖累了行军速度。"}
_tab_stringI[11112] = {"北风","","在严酷的极北之地生存，具有极强的忍耐力。"}
----1～2级额外补充
_tab_stringI[11113] = {"神木剑","","看似不起眼的木剑，却如钢铁般坚硬。"}
_tab_stringI[11114] = {"百草香囊","","上好香料和药材调配而成的香囊，散发淡淡清香。"}
_tab_stringI[11115] = {"护手钺","","小巧而精悍的防身武器。"}
_tab_stringI[11116] = {"夜行衣","","通常为黑色，方便晚上行动不被发现。"}
_tab_stringI[11117] = {"护心镜","","古代镶嵌在战衣胸背部位用以防箭的铜镜。"}
_tab_stringI[11118] = {"吐谷浑马","","产自高原苦寒之地的名马，体质结实干燥。"}

_tab_stringI[11119] = {"金乌落炎弓","","传说后羿用金乌的脊椎骨做出的弓。"}
_tab_stringI[11120] = {"碎金锤","","在西北高寒之地埋藏的一把巨锤，能轻易击碎敌人的头颅。"}
_tab_stringI[11121] = {"黑熊","","一匹黑熊，漆黑的巨兽，擅长用高大的身躯碾碎身前的敌人。"}
_tab_stringI[11122] = {"天师符咒","","一张天师符咒。","黄巾术士使用的咒符，能增强引雷之术。"}
_tab_stringI[11123] = {"愤怒之铠","","外型骇人的铠甲，能感受到穿戴者的怒火。"}
_tab_stringI[11124] = {"雁翎金甲","","甲身环环相扣，型如雁翎，轻便且坚韧。"}

---精英本橙装
_tab_stringI[11201] = {"龙牙刀","","威力巨大的重型兵器，传闻是用整颗龙的牙齿打磨而成。"}
_tab_stringI[11202] = {"轰火杖","","加持了特殊法咒的杖型兵器。"}
_tab_stringI[11203] = {"芭蕉扇","","传闻是天界仙人炼丹时用来扇火的宝物。"}
_tab_stringI[11204] = {"暗月","","原本只是仪式所用的镇邪之物，被无名方士炼化成了法器。"}
_tab_stringI[11205] = {"蚩牛巨斧","","远古东夷一族的圣器。"}

_tab_stringI[11206] = {"玄龟甲","","使用玄龟外壳制成的铠甲，寻常刀剑奈何不了它。"}
_tab_stringI[11207] = {"武极斗篷","","能发挥武者潜力的斗篷"}
_tab_stringI[11208] = {"金麟甲","","黄金打造的铠甲，闪耀着麒麟状花纹。"}
_tab_stringI[11209] = {"诅咒之铠","","受到诅咒的铠甲，只有意志坚定者才能抵御铠甲的反噬之力。"}



_tab_stringI[11210] = {"疯魔面具","","尽情战斗到最后一刻吧！"}
_tab_stringI[11211] = {"聚财青钱","","只是一枚锈迹斑斑的铜钱。"}
_tab_stringI[11212] = {"吴子兵法","","战国名将吴起所著的兵书，武经七书之一。"}
_tab_stringI[11213] = {"黑铁重盾","","使用纯度很高的黑铁打造，拥有极强的防护力。"}



_tab_stringI[11216] = {"紫骍","","出自大宛的名马，曹操之子曹植的坐骑。"}
_tab_stringI[11217] = {"踏雪","","在极北苦寒之地的生存的奇异生灵，形似麋鹿，极有灵性。"}
_tab_stringI[11218] = {"玄龟","","一种传说中的异兽，与神兽玄武有着说不清道不明的联系。"}
_tab_stringI[11219] = {"玄甲白牛","","南越之地的圣兽，体格健壮，性情温顺，极富灵性。"}
_tab_stringI[11220] = {"漆黑道袍","","充斥着黑暗能量的邪道之衣。"}
_tab_stringI[11221] = {"藤甲","","产自南蛮之地的一种特殊铠甲，对寻常兵器有着极强的防护力。"}
_tab_stringI[11222] = {"雪橇车","","当大家还沉醉在梦乡的时候，圣诞老人已经驾驶着满载礼物的雪橇车悄然而至。"}
_tab_stringI[11223] = {"筏罗诃","","来自西域的神猪，极富灵性。"}

--红装--武器
_tab_stringI[12001] = {"鬼神方天戟","","能施展鬼神之力的绝世武器。","获取方式 \n开启神器锦囊、红装兑换券"}
_tab_stringI[12002] = {"朱雀羽扇","","蕴含神兽朱雀之力的羽扇。","获取方式 \n开启神器锦囊、红装兑换券"}
_tab_stringI[12003] = {"天公之怒","","南华老仙赐予张角的法器之一。","获取方式 \n首次充值388元档"}
_tab_stringI[12004] = {"倚天剑","","曹操的佩剑之一，与青缸剑成对。","获取方式 \n开启神器锦囊、红装兑换券"}
_tab_stringI[12005] = {"冥蛇弩","","以极为罕有的冥蛇作为材料炼制而成的弩。","获取方式 \n开启神器锦囊、红装兑换券"}
_tab_stringI[12006] = {"恶鬼锤","","古老的巨锤，通体黝黑，拿在手中似有强大的力量。","获取方式 \n开启神器锦囊、红装兑换券"}
--_tab_stringI[12007] = {"昭明神剑","","天帝以神剑昭明砍断巨龟四足，撑起苍穹。","获取方式 \n无法获取"}
_tab_stringI[12008] = {"青玉蛇纹剑","","通体翠绿,饰有精美青蛇环绕剑身,内有机关,可释放剧毒。","获取方式 \n活动奖励"}
_tab_stringI[12009] = {"泰阿","","当持剑者内心无所畏惧，便能激发此剑威能。","获取方式 \n开启神器锦囊、红装兑换券"}
_tab_stringI[12010] = {"红月","","以天外陨铁锻造而成的绝世神兵，散发着耀眼红芒。","获取方式 \n活动奖励"}
_tab_stringI[12011] = {"贪狼","","火遇贪狼照命宫，封侯食禄是英雄","获取方式 \n开启军团宝箱"}
_tab_stringI[12012] = {"鼠槌","","一把神奇的小木槌，无论面对多强大的敌人，都能令其受伤。","获取方式 \n魔龙宝库限时掉落、活动奖励"}
_tab_stringI[12013] = {"巨阙","","铸剑名师欧冶子所铸，钝而厚重。","获取方式 \n开启高级藏宝图"}
_tab_stringI[12014] = {"龙吟","","此物时常发出龙吟，因而得名。","获取方式 \n开启高级藏宝图"}
_tab_stringI[12015] = {"豪龙胆","","传闻有着赤胆忠心之人才可使用，十分沉重，寻常人根本无法拿起。","获取方式 \n开启高级藏宝图"}


--红装--盔甲
_tab_stringI[12201] = {"玄武战甲","","蕴含神兽玄武之力的战甲。","获取方式 \n开启神器锦囊、红装兑换券"}
_tab_stringI[12202] = {"炽魂战衣","","祸斗的灵魂寄宿其中。","获取方式 \n开启神器锦囊、红装兑换券"}
_tab_stringI[12203] = {"玄冰魔衣","","以千年玄冰作为材料制作而成的衣服。","获取方式 \n开启神器锦囊、红装兑换券"}
_tab_stringI[12204] = {"饕餮魔甲","","蚩尤一族使用上古魔兽饕餮的皮缝制而成的铠甲。","获取方式 \n开启神器锦囊、红装兑换券"}
_tab_stringI[12205] = {"月神护甲","","月神之力加持的护甲，可以吸收月光打击敌人。","获取方式 \n活动奖励"}
_tab_stringI[12206] = {"黑暗魔衣","","稀有材料打造而成，蕴含神秘魔法能力。","获取方式 \n开启神器锦囊、红装兑换券"}
_tab_stringI[12207] = {"紫电神雷衣","","由上古雷纹木淬炼而成,内蕴强大力量。","获取方式 \n开启神器锦囊、红装兑换券"}
_tab_stringI[12208] = {"隐身斗篷","","能藏匿身形的神奇斗篷。","获取方式 \n开启神器锦囊、红装兑换券"}
_tab_stringI[12209] = {"圣者之衣","","古圣先贤流传下来的衣物，似乎没有什么特别的。","获取方式 \n活动奖励"}
_tab_stringI[12210] = {"龙鳞铠甲","","甲身用龙之逆鳞加上补天石做成，龙之逆鳞是保护龙的弱点，坚硬无比。","获取方式 \n开启军团宝箱"}
_tab_stringI[12211] = {"凶邪战甲","","稀有材料打造而成，隐隐透着一股威压。","获取方式 \n开启神器锦囊、红装兑换券"}
_tab_stringI[12212] = {"蛇纹胸甲","","传闻此甲乃是用了上古凶神相柳的皮所缝制，散发阵阵恶臭。","获取方式 \n活动奖励"}
_tab_stringI[12213] = {"蟠龙战衣","","使用了蟠龙麟片缝制而成，其周围常常凝聚雾气。","获取方式 \n开启神器锦囊、红装兑换券"}
_tab_stringI[12214] = {"幽邃魔衣","","此衣于幽泉之处静置千年，常年吸收黄泉之花的魔力，因而不腐。","获取方式 \n活动奖励"}
_tab_stringI[12215] = {"修罗战甲","","化身修罗之人，将永世受到诅咒。","获取方式 \n活动奖励"}
--红装--宝物
_tab_stringI[12401] = {"文王八卦镜","","使用降龙木制成的八卦镜，有镇宅辟邪之功效。","获取方式 \n开启神器锦囊、红装兑换券"}
_tab_stringI[12402] = {"孟德新书","","曹操所著兵书，记载其军事理论成果。","获取方式 \n开启神器锦囊、红装兑换券"}
_tab_stringI[12403] = {"摸金手套","","曹操所设摸金校尉军衔，专司盗墓取财，贴补军饷。","获取方式 \n开启神器锦囊、红装兑换券"}
_tab_stringI[12404] = {"殇王之盔","","战国时期的邪物，站在远处都感受到丝丝凉意。","获取方式 \n开启神器锦囊、红装兑换券"}
_tab_stringI[12405] = {"神鹰令","","可以调配神鹰卫的令牌。","获取方式 \n开启神器锦囊、红装兑换券"}
--特殊红装，祭坛用
_tab_stringI[12406] = {"献祭之石","","可以放入祭坛合成其他红色神器。",""}
------
_tab_stringI[12407] = {"喋血护腕","","浸满了战场上敌人的鲜血，赐予佩戴者吸血能力。","获取方式 \n开启神器锦囊、红装兑换券"}
_tab_stringI[12408] = {"镇魂钟","","极其坚固的钟形饰物，能激发使用者的潜力。","获取方式 \n开启神器锦囊、红装兑换券"}
_tab_stringI[12409] = {"七彩琉璃心","","落入凡间的天界宝物，散发着多彩光芒。","获取方式 \n活动奖励"}
_tab_stringI[12410] = {"太平清领道","","道家著作，记载了治病救人的方术。","获取方式 \n开启神器锦囊、红装兑换券"}
_tab_stringI[12411] = {"虹霞秘术","","红霞所落之处，辉光万照，耀眼无比。","获取方式 \n开启军团宝箱"}
_tab_stringI[12412] = {"军团神器","","可随机获得一件2-4孔的军团红色神器。",}
_tab_stringI[12413] = {"麒麟心","","神兽麒麟之心，仍然残留着麒麟强大的神力。","获取方式 \n活动奖励"}
_tab_stringI[12414] = {"九龙神火炮","","使用墨家机关术所做的强大兵器，拥有毁天灭地之威能。","获取方式 \n开启神器锦囊、红装兑换券"}
_tab_stringI[12415] = {"盖聂秘典","","记载着一代剑术大师盖聂的剑术。","获取方式 \n活动奖励"}
_tab_stringI[12416] = {"冰棱杖","","杖的顶部镶嵌着千年玄冰，散发阵阵寒气。","获取方式 \n开启神器锦囊、红装兑换券"}
_tab_stringI[12417] = {"穷奇羽扇","","蕴含上古凶兽穷奇之力的羽扇。","获取方式 \n活动奖励"}
_tab_stringI[12418] = {"旱魃之心","","尸祖旱魃的心脏，传闻旱魃的灵魂被封印在里面。","获取方式 \n开启高级藏宝图"}
_tab_stringI[12419] = {"梼杌之眼","","被做成饰品的梼杌之眼，依然残留着强大的能量。","获取方式 \n开启神器锦囊、红装兑换券"}
_tab_stringI[12420] = {"蚩牛面具","","使用蚩牛头骨做成的面具，东夷一族的圣器。","获取方式 \n活动奖励"}
_tab_stringI[12421] = {"青龙之圭","","青龙形态的玉圭，夏后祭器之一。","获取方式 \n活动奖励"}
_tab_stringI[12422] = {"白虎之琥","","白虎形态的玉琥，夏后祭器之一。","获取方式 \n活动奖励"}
_tab_stringI[12423] = {"朱雀之璋","","朱雀形态的玉璋，夏后祭器之一。","获取方式 \n活动奖励"}
_tab_stringI[12424] = {"玄武之璜","","玄武形态的玉璜，夏后祭器之一。","获取方式 \n活动奖励"}
--红装--坐骑
_tab_stringI[12601] = {"蛮王战象","","南蛮之王的坐骑，身形巨大，刀枪不入。","获取方式 \n开启神器锦囊、红装兑换券"}
_tab_stringI[12602] = {"绝影","","奔跑的速度极快，连影子都追不上，因而得名。","获取方式 \n开启神器锦囊、红装兑换券"}
_tab_stringI[12603] = {"的卢","","眼下有泪槽，额边生白点，骑则妨主。","获取方式 \n开启神器锦囊、红装兑换券"}
_tab_stringI[12604] = {"盗骊","","古代名驹，关外名马，体格健壮，脾气暴烈，极难驯服。","获取方式 \n开启神器锦囊、红装兑换券"}
_tab_stringI[12605] = {"九色鹿","","会给人带来幸运的神鹿。","获取方式 \n开启神器锦囊、红装兑换券"}
_tab_stringI[12606] = {"游云惊帆","","古代名驹，极有灵性，奔跑如行云流水。","获取方式 \n开启神器锦囊、红装兑换券"}
_tab_stringI[12607] = {"年兽","","神话传说中的恶兽。","获取方式 \n魔龙宝库限时掉落、活动奖励"}
_tab_stringI[12608] = {"爪黄飞电","","通体雪白，四个黄蹄子，气质高贵非凡，傲气不可一世。","获取方式 \n开启神器锦囊、红装兑换券"}
_tab_stringI[12609] = {"吉祥猪","","受到天神祝福的猪，能带给你好运。","获取方式 \n魔龙宝库限时掉落、活动奖励"}
_tab_stringI[12610] = {"白虎","","古代神话传说中的神兽，是正义、勇猛、威严的象征。","获取方式 \n首次充值198元档"}
_tab_stringI[12611] = {"仙鹤","","传说中仙人的坐骑，象征着幸福、吉祥、长寿、忠贞。","获取方式 \n开启军团宝箱"}
_tab_stringI[12612] = {"碧酉鸡","","使用墨家机关术所做的代步工具。","获取方式 \n开启军团宝箱"}
_tab_stringI[12613] = {"玄甲金牛","","南越之地的圣兽，象征着智慧和财富。","获取方式 \n魔龙宝库限时掉落、活动奖励"}
_tab_stringI[12614] = {"六眼飞鱼","","只存在于传说中的鱼。","获取方式 \n开启军团宝箱"}

_tab_stringI[15001] = {"火神书","","火神书"}
_tab_stringI[15002] = {"激石书","","激石书"}
_tab_stringI[15003] = {"遁甲天书","","遁甲天书"}
_tab_stringI[15004] = {"兵法书","","兵法书"}
_tab_stringI[15005] = {"青囊书","","青囊书"}
_tab_stringI[15006] = {"石敢当","","石敢当"}
_tab_stringI[15007] = {"一壶浊酒","","一壶浊酒"}
_tab_stringI[15008] = {"落地冰莲","","落地冰莲"}
_tab_stringI[15009] = {"雷公凿","","雷公凿"}
_tab_stringI[15010] = {"召唤祸斗","","召唤祸斗"}
_tab_stringI[15011] = {"召唤群狼","","召唤群狼"}
_tab_stringI[15012] = {"召唤玄武","","召唤玄武"}
_tab_stringI[15013] = {"包子","","包子"}
_tab_stringI[15014] = {"天雷符","","释放电弧，在周围随机敌人之间弹射15次，每次造成300点法术伤害，并电晕0.5秒。"}
_tab_stringI[15015] = {"鸡腿","","鸡腿"}
_tab_stringI[15016] = {"兵法书","","兵法书"}
--_tab_stringI[15017] = {"天关塔决","","天关塔决"}
_tab_stringI[15018] = {"加心","","加心"}

------------------------------------------------------------------------------
_tab_stringI[15019] = {"神秘宝物", "", "神秘宝物，点击后立即生效。"} --加生命点5
_tab_stringI[15020] = {"神秘宝物", "", "神秘宝物，点击后立即生效。"} --减生命点5
_tab_stringI[15021] = {"神秘宝物", "", "神秘宝物，点击后立即生效。"} --加金币2000
_tab_stringI[15022] = {"神秘宝物", "", "神秘宝物，点击后立即生效。"} --减金币2000
_tab_stringI[15023] = {"神秘宝物", "", "神秘宝物，点击后立即生效。"} --加回血50
_tab_stringI[15024] = {"神秘宝物", "", "神秘宝物，点击后立即生效。"} --减回血50
_tab_stringI[15025] = {"神秘宝物", "", "神秘宝物，点击后立即生效。"} --加攻击力100
_tab_stringI[15026] = {"神秘宝物", "", "神秘宝物，点击后立即生效。"} --减攻击力100
_tab_stringI[15027] = {"神秘宝物", "", "神秘宝物，点击后立即生效。"} --加移动速度100
_tab_stringI[15028] = {"神秘宝物", "", "神秘宝物，点击后立即生效。"} --减移动速度100
_tab_stringI[15029] = {"神秘宝物", "", "神秘宝物，点击后立即生效。"} --加免控60秒
_tab_stringI[15030] = {"神秘宝物", "", "神秘宝物，点击后立即生效。"} --变小动物30秒
_tab_stringI[15031] = {"神秘宝物", "", "神秘宝物，点击地面后生效。"} --召唤友军60秒
_tab_stringI[15032] = {"神秘宝物", "", "神秘宝物，点击地面后生效。"} --召唤敌军60秒
_tab_stringI[15033] = {"神秘宝物", "", "神秘宝物，点击后立即生效。"} --减战术技能冷却120秒
_tab_stringI[15034] = {"神秘宝物", "", "神秘宝物，点击后立即生效。"} --加战术技能冷却120秒
_tab_stringI[15035] = {"神秘宝物", "", "神秘宝物，点击后立即生效。"} --加闪避50％
_tab_stringI[15036] = {"神秘宝物", "", "神秘宝物，点击后立即生效。"} --减命中50％
_tab_stringI[15037] = {"神秘宝物", "", "神秘宝物，点击一个防御塔后生效。"} --加塔射程100
_tab_stringI[15038] = {"神秘宝物", "", "神秘宝物，点击一个防御塔后生效。"} --加塔攻速100
_tab_stringI[15039] = {"解药", "", "瘟疫解药，可治愈一名英雄。"} --解除瘟疫
_tab_stringI[15040] = {"过期解药", "", "已过期的解药，尚不清除对变异后的瘟疫是否有效。"} --解除变异瘟疫
_tab_stringI[15041] = {"特效解药", "", "实验室刚研发出的解药，还未对人体进行试验。"} --解除终极瘟疫


_tab_stringI[15100] = {"移形换影", "", "【移形换影】: 迅速向正前方移动120码的距离，并获得极短时间的无敌。"}
_tab_stringI[15101] = {"机关弩炮", "", "【机关弩炮】: 在身边放置一台机关弩炮为你战斗。机关弩炮存在20秒。"}
_tab_stringI[15102] = {"护体神光", "", "【护体神光】: 移除身边的地刺，持续5秒。"}


_tab_stringI[15103] = {"捕兽夹", "", "【捕兽夹】: 使目标不能移动，并减少200点物理防御，持续3秒。"}
_tab_stringI[15104] = {"疾风骤雨", "", "【疾风骤雨】: 对附近随机目标发动连续12次攻击。"}

_tab_stringI[15120] = {"强弩","","攻击力"}
_tab_stringI[15121] = {"连射","","攻击速度"}
_tab_stringI[15122] = {"厚甲","","防御"}
_tab_stringI[15123] = {"疾行","","移速"}
_tab_stringI[15124] = {"回元","","回血"}
_tab_stringI[15125] = {"灵动","","闪避"}
_tab_stringI[15126] = {"会心","","暴击"}
_tab_stringI[15127] = {"鹰眼","","攻击范围"}

_tab_stringI[15200] = {"塔诀晶石-速", "", "提升目标防御塔100％的攻击速度。"}
_tab_stringI[15201] = {"塔诀晶石-攻", "", "提升目标防御塔200％的攻击力。"}
_tab_stringI[15202] = {"塔诀晶石-暴", "", "增加目标防御塔30％的暴击几率。"}
_tab_stringI[15203] = {"塔诀晶石-远", "", "提升目标防御塔100％的射程。"}
_tab_stringI[15204] = {"塔诀晶石-防", "", "提升目标防御塔50点物防、法防和生命回复。"}

_tab_stringI[15210] = {"箭塔", "", "在空地建造一个箭塔。"}
_tab_stringI[15211] = {"法术塔", "", "在空地建造一个法术塔。"}
_tab_stringI[15212] = {"炮塔", "", "在空地建造一个炮塔。"}
_tab_stringI[15213] = {"特种塔", "", "在空地建造一个特种塔。"}
_tab_stringI[15214] = {"飞剑塔", "", "在空地建造一个飞剑塔。"}
_tab_stringI[15215] = {"兵营", "", "在空地建造一个兵营。"}
_tab_stringI[15216] = {"光线塔", "", "在空地建造一个光线塔。"}
_tab_stringI[15217] = {"召唤瓦力", "", "召唤2个瓦力机器人为你战斗。瓦力存在180秒。"}
_tab_stringI[15218] = {"地刺", "", "在目标点周围放置地刺，对经过的敌人造成伤害。",}
_tab_stringI[15219] = {"捕兽夹", "", "在目标点周围放置捕兽夹，捕获第一个经过的敌人后消失，被捕获的敌人眩晕5秒。",}
_tab_stringI[15222] = {"包子","","恢复生命"}
_tab_stringI[15223] = {"强攻","","攻击力+3"} --强攻
_tab_stringI[15224] = {"急速","","攻击速度+6％"} --急速
_tab_stringI[15225] = {"厚甲","","物理防御+5"} --厚甲
_tab_stringI[15226] = {"魔御","","法术防御+5"} --魔御
_tab_stringI[15227] = {"疾行","","移动速度+10"} --疾行
_tab_stringI[15228] = {"回元","","回血速度+5"} --回元
_tab_stringI[15229] = {"会心","","暴击几率+1％"} --会心
_tab_stringI[15230] = {"激光炮", "", "在目标点附近召唤激光炮，对1000范围内的敌人造成巨大伤害。",}
_tab_stringI[15231] = {"导弹塔", "", "在空地建造一个导弹塔。",}
_tab_stringI[15232] = {"变身机器人", "", "将自己变身为超级机器人，持续60秒。",}
_tab_stringI[15233] = {"冰霜领域", "", "使目标点周围300范围内的敌人冰冻25秒。",}
_tab_stringI[15234] = {"冰霜领域", "", "使目标点周围300范围内的敌人冰冻50秒。",}
_tab_stringI[15235] = {"精神控制", "", "选择一名敌方小兵，将其变成我方单位。",}
_tab_stringI[15236] = {"生命汲取", "", "选择一名敌方英雄，每秒汲取1000点生命。持续30秒。",}
_tab_stringI[15237] = {"天神下凡", "", "自身变得巨大化，变成远程攻击，并免疫法术伤害。持续90秒。",}
_tab_stringI[15239] = {"复制敌将", "", "选择一名敌方英雄，复制该英雄的镜像为你战斗。镜像存在120秒。",}
_tab_stringI[15240] = {"凤翼天翔", "",
	"召唤凤凰，对200范围敌人和敌方建筑造成1600点真实伤害，并持续燃烧地面20秒。冷却90秒。",
	"召唤凤凰，对220范围敌人和敌方建筑造成2000点真实伤害，并持续燃烧地面24秒。冷却80秒。",
	"召唤凤凰，对240范围敌人和敌方建筑造成2400点真实伤害，并持续燃烧地面28秒。冷却70秒。",
	"召唤凤凰，对260范围敌人和敌方建筑造成2800点真实伤害，并持续燃烧地面32秒。冷却60秒。",
	"召唤凤凰，对280范围敌人和敌方建筑造成3200点真实伤害，并持续燃烧地面36秒。冷却50秒。",
	"召唤凤凰，对300范围敌人和敌方建筑造成3600点真实伤害，并持续燃烧地面40秒。冷却40秒。",
	"召唤凤凰，对330范围敌人和敌方建筑造成4000点真实伤害，并持续燃烧地面44秒。冷却30秒。",
	"召唤凤凰，对340范围敌人和敌方建筑造成4400点真实伤害，并持续燃烧地面48秒。冷却20秒。",
	"召唤凤凰，对360范围敌人和敌方建筑造成4800点真实伤害，并持续燃烧地面52秒。冷却10秒。",
	"召唤凤凰，对380范围敌人和敌方建筑造成5200点真实伤害，并持续燃烧地面56秒。冷却5秒。",
}
_tab_stringI[15241] = {"逆转天机", "",
	"提升我方防御塔35％的攻击力和100％的攻击速度，持续10秒。冷却120秒。",
	"提升我方防御塔45％的攻击力和110％的攻击速度，持续10秒。冷却115秒。",
	"提升我方防御塔55％的攻击力和120％的攻击速度，持续10秒。冷却110秒。",
	"提升我方防御塔65％的攻击力和130％的攻击速度，持续10秒。冷却105秒。",
	"提升我方防御塔75％的攻击力和140％的攻击速度，持续10秒。冷却100秒。",
	"提升我方防御塔75％的攻击力和150％的攻击速度，持续10秒。冷却95秒。",
	"提升我方防御塔75％的攻击力和150％的攻击速度，持续10秒。冷却90秒。",
	"提升我方防御塔75％的攻击力和150％的攻击速度，持续10秒。冷却85秒。",
	"提升我方防御塔75％的攻击力和150％的攻击速度，持续10秒。冷却80秒。",
	"提升我方防御塔75％的攻击力和150％的攻击速度，持续10秒。冷却75秒。",
}
_tab_stringI[15242] = {"召唤章鱼怪", "", "召唤4个章鱼怪为你战斗。章鱼怪存在240秒。"}
_tab_stringI[15243] = {"箭塔+3", "", "获得3个箭塔。"}
_tab_stringI[15244] = {"法术塔+3", "", "获得3个法术塔。"}
_tab_stringI[15245] = {"炮塔+3", "", "获得3个炮塔。"}
_tab_stringI[15246] = {"特种塔+3", "", "获得3个特种塔。"}
_tab_stringI[15247] = {"基础塔+1", "", "获得1个箭塔、1个法术塔、1个炮塔、1个特种塔。"}
_tab_stringI[15248] = {"空中枷锁", "", "在目标点周围撒下天网，进入该区域内的空中单位将被捕获，并被拉到地面。"}
_tab_stringI[15249] = {"恐怖瘟疫", "", "选择一名英雄，使其感染恐怖的瘟疫。"}
_tab_stringI[15250] = {"群体传送", "", "选择一个目标点，将自己和周围300范围内的全体单位传送到该处。冷却300秒。"}
_tab_stringI[15252] = {"沉默敌将", "", "选择一名敌方英雄，使其无法释放技能，持续75秒。"}
_tab_stringI[15253] = {"无敌斩", "", "瞬移至目标地点，并连续发动50次攻击，每次对附近随机一个敌人造成攻击力300％的真实伤害。在此期间处于无敌状态。"}
_tab_stringI[15254] = {"暴雨梨花针", "", "瞬间从自己身上发射出大量银针。"}
_tab_stringI[15255] = {"召唤孔明灯", "", "召唤6个孔明灯为你战斗。孔明灯只攻击空中单位，存在100秒。"}
_tab_stringI[15256] = {"雷神之怒", "", "在任意位置建造一个天雷装置。附近的敌人将遭受雷神之怒的攻击。"}
_tab_stringI[15257] = {"怒吼", "", "增加自身100点物防和法防，并嘲讽附近的敌人，强迫他们攻击自己，持续30秒。"}
_tab_stringI[15259] = {"雷劈", "", "从天空引一道天雷，对自己和全体敌人造成最大生命值300％的真实伤害。"}
_tab_stringI[15260] = {"瞬移术", "", "瞬间移动到目标点。冷却10秒。"}
_tab_stringI[15261] = {"灵魂链接", "", "选择一名敌方英雄，使其承担你受到的全部伤害，持续20秒。"}
_tab_stringI[15262] = {"狗雨", "", "朝目标点发射一波大范围的群狗，对300范围内的敌人造成大量伤害并混乱8秒。"}
_tab_stringI[15263] = {"蟠龙之锤", "", "我方英雄每次攻击有25％的几率（远程15％）击晕目标2秒。"}
_tab_stringI[15264] = {"愤怒的乔治", "", "对全体敌人造成当前金币数*1.5倍的法术伤害。"}
_tab_stringI[15265] = {"佩奇的祝福", "", "提升我方防御塔100％的射程，持续45秒。"}
_tab_stringI[15266] = {"召唤迷你旱魃", "", "召唤1个迷你旱魃为你战斗。迷你旱魃存在80秒。"}
_tab_stringI[15267] = {"召唤蜉蝣飞机", "", "召唤5个蜉蝣飞机为你战斗。蜉蝣飞机存在140秒。"}
_tab_stringI[15268] = {"轮回之心", "", "立即刷新我方英雄的战术技能和道具技能的冷却。"}
_tab_stringI[15269] = {"葵花宝典", "", "一本神秘的武功秘籍。修炼者必须为男性，并且要做出巨大牺牲。"}
_tab_stringI[15270] = {"霜之哀伤", "", "在目标点放置一把霜之哀伤。霜之哀伤释放冰霜之箭攻击敌人。如果敌人被霜之哀伤杀死，会转化为友军，持续35秒。"}
_tab_stringI[15271] = {"火之高兴", "", "在目标点放置一把火之高兴。火之高兴随机释放各类火焰法术攻击敌人。"}
_tab_stringI[15272] = {"风暴领域", "", "在地图上放置3个风暴之眼，使之连成三角形区域。在此三角形区域内的我方单位属性大幅提升，敌人属性大幅衰减。"}
_tab_stringI[15273] = {"南蛮入侵", "", "在目标点召唤南蛮部队为你战斗。南蛮部队存在150秒。"}
_tab_stringI[15274] = {"圣诞树", "", "在空地建造一棵圣诞树。"}
_tab_stringI[15275] = {"玉女心经", "", "古墓派的至高绝学。相传只有冰清玉洁的少女才能练成。"}
_tab_stringI[15276] = {"风暴塔", "", "在空地建造一个风暴塔。"}
_tab_stringI[15277] = {"召唤武侯之魂", "", "召唤1个武侯之魂为你战斗。武侯之魂存在200秒。"}
_tab_stringI[15278] = {"机枪塔", "", "在空地建造一个机枪塔。"}
_tab_stringI[15279] = {"九阴真经", "", "一门至阴至柔的绝世武功，天下第一武学奇术。共分为上、下两册。"}
_tab_stringI[15280] = {"九阴白骨爪", "", "一门非常阴毒的武功，可千里之外取人首级，狠辣无比。修炼者必须为女性。"}
_tab_stringI[15281] = {"扫射", "", "增加自身100％的攻击速度，持续65秒。"}
_tab_stringI[15282] = {"爆炎", "", "朝目标点发射威力巨大的爆炎，对300范围内的敌人造成巨量伤害并点燃9秒。"}
_tab_stringI[15283] = {"肉钩", "", "朝目标点方向挥出一个肉钩，将第一个碰到的单位钩回你身边。如果钩到的是敌人，额外造成大量伤害并击晕5秒。"}
_tab_stringI[15284] = {"东方快车", "", "从终点发出一辆火车开往起点，将沿途碰到的敌人推开并造成伤害。"}
_tab_stringI[15285] = {"幻象", "", "在目标点召唤1个你的分身。分身拥有你80％的属性，受到200％的伤害。分身存在75秒。"}









_tab_stringI[15500] = {"祸斗之魂","","祸斗之魂"}
_tab_stringI[15501] = {"风伯之魂","","风伯之魂"}
_tab_stringI[15502] = {"帝江之魂","","帝江之魂"}
_tab_stringI[15503] = {"黄龙之魂","","黄龙之魂"}
_tab_stringI[15504] = {"玄龟之魂","","玄龟之魂"}
_tab_stringI[15505] = {"凤凰之魂","","凤凰之魂"}









_tab_stringI[16003] = {"狂战","","狂战"}
_tab_stringI[16006] = {"雷霆战神","","雷霆战神"}
_tab_stringI[16013] = {"雨润","","雨润"}
_tab_stringI[16016] = {"固若金汤","","固若金汤"}
_tab_stringI[16023] = {"冰暴","","冰暴"}
_tab_stringI[16026] = {"劫火","","劫火"}
_tab_stringI[16033] = {"咆哮","","咆哮"}
_tab_stringI[16036] = {"白驹过隙","","白驹过隙"}



_tab_stringI[99999] = {"赠送锦囊", "", "普通锦囊，每隔8小时可领取一个。\n可开出游戏币，以及少量的兵种卡碎片、英雄将魂碎片。",}




--[[
_tab_stringI[110] = {"","",""}
_tab_stringI[110] = {"","",""}
_tab_stringI[110] = {"","",""}
--]]



_tab_stringME[1] = {"英雄现世", "通关  英雄现世",}
_tab_stringME[2] = {"新兵上路", "通关  扫除狼患",}
_tab_stringME[3] = {"水火不容", "消灭  祸斗 3 次",}
_tab_stringME[4] = {"桃园结义", "通关  桃园结义",}

_tab_stringME[5] = {"星星1", "获得 10 颗星",}
_tab_stringME[6] = {"星星2", "获得 20 颗星",}
_tab_stringME[7] = {"星星3", "获得 50 颗星",}
_tab_stringME[8] = {"星星4", "获得 100 颗星",}
_tab_stringME[9] = {"星星5", "获得 150 颗星",}

_tab_stringME[10] = {"千人斩", "消灭1000个敌人",}
_tab_stringME[11] = {"万人敌", "消灭10000个敌人",}
_tab_stringME[12] = {"天下无双", "消灭100000个敌人",}

_tab_stringME[13] = {"箭塔达人", "建造 100 个初级箭塔",}
_tab_stringME[14] = {"箭塔大师", "建造 200 个初级箭塔",}
_tab_stringME[15] = {"箭塔宗师", "建造 500 个初级箭塔",}

_tab_stringME[16] = {"炮塔达人", "建造 100 个初级炮塔",}
_tab_stringME[17] = {"炮塔大师", "建造 200 个初级炮塔",}
_tab_stringME[18] = {"炮塔宗师", "建造 500 个初级炮塔",}

_tab_stringME[19] = {"术塔达人", "建造 100 个初级法术塔",}
_tab_stringME[20] = {"术塔大师", "建造 200 个初级法术塔",}
_tab_stringME[21] = {"术塔宗师", "建造 500 个初级法术塔",}

_tab_stringME[22] = {"无尽挑战1", "在 无尽挑战 中战绩达到 4000 分",}
_tab_stringME[23] = {"无尽挑战2", "在 无尽挑战 中战绩达到 8000 分",}
_tab_stringME[24] = {"无尽挑战3", "在 无尽挑战 中战绩达到 12000 分",}

_tab_stringME[25] = {"星星6", "获得 200 颗星",}
_tab_stringME[26] = {"星星7", "获得 250 颗星",}
_tab_stringME[27] = {"星星8", "获得 300 颗星",}




--_tab_string["TipU14001"] = ""
--_tab_string["_TEXT_MIAOSHA_"] = "秒"
--_tab_string["_TEXT_MIE_"] = "灭"
--_tab_string["dx_0"] = "群"
--_tab_string["dx_1"] = "1 连" 
--_tab_string["dx_2"] = "2 连"
--_tab_string["dx_3"] = "3 连"
--_tab_string["dx_4"] = "4 连"
--_tab_string["dx_5"] = "5 连"



_tab_string["ios_groupcoin"] = "军团币"

--=============================================================================================--
--[[
--测试是否有未定义的文字
for _, tab in pairs(g_string) do
	for k, v in pairs(tab) do
		if (type(v) == "string") then
			local length = #v
			tab[k] = string.rep("#", math.ceil(length / 2))
		elseif (type(v) == "table") then
			for k1, v1 in pairs(v) do
				if (type(v1) == "string") then
					local length1 = #v1
					v[k1] = string.rep("#", math.ceil(length1 / 2))
				end
			end
		end
	end
end
]]