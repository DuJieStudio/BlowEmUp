@echo off
cd pak
echo -------------------
echo ���ڷ������룬���Ժ�...
lua sys/create_bat.lua

echo ���ڴ�����룬���Ժ�...

call sys/package.bat

echo ���!
pause