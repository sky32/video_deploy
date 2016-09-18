#!/usr/bin/env bash
# update apt-get source
wget -q https://www.ubuntulinux.jp/ubuntu-ja-archive-keyring.gpg -O- | apt-key add -
wget -q https://www.ubuntulinux.jp/ubuntu-jp-ppa-keyring.gpg -O- | apt-key add -
wget https://www.ubuntulinux.jp/sources.list.d/trusty.list -O /etc/apt/sources.list.d/ubuntu-ja.list
apt-get update
# install rtorrent nginx php
apt-get install -y rTorrent nginx php5-fpm php5-curl screen
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
# create rtorrent config
cat <<EOF > /root/.rtorrent.rc
min_peers = 400
max_peers = 1000
min_peers_seed = 100
max_peers_seed = 500
max_uploads = 15
download_rate = 0
upload_rate = 0

log.open_file = "rtorrent.log", (cat,/root/log/rtorrent.log.,(system.pid))
log.open_file = "tracker.log", (cat,/root/log/tracker.log.,(system.pid))
log.add_output = "info", "rtorrent.log"
log.add_output = "dht_debug", "tracker.log"
log.add_output = "tracker_debug", "tracker.log"

directory = /root/downloads
session = /root/downloads/.session
schedule = watch_directory,5,5,load_start=/root/torrent/*.torrent
schedule = untied_directory,5,5,stop_untied=
schedule = low_diskspace,5,60,close_low_diskspace=100M
schedule = ratio,60,60,"stop_on_ratio=200,200M,2000"

encryption = allow_incoming,try_outgoing,enable_retry

port_range = 49164-49164
use_udp_trackers = yes
dht = off
peer_exchange = yes
encoding_list = utf-8
system.method.set_key = event.download.finished,move_complete,"execute=/root/move_sliced.sh,$d.get_base_path=,$d.loaded_file=;execute=mv,-u,$d.loaded_file=,/root/output/"
EOF

# create download php
wget https://raw.githubusercontent.com/sky32/video_deploy/master/index.php -P /root/m3u8/ -O index.php
wget https://raw.githubusercontent.com/sky32/video_deploy/master/move_sliced.sh -P /root/ -O move_sliced.sh
chmod +x /root/move_sliced.sh
chmod 755 /root/
chmod 755 /root/m3u8/
chmod 755 /root/torrent/