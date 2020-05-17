#!/bin/bash
# Screen shot tool, screenshots the area, uploades file to the apache web server 
# and copies picture link to the clipboard. Dependencies: gnome-screenshot, xclip 
# This tool is made to work with SSH keys

fileName=`date '+%Y-%m-%d-%H-%M-%S'` # 2020-05-15-17-01-46
fileName="${fileName}.png" # 2020-05-15-17-01-46.png

# server ip + : + directories to the upload directory for images
server="34.89.235.189:/var/www/html/i"
# if you have a domain to cover the ip put it here
domain="http://sebbaindustries.com"
# if there are any directories between ip's folder and upload directory add them here
uploadFolder="/i/"

# screenshot and save the file
gnome-screenshot -a --file=$fileName
#copy uploaded file link
echo -n "${domain}${uploadFolder}${fileName}" | xclip -selection clipboard
# upload to the server
scp $fileName $server
# create a popup telling user that screen is ready
notify-send "Uploaded screenshot to the server"