--����
local Queue = class("Queue")
	
	--���캯��
	function Queue:ctor()
		self._first = 0
		self._last = -1
		self._store = {}
		return self
	end
	
	--push
	function Queue:Push(value)
		local last = self._last + 1
		self._last = last
		self._store[last] = value
		return self
	end
	
	--pop
	function Queue:Pop()
		local value
		local first = self._first
		
		if self:IsEmpty() then 
		else
			value = self._store[first]
			
			self._store[first] = nil
			
			self._first = self._first + 1
		end
		
		return value
	end
	
	--�Ƿ�Ϊ��
	function Queue:IsEmpty()
		local ret = false
		if self._first > self._last then
			ret = true
		end
		return ret
	end

	--��ȡ��ǰ����
	function Queue:GetLen()
		if self:IsEmpty() then
			return 0
		else
			return self._last - self._first + 1
		end
	end

	--��ȡ������������(���ᴥ������pop)
	function Queue:GetAll()
		local ret = {}
		if not self:IsEmpty() then
			for i = self._first, self._last do
				ret[#ret + 1] = self._store[i]
			end
		end
		return ret
	end
	
return Queue