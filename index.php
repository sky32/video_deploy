<?php
$token = $_GET['token'];
$url   = $_GET['url'];
$file  = $_GET['file'];
if (empty($token) || empty($url) || empty($file)) {
    // echo 'fail';
}
if ($token !== md5($url . $file . "happysky")) {
    // echo 'fail';
}
$url  = 'http://www.mp4ba.com/down.php?date=1473437970&hash=1d3656d3d08db180ec70b50251aaf2e9765b6282';
$file = '1d3656d3d08db180ec70b50251aaf2e9765b6282.torrent';
$ret  = getFile('http://www.mp4ba.com/down.php?date=1473437970&hash=1d3656d3d08db180ec70b50251aaf2e9765b6282', '/root/torrent/', $file);
var_dump($ret);
function getFile($url, $savePath, $fileName)
{
    if (empty($url) || empty($savePath) || empty($fileName)) {
        return false;
    }
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
    curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 3);
    $fileBody = curl_exec($ch);
    curl_close($ch);
    $fp = @fopen($savePath . $fileName, 'w');
    fwrite($fp, $fileBody);
    fclose($fp);
    unset($fileBody, $url);
    return true;
}