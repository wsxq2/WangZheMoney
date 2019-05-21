--王者荣耀刷金币脚本
--环境：雷电模拟器Android5.1：1280*720（平板模式）
--by wsxq2

--TODO：
--[x] 随机化mSleep的时间
--[x] 随机化点击的位置（只要在某个区域内就可以）,使用了randomsTap函数
--[x] 第73行，第7天签到领取皮肤碎片时需要点击立即使用
--[x] （可选）get_money函数，注意识别“下次吧”，而非以出现“确认”为判断循环结束的条件
--[x] 战令系统
--[x] send_money存在问题
--[x] （可选）点击小妲己领取奖励
--[x] 添加qq登录环节
--[x] 关闭直播时出现错误
--[x] get_money时出现卡死现象
--[ ] 登录时出现断开连接
--[ ] 登录QQ时要求输入验证码（需要人工操作）
--[ ] 登录到游戏大厅后弹出直播提示或者其它新内容

require("TSLib")
require("WangZheMoney-master/pass")

start_time=30*1000
enter_time=60*1000

--init(0)
--mSleep(5000)

function login_wangzhe() --登录王者荣耀（进入主界面）
	local index,ret
	--点击王者荣耀
--	os.execute("input tap 138 218")
--	click1dot5s(138,218)

	if 0~=runApp("com.tencent.tmgp.sgame") then
		dialog("启动王者荣耀失败，程序退出")
	end
	mSleep(start_time)


	index = addTSOcrDictEx({
"0c0000cfffc01bffff877ffffdc0c00ff838003e07001fe7fffffcfffff1dffffc18300003860000001e3ffc07c7ff83f8fff1fb1ffefc6300df0c601b818c034031806006300c00c6018338e0707f1ffe07f3ff803e7fe000c000@0$shi$360$27$27",
		})
	while (true) do
		--查找"开始游戏"是否出现
		ret = tsOcrText(index,606,543,635,572, "EED9BD , 112643", 90)
		nLog("期望识别到‘始’: "..ret)
		if(ret=="shi") then --如果出现
			break
		end

		ret = tsOcrText(addTSOcrDictEx({
"1860076d81cdb071b78e36f8e6db1edb23db6067ec6ffd8cffb1f9b63e36c7c6ffdcdffb9b60636c0c0d818180@0$deng$196$19$19",
					}), 784,425,806,449, "5AB7AE , 5B2227", 90)
		if(ret=="deng") then --说明有无响应提示
			click1dot5s(805,438)
		end

		--判断是否出现登录提示
		ret = tsOcrText(addTSOcrDictEx({
"0ff807ff83fff1fffe7807bc01ff003f800fe001f800fe00ff807f781f9e07e7fffcffff07fd80fc0$Q$185$18$18",
					}), 747,584,769,609, "E5DED2 , 1B222E", 90)

		if ret=="Q" then
			click2s(779,594)
			mSleep(15000)
			click2s(460,300)
			os.execute("input text "..pass)
			click2s(638,392)
			mSleep(15000)
		end

		--判断是否有更新公告
		ret = tsOcrText(addTSOcrDictEx({
"000000080180000700f00003e07e0001fc3fc000ff9ff8007ff7ff003ffcffe01ffe1ffc0fff03ffc7ff807ff3ffc00fffffc001fffff0003ffff00007fffc0000fffe00001fff000007ffc00003fff00001ffff0000ffffe0007ffffc003fffff001ffefff00fff1ffe07ff03ffc3ffc07ff1ffe00ffffff001ffcff8003fe3fc0007f03c0000f80f00001c000000020$x$585$34$34",
					}), 1147,61,1190,100, "D7DDE4 , 332C26", 90)
		nLog("期望识别到‘x’: "..ret)
		if (ret=="x") then --说明有更新公告，关闭
			click1dot5s(1167,80)
		else --说明有过场动画，跳过
			click(1167,80,10,500)
--			os.execute("input tap 1167 80")
--			mSleep(500)
			ret = tsOcrText(addTSOcrDictEx({
						"00005fcffbf80361006c3ff9fce33f086000003c3861ce0c00017fffeffff000003fffe7fffe000040cc0cf0c1800c2$tiao$170$19$20",
						}), 1184, 12, 1225, 40, "D2D8DF , 2E2721", 90)
			nLog("期望识别‘跳’: "..ret)
			if (ret=="tiao") then
				--点击跳过
				click2s(1225,31)
				nLog("点击跳过完成")
			end
		end
		mSleep(2000)
	end
	--点击开始游戏
	click1dot5s(637,560)
--	os.execute("input tap 637 560")
	mSleep(enter_time)

	--判断是否需要签到
	ret = tsOcrText(addTSOcrDictEx({
				"0080001980071831e1837c183f1d81f1f877839f1e1fc071f0031c0008004000043ffc43ffc42000420017e3ff7e7ff7a7ff420034200043ffc43ffc40000$ling$203$20$25",
				}),  982,610,1020,651, "F5F3EF , 0A0D10", 90)
	if (ret=="ling") then --领取签到奖励
		click1dot5s(1016,629) --点击领取
		click1dot5s(748,532) --点击立即使用
		click_ack()
	end

	--判断是否进入主界面
	while (not is_main_page()) do

		--判断是否存在直播提示
		ret = tsOcrText(addTSOcrDictEx({
"0000fff00000003ffff8000007ffffe000007f001fc0000fe0003f0000fc00007e000f800000f000f8000003c00f8000000f00700000003c0780000000e0781c0003878381f0003e1c3c0fc003f071c03f003f038e00fc03f01c6003f03f0067000fc3f003b8003f3f001dc000fff000ee0003ff000370000ff0001b80007f0000dc0003fc0006e0003ff000770003ffc003b8003f3f001ec003f0fc00c7003f03f00e3803f00fc071e03f003f038703f000fc383c1f0003e1c0e070000e1c0381000021e01e0000001e0078000001e001e000001f0007c00001f0001f80003e00007f000fe00000ffc7fe000001ffffc0000003fff800000001f80000@0$x0$641$45$45",
					}), 1074,42,1136,102, "9B928F , 646E70", 90)
		nLog("识别到的内容(期望x0): "..ret)
		if (ret=="x0") then
			click1dot5s(1106,75) --关闭直播提示
		else
			click1dot5s(1150,80) --关闭其它广告
		end
		mSleep(math.random(2500,3000))
	end
end

function exit_wangzhe() --退出王者荣耀
	--按下返回键
	os.execute("input keyevent KEYCODE_BACK")
	os.execute("input keyevent KEYCODE_BACK")
	mSleep(1000)
	--按下返回键
	click1dot5s(751,506)

end

function maoxian_money()
	local index,ret
	local t1=os.time()
	--点击冒险之旅
	click1dot5s(1000,527)
	--点击冒险模式
	click1dot5s(769,407)
	--点击最高：堕落的祸源
	click1dot5s(630,358)
	--点击下一步
	click1dot5s(1000,610)

	while (true) do
		--点击闯关
		click1dot5s(952,582)
		--		os.execute("input tap 952 582")
		--等待一段时间
		mSleep(10*1000)
		index = addTSOcrDictEx({
				"00005fcffbf80361006c3ff9fce33f086000003c3861ce0c00017fffeffff000003fffe7fffe000040cc0cf0c1800c2$tiao$170$19$20",
			})
		while (true) do
			ret = tsOcrText(index, 1184, 12, 1225, 40, "D2D8DF , 2E2721", 90)
			nLog("闯关开始识别到的内容（期望‘跳’）:"..ret)
			if (ret=="tiao") then
				--点击跳过
				click2s(1225,31)
				nLog("点击跳过完成")
				break
			end
			mSleep(2000)
		end

		----点击自动
		--	os.execute("input tap 1180 34")
		--	mSleep(1000)
		mSleep(2.4*60*1000)
		index = addTSOcrDictEx({
				"000000000101ff901ff901ff80183801818018190181901819ff818ff818ff81831818318193181931818318183183831ff831ff131fe13000130000$dian$169$20$24",
			})
		while (true) do
			ret=tsOcrText(index, 553, 627, 584, 658, "E9F0F6 , 1E1712", 90)
			nLog("闯关结束识别到的内容（期望‘点’）: "..ret)
			if (ret=="dian") then
				click3s(640,360)
				break
			end
			mSleep(2000)
		end

		-- 超过1小时就退出
		if os.time()-t1>3600 then
			--dialog("金币已刷1小时，脚本退出")
			break
		end

		--判断获得的金币是否为0
		ret = tsOcrText(addTSOcrDictEx({
					"01fffffc001ffffffc01fffffffc07fffffff83ffffffff1ffffffffc7ffffffffbffffffffeffc0001ffbfc00001fffe000003fff800000fffe000003fffc00000ffff000007fbff00007fe7ffffffff9ffffffffe7ffffffff0ffffffffc1fffffffe03fffffff007ffffff0007fffff00$0$642$38$24",
					}), 1000,370,1058,434, "E3D2B0 , 1D2E50", 90)
		if (ret=="0") then
			--dialog("获得的金币为0，脚本退出")
			break
		end
		ret=tsOcrText(addTSOcrDictEx({
					"0001818003030006063ffffc7ffff8fffff30c606618c0cc318198630330c606ffbc0ffff81ffff0339c606218c0cc318198630f30c61e618c3cfffff9fffff3fffe6000c0c0018@000$zai$283$23$25",
					}), 1025,647, 1058,678, "E4E0D8 , 1B2028", 90)
		nLog("闯关结束识别到的内容（期望‘再’）: "..ret)
		if (ret=="zai") then
			--点击再次挑战
			click3s(1080,663)
		else
			dialog("未出现期待的‘再’，脚本退出")
			lua_exit()
		end
		mSleep(math.random(1500,2500))
	end
	click3s(898,659)
	mSleep(4000)
	click_back()
end

function is_main_page()
	return "lv"==tsOcrText(addTSOcrDictEx({
				"000003c6000fa1ffffe07ffff07fffe03f38002f860009e1fffa187ffe861fffc18000401800000fffff8f7fffafdfffebe75ff8f9c0070e7783839dfce0e77fc039c3f80e707f039c79e0e67c1c3b9e028404006$lv$353$26$26",
				}), 1030,507,1060,535, "B7BDCC , 413E32", 90)
end

function click(x,y,r,t)
	--	randomsTap(x,y,r)
	randomTap(x,y,r)
	mSleep(math.random(t-500,t+500))
end
function click1dot5s(x,y)
	click2s(x,y)
end
function click2s(x,y)
	click(x,y,10,2000)
end
function click3s(x,y)
	click(x,y,10,4000)
end
function click_ack() --点击确定
	click2s(640,531) --点击确定
end

function has_ack()
	local ret = tsOcrText(addTSOcrDictEx({
				"000c000e0700038ffff0fffffc3fffff0fd800c3870070e1fffc387ffe0e0000703001f81ffffc0ffffe1ffffc0f98c703e631c071ffff8c7fffe33ffff8fe31c03f8c718fe31c73bffffc0ffffe03ffff@10$que$384$26$25",
				}), 608,515,639,550, "6EC2C1 , 6F2D3A", 80)
	return ret=="que"
end
function has_ack2()
	return multiColor({
			{  926,  193, 0x142135},
			{  856,  186, 0x5199db},
			{  487,  218, 0x487db1},
			{  372,  192, 0x142135},
			},90)
end
function click_back()
	click2s(75,35) --点击返回
end

function swipe(x1,y1,x2,y2)
	deta=math.random(-50,50)
	os.execute("input swipe "..(x1+deta).." "..(y1+deta).." "..(x2+deta).." "..(y2+deta))
end
function swipe3s()
	swipe(700,450,700,250)	
	mSleep(math.random(3000,4000))

end
function get_mingwen() --获取铭文
	if has_redpoint(300,663) then --如果铭文右上角有小红点
		click3s(264,671) --点击铭文
		if has_redpoint(122,319) then --如果碎片获取上有小红点
			click2s(58,350) --点击碎片获取
			click1dot5s(835,627) --点击免费买一次
			click1dot5s(835,627)
			mSleep(4000)
			click_ack() --点击确定
		end
		click_back() --点击返回（返回主界面）
	end
end

function get_xiangou() --获取限购奖励
	click3s(1236,157) --点击商城
	if has_redpoint(122,553) then
		click3s(64,586) --点击特惠
		click2s(396,82) --点击限购
		click2s(314,337) --点击免费
		click2s(638,543) --点击免费购买
		click2s(740,531) --点击立即使用
		click_ack() --点击确定
	end
	if has_redpoint(122,395) then
		click3s(65,427) --点击星元
		click3s(1153,273) --点击许愿屋
		click2s(485,355) --点击第一个免费
		click_ack()
		click_back()
	end

	click_back() --点击返回（返回主界面）
end

function qiandao() -- 每日签到
	if has_redpoint(1252,652) then
		click3s(1223,676) --点击妲己
		click2s(212,678) --点击我的战场
		if not isColor(1070,113,0x878889) then --如果不是灰色则点击
			click2s(1082,118) --点击每日签到
			click_ack() --点击确定
		end
		click_back()
	end
end

function meirirenwu() --领取每日任务奖励
	if has_redpoint(1252,652) then
		click3s(1223,676) --点击妲己
		click2s(633,678) --点击每日任务
		while(true) do
			-- 判断当前页面是否有可以领取的奖励
			x, y = tsFindText(addTSOcrDictEx({
						"030000318c078c30f0618f3f0e7cf9f8f0ffc1c7c7033808180018ffc6cffe367063330079f9ff8fdff87e7fe3300799e18ccffe363ff1@1$ling$227$21$21",
						}), "ling", 1022,68,1238,642, "E5DED2 , 1B222E", 80)
			if x~=-1 and y~=-1 then
				click2s(x+24,y+8)
				if has_ack2() then
					--					nLog("qiandao: has_ack2")
					click_ack()
				end
			else
				break
			end
		end
		click_back() --点击返回
	end
end

function query_money() -- 查询周金币上限
	mSleep(3000)
	click3s(1220,671)
	click2s(1055,33)
end

function get_money() --领取好友赠送的金币
	click3s(1050,27) --点击邮件图标

	click2s(54,116) --点击好友邮件
	ret = tsOcrText(addTSOcrDictEx({
				"0ff0007f80000001fffffffffffffffc380000c307181830c0c7860679ffff8ffff87fff83fffe0303781818e0ffc387fe1c3ff0700181800c0@00$kuai$239$21$22",
				}), 1116, 650, 1142, 680, "6FB6A7 , 703A54", 90)
	if ret=="kuai" then 
		click3s(1165,664) --点击快速领取
		while (true) do
			ret = tsOcrText(addTSOcrDictEx({
						"c00000e00000e00000e00000e00000e00000e00000e00000e00000e00000ffffffffffffffffffffffffe00000e1c000e0e000e0e000e0f000e07000e07800e07800e03c00e03c00e00000$xia$190$24$25",
						}), 483,490,515,522, "6EC2C1 , 6F2D3A", 90)
			--				dialog("识别到的内容:"..ret)
			if ret=="xia" then
				click2s(524,507) --点击下次吧
			else
				break
			end
		end
		mSleep(2000)
		if has_ack2() then
			nLog("get_money: has_ack2")
			click_ack()
		end
		--		if multiColor({
		--				{ 1080,  102, 0x1e3553},
		--				{ 1074,  111, 0xfcffff},
		--				{ 1051,   86, 0xc8dcdc},
		--				},90) then
		----			toast("ret==x")
		--			click2s(1064,98)
		--		end
	end

	click_back()
end

function get_xitong() --领取系统邮件中的奖励
	click3s(1050,27) --点击邮件图标
	click2s(60,190) --点击系统邮件
	local ret = tsOcrText(addTSOcrDictEx({
				"032000710c0f0871f4c18f3e1e7cfbf8f1fdc1c7c703380a180051ffc68ffe646007330071fbff0fdff8667fe2300391ffcc8ffe347fe1@1$ling$226$21$21",
				}), 1166,652,1190,677, "E5DCC8 , 1B2337", 90)
	if ret=="ling" then 
		click3s(1165,664) --点击快速领取
		mSleep(2000)
		while has_ack2() do
			click_ack()
		end
	end
	click_back()
end

function send_money()
	click3s(903,35) --点击好友图标
	click1dot5s(66,194) --点击游戏好友
	if isColor(1211,188,0xf7e7ad) then
		local i,y1new,xlast,ylast,count=0,124,0,0,0
		local x,y,x1,y1,x2,y2
		while(i<10) do
			-- 判断当前页面是否有可以赠送金币的好友（没有则向下滑动）
			x, y = tsFindText(addTSOcrDictEx({
						"003e00007ff0007fff003fffe01ffffc0f83c703c061e0e01c7878431f1e30e3cf0c38f3c30e3cf0c3803e30e7878e39e1e38c7878601e1f180783cf01e07fe7ff0ffcffc1ff9fe03ff3f001fcfc00001e0000030$send$327$26$26",
						}), "send", 1174,y1new, 1259,621, "E4E0C5 , 1B203B", 90)
			if x==-1 and y==-1 then
				y1new=124
				swipe3s()
			else
				--判断是否7天前登录
				x1,y1,x2,y2= x-14,y-46,x-1,y-16

				ret = tsOcrText(addTSOcrDictEx({
							"c000c000c007c03fc0ffc3fecfe0ff00fc00f000e000$7$68$16$11",
							}), x1,y1,x2,y2, "9DADBE , 665645", 90)
				if ret ~= "7" then
					--				nLog((x+12)..", "..(y+9))
					click2s(x+12,y+9)
					ret = tsOcrText(addTSOcrDictEx({
								"c00000e00000e00000e00000e00000e00000e00000e00000e00000e00000ffffffffffffffffffffffffe00000e1c000e0e000e0e000e0f000e07000e07800e07800e03c00e03c00e00000$xia$190$24$25",
								}), 483,490,515,522, "6EC2C1 , 6F2D3A", 90)
					if ret=="xia" then
						click2s(524,507) --点击下次吧
					end
					i=i+1
				end
				y1new=y+108
				if y1new >= 621 then
					y1new=620
				end
			end
		end
	end
	click_back()
end

function set_wurao(...) --禁止组队邀请（开启勿扰模式）
	click3s(1124,30)
	while (true) do
		--查找“扰”字
		local x, y = tsFindText(addTSOcrDictEx({
					"1860ce183fffffffffffff8e7871cc3c303e1c7f3fff8fff83fffc1fffffffffdffff0033c03c300f0803@10$rao$222$18$19",
					}), "rao", 600,15,650,618, "5A8C9A , 5B4C3C", 90)
		--		dialog("识别到的坐标 	x:"..x.." , y:"..y)
		if (x~=-1 and y~=-1) then
			click1dot5s(x-76,y+8) --开启勿扰模式
			break
		end
		--查找“隐”字（找到则意味着滑到底了）
		local ret = tsOcrText(addTSOcrDictEx({
					"7fff9ffff7fffd0c187ffe1f3f2103f8f6fc7db03b6feedbfdb6c36dbcdf6fb7db3dffc60fef8001e$yin$217$18$18",
					}), 363,511,389,536, "7888AC , 272427", 90)
		--		dialog("识别到的内容:"..ret)
		if ret=="yin" then
			break
		end
		swipe3s()
	end
	click_back()
end
function has_redpoint(x,y) --判断指定位置是否有小红点
	return isColor(x,y,0x941810)
end
function get_huodong() --领取活动奖励
	local x,y
	if has_redpoint(1272,228) then
		click3s(1235,255) --点击活动
		x, y = tsFindText(addTSOcrDictEx({
					"030000318c078c30f0618f3f0e7cf9f8f0ffc1c7c7033808180018ffc6cffe367063330079f9ff8fdff87e7fe3300799e18ccffe363ff1@1$ling$227$21$21",
					}), "ling", 292,81,1210,661, "E5DED2 , 1B222E", 80)
		if x~=-1 and y~=-1 then
			click2s(x+24,y+8)
			if has_ack2() then
				mSleep(2000)
				nLog("get_huodong: has_ack2")
				click_ack()
			end
		end
		while (true) do
			x,y=findMultiColorInRegionFuzzy( 0x971813, "-38|-5|0x122d4c,3|21|0x183052", 95,235,75,360,667)
			--			x, y = findColorInRegionFuzzy(0x991a15, 95, 235,75,360,667)
			nLog("识别到的坐标 	x:"..x.." , y:"..y)
			if x==-1 and y==-1 then
				--				click2s(1074,100)
				nLog("没有找到可领取的活动奖励")
				click2s(1252,120)
				break
			else
				click3s(x-92,y+45)
				x, y = tsFindText(addTSOcrDictEx({
							"030000318c078c30f0618f3f0e7cf9f8f0ffc1c7c7033808180018ffc6cffe367063330079f9ff8fdff87e7fe3300799e18ccffe363ff1@1$ling$227$21$21",
							}), "ling", 292,81,1210,661, "E5DED2 , 1B222E", 80)
				if x~=-1 and y~=-1 then
					click3s(x+24,y+8)
					if has_ack2() then
						nLog("get_huodong: has_ack2")
						click_ack()
					end
				end
			end
			--			mSleep(2000)
		end
	end
end

function get_zhanling()
	if has_redpoint(1268,325) then
		click3s(1237,350) --点击战令

		if has_redpoint(120,164) then
			click2s(68,196) --点击任务
			click3s(816,670) --点击额外经验升级包
			click_ack() --点击确认
			click2s(530,503) --点击不用了
		end

		if has_redpoint(120,86) then
			click2s(68,116) --点击奖励
			x, y = tsFindText(addTSOcrDictEx({
						"030000318c078c30f0618f3f0e7cf9f8f0ffc1c7c7033808180018ffc6cffe367063330079f9ff8fdff87e7fe3300799e18ccffe363ff1@1$ling$227$21$21",
						}), "ling", 250,182,1255,708, "E5DED2 , 1B222E", 70)
			--			dialog("识别到的坐标 	x:"..x.." , y:"..y)

			if x~=-1 and y~=-1 then
				click2s(x+24,y+8) --点击领取
				click_ack() --点击确认
				click2s(522,616) --点击不用了
			end

		end
		click_back()
	end


end

function login_wurao()
	--回主界面
	pressHomeKey()
	mSleep(2000)
	login_wangzhe() --登录王者荣耀
	set_wurao() --设置勿扰模式
end

function other()
	get_mingwen() --获取铭文
	qiandao() --签到
	get_xiangou() --获取限购和星元奖励
	send_money() --赠送好友金币
	get_money() --领取好友赠送的金币
	meirirenwu() --领取每日任务奖励
	get_xitong() --领取系统邮件中的奖励
	get_zhanling() --领取战令奖励
	get_huodong() --领取活动奖励
end


function do_all()
	math.randomseed(tostring(os.time()):reverse():sub(1,6))

	login()
	maoxian_money() --玩冒险模式刷金币
	other()
	query_money()
	mSleep(1200*1000)
	exit_wangzhe()
end 

function test()
	--	get_mingwen()
	--	get_xiangou()
	--	qiandao()
	--	query_money()
	--	send_money()
	--	get_money()
	--	maoxian_money()
	--	get_huodong()
	--	set_wurao()
	--	get_zhanling()
	--	qiandao()
	--	get_huodong() --领取活动奖励
	for i=1,1 do
		--		swipe3s()
		if has_ack2() then 
			nLog("has_ack2")
			click_ack()
		else
			nLog("error")
		end
	end
	--	get_zhanling() --领取战令奖励

end
