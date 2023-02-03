--战车随机地图房间各皮肤信息
hVar.RANDMAP_ROOM_AVATAR_INFO =
{
	--随机迷宫随机的范围
	RandRange = 13,
	
	--黄色警戒线风格
	[1] =
	{
		farobj = --地球远景层
		{
			img = {"data/image/maze/space_back_01.jpg", "data/image/maze/space_back_02.jpg", "data/image/maze/space_back_03.jpg", "data/image/maze/space_back_04.jpg", "data/image/maze/space_back_05.jpg", "data/image/maze/space_back_06.jpg",},
			num = 1,
			scale = 1.0,
			rollRatio = 0.1, --卷轴速率
		},
		middleobj = --星星中景层
		{
			img = {"data/image/maze/starlight.png",},
			num = 20,
			scale = {0.2, 0.7},
			rollRatio = 0.16, --卷轴速率
		},
		nearobj = --飞船近景层
		{
			img = {
				[1] =
				{
					x = 128 * 0 + 2,
					y = 128 * 6 + 2,
					w = 256 - 2 * 2,
					h = 256 - 2 * 2,
				},
				[2] =
				{
					x = 128 * 2 + 2,
					y = 128 * 6 + 2,
					w = 256 - 2 * 2,
					h = 256 - 2 * 2,
				},
				[3] =
				{
					x = 128 * 4 + 2,
					y = 128 * 6 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[4] =
				{
					x = 128 * 5 + 2,
					y = 128 * 6 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[5] =
				{
					x = 128 * 6 + 2,
					y = 128 * 6 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[6] =
				{
					x = 128 * 7 + 2,
					y = 128 * 6 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[7] =
				{
					x = 128 * 4 + 2,
					y = 128 * 7 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[8] =
				{
					x = 128 * 5 + 2,
					y = 128 * 7 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[9] =
				{
					x = 128 * 6 + 2,
					y = 128 * 7 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[10] =
				{
					x = 128 * 7 + 2,
					y = 128 * 7 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
			},
			num = 20,
			scale = {1.0, 2.0},
			rollRatio = 0.3, --卷轴速率
		},
		wallimg = "data/image/maze/mazeskin_highwall_001.png", --墙面图片（整合到一张图里）
		ground = { --地板
			[1] =
			{
				x = 128 * 4 + 2,
				y = 128 * 0 + 2,
				w = 256 - 2 * 2,
				h = 256 - 2 * 2,
				probablity = 60, --几率
			},
			[2] =
			{
				x = 128 * 6 + 2,
				y = 128 * 0 + 2,
				w = 256 - 2 * 2,
				h = 256 - 2 * 2,
				probablity = 35,
			},
			[3] =
			{
				x = 128 * 4 + 2,
				y = 128 * 2 + 2,
				w = 256 - 2 * 2,
				h = 256 - 2 * 2,
				probablity = 5,
			},
		},
		wall_l = {
			objId = 4001,
			offsetX = 24,
			offsetY = 24,
			effect =
			{
				x = 128 * 0 + 2,
				y = 128 * 1 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 24,
				offY = -1,
			},
			zOrder = 128, --指定z值叠加
		},
		wall_r = {
			objId = 4002,
			offsetX = 24,
			offsetY = 24,
			effect =
			{
				x = 128 * 2 + 2,
				y = 128 * 1 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -28,
				offY = 1,
			},
			zOrder = 128, --指定z值叠加
		},
		wall_t = {
			objId = 4003,
			offsetX = 48,
			offsetY = 0,
			effect =
			{
				x = 128 * 1 + 2,
				y = 128 * 0 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -3,
				offY = 18,
			},
			zOrder = -256, --指定z值很小
		},
		wall_b = {
			objId = 4004,
			offsetX = 48,
			offsetY = 0,
			effect =
			{
				x = 128 * 1 + 2,
				y = 128 * 2 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -3,
				offY = -26,
			},
			zOrder = 128, --指定z值叠加
		},
		corner_lt = {
			objId = 4005,
			offsetX = 48,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 0 + 2,
				y = 128 * 0 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -7,
				offY = 2,
			},
			zOrder = -256, --指定z值很小
		},
		corner_rt = {
			objId = 4006,
			offsetX = 24,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 2 + 2,
				y = 128 * 0 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 18,
				offY = 2,
			},
			zOrder = -256, --指定z值很小
		},
		corner_lb = {
			objId = 4007,
			offsetX = 48,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 0 + 2,
				y = 128 * 2 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -7,
				offY = 3,
			},
			zOrder = 128, --指定z值叠加
		},
		corner_rb = {
			objId = 4008,
			offsetX = 24,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 2 + 2,
				y = 128 * 2 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 18,
				offY = 2,
			},
			zOrder = 128, --指定z值叠加
		},
		
		corner_lt1 = { --合并
			objId = 4014,
			offsetX = 48,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 3 + 2,
				y = 128 * 0 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -7,
				offY = 2,
			},
			zOrder = 128, --指定z值叠加
		},
		corner_rt1 = { --合并
			objId = 4015,
			offsetX = 24,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 3 + 2,
				y = 128 * 2 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 18,
				offY = 2,
			},
			zOrder = 128, --指定z值叠加
		},
		corner_lb1 = { --合并
			objId = 4016,
			offsetX = 48,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 3 + 2,
				y = 128 * 1 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -7,
				offY = 3,
			},
			zOrder = 128, --指定z值叠加
		},
		corner_rb1 = { --合并
			objId = 4017,
			offsetX = 24,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 3 + 2,
				y = 128 * 3 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 18,
				offY = 2,
			},
			zOrder = 128, --指定z值叠加
		},
		
		door_v = {
			objId = 4009,
			offsetX = 24,
			offsetY = 0,
			rot = 0,
			effect =
			{
				x = 128 * 0 + 2,
				y = 128 * 3 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 2,
				offY = -6,
			},
			zOrder = 128, --指定z值叠加
		},
		door_h = {
			objId = 4010,
			offsetX = 24,
			offsetY = 0,
			rot = 0,
			effect =
			{
				x = 128 * 1 + 2,
				y = 128 * 3 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 0,
				offY = -6,
			},
			zOrder = 128, --指定z值叠加
		},
		swall_v = {
			objId = 4011,
			offsetX = 24,
			offsetY = 0,
			effect =
			{
				x = 128 * 1 + 2,
				y = 128 * 1 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 0,
				offY = -3,
			},
			zOrder = 128, --指定z值叠加
		},
		swall_h = {
			objId = 4012,
			offsetX = 24,
			offsetY = 0,
			effect =
			{
				x = 128 * 2 + 2,
				y = 128 * 3 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 0,
				offY = -3,
			},
			zOrder = 128, --指定z值叠加
		},
		
		blocks = 
		{
			{
				objId = 5158,
				offsetX = 0,
				offsetY = 0,
				rot = 0,
			},
			{
				objId = 5159,
				offsetX = 0,
				offsetY = 0,
				rot = 0,
			},
			{
				objId = 5148,
				offsetX = 0,
				offsetY = 0,
				rot = 0,
			},
			{
				objId = 5149,
				offsetX = 0,
				offsetY = 0,
				rot = 0,
			},
		},
		
		--装饰物件
		renders =
		{
			--装饰物件1
			{
				x = 128 * 0 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件2
			{
				x = 128 * 1 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件3
			{
				x = 128 * 2 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件4
			{
				x = 128 * 3 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件5
			{
				x = 128 * 4 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件6
			{
				x = 128 * 5 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件7
			{
				x = 128 * 6 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件8
			{
				x = 128 * 7 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件9
			{
				x = 128 * 0 + 2,
				y = 128 * 5 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件10
			{
				x = 128 * 1 + 2,
				y = 128 * 5 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
		},
	},
	
	--裂纹风格
	[2] =
	{
		farobj = --地球远景层
		{
			img = {"data/image/maze/space_back_01.jpg", "data/image/maze/space_back_02.jpg", "data/image/maze/space_back_03.jpg", "data/image/maze/space_back_04.jpg", "data/image/maze/space_back_05.jpg", "data/image/maze/space_back_06.jpg",},
			num = 1,
			scale = 1.0,
			rollRatio = 0.1, --卷轴速率
		},
		middleobj = --星星中景层
		{
			img = {"data/image/maze/starlight.png",},
			num = 20,
			scale = {0.2, 0.7},
			rollRatio = 0.16, --卷轴速率
		},
		nearobj = --飞船近景层
		{
			img = {
				[1] =
				{
					x = 128 * 0 + 2,
					y = 128 * 6 + 2,
					w = 256 - 2 * 2,
					h = 256 - 2 * 2,
				},
				[2] =
				{
					x = 128 * 2 + 2,
					y = 128 * 6 + 2,
					w = 256 - 2 * 2,
					h = 256 - 2 * 2,
				},
				[3] =
				{
					x = 128 * 4 + 2,
					y = 128 * 6 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[4] =
				{
					x = 128 * 5 + 2,
					y = 128 * 6 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[5] =
				{
					x = 128 * 6 + 2,
					y = 128 * 6 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[6] =
				{
					x = 128 * 7 + 2,
					y = 128 * 6 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[7] =
				{
					x = 128 * 4 + 2,
					y = 128 * 7 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[8] =
				{
					x = 128 * 5 + 2,
					y = 128 * 7 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[9] =
				{
					x = 128 * 6 + 2,
					y = 128 * 7 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[10] =
				{
					x = 128 * 7 + 2,
					y = 128 * 7 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
			},
			num = 20,
			scale = {1.0, 2.0},
			rollRatio = 0.3, --卷轴速率
		},
		wallimg = "data/image/maze/mazeskin_highwall_002.png", --墙面图片（整合到一张图里）
		ground = { --地板
			[1] =
			{
				x = 128 * 4 + 2,
				y = 128 * 0 + 2,
				w = 256 - 2 * 2,
				h = 256 - 2 * 2,
				probablity = 60, --几率
			},
			[2] =
			{
				x = 128 * 6 + 2,
				y = 128 * 0 + 2,
				w = 256 - 2 * 2,
				h = 256 - 2 * 2,
				probablity = 35,
			},
			[3] =
			{
				x = 128 * 4 + 2,
				y = 128 * 2 + 2,
				w = 256 - 2 * 2,
				h = 256 - 2 * 2,
				probablity = 5,
			},
		},
		wall_l = {
			objId = 4001,
			offsetX = 24,
			offsetY = 24,
			effect =
			{
				x = 128 * 0 + 2,
				y = 128 * 1 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 24,
				offY = -1,
			},
			zOrder = -256, --指定z值很小
		},
		wall_r = {
			objId = 4002,
			offsetX = 24,
			offsetY = 24,
			effect =
			{
				x = 128 * 2 + 2,
				y = 128 * 1 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -28,
				offY = 1,
			},
			zOrder = -256, --指定z值很小
		},
		wall_t = {
			objId = 4003,
			offsetX = 48,
			offsetY = 0,
			effect =
			{
				x = 128 * 1 + 2,
				y = 128 * 0 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -3,
				offY = 18,
			},
			zOrder = -256, --指定z值很小
		},
		wall_b = {
			objId = 4004,
			offsetX = 48,
			offsetY = 0,
			effect =
			{
				x = 128 * 1 + 2,
				y = 128 * 2 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -3,
				offY = -26,
			},
			zOrder = -256, --指定z值很小
		},
		corner_lt = {
			objId = 4005,
			offsetX = 48,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 0 + 2,
				y = 128 * 0 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -7,
				offY = 2,
			},
			zOrder = -256, --指定z值很小
		},
		corner_rt = {
			objId = 4006,
			offsetX = 24,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 2 + 2,
				y = 128 * 0 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 18,
				offY = 2,
			},
			zOrder = -256, --指定z值很小
		},
		corner_lb = {
			objId = 4007,
			offsetX = 48,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 0 + 2,
				y = 128 * 2 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -7,
				offY = 3,
			},
			zOrder = -256, --指定z值很小
		},
		corner_rb = {
			objId = 4008,
			offsetX = 24,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 2 + 2,
				y = 128 * 2 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 18,
				offY = 2,
			},
			zOrder = -256, --指定z值很小
		},
		
		corner_lt1 = { --合并
			objId = 4014,
			offsetX = 48,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 3 + 2,
				y = 128 * 0 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -7,
				offY = 2,
			},
			zOrder = -256, --指定z值很小
		},
		corner_rt1 = { --合并
			objId = 4015,
			offsetX = 24,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 3 + 2,
				y = 128 * 2 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 18,
				offY = 2,
			},
			zOrder = -256, --指定z值很小
		},
		corner_lb1 = { --合并
			objId = 4016,
			offsetX = 48,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 3 + 2,
				y = 128 * 1 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -7,
				offY = 3,
			},
			zOrder = -256, --指定z值很小
		},
		corner_rb1 = { --合并
			objId = 4017,
			offsetX = 24,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 3 + 2,
				y = 128 * 3 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 18,
				offY = 2,
			},
			zOrder = -256, --指定z值很小
		},
		
		door_v = {
			objId = 4009,
			offsetX = 24,
			offsetY = 0,
			rot = 0,
			effect =
			{
				x = 128 * 0 + 2,
				y = 128 * 3 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 2,
				offY = -6,
			},
			zOrder = -256, --指定z值很小
		},
		door_h = {
			objId = 4010,
			offsetX = 24,
			offsetY = 0,
			rot = 0,
			effect =
			{
				x = 128 * 1 + 2,
				y = 128 * 3 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 0,
				offY = -6,
			},
			zOrder = -256, --指定z值很小
		},
		swall_v = {
			objId = 4011,
			offsetX = 24,
			offsetY = 0,
			effect =
			{
				x = 128 * 1 + 2,
				y = 128 * 1 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 0,
				offY = -3,
			},
			zOrder = -256, --指定z值很小
		},
		swall_h = {
			objId = 4012,
			offsetX = 24,
			offsetY = 0,
			effect =
			{
				x = 128 * 2 + 2,
				y = 128 * 3 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 0,
				offY = -3,
			},
			zOrder = -256, --指定z值很小
		},
		
		blocks = 
		{
			{
				objId = 5158,
				offsetX = 0,
				offsetY = 0,
				rot = 0,
			},
			{
				objId = 5159,
				offsetX = 0,
				offsetY = 0,
				rot = 0,
			},
			{
				objId = 5148,
				offsetX = 0,
				offsetY = 0,
				rot = 0,
			},
			{
				objId = 5149,
				offsetX = 0,
				offsetY = 0,
				rot = 0,
			},
		},
		
		--装饰物件
		renders =
		{
			--装饰物件1
			{
				x = 128 * 0 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件2
			{
				x = 128 * 1 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件3
			{
				x = 128 * 2 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件4
			{
				x = 128 * 3 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件5
			{
				x = 128 * 4 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件6
			{
				x = 128 * 5 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件7
			{
				x = 128 * 6 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件8
			{
				x = 128 * 7 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件9
			{
				x = 128 * 0 + 2,
				y = 128 * 5 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件10
			{
				x = 128 * 1 + 2,
				y = 128 * 5 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
		},
	},
	
	--无警戒线风格
	[3] =
	{
		farobj = --地球远景层
		{
			img = {"data/image/maze/space_back_01.jpg", "data/image/maze/space_back_02.jpg", "data/image/maze/space_back_03.jpg", "data/image/maze/space_back_04.jpg", "data/image/maze/space_back_05.jpg", "data/image/maze/space_back_06.jpg",},
			num = 1,
			scale = 1.0,
			rollRatio = 0.1, --卷轴速率
		},
		middleobj = --星星中景层
		{
			img = {"data/image/maze/starlight.png",},
			num = 20,
			scale = {0.2, 0.7},
			rollRatio = 0.16, --卷轴速率
		},
		nearobj = --飞船近景层
		{
			img = {
				[1] =
				{
					x = 128 * 0 + 2,
					y = 128 * 6 + 2,
					w = 256 - 2 * 2,
					h = 256 - 2 * 2,
				},
				[2] =
				{
					x = 128 * 2 + 2,
					y = 128 * 6 + 2,
					w = 256 - 2 * 2,
					h = 256 - 2 * 2,
				},
				[3] =
				{
					x = 128 * 4 + 2,
					y = 128 * 6 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[4] =
				{
					x = 128 * 5 + 2,
					y = 128 * 6 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[5] =
				{
					x = 128 * 6 + 2,
					y = 128 * 6 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[6] =
				{
					x = 128 * 7 + 2,
					y = 128 * 6 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[7] =
				{
					x = 128 * 4 + 2,
					y = 128 * 7 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[8] =
				{
					x = 128 * 5 + 2,
					y = 128 * 7 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[9] =
				{
					x = 128 * 6 + 2,
					y = 128 * 7 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[10] =
				{
					x = 128 * 7 + 2,
					y = 128 * 7 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
			},
			num = 20,
			scale = {1.0, 2.0},
			rollRatio = 0.3, --卷轴速率
		},
		wallimg = "data/image/maze/mazeskin_midwall_003.png", --墙面图片（整合到一张图里）
		ground = { --地板
			[1] =
			{
				x = 128 * 4 + 2,
				y = 128 * 0 + 2,
				w = 256 - 2 * 2,
				h = 256 - 2 * 2,
				probablity = 60, --几率
			},
			[2] =
			{
				x = 128 * 6 + 2,
				y = 128 * 0 + 2,
				w = 256 - 2 * 2,
				h = 256 - 2 * 2,
				probablity = 35,
			},
			[3] =
			{
				x = 128 * 4 + 2,
				y = 128 * 2 + 2,
				w = 256 - 2 * 2,
				h = 256 - 2 * 2,
				probablity = 5,
			},
		},
		wall_l = {
			objId = 4001,
			offsetX = 24,
			offsetY = 24,
			effect =
			{
				x = 128 * 0 + 2,
				y = 128 * 1 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 24,
				offY = -1,
			},
			zOrder = 128, --指定z值叠加
		},
		wall_r = {
			objId = 4002,
			offsetX = 24,
			offsetY = 24,
			effect =
			{
				x = 128 * 2 + 2,
				y = 128 * 1 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -28,
				offY = 1,
			},
			zOrder = 128, --指定z值叠加
		},
		wall_t = {
			objId = 4003,
			offsetX = 48,
			offsetY = 0,
			effect =
			{
				x = 128 * 1 + 2,
				y = 128 * 0 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -3,
				offY = 18,
			},
			zOrder = -256, --指定z值很小
		},
		wall_b = {
			objId = 4004,
			offsetX = 48,
			offsetY = 0,
			effect =
			{
				x = 128 * 1 + 2,
				y = 128 * 2 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -3,
				offY = -26,
			},
			zOrder = 128, --指定z值叠加
		},
		corner_lt = {
			objId = 4005,
			offsetX = 48,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 0 + 2,
				y = 128 * 0 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -7,
				offY = 2,
			},
			zOrder = -256, --指定z值很小
		},
		corner_rt = {
			objId = 4006,
			offsetX = 24,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 2 + 2,
				y = 128 * 0 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 18,
				offY = 2,
			},
			zOrder = -256, --指定z值很小
		},
		corner_lb = {
			objId = 4007,
			offsetX = 48,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 0 + 2,
				y = 128 * 2 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -7,
				offY = 3,
			},
			zOrder = 128, --指定z值叠加
		},
		corner_rb = {
			objId = 4008,
			offsetX = 24,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 2 + 2,
				y = 128 * 2 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 18,
				offY = 2,
			},
			zOrder = 128, --指定z值叠加
		},
		
		corner_lt1 = { --合并
			objId = 4014,
			offsetX = 48,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 3 + 2,
				y = 128 * 0 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -7,
				offY = 2,
			},
			zOrder = 128, --指定z值叠加
		},
		corner_rt1 = { --合并
			objId = 4015,
			offsetX = 24,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 3 + 2,
				y = 128 * 2 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 18,
				offY = 2,
			},
			zOrder = 128, --指定z值叠加
		},
		corner_lb1 = { --合并
			objId = 4016,
			offsetX = 48,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 3 + 2,
				y = 128 * 1 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -7,
				offY = 3,
			},
			zOrder = 128, --指定z值叠加
		},
		corner_rb1 = { --合并
			objId = 4017,
			offsetX = 24,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 3 + 2,
				y = 128 * 3 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 18,
				offY = 2,
			},
			zOrder = 128, --指定z值叠加
		},
		
		door_v = {
			objId = 4009,
			offsetX = 24,
			offsetY = 0,
			rot = 0,
			effect =
			{
				x = 128 * 0 + 2,
				y = 128 * 3 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 2,
				offY = -6,
			},
			zOrder = 128, --指定z值叠加
		},
		door_h = {
			objId = 4010,
			offsetX = 24,
			offsetY = 0,
			rot = 0,
			effect =
			{
				x = 128 * 1 + 2,
				y = 128 * 3 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 0,
				offY = -6,
			},
			zOrder = 128, --指定z值叠加
		},
		swall_v = {
			objId = 4011,
			offsetX = 24,
			offsetY = 0,
			effect =
			{
				x = 128 * 1 + 2,
				y = 128 * 1 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 0,
				offY = -3,
			},
			zOrder = 128, --指定z值叠加
		},
		swall_h = {
			objId = 4012,
			offsetX = 24,
			offsetY = 0,
			effect =
			{
				x = 128 * 2 + 2,
				y = 128 * 3 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 0,
				offY = -3,
			},
			zOrder = 128, --指定z值叠加
		},
		
		blocks = 
		{
			{
				objId = 5158,
				offsetX = 0,
				offsetY = 0,
				rot = 0,
			},
			{
				objId = 5159,
				offsetX = 0,
				offsetY = 0,
				rot = 0,
			},
			{
				objId = 5148,
				offsetX = 0,
				offsetY = 0,
				rot = 0,
			},
			{
				objId = 5149,
				offsetX = 0,
				offsetY = 0,
				rot = 0,
			},
		},
		
		--装饰物件
		renders =
		{
			--装饰物件1
			{
				x = 128 * 0 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件2
			{
				x = 128 * 1 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件3
			{
				x = 128 * 2 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件4
			{
				x = 128 * 3 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件5
			{
				x = 128 * 4 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件6
			{
				x = 128 * 5 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件7
			{
				x = 128 * 6 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件8
			{
				x = 128 * 7 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件9
			{
				x = 128 * 0 + 2,
				y = 128 * 5 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件10
			{
				x = 128 * 1 + 2,
				y = 128 * 5 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
		},
	},
	
	--Dune 沙土风格
	[4] =
	{
		farobj = --地球远景层
		{
			img = {"data/image/maze/space_back_01.jpg", "data/image/maze/space_back_02.jpg", "data/image/maze/space_back_03.jpg", "data/image/maze/space_back_04.jpg", "data/image/maze/space_back_05.jpg", "data/image/maze/space_back_06.jpg",},
			num = 1,
			scale = 1.0,
			rollRatio = 0.1, --卷轴速率
		},
		middleobj = --星星中景层
		{
			img = {"data/image/maze/starlight.png",},
			num = 20,
			scale = {0.2, 0.7},
			rollRatio = 0.16, --卷轴速率
		},
		nearobj = --飞船近景层
		{
			img = {
				[1] =
				{
					x = 128 * 0 + 2,
					y = 128 * 6 + 2,
					w = 256 - 2 * 2,
					h = 256 - 2 * 2,
				},
				[2] =
				{
					x = 128 * 2 + 2,
					y = 128 * 6 + 2,
					w = 256 - 2 * 2,
					h = 256 - 2 * 2,
				},
				[3] =
				{
					x = 128 * 4 + 2,
					y = 128 * 6 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[4] =
				{
					x = 128 * 5 + 2,
					y = 128 * 6 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[5] =
				{
					x = 128 * 6 + 2,
					y = 128 * 6 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[6] =
				{
					x = 128 * 7 + 2,
					y = 128 * 6 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[7] =
				{
					x = 128 * 4 + 2,
					y = 128 * 7 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[8] =
				{
					x = 128 * 5 + 2,
					y = 128 * 7 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[9] =
				{
					x = 128 * 6 + 2,
					y = 128 * 7 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[10] =
				{
					x = 128 * 7 + 2,
					y = 128 * 7 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
			},
			num = 20,
			scale = {1.0, 2.0},
			rollRatio = 0.3, --卷轴速率
		},
		wallimg = "data/image/maze/mazeskin_flatwall_004.png", --墙面图片（整合到一张图里）
		ground = { --地板
			[1] =
			{
				x = 128 * 4 + 2,
				y = 128 * 0 + 2,
				w = 256 - 2 * 2,
				h = 256 - 2 * 2,
				probablity = 60, --几率
			},
			[2] =
			{
				x = 128 * 6 + 2,
				y = 128 * 0 + 2,
				w = 256 - 2 * 2,
				h = 256 - 2 * 2,
				probablity = 35,
			},
			[3] =
			{
				x = 128 * 4 + 2,
				y = 128 * 2 + 2,
				w = 256 - 2 * 2,
				h = 256 - 2 * 2,
				probablity = 5,
			},
		},
		wall_l = {
			objId = 4101,
			offsetX = 24,
			offsetY = 24,
			effect =
			{
				x = 128 * 0 + 2,
				y = 128 * 1 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 24,
				offY = -1,
			},
			zOrder = -2048, --指定z值很小
		},
		wall_r = {
			objId = 4102,
			offsetX = 24,
			offsetY = 24,
			effect =
			{
				x = 128 * 2 + 2,
				y = 128 * 1 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -28,
				offY = 1,
			},
			zOrder = -256, --指定z值很小
		},
		wall_t = {
			objId = 4103,
			offsetX = 48,
			offsetY = 0,
			effect =
			{
				x = 128 * 1 + 2,
				y = 128 * 0 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -3,
				offY = 18,
			},
			zOrder = -2048, --指定z值很小
		},
		wall_b = {
			objId = 4104,
			offsetX = 48,
			offsetY = 0,
			effect =
			{
				x = 128 * 1 + 2,
				y = 128 * 2 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -3,
				offY = -26,
			},
			zOrder = -2048, --指定z值很小
		},
		corner_lt = {
			objId = 4105,
			offsetX = 48,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 0 + 2,
				y = 128 * 0 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -7,
				offY = 2,
			},
			zOrder = -2048, --指定z值很小
		},
		corner_rt = {
			objId = 4106,
			offsetX = 24,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 2 + 2,
				y = 128 * 0 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 18,
				offY = 2,
			},
			zOrder = -2048, --指定z值很小
		},
		corner_lb = {
			objId = 4107,
			offsetX = 48,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 0 + 2,
				y = 128 * 2 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -7,
				offY = 3,
			},
			zOrder = -2048, --指定z值很小
		},
		corner_rb = {
			objId = 4108,
			offsetX = 24,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 2 + 2,
				y = 128 * 2 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 18,
				offY = 2,
			},
			zOrder = -2048, --指定z值很小
		},
		
		corner_lt1 = { --合并
			objId = 4114,
			offsetX = 48,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 3 + 2,
				y = 128 * 0 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -7,
				offY = 2,
			},
			zOrder = -2048, --指定z值很小
		},
		corner_rt1 = { --合并
			objId = 4115,
			offsetX = 24,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 3 + 2,
				y = 128 * 2 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 18,
				offY = 2,
			},
			zOrder = -2048, --指定z值很小
		},
		corner_lb1 = { --合并
			objId = 4116,
			offsetX = 48,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 3 + 2,
				y = 128 * 1 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -7,
				offY = 3,
			},
			zOrder = -2048, --指定z值很小
		},
		corner_rb1 = { --合并
			objId = 4117,
			offsetX = 24,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 3 + 2,
				y = 128 * 3 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 18,
				offY = 2,
			},
			zOrder = -2048, --指定z值很小
		},
		
		door_v = {
			objId = 4109,
			offsetX = 24,
			offsetY = 0,
			rot = 0,
			effect =
			{
				x = 128 * 0 + 2,
				y = 128 * 3 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 2,
				offY = -6,
			},
			zOrder = -256, --指定z值很小
		},
		door_h = {
			objId = 4110,
			offsetX = 24,
			offsetY = 0,
			rot = 0,
			effect =
			{
				x = 128 * 1 + 2,
				y = 128 * 3 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 0,
				offY = -6,
			},
			zOrder = -256, --指定z值很小
		},
		swall_v = {
			objId = 4111,
			offsetX = 24,
			offsetY = 0,
			effect =
			{
				x = 128 * 1 + 2,
				y = 128 * 1 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 0,
				offY = -3,
			},
			zOrder = -2048, --指定z值很小
		},
		swall_h = {
			objId = 4112,
			offsetX = 24,
			offsetY = 0,
			effect =
			{
				x = 128 * 2 + 2,
				y = 128 * 3 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 0,
				offY = -3,
			},
			zOrder = -2048, --指定z值很小
		},
		
		blocks = 
		{
			{
				objId = 5158,
				offsetX = 0,
				offsetY = 0,
				rot = 0,
			},
			{
				objId = 5159,
				offsetX = 0,
				offsetY = 0,
				rot = 0,
			},
			{
				objId = 5148,
				offsetX = 0,
				offsetY = 0,
				rot = 0,
			},
			{
				objId = 5149,
				offsetX = 0,
				offsetY = 0,
				rot = 0,
			},
		},
		
		--装饰物件
		renders =
		{
			--装饰物件1
			{
				x = 128 * 0 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件2
			{
				x = 128 * 1 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件3
			{
				x = 128 * 2 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件4
			{
				x = 128 * 3 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件5
			{
				x = 128 * 4 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件6
			{
				x = 128 * 5 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件7
			{
				x = 128 * 6 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件8
			{
				x = 128 * 7 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件9
			{
				x = 128 * 0 + 2,
				y = 128 * 5 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件10
			{
				x = 128 * 1 + 2,
				y = 128 * 5 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
		},
	},
	
	--damaged spaceship deck
	[5] =
	{
		farobj = --地球远景层
		{
			img = {"data/image/maze/space_back_01.jpg", "data/image/maze/space_back_02.jpg", "data/image/maze/space_back_03.jpg", "data/image/maze/space_back_04.jpg", "data/image/maze/space_back_05.jpg", "data/image/maze/space_back_06.jpg",},
			num = 1,
			scale = 1.0,
			rollRatio = 0.1, --卷轴速率
		},
		middleobj = --星星中景层
		{
			img = {"data/image/maze/starlight.png",},
			num = 20,
			scale = {0.2, 0.7},
			rollRatio = 0.16, --卷轴速率
		},
		nearobj = --飞船近景层
		{
			img = {
				[1] =
				{
					x = 128 * 0 + 2,
					y = 128 * 6 + 2,
					w = 256 - 2 * 2,
					h = 256 - 2 * 2,
				},
				[2] =
				{
					x = 128 * 2 + 2,
					y = 128 * 6 + 2,
					w = 256 - 2 * 2,
					h = 256 - 2 * 2,
				},
				[3] =
				{
					x = 128 * 4 + 2,
					y = 128 * 6 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[4] =
				{
					x = 128 * 5 + 2,
					y = 128 * 6 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[5] =
				{
					x = 128 * 6 + 2,
					y = 128 * 6 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[6] =
				{
					x = 128 * 7 + 2,
					y = 128 * 6 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[7] =
				{
					x = 128 * 4 + 2,
					y = 128 * 7 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[8] =
				{
					x = 128 * 5 + 2,
					y = 128 * 7 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[9] =
				{
					x = 128 * 6 + 2,
					y = 128 * 7 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[10] =
				{
					x = 128 * 7 + 2,
					y = 128 * 7 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
			},
			num = 20,
			scale = {1.0, 2.0},
			rollRatio = 0.3, --卷轴速率
		},
		wallimg = "data/image/maze/mazeskin_flatwall_005.png", --墙面图片（整合到一张图里）
		ground = { --地板
			[1] =
			{
				x = 128 * 4 + 2,
				y = 128 * 0 + 2,
				w = 256 - 2 * 2,
				h = 256 - 2 * 2,
				probablity = 60, --几率
			},
			[2] =
			{
				x = 128 * 6 + 2,
				y = 128 * 0 + 2,
				w = 256 - 2 * 2,
				h = 256 - 2 * 2,
				probablity = 35,
			},
			[3] =
			{
				x = 128 * 4 + 2,
				y = 128 * 2 + 2,
				w = 256 - 2 * 2,
				h = 256 - 2 * 2,
				probablity = 5,
			},
		},
		wall_l = {
			objId = 4101,
			offsetX = 24,
			offsetY = 24,
			effect =
			{
				x = 128 * 0 + 2,
				y = 128 * 1 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 24,
				offY = -1,
			},
			zOrder = -12048, --指定z值很小
		},
		wall_r = {
			objId = 4102,
			offsetX = 24,
			offsetY = 24,
			effect =
			{
				x = 128 * 2 + 2,
				y = 128 * 1 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -28,
				offY = 1,
			},
			zOrder = -12048, --指定z值很小
		},
		wall_t = {
			objId = 4103,
			offsetX = 48,
			offsetY = 0,
			effect =
			{
				x = 128 * 1 + 2,
				y = 128 * 0 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -3,
				offY = 18,
			},
			zOrder = -12048, --指定z值很小
		},
		wall_b = {
			objId = 4104,
			offsetX = 48,
			offsetY = 0,
			effect =
			{
				x = 128 * 1 + 2,
				y = 128 * 2 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -3,
				offY = -26,
			},
			zOrder = -12048, --指定z值很小
		},
		corner_lt = {
			objId = 4105,
			offsetX = 48,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 0 + 2,
				y = 128 * 0 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -7,
				offY = 2,
			},
			zOrder = -12048, --指定z值很小
		},
		corner_rt = {
			objId = 4106,
			offsetX = 24,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 2 + 2,
				y = 128 * 0 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 18,
				offY = 2,
			},
			zOrder = -12048, --指定z值很小
		},
		corner_lb = {
			objId = 4107,
			offsetX = 48,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 0 + 2,
				y = 128 * 2 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -7,
				offY = 3,
			},
			zOrder = -12048, --指定z值很小
		},
		corner_rb = {
			objId = 4108,
			offsetX = 24,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 2 + 2,
				y = 128 * 2 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 18,
				offY = 2,
			},
			zOrder = -12048, --指定z值很小
		},
		
		corner_lt1 = { --合并
			objId = 4114,
			offsetX = 48,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 3 + 2,
				y = 128 * 0 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -7,
				offY = 2,
			},
			zOrder = -12048, --指定z值很小
		},
		corner_rt1 = { --合并
			objId = 4115,
			offsetX = 24,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 3 + 2,
				y = 128 * 2 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 18,
				offY = 2,
			},
			zOrder = -12048, --指定z值很小
		},
		corner_lb1 = { --合并
			objId = 4116,
			offsetX = 48,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 3 + 2,
				y = 128 * 1 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -7,
				offY = 3,
			},
			zOrder = -12048, --指定z值很小
		},
		corner_rb1 = { --合并
			objId = 4117,
			offsetX = 24,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 3 + 2,
				y = 128 * 3 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 18,
				offY = 2,
			},
			zOrder = -12048, --指定z值很小
		},
		
		door_v = {
			objId = 4109,
			offsetX = 24,
			offsetY = 0,
			rot = 0,
			effect =
			{
				x = 128 * 0 + 2,
				y = 128 * 3 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 2,
				offY = -6,
			},
			zOrder = -12048, --指定z值很小
		},
		door_h = {
			objId = 4110,
			offsetX = 24,
			offsetY = 0,
			rot = 0,
			effect =
			{
				x = 128 * 1 + 2,
				y = 128 * 3 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 0,
				offY = -6,
			},
			zOrder = -12048, --指定z值很小
		},
		swall_v = {
			objId = 4111,
			offsetX = 24,
			offsetY = 0,
			effect =
			{
				x = 128 * 1 + 2,
				y = 128 * 1 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 0,
				offY = -3,
			},
			zOrder = -2048, --指定z值很小
		},
		swall_h = {
			objId = 4112,
			offsetX = 24,
			offsetY = 0,
			effect =
			{
				x = 128 * 2 + 2,
				y = 128 * 3 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 0,
				offY = -3,
			},
			zOrder = -2048, --指定z值很小
		},
		
		blocks = 
		{
			{
				objId = 5158,
				offsetX = 0,
				offsetY = 0,
				rot = 0,
			},
			{
				objId = 5159,
				offsetX = 0,
				offsetY = 0,
				rot = 0,
			},
			{
				objId = 5148,
				offsetX = 0,
				offsetY = 0,
				rot = 0,
			},
			{
				objId = 5149,
				offsetX = 0,
				offsetY = 0,
				rot = 0,
			},
		},
		
		--装饰物件
		renders =
		{
			--装饰物件1
			{
				x = 128 * 0 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件2
			{
				x = 128 * 1 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件3
			{
				x = 128 * 2 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件4
			{
				x = 128 * 3 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件5
			{
				x = 128 * 4 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件6
			{
				x = 128 * 5 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件7
			{
				x = 128 * 6 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件8
			{
				x = 128 * 7 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件9
			{
				x = 128 * 0 + 2,
				y = 128 * 5 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件10
			{
				x = 128 * 1 + 2,
				y = 128 * 5 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
		},
	},
	
	--冰窖风格
	[6] =
	{
		farobj = --地球远景层
		{
			img = {"data/image/maze/space_back_01.jpg", "data/image/maze/space_back_02.jpg", "data/image/maze/space_back_03.jpg", "data/image/maze/space_back_04.jpg", "data/image/maze/space_back_05.jpg", "data/image/maze/space_back_06.jpg",},
			num = 1,
			scale = 1.0,
			rollRatio = 0.1, --卷轴速率
		},
		middleobj = --星星中景层
		{
			img = {"data/image/maze/starlight.png",},
			num = 20,
			scale = {0.2, 0.7},
			rollRatio = 0.16, --卷轴速率
		},
		nearobj = --飞船近景层
		{
			img = {
				[1] =
				{
					x = 128 * 0 + 2,
					y = 128 * 6 + 2,
					w = 256 - 2 * 2,
					h = 256 - 2 * 2,
				},
				[2] =
				{
					x = 128 * 2 + 2,
					y = 128 * 6 + 2,
					w = 256 - 2 * 2,
					h = 256 - 2 * 2,
				},
				[3] =
				{
					x = 128 * 4 + 2,
					y = 128 * 6 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[4] =
				{
					x = 128 * 5 + 2,
					y = 128 * 6 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[5] =
				{
					x = 128 * 6 + 2,
					y = 128 * 6 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[6] =
				{
					x = 128 * 7 + 2,
					y = 128 * 6 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[7] =
				{
					x = 128 * 4 + 2,
					y = 128 * 7 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[8] =
				{
					x = 128 * 5 + 2,
					y = 128 * 7 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[9] =
				{
					x = 128 * 6 + 2,
					y = 128 * 7 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[10] =
				{
					x = 128 * 7 + 2,
					y = 128 * 7 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
			},
			num = 20,
			scale = {1.0, 2.0},
			rollRatio = 0.3, --卷轴速率
		},
		wallimg = "data/image/maze/mazeskin_highwall_006.png", --墙面图片（整合到一张图里）
		ground = { --地板
			[1] =
			{
				x = 128 * 4 + 2,
				y = 128 * 0 + 2,
				w = 256 - 2 * 2,
				h = 256 - 2 * 2,
				probablity = 60, --几率
			},
			[2] =
			{
				x = 128 * 6 + 2,
				y = 128 * 0 + 2,
				w = 256 - 2 * 2,
				h = 256 - 2 * 2,
				probablity = 35,
			},
			[3] =
			{
				x = 128 * 4 + 2,
				y = 128 * 2 + 2,
				w = 256 - 2 * 2,
				h = 256 - 2 * 2,
				probablity = 5,
			},
		},
		wall_l = {
			objId = 4001,
			offsetX = 24,
			offsetY = 24,
			effect =
			{
				x = 128 * 0 + 2,
				y = 128 * 1 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 24,
				offY = -1,
			},
			zOrder = -256, --指定z值很小
		},
		wall_r = {
			objId = 4002,
			offsetX = 24,
			offsetY = 24,
			effect =
			{
				x = 128 * 2 + 2,
				y = 128 * 1 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -28,
				offY = 1,
			},
			zOrder = -256, --指定z值很小
		},
		wall_t = {
			objId = 4003,
			offsetX = 48,
			offsetY = 0,
			effect =
			{
				x = 128 * 1 + 2,
				y = 128 * 0 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -3,
				offY = 18,
			},
			zOrder = -256, --指定z值很小
		},
		wall_b = {
			objId = 4004,
			offsetX = 48,
			offsetY = 0,
			effect =
			{
				x = 128 * 1 + 2,
				y = 128 * 2 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -3,
				offY = -26,
			},
			zOrder = -256, --指定z值很小
		},
		corner_lt = {
			objId = 4005,
			offsetX = 48,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 0 + 2,
				y = 128 * 0 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -7,
				offY = 2,
			},
			zOrder = -256, --指定z值很小
		},
		corner_rt = {
			objId = 4006,
			offsetX = 24,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 2 + 2,
				y = 128 * 0 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 18,
				offY = 2,
			},
			zOrder = -256, --指定z值很小
		},
		corner_lb = {
			objId = 4007,
			offsetX = 48,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 0 + 2,
				y = 128 * 2 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -7,
				offY = 3,
			},
			zOrder = -256, --指定z值很小
		},
		corner_rb = {
			objId = 4008,
			offsetX = 24,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 2 + 2,
				y = 128 * 2 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 18,
				offY = 2,
			},
			zOrder = -256, --指定z值很小
		},
		
		corner_lt1 = { --合并
			objId = 4014,
			offsetX = 48,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 3 + 2,
				y = 128 * 0 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -7,
				offY = 2,
			},
			zOrder = -256, --指定z值很小
		},
		corner_rt1 = { --合并
			objId = 4015,
			offsetX = 24,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 3 + 2,
				y = 128 * 2 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 18,
				offY = 2,
			},
			zOrder = -256, --指定z值很小
		},
		corner_lb1 = { --合并
			objId = 4016,
			offsetX = 48,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 3 + 2,
				y = 128 * 1 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -7,
				offY = 3,
			},
			zOrder = -256, --指定z值很小
		},
		corner_rb1 = { --合并
			objId = 4017,
			offsetX = 24,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 3 + 2,
				y = 128 * 3 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 18,
				offY = 2,
			},
			zOrder = -256, --指定z值很小
		},
		
		door_v = {
			objId = 4009,
			offsetX = 24,
			offsetY = 0,
			rot = 0,
			effect =
			{
				x = 128 * 0 + 2,
				y = 128 * 3 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 2,
				offY = -6,
			},
			zOrder = -256, --指定z值很小
		},
		door_h = {
			objId = 4010,
			offsetX = 24,
			offsetY = 0,
			rot = 0,
			effect =
			{
				x = 128 * 1 + 2,
				y = 128 * 3 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 0,
				offY = -6,
			},
			zOrder = -256, --指定z值很小
		},
		swall_v = {
			objId = 4011,
			offsetX = 24,
			offsetY = 0,
			effect =
			{
				x = 128 * 1 + 2,
				y = 128 * 1 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 0,
				offY = -3,
			},
			zOrder = -256, --指定z值很小
		},
		swall_h = {
			objId = 4012,
			offsetX = 24,
			offsetY = 0,
			effect =
			{
				x = 128 * 2 + 2,
				y = 128 * 3 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 0,
				offY = -3,
			},
			zOrder = -256, --指定z值很小
		},
		
		blocks = 
		{
			{
				objId = 5158,
				offsetX = 0,
				offsetY = 0,
				rot = 0,
			},
			{
				objId = 5159,
				offsetX = 0,
				offsetY = 0,
				rot = 0,
			},
			{
				objId = 5148,
				offsetX = 0,
				offsetY = 0,
				rot = 0,
			},
			{
				objId = 5149,
				offsetX = 0,
				offsetY = 0,
				rot = 0,
			},
		},
		
		--装饰物件
		renders =
		{
			--装饰物件1
			{
				x = 128 * 0 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件2
			{
				x = 128 * 1 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件3
			{
				x = 128 * 2 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件4
			{
				x = 128 * 3 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件5
			{
				x = 128 * 4 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件6
			{
				x = 128 * 5 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件7
			{
				x = 128 * 6 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件8
			{
				x = 128 * 7 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件9
			{
				x = 128 * 0 + 2,
				y = 128 * 5 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件10
			{
				x = 128 * 1 + 2,
				y = 128 * 5 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
		},
	},
	
	--mazeskin_011
	[7] =
	{
		farobj = --地球远景层
		{
			img = {"data/image/maze/space_back_01.jpg", "data/image/maze/space_back_02.jpg", "data/image/maze/space_back_03.jpg", "data/image/maze/space_back_04.jpg", "data/image/maze/space_back_05.jpg", "data/image/maze/space_back_06.jpg",},
			num = 1,
			scale = 1.0,
			rollRatio = 0.1, --卷轴速率
		},
		middleobj = --星星中景层
		{
			img = {"data/image/maze/starlight.png",},
			num = 20,
			scale = {0.2, 0.7},
			rollRatio = 0.16, --卷轴速率
		},
		nearobj = --飞船近景层
		{
			img = {
				[1] =
				{
					x = 128 * 0 + 2,
					y = 128 * 6 + 2,
					w = 256 - 2 * 2,
					h = 256 - 2 * 2,
				},
				[2] =
				{
					x = 128 * 2 + 2,
					y = 128 * 6 + 2,
					w = 256 - 2 * 2,
					h = 256 - 2 * 2,
				},
				[3] =
				{
					x = 128 * 4 + 2,
					y = 128 * 6 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[4] =
				{
					x = 128 * 5 + 2,
					y = 128 * 6 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[5] =
				{
					x = 128 * 6 + 2,
					y = 128 * 6 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[6] =
				{
					x = 128 * 7 + 2,
					y = 128 * 6 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[7] =
				{
					x = 128 * 4 + 2,
					y = 128 * 7 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[8] =
				{
					x = 128 * 5 + 2,
					y = 128 * 7 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[9] =
				{
					x = 128 * 6 + 2,
					y = 128 * 7 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[10] =
				{
					x = 128 * 7 + 2,
					y = 128 * 7 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
			},
			num = 20,
			scale = {1.0, 2.0},
			rollRatio = 0.3, --卷轴速率
		},
		wallimg = "data/image/maze/mazeskin_011.png", --墙面图片（整合到一张图里）
		ground = { --地板
			[1] =
			{
				x = 128 * 4 + 2,
				y = 128 * 0 + 2,
				w = 256 - 2 * 2,
				h = 256 - 2 * 2,
				probablity = 60, --几率
			},
			[2] =
			{
				x = 128 * 6 + 2,
				y = 128 * 0 + 2,
				w = 256 - 2 * 2,
				h = 256 - 2 * 2,
				probablity = 35,
			},
			[3] =
			{
				x = 128 * 4 + 2,
				y = 128 * 2 + 2,
				w = 256 - 2 * 2,
				h = 256 - 2 * 2,
				probablity = 5,
			},
		},
		wall_l = {
			objId = 4101,
			offsetX = 24,
			offsetY = 24,
			effect =
			{
				x = 128 * 0 + 2,
				y = 128 * 1 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 24,
				offY = -1,
			},
			zOrder = -12048, --指定z值很小
		},
		wall_r = {
			objId = 4102,
			offsetX = 24,
			offsetY = 24,
			effect =
			{
				x = 128 * 2 + 2,
				y = 128 * 1 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -28,
				offY = 1,
			},
			zOrder = -12048, --指定z值很小
		},
		wall_t = {
			objId = 4103,
			offsetX = 48,
			offsetY = 0,
			effect =
			{
				x = 128 * 1 + 2,
				y = 128 * 0 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -3,
				offY = 18,
			},
			zOrder = -12048, --指定z值很小
		},
		wall_b = {
			objId = 4104,
			offsetX = 48,
			offsetY = 0,
			effect =
			{
				x = 128 * 1 + 2,
				y = 128 * 2 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -3,
				offY = -26,
			},
			zOrder = -12048, --指定z值很小
		},
		corner_lt = {
			objId = 4105,
			offsetX = 48,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 0 + 2,
				y = 128 * 0 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -7,
				offY = 2,
			},
			zOrder = -12048, --指定z值很小
		},
		corner_rt = {
			objId = 4106,
			offsetX = 24,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 2 + 2,
				y = 128 * 0 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 18,
				offY = 2,
			},
			zOrder = -12048, --指定z值很小
		},
		corner_lb = {
			objId = 4107,
			offsetX = 48,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 0 + 2,
				y = 128 * 2 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -7,
				offY = 3,
			},
			zOrder = -12048, --指定z值很小
		},
		corner_rb = {
			objId = 4108,
			offsetX = 24,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 2 + 2,
				y = 128 * 2 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 18,
				offY = 2,
			},
			zOrder = -12048, --指定z值很小
		},
		
		corner_lt1 = { --合并
			objId = 4114,
			offsetX = 48,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 3 + 2,
				y = 128 * 0 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -7,
				offY = 2,
			},
			zOrder = -12048, --指定z值很小
		},
		corner_rt1 = { --合并
			objId = 4115,
			offsetX = 24,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 3 + 2,
				y = 128 * 2 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 18,
				offY = 2,
			},
			zOrder = -12048, --指定z值很小
		},
		corner_lb1 = { --合并
			objId = 4116,
			offsetX = 48,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 3 + 2,
				y = 128 * 1 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -7,
				offY = 3,
			},
			zOrder = -12048, --指定z值很小
		},
		corner_rb1 = { --合并
			objId = 4117,
			offsetX = 24,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 3 + 2,
				y = 128 * 3 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 18,
				offY = 2,
			},
			zOrder = -12048, --指定z值很小
		},
		
		door_v = {
			objId = 4109,
			offsetX = 24,
			offsetY = 0,
			rot = 0,
			effect =
			{
				x = 128 * 0 + 2,
				y = 128 * 3 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 2,
				offY = -6,
			},
			zOrder = -12048, --指定z值很小
		},
		door_h = {
			objId = 4110,
			offsetX = 24,
			offsetY = 0,
			rot = 0,
			effect =
			{
				x = 128 * 1 + 2,
				y = 128 * 3 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 0,
				offY = -6,
			},
			zOrder = -12048, --指定z值很小
		},
		swall_v = {
			objId = 4111,
			offsetX = 24,
			offsetY = 0,
			effect =
			{
				x = 128 * 1 + 2,
				y = 128 * 1 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 0,
				offY = -3,
			},
			zOrder = -2048, --指定z值很小
		},
		swall_h = {
			objId = 4112,
			offsetX = 24,
			offsetY = 0,
			effect =
			{
				x = 128 * 2 + 2,
				y = 128 * 3 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 0,
				offY = -3,
			},
			zOrder = -2048, --指定z值很小
		},
		
		blocks = 
		{
			{
				objId = 5158,
				offsetX = 0,
				offsetY = 0,
				rot = 0,
			},
			{
				objId = 5159,
				offsetX = 0,
				offsetY = 0,
				rot = 0,
			},
			{
				objId = 5148,
				offsetX = 0,
				offsetY = 0,
				rot = 0,
			},
			{
				objId = 5149,
				offsetX = 0,
				offsetY = 0,
				rot = 0,
			},
		},
		
		--装饰物件
		renders =
		{
			--装饰物件1
			{
				x = 128 * 0 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件2
			{
				x = 128 * 1 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件3
			{
				x = 128 * 2 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件4
			{
				x = 128 * 3 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件5
			{
				x = 128 * 4 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件6
			{
				x = 128 * 5 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件7
			{
				x = 128 * 6 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件8
			{
				x = 128 * 7 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件9
			{
				x = 128 * 0 + 2,
				y = 128 * 5 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件10
			{
				x = 128 * 1 + 2,
				y = 128 * 5 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
		},
	},
	
	--mazeskin_012
	[8] =
	{
		farobj = --地球远景层
		{
			img = {"data/image/maze/space_back_01.jpg", "data/image/maze/space_back_02.jpg", "data/image/maze/space_back_03.jpg", "data/image/maze/space_back_04.jpg", "data/image/maze/space_back_05.jpg", "data/image/maze/space_back_06.jpg",},
			num = 1,
			scale = 1.0,
			rollRatio = 0.1, --卷轴速率
		},
		middleobj = --星星中景层
		{
			img = {"data/image/maze/starlight.png",},
			num = 20,
			scale = {0.2, 0.7},
			rollRatio = 0.16, --卷轴速率
		},
		nearobj = --飞船近景层
		{
			img = {
				[1] =
				{
					x = 128 * 0 + 2,
					y = 128 * 6 + 2,
					w = 256 - 2 * 2,
					h = 256 - 2 * 2,
				},
				[2] =
				{
					x = 128 * 2 + 2,
					y = 128 * 6 + 2,
					w = 256 - 2 * 2,
					h = 256 - 2 * 2,
				},
				[3] =
				{
					x = 128 * 4 + 2,
					y = 128 * 6 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[4] =
				{
					x = 128 * 5 + 2,
					y = 128 * 6 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[5] =
				{
					x = 128 * 6 + 2,
					y = 128 * 6 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[6] =
				{
					x = 128 * 7 + 2,
					y = 128 * 6 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[7] =
				{
					x = 128 * 4 + 2,
					y = 128 * 7 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[8] =
				{
					x = 128 * 5 + 2,
					y = 128 * 7 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[9] =
				{
					x = 128 * 6 + 2,
					y = 128 * 7 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[10] =
				{
					x = 128 * 7 + 2,
					y = 128 * 7 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
			},
			num = 20,
			scale = {1.0, 2.0},
			rollRatio = 0.3, --卷轴速率
		},
		wallimg = "data/image/maze/mazeskin_012.png", --墙面图片（整合到一张图里）
		ground = { --地板
			[1] =
			{
				x = 128 * 4 + 2,
				y = 128 * 0 + 2,
				w = 256 - 2 * 2,
				h = 256 - 2 * 2,
				probablity = 60, --几率
			},
			[2] =
			{
				x = 128 * 6 + 2,
				y = 128 * 0 + 2,
				w = 256 - 2 * 2,
				h = 256 - 2 * 2,
				probablity = 35,
			},
			[3] =
			{
				x = 128 * 4 + 2,
				y = 128 * 2 + 2,
				w = 256 - 2 * 2,
				h = 256 - 2 * 2,
				probablity = 5,
			},
		},
		wall_l = {
			objId = 4101,
			offsetX = 24,
			offsetY = 24,
			effect =
			{
				x = 128 * 0 + 2,
				y = 128 * 1 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 24,
				offY = -1,
			},
			zOrder = -12048, --指定z值很小
		},
		wall_r = {
			objId = 4102,
			offsetX = 24,
			offsetY = 24,
			effect =
			{
				x = 128 * 2 + 2,
				y = 128 * 1 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -28,
				offY = 1,
			},
			zOrder = -12048, --指定z值很小
		},
		wall_t = {
			objId = 4103,
			offsetX = 48,
			offsetY = 0,
			effect =
			{
				x = 128 * 1 + 2,
				y = 128 * 0 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -3,
				offY = 18,
			},
			zOrder = -12048, --指定z值很小
		},
		wall_b = {
			objId = 4104,
			offsetX = 48,
			offsetY = 0,
			effect =
			{
				x = 128 * 1 + 2,
				y = 128 * 2 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -3,
				offY = -26,
			},
			zOrder = -12048, --指定z值很小
		},
		corner_lt = {
			objId = 4105,
			offsetX = 48,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 0 + 2,
				y = 128 * 0 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -7,
				offY = 2,
			},
			zOrder = -12048, --指定z值很小
		},
		corner_rt = {
			objId = 4106,
			offsetX = 24,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 2 + 2,
				y = 128 * 0 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 18,
				offY = 2,
			},
			zOrder = -12048, --指定z值很小
		},
		corner_lb = {
			objId = 4107,
			offsetX = 48,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 0 + 2,
				y = 128 * 2 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -7,
				offY = 3,
			},
			zOrder = -12048, --指定z值很小
		},
		corner_rb = {
			objId = 4108,
			offsetX = 24,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 2 + 2,
				y = 128 * 2 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 18,
				offY = 2,
			},
			zOrder = -12048, --指定z值很小
		},
		
		corner_lt1 = { --合并
			objId = 4114,
			offsetX = 48,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 3 + 2,
				y = 128 * 0 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -7,
				offY = 2,
			},
			zOrder = -12048, --指定z值很小
		},
		corner_rt1 = { --合并
			objId = 4115,
			offsetX = 24,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 3 + 2,
				y = 128 * 2 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 18,
				offY = 2,
			},
			zOrder = -12048, --指定z值很小
		},
		corner_lb1 = { --合并
			objId = 4116,
			offsetX = 48,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 3 + 2,
				y = 128 * 1 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -7,
				offY = 3,
			},
			zOrder = -12048, --指定z值很小
		},
		corner_rb1 = { --合并
			objId = 4117,
			offsetX = 24,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 3 + 2,
				y = 128 * 3 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 18,
				offY = 2,
			},
			zOrder = -12048, --指定z值很小
		},
		
		door_v = {
			objId = 4109,
			offsetX = 24,
			offsetY = 0,
			rot = 0,
			effect =
			{
				x = 128 * 0 + 2,
				y = 128 * 3 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 2,
				offY = -6,
			},
			zOrder = -12048, --指定z值很小
		},
		door_h = {
			objId = 4110,
			offsetX = 24,
			offsetY = 0,
			rot = 0,
			effect =
			{
				x = 128 * 1 + 2,
				y = 128 * 3 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 0,
				offY = -6,
			},
			zOrder = -12048, --指定z值很小
		},
		swall_v = {
			objId = 4111,
			offsetX = 24,
			offsetY = 0,
			effect =
			{
				x = 128 * 1 + 2,
				y = 128 * 1 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 0,
				offY = -3,
			},
			zOrder = -2048, --指定z值很小
		},
		swall_h = {
			objId = 4112,
			offsetX = 24,
			offsetY = 0,
			effect =
			{
				x = 128 * 2 + 2,
				y = 128 * 3 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 0,
				offY = -3,
			},
			zOrder = -2048, --指定z值很小
		},
		
		blocks = 
		{
			{
				objId = 5158,
				offsetX = 0,
				offsetY = 0,
				rot = 0,
			},
			{
				objId = 5159,
				offsetX = 0,
				offsetY = 0,
				rot = 0,
			},
			{
				objId = 5148,
				offsetX = 0,
				offsetY = 0,
				rot = 0,
			},
			{
				objId = 5149,
				offsetX = 0,
				offsetY = 0,
				rot = 0,
			},
		},
		
		--装饰物件
		renders =
		{
			--装饰物件1
			{
				x = 128 * 0 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件2
			{
				x = 128 * 1 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件3
			{
				x = 128 * 2 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件4
			{
				x = 128 * 3 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件5
			{
				x = 128 * 4 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件6
			{
				x = 128 * 5 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件7
			{
				x = 128 * 6 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件8
			{
				x = 128 * 7 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件9
			{
				x = 128 * 0 + 2,
				y = 128 * 5 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件10
			{
				x = 128 * 1 + 2,
				y = 128 * 5 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
		},
	},
	
	--mazeskin_013
	[9] =
	{
		farobj = --地球远景层
		{
			img = {"data/image/maze/space_back_01.jpg", "data/image/maze/space_back_02.jpg", "data/image/maze/space_back_03.jpg", "data/image/maze/space_back_04.jpg", "data/image/maze/space_back_05.jpg", "data/image/maze/space_back_06.jpg",},
			num = 1,
			scale = 1.0,
			rollRatio = 0.1, --卷轴速率
		},
		middleobj = --星星中景层
		{
			img = {"data/image/maze/starlight.png",},
			num = 20,
			scale = {0.2, 0.7},
			rollRatio = 0.16, --卷轴速率
		},
		nearobj = --飞船近景层
		{
			img = {
				[1] =
				{
					x = 128 * 0 + 2,
					y = 128 * 6 + 2,
					w = 256 - 2 * 2,
					h = 256 - 2 * 2,
				},
				[2] =
				{
					x = 128 * 2 + 2,
					y = 128 * 6 + 2,
					w = 256 - 2 * 2,
					h = 256 - 2 * 2,
				},
				[3] =
				{
					x = 128 * 4 + 2,
					y = 128 * 6 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[4] =
				{
					x = 128 * 5 + 2,
					y = 128 * 6 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[5] =
				{
					x = 128 * 6 + 2,
					y = 128 * 6 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[6] =
				{
					x = 128 * 7 + 2,
					y = 128 * 6 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[7] =
				{
					x = 128 * 4 + 2,
					y = 128 * 7 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[8] =
				{
					x = 128 * 5 + 2,
					y = 128 * 7 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[9] =
				{
					x = 128 * 6 + 2,
					y = 128 * 7 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[10] =
				{
					x = 128 * 7 + 2,
					y = 128 * 7 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
			},
			num = 20,
			scale = {1.0, 2.0},
			rollRatio = 0.3, --卷轴速率
		},
		wallimg = "data/image/maze/mazeskin_013.png", --墙面图片（整合到一张图里）
		ground = { --地板
			[1] =
			{
				x = 128 * 4 + 2,
				y = 128 * 0 + 2,
				w = 256 - 2 * 2,
				h = 256 - 2 * 2,
				probablity = 60, --几率
			},
			[2] =
			{
				x = 128 * 6 + 2,
				y = 128 * 0 + 2,
				w = 256 - 2 * 2,
				h = 256 - 2 * 2,
				probablity = 35,
			},
			[3] =
			{
				x = 128 * 4 + 2,
				y = 128 * 2 + 2,
				w = 256 - 2 * 2,
				h = 256 - 2 * 2,
				probablity = 5,
			},
		},
		wall_l = {
			objId = 4101,
			offsetX = 24,
			offsetY = 24,
			effect =
			{
				x = 128 * 0 + 2,
				y = 128 * 1 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 24,
				offY = -1,
			},
			zOrder = -12048, --指定z值很小
		},
		wall_r = {
			objId = 4102,
			offsetX = 24,
			offsetY = 24,
			effect =
			{
				x = 128 * 2 + 2,
				y = 128 * 1 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -28,
				offY = 1,
			},
			zOrder = -12048, --指定z值很小
		},
		wall_t = {
			objId = 4103,
			offsetX = 48,
			offsetY = 0,
			effect =
			{
				x = 128 * 1 + 2,
				y = 128 * 0 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -3,
				offY = 18,
			},
			zOrder = -12048, --指定z值很小
		},
		wall_b = {
			objId = 4104,
			offsetX = 48,
			offsetY = 0,
			effect =
			{
				x = 128 * 1 + 2,
				y = 128 * 2 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -3,
				offY = -26,
			},
			zOrder = -12048, --指定z值很小
		},
		corner_lt = {
			objId = 4105,
			offsetX = 48,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 0 + 2,
				y = 128 * 0 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -7,
				offY = 2,
			},
			zOrder = -12048, --指定z值很小
		},
		corner_rt = {
			objId = 4106,
			offsetX = 24,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 2 + 2,
				y = 128 * 0 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 18,
				offY = 2,
			},
			zOrder = -12048, --指定z值很小
		},
		corner_lb = {
			objId = 4107,
			offsetX = 48,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 0 + 2,
				y = 128 * 2 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -7,
				offY = 3,
			},
			zOrder = -12048, --指定z值很小
		},
		corner_rb = {
			objId = 4108,
			offsetX = 24,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 2 + 2,
				y = 128 * 2 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 18,
				offY = 2,
			},
			zOrder = -12048, --指定z值很小
		},
		
		corner_lt1 = { --合并
			objId = 4114,
			offsetX = 48,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 3 + 2,
				y = 128 * 0 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -7,
				offY = 2,
			},
			zOrder = -12048, --指定z值很小
		},
		corner_rt1 = { --合并
			objId = 4115,
			offsetX = 24,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 3 + 2,
				y = 128 * 2 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 18,
				offY = 2,
			},
			zOrder = -12048, --指定z值很小
		},
		corner_lb1 = { --合并
			objId = 4116,
			offsetX = 48,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 3 + 2,
				y = 128 * 1 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -7,
				offY = 3,
			},
			zOrder = -12048, --指定z值很小
		},
		corner_rb1 = { --合并
			objId = 4117,
			offsetX = 24,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 3 + 2,
				y = 128 * 3 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 18,
				offY = 2,
			},
			zOrder = -12048, --指定z值很小
		},
		
		door_v = {
			objId = 4109,
			offsetX = 24,
			offsetY = 0,
			rot = 0,
			effect =
			{
				x = 128 * 0 + 2,
				y = 128 * 3 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 2,
				offY = -6,
			},
			zOrder = -12048, --指定z值很小
		},
		door_h = {
			objId = 4110,
			offsetX = 24,
			offsetY = 0,
			rot = 0,
			effect =
			{
				x = 128 * 1 + 2,
				y = 128 * 3 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 0,
				offY = -6,
			},
			zOrder = -12048, --指定z值很小
		},
		swall_v = {
			objId = 4111,
			offsetX = 24,
			offsetY = 0,
			effect =
			{
				x = 128 * 1 + 2,
				y = 128 * 1 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 0,
				offY = -3,
			},
			zOrder = -2048, --指定z值很小
		},
		swall_h = {
			objId = 4112,
			offsetX = 24,
			offsetY = 0,
			effect =
			{
				x = 128 * 2 + 2,
				y = 128 * 3 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 0,
				offY = -3,
			},
			zOrder = -2048, --指定z值很小
		},
		
		blocks = 
		{
			{
				objId = 5158,
				offsetX = 0,
				offsetY = 0,
				rot = 0,
			},
			{
				objId = 5159,
				offsetX = 0,
				offsetY = 0,
				rot = 0,
			},
			{
				objId = 5148,
				offsetX = 0,
				offsetY = 0,
				rot = 0,
			},
			{
				objId = 5149,
				offsetX = 0,
				offsetY = 0,
				rot = 0,
			},
		},
		
		--装饰物件
		renders =
		{
			--装饰物件1
			{
				x = 128 * 0 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件2
			{
				x = 128 * 1 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件3
			{
				x = 128 * 2 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件4
			{
				x = 128 * 3 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件5
			{
				x = 128 * 4 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件6
			{
				x = 128 * 5 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件7
			{
				x = 128 * 6 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件8
			{
				x = 128 * 7 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件9
			{
				x = 128 * 0 + 2,
				y = 128 * 5 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件10
			{
				x = 128 * 1 + 2,
				y = 128 * 5 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
		},
	},
	
	--mazeskin_014
	[10] =
	{
		farobj = --地球远景层
		{
			img = {"data/image/maze/space_back_01.jpg", "data/image/maze/space_back_02.jpg", "data/image/maze/space_back_03.jpg", "data/image/maze/space_back_04.jpg", "data/image/maze/space_back_05.jpg", "data/image/maze/space_back_06.jpg",},
			num = 1,
			scale = 1.0,
			rollRatio = 0.1, --卷轴速率
		},
		middleobj = --星星中景层
		{
			img = {"data/image/maze/starlight.png",},
			num = 20,
			scale = {0.2, 0.7},
			rollRatio = 0.16, --卷轴速率
		},
		nearobj = --飞船近景层
		{
			img = {
				[1] =
				{
					x = 128 * 0 + 2,
					y = 128 * 6 + 2,
					w = 256 - 2 * 2,
					h = 256 - 2 * 2,
				},
				[2] =
				{
					x = 128 * 2 + 2,
					y = 128 * 6 + 2,
					w = 256 - 2 * 2,
					h = 256 - 2 * 2,
				},
				[3] =
				{
					x = 128 * 4 + 2,
					y = 128 * 6 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[4] =
				{
					x = 128 * 5 + 2,
					y = 128 * 6 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[5] =
				{
					x = 128 * 6 + 2,
					y = 128 * 6 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[6] =
				{
					x = 128 * 7 + 2,
					y = 128 * 6 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[7] =
				{
					x = 128 * 4 + 2,
					y = 128 * 7 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[8] =
				{
					x = 128 * 5 + 2,
					y = 128 * 7 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[9] =
				{
					x = 128 * 6 + 2,
					y = 128 * 7 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[10] =
				{
					x = 128 * 7 + 2,
					y = 128 * 7 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
			},
			num = 20,
			scale = {1.0, 2.0},
			rollRatio = 0.3, --卷轴速率
		},
		wallimg = "data/image/maze/mazeskin_014.png", --墙面图片（整合到一张图里）
		ground = { --地板
			[1] =
			{
				x = 128 * 4 + 2,
				y = 128 * 0 + 2,
				w = 256 - 2 * 2,
				h = 256 - 2 * 2,
				probablity = 60, --几率
			},
			[2] =
			{
				x = 128 * 6 + 2,
				y = 128 * 0 + 2,
				w = 256 - 2 * 2,
				h = 256 - 2 * 2,
				probablity = 35,
			},
			[3] =
			{
				x = 128 * 4 + 2,
				y = 128 * 2 + 2,
				w = 256 - 2 * 2,
				h = 256 - 2 * 2,
				probablity = 5,
			},
		},
		wall_l = {
			objId = 4101,
			offsetX = 24,
			offsetY = 24,
			effect =
			{
				x = 128 * 0 + 2,
				y = 128 * 1 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 24,
				offY = -1,
			},
			zOrder = -12048, --指定z值很小
		},
		wall_r = {
			objId = 4102,
			offsetX = 24,
			offsetY = 24,
			effect =
			{
				x = 128 * 2 + 2,
				y = 128 * 1 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -28,
				offY = 1,
			},
			zOrder = -12048, --指定z值很小
		},
		wall_t = {
			objId = 4103,
			offsetX = 48,
			offsetY = 0,
			effect =
			{
				x = 128 * 1 + 2,
				y = 128 * 0 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -3,
				offY = 18,
			},
			zOrder = -12048, --指定z值很小
		},
		wall_b = {
			objId = 4104,
			offsetX = 48,
			offsetY = 0,
			effect =
			{
				x = 128 * 1 + 2,
				y = 128 * 2 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -3,
				offY = -26,
			},
			zOrder = -12048, --指定z值很小
		},
		corner_lt = {
			objId = 4105,
			offsetX = 48,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 0 + 2,
				y = 128 * 0 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -7,
				offY = 2,
			},
			zOrder = -12048, --指定z值很小
		},
		corner_rt = {
			objId = 4106,
			offsetX = 24,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 2 + 2,
				y = 128 * 0 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 18,
				offY = 2,
			},
			zOrder = -12048, --指定z值很小
		},
		corner_lb = {
			objId = 4107,
			offsetX = 48,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 0 + 2,
				y = 128 * 2 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -7,
				offY = 3,
			},
			zOrder = -12048, --指定z值很小
		},
		corner_rb = {
			objId = 4108,
			offsetX = 24,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 2 + 2,
				y = 128 * 2 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 18,
				offY = 2,
			},
			zOrder = -12048, --指定z值很小
		},
		
		corner_lt1 = { --合并
			objId = 4114,
			offsetX = 48,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 3 + 2,
				y = 128 * 0 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -7,
				offY = 2,
			},
			zOrder = -12048, --指定z值很小
		},
		corner_rt1 = { --合并
			objId = 4115,
			offsetX = 24,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 3 + 2,
				y = 128 * 2 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 18,
				offY = 2,
			},
			zOrder = -12048, --指定z值很小
		},
		corner_lb1 = { --合并
			objId = 4116,
			offsetX = 48,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 3 + 2,
				y = 128 * 1 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -7,
				offY = 3,
			},
			zOrder = -12048, --指定z值很小
		},
		corner_rb1 = { --合并
			objId = 4117,
			offsetX = 24,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 3 + 2,
				y = 128 * 3 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 18,
				offY = 2,
			},
			zOrder = -12048, --指定z值很小
		},
		
		door_v = {
			objId = 4109,
			offsetX = 24,
			offsetY = 0,
			rot = 0,
			effect =
			{
				x = 128 * 0 + 2,
				y = 128 * 3 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 2,
				offY = -6,
			},
			zOrder = -12048, --指定z值很小
		},
		door_h = {
			objId = 4110,
			offsetX = 24,
			offsetY = 0,
			rot = 0,
			effect =
			{
				x = 128 * 1 + 2,
				y = 128 * 3 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 0,
				offY = -6,
			},
			zOrder = -12048, --指定z值很小
		},
		swall_v = {
			objId = 4111,
			offsetX = 24,
			offsetY = 0,
			effect =
			{
				x = 128 * 1 + 2,
				y = 128 * 1 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 0,
				offY = -3,
			},
			zOrder = -2048, --指定z值很小
		},
		swall_h = {
			objId = 4112,
			offsetX = 24,
			offsetY = 0,
			effect =
			{
				x = 128 * 2 + 2,
				y = 128 * 3 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 0,
				offY = -3,
			},
			zOrder = -2048, --指定z值很小
		},
		
		blocks = 
		{
			{
				objId = 5158,
				offsetX = 0,
				offsetY = 0,
				rot = 0,
			},
			{
				objId = 5159,
				offsetX = 0,
				offsetY = 0,
				rot = 0,
			},
			{
				objId = 5148,
				offsetX = 0,
				offsetY = 0,
				rot = 0,
			},
			{
				objId = 5149,
				offsetX = 0,
				offsetY = 0,
				rot = 0,
			},
		},
		
		--装饰物件
		renders =
		{
			--装饰物件1
			{
				x = 128 * 0 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件2
			{
				x = 128 * 1 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件3
			{
				x = 128 * 2 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件4
			{
				x = 128 * 3 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件5
			{
				x = 128 * 4 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件6
			{
				x = 128 * 5 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件7
			{
				x = 128 * 6 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件8
			{
				x = 128 * 7 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件9
			{
				x = 128 * 0 + 2,
				y = 128 * 5 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件10
			{
				x = 128 * 1 + 2,
				y = 128 * 5 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
		},
	},
	
	--mazeskin_015
	[11] =
	{
		farobj = --地球远景层
		{
			img = {"data/image/maze/space_back_01.jpg", "data/image/maze/space_back_02.jpg", "data/image/maze/space_back_03.jpg", "data/image/maze/space_back_04.jpg", "data/image/maze/space_back_05.jpg", "data/image/maze/space_back_06.jpg",},
			num = 1,
			scale = 1.0,
			rollRatio = 0.1, --卷轴速率
		},
		middleobj = --星星中景层
		{
			img = {"data/image/maze/starlight.png",},
			num = 20,
			scale = {0.2, 0.7},
			rollRatio = 0.16, --卷轴速率
		},
		nearobj = --飞船近景层
		{
			img = {
				[1] =
				{
					x = 128 * 0 + 2,
					y = 128 * 6 + 2,
					w = 256 - 2 * 2,
					h = 256 - 2 * 2,
				},
				[2] =
				{
					x = 128 * 2 + 2,
					y = 128 * 6 + 2,
					w = 256 - 2 * 2,
					h = 256 - 2 * 2,
				},
				[3] =
				{
					x = 128 * 4 + 2,
					y = 128 * 6 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[4] =
				{
					x = 128 * 5 + 2,
					y = 128 * 6 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[5] =
				{
					x = 128 * 6 + 2,
					y = 128 * 6 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[6] =
				{
					x = 128 * 7 + 2,
					y = 128 * 6 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[7] =
				{
					x = 128 * 4 + 2,
					y = 128 * 7 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[8] =
				{
					x = 128 * 5 + 2,
					y = 128 * 7 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[9] =
				{
					x = 128 * 6 + 2,
					y = 128 * 7 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[10] =
				{
					x = 128 * 7 + 2,
					y = 128 * 7 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
			},
			num = 20,
			scale = {1.0, 2.0},
			rollRatio = 0.3, --卷轴速率
		},
		wallimg = "data/image/maze/mazeskin_015.png", --墙面图片（整合到一张图里）
		ground = { --地板
			[1] =
			{
				x = 128 * 4 + 2,
				y = 128 * 0 + 2,
				w = 256 - 2 * 2,
				h = 256 - 2 * 2,
				probablity = 60, --几率
			},
			[2] =
			{
				x = 128 * 6 + 2,
				y = 128 * 0 + 2,
				w = 256 - 2 * 2,
				h = 256 - 2 * 2,
				probablity = 35,
			},
			[3] =
			{
				x = 128 * 4 + 2,
				y = 128 * 2 + 2,
				w = 256 - 2 * 2,
				h = 256 - 2 * 2,
				probablity = 5,
			},
		},
		wall_l = {
			objId = 4101,
			offsetX = 24,
			offsetY = 24,
			effect =
			{
				x = 128 * 0 + 2,
				y = 128 * 1 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 24,
				offY = -1,
			},
			zOrder = -12048, --指定z值很小
		},
		wall_r = {
			objId = 4102,
			offsetX = 24,
			offsetY = 24,
			effect =
			{
				x = 128 * 2 + 2,
				y = 128 * 1 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -28,
				offY = 1,
			},
			zOrder = -12048, --指定z值很小
		},
		wall_t = {
			objId = 4103,
			offsetX = 48,
			offsetY = 0,
			effect =
			{
				x = 128 * 1 + 2,
				y = 128 * 0 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -3,
				offY = 18,
			},
			zOrder = -12048, --指定z值很小
		},
		wall_b = {
			objId = 4104,
			offsetX = 48,
			offsetY = 0,
			effect =
			{
				x = 128 * 1 + 2,
				y = 128 * 2 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -3,
				offY = -26,
			},
			zOrder = -12048, --指定z值很小
		},
		corner_lt = {
			objId = 4105,
			offsetX = 48,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 0 + 2,
				y = 128 * 0 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -7,
				offY = 2,
			},
			zOrder = -12048, --指定z值很小
		},
		corner_rt = {
			objId = 4106,
			offsetX = 24,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 2 + 2,
				y = 128 * 0 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 18,
				offY = 2,
			},
			zOrder = -12048, --指定z值很小
		},
		corner_lb = {
			objId = 4107,
			offsetX = 48,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 0 + 2,
				y = 128 * 2 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -7,
				offY = 3,
			},
			zOrder = -12048, --指定z值很小
		},
		corner_rb = {
			objId = 4108,
			offsetX = 24,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 2 + 2,
				y = 128 * 2 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 18,
				offY = 2,
			},
			zOrder = -12048, --指定z值很小
		},
		
		corner_lt1 = { --合并
			objId = 4114,
			offsetX = 48,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 3 + 2,
				y = 128 * 0 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -7,
				offY = 2,
			},
			zOrder = -12048, --指定z值很小
		},
		corner_rt1 = { --合并
			objId = 4115,
			offsetX = 24,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 3 + 2,
				y = 128 * 2 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 18,
				offY = 2,
			},
			zOrder = -12048, --指定z值很小
		},
		corner_lb1 = { --合并
			objId = 4116,
			offsetX = 48,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 3 + 2,
				y = 128 * 1 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -7,
				offY = 3,
			},
			zOrder = -12048, --指定z值很小
		},
		corner_rb1 = { --合并
			objId = 4117,
			offsetX = 24,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 3 + 2,
				y = 128 * 3 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 18,
				offY = 2,
			},
			zOrder = -12048, --指定z值很小
		},
		
		door_v = {
			objId = 4109,
			offsetX = 24,
			offsetY = 0,
			rot = 0,
			effect =
			{
				x = 128 * 0 + 2,
				y = 128 * 3 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 2,
				offY = -6,
			},
			zOrder = -12048, --指定z值很小
		},
		door_h = {
			objId = 4110,
			offsetX = 24,
			offsetY = 0,
			rot = 0,
			effect =
			{
				x = 128 * 1 + 2,
				y = 128 * 3 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 0,
				offY = -6,
			},
			zOrder = -12048, --指定z值很小
		},
		swall_v = {
			objId = 4111,
			offsetX = 24,
			offsetY = 0,
			effect =
			{
				x = 128 * 1 + 2,
				y = 128 * 1 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 0,
				offY = -3,
			},
			zOrder = -2048, --指定z值很小
		},
		swall_h = {
			objId = 4112,
			offsetX = 24,
			offsetY = 0,
			effect =
			{
				x = 128 * 2 + 2,
				y = 128 * 3 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 0,
				offY = -3,
			},
			zOrder = -2048, --指定z值很小
		},
		
		blocks = 
		{
			{
				objId = 5158,
				offsetX = 0,
				offsetY = 0,
				rot = 0,
			},
			{
				objId = 5159,
				offsetX = 0,
				offsetY = 0,
				rot = 0,
			},
			{
				objId = 5148,
				offsetX = 0,
				offsetY = 0,
				rot = 0,
			},
			{
				objId = 5149,
				offsetX = 0,
				offsetY = 0,
				rot = 0,
			},
		},
		
		--装饰物件
		renders =
		{
			--装饰物件1
			{
				x = 128 * 0 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件2
			{
				x = 128 * 1 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件3
			{
				x = 128 * 2 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件4
			{
				x = 128 * 3 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件5
			{
				x = 128 * 4 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件6
			{
				x = 128 * 5 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件7
			{
				x = 128 * 6 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件8
			{
				x = 128 * 7 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件9
			{
				x = 128 * 0 + 2,
				y = 128 * 5 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件10
			{
				x = 128 * 1 + 2,
				y = 128 * 5 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
		},
	},
	
	--mazeskin_016（高墙）
	[12] =
	{
		farobj = --地球远景层
		{
			img = {"data/image/maze/space_back_01.jpg", "data/image/maze/space_back_02.jpg", "data/image/maze/space_back_03.jpg", "data/image/maze/space_back_04.jpg", "data/image/maze/space_back_05.jpg", "data/image/maze/space_back_06.jpg",},
			num = 1,
			scale = 1.0,
			rollRatio = 0.1, --卷轴速率
		},
		middleobj = --星星中景层
		{
			img = {"data/image/maze/starlight.png",},
			num = 20,
			scale = {0.2, 0.7},
			rollRatio = 0.16, --卷轴速率
		},
		nearobj = --飞船近景层
		{
			img = {
				[1] =
				{
					x = 128 * 0 + 2,
					y = 128 * 6 + 2,
					w = 256 - 2 * 2,
					h = 256 - 2 * 2,
				},
				[2] =
				{
					x = 128 * 2 + 2,
					y = 128 * 6 + 2,
					w = 256 - 2 * 2,
					h = 256 - 2 * 2,
				},
				[3] =
				{
					x = 128 * 4 + 2,
					y = 128 * 6 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[4] =
				{
					x = 128 * 5 + 2,
					y = 128 * 6 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[5] =
				{
					x = 128 * 6 + 2,
					y = 128 * 6 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[6] =
				{
					x = 128 * 7 + 2,
					y = 128 * 6 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[7] =
				{
					x = 128 * 4 + 2,
					y = 128 * 7 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[8] =
				{
					x = 128 * 5 + 2,
					y = 128 * 7 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[9] =
				{
					x = 128 * 6 + 2,
					y = 128 * 7 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[10] =
				{
					x = 128 * 7 + 2,
					y = 128 * 7 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
			},
			num = 20,
			scale = {1.0, 2.0},
			rollRatio = 0.3, --卷轴速率
		},
		wallimg = "data/image/maze/mazeskin_016_wall.png", --墙面图片（整合到一张图里）
		ground = { --地板
			[1] =
			{
				x = 128 * 4 + 2,
				y = 128 * 0 + 2,
				w = 256 - 2 * 2,
				h = 256 - 2 * 2,
				probablity = 60, --几率
			},
			[2] =
			{
				x = 128 * 6 + 2,
				y = 128 * 0 + 2,
				w = 256 - 2 * 2,
				h = 256 - 2 * 2,
				probablity = 35,
			},
			[3] =
			{
				x = 128 * 4 + 2,
				y = 128 * 2 + 2,
				w = 256 - 2 * 2,
				h = 256 - 2 * 2,
				probablity = 5,
			},
		},
		wall_l = {
			objId = 4001,
			offsetX = 24,
			offsetY = 24,
			effect =
			{
				x = 128 * 0 + 2,
				y = 128 * 1 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 24,
				offY = -1,
			},
			zOrder = -256, --指定z值很小
		},
		wall_r = {
			objId = 4002,
			offsetX = 24,
			offsetY = 24,
			effect =
			{
				x = 128 * 2 + 2,
				y = 128 * 1 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -28,
				offY = 1,
			},
			zOrder = -256, --指定z值很小
		},
		wall_t = {
			objId = 4003,
			offsetX = 48,
			offsetY = 0,
			effect =
			{
				x = 128 * 1 + 2,
				y = 128 * 0 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -3,
				offY = 18,
			},
			zOrder = -256, --指定z值很小
		},
		wall_b = {
			objId = 4004,
			offsetX = 48,
			offsetY = 0,
			effect =
			{
				x = 128 * 1 + 2,
				y = 128 * 2 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -3,
				offY = -26,
			},
			zOrder = -256, --指定z值很小
		},
		corner_lt = {
			objId = 4005,
			offsetX = 48,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 0 + 2,
				y = 128 * 0 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -7,
				offY = 2,
			},
			zOrder = -256, --指定z值很小
		},
		corner_rt = {
			objId = 4006,
			offsetX = 24,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 2 + 2,
				y = 128 * 0 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 18,
				offY = 2,
			},
			zOrder = -256, --指定z值很小
		},
		corner_lb = {
			objId = 4007,
			offsetX = 48,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 0 + 2,
				y = 128 * 2 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -7,
				offY = 3,
			},
			zOrder = -256, --指定z值很小
		},
		corner_rb = {
			objId = 4008,
			offsetX = 24,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 2 + 2,
				y = 128 * 2 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 18,
				offY = 2,
			},
			zOrder = -256, --指定z值很小
		},
		
		corner_lt1 = { --合并
			objId = 4014,
			offsetX = 48,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 3 + 2,
				y = 128 * 0 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -7,
				offY = 2,
			},
			zOrder = -256, --指定z值很小
		},
		corner_rt1 = { --合并
			objId = 4015,
			offsetX = 24,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 3 + 2,
				y = 128 * 2 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 18,
				offY = 2,
			},
			zOrder = -256, --指定z值很小
		},
		corner_lb1 = { --合并
			objId = 4016,
			offsetX = 48,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 3 + 2,
				y = 128 * 1 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -7,
				offY = 3,
			},
			zOrder = -256, --指定z值很小
		},
		corner_rb1 = { --合并
			objId = 4017,
			offsetX = 24,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 3 + 2,
				y = 128 * 3 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 18,
				offY = 2,
			},
			zOrder = -256, --指定z值很小
		},
		
		door_v = {
			objId = 4009,
			offsetX = 24,
			offsetY = 0,
			rot = 0,
			effect =
			{
				x = 128 * 0 + 2,
				y = 128 * 3 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 2,
				offY = -6,
			},
			zOrder = -256, --指定z值很小
		},
		door_h = {
			objId = 4010,
			offsetX = 24,
			offsetY = 0,
			rot = 0,
			effect =
			{
				x = 128 * 1 + 2,
				y = 128 * 3 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 0,
				offY = -6,
			},
			zOrder = -256, --指定z值很小
		},
		swall_v = {
			objId = 4011,
			offsetX = 24,
			offsetY = 0,
			effect =
			{
				x = 128 * 1 + 2,
				y = 128 * 1 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 0,
				offY = -3,
			},
			zOrder = -256, --指定z值很小
		},
		swall_h = {
			objId = 4012,
			offsetX = 24,
			offsetY = 0,
			effect =
			{
				x = 128 * 2 + 2,
				y = 128 * 3 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 0,
				offY = -3,
			},
			zOrder = -256, --指定z值很小
		},
		
		blocks = 
		{
			{
				objId = 5158,
				offsetX = 0,
				offsetY = 0,
				rot = 0,
			},
			{
				objId = 5159,
				offsetX = 0,
				offsetY = 0,
				rot = 0,
			},
			{
				objId = 5148,
				offsetX = 0,
				offsetY = 0,
				rot = 0,
			},
			{
				objId = 5149,
				offsetX = 0,
				offsetY = 0,
				rot = 0,
			},
		},
		
		--装饰物件
		renders =
		{
			--装饰物件1
			{
				x = 128 * 0 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件2
			{
				x = 128 * 1 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件3
			{
				x = 128 * 2 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件4
			{
				x = 128 * 3 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件5
			{
				x = 128 * 4 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件6
			{
				x = 128 * 5 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件7
			{
				x = 128 * 6 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件8
			{
				x = 128 * 7 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件9
			{
				x = 128 * 0 + 2,
				y = 128 * 5 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件10
			{
				x = 128 * 1 + 2,
				y = 128 * 5 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
		},
	},
	
	--mazeskin_017
	[13] =
	{
		farobj = --地球远景层
		{
			img = {"data/image/maze/space_back_01.jpg", "data/image/maze/space_back_02.jpg", "data/image/maze/space_back_03.jpg", "data/image/maze/space_back_04.jpg", "data/image/maze/space_back_05.jpg", "data/image/maze/space_back_06.jpg",},
			num = 1,
			scale = 1.0,
			rollRatio = 0.1, --卷轴速率
		},
		middleobj = --星星中景层
		{
			img = {"data/image/maze/starlight.png",},
			num = 20,
			scale = {0.2, 0.7},
			rollRatio = 0.16, --卷轴速率
		},
		nearobj = --飞船近景层
		{
			img = {
				[1] =
				{
					x = 128 * 0 + 2,
					y = 128 * 6 + 2,
					w = 256 - 2 * 2,
					h = 256 - 2 * 2,
				},
				[2] =
				{
					x = 128 * 2 + 2,
					y = 128 * 6 + 2,
					w = 256 - 2 * 2,
					h = 256 - 2 * 2,
				},
				[3] =
				{
					x = 128 * 4 + 2,
					y = 128 * 6 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[4] =
				{
					x = 128 * 5 + 2,
					y = 128 * 6 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[5] =
				{
					x = 128 * 6 + 2,
					y = 128 * 6 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[6] =
				{
					x = 128 * 7 + 2,
					y = 128 * 6 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[7] =
				{
					x = 128 * 4 + 2,
					y = 128 * 7 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[8] =
				{
					x = 128 * 5 + 2,
					y = 128 * 7 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[9] =
				{
					x = 128 * 6 + 2,
					y = 128 * 7 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[10] =
				{
					x = 128 * 7 + 2,
					y = 128 * 7 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
			},
			num = 20,
			scale = {1.0, 2.0},
			rollRatio = 0.3, --卷轴速率
		},
		wallimg = "data/image/maze/mazeskin_017.png", --墙面图片（整合到一张图里）
		ground = { --地板
			[1] =
			{
				x = 128 * 4 + 2,
				y = 128 * 0 + 2,
				w = 256 - 2 * 2,
				h = 256 - 2 * 2,
				probablity = 60, --几率
			},
			[2] =
			{
				x = 128 * 6 + 2,
				y = 128 * 0 + 2,
				w = 256 - 2 * 2,
				h = 256 - 2 * 2,
				probablity = 35,
			},
			[3] =
			{
				x = 128 * 4 + 2,
				y = 128 * 2 + 2,
				w = 256 - 2 * 2,
				h = 256 - 2 * 2,
				probablity = 5,
			},
		},
		wall_l = {
			objId = 4101,
			offsetX = 24,
			offsetY = 24,
			effect =
			{
				x = 128 * 0 + 2,
				y = 128 * 1 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 24,
				offY = -1,
			},
			zOrder = -12048, --指定z值很小
		},
		wall_r = {
			objId = 4102,
			offsetX = 24,
			offsetY = 24,
			effect =
			{
				x = 128 * 2 + 2,
				y = 128 * 1 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -28,
				offY = 1,
			},
			zOrder = -12048, --指定z值很小
		},
		wall_t = {
			objId = 4103,
			offsetX = 48,
			offsetY = 0,
			effect =
			{
				x = 128 * 1 + 2,
				y = 128 * 0 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -3,
				offY = 18,
			},
			zOrder = -12048, --指定z值很小
		},
		wall_b = {
			objId = 4104,
			offsetX = 48,
			offsetY = 0,
			effect =
			{
				x = 128 * 1 + 2,
				y = 128 * 2 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -3,
				offY = -26,
			},
			zOrder = -12048, --指定z值很小
		},
		corner_lt = {
			objId = 4105,
			offsetX = 48,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 0 + 2,
				y = 128 * 0 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -7,
				offY = 2,
			},
			zOrder = -12048, --指定z值很小
		},
		corner_rt = {
			objId = 4106,
			offsetX = 24,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 2 + 2,
				y = 128 * 0 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 18,
				offY = 2,
			},
			zOrder = -12048, --指定z值很小
		},
		corner_lb = {
			objId = 4107,
			offsetX = 48,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 0 + 2,
				y = 128 * 2 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -7,
				offY = 3,
			},
			zOrder = -12048, --指定z值很小
		},
		corner_rb = {
			objId = 4108,
			offsetX = 24,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 2 + 2,
				y = 128 * 2 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 18,
				offY = 2,
			},
			zOrder = -12048, --指定z值很小
		},
		
		corner_lt1 = { --合并
			objId = 4114,
			offsetX = 48,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 3 + 2,
				y = 128 * 0 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -7,
				offY = 2,
			},
			zOrder = -12048, --指定z值很小
		},
		corner_rt1 = { --合并
			objId = 4115,
			offsetX = 24,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 3 + 2,
				y = 128 * 2 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 18,
				offY = 2,
			},
			zOrder = -12048, --指定z值很小
		},
		corner_lb1 = { --合并
			objId = 4116,
			offsetX = 48,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 3 + 2,
				y = 128 * 1 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -7,
				offY = 3,
			},
			zOrder = -12048, --指定z值很小
		},
		corner_rb1 = { --合并
			objId = 4117,
			offsetX = 24,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 3 + 2,
				y = 128 * 3 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 18,
				offY = 2,
			},
			zOrder = -12048, --指定z值很小
		},
		
		door_v = {
			objId = 4109,
			offsetX = 24,
			offsetY = 0,
			rot = 0,
			effect =
			{
				x = 128 * 0 + 2,
				y = 128 * 3 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 2,
				offY = -6,
			},
			zOrder = -12048, --指定z值很小
		},
		door_h = {
			objId = 4110,
			offsetX = 24,
			offsetY = 0,
			rot = 0,
			effect =
			{
				x = 128 * 1 + 2,
				y = 128 * 3 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 0,
				offY = -6,
			},
			zOrder = -12048, --指定z值很小
		},
		swall_v = {
			objId = 4111,
			offsetX = 24,
			offsetY = 0,
			effect =
			{
				x = 128 * 1 + 2,
				y = 128 * 1 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 0,
				offY = -3,
			},
			zOrder = -2048, --指定z值很小
		},
		swall_h = {
			objId = 4112,
			offsetX = 24,
			offsetY = 0,
			effect =
			{
				x = 128 * 2 + 2,
				y = 128 * 3 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 0,
				offY = -3,
			},
			zOrder = -2048, --指定z值很小
		},
		
		blocks = 
		{
			{
				objId = 5158,
				offsetX = 0,
				offsetY = 0,
				rot = 0,
			},
			{
				objId = 5159,
				offsetX = 0,
				offsetY = 0,
				rot = 0,
			},
			{
				objId = 5148,
				offsetX = 0,
				offsetY = 0,
				rot = 0,
			},
			{
				objId = 5149,
				offsetX = 0,
				offsetY = 0,
				rot = 0,
			},
		},
		
		--装饰物件
		renders =
		{
			--装饰物件1
			{
				x = 128 * 0 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件2
			{
				x = 128 * 1 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件3
			{
				x = 128 * 2 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件4
			{
				x = 128 * 3 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件5
			{
				x = 128 * 4 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件6
			{
				x = 128 * 5 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件7
			{
				x = 128 * 6 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件8
			{
				x = 128 * 7 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件9
			{
				x = 128 * 0 + 2,
				y = 128 * 5 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件10
			{
				x = 128 * 1 + 2,
				y = 128 * 5 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
		},
	},
	
	--猫咪庭院风格
	[14] =
	{
		farobj = --地球远景层
		{
			img = {"data/image/maze/space_back_07.jpg",},
			num = 1,
			scale = 1.0,
			rollRatio = 0.1, --卷轴速率
		},
		middleobj = --星星中景层
		{
			img = {"data/image/maze/starlight.png",},
			num = 20,
			scale = {0.2, 0.7},
			rollRatio = 0.16, --卷轴速率
		},
		nearobj = --飞船近景层
		{
			img = {
				[1] =
				{
					x = 128 * 0 + 2,
					y = 128 * 6 + 2,
					w = 256 - 2 * 2,
					h = 256 - 2 * 2,
				},
				[2] =
				{
					x = 128 * 2 + 2,
					y = 128 * 6 + 2,
					w = 256 - 2 * 2,
					h = 256 - 2 * 2,
				},
				[3] =
				{
					x = 128 * 4 + 2,
					y = 128 * 6 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[4] =
				{
					x = 128 * 5 + 2,
					y = 128 * 6 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[5] =
				{
					x = 128 * 6 + 2,
					y = 128 * 6 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[6] =
				{
					x = 128 * 7 + 2,
					y = 128 * 6 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[7] =
				{
					x = 128 * 4 + 2,
					y = 128 * 7 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[8] =
				{
					x = 128 * 5 + 2,
					y = 128 * 7 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[9] =
				{
					x = 128 * 6 + 2,
					y = 128 * 7 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
				[10] =
				{
					x = 128 * 7 + 2,
					y = 128 * 7 + 2,
					w = 128 - 2 * 2,
					h = 128 - 2 * 2,
				},
			},
			num = 20,
			scale = {1.0, 2.0},
			rollRatio = 0.3, --卷轴速率
		},
		wallimg = "data/image/maze/mazeskin_highwall_007.png", --墙面图片（整合到一张图里）
		ground = { --地板
			[1] =
			{
				x = 128 * 4 + 2,
				y = 128 * 0 + 2,
				w = 256 - 2 * 2,
				h = 256 - 2 * 2,
				probablity = 60, --几率
			},
			[2] =
			{
				x = 128 * 6 + 2,
				y = 128 * 0 + 2,
				w = 256 - 2 * 2,
				h = 256 - 2 * 2,
				probablity = 35,
			},
			[3] =
			{
				x = 128 * 4 + 2,
				y = 128 * 2 + 2,
				w = 256 - 2 * 2,
				h = 256 - 2 * 2,
				probablity = 5,
			},
		},
		wall_l = {
			objId = 4001,
			offsetX = 24,
			offsetY = 24,
			effect =
			{
				x = 128 * 0 + 2,
				y = 128 * 1 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 24,
				offY = -1,
			},
			zOrder = 128, --指定z值叠加
		},
		wall_r = {
			objId = 4002,
			offsetX = 24,
			offsetY = 24,
			effect =
			{
				x = 128 * 2 + 2,
				y = 128 * 1 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -28,
				offY = 1,
			},
			zOrder = 128, --指定z值叠加
		},
		wall_t = {
			objId = 4003,
			offsetX = 48,
			offsetY = 0,
			effect =
			{
				x = 128 * 1 + 2,
				y = 128 * 0 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -3,
				offY = 18,
			},
			zOrder = -256, --指定z值很小
		},
		wall_b = {
			objId = 4004,
			offsetX = 48,
			offsetY = 0,
			effect =
			{
				x = 128 * 1 + 2,
				y = 128 * 2 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -3,
				offY = -26,
			},
			zOrder = 128, --指定z值叠加
		},
		corner_lt = {
			objId = 4005,
			offsetX = 48,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 0 + 2,
				y = 128 * 0 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -7,
				offY = 2,
			},
			zOrder = -256, --指定z值很小
		},
		corner_rt = {
			objId = 4006,
			offsetX = 24,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 2 + 2,
				y = 128 * 0 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 18,
				offY = 2,
			},
			zOrder = -256, --指定z值很小
		},
		corner_lb = {
			objId = 4007,
			offsetX = 48,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 0 + 2,
				y = 128 * 2 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -7,
				offY = 3,
			},
			zOrder = 128, --指定z值叠加
		},
		corner_rb = {
			objId = 4008,
			offsetX = 24,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 2 + 2,
				y = 128 * 2 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 18,
				offY = 2,
			},
			zOrder = 128, --指定z值叠加
		},
		
		corner_lt1 = { --合并
			objId = 4014,
			offsetX = 48,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 3 + 2,
				y = 128 * 0 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -7,
				offY = 2,
			},
			zOrder = 128, --指定z值叠加
		},
		corner_rt1 = { --合并
			objId = 4015,
			offsetX = 24,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 3 + 2,
				y = 128 * 2 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 18,
				offY = 2,
			},
			zOrder = 128, --指定z值叠加
		},
		corner_lb1 = { --合并
			objId = 4016,
			offsetX = 48,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 3 + 2,
				y = 128 * 1 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = -7,
				offY = 3,
			},
			zOrder = 128, --指定z值叠加
		},
		corner_rb1 = { --合并
			objId = 4017,
			offsetX = 24,
			offsetY = 24,
			rot = 0,
			effect =
			{
				x = 128 * 3 + 2,
				y = 128 * 3 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 18,
				offY = 2,
			},
			zOrder = 128, --指定z值叠加
		},
		
		door_v = {
			objId = 4009,
			offsetX = 24,
			offsetY = 0,
			rot = 0,
			effect =
			{
				x = 128 * 0 + 2,
				y = 128 * 3 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 2,
				offY = -6,
			},
			zOrder = 128, --指定z值叠加
		},
		door_h = {
			objId = 4010,
			offsetX = 24,
			offsetY = 0,
			rot = 0,
			effect =
			{
				x = 128 * 1 + 2,
				y = 128 * 3 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 0,
				offY = -6,
			},
			zOrder = 128, --指定z值叠加
		},
		swall_v = {
			objId = 4011,
			offsetX = 24,
			offsetY = 0,
			effect =
			{
				x = 128 * 1 + 2,
				y = 128 * 1 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 0,
				offY = -3,
			},
			zOrder = 128, --指定z值叠加
		},
		swall_h = {
			objId = 4012,
			offsetX = 24,
			offsetY = 0,
			effect =
			{
				x = 128 * 2 + 2,
				y = 128 * 3 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
				offX = 0,
				offY = -3,
			},
			zOrder = 128, --指定z值叠加
		},
		
		blocks = 
		{
			{
				objId = 5158,
				offsetX = 0,
				offsetY = 0,
				rot = 0,
			},
			{
				objId = 5159,
				offsetX = 0,
				offsetY = 0,
				rot = 0,
			},
			{
				objId = 5148,
				offsetX = 0,
				offsetY = 0,
				rot = 0,
			},
			{
				objId = 5149,
				offsetX = 0,
				offsetY = 0,
				rot = 0,
			},
		},
		
		--装饰物件
		renders =
		{
			--装饰物件1
			{
				x = 128 * 0 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件2
			{
				x = 128 * 1 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件3
			{
				x = 128 * 2 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件4
			{
				x = 128 * 3 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件5
			{
				x = 128 * 4 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件6
			{
				x = 128 * 5 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件7
			{
				x = 128 * 6 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件8
			{
				x = 128 * 7 + 2,
				y = 128 * 4 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件9
			{
				x = 128 * 0 + 2,
				y = 128 * 5 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
			--装饰物件10
			{
				x = 128 * 1 + 2,
				y = 128 * 5 + 2,
				w = 128 - 2 * 2,
				h = 128 - 2 * 2,
			},
		},
	},
	
	------------------------------------
	--引导图 第0关
	[104] =
	{
		farobj = --火星远景层
		{
			img = {"data/image/maze/space_back_01.jpg",},
			num = 1,
			scale = 0.85,
			rollRatio = 0.1, --卷轴速率
		},
		middleobj = --星星中景层
		{
			img = {"data/image/maze/starlight.png",},
			num = 10,
			scale = {0.2, 0.7},
			rollRatio = 0.16, --卷轴速率
		},
		nearobj = --矿石近景层
		{
			img = {"data/image/maze/crystal_stone01.png", "data/image/maze/crystal_stone02.png", "data/image/maze/crystal_stone03.png", "data/image/maze/crystal_stone04.png", "data/image/maze/crystal_stone05.png", "data/image/maze/crystal_stone06.png",},
			num = 100,
			scale = {0.15, 1.0},
			rollRatio = 0.3, --卷轴速率
		},
	},
	
	------------------------------------
	--用户自定义关卡
	[1001] =
	{
		farobj = {}, --地球远景层
		middleobj = {}, --星星中景层
		nearobj = {},--飞船近景层
		wallimg = "", --墙面图片（整合到一张图里）
		ground = {}, --地板
		wall_l = {},
		wall_r = {},
		wall_t = {},
		wall_b = {},
		corner_lt = {},
		corner_rt = {},
		corner_lb = {},
		corner_rb = {},
		corner_lt1 = {},
		corner_rt1 = {},
		corner_lb1 = {},
		corner_rb1 = {},
		door_v = {},
		door_h = {},
		swall_v = {},
		swall_h = {},
		blocks = {},
		renders = {}, --装饰物件
	},
}

--战车区域生成点系数
hVar.RANDMAP_REGION_POINT_MULTIPLY =
{
	--区域1
	[1] =
	{
		avatarInfoId = 0, --皮肤id（0为随机）
		link = {regionId = 0, fx = 0, fy = 0,}, --参考区域id, 系数x,系数y
		width_rate = 0.5,
		height_rate = 0.5,
		tonext = true,
		toprevious = false,
		terminal = false, --最后一关？
		mutation_maxcount = 2, --最大突变次数
		grouplimit = --组数量上限限制
		{
			[4] = {mincount = 0, maxcount = 1,}, --铁人雕像 5171
			[2] = {mincount = 0, maxcount = 1,}, --看守所 11210
			[6] = {mincount = 0, maxcount = 1,}, --宠物治疗 5186
			[8] = {mincount = 0, maxcount = 1,}, --平房X
			[9] = {mincount = 0, maxcount = 1,}, --宠物雇佣
			[10] = {mincount = 0, maxcount = 0,}, --水晶商店
			[700] = {mincount = 0, maxcount = 1,},
			[701] = {mincount = 0, maxcount = 1,},
			[800] = {mincount = 0, maxcount = 1,},
			[801] = {mincount = 0, maxcount = 1,},
			[802] = {mincount = 0, maxcount = 1,},
		},
		
	},
	
	--区域2
	[2] =
	{
		avatarInfoId = 0, --皮肤id（0为随机）
		link = {regionId = 1, fx = 0.0, fy = 1.0,}, --参考区域id, 系数x,系数y
		width_rate = 0.5,
		height_rate = 0.5,
		tonext = true,
		toprevious = true,
		terminal = false, --最后一关？
		mutation_maxcount = 2, --最大突变次数
		grouplimit = --组数量上限限制
		{
			[4] = {mincount = 0, maxcount = 1,}, --铁人雕像 5171
			[2] = {mincount = 0, maxcount = 1,}, --看守所 11210
			[6] = {mincount = 0, maxcount = 1,}, --宠物治疗 5186
			[8] = {mincount = 0, maxcount = 1,}, --平房X
			[9] = {mincount = 0, maxcount = 1,}, --宠物雇佣
			[10] = {mincount = 0, maxcount = 0,}, --水晶商店
			[700] = {mincount = 0, maxcount = 1,},
			[701] = {mincount = 0, maxcount = 1,},
			[800] = {mincount = 0, maxcount = 1,},
			[801] = {mincount = 0, maxcount = 1,},
			[802] = {mincount = 0, maxcount = 1,},
		},
	},
	
	--区域3
	[3] =
	{
		avatarInfoId = 0, --皮肤id（0为随机）
		link = {regionId = 1, fx = 1.0, fy = 0.0,}, --参考区域id, 系数x,系数y
		width_rate = 0.5,
		height_rate = 0.5,
		tonext = true,
		toprevious = true,
		terminal = false, --最后一关？
		mutation_maxcount = 2, --最大突变次数
		grouplimit = --组数量上限限制
		{
			[4] = {mincount = 0, maxcount = 1,}, --铁人雕像 5171
			[2] = {mincount = 0, maxcount = 1,}, --看守所 11210
			[6] = {mincount = 0, maxcount = 1,}, --宠物治疗 5186
			[8] = {mincount = 0, maxcount = 1,}, --平房X
			[9] = {mincount = 0, maxcount = 1,}, --宠物雇佣
			[10] = {mincount = 0, maxcount = 1,}, --水晶商店
			[700] = {mincount = 0, maxcount = 1,},
			[701] = {mincount = 0, maxcount = 1,},
			[800] = {mincount = 0, maxcount = 1,},
			[801] = {mincount = 0, maxcount = 1,},
			[802] = {mincount = 0, maxcount = 1,},
		},
	},
	
	--区域4
	[4] =
	{
		avatarInfoId = 0, --皮肤id（0为随机）
		link = {regionId = 1, fx = 1.0, fy = 1.0,}, --参考区域id, 系数x,系数y
		width_rate = 0.5,
		height_rate = 0.5,
		tonext = true,
		toprevious = true,
		terminal = true, --最后一关？
		mutation_maxcount = 2, --最大突变次数
		grouplimit = --组数量上限限制
		{
			[4] = {mincount = 0, maxcount = 1,}, --铁人雕像 5171
			[2] = {mincount = 0, maxcount = 1,}, --看守所 11210
			[6] = {mincount = 0, maxcount = 1,}, --宠物治疗 5186
			[8] = {mincount = 0, maxcount = 1,}, --平房X
			[9] = {mincount = 0, maxcount = 1,}, --宠物雇佣
			[10] = {mincount = 0, maxcount = 0,}, --水晶商店
			[700] = {mincount = 0, maxcount = 1,},
			[701] = {mincount = 0, maxcount = 1,},
			[800] = {mincount = 0, maxcount = 1,},
			[801] = {mincount = 0, maxcount = 1,},
			[802] = {mincount = 0, maxcount = 1,},
		},
	},
	
	--启动图
	[5] =
	{
		avatarInfoId = 0, --皮肤id（0为随机）
		link = {regionId = 0, fx = 1.0, fy = 1.0,}, --参考区域id, 系数x,系数y
		width_rate = 1,
		height_rate = 1,
		tonext = true,
		toprevious = false,
		terminal = false, --最后一关？
	},
	
	--区域1001（用户自定义地图）
	[1001] =
	{
		avatarInfoId = 1001, --皮肤id
		link = {regionId = 1, fx = 1.0, fy = 1.0,}, --参考区域id, 系数x,系数y
		width_rate = 0.5,
		height_rate = 0.5,
		tonext = false,
		toprevious = false,
		terminal = true, --最后一关？
		mutation_maxcount = 2, --最大突变次数
		grouplimit = --组数量上限限制
		{
			[4] = {mincount = 0, maxcount = 1,}, --铁人雕像 5171
			[2] = {mincount = 0, maxcount = 1,}, --看守所 11210
			[6] = {mincount = 0, maxcount = 1,}, --宠物治疗 5186
			[8] = {mincount = 0, maxcount = 1,}, --平房X
			[9] = {mincount = 0, maxcount = 1,}, --宠物雇佣
			[700] = {mincount = 0, maxcount = 1,},
			[701] = {mincount = 0, maxcount = 1,},
			[800] = {mincount = 0, maxcount = 1,},
			[801] = {mincount = 0, maxcount = 1,},
			[802] = {mincount = 0, maxcount = 1,},
		},
	},
	
}
