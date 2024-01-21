#!/usr/bin/env bash

run() {
  wget -O socks5 https://raw.githubusercontent.com/moyada/res/master/socks5

  if [ -f "s5.pid" ];then
    echo "kill exist socks5"
    kill `cat s5.pid`
    rm -f s5.pid
  fi

  echo "open socks5"
  chmod +x socks5
  nohup ./socks5 >> out.log 2>&1 &
  echo $! > s5.pid
}

run
