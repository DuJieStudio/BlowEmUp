--*************************************************************
-- Copyright (c) 2013, XinLine Co.,Ltd
-- Author: Red
-- Detail: 游戏更新模块
---------------------------------------------------------------

--g_td_mode = 1
local IsTester = CCUserDefault:sharedUserDefault():getIntegerForKey("xl_account_test") --管理员检测

total,free,usedByMe = xlGetMemoryInfo()
print("000000000000 usdmem total:" .. total .. " free:" .. free .. " usedByMe:" .. usedByMe .. " \n")

--TD模式寻路
xlEnableTD(1)

--*************************************************************
-- 防止无资源导致的错误
---------------------------------------------------------------
local __tExistImage = {}
local __IMG = function(sPath)
	if __tExistImage[sPath] then
	elseif xlIsFileExist(sPath)==1 then
		__tExistImage[sPath] = sPath
	elseif CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(sPath) then
		__tExistImage[sPath] = sPath
	else
		__tExistImage[sPath] = "data/image/misc/mask.png"
	end
	return __tExistImage[sPath]
end

--*************************************************************
-- ip5 边框相关函数
---------------------------------------------------------------
local __IMAGE_FILE_PATH__ = "data/image/"
local __Align = {
	["LT"] = {0	,2},
	["MT"] = {1	,2},
	["RT"] = {2	,2},
	["LC"] = {0	,1},
	["MC"] = {1	,1},
	["RC"] = {2	,1},
	["LB"] = {0	,0},
	["MB"] = {1	,0},
	["RB"] = {2	,0},
}
local __FrameModelBasic = {
	name = "UI:TileFrmBasic",
	image = "panel/panel_part_00.png",
	animation = {
		"normal",
		"smart",
		"LT",
		"MT",
		"RT",
		"LC",
		"RC",
		"LB",
		"MB",
		"RB",
	},
	smart = {
		image = "panel/panel_part_00.png",
		[1] = {0,0,256,256},
	},
	normal = {
		image = "panel/panel_part_00.png",
		[1] = {0,0,256,256},
	},
	LT = {
		image = "panel/panel_part_05.png",
		[1] = {0,0,96,96},
	},
	MT = {
		image = "panel/panel_part_01.png",
		[1] = {0,0,48,48},
	},
	RT = {
		image = "panel/panel_part_06.png",
		[1] = {0,0,96,96},
	},
	LC = {
		image = "panel/panel_part_03.png",
		[1] = {0,0,48,48},
	},
	RC = {
		image = "panel/panel_part_04.png",
		[1] = {0,0,48,48},
	},
	LB = {
		image = "panel/panel_part_08.png",
		[1] = {0,0,96,96},
	},
	MB = {
		image = "panel/panel_part_02.png",
		[1] = {0,0,48,48},
	},
	RB = {
		image = "panel/panel_part_07.png",
		[1] = {0,0,96,96},
	},
}
local __FrameStyleBasic = {
	model = "UI:TileFrmBasic",
	image = {
		"LC","RC","MT","MB","LB","RB","LT","RT",
	},
	LT = {0,0},
	RT = {0,0},
	LB = {0,0},
	RB = {0,0},
	LC = {0,0,0,0},
	RC = {0,0,0,0},
	MT = {0,0,0,0},
	MB = {0,0,0,0},
	addBorder = function(self,handleTable,w,h)
		local _parent = handleTable._n
		local LT,RT,LB,RB,LC,RC,MT,MB = self.LT,self.RT,self.LB,self.RB,self.LC,self.RC,self.MT,self.MB
		LT[1],LT[2]		= -24,		24
		RT[1],RT[2]		= w+23,		24
		LB[1],LB[2]		= -24+1,	-1*h-24
		RB[1],RB[2]		= w+23,		-1*h-24

		LC[1],LC[2],LC[3],LC[4] = -30,		-1*h/2,		48,		h-96*2+48
		RC[1],RC[2],RC[3],RC[4] = w+33,		-1*h/2,		48,		h-96*2+48
		MT[1],MT[2],MT[3],MT[4] = w/2,		25,		w-96*2+46+2,	48
		MB[1],MB[2],MB[3],MB[4] = w/2,		-1*h-27,	w-96*2+46,	48

		for i = 1,#self.image do
			local k = self.image[i]
			local v = self[k]
			if v then
				local s = handleTable["_s"..k]
				if s~=nil then
					s:getParent():removeChild(s,true)
				end
				local x,y,iw,ih = v[1],v[2],v[3],v[4]
				local anchor = __Align[k]
				local aCur = __FrameModelBasic[k]
				local pSprite = CCSprite:create(__IMG(__IMAGE_FILE_PATH__..aCur.image))
				handleTable["_s"..k] = pSprite
				pSprite:setPosition(x,y)
				pSprite:setAnchorPoint(ccp(anchor[1]/2,anchor[2]/2))
				if iw and iw>0 then
					pSprite:setScaleX(iw/aCur[1][3])
				end
				if ih and ih>0 then
					pSprite:setScaleY(ih/aCur[1][4])
				end
				handleTable._n:addChild(pSprite,1)
			end
		end
	end,
}
local __CalRepeatCount = function(w,nLength)
	if w<nLength then
		return 0,w
	elseif w>0 and nLength>0 then
		local r = math.mod(w,nLength)
		return math.floor((w-r)/nLength),r
	else
		return 0,0
	end
end
local __CreateFrmBG9 = function(self)
	local h = self.handle
	local d = self.data
	d.w = d.w or 400
	d.h = d.h or 400
	d.bgAlpha = d.bgAlpha or 0

	---------------------------------------
	local tModelS = __FrameModelBasic
	local aBase = __FrameModelBasic.normal
	--local aSmart = __FrameModelBasic.smart
	local _baseX,_baseY = aBase[1][1],aBase[1][2]
	local _baseW,_baseH = aBase[1][3],aBase[1][4]
	local _wRep,_wLeft = __CalRepeatCount(d.w,_baseW)
	local _hRep,_hLeft = __CalRepeatCount(d.h,_baseH)
	local curX,curY = 0,0
	local hRep,hLeft = _hRep,_hLeft

	h._n = CCNode:create()
	h._bn =  CCSpriteBatchNode:create(__IMG(__IMAGE_FILE_PATH__..aBase.image))
	h._n:addChild(h._bn,-1)
	h.s = h._n

	while(hRep>0 or hLeft>0)do
		local baseX,baseY = _baseX,_baseY
		local baseW,baseH = 0,0
		local IsDrawY = 0
		if hRep<=0 and hLeft>0 then
			baseW = _baseW
			baseH = hLeft
			------------
			hLeft = 0
			IsDrawY = 1
		elseif hRep>0 then
			baseW = _baseW
			baseH = _baseH
			------------
			hRep = hRep - 1
			IsDrawY = 1
		end
		if IsDrawY==1 then
			local wRep,wLeft = _wRep,_wLeft
			local curW,curH = 0,0
			while(wRep>0 or wLeft>0)do
				local IsDrawX = 0
				if wRep<=0 and wLeft>0 then
					curW = wLeft
					curH = baseH
					------------
					wLeft = 0
					IsDrawX = 1
				elseif wRep>0 then
					curW = baseW
					curH = baseH
					------------
					wRep = wRep - 1
					IsDrawX = 1
				end
				if IsDrawX==1 then
					--aSmart[1][1],aSmart[1][2] = baseX,baseY
					--aSmart[1][3],aSmart[1][4] = curW,curH
					local s = CCSprite:createWithTexture(h._bn:getTexture(),CCRectMake(baseX,baseY,curW,curH))
					if s~=nil then
						h._bn:addChild(s,0)
						s:setAnchorPoint(ccp(0,1))
						s:setPosition(curX,curY)
						if d.bgAlpha>0 then
							s:setOpacity(math.min(d.bgAlpha,255))
						end
					end
					curX = curX + curW
				end
			end
			curX = 0
			curY = curY - baseH
		end
	end
	--__FrameStyleBasic:addBorder(self.handle,d.w,d.h)
	return h._n
end

--给脚本用的现实公告的接口
local _WebViewState = 0
Lua_xlShowWebView = function(state)
	xlShowWebView(state)
	_WebViewState = state
end

Lua_getWebViewState = function()
	return _WebViewState
end

math.randomseed(os.time())

if LANGUAG_SITTING == nil then
	LANGUAG_SITTING = 1				--语言设置 1按照默认 2简体(强制) 3繁体(强制) 4英语(强制)
end
if VIP_AND_FIRSTTOP_COIN_OR_MONEY == nil then
	VIP_AND_FIRSTTOP_COIN_OR_MONEY = 0		--vip和首冲以游戏币还是钱来统计	0钱(人民币) 1 游戏币
end

language_config = {}
local ttfext = ""
if 3 == CCApplication:sharedApplication():getTargetPlatform() then
	ttfext = ".ttf"
end
language_config[1] = {"默认","DEFAULT","default","coh_2018" .. ttfext,__IMG("data/image/misc/lan_sc.png"),26}
language_config[2] = {"简体中文","DEFAULT","default","coh_2018" .. ttfext,__IMG("data/image/misc/lan_sc.png"),26}
language_config[3] = {"繁体中文","DEFAULT","default","coh_2018" .. ttfext,__IMG("data/image/misc/lan_tc.png"),26}
language_config[4] = {"英语", "EN", "en","coh_2018" .. ttfext,__IMG("data/image/misc/lan_en.png"),26}
language_config[5] = {"日文", "JP", "jp","coh_2018" .. ttfext,__IMG("data/image/misc/lan_jp.png"),26}

g_language_setting = CCUserDefault:sharedUserDefault():getIntegerForKey("xl_language")
--暂时不区分语音 全显示中文
if true then
	if g_language_setting ~= 1 then
		g_language_setting = 1
		CCUserDefault:sharedUserDefault():setIntegerForKey("xl_language",g_language_setting)
		CCUserDefault:sharedUserDefault():flush()
	end
else
	if g_language_setting == 0 then
		local system_lang = ""
		if xlSystemLanguage then
			system_lang = xlSystemLanguage()
		end
		if system_lang == "zh-Hant" or system_lang == "zh-Hant-CN" or system_lang == "zh-TW" or system_lang == "zh-HK" then
			g_language_setting = 3
		else
			local sys_lang = CCApplication:sharedApplication():getCurrentLanguage()
			if sys_lang == 1 then		--	国语
				g_language_setting = 1
			elseif sys_lang == 8 then	--	韩文
				g_language_setting = 3
			elseif sys_lang == 9 then	--	日语
				g_language_setting = 5
			else
				g_language_setting = 4
			end
		end
		CCUserDefault:sharedUserDefault():setIntegerForKey("xl_language",g_language_setting)
		CCUserDefault:sharedUserDefault():flush()
	end
end

local _update_s
local _update_texlist = {}

g_Background_vertical = {
	[1] = "other/logintv",
	[2] = "other/logintv2",
	[3] = "other/logintv3",
}

--设置该场景背景图
local rand = math.random(1,10000)
		
g_Background_Index = rand % #g_Background_vertical + 1

local function loadstringlang()
	if LANGUAG_SITTING == 1 then
		xlDoFile("data/"..language_config[g_language_setting][3]..".lan")
		--g_langauge_ver = language_config[g_language_setting][3]

		if g_language_setting == 1 or g_language_setting == 2 then
			g_Cur_Language = 1
		elseif g_language_setting == 3 then
			g_Cur_Language = 2
		elseif g_language_setting == 4 then
			g_Cur_Language = 3
		elseif g_language_setting == 5 then
			g_Cur_Language = 4
		end
	else
		xlDoFile("data/"..language_config[LANGUAG_SITTING][3]..".lan")
		--g_langauge_ver = language_config[LANGUAG_SITTING][3]
		if LANGUAG_SITTING == 2 then
			g_Cur_Language = 1
		elseif LANGUAG_SITTING == 3 then
			g_Cur_Language = 2
		elseif LANGUAG_SITTING == 4 then
			g_Cur_Language = 3
		elseif LANGUAG_SITTING == 5 then
			g_Cur_Language = 4
		end
	end

	xlUI_SetFont(language_config[g_language_setting][4],language_config[g_language_setting][6])

end

loadstringlang()

total,free,usedByMe = xlGetMemoryInfo()
print("fffffffffbegin usdmem total:" .. total .. " free:" .. free .. " usedByMe:" .. usedByMe .. " \n")
--g_language_setting = 1
--if g_language_setting <= 2 then
	--xlDoFile("data/"..language_config[g_language_setting][3]..".lan")
	--if g_language_setting == 1 then
		--g_langauge_ver = "chjt"
	--elseif g_language_setting == 2 then
		--g_langauge_ver = "chft"
	----elseif g_language_setting == 3 then
		----g_langauge_ver = "en"
	--else
		--g_langauge_ver = "chjt"
	--end
--else
	--xlDoFile("data/chjt.lan")
--end
total,free,usedByMe = xlGetMemoryInfo()
print("fffffffffend usdmem total:" .. total .. " free:" .. free .. " usedByMe:" .. usedByMe .. " \n")


--if xlUI_SetFont ~= nil then
	--xlUI_SetFont(language_config[g_language_setting][4],language_config[g_language_setting][6])
--end
--*************************************************************
-- 文本定义
---------------------------------------------------------------

Update_String_Table = {}
Update_String_Language = {}

--Update_String_Language["CopyDir_Loading_Info"]			= {"Set up games datas...","设置游戏运行环境..."}
--Update_String_Language["Updating_Loading_Info"]			= {"Updating...","正在更新..."}
--Update_String_Language["GameStart_Loading_Info"]		= {"Loading game datas...","正在加载游戏..."}

Update_String_Language["Announcement"] 					= {"News :","公      告"}
Update_String_Language["Announcement_Info"]				= {{},{},{},{}}--{"《Sango: Clash of Heroes》, command your lengedary heroes to explore the ancient land,\n conquer towns and castles, unite the kingdoms!\n\n","《策马三国志》用英雄策马天下的\n 游戏方式诠释三国时代的经典战役\n ...粉丝征集中...\n\n  英雄等级开放至12级"}


Update_String_Language["Announcement_Info"][2][1] 		= "      " 
Update_String_Language["Announcement_Info"][2][2] 		= "我们很有诚意的制作了《策马三国志》这款游" 
Update_String_Language["Announcement_Info"][2][3]		= "戏,用英雄策马天下的游戏方式诠释三国时代名" 
Update_String_Language["Announcement_Info"][2][4]       = "将与战役,重现英雄无敌征战三国的战棋经典!"
Update_String_Language["Announcement_Info"][2][5]		= "现粉丝火热征集中!!        "
Update_String_Language["Announcement_Info"][2][6]		= ""
Update_String_Language["Announcement_Info"][2][7]		= " 上海鑫线游戏 www.xingames.com"
Update_String_Language["Announcement_Info"][2][8]		= " 官方QQ群号:274108227 "
Update_String_Language["Announcement_Info"][2][9]		= ""
Update_String_Language["Announcement_Info"][2][10]		= "1.089版更新内容:"
Update_String_Language["Announcement_Info"][2][11]		= ""
Update_String_Language["Announcement_Info"][2][12]		= "1. 增加一批首通关卡后的装备奖励"
Update_String_Language["Announcement_Info"][2][13]		= "2. 增加新英雄令：太史慈"
Update_String_Language["Announcement_Info"][2][14]		= "3. 开放一张新娱乐地图: 秘境试炼"
Update_String_Language["Announcement_Info"][2][15]		= "4. 增加一些新手引导"
Update_String_Language["Announcement_Info"][2][16]		= "5. 部分关卡小幅调整"
Update_String_Language["Announcement_Info"][2][17]		= "6. 购买英雄令将获得附加装备"
Update_String_Language["Announcement_Info"][2][18]		= ""
Update_String_Language["Announcement_Info"][2][19]		= ""
Update_String_Language["Announcement_Info"][2][20]		= ""
Update_String_Language["Announcement_Info"][2][21]		= ""
Update_String_Language["Announcement_Info"][2][22]		= ""
Update_String_Language["Announcement_Info"][2][23]		= ""
Update_String_Language["Announcement_Info"][2][24]		= ""


--Update_String_Language["NetInfo"]					= {"network info","网络信息"}
--Update_String_Language["VersionInfo"]					= {"version","版本信息"}
--Update_String_Language["GameOptionNet"]					= {"network","联网模式"}
--Update_String_Language["GameOptionSa"]					= {"S t a r t","进入游戏"}
--Update_String_Language["GameOptionBbs"]					= {"game BBS","游戏论坛"}
--Update_String_Language["GameOptionLanguage"]			= {"Language","语言"}

--Update_String_Language["Version_Local_Label"]			= {"current version      ","当前版本        "}
--Update_String_Language["Version_Local_Version"]			= {"unknow","unknow"}
--Update_String_Language["Version_Server_Label"]			= {"available updates : ","可用新版本    "}
--Update_String_Language["Version_Server_Version"]		= {"unknow","unknow"}
--Update_String_Language["Version_Status_Ok"]				= {"","当前版本状态   正常"}
--Update_String_Language["Version_Status_Deformity"]		= {"need to finish updating!", "当前版本状态   不完整"}
--Update_String_Language["Version_Update_Continue"]		= {"continue to update", "继续更新"}
--Update_String_Language["Version_Update_Start"]			= {"begin update", "开始更新"}
--Update_String_Language["Version_Update_Unnecessary"]	= {"no need to update", "无须更新"}
--Update_String_Language["Version_Update_Rflesh"]			= {"refresh", "刷新"}
--Update_String_Language["Version_Update_FromApp"]		= {"pls get new version from App Store","请从苹果商店更新最新版本"}
--Update_String_Language["Version_Update_WithoutApp"]		= {"pls get new version from App Store","已经是苹果商店最新版本"}

--Update_String_Language["Main_Runing_NetWorkType0"]		= {"no network","当前网络类型   无"}
--Update_String_Language["Main_Runing_NetWorkType1"]		= {"network:  WIFI","当前网络类型   WIFI"}
--Update_String_Language["Main_Runing_NetWorkType2"]		= {"network:   3G","当前网络类型   3G"}
--Update_String_Language["Main_Runing_GetAnnouncement"]	= {"getting news......","获取公告信息......"}
--Update_String_Language["Main_Runing_GetLocalInfo"]		= {"getting local version info......","获取本地版本信息......"}
--Update_String_Language["Main_Runing_GetNetInfo"]		= {"checking network......","获取网络类型......"}
--Update_String_Language["Main_Runing_GetServerInfo"]		= {"getting server info......","获取服务器版本信息......"}
--Update_String_Language["Main_Runing_End"]				= {"",""}

--Update_String_Language["Exit_Info"]						= {"","更新完成，请重新启动游戏"}
--Update_String_Language["Exit_Ack"]						= {"","确定"}

--Update_String_Language["Confirm_Info_Up_"]				= {"","   检测到游戏最新版本！"}
--Update_String_Language["Confirm_Enter"]					= {"","进入游戏"}
--Update_String_Language["Confirm_Leave"]					= {"","更新"}

local function xlUI_ResetStringTable()
	local ltype = xlGame_Language_Type_Get()
	
	Update_String_Table["Announcement"] 			= Update_String_Language["Announcement"][ltype] or ""
	Update_String_Table["Announcement_Info"]		= Update_String_Language["Announcement_Info"][ltype] or {}
	
	local tabS = {}
	if type(g_string)=="table" and type(g_string.tab_string)=="table" then
		tabS = g_string.tab_string
	end
	local _STR = function(s)
		return tabS[s] or tostring(s)
	end
	
	Update_String_Table["CopyDir_Loading_Info"]		= _STR("CopyDir_Loading_Info")
	Update_String_Table["Updating_Loading_Info"]		= _STR("Updating_Loading_Info")
	Update_String_Table["GameStart_Loading_Info"]		= _STR("GameStart_Loading_Info")
	
	--随机的提示
	local randIdx = 1--math.random(1, #g_fail_hint_info)
	Update_String_Table["GameStart_Loading_Info"] = "" --g_fail_hint_info[randIdx] --大菠萝不显示文字
	
	Update_String_Table["NetInfo"]				= _STR("NetInfo")
	Update_String_Table["VersionInfo"]			= _STR("VersionInfo")
	Update_String_Table["GameOptionNet"]			= _STR("GameOptionNet")
	Update_String_Table["GameOptionSa"]			= _STR("GameOptionSa")
	Update_String_Table["GameOptionBbs"]			= _STR("GameOptionBbs")
	Update_String_Table["GameOptionLanguage"]		= _STR("GameOptionLanguage")
	
	Update_String_Table["Version_Local_Label"]		= _STR("Version_Local_Label")
	Update_String_Table["Version_Local_Version"]		= _STR("Version_Local_Version")
	Update_String_Table["Version_Server_Label"]		= _STR("Version_Server_Label")
	Update_String_Table["Version_Server_Version"]		= _STR("Version_Server_Version")
	Update_String_Table["Version_Status_Ok"]		= _STR("Version_Status_Ok")
	Update_String_Table["Version_Status_Deformity"]		= _STR("Version_Status_Deformity")
	Update_String_Table["Version_Update_Continue"]		= _STR("Version_Update_Continue")
	Update_String_Table["Version_Update_Continue2"]		= _STR("Version_Update_Continue2")
	Update_String_Table["Version_Update_Start"]			= _STR("Version_Update_Start")
	Update_String_Table["Version_Update_Unnecessary"]	= _STR("Version_Update_Unnecessary")
	Update_String_Table["Version_Update_Rflesh"]		= _STR("Version_Update_Rflesh")
	Update_String_Table["Version_Update_FromApp"]		= _STR("Version_Update_FromApp")
	Update_String_Table["Version_Update_WithoutApp"]	= _STR("Version_Update_WithoutApp")

	Update_String_Table["Main_Runing_NetWorkType0"]		= _STR("Main_Runing_NetWorkType0")
	Update_String_Table["Main_Runing_NetWorkType1"]		= _STR("Main_Runing_NetWorkType1")
	Update_String_Table["Main_Runing_NetWorkType2"]		= _STR("Main_Runing_NetWorkType2")
	Update_String_Table["Main_Runing_GetAnnouncement"]	= _STR("Main_Runing_GetAnnouncement")
	Update_String_Table["Main_Runing_GetLocalInfo"]		= _STR("Main_Runing_GetLocalInfo")
	Update_String_Table["Main_Runing_GetNetInfo"]		= _STR("Main_Runing_GetNetInfo")
	Update_String_Table["Main_Runing_GetServerInfo"]	= _STR("Main_Runing_GetServerInfo")
	Update_String_Table["Main_Runing_End"]			= _STR("Main_Runing_End")
	Update_String_Table["Main_Runing_GetInfo"]		= _STR("Main_Runing_GetInfo")
	Update_String_Table["Main_Runing_GetInfo11"]		= _STR("Main_Runing_GetInfo11")
	Update_String_Table["Main_Runing_GetInfo88"]		= _STR("Main_Runing_GetInfo88")
	Update_String_Table["Main_Runing_GetInfo99"]		= _STR("Main_Runing_GetInfo99")

	Update_String_Table["Exit_Info"]			= _STR("Exit_Info")
	Update_String_Table["Exit_Ack"]				= _STR("Exit_Ack")
	Update_String_Table["Exit_Wait"]			= _STR("Exit_Wait")
	Update_String_Table["Exit_Now"]				= _STR("Exit_Now")
	Update_String_Table["GameSettingInfo"]			= _STR("GameSettingInfo")

	Update_String_Table["Confirm_Info_Up_"]			= _STR("Confirm_Info_Up_")
	Update_String_Table["Confirm_Enter"]			= _STR("Confirm_Enter")
	Update_String_Table["Confirm_Leave"]			= _STR("Confirm_Leave")
	Update_String_Table["Confirm_Update_Later"]		= _STR("Confirm_Update_Later")
	Update_String_Table["Version_Server_Size"]		= _STR("Version_Server_Size")

	Update_String_Table["eightMantra1"]			= _STR("eightMantra1")
	Update_String_Table["eightMantra2"]			= _STR("eightMantra2")
	Update_String_Table["eightMantra3"]			= _STR("eightMantra3")
	Update_String_Table["eightMantra4"]			= _STR("eightMantra4")
	Update_String_Table["copyright"]			= _STR("copyright")
	Update_String_Table["__TEXT_healthgame"]		= _STR("__TEXT_healthgame")

	Update_String_Table["on_loading"]			= _STR("on_loading")

end




--*************************************************************
-- 常量枚举类型定义
---------------------------------------------------------------
Update_RuningStatus_TypeDef = {Start="Start",Init="Init",GetAnnouncementInfo="GetAnnouncementInfo",GetLocalInfo="GetLocalInfo",GetNetWorkType="GetNetWorkType",ConnectingServer="ConnectingServer",GetServerInfo="GetServerInfo",Updating="Updating",Delay="Delay",End="End",Skip="Skip"}
Update_WinType_TypeDef = {None="None",Welcome="Welcome",Loading="Loading",Updating="Updating",Main="Main",NetWork="NetWork",Exit="Exit",AppStore="AppStore",EnterGame="EnterGame",Up2="Up2"}
Update_NetWork_TypeDef = {none="none",wifi="wifi",g3="3G"}
Update_Loading_TypeDef = {StandAlone="StandAlone",}
g_tTargetPlatform = {kTargetWindows = 0,kTargetLinux = 1,kTargetMacOS = 2,kTargetAndroid = 3,kTargetIphone = 4,kTargetIpad = 5,kTargetBlackBerry = 6}




--*************************************************************
-- 内部状态数据
---------------------------------------------------------------
Update_Data_Table 					= {}								-- DATA

Update_Data_Table.Mode 					= 1 								-- 0为单机调试模式 1为正常模式	
Update_Data_Table.Level					= 0									-- 更新级别
Update_Data_Table.ExitWhenUpdate		= false								-- 更新完成是否退出
Update_Data_Table.IsOk 					= false 							-- 程序是否完整
Update_Data_Table.CanEnterGame				= false								-- 进入游戏按钮是否可以点
Update_Data_Table.InitGame				= false								-- 是否调用过InitGame
Update_Data_Table.IsWelcomeStart			= false								-- 是否进过欢迎界面
Update_Data_Table.PlatForm				= CCApplication:sharedApplication():getTargetPlatform() -- 当前平台--g_tTargetPlatform.kTargetIphone
Update_Data_Table.DesignResolutionSize			= CCDirector:sharedDirector():getOpenGLView():getDesignResolutionSize() -- 当前设计大小(屏幕大小)
print("xxxxxxx platform:" .. Update_Data_Table.PlatForm .. " ds.width:" .. Update_Data_Table.DesignResolutionSize.width .. " ds.height:" .. Update_Data_Table.DesignResolutionSize.height .. " \n")

Update_Data_Table.NetType				= Update_NetWork_TypeDef.unknow					-- 当前网络类型
Update_Data_Table.Status 				= Update_RuningStatus_TypeDef.Start				-- 当前运行状态

Update_Data_Table.LoadingType				= nil								-- loading界面要作的流程类型

Update_Data_Table.LoadingFuncs				= nil								-- loading要执行的流程列表
Update_Data_Table.LoadingFuncsIndex			= nil								-- loading要执行的当前流程索引

Update_Data_Table.ConnectStartFrame			= 0
Update_Data_Table.NetOverTick				= 600								-- 网络链接超时检测
Update_Data_Table.WebStatus				= 0								-- 跟踪从web获取ip.txt信息走到哪一步了
Update_Data_Table.IsConnected				= false								-- 当前是否连接
Update_Data_Table.CanUpdate				= false								-- 当前是否有新版本可以更新
Update_Data_Table.UpdateFromApp				= 0
Update_Data_Table.CheckNetWork				= 0								-- main界面下每多少帧检测一次网络

Update_Data_Table.TotalFiles				= 0								-- 当前下载总文件数
Update_Data_Table.TotalFileLen				= 0								-- 当前下载总数据
Update_Data_Table.TotalFileDownLoad			= 0								-- 当前下载数据进度

Update_Data_Table.CurrentFiles				= 0								-- 当前下载的文件数
Update_Data_Table.CurrentFileName			= nil								-- 当前下载的文件名
Update_Data_Table.CurrentFileLen			= 0								-- 当前下载的文件的长度
Update_Data_Table.CurrentFileDownLoad			= 0								-- 当前下载的文件的下载进度

Update_Data_Table.RunGameStart				= nil								-- 异步执行gamestart

Update_Data_Table.MaxAnnouncementLines			= 20								-- 公告行数
Update_Data_Table.MinAnnouncementSpace			= 24								-- 公告行间距

Update_Data_Table.CurrentSelServer			= 1								-- 当前选中的server
Update_Data_Table.ShowSelServer				= (1 == g_lua_src) or false					-- 选择服务器相关内容
Update_Data_Table.ServerList				= nil								-- 服务器列表
Update_Data_Table.ServerVersion				= "unknow"

Update_Data_Table.UpdateFrame				= 0

Update_Data_Table.IsDBConnected				= 0


--*************************************************************
-- 窗体界面及函数
---------------------------------------------------------------
Update_Ui_Table 					= {}								-- UI
Update_Ui_Table.Scene 					= nil 								-- 场景对象

Update_Ui_Table.LoginScene				= nil								-- 联网模式登陆场景

Update_Ui_Table.Win 					= {} 								-- 窗体表
Update_Ui_Table.Win.Updating 				= nil								-- Updating窗体
Update_Ui_Table.Win.Loading 				= nil								-- Loading窗体
Update_Ui_Table.Win.Main_Announcement_WEB		= nil								-- 主界面公告窗体 WEB
Update_Ui_Table.Win.Main_Announcement 			= nil								-- 主界面公告窗体
Update_Ui_Table.Win.Main_Info 				= nil								-- 主界面信息窗体
Update_Ui_Table.Win.Main_Game 				= nil								-- 主界面游戏窗体
Update_Ui_Table.Win.Main_Loading			= nil								-- 主界面loading图
Update_Ui_Table.Win.Logo 				= nil								-- Logo窗体
Update_Ui_Table.Win.CurrentWin				= nil								-- 当前现实的窗体
Update_Ui_Table.Win.Exit				= nil								-- 退出框
Update_Ui_Table.Win.Up2					= nil								-- 更新中断时显示的对话框
Update_Ui_Table.Win.Ip59				= nil								-- ip5两边边框
Update_Ui_Table.Win.EnterGame				= nil								-- 是否进入游戏确认框
Update_Ui_Table.Win.HealthGame				= nil								-- 健康游戏
--Update_Ui_Table.Win.GameSetting			= nil								--游戏设置窗体
--Update_Ui_Table.Win.GameSetting_Confim		= nil								--游戏设置更改确认


Update_Ui_Table.ButtonTable				= {} 								-- 所有Button表
Update_Ui_Table.ButtonTable_Handle			= {} 								-- 所有ButtonHandle表

Update_Ui_Table.Data					= {}								-- 界面DATA
Update_Ui_Table.Data.Size_U_Progress			= {Width = 0, Height = 0}					-- 更新进度条尺寸

local _labeloffy = 0
local _labeloffy2 = 0
if Update_Data_Table.PlatForm == g_tTargetPlatform.kTargetIphone or Update_Data_Table.PlatForm == g_tTargetPlatform.kTargetAndroid then --ip/android
	_labeloffy = 2
	_labeloffy2 = 6
end

--苹果版 时间减半
if xlGetChannelId then
	local iChannelId = xlGetChannelId()
	if iChannelId < 100 then
		Update_Data_Table.NetOverTick = 480
	end
end

-- 窗体函数
local function xlUI_Update_AddWindowButton(window, win_x, win_y, button_uid, button_w, button_h, button_image)
	Update_Ui_Table.ButtonTable[button_uid] = xlUI_CreateButton(button_w, button_h, button_image, 0 ,1)
	xlUI_AddButton(window, Update_Ui_Table.ButtonTable[button_uid], win_x, win_y)

	return Update_Ui_Table.ButtonTable[button_uid]
end

local function ui_enable_button(button,enable)
	if type(button) == "table" then
		if 0 == enable then
			-- local 
			xlUI_EnableTouch(button,0)
		else
			xlUI_EnableTouch(button,1)
		end
	end
end

--初始化按钮文本
--参数 1.按钮名 2.x坐标 3.y坐标 4.显示文本 5.文本宽 6.文本高 7.文本字体大小 8.水平对齐 9.垂直对齐 
--备注设置字体大小只有初次有效 之后再更改无效
local function xlUI_InitButtonLabel(buttonName,buttonX,buttonY,text,buttonW,buttonH,LabelSize,hAligh,vAligh)
	local iLastSize = xlUI_GetFontSize()	--提取原有的大小
	if type(LabelSize) == "number" then
		--xlUI_SetFontSize(LabelSize)			--设置按钮文字需要的字体大小
		xlUI_SetFont(language_config[g_language_setting][4],LabelSize)
	end
	xlUI_SetButtonLabel(Update_Ui_Table.ButtonTable[buttonName], buttonX, buttonY, text, buttonW, buttonH, hAligh,vAligh)
	--xlUI_SetFontSize(iLastSize)
	xlUI_SetFont(language_config[g_language_setting][4],iLastSize)
end

local function create9Sprite(filePath, pos_x, pos_y, width, height, frm, z)
	local img9 = CCScale9Sprite:create(filePath)
	if (img9 == nil) then
		img9 = CCScale9Sprite:create("data/image/misc/mask.png")
	end
	img9:setPosition(ccp(pos_x, pos_y))
	img9:setContentSize(CCSizeMake(width, height))
	xlUI_AddChild(frm,img9)
	return img9
end

-- 用来显示两边多余的边框
function ui_show_ip59(show)
	if Update_Data_Table.DesignResolutionSize.width >= 1136 and Update_Data_Table.DesignResolutionSize.height >= 640 then
		xlUI_Show(Update_Ui_Table.Win.Ip59,show)
	end
end

local function update_ui_show_iphone(wintype,itag)
	Update_Ui_Table.Win.CurrentWin = wintype
	if wintype == Update_WinType_TypeDef.None then
		xlUI_Show(Update_Ui_Table.Win.Loading,0)
		xlUI_Show(Update_Ui_Table.Win.Main_Loading,0)
		xlUI_Show(Update_Ui_Table.Win.Exit,0)
		xlUI_Show(Update_Ui_Table.Win.EnterGame,0)
		xlUI_Show(Update_Ui_Table.Win.Up2,0)
		xlUI_Show(Update_Ui_Table.Win.HealthGame,0)
		ui_show_ip59(0)
	elseif wintype == Update_WinType_TypeDef.Welcome then
		xlUI_Show(Update_Ui_Table.Win.Loading,0)
		xlUI_Show(Update_Ui_Table.Win.Main_Loading,0)
		xlUI_Show(Update_Ui_Table.Win.Exit,0)
		xlUI_Show(Update_Ui_Table.Win.EnterGame,0)
		xlUI_Show(Update_Ui_Table.Win.Up2,0)
		xlUI_Show(Update_Ui_Table.Win.HealthGame,0)
		ui_show_ip59(1)
	elseif wintype == Update_WinType_TypeDef.Loading then
		xlUI_Show(Update_Ui_Table.Win.Loading,1)
		xlUI_Show(Update_Ui_Table.Win.Main_Loading,0)
		xlUI_Show(Update_Ui_Table.Win.Exit,0)
		xlUI_Show(Update_Ui_Table.Win.EnterGame,0)
		xlUI_Show(Update_Ui_Table.Win.Up2,0)
		xlUI_Show(Update_Ui_Table.Win.HealthGame,1)
		ui_show_ip59(1)
		xlUI_SetButtonLabel(Update_Ui_Table.ButtonTable["current_progress"], -300, -60, "", 1280, 64, 1, 1) --+是往下
	elseif wintype == Update_WinType_TypeDef.Updating then
		xlUI_Show(Update_Ui_Table.Win.Loading,1)
		xlUI_Show(Update_Ui_Table.Win.Main_Loading,0)
		xlUI_Show(Update_Ui_Table.Win.Exit,0)
		xlUI_Show(Update_Ui_Table.Win.EnterGame,0)
		xlUI_Show(Update_Ui_Table.Win.Up2,0)
		xlUI_Show(Update_Ui_Table.Win.HealthGame,1)
		ui_show_ip59(1)
	elseif wintype == Update_WinType_TypeDef.Main then
		xlUI_Show(Update_Ui_Table.Win.Loading,0)
		xlUI_Show(Update_Ui_Table.Win.Main_Loading,1)
		xlUI_Show(Update_Ui_Table.Win.Exit,0)
		xlUI_Show(Update_Ui_Table.Win.EnterGame,0)
		xlUI_Show(Update_Ui_Table.Win.Up2,0)
		xlUI_Show(Update_Ui_Table.Win.HealthGame,1)
		ui_show_ip59(1)
	elseif wintype == Update_WinType_TypeDef.Exit then
		xlUI_Show(Update_Ui_Table.Win.Loading,0)
		xlUI_Show(Update_Ui_Table.Win.Main_Loading,0)
		xlUI_Show(Update_Ui_Table.Win.Exit,1)
		xlUI_Show(Update_Ui_Table.Win.EnterGame,0)
		xlUI_Show(Update_Ui_Table.Win.Up2,0)
		xlUI_Show(Update_Ui_Table.Win.HealthGame,0)
		ui_show_ip59(1)
	elseif wintype == Update_WinType_TypeDef.AppStore then
		xlUI_Show(Update_Ui_Table.Win.Loading,0)
		xlUI_Show(Update_Ui_Table.Win.Main_Loading,0)
		xlUI_Show(Update_Ui_Table.Win.Exit,1)
		xlUI_Show(Update_Ui_Table.Win.EnterGame,0)
		xlUI_Show(Update_Ui_Table.Win.Up2,0)
		xlUI_Show(Update_Ui_Table.Win.HealthGame,0)
		ui_show_ip59(1)
	elseif wintype == Update_WinType_TypeDef.EnterGame then
		xlUI_Show(Update_Ui_Table.Win.Loading,0)
		xlUI_Show(Update_Ui_Table.Win.Main_Loading,0)
		xlUI_Show(Update_Ui_Table.Win.Exit,0)
		xlUI_Show(Update_Ui_Table.Win.EnterGame,1)
		xlUI_Show(Update_Ui_Table.Win.HealthGame,0)
		if Update_Data_Table.PlatForm == g_tTargetPlatform.kTargetIphone or Update_Data_Table.PlatForm == g_tTargetPlatform.kTargetAndroid or Update_Data_Table.PlatForm == g_tTargetPlatform.kTargetIpad then --ip/android/ipad
			if 1 == itag then
				xlUI_Show(Update_Ui_Table.ButtonTable["game_enter_update"],0)
				xlUI_Show(Update_Ui_Table.ButtonTable["game_leave"],0)
				xlUI_Show(Update_Ui_Table.ButtonTable["game_enter_update_new"],1)
			else
				
				--xlUI_Show(Update_Ui_Table.ButtonTable["game_enter_update"],1)
				--xlUI_Show(Update_Ui_Table.ButtonTable["game_leave"],1)
				--xlUI_Show(Update_Ui_Table.ButtonTable["game_enter_update_new"],0)
				
				--geyachao: 都改为必须更新
				xlUI_Show(Update_Ui_Table.ButtonTable["game_enter_update"],0)
				xlUI_Show(Update_Ui_Table.ButtonTable["game_leave"],0)
				xlUI_Show(Update_Ui_Table.ButtonTable["game_enter_update_new"],1)
			end
		end
		xlUI_Show(Update_Ui_Table.Win.Up2,0)
		ui_show_ip59(1)

		local btnx = 116
		local iChannelId = getChannelInfo()
		if iChannelId < 100 then
			btnx = 73
		end

		local button = Update_Ui_Table.ButtonTable["entergame_version"]
		local info_string = Update_String_Table["Version_Server_Label"] .. Update_Data_Table.ServerVersion
		--xlLG("rrr","update server info:" .. info_string .. "\n")
		xlUI_SetButtonLabel(button,btnx,145, (info_string),400,30)
		local button = Update_Ui_Table.ButtonTable["update_download_size"]--xlUI_Update_AddWindowButton(Update_Ui_Table.Win.EnterGame, 0, 0, "update_download_size", 0, 0,"",0,1)
		local info_string = string.format("%s%.1f %s",Update_String_Table["Version_Server_Size"],(Update_Data_Table.TotalFileLen/1024/1024),"MB")
		--xlLG("rrr","update server size:" .. info_string .. "\n")
		xlUI_SetButtonLabel(button,btnx,195,info_string,400,30)
	elseif wintype == Update_WinType_TypeDef.Up2 then
		xlUI_Show(Update_Ui_Table.Win.Loading,0)
		xlUI_Show(Update_Ui_Table.Win.Main_Loading,0)
		xlUI_Show(Update_Ui_Table.Win.Exit,0)
		xlUI_Show(Update_Ui_Table.Win.EnterGame,0)
		xlUI_Show(Update_Ui_Table.Win.Up2,1)
		xlUI_Show(Update_Ui_Table.Win.HealthGame,0)
		ui_show_ip59(1)
	end
	
	if type(xlShowWebView) == "function" then
		Lua_xlShowWebView(0)
	end

	Update_Data_Table.Status = Update_RuningStatus_TypeDef.Start
end

local function update_ui_show(wintype,itag)
	update_ui_show_iphone(wintype,itag)
end

local function update_ui_init_loading()
	if nil == Update_Ui_Table.Win.Loading then
		local offy = 0
		local offx = 0
		local barw = 700
		local barh = 86
		local baroffx = 0
		local baroffy = 0
		local size = CCDirector:sharedDirector():getOpenGLView():getDesignResolutionSize()
		if size.width < size.height then
			offy = - 279 - 10
			offx = -110
			barw = 360
			barh =  86
			baroffx = 290
			baroffy = - 22
		end

		--主窗体
		local x = Update_Data_Table.DesignResolutionSize.width / 2
		local y = Update_Data_Table.DesignResolutionSize.height / 2
		Update_Ui_Table.Win.Loading = xlUI_CreateWindow(400, 240, 0, "")
		xlUI_SetWindowPos(Update_Ui_Table.Win.Loading, x - 200 + offx, y + 85 + offy)
		xlUI_EnableTouch(Update_Ui_Table.Win.Loading,0)

		_update_s = CCNode:create()
		xlUI_AddChild(Update_Ui_Table.Win.Loading,_update_s)
		
		--进度条背景
		local button = xlUI_CreateButton(barw, barh, __IMG("data/image/misc/valuebar_back.png"), 0, 1)
		xlUI_AddButton(Update_Ui_Table.Win.Loading, button, -170 + baroffx, 114 + baroffy)
		xlUI_EnableTouch(button,0)
		
		--[[
		--文字背景图
		button = xlUI_Update_AddWindowButton(Update_Ui_Table.Win.Loading, -147, 59, "label_bg", 680, 42, __IMG("data/image/misc/selectbg.png"))
		xlUI_EnableTouch(button,0)
		]]
		
		-- 进度条当前进度
		button = xlUI_Update_AddWindowButton(Update_Ui_Table.Win.Loading, -170 + baroffx, 118 + baroffy, "current_progress", barw, barh, __IMG("data/image/misc/valuebar.png"))
		local progressSize = Update_Ui_Table.Data.Size_U_Progress
		--progressSize.Width,progressSize.Height = xlUI_GetImageRect(button)
		progressSize.Width,progressSize.Height = 700, barh
		xlUI_EnableTouch(button,0)
		
		--进度信息
		button = xlUI_Update_AddWindowButton(Update_Ui_Table.Win.Loading, -137, 106 + baroffy, "update_progress_info", barw - 20, 22,__IMG("data/image/misc/arrow.png"))
		xlUI_EnableTouch(button,0)

		--进度信息
		button = xlUI_Update_AddWindowButton(Update_Ui_Table.Win.Loading, -137, 148 + baroffy, "update_progress_document", barw - 20, 22,__IMG("data/image/misc/arrow.png"))
		xlUI_EnableTouch(button,0)

		create_loading_redbtn(2)
	end
end

local function update_ui_init_exit()
	if nil == Update_Ui_Table.Win.Exit then
		-- 主窗体
		local x = Update_Data_Table.DesignResolutionSize.width / 2
		local y = Update_Data_Table.DesignResolutionSize.height / 2
		Update_Ui_Table.Win.Exit = xlUI_CreateWindow(384, 420, 0, __IMG("data/image/misc/login_border.png"))
		xlUI_SetWindowPos(Update_Ui_Table.Win.Exit, x-199, y-420)
		xlUI_EnableTouch(Update_Ui_Table.Win.Exit,0)
		
		-- 退出信息
		local button = xlUI_CreateButton(0,0, "",0,1)
		Update_Ui_Table.ButtonTable["exit_info"] = button
		xlUI_AddButton(Update_Ui_Table.Win.Exit, button, 0, 0)	
		xlUI_SetButtonLabel(button,40,133, Update_String_Table["Exit_Info"])
		-- 按钮
		button = xlUI_Update_AddWindowButton(Update_Ui_Table.Win.Exit, 126, 233, "game_exit", 0, 0,__IMG("data/image/misc/chest/itembtn2.png"))
		xlUI_SetButtonLabel(button, 0, 12, Update_String_Table["Exit_Ack"])
		Update_Ui_Table.ButtonTable_Handle[button] = function()
			print("exit")
			--xlOpenUrl("remote://https://test.xingames.com/red/111.html")
			if Update_WinType_TypeDef.AppStore == Update_Ui_Table.Win.CurrentWin then
				xlOpenUrl(g_myapp_url)
			end
			xlExit()
		end
	end
end


local function update_ui_init_up2()
	if nil == Update_Ui_Table.Win.Up2 then
		-- 主窗体
		local x = Update_Data_Table.DesignResolutionSize.width / 2
		local y = Update_Data_Table.DesignResolutionSize.height / 2
		--Update_Ui_Table.Win.Up2 = xlUI_CreateWindow(400, 250, 0, __IMG("data/image/misc/skillup/msgbox.png"))
		Update_Ui_Table.Win.Up2 = xlUI_CreateWindow(384, 420, 0, __IMG("data/image/misc/login_border.png"))
		xlUI_SetWindowPos(Update_Ui_Table.Win.Up2, x-199, y-420)
		xlUI_EnableTouch(Update_Ui_Table.Win.Up2,0)

		-- 继续更新信息
		local button = xlUI_CreateButton(0,0, "",0,1)
		xlUI_AddButton(Update_Ui_Table.Win.Up2, button, 0, 0)	
		xlUI_SetButtonLabel(button,90,133, Update_String_Table["Version_Update_Continue2"])
		-- 按钮
		button = xlUI_Update_AddWindowButton(Update_Ui_Table.Win.Up2, 126, 223, "game_exit", 0, 0,__IMG("data/image/misc/chest/itembtn2.png"))
		xlUI_SetButtonLabel(button, 0, 12, Update_String_Table["Exit_Ack"])
		Update_Ui_Table.ButtonTable_Handle[button] = function()
			print("continue update")
			--game_update_button_update_click()
			update_ui_show(Update_WinType_TypeDef.Main)
		end
	end	
end

local function update_ui_init_HealthGame()
	--[[
	if nil == Update_Ui_Table.Win.HealthGame then
		local x = 0
		local y = 0
		Update_Ui_Table.Win.HealthGame = xlUI_CreateWindow(Update_Data_Table.DesignResolutionSize.width, Update_Data_Table.DesignResolutionSize.height, 0, "")
		xlUI_SetWindowPos(Update_Ui_Table.Win.HealthGame, x, y + Update_Data_Table.DesignResolutionSize.height - 120)
		xlUI_EnableTouch(Update_Ui_Table.Win.HealthGame,0)

		if getChannelInfo() == 999 or g_Cur_Language == 1 then
			local img9 = create9Sprite(__IMG("data/image/panel/9sprite_bg_1.png"), 0, 0,Update_Data_Table.DesignResolutionSize.width,120,Update_Ui_Table.Win.HealthGame,-1)
			img9:setOpacity(100)

			--local button = xlUI_Update_AddWindowButton(Update_Ui_Table.Win.HealthGame, 0, 0, "healthgame", 0, 0,"")
			--xlUI_InitButtonLabel("healthgame",Update_Data_Table.DesignResolutionSize.width/2 - 360, 16, Update_String_Table["__TEXT_healthgame"], 0, 0,20, 1, 1)

			if Update_Data_Table.DesignResolutionSize.width > Update_Data_Table.DesignResolutionSize.height then
				button = xlUI_Update_AddWindowButton(Update_Ui_Table.Win.HealthGame, 0, 0, "eightMantra", 0, 0,"")
				xlUI_InitButtonLabel("eightMantra",Update_Data_Table.DesignResolutionSize.width/2 - 500, 36, Update_String_Table["eightMantra1"]..Update_String_Table["eightMantra2"]..Update_String_Table["eightMantra3"]..Update_String_Table["eightMantra4"], 0, 0,16, 1, 1)
			else
				button = xlUI_Update_AddWindowButton(Update_Ui_Table.Win.HealthGame, 0, 0, "eightMantra1", 0, 0,"")
				xlUI_InitButtonLabel("eightMantra1",Update_Data_Table.DesignResolutionSize.width/2 - 330, 16, Update_String_Table["eightMantra1"]..Update_String_Table["eightMantra2"], 0, 0,22, 1, 1)
				button = xlUI_Update_AddWindowButton(Update_Ui_Table.Win.HealthGame, 0, 0, "eightMantra2", 0, 0,"")
				xlUI_InitButtonLabel("eightMantra2",Update_Data_Table.DesignResolutionSize.width/2 - 330, 40, Update_String_Table["eightMantra3"]..Update_String_Table["eightMantra4"], 0, 0,22, 1, 1)
				button = xlUI_Update_AddWindowButton(Update_Ui_Table.Win.HealthGame, Update_Data_Table.DesignResolutionSize.width - 80, 18, "label_bg", 0, 0, __IMG("data/image/misc/age12+.png"))
				xlUI_EnableTouch(button,0)
			end

			button = xlUI_Update_AddWindowButton(Update_Ui_Table.Win.HealthGame, 0, 0, "copyright", 0, 0,"")
			xlUI_InitButtonLabel("copyright",Update_Data_Table.DesignResolutionSize.width/2 - 330, 64, Update_String_Table["copyright"], 0, 0,22, 1, 1)
		end
	end
	--]]
end

local function update_ui_init_entergame()
	if nil == Update_Ui_Table.Win.EnterGame then
		-- 主窗体
		local x = Update_Data_Table.DesignResolutionSize.width / 2
		local y = Update_Data_Table.DesignResolutionSize.height / 2
		--Update_Ui_Table.Win.EnterGame = xlUI_CreateWindow(400, 370, 0, __IMG("data/image/misc/mask.png"))
		Update_Ui_Table.Win.EnterGame = xlUI_CreateWindow(384, 420, 0, __IMG("data/image/misc/login_border.png"))
		xlUI_SetWindowPos(Update_Ui_Table.Win.EnterGame, x-199, y-420)
		xlUI_EnableTouch(Update_Ui_Table.Win.EnterGame,0)

		-- 说明信息
		local button = xlUI_Update_AddWindowButton(Update_Ui_Table.Win.EnterGame, 0, 0, "title_info", 0, 0,"",0,1)
		local info = Update_String_Table["Confirm_Info_Up_"]
		xlUI_SetButtonLabel(button,116,95,info,400,30)
		
		-- 版本信息
		button = xlUI_Update_AddWindowButton(Update_Ui_Table.Win.EnterGame, 0, 0, "entergame_version", 0, 0,"",0,1)
		local info = Update_String_Table["Version_Server_Label"] .. Update_Data_Table.ServerVersion
		--xlLG("rrr",info)
		xlUI_SetButtonLabel(button,116,145,info,400,30)
		
		-- 版本大小
		button = xlUI_Update_AddWindowButton(Update_Ui_Table.Win.EnterGame, 0, 0, "update_download_size", 0, 0,"",0,1)
		info = Update_String_Table["Version_Server_Size"] .. (Update_Data_Table.TotalFileLen/1024*1024) .. ("MB")
		--xlLG("rrr",info)
		xlUI_SetButtonLabel(button,116,195,"",400,30)
		
		
		if Update_Data_Table.PlatForm == g_tTargetPlatform.kTargetIphone or Update_Data_Table.PlatForm == g_tTargetPlatform.kTargetAndroid or Update_Data_Table.PlatForm == g_tTargetPlatform.kTargetIpad then --ip/android/ipad
			-- 暂时不更新
			button = xlUI_Update_AddWindowButton(Update_Ui_Table.Win.EnterGame, 40, 265, "game_leave", 0, 0,__IMG("data/image/misc/chest/itembtn2.png"))
			xlUI_SetButtonLabel(button, 0, 12 + _labeloffy, Update_String_Table["Confirm_Update_Later"])
			Update_Ui_Table.ButtonTable_Handle[button] = function()
				--xlLG("rrr","暂时不更新")
				if false == Update_Data_Table.IsOk then
					update_ui_show(Update_WinType_TypeDef.Main)
				else
					game_update_button_enter_game()
				end
			end

			-- 确认按钮（更新）
			button = xlUI_Update_AddWindowButton(Update_Ui_Table.Win.EnterGame, 208, 265, "game_enter_update", 0, 0,__IMG("data/image/misc/chest/itembtn2.png"))
			xlUI_SetButtonLabel(button, 0, 12 + _labeloffy, Update_String_Table["Confirm_Leave"])
			Update_Ui_Table.ButtonTable_Handle[button] = function()
				--xlLG("rrr","进入更新流程")
				if true == Update_Data_Table.CanUpdate then
					update_ui_show(Update_WinType_TypeDef.Updating)
				else
					if false == Update_Data_Table.IsOk then
						update_ui_show(Update_WinType_TypeDef.Main)
					end
				end
			end

			-- 确认按钮（更新）2
			button = xlUI_Update_AddWindowButton(Update_Ui_Table.Win.EnterGame, 124, 265, "game_enter_update_new", 0, 0,__IMG("data/image/misc/chest/itembtn2.png"))
			xlUI_SetButtonLabel(button, 0, 12 + _labeloffy, Update_String_Table["Confirm_Leave"])
			Update_Ui_Table.ButtonTable_Handle[button] = function()
				xlLG("rrr","进入更新流程")
				if true == Update_Data_Table.CanUpdate then
					update_ui_show(Update_WinType_TypeDef.Updating)
				else
					if false == Update_Data_Table.IsOk then
						update_ui_show(Update_WinType_TypeDef.Main)
					end
				end
			end
			xlUI_Show(button,0)
		else
			-- 暂时不更新
			button = xlUI_Update_AddWindowButton(Update_Ui_Table.Win.EnterGame, 40, 265, "game_leave", 0, 0,__IMG("data/image/misc/chest/itembtn2.png"))
			xlUI_SetButtonLabel(button, 0, 12, Update_String_Table["Confirm_Update_Later"])
			Update_Ui_Table.ButtonTable_Handle[button] = function()
				--xlLG("rrr","暂时不更新")
				if false == Update_Data_Table.IsOk then
					update_ui_show(Update_WinType_TypeDef.Main)
				else
					game_update_button_enter_game()
				end
			end
			-- 确认按钮（更新）
			button = xlUI_Update_AddWindowButton(Update_Ui_Table.Win.EnterGame, 208, 265, "game_enter_update", 0, 0,__IMG("data/image/misc/chest/itembtn2.png"))
			xlUI_SetButtonLabel(button, 0, 12, Update_String_Table["Confirm_Leave"])
			Update_Ui_Table.ButtonTable_Handle[button] = function()
				--xlLG("rrr","进入更新流程")
				if true == Update_Data_Table.CanUpdate then
					update_ui_show(Update_WinType_TypeDef.Updating)
				else
					if false == Update_Data_Table.IsOk then
						update_ui_show(Update_WinType_TypeDef.Main)
					end
				end
			end
		end
	end
end

-- 错误信息面板， 当game.so 加载失败时 弹出
Erro_Frm = {}
local function Erro_Frm_Func()
	local x = Update_Data_Table.DesignResolutionSize.width / 2
	local y = Update_Data_Table.DesignResolutionSize.height / 2

	Erro_Frm.Main_Game = xlUI_CreateWindow(400, 240, 0, __IMG("data/image/misc/skillup/msgbox4.png"))
	xlUI_SetWindowPos(Erro_Frm.Main_Game, x-200, y-125)
	xlUI_EnableTouch(Erro_Frm.Main_Game,0)

	xlUI_Show(Erro_Frm.Main_Game,0)

	local button = xlUI_CreateButton(0,0, "",0,1)
	xlUI_AddButton(Erro_Frm.Main_Game, button, 0, 0)	
	xlUI_SetButtonLabel(button,60,45, "游戏核心模块加载失败... \n \n 请重新启动游戏")

	button = xlUI_CreateButton(0,0,__IMG("data/image/misc/chest/itembtn2.png"),0,1)
	xlUI_AddButton(Erro_Frm.Main_Game, button, 200 - 50, 125 + 50)
	Update_Ui_Table.ButtonTable_Handle[button] = function()
		xlExit()
	end

end

local function update_ui_init_main_iphone()
	local px = 0
	if Update_Data_Table.DesignResolutionSize.width == 960 and Update_Data_Table.DesignResolutionSize.height == 640 then -- ip4(s)
	elseif Update_Data_Table.DesignResolutionSize.width == 1136 and Update_Data_Table.DesignResolutionSize.height == 640 then -- ip5(s)
		px = 88
		Update_Ui_Table.Win.Ip59 = xlUI_CreateWindow(1,1)
		xlUI_SetWindowPos(Update_Ui_Table.Win.Ip59,-100,-100)
		xlUI_SetOpaque(Update_Ui_Table.Win.Ip59, 100)
		xlUI_EnableTouch(Update_Ui_Table.Win.Ip59,0)
		local self = {data = {w = 140,h = 1040},handle = {}}
		--local a = __CreateFrmBG9(self)
		--local b = __CreateFrmBG9(self)
		--xlUI_AddChild(Update_Ui_Table.Win.Ip59,a)
		--xlUI_AddChild(Update_Ui_Table.Win.Ip59,b)
		--a:setPosition(95,200)
		--b:setPosition(1095,200)
	elseif Update_Data_Table.DesignResolutionSize.width == 1280 and Update_Data_Table.DesignResolutionSize.height == 720 then -- android
		px = 88
		Update_Ui_Table.Win.Ip59 = xlUI_CreateWindow(1,1)
		xlUI_SetWindowPos(Update_Ui_Table.Win.Ip59,-100,-100)
		xlUI_SetOpaque(Update_Ui_Table.Win.Ip59, 100)
		xlUI_EnableTouch(Update_Ui_Table.Win.Ip59,0)
		local self = {data = {w = 160,h = 1040},handle = {}}
		--local a = __CreateFrmBG9(self)
		--local b = __CreateFrmBG9(self)
		--xlUI_AddChild(Update_Ui_Table.Win.Ip59,a)
		--xlUI_AddChild(Update_Ui_Table.Win.Ip59,b)
		--a:setPosition(100,200)
		--b:setPosition(1220,200)
	elseif Update_Data_Table.DesignResolutionSize.width == 1560 and Update_Data_Table.DesignResolutionSize.height == 720 then --iPhoneX
		local W = Update_Data_Table.DesignResolutionSize.width
		local H = Update_Data_Table.DesignResolutionSize.height
		
		Update_Ui_Table.Win.Effect = xlUI_CreateWindow(1, 1)--__IMG("data/image/misc/skillup/msgbox.png"))
		xlUI_SetWindowPos(Update_Ui_Table.Win.Effect, -100, -100)
		xlUI_SetOpaque(Update_Ui_Table.Win.Effect, 100)
		xlUI_EnableTouch(Update_Ui_Table.Win.Effect,0)
		
		--[[
		--左侧黑边
		local tex = CCTextureCache:sharedTextureCache():addImage(__IMG("data/image/misc/black_border.png"))
		local pSprite = CCSprite:createWithTexture(tex,CCRectMake(0,0,120, 720))
		xlUI_AddChild(Update_Ui_Table.Win.Effect,pSprite)
		pSprite:setRotation(180)
		pSprite:setPosition(ccp(220, -H - H / 2 + 260))
		
		--右侧黑边
		local tex = CCTextureCache:sharedTextureCache():addImage(__IMG("data/image/misc/black_border.png"))
		local pSprite = CCSprite:createWithTexture(tex,CCRectMake(0, 0, 120, 720))
		xlUI_AddChild(Update_Ui_Table.Win.Effect,pSprite)
		pSprite:setRotation(0)
		pSprite:setPosition(ccp(W - 20, -H / 2 + 260))
		--]]
	end
	
	-- a 公告信息模块 开始

	local offy = 0
	local offx = 0
	local size = CCDirector:sharedDirector():getOpenGLView():getDesignResolutionSize()
	if size.width < size.height then
		offy = - 279 - 10
		offx = -110
	end
	local x = Update_Data_Table.DesignResolutionSize.width / 2
	local y = Update_Data_Table.DesignResolutionSize.height / 2
	Update_Ui_Table.Win.Main_Loading = xlUI_CreateWindow(400, 240, 0, "")
	xlUI_SetWindowPos(Update_Ui_Table.Win.Main_Loading, x - 200 + offx, y + 85 + offy)
	xlUI_SetOpaque(Update_Ui_Table.Win.Main_Loading, 100)
	xlUI_EnableTouch(Update_Ui_Table.Win.Main_Loading,0)

	local labeloffy = 0
	if Update_Data_Table.PlatForm == g_tTargetPlatform.kTargetIphone or Update_Data_Table.PlatForm == g_tTargetPlatform.kTargetAndroid then --ip/android
		labeloffy = -14
	end

	local size = CCDirector:sharedDirector():getOpenGLView():getDesignResolutionSize()
	local button = xlUI_Update_AddWindowButton(Update_Ui_Table.Win.Main_Loading, 0, 0, "waitserver", 0, 0,"")
	xlUI_SetButtonLabel(button, 202, - 20 + labeloffy, Update_String_Table["Main_Runing_GetInfo"])
	--ui_init_loading_ani()

	create_loading_redbtn(1)
end

local function update_ui_init_main()
	update_ui_init_main_iphone()
	Erro_Frm_Func()
end

-- 创建和初始化场景和各个界面
local function update_ui_init_scene()
	if nil == Update_Ui_Table.Scene then
		Update_Ui_Table.Scene = xlScene_Create("update")
		xlScene_Switch(Update_Ui_Table.Scene)
		--if Update_Data_Table.PlatForm == g_tTargetPlatform.kTargetIphone then
			if Update_Data_Table.DesignResolutionSize.width == 960 and Update_Data_Table.DesignResolutionSize.height == 640 then -- ip4(s)
				xlScene_EnableFillScreen(Update_Ui_Table.Scene,1)
				xlSetViewNodeFocus(Update_Data_Table.DesignResolutionSize.width/2,Update_Data_Table.DesignResolutionSize.height/2)
				xlView_SetScale(1.0)
			elseif Update_Data_Table.DesignResolutionSize.width == 1136 and Update_Data_Table.DesignResolutionSize.height == 640 then -- ip5(s)
				xlSetViewNodeFocus(Update_Data_Table.DesignResolutionSize.width/2 + 2,Update_Data_Table.DesignResolutionSize.height/2 + 28)
				xlView_SetScale(0.89)
			elseif Update_Data_Table.DesignResolutionSize.width == 1280 and Update_Data_Table.DesignResolutionSize.height == 720 then
				xlSetViewNodeFocus(Update_Data_Table.DesignResolutionSize.width/2 ,Update_Data_Table.DesignResolutionSize.height/2 + 30)
				--xlView_SetScale(0.96)
			elseif Update_Data_Table.DesignResolutionSize.width == 1560 and Update_Data_Table.DesignResolutionSize.height == 720 then --iphoneX
				xlSetViewNodeFocus(Update_Data_Table.DesignResolutionSize.width/2,Update_Data_Table.DesignResolutionSize.height/2)
				--xlView_SetScale(0.96)
			elseif Update_Data_Table.DesignResolutionSize.width == 720 and Update_Data_Table.DesignResolutionSize.height == 1560 then --iphoneX
				xlSetViewNodeFocus(Update_Data_Table.DesignResolutionSize.width/2+24,Update_Data_Table.DesignResolutionSize.height/2)
				xlView_SetScale(1.0)
			elseif Update_Data_Table.DesignResolutionSize.width == 720 and Update_Data_Table.DesignResolutionSize.height == 1280 then --iphoneX
				xlSetViewNodeFocus(Update_Data_Table.DesignResolutionSize.width/2+24,Update_Data_Table.DesignResolutionSize.height/2 + 140)
				xlView_SetScale(1.0)
			else
				xlSetViewNodeFocus(Update_Data_Table.DesignResolutionSize.width/2 + 128 ,Update_Data_Table.DesignResolutionSize.height/2)
				xlView_SetScale(1.0)
			end
		--end
		xlUI_ResetStringTable()
		
		--TraceMemoryInfo("init begin loading")
		update_ui_init_loading()	--初始化loading界面
		--TraceMemoryInfo("init begin main")
		update_ui_init_main() --初始化主界面
		--TraceMemoryInfo("init begin exit")
		update_ui_init_exit() --初始化exit界面
		--TraceMemoryInfo("init begin entergame")
		update_ui_init_entergame()
		--TraceMemoryInfo("init begin up2")
		update_ui_init_up2()
		--TraceMemoryInfo("init begin HealthGame")
		update_ui_init_HealthGame()
		--TraceMemoryInfo("init end init")
	else
		xlScene_Switch(Update_Ui_Table.Scene)
		
		if Update_Data_Table.DesignResolutionSize.width == 960 and Update_Data_Table.DesignResolutionSize.height == 640 then -- ip4(s)
			xlScene_EnableFillScreen(Update_Ui_Table.Scene,1)
			xlSetViewNodeFocus(Update_Data_Table.DesignResolutionSize.width/2,Update_Data_Table.DesignResolutionSize.height/2)
			xlView_SetScale(1.0)
		elseif Update_Data_Table.DesignResolutionSize.width == 1136 and Update_Data_Table.DesignResolutionSize.height == 640 then -- ip5(s)
			xlSetViewNodeFocus(Update_Data_Table.DesignResolutionSize.width/2 + 2,Update_Data_Table.DesignResolutionSize.height/2 + 28)
			xlView_SetScale(0.89)
		elseif Update_Data_Table.DesignResolutionSize.width == 1280 and Update_Data_Table.DesignResolutionSize.height == 720 then --ip6,ip7,ip8
			xlSetViewNodeFocus(Update_Data_Table.DesignResolutionSize.width/2 ,Update_Data_Table.DesignResolutionSize.height/2 + 30)
			xlView_SetScale(1)
		elseif Update_Data_Table.DesignResolutionSize.width == 1560 and Update_Data_Table.DesignResolutionSize.height == 720 then --ipX
			xlSetViewNodeFocus(Update_Data_Table.DesignResolutionSize.width/2,Update_Data_Table.DesignResolutionSize.height/2)
			--xlView_SetScale(1.21875)
		else --iPad
			xlSetViewNodeFocus(Update_Data_Table.DesignResolutionSize.width/2 + 128 ,Update_Data_Table.DesignResolutionSize.height/2)
			xlView_SetScale(1.0)
		end
		--if g_Cur_Language == 1 then
			xlScene_LoadBackground(Update_Ui_Table.Scene,"other/loading")
		--else
			--xlScene_LoadBackground(Update_Ui_Table.Scene,"other/loading_en")
		--end
	end
end

--游戏论坛页面
function update_ui_show_gamebbs_scene(urlName)
	local url = GameForumURL
	if type(urlName) == "string" then
		GameForumURL = AccountRegisterURL
	end
	
	if g_tTargetPlatform.kTargetWindows ~= Update_Data_Table.PlatForm then                  
		if nil == Update_Ui_Table.GameForum then                            
			Update_Ui_Table.GameForum = xlScene_Create("gameForum")         
		end
		xlScene_Switch(Update_Ui_Table.GameForum)
		
	else
		xlOpenUrl(GameForumURL)
	end
	
	GameForumURL = url
end

local function update_ui_refresh_version_announcement()
	--print("xxxxxxxxxxxxxxxxx update_ui_refresh_version_announcement")
	local announcement_lines = Update_String_Table["Announcement_Info"]
	if type(announcement_lines) == "table" and #announcement_lines >0 then
		for i = 1,Update_Data_Table.MaxAnnouncementLines do
			local info = announcement_lines[i]
			if type(info) == "string" then
			else
				info = ""
			end
			--print("xxxxxxxxxxxx   info:" .. info)
			xlUI_SetButtonLabel(Update_Ui_Table.ButtonTable[string.format("update_version_announcement_%02d",i)],30,20 + Update_Data_Table.MinAnnouncementSpace*i,info)
		end
	end
end

local function update_ui_refresh_current_status(info)
	local x = 60
	local y = 125
	xlUI_SetButtonLabel(Update_Ui_Table.ButtonTable["update_current_status"],x,y, info)
end

local function update_ui_refresh_current_networktype()
	local x = 60
	local y = 40
	if Update_Data_Table.NetType == Update_NetWork_TypeDef.none then
		xlUI_SetButtonLabel(Update_Ui_Table.ButtonTable["update_current_networktype"],x,y, Update_String_Table["Main_Runing_NetWorkType0"])
	elseif Update_Data_Table.NetType == Update_NetWork_TypeDef.wifi then
		xlUI_SetButtonLabel(Update_Ui_Table.ButtonTable["update_current_networktype"],x,y, Update_String_Table["Main_Runing_NetWorkType1"])
	elseif Update_Data_Table.NetType == Update_NetWork_TypeDef.g3 then
		xlUI_SetButtonLabel(Update_Ui_Table.ButtonTable["update_current_networktype"],x,y, Update_String_Table["Main_Runing_NetWorkType2"])
	end
end

local function update_ui_refresh_version_local()
	local version_local = xlUpdateGetInfo(2)
	if type(version_local) == "string" then
	else
		version_local = Update_String_Table["Version_Local_Version"]
	end
	local info = Update_String_Table["Version_Local_Label"] .. version_local
	local x = 60
	local y = 100
	xlUI_SetButtonLabel(Update_Ui_Table.ButtonTable["update_version_local"], x, y, info,450,30)
end

function update_ui_refresh_version_server()
	local version_server = xlUpdateGetInfo(3)
	if type(version_server) == "string" then
	else
		version_server = Update_String_Table["Version_Server_Version"]
	end
	if false == Update_Data_Table.IsConnected then
		version_server = Update_String_Table["Version_Server_Version"]
	end
	--game_update_set_server_version(version_server)
	Update_Data_Table.ServerVersion = version_server

	local button = Update_Ui_Table.ButtonTable["entergame_version"]
	local info_string = Update_String_Table["Version_Server_Label"] .. Update_Data_Table.ServerVersion
	xlUI_SetButtonLabel(button,116,145, (info_string),400,30)
	--xlLG("rrr","update server info:" .. info_string .. "\n")
	local button = Update_Ui_Table.ButtonTable["update_download_size"]--xlUI_Update_AddWindowButton(Update_Ui_Table.Win.EnterGame, 0, 0, "update_download_size", 0, 0,"",0,1)
	local info_string = string.format("%s%.1f %s",Update_String_Table["Version_Server_Size"],(Update_Data_Table.TotalFileLen/1024/1024),"MB")
	--xlLG("rrr","update server size:" .. info_string .. "\n")
	xlUI_SetButtonLabel(button,116,195,info_string,400,30)
end

local function update_ui_refresh_version_panel()
	update_ui_refresh_version_server()
end

local function update_ui_refresh_serverlist_panel()
	--服务器列表1
	xlUI_Show(Update_Ui_Table.ButtonTable["update_serverlist_1_icon"],0)
	xlUI_Show(Update_Ui_Table.ButtonTable["update_serverlist_1_label"],0)
	--服务器列表2
	xlUI_Show(Update_Ui_Table.ButtonTable["update_serverlist_2_icon"],0)
	xlUI_Show(Update_Ui_Table.ButtonTable["update_serverlist_2_label"],0)
	--服务器列表3
	xlUI_Show(Update_Ui_Table.ButtonTable["update_serverlist_3_icon"],0)
	xlUI_Show(Update_Ui_Table.ButtonTable["update_serverlist_3_label"],0)
	--选中服务器图标
	xlUI_Show(Update_Ui_Table.ButtonTable["update_serverlist_sel_icon"],0)
	
	if true == Update_Data_Table.ShowSelServer then
		if type(Update_Data_Table.ServerList) == "table" then		
			for i = 1,#Update_Data_Table.ServerList do
				if 1 == i then
					xlUI_Show(Update_Ui_Table.ButtonTable["update_serverlist_1_icon"],1)
					xlUI_Show(Update_Ui_Table.ButtonTable["update_serverlist_1_label"],1)
					xlUI_SetButtonLabel(Update_Ui_Table.ButtonTable["update_serverlist_1_label"],60,105 + (i - 1)*35,Update_Data_Table.ServerList[i])
				elseif 2 == i then
					xlUI_Show(Update_Ui_Table.ButtonTable["update_serverlist_2_icon"],1)
					xlUI_Show(Update_Ui_Table.ButtonTable["update_serverlist_2_label"],1)
					xlUI_SetButtonLabel(Update_Ui_Table.ButtonTable["update_serverlist_2_label"],60,105 + (i - 1)*35,Update_Data_Table.ServerList[i])
				elseif 3 == i then
					xlUI_Show(Update_Ui_Table.ButtonTable["update_serverlist_3_icon"],1)
					xlUI_Show(Update_Ui_Table.ButtonTable["update_serverlist_3_label"],1)
					xlUI_SetButtonLabel(Update_Ui_Table.ButtonTable["update_serverlist_3_label"],60,105 + (i - 1)*35,Update_Data_Table.ServerList[i])
				end
			end
			xlUI_Show(Update_Ui_Table.ButtonTable["update_serverlist_sel_icon"],1)
		end
	end
end

local function update_ui_set_loading_progress(progress)
	local lenth = progress / 100 * Update_Ui_Table.Data.Size_U_Progress.Width
	xlUI_SetImageRect(Update_Ui_Table.ButtonTable["current_progress"],lenth,Update_Ui_Table.Data.Size_U_Progress.Height)
end

local __LastTittle = "N/A"
local __LastTime = os.time()
local function update_ui_set_loading_progress_title(title)
	if title==nil then
		title = __LastTittle
	else
		__LastTittle = title
	end
	local curDownLoad = Update_Data_Table.TotalFileDownLoad + Update_Data_Table.CurrentFileDownLoad
	local plus = ""
	if curDownLoad~=0 and curDownLoad~=Update_Data_Table.TotalFileLen then
		plus = "" .. math.floor(curDownLoad/1024/1024) .. "/" .. math.floor(Update_Data_Table.TotalFileLen/1024/1024).."MB"
	end
	
	local timeNow = os.time()
	local deltatime = timeNow - __LastTime
	if (deltatime > 15) then --15秒换一次tip
		--随机的提示
		local randIdx = 1 --math.random(1, #g_fail_hint_info)
		Update_String_Table["GameStart_Loading_Info"] = "" --g_fail_hint_info[randIdx] --大菠萝不显示文字
		
		--重新计时
		__LastTime = timeNow
	end
	
	--xlUI_SetButtonLabel(Update_Ui_Table.ButtonTable["update_progress_info"], 60, 17, title..plus,240,96)
	--xlUI_SetButtonLabel(Update_Ui_Table.ButtonTable["current_progress"], -300, -60, title, 64, 1, 1)
	xlUI_SetButtonLabel(Update_Ui_Table.ButtonTable["current_progress"], -300, -60, Update_String_Table["GameStart_Loading_Info"] ,1280, 64, 1, 1)
	xlUI_SetButtonLabel(Update_Ui_Table.ButtonTable["update_progress_info"], -200, 19 + _labeloffy2, plus, 1280, 50, 1, 1)
end

local function update_ui_set_loading_progress_detail(detail)
	
end

local function update_ui_show_server_selected(index)
	if index == Update_Data_Table.CurrentSelServer then
		return
	end

	if 0 == index then
		return
	end
	
	Update_Data_Table.CurrentSelServer = index

	xlUI_SetWindowPos(Update_Ui_Table.ButtonTable["update_serverlist_sel_icon"], 20, 105+(index - 1)*35)
end

local function update_ui_refresh_updating_panel()
	local curDownLoad = Update_Data_Table.TotalFileDownLoad + Update_Data_Table.CurrentFileDownLoad
	update_ui_set_loading_progress_title()		--刷新下载数值
	--xlUI_SetButtonLabel(Update_Ui_Table.ButtonTable["current_progress"], -300, -60, Update_Data_Table.CurrentFileName, 1280, 64, 1, 1)
	local lenth = curDownLoad / Update_Data_Table.TotalFileLen * Update_Ui_Table.Data.Size_U_Progress.Width
	xlUI_SetImageRect(Update_Ui_Table.ButtonTable["current_progress"],lenth,Update_Ui_Table.Data.Size_U_Progress.Height)
	
	if (IsTester == 2) then
		local curDownLoad = Update_Data_Table.TotalFileDownLoad + Update_Data_Table.CurrentFileDownLoad
		local plus = ""
		local filaname = ""
		if curDownLoad~=0 and curDownLoad~=Update_Data_Table.TotalFileLen then
			plus = "" .. math.floor(curDownLoad/1024/1024) .. "/" .. math.floor(Update_Data_Table.TotalFileLen/1024/1024).."MB"
			filaname = Update_Data_Table.CurrentFileName
		end
		
		--竖屏往右上挪
		--战车 --geyachao
		xlUI_SetButtonLabel(Update_Ui_Table.ButtonTable["update_progress_info"], -200, 19 + _labeloffy2, plus, 1280, 50, 1, 1)
		xlUI_SetButtonLabel(Update_Ui_Table.ButtonTable["update_progress_document"], -200, 19 + _labeloffy2, filaname, 1280, 50, 1, 1)
	end
	
end

function update_ui_refresh_language()
	xlUI_ResetStringTable()	
	
	xlUI_SetButtonLabel(Update_Ui_Table.ButtonTable["Announcement"],230,18, Update_String_Table["Announcement"])
	xlUI_SetButtonLabel(Update_Ui_Table.ButtonTable["NetInfo"],210,15, Update_String_Table["NetInfo"])
	xlUI_SetButtonLabel(Update_Ui_Table.ButtonTable["VersionInfo"],210,10,Update_String_Table["VersionInfo"])
	xlUI_SetButtonLabel(Update_Ui_Table.ButtonTable["game_option_sa"], 0, 12, Update_String_Table["GameOptionSa"])
	xlUI_SetButtonLabel(Update_Ui_Table.ButtonTable["game_option_bbs"], 0, 12, Update_String_Table["GameOptionBbs"])
	xlUI_SetButtonLabel(Update_Ui_Table.ButtonTable["game_option_language"], 0, 12, Update_String_Table["GameOptionLanguage"])
	
	update_ui_refresh_version_announcement()
	update_ui_refresh_current_networktype()
	update_ui_refresh_version_panel()
end



total,free,usedByMe = xlGetMemoryInfo()
--print("11111111111 usdmem total:" .. total .. " free:" .. free .. " usedByMe:" .. usedByMe .. " \n")
--*************************************************************
-- 程序流程相关
---------------------------------------------------------------
-- 总入口函数 nUpdateMode 0为单机调试模式 1为正常模式
function update_start(nUpdateMode,nLevel)
	Update_Data_Table.Mode = nUpdateMode
	xlLG("update","update_start... mode:" .. Update_Data_Table.Mode)	
	if 0 == Update_Data_Table.Mode then
		Update_Data_Table.IsOk = true
	end

	-- 设置当前更新等级
	if type(nLevel) == "number" then
		Update_Data_Table.Level = nLevel
	else
		local nMaxLevel = xlUpdateEvent(47)
		Update_Data_Table.Level = nMaxLevel
	end
	xlUpdateEvent(46,Update_Data_Table.Level)

	update_ui_init_scene()

total,free,usedByMe = xlGetMemoryInfo()
--print("33333333333 usdmem total:" .. total .. " free:" .. free .. " usedByMe:" .. usedByMe .. " \n")

	if true == Update_Data_Table.ShowSelServer then
		xlUpdateEvent(6,0)
	else
		xlUpdateEvent(6,1)
	end
	xlUpdateEvent(6,0)
	local accounttype = CCUserDefault:sharedUserDefault():getIntegerForKey("xl_account_test")
	if 0 == accounttype then
	else
		Update_Data_Table.CurrentSelServer = 2
	end
	--print("xxxxxxxxxxxxxx dfdfdfdf f  fgjdkfjdkfj j  at:" .. accounttype)


	if true == Update_Data_Table.IsWelcomeStart then
		if 0 == nUpdateMode then
			--print("xxxxxxxxxxxxxx 1111 \n")
			update_ui_show(Update_WinType_TypeDef.Main)
		else
			if 0 == xlUpdateEvent(200) then
			--print("xxxxxxxxxxxxxx 2222 \n")
				update_loading_init_dir()
				update_ui_show(Update_WinType_TypeDef.Loading)
			else
				--print("xxxxxxxxxxxxxx 3333 \n")
				update_ui_show(Update_WinType_TypeDef.Main)
			end
		end	
	else
		--print("xxxxxxxxxxxxxx 4444 \n")
		update_ui_show(Update_WinType_TypeDef.Welcome)
		
		--战车
		--本地默认2个更新服务器随机选一个
		local t = {
			up1 = {"121.199.51.44:13282",},
			up2 = {"121.199.51.44:13281",},
		}
		local t1_length = (#t.up1)
		local t2_length = (#t.up2)
		if (t1_length > 0) and (t2_length > 0) then
			local randValue1 = math.random(1, t1_length)
			local randValue2 = math.random(1, t2_length)
			local tmp_up1 = t.up1[randValue1]
			local tmp_up2 = t.up2[randValue2]
			xlUpdateResetServerList(tmp_up1,tmp_up2)
			print("from local up1="..tmp_up1, "up2="..tmp_up2)
		end
		
		--http request
		local url = "http://139.196.204.222/update/ip_diablo_and.txt"
		xlHttpClient_Get(url,"update")
		
		--http request
		local iChannelId = xlGetChannelId()
		local url = string.format("http://update.xingames.com/config_tank.php?cid=%d",iChannelId)
		xlHttpClient_Get(url,"red")

		xlUpdateEvent(210)
		--跳过起始5秒动画效果
		--xlLuaEvent_UpdateEvent(211)
	end

	--total,free,usedByMe = xlGetMemoryInfo()
	--print("44444444444 usdmem total:" .. total .. " free:" .. free .. " usedByMe:" .. usedByMe .. " \n")

end

-- 各窗体的每帧update回调处理
g_loading_paused = 0		--允许一些调试信息把loading过程卡住
g_loading_continue = 0		--立刻执行下一个初始化函数
g_loading_func_match = ""
local function reset_loading_control_param(t)
	if type(t)=="table" then
		g_loading_func_match = tostring(t)
	else
		g_loading_func_match = ""
	end
	g_loading_paused = 0
	g_loading_continue = 0
end
local function ui_win_loading_loop(frame)
	if Update_Data_Table.Status == Update_RuningStatus_TypeDef.Start then
		if type(Update_Data_Table.LoadingFuncs) == "table" and #Update_Data_Table.LoadingFuncs > 0 and nil == Update_Data_Table.LoadingFuncsIndex then
			reset_loading_control_param(Update_Data_Table.LoadingFuncs)
			Update_Data_Table.LoadingFuncsIndex = 1
			update_ui_set_loading_progress(0)
			Update_Data_Table.Status = Update_RuningStatus_TypeDef.Updating
		else
			update_ui_show(Update_WinType_TypeDef.None)
		end
	elseif Update_Data_Table.Status == Update_RuningStatus_TypeDef.Updating then
		if Update_Data_Table.LoadingFuncsIndex <= #Update_Data_Table.LoadingFuncs then
			local IsLastLoad = g_loading_func_match==tostring(Update_Data_Table.LoadingFuncs)
			if IsLastLoad and g_loading_paused==1 then
				return
			end
			local curprogress = Update_Data_Table.LoadingFuncs[Update_Data_Table.LoadingFuncsIndex]()
			while(IsLastLoad and g_loading_continue==1 and Update_Data_Table.LoadingFuncsIndex<#Update_Data_Table.LoadingFuncs)do
				g_loading_continue = 0
				Update_Data_Table.LoadingFuncsIndex = Update_Data_Table.LoadingFuncsIndex + 1
				curprogress = Update_Data_Table.LoadingFuncs[Update_Data_Table.LoadingFuncsIndex]()
			end
			if Update_Data_Table.LoadingFuncsIndex >= #Update_Data_Table.LoadingFuncs then
				Update_Data_Table.LoadingFuncs = nil
				Update_Data_Table.LoadingFuncsIndex = nil
				reset_loading_control_param()
				--ui_show_ip59(0)
			else
				if type(curprogress) == "number" then
					update_ui_set_loading_progress(curprogress)
					Update_Data_Table.LoadingFuncsIndex = Update_Data_Table.LoadingFuncsIndex + 1
					Update_Data_Table.Status = Update_RuningStatus_TypeDef.Delay
				elseif curprogress == "erro" then
					local errStr = tostring(xlPlayer_GetUID()).."-"..tostring(xlUpdateGetInfo(2)).."- game.so init erro".."-game_up.ss"
					xlAppAnalysis("error",0,1,"info",string.sub(errStr,0,110))
					xlUI_Show(Erro_Frm.Main_Game,1)
				end
			end
		end
	elseif Update_Data_Table.Status == Update_RuningStatus_TypeDef.Delay then
		Update_Data_Table.Status = Update_RuningStatus_TypeDef.Updating
	end
end

-- ui循环
local function ui_win_updating_loop(frame)
	Update_Data_Table.UpdateFrame = frame
	if Update_Data_Table.Status == Update_RuningStatus_TypeDef.Start then
		Update_Data_Table.Status = Update_RuningStatus_TypeDef.Updating
		ui_play_update_ani()
		update_ui_set_loading_progress_title(Update_String_Table["Updating_Loading_Info"])
		Update_Data_Table.ConnectStartFrame = frame
		if 0 == xlUpdateEvent(4) then
			Update_Data_Table.IsOk = false
		end
	elseif Update_Data_Table.Status == Update_RuningStatus_TypeDef.Updating then
		if true == Update_Data_Table.IsConnected then
			Update_Data_Table.IsConnected = false
			Update_Data_Table.ConnectStartFrame = frame
		else
			if frame - Update_Data_Table.ConnectStartFrame >= 1800 then
				update_ui_show(Update_WinType_TypeDef.Up2)
			end
		end
		for i = 1,5 do
			xlUpdateEvent(3)
		end
	end
end

local function do_finish_update()
	Update_Data_Table.Status = Update_RuningStatus_TypeDef.Skip
	if false == Update_Data_Table.IsOk then
		game_update_button_update_click()
		--xlLG("rrr","do_finish_update 1111\n")
	else
		game_update_button_start_click()
		--xlLG("rrr","do_finish_update 2222\n")
	end
end

local function ui_win_main_loop(frame)
	if 1 == Update_Data_Table.Mode then
		if Update_Data_Table.Status == Update_RuningStatus_TypeDef.Start then
			--[[  
			--注掉打开公告的地方
			if type(xlUpdate_OpenUrl) == "function" then
				local accounttype = CCUserDefault:sharedUserDefault():getIntegerForKey("xl_account_test")
				if 0 == accounttype then --非测试员
					if 1 == g_language_setting or 2 == g_language_setting then
						if Update_Data_Table.PlatForm == g_tTargetPlatform.kTargetIphone or Update_Data_Table.PlatForm == g_tTargetPlatform.kTargetAndroid then
							if (newtd == 1) then --魔塔前线定义"newtd" = 1
								xlUpdate_OpenUrl("http://bbs.xingames.com/notices/mota/notice_release_ip_SC.html")
							else
								xlUpdate_OpenUrl("http://bbs.xingames.com/notices/td/notice_release_ip_SC.html")
							end
						else
							if (newtd == 1) then --魔塔前线定义"newtd" = 1
								xlUpdate_OpenUrl("http://bbs.xingames.com/notices/mota/notice_release_SC.html")
							else
								xlUpdate_OpenUrl("http://bbs.xingames.com/notices/td/notice_release_SC.html")
							end
						end
					elseif 3 == g_language_setting then
						if Update_Data_Table.PlatForm == g_tTargetPlatform.kTargetIphone or Update_Data_Table.PlatForm == g_tTargetPlatform.kTargetAndroid then
							xlUpdate_OpenUrl("http://bbs.xingames.com/notices/td/notice_release_ip_TC.html")
						else
							xlUpdate_OpenUrl("http://bbs.xingames.com/notices/td/notice_release_TC.html")
						end
					elseif 4 == g_language_setting then
						if Update_Data_Table.PlatForm == g_tTargetPlatform.kTargetIphone or Update_Data_Table.PlatForm == g_tTargetPlatform.kTargetAndroid then
							xlUpdate_OpenUrl("http://bbs.xingames.com/notices/td/notice_release_ip_EN.html")
						else
							xlUpdate_OpenUrl("http://bbs.xingames.com/notices/td/notice_release_EN.html")
						end
					else
						xlUpdate_OpenUrl("http://bbs.xingames.com/notices/td/notice_release_SC.html")
					end
				else
					if Update_Data_Table.PlatForm == g_tTargetPlatform.kTargetIphone or Update_Data_Table.PlatForm == g_tTargetPlatform.kTargetAndroid then
						xlUpdate_OpenUrl("http://bbs.xingames.com/notices/td/notice_debug_ip.html")
					else
						xlUpdate_OpenUrl("http://bbs.xingames.com/notices/td/notice_debug.html")
					end
				end
			end
			--]]
			Update_Data_Table.CanEnterGame = false
			Update_Data_Table.CheckNetWork = 0
			Update_Data_Table.Status = Update_RuningStatus_TypeDef.GetAnnouncementInfo
		elseif Update_Data_Table.Status == Update_RuningStatus_TypeDef.GetAnnouncementInfo then
			Update_Data_Table.Status = Update_RuningStatus_TypeDef.GetLocalInfo
		elseif Update_Data_Table.Status == Update_RuningStatus_TypeDef.GetLocalInfo then
			local nUpdateStatus = xlUpdateGetInfo(4)
			if 2 == nUpdateStatus or 4 == nUpdateStatus then
				Update_Data_Table.IsOk = true
				--xlLG("rrr","Update_Data_Table.IsOk true\n")
			else
				Update_Data_Table.IsOk = false
				--xlLG("rrr","Update_Data_Table.IsOk false\n")
			end
			Update_Data_Table.Status = Update_RuningStatus_TypeDef.GetNetWorkType
		elseif Update_Data_Table.Status == Update_RuningStatus_TypeDef.GetNetWorkType then
			local nettype = xlGetNetType()
			if 0 == nettype then
				Update_Data_Table.NetType = Update_NetWork_TypeDef.none
			elseif 1 == nettype then
				Update_Data_Table.NetType = Update_NetWork_TypeDef.wifi
			elseif 2 == nettype then
				Update_Data_Table.NetType = Update_NetWork_TypeDef.g3
			end
			Update_Data_Table.IsConnected = false
			Update_Data_Table.CanUpdate = false
			Update_Data_Table.UpdateFromApp = 0
			if 0 == nettype then
				Update_Data_Table.Status = Update_RuningStatus_TypeDef.End
				return
			end
			if true == Update_Data_Table.ShowSelServer then
			else
				local accounttype = CCUserDefault:sharedUserDefault():getIntegerForKey("xl_account_test")
				if 0 == accounttype then
					Update_Data_Table.CurrentSelServer = 1			
				else
					Update_Data_Table.CurrentSelServer = 2
				end			
			end
			if 0 == xlUpdateEvent(1,Update_Data_Table.CurrentSelServer) then
				Update_Data_Table.Status = Update_RuningStatus_TypeDef.ConnectingServer
				Update_Data_Table.ConnectStartFrame = frame
			else
				Update_Data_Table.Status = Update_RuningStatus_TypeDef.End
			end
		elseif Update_Data_Table.Status == Update_RuningStatus_TypeDef.ConnectingServer then
			if true == Update_Data_Table.IsConnected then
				Update_Data_Table.Status = Update_RuningStatus_TypeDef.GetServerInfo
			else
				if frame - Update_Data_Table.ConnectStartFrame >= Update_Data_Table.NetOverTick then
					update_ui_refresh_version_panel()
					Update_Data_Table.Status = Update_RuningStatus_TypeDef.End
				end
			end
			local labeloffy = 0
			if Update_Data_Table.PlatForm == g_tTargetPlatform.kTargetIphone or Update_Data_Table.PlatForm == g_tTargetPlatform.kTargetAndroid then --ip/android
				labeloffy = -14
			end
			local size = CCDirector:sharedDirector():getOpenGLView():getDesignResolutionSize()
			--帧数倒计时
			local leftFrame = Update_Data_Table.NetOverTick + Update_Data_Table.ConnectStartFrame - frame
			if leftFrame > 0 then
				if Update_Ui_Table.ButtonTable["waitserver"] then
					--用剩余帧数设置为本...
					local webinfo = tonumber(Update_Data_Table.WebStatus)
					local str = Update_String_Table["Main_Runing_GetInfo"]
					local labx = 190
					if webinfo == 11 then
						labx = 178
						str = Update_String_Table["Main_Runing_GetInfo11"]
					elseif webinfo == 88 then
						labx = 178
						str = Update_String_Table["Main_Runing_GetInfo88"]
					elseif webinfo == 99 then
						str = Update_String_Table["Main_Runing_GetInfo99"]
					end
					str = str .. "(" .. math.floor(leftFrame/60) .. ")"
					xlUI_SetButtonLabel(Update_Ui_Table.ButtonTable["waitserver"], labx, - 20 + labeloffy, str)
					print("leftFrame",leftFrame)
				end
			else
				print("leftFrame",0)
				leftFrame = 0 
				if Update_Ui_Table.ButtonTable["waitserver"] then
					xlUI_SetButtonLabel(Update_Ui_Table.ButtonTable["waitserver"], 186, - 20 + labeloffy, "")
				end
			end
			
			xlUpdateEvent(3)
		elseif Update_Data_Table.Status == Update_RuningStatus_TypeDef.GetServerInfo then
			update_ui_refresh_version_panel()
			Update_Data_Table.Status = Update_RuningStatus_TypeDef.End
		elseif Update_Data_Table.Status == Update_RuningStatus_TypeDef.End then
			if 60 == Update_Data_Table.CheckNetWork then
				Update_Data_Table.CheckNetWork = 0
				local nettype = xlGetNetType()
				if 0 == nettype then
					Update_Data_Table.NetType = Update_NetWork_TypeDef.none
				elseif 1 == nettype then
					Update_Data_Table.NetType = Update_NetWork_TypeDef.wifi
				elseif 2 == nettype then
					Update_Data_Table.NetType = Update_NetWork_TypeDef.g3
				end
			else
				Update_Data_Table.CheckNetWork = Update_Data_Table.CheckNetWork + 1
			end
			Update_Data_Table.CanEnterGame = true
			do_finish_update()
		end
	else
		
	end
end

function UpdateRunCallBack(frame)
	if Update_Ui_Table.Win.CurrentWin == Update_WinType_TypeDef.None then
	elseif Update_Ui_Table.Win.CurrentWin == Update_WinType_TypeDef.Loading then
		ui_win_loading_loop(frame)
	elseif Update_Ui_Table.Win.CurrentWin == Update_WinType_TypeDef.Updating then
		ui_win_updating_loop(frame)
	elseif Update_Ui_Table.Win.CurrentWin == Update_WinType_TypeDef.Main then
		ui_win_main_loop(frame)
	elseif Update_Ui_Table.Win.CurrentWin == Update_WinType_TypeDef.EnterGame then
		
	end
end

-- 更新管理器各种回调
function xlLuaEvent_UpdateEvent(nEvent,param1,param2,param3,param4)
	print("xlLuaEvent_UpdateEvent  :" .. nEvent .. " \n")
	if 1 == nEvent then
		Update_Data_Table.IsOk = true
		Update_Data_Table.IsConnected = true
		Update_Data_Table.CanUpdate = false
		update_ui_refresh_version_panel()
	
	elseif 2 == nEvent then
		Update_Data_Table.IsOk = true
		Update_Data_Table.IsConnected = true
		Update_Data_Table.CanUpdate = false
		
		update_ui_show(Update_WinType_TypeDef.None)
		Update_Data_Table.InitGame = false
		xlUpdateEvent(5)
		--xlLG("rrr","xlLuaEvent_UpdateEvent  222222 \n")
	elseif 3 == nEvent then
		Update_Data_Table.IsConnected = true
		local vSameAppVersion = xlUpdateGetInfo(5) -- 1 服务器版本比客户端大 0 相等
		--xlLG("rrr","xxx get update info sameappversion:" .. vSameAppVersion .. " \n")
		if 1 == vSameAppVersion then
			local iChannelId = getChannelInfo()
			if 1001 == iChannelId then
				Update_Data_Table.CanUpdate = true
				Update_Data_Table.UpdateFromApp = 0
			else
				Update_Data_Table.CanUpdate = false
				Update_Data_Table.UpdateFromApp = 1
			end
		elseif 0 == vSameAppVersion then
			local tmVersion = false
			local accounttype = CCUserDefault:sharedUserDefault():getIntegerForKey("xl_account_test")
			--xlLG("rrr","xxxxxxxxxxxxxxxx  fdggfgfg     atttttttttt:" .. accounttype)
			if 0 == accounttype then
				if type(param4) == "string" then
					local sB44,sE44 = string.find(param4,"44")
					if sB44 and sE44 then
						tmVersion = true
					end
					local sB66,sE66 = string.find(param4,"66")
					if sB66 and sE66 then
						tmVersion = true
					end
					local sB88,sE88 = string.find(param4,"88")
					if sB88 and sE88 then
						tmVersion = true
					end
				
					local lastFlag = tostring(string.sub(param4,10,10))
					--xlLG("rrr","xxxxxxxxxxxxxxxx  fdggfgfg     atttttttttt flag:" .. param4 .. " len:" .. string.len(param4) .. " \n")
					--xlLG("rrr","xxxxxxxxxxxxxxxx  fdggfgfg     atttttttttt flag:" .. tostring(lastFlag))
					if "1" == lastFlag or "3" == lastFlag or "5" == lastFlag or "7" == lastFlag or "9" == lastFlag then
					--else
						Update_Data_Table.ExitWhenUpdate = true
						--print("xxxxxxxxxxxx rrrrrrrrrrrrrr Update_Data_Table.ExitWhenUpdate = true \n")
					end
				end
			end
			
			if true == tmVersion then
				Update_Data_Table.CanUpdate = false
			else
				Update_Data_Table.CanUpdate = true
			end
			Update_Data_Table.UpdateFromApp = 0
		else
			Update_Data_Table.CanUpdate = false
			Update_Data_Table.UpdateFromApp = -1
		end
			
		Update_Data_Table.TotalFiles = param1
		Update_Data_Table.CurrentFiles = 0
		Update_Data_Table.TotalFileLen = param2
		Update_Data_Table.TotalFileDownLoad = 0
		
		
		update_ui_refresh_version_panel()
		
	elseif 4 == nEvent then
		Update_Data_Table.CurrentFiles = param1
		Update_Data_Table.CurrentFileName = param3
		Update_Data_Table.CurrentFileLen = param2
		Update_Data_Table.TotalFileDownLoad = Update_Data_Table.TotalFileDownLoad + Update_Data_Table.CurrentFileDownLoad
		Update_Data_Table.CurrentFileDownLoad = 0
		Update_Data_Table.IsConnected = true
		
		update_ui_refresh_updating_panel()
	elseif 5 == nEvent then
		Update_Data_Table.IsConnected = true
		Update_Data_Table.ConnectStartFrame = Update_Data_Table.UpdateFrame
		Update_Data_Table.CurrentFileDownLoad = param1

		update_ui_refresh_updating_panel()
	elseif 100 == nEvent then
		--if type(xlGame_ClearAll) == "function" then
		--	xlGame_ClearAll()
		--end
		if true == Update_Data_Table.ExitWhenUpdate then
			update_ui_show(Update_WinType_TypeDef.Exit)
		else
			CCFileUtils:sharedFileUtils():purgeCachedEntries()
			game_update_button_enter_game()
		end
	elseif 211 == nEvent then
		--[[
		if type(xlCreateWebView) == "function" then
			local size = CCDirector:sharedDirector():getOpenGLView():getDesignResolutionSize()
			--print("xxxxxx oooooo size.width:" .. size.width .. " size.height:" .. size.height .. "\n")
			total,free,usedByMe = xlGetMemoryInfo()
			if size.width == 960 and size.height == 640 then -- ip4s
				xlCreateWebView(10,60,222,(size.height - 150)/2)
				Lua_xlShowWebView(0)
			elseif size.width == 1136 and size.height == 640 then -- ip5
				xlCreateWebView(10,60,250,(size.height - 150)/2)
				Lua_xlShowWebView(0)
			else
				xlCreateWebView(20,120,500,(size.height - 150))
				Lua_xlShowWebView(0)
			end
		end
		]]
		if type(xlCreateWebViewNew) == "function" then
			local size = CCDirector:sharedDirector():getOpenGLView():getDesignResolutionSize()
			--print("xxxxxx oooooo size.width:" .. size.width .. " size.height:" .. size.height .. "\n")
			total,free,usedByMe = xlGetMemoryInfo()
			if size.width == 960 and size.height == 640 then --iPhone4
				xlCreateWebViewNew(15,156,448,(size.height - 212))
			elseif size.width == 1136 and size.height == 640 then --iPhone5
				xlCreateWebViewNew(76,156,500,(size.height - 212))
			elseif size.width == 1280 and size.height == 720 then --iPhone6, iPhone7, iPhone8
				xlCreateWebViewNew(138,156,500,(size.height - 212))
			elseif size.width == 1560 and size.height == 720 then --iPhoneX
				xlCreateWebViewNew(288,156,500,(size.height - 212))
			else --iPad
				xlCreateWebViewNew(20,156,500,(size.height - 212))
			end
			Lua_xlShowWebView(0)
		end
		Update_Data_Table.IsWelcomeStart = true
		xlLuaEvent_TouchBegan()
	elseif 400 == nEvent then
		if 0 == param1 then -- 成功
			
		end
		if type(xlShowWebView) == "function" then
			Lua_xlShowWebView(0)
		end
	end
end

-- initing dir
function update_loading_init_dir()
	local functions = {}
		
	functions[#functions + 1] = function()
		update_ui_set_loading_progress_title(Update_String_Table["CopyDir_Loading_Info"])
		return 0
	end	
	functions[#functions + 1] = function()
		xlUpdateEvent(201)
		return 10
	end
	functions[#functions + 1] = function()
		xlUpdateEvent(201)
		return 40
	end
	functions[#functions + 1] = function()
		xlUpdateEvent(201)
		return 45
	end
	functions[#functions + 1] = function()
		xlUpdateEvent(201)
		return 50
	end
	functions[#functions + 1] = function()
		xlUpdateEvent(201)
		return 55
	end
	functions[#functions + 1] = function()
		xlUpdateEvent(201)
		return 60
	end
	functions[#functions + 1] = function()
		xlUpdateEvent(201)
		return 65
	end	
	functions[#functions + 1] = function()
		xlUpdateEvent(201)
		return 70
	end
	functions[#functions + 1] = function()
		xlUpdateEvent(201)
		return 75
	end	
	functions[#functions + 1] = function()
		xlUpdateEvent(201)
		return 80
	end
	functions[#functions + 1] = function()
		xlUpdateEvent(201)
		return 90
	end
	functions[#functions + 1] = function()
		xlUpdateEvent(201)
		return 100
	end
	functions[#functions + 1] = function()
		xlUpdateEvent(201)
		if 0 == xlUpdateEvent(100) then
			update_ui_show(Update_WinType_TypeDef.Main)
		end
		return 0
	end
	
	Update_Data_Table.LoadingFuncs = functions
end

local shouldCreateLoadingRedbtn = {0,0}
function create_loading_redbtn(index)
	if shouldCreateLoadingRedbtn[index] == 0 then
		shouldCreateLoadingRedbtn[index] = 1
	else
		return
	end
	local winfrm = Update_Ui_Table.Win.Loading
	if index == 1 then
		winfrm = Update_Ui_Table.Win.Main_Loading
	end
	local btnoffx = 0
	local btnoffy = 0
	if g_Background_Index == 2 then
		btnoffx = -1
		btnoffy = 5
	elseif g_Background_Index == 3 then
		btnoffy = 12
	end

	local imgsrc = "data/image/misc/redbtn".. g_Background_Index .."_2.png"
	print("imgsrc",imgsrc)
	button = xlUI_CreateButton(166, 118, imgsrc, 0, 1);
	xlUI_AddButton(winfrm, button, 344+btnoffx, 244+btnoffy) --坐标
	xlUI_EnableTouch(button,0)
end

-- loading map sa
function update_loading_game_sa(sa)
	Update_Data_Table.RunGameStart = true
	xlUpdateEvent(2)
	local gamestartfuncs = game_start()
	local functions = {}
	functions[#functions + 1] = function()
		local size = CCDirector:sharedDirector():getOpenGLView():getDesignResolutionSize()
		if size.width > size.height then
			update_ui_set_loading_progress_title(Update_String_Table["GameStart_Loading_Info"])
		else
			xlUI_SetButtonLabel(Update_Ui_Table.ButtonTable["current_progress"], 0, -40, "", 360, 64, 1, 1)
		end
		Update_Data_Table.InitGame = true
		ui_play_update_ani()
		return 0
	end
	for i = 1,#gamestartfuncs do
		functions[#functions + 1] = gamestartfuncs[i]
	end

	if nil == sa then
		functions[#functions + 1] = function()
			enter_game("local")
			return 100
		end
	else
		functions[#functions + 1] = function()
			enter_game("online",sa)
			return 100
		end	
	end
	
	functions[#functions + 1] = function()
		update_ui_show(Update_WinType_TypeDef.None)
		return 100
	end
	Update_Data_Table.LoadingFuncs = functions
end

-- 按钮响应
function update_ui_buttonclick(button, tag)
	if type(Update_Ui_Table.ButtonTable_Handle[button]) == "function" then	
		Update_Ui_Table.ButtonTable_Handle[button](tag)
	end
end

function xlLuaEvent_ButtonClick(button,tag)
	update_ui_buttonclick(button,tag)
end

function game_update_button_login_click(playername)
	xlScene_Switch(Update_Ui_Table.Scene)

	if true == Update_Data_Table.IsOk then
		if true == Update_Data_Table.InitGame then
			if true == Update_Data_Table.InitGame then
				update_ui_show(Update_WinType_TypeDef.None)
				enter_game("online",playername)
			end
		else
			update_loading_game_sa(playername)
			update_ui_show(Update_WinType_TypeDef.Loading)
		end
	end
end

-- 更新游戏按钮点击
function game_update_button_update_click()
	print("更新")
	if true == Update_Data_Table.CanUpdate then
		update_ui_show(Update_WinType_TypeDef.Updating)
	else
		if false == Update_Data_Table.IsOk then
			update_ui_show(Update_WinType_TypeDef.Up2)
		end
	end
end

-- 进入游戏按钮点击
function game_update_button_start_click()
	--xlLG("rrr","Game_Sa")
	if true == Update_Data_Table.IsOk and true == Update_Data_Table.CanEnterGame then
		if true == Update_Data_Table.CanUpdate then
			--xlLG("rrr","xxx can update now ... \n")
			if 1 == g_mode_skip_update then
				game_update_button_enter_game()
			else
				local res = xlUpdateGetInfo(8)
				--xlLG("rrr","xxxxxxxxxxxx Game_Sa res = " .. res .. "\n")
                if 49 == res then
                    update_ui_show(Update_WinType_TypeDef.EnterGame,1)
                else
                    update_ui_show(Update_WinType_TypeDef.EnterGame,0)
                end
			end
		else
			--xlLG("rrr","xxx can not update now ... \n")
			if 1 == Update_Data_Table.UpdateFromApp then
				local res = xlUpdateGetInfo(8)
				if 51 == res then
					game_update_button_enter_game()
				else
					xlUI_SetButtonLabel(Update_Ui_Table.ButtonTable["exit_info"],40,133, Update_String_Table["Version_Update_FromApp"])
					update_ui_show(Update_WinType_TypeDef.AppStore)
					
					--测试 --test
					--test_no_AppStore()
					--test_update_process()
				end
			else
				game_update_button_enter_game()
			end
		end
	end
end

-- 游戏论坛按钮点击
function game_update_button_bbs_click()
	print("Game_Bbs")
	if g_tTargetPlatform.kTargetWindows ~= Update_Data_Table.PlatForm then                  
		update_ui_show(Update_WinType_TypeDef.None)
	end

	update_ui_show_gamebbs_scene()
end

function game_update_button_back2main_click()
	xlScene_Switch(Update_Ui_Table.Scene)
	update_ui_show(Update_WinType_TypeDef.Main)
end

function game_update_button_back2LastScene_click()
	print("back from Game_Bbs\n")

	--if g_phone_mode == nil or type(g_phone_mode) == "number" and g_phone_mode == 0 then
		--local lastScene = g_last_scene;
		--if lastScene == nil then
			--lastScene = Update_Ui_Table.Scene;
		--end
    
		--xlScene_Switch(lastScene)
		----如果 返回的上一个是玩家列表 则调用一次 脚本UI事件 刷新玩家列表
		--if lastScene == g_playerlist then
			--hGlobal.event:event("LocalEvent_ShowPlayerListFram",Save_playerList,g_game_mode,g_curPlayerName)
		--end
    
		--if lastScene == Update_Ui_Table.Scene then
			--update_ui_show(Update_WinType_TypeDef.Main)
		--end
	--elseif type(g_phone_mode) == "number" and g_phone_mode > 0 then
		--hGlobal.event:event("LocalEvent_OpenPhoneMainMenu")
		hGlobal.event:event("LocalEvent_Phone_ShowPhone_SelecteMap", 1)
	--end
end

function game_update_button_serverlist_click(index)
	print("sel server list index:" .. index)
	if index == Update_Data_Table.CurrentSelServer then
		return
	else
		update_ui_show_server_selected(index)
		Update_Data_Table.CheckNetWork = 0
		xlUI_Show(Update_Ui_Table.ButtonTable["update_version_update"],0)			
		xlUI_Show(Update_Ui_Table.ButtonTable["update_version_update_icon"],0)
		update_ui_refresh_current_status(Update_String_Table["Main_Runing_GetAnnouncement"])
		Update_Data_Table.Status = Update_RuningStatus_TypeDef.GetAnnouncementInfo
	end
end

function game_update_button_enter_game()
	if true == Update_Data_Table.InitGame then
		if true == Update_Data_Table.InitGame then
			update_ui_show(Update_WinType_TypeDef.None)
			ui_remove_update_ani()
			enter_game("local")
		end
	else
		update_loading_game_sa()
		update_ui_show(Update_WinType_TypeDef.Loading)
	end
end

function game_update_set_server_version(version)
	Update_Data_Table.ServerVersion = version
end

function game_update_is_level_loaded(nLevel)
	local nMaxLevel = xlUpdateEvent(47)
	if nMaxLevel >= nLevel then
		return true
	else
		return false
	end
end

--*************************************************************
-- http回调
---------------------------------------------------------------
g_event_http = 0
function xlError_CFunc(err)
	--print("http err:",err)
	g_event_http = 1
	xlLuaEvent_UpdateEvent(211)
end
--http response
function callback_httpresponse(p1,p2,p3,p4)
	print("callback_httpresponse xxxxxxxxxxxxxxxx:",p1,p2,p3,p4)
	if "number" == type(p2) and 200 == p2 and "string" == type(p3) and "ok" == p3 and "string" == type(p4) then
		local dostring2 = function(sss)
			local f = loadstring(sss)
			if type(f) == "function" then	
				f()
			end
		end
		
		dostring2(p4)
		
		--选择各类服务器
		--战车
		if (p1 == "update") then
			--收到web的返回 也可能是404
			Update_Data_Table.WebStatus = 99

			--print("g_ip_list",g_ip_list)
			--服务器列表
			local t = g_ip_list or {}
			
			--渠道号
			local iChannelId = 0
			local iChannelVersion = 2022020202
			if xlGetChannelId then
				iChannelId = xlGetChannelId()
			end
			if xlGetChannelVersion then
				iChannelVersion = xlGetChannelVersion()
			end
			
			--更新服务器2选1
			if "table" == type(t.up1) and "table" == type(t.up2) then
				Update_Data_Table.WebStatus = 11

				local t1_length = (#t.up1)
				local t2_length = (#t.up2)
				if (t1_length > 0) and (t2_length > 0) then
					local randValue1 = math.random(1, t1_length)
					local randValue2 = math.random(1, t2_length)
					local tmp_up1 = t.up1[randValue1]
					local tmp_up2 = t.up2[randValue2]
					xlUpdateResetServerList(tmp_up1,tmp_up2)
					print("from web services up1="..tmp_up1, "up2="..tmp_up2)
				end
			end

			--print(t.ios,iChannelVersion)

			--ios审核版本跳过更新
			if "number" == type(t.ios) and t.ios == iChannelVersion then
				Update_Data_Table.WebStatus = 88
				Update_Data_Table.NetOverTick = 61
				--这里其实需要加个当前平台是否IOS的判断但是因为审核很快所以也还好。。。
				local tmp_up1 = "121.199.51.44:55555"
				local tmp_up2 = "121.199.51.44:55555"
				xlUpdateResetServerList(tmp_up1,tmp_up2)
			end
			
			--游戏服务器3选1
			if "table" == type(t.game) then
				local t_length = (#t.game)
				if (t_length > 0) then
					local randValue = math.random(1, t_length)
					local tmp_game = t.game[randValue]
					g_gameserver_host = tmp_game
					print("game="..tmp_game)
				end
			end
		end
	end
	
	--一定要放最后执行
	g_event_http = 1
	xlLuaEvent_UpdateEvent(211)
end

--*************************************************************
-- 以下函数该模块没用 但因为主程序会统一调用 所以需要实现
---------------------------------------------------------------
function xlLuaEvent_SwitchScene(scene) end
function xlLuaEvent_KeyUp(key, ctrl, shift) end
function xlLuaEvent_TouchBegan(screenX, screenY, worldX, worldY) 	
	if Update_WinType_TypeDef.Welcome == Update_Ui_Table.Win.CurrentWin and true == Update_Data_Table.IsWelcomeStart then
		xlScene_LoadBackground(Update_Ui_Table.Scene,g_Background_vertical[g_Background_Index])
		--if g_Cur_Language == 1 then
			--xlScene_LoadBackground(Update_Ui_Table.Scene,"other/logintv")
		--else
			--xlScene_LoadBackground(Update_Ui_Table.Scene,"other/loading_en")
		--end
		total,free,usedByMe = xlGetMemoryInfo()
		--print("666666666666 usdmem total:" .. total .. " free:" .. free .. " usedByMe:" .. usedByMe .. " \n")
		if 0 == Update_Data_Table.Mode then
			update_ui_show(Update_WinType_TypeDef.Main)
		else
			if 0 == xlUpdateEvent(200) then
				update_loading_init_dir()
				update_ui_show(Update_WinType_TypeDef.Loading)
			else
				update_ui_show(Update_WinType_TypeDef.Main)
			end
		end
	end
end
function xlLuaEvent_TouchUp(screenX, screenY, worldX, worldY) end




--*************************************************************
-- 语言模块
---------------------------------------------------------------
--kLanguageEnglish = 1,kLanguageChinese,kLanguageFrench,kLanguageItalian,kLanguageGerman,kLanguageSpanish,kLanguageRussian,kLanguageKorean
g_myapp_url_us = "https://apps.apple.com/cn/app/id6443552084"
g_myapp_url_cn = "https://apps.apple.com/cn/app/id6443552084"
g_myapp_url = "https://apps.apple.com/cn/app/id6443552084"
if (newtd == 1) then --魔塔前线定义"newtd" = 1
	--
end
function xlGame_Language_Type_Get()
	local ltype = CCUserDefault:sharedUserDefault():getIntegerForKey("xl_language_type")
	print("xlGame_Language_Type_Get111 type:" .. ltype)
	if ltype > 0 then
	else
		ltype = CCApplication:sharedApplication():getCurrentLanguage() + 1
		CCUserDefault:sharedUserDefault():setIntegerForKey("xl_language_type",ltype)
		CCUserDefault:sharedUserDefault():flush()
	end
	print("xlGame_Language_Type_Get222 type:" .. ltype)
	if 1 == ltype then
		--g_myapp_url = g_myapp_url_us
	end
	return ltype
end
function xlGame_Language_Type_Set(language)
	CCUserDefault:sharedUserDefault():setIntegerForKey("xl_language_type",language)
	CCUserDefault:sharedUserDefault():flush()
	print("xlGame_Language_Type_Set type:" .. language)
	if 1 == language then
		--g_myapp_url = g_myapp_url_us
	end
end

--*************************************************************
-- loading 动画
---------------------------------------------------------------
-- [弃用]转圈等待帧动画
function ui_init_loading_ani()
	local tex = CCTextureCache:sharedTextureCache():addImage(__IMG("data/image/effect/waiting.png"))
	print("xxxxxxx tex:" .. tostring(tex) .. "\n")
	local farry = CCArray:create()
	for j = 1,4 do
		for i = 1,4 do
			farry:addObject(CCSpriteFrame:createWithTexture(tex, CCRectMake((i-1)*64,(j-1)*64,64,64)))
		end
	end
	local animation = CCAnimation:createWithSpriteFrames(farry, 0.2)
	local s = CCSprite:create()
	s:runAction(CCRepeatForever:create(CCAnimate:create(animation)))
	xlUI_AddChild(Update_Ui_Table.Win.Main_Loading,s)
	local size = CCDirector:sharedDirector():getOpenGLView():getDesignResolutionSize()
	if size.width > size.height then
		s:setPosition(ccp(Update_Data_Table.DesignResolutionSize.width/2 + 50,-(Update_Data_Table.DesignResolutionSize.height/2)))
	else
		s:setPosition(ccp(Update_Data_Table.DesignResolutionSize.width/2+75,-(Update_Data_Table.DesignResolutionSize.height/2) + 150))
	end
end

--*************************************************************
-- update 动画
---------------------------------------------------------------
-- 代码瀑布特效背景帧动画
function ui_init_update_ani()
	print("ui_init_update_ani")
	if _update_s then
		if _update_s.s == nil then
			print("_update_s.s == nil")
			local s = CCSprite:create()
			s:setScaleX(1.5)
			s:setScaleY(1.5)
			_update_s:addChild(s,1)
			_update_s.s = s
			_update_s.s:setPosition(ccp(300, 0))
		end
		if #_update_texlist == 0 then
			for i = 1,20 do
				local path = string.format("data/image/panel/update/000%02d.png",i)
				_update_texlist[i] = CCTextureCache:sharedTextureCache():addImage(__IMG(path))
			end
		end
	end
end

-- 播放代码瀑布帧动画
function ui_play_update_ani()
	ui_init_update_ani()
	if _update_s and _update_s.s and _update_s.haveaction ~= 1 then
		local texW = 256
		local texH = 277
		local farry = CCArray:create()
		for i = 1,#_update_texlist do
			--print("xxxxxxx tex:" .. tostring(_update_texlist[i]) .. "\n")
			farry:addObject(CCSpriteFrame:createWithTexture(_update_texlist[i], CCRectMake(0,0,256,277)))
		end
		local animation = CCAnimation:createWithSpriteFrames(farry, 0.1)
		_update_s.s:runAction(CCRepeatForever:create(CCAnimate:create(animation)))
		_update_s.haveaction = 1
	end
end

-- 移除代码瀑布帧动画
function ui_remove_update_ani()
	print("ui_remove_update_ani")
	if _update_s then
		if _update_s.s then
			_update_s.s:stopAllActions()
			_update_s.s:getParent():removeChild(_update_s,true)
			_update_s.s = nil
		end
		_update_s.haveaction = nil
	end
	for i = 1,#_update_texlist do
		local tex = _update_texlist[i]
		_update_texlist[i] = 0
		CCTextureCache:sharedTextureCache():removeTexture(tex)
	end
	_update_texlist = {}
end

function test_no_AppStore()
	xlUI_Show(Update_Ui_Table.Win.EnterGame,1)
	game_update_button_enter_game()
end

function test_update_process()
	update_ui_show(Update_WinType_TypeDef.Updating)
	--update_ui_show(Update_WinType_TypeDef.Up2)
	--update_ui_show(Update_WinType_TypeDef.Main)
	--update_ui_init_entergame()
	--xlUI_Show(Update_Ui_Table.Win.EnterGame,1)
	
end


--*************************************************************
-- share
---------------------------------------------------------------
function init_share_ui()
	local y = 488
	local w = 64
	local h = 72
	if Update_Data_Table.PlatForm == g_tTargetPlatform.kTargetIphone then
		y = 258
		w = 51
		h = 57
	end
	if 4 == g_language_setting then -- 英文
		local spx = 105
		CCUserDefault:sharedUserDefault():setStringForKey("xl_share_image","share.png")
		CCUserDefault:sharedUserDefault():setStringForKey("xl_share_btn","sharebtn_en.png")
		
		CCUserDefault:sharedUserDefault():setIntegerForKey("xl_share_count",5)

		CCUserDefault:sharedUserDefault():setStringForKey("xl_share_1_name","facebook")
		CCUserDefault:sharedUserDefault():setStringForKey("xl_share_1_icon","share_facebook.png")
		CCUserDefault:sharedUserDefault():setIntegerForKey("xl_share_1_x",22)
		CCUserDefault:sharedUserDefault():setIntegerForKey("xl_share_1_y",y)
		CCUserDefault:sharedUserDefault():setIntegerForKey("xl_share_1_w",w)
		CCUserDefault:sharedUserDefault():setIntegerForKey("xl_share_1_h",h)

		CCUserDefault:sharedUserDefault():setStringForKey("xl_share_2_name","twitter")
		CCUserDefault:sharedUserDefault():setStringForKey("xl_share_2_icon","share_twitter.png")
		CCUserDefault:sharedUserDefault():setIntegerForKey("xl_share_2_x",22+spx)
		CCUserDefault:sharedUserDefault():setIntegerForKey("xl_share_2_y",y)
		CCUserDefault:sharedUserDefault():setIntegerForKey("xl_share_2_w",w)
		CCUserDefault:sharedUserDefault():setIntegerForKey("xl_share_2_h",h)

		CCUserDefault:sharedUserDefault():setStringForKey("xl_share_3_name","googleplus")
		CCUserDefault:sharedUserDefault():setStringForKey("xl_share_3_icon","share_google+.png")
		CCUserDefault:sharedUserDefault():setIntegerForKey("xl_share_3_x",22+spx*2)
		CCUserDefault:sharedUserDefault():setIntegerForKey("xl_share_3_y",y)
		CCUserDefault:sharedUserDefault():setIntegerForKey("xl_share_3_w",w)
		CCUserDefault:sharedUserDefault():setIntegerForKey("xl_share_3_h",h)

		CCUserDefault:sharedUserDefault():setStringForKey("xl_share_4_name","wx_session")
		CCUserDefault:sharedUserDefault():setStringForKey("xl_share_4_icon","share_wechat_en.png")
		CCUserDefault:sharedUserDefault():setIntegerForKey("xl_share_4_x",22+spx*3)
		CCUserDefault:sharedUserDefault():setIntegerForKey("xl_share_4_y",y)
		CCUserDefault:sharedUserDefault():setIntegerForKey("xl_share_4_w",w)
		CCUserDefault:sharedUserDefault():setIntegerForKey("xl_share_4_h",h)

		CCUserDefault:sharedUserDefault():setStringForKey("xl_share_5_name","wx_timeline")
		CCUserDefault:sharedUserDefault():setStringForKey("xl_share_5_icon","share_moments_en.png")
		CCUserDefault:sharedUserDefault():setIntegerForKey("xl_share_5_x",22+spx*4)
		CCUserDefault:sharedUserDefault():setIntegerForKey("xl_share_5_y",y)
		CCUserDefault:sharedUserDefault():setIntegerForKey("xl_share_5_w",w)
		CCUserDefault:sharedUserDefault():setIntegerForKey("xl_share_5_h",h)
	else
		local spx = 88
		if Update_Data_Table.PlatForm == g_tTargetPlatform.kTargetIphone then
			spx = 81
		end
		CCUserDefault:sharedUserDefault():setStringForKey("xl_share_image","share.png")
		CCUserDefault:sharedUserDefault():setStringForKey("xl_share_btn","sharebtn.png")
		
		CCUserDefault:sharedUserDefault():setIntegerForKey("xl_share_count",6)

		CCUserDefault:sharedUserDefault():setStringForKey("xl_share_1_name","wb_sina")
		CCUserDefault:sharedUserDefault():setStringForKey("xl_share_1_icon","share_sina.png")
		CCUserDefault:sharedUserDefault():setIntegerForKey("xl_share_1_x",12)
		CCUserDefault:sharedUserDefault():setIntegerForKey("xl_share_1_y",y)
		CCUserDefault:sharedUserDefault():setIntegerForKey("xl_share_1_w",w)
		CCUserDefault:sharedUserDefault():setIntegerForKey("xl_share_1_h",h)

		CCUserDefault:sharedUserDefault():setStringForKey("xl_share_2_name","wb_tencent")
		CCUserDefault:sharedUserDefault():setStringForKey("xl_share_2_icon","share_tencent.png")
		CCUserDefault:sharedUserDefault():setIntegerForKey("xl_share_2_x",12+spx)
		CCUserDefault:sharedUserDefault():setIntegerForKey("xl_share_2_y",y)
		CCUserDefault:sharedUserDefault():setIntegerForKey("xl_share_2_w",w)
		CCUserDefault:sharedUserDefault():setIntegerForKey("xl_share_2_h",h)

		CCUserDefault:sharedUserDefault():setStringForKey("xl_share_3_name","qzone")
		CCUserDefault:sharedUserDefault():setStringForKey("xl_share_3_icon","share_qqzone.png")
		CCUserDefault:sharedUserDefault():setIntegerForKey("xl_share_3_x",12+spx*2)
		CCUserDefault:sharedUserDefault():setIntegerForKey("xl_share_3_y",y)
		CCUserDefault:sharedUserDefault():setIntegerForKey("xl_share_3_w",w)
		CCUserDefault:sharedUserDefault():setIntegerForKey("xl_share_3_h",h)

		CCUserDefault:sharedUserDefault():setStringForKey("xl_share_4_name","wx_session")
		CCUserDefault:sharedUserDefault():setStringForKey("xl_share_4_icon","share_wechat.png")
		CCUserDefault:sharedUserDefault():setIntegerForKey("xl_share_4_x",12+spx*3)
		CCUserDefault:sharedUserDefault():setIntegerForKey("xl_share_4_y",y)
		CCUserDefault:sharedUserDefault():setIntegerForKey("xl_share_4_w",w)
		CCUserDefault:sharedUserDefault():setIntegerForKey("xl_share_4_h",h)
				
		CCUserDefault:sharedUserDefault():setStringForKey("xl_share_5_name","wx_timeline")
		CCUserDefault:sharedUserDefault():setStringForKey("xl_share_5_icon","share_circle.png")
		CCUserDefault:sharedUserDefault():setIntegerForKey("xl_share_5_x",12+spx*4)
		CCUserDefault:sharedUserDefault():setIntegerForKey("xl_share_5_y",y)
		CCUserDefault:sharedUserDefault():setIntegerForKey("xl_share_5_w",w)
		CCUserDefault:sharedUserDefault():setIntegerForKey("xl_share_5_h",h)

		CCUserDefault:sharedUserDefault():setStringForKey("xl_share_6_name","renren")
		CCUserDefault:sharedUserDefault():setStringForKey("xl_share_6con","share_renren.png")
		CCUserDefault:sharedUserDefault():setIntegerForKey("xl_share_6_x",12+spx*5)
		CCUserDefault:sharedUserDefault():setIntegerForKey("xl_share_6_y",y)
		CCUserDefault:sharedUserDefault():setIntegerForKey("xl_share_6_w",w)
		CCUserDefault:sharedUserDefault():setIntegerForKey("xl_share_6_h",h)
	end
	-- 微信用的url
	local system_lang = ""
	if xlSystemLanguage then
		system_lang = xlSystemLanguage()
	end
	if system_lang == "zh-Hant" or system_lang == "zh-Hant-CN" or system_lang == "zh-TW" or system_lang == "zh-HK" then
		CCUserDefault:sharedUserDefault():setStringForKey("xl_share_url","http%3a%2f%2fmp.weixin.qq.com%2fs%3f__biz%3dMzA4MzMxNTc5OQ%3d%3d%26mid%3d401509306%26idx%3d1%26sn%3d2cf763e4237d84531bafb881e40ce270%23rd")
	else
		CCUserDefault:sharedUserDefault():setStringForKey("xl_share_url","http%3a%2f%2fmp.weixin.qq.com%2fs%3f__biz%3dMzA4MzMxNTc5OQ%3d%3d%26mid%3d401506169%26idx%3d1%26sn%3d0d8bea457b131b1eebb1b81ea8ca1c42%23rd")
	end
	--CCUserDefault:sharedUserDefault():setStringForKey("xl_share_url","http%3a%2f%2fmp.weixin.qq.com%2fs%3f__biz%3dMzA4MDUyMzIwOQ%3d%3d%26mid%3d401235459%26idx%3d1%26sn%3dfd1f347591b5bac79e85d603443df4c9%23rd")
	CCUserDefault:sharedUserDefault():setStringForKey("xl_share_url_qzone","http://www.xingames.com")
	CCUserDefault:sharedUserDefault():setStringForKey("xl_share_url_fb","http://www.facebook.com")
	CCUserDefault:sharedUserDefault():setStringForKey("xl_share_url_tw","http://www.twitter.com")
	CCUserDefault:sharedUserDefault():flush()
end

if type(xlLua2C_setvalue) == "function" then
	local shareinfo = {}
	shareinfo[1] = "我正在绞尽脑汁地玩《策马守天关》!喜欢塔防游戏的都来试试吧!\n 苹果App商店下载地址:\n https://apps.apple.com/cn/app/id1444837687"
	shareinfo[2] = "我正在玩《策马守天关》,喜欢塔防游戏的都来试试吧!\n 苹果App商店下载地址:\n https://apps.apple.com/cn/app/id1444837687"
	shareinfo[3] = "《策马守天关》是三国版塔防,喜欢塔防游戏的都来试试吧!\n 苹果App商店下载地址:\n https://apps.apple.com/cn/app/id1444837687"
	local index = math.random(1,2000)
	index = math.fmod(index,3) + 1
	--print("000000000000000000000000000000000000xxxxxxxxxxxxxxxxxxxxxxxxxxx index:" .. index .. " \n")
	xlLua2C_setvalue(1,shareinfo[index])
	CCUserDefault:sharedUserDefault():setIntegerForKey("xl_language",g_language_setting)
	init_share_ui()
end
--*************************************************************
-- login
---------------------------------------------------------------
LoginServerIP = "121.199.51.44"
LoginServerPort = "9991"
max_connecting_time_ms = 5

--GameForumURL="http://www.xingames.com"
GameForumURL="http://bbs.xingames.com/forum.php?mod=forumdisplay&fid=51"
AccountRegisterURL="http://www.xingames.com/member.php?mod=games"

function xlLoginSuccess(playerName)
    print("game login success: \n"..playerName)

    if type(game_update_button_login_click) == "function" then
        game_update_button_login_click(playerName)
    end
end

--获取渠道信息
-- 0 保留
-- 1 appstore
-- 2 windows
-- 3 kuaiyong
-- 4 itools
-- 5 pp
-- 100 开始为android xinline
-- 101 android 删档1次测试
-- 102 android 删档2次测试
-- 1001 百度越狱版
function getChannelInfo()
	local iChannelId = 0
	local iKuaiyong = 0
	if xlGetChannelId then
		iChannelId = xlGetChannelId()
	else
		local TargetPlatform = CCApplication:sharedApplication():getTargetPlatform()
		if TargetPlatform == g_tTargetPlatform.kTargetWindows then 
			iChannelId = 2
		elseif TargetPlatform == g_tTargetPlatform.kTargetIphone or TargetPlatform == g_tTargetPlatform.kTargetIpad then
			iChannelId = 1
			if xlIsFileExist("ky_install_sign") == 0 then
				iKuaiyong = 1
			end
		else --android
			iChannelId = 100
		end
	end
	
	print(string.format("getChannelInfo iChannelId:%d iKuaiyong:%d\n",iChannelId,iKuaiyong))

	return iChannelId,iKuaiyong
end

--*************************************************************
-- passlist {path(string),level(uint)} 其中level 最小1 99为强制更新
---------------------------------------------------------------
g_table_passlist = {}

--[[
g_table_passlist[#g_table_passlist + 1] = {"data/image/effect/Acid_1.png",1}
]]






xlUpdateEvent(44)