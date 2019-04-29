
local say = ngx.say
local sha1 = ngx.sha1_bin
local cjson = require("cjson.safe")

local config = require("weixin.config")
local funcs = require("weixin.funcs")


-- -- 获取GET参数
-- local args = ngx.req.get_uri_args(20)	-- 最多解析20个参数 
-- -- 获取POST参数
-- ngx.req.read_body()
-- local post_args = ngx.req.get_post_args(10)	-- 最多10个参数
-- for k, v in pairs(post_args) do
-- 	args[k] = v
-- end


-- 获取GET参数
local signature = ngx.var.arg_signature	-- 微信加密签名，结合了开发者填写的token参数和请求中timestamp参数、nonce参数
local timestamp = ngx.var.arg_timestamp	-- 时间戳
local nonce = ngx.var.arg_nonce			-- 随机数
local echostr = ngx.var.arg_echostr		-- 随机字符串

--[[
加密校验流程
1,将token、timestamp、nonce三个参数进行字典排序
2,将三个参数字符串拼接成一个字符串进行sha1加密
3,开发者获得加密后的字符串可与signature对比，标识该请求来源于微信
]]

local token = config['token']
if not token then
	return 
end
local tmp_tb = {token, timestamp, nonce}
local tmp_json = cjson.encode(tmp_tb)
tmp_tb = cjson.decode(tmp_json)		-- 此时是按照字典排序
local tmp_str = ""
for _, v in pairs(tmp_tb) do
	tmp_str	= tmp_str .. v
end

if tmp_str ~= signature then
	ngx.eof()
else
	say("1")
end
