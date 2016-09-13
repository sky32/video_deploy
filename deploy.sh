#!/usr/bin/env bash
# update apt-get source
wget -q https://www.ubuntulinux.jp/ubuntu-ja-archive-keyring.gpg -O- | sudo apt-key add -
wget -q https://www.ubuntulinux.jp/ubuntu-jp-ppa-keyring.gpg -O- | sudo apt-key add -
sudo wget https://www.ubuntulinux.jp/sources.list.d/trusty.list -O /etc/apt/sources.list.d/ubuntu-ja.list
sudo apt-get update
# install bt soft
apt-get install -y rTorrent
sudo apt-get install -y software-properties-common python-software-properties
# install ffmpeg
sudo add-apt-repository -y ppa:kirillshkrogalev/ffmpeg-next
sudo apt-get update
sudo apt-get install -y ffmpeg
sudo apt-get install nginx php5-fpm
sed -i -e '54,64 s/#//' /etc/nginx/sites-available/default
sed -i -e '59 s/fastcgi_pass/# fastcgi_pass/' /etc/nginx/sites-available/default
sed -i -e '25 s/index.*/index index.php;/' /etc/nginx/sites-available/default
/etc/init.d/php-fpm start
/etc/init.d/nginx start
