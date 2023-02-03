-------------------------------------------------
--服务器特有
---------------------------------------------------
--和客户端一致
--网络协议define
--服务器接收协议号
hVar.GROUP_OPR_TYPE = {
	
	--1~99,系统消息
	C2L_REQUIRE_HEART		= 1,					--心跳包
	C2L_REQUIRE_DEBUG		= 2,					--GM_Debug
	
	--GROUP系统
	C2L_REQUIRE_CHAT_INIT	= 100,					--请求初始化玩家聊天
	C2L_REQUIRE_CHAT_ID_LIST	= 101,				--获取聊天消息id列表
	C2L_REQUIRE_CHAT_CONTENT_LIST	= 102,			--获取指定聊天消息id列表的内容
	C2L_REQUIRE_CHAT_SEND_MESSAGE	= 103,			--请求发送一条聊天消息
	C2L_REQUIRE_CHAT_UPDATE_MESSAGE	= 104,			--请求更新一条聊天消息
	C2L_REQUIRE_CHAT_REMOVE_MESSGAE	= 105,			--请求删除一条聊天消息
	C2L_REQUIRE_CHAT_FORBIDDEN_USER	= 106,			--请求禁言玩家聊天
	C2L_REQUIRE_CHAT_PRIVATE_INVITE	= 107,			--请求和对方玩家私聊
	C2L_REQUIRE_CHAT_PRIVATE_INVITE_OP	= 108,		--私聊验证消息操作
	C2L_REQUIRE_CHAT_PRIVATE_DELETE	= 109,			--请求删除私聊好友
	C2L_REQUIRE_CHAT_SEND_GROUP_SYSTEM_MESSAGE	= 110,--请求发送一条军团系统聊天消息
	C2L_REQUIRE_EXCHAGE_TACTIC_DEBRIS	= 111,		--请求兑换战术卡碎片
	C2L_REQUIRE_EXCHAGE_HERO_DEBRIS	= 112,			--请求兑换英雄将魂
	C2L_REQUIRE_EXCHAGE_GROUPCOIN_CHEST	= 113,		--请求兑换军团币宝箱
	C2L_REQUIRE_HERO_DEBRIS_INFO	= 114,			--请求查询英雄将魂信息
	C2L_REQUIRE_BUY_BATTLE_COUNT	= 115,			--请求购买军团副本次数
	C2L_REQUIRE_SEND_GROUP_REDPACKET	= 116,		--请求发送军团红包
	C2L_REQUIRE_RECEIVE_GROUP_REDPACKET	=117,		--请求领取军团红包
	C2L_REQUIRE_CHAT_SEND_WORLD_BATTLE_SYSTEM_MESSAGE	= 118,--请求发送一条世界关卡通关系统聊天消息
	C2L_REQUIRE_GROUP_MILITARY_TASK_INFO	= 119,		--请求查询军团军饷任务完成情况
	C2L_REQUIRE_GROUP_MILITARY_TASK_TAKEREWARD	= 120,	--请求领取军团军饷任务
	C2L_REQUIRE_RECEIVE_PAY_REDPACKET	=121,		--请求领取支付（土豪）红包
	C2L_REQUIRE_VIEWDETAIL_PAY_REDPACKET	=122,		--请求查看支付（土豪）红包的领取详情
	C2L_REQUIRE_GROUP_KICK_OFFLINE_PLAYER	= 123,		--请求踢出长期不在线的其他军团的玩家（仅管理员可操作）
	C2L_REQUIRE_GROUP_ASSET_ADMIN_PLAYER	= 124,		--请求任命玩家为会长（仅管理员可操作）
	C2L_REQUIRE_GROUP_TRANSFER		= 125,		--请求转让军团
	C2L_REQUIRE_GROUP_DISOLUTE		= 126,		--请求解散军团（仅管理员可操作）
	C2L_REQUIRE_GROUP_INVITE_CREATE		= 127,		--请求创建军团邀请函
	C2L_REQUIRE_GROUP_INVITE_JOIN		= 128,		--请求加入军团邀请函
	C2L_REQUIRE_CHAT_ID_LIST_GROUP_GM	= 129,		--获取指定军团的聊天消息id列表（仅管理员可操作）
	C2L_REQUIRE_CHAT_CONTENT_LIST_GROUP_GM	= 130,		--获取指定军团的聊天消息id列表的内容（仅管理员可操作）
	C2L_REQUIRE_CHAT_REMOVE_MESSGAE_BATTLE	= 131,		--请求删除一条组队副本邀请聊天消息
	C2L_REQUIRE_CHAT_SEND_MESSAGE_BATTLE	= 132,		--请求发送一条组队副本邀请聊天消息
	
	
	
	
	--新手营
	C2L_NOVICECAMP_LIST		= 1001,				--请求新手营列表
	C2L_NOVICECAMP_CREATE		= 1002,				--创建新手营
	C2L_NOVICECAMP_REMOVE		= 1003,				--解散新手营
	C2L_MEMBER_LIST			= 1004,				--查看成员列表
	C2L_POWER_JION_ACCEPT		= 1005,				--营长通过新手申请
	C2L_POWER_JION_REJECT		= 1006,				--营长驳回新手申请
	C2L_POWER_JION_REQUEST		= 1007,				--新手申请加营
	C2L_POWER_JION_CANCEL		= 1008,				--新手取消申请
	C2L_NOVICECAMP_UPDATE		= 1009,				--更新新手营信息
	C2L_POWER_FIRE			= 1010,				--踢人
	C2L_CONFIG_PRIZE		= 1011,				--请求奖励信息
	C2L_NOVICECAMP_RENAME		= 1012,				--修改新手营名字
	C2L_BUILDING_UPGRADE		= 1013,				--升级建筑
	C2L_BUILDING_PRIZE		= 1014,				--获取建筑奖励
	C2L_POWER_QUIT			= 1015,				--退出
	C2L_CARD_UPGRADE		= 1016,				--战术卡升级
	C2L_POWER_ASSISTANT_APPOINT	= 1017,				--会长任命助理
	C2L_POWER_ASSISTANT_DISAPPOINT	= 1018,				--会长取消任命助理
	C2L_NOVICECAMP_LIST_JOIN	= 1019,				--请求申请加入军团列表
	C2L_REQUIRE_GROUP_SEARCH	= 1020,				--请求查找军团
}

--服务器返回协议号
hVar.GROUP_RECV_TYPE = {
	--1~99,系统消息
	L2C_NOTICE_USER_LOGIN		= 1,				--玩家登陆1
	L2C_NOTICE_PING			= 2,					--ping协议
	L2C_NOTICE_ERROR		= 98,					--错误事件1
	
	--GROUP系统
	L2C_NOTICE_CHAT_ORPEATION_RESULT	= 100,		--返回操作结果通知
	L2C_NOTICE_CHAT_INIT		= 101,				--返回初始化玩家聊天结果
	L2C_NOTICE_CHAT_ID_LIST		= 102,				--返回聊天消息id列表
	L2C_NOTICE_CHAT_CONTENT_LIST		= 103,		--返回指定聊天消息id列表的内容
	L2C_NOTICE_CHAT_SINGLE_MESSAGE	= 104,			--返回单条聊天消息
	L2C_NOTICE_CHAT_UPDATE_MESSAGE	= 105,			--返回更新单条聊天消息
	L2C_NOTICE_CHAT_REMOVE_MESSAGE	= 106,			--返回删除聊天消息
	L2C_NOTICE_CHAT_USER_FORBIDDEN	= 107,			--返回玩家被禁言的结果
	L2C_NOTICE_CHAT_PRIVATE_INVITE	= 108,			--返回请求和对方玩家私聊的结果
	L2C_NOTICE_CHAT_SINGLE_PRIVATE_USER	= 109,		--返回收到增加单个私聊好友
	L2C_NOTICE_CHAT_REMOVE_PRIVATE_USER	= 110,		--返回收到移除单个私聊好友
	L2C_NOTICE_EXCHAGE_TACTIC_DEBRIS	= 111,		--返回兑换战术卡碎片结果
	L2C_NOTICE_EXCHAGE_HERO_DEBRIS	= 112,			--返回兑换英雄将魂结果
	L2C_NOTICE_EXCHAGE_GROUPCOIN_CHEST	= 113,		--返回兑换军团币宝箱结果
	L2C_NOTICE_QUERY_HERO_DEBRIS_INFO	= 114,		--返回查询英雄将魂信息结果
	L2C_NOTICE_GROUP_RESOURCE_INFO	= 115,			--返回军团资源变化结果
	L2C_NOTICE_GROUP_BUY_BATTLE_COUNT	= 116,		--返回军团会长购买副本次数结果
	L2C_NOTICE_GROUP_SEND_REDPACKET	= 117,			--返回发送军团红包结果
	L2C_NOTICE_GROUP_RECEIVE_REDPACKET	= 118,		--返回领取军团红包结果
	L2C_NOTICE_GROUP_MILITARY_TASK_QUERY	= 119,		--返回查询军团军饷任务完成结果
	L2C_NOTICE_GROUP_MILITARY_TASK_TAKEREWARD	= 120,	--返回领取军团军饷任务结果
	L2C_NOTICE_PAY_RECEIVE_REDPACKET	= 121,		--返回领取支付（土豪）红包结果
	L2C_NOTICE_PAY_VIEWDETAIL_REDPACKET	= 122,		--返回查看支付（土豪）红包的领取详情结果
	L2C_NOTICE_GROUP_KICK_OFFLINE_PLAYER	= 123,		--返回踢出长期不在线的其他军团的玩家结果（仅管理员可操作）
	L2C_NOTICE_GROUP_ASSET_ADMIN_PLAYER	= 124,		--返回任命玩家为会长结果（仅管理员可操作）
	L2C_NOTICE_GROUP_TRANSFER		= 125,		--返回军团转让结果
	L2C_NOTICE_GROUP_DISOLUTE		= 126,		--返回军团解散结果（仅管理员可操作）
	L2C_NOTICE_GROUP_INVITE_CREATE		= 127,		--返回创建军团邀请函结果
	L2C_NOTICE_GROUP_INVITE_JOIN		= 128,		--返回加入军团邀请函结果
	L2C_NOTICE_CHAT_SEND_MESSAGE_BATTLE	= 129,		--返回请求发送一条组队副本邀请聊天消息结果
	
	
	
	
	
	
	--新手营
	L2C_NOVICECAMP_LIST		= 1001,				--返回新手营列表
	L2C_NOVICECAMP_CREATE		= 1002,				--返回新手营创建结果
	L2C_NOVICECAMP_REMOVE		= 1003,				--返回新手营解散结果
	L2C_MEMBER_LIST			= 1004,				--返回成员列表
	L2C_POWER_JION_ACCEPT		= 1005,				--返回营长通过新手申请
	L2C_POWER_JION_REJECT		= 1006,				--返回营长驳回新手申请
	L2C_POWER_JION_REQUEST		= 1007,				--返回新手申请加营结果
	L2C_POWER_JION_CANCEL		= 1008,				--返回新手取消申请结果
	L2C_NOVICECAMP_UPDATE		= 1009,				--返回更新新手营信息结果
	L2C_POWER_FIRE			= 1010,				--返回踢人结果
	L2C_CONFIG_PRIZE		= 1011,				--返回奖励信息
	L2C_NOVICECAMP_RENAME		= 1012,				--返回修改新手营名字结果
	L2C_BUILDING_UPGRADE		= 1013,				--返回升级建筑结果
	L2C_BUILDING_PRIZE		= 1014,				--返回建筑奖励
	L2C_POWER_QUIT			= 1015,				--返回退出结果
	L2C_CARD_UPGRADE		= 1016,				--返回战术卡升级结果
	L2C_POWER_ASSISTANT_APPOINT	= 1017,				--返回会长任命助理结果
	L2C_POWER_ASSISTANT_DISAPPOINT	= 1018,				--返回会长取消任命助理结果
	L2C_NOVICECAMP_LIST_JOIN	= 1019,				--返回申请加入军团列表
	L2C_NOTICE_GROUP_SEARCH_RET	= 1020,				--返回军团查找结果
}
