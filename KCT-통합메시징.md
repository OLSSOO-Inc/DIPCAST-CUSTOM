# DIPCAST - CUSTOM

KCT 통합 메시징 설치
***


### Debian 12에 KCT-NIMP-AGENT v2.0a 설치하기
> ```
> wget --inet4-only https://raw.githubusercontent.com/OLSSOO-Inc/DIPCAST-CUSTOM/master/resources/scripts/kct_nimp_agent_installer.sh
> chmod +x kct_nimp_agent_installer.sh
> ./kct_nimp_agent_installer.sh
> ```

### Debian 12에 KCT-NIMP-AGENT v2.2a 설치하기
>
> ```
> wget --inet4-only https://raw.githubusercontent.com/OLSSOO-Inc/DIPCAST-CUSTOM/master/resources/scripts/kct_nimp_agent_v2.2a_installer.sh
> chmod +x kct_nimp_agent_v2.2a_installer.sh
> ./kct_nimp_agent_v2.2a_installer.sh
> ```



### Debian 12에 KCT-CPA-AGENT 설치하기 (전국대표번호 MO전용) SMS, MMS
> ```
> wget --inet4-only https://raw.githubusercontent.com/OLSSOO-Inc/DIPCAST-CUSTOM/master/resources/scripts/kct_cpa_agent_installer.sh
> chmod +x kct_cpa_agent_installer.sh
> ./kct_cpa_agent_installer.sh
> ```

### CPA (MCPA, SCPA) DB 생성
> ```
> rm -rf kct-cpa-init.sql
> wget --inet4-only https://raw.githubusercontent.com/OLSSOO-Inc/DIPCAST-CUSTOM/master/resources/config/kct-cpa-init.sql
> mysql -udcrm -pdcrm5K1! dcrm < kct-cpa-init.sql
> ```