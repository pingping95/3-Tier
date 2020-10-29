# Overview

AWS 서비스와 IAM에 대해 어느정도 학습을 한 상태이며 좀 더 AWS에 대한 폭 넓게 이해하기 위해 Nginx-Tomcat-RDS 3-Tier를 구현해보고자 합니다.

# 목적

- AWS 상에서 고가용성 3-Tier를 구현한다.
    - 2개의 가용 영역을 구현함으로써 고가용성 인프라 구현
    - Nginx - Tomcat - RDS
    - 정적인 Content는 Web Server가 처리하고 동적인 Content는 Tomcat이 처리한다.
    - 최적의 성능을 이끌어내기 위해 Nginx, Tomcat 서버의 설정 값들을 Customizing한다.
    - 다양한 Traffic에 유연하게 대응하기 위해 Auto-Scaling 기능을 구현한다.

# Architecture
