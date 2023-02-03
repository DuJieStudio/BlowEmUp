@echo off
cd pak
echo -------------------
echo 正在分析代码，请稍后...
lua sys/create_bat.lua

echo 正在打包代码，请稍候...

call sys/package.bat

echo 完成!
pause