#!/bin/bash
# This code is the property of OLSSOO FACTORY LLC Company
# License: Proprietary
# Date: 20250428
# KCT 통합메시징 에이젠트 설치(NIMP)
#
set -e

green="\033[00;32m"
red="\033[0;31m"
txtrst="\033[00;0m"

function jumpto
{
	label=$start
	cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
	eval "$cmd"
	exit
}

echo -e "\n"
echo -e "*************************************************"
echo -e "*  Welcome to the KCT NIMP Agent Installation   *"
echo -e "*                     v2.2a                     *"
echo -e "*     Powered by OLSSOO FACTORY, 1668-2471      *"
echo -e "*************************************************"

echo -e "${green}Checking Database dcrm...${txtrst}"
mysql -u root -e "show database dcrm;"
rm -rf KCT_Agent_ver* /usr/share/kct-nimp-agent /etc/apt/sources.list.d/mariadb.list

echo -e "${green}Updating the System...${txtrst}"
apt update
apt install curl zip unzip -y

echo -e "${green}Installing the JAVA From SDKMAN...${txtrst}"
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk install java 21.0.7-tem
sdk default java 21.0.7-tem

echo -e "${green}Installing the MariaDB Connector/J ...${txtrst}"
curl -LsS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | sudo bash
apt install libmariadb-java
find / -name mariadb-java-client.jar

echo -e "${green}Installing KCT NIMP AGENT...${txtrst}"
wget --inet4-only https://raw.githubusercontent.com/OLSSOO-Inc/DIPCAST-CUSTOM/master/kct/nimp-agent/KCT_Agent_ver2.2a.zip
mkdir -p /usr/share/kct-nimp-agent
unzip KCT_Agent_ver2.2a.zip -d  /usr/share/
mv  /usr/share/KCT_Agent_ver2.2a /usr/share/kct-nimp-agent
chmod +x  /usr/share/kct-nimp-agent/agent.sh

echo -e "${green}Configuring KCT NIMP AGENT v2.2a...${txtrst}"
filename="kct-nimp-config.txt"
if [ -f $filename ]; then
	echo -e "config file"
	n=1
	while read line; do
		case $n in
			1)
				serverip=$line
			  ;;
			2)
				serverport=$line
			  ;;
			3)
				nimpid=$line
			  ;;
			4)
				nimppassword=$line
			  ;;
			5)
				nimppassword=$line
			;;
			6)
				nimppassword=$line
			;;
			7)
				nimppassword=$line
			;;
		esac
		n=$((n+1))
	done < $filename
	echo -e "KCT Server IP............... > $serverip"	
	echo -e "KCT Server Port...............> $serverport"
	echo -e "KCT NIMP ID.............. > $nimpid"
	echo -e "KCT NIMP PASSWORD........ > $nimppassword"
	echo -e "DB Server IP............. > $nimpdbserverip"
	echo -e "DB NIMP ID.............. > $nimpdbserverid"
	echo -e "DB NIMP PASSWORD........ > $nimpdbpassword"
fi

while [[ $serverip == '' ]]
do
	read -p "Server IP............... > " serverip 
done 

while [[ $serverport == '' ]]
do
	read -p "Server Port............... > " serverport
done

while [[ $nimpid == '' ]]
do
	read -p "KCT NIMP ID.............. > " nimpid
done 

while [[ $nimppassword == '' ]]
do
	read -p "KCT NIMP PASSWORD......... > " nimppassword
done

while [[ $nimpdbserverip == '' ]]
do
	read -p "DB Server IP......... > " nimpdbserverip
done

while [[ $nimpdbserverid == '' ]]
do
	read -p "DB NIMP ID......... > " nimpdbserverid
done

while [[ $nimpdbpassword == '' ]]
do
	read -p "DB NIMP PASSWORD......... > " nimpdbpassword
done


echo -e "************************************************************"
echo -e "*                   Check Information                      *"
echo -e "*        Make sure you have Server and auth infomation     *"
echo -e "************************************************************"
echo -e "*                        common.xml                        *"
echo -e "************************************************************"
echo -e "1)Server IP:" $serverip
echo -e "2)Server Port:" $serverport
echo -e "3)KCT NIMP ID:" $nimpid
echo -e "4)KCT NIMP PASSWORD:" $nimppassword
echo -e "************************************************************"
echo -e "*                      db.properties                       *"
echo -e "************************************************************"
echo -e "5)DB Server IP:" $nimpdbserverip
echo -e "6)DB NIMP ID:" $nimpdbserverid
echo -e "7)DB NIMP PASSWORD:" $nimpdbpassword
echo -e "************************************************************"
while [[ $nimp_veryfy_info != yes && $nimp_veryfy_info != no ]]
do
	read -p "Are you sure to continue with this settings? (yes,no) > " nimp_veryfy_info 
done

if [ "$nimp_veryfy_info" = yes ] ;then
	echo -e "************************************************************"
	echo -e "*                Starting to run the scripts               *"
	echo -e "************************************************************"
else
		exit;
fi

cat > /usr/share/kct-nimp-agent/config/common.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE properties SYSTEM "http://java.sun.com/dtd/properties.dtd">
<properties>
	<!-- thread number : 0 ~ 5(Max) -->
	<entry key="nSmsThread">1</entry>
	<entry key="nMmsThread">1</entry>
	<entry key="nRcsThread">1</entry>
	<entry key="nKkoThread">1</entry>
	<!-- report thread is default 1 -->
	
	<entry key="serverIp">$serverip</entry>
	<entry key="serverPort">$serverport</entry>
	<entry key="bindId">$nimpid</entry><!-- 16C -->
	<entry key="bindPw">$nimppassword</entry><!-- 16C -->
	
	<!-- euckr -->
	<entry key="charSet">euckr</entry>
	<entry key="dbCharSet">euckr</entry>
	
	<!-- <entry key="charSet">utf8</entry>
	<entry key="dbCharSet">utf8</entry> -->
	
	<entry key="senderCode"></entry><!-- 10C -->
	<entry key="brand_key"></entry><!-- 10C -->

	<entry key="encrypt">false</entry>
	<entry key="selectListCount">100</entry>	<!-- default, 50   -->
	
	<entry key="logPath">/usr/share/kct-nimp-agent/logs</entry>
	<entry key="logPattern">%d{HH:mm:ss.SSS} [%t] %c %-5p %C{1} [%M :%L] - %m%n</entry>
	<entry key="attachPath">/usr/share/kct-nimp-agent/attach</entry>
	<entry key="moSavePath">/usr/share/kct-nimp-agent/mosave</entry>
	
	<!-- MO Listening -->
	<entry key="modeMo">Y</entry>
	<entry key="moSaveMonth">Y</entry>
	
	<!-- Black List Listening -->
	<entry key="modeBl">false</entry>
	<entry key="blPort">0</entry>

	<entry key="dbPwEncryption">N</entry>
	<entry key="dbTableMove">N</entry>

</properties>

EOF

cat > /usr/share/kct-nimp-agent/config/db.properties << EOF
dbtype=maria
driver=org.mariadb.jdbc.Driver
url=jdbc:mariadb://$nimpdbserverip:3306/dcrm?characterEncoding=utf8
username=$nimpdbserverid
password=$nimpdbpassword
EOF

echo -e "****************************************************"
echo -e "*          Auto configuration is completed         *"
echo -e "****************************************************"


echo -e "${green}Configuring KCT-Nimp-Agent..v2.2a..${txtrst}"
cat > /etc/systemd/system/kct-nimp-agent.service << EOF
[Unit]
Description=KCT_NIMP_AGENT v2.2a Powered By OLSSOO FACTORY
Wants=mariadb.service
After=mariadb.service

[Service]
Type=simple
WorkingDirectory=/usr/share/kct-nimp-agent/
ExecStart=/root/.sdkman/candidates/java/current/bin/java -jar amagent_22a.jar NIMP_AGENT_22a
SuccessExitStatus=143                    # SIGTERM(기본 중지 신호)으로 종료 시 성공으로 간주
TimeoutStopSec=5                        # 중지시 대기 시간 (초)
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

echo -e "${green}Starting & Enabling KCT-Nimp-Agent Services..v2.2a..${txtrst}"
systemctl enable kct-nimp-agent
systemctl start kct-nimp-agent