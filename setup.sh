#! /bin/sh

mkdir /fan

cp ./daemon.sh /fan/
cp ./fan_control.service /etc/systemd/system/

systemctl enable --now fan_control
