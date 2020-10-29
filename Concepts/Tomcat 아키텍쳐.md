# Tomcat에 대한 이해

# 목표

- 3-Tier 구축하기 전에 Tomcat의 구성과 아키텍쳐에 대해 먼저 알아보고자 한다.

# Apache Tomcat Versions

- Apache_Tomcat 10은 Alpha 버젼이므로 9버전이 좋아 보인다.
- Apache Tomcat 9 버젼
    - Servlet : 4.0
    - JSP : 2.3
    - EL : 3.0
    - WebSocket : 1.1
    - Authentication : 1.1
    - Supported Java Version : 8 버젼 이상
![Untitled](https://user-images.githubusercontent.com/67780144/97522289-c72f4800-19e2-11eb-8af6-e1b4b09a0411.png)

# Tomcat Architecture

## 아키텍쳐 #1

- Tomcat Instance의 Key Component는 Catalina Servlet Engine이다.
- Server, Service, Engine, Host, Context는 Container의 일종 (server.xml 에서 설정 가능)
- " + 문자 " 는 여러 개로 구성될 수 있음을 의미한다.
![Untitled_Diagram_(2)](https://user-images.githubusercontent.com/67780144/97522301-cc8c9280-19e2-11eb-9965-6375479d3a7e.png)

- Server (Instance)
    - Tomcat Instance (JVM Process 필수)
- Service
    - 컴포넌트에 대한 중재자 역할
    - 여러 개의 Service를 JVM Instance가 가질 수 있으며, 각각의 Service는 독립적임
- Connector
    - Request, Response를 Handling하는 클래스
    - Connector 종류
        - HTTP : 8080 Port (Default : enabled)
        - HTTPS : 8443 Port (Default : disabled)
        - AJP (Apache Jserv Protocol)
            - Apache를 통해 mod_jk를 통해 입력 받는 커넥터
            - 8009 Port, (Default : enabled)
- Engine (Catalina)
    - 특정 서비스를 위한 요청 처리 파이프 라인
    - 하나의 Service는 여러 개의 Connector를 가질 수 있으며, Engine은 이러한 Connector들로부터 모든 요청을 수신하고 처리함 (Receive, Handle)
- Host
    - Catalina <Engine>의 Instance에 1개의 Virtual Host가 정의되는데, 이를 정의해주는 것이 <Host>이다.
    - Host Container는 여러 개의 Context를 가질 수 있다.
- Context
    - Web Application을 나타내며, 하나의 Host는 n개의 Context를 가질 수 있음

## 아키텍쳐 #2

![Untitled 1](https://user-images.githubusercontent.com/67780144/97522293-c8607500-19e2-11eb-90b4-825d807901a1.png)

# Tomcat Structure

## Servlet Flow Chart
![Untitled 2](https://user-images.githubusercontent.com/67780144/97522295-c8f90b80-19e2-11eb-9d7a-bd1d940e3964.png)

## 톰갯 컴포넌트

### Server

- Server = Catalina Servlet Cntainer = Tomcat Instance
- JVM 안에 Singletom으로 존재하며 Tomcat Server 내에 포함되는 Service들의 생명 주기 관리

### Context

![Untitled_Diagram_(3)](https://user-images.githubusercontent.com/67780144/97522302-cd252900-19e2-11eb-9106-98726b790833.png)

- Web Application을 나타내는 구성요소
    - Listeners

        : Tomcat Life_cycle 이벤트 발생 시 행위 (Action)을 수행하는 컴포넌트

    - Manager : HTTP 세션을 생성, 관리해주는 Session Manager

        세션을 Memory나 File이나 Database에 보관한다. (보통 Memory에 권장)
        ![Untitled 3](https://user-images.githubusercontent.com/67780144/97522296-c991a200-19e2-11eb-8410-a82a1cfca6bb.png)

 - Value : 컨테이너(Engine, Host, Context)와 관련된 각각의 Request 처리 파이프 라인 (Value Chain 객체)안에 들어가 있는 컴포넌트
![Untitled 4](https://user-images.githubusercontent.com/67780144/97522297-ca2a3880-19e2-11eb-87b0-02bc65effc79.png)


## Tomcat 핵심 단위 Module
![Untitled 5](https://user-images.githubusercontent.com/67780144/97522299-cb5b6580-19e2-11eb-9bbd-4f138b812581.png)

- **Catalina** : Servlet Container

    ⇒ Java EE Container, Servlet-JSP Processing

- **Coyote** : HTTP 1.1 Protocol Web Server

    ⇒ Web Browser와 WAS 간의 HTTP 통신 담당, Request ~ Response

- **Jasper** : JSP Engine

    ⇒ JSP를 실행하고 해석함

- **Cluster** : Load-Balancing, Session-Clustering


# Tomcat Engine 디렉터리 구조

- bin : 바이너리 명렁어 파일들을 모아놓은 디렉터리
- conf : Tomcat Web 서비스를 위한 설정 파일 디렉터리
- lib : 외부 라이브러리 디렉터리 (.jar)
- log : 로그 파일 디렉터리
- temp : 임시 파일 디렉터리
- webapps : 웹 어플리케이션 배포 디렉터리
- work : jsp 파일이 Servlet으로 Compile된 디렉터리 (.class)

## Concept

- Tomcat Engine은 CATALINA_HOME 기준으로 lib, bin만 사용
- 실제 서비스 담당 인스턴스들은 conf, logs, temp, webapps, work 디렉터리 사용
- [startup.sh](http://startup.sh) 쉘 스크립트를 실행하면 실제로 [catalina.sh](http://catalina.sh) 가 실행된다.
- catalina.sh나 catalina.bat는 <CATALINA_HOME> ENV를 통해서 Tomcat Engine 디렉터리를 통해 기동한다.

# DB와의 연동

- 크게 ODBC Pool과 JDBC Pool 2가지 중 하나를 이용한다.

## JDBC Connection Pool 접속 방법

### 설정 값

- DB와의 연결을 위해 JDBC Driver에 기입해주어야 한다.
    - Username
    - Password
    - URL : DB Endpoint
    - driverclassname : JDBC 드라이버의 FQDN
    - connectionProperties : DB 연결을 위해 JDBC에 전달되는 Properties

# Tomcat 최적화 Tuning

- 가정
    - n대의 Tomcat을 이용하여 L7 계층에서의 REST API 서비스를 제공
    - Front 단에는 L4 스위치로 부하 분산을 시킴
    - 서비스는 Stateless → 상태 저장 X

## Server.xml

- Listener
- Connector
    - protocol
    - acceptCount
    - enableLookups
    - compression
    - maxConnection
    - maxKeepAliveRequest
    - maxThread
    - tcpNoDelay

## JVM Tuning

- Xms, Xmx
- OutOfMemory
- GC

# Monitoring

- 대상 항목
    - CPU Usage
    - Memory Usage
    - Disk Usage
    - Thread Status
    - Heap Memory Init, Max
    - JDBC URL, Connections
    - OutOfMemoryError
    - ...
- Open Source 모니터링 Tool
    - Scouter

- Reference

[https://12bme.tistory.com/457](https://12bme.tistory.com/457)

[https://bcho.tistory.com/788](https://bcho.tistory.com/788)