-------------------------------------------------
--����������
---------------------------------------------------
--�Ϳͻ���һ��
--����Э��define
--����������Э���
hVar.GROUP_OPR_TYPE = {
	
	--1~99,ϵͳ��Ϣ
	C2L_REQUIRE_HEART		= 1,					--������
	C2L_REQUIRE_DEBUG		= 2,					--GM_Debug
	
	--GROUPϵͳ
	C2L_REQUIRE_CHAT_INIT	= 100,					--�����ʼ���������
	C2L_REQUIRE_CHAT_ID_LIST	= 101,				--��ȡ������Ϣid�б�
	C2L_REQUIRE_CHAT_CONTENT_LIST	= 102,			--��ȡָ��������Ϣid�б������
	C2L_REQUIRE_CHAT_SEND_MESSAGE	= 103,			--������һ��������Ϣ
	C2L_REQUIRE_CHAT_UPDATE_MESSAGE	= 104,			--�������һ��������Ϣ
	C2L_REQUIRE_CHAT_REMOVE_MESSGAE	= 105,			--����ɾ��һ��������Ϣ
	C2L_REQUIRE_CHAT_FORBIDDEN_USER	= 106,			--��������������
	C2L_REQUIRE_CHAT_PRIVATE_INVITE	= 107,			--����ͶԷ����˽��
	C2L_REQUIRE_CHAT_PRIVATE_INVITE_OP	= 108,		--˽����֤��Ϣ����
	C2L_REQUIRE_CHAT_PRIVATE_DELETE	= 109,			--����ɾ��˽�ĺ���
	C2L_REQUIRE_CHAT_SEND_GROUP_SYSTEM_MESSAGE	= 110,--������һ������ϵͳ������Ϣ
	C2L_REQUIRE_EXCHAGE_TACTIC_DEBRIS	= 111,		--����һ�ս������Ƭ
	C2L_REQUIRE_EXCHAGE_HERO_DEBRIS	= 112,			--����һ�Ӣ�۽���
	C2L_REQUIRE_EXCHAGE_GROUPCOIN_CHEST	= 113,		--����һ����űұ���
	C2L_REQUIRE_HERO_DEBRIS_INFO	= 114,			--�����ѯӢ�۽�����Ϣ
	C2L_REQUIRE_BUY_BATTLE_COUNT	= 115,			--��������Ÿ�������
	C2L_REQUIRE_SEND_GROUP_REDPACKET	= 116,		--�����;��ź��
	C2L_REQUIRE_RECEIVE_GROUP_REDPACKET	=117,		--������ȡ���ź��
	C2L_REQUIRE_CHAT_SEND_WORLD_BATTLE_SYSTEM_MESSAGE	= 118,--������һ������ؿ�ͨ��ϵͳ������Ϣ
	C2L_REQUIRE_GROUP_MILITARY_TASK_INFO	= 119,		--�����ѯ���ž�������������
	C2L_REQUIRE_GROUP_MILITARY_TASK_TAKEREWARD	= 120,	--������ȡ���ž�������
	C2L_REQUIRE_RECEIVE_PAY_REDPACKET	=121,		--������ȡ֧�������������
	C2L_REQUIRE_VIEWDETAIL_PAY_REDPACKET	=122,		--����鿴֧�����������������ȡ����
	C2L_REQUIRE_GROUP_KICK_OFFLINE_PLAYER	= 123,		--�����߳����ڲ����ߵ��������ŵ���ң�������Ա�ɲ�����
	C2L_REQUIRE_GROUP_ASSET_ADMIN_PLAYER	= 124,		--�����������Ϊ�᳤��������Ա�ɲ�����
	C2L_REQUIRE_GROUP_TRANSFER		= 125,		--����ת�þ���
	C2L_REQUIRE_GROUP_DISOLUTE		= 126,		--�����ɢ���ţ�������Ա�ɲ�����
	C2L_REQUIRE_GROUP_INVITE_CREATE		= 127,		--���󴴽��������뺯
	C2L_REQUIRE_GROUP_INVITE_JOIN		= 128,		--�������������뺯
	C2L_REQUIRE_CHAT_ID_LIST_GROUP_GM	= 129,		--��ȡָ�����ŵ�������Ϣid�б�������Ա�ɲ�����
	C2L_REQUIRE_CHAT_CONTENT_LIST_GROUP_GM	= 130,		--��ȡָ�����ŵ�������Ϣid�б�����ݣ�������Ա�ɲ�����
	C2L_REQUIRE_CHAT_REMOVE_MESSGAE_BATTLE	= 131,		--����ɾ��һ����Ӹ�������������Ϣ
	C2L_REQUIRE_CHAT_SEND_MESSAGE_BATTLE	= 132,		--������һ����Ӹ�������������Ϣ
	
	
	
	
	--����Ӫ
	C2L_NOVICECAMP_LIST		= 1001,				--��������Ӫ�б�
	C2L_NOVICECAMP_CREATE		= 1002,				--��������Ӫ
	C2L_NOVICECAMP_REMOVE		= 1003,				--��ɢ����Ӫ
	C2L_MEMBER_LIST			= 1004,				--�鿴��Ա�б�
	C2L_POWER_JION_ACCEPT		= 1005,				--Ӫ��ͨ����������
	C2L_POWER_JION_REJECT		= 1006,				--Ӫ��������������
	C2L_POWER_JION_REQUEST		= 1007,				--���������Ӫ
	C2L_POWER_JION_CANCEL		= 1008,				--����ȡ������
	C2L_NOVICECAMP_UPDATE		= 1009,				--��������Ӫ��Ϣ
	C2L_POWER_FIRE			= 1010,				--����
	C2L_CONFIG_PRIZE		= 1011,				--��������Ϣ
	C2L_NOVICECAMP_RENAME		= 1012,				--�޸�����Ӫ����
	C2L_BUILDING_UPGRADE		= 1013,				--��������
	C2L_BUILDING_PRIZE		= 1014,				--��ȡ��������
	C2L_POWER_QUIT			= 1015,				--�˳�
	C2L_CARD_UPGRADE		= 1016,				--ս��������
	C2L_POWER_ASSISTANT_APPOINT	= 1017,				--�᳤��������
	C2L_POWER_ASSISTANT_DISAPPOINT	= 1018,				--�᳤ȡ����������
	C2L_NOVICECAMP_LIST_JOIN	= 1019,				--���������������б�
	C2L_REQUIRE_GROUP_SEARCH	= 1020,				--������Ҿ���
}

--����������Э���
hVar.GROUP_RECV_TYPE = {
	--1~99,ϵͳ��Ϣ
	L2C_NOTICE_USER_LOGIN		= 1,				--��ҵ�½1
	L2C_NOTICE_PING			= 2,					--pingЭ��
	L2C_NOTICE_ERROR		= 98,					--�����¼�1
	
	--GROUPϵͳ
	L2C_NOTICE_CHAT_ORPEATION_RESULT	= 100,		--���ز������֪ͨ
	L2C_NOTICE_CHAT_INIT		= 101,				--���س�ʼ�����������
	L2C_NOTICE_CHAT_ID_LIST		= 102,				--����������Ϣid�б�
	L2C_NOTICE_CHAT_CONTENT_LIST		= 103,		--����ָ��������Ϣid�б������
	L2C_NOTICE_CHAT_SINGLE_MESSAGE	= 104,			--���ص���������Ϣ
	L2C_NOTICE_CHAT_UPDATE_MESSAGE	= 105,			--���ظ��µ���������Ϣ
	L2C_NOTICE_CHAT_REMOVE_MESSAGE	= 106,			--����ɾ��������Ϣ
	L2C_NOTICE_CHAT_USER_FORBIDDEN	= 107,			--������ұ����ԵĽ��
	L2C_NOTICE_CHAT_PRIVATE_INVITE	= 108,			--��������ͶԷ����˽�ĵĽ��
	L2C_NOTICE_CHAT_SINGLE_PRIVATE_USER	= 109,		--�����յ����ӵ���˽�ĺ���
	L2C_NOTICE_CHAT_REMOVE_PRIVATE_USER	= 110,		--�����յ��Ƴ�����˽�ĺ���
	L2C_NOTICE_EXCHAGE_TACTIC_DEBRIS	= 111,		--���ضһ�ս������Ƭ���
	L2C_NOTICE_EXCHAGE_HERO_DEBRIS	= 112,			--���ضһ�Ӣ�۽�����
	L2C_NOTICE_EXCHAGE_GROUPCOIN_CHEST	= 113,		--���ضһ����űұ�����
	L2C_NOTICE_QUERY_HERO_DEBRIS_INFO	= 114,		--���ز�ѯӢ�۽�����Ϣ���
	L2C_NOTICE_GROUP_RESOURCE_INFO	= 115,			--���ؾ�����Դ�仯���
	L2C_NOTICE_GROUP_BUY_BATTLE_COUNT	= 116,		--���ؾ��Ż᳤���򸱱��������
	L2C_NOTICE_GROUP_SEND_REDPACKET	= 117,			--���ط��;��ź�����
	L2C_NOTICE_GROUP_RECEIVE_REDPACKET	= 118,		--������ȡ���ź�����
	L2C_NOTICE_GROUP_MILITARY_TASK_QUERY	= 119,		--���ز�ѯ���ž���������ɽ��
	L2C_NOTICE_GROUP_MILITARY_TASK_TAKEREWARD	= 120,	--������ȡ���ž���������
	L2C_NOTICE_PAY_RECEIVE_REDPACKET	= 121,		--������ȡ֧����������������
	L2C_NOTICE_PAY_VIEWDETAIL_REDPACKET	= 122,		--���ز鿴֧�����������������ȡ������
	L2C_NOTICE_GROUP_KICK_OFFLINE_PLAYER	= 123,		--�����߳����ڲ����ߵ��������ŵ���ҽ����������Ա�ɲ�����
	L2C_NOTICE_GROUP_ASSET_ADMIN_PLAYER	= 124,		--�����������Ϊ�᳤�����������Ա�ɲ�����
	L2C_NOTICE_GROUP_TRANSFER		= 125,		--���ؾ���ת�ý��
	L2C_NOTICE_GROUP_DISOLUTE		= 126,		--���ؾ��Ž�ɢ�����������Ա�ɲ�����
	L2C_NOTICE_GROUP_INVITE_CREATE		= 127,		--���ش����������뺯���
	L2C_NOTICE_GROUP_INVITE_JOIN		= 128,		--���ؼ���������뺯���
	L2C_NOTICE_CHAT_SEND_MESSAGE_BATTLE	= 129,		--����������һ����Ӹ�������������Ϣ���
	
	
	
	
	
	
	--����Ӫ
	L2C_NOVICECAMP_LIST		= 1001,				--��������Ӫ�б�
	L2C_NOVICECAMP_CREATE		= 1002,				--��������Ӫ�������
	L2C_NOVICECAMP_REMOVE		= 1003,				--��������Ӫ��ɢ���
	L2C_MEMBER_LIST			= 1004,				--���س�Ա�б�
	L2C_POWER_JION_ACCEPT		= 1005,				--����Ӫ��ͨ����������
	L2C_POWER_JION_REJECT		= 1006,				--����Ӫ��������������
	L2C_POWER_JION_REQUEST		= 1007,				--�������������Ӫ���
	L2C_POWER_JION_CANCEL		= 1008,				--��������ȡ��������
	L2C_NOVICECAMP_UPDATE		= 1009,				--���ظ�������Ӫ��Ϣ���
	L2C_POWER_FIRE			= 1010,				--�������˽��
	L2C_CONFIG_PRIZE		= 1011,				--���ؽ�����Ϣ
	L2C_NOVICECAMP_RENAME		= 1012,				--�����޸�����Ӫ���ֽ��
	L2C_BUILDING_UPGRADE		= 1013,				--���������������
	L2C_BUILDING_PRIZE		= 1014,				--���ؽ�������
	L2C_POWER_QUIT			= 1015,				--�����˳����
	L2C_CARD_UPGRADE		= 1016,				--����ս�����������
	L2C_POWER_ASSISTANT_APPOINT	= 1017,				--���ػ᳤����������
	L2C_POWER_ASSISTANT_DISAPPOINT	= 1018,				--���ػ᳤ȡ������������
	L2C_NOVICECAMP_LIST_JOIN	= 1019,				--���������������б�
	L2C_NOTICE_GROUP_SEARCH_RET	= 1020,				--���ؾ��Ų��ҽ��
}
