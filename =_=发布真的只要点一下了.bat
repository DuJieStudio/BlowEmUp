@echo off

if not exist .\data\scripts\ (echo =_=干嘛老喜欢多点一次...)
if not exist .\data\scripts\ (goto gameover)


if not exist .\data\tabs\ (echo =_=干嘛老喜欢多点一次...)
if not exist .\data\tabs\ (goto gameover)


cd pak

call lua2gamedata.bat
call luac.bat
call backup.bat
call del.bat

:gameover

pause