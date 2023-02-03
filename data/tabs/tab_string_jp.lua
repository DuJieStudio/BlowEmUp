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
_tab_string["realnamecheck_err20010"] = "身份证填写为空或非法"
_tab_string["realnamecheck_err20310"] = "姓名填写为空或非法"
_tab_string["realnamecheck_errcode"]="版署实名验证失败\n错误码："
_tab_string["try_again_later"]= "系统繁忙,请稍后再试"
_tab_string["pleace_choose_logintype"]= "请选择登录方式"
_tab_string["remaining_time"]= "剩余游戏时间"
_tab_string["realname_1"] = "根据国家新闻出版署《关于防止未成年人沉迷网络游戏的通知》，响应国家号召，帮助未成年人树立正确的网络游戏消费观念和行为习惯，需要对账号进行实名认证，请输入您的身份证号码，进行实名认证"
_tab_string["realname_2"] = "根据国家新闻出版署《关于防止未成年人沉迷网络游戏的通知》，响应国家号召，帮助未成年人树立正确的网络游戏消费观念和行为习惯。\n您当前游戏时长已经超过规定的游戏时长，或者您处于非规定的游戏时间段内。\n系统将会强制您下线，给您带来的不便，敬请见谅。"
_tab_string["realname_3"] = "根据您的账号信息，您已被识别为【未成年人】。本游戏对未成年人做了如下限制：\n1、每日22时至次日8时无法进行游戏\n2、工作日游戏时长不得超过1.5小时，周末游戏时长不得超过3小时\n3、游戏内的充值消费会有额度限制"
_tab_string["realname_4"] = "根据国家新闻出版署最新规定，您是未成年人无法进入本游戏,  感谢配合！"

_tab_string["__TEXT_GetPhoneIDError"] = "获取手机号失败，错误码:"
_tab_string["douhao"] = "，"
_tab_string["__TEXT_Game_Privacy"] = "请阅读并同意"
_tab_string["__TEXT_And"] = "及"
_tab_string["__TEXT_Privacy"] = "隐私政策"
_tab_string["__TEXT_Protocol"] = "用户协议"
_tab_string["__TEXT_GamePrivacy_Title"] = "鑫线游戏隐私政策"
_tab_string["__TEXT_GameProtocol_Title"] = "鑫线游戏用户协议"
_tab_string["NoAgreeAndExit"] = "由于你不同意 《鑫线游戏%s及%s》，已退出游戏。"
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
_tab_string["waitannounce"] = "获取公告内容中，请稍后再试"

--------------------------------------------------------------------------
--从这开始调用翻译

--プログラムのために移動しないでください
g_input_erro_info = {}
g_input_erro_info[1] = "duplicate name"
g_input_erro_info[2] = "invalid name"
g_input_erro_info[3] = "invalid name"
g_input_erro_info[4] = "too long"
g_input_erro_info[5] = "invalid name"
g_input_erro_info[6] = "unaccepctable name"
g_input_erro_info[7] = "unaccepctable name"
--[[
g_input_erro_info [1] = "名前は既存のアーカイブと同じです"
g_input_erro_info [2] = "名前が入力されていません"
g_input_erro_info [3] = "名前にスペースを含めることはできません"
g_input_erro_info [4] = "名前は15文字までの英語または5文字の中国語をサポートします。"
g_input_erro_info [5] = "名前には特殊文字を使用できません"
g_input_erro_info [6] = "入力したコンテンツには,機密性の高い単語が含まれています"
g_input_erro_info [7] = "名前を数字と句読点で始めることはできません"
]]

--失敗後のヒント
g_fail_hint_info ={}
g_fail_hint_info[1] = "111"


_tab_stringGIFT[1] = {}
_tab_stringGIFT[2] = {}
_tab_stringGIFT[3] = {}
_tab_stringGIFT[4] = {}
_tab_stringGIFT[5] = {}

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
_tab_string["__Attr_Hint_grenade_fire"] = "燃烧"
_tab_string["__Attr_Hint_grenade_dis"] = "射程"
_tab_string["__Attr_Hint_grenade_cd"] = "射速"
_tab_string["__Attr_Hint_grenade_crit"] = "暴击"
_tab_string["__Attr_Hint_grenade_multiply"] = "双雷"
_tab_string["__Attr_Hint_inertia"] = "惯性"
_tab_string["__Attr_Hint_crystal_rate"] = "水晶产量"
_tab_string["__Attr_Hint_melee_bounce"] = "冲撞伤害"
_tab_string["__Attr_Hint_melee_fight"] = "轮刀"
_tab_string["__Attr_Hint_pet_hp_restore"] = "宠物治疗"
_tab_string["__Attr_Hint_pet_capacity"] = "携宠"
_tab_string["__Attr_Hint_trap_ground"] = "陷阱时间"
_tab_string["__Attr_Hint_trap_groundcd"] = "陷阱冷却"
_tab_string["__Attr_Hint_trap_groundenemy"] = "陷阱困敌"
_tab_string["__Attr_Hint_trap_fly"] = "天网时间"
_tab_string["__Attr_Hint_trap_flycd"] = "天网冷却"
_tab_string["__Attr_Hint_trap_flyenemy"] = "天网困敌"
_tab_string["__Attr_Hint_puzzle"] = "迷惑几率"
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
_tab_string["__Attr_On-hook_proceeds"] = "挂机收益"
_tab_string["__ATTR__Wave"] = "波次"
_tab_string["__TEXT_PAGE_SHOP"] = "商城"
_tab_string["__TEXT_PAGE_PURCHASE"] = "氪石"
_tab_string["__TEXT_PAGE_TASKSTONE"] = "任务石"
_tab_string["__TEXT_PAGE_CHEST"] = "宝箱"
_tab_string["__TEXT_PAGE_GIFT"] = "礼包"
_tab_string["__TEXT_PAGE_MUCHAOZHIZHAN"] = "母巢之战"
_tab_string["__TEXT_PAGE_QIANSHAOZHENDI"] = "前哨阵地"
_tab_string["__TEXT_PAGE_DUOBAIQIBING"] = "夺宝奇兵"

-------------------------------------------------------------
_tab_string["__TEXT_Level"] = "困難"
_tab_string["__TEXT_Reset"] = "リセット "
_tab_string["__TEXT_ResetALL"] = "すべてリセット？"
_tab_string["startgame"] = "ベギン "
_tab_string["norecord"] = "記録なし"
_tab_string["__TEXT_ExitGame"] = "退出游戏"
_tab_string["__TEXT_SorryForErro"] = "游戏出现错误，错误信息："
_tab_string["__TEXT_Quality"] = "品质"
_tab_string["__TEXT_PURCHASE_DESC"] = "获得氪石%d。"
_tab_string["__TEXT_PURCHASE"] = "充值"
_tab_string["ios_deal_ing"] = "上一个交易正在处理中！"
_tab_string["recharge_success"] = "充值成功，请前往【信箱】领取奖励"
_tab_string["recharge_success_short"] = "充值成功！"
_tab_string["__TEXT_RewardLeftTime"] = "剩余领取时间"
_tab_string["__TEXT_Dat"] = "天"
_tab_string["__TEXT_Hour"] = "小时"
_tab_string["__TEXT_Hour_Short"] = "时"
_tab_string["__Minute"] = "分"
_tab_string["__Second"] = "秒"
_tab_string["MadelGift"] = "奖励："
_tab_string["SystemMail_Expired"] = "邮件即将过期，请尽快领取！"
_tab_string["SystemMail_Conetnt"] = "请领取您的奖励。"
_tab_string["__Get__"] = "领取"
_tab_string["ios_gamecoin_intro"] = "可用于购买道具"
_tab_string["ios_taskstone_intro"] = "可用于领取任务进度奖励"
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

--戦術スキルカード資料の開始

_tab_string["["] = "【"
_tab_string["]"] = "】"


_tab_string["__TEXT_WanJia"] = "プレーヤー"
_tab_string["request_errcode"]="エラーコード："
_tab_string["__TEXT_cheatPlayer"] = "あなたのゲームデータは深刻な異常があり、ゲームに入ることができません！"
_tab_string["__TEXT_SetPassWord"] = "パスワードの設定"
_tab_string["__TEXT_SetNewPassWord"] = "新しいパスワードを設定"
_tab_string["__TEXT_SetPassWordInfo"] = "現在のパスワードとして設定する6桁を入力してください"
_tab_string["__TEXT_SetPassWordRs_1"] = "パスワードを正常に設定しました"
_tab_string["__TEXT_SetPassWordRs_2"] = "パスワードの設定に失敗しました"
_tab_string["__TEXT_manger"] = "アカウント管理"
_tab_string["__TEXT_GoToRecharge"] = "リチャージ"
_tab_string["guest"] = "ユーザー"
_tab_string["guest_info1"] = "既存のゲームアカウントを使用してゲームデータを復元する"
_tab_string["guest_check_in"] = "ゲームアカウントのログイン"
_tab_string["Totoltopup"] = "累積リチャージ"
_tab_string["HaveGetTodayReward"] = "今日の報酬を受け取りました！"

_tab_string["App_Download_CMSTG"] = "AppStoreからダウンロード"
_tab_string["App_Comment_CMSTG"] = "Apple Storeのレビューに移動"
_tab_string["commentTitle2"] = "ゲームに関するコメントへようこそ"

_tab_string["AndroidTestTip"] = "テスト期間中,デポジットは利用できません！"

--ストーリーダイアログテキスト
_tab_string["__TEXT_SPEED_UP"] = "スピードアップ！"
_tab_string["__TEXT_HELP"] = "ヘルプ！"
_tab_string["__TEXT_BLOW"] = "ここで爆発！"
_tab_string["__TEXT_WHERE_ARE_WE"] = "「どこにいるの？」"
_tab_string["__TEXT_I_DONOT_KNOWN"] = "わからない"
_tab_string["__TEXT_WHAT_THE_HELL"] = "私は行きます..."
_tab_string["__TEXT_GET_IN"] = "車に乗れ！"
_tab_string["__TEXT_LETS_FIGHT_BACK"] = "それらを突く！"
_tab_string["__TEXT_WE_MADE_IT"] = "勝ちました！"
_tab_string["__TEXT_FINALLY"] = "Oh yeah！"
_tab_string["__TEXT_ARE_WE_SAFE_NOW"] = "今安全ですか？"
_tab_string["__TEXT_WTF"] = "私はそれに依存しています!!!"
_tab_string["__TEXT_AGAIN"] = "また来ました！"
_tab_string["__TEXT_GET_INT_GET_IN"] = "Fast！Fast forward！"
_tab_string["__TEXT_DO_NOT_PANIC_WE_ARE_ON_YOUR_SIDE"] = "恐れるな,恐れるな,私は敵ではない。"
_tab_string["__TEXT_THEY_HAVE_ATTACKED_MANY_NEARTH_FACILITIES_OUTSIDE"] = "私の友人と私は長い間ここに留まっています"
_tab_string["__TEXT_WE_NEED_YOUR_FIRST_HAND_INFORMATION"] = "敵と戦うために一緒に働きましょう！"
_tab_string["__TEXT_IN_EXCHANGE_WE_WILL_HELP_YOU_TO_BEAT_THEM"] = "最初に宇宙船からお連れします。"
_tab_string["__TEXT_A_WAREHOUSE"] = "倉庫ですか？"
_tab_string["__TEXT_WE_SHOULD_GET_SOME_SUPPLY_FROM_IT"] = "ここで補給できます。"
_tab_string["__TEXT_LETS_TAKE_IT_OVER"] = "これは私たちのものです！"
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
_tab_string["__TEXT_CONSUME"] = "消耗"
_tab_string["__TEXT_TEMPORARY_NO"] = "暂时不用"
_tab_string["__TEXT_Equip"] = "装备"
_tab_string["__TEXT_Exchange"] = "分解"
_tab_string["__TEXT_Change"] = "更换"
_tab_string["__TEXT_remove"] = "卸下"
_tab_string["__TEXT_PlayerName"] = "玩家名"
_tab_string["__TEXT_ShiftData0"] = "账号"
_tab_string["__TEXT_Follow"] = "跟随"
_tab_string["__TEXT_CHIP"] = "碎片"

_tab_string["__TEXT_BUILD_INVALID_POINT"] = "该目标点不能建造塔"
_tab_string["__TEXT_BUILD_INVALID_ROAD"] = "该路面不能建造塔"
_tab_string["__TEXT_BUILD_COLLAPSE_UNIT"] = "目标点和单位重叠"
_tab_string["__TEXT_BUILD_COLLAPSE_TOWER"] = "目标点和附近建筑重叠"

_tab_string["__TEXT_CLICK_SCREEN_FINISH"] = "点击屏幕完成"
_tab_string["__TEXT_CLICK_SCREEN_CLOSE"] = "点击屏幕关闭"
_tab_string["__TEXT_CLICK_SCREEN_CONTINUE"] = "点击屏幕继续"
_tab_string["__TEXT_Page_AcreenSpeedUp"] = "点击屏幕加速"

_tab_string["__TEXT_BUY_PET_HINT"] = "收取%d矿石，获得帮手"
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
_tab_string["__TEXT_MapNotPassPreevious"] = "三星通关前一个难度才能挑战"
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
_tab_string["__TEXT_TaskStoneProgreeReward"] = "累计获得%d任务石可领取奖励"
_tab_string["__TEXT_BAGLISTISFULL"] = "背包已满，无法领取道具"
_tab_string["__TEXT_BestStage"] = "层数"
_tab_string["__TEXT_MyRank"] = "我的排名"
_tab_string["__TEXT_MyBestStage"] = "我的层数"
_tab_string["__TEXT_TemporaryNone"] = "暂无"
_tab_string["__TEXT_TemporaryNoneRank"] = "暂无排名"
_tab_string["ios_err_prize_rewarded"] = "奖励已领取"
_tab_string["__GROUP_SERVER_ERROR_TYPE_NO_VALID_PARAM"] = "参数不合法"
_tab_string["__GROUP_SERVER_ERROR_TYPE_NO_TASK_FINISH"] = "未满足任务完成条件"
--_tab_string["__TEXT_GIFT_CONTAIN"] = "礼包包含以下奖励："
_tab_string["ios_err_rename"] = "您输入的名字与已有玩家重名"
_tab_string["ios_err_unknow"] = "未知错误"
_tab_string["__TEXT_send"] = "发送"
_tab_string["__TEXT_CanUseSpecialCharacters"] = "包含不可用字符"
_tab_string["__TEXT_DragDownToLoadMore"] = "向下拖动以加载更多"
_tab_string["__TEXT_CommentIsBottom"] = "评论已经到底"


--===================================================== ===============================================-

--中国語と英語のテキストの変更
_tab_string["CopyDir_Loading_Info"] = "ゲーム環境を設定..."
_tab_string["Updating_Loading_Info"] = "更新中..."
_tab_string["GameStart_Loading_Info"] = "ゲームを読み込んでいます..."
_tab_string["NetInfo"] = "ネットワーク情報"
_tab_string["VersionInfo"] = "バージョン情報"
_tab_string["GameOptionNet"] = "ネットワークモード"
_tab_string["GameOptionSa"] = "ゲームに参加"
_tab_string["GameOptionBbs"] = "レビューを書いてください"
_tab_string["GameOptionLanguage"] = "言語設定"
_tab_string["Version_Local_Label"] = "現在のバージョン"
_tab_string["Version_Local_Version"] = "不明"
_tab_string["Version_Server_Label"] = ""--" 最新バージョン"
_tab_string["Version_Server_Version"] = "不明"
_tab_string["Version_Status_Ok"] = "バージョンステータスOK"
_tab_string["Version_Status_Deformity"] = "バージョンのステータスが不完全です"
_tab_string["Version_Update_Continue"] = "更新を続ける"
_tab_string["Version_Update_Continue2"] = "不完全なバージョンを更新してください"
_tab_string["Version_Update_Start"] = "更新の開始"
_tab_string["Version_Update_Unnecessary"] = "更新は不要です"
_tab_string["Version_Update_Rflesh"] = "更新"
_tab_string["Version_Update_FromApp"] = "Apple Storeから最新バージョンを更新してください"
_tab_string["Version_Update_FromApp_Andriod"] = "最新バージョンに更新してください"
_tab_string["Version_Update_WithoutApp"] = "すでに最新バージョンのApple Store"
_tab_string["Version_Update_WithoutApp_Andriod"] = "既に最新バージョンです"
_tab_string["Main_Runing_NetWorkType0"] = "ネットワークタイプなし"
_tab_string["Main_Runing_NetWorkType1"] = "ネットワークタイプWIFI"
_tab_string["Main_Runing_NetWorkType2"] = "ネットワークタイプ3G"
_tab_string["Main_Runing_GetAnnouncement"] = "アナウンス情報を取得..."
_tab_string["Main_Runing_GetLocalInfo"] = "ローカルバージョン情報を取得..."
_tab_string["Main_Runing_GetNetInfo"] = "ネットワークタイプを取得..."
_tab_string["Main_Runing_GetServerInfo"] = "サーバーのバージョン情報を取得..."
_tab_string["Main_Runing_End"] = ""
_tab_string["Exit_Info"] = "更新が完了しました。ゲームを再起動してください！"
_tab_string["Exit_Ack"] = "OK"
_tab_string["Exit_Wait"] = "後で"
_tab_string["Exit_Now"] = "Exit"
_tab_string["GameSettingInfo"] = "ゲームの再起動後に言語設定が有効になります"
_tab_string["Confirm_Info_Up_"] = "ゲームの最新バージョン"
_tab_string["Confirm_Enter"] = "ゲームに参加"
_tab_string["Confirm_Leave"] = "更新"
_tab_string["Confirm_Update_Later"] = "更新されていません"
_tab_string["Version_Server_Size"] = ""--"バージョンサイズ"
_tab_string["on_loading"] = "加载中..."
_tab_string["Official_Announcement"] = "官方公告"

_tab_string["ios_err_network_cannot_conn2"] = "ネットワークを開いたままにしてください... "
_tab_string["__TEXT_Back_Login"] = "ログインに戻る"
_tab_string["__TEXT_Try_Connect"] = "再接続してみてください"
_tab_string["__TEXT_Buy"] = "购买"
_tab_string["lowconfigmode"] = "低フレームスムーズモード"
_tab_string["CurrentNotGet"] = "未获得"
_tab_string["lowconfig"] = "ローフレーム"
_tab_string["restart"] = "再試行"
_tab_string["not_enough"] = "あまりない"
_tab_string["language_setting"] = "言語設定"
_tab_string["music_on"] = "音楽：オフ"
_tab_string["music_off"] = "音楽：オーン"
_tab_string["screen_setting"] = "スクリーンロック"
_tab_string["screen_horizontal"] = "水平"
_tab_string["screen_vertical"] = "垂直"
_tab_string["screen_unlock"] = "ロックなし"
_tab_string["gameperspective"] = "ゲームの視点"
_tab_string["farview"] = "遠く"
_tab_string["mediumview"] = "真ん中"
_tab_string["nearview"] = "近く"
_tab_string["unlock"] = "ロックキャンセル"
_tab_string["rankboard"] = "リーダーボード"
_tab_string["rank"] = "ランキング"
_tab_string["to_rate"] = "コメントする"
_tab_string["rate_game"] = "あなたのサポートが私たちの最のの動機です。コメント価してください！"
_tab_string["supply_drop"] = "サプライボックス"
_tab_string["get"] = "受け取ります"
_tab_string["receive"] = "受け取ります"
_tab_string["haveget"] = "取得済み"
_tab_string["confirm"] = "確認"
_tab_string["your_name"] = "名前の前"
_tab_string["new_name"] = "新しい名前が前です"
_tab_string["rebirth_for_free"] = "無料復活"
_tab_string["upgrade"] = "アップレレード"
_tab_string["max_lv"] = "ハイランク"
_tab_string["not_ready"] = "まだが開いていますか？"
_tab_string["leave"] = "去る"
_tab_string["continue"] = "继续"
_tab_string["rebirth"] = "ゲームを続ける"
_tab_string["nextStage"] = "次のレベール"
_tab_string["continuegame"] = "ゲームを続ける"
_tab_string["start"] = "開始をキャプチャする"
_tab_string["exit_game"] = "终わりの冒険"
_tab_string["__TEXT_ResetLevel"] = "重玩本关"
_tab_string["premium_supply"] = "スーパー補給パッケージ"
_tab_string["game_tips1"] = "ゲームでさまざまな\nスキルカード（爆弾）を拾うことができます\n各カードを拾う回数の合計\n数に達したら,パワーレベルを上げることができます"
_tab_string["options_left"] = "学習が不可能な場合がある"
_tab_string["damage"] = "痛い"
_tab_string["second"] = "second"
_tab_string["unlock_area"] = "北を失った後,エリアのロックを解雇"
_tab_string["unlock_area2"] = "購入後,エリアのロックを脱します。"
_tab_string["ok"] = "わかった"
_tab_string["wattingPlease"] = "ネットワークに例外があります。おひとたびしください！"
_tab_string["restoredatasuccessful"] = "成功した返信"
_tab_string["keepnetworkconnected"] = "接続を続けててください"
_tab_string["restoredatatext1"] = "前のゲームデータを複製元する"
_tab_string["restoredatatext2"] = "前のゲームデータを破してしてして初して直からやり"
_tab_string["unlock_petarea"] = "ペトゾーンのロック解除"
_tab_string["achievement"] = "実績"
_tab_string["maxkill"] = "最大キル"
_tab_string["batter"] = "コンボ"
_tab_string["clearance"] = "通関"
_tab_string["pet"] = "ペット"
_tab_string["rolling"] = "ローリング"
_tab_string["onepass"] = "ワンパス"
_tab_string["pet_criteria"] = "同時に #NUM 匹のペット"
_tab_string["rolling_criteria"] = "1ラウンドで #NUM 個のモンスターを粉砕する"
_tab_string["onepass_criteria"] = "1つのライフで #NUM レベルを渡す"
_tab_string["errcode"] = "エラーコード"

_tab_string["__TEXT_get_after_upgrade"] = "升级后效果"
_tab_string["__TEXT_cur_get"] = "当前效果"
_tab_string["__TEXT_nextlv_get"] = "下一级效果"

_tab_string["__TEXT_UNLOCK_SUCCESS"] = "解锁成功！"
_tab_string["__TEXT_STARUP_SUCCESS"] = "升星成功！"
_tab_string["__TEXT_LEVELUP_SUCCESS"] = "升级成功！"
_tab_string["__TEXT_SEND_SUCCESS"] = "派遣成功！"
_tab_string["__TEXT_CANCEL_SEND_SUCCESS"] = "取消成功！"
_tab_string["__TEXT_MainInterface"] = "Main interface" 
_tab_string["__TEXT__Account"] = "Account"
_tab_string["__TEXT__Password"] = "Password"
_tab_string["__TEXT__AutoRegister"] = "AutoRegister"
_tab_string["__TEXT__Login"] = "Login"
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
_tab_string["__TEXT_TotalPurchaseMoney"] = "充值%d元"
_tab_string["__TEXT_Agree"] = "同意"
_tab_string["__TEXT_NoAgree"] = "不同意"
_tab_string["__TEXT_TASK_FINISH_ALL"] = "任务已完成"
_tab_string["__TEXT__AccountTip"] = "登录"
_tab_string["__TEXT__ItemBaseAttr"] = "[基础属性]:"
_tab_string["__TEXT__ItemSlotAttr"] = "[锻造属性]:"
_tab_string["__TEXT_TemporaryNoneMail"] = "暂无邮件"
_tab_string["__TEXT_TemporaryNoneMailContent"] = "暂无邮件正文"
_tab_string["__TEXT_TAKEALL_MAIL"] = "全部领取"
_tab_string["__TEXT_IS_TAKEREWARD_ALLMAIL"] = "是否领取全部邮件奖励？"
_tab_string["__TEXT_MAILTYYE_01"] = "游戏更新"
_tab_string["__TEXT_MAILTYYE_02"] = "活动奖励"
_tab_string["__TEXT_MAILTYYE_03"] = "游戏通知"
_tab_string["__TEXT_REWARD_TAKE_ALL"] = "已领取全部奖励"
_tab_string["__TEXT_UGCEDIT_HORIZONTAL"] = "横屏模式不支持此功能"
_tab_string["__TEXT_Confirm_delREquip"] = "你确定要分解红色装备吗？"

_tab_string["gift3_1"] = "获赠透射枪一把，具有穿透效果并且可以击退敌人"
_tab_string["gift3_2"] = "战车复活时，不再消耗水晶矿石"
_tab_string["gift3_3"] = "解锁宠物区域，可以选择长期跟随的宠物"

_tab_string["__TEXT_comment"] = "评论"

_tab_string["__TEXT_WaitTotalment"] = "等待结算"

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
_tab_string["txt_ftjp"] = "反弹镜片"
_tab_string["txt_sdj"] = "输弹机"
_tab_string["txt_cwzl"] = "宠物治疗"
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
_tab_string["__TEXT_Cancel"] = "取消"
_tab_string["__TEXT_ChatBan"] = "禁言"
_tab_string["__TEXT_IsChatDeleteMessage"] = "是否删除消息 \"%s\" ？"
_tab_string["__TEXT_IsChatBanPlayer"] = "是否禁言玩家 \"%s\" ？"
_tab_string["__TEXT_PVP_Online"] = "在线"

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

_tab_string["__TEXT_CHAT_ADVERSE"] = "更多游戏攻略请前往taptap论坛。遇到账号问题可加官方QQ群438146825进行反馈。"
_tab_string["__TEXT_CHAT_ADVERSE2"] = "请勿发送诽谤、辱骂、淫秽、广告等不良内容，违规者将依据运营政策受到处罚。请勿向他人透露支付信息和个人信息。"

_tab_string["__TEXT_Cant_ShowMessageType"] = "【收到不支持的消息类型，暂无法显示】"

-------------------------------------------------------------



-------------------------------------------------------------
--光环
_tab_stringA[1000] = {
	"",
	"+ 1",
	"+ 2",
}

_tab_stringA[1001] = {
	"",
	"+ 1",
	"+ 2",
}

_tab_stringA[1002] = {
	"",
	"+ 1",
	"+ 2",
}

_tab_stringA[1003] = {
	"",
	"+ 1",
	"+ 2",
}

_tab_stringA[1004] = {
	"",
	"+ 1",
	"+ 2",
}

_tab_stringA[1005] = {
	"",
	"+ 1",
	"+ 2",
}

_tab_stringA[1006] = {
	"",
	"+ 1",
	"+ 2",
}

_tab_stringA[1007] = {
	"",
	"+ 1",
	"+ 2",
}

_tab_stringA[1008] = {
	"",
	"+ 1",
	"+ 2",
}

_tab_stringA[1009] = {
	"",
	"+ 1",
}

_tab_stringA[1010] = {
	"",
	"+ 1",
}

_tab_stringA[1011] = {
	"",
	"生命上限 + 10%",
}

_tab_stringA[1100] = {
	"",
	"+ 1",
	"+ 2",
}
_tab_stringA[1101] = {
	"",
	"+ 1",
	"+ 2",
}
_tab_stringA[1102] = {
	"",
	"+ 1",
	"+ 2",
}
_tab_stringA[1103] = {
	"",
	"+ 1",
	"+ 2",
}
_tab_stringA[1104] = {
	"",
	"+ 1",
	"+ 2",
}
_tab_stringA[1105] = {
	"",
	"+ 1",
	"+ 2",
}
_tab_stringA[1106] = {
	"",
	"+ 1",
	"+ 2",
}
_tab_stringA[1107] = {
	"",
	"+ 1",
	"+ 2",
}
_tab_stringA[1108] = {
	"",
	"+ 1",
	"+ 2",
}
_tab_stringA[1109] = {
	"",
	"+ 1",
	"+ 2",
}
_tab_stringA[1110] = {
	"",
	"+ 1",
	"+ 2",
}
_tab_stringA[1111] = {
	"",
	"+ 1",
	"+ 2",
}
_tab_stringA[1112] = {
	"",
	"+ 1",
	"+ 2",
}

_tab_stringA[1200] = {
	"",
	"+ 1",
}
_tab_stringA[1201] = {
	"",
	"+ 1",
}
_tab_stringA[1202] = {
	"",
	"+ 1",
}
_tab_stringA[1203] = {
	"",
	"+ 1",
}

_tab_stringA[2000] = {
	"",
	"+ 500",
}
_tab_stringA[2001] = {
	"",
	"+ 1",
}


_tab_stringA[2200] = {
	"",
	"*2",
}
_tab_stringA[2201] = {
	"",
	"*2",
}
_tab_stringA[2202] = {
	"",
	"*2",
}


_tab_stringM["world/dlc_yxys_zerg"] = {"脑虫", "成群的虫族冲垮了人类脆弱的抵抗，外星统治的十三个世界中有九个已被虫族排放的废物污染。"}
_tab_stringM["world/yxys_zerg_001"] = {"脑虫Ⅰ", ""}
_tab_stringM["world/yxys_zerg_002"] = {"脑虫Ⅱ", ""}
_tab_stringM["world/yxys_zerg_003"] = {"脑虫Ⅲ", ""}
_tab_stringM["world/yxys_zerg_004"] = {"脑虫Ⅳ", ""}
_tab_stringM["world/dlc_yxys_spider"] = {"机械蜘蛛", "机械蜘蛛通过感染其他种族从而将他们感化成机械蜘蛛的一员，这些生物迅速且有选择地进化成了冷酷的杀戮机器。"}
_tab_stringM["world/yxys_spider_01"] = {"机械蜘蛛Ⅰ", "由大量机械蜘蛛把守的仓库，其中存放着危险的易燃物品。"}
_tab_stringM["world/yxys_spider_02"] = {"机械蜘蛛Ⅱ", "穿过仓库后，一道道机关门阻挡了前进的道路。"}
_tab_stringM["world/yxys_spider_03"] = {"机械蜘蛛Ⅲ", "在黑暗的洞穴里，FUNVEE小队遭到了密集的来自远方敌人的攻击。"}
_tab_stringM["world/yxys_spider_04"] = {"机械蜘蛛Ⅳ", "道路的尽头，巨型机械蜘蛛从天而降。"}
_tab_stringM["world/dlc_yxys_airship"] = {"飞机母舰", "飞船利用卫星传递信号，只要将电脑病毒植入飞船母舰，破坏系统程序，所有飞船的防御屏障就都会失灵。"}
_tab_stringM["world/yxys_airship_01"] = {"飞机母舰Ⅰ", ""}
_tab_stringM["world/yxys_airship_02"] = {"飞机母舰Ⅱ", ""}
_tab_stringM["world/yxys_airship_03"] = {"飞机母舰Ⅲ", ""}
_tab_stringM["world/yxys_airship_04"] = {"飞机母舰Ⅳ", ""}
_tab_stringM["world/dlc_bio_airship"] = {"魔眼", "经历了4个阶段的变异，他们已经变成了彻头彻尾的怪物。"}
_tab_stringM["world/yxys_bio_001"] = {"魔眼Ⅰ", ""}
_tab_stringM["world/yxys_bio_002"] = {"魔眼Ⅱ", ""}
_tab_stringM["world/yxys_bio_003"] = {"魔眼Ⅲ", ""}
_tab_stringM["world/yxys_bio_004"] = {"魔眼Ⅳ", ""}
_tab_stringM["world/dlc_yxys_plate"] = {"圆盘飞碟", "经历了4个阶段的变异，他们已经变成了彻头彻尾的怪物。"}
_tab_stringM["world/yxys_plate_01"] = {"圆盘飞碟Ⅰ", ""}
_tab_stringM["world/yxys_plate_02"] = {"圆盘飞碟Ⅱ", ""}
_tab_stringM["world/yxys_plate_03"] = {"圆盘飞碟Ⅲ", ""}
_tab_stringM["world/yxys_plate_04"] = {"圆盘飞碟Ⅳ", ""}
_tab_stringM["world/dlc_yxys_mechanics"] = {"空中堡垒", "经历了4个阶段的变异，他们已经变成了彻头彻尾的怪物。"}
_tab_stringM["world/yxys_mechanics_001"] = {"空中堡垒Ⅰ", ""}
_tab_stringM["world/yxys_mechanics_002"] = {"空中堡垒Ⅱ", ""}
_tab_stringM["world/yxys_mechanics_003"] = {"空中堡垒Ⅲ", ""}
_tab_stringM["world/yxys_mechanics_004"] = {"空中堡垒Ⅳ", ""}
--=============================================================================================--
--宝箱
_stringCHEST[1] = {
	"武器宝箱",
	"每20个武器宝箱碎片可开启一次宝箱。",
}

_stringCHEST[2] = {
	"战术宝箱",
	"每20个战术宝箱碎片可开启一次宝箱。",
}

_stringCHEST[3] = {
	"基因宝箱",
	"每20个基因宝箱碎片可开启一次宝箱。",
}

_stringCHEST[4] = {
	"装备宝箱",
	"每20个装备宝箱碎片可开启一次宝箱。",
}

_stringCHEST[5] = {
	"神器宝箱",
	"消耗50氪石可开启一次宝箱。",
}


--=============================================================================================--
--任务表
_tab_stringTask[1] = {"每日奖励", "分享给微信好友，每天一次",}
_tab_stringTask[2] = {"商城抽卡", "聚宝盆抽取一次战术卡包",}
_tab_stringTask[3] = {"商城抽宝", "聚宝盆抽取一次神器宝箱",}
_tab_stringTask[4] = {"刷新商店", "刷新一次售货机商品",}
_tab_stringTask[5] = {"百炼成钢", "洗炼装备一次",}
_tab_stringTask[6] = {"小试牛刀", "通关任意战役地图一次",}
_tab_stringTask[7] = {"无尽使命", "挑战无尽试炼达到3000分",}
_tab_stringTask[8] = {"竞技锦囊", "夺塔奇兵商城兑换任意商品一次",}
_tab_stringTask[9] = {"竞技切磋", "夺塔奇兵完成一次有效局",}
_tab_stringTask[10] = {"兵符达人", "消耗30兵符",}
_tab_stringTask[11] = {"武器宝箱", "开启武器宝箱1次",}
_tab_stringTask[12] = {"战术宝箱", "开启战术宝箱1次",}
_tab_stringTask[13] = {"宠物宝箱", "开启宠物宝箱1次",}
_tab_stringTask[14] = {"装备宝箱", "开启装备宝箱1次",}
_tab_stringTask[15] = {"击杀敌人", "累计击杀100个敌人",}
_tab_stringTask[16] = {"击杀BOSS", "累计击杀10个BOSS",}
_tab_stringTask[17] = {"使用战术卡", "使用战术卡10次",}
_tab_stringTask[18] = {"击杀BOSS", "累计击杀蜘蛛BOSS 5次",}
_tab_stringTask[19] = {"使用战术卡", "使用指定战术卡10次",}
_tab_stringTask[20] = {"矿山巨兽I", "通关",}
_tab_stringTask[21] = {"拯救科学家", "营救10个工程师",}
_tab_stringTask[22] = {"前哨阵地", "挑战前哨阵地达到10波",}
_tab_stringTask[23] = {"随机迷宫", "挑战随机迷宫达到1-4层",}

--周任务
_tab_stringTask[1001] = {"武器宝箱", "本周开启武器宝箱20次",}
_tab_stringTask[1002] = {"战术宝箱", "本周开启战术宝箱20次",}
_tab_stringTask[1003] = {"宠物宝箱", "本周开启宠物宝箱20次",}
_tab_stringTask[1004] = {"装备宝箱", "本周开启装备宝箱20次",}
_tab_stringTask[1005] = {"击杀敌人", "本周累计击杀1000个敌人",}

--=============================================================================================--







--=============================================================================================--
--成就
_tab_stringME[11] = {"星星1", "累计获得 3 颗星星",}
_tab_stringME[12] = {"星星2", "累计获得 5 颗星星",}
_tab_stringME[13] = {"星星3", "累计获得 10 颗星星",}
_tab_stringME[14] = {"星星4", "累计获得 15 颗星星",}
_tab_stringME[15] = {"星星5", "累计获得 2 颗星星",}
_tab_stringME[16] = {"星星6", "累计获得 20 颗星星",}
_tab_stringME[17] = {"星星7", "累计获得 30 颗星星",}
_tab_stringME[18] = {"星星8", "累计获得 40 颗星星",}
_tab_stringME[19] = {"星星9", "累计获得 50 颗星星",}
_tab_stringME[20] = {"星星10", "累计获得 75 颗星星",}
_tab_stringME[21] = {"星星11", "累计获得 100 颗星星",}
_tab_stringME[22] = {"星星12", "累计获得 150 颗星星",}
--=============================================================================================--




--=============================================================================================--
--战术卡
_tab_stringT[1201] = {"敌人生命加强",
	"敌人生命值+20％。",
	"敌人生命值+40％。",
	"敌人生命值+60％。",
	"敌人生命值+80％。",
	"敌人生命值+100％。",
}

_tab_stringT[1202] = {"敌人攻击加强",
	"敌人攻击力+20％。",
	"敌人攻击力+40％。",
	"敌人攻击力+60％。",
	"敌人攻击力+80％。",
	"敌人攻击力+100％。",
}
--=============================================================================================--



--==================================================== ===============================================-
--[[
---未定義テキストのテスト
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
	
}

ProtocolAgreement_String = {
	
}