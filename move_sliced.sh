#!/usr/bin/env bash
# 下载文件路径
downloadPath=$1
# 种子路径
torrentPath=$2
# 种子文件名称
torrentName=$(basename $torrentPath .torrent)
# 最终保存目录
outputPath="/root/output/"
# 切片目录
m3u8Path="/root/m3u8/"
# 目录名称
folderName=${downloadPath##*/}
# 移动到最终保存目录
mv $downloadPath $outputPath$folderName
# 改目录名
mv $outputPath$folderName $outputPath$torrentName
# 移动种子到目录
mv $torrentPath $outputPath$torrentName
# 取文件列表
fileList=`ls $outputPath$torrentName`
for file in $fileList
do
    # 取扩展名
    extension=${file##*.}
    # 创建切片目录
    mkdir $m3u8Path$torrentName
    echo 'nook' > $m3u8Path$torrentName/index.html
    if [ "$extension" = "mp4" ]; then
        # 切片
        nohup ffmpeg -i $outputPath$torrentName/$file -c:v libx264 -c:a aac -strict -2 -f hls -hls_list_size 0 -hls_time 20 $m3u8Path$torrentName/$torrentName.m3u8 && echo 'ok' > $m3u8Path$torrentName/index.html && rm -rf $outputPath$torrentName &
    fi
done