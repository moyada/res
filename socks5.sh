#!/usr/bin/env bash

Green="\033[32m"
Red="\033[31m"
Blue="\033[36m"
Font="\033[0m"
RedBG="\033[41;37m"
OK="${Green}[OK]${Font}"
ERROR="${Red}[ERROR]${Font}"

function print_ok() {
  echo -e "${OK} ${Blue} $1 ${Font}"
}

function print_error() {
  echo -e "${ERROR} ${RedBG} $1 ${Font}"
}

function port_exist_check() {
  if [[ 0 -eq $(lsof -i:"$1" | grep -i -c "listen") ]]; then
    print_ok "$1 端口未被占用"
  else
    print_error "检测到 $1 端口被占用，以下为 $1 端口占用信息"
    lsof -i:"$1"
    exit 1
#    print_error "5s 后将尝试自动 kill 占用进程"
#    sleep 5
#    lsof -i:"$1" | awk '{print $2}' | grep -v "PID" | xargs kill -9
#    print_ok "kill 完成"
#    sleep 1
  fi
}

function download_socks5() {
  wget -O socks5 https://raw.githubusercontent.com/moyada/res/master/socks5
  chmod +x socks5
}

function kill_old_socks5() {
  if [ -f "s5.pid" ];then
    print_ok "停止socks5客户端"
    kill `cat s5.pid`
    rm -f "s5.pid"
  fi
}

function run_socks5() {
  print_ok "创建socks5客户端"
  nohup ./socks5 -u "$1" -p "$2" -P "$3" >> out.log 2>&1 &
  echo $! > s5.pid
}

menu() {
  read -rp "请输入用户名(默认：guest)：" USER
  [ -z "$USER" ] && USER="guest"

  read -rp "请输入密码(默认：Qa@112233)：" PASS
  [ -z "$PASS" ] && PASS="Qa@112233"

  read -rp "请输入端口号(默认：1443)：" PORT
  [ -z "$PORT" ] && PORT="1443"

  if [[ $PORT -le 1000 ]] || [[ $PORT -gt 65535 ]]; then
    print_error "请输入 1000-65535 之间的值"
    exit 1
  fi

  kill_old_socks5
  port_exist_check $PORT
  download_socks5
  run_socks5 $USER $PASS $PORT
}

menu "$@"
