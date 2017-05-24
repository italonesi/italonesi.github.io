#!/bin/bash
#
#System variables. User/IP_Address of Collector(s) and Webserver
#User_Collector='ism'
#IP_Collector='192.168.56.10'
#User_WebServer='ism'
#IP_WebServer='192.168.56.50'
#
cd /home/ism/app
#
#Wait for TempFile@Collector to be deleted (token)
#while ssh $User_Collector@$IP_Collector "test -e /home/ism/app/Filename.temp"
#do
   #echo "Please wait for token to be deleted on the Collector side..."
   #sleep 3
#done
#rsync files from Collector(s) to Builder, deleting source files after transfer is completed
#rsync --remove-source-files -az $User_Collector@$IP_Collector:/home/ism/app/getFiles_New/* /home/ism/app/getFiles_New
#
#Parse raw files to MySQL
#python3 prs_reptStatTrbl.pyc &
python3 prs_reptStatSccp.pyc &
python3 prs_pdbInfo.pyc &
python3 prs_reptStatIptps.pyc &
python3 prs_rtrvCardIpsg.pyc &
python3 prs_rtrvStp.pyc &
wait
#
#Build Reports
#python3 mod_reptStatTrbl.pyc &
#python3 mod_reptStatTrblCor.pyc &
python3 mod_rtrvStp.pyc &
python3 mod_reptStatSccp.pyc &
python3 mod_pdbInfo.pyc &
python3 mod_reptStatIptpsDiff.pyc &
python3 mod_rtrvCardIpsg.pyc &
#'mod_reptStatIptpsDay.pyc' must be executed before 'mod_reptStatIptps.pyc' so the daily Occup/Max/Min can be recorded
python3 mod_reptStatIptpsDay.pyc &
wait
python3 mod_htmlMain.pyc
python3 mod_reptStatIptps.pyc &
wait
#
#Put HTML files together
python3 mod_htmlMain.pyc
#rsync html/png files from Builder to Webserver (keep exact copy on WebServer)
sudo chown -R www-data:www-data /var/www/ism
#rsync --delete -rogz /var/www/ism/html/* $User_WebServer@$IP_WebServer:/var/www/ism/html --exclude /var/www/ism/html/data.dat --exclude /var/www/ism/html/cPwd.pyc --exclude /var/www/ism/html/sysStat.html
#ssh $User_WebServer@$IP_WebServer "sudo chown -R www-data:www-data /var/www/ism"
#
echo
echo 'Done!'
