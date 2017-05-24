#!/bin/bash
cd /home/ism/app
#Parse raw files to MySQL
sudo python3 prs_reptStatSccp.pyc &
sudo python3 prs_pdbInfo.pyc &
sudo python3 prs_reptStatIptps.pyc &
sudo python3 prs_rtrvCardIpsg.pyc &
sudo python3 prs_rtrvStp.pyc &
wait
#
#Build Reports
sudo python3 mod_rtrvStp.pyc &
sudo python3 mod_reptStatSccp.pyc &
sudo python3 mod_pdbInfo.pyc &
sudo python3 mod_reptStatIptpsDiff.pyc &
sudo python3 mod_rtrvCardIpsg.pyc &
sudo python3 mod_reptStatIptpsDay.pyc &
wait
sudo python3 mod_htmlMain.pyc
sudo python3 mod_reptStatIptps.pyc &
wait
#
#Put HTML files together
sudo python3 mod_htmlMain.pyc
#rsync html/png files from Builder to Webserver (keep exact copy on WebServer)
sudo chown -R www-data:www-data /var/www/ism
#rsync --delete -rogz /var/www/ism/html/* $User_WebServer@$IP_WebServer:/var/www/ism/html --exclude /var/www/ism/html/data.dat --exclude /var/www/ism/html/cPwd.pyc --exclude /var/www/ism/html/sysStat.html
#ssh $User_WebServer@$IP_WebServer "sudo chown -R www-data:www-data /var/www/ism"
#
echo
echo 'Done!'
