--------------------------------
-- 世界排行榜界面
--------------------------------
--file changed by pangyong 2015/3/18
hGlobal.UI.InitWorldRankFram = function(mode)
	local tInitEventName = {"LocalEvent_Phone_ShowWorldRank","__showRank"}
	if mode~="include" then											--如果模式不是include，则返回关键字表，而下面的内容临时不做处理，底层利用返回的关键字处理下面的监听事件
		return tInitEventName
	end	
	
	--[创建主框]
	hGlobal.UI.PhoneWorldRankFram = hUI.frame:new({
		x = 87,
		y = 687,
		dragable = 3,											--0:不能拖拽,1:可拖拽,2:全屏幕,{tx,ty,bx,by}:允许拖拽的区域,3:全屏可点击，但是点到该框外面的话就会关闭窗口
		w = 850,											--因为用于英雄背景的图标有白边，所以框的宽度减少22，以过滤掉白边
		h = 340,
		show = 0,											--是否系显示默认面板
		background =  1,										--若为0，则无法显示边框
		border = "UI:TileFrmBasic_thin",								--小边框,在此框架中已经默认"panel/panel_part_00.png"为背景色
	})
	
	local _fram = hGlobal.UI.PhoneWorldRankFram
	local _parent = _fram.handle._n
	local _childUI = _fram.childUI
	
	local _x, _y, _w = 10, 8, 800

	--[关闭按钮]
	_childUI["closeBtn"] = hUI.button:new({
		parent = _parent,										--所属窗口
		dragbox = _fram.childUI["dragBox"],								--必须传，不然这个按钮不能点击
		model = "BTN:PANEL_CLOSE",									--按钮图片
		x = _w + 35,
		y = _y - 28,
		z = 1,												--设置为1防止窗口setWH()后，框架盖住按钮									
		scaleT = 0.9,											--比例
		code = function()
			_fram:show(0)
		end,
	})

	--[创建军队信息]
	local groupList = {}											--使用列表，以便对创建的部件更容易清除
	local offY = 120											--每一行之间的距离参数
	local rgb = {{0,255,0}, {255,0,0}, {255,0,0}, {255,0,0}, {255,0,0}, {255,0,0}, {255,0,0}, {255,255,255}, {255,255,255}}--绿色为本地玩家， 红色
	local _createRankName = function(rankName, heroList)
		for i = 1, #groupList do
			hApi.safeRemoveT(_childUI,groupList[i])							--删除以前的显示内容
		end
		groupList = {}											--清空列表
		for i = 1, #rankName do
			local heros = heroList[i][1]								--提取英雄列表

			--名次及势力名
			_childUI["group_name_"..i] = hUI.label:new({
				parent = _parent,
				size = 26,
				align = "LT",
				font = hVar.FONTC,
				RGB  = rgb[heros[1].data.owner],						--根据英雄列表里的英雄所属的玩家设置军队名字的颜色
				x = _x + 6,
				y = _y - 23 - (i-1) * offY,
				width = 400,
				text = rankName[i].name,							--rankName[i].name：	黄巾军，刘备军等…………………………
			})
			groupList[#groupList+1] = "group_name_"..i
			
			--军队图标
			_childUI["group_war_iamge"..i] = hUI.image:new({
				parent = _parent,
				model = "ICON:power",
				--w = 90,									--若设置了w,则会忽略图tab中的资源宽度信息
				x = _x + 254,
				y = _y - 34 - (i-1) * offY,
			})
			groupList[#groupList+1] = "group_war_iamge"..i

			--军力
			_childUI["group_war_text"..i] = hUI.label:new({
				parent = _parent,
				size = 22,
				align = "LT",
				font = hVar.FONTC,
				RGB = {255, 255, 0},								--黄色
				x = _x + 229,
				y = _y - 25 - (i-1) * offY,
				width = 400,
				text = rankName[i].combat,
			})
			groupList[#groupList+1] = "group_war_text"..i
		end
	end
	
	--[创建英雄列表]
	local heroImageList = {}
	local hx, hy, hlx, hly, hoffX = -28, _y - 83, -28, _y - 122, 70
	local _createHeroImage = function(heroList)
		for i = 1, #heroImageList do
			hApi.safeRemoveT(_childUI,heroImageList[i])
		end
		heroImageList = {}

		for i = 1, #heroList do
			local heros = heroList[i][1]
			local nNumX = 1											--作为x轴偏移单位量，有点英雄不显示，所以下面的k值不能使用了
			for k, v in pairs(heros) do
				--一行最多只绘制12个人物
				--只绘制 IsNPC ~= 1 的英雄
				if k > 12 then break end
				if 1 ~= hVar.tab_unit[v.data.id].IsNPC then
					_childUI["heroname"..i..nNumX] = hUI.label:new({
						parent = _parent,
						size = 13,
						text = hVar.tab_stringU[v.data.id][1],					--英雄名字
						align = "MC",
						x = hlx + hoffX*nNumX,
						y = hly - (i-1)*offY,
					})
					heroImageList[#heroImageList+1] = "heroname"..i..nNumX
					--_childUI["heroname"..i..nNumX].handle.s:setScale(0.7)				-- 将label同比放缩

					--英雄图像
					_childUI["heroImage"..i..nNumX] = hUI.image:new({
						parent = _parent,
						model = v.data.icon,                                                    --"ICON:hero_liubei_s",
						w = 53,
						x = hx + hoffX*nNumX,
						y = hy - (i-1)*offY,
					})
					heroImageList[#heroImageList+1] = "heroImage"..i..nNumX
					if v.data.IsDefeated == 1 then
						_childUI["heroImage"..i..nNumX].handle.s:setColor(ccc3(127,127,127))	--暗下去
						_childUI["heroname"..i..nNumX].handle.s:setColor(ccc3(127,127,127))
					else
						_childUI["heroImage"..i..nNumX].handle.s:setColor(ccc3(255,255,255))	--白色
						_childUI["heroname"..i..nNumX].handle.s:setColor(ccc3(255,255,255))
					end
					
					--英雄图像边框
					_childUI["imageframe"..i..nNumX] = hUI.image:new({
						parent = _parent,
						model = "ICON:image_frame",
						x = hx + hoffX*nNumX,
						y = hy - (i-1)*offY,
					})
					heroImageList[#heroImageList+1] = "imageframe"..i..nNumX
					nNumX = nNumX + 1
				end
			end

			--排名分界线
			_childUI["line"..i] = hUI.image:new({
				parent = _parent,
				model = "ICON:line",
				x = hlx + 454,
				y = hly - 13 - (i-1)*offY,
				w = 850,									--若设置了w,则会忽略图tab中的资源宽度信息，按照设置进行拉伸
				h = 2,
				z = -1,
			})
			heroImageList[#heroImageList+1] = "line"..i
		end
	end

	--[胜利条件和难度]
	local conditionList = {}
	local _createVictoryCondition  = function(rankLen, oworld)
		local _yd = hly - (rankLen - 1)* offY - 13							--以最后一个分割线作为参考数据
		local _xd = _x + 2

		--清空之前的部件
		for i = 1, #conditionList do
			hApi.safeRemoveT(_childUI, conditionList[i])	
		end
		conditionList = {}
		
		--“胜利条件：”
		_childUI["VictoryCondition"] = hUI.label:new({
				parent = _parent,
				size = 24,
				align = "LT",
				font = hVar.FONTC,
				x = _xd,
				y = _yd - 12,
				width = 110,
				text = hVar.tab_string["__TEXT_VictoryCondition"],
		})
		conditionList[#conditionList+1] = "VictoryCondition"

		--胜利条件
		_childUI["map_intent"] = hUI.label:new({
				parent = _parent,
				size = 24,
				align = "LT",
				font = hVar.FONTC,
				x = _xd + 114,
				y = _yd - 12,
				width = 716,									--最长显示到边框为止
				RGB = {255,0,0},
				text = hVar.MAP_INTENT[oworld.data.map],
		})
		conditionList[#conditionList+1] = "map_intent"
		
		--“当前难度：”
		local nYOffset = 44
		if 4 == LANGUAG_SITTING then									--判断语言是否为英文(4)
			nYOffset = 30										--如果为英文版本的话，由于字体大小不一样，需要做相应的位置调整
		end
		_childUI["currentdiff"] = hUI.label:new({
				parent = _parent,
				size = 24,
				align = "LT",
				font = hVar.FONTC,
				x = _xd,
				y = _yd - nYOffset,
				width = 110,
				text = hVar.tab_string["__TEXT_currentdiff"],
		})
		conditionList[#conditionList+1] = "currentdiff"
		
		--当前难度(辣椒图)
		--local nNum = hVar.MAP_INFO[oworld.data.map].default_diff					--默认难度
		local nNum = oworld.data.MapDifficulty								--获取当前难度
		for num = 1,nNum do
			_childUI["map_diff"..num] = hUI.image:new({
				parent = _parent,
				model = "UI:difficulty",
				x = _xd + 104 + num* 22,
				y = _yd - 55,
			})
			conditionList[#conditionList+1] = "map_diff"..num
		end
		for num = nNum + 1, 5 do
			_childUI["map_diff_slot"..num] = hUI.image:new({
				parent = _parent,
				model = "UI:difficulty_slot",
				x = _xd + 104 + num* 22,
				y = _yd - 55,
			})
			conditionList[#conditionList+1] = "map_diff_slot"..num
		end

		--"初始兵力 : "
		_childUI["startunits"] = hUI.label:new({
				parent = _parent,
				size = 24,
				align = "LT",
				font = hVar.FONTC,
				x = _xd + 240,
				y = _yd - 46,
				width = 150,
				RGB = {255,0,0},
				text = hVar.tab_string["__TEXT_startunits"],
		})
		conditionList[#conditionList+1] = "startunits"
		--初始兵力
		local nXOffset, nWidthOffSet = 380, 480
		local strPercent = "% "
		if 4 == LANGUAG_SITTING then									--判断语言是否为英文(4)
			nXOffset = 350
			nWidthOffSet = 500
			strPercent = "%  "									--百分号
		end
		local RandomPec = hApi.GetMapValueByDifficulty(oworld, "EnemyBorn")
		local forces = RandomPec * 100									--初始兵力
		_childUI["startunits1"] = hUI.label:new({
				parent = _parent,
				size = 24,
				align = "LT",
				font = hVar.FONTC,
				x = _xd + nXOffset,
				y = _yd - 46,
				width = nWidthOffSet,
				RGB = {255,0,0},
				text = forces..strPercent..hVar.tab_string["__TEXT_inform_rose"],
		})
		conditionList[#conditionList+1] = "startunits1"
	end
	
	--[交换数据]
	local swapTableItem = function(tab,n,m)
		local temp = tab[n]
		tab[n] = tab[m]
		tab[m] = temp
	end

	hGlobal.event:listen(tInitEventName[1], tInitEventName[2], function()
		if g_editor == 1 then return end
		--[设置地图名字]
		local oworld = hGlobal.WORLD.LastWorldMap							--获取当前地图的信息表
		local shiList = {}
		if oworld then
			----这里要加一段十分邪恶的代码，将来一定要删除掉，如果看到此处的你发现这段代码还没删除，请务必联系 陶晶...
			for k,v in pairs(hVar.MAP_LEGION) do
				if k == oworld.data.map then							--k中存储的是地图的名字如：	"world/level_xsnd" ，"world/level_hmzl"等等…………………… （可参考var.lua中的定义） 
					for i = 1,#v do
						shiList[v[i][1]] = hVar.tab_string[v[i][2]]			--提取表v中的tab索引到shiList中，通过索引可以获取名字字符串
					end
				end
			end
		else
			print(tInitEventName[1].."is error! ")
		end

		local _rankLen = 0										--记录英雄列表长度
		local rankName = {}
		local herolist = {}

		for i = 1,8 do --hVar.MAX_PLAYER_NUM do								--8是玩家表中最大的索引
			local player = hGlobal.player[i]

			--当玩家拥有英雄 或 拥有城池时
			if player and (#player.heros ~= 0 or #player.data.ownTown ~= 0) then
				_rankLen = _rankLen+1
				if shiList[i] then
					rankName[#rankName+1] = {name = shiList[i] or hVar.tab_stringU[player.data.id][1],ID = i } --名字，由于下标从1开始，所以本地玩家（1）一定是第一个， 友军（8，9）一定在最后
					herolist[#herolist+1] = {player.heros}						--将英雄保存到英雄列表中
				end
			end
		end
		
		--只排名前四名英雄
		if _rankLen > 4 then
			_rankLen = 4
		end

		--[设置窗口大小]
		local nFram_h = 80 + _rankLen* 120								--窗口的高度
		local nFram_w = 850
		_fram:setWH(nFram_w, nFram_h)

		--[设置窗口的坐标 (不同设备的可视面不同)]
		local _xs = hVar.SCREEN.w/2 - 458								--非手机模式
		local _ys = hVar.SCREEN.h - 81	
		if 1 == g_phone_mode or 2 == g_phone_mode then							--手机模式:	0:pad	1:4s,	2:5s:	3:安卓
			--_xs = hVar.SCREEN.w/2 - 473
			if 4 == _rankLen then
				_ys = hVar.SCREEN.h - 71							--当排行数为4时需要将对话框向上调整，以满足小屏手机的显示，否则看不到底部
			else
				_ys = hVar.SCREEN.h - 81
			end
		end
		_fram:setXY(_xs, _ys)

		--[绘制背景]
		hApi.safeRemoveT(_childUI,"SelectedPlayerFram")							--删除之前的背景
		_childUI["SelectedPlayerFram"] = hUI.bar:new({							--创建新的背景
			parent = _parent,
			model = "UI:frm_b",
			align = "LT",
			x = 0,
			y = 0,
			w = nFram_w,
			h = 8 + _rankLen* 120,
			z = -1,
		})

		local playerCombat = {}
		local tempnum = nil

		--[计算战斗力]
		for i = 1, #herolist do
			tempnum = 0
			local heros = herolist[i][1]
			local oUnit = nil
			for k,v in pairs(heros) do
				oUnit = v:getunit()
				if oUnit then
					tempnum = tempnum + heroGameAI.CalculateSystem.Calculate(oUnit,nil,heroGameAI.CalculateSystem.CALC_TYPE_DEF.COMBATSCORE)
				end
			end
			playerCombat[i] = tempnum
		end
		
		for i = 1, #rankName do
			rankName[i].combat = playerCombat[i]							--将战斗力保存到相应的名字列表里
		end

		--排序列表顺序  至上而下依次为： 敌军， 友军， 本地玩家
		for i = 1, #herolist-1 do
			swapTableItem( herolist, i, i+1 )
			swapTableItem( rankName, i, i+1 )
		end

		--[创建排行框中的部件]
		_createRankName(rankName,herolist)								--排名的名字,需要用到英雄所属的玩家，来设置军队名字的颜色
		_createHeroImage(herolist)									--英雄列表
		_createVictoryCondition(_rankLen, oworld)							--胜利条件

		_fram:show(1)
		_fram:active()
	end)

end
