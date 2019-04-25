
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

-- redis������Ĭ������
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
	-- ע��ú�����ʱʹ��redis.new(opts),������redis:new(opts)
]]
function _M.new(opts)		-- self�����û���execʱ�޸�
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
	-- �ú�������ʱ��ʹ��redis:exec(func)����redis.exec(redis, func)�ķ�ʽ
	-- func��һ���������͵Ĳ���������lua֧�ֺ���ʽ��̵��ص�
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

	-- ��־����ӡ���������ʱ���ڵ����ô���
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
���ܣ�redis�ϼ�������
������opts��һ��������redis���ݿ⣬��������ֵ��������������
����ֵ: �ɹ�����true��ʧ�ܷ���false��nil
����ʱ�����жϼ���ʱ�ĵ�ַ�͵�ǰ���ӵĵ�ַ��һ��ʱ�����ش���
]]
function _M:lock(opts)

	if opts == nil then
		errlog("invalid parameter")
		return nil, "invalid parameter"
	end
		

	local db = self.db
	local ok, err = db:set(opts['lock_key'], opts['lock_value'], "nx", "px", opts['lock_time'])		-- set key value nx ����ֵ��nil��ok����

	if not ok or ok == null then
		return false, "failed to lock"
	end

	return true, ""
end

--[[
���ܣ�redis�Ͻ���
������opts��һ�����������ݿ⣬��������ֵ��������������
����ֵ: �ɹ�����true��ʧ�ܷ���false��nil
]]
function _M:unlock(opts)

	if opts == nil then
		return nil, "invalid parameter"
	end

	script = "if redis.call('get', KEYS[1]) == ARGV[1] then return redis.call('del', KEYS[1]) else return 0 end"	-- ʹ�ýű������������ܱ��ֱȼۺ�ɾ������ܶ�ʱ�䣬����ɾ�����˵���
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
ʹ��ʾ����
local redis = require("rediscli")
local red = redis.new({host = "127.0.0.1"})
local res, err = red:eec(
	function(red)
		return red:get("key")
	end
)
]]
