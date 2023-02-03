--战车随机单位表
hVar.RANDMAP_ROOM_ENEMY_UNIT =
{
	[1] = {11300,11301,11302,11303,},--光球蜘蛛
	
	[2] = {11330,11331,11332,11333,},--机器人
	
	[3] = {11208,11303,},
	
	[4] = {13009,13010,},---油桶tnt
	
	[5] = {11201,11237,},---菊花塔
	
	[6] = {5191,5191,11203,},---集装箱+透明块
	
	[7] = {5096,5097,5098,5099,},---菌毯

	[8] = {5136,},---金属箱
	[9] = {5136,5191,5191,5191,},---金属箱+集装箱
	[10] = {5136,11203,},---金属箱+透明块

	[11] = {5103,5103,5148,5148,11203,},---虫卵+透明块
	[12] = {5136,5136,11203,},---金属箱+透明块(2)
	
	---[危险度1]
	[100] = {11300,11301,},--生化系
	[101] = {11330,11333,},--机械系
	[102] = {11300,11301,11330,11333,11304,},--混合
	---[危险度2]
	[110] = {11302,11303,},--生化系
	[111] = {11331,11334,},--机械系
	---[危险度3]
	[120] = {11332,11335,},--机械系
	[121] = {11363,11390,},--星河虫+小飞机
	---[危险度4]
	[130] = {11404,},--触手怪
	[131] = {11392,16000,},--虫系
	[132] = {11336,11391,},--菱形机器人+小飞碟A
	[133] = {11392,11362,},--虫系2
	---[危险度5]
	[140] = {16008,},--埋地刺蛇
	[141] = {11306,11393,},--钢铁大脑怪+小飞碟B
	[142] = {11404,11490},--触手怪+钢铁气球
	[143] = {16008,11306,},
	[144] = {11364,},--埋地刺蛇2
	---[危险度6]
	[150] = {11533,11537,},--小异形
	---[危险度7]
	[160] = {11300,11306,11390,},--生化系
	[161] = {11302,11335,11336,},--机械系
	[162] = {11391,11393,},--飞碟系
	[163] = {16008,11392,11533,11537,},--虫系

	---Elite[危险度1]
	[200] = {11400,11401,},--生化系
	[201] = {11430,11433,},--机械系
	[202] = {11400,11401,11430,11433,},--混合
	---Elite[危险度2]
	[210] = {11402,11403,},--生化系
	[211] = {11431,11434,},--机械系
	---Elite[危险度3]
	[220] = {11432,11435,},--机械系
	[221] = {11432,11435,11460},
	---Elite[危险度4]
	[230] = {11436,16005,},
	---Elite[危险度6]
	[250] = {11538,},--异形
}

--单位突变表
hVar.RANDMAP_ROOM_UNIT_MUTATION =
{
	[5191] = {tounit = {5198,}, probability = 1,},
	[5103] = {tounit = {13002,13003,}, probability = 5,},
	[5148] = {tounit = {13002,13003,}, probability = 5,},
	[11300] = {tounit = {11400,}, probability = 5,},
	[11301] = {tounit = {11401,}, probability = 5,},
	[11302] = {tounit = {11402,}, probability = 5,},
	[11303] = {tounit = {11403,}, probability = 5,},
	[11330] = {tounit = {11430,}, probability = 5,},
	[11331] = {tounit = {11431,}, probability = 5,},
	[11332] = {tounit = {11432,}, probability = 5,},
	[11333] = {tounit = {11433,}, probability = 5,},
	[11334] = {tounit = {11434,}, probability = 5,},
	[11335] = {tounit = {11435,}, probability = 5,},
	[11336] = {tounit = {11436,}, probability = 5,},
	[11363] = {tounit = {11460,}, probability = 5,},
	[16000] = {tounit = {16005,}, probability = 5,},
	[11533] = {tounit = {11538,}, probability = 5,},
	[11537] = {tounit = {11538,}, probability = 5,},
}

--战车出怪组
hVar.RANDMAP_ROOM_ENEMY_GROUP =
{
	--空地
	[1] =
	{
		box = {0, 0, 240, 240},
		totalWave = 0, --最大波数
		--[[
		totalWave = 3, --最大波数
		waves =
		{
			[1] = --第1波
			{
				delayTime = 2000, --单位:毫秒（填-1表示永远等待）
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				
				{unidId = 11204, offsetX = {40, 200,}, offsetY = {40, 200,},}, --箱子
			},
			
			[2] = --第2波
			{
				delayTime = 20000, --单位:毫秒（填-1表示永远等待）
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				
				{unidId = 11210, offsetX = {120, 120,}, offsetY = {120, 120,},}, --看守所
			},
			
			[3] = --第3波
			{
				delayTime = 40000, --单位:毫秒（填-1表示永远等待）
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				
				{unidId = 11210, offsetX = {120, 120,}, offsetY = {120, 120,},}, --看守所
			},
		},
		]]
	},
	
	--看守所+围墙
	[2] =
	{
		box = {0, 0, 240, 240},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{unidId = 11210, offsetX = {120, 120,}, offsetY = {120, 120,},}, --看守所
				{unidId = 11106, offsetX = {120, 120,}, offsetY = {120, 120,},}, --围墙
			},
		},
	},
	
	--箱子
	[3] =
	{
		box = {0, 0, 240, 240},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				delayTime = 2000,
				{unidId = 11204, offsetX = {40, 200,}, offsetY = {40, 200,},}, --箱子
			},
		},
	},
	
	--铁人雕像
	[4] =
	{
		box = {0, 0, 240, 240},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{unidId = 5171, offsetX = 120, offsetY = 120, side = 0,}, --铁人
			},
		},
	},
	
	--油桶tnt*1
	[5] =
	{
		box = {0, 0, 120, 120},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "randunit", randId = 4, offsetX = {30, 90,}, offsetY = {30, 90,},},
			},
		},
	},
	
	--宠物治疗
	[6] =
	{
		box = {0, 0, 240, 240},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{unidId = 5186, offsetX = 120, offsetY = 120,side=0,},
			},
		},
	},
	
	--存档点
	[7] =
	{
		box = {0, 0, 240, 240},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{unidId = 5197, offsetX = 180, offsetY = 120,side=0,},
				{unidId = 11008, offsetX = 240, offsetY = 120, angle = 90, side=0,},
				--{unidId = 11008, offsetX = 100, offsetY = 100, angle = 45, side=0,},
			},
		},
	},

	--平房X+围墙
	[8] =
	{
		box = {0, 0, 240, 240},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{unidId = 13000, offsetX = 120, offsetY = 120,}, --平房X
				{unidId = 13001, offsetX = 120, offsetY = 120,}, --围墙
			},
		},
	},

	--雇佣宠物
	[9] =
	{
		box = {0, 0, 240, 240},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{unidId = 5182, offsetX = 140, offsetY = 140,},
				{unidId = 15504, offsetX = 120, offsetY = 120,angle = 270,},
			},
		},
	},

	--水晶商店
	[10] =
	{
		box = {0, 0, 240, 240},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{unidId = 13006, offsetX = 120, offsetY = 120, side = 0,},
			},
		},
	},
	
	--横混合箱
	[50] =
	{
		box = {0, 0, 288, 144},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "randunit", randId = 9, offsetX = 48, offsetY = 48, side = 23,},
				{type = "randunit", randId = 9, offsetX = 96, offsetY = 48, side = 23,},
				{type = "randunit", randId = 9, offsetX = 144, offsetY = 48, side = 23,},
				{type = "randunit", randId = 9, offsetX = 192, offsetY = 48, side = 23,},
			},
		},
	},
	
	--竖混合箱
	[51] =
	{
		box = {0, 0, 144, 288},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "randunit", randId = 9, offsetX = 48, offsetY = 48, side = 23,},
				{type = "randunit", randId = 9, offsetX = 48, offsetY = 96, side = 23,},
				{type = "randunit", randId = 9, offsetX = 48, offsetY = 144, side = 23,},
				{type = "randunit", randId = 9, offsetX = 48, offsetY = 192, side = 23,},
			},
		},
	},
	
	--可破坏集装箱
	--形状：田
	[52] =
	{
		box = {0, 0, 96, 96},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "randunit", randId = 6, offsetX = 0, offsetY = 0, side = 23,},
				{type = "randunit", randId = 6, offsetX = 48, offsetY = 0, side = 23,},
				{type = "randunit", randId = 6, offsetX = 0, offsetY = 48, side = 23,},
				{type = "randunit", randId = 6, offsetX = 48, offsetY = 48, side = 23,},
			},
		},
	},
	
	--形状：井
	[53] =
	{
		box = {0, 0, 144, 144},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "randunit", randId = 6, offsetX = 0, offsetY = 0, side = 23,},
				{type = "randunit", randId = 6, offsetX = 48, offsetY = 0, side = 23,},
				{type = "randunit", randId = 6, offsetX = 96, offsetY = 0, side = 23,},
				{type = "randunit", randId = 6, offsetX = 0, offsetY = 48, side = 23,},
				{type = "randunit", randId = 6, offsetX = 48, offsetY = 48, side = 23,},
				{type = "randunit", randId = 6, offsetX = 96, offsetY = 48, side = 23,},
				{type = "randunit", randId = 6, offsetX = 0, offsetY = 96, side = 23,},
				{type = "randunit", randId = 6, offsetX = 48, offsetY = 96, side = 23,},
				{type = "randunit", randId = 6, offsetX = 96, offsetY = 96, side = 23,},
			},
		},
	},

	--金属箱
	--形状：田
	[54] =
	{
		box = {0, 0, 96, 96},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "randunit", randId = 9, offsetX = 0, offsetY = 0, side = 23,},
				{type = "randunit", randId = 9, offsetX = 48, offsetY = 0, side = 23,},
				{type = "randunit", randId = 9, offsetX = 0, offsetY = 48, side = 23,},
				{type = "randunit", randId = 9, offsetX = 48, offsetY = 48, side = 23,},
			},
		},
	},
	
	--形状：井
	[55] =
	{
		box = {0, 0, 144, 144},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "randunit", randId = 9, offsetX = 0, offsetY = 0, side = 23,},
				{type = "randunit", randId = 9, offsetX = 48, offsetY = 0, side = 23,},
				{type = "randunit", randId = 9, offsetX = 96, offsetY = 0, side = 23,},
				{type = "randunit", randId = 9, offsetX = 0, offsetY = 48, side = 23,},
				{type = "randunit", randId = 9, offsetX = 48, offsetY = 48, side = 23,},
				{type = "randunit", randId = 9, offsetX = 96, offsetY = 48, side = 23,},
				{type = "randunit", randId = 9, offsetX = 0, offsetY = 96, side = 23,},
				{type = "randunit", randId = 9, offsetX = 48, offsetY = 96, side = 23,},
				{type = "randunit", randId = 9, offsetX = 96, offsetY = 96, side = 23,},
			},
		},
	},

	--L形1
	[56] =
	{
		box = {0, 0, 240, 240},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "randunit", randId = 8, offsetX = 96, offsetY = 96, side = 23,},
				{type = "randunit", randId = 8, offsetX = 144, offsetY = 96, side = 23,},
				{type = "randunit", randId = 8, offsetX = 96, offsetY = 144, side = 23,},
				{type = "randunit", randId = 10, offsetX = 192, offsetY = 96, side = 23,},
				{type = "randunit", randId = 10, offsetX = 96, offsetY = 192, side = 23,},
			},
		},
	},

	--L形2
	[57] =
	{
		box = {0, 0, 240, 240},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "randunit", randId = 8, offsetX = 192, offsetY = 96, side = 23,},
				{type = "randunit", randId = 8, offsetX = 144, offsetY = 96, side = 23,},
				{type = "randunit", randId = 8, offsetX = 192, offsetY = 144, side = 23,},
				{type = "randunit", randId = 10, offsetX = 96, offsetY = 96, side = 23,},
				{type = "randunit", randId = 10, offsetX = 192, offsetY = 192, side = 23,},
			},
		},
	},

	--L形3
	[58] =
	{
		box = {0, 0, 240, 240},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "randunit", randId = 8, offsetX = 96, offsetY = 192, side = 23,},
				{type = "randunit", randId = 8, offsetX = 96, offsetY = 144, side = 23,},
				{type = "randunit", randId = 8, offsetX = 144, offsetY = 192, side = 23,},
				{type = "randunit", randId = 10, offsetX = 96, offsetY = 96, side = 23,},
				{type = "randunit", randId = 10, offsetX = 192, offsetY = 192, side = 23,},
			},
		},
	},

	--L形4
	[59] =
	{
		box = {0, 0, 240, 240},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "randunit", randId = 8, offsetX = 192, offsetY = 192, side = 23,},
				{type = "randunit", randId = 8, offsetX = 144, offsetY = 192, side = 23,},
				{type = "randunit", randId = 8, offsetX = 192, offsetY = 144, side = 23,},
				{type = "randunit", randId = 10, offsetX = 96, offsetY = 192, side = 23,},
				{type = "randunit", randId = 10, offsetX = 192, offsetY = 96, side = 23,},
			},
		},
	},

	--可破坏虫卵
	--形状：田
	[60] =
	{
		box = {0, 0, 96, 96},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "randunit", randId = 11, offsetX = 0, offsetY = 0, side = 23,},
				{type = "randunit", randId = 11, offsetX = 48, offsetY = 0, side = 23,},
				{type = "randunit", randId = 11, offsetX = 0, offsetY = 48, side = 23,},
				{type = "randunit", randId = 11, offsetX = 48, offsetY = 48, side = 23,},
			},
		},
	},
	
	--形状：井
	[61] =
	{
		box = {0, 0, 144, 144},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "randunit", randId = 11, offsetX = 0, offsetY = 0, side = 23,},
				{type = "randunit", randId = 11, offsetX = 48, offsetY = 0, side = 23,},
				{type = "randunit", randId = 11, offsetX = 96, offsetY = 0, side = 23,},
				{type = "randunit", randId = 11, offsetX = 0, offsetY = 48, side = 23,},
				{type = "randunit", randId = 11, offsetX = 48, offsetY = 48, side = 23,},
				{type = "randunit", randId = 11, offsetX = 96, offsetY = 48, side = 23,},
				{type = "randunit", randId = 11, offsetX = 0, offsetY = 96, side = 23,},
				{type = "randunit", randId = 11, offsetX = 48, offsetY = 96, side = 23,},
				{type = "randunit", randId = 11, offsetX = 96, offsetY = 96, side = 23,},
			},
		},
	},

	--横金属箱(*3)
	[62] =
	{
		box = {0, 0, 240, 144},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "randunit", randId = 12, offsetX = 48, offsetY = 48, side = 23,},
				{type = "randunit", randId = 12, offsetX = 96, offsetY = 48, side = 23,},
				{type = "randunit", randId = 12, offsetX = 144, offsetY = 48, side = 23,},
			},
		},
	},
	
	--竖金属箱(*3)
	[63] =
	{
		box = {0, 0, 144, 240},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "randunit", randId = 12, offsetX = 48, offsetY = 48, side = 23,},
				{type = "randunit", randId = 12, offsetX = 48, offsetY = 96, side = 23,},
				{type = "randunit", randId = 12, offsetX = 48, offsetY = 144, side = 23,},
			},
		},
	},

	--横金属箱(*4)
	[64] =
	{
		box = {0, 0, 288, 144},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "randunit", randId = 12, offsetX = 48, offsetY = 48, side = 23,},
				{type = "randunit", randId = 12, offsetX = 96, offsetY = 48, side = 23,},
				{type = "randunit", randId = 12, offsetX = 144, offsetY = 48, side = 23,},
				{type = "randunit", randId = 12, offsetX = 192, offsetY = 48, side = 23,},
			},
		},
	},
	
	--竖金属箱(*4)
	[65] =
	{
		box = {0, 0, 144, 288},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "randunit", randId = 12, offsetX = 48, offsetY = 48, side = 23,},
				{type = "randunit", randId = 12, offsetX = 48, offsetY = 96, side = 23,},
				{type = "randunit", randId = 12, offsetX = 48, offsetY = 144, side = 23,},
				{type = "randunit", randId = 12, offsetX = 48, offsetY = 192, side = 23,},
			},
		},
	},
	
	--菊花塔*1
	[100] =
	{
		box = {0, 0, 300, 300},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "randunit", randId = 5, offsetX = 150, offsetY = 150,}, --菊花塔
				{unidId = 5007, offsetX = 150, offsetY = 70,}, --轨道（上横）
				{unidId = 5007, offsetX = 150, offsetY = 230,}, --轨道（下横）
				{unidId = 5008, offsetX = 70, offsetY = 150, angle = 180,}, --轨道（左中）
				{unidId = 5008, offsetX = 230, offsetY = 150,}, --轨道（右中）
				{unidId = 5013, offsetX = 70, offsetY = 70, angle = 180,}, --轨道（左上）
				{unidId = 5014, offsetX = 70, offsetY = 230, angle = 180,}, --轨道（左下）
				{unidId = 5013, offsetX = 230, offsetY = 70,}, --轨道（右上）
				{unidId = 5014, offsetX = 230, offsetY = 230,}, --轨道（右下）
			},
		},
	},

	--滑轨菊花塔+横轨道
	[101] =
	{
		box = {0, 0, 360, 180},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{unidId = 11207, offsetX = 180, offsetY = 90, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] }, --滑轨菊花塔
				{unidId = 5007, offsetX = 180, offsetY = 90,}, --轨道（横）
				{unidId = 5066, offsetX = 72, offsetY = 90,}, --轨道末端（横）
				{unidId = 5015, offsetX =  288, offsetY = 90,}, --轨道末端（横）
			},
		},
	},
	
	--滑轨菊花塔+竖轨道
	[102] =
	{
		box = {0, 0, 180, 360},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{unidId = 11207, offsetX = 90, offsetY = 180, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.VERTICAL, --[[竖向走]] }, --滑轨菊花塔
				{unidId = 5008, offsetX = 90, offsetY = 180,}, --轨道（竖）
				{unidId = 5016, offsetX = 90, offsetY = 72,}, --轨道末端（竖上）
				{unidId = 5017, offsetX = 90, offsetY = 288,}, --轨道末端（竖下）
			},
		},
	},

	--火坑
	[103] =
	{
		box = {0, 0, 100, 100},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				--{unidId = 13004, offsetX = 50, offsetY = 50,},
				--{unidId = 13004, offsetX = 150, offsetY = 50,},
				--{unidId = 13004, offsetX = 50, offsetY = 150,},
				--{unidId = 13004, offsetX = 150, offsetY = 150,},
			},
		},
	},

	--通路火坑
	[104] =
	{
		box = {0, 0, 200, 200},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{unidId = 13004, offsetX = 25, offsetY = 0,},
				{unidId = 13004, offsetX = 125, offsetY = 0,},
				{unidId = 13004, offsetX = 225, offsetY = 0,},
				{unidId = 13004, offsetX = 25, offsetY = 100,},
				{unidId = 13004, offsetX = 125, offsetY = 100,},
				{unidId = 13004, offsetX = 225, offsetY = 100,},
				{unidId = 13004, offsetX = 25, offsetY = 200,},
				{unidId = 13004, offsetX = 125, offsetY = 200,},
				{unidId = 13004, offsetX = 225, offsetY = 200,},
			},
		},
	},

	--通路毒坑
	[105] =
	{
		box = {0, 0, 200, 200},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{unidId = 13015, offsetX = 25, offsetY = 0,},
				{unidId = 13015, offsetX = 125, offsetY = 0,},
				{unidId = 13015, offsetX = 225, offsetY = 0,},
				{unidId = 13015, offsetX = 25, offsetY = 100,},
				{unidId = 13015, offsetX = 125, offsetY = 100,},
				{unidId = 13015, offsetX = 225, offsetY = 100,},
				{unidId = 13015, offsetX = 25, offsetY = 200,},
				{unidId = 13015, offsetX = 125, offsetY = 200,},
				{unidId = 13015, offsetX = 225, offsetY = 200,},
			},
		},
	},

	--通路电坑
	[106] =
	{
		box = {0, 0, 200, 200},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{unidId = 13016, offsetX = 25, offsetY = 0,},
				{unidId = 13016, offsetX = 125, offsetY = 0,},
				{unidId = 13016, offsetX = 225, offsetY = 0,},
				{unidId = 13016, offsetX = 25, offsetY = 100,},
				{unidId = 13016, offsetX = 125, offsetY = 100,},
				{unidId = 13016, offsetX = 225, offsetY = 100,},
				{unidId = 13016, offsetX = 25, offsetY = 200,},
				{unidId = 13016, offsetX = 125, offsetY = 200,},
				{unidId = 13016, offsetX = 225, offsetY = 200,},
			},
		},
	},
	
	
	
	--[危险度1]横轨道+生化系*4
	[200] =
	{
		box = {0, 0, 360, 240},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "group", groupId = 50, offsetX = 0, offsetY = {0, 60,},},
				{type = "randunit", randId = 100, offsetX = {0, 360,}, offsetY = {0, 240,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
				{type = "randunit", randId = 100, offsetX = {0, 360,}, offsetY = {0, 240,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
				{type = "randunit", randId = 100, offsetX = {0, 360,}, offsetY = {0, 240,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
				{type = "randunit", randId = 100, offsetX = {0, 360,}, offsetY = {0, 240,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
			},
		},
	},
	
	--[危险度1]竖轨道+生化系*4
	[201] =
	{
		box = {0, 0, 240, 360},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "group", groupId = 51, offsetX = {0, 60,}, offsetY = 0,},
				{type = "randunit", randId = 100, offsetX = {0, 240,}, offsetY = {0, 360,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.VERTICAL, --[[竖向走]] },
				{type = "randunit", randId = 100, offsetX = {0, 240,}, offsetY = {0, 360,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.VERTICAL, --[[竖向走]] },
				{type = "randunit", randId = 100, offsetX = {0, 240,}, offsetY = {0, 360,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.VERTICAL, --[[竖向走]] },
				{type = "randunit", randId = 100, offsetX = {0, 240,}, offsetY = {0, 360,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.VERTICAL, --[[竖向走]] },
			},
		},
	},
	
	--[危险度1]中心障碍+生化系*4
	[202] =
	{
		box = {0, 0, 288, 288},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "group", groupId = 52, offsetX = {48, 192,}, offsetY = 0,},
				{type = "randunit", randId = 100, offsetX = {0, 288,}, offsetY = {0, 96,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
				{type = "randunit", randId = 100, offsetX = {0, 96,}, offsetY = {0, 288,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.VERTICAL, --[[竖向走]] },
				{type = "randunit", randId = 100, offsetX = {192, 288,}, offsetY = {0, 288,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.VERTICAL, --[[竖向走]] },
				{type = "randunit", randId = 100, offsetX = {0, 288,}, offsetY = {192, 288,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
			},
		},
	},

	--[危险度2]横轨道+生化系*4
	[210] =
	{
		box = {0, 0, 360, 240},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "group", groupId = 50, offsetX = 0, offsetY = {0, 60,},},
				{type = "randunit", randId = 110, offsetX = {0, 360,}, offsetY = {0, 240,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
				{type = "randunit", randId = 110, offsetX = {0, 360,}, offsetY = {0, 240,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
				{type = "randunit", randId = 110, offsetX = {0, 360,}, offsetY = {0, 240,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
				{type = "randunit", randId = 110, offsetX = {0, 360,}, offsetY = {0, 240,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
			},
		},
	},
	
	--[危险度2]竖轨道+生化系*4
	[211] =
	{
		box = {0, 0, 240, 360},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "group", groupId = 51, offsetX = {0, 60,}, offsetY = 0,},
				{type = "randunit", randId = 110, offsetX = {0, 240,}, offsetY = {0, 360,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.VERTICAL, --[[竖向走]] },
				{type = "randunit", randId = 110, offsetX = {0, 240,}, offsetY = {0, 360,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.VERTICAL, --[[竖向走]] },
				{type = "randunit", randId = 110, offsetX = {0, 240,}, offsetY = {0, 360,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.VERTICAL, --[[竖向走]] },
				{type = "randunit", randId = 110, offsetX = {0, 240,}, offsetY = {0, 360,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.VERTICAL, --[[竖向走]] },
			},
		},
	},
	
	--[危险度2]中心障碍+生化系*4
	[212] =
	{
		box = {0, 0, 288, 288},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "group", groupId = 52, offsetX = {48, 192,}, offsetY = 0,},
				{type = "randunit", randId = 110, offsetX = {0, 288,}, offsetY = {0, 96,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
				{type = "randunit", randId = 110, offsetX = {0, 96,}, offsetY = {0, 288,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.VERTICAL, --[[竖向走]] },
				{type = "randunit", randId = 110, offsetX = {192, 288,}, offsetY = {0, 288,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.VERTICAL, --[[竖向走]] },
				{type = "randunit", randId = 110, offsetX = {0, 288,}, offsetY = {192, 288,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
			},
		},
	},

	--[危险度5]横轨道+生化系*4
	[220] =
	{
		box = {0, 0, 360, 240},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "group", groupId = 50, offsetX = 0, offsetY = {0, 60,},},
				{type = "randunit", randId = 141, offsetX = {0, 360,}, offsetY = {0, 240,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
				{type = "randunit", randId = 141, offsetX = {0, 360,}, offsetY = {0, 240,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
				{type = "randunit", randId = 141, offsetX = {0, 360,}, offsetY = {0, 240,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
				{type = "randunit", randId = 141, offsetX = {0, 360,}, offsetY = {0, 240,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
			},
		},
	},
	
	--[危险度5]竖轨道+生化系*4
	[221] =
	{
		box = {0, 0, 240, 360},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "group", groupId = 51, offsetX = {0, 60,}, offsetY = 0,},
				{type = "randunit", randId = 141, offsetX = {0, 240,}, offsetY = {0, 360,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.VERTICAL, --[[竖向走]] },
				{type = "randunit", randId = 141, offsetX = {0, 240,}, offsetY = {0, 360,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.VERTICAL, --[[竖向走]] },
				{type = "randunit", randId = 141, offsetX = {0, 240,}, offsetY = {0, 360,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.VERTICAL, --[[竖向走]] },
				{type = "randunit", randId = 141, offsetX = {0, 240,}, offsetY = {0, 360,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.VERTICAL, --[[竖向走]] },
			},
		},
	},
	
	--[危险度5]中心障碍+生化系*4
	[222] =
	{
		box = {0, 0, 288, 288},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "group", groupId = 52, offsetX = {48, 192,}, offsetY = 0,},
				{type = "randunit", randId = 141, offsetX = {0, 288,}, offsetY = {0, 96,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
				{type = "randunit", randId = 141, offsetX = {0, 96,}, offsetY = {0, 288,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.VERTICAL, --[[竖向走]] },
				{type = "randunit", randId = 141, offsetX = {192, 288,}, offsetY = {0, 288,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.VERTICAL, --[[竖向走]] },
				{type = "randunit", randId = 141, offsetX = {0, 288,}, offsetY = {192, 288,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
			},
		},
	},

	--[危险度7]横轨道+生化系*4
	[230] =
	{
		box = {0, 0, 360, 240},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "group", groupId = 50, offsetX = 0, offsetY = {0, 60,},},
				{type = "randunit", randId = 160, offsetX = {0, 360,}, offsetY = {0, 240,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
				{type = "randunit", randId = 160, offsetX = {0, 360,}, offsetY = {0, 240,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
				{type = "randunit", randId = 160, offsetX = {0, 360,}, offsetY = {0, 240,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
				{type = "randunit", randId = 160, offsetX = {0, 360,}, offsetY = {0, 240,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
			},
		},
	},
	
	--[危险度7]竖轨道+生化系*4
	[231] =
	{
		box = {0, 0, 240, 360},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "group", groupId = 51, offsetX = {0, 60,}, offsetY = 0,},
				{type = "randunit", randId = 160, offsetX = {0, 240,}, offsetY = {0, 360,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.VERTICAL, --[[竖向走]] },
				{type = "randunit", randId = 160, offsetX = {0, 240,}, offsetY = {0, 360,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.VERTICAL, --[[竖向走]] },
				{type = "randunit", randId = 160, offsetX = {0, 240,}, offsetY = {0, 360,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.VERTICAL, --[[竖向走]] },
				{type = "randunit", randId = 160, offsetX = {0, 240,}, offsetY = {0, 360,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.VERTICAL, --[[竖向走]] },
			},
		},
	},
	
	--[危险度7]中心障碍+生化系*4
	[232] =
	{
		box = {0, 0, 288, 288},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "group", groupId = 52, offsetX = {48, 192,}, offsetY = 0,},
				{type = "randunit", randId = 160, offsetX = {0, 288,}, offsetY = {0, 96,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
				{type = "randunit", randId = 160, offsetX = {0, 96,}, offsetY = {0, 288,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.VERTICAL, --[[竖向走]] },
				{type = "randunit", randId = 160, offsetX = {192, 288,}, offsetY = {0, 288,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.VERTICAL, --[[竖向走]] },
				{type = "randunit", randId = 160, offsetX = {0, 288,}, offsetY = {192, 288,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
			},
		},
	},

	--[危险度1]横轨道+机械系*4
	[300] =
	{
		box = {0, 0, 360, 240},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "group", groupId = 50, offsetX = 0, offsetY = {0, 60,},},
				{type = "randunit", randId = 101, offsetX = {0, 360,}, offsetY = {0, 240,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
				{type = "randunit", randId = 101, offsetX = {0, 360,}, offsetY = {0, 240,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
				{type = "randunit", randId = 101, offsetX = {0, 360,}, offsetY = {0, 240,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
				{type = "randunit", randId = 101, offsetX = {0, 360,}, offsetY = {0, 240,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
			},
		},
	},
	
	--[危险度1]竖轨道+机械系*4
	[301] =
	{
		box = {0, 0, 240, 360},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "group", groupId = 51, offsetX = {0, 60,}, offsetY = 0,},
				{type = "randunit", randId = 101, offsetX = {0, 240,}, offsetY = {0, 360,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.VERTICAL, --[[竖向走]] },
				{type = "randunit", randId = 101, offsetX = {0, 240,}, offsetY = {0, 360,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.VERTICAL, --[[竖向走]] },
				{type = "randunit", randId = 101, offsetX = {0, 240,}, offsetY = {0, 360,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.VERTICAL, --[[竖向走]] },
				{type = "randunit", randId = 101, offsetX = {0, 240,}, offsetY = {0, 360,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.VERTICAL, --[[竖向走]] },
			},
		},
	},
	
	--[危险度1]中心障碍+机械系*4
	[302] =
	{
		box = {0, 0, 288, 288},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "group", groupId = 52, offsetX = {48, 192,}, offsetY = 0,},
				{type = "randunit", randId = 101, offsetX = {0, 288,}, offsetY = {0, 96,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
				{type = "randunit", randId = 101, offsetX = {0, 96,}, offsetY = {0, 288,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.VERTICAL, --[[竖向走]] },
				{type = "randunit", randId = 101, offsetX = {192, 288,}, offsetY = {0, 288,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.VERTICAL, --[[竖向走]] },
				{type = "randunit", randId = 101, offsetX = {0, 288,}, offsetY = {192, 288,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
			},
		},
	},

	--[危险度2]横轨道+机械系*4
	[310] =
	{
		box = {0, 0, 360, 240},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "group", groupId = 50, offsetX = 0, offsetY = {0, 60,},},
				{type = "randunit", randId = 111, offsetX = {0, 360,}, offsetY = {0, 240,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
				{type = "randunit", randId = 111, offsetX = {0, 360,}, offsetY = {0, 240,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
				{type = "randunit", randId = 111, offsetX = {0, 360,}, offsetY = {0, 240,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
				{type = "randunit", randId = 111, offsetX = {0, 360,}, offsetY = {0, 240,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
			},
		},
	},
	
	--[危险度2]竖轨道+机械系*4
	[311] =
	{
		box = {0, 0, 240, 360},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "group", groupId = 51, offsetX = {0, 60,}, offsetY = 0,},
				{type = "randunit", randId = 111, offsetX = {0, 240,}, offsetY = {0, 360,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.VERTICAL, --[[竖向走]] },
				{type = "randunit", randId = 111, offsetX = {0, 240,}, offsetY = {0, 360,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.VERTICAL, --[[竖向走]] },
				{type = "randunit", randId = 111, offsetX = {0, 240,}, offsetY = {0, 360,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.VERTICAL, --[[竖向走]] },
				{type = "randunit", randId = 111, offsetX = {0, 240,}, offsetY = {0, 360,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.VERTICAL, --[[竖向走]] },
			},
		},
	},
	
	--[危险度2]中心障碍+机械系*4
	[312] =
	{
		box = {0, 0, 288, 288},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "group", groupId = 52, offsetX = {48, 192,}, offsetY = 0,},
				{type = "randunit", randId = 111, offsetX = {0, 288,}, offsetY = {0, 96,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
				{type = "randunit", randId = 111, offsetX = {0, 96,}, offsetY = {0, 288,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.VERTICAL, --[[竖向走]] },
				{type = "randunit", randId = 111, offsetX = {192, 288,}, offsetY = {0, 288,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.VERTICAL, --[[竖向走]] },
				{type = "randunit", randId = 111, offsetX = {0, 288,}, offsetY = {192, 288,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
			},
		},
	},

	--[危险度3]横轨道+机械系*4
	[320] =
	{
		box = {0, 0, 360, 240},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "group", groupId = 50, offsetX = 0, offsetY = {0, 60,},},
				{type = "randunit", randId = 120, offsetX = {0, 360,}, offsetY = {0, 240,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
				{type = "randunit", randId = 120, offsetX = {0, 360,}, offsetY = {0, 240,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
				{type = "randunit", randId = 120, offsetX = {0, 360,}, offsetY = {0, 240,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
				{type = "randunit", randId = 120, offsetX = {0, 360,}, offsetY = {0, 240,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
			},
		},
	},
	
	--[危险度3]竖轨道+机械系*4
	[321] =
	{
		box = {0, 0, 240, 360},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "group", groupId = 51, offsetX = {0, 60,}, offsetY = 0,},
				{type = "randunit", randId = 120, offsetX = {0, 240,}, offsetY = {0, 360,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.VERTICAL, --[[竖向走]] },
				{type = "randunit", randId = 120, offsetX = {0, 240,}, offsetY = {0, 360,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.VERTICAL, --[[竖向走]] },
				{type = "randunit", randId = 120, offsetX = {0, 240,}, offsetY = {0, 360,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.VERTICAL, --[[竖向走]] },
				{type = "randunit", randId = 120, offsetX = {0, 240,}, offsetY = {0, 360,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.VERTICAL, --[[竖向走]] },
			},
		},
	},
	
	--[危险度3]中心障碍+机械系*4
	[322] =
	{
		box = {0, 0, 288, 288},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "group", groupId = 52, offsetX = {48, 192,}, offsetY = 0,},
				{type = "randunit", randId = 120, offsetX = {0, 288,}, offsetY = {0, 96,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
				{type = "randunit", randId = 120, offsetX = {0, 96,}, offsetY = {0, 288,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.VERTICAL, --[[竖向走]] },
				{type = "randunit", randId = 120, offsetX = {192, 288,}, offsetY = {0, 288,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.VERTICAL, --[[竖向走]] },
				{type = "randunit", randId = 120, offsetX = {0, 288,}, offsetY = {192, 288,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
			},
		},
	},

	--[危险度7]横轨道+机械系*4
	[330] =
	{
		box = {0, 0, 360, 240},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "group", groupId = 50, offsetX = 0, offsetY = {0, 60,},},
				{type = "randunit", randId = 161, offsetX = {0, 360,}, offsetY = {0, 240,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
				{type = "randunit", randId = 161, offsetX = {0, 360,}, offsetY = {0, 240,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
				{type = "randunit", randId = 161, offsetX = {0, 360,}, offsetY = {0, 240,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
				{type = "randunit", randId = 162, offsetX = {0, 360,}, offsetY = {0, 240,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
			},
		},
	},
	
	--[危险度7]竖轨道+机械系*4
	[331] =
	{
		box = {0, 0, 240, 360},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "group", groupId = 51, offsetX = {0, 60,}, offsetY = 0,},
				{type = "randunit", randId = 161, offsetX = {0, 240,}, offsetY = {0, 360,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.VERTICAL, --[[竖向走]] },
				{type = "randunit", randId = 161, offsetX = {0, 240,}, offsetY = {0, 360,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.VERTICAL, --[[竖向走]] },
				{type = "randunit", randId = 161, offsetX = {0, 240,}, offsetY = {0, 360,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.VERTICAL, --[[竖向走]] },
				{type = "randunit", randId = 162, offsetX = {0, 240,}, offsetY = {0, 360,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.VERTICAL, --[[竖向走]] },
			},
		},
	},
	
	--[危险度7]中心障碍+机械系*4
	[332] =
	{
		box = {0, 0, 288, 288},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "group", groupId = 52, offsetX = {48, 192,}, offsetY = 0,},
				{type = "randunit", randId = 161, offsetX = {0, 288,}, offsetY = {0, 96,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
				{type = "randunit", randId = 161, offsetX = {0, 96,}, offsetY = {0, 288,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.VERTICAL, --[[竖向走]] },
				{type = "randunit", randId = 161, offsetX = {192, 288,}, offsetY = {0, 288,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.VERTICAL, --[[竖向走]] },
				{type = "randunit", randId = 162, offsetX = {0, 288,}, offsetY = {192, 288,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
			},
		},
	},

	--[危险度3]菌毯+分裂虫
	[400] =
	{
		box = {0, 0, 240, 240},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				--{unidId = 11360, offsetX = {40, 200,}, offsetY = {40, 200,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.CIRCLE_CLOCKWISE, --[[圆型走（顺时针）]] },
				--{unidId = 11360, offsetX = {40, 200,}, offsetY = {40, 200,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.CIRCLE_ANTI_CLOCKWISE, --[[圆型走（逆时针）]] },
				{unidId = 11360, offsetX = {100, 140,}, offsetY = {100, 140,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM, --[[随机走]] },
				{unidId = 11360, offsetX = {100, 140,}, offsetY = {100, 140,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM, --[[随机走]] },
				{type = "randunit", randId = 7, offsetX = 120, offsetY = 120,},
			},
		},
	},
	
	--[危险度4]刺蛇
	[410] =
	{
		box = {0, 0, 240, 240},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{unidId = 16000, offsetX = {40, 200,}, offsetY = {40, 200,},},
				{unidId = 16000, offsetX = {40, 200,}, offsetY = {40, 200,},},
				{unidId = 5100, offsetX = {40, 200,}, offsetY = {40, 200,},},
				{unidId = 5100, offsetX = {40, 200,}, offsetY = {40, 200,},},
				{unidId = 5100, offsetX = {40, 200,}, offsetY = {40, 200,},},
				{unidId = 5100, offsetX = {40, 200,}, offsetY = {40, 200,},},
				{type = "randunit", randId = 7, offsetX = 120, offsetY = 120,},
			},
		},
	},

	--[危险度4]飞龙
	[411] =
	{
		box = {0, 0, 240, 240},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{unidId = 11392, offsetX = {40, 200,}, offsetY = {40, 200,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM, --[[随机走]] },
				{unidId = 11392, offsetX = {40, 200,}, offsetY = {40, 200,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM, --[[随机走]] },
				{unidId = 5100, offsetX = {40, 200,}, offsetY = {40, 200,},},
				{unidId = 5100, offsetX = {40, 200,}, offsetY = {40, 200,},},
				{unidId = 5100, offsetX = {40, 200,}, offsetY = {40, 200,},},
				{unidId = 5100, offsetX = {40, 200,}, offsetY = {40, 200,},},
				{type = "randunit", randId = 7, offsetX = 120, offsetY = 120,},
			},
		},
	},

	--[危险度5]埋地刺蛇
	[420] =
	{
		box = {0, 0, 240, 240},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "randunit", randId = 140, offsetX = {40, 200,}, offsetY = {40, 200,},},
				{type = "randunit", randId = 140, offsetX = {40, 200,}, offsetY = {40, 200,},},
				{type = "randunit", randId = 140, offsetX = {40, 200,}, offsetY = {40, 200,},},
				{unidId = 5100, offsetX = {40, 200,}, offsetY = {40, 200,},},
				{unidId = 5100, offsetX = {40, 200,}, offsetY = {40, 200,},},
				{unidId = 5100, offsetX = {40, 200,}, offsetY = {40, 200,},},
				{type = "randunit", randId = 7, offsetX = 120, offsetY = 120,},
			},
		},
	},

	--[危险度6]小异形
	[430] =
	{
		box = {0, 0, 240, 240},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "randunit", randId = 150, offsetX = {40, 200,}, offsetY = {40, 200,},},
				{type = "randunit", randId = 150, offsetX = {40, 200,}, offsetY = {40, 200,},},
				{type = "randunit", randId = 150, offsetX = {40, 200,}, offsetY = {40, 200,},},
				{unidId = 5100, offsetX = {40, 200,}, offsetY = {40, 200,},},
				{unidId = 5100, offsetX = {40, 200,}, offsetY = {40, 200,},},
				{unidId = 5100, offsetX = {40, 200,}, offsetY = {40, 200,},},
				{type = "randunit", randId = 7, offsetX = 120, offsetY = 120,},
			},
		},
	},

	--[危险度7]虫族综合
	[440] =
	{
		box = {0, 0, 240, 240},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "randunit", randId = 163, offsetX = {40, 200,}, offsetY = {40, 200,},},
				{type = "randunit", randId = 163, offsetX = {40, 200,}, offsetY = {40, 200,},},
				{type = "randunit", randId = 163, offsetX = {40, 200,}, offsetY = {40, 200,},},
				{type = "randunit", randId = 163, offsetX = {40, 200,}, offsetY = {40, 200,},},
				{unidId = 5100, offsetX = {40, 200,}, offsetY = {40, 200,},},
				{unidId = 5100, offsetX = {40, 200,}, offsetY = {40, 200,},},
				{unidId = 5100, offsetX = {40, 200,}, offsetY = {40, 200,},},
				{type = "randunit", randId = 7, offsetX = 120, offsetY = 120,},
			},
		},
	},
	
	--[危险度3]小飞机A型
	[500] =
	{
		box = {0, 0, 240, 240},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{unidId = 11390, offsetX = {100, 140,}, offsetY = {100, 140,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM, --[[随机走]] },
				{unidId = 11390, offsetX = {100, 140,}, offsetY = {100, 140,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM, --[[随机走]] },
				--{unidId = 11390, offsetX = {100, 140,}, offsetY = {100, 140,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM, --[[随机走]] },
				--{unidId = 11390, offsetX = {100, 140,}, offsetY = {100, 140,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM, --[[随机走]] },
			},
		},
	},

	--小飞碟
	[501] =
	{
		box = {0, 0, 240, 240},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{unidId = 11391, offsetX = {100, 140,}, offsetY = {100, 140,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM, --[[随机走]] },
				{unidId = 11391, offsetX = {100, 140,}, offsetY = {100, 140,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM, --[[随机走]] },
				--{unidId = 11390, offsetX = {100, 140,}, offsetY = {100, 140,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM, --[[随机走]] },
				--{unidId = 11390, offsetX = {100, 140,}, offsetY = {100, 140,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM, --[[随机走]] },
			},
		},
	},

	--[危险度3]横轨道+星河虫*3+小飞机*1
	[600] =
	{
		box = {0, 0, 360, 240},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "group", groupId = 50, offsetX = 0, offsetY = {0, 60,},},
				{unidId = 11363, offsetX = {0, 360,}, offsetY = {0, 240,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
				{unidId = 11363, offsetX = {0, 360,}, offsetY = {0, 240,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
				{unidId = 11363, offsetX = {0, 360,}, offsetY = {0, 240,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
				{unidId = 11390, offsetX = {100, 140,}, offsetY = {100, 140,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM, --[[随机走]] },
			},
		},
	},
	
	--[危险度3]竖轨道+星河虫*3+小飞机*1
	[601] =
	{
		box = {0, 0, 240, 360},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "group", groupId = 51, offsetX = {0, 60,}, offsetY = 0,},
				{unidId = 11363, offsetX = {0, 240,}, offsetY = {0, 360,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.VERTICAL, --[[竖向走]] },
				{unidId = 11363, offsetX = {0, 240,}, offsetY = {0, 360,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.VERTICAL, --[[竖向走]] },
				{unidId = 11363, offsetX = {0, 240,}, offsetY = {0, 360,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.VERTICAL, --[[竖向走]] },
				{unidId = 11390, offsetX = {100, 140,}, offsetY = {100, 140,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM, --[[随机走]] },
			},
		},
	},
	
	--[危险度3]中心障碍+星河虫*2+小飞机*2
	[602] =
	{
		box = {0, 0, 288, 288},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "group", groupId = 52, offsetX = {48, 192,}, offsetY = 0,},
				{unidId = 11363, offsetX = {0, 288,}, offsetY = {0, 96,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.CIRCLE_ANTI_CLOCKWISE, --[[圆型走（逆时针）]] },
				{unidId = 11363, offsetX = {0, 96,}, offsetY = {0, 288,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.CIRCLE_CLOCKWISE, --[[圆型走（顺时针）]] },
				{unidId = 11390, offsetX = {100, 140,}, offsetY = {100, 140,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM, --[[随机走]] },
				{unidId = 11390, offsetX = {100, 140,}, offsetY = {100, 140,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM, --[[随机走]] },
			},
		},
	},

	--[危险度4]横轨道+菱形机*3+小飞碟*1
	[610] =
	{
		box = {0, 0, 360, 240},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "group", groupId = 50, offsetX = 0, offsetY = {0, 60,},},
				{unidId = 11336, offsetX = {0, 360,}, offsetY = {0, 240,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
				{unidId = 11336, offsetX = {0, 360,}, offsetY = {0, 240,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
				{unidId = 11336, offsetX = {0, 360,}, offsetY = {0, 240,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
				{unidId = 11391, offsetX = {100, 140,}, offsetY = {100, 140,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM, --[[随机走]] },
			},
		},
	},
	
	--[危险度4]竖轨道+菱形机*3+小飞碟*1
	[611] =
	{
		box = {0, 0, 240, 360},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "group", groupId = 51, offsetX = {0, 60,}, offsetY = 0,},
				{unidId = 11336, offsetX = {0, 240,}, offsetY = {0, 360,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.VERTICAL, --[[竖向走]] },
				{unidId = 11336, offsetX = {0, 240,}, offsetY = {0, 360,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.VERTICAL, --[[竖向走]] },
				{unidId = 11336, offsetX = {0, 240,}, offsetY = {0, 360,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.VERTICAL, --[[竖向走]] },
				{unidId = 11391, offsetX = {100, 140,}, offsetY = {100, 140,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM, --[[随机走]] },
			},
		},
	},
	
	--[危险度4]中心障碍+菱形机*2+小飞碟*2
	[612] =
	{
		box = {0, 0, 288, 288},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "group", groupId = 52, offsetX = {48, 192,}, offsetY = 0,},
				{unidId = 11336, offsetX = {0, 288,}, offsetY = {0, 96,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.CIRCLE_ANTI_CLOCKWISE, --[[圆型走（逆时针）]] },
				{unidId = 11336, offsetX = {0, 96,}, offsetY = {0, 288,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.CIRCLE_CLOCKWISE, --[[圆型走（顺时针）]] },
				{unidId = 11391, offsetX = {100, 140,}, offsetY = {100, 140,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM, --[[随机走]] },
				{unidId = 11391, offsetX = {100, 140,}, offsetY = {100, 140,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM, --[[随机走]] },
			},
		},
	},


	--[危险度4]触手怪*1
	[700] =
	{
		box = {0, 0, 300, 300},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "randunit", randId = 130, offsetX = 150, offsetY = 150, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM, --[[随机走]] },
			},
		},
	},

	--[危险度5]触手怪/钢铁气球*1
	[701] =
	{
		box = {0, 0, 300, 300},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "randunit", randId = 142, offsetX = 150, offsetY = 150, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM, --[[随机走]] },
			},
		},
	},

	--[危险度3]采矿区
	[800] =
	{
		box = {0, 0, 480, 480},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{unidId = 11011, offsetX = 100, offsetY = 100,angle = 180,},
				{unidId = 11012, offsetX = 145, offsetY = 150,angle = 0,},
				{unidId = 5140, offsetX = 377, offsetY = 377,angle = 0,},
				{unidId = 5140, offsetX = 397, offsetY = 330,angle = 180,},
				{unidId = 5140, offsetX = 387, offsetY = 280,angle = 0,},
				{unidId = 5140, offsetX = 311, offsetY = 395,angle = 180,},
				{type = "randunit", randId = 221, offsetX = 240, offsetY = 240, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM, --[[随机走]] },
				{type = "randunit", randId = 221, offsetX = 240, offsetY = 240, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM, --[[随机走]] },
			},
		},
	},

	--[危险度4]采矿区
	[801] =
	{
		box = {0, 0, 480, 480},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{unidId = 11011, offsetX = 100, offsetY = 100,angle = 180,},
				{unidId = 11012, offsetX = 145, offsetY = 150,angle = 0,},
				{unidId = 5140, offsetX = 377, offsetY = 377,angle = 0,},
				{unidId = 5140, offsetX = 397, offsetY = 330,angle = 180,},
				{unidId = 5140, offsetX = 387, offsetY = 280,angle = 0,},
				{unidId = 5140, offsetX = 311, offsetY = 395,angle = 180,},
				{type = "randunit", randId = 230, offsetX = 240, offsetY = 240, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM, --[[随机走]] },
				{type = "randunit", randId = 230, offsetX = 240, offsetY = 240, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM, --[[随机走]] },
			},
		},
	},

	--[危险度5]采矿区
	[802] =
	{
		box = {0, 0, 480, 480},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{unidId = 11011, offsetX = 100, offsetY = 100,angle = 180,},
				{unidId = 11012, offsetX = 145, offsetY = 150,angle = 0,},
				{unidId = 5140, offsetX = 377, offsetY = 377,angle = 0,},
				{unidId = 5140, offsetX = 397, offsetY = 330,angle = 180,},
				{unidId = 5140, offsetX = 387, offsetY = 280,angle = 0,},
				{unidId = 5140, offsetX = 311, offsetY = 395,angle = 180,},
				{unidId = 11404, offsetX = 240, offsetY = 240, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM, --[[随机走]] },
			},
		},
	},
	
	--[危险度1]通路随机生化系*1
	[900] =
	{
		box = {0, 0, 200, 200},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "randunit", randId = 100, offsetX = {44, 100,}, offsetY = {44, 100,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
			},
		},
	},
	
	--[危险度1]通路随机机械系*1
	[901] =
	{
		box = {0, 0, 200, 200},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "randunit", randId = 101, offsetX = {44, 100,}, offsetY = {44, 100,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
			},
		},
	},

	--[危险度2]通路随机生化系*1
	[910] =
	{
		box = {0, 0, 200, 200},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "randunit", randId = 110, offsetX = {44, 100,}, offsetY = {44, 100,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
			},
		},
	},
	
	--[危险度2]通路随机机械系*1
	[911] =
	{
		box = {0, 0, 200, 200},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "randunit", randId = 111, offsetX = {44, 100,}, offsetY = {44, 100,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
			},
		},
	},

	--[危险度3]通路随机机械系*1
	[920] =
	{
		box = {0, 0, 200, 200},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "randunit", randId = 120, offsetX = {44, 100,}, offsetY = {44, 100,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
			},
		},
	},

	--[危险度3]通路随机星河虫/小飞机*1
	[921] =
	{
		box = {0, 0, 200, 200},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "randunit", randId = 121, offsetX = {44, 100,}, offsetY = {44, 100,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
			},
		},
	},

	--[危险度4]通路随机*1
	[930] =
	{
		box = {0, 0, 200, 200},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "randunit", randId = 130, offsetX = {44, 100,}, offsetY = {44, 100,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
			},
		},
	},

	--[危险度4]通路随机虫系*1
	[931] =
	{
		box = {0, 0, 200, 200},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "randunit", randId = 131, offsetX = {44, 100,}, offsetY = {44, 100,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
			},
		},
	},

	--[危险度4]通路菱形机/小飞碟*1
	[932] =
	{
		box = {0, 0, 200, 200},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "randunit", randId = 132, offsetX = {44, 100,}, offsetY = {44, 100,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
			},
		},
	},

	--[危险度5]通路随机*1
	[940] =
	{
		box = {0, 0, 200, 200},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "randunit", randId = 143, offsetX = {44, 100,}, offsetY = {44, 100,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
			},
		},
	},

	--[危险度7]通路随机*1
	[960] =
	{
		box = {0, 0, 200, 200},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "randunit", randId = 160, offsetX = {44, 100,}, offsetY = {44, 100,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
			},
		},
	},

	--[危险度7]通路随机*1
	[961] =
	{
		box = {0, 0, 200, 200},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "randunit", randId = 161, offsetX = {44, 100,}, offsetY = {44, 100,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
			},
		},
	},

	--[危险度7]通路随机*1
	[962] =
	{
		box = {0, 0, 200, 200},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "randunit", randId = 163, offsetX = {44, 100,}, offsetY = {44, 100,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.HORIZONTAL, --[[横向走]] },
			},
		},
	},
	
	--测试*1
	[999] =
	{
		box = {0, 0, 240, 240},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "randunit", randId = 3, offsetX = {24, 72,}, offsetY = {24, 72,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM, --[[随机走]] },
			},
		},
	},
	
	
	
	--横轨道+BOSS
	[1000] =
	{
		box = {0, 0, 900, 900},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{type = "group", groupId = 53, offsetX = {192, 240,}, offsetY = {168, 216,},side = 23,},
				{type = "group", groupId = 53, offsetX = {648, 696,}, offsetY = {408, 456,},side = 23,},
				{type = "group", groupId = 53, offsetX = {96, 144,}, offsetY = {624, 672,},side = 23,},
				--{type = "group", groupId = 53, offsetX = 648, offsetY = 648,side = 23,},
				{type = "randunit", randId = 101, offsetX = 450, offsetY = 450,},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
			},
		},
	},
	
	--半兽人战车
	[1001] =
	{
		box = {0, 0, 900, 900},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{unidId = 11510, offsetX = 450, offsetY = 160, },
			},
		},
	},
	
	--飞机母舰
	[1002] =
	{
		box = {0, 0, 900, 900},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{unidId = 11512, offsetX = 450, offsetY = 450, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM, --[[随机走]] },
				{type = "group", groupId = 53, offsetX = {192, 240,}, offsetY = {168, 216,},side = 23,},
				{type = "group", groupId = 53, offsetX = {648, 696,}, offsetY = {408, 456,},side = 23,},
				{type = "group", groupId = 53, offsetX = {96, 144,}, offsetY = {624, 672,},side = 23,},
			},
		},
	},
	
	------光球蜘蛛巨大型
	[1003] =
	{
		box = {0, 0, 900, 900},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{unidId = 16006, offsetX = 450, offsetY = 450,},
				{type = "group", groupId = 53, offsetX = {192, 240,}, offsetY = {168, 216,},side = 23,},
				{type = "group", groupId = 53, offsetX = {648, 696,}, offsetY = {408, 456,},side = 23,},
				{type = "group", groupId = 53, offsetX = {96, 144,}, offsetY = {624, 672,},side = 23,},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
			},
		},
	},
	
	[1004] =
	{
		box = {0, 0, 900, 900},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{unidId = 11502, offsetX = 450, offsetY = 450,},
				{type = "group", groupId = 53, offsetX = {192, 240,}, offsetY = {168, 216,},side = 23,},
				{type = "group", groupId = 53, offsetX = {648, 696,}, offsetY = {408, 456,},side = 23,},
				{type = "group", groupId = 53, offsetX = {96, 144,}, offsetY = {624, 672,},side = 23,},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
			},
		},
	},
	
	--------大型机器人
	[1005] =
	{
		box = {0, 0, 900, 900},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{unidId = 16007, offsetX = 450, offsetY = 450,},
				{type = "group", groupId = 53, offsetX = {192, 240,}, offsetY = {168, 216,},side = 23,},
				{type = "group", groupId = 53, offsetX = {648, 696,}, offsetY = {408, 456,},side = 23,},
				{type = "group", groupId = 53, offsetX = {96, 144,}, offsetY = {624, 672,},side = 23,},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
			},
		},
	},
	
	[1006] =
	{
		box = {0, 0, 900, 900},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{unidId = 11505, offsetX = 450, offsetY = 450,},
				{type = "group", groupId = 53, offsetX = {192, 240,}, offsetY = {168, 216,},side = 23,},
				{type = "group", groupId = 53, offsetX = {648, 696,}, offsetY = {408, 456,},side = 23,},
				{type = "group", groupId = 53, offsetX = {96, 144,}, offsetY = {624, 672,},side = 23,},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
			},
		},
	},
	
	[1007] =
	{
		box = {0, 0, 900, 900},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{unidId = 16001, offsetX = 450, offsetY = 450,},
				{type = "group", groupId = 53, offsetX = {192, 240,}, offsetY = {168, 216,},side = 23,},
				{type = "group", groupId = 53, offsetX = {648, 696,}, offsetY = {408, 456,},side = 23,},
				{type = "group", groupId = 53, offsetX = {96, 144,}, offsetY = {624, 672,},side = 23,},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
			},
		},
	},
	
	[1008] =
	{
		box = {0, 0, 900, 900},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{unidId = 11513, offsetX = 450, offsetY = 70,},
				{unidId = 5101, offsetX = 40, offsetY = 60,},
				{unidId = 5101, offsetX = 160, offsetY = 60,},
				{unidId = 5101, offsetX = 280, offsetY = 60,},
				{unidId = 5101, offsetX = 400, offsetY = 60,},
				{unidId = 5101, offsetX = 520, offsetY = 60,},
				{unidId = 5101, offsetX = 640, offsetY = 60,},
				{unidId = 5101, offsetX = 760, offsetY = 60,},
				{unidId = 5101, offsetX = 880, offsetY = 60,},
				{unidId = 5101, offsetX = 40, offsetY = 100,},
				{unidId = 5101, offsetX = 160, offsetY = 100,},
				{unidId = 5101, offsetX = 280, offsetY = 100,},
				{unidId = 5101, offsetX = 400, offsetY = 100,},
				{unidId = 5101, offsetX = 520, offsetY = 100,},
				{unidId = 5101, offsetX = 640, offsetY = 100,},
				{unidId = 5101, offsetX = 760, offsetY = 100,},
				{unidId = 5101, offsetX = 880, offsetY = 100,},
				{type = "group", groupId = 53, offsetX = {504, 552,}, offsetY = {408, 456,},side = 23,},
				{type = "group", groupId = 53, offsetX = {96, 144,}, offsetY = {480, 528,},side = 23,},
			},
		},
	},

	[1009] =
	{
		box = {0, 0, 900, 900},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{unidId = 11203, offsetX = 450, offsetY = 110,},---透明单位
				{unidId = 11514, offsetX = 450, offsetY = 110,},
				{unidId = 5101, offsetX = 40, offsetY = 60,},
				{unidId = 5101, offsetX = 160, offsetY = 60,},
				{unidId = 5101, offsetX = 280, offsetY = 60,},
				{unidId = 5101, offsetX = 400, offsetY = 60,},
				{unidId = 5101, offsetX = 520, offsetY = 60,},
				{unidId = 5101, offsetX = 640, offsetY = 60,},
				{unidId = 5101, offsetX = 760, offsetY = 60,},
				{unidId = 5101, offsetX = 880, offsetY = 60,},
				{unidId = 5101, offsetX = 40, offsetY = 100,},
				{unidId = 5101, offsetX = 160, offsetY = 100,},
				{unidId = 5101, offsetX = 280, offsetY = 100,},
				{unidId = 5101, offsetX = 400, offsetY = 100,},
				{unidId = 5101, offsetX = 520, offsetY = 100,},
				{unidId = 5101, offsetX = 640, offsetY = 100,},
				{unidId = 5101, offsetX = 760, offsetY = 100,},
				{unidId = 5101, offsetX = 880, offsetY = 100,},
				{type = "group", groupId = 53, offsetX = {504, 552,}, offsetY = {408, 456,},side = 23,},
				{type = "group", groupId = 53, offsetX = {96, 144,}, offsetY = {480, 528,},side = 23,},
			},
		},
	},

	------重装机甲
	[1010] =
	{
		box = {0, 0, 900, 900},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				--{unidId = 11203, offsetX = 450, offsetY = 110,},---透明单位
				{unidId = 11503, offsetX = 450, offsetY = 0,},
			},
		},
	},

	--------高射塔
	[1011] =
	{
		box = {0, 0, 900, 900},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{unidId = 16002, offsetX = 450, offsetY = 450,},
				{type = "group", groupId = 53, offsetX = {192, 240,}, offsetY = {168, 216,},side = 23,},
				{type = "group", groupId = 53, offsetX = {648, 696,}, offsetY = {408, 456,},side = 23,},
				{type = "group", groupId = 53, offsetX = {96, 144,}, offsetY = {624, 672,},side = 23,},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
			},
		},
	},

	--------射击塔
	[1012] =
	{
		box = {0, 0, 900, 900},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{unidId = 16003, offsetX = 450, offsetY = 450,},
				{type = "group", groupId = 53, offsetX = {192, 240,}, offsetY = {168, 216,},side = 23,},
				{type = "group", groupId = 53, offsetX = {648, 696,}, offsetY = {408, 456,},side = 23,},
				{type = "group", groupId = 53, offsetX = {96, 144,}, offsetY = {624, 672,},side = 23,},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
			},
		},
	},

	--------炮台塔
	[1013] =
	{
		box = {0, 0, 900, 900},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{unidId = 16004, offsetX = 450, offsetY = 450,},
				{type = "group", groupId = 53, offsetX = {192, 240,}, offsetY = {168, 216,},side = 23,},
				{type = "group", groupId = 53, offsetX = {648, 696,}, offsetY = {408, 456,},side = 23,},
				{type = "group", groupId = 53, offsetX = {96, 144,}, offsetY = {624, 672,},side = 23,},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
			},
		},
	},

	--------盾牌机器人
	[1014] =
	{
		box = {0, 0, 900, 900},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{unidId = 11516, offsetX = 450, offsetY = 450,},
				{type = "group", groupId = 53, offsetX = {192, 240,}, offsetY = {168, 216,},side = 23,},
				{type = "group", groupId = 53, offsetX = {648, 696,}, offsetY = {408, 456,},side = 23,},
				{type = "group", groupId = 53, offsetX = {96, 144,}, offsetY = {624, 672,},side = 23,},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
			},
		},
	},

	--------钢铁气球MK2
	[1015] =
	{
		box = {0, 0, 900, 900},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{unidId = 11203, offsetX = 450, offsetY = 450,},---透明单位
				{unidId = 11521, offsetX = 450, offsetY = 450,},
				{type = "group", groupId = 53, offsetX = {192, 240,}, offsetY = {168, 216,},side = 23,},
				{type = "group", groupId = 53, offsetX = {648, 696,}, offsetY = {408, 456,},side = 23,},
				{type = "group", groupId = 53, offsetX = {96, 144,}, offsetY = {624, 672,},side = 23,},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
			},
		},
	},

	--------量产机-白
	[1016] =
	{
		box = {0, 0, 900, 900},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{unidId = 11522, offsetX = 450, offsetY = 450,},
				{type = "group", groupId = 53, offsetX = {192, 240,}, offsetY = {168, 216,},side = 23,},
				{type = "group", groupId = 53, offsetX = {648, 696,}, offsetY = {408, 456,},side = 23,},
				{type = "group", groupId = 53, offsetX = {96, 144,}, offsetY = {624, 672,},side = 23,},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
			},
		},
	},

	--------量产机-黑
	[1017] =
	{
		box = {0, 0, 900, 900},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{unidId = 11523, offsetX = 450, offsetY = 450,},
				{type = "group", groupId = 53, offsetX = {192, 240,}, offsetY = {168, 216,},side = 23,},
				{type = "group", groupId = 53, offsetX = {648, 696,}, offsetY = {408, 456,},side = 23,},
				{type = "group", groupId = 53, offsetX = {96, 144,}, offsetY = {624, 672,},side = 23,},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
			},
		},
	},

	--------量产机-白+黑
	[1018] =
	{
		box = {0, 0, 900, 900},
		totalWave = 2, --最大波数
		waves =
		{
			[1] = --第1波
			{
				delayTime = 0,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{unidId = 11524, offsetX = 350, offsetY = 450,},
				{unidId = 11525, offsetX = 550, offsetY = 450,},
				{type = "group", groupId = 53, offsetX = {192, 240,}, offsetY = {168, 216,},side = 23,},
				{type = "group", groupId = 53, offsetX = {648, 696,}, offsetY = {408, 456,},side = 23,},
				{type = "group", groupId = 53, offsetX = {96, 144,}, offsetY = {624, 672,},side = 23,},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
			},
			[2] = --第11波
			{
				delayTime = -1,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{unidId = 11501, offsetX = 450, offsetY = 450,},
			},
		},
	},
	--尤达1
	[1019] =
	{
		box = {0, 0, 900, 900},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{unidId = 11526, offsetX = 450, offsetY = 450,},
				{type = "group", groupId = 53, offsetX = {192, 240,}, offsetY = {168, 216,},side = 23,},
				{type = "group", groupId = 53, offsetX = {648, 696,}, offsetY = {408, 456,},side = 23,},
				{type = "group", groupId = 53, offsetX = {96, 144,}, offsetY = {624, 672,},side = 23,},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
			},
		},
	},
	--尤达2
	[1020] =
	{
		box = {0, 0, 900, 900},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{unidId = 11527, offsetX = 450, offsetY = 450,},
				{type = "group", groupId = 53, offsetX = {192, 240,}, offsetY = {168, 216,},side = 23,},
				{type = "group", groupId = 53, offsetX = {648, 696,}, offsetY = {408, 456,},side = 23,},
				{type = "group", groupId = 53, offsetX = {96, 144,}, offsetY = {624, 672,},side = 23,},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
			},
		},
	},
	--尤达3
	[1021] =
	{
		box = {0, 0, 900, 900},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{unidId = 11528, offsetX = 450, offsetY = 450,},
				{type = "group", groupId = 53, offsetX = {192, 240,}, offsetY = {168, 216,},side = 23,},
				{type = "group", groupId = 53, offsetX = {648, 696,}, offsetY = {408, 456,},side = 23,},
				{type = "group", groupId = 53, offsetX = {96, 144,}, offsetY = {624, 672,},side = 23,},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
			},
		},
	},
	--异形1
	[1022] =
	{
		box = {0, 0, 900, 900},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{unidId = 11529, offsetX = 450, offsetY = 450,},
				{type = "group", groupId = 53, offsetX = {192, 240,}, offsetY = {168, 216,},side = 23,},
				{type = "group", groupId = 53, offsetX = {648, 696,}, offsetY = {408, 456,},side = 23,},
				{type = "group", groupId = 53, offsetX = {96, 144,}, offsetY = {624, 672,},side = 23,},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
			},
		},
	},
	--异形2
	[1023] =
	{
		box = {0, 0, 900, 900},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{unidId = 11530, offsetX = 450, offsetY = 450,},
				{type = "group", groupId = 53, offsetX = {192, 240,}, offsetY = {168, 216,},side = 23,},
				{type = "group", groupId = 53, offsetX = {648, 696,}, offsetY = {408, 456,},side = 23,},
				{type = "group", groupId = 53, offsetX = {96, 144,}, offsetY = {624, 672,},side = 23,},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
			},
		},
	},
	--异形3
	[1024] =
	{
		box = {0, 0, 900, 900},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{unidId = 11531, offsetX = 450, offsetY = 450,},
				{type = "group", groupId = 53, offsetX = {192, 240,}, offsetY = {168, 216,},side = 23,},
				{type = "group", groupId = 53, offsetX = {648, 696,}, offsetY = {408, 456,},side = 23,},
				{type = "group", groupId = 53, offsetX = {96, 144,}, offsetY = {624, 672,},side = 23,},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},


			},
		},
	},
	--虫巢
	[1025] =
	{
		box = {0, 0, 900, 900},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{unidId = 11534, offsetX = 450, offsetY = 450,},
				{type = "group", groupId = 53, offsetX = {192, 240,}, offsetY = {168, 216,},side = 23,},
				{type = "group", groupId = 53, offsetX = {648, 696,}, offsetY = {408, 456,},side = 23,},
				{type = "group", groupId = 53, offsetX = {96, 144,}, offsetY = {624, 672,},side = 23,},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
			},
		},
	},
	--巨大机械蜘蛛
	[1026] =
	{
		box = {0, 0, 900, 900},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{unidId = 11539, offsetX = 450, offsetY = 450,},
				{type = "group", groupId = 53, offsetX = {192, 240,}, offsetY = {168, 216,},side = 23,},
				{type = "group", groupId = 53, offsetX = {648, 696,}, offsetY = {408, 456,},side = 23,},
				{type = "group", groupId = 53, offsetX = {96, 144,}, offsetY = {624, 672,},side = 23,},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
			},
		},
	},
	----异虫
	[1027] =
	{
		box = {0, 0, 900, 900},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{unidId = 11511, offsetX = 450, offsetY = 450,},
			},
		},
	},

	----AT步行战车MK2
	[1028] =
	{
		box = {0, 0, 900, 900},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{unidId = 11541, offsetX = 450, offsetY = 450,},
				{type = "group", groupId = 53, offsetX = {192, 240,}, offsetY = {168, 216,},side = 23,},
				{type = "group", groupId = 53, offsetX = {648, 696,}, offsetY = {408, 456,},side = 23,},
				{type = "group", groupId = 53, offsetX = {96, 144,}, offsetY = {624, 672,},side = 23,},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
			},
		},
	},
	[1029] =
	{
		box = {0, 0, 900, 900},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{unidId = 11542, offsetX = 450, offsetY = 450,},
				{type = "group", groupId = 53, offsetX = {192, 240,}, offsetY = {168, 216,},side = 23,},
				{type = "group", groupId = 53, offsetX = {648, 696,}, offsetY = {408, 456,},side = 23,},
				{type = "group", groupId = 53, offsetX = {96, 144,}, offsetY = {624, 672,},side = 23,},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
			},
		},
	},
	[1030] =
	{
		box = {0, 0, 900, 900},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{unidId = 11543, offsetX = 450, offsetY = 450,},
				{type = "group", groupId = 53, offsetX = {192, 240,}, offsetY = {168, 216,},side = 23,},
				{type = "group", groupId = 53, offsetX = {648, 696,}, offsetY = {408, 456,},side = 23,},
				{type = "group", groupId = 53, offsetX = {96, 144,}, offsetY = {624, 672,},side = 23,},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
			},
		},
	},
	[1031] =
	{
		box = {0, 0, 900, 900},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{unidId = 11546, offsetX = 450, offsetY = 450,},
				{type = "group", groupId = 53, offsetX = {192, 240,}, offsetY = {168, 216,},side = 23,},
				{type = "group", groupId = 53, offsetX = {648, 696,}, offsetY = {408, 456,},side = 23,},
				{type = "group", groupId = 53, offsetX = {96, 144,}, offsetY = {624, 672,},side = 23,},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
			},
		},
	},

	--半兽人战车_修改测试
	[1032] =
	{
		box = {0, 0, 900, 900},
		totalWave = 1, --最大波数
		waves =
		{
			[1] = --第1波
			{
				{unidId = 11510, offsetX = 450, offsetY = 160, },
			},
		},
	},

	--------[危险度3]防守
	[1100] =
	{
		box = {0, 0, 900, 900},
		totalWave = 11, --最大波数
		waves =
		{
			---第1波
			[1] = 
			{
				delayTime = 0,
				deadOnNext = false, --本波死亡后是否下一波提前发兵
				{unidId = 11013, offsetX = 450, offsetY = 450, side = 1,},
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {100, 120,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 120,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {780, 800,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {780, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[2] = 
			{
				delayTime = 2000,
				deadOnNext = false, --本波死亡后是否下一波提前发兵
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {100, 120,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 120,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {780, 800,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {780, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[3] = 
			{
				delayTime = 4000,
				deadOnNext = false, --本波死亡后是否下一波提前发兵
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {100, 120,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 120,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {780, 800,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {780, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			---第2波
			[4] = 
			{
				delayTime = 16000,
				deadOnNext = false, --本波死亡后是否下一波提前发兵
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {100, 120,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 120,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {780, 800,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {780, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[5] = 
			{
				delayTime = 18000,
				deadOnNext = false, --本波死亡后是否下一波提前发兵
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {100, 120,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 120,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {780, 800,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {780, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[6] = 
			{
				delayTime = 20000,
				deadOnNext = false, --本波死亡后是否下一波提前发兵
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {100, 120,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 120,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {780, 800,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {780, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			---第3波
			[7] = 
			{
				delayTime = 32000,
				deadOnNext = false, --本波死亡后是否下一波提前发兵
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {100, 120,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 120,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {780, 800,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {780, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[8] = 
			{
				delayTime = 34000,
				deadOnNext = false, --本波死亡后是否下一波提前发兵
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {100, 120,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 120,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {780, 800,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {780, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[9] = 
			{
				delayTime = 36000,
				deadOnNext = false, --本波死亡后是否下一波提前发兵
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {100, 120,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 120,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {780, 800,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {780, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[10] = 
			{
				delayTime = 38000,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {100, 120,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 120,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {780, 800,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {780, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11602, offsetX = 800, offsetY = 100, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[11] = 
			{
				delayTime = -1,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{unidId = 11501, offsetX = 450, offsetY = 450,},
				{unidId = 11014, offsetX = 450, offsetY = 450,},
			},
		},
	},

	--------[危险度3]防守2
	[1101] =
	{
		box = {0, 0, 900, 900},
		totalWave = 22, --最大波数
		waves =
		{
			---第1波
			[1] = 
			{
				delayTime = 0,
				deadOnNext = false, --本波死亡后是否下一波提前发兵
				{unidId = 11013, offsetX = 450, offsetY = 450, side = 1,},
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {100, 120,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 120,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {780, 800,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {780, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[2] = 
			{
				delayTime = 2000,
				deadOnNext = false, --本波死亡后是否下一波提前发兵
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {100, 120,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 120,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {780, 800,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {780, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[3] = 
			{
				delayTime = 4000,
				deadOnNext = false, --本波死亡后是否下一波提前发兵
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {100, 120,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 120,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {780, 800,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {780, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			---第2波
			[4] = 
			{
				delayTime = 16000,
				deadOnNext = false, --本波死亡后是否下一波提前发兵
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {100, 120,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 120,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {780, 800,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {780, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[5] = 
			{
				delayTime = 18000,
				deadOnNext = false, --本波死亡后是否下一波提前发兵
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {100, 120,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 120,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {780, 800,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {780, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[6] = 
			{
				delayTime = 20000,
				deadOnNext = false, --本波死亡后是否下一波提前发兵
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {100, 120,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 120,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {780, 800,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {780, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			---第3波
			[7] = 
			{
				delayTime = 32000,
				deadOnNext = false, --本波死亡后是否下一波提前发兵
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {100, 120,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 120,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {780, 800,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {780, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[8] = 
			{
				delayTime = 34000,
				deadOnNext = false, --本波死亡后是否下一波提前发兵
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {100, 120,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 120,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {780, 800,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {780, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[9] = 
			{
				delayTime = 36000,
				deadOnNext = false, --本波死亡后是否下一波提前发兵
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {100, 120,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 120,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {780, 800,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {780, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			---第4波
			[10] = 
			{
				delayTime = 48000,
				deadOnNext = false, --本波死亡后是否下一波提前发兵
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {100, 120,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 120,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {780, 800,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {780, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[11] = 
			{
				delayTime = 50000,
				deadOnNext = false, --本波死亡后是否下一波提前发兵
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {100, 120,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 120,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {780, 800,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {780, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[12] = 
			{
				delayTime = 52000,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {100, 120,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 120,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {780, 800,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {780, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11602, offsetX = 800, offsetY = 100, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			---第5波
			[13] = 
			{
				delayTime = 64000,
				deadOnNext = false, --本波死亡后是否下一波提前发兵
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {100, 120,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 120,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {780, 800,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {780, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[14] = 
			{
				delayTime = 66000,
				deadOnNext = false, --本波死亡后是否下一波提前发兵
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {100, 120,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 120,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {780, 800,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {780, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[15] = 
			{
				delayTime = 68000,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {100, 120,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 120,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {780, 800,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {780, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11602, offsetX = 100, offsetY = 800, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			---第6波
			[16] = 
			{
				delayTime = 80000,
				deadOnNext = false, --本波死亡后是否下一波提前发兵
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {100, 120,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 120,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {780, 800,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {780, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[17] = 
			{
				delayTime = 82000,
				deadOnNext = false, --本波死亡后是否下一波提前发兵
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {100, 120,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 120,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {780, 800,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {780, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[18] = 
			{
				delayTime = 84000,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {100, 120,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 120,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {780, 800,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {780, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11602, offsetX = 100, offsetY = 100, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			---第7波
			[19] = 
			{
				delayTime = 100000,
				deadOnNext = false, --本波死亡后是否下一波提前发兵
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {100, 120,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 120,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {780, 800,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {780, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[20] = 
			{
				delayTime = 102000,
				deadOnNext = false, --本波死亡后是否下一波提前发兵
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {100, 120,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 120,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {780, 800,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {780, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[21] = 
			{
				delayTime = 104000,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {100, 120,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 120,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {780, 800,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11601, offsetX = {100, 800,}, offsetY = {780, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11602, offsetX = 800, offsetY = 800, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[22] = 
			{
				delayTime = -1,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{unidId = 11501, offsetX = 450, offsetY = 450,},
				{unidId = 11014, offsetX = 450, offsetY = 450,},
			},
		},
	},

	--------[危险度4]防守(空中)
	[1102] =
	{
		box = {0, 0, 900, 900},
		totalWave = 22, --最大波数
		waves =
		{
			---第1波
			[1] = 
			{
				delayTime = 0,
				deadOnNext = false, --本波死亡后是否下一波提前发兵
				{unidId = 11013, offsetX = 450, offsetY = 450, side = 1,},
				{unidId = 11603, offsetX = {100, 800,}, offsetY = {100, 120,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {100, 120,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {780, 800,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {100, 800,}, offsetY = {780, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[2] = 
			{
				delayTime = 2000,
				deadOnNext = false, --本波死亡后是否下一波提前发兵
				{unidId = 11603, offsetX = {100, 800,}, offsetY = {100, 120,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {100, 120,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {780, 800,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {100, 800,}, offsetY = {780, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[3] = 
			{
				delayTime = 4000,
				deadOnNext = false, --本波死亡后是否下一波提前发兵
				{unidId = 11603, offsetX = {100, 800,}, offsetY = {100, 120,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {100, 120,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {780, 800,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {100, 800,}, offsetY = {780, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			---第2波
			[4] = 
			{
				delayTime = 16000,
				deadOnNext = false, --本波死亡后是否下一波提前发兵
				{unidId = 11603, offsetX = {100, 800,}, offsetY = {100, 120,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {100, 120,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {780, 800,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {100, 800,}, offsetY = {780, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[5] = 
			{
				delayTime = 18000,
				deadOnNext = false, --本波死亡后是否下一波提前发兵
				{unidId = 11603, offsetX = {100, 800,}, offsetY = {100, 120,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {100, 120,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {780, 800,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {100, 800,}, offsetY = {780, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[6] = 
			{
				delayTime = 20000,
				deadOnNext = false, --本波死亡后是否下一波提前发兵
				{unidId = 11603, offsetX = {100, 800,}, offsetY = {100, 120,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {100, 120,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {780, 800,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {100, 800,}, offsetY = {780, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			---第3波
			[7] = 
			{
				delayTime = 32000,
				deadOnNext = false, --本波死亡后是否下一波提前发兵
				{unidId = 11603, offsetX = {100, 800,}, offsetY = {100, 120,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {100, 120,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {780, 800,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {100, 800,}, offsetY = {780, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[8] = 
			{
				delayTime = 34000,
				deadOnNext = false, --本波死亡后是否下一波提前发兵
				{unidId = 11603, offsetX = {100, 800,}, offsetY = {100, 120,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {100, 120,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {780, 800,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {100, 800,}, offsetY = {780, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[9] = 
			{
				delayTime = 36000,
				deadOnNext = false, --本波死亡后是否下一波提前发兵
				{unidId = 11603, offsetX = {100, 800,}, offsetY = {100, 120,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {100, 120,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {780, 800,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {100, 800,}, offsetY = {780, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			---第4波
			[10] = 
			{
				delayTime = 48000,
				deadOnNext = false, --本波死亡后是否下一波提前发兵
				{unidId = 11603, offsetX = {100, 800,}, offsetY = {100, 120,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {100, 120,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {780, 800,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {100, 800,}, offsetY = {780, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[11] = 
			{
				delayTime = 50000,
				deadOnNext = false, --本波死亡后是否下一波提前发兵
				{unidId = 11603, offsetX = {100, 800,}, offsetY = {100, 120,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {100, 120,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {780, 800,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {100, 800,}, offsetY = {780, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[12] = 
			{
				delayTime = 52000,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{unidId = 11603, offsetX = {100, 800,}, offsetY = {100, 120,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {100, 120,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {780, 800,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {100, 800,}, offsetY = {780, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11604, offsetX = 800, offsetY = 100, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			---第5波
			[13] = 
			{
				delayTime = 64000,
				deadOnNext = false, --本波死亡后是否下一波提前发兵
				{unidId = 11603, offsetX = {100, 800,}, offsetY = {100, 120,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {100, 120,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {780, 800,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {100, 800,}, offsetY = {780, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[14] = 
			{
				delayTime = 66000,
				deadOnNext = false, --本波死亡后是否下一波提前发兵
				{unidId = 11603, offsetX = {100, 800,}, offsetY = {100, 120,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {100, 120,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {780, 800,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {100, 800,}, offsetY = {780, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[15] = 
			{
				delayTime = 68000,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{unidId = 11603, offsetX = {100, 800,}, offsetY = {100, 120,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {100, 120,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {780, 800,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {100, 800,}, offsetY = {780, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11604, offsetX = 100, offsetY = 800, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			---第6波
			[16] = 
			{
				delayTime = 80000,
				deadOnNext = false, --本波死亡后是否下一波提前发兵
				{unidId = 11603, offsetX = {100, 800,}, offsetY = {100, 120,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {100, 120,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {780, 800,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {100, 800,}, offsetY = {780, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[17] = 
			{
				delayTime = 82000,
				deadOnNext = false, --本波死亡后是否下一波提前发兵
				{unidId = 11603, offsetX = {100, 800,}, offsetY = {100, 120,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {100, 120,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {780, 800,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {100, 800,}, offsetY = {780, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[18] = 
			{
				delayTime = 84000,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{unidId = 11603, offsetX = {100, 800,}, offsetY = {100, 120,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {100, 120,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {780, 800,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {100, 800,}, offsetY = {780, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11604, offsetX = 100, offsetY = 100, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			---第7波
			[19] = 
			{
				delayTime = 100000,
				deadOnNext = false, --本波死亡后是否下一波提前发兵
				{unidId = 11603, offsetX = {100, 800,}, offsetY = {100, 120,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {100, 120,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {780, 800,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {100, 800,}, offsetY = {780, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[20] = 
			{
				delayTime = 102000,
				deadOnNext = false, --本波死亡后是否下一波提前发兵
				{unidId = 11603, offsetX = {100, 800,}, offsetY = {100, 120,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {100, 120,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {780, 800,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {100, 800,}, offsetY = {780, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[21] = 
			{
				delayTime = 104000,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{unidId = 11603, offsetX = {100, 800,}, offsetY = {100, 120,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {100, 120,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {780, 800,}, offsetY = {100, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11603, offsetX = {100, 800,}, offsetY = {780, 800,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11604, offsetX = 800, offsetY = 800, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[22] = 
			{
				delayTime = -1,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{unidId = 11501, offsetX = 450, offsetY = 450,},
				{unidId = 11014, offsetX = 450, offsetY = 450,},
			},
		},
	},

	------[危险度1]蜘蛛阵
	[1500] =
	{
		box = {0, 0, 900, 900},
		totalWave = 4, --最大波数
		waves =
		{
			[1] = --第1波
			{
				delayTime = 0,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{unidId = 11605, offsetX = 450, offsetY = 450,},
				{unidId = 5080, offsetX = 450, offsetY = 450,},
				{type = "group", groupId = 62, offsetX = {288,360}, offsetY = 288,side = 23,},
				{type = "group", groupId = 63, offsetX = 240, offsetY = {336,384},side = 23,},
				{type = "group", groupId = 63, offsetX = 504, offsetY = {336,384},side = 23,},
				{type = "group", groupId = 62, offsetX = {288,360}, offsetY = 528,side = 23,},
				{type = "group", groupId = 64, offsetX = {144,192}, offsetY = 144,side = 23,},
				{type = "group", groupId = 64, offsetX = {384,456}, offsetY = 144,side = 23,},
				{type = "group", groupId = 65, offsetX = 96, offsetY = {192,240},side = 23,},
				{type = "group", groupId = 65, offsetX = 96, offsetY = {432,480},side = 23,},
				{type = "group", groupId = 65, offsetX = 648, offsetY = {192,240},side = 23,},
				{type = "group", groupId = 65, offsetX = 648, offsetY = {432,480},side = 23,},
				{type = "group", groupId = 64, offsetX = {144,192}, offsetY = 672,side = 23,},
				{type = "group", groupId = 64, offsetX = {384,456}, offsetY = 672,side = 23,},
				{type = "randunit", randId = 102, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 102, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 102, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 102, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 102, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[2] = --第2波
			{
				delayTime = -1,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{type = "randunit", randId = 102, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 102, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 102, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 102, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 102, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[3] = --第3波
			{
				delayTime = -1,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{type = "randunit", randId = 102, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 102, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 102, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 102, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 202, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[4] = --第4波
			{
				delayTime = -1,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{unidId = 11501, offsetX = 450, offsetY = 450,},
			},
		},
	},

	---------[危险度2]蜘蛛阵
	[1501] =
	{
		box = {0, 0, 900, 900},
		totalWave = 4, --最大波数
		waves =
		{
			[1] = --第1波
			{
				delayTime = 0,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{type = "group", groupId = 53, offsetX = {192, 240,}, offsetY = {168, 216,},side = 23,},
				{type = "group", groupId = 53, offsetX = {648, 696,}, offsetY = {408, 456,},side = 23,},
				{type = "group", groupId = 53, offsetX = {96, 144,}, offsetY = {624, 672,},side = 23,},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 110, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 110, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 110, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 110, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 110, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[2] = --第2波
			{
				delayTime = -1,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{type = "randunit", randId = 110, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 110, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 110, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 110, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 110, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[3] = --第3波
			{
				delayTime = -1,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{type = "randunit", randId = 110, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 110, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 110, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 110, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 210, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[4] = --第4波
			{
				delayTime = -1,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{unidId = 11501, offsetX = 450, offsetY = 450,},
			},
		},
	},

	-------[危险度3]机器人阵
	[1502] =
	{
		box = {0, 0, 900, 900},
		totalWave = 4, --最大波数
		waves =
		{
			[1] = --第1波
			{
				delayTime = 0,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{type = "group", groupId = 53, offsetX = {192, 240,}, offsetY = {168, 216,},side = 23,},
				{type = "group", groupId = 53, offsetX = {648, 696,}, offsetY = {408, 456,},side = 23,},
				{type = "group", groupId = 53, offsetX = {96, 144,}, offsetY = {624, 672,},side = 23,},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 120, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 120, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 120, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 120, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 120, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[2] = --第2波
			{
				delayTime = -1,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{type = "randunit", randId = 120, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 120, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 120, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 120, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 120, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[3] = --第3波
			{
				delayTime = -1,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{type = "randunit", randId = 120, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 120, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 120, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 120, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 220, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[4] = --第4波
			{
				delayTime = -1,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{unidId = 11501, offsetX = 450, offsetY = 450,},
			},
		},
	},

	--------[危险度4]刺蛇飞龙阵
	[1503] =
	{
		box = {0, 0, 900, 900},
		totalWave = 4, --最大波数
		waves =
		{
			[1] = --第1波
			{
				delayTime = 0,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{type = "group", groupId = 53, offsetX = {192, 240,}, offsetY = {168, 216,},side = 23,},
				{type = "group", groupId = 53, offsetX = {648, 696,}, offsetY = {408, 456,},side = 23,},
				{type = "group", groupId = 53, offsetX = {96, 144,}, offsetY = {624, 672,},side = 23,},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 133, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 133, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 133, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 133, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 133, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[2] = --第2波
			{
				delayTime = -1,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{type = "randunit", randId = 133, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 133, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 133, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 133, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 133, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[3] = --第3波
			{
				delayTime = -1,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{type = "randunit", randId = 133, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 133, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 133, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 133, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 16005, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[4] = --第4波
			{
				delayTime = -1,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{unidId = 11501, offsetX = 450, offsetY = 450,},
			},
		},
	},

	---------[危险度4]菱形机飞碟阵
	[1504] =
	{
		box = {0, 0, 900, 900},
		totalWave = 4, --最大波数
		waves =
		{
			[1] = --第1波
			{
				delayTime = 0,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{type = "group", groupId = 53, offsetX = {192, 240,}, offsetY = {168, 216,},side = 23,},
				{type = "group", groupId = 53, offsetX = {648, 696,}, offsetY = {408, 456,},side = 23,},
				{type = "group", groupId = 53, offsetX = {96, 144,}, offsetY = {624, 672,},side = 23,},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 132, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 132, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 132, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 132, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 132, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[2] = --第2波
			{
				delayTime = -1,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{type = "randunit", randId = 132, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 132, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 132, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 132, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 132, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[3] = --第3波
			{
				delayTime = -1,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{type = "randunit", randId = 132, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 132, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 132, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 132, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11436, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[4] = --第4波
			{
				delayTime = -1,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{unidId = 11501, offsetX = 450, offsetY = 450,},
			},
		},
	},

	------[危险度1]机器人阵
	[1505] =
	{
		box = {0, 0, 900, 900},
		totalWave = 4, --最大波数
		waves =
		{
			[1] = --第1波
			{
				delayTime = 0,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{unidId = 11605, offsetX = 450, offsetY = 450,},
				{unidId = 5080, offsetX = 450, offsetY = 450,},
				{type = "group", groupId = 62, offsetX = {288,360}, offsetY = 288,side = 23,},
				{type = "group", groupId = 63, offsetX = 240, offsetY = {336,384},side = 23,},
				{type = "group", groupId = 63, offsetX = 504, offsetY = {336,384},side = 23,},
				{type = "group", groupId = 62, offsetX = {288,360}, offsetY = 528,side = 23,},
				{type = "group", groupId = 64, offsetX = {144,192}, offsetY = 144,side = 23,},
				{type = "group", groupId = 64, offsetX = {384,456}, offsetY = 144,side = 23,},
				{type = "group", groupId = 65, offsetX = 96, offsetY = {192,240},side = 23,},
				{type = "group", groupId = 65, offsetX = 96, offsetY = {432,480},side = 23,},
				{type = "group", groupId = 65, offsetX = 648, offsetY = {192,240},side = 23,},
				{type = "group", groupId = 65, offsetX = 648, offsetY = {432,480},side = 23,},
				{type = "group", groupId = 64, offsetX = {144,192}, offsetY = 672,side = 23,},
				{type = "group", groupId = 64, offsetX = {384,456}, offsetY = 672,side = 23,},
				{type = "randunit", randId = 101, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 101, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 101, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 101, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 101, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[2] = --第2波
			{
				delayTime = -1,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{type = "randunit", randId = 101, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 101, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 101, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 101, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 101, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[3] = --第3波
			{
				delayTime = -1,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{type = "randunit", randId = 101, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 101, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 101, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 101, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 201, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[4] = --第4波
			{
				delayTime = -1,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{unidId = 11501, offsetX = 450, offsetY = 450,},
			},
		},
	},

	------[危险度1]僵尸阵
	[1506] =
	{
		box = {0, 0, 900, 900},
		totalWave = 4, --最大波数
		waves =
		{
			[1] = --第1波
			{
				delayTime = 0,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{unidId = 11605, offsetX = 450, offsetY = 450,},
				{unidId = 5080, offsetX = 450, offsetY = 450,},
				{type = "group", groupId = 62, offsetX = {288,360}, offsetY = 288,side = 23,},
				{type = "group", groupId = 63, offsetX = 240, offsetY = {336,384},side = 23,},
				{type = "group", groupId = 63, offsetX = 504, offsetY = {336,384},side = 23,},
				{type = "group", groupId = 62, offsetX = {288,360}, offsetY = 528,side = 23,},
				{type = "group", groupId = 64, offsetX = {144,192}, offsetY = 144,side = 23,},
				{type = "group", groupId = 64, offsetX = {384,456}, offsetY = 144,side = 23,},
				{type = "group", groupId = 65, offsetX = 96, offsetY = {192,240},side = 23,},
				{type = "group", groupId = 65, offsetX = 96, offsetY = {432,480},side = 23,},
				{type = "group", groupId = 65, offsetX = 648, offsetY = {192,240},side = 23,},
				{type = "group", groupId = 65, offsetX = 648, offsetY = {432,480},side = 23,},
				{type = "group", groupId = 64, offsetX = {144,192}, offsetY = 672,side = 23,},
				{type = "group", groupId = 64, offsetX = {384,456}, offsetY = 672,side = 23,},
				{unidId = 11304, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11304, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11304, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11304, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11304, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[2] = --第2波
			{
				delayTime = -1,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{unidId = 11304, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11304, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11304, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11304, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11304, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[3] = --第3波
			{
				delayTime = -1,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{unidId = 11304, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11304, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11304, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11304, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11304, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[4] = --第4波
			{
				delayTime = -1,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{unidId = 11501, offsetX = 450, offsetY = 450,},
			},
		},
	},

	---------[危险度2]机器人阵
	[1507] =
	{
		box = {0, 0, 900, 900},
		totalWave = 4, --最大波数
		waves =
		{
			[1] = --第1波
			{
				delayTime = 0,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{type = "group", groupId = 53, offsetX = {192, 240,}, offsetY = {168, 216,},side = 23,},
				{type = "group", groupId = 53, offsetX = {648, 696,}, offsetY = {408, 456,},side = 23,},
				{type = "group", groupId = 53, offsetX = {96, 144,}, offsetY = {624, 672,},side = 23,},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 111, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 111, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 111, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 111, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 111, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[2] = --第2波
			{
				delayTime = -1,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{type = "randunit", randId = 111, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 111, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 111, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 111, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 111, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[3] = --第3波
			{
				delayTime = -1,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{type = "randunit", randId = 111, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 111, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 111, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 111, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 211, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[4] = --第4波
			{
				delayTime = -1,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{unidId = 11501, offsetX = 450, offsetY = 450,},
			},
		},
	},

	---------[危险度3]星河虫飞机阵
	[1508] =
	{
		box = {0, 0, 900, 900},
		totalWave = 4, --最大波数
		waves =
		{
			[1] = --第1波
			{
				delayTime = 0,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{type = "group", groupId = 53, offsetX = {192, 240,}, offsetY = {168, 216,},side = 23,},
				{type = "group", groupId = 53, offsetX = {648, 696,}, offsetY = {408, 456,},side = 23,},
				{type = "group", groupId = 53, offsetX = {96, 144,}, offsetY = {624, 672,},side = 23,},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 121, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 121, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 121, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 121, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 121, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[2] = --第2波
			{
				delayTime = -1,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{type = "randunit", randId = 121, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 121, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 121, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 121, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 121, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[3] = --第3波
			{
				delayTime = -1,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{type = "randunit", randId = 121, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 121, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 121, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 121, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11460, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[4] = --第4波
			{
				delayTime = -1,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{unidId = 11501, offsetX = 450, offsetY = 450,},
			},
		},
	},

	------[危险度5]触手怪+钢铁气球
	[1509] =
	{
		box = {0, 0, 900, 900},
		totalWave = 2, --最大波数
		waves =
		{
			[1] = --第1波
			{
				delayTime = 0,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{type = "group", groupId = 53, offsetX = {192, 240,}, offsetY = {168, 216,},side = 23,},
				{type = "group", groupId = 53, offsetX = {648, 696,}, offsetY = {408, 456,},side = 23,},
				{type = "group", groupId = 53, offsetX = {96, 144,}, offsetY = {624, 672,},side = 23,},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{unidId = 11490, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11404, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[2] = --第2波
			{
				delayTime = -1,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{unidId = 11501, offsetX = 450, offsetY = 450,},
			},
		},
	},

	-------[危险度5]埋地刺蛇阵
	[1510] =
	{
		box = {0, 0, 900, 900},
		totalWave = 4, --最大波数
		waves =
		{
			[1] = --第1波
			{
				delayTime = 0,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{type = "group", groupId = 53, offsetX = {192, 240,}, offsetY = {168, 216,},side = 23,},
				{type = "group", groupId = 53, offsetX = {648, 696,}, offsetY = {408, 456,},side = 23,},
				{type = "group", groupId = 53, offsetX = {96, 144,}, offsetY = {624, 672,},side = 23,},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 144, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 144, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 144, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 144, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 144, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[2] = --第2波
			{
				delayTime = -1,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{type = "randunit", randId = 144, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 144, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 144, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 144, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 144, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[3] = --第3波
			{
				delayTime = -1,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{type = "randunit", randId = 144, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 144, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 144, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 144, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11404, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[4] = --第4波
			{
				delayTime = -1,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{unidId = 11501, offsetX = 450, offsetY = 450,},
			},
		},
	},

	-------[危险度5]钢铁大脑怪阵
	[1511] =
	{
		box = {0, 0, 900, 900},
		totalWave = 4, --最大波数
		waves =
		{
			[1] = --第1波
			{
				delayTime = 0,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{type = "group", groupId = 53, offsetX = {192, 240,}, offsetY = {168, 216,},side = 23,},
				{type = "group", groupId = 53, offsetX = {648, 696,}, offsetY = {408, 456,},side = 23,},
				{type = "group", groupId = 53, offsetX = {96, 144,}, offsetY = {624, 672,},side = 23,},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 141, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 141, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 141, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 141, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 141, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[2] = --第2波
			{
				delayTime = -1,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{type = "randunit", randId = 141, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 141, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 141, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 141, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 141, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[3] = --第3波
			{
				delayTime = -1,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{type = "randunit", randId = 141, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 141, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 141, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 141, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{unidId = 11490, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[4] = --第4波
			{
				delayTime = -1,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{unidId = 11501, offsetX = 450, offsetY = 450,},
			},
		},
	},
	------[危险度6]异形阵
	[1512] =
	{
		box = {0, 0, 900, 900},
		totalWave = 4, --最大波数
		waves =
		{
			[1] = --第1波
			{
				delayTime = 0,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{type = "group", groupId = 53, offsetX = {192, 240,}, offsetY = {168, 216,},side = 23,},
				{type = "group", groupId = 53, offsetX = {648, 696,}, offsetY = {408, 456,},side = 23,},
				{type = "group", groupId = 53, offsetX = {96, 144,}, offsetY = {624, 672,},side = 23,},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 4, offsetX = {100, 800,}, offsetY = {100, 800,},},
				{type = "randunit", randId = 150, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 150, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 150, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 150, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 150, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[2] = --第2波
			{
				delayTime = -1,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{type = "randunit", randId = 150, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 150, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 150, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 150, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 150, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[3] = --第3波
			{
				delayTime = -1,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{type = "randunit", randId = 150, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 150, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 150, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 150, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
				{type = "randunit", randId = 250, offsetX = {200, 700,}, offsetY = {200, 700,}, roadPointType = hVar.RANDMAP_ROADPOINT_TYPE.RANDOM,},
			},
			[4] = --第4波
			{
				delayTime = -1,
				deadOnNext = true, --本波死亡后是否下一波提前发兵
				{unidId = 11501, offsetX = 450, offsetY = 450,},
			},
		},
	},
	
}



--战车随机地图刷怪表
hVar.RANDMAP_ENEMY_CONFIG =
{
	--第1层（1-1 ~ 1-4）
	[1] =
	{
		--普通房间（小）
		[hVar.RANDMAP_ROOMTYPE.ROOM_NORMAL_SMALL] =
		{
			enemys =
			{
				{1,},
			},
		},
		
		--普通房间（大）
		[hVar.RANDMAP_ROOMTYPE.ROOM_NORMAL_BIG] =
		{
			enemys =
			{
				--{5,5,50,51,52,53,54,55,56,57,58,59,60,61,100,100,102,103,104,105,106,106,107,108,109,},
				--{5,5,50,51,52,53,54,55,56,57,58,59,60,61,101,101,102,113,114,115,116,117,118,119,},
				--{5,5,50,51,52,53,54,55,56,57,58,59,60,61,102,400,400,401,},
				--{5,5,50,51,52,53,54,55,56,57,58,59,60,61,102,102,500,500,500,},
				{5,8,50,51,52,53,54,55,56,57,58,59,60,61,100,100,103,200,201,202,200,201,202,200,201,202,},
				{5,8,50,51,52,53,54,55,56,57,58,59,60,61,100,100,103,300,301,302,300,301,302,300,301,302,},
			},
		},
		
		--BOSS大房间
		[hVar.RANDMAP_ROOMTYPE.ROOM_BOSS] =
		{
			enemys =
			{
				{1003,},--光球蜘蛛巨大型
				{1005,},--大型机器人
				{1011,},--高射塔
				{1500,},--[危险度1]混合阵
				--{1505,},--[危险度1]机器人阵
				--{1506,},--[危险度1]僵尸阵
				--新增
				{1026,},--喷火大蜘蛛
				{1029,},--大球形机器人
			},
		},
		
		--终极BOSS大房间
		[hVar.RANDMAP_ROOMTYPE.ROOM_BOSS_TERNIMAL] =
		{
			enemys =
			{
				{1004,},--AT步行战车
				{1006,},--布雷坦克
				{1008,},--武装列车
				{1012,},--射击塔
				{1020,},--尤达
				{1023,},--隐身异形
				{1027,},--异虫
				{1501,},--[危险度2]蜘蛛阵
				{1507,},--[危险度2]机器人阵
			},
		},
		
		--通路（长条形）
		[hVar.RANDMAP_ROOMTYPE.ROOM_ROAD_W] =
		{
			enemys =
			{
				{1,1,1,1,104,105,106,900,900,},
				{1,1,1,1,104,105,106,901,901,},
			},
		},
		
		--通路（竖条形）
		[hVar.RANDMAP_ROOMTYPE.ROOM_ROAD_H] =
		{
			enemys =
			{
				{1,1,1,1,104,105,106,900,900,},
				{1,1,1,1,104,105,106,901,901,},
			},
		},
		
		--断头路
		[hVar.RANDMAP_ROOMTYPE.ROOM_ROAD_TERMINAL] =
		{
			enemys =
			{
				{2,2,2,2,2,2,3,3,3,3,3,3,4,4,4,4,4,4,6,9},--2-看守所 3-箱子 4-铁人 6-修理 9-宠物
				--{1,10,},
			},
		},
	},
	
	--第2层（2-1 ~ 2-4）
	[2] =
	{
		--普通房间（小）
		[hVar.RANDMAP_ROOMTYPE.ROOM_NORMAL_SMALL] =
		{
			enemys =
			{
				{1,},
			},
		},
		
		--普通房间（大）
		[hVar.RANDMAP_ROOMTYPE.ROOM_NORMAL_BIG] =
		{
			enemys =
			{
				{5,8,50,51,52,53,54,55,56,57,58,59,60,61,100,100,103,210,211,212,210,211,212,210,211,212,},
				{5,8,50,51,52,53,54,55,56,57,58,59,60,61,100,100,103,310,311,312,310,311,312,210,211,212,},
			},
		},
		
		--BOSS大房间
		[hVar.RANDMAP_ROOMTYPE.ROOM_BOSS] =
		{
			enemys =
			{
				{1004,},--AT步行战车
				{1006,},--布雷坦克
				{1008,},--武装列车
				{1012,},--射击塔
				{1020,},--尤达
				{1023,},--隐身异形
				{1027,},--异虫
				{1501,},--[危险度2]蜘蛛阵
				{1507,},--[危险度2]机器人阵
				{1100,},--[危险度3]防守
			},
		},
		
		--终极BOSS大房间
		[hVar.RANDMAP_ROOMTYPE.ROOM_BOSS_TERNIMAL] =
		{
			enemys =
			{
				{1002,},--飞机母舰
				{1009,},--横走坦克
				{1013,},--炮台塔
				{1014,},--盾牌机器人
				{1025,},--虫巢
				{1019,},--巨大尤达
				{1022,},--毒液异形
				{1028,},--AT步行战车MK2
				{1502,},--[危险度3]机器人阵
				{1508,},--[危险度3]星河虫飞机阵
			},
		},
		
		--通路（长条形）
		[hVar.RANDMAP_ROOMTYPE.ROOM_ROAD_W] =
		{
			enemys =
			{
				{1,1,1,1,104,105,106,910,910,},
				{1,1,1,1,104,105,106,911,911,},
			},
		},
		
		--通路（竖条形）
		[hVar.RANDMAP_ROOMTYPE.ROOM_ROAD_H] =
		{
			enemys =
			{
				{1,1,1,1,104,105,106,910,910,},
				{1,1,1,1,104,105,106,911,911,},
			},
		},
		
		--断头路
		[hVar.RANDMAP_ROOMTYPE.ROOM_ROAD_TERMINAL] =
		{
			enemys =
			{
				{2,2,2,2,2,2,3,3,3,3,3,3,4,4,4,4,4,4,6,9},--2-看守所 3-箱子 4-铁人 6-修理 9-宠物
			},
		},
	},
	
	--第3层（3-1 ~ 3-4）
	[3] =
	{
		--普通房间（小）
		[hVar.RANDMAP_ROOMTYPE.ROOM_NORMAL_SMALL] =
		{
			enemys =
			{
				{1,},
			},
		},
		
		--普通房间（大）
		[hVar.RANDMAP_ROOMTYPE.ROOM_NORMAL_BIG] =
		{
			enemys =
			{
				{5,8,50,51,52,53,54,55,56,57,58,59,60,61,101,102,101,102,103,320,321,322,320,321,322,320,321,322,800,},
				{5,8,50,51,52,53,54,55,56,57,58,59,60,61,101,102,101,102,103,600,601,602,600,601,602,600,601,602,800,},
				{5,8,50,51,52,53,54,55,56,57,58,59,60,61,100,101,102,101,102,103,400,400,400,400,400,400,800,},
			},
		},
		
		--BOSS大房间
		[hVar.RANDMAP_ROOMTYPE.ROOM_BOSS] =
		{
			enemys =
			{
				{1002,},--飞机母舰
				{1009,},--横走坦克
				{1013,},--炮台塔
				{1014,},--盾牌机器人
				{1025,},--虫巢
				{1019,},--巨大尤达
				{1022,},--毒液异形
				{1028,},--AT步行战车MK2
				{1502,},--[危险度3]机器人阵
				{1508,},--[危险度3]星河虫飞机阵
				{1101,},--[危险度3]防守2
			},
		},
		
		--终极BOSS大房间
		[hVar.RANDMAP_ROOMTYPE.ROOM_BOSS_TERNIMAL] =
		{
			enemys =
			{
				{1001,},--半兽人战车
				{1007,},--巨塔*3
				{1016,},--量产机-白
				{1017,},--量产机-黑
				{1024,},--产卵异形
				{1030,},--高级触手怪
				{1031,},--机枪塔
				{1503,},--[危险度4]刺蛇飞龙阵
				{1504,},--[危险度4]菱形机飞碟阵
			},
		},
		
		--通路（长条形）
		[hVar.RANDMAP_ROOMTYPE.ROOM_ROAD_W] =
		{
			enemys =
			{
				{1,1,1,1,104,105,106,920,920,},
				{1,1,1,1,104,105,106,921,921,},
			},
		},
		
		--通路（竖条形）
		[hVar.RANDMAP_ROOMTYPE.ROOM_ROAD_H] =
		{
			enemys =
			{
				{1,1,1,1,104,105,106,920,920,},
				{1,1,1,1,104,105,106,921,921,},
			},
		},
		
		--断头路
		[hVar.RANDMAP_ROOMTYPE.ROOM_ROAD_TERMINAL] =
		{
			enemys =
			{
				{2,2,2,2,2,2,3,3,3,3,3,3,4,4,4,4,4,4,6,9,10},--2-看守所 3-箱子 4-铁人 6-修理 9-宠物
			},
		},
	},
	
	--第1层（4-1 ~ 4-4）
	[4] =
	{
		--普通房间（小）
		[hVar.RANDMAP_ROOMTYPE.ROOM_NORMAL_SMALL] =
		{
			enemys =
			{
				{1,},
			},
		},
		
		--普通房间（大）
		[hVar.RANDMAP_ROOMTYPE.ROOM_NORMAL_BIG] =
		{
			enemys =
			{
				{5,8,50,51,52,53,54,55,56,57,58,59,60,61,101,102,101,102,103,610,611,612,610,611,612,610,611,612,700,801,},
				{5,8,50,51,52,53,54,55,56,57,58,59,60,61,101,102,101,102,103,410,411,410,411,410,411,700,801,},
			},
		},
		
		--BOSS大房间
		[hVar.RANDMAP_ROOMTYPE.ROOM_BOSS] =
		{
			enemys =
			{
				{1001,},--半兽人战车
				{1007,},--巨塔*3
				{1016,},--量产机-白
				{1017,},--量产机-黑
				{1024,},--产卵异形
				{1030,},--高级触手怪
				{1031,},--机枪塔
				{1503,},--[危险度4]刺蛇飞龙阵
				{1504,},--[危险度4]菱形机飞碟阵
				{1102,},--[危险度4]防守(空中)
			},
		},
		
		--终极BOSS大房间
		[hVar.RANDMAP_ROOMTYPE.ROOM_BOSS_TERNIMAL] =
		{
			enemys =
			{
				{1010,},--重装机甲
				{1015,},--钢铁气球MK2
				{1018,},--量产机-白+黑
				{1021,},--瞬移尤达
				{1509,},--[危险度5]触手怪+钢铁气球
				{1510,},--[危险度5]埋地刺蛇阵
				{1511,},--[危险度5]钢铁大脑怪阵
			},
		},
		
		--通路（长条形）
		[hVar.RANDMAP_ROOMTYPE.ROOM_ROAD_W] =
		{
			enemys =
			{
				{1,1,1,1,104,105,106,930,930,},
				{1,1,1,1,104,105,106,931,931,},
				{1,1,1,1,104,105,106,932,932,},
			},
		},
		
		--通路（竖条形）
		[hVar.RANDMAP_ROOMTYPE.ROOM_ROAD_H] =
		{
			enemys =
			{
				{1,1,1,1,104,105,106,930,930,},
				{1,1,1,1,104,105,106,931,931,},
				{1,1,1,1,104,105,106,932,932,},
			},
		},
		
		--断头路
		[hVar.RANDMAP_ROOMTYPE.ROOM_ROAD_TERMINAL] =
		{
			enemys =
			{
				{2,2,2,2,2,2,3,3,3,3,3,3,4,4,4,4,4,4,6,9,10},--2-看守所 3-箱子 4-铁人 6-修理 9-宠物
			},
		},
	},
	
	--第5层（5-1 ~ 5-4）
	[5] =
	{
		--普通房间（小）
		[hVar.RANDMAP_ROOMTYPE.ROOM_NORMAL_SMALL] =
		{
			enemys =
			{
				{1,},
			},
		},
		
		--普通房间（大）
		[hVar.RANDMAP_ROOMTYPE.ROOM_NORMAL_BIG] =
		{
			enemys =
			{
				{5,8,50,51,52,53,54,55,56,57,58,59,60,61,101,102,101,102,103,220,221,222,220,221,222,220,221,222,701,802,},
				{5,8,50,51,52,53,54,55,56,57,58,59,60,61,101,102,101,102,103,420,420,420,420,420,420,701,802,},
			},
		},
		
		--BOSS大房间
		[hVar.RANDMAP_ROOMTYPE.ROOM_BOSS] =
		{
			enemys =
			{
				{1010,},--重装机甲
				{1015,},--钢铁气球MK2
				{1018,},--量产机-白+黑
				{1021,},--瞬移尤达
				{1509,},--[危险度5]触手怪+钢铁气球
				{1510,},--[危险度5]埋地刺蛇阵
				{1511,},--[危险度5]钢铁大脑怪阵
			},
		},
		
		--终极BOSS大房间
		[hVar.RANDMAP_ROOMTYPE.ROOM_BOSS_TERNIMAL] =
		{
			enemys =
			{
				{1001,},--半兽人战车
				{1007,},--巨塔*3
				{1022,},--毒液异形
				{1024,},--产卵异形
				{1025,},--虫巢
				{1512,},--[危险度6]异形阵
			},
		},
		
		--通路（长条形）
		[hVar.RANDMAP_ROOMTYPE.ROOM_ROAD_W] =
		{
			enemys =
			{
				{1,1,1,1,104,105,106,940,940,},
			},
		},
		
		--通路（竖条形）
		[hVar.RANDMAP_ROOMTYPE.ROOM_ROAD_H] =
		{
			enemys =
			{
				{1,1,1,1,104,105,106,940,940,},
			},
		},
		
		--断头路
		[hVar.RANDMAP_ROOMTYPE.ROOM_ROAD_TERMINAL] =
		{
			enemys =
			{
				{2,2,2,2,2,2,3,3,3,3,3,3,4,4,4,4,4,4,6,9,10},--2-看守所 3-箱子 4-铁人 6-修理 9-宠物
				--{1,9,},
			},
		},
	},
	
	--第6层（6-1 ~ 6-4）
	[6] =
	{
		--普通房间（小）
		[hVar.RANDMAP_ROOMTYPE.ROOM_NORMAL_SMALL] =
		{
			enemys =
			{
				{1,},
			},
		},
		
		--普通房间（大）
		[hVar.RANDMAP_ROOMTYPE.ROOM_NORMAL_BIG] =
		{
			enemys =
			{
				{5,8,50,51,52,53,54,55,56,57,58,59,60,61,101,102,101,102,103,320,321,322,320,321,322,320,321,322,701,802,},
				{5,8,50,51,52,53,54,55,56,57,58,59,60,61,101,102,101,102,103,220,221,222,220,221,222,220,221,222,701,802,},
				{5,8,50,51,52,53,54,55,56,57,58,59,60,61,101,102,101,102,103,430,430,430,430,430,430,701,802,},
			},
		},
		
		--BOSS大房间
		[hVar.RANDMAP_ROOMTYPE.ROOM_BOSS] =
		{
			enemys =
			{
				{1001,},--半兽人战车
				{1007,},--巨塔*3
				{1022,},--毒液异形
				{1024,},--产卵异形
				{1025,},--虫巢
				{1512,},--[危险度6]异形阵
			},
		},
		
		--终极BOSS大房间
		[hVar.RANDMAP_ROOMTYPE.ROOM_BOSS_TERNIMAL] =
		{
			enemys =
			{
				{1016,},--量产机-白
				{1017,},--量产机-黑
				{1019,},--巨大尤达
				{1504,},--[危险度4]菱形机飞碟阵
				{1508,},--[危险度3]星河虫飞机阵
				{1509,},--[危险度5]触手怪+钢铁气球
				{1512,},--[危险度6]异形阵
			},
		},
		
		--通路（长条形）
		[hVar.RANDMAP_ROOMTYPE.ROOM_ROAD_W] =
		{
			enemys =
			{
				{1,1,1,1,104,105,106,940,940,},
			},
		},
		
		--通路（竖条形）
		[hVar.RANDMAP_ROOMTYPE.ROOM_ROAD_H] =
		{
			enemys =
			{
				{1,1,1,1,104,105,106,940,940,},
			},
		},
		
		--断头路
		[hVar.RANDMAP_ROOMTYPE.ROOM_ROAD_TERMINAL] =
		{
			enemys =
			{
				{2,2,2,2,2,2,3,3,3,3,3,3,4,4,4,4,4,4,6,9,10},--2-看守所 3-箱子 4-铁人 6-修理 9-宠物
			},
		},
	},
	
	--第7层（7-1 ~ 7-4）
	[7] =
	{
		--普通房间（小）
		[hVar.RANDMAP_ROOMTYPE.ROOM_NORMAL_SMALL] =
		{
			enemys =
			{
				{1,},
			},
		},
		
		--普通房间（大）
		[hVar.RANDMAP_ROOMTYPE.ROOM_NORMAL_BIG] =
		{
			enemys =
			{
				{5,8,50,51,52,53,54,55,56,57,58,59,60,61,101,102,101,102,103,230,231,232,230,231,232,230,231,232,701,802,},
				{5,8,50,51,52,53,54,55,56,57,58,59,60,61,101,102,101,102,103,330,331,332,330,331,332,330,331,332,701,802,},
				{5,8,50,51,52,53,54,55,56,57,58,59,60,61,101,102,101,102,103,440,440,440,440,440,440,701,802,},
			},
		},
		
		--BOSS大房间
		[hVar.RANDMAP_ROOMTYPE.ROOM_BOSS] =
		{
			enemys =
			{
				{1001,},--半兽人战车
				{1007,},--巨塔*3
				{1010,},--重装机甲
				{1015,},--钢铁气球MK2
				{1016,},--量产机-白
				{1017,},--量产机-黑
				{1018,},--量产机-白+黑
				{1019,},--巨大尤达
				{1021,},--瞬移尤达
				{1022,},--毒液异形
				{1024,},--产卵异形
				{1504,},--[危险度4]菱形机飞碟阵
				{1508,},--[危险度3]星河虫飞机阵
				{1509,},--[危险度5]触手怪+钢铁气球
				{1512,},--[危险度6]异形阵
			},
		},
		
		--终极BOSS大房间
		[hVar.RANDMAP_ROOMTYPE.ROOM_BOSS_TERNIMAL] =
		{
			enemys =
			{
				{1001,},--半兽人战车
				{1007,},--巨塔*3
				{1010,},--重装机甲
				{1015,},--钢铁气球MK2
				{1018,},--量产机-白+黑
				{1019,},--巨大尤达
				{1021,},--瞬移尤达
				{1022,},--毒液异形
				{1024,},--产卵异形
			},
		},
		
		--通路（长条形）
		[hVar.RANDMAP_ROOMTYPE.ROOM_ROAD_W] =
		{
			enemys =
			{
				{1,1,1,1,104,105,106,960,960,},
				{1,1,1,1,104,105,106,961,961,},
				{1,1,1,1,104,105,106,962,962,},
			},
		},
		
		--通路（竖条形）
		[hVar.RANDMAP_ROOMTYPE.ROOM_ROAD_H] =
		{
			enemys =
			{
				{1,1,1,1,104,105,106,960,960,},
				{1,1,1,1,104,105,106,961,961,},
				{1,1,1,1,104,105,106,962,962,},
			},
		},
		
		--断头路
		[hVar.RANDMAP_ROOMTYPE.ROOM_ROAD_TERMINAL] =
		{
			enemys =
			{
				{2,2,2,2,2,2,3,3,3,3,3,3,4,4,4,4,4,4,6,9,10},--2-看守所 3-箱子 4-铁人 6-修理 9-宠物
			},
		},
	},
	
	--第8层（8-1 ~ 8-4）
	[8] =
	{
		--普通房间（小）
		[hVar.RANDMAP_ROOMTYPE.ROOM_NORMAL_SMALL] =
		{
			enemys =
			{
				{1,},
			},
		},
		
		--普通房间（大）
		[hVar.RANDMAP_ROOMTYPE.ROOM_NORMAL_BIG] =
		{
			enemys =
			{
				{5,8,50,51,52,53,54,55,56,57,58,59,60,61,101,102,101,102,103,230,231,232,230,231,232,230,231,232,701,802,},
				{5,8,50,51,52,53,54,55,56,57,58,59,60,61,101,102,101,102,103,330,331,332,330,331,332,330,331,332,701,802,},
				{5,8,50,51,52,53,54,55,56,57,58,59,60,61,101,102,101,102,103,440,440,440,440,440,440,701,802,},
			},
		},
		
		--BOSS大房间
		[hVar.RANDMAP_ROOMTYPE.ROOM_BOSS] =
		{
			enemys =
			{
				{1001,},--半兽人战车
				{1007,},--巨塔*3
				{1010,},--重装机甲
				{1015,},--钢铁气球MK2
				{1016,},--量产机-白
				{1017,},--量产机-黑
				{1018,},--量产机-白+黑
				{1019,},--巨大尤达
				{1021,},--瞬移尤达
				{1022,},--毒液异形
				{1024,},--产卵异形
				{1504,},--[危险度4]菱形机飞碟阵
				{1508,},--[危险度3]星河虫飞机阵
				{1509,},--[危险度5]触手怪+钢铁气球
				{1512,},--[危险度6]异形阵
			},
		},
		
		--终极BOSS大房间
		[hVar.RANDMAP_ROOMTYPE.ROOM_BOSS_TERNIMAL] =
		{
			enemys =
			{
				{1001,},--半兽人战车
				{1007,},--巨塔*3
				{1010,},--重装机甲
				{1015,},--钢铁气球MK2
				{1018,},--量产机-白+黑
				{1019,},--巨大尤达
				{1021,},--瞬移尤达
				{1022,},--毒液异形
				{1024,},--产卵异形
			},
		},
		
		--通路（长条形）
		[hVar.RANDMAP_ROOMTYPE.ROOM_ROAD_W] =
		{
			enemys =
			{
				{1,1,1,1,104,105,106,960,960,},
				{1,1,1,1,104,105,106,961,961,},
				{1,1,1,1,104,105,106,962,962,},
			},
		},
		
		--通路（竖条形）
		[hVar.RANDMAP_ROOMTYPE.ROOM_ROAD_H] =
		{
			enemys =
			{
				{1,1,1,1,104,105,106,960,960,},
				{1,1,1,1,104,105,106,961,961,},
				{1,1,1,1,104,105,106,962,962,},
			},
		},
		
		--断头路
		[hVar.RANDMAP_ROOMTYPE.ROOM_ROAD_TERMINAL] =
		{
			enemys =
			{
				{2,2,2,2,2,2,3,3,3,3,3,3,4,4,4,4,4,4,6,9,10},--2-看守所 3-箱子 4-铁人 6-修理 9-宠物
			},
		},
	},
}