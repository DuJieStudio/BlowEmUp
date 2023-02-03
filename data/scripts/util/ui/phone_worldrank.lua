--------------------------------
-- �������а����
--------------------------------
--file changed by pangyong 2015/3/18
hGlobal.UI.InitWorldRankFram = function(mode)
	local tInitEventName = {"LocalEvent_Phone_ShowWorldRank","__showRank"}
	if mode~="include" then											--���ģʽ����include���򷵻عؼ��ֱ��������������ʱ���������ײ����÷��صĹؼ��ִ�������ļ����¼�
		return tInitEventName
	end	
	
	--[��������]
	hGlobal.UI.PhoneWorldRankFram = hUI.frame:new({
		x = 87,
		y = 687,
		dragable = 3,											--0:������ק,1:����ק,2:ȫ��Ļ,{tx,ty,bx,by}:������ק������,3:ȫ���ɵ�������ǵ㵽�ÿ�����Ļ��ͻ�رմ���
		w = 850,											--��Ϊ����Ӣ�۱�����ͼ���аױߣ����Կ�Ŀ�ȼ���22���Թ��˵��ױ�
		h = 340,
		show = 0,											--�Ƿ�ϵ��ʾĬ�����
		background =  1,										--��Ϊ0�����޷���ʾ�߿�
		border = "UI:TileFrmBasic_thin",								--С�߿�,�ڴ˿�����Ѿ�Ĭ��"panel/panel_part_00.png"Ϊ����ɫ
	})
	
	local _fram = hGlobal.UI.PhoneWorldRankFram
	local _parent = _fram.handle._n
	local _childUI = _fram.childUI
	
	local _x, _y, _w = 10, 8, 800

	--[�رհ�ť]
	_childUI["closeBtn"] = hUI.button:new({
		parent = _parent,										--��������
		dragbox = _fram.childUI["dragBox"],								--���봫����Ȼ�����ť���ܵ��
		model = "BTN:PANEL_CLOSE",									--��ťͼƬ
		x = _w + 35,
		y = _y - 28,
		z = 1,												--����Ϊ1��ֹ����setWH()�󣬿�ܸ�ס��ť									
		scaleT = 0.9,											--����
		code = function()
			_fram:show(0)
		end,
	})

	--[����������Ϣ]
	local groupList = {}											--ʹ���б��Ա�Դ����Ĳ������������
	local offY = 120											--ÿһ��֮��ľ������
	local rgb = {{0,255,0}, {255,0,0}, {255,0,0}, {255,0,0}, {255,0,0}, {255,0,0}, {255,0,0}, {255,255,255}, {255,255,255}}--��ɫΪ������ң� ��ɫ
	local _createRankName = function(rankName, heroList)
		for i = 1, #groupList do
			hApi.safeRemoveT(_childUI,groupList[i])							--ɾ����ǰ����ʾ����
		end
		groupList = {}											--����б�
		for i = 1, #rankName do
			local heros = heroList[i][1]								--��ȡӢ���б�

			--���μ�������
			_childUI["group_name_"..i] = hUI.label:new({
				parent = _parent,
				size = 26,
				align = "LT",
				font = hVar.FONTC,
				RGB  = rgb[heros[1].data.owner],						--����Ӣ���б����Ӣ��������������þ������ֵ���ɫ
				x = _x + 6,
				y = _y - 23 - (i-1) * offY,
				width = 400,
				text = rankName[i].name,							--rankName[i].name��	�ƽ�����������ȡ�������������������
			})
			groupList[#groupList+1] = "group_name_"..i
			
			--����ͼ��
			_childUI["group_war_iamge"..i] = hUI.image:new({
				parent = _parent,
				model = "ICON:power",
				--w = 90,									--��������w,������ͼtab�е���Դ�����Ϣ
				x = _x + 254,
				y = _y - 34 - (i-1) * offY,
			})
			groupList[#groupList+1] = "group_war_iamge"..i

			--����
			_childUI["group_war_text"..i] = hUI.label:new({
				parent = _parent,
				size = 22,
				align = "LT",
				font = hVar.FONTC,
				RGB = {255, 255, 0},								--��ɫ
				x = _x + 229,
				y = _y - 25 - (i-1) * offY,
				width = 400,
				text = rankName[i].combat,
			})
			groupList[#groupList+1] = "group_war_text"..i
		end
	end
	
	--[����Ӣ���б�]
	local heroImageList = {}
	local hx, hy, hlx, hly, hoffX = -28, _y - 83, -28, _y - 122, 70
	local _createHeroImage = function(heroList)
		for i = 1, #heroImageList do
			hApi.safeRemoveT(_childUI,heroImageList[i])
		end
		heroImageList = {}

		for i = 1, #heroList do
			local heros = heroList[i][1]
			local nNumX = 1											--��Ϊx��ƫ�Ƶ�λ�����е�Ӣ�۲���ʾ�����������kֵ����ʹ����
			for k, v in pairs(heros) do
				--һ�����ֻ����12������
				--ֻ���� IsNPC ~= 1 ��Ӣ��
				if k > 12 then break end
				if 1 ~= hVar.tab_unit[v.data.id].IsNPC then
					_childUI["heroname"..i..nNumX] = hUI.label:new({
						parent = _parent,
						size = 13,
						text = hVar.tab_stringU[v.data.id][1],					--Ӣ������
						align = "MC",
						x = hlx + hoffX*nNumX,
						y = hly - (i-1)*offY,
					})
					heroImageList[#heroImageList+1] = "heroname"..i..nNumX
					--_childUI["heroname"..i..nNumX].handle.s:setScale(0.7)				-- ��labelͬ�ȷ���

					--Ӣ��ͼ��
					_childUI["heroImage"..i..nNumX] = hUI.image:new({
						parent = _parent,
						model = v.data.icon,                                                    --"ICON:hero_liubei_s",
						w = 53,
						x = hx + hoffX*nNumX,
						y = hy - (i-1)*offY,
					})
					heroImageList[#heroImageList+1] = "heroImage"..i..nNumX
					if v.data.IsDefeated == 1 then
						_childUI["heroImage"..i..nNumX].handle.s:setColor(ccc3(127,127,127))	--����ȥ
						_childUI["heroname"..i..nNumX].handle.s:setColor(ccc3(127,127,127))
					else
						_childUI["heroImage"..i..nNumX].handle.s:setColor(ccc3(255,255,255))	--��ɫ
						_childUI["heroname"..i..nNumX].handle.s:setColor(ccc3(255,255,255))
					end
					
					--Ӣ��ͼ��߿�
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

			--�����ֽ���
			_childUI["line"..i] = hUI.image:new({
				parent = _parent,
				model = "ICON:line",
				x = hlx + 454,
				y = hly - 13 - (i-1)*offY,
				w = 850,									--��������w,������ͼtab�е���Դ�����Ϣ���������ý�������
				h = 2,
				z = -1,
			})
			heroImageList[#heroImageList+1] = "line"..i
		end
	end

	--[ʤ���������Ѷ�]
	local conditionList = {}
	local _createVictoryCondition  = function(rankLen, oworld)
		local _yd = hly - (rankLen - 1)* offY - 13							--�����һ���ָ�����Ϊ�ο�����
		local _xd = _x + 2

		--���֮ǰ�Ĳ���
		for i = 1, #conditionList do
			hApi.safeRemoveT(_childUI, conditionList[i])	
		end
		conditionList = {}
		
		--��ʤ����������
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

		--ʤ������
		_childUI["map_intent"] = hUI.label:new({
				parent = _parent,
				size = 24,
				align = "LT",
				font = hVar.FONTC,
				x = _xd + 114,
				y = _yd - 12,
				width = 716,									--���ʾ���߿�Ϊֹ
				RGB = {255,0,0},
				text = hVar.MAP_INTENT[oworld.data.map],
		})
		conditionList[#conditionList+1] = "map_intent"
		
		--����ǰ�Ѷȣ���
		local nYOffset = 44
		if 4 == LANGUAG_SITTING then									--�ж������Ƿ�ΪӢ��(4)
			nYOffset = 30										--���ΪӢ�İ汾�Ļ������������С��һ������Ҫ����Ӧ��λ�õ���
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
		
		--��ǰ�Ѷ�(����ͼ)
		--local nNum = hVar.MAP_INFO[oworld.data.map].default_diff					--Ĭ���Ѷ�
		local nNum = oworld.data.MapDifficulty								--��ȡ��ǰ�Ѷ�
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

		--"��ʼ���� : "
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
		--��ʼ����
		local nXOffset, nWidthOffSet = 380, 480
		local strPercent = "% "
		if 4 == LANGUAG_SITTING then									--�ж������Ƿ�ΪӢ��(4)
			nXOffset = 350
			nWidthOffSet = 500
			strPercent = "%  "									--�ٷֺ�
		end
		local RandomPec = hApi.GetMapValueByDifficulty(oworld, "EnemyBorn")
		local forces = RandomPec * 100									--��ʼ����
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
	
	--[��������]
	local swapTableItem = function(tab,n,m)
		local temp = tab[n]
		tab[n] = tab[m]
		tab[m] = temp
	end

	hGlobal.event:listen(tInitEventName[1], tInitEventName[2], function()
		if g_editor == 1 then return end
		--[���õ�ͼ����]
		local oworld = hGlobal.WORLD.LastWorldMap							--��ȡ��ǰ��ͼ����Ϣ��
		local shiList = {}
		if oworld then
			----����Ҫ��һ��ʮ��а��Ĵ��룬����һ��Ҫɾ��������������˴����㷢����δ��뻹ûɾ�����������ϵ �վ�...
			for k,v in pairs(hVar.MAP_LEGION) do
				if k == oworld.data.map then							--k�д洢���ǵ�ͼ�������磺	"world/level_xsnd" ��"world/level_hmzl"�ȵȡ��������������� ���ɲο�var.lua�еĶ��壩 
					for i = 1,#v do
						shiList[v[i][1]] = hVar.tab_string[v[i][2]]			--��ȡ��v�е�tab������shiList�У�ͨ���������Ի�ȡ�����ַ���
					end
				end
			end
		else
			print(tInitEventName[1].."is error! ")
		end

		local _rankLen = 0										--��¼Ӣ���б���
		local rankName = {}
		local herolist = {}

		for i = 1,8 do --hVar.MAX_PLAYER_NUM do								--8����ұ�����������
			local player = hGlobal.player[i]

			--�����ӵ��Ӣ�� �� ӵ�гǳ�ʱ
			if player and (#player.heros ~= 0 or #player.data.ownTown ~= 0) then
				_rankLen = _rankLen+1
				if shiList[i] then
					rankName[#rankName+1] = {name = shiList[i] or hVar.tab_stringU[player.data.id][1],ID = i } --���֣������±��1��ʼ�����Ա�����ң�1��һ���ǵ�һ���� �Ѿ���8��9��һ�������
					herolist[#herolist+1] = {player.heros}						--��Ӣ�۱��浽Ӣ���б���
				end
			end
		end
		
		--ֻ����ǰ����Ӣ��
		if _rankLen > 4 then
			_rankLen = 4
		end

		--[���ô��ڴ�С]
		local nFram_h = 80 + _rankLen* 120								--���ڵĸ߶�
		local nFram_w = 850
		_fram:setWH(nFram_w, nFram_h)

		--[���ô��ڵ����� (��ͬ�豸�Ŀ����治ͬ)]
		local _xs = hVar.SCREEN.w/2 - 458								--���ֻ�ģʽ
		local _ys = hVar.SCREEN.h - 81	
		if 1 == g_phone_mode or 2 == g_phone_mode then							--�ֻ�ģʽ:	0:pad	1:4s,	2:5s:	3:��׿
			--_xs = hVar.SCREEN.w/2 - 473
			if 4 == _rankLen then
				_ys = hVar.SCREEN.h - 71							--��������Ϊ4ʱ��Ҫ���Ի������ϵ�����������С���ֻ�����ʾ�����򿴲����ײ�
			else
				_ys = hVar.SCREEN.h - 81
			end
		end
		_fram:setXY(_xs, _ys)

		--[���Ʊ���]
		hApi.safeRemoveT(_childUI,"SelectedPlayerFram")							--ɾ��֮ǰ�ı���
		_childUI["SelectedPlayerFram"] = hUI.bar:new({							--�����µı���
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

		--[����ս����]
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
			rankName[i].combat = playerCombat[i]							--��ս�������浽��Ӧ�������б���
		end

		--�����б�˳��  ���϶�������Ϊ�� �о��� �Ѿ��� �������
		for i = 1, #herolist-1 do
			swapTableItem( herolist, i, i+1 )
			swapTableItem( rankName, i, i+1 )
		end

		--[�������п��еĲ���]
		_createRankName(rankName,herolist)								--����������,��Ҫ�õ�Ӣ����������ң������þ������ֵ���ɫ
		_createHeroImage(herolist)									--Ӣ���б�
		_createVictoryCondition(_rankLen, oworld)							--ʤ������

		_fram:show(1)
		_fram:active()
	end)

end
