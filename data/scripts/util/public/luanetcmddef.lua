-----------------------
--�������ű�ϵͳ
-----------------------
--�ͷ�����һ��
hVar.DB_OPR_TYPE = {
	--C2L_REQUIRE			= 3002,
	C2L_REQUIRE			= 66666,			--��׿��Э��Ÿ���
	
	C2L_REQUIRE_SYSTIME		= 1,				--��ȡ������ʱ��
	C2L_GET_MAIL_ANNEX		= 2,				--��ȡ���丽��
	C2L_GET_VER_INFO		= 3,				--��ȡ�汾��Ϣ
	C2L_GET_MAIL_ANNEX_DRAWCARD	= 5,				--��ȡ����������鿨����
	C2L_GET_ENDLESS_RANK_NAME	= 6,				--��ȡ�޾���ͼ��ǰ10�������
	C2L_GET_ENDLESS_REWARD		= 7,				--��ȡ�޾���ͼ���а���
	C2L_GETPVEMULTY_REWARD		= 8,				--��ȡħ������ÿ�����ͽ�����
	C2L_GETTITIEMSG_REWARD		= 9,				--��ȡ�����������ʼ��Ľ���
	
	C2L_REQUIRE_HOTFIX		= 11,
	--�������
	C2L_REQUIRE_QUEST		= 12,				--��������
	C2L_UPDATE_QUEST		= 13,				--��������״̬
	C2L_CONFIRM_QUEST		= 14,				--��ȡ������
	
	--�콱��־
	C2L_UPDATE_REWARD_LOG		= 15,				--�����콱״̬��־
	
	--���а���ع���
	C2L_REQUIRE_BOARD_TEMPLATE	= 16,				--��ȡ���а�ģ��
	C2L_REQUIRE_BILLBOARD		= 17,				--��ȡ���а���Ϣ
	C2L_UPDATE_BILLBOARD_RANK	= 18,				--����������а���Ϣ
	
	--�޸�����
	C2L_REQUIRE_CHANGE_NAME		= 19,				--�޸Ľ�ɫ����
	
	--���µ�ͼ�״�ͨ�ؼ�¼
	C2L_UPLOAD_MAP_RECORD		= 20,				--��ͼ�״�ͨ�ؼ�¼

	--�̳�
	C2L_REQUIRE_OPEN_SHOP		= 21,				--���̳�
	C2L_REQUIRE_REFRESH_SHOP	= 22,				--ˢ���̳�(ʹ��rmbˢ��)
	C2L_REQUIRE_BUYITEM		= 23,				--������Ʒ
	C2L_REQUIRE_MYCOIN		= 24,				--��ȡ��Ҹ��ֻ���
	
	C2L_REQUIRE_MERGE_REDEQUIP	= 25,				--��װ�ϳ�
	C2L_REQUIRE_XILIAN_REDEQUIP	= 26,				--��װϴ��
	C2L_REQUIRE_SYNC_REDEQUIP	= 27,				--��װͬ��
	
	C2L_REQUIRE_VIP_INFO		= 28,				--��ȡvip��Ϣ
	C2L_REQUIRE_VIP_DAILY_REWARD	= 29,				--��ȡvipÿ�ս���1
	
	C2L_REQUIRE_QUEST_TEST		= 30,
	
	C2L_REQUIRE_GET_ALLREDEQUIP	= 31,				--��ȡ���к�װ��Ϣ
	C2L_REQUIRE_REDSCROLL_EXCHANGE	= 32,				--��װ����һ���װ
	
	--��׿
	C2L_ANDROID_SAVE_LOG = 33,							--��׿��ͬ���浵��־
	
	--��������
	C2L_REQUIRE_SET_NAME		= 34,				--��������
	
	--�޾���ͼ��ʼս��
	C2L_REQUIRE_ENDLESS_BEGIN_GAME = 35,			--�޾���ͼ��ʼս��
	
	C2L_REQUIRE_MERGE_ORANGEEQUIP	= 36,				--��װ�ϳ�
	C2L_REQUIRE_MERGE_ORANGEEQUIP_RESULT	= 37,		--��װ�ϳɽ��
	C2L_REQUIRE_DESCOMPOS_REDEQUIP = 38,			--�ֽ��װ
	C2L_REQUIRE_BATTLE_NORMAL	= 39,			--������ս��ͨ�����ͼ
	C2L_REQUIRE_BATTLE_ENTERTAMENT	= 40,			--������ս���ֵ�ͼ
	C2L_REQUIRE_RESUME_ENTERTAMENT	= 41,			--����������ֵ�ͼ������Թ���
	
	--��׿
	C2L_ANDROID_SAVE_LOG = 33,							--��׿��ͬ���浵��־
	C2L_REQUIRE_MONTH_CARD				= 151,			--��ѯ�¿����¿�ÿ���콱
	C2L_UPDATE_TANK_SCORE	= 159,						--����ս���÷�
	C2L_REQUIRE_TANK_BILLBOARD	= 160,					--��ȡս�����а�
	C2L_MODIFY_TANK_USERNAME	= 161,					--�޸�ս�������
	C2L_UPLOAD_TANK_STAGELOG	= 162,					--�ϴ�ս���ؿ���־
	C2L_UPLOAD_TANK_SCOREINFO	= 163,					--�ϴ�ս��������Ϣ
	
	C2L_QUERY_TANK_YESTERDAY_RANK	= 164,				--��ѯս����������
	C2L_REWARD_TANK_YESTERDAY_RANK	= 165,				--��ȡս��������������
	
	C2L_REQUIRE_TRESTURE_INFO		= 166,				--��ѯ��ұ���ͱ�������λ��Ϣ
	C2L_UPDATE_TRESTURE_STARUP		= 167,				--�������������
	C2L_UPLOAD_TRESTURE_ATTR_INFO		= 168,				--�ϴ���ұ�������λֵ��Ϣ
	C2L_REQUIRE_TANK_OPEN_CHEST		= 169,				--ս�����󿪱���
	C2L_REQUIRE_ERROR_LOG			= 170,				--�ϴ��ͻ��˴�����־
	C2L_QUERY_TANK_WEAPON_INFO		= 171,				--��ѯս������ǹͬ����Ϣ
	C2L_REQUIRE_TANK_WEAPON_STARUP		= 172,				--����ս������ǹ����
	--C2L_REQUIRE_TANK_WEAPON_ADDEXP		= 173,				--����ս������ǹ�Ӿ���ֵ
	C2L_QUERY_TANK_TALENTPOINT_INFO		= 174,				--��ѯս�����ܵ���ͬ����Ϣ
	C2L_REQUIRE_TANK_TALENTPOINT_ADDEXP	= 175,				--����ս���Ӿ���ֵ
	C2L_REQUIRE_TANK_TALENTPOINT_ADDPOINT	= 176,				--����ս���츳�����
	C2L_QUERY_TANK_PET_INFO			= 177,				--��ѯս������ͬ����Ϣ
	C2L_REQUIRE_TANK_PET_STARUP		= 178,				--����ս����������
	--C2L_REQUIRE_TANK_PET_ADDEXP		= 179,				--����ս������Ӿ���ֵ
	C2L_REQUIRE_TANK_TALENTPOINT_RESTORE	= 180,				--����ս���츳������
	C2L_REQUIRE_TANK_WEAPON_LEVELUP		= 181,				--����ս������ǹ����
	C2L_REQUIRE_TANK_PET_LEVELUP		= 182,				--����ս����������
	C2L_QUERY_TANK_TACTIC_INFO		= 183,				--��ѯս����ͬ����Ϣ
	C2L_REQUIRE_TANK_TACTIC_LEVELUP		= 184,				--����ս��������
	C2L_REQUIRE_TANK_CLEARDATA		= 185,				--�����������
	C2L_REQUIRE_TANK_PET_WAKUANG		= 186,				--������ǲ�����ڿ�
	C2L_REQUIRE_TANK_PET_WATILI		= 187,				--������ǲ����������
	C2L_REQUIRE_TANK_PET_CANCEL_WAKUANG	= 188,				--������ǲ����ȡ���ڿ�
	C2L_REQUIRE_TANK_PET_CANCEL_WATILI	= 189,				--������ǲ����ȡ��������
	C2L_REQUIRE_TANK_TILI_EXCHANGE		= 190,				--����һ�����
	C2L_REQUIRE_TANK_ADDONES_KESHI		= 191,				--������ȡ�ڿ��ʯ
	C2L_REQUIRE_TANK_ADDONES_TILI		= 192,				--������ȡ�ڿ�����
	C2L_REQUIRE_TANK_TILI_INFO		= 193,				--�����ѯ����������Ϣ
	C2L_QUERY_TANK_MAP_INFO			= 194,				--��ѯս����ͼͬ����Ϣ
	C2L_REQUIRE_TANK_REBIRTH		= 195,				--������Ϸ��ս������
	C2L_REQUIRE_ACHIEVEMENT_QUERY		= 196,				--�����ѯ�ɾ�������
	C2L_REQUIRE_ACHIEVEMENT_TAKEREWARD	= 197,				--������ȡ�ɾͽ���
	C2L_REQUIRE_RANDOMMAP_BOLLBOARD		= 198,				--�����ѯ����Թ����а�
	C2L_ORDER_UPDATE			= 199,				--����״̬���£��£�
	C2L_REQUIRE_RENZUWUDI_REDRAWCARD	= 200,				--�����޵��س鿨Ƭ
	C2L_REQUIRE_VIP_DAILY_REWARD2		= 201,				--��ȡvipÿ�ս���2
	C2L_REQUIRE_VIP_DAILY_REWARD3		= 202,				--��ȡvipÿ�ս���3
	C2L_REQUIRE_TANK_ADDONES_CHEST		= 203,				--������ȡ�ڿ���
	C2L_GET_MAIL_ANNEX_OPENCHEST		= 204,				--��ȡֱ�ӿ��������丽��
	C2L_REQUIRE_CHATDRAGON_REWARD		= 205,				--�����ȡ��������������
	C2L_REQUIRE_USER_CHAMPION_INFO		= 206,				--�����ѯ��ҵĵ�ǰ�ƺ�
	C2L_REQUIRE_GIFT_EQUIP_INFO		= 207,				--��������ѯ���ػ�װ����Ϣ
	C2L_REQUIRE_GIFT_EQUIP_BUYITEM		= 208,				--����������ػ�װ��
	C2L_REQUIRE_SHARE_REWARD		= 209,				--���������ȡ������
	
	
	C2L_REQUIRE_TASK_TYPE_FINISH			= 213,			--�������������£�����
	C2L_REQUIRE_TASK_QUERY_STATE			= 214,			--�����ѯ�����£�����
	C2L_REQUIRE_TASK_TAKEREWARD			= 215,			--������ȡ��������£��Ľ���
	C2L_REQUIRE_TASK_TAKEREWARD_ALL			= 216,			--����һ����ȡȫ���Ѵ�������£��Ľ���
	C2L_REQUIRE_ACTIVITY_TODAY_STATE		= 217,			--�����ѯ�����14��ǩ��������Ƿ����ȡ����
	C2L_REQUIRE_ACTIVITY_TODAY_SIGNIN		= 218,			--�����14��ǩ�������ǩ��
	C2L_REQUIRE_ACTIVITY_SIGNIN_BUYGIFT		= 219,			--�����14��ǩ��������ػ����
	C2L_REQUIRE_SYSTEM_MAIL_LIST			= 220,			--��ȡϵͳ�ʼ��б��£�
	C2L_REQUIRE_SYSTEM_MAIL_REWAR_ALL		= 221,			--����һ����ȡȫ���ʼ�
	C2L_REQUIRE_GM_ADDDEBRIS			= 222,			--���������Ƭ��������Ա���ã�
	C2L_REQUIRE_SEND_GAMEEND_INFO			= 223,			--�����ϴ�ս�����
	--GMָ��
	C2L_REQUIRE_GM_ADD_RESOURCE			= 224,			--GMָ��-����Դ
	C2L_REQUIRE_GM_MAP_FINISH			= 225,			--GMָ��-��ͼȫͨ
	C2L_REQUIRE_GM_ADD_HEROEXP_ALL			= 226,			--GMָ��-��ȫ��Ӣ�۾���
	C2L_REQUIRE_GUIDE_ADD_REDEQUOP			= 227,			--��������ͼ-��Ӻ�װ
	C2L_REQUIRE_TASK_WEEK_REWARD			= 228,			--������ȡ�������£����Ƚ���
	C2L_REQUIRE_COMMENT_TAKEREWAED			= 229,			--������ȡ���۽������£�
	C2L_REQUIRE_DEBUG				= 230,			--GM�����͵���ָ��
	
	--�����뵯Ļ
	C2L_REQUIRE_COMMENT_BARRAGE_BEGIN		= 280,
	C2L_REQUIRE_COMMENT_ADD					= 281,		--�������
	C2L_REQUIRE_COMMENT_EDIT				= 282,		--�޸�����
	C2L_REQUIRE_COMMENT_DEL					= 283,		--ɾ������
	C2L_REQUIRE_COMMENT_LOOK				= 284,		--�鿴����
	C2L_REQUIRE_COMMENT_LIKES				= 285,		--���۵���
	C2L_REQUIRE_COMMENT_CANNEL_LIKES		= 286,		--ȡ������
	C2L_REQUIRE_COMMENT_LIKES_COUNT			= 287,		--�鿴�޵�����
	C2L_REQUIRE_COMMENT_USER_LIKES			= 288,		--����Ƿ�����۵���
	C2L_REQUIRE_COMMENT_QUERY_TITLE			= 289,		--��ѯ���۱���

	C2L_REQUIRE_COMMENT_BARRAGE_LOOK		= 290,		--�鿴��Ļ

	C2L_REQUIRE_COMMENT_EDIT_TITLE			= 296,		--�޸����۱���

	C2L_REQUIRE_COMMENT_BARRAGE_END			= 300,

	C2L_REQUIRE_PLAYGOPHER				= 310,		--����������
	C2L_REQUIRE_GAMEGOPHER_REWARD			= 311,		--��ȡ������Ϸ����

	C2L_REQUIRE_SYNC_CHAT_MSG_ID			= 312,		--������Ϣidͬ��
	C2L_REQUIRE_BUBBLE_NOTICE			= 313,			--���������ð��		--add by mj 2022.11.21����ʱע��
}

hVar.DB_RECV_TYPE = {
	--L2C_RECV			= 3003,
	L2C_RECV			= 66666, --��׿��Э�����

	L2C_SYSTIME			= 1,				--��ȡ������ʱ��
	L2C_QUEST_MAIL_ANNEX		= 2,				--��ȡ���丽��
	L2C_QUEST_VER_INFO		= 3,				--��ȡ�汾��Ϣ
	L2C_NOTICE_PLAYER_LOGIN = 4,					--��׿��ҵ���
	L2C_QUEST_MAIL_ANNEX_DRAWCARD	= 5,				--��ȡ�������鿨���丽��
	L2C_QUEST_MAIL_ANNEX_ENDLESS	= 6,				--��ȡ�޾���ͼ���н������丽��
	L2C_QUEST_MAIL_ANNEX_PVEMULTY	= 7,				--��ȡ��ħ������ÿ�����ͽ����丽��
	L2C_QUEST_MAIL_ANNEX_TITIEMSG	= 8,				--��ȡ�������ĵĽ����丽��
	L2C_QUEST_MAIL_ANNEX_OPENCHEST	= 9,				--��÷�����ֱ�ӿ��������丽��

	--�������
	L2C_QUEST			= 11,				--���񷵻�
	L2C_QUEST_REWARD		= 12,

	--���а���ع���
	L2C_BOARD_TEMPLATE		= 13,				--�������а�ģ��
	L2C_BILLBOARD_INFO		= 14,				--�������а���Ϣ

	--�޸������Ƿ�ɹ�
	L2C_REQUEST_CHANGE_NAME		= 15,				--�޸���������

	--�̳�
	L2C_REQUEST_SHOP_INFO		= 16,				--�����̵���Ϣ
	L2C_REQUEST_BUYITEM		= 17,				--���ع��򵽵���Ʒ��Ϣ
	L2C_REQUEST_REFRESH_SHOP	= 18,				--����ˢ���̵���
	L2C_REQUEST_MYCOIN		= 19,				--������Ҹ��ֻ���
	
	L2C_REQUEST_MERGE_REDEQUIP	= 20,				--��װ�ϳɽ������
	L2C_REQUEST_XILIAN_REDEQUIP	= 21,				--��װϴ���������
	L2C_REQUEST_SYNC_REDEQUIP	= 22,				--��װͬ���������
	
	L2C_REQUEST_VIP_INFO		= 23,				--���ػ�ȡ��vip��Ϣ
	L2C_REQUEST_VIP_DAILY_REWARD	= 24,				--����vipÿ�ս���

	L2C_REQUEST_GET_ALLREDEQUIP	= 25,				--���غ�װ����ɶһ������к�װ��Ϣ
	L2C_REQUEST_REDSCROLL_EXCHANGE	= 26,				--���غ�װ����һ��Ƿ�ɹ�
	
	--��׿��ͬ����־�浵������
	L2C_REQUEST_ANDROID_SAVE_LOG	= 27,				--���ذ�׿��ͬ����־�浵
	L2C_REQUEST_ANDROID_NOTICE_MSG	= 28,				--���ذ�׿��������Ϣ
	
	--���������Ƿ�ɹ�
	L2C_REQUEST_SET_NAME		= 29,				--������������
	
	--�޾���ͼ��ʼս������
	L2C_BOARD_ENDLESS_BEGIN_GAME	= 30,			--�޾���ͼ��ʼս������
	
	--�޾���ͼ���а��ѯǰ10���������
	L2C_BOARD_ENDLESS_RANK_NAME		= 31,			--�޾���ͼ���а��ѯǰ10���������
	
	L2C_REQUEST_MERGE_ORANGEEQUIP	= 32,				--��װ�ϳɽ������
	L2C_REQUEST_DESCOMPOS_REDEQUIP	= 33,				--���طֽ��װ�Ľ��
	L2C_REQUIRE_BATTLE_NORMAL_RET = 34,				--������ս��ͨ�����ͼ�Ľ������
	L2C_REQUIRE_BATTLE_ENTETAMENT_RET = 35,				--������ս���־����ͼ�Ľ������
	L2C_REQUIRE_RESUME_ENTETAMENT_RET = 36,				--���ؼ������־����ͼ�Ľ�����أ�����Թ���
	
	--ϵͳ
	L2C_NOTICE_ERROR		= 98,				--�����¼�1
	L2C_NOTICE_MONTH_CARD = 143,					--֪ͨ�������¿����¿����շ������
	L2C_NOTICE_TANK_BILLBOARD = 151,				--֪ͨս�����а񷵻�
	L2C_NOTICE_TANK_MODIFYNAME	= 152,				--֪ͨս�������������
	L2C_NOTICE_TANK_UPLOAD_STAGELOG	= 153,			--֪ͨ�ϴ�ս���ؿ���־����
	
	L2C_NOTICE_TANK_YESTERDAY_RANK	= 154,			--֪ͨ��ȡ�������а�����
	L2C_RECEIVE_TANK_YESTERDAY_RANK	= 155,			--֪ͨ��ȡս��������������
	L2C_REQUIRE_TREASURE_INFO	= 156,				--֪ͨ��Ҳ�ѯ����ͱ�������λֵ��Ϣ���ؽ��
	L2C_UPDATE_TREASURE_STARUP	= 157,				--֪ͨ��ұ������Ƿ��ؽ��
	L2C_UPLOAD_TREASURE_ATTR_INFO	= 158,				--֪ͨ����ϴ���������λֵ��Ϣ���ؽ��
	L2C_REQUIRE_TANK_OPEN_CHEST	= 159,				--֪ͨ���ս�����󿪱��䷵�ؽ��
	L2C_REQUIRE_TANK_WEAPON_INFO_RET	= 160,			--֪ͨ�������ǹ��Ϣ���ؽ��
	L2C_REQUIRE_TANK_WEAPON_STARUP_RET	= 161,			--֪ͨ�������ǹ���Ƿ��ؽ��
	--L2C_REQUIRE_TANK_WEAPON_ADDEXP_RET	= 162,			--֪ͨ�������ǹ�Ӿ���ֵ���ؽ��
	L2C_REQUIRE_TANK_TALENTPOINT_INFO_RET	= 163,			--֪ͨ���ս�����ܵ�����Ϣ���ؽ��
	L2C_REQUIRE_TANK_TALENTPOINT_ADDEXP_RET		= 164,		--֪ͨ���ս���Ӿ���ֵ���ؽ��
	L2C_REQUIRE_TANK_TALENTPOINT_ADDPOINT_RET	= 165,		--֪ͨ���ս������������ؽ��
	L2C_REQUIRE_TANK_PET_INFO_RET	= 166,				--֪ͨ��ҳ�����Ϣ���ؽ��
	L2C_REQUIRE_TANK_PET_STARUP_RET	= 167,				--֪ͨ��ҳ������Ƿ��ؽ��
	--L2C_REQUIRE_TANK_PET_ADDEXP_RET	= 168,			--֪ͨ�������ǹ�Ӿ���ֵ���ؽ��
	L2C_REQUIRE_TANK_TALENTPOINT_RESTORE_RET	= 169,		--����ս���츳�����÷��ؽ��
	L2C_REQUIRE_TANK_WEAPON_LEVELUP_RET	= 170,			--֪ͨ�������ǹ�������ؽ��
	L2C_REQUIRE_TANK_PET_LEVELUP_RET	= 171,			--֪ͨ��ҳ����������ؽ��
	L2C_REQUIRE_TANK_TACTIC_INFO_RET	= 172,			--֪ͨ���ս������Ϣ���ؽ��
	L2C_REQUIRE_TANK_TACTIC_LEVELUP_RET	= 173,			--֪ͨ���ս�����������ؽ��
	L2C_REQUIRE_TANK_CLEARDATA_RET		= 174,			--֪ͨ���������ݽ������
	L2C_REQUIRE_TANK_PET_WAKUANG_RET	= 186,			--֪ͨ��ǲ�����ڿ�������
	L2C_REQUIRE_TANK_PET_WATILI_RET		= 187,			--֪ͨ��ǲ�����������������
	L2C_REQUIRE_TANK_PET_CANCEL_WAKUANG_RET	= 188,			--֪ͨ��ǲ����ȡ���ڿ�������
	L2C_REQUIRE_TANK_PET_CANCEL_WATILI_RET	= 189,			--֪ͨ��ǲ����ȡ���������������
	L2C_REQUIRE_TANK_TILI_EXCHANGE_RET	= 190,			--֪ͨ�һ������������
	L2C_REQUIRE_TANK_ADDONES_KESHI_RET	= 191,			--֪ͨ��ȡ�ڿ��ʯ�������
	L2C_REQUIRE_TANK_ADDONES_TILI_RET	= 192,			--֪ͨ��ȡ�ڿ������������
	L2C_REQUIRE_TANK_TILI_INFO_RET		= 193,			--֪ͨ�������������Ϣ�������
	L2C_REQUIRE_TANK_MAP_INFO_RET		= 194,			--֪ͨ��ҵ�ͼ��Ϣ���ؽ��
	L2C_REQUIRE_TANK_MAP_FINISH_REWARD_RET	= 195,			--֪ͨ��ҵ�ͼͨ�ؽ������ؽ��
	L2C_REQUIRE_TANK_REBIRTH_RET		= 196,			--֪ͨ�����Ϸ��ս������ؽ��
	L2C_NOTICE_ACHIEVEMENT_QUERY_RET	= 197,			--֪ͨ��Ҳ�ѯ�ɾ��������Ľ������
	L2C_NOTICE_ACHIEVEMENT_TAKEREWARD_RET	= 198,			--֪ͨ�����ȡ�ɾͽ����Ľ������
	L2C_REQUEST_QUNYINGGE_REDRAWCARD	= 199,			--֪ͨ���޾�ȺӢ���س鿨Ƭ�������
	L2C_REQUIRE_TANK_ADDONES_CHEST_RET	= 200,			--֪ͨ��ȡ�ڿ���������
	L2C_NOTICE_MAIL_ANNEX_CHATDRAGON_RET	= 201,			--֪ͨ��ȡ�������������丽���Ľ������
	L2C_NOTICE_USER_CHAMPION_INFO_RET	= 202,			--֪ͨ��ҵĵ�ǰ�ƺŽ������
	
	L2C_NOTICE_TASK_QUERY_RET			= 205,		--֪ͨ��������£��Ľ��ȷ���
	L2C_NOTICE_TASK_TAKEREWARD_RET			= 206,		--֪ͨ��������£���������콱����
	L2C_NOTICE_TASK_TAKEREWARD_ALL_RET		= 207,		--֪ͨ���һ����ȡȫ���Ѵ�������£��Ľ����������
	L2C_NOTICE_ACTIVITY_TODAY_STATE			= 208,		--֪ͨ�����14��ǩ��������Ƿ����ȡ����
	L2C_NOTICE_ACTIVITY_TODAY_SIGNIN		= 209,		--֪ͨ�����14��ǩ�������ǩ�����
	L2C_NOTICE_ACTIVITY_SIGNIN_BUYGIFT		= 210,		--֪ͨ�����14��ǩ��������ػ�������
	L2C_REQUIRE_SYSTEM_MAIL_LIST_RET		= 211,		--֪ͨ���ϵͳ�ʼ��б��£�
	L2C_REQUIRE_SYSTEM_MAIL_REWARD_ALL_RET		= 212,		--֪ͨ���һ����ȡȫ���ʼ��������
	L2C_REQUIRE_GM_ADDDEBRIS_RET			= 213,		--֪ͨ��������Ƭ����������أ�������Ա�ɲ�����
	L2C_REQUIRE_SEND_GAMEEND_INFO_RET		= 214,		--֪ͨ�ϴ�ս���������
	--GMָ��
	L2C_REQUIRE_GM_ADD_RESOURCE_RET			= 215,		--֪ͨGMָ��-����Դ���ؽ��
	L2C_REQUIRE_GM_MAP_FINISH_RET			= 216,		--֪ͨGMָ��-��ͼȫͨ���ؽ��
	L2C_REQUIRE_GM_ADD_HEROEXP_ALL			= 217,		--֪ͨGMָ��-��ȫ��Ӣ�۾��鷵�ؽ��
	L2C_REQUIRE_GUIDE_ADD_REDEQUOP_RET		= 218,		--֪ͨ����ͼ������װ���ؽ��
	L2C_NOTICE_TASK_WEEK_REWARD_RET			= 219,		--֪ͨ��ȡ�������£����Ƚ������ؽ��
	L2C_NOTICE_COMMENT_REWARD_RET			= 220,		--֪ͨ��ȡ�Ƽ��������£����ؽ��
	L2C_NOTICE_GIFT_EQUIP_INFO_RET			= 221,		--֪ͨ��ѯ���ػ�װ����Ϣ���ؽ��
	L2C_NOTICE_GIFT_EQUIP_BUYITEM_RET		= 222,		--֪ͨ�����ػ�װ�����ؽ��
	L2C_NOTICE_SHARE_REWARD_RET			= 223,		--֪ͨ��ȡ���������ؽ��
	
	--�����뵯Ļ
	L2C_REQUIRE_COMMENT_BARRAGE_BEGIN		= 280,
	L2C_REQUIRE_COMMENT_ADD_RET				= 281,		--�������
	L2C_REQUIRE_COMMENT_EDIT_RET			= 282,		--�޸�����
	L2C_REQUIRE_COMMENT_DEL_RET				= 283,		--ɾ������
	L2C_REQUIRE_COMMENT_LOOK_RET			= 284,		--�鿴����
	L2C_REQUIRE_COMMENT_LIKES_RET			= 285,		--���۵���
	L2C_REQUIRE_COMMENT_CANNEL_LIKES_RET	= 286,		--ȡ������
	L2C_REQUIRE_COMMENT_LIKES_COUNT_RET		= 287,		--�鿴�޵�����
	L2C_REQUIRE_COMMENT_USER_LIKES_RET		= 288,		--����Ƿ�����۵���
	L2C_REQUIRE_COMMENT_QUERY_TITLE			= 289,		--��ѯ���۱���

	L2C_REQUIRE_COMMENT_BARRAGE_LOOK_RET	= 290,		--�鿴��Ļ


	L2C_REQUIRE_COMMENT_EDIT_TITLE			= 296,		--�޸����۱���

	L2C_REQUIRE_COMMENT_BARRAGE_END			= 300,

	
	L2C_REQUIRE_PLAYGOPHER_RESULT			= 310,		--����������Ľ��
	L2C_REQUIRE_GAMEGOPHER_REWARD			= 311,		--���ص�����

	L2C_REQUIRE_SYNC_CHAT_MSG_ID			= 312,		--������Ϣidͬ��
	L2C_REQUIRE_BUBBLE_NOTICE_RET			= 313,		--֪ͨ�����ð�ֽ������ --add by mj 2022.11.21����ʱע��
}

hVar.DBNETERR = 
{
	UNKNOW_ERROR = 0,				--δ֪����
	UPDATE_BILLBOARD_RANK_FAILED = 1,		--�������а�����ʧ��

}

