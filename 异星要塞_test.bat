@echo off

cd pak

call luac.bat

cd..

start system\hero_pc_test.exe skip_update w=520; h=925;