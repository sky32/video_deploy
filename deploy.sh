#!/usr/bin/env bash
# update apt-get source
wget -q https://www.ubuntulinux.jp/ubuntu-ja-archive-keyring.gpg -O- | apt-key add -
wget -q https://www.ubuntulinux.jp/ubuntu-jp-ppa-keyring.gpg -O- | apt-key add -
wget https://www.ubuntulinux.jp/sources.list.d/trusty.list -O /etc/apt/sources.list.d/ubuntu-ja.list
apt-get update
# install rtorrent nginx php
apt-get install -y rTorrent nginx php5-fpm php5-curl screen supervisor
sed -i -e '54,64 s/#//' /etc/nginx/sites-available/default
sed -i -e '59 s/fastcgi_pass/# fastcgi_pass/' /etc/nginx/sites-available/default
sed -i -e '25 s/index.*/index index.php;/' /etc/nginx/sites-available/default
sed -i -e '24 s/root.*/root \/root\/m3u8\/;/' /etc/nginx/sites-available/default
sed -i -e '30a \\t\troot /root/m3u8/;' /etc/nginx/sites-available/default
/etc/init.d/php5-fpm start
/etc/init.d/nginx start
# install add-apt-repository
apt-get install -y software-properties-common python-software-properties
# install ffmpeg
add-apt-repository -y ppa:kirillshkrogalev/ffmpeg-next
apt-get update
apt-get install -y ffmpeg
# create rtorrent folder
mkdir /root/downloads/
mkdir /root/downloads/.session/
mkdir /root/torrent/
mkdir /root/m3u8/
mkdir /root/log/
chmod 755 /root/
chmod 755 /root/m3u8/
chmod 755 /root/torrent/
# create script
wget https://raw.githubusercontent.com/sky32/video_deploy/master/rtorrent.rc -P /root/ -O .rtorrent.rc
wget https://raw.githubusercontent.com/sky32/video_deploy/master/index.php -P /root/m3u8/ -O index.php
wget https://raw.githubusercontent.com/sky32/video_deploy/master/move_sliced.sh -P /root/ -O move_sliced.sh
wget https://raw.githubusercontent.com/sky32/video_deploy/master/rtorrent_supervisor.conf -P /etc/supervisor/conf.d/ -O rtorrent_supervisor.conf
chmod +x /root/move_sliced.sh
supervisord
supervisorctl sratr all