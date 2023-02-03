-- 传说中的类底层
function eClassInit(SYNC_TAB)
	_DEBUG_MSG = _DEBUG_MSG or print
	--同步部分，SYNC_TAB为返回一个表的函数或一个字符串
	--不会自动覆盖已存在的同步表
	local __SYNC_GET_FUNC
	if type(SYNC_TAB)=="function" then
		__SYNC_GET_FUNC = SYNC_TAB
	else
		if type(SYNC_TAB)~="string" then
			SYNC_TAB = "__eClass_SYNC_TAB"
		end
		_G[SYNC_TAB] = _G[SYNC_TAB] or {}
		__SYNC_GET_FUNC = function()
			return _G[SYNC_TAB]
		end
	end

	--------------------------------------------
	-- [李宁 2010/11/1]
	-- 2011-2-14：优化GetObj函数，提高效率
	-- 2011-4-28：优化eClass效率
	-------------------------------------
	-- eClass专用API
	local __eClassAPI = {
		GetObj = function(class,ID)
			if class.__ID[ID]~=0 then
				return class.__ID[ID]
			end
		end,

		EnumAddId = function(class,id)
			local e = class.enum_list
			if e.f==0 then
				e.f = id		--first
			end
			e.l[id] = e.c		--last
			if e.c~=0 then
				e.n[e.c] = id	--next
			end

			if e.i==id and e.ni==0 then
				e.ni = e.i
			end

			e.c = id
		end,

		EnumRemoveId = function(class,id)
			local e = class.enum_list
			if id==e.f then
				e.f = e.n[id] or 0
			end
			if id==e.c then
				e.c = e.l[id] or 0
			end
			if e.l[id] and e.l[id]~=0 then
				e.n[e.l[id]] = e.n[id] or 0
			end
			if e.n[id] and e.n[id]~=0 then
				e.l[e.n[id]] = e.l[id] or 0
			end

			if e.ni~=0 and e.ni==id then
				e.ni = e.n[id] or 0
			end

			e.l[id] = 0
			e.n[id] = 0
		end,

		EnumObj = function(class,code,param)
			local e = class.enum_list
			local obj = class.__ID
			e.i = e.f
			while e.i~=0 and obj[e.i] and obj[e.i]~=0 do
				e.ni = e.n[e.i] or 0
				local o = obj[e.i]
				if o.ID~=0 then
					code(o,param)
				end
				e.i = e.ni
			end
			e.i = 0
			e.ni = 0
		end,
		_sEnumObj = function(class,code,param)
			if #class.__ID>0 then
				for i = 1,#class.ID do
					local o = class.__ID[i]
					if o~=0 and o.ID~=0 then
						code(o,param)
					end
				end
			end
		end,
	}

	__eClassAPI.AddObj = function(class,obj)
		local list = class.ID
		local p = list.p
		if p>0 then
			list.p = list[p]
			list[p] = obj
			obj.ID = p
			class.__ID[obj.ID] = obj
		else
			local n = #list+1
			list[n] = obj
			obj.ID = n
			class.__ID[obj.ID] = obj
		end
		
		--可以enum的处理
		if class.enum_list and obj.ID~=0 then
			__eClassAPI.EnumAddId(class,obj.ID)
		end
		return obj
	end

	__eClassAPI.RemoveObj = function(class,obj)
		if obj.ID and obj.ID<=0 then return end

		--可以enum的处理
		if class.enum_list and obj.ID~=0 then
			__eClassAPI.EnumRemoveId(class,obj.ID)
		end

		local list = class.ID
		class.__ID[obj.ID] = 0
		list[obj.ID] = list.p
		list.p = obj.ID
		obj.ID = 0
		return obj
	end
	-----------------------------------------------------
	local __NumberTable2String
	__NumberTable2String = function(v,tail,Depth,DepthMax)
		Depth = Depth or 0
		tail = tail or ""
		DepthMax = DepthMax or 10
		local valType = type(v)
		if Depth>DepthMax then
			return "0"..tail
		elseif valType=="table" then
			local r = "{"
			if Depth==0 then
				if type(v.i)=="number" then
					r = r.."i="..v.i..","
				end
				if type(v.n)=="number" then
					r = r.."n="..v.n..","
				end
				if type(v.num)=="number" then
					r = r.."num="..v.num..","
				end
			end
			for i = 1,#v do
				r = r..__NumberTable2String(v[i],",",Depth+1,DepthMax)
			end
			return r.."}"..tail
		elseif valType=="number" then
			return v..tail
		elseif valType=="string" then
			return "\""..tostring(string.gsub(v,"\n","\\n")).."\""..tail
		else
			return "0"..tail
		end
	end
	local __KeyNumberTable2String
	__KeyNumberTable2String = function(v,tail,Depth)
		Depth = Depth or 0
		tail = tail or ""
		local valType = type(v)
		if Depth>10 then
			return "0"..tail
		elseif valType=="table" then
			local r = "{"
			local n = #v
			if n>0 then
				for i = 1,n do
					r = r..__KeyNumberTable2String(v[i],",",Depth+1)
				end
			end
			for k,o in pairs(v) do
				local case = type(k)
				if case=="number" then
					if k<=0 or k>n then
						r = r.."["..k.."]="..__KeyNumberTable2String(o,",",Depth+1)
					end
				elseif case=="string" then
					r = r..k.."="..__KeyNumberTable2String(o,",",Depth+1)
				end
			end
			return r.."}"..tail
		elseif valType=="number" then
			return v..tail
		elseif valType=="string" then
			return "\""..tostring(string.gsub(v,"\n","\\n")).."\""..tail
		else
			return "0"..tail
		end
	end
	__eClassAPI.NumberTable2String = __NumberTable2String
	--------------------------------------------------------------
	local eClass_default_init = function(self)
	end
	local eClass_default_destroy = function(self)
	end
	local __PreT = ""
	local __TailN = ""--"\n"
	local __SAVE__FilterTab
	local __AntiNesting = function(rTab,pKey,key,val,pre,saveTag,tail,__TailN)
		--防嵌套锁
		if __SAVE__FilterTab then
			if __SAVE__FilterTab[val]==1 then
				_DEBUG_MSG("[LUA ERROR]发现对嵌套表的引用"..tostring(pKey).."["..tostring(key).."]，可能引起存档错误！")
				if type(val.ID)=="number" then
					rTab[#rTab+1] = pre..saveTag.."={OBJ=1,ID="..tostring(val.ID).."}"..tail..__TailN
				else
					rTab[#rTab+1] = pre..saveTag.."="..__NumberTable2String(val)..tail..__TailN
					--rTab[#rTab+1] = pre..saveTag.."={nesting=1}"..tail..__TailN
				end
				return 1
			else
				__SAVE__FilterTab[val] = 1
			end
		end
	end
	local eClass_SaveObject_ToFile
	eClass_SaveObject_ToFile = function(pKey,key,val,rTab,preTag,pre,tail,SpecialSaveTableKey,Depth)
		Depth = Depth or 0
		pre = pre and pre..(preTag or __PreT) or ""
		tail = tail or ""
		local saveTag
		local valType = type(val)
		local tagType = type(key)
		if tagType=="number" then
			saveTag = "["..key.."]"
		elseif tagType=="string" then
			if tostring(tonumber(key))==key then
				saveTag = "["..key.."]"
			else
				saveTag = key
			end
		else
			saveTag = "[\""..tostring(key).."\"]"
		end
		if valType=="table" then
			local AntiNesting = 1
			if key=="__SpecialKeyTab" then
				return
			elseif pKey=="ID" then
				--全部存下来
			elseif pKey=="enum_list" then
				--enum_list比较特殊，这样存，占空间比较小
				rTab[#rTab+1] = pre..saveTag.."="..__NumberTable2String(val)..tail
				return
			elseif key=="obj_static" then
				--obj_static中什么都不存
				rTab[#rTab+1] = pre..saveTag.."={},"
				return
			elseif key=="ID" then
				--防嵌套锁
				if AntiNesting==1 then
					AntiNesting = 0
					if __AntiNesting(rTab,pKey,key,val,pre,saveTag,tail,__TailN)==1 then
						return
					end
				end
				--rTab[#rTab+1] = pre..saveTag.."={p="..(val.p or 0)..","
				rTab[#rTab+1] = pre..saveTag.."={p="..(val.p or 0)..","
				if SpecialSaveTableKey and type(SpecialSaveTableKey.__ObjectSaveCode)=="function" then
					local _CodeS = SpecialSaveTableKey.__ObjectSaveCode
					for i = 1,#val do
						if not(_CodeS(i,val[i],rTab)) then
							rTab[#rTab+1] = "\n	"
							eClass_SaveObject_ToFile(key,i,val[i],rTab,preTag,pre,",",SpecialSaveTableKey,Depth+1)
						end
					end
				else
					for i = 1,#val do
						rTab[#rTab+1] = "\n	"
						eClass_SaveObject_ToFile(key,i,val[i],rTab,preTag,pre,",",SpecialSaveTableKey,Depth+1)
					end
				end
				rTab[#rTab+1] = pre.."\n}"..tail
				return
			else
				if SpecialSaveTableKey and SpecialSaveTableKey[key] then
					local case = SpecialSaveTableKey[key]
					if case==1 then
						--不存储的表格
						if val.i~=nil then
							rTab[#rTab+1] = pre..saveTag.."={i=0}"..tail..__TailN
							return
						else
							rTab[#rTab+1] = pre..saveTag.."={}"..tail..__TailN
							return
						end
					elseif case==-1 then
						--直接跳过
						return
					else
						--防嵌套锁
						if AntiNesting==1 then
							AntiNesting = 0
							if __AntiNesting(rTab,pKey,key,val,pre,saveTag,tail,__TailN)==1 then
								return
							end
						end
						if case==0 then
							--特殊存储方式:{{1,2,3,4},...}
							--这种方式仅存储全部数字索引的表格，请手动指定
							rTab[#rTab+1] = pre..saveTag.."="..__NumberTable2String(val)..tail..__TailN
							return
						elseif case=="n" then
							--特殊存储方式:{{1,2,3,4},...}
							--这种方式仅存储全部数字索引的表格，请手动指定,并且第一层在前面补上一个"	"，后面加上一个"\n"
							rTab[#rTab+1] = pre..saveTag.."={"
							for i = 1,#val do
								rTab[#rTab+1] = pre..(preTag or __PreT)..__NumberTable2String(val[i])..","--tail
							end
							rTab[#rTab+1] = pre.."}"..tail..__TailN
							return
						elseif case=="kn" then
							rTab[#rTab+1] = pre..saveTag.."={"
							local cap = #val
							if #val>0 then
								for i = 1,#val do
									local v = val[i]
									rTab[#rTab+1] = pre..(preTag or __PreT).."["..i.."]="..__KeyNumberTable2String(v)..","--tail
								end
							end
							for k,v in pairs(val) do
								local case = type(k)
								if case=="number" then
									if (k<1 or k>cap) then
										rTab[#rTab+1] = pre..(preTag or __PreT).."["..k.."]="..__KeyNumberTable2String(v)..","--tail
									end
								elseif case=="string" then
									rTab[#rTab+1] = pre..(preTag or __PreT)..k.."="..__KeyNumberTable2String(v)..","--tail
								end
							end
							rTab[#rTab+1] = pre.."}"..tail..__TailN
							return
						end
					end
				end
				if Depth>20 then
					return print("警告:存储表格["..tostring(pKey).."]时深度超出限制(max 20)")
				end
				if __SAVE__FilterTab==nil then
					--如果防嵌套锁没打开的话，禁止存储对象数据
					if type(val.ID)=="number" and type(val.__ID)=="number" and getmetatable(val)~=nil then
						--rTab[#rTab+1] = pre..key.." = {\"CLASSOBJECT\",\""..tostring(val.classname).."\","..val.ID..",}"..tail.."\n"
						return print("警告:存储表格["..tostring(pKey).."]中存储了对象类型的数据:"..tostring(key))
					end
				end
			end
			--防嵌套锁
			if AntiNesting==1 then
				AntiNesting = 0
				if __AntiNesting(rTab,pKey,key,val,pre,saveTag,tail,__TailN)==1 then
					return
				end
			end
			rTab[#rTab+1] = pre..saveTag.."={"..__TailN
			for k,v in pairs(val)do
				eClass_SaveObject_ToFile(key,k,v,rTab,preTag,pre,",",SpecialSaveTableKey,Depth+1)
			end
			rTab[#rTab+1] = pre.."}"..tail..__TailN
		elseif valType=="number" or valType=="boolean" then
			rTab[#rTab+1] = pre..saveTag.."="..tostring(val)..tail..__TailN
		elseif valType=="string" then
			rTab[#rTab+1] = pre..saveTag.."=\""..tostring(string.gsub(val,"\n","\\n")).."\""..tail..__TailN
		--else
			--return print("警告:存储表格["..tostring(pKey).."]中存储了自定义类型的数据["..tostring(key)..":("..valType..")")
		end
	end

	--------------------------------------------------------------
	-- 类（新）
	-- eClass:new(parent)			创建一个新的类
	eClass = {
		API = __eClassAPI,
		ConvertTableToString = eClass_SaveObject_ToFile,
		ConvertTableToStringEx = function(FilterTab,pKey,key,val,rTab,preTag,pre,tail,SpecialSaveTableKey,Depth)
			if type(FilterTab)=="table" then
				__SAVE__FilterTab = FilterTab
			else
				__SAVE__FilterTab = nil
			end
			eClass_SaveObject_ToFile(pKey,key,val,rTab,preTag,pre,tail,SpecialSaveTableKey,Depth)
			__SAVE__FilterTab = nil
		end,
		gAPI = {
			create = function()
				local g = {}
				g.ID = {p = 0}
				g.__ID = {}
				-- 类的实例计数器
				g.__count = 0
				return g
			end,
			add = __eClassAPI.AddObj,
			remove = __eClassAPI.RemoveObj,
			find = __eClassAPI.GetObj,
			enum = __eClassAPI._sEnumObj,
		},
		-- 管理组用的函数，暴露给外面用
		-- 构造类的new方法
		-- 
		-- class_type有三种类型:table、string、nil
		-- 当为table时，会作为parent参数使用，且无其他作用
		-- 当为string时，能任意组合3种类型：sync、static、enum，例如"sync static enum"
		-- 
		-- @param class_type? table|string('sync'|'static'|'enum') 类型
		-- @param parent? 继承基类，仅克隆函数
		-- @
		new = function(_,class_type,parent)
			if type(class_type)=='table' then
				parent = class_type
				class_type = nil
			end
			-- 构造一个类
			local class = eClass.gAPI.create()
			--继承:仅仅是将函数复制过来使用
			if type(parent)=='table' then
				--setmetatable(class,parent.meta)
				for k,v in pairs(parent)do
					if type(v)=="function" then
						rawset(class,k,v)
					end
				end
			end
			class.meta = {__index = class,__class = class}
			class.default_param = {}
			class.init = eClass_default_init
			class.destroy = eClass_default_destroy
			eClass.setcode(class,eClass.code)
			if type(class_type)=='string' then
				local sync = 0
				if string.find(class_type,'sync') then
					-- sync_code = function(class,opr,name,tab)
					class.sync = eClass.sync_code
					-- 构造同步表
					rawset(class,"sync_tab",{__SpecialKeyTab = {},ID = class.ID})
					sync = 1
				end
				if string.find(class_type,'static') then
					-- 设置静态方法
					eClass.setcode(class,eClass.static_code)
					class.obj_static = {}
					-- 同步模式
					if sync==1 then
						class:sync('set','obj_static')
					end
				end
				if string.find(class_type,'enum') then
					class.enum = __eClassAPI.EnumObj
					class.enum_list = {f=0,c=0,i=0,ni=0,l={},n={}}
					-- 同步模式
					if sync==1 then
						class:sync('set','enum_list')
					end
				end
			end

			return class
		end,

		---------------------------------------------------------------------
		-- 功能函数
		error = function(class,...)	--当发生错误时调用这里
		end,

		setcode = function(class,codes)
			local k,v
			for k,v in pairs(codes) do
				class[k] = v
			end
		end,

		code_tab_default = function(self)
			return 1
		end,

		code_tab_meta = {
			__index = function(t,k)
				rawset(t,k,eClass.code_tab_default)
				return eClass.code_tab_default
			end,
		},

		code_tab = function()
			local ct = {}
			setmetatable(ct,eClass.code_tab_meta)
			return ct
		end,

		----------------------------------------------
		-- 类方法
		code = {
			-- 构造实例的new方法
			new = function(class,param,unRecord)
				local self = {}
				if unRecord==0 then
					self.ID = 0
				else
					__eClassAPI.AddObj(class,self)
				end
				class.setclass(self,class)
				-- 类实例化次数+1
				class.__count = class.__count + 1
				-- 实例ID = 类实例化次数
				self.__ID = class.__count
				if class.init then
					class.init(self,param)
				end
				return self
			end,
			
			del = function(self,destroy)
				--if self.getRoadPoint and self:getRoadPoint() then
					--xlLG("RoadPoint", "del(1), unit=" .. tostring(self.data.name) .. "_" .. tostring(self.__ID) .. "\n")
				--end
				if self.ID==0 then return end
				local class = self:getclass()
				if destroy~=0 and rawget(self,'destroy')==nil and class.destroy then
					self:destroy()
				end
				__eClassAPI.RemoveObj(class,self)
				setmetatable(self,nil)	--只有普通的类是这样处理的
				
				--geyachao: 添加删除事件
				--if self.__del then
				--	self:__del()
				--end
			end,
			
			del_all = function(class)
				local _,v
				for _,v in pairs(class.ID)do
					if type(v)=='table' then
						v:del()
					end
				end
			end,

			setclass = function(self,class)
				setmetatable(self,class.meta)
			end,

			getclass = function(self)
				return getmetatable(self).__class
			end,

			find = function(class,ID)
				if ID then
					return __eClassAPI.GetObj(class,ID)
				end
			end,

			save_default = function(class,param,index)
				index = index or 1
				if param==nil then
					class.default_param[index] = nil
				else
					class.default_param[index] = {param = param,meta = {__index = param}}
				end
			end,

			load_default = function(self,param,index)
				index = index or 1
				local class = self:getclass()
				if class.default_param[index] then
					if param then
						setmetatable(param,class.default_param[index].meta)
					else
						param = class.default_param[index].param
					end
					return param
				end
			end,

			default = function(self,param,index)			--这个函数以后别用了。。。
				index = index or 1
				if type(self.ID)=='table' then
					if param==nil then
						self.default_param[index] = nil
					else
						self.default_param[index] = {param = param,meta = {__index = param}}
					end
				else
					local class = self:getclass()
					if class.default_param[index] then
						if type(param)=='table' then
							setmetatable(param,class.default_param[index].meta)
						else
							param = class.default_param[index].param
						end
						return param
					end
				end
			end,

			enum = __eClassAPI._sEnumObj,
		},

		----------------------------------------------
		-- 类方法（静态）
		-- 使用这里的代码，在new时会重用之前创建的obj
		-- 调用class:setstatic()以启动静态类
		static_code = {
			new = function(class,param)
				local self
				local list = class.ID
				local p = list.p
				--if type(p)~="number" then
					--xlLG("error_eclass","eClass."..tostring(class.classname).."创建ID错误"..tostring(p).."|"..tostring(list).."\n")
					--if g_eClassErrorCount~=1 then
						--g_eClassErrorCount = 1
						--local tab = hApi.SaveTableEx(class,{"OBJ_"..tostring(class.classname)},{meta=1,__static=1,sync_tab=1,handle=1,chaUI=1,localdata=1})
						--LuaSaveGameData("log/eClass_error.log",tab)
						----local f = io.open("ClassErrorLOG.lua","w")
						----for i = 1,#tab do
							----f:write(tab[i])
						----end
						----f:close()
					--end
				--end
				if p>0 and class.obj_static[p] then
					self = class.obj_static[p]
					list.p = list[p]
					list[p] = self
					self.ID = p
					class.__ID[self.ID] = self
				else
					self = {}
					class.setclass(self,class)

					local n = #list+1
					list[n] = self
					self.ID = n
					class.__ID[self.ID] = self
				end
				--可以enum的处理
				if class.enum_list and self.ID~=0 then
					__eClassAPI.EnumAddId(class,self.ID)
				end
				class.__count = class.__count + 1
				self.__ID = class.__count
				if class.init then
					class.init(self,param)
				end
				return self
			end,
			
			del = function(self,destroy)
				--if self.getRoadPoint and self:getRoadPoint() then
					--xlLG("RoadPoint", "del(2), unit=" .. tostring(self.data.name) .. "_" .. tostring(self.__ID) .. "\n")
				--end
				if self.ID==0 then return end
				local class = self:getclass()
				if destroy~=0 and rawget(self,'destroy')~=0 then
					if destroy=="safe" then
						pcall(self.destroy,self)
					else
						self.destroy(self)
					end
				end
				--可以enum的处理
				if class.enum_list and self.ID~=0 then
					__eClassAPI.EnumRemoveId(class,self.ID)
				end
				
				local list = class.ID
				class.__ID[self.ID] = 0
				list[self.ID] = list.p
				list.p = self.ID
				class.obj_static[self.ID] = self
				self.ID = 0
				self.__ID = -1*self.__ID
				
				--geyachao: 添加删除事件
				--if self.__del then
				--	self:__del()
				--end
			end,
			
			clear_static = function(self)
				local sTab = self.obj_static
				for k,v in pairs(sTab)do
					setmetatable(v,nil)
					sTab[k] = nil
				end
			end,
		},
		-----------------------------------------------------------
		-- 同步操作函数
		sync_tab = {},
		sync_save = function(self,SaveMode,SaveTableName)
			-- load_gamesys.hSaveData:table
			local tab_SYNC = __SYNC_GET_FUNC()
			if type(tab_SYNC)=="table" then
				local rTab
				if type(SaveMode)=="table" then
					rTab = SaveMode
					SaveMode = "file"
				else
					rTab = {}
				end
				SaveTableName = SaveTableName or "eSync"
				rTab[#rTab+1] = SaveTableName.." = {}\n"
				__SAVE__FilterTab = {}
				for k,v in pairs(tab_SYNC)do
					eClass_SaveObject_ToFile(nil,SaveTableName.."."..k,v,rTab,nil,nil,"\n",v.__SpecialKeyTab)
				end
				__SAVE__FilterTab = nil
				return rTab
			else
				return {}
			end
		end,
		sync_load = function(self,LoadList)
			if type(LoadList)=="table" then
				for i = 1,#LoadList do
					local k = LoadList[i]
					local v = eClass.sync_tab[k]
					if v and v:sync('load',k)~=1 then
						--ERROR:尝试读取同步数据失败
					end
				end
			else
				local k,v
				for k,v in pairs(eClass.sync_tab)do
					if v:sync('load',k)~=1 then
						--ERROR:尝试读取同步数据失败
					end
				end
			end
		end,
		-- 同步函数
		-- 
		-- 'set':将class[name]值同步到class.sync_tab表
		-- 
		-- @param opr string 操作类型:'set'|'local'|'simple'|'hook'|'save'|'load'
		-- @param name string 字段名
		-- @param tab? any 当opr为'set'时，为class[name]设置新的值
		sync_code = function(class,opr,name,tab)
			-- load_gamesys.hSaveData:table
			local tab_SYNC = __SYNC_GET_FUNC()
			if opr=='set' then
				if tab then
					class[name] = tab
				end
				class.sync_tab[name] = class[name]
			elseif opr=='local' then
				local m = class.sync_tab.__SpecialKeyTab
				if m then
					if type(name)=="table" then
						for i = 1,#name do
							m[name[i]] = 1
						end
					elseif name~=nil then
						m[name] = 1
					end
				end
			elseif opr=='simple' then
				local m = class.sync_tab.__SpecialKeyTab
				if m then
					if type(name)=="table" then
						for i = 1,#name do
							m[name[i]] = 0
						end
					elseif name~=nil then
						m[name] = 0
					end
				end
			elseif opr=='hook' then
				local m = class.sync_tab.__SpecialKeyTab
				if m then
					m.__ObjectSaveCode = name
				end
			elseif opr=='save' then
				tab_SYNC[name] = class.sync_tab
				eClass.sync_tab[name] = class
			elseif opr=='load' then
				if tab_SYNC[name] then
					local __SpecialKeyTab = class.sync_tab.__SpecialKeyTab
					class.sync_tab = tab_SYNC[name]
					class.sync_tab.__SpecialKeyTab = __SpecialKeyTab
					local k,v
					for k in pairs(class.sync_tab)do
						class[k] = class.sync_tab[k]
					end
					local code = rawget(class,'__InitAfterLoaded')
					--metatable特殊处理
					for k,v in pairs(class.ID)do
						if type(v)=='table' then
							class.__ID[k] = v
							class.setclass(v,class)
							if code then
								code(v)
							end
						end
					end
					if class.obj_static then
						local code = rawget(class,'__DeadObjectAfterLoaded')
						for k,v in pairs(class.obj_static)do
							if type(v)=='table' then
								class.setclass(v,class)
								if code then
									code(v)
								end
							end
						end
					end
					return 1
				end
			end
		end,
	}

	---------------------------------------------------------------
	-- eClass附带功能
	eClass.index_tab = {
		new = function()
			return {n=0,max=0}
		end,
		insert = function(self,obj)
			local p = 1
			if self.n==self.max then
				self.max = self.max + 1
				p = self.max
			else
				while(self[p] and self[p]~=0)do
					p = p + 1
				end
			end
			self.n = self.n + 1
			self[p] = obj
			return p
		end,
		
		remove = function(self,index)
			self[index] = 0
			if self.n<=self.max then
				while(self[self.max]==0)do
					self.max = self.max - 1
				end
			end
			self.n = self.n - 1
		end,
	}
	local eClass_index_tab = eClass.index_tab	-- 写法略扭曲，请勿介意（效率）
	eClass.index_tab.insert_m = function(self,key,obj)
		if self[key]==nil then
			self[key] = eClass_index_tab.new()					--  eClass.index_tab.new()
		end
		return eClass_index_tab.insert(self[key],obj)			-- eClass.index_tab.insert(self[key],obj)
	end
	eClass.index_tab.remove_m = function(self,key,index)
		if self[key] then
			return eClass_index_tab.remove(self[key],index)		-- eClass.index_tab.remove(self[key],index)
		end
	end
	-------------------------------------------------------------
	--@允许以eClass(param)的方式生成类
	setmetatable(eClass,{
		__call = function(self,...)
			return self.new(self,...)
		end,
	})
end