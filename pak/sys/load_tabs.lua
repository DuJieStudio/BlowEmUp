--hDefine.Tabs = {
	----�����ı�
	--"tab_string",					--�ı���(UTF-8)��ʽ
	----������Դ
	--"model/tab_model",				--����ģ�ͱ�
	--"model/tab_model_unit",				--��λģ�ͱ�
	--"model/tab_model_effect",			--��Чģ�ͱ�
	--"model/tab_model_sceobj",			--�������ģ�ͱ�
	--"model/tab_model_ui",				--UIģ�ͱ�
	--"model/tab_model_icon",				--UIͼ���
	--function()return hVar.tab_model.init()end,	--��ʼ��ģ�ͱ�
	--"tab_effect",					--��Ч��Ϣ
	--"tab_skill",					--���ܱ�
	--"tab_unit",					--��λ��Ϣ
	--"tab_item",					--���߱�
--}
--------------------
---- ����
---- ����Ϊ�ַ��������ʽ�����Ϊ������ر��е�һ�������������ڵڶ������������Ժ�����ʽִ��
--hDefine.Scripts = {}
--math.randomseed(os.time())
--hApi.LoadScripts("tabs/",hDefine.Tabs)
xpcall(function()
	if type(g_langauge_ver)=="string" and xlIsFileExist("data/"..g_langauge_ver..".lan") then
		xlDoFile("data/"..g_langauge_ver..".lan")
	else
		xlDoFile("data/default.lan")
	end
	xlDoFile("data/bats.so")
	xlDoFile("data/plus.so")
end,function(msg)
	xlLG("init","[load bat.o]���ر����ִ���:"..tostring(msg).."\n")
end)