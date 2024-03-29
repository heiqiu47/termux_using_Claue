#!/bin/bash

version="Ver2.5"
# hopingmiao=hotmiao

function clewdSettings { 
    clewd_dir=clewd
    # 3. Clewd设置
    echo -e "\033[0;36mhoping：选一个执行喵~\n\033[0m\033[0;33m--------------------------------------\n\033[0m\033[0;33m选项1 查看 config.js 配置文件\n\033[0m\033[0;37m选项2 使用 Vim 编辑 config.js\n\033[0m\033[0;33m选项3 为 Clewd 添加 Cookies\n\033[0m\033[0;37m选项4 修改 Clewd 密码\n\033[0m\033[0;33m选项5 修改 Clewd 端口\n\033[0m\033[0;37m选项6 修改 Cookiecounter\n\033[0m\033[0;33m选项7 修改 rProxy\n\033[0m\033[0;37m选项0 删除现有clewd，下载最新测试修改版clewd\n\033[0m\033[0;33m--------------------------------------\n\033[0m"
    read -n 1 option
    echo
    case $option in 
        1) 
            # 查看 config.js
            cat $clewd_dir/config.js
            ;;
        2)
            # 使用 Vim 编辑 config.js
            vim $clewd_dir/config.js
            ;;
        3) 
            # 添加 Cookies
            echo "hoping：请输入你的cookie文本喵~(回车进行保存，如果全部输入完后按一次ctrl+D即可退出输入):"
            while IFS= read -r line; do
                cookies=$(echo "$line" | grep -E -o '"?sessionKey=[^"]{100,120}AA"?' | tr -d "\"'")
                echo "$cookies"
                if [ -n "$cookies" ]; then
                    echo -p "我猜你的cookies是:\n"
                    echo "$cookies"
                    # Format cookies, one per line with quotes
                    cookies=$(echo "$cookies" | tr ' ' '\n' | sed -e 's/^/"/; s/$/"/g')
                    # Join into array
                    cookie_array=$(echo "$cookies" | tr '\n' ',' | sed 's/,$//')
                    # Update config.js
                    sed -i "/\"CookieArray\"/s/\[/\[$cookie_array\,/" ./$clewd_dir/config.js
                    echo "Cookies成功被添加到config.js文件了喵~"
                else
                    echo "没有找到cookie喵~o(╥﹏╥)o，要不检查一下cookie是不是输错了吧？(如果要退出输入请按Ctrl+D)"
                fi
            done
            echo "cookies成功输入了(*^▽^*)"
            ;;
        4) 
            # 修改 Clewd 密码
            read -p "是否修改密码?(y/n)" choice
            if [ "$choice" == "y" ] || [ "$choice" == "Y" ]; then
                # 读取用户输入的新密码
                read -p "请输入新密码\n（不是你本地部署设密码干哈啊？）:" new_pass

                # 修改密码
                sed -i 's/"ProxyPassword": ".*",/"ProxyPassword": "'$new_pass'",/g' $clewd_dir/config.js

                echo "密码已修改为$new_pass"
            else
                echo "未修改密码"
            fi
            ;; 
        5) 
            # 修改 Clewd 端口
            read -p "是否要修改开放端口?(y/n)" choice
            if [ "$choice" == "y" ] || [ "$choice" == "Y" ]; then
                # 读取用户输入的端口号
                read -p "请输入开放的端口号:" custom_port

                # 更新配置文件的端口号
                sed -i 's/"Port": [0-9]*/"Port": '$custom_port'/g' $clewd_dir/config.js
                echo "端口已修改为$custom_port"
            else
                echo "未修改端口号"
            fi
            ;;
        6)  
            # 修改 Cookiecounter
            echo "切换Cookie的频率, 默认为3(每3次切换), 改为-1进入测试Cookie模式"
            read -p "是否要修改Cookiecounter?(y/n)" choice
            if [ "$choice" == "y" ] || [ "$choice" == "Y" ]; then
                # 读取用户输入Cookiecounter
                read -p "请输入需要设置的数值:" cookiecounter

                # 更新配置文件的Cookiecounter
                sed -i 's/"Cookiecounter": [0-9]*/"Cookiecounter": '$cookiecounter'/g' $clewd_dir/config.js
                echo "Cookiecounter已修改为$cookiecounter"
            else
                echo "未修改Cookiecounter"
            fi
            ;;
        7)  
            # 修改 rProxy
            echo -e "\n1. 官网地址claude.ai\n2. 国内镜像地址finechat.ai\n3. 自定义地址\n0. 不修改"
            read -p "输入选择喵：" choice
            case $choice in 
                1)  
                    sed -i 's/"rProxy": ".*",/"rProxy": "",/g' $clewd_dir/config.js
                    ;; 
                2) 
                    sed -i 's#"rProxy": ".*",#"rProxy": "https://chat.finechat.ai",#g' $clewd_dir/config.js
                    ;; 
                3)
                    # 读取用户输入rProxy
                    read -p "请输入需要设置的数值:" rProxy
                    # 更新配置文件的rProxy
                    sed -i 's#"rProxy": ".*",#"rProxy": "'$rProxy'",#g' $clewd_dir/config.js
                    echo "rProxy已修改为$rProxy"
                    ;; 
                0) 
                    echo "不修改喵~"
                    break ;; 
            esac
            ;;    
        0)
            cd /root
	        rm -rf clewd
            git clone -b test https://github.com/teralomaniac/clewd.git
	        cd clewd
            bash start.sh
	        cd /root
            ;;
        *)
            echo "什么都没有执行喵~"
            ;;
    esac
}

function sillyTavernSettings {
    # 4. SillyTavern设置
	echo -e "\033[0;36mhoping：选一个执行喵~\n\033[0m\033[0;33m--------------------------------------\n\033[0m\033[0;33m选项1 修改酒馆端口\n\033[0m\033[0;37m选项2 保留数据更新酒馆最新版本\n\033[0m\033[0;33m--------------------------------------\n\033[0m"
    read -n 1 option
    echo
    case $option in 
        1)
            read -p "是否要修改开放端口?(y/n)" choice

            if [ "$choice" == "y" ] || [ "$choice" == "Y" ]; then
                # 读取用户输入的端口号
                read -p "请输入开放的端口号:" custom_port
                # 更新配置文件的端口号
                sed -i 's/port: [0-9]*/port: '$custom_port'/g' SillyTavern/config.yaml
                echo "端口已修改为$custom_port"
            else
                echo "未修改端口号"
            fi
            ;;
        2)
            if [ -d "SillyTavern_old" ]; then                                   
                NEW_FOLDER_NAME="SillyTavern_$(date +%Y%m%d)"
                mv SillyTavern_old $NEW_FOLDER_NAME
            fi                                                                
            git clone https://github.com/SillyTavern/SillyTavern.git SillyTavern_new

            if [ ! -d "SillyTavern_new" ]; then
                echo -e "(*꒦ິ⌓꒦ີ)\n\033[0;33m hoping：因为网络波动下载失败了，更换网络再试喵~\n\033[0m"
                exit 5
            fi
        
            cp -r SillyTavern/public/characters/. SillyTavern_new/public/characters/
            cp -r SillyTavern/public/chats/. SillyTavern_new/public/chats/       
            cp -r SillyTavern/public/worlds/. SillyTavern_new/public/worlds/
            cp -r SillyTavern/public/groups/. SillyTavern_new/public/groups/
            cp -r SillyTavern/public/group\ chats/. SillyTavern_new/public/group\ chats/
            cp -r SillyTavern/public/OpenAI\ Settings/. SillyTavern_new/public/OpenAI\ Settings/
            cp -r SillyTavern/public/User\ Avatars/. SillyTavern_new/public/User\ Avatars/
            cp -r SillyTavern/public/backgrounds/. SillyTavern_new/public/backgrounds/
            mv SillyTavern SillyTavern_old                                    
            mv SillyTavern_new SillyTavern

            read -p "是否删除旧版本,请输入Y/N:" para
            case $para in
                [yY])
                    read -p "若要删除请再次确认" queren
                    case $queren in
                        [yY])
                            rm -rf SillyTavern_old
                            echo "hoping:酒馆更新成功了喵~"
                            ;;
                        [nN])
                            echo "保留旧版本"
                            echo "hoping:酒馆更新结束了喵~"
                            ;;
                        *)
                            echo "错误的输入"
                            read -p "已经默认保留旧版本"
                            echo "hoping:酒馆更新结束了喵~"
                            ;;
                    esac
            esac
            ;;
        *)
            echo "什么都没有执行喵~"
            ;;
    esac
}

# 检查是否存在git指令
if command -v git &> /dev/null; then
    echo "git指令存在"
    git --version
else
    echo "git指令不存在，建议回termux下载git喵~"
fi

# 检查是否存在node指令
if command -v node &> /dev/null; then
    echo "node指令存在"
    node --version
else
    echo "node指令不存在，正在尝试重新下载喵~"
    curl -O https://nodejs.org/dist/v20.10.0/node-v20.10.0-linux-arm64.tar.xz
    tar xf node-v20.10.0-linux-arm64.tar.xz
    echo "export PATH=\$PATH:/root/node-v20.10.0-linux-arm64/bin" >>/etc/profile
    source /etc/profile
    if command -v node &> /dev/null; then
        echo "node成功下载"
        node --version                                                
    else
        echo "node下载失败，╮(︶﹏︶)╭，自己尝试手动下载吧"
        exit 1

  fi
fi

if [ ! -d "SillyTavern" ] || [ ! -f "SillyTavern/start.sh" ]; then
    echo "SillyTavern不存在，正在通过git下载..."
	cp -r SillyTavern/public SillyTavern_public_bak
	rm -rf SillyTavern
    git clone https://github.com/SillyTavern/SillyTavern SillyTavern
fi

if [ ! -d "clewd" ]; then
	echo "clewd不存在，正在通过git下载..."
	git clone https://github.com/teralomaniac/clewd
	cd clewd
	bash start.sh
        cd /root
elif [ ! -f "clewd/config.js" ]; then
    cd clewd
    bash start.sh
    cd /root
fi

if [ ! -d "SillyTavern" ] || [ ! -f "SillyTavern/start.sh" ]; then
	echo -e "(*꒦ິ⌓꒦ີ)\n\033[0;33m hoping：因网络波动文件下载失败了，更换网络后再试喵~\n\033[0m"
 	rm -rf SillyTavern
	exit 2
fi

if  [ ! -d "clewd" ] || [ ! -f "clewd/config.js" ]; then
	echo -e "(*꒦ິ⌓꒦ີ)\n\033[0;33m hoping：因网络波动文件下载失败了，更换网络后再试喵~\n\033[0m"
  	rm -rf clewd
	exit 3
fi

# 主菜单
echo "                                              
烧猫一键脚本
作者：hoping喵(烧猫)，水秋喵(苦等hoping喵起床)
版本：$version
来自：Claude2.1先行破限组
群号：704819371，910524479，304690608
类脑Discord(角色卡发布等): https://discord.gg/HWNkueX34q
此程序完全免费，不允许如浅睡一天一夜等人对脚本/教程进行盗用/商用。运行时需要稳定的魔法网络环境。"
while :
do 
    echo -e "\033[0;36mhoping喵~让你选一个执行（输入数字即可），懂了吗？\033[0;38m(｡ì _ í｡)\033[0m\n\033[0m\033[0;33m--------------------------------------\n\033[0m\033[0;31m选项0 退出脚本\n\033[0m\033[0;33m选项1 启动Clewd\n\033[0m\033[0;37m选项2 启动酒馆\n\033[0m\033[0;33m选项3 Clewd设置\n\033[0m\033[0;37m选项4 酒馆配置\n\033[0m\033[0;31m选项5 更新脚本\n\033[0m\033[0;33m--------------------------------------\n\033[0m\033[0;35m不准选其他选项，听到了吗？\n\033[0m\n(⇀‸↼‶)"
    read -n 1 option
    echo 
    case $option in 
        0) 
            break ;; 
        1) 
            #启动Clewd
            port=$(grep -oP '"Port":\s*\K\d+' clewd/config.js)
            echo "端口为$port, 出现 (x)Login in {邮箱} 代表启动成功, 后续出现AI无法应答等报错请检查本窗口喵。"
            cd clewd
            bash start.sh
            echo "Clewd已关闭, 即将返回主菜单"
            cd ../
            ;; 
        2) 
            #启动SillyTavern
            cd SillyTavern
	        bash start.sh
            echo "酒馆已关闭, 即将返回主菜单"
            cd ../
            ;; 
        3) 
            #Clewd设置
            clewdSettings
            ;; 
        4) 
            #SillyTavern设置
            sillyTavernSettings
            ;; 
        5)
            # 更新脚本
            rm -rf sac.sh
            curl -O https://raw.githubusercontent.com/heiqiu47/termux_using_Claue/main/sac.sh
            break ;;
        *) 
            echo -e "m9( ｀д´ )!!!! \n\033[0;36m坏猫猫居然不听话，存心和我hoping喵~过不去是吧？\033[0m\n"
            ;;
    esac
done 
echo "已退出烧猫一键脚本，输入 bash sac.sh 可重新进入脚本喵~"
exit
