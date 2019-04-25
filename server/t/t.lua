local say = ngx.say


local weixin_test = require("t.weixin.test")

local res, err = weixin_test:start_test()
if not res then
	say("\nweixin test error, err: " .. err .. "\n")
	return
else
	say("\nweixin test success!\n")
end



