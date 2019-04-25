--[[
测试对话服务

(1)测试基础支持

(2)接受消息

(3)发送消息

(4)用户管理
]]--


local say = ngx.say
local _M = {
	__date = "2019-04-22"
}

_M['session'] = require("t.weixin.session")

--(1) 测试基础支持
-- 获取access_token
function _M:test_get_access_token()
	return self['session'].get_access_token()
end

-- 获取微信服务器IP地址
function _M:test_get_callback_ip()
	return self['session'].get_callback_ip()
end

function _M:start_test()
	-- 1,测试基础支持
	-- (1)获取access_token
	local res, err = self:test_get_access_token()
	if not res then
		say("测试get_access_token失败, err:"..err)
		return nil, err
	else
		say("测试get_access_token成功")
	end

	res, err = self:test_get_callback_ip()
	if not res then
		say("测试get_callback_ip失败, err:"..err)
		return nil, err
	else
		say("测试get_callback_ip成功")
	end


	return true
end



return _M

