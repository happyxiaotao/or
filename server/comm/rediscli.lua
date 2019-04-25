
local redis = require("resty.redis")
local log = ngx.log
local ERR = ngx.ERR
local setmetatable = setmetatable

local _M = {
	__date = "2019-01-12"
}

local mt = { __index = _M }

local default_conf = {
	conn_conf = {
		host = "127.0.0.1",
		port = 6379,
	}
	timeout = 0,
	database = 0,
	max_idle_time = 60000,
	pool_size = 100,
}

-- redis中锁的默认配置
local default_lock_conf = {
	
	conn_conf = 
	
	key = "redis_lock_key",
	value = "redis_lock_value",
	time = "50"
	nx = "nx",
	px = "px",
}

local function errlog(...)
	log(ERR, "Redis: ", ...)
end

--[[
	-- 注意该函数参时使用redis.new(opts),而不是redis:new(opts)
]]
function _M.new(opts)		-- self的配置会在exec时修改
	local conf = {
		conn_conf = opts.conn_conf or default_conf.conn_conf
		host = opts.host or "127.0.0.1",
		port = config.port or 6379,
		timeout = config.timeout or 5000,
		database = config.database or 0,
		max_idle_time = config.max_idle_time or 60000,
		pool_size = config.pool_size or 100,
	}
	
	return setmetatable({conf = conf}, mt)
end

--[[
	-- 该函数传参时，使用redis:exec(func)或者redis.exec(redis, func)的方式
	-- func是一个函数类型的参数，利用lua支持函数式编程的特点
]]
function _M:exec(func)
	
	local conf = self.conf
	local red = redis:new()
	red:set_timeout(conf.timeout)
	
	local ok, err = red:connect(conf.host, conf.port)
	if not ok then
		errlog("failed to connect, host: ", conf.host, ", port: ", conf.port, " err :", err)
		return nil, err
	end
	
	red:select(conf.database)

	-- 日志：打印连接在最大时间内的重用次数
	errlog("connected to redis host: ", conf.host, " port: ", conf.port, " reused_times: ", db:get_reused_times())

	local res, err = func(red)
	if res then
		local ok, err = red:set_keepalive(conf.max_idle_time, conf.pool_size)
		if not ok then
			red:close()
		end
	end
	
	return res, err
end



--[[
功能：redis上加锁操作
参数：opts是一个表，包含redis数据库，锁，锁的值，锁的生命周期
返回值: 成功返回true，失败返回false或nil
有锁时，当判断加锁时的地址和当前连接的地址不一样时，返回错误
]]
function _M:lock(opts)

	if opts == nil then
		errlog("invalid parameter")
		return nil, "invalid parameter"
	end
		

	local db = self.db
	local ok, err = db:set(opts['lock_key'], opts['lock_value'], "nx", "px", opts['lock_time'])		-- set key value nx 返回值是nil或ok类型

	if not ok or ok == null then
		return false, "failed to lock"
	end

	return true, ""
end

--[[
功能：redis上解锁
参数：opts是一个表，包含数据库，锁，锁的值，锁的生命周期
返回值: 成功返回true，失败返回false或nil
]]
function _M:unlock(opts)

	if opts == nil then
		return nil, "invalid parameter"
	end

	script = "if redis.call('get', KEYS[1]) == ARGV[1] then return redis.call('del', KEYS[1]) else return 0 end"	-- 使用脚本解锁，尽可能保持比价和删除相隔很短时间，避免删除别人的锁
	local db = self.db
	local ok, err = db:eval(script, 1, opts['lock_key'], opts['lock_value'])

	if not ok or ok == null then
		return false, "failed to unlock"
	end

	return true, ""
end
	


function _M:lock(opts)
	
end

function _M:unlock(opts)
end

return _M

--[[
使用示例：
local redis = require("rediscli")
local red = redis.new({host = "127.0.0.1"})
local res, err = red:eec(
	function(red)
		return red:get("key")
	end
)
]]
