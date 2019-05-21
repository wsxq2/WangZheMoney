# WangZheMoney
王者荣耀刷金币及领取日常奖励脚本。实现完全自动化，包括登录及自动退出。为了防止出现休息提示，默认只刷一小时。刷完后等待用户查看结果，默认等待 30 分钟后自动退出王者荣耀

## 文件说明
```
.
├── do_all.lua* #一键完成
├── login_wurao.lua* #登录王者荣耀并设置为勿扰模式
├── maoxian_money.lua* #通过冒险模式刷金币（需要先登录到大厅）
├── other.lua* #领取其它奖励（如获取铭文）（需要先登录到大厅）
├── README.md* #本文档
├── test.lua* #用于测试的文件
├── pass.lua* #保存你的 QQ 密码的文件
└── wangzhe.lua* #主代码文件
```

## 使用说明
测试平台： 雷电模拟器，`Android5.1`，分辨率设置为`1280*720`

下面详细讲解如何通过雷电模拟器使用该脚本

1. 下载雷电安卓模拟器：<http://www.ldmnq.com>
2. 安装雷电安卓模拟器
1. 设置雷电模拟器。打开安装好的雷电安卓模拟器，点击雷电模拟器右侧边栏的**设置**，将分辨率设置为**平板版**`1280*720`。
2. 安装并设置**触动精灵**。通过**雷电游戏中心**安装触动精灵或通过电脑从官网下载并拖放到模拟器中安装。然后对**触动精灵**进行如下设置：
   
   1. 打开音量键控制。打开**触动精灵**，点击**我的账号**，点击**按键设置**，开启**音量键控制** 并将**音量减**设置为运行脚本
   2. 打开悬浮窗。在触动精灵中点击**我的账号**，开启**悬浮窗按钮**

3. 下载并解压本项目。可通过<https://github.com/wsxq2/WangZheMoney/archive/master.zip>下载，也可以点击当前页面中的`Clone or download`下载。然后使用解压软件解压得到`WangZheMoney-master`文件夹
1. 发送本项目到模拟器。将整个`WangZheMoney-master/`文件夹拖入到已打开的雷电模拟器中
1. 在模拟器中移动本项目。通过模拟器自带文件管理器将`WangZheMoney-master/`文件夹移动到`/sdcard/TouchSprite/lua/`文件夹中。具体步骤如下：

   1. 选中已拖入到雷电模拟器中的`WangZheMoney-master/`文件夹
   2. 到指定文件夹（`/sdcard/TouchSprite/lua`）中点击**选项**，**粘贴选择项**

5. 勾选要启动的脚本。打开模拟器中的**触动精灵**，此时应该能看到之前移动的`WangZheMoney-master/`文件夹，然后勾选里面的`do_all.lua`（也可以选择其它脚本）以准备启动该脚本。
6. 启动脚本。按**音量减**（在模拟器右边的侧边栏中）启动脚本

## 已知的问题及解决方法
如果出现以下问题，则脚本会出现异常：
- 登录时出现断开连接提示。这个问题通常是由主机突然断网导致的
- 登录 QQ 时要求输入验证码（需要人工操作）。这个问题的出现好像是随机的
- 登录到游戏大厅后弹出直播提示或者其它新内容。这个问题在有新活动或 KPL 比赛期间出现

出现以上问题时都需要手动操作，常见的手动操作如下：
* 停止脚本，退出游戏，重新开始执行脚本（按音量减）
* 暂停脚本并手动完成下一步（至于下一步是啥可以参考源代码），然后继续执行脚本。`do_all.lua`脚本的运行流程如下：
  1. 登录到游戏大厅并设置勿扰模式
  1. 开始通过冒险模式刷金币
  1. 做其它领取奖励的活动）
  
* 暂停脚本并切换执行脚本。可切换到如下脚本：
  * `login_wurao.lua`：登录到游戏大厅并设置勿扰模式。不执行后续操作
  * `maoxian_money.lua`：通过冒险模式刷金币。完成后自动返回游戏大厅
  * `other.lua`：做其它领取奖励的事。包括如下内容
  
  	1. 免费获取铭文
  	1. 点击右下角小妲己后的签到
  	1. 获取商城里的限购和星元奖励
  	1. 赠送好友金币
  	1. 领取好友赠送的金币
  	1. 领取每日任务奖励（点击右下角小妲己后可以看到）
  	1. 领取系统邮件中的奖励
  	1. 领取战令奖励
  	1. 领取活动奖励

## 模拟器外自动化
使用本项目的脚本实现了安卓模拟器内的自动化，但是每次都要手动启动模拟器，手动打开触动精灵，手动启动脚本（按音量减）。有没有办法避免这些麻烦的模拟器外的手动行为？答案是肯定的。通过使用 AHK 我们可以轻易的实现上述目标：
```
#NoEnv
#SingleInstance force

CoordMode Mouse,Window

;script control
!Home::Pause
!Esc::ExitApp

has_started(ldname)
{
    ;ToolTip %ldname%,0,0,1
    IfWinExist %ldname%
    {
        WinActivate
        PixelGetColor color1, 67,510,RGB ;左下角
        PixelGetColor color2, 1241, 61,RGB ;时间图标中下面的冒号
        PixelGetColor color3, 639, 608,RGB ;中间部分的小白点
        ;ToolTip %color1%、%color2%、%color3%,50,50,2
        return (!(color1==0x009d14) && color2==0xFFFFFF && color3==0xF5F5F5) ;color1不为蓝色，color2为白色，color3为白色时表示雷电模拟器启动完成
    }
    return false
}
has_enter_TS(ldname)
{
    IfWinExist %ldname%
    {
        WinActivate
        PixelGetColor color1,236,87,RGB ;“触动精灵”的背景
        PixelGetColor color2,526,173,RGB ;“脚本”、“其他”的背景
        PixelGetColor color3,419,723,RGB ;“我的脚本”、“找脚本”、“我的账号”的背景
        return color1==0x141414  && color2==0xF0F0F0 && color3==0xF0F0F0 ;color1为黑色，color2为白色，color3为白色时表示进入了TS
    }
	else MsgBox %ldname%
}

main()
{
    runwait ldconsole.exe globalsetting --fps 30 --audio 1  --fastplay 1,,Hide
    ld_nums:=2 ;模拟器数量
    ld_nameprefix:="ld" ;模拟器名字前缀（结合ld_nums表示ld0, ld1这两个模拟器）
    i:=0
    while (i<ld_nums)
    {
        runwait ldconsole.exe launch --name %ld_nameprefix%%i%,,Hide
        Sleep 5000
        i++
        if not KeepwjRunning
            return
    }
    Sleep % 10*1000
    i=0
    while ( i<ld_nums )
    {
        if(has_started(ld_nameprefix i))
        {
            Sleep 3000
            runwait ldconsole.exe runapp --name %ld_nameprefix%%i% --packagename com.touchsprite.android,,Hide
            i++
        }
        Sleep 2000
        if not KeepwjRunning
            return
    }

    i=0
    while ( i<ld_nums )
    {
        if(has_enter_TS(ld_nameprefix i))
        {
            Sleep 5000
            runwait %comspec% /c ldconsole.exe action --name %ld_nameprefix%%i% --key call.keyboard --value volumedown,,Hide
            i++
        }
        Sleep 2000
        if not KeepwjRunning
            return
    }
    runwait ldconsole.exe sortWnd,,Hide
}

;王者荣耀刷金币
#MaxThreadsPerHotkey 3
~w & j::
    #MaxThreadsPerHotkey 1
    WinGetActiveTitle, WinTitle
    if (WinTitle != ""){
        return
    }
    if KeepwjRunning  ; 这说明一个潜在的 线程 正在下面的循环中运行.
    {
        KeepwjRunning := false  ; 向那个线程的循环发出停止的信号.
        return  ; 结束此线程, 这样才可以让下面的线程恢复并得知上一行所做的更改.
    }
    ; 否则:
    global KeepwjRunning := true
    main()
    ;test()
    KeepwjRunning := false  ; 复位, 为下一次使用热键做准备.
return
```
通过`w+j`启动脚本，通过`Alt+Home`暂停脚本，通过`Alt+Esc`完全停止脚本。启动后再按`w+j`会暂停脚本，再按`w+j`会继续脚本，再按`w+j`会暂停脚本……

## 相关博客
* [Touchsprite脚本笔记](https://wsxq2.55555.io/blog/2018/08/23/TouchSprite%E8%84%9A%E6%9C%AC%E7%AC%94%E8%AE%B0/)
* [Ahk学习笔记](https://wsxq2.55555.io/blog/2019/05/06/ahk%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B0/)
