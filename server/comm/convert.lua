--[[
	负责将table转化为
		xml、
		json、
	等格式
]]

local log = ngx.log
local ERR = ngx.ERR
local insert = table.insert
local concat = table.concat
local type = type

local _M = {
	__date = "2019-01-12"
}

local function errlog(...)
	log(ERR, "Convert: ", ...)
end

local json = require("cjson.safe")

function _M.get_data(self, opts, fmt)
	
	if self == nil or opts == nil or fmt == nil then
		errlog("invalid params")
		return nil, "invalid params"
	end
	
	if fmt == "xml" then
		return self.get_xml(opts)
	elseif fmt == "json" then
		return self.get_json(opts)
	else
		errlog("unknown fmt")
		return nil, "unknown fmt"
	end
end

function _M.get_xml(opts)
	if self == nil or opts == nil then
		errlog("invalid params")
		return nil, "invalid params"
	end
	
	local result = "<?xml version=\""..opts.xml_version.."\" encoding=\""..opts.xml_encoding.."\"?>"
	result = result.."<"..opts.tag..">"
	if opts.item then
		if opts.tag == "wlh_query_kick_user" then
			if opts.item == "" then
				result = result.."<item></item>"
			else
				result = result.."<item>"..opts.item.."</item>"
			end
		else 
			result = result.."<item "..opts.item.." />"
		end
	end
	result = result.."<ret "..opts.ret.." />"
	result = result.."</"..opts.tag..">"
end

function _M.get_json(opts)
	return cjson.encode(opts)
end


function _M.tb_to_xml_table(tb, new_tb)
	for k, v in pairs(tb) do
		if type(v) == "table" then
			insert(new_tb, "<")
			insert(new_tb, k)
			insert(new_tb, ">")
			_M.tb_to_xml_table(v, new_tb)
			insert(new_tb, "</")
			insert(new_tb, key)
			insert(new_tb, ">")
		else
			insert(new_tb, "<")
			insert(new_tb, key)
			insert(new_tb, ">")
			insert(new_tb, value)
			insert(new_tb, "</")
			insert(new_tb, key)
			insert(new_tb, ">")
		end
	end
end

-- table转化为xml字符串
function _M.tb_to_xml_str(version, charset, tb)
	local new_tb = {}
	insert(new_tb, 1, "<?xml version=\"" .. version .. "\" encoding=\"" .. charset .. "\" ?>")
	tb_to_xml_table(tb, new_tb)
	return concat(new_tb)
end

return _M
