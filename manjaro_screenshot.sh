#!/bin/bash

file_location="/home/sebba/Pictures/"
file_name=`date '+%Y-%m-%d-%H-%M-%S'`
file_format='.png'

remote="work@op65n.tech:/var/www/html/i"

domain="https://op65n.tech/i/"

deepin-screenshot --save-path ${file_location}${file_name}${file_format} -n

if [ ! -f ${file_location}${file_name}${file_format} ]; then
  echo "File ${file_location}${file_name}${file_format} not found, terminating!"
  exit
fi

echo -n "${domain}${file_name}${file_format}" | xclip -selection clipboard


scp ${file_location}${file_name}${file_format} $remote

rm ${file_location}${file_name}${file_format}

notify-send "Upload complete :3" -t 2000 -a Screenshot
