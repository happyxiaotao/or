--[[	mysql连接配置	]]--
local mysql_conf = {
	conn_conf = {
		--host = "10.0.38.104",
		host = "127.0.0.1",
		port = 3306,
		database = "userinfo",
		user = "root",
		password = "10jqka",
	},
	charset = "utf8",
	timeout = 100,
	max_packet_size = 1024 * 1024,
	max_idle_time = 6000,
	pool_size = 100,

	mysql_reg_tb = "userinfo",				-- 保存注册用户信息
	mysql_sms_tb = "smslog",				--	保存短信信息
	mysql_udid_tb = "verify_wl_udid",	 	-- 保存用户与udid关系(临时账号生成)
	mysql_selfstock_tb = "selfstock",		-- 保存用户自选股信息

	conn_conf_slave = {					-- 添加从库连接配置
		-- host = "10.0.38.104",
		host = "127.0.0.1",
		port = 3306,
		database = "userinfo",
		password = "10jqka",
	}
}

--[[	redis连接配置	]]--
local redis_conf = {
	conn_conf = {
		host = "127.0.0.1",
		port = 6379,
	},
	timeout = 1000,
	max_packet_size = 1024 * 1024,
	max_idle_time = 60000,
	pool_size = 100,

	redis_user_index = 1,			-- 登陆和剔除缓存存储位置
	redis_selfstock_index = 2,		-- 自选股存储位置
	redis_zdfb_index = 3,			-- 行情涨跌分布对应的位置
	redis_lock_key = "redis:lock",	-- redis中的锁
}

--[[	config配置	]]--
local config = {

	-- mysql配置
	mysql_conf = mysql_conf,						-- 保存mysql配置

	-- redis配置
	redis_conf = redis_conf,					

	-- 涨跌分布模块添加的剩余部分配置
	hushen_holiday_str = "20190101;20190204-20190210;20190405-20190407;20190501;20190607-20190609;20190913-20190915;20191001-20191007;",	-- 假期，用来判断是否是交易日
	zdfb_hushen = 'zdfb:hushen',		-- 存储涨跌分布数据(json格式)
	zdfb_hushen_oldszxd = 'zdfb:hushen_oldszxd',	-- 存储上以交易日的总上涨和总下跌(json格式)
	hx_uri = 'http://10.0.11.7:1080',	-- 请求涨跌分布的uri
	hx_method = 'POST',					-- post
	hx_path = '/hexin',
	-- hx_body = 'method=quote&codelist=17(),32()&datetime=0(0-0)&datatype=199112,10,69,70',
	hx_body = 'method=quote&codelist=17(),32(),33()&datetime=0(0-0)&datatype=199112,10,69,70',	-- 涨跌幅、股票代码、涨停、跌停

	-- 连接需求方数据库(上下行短信等)配置
	--Config['db_conn_type'] = 1,			--0：无，1：SQL Server，2：Oracle
	db_conn_servername = "ga",           --服务器名
	db_conn_username = "phoneuser",      --用户名
	db_conn_password = "phoneuser123",   --密码
	db_conn_name = "db_customsms",       --数据库名
	
	-- 短信上行注册配置
	sms_sx_content = "gshx",		--上行指令
	
	is_reg2ths = 1,			--是否到同花顺认证中心注册；1是，0否
					-- 当选择到同花顺认证中心注册是，需要配置以下信息
					-- 如果不是同花顺内网，需要将wap服务器的"ip"，"mask"通知同花顺技术人员，加入ip白名单
	is_within = 0,			--是否是同花顺内网；1是，0否；				
	qsid = "13",				--券商ID，默认是同花顺，qsid为800
	--wap_version = "W50",			--调用认证中心接口wl_thsreg时需要传入的version参数，具体可咨询朱槐龙
	src = 2,				--标识注册来源：2：wap
	user_prefix = "Cczq_",		--将手机号码作为用户名到认证中心注册时是否要加上前缀；例如 zjyd_，为空就不加前缀
	sms_prefix = "cczq",                 --一键注册短信前缀
	
	pass_type = 1,	--如果注册时用户不提交密码，那么需要自动给用户分配一个密码。
			--1.根据手机号计算出一个固定的4位数字的密码
			--2.随机生成密码。可以修改自定义函数 getRandPwd 修改算法。
	is_return_pwd = 0,	--采用wap页面注册时，注册成功后是否在页面上输出密码；1是，0否
	submit_clew = "感谢您使用同花顺手机炒股服务，您将在大约5分钟内收到短信告知您的登录用户名和密码。",	-- 当Config['is_return_pwd']!=1，页面提交注册后，展现在页面上的提示文字
	is_send_msg	 = 1,	--注册成功是否发送短信：0：不发，1：发
	send_msg = "注册成功，您的用户名是%s，密码是%s。",	-- 当注册成功后，发送到用户手机上的提示文字
	cell_mode = "[1][3,4,5,7,8]%d%d%d%d%d%d%d%d%d",	-- 验证手机号码格式的正则表达式
	
	verify_code_valid_time = "60",		-- 手机验证码有效时间
	
	is_need_valid_time = 0,				-- 登录验证时是否需要验证注册的记录有效时间
	valid_time = 60,						-- 单位秒
	
	-- 注册用户后台查询配置
	admin_name = "admin",	-- 登录用户名
	admin_pwd = "hexin10jqka",	-- 登录密码
	
	
}

return config;
