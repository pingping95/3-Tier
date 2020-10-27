# 실습 목적

- 서로 다른 VM 호스트 간에 Web - WAS - Database 3-Tier 구현
- mod_JK를 이용하여 Apache와 Tomcat 간에 연동
- JDBC Driver를 이용하여 Tomcat과 MariaDB 간에 연동

# 실습 환경

- Host Machine : Ubuntu 20.04
- Hypervisior : KVM
    - Network : NAT 통신
        - Web Server : 192.168.202.10/24
        - WAS Server : 192.168.202.11/24
        - DB Server : 192.168.202.12/24

# 아키텍쳐

![image](https://user-images.githubusercontent.com/67780144/94366418-0ed86080-0113-11eb-9211-6cd230c89969.png)
- Host의 Web Browser (Chrome)에서 Web Server의 IP Address로 동적인 파일 (.jsp, ..)을 Request하였을 때 WAS Server가 이를 처리하고 Database의 정보를 받아와 최종적으로 Client에게 반환함을 목적으로 합니다.
