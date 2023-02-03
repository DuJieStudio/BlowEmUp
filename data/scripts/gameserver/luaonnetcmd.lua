--local iChannelId = xlGetChannelId()
--if iChannelId < 100 then
	--return
--end

--网络协议define
hVar.ONLINECMD = {
	PLANTFORM_ASK		= 3900,		--查询第三帐号下的游戏帐号信息
	PLANTFORM_ASK_RES	= 3901,
	NEW_LOGIN		= 3902,
	NEW_LOGIN_RES		= 3903,
	NEW_REGISTER		= 3904,
	NEW_REGISTER_RES	= 3905,		--包含第三方的新注册回执
	BIND_PLANTFORM		= 3906,
	BIND_PLANTFORM_RES	= 3907,
	BIND_PLANTFORM_OLD	= 3908,
	BIND_PLANTFORM_OLD_RES	= 3909,
	UNBIND_PLANTFORM	= 3910,		--解绑
	UNBIND_PLANTFORM_RES	= 3911,		--解绑返回
	BIND_REALNAMEINFO	= 3920,		--绑定实名信息
	BIND_REALNAMEINFO_RES	= 3921,	
	REQUEST_PLAYTIME	= 3922,		--获取游戏时间（未成年用户）
	REQUEST_PLAYTIME_RES	= 3923,
	GET_INFO_AFTER_LOGIN	= 3930,		--登陆前获取信息
	GET_INFO_AFTER_LOGIN_RES= 3931,		--登陆前获取信息的返回
	NEW_RE_LOGIN		= 3912,		--游戏里重新登录
	NEW_RE_LOGIN_RES	= 3913,		--游戏里重新登录的返回
	REGISTER_RES		= 3999,		--注册成功的返回
	LOGIN			= 4000,
	REQUEST_SAVE		= 4001,
	REQUEST_SAVE_RECV	= 4002,

	--上传存档
	NOTIIFY_CLIENT_SEND	= 4003,
	SEND_SAVE_FILE		= 4004,
	CONFIRM_SEND_FILE	= 4005,
	-----------------------------------
	CMD_OBTAINHERO		= 4007,		--通知服务器获取英雄令 hero
	CMD_OBTAINHERO_RES	= 4008,		--返回4007 结果
	
	CMD_OBTAINMAP		= 4009,		--通知服务器开启地图 map
	CMD_OBTAINMAP_RES	= 4010,		--4009 的返回
	-------------loadbag---------------
	CMD_LOADBAG		= 4011,		--读取hero表 field字段 及 t_cha的bag字段
	CMD_LOADBAG_RES		= 4012,		--返回4011 hero表 field字段 及 t_cha的bag字段
	-------------updatebag-------------
	CMD_UPDATEBAG		= 4013,		--更新hero表 field字段 及 t_cha的bag字段
	CMD_UPDATEBAG_RES	= 4014,		--返回4013更新结果
	-------------loadcard--------------
	CMD_LOADCARD		= 4015,		--读取t_cha card信息
	CMD_LOADCARD_RES	= 4016,		--返回4015 t_cha card信息
	-------------updatecard------------
	CMD_UPDATECARD		= 4017,		--更新t_cha card信息
	CMD_UPDATECARD_RES	= 4018,		--返回4017更新结果
	-------------loadmap--------------
	CMD_LOADMAP		= 4102,		--读取map info信息	*******[4019暂时废弃]
	CMD_LOADMAP_RES		= 4103,		--返回4019 map info信息 *******[4020暂时废弃]
	------------updatemap--------------
	CMD_UPDATEMAP		= 4021,		--更新map info信息
	CMD_UPDATEMAP_RES	= 4022,		--返回4021更新结果
	----------------------getherolist----------------------------------------------
	CMD_GETHEROLIST		= 4023,		--读取roleid 下heroid list信息
	CMD_GETHEROLIST_RES	= 4024,		--返回4024 heroid list信息
	----------------------getMaplist-----------------------------------------------
	CMD_GETMAPLIST		= 4025,		--读取roleid 下map list信息
	CMD_GETMAPLIST_RES	= 4026,		--4025 map list信息
	----------------------loadallmap-----------------------------------------------
	CMD_LOADMAPLIST		= 4027,		--读取roleid 下 所有mapinfo信息
	CMD_LOADMAPLIST_RES	= 4028,		--4027 所有mapinfo信息
	------------------------gameScore----------------------------------------------
	CMD_USER_SAVESCORE	= 30020,	--上传积分
	CMD_USER_SAVESCORE_RES	= 30021,	--保存结果
	-----------------------Login_Out-----------------------------------------------
	CMD_LOGIN_OUT		= 3997,		--发送更换账号的请求
	CMD_LOGIN_OUT_RES	= 3997,		--允许登出的返回
	CMD_LITF_OF_RESF	= 3998,		--在别的设备上登陆强行踢掉
	----------------------loadskill------------------------------------------------
	CMD_LOADSKILL		= 4029,		--读取t_cha skill信息	
	CMD_LOADSKILL_RES	= 4030,		--返回4029 t_cha skill信息
	----------------------updateskill----------------------------------------------
	CMD_UPDATESKILL		= 4031,		--更新t_cha skill信息
	CMD_UPDATESKILL_RES	= 4032,		--返回4031更新结果
	----------------------loadmaterial---------------------------------------------
	CMD_LOADMATERIAL	= 4033,		--读取t_cha material信息
	CMD_LOADMATERIAL_RES	= 4034,		--返回4033 t_cha material信息
	----------------------updatematerial-------------------------------------------
	CMD_UPDATEMATERIAL	= 4035,		--更新t_cha material信息
	CMD_UPDATEMATERIAL_RES	= 4036,		--返回4031更新结果
	
	----------------------loadkeychain---------------------------------------------
	CMD_LOAD_KEYCHAIN	= 4037,		--读取t_cha keychain信息
	CMD_LOAD_KEYCHAIN_RES	= 4038,		--返回4037 t_cha keychain信息

	----------------------updatekeychain-------------------------------------------
	CMD_UPDATE_KEY_CHAIN	= 4039,		--更新t_cha keychain信息
	CMD_UPDATE_KEY_CHAIN_RES = 4040,	--返回4039更新结果
	----------------------活动信息-------------------------------------------------
	CMD_ACTIVITY_INFO	= 4041,		--请求活动信息
	CMD_ACTIVITY_INFO_RES	= 4042,		--返回4041结果
	
	----------------------充值成功后的回调-----------------------------------------
	CMD_CONST_INT_CMD_IAP_TOPUP	= 30012,

	----------------------礼品码领取-------------------------------------------------
	CMD_GET_GIFT_REWARD	= 4043,		--请求活动信息
	CMD_GET_GIFT_REWARD_RES	= 4044,		--返回4043结果
	CMD_GET_GIFT_CONFIRM	= 4045,		--更新礼品吗标志
	
	----------------------更新数据-------------------------------------------------
	--安卓，写存档接口协议号
	CMD_SAVE_NEWDIC	= 4100,		--上传数据，总数据接口
	CMD_SAVE_NEWDIC_RES	= 4101,		--4100返回上传数据后的返回
	
	----------------------更新数据-------------------------------------------------
	--CMD_SEND_GAME_DATA	= 4100,		--上传数据，总数据接口
	--CMD_SEND_GAME_DATA_RES	= 4101,		--4100返回上传数据后的返回
	
	----------------------loaddic-------------------------------------------------
	CMD_LOAD_DICINFO	= 4104,		--读取dic info信息	
	CMD_LOAD_DICINFO_RES	= 4105,		--返回4104 dic info信息
	
	CMD_SEND_LOADSTRING_ERROR	= 4444,	--上传错误日志

	----------------------loadlog-------------------------------------------------
	--p1 (protocol int) p2 (uid int) P3 (rid int)
	CMD_LOAD_LOG		= 4106,		--读取t_cha log信息
	--P1 (protocol int) P2 (errorcode int) P3 (uid int) P4 (log string) P5
	CMD_LOAD_LOG_RES	= 4107,		--返回4106 t_cha log信息
	----------------------updatelog-------------------------------------------------
	--p1 (protocol int) p2	(uid int) p3 (rid int) p4 (log string)
	CMD_UPDATE_LOG		= 4108,		--更新t_cha log信息
	--p1 (protocol int) p2 (errorcode int) p3 (uid int) p4	(rid int)
	CMD_UPDATE_LOG_RES	= 4109,		--返回4108更新结果
	----------------------------------------------------------------------------
	
	--------------------------------------------------------------------------
	CMD_LOGIN_CONFIRM	= 4400,		--登陆成功后给的返回
	CMD_RESETPASSWORD_RES	= 4402,		--修改密码的返回

	CMD_HEART_BEAT		= 44444,		--心跳包
	CMD_HEART_BEAT_RES	= 44445,		--心跳包回执
}

--网络协议接收处理
GluaNetCmd = {}
--收到消息的总入口
function LuaOnNetPack_android(NetPack)
	--从第二位开始去协议ID
	local typeID = NetPack[1]
	if type(GluaNetCmd[typeID]) == "function" then
		local netData = {}
		for i = 2,#NetPack do
			netData[#netData+1] = NetPack[i]
		end
		GluaNetCmd[typeID](unpack(netData))
	end
end

function CheckShouldCopySave(oldUID,newUid)
	local nShouldCopy = 0
	local iChannelId = xlGetChannelId()
	--local iChannelId = 1
	local TargetPlatform = CCApplication:sharedApplication():getTargetPlatform()
	
	if g_loadServerSaveData == 1 then
		--读取服务器存档
	elseif oldUID == 0 then
		--第一次获得UID  需要复制原存档
		nShouldCopy = 1
	elseif newUid ~= oldUID then
		if iChannelId == 1 then
			local nIsNew = 0
			--ios 平台 老账号 需要复制原存档
			if g_tTargetPlatform.kTargetWindows ~= TargetPlatform then
				nIsNew = xlGetIntFromKeyChain("xl_"..oldUID.."_isNew") or 0
			else
				nIsNew = CCUserDefault:sharedUserDefault():getIntegerForKey("xl_"..oldUID.."_isNew") or 0
			end
			if nIsNew == 0 then
				nShouldCopy = 1
			end
		end
	end
	if iChannelId == 1 then
		if g_tTargetPlatform.kTargetWindows ~= TargetPlatform then
			xlSaveIntToKeyChain("xl_"..newUid.."_isNew",1)
		else
			CCUserDefault:sharedUserDefault():setIntegerForKey("xl_"..newUid.."_isNew",1)
			CCUserDefault:sharedUserDefault():flush()
		end
	end
	return nShouldCopy
end

function CopyPlayerSave(oldUID,newUid,oldname)
	--存储新存档
	LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)

	--删除旧存档
	xlDeleteFileWithFullPath(g_localfilepath..oldname..hVar.SAVE_DATA_PATH.MAP_SAVE)
	xlDeleteFileWithFullPath(g_localfilepath..oldname..hVar.SAVE_DATA_PATH.FOG)
	xlDeleteFileWithFullPath(g_localfilepath..oldname..hVar.SAVE_DATA_PATH.PLAYER_DATA)
	xlDeleteFileWithFullPath(g_localfilepath..oldname..hVar.SAVE_DATA_PATH.PLAYER_LOG)
	
	
end

--登陆协议 4000
--imaccmp		--是否有变化
--useDic		--是否使用服务器存档
--snapshotID		--快照序列号
--num			--几块数据
GluaNetCmd[hVar.ONLINECMD.LOGIN] = function(protocol,uid,rid,errcode,name,isReconnection,iTag,password,imaccmp,useDic,snapshotID,num,...)
	print("hVar.ONLINECMD.LOGIN",errcode)
	if (errcode == 0) or (errcode == 200) then --0:登录成功/200:重复登录成功
		local args = {...}
		--Save_PlayerData = {}
		--Save_PlayerLog = {}
		
		--Save_PlayerData = nil
		--Save_PlayerLog = nil
		
		--标记不是异常重连状态
		g_isLoginException = 0
		
		--管理员可查看日志
		hGlobal.event:event("localEvent_SaveDataChangeLog", {
			time = os.date("%Y-%m-%d %H:%M:%S", os.time()),
			content = "登入成功！ uid:" .. uid .. ", " .. "rid:" .. rid .. ", " .. "name:" .. name .. ", ".. "snapshotID:" .. snapshotID .. ",",
			color = {192, 255, 192,},
		})
		
		Save_PlayerData = nil
		Save_PlayerLog = nil
		
		--安卓流程
		--初始化存档名
		--hVar.SAVE_DATA_PATH.PLAYER_LIST = "User" .. uid .. "playerlist" .. ".sav"
		--hVar.SAVE_DATA_PATH.PLAYER_DATA = "User" .. uid .. "playerdata" .. ".sav"
		--hVar.SAVE_DATA_PATH.PLAYER_LOG = "User" .. uid .. "playerlog" .. ".sav"
		
		--解析表情
		name = hApi.StringDecodeEmoji(name)
		
		--原存档文件是否存在
		local bSaveDataExisted = (hApi.FileExists(g_localfilepath..hVar.SAVE_DATA_PATH.PLAYER_LIST,"full") and hApi.FileExists(g_localfilepath..g_curPlayerName..hVar.SAVE_DATA_PATH.PLAYER_DATA,"full"))
		--print(g_localfilepath..g_curPlayerName..hVar.SAVE_DATA_PATH.PLAYER_LIST)
		--print(g_localfilepath..g_curPlayerName..hVar.SAVE_DATA_PATH.PLAYER_DATA)
		print("原存档文件是否存在=", bSaveDataExisted)
		
		--获取上一次登录时的UID  进行对比 
		--如果UID是0   那么直接赋值存档  删除旧的
		--如果是UID不是0  且是Ios平台  没有新版的存档文件  那么复制存档  且删除旧的
		local oldUID = xlPlayer_GetUID() or 0
		local oldname = g_curPlayerName
		local nShouldCopySave = CheckShouldCopySave(oldUID,uid)
		--保留原积分
		local score = LuaGetPlayerScore()
		--保留原随机地图信息
		local tInfos = LuaGetPlayerRandMapInfo(g_curPlayerName)
		--保留原最佳通关记录
		local tRecord =  LuaGetRandMapBestRecord(g_curPlayerName)
		
		--初始化登陆UID
		xlPlayer_SetUID(uid,password,iTag)
		if Save_PlayerData then
			Save_PlayerData.userID = uid
		end
		
		--初始化本地玩家名
		g_curPlayerName = "User"..tostring(uid)
		
		if nShouldCopySave == 1 then
			CopyPlayerSave(oldUID,uid,oldname)
			LuaSetPlayerScore(score)
		end
		
		--xlLoadPlayerInfo(g_localfilepath)
		--格式化本地玩家表
		LuaSetPlayerList(1,g_curPlayerName,rid)
		
		--默认主公名改为含有uid的名字
		--[[
		local playerInfo = LuaGetPlayerByName(g_curPlayerName)
		if playerInfo and (playerInfo.showName) then
			if (playerInfo.showName == hVar.tab_string["guest"]) then
				local showname = hVar.tab_string["guest"] .. tostring(uid)
				--设置主公名称
				LuaSetPlayerShowName(rid,showname)
			end
		end
		]]
		
		--UI刷新
		local playerInfo = {name = g_curPlayerName}
		LuaSwitchPlayer(playerInfo,rid)
		luaSetplayerDataID(rid)
		
		--print("aaaaaaaaaaaaaaaaaaaaaaa name",name)
		local playerInfo = LuaGetPlayerByName(g_curPlayerName)
		if playerInfo then
			if name == "" or name == " " then
				playerInfo.showName = hVar.tab_string["guest"]..uid
				SendCmdFunc["modify_tank_username"](playerInfo.showName, 0)
			elseif name ~= hVar.tab_string["text_youke"]..uid then
				playerInfo.showName = name
			--else
				--playerInfo.showName = hVar.tab_string["guest"]
			end
		end
		
		if nShouldCopySave == 1 then
			--复制原存档随机地图进度
			LuaSetPlayerRandMapInfos(g_curPlayerName,tInfos)
			--复制原存档最佳通关记录
			LuaUpdateRandMapBestRecord(g_curPlayerName,tRecord)
		end
		
		print("g_loadServerSaveData=", g_loadServerSaveData)
		--hGlobal.event:event("LocalEvent_SaveGuestCfg")
		hGlobal.event:event("LocalEvent_SaveNewGuestCfg")
		--g_loadServerSaveData = 1
		if g_loadServerSaveData == 1 then
			--读取服务器存档
			--覆盖本地存档
			print("snapshotID=", snapshotID)
			if (snapshotID > 0) then --存档版本号大于0
				print("num=", num)
				if (num > 0) then --存在存档
					local oldSnapShotID = xlPlayer_GetSnapShotID(uid) or 0
					print("原存档id=", oldSnapShotID)
					
					--本次存档较旧，需要讲服务器存档覆盖本地
					--或者本地没有存档，需要将服务器存档覆盖本地
					if (oldSnapShotID < snapshotID) or (not bSaveDataExisted) or (Save_PlayerData == nil) then
						print("本次存档较旧，需要将服务器存档覆盖本地")
						
						local rs = ""
						for i = 1, num * 2, 2 do
							local key, data = args[i], args[i+1]
							local tResult = {}
							print(key, #data)
							if (type(data == "string")) and (#data > 0) then
								local sTmp = "local tmp = " .. data .. " return tmp"
								tResult = assert(loadstring(sTmp))()
								
								print("写入 " .. key)
								
								if (Save_PlayerData == nil) then
									Save_PlayerData = {}
								end
								
								if (key == "card") then --英雄
									Save_PlayerData.herocard = tResult
								elseif (key == "skill") then --战术卡
									Save_PlayerData.battlefieldskillbook = tResult
								elseif (key == "bag") then --背包
									Save_PlayerData.bag = tResult
								elseif (key == "map") then --地图
									Save_PlayerData.mapAchi = tResult
								elseif (key == "material") then --杂项
									for k, v in pairs(tResult) do
										if (k ~= "herocard") and (k ~= "battlefieldskillbook") and (k ~= "bag") and (k ~= "mapAchi") then
											Save_PlayerData[k] = v
										end
									end
								elseif (key == "log") then --日志
									Save_PlayerLog = tResult
								end
							end
						end
						
						--设置本地的存档号
						xlPlayer_SetSnapShotID(uid, snapshotID)
						
						---------------------------------------------
						--todo: 临时代码
						--积分
						local score = Save_PlayerData.totalScore
						--清除积分信息
						local TargetPlatform = CCApplication:sharedApplication():getTargetPlatform()
						--IOS
						if g_tTargetPlatform.kTargetWindows ~= TargetPlatform then
							xlSaveIntToKeyChain("xl_"..g_curPlayerName.."_playerScore",score)
						--windows
						else
							CCUserDefault:sharedUserDefault():setIntegerForKey("xl_"..g_curPlayerName.."_playerScore",score)
							CCUserDefault:sharedUserDefault():flush()
						end
						---------------------------------------------
						
						--存档
						LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
						--本地存档
						LuaSavePlayerList()
						
						--UI刷新
						local playerInfo = {name = g_curPlayerName}
						LuaSwitchPlayer(playerInfo,rid)
						luaSetplayerDataID(rid)
						
						local playerInfo = LuaGetPlayerByName(g_curPlayerName)
						if playerInfo then
							if name ~= hVar.tab_string["text_youke"]..uid then
								playerInfo.showName = name
							else
								playerInfo.showName = hVar.tab_string["guest"]
							end
						end
					end
				end
			end
			
			g_loadServerSaveData = 0
			--界面回调
			hGlobal.event:event("LocalEvent_RestoreSaveDataSuccess")
		end
		
		--登录成功后重置 重开游戏标记
		LuaSetPlayerStartNewGame(g_curPlayerName,0)

		--存储最后一次登陆信息(审核版本用)
		hGlobal.event:event("LocalEvent_RecordLastLogin")

		--初始化装备信息
		LuaInitEquipData()
		
		--local rs = hApi.FormatSaveDataByStr(uid,num,args,imaccmp,useDic,snapshotID)
		--if type(args[num * 2 + 1]) == "number" then
			--g_IsGM = args[num * 2 + 1]
			--hGlobal.event:event("LocalEvent_isGM",g_IsGM)
		--end
		
		--服务器开关
		if type(args[num * 2 + 3]) == "string" then
			--字符串转table
			print("ssss",args[num * 2 + 3])
			hApi.ReadOBConfig(args[num * 2 + 3])
		end
		
		--print(args[num * 2 + 1],args[num * 2 + 2],args[num * 2 + 3],args[num * 2 + 4])
		--总计存活天数
		local birth_day = 0
		if type(args[num * 2 + 4]) == "number" then
			birth_day = args[num * 2 + 4]
		end
		
		--实名状态
		local pi_state = 0
		if type(args[num * 2 + 5]) == "number" then
			pi_state = args[num * 2 + 5]
		end
		
		--身份证
		local id_card = ""
		if type(args[num * 2 + 6]) == "string" then
			id_card = args[num * 2 + 6]
		end
		
		--姓名
		local id_name = ""
		if type(args[num * 2 + 7]) == "string" then
			id_name = args[num * 2 + 7]
		end
		
		--多处登陆的上一次登陆的ip（仅登陆失败 错误码222有数据）
		local last_ip = ""
		if type(args[num * 2 + 8]) == "string" then
			last_ip = args[num * 2 + 8]
		end
		
		--多处登陆的上一次登陆的port（仅登陆失败 错误码222有数据）
		local last_port = ""
		if type(args[num * 2 + 9]) == "number" then
			last_port = args[num * 2 + 9]
		end
		
		g_login_token = ""
		if type(args[num * 2 + 10]) == "string" then
			g_login_token = args[num * 2 + 10]
		end
		
		--local playerInfo = LuaGetPlayerByName(g_curPlayerName)
		--FormatPlayerData(g_localfilepath,g_curPlayerName,playerInfo,Save_PlayerData)

		----xlLoadTempData()
		--hApi.ReadItemDisabledFromSave()		--处理作弊道具
		--local nIsTester = CCUserDefault:sharedUserDefault():getIntegerForKey("xl_account_test")
		--if g_IsGM == 1 or nIsTester == 1 or g_lua_src == 1 then
			--hApi.EnumAllMyItem(LuaMarkPlayerItem)	--道具类型校验
		--else
			----统计装备
			--hApi.EnumAllMyItem(LuaCountItem)
		--end
		----修复UID有重复
		--hApi.RepairItemUniqueID()
		--g_CanCheckItemCheat = 1			--开启道具作弊检测

		----格式化item存档数据
		--SaveModifyFunc["ItemDataFormat"](Save_PlayerData)
		----去掉多余的数据项
		--SaveModifyFunc["ACHI"](Save_PlayerData.mapAchi)
		----增加新增数据项
		--SaveModifyFunc["LOG"]()
		
		--GluaSendNetCmd[hVar.ONLINECMD.CMD_LOAD_KEYCHAIN](uid,rid)
		
		GluaSendNetCmd[hVar.ONLINECMD.CMD_SEND_LOADSTRING_ERROR]("onLoginSuccess:"..tostring(rs))
		
		GluaSendNetCmd[hVar.ONLINECMD.CMD_LOGIN_CONFIRM]()
		
		--发起查询服务器系统时间
		SendCmdFunc["refresh_systime"]()
		
		--发起查询月卡和月卡每日领奖
		SendCmdFunc["query_month_card"]()
		
		----获取作弊标志(安卓无协议)
		----SendCmdFunc["get_cheatflag"]()
		--获取测试员标记
		SendCmdFunc["get_Account_Test"]()
		
		--获取服务器版本控制信息
		SendCmdFunc["get_version_control"]()
		
		--获取武器枪服务器同步数据
		SendCmdFunc["tank_sync_weapon_info"]()
		--获取战车技能点数同步数据
		SendCmdFunc["tank_sync_talentpoint_info"]()
		--获取战车宠物同步数据
		SendCmdFunc["tank_sync_pet_info"]()
		--获取战车战术卡同步数据
		SendCmdFunc["tank_sync_tactic_info"]()
		--获取战车地图同步数据
		SendCmdFunc["tank_sync_map_info"]()
		--获取成就数据
		SendCmdFunc["achievement_query_info"]()
		--获取玩家体力产量信息
		--SendCmdFunc["tank_reqiure_tili_info"]()
		--获取玩家神器信息
		SendCmdFunc["sync_redequip"]()
		
		--发送查询活动信息请求
		local langIdx = g_Cur_Language - 1
		SendCmdFunc["get_ActivityList"](langIdx)
		
		--聊天最新消息id同步
		SendCmdFunc["sync_chat_msg_id"]()

		--print("获取玩家神器信息")
		----申请VIP等级
		--SendCmdFunc["get_VIP_Lv"]()
		----申请游戏币
		--SendCmdFunc["gamecoin"]()
		----DLC检测
		--LuaCheckDLCFunc()
		----登录时发送一次 发送状态为 0 的玩家行为ID
		--LuaCheatBehaviorList()
		----更新掉线log
		--LuaUpdatePlayerOffLineLog()
		----作弊检查
		--if g_IsGM == 1 then
			--LuaDelCheatLog()
		--else
			--LuaCheckCheatLog()
		--end
		----申请每日任务
		--hGlobal.event:event("localEvent_RequestNetTask")
		
		--查询充值条目
		local current_iType = xlGetIapType() --读取支付类型
		--默认是用苹果支付
		if (current_iType == 0) then
			current_iType = 1
		end
		xlRequestIapList(current_iType)
		
		----计时器移到了登录之后  因为这个东西导致玩家收到存档前先上传了存档  然后才收到服务器存档   
		----这时如果玩家直接闪退或者关游戏 那么服务器上记录的就是错误的存档 所以计时器移动了触发位置
		--hApi.clearTimer("__AndroidDataUpdateTimer")
		--hApi.addTimerForever("__AndroidDataUpdateTimer",hVar.TIMER_MODE.GAMETIME,5000,function(tick)
			--if g_curPlayerName == nil then return end

			--GluaSendNetCmd[hVar.ONLINECMD.CMD_SEND_GAME_DATA](xlGetUIDSaveCount())

			--GluaSendNetCmd[hVar.ONLINECMD.CMD_HEART_BEAT]()
		--end)

		--if isReconnection == 1 then
			--hGlobal.event:event("LocalEvent_showAndroidNetAlreadyFrm",0)
			----有网络战场时不显示主界面
			----local oWorld = hGlobal.WORLD.LastWorldMap
			----if oWorld == nil and (hGlobal.ArenaConnect==nil or not(hGlobal.ArenaConnect:isConnected())) then
				----hGlobal.event:event("LocalEvent_OpenPhoneMainMenu_new",1)
			----end
			----当主界面显示的时候需要重新开启主界面  其余时候不显示  直接返回原界面即可
			--if g_MainMenu_Show == 1 then
				--hGlobal.event:event("LocalEvent_OpenPhoneMainMenu_new",1)
			--end
			--return
		--end

		--刷新活动列表
		GluaSendNetCmd[hVar.ONLINECMD.CMD_ACTIVITY_INFO](uid,rid)
		hGlobal.event:event("LocalEvent_new_mainmenu_frm",0)
		
		g_antologin = 1
		--登录成功后  不管如何他都应该关闭
		hGlobal.event:event("LocalEvent_showAndroidNetAlreadyFrm",0)

		if isReconnection == 1 then
			hApi.clearTimer("RecoverBtn_VerticalLoginFrm")
			return
		end

		g_isReconnection	= 1	--判断是否是断线重连

		local behaviorId = hVar.PlayerBehaviorList[20006]
		LuaAddBehaviorID(behaviorId)

		local screenmode = CCUserDefault:sharedUserDefault():getIntegerForKey("xl_screenmode")
		if screenmode ~= 0 then
			g_CurScreenMode = screenmode
		end
		local viewmode = CCUserDefault:sharedUserDefault():getIntegerForKey("xl_viewmode")
		if viewmode ~= 0 then
			g_CurViewMode = viewmode
		end
		
		--战车显血开关
		local tankhpbar = CCUserDefault:sharedUserDefault():getIntegerForKey("xl_tankhpbar")
		if (tankhpbar == 1) then
			hVar.OPTIONS.SHOW_TANK_HP_FLAG = 1
		end
		
		--print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
		--print(uid,birth_day,pi_state,id_card,id_name)
		if hApi.CheckPlayerRealNameStage(uid,birth_day,pi_state,id_card,id_name) == 0 then
			return
		end
		g_canSpinScreen = 1
		hGlobal.event:event("LocalEvent_EnterGame")

		----在刷新活动列表后开启主菜单
		--hGlobal.event:event("LocalEvent_OpenLoginView",0)
		--hGlobal.event:event("LocalEvent_PhoneShowPlayerCardFrm",g_curPlayerName)
		--hGlobal.event:event("LocalEvent_OpenPhoneMainMenu")

		----隐藏新的登陆界面
		--hGlobal.event:event("LocalEvent_ShowChannelLoginFrm",0)
		--hGlobal.event:event("LocalEvent_OpenPhoneMainMenu_new",1)
		----hGlobal.event:event("LocalEvent_shownewlualoginFrm",0)

		----华为平台需要发送游戏数据
		--local iChannelId = getChannelInfo()
		--if iChannelId == 1004 then
			--if xlHwAddInfo then
				--xlHwAddInfo("1 level",name,"0","null")
			--end
			--if xlGetChannelVersion and xlGetChannelVersion() > 2017080102 then
				----华为提交版本所需
			--else
				----hGlobal.event:event("ShowTempActivity")
				----hGlobal.event:event("ShowTempActivityEnd")
			--end
		--elseif iChannelId == 1005 then
			--xl9YAddInfo(uid,name,0,"0","0","0")
		--elseif iChannelId == 1006 then
			--xlTxAddInfo(uid)
			--if xlGetChannelVersion and xlGetChannelVersion() > 2017080102 then
				----应用宝提交版本所需
			--else
				----hGlobal.event:event("ShowTempActivityEnd")
			--end
		--elseif iChannelId == 1008 then
			--xlVvAddInfo(uid,name,0,"0","0")
		----elseif iChannelId == 100 or iChannelId == 1002 then 
			------弹框去下载新版本
			----if xlGetChannelVersion and xlGetChannelVersion() < 2018040404 then
				----if g_lua_src ~= 1 then
					----hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_UpdateTipInfoVer2"],{
						----font = hVar.FONTC,
						----ok = function() 
							----xlOpenUrl("http://app.xingames.com/download/sgz_android.html")
							----xlExit()
						----end,
					----},nil,nil,{"UI:tip",nil,nil,nil,nil,0.8})
				----end
			----end
		--elseif iChannelId == 1012 then
			--if g_Cur_Language > 2 then
				--hGlobal.event:event("DisableChatfrm")
			--end
		--end

	--登陆密码不对
	elseif errcode == 2 then
		hGlobal.UI.MsgBox(hVar.tab_string["pass_word_error"],{
			font = hVar.FONTC,
			ok = function()
				if isReconnection == 1 then
					xlExit()
				end
			end,
		})
	else
		print("LOGIN","errcode = ",errcode)
		hGlobal.UI.MsgBox(hVar.tab_string["__TEXT__AccountTip"]..hVar.tab_string["__TEXT_Fail"].."("..tostring(isReconnection)..")",{
			font = hVar.FONTC,
			ok = function()
				if isReconnection == 1 then
					xlExit()
				end
			end,
		})
		--if isReconnection == 1 then
			--xlExit()
		--end
	end

	--hApi.clearTimer("android_login_btn")
	--hUI.NetDisable(0)
end

--获取存档的协议 4002
GluaNetCmd[hVar.ONLINECMD.REQUEST_SAVE_RECV] = function(protocol,uid,rid,type,errcode,name,data)
	
end

--服务器 通知客户端上传存档 4003
GluaNetCmd[hVar.ONLINECMD.NOTIIFY_CLIENT_SEND] = function(protocol)
	
	
end

--服务器收到存档后的 确认返回 4005
GluaNetCmd[hVar.ONLINECMD.CONFIRM_SEND_FILE] = function(protocol,uid,rid,type,errcode)
	
end

--4008 返回4007 结果
GluaNetCmd[hVar.ONLINECMD.CMD_OBTAINHERO_RES] = function(protocol,errcode,uid,rid,heroid)

end

--4010 4009 的返回
GluaNetCmd[hVar.ONLINECMD.CMD_OBTAINMAP_RES] = function(protocol,errcode,uid,rid,mapid)
end

--4012 返回4011 hero表 field字段 及 t_cha的bag字段
GluaNetCmd[hVar.ONLINECMD.CMD_LOADBAG_RES] = function(protocol,errcode,uid,rid,type,heroid,field,bag)
end

--4014 返回4013更新结果 更新仓库数据的返回
GluaNetCmd[hVar.ONLINECMD.CMD_UPDATEBAG_RES] = function(protocol,errcode,uid,rid,type,heroid)

end

--4016 返回4015 t_cha card信息
GluaNetCmd[hVar.ONLINECMD.CMD_LOADCARD_RES] = function(protocol,errcode,uid,rid,card)

end

--4018 返回4017更新结果
GluaNetCmd[hVar.ONLINECMD.CMD_UPDATECARD_RES] = function(protocol,errcode,uid,rid)

end

--4103 返回4102 map info信息
GluaNetCmd[hVar.ONLINECMD.CMD_LOADMAP_RES] = function(protocol,errcode,uid,rid,mapinfo)
end

--4022 返回4021更新结果
GluaNetCmd[hVar.ONLINECMD.CMD_UPDATEMAP_RES] = function(protocol,errcode,uid,rid,mapid)
	
end


--返回4024 heroid list信息
GluaNetCmd[hVar.ONLINECMD.CMD_GETHEROLIST_RES] = function(protocol,errcode,uid,rid,num,...)

end

--返回4025 heroid list信息
GluaNetCmd[hVar.ONLINECMD.CMD_GETMAPLIST_RES] = function(protocol,errorcode,uid,rid,num,...)


end

--返回4027 所有mapinfo信息
GluaNetCmd[hVar.ONLINECMD.CMD_LOADMAPLIST_RES] = function(protocol,errcode,uid,rid,num,...)
	
end

--上传积分返回结果
GluaNetCmd[hVar.ONLINECMD.CMD_USER_SAVESCORE_RES] = function(protocol,errcode,uid,rid,score)
	hUI.NetDisable(0)

	if errcode == 0 then

	else
		print("CMD_USER_SAVESCORE_RES ERROR")
	end
end

--允许登出的返回
GluaNetCmd[hVar.ONLINECMD.CMD_LOGIN_OUT_RES] = function(protocol,uid,errcode)
	hUI.NetDisable(0)
	g_isReconnection = 0
	if errcode ~= 0 then
		hGlobal.UI.MsgBox("CMD_LOGIN_OUT_RES ERRCODE != 0".."\n"..errcode,{
			font = hVar.FONTC,
			ok = function() end,
		})
	else
		if g_doLoginOut == 1 then
			g_doLoginOut = nil
			--切换到login地图
			hGlobal.event:event("LocalEvent_new_mainmenu_frm", 1,false,nil,99)
		end
	end
end

--账号在其他设备登陆后的踢出接口
GluaNetCmd[hVar.ONLINECMD.CMD_LITF_OF_RESF] = function(protocol,reason)
	hUI.NetDisable(0)
	g_isReconnection = 0
	--账号在另一个设备登陆
	if reason == 0 then
		hGlobal.UI.MsgBox(hVar.tab_string["__TEXT__AccountTip3"],{
			font = hVar.FONTC,
			ok = function() 
				--[[
				if hApi.IsPVPConnected() then
					g_PVP_NetSaveData.MyExitOprTick = hApi.gametime()
					hGlobal.ArenaConnect:disconnect()
					--hGlobal.ArenaConnect:logout()
				end
				hApi.RturnToLoginFrm()
				--Game_Server.Connect()
				]]
				xlExit()
			end,
		})
	--自己主动退出
	elseif reason == 1 then
		--hApi.RturnToLoginFrm()
		if hApi.IsReviewMode() then
			--审核模式不关闭
		else
			--xlExit()
			if g_doLoginOut == 1 then
				g_doLoginOut = nil
				--切换到login地图
				hGlobal.event:event("LocalEvent_new_mainmenu_frm", 1,false,nil,99)
			end
		end
	end
end

--注册成功后的返回
GluaNetCmd[hVar.ONLINECMD.REGISTER_RES] = function(protocol,errcode,uid,name,password)
	if errcode == 0 then
		xlAddRegistCount(1)
		hGlobal.event:event("LocalEvent_showluaregisteredFrm",0)
		hGlobal.event:event("LocalEvent_showlualoginFrm",1,uid,password)
	elseif errcode == 99 then
		hGlobal.UI.MsgBox(hVar.tab_string["Register_def_name"],{
			font = hVar.FONTC,
			ok = function()
			end,
		})
	else
		hGlobal.UI.MsgBox(hVar.tab_string["Register_def"],{
			font = hVar.FONTC,
			ok = function()
			end,
		})
	end
end

GluaNetCmd[hVar.ONLINECMD.PLANTFORM_ASK_RES] = function(protocol,errcode,t_type,account,num,...)
	print("PLANTFORM_ASK_RES",protocol,errcode,t_type,account,num,...)
	if errcode == 0 then
		local args = {...}
		if num == 0 then
			hGlobal.event:event("LocalEvent_newRegisterForOtherPlant",t_type)
			--if g_guest_uid == nil or g_guest_uid == "" or g_guest_uid == 0 then--本地没游客号
				--GluaSendNetCmd[hVar.ONLINECMD.NEW_REGISTER](plantform_type,str,bindName," ")
				--hGlobal.event:event("Lua_ReNameFrm",1,2,"",t_type)
			--else--本地有游客号
				--hGlobal.event:event("Lua_BindOrNotFrm",1,t_type)
			--end
		else
			local uid = tonumber(args[1])
			if uid then
				g_lastPid = hVar.ONLINECMD.NEW_LOGIN
				g_lastPtable = {t_type,uid," ",nil,g_isReconnection}
				GluaSendNetCmd[hVar.ONLINECMD.NEW_LOGIN](t_type,uid," ",nil,g_isReconnection)
			end
		end
	else
		hGlobal.event:event("LocalEvent_ResetVerticalLoginBtn")
		if t_type == 55 then
			hGlobal.event:event("LocalEvent_NewGuestLoginError",errcode)
		else
			local strText = "hVar.ONLINECMD.PLANTFORM_ASK_RES , errcode "..errcode.." , t_type "..t_type
			hGlobal.UI.MsgBox(strText, {
				font = hVar.FONTC,
				ok = function()
					
				end,
			})
		end
	end
end

GluaNetCmd[hVar.ONLINECMD.NEW_LOGIN_RES] = function(protocol,errcode,isbind,uid,rid,nickname,itag,reconnection,password,imaccmp,serverdic,snapshotid,datanum,...)
	print("hVar.ONLINECMD.NEW_LOGIN_RES",errcode,isbind,uid,rid,nickname)
	if (errcode == 0) or (errcode == 200) then --0:登录成功/200:重复登录成功
		--标记是登录状态
		g_cur_login_state = 1
		
		xlSaveIntToKeyChain("cheatflag",0) -- 其实不用存 安卓必须联网 多写了
		g_guest_bind = isbind
		--local args = {...}
		GluaNetCmd[hVar.ONLINECMD.LOGIN](protocol,uid,rid,errcode,nickname,reconnection,itag,password,imaccmp,serverdic,snapshotid,datanum,...)
		hGlobal.event:event("Lua_ReNameFrm",0)
		hGlobal.event:event("Lua_BindOrNotFrm",0)
		--hGlobal.event:event("LocalEvent_shownewlualoginFrm",0)
		hGlobal.event:event("LocalEvent_ShowChannelLoginFrm",0)
		local oWorld =  hGlobal.LocalPlayer:getfocusworld()
		if oWorld == nil then
			oWorld = hGlobal.LocalPlayer:getfocusmap()
		end
		--在快速登录的按钮上已强制绑定
		--if g_guest_bind == 0 and LuaGetPlayerMapAchi("world/level_xsnd",hVar.ACHIEVEMENT_TYPE.LEVEL) == 1 and oWorld and oWorld.data.map == hVar.PHONE_MAINMENU then
			--hGlobal.UI.MsgBox(hVar.tab_string["no_bind_warring"],{
				--textFont = hVar.FONTC,
				--ok = function()
				--end,
			--})
		--end
	elseif (errcode == 199) then --重复RELOGIN
		--取消挡操作
		hUI.NetDisable(0)
		
		--标记是登录状态
		g_cur_login_state = 1
		
		--清除重连检测timer
		hApi.clearTimer("__Android_HEART_BEAT")
		
		--...
	elseif (errcode == 200) then --重复LOGIN
		--取消挡操作
		hUI.NetDisable(0)
		
		--标记是登录状态
		--g_cur_login_state = 1
		
		--清除重连检测timer
		hApi.clearTimer("__Android_HEART_BEAT")
		
		--登出
		local uid = xlPlayer_GetUID()
		GluaSendNetCmd[hVar.ONLINECMD.CMD_LOGIN_OUT](uid)
		
		--冒字
		--"登入超时"
		local strText = hVar.tab_string["__TEXT__AccountTip5"]
		hUI.floatNumber:new({
			x = hVar.SCREEN.w / 2,
			y = hVar.SCREEN.h / 2,
			align = "MC",
			text = "",
			lifetime = 2000,
			fadeout = -550,
			moveY = 32,
		}):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)
	elseif (errcode == 201) then --重复RELOGIN2
		--取消挡操作
		hUI.NetDisable(0)
		
		--标记是登录状态
		g_cur_login_state = 1
		
		--清除重连检测timer
		hApi.clearTimer("__Android_HEART_BEAT")
		
		--...
	elseif (errcode == 222) then --多处登陆
		--多处登陆的上一次登陆的ip（仅登陆失败 错误码222有数据）
		local args = {...}
		local last_ip = ""
		if type(args[datanum * 2 + 8]) == "string" then
			last_ip = args[datanum * 2 + 8]
		end
		
		--多处登陆的上一次登陆的port（仅登陆失败 错误码222有数据）
		local last_port = ""
		if type(args[datanum * 2 + 9]) == "number" then
			last_port = args[datanum * 2 + 9]
		end
		
		print("last_ip=", last_ip)
		print("last_port=", last_port)
		
		--修改本地ip和port
		local gs = Game_Server
		local gsd = gs.Data
		gsd.ip = last_ip
		gsd.port = last_port
		
		--断开连接并再次connect
		Game_Server:Close()
		Game_Server:Connect()
		
		--尝试再次登录
		--g_lastPtable = {t_type,uid," ",nil,g_isReconnection}
		--GluaSendNetCmd[hVar.ONLINECMD.NEW_LOGIN](t_type,uid," ",nil,g_isReconnection)
		if (type(g_lastPtable) == "table") then
			local t_type = g_lastPtable[1]
			local uid = g_lastPtable[2]
			GluaSendNetCmd[hVar.ONLINECMD.NEW_LOGIN](t_type,uid," ",nil,g_isReconnection)
		else
			--冒字
			--"登入超时"
			local strText = hVar.tab_string["__TEXT__AccountTip5"]
			hUI.floatNumber:new({
				x = hVar.SCREEN.w / 2,
				y = hVar.SCREEN.h / 2,
				align = "MC",
				text = "",
				lifetime = 2000,
				fadeout = -550,
				moveY = 32,
			}):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)
		end
	else
		local text = hVar.tab_string["__TEXT_WanJia"].."ID:"..uid.."\n"
		if errcode == 30 then
			--防止未收到协议 没清理
			LuaDelCheatLog()
			--作弊标志保存到本地
			xlSaveIntToKeyChain("cheatflag",1) -- 其实不用存 安卓必须联网 多写了
			text = text..hVar.tab_string["__TEXT_cheatPlayer"]
		else
			text = text..hVar.tab_string["request_errcode"]..errcode
		end
		if hApi.IsReviewMode() then
			text = hVar.tab_string["admin&password_err"]
		end
		
		hGlobal.UI.MsgBox(text,{
			font = hVar.FONTC,
			ok = function()
				if hApi.IsReviewMode() then
				else
					xlExit()
				end
			end,
		})
	end
end

--安卓游戏里重新登录回调
GluaNetCmd[hVar.ONLINECMD.NEW_RE_LOGIN_RES] = function(protocol,errcode,isbind,uid,rid,nickname,itag,reconnection,password,imaccmp,serverdic,snapshotid,datanum,...)
	print("重新登录回调:",protocol,"errcode="..tostring(errcode),"isbind="..tostring(isbind),"uid="..tostring(uid),"rid="..tostring(rid),"nickname="..tostring(nickname),"itag="..tostring(itag),"reconnection="..tostring(reconnection),"password="..tostring(password),imaccmp,serverdic,"snapshotid="..tostring(snapshotid),"datanum="..tostring(datanum), "\n")
	
	--隐藏菊花
	hUI.NetDisable(0)
	
	if (errcode == 0) then --成功
		--标记是登录状态
		g_cur_login_state = 1
		
		--清除重连检测timer
		hApi.clearTimer("__Android_HEART_BEAT")
		
		--获取服务器版本控制信息
		SendCmdFunc["get_version_control"]()
		
		--隐藏安卓重连的框
		hGlobal.event:event("LocalEvent_showAndroidNetAlreadyFrm", 0)
	else
		--local text = hVar.tab_string["__TEXT_WanJia"].."ID:"..uid.."\n"
		--错误信息
		local errmsg = ""
		
		if (errcode == 30) then
			--标记是异常重连状态
			g_isLoginException = 1
			--隐藏重连界面
			hGlobal.event:event("LocalEvent_showAndroidNetAlreadyFrm",0)
			
			--防止未收到协议 没清理
			LuaDelCheatLog()
			--作弊标志保存到本地
			xlSaveIntToKeyChain("cheatflag",1) -- 其实不用存 安卓必须联网 多写了
			--text = text..hVar.tab_string["__TEXT_cheatPlayer"]
			errmsg = hVar.tab_string["__TEXT_ChestLoginFail"] --"您的账号异常，禁止登录"
			
			--通知重连失败事件
			hGlobal.event:event("LocalEvent_ReLoginFailEvent", errcode, errmsg)
			
			--[[
			--断开pvp，group连接
			Pvp_Server:Close()
			Group_Server:Close()
			]]
			
			--弹框退出
			hGlobal.UI.MsgBox(errmsg,{
				font = hVar.FONTC,
				ok = function()
					xlExit()
				end,
			})
		elseif (errcode == 2) then --版本太旧
			--标记是异常重连状态
			g_isLoginException = 1
			--隐藏重连界面
			hGlobal.event:event("LocalEvent_showAndroidNetAlreadyFrm",0)
			
			errmsg = hVar.tab_string["__TEXT_VersionTooOldUpdate"] --"您的版本太老，已无法使用当前功能，请更新至最新版本！"
			
			--通知重连失败事件
			hGlobal.event:event("LocalEvent_ReLoginFailEvent", errcode, errmsg)
			
			--[[
			--断开pvp，group连接
			Pvp_Server:Close()
			Group_Server:Close()
			]]
			
			--弹框退出
			hGlobal.UI.MsgBox(errmsg,{
				font = hVar.FONTC,
				ok = function()
					xlExit()
				end,
			})
		elseif (errcode == 201) then --重登录才有的返回值，当前连接已经是登录状态，不需要重登
			--标记是登录状态
			g_cur_login_state = 1
			
			--标记不是异常重连状态
			g_isLoginException = 0
			
			--清除重连检测timer
			hApi.clearTimer("__Android_HEART_BEAT")
			
			--获取服务器版本控制信息
			SendCmdFunc["get_version_control"]()
			
			--隐藏安卓重连的框
			hGlobal.event:event("LocalEvent_showAndroidNetAlreadyFrm", 0)
		elseif (errcode == 202) then --重登录才有的返回值，当前uid已经是登录状态，不需要重登
			--标记是登录状态
			g_cur_login_state = 1
			
			--标记不是异常重连状态
			g_isLoginException = 0
			
			--清除重连检测timer
			hApi.clearTimer("__Android_HEART_BEAT")
			
			--获取服务器版本控制信息
			SendCmdFunc["get_version_control"]()
			
			--隐藏安卓重连的框
			hGlobal.event:event("LocalEvent_showAndroidNetAlreadyFrm", 0)
		elseif (errcode == 203) then --重登录才有的返回值，服务器标记需要强制覆盖存档
			--标记是异常重连状态
			g_isLoginException = 1
			--隐藏重连界面
			hGlobal.event:event("LocalEvent_showAndroidNetAlreadyFrm",0)
			
			errmsg = hVar.tab_string["__TEXT__AccountTip4"] --"请您重新登录"
			
			--通知重连失败事件
			hGlobal.event:event("LocalEvent_ReLoginFailEvent", errcode, errmsg)
			
			--[[
			--断开pvp，group连接
			Pvp_Server:Close()
			Group_Server:Close()
			]]
			
			--弹框退出
			hGlobal.UI.MsgBox(errmsg,{
				font = hVar.FONTC,
				ok = function()
					xlExit()
				end,
			})
		elseif (errcode == 204) then --重登录才有的返回值，已在其它设备登录
			--标记是异常重连状态
			g_isLoginException = 1
			--隐藏重连界面
			hGlobal.event:event("LocalEvent_showAndroidNetAlreadyFrm",0)
			
			errmsg = hVar.tab_string["__TEXT__AccountTip3"] --"您的账号已在其他设备登录"
			
			--通知重连失败事件
			hGlobal.event:event("LocalEvent_ReLoginFailEvent", errcode, errmsg)
			
			--[[
			--断开pvp，group连接
			Pvp_Server:Close()
			Group_Server:Close()
			]]
			
			--弹框退出
			hGlobal.UI.MsgBox(errmsg,{
				font = hVar.FONTC,
				ok = function()
					xlExit()
				end,
			})
		elseif (errcode == 222) then --重登录才有的返回值，多处登陆
			--标记是异常重连状态
			g_isLoginException = 1
			--隐藏重连界面
			hGlobal.event:event("LocalEvent_showAndroidNetAlreadyFrm",0)
			
			errmsg = hVar.tab_string["__TEXT__AccountTip3"] --"您的账号已在其他设备登录"
			
			--通知重连失败事件
			hGlobal.event:event("LocalEvent_ReLoginFailEvent", errcode, errmsg)
			
			--[[
			--断开pvp，group连接
			Pvp_Server:Close()
			Group_Server:Close()
			]]
			
			--弹框退出
			hGlobal.UI.MsgBox(errmsg,{
				font = hVar.FONTC,
				ok = function()
					xlExit()
				end,
			})
		elseif (errcode == 223) then --重登录才有的返回值，曾经多处登陆
			--标记是异常重连状态
			g_isLoginException = 1
			--隐藏重连界面
			hGlobal.event:event("LocalEvent_showAndroidNetAlreadyFrm",0)
			
			errmsg = hVar.tab_string["__TEXT__AccountTip4"] --"请您重新登录"
			
			--通知重连失败事件
			hGlobal.event:event("LocalEvent_ReLoginFailEvent", errcode, errmsg)
			
			--[[
			--断开pvp，group连接
			Pvp_Server:Close()
			Group_Server:Close()
			]]
			
			--弹框退出
			hGlobal.UI.MsgBox(errmsg,{
				font = hVar.FONTC,
				ok = function()
					xlExit()
				end,
			})
		else
			--标记是异常重连状态
			g_isLoginException = 1
			--隐藏重连界面
			hGlobal.event:event("LocalEvent_showAndroidNetAlreadyFrm",0)
			
			errmsg = hVar.tab_string["request_errcode"] .. tostring(errcode)
			
			--通知重连失败事件
			hGlobal.event:event("LocalEvent_ReLoginFailEvent", errcode, errmsg)
			
			--[[
			--断开pvp，group连接
			Pvp_Server:Close()
			Group_Server:Close()
			]]
			
			--弹框退出
			hGlobal.UI.MsgBox(errmsg,{
				font = hVar.FONTC,
				ok = function()
					xlExit()
				end,
			})
		end
	end
end

GluaNetCmd[hVar.ONLINECMD.NEW_REGISTER_RES] = function(protocol,errcode,t_type,uid,name,password)
	g_reg_ans = 1
	if errcode == 0 then
		if t_type == 0 then
			hGlobal.event:event("LocalEvent_getANewGuestRes",uid,name,password)
		else
			hGlobal.event:event("LocalEvent_NewOtherPlantForm",t_type,uid)
		end
	else
		hGlobal.event:event("LocalEvent_ResetVerticalLoginBtn")
		local strText = "hVar.ONLINECMD.NEW_REGISTER_RES , errcode "..errcode.." , t_type "..t_type.." , uid "..uid
		hGlobal.UI.MsgBox(strText, {
			font = hVar.FONTC,
			ok = function()
				
			end,
		})
	end
end

GluaNetCmd[hVar.ONLINECMD.BIND_PLANTFORM_RES] = function(protocol,errcode)
	if errcode == 0 then
		hGlobal.event:event("Lua_ReNameFrm",0)
		hGlobal.event:event("Lua_BindOrNotFrm",0)
		hGlobal.event:event("LocalEvent_BindRes")
	elseif errcode == 40 then
	elseif errcode == 41 then
		hGlobal.UI.MsgBox(hVar.tab_string["bangdingnot"],
		{
			font = hVar.FONTC,
			ok = function()
			end,
		})
	end
end

GluaNetCmd[hVar.ONLINECMD.BIND_PLANTFORM_OLD_RES] = function(protocol,errcode,channelid,uid,t_type)
	--print("PLANTFORM_ASK_RES",protocol,errcode,t_type,account,num,...)
		
	if errcode == 0 then
		hGlobal.event:event("LocalEvent_set_BIND_PLANTFORM_OLD_RES",t_type)
	elseif errcode == 100 then
		hGlobal.UI.MsgBox(hVar.tab_string["check_in_err24"],
		{
			font = hVar.FONTC,
			ok = function()
			end,
		})
	end
end

GluaNetCmd[hVar.ONLINECMD.UNBIND_PLANTFORM_RES] = function(protocol,errcode,uid,reg_type,account)
	hUI.NetDisable(0)
	if errcode == 0 then
--		local strText = "success|" .. tostring(uid).."|"..tostring(reg_type)
--		hUI.floatNumber:new({
--			x = hVar.SCREEN.w / 2,
--			y = hVar.SCREEN.h / 2,
--			align = "MC",
--			text = "",
--			lifetime = 1000,
--			fadeout = -550,
--			moveY = 32,
--		}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
		if hApi.FileExists(g_localfilepath.."account_antologin.cfg","full") == true then
			xlDeleteFileWithFullPath(g_localfilepath.."account_antologin.cfg")
		end
		g_AccountAutoLogin = nil
		local ntype = tonumber(reg_type)
		if ntype == 44 then
			g_phonelogin = nil
			if hApi.FileExists(g_localfilepath.."phonelogin.cfg","full") then
				xlDeleteFileWithFullPath(g_localfilepath.."phonelogin.cfg")
			end
		elseif ntype == 40 then
			g_ioslogin = nil
			if hApi.FileExists(g_localfilepath.."ioslogin.cfg","full") then
				xlDeleteFileWithFullPath(g_localfilepath.."ioslogin.cfg")
			end
		elseif ntype == 1 then
			g_wxlogin = nil
			if hApi.FileExists(g_localfilepath.."wxlogin.cfg","full") then
				xlDeleteFileWithFullPath(g_localfilepath.."wxlogin.cfg")
			end
		elseif ntype == 2 then
			g_qqlogin = nil
			if hApi.FileExists(g_localfilepath.."qqlogin.cfg","full") then
				xlDeleteFileWithFullPath(g_localfilepath.."qqlogin.cfg")
			end
		end
		hGlobal.event:event("LocalEvent_DeleteAccountSuccess")
	else
		local strText = hVar.tab_string["request_errcode"] .. tostring(errcode)
		hUI.floatNumber:new({
			x = hVar.SCREEN.w / 2,
			y = hVar.SCREEN.h / 2,
			align = "MC",
			text = "",
			lifetime = 1000,
			fadeout = -550,
			moveY = 32,
		}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
	end
end

GluaNetCmd[hVar.ONLINECMD.GET_INFO_AFTER_LOGIN_RES] = function(protocol,configinfo)
	print("hVar.ONLINECMD.GET_INFO_AFTER_LOGIN_RES")
	--print(protocol,configinfo)
	hApi.ReadOBConfig(configinfo)
	hGlobal.event:event("LocalEvent_UndateUIafterOBConfig")
end

--战术技能卡获取
GluaNetCmd[hVar.ONLINECMD.CMD_LOADSKILL_RES] = function(protocol,errcode,uid,rid,skill)

end

--战术技能卡更新
GluaNetCmd[hVar.ONLINECMD.CMD_UPDATESKILL_RES] = function(protocol,errcode,uid,rid)
	
end

--分解材料获取
GluaNetCmd[hVar.ONLINECMD.CMD_LOADMATERIAL_RES] = function(protocol,errcode,uid,rid,material)
	
end

--分解材料更新返回
GluaNetCmd[hVar.ONLINECMD.CMD_UPDATEMATERIAL_RES] = function(protocol,errcode,uid,rid)
	
end

--读取服务器上的keyChain
GluaNetCmd[hVar.ONLINECMD.CMD_LOAD_KEYCHAIN_RES] = function(protocol,errcode,uid,rid,keychain)
	if errcode == 0 then
		xlSetKeyChinaVal("IU",keychain)
		xlSetKeyChinaVal("MU",keychain)
	else
		print("CMD_LOAD_KEYCHAIN_RES ERRCODE 0")
	end
end

--更新服务器上的keyChain
GluaNetCmd[hVar.ONLINECMD.CMD_UPDATE_KEY_CHAIN_RES] = function(protocol,errcode,uid,rid)
end


--如果开启了活动服务，这里可以直接收到
local __AnalyzeActivitiesFromServer = function(id,tickLeft,content)
	if id==100 then
		-- 100:青铜箱子中的装备掉率
		local cTab = hApi.ReadNumberFromString(content)
		if cTab and #cTab>=3 then
			hVar.tab_drop.init("copper_box",cTab)
		end
	elseif id==101 then
		-- 101:白银箱子中的装备掉率
		local cTab = hApi.ReadNumberFromString(content)
		if cTab and #cTab>=3 then
			hVar.tab_drop.init("silver_box",cTab)
		end
	elseif id==102 then
		-- 102:黄金箱子中的装备掉率
		local cTab = hApi.ReadNumberFromString(content)
		if cTab and #cTab>=3 then
			hVar.tab_drop.init("gold_box",cTab)
		end
	end
end

local __UpdateTopupGiftItem = function(id,tickLeft,content)
	local itemID = 0
	local itemNum = 1
	local score = 0
	if id == 1030 or id == 1031 or  id == 1032 or id == 1033 or id == 1034 or id == 1035 or id == 1036 then
		--如果是新的格式
		if string.find(content,"i:") ~= nil and string.find(content,"s:") then
			local tempState = {}
			for content in string.gfind(content,"([^%;]+);+") do
				tempState[#tempState+1] = content
			end
			itemID = tonumber(string.sub(tempState[1],string.find(content,"i:")+2,string.len(tempState[1])))
			score = tonumber(string.sub(tempState[2],string.find(content,"s:")+2,string.len(tempState[2])))
		
		--老格式
		elseif string.find(content,"i:") ~= nil then
			itemID = tonumber(string.sub(content,string.find(content,"i:")+2,string.find(content,"n:")-1))
		end
	end

	--首充奖励6
	if id == 1030 then
		g_TopupGiftItemList[1] = {itemID,itemNum,score}
	--18
	elseif id == 1031 then
		g_TopupGiftItemList[2] = {itemID,itemNum,score}
	--45
	--elseif id == 1032 then
		--g_TopupGiftItemList[3] = {itemID,itemNum,score}
	--68
	elseif id == 1033 then
		g_TopupGiftItemList[3] = {itemID,itemNum,score}
	--98
	elseif id == 1034 then
		g_TopupGiftItemList[4] = {itemID,itemNum,score}
	--198 
	elseif id == 1035 then
		g_TopupGiftItemList[5] = {itemID,itemNum,score}
	--388
	elseif id == 1036 then
		g_TopupGiftItemList[6] = {itemID,itemNum,score}
	end
end

--刷新活动相关信息 list:   (id int)/(valid int)/(content string)
GluaNetCmd[hVar.ONLINECMD.CMD_ACTIVITY_INFO_RES] = function(protocol,errcode,num,...)
	local args = {...}
	if errcode == 0 then
		local activity_list = {}
		for i = 1,#args,3 do
			local id, leftTimsInSec, content = args[i],args[i+1],args[i+2]
			__AnalyzeActivitiesFromServer(id, leftTimsInSec, content)
			--白银宝箱活动
			if id == 200 then
				
			elseif id == 201 then
				
			elseif id == 1310 then
				--刷新礼品按钮
				local state = -1
				if tonumber(content) == 0 then
					state = -1
				elseif tonumber(content) == 1 then
					state = 1
				end
				
				hGlobal.event:event("LocalEvent_Setbtn_compensate",state)
			elseif id == 304 then
				--设置积分和游戏币 lab
				if string.find(content,"c:") and string.find(content,"s:") then
					local rmb = string.sub(content,string.find(content,"c:")+2,string.find(content,"s:")-2)
					local score = 0
					score  = SendCmdFunc["Tool_string2socre"](content)
					activity_list[#activity_list+1] = {id = id,index = 3,itemID = 9005,score =tonumber(score),rmb = tonumber(rmb)}
				end
			elseif id == 305 then
				--设置积分和游戏 lab
				if string.find(content,"c:") and string.find(content,"s:") then
					local rmb = string.sub(content,string.find(content,"c:")+2,string.find(content,"s:")-2)
					local score = 0
					score  =SendCmdFunc["Tool_string2socre"](content)
					activity_list[#activity_list+1] = {id = id,index = 5,itemID = 9006,score =tonumber(score),rmb = tonumber(rmb)}
				end

			elseif id == 306 then
				--设置炎晶 游戏币
				if string.find(content,"c:") and string.find(content,"s:") then
					local rmb = string.sub(content,string.find(content,"c:")+2,string.find(content,"s:")-2)
					local score = 0
					score  =SendCmdFunc["Tool_string2socre"](content)
					activity_list[#activity_list+1] = {id = id,index = 6,itemID = 9009,score =tonumber(score),rmb = tonumber(rmb)}
				end
			elseif id == 307 then
				if string.find(content,"c:") and string.find(content,"s:") then
					local rmb = string.sub(content,string.find(content,"c:")+2,string.find(content,"s:")-2)
					local score = 0
					score  =SendCmdFunc["Tool_string2socre"](content)
					activity_list[#activity_list+1] = {id = id,index = 7,itemID = 9101,score =tonumber(score),rmb = tonumber(rmb)}
				end
			elseif id == 308 then
				if string.find(content,"c:") and string.find(content,"s:") then
					local rmb = string.sub(content,string.find(content,"c:")+2,string.find(content,"s:")-2)
					local score = 0
					score  =SendCmdFunc["Tool_string2socre"](content)
					activity_list[#activity_list+1] = {id = id,index = 9,itemID = 9102,score =tonumber(score),rmb = tonumber(rmb)}
				end

			elseif id == 303 then
				--商店左上角的显示
				if type(content) == "string" then
					local tempStr = {}
					for content in string.gfind(content,"([^%;]+);+") do
						tempStr[#tempStr+1] = content
					end
					local ShopItemID,ShopItemState,ShopItemPrice = 0,0,0
					for i = 1,#tempStr do
						if string.find(tempStr[i],"i:") and string.find(tempStr[i],"t:") and string.find(tempStr[i],"p:") then
							ShopItemID = string.sub(tempStr[i],string.find(tempStr[i],"i:")+2,string.find(tempStr[i],"t")-1)
							ShopItemState = string.sub(tempStr[i],string.find(tempStr[i],"t:")+2,string.find(tempStr[i],"t:")+2)
							ShopItemPrice = string.sub(tempStr[i],string.find(tempStr[i],"p:")+2,string.len(tempStr[i]))

							activity_list[#activity_list+1] = {id = 303,ShopItemID = tonumber(ShopItemID),ShopItemState = tonumber(ShopItemState),ShopItemPrice = tonumber(ShopItemPrice)}
						end
					end
				else
					print("303","erro")
				end
			end

			--刷新 首充奖励界面的奖品信息
			__UpdateTopupGiftItem(id, leftTimsInSec, content)
			--刷新 每日奖励 扣除的积分信息
			if id == 9 then
				if string.find(content,"s:") ~= nil then
					local score = SendCmdFunc["Tool_string2socre"](content)
					g_DailyRewardScore = math.abs(tonumber(score))
				end
				if string.find(content,"c:") ~= nil then
					local coin = string.sub(content,string.find(content,"c:")+2,string.find(content,"s:")-2)
					g_DailyRewardCoin = math.abs(tonumber(coin))
				end
			end

			if id == 5000 then
				if string.find(content,"s:") ~= nil then
					local score = SendCmdFunc["Tool_string2socre"](content)
					g_DailyRewardScore_m = math.abs(tonumber(score))
				end
				if string.find(content,"c:") ~= nil then
					local coin = string.sub(content,string.find(content,"c:")+2,string.find(content,"s:")-2)
					g_DailyRewardCoin_m = math.abs(tonumber(coin))
				end
			end
			
			--每周将星数据
			if id == 1500 then
				g_HeroWeekStar = {}
				--解析将星字段， id == 英雄ID，
				local heroID = 0
				local odds = 0
				if string.find(content,"id:") ~= nil then
					heroID = tonumber(string.sub(content,string.find(content,"id:")+3,string.find(content,";")-1))
					odds = tonumber(string.sub(content,string.find(content,"ps:")+3,string.len(content)))
					g_HeroWeekStar[#g_HeroWeekStar+1] = {heroID,odds}
				end
				--安卓先保存数据  不直接弹  点击剧情战役和娱乐关卡才会弹 且只弹一次
				--hGlobal.event:event("LocalEvent_showweekstarherofrm",g_HeroWeekStar)
			end
		end
		hGlobal.event:event("LocalEvent_Set_activity_list",activity_list)
	end

end

--检测字符串中是否有材料信息
local _constStrList = {"m1:","m2:","m3:"}
local _constStrList2 = {29,30,31}
local _checkMatSByString = function(str)
	for i = 1,#_constStrList do
		if type(string.find(str,_constStrList[i])) == "number" then
			return _constStrList2[i],tonumber(string.sub(str,4,string.len(str)))
		end
	end
	return nil,nil
end

--解析字符串函数
local _analyzeStr = function(pStrTab,ptab)
	for i = 1,#pStrTab do
		--道具信息
		if type(string.find(pStrTab[i],"i:")) == "number" then
			ptab[#ptab+1] = {
				"item",
				tonumber(string.sub(pStrTab[i],string.find(pStrTab[i],"i:")+2,string.len(pStrTab[i]))),			--道具ID
				tonumber(string.sub(pStrTab[i+2],string.find(pStrTab[i+2],"h:")+2,string.len(pStrTab[i+2]))),		--道具孔数
			}
		--战术卡信息
		elseif type(string.find(pStrTab[i],"bfs:")) == "number" then
			ptab[#ptab+1] = {
				"card",
				tonumber(string.sub(pStrTab[i],string.find(pStrTab[i],"bfs:")+4,string.find(pStrTab[i],"lv:")-1)),	--卡牌ID
				tonumber(string.sub(pStrTab[i],string.find(pStrTab[i],"lv:")+3,string.len(pStrTab[i]))),		--卡牌等级
			}
		--英雄令
		elseif type(string.find(pStrTab[i],"ID:")) == "number" then
			ptab[#ptab+1] = {
				"hero",
				tonumber(string.sub(pStrTab[i],string.find(pStrTab[i],"ID:")+3,string.len(pStrTab[i]))),
			}
		--积分
		elseif type(string.find(pStrTab[i],"s:")) == "number" then
			ptab[#ptab+1] = {
				"score",
				25,
				tonumber(string.sub(pStrTab[i],string.find(pStrTab[i],"s:")+2,string.len(pStrTab[i]))),
			}
		--金币
		elseif type(string.find(pStrTab[i],"c:")) == "number" then
			ptab[#ptab+1] = {
				"coin",
				27,
				tonumber(string.sub(pStrTab[i],string.find(pStrTab[i],"c:")+2,string.len(pStrTab[i]))),
			}
		--锻造材料信息
		else
			local matType,num = _checkMatSByString(pStrTab[i])
			if matType ~= nil and num ~= nil then
				ptab[#ptab+1] = {
					"mat",
					matType,		--卡牌ID
					num,			--卡牌等级
				}
			end
		end
	end
end

--返回4043结果
GluaNetCmd[hVar.ONLINECMD.CMD_GET_GIFT_REWARD_RES] = function(protocol,errcode,uid,rid,key,content,ptype)
	if errcode == 0 then
		local tempStr = {}
		for v in string.gfind(content,"([^%;]+);+") do
			tempStr[#tempStr+1]= v
		end
		local giftList = {}
		
		--游戏币
		if ptype == 0 then
			giftList[#giftList+1] = {"coin",27,tonumber(content),}
		--积分
		elseif ptype == 1 then
			giftList[#giftList+1] = {"score",25,tonumber(content),}
		else
			--解析字符串
			_analyzeStr(tempStr,giftList)
		end
		
		--再次查询游戏币
		--获取体力数据
		SendCmdFunc["get_mycoin"]()
		
		hGlobal.event:event("LocalEvent_BuyGiftItem",giftList,nil,2)
		--增加积分  保险起见  不在LocalEvent_BuyGiftItem中添加 因为这个监听用的地方较多  防止出错 加了两份
		hGlobal.event:event("LocalEvent_BuyGiftAddScore",giftList)
		GluaSendNetCmd[hVar.ONLINECMD.CMD_GET_GIFT_CONFIRM](uid,rid,key)
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
	else
		print("USED "..errcode)
		local sText = ""
		if errcode == 1 then--
			sText = hVar.tab_string["gift_err_cannot_use"]
		elseif errcode == 22 then--礼品码不存在
			sText = hVar.tab_string["gift_err_not_exist"]
		elseif errcode == 2 then
			sText = hVar.tab_string["gift_err_only_use_once"]
		else
			sText = hVar.tab_string["ios_error"]..errcode
		end
		--local frm=hGlobal.UI.SystemMenuNewExFram
		
		--冒字
		hUI.floatNumber:new({
			x = hVar.SCREEN.w / 2,
			y = hVar.SCREEN.h / 2,
			align = "MC",
			text = "",
			lifetime = 2000,
			fadeout = -550,
			moveY = 32,
		}):addtext(sText, hVar.FONTC, 32, "MC", 0, 0,nil,1)
	end
end


----4100返回上传数据后的返回 order 上传的本地存档计数器
--GluaNetCmd[hVar.ONLINECMD.CMD_SEND_GAME_DATA_RES] = function(protocol,errcode,uid,rid,order)
--	if errcode == 0 then
--		local cur_count = xlGetUIDSaveCount()
--		if order == cur_count then
--			for k,v in pairs(hVar.DATA_SEND_STATE) do
--				local state = xlGetDateSendState(v)
--				--为0代表可以清除本地缓存
--				if state == 0 then
--					if hApi.FileExists(g_localfilepath..tostring(uid).."_"..hVar.SAVE_DATA_PATH[k],"full") == true then
--						--xlDeleteFileWithFullPath(g_localfilepath..tostring(uid).."_"..hVar.SAVE_DATA_PATH[k],"full")
--					end
--				end
--			end
--		end
--	end
--end

--4100返回上传数据后的返回 snapshotID 上传的本地存档计数器
GluaNetCmd[hVar.ONLINECMD.CMD_SAVE_NEWDIC_RES] = function(protocol,errcode,uid,rid,snapshotID)
	hUI.NetDisable(0)
	
	print("SAVE_NEWDIC_RES 结果, errorcode=", errcode,uid,rid,snapshotID)
	
	if errcode == 0 then
		--[[
		local cur_count = xlGetUIDSaveCount()
		if snapshotID == cur_count then
			for k,v in pairs(hVar.DATA_SEND_STATE) do
				local state = xlGetDateSendState(v)
				--为0代表可以清除本地缓存
				if state == 0 then
					if hApi.FileExists(g_localfilepath..tostring(uid).."_"..hVar.SAVE_DATA_PATH[k],"full") == true then
						--xlDeleteFileWithFullPath(g_localfilepath..tostring(uid).."_"..hVar.SAVE_DATA_PATH[k],"full")
					end
				end
			end
		end
		]]
		--管理员可查看日志
		hGlobal.event:event("localEvent_SaveDataChangeLog", {
			time = os.date("%Y-%m-%d %H:%M:%S", os.time()),
			content = "存档成功！ snapshotID:" .. snapshotID,
			color = {255, 255, 192,},
		})
		
		--设置本地的存档号
		--xlPlayer_SetSnapShotID(uid, snapshotID)
	end
end

--返回4104 dic info信息
GluaNetCmd[hVar.ONLINECMD.CMD_LOAD_DICINFO_RES] = function(protocol,errcode,uid,rid,order,num,...)
	local args = {...}
	if errcode == 0 then
		hApi.FormatSaveDataByStr(num,args)
		hUI.NetDisable(0)
	else
		hGlobal.UI.MsgBox("LOAD DATA ERROR \n"..hVat.tab_string["["]..tostring(uid)..hVat.tab_string["]"]{
			font = hVar.FONTC,
			ok = function() xlExit() end,
		})
	end
end

--修改密码的返回
GluaNetCmd[hVar.ONLINECMD.CMD_RESETPASSWORD_RES] = function(protocol,errcode,uid,password)
	if errcode == 0 then
		--更新游客UID
		if uid == g_guest_uid then
			local str = "g_guest_uid = "..uid.." g_guest_name = ".."\""..g_guest_name.."\" g_guest_pw = ".."\""..password.."\" g_guest_head = \"def\" g_guest_bind = 1"
			xlSaveGameData(g_localfilepath.."new_guest.cfg",str)
			hApi.SaveGuestInfo_IOS()
		end
		hGlobal.event:event("LocalEvent_SetUidPassWord",0)
		hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_SetPassWordRs_1"],{
			font = hVar.FONTC,
			ok = function()
			end,
		})
	else
		hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_SetPassWordRs_2"],{
			font = hVar.FONTC,
			ok = function()
			end,
		})
	end
end

--心跳包回执
GluaNetCmd[hVar.ONLINECMD.CMD_HEART_BEAT_RES] = function(protocol,uid,itag)
	--当itag不为0时需要做特殊处理
	if itag~= 0 then
		hApi.clearTimer("__Android_HEART_BEAT")
		
		--隐藏安卓重连的框
		--hGlobal.event:event("LocalEvent_showAndroidNetAlreadyFrm", 0)
		
		--geyachao: 检测是否需要游戏内重连
		if (g_cur_net_state == 1) then --连接状态
			if (g_cur_login_state ~= 1) then --不是登录状态
				if (g_isReconnection == 1) then --重连状态
					local t_type,uid,pass,itag,reconnection = unpack(g_lastPtable)
					--print(g_lastPid,t_type,uid,pass,itag,reconnection)
					GluaSendNetCmd[hVar.ONLINECMD.NEW_RE_LOGIN](t_type,uid,pass,itag,g_isReconnection) --游戏内重连
				end
			end
		end
		
		hUI.NetDisable(0)
	end
end

--预留
GluaNetCmd[hVar.ONLINECMD.BIND_REALNAMEINFO_RES] = function(protocol,errcode,nTotalDay)
	print("hVar.ONLINECMD.BIND_REALNAMEINFO_RES")
	hUI.NetDisable(0)
	if errcode == 0 then
		local nResult = hApi.CheckPlayerAge(nTotalDay)
		--如果检测为1 说明不受限制 直接登录
		if nResult == 1 then
			--审核模式的登陆回调
			hGlobal.event:event("LocalEvent_OnReviewlogin")
		end
	else
		--未知错误直接弹框退出游戏
		hGlobal.UI.MsgBox(hVar.tab_string["errcode"]..":"..errcode,{
			font = hVar.FONTC,
			ok = function()
				xlExit()
			end,
		})
	end
end

--请求游戏时间的返回
GluaNetCmd[hVar.ONLINECMD.REQUEST_PLAYTIME_RES] = function(protocol,errcode,totalday,todaycount,sServerDate)
	hUI.NetDisable(0)
	if errcode == 0 then
		--只有未成年才会收到此回调
		--先判断服务器时间 22.00 - 8.00不能玩  直接退出游戏 sServerDate 年-月-日-时-分-秒
		local _,_,year,month,day,hour,minute,secord = string.find(sServerDate,"(%d+)-(%d+)-(%d+)-(%d+)-(%d+)-(%d+)")
		print("hVar.ONLINECMD.REQUEST_PLAYTIME_RES",sServerDate,year,month,day,hour,minute,secord)
		print("errcode,totalday,todaycount,sServerDate",errcode,totalday,todaycount,sServerDate)
		year = tonumber(year)
		month = tonumber(month)
		day = tonumber(day)
		hour = tonumber(hour)
		minute = tonumber(minute)
		secord = tonumber(secord)
		if hour >= 22 or hour <= 8 then
			--
			hApi.ShowTimeLimitFrm()
			return
		end
		--判断累计时长是否超过上限  超过则弹框退出游戏  没超过则倒计时退出时间
		local limitSecord = 90 * 60		--周1-5 90分钟
		local serverTime = os.time({year = year,month = month, day =day,hour =hour, min =minute, sec = secord})
		local dayinweek = tonumber(os.date("%w",serverTime))
		print("dayinweek",dayinweek)
		if dayinweek == 6 or dayinweek == 0 then			--周末 180分钟
			limitSecord = 180 * 60
		end
		
		local remainingsecord = limitSecord - todaycount * 60
		local limitTime = os.time({year =year, month = month, day =day, hour =22, min =00, sec = 00})

		local toLimitTime = limitTime - serverTime
		if toLimitTime < 0 then
			remainingsecord = 0
		else
			remainingsecord = math.min(remainingsecord,toLimitTime)
		end
		print("remainingsecord",remainingsecord)
		if remainingsecord > 0 then
			hGlobal.event:event("LocalEvent_ShowYoungPlayerWarningFrm")
			--开启倒计时
			hGlobal.event:event("LocalEvent_ShowYoungPlayerCountDownFrm",remainingsecord)
		else
			--弹框退出
			hApi.ShowTimeLimitFrm()
		end
		
	else
		--未知错误直接弹框退出游戏
		hGlobal.UI.MsgBox(hVar.tab_string["errcode"]..":"..errcode,{
			font = hVar.FONTC,
			ok = function()
				xlExit()
			end,
		})
	end
end