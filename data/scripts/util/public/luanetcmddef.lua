-----------------------
--服务器脚本系统
-----------------------
--和服务器一致
hVar.DB_OPR_TYPE = {
	--C2L_REQUIRE			= 3002,
	C2L_REQUIRE			= 66666,			--安卓，协议号改了
	
	C2L_REQUIRE_SYSTIME		= 1,				--获取服务器时间
	C2L_GET_MAIL_ANNEX		= 2,				--获取邮箱附件
	C2L_GET_VER_INFO		= 3,				--获取版本信息
	C2L_GET_MAIL_ANNEX_DRAWCARD	= 5,				--获取邮箱服务器抽卡附件
	C2L_GET_ENDLESS_RANK_NAME	= 6,				--获取无尽地图的前10名玩家名
	C2L_GET_ENDLESS_REWARD		= 7,				--获取无尽地图排行榜奖励
	C2L_GETPVEMULTY_REWARD		= 8,				--获取魔龙宝库每日勤劳奖奖励
	C2L_GETTITIEMSG_REWARD		= 9,				--获取标题正文类邮件的奖励
	
	C2L_REQUIRE_HOTFIX		= 11,
	--任务相关
	C2L_REQUIRE_QUEST		= 12,				--请求任务
	C2L_UPDATE_QUEST		= 13,				--更新任务状态
	C2L_CONFIRM_QUEST		= 14,				--领取任务奖励
	
	--领奖日志
	C2L_UPDATE_REWARD_LOG		= 15,				--更新领奖状态日志
	
	--排行榜相关功能
	C2L_REQUIRE_BOARD_TEMPLATE	= 16,				--获取排行榜模板
	C2L_REQUIRE_BILLBOARD		= 17,				--获取排行榜信息
	C2L_UPDATE_BILLBOARD_RANK	= 18,				--更新玩家排行榜信息
	
	--修改姓名
	C2L_REQUIRE_CHANGE_NAME		= 19,				--修改角色姓名
	
	--更新地图首次通关记录
	C2L_UPLOAD_MAP_RECORD		= 20,				--地图首次通关记录

	--商城
	C2L_REQUIRE_OPEN_SHOP		= 21,				--打开商城
	C2L_REQUIRE_REFRESH_SHOP	= 22,				--刷新商城(使用rmb刷新)
	C2L_REQUIRE_BUYITEM		= 23,				--购买商品
	C2L_REQUIRE_MYCOIN		= 24,				--获取玩家各种货币
	
	C2L_REQUIRE_MERGE_REDEQUIP	= 25,				--红装合成
	C2L_REQUIRE_XILIAN_REDEQUIP	= 26,				--红装洗练
	C2L_REQUIRE_SYNC_REDEQUIP	= 27,				--红装同步
	
	C2L_REQUIRE_VIP_INFO		= 28,				--获取vip信息
	C2L_REQUIRE_VIP_DAILY_REWARD	= 29,				--获取vip每日奖励1
	
	C2L_REQUIRE_QUEST_TEST		= 30,
	
	C2L_REQUIRE_GET_ALLREDEQUIP	= 31,				--获取所有红装信息
	C2L_REQUIRE_REDSCROLL_EXCHANGE	= 32,				--红装卷轴兑换红装
	
	--安卓
	C2L_ANDROID_SAVE_LOG = 33,							--安卓，同步存档日志
	
	--主公起名
	C2L_REQUIRE_SET_NAME		= 34,				--主公起名
	
	--无尽地图开始战斗
	C2L_REQUIRE_ENDLESS_BEGIN_GAME = 35,			--无尽地图开始战斗
	
	C2L_REQUIRE_MERGE_ORANGEEQUIP	= 36,				--橙装合成
	C2L_REQUIRE_MERGE_ORANGEEQUIP_RESULT	= 37,		--橙装合成结果
	C2L_REQUIRE_DESCOMPOS_REDEQUIP = 38,			--分解红装
	C2L_REQUIRE_BATTLE_NORMAL	= 39,			--请求挑战普通剧情地图
	C2L_REQUIRE_BATTLE_ENTERTAMENT	= 40,			--请求挑战娱乐地图
	C2L_REQUIRE_RESUME_ENTERTAMENT	= 41,			--请求继续娱乐地图（随机迷宫）
	
	--安卓
	C2L_ANDROID_SAVE_LOG = 33,							--安卓，同步存档日志
	C2L_REQUIRE_MONTH_CARD				= 151,			--查询月卡和月卡每日领奖
	C2L_UPDATE_TANK_SCORE	= 159,						--更新战车得分
	C2L_REQUIRE_TANK_BILLBOARD	= 160,					--获取战车排行榜
	C2L_MODIFY_TANK_USERNAME	= 161,					--修改战车玩家名
	C2L_UPLOAD_TANK_STAGELOG	= 162,					--上传战车关卡日志
	C2L_UPLOAD_TANK_SCOREINFO	= 163,					--上传战车积分信息
	
	C2L_QUERY_TANK_YESTERDAY_RANK	= 164,				--查询战车昨日排名
	C2L_REWARD_TANK_YESTERDAY_RANK	= 165,				--领取战车昨日排名奖励
	
	C2L_REQUIRE_TRESTURE_INFO		= 166,				--查询玩家宝物和宝物属性位信息
	C2L_UPDATE_TRESTURE_STARUP		= 167,				--玩家请求宝物升星
	C2L_UPLOAD_TRESTURE_ATTR_INFO		= 168,				--上传玩家宝物属性位值信息
	C2L_REQUIRE_TANK_OPEN_CHEST		= 169,				--战车请求开宝箱
	C2L_REQUIRE_ERROR_LOG			= 170,				--上传客户端错误日志
	C2L_QUERY_TANK_WEAPON_INFO		= 171,				--查询战车武器枪同步信息
	C2L_REQUIRE_TANK_WEAPON_STARUP		= 172,				--请求战车武器枪升星
	--C2L_REQUIRE_TANK_WEAPON_ADDEXP		= 173,				--请求战车武器枪加经验值
	C2L_QUERY_TANK_TALENTPOINT_INFO		= 174,				--查询战车技能点数同步信息
	C2L_REQUIRE_TANK_TALENTPOINT_ADDEXP	= 175,				--请求战车加经验值
	C2L_REQUIRE_TANK_TALENTPOINT_ADDPOINT	= 176,				--请求战车天赋点分配
	C2L_QUERY_TANK_PET_INFO			= 177,				--查询战车宠物同步信息
	C2L_REQUIRE_TANK_PET_STARUP		= 178,				--请求战车宠物升星
	--C2L_REQUIRE_TANK_PET_ADDEXP		= 179,				--请求战车宠物加经验值
	C2L_REQUIRE_TANK_TALENTPOINT_RESTORE	= 180,				--请求战车天赋点重置
	C2L_REQUIRE_TANK_WEAPON_LEVELUP		= 181,				--请求战车武器枪升级
	C2L_REQUIRE_TANK_PET_LEVELUP		= 182,				--请求战车宠物升级
	C2L_QUERY_TANK_TACTIC_INFO		= 183,				--查询战术卡同步信息
	C2L_REQUIRE_TANK_TACTIC_LEVELUP		= 184,				--请求战术卡升级
	C2L_REQUIRE_TANK_CLEARDATA		= 185,				--请求清除数据
	C2L_REQUIRE_TANK_PET_WAKUANG		= 186,				--请求派遣宠物挖矿
	C2L_REQUIRE_TANK_PET_WATILI		= 187,				--请求派遣宠物挖体力
	C2L_REQUIRE_TANK_PET_CANCEL_WAKUANG	= 188,				--请求派遣宠物取消挖矿
	C2L_REQUIRE_TANK_PET_CANCEL_WATILI	= 189,				--请求派遣宠物取消挖体力
	C2L_REQUIRE_TANK_TILI_EXCHANGE		= 190,				--请求兑换体力
	C2L_REQUIRE_TANK_ADDONES_KESHI		= 191,				--请求领取挖矿氪石
	C2L_REQUIRE_TANK_ADDONES_TILI		= 192,				--请求领取挖矿体力
	C2L_REQUIRE_TANK_TILI_INFO		= 193,				--请求查询体力产量信息
	C2L_QUERY_TANK_MAP_INFO			= 194,				--查询战车地图同步信息
	C2L_REQUIRE_TANK_REBIRTH		= 195,				--请求游戏中战车复活
	C2L_REQUIRE_ACHIEVEMENT_QUERY		= 196,				--请求查询成就完成情况
	C2L_REQUIRE_ACHIEVEMENT_TAKEREWARD	= 197,				--请求领取成就奖励
	C2L_REQUIRE_RANDOMMAP_BOLLBOARD		= 198,				--请求查询随机迷宫排行榜
	C2L_ORDER_UPDATE			= 199,				--订单状态更新（新）
	C2L_REQUIRE_RENZUWUDI_REDRAWCARD	= 200,				--人族无敌重抽卡片
	C2L_REQUIRE_VIP_DAILY_REWARD2		= 201,				--获取vip每日奖励2
	C2L_REQUIRE_VIP_DAILY_REWARD3		= 202,				--获取vip每日奖励3
	C2L_REQUIRE_TANK_ADDONES_CHEST		= 203,				--请求领取挖矿宝箱
	C2L_GET_MAIL_ANNEX_OPENCHEST		= 204,				--获取直接开锦囊邮箱附件
	C2L_REQUIRE_CHATDRAGON_REWARD		= 205,				--请求获取聊天龙王奖奖励
	C2L_REQUIRE_USER_CHAMPION_INFO		= 206,				--请求查询玩家的当前称号
	C2L_REQUIRE_GIFT_EQUIP_INFO		= 207,				--玩家请求查询的特惠装备信息
	C2L_REQUIRE_GIFT_EQUIP_BUYITEM		= 208,				--玩家请求购买特惠装备
	C2L_REQUIRE_SHARE_REWARD		= 209,				--玩家请求领取分享奖励
	
	
	C2L_REQUIRE_TASK_TYPE_FINISH			= 213,			--请求增加任务（新）进度
	C2L_REQUIRE_TASK_QUERY_STATE			= 214,			--请求查询任务（新）进度
	C2L_REQUIRE_TASK_TAKEREWARD			= 215,			--请求领取完成任务（新）的奖励
	C2L_REQUIRE_TASK_TAKEREWARD_ALL			= 216,			--请求一键领取全部已达成任务（新）的奖励
	C2L_REQUIRE_ACTIVITY_TODAY_STATE		= 217,			--请求查询新玩家14日签到活动今日是否可领取奖励
	C2L_REQUIRE_ACTIVITY_TODAY_SIGNIN		= 218,			--新玩家14日签到活动今日签到
	C2L_REQUIRE_ACTIVITY_SIGNIN_BUYGIFT		= 219,			--新玩家14日签到活动购买特惠礼包
	C2L_REQUIRE_SYSTEM_MAIL_LIST			= 220,			--获取系统邮件列表（新）
	C2L_REQUIRE_SYSTEM_MAIL_REWAR_ALL		= 221,			--请求一键领取全部邮件
	C2L_REQUIRE_GM_ADDDEBRIS			= 222,			--请求添加碎片（仅管理员可用）
	C2L_REQUIRE_SEND_GAMEEND_INFO			= 223,			--请求上传战斗结果
	--GM指令
	C2L_REQUIRE_GM_ADD_RESOURCE			= 224,			--GM指令-加资源
	C2L_REQUIRE_GM_MAP_FINISH			= 225,			--GM指令-地图全通
	C2L_REQUIRE_GM_ADD_HEROEXP_ALL			= 226,			--GM指令-加全部英雄经验
	C2L_REQUIRE_GUIDE_ADD_REDEQUOP			= 227,			--新手引导图-添加红装
	C2L_REQUIRE_TASK_WEEK_REWARD			= 228,			--请求领取周任务（新）进度奖励
	C2L_REQUIRE_COMMENT_TAKEREWAED			= 229,			--请求领取评价奖励（新）
	C2L_REQUIRE_DEBUG				= 230,			--GM请求发送调试指令
	
	--评论与弹幕
	C2L_REQUIRE_COMMENT_BARRAGE_BEGIN		= 280,
	C2L_REQUIRE_COMMENT_ADD					= 281,		--添加评论
	C2L_REQUIRE_COMMENT_EDIT				= 282,		--修改评论
	C2L_REQUIRE_COMMENT_DEL					= 283,		--删除评论
	C2L_REQUIRE_COMMENT_LOOK				= 284,		--查看评论
	C2L_REQUIRE_COMMENT_LIKES				= 285,		--评论点赞
	C2L_REQUIRE_COMMENT_CANNEL_LIKES		= 286,		--取消点赞
	C2L_REQUIRE_COMMENT_LIKES_COUNT			= 287,		--查看赞的数量
	C2L_REQUIRE_COMMENT_USER_LIKES			= 288,		--玩家是否对评论点赞
	C2L_REQUIRE_COMMENT_QUERY_TITLE			= 289,		--查询评论标题

	C2L_REQUIRE_COMMENT_BARRAGE_LOOK		= 290,		--查看弹幕

	C2L_REQUIRE_COMMENT_EDIT_TITLE			= 296,		--修改评论标题

	C2L_REQUIRE_COMMENT_BARRAGE_END			= 300,

	C2L_REQUIRE_PLAYGOPHER				= 310,		--请求玩打地鼠
	C2L_REQUIRE_GAMEGOPHER_REWARD			= 311,		--领取地鼠游戏奖励

	C2L_REQUIRE_SYNC_CHAT_MSG_ID			= 312,		--聊天消息id同步
	C2L_REQUIRE_BUBBLE_NOTICE			= 313,			--请求走马灯冒字		--add by mj 2022.11.21，临时注掉
}

hVar.DB_RECV_TYPE = {
	--L2C_RECV			= 3003,
	L2C_RECV			= 66666, --安卓改协议号了

	L2C_SYSTIME			= 1,				--获取服务器时间
	L2C_QUEST_MAIL_ANNEX		= 2,				--获取邮箱附件
	L2C_QUEST_VER_INFO		= 3,				--获取版本信息
	L2C_NOTICE_PLAYER_LOGIN = 4,					--安卓玩家登入
	L2C_QUEST_MAIL_ANNEX_DRAWCARD	= 5,				--获取服务器抽卡邮箱附件
	L2C_QUEST_MAIL_ANNEX_ENDLESS	= 6,				--获取无尽地图排行奖励邮箱附件
	L2C_QUEST_MAIL_ANNEX_PVEMULTY	= 7,				--获取无魔龙宝库每日勤劳奖邮箱附件
	L2C_QUEST_MAIL_ANNEX_TITIEMSG	= 8,				--获取标题正文的奖邮箱附件
	L2C_QUEST_MAIL_ANNEX_OPENCHEST	= 9,				--获得服务器直接开锦囊邮箱附件

	--任务相关
	L2C_QUEST			= 11,				--任务返回
	L2C_QUEST_REWARD		= 12,

	--排行榜相关功能
	L2C_BOARD_TEMPLATE		= 13,				--返回排行榜模板
	L2C_BILLBOARD_INFO		= 14,				--返回排行榜信息

	--修改姓名是否成功
	L2C_REQUEST_CHANGE_NAME		= 15,				--修改姓名返回

	--商城
	L2C_REQUEST_SHOP_INFO		= 16,				--返回商店信息
	L2C_REQUEST_BUYITEM		= 17,				--返回购买到的商品信息
	L2C_REQUEST_REFRESH_SHOP	= 18,				--返回刷新商店结果
	L2C_REQUEST_MYCOIN		= 19,				--返回玩家各种货币
	
	L2C_REQUEST_MERGE_REDEQUIP	= 20,				--红装合成结果返回
	L2C_REQUEST_XILIAN_REDEQUIP	= 21,				--红装洗练结果返回
	L2C_REQUEST_SYNC_REDEQUIP	= 22,				--红装同步结果返回
	
	L2C_REQUEST_VIP_INFO		= 23,				--返回获取的vip信息
	L2C_REQUEST_VIP_DAILY_REWARD	= 24,				--返回vip每日奖励

	L2C_REQUEST_GET_ALLREDEQUIP	= 25,				--返回红装卷轴可兑换的所有红装信息
	L2C_REQUEST_REDSCROLL_EXCHANGE	= 26,				--返回红装卷轴兑换是否成功
	
	--安卓，同步日志存档，返回
	L2C_REQUEST_ANDROID_SAVE_LOG	= 27,				--返回安卓，同步日志存档
	L2C_REQUEST_ANDROID_NOTICE_MSG	= 28,				--返回安卓，弹框消息
	
	--主公起名是否成功
	L2C_REQUEST_SET_NAME		= 29,				--主公起名返回
	
	--无尽地图开始战斗返回
	L2C_BOARD_ENDLESS_BEGIN_GAME	= 30,			--无尽地图开始战斗返回
	
	--无尽地图排行榜查询前10玩家名返回
	L2C_BOARD_ENDLESS_RANK_NAME		= 31,			--无尽地图排行榜查询前10玩家名返回
	
	L2C_REQUEST_MERGE_ORANGEEQUIP	= 32,				--橙装合成结果返回
	L2C_REQUEST_DESCOMPOS_REDEQUIP	= 33,				--返回分解红装的结果
	L2C_REQUIRE_BATTLE_NORMAL_RET = 34,				--返回挑战普通剧情地图的结果返回
	L2C_REQUIRE_BATTLE_ENTETAMENT_RET = 35,				--返回挑战娱乐剧情地图的结果返回
	L2C_REQUIRE_RESUME_ENTETAMENT_RET = 36,				--返回继续娱乐剧情地图的结果返回（随机迷宫）
	
	--系统
	L2C_NOTICE_ERROR		= 98,				--错误事件1
	L2C_NOTICE_MONTH_CARD = 143,					--通知服务器月卡和月卡今日发奖结果
	L2C_NOTICE_TANK_BILLBOARD = 151,				--通知战车排行榜返回
	L2C_NOTICE_TANK_MODIFYNAME	= 152,				--通知战车改名结果返回
	L2C_NOTICE_TANK_UPLOAD_STAGELOG	= 153,			--通知上传战车关卡日志返回
	
	L2C_NOTICE_TANK_YESTERDAY_RANK	= 154,			--通知获取昨日排行榜排名
	L2C_RECEIVE_TANK_YESTERDAY_RANK	= 155,			--通知领取战车昨日排名奖励
	L2C_REQUIRE_TREASURE_INFO	= 156,				--通知玩家查询宝物和宝物属性位值信息返回结果
	L2C_UPDATE_TREASURE_STARUP	= 157,				--通知玩家宝物升星返回结果
	L2C_UPLOAD_TREASURE_ATTR_INFO	= 158,				--通知玩家上传宝物属性位值信息返回结果
	L2C_REQUIRE_TANK_OPEN_CHEST	= 159,				--通知玩家战车请求开宝箱返回结果
	L2C_REQUIRE_TANK_WEAPON_INFO_RET	= 160,			--通知玩家武器枪信息返回结果
	L2C_REQUIRE_TANK_WEAPON_STARUP_RET	= 161,			--通知玩家武器枪升星返回结果
	--L2C_REQUIRE_TANK_WEAPON_ADDEXP_RET	= 162,			--通知玩家武器枪加经验值返回结果
	L2C_REQUIRE_TANK_TALENTPOINT_INFO_RET	= 163,			--通知玩家战车技能点数信息返回结果
	L2C_REQUIRE_TANK_TALENTPOINT_ADDEXP_RET		= 164,		--通知玩家战车加经验值返回结果
	L2C_REQUIRE_TANK_TALENTPOINT_ADDPOINT_RET	= 165,		--通知玩家战车分配点数返回结果
	L2C_REQUIRE_TANK_PET_INFO_RET	= 166,				--通知玩家宠物信息返回结果
	L2C_REQUIRE_TANK_PET_STARUP_RET	= 167,				--通知玩家宠物升星返回结果
	--L2C_REQUIRE_TANK_PET_ADDEXP_RET	= 168,			--通知玩家武器枪加经验值返回结果
	L2C_REQUIRE_TANK_TALENTPOINT_RESTORE_RET	= 169,		--请求战车天赋点重置返回结果
	L2C_REQUIRE_TANK_WEAPON_LEVELUP_RET	= 170,			--通知玩家武器枪升级返回结果
	L2C_REQUIRE_TANK_PET_LEVELUP_RET	= 171,			--通知玩家宠物升级返回结果
	L2C_REQUIRE_TANK_TACTIC_INFO_RET	= 172,			--通知玩家战术卡信息返回结果
	L2C_REQUIRE_TANK_TACTIC_LEVELUP_RET	= 173,			--通知玩家战术卡升级返回结果
	L2C_REQUIRE_TANK_CLEARDATA_RET		= 174,			--通知玩家清除数据结果返回
	L2C_REQUIRE_TANK_PET_WAKUANG_RET	= 186,			--通知派遣宠物挖矿结果返回
	L2C_REQUIRE_TANK_PET_WATILI_RET		= 187,			--通知派遣宠物挖体力结果返回
	L2C_REQUIRE_TANK_PET_CANCEL_WAKUANG_RET	= 188,			--通知派遣宠物取消挖矿结果返回
	L2C_REQUIRE_TANK_PET_CANCEL_WATILI_RET	= 189,			--通知派遣宠物取消挖体力结果返回
	L2C_REQUIRE_TANK_TILI_EXCHANGE_RET	= 190,			--通知兑换体力结果返回
	L2C_REQUIRE_TANK_ADDONES_KESHI_RET	= 191,			--通知领取挖矿氪石结果返回
	L2C_REQUIRE_TANK_ADDONES_TILI_RET	= 192,			--通知领取挖矿体力结果返回
	L2C_REQUIRE_TANK_TILI_INFO_RET		= 193,			--通知玩家体力产量信息结果返回
	L2C_REQUIRE_TANK_MAP_INFO_RET		= 194,			--通知玩家地图信息返回结果
	L2C_REQUIRE_TANK_MAP_FINISH_REWARD_RET	= 195,			--通知玩家地图通关奖励返回结果
	L2C_REQUIRE_TANK_REBIRTH_RET		= 196,			--通知玩家游戏内战车复活返回结果
	L2C_NOTICE_ACHIEVEMENT_QUERY_RET	= 197,			--通知玩家查询成就完成情况的结果返回
	L2C_NOTICE_ACHIEVEMENT_TAKEREWARD_RET	= 198,			--通知玩家领取成就奖励的结果返回
	L2C_REQUEST_QUNYINGGE_REDRAWCARD	= 199,			--通知新无尽群英阁重抽卡片结果返回
	L2C_REQUIRE_TANK_ADDONES_CHEST_RET	= 200,			--通知领取挖矿宝箱结果返回
	L2C_NOTICE_MAIL_ANNEX_CHATDRAGON_RET	= 201,			--通知领取聊天龙王奖邮箱附件的结果返回
	L2C_NOTICE_USER_CHAMPION_INFO_RET	= 202,			--通知玩家的当前称号结果返回
	
	L2C_NOTICE_TASK_QUERY_RET			= 205,		--通知玩家任务（新）的进度返回
	L2C_NOTICE_TASK_TAKEREWARD_RET			= 206,		--通知玩家任务（新）完成任务领奖返回
	L2C_NOTICE_TASK_TAKEREWARD_ALL_RET		= 207,		--通知玩家一键领取全部已达成任务（新）的奖励结果返回
	L2C_NOTICE_ACTIVITY_TODAY_STATE			= 208,		--通知新玩家14日签到活动今日是否可领取奖励
	L2C_NOTICE_ACTIVITY_TODAY_SIGNIN		= 209,		--通知新玩家14日签到活动今日签到结果
	L2C_NOTICE_ACTIVITY_SIGNIN_BUYGIFT		= 210,		--通知新玩家14日签到活动购买特惠礼包结果
	L2C_REQUIRE_SYSTEM_MAIL_LIST_RET		= 211,		--通知玩家系统邮件列表（新）
	L2C_REQUIRE_SYSTEM_MAIL_REWARD_ALL_RET		= 212,		--通知玩家一键领取全部邮件结果返回
	L2C_REQUIRE_GM_ADDDEBRIS_RET			= 213,		--通知玩家添加碎片操作结果返回（仅管理员可操作）
	L2C_REQUIRE_SEND_GAMEEND_INFO_RET		= 214,		--通知上传战斗结果返回
	--GM指令
	L2C_REQUIRE_GM_ADD_RESOURCE_RET			= 215,		--通知GM指令-加资源返回结果
	L2C_REQUIRE_GM_MAP_FINISH_RET			= 216,		--通知GM指令-地图全通返回结果
	L2C_REQUIRE_GM_ADD_HEROEXP_ALL			= 217,		--通知GM指令-加全部英雄经验返回结果
	L2C_REQUIRE_GUIDE_ADD_REDEQUOP_RET		= 218,		--通知新手图奖励红装返回结果
	L2C_NOTICE_TASK_WEEK_REWARD_RET			= 219,		--通知领取周任务（新）进度奖励返回结果
	L2C_NOTICE_COMMENT_REWARD_RET			= 220,		--通知领取推荐奖励（新）返回结果
	L2C_NOTICE_GIFT_EQUIP_INFO_RET			= 221,		--通知查询的特惠装备信息返回结果
	L2C_NOTICE_GIFT_EQUIP_BUYITEM_RET		= 222,		--通知购买特惠装备返回结果
	L2C_NOTICE_SHARE_REWARD_RET			= 223,		--通知领取分享奖励返回结果
	
	--评论与弹幕
	L2C_REQUIRE_COMMENT_BARRAGE_BEGIN		= 280,
	L2C_REQUIRE_COMMENT_ADD_RET				= 281,		--添加评论
	L2C_REQUIRE_COMMENT_EDIT_RET			= 282,		--修改评论
	L2C_REQUIRE_COMMENT_DEL_RET				= 283,		--删除评论
	L2C_REQUIRE_COMMENT_LOOK_RET			= 284,		--查看评论
	L2C_REQUIRE_COMMENT_LIKES_RET			= 285,		--评论点赞
	L2C_REQUIRE_COMMENT_CANNEL_LIKES_RET	= 286,		--取消点赞
	L2C_REQUIRE_COMMENT_LIKES_COUNT_RET		= 287,		--查看赞的数量
	L2C_REQUIRE_COMMENT_USER_LIKES_RET		= 288,		--玩家是否对评论点赞
	L2C_REQUIRE_COMMENT_QUERY_TITLE			= 289,		--查询评论标题

	L2C_REQUIRE_COMMENT_BARRAGE_LOOK_RET	= 290,		--查看弹幕


	L2C_REQUIRE_COMMENT_EDIT_TITLE			= 296,		--修改评论标题

	L2C_REQUIRE_COMMENT_BARRAGE_END			= 300,

	
	L2C_REQUIRE_PLAYGOPHER_RESULT			= 310,		--返回玩打地鼠的结果
	L2C_REQUIRE_GAMEGOPHER_REWARD			= 311,		--返回地鼠奖励

	L2C_REQUIRE_SYNC_CHAT_MSG_ID			= 312,		--聊天消息id同步
	L2C_REQUIRE_BUBBLE_NOTICE_RET			= 313,		--通知走马灯冒字结果返回 --add by mj 2022.11.21，临时注掉
}

hVar.DBNETERR = 
{
	UNKNOW_ERROR = 0,				--未知错误
	UPDATE_BILLBOARD_RANK_FAILED = 1,		--更新排行榜数据失败

}

