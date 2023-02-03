--------------------------------
--英雄令介绍界面
--------------------------------

--file added by pangyong 2015/4/16
hGlobal.UI.InitHeroCardInfoFrm = function( mode )
	--[初始监听]
	local tInitEventName = {"LocalEvent_HeroCardInfo","__showheroCardInfo"}
	if mode ~= "include" then										--如果模式不是include，则返回关键字表，而下面的内容临时不做处理，底层更加返回的关键字处理下面的监听事件
		return tInitEventName
	end
	
	--设置用于主框架的参数
	local _wc, _hc	= 564, 412
	local _xc, _yc	= hVar.SCREEN.w/2 - _wc/2, hVar.SCREEN.h/2+ _hc/2 - 17					--提取屏幕数值设置参数
	
	--[创建主框]
	hGlobal.UI.PhoneHeroCardInfoFram = hUI.frame:new({
		x	    = _xc,
		y	    = _yc + 30,
		z = 101,
		dragable    = 3,										--0:不能拖拽,1:可拖拽,2:全屏幕,{tx,ty,bx,by}:允许拖拽的区域,3:全屏可点击，但是点到该框外面的话就会跳动以下关闭窗口 4：全屏可点击，但是点到该框外面的话就会跳动以下窗口
		w	    = _wc,										--因为用于英雄背景的图标有白边，所以框的宽度减少22，以过滤掉白边
		h	    = _hc,
		show	    = 0,										--是否系显示默认面板
		border	    = "UI:TileFrmBasic_thin",								--小边框,在此框架中已经默认"panel/panel_part_00.png"为背景色
	})
	local _fram	    = hGlobal.UI.PhoneHeroCardInfoFram
	local _parent	    = _fram.handle._n
	local _childUI	    = _fram.childUI
	
	--[关闭按钮]
	_childUI["closeBtn"] = hUI.button:new({
		parent	= _parent,
		dragbox = _fram.childUI["dragBox"],
		model	= "BTN:PANEL_CLOSE",
		x = _wc - 14,
		y = -14,
		z = 1,												--设置为1防止窗口setWH()后，框架盖住按钮									
		scaleT	= 0.9,
		code	= function()
			_fram:show(0)
		end,
	})
	
	--[创建英雄半身像 说明文字 获得途径]
	local _HeroInfoCount = {}
	local _createHeroInfo = function( heroID )
		--清理
		for i = 1,#_HeroInfoCount do
			hApi.safeRemoveT(_childUI,_HeroInfoCount[i])
		end
		_HeroInfoCount = {}
		
		--英雄半身像
		_childUI["HeroImage"] = hUI.image:new({
			parent = _parent,
			mode   = "image",									--如果不指定此项，则图片总是会居中对齐（忽略了align的设置）
			model  = hVar.tab_unit[heroID].portrait,
			align  = "LT",
			x = 25,
			y = -26,
			w = 222,
			h = 222,
		})
		hUI.SYSAutoReleaseUI:addModel("portrait", hVar.tab_unit[heroID].portrait) --待回收
		_HeroInfoCount[#_HeroInfoCount + 1] = "HeroImage"
		
		--图像低部线条
		_childUI["DownLine"] = hUI.bar:new({
			parent = _parent,
			model  = "UI:title_line",
			align  = "LT",
			x = _childUI["HeroImage"].data.x,
			y = _childUI["HeroImage"].data.y - _childUI["HeroImage"].data.h,
			w = 222 + 1,
			h = 6,
		})
		_HeroInfoCount[#_HeroInfoCount + 1] = "DownLine"
		
		--详细信息
		local nUnit = 0
		local nYOffset = 52
		if 4 == LANGUAG_SITTING then									--判断语言是否为英文(4)
			nUnit = 6										--如果为英文版本的话，由于字体大小不一样，需要做相应的位置调整
			nYOffset = 50
		end
		_childUI["HeroName"] = hUI.label:new({
			parent = _parent,
			size   = 32,
			align  = "LT",
			font   = hVar.FONTC,
			x = 255,
			y = - nYOffset,
			text = hVar.tab_stringU[heroID] and hVar.tab_stringU[heroID][1] or ("未知英雄" .. heroID),
		})
		_HeroInfoCount[#_HeroInfoCount + 1] = "HeroName"
		local size	= _childUI["HeroName"].handle.s:getContentSize()				--获取label创建后的长度
		local lenNum	= math.ceil(size.width/4 -  1*(size.width/32) + nUnit)
		local strBlank	= string.rep(" ",lenNum)							--根据视图显示临时设计的参数计算方式，没有其他特别的意思，如有更好的方法，可替代本计算方法
		_childUI["HeroInfo"] = hUI.label:new({
			parent = _parent,
			size = 22,
			align = "LT",
			font = hVar.FONTC,
			x = 255,
			y = - 60,
			width = 294,
			text = strBlank .. (hVar.tab_stringU[heroID] and hVar.tab_stringU[heroID][2] or ("未知英雄介绍" .. heroID)),						--strBlank:  为英雄的名字 留出来的空格
		})
		_HeroInfoCount[#_HeroInfoCount + 1] = "HeroInfo"
		
		--获取途径
		_childUI["HeroAccess"] = hUI.label:new({
			parent = _parent,
			size   = 22,
			align  = "LT",
			font   = hVar.FONTC,
			border = 1,
			RGB    = {0, 255, 0},
			x      = 270,
			y      = - 170,
			width  = 280,
			text   = hVar.tab_stringU[heroID] and hVar.tab_stringU[heroID][3] or ("未知英雄来源" .. heroID),
		})
		_HeroInfoCount[#_HeroInfoCount + 1] = "HeroAccess"
	end
	
	--[技能]
	local xskill, yskill = 0, -_hc + 140
	--技能背景
	_childUI["SkillBackground"] = hUI.bar:new({
		parent = _parent,
		model = "UI:tip_item",
		align = "LT",
		x = xskill,
		y = yskill,
		w = _wc + 10,
		h = 130,
		z = -1,
	})
	--“英雄技能”
	local nYOffset, nWOffset = 16, 25
	if 4 == LANGUAG_SITTING then									--判断语言是否为英文(4)
		nYOffset = 52										--如果为英文版本的话，由于字体大小不一样，需要做相应的位置调整
		nWOffset = 34
	end
	_childUI["HeroSkillstr"] = hUI.label:new({
		parent = _parent,
		size = 24,
		align = "LT",
		font = hVar.FONTC,
		x = xskill + 48,
		y = yskill - nYOffset,
		width = nWOffset,
		text = hVar.tab_string["__TEXT_HeroSkill"],
	})
	--技能按钮
	local _skillListCount = {}
	local _createSkillBtn = function( skillList, tacticList, heroID)
		for i = 1,#_skillListCount do
			hApi.safeRemoveT(_childUI,_skillListCount[i])
		end
		--print("技能按钮", heroID)
		_skillListCount = {}
		local skillNum = 1
		--战术技能
		if #tacticList > 0 then
			for i = 1, #tacticList do
				--战术技能的背景图
				--技能按钮
				_childUI["HeroSkillImg_BG_"..skillNum] = hUI.button:new({
					mode = "imageButton",
					parent = _parent,
					model = "UI:TacticImgBG",
					x = xskill + 144 + (skillNum-1)*84,
					y = yskill - 52,
					w = 76,
					h = 76,
				})
				_skillListCount[#_skillListCount+1] = "HeroSkillImg_BG_"..skillNum
				
				--技能按钮
				_childUI["HeroSkillImg_"..skillNum] = hUI.button:new({
					mode = "imageButton",
					parent = _parent,
					model = hVar.tab_tactics[tacticList[i]].icon ,
					dragbox = _childUI["dragBox"],
					x = xskill + 144 + (skillNum-1)*84,
					y = yskill - 52,
					w = 64,
					h = 64,
					scaleT = 0.95,
					code = function(self,x,y,sus)
						local tacticId = tacticList[i]
						if tacticId and hVar.tab_tactics[tacticId] and hVar.tab_tactics[tacticId].activeSkill then
							local skillId = hVar.tab_tactics[tacticId].activeSkill.id
							if skillId and hVar.tab_skill[skillId] then
								hGlobal.event:event("LocalEvent_ShowSkillInfoFram",heroID,skillId,150,600)
							end
						end
					end,
				})
				_skillListCount[#_skillListCount+1] = "HeroSkillImg_"..skillNum
				
				--等级需求前缀
				_childUI["HeroSkillLevelPrefix"..skillNum] = hUI.label:new({
					parent = _parent,
					size = 18,
					align = "RC",
					font = hVar.FONTC,
					x = xskill + 156 + (skillNum-1)*84,
					y = yskill - 100,
					width = 64,
					--text = "等级", --language
					text = hVar.tab_string["__Attr_Hint_Lev"], --language
					border = 1,
				})
				_childUI["HeroSkillLevelPrefix"..skillNum].handle.s:setColor(ccc3(255, 212, 0))
				_skillListCount[#_skillListCount+1] = "HeroSkillLevelPrefix"..skillNum
				
				--等级需求
				--local nlevel = (i-1) * 3
				--if 0 == nlevel then
				--	nlevel = 1
				--end
				_childUI["HeroSkillLevel"..skillNum] = hUI.label:new({
					parent = _parent,
					size = 14,
					align = "LC",
					font = "num",
					x = xskill + 159 + (skillNum-1)*84,
					y = yskill - 100 - 1,
					width = 64,
					text = tostring(1),						--lv1	lv3	lv6	lv9	lv12
				})
				_skillListCount[#_skillListCount+1] = "HeroSkillLevel"..skillNum
				
				skillNum = skillNum + 1
			end
		end
		
		--天赋技能
		if #skillList > 0 then
			for i = 1, #skillList do
				--技能按钮
				_childUI["HeroSkillImg_"..skillNum] = hUI.button:new({
					mode = "imageButton",
					parent = _parent,
					model = hVar.tab_skill[skillList[i]] and hVar.tab_skill[skillList[i]].icon ,
					dragbox = _childUI["dragBox"],
					x = xskill + 144 + (skillNum-1)*84,
					y = yskill - 52,
					w = 64,
					h = 64,
					scaleT = 0.95,
					code = function(self,x,y,sus)
						hGlobal.event:event("LocalEvent_ShowSkillInfoFram",heroID,skillList[i],150,600)
					end,
				})
				_skillListCount[#_skillListCount+1] = "HeroSkillImg_"..skillNum
				
				--等级需求前缀
				_childUI["HeroSkillLevelPrefix"..skillNum] = hUI.label:new({
					parent = _parent,
					size = 18,
					align = "RC",
					font = hVar.FONTC,
					x = xskill + 156 + (skillNum-1)*84,
					y = yskill - 100,
					width = 64,
					--text = "等级", --language
					text = hVar.tab_string["__Attr_Hint_Lev"], --language
					border = 1,
				})
				_childUI["HeroSkillLevelPrefix"..skillNum].handle.s:setColor(ccc3(255, 212, 0))
				_skillListCount[#_skillListCount+1] = "HeroSkillLevelPrefix"..skillNum
				
				--等级需求
				--local nlevel = (i-1) * 3
				--if 0 == nlevel then
				--	nlevel = 1
				--end
				local nlevel = 1
				_childUI["HeroSkillLevel"..skillNum] = hUI.label:new({
					parent = _parent,
					size = 14,
					align = "LC",
					font = "num",
					x = xskill + 159 + (skillNum-1)*84,
					y = yskill - 100 - 1,
					width = 64,
					text = tostring(nlevel),						--lv1	lv3	lv6	lv9	lv12
				})
				_skillListCount[#_skillListCount+1] = "HeroSkillLevel"..skillNum
				
				skillNum = skillNum + 1
			end
		end
	end
	
	
	--[监听画面启动]
	hGlobal.event:listen(tInitEventName[1], tInitEventName[2], function(heroID)
		--提取英雄技能
		local tactic = hVar.tab_unit[heroID].tactics
		local tacticList = {}
		local talent = hVar.tab_unit[heroID].talent
		local skillList = {}
		if type(tactic) == "table" then
			for i = 1,#tactic do
				tacticList[#tacticList+1] = tactic[i]
			end
		end
		
		if type(talent) == "table" then
			for i = 1,#talent do
				skillList[#skillList+1] = talent[i][1]
			end
		end
		
		--创建本英雄令的技能按钮
		_createSkillBtn(skillList,tacticList,heroID)
		
		--创建英雄半身像 说明文字 获得途径
		_createHeroInfo(heroID)
		
		--启动画面
		_fram:show(1)
		_fram:active()
	end)
end