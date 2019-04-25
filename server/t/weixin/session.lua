
--[[
提供对话服务

(1)测试基础支持

(2)接受消息

(3)发送消息

(4)用户管理
]]--

local config = require("weixin.config")
local cjson = require("cjson")
local say = ngx.say

local _M = {
	__author = "shijuntao",
	__date = "2019-04-22",
	__readme = [[
		提供对话服 
		
		1,测试基础
		(1)获取access_token
		(2)获取微信服务器IP地址
		
		2,接受消息
		(1)验证消息真实性
		(2)接受普通消息
		(3)接受事件推送
		(4)接受语音识别结果(已关闭)
		
		3,发送消息
		(1)自动回复
		(2)客户接口
		(3)群发接口
		(4)模板消息(业务通知)
		
		4,用户管理
		(1)用户分组管理
		(2)设置用户名备注名
		(3)获取用户基本信息
		(4)获取用户列表
		(5)获取用户地理位置
		]]
}

local function get_http_data(uri, params)
	if not uri or not params then
		return nil, "get_http_data get invalid uri or params"
	end

	local http = require("comm.mod.http")
	local httpc, err = http:new()
	if not httpc then
		return nil, err
	end

	local time_out = 1000
	httpc:set_timeout(time_out)

	local res, err = httpc:request_uri(uri, params)
	if not res then
		httpc:close()
		return nil, err
	end

	httpc:close()
	return res
end

-- 1,(1) 获取access_token
function _M.get_access_token()
	local appid = config['AppID']
	local secret = config['AppSecret']
	if not appid or not secret then
		return nil, "get appid or secret is nil"
	end
	local uri = config['general_domain']
	local method = "GET"
	local path = "/cgi-bin/token"
	local body = "grant_type=client_credential&appid="..appid.."&secret="..secret
	params = {
		method = method,
		path = path .. "?" ..body,
	--	path = path,		-- 使用者中方式调用的话一直报错
	--	body = body,		-- {"errcode":41002,"errmsg":"appid missing hint: [QucVcA06721533]"}
		headers = {
			["User-Agent"] = "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:66.0) Gecko/20100101 Firefox/66.0",
		}
	}

	local res, err = get_http_data(uri, params)
	if not res then
		return nil, err
	elseif res.status ~= 200 then
		err = "http status : " .. res.status
		return nil, err
	end
		
	local tb, err = cjson.decode(res.body)
	if tb['errcode'] and tb['errcode'] ~= 0 then	-- cjson.encode(access_token_tb) = {"errcode":40013,"errmsg":"invalid appid"}
		return nil, res.body
	elseif tb['access_token'] then
		return tb['access_token']
	else
		return nil, "无法解析获取access_token的返回信息"
	end
end


-- 1,(2)获取微信服务器ip地址
function _M.get_callback_ip()
	-- 获取access_token
	local access_token, err = _M.get_access_token()
	if not access_token then
		return nil, err
	end
	
	-- cjson.encode(access_token_tb) = {"access_token":"ACCESS_TOKEN","expires_in":7200}
	local uri = config['general_domain']
	local path = "/cgi-bin/getcallbackip"
	
	local body = "access_token=" .. access_token
	
	local params = {
		uri = uri,
		method = "GET",
		path = path .. "?" .. body
	}
	local url = path .. "?" .. body

	local res, err = get_http_data(uri, params)
	if not res then
		return nil, err
	elseif res.status ~= 200 then
		err = "http status : " .. res.status
		return nil, err
	end

	local tb, err = cjson.decode(res.body)
	if tb['errcode'] then	-- cjson.encode(res.body) = {"errcode":40013,"errmsg":"invalid appid"}
		return nil, res.body
	elseif tb['ip_list'] then
		return tb['ip_list']
	else
		return nil, "无法解析获取服务器ip的返回信息"
	end
end

-- 网络检测
function _M.check_net()
	-- 获取access_token
	local access_token, err = _M.get_access_token()
	if not access_token then
		return nil, err
	end

	local uri = config['general_domain']
	local path = "/cig-bin/callback/check"
	
end
return _M
