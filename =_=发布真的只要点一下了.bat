@echo off

if not exist .\data\scripts\ (echo =_=������ϲ�����һ��...)
if not exist .\data\scripts\ (goto gameover)


if not exist .\data\tabs\ (echo =_=������ϲ�����һ��...)
if not exist .\data\tabs\ (goto gameover)


cd pak

call lua2gamedata.bat
call luac.bat
call backup.bat
call del.bat

:gameover

pause