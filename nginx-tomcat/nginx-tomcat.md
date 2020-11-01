# nginx - tomcat

# 순서

- Nginx 설치
- Nginx 로드밸런싱
- openjdk 설치
- Tomcat 설치
- Tomcat의 index.jsp 수정

## Prerequisite

- /etc/hosts

    각 서버에 모두 적용. 맨 아래에 추가해준다.

    ```bash
    192.168.100.10 web.test.local
    192.168.100.20 was-01.test.local
    192.168.100.21 was-02.test.local
    192.168.100.10 redis.test.local
    ```

## Nginx 설치

- Nginx는 Centos 7의 경우 Default 레포지토리에 설치가 안되어있기 때문에 repo를 추가해준 이후에 설치를 진행해줘야 한다.
- Repo 추가

```bash
vi /etc/yum.repos.d/nginx.repo

[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
gpgcheck=0
enabled=1
```

- Nginx 설치

```bash
yum clean all

yum update

yum -y install nginx

systemctl start nginx
```

- Nginx Process 확인

    Nginx는 기본적으로 master process와 worker process 구조로 이루어져 있다.

    master process는 worker process들에 대한 제어를 담당한다.

```bash
root      3265     1  0 12:28 ?        00:00:00 nginx: master process /usr/sbin/nginx -c /etc/nginx/nginx.conf
nginx     3266  3265  0 12:28 ?        00:00:00 nginx: worker process
```

- Nginx 실행 확인

    it is so good은 심심해서 추가해봤음

![Untitled](https://user-images.githubusercontent.com/67780144/97795151-08736200-1c46-11eb-8ca0-70711c4e1b36.png)

- curl로 확인

```bash
[root@web conf.d]# curl -I localhost
HTTP/1.1 301 Moved Permanently
Server: nginx/1.18.0
Date: Sat, 31 Oct 2020 16:27:39 GMT
Content-Type: text/html
Content-Length: 169
Connection: keep-alive
Location: https://web.test.local:443?request_uri
```

- Reload

```bash
systemctl restart nginx

systemctl enable nginx
```

- tomcat.conf 파일을 통해 tomcat과 연동
    - 정적 파일 (css, js, jpg, jpeg, html 등)은 nginx가 처리하도록 하고 그 외 동적 파일은 tomcat이 처리하도록 해준다.
    - conf.d 디렉터리에 있는 default.conf는 backup 해주고 진행한다.
    - tomcat server를 2개 두므로 Client 단이 접속할 때 세션을 유지하기 위해 ip_hash 알고리즘을 사용한다.

```bash
cd /etg/nginx/conf.d

mv default.conf default.conf_bak

# vi /etc/nginx/conf.d/tomcat.conf

upstream tomcat {
    ip_hash;
    server was-01.test.local:8080;
    server was-02.test.local:8080;
}

server {
    listen 80;
    server_name web.test.local;

    access_log /var/log/nginx/test1.log;

    location / {
        root /usr/share/nginx/html;
        index index.html index.htm;
    }

    location ~ \.(css|js|jpg|jpeg|gif|htm|html|swf)$ {
        root /usr/share/nginx/html;
        index index.html index.html;
    }

    location ~ \.jsp$ {
        proxy_pass http://tomcat;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $http_host;
    }

    error_page 500 502 503 504 /50x.html;
    location = /50x.html {
        root /usr/share/nginx/html;
    }
}
```

- Worker Process 갯수 조정
    - 워커 프로세스는 CPU Core 숫자에 맞게 조정해준다.
    - CPU가 N Core라면 워커 프로세스 또한 N개로 맞춰준다.
    - vCPU 2개 이므로 2개로 조정해주었음

```bash
[root@web nginx]# cat nginx.conf 

user  nginx;
worker_processes  2;

error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;

events {
    worker_connections  1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    keepalive_timeout  65;

    #gzip  on;

    include /etc/nginx/conf.d/*.conf;
}
```

- Reload

```bash
systemctl restart nginx
```

## Tomcat

- Java 웹 어플리케이션 서버인 Tomcat은 Java 개발 환경 혹은 실행 환경 위에서 작동한다.
- JRE (Java Runtime Environment)나 JDK (Java Development Kit) 둘 중 하나를 설치해준다.
- was-01 설치한 이후에는 was-02도 설치해준다.
    - 본인은 was-01 설치한 이후 KVM에서 Cloning해서 환경만 살짝 수정해줌

### 순서

- openjdk 설치
- 환경 변수 설정
- Test
- Tomcat 설치

### 설치

- openjdk 설치

    java-1.8.0 버젼을 설치해준다. JRE와 JDK 둘 다 설치해줘봄

```bash
yum install java-1.8.0-openjdk java-1.8.0-openjdk-devel.x86_64
```

- 환경변수 등록
    - /usr/bin/java 경로에 Symbolic Link 경로가 걸려있으므로 실제 경로를 차장서 환경변수를 등록해주어야 한다.
    - 실제 경로를 찾았으면 3가지 (JAVA_HOME, PATH, CLASSPATH)를 등록

```bash
## readlink : Print value of a symbolic link or canonical file name

readlink -f /usr/bin/java
/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.262.b10-0.el7_8.x86_64/jre/bin/java

# 맨 아랫줄에 export까지 기입
vi /etc/profile

...
# JAVA_HOME Directory
JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.262.b10-0.el7_8.x86_64
# Tomcat Server Home DIrectory
CATALINA_HOME=/opt/tomcat8
# binary
PATH=$PATH:$JAVA_HOME/bin
# library, tools.jar
CLASSPATH=$JAVA_HOME/jre/lib:$JAVA_HOME/lib/tools.jar
export JAVA_HOME PATH CLASSPATH CATALINA_HOME

# source 명령어로 적용
source /etc/profile
```

- Test

```bash
[root@was-01 tomcat8]# echo $PATH 
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin:/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.262.b10-0.el7_8.x86_64/bin

[root@was-01 tomcat8]# echo $CLASSPATH 
/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.262.b10-0.el7_8.x86_64/jre/lib:/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.262.b10-0.el7_8.x86_64/lib/tools.jar

[root@was-01 tomcat8]# echo $CATALINA_HOME 
/opt/tomcat8

[root@was-01 tomcat8]# echo $JAVA_HOME 
/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.262.b10-0.el7_8.x86_64
```

- 간단한 컴파일 Test

```bash
# vi HelloWorld.java

public class HelloWorld{
   public static void main(String[] args){
        System.out.println("Hello World!!");
   }
}

javac HelloWorld.java
java -cp . HelloWorld
Hello World!!
```

- tomcat 전용 계정 생성

```bash
useradd -aG wheel tomcat

passwd tomcat
```

- /opt 디렉터리로 이동하여 설치 진행

```bash
cd /opt
```

- .zip 파일이나 .tar.gz 파일을 Tomcat 공식 홈페이지에서 wget 혹은 curl 명령어로 가져오기

    tomcat 8.5.59 버젼임

```bash
wget https://downloads.apache.org/tomcat/tomcat-8/v8.5.59/bin/apache-tomcat-8.5.59.tar.gz
```

- 파일 압축 해제

```bash
tar xvf apache-tomcat-8.5.59.tar.gz
```

- 압축 푼 디렉터리 tomcat 계정으로 디렉터리 소유자 변경

    chown tomcat:tomcat -R <<CATALINA_HOME_DIR>>

```bash
chown -R tomcat:tomcat /opt/tomcat8
```

- server.xml 가서 URIEncoding 설정

    Service name=Catalina 섹션에서 8080 커넥터로 들어오는 부분에 대한 정의가 있음

    HTTP Connector로 들어오는 요청에 대한 URIEncoding을 UTF-8 추가

```bash
..
..
<Service name="Catalina">

    <!--The connectors can use a shared executor, you can define one or more named thread pools-->
    <!--
    <Executor name="tomcatThreadPool" namePrefix="catalina-exec-"
        maxThreads="150" minSpareThreads="4"/>
    -->

    <!-- A "Connector" represents an endpoint by which requests are received
         and responses are returned. Documentation at :
         Java HTTP Connector: /docs/config/http.html
         Java AJP  Connector: /docs/config/ajp.html
         APR (HTTP/AJP) Connector: /docs/apr.html
         Define a non-SSL/TLS HTTP/1.1 Connector on port 8080
    -->
    <Connector port="8080" protocol="HTTP/1.1"
               connectionTimeout="20000"
               redirectPort="8443"
               **URIEncoding="UTF-8" />           # 추가**
```

- tomcat 서비스 등록

    yum으로 설치한 것이 아니므로 service 등록이 안되어있음

    수동으로 $CATALINA_HOME/bin/startup.sh 하기엔 너무 번거로우므로 서비스 등록

    vi /usr/lib/systemd/system/tomcat.service

    ```bash
    [Unit]
    Description=tomcat8 
    After=syslog.target

    [Service]
    Type=forking
    User=tomcat
    Group=tomcat
    ExecStart=/opt/tomcat8/bin/startup.sh
    ExecStop=/opt/tomcat8/bin/shutdown.sh
    SuccessExitStatus=143

    [Install]
    WantedBy=multi-user.target
    ```

- index.jsp 수정

    was-01 서버에는 tomcat-1 기입

    was-02 서버에는 tomcat-2 기입

    vi /opt/tomcat8/webapps/ROOT/index.jsp

```bash
<%@page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<html>
    <head>
        <title>tomcat-1</title>
    </head>
    <body>
        <h1><font color="red">Session serviced by tomcat</font></h1>
        <table aligh="center" border="1">
        <tr>
            <td>Session ID</td>
            <td><%=session.getId() %></td>
                <% session.setAttribute("abc","abc");%>
            </tr>
            <tr>
            <td>Created on</td>
            <td><%= session.getCreationTime() %></td>
            </tr>
        </table>
    tomcat-1
    </body>
<html>
```

- tomcat 서비스 시작

```bash
[root@was-01 ROOT]# systemctl restart tomcat.service 
[root@was-01 ROOT]# systemctl enable tomcat.service 
[root@was-01 ROOT]# systemctl status tomcat.service 
● tomcat.service - tomcat8
   Loaded: loaded (/usr/lib/systemd/system/tomcat.service; enabled; vendor preset: disabled)
   Active: active (running) since 토 2020-10-31 13:35:53 EDT; 6s ago
 Main PID: 2866 (java)
   CGroup: /system.slice/tomcat.service
           └─2866 /usr/bin/java -Djava.util.logging.config.file=/opt/tomcat8/conf/logging.properties -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager -Djdk.tls.ephemeralDHKeySize=2048 ...

10월 31 13:35:53 was-01 systemd[1]: Stopped tomcat8.
10월 31 13:35:53 was-01 systemd[1]: Starting tomcat8...
10월 31 13:35:53 was-01 systemd[1]: Started tomcat8.
```

- curl test

```bash
[root@was-01 ROOT]# curl -I localhost:8080
HTTP/1.1 200 
Set-Cookie: JSESSIONID=F6E7E8A3219B2D0737BD54FAA85892B4; Path=/; HttpOnly
Content-Type: text/html;charset=ISO-8859-1
Transfer-Encoding: chunked
Date: Sat, 31 Oct 2020 17:39:25 GMT

```

- 웹 브라우저에서 접속

    IP Hash 알고리즘이 적용되어 시간이 지나도 같은 Tomcat 서버로 접속중임을 확인할 수 있다.

![Untitled 1](https://user-images.githubusercontent.com/67780144/97795152-09a48f00-1c46-11eb-9eef-b19b8036a33c.png)

- was-01, was-02 로도 각각 웹브라우저에서 접속
    - 세션 ID는 각각의 서버이므로 다르고, Message도 다르다.

![Untitled 2](https://user-images.githubusercontent.com/67780144/97795153-09a48f00-1c46-11eb-8447-ef6df0a952ce.png)

## 추가로 실습해봐야 할 사항들

1. Tomcat Session Clustering 적용
    - Redis In-memory Database를 통해 톰캣 다중화 환경에서 Tomcat-Redis 세션 클러스터링
2. 간단한 Application 올려보기
    - github 등에 여러가지 자바 샘플 어플리케션이 있을 것 같음

# Trouble Shootings

## 상황

- Nginx 홈페이지를 통해서 was-01, was-02로 접속하려고 하는데 Error 발생

![Untitled 3](https://user-images.githubusercontent.com/67780144/97795155-0a3d2580-1c46-11eb-8dc1-4c8f64988a60.png)

## 원인

- error log를 확인해보라고 해서 확인해봄

    permission 문제...

- 구글링 해 본 결과

    SELinux 문제였음

## 해결 방법

1. SELinux 끄기
    - setenforce 0
2. setsebool 명령어를 통해 SELinux 설정
    - setsebool -P httpd_can_network_connect on
- 조치 후

    tomcat으로 Redirect가 잘 되는것을 확인할 수 있었음

![Untitled 4](https://user-images.githubusercontent.com/67780144/97795157-0ad5bc00-1c46-11eb-99ca-aca20ecfe549.png)

- Reference

[http://dveamer.github.io/backend/InstallNginxTomcat.html](http://dveamer.github.io/backend/InstallNginxTomcat.html)