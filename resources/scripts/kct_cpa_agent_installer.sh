#!/bin/bash
# This code is the property of OLSSOO FACTORY LLC Company
# License: Proprietary
# Date: 20250428
# KCT 통합메시징 에이젠트 설치(CPA)
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
echo -e "*   Welcome to the KCT CPA Agent Installation   *"
echo -e "*     Powered by OLSSOO FACTORY, 1668-2471      *"
echo -e "*************************************************"

echo -e "${green}Updating the System...${txtrst}"
apt update
apt install curl zip unzip -y
rm -rf KCT_Agent_ver* /usr/share/kct-nimp-agent /etc/apt/sources.list.d/mariadb.list SCPA* MCPA*

echo -e "${green}Installing the JAVA From SDKMAN...${txtrst}"
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk install java 21.0.7-tem
sdk default java 21.0.7-tem

echo -e "${green}Installing the MariaDB Connector/J ...${txtrst}"
curl -LsS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | sudo bash
apt install libmariadb-java
find / -name mariadb-java-client.jar

mkdir -p /usr/share/kct-cpa-agent

echo -e "${green}Installing KCT CPA AGENTS...${txtrst}"
wget --inet4-only https://raw.githubusercontent.com/OLSSOO-Inc/DIPCAST-CUSTOM/master/kct/cpa-agent/SCPA9_0.9.9.7.tar
tar -xvf SCPA9_0.9.9.7.tar -C /usr/share/kct-cpa-agent/
mv  /usr/share/kct-cpa-agent/SCPA9_0.9.9.7  /usr/share/kct-cpa-agent/SCPA

wget --inet4-only https://raw.githubusercontent.com/OLSSOO-Inc/DIPCAST-CUSTOM/master/kct/cpa-agent/MCPA9_0.9.9.7.tar
tar -xvf MCPA9_0.9.9.7.tar -C /usr/share/kct-cpa-agent/
mv  /usr/share/kct-cpa-agent/MCPA9_0.9.9.7  /usr/share/kct-cpa-agent/MCPA

echo -e "${green}Configuring KCT CPA AGENT...${txtrst}"
filename="kct-cpa-config.txt"
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
				cpaid=$line
			  ;;
			4)
				cpapassword=$line
			  ;;
			5)
				cpadbserverip=$line
			;;
			6)
				cpadbserverid=$line
			;;
			7)
				cpadbpassword=$line
			;;
		esac
		n=$((n+1))
	done < $filename
	echo -e "Server IP............... > $serverip"	
	echo -e "Server Port...............> $serverport"
	echo -e "KCT CPA ID.............. > $cpaid"
	echo -e "KCT CPA PASSWORD........ > $cpapassword"
	echo -e "DB Server IP............. > $cpadbserverip"
	echo -e "DB CPA ID.............. > $cpadbserverid"
	echo -e "DB CPA PASSWORD........ > $cpadbpassword"
fi

while [[ $serverip == '' ]]
do
	read -p "Server IP............... > " serverip 
done 

while [[ $serverport == '' ]]
do
	read -p "Server Port............... > " serverport
done

while [[ $cpaid == '' ]]
do
	read -p "KCT CPA ID.............. > " cpaid
done 

while [[ $cpapassword == '' ]]
do
	read -p "KCT CPA PASSWORD......... > " cpapassword
done

while [[ $cpadbserverip == '' ]]
do
	read -p "DB Server IP......... > " cpadbserverip
done

while [[ $cpadbserverid == '' ]]
do
	read -p "DB CPA ID......... > " cpadbserverid
done

while [[ $cpadbpassword == '' ]]
do
	read -p "DB CPA PASSWORD......... > " cpadbpassword
done


echo -e "************************************************************"
echo -e "*                   Check Information                      *"
echo -e "*        Make sure you have Server and auth infomation     *"
echo -e "************************************************************"
echo -e "1)Server IP:" $serverip
echo -e "2)Server Port:" $serverport
echo -e "3)KCT CPA ID:" $cpaid
echo -e "4)KCT CPA PASSWORD:" $cpapassword
echo -e "5)DB Server IP:" $cpadbserverip
echo -e "6)DB CPA ID:" $cpadbserverid
echo -e "7)DB CPA PASSWORD:" $cpadbpassword
echo -e "************************************************************"
while [[ $cpa_veryfy_info != yes && $cpa_veryfy_info != no ]]
do
	read -p "Are you sure to continue with this settings? (yes,no) > " cpa_veryfy_info 
done

if [ "$cpa_veryfy_info" = yes ] ;then
	echo -e "************************************************************"
	echo -e "*                Starting to run the scripts               *"
	echo -e "************************************************************"
else
		exit;
fi

cat > /usr/share/kct-cpa-agent/SCAP/CPA_SMS.conf << EOF
#######################################################################
#
# SMS CPA º≥¡§∆ƒ¿œ
#
#######################################################################
#VERSION = 0.9.9.5

CPA_HOME = ./
CPA_LOGDIR = ./LOG
CPA_LOGLEVEL = 3
CPA_RECV_PERIOD = 10
SERVER_IP = $serverip	
SERVER_PORT = $serverport
SERVER_ID = $cpaid
SERVER_PASSWD = $cpapassword
SMS_TIMEOUT = 5
LINECHK_TIMEOUT = 60
DB_TYPE	= MYSQL
DB_FLAG = 1
DB_IP = $cpadbserverip
DB_PORT = 3306
DB_USERNAME = $cpadbserverid
DB_PASSWD = $cpadbpassword
DB_NAME	= nimpdb
DB_CHARSET = UTF8
DB_TABLE = kct_sms_rcv
DB_CONN_CHECK = 10

EOF

cat > /usr/share/kct-cpa-agent/MCAP/CPA_MMS.conf << EOF
#######################################################################
#
# MMS CPA º≥¡§∆ƒ¿œ
#
#######################################################################
#VERSION = 0.9.9.5

CPA_HOME = ./
CPA_LOGDIR = ./LOG
CPA_CONTENTDIR = ./MMS_CONTENT
CPA_DISKFREESPACE_LIMITRATIO = 20
CPA_CONT_ONOFF = 0
CPA_LOGLEVEL = 3
CPA_RECV_PERIOD = 10
SERVER_IP = $serverip	
SERVER_PORT = $serverport	
SERVER_ID = $cpaid
SERVER_PASSWD = $cpapassword
LINECHK_TIMEOUT = 10
DB_TYPE	= MYSQL
DB_USERNAME = $cpadbserverid	
DB_PASSWD = $cpadbpassword
DB_CHARSET = UTF8
DB_TABLE = kct_mms_rcv
DB_CONN_CHECK = 10
DB_FLAG = 1
DB_IP = $cpadbserverip
DB_PORT = 3306
DB_NAME	= nimpdb

EOF

echo -e "****************************************************"
echo -e "*          Auto configuration is completed         *"
echo -e "****************************************************"


echo -e "${green}Configuring KCT-SCPA-Agent...${txtrst}"
cat > /etc/systemd/system/kct-scpa-agent.service << EOF
[Unit]
Description=KCT_SCPA_AGENT Powered By OLSSOO FACTORY
Wants=mariadb.service
After=mariadb.service

[Service]
Type=simple
WorkingDirectory=/usr/share/kct-cpa-agent/SCPA/
ExecStart=/root/.sdkman/candidates/java/current/bin/java -Xms32m -Xmx64m -XX:+UseG1GC -XX:MetaspaceSize=32M -XX:MaxMetaspaceSize=64M -Djdk.nio.maxCachedBufferSize=10485760 -jar ./SCPA.jar ./CPA_SMS.conf
SuccessExitStatus=143                    # SIGTERM(기본 중지 신호)으로 종료 시 성공으로 간주
TimeoutStopSec=5                        # 중지 시 대기 시간 (초)
Restart=on-failure
User=root

[Install]
WantedBy=multi-user.target
EOF

echo -e "${green}Starting & Enabling KCT-SCPA-Agent Services...${txtrst}"
sudo systemctl enable kct-scpa-agent
sudo systemctl start kct-scpa-agent


echo -e "${green}Configuring KCT-MCPA-Agent...${txtrst}"
cat > /etc/systemd/system/kct-mcpa-agent.service << EOF
[Unit]
Description=KCT_MCPA_AGENT Powered By OLSSOO FACTORY
Wants=mariadb.service
After=mariadb.service

[Service]
Type=simple
WorkingDirectory=/usr/share/kct-cpa-agent/MCPA/
ExecStart=/root/.sdkman/candidates/java/current/bin/java -Xms32m -Xmx64m -XX:+UseG1GC -XX:MetaspaceSize=32M -XX:MaxMetaspaceSize=64M -Djdk.nio.maxCachedBufferSize=10485760 -jar ./MCPA.jar ./CPA_MMS.conf
SuccessExitStatus=143                    # SIGTERM(기본 중지 신호)으로 종료 시 성공으로 간주
TimeoutStopSec=5                        # 중지 시 대기 시간 (초)
Restart=on-failure
User=root

[Install]
WantedBy=multi-user.target
EOF

echo -e "${green}Starting & Enabling KCT-MCPA-Agent Services...${txtrst}"
sudo systemctl enable kct-mcpa-agent
sudo systemctl start kct-mcpa-agent