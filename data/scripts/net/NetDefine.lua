hGlobal.NET_DATA = {}
GameSession = {}
GameSession.recCmdHandlers = {}
GameSession.sendCmdHandlers = {}

hVar.PVP_CONSOLE_SWITCH = 0

hVar.PVP_FIGHT_MODE = {
	UNKNOWN = 0,
	PVP = 1,
}

hVar.PVP_PLAYER_STATE = {
	OFFLINE = 0,
	FREE = 1,
	IN_BATTLE = 2,
	BUSY = 3,
	AUTOMATCH = 4,
	REPLAY = 5,
	NPC = 6,
	RANK_KING = 7,
}

hVar.PVP_CHANLLENGE_STATE = {
	INIT = 0,
	WAITING = 1,
	ACTIVE = 2,
	COMPLETE = 3,
	EXCEPTION = 4,
	END = 5,
}

hVar.PVP_CHANLLENGE_CHANGE_REASON = {
	NONE = 0,
	TIMEOUT = 1,
	OFFLINE = 2,
	ACCEPT = 3,
	REFUSE = 4,
	READY = 5,
	LEAVE = 6,
	COMPLETED = 7,
	RESTART = 8,
}

hVar.PVP_CHANLLENGE_ERRCODE = {
	OK = 0,
	FAIL = 1,
	INVALID_PVP_MODE = 2,
	PLAYER_IN_BATTLE = 3,
	PLAYER_NOT_FOUND = 4,
	CANNOT_CHALLENGE_SELF = 5,
	INVALID_CHALLENGE_STATE = 6,
}

--玩家UI操作后 发送给服务器的 状态修改指令
hVar.PVP_SEND_PLAYER_STATE = {
	E_PLAYER_STATE_OFFLINE = 0,
	E_PLAYER_STATE_FREE = 1,
	E_PLAYER_STATE_IN_BATTLE = 2,
	E_PLAYER_STATE_PROTECT = 3,
}

hVar.PVP_OPERATE_TYPE = {
	CMSG_AUTH		= 1000,
	GAME_MSG_PVP_BEGIN	= 1500,

	C2L_LOG			= 3010,

	L2C_ONLINE		= 4000,
	C2L_ONLINE		= 4000,
	C2L_OFFLINE		= 4001,
}
local __PVP_OPERATE_TYPE = {
	C2LY_PLAYER_LIST = 1,
	LY2C_PLAYER_LIST = 2,

	L2C_ERROR = 3,

	C2L_REQ_CHALLANGE = 4,
	L2C_REQ_CHALLANGE_RET = 5,

	L2C_BEING_CHALLANGED = 6,
	C2L_BEING_CHALLANGED_RET = 7,

	C2L_READY_GAME = 8,
	C2L_COMPLETE_GAME = 9,
	C2L_REQ_RESTAR = 10,

	P2P_GAME_DATA = 11,
	P2P_GAME_CMD = 12,

	L2C_CHALLANGE_STATE_CHANGED = 13,
	C2L_LEAVE_GAME = 14,
	
	L2C_BATTLE_INFO = 15,
	L2C_PLAYER_ID = 16,

	L2C_OP_TIMEOUT = 17,		--现在已经不发了，这毫无意义
	
	C2L_GAME_RESULT = 18,
	L2C_GAME_RESULT_RET = 19,

	C2L_PLAYER_STATE = 20,

	C2L_PLAYER_PARAM = 21,		--给服务器发一条长度不超过128字节的自定义字符串，会被其他玩家在请求列表的时候刷到

	C2L_PLAYER_NET_SAVE_UPDATE = 22,	--要求对自己的网络存档进行修改
	L2C_PLAYER_NET_SAVE_UPDATE = 23,	--服务器处理完网络存档后会把数据发下来

	C2L_PLAYER_SWITCH_ROOM = 24,		--玩家切换房间

	L2C_ROOM_TIMEOUT_WARNING = 25,		--对决超时(收到这个消息后，强行根据双方的操作平均耗时决定胜负)

	C2L_GAME_CMD_CONFIRM = 26,		--玩家收到服务器的cmd后，回应服务器
}

for k,v in pairs(__PVP_OPERATE_TYPE) do
	hVar.PVP_OPERATE_TYPE[k] = hVar.PVP_OPERATE_TYPE.GAME_MSG_PVP_BEGIN + v
end


hVar.NET_ROLE_INFO_TYPE = {
	MSG_START = 2000,
}
local __NET_ROLE_INFO_TYPE = {
	MSG_ID_C2L_ROLEINFO_QUERY = 1,
	MSG_ID_L2C_ROLEINFO_QUERY_RET = 2,
	MSG_ID_C2L_ROLEINFO_UPDATE = 3,
	MSG_ID_L2C_ROLEINFO_UPDATE_RET = 4,
}

for k,v in pairs(__NET_ROLE_INFO_TYPE)do
	hVar.NET_ROLE_INFO_TYPE[k] = v + hVar.NET_ROLE_INFO_TYPE.MSG_START
end

hVar.NET_CONNECTION_TYPE = {
	CT_LOGIN = 1,
	CT_GAME = 2,
}

hVar.NET_DATA_DEFINE = {
	PLAYER_ID = 1,		--房间内的 临时ID 
	PLAYER_ROLE_ID = 2,	--玩家的角色ID 对应数据库查询用
	PLAYER_NAME = 3,
	BF_DATA = 4,
	IS_READY = 5,
	SYNC_SUM = 6,
	DEPLOYMENT = 7,
	DEPLOYMENT_CONV = 8,
	ELO = 9,
}

hVar.NET_BF_DATA_TYPE = {
	TACTICS = 1,
	UNIT = 2,
	HERO = 3,
	ARMYCARD = 4,
}

hVar.PVP_ROOM_TYPE = {
	NPC = 0,
	RANK = 1,
	PRACTICE = 2,
	CHALLENGE = 3,
}

hVar.PVP_PLAYER_DATA = {	--PVP中创建房间时用到的信息
	ID = 1,
	ROLE_ID = 2,
	NAME = 3,
	ELO = 4,
	PARAM = 5,
	STATE = 6,
	HOST = 7,
	GUEST = 8,
	CHANLLENGE = 9,
	TIME = 10,
	LIMIT = 11,
	NPC = 12,
	EXTRA = 13,		--额外信息
}

hVar.PVP_ROOM_DATA = {
	HOST		= 1,
	GUEST		= 2,
	HOST_PARAM	= 3,
	GUEST_PARAM	= 4,
	STATE		= 5,
	CHECK_NUM	= 5,	--检查需要刷新标记
	PAST		= 6,
	LIMIT		= 7,
	TICK		= 8,
	SERVER_TICK	= 9,
	MAX_NUM		= 9,	--最大数量
}
hVar.PVP_ROOM_STATE = {
	BUSY		= 1,
	READY		= 2,
	BATTLE		= 3,
	REPLAY		= 4,
	NPC		= 5,
	NPC_RANK_KING   = 6	--为天梯房前三名打标签
}

hVar.NET_SAVE_UPDATE_DATA = {
	ID = 1,
	UNIQUE = 2,
	PARAM = 3,
}

hVar.NET_SAVE_OPR_TYPE = {
	C2L_UPDATE_ALL_ARMY_CARD	= 1,
	L2C_UPDATE_ALL_ARMY_CARD	= 2,

	L2C_UPDATE_ONE_ARMY_CARD	= 3,

	C2L_UNLOCK_ARMY_CARD		= 4,
	C2L_UPGRADE_ARMY_CARD		= 5,
	C2L_CLEAR_ALL_ARMY_CARD		= 6,
	C2L_UPDATE_PVP_SCORE		= 7,
	C2L_BUY_PVP_COIN		= 8,
}

hVar.PVP_DB_OPR_TYPE = {
	C2L_UPDATE			= 3000,
	C2L_UPDATE_DEPLOYMENT		= 1,

	C2L_REQUIRE			= 3000,
	C2L_REQUIRE_RANK_LIST		= 2,
	C2L_REQUIRE_ROLE_INFO		= 3,
	C2L_REQUIRE_HOTFIX		= 4,
	C2L_REQUIRE_QUEST		= 5,
	C2L_CONFIRM_QUEST		= 6,
	C2L_REQUIRE_REPLAY		= 7,
	C2L_REQUIRE_NPC			= 8,
	C2L_REQUIRE_SWITCH		= 9,
	C2L_UPLOAD_CMD_LOG		= 10,	--这个协议其实不会用到
	C2L_REQUIRE_PVE_GAME		= 11,	--要求启动一局PVE对决
	C2L_REQUIRE_RANK_KING		= 12,	--请求rank king
	C2L_REQUIRE_PVE_RANK_KING	= 13,	--要求启动一局rank king对决
}

hVar.PVP_DB_RECV_TYPE = {
	L2C_RECV = 3001,
	L2C_RANK_DATA		= 1,
	L2C_ROLE_INFO		= 2,
	L2C_BF_RESULT		= 3,
	L2C_MSG			= 4,
	L2C_QUEST		= 5,
	L2C_QUEST_REWARD	= 6,
	L2C_REPLAY		= 7,
	L2C_NPC			= 8,
	L2C_SWITCH		= 9,
	L2C_REQUIRE_CMD_LOG	= 10,	--这个东西发送时走的是hVar.PVP_OPERATE_TYPE.C2L_LOG协议
	L2C_STRART_PVE_GAME	= 11,	--启动一局PVE对决
	L2C_RANK_KING		= 12,	--下发排行榜第一玩家数据
	L2C_STRART_RANK_KING	= 13,	--启动竞技场季赛冠军
}

hVar.PVP_LOG_TYPE = {
	DUEL_REPLAY	= 1,
	SYNC_ERROR	= 2,
	QUICK_REPLAY	= 3,
	NPC_REPLAY	= 4,
	CMD_LOG		= 5,
	NPC_RANK_KING   = 6,
}

hVar.PVP_QUEST_DATA = {
	TYPE = 1,
	STATE = 2,
	NAME = 3,
	TIP = 4,
	INTRO = 5,
	REWARD = 6,
}