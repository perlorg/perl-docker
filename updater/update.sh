#!/bin/sh
if [ -e /ntppool/.git ]; then
  cd /ntppool;
  git pull --rebase
else
  git clone https://github.com/abh/ntppool.git /ntppool/
fi
