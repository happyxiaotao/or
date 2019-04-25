--[[
	filename：		utils.lua
	description:	提供一些基础方法
	date:			2019-01-12
]]

local rematch = ngx.re.match	-- 后续考虑使用ngx.re中的正则表达代替lua中的正则表达
local type = type
local pairs = pairs
local mrandom = math.random
local sub = string.sub
local gsub = string.gsub
local insert = table.insert
local concat = table.concat
local gmatch = string.gmatch
local find = string.find

local _M = {
	__date = "2019-01-12"
}

--[[	table相关	]]--
-- 判断tb是否是数组
function _M.table_is_array(tb)
	if type(tb) ~= "table" then
		return false
	end
	local i = 0
	for _ in pairs(tb) do
		i = i + 1
		if t[i] == nil then
			return false
		end
	end
	return true
end

-- 将哈希表b中的值拷贝给a
function _M.mixin(a, b)
	if a and b then
		for k, v in pairs(b) do
			a[k] = b[k]
		end
	end
	return a
end

-- 判断哈希表是否包含key
function _M.contains_key(tb, key)
	if not tb then
		return false
	end
	for k, _ in pairs(tb) do
		if key == k then
			return true
		end
	end
	return false
end

-- 判断哈希表是否包含value
function _M.contains_value(tb, value)
	if not table then
		return false
	end
	for _, v in pairs(tb) do
		if v == value then
			return true
		end
	end
	return false
end

-- 判断哈希表是否匹配key
function _M.key_matched(tb, key)
	if not tb then
		return false
	end
	for k, _ in pairs(tb) do
		if rematch(key, k, "o") then
			return true
		end
	end
	return false
end

-- 判断哈希表是否匹value
function _M.value_matched(tb, value)
	if not tb then
		return false
	end
	for _, v in pairs(tb) do
		if rematch(value, v, "o") then
			return true
		end
	end
	return false
end

--[[	字符串相关	]]--

-- 去掉字符串两边空白
function _M.trim(str)
	if str == nil then
		return nil
	end
	return gsub(str, "^%s*(.-)%s*$", "%1")
end

-- 字符串替换
function _M.replace(src, dst, str)
	return gsub(str, src, dst)
end

-- 字符串分割 "1:2:3:4:"形式
function _M.explode(str, delimiter)
	if str == nil or str == "" or delimiter == nil then
		return nil
	end
	local res = {}
	for match in gmatch(str, "(.-)"..delimiter) do
		insert(res, match)
	end
	return res
end

-- 捕获所有模式串（支持一次捕获一个模式串，返回一个数组）
function _M.get_mod_str_one(str, mod)
	if str == nil or str == "" or mod == nil then
		return nil
	end
	local res = {}
	gsub(str, mod, function (capture1) insert(res, capture) end)
	return res	
end

-- 捕获所有模式串（支持一次捕获两个模式串，以数组形式插入res中）
function _M.get_mod_str_two(str, mod)
	if str == nil or str == "" or mod == nil then
		return nil
	end
	local res = {}
	gsub(str, mod, function (capture1, capture2) insert(res, {capture1, capture2}) end)
	return res
end

-- 返回子串第一次出现的位置
function _M.strpos(str, substr)
	if str == nil or substr == nil then
		return nil
	end
	
	return find(str, substr)
end

--[[	数字相关	]]--
-- 获取[1000, 9999]之间的随机数
function _M.random()
	return mrandom(1000, 9999)
end


return _M
