RandNameProcess = {}
RandNameProcess.data = {}
RandNameProcess.func = {}

RandNameProcess.func.Init = function()
	RandNameProcess.data = {}
	RandNameProcess.data.NameLibrary = {}
	RandNameProcess.data.RequestStartIndex = 0
	RandNameProcess.func.AddEvent()
	RandNameProcess.func.AutoGetNameLibrary()
end

RandNameProcess.func.Clear = function()
	RandNameProcess.data = {}
	RandNameProcess.func.ClearEvent()
end

RandNameProcess.func.RequireNameLibrary = function()
	print("RandNameProcess.func.RequireNameLibrary")
	SendCmdFunc["comment_system_query_barrage"](hVar.CommentTargetTypeDefine.NAMELIBRARY,1,RandNameProcess.data.RequestStartIndex)
end

RandNameProcess.func.AutoGetNameLibrary = function()
	RandNameProcess.func.RequireNameLibrary()
	hApi.addTimerForever("__AutoGetNameLibrary",hVar.TIMER_MODE.GAMETIME,5000,function(tick)
		RandNameProcess.func.RequireNameLibrary()
	end)
end

RandNameProcess.func.GetNameLibrary = function(beginIndex,dataCount,tData)
	print("RandNameProcess.func.GetNameLibrary")
	--��ȡʧ�� ֱ������
	if beginIndex == -1 then
		hApi.clearTimer("__AutoGetNameLibrary")
		return
	end
	--������ֱ������
	if beginIndex < RandNameProcess.data.RequestStartIndex then
		return
	end
	hApi.clearTimer("__AutoGetNameLibrary")
	if type(tData) == "table" then
		--table_print(tData)
		for i = 1,#tData do
			local v = tData[i]
			local name = v.content
			RandNameProcess.data.NameLibrary[#RandNameProcess.data.NameLibrary + 1] = name
		end
		--table_print(RandNameProcess.data.NameLibrary)
	end

	RandNameProcess.data.RequestStartIndex = RandNameProcess.data.RequestStartIndex + dataCount
	--һ���Ի�ȡ��Ļ����Ϊ30
	if dataCount < 30 then --��С��30��˵��ȡ����
		--������Ҫ��ȡ
	else --����˵����������
		RandNameProcess.func.AutoGetNameLibrary()
	end
end

RandNameProcess.func.AddEvent = function()
	hGlobal.event:listen("LocalEvent_GetNameLibrary","RandNameProcess",RandNameProcess.func.GetNameLibrary)
end

RandNameProcess.func.ClearEvent = function()
	hGlobal.event:listen("LocalEvent_GetNameLibrary","RandNameProcess",nil)
end

hGlobal.event:listen("LocalEvent_PlayerFocusWorld", "RandNameProcess",function(sSceneType,oWorld,oMap)
	if oWorld and oWorld.data.map == hVar.GuideMap then
		RandNameProcess.func.Init()
	else
		RandNameProcess.func.Clear()
	end
end)