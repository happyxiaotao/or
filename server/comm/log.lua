local _M = {
	__date = "2019-04-30",
}

local LOG = ngx.log
local STDERR	= ngx.STDERR
local DEBUG 	= ngx.DEBUG
local EMERG 	= ngx.EMERG
local ALERT 	= ngx.ALERT
local CRIT 		= ngx.CRIT
local WARN		= ngx.WARN
local NOTICE 	= ngx.NOTICE
local INFO 		= ngx.info
local DEBUG		= ngx.debug

function _M.DEBUG(...)
	LOG(ngx.DEBUG, ...)
end

