# 打印lua或luajit版本
location /lua-version
{
	default_type text/html;
	content_by_lua '
		if jit then
			ngx.say(\'luajit version:\', jit.version)
		else
			ngx.say(\'lua version:\', _VERSION)
		end
	';
}


# 微信公众号
location = /weixin
{
	default_type text/html;
	content_by_lua_file server/weixin/weixin.lua;
}

# 测试使用
location = /t
{
	default_type text/html;
	content_by_lua_file server/t/t.lua;
}
