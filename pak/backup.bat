echo ---------------------------- 删除备份的脚本文件开始

echo ------ 删除 script_backup\scripts
rd ..\script_backup\scripts /s /q

echo ------ 删除 script_backup\tabs
rd ..\script_backup\tabs /s /q

echo ---------------------------- 删除备份的脚本文件结束



echo ---------------------------- 开始脚本文件的备份

echo ------ 备份 script_backup\scripts
xcopy ..\data\scripts    ..\script_backup\scripts /I/E

echo ------ 备份 script_backup\tabs
xcopy ..\data\tabs    ..\script_backup\tabs /I/E

echo ---------------------------- 结束脚本文件的备份