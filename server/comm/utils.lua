--[[
	filename��		utils.lua
	description:	�ṩһЩ��������
	date:			2019-01-12
]]

local rematch = ngx.re.match	-- ��������ʹ��ngx.re�е����������lua�е�������
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

--[[	table���	]]--
-- �ж�tb�Ƿ�������
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

-- ����ϣ��b�е�ֵ������a
function _M.mixin(a, b)
	if a and b then
		for k, v in pairs(b) do
			a[k] = b[k]
		end
	end
	return a
end

-- �жϹ�ϣ���Ƿ����key
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

-- �жϹ�ϣ���Ƿ����value
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

-- �жϹ�ϣ���Ƿ�ƥ��key
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

-- �жϹ�ϣ���Ƿ�ƥvalue
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

--[[	�ַ������	]]--

-- ȥ���ַ������߿հ�
function _M.trim(str)
	if str == nil then
		return nil
	end
	return gsub(str, "^%s*(.-)%s*$", "%1")
end

-- �ַ����滻
function _M.replace(src, dst, str)
	return gsub(str, src, dst)
end

-- �ַ����ָ� "1:2:3:4:"��ʽ
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

-- ��������ģʽ����֧��һ�β���һ��ģʽ��������һ�����飩
function _M.get_mod_str_one(str, mod)
	if str == nil or str == "" or mod == nil then
		return nil
	end
	local res = {}
	gsub(str, mod, function (capture1) insert(res, capture) end)
	return res	
end

-- ��������ģʽ����֧��һ�β�������ģʽ������������ʽ����res�У�
function _M.get_mod_str_two(str, mod)
	if str == nil or str == "" or mod == nil then
		return nil
	end
	local res = {}
	gsub(str, mod, function (capture1, capture2) insert(res, {capture1, capture2}) end)
	return res
end

-- �����Ӵ���һ�γ��ֵ�λ��
function _M.strpos(str, substr)
	if str == nil or substr == nil then
		return nil
	end
	
	return find(str, substr)
end

--[[	�������	]]--
-- ��ȡ[1000, 9999]֮��������
function _M.random()
	return mrandom(1000, 9999)
end


return _M
