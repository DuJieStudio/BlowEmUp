--工会管理类
local FileWriter = class("FileWriter")
	--构造函数
	function FileWriter:ctor()
		self._fileTypeName = ""
		
		--输出
		self._fileWriter = nil		--输出
		self._fileWriterName = nil	--输出日期
		
		return self
	end
	
	--初始化
	function FileWriter:Init(fileTypeName)
		--输出初始化
		if (self._fileWriter == nil) then
			self._fileTypeName = fileTypeName
			
			--输出日志
			local sDateYMD = os.date("%Y-%m-%d", os.time())
			self._fileWriterName = g_serverLog .. tostring(self._fileTypeName) .. "_" .. sDateYMD ..  ".log"	--输出日期
			self._fileWriter = io.open(self._fileWriterName, "a")
		end
		
		return self
	end
	
	--release
	function FileWriter:Release()
		--文件
		if self._fileWriter then
			self._fileWriter:close()
			self._fileWriter = nil
		end
		
		self._fileTypeName = ""
		self._fileWriterName = nil	--输出日期
		
		return self
	end
	
	--写日志
	function FileWriter:Write(text)
		if self._fileWriter then
			local sDateYMD = os.date("%Y-%m-%d", os.time())
			local fileName = g_serverLog .. tostring(self._fileTypeName) .. "_" .. sDateYMD ..  ".log"	--输出日期
			
			--到了第2天
			if (fileName ~= self._fileWriterName) then
				self._fileWriter:close()
				
				self._fileWriterName = fileName
				self._fileWriter = io.open(fileName, "a")
			end
			
			local sDate = os.date("%Y-%m-%d %H:%M:%S", os.time())
			local buff = string.format("[%s]%s\n", sDate, tostring(text))
			self._fileWriter:write(buff)
			self._fileWriter:flush()
		end
		
		return self
	end
	
return FileWriter
