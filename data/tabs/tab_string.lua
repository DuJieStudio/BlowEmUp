--UTF8格式文件！
--print("UTF8格式文件！")
g_string = {}
g_string.tab_string = {}
g_string.tab_stringU = {}		--单位字符串
g_string.tab_stringH = {}		--不知道是啥
g_string.tab_stringS = {}		--技能字符串
g_string.tab_stringI = {}		--物品字符串
g_string.tab_stringM = {}		--地图字符串
g_string.tab_stringIE = {}		--道具强化说明表
g_string.tab_stringME = {}		--勋章信息说明表
g_string.tab_stringQ = {}		--任务说明表
g_string.tab_stringGIFT = {}		--礼包说明表
g_string.tab_stringT = {}		--战术技能表
g_string.tab_stringCH = {}		--章节描述
g_string.tab_stringTR = {}		--宝物表
g_string.tab_stringA = {}		--光环
g_string.tab_stringCHEST = {}		--宝箱
g_string.tab_stringTask = {}		--任务

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
local _tab_stringQ = g_string.tab_stringQ
local _tab_stringCH = g_string.tab_stringCH
local _tab_stringTR = g_string.tab_stringTR
local _tab_stringA = g_string.tab_stringA
local _stringCHEST = g_string.tab_stringCHEST
local _tab_stringTask = g_string.tab_stringTask

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

_tab_stringI[25] = {"水晶",}
_tab_stringI[1039] = {"水晶",}
_tab_stringI[1060] = {"水晶",}

_tab_string["__TEXT_Topup_Success_Tip2"] = "purchase succeeded"
_tab_string["cmd_40105"] = "￥%d.00"

--代码判断名字时要用 请勿删除或修改
_tab_string["text_youke"] = "战车"
_tab_string["__TEXT__sanjiao"] = "∨"
_tab_string["eightMantra1"] = "抵制不良游戏 拒绝盗版游戏 "
_tab_string["eightMantra2"] = "注意自我保护 谨防上当受骗 "
_tab_string["eightMantra3"] = "适度游戏益脑 沉迷游戏伤身 "
_tab_string["eightMantra4"] = "合理安排时间 享受健康生活 "
_tab_string["copyright"] = "著作权号：2019SR0506795"
_tab_string["editionInformation1"] = "ISBN ：978-7-498-08757-7" 
_tab_string["editionInformation2"] = "审批文号：国新出审【2021】226号" 
_tab_string["editionInformation3"] = "出版单位：上海晨路信息科技股份有限公司" 
_tab_string["__TEXT_healthgame"] = "本网络游戏适合年满16周岁以上的用户使用，为了你的健康，请合理控制游戏时间。"
_tab_string["admin_err"] = "账号填写错误"
_tab_string["password_err"] = "密码填写错误"
_tab_string["admin&password_err"] = "账号或密码错误"
_tab_string["enter_realname"] = "请输入真实姓名"
_tab_string["enter_idcard"] = "请输入身份证号" 
_tab_string["realnamecheck_err0"] = "验证通过"
_tab_string["realnamecheck_err1"] = "身份证错误"
_tab_string["realnamecheck_err2"] = "身份证信息不匹配"
_tab_string["realnamecheck_err3"] = "无效身份证"
_tab_string["realnamecheck_err2001"] = "身份验证不通过"
_tab_string["realnamecheck_err20010"] = "身份证填写无效"
_tab_string["realnamecheck_err20310"] = "姓名填写无效"
_tab_string["realnamecheck_errcode"]="版署实名验证失败\n错误码："
_tab_string["try_again_later"]= "等待超时，请稍后再试"
_tab_string["pleace_choose_logintype"]= "请选择登录方式"
_tab_string["remaining_time"]= "剩余游戏时间"
_tab_string["realname_1"] = "根据国家新闻出版署《关于防止未成年人沉迷网络游戏的通知》，响应国家号召，帮助未成年人树立正确的网络游戏消费观念和行为习惯，需要对账号进行实名认证，请输入您的身份证号码，进行实名认证"
_tab_string["realname_2"] = "根据国家新闻出版署《关于防止未成年人沉迷网络游戏的通知》，响应国家号召，帮助未成年人树立正确的网络游戏消费观念和行为习惯。\n您当前游戏时长已经超过规定的游戏时长，或者您处于非规定的游戏时间段内。\n系统将会强制您下线，给您带来的不便，敬请见谅。"
_tab_string["realname_3"] = "根据您的账号信息，您已被识别为【未成年人】。本游戏对未成年人做了如下限制：\n1、每日22时至次日8时无法进行游戏\n2、工作日游戏时长不得超过1.5小时，周末游戏时长不得超过3小时\n3、游戏内的充值消费会有额度限制"
_tab_string["realname_4"] = "根据国家新闻出版署最新规定，您是未成年人无法进入本游戏,  感谢配合！"

_tab_string["__TEXT_GetPhoneIDError"] = "获取手机号失败，错误码:"
_tab_string["__TEXT_GetPhoneIDError200022"] = "无网络"
_tab_string["__TEXT_GetPhoneIDError200027"] = "使用手机号码登录，必须先开启手机上的蜂窝数据或者移动数据"
_tab_string["douhao"] = "，"
_tab_string["__TEXT_Game_Privacy"] = "请阅读并同意"
_tab_string["__TEXT_And"] = "及"
_tab_string["__TEXT_Privacy"] = "隐私政策"
_tab_string["__TEXT_Protocol"] = "用户协议"
_tab_string["__TEXT_GamePrivacy_Title"] = "鑫线游戏隐私政策"
_tab_string["__TEXT_GameProtocol_Title"] = "鑫线游戏用户协议"
_tab_string["NoAgreeAndExit"] = "由于你不同意 《鑫线游戏%s及%s》，即将退出游戏。"
_tab_string["privacylist"] = "权限列表"
_tab_string["privacyinfo1"] = "我们非常重视您的个人信息和隐私保护，"
_tab_string["privacyinfo2"] = "为了保护您的个人权益，在进入游戏前，"
_tab_string["privacyinfo3"] = "隐私政策"
_tab_string["privacyinfo4"] = "用户协议"
_tab_string["privacyinfo5"] = "《"
_tab_string["privacyinfo6"] = "》"
_tab_string["privacyname1"] = "设备"
_tab_string["privacyintroduce1"] = "获取设备标识，加强账号安全"
_tab_string["privacyname2"] = "存储"
_tab_string["privacyintroduce2"] = "游戏资源存储，游戏数据读取"
_tab_string["privacyname3"] = "网络"
_tab_string["privacyintroduce3"] = "获取网络状态"
_tab_string["waitannounce"] = "获取公告信息中..."

_tab_string["del_account1"] = "当前为【#NAME】"
_tab_string["del_account2"] = "是否解除绑定， 并将对应的游戏账号和数据完全删除？"
_tab_string["logintype_phone"] = "手机号码一键登录"
_tab_string["logintype_wx"] = "微信登录"
_tab_string["logintype_qq"] = "QQ登录"
_tab_string["logintype_ios"] = "Apple登录"

--------------------------------------------------------------------------
--从这开始调用翻译

--程序用的别动
g_input_erro_info = {}
g_input_erro_info[1] = "duplicate name"
g_input_erro_info[2] = "invalid name"
g_input_erro_info[3] = "invalid name"
g_input_erro_info[4] = "too long"
g_input_erro_info[5] = "invalid name"
g_input_erro_info[6] = "unaccepctable name"
g_input_erro_info[7] = "unaccepctable name"
--[[
g_input_erro_info[1] = "名字与已有存档同名"
g_input_erro_info[2] = "您还没有输入名字"
g_input_erro_info[3] = "名字不能包含空格"
g_input_erro_info[4] = "名字最长支持15个英文或5个汉字"
g_input_erro_info[5] = "名字不能使用特殊字符"
g_input_erro_info[6] = "你输入的内容含有部分敏感词汇"
g_input_erro_info[7] = "名字不能以数字和标点符号开头"
]]

--失败后的小贴士
g_fail_hint_info = {}
g_fail_hint_info[1] = "111"


_tab_stringGIFT[1] = {"每日奖励", "",}
_tab_stringGIFT[2] = {"新人礼包", "",}
_tab_stringGIFT[3] = {"支持游戏", "",}
_tab_stringGIFT[4] = {"推荐礼包", "",}
_tab_stringGIFT[5] = {"首充礼包", "",}

-------------------------------------------------------------
--geyachao: 属性名称
_tab_string["__ATTR__hp_max"] = "生命"
_tab_string["__Attr_Hint_atk"] = "杀伤"
_tab_string["__Attr_Hint_atk_interval"] = "攻击间隔"
_tab_string["__Attr_Hint_move_speed"] = "动力"
_tab_string["__Attr_Hint_def_physic"] = "装甲"
_tab_string["__Attr_Hint_crit"] = "暴击"
_tab_string["__Attr_Hint_hp_restore"] = "维修"
_tab_string["__Attr_Hint_skill_damage"] = "攻击"
_tab_string["__Attr_Hint_def_thunder"] = "防电"
_tab_string["__Attr_Hint_def_fire"] = "防火"
_tab_string["__Attr_Hint_def_poison"] = "防毒"
_tab_string["__Attr_Hint_grenade_child"] = "子母"
_tab_string["__Attr_Hint_grenade_fire"] = "燃烧等级"
_tab_string["__Attr_Hint_grenade_fire2"] = "燃烧"
_tab_string["__Attr_Hint_grenade_dis"] = "射程"
_tab_string["__Attr_Hint_grenade_cd"] = "投雷冷却"
_tab_string["__Attr_Hint_grenade_cd2"] = "冷却"
_tab_string["__Attr_Hint_grenade_crit"] = "暴击"
_tab_string["__Attr_Hint_grenade_multiply"] = "双雷"
_tab_string["__Attr_Hint_inertia"] = "惯性"
_tab_string["__Attr_Hint_crystal_rate"] = "水晶产量"
_tab_string["__Attr_Hint_melee_bounce"] = "近战弹开"
_tab_string["__Attr_Hint_melee_fight"] = "轮刀"
_tab_string["__Attr_Hint_melee_stone"] = "碎石"
_tab_string["__Attr_Hint_pet_hp_restore"] = "宠物治疗"
_tab_string["__Attr_Hint_pet_hp"] = "宠物生命"
_tab_string["__Attr_Hint_pet_atk"] = "宠物攻击"
_tab_string["__Attr_Hint_pet_atk_speed"] = "宠物攻速"
_tab_string["__Attr_Hint_pet_capacity"] = "携宠"
_tab_string["__Attr_Hint_trap_ground"] = "陷阱时间"
_tab_string["__Attr_Hint_trap_groundcd"] = "陷阱冷却"
_tab_string["__Attr_Hint_trap_groundenemy"] = "陷阱困敌"
_tab_string["__Attr_Hint_trap_fly"] = "天网时间"
_tab_string["__Attr_Hint_trap_flycd"] = "天网冷却"
_tab_string["__Attr_Hint_trap_flyenemy"] = "天网困敌"
_tab_string["__Attr_Hint_puzzle"] = "迷惑几率"
_tab_string["__Attr_Hint_puzzle_short"] = "迷惑"
_tab_string["__Attr_Hint_atk_bullet"] = "武器攻击"
_tab_string["__Attr_Hint_basic_weapon_level"] = "武器等级"
_tab_string["__Attr_Hint_weapon_crit_shoot"] = "射击暴击"
_tab_string["__Attr_Hint_weapon_crit_frozen"] = "冰冻暴击"
_tab_string["__Attr_Hint_weapon_crit_fire"] = "火焰暴击"
_tab_string["__Attr_Hint_weapon_crit_hit"] = "击退暴击"
_tab_string["__Attr_Hint_weapon_crit_blow"] = "飓风暴击"
_tab_string["__Attr_Hint_weapon_crit_poison"] = "毒液暴击"
_tab_string["__Attr_Hint_weapon_crit_equip"] = "装备暴击"
_tab_string["__Attr_Hint_atk_speed"] = "攻速"
_tab_string["__Attr_Hint_atk_radius"] = "射程"
_tab_string["__Attr_Hint_def_magic"] = "法防"
_tab_string["__Attr_Hint_dodge_rate"] = "闪避"
_tab_string["__Attr_Hint_hit_rate"] = "命中"
_tab_string["__Attr_Hint_crit_rate"] = "暴率"
_tab_string["__Attr_Hint_crit_value"] = "暴倍"
_tab_string["__Attr_Hint_hp_restore"] = "回血"
_tab_string["__Attr_Hint_suck_blood_rate"] = "吸血"
_tab_string["__Attr_Hint_rebirth_time"] = "复活"
_tab_string["__Attr_Hint_active_skill_cd_delta"] = "战术冷却"
_tab_string["__Attr_Hint_passive_skill_cd_delta"] = "战术冷却"
_tab_string["__Attr_Hint_active_skill_cd_delta_rate"] = "技能冷却"
_tab_string["__Attr_Hint_passive_skill_cd_delta_rate"] = "技能冷却"
_tab_string["__Attr_Hint_trap"] = "陷阱"
_tab_string["__TEXT_melee_bounce"] = "冲撞"
_tab_string["__TEXT_hp_restore"] = "治疗"


_tab_string["__Attr_AttackType"] = "攻击方式"
_tab_string["__Attr_On-hook_proceeds"] = "挖矿收益"
_tab_string["__ATTR__Wave"] = "波次"
_tab_string["__TEXT_PAGE_SHOP"] = "货架"
_tab_string["__TEXT_PAGE_PURCHASE"] = "氪石"
_tab_string["__TEXT_PAGE_TASKSTONE"] = "活跃度"
_tab_string["__TEXT_PAGE_CHEST"] = "宝箱"
_tab_string["__TEXT_PAGE_GIFT"] = "礼包"
_tab_string["__TEXT_PAGE_MUCHAOZHIZHAN"] = "母巢之战"
_tab_string["__TEXT_PAGE_QIANSHAOZHENDI"] = "前哨阵地"
_tab_string["__TEXT_PAGE_DUOBAIQIBING"] = "夺宝奇兵"
_tab_string["__TEXT_SELECT"] = "选择"
_tab_string["__TEXT_BATTLE"] = "出战"
-------------------------------------------------------------
_tab_string["__TEXT_Level"] = "难度"
_tab_string["__TEXT_Reset"] = "重置"
_tab_string["__TEXT_ResetALL"] = "您确定要重置吗？"
_tab_string["startgame"] = "开始"
_tab_string["norecord"] = "无记录"
_tab_string["__TEXT_ExitGame"] = "退出游戏"
_tab_string["__TEXT_SorryForErro"] = "游戏出现错误，错误信息："
_tab_string["__TEXT_Quality"] = "品质"
_tab_string["__TEXT_PURCHASE_DESC"] = "获得氪石%d。"
_tab_string["__TEXT_PURCHASE"] = "充值"
_tab_string["__TEXT_WAITING_PURCHASE"] = "交易进行中..."
_tab_string["recharge_success"] = "购买成功，请前往【信箱】领取奖励"
_tab_string["recharge_success_short"] = "购买成功！"
_tab_string["ios_deal_ing"] = "上一个交易正在处理中！"
_tab_string["__TEXT_RewardLeftTime"] = "后过期"
_tab_string["__TEXT_Dat"] = "天"
_tab_string["__TEXT_Hour"] = "小时"
_tab_string["__TEXT_Hour_Short"] = "时"
_tab_string["__Minute"] = "分"
_tab_string["__Second"] = "秒"
_tab_string["MadelGift"] = "奖励"
_tab_string["SystemMail_Expired"] = "邮件即将过期！"
_tab_string["SystemMail_Conetnt"] = "请领取您的奖励。"
_tab_string["SystemMail_Endless"] = "在%s的%s中，您排行第%d名。以下玩家取得前8排名。"
_tab_string["__Get__"] = "领取"
_tab_string["ios_gamecoin_intro"] = "可用于购买道具"
_tab_string["ios_taskstone_intro"] = "可用于领取任务活跃度奖励"
_tab_string["__Yesterday"] = "昨日"
_tab_string["_TEXT_YEAR_"] = "年"
_tab_string["_TEXT_MONTH_"] = "月"
_tab_string["_TEXT_DAY_"] = "日"
_tab_string["__TEXT_SCIENTIST_ACHIEVEMENT1"] = "咖啡桌"
_tab_string["__TEXT_SCIENTIST_ACHIEVEMENT_INTRO1"] = "可在主基地展示咖啡桌。"
_tab_string["__TEXT_SCIENTIST_ACHIEVEMENT2"] = "布朗工作台"
_tab_string["__TEXT_SCIENTIST_ACHIEVEMENT_INTRO2"] = "可在主基地展示布朗工作台。"
_tab_string["__TEXT_SCIENTIST_ACHIEVEMENT3"] = "布朗工具架"
_tab_string["__TEXT_SCIENTIST_ACHIEVEMENT_INTRO3"] = "可在主基地展示布朗工具架。"
_tab_string["__TEXT_SCIENTIST_ACHIEVEMENT4"] = "议事会餐桌"
_tab_string["__TEXT_SCIENTIST_ACHIEVEMENT_INTRO4"] = "可在主基地展示议事会餐桌。"
_tab_string["__TEXT_SCIENTIST_DISHU_COIN"] = "游戏币"
_tab_string["__TEXT_SCIENTIST_DISHU_COIN_INTRODUCE"] = "可用于打地鼠游戏机"
_tab_string["__TEXT_TANKDEADTH_ACHIEVEMENT1"] = "一些残骸"
_tab_string["__TEXT_TANKDEADTH_ACHIEVEMENT_INTRO1"] = "可在主基地展示小型垃圾堆。"
_tab_string["__TEXT_TANKDEADTH_ACHIEVEMENT2"] = "一小堆残骸"
_tab_string["__TEXT_TANKDEADTH_ACHIEVEMENT_INTRO2"] = "可在主基地展示中型垃圾堆。"
_tab_string["__TEXT_TANKDEADTH_ACHIEVEMENT3"] = "一大堆残骸"
_tab_string["__TEXT_TANKDEADTH_ACHIEVEMENT_INTRO3"] = "可在主基地展示大型垃圾堆。"
_tab_string["__TEXT_TANKDEADTH_ACHIEVEMENT4"] = "触目惊心的残骸"
_tab_string["__TEXT_TANKDEADTH_ACHIEVEMENT_INTRO4"] = "可在主基地展示巨型垃圾堆。"
_tab_string["__TEXT_TANKDEADTH_ACHIEVEMENT5"] = "堆积如山的残骸"
_tab_string["__TEXT_TANKDEADTH_ACHIEVEMENT_INTRO5"] = "可在主基地展示终极垃圾堆。"
-------------------------------------------------------------

--走马灯相关
_tab_string["__TEXT_Get1"] = "获得"
_tab_string["__TEXT_COUNT"] = "个"
_tab_string["__TEXT_PVP_VS_DiffA"] = "简单"
_tab_string["__TEXT_PVP_VS_Diff1"] = "普通"
_tab_string["__TEXT_PVP_VS_Diff2"] = "困难"
_tab_string["__TEXT_PVP_VS_Diff3"] = "噩梦"
_tab_string["__TEXT_PVP_VS_Diff0"] = "难度"
_tab_string["__TEXT__In"] = "在"
_tab_string["__TEXT__De"] = "的"
_tab_string["__TEXT__OneVsOne"] = "单挑"
_tab_string["__TEXT_ITEM_TYPE_ORNAMENTS"] = "宝物"
_tab_string["hero"] = "英雄"
_tab_string["__TEXT_star"] = "星"
_tab_string["__TEXT__Slot"] = "孔"
_tab_string["__TEXT__UpgrateTo"] = "升到了"
_tab_string["__TEXT__BattleWin"] = "战胜了"
_tab_string["__TEXT_PVP_DRAGON"] = "魔龙"
_tab_string["__TEXT_PVP_Arena_Battle"] = "擂台赛"
_tab_string["__TEXT__OpenTagNotice1"] = "已开启，快和好友一决高下吧"
_tab_string["__TEXT__OpenTagNotice2"] = "已开启，快和好友组队挑战吧"
_tab_string["__TEXT__OpenTagNotice3"] = "为给您提供更好的游戏体验，游戏服务器将于"
_tab_string["__TEXT__OpenTagNotice4"] = "5:00"
_tab_string["__TEXT__OpenTagNotice5"] = "进行更新维护，本次维护预计需要5分钟。在服务器维护期间，您将无法登入游戏，给您带来的不便敬请谅解！"
_tab_string["__TEXT__UnlockedTowerAddones"] = "解锁了强化属性"
_tab_string["__TEXT_UNKOWN_ZSK"] = "未知战术卡"
_tab_string["__TEXT_UNKOWN_ITEM"] = "未知道具"
_tab_string["__TEXT_UNKOWN_HREO"] = "未知英雄"
_tab_string["__TEXT_UNKOWN_MAP"] = "未知地图"
_tab_string["__TEXT_UNKOWN_T"] = "未知塔"
_tab_string["__TEXT_SCROLL_NOTICE_UNLOCK"] = "解锁了"
_tab_string["__TEXT_SCROLL_NOTICE_WEAPON"] = "武器"
_tab_string["__TEXT_SCROLL_NOTICE_PET"] = "宠物"

-------------------------------------------------------------

--分享相关
_tab_string["__TEXT_Cant_Share_Net"] = "必须联网才能使用分享功能"
_tab_string["__TEXT_Cant_Share_Old_Version"] = "游戏版本过旧,无法分享\n版本需求:[%s]\n当前版本:[%s]\n请联网更新游戏到最新版本!"
_tab_string["__TEXT_Cant_Share_Platform"] = "当前平台暂不支持分享"
_tab_string["__TEXT_Share_Success"] = "确认中。。。感谢分享！\n小礼包过会就发放到邮件里！"

-------------------------------------------------------------

--战术技能卡材料开始

_tab_string["["] = "【"
_tab_string["]"] = "】"
_tab_string["__TEXT_SystemNotice"] = "系统公告"
_tab_string["__TEXT_ScriptsTooOld"] = "游戏有更新！ \n \n请重新启动游戏，进行自动更新！"

_tab_string["__TEXT_WanJia"] = "玩家"
_tab_string["request_errcode"]="错误码："
_tab_string["__TEXT_cheatPlayer"] = "您的游戏数据严重异常已无法进入游戏!"
_tab_string["__TEXT_SetPassWord"] = "设置密码"
_tab_string["__TEXT_SetNewPassWord"] = "设置新密码"
_tab_string["__TEXT_SetPassWordInfo"] = "请输入6位数字设定为当前密码"
_tab_string["__TEXT_SetPassWordRs_1"] = "设置密码成功"
_tab_string["__TEXT_SetPassWordRs_2"] = "设置密码失败"
_tab_string["__TEXT_manger"] = "账号管理"
_tab_string["__TEXT_GoToRecharge"] = "去充值"
_tab_string["guest"] = "战车"
_tab_string["guest_info1"] = "使用已有游戏账号来恢复游戏数据"
_tab_string["guest_check_in"] = "游戏账号登入"
_tab_string["Totoltopup"] = "累计充值"
_tab_string["HaveGetTodayReward"] = "已领取今日奖励！"

_tab_string["App_Download_CMSTG"] = "去苹果商店下载"
_tab_string["App_Comment_CMSTG"] = "前往苹果商店评论"
_tab_string["commentTitle2"] = "欢迎对游戏发表评论"

_tab_string["AndroidTestTip"] = "测试期间，暂不开放充值！"

--剧情对话文字
--_tab_string["__TEXT_SPEED_UP"] = "加速！"
_tab_string["__TEXT_HELP"] = "求助！"
_tab_string["__TEXT_BLOW"] = "炸开这里！"
_tab_string["__TEXT_WHERE_ARE_WE"] = "这么大的风暴，车\n都从天上掉下来了\n我们居然还活着"
_tab_string["__TEXT_I_DONOT_KNOWN"] = "这地方看起来很诡\n异，大家小心一点"
_tab_string["__TEXT_WHAT_THE_HELL"] = "快上车！"
_tab_string["__TEXT_GET_IN"] = "我来负责火力！"
_tab_string["__TEXT_LETS_FIGHT_BACK"] = "你不要点射，对付\n它们恐怕得按住连\n续射击"
_tab_string["__TEXT_WE_MADE_IT"] = "我们胜利了！"
_tab_string["__TEXT_FINALLY"] = "哦耶！"
_tab_string["__TEXT_ARE_WE_SAFE_NOW"] = "现在安全了吧？"
_tab_string["__TEXT_WTF"] = "我靠！！！"
_tab_string["__TEXT_AGAIN"] = "又来了个！"
_tab_string["__TEXT_GET_INT_GET_IN"] = "快！快上车！"
_tab_string["__TEXT_DO_NOT_PANIC_WE_ARE_ON_YOUR_SIDE"] = "别怕，别怕，\n我不是敌人。"
_tab_string["__TEXT_THEY_HAVE_ATTACKED_MANY_NEARTH_FACILITIES_OUTSIDE"] = "我和我的伙伴们也\n被困在这儿很久了"
_tab_string["__TEXT_WE_NEED_YOUR_FIRST_HAND_INFORMATION"] = "我们可以合作！\n黑龙我们也认识！"
_tab_string["__TEXT_IN_EXCHANGE_WE_WILL_HELP_YOU_TO_BEAT_THEM"] = "先带你们上飞船\n离开这里"
_tab_string["__TEXT_A_WAREHOUSE"] = "一个仓库？"
_tab_string["__TEXT_WE_SHOULD_GET_SOME_SUPPLY_FROM_IT"] = "我们可以在这里进行补给。"
_tab_string["__TEXT_LETS_TAKE_IT_OVER"] = "它是我们的了！"
_tab_string["__TEXT_SOLDIER_1"] = "经过刚才那一幕，\n看到会讲话的龙，\n也没什么稀奇了！"
_tab_string["__TEXT_SOLDIER_2"] = "你和那些怪物不是\n一伙的啰！？"
_tab_string["__TEXT_SOLDIER_3"] = "看你受了伤，我给\n你一个创口贴吧！"
_tab_string["__TEXT_BLACK_DRAGON_1"] = "看来我得救了！"
_tab_string["__TEXT_BLACK_DRAGON_2"] = "我有一个秘密基地\n但经常被附近挖矿\n的巨兽袭击。"
_tab_string["__TEXT_BLACK_DRAGON_3"] = "你们可以先去解决\n掉它。"
_tab_string["__TEXT_BLACK_DRAGON_4"] = "前往矿山寻找巨兽"
_tab_string["__TEXT_BLACK_DRAGON_5"] = "跟随黑龙去基地"
_tab_string["__TEXT_BLACK_DRAGON_6"] = "。。。。。。"
_tab_string["__TEXT_BLACK_DRAGON_7"] = "那就回赠给你们这\n2件东西，装配到\n车上可以增强火力"
_tab_string["__TEXT_BLACK_DRAGON_8"] = "你们是个什么组织\n报上名来！"
_tab_string["__TEXT_BLACK_DRAGON_9"] = "你们做的很好！"
_tab_string["__TEXT_BLACK_DRAGON_10"] = "作为回报我再赠予\n你们一件装备。"
_tab_string["__TEXT_WALL_E_1"] = "再坚持一下！"
_tab_string["__TEXT_CONSUME"] = "消耗"
_tab_string["__TEXT_TEMPORARY_NO"] = "暂时不用"
--_tab_string["__TEXT_Equip"] = "装备"
_tab_string["__TEXT_Exchange"] = "分解"
_tab_string["__TEXT_Change"] = "更换"
_tab_string["__TEXT_remove"] = "卸下"
_tab_string["__TEXT_PlayerName"] = "玩家名"
_tab_string["__TEXT_ShiftData0"] = "账号"
_tab_string["__TEXT_Follow"] = "跟随"
_tab_string["__TEXT_CHIP"] = "碎片"
_tab_string["__TEXT_ExchangeEquip"] = "装备批量分解"
_tab_string["__TEXT_EquipQuality1"] = "白色"
_tab_string["__TEXT_EquipQuality2"] = "蓝色"
_tab_string["__TEXT_EquipQuality3"] = "黄色"
_tab_string["__TEXT_EquipQuality4"] = "红色"

_tab_string["__TEXT_BUILD_INVALID_POINT"] = "该目标点不能建造塔"
_tab_string["__TEXT_BUILD_INVALID_ROAD"] = "该路面不能建造塔"
_tab_string["__TEXT_BUILD_COLLAPSE_UNIT"] = "目标点和单位重叠"
_tab_string["__TEXT_BUILD_COLLAPSE_TOWER"] = "目标点和附近建筑重叠"

_tab_string["__TEXT_CLICK_SCREEN_FINISH"] = "点击屏幕完成"
_tab_string["__TEXT_CLICK_SCREEN_CLOSE"] = "点击屏幕关闭"
_tab_string["__TEXT_CLICK_SCREEN_CONTINUE"] = "点击屏幕继续"
_tab_string["__TEXT_Page_AcreenSpeedUp"] = "点击屏幕加速"
_tab_string["__TEXT_TALENT_POINT"] = "天赋点"
_tab_string["__TEXT_TALENT_POINT_INTRODUCE"] = "可用于战车分配天赋点数。"
_tab_string["__TEXT_BUY_PET_HINT"] = "收取%d矿石，获得帮手"
_tab_string["__TEXT_TILI"] = "体力"
_tab_string["__TEXT_TILI_INTRODUCE"] = "可用于挑战关卡"
_tab_string["PVPChongShuaDaoJiShi_Shop"] = "%s后重刷"
_tab_string["__TEXT_Hour_Short"] = "时"
_tab_string["__Minute"] = "分"
_tab_string["__Second"] = "秒"
_tab_string["__TEXT_Reflash"] = "刷新"
_tab_string["__TEXT_Refresh_Item_Free"] = "是否立即刷新商品列表？"
_tab_string["__TEXT_Refresh_Item_Consume"] = "是否消耗20氪石立即刷新商品列表？"
_tab_string["__TEXT_Cancel"] = "取消"
_tab_string["__TEXT_OperationFail_ErrorCode"] = "%s失败！错误码: %d"
_tab_string["__TEXT_PVP_Operation"] = "操作"
_tab_string["ios_not_enough_game_coin"] = "氪石不足"
_tab_string["__TEXT_PARAP_INVALID"] = "参数错误"
_tab_string["ios_payment_fail"] = "购买失败"
_tab_string["ios_payment_success"] = "购买成功！"
_tab_string["ios_exchange_success"] = "兑换成功！"
_tab_string["__TEXT_TodayBuyItemUsedUp"] = "该商品今日购买次数已用完！"
_tab_string["__TEXT_TodayRefreshCountUsedUp"] = "今日刷新次数已用完！"
_tab_string["__TEXT_TodayExchangeCountUsedUp"] = "今日兑换次数已用完！"
_tab_string["__TEXT_NotEnoughTili"] = "体力不足"
_tab_string["__TEXT_MapNotPassPreevious"] = "通关前一个难度才能挑战"
_tab_string["__TEXT_MapUnlock"] = "本关未解锁"
_tab_string["__TEXT_PetWaKuangSendNumMax"] = "派遣宠物数量已达上限"
_tab_string["__TEXT_PetWaKuangUnlock"] = "宠物未解锁挖矿"
_tab_string["__TEXT_PetWaKuangInWork"] = "宠物正在挖矿"
_tab_string["__TEXT_PetWaKuangNotInWork"] = "宠物未在挖矿"
_tab_string["__TEXT_PetWaTiLiInSendNumMax"] = "派遣宠物数量已达上限"
_tab_string["__TEXT_PetWaTiLiUnlock"] = "宠物未解锁挖体力"
_tab_string["__TEXT_PetWaTiLiInWork"] = "宠物正在挖体力"
_tab_string["__TEXT_PetWaTiLiNotInWork"] = "宠物未在挖体力"
_tab_string["__TEXT_PetWaKuangNoNum"] = "无可领取氪石"
_tab_string["__TEXT_PetWaTiLiNoNum"] = "无可领取体力"
_tab_string["__TEXT_PetWaTiLiExpierMax"] = "体力已满"
_tab_string["__TEXT_Space_Wrench"] = "次元斩！"
_tab_string["__TEXT_Nice"] = "干得漂亮！"
_tab_string["__TEXT_DailyBaseTili"] = "每日基础产量"
_tab_string["__TEXT_DailyPetTili"] = "每日宠物产量"
_tab_string["__TEXT_Exchange"] = "兑换"
_tab_string["__TEXT_WeaponChestNumNotEnough"] = "武器宝箱数量不足"
_tab_string["__TEXT_TacticChestNumNotEnough"] = "战术宝箱数量不足"
_tab_string["__TEXT_PetChestNumNotEnough"] = "宠物宝箱数量不足"
_tab_string["__TEXT_EquipChestNumNotEnough"] = "装备宝箱数量不足"
_tab_string["__TEXT_NoPriority"] = "您没有权限进行此操作"
_tab_string["__TEXT_ExchangeTiLiReally"] = "是否消耗20氪石兑换10体力？"
_tab_string["__TEXT_Close"] = "关闭"
_tab_string["__TEXT_Close_Short"] = "关"
_tab_string["__TEXT_Open_Short"] = "开"
_tab_string["__TEXT_TaskStoneProgreeReward"] = "累计获得%d活跃度可领取奖励"
_tab_string["__TEXT_BAGLISTISFULL"] = "背包已满，无法领取道具"
_tab_string["__TEXT_BestStage"] = "层数"
_tab_string["__TEXT_MyRank"] = "我的排名"
_tab_string["__TEXT_MyBestStage"] = "我的层数"
_tab_string["__TEXT_MyBestWave"] = "我的波次"
_tab_string["__TEXT_TemporaryNone"] = "暂无"
_tab_string["__TEXT_Unknwon"] = "神秘属性"
_tab_string["__TEXT_TemporaryNoneRank"] = "暂无排名"
_tab_string["ios_err_prize_rewarded"] = "奖励已领取"
_tab_string["__GROUP_SERVER_ERROR_TYPE_NO_VALID_PARAM"] = "参数不合法"
_tab_string["__GROUP_SERVER_ERROR_TYPE_NO_TASK_FINISH"] = "未满足任务完成条件"
_tab_string["_TEXT_TASK_HAVE_FINISHED"] = "该任务已完成！"
--_tab_string["__TEXT_GIFT_CONTAIN"] = "礼包包含以下奖励："
_tab_string["ios_err_rename"] = "您输入的名字与已有玩家重名"
_tab_string["ios_err_unknow"] = "未知错误"
_tab_string["__TEXT_send"] = "发送"
_tab_string["__TEXT_CanUseSpecialCharacters"] = "包含不可用字符"
_tab_string["__TEXT_DragDownToLoadMore"] = "向下拖动以加载更多"
_tab_string["__TEXT_CommentIsBottom"] = "评论已经到底"
_tab_string["__TEXT_Rmb"] = "元"
_tab_string["__TEXT_GiftCode"] = "礼包兑换"
_tab_string["__TEXT_PetFollowNumMax"] = "出战宠物已达上限，请提升战车的相关猎人天赋"

--_tab_string["__TEXT_VIPN_FILI"] = "VIP%d福利"
_tab_string["vipOneOffReward20010"] = "【VIP5奖励】"
_tab_string["vipOneOffReward20017"] = "【VIP3奖励】"
_tab_string["vipOneOffReward20018"] = "【VIP4奖励】"


--瓦力剧情文字
_tab_string["__TEXT_NPC1"] = "利用道具技能，改变圆台上的\n数字，使所有数字相加等于32"
_tab_string["__TEXT_NPC2"] = "敌人出现了！"
_tab_string["__TEXT_NPC3"] = "经过一阵颠簸，你和瓦力被传\n送到了公理号飞船之上。"
_tab_string["__TEXT_NPC4"] = "伊芙"
_tab_string["__TEXT_NPC5"] = "瓦力要去救伊芙"
_tab_string["__TEXT_NPC6"] = "瓦力，是你吗？"
_tab_string["__TEXT_NPC7"] = "我们必须找回植物样本"
----已放服务器的文字，下面的不生效
-----------------------------------------------------------------------------------------------


--_tab_string["taskIntroduce"] = "黑龙任务"
--_tab_string["taskIntroduce1"] = "黑龙每天都会发布日常任务，每周会发布一次周任务，累计的任务活跃度可以换取额外奖励，每周四结束时刷新【每周任务】，并重置任务活跃度"

--_tab_string["__TEXT_PurchaseMoneyGet"] = "累计与黑龙交易%d氪石可获得"

--_tab_string["clearspider04"] = "击败矿山巨兽可进入"
--_tab_string["gophertestplay"] = "您的试玩成绩 %d/%d\n\n投币玩其它难度获得高额奖励"
--_tab_string["gophernoreward"] = "您本次的成绩为 %d/%d|n |n没能获得奖励，就差一点了，加油！"

--_tab_string["__TEXT_allRmb0"] = "黑龙之家"
--_tab_string["__TEXT_allRmb2"] = "已与黑龙交易氪石 %d"


--_tab_string["TEXT_StarCount"] = "累计获得 %d 颗星星"
--_tab_string["TEXT_RescueScientist"] = "累计营救 %d 个工程师"
--_tab_string["TEXT_TankDeadthCount"] = "战车累计损毁 %d 次"



--_tab_string["vipStr1"] = "仓库6页"
--_tab_string["vipStr2"] = "每天获得一个黑龙快递箱子"
--_tab_string["vipStr3"] = "每天获得3个地鼠游戏币"
--_tab_string["vipStr4"] = "仓库7页"
--_tab_string["vipStr5"] = "每天获得一个高级黑龙快递箱子"
--_tab_string["vipStr6"] = "每天获得6个地鼠游戏币"
--_tab_string["vipStr7"] = "仓库8页"
--_tab_string["vipStr8"] = "获得2000个弹射球碎片"
--_tab_string["vipStr9"] = "战车升级经验提高10%"
--_tab_string["vipStr10"] = "仓库9页"
--_tab_string["vipStr11"] = "获得2000个巨浪碎片"
--_tab_string["vipStr13"] = "仓库10页"
--_tab_string["vipStr14"] = "获得100个终结者机枪碎片"
--_tab_string["vipStr15"] = "每局游戏可以召唤一个铁人雕像"

--_tab_string["vipStr16"] = "每日体力恢复至70"
--_tab_string["vipStr17"] = "每日限时商店刷新次数+1"
--_tab_string["vipStr18"] = "免费解锁蜘蛛坦克皮肤1"
--_tab_string["vipStr19"] = "战车升级经验提高15％"
--_tab_string["vipStr20"] = "每日体力恢复至80"
--_tab_string["vipStr21"] = "每日限时商店刷新次数+2"
--_tab_string["vipStr22"] = "免费解锁蜘蛛坦克皮肤2"
--_tab_string["vipStr23"] = "战车升级经验提高20％"
--_tab_string["vipStr24"] = "每日限时商店刷新次数+3"
--_tab_string["vipStr25"] = "战车升级经验提高25％"
--_tab_string["vipStr26"] = "每日限时商店刷新次数+4"
--_tab_string["vipStr27"] = "宠物可派遣数量+1"
--_tab_string["vipStr28"] = "战车升级经验提高30％"
--_tab_string["vipStr29"] = "每日限时商店刷新次数+5"
--_tab_string["vipStr30"] = "宠物可派遣数量+2"
--_tab_string["vipStr31"] = "每日体力恢复至90"
--_tab_string["vipStr32"] = "每日体力恢复至100"
--_tab_string["vipStr33"] = "每日体力恢复至110"


--_tab_string["vipStr101"] = "需拥有通量电容器驱动"
--_tab_string["vipStr102"] = "需拥有量子计算机驱动"
--_tab_string["vipStr103"] = "需拥有铁人之心来驱动"
-----------------------------------------------------------------------------------------------




--战车中英文切换相关文字
_tab_string["CopyDir_Loading_Info"] = "设置游戏运行环境…"
_tab_string["Updating_Loading_Info"] = "正在更新…"
_tab_string["GameStart_Loading_Info"] = "正在加载游戏…"
_tab_string["NetInfo"] = "网络信息"
_tab_string["VersionInfo"] = "版本信息"
_tab_string["GameOptionNet"] = "联网模式"
_tab_string["GameOptionSa"] = "进入游戏"
_tab_string["GameOptionBbs"] = "去写心得"
_tab_string["GameOptionLanguage"] = "语言设置"
_tab_string["Version_Local_Label"] = "当前版本		"
_tab_string["Version_Local_Version"] = "未知"
_tab_string["Version_Server_Label"] = "		" --"最新版本		"
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
_tab_string["Main_Runing_NetWorkType1"] = "网络类型   无线网络"
_tab_string["Main_Runing_NetWorkType2"] = "网络类型   移动网络"
_tab_string["Main_Runing_GetAnnouncement"] = "获取公告信息......"
_tab_string["Main_Runing_GetLocalInfo"] = "获取本地版本信息......"
_tab_string["Main_Runing_GetNetInfo"] = "获取网络类型......"
_tab_string["Main_Runing_GetServerInfo"] = "获取服务器版本信息......"
_tab_string["Main_Runing_GetInfo"] = "检查游戏最新文本"
_tab_string["Main_Runing_GetInfo11"] = "检查游戏最新文本中"
_tab_string["Main_Runing_GetInfo88"] = "检查游戏最新文本…"
_tab_string["Main_Runing_GetInfo99"] = "检查游戏最新文字"
_tab_string["Main_Runing_End"] = ""
_tab_string["Exit_Info"] = "更新完成，请重新启动游戏!"
_tab_string["Exit_Ack"] = "确定"
_tab_string["Exit_Wait"] = "稍后"
_tab_string["Exit_Now"] = "退出"
_tab_string["GameSettingInfo"] = "语言设置在重启游戏后生效"
_tab_string["Confirm_Info_Up_"] = "最新游戏文字包"
_tab_string["Confirm_Enter"] = "进入游戏"
_tab_string["Confirm_Leave"] = "确定"
_tab_string["Confirm_Update_Later"] = "暂不更新"
_tab_string["Version_Server_Size"] =  "		" --"版本大小		"
_tab_string["on_loading"] = "加载中..."
_tab_string["Official_Announcement"] = "官方公告"

_tab_string["ios_err_network_cannot_conn2"] = "正在尝试连接服务器..."
_tab_string["__TEXT_Back_Login"] = "返回登陆"
_tab_string["__TEXT_Try_Connect"] = "尝试重连"
_tab_string["__TEXT_Buy"] = "购买"
_tab_string["lowconfigmode"] = "低帧流畅模式"
_tab_string["lowconfig"] = "低帧"
_tab_string["CurrentNotGet"] = "未获得"
_tab_string["restart"] = "再试一次"
_tab_string["not_enough"] = "不足"
_tab_string["language_setting"] = "设置语言"
_tab_string["music_on"] = "音乐：关"
_tab_string["music_off"] = "音乐：开"
_tab_string["screen_setting"] = "屏幕锁定"
_tab_string["screen_horizontal"] = "横屏锁定"
_tab_string["screen_vertical"] = "竖屏锁定"
_tab_string["screen_unlock"] = "自动旋转"
_tab_string["gameperspective"] = "游戏视角"
_tab_string["tankshowhpbar"] = "战车显血"
_tab_string["farview"] = "远"
_tab_string["mediumview"] = "中"
_tab_string["nearview"] = "近"
_tab_string["unlock"] = "解锁"
_tab_string["rankboard"] = "排行榜"
_tab_string["rank"] = "排名"
_tab_string["to_rate"] = "【游戏讨论】"
_tab_string["rate_game"] = "来看看最新最热门的话题吧！"
_tab_string["supply_drop"] = "补给箱"
_tab_string["get"] = "领取"
_tab_string["receive"] = "领取"
_tab_string["haveget"] = "已领取"
_tab_string["confirm"] = "确认"
_tab_string["your_name"] = "请回答"
_tab_string["new_name"] = "更换名称"
_tab_string["rebirth_for_free"] = "免费复活"
_tab_string["upgrade"] = "升级"
_tab_string["max_lv"] = "最高等级"
_tab_string["not_ready"] = "暂未开放"
_tab_string["leave"] = "离开"
_tab_string["returnlogin"] = "登录管理"
_tab_string["continue"] = "继续"
_tab_string["rebirth"] = "继续游戏"
_tab_string["nextStage"] = "下一关"
_tab_string["continuegame"] = "继续游戏"
_tab_string["start"] = "开始冒险"
_tab_string["exit_game"] = "结束冒险"
_tab_string["__TEXT_ResetLevel"] = "重玩本关"
_tab_string["premium_supply"] = "超级补给包"
_tab_string["game_tips1"] = "游戏中可以拾取到五花八门的\n技能卡（炸弹）\n卡片升级可以提升威力"
_tab_string["options_left"] = "可改造选项"
_tab_string["damage"] = "伤害"
_tab_string["second"] = "秒"
_tab_string["unlock_area"] = "击败后解锁该区域"
_tab_string["unlock_area2"] = "购买后解锁该区域"
_tab_string["ok"] = "好的"
_tab_string["wattingPlease"] = "网络异常，请稍后再试!"
_tab_string["restoredatasuccessful"] = "恢复成功"
_tab_string["keepnetworkconnected"] = "请保持网络连接"
_tab_string["restoredatatext1"] = "恢复之前的游戏数据"
_tab_string["restoredatatext2"] = "放弃之前的游戏数据，重新开始"
_tab_string["unlock_petarea"] = "解锁宠物区"
_tab_string["achievement"] = "成就"
_tab_string["maxkill"] = "最大连杀数"
_tab_string["batter"] = "连击"
_tab_string["clearance"] = "通关"
_tab_string["pet"] = "宠物"
_tab_string["rolling"] = "碾压"
_tab_string["onepass"] = "一命闯关"
_tab_string["pet_criteria"] = "同时携带 #NUM 个宠物"
_tab_string["rolling_criteria"] = "一局碾压 #NUM 个怪"
_tab_string["onepass_criteria"] = "一命闯过 #NUM 关"
_tab_string["errcode"] = "错误码"
_tab_string["__ITEM_PANEL__PAGE_XILIAN"] =  "改造"
_tab_string["__ITEM_PANEL_MINI__XILIAN_INTRO"] = "随机生成装备孔的新属性"
_tab_string["__TEXT_TodayLockXiLian"] = "该装备今日还可以锁孔改造"
_tab_string["__TEXT_YouCanForgedCount1"] = "次"
_tab_string["__TEXT_Page_Equip"] = "装备"
_tab_string["__TEXT_Page_Equip2"] = "特惠装备"
_tab_string["__ITEM_PANEL__LOCK"] = "锁定"
_tab_string["__TEXT_ChipNotEnough"] = "芯片不足！"
_tab_string["__TEXT_Cant_XiLianRequireAtLeastOneSlot_Net"] = "改造需要至少一条属性"
_tab_string["__TEXT_TodayLockXiLianUsedUp"] = "该装备今日锁孔改造次数已用完，不能继续锁孔！"
_tab_string["__TEXT_XiLianInvalidUID"] = "神器来源未知"

_tab_string["__TEXT_get_after_upgrade"] = "升级后效果"
_tab_string["__TEXT_cur_get"] = "当前效果"
_tab_string["__TEXT_nextlv_get"] = "下一级效果"
_tab_string["__TEXT__AccountTip3"] = "您的账号已在其他设备登录"
_tab_string["__TEXT__AccountTip4"] = "请您重新登录"
_tab_string["__TEXT__AccountTip5"] = "登录超时"

_tab_string["__TEXT_UNLOCK_SUCCESS"] = "解锁成功！"
_tab_string["__TEXT_STARUP_SUCCESS"] = "升星成功！"
_tab_string["__TEXT_LEVELUP_SUCCESS"] = "升级成功！"
_tab_string["__TEXT_SEND_SUCCESS"] = "派遣成功！"
_tab_string["__TEXT_CANCEL_SEND_SUCCESS"] = "取消成功！"
_tab_string["__TEXT_MainInterface"] = "主界面" 
_tab_string["__TEXT__Account"] = "账号"
_tab_string["__TEXT__Password"] = "密码"
_tab_string["__TEXT__AutoRegister"] = "一键注册"
_tab_string["__TEXT__Login"] = "登录"
_tab_string["__TEXT__Exchange"] = "礼包兑换"
_tab_string["__TEXT_Enter_Gift"] = "请输入您的兑换码"
_tab_string["enter_gift_8"] = " 8位数字或字符"
_tab_string["gift_err_not_exist"]="该礼品码不存在"
_tab_string["gift_err_only_use_once"]="同类型礼品码只能领取1次"
_tab_string["gift_err_cannot_use"]="该礼品码已经被使用"
_tab_string["__TEXT_All_get"] = "您获得了"
_tab_string["ios_prize_from_system"] = "来自系统的奖励"
_tab_string["ios_score"] = "水晶"
_tab_string["__TEXT_DebrisNotEnough"] = "碎片不足"
_tab_string["__UPGRADEBFSTAR_LESSLEVEL"] = "等级不足"
_tab_string["__UPGRADEBFLEVEL_LESSSTAR"] = "星级不足"
_tab_string["__UPGRADEBFLEVEL_CANT"] = "已升到最大等级"
_tab_string["__UPGRADEBFSTAR_CANT"] = "已升到最大星级"
_tab_string["__TEXT__LeiJi"] = "累计"
_tab_string["__TEXT_CONSUME"] = "消耗"
_tab_string["__TEXT_TotalPurchaseMoney"] = "购买%d氪石"
_tab_string["__TEXT_Agree"] = "同意"
_tab_string["__TEXT_NoAgree"] = "不同意"
_tab_string["__TEXT_TASK_FINISH_ALL"] = "任务已完成"
_tab_string["__TEXT__AccountTip"] = "登录"
_tab_string["__TEXT__ItemBaseAttr"] = "[基础属性]:"
_tab_string["__TEXT__ItemSlotAttr"] = "[改造属性]:"
_tab_string["__TEXT__ItemProbablityAttr"] = "以下%d个属性随机%s个"
_tab_string["__SHENQI_CRTSTAL"] = "芯片"
_tab_string["__SHENQI_CRTSTAL_INTRODUCE"] = "可用于装备改造。"
_tab_string["__TEXT_App_Comment"] = "来讲2句"
_tab_string["__TEXT_commentInfo1"] = "这次我们从三国的题材中跳了出来，\n为你献上一款完全不同的作品！"
_tab_string["__TEXT_commentInfo2"] = "枪林弹雨之下过关斩将，铁甲战车的科幻冒险！"
_tab_string["__TEXT_commentInfo3"] = "本作还在持续的改进完善中\n欢迎发表各种真实感受和意见！\n这对我们就是最佳的鼓励！"
_tab_string["__TEXT_commentInfo4"] = "x100，一点心意，一小会以后会奉上！"
_tab_string["__TEXT_Cant_BagItemIsFull_Net1"] = "仓库已满，请清理后重新登录，才能获取剩余神器。"
_tab_string["__TEXT_TemporaryNoneMail"] = "暂无邮件"
_tab_string["__TEXT_TemporaryNoneActivity"] = "暂无活动"
_tab_string["__TEXT_TemporaryNoneMailContent"] = "暂无邮件正文"
_tab_string["__TEXT_TAKEALL_MAIL"] = "全部领取"
_tab_string["__TEXT_IS_TAKEREWARD_ALLMAIL"] = "是否领取全部邮件奖励？"
_tab_string["__TEXT_MAILTYYE_01"] = "游戏更新"
_tab_string["__TEXT_MAILTYYE_02"] = "活动奖励"
_tab_string["__TEXT_MAILTYYE_03"] = "游戏通知"
_tab_string["__TEXT_MAILTYYE_04"] = "空投补给"
_tab_string["__TEXT_MAILTYYE_05"] = "感谢信"
_tab_string["__TEXT_MAILTYYE_06"] = "氪石萃取"
_tab_string["__TEXT_MAILTYYE_07"] = "分享奖励"
_tab_string["__TEXT_MAILTYYE_08"] = "排名奖励"
_tab_string["__TEXT_REWARD_TAKE_ALL"] = "已领取全部奖励"
_tab_string["__TEXT_UGCEDIT_HORIZONTAL"] = "横屏模式不支持此功能"
_tab_string["__TEXT_Confirm_delREquip"] = "你确定要分解红色装备吗？"

_tab_string["gift3_1"] = "获赠透射枪一把，具有穿透效果并且可以击退敌人"
_tab_string["gift3_2"] = "战车复活时，不再消耗水晶矿石"
_tab_string["gift3_3"] = "解锁宠物区域，可以选择长期跟随的宠物"
_tab_string["__TEXT_RankNum"] = "排名"
_tab_string["__TEXT_comment"] = "评论"
_tab_string["__TEXT_collapse"] = "收起"
_tab_string["__Reward__"] = "奖励"
_tab_string["__TEXT_PLEASE_SELECT_TECHONOGY_CARD"] = "请选择一张科技效果"
_tab_string["__SecondToAutoSelect"] = "秒后自动选择"
_tab_string["__RE_EXCHANGE2__"] = "重抽"
_tab_string["__TEXT_Cant_Redraw_ThisGame"] = "本局重抽次数已用完！"
_tab_string["__TEXT_PAGE_BAG"] = "仓库"
_tab_string["__TEXT_PAGE_LASTMAP"] = "最后战役"
_tab_string["__TEXT_PAGE_SHOP2"] = "售货机"
_tab_string["__TEXT_PAGE_DEBRIS"] = "碎片合成"
_tab_string["__TEXT_PAGE_DRAGON"] = "黑龙洞窟"
_tab_string["__TEXT_PAGE_EQUIPMENT"] = "改造中心"
_tab_string["__TEXT_WaitTotalment"] = "等待结算"
_tab_string["__TEXT_TASK_RANDOMMAP_STAGE"] = "抵达%d-%d"
_tab_string["__TEXT_TASK_QIANSHAOZHENDI_WAVE"] = "抵达第%d波"
_tab_string["__TEXT_TASK_WEAOON_UNLOCK_NUM"] = "解锁%d个武器"
_tab_string["__TEXT_TASK_PET_UNLOCK_NUM"] = "解锁%d个宠物"
_tab_string["__TEXT_TASK_TOTALSTAR_NUM"] = "获得%d颗星星"
_tab_string["__TEXT_AppVersionTooOld_Download"] = "您的应用程序版本太旧，请从商店更新至最新版本！"
_tab_string["ios_pruchase_connect_ios"] = "内购条目准备中"

-------------------------------------------------------------
_tab_string["txt_debug"] = "测试通用文字"
-------------------------------------------------------------




-------------------------------------------------------------
--武器字符串（通用）
_tab_string["txt_gun_1"] = "机枪碎片"
_tab_string["txt_gun_2"] = "散弹枪碎片"
_tab_string["txt_gun_3"] = "反弹光球碎片"
_tab_string["txt_gun_4"] = "喷火枪碎片"
_tab_string["txt_gun_5"] = "透射枪碎片"
_tab_string["txt_gun_6"] = "雷神之锤碎片"
_tab_string["txt_gun_7"] = "毒液枪碎片"
_tab_string["txt_gun_8"] = "缩小枪碎片"
_tab_string["txt_gun_9"] = "反弹光线碎片"
_tab_string["txt_gun_10"] = "冲击波碎片"
_tab_string["txt_gun_11"] = "火箭枪碎片"
_tab_string["txt_gun_12"] = "导弹枪碎片"
_tab_string["txt_gun_13"] = "终结者碎片"
_tab_string["txt_gun_14"] = "流浪者碎片"





-------------------------------------------------------------
--装备字符串（通用）

_tab_string["txt_sjld"] = "水晶雷达"
_tab_string["txt_ztdj"] = "装填电机"
_tab_string["txt_dplg"] = "刀片轮毂"
_tab_string["txt_fyzj"] = "反应装甲"
_tab_string["txt_wlyq"] = "涡轮引擎"
_tab_string["txt_hjzj"] = "合金装甲"
_tab_string["txt_fhzj"] = "防火装甲"
_tab_string["txt_hkxp"] = "火控芯片"
_tab_string["txt_sjld_test"] = "超级水晶雷达"
_tab_string["txt_dplg_test"] = "超级刀片轮毂"
_tab_string["txt_hkxp_test"] = "超级火控芯片"
--_tab_string["txt_ftjp"] = "反弹镜片"
_tab_string["txt_sdj"] = "输弹机"
_tab_string["txt_cwzl"] = "修理站"
_tab_string["txt_zjd"] = "振金盾"
_tab_string["txt_ysj"] = "元素剑"
_tab_string["txt_crit_shoot"] = "射击雷管"
_tab_string["txt_crit_frozen"] = "冰冻雷管"
_tab_string["txt_crit_fire"] = "火焰雷管"
_tab_string["txt_crit_equip"] = "暴击雷管"
_tab_string["txt_crit_hit"] = "击退雷管"
_tab_string["txt_crit_blow"] = "飓风雷管"
_tab_string["txt_crit_poison"] = "毒液雷管"
_tab_string["txt_crit_bushoujia"] = "捕兽夹"
_tab_string["txt_crit_tianwang"] = "天网"

--【测试装备】
_tab_stringI[25] = {"水晶","","获得一定数量的水晶"}
_tab_stringI[26] = {"体力","","获得一定数量的体力"}
_tab_stringI[27] = {"氪石","","获得一定数量的氪石"}

_tab_stringI[20000] = {"王尼玛","测试专用装备，真是太厉害了..."}

--装备字符串【正式】
--20100~20150白
_tab_stringI[20100] = {"感应装置Ⅰ",""}
_tab_stringI[20101] = {"水晶雷达Ⅰ",""}
_tab_stringI[20102] = {"装填电机Ⅰ",""}
_tab_stringI[20103] = {"刀片轮毂Ⅰ",""}
_tab_stringI[20104] = {"反应装甲Ⅰ",""}
_tab_stringI[20105] = {"涡轮引擎Ⅰ",""}
_tab_stringI[20106] = {"合金装甲Ⅰ",""}
_tab_stringI[20107] = {"防火隔板",""}
_tab_stringI[20108] = {"防电隔板",""}
_tab_stringI[20109] = {"防毒隔板",""}
_tab_stringI[20110] = {"修理装置Ⅰ",""}
_tab_stringI[20111] = {"输弹机Ⅰ",""}
_tab_stringI[20112] = {"毒液弹匣",""}
_tab_stringI[20113] = {"冰霜弹匣",""}
_tab_stringI[20114] = {"飓风弹匣",""}
_tab_stringI[20115] = {"烈焰弹匣",""}
_tab_stringI[20116] = {"穿透弹匣",""}
_tab_stringI[20117] = {"暴击弹匣",""}



--20100~20150白--高级
_tab_stringI[20121] = {"水晶探测器",""}
_tab_stringI[20122] = {"改良装填电机",""}
_tab_stringI[20123] = {"焰形尖刺",""}
_tab_stringI[20124] = {"巧克力披甲",""}
_tab_stringI[20125] = {"新型涡轮引擎",""}
_tab_stringI[20126] = {"钛合金装甲",""}
_tab_stringI[20127] = {"水冷装置",""}
_tab_stringI[20128] = {"绝缘板",""}
_tab_stringI[20129] = {"防毒面具",""}
_tab_stringI[20130] = {"宠物医疗包",""}
_tab_stringI[20131] = {"改良输弹机",""}

_tab_stringI[20132] = {"仿生芯片A",""}
_tab_stringI[20133] = {"仿生芯片B",""}
_tab_stringI[20134] = {"仿生芯片C",""}
--20200~20300蓝
_tab_stringI[20200] = {"感应装置Ⅱ",""}
_tab_stringI[20201] = {"高能水晶雷达",""}
_tab_stringI[20202] = {"装填电机Ⅱ",""}
_tab_stringI[20203] = {"刀片轮毂Ⅱ",""}
_tab_stringI[20204] = {"反应装甲Ⅱ",""}
_tab_stringI[20205] = {"涡轮引擎Ⅱ",""}
_tab_stringI[20206] = {"合金装甲Ⅱ",""}
_tab_stringI[20207] = {"防火装甲",""}
_tab_stringI[20208] = {"防电装甲",""}
_tab_stringI[20209] = {"防毒装甲",""}
_tab_stringI[20210] = {"修理装置Ⅱ",""}
_tab_stringI[20211] = {"输弹机Ⅱ",""}
_tab_stringI[20212] = {"火控芯片","增加2侧射击效果， 攻击 + 2%"}
_tab_stringI[20213] = {"装填电机",""}

--20200~20300蓝--高级
_tab_stringI[20214] = {"老旧的布雷机","每6秒在原地布置1枚地雷。"}
_tab_stringI[20215] = {"加速装置","每过25秒提升移动速度，持续3秒。"}
_tab_stringI[20216] = {"宝石光剑","每过10秒向前方发射剑气。"}
_tab_stringI[20217] = {"闪电发生器","每过12秒，向附近敌人发射一道能连续弹射的闪电。"}
_tab_stringI[20218] = {"毒气","每过12秒散发小范围的毒气攻击附近敌人。"}
_tab_stringI[20219] = {"简易灭火器","每过5秒扑灭附近火焰。"}

_tab_stringI[20220] = {"战斗手环A",""}
_tab_stringI[20221] = {"战斗手环B",""}
_tab_stringI[20222] = {"战斗手环C",""}

--20300~20400黄
_tab_stringI[20300] = {"感应装置Ⅲ",""}
_tab_stringI[20301] = {"量子水晶雷达",""}
_tab_stringI[20302] = {"装填电机Ⅲ",""}
_tab_stringI[20303] = {"刀片轮毂Ⅲ",""}
_tab_stringI[20304] = {"反应装甲Ⅲ",""}
_tab_stringI[20305] = {"涡轮引擎Ⅲ",""}
_tab_stringI[20306] = {"合金装甲Ⅲ",""}
_tab_stringI[20307] = {"高级防火装甲",""}
_tab_stringI[20308] = {"高级防电装甲",""}
_tab_stringI[20309] = {"高级防毒装甲",""}
_tab_stringI[20310] = {"修理装置Ⅲ",""}
_tab_stringI[20311] = {"输弹机Ⅲ",""}
_tab_stringI[20312] = {"布雷机","每4秒在原地布置1枚地雷。"}
_tab_stringI[20313] = {"骤雨","使用机枪或霰弹枪攻击时有概率发射巨量子弹。"}
_tab_stringI[20314] = {"风刃","每过6秒向前方发射剑气。"}
_tab_stringI[20315] = {"氮气加速装置","每过15秒提升移动速度，持续3秒。"}
_tab_stringI[20316] = {"飞星","使用机枪或霰弹枪攻击时额外向前方随机角度射出子弹。"}
_tab_stringI[20317] = {"火箭发射器","每过8秒发射多枚火箭弹。"}
_tab_stringI[20318] = {"霜冻之手","每过9秒向前方发射冰冻弹。"}
_tab_stringI[20319] = {"毒瘴","每过12秒散发毒气攻击附近敌人。"}
_tab_stringI[20320] = {"声波","每过7秒发动大范围的声波攻击敌人。"}
_tab_stringI[20321] = {"毒液轮","移动时在地面留下毒液。"}
_tab_stringI[20322] = {"车载灭火器","每过3秒扑灭附近火焰。"}

_tab_stringI[20323] = {"智能手环",""}
_tab_stringI[20324] = {"远程控制器",""}



--20400~20500红装
_tab_stringI[20400] = {"寒渊","每过12秒创造一个奇点，将附近敌人吸入其中。","获取方式\n开启装备宝箱和神器宝箱"}
_tab_stringI[20401] = {"光幕","每过15秒获得一个护盾。","获取方式\n开启神器宝箱"}
_tab_stringI[20402] = {"原子切割","每过7秒向四周发射剑气。","获取方式\n开启装备宝箱和神器宝箱"}
_tab_stringI[20403] = {"超合金装甲","战车生命值低于30%时装甲提升30。","获取方式\n开启装备宝箱和神器宝箱"}
_tab_stringI[20404] = {"超合金轮毂","刀片伤害提升30%。","获取方式\n开启装备宝箱和神器宝箱"}
_tab_stringI[20405] = {"暴风雨","使用机枪或霰弹枪攻击时额外向两侧发射大量子弹。","获取方式\n开启装备宝箱和神器宝箱"}

_tab_stringI[20406] = {"猩红闪电","提升30%雷神之锤的伤害和2次弹射次数。","获取方式\n开启神器宝箱"}
_tab_stringI[20407] = {"地狱火","使用火焰喷射器攻击时额外向两侧发出威力较小的火焰。","获取方式\n开启神器宝箱"}
_tab_stringI[20408] = {"方舟核心","","获取方式\n开启神器宝箱"}
_tab_stringI[20409] = {"全自动布雷机","每2秒在原地布置1枚地雷。","获取方式\n开启装备宝箱和神器宝箱"}
_tab_stringI[20410] = {"绝对零度","每过7秒向前方发射多枚冰冻弹。","获取方式\n开启神器宝箱"}
_tab_stringI[20411] = {"量子玫瑰","每过9秒将附近的敌人变小，持续3秒。","获取方式\n开启神器宝箱"}

_tab_stringI[20412] = {"超新星","弹射球击中敌人时引发剧烈爆炸。","获取方式\n开启装备宝箱和神器宝箱"}
_tab_stringI[20413] = {"震荡波","使用脉冲枪或缩小枪攻击时引发震荡波推开敌人。","获取方式\n开启装备宝箱和神器宝箱"}
_tab_stringI[20414] = {"极光","提升30%透射枪和反弹光线的伤害。","获取方式\n开启装备宝箱和神器宝箱"}
_tab_stringI[20415] = {"奇美拉","提升30%毒液枪的伤害。","获取方式\n开启装备宝箱和神器宝箱"}
_tab_stringI[20416] = {"瘟疫使者","每过9秒散发大范围的毒气攻击附近敌人。","获取方式\n开启神器宝箱"}

_tab_stringI[20417] = {"次声波炸弹","手雷能引发震荡波。","获取方式\n开启装备宝箱和神器宝箱"}
_tab_stringI[20418] = {"风火轮","移动时留下火焰灼烧附近的敌人。","获取方式\n开启装备宝箱和神器宝箱"}
_tab_stringI[20419] = {"智能灭火装置","持续扑灭附近火焰。","获取方式\n开启装备宝箱和神器宝箱"}
_tab_stringI[20420] = {"自动爆破机","自动爆破附近的看守所、精炼厂、平房。","获取方式\n开启装备宝箱和神器宝箱"}
--_tab_stringI[20420] = {"火神炮","攻击时额外发射一枚火箭弹\n同类效果只会生效一个。","获取方式\n开启装备宝箱和神器宝箱"}
--_tab_stringI[20406] = {"闪电风暴","每过3秒，向附近敌人发射一道能连续弹射的闪电。","获取方式\n开启装备宝箱和神器宝箱"}
_tab_stringI[20421] = {"意智宝玉","","获取方式\n开启神器宝箱"}
_tab_stringI[20422] = {"基因拟态酶","通过神像获得宠物时，有较小概率额外复制1个相同的宠物。","获取方式\n开启神器宝箱"}---旧

_tab_stringI[20480] = {"闪电风暴","每过3秒，向附近敌人发射一道能连续弹射的闪电。","获取方式\n购买12元礼包"}
_tab_stringI[20481] = {"便携式机枪塔","架设一台便携机枪帮助你战斗，最多持续12秒。","获取方式\n购买98元礼包"}
_tab_stringI[20482] = {"羽蛇神","","获取方式\n购买198元礼包"}
_tab_stringI[20483] = {"白昼","每过12秒，发射大量以自身为中心，旋转扫射的光球。","获取方式\n购买25元礼包"}
_tab_stringI[20484] = {"基因拟态酶","通过神像获得宠物时，有较小概率额外复制1个相同的宠物。","获取方式\n购买45元礼包"}---新

-------------------------------------------------------------
--战术卡字符串（通用）
_tab_string["txt_tactics_card"] = "战术卡碎片"
_tab_string["txt_tactics_card_introduce"] = "可用于解锁和升级战术卡。"



-------------------------------------------------------------
--宠物字符串（通用）
_tab_string["txt_pet"] = "宠物碎片"
_tab_string["txt_pet_introduce"] = "可用于解锁和升级宠物。"

-------------------------------------------------------------
--宠物字符串（通用）
_tab_string["txt_weapon"] = "武器碎片"
_tab_string["txt_weapon_introduce"] = "可用于解锁和升级武器。"

-------------------------------------------------------------
--聊天军团字符串（通用）
_tab_string["__TEXT_MAINUI_BTN_HERO"] = "点将台"
_tab_string["__TEXT_MAINUI_BTN_TACITC"] = "战术卡"
_tab_string["__TEXT_MAINUI_BTN_MISSION"] = "任务活动"
_tab_string["__TEXT_MAINUI_BTN_CHALLENGE"] = "挑战台"
_tab_string["__TEXT_MAINUI_BTN_ITEM"] = "道具"
_tab_string["__TEXT_MAINUI_BTN_MAIL"] = "邮件"
_tab_string["__TEXT_MAINUI_BTN_PVP"] = "竞技场"
_tab_string["__TEXT_MAINUI_BTN_WORLD"] = "世界"
_tab_string["__TEXT_MAINUI_BTN_INVITE"] = "邀请"
_tab_string["__TEXT_MAINUI_BTN_PRIVATECHAT"] = "私聊"
_tab_string["__TEXT_MAINUI_BTN_GROUP"] = "军团"
_tab_string["__TEXT_MAINUI_BTN_COUPLE"] = "组队"
_tab_string["__TEXT_MAINUI_BTN_DONATE"] = "捐献"
_tab_string["__TEXT_MAINUI_BTN_REDPACKET"] = "红包"
_tab_string["__TEXT_MAINUI_BTN_NONOTICE"] = "不再提醒"
_tab_string["__GROUP_SERVER_ERROR_TYPE_FLOOD_SCREEN"] = "您的聊天内容在短时间内已重复多次，不能发送"
_tab_string["__GROUP_SERVER_ERROR_TYPE_TOO_FAST"] = "您的聊天频率在短时间内过快，不能发送"
_tab_string["__TEXT_MONTHCARD"] = "氪石萃取机"
_tab_string["__TEXT_MONTHCARD_INTRODUCE1"] = "1、购买后立即获得300氪石。"
_tab_string["__TEXT_MONTHCARD_INTRODUCE2"] = "2、30天内每天赠送30氪石。"
_tab_string["__TEXT_MONTHCARD_INTRODUCE3"] = "3、30天内每天赠送20个装备宝箱碎片。"
_tab_string["__TEXT_MONTHCARD_LEFTTIME"] = "氪石萃取机剩余工作时效: %d天"
_tab_string["__TEXT_MONTHCARD_NOTHAVE"] = "您还未获得氪石萃取机"
_tab_string["__TEXT_MAP_LASTMAP"] = "您还未获得氪石萃取机"
_tab_string["__TEXT_MAP_NOTEXIST"] = "地图\"%s\"不存在！"
_tab_string["__TEXT_XILIAN_COSTCHIP"] = "消耗芯片%d个"
_tab_string["__TEXT_XILIAN_COSTKESHI"] = "消耗芯片%d个 氪石%d"

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
_tab_string["ios_chat_not_empty"] = "聊天内容不能为空"
_tab_string["ios_chat_too_long"] = "您输入的内容过长"
_tab_string["ios_chat_no_empty"] = "不能包含空格"
_tab_string["ios_chat_no_text"] = "您还没有输入内容"

_tab_string["__TEXT_FORMAT_TimeLeft_Days"] = "剩余%d天"
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
_tab_string["__TEXT_AcievementFinished"] = "成就已领取!"
_tab_string["__TEXT_ChatDragonReward"] = "聊天龙王奖"
_tab_string["SystemMail_ChatDragon"] = "在%s的聊天中，您侃侃而谈，累计聊天%d次，遥遥领先其它玩家，荣获“聊天龙王奖”。同时您获得聊天龙王头衔，有效期一天。"

_tab_string["__GROUP_SERVER_ERROR_TYPE_NO_AUTHORITY"] = "您没有权限进行此操作"
_tab_string["__GROUP_SERVER_ERROR_TYPE_NO_VALID_MSGID"] = "无效的消息"
_tab_string["__GROUP_SERVER_ERROR_TYPE_NO_VALID_UID"] = "无效的玩家"
_tab_string["__GROUP_SERVER_ERROR_TYPE_NO_USER_INIT"] = "玩家未初始化"
_tab_string["__GROUP_SERVER_ERROR_TYPE_NO_VALID_PARAM"] = "参数不合法"
_tab_string["__GROUP_SERVER_ERROR_TYPE_NO_VALID_FOBIDDEN"] = "您被禁言无法发送消息"
_tab_string["__GROUP_SERVER_ERROR_TYPE_NO_VALID_PRIVATE_FOBIDDEN"] = "您被禁言无法发起私聊"
_tab_string["__GROUP_SERVER_ERROR_TYPE_NO_CHAT_PRIVATE_TYPE"] = "只能发送私聊消息"
_tab_string["__GROUP_SERVER_ERROR_TYPE_NO_CHAT_PRIVATE_FRIEND"] = "对方不在您的私聊列表里"
_tab_string["__GROUP_SERVER_ERROR_TYPE_NO_CHAT_PRIVATE_FRIEND_ME"] = "您不在对方的私聊列表里"
_tab_string["__GROUP_SERVER_ERROR_TYPE_NO_CHAT_PRIVATE_INVITE"] = "等待对方通过私聊请求"
_tab_string["__GROUP_SERVER_ERROR_TYPE_NO_CHAT_PRIVATE_USER_OFFLINE"] = "对方不在线，无法发起私聊"
_tab_string["__GROUP_SERVER_ERROR_TYPE_NO_CHAT_PRIVATE_USER_NUMMAX"] = "您的私聊人数已达上限，无法发起私聊"
_tab_string["__GROUP_SERVER_ERROR_TYPE_NO_CHAT_PRIVATE_USER_NUMMAX_ME"] = "对方私聊人数已达上限，无法发起私聊"
_tab_string["__GROUP_SERVER_ERROR_TYPE_NO_CHAT_PRIVATE_USER_SAMEME"] = "不能和自己私聊"
_tab_string["__GROUP_SERVER_ERROR_TYPE_NO_CHAT_PRIVATE_INVITE_SAME"] = "不能重复发送私聊请求"
_tab_string["__GROUP_SERVER_ERROR_TYPE_NO_CHAT_PRIVATE_INVITE_OP_REMOVE"] = "对方已关闭和你的私聊"
_tab_string["__GROUP_SERVER_ERROR_TYPE_NO_CHAT_PRIVATE_INVITE_OP_REMOVE_ME"] = "您已将对方删除"
_tab_string["__GROUP_SERVER_ERROR_TYPE_NO_CHAT_PRIVATE_INVITE_OP_REFUSE"] = "对方已拒绝您的私聊请求"
_tab_string["__GROUP_SERVER_ERROR_TYPE_NO_CHAT_PRIVATE_INVITE_OP_REFUSE_ME"] = "您已拒绝对方的私聊请求"
_tab_string["__GROUP_SERVER_ERROR_TYPE_NO_CHAT_PRIVATE_INVITE_MAXCOUNT"] = "您今日请求私聊该玩家的次数已达上限"

_tab_string["__TEXT_HINT_NEW_MESSGAE"] = "收到新消息"

_tab_string["__TEXT_SEND"] = "发送"
_tab_string["__TEXT_Delete"] = "删除"
_tab_string["__TEXT_Accept"] = "接受"
_tab_string["__TEXT_Refuse"] = "拒绝"
_tab_string["__TEXT_Confirm"] = "确定"
_tab_string["__TEXT_ChatBan"] = "禁言"
_tab_string["__TEXT_IsChatDeleteMessage"] = "是否删除消息 \"%s\" ？"
_tab_string["__TEXT_IsChatBanPlayer"] = "是否禁言玩家 \"%s\" ？"
_tab_string["__TEXT_PVP_Online"] = "在线"
_tab_string["__TEXT_IAPPAY_SELECT"] = "请选择支付方式"
_tab_string["__TEXT_IAPPAY_ALI"] = "支付宝"
_tab_string["__TEXT_IAPPAY_WEIXIN"] = "微信"
_tab_string["__TEXT_MapInfoGetting"] = "正在获取地图信息"
_tab_string["__GROUP_REDPACKET_SEND"] = "发送了一个红包"
_tab_string["__GROUP_REDPACKET_DETAIL"] = "查看领取详情"
_tab_string["__GROUP_REDPACKET_RECEIVE_YOU"] = "您已领取该红包"
_tab_string["__GROUP_REDPACKET_RECEIVE_EMPTY"] = "红包已被领完"
_tab_string["__GROUP_REDPACKET_RECEIVE_DETAIL_SOME"] = "%d个红包，已领取%d/%d"
_tab_string["__GROUP_REDPACKET_RECEIVE_DETAIL_ALL"] = "%d个红包，已全部领完"
_tab_string["__GROUP_REDPACKET_RECEIVE_CLICK"] = "点击领取红包"
_tab_string["__GROUP_REDPACKET_RECEIVE_NOTICE"] = "【%s】的红包"
_tab_string["__TEXT_GROUP_MAP_BATTLE_SUCCESS_COUNT"] = "【%s】成功挑战%s，今日累计挑战%d次！"
_tab_string["__GROUP_REDPACKET_SEND_BTN"] = "发红包"

_tab_string["__TEXT_CHAT_ADVERSE"] = "更多游戏攻略请前往taptap论坛。遇到账号问题可加官方QQ群915030951进行反馈。"
_tab_string["__TEXT_CHAT_ADVERSE2"] = "请勿发送诽谤、辱骂、淫秽、广告等不良内容，违规者将依据运营政策受到处罚。请勿向他人透露支付信息和个人信息。"

_tab_string["__TEXT_Cant_ShowMessageType"] = "【收到不支持的消息类型，无法显示】"
_tab_string["__TEXT_RANDOMMAP_LOADSAVEDATA"] = "您上次挑战天梯迷宫意外中断了！"
_tab_string["__TEXT_RANDOMMAP_CONTINUE"] = "继续进度"
_tab_string["__TEXT_RANDOMMAP_RESTART"] = "重头开始"
_tab_string["__TEXT_RANDOMMAP_OUTDATE"] = "您上次挑战天梯迷宫的时间太久，已过了有效时限，无法继续！"
_tab_string["__TEXT_RANDOMMAP_ERROE1"] = "战斗不存在！"
_tab_string["__TEXT_RANDOMMAP_ERROE2"] = "战斗信息不一致！"
_tab_string["__TEXT_RANDOMMAP_PLEASESAVEDATA"] = "请使用运输机送回营救的工程师和战利品"
-------------------------------------------------------------



-------------------------------------------------------------

--枪
_tab_stringU[6002] = {"反弹光线","发射能到处反弹穿透敌人的能量光线",""}
_tab_stringU[6003] = {"喷火枪","喷射可穿透敌人的火焰，射程近但威力大",""}
_tab_stringU[6004] = {"雷神之锤","释放可在多个敌人间弹射的闪电链",""}
_tab_stringU[6005] = {"冲击波","发射可穿透的冲击波，能推开命中的敌人",""}
_tab_stringU[6006] = {"透射枪","发射射程极远的穿透光线，威力会随距离衰减",""}
_tab_stringU[6007] = {"反弹光球","发射能到处反弹的能量光球",""}
_tab_stringU[6008] = {"火箭枪","",""}
_tab_stringU[6009] = {"导弹枪","",""}
_tab_stringU[6013] = {"机枪","单发威力较低但攻速极快",""}
_tab_stringU[6014] = {"散弹枪","发射呈扇形散布的大量子弹",""}
_tab_stringU[6016] = {"毒液枪","喷射毒液使范围内敌人中毒",""}
_tab_stringU[6017] = {"缩小枪","能将大部分敌人缩小，之后可直接碾压消灭",""}
_tab_stringU[6019] = {"终结者","发射两排子弹，索敌范围较大",""}
_tab_stringU[6020] = {"流浪者","",""}

--宠物
_tab_stringU[13041] = {"霹雳七号","近战单位，攻防兼备，拥有所有宠物里最多的血量",""}
_tab_stringU[13042] = {"兔儿大师","近战单位，攻击力较低，但是攻击速度极快",""}
_tab_stringU[13043] = {"以太战机","远程单位，比较脆弱，但火力强大",""}
_tab_stringU[13044] = {"毒液刺蛇","近战单位，各项能力较为平均",""}


--随机图boss
_tab_stringU[6000] = {"","",""}
_tab_stringU[11500] = {"光球蜘蛛","",""}
_tab_stringU[11502] = {"步行战车","",""}
_tab_stringU[11503] = {"重装机甲","",""}
_tab_stringU[11504] = {"战斗机器","",""}
_tab_stringU[11505] = {"地雷坦克","",""}
_tab_stringU[11507] = {"高射塔","",""}
_tab_stringU[11508] = {"喷火塔","",""}
_tab_stringU[11509] = {"飞弹塔","",""}
_tab_stringU[11510] = {"兽人战车","",""}
_tab_stringU[11512] = {"飞机母舰","",""}
_tab_stringU[11513] = {"武装列车","",""}
_tab_stringU[11514] = {"轨道坦克","",""}
_tab_stringU[11516] = {"盾牌机甲","",""}
_tab_stringU[11517] = {"高射塔","",""}
_tab_stringU[11518] = {"喷火塔","",""}
_tab_stringU[11519] = {"飞弹塔","",""}
_tab_stringU[11521] = {"钢铁气球","",""}
_tab_stringU[11522] = {"白翼机兵","",""}
_tab_stringU[11523] = {"黑翼机兵","",""}
_tab_stringU[11524] = {"白翼机兵","",""}
_tab_stringU[11525] = {"黑翼机兵","",""}
_tab_stringU[11526] = {"光剑高手","",""}
_tab_stringU[11528] = {"光剑大师","",""}
_tab_stringU[11529] = {"毒液异形","",""}
_tab_stringU[11531] = {"产卵异形","",""}
_tab_stringU[11534] = {"虫巢","",""}

_tab_stringU[40000] = {"太鼓游戏机","",""}  --3
_tab_stringU[40001] = {"海神三叉戟","",""}  --4
_tab_stringU[40003] = {"铁人之心","",""}    --5
_tab_stringU[40007] = {"量子计算机","",""}  --2
_tab_stringU[40008] = {"通量电容器","",""} ---1


-------------------------------------------------------------
--光环
_tab_stringA[1000] = {
	"",
	"暴击+5%",
}

_tab_stringA[1001] = {
	"",
	"燃烧+1",
}

_tab_stringA[1002] = {
	"",
	"子母+1",
}

_tab_stringA[1003] = {
	"",
	"装甲+5",
}

_tab_stringA[1004] = {
	"",
	"动力+10",
}

_tab_stringA[1005] = {
	"",
	"防电+5",
}

_tab_stringA[1006] = {
	"",
	"防火+5",
}

_tab_stringA[1007] = {
	"",
	"防毒+5",
}

_tab_stringA[1008] = {
	"",
	"治疗当前所有宠物",
}

_tab_stringA[1009] = {
	"",
	"双雷+1",
}

_tab_stringA[1010] = {
	"",
	"武器等级+2",
}

_tab_stringA[1011] = {
	"",
	"杀伤+10",
}

_tab_stringA[1012] = {
	"",
	"轮刀+200",
}

_tab_stringA[1013] = {
	"",
	"迷惑几率+1%",
}

_tab_stringA[1014] = {
	"",
	"手雷距离+50",
}

_tab_stringA[1100] = {
	"",
	"战术卡+1",
	"战术卡+2",
}
_tab_stringA[1101] = {
	"",
	"战术卡+1",
	"战术卡+2",
}
_tab_stringA[1102] = {
	"",
	"战术卡+1",
	"战术卡+2",
}
_tab_stringA[1103] = {
	"",
	"战术卡+1",
	"战术卡+2",
}
_tab_stringA[1104] = {
	"",
	"战术卡+1",
	"战术卡+2",
}
_tab_stringA[1105] = {
	"",
	"战术卡+1",
	"战术卡+2",
}
_tab_stringA[1106] = {
	"",
	"战术卡+1",
	"战术卡+2",
}
_tab_stringA[1107] = {
	"",
	"战术卡+1",
	"战术卡+2",
}
_tab_stringA[1108] = {
	"",
	"战术卡+1",
	"战术卡+2",
}
_tab_stringA[1109] = {
	"",
	"战术卡+1",
	"战术卡+2",
}
_tab_stringA[1110] = {
	"",
	"战术卡+1",
	"战术卡+2",
}
_tab_stringA[1111] = {
	"",
	"战术卡+1",
	"战术卡+2",
}
_tab_stringA[1112] = {
	"",
	"战术卡+1",
	"战术卡+2",
}

_tab_stringA[1120] = {
	"",
	"战术卡+10",
}
_tab_stringA[1121] = {
	"",
	"战术卡+10",
}
_tab_stringA[1122] = {
	"",
	"战术卡+10",
}
_tab_stringA[1123] = {
	"",
	"战术卡+10",
}
_tab_stringA[1124] = {
	"",
	"战术卡+10",
}
_tab_stringA[1125] = {
	"",
	"战术卡+10",
}
_tab_stringA[1126] = {
	"",
	"战术卡+10",
}
_tab_stringA[1127] = {
	"",
	"战术卡+10",
}
_tab_stringA[1128] = {
	"",
	"战术卡+10",
}
_tab_stringA[1129] = {
	"",
	"战术卡+10",
}
_tab_stringA[1130] = {
	"",
	"战术卡+10",
}
_tab_stringA[1131] = {
	"",
	"战术卡+10",
}
_tab_stringA[1132] = {
	"",
	"战术卡+10",
}

_tab_stringA[1200] = {
	"",
	"宠物+1",
}
_tab_stringA[1201] = {
	"",
	"宠物+1",
}
_tab_stringA[1202] = {
	"",
	"宠物+1",
}
_tab_stringA[1203] = {
	"",
	"宠物+1",
}

_tab_stringA[2000] = {
	"",
	"水晶+500",
}
_tab_stringA[2001] = {
	"",
	"超级天网+1",
}
_tab_stringA[2002] = {
	"",
	"回复建筑25%血量",
}
_tab_stringA[2003] = {
	"",
	"短时间枪塔攻速翻倍",
}

_tab_stringA[2100] = {
	"",
	"",
}
_tab_stringA[2101] = {
	"",
	"",
}
_tab_stringA[2102] = {
	"",
	"",
}
_tab_stringA[2103] = {
	"",
	"",
}
_tab_stringA[2104] = {
	"",
	"",
}
_tab_stringA[2105] = {
	"",
	"",
}
_tab_stringA[2106] = {
	"",
	"",
}
_tab_stringA[2107] = {
	"",
	"",
}
_tab_stringA[2108] = {
	"",
	"",
}
_tab_stringA[2109] = {
	"",
	"",
}
_tab_stringA[2110] = {
	"",
	"",
}
_tab_stringA[2111] = {
	"",
	"",
}
_tab_stringA[2112] = {
	"",
	"",
}
_tab_stringA[2113] = {
	"",
	"",
}
_tab_stringA[2114] = {
	"",
	"",
}
_tab_stringA[2115] = {
	"",
	"",
}


_tab_stringA[2200] = {
	"",
	"机枪塔攻击等级提升",
}
_tab_stringA[2201] = {
	"",
	"散弹枪塔攻击等级提升",
}
_tab_stringA[2202] = {
	"",
	"喷火枪塔攻击等级提升",
}
_tab_stringA[2203] = {
	"",
	"透射枪塔攻击等级提升",
}
_tab_stringA[2204] = {
	"",
	"雷神之锤塔攻击等级提升",
}
_tab_stringA[2205] = {
	"",
	"冲击波塔攻击等级提升",
}
_tab_stringA[2206] = {
	"",
	"毒枪塔攻击等级提升",
}
_tab_stringA[2207] = {
	"",
	"反弹光线塔攻击等级提升",
}
_tab_stringA[2208] = {
	"",
	"反弹光球塔攻击等级提升",
}
_tab_stringA[2209] = {
	"",
	"缩小枪塔攻击等级提升",
}

_tab_stringA[3000] = {
	"",
	"装甲+10",
}
_tab_stringA[3001] = {
	"",
	"防电+10",
}
_tab_stringA[3002] = {
	"",
	"防火+10",
}
_tab_stringA[3003] = {
	"",
	"防毒+10",
}
_tab_stringA[3004] = {
	"",
	"燃烧+2",
}
_tab_stringA[3005] = {
	"",
	"子母+2",
}
_tab_stringA[3006] = {
	"",
	"陷阱时间翻倍",
}
_tab_stringA[3007] = {
	"",
	"天网时间翻倍",
}
_tab_stringA[3008] = {
	"",
	"战车下次损毁后会引爆周围敌人",
}
_tab_stringA[3009] = {
	"",
	"迷惑范围翻倍",
}
_tab_stringA[3010] = {
	"",
	"克隆当前所有宠物",
}


_tab_stringA[4000] = {
	"",
	"暴击+20%",
}
_tab_stringA[4001] = {
	"",
	"冷却-1000",
}
_tab_stringA[4002] = {
	"",
	"手雷爆炸后产生十字火焰",
}
_tab_stringA[4003] = {
	"",
	"手雷爆炸后产生飞弹",
}
_tab_stringA[4004] = {
	"",
	"手雷爆炸后产生旋涡",
}
_tab_stringA[4005] = {
	"",
	"惯性翻倍",
}
_tab_stringA[4006] = {
	"",
	"战车最大生命翻倍",
}

_tab_stringA[4007] = {
	"",
	"战车复活次数+1",
}

_tab_stringA[4008] = {
	"",
	"火焰免伤",
}
_tab_stringA[4009] = {
	"",
	"迷惑+6",
}

_tab_stringA[4010] = {
	"",
	"宠物复活次数+1",
}




_tab_stringM["world/csys_random_test"] = {"天梯迷宫", ""}
_tab_stringM["world/yxys_ex_002"] = {"前哨阵地", ""}
-------------------------------------------------------------
_tab_stringM["world/dlc_yxys_spider"] = {"矿山巨兽", "章节"}
_tab_stringM["world/yxys_spider_01"] = {"矿山巨兽Ⅰ", ""}
_tab_stringM["world/yxys_spider_02"] = {"矿山巨兽Ⅱ", ""}
_tab_stringM["world/yxys_spider_03"] = {"矿山巨兽Ⅲ", ""}
_tab_stringM["world/yxys_spider_04"] = {"矿山巨兽Ⅳ", ""}
-------------------------------------------------------------
_tab_stringM["world/dlc_yxys_airship"] = {"母舰", "章节"}
_tab_stringM["world/yxys_airship_01"] = {"母舰Ⅰ", ""}
_tab_stringM["world/yxys_airship_02"] = {"母舰Ⅱ", ""}
_tab_stringM["world/yxys_airship_03"] = {"母舰Ⅲ", ""}
_tab_stringM["world/yxys_airship_04"] = {"母舰Ⅳ", ""}
-------------------------------------------------------------
_tab_stringM["world/dlc_yxys_zerg"] = {"异虫", "章节"}
_tab_stringM["world/yxys_zerg_001"] = {"异虫Ⅰ", ""}
_tab_stringM["world/yxys_zerg_002"] = {"异虫Ⅱ", ""}
_tab_stringM["world/yxys_zerg_003"] = {"异虫Ⅲ", ""}
_tab_stringM["world/yxys_zerg_004"] = {"异虫Ⅳ", ""}
-------------------------------------------------------------
_tab_stringM["world/dlc_bio_airship"] = {"魔眼", "章节"}
_tab_stringM["world/yxys_bio_001"] = {"魔眼Ⅰ", ""}
_tab_stringM["world/yxys_bio_002"] = {"魔眼Ⅱ", ""}
_tab_stringM["world/yxys_bio_003"] = {"魔眼Ⅲ", ""}
_tab_stringM["world/yxys_bio_004"] = {"魔眼Ⅳ", ""}
-------------------------------------------------------------
_tab_stringM["world/dlc_yxys_mechanics"] = {"空中堡垒", "章节"}
_tab_stringM["world/yxys_mechanics_001"] = {"空中堡垒Ⅰ", ""}
_tab_stringM["world/yxys_mechanics_002"] = {"空中堡垒Ⅱ", ""}
_tab_stringM["world/yxys_mechanics_003"] = {"空中堡垒Ⅲ", ""}
_tab_stringM["world/yxys_mechanics_004"] = {"空中堡垒Ⅳ", ""}
-------------------------------------------------------------
_tab_stringM["world/dlc_yxys_plate"] = {"弧反应堆", "章节"}
_tab_stringM["world/yxys_plate_01"] = {"弧反应堆Ⅰ", ""}
_tab_stringM["world/yxys_plate_02"] = {"弧反应堆Ⅱ", ""}
_tab_stringM["world/yxys_plate_03"] = {"弧反应堆Ⅲ", ""}
_tab_stringM["world/yxys_plate_04"] = {"弧反应堆Ⅳ", ""}





--=============================================================================================--
--任务表

--_tab_stringTask[1] = {"每日奖励", "分享给微信好友，每天一次",}
--_tab_stringTask[2] = {"商城抽卡", "聚宝盆抽取一次战术卡包",}
--_tab_stringTask[3] = {"商城抽宝", "聚宝盆抽取一次神器宝箱",}
--_tab_stringTask[4] = {"百炼成钢", "改造装备一次",}
--_tab_stringTask[5] = {"小试牛刀", "通关任意战役地图一次",}
--_tab_stringTask[6] = {"无尽使命", "挑战无尽试炼达到3000分",}
--_tab_stringTask[7] = {"竞技锦囊", "夺塔奇兵商城兑换任意商品一次",}
--_tab_stringTask[8] = {"竞技切磋", "夺塔奇兵完成一次有效局",}
--_tab_stringTask[9] = {"兵符达人", "消耗30兵符",}
--_tab_stringTask[10] = {"击杀BOSS", "累计击杀蜘蛛BOSS 5次",}
--_tab_stringTask[11] = {"使用战术卡", "使用指定战术卡10次",}

_tab_stringTask[100] = {"每日分享", "邮箱领取3次分享奖励",}

_tab_stringTask[101] = {"矿山巨兽Ⅰ", "通关",}
_tab_stringTask[102] = {"矿山巨兽Ⅱ", "通关",}
_tab_stringTask[103] = {"矿山巨兽Ⅲ", "通关",}
_tab_stringTask[104] = {"矿山巨兽Ⅳ", "通关",}
_tab_stringTask[105] = {"母舰Ⅰ", "通关",}
_tab_stringTask[106] = {"母舰Ⅱ", "通关",}
_tab_stringTask[107] = {"母舰Ⅲ", "通关",}
_tab_stringTask[108] = {"母舰Ⅳ", "通关",}
_tab_stringTask[109] = {"异虫Ⅰ", "通关",}
_tab_stringTask[110] = {"异虫Ⅱ", "通关",}
_tab_stringTask[111] = {"异虫Ⅲ", "通关",}
_tab_stringTask[112] = {"异虫Ⅳ", "通关",}
_tab_stringTask[113] = {"魔眼Ⅰ", "通关",}
_tab_stringTask[114] = {"魔眼Ⅱ", "通关",}
_tab_stringTask[115] = {"魔眼Ⅲ", "通关",}
_tab_stringTask[116] = {"魔眼Ⅳ", "通关",}
_tab_stringTask[117] = {"空中堡垒Ⅰ", "通关",}
_tab_stringTask[118] = {"空中堡垒Ⅱ", "通关",}
_tab_stringTask[119] = {"空中堡垒Ⅲ", "通关",}
_tab_stringTask[120] = {"空中堡垒Ⅳ", "通关",}
_tab_stringTask[121] = {"弧反应堆Ⅰ", "通关",}
_tab_stringTask[122] = {"弧反应堆Ⅱ", "通关",}
_tab_stringTask[123] = {"弧反应堆Ⅲ", "通关",}
_tab_stringTask[124] = {"弧反应堆Ⅳ", "通关",}


_tab_stringTask[201] = {"矿山巨兽Ⅰ", "无损通关",}
_tab_stringTask[202] = {"矿山巨兽Ⅱ", "无损通关",}
_tab_stringTask[203] = {"矿山巨兽Ⅲ", "无损通关",}
_tab_stringTask[204] = {"矿山巨兽Ⅳ", "无损通关",}
_tab_stringTask[205] = {"母舰Ⅰ", "无损通关",}
_tab_stringTask[206] = {"母舰Ⅱ", "无损通关",}
_tab_stringTask[207] = {"母舰Ⅲ", "无损通关",}
_tab_stringTask[208] = {"母舰Ⅳ", "无损通关",}
_tab_stringTask[209] = {"异虫Ⅰ", "无损通关",}
_tab_stringTask[210] = {"异虫Ⅱ", "无损通关",}
_tab_stringTask[211] = {"异虫Ⅲ", "无损通关",}
_tab_stringTask[212] = {"异虫Ⅳ", "无损通关",}
_tab_stringTask[213] = {"魔眼Ⅰ", "无损通关",}
_tab_stringTask[214] = {"魔眼Ⅱ", "无损通关",}
_tab_stringTask[215] = {"魔眼Ⅲ", "无损通关",}
_tab_stringTask[216] = {"魔眼Ⅳ", "无损通关",}
_tab_stringTask[217] = {"空中堡垒Ⅰ", "无损通关",}
_tab_stringTask[218] = {"空中堡垒Ⅱ", "无损通关",}
_tab_stringTask[219] = {"空中堡垒Ⅲ", "无损通关",}
_tab_stringTask[220] = {"空中堡垒Ⅳ", "无损通关",}
_tab_stringTask[221] = {"弧反应堆Ⅰ", "无损通关",}
_tab_stringTask[222] = {"弧反应堆Ⅱ", "无损通关",}
_tab_stringTask[223] = {"弧反应堆Ⅲ", "无损通关",}
_tab_stringTask[224] = {"弧反应堆Ⅳ", "无损通关",}


_tab_stringTask[301] = {"刷新商店", "刷新一次售货机商品",}
_tab_stringTask[311] = {"武器宝箱", "开启武器宝箱1次",}
_tab_stringTask[321] = {"战术宝箱", "开启战术宝箱1次",}
_tab_stringTask[331] = {"宠物宝箱", "开启宠物宝箱1次",}
_tab_stringTask[341] = {"装备宝箱", "开启装备宝箱1次",}

_tab_stringTask[351] = {"击杀敌人", "累计击杀100个敌人",}
_tab_stringTask[352] = {"击杀敌人", "累计击杀200个敌人",}
_tab_stringTask[353] = {"击杀敌人", "累计击杀300个敌人",}

_tab_stringTask[361] = {"击杀BOSS", "累计击杀5个BOSS",}
_tab_stringTask[362] = {"击杀BOSS", "累计击杀10个BOSS",}
_tab_stringTask[363] = {"击杀BOSS", "累计击杀15个BOSS",}

_tab_stringTask[371] = {"使用战术卡", "使用战术卡30次",}
_tab_stringTask[372] = {"使用战术卡", "使用战术卡60次",}
_tab_stringTask[373] = {"使用战术卡", "使用战术卡90次",}

_tab_stringTask[381] = {"营救工程师", "营救10个工程师",}
_tab_stringTask[382] = {"营救工程师", "营救20个工程师",}
_tab_stringTask[383] = {"营救工程师", "营救30个工程师",}


_tab_stringTask[391] = {"前哨阵地", "前哨阵地达到5波",}
_tab_stringTask[392] = {"前哨阵地", "前哨阵地达到10波",}
_tab_stringTask[393] = {"前哨阵地", "前哨阵地达到15波",}


_tab_stringTask[401] = {"天梯迷宫", "天梯迷宫抵达2-1",}
_tab_stringTask[402] = {"天梯迷宫", "天梯迷宫抵达3-1",}
_tab_stringTask[403] = {"天梯迷宫", "天梯迷宫抵达4-1",}
_tab_stringTask[404] = {"天梯迷宫", "天梯迷宫抵达5-1",}

_tab_stringTask[411] = {"战车损坏", "战车累计损坏3次",}
_tab_stringTask[412] = {"战车损坏", "战车累计损坏6次",}
_tab_stringTask[413] = {"战车损坏", "战车累计损坏9次",}

_tab_stringTask[421] = {"宠物跟随", "同时跟随3个宠物",}
_tab_stringTask[422] = {"宠物跟随", "同时跟随6个宠物",}
_tab_stringTask[423] = {"宠物跟随", "同时跟随9个宠物",}

_tab_stringTask[431] = {"改造装备", "累计改造装备3次",}
_tab_stringTask[432] = {"改造装备", "累计改造装备6次",}
_tab_stringTask[433] = {"改造装备", "累计改造装备9次",}

_tab_stringTask[441] = {"升级战术卡", "累计升级任意战术卡1次",}
_tab_stringTask[442] = {"升级战术卡", "累计升级任意战术卡2次",}
_tab_stringTask[443] = {"升级战术卡", "累计升级任意战术卡3次",}

_tab_stringTask[451] = {"升级枪塔", "累计升级任意枪塔1次",}
_tab_stringTask[452] = {"升级枪塔", "累计升级任意枪塔2次",}
_tab_stringTask[453] = {"升级枪塔", "累计升级任意枪塔3次",}

_tab_stringTask[461] = {"升级宠物", "累计升级任意宠物1次",}
_tab_stringTask[462] = {"升级宠物", "累计升级任意宠物2次",}
_tab_stringTask[463] = {"升级宠物", "累计升级任意宠物3次",}

_tab_stringTask[501] = {"母巢之战", "通关母巢之战-难度1",}
_tab_stringTask[502] = {"母巢之战", "通关母巢之战-难度2",}
_tab_stringTask[503] = {"母巢之战", "通关母巢之战-难度3",}

_tab_stringTask[521] = {"夺宝奇兵", "通关夺宝奇兵-简单难度",}
_tab_stringTask[522] = {"夺宝奇兵", "通关夺宝奇兵-正常难度",}
_tab_stringTask[523] = {"夺宝奇兵", "通关夺宝奇兵-困难难度",}



--周任务
_tab_stringTask[1001] = {"武器宝箱", "本周开启武器宝箱20次",}
_tab_stringTask[1002] = {"战术宝箱", "本周开启战术宝箱20次",}
_tab_stringTask[1003] = {"宠物宝箱", "本周开启宠物宝箱20次",}
_tab_stringTask[1004] = {"装备宝箱", "本周开启装备宝箱20次",}
_tab_stringTask[1005] = {"击杀敌人", "本周累计击杀1000个敌人",}
_tab_stringTask[1006] = {"营救工程师", "本周累计营救80个工程师",}
_tab_stringTask[1007] = {"战车损坏", "本周战车累计损坏30次",}
_tab_stringTask[1008] = {"前哨阵地", "本周前哨阵地达到30波",}
_tab_stringTask[1009] = {"天梯迷宫", "本周天梯迷宫抵达6-1",}
_tab_stringTask[1010] = {"击杀BOSS", "本周累计击杀50个BOSS",}
_tab_stringTask[1011] = {"使用战术卡", "本周使用战术卡300次",}
_tab_stringTask[1012] = {"宠物跟随", "本周同时跟随15个宠物",}
_tab_stringTask[1013] = {"改造装备", "本周累计改造装备20次",}
_tab_stringTask[1014] = {"升级战术卡", "本周累计升级战术卡10次",}
_tab_stringTask[1015] = {"升级枪塔", "本周累计升级枪塔10次",}
_tab_stringTask[1016] = {"升级宠物", "本周累计升级宠物10次",}
_tab_stringTask[1017] = {"母巢之战", "本周通关母巢之战-难度1",}
_tab_stringTask[1018] = {"夺宝奇兵", "本周通关夺宝奇兵-简单",}

--=============================================================================================--
--宝箱
_stringCHEST[1] = {
	"武器宝箱碎片",
	"每10个武器宝箱碎片可开启一次宝箱。",
}

_stringCHEST[2] = {
	"战术宝箱碎片",
	"每10个战术宝箱碎片可开启一次宝箱。",
}

_stringCHEST[3] = {
	"基因宝箱碎片",
	"每10个基因宝箱碎片可开启一次宝箱。",
}

_stringCHEST[4] = {
	"装备宝箱碎片",
	"每20个装备宝箱碎片可开启一次宝箱。",
}

_stringCHEST[5] = {
	"神器宝箱",
	"消耗50氪石可开启一次宝箱。",
}






--=============================================================================================--
--战术卡
_tab_stringT[1201] = {"敌人生命加强",
	"敌人生命值+20％。",
	"敌人生命值+40％。",
	"敌人生命值+60％。",
	"敌人生命值+80％。",
	"敌人生命值+110％。",
	"敌人生命值+140％。",
	"敌人生命值+180％。",
	"敌人生命值+220％。",
	"敌人生命值+260％。",
	"敌人生命值+300％。",
	"敌人生命值+350％。",
	"敌人生命值+400％。",
	"敌人生命值+450％。",
	"敌人生命值+500％。",
	"敌人生命值+550％。",
	"敌人生命值+600％。",
	"敌人生命值+650％。",
	"敌人生命值+700％。",
	"敌人生命值+750％。",
	"敌人生命值+800％。",
	"敌人生命值+850％。",
	"敌人生命值+900％。",
	"敌人生命值+950％。",
	"敌人生命值+1000％。",
	"敌人生命值+1050％。",
	"敌人生命值+1100％。",
	"敌人生命值+1150％。",
	"敌人生命值+1200％。",
	"敌人生命值+1250％。",
	"敌人生命值+1300％。",
	"敌人生命值+1350％。",
	"敌人生命值+1400％。",
	"敌人生命值+1450％。",
	"敌人生命值+1500％。",
	"敌人生命值+1550％。",
	"敌人生命值+1600％。",
	"敌人生命值+1650％。",
	"敌人生命值+1700％。",
	"敌人生命值+1750％。",
	"敌人生命值+1800％。",
}

_tab_stringT[1202] = {"敌人攻击加强",
	"敌人攻击力+20％。",
	"敌人攻击力+40％。",
	"敌人攻击力+60％。",
	"敌人攻击力+80％。",
	"敌人攻击力+110％。",
	"敌人攻击力+140％。",
	"敌人攻击力+180％。",
	"敌人攻击力+220％。",
	"敌人攻击力+260％。",
	"敌人攻击力+300％。",
	"敌人攻击力+350％。",
	"敌人攻击力+400％。",
	"敌人攻击力+450％。",
	"敌人攻击力+500％。",
	"敌人攻击力+550％。",
	"敌人攻击力+600％。",
	"敌人攻击力+650％。",
	"敌人攻击力+700％。",
	"敌人攻击力+750％。",
	"敌人攻击力+800％。",
	"敌人攻击力+850％。",
	"敌人攻击力+900％。",
	"敌人攻击力+950％。",
	"敌人攻击力+1000％。",
	"敌人攻击力+1050％。",
	"敌人攻击力+1100％。",
	"敌人攻击力+1150％。",
	"敌人攻击力+1200％。",
	"敌人攻击力+1250％。",
	"敌人攻击力+1300％。",
	"敌人攻击力+1350％。",
	"敌人攻击力+1400％。",
	"敌人攻击力+1450％。",
	"敌人攻击力+1500％。",
	"敌人攻击力+1550％。",
	"敌人攻击力+1600％。",
	"敌人攻击力+1650％。",
	"敌人攻击力+1700％。",
	"敌人攻击力+1750％。",
	"敌人攻击力+1800％。",
}

_tab_stringT[1203] = {"敌人装甲加强",
	"敌人装甲+100。",
	"敌人装甲+150。",
	"敌人装甲+200。",
}
_tab_stringT[1204] = {"敌人速度加强",
	"敌人速度+100％。",
	"敌人速度+150％。",
	"敌人速度+200％。",
}
_tab_stringT[1205] = {"我方速度降低",
	"我方速度-50％。",
	"我方速度-60％。",
	"我方速度-70％。",
}
_tab_stringT[1206] = {"我方生命降低",
	"我方生命-50％。",
	"我方生命-60％。",
	"我方生命-70％。",
}
_tab_stringT[1207] = {"敌人生命加强",
	"敌人生命+100％。",
	"敌人生命+150％。",
	"敌人生命+200％。",
}
_tab_stringT[1208] = {"敌人攻击加强",
	"敌人攻击+100％。",
	"敌人攻击+150％。",
	"敌人攻击+200％。",
}
_tab_stringT[1209] = {"敌人防护加强",
	"敌人防火、防电、防毒+100。",
	"敌人防火、防电、防毒+150。",
	"敌人防火、防电、防毒+200。",
}





--=============================================================================================--
--成就
--[[
_tab_stringME[11] = {"星星1", "累计获得 1 颗星星",}
_tab_stringME[12] = {"星星2", "累计获得 3 颗星星",}
_tab_stringME[13] = {"星星3", "累计获得 5 颗星星",}
_tab_stringME[14] = {"星星4", "累计获得 10 颗星星",}
_tab_stringME[15] = {"星星5", "累计获得 20 颗星星",}
_tab_stringME[16] = {"星星6", "累计获得 30 颗星星",}
_tab_stringME[17] = {"星星7", "累计获得 40 颗星星",}
_tab_stringME[18] = {"星星8", "累计获得 50 颗星星",}
_tab_stringME[19] = {"星星9", "累计获得 70 颗星星",}
_tab_stringME[20] = {"星星10", "累计获得 100 颗星星",}
_tab_stringME[21] = {"星星11", "累计获得 130 颗星星",}
_tab_stringME[22] = {"星星12", "累计获得 160 颗星星",}
_tab_stringME[23] = {"星星13", "累计获得 190 颗星星",}
_tab_stringME[24] = {"星星14", "累计获得 220 颗星星",}
_tab_stringME[25] = {"星星15", "累计获得 250 颗星星",}
_tab_stringME[26] = {"星星16", "累计获得 280 颗星星",}

_tab_stringME[51] = {"工程师1", "累计营救 3 个工程师",}
_tab_stringME[52] = {"工程师2", "累计营救 5 个工程师",}
_tab_stringME[53] = {"工程师3", "累计营救 10 个工程师",}
_tab_stringME[54] = {"工程师4", "累计营救 15 个工程师",}
_tab_stringME[55] = {"工程师5", "累计营救 20 个工程师",}
_tab_stringME[56] = {"工程师6", "累计营救 35 个工程师",}
_tab_stringME[57] = {"工程师7", "累计营救 50 个工程师",}
_tab_stringME[58] = {"工程师8", "累计营救 100 个工程师",}
_tab_stringME[59] = {"工程师9", "累计营救 137 个工程师",}
_tab_stringME[60] = {"工程师10", "累计营救 150 个工程师",}
_tab_stringME[61] = {"工程师11", "累计营救 200 个工程师",}
_tab_stringME[62] = {"工程师12", "累计营救 250 个工程师",}
_tab_stringME[63] = {"工程师13", "累计营救 300 个工程师",}
_tab_stringME[64] = {"工程师14", "累计营救 400 个工程师",}
_tab_stringME[65] = {"工程师15", "累计营救 500 个工程师",}
_tab_stringME[66] = {"工程师16", "累计营救 616 个工程师",}
_tab_stringME[67] = {"工程师17", "累计营救 1000 个工程师",}

_tab_stringME[101] = {"残骸1", "战车累计损毁 3 次",}
_tab_stringME[102] = {"残骸2", "战车累计损毁 5 次",}
_tab_stringME[103] = {"残骸3", "战车累计损毁 10 次",}
_tab_stringME[104] = {"残骸4", "战车累计损毁 15 次",}
_tab_stringME[105] = {"残骸5", "战车累计损毁 20 次",}
_tab_stringME[106] = {"残骸6", "战车累计损毁 35 次",}
_tab_stringME[107] = {"残骸7", "战车累计损毁 50 次",}
_tab_stringME[108] = {"残骸8", "战车累计损毁 75 次",}
_tab_stringME[109] = {"残骸9", "战车累计损毁 100 次",}
_tab_stringME[110] = {"残骸10", "战车累计损毁 150 次",}
_tab_stringME[111] = {"残骸11", "战车累计损毁 200 次",}
_tab_stringME[112] = {"残骸12", "战车累计损毁 250 次",}
_tab_stringME[113] = {"残骸13", "战车累计损毁 300 次",}
_tab_stringME[114] = {"残骸14", "战车累计损毁 400 次",}
_tab_stringME[115] = {"残骸15", "战车累计损毁 500 次",}
_tab_stringME[116] = {"残骸16", "战车累计损毁 700 次",}
_tab_stringME[117] = {"残骸17", "战车累计损毁 1000 次",}
]]
--=============================================================================================--



--_tab_stringT[5001] = {"SAS导弹",	"随车持续发射跟踪导弹， 火力辅助",}
--_tab_stringT[5002] = {"自动机枪",	"很好用的火力辅助，对地也能对空",}
--_tab_stringT[5003] = {"护盾",		"一定时间内抵御一切外部攻击，同时车辆提速，闯关必备",}
--_tab_stringT[5004] = {"核爆",		"投掷一枚小型核弹，清扫目标区域一切敌人",}
--_tab_stringT[5005] = {"SAS导弹台",	"导弹发射台，持续发射跟踪导弹， 火力辅助",}
--_tab_stringT[5006] = {"火墙",		"持续燃烧的火墙，威力巨大，可升级为十字火焰",}
--_tab_stringT[5007] = {"灭世天光",	"大面积杀伤的卫星激光武器",}
--_tab_stringT[5008] = {"冰霜",		"冰冻一定范围内的敌人",}
--_tab_stringT[5010] = {"SAS吸附弹",	"随车持续发射跟踪导弹，吸附在敌人身上，定时引爆",}
--_tab_stringT[5011] = {"爆裂弹珠",	"释放四处反弹的能量球杀伤敌方",}
--_tab_stringT[5012] = {"星夜",		"吸附敌方的黑洞漩涡",}
--_tab_stringT[5013] = {"缩小光线",	"照射一定范围的敌人，将他们缩小后，可以随意碾压",}
--_tab_stringT[5014] = {"巨浪",		"电磁波巨浪，将敌人冲刷到远处",}


--=============================================================================================--


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

PrivacyAgreement_String = {
	"《鑫线游戏用户个人信息及隐私保护政策》（以下简称“《隐私政策》”）由您（以下亦称“用户”或“您”）与上海鑫线信息技术有限公司（下文亦称“鑫线游戏”、“鑫线”或“我们”）共同缔结，本《隐私政策》具有合同效力。",
	" ",
	"为了更好的保护您的个人信息，建议您仔细阅读最新版的《鑫线游戏用户个人信息及隐私保护政策》。如您对本隐私政策条款有任何异议或疑问，您可通过本隐私政策第八条所列的联系方式与我们沟通解决。",
	" ",
	"上海鑫线信息技术有限公司在中华人民共和国大陆地区内运营旗下游戏(包括但不限于:《策马三国志》、《策马守天关》)。欢迎您使用鑫线游戏为您提供的服务，包括但不限于您与鑫线游戏的交互行为及/或您注册和使用鑫线游戏及/或注册和使用鑫线游戏提供的产品或服务（以下统称“鑫线游戏服务”或“服务”），鑫线游戏为保障用户在使用鑫线游戏服务期间的隐私权，鑫线游戏特此制定本《鑫线游戏用户个人信息及隐私保护政策》，用以向您说明在使用鑫线游戏服务时，我们如何收集、使用、储存和分享这些信息，以及我们为您提供访问、更新、控制和保护这些信息的方式。",
	" ",
	"《鑫线游戏用户个人信息及隐私保护政策》目录",
	" ",
	"一、引言",
	"二、您在使用我们产品或服务时主动提供的信息",
	"三、我们在您使用产品或服务时可能获取的您的信息",
	"四、我们如何存储、保护及使用您的信息",
	"五、您管理个人信息的权利",
	"六、未成年人保护",
	"七、Cookie是什么、我们会怎样使用cookie",
	"八、如何联系我们",
	" ",
	" ",
	"一、     引言",
	" ",
	"1.1本《鑫线游戏用户个人信息及隐私保护政策》适用于鑫线游戏的全部产品和服务，包括鑫线游戏网站、iOS端应用程序、安卓端应用程序等全部终端客户端。",
	" ",
	"特别提醒：由于鑫线游戏的产品和服务较多，为您提供的产品和服务内容也有所不同，本隐私政策为鑫线游戏统一适用的一般性隐私政策条款。",
	" ",
	"1.2请您在使用鑫线游戏各项产品和/或服务前，仔细阅读并充分理解本隐私政策的全部内容。一旦您选择接受并同意或开始使用或继续使用鑫线游戏的产品/服务，即表示您同意我们按照本隐私政策使用和处理您的相关信息。",
	" ",
	"1.3您可以在游戏登录界面处随时查看当前版本隐私政策。我们可能会不时依据法律法规或业务调整对本隐私政策进行修订。当本隐私政策发生变更后，我们会在版本更新后通过在显著位置提示或推送通知、消息、页面提示、弹窗、站内信、网站公告或其他便于您获知的方式向您展示变更后的内容。同时我们也会在鑫线游戏官网http://www.xingames.com/及时更新隐私政策，您可随时访问查看。",
	" ",
	"1.4您需理解，只有在您确认并同意变更后的《鑫线游戏用户个人信息及隐私保护政策》，我们才会依据变更后的隐私政策收集、使用、处理和存储您的个人信息；您有权拒绝同意变更后的隐私政策，但请您知悉，一旦您拒绝同意变更后的隐私政策，可能导致您不能或不能继续完整使用鑫线游戏的相关服务和功能，或者无法达到我们拟达到的服务效果。",
	" ",
	"1.5个人信息（出自于GB/T 35273-2020《信息安全技术 个人信息安全规范》）：是指以电子或者其他方式记录的能够单独或者与其他信息结合识别特定自然人身份或者反映特定自然人活动情况的各种信息。本隐私政策中涉及的个人信息包括自然人的基本资料（包括个人姓名、生日、性别、住址、个人电话号码、电子邮箱地址）、个人身份信息（包括身份证件号码）、个人生物识别信息（包括指纹、面部特征）、网络身份标识信息（包括系统账号、IP地址、个人数字证书等）、个人财产信息（包括银行账号、口令、交易和消费记录、虚拟货币、虚拟交易、兑换码等虚拟财产信息）、通讯录信息、个人上网记录（包括网站浏览记录、软件使用记录、使用中的软件列表）、个人常用设备信息（包括硬件序列号、硬件型号、设备MAC地址、操作系统类型、软件列表、唯一设备识别码）、个人位置信息（包括大概地理位置、精准定位信息）。我们实际具体收集的个人信息种类以下文描述为准。",
	" ",
	"1.6个人敏感信息（出自于GB/T 35273-2020《信息安全技术 个人信息安全规范》）：是指一旦泄露、非法提供或滥用可能危害人身和财产安全，极易导致个人名誉、身心健康受到损害或歧视性待遇等的个人信息。本隐私政策中涉及的个人敏感信息包括您的个人财产信息、个人身份信息、个人生物识别信息、网络身份标识信息、通讯录信息、精准定位信息、收货地址。我们实际具体收集的个人敏感信息种类以下文描述为准。",
	" ",
	"二、您在使用我们产品或服务时主动提供的信息包括但不限于：",
	" ",
	"2.1 当您注册或使用鑫线游戏服务时，我们会收集您的网络身份标识信息及个人常用设备信息，用于标记您为鑫线游戏的用户。如果您使用我们认可的其他账号（以下称“第三方账号”）作为游戏账号关联登录鑫线游戏的，我们会收集您第三方账号的唯一标识、头像、昵称，用于保存您的登录信息，以便您在不同设备登录。",
	" ",
	"2.2 为满足相关法律法规政策及相关主管部门的要求，鑫线游戏用户需进行实名认证以继续使用和享受鑫线游戏。我们会在获得您同意或您主动提供的情况下收集您的实名身份信息（包括姓名、身份证号、照片等信息），该信息属于敏感信息，拒绝提供实名身份信息可能会导致您无法登录鑫线游戏或在使用鑫线游戏过程中受到相应限制。",
	" ",
	"2.3您通过我们的产品或服务向其他方提供的共享信息，以及您使用我们的产品或服务时所储存的信息。",
	" ",
	"三、为维护基础功能的正常运行及优化并改进我们的服务，我们在您使用产品或服务时可能获取的您的信息：",
	" ",
	"3.1 日志信息: 以便您能够在客户端查看您的游戏历史记录，同时用于游戏运营统计分析、客服投诉处理及其他游戏安全分析，并为提升您的游戏体验当您使用我们的产品或服务时,我们可能会自动收集您对我们产品或服务的详细使用情况,作为相关网络日志保存。例如您的登录账号所对应的搜索查询内容、IP地址、浏览器的类型、电信运营商、网络环境、使用的语言、访问日期、时间及您访问的网页浏览记录、推送打开记录、停留时长、刷新记录、发布记录、关注、订阅、收藏及分享。",
	" ",
	"3.2 设备信息: 为保障您正常使用我们的服务，维护游戏基础功能的正常运行，优化游戏产品性能，提升您的游戏体验并保障您的账号安全，我们可能会根据您在软件安装及使用中授予的具体权限,接收并记录您所使用的设备(手机、电脑等)相关信息(例如IMEI、MAC、Serial、SIM卡IMSI识别码、设备机型、操作系统及版本、客户端版本、设备分辨率、包名、设备设置、进程及软件列表、唯一设备标识符（专属ID或UUID：是指由设备制造商编入到设备中的一串字符，可用于以独有方式标识相应设备（如IMEI/android ID/IDFA/OpenUDID/GUID/SIM卡IMSI信息等），唯一设备识别码有多种用途，其中可在不能使用Cookie（例如在移动应用程序中）时用以提供广告）、软硬件特征信息)、设备所在位置相关信息(例如IP地址、端口信息、GPS位置以及能够提供相关信息的WLAN接入点、蓝牙和基站传感器信息)、游戏处理数据。",
	" ",
	"3.3 当您使用鑫线游戏产品的消费功能时，我们会收集您的充值记录、消费记录等信息，以便您查询您的交易记录，同时尽最大程度保护您的虚拟物品安全。充值记录、消费记录属于敏感信息，收集上述信息为实现游戏产品的消费功能所必需，否则将无法完成交易。",
	" ",
	"3.4 基于为您提供安全保障，会收集您的游戏识别信息、硬件及操作系统信息、进程及游戏崩溃记录等信息，以用于打击破坏游戏公平环境或干扰、破坏游戏服务正常进行的行为（如用于检测盗版、扫描外挂、防止作弊等）。",
	" ",
	"3.5 基于为您提供安全保障，收集、使用或整合您的账户信息、交易信息、设备信息、日志信息以及鑫线游戏取得您授权或依据法律共享的信息，来综合判断您账户及交易风险、进行身份验证、检测及防范安全事件，并依法采取必要的记录、审计、分析、处置措施。",
	" ",
	"3.6 当您通过语音、视频与其他用户互动（如组队语音），我们需要您授权访问您设备的麦克风、摄像头（相机）权限，为您提供语音聊天、直播互动等功能。如您拒绝提供该权限和内容的，仅会使您无法使用与之相对应的功能，但并不影响您正常使用产品与/或服务的其他功能。同时，您也可以随时通过您的设备系统权限管理页面开启/取消该权限。",
	" ",
	"3.7 参与游戏内某些特定功能或活动可能涉及拍照、截图、扫描二维码、录制视频场景，如您有意使用该等功能，我们需要访问您的设备相机和/或设备录音（麦克风）相关权限以完成相关拍摄或录制，同时我们需要访问您写入外置存储权限以完成拍摄、录制成果的存储及上传或扫描图像的缓存并收集您基于扫描二维码、拍摄照片、拍摄视频后向我们主动上传的图片、视频信息。如您拒绝提供前述权限和内容的，仅会使您无法使用该等功能，但并不影响您正常使用产品与/或服务的其他功能。同时，您也可以随时通过您的设备系统权限管理页面开启/取消前述权限。",
	" ",
	"3.8 当您向鑫线游戏发起投诉、申诉或进行咨询时，为了您的账号与系统安全，我们可能需要您先行提供账号信息，并与您之前的个人信息相匹配以验证您的用户身份。同时，为了方便与您联系或帮助您解决问题，我们可能还需要您提供姓名、手机号码、电子邮件及其他联系方式等个人信息（个人敏感信息）。另外，我们还会收集您与我们的沟通信息（包括文字/图片/音视频/通话记录形式）、与您的需求相关联的其他必要信息。我们收集这些信息是为了调查事实与帮助您解决问题，如您拒绝提供上述信息，我们可能无法向您及时反馈投诉、申诉或咨询结果。",
	" ",
	"3.9 您理解并知悉，您向外部第三方（鑫线游戏旗下关联公司不在此限）提供的个人信息，或外部第三方收集的您的个人信息，我们无法获取，更不会使用非常规方式（如：恶意干预对方系列APP数据）擅自以软件程序获得您的个人信息。鑫线游戏可能因业务发展的需要而确实需要从第三方间接收集（如共享等）您的个人信息的，且由我们直接或共同为您提供产品或服务的，我们（或第三方）在收集前会向您明示共享的您个人信息的来源、类型、使用目的、方式和所用于的业务功能、授权同意范围（如果使用方式和范围超出您在第三方原授权范围的，我们会再次征得您的授权同意）。我们的某些产品或服务由第三方业务合作伙伴提供或共同提供时，为了必要且合理的开展业务，我们可能会从部分业务合作伙伴处间接收集的您的部分信息、其他方使用我们的产品与/或服务时所提供有关您的信息。我们的专业安全团队对个人信息将进行安全加固（包括敏感信息报备、敏感信息加密存储、访问权限控制等）。我们会使用不低于我们对自身用户个人信息同等的保护手段与措施对间接获取的个人信息进行保护。",
	" ",
	"3.10 为您展示和推送产品或服务，我们可能使用您的信息，您的浏览及搜索记录、设备信息、位置信息、订单信息，提取您的浏览、搜索偏好、行为习惯、位置信息等特征，并基于特征标签通过电子邮件、短信、电话或其他方式向您发送营销信息，提供或推广我们的产品或服务。我们可能在必需时（例如当我们由于系统维护而暂停提供服务、变更、终止提供单项服务时）向您发出与服务有关的通知。",
	" ",
	"3.11出于其他合理且必要的目的",
	" ",
	"（1）如前文所述，如果某一需要收集您的个人信息的功能或产品/服务未能在本隐私政策中予以说明的，或者我们超出了与收集您的个人信息时所声称的目的及具有直接或合理关联范围的，我们将在收集和使用您的个人信息前，通过更新本隐私政策、页面提示、弹窗、站内信、网站公告或其他便于您获知的方式另行向您说明，并为您提供自主选择同意的方式，且在征得您明示同意后收集和使用。",
	" ",
	"（2）您理解并同意，在以下情况下，我们无需取得您的授权同意即可收集和使用您的个人信息：",
	" ",
	"a)与国家安全、国防安全有关的；",
	"b)与公共安全、公共卫生、重大公共利益有关的；",
	"c)与犯罪侦查、起诉、审判和判决执行等直接相关的；",
	"d)出于维护您或其他个人的生命、财产等重大合法权益但又很难得到您本人同意的；",
	"e)所收集的信息是您自行向社会公开的或者是从合法公开的渠道（如合法的新闻报道、政府信息公开等渠道）中收集到的；",
	"f)根据与您签订和履行相关协议或其他书面文件所必需的；",
	"g)用于维护我们的产品与/或服务的安全稳定运行所必需的，例如发现、处置产品与/或服务的故障；",
	"h)有权机关的要求、法律法规等规定的其他情形。",
	" ",
	"四、我们如何存储、保护及使用您的信息",
	" ",
	"4.1 存储：我们将仅在本隐私政策所述目的所必需的期间和法律法规要求的时限内保留您的私人信息,且您的信息在收集后将仅存储于中华人民共和国境内。",
	" ",
	"4.2 保护：我们使用符合业界标准的安全防护措施保护您提供的个人信息，防止数据遭到未经授权的访问、公开披露、使用、修改，防止数据发生损坏或丢失。我们会采取一切合理可行的措施，保护您的个人信息。例如对数据进行加密保护；我们已建立访问控制机制，确保只有授权人员才可以访问个人信息；我们不时的举办安全和隐私保护培训课程，加强员工对于保护个人信息重要性的认识。若发生个人信息泄露等安全事件，我们会启动应急预案，阻止安全事件扩大。安全事件发生后，我们会以公告、推送通知或邮件等形式告知您安全事件的基本情况、我们即将或已经采取的处置措施和补救措施，以及我们对您的应对建议。如果难以实现逐一告知，我们将通过公告等方式发布警示。",
	" ",
	"4.3使用：",
	" ",
	"4.3.1信息使用规则",
	"（1）我们会根据我们收集的信息向您提供各项功能与服务，包括基础游戏功能、玩家互动功能、直播功能、消费功能等；",
	" ",
	"（2）我们会根据您使用鑫线游戏产品的频率和情况、故障信息、性能信息等分析我们产品的运行情况，以确保服务的安全性，并优化我们的产品，提高我们的服务质量。我们不会将我们存储在分析软件中的信息与您提供的个人身份信息相结合；",
	" ",
	"（3）帮助您能够在客户端查看您的游戏历史记录、历史数据回顾。用于判断您的游戏行为是否符合未成年人游戏行为特征，以决定是否将此账号纳入到防沉迷体系中以及采取的具体防沉迷措施。",
	" ",
	"4.3.2告知变动目的后征得同意的方式",
	" ",
	"我们将会在本隐私政策所涵盖的用途内使用收集的信息。如我们使用您的个人信息，超出了与收集时所声称的目的及具有直接或合理关联的范围，我们将在使用您的个人信息前，再次向您告知并征得您的明示同意。",
	" ",
	"4.3.3对外提供",
	" ",
	"（1）除本隐私政策以及《鑫线游戏用户协议》规定的情形之外，我们不会主动共享、提供或转让您的个人信息至鑫线游戏外的第三方，如存在其他共享、提供或转让您的个人信息或您需要我们将您的个人信息共享、提供或转让至鑫线游戏外的第三方情形时，我们会直接或间接通过该第三方征得您对上述行为的明示同意。",
	" ",
	"我们重视对您的个人信息的保护，您的个人信息是我们为您提供产品与/或服务的重要依据和组成部分，对于您的个人信息，我们仅在本隐私政策所述目的和范围内或根据法律法规的要求收集和使用，并严格保密。通常情况下，我们不会与任何公司、组织和个人共享您的个人信息，但以下情况除外：",
	" ",
	"1）事先已获得您的明确授权或同意；",
	" ",
	"2）根据适用的法律法规、法律程序、政府的强制命令或司法裁定而需共享您的个人信息；",
	" ",
	"3）在法律要求或允许的范围内，为了保护鑫线游戏及其用户或社会公众的利益、财产或安全免遭损害而有必要提供您的个人信息给第三方；",
	" ",
	"4）您的个人信息可能会在我们的关联公司之间共享。我们只会共享必要的个人信息，且这种共享亦受本隐私政策声明目的的约束。关联公司如要改变个人信息的处理目的，将再次征求您的授权同意。",
	" ",
	"为了向您提供更完善、优质的产品和服务，我们的某些服务将由授权合作伙伴提供。我们可能会与合作伙伴共享您的某些个人信息，以提供更好的客户服务和用户体验。我们仅会出于合法、正当、必要、特定、明确的目的共享您的个人信息，并且只会共享提供服务所必要的个人信息。同时，我们会与合作伙伴签署严格的保密协定，要求他们按照我们的说明、本隐私政策以及其他任何相关的保密和安全措施来处理您的个人信息。我们的合作伙伴无权将共享的个人信息用于任何其他用途。如果您拒绝我们的合作伙伴在提供服务时收集为提供服务所必须的个人信息，将可能导致您无法在我们的平台中使用该第三方服务。通常我们的合作伙伴有如下几类：",
	" ",
	"1）为我们的产品与/或服务提供功能支持的服务提供商：例如提供支付服务的支付机构、提供配送服务的第三方公司和其他服务提供商，我们共享信息的目的仅为实现我们产品与/或服务的功能；",
	" ",
	"2）为提升您的用户体验，例如优化广告效果，我们可能需要向第三方合作伙伴等，分享已经匿名化或去标识化（是指通过对个人信息的技术处理，使其在不借助额外信息的情况下，无法识别或关联个人信息主体的过程）处理后的信息，要求其严格遵守我们关于数据隐私保护的措施与要求，包括但不限于根据数据保护协议、承诺书及相关数据处理政策进行处理，避免识别出个人身份，保障隐私安全；",
	" ",
	"3）向您提供我们的产品或服务，我们可能向合作伙伴及其他第三方分享您的信息，以实现您需要的核心功能或提供您需要的服务，例如：向物流服务商提供对应的订单信息；向通讯服务提供商提供对应的联系信息；",
	" ",
	"4）第三方SDK类服务商：我们的产品中可能会包含第三方SDK或其他类似的应用程序，如您在我们平台上使用这类由第三方提供的服务时，您同意将由其直接收集和处理您的信息（如以嵌入代码、插件等形式）。目前我们产品中包含的第三方SDK服务请具体查阅《鑫线游戏第三方SDK目录》http://app.xingames.com/policy/。前述服务商收集和处理信息等行为遵守其自身的隐私条款，而不适用于本政策。为了最大程度保障您的信息安全，我们建议您在使用任何第三方SDK类服务前先行查看其隐私条款。为保障您的合法权益，如您发现这等SDK或其他类似的应用程序存在风险时，建议您立即终止相关操作并及时与我们取得联系；",
	" ",
	"5）我们不会向合作伙伴分享可用于识别您个人身份的信息（例如您的姓名或电子邮件地址），除非您明确授权。",
	" ",
	"（2）除本隐私政策以及《鑫线游戏用户协议》另有规定外，我们不会对外公开披露所收集的个人信息。我们仅会在以下情况下，且采取符合业界标准的安全防护措施的前提下，披露您的信息：根据法律、法规的要求、强制性的行政执法或司法要求所必须提供您的信息的情况下，我们可能会依据所要求的信息类型和披露方式披露您的信息。在符合法律法规的前提下，当我们收到上述披露信息的请求时，我们会要求接收方必须出具与之相应的法律文件，如传票或调查函。我们坚信，对于要求我们提供的信息，应该在法律允许的范围内尽可能保持透明。我们对所有的请求都进行了慎重的审查，以确保其具备合法依据，且仅限于执法部门因特定调查目的且有合法权利获取的数据。如必须公开披露时，我们会向您告知此次公开披露的目的、披露信息的类型及可能涉及的敏感信息，并征得您的明示同意。",
	" ",
	"（3）随着我们业务的持续发展，我们有可能进行合并、收购、资产转让等交易，我们将告知您相关情形，按照法律法规及不低于本隐私政策所要求的标准继续保护或要求新的控制者继续保护您的个人信息。",
	" ",
	"（4）根据相关法律法规及国家标准，以下情形中，我们可能会共享、转让、公开披露个人信息无需事先征得您的授权同意：",
	" ",
	"1） 与国家安全、国防安全直接相关的；",
	"2） 与公共安全、公共卫生、重大公共利益直接相关的；",
	"3） 与犯罪侦查、起诉、审判和判决执行等直接相关的；",
	"4） 出于维护个人信息主体或其他个人的生命、财产等重大合法权益但又很难得到本人同意的；",
	"5） 个人信息主体自行向社会公众公开个人信息的；",
	"6） 从合法公开披露的信息中收集个人信息的，如合法的新闻报道、政府信息公开等渠道。",
	" ",
	"五、您管理个人信息的权利",
	" ",
	"我们理解您对个人信息的关注，并尽全力确保您对于自己个人信息访问、更正、删除以及撤回授权的权利，以使您拥有充分的能力保障您的隐私和安全。您的权利包括：",
	" ",
	"5.1您有权访问您的个人信息",
	" ",
	"您可以按照我们提供的产品和服务的相关说明（或设置），对您已提供给我们的相关个人信息进行查阅。包括：",
	" ",
	"账号信息：您可以通过相关产品页面随时登陆您的个人中心，以访问您账号中的个人资料信息，包括：头像、昵称、UID、二维码名片、性别、出生年月、个人签名等；",
	" ",
	"使用信息：您可以通过相关产品页面随时查阅您的使用信息，包括：动态发布内容、投稿内容、收藏记录、历史记录、订单信息、地址信息、账单记录等；",
	" ",
	"其他信息：如您在访问过程中遇到操作问题需获取其他前述无法获知的个人信息内容，您可通过本隐私政策提供的方式联系我们。",
	" ",
	"5.2您有权更正/修改您的个人信息",
	" ",
	"当您发现您提供给我们的个人信息存在登记错误、不完整或有更新的，您可在我们的产品和/或服务中更正/修改您的个人信息。",
	" ",
	"对于您的部分个人信息，我们在产品的相关功能页面为您提供了操作设置，您可以直接进行更正/修改。",
	" ",
	"对于您在行使上述权利过程中遇到的困难，或者其他可能目前无法向您提供在线自行更正/修改服务的，经过对您身份的验证，且更正/修改不影响信息的客观性和准确性的情况下，您有权对错误或不完整的信息作出更正或修改，或在特定情况下，尤其是数据错误时，通过我们公布的反馈与报错等措施将您的更正/修改申请提交给我们，要求我们更正或修改您的数据，但法律法规另有规定的除外。但出于安全性和身份识别的考虑，您可能无法修改注册时提交的某些初始注册信息。",
	" ",
	"5.3您有权删除您的个人信息",
	" ",
	"对于您的部分个人信息，您也可以自行通过我们提供的相关产品和服务的功能页面，主动删除您提供信息。您也可以自主删除您发布的视频、动态、图片等。一旦您删除后，我们即会对此类信息进行删除或匿名化处理，除非法律法规另有规定。",
	" ",
	"5.4当发生以下情况时，您可以直接要求我们删除您的个人信息，但已做匿名化处理或法律法规另有规定的除外：",
	" ",
	"（1）当我们处理个人信息的行为违反法律法规时；",
	"（2）当我们收集、使用您的个人信息，却未征得您的同意时；",
	"（3）当我们处理个人信息的行为违反了与您的约定时；",
	"（4）当您注销了账号时；",
	"（5）当我们终止服务及运营时。",
	"5.5您有权撤回您对个人信息的授权",
	" ",
	"如前文所述，我们提供的产品和服务的部分功能需要获得您使用设备的相关权限（包括：位置、相机、麦克风、日程安排等，具体以产品实际获取的功能为准）。您可以在授权后随时撤回（或停止）对该权限的继续授权。例如您可以通过iOS设备中的“设置-隐私-照片”来关闭您对手机相册的授权。您也可以通过注销账号的方式，永久撤回我们继续收集您个人信息的全部授权。您需理解，当您撤回授权后，我们无法继续为您提供撤回授权所对应的特定功能和/或服务。但您撤回授权的决定，不会影响此前基于您的授权而开展的个人信息处理。",
	" ",
	"5.6您有权注销您的账号",
	" ",
	"您可以通过在线申请注销或客服或通过其他我们公示的方式申请注销您的账号。当您注销账号后，您将无法再以该账号登录和使用我们的产品与服务；且该账号在鑫线游戏其他产品与服务使用期间已产生的但未消耗完毕的权益及未来的逾期利益等全部权益将被清除；该账号下的内容、信息、数据、记录等将会被删除或匿名化处理（但法律法规另有规定或监管部门另有要求的除外，如依据《中华人民共和国网络安全法》规定，您的网络操作日志将至少保留六个月的时间）；账号注销完成后，将无法恢复。",
	" ",
	"如您在谨慎考虑后仍决定注销您的账号的，您可以在您使用的我们的产品与/或服务的相关功能设置页面或根据操作指引向我们提交注销申请。",
	" ",
	"如果您在处置您的个人信息时有任何疑问，您可通过本隐私政策第八条所列的联系方式与我们沟通解决。",
	" ",
	"六、未成年人保护",
	" ",
	"6.1 未成年人使用我们的产品与/或服务前应取得其监护人的同意。",
	" ",
	"6.2 如您为未成年人，在使用我们的产品与/或服务前，应在监护人监护、指导下共同阅读本隐私政策且应在监护人明确同意和指导下使用我们的产品与/或服务、提交个人信息。我们根据国家相关法律法规的规定保护未成年人的个人信息，只会在法律法规允许、监护人明确同意或保护您的权益所必要的情况下收集、使用或公开披露未成年人的个人信息。",
	" ",
	"6.3 若您是未成年人的监护人，当您对您所监护的未成年人的个人信息有相关疑问时，您可通过本隐私政策第八条所列的联系方式与我们沟通解决。如果我们发现在未事先获得可证实的监护人同意的情况下收集了未成年人的个人信息，则会尽快删除相关数据。",
	" ",
	"6.4我们会积极按照国家防沉迷政策要求，通过启用防沉迷系统保护未成年人的合法权益。我们会通过实名身份等信息校验判断相关账号的实名信息是否为未成年人，进而决定是否将此账号纳入到防沉迷体系中。另外，我们会收集您的登录时间、游戏时长等信息，通过从系统层面自动干预和限制未成年人游戏时间、启用强制下线功能等方式，引导未成年人合理游戏，并在疑似未成年人消费后尝试联系其监护人进行提醒、确认与处理，帮助未成年人健康上网。",
	" ",
	" ",
	" ",
	"七、Cookie是什么、我们会怎样使用cookie",
	" ",
	"7.1 Cookie是您的网页浏览器的一项功能,允许网站向您的计算机发送一定量的信息供保存记录用。保存在您计算机上的cookie可以用来“记忆”某些信息,例如您的密码或记录下您已经注册过的项目,通过省去您输入密码或注册信息等步骤,使您将来在网站上的操作更加快速、省时。此外,出于宣传、营销或安全考虑,我们还将通过cookie回收用户信息。我们使用Cookie以实现诸多目的，如记录用户会话信息、登陆和操作状态、默认语言配置等。使用Cookie将使您在使用鑫线游戏服务时获得更好的体验。",
	" ",
	"7.2 如果您拒绝我们使用Cookie及同类技术收集和使用您的相关信息，您可在浏览器具备该功能的前提下，通过您的浏览器的设置以管理、（部分/全部）拒绝Cookie与/或同类技术；或删除已经储存在您的计算机、移动设备或其他装置内的Cookie与/或同类技术，从而实现我们无法全部或部分追踪您的个人信息。您如需详细了解如何更改浏览器设置，请具体查看您使用的浏览器的相关设置页面。您理解并知悉：我们的某些产品/服务只能通过使用Cookie或同类技术才可得到实现，如您拒绝使用或删除的，您可能将无法正常使用我们的相关产品与/或服务或无法通过我们的产品与/或服务获得最佳的服务体验，同时也可能会对您的信息保护和账号安全性造成一定的影响。",
	" ",
	"八、如何联系我们",
	" ",
	"8.1如您对隐私政策的内容或使用我们的服务时遇到的与隐私保护相关的事宜有任何疑问或进行咨询或投诉、举报时，均可以通过如下任一方式与我们取得联系：",
	" ",
	"通过客服邮箱：gm@xingames.com以及鑫线游戏官方网站http://www.xingames.com/公布的联系方式与我们联系；",
	" ",
	"若您有相关投诉及建议，可以通过我们的投诉建议专用邮箱：soldier@xingames.com  进行反馈",
	" ",
	"8.2一般情况下，我们将在收到您的问题、意见或建议，并验证您的用户身份后15个工作日内回复。如果您对我们的回复不满意，特别是我们的个人信息处理行为损害了您的合法权益，您还可以向网信、电信、公安及市场监督管理等监管部门进行投诉或举报。此外，您理解并知悉，在与个人信息有关的如下情形下，我们将无法回复您的请求：",
	" ",
	"(1) 与国家安全、国防安全有关的；",
	"(2) 与公共安全、公共卫生、重大公共利益有关的；",
	"(3) 与犯罪侦查、起诉和审判等有关的；",
	"(4) 有充分证据表明您存在主观恶意或滥用权利的；",
	"(5) 响应您的请求将导致您或其他个人、组织的合法权益受到严重损害的；",
	"(6) 涉及商业秘密的；",
	"(7) 法律法规等规定的其他情形。",
	" ",
	"本隐私政策更新于2021年7月20日",
	" ",
	" ",
}

ProtocolAgreement_String = {
	"一、总 则",
	"1.1 用户在使用本公司的服务（包括注册、登录、使用、浏览等）之前，应当仔细阅读、充分理解本协议条款，特别是免除或者限制本公司责任的免责条款及对用户的权利限制条款。请您审慎阅读并选择接受或不接受本《协议》（未成年人应在法定监护人陪同下阅读）。除非您接受本协议所有条款，否则您无权注册、登录、使用、浏览本协议所涉相关服务。您的注册、登录、使用、浏览等行为将视为已接受本协议的全部内容，并同意受其约束。本公司的通知、公告、声明或其它类似内容是本协议及应用规则的一部分。",
	" ",
	"1.2 本公司可能不定期对本协议进行更新，并公布以代替原来的协议条款，恕不再另行通知，用户可在网站查阅最新版协议条款。在本公司对协议进行了更新修改后，如用户不接受修改后的条款，请立即停止使用本公司提供的服务，用户继续使用本公司提供的服务将被视为已接受了修改后的协议。",
	" ",
	"二、服务内容",
	"2.1 鑫线游戏的具体服务内容由本公司根据实际情况提供，并不定期进行更新、增删。",
	" ",
	"2.2 本公司在提供网络服务时，可能会对部分网络服务用户收取一定的费用。在此情况下，会在相关页面上做明确的提示。如用户不同意支付该等费用，则可不接受相关的网络服务。",
	" ",
	"2.3 当您发现您的账号或密码被他人非法使用或有使用异常的情况的，应第一时间根据本公司公布的处理方式通知本公司。",
	" ",
	"2.4 本公司根据您的通知并在您提供了与注册信息相一致的个人身份信息及其他本公司要求的资料后，本公司将采取相应的处理措施，包括但不限于暂停您的账号，停止账号功能等。如果您未能提供符合要求并经核实确认的相关信息资料的，本公司有权拒绝您的要求。",
	" ",
	"2.5 当您的账号出现权属权纠纷时，本公司为保障您的利益，有权暂停该账号登录和使用。",
	" ",
	"2.6 您必须保管好自己的账号和密码，由于您的原因导致账号和密码泄密而造成的后果均将由您自行承担。",
	" ",
	"三、使用规则",
	"3.1 用户使用本公司提供之软件服务必须遵守中华人民共和国相关法律法规，并对其自行发表、上传或传送的内容负全部责任，不得发布、转载、传送含有下列内容之一的信息，否则本公司有权视情节自行处理：",
	"　(1) 违反宪法确定的基本原则的；",
	"　(2) 危害国家安全，泄漏国家机密，颠覆国家政权，破坏国家统一的；",
	"　(3) 损害国家荣誉和利益的；",
	"　(4) 煽动民族仇恨、民族歧视，破坏民族团结的；",
	"　(5) 破坏国家宗教政策，宣扬邪教和封建迷信的；",
	"　(6) 散布谣言，扰乱社会秩序，破坏社会稳定的；",
	"　(7) 散布淫秽、色情、赌博、暴力、恐怖或者教唆犯罪的；",
	"　(8) 侮辱或者诽谤他人，侵害他人合法权益的；",
	"　(9) 煽动非法集会、结社、游行、示威、聚众扰乱社会秩序的；",
	"　(10) 以非法民间组织名义活动的；",
	"　(11) 含有法律、行政法规禁止的其他内容的。",
	" ",
	"3.2 用户在使用网络服务时须遵守以下规定：",
	"　(1) 不得为任何非法目的而使用网络服务系统；",
	"　(2) 遵守所有与网络服务有关的网络协议、规定和程序；",
	"　(3) 不得利用本公司提供之网络服务进行任何可能对互联网的正常运转造成不利影响的行为。",
	" ",
	"3.3 本软件注册帐号的所有权归本公司所有，用户完成申请注册手续后，获得本软件帐号的使用权，该使用权仅属于初始申请注册人，禁止赠与、借用、租用、转让或售卖。本公司因经营需要，有权回收用户的注册帐号。",
	" ",
	"3.4 用户有权更改、删除在本软件上的个人资料、注册信息及传送内容等，但需注意，删除有关信息的同时也会删除任何您储存在系统中的文字和图片。用户需承担该风险。",
	" ",
	"3.5 用户有责任妥善保管注册帐号信息及帐号密码的安全，用户需要对注册帐号以及密码下的行为承担法律责任。用户同意在任何情况下不使用其他成员的帐号或密码。在用户怀疑他人在使用您的帐号或密码时，您同意立即通知本公司。",
	" ",
	"3.6 用户注册本软件帐号后在6个月内未登陆该帐号，本公司有权回收该帐号，以免造成资源浪费，由此带来问题均由用户自行承担。",
	" ",
	"3.7 当第三方认为用户侵犯、妨害、威胁其权利或安全，或者假冒他人的行为，本公司有权依法依其自行判断对违反本条款的任何人士采取适当的法律行动，包括但不限于，从本软件服务中删除具有违法性、侵权性、不当性等内容，阻止其使用本软件全部或部分服务，冻结或注销注册帐号等。",
	" ",
	"3.8 本软件服务的文字、图片、音频、视频等版权均归本公司享有或本公司已得到相关权利人的合法授权，未经本公司或权利人许可，不得任意复制、转载或用于任何商业目的。",
	" ",
	"3.9 本公司为提供网络服务而使用的任何软件（包括但不限于软件中所含的任何图象、照片、动画、录像、录音、音乐、文字和附加程序、随附的帮助材料等）的一切权利均属于该软件的著作权人，未经该软件的著作权人许可，用户不得对该软件进行反向工程（ reverse engineer）、反向编译（ decompile）或反汇编（ disassemble）。",
	" ",
	"3.10 用户使用本公司提供之服务必须遵守中华人民共和国相关法律法规，不得有下列行为之一，否则本公司有权视情节自行处理，包括但不限于删除涉嫌侵权信息、暂停或终止用户使用本公司相关服务、冻结或收回注册帐户等一切处理措施：",
	"　(1) 侵入、拦截、破坏、复制、修改游戏程序，以及宣扬、叫卖和使用各种辅助性程序或恶性非法程序，即使用外挂程序、或在游戏中宣传外挂程序的行为。",
	"　(2) 以任何弄虚作假的形式来蒙蔽或者欺骗其他用户，如发布模仿官方并带有病毒的网站、非官方中奖信息、非法广告、游戏代码、木马、外挂、病毒、色情信息、垃圾广告等信息",
	"　(3) 通过注册帐户发布非法网站，宣传或使用私服、游戏代码、木马、外挂、病毒、色情信息、垃圾广告、非法广告等信息",
	"　(4) 宣传或贩卖BUG、攻击服务器运行、牟取个人利益、影响游戏公平性，以及影响其他玩家正常进行游戏等行为",
	"　(5) 盗取或参与盗取他人账号，给被盗者造成严重损失的行为",
	"　(6) 侮辱、毁谤、猥亵、威胁、辱骂其他用户，扭曲事实、恶意散布不实谣言，恶意影响游戏环境等行为。",
	" ",
	"3.11 用户一旦在本软件服务上上传或张贴内容，即视为用户授予本公司该内容著作权之免费及非独家、永久的许可使用权，本公司有权为展示、传播及推广前述内容之目的，对上述内容进行复制、修改、出版。由此展示、传播及推广行为所产生的损失或利润，均由本公司承担或享受。",
	" ",
	"四、关于虚拟物品的约定",
	"　　游戏中的各种虚拟物品量不限于金币、银两、道具、装备等，其所有权归本公司所有。用户只能在合乎法律和游戏规则的情况下拥有对虚拟物品的使用权。用户一旦购买了虚拟道具的使用权，将视为自动进入消费过程，不得以任何名义要求退还该虚拟道具。 为维护本公司游戏内的正常秩序，本公司仅对在游戏系统以正当途径产生或获取的游戏币、道具、装备等虚拟物品予以承认。本公司反对玩家自行进行线下交易，游戏内的游戏币、道具、装备等虚拟物品都不允许线下交易的。若玩家自行线下交易出现任何问题本公司将不给予受理，玩家将自行负责。同时，一旦本公司核查前述虚拟物品为非正当途径（包括但不限于线下交易）取得的，本公司将会采取回收（即视为系统未产生该虚拟物品）方式以维护游戏的正常秩序。相关损失将由您自己承担，请您务必遵守游戏规则及本协议，不要以线下交易等非正当途径的方式获取虚拟物品，否则您将自己承担所有的不利后果。",
	" ",
	" ",
	"五、法律责任及免责",
	"5.1 用户明确同意其使用本公司服务所存在的风险及一切后果将完全由用户本人承担，本公司 对此不承担任何责任。",
	" ",
	"5.2 本公司不保证为方便用户而设置的外部链接的准确性和完整性，同时，对于该等外部链接指向的不由本公司实际控制的任何网页上的内容，本公司不承担任何责任。",
	" ",
	"5.3 对于因不可抗力或本公司不能控制的原因造成的网络服务中断或其它缺陷，本公司不承担任何责任，但将尽力减少因此而给用户造成的损失和影响。",
	" ",
	"5.4 任何由于计算机自身问题、黑客攻击、计算机病毒侵入或发作，因政府管制而造成的暂时性关闭等影响提供正常服务的不可抗力而造成的个人资料泄露、丢失、被盗用或被窜改等，本公司 对此不予承担任何责任。",
	" ",
	"5.5 用户应保证其自行上传、分享的信息、视频、文字等一切信息属于《中华人民共和国著作权法》规定的作品，并对上传之作品均享有完整的知识产权，或者已经得到相关权利人的合法授权。同时，用户保证其所上传、分享的一切信息安全。由于用户违反本条而引发的问题，本公司不承担任何责任。用户应当确保其使用本公司之网络服务将用于恰当的用途，严禁任何非法或违背相关准则规定的行为。由此引发的问题，本公司不承担任何责任。同时，当第三方认为用户侵犯其权利，并向本公司发送相关书面通知时，用户同意本公司可以自行判断并采取包括但不限于删除涉嫌侵权信息、暂停或终止用户使用本公司相关服务、冻结或收回注册帐户等一切处理措施。",
	" ",
	"5.6 用户违反本协议或相关的服务条款的规定，导致或产生的任何第三方主张的任何索赔、要求或损失，包括合理的律师费，用户同意赔偿本公司与合作公司、关联公司，并使之免受损害。同时，用户同意本公司有权视用户的行为性质采取包括但不限于删除涉嫌侵权信息、暂停或终止用户使用本公司相关服务、冻结或收回注册帐户、追究相应的法律责任等一切处理措施。",
	" ",
	"5.7 本公司保留因业务发展需要，单方面对本服务的全部或部分服务内容在任何时候不经任何通知的情况下进行变更、暂停、限制、终止或撤销本软件中任何一项服务的权利，用户需承担此风险。",
	" ",
	"5.8 本软件提供的服务中可能包括广告，用户同意在使用过程中显示本软件和第三方供应商、合作伙伴提供的广告。",
	" ",
	"5.9 为维护游戏的公平性，如本公司发现用户数据异常，无论用户对该异常数据产生是否负有过错，本公司均有权根据本协议、游戏公约、玩家守则及后期不时发布的游戏公告等，采取相应措施：包括但不限于对该账号的冻结、封号、删除；用户在此同意本公司有权采取上述行动，并承诺不就上述行为要求本公司做任何补偿或退费。",
	" ",
	"六、知识产权",
	"6.1 产品和服务中所涉及的图形、文字或其组成，以及其他本公司的标志及产品、服务名称，均为本公司的商标、标识。未经本公司事先书面同意，您不得将本公司标识以任何方式展示或使用或作其他处理，也不得向他人表明您有权展示、使用、或其他有权处理本公司标识的行为。",
	" ",
	"6.2 用户须明白，在使用本服务过程中存在有来自任何他人的包括威胁性的、诽谤性的、令人反感的或非法的内容或行为或对他人权利的侵犯（包括知识产权）的匿名或冒名的信息的风险，您须承担以上风险，本公司和合作公司对本服务不作任何类型的担保，不论是明确的或隐含的，包括所有有关信息真实性、适用性、所有权和非侵权性的默示担保和条件，对因此导致任何因用户不正当或非法使用服务产生的直接、间接、偶然、特殊及后续的损害，不承担任何责任。 信息内容包括：文字、软件、声音、相片、录像、图表；在广告中全部内容；本公司为用户提供的商业信息，所有这些内容受版权、商标权、和其它知识产权和所有权法律的保护。所以，您在未获得本公司或相关权利人授权下不能擅自复制、修改、编纂这些内容、或创造与内容有关的衍生产品，否则您应当承担赔偿本公司或相关权利人因此受到所有的经济损失。",
	" ",
	"七、附则",
	"7.1 本协议的订立、执行和解释及争议的解决均应适用中华人民共和国法律。若用户和本公司发生任何争议或纠纷，用户在此完全同意将争议或纠纷提交本协议签订地人民法院管辖。",
	" ",
	"7.2 如本协议中的任何条款全部或部分无效或不具有执行力，不影响其他条款的效力。本协议各条款内容的解释权及修订权归本公司所有。",
	" ",
	" ",
}