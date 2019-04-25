--[[
	微信公众号需要使用的一些配置
]]

local _M = {


	general_domain = "https://api.weixin.qq.com",	--	通用域名，使用该域名将访问官方指定就近的接入点
	disaster_recovery_domain = "https://api2.weixin.qq.com",					--  通用异地容灾域名
	sh_domain = "https://sh.api.weixin.qq.com",			-- 上海域名
	sz_domain = "https://sz.api.weixin.qq.com",			-- 深圳域名
	hk_domain = "https://hk.weixin.qq.com",				-- 香港域名
	


	AppID = "wxe86b6ed68cbb0ddb",			-- 第三方用户唯一凭证
	AppSecret = "afce5868a7cc9f87a7f7f66a00806573",	-- 第三方用户唯一凭证密钥
}

return _M
