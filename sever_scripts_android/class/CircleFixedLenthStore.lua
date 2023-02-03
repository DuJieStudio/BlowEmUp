--固定长度的循环存取容器
local CircleFixedLenthStore = class("CircleFixedLenthStore")
    
	--构造函数
	function CircleFixedLenthStore:ctor(clsName)
		self._cls = clsName or "num"
		self._list = nil
		--self._store = nil
		self._len = 0
		return self
	end
	--内存池初始化
	function CircleFixedLenthStore:Init(lenth)
		self:Clear()
		self._list = {}
		self._len = lenth
		--self._store = {}
		for i = 1, lenth do
			local data = nil
			if self._cls == "num" then
				data = 0
			elseif self._cls == "string" then
				data = ""
			elseif self._cls == "table" then
				data = {}
			elseif hClass[self._cls] then
				data = hClass[self._cls]:create()
			end
			self._list[#self._list + 1] = data	
			--self._store[#self._list + 1] = data
		end
		return self
	end
	--清空内存池
	function CircleFixedLenthStore:Clear()
		self._list = nil
		--self._store = nil
		return self
	end
	--从内存池中申请对象
	function CircleFixedLenthStore:CreateObj()
		if self._list and #self._list > 0 then
			local ret = self._list[#self._list]
			local retIdx = #self._list

			table.remove(self._list,retIdx)
			return ret
		else
			return
		end
	end
	--将对象释放回内存池
	function CircleFixedLenthStore:Release(classObj)
		if self._list then
			table.insert(self._list, 1, classObj)
		end
		return self
	end

	--剩余容量
	function CircleFixedLenthStore:GetRemainNum()
		local leftNum = 0
		if self._list and type(self._list) == "table" then
			leftNum = #self._list
		end
		return math.max(0, leftNum)
	end

	--最大容量
	function CircleFixedLenthStore:GetCapactiy()
		return self._len
	end
    
return CircleFixedLenthStore