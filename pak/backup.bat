echo ---------------------------- ɾ�����ݵĽű��ļ���ʼ

echo ------ ɾ�� script_backup\scripts
rd ..\script_backup\scripts /s /q

echo ------ ɾ�� script_backup\tabs
rd ..\script_backup\tabs /s /q

echo ---------------------------- ɾ�����ݵĽű��ļ�����



echo ---------------------------- ��ʼ�ű��ļ��ı���

echo ------ ���� script_backup\scripts
xcopy ..\data\scripts    ..\script_backup\scripts /I/E

echo ------ ���� script_backup\tabs
xcopy ..\data\tabs    ..\script_backup\tabs /I/E

echo ---------------------------- �����ű��ļ��ı���