@echo off
cd pak
echo -------------------

luac -o ../data/game.so ^
../data/game.so ^
../data/ggg.lua


pause