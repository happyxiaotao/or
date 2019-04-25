--[[	mysql��������	]]--
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

	mysql_reg_tb = "userinfo",				-- ����ע���û���Ϣ
	mysql_sms_tb = "smslog",				--	���������Ϣ
	mysql_udid_tb = "verify_wl_udid",	 	-- �����û���udid��ϵ(��ʱ�˺�����)
	mysql_selfstock_tb = "selfstock",		-- �����û���ѡ����Ϣ

	conn_conf_slave = {					-- ��Ӵӿ���������
		-- host = "10.0.38.104",
		host = "127.0.0.1",
		port = 3306,
		database = "userinfo",
		password = "10jqka",
	}
}

--[[	redis��������	]]--
local redis_conf = {
	conn_conf = {
		host = "127.0.0.1",
		port = 6379,
	},
	timeout = 1000,
	max_packet_size = 1024 * 1024,
	max_idle_time = 60000,
	pool_size = 100,

	redis_user_index = 1,			-- ��½���޳�����洢λ��
	redis_selfstock_index = 2,		-- ��ѡ�ɴ洢λ��
	redis_zdfb_index = 3,			-- �����ǵ��ֲ���Ӧ��λ��
	redis_lock_key = "redis:lock",	-- redis�е���
}

--[[	config����	]]--
local config = {

	-- mysql����
	mysql_conf = mysql_conf,						-- ����mysql����

	-- redis����
	redis_conf = redis_conf,					

	-- �ǵ��ֲ�ģ����ӵ�ʣ�ಿ������
	hushen_holiday_str = "20190101;20190204-20190210;20190405-20190407;20190501;20190607-20190609;20190913-20190915;20191001-20191007;",	-- ���ڣ������ж��Ƿ��ǽ�����
	zdfb_hushen = 'zdfb:hushen',		-- �洢�ǵ��ֲ�����(json��ʽ)
	zdfb_hushen_oldszxd = 'zdfb:hushen_oldszxd',	-- �洢���Խ����յ������Ǻ����µ�(json��ʽ)
	hx_uri = 'http://10.0.11.7:1080',	-- �����ǵ��ֲ���uri
	hx_method = 'POST',					-- post
	hx_path = '/hexin',
	-- hx_body = 'method=quote&codelist=17(),32()&datetime=0(0-0)&datatype=199112,10,69,70',
	hx_body = 'method=quote&codelist=17(),32(),33()&datetime=0(0-0)&datatype=199112,10,69,70',	-- �ǵ�������Ʊ���롢��ͣ����ͣ

	-- �����������ݿ�(�����ж��ŵ�)����
	--Config['db_conn_type'] = 1,			--0���ޣ�1��SQL Server��2��Oracle
	db_conn_servername = "ga",           --��������
	db_conn_username = "phoneuser",      --�û���
	db_conn_password = "phoneuser123",   --����
	db_conn_name = "db_customsms",       --���ݿ���
	
	-- ��������ע������
	sms_sx_content = "gshx",		--����ָ��
	
	is_reg2ths = 1,			--�Ƿ�ͬ��˳��֤����ע�᣻1�ǣ�0��
					-- ��ѡ��ͬ��˳��֤����ע���ǣ���Ҫ����������Ϣ
					-- �������ͬ��˳��������Ҫ��wap��������"ip"��"mask"֪ͨͬ��˳������Ա������ip������
	is_within = 0,			--�Ƿ���ͬ��˳������1�ǣ�0��				
	qsid = "13",				--ȯ��ID��Ĭ����ͬ��˳��qsidΪ800
	--wap_version = "W50",			--������֤���Ľӿ�wl_thsregʱ��Ҫ�����version�������������ѯ�컱��
	src = 2,				--��ʶע����Դ��2��wap
	user_prefix = "Cczq_",		--���ֻ�������Ϊ�û�������֤����ע��ʱ�Ƿ�Ҫ����ǰ׺������ zjyd_��Ϊ�վͲ���ǰ׺
	sms_prefix = "cczq",                 --һ��ע�����ǰ׺
	
	pass_type = 1,	--���ע��ʱ�û����ύ���룬��ô��Ҫ�Զ����û�����һ�����롣
			--1.�����ֻ��ż����һ���̶���4λ���ֵ�����
			--2.����������롣�����޸��Զ��庯�� getRandPwd �޸��㷨��
	is_return_pwd = 0,	--����wapҳ��ע��ʱ��ע��ɹ����Ƿ���ҳ����������룻1�ǣ�0��
	submit_clew = "��л��ʹ��ͬ��˳�ֻ����ɷ��������ڴ�Լ5�������յ����Ÿ�֪���ĵ�¼�û��������롣",	-- ��Config['is_return_pwd']!=1��ҳ���ύע���չ����ҳ���ϵ���ʾ����
	is_send_msg	 = 1,	--ע��ɹ��Ƿ��Ͷ��ţ�0��������1����
	send_msg = "ע��ɹ��������û�����%s��������%s��",	-- ��ע��ɹ��󣬷��͵��û��ֻ��ϵ���ʾ����
	cell_mode = "[1][3,4,5,7,8]%d%d%d%d%d%d%d%d%d",	-- ��֤�ֻ������ʽ��������ʽ
	
	verify_code_valid_time = "60",		-- �ֻ���֤����Чʱ��
	
	is_need_valid_time = 0,				-- ��¼��֤ʱ�Ƿ���Ҫ��֤ע��ļ�¼��Чʱ��
	valid_time = 60,						-- ��λ��
	
	-- ע���û���̨��ѯ����
	admin_name = "admin",	-- ��¼�û���
	admin_pwd = "hexin10jqka",	-- ��¼����
	
	
}

return config;
