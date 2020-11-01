# 실습 환경

- Host Machine : Ubuntu 18.04
- Hypervisior : KVM
- web
    - OS : CentOS 7
    - vCPU : 2 Core
    - RAM   : 2GB
    - 192.168.100.10/24
- was-01
    - OS : CentOS 7
    - vCPU : 2 Core
    - RAM   : 2GB
    - 192.168.100.20/24
- was-02
    - OS : CentOS 7
    - vCPU : 2 Core
    - RAM   : 2GB
    - 192.168.100.21/24

# Architecture

- Web과 WAS 모두 정적, 동적인 컨텐츠를 처리할 수 있지만 각각의 WEB, WAS는 정적, 동적 컨텐츠를 처리하는데 특화되 있으므로 나누어서 처리하는 것이 권장된다.

![Untitled_Diagram_(4)](https://user-images.githubusercontent.com/67780144/97795158-0ad5bc00-1c46-11eb-8cf4-990070c07f94.png)
