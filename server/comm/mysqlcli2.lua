
local mysql = require("resty.mysql")
local log = ngx.log
local ERR = ngx.ERR
local setmetatable = setmetatable

local _M = {
	__date = "2019-01-12",
}

local mt = { __index = _M }

local function errlog(...)
	log(ERR, "Mysql: ", ...)
end

function _M.new(opts)
	local opts = opts or {}
	local conf = {
		conn_conf = opts.conn_conf or {		-- 主库的连接
			host = "127.0.0.1",
			port = 3306,
			database = "test",
			user = "root",
			password = "",
		},
		-- conn_conf_slave = opts.conn_conf_slave or {},	-- 从库的连接
		conn_conf_slave = opts.conn_conf_slave,	-- 从库的连接

		timeout = opts.timeout or 1000;
--		charset = opts.charset or "utf8",
		max_packet_size = opts.max_packet_size or 1024*1024,
		max_idle_time = opts.max_idle_time or 60000,
		pool_size = opts.pool_size or 100
	}
	
	return setmetatable({conf = conf}, mt)
end

function _M.connect(self)
		
	if not self or not self.conf then
		errlog("mysql or mysql_conf parse error!, please check") 
		return nil, "mysql or mysql_conf parse error!, please check"
	end

	local conf = self.conf

	local db, err = mysql:new()
	if not db then
		errlog("failed to instantiate mysql: ", err)
		return nil, err
	end
	
	db:set_timeout(conf.timeout)
	
	for k, v in pairs(conf.conn_conf) do
		errlog("--k = ", k, " -- v = ", v)
	end
	local ok, err, errno, sqlstate = db:connect(conf.conn_conf)
	if not ok then
		errlog("failed to connect, host: ", conf.conn_conf.host, " port: ", conf.conn_conf.port, " user: ", conf.conn_conf.user, " password: ", conf.conn_conf.password, " err : ", err, ": ", errno, " ", sqlstate)
		-- 添加切换到从库的操作
		ok, err, errno, sqlstate = db:connect(conf.conn_conf_slave)
		if ok then
			errlog("failed to connect slave , host: ", conf.conn_conf_slave.host, " port: ", conf.conn_conf_slave.port)
		else
			errlog("failed to connect, host: ", conf.conn_conf.host, " port: ", conf.conn_conf.port, " user: ", conf.conn_conf.user, " password: ", conf.conn_conf.password, " err : ", err, ": ", errno, " ", sqlstate)
			return nil, err
		end
	end
	
	-- 日志：打印连接在最大时间内的重用次数
	errlog("connected to mysql, reused_times: ", db:get_reused_times(), " sql: ", sql)

	db:query("set names utf8")

	return true, nil
end

function _M.query(self, sql)

	if not self or not self.conf then
		errlog("mysql or mysql_conf parse error!, please check") 
		return nil, "mysql or mysql_conf parse error!, please check"
	end
	
	if not sql then
		errlog("sql parse error! please check")
		return nil, "sql parse error! please check"
	end
	
	local conf = self.conf

	local db, err = mysql:new()
	if not db then
		errlog("failed to instantiate mysql: ", err)
		return nil, err
	end
	
	db:set_timeout(conf.timeout)
	
	for k, v in pairs(conf.conn_conf) do
		errlog("--k = ", k, " -- v = ", v)
	end
	local ok, err, errno, sqlstate = db:connect(conf.conn_conf)
	if not ok then
		errlog("failed to connect, host: ", conf.conn_conf.host, " port: ", conf.conn_conf.port, " user: ", conf.conn_conf.user, " password: ", conf.conn_conf.password, " err : ", err, ": ", errno, " ", sqlstate)
		-- 添加切换到从库的操作
		ok, err, errno, sqlstate = db:connect(conf.conn_conf_slave)
		if ok then
			errlog("failed to connect slave , host: ", conf.conn_conf_slave.host, " port: ", conf.conn_conf_slave.port)
		else
			errlog("failed to connect, host: ", conf.conn_conf.host, " port: ", conf.conn_conf.port, " user: ", conf.conn_conf.user, " password: ", conf.conn_conf.password, " err : ", err, ": ", errno, " ", sqlstate)
			return nil, err
		end
	end
	
	-- 日志：打印连接在最大时间内的重用次数
	errlog("connected to mysql, reused_times: ", db:get_reused_times(), " sql: ", sql)

	db:query("set names utf8")
	
	local res, err, errno, sqlstate = db:query(sql)
	if not res then
		errlog("bad result: ", err, ": ", errno, ": ", sqlstate, ".")
	end
	
	errlog(" conf.max_idle_time = ", conf.max_idle_time, " conf.pool_size = ", conf.pool_size)
	local ok, err = db:set_keepalive(conf.max_idle_time, conf.pool_size)
	-- local ok, err = db:close()
	if not ok then
		errlog("failed to set keepalive: ", err)
	end
	
	return res, err, errno, sqlstate
end

return _M
