--主基地
hGlobal.UI.InitSystemMenuFram_mainbase = function()
	local tempWeaponList  = {
		[6013] = 1,
		[6014] = 2,
		[6007] = 3,
		[6003] = 4,
		[6006] = 5,
		[6004] = 6,
	}
	--单位转换战术卡道具列表
	hVar.UnitToTacticsItemList = {
		[11016] = 12013,
		[11017] = 12014,
		[11018] = 12015,
		[11019] = 12017,
		[11020] = 12018,
		[11021] = 12019,
		[11022] = 12016,
		[11023] = 12020,
		[11024] = 12021,
		[11025] = 12022,
		[11026] = 12023,
		[11027] = 12024,
		[11028] = 12025,
	}
	--武器显示参数
	local _weaponOff = {
		
	}
	local weaponSelectOff = {
		[6004] = {
			y = 19,
		},
		[6006] = {
			y = 11,
		},
		[6007] = {
			y = 7,
		},
		[6016] = {
			y = 9,
		},
	}
	local weaponUpgradeOff = {
		[6002] = {
			y = 8,
		},
		[6004] = {
			y = 25,
		},
		[6005] = {
			y = 9,
		},
		[6006] = {
			y = 17,
		},
		[6007] = {
			y = 16,
		},
		[6016] = {
			y = 16,
		},
		[6017] = {
			y = 8,
		},
	}
	local _weaponScale = {
		[6004] = 1.3,
	}
	--宠物参数
	local _petInfo = {
		[13041] = {		--瓦力
			x = 4,		--地图上偏移x（负左正右）
		},
		[13042] = {		--犹达
			x = -4,		--地图上偏移x（负左正右）
			y = -16,	--地图上偏移y（负上正下）
		},
		[13043] = {		--支援战机
			x = -5,		--地图上偏移x（负左正右）
			y = 7,		--地图上偏移y（负上正下）
			basex = 17,	--创建的底座偏移x（负左正右）
			basey = -25,	--创建的底座偏移y（负上正下）
			lv_y = 16,	--等级图偏移y
			
		},
		[13044] = {		--刺蛇
			x = 4,		--地图上偏移x（负左正右）
			y = -8,		--地图上偏移y（负上正下）
		},
	}
	--炮塔单位
	local _turretUnit ={
		[5161] = {
			unitid = 7003,
		}
	}
	--时间点（移动操作）
	local _eventPoint_Move = {
		[69998] = {
			[1] = {15,"LocalEvent_EnterEndlessMap",17},
			[2] = {14,"LocalEvent_MainBase_Showskillfrm",16},
			--[3] = {20,"LocalEvent_EnterRandMap",21},
			[3] = {20,"LocalEvent_EnterMapDoor",21},
			--[4] = {26,"LocalEvent_EnterRandTestMap",27},
		},
	}
	
	--事件单位
	local _eventUnit = {
		--[11015] = {"LocalEvent_ShowPlayerBestInfo"}, --电视机
		[11015] = {"LocalEvent_Phone_ShowMyTask"}, --电视机
		[11030] = {"LocalEvent_ShowDailyRewardFrm"},
		[11031] = {"LocalEvent_ShowPurchaseGiftFrm"},
		--[11029] = {"LocalEvent_ShowTacticsHelpFrm"},
		[11107] = {"LocalEvent_ShowUnlockPetAreaFrm"},
		[11108] = {"LocalEvent_ShowUnlockTacticsAreaFrm"},
		[11122] = {"LocalEvent_ShowUnlockentertainmentareaFrm"},
		[11002] = {"LocalEvent_ShowGotoPlay"},	--打地鼠机
		--[11006] = {"LocalEvent_Phone_ShowPhoneChestFrame"},	--宝箱界面
		[5142] = {"LocalEvent_Phone_ShowPhoneChestFrame"},	--宝箱界面
		[11033] = {"LocalEvent_Phone_ShowUserDefMapFrm"},	--用户自定义地图界面
		[11034] = {"LocalEvent_Phone_ShowBlackDragonTalkFrm", 2},	--抢滩登录
		[11035] = {"LocalEvent_Phone_ShowBlackDragonTalkFrm", 1},	--母巢之战
		[11046] = {"LocalEvent_Phone_ShowBlackDragonTalkFrm", 3},	--夺宝奇兵
		[11037] = {"LocalEvent_ShowDLCMapInfo", "world/dlc_yxys_spider"},	--机械蜘蛛地图
		[11038] = {"LocalEvent_ShowDLCMapInfo", "world/dlc_yxys_zerg"},	--虫族地图
		[11039] = {"LocalEvent_ShowDLCMapInfo", "world/dlc_bio_airship"},	--生化战役地图
		[11040] = {"LocalEvent_ShowDLCMapInfo", "world/dlc_yxys_airship"},	--飞机地图
		[11052] = {"LocalEvent_ShowDLCMapInfo", "world/dlc_yxys_plate"},	--飞碟地图
		[11048] = {"LocalEvent_ShowDLCMapInfo", "world/dlc_yxys_mechanics"},	--机械战舰地图
		[11069] = {"LocalEvent_ShowDLCMapInfo", "world/dlc_yxys_yoda"},		--尤达地图
		[11067] = {"LocalEvent_ShowDLCMapInfo", "world/dlc_yxys_walle"},	--瓦力地图
		--[6107] = {"LocalEvent_showswitchtankbtn", 6107,},	--切换战车
		--[6108] = {"LocalEvent_showswitchtankbtn", 6108,},	--切换战车
		--[6109] = {"LocalEvent_showswitchtankbtn", 6109,},	--切换战车
		[6109] = {"LocalEvent_TankAvaterFrm", 1,},	--切换战车1
		[6107] = {"LocalEvent_TankAvaterFrm", 2,},	--切换战车2
		[6108] = {"LocalEvent_TankAvaterFrm", 3,},	--切换战车3
		[13066] = {"LocalEvent_Phone_TakeRewardKeShi",},	--氪石领取点
		[13067] = {"LocalEvent_Phone_TakeRewardTiLi",},		--体力领取点
		[13071] = {"LocalEvent_Phone_TakeRewardChest",},	--宝箱领取点
		[11045] = {"LocalEvent_EnterRandTestMap",},		--随机迷宫
		[11055] = {"LocalEvent_Phone_ShowMyAchievement", hVar.MEDAL_TYPE.starCount,},	--成就界面（星星）
		[11004] = {"LocalEvent_Phone_ShowMyAchievement", hVar.MEDAL_TYPE.rescueScientist,},	--成就界面（科学家）
		[11065] = {"LocalEvent_Phone_ShowMyAchievement", hVar.MEDAL_TYPE.tankDeadthCount,},	--成就界面（战车死亡）
	}
	
	--区域事件坐标设定
	local _areaEventPoint = {
		["defencearea"] = {--前哨阵地
			{
				mode = 1, -- 1长方形 2 圆形
				x = 1336, 
				y = -370,
				w = 360, 
				h = 300,
			},
		},
		["tacticsarea"] = {--战术卡区域
			{
				mode = 1, -- 1长方形 2 圆形
				x = 2886, 
				y = -1010,
				w = 800, 
				h = 700,
			},
		},
		["petarea"] = {--宠物区域
			{
				mode = 1, -- 1长方形 2 圆形
				x = 2096, 
				y = -1700,
				w = 920,
				h = 600,
			},
		},
		["engineer"] = {--随机地图区域
			{
				mode = 1, -- 1长方形 2 圆形
				x = 1350, 
				y = -1500,
				w = 580,
				h = 500,
			},
		},
		["blackdragonarea"] = {--黑龙区域
			{
				mode = 1, -- 1长方形 2 圆形
				x = 626, 
				y = -700,
				w = 530,
				h = 480,
			},
		},
		["battlearea"] = {--战役区域
			{
				mode = 1, -- 1长方形 2 圆形
				x = 1806, 
				y = -660,
				w = 580,
				h = 440,
			},
			{
				mode = 1, -- 1长方形 2 圆形
				x = 2276, 
				y = -840,
				w = 380,
				h = 480,
			},
			{
				mode = 1, -- 1长方形 2 圆形
				x = 2306, 
				y = -400,
				w = 620,
				h = 480,
			},
		},
	--	["testarea"] = {	--圆形测试区域
	--		{
	--			mode = 2, -- 1长方形 2 圆形
	--			x = 2214, 
	--			y = -1410,
	--			radius = 500,
	--		},
	--	},
	}
	local _IsDrawArea = 0
	
	local iPhoneX_WIDTH = 0
	if (g_phone_mode == 4) then --iPhoneX
		iPhoneX_WIDTH = hVar.SCREEN.offx
	end
	
	--挖矿
	local _nKeShiPosX = 2541
	local _nKeShiPosY = 1665
	local _tKeShiUints = {{id = 13062, num = 3,}, {id = 13061, num = 2,}, {id = 13060, num = 1,},}
	--挖体力
	local _nTiLiPosX = 2431
	local _nTiLiPosY = 1771
	local _tTiLiUints = {{id = 13065, num = 3,}, {id = 13064, num = 2,}, {id = 13063, num = 1,},}
	--挖宝箱
	local _nChestPosX = 2434
	local _nChestPosY = 1675
	local _tChestUints = {{id = 13070, num = 3,}, {id = 13069, num = 2,}, {id = 13068, num = 1,},}
	
	local _frm,_parent,_childUI = nil,nil,nil
	local _nUnlockviparea = -1
	local _shouldCheckEvent = false
	local _oDailyRewardUnit = nil
	local _oGiftUnit = nil
	local _oTacticsHelpUnit = nil
	local _oUnlockAreaUnit = nil
	local _tTalkWeaponList = {}
	local _tLastTalkTarget = nil
	local _tTalkUnitInfo = nil
	local _oGopherUnit = nil
	local _oTurretUnit = nil
	local _oEngineerUnit = nil --科学家成就单位
	local _oTankDeadthUnit = nil --战车死亡成就单位
	local _oWeaponCapsuleUnit = nil
	local _oStarMedalUnit = nil --星星成就单位
	local _oTacticsCapsuleUnit = nil
	local _oPetCapsuleUnit = nil
	local _oEquipCapsuleUnit = nil
	local _tAreaStateInfo = nil
	local _tReplaceTankUnitList = {
		tank = {},
		driveway_green = nil,
	}
	local _tSelectUnitList = {}
	local _tPetUnitList = {} 
	local _tWeaponUnitList = {}
	local _tTurretUnitList = {}
	local _tGophersBirth = {}
	local _tDelUnitList = {}
	local _tTacticsUnitList = {}
	local _tAreaMaskSprite = {}
	local Code_CreateMainBaseFrm = hApi.DoNothing
	local Code_ClearFrm = hApi.DoNothing
	local Code_HideFrm = hApi.DoNothing --隐藏本界面（进入黑龙scene隐藏）
	local Code_ShowFrm = hApi.DoNothing --显示本界面（离开黑龙scene显示）
	local Code_CheckTalkEvent = hApi.DoNothing
	local Code_CheckAreaEvent = hApi.DoNothing
	local Code_EnterAreaEvent = hApi.DoNothing
	local Code_LeaveAreaEvent = hApi.DoNothing
	local Code_InitData = hApi.DoNothing
	local Code_ClearData = hApi.DoNothing
	local Code_AddWeaponCanUpgradeEffect = hApi.DoNothing
	local Code_AddUpgradeEffect = hApi.DoNothing
	local Code_AddScreenEffect = hApi.DoNothing
	local Code_AddSelectEffect = hApi.DoNothing
	local Code_AddSelectItemEffect = hApi.DoNothing
	local Code_AddRotateEffect = hApi.DoNothing
	local Code_PlayGrowAcition = hApi.DoNothing
	local Code_TowerPlayEffect = hApi.DoNothing --指定id的塔播放特效
	local Code_RemoveSelectEffect = hApi.DoNothing
	local Code_ReplaceModel = hApi.DoNothing
	local Code_ReplacePet = hApi.DoNothing
	local Code_ReplaceTank = hApi.DoNothing --切换战车
	local Code_UpdateTankInfo = hApi.DoNothing
	local Code_CancelFollowPet = hApi.DoNothing --取消宠物跟随
	local Code_SendPetWaKuang = hApi.DoNothing --主基地派遣宠物挖矿
	local Code_SendPetWaTiLi = hApi.DoNothing --主基地派遣宠物挖体力
	local Code_CancelPetWaKuang = hApi.DoNothing --主基地取消宠物挖矿
	local Code_CancelPetWaTiLi = hApi.DoNothing --主基地取消宠物挖体力
	local Code_RefreshScientstAchievement = hApi.DoNothing --主基地更新科学家成就皮肤
	local Code_RefreshTankDeadthAchievement = hApi.DoNothing --主基地更新战车死亡成就皮肤
	local Code_UpdateTanHao = hApi.DoNothing --主基地更新任务叹号
	local Code_ShowWeaponInfo = hApi.DoNothing
	local Code_UnlockFunc = hApi.DoNothing
	local Code_UpgradePet = hApi.DoNothing
	local Code_CheckEventPoint = hApi.DoNothing
	local Code_ChangeWorldFunc = hApi.DoNothing
	local Code_CheckDailyReward = hApi.DoNothing
	local Code_CheckAdminDebug = hApi.DoNothing --管理员调试模式
	local Code_ReceiveTankYesterdayRank = hApi.DoNothing --战车昨日排名
	local Code_CreateEngineerNum = hApi.DoNothing --更新营救科学家数量
	local Code_CreateTankDeadthNum = hApi.DoNothing --更新战车死亡数量
	local Code_RefreshWeaponCapsuleNum = hApi.DoNothing
	local Code_RefreshTacticsCapsuleNum = hApi.DoNothing
	local Code_RefreshPetCapsuleNum = hApi.DoNothing
	local Code_CheckTacticsCard = hApi.DoNothing
	local Code_CreateTacticsLvBg = hApi.DoNothing
	local Code_CreatePetLvBg = hApi.DoNothing
	local Code_CreateDishuCoin = hApi.DoNothing
	local Code_PlayTacticsLvUpEffect = hApi.DoNothing
	local Code_RefreshPetBase = hApi.DoNothing
	local Code_ClearTurretUnit = hApi.DoNothing
	local Code_NotReady = hApi.DoNothing
	local Code_CreateAreaMask = hApi.DoNothing
	local Code_ClearAreaMask = hApi.DoNothing

	local on_refresh_chatbtn_notice = hApi.DoNothing --刷新聊天叹号提示
	local on_refresh_medal_state_ui = hApi.DoNothing

	talktype_last = 0
	local m_kesiNum = 0 --缓存氪石值
	local m_tiliNum = 0 --缓存体力值
	local m_chestNum = 0 --缓存宝箱值
	local m_keshiExportNow = 0 --当前氪石领取量
	local m_tiliExportNow = 0 --当前体力领取量
	local m_chestExportNow = 0 --当前宝箱领取量
	
	--游戏货币资源
	g_GameCurrencyResource = {keshi = 0,chip = 0}
	
	hApi.GetMainBaseGophersBirth = function()
		return _tGophersBirth
	end
	
	Code_ClearFrm = function()
		if hGlobal.UI.SystemMenuFram_mainbase then
			hGlobal.UI.SystemMenuFram_mainbase:del()
			hGlobal.UI.SystemMenuFram_mainbase = nil
		end
		_frm,_parent,_childUI = nil,nil,nil
	end
	
	--隐藏本界面（进入黑龙scene隐藏）
	Code_HideFrm = function()
		if hGlobal.UI.SystemMenuFram_mainbase then
			hGlobal.UI.SystemMenuFram_mainbase:show(0)
		end
	end
	
	--显示本界面（离开黑龙scene显示）
	Code_ShowFrm = function()
		if hGlobal.UI.SystemMenuFram_mainbase then
			hGlobal.UI.SystemMenuFram_mainbase:show(1)
		end
	end
	
	Code_NotReady = function()
		hUI.floatNumber:new({
			x = hVar.SCREEN.w / 2,
			y = hVar.SCREEN.h / 2,
			align = "MC",
			text = "",
			lifetime = 1000,
			fadeout = -550,
			moveY = 32,
		}):addtext(hVar.tab_string["not_ready"], hVar.FONTC, 40, "MC", 0, 0,nil,1)
	end
	
	Code_CreateMainBaseFrm = function()
		hGlobal.UI.SystemMenuFram_mainbase = hUI.frame:new({
			x = 0,
			y = 0,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			z = -1,
			show = 0,
			dragable = 2,
			buttononly = 1,
			autoactive = 0,
			border = 0,
		})
		_frm = hGlobal.UI.SystemMenuFram_mainbase
		_parent = _frm.handle._n
		_childUI = _frm.childUI

		--_childUI["SysMenu"] = hUI.button:new({
			--parent = _parent,
			--model = "misc/setting.png",
			--dragbox = _frm.childUI["dragBox"],
			--x = hVar.SCREEN.w - iPhoneX_WIDTH - 60,
			--y = hVar.SCREEN.h - 40,
			--w = 64,
			--h = 64,
			--scaleT = 0.95,
			----scale = 1.0,
			--code = function()
				--local w = hGlobal.WORLD.LastWorldMap
				--if w then
					--if (w.data.keypadEnabled == true) then --允许响应事件
						--local mapInfo = w.data.tdMapInfo
						--if mapInfo then
							----游戏已结束，此时需要等待2秒，不能点齿轮
							--if (mapInfo.mapState > hVar.MAP_TD_STATE.PAUSE) then
								----
							--else
								--if (mapInfo.mapMode ~= hVar.MAP_TD_TYPE.PVP) then
									--if hGlobal.UI.SystemMenuNewFram then
										--hGlobal.event:event("localEvent_ShowNewSysFrm")
									--end
								--end
							--end
						--end
					--end
				--end
			--end,
		--})

		iPhoneX_WIDTH = hVar.SCREEN.offx
		local offy = - 10
		if hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.VERTICAL then
			offy = - 60
			iPhoneX_WIDTH = 0
		end
		
		--氪石底纹
		_childUI["CoinNumBG"] = hUI.image:new({
			parent = _parent,
			model = "UI:selectbg",
			x = 150 + iPhoneX_WIDTH,
			y = hVar.SCREEN.h - 40 + offy,
			w = 200,
			h = 36,
		})
		
		--氪石图标
		_childUI["CoinIcon"] = hUI.image:new({
			parent = _parent,
			model = "misc/skillup/keshi.png",
			x = 60 + iPhoneX_WIDTH,
			y = hVar.SCREEN.h - 40 + offy,
			scale = 1.0,
			h = 55,
			w = 55,
		})
		
		--氪石数量
		_childUI["CoinNum"] = hUI.label:new({
			parent = _parent,
			x = 150 + iPhoneX_WIDTH,
			y = hVar.SCREEN.h - 40 + offy,
			width = 500,
			align = "MC",
			font = "num",
			border = 0,
			size = 22,
			text = m_kesiNum,
		})
		
		--氪石加号按钮
		_childUI["buycoin"] = hUI.button:new({
			parent = _parent,
			--model = "misc/skillup/addtimes.png",
			model = "misc/mask.png",
			dragbox = _frm.childUI["dragBox"],
			x = 236 + iPhoneX_WIDTH,
			--y = hVar.SCREEN.h - 40,
			y = hVar.SCREEN.h - 40 + offy,
			w = 80,
			h = 80,
			scaleT = 0.95,
			code = function(self, screenX, screenY, isInside)
				local oWorld = hGlobal.WORLD.LastWorldMap
				if oWorld then
					oWorld.data.keypadEnabled = false
					--hGlobal.event:event("LocalEvent_InitInAppPurchaseTipFrm_new")
					local callback = function()
						oWorld.data.keypadEnabled = true
						--hGlobal.event:event("enablePhonePurchaseFrm")
					end
					--允许打开充值界面
					hGlobal.event:event("enablePhonePurchaseFrm")
					hGlobal.event:event("LocalEvent_InitInAppPurchaseTipFrm", callback, false)
				end
			end
		})
		_childUI["buycoin"].handle.s:setOpacity(0) --只响应事件，不显示
		--氪石加号图标
		_childUI["buycoin"].childUI["img"] = hUI.button:new({
			parent = _childUI["buycoin"].handle._n,
			model = "misc/skillup/addtimes.png",
		})
		
		--[[
		--金币数量底图
		_childUI["GoldNumBG"] = hUI.image:new({
			parent = _parent,
			model = "UI:selectbg",
			x = 150 + iPhoneX_WIDTH,
			y = hVar.SCREEN.h - 40 + offy,
			w = 200,
			h = 36,
		})

		_childUI["GoldIcon"] = hUI.image:new({
			parent = _parent,
			model = "misc/skillup/mu_coin.png",
			x = 60 + iPhoneX_WIDTH,
			y = hVar.SCREEN.h - 40 + offy,
			scale = 1.0,
		})
		
		--金币数量
		_childUI["GoldNum"] = hUI.label:new({
			parent = _parent,
			x = 150 + iPhoneX_WIDTH,
			y = hVar.SCREEN.h - 40 + offy,
			width = 500,
			align = "MC",
			font = "num",
			border = 0,
			size = 22,
			text = "0",
		})
		]]
		
		--体力底纹
		local tili_dx = 260
		_childUI["TiliNumBG"] = hUI.image:new({
			parent = _parent,
			model = "UI:selectbg",
			x = 150 + tili_dx + iPhoneX_WIDTH,
			y = hVar.SCREEN.h - 40 + offy,
			w = 200 - 60,
			h = 36,
		})
		
		--体力图标
		_childUI["TiliIcon"] = hUI.image:new({
			parent = _parent,
			model = "misc/task/tili.png",
			x = 60 + tili_dx + iPhoneX_WIDTH + 30,
			y = hVar.SCREEN.h - 40 + offy,
			scale = 1.0,
			w = 64 * 1.0,
			h = 64 * 1.0,
		})
		
		--体力数量
		_childUI["TiliNum"] = hUI.label:new({
			parent = _parent,
			x = 150 + tili_dx + iPhoneX_WIDTH,
			y = hVar.SCREEN.h - 40 + offy,
			width = 500,
			align = "MC",
			font = "numWhite",
			border = 0,
			size = 22,
			text = m_tiliNum,
		})
		_childUI["TiliNum"].handle.s:setColor(ccc3(0, 255, 0))
		
		--体力加号按钮
		_childUI["buytili"] = hUI.button:new({
			parent = _parent,
			--model = "misc/skillup/addtimes.png",
			model = "misc/mask.png",
			dragbox = _frm.childUI["dragBox"],
			x = 236 + tili_dx + iPhoneX_WIDTH - 30,
			--y = hVar.SCREEN.h - 40,
			y = hVar.SCREEN.h - 40 + offy,
			w = 80,
			h = 80,
			scaleT = 0.95,
			code = function(self, screenX, screenY, isInside)
				local oWorld = hGlobal.WORLD.LastWorldMap
				if oWorld then
					hGlobal.event:event("LocalEvent_HideBarrage")
					hGlobal.event:event("LocalEvent_CloseBlackDragonTalkFrm")
					
					oWorld.data.keypadEnabled = false
					--hGlobal.event:event("LocalEvent_InitInAppPurchaseTipFrm_new")
					local callback = function()
						oWorld.data.keypadEnabled = true
						--hGlobal.event:event("enablePhonePurchaseFrm")
					end
					--允许打开充值界面
					hGlobal.event:event("enablePhonePurchaseFrm")
					--hGlobal.event:event("LocalEvent_InitInAppPurchaseTipFrm", callback, false)
					--显示购买体力界面
					hApi.ShowPvpCoinTip()
				end
			end
		})
		_childUI["buytili"].handle.s:setOpacity(0) --只响应事件，不显示
		--氪石加号图标
		_childUI["buytili"].childUI["img"] = hUI.button:new({
			parent = _childUI["buytili"].handle._n,
			model = "misc/skillup/addtimes.png",
		})
		
		
		--管理员调试按钮
		_childUI["adminDebugBun"] = hUI.button:new({
			parent = _parent,
			model = "misc/vip1.png",
			dragbox = _frm.childUI["dragBox"],
			x = 80,
			y = 70,
			--w = 80,
			--h = 80,
			--scale = 0.5,
			scaleT = 0.95,
			code = function(self, screenX, screenY, isInside)
				--[[
				--显示存档日志
				hGlobal.event:event("LocalEvent_Phone_ShowSaveDataChangeInfoFrm")
				]]
				
				--[[
				--触发事件
				local callbackOK = function(backgroundId, avaterId, wallId)
					print(backgroundId, avaterId, wallId)
					
					--开始生成用户自定义地图的配置
					local regionPoint = 1001
					local tConfig = hVar.RANDMAP_ROOM_AVATAR_INFO[regionPoint]
					
					--拷贝宇宙层
					local tUniverseConfig = hVar.RANDMAP_ROOM_AVATAR_INFO[1]
					tConfig.farobj = --地球远景层
					{
						img = {tUniverseConfig.farobj.img[backgroundId],},
						num = 1,
						scale = 1.0,
					}
					tConfig.middleobj = tUniverseConfig.middleobj
					tConfig.nearobj = tUniverseConfig.nearobj
					print(tConfig.farobj.img[1])
					--拷贝背景图
					local tBackgroundConfig = hVar.RANDMAP_ROOM_AVATAR_INFO[avaterId]
					tConfig.wallimg = tBackgroundConfig.wallimg
					tConfig.renders = tBackgroundConfig.renders
					
					--拷贝墙面
					local wallCfgId = 0
					if (wallId == 1) then --高墙
						wallCfgId = 1
					elseif (wallId == 2) then --矮墙
						wallCfgId = 3
					elseif (wallId == 3) then --无墙
						wallCfgId = 4
					end
					local tWallConfig = hVar.RANDMAP_ROOM_AVATAR_INFO[wallCfgId]
					tConfig.ground = tWallConfig.ground --地板
					tConfig.wall_l = tWallConfig.wall_l
					tConfig.wall_r = tWallConfig.wall_r
					tConfig.wall_t = tWallConfig.wall_t
					tConfig.wall_b = tWallConfig.wall_b
					tConfig.corner_lt = tWallConfig.corner_lt
					tConfig.corner_rt = tWallConfig.corner_rt
					tConfig.corner_lb = tWallConfig.corner_lb
					tConfig.corner_rb = tWallConfig.corner_rb
					tConfig.corner_lt1 = tWallConfig.corner_lt1
					tConfig.corner_rt1 = tWallConfig.corner_rt1
					tConfig.corner_lb1 = tWallConfig.corner_lb1
					tConfig.corner_rb1 = tWallConfig.corner_rb1
					tConfig.door_v = tWallConfig.door_v
					tConfig.door_h = tWallConfig.door_h
					tConfig.swall_v = tWallConfig.swall_v
					tConfig.swall_h = tWallConfig.swall_h
					tConfig.blocks = tWallConfig.blocks
					
					--大菠萝数据初始化
					hGlobal.LocalPlayer.data.diablodata = LuaInitDiabloData()
					xlScene_LoadMap(g_world, "world/csys_random_test_userdef",0,hVar.MAP_TD_TYPE.NORMAL)
				end
				local callbackCancel = function(...) print(...) end
				hGlobal.event:event("LocalEvent_Phone_ShowGMResourceFrm", callbackOK, callbackCancel)
				]]
				--hGlobal.event:event("LocalEvent_Phone_ShowMyTask")
				
				--管理员调试
				SendCmdFunc["gm_debug"]()
				
				if xlError_MakeACppCrash then
					xlError_MakeACppCrash()
				end
				
				local strText = "已发送调试指令！" --language
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
		})
		_childUI["adminDebugBun"]:setstate(-1)
		--星星1
		_childUI["adminDebugBun"].childUI["star1"] = hUI.image:new({
			parent = _childUI["adminDebugBun"].handle._n,
			model = "ICON:WeekStar",
			x = -11,
			y = 37,
			z = 100,
			w = 24,
			h = 24,
		})
		--星星2
		_childUI["adminDebugBun"].childUI["star2"] = hUI.image:new({
			parent = _childUI["adminDebugBun"].handle._n,
			model = "ICON:WeekStar",
			x = 11,
			y = 37,
			z = 100,
			w = 24,
			h = 24,
		})
		
		--设置
		_childUI["set"]=hUI.button:new({
			parent = _parent,
			model = "misc/setting.png",
			dragbox = _frm.childUI["dragBox"],
			x = hVar.SCREEN.w - 80 - iPhoneX_WIDTH,
			y = hVar.SCREEN.h - 40 + offy,
			scaleT = 0.95,
			code = function(self, screenX, screenY, isInside)
				hGlobal.event:event("LocalEvent_HideBarrage")
				hGlobal.event:event("LocalEvent_CloseBlackDragonTalkFrm")
				hGlobal.event:event("LocalEvent_ShowSystemMenuIntegrateFrm")
			end
		})
		
		--背包
		_childUI["storehouse"]=hUI.button:new({
			parent = _parent,
			model = "ui/icon_shortcut.png",
			dragbox = _frm.childUI["dragBox"],
			x = hVar.SCREEN.w - 80 - iPhoneX_WIDTH,
			y = hVar.SCREEN.h - 40 - 76 + offy,
			scaleT = 0.95,
			scale = 1.0,
			code = function(self, screenX, screenY, isInside)
				hGlobal.event:event("LocalEvent_HideBarrage")
				hGlobal.event:event("LocalEvent_CloseBlackDragonTalkFrm")
				
				--hGlobal.event:event("localEvent_ShowChariotItemFrm",1)
				--触发事件，显示快捷入口界面
				hApi.ShowShorcutTip()
			end
		})
		--背包叹号
		_childUI["storehouse"].childUI["lvup"] = hUI.image:new({
			parent = _childUI["storehouse"].handle._n,
			model = "UI:TaskTanHao",
			x = 15,
			y = 25 - 5,
			scale = 1.0,
		})
		local act1 = CCMoveBy:create(0.2, ccp(0, 6))
			local act2 = CCMoveBy:create(0.2, ccp(0, -6))
			local act3 = CCMoveBy:create(0.2, ccp(0, 6))
			local act4 = CCMoveBy:create(0.2, ccp(0, -6))
			local act5 = CCDelayTime:create(0.6)
			local act6 = CCRotateBy:create(0.1, 10)
			local act7 = CCRotateBy:create(0.1 * 1, -10 * 2)
			local act8 = CCRotateBy:create(0.1 * 1, 10 * 2)
			local act9 = CCRotateBy:create(0.1, -10)
			local act10 = CCDelayTime:create(0.8)
			local a = CCArray:create()
			a:addObject(act1)
			a:addObject(act2)
			a:addObject(act3)
			a:addObject(act4)
			a:addObject(act5)
			a:addObject(act6)
			a:addObject(act7)
			a:addObject(act8)
			a:addObject(act9)
			a:addObject(act10)
			local sequence = CCSequence:create(a)
		_childUI["storehouse"].childUI["lvup"].handle._n:runAction(CCRepeatForever:create(sequence))
		_childUI["storehouse"].childUI["lvup"].handle._n:setVisible(false) --默认隐藏
		
		--任务
		_childUI["task"] = hUI.button:new({
			parent = _parent,
			model = "misc/task.png",
			dragbox = _frm.childUI["dragBox"],
			x = hVar.SCREEN.w - 80 - iPhoneX_WIDTH,
			y = hVar.SCREEN.h - 40 - 76*2 + offy,
			scaleT = 0.95,
			scale = 0.85,
			code = function(self, screenX, screenY, isInside)
				hGlobal.event:event("LocalEvent_HideBarrage")
				hGlobal.event:event("LocalEvent_CloseBlackDragonTalkFrm")
				
				--显示任务界面
				hGlobal.event:event("LocalEvent_Phone_ShowMyTask", nil, true)
			end
		})
		--任务叹号
		_childUI["task"].childUI["lvup"] = hUI.image:new({
			parent = _childUI["task"].handle._n,
			model = "UI:TaskTanHao",
			x = 15,
			y = 25 - 5,
			scale = 1.0,
		})
		local act1 = CCMoveBy:create(0.2, ccp(0, 6))
			local act2 = CCMoveBy:create(0.2, ccp(0, -6))
			local act3 = CCMoveBy:create(0.2, ccp(0, 6))
			local act4 = CCMoveBy:create(0.2, ccp(0, -6))
			local act5 = CCDelayTime:create(0.6)
			local act6 = CCRotateBy:create(0.1, 10)
			local act7 = CCRotateBy:create(0.1 * 1, -10 * 2)
			local act8 = CCRotateBy:create(0.1 * 1, 10 * 2)
			local act9 = CCRotateBy:create(0.1, -10)
			local act10 = CCDelayTime:create(0.8)
			local a = CCArray:create()
			a:addObject(act1)
			a:addObject(act2)
			a:addObject(act3)
			a:addObject(act4)
			a:addObject(act5)
			a:addObject(act6)
			a:addObject(act7)
			a:addObject(act8)
			a:addObject(act9)
			a:addObject(act10)
			local sequence = CCSequence:create(a)
		_childUI["task"].childUI["lvup"].handle._n:runAction(CCRepeatForever:create(sequence))
		_childUI["task"].childUI["lvup"].handle._n:setVisible(false) --默认隐藏
		

		--礼包
		_childUI["libao"] = hUI.button:new({
			parent = _parent,
			model = "UI:GIFT",
			dragbox = _frm.childUI["dragBox"],
			x = hVar.SCREEN.w - 80 - iPhoneX_WIDTH,
			y = hVar.SCREEN.h - 40 - 76*3 + offy,
			scaleT = 0.95,
			w = 50,
			h = 50,
			--scale = 0.85,
			code = function(self, screenX, screenY, isInside)
				hGlobal.event:event("LocalEvent_ShowWithdrawGiftFrm")
			end
		})
		local _offh = 0
		if g_OBSwitch.lipinma == 1 then
			_childUI["libao"]:setstate(1)
			_offh = -76
		else
			_childUI["libao"]:setstate(-1)
		end

		--弹幕
		_childUI["danmu"] = hUI.button:new({
			parent = _parent,
			model = "misc/button_null.png",
			dragbox = _frm.childUI["dragBox"],
			x = hVar.SCREEN.w - 80 - iPhoneX_WIDTH,
			y = hVar.SCREEN.h - 40 - 76*3 + offy + _offh,
			scaleT = 0.95,
			w = 50,
			h = 50,
			--scale = 0.85,
			code = function(self, screenX, screenY, isInside)
				hGlobal.event:event("LocalEvent_SwitchBarrageShow")
			end
		})

		_childUI["danmu"].childUI["img"] = hUI.image:new({
			parent = _childUI["danmu"].handle._n,
			model = "misc/barrage_on.png",
		})
		--隐藏
		_childUI["danmu"]:setstate(-1)
		
		--评价
		_childUI["comment"]=hUI.button:new({
			parent = _parent,
			model = "misc/addition/comment.png",
			dragbox = _frm.childUI["dragBox"],
			x = hVar.SCREEN.w - 80 - 90 - iPhoneX_WIDTH,
			y = hVar.SCREEN.h - 32 + offy,
			--w = 80,
			--h = 80,
			--scale = 0.5,
			scaleT = 0.95,
			scale = 0.9,
			code = function(self, screenX, screenY, isInside)
				--local clickCount = LuaGetCommentClickCount() --点击按钮的次数
				--LuaSetCommentClickCount(clickCount + 1)
				--Gift_Function["reward_3"]()
				hGlobal.event:event("LocalEvent_HideBarrage")
				hGlobal.event:event("LocalEvent_CloseBlackDragonTalkFrm")
				
				--hGlobal.event:event("LocalEvent_ShowCommentRewardFrm")
				--显示去评价界面
				hGlobal.event:event("LocalEvent_Phone_ShowRecommandInfoFrm")
			end
		})
		_childUI["comment"]:setstate(-1)
		--评价叹号
		_childUI["comment"].childUI["tanhao"] = hUI.image:new({
			parent = _childUI["comment"].handle._n,
			model = "UI:TaskTanHao",
			x = 15,
			y = 16,
			--x = 15,
			--y = 25 - 5,
			z = 100,
			scale = 1.0,
		})
		
		local act1 = CCMoveBy:create(0.2, ccp(0, 6))
		local act2 = CCMoveBy:create(0.2, ccp(0, -6))
		local act3 = CCMoveBy:create(0.2, ccp(0, 6))
		local act4 = CCMoveBy:create(0.2, ccp(0, -6))
		local act5 = CCDelayTime:create(0.6)
		local act6 = CCRotateBy:create(0.1, 10)
		local act7 = CCRotateBy:create(0.1 * 1, -10 * 2)
		local act8 = CCRotateBy:create(0.1 * 1, 10 * 2)
		local act9 = CCRotateBy:create(0.1, -10)
		local act10 = CCDelayTime:create(0.8)
		local a = CCArray:create()
		a:addObject(act1)
		a:addObject(act2)
		a:addObject(act3)
		a:addObject(act4)
		a:addObject(act5)
		a:addObject(act6)
		a:addObject(act7)
		a:addObject(act8)
		a:addObject(act9)
		a:addObject(act10)
		local sequence = CCSequence:create(a)
		_childUI["comment"].childUI["tanhao"].handle._n:runAction(CCRepeatForever:create(sequence))
		_childUI["comment"].childUI["tanhao"].handle._n:setVisible(false) --默认隐藏
		
		-------------------------------------------------------
		--聊天按钮
		if (g_OBSwitch and g_OBSwitch.openChat == 1) or g_lua_src == 1 then
			local iPhoneX_WIDTH_NEW = 0
			local iPhoneX_HEIGHT_NEW = 0
			if hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.VERTICAL then
				iPhoneX_WIDTH_NEW = 0
				if (g_phone_mode == 4) then
					iPhoneX_HEIGHT_NEW = 80
				end
				
				--iPhoneX_WIDTH_NEW = iPhoneX_WIDTH_NEW - 200 --竖屏，暂时隐藏聊天按钮
			elseif hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.HORIZONTAL then
				if (g_phone_mode == 4) then
					iPhoneX_WIDTH_NEW = 80
				end
				iPhoneX_HEIGHT_NEW = 0
				
				iPhoneX_WIDTH_NEW = iPhoneX_WIDTH_NEW - 200 --横屏，暂时隐藏聊天按钮
			end
			
			_childUI["chatBtn"] = hUI.button:new({
				parent = _parent,
				model = "misc/mask.png", --ui/set.png",
				--x = 50,
				--y = -20,
				x = iPhoneX_WIDTH_NEW + 50, --	+ hVar.SCREEN.offx
				y = iPhoneX_HEIGHT_NEW + 50,
				scaleT = 0.95,
				dragbox = _frm.childUI["dragBox"],
				w = 100,
				h = 100,
				z = 10,
				--failcall = 1,
				code = function(self, touchX, touchY, sus)
					--geyachao: 触发引导事件：点到了设置按钮
					--hGlobal.event:event("LocalEvent_Click_Guide_SettingButton")
					
					if (hGlobal.UI.Phone_MyHeroCardFrm_New ~= nil) and 1 == hGlobal.UI.Phone_MyHeroCardFrm_New.data.show then					--如果“我的英雄令”界面正在打开则直接返回		added by pangyong 2015/4/21
						return
					end
					
					--没有账号，不能进入设置
					if (g_curPlayerName == nil) then
						return
					end
					
					--打开聊天界面（主界面）
					local tCallback = {
						bEnableBattleInvite = true, --是否允许聊天直接加入房间
						strDisableBattleInviteString = "", --不允许聊天直接加入房间的提示文字
						
						--关闭回调事件
						OnCloseFunc = function()
							--
						end,
						
						--聊天直接加入房间回调事件
						OnBattleInviteEnterFunc = function()
							--
						end,
						
						--聊天直接加入房间返回回调事件
						OnBattleInviteReturnFunc = function()
							--主界面断开pvp服务器的连接
							--Pvp_Server:Close() --!!!! edit by mj 2022.11.15
							--Pvp_Server:Clear() --!!!! edit by mj 2022.11.15
						end,
						
						--聊天直接加入房间进入战斗回调事件
						OnBattleInviteBeginFunc = function()
							--
						end,
					}
					hGlobal.event:event("LocalEvent_Phone_ShowChatDialogue", nil, tCallback)
				end,
			})
			_childUI["chatBtn"].handle.s:setOpacity(0) --只用于控制，不显示
			--聊天图片
			_childUI["chatBtn"].childUI["image"] = hUI.image:new({
				parent = _childUI["chatBtn"].handle._n,
				model = "misc/chat.png",	--"UI:CHAT_N",
				x = 0,
				y = 0,
				scale = 0.75,
			})
			--聊天按钮提示有新消息的叹号
			_childUI["chatBtn"].childUI["NoteJianTou"] = hUI.image:new({
				parent = _childUI["chatBtn"].handle._n,
				model = "UI:TaskTanHao",
				x = 20,
				y = 28,
				z = 3,
				w = 36,
				h = 36,
			})
			local act1 = CCMoveBy:create(0.2, ccp(0, 5))
			local act2 = CCMoveBy:create(0.2, ccp(0, -5))
			local act3 = CCMoveBy:create(0.2, ccp(0, 5))
			local act4 = CCMoveBy:create(0.2, ccp(0, -5))
			local act5 = CCDelayTime:create(2.0)
			local a = CCArray:create()
			a:addObject(act1)
			a:addObject(act2)
			a:addObject(act3)
			a:addObject(act4)
			a:addObject(act5)
			local sequence = CCSequence:create(a)
			_childUI["chatBtn"].childUI["NoteJianTou"].handle._n:runAction(CCRepeatForever:create(sequence))
			_childUI["chatBtn"].childUI["NoteJianTou"].handle._n:setVisible(false) --一开始不显示
		else
			if _childUI["chatBtn"] then
				_childUI["chatBtn"].handle._n:setVisible(false)
			end
		end

		--局部函数
		--geyachao: 刷新点将台、战术卡、成就任务活动、竞技场锦囊、商城今日刷新商品、评价，等叹号提示
		on_refresh_chatbtn_notice = function()
			local _frm = hGlobal.UI.SystemMenuFram_mainbase
			
			--没创建新主界面，直接返回
			if (not _frm) then
				return
			end
			
			local childUI = _frm.childUI
			if not childUI then
				return
			end

			if (g_OBSwitch and g_OBSwitch.openChat == 1) or g_lua_src == 1 then --开启聊天控制
				if not childUI["chatBtn"] or not childUI["chatBtn"].childUI["NoteJianTou"] then
					return
				end

				----------------------------------------------------------------------------
				--检测聊天新消息提示叹号
				local noticeFlag = LuaGetChatWorldNoticeFlag(g_curPlayerName) or 0
				if (noticeFlag == 1) then
					childUI["chatBtn"].childUI["NoteJianTou"].handle._n:setVisible(true)
				else
					childUI["chatBtn"].childUI["NoteJianTou"].handle._n:setVisible(false)
				end
			end
		end

		on_refresh_chatbtn_notice()

		on_refresh_medal_state_ui = function()
			on_refresh_chatbtn_notice()
		end

		--聊天相关
		--监听收到聊天模块初始化事件，刷新点将台、战术卡、成就任务活动、竞技场锦囊、商城今日刷新商品、评价，等叹号提示
		hGlobal.event:listen("LocalEvent_Group_ChatInitEvent", "__MainBaseChatBtnNoticeRefresh__", on_refresh_chatbtn_notice)
		--监听收到单条聊天消息事件，刷新点将台、战术卡、成就任务活动、竞技场锦囊、商城今日刷新商品、评价，等叹号提示
		hGlobal.event:listen("LocalEvent_Group_SingleChatMessageEvent", "__MainBaseChatBtnNoticeRefresh__", on_refresh_chatbtn_notice)
		--监听收到删除单条聊天消息事件，刷新点将台、战术卡、成就任务活动、竞技场锦囊、商城今日刷新商品、评价，等叹号提示
		hGlobal.event:listen("LocalEvent_Group_RemoveChatMessageEvent", "__MainBaseChatBtnNoticeRefresh__", on_refresh_chatbtn_notice)
		--监听收到增加单个私聊好友
		hGlobal.event:listen("LocalEvent_Group_PrivateFriendAddEvent", "__MainBaseChatBtnNoticeRefresh__", on_refresh_chatbtn_notice)
		--监听收到删除单个私聊好友
		hGlobal.event:listen("LocalEvent_Group_PrivateFriendRemoveEvent", "__MainBaseChatBtnNoticeRefresh__", on_refresh_chatbtn_notice)
		--触发事件：刷新点将台、战术卡、成就任务活动、竞技场锦囊、商城今日刷新商品、评价，等叹号提示
		hGlobal.event:listen("LocalEvent_RefreshMedalStateUI", "__MainBaseMedalStateUIRefresh__", on_refresh_medal_state_ui)
		-------------------------------------------------------
		
		do
			local x = hVar.SCREEN.w - 66
			local y = 68
			if hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.HORIZONTAL then
				x = 642
			end
			
			_childUI["btn_shop"] = hUI.button:new({
				parent = _parent,
				x = x,
				y = y,
				dragbox = _frm.childUI["dragBox"],
				scaleT = 0.95,
				--model = "misc/skillup/talk.png",
				model = "ICON:DRAGON_OPEN",
				z = 1,
				code = function(self, screenX, screenY, isInside)
					--GameManager.StartTest(nil,"world/yxys_ex_001")
					--print("AAA")
					
					--geyachao: 不删除world，只是swich scene
					--[[
					if hGlobal.WORLD.LastWorldMap then
						hGlobal.WORLD.LastWorldMap:del()
						hGlobal.WORLD.LastWorldMap = nil
						--print(""..abc)
						--hApi.debug_floatNumber("hGlobal.WORLD.LastWorldMap = nil 16")
					end
					]]
					if _nUnlockviparea == - 1 then
						_nUnlockviparea = hApi.GetUnlockStateByName("viparea")
					end
					if _nUnlockviparea > 0 then
						--查询VIP等级和领取状态
						SendCmdFunc["get_VIP_Lv_New"]()
						
						--hGlobal.LocalPlayer:setfocusworld(nil)
						hGlobal.event:event("LocalEvent_HideBarrage")
						hGlobal.WORLD.LastWorldMap:disableTimer()
						local chapterId = 99
						hGlobal.event:event("LocalEvent_Phone_ShowPhone_SelecteMap", chapterId)
					end
				end
			})
			_childUI["btn_shop"]:setstate(-1)
			
			--[[
			--切换战车按钮
			_childUI["btn_swich_tank"] = hUI.button:new({
				parent = _parent,
				x = x,
				y = y,
				dragbox = _frm.childUI["dragBox"],
				scaleT = 0.95,
				model = "misc/skillup/select_2.png",
				z = 1,
				code = function(self, screenX, screenY, isInside)
					--切换战车模型
					local unitId = self.data.unitId or 0
					if (unitId > 0) then
						--print("btn_swich_tank", unitId)
						Code_ReplaceTank(unitId)
					end
				end
			})
			_childUI["btn_swich_tank"]:setstate(-1)
			]]
			
			--[[
			--进入随机迷宫按钮
			_childUI["btn_enter_randommap"] = hUI.button:new({
				parent = _parent,
				x = x,
				y = y,
				dragbox = _frm.childUI["dragBox"],
				scaleT = 0.95,
				model = "misc/skillup/talk.png",
				z = 1,
				code = function(self, screenX, screenY, isInside)
					--挡操作
					hUI.NetDisable(30000)
					
					--发送指令，请求挑战随机迷宫
					local MapName = hVar.RandomMap
					local MapDifficulty = 0
					SendCmdFunc["require_battle_entertament"](MapName, MapDifficulty)
				end
			})
			_childUI["btn_enter_randommap"]:setstate(-1)
			]]
		end
	end
	
	--更换战车
	Code_ReplaceTank = function(tankId, bRelaced)
		if (tankId > 0) then
			--当前选中的战车单位
			local tankIdxNow = LuaGetHeroTankIdx()
			--print("tankIdxNow="..tankIdxNow)
			local tank_unit = hVar.tab_unit[hVar.MY_TANK_ID].tank_unit
			local tankIdNow = tank_unit[tankIdxNow]
			
			--print("tankId="..tankId, "tankIdNow"..tankIdNow)
			
			--不重复替换
			if (tankId ~= tankIdNow) or bRelaced then
				--print("更新当前选中的战车索引", tankId)
				--更新当前选中的战车索引
				local tankIdx = 1
				for i = 1, #tank_unit, 1 do
					if (tank_unit[i] == tankId) then --找到了
						tankIdx = i
						break
					end
				end
				--print("LuaSetHeroTankIdx", tankIdx)
				LuaSetHeroTankIdx(tankIdx)
				
				local oWorld = hGlobal.WORLD.LastWorldMap
				local oPlayerMe = oWorld:GetPlayerMe() --我的玩家对象
				local oHero = oPlayerMe.heros[1]
				--print(oHero)
				if oHero then
					local oUnit = oHero:getunit()
					--print(oUnit)
					if oUnit then
						if (oUnit.data.id ~= tankId) then --不重复替换
							local tabU = hVar.tab_unit[tankId]
							local model = tabU.model
							local scale = tabU.scale
							local bind_wheel = tabU.bind_wheel
							
							--读取皮肤索引
							local avaterIdx = LuaGetHeroAvaterIdx(tankId)
							local avaterId = tabU.avater[avaterIdx] or 0
							model = hVar.tab_avater[avaterId].model
							bind_wheel = hVar.tab_avater[avaterId].bind_wheel
							scale = hVar.tab_avater[avaterId].scale
							
							oUnit.handle.__UnitModelName = model
							oUnit.data.scale = scale * 100
							oUnit:initmodel()
							
							--替换轮子
							if (oUnit.data.bind_wheel ~= 0) then
								oUnit.data.bind_wheel:del()
								oUnit.data.bind_wheel = 0
							end
							
							--也替换静态表的数据
							local currentUnitId = oUnit.data.id
							local tabUCurrent = hVar.tab_unit[currentUnitId]
							tabUCurrent.model = model
							tabUCurrent.scale = scale
							tabUCurrent.bind_wheel = bind_wheel
							
							--属性重算
							oUnit:__AttrRecheckBasic(tabU.attr)
							
							--tank: 是否有绑定的单位（坦克轮子）
							local worldX, worldY = hApi.chaGetPos(oUnit.handle) --目标的位置
							if bind_wheel then
								--local worldX, worldY = hApi.chaGetPos(oUnit.handle) --目标的位置
								local gridX, gridY = oWorld:xy2grid(worldX, worldY)
								local lv = oUnit
								local owner = oUnit:getowner():getpos()
								local facing = oUnit.data.facing
								local lv = oUnit.attr.lv
								local star = oUnit.attr.star
								local bind_wheel2 = oWorld:addunit(bind_wheel, owner, gridX, gridY, facing, worldX, worldY, nil, nil, lv, star)
								oUnit.data.bind_wheel = bind_wheel2
								bind_wheel2.data.bind_wheel_owner = oUnit
							end
							
							--也替换静态表的数据
							tabUCurrent.attr.hp = tabU.attr.hp
							tabUCurrent.attr.hp_restore = tabU.attr.hp_restore
							tabUCurrent.attr.move_speed = tabU.attr.move_speed
							tabUCurrent.attr.atk_radius = tabU.attr.atk_radius
							tabUCurrent.attr.atk_defend_radius = tabU.attr.atk_defend_radius
							tabUCurrent.attr.atk_interval = tabU.attr.atk_interval
							tabUCurrent.attr.def_physic = tabU.attr.def_physic
							tabUCurrent.attr.def_magic = tabU.attr.def_magic
							tabUCurrent.attr.def_ice = tabU.attr.def_ice
							tabUCurrent.attr.def_thunder = tabU.attr.def_thunder
							tabUCurrent.attr.def_fire = tabU.attr.def_fire
							tabUCurrent.attr.def_poison = tabU.attr.def_poison
							tabUCurrent.attr.def_bullet = tabU.attr.def_bullet
							tabUCurrent.attr.def_bomb = tabU.attr.def_bomb
							tabUCurrent.attr.def_chuanci = tabU.attr.def_chuanci
							tabUCurrent.attr.dodge_rate = tabU.attr.dodge_rate --基础闪避几率（去百分号后的值）
							tabUCurrent.attr.inertia = tabU.attr.inertia
							tabUCurrent.attr.rebirth_time = tabU.attr.rebirth_time
							tabUCurrent.attr.melee_stone = tabU.attr.melee_stone
							
							--基地的红绿灯显示
							local baseunitId = 0
							if (tankId == 6109) then
								baseunitId = 5068
							elseif (tankId == 6107) then
								baseunitId = 5128
							elseif (tankId == 6108) then
								baseunitId = 5130
							end
							local base_oUunit = (_tReplaceTankUnitList.tank[tankId] or {})[2]
							--[[
							--print("baseunitId=", baseunitId)
							oWorld:enumunitArea(0,worldX, worldY,2000,function(eu)
								--print("eu.data.id=", eu.data.id)
								if (eu.data.id == baseunitId) then
									base_oUunit = eu
								end
							end)
							]]
							if base_oUunit then
								--base_oUunit:sethide(1)
							end
							
							--基地的绿灯
							local baseunitId_green = 5069
							local base_oUunit_green = _tReplaceTankUnitList.driveway_green
							--[[
							--print("baseunitId_green=", baseunitId_green)
							oWorld:enumunitArea(0,worldX, worldY,500,function(eu)
								--print("eu.data.id=", eu.data.id)
								if (eu.data.id == baseunitId_green) then
									base_oUunit_green = eu
								end
							end)
							]]
							if base_oUunit_green then
								local basex, basey = hApi.chaGetPos(base_oUunit.handle) --目标的位置
								hApi.chaSetPos(base_oUunit_green.handle, basex, basey)
							end
							
							--基地当前出战的战车隐藏
							oWorld:enumunitArea(0,worldX, worldY,2000,function(eu)
								--print("eu.data.id=", eu.data.id)
								if (eu.data.id == 6109) or (eu.data.id == 6107) or (eu.data.id == 6108) then
									if (eu.data.id == tankId) then
										eu:sethide(1)
										if (eu.data.bind_weapon ~= 0) then
											eu.data.bind_weapon:sethide(1)
										end
										if (eu.data.bind_wheel ~= 0) then
											eu.data.bind_wheel:sethide(1)
										end
									else
										eu:sethide(0)
										if (eu.data.bind_weapon ~= 0) then
											eu.data.bind_weapon:sethide(0)
										end
										if (eu.data.bind_wheel ~= 0) then
											eu.data.bind_wheel:sethide(0)
										end
									end
								end
							end)
						end
					end
				end
			end
		end
	end

	Code_UpdateTankInfo = function()
		for tankId,info in pairs(_tReplaceTankUnitList.tank) do
			local tankunit = info[2]
			local level = 1
			local nexp = 0 
			local tHeroCard = hApi.GetHeroCardById(tankId)
			--print("tankId=", tankId, tHeroCard)
			if tHeroCard then
				level = tHeroCard.attr.level
				nexp = tHeroCard.attr.exp
				--print(level,nexp)
				--table_print(tHeroCard)
			end
			
			hApi.safeRemoveT(tankunit.chaUI,"lab_lv")
			tankunit.chaUI["lab_lv"] = hUI.label:new({
				parent = tankunit.handle._tn,
				font = "numGreen",
				align = "MC",
				size = 20,
				text = tostring(level),
				x = 57,
				y = 65,
				--RGB = {255,200,0},
			})

			local nextExp = hVar.TANK_LEVELUP_EXP[level].nextExp --下一级所需经验值
			local curExp = nexp - hVar.TANK_LEVELUP_EXP[level].minExp --本级经验值

			hApi.safeRemoveT(tankunit.chaUI,"bar_exp")
			tankunit.chaUI["bar_exp"] = hUI.valbar:new({
				parent = tankunit.handle._tn,
				x = - 34,
				y = 59,
				w = 66,
				h = 9,
				align = "LC",
				model = "UI:IMG_ValueBar",
				animation = "blue",
				--v = curExp,
				--max = nextExp,
			})
			tankunit.chaUI["bar_exp"]:setV(curExp,nextExp)
		end
	end
	
	--更换宠物（宠物出战）
	Code_ReplacePet = function()
		--改变宠物
		local unitid = _tTalkUnitInfo.target.data.id
		local petIdx = LuaGetHeroPetIndexById(hVar.MY_TANK_ID,unitid)
		
		local currentIdx = LuaGetHeroPetIdx(hVar.MY_TANK_ID)
		local currentIdx2 = LuaGetHeroPetIdx2(hVar.MY_TANK_ID)
		local currentIdx3 = LuaGetHeroPetIdx3(hVar.MY_TANK_ID)
		local currentIdx4 = LuaGetHeroPetIdx4(hVar.MY_TANK_ID)
		
		if _tSelectUnitList.selectPet then
			_tSelectUnitList.selectPet:sethide(0)
		end
		_tTalkUnitInfo.target:sethide(1)
		_tSelectUnitList.selectPet = _tTalkUnitInfo.target
		
		if (currentIdx == 0) then
			LuaSetHeroPetIdx(hVar.MY_TANK_ID, petIdx)
		elseif (currentIdx2 == 0) then
			LuaSetHeroPetIdx2(hVar.MY_TANK_ID, petIdx)
		elseif (currentIdx3 == 0) then
			LuaSetHeroPetIdx3(hVar.MY_TANK_ID, petIdx)
		elseif (currentIdx4 == 0) then
			LuaSetHeroPetIdx4(hVar.MY_TANK_ID, petIdx)
		end
		
		local keyList = {"card",}
		LuaSavePlayerData_Android_Upload(keyList, "宠物跟随")
		
		hApi.PlaySound("open")
		
		--添加(替换)地图上的宠物
		--print(petIdx)
		if (petIdx > 0) then
			local oWorld = hGlobal.WORLD.LastWorldMap
			local oPlayerMe = oWorld:GetPlayerMe() --我的玩家对象
			local oHero = oPlayerMe.heros[1]
			--print(oHero)
			if oHero then
				local oUnit = oHero:getunit()
				--print(oUnit)
				if oUnit then
					local randPosX, randPosY = hApi.chaGetPos(oUnit.handle)
					local petPosX = randPosX + oWorld:random(-50, 50) --随机x位置
					local petPosY = randPosY + oWorld:random(-50, 50) --随机y位置
					petPosX, petPosY = hApi.Scene_GetSpace(petPosX, petPosY, 50)
					
					--[[
					--之前有宠物
					if (oWorld.data.follow_pet_unit ~= 0) then
						petPosX, petPosY = hApi.chaGetPos(oWorld.data.follow_pet_unit.handle)
						
						oWorld.data.rpgunits[oWorld.data.follow_pet_unit] = nil
						oWorld.data.follow_pet_unit:del()
					end
					]]
					
					local tPet = hVar.tab_unit[hVar.MY_TANK_ID].pet_unit
					if tPet then
						local petId = tPet[petIdx].summonUnit
						--print("petId=", petId)
						local petStar = LuaGetHeroPetLv(hVar.MY_TANK_ID, petIdx)
						local petLv = LuaGetHeroPetExp(hVar.MY_TANK_ID, petIdx)
						local petSide = 1 --蜀国
						if (oWorld.data.tdMapInfo.mapMode == hVar.MAP_TD_TYPE.TANKCONFIG) then --配置坦克地图
							petSide = 21
						end
						local oPetUnit = oWorld:addunit(petId, petSide, nil ,nil, angle, petPosX, petPosY, nil, nil, petLv, petStar)
						
						oWorld.data.rpgunits[oPetUnit] = oPetUnit:getworldC() --标记是我方单位
						oWorld.data.follow_pet_unit = oPetUnit
					end
				end
			end
		end
		
		hGlobal.event:event("clearUpgradePetsFrm")
		Code_CheckTalkEvent()
	end
	
	--取消宠物跟随
	Code_CancelFollowPet = function()
		--改变宠物
		local unitid = _tTalkUnitInfo.target.data.id
		local petIdx = LuaGetHeroPetIndexById(hVar.MY_TANK_ID,unitid)
		
		local currentIdx = LuaGetHeroPetIdx(hVar.MY_TANK_ID)
		local currentIdx2 = LuaGetHeroPetIdx2(hVar.MY_TANK_ID)
		local currentIdx3 = LuaGetHeroPetIdx3(hVar.MY_TANK_ID)
		local currentIdx4 = LuaGetHeroPetIdx4(hVar.MY_TANK_ID)
		
		if _tSelectUnitList.selectPet then
			_tSelectUnitList.selectPet:sethide(0)
		end
		--_tTalkUnitInfo.target:sethide(1) --同一个单位，就不隐藏了
		_tSelectUnitList.selectPet = _tTalkUnitInfo.target
		
		if (currentIdx == petIdx) then
			LuaSetHeroPetIdx(hVar.MY_TANK_ID, 0)
		elseif (currentIdx2 == petIdx) then
			LuaSetHeroPetIdx2(hVar.MY_TANK_ID, 0)
		elseif (currentIdx3 == petIdx) then
			LuaSetHeroPetIdx3(hVar.MY_TANK_ID, 0)
		elseif (currentIdx4 == petIdx) then
			LuaSetHeroPetIdx4(hVar.MY_TANK_ID, 0)
		end
		
		local keyList = {"card",}
		LuaSavePlayerData_Android_Upload(keyList, "取消宠物跟随")
		
		hApi.PlaySound("open")
		
		--删除地图上的宠物
		--print(petIdx)
		if (petIdx > 0) then
			local oWorld = hGlobal.WORLD.LastWorldMap
			local oPlayerMe = oWorld:GetPlayerMe() --我的玩家对象
			local oHero = oPlayerMe.heros[1]
			--print(oHero)
			if oHero then
				local oUnit = oHero:getunit()
				--print(oUnit)
				if oUnit then
					--[[
					local randPosX, randPosY = hApi.chaGetPos(oUnit.handle)
					local petPosX = randPosX + oWorld:random(-50, 50) --随机x位置
					local petPosY = randPosY + oWorld:random(-50, 50) --随机y位置
					petPosX, petPosY = hApi.Scene_GetSpace(petPosX, petPosY, 50)
					
					--之前有宠物
					if (oWorld.data.follow_pet_unit ~= 0) then
						petPosX, petPosY = hApi.chaGetPos(oWorld.data.follow_pet_unit.handle)
						
						oWorld.data.rpgunits[oWorld.data.follow_pet_unit] = nil
						oWorld.data.follow_pet_unit:del()
						
						--标记没跟随宠物了
						oWorld.data.follow_pet_unit = 0
					end
					]]
					local tPet = hVar.tab_unit[hVar.MY_TANK_ID].pet_unit
					if tPet then
						local petId = tPet[petIdx].summonUnit
						
						--遍历全部单位
						oWorld:enumunit(function(eu)
							if (eu.data.id == petId) then
								oWorld.data.rpgunits[eu] = nil
								eu:del()
							end
						end)
					end
				end
			end
		end
		
		hGlobal.event:event("clearUpgradePetsFrm")
		Code_CheckTalkEvent()
	end
	
	--主基地派遣宠物挖矿
	Code_SendPetWaKuang = function()
		local oWorld = hGlobal.WORLD.LastWorldMap
		local oPlayerMe = oWorld:GetPlayerMe() --我的玩家对象
		local oHero = oPlayerMe.heros[1]
		--print(oHero)
		if oHero then
			local oUnit = oHero:getunit()
			--print(oUnit)
			if oUnit then
				local oTarget = _tTalkUnitInfo.target
				local unitid = _tTalkUnitInfo.target.data.id
				
				--隐藏宠物
				oTarget:sethide(1)
				
				--释放技能
				local petIdx = LuaGetHeroPetIndexById(hVar.MY_TANK_ID,unitid)
				local tPet = hVar.tab_unit[hVar.MY_TANK_ID].pet_unit
				local wakuangUnit = tPet[petIdx].wakuangUnit --挖矿单位
				local wakuangSkill = tPet[petIdx].wakuangSkill --挖矿技能
				local targetX, targetY = hApi.chaGetPos(oTarget.handle) --目标的位置
				local gridX, gridY = oWorld:xy2grid(targetX, targetY)
				local skillId = wakuangSkill --技能
				local skillLv = 1
				local tCastParam = {level = wakuangUnit,}
				hApi.CastSkill(oUnit, skillId, nil, nil, oTarget, gridX, gridY, tCastParam)
			end
		end
		
		hGlobal.event:event("clearUpgradePetsFrm")
		Code_CheckTalkEvent()
	end
	
	--主基地派遣宠物挖体力
	Code_SendPetWaTiLi = function()
		local oWorld = hGlobal.WORLD.LastWorldMap
		local oPlayerMe = oWorld:GetPlayerMe() --我的玩家对象
		local oHero = oPlayerMe.heros[1]
		--print(oHero)
		if oHero then
			local oUnit = oHero:getunit()
			--print(oUnit)
			if oUnit then
				local oTarget = _tTalkUnitInfo.target
				local unitid = _tTalkUnitInfo.target.data.id
				
				--隐藏宠物
				oTarget:sethide(1)
				
				--释放技能
				local petIdx = LuaGetHeroPetIndexById(hVar.MY_TANK_ID,unitid)
				local tPet = hVar.tab_unit[hVar.MY_TANK_ID].pet_unit
				local watiliUnit = tPet[petIdx].watiliUnit --挖体力单位
				local watiliSkill = tPet[petIdx].watiliSkill --挖体力技能
				local targetX, targetY = hApi.chaGetPos(oTarget.handle) --目标的位置
				local gridX, gridY = oWorld:xy2grid(targetX, targetY)
				local skillId = watiliSkill --技能
				local skillLv = 1
				local tCastParam = {level = watiliUnit,}
				hApi.CastSkill(oUnit, skillId, nil, nil, oTarget, gridX, gridY, tCastParam)
			end
		end
		
		hGlobal.event:event("clearUpgradePetsFrm")
		Code_CheckTalkEvent()
	end
	
	--主基地取消宠物挖矿
	Code_CancelPetWaKuang = function()
		local oWorld = hGlobal.WORLD.LastWorldMap
		local oPlayerMe = oWorld:GetPlayerMe() --我的玩家对象
		local oHero = oPlayerMe.heros[1]
		--print(oHero)
		if oHero then
			local oUnit = oHero:getunit()
			--print(oUnit)
			if oUnit then
				local oTarget = _tTalkUnitInfo.target
				local unitid = _tTalkUnitInfo.target.data.id
				
				--显示宠物
				oTarget:sethide(0)
				
				--删除地图上在挖矿的宠物
				local petIdx = LuaGetHeroPetIndexById(hVar.MY_TANK_ID,unitid)
				local tPet = hVar.tab_unit[hVar.MY_TANK_ID].pet_unit
				local wakuangUnit = tPet[petIdx].wakuangUnit --挖矿单位
				local wakuangSkill = tPet[petIdx].wakuangSkill --挖矿技能
				
				--print(wakuangUnit, wakuangSkill)
				
				--遍历全部单位
				oWorld:enumunit(function(eu)
					if (eu.data.id == wakuangUnit) then
						eu:del()
					end
				end)
			end
		end
		
		hGlobal.event:event("clearUpgradePetsFrm")
		Code_CheckTalkEvent()
	end
	
	--主基地取消宠物挖体力
	Code_CancelPetWaTiLi = function()
		local oWorld = hGlobal.WORLD.LastWorldMap
		local oPlayerMe = oWorld:GetPlayerMe() --我的玩家对象
		local oHero = oPlayerMe.heros[1]
		--print(oHero)
		if oHero then
			local oUnit = oHero:getunit()
			--print(oUnit)
			if oUnit then
				local oTarget = _tTalkUnitInfo.target
				local unitid = _tTalkUnitInfo.target.data.id
				
				--显示宠物
				oTarget:sethide(0)
				
				--删除地图上在挖体力宠物
				local petIdx = LuaGetHeroPetIndexById(hVar.MY_TANK_ID,unitid)
				local tPet = hVar.tab_unit[hVar.MY_TANK_ID].pet_unit
				local watiliUnit = tPet[petIdx].watiliUnit --挖体力单位
				local watiliSkill = tPet[petIdx].watiliSkill --挖体力技能
				
				--print(watiliUnit, watiliSkill)
				
				--遍历全部单位
				oWorld:enumunit(function(eu)
					if (eu.data.id == watiliUnit) then
						eu:del()
					end
				end)
			end
		end
		
		hGlobal.event:event("clearUpgradePetsFrm")
		Code_CheckTalkEvent()
	end
	
	--主基地更新科学家成就皮肤
	Code_RefreshScientstAchievement = function()
		local oWorld = hGlobal.WORLD.LastWorldMap
		local oPlayerMe = oWorld:GetPlayerMe() --我的玩家对象
		local oHero = oPlayerMe.heros[1]
		--print(oHero)
		if oHero then
			local oUnit = oHero:getunit()
			--print(oUnit)
			if oUnit then
				--遍历全部单位
				oWorld:enumunit(function(eu)
					if (eu.data.id == 11056) then --科学家成就1
						local sa = LuaGetScientistAchievnemtn1()
						if (sa == 0) then
							eu:sethide(1)
						else
							eu:sethide(0)
						end
					elseif (eu.data.id == 11057) then --科学家成就2
						local sa = LuaGetScientistAchievnemtn2()
						if (sa == 0) then
							eu:sethide(1)
						else
							eu:sethide(0)
						end
					elseif (eu.data.id == 11058) then --科学家成就3
						local sa = LuaGetScientistAchievnemtn3()
						if (sa == 0) then
							eu:sethide(1)
						else
							eu:sethide(0)
						end
					elseif (eu.data.id == 11059) then --科学家成就4
						local sa = LuaGetScientistAchievnemtn4()
						if (sa == 0) then
							eu:sethide(1)
						else
							eu:sethide(0)
						end
					end
				end)
			end
		end
	end
	
	--主基地更新战车死亡成就皮肤
	Code_RefreshTankDeadthAchievement = function()
		local oWorld = hGlobal.WORLD.LastWorldMap
		local oPlayerMe = oWorld:GetPlayerMe() --我的玩家对象
		local oHero = oPlayerMe.heros[1]
		--print(oHero)
		if oHero then
			local oUnit = oHero:getunit()
			--print(oUnit)
			if oUnit then
				--遍历全部单位
				oWorld:enumunit(function(eu)
					if (eu.data.id == 11060) then --垃圾堆成就1
						local sa = LuaGetTankDeadthAchievnemtn1()
						if (sa == 0) then
							eu:sethide(1)
						else
							eu:sethide(0)
						end
					elseif (eu.data.id == 11061) then --垃圾堆成就2
						local sa = LuaGetTankDeadthAchievnemtn2()
						if (sa == 0) then
							eu:sethide(1)
						else
							eu:sethide(0)
						end
					elseif (eu.data.id == 11062) then --垃圾堆成就3
						local sa = LuaGetTankDeadthAchievnemtn3()
						if (sa == 0) then
							eu:sethide(1)
						else
							eu:sethide(0)
						end
					elseif (eu.data.id == 11063) then --垃圾堆成就4
						local sa = LuaGetTankDeadthAchievnemtn4()
						if (sa == 0) then
							eu:sethide(1)
						else
							eu:sethide(0)
						end
					elseif (eu.data.id == 11064) then --垃圾堆成就5
						local sa = LuaGetTankDeadthAchievnemtn5()
						if (sa == 0) then
							eu:sethide(1)
						else
							eu:sethide(0)
						end
					end
				end)
			end
		end
	end
	
	--替换模型
	Code_ReplaceModel = function()
		if _tTalkUnitInfo then
			local tUnitCreateParam = nil
			local oWorld = hGlobal.WORLD.LastWorldMap
			local oPlayerMe = oWorld:GetPlayerMe() --我的玩家对象
			local nForceMe = oPlayerMe:getforce() --我的势力
			local newHeroId
			local newWeaponIdx = 1
			if type(oPlayerMe.heros) == "table" then
				local oHero = oPlayerMe.heros[1]
				if oHero then
					local oUnit = oHero:getunit()
					if oUnit then
						local d = oUnit.data
						newHeroId = d.id
						newWeaponIdx = LuaGetHeroWeaponIdx(newHeroId)
						local eu_x, eu_y = hApi.chaGetPos(oUnit.handle)
						tUnitCreateParam = {d.id,d.owner,d.worldX,d.worldY,d.facing}
						--print(d.id,d.owner,worldX,worldY,d.facing)
						oUnit:del()
					end
					--oHero:del()
				end
			end
			hApi.PlaySound("open")
			if _tTalkUnitInfo.talktype == 1 then
				newHeroId = _tTalkUnitInfo.target.data.id
				if _tSelectUnitList.selectUnit then
					
				end
			elseif _tTalkUnitInfo.talktype == 2 then
				newWeaponIdx = tempWeaponList[_tTalkUnitInfo.target.data.id] or 1
				if _tSelectUnitList.selectWeapon then
					if _tSelectUnitList.selectWeapon.data.id ~= _tTalkUnitInfo.target.data.id then
						--_tSelectUnitList.selectWeapon:sethide(0)
						--_tTalkUnitInfo.target:sethide(1)
						_tSelectUnitList.selectWeapon.handle.s:setVisible(true)
						_tTalkUnitInfo.target.handle.s:setVisible(false)
						_tSelectUnitList.selectWeapon = _tTalkUnitInfo.target
					end
				end
			end
			if type(tUnitCreateParam) == "table" and type(newHeroId) == "number" then
				LuaSetHeroWeaponIdx(newHeroId, newWeaponIdx)
				local _,_,worldX,worldY,facing     = unpack(tUnitCreateParam)
				local unit = oWorld:addunit(newHeroId,nForceMe,nil,nil,facing,worldX,worldY)
				unit:setPos(worldX,worldY,facing)
				--local hero = oPlayerMe:createhero(newHeroId)
				--hero:bind(unit)
				local oHero = oPlayerMe.heros[1]
				if oHero then
					oHero:bind(unit)
				end
				hGlobal.event:call("Event_UnitBorn", unit)
				local keyList = {"card", "log",}
				LuaSavePlayerData_Android_Upload(keyList, "更换武器")
				--oPlayerMe.heros[1] = hero
			end
			Code_CheckTalkEvent()
		end
	end
	
	Code_ShowWeaponInfo = function()
		if _tTalkUnitInfo then
			if _tTalkUnitInfo.talktype == 2 then
				local unitid = _tTalkUnitInfo.target.data.id
				hGlobal.event:event("LocalEvent_ShowWeaponInfoFrm",unitid)
			end
		end
	end
	
	Code_UpgradePet = function(unitid)
		hGlobal.event:event("LocalEvent_ShowUpgradePetsFrm",hVar.MY_TANK_ID,unitid)
	end
	
	--主基地更新任务叹号
	Code_UpdateTanHao = function()
		if _childUI then
			--更新任务叹号
			if _childUI["task"] then
				if _childUI["task"].childUI["lvup"] then
					local uiCtrl = _childUI["task"].childUI["lvup"]
					
					--检测是否有签到活动
					local bHaveSignInActivity = hApi.CheckNewActivitySignIn()
					
					--检测是否有可以领取的任务
					local bHaveFinishedTask = hApi.CheckDailyQuest() --日常任务检测（返回 true/false, 有任务完成返回true）
					
					--检测是否有活动
					local bHaveActivity = hApi.CheckNewActivity()
					
					--检测是否有邮件
					local bHaveMailNotice = ((g_mailNotice == 1) and true or false)
					
					local bShowNotice = (bHaveSignInActivity or bHaveFinishedTask or bHaveActivity or bHaveMailNotice)
					uiCtrl.handle._n:setVisible(bShowNotice)
				end
			end
			
			--更新背包叹号
			if _childUI["storehouse"] then
				if _childUI["storehouse"].childUI["lvup"] then
					local uiCtrl = _childUI["storehouse"].childUI["lvup"]
					
					--检测是否有背包的道具可装备到英雄身上
					local bHaveBagTakeOnEquip = hApi.CheckBagTakeOnEquip()
					local bShowNotice = (bHaveBagTakeOnEquip)
					uiCtrl.handle._n:setVisible(bShowNotice)
				end
			end
			
			--更新星星成就叹号
			if _oStarMedalUnit then
				if _oStarMedalUnit.chaUI["lvup"] then
					--检测是否有可领取的星星成就
					local enableAchievementFinish_starCount = hApi.CheckMadelByType(hVar.MEDAL_TYPE.starCount)
					local bShowNotice = (enableAchievementFinish_starCount)
					_oStarMedalUnit.chaUI["lvup"].handle._n:setVisible(bShowNotice)
				end
			end
			
			--更新科学家成就叹号
			if _oEngineerUnit then
				if _oEngineerUnit.chaUI["lvup"] then
					--检测是否有可领取的科学家成就
					local enableAchievementFinish_scientist = hApi.CheckMadelByType(hVar.MEDAL_TYPE.rescueScientist)
					local bShowNotice = (enableAchievementFinish_scientist)
					_oEngineerUnit.chaUI["lvup"].handle._n:setVisible(bShowNotice)
				end
			end
			
			--更新战车死亡成就叹号
			if _oTankDeadthUnit then
				if _oTankDeadthUnit.chaUI["lvup"] then
					--检测是否有可领取的战车死亡成就
					local enableAchievementFinish_deadth = hApi.CheckMadelByType(hVar.MEDAL_TYPE.tankDeadthCount)
					local bShowNotice = (enableAchievementFinish_deadth)
					_oTankDeadthUnit.chaUI["lvup"].handle._n:setVisible(bShowNotice)
				end
			end
		end
	end
	
	Code_UnlockFunc = function()
		if _tTalkUnitInfo and _tTalkUnitInfo.target then
			local oWorld = hGlobal.WORLD.LastWorldMap
			local oPlayerMe = oWorld:GetPlayerMe() --我的玩家对象
			local nForceMe = oPlayerMe:getforce() --我的势力
			local oHero = oPlayerMe.heros[1]
			if oHero then
				local oUnit = oHero:getunit()
				if oUnit then
					if _tTalkUnitInfo.talktype == 2 then
						local nWeaponIdx = tempWeaponList[_tTalkUnitInfo.target.data.id]
						--OnCreateUnlockWeaponTip(oUnit.data.id,nWeaponIdx)
						--hGlobal.event:event("LocalEvent_ShowUnlockWeaponTip",oUnit.data.id,nWeaponIdx)
					end
				end
			end
		end
	end

	Code_InitData = function()
		tempWeaponList = {}
		local oWorld = hGlobal.WORLD.LastWorldMap
		if oWorld then
			local oPlayerMe = oWorld:GetPlayerMe() --我的玩家对象
			local nForceMe = oPlayerMe:getforce() --我的势力
			local oHero = oPlayerMe.heros[1]
			if oHero then
				local oUnit = oHero:getunit()
				if oUnit then
					local tabU = hVar.tab_unit[oUnit.data.id]
					if tabU and type(tabU.weapon_unit) then
						for i = 1,#tabU.weapon_unit do
							tempWeaponList[tabU.weapon_unit[i].unitId] = i
						end
					end
					
				end
			end
		end
		_tTalkWeaponList = {}
		for weaponId in pairs(tempWeaponList) do
			_tTalkWeaponList[weaponId] = 1
		end
		g_closedanmu = hApi.GetDanmuState()
		hGlobal.event:listen("Event_CheckMainBaseTalkEvent", "_MainBase",Code_CheckTalkEvent)
		hGlobal.event:listen("Event_UnitArrive_TD", "_MainBase",Code_CheckTalkEvent)
		hGlobal.event:listen("Event_CheckMainBaseAreaEvent","_MainBase",Code_CheckAreaEvent)
		--local curScore = LuaGetPlayerScore() --当前积分
		--更新总积分
		--if _childUI and _childUI["GoldNum"] then
			--_childUI["GoldNum"]:setText(curScore)
		--end
		print(" XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Code_InitData")
	end

	local createPetUnit_base = function(oWorld,u,refreshBase)
		--print(u.data.id)
		local toff = _petInfo[u.data.id]
		--table_print(toff)
		--u:setPos(u.data.worldX + (toff.x or 0),u.data.worldY + (toff.y or 0),270)
		
		local oldx = u.data.worldX
		local oldy = u.data.worldY
		local to_x_valid = u.data.worldX
		local to_y_valid = u.data.worldY
		if refreshBase ~= 1 then
			to_x_valid = to_x_valid + (toff.x or 0)
			to_y_valid = to_y_valid + (toff.y or 0)
			u.data.worldX = to_x_valid
			u.data.worldY = to_y_valid
			hApi.chaSetPos(u.handle, to_x_valid, to_y_valid)
			local node = u.handle._n
			node:setPosition(to_x_valid, -to_y_valid) --设置角色的位置
		end
		local petIdx = LuaGetHeroPetIndexById(hVar.MY_TANK_ID,u.data.id)
		local lv = LuaGetHeroPetLv(hVar.MY_TANK_ID, petIdx)
		local basex = toff.basex or 0
		local basey = toff.basey or 0
		print(basex,basey)
		if lv == 0 then
			--5181
			local oUnit = oWorld:addunit(5181, 1, nil, nil, 0, to_x_valid + basex, to_y_valid + basey, nil, nil, 1, 1)
			u.data._TempbaseUnit = oUnit
		else
			--5182
		end
	end
	
	Code_ChangeWorldFunc = function()
		local tRecord =  LuaGetRandMapBestRecord(g_curPlayerName)
		local stage = tRecord.stage or 0
		local channelId = xlGetChannelId()
		local oWorld = hGlobal.WORLD.LastWorldMap
		local nWeaponLevel = LuaGetHeroWeaponLv(hVar.MY_TANK_ID,5)	--内网判断等级
		local unlockpet = hApi.GetUnlockStateByName("petarea")
		local unlocktactisc = hApi.GetUnlockStateByName("tacticsarea")
		local unlockentertainment = hApi.GetUnlockStateByName("entertainmentarea")
		local unlockentertainment2 = hApi.GetUnlockStateByName("entertainmentarea2")
		_tDelUnitList["petarea"] = {}
		_tDelUnitList["tacticsarea"] = {}
		_tDelUnitList["entertainmentarea"] = {}
		_tDelUnitList["entertainmentarea2"] = {}
		if oWorld then
			local oPlayerMe = oWorld:GetPlayerMe() --我的玩家对象
			local nForceMe = oPlayerMe:getforce() --我的势力
			local oHero = oPlayerMe.heros[1]
			if oHero then
				local oUnit = oHero:getunit()
				if oUnit then
					local targetInfo = {}
					local ox, oy = hApi.chaGetPos(oUnit.handle)
					oWorld.enumunitAreaAlly(oWorld,nForceMe,ox, oy,5000,function(u)
						if _tTalkWeaponList[u.data.id] == 1 and u.data.bind_weapon_owner == 0 then
							local ox1,oy1 = hApi.chaGetPos(u.handle)
							if oy1 > oy then
								if _weaponScale[u.data.id] then
									u.handle._n:setScale(_weaponScale[u.data.id])
								else
									u.handle._n:setScale(1.2)
								end
								--u.handle.s:setColor(ccc3(30,30,30))
								if oUnit.data.bind_weapon.data.id == u.data.id then
									_tSelectUnitList.selectWeapon = u
									--u:sethide(1)
									u.handle.s:setVisible(false)
								end
								_tWeaponUnitList[#_tWeaponUnitList+1] = u
								Code_AddWeaponCanUpgradeEffect(u)
							end
						elseif _petInfo[u.data.id] then
							_tPetUnitList[#_tPetUnitList + 1] = u
							local currentIdx = LuaGetHeroPetIdx(hVar.MY_TANK_ID)
							local petIdx = LuaGetHeroPetIndexById(hVar.MY_TANK_ID,u.data.id)
							if currentIdx == petIdx then
								_tSelectUnitList.selectPet = u
								_tSelectUnitList.selectPet:sethide(1)
							end
							local facing = math.random(0,360)
							hApi.ChaSetFacing(u.handle, facing)
							Code_CreatePetLvBg(u)
						elseif _turretUnit[u.data.id] then
							_oTurretUnit = u
						elseif u.data.id == oUnit.data.id and oUnit ~= u then
							_tSelectUnitList.selectUnit = u
							u:sethide(1)
							if u.data.bind_wheel then
								u.data.bind_wheel:sethide(1)
							end
							if u.data.bind_weapon then
								u.data.bind_weapon:sethide(1)
							end
							if u.data.bind_light and (u.data.bind_light ~= 0) then
								u.data.bind_light:sethide(1)
							end
						elseif u.data.id == 11030 then	--日常奖励单位
							u:sethide(1)
							_oDailyRewardUnit = u
						elseif u.data.id == 11031 then	--礼包单位
							--_oGiftUnit = u
							if channelId < 100 then
								_oGiftUnit = u
							else
								u:del()
							end
						elseif u.data.id == 11032 then
							if channelId >= 100 then
								u:del()
							end
						elseif u.data.id == 11029 then	--战术卡提示单位
							_oTacticsHelpUnit = u
							if g_Cur_Language==1 then
								hGlobal.event:event("LocalEvent_HideTacticsHelpUnit",0)
							else
								hGlobal.event:event("LocalEvent_HideTacticsHelpUnit",1)
							end
						elseif u.data.id == 5180 then	--战术卡区域的墙
							if unlocktactisc >= 1 then
								u:del()
							else
								local num = #_tDelUnitList["tacticsarea"]
								_tDelUnitList["tacticsarea"][num + 1] = u
							end
						elseif u.data.id == 5181 then	--宠物未解锁底座
							local euForce = u:getowner():getforce()
							if euForce == 1 then
								u:del()
							end
						elseif u.data.id == 5183 then	--宠物区域的墙
							--if g_lua_src == 1 then
								--u:del()
							--else
							if unlockpet > 0 then
								u:del()
							else
								local num = #_tDelUnitList["petarea"]
								_tDelUnitList["petarea"][num + 1] = u
							end
						elseif u.data.id == 5210 or u.data.id == 5211 then
							if unlockentertainment > 0 then
								u:del()
							else
								local num = #_tDelUnitList["entertainmentarea"]
								_tDelUnitList["entertainmentarea"][num + 1] = u
							end
						elseif u.data.id == 5215 then
							if unlockentertainment2 > 0 then
								u:del()
							else
								local num = #_tDelUnitList["entertainmentarea2"]
								_tDelUnitList["entertainmentarea2"][num + 1] = u
							end
						elseif u.data.id == 5068 then
							--6109
							--print(5068,6109)
							_tReplaceTankUnitList.tank[6109] = {
								5068,u
							}
						elseif u.data.id == 5128 then
							--6107
							--print(5128,6107)
							_tReplaceTankUnitList.tank[6107] = {
								5128,u
							}
						elseif u.data.id == 5130 then
							--6108
							--print(5130,6108)
							_tReplaceTankUnitList.tank[6108] = {
								5130,u
							}
						elseif u.data.id == 5069 then
							--print(5069)
							_tReplaceTankUnitList.driveway_green = u
						elseif u.data.id == 11002 then
							_oGopherUnit = u
						elseif u.data.id == 11005 then
							_oWeaponCapsuleUnit = u
							Code_RefreshWeaponCapsuleNum()
						elseif (u.data.id == 11006) then
							_oTacticsCapsuleUnit = u
							Code_RefreshTacticsCapsuleNum()
						elseif (u.data.id == 5142) then
							--_oTacticsCapsuleUnit = u
							--Code_RefreshTacticsCapsuleNum()
						elseif u.data.id == 11007 then
							_oPetCapsuleUnit = u
							Code_RefreshPetCapsuleNum()
						--elseif u.data.id == 11007 then
						--	_oEquipCapsuleUnit = u
						--	Code_RefreshEquipCapsuleNum()
						elseif u.data.id == 11107 then	--瓦力
							if unlockpet > 0 then
								u:del()
							else
								local num = #_tDelUnitList["petarea"]
								_tDelUnitList["petarea"][num + 1] = u
							end
						elseif u.data.id == 11108 then
							if unlocktactisc > 0 then
								u:del()
							else
								local num = #_tDelUnitList["tacticsarea"]
								_tDelUnitList["tacticsarea"][num + 1] = u
							end
						elseif u.data.id == 11003 then
							g_ActionTreeManager.StartMonitoring()
							hGlobal.event:event("LocalEvent_ManagerBlackDragonAction",u,oUnit)
							--u:setanimation({"lie","sleep"})
						elseif u.data.id == 11110 then
							_tGophersBirth[#_tGophersBirth+1] = u
						elseif u.data.id == 11122 then
							if unlockentertainment > 0 then
								u:del()
							else
								local num = #_tDelUnitList["entertainmentarea"]
								_tDelUnitList["entertainmentarea"][num + 1] = u
							end
						elseif (u.data.id == 11056) then --科学家成就1
							local sa = LuaGetScientistAchievnemtn1()
							if (sa == 0) then
								u:sethide(1)
							else
								u:sethide(0)
							end
						elseif (u.data.id == 11057) then --科学家成就2
							local sa = LuaGetScientistAchievnemtn2()
							if (sa == 0) then
								u:sethide(1)
							else
								u:sethide(0)
							end
						elseif (u.data.id == 11058) then --科学家成就3
							local sa = LuaGetScientistAchievnemtn3()
							if (sa == 0) then
								u:sethide(1)
							else
								u:sethide(0)
							end
						elseif (u.data.id == 11059) then --科学家成就4
							local sa = LuaGetScientistAchievnemtn4()
							if (sa == 0) then
								u:sethide(1)
							else
								u:sethide(0)
							end
						elseif (u.data.id == 11060) then --垃圾堆成就1
							local sa = LuaGetTankDeadthAchievnemtn1()
							if (sa == 0) then
								u:sethide(1)
							else
								u:sethide(0)
							end
						elseif (u.data.id == 11061) then --垃圾堆成就2
							local sa = LuaGetTankDeadthAchievnemtn2()
							if (sa == 0) then
								u:sethide(1)
							else
								u:sethide(0)
							end
						elseif (u.data.id == 11062) then --垃圾堆成就3
							local sa = LuaGetTankDeadthAchievnemtn3()
							if (sa == 0) then
								u:sethide(1)
							else
								u:sethide(0)
							end
						elseif (u.data.id == 11063) then --垃圾堆成就4
							local sa = LuaGetTankDeadthAchievnemtn4()
							if (sa == 0) then
								u:sethide(1)
							else
								u:sethide(0)
							end
						elseif (u.data.id == 11064) then --垃圾堆成就5
							local sa = LuaGetTankDeadthAchievnemtn5()
							if (sa == 0) then
								u:sethide(1)
							else
								u:sethide(0)
							end
						elseif (u.data.id == 11055) then --星星成就单位
							_oStarMedalUnit = u
						elseif (u.data.id == 11004) then --科学家成就单位
							local euForce = u:getowner():getforce()
							if (euForce == 1) then --摆放了3个科学家，就中间的阵营为1
								_oEngineerUnit = u
								Code_CreateEngineerNum()
							end
						elseif (u.data.id == 11065) then --战车死亡成就单位
							--print("更新战车死亡数量", euForce)
							_oTankDeadthUnit = u
							Code_CreateTankDeadthNum()
							
							--动作管理-机械臂伸展
							g_ActionTreeManager.StartMonitoring()
							hGlobal.event:event("LocalEvent_ManagerRoboticArmAction",u,oUnit)
						elseif (u.data.id == 11065) then --战车死亡成就单位
							_oTankDeadthMedalUnit = u
						elseif hVar.UnitToTacticsItemList[u.data.id] then
							Code_CreateTacticsLvBg(u)
						end
					end)
				end
			end
		end
		
		--因动态障碍删除会把整块区域的障碍不做任何判断删除  所以必须放到最后添加动态障碍（初始化）
		for i = 1,#_tPetUnitList do
			local u = _tPetUnitList[i]
			createPetUnit_base(oWorld,u)
		end
		
		--更换战车（初始化）
		local tankIdx = LuaGetHeroTankIdx()
		local tankId = hVar.tab_unit[hVar.MY_TANK_ID].tank_unit[tankIdx]
		Code_ReplaceTank(tankId, true)

		Code_UpdateTankInfo()

		--暂时解决第一次进游戏 数据不刷新的问题
		hApi.addTimerOnce("refreshmainbaseinfo",3000, function()
			hGlobal.event:event("LocalEvent_refreshWeaponInfo",false)
			Code_UpdateTankInfo()
		end)
	end
	
	Code_CheckTacticsCard = function()
		print("Code_CheckTacticsCard")
		--[[
		--geyachao: 发战术卡已经改成服务器处理了，这里不用添加了
		local shouldUpgrade = 0
		for unitid,itemid in pairs(hVar.UnitToTacticsItemList) do
			print(itemid)
			local tabI = hVar.tab_item[itemid]
			if tabI and tabI.tacticId then
				local tabT = hVar.tab_tactics[tabI.tacticId]
				if type(tabT) == "table" then
					local tacticId = tabI.tacticId
					local id = tacticId
					local lv = 0
					local num = 0
					local tacticInfo = LuaGetPlayerTacticById(tacticId)
					if tacticInfo then
						id, lv, num = unpack(tacticInfo)
					end
					if lv == 0 then
						print("lv",lv,id)
						local tacticLvUpInfo = hVar.TACTIC_LVUP_INFO[lv]
						local costDebris = tacticLvUpInfo.costDebris
						LuaAddPlayerTacticDebris(id,costDebris)
						LuaLvUpPlayerTactic(id)
						shouldUpgrade = shouldUpgrade + 1
					end
				end
			end
		end
		if shouldUpgrade > 0 then
			local keyList = {"skill"}
			LuaSavePlayerData_Android_Upload(keyList, "初始化战术技能卡等级")
		end
		]]
	end
	
	Code_CreateTacticsLvBg = function(oUnit,reset)
		print("Code_CreateTacticsLvBg")
		if oUnit then
			_tTacticsUnitList[#_tTacticsUnitList+1] = oUnit
			if reset then
				hApi.safeRemoveT(oUnit.chaUI,"tacticsLvBg")
				hApi.safeRemoveT(oUnit.chaUI,"tacticsnum")
				for i = 1, hVar.TACTIC_LVUP_INFO.maxTacticLv do
					hApi.safeRemoveT(oUnit.chaUI, "tacticsLv"..i)
				end
			end
			if oUnit.chaUI["tacticsLvBg"] == nil then
				local lineW = 15
				oUnit.chaUI["tacticsLvBg"] = hUI.image:new({
					parent = oUnit.handle._n,
					model = "misc/tactics/SlotBG.png",
					--animation = "blue",
					x = 0,
					y = -64,
					z = -255,
				})
				oUnit.chaUI["tacticsLvBg1"] = hUI.image:new({
					parent = oUnit.handle._n,
					model = "misc/tactics/SlotBG.png",
					--animation = "blue",
					x = 0,
					y = -64 - lineW,
					z = -255,
				})
				local itemid = hVar.UnitToTacticsItemList[oUnit.data.id]
				local tabI = hVar.tab_item[itemid]
				local cownum = 5
				if tabI and tabI.tacticId then
					local tabT = hVar.tab_tactics[tabI.tacticId]
					if type(tabT) == "table" then
						local tacticId = tabI.tacticId
						local id = tacticId
						local lv = 0
						local num = 0
						local tacticInfo = LuaGetPlayerTacticById(tacticId)
						if tacticInfo then
							id, lv, num = unpack(tacticInfo)
						end
						--lv = math.random(3,27)
						--lv = 20
						local maxTacticLv = hVar.TACTIC_LVUP_INFO.maxTacticLv

						local startI = math.floor(math.max(0,math.min(lv,maxTacticLv)-1)/10)*10 + 1
						for i = startI,math.min(lv,maxTacticLv) do
							local nline = math.floor( (((i - 1) % 10 + 1) - 1)/cownum)
							local smodel = "misc/tactics/slot_purple.png"
							if i <= 10 then
								smodel = "misc/tactics/slot_yellow.png"
							elseif i <= 20 then
								smodel = "misc/tactics/slot_red.png"
							end
							oUnit.chaUI["tacticsLv"..i] = hUI.image:new({
								parent = oUnit.handle._n,
								model = smodel,
								--animation = "blue",
								x = ((i - 1)% cownum) * 13 - 26,
								y = -64 - nline * lineW,
								z = -255,
							})
						end
						if lv < maxTacticLv then
							local costDebris = hVar.TACTIC_LVUP_INFO[lv].costDebris
							local font = "num"
							--costDebris = 0
							if num < costDebris then
								font = "numRed"
							else
								local nextlv = lv + 1
								local nline = math.floor( (((nextlv - 1) % 10 + 1) - 1)/cownum)
								--print("nline",nline,nextlv)
								oUnit.chaUI["tacticsLv"..nextlv] = hUI.image:new({
									parent = oUnit.handle._n,
									model = "misc/tactics/slot_green.png",
									--animation = "blue",
									x = ((nextlv - 1)% cownum) * 13 - 26,
									y = -64 - nline * lineW,
									z = -254,
								})
								local act1 = CCDelayTime:create(1)
								local act2 = CCFadeOut:create(0.4)
								local act3 = CCDelayTime:create(2)
								local act4 = CCFadeIn:create(0.4)
								local a = CCArray:create()
								a:addObject(act1)
								a:addObject(act2)
								a:addObject(act3)
								a:addObject(act4)
								local sequence = CCSequence:create(a)
								oUnit.chaUI["tacticsLv"..nextlv].handle.s:runAction(CCRepeatForever:create(sequence))
							end
							oUnit.chaUI["tacticsnum"] = hUI.label:new({
								parent = oUnit.handle._n,
								size = 16,
								x = 0,
								y = 50,
								align = "MC",
								font = font,
								text = tostring(num).."/"..tostring(costDebris),
							})
						else
							oUnit.chaUI["tacticsnum"] = hUI.label:new({
								parent = oUnit.handle._n,
								size = 16,
								x = 0,
								y = 50,
								align = "MC",
								font = "num",
								text = tostring(num).."/",
							})
						end
					end
				end
			end
		end
	end

	Code_CreatePetLvBg = function(oUnit,reset)
		--宠物数据结构变化  暂时不显示提示
		if true then
			return
		end
		if oUnit then
			if reset then
				hApi.safeRemoveT(oUnit.chaUI,"petsLvBg")
				for i = 1, 5 do
					hApi.safeRemoveT(oUnit.chaUI, "petsLv"..i)
				end
			end
			local petIdx = LuaGetHeroPetIndexById(hVar.MY_TANK_ID,oUnit.data.id)
			if petIdx > 0 and hVar.EnablePetUpgrade == 1 then
				local offx,offy = 0,0
				if type(_petInfo[oUnit.data.id] == "table") then
					offx = _petInfo[oUnit.data.id].lv_x or 0
					offy = _petInfo[oUnit.data.id].lv_y or 0
				end
				local lv = LuaGetHeroPetLv(hVar.MY_TANK_ID, petIdx)
				if oUnit.chaUI["petsLvBg"] == nil and lv > 0 then
					oUnit.chaUI["petsLvBg"] = hUI.image:new({
						parent = oUnit.handle._n,
						model = "misc/tactics/SlotBG.png",
						--animation = "blue",
						x = 0 + offx,
						y = -64 + offy,
						z = -255,
					})
					
					local maxLv = hVar.PET_LVUP_INFO_NEW.maxPetLv
					
					for i = 1,math.min(lv,maxLv) do
						oUnit.chaUI["petsLv"..i] = hUI.image:new({
							parent = oUnit.handle._n,
							model = "misc/tactics/Slot.png",
							--animation = "blue",
							x = ((i - 1)% maxLv) * 13 - 26 + offx,
							y = -64 + offy,
							z = -255,
						})
					end
					if LuaCheckHeroPetCanUpgrade(hVar.MY_TANK_ID, petIdx) then
						local nextlv = lv + 1
						oUnit.chaUI["petsLv"..nextlv] = hUI.image:new({
							parent = oUnit.handle._n,
							model = "misc/tactics/Slot.png",
							--animation = "blue",
							x = ((nextlv - 1)% maxLv) * 13 - 26 + offx,
							y = -64 + offy,
							z = -255,
						})
						oUnit.chaUI["petsLv" .. nextlv].handle.s:setColor(ccc3(0, 255, 0))
					end
				end
			end
		end
	end
	
	Code_PlayTacticsLvUpEffect = function(oTarget)
		--local oWorld = hGlobal.WORLD.LastWorldMap
		--if oWorld then
			--local oPlayerMe = oWorld:GetPlayerMe() --我的玩家对象
			--local nForceMe = oPlayerMe:getforce() --我的势力
			--local oHero = oPlayerMe.heros[1]
			--if oHero then
				--local oUnit = oHero:getunit()
				--if oUnit then
					--hApi.safeRemoveT(oUnit.chaUI,"tacticsLvUp")
					--oUnit.chaUI["tacticsLvUp"] = hUI.image:new({
						--parent = oUnit.handle._n,
						--x = 0,
						--y = - 40,
						--z = 1000,
						--model = "MODEL_EFFECT:upgrade",
						--align = "MC",
					--})
				--end
			--end
		--end
		local oWorld = hGlobal.WORLD.LastWorldMap
		if oWorld and oTarget then
			hApi.PlaySound("tactics_upgrade")
			oWorld:addeffect(12, 1.0 ,nil, oTarget.data.worldX, oTarget.data.worldY)
		end
	end
	
	--刷新顺风箱子、刷新评价按钮状态
	Code_CheckDailyReward = function()
		--print("刷新顺风箱子、刷新评价按钮状态")
		--print("_oDailyRewardUnit=", _oDailyRewardUnit)
		--[[
		if _oDailyRewardUnit then
			if (g_cur_net_state == 1) then
				--local tRecord =  LuaGetRandMapBestRecord(g_curPlayerName)
				--local stage = tRecord.stage or 0
				local stage = LuaGetPlayerMapAchi("world/yxys_airship_04", hVar.ACHIEVEMENT_TYPE.LEVEL) or 0
				--print("stage=", stage)
				if stage >= 1 then
					if LuaGetPlayerGiftstate(1) == 0 then
						_oDailyRewardUnit:sethide(0)
					else
						_oDailyRewardUnit:sethide(1)
					end
					--print(g_MyVip_Param.enable,g_vs_number , g_next_vs_number)
					--if g_MyVip_Param.enable == 1 or g_vs_number < g_next_vs_number then
					--	_childUI["comment"]:setstate(1)
					--end
				else
					_oDailyRewardUnit:sethide(1)
				end
				
				--local tRecord =  LuaGetRandMapBestRecord(g_curPlayerName)
				local stage = tRecord.stage or 0
				local giftstate = LuaGetPlayerGiftstate(3)
				print("stage=", stage)
				print(giftstate)
				
				local clickCount = LuaGetCommentClickCount() --点击按钮的次数
				print("clickCount",clickCount)
				--通关第一关显示评价按钮
				if stage >= 1 then
					--通关第n关且拿过评价奖励且点开过10次 则不再显示
					if giftstate == 1 and stage >= 1 and clickCount > 10 then
						_childUI["comment"]:setstate(-1)
					else
						_childUI["comment"]:setstate(1)
					end
				else
					_childUI["comment"]:setstate(-1)
				end
				
				if giftstate == 0 then
					_childUI["comment"].childUI["tanhao"].handle._n:setVisible(true)
				else
					_childUI["comment"].childUI["tanhao"].handle._n:setVisible(false)
				end
			else
				_oDailyRewardUnit:sethide(1)
			end
		end
		]]
		
		local stage = LuaGetPlayerMapAchi("world/yxys_airship_04", hVar.ACHIEVEMENT_TYPE.LEVEL) or 0
		local giftstate = LuaGetPlayerGiftstate(3)
		print("stage=", stage)
		print("giftstate=", giftstate)
		local clickTimestamp = LuaGetCommentClickTime() --上次评价的时间戳（北京时间）
		print("clickTimestamp", os.date("%Y-%m-%d %H:%M:%S", clickTimestamp))
		--当前时间
		local clienttime = os.time()
		local hosttime = clienttime - g_localDeltaTime_pvp --(Local = Host + deltaTime)
		local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
		local delteZone = localTimeZone - hVar.SYS_TIME_ZONE --与北京时间的时差
		hosttime = hosttime - delteZone * 3600 --GMT+8时区
		local deltatime = hosttime - clickTimestamp
		print("deltatime=", deltatime)
		
		--通关第一关显示评价按钮
		if _childUI then
			if _childUI["comment"] then
				if stage >= 1 then
					--通关第n关且拿过评价奖励且点开大于72小时 则不再显示
					if giftstate == 1 and stage >= 1 and deltatime > 259200 then
						_childUI["comment"]:setstate(-1)
					else
						_childUI["comment"]:setstate(1)
					end
				else
					_childUI["comment"]:setstate(-1)
				end
				
				if giftstate == 0 then
					_childUI["comment"].childUI["tanhao"].handle._n:setVisible(true)
				else
					_childUI["comment"].childUI["tanhao"].handle._n:setVisible(false)
				end
			end
		end
	end
	
	--管理员调试模式
	Code_CheckAdminDebug = function()
		if (g_is_account_test == 1) then --测试员
			--
		elseif (g_is_account_test == 2) then --管理员
			if _childUI then
				if _childUI["adminDebugBun"] then
					_childUI["adminDebugBun"]:setstate(1)
					_childUI["adminDebugBun"].childUI["star1"].handle._n:setVisible(true)
					_childUI["adminDebugBun"].childUI["star2"].handle._n:setVisible(true)
				end
			end
		end
	end
	
	--战车昨日排名
	Code_ReceiveTankYesterdayRank = function(uid, rid ,rank)
		--print("Code_ReceiveTankYesterdayRank", uid, rid ,rank)
		
		if _oDailyRewardUnit then
			--更新昨日排名
			if (_oDailyRewardUnit.chaUI["UITop"] == nil) then
				_oDailyRewardUnit.chaUI["UITop"] = hUI.image:new({
					parent = _oDailyRewardUnit.handle._n,
					x = 0,
					y = 56,
					model = "misc/billboard/top.png",
					align = "MC",
					scale = 1.0,
				})
			end
			
			if (_oDailyRewardUnit.chaUI["UITopRank"] == nil) then
				_oDailyRewardUnit.chaUI["UITopRank"] = hUI.image:new({
					parent = _oDailyRewardUnit.handle._n,
					x = 0,
					y = 56,
					model = "misc/billboard/top3.png",
					align = "LC",
					scale = 1.0,
				})
			end
			
			local lastrank = _oDailyRewardUnit.chaUI["UITopRank"].data.rank
			if (rank ~= lastrank) then
				if (rank > 0) then --有排名
					_oDailyRewardUnit.chaUI["UITop"].handle._n:setVisible(true)
					_oDailyRewardUnit.chaUI["UITopRank"].handle._n:setVisible(true)
					
					--找出哪个档位
					--print(hVar.TANK_BILLBOARD_REWARD)
					for i = 1, #hVar.TANK_BILLBOARD_REWARD, 1 do
						local tReward = hVar.TANK_BILLBOARD_REWARD[i]
						if (rank >= tReward.from) and (rank <= tReward.to) then
							local score = tReward.score --500
							local model = tReward.model --"misc/billboard/top10.png"
							
							_oDailyRewardUnit.chaUI["UITopRank"]:setmodel(model, nil, _oDailyRewardUnit.chaUI["UITopRank"].data.w, _oDailyRewardUnit.chaUI["UITopRank"].data.h)
							break
						end
					end
				else --无排名
					_oDailyRewardUnit.chaUI["UITop"].handle._n:setVisible(false)
					_oDailyRewardUnit.chaUI["UITopRank"].handle._n:setVisible(false)
				end
				
				_oDailyRewardUnit.chaUI["UITopRank"].data.rank = rank
			end
		end
	end

	local PlayCapsuleAction = function(oItem)
		local time = math.random(800, 1200)
		--宝物图标随机动画
		local delayTime1 = math.random(800, 1200)
		local delayTime2 = math.random(900, 1500)
		local moveTime = math.random(1000, 2500)
		local moveDy = math.random(8, 16)
		local act1 = CCDelayTime:create(delayTime1/1000)
		local act2 = CCMoveBy:create(moveTime/1000, ccp(0, moveDy))
		local act3 = CCDelayTime:create(delayTime2/1000)
		local act4 = CCMoveBy:create(moveTime/1000, ccp(0, -moveDy))
		local a = CCArray:create()
		a:addObject(act1)
		a:addObject(act2)
		a:addObject(act3)
		a:addObject(act4)
		local sequence = CCSequence:create(a)
		--oItem.handle.s:stopAllActions() --先停掉之前的动作
		oItem.handle.s:runAction(CCRepeatForever:create(sequence))
	end
	
	--刷新武器枪宝箱数量
	Code_RefreshWeaponCapsuleNum = function()
		if _oWeaponCapsuleUnit then
			local weapongunChestNum = LuaGetTankWeaponGunChestNum() --武器枪宝箱数量
			if _oWeaponCapsuleUnit.chaUI["num"] == nil then
				_oWeaponCapsuleUnit.chaUI["num"] = hUI.label:new({
					parent = _oWeaponCapsuleUnit.handle._n,
					x = 0,
					y = 64,
					size = 20,
					font = "num",
					text = tostring(weapongunChestNum),
					align = "MC",
				})
				PlayCapsuleAction(_oWeaponCapsuleUnit)
			else
				_oWeaponCapsuleUnit.chaUI["num"]:setText(tostring(weapongunChestNum))
			end
		end
		
	end
	
	--刷新战术宝箱数量
	Code_RefreshTacticsCapsuleNum = function()
		if _oTacticsCapsuleUnit then
			local tacticChestNum = LuaGetTankTacticChestNum() --战术卡宝箱枪数量
			if _oTacticsCapsuleUnit.chaUI["num"] == nil then
				_oTacticsCapsuleUnit.chaUI["num"] = hUI.label:new({
					parent = _oTacticsCapsuleUnit.handle._n,
					x = 0,
					y = 64,
					size = 20,
					font = "num",
					text = tostring(tacticChestNum),
					align = "MC",
				})
				PlayCapsuleAction(_oTacticsCapsuleUnit)
			else
				_oTacticsCapsuleUnit.chaUI["num"]:setText(tostring(tacticChestNum))
			end
		end
	end
	
	--刷新宠物宝箱数量
	Code_RefreshPetCapsuleNum = function()
		if _oPetCapsuleUnit then
			local petChestNum = LuaGetTankPetChestNum() --宠物宝箱枪数量
			if _oPetCapsuleUnit.chaUI["num"] == nil then
				_oPetCapsuleUnit.chaUI["num"] = hUI.label:new({
					parent = _oPetCapsuleUnit.handle._n,
					x = 0,
					y = 64,
					size = 20,
					font = "num",
					text = tostring(petChestNum),
					align = "MC",
				})
				PlayCapsuleAction(_oPetCapsuleUnit)
			else
				_oPetCapsuleUnit.chaUI["num"]:setText(tostring(petChestNum))
			end
		end
	end
	
	--刷新装备宝箱数量
	Code_RefreshEquipCapsuleNum = function()
		if _oEquipCapsuleUnit then
			local equipChestNum = LuaGetTankEquipChestNum() --装备宝箱枪数量
			if _oEquipCapsuleUnit.chaUI["num"] == nil then
				_oEquipCapsuleUnit.chaUI["num"] = hUI.label:new({
					parent = _oEquipCapsuleUnit.handle._n,
					x = 0,
					y = 64,
					size = 20,
					font = "num",
					text = tostring(equipChestNum),
					align = "MC",
				})
				PlayCapsuleAction(_oEquipCapsuleUnit)
			else
				_oEquipCapsuleUnit.chaUI["num"]:setText(tostring(equipChestNum))
			end
		end
	end

	Code_CreateDishuCoin = function()
		if _oGopherUnit then
			if (_oGopherUnit.chaUI["icon2"] == nil) then
				_oGopherUnit.chaUI["icon2"] = hUI.image:new({
					parent = _oGopherUnit.handle._n,
					x = - 13,
					y = 100,
					scale = 0.8,
					model = "misc/coin2.png",
				})
				_oGopherUnit.chaUI["icon2"].handle._n:setRotation(- 8)
			end
			local coin = LuaGetTankDiShuCoinNum()
			if (_oGopherUnit.chaUI["num"] == nil) then
				_oGopherUnit.chaUI["num"] = hUI.label:new({
					parent = _oGopherUnit.handle._n,
					x = 9,
					y = 96,
					size = 24,
					font = "num",
					text = tostring(coin),
					align = "LC",
				})
				_oGopherUnit.chaUI["num"].handle._n:setRotation(8)
				--_oGopherUnit.chaUI["num"]:setText(12)
			else
				_oGopherUnit.chaUI["num"]:setText(coin)
			end
		end
	end
	
	--更新营救科学家数量
	Code_CreateEngineerNum = function()
		if _oEngineerUnit then
			if (_oEngineerUnit.chaUI["num"] == nil) then
				local scientistNum = LuaGetTankScientistNum()
				_oEngineerUnit.chaUI["num"] = hUI.label:new({
					parent = _oEngineerUnit.handle._n,
					x = -2,
					y = 40,
					size = 20,
					font = "num",
					text = tostring(scientistNum),
					align = "MC",
				})
			end
			
			if (_oEngineerUnit.chaUI["lvup"] == nil) then
				--战车死亡的按钮叹号
				_oEngineerUnit.chaUI["lvup"] = hUI.image:new({
					parent = _oEngineerUnit.handle._n,
					model = "UI:TaskTanHao",
					x = 15 + 15,
					y = 25 - 5 + 20,
					scale = 1.2,
				})
				local act1 = CCMoveBy:create(0.2, ccp(0, 6))
				local act2 = CCMoveBy:create(0.2, ccp(0, -6))
				local act3 = CCMoveBy:create(0.2, ccp(0, 6))
				local act4 = CCMoveBy:create(0.2, ccp(0, -6))
				local act5 = CCDelayTime:create(0.6)
				local act6 = CCRotateBy:create(0.1, 10)
				local act7 = CCRotateBy:create(0.1 * 1, -10 * 2)
				local act8 = CCRotateBy:create(0.1 * 1, 10 * 2)
				local act9 = CCRotateBy:create(0.1, -10)
				local act10 = CCDelayTime:create(0.8)
				local a = CCArray:create()
				a:addObject(act1)
				a:addObject(act2)
				a:addObject(act3)
				a:addObject(act4)
				a:addObject(act5)
				a:addObject(act6)
				a:addObject(act7)
				a:addObject(act8)
				a:addObject(act9)
				a:addObject(act10)
				local sequence = CCSequence:create(a)
				_oEngineerUnit.chaUI["lvup"].handle._n:runAction(CCRepeatForever:create(sequence))
				_oEngineerUnit.chaUI["lvup"].handle._n:setVisible(false) --默认隐藏
			end
			
			--检测是否有可领取的科学家成就
			local enableAchievementFinish_scientist = hApi.CheckMadelByType(hVar.MEDAL_TYPE.rescueScientist)
			local bShowNotice = (enableAchievementFinish_scientist)
			_oEngineerUnit.chaUI["lvup"].handle._n:setVisible(bShowNotice)
		end
	end
	
	--更新战车死亡数量
	Code_CreateTankDeadthNum = function()
		--print("_oTankDeadthUnit=", _oTankDeadthUnit)
		if _oTankDeadthUnit then
			if (_oTankDeadthUnit.chaUI["num"] == nil) then
				local tankDeadthCount = LuaGetTankDeadthNum()
				--print("tankDeadthCount=", tankDeadthCount)
				_oTankDeadthUnit.chaUI["num"] = hUI.label:new({
					parent = _oTankDeadthUnit.handle._n,
					x = -14,
					y = 40 + 40, --比科学家再高一点
					size = 20,
					font = "num",
					text = tostring(tankDeadthCount),
					align = "MC",
				})
			end
			
			if (_oTankDeadthUnit.chaUI["lvup"] == nil) then
				--战车死亡的按钮叹号
				_oTankDeadthUnit.chaUI["lvup"] = hUI.image:new({
					parent = _oTankDeadthUnit.handle._n,
					model = "UI:TaskTanHao",
					x = 15 + 5,
					y = 25 - 5 + 60,
					scale = 1.2,
				})
				local act1 = CCMoveBy:create(0.2, ccp(0, 6))
				local act2 = CCMoveBy:create(0.2, ccp(0, -6))
				local act3 = CCMoveBy:create(0.2, ccp(0, 6))
				local act4 = CCMoveBy:create(0.2, ccp(0, -6))
				local act5 = CCDelayTime:create(0.6)
				local act6 = CCRotateBy:create(0.1, 10)
				local act7 = CCRotateBy:create(0.1 * 1, -10 * 2)
				local act8 = CCRotateBy:create(0.1 * 1, 10 * 2)
				local act9 = CCRotateBy:create(0.1, -10)
				local act10 = CCDelayTime:create(0.8)
				local a = CCArray:create()
				a:addObject(act1)
				a:addObject(act2)
				a:addObject(act3)
				a:addObject(act4)
				a:addObject(act5)
				a:addObject(act6)
				a:addObject(act7)
				a:addObject(act8)
				a:addObject(act9)
				a:addObject(act10)
				local sequence = CCSequence:create(a)
				_oTankDeadthUnit.chaUI["lvup"].handle._n:runAction(CCRepeatForever:create(sequence))
				_oTankDeadthUnit.chaUI["lvup"].handle._n:setVisible(false) --默认隐藏
			end
			
			--检测是否有可领取的战车死亡成就
			local enableAchievementFinish_deadth = hApi.CheckMadelByType(hVar.MEDAL_TYPE.tankDeadthCount)
			local bShowNotice = (enableAchievementFinish_deadth)
			_oTankDeadthUnit.chaUI["lvup"].handle._n:setVisible(bShowNotice)
		end
	end
	
	Code_ClearData = function()
		_IsDrawArea = 0
		_tAreaStateInfo = nil
		_tAreaMaskSprite = {}
		_tGophersBirth = {}
		_tWeaponUnitList = {}
		_tDelUnitList = {}
		_tPetUnitList = {}
		_tGiftRemoveList = {}
		_tSelectUnitList = {}
		_tTacticsUnitList = {}
		local _tReplaceTankUnitList = {
			tank = {},
			driveway_green = nil,
		}
		_nUnlockviparea = -1
		_tLastTalkTarget = nil
		_tTalkUnitInfo = nil
		_oDailyRewardUnit = nil
		_oGiftUnit = nil
		_oTacticsHelpUnit = nil
		_oGopherUnit = nil
		_oTurretUnit = nil
		_oEngineerUnit = nil --科学家成就单位
		_oTankDeadthUnit = nil --战车死亡成就单位
		_oWeaponCapsuleUnit = nil
		_oStarMedalUnit = nil --星星成就单位
		_oTacticsCapsuleUnit = nil
		_oPetCapsuleUnit = nil
		_oEquipCapsuleUnit = nil
		hGlobal.event:listen("Event_CheckMainBaseTalkEvent", "_MainBase",nil)
		hGlobal.event:listen("Event_UnitArrive_TD", "_MainBase",nil)
		hGlobal.event:listen("Event_CheckMainBaseAreaEvent","_MainBase",nil)

		--聊天相关
		--监听收到聊天模块初始化事件，刷新点将台、战术卡、成就任务活动、竞技场锦囊、商城今日刷新商品、评价，等叹号提示
		hGlobal.event:listen("LocalEvent_Group_ChatInitEvent", "__MainBaseChatBtnNoticeRefresh__", nil)
		--监听收到单条聊天消息事件，刷新点将台、战术卡、成就任务活动、竞技场锦囊、商城今日刷新商品、评价，等叹号提示
		hGlobal.event:listen("LocalEvent_Group_SingleChatMessageEvent", "__MainBaseChatBtnNoticeRefresh__", nil)
		--监听收到删除单条聊天消息事件，刷新点将台、战术卡、成就任务活动、竞技场锦囊、商城今日刷新商品、评价，等叹号提示
		hGlobal.event:listen("LocalEvent_Group_RemoveChatMessageEvent", "__MainBaseChatBtnNoticeRefresh__", nil)
		--监听收到增加单个私聊好友
		hGlobal.event:listen("LocalEvent_Group_PrivateFriendAddEvent", "__MainBaseChatBtnNoticeRefresh__", nil)
		--监听收到删除单个私聊好友
		hGlobal.event:listen("LocalEvent_Group_PrivateFriendRemoveEvent", "__MainBaseChatBtnNoticeRefresh__", nil)
		--触发事件：刷新点将台、战术卡、成就任务活动、竞技场锦囊、商城今日刷新商品、评价，等叹号提示
		hGlobal.event:listen("LocalEvent_RefreshMedalStateUI", "__MainBaseMedalStateUIRefresh__", nil)

		hGlobal.event:event("LocalEvent_CloseCommentSystem")
		hApi.clearTimer("refreshmainbaseinfo")
		print(" XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Code_ClearData")
	end

	Code_AddWeaponCanUpgradeEffect = function(unit)
		if unit then
			local weaponid = unit.data.id
			local weaponIndex = LuaGetHeroWeaponIndexById(hVar.MY_TANK_ID, weaponid)
			local lv = LuaGetHeroWeaponLv(hVar.MY_TANK_ID,weaponIndex)
			local bflag = LuaCheckHeroWeaponCanUpgrade(hVar.MY_TANK_ID,weaponIndex)
			print("lv",bflag)
			if bflag then
				Code_AddUpgradeEffect(unit)
			else
				hApi.safeRemoveT(unit.chaUI, "WeaponUpgradeEffect_e")
			end
		end
	end

	Code_AddScreenEffect = function(target)
		if target.chaUI["SelectTalkEffect_c"] == nil then
			hApi.PlaySound("choice")
			target.chaUI["SelectTalkEffect_c"] = hUI.image:new({
				parent = target.handle._n,
				model = "effect/screen.png",
				--animation = "blue",
				--z = -255,
				--w = 128,
			})

			local shandong = CCCallFunc:create(function()
				local x,y = target.chaUI["SelectTalkEffect_c"].data.x,target.chaUI["SelectTalkEffect_c"].data.y
				local act1 = CCDelayTime:create(3)
				local act2 = CCFadeOut:create(0.001)
				local act4 = CCDelayTime:create(0.04)
				local act3 = CCFadeIn:create(0.01)
				local act5 = CCMoveTo:create(0.05,ccp(x+1,y-1))
				local act6 = CCMoveTo:create(0.05,ccp(x-1,y+1))
				local act7 = CCMoveTo:create(0.1,ccp(x,y))
				--local act4 = CCDelayTime:create(1)
				local a = CCArray:create()
				a:addObject(act1)
				--a:addObject(act5)
				--a:addObject(act6)
				--a:addObject(act7)
				a:addObject(act2)
				a:addObject(act4)
				a:addObject(act3)
				
				local sequence = CCSequence:create(a)
				local a1 = CCArray:create()
				a1:addObject(act5)
				a1:addObject(act6)
				a1:addObject(act7)
				local sequence1 = CCSequence:create(a1)
				target.chaUI["SelectTalkEffect_c"].handle.s:stopAllActions()
				target.chaUI["SelectTalkEffect_c"].handle.s:runAction(CCRepeatForever:create(sequence))
				target.chaUI["SelectTalkEffect_c"].handle.s:runAction(CCRepeatForever:create(sequence1))
			end)
			target.chaUI["SelectTalkEffect_c"].handle.s:runAction(CCSequence:createWithTwoActions(CCFadeIn:create(0.3),shandong))
			
		end
	end

	Code_AddUpgradeEffect = function(target)
		local toff = weaponUpgradeOff[target.data.id] or {}
		if target.chaUI["WeaponUpgradeEffect_e"] == nil then
			print(target.data.id)
			print(toff.x,toff.y)
			target.chaUI["WeaponUpgradeEffect_e"] = hUI.image:new({
				parent = target.handle._tn,
				model = "effect/select_light.png",
				x = - 4 + (toff.x or 0),
				y = - 35 + (toff.y or 0),
				--animation = "blue",
				z = -255,
				--w = 128,
			})
			
		end
	end

	Code_AddSelectEffect = function(target)
		local toff = weaponSelectOff[target.data.id] or {}
		local scale = 1
		if _weaponScale[target.data.id] then
			scale = scale * 1.2 / _weaponScale[target.data.id]
		end
		if target.chaUI["SelectTalkEffect_c"] == nil then
			hApi.PlaySound("choice")
			target.chaUI["SelectTalkEffect_c"] = hUI.image:new({
				parent = target.handle._n,
				model = "effect/select_circle.png",
				--animation = "blue",
				x = (toff.x or 0),
				y = (toff.y or 0),
				z = -255,
				w = 128,
				scale = scale,
			})
		end
	end

	Code_AddSelectItemEffect = function(target)
		if target.chaUI["SelectTalkEffect_c"] == nil then
			
			hApi.PlaySound("choice")
			target.chaUI["SelectTalkEffect_c"] = hUI.image:new({
				parent = target.handle._n,
				model = "effect/select_circle2.png",
				--animation = "blue",
				x = 0,
				y = -14,
				z = -255,
				w = 128,
				scale = scale,
			})
		end
	end
	
	Code_RemoveSelectEffect = function()
		hApi.safeRemoveT(_tLastTalkTarget.chaUI, "SelectTalkEffect_c")
		hApi.safeRemoveT(_tLastTalkTarget.chaUI, "SelectTalkEeffect_e")
		--Code_ClearTurretUnit()
		hGlobal.event:event("clearUnlockWeaponTip")
		hGlobal.event:event("clearUnlockPetTip")
		hGlobal.event:event("clearPlayerBestInfoFrame")
		hGlobal.event:event("clearGotoPlayfrm")
		hGlobal.event:event("clearUpgradeTacticsFrm")
		hGlobal.event:event("clearUpgradePetsFrm")
		hGlobal.event:event("clearDailyRewardFrm")
		hGlobal.event:event("clearPurchaseGiftFrm")
		hGlobal.event:event("clearPlainTextFrm")
		hGlobal.event:event("clearUpgradeWeaponFrm")
		hGlobal.event:event("clearPhoneChestFrm") --关闭宝箱界面
		hGlobal.event:event("clearPhoneUserDefMapFrm_Vert") --关闭用户自定义地图界面
		--触发事件，关闭黑龙对话界面
		hGlobal.event:event("LocalEvent_Phone_HideBlackDragonTalkFrm")
		--hGlobal.event:event("LocalEvent_hideswitchtankbtn") --关闭切换战车按钮
		--hGlobal.event:event("LocalEvent_LeaveRandTestMap") --关闭随机迷宫按钮
	end
	
	Code_AddRotateEffect = function(target)
		local unitId = target.data.id
		hApi.addTimerForever("mainBaseAddRotateEvent_"..unitId, hVar.TIMER_MODE.PCTIME, 30, function()
			local facing = (target.data.facing - 11.25) % 360
			hApi.ChaSetFacing(target.handle, facing)
			target.data.facing = facing
			if _tLastTalkTarget ~= target and facing == 0  then
				hApi.clearTimer("mainBaseAddRotateEvent_"..unitId)
			end
		end)
	end
	
	--指定id的塔播放特效
	local counter = 0
	Code_TowerPlayEffect = function(target, typeId, deltatime, effectId, offsetX, offsetY)
		offsetX = offsetX or 0
		offsetY = offsetY or 0
		local w = hGlobal.WORLD.LastWorldMap
		
		if (target.data.id == typeId) then
			if (deltatime <= 0) then
				w:addeffect(effectId, 1, nil, target.data.worldX + offsetX, target.data.worldY + offsetY)
			else
				counter = counter + 1
				hApi.addTimerOnce("__TOWER_PLAY_EFFECT_" .. counter .. "__", deltatime, function()
					w:addeffect(effectId, 1, nil, target.data.worldX + offsetX, target.data.worldY + offsetY)
				end)
			end
		end
		
		local w = hGlobal.WORLD.LastWorldMap
		
	end
	
	Code_PlayGrowAcition = function(target)
		hApi.PlaySound("button")
		print("Code_PlayGrowAcition", target.data.id)
		local w = hGlobal.WORLD.LastWorldMap
		if w and target then
			local unitId = target.data.id
			local gu = nil
			local unitData = target.data
			if _tTurretUnitList[unitId] then
				gu = _tTurretUnitList[unitId]
				gu:sethide(0)
			else
				local buildId = _turretUnit[unitId].unitid
				local growUnitID = 0
				local tGrowUnitID = hVar.tab_unit[buildId].growUnitID
				--print(unitId,buildId,tGrowUnitID)
				if (type(tGrowUnitID) == "table") then
					growUnitID = tGrowUnitID.id or 0
					local growUnitDx = tGrowUnitID.dx or 0
					local growUnitDy = tGrowUnitID.dy or 0
					local growFacing = tGrowUnitID.facing or nil
					--print(unitData.worldX,growUnitDx,unitData.worldY,growUnitDy)
					--print(growUnitID)
					local owner = unitData.owner
					gu = w:addunit(growUnitID, owner, nil, nil, -45, unitData.worldX+growUnitDx,unitData.worldY+growUnitDy)
					gu.handle._n:setPosition(ccp(unitData.worldX+growUnitDx,-(unitData.worldY+growUnitDy))) --精准位置

					local allBuildCost = 0
					local baseTower = 0
					local oPlayer = target:getowner()
	
					gu.data.growParam = {buildId = buildId, oPlayer = oPlayer, allBuildCost = allBuildCost, baseTower = baseTower, owner = owner, worldX = unitData.worldX, worldY = unitData.worldY, triggerID = target.data.triggerID, growFacing = growFacing,} --生长动画参数
				
					_tTurretUnitList[unitId] = gu
				end
			end
			if gu then
				gu:playanimation("walk")
				--播放特效及音效
				--w:addeffect(96, 1, nil, unitData.worldX, unitData.worldY)
				target:sethide(1)
				
				--指定id的塔播放特效 (target, typeId, deltatime, effectId, offsetX, offsetY)
				Code_TowerPlayEffect(target, unitId, 500, 96, 0, 0)
				Code_TowerPlayEffect(target, unitId, 500, 3216, 20, 10)
				Code_TowerPlayEffect(target, unitId, 1500, 3216, -35, -30)
			end
		end
	end

	Code_ClearTurretUnit = function()
		if _tLastTalkTarget then
			if _tTalkUnitInfo then
				if _tTalkUnitInfo.talktype == 7 then
					local target = _tTalkUnitInfo.target
					if target then
						target:sethide(0)
					end
				end
			end
			local unitId = _tLastTalkTarget.data.id
			if _tTurretUnitList[unitId] then
				_tTurretUnitList[unitId]:del()
				_tTurretUnitList[unitId] = nil
			end
		end
	end

	Code_CheckEventPoint = function(oUnit)
		local eventList =  _eventPoint_Move[oUnit.data.id]
		if type(eventList) == "table" then
			local tid = oUnit.data.triggerID
			for i = 1,#eventList do
				if tid == eventList[i][1] then
					return true,eventList[i]
				end
			end
		end
		return false
	end
	
	Code_CheckTalkEvent = function()
		local oWorld = hGlobal.WORLD.LastWorldMap
		if oWorld and _shouldCheckEvent then
			local oPlayerMe = oWorld:GetPlayerMe() --我的玩家对象
			local nForceMe = oPlayerMe:getforce() --我的势力
			local oHero = oPlayerMe.heros[1]
			if oHero then
				local oUnit = oHero:getunit()
				if oUnit then
					local targetInfo = {}
					local ox, oy = hApi.chaGetPos(oUnit.handle) --战车坐标
					oWorld.enumunitAreaAlly(oWorld,nForceMe,ox, oy,180,function(u)
						if u ~= oUnit and u ~= oUnit.data.bind_weapon then
							--print("u.data.id",u.data.id)
							local talktype = 0 
							local event = nil
							local toX,toY = hApi.chaGetPos(u.handle)
							local dx = ox - toX
							local dy = oy - toY
							local dis = math.sqrt(dx * dx + dy * dy)
							if _tTalkWeaponList[u.data.id] == 1 and u.data.bind_weapon_owner == 0 then
								if dis < 140 then
									talktype = 2
								end
							elseif _eventUnit[u.data.id] then
								if dis < 120 then
									talktype = 4
									event = _eventUnit[u.data.id]
									--print("Code_CheckTalkEvent", u.data.id, event[1])
								end
							elseif hVar.UnitToTacticsItemList[u.data.id] then
								if dis < 160 then
									talktype = 5
								end
							elseif _petInfo[u.data.id] then
								if dis < 160 then
									talktype = 6
								end
							else
								if dis < 140 then
									local flag,pointevent = Code_CheckEventPoint(u)
									if flag then
										talktype = 3
										event = pointevent
									end
								end
							end
							if talktype ~= 0 then
								if targetInfo.target == nil or dis < targetInfo.dis then
									targetInfo = {
										target = u,
										dis = dis,
										talktype = talktype,
										event = event,
									}
								end
							end
						end
					end)
					
					--geyachao: 外网出版本专用
					oWorld.enumunitAreaAlly(oWorld,nForceMe,ox, oy,290,function(u)
						if u ~= oUnit and u ~= oUnit.data.bind_weapon then
							--print("u.data.id",u.data.id)
							local talktype = 0 
							local event = nil
							if _turretUnit[u.data.id] then
								talktype = 8
							else
								--talktype_last = 0
							end
							if talktype ~= 0 then
								local ux,uy = oUnit:getXY()
								local toX,toY = u:getXY()
								local dx = ux - toX
								local dy = uy - toY
								local dis = math.sqrt(dx * dx + dy * dy)
								if targetInfo.target == nil or dis < targetInfo.dis or (dis == targetInfo.dis and talktype == 1) then
									if talktype == 3 or dis <= 290 then
										targetInfo = {
											target = u,
											dis = dis,
											talktype = talktype,
											event = event,
										}
									end
								end
							end
						end
					end)
					
					--print("targetInfo.target=", targetInfo.target, "_tTalkUnitInfo=", _tTalkUnitInfo)
					if targetInfo.target then
						--保证先清理后创建
						if _tLastTalkTarget then
							if targetInfo.target ~= _tLastTalkTarget then
								hGlobal.event:event("LocalEvent_RecoverBarrage")
								Code_RemoveSelectEffect()
								_tTalkUnitInfo = nil
							end
						end
						local addeffect  = 1
						if targetInfo.talktype == 4 then
							if targetInfo.target.data.id == 11015 then
								addeffect = 2
							else
								addeffect = 0
							end
						elseif targetInfo.talktype == 3 then
							addeffect = 0
						elseif targetInfo.talktype == 5 then
							addeffect = 3
						elseif targetInfo.talktype == 6 then
							addeffect = 0
						elseif targetInfo.talktype == 7 then
							addeffect = 0
						elseif targetInfo.talktype == 8 then
							addeffect = 0
						end

						if addeffect == 1 then
							Code_AddSelectEffect(targetInfo.target)
						elseif addeffect == 2 then
							Code_AddScreenEffect(targetInfo.target)
						elseif addeffect == 3 then
							Code_AddSelectItemEffect(targetInfo.target)
						end
						if targetInfo.talktype == 2 and targetInfo.target ~= _tLastTalkTarget then
							Code_AddRotateEffect(targetInfo.target)
						end
						_tLastTalkTarget = targetInfo.target
						
						if (oUnit:getAIState() ~= hVar.UNIT_AI_STATE.IDLE) then
							--print("! IDLE", oUnit:getAIState())
							return
						end
						
						--闲置情况下再弹相关操作
						if _tTalkUnitInfo == nil then
							--print("闲置情况下再弹相关操作1")
							--print("targetInfo.talktype=", targetInfo.talktype)
							--清理
							hGlobal.event:event("LocalEvent_Comment_Clean")
							hGlobal.event:event("LocalEvent_HideBarrage")
							--2 武器   3 互动点  4 事件单位  5 升级战术卡 6 宠物
							if targetInfo.talktype == 2 then
								local nWeaponIdx = tempWeaponList[targetInfo.target.data.id]
								local _nWeaponLevel = LuaGetHeroWeaponLv(oUnit.data.id,nWeaponIdx)
								
								if _nWeaponLevel == 0 then
									hGlobal.event:event("LocalEvent_ShowUnlockWeaponTip",oUnit.data.id,nWeaponIdx)
								else
									hGlobal.event:event("LocalEvent_ShowUpgradeWeaponFrm",targetInfo.target.data.id)
								end
							elseif targetInfo.talktype == 4 then
								--print("???", targetInfo.event,targetInfo.event[1])
								if targetInfo.target.data.IsHide == 1 then
									targetInfo.event = {}
								end
								if (type(targetInfo.event) == "table") then
									hGlobal.event:event(targetInfo.event[1], targetInfo.event[2])
									print("闲置情况下再弹相关操作2")
								end
							elseif targetInfo.talktype == 5 then
								local unitid = targetInfo.target.data.id
								hGlobal.event:event("LocalEvent_ShowUpgradeTacticsFrm",unitid,hVar.UnitToTacticsItemList[unitid])
							elseif targetInfo.talktype == 3 then
								local toX, toY = targetInfo.target:getXY()
								oWorld.data.keypadEnabled = false
								hApi.addTimerOnce("mainBaseMoveEvent",100,function()
									hApi.UnitMoveToPoint_TD(oUnit, toX, toY, false)
									hApi.addTimerOnce("mainBasePointEventSound",500,function()
										hApi.PlaySound("open")
									end)
									hApi.addTimerOnce("mainBasePointEvent",800,function()
										hGlobal.event:event(targetInfo.event[2])
									end)
								end)
								_shouldCheckEvent = false
							elseif targetInfo.talktype == 6 then
								local unitid = targetInfo.target.data.id
								local petIdx = LuaGetHeroPetIndexById(hVar.MY_TANK_ID,unitid)
								local lv = LuaGetHeroPetLv(hVar.MY_TANK_ID, petIdx)
								if lv == 0 then
									--弹解锁界面
									hGlobal.event:event("LocalEvent_ShowUnlockPetTip",hVar.MY_TANK_ID,unitid)
								else
									--替换 和 升级
									Code_UpgradePet(unitid)
								end
							elseif targetInfo.talktype == 8 then
								if (talktype_last ~= 8) then
									--geyachao: 外网出版本专用
									talktype_last = 8
									hGlobal.event:event("LocalEvent_BuildTurretUnit_MainBase")
								end
							else
								
							end
							--print(targetInfo.target.data.id,targetInfo.dis,targetInfo.talktype)
							_tTalkUnitInfo = targetInfo
						end
					else
						if _tLastTalkTarget then
							Code_RemoveSelectEffect()
							hGlobal.event:event("LocalEvent_Comment_Clean")
							hGlobal.event:event("LocalEvent_RecoverBarrage")
						end
						_tLastTalkTarget = nil
						_tTalkUnitInfo = nil
					end
				end
			end
		end
	end

	--进入区域事件
	Code_EnterAreaEvent = function(sAreaName)
		print("enter"..tostring(sAreaName))
		CommentManage.EnterArea(sAreaName)
	end
	
	--离开区域事件
	Code_LeaveAreaEvent = function(sAreaName)
		print("leave"..tostring(sAreaName))
		CommentManage.LeaveArea(sAreaName)
	end

	Code_CheckAreaEvent = function()
		local oWorld = hGlobal.WORLD.LastWorldMap
		if oWorld then
			local oPlayerMe = oWorld:GetPlayerMe() --我的玩家对象
			local nForceMe = oPlayerMe:getforce() --我的势力
			local oHero = oPlayerMe.heros[1]
			if oHero then
				local oUnit = oHero:getunit()
				if oUnit then
					local targetInfo = {}
					local ox, oy = hApi.chaGetPos(oUnit.handle) --战车坐标
					local enterAreaName = nil
					local mindis = 0
					for areaname,tPoint in pairs(_areaEventPoint) do
						for i = 1,#tPoint do
							local info = tPoint[i]
							if info.mode == 1 then
								local rect = {info.x - info.w /2,-info.y + info.h /2,info.w,info.h}
								if hApi.IsInBox(ox, oy,rect) then	--在长方形那
									local dis = math.sqrt((ox - info.x)^2 + (oy - (-info.y))^2)
									if enterAreaName == nil then
										enterAreaName = areaname
										mindis = dis
									else
										if dis < mindis then
											enterAreaName = areaname
											mindis = dis
										end
									end
								end
							elseif info.mode == 2 then
								local dis = math.sqrt((ox - info.x)^2 + (oy - (-info.y))^2)
								if dis <= info.radius then		--在圈内
									if enterAreaName == nil then
										enterAreaName = areaname
										mindis = dis
									else
										if dis < mindis then
											enterAreaName = areaname
											mindis = dis
										end
									end
								end
							end
						end
					end
					if enterAreaName then
						if _tAreaStateInfo then
							if _tAreaStateInfo.areaName ~= enterAreaName then
								--先调离开事件
								Code_LeaveAreaEvent(_tAreaStateInfo.areaName)
							else
								return
							end
						end
						_tAreaStateInfo = {
							areaName = enterAreaName,
						}
						--进入事件
						Code_EnterAreaEvent(enterAreaName)
					else
						if _tAreaStateInfo then
							--离开事件
							Code_LeaveAreaEvent(_tAreaStateInfo.areaName)
						end
						_tAreaStateInfo = nil
					end
				end
			end
		end
	end

	local createGetScoreFloat = function(nScore)
		local text = "+ "..nScore.." "
		local num = #text
		local offx = 90+40*num/2
		hUI.floatNumber:new({
			x = hVar.SCREEN.w / 2 + offx/2 -25,
			y = hVar.SCREEN.h / 2,
			align = "MC",
			text = "",
			lifetime = 1000,
			fadeout = -550,
			moveY = 32,
		}):addtext(text, hVar.FONTC, 40, "RC", 0, 0,nil,offx)

		hUI.floatNumber:new({
			font = "numGreen",
			text = "",
			size = 16,
			x = hVar.SCREEN.w / 2 - 40*num/4 + 12,
			y = hVar.SCREEN.h / 2 - 4,
			align = "LC",
			icon = "misc/skillup/mu_coin.png",
			iconWH = 36,
			lifetime = 1000,
			fadeout = -550,
			moveY = 32,
		})
	end
	
	--增加氪石
	local createGetKeShiFloat = function(nKeShi)
		local text = "+ "..nKeShi.." "
		local num = #text
		local offx = 90+40*num/2
		hUI.floatNumber:new({
			x = hVar.SCREEN.w / 2 + offx/2 -25,
			y = hVar.SCREEN.h / 2,
			align = "MC",
			text = "",
			lifetime = 1000,
			fadeout = -550,
			moveY = 32,
		}):addtext(text, hVar.FONTC, 40, "RC", 0, 0,nil,offx)
		
		hUI.floatNumber:new({
			font = "num",
			text = "",
			size = 16,
			x = hVar.SCREEN.w / 2 - 40*num/4 + 12,
			y = hVar.SCREEN.h / 2 - 4,
			align = "LC",
			icon = "misc/skillup/keshi.png",
			iconWH = 36,
			lifetime = 1000,
			fadeout = -550,
			moveY = 32,
		})
	end
	
	--增加体力
	local createGetTiLiFloat = function(nTiLi)
		local text = "+ "..nTiLi.." "
		local num = #text
		local offx = 90+40*num/2
		hUI.floatNumber:new({
			x = hVar.SCREEN.w / 2 + offx/2 -25,
			y = hVar.SCREEN.h / 2,
			align = "MC",
			text = "",
			lifetime = 1000,
			fadeout = -550,
			moveY = 32,
		}):addtext(text, hVar.FONTC, 40, "RC", 0, 0,nil,offx)
		
		hUI.floatNumber:new({
			font = "num",
			text = "",
			size = 16,
			x = hVar.SCREEN.w / 2 - 40*num/4 + 12,
			y = hVar.SCREEN.h / 2 - 4,
			align = "LC",
			icon = "misc/task/tili.png",
			iconWH = 48,
			lifetime = 1000,
			fadeout = -550,
			moveY = 32,
		})
	end
	
	Code_RefreshPetBase = function()
		if _tLastTalkTarget then
			local oWorld = hGlobal.WORLD.LastWorldMap
			local unit = _tLastTalkTarget
			if unit and oWorld then
				if unit.data._TempbaseUnit then
					unit.data._TempbaseUnit:del()
					unit.data._TempbaseUnit = nil
				end
				createPetUnit_base(oWorld,unit,1)
			end
		end
	end

	Code_CreateAreaMask = function()
		local oWorld = hGlobal.WORLD.LastWorldMap
		if oWorld then
			local h = oWorld.handle
			local worldLayer = h.worldLayer
			if worldLayer then
				local maskpng = "data/image/misc/mask.png"
				local circlemaskpng = "data/image/misc/circlemask.png"
				for areaname,tPoint in pairs(_areaEventPoint) do
					_tAreaMaskSprite[areaname] = {}
					local _list = _tAreaMaskSprite[areaname]
					for i = 1,#tPoint do
						local info = tPoint[i]
						if type(info) == "table" then
							local pNodeC = CCNode:create()
							pNodeC:setPosition(info.x or 0, info.y or 0)
							worldLayer:addChild(pNodeC,1000000)
							
							if info.mode == 1 then
								_list[#_list+1] = pNodeC
								local image = hUI.image:new({
									parent = pNodeC,
									model = "misc/mask.png",
									w = info.w or 100, 
									h = info.h or 100,
								})
								local lab = hUI.label:new({
									parent = pNodeC,
									font = hVar.FONTC,
									size = 20,
									text = tostring(areaname),
									align = "MC",
								})
							elseif info.mode == 2 then
								_list[#_list+1] = pNodeC
								--local scale = info.radius * 2 /32
								local image = hUI.image:new({
									parent = pNodeC,
									model = "misc/circlemask.png",
									w = info.radius * 2 or 100, 
									h = info.radius * 2 or 100,
									--scale = scale,
								})
								local lab = hUI.label:new({
									parent = pNodeC,
									font = hVar.FONTC,
									size = 20,
									text = tostring(areaname),
									align = "MC",
								})
							end
						end
					end
				end
			end
		end
	end

	Code_ClearAreaMask = function()
		table_print(_tAreaMaskSprite)
		for areaname,tList in pairs(_tAreaMaskSprite) do
			for i = 1,#tList do
				local sprite = tList[i] 
				if sprite~=nil then
					sprite:getParent():removeChild(sprite,true)
				end
			end
		end
		_tAreaMaskSprite = {}
	end

	hGlobal.event:listen("LocalEvent_MainBaseResetUnitInfo","_MainBase",function()
		_tTalkUnitInfo = nil
		Code_CheckTalkEvent()
	end)

	hGlobal.event:listen("LocalEvent_SetDanmuBtnState","_MainBase",function(nstate,changemodel)
		if _frm and _frm.data.show == 1 and _childUI["danmu"] then
			if nstate then
				_childUI["danmu"]:setstate(nstate)
			end
			if changemodel then
				if g_closedanmu == 1 then
					if _childUI["danmu"].childUI["img"] then
						_childUI["danmu"].childUI["img"]:setmodel("misc/barrage_off.png")
					end
				else
					if _childUI["danmu"].childUI["img"] then
						_childUI["danmu"].childUI["img"]:setmodel("misc/barrage_on.png")
					end
				end
			end
		end
	end)

	hGlobal.event:listen("LocalEvent_ShowAreaMask","_MainBase",function()
		if g_lua_src == 1 then
			if _IsDrawArea == 0 then
				_IsDrawArea = 1
				Code_CreateAreaMask()
			else
				_IsDrawArea = 0
				Code_ClearAreaMask()
			end
		end
	end)

	hGlobal.event:listen("LocalEvent_ReloadAreaMaskInfo","_MainBase",function(tab)
		_areaEventPoint = hApi.ReadParamWithDepth(tab,nil,{},3)
		--table_print(_areaEventPoint)
	end)
	
	--跟随宠物
	hGlobal.event:listen("LocalEvent_ReplacePet","_MainBase",function()
		if _tTalkUnitInfo then
			if _tTalkUnitInfo.talktype == 6 then
				Code_ReplacePet()
			else
				Code_ReplaceModel()
			end
		end
	end)
	
	--取消跟随宠物
	hGlobal.event:listen("LocalEvent_CancelFollowPet","_MainBase",function()
		--取消跟随宠物
		if _tTalkUnitInfo then
			if _tTalkUnitInfo.talktype == 6 then
				Code_CancelFollowPet()
			end
		end
	end)
	
	--主基地派遣宠物挖矿
	hGlobal.event:listen("LocalEvent_MainBase_SendPetWaKuang","_MainBase",function()
		--print("主基地派遣宠物挖矿")
		--主基地派遣宠物挖矿
		--print("_tTalkUnitInfo=", _tTalkUnitInfo)
		if _tTalkUnitInfo then
			if _tTalkUnitInfo.talktype == 6 then
				--print("_tTalkUnitInfo.talktype=", _tTalkUnitInfo.talktype)
				Code_SendPetWaKuang()
			end
		end
	end)
	
	--主基地派遣宠物挖体力
	hGlobal.event:listen("LocalEvent_MainBase_SendPetWaTiLi","_MainBase",function()
		--主基地派遣宠物挖体力
		if _tTalkUnitInfo then
			if _tTalkUnitInfo.talktype == 6 then
				Code_SendPetWaTiLi()
			end
		end
	end)
	
	--主基地取消宠物挖矿
	hGlobal.event:listen("LocalEvent_MainBase_CancelPetWaKuang","_MainBase",function()
		--主基地取消宠物挖矿
		if _tTalkUnitInfo then
			if _tTalkUnitInfo.talktype == 6 then
				Code_CancelPetWaKuang()
			end
		end
	end)
	
	--主基地取消宠物挖体力
	hGlobal.event:listen("LocalEvent_MainBase_CancelPetWaTiLi","_MainBase",function()
		--主基地取消宠物挖体力
		if _tTalkUnitInfo then
			if _tTalkUnitInfo.talktype == 6 then
				Code_CancelPetWaTiLi()
			end
		end
	end)
	
	--主基地收到领取成就奖励的结果回调
	hGlobal.event:listen("localEvent_OnTakeRewardAchievement","_MainBase",function()
		Code_RefreshScientstAchievement() --主基地更新科学家成就皮肤
		Code_RefreshTankDeadthAchievement() --主基地更新战车死亡成就皮肤
		
		--主基地更新任务叹号
		Code_UpdateTanHao()
	end)
	
	hGlobal.event:listen("LocalEvent_BuildTurretUnit_MainBase","_MainBase",function()
		print("LocalEvent_BuildTurretUnit_MainBase")
		if _oTurretUnit then
			print("aaaa")
			Code_PlayGrowAcition(_oTurretUnit)
		end
	end)
	
	hGlobal.event:listen("LocalEvent_ShowWeaponInfoFrm_MainBase","",function()
		Code_ShowWeaponInfo()
	end)
	
	hGlobal.event:listen("LocalEvent_ChangeModel_MainBase","_MainBase",function(ignore)
		local oWorld = hGlobal.WORLD.LastWorldMap
		local oPlayerMe = oWorld:GetPlayerMe() --我的玩家对象
		local nForceMe = oPlayerMe:getforce() --我的势力
		local oHero = oPlayerMe.heros[1]
		if oHero then
			local oUnit = oHero:getunit()
			if oUnit and _tTalkUnitInfo then
				print(_tTalkUnitInfo.target.data.id,oUnit.data.bind_weapon.data.id)
				if _tTalkUnitInfo.target.data.id == oUnit.data.bind_weapon.data.id then
					if ignore then
						Code_ReplaceModel()
					else
						return
					end
				else
					Code_ReplaceModel()
				end
			end
		end
		
	end)

	hGlobal.event:listen("LocalEvent_HideTurretUnit_MainBase","_MainBase",function()
		print("LocalEvent_HideTurretUnit_MainBase")
		if _oTurretUnit then
			print("bbbbb")
			--Code_PlayGrowAcition(_oTurretUnit)
			local unitId = _oTurretUnit.data.id
			if _tTurretUnitList[unitId] then
				_tTurretUnitList[unitId]:sethide(1)
			end
			_oTurretUnit:sethide(0)
		end
	end)

	hGlobal.event:listen("LocalEvent_HideCommentBtn","hideunit",function(nScore)
		createGetScoreFloat(nScore)
		--弹框
		hGlobal.event:event("LocalEvent_RefreshScoreAction",1)
		--_childUI["comment"]:setstate(-1)
	end)

	hGlobal.event:listen("LocalEvent_HideDailyRewardUnit","hideunit",function(nScore)
		if _oDailyRewardUnit then
			createGetScoreFloat(nScore)
			--弹框
			hGlobal.event:event("LocalEvent_RefreshScoreAction",1)
			_oDailyRewardUnit:sethide(1)
			hGlobal.event:event("clearDailyRewardFrm")
			--_oDailyRewardUnit = nil
		end
	end)

	hGlobal.event:listen("LocalEvent_HideTacticsHelpUnit","hideunit",function(nIsHide)
		if _oTacticsHelpUnit then
			_oTacticsHelpUnit:sethide(nIsHide)
		end
	end)
	
	hGlobal.event:listen("LocalEvent_RefreshDailyRewardUnit","refreshDailyRewardUnit",function()
		--print("LocalEvent_RefreshDailyRewardUnit")
		Code_CheckDailyReward()
		Code_CheckAdminDebug()
	end)
	
	--收到战车昨日排名
	hGlobal.event:listen("LocalEvent_OnReceiveTankYesterdayRank", "refreshDailyRewardUnit", function(uid, rid ,rank)
		Code_ReceiveTankYesterdayRank(uid, rid ,rank)
	end)

	hGlobal.event:listen("LocalEvent_ShowUnlockPetAreaFrm","showfrm",function()
		local tIconData = {
			--icon = "misc/addition/boss_tip.png",
			y = 30,
			thumbImageId = 12010,
			--scale = 1.5,
		}
		local tTextData = {
			y = -90,
			align = "MC",
			size = 26,
			width = 480 - 50 * 2,
			height = 140,
			font = hVar.FONTC,
			text = hVar.tab_string["unlock_area"],
		}
		hGlobal.event:event("LocalEvent_ShowPlainTextFrm",tIconData,tTextData)
	end)

	hGlobal.event:listen("LocalEvent_ShowUnlockTacticsAreaFrm","showfrm",function()
		local tIconData = {
			--icon = "misc/addition/boss_tip.png",
			y = 32,
			thumbImageId = 12042,
			facing = 235,
			scale = 1.1,
		}
		local tTextData = {
			y = -90,
			align = "MC",
			size = 26,
			width = 480 - 50 * 2,
			height = 140,
			font = hVar.FONTC,
			text = hVar.tab_string["unlock_area"],
		}
		hGlobal.event:event("LocalEvent_ShowPlainTextFrm",tIconData,tTextData)
	end)

	hGlobal.event:listen("LocalEvent_ShowUnlockentertainmentareaFrm","showfrm",function()
		local tIconData = {
			--icon = "misc/addition/boss_tip.png",
			y = 20,
			thumbImageId = 12513,
			facing = 235,
			scale = 0.64,
		}
		local tTextData = {
			y = -90,
			align = "MC",
			size = 26,
			width = 480 - 50 * 2,
			height = 140,
			font = hVar.FONTC,
			text = hVar.tab_string["unlock_area"],
		}
		hGlobal.event:event("LocalEvent_ShowPlainTextFrm",tIconData,tTextData)
	end)
	

	hGlobal.event:listen("LocalEvent_ShowUnlockAreaFrm2","showfrm",function()
		local iChannelId = xlGetChannelId()
		if iChannelId < 100 then
			local tIconData = {
				--icon = "ICON:skill_icon1_x3y5",
				thumbImageId = 11031,
				y = 40,
				scale = 1.3,
			}
			local tTextData = {
				y = -70,
				align = "MC",
				size = 26,
				width = 480 - 20 * 2,
				height = 140,
				font = hVar.FONTC,
				text = hVar.tab_string["unlock_area2"],
			}
			hGlobal.event:event("LocalEvent_ShowPlainTextFrm",tIconData,tTextData)
		else
			local tIconData = {
				icon = "misc/button_null.png",
			}
			local tTextData = {
				y = 0,
				align = "MC",
				size = 26,
				width = 480 - 20 * 2,
				height = 140,
				font = hVar.FONTC,
				text = hVar.tab_string["not_ready"],
			}
			hGlobal.event:event("LocalEvent_ShowPlainTextFrm",tIconData,tTextData)

		end
	end)

	hGlobal.event:listen("LocalEvent_ShowTacticsHelpFrm","showfrm",function()
		--[[
		--_tTalkUnitInfo.target
		if _tTalkUnitInfo and _tTalkUnitInfo.target then
			print("LocalEvent_ShowTacticsHelpFrm",_tTalkUnitInfo.target.data.id)
		end
		local tIconData = {
			icon = "effect/buff_n0.png",
			y = 76,
		}
		local tTextData = {
			y = 16,
			align = "MT",
			size = 28,
			width = 480 - 50 * 2,
			height = 140,
			font = hVar.FONTC,
			text = hVar.tab_string["game_tips1"],
		}
		hGlobal.event:event("LocalEvent_ShowPlainTextFrm",tIconData,tTextData)
		--]]
	end)
	
	hGlobal.event:listen("LocalEvent_TD_NextWave","_ChangeWorldFunc",function()
		local oWorld = hGlobal.WORLD.LastWorldMap
		if oWorld and oWorld.data.map == hVar.MainBase then
			Code_InitData()
			Code_CheckTacticsCard()
			Code_ChangeWorldFunc()
			
			--查询战车昨日排名
			SendCmdFunc["query_yesterday_rank"]()
			
			--查询礼包状态
			SendCmdFunc["gift_state"]("9;100;18;3;1030;1031;1033;1034;1035;1036")
		end
		--Code_CheckDailyReward()
	end)

	hGlobal.event:listen("LocalEvent_MainBase_Showskillfrm","show",function()
		local oWorld = hGlobal.WORLD.LastWorldMap
		if oWorld then
			local oPlayerMe = oWorld:GetPlayerMe() --我的玩家对象
			local nForceMe = oPlayerMe:getforce() --我的势力
			local oHero = oPlayerMe.heros[1]
			local oUnit = oHero:getunit()
			print(oUnit.data.id)
			hGlobal.event:event("LocalEvent_Phone_ShowDiabloSkillUpInfoFrm",oUnit.data.id)
		end
	end)

	hGlobal.event:listen("LocalEvent_EnterMapDoor","enterDoor",function()
		local isBeginer = GameManager.CheckIsBeginner()
		if isBeginer == 1 then
			GameManager.GameStart(hVar.GameType.BEGINNER)
		else
			local keyList = {"skill","card","map", "material", "log",}
			LuaSavePlayerData_Android_Upload(keyList, "进随机地图")
			--hGlobal.event:event("LocalEvent_EnterRandMap")
			local tCallback = {"LocalEvent_MainBaseEventCB"}
			--hGlobal.event:event("localEvent_ShowSelectBattleMapFrm",tCallback)
			hGlobal.event:event("localEvent_ShowSelectBattleMapFrm_temp",tCallback) --临时选关卡界面
		end
	end)
	
	--[[
	--随机迷宫
	hGlobal.event:listen("LocalEvent_EnterRandTestMap","enterDoor",function()
		_childUI["btn_enter_randommap"]:setstate(1)
		--GameManager.GameStart(hVar.GameType.FOURSR)
	end)
	
	--隐藏随机迷宫
	hGlobal.event:listen("LocalEvent_LeaveRandTestMap","leaveDoor",function()
		_childUI["btn_enter_randommap"]:setstate(-1)
	end)
	]]
	
	--[[
	--添加事件监听：收到请求挑战娱乐地图结果返回
	hGlobal.event:listen("LocalEvent_RequireEntertamentNormalRet", "randommapdoor", function(result, pvpcoin, mapName, mapDiff, battlecfg_id)
		--操作成功
		if (result == 1) then
			if (mapName == hVar.RandomMap) then --是随机迷宫地图
				--进入随机迷宫
				GameManager.GameStart(hVar.GameType.FOURSR, nil, battlecfg_id)
			end
		end
	end)
	]]
	
	hGlobal.event:listen("LocalEvent_EnterEndlessMap","entermap",function()
		--local unlock = 1
		--local tabChpt = hVar.tab_chapter[1]
		--if tabChpt then
			--local startMap = tabChpt.firstmap
			--local lastMap = tabChpt.lastmap
			--if hVar.MAP_INFO[startMap] then
				--local mapname = startMap
				--while(hVar.MAP_INFO[mapname] and unlock == 1) do
					--unlock = LuaGetPlayerMapAchi(mapname,hVar.ACHIEVEMENT_TYPE.LEVEL) or 0
					--print("mapname",mapname,unlock)
					--if hVar.MAP_INFO[mapname].nextmap and hVar.MAP_INFO[mapname].nextmap[1] and mapname ~= lastMap then
						--mapname = hVar.MAP_INFO[mapname].nextmap[1]
					--else
						--mapname = nil
					--end
				--end
			--end
		--end
		local unlock = 0
		local tabRandM = hVar.tab_randmap[1]
		local stage = 2
		if tabRandM and tabRandM[stage] and type(tabRandM[stage].randmap) == "table" then
			for i = 1,#tabRandM[stage].randmap do
				local sMapName = tabRandM[stage].randmap[i]
				if LuaGetPlayerMapAchi(sMapName,hVar.ACHIEVEMENT_TYPE.LEVEL) == 1 then
					unlock = 1
					break
				end
			end
		end
		if unlock == 0 then
			hGlobal.event:event("LocalEvent_MainBaseEventCB")
			hUI.floatNumber:new({
				x = hVar.SCREEN.w / 2,
				y = hVar.SCREEN.h / 2,
				align = "MC",
				text = "",
				lifetime = 1000,
				fadeout = -550,
				moveY = 32,
			}):addtext("CLEARING MAP6 CAN ENTER", hVar.FONTC, 32, "MC", 0, 0,nil,1)
		else
			--大菠萝数据初始化
			hGlobal.LocalPlayer.data.diablodata = LuaInitDiabloData()
			
			local mapname = "world/endless_001"
			local MapDifficulty = 0
			local MapMode = hVar.MAP_TD_TYPE.ENDLESS --无尽模式
			
			xlScene_LoadMap(g_world, mapname,MapDifficulty,MapMode)
		end
	end)

	hGlobal.event:listen("LocalEvent_RefreshChestNum","__Do_event",function()
		print("LocalEvent_RefreshChestNum")
		Code_RefreshWeaponCapsuleNum()
		Code_RefreshTacticsCapsuleNum()
		Code_RefreshPetCapsuleNum()
	end)
	
	hGlobal.event:listen("LocalEvent_RefreshScoreAction","__Do_event",function(showanimation)
		if true then
			return
		end
		if _frm and _frm.data.show == 1 then
			if showanimation == 0 then
				local newScore = LuaGetPlayerScore()
				_frm.childUI["GoldNum"]:setText(newScore)
			else
				local delay = CCDelayTime:create(0.3)
				local callback1 = CCCallFunc:create(function()
					local newScore = LuaGetPlayerScore()
					_frm.childUI["GoldNum"]:setText(newScore)
				end)
				local scaleBig = CCScaleTo:create(0.1, 1.5)
				local scaleSmall = CCScaleTo:create(0.1, 22/26)
				local a = CCArray:create()
				a:addObject(delay)
				a:addObject(callback1)
				a:addObject(scaleBig)
				a:addObject(scaleSmall)
				local sequence = CCSequence:create(a)
				_frm.childUI["GoldNum"].handle._n:runAction(sequence)
			end
		end
	end)
	
	hGlobal.event:listen("LocalEvent_SetCurGameCoin","__mainbase",function(coin)
		--print("LocalEvent_SetCurGameCoin", coin)
		
		--存储本地缓存值
		m_kesiNum = coin
		--m_tiliNum = pvpcoin
		
		if _childUI and _childUI["CoinNum"] then
			_childUI["CoinNum"]:setText(tonumber(coin))
		end
	end)
	
	--监听金币改变（手机版）事件
	hGlobal.event:listen("LocalEvent_Phone_SetCurGameCoin_Game","__mainbase",function(coin)
		--print("LocalEvent_Phone_SetCurGameCoin_Game", coin)
		
		--存储本地缓存值
		m_kesiNum = coin
		--m_tiliNum = pvpcoin
		
		if _childUI and _childUI["CoinNum"] then
			_childUI["CoinNum"]:setText(coin)
		end
	end)
	
	--监听获得游戏资源事件
	hGlobal.event:listen("LocalEvent_GetGameResource", "__mainbase",function(gamecoin, pvpcoin, crystal, evaluateE, redscroll, weaponChestNum, tacticChestNum, petChestNum, equipChestNum, scientistNum, tankDeadthCount, dishuCoin)
		--print("监听获得游戏资源事件", gamecoin, pvpcoin, crystal, evaluateE, redscroll, weaponChestNum, tacticChestNum, petChestNum, equipChestNum, scientistNum, tankDeadthCount, dishuCoin)
		
		--存储本地缓存值
		m_kesiNum = gamecoin
		m_tiliNum = pvpcoin
		
		g_GameCurrencyResource.keshi = gamecoin
		g_GameCurrencyResource.chip = crystal
		
		--氪石
		if _childUI and _childUI["CoinNum"] then
			_childUI["CoinNum"]:setText(gamecoin)
		end
		
		--体力
		if _childUI and _childUI["TiliNum"] then
			_childUI["TiliNum"]:setText(pvpcoin)
		end
		
		--营救科学家数量
		if _oEngineerUnit then
			if (_oEngineerUnit.chaUI ~= nil) then
				if (_oEngineerUnit.chaUI["num"] ~= nil) then
					_oEngineerUnit.chaUI["num"]:setText(scientistNum)
				end
			end
		end
		
		--战车死亡数量
		--print("监听获得游戏资源事件 tankDeadthCount=", tankDeadthCount)
		if _oTankDeadthUnit then
			if (_oTankDeadthUnit.chaUI ~= nil) then
				if (_oTankDeadthUnit.chaUI["num"] ~= nil) then
					_oTankDeadthUnit.chaUI["num"]:setText(tankDeadthCount)
				end
			end
		end

		if _oGopherUnit then
			Code_CreateDishuCoin()
		end
	end)
	
	--监听获得体力收益信息返回事件
	hGlobal.event:listen("LocalEvent_TiLiInfo_Ret", "__TiLiInfo_mainbase_", function(tiliDailyMax, tiliNow, tiliDailyBuyCount, tiliBuyCount, tiliDailySupply, dailyKeShiExport, dailyTiLiExport, dailyChestExport, keshiExportNow, tiliExportNow, chestExportNow)
		--存储本地缓存值
		m_tiliNum = tiliNow
		m_keshiExportNow = keshiExportNow
		m_tiliExportNow = tiliExportNow
		m_chestExportNow = chestExportNow
		
		--体力
		if _childUI and _childUI["TiliNum"] then
			_childUI["TiliNum"]:setText(tiliNow)
		end
		
		--地上生成一堆氪石和一堆体力
		--氪石 2541,1665
		--体力 2431,1771
		
		--先删除旧的
		local oWorld = hGlobal.WORLD.LastWorldMap
		if oWorld then
			--删除氪石
			oWorld:enumunitAreaAlly(0, _nKeShiPosX, _nKeShiPosY, 300, function(eu)
				--print("eu.data.id=", eu.data.id)
				if (eu.data.id == _tKeShiUints[1].id) or (eu.data.id == _tKeShiUints[2].id) or (eu.data.id == _tKeShiUints[3].id) then
					eu:del()
				end
			end)
			
			--删除体力
			oWorld:enumunitAreaAlly(0, _nTiLiPosX, _nTiLiPosY, 300, function(eu)
				--print("eu.data.id=", eu.data.id)
				if (eu.data.id == _tTiLiUints[1].id) or (eu.data.id == _tTiLiUints[2].id) or (eu.data.id == _tTiLiUints[3].id) then
					eu:del()
				end
			end)
			
			--删除宝箱
			oWorld:enumunitAreaAlly(0, _nChestPosX, _nChestPosY, 300, function(eu)
				--print("eu.data.id=", eu.data.id)
				if (eu.data.id == _tChestUints[1].id) or (eu.data.id == _tChestUints[2].id) or (eu.data.id == _tChestUints[3].id) then
					eu:del()
				end
			end)
			
			--添加氪石
			print("keshiExportNow=", keshiExportNow)
			local keshiNum = keshiExportNow
			local keshiPivot = 1
			while (keshiNum > 0) do
				local unitId = _tKeShiUints[keshiPivot].id
				local num = _tKeShiUints[keshiPivot].num
				
				--剩余数量不足以放下了
				while (keshiNum < num) do
					keshiPivot = keshiPivot + 1
					unitId = _tKeShiUints[keshiPivot].id
					num = _tKeShiUints[keshiPivot].num
				end
				
				local randX = _nKeShiPosX + math.random(-30, 30)
				local randY = _nKeShiPosY + math.random(-30, 30)
				--print(i, unitId, randX, randY)
				local oTarget = oWorld:addunit(unitId, 21, nil ,nil, 0, randX, randY, nil, nil, 1, 1)
				local bForceSetPos = true
				oTarget:setPos(randX, randY, 0, bForceSetPos)
				
				--减少
				keshiNum = keshiNum - num
			end
			
			--添加体力
			print("tiliExportNow=", tiliExportNow)
			local tiliNum = tiliExportNow
			local tiliPivot = 1
			while (tiliNum > 0) do
				local unitId = _tTiLiUints[tiliPivot].id
				local num = _tTiLiUints[tiliPivot].num
				
				--剩余数量不足以放下了
				while (tiliNum < num) do
					tiliPivot = tiliPivot + 1
					unitId = _tTiLiUints[tiliPivot].id
					num = _tTiLiUints[tiliPivot].num
				end
				
				local randX = _nTiLiPosX + math.random(-30, 30)
				local randY = _nTiLiPosY + math.random(-30, 30)
				--print(i, unitId, randX, randY)
				local oTarget = oWorld:addunit(unitId, 21, nil ,nil, 0, randX, randY, nil, nil, 1, 1)
				local bForceSetPos = true
				oTarget:setPos(randX, randY, 0, bForceSetPos)
				
				--减少
				tiliNum = tiliNum - num
			end
			
			--添加宝箱
			print("chestExportNow=", chestExportNow)
			local chestNum = chestExportNow
			local chestPivot = 1
			while (chestNum > 0) do
				local unitId = _tChestUints[chestPivot].id
				local num = _tChestUints[chestPivot].num
				
				--剩余数量不足以放下了
				while (chestNum < num) do
					chestPivot = chestPivot + 1
					unitId = _tChestUints[chestPivot].id
					num = _tChestUints[chestPivot].num
				end
				
				local randX = _nChestPosX + math.random(-30, 30)
				local randY = _nChestPosY + math.random(-30, 30)
				--print(i, unitId, randX, randY)
				local oTarget = oWorld:addunit(unitId, 21, nil ,nil, 0, randX, randY, nil, nil, 1, 1)
				local bForceSetPos = true
				oTarget:setPos(randX, randY, 0, bForceSetPos)
				
				--减少
				chestNum = chestNum - num
			end
		end
	end)
	
	--监听走到氪石领取点事件
	local _lastKeShiTakeTime = 0
	hGlobal.event:listen("LocalEvent_Phone_TakeRewardKeShi", "__TiLiInfo_mainbase_", function()
		local currenttime = os.time()
		local deltatime = currenttime - _lastKeShiTakeTime
		if (deltatime >= 3) then --3秒
			_lastKeShiTakeTime = currenttime
			
			--有氪石
			if (m_keshiExportNow > 0) then
				print("氪石领取点")
				
				--请求领取挖矿氪石奖励
				SendCmdFunc["tank_addones_keshi"]()
			end
		end
	end)
	
	--监听走到体力领取点事件
	local _lastTiLiTakeTime = 0
	hGlobal.event:listen("LocalEvent_Phone_TakeRewardTiLi", "__TiLiInfo_mainbase_", function()
		local currenttime = os.time()
		local deltatime = currenttime - _lastTiLiTakeTime
		if (deltatime >= 3) then --3秒
			_lastTiLiTakeTime = currenttime
			
			--有体力
			if (m_tiliExportNow > 0) then
				print("体力领取点")
				
				--请求领取挖矿体力奖励
				SendCmdFunc["tank_addones_tili"]()
			end
		end
	end)
	
	--监听走到宝箱领取点事件
	local _lastChestTakeTime = 0
	hGlobal.event:listen("LocalEvent_Phone_TakeRewardChest", "__ChestInfo_mainbase_", function()
		local currenttime = os.time()
		local deltatime = currenttime - _lastChestTakeTime
		if (deltatime >= 3) then --3秒
			_lastChestTakeTime = currenttime
			
			--有宝箱
			if (m_chestExportNow > 0) then
				print("宝箱领取点")
				
				--请求领取挖矿宝箱奖励
				SendCmdFunc["tank_addones_chest"]()
			end
		end
	end)
	
	--监听领取挖矿氪石的事件返回
	hGlobal.event:listen("LocalEvent_TakeRewardWaKuang_Ret", "__TakeRewardWaKuang_mainbase_", function(result, addKeShiNum)
		--操作成功
		if (result == 1) then
			--冒字获得氪石
			createGetKeShiFloat(addKeShiNum)
			
			--音效
			hApi.PlaySound("getcard")
			
			--再次获取玩家体力产量信息
			SendCmdFunc["tank_reqiure_tili_info"]()
		end
	end)
	
	--监听领取挖矿体力的事件返回
	hGlobal.event:listen("LocalEvent_TakeRewardWaTiLi_Ret", "__TakeRewardWaTiLi_mainbase_", function(result, addTiLiNum)
		--操作成功
		if (result == 1) then
			--冒字获得体力
			createGetTiLiFloat(addTiLiNum)
			
			--音效
			hApi.PlaySound("recover_hp")
			
			--再次获取玩家体力产量信息
			SendCmdFunc["tank_reqiure_tili_info"]()
		end
	end)
	
	--监听领取挖矿宝箱的事件返回
	hGlobal.event:listen("LocalEvent_TakeRewardWaChest_Ret", "__TakeRewardWaChest_mainbase_", function(result, addChestNum)
		--操作成功
		if (result == 1) then
			--冒字获得体力
			--createGetTiLiFloat(addTiLiNum)
			
			--音效
			--hApi.PlaySound("recover_hp")
			
			--再次获取玩家体力产量信息
			SendCmdFunc["tank_reqiure_tili_info"]()
		end
	end)
	
	--监听获得成就信息返回事件
	hGlobal.event:listen("localEvent_OnReceiveAchievementInfo", "__Achievement_mainbase_", function()
		--找到成就墙
		local oWorld = hGlobal.WORLD.LastWorldMap
		if oWorld then
			--不是基地界面，不处理
			if (oWorld.data.map ~= hVar.MainBase) then
				return
			end
			
			--遍历全部单位
			local chengjiuUnit = _oStarMedalUnit
			if chengjiuUnit then
				--总星星
				local totalStar = LuaGetPlayerStarCountVal()
				--totalStar = 666
				
				hApi.safeRemoveT(chengjiuUnit.chaUI, "star")
				hApi.safeRemoveT(chengjiuUnit.chaUI, "starNum")
				hApi.safeRemoveT(chengjiuUnit.chaUI, "lvup")
				
				--星星
				local starDx = 0
				if (totalStar >= 100) then --三位数
					starDx = -10
				end
				chengjiuUnit.chaUI["star"] = hUI.image:new({
					parent = chengjiuUnit.handle._n,
					model = "misc/addition/star_light2.png",
					align = "MC",
					x = -26 + starDx,
					y = 20,
					w = 32,
					h = 32,
				})
				
				--星星值
				chengjiuUnit.chaUI["starNum"] = hUI.label:new({
					parent = chengjiuUnit.handle._n,
					font = "num",
					text = totalStar,
					size = 24,
					align = "LC",
					x = -4 + starDx,
					y = 20 - 1,
				})
				
				--星星的按钮叹号
				chengjiuUnit.chaUI["lvup"] = hUI.image:new({
					parent = chengjiuUnit.handle._n,
					model = "UI:TaskTanHao",
					x = 15 + 15,
					y = 25 - 5 + 40,
					scale = 1.2,
				})
				local act1 = CCMoveBy:create(0.2, ccp(0, 6))
				local act2 = CCMoveBy:create(0.2, ccp(0, -6))
				local act3 = CCMoveBy:create(0.2, ccp(0, 6))
				local act4 = CCMoveBy:create(0.2, ccp(0, -6))
				local act5 = CCDelayTime:create(0.6)
				local act6 = CCRotateBy:create(0.1, 10)
				local act7 = CCRotateBy:create(0.1 * 1, -10 * 2)
				local act8 = CCRotateBy:create(0.1 * 1, 10 * 2)
				local act9 = CCRotateBy:create(0.1, -10)
				local act10 = CCDelayTime:create(0.8)
				local a = CCArray:create()
				a:addObject(act1)
				a:addObject(act2)
				a:addObject(act3)
				a:addObject(act4)
				a:addObject(act5)
				a:addObject(act6)
				a:addObject(act7)
				a:addObject(act8)
				a:addObject(act9)
				a:addObject(act10)
				local sequence = CCSequence:create(a)
				chengjiuUnit.chaUI["lvup"].handle._n:runAction(CCRepeatForever:create(sequence))
				chengjiuUnit.chaUI["lvup"].handle._n:setVisible(false) --默认隐藏
				
				--检测是否有可领取的星星成就
				local enableAchievementFinish_starCount = hApi.CheckMadelByType(hVar.MEDAL_TYPE.starCount)
				local bShowNotice = (enableAchievementFinish_starCount)
				chengjiuUnit.chaUI["lvup"].handle._n:setVisible(bShowNotice)
			end
			
			--更换战车
			local tankIdx = LuaGetHeroTankIdx()
			local tankId = hVar.tab_unit[hVar.MY_TANK_ID].tank_unit[tankIdx]
			Code_ReplaceTank(tankId, true)
		end
	end)
	
	hGlobal.event:listen("LocalEvent_MainBaseEventCB","__Do_event",function()
		local oWorld = hGlobal.WORLD.LastWorldMap
		if oWorld and _frm and _frm.data.show == 1 then
			if _tTalkUnitInfo then
				--local curScore = LuaGetPlayerScore() --当前积分
				--更新总积分
				--_childUI["GoldNum"]:setText(curScore)
				local oPlayerMe = oWorld:GetPlayerMe() --我的玩家对象
				local nForceMe = oPlayerMe:getforce() --我的势力
				local oHero = oPlayerMe.heros[1]
				local oUnit = oHero:getunit()
				local eventInfo = _tTalkUnitInfo.event
				local triggerID = eventInfo[3]
				local u = hApi.UniqueID2UnitByWorld(triggerID)
				hApi.addTimerOnce("mainBaseMoveEvent",100, function()
					if oUnit and u then
						local toX, toY = u:getXY()
						hApi.UnitMoveToPoint_TD(oUnit, toX, toY, false)
					end
					hApi.addTimerOnce("clearMainBaseParm",800,function()
						oWorld.data.keypadEnabled = true
						_shouldCheckEvent = true
					end)
				end)
			end
		end
	end)

	hGlobal.event:listen("LocalEvent_refresheDishuCoin","refresh",function()
		Code_CreateDishuCoin()
	end)

	hGlobal.event:listen("LocalEvent_refreshPurchaseGiftInfo","refresh",function()
		
	end)

	hGlobal.event:listen("LocalEvent_refreshTacticsInfo","refresh",function(nMode,reset)
		if nMode == "all" then
			for i = 1,#_tTacticsUnitList do
				local oUnit = _tTacticsUnitList[i]
				Code_CreateTacticsLvBg(oUnit,true)
				Code_PlayTacticsLvUpEffect(oUnit)
			end
		else
			Code_CreateTacticsLvBg(_tLastTalkTarget,true)
			Code_PlayTacticsLvUpEffect(_tLastTalkTarget)
		end
		if reset == nil or reset then
			hGlobal.event:event("LocalEvent_MainBaseResetUnitInfo")
		end
	end)

	hGlobal.event:listen("LocalEvent_refreshPetInfo","refresh",function(nType,reset)
		print("LocalEvent_refreshPetInfo")
		--1 解锁 2 升级
		if nType == 1 then
			Code_RefreshPetBase()
		end
		for i = 1,#_tPetUnitList do
			Code_CreatePetLvBg(_tPetUnitList[i],true)
		end
		if reset == nil or reset then
			hGlobal.event:event("LocalEvent_MainBaseResetUnitInfo")
		end
	end)

	hGlobal.event:listen("LocalEvent_refreshWeaponInfo","refresh",function(reset)
		for i = 1,#_tWeaponUnitList do
			local unit = _tWeaponUnitList[i]
			Code_AddWeaponCanUpgradeEffect(unit)
		end
		if reset == nil or reset then
			hGlobal.event:event("LocalEvent_MainBaseResetUnitInfo")
		end
	end)

	hGlobal.event:listen("LocalEvent_ShowDLCMapInfo","mainbase",function(map)
		--todo
		--尤达战役包，目前只有管理员能进
		if (map == "world/dlc_yxys_yoda") or (map == "world/dlc_yxys_walle") then
			--管理员，检测tab表
			if (g_lua_src == 1) or (g_is_account_test == 2) then --源代码模式、管理员
				--
			else
				--冒字
				local strText = "暂未开放！"
				hUI.floatNumber:new({
					x = hVar.SCREEN.w / 2,
					y = hVar.SCREEN.h / 2,
					align = "MC",
					text = "",
					lifetime = 2000,
					fadeout = -550,
					moveY = 32,
				}):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)
				
				return
			end
		end
		
		hGlobal.event:event("LocalEvent_Phone_ShowDLCMapInfoFrm",map)
		hGlobal.event:event("LocalEvent_SetCommentId",{map})
	end)
	
	hGlobal.event:listen("LocalEvent_EnterRandMap","enterMap",function(nRandId,nReset)
		nRandId = nRandId or 1
		nReset = nReset or 0
		local oWorld = hGlobal.WORLD.LastWorldMap
		local nStage = 1
		local nDeathcount = 0
		local nLifecount = hVar.DEFAULT_LIFT_NUM
		local nCanBuyLiftcount = hVar.CAN_BUY_LIFE_NUM
		local nWeaponlevel = 1
		local mapName = hVar.MainBase
		local tRandMap = hVar.tab_randmap[nRandId][nStage]
		local nTankId = LuaGetPlayerSelectTank(g_curPlayerName)[1] or hVar.MY_TANK_ID
		local nTalentpoint = 0
		local tTalentskill = {}
		if tRandMap and type(tRandMap.randmap) == "table" then
			local r = math.random(1,#tRandMap.randmap)
			mapName = tRandMap.randmap[r]
			if hVar.MAP_INFO[mapName] == nil then
				local strText = "地图 " .. "\"" .. tostring(mapName) .. "\" " .. " 未定义！"
				hGlobal.UI.MsgBox(strText, {
					font = hVar.FONTC,
					ok = function()
						--self:setstate(1)
					end,
				})
				mapName = hVar.MainBase
			end
		end
		--获取上一次游戏进度
		local tInfo = LuaGetPlayerRandMapInfo(g_curPlayerName)
		--阶段1不存储信息
		print("tInfo.isguide",tInfo.isguide)
		if tInfo.id and (tInfo.stage ~= 1 or tInfo.isguide == 1) and type(tInfo.lifecount) == "number" and tInfo.lifecount > 0 and tInfo.isclear ~= 1  and tInfo.istest ~= 1 and nReset ~= 1 then
			nRandId = tInfo.id or nRandId
			nStage = tInfo.stage or nStage
			nLifecount = tInfo.lifecount or nLifecount
			nDeathcount = tInfo.deathcount or nDeathcount
			nCanBuyLiftcount = tInfo.canbuylife or nCanBuyLiftcount
			mapName = tInfo.mapname or mapName
			nWeaponlevel = tInfo.weaponlevel or nWeaponlevel
			nTankId = tInfo.tankId or nTankId
			nTalentpoint = tInfo.talentpoint or nTalentpoint
			if type(tInfo.talentskill) == "table" then
				tTalentskill = hApi.ReadParamWithDepth(tInfo.talentskill,nil,{},3)
			end
			--重置
			local tInfos = {
				{"bossid_l",0},
				{"ckscore",0},
				--{"rollingcount",0}, --本关碾压数量
			}
			if tInfo.stageInfo == nil then
				tInfo.stageInfo = {}
			end
			tInfo.stageInfo[nStage] = {}
			LuaSetPlayerRandMapInfos(g_curPlayerName,tInfos)
		else
			--如不满足上述要求 则新开局
			LuaClearPlayerRandMapInfo(g_curPlayerName)
			local tInfos = {
				{"id",nRandId},
				{"stage",nStage},
				{"lifecount",nLifecount},
				{"tank",nTankId},
			}
			LuaSetPlayerRandMapInfos(g_curPlayerName,tInfos)

			--新开局时 统计游戏数据
			LuaRecordPlayerGameLog()

			--临时处理
			local curScore = LuaGetPlayerScore()
			local costScore = hApi.NumBetween(0,200,curScore)
			if costScore > 0 then 
				LuaAddPlayerScore(- costScore)
				local keyList = {"material"}
				LuaSavePlayerData_Android_Upload(keyList, "进随机地图")
			end
			GameManager.AddGameInfo("scoreingame",200)

			if GameManager.Data == nil then
				GameManager.Data = {}
			end
			GameManager.Data.gametype = hVar.GameType.SIXBR
		end
		hApi.addTimerOnce("testssssssssssssss",1000,function()
			if type(table_print) == "function" then
				table_print(tInfo)
			end
			print("mapName",mapName)
		end)
		local tRMapInfo
		if mapName ~= hVar.MainBase then
			tRMapInfo = {
				randmapId = nRandId,
				stage = nStage,
				weaponlevel = nWeaponlevel,
				talentpoint = 2,
				talentskill = tTalentskill,
			}
		end
		
		print(debug.traceback())
		
		local activeskill = {}
		local basic_weapon_level = 1
		local follow_pet_units = {}
		--记录本局营救科学家的数据
		local statistics_rescue_count = 0 --大菠萝营救的科学家数量(随机关单局数据)
		local statistics_rescue_num = 0 --大菠萝营救的科学家数量(随机关累加数据)
		local statistics_rescue_costnum = 0 --大菠萝营救的科学家消耗数量
		if oWorld then
			--记录本局还未使用的道具技能
			--local activeskill = {}
			local me = oWorld:GetPlayerMe()
			local oHero = me.heros[1]
			--local typeId = oHero.data.id --英雄类型id
			local itemSkillT = oHero.data.itemSkillT
			if (itemSkillT) then
				for k = hVar.TANKSKILL_EMPTY + 1, #itemSkillT, 1 do
					local activeItemId = itemSkillT[k].activeItemId --主动技能的CD
					local activeItemLv = itemSkillT[k].activeItemLv --主动技能的等级
					local activeItemNum = itemSkillT[k].activeItemNum --主动技能的使用次数
					local activeItemCD = itemSkillT[k].activeItemCD --主动技能的CD
					local activeItemLastCastTime = itemSkillT[k].activeItemLastCastTime --主动技能的上次释放的时间（单位:秒）
					
					--存储
					activeskill[#activeskill+1] = {id = activeItemId, lv = activeItemLv, num = activeItemNum,}
				end
			end
			
			--记录本局武器等级
			--local basic_weapon_level = 1
			local oUnit = oHero:getunit()
			if oUnit then
				if (oUnit.data.bind_weapon ~= 0) then
					basic_weapon_level = oUnit.data.bind_weapon.attr.attack[6]
				end
			end
			--print("（随机地图） basic_weapon_level=", basic_weapon_level)
			
			--记录本局还存在的宠物
			--local follow_pet_units = {}
			--geyachao: 大菠萝瓦力传送
			local rpgunits = oWorld.data.rpgunits
			for u, u_worldC in pairs(rpgunits) do
				for _, walle_id in ipairs(hVar.MY_TANK_FOLLOW_ID) do
					if (u.data.id == walle_id) then
						follow_pet_units[#follow_pet_units+1] = {id = u.data.id, lv = u.attr.lv, star = u.attr.star,}
					end
				end
			end
			
			--记录本局营救科学家的数据
			statistics_rescue_count = oWorld.data.statistics_rescue_count --大菠萝营救的科学家数量(随机关单局数据)
			statistics_rescue_num = oWorld.data.statistics_rescue_num --大菠萝营救的科学家数量(随机关累加数据)
			statistics_rescue_costnum = oWorld.data.statistics_rescue_costnum --大菠萝营救的科学家消耗数量
		end
		
		--geyachao: 进入下一关，复用本局的大菠萝数据（随机地图）
		if type(hGlobal.LocalPlayer.data.diablodata) == "table" then
			hGlobal.LocalPlayer.data.diablodata.lifecount = nLifecount --命数量
			hGlobal.LocalPlayer.data.diablodata.canbuylife = nCanBuyLiftcount --可以购买命的数量 
			hGlobal.LocalPlayer.data.diablodata.deathcount = nDeathcount --死亡次数
			hGlobal.LocalPlayer.data.diablodata.randMap = tRMapInfo
			hGlobal.LocalPlayer.data.diablodata.activeskill = activeskill --坦克的上一局主动技能
			hGlobal.LocalPlayer.data.diablodata.basic_weapon_level = basic_weapon_level --坦克的上一局的武器等级
			hGlobal.LocalPlayer.data.diablodata.follow_pet_units = follow_pet_units --坦克的上一局的宠物
			hGlobal.LocalPlayer.data.diablodata.statistics_rescue_count = statistics_rescue_count --营救的科学家数量(随机关单局数据)
			hGlobal.LocalPlayer.data.diablodata.statistics_rescue_num = statistics_rescue_num --营救的科学家数量(随机关累加数据)
			hGlobal.LocalPlayer.data.diablodata.statistics_rescue_costnum = statistics_rescue_costnum --营救的科学家消耗数量
			--战术卡信息
			hGlobal.LocalPlayer.data.diablodata.tTacticInfo = nil
			--宝箱信息
			hGlobal.LocalPlayer.data.diablodata.tChestInfo = nil
			--战车生命百分比
			hGlobal.LocalPlayer.data.diablodata.hpRate = nil
			--随机迷宫层数和小关数
			hGlobal.LocalPlayer.data.diablodata.randommapStage = nil
			hGlobal.LocalPlayer.data.diablodata.randommapIdx = nil
		else
			hGlobal.LocalPlayer.data.diablodata = LuaInitDiabloData()
		end
		
		if oWorld then
			oWorld:del()
			oWorld = nil
		end
		
		--跳转
		local __MAPDIFF = 0
		local __MAPMODE = hVar.MAP_TD_TYPE.NORMAL
		xlScene_LoadMap(g_world, mapName,__MAPDIFF,__MAPMODE)
	end)
	
	hGlobal.event:listen("LocalEvent_showblackdragonshopbtn","refresh",function(show)
		_childUI["btn_shop"]:setstate(show)
		if show == -1 then
			hGlobal.event:event("LocalEvent_CloseBlackDragonTalkFrm")
		else
			if _nUnlockviparea == -1 then
				_nUnlockviparea = hApi.GetUnlockStateByName("viparea")
			end
			hGlobal.event:event("LocalEvent_ShowBlackDragonTalkFrm",_nUnlockviparea)
		end
		--[[
		if (show == 1) then
			--触发事件，显示黑龙对话界面
			hGlobal.event:event("LocalEvent_Phone_ShowBlackDragonTalkFrm")
		elseif (show == -1) then
			--触发事件，关闭黑龙对话界面
			hGlobal.event:event("LocalEvent_Phone_HideBlackDragonTalkFrm")
		end
		]]
	end)
	
	--[[
	--切换战车按钮状态控制
	hGlobal.event:listen("LocalEvent_showswitchtankbtn","refresh",function(unitId)
		--print("LocalEvent_showswitchtankbtn", unitId)
		if (_childUI["btn_swich_tank"].data.state == -1) then
			_childUI["btn_swich_tank"]:setstate(1)
			_childUI["btn_swich_tank"].data.unitId = unitId
		end
	end)
	]]
	
	--[[
	--取消切换战车按钮状态控制
	hGlobal.event:listen("LocalEvent_hideswitchtankbtn","refresh",function(unitId)
		_childUI["btn_swich_tank"]:setstate(-1)
		_childUI["btn_swich_tank"].data.unitId = 0
	end)
	]]
	
	hGlobal.event:listen("LocalEvent_DelUnit","mainbasefrm",function(name)
		if _tDelUnitList[name] then
			local num = #_tDelUnitList[name]
			for i = 1,num do
				local u = _tDelUnitList[name][i]
				u:del()
				_tDelUnitList[name][i] = nil
			end
		end
		_tDelUnitList[name] = nil
	end)
	
	hGlobal.event:listen("LocalEvent_EnableKeypad_mainbase","_EnableKeypad",function()
		local oWorld = hGlobal.WORLD.LastWorldMap
		if oWorld then
			oWorld.data.keypadEnabled = true
		end
	end)
	
	hGlobal.event:listen("LocalEvent_EnableMainbaseFrm","showfrm",function(show)
		_frm:show(show)
	end)
	
	--geyachao: 邮件已改为新写法+新界面
	--监听邮件（新）变化判断，显示/隐藏邮件叹号
	hGlobal.event:listen("localEvent_OnReceiveSystemMailList", "__CheckNewWebActionRefresh__", function(mailNum, tMailInfo)
		--print("监听邮件变化判断（新）", mailNum, tMailInfo, debug.traceback())
		--local uiCtrl = _childUI[bottomMenuName[7] ].childUI["lvup"]
		
		local uiCtrl = _childUI["task"].childUI["lvup"] --邮件第3个按钮
		
		--没有邮件，隐藏叹号
		if (mailNum == 0) then
			--标记邮件提示叹号
			g_mailNotice = 0
		--只有1封邮件，检测是否是系统公告
		elseif (mailNum == 1) then
			local tipSwitch = 1 --是否提示
			local tMailI = tMailInfo[1]
			local prizeId = tMailI.prizeId --邮件id
			local prizeType = tMailI.prizeType --邮件类型
			local prizeContent = tMailI.prizeContent --邮件正文
			
			if (prizeType == 2000) then --系统公告
				local itemID,itemNum,itemName,itemHole,coin,score,itemBack,itemModel,GiftTip,GiftTip_Ex,ex_num,_,_,giftType = hApi.UnpackPrizeData(prizeType,prizeId,prizeContent)
				
				--标题过滤掉回车符
				GiftTip = string.gsub(GiftTip, "\n", "") --过滤掉回车符
				GiftTip = GiftTip:gsub("^%s*(.-)%s*$", "%1") --trim
				
				--已阅读过，标记为不需要提示
				local lasttitle = LuaGetSystemMailTitle(g_curPlayerName) --上一次阅读的系统邮件标题
				if (lasttitle == GiftTip) then
					tipSwitch = 0
				end
			end
			
			--标记邮件提示叹号
			g_mailNotice = tipSwitch
		else --多封邮件
			--标记邮件提示叹号
			g_mailNotice = 1
		end
		
		--主基地更新任务叹号
		Code_UpdateTanHao()
	end)
	
	--监听新玩家14日签到活动，今日签到结果
	hGlobal.event:listen("localEvent_activity_today_signin", "__CheckNewWebActionRefresh__", function(aid, ptype, result, progress, progressMax, info, prizeId, prizeType, reward)
		--主基地更新任务叹号
		Code_UpdateTanHao()
	end)
	
	--监听活动信息
	hGlobal.event:listen("localEvent_UpdateActivityInfo", "__CheckNewWebActionRefresh__", function(t)
		--主基地更新任务叹号
		Code_UpdateTanHao()
	end)
	
	--监听通知刷新点将台、战术卡、成就任务活动、竞技场锦囊、商城今日刷新商品、评价，等叹号提示
	hGlobal.event:listen("LocalEvent_RefreshMedalStateUI", "__CheckNewWebActionRefresh__", function()
		--主基地更新任务叹号
		Code_UpdateTanHao()
	end)
	
	--监听关闭背包事件
	hGlobal.event:listen("LocalEvent_RecoverBarrage", "__CheckNewWebActionRefresh__", function()
		--print("监听关闭背包事件 LocalEvent_RecoverBarrage")
		--主基地更新任务叹号
		Code_UpdateTanHao()
	end)
	
	--监听收到玩家宠物信息返回结果事件
	hGlobal.event:listen("LocalEvent_OnReceiveTankPetInfoRet", "_OnReceiveTankPetInfoRet_", function()
		local oWorld = hGlobal.WORLD.LastWorldMap
		if _frm and (_frm.data.show == 1) and oWorld and (oWorld.data.map == hVar.MainBase) then
			local oPlayerMe = oWorld:GetPlayerMe() --我的玩家对象
			local oHero = oPlayerMe.heros[1]
			--print(oHero)
			if oHero then
				local oUnit = oHero:getunit()
				--print(oUnit)
				if oUnit then
					--释放技能
					local targetX, targetY = hApi.chaGetPos(oUnit.handle) --目标的位置
					local gridX, gridY = oWorld:xy2grid(targetX, targetY)
					local skillId = 16008 --挖矿技能
					local skillLv = 1
					local tCastParam = {level = skillLv,}
					hApi.CastSkill(oUnit, skillId, 0, nil, nil, gridX, gridY, tCastParam)
				end
			end
		end
	end)
	
	hGlobal.event:listen("LocalEvent_SpinScreen","SystemMenuFram_mainbase",function()
		local oWorld = hGlobal.WORLD.LastWorldMap
		if _frm and _frm.data.show == 1 and oWorld and oWorld.data.map == hVar.MainBase then
			Code_ClearFrm()
			Code_CreateMainBaseFrm()
			_frm:show(1)
			hGlobal.event:event("LocalEvent_RefreshScoreAction",0)
			hGlobal.event:event("LocalEvent_SetDanmuBtnState",nil,1)
			--hGlobal.event:event("LocalEvent_Comment_Clean")
		end
	end)
	
	hGlobal.event:listen("LocalEvent_PlayerFocusWorld", "__SHOW__SystemMenuFram_mainbase",function(sSceneType,oWorld,oMap)
		if g_editor == 1 then
			return
		end
		
		--如果是从基地切换到黑龙，或者黑龙切换到基地，不处理
		if (hVar.OPTIONSSYSTEM_MAINBASE_NOCLEAR == 1) then
			if oWorld and sSceneType=="worldmap" and oWorld.data.map == hVar.MainBase then
				Code_ShowFrm()
			else
				Code_HideFrm()
			end
			
			return
		end
		
		Code_ClearFrm()
		if oWorld and sSceneType=="worldmap" and oWorld.data.map == hVar.MainBase then
			g_DisableShowOption = 1
			hGlobal.event:event("Event_InitHotKey")
			--预加载文字
			PreloadTxtManager.func.Init()
			Code_CreateMainBaseFrm()
			
			_frm:show(1)
			hGlobal.event:event("LocalEvent_SetDanmuBtnState",nil,1)
			_shouldCheckEvent = true
			
			--发起查询服务器系统时间
			SendCmdFunc["refresh_systime"]()
			
			--进入新手基地开始检查是否有可领取的邮件
			SendCmdFunc["get_prize_list"]()
			SendCmdFunc["get_system_mail_list"]()
			--SendCmdFunc["gamecoin"]()
			--获取我的资源（游戏币、兵符、红装晶石、战功积分）
			SendCmdFunc["get_mycoin"]()
			--获取玩家体力产量信息
			SendCmdFunc["tank_reqiure_tili_info"]()
			--获取成就数据
			SendCmdFunc["achievement_query_info"]()
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
			
			--获取VIP等级
			--SendCmdFunc["get_VIP_Lv"]()
			SendCmdFunc["get_VIP_Lv_New"]()
			--领取VIP每日奖励
			--SendCmdFunc["get_VIP_dailyReward"]()
			
			--发送查询活动信息请求
			local langIdx = g_Cur_Language - 1
			SendCmdFunc["get_ActivityList"](langIdx)
			
			--[[
			local tankIdx = LuaGetHeroTankIdx()
			local tankId = hVar.tab_unit[hVar.MY_TANK_ID].tank_unit[tankIdx]
			Code_ReplaceTank(tankId, true)
			]]
			
			--管理员，检测tab表
			if (g_lua_src == 1) or (g_is_account_test == 2) then --源代码模式、管理员
				--击杀怪物得钱是否超出上限警告
				for unitId, tabU in pairs(hVar.tab_unit) do
					local attr = tabU.attr
					if attr then
						local kill_gold = attr.kill_gold or 0
						if (kill_gold > 500) then
							local strText = "警告: 单位[" .. unitId .. "] 的 [kill_gold] 属性 超过理论上限500，当前值为 :" .. kill_gold
							hGlobal.UI.MsgBox(strText,{
								font = hVar.FONTC,
								ok = function()
									--
								end,
							})
							print(strText)
						end
					end
				end
				
				--漏怪扣点数否超出上限警告
				for unitId, tabU in pairs(hVar.tab_unit) do
					local attr = tabU.attr
					if attr then
						local escape_punish = attr.escape_punish or 0
						if (escape_punish > 10) then
							local strText = "警告: 单位[" .. unitId .. "] 的 [escape_punish] 属性 超过理论上限10，当前值为 :" .. escape_punish
							hGlobal.UI.MsgBox(strText,{
								font = hVar.FONTC,
								ok = function()
									--
								end,
							})
							print(strText)
						end
					end
				end
				
				--检测tab_tactics中的技能是否
				for tacticId, tabT in pairs(hVar.tab_tactics) do
					local skillId = tabT.skillId or 0
					if (skillId > 0) then
						--print("skillId=", skillId)
						local tabS = hVar.tab_skill[skillId]
						if (tabS == nil) then
							local strText = "警告: 战术卡[" .. tacticId .. "] 的技能id无效！当前值为 :" .. skillId
							hGlobal.UI.MsgBox(strText,{
								font = hVar.FONTC,
								ok = function()
									--
								end,
							})
							print(strText)
						end
					end
				end
				
				--检测tab_item中的技能是否
				for itemId, tabI in pairs(hVar.tab_item) do
					--被动技能
					local skillId = tabI.skillId
					if (type(skillId) == "table") then
						for s = 1, #skillId, 1 do
							local skillId = skillId[s].id
							--print("itemId=", itemId, "skillId=", skillId)
							local tabS = hVar.tab_skill[skillId]
							if (tabS == nil) then
								local strText = "警告: 道具[" .. itemId .. "] 的技能id无效！当前值为 :" .. skillId
								hGlobal.UI.MsgBox(strText,{
									font = hVar.FONTC,
									ok = function()
										--
									end,
								})
								print(strText)
							end
						end
					end
					
					--主动技能
					local activeSkill = tabI.activeSkill
					if (type(activeSkill) == "table") then
						local skillId = activeSkill.id
						--print("itemId=", itemId, "skillId=", skillId)
						local tabS = hVar.tab_skill[skillId]
						if (tabS == nil) then
							local strText = "警告: 道具[" .. itemId .. "] 的主动技能id无效！当前值为 :" .. skillId
							hGlobal.UI.MsgBox(strText,{
								font = hVar.FONTC,
								ok = function()
									--
								end,
							})
							print(strText)
						end
					end
				end
				
				--检测tab_unit中的单位的普通攻击，AI技能是否存在
				for unitId, tabU in pairs(hVar.tab_unit) do
					local attr = tabU.attr
					if attr then
						--检测普通攻击
						local attack = attr.attack
						if attack then
							local attackId = attack[1]
							if (attackId > 0) then
								local tabS = hVar.tab_skill[attackId]
								if (tabS == nil) then
									local strText = "警告: 单位[" .. unitId .. "] 的普通攻击id无效！当前值为 :" .. attackId
									hGlobal.UI.MsgBox(strText,{
										font = hVar.FONTC,
										ok = function()
											--
										end,
									})
									print(strText)
								end
							end
						end
						
						--检测AI技能
						local skill = attr.skill
						if skill then
							for s = 1, #skill, 1 do
								local skillId = skill[s][1]
								local tabS = hVar.tab_skill[skillId]
								--print(unitId, skillId)
								if (tabS == nil) then
									local strText = "警告: 单位[" .. unitId .. "] 的AI技能id无效！当前值为 :" .. skillId
									hGlobal.UI.MsgBox(strText,{
										font = hVar.FONTC,
										ok = function()
											--
										end,
									})
									print(strText)
								end
							end
						end
					end
					
					--检测天赋技能
					local talent = tabU.talent
					if talent then
						for s = 1, #talent, 1 do
							local skillId = talent[s][1]
							local tabS = hVar.tab_skill[skillId]
							--print(unitId, skillId)
							if (tabS == nil) then
								local strText = "警告: 单位[" .. unitId .. "] 的天赋技能id无效！当前值为 :" .. skillId
								hGlobal.UI.MsgBox(strText,{
									font = hVar.FONTC,
									ok = function()
										--
									end,
								})
								print(strText)
							end
						end
					end
				end
				
				--tab_skill中buff的tag是否和id一致
				for skillId, tabS in pairs(hVar.tab_skill) do
					local action = tabS.action
					for ac = 1, #action, 1 do
						local ac1 = action[ac][1]
						local ac2 = action[ac][2]
						local ac3 = action[ac][3]
						if (ac1 == "BecomeBuff") then
							--检测BUFF标记
							if (ac3 ~= "BUFF_" .. skillId) then
								local strText = "警告: 技能[" .. skillId .. "] 的BUFF标记和技能id不一致！当前值为 :" .. ac3
								hGlobal.UI.MsgBox(strText,{
									font = hVar.FONTC,
									ok = function()
										--
									end,
								})
								print(strText)
							end
							
							--检测施法目标
							if (ac2 ~= "target") then
								local strText = "警告: 技能[" .. skillId .. "] 的BUFF标记的目标类型有误！当前值为 :" .. ac2
								hGlobal.UI.MsgBox(strText,{
									font = hVar.FONTC,
									ok = function()
										--
									end,
								})
								print(strText)
							end
						end
					end
				end
			end
		else
			g_DisableShowOption = 0
			Code_ClearData()
			_shouldCheckEvent = false
		end
	end)


	--hGlobal.event:listen("LocalEvent_testXXXXXX","show",function()
		--Code_InitData()
		--_frm:show(1)
	--end)
end

--if hGlobal.UI.SystemMenuFram_mainbase then
	--hGlobal.UI.SystemMenuFram_mainbase:del()
	--hGlobal.UI.SystemMenuFram_mainbase = nil
--end
--hGlobal.UI.InitSystemMenuFram_mainbase()
--hGlobal.event:event("LocalEvent_testXXXXXX")

--OnCreateUnlockWeaponTip = function(nUnitId,nWeaponIdx)

hGlobal.UI.InitMainBaseSetFrm = function(mode)
	local tInitEventName = {"LocalEvent_ShowMainBaseSetFrm","ShowFrm"}
	if mode ~= "include" then
		return tInitEventName
	end

	local _inGAME = 0

	local OnCreateMainBaseSetFrm = hApi.DoNothing
	local OnLeaveFunc = hApi.DoNothing
	local _CODE_SwitchSoundEnable = hApi.DoNothing
	local _CODE_SwitchLanguage = hApi.DoNothing
	local _CODE_SwitchLowConfigMode = hApi.DoNothing --低配模式界面刷新
	local _CODE_ExitGame = hApi.DoNothing

	local _tChangeLanguageList = {
		[1] = {3,4,"misc/language_sc.png"},	--中文 切英文
		[3] = {4,5,"misc/language_en.png"},	--英文 切日语
		[4] = {1,1,"misc/language_jp.png"},	--日文 切中文
	}

	OnLeaveFunc = function()
		if hGlobal.UI.MainBaseSetFrm then
			hGlobal.UI.MainBaseSetFrm:del()
			hGlobal.UI.MainBaseSetFrm = nil
		end
		hGlobal.event:event("Event_StartPauseSwitch", false)
	end

	--声音开关
	_CODE_SwitchSoundEnable = function(IsSwitch)
		if IsSwitch==1 then
			if hVar.OPTIONS.PLAY_SOUND_BG==1 then
				hVar.OPTIONS.PLAY_SOUND = 0
				hVar.OPTIONS.PLAY_SOUND_BG = 0
			else
				hVar.OPTIONS.PLAY_SOUND = 1
				hVar.OPTIONS.PLAY_SOUND_BG = 1
			end
			if hVar.OPTIONS.PLAY_SOUND_BG==1 then
				hApi.EnableSoundBG(1)
				hApi.PlaySound("button")
			else
				hApi.EnableSoundBG(0)
			end
			hApi.SaveGameOptions()
		end
		local _frm = hGlobal.UI.MainBaseSetFrm
		local _parent = _frm.handle._n
		local _childUI = _frm.childUI
		if hVar.OPTIONS.PLAY_SOUND_BG==1 then
			if _childUI["soundenable"] then
				_childUI["soundenable"]:loadsprite("misc/addition/sound_on.png")
			end
			if _childUI["btn_music"] then
				_childUI["btn_music"]:setText(hVar.tab_string["music_on"])
			end
		else
			if _childUI["soundenable"] then
				_childUI["soundenable"]:loadsprite("misc/addition/sound_off.png")
			end
			if _childUI["btn_music"] then
				_childUI["btn_music"]:setText(hVar.tab_string["music_off"])
			end
		end
	end

	_CODE_SwitchLanguage = function(IsSwitch)
		if IsSwitch == 1 then
			for language,tChangeLanguage in pairs(_tChangeLanguageList) do
				if g_Cur_Language == language then
					local c1,c2,c3 = unpack(tChangeLanguage)
					g_Cur_Language = c1
					g_language_setting = c2
					CCUserDefault:sharedUserDefault():setIntegerForKey("xl_language",g_language_setting)
					CCUserDefault:sharedUserDefault():flush()
					hApi.ChangeLanguage()
					break
				end
			end
		end
		local _frm = hGlobal.UI.MainBaseSetFrm
		local _parent = _frm.handle._n
		local _childUI = _frm.childUI
		if _childUI["languageFlag"] then
			tChangeLanguage = _tChangeLanguageList[g_Cur_Language]
			if type(tChangeLanguage) == "table" then
				_childUI["languageFlag"]:loadsprite(tChangeLanguage[3])
			end
			if g_Cur_Language==1 then
				hGlobal.event:event("LocalEvent_HideTacticsHelpUnit",0)
			else
				hGlobal.event:event("LocalEvent_HideTacticsHelpUnit",1)
			end
		end
	end
	
	--低配模式界面刷新
	_CODE_SwitchLowConfigMode = function(IsSwitch)
		local _frm = hGlobal.UI.MainBaseSetFrm
		local _parent = _frm.handle._n
		local _childUI = _frm.childUI
		
		--低配模式
		if (IsSwitch == 1) then
			LuaSetTankLowConfigMode(1)
		elseif (IsSwitch == 0) then
			LuaSetTankLowConfigMode(0)
		end
		
		local flag = LuaGetTankLowConfigMode()
		
		--更新文字
		if _childUI["lowconfigmodeLabel"] then
			_childUI["lowconfigmodeLabel"]:setText(hVar.tab_string["lowconfigmode"])
		end
		
		--更新文字颜色
		if (flag == 1) then
			if _childUI["lowconfigmodeLabel"] then
				_childUI["lowconfigmodeLabel"].handle.s:setColor(ccc3(0, 255, 0))
			end
		else
			if _childUI["lowconfigmodeLabel"] then
				_childUI["lowconfigmodeLabel"].handle.s:setColor(ccc3(192, 192, 192))
			end
		end
		
		--勾勾
		if (flag == 1) then
			if _childUI["lowconfigmodeSelectOK"] then
				_childUI["lowconfigmodeSelectOK"].handle._n:setVisible(true)
			end
		else
			if _childUI["lowconfigmodeSelectOK"] then
				_childUI["lowconfigmodeSelectOK"].handle._n:setVisible(false)
			end
		end
		
		if g_Cur_Language==1 then --中文
			--
		else --英文
			--
		end
	end
	
	_CODE_ExitGame = function()
		local diablodata = hGlobal.LocalPlayer.data.diablodata
		if diablodata and type(diablodata.randMap) == "table" then
			OnLeaveFunc()

			--存档
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
			
			--关闭同步日志文件
			hApi.SyncLogClose()
			--关闭非同步日志文件
			hApi.AsyncLogClose()
			
			--隐藏可能的选人界面
			if hGlobal.UI.PhoneSelectedHeroFrm2 then
				hGlobal.UI.PhoneSelectedHeroFrm2:show(0)
				hGlobal.UI.PhoneSelectedHeroFrmBG.handle.s:setVisible(false) --隐藏背景框挡板
				hApi.clearTimer("__SELECT_HERO_UPDATE__")
				hApi.clearTimer("__SELECT_TOWER_UPDATE__")
				hApi.clearTimer("__SELECT_TACTIC_UPDATE__")
			end
			
			local tInfos = {
				{"lifecount",0},
			}
			LuaSetPlayerRandMapInfos(g_curPlayerName,tInfos)
			
			local bResult = false
			TD_OnGameOver_Diablo(bResult)
			
			--大菠萝游戏结束,刷新界面
			local nResult = 0
			hGlobal.event:event("LocalEvent_GameOver_Diablo", nResult)
			return
		end
		--geyachao: 先存档
		--存档
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		
		--关闭同步日志文件
		hApi.SyncLogClose()
		--关闭非同步日志文件
		hApi.AsyncLogClose()
		
		--隐藏可能的选人界面
		if hGlobal.UI.PhoneSelectedHeroFrm2 then
			hGlobal.UI.PhoneSelectedHeroFrm2:show(0)
			hGlobal.UI.PhoneSelectedHeroFrmBG.handle.s:setVisible(false) --隐藏背景框挡板
			hApi.clearTimer("__SELECT_HERO_UPDATE__")
			hApi.clearTimer("__SELECT_TOWER_UPDATE__")
			hApi.clearTimer("__SELECT_TACTIC_UPDATE__")
		end
		
		local w = hGlobal.WORLD.LastWorldMap
		local map = w.data.map
		local tabM = hVar.MAP_INFO[map]
		local chapterId = 1
		if tabM then
			chapterId = tabM.chapter or 1
		end
		--todo zhenkira 这里以后要读取当前地图所在章节进行切换
		
		--zhenkira 注释
		local currentMapMode = hVar.MAP_TD_TYPE.NORMAL
		if (hGlobal.WORLD.LastWorldMap ~= nil) then
			--存储地图模式
			currentMapMode = hGlobal.WORLD.LastWorldMap.data.tdMapInfo and (hGlobal.WORLD.LastWorldMap.data.tdMapInfo.mapMode)
			
			local mapname = hGlobal.WORLD.LastWorldMap.data.map
			--if hApi.Is_RSYZ_Map(mapname) ~= -1 then
			--	print(".."..nil)
			--	Game_Zone_OnGameEvent(GZone_Event_TypeDef.Lua,{GZone_Event_TypeDef.BattleEnd_Fire,luaGetplayerDataID(),g_RSDYZ_BattleID})
			--end
			hGlobal.WORLD.LastWorldMap:del()
			
			hGlobal.LocalPlayer:setfocusworld(nil)
			hApi.clearCurrentWorldScene()
		end
		
		--大菠萝数据初始化
		hGlobal.LocalPlayer.data.diablodata = LuaInitDiabloData()
		
		--切换到配置坦克地图
		local mapname = hVar.MainBase
		local MapDifficulty = 0
		local MapMode = hVar.MAP_TD_TYPE.TANKCONFIG --配置坦克模式
		xlScene_LoadMap(g_world, mapname,MapDifficulty,MapMode)
		
		OnLeaveFunc()
	end
	
	OnCreateMainBaseSetFrm = function(nInGame)
		if hGlobal.UI.MainBaseSetFrm then
			hGlobal.UI.MainBaseSetFrm:del()
			hGlobal.UI.MainBaseSetFrm = nil
		end
		hGlobal.UI.MainBaseSetFrm = hUI.frame:new({
			x = 0,
			y = 0,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			z = 100,
			show = 0,
			--dragable = 2,
			dragable = 2, --点击后消失
			buttononly = 1,
			autoactive = 0,
			--background = "UI:PANEL_INFO_MINI",
			failcall = 1, --出按钮区域抬起也会响应事件
			background = -1, --无底图
			border = 0, --无边框
		})
		
		local _frm = hGlobal.UI.MainBaseSetFrm
		local _parent = _frm.handle._n
		local _childUI = _frm.childUI
		
		local offX = hVar.SCREEN.w/2
		local offY = hVar.SCREEN.h/2
		
		--创建技能tip图片背景
		_childUI["ItemBG_1"] = hUI.button:new({
			parent = _parent,
			--model = "UI_frm:slot",
			--animation = "normal",
			model = "misc/skillup/msgbox4.png",
			dragbox = _childUI["dragBox"],
			x = offX,
			y = hVar.SCREEN.h/2,
			w = 480,
			h = 360,
			code = function()
				--print("技能tip图片背景")
			end,
		})
		
		_childUI["closeBtn"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/skillup/btn_close.png",
			x = offX + 240 - 38,
			y = offY + 180 - 38,
			scaleT = 0.95,
			z = 2,
			code = function()
				OnLeaveFunc()
			end,
		})
		
		local _frm = hGlobal.UI.MainBaseSetFrm
		local _parent = _frm.handle._n
		local _childUI = _frm.childUI

		--默认数据 是新手引导时弹的
		local startY = 60
		local deltaH = - 120
		local btnIndex = 0
		
		--主基地
		if type(nInGame) == "number" and nInGame == 0 then
			startY = 98
			deltaH = - 100
			local curVer = "V"
			local SOverInfo = hVar.CURRENT_ITEM_VERSION
			local PverInfo = tostring(xlGetExeVersion())
			if type(PverInfo) == "string" then
				curVer = curVer..string.sub(PverInfo,2,4)
			end
			if type(SOverInfo) == "string" then
				curVer = curVer..string.sub(SOverInfo,4,string.len(SOverInfo)).."     ID"..xlPlayer_GetUID()
			end
			--curVer = "V031.091102     ID"..xlPlayer_GetUID()
			
			_childUI["programm_version"] = hUI.label:new({
				parent = _parent,
				size = 16,
				text = curVer,
				--font = hVar.FONTC,
				--text = "025.112502(1002)",
				align = "MT",
				border = 1,
				--x = offX + 480/2 - 60,
				x = offX,
				y = offY - 360/2 + 50,
				RGB = {128,128,128},
			})
		end
		
		--除新手关卡外所有游戏中的关卡显示
		if nInGame == 1 then
			startY = 100
			deltaH = -100
			_childUI["btn_exit"] = hUI.button:new({
				parent = _parent,
				model = "misc/addition/cg.png",
				dragbox = _childUI["dragBox"],
				label = {text = hVar.tab_string["exit_game"],size = 32,y= 4,width = 240,height = 36,font = hVar.FONTC,},
				scaleT = 0.95,
				x = offX,
				y = offY + startY + btnIndex * deltaH,
				w = 240,
				h = 64,
				--scale = 0.95,
				code = function(self)
					_CODE_ExitGame()
				end,
			})
			btnIndex = btnIndex + 1
		end
		
		--声音按钮
		_childUI["btn_music"] = hUI.button:new({
			parent = _parent,
			model = "misc/addition/cg.png",
			dragbox = _childUI["dragBox"],
			label = {text = hVar.tab_string["music_on"],size = 32,y= 4,width = 240,height = 36,font = hVar.FONTC,},
			scaleT = 0.95,
			x = offX,
			y = offY + startY + btnIndex * deltaH,
			w = 240,
			h = 64,
			--scale = 0.95,
			code = function(self)
				_CODE_SwitchSoundEnable(1)
				OnCreateMainBaseSetFrm(nInGame)
			end,
		})
		
		--声音图标
		_childUI["soundenable"] = hUI.button:new({
			parent = _parent,
			model = "misc/addition/sound_on.png",
			dragbox = _childUI["dragBox"],
			--icon = "UI:shopitemxg",
			--iconWH = 68,
			dragbox = _frm.childUI["dragBox"],
			x = offX + 156,
			y = offY + startY + btnIndex * deltaH,
			code = function(self)
				_CODE_SwitchSoundEnable(1)
				OnCreateMainBaseSetFrm(nInGame)
			end,
		})
		
		btnIndex = btnIndex + 1
		
		--语言按钮
		_childUI["btn_language"] = hUI.button:new({
			parent = _parent,
			model = "misc/addition/cg.png",
			dragbox = _childUI["dragBox"],
			label = {text = hVar.tab_string["language_setting"],size = 32,y= 4,width = 240,height = 36,font = hVar.FONTC,},
			scaleT = 0.95,
			x = offX,
			y = offY + startY + btnIndex * deltaH,
			w = 240,
			h = 64,
			--scale = 0.95,
			code = function(self)
				_CODE_SwitchLanguage(1)
				OnCreateMainBaseSetFrm(nInGame)
			end,
		})
		
		--语言图标
		_childUI["languageFlag"] = hUI.button:new({
			parent = _parent,
			model = "misc/language_sc.png",
			dragbox = _childUI["dragBox"],
			--icon = "UI:shopitemxg",
			--iconWH = 68,
			x = offX + 156,
			y = offY + startY + btnIndex * deltaH,
			code = function(self)
				_CODE_SwitchLanguage(1)
				OnCreateMainBaseSetFrm(nInGame)
			end,
		})
		
		btnIndex = btnIndex + 1
		
		--主基地
		if type(nInGame) == "number" and nInGame == 0 then
			--低配模式按钮
			_childUI["btn_lowconfigmode"] = hUI.button:new({
				parent = _parent,
				--model = "misc/mask.png",
				model = -1,
				dragbox = _childUI["dragBox"],
				--label = {text = hVar.tab_string["current_language"],size = 32,y= 4,width = 240,height = 36,font = hVar.FONTC,},
				scaleT = 0.95,
				x = offX,
				y = offY + startY + btnIndex * deltaH + 16,
				w = 460,
				h = 64,
				--scale = 0.95,
				code = function(self)
					local flag = LuaGetTankLowConfigMode()
					_CODE_SwitchLowConfigMode(1 - flag)
				end,
			})
			
			--低配模式按钮选中框
			_childUI["lowconfigmodeCheckbox"] = hUI.image:new({
				parent = _parent,
				model = "misc/photo_frame.png",
				x = offX - 90,
				y = offY + startY + btnIndex * deltaH + 16,
				w = 42,
				h = 42,
			})
			
			--低配模式文字
			_childUI["lowconfigmodeLabel"] = hUI.label:new({
				parent = _parent,
				model = "misc/photo_frame.png",
				x = offX - 60,
				y = offY + startY + btnIndex * deltaH + 16 + 1,
				width = 340,
				height = 36,
				font = hVar.FONTC,
				size = 26,
				align = "LC",
				text = hVar.tab_string["lowconfigmode"], --"低配流畅模式"
				RGB = {192, 192, 192,},
			})
			
			--低配模式勾勾
			_childUI["lowconfigmodeSelectOK"] = hUI.image:new({
				parent = _parent,
				model = "misc/ok.png",
				x = offX - 90,
				y = offY + startY + btnIndex * deltaH + 16 + 4,
				w = 48,
				h = 48,
			})
			
			btnIndex = btnIndex + 1
		end
		
		--标识否是是管理员的图标
		if (g_is_account_test == 1) then --测试员
			_childUI["img_star1"] = hUI.image:new({
				parent = _parent,
				model = "ICON:WeekStar",
				x = offX - 170,
				y = offY + 180 - 36,
				w = 32,
				h = 32,
			})
		elseif (g_lua_src == 1) or (g_is_account_test == 2) then --源代码模式、管理员
			_childUI["img_star1"] = hUI.image:new({
				parent = _parent,
				model = "ICON:WeekStar",
				x = offX - 170,
				y = offY + 180 - 36,
				w = 32,
				h = 32,
			})
			_childUI["img_star2"] = hUI.image:new({
				parent = _parent,
				model = "ICON:WeekStar",
				x = offX - 170 + 30,
				y = offY + 180 - 36,
				w = 32,
				h = 32,
			})
		end
		
		if (g_lua_src == 1) or (g_is_account_test == 1) or (g_is_account_test == 2) then
			
			_childUI["btn_cheatmanage"] = hUI.button:new({
				parent = _parent,
				model = "misc/mask.png",
				dragbox = _childUI["dragBox"],
				label = {text = "作弊管理",size = 24,width = 50, font = hVar.FONTC, border = 1, RGB = {255, 255, 0},},
				x = offX + 156,
				y = offY + startY + btnIndex * deltaH + 100,
				w = 56,
				h = 56,
				scaleT = 0.95,
				code = function(self)
					hGlobal.event:event("LocalEvent_ShowCheatManagerFrm")
				end,
			})
		end

		--礼品码按钮
--		_childUI["giftBtn"] = hUI.button:new({
--			parent = _parent,
--			model = "misc/gift.png",
--			dragbox = _childUI["dragBox"],
--			--icon = "UI:shopitemxg",
--			--iconWH = 68,
--			dragbox = _frm.childUI["dragBox"],
--			x = offX + 156,
--			y = offY + startY + btnIndex * deltaH + 70,
--			w = 56,
--			h = 56,
--			scaleT = 0.95,
--			code = function(self)
--				--if hGlobal.UI.MainBaseSetFrm then
--				--	hGlobal.UI.MainBaseSetFrm:del()
--				--	hGlobal.UI.MainBaseSetFrm = nil
--				--end
--				
--				--弹出礼品码界面
--				--hGlobal.event:event("LocalEvent_ShowWithdrawGiftFrm", 1)
--				--hGlobal.event:event("LocalEvent_ShowChariotConfigFrm")
--				--触发事件，显示宝物界面
--				hGlobal.event:event("LocalEvent_Phone_ShowPhoneBaoWuFrame", callback)
--				OnLeaveFunc()
--			end,
--		})
		
		_CODE_SwitchSoundEnable()
		_CODE_SwitchLanguage()
		_CODE_SwitchLowConfigMode()
		
		_frm:show(1)
		_frm:active()
	end

	hGlobal.event:listen("CloseMainBaseSetFrm","closefrm",function()
		OnLeaveFunc()
	end)

	hGlobal.event:listen("LocalEvent_SpinScreen","MainBaseSetFrm",function()
		local _frm = hGlobal.UI.MainBaseSetFrm
		if _frm and _frm.data.show == 1 then
			OnLeaveFunc()
			hGlobal.event:event("LocalEvent_ShowMainBaseSetFrm",_inGAME)
		end
	end)

	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(nInGame)
		nInGame = nInGame or 0
		_inGAME = nInGame
		if hApi.IsReviewMode() then
			--显示审核版
			hGlobal.event:event("LocalEvent_ShowSetFrm_Review",nInGame)
		else
			--新手引导关卡不弹此界面
			if type(nInGame) == "number" and nInGame >= 1 and ((g_lua_src == 1) or (g_is_account_test == 2)) then --源代码模式、管理员
				
			else
				OnCreateMainBaseSetFrm(nInGame)
				hGlobal.event:event("Event_StartPauseSwitch", true)
			end
		end
	end)
end


hGlobal.UI.InitSystemMenuIntegrateFrm = function(mode)
	local tInitEventName = {"LocalEvent_ShowSystemMenuIntegrateFrm", "_show",}
	if (mode ~= "include") then
		--return tInitEventName
	end

	local _tChangeLanguageList = {
		[1] = {3,4,"misc/language_sc.png"},	--中文 切英文
		[3] = {4,5,"misc/language_en.png"},	--英文 切日语
		[4] = {1,1,"misc/language_jp.png"},	--日文 切中文
	}

	local _tScreenMode = {
		{"screen_unlock","misc/iconb_nolock.png"},	--不锁定
		{"screen_vertical","misc/iconb_lock.png"},	--竖锁
		{"screen_horizontal","misc/iconb_lock.png"},	--横锁
	}

	local _tViewList = {
		{"mediumview",1},
		{"farview",1.1},
		{"nearview",0.9},
	}

	local _frm,_parent,_childUI = nil,nil,nil
	local _boardW,_boardH = 500,492
	local m_fScale = 1.0
	local _startTime = 0
	local _clickCount = 0
	local _CODE_ClearFunc = hApi.DoNothing
	local _CODE_CreateFrm = hApi.DoNothing
	local _CODE_CreateBtn = hApi.DoNothing
	local _CODE_CreateUI = hApi.DoNothing
	local _CODE_RepaintFrm = hApi.DoNothing
	local _CODE_CreateCheatUI = hApi.DoNothing
	local _CODE_CreatePassGuideMap = hApi.DoNothing
	
	local _CODE_SwitchLanguage = hApi.DoNothing
	local _CODE_SwitchSoundEnable = hApi.DoNothing
	local _CODE_SwitchScreenMode = hApi.DoNothing
	local _CODE_SwitchView = hApi.DoNothing
	local _CODE_SwitchTankHpBar = hApi.DoNothing --战车显血开关
	
	_CODE_ClearFunc = function()
		if hGlobal.UI.SystemMenuIntegrateFrm then
			hGlobal.UI.SystemMenuIntegrateFrm:del()
			hGlobal.UI.SystemMenuIntegrateFrm = nil
		end
		_frm,_parent,_childUI = nil,nil,nil
		_startTime = 0
		_clickCount = 0
	end

	_CODE_SwitchSoundEnable = function(IsSwitch)
		if IsSwitch==1 then
			if hVar.OPTIONS.PLAY_SOUND_BG==1 then
				hVar.OPTIONS.PLAY_SOUND = 0
				hVar.OPTIONS.PLAY_SOUND_BG = 0
			else
				hVar.OPTIONS.PLAY_SOUND = 1
				hVar.OPTIONS.PLAY_SOUND_BG = 1
			end
			if hVar.OPTIONS.PLAY_SOUND_BG==1 then
				hApi.EnableSoundBG(1)
				hApi.PlaySound("button")
			else
				hApi.EnableSoundBG(0)
			end
			hApi.SaveGameOptions()
		end
		if hVar.OPTIONS.PLAY_SOUND_BG==1 then
			if _childUI["soundenable"] then
				_childUI["soundenable"]:loadsprite("misc/addition/sound_on.png")
			end
			if _childUI["btn_music"] then
				_childUI["btn_music"]:setText(hVar.tab_string["music_off"])
			end
		else
			if _childUI["soundenable"] then
				_childUI["soundenable"]:loadsprite("misc/addition/sound_off.png")
			end
			if _childUI["btn_music"] then
				_childUI["btn_music"]:setText(hVar.tab_string["music_on"])
			end
		end
	end

	_CODE_SwitchLanguage = function(IsSwitch)
		if IsSwitch == 1 then
			for language,tChangeLanguage in pairs(_tChangeLanguageList) do
				if g_Cur_Language == language then
					local c1,c2,c3 = unpack(tChangeLanguage)
					g_Cur_Language = c1
					g_language_setting = c2
					CCUserDefault:sharedUserDefault():setIntegerForKey("xl_language",g_language_setting)
					CCUserDefault:sharedUserDefault():flush()
					hApi.ChangeLanguage()
					break
				end
			end
		end
		if _childUI["languageFlag"] then
			tChangeLanguage = _tChangeLanguageList[g_Cur_Language]
			if type(tChangeLanguage) == "table" then
				_childUI["languageFlag"]:loadsprite(tChangeLanguage[3])
			end
			if g_Cur_Language==1 then
				hGlobal.event:event("LocalEvent_HideTacticsHelpUnit",0)
			else
				hGlobal.event:event("LocalEvent_HideTacticsHelpUnit",1)
			end
		end
	end

	_CODE_SwitchScreenMode = function(IsSwitch)
		if IsSwitch == 1 then
			g_CurScreenMode = (g_CurScreenMode % #_tScreenMode) + 1
			if _tScreenMode[g_CurScreenMode] then
				CCUserDefault:sharedUserDefault():setIntegerForKey("xl_screenmode",g_CurScreenMode)
				CCUserDefault:sharedUserDefault():flush()
				hApi.ChangeScreenMode()
			end
		end
		if _childUI["btn_screenlab"] then
			_childUI["btn_screenlab"]:loadsprite(_tScreenMode[g_CurScreenMode][2])
		end
		if _childUI["btn_screen"] then
			_childUI["btn_screen"]:setText(hVar.tab_string[_tScreenMode[g_CurScreenMode][1]])
		end
	end
	
	_CODE_SwitchView = function(IsSwitch)
		if IsSwitch == 1 then
			g_CurViewMode = (g_CurViewMode % #_tViewList) + 1
			if _tViewList[g_CurViewMode] then
				CCUserDefault:sharedUserDefault():setIntegerForKey("xl_viewmode",g_CurViewMode)
				CCUserDefault:sharedUserDefault():flush()
				m_fScale = _tViewList[g_CurViewMode][2]
				hApi.ResetViewMode()
			end
		end
		if _childUI["btn_viewlab"] and _childUI["btn_viewlab"].childUI["lab"] then
			_childUI["btn_viewlab"].childUI["lab"]:setText(hVar.tab_string[_tViewList[g_CurViewMode][1]])
		end
	end
	
	--战车显血开关
	_CODE_SwitchTankHpBar = function(flag)
		CCUserDefault:sharedUserDefault():setIntegerForKey("xl_tankhpbar", flag)
	end
	
	_CODE_CreateBtn = function(key,x,y)
		if key == "sound" then
			_childUI["btn_music"] = hUI.button:new({
				parent = _parent,
				model = "misc/addition/cg.png",
				dragbox = _childUI["dragBox"],
				label = {text = hVar.tab_string["music_on"],size = 28,y= 4,height = 36,font = hVar.FONTC,},
				scaleT = 0.95,
				x = x,
				y = y,
				w = 200,
				h = 56,
				--scale = 0.95,
				code = function(self)
					_CODE_SwitchSoundEnable(1)
					_CODE_RepaintFrm()
				end,
			})
			
			--声音图标
			_childUI["soundenable"] = hUI.button:new({
				parent = _parent,
				model = "misc/addition/sound_on.png",
				dragbox = _childUI["dragBox"],
				--icon = "UI:shopitemxg",
				--iconWH = 68,
				dragbox = _frm.childUI["dragBox"],
				x = x + 156,
				y = y,
				code = function(self)
					_CODE_SwitchSoundEnable(1)
					_CODE_RepaintFrm()
				end,
			})
		elseif key == "language" then
			--语言按钮
			_childUI["btn_language"] = hUI.button:new({
				parent = _parent,
				model = "misc/addition/cg.png",
				dragbox = _childUI["dragBox"],
				label = {text = hVar.tab_string["language_setting"],size = 28,y= 4,height = 36,font = hVar.FONTC,},
				scaleT = 0.95,
				x = x,
				y = y,
				w = 200,
				h = 56,
				--scale = 0.95,
				code = function(self)
					_CODE_SwitchLanguage(1)
					_CODE_RepaintFrm()
				end,
			})
			
			--语言图标
			_childUI["languageFlag"] = hUI.button:new({
				parent = _parent,
				model = "misc/language_sc.png",
				dragbox = _childUI["dragBox"],
				--icon = "UI:shopitemxg",
				--iconWH = 68,
				x = x + 156,
				y = y,
				code = function(self)
					_CODE_SwitchLanguage(1)
					_CODE_RepaintFrm()
				end,
			})
		elseif key == "screen" then
			--锁屏按钮
			_childUI["btn_screen"] = hUI.button:new({
				parent = _parent,
				model = "misc/addition/cg.png",
				dragbox = _childUI["dragBox"],
				label = {text = hVar.tab_string["screen_setting"],size = 28,y= 4,height = 36,font = hVar.FONTC,},
				scaleT = 0.95,
				x = x,
				y = y,
				w = 200,
				h = 56,
				--scale = 0.95,
				code = function(self)
					_CODE_SwitchScreenMode(1)
					_CODE_RepaintFrm()
				end,
			})

			_childUI["btn_screenlab"] = hUI.button:new({
				parent = _parent,
				model = _tScreenMode[2][2],
				--model = "misc/mask.png",
				dragbox = _childUI["dragBox"],
				x = x + 156,
				y = y,
				code = function(self)
					_CODE_SwitchScreenMode(1)
					_CODE_RepaintFrm()
				end,
			})
		elseif key == "back" then
			_childUI["btnback"] = hUI.button:new({
				parent = _parent,
				model = "misc/addition/cg.png",
				dragbox = _childUI["dragBox"],
				label = {text = hVar.tab_string["leave"],size = 28,y= 4,height = 36,font = hVar.FONTC,},
				x = x,
				y = y,
				w = 200,
				h = 56,
				scaleT = 0.95,
				code = function()
					local diablodata = hGlobal.LocalPlayer.data.diablodata
					if diablodata and type(diablodata.randMap) == "table" then
						--存档
						LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
						
						--关闭同步日志文件
						hApi.SyncLogClose()
						--关闭非同步日志文件
						hApi.AsyncLogClose()
						
						--隐藏可能的选人界面
						if hGlobal.UI.PhoneSelectedHeroFrm2 then
							hGlobal.UI.PhoneSelectedHeroFrm2:show(0)
							hGlobal.UI.PhoneSelectedHeroFrmBG.handle.s:setVisible(false) --隐藏背景框挡板
							hApi.clearTimer("__SELECT_HERO_UPDATE__")
							hApi.clearTimer("__SELECT_TOWER_UPDATE__")
							hApi.clearTimer("__SELECT_TACTIC_UPDATE__")
						end

						local tInfos = {
							{"lifecount",0},
						}
						LuaSetPlayerRandMapInfos(g_curPlayerName,tInfos)

						local bResult = false
						TD_OnGameOver_Diablo(bResult)
						
						--大菠萝游戏结束,刷新界面
						local nResult = 0
						hGlobal.event:event("LocalEvent_GameOver_Diablo", nResult)
						
						_CODE_ClearFunc()
						
						return
					end
					
					--清空随机迷宫缓存信息（防止闪退记录的第n-1小关的进度信息）
					if (hGlobal.WORLD.LastWorldMap ~= nil) then
						if (hGlobal.WORLD.LastWorldMap.data.map == hVar.RandomMap) then
							--直接离开
							LuaClearRandommapInfo(g_curPlayerName)
						end
					end
					
					--geyachao: 先存档
					--存档
					LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
					
					--关闭同步日志文件
					hApi.SyncLogClose()
					--关闭非同步日志文件
					hApi.AsyncLogClose()
					
					--隐藏可能的选人界面
					if hGlobal.UI.PhoneSelectedHeroFrm2 then
						hGlobal.UI.PhoneSelectedHeroFrm2:show(0)
						hGlobal.UI.PhoneSelectedHeroFrmBG.handle.s:setVisible(false) --隐藏背景框挡板
						hApi.clearTimer("__SELECT_HERO_UPDATE__")
						hApi.clearTimer("__SELECT_TOWER_UPDATE__")
						hApi.clearTimer("__SELECT_TACTIC_UPDATE__")
					end

					--zhenkira 注释
					local currentMapMode = hVar.MAP_TD_TYPE.NORMAL
					if (hGlobal.WORLD.LastWorldMap ~= nil) then
						--存储地图模式
						currentMapMode = hGlobal.WORLD.LastWorldMap.data.tdMapInfo and (hGlobal.WORLD.LastWorldMap.data.tdMapInfo.mapMode)
						
						local mapname = hGlobal.WORLD.LastWorldMap.data.map
						hGlobal.WORLD.LastWorldMap:del()
						
						hGlobal.LocalPlayer:setfocusworld(nil)
						hApi.clearCurrentWorldScene()
					end
					
					--大菠萝数据初始化
					hGlobal.LocalPlayer.data.diablodata =
					{
						bind_weapon = 0, --绑定的武器typeId
						score = 0, --得分
						lifecount = hVar.DEFAULT_LIFT_NUM, --命数量
						canbuylife = hVar.CAN_BUY_LIFE_NUM,--可以购买命的数量 
						deathcount = 0, --死亡次数
						deathscore = 0, --第一次死亡的得分
						tankbuffs = {}, --坦克的buff
						tankweaponbuffs = {}, --坦克的武器buff
						heros = {}, --坦克的英雄数据
					}
					
					--切换到配置坦克地图
					local mapname = hVar.MainBase
					local MapDifficulty = 0
					local MapMode = hVar.MAP_TD_TYPE.TANKCONFIG --配置坦克模式
					xlScene_LoadMap(g_world, mapname,MapDifficulty,MapMode)
					
					_CODE_ClearFunc()
				end,
			})

			_childUI["btn_backbg"] = hUI.button:new({
				parent = _parent,
				model = "misc/icon_backb.png",
				dragbox = _childUI["dragBox"],
				x = x + 156,
				y = y,
				scale = 0.8,
				code = function(self)
					_childUI["btnback"].data.code()
				end,
			})
		elseif key == "view" then
			_childUI["btn_view"] = hUI.button:new({
				parent = _parent,
				model = "misc/addition/cg.png",
				dragbox = _childUI["dragBox"],
				label = {text = hVar.tab_string["gameperspective"],size = 28,y= 4,height = 36,font = hVar.FONTC,},
				scaleT = 0.95,
				x = x,
				y = y,
				w = 200,
				h = 56,
				--scale = 0.95,
				code = function(self)
					_CODE_SwitchView(1)
					_CODE_RepaintFrm()
				end,
			})
			
			_childUI["btn_viewlab"] = hUI.button:new({
				parent = _parent,
				model = "misc/button_null.png",
				dragbox = _childUI["dragBox"],
				x = x + 156,
				y = y,
				code = function(self)
					_childUI["btn_view"].data.code()
				end,
			})
			_childUI["btn_viewlab"].childUI["lab"] = hUI.label:new({
				parent = _childUI["btn_viewlab"].handle._n,
				text = hVar.tab_string[_tViewList[1][1]],
				size = 24,
				font = hVar.FONTC,
				align = "MC",
			})
		elseif key == "reset" then
			--锁屏按钮
			_childUI["btn_reset"] = hUI.button:new({
				parent = _parent,
				model = "misc/addition/cg.png",
				dragbox = _childUI["dragBox"],
				label = {text = "全新游戏",size = 28,y= 4,height = 36,font = hVar.FONTC,},
				scaleT = 0.95,
				x = x,
				y = y,
				w = 200,
				h = 56,
				--scale = 0.95,
				code = function(self)
					hGlobal.event:event("LocalEvent_ShowNewGameDataFrm")
				end,
			})
		elseif key == "returnlogin" then
			_childUI["btnback"] = hUI.button:new({
				parent = _parent,
				model = "misc/addition/cg.png",
				dragbox = _childUI["dragBox"],
				label = {text = hVar.tab_string["returnlogin"],size = 28,y= 4,height = 36,font = hVar.FONTC,},
				x = x,
				y = y,
				w = 200,
				h = 56,
				scaleT = 0.95,
				code = function()
					_CODE_ClearFunc()
					hUI.NetDisable(9999)
					g_isReconnection = 0
					g_doLoginOut = 1
					local uid = xlPlayer_GetUID()
					GluaSendNetCmd[hVar.ONLINECMD.CMD_LOGIN_OUT](uid)
					
				end
			})
		elseif key == "login" then
			_childUI["btnback"] = hUI.button:new({
				parent = _parent,
				model = "misc/addition/cg.png",
				dragbox = _childUI["dragBox"],
				label = {text = hVar.tab_string["leave"],size = 28,y= 4,height = 36,font = hVar.FONTC,},
				x = x,
				y = y,
				w = 200,
				h = 56,
				scaleT = 0.95,
				code = function()
					--[[
					local diablodata = hGlobal.LocalPlayer.data.diablodata
					if diablodata and type(diablodata.randMap) == "table" then
						--存档
						LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
						
						--关闭同步日志文件
						hApi.SyncLogClose()
						--关闭非同步日志文件
						hApi.AsyncLogClose()
						
						--隐藏可能的选人界面
						if hGlobal.UI.PhoneSelectedHeroFrm2 then
							hGlobal.UI.PhoneSelectedHeroFrm2:show(0)
							hGlobal.UI.PhoneSelectedHeroFrmBG.handle.s:setVisible(false) --隐藏背景框挡板
							hApi.clearTimer("__SELECT_HERO_UPDATE__")
							hApi.clearTimer("__SELECT_TOWER_UPDATE__")
							hApi.clearTimer("__SELECT_TACTIC_UPDATE__")
						end

						local tInfos = {
							{"lifecount",0},
						}
						LuaSetPlayerRandMapInfos(g_curPlayerName,tInfos)

						local bResult = false
						TD_OnGameOver_Diablo(bResult)
						
						--大菠萝游戏结束,刷新界面
						local nResult = 0
						hGlobal.event:event("LocalEvent_GameOver_Diablo", nResult)

						_CODE_ClearFunc()

						return
					end
					--geyachao: 先存档
					--存档
					LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
					
					--关闭同步日志文件
					hApi.SyncLogClose()
					--关闭非同步日志文件
					hApi.AsyncLogClose()
					
					--隐藏可能的选人界面
					if hGlobal.UI.PhoneSelectedHeroFrm2 then
						hGlobal.UI.PhoneSelectedHeroFrm2:show(0)
						hGlobal.UI.PhoneSelectedHeroFrmBG.handle.s:setVisible(false) --隐藏背景框挡板
						hApi.clearTimer("__SELECT_HERO_UPDATE__")
						hApi.clearTimer("__SELECT_TOWER_UPDATE__")
						hApi.clearTimer("__SELECT_TACTIC_UPDATE__")
					end

					--zhenkira 注释
					local currentMapMode = hVar.MAP_TD_TYPE.NORMAL
					if (hGlobal.WORLD.LastWorldMap ~= nil) then
						--存储地图模式
						currentMapMode = hGlobal.WORLD.LastWorldMap.data.tdMapInfo and (hGlobal.WORLD.LastWorldMap.data.tdMapInfo.mapMode)
						
						local mapname = hGlobal.WORLD.LastWorldMap.data.map
						hGlobal.WORLD.LastWorldMap:del()
						
						hGlobal.LocalPlayer:setfocusworld(nil)
						hApi.clearCurrentWorldScene()
					end
					
					--大菠萝数据初始化
					hGlobal.LocalPlayer.data.diablodata =
					{
						bind_weapon = 0, --绑定的武器typeId
						score = 0, --得分
						lifecount = hVar.DEFAULT_LIFT_NUM, --命数量
						canbuylife = hVar.CAN_BUY_LIFE_NUM,--可以购买命的数量 
						deathcount = 0, --死亡次数
						deathscore = 0, --第一次死亡的得分
						tankbuffs = {}, --坦克的buff
						tankweaponbuffs = {}, --坦克的武器buff
						heros = {}, --坦克的英雄数据
					}
					
					--切换到login地图
					
					local __MAPDIFF = 0
					local __MAPMODE = hVar.MAP_TD_TYPE.NORMAL
					local mapName = hVar.LoginMap --"world/csys_ex_002_randommap"
					hGlobal.LocalPlayer.data.diablodata = LuaInitDiabloData()
					xlScene_LoadMap(g_world, mapName,__MAPDIFF,__MAPMODE)
					]]
					
					_CODE_ClearFunc()
					
					--切换到login地图
					hGlobal.event:event("LocalEvent_new_mainmenu_frm", 1)
				end,
			})
			
			--[[
			_childUI["btn_backbg"] = hUI.button:new({
				parent = _parent,
				model = "misc/icon_backb.png",
				dragbox = _childUI["dragBox"],
				x = x + 156,
				y = y,
				scale = 0.8,
				code = function(self)
					_childUI["btnback"].data.code()
				end,
			})
			]]
		elseif key == "hpbar" then --战车血条
			_childUI["btnhpbar"] = hUI.button:new({
				parent = _parent,
				model = "misc/addition/cg.png",
				dragbox = _childUI["dragBox"],
				label = {text = hVar.tab_string["tankshowhpbar"],size = 28,y= 4,height = 36,font = hVar.FONTC,}, --"战车显血"
				x = x,
				y = y,
				w = 200,
				h = 56,
				scaleT = 0.95,
				code = function()
					hVar.OPTIONS.SHOW_TANK_HP_FLAG = 1 - hVar.OPTIONS.SHOW_TANK_HP_FLAG
					
					_CODE_SwitchTankHpBar(hVar.OPTIONS.SHOW_TANK_HP_FLAG)
					
					if (hVar.OPTIONS.SHOW_TANK_HP_FLAG == 1) then
						_childUI["btnhpbar_lab"].childUI["lab"]:setText(hVar.tab_string["__TEXT_Open_Short"]) --"开"
					else
						_childUI["btnhpbar_lab"].childUI["lab"]:setText(hVar.tab_string["__TEXT_Close_Short"]) --"关"
					end
				end,
			})
			
			_childUI["btnhpbar_lab"] = hUI.button:new({
				parent = _parent,
				model = "misc/button_null.png",
				dragbox = _childUI["dragBox"],
				x = x + 156,
				y = y,
				code = function(self)
					_childUI["btnhpbar"].data.code()
				end,
			})
			_childUI["btnhpbar_lab"].childUI["lab"] = hUI.label:new({
				parent = _childUI["btnhpbar_lab"].handle._n,
				text = "",
				size = 24,
				font = hVar.FONTC,
				align = "MC",
			})
			if (hVar.OPTIONS.SHOW_TANK_HP_FLAG == 1) then
				_childUI["btnhpbar_lab"].childUI["lab"]:setText(hVar.tab_string["__TEXT_Open_Short"]) --"开"
			else
				_childUI["btnhpbar_lab"].childUI["lab"]:setText(hVar.tab_string["__TEXT_Close_Short"]) --"关"
			end
		elseif key == "giftcode" then --礼品码
			_childUI["btngiftcode"] = hUI.button:new({
				parent = _parent,
				model = "misc/addition/cg.png",
				dragbox = _childUI["dragBox"],
				label = {text = hVar.tab_string["__TEXT_GiftCode"],size = 28,y= 4,height = 36,font = hVar.FONTC,}, --"礼包兑换"
				x = x,
				y = y,
				w = 200,
				h = 56,
				scaleT = 0.95,
				code = function()
					--关闭本界面
					if _frm then
						_frm:show(0)
					end
					
					--弹出礼品码界面
					local callback = function()
						if _frm then
							_frm:show(1)
						end
					end
					hGlobal.event:event("LocalEvent_ShowWithdrawGiftFrm", callback)
				end,
			})
		end
	end

	local _code_clearMap = function()
		--隐藏菜单
		hGlobal.event:event("Event_StartPauseSwitch", false)
		
		_CODE_ClearFunc()
		
		local w = hGlobal.WORLD.LastWorldMap
		if w then
			if w.data.map == hVar.MainBase then
				LuaSetPlayerMapAchi("world/yxys_spider_04",hVar.ACHIEVEMENT_TYPE.LEVEL,1)
				LuaSetPlayerMapAchi("world/yxys_airship_04",hVar.ACHIEVEMENT_TYPE.LEVEL,1)
				LuaSetPlayerMapAchi("world/yxys_zerg_004",hVar.ACHIEVEMENT_TYPE.LEVEL,1)
				LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
				hGlobal.event:event("LocalEvent_DelUnit","petarea")
				hGlobal.event:event("LocalEvent_DelUnit","tacticsarea")
				hGlobal.event:event("LocalEvent_DelUnit","entertainmentarea")
				hGlobal.event:event("LocalEvent_DelUnit","entertainmentarea2")
				_nUnlockviparea = 1
				local keyList = {"map"}
				LuaSavePlayerData_Android_Upload(keyList, "作弊一键通关")
				return
			end
			
			if (w.data.map == hVar.GuideMap) then
				--弹出二选一的操作界面
				hApi.ShowSelectMsgBox(2, {text = hVar.tab_string["__TEXT_BLACK_DRAGON_4"], size = 28, tomap = "world/yxys_spider_01", tomapmode = hVar.MAP_TD_TYPE.NORMAL,}, {text = hVar.tab_string["__TEXT_BLACK_DRAGON_5"], size = 28, tomap = hVar.MainBase, tomapmode = hVar.MAP_TD_TYPE.TANKCONFIG,})
				return
			end
		end
		
		--冒字
		local strText = "直接通关！"
		hUI.floatNumber:new({
			x = hVar.SCREEN.w / 2,
			y = hVar.SCREEN.h / 2,
			align = "MC",
			text = "",
			lifetime = 2000,
			fadeout = -550,
			moveY = 32,
		}):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)
		
		hApi.addTimerForever("__CHECK_SUCCESS_TIMER__", hVar.TIMER_MODE.GAMETIME, 100, function()
			--快速游戏结束
			local w = hGlobal.WORLD.LastWorldMap
			
			--如果游戏暂停，直接跳出循环
			if w then
				if (w.data.IsPaused == 1) then
					return
				end
				
				hApi.clearTimer("__CHECK_SUCCESS_TIMER__")
				
				--直接胜利
				local mapInfo = w.data.tdMapInfo
				if mapInfo then
					--mapInfo.mapState = hVar.MAP_TD_STATE.FAILED
					mapInfo.mapState = hVar.MAP_TD_STATE.SUCCESS
				end
				
				--给英雄加经验值
				if Save_PlayerData and Save_PlayerData.herocard then
					for i = 1, #Save_PlayerData.herocard, 1 do
						local id = Save_PlayerData.herocard[i].id
					end
				end
				
				--存档
				LuaSaveHeroCard()
			end
		end)
	end
	
	_CODE_CreatePassGuideMap = function()
		local oWorld = hGlobal.WORLD.LastWorldMap
		if oWorld and oWorld.data.map == hVar.GuideMap then
			local offX = hVar.SCREEN.w/2
			local offY = -hVar.SCREEN.h/2 - _boardH/2 + 30
			
			_childUI["btn_passguidemap"] = hUI.button:new({
				parent = _parent,
				model = "misc/button_null.png",
				dragbox = _childUI["dragBox"],
				x = offX,
				y = offY,
				w = 200,
				h = 60,
				--scale = 0.95,
				code = function(self)
					if _startTime == 0 then
						_startTime = os.clock()
						_clickCount = 1
						return
					else
						local curTime = os.clock()
						if curTime - _startTime < 10 then
							_clickCount =  _clickCount + 1
						else
							--重置
							_startTime = os.clock()
							_clickCount = 1
						end
						print(_startTime,curTime,_clickCount)
						if _clickCount == 12 then
							_startTime = 0
							_clickCount = 0
							hGlobal.UI.MsgBox("passguide", {
								font = hVar.FONTC,
								ok = function()
									_code_clearMap()
									--self:setstate(1)
								end,
							})
						end
					end
					--_clickCount = 0
				end
			})
		end
	end
	
	_CODE_CreateCheatUI = function()
		hApi.safeRemoveT(_childUI,"btn_passguidemap")
		local offX = hVar.SCREEN.w/2
		local offY = -hVar.SCREEN.h/2 - _boardH/2 - 60
		_childUI["btn_clear"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png",
			dragbox = _childUI["dragBox"],
			label = {text = hVar.tab_string["clearance"],size = 24,y= 4,height = 36,font = hVar.FONTC,},
			scaleT = 0.95,
			x = offX - _boardW/2 + 50,
			y = offY,
			w = 80,
			h = 56,
			--scale = 0.95,
			code = function(self)
				_code_clearMap()
			end,
		})
		
		_childUI["btn_buff"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png",
			dragbox = _childUI["dragBox"],
			label = {text = "增强",size = 24,y= 4,height = 36,font = hVar.FONTC,},
			scaleT = 0.95,
			x = offX - _boardW/2 + 50 + 120 * 1,
			y = offY,
			w = 80,
			h = 56,
			--scale = 0.95,
			code = function(self)
				hGlobal.event:event("LocalEvent_CheatAddAllBuff")
			end,
		})
		
		_childUI["btn_cheatmanager"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png",
			dragbox = _childUI["dragBox"],
			label = {text = "作弊管理",size = 24,y= 4,height = 60,font = hVar.FONTC,},
			scaleT = 0.95,
			x = offX - _boardW/2 + 50 + 120 * 2,
			y = offY,
			w = 80,
			h = 56,
			--scale = 0.95,
			code = function(self)
				hGlobal.event:event("LocalEvent_ShowCheatManagerFrm")
			end,
		})
		
		_childUI["btn_Announcement"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png",
			dragbox = _childUI["dragBox"],
			label = {text = "公告测试",size = 24,y= 4,align = "MC",width = 60,height = 80,font = hVar.FONTC,},
			scaleT = 0.95,
			x = offX - _boardW/2 + 70,
			y = offY + 120,
			w = 80,
			h = 56,
			--scale = 0.95,
			code = function(self)
				hApi.RequestTestAnnouncement()
			end,
		})
		
		_childUI["btn_debug"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png",
			dragbox = _childUI["dragBox"],
			label = {text = "调试",size = 24,y= 4,height = 60,font = hVar.FONTC,},
			scaleT = 0.95,
			x = offX - _boardW/2 + 50 + 120 * 3,
			y = offY,
			w = 80,
			h = 56,
			--scale = 0.95,
			code = function(self)
				if (self.data.nIsShowDebug == 0) then
					--打开调试
					self.data.nIsShowDebug = 1
					
					OpenFlag()
					
					self.childUI["label"]:setText("调试(开)")
					self.childUI["label"].handle.s:setColor(ccc3(0, 255, 0))
					
					_childUI["playaction"]:setstate(1)
					_childUI["camerascroll_add"]:setstate(1)
					_childUI["camerascroll_minus"]:setstate(1)
				else
					--关闭调试
					self.data.nIsShowDebug = 0
					
					CloseFlag()
					
					self.childUI["label"]:setText("调试(关)")
					self.childUI["label"].handle.s:setColor(ccc3(255, 0, 0))
					
					_childUI["playaction"]:setstate(-1)
					_childUI["camerascroll_add"]:setstate(-1)
					_childUI["camerascroll_minus"]:setstate(-1)
				end
			end,
		})
		_childUI["btn_debug"].data.nIsShowDebug = 0

		-- TODO: 分享按钮
		_childUI["btn_share"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png",
			dragbox = _childUI["dragBox"],
			label = {text = "分享测试",size = 24,y= 4,height = 60,font = hVar.FONTC,},
			scaleT = 0.95,
			x = offX - _boardW/2 + 50 + 120 * 4,
			y = offY,
			w = 80,
			h = 56,
			--scale = 0.95,
			code = function(self)
				print("测试分享")
				
				hGlobal.event:event("LocalEvent_ShowShareWindow", hVar.ShareType.WechatFriends, "data/image/misc/share/sharetacticsbg12029.png")
				-- hGlobal.event:event("LocalEvent_CloseShareWindow")
			end,
		})
		
		_childUI["playaction"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png",
			dragbox = _childUI["dragBox"],
			label = {text = "动画",size = 24,y= 4,height = 36,font = hVar.FONTC,},
			scaleT = 0.95,
			x = offX - _boardW/2 + 80,
			y = offY + _boardH - 80,
			w = 80,
			h = 60,
			--scale = 0.95,
			code = function(self)
				--隐藏菜单
				hGlobal.event:event("Event_StartPauseSwitch", false)
				
				local oWorld = hGlobal.WORLD.LastWorldMap
				oWorld:removetimer("__TD__Camera_Follow_")
				
				hApi.addTimerForever("__CHECK_SUCCESS_TIMER__", hVar.TIMER_MODE.GAMETIME, 100, function()
					hApi.clearTimer("__CHECK_SUCCESS_TIMER__")
					
					--开场动画
					local oUnit = oWorld:GetPlayerMe().heros[1]:getunit() --玩家的第一个英雄
					
					--释放技能
					local targetX, targetY = hApi.chaGetPos(oUnit.handle) --目标的位置
					local gridX, gridY = oWorld:xy2grid(targetX, targetY)
					local skillId = 16004 --开场动画技能
					local skillLv = 1
					local tCastParam = {level = skillLv,}
					hApi.CastSkill(oUnit, skillId, 0, nil, nil, gridX, gridY, tCastParam)
				end)
				
				_CODE_ClearFunc()
			end,
		})
		
		_childUI["camerascroll_add"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png",
			dragbox = _childUI["dragBox"],
			label = {text = "镜头+",size = 24,y= 4,height = 36,font = hVar.FONTC,},
			scaleT = 0.95,
			x = offX - _boardW/2 + 80,
			y = offY + _boardH - 80 * 2,
			w = 80,
			h = 60,
			--scale = 0.95,
			code = function(self)
				m_fScale = m_fScale + 0.1
				xlView_SetScale(m_fScale)
			end
		})
		
		_childUI["camerascroll_minus"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png",
			dragbox = _childUI["dragBox"],
			label = {text = "镜头-",size = 24,y= 4,height = 36,font = hVar.FONTC,},
			scaleT = 0.95,
			x = offX - _boardW/2 + 80,
			y = offY + _boardH - 80 * 3,
			w = 80,
			h = 60,
			--scale = 0.95,
			code = function(self)
				if (m_fScale > 0) then
					m_fScale = m_fScale - 0.1
					xlView_SetScale(m_fScale)
				end
			end
		})
		
		_childUI["playaction"]:setstate(-1)
		_childUI["camerascroll_add"]:setstate(-1)
		_childUI["camerascroll_minus"]:setstate(-1)
		
		--摇杆方向
		_childUI["btn_vc_dirnum"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png",
			dragbox = _childUI["dragBox"],
			label = {text = "摇杆[" .. hVar.OPTIONS.VIRTUAL_CONTROL_DIRNUM .. "]",size = 24,y= 4,height = 60,font = hVar.FONTC,},
			scaleT = 0.95,
			x = offX - _boardW/2 + 50 + 120 * 0,
			y = offY - 100,
			w = 80,
			h = 56,
			--scale = 0.95,
			code = function(self)
				hVar.OPTIONS.VIRTUAL_CONTROL_DIRNUM = hVar.OPTIONS.VIRTUAL_CONTROL_DIRNUM / 2
				if (hVar.OPTIONS.VIRTUAL_CONTROL_DIRNUM < 8) then
					hVar.OPTIONS.VIRTUAL_CONTROL_DIRNUM = 32
				end
				_childUI["btn_vc_dirnum"].childUI["label"]:setText("摇杆[" .. hVar.OPTIONS.VIRTUAL_CONTROL_DIRNUM .. "]")
			end,
		})
		
		--战车血条
		_childUI["btn_tank_hp"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png",
			dragbox = _childUI["dragBox"],
			label = {text = "战车血条",size = 24,y= 4,height = 60,font = hVar.FONTC,},
			scaleT = 0.95,
			x = offX - _boardW/2 + 50 + 120 * 1,
			y = offY - 100,
			w = 80,
			h = 56,
			--scale = 0.95,
			code = function(self)
				hVar.OPTIONS.SHOW_TANK_HP_FLAG = 1 - hVar.OPTIONS.SHOW_TANK_HP_FLAG
				
				if (hVar.OPTIONS.SHOW_TANK_HP_FLAG == 1) then
					_childUI["btn_tank_hp"].childUI["label"].handle.s:setColor(ccc3(0, 255, 0))
				else
					_childUI["btn_tank_hp"].childUI["label"].handle.s:setColor(ccc3(255, 255, 255))
				end
			end,
		})
		if (hVar.OPTIONS.SHOW_TANK_HP_FLAG == 1) then
			_childUI["btn_tank_hp"].childUI["label"].handle.s:setColor(ccc3(0, 255, 0))
		else
			_childUI["btn_tank_hp"].childUI["label"].handle.s:setColor(ccc3(255, 255, 255))
		end
		
		--固定摇杆
		_childUI["btn_vc_move"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png",
			dragbox = _childUI["dragBox"],
			label = {text = "",size = 24,y= 4,height = 60,font = hVar.FONTC,},
			scaleT = 0.95,
			x = offX - _boardW/2 + 50 + 120 * 2,
			y = offY - 100,
			w = 80,
			h = 56,
			--scale = 0.95,
			code = function(self)
				hVar.OPTIONS.VIRTUAL_CONTROL_MOVE = 1 - hVar.OPTIONS.VIRTUAL_CONTROL_MOVE
				
				if (hVar.OPTIONS.VIRTUAL_CONTROL_MOVE == 1) then
					_childUI["btn_vc_move"].childUI["label"]:setText("跟随摇杆")
					_childUI["btn_vc_move"].childUI["label"].handle.s:setColor(ccc3(0, 255, 0))
				else
					_childUI["btn_vc_move"].childUI["label"]:setText("固定摇杆")
					_childUI["btn_vc_move"].childUI["label"].handle.s:setColor(ccc3(255, 255, 255))
				end
			end,
		})
		if (hVar.OPTIONS.VIRTUAL_CONTROL_MOVE == 1) then
			_childUI["btn_vc_move"].childUI["label"]:setText("跟随摇杆")
			_childUI["btn_vc_move"].childUI["label"].handle.s:setColor(ccc3(0, 255, 0))
		else
			_childUI["btn_vc_move"].childUI["label"]:setText("固定摇杆")
			_childUI["btn_vc_move"].childUI["label"].handle.s:setColor(ccc3(255, 255, 255))
		end
	end
	
	_CODE_RepaintFrm = function()
		_CODE_ClearFunc()
		_CODE_CreateFrm()
		_CODE_CreateUI()
	end
	
	_CODE_CreateUI = function()
		local list = {}
		local oWorld = hGlobal.WORLD.LastWorldMap
		--list = {"sound","language","view","screen","back"}
		list = {"sound","view","screen","hpbar","back",}
		
		--引导图
		if oWorld and (oWorld.data.map == hVar.GuideMap) then
			--list = {"sound","language","view","screen","reset"}
			--list = {"sound","language","view","screen",}
			--list = {"sound","view","screen","login",}
			list = {"sound","view","screen",}
			if g_OBSwitch.delAccount == 1 then
				list = {"sound","view","screen","login",}
			end
		end
		
		--主基地图
		if oWorld and (oWorld.data.map == hVar.MainBase) then
			--list = {"sound","language","view","screen","reset"}
			--list = {"sound","language","view","screen",}
			list = {"sound","view","screen",}
			if g_OBSwitch.lipinma == 1 then
				list[#list+1] = "giftcode"
			end
			if g_OBSwitch.delAccount == 1 then
				list[#list+1] = "returnlogin"
			end
		end
		
		local offX = hVar.SCREEN.w/2
		local offY = -hVar.SCREEN.h/2 + _boardH/2 - 40
		local num = #list
		local offh = (_boardH - 90)/num
		if num == 5 then
			offY = -hVar.SCREEN.h/2 + _boardH/2 - 30
		elseif num == 4 then
			offY = -hVar.SCREEN.h/2 + _boardH/2 - 36
			--offh = 100
		elseif num == 6 then
			offY = -hVar.SCREEN.h/2 + _boardH/2 - 20
			--offh = 100
		elseif num == 3 then
			offY = -hVar.SCREEN.h/2 + _boardH/2 - 64
			offh = 114
		end
		for i = 1,num do
			local x = offX
			local y = offY - (i-1) * offh - 40
			local key = list[i]
			_CODE_CreateBtn(key,x,y)
		end
		
		if (g_lua_src == 1) or (g_is_account_test == 2) then
			if hVar.ShowGMUI == 1 then
				_CODE_CreateCheatUI()
			end
		else
			_CODE_CreatePassGuideMap()
		end
		
		_CODE_SwitchSoundEnable()
		_CODE_SwitchLanguage()
		_CODE_SwitchScreenMode()
		_CODE_SwitchView()
	end
	
	_CODE_CreateFrm = function()
		hGlobal.UI.SystemMenuIntegrateFrm = hUI.frame:new({
			x = 0,
			y = hVar.SCREEN.h,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			dragable = 2,
			show = 0,
			border = 0,
			background = -1,
			z = hZorder.SetFrm,
		})
		
		_frm = hGlobal.UI.SystemMenuIntegrateFrm
		_parent = _frm.handle._n
		_childUI = _frm.childUI
		
		local offX = hVar.SCREEN.w/2
		local offY = -hVar.SCREEN.h/2
		
		_childUI["closeBtn"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/skillup/btn_close.png",
			x = offX + _boardW/2 - 38,
			y = offY + _boardH/2 - 38,
			scaleT = 0.95,
			z = 2,
			code = function()
				hGlobal.event:event("LocalEvent_RecoverBarrage")
				hGlobal.event:event("Event_StartPauseSwitch", false)
				_CODE_ClearFunc()
			end,
		})
		
		_childUI["img_bg"] = hUI.image:new({
			parent = _parent,
			model = "misc/skillup/msgbox6.png",
			x = offX,
			y = offY,
			w = _boardW,
			h = _boardH,
			code = function()
				--print("技能tip图片背景")
			end,
		})
		
		if (g_is_account_test == 1) then --测试员
			_childUI["img_star1"] = hUI.image:new({
				parent = _parent,
				model = "ICON:WeekStar",
				x = offX - _boardW/2  + 70,
				y = offY + _boardH/2 - 36,
				w = 32,
				h = 32,
			})
		elseif (g_lua_src == 1) or (g_is_account_test == 2) then --源代码模式、管理员
			_childUI["btn_showGMUI"] = hUI.button:new({
				parent = _parent,
				model = "misc/button_null.png",
				dragbox = _childUI["dragBox"],
				x = offX,
				y = offY - _boardH/2 + 40,
				w = 160,
				h = 50,
				code = function()
					if hVar.ShowGMUI == 1 then
						hVar.ShowGMUI = 0
					else
						hVar.ShowGMUI = 1
					end
					_CODE_RepaintFrm()
				end,
			})
			
			if hVar.ShowGMUI == 1 then
				_childUI["img_star1"] = hUI.image:new({
					parent = _parent,
					model = "ICON:WeekStar",
					x = offX - _boardW/2 + 70,
					y = offY + _boardH/2 - 36,
					w = 32,
					h = 32,
				})
				_childUI["img_star2"] = hUI.image:new({
					parent = _parent,
					model = "ICON:WeekStar",
					x = offX - _boardW/2 + 100,
					y = offY + _boardH/2 - 36,
					w = 32,
					h = 32,
				})
			end
		end
		
		local curVer = "V"
		local SOverInfo = hVar.CURRENT_ITEM_VERSION
		local PverInfo = tostring(xlGetExeVersion())
		local iChannelId = getChannelInfo()
		if type(PverInfo) == "string" then
			curVer = curVer..string.sub(PverInfo,2,4)
		end
		if type(SOverInfo) == "string" then
			curVer = curVer..string.sub(SOverInfo,4,string.len(SOverInfo)).. "     C"..tostring(iChannelId).."     ID"..xlPlayer_GetUID()
		end
		--curVer = "V031.091102    C1002     ID"..xlPlayer_GetUID()
		
		_childUI["programm_version"] = hUI.label:new({
			parent = _parent,
			size = 16,
			text = curVer,
			align = "MT",
			border = 1,
			x = offX,
			y = offY - _boardH/2 + 50,
			RGB = {128,128,128},
		})
		
		_frm:show(1)
		_frm:active()
	end
	
	hGlobal.event:listen("LocalEvent_SpinScreen","SystemMenuIntegrateFrm",function()
		if _frm and _frm.data.show == 1 then
			_CODE_RepaintFrm()
		end
	end)

	hGlobal.event:listen("CloseSystemMenuIntegrateFrm","closefrm",function()
		_CODE_ClearFunc()
	end)
	
	hGlobal.event:listen(tInitEventName[1], tInitEventName[2], function()
		hGlobal.event:event("Event_StartPauseSwitch", true)
		_CODE_ClearFunc()
		_CODE_CreateFrm()
		_CODE_CreateUI()
	end)
end


hGlobal.UI.InitNewGameDataFrm = function(mode)
	local tInitEventName = {"LocalEvent_ShowNewGameDataFrm", "_show",}
	if (mode ~= "include") then
		return tInitEventName
	end
	
	local _frm,_parent,_childUI = nil,nil,nil
	local _boardW,_boardH = 420,300
	
	local _CODE_ClearFunc = hApi.DoNothing
	local _CODE_CreateFrm = hApi.DoNothing
	local _CODE_CreateUI = hApi.DoNothing
	
	_CODE_ClearFunc = function()
		_frm,_parent,_childUI = nil,nil,nil
		if hGlobal.UI.NewGameDataFrm then
			hGlobal.UI.NewGameDataFrm:del()
			hGlobal.UI.NewGameDataFrm = nil
		end
	end
	
	_CODE_CreateUI = function()
		_childUI["lab_content"] = hUI.label:new({
			parent = _parent,
			text = "游戏数据将被重置！\n \n点击[确定]开始全新游戏",
			x = _boardW/2,
			y = - 108,
			align = "MC",
			size = 24,
			width = _boardW - 40,
			height = 100,
			border = 1,
			font = hVar.FONTC,
		})
		
		_childUI["btn_ok"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/addition/cg.png",
			font = hVar.FONTC,
			label = {text = "确定",size = 24,},
			x = _boardW /2 - 86,
			y = - 230,
			border = 1,
			scale = 0.8,
			w = 168,
			h = 60,
			align = "MC",
			scaleT = 0.9,
			code = function()
				if hGlobal.WORLD.LastWorldMap then
					
					--关闭同步日志文件
					hApi.SyncLogClose()
					--关闭非同步日志文件
					hApi.AsyncLogClose()
					
					--隐藏可能的选人界面
					if hGlobal.UI.PhoneSelectedHeroFrm2 then
						hGlobal.UI.PhoneSelectedHeroFrm2:show(0)
						hGlobal.UI.PhoneSelectedHeroFrmBG.handle.s:setVisible(false) --隐藏背景框挡板
						hApi.clearTimer("__SELECT_HERO_UPDATE__")
						hApi.clearTimer("__SELECT_TOWER_UPDATE__")
						hApi.clearTimer("__SELECT_TACTIC_UPDATE__")
					end

					if (hGlobal.WORLD.LastWorldMap ~= nil) then
						hGlobal.WORLD.LastWorldMap:del()
						
						hGlobal.LocalPlayer:setfocusworld(nil)
						hApi.clearCurrentWorldScene()
					end
				end

				hGlobal.event:event("CloseSystemMenuIntegrateFrm")

				xlDeleteFileWithFullPath(g_localfilepath..g_curPlayerName..hVar.SAVE_DATA_PATH.PLAYER_DATA)
				xlDeleteFileWithFullPath(g_localfilepath..g_curPlayerName..hVar.SAVE_DATA_PATH.PLAYER_LOG)

				local uid = xlPlayer_GetUID()
				local rid = luaGetplayerDataID()

				Save_PlayerData.userID = uid
				
				--初始化本地玩家名
				g_curPlayerName = "User"..tostring(uid)
				
				--UI刷新
				local playerInfo = {name = g_curPlayerName}
				LuaSwitchPlayer(playerInfo,rid)
				luaSetplayerDataID(rid)
				
				local playerInfo = LuaGetPlayerByName(g_curPlayerName)

				LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)

				local keyList = {"skill","card","map","bag", "material", "log",}
				LuaSavePlayerData_Android_Upload(keyList, "GM重置进度")

				SendCmdFunc["tank_cleardata"]()

				hGlobal.event:event("LocalEvent_EnterGame")

				_CODE_ClearFunc()
			end,
		})

		_childUI["btn_cannel"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/addition/cg.png",
			font = hVar.FONTC,
			label = {text = "取消",size = 24,},
			x = _boardW /2 + 86,
			y = - 230,
			border = 1,
			scale = 0.8,
			w = 168,
			h = 60,
			align = "MC",
			scaleT = 0.9,
			code = function()
				_CODE_ClearFunc()
			end,
		})
	end

	_CODE_CreateFrm = function()
		local nBoardX,nBoardY = hVar.SCREEN.w / 2 - _boardW / 2,hVar.SCREEN.h / 2 + _boardH / 2
		hGlobal.UI.NewGameDataFrm  = hUI.frame:new({
			x = nBoardX + 10,
			y = nBoardY - 20,
			w = _boardW,
			h = _boardH,
			background = "misc/skillup/msgbox4.png",
			closebtn = 0,
			dragable = 4,
			top = 1,
			show = 0,
			z = 1000000,
		})
		_frm = hGlobal.UI.NewGameDataFrm
		_parent = _frm.handle._n
		_childUI = _frm.childUI

		_CODE_CreateUI()

		_frm:show(1)
		_frm:active()
	end

	hGlobal.event:listen("LocalEvent_SpinScreen","NewGameDataFrm",function()
		if _frm and _frm.data.show == 1 then
			_CODE_ClearFunc()
			_CODE_CreateFrm()
		end
	end)

	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function()
		_CODE_ClearFunc()
		_CODE_CreateFrm()
	end)
end






--安卓的礼品码
--礼品码输入界面 脚本实现
hGlobal.UI.InitWithdrawGiftFrm = function(mode)
	local tInitEventName = {"LocalEvent_ShowWithdrawGiftFrm", "showIF",}
	if (mode ~= "include") then
		return tInitEventName
	end
	
	local _w,_h = 480,360
	local _x,_y = hVar.SCREEN.w/2 - _w/2,hVar.SCREEN.h/2 + _h/2
	local current_funcCallback = nil --关闭后的回调事件
	
	local _frm,_parent,_childUI = nil
	local _inputText = ""
	
	local _FrmChildUI = {
		{__UI="label",__NAME="Guild_Name",x=_w/2+20,y= -80,z=1,text=hVar.tab_string["__TEXT_Enter_Gift"],border=1,font=hVar.FONTC,size=32,align="MC",RGB = {255, 255, 255},},
		--礼物包图片
		{__UI="image",__NAME="giftImage",x=100,y=-80,w = 48,h=48,model="UI:GIFT"},
		--{__UI="image",__NAME="input_bg",x=_w/2,y=-_h/2,w=400,h=50,model="UI:login_xx"},
		--领取按钮
		{__UI="button",__NAME="rewardBtn",x=_w/2,y =-_h + 70,model = "misc/addition/cg.png",scaleT = 0.95, w = 240,
			h = 64,
			label = {text = hVar.tab_string["__TEXT__Exchange"],size = 32,y= 4,width = 240,height = 36,font = hVar.FONTC,}, --"礼包兑换"
			code = function()
				GluaSendNetCmd[hVar.ONLINECMD.CMD_GET_GIFT_REWARD](xlPlayer_GetUID(),luaGetplayerDataID(),_inputText)
				_frm:show(0)
			end
		},
	}
	
	hGlobal.UI.WithdrawGiftFrm = hUI.frame:new({
		x = _x,
		y = _y,
		w = _w,
		h = _h,
		dragable = 2,
		show = 0,
		--bgMode = "tile",
		background = "misc/skillup/msgbox4.png",--"UI:Tactic_Background_No_Top",
		border = 0,
		z = hZorder.SetFrm,
		--border = "UI:TileFrmBasic_thin",
		child = _FrmChildUI,
		
		--点击事件
		codeOnTouch = function(self, x, y, sus)
			--在外部点击
			if (sus == 0) then
				self.childUI["closeBtn"].data.code()
			end
		end,
	})
	
	_frm = hGlobal.UI.WithdrawGiftFrm
	_parent,_childUI = _frm.handle._n,_frm.childUI
	
	--背景底图
	_childUI["BG"] = hUI.image:new({
		parent = _parent,
		model = "misc/mask_white.png",
		x = 0,
		y = 0,
		z = -100,
		w = hVar.SCREEN.w * 2,
		h = hVar.SCREEN.h * 2,
	})
	_childUI["BG"].handle.s:setOpacity(88)
	_childUI["BG"].handle.s:setColor(ccc3(0, 0, 0))
	
	--关闭按钮
	_childUI["closeBtn"] = hUI.button:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		model = "misc/skillup/btn_close.png",
		x = _frm.data.w - 38,
		y = - 38,
		scaleT = 0.95,
		z = 2,
		code = function()
			_frm:show(0)
			
			--显示菜单界面
			--hGlobal.event:event("LocalEvent_ShowMainBaseSetFrm")
			--回调事件
			if (type(current_funcCallback) == "function") then
				current_funcCallback()
			end
		end,
	})
	
	local enterEditBox = nil
	local editInputBoxTextEventHandle = function(strEventName,pSender)
		--if strEventName == "ended" then
			_inputText = enterEditBox:getText()
			if #_inputText == 8 then
				_childUI["rewardBtn"]:setstate(1)
			else
				_childUI["rewardBtn"]:setstate(0)
			end
		--end
	end
	
	--enterEditBox = CCEditBox:create(CCSizeMake(260, 40),CCScale9Sprite:create("data/image/misc/1xs.png"))
	--enterEditBox:setPosition(ccp(_w/2+30,-_h/2+4))
	--enterEditBox:setFontSize(28)
	--enterEditBox:setFontColor(ccc3(255,255,255))
	--enterEditBox:setPlaceHolder(hVar.tab_string["enter_gift_8"])
	----enterNameEditBox:setPlaceholderFontColor(ccc3(255,122,16))
	--enterEditBox:setMaxLength(8)
	--enterEditBox:registerScriptEditBoxHandler(editInputBoxTextEventHandle)
	--enterEditBox:setTouchPriority(0)
	--enterEditBox:setReturnType(kKeyboardReturnTypeDone)
	--_parent:addChild(enterEditBox)
	
	--显示礼品码界面
	hGlobal.event:listen("LocalEvent_ShowWithdrawGiftFrm","showIF",function(callback)
		_childUI["rewardBtn"]:setstate(0)
		_frm:show(1)
		_frm:active()
		
		--重新创建输入框
		if enterEditBox then
			_frm.handle._n:removeChild(enterEditBox,true)
		end
		enterEditBox = CCEditBox:create(CCSizeMake(360, 48),CCScale9Sprite:create("data/image/misc/billboard/bg_ng_graywhite.png"))
		enterEditBox:setPosition(ccp(_w/2,-_h/2+4))
		enterEditBox:setPlaceholderFontSize(8)
		enterEditBox:setFontSize(8)
		enterEditBox:setFontColor(ccc3(0,0,0))
		enterEditBox:setPlaceHolder(hVar.tab_string["enter_gift_8"])
		--enterNameEditBox:setPlaceholderFontColor(ccc3(255,122,16))
		enterEditBox:setMaxLength(8)
		enterEditBox:registerScriptEditBoxHandler(editInputBoxTextEventHandle)
		enterEditBox:setTouchPriority(0)
		enterEditBox:setReturnType(kKeyboardReturnTypeDone)
		_frm.handle._n:addChild(enterEditBox)
		
		--存储回调事件
		current_funcCallback = callback
	end)
end
--[[
--创建礼品码界面
if hGlobal.UI.WithdrawGiftFrm then
	hGlobal.UI.WithdrawGiftFrm:del()
	hGlobal.UI.WithdrawGiftFrm = nil
end
hGlobal.UI.InitWithdrawGiftFrm("include")
--弹出礼品码界面
hGlobal.event:event("LocalEvent_ShowWithdrawGiftFrm", 1)
]]




hGlobal.UI.InitBlackDragonTalkFrm = function(mode)
	local tInitEventName = {"LocalEvent_ShowBlackDragonTalkFrm", "__Show",}
	if mode ~= "include" then
		return tInitEventName
	end

	local _bCanCreate = true
	local _nCreateTime = 0
	local _frm,_childUI,_parent = nil,nil,nil

	local _CODE_CreateFrm = hApi.DoNothing
	local _CODE_CloseFunc = hApi.DoNothing
	local _CODE_AutoDel = hApi.DoNothing

	_CODE_CloseFunc = function()
		hApi.clearTimer("ClearBlackDragonTalkFrm")
		if hGlobal.UI.ShowBlackDragonTalkFrm then
			hGlobal.UI.ShowBlackDragonTalkFrm:del()
			hGlobal.UI.ShowBlackDragonTalkFrm = nil
		end
		_frm,_childUI,_parent = nil,nil,nil
		_bCanCreate = true
	end

	_CODE_CreateFrm = function(state)
		hGlobal.UI.ShowBlackDragonTalkFrm = hUI.frame:new({
			x = 0,
			y = hVar.SCREEN.h,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			z = hZorder.MainBaseFirstFrm,
			show = 0,
			--dragable = 2,
			dragable = 3, --点击后消失
			buttononly = 1,
			autoactive = 0,
			failcall = 1, --出按钮区域抬起也会响应事件
			background = -1, --无底图
			border = 0, --无边框
		})
		
		_frm = hGlobal.UI.ShowBlackDragonTalkFrm
		_parent = _frm.handle._n
		_childUI = _frm.childUI

		_childUI["btn_talkbg"] = hUI.button:new({
			parent = _parent,
			model = "misc/chest/dragon_panel.png",
			align = "LB",
			x = 0,
			y = -hVar.SCREEN.h + 5,
			scale = 1.0,
		})

		
		local str = hVar.tab_string["__TEXT_allRmb0"]
		local rgb = {255, 255, 0}
		local showx = 367
		local showy = 62
		local size = 36
		if state == 0 then
			str = hVar.tab_string["clearspider04"]
			rgb = {255, 255, 255}
			showx = 380
			showy = 58
			size = 28
		end

		_childUI["btn_talkbg"].childUI["lab"] = hUI.label:new({
			parent = _childUI["btn_talkbg"].handle._n,
			text = str,
			align = "MC",
			size = size,
			x = showx,
			y = showy,
			font = hVar.FONTC,
			border = 1,
			RGB = rgb,
		})

		_frm:show(1)
		_frm:active()
	end

	_CODE_AutoDel = function()
		local act0 = CCDelayTime:create(5.5)
		local act1 = CCFadeOut:create(0.5) --淡入
		local act2 = CCCallFunc:create(function()
			_CODE_CloseFunc()
		end)
		local a = CCArray:create()
		a:addObject(act0)
		a:addObject(act1)
		a:addObject(act2)
		local sequence = CCSequence:create(a)
		_frm.handle._n:runAction(sequence)
	end

	hGlobal.event:listen("LocalEvent_CloseBlackDragonTalkFrm","BlackDragonTalkFrm",function()
		_CODE_CloseFunc()
	end)

	hGlobal.event:listen("LocalEvent_SpinScreen","BlackDragonTalkFrm",function()
		_CODE_CloseFunc()
	end)
	
	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(state)
		if _bCanCreate then
			_bCanCreate = false
			_CODE_CreateFrm(state)
			--_CODE_AutoDel()
		end
	end)
end
