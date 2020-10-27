## 보충 학습

- XML Basics

    ## 정의

    - 다목적 마크업 언어(Extensible Markup Language)이다.
    - 특히 인터넷에 연결된 시스템끼리 데이터를 쉽게 주고 받을 수 있게 하여 HTML의 한계를 극복할 목적으로 만들어졌다.

    ### Example
    ![Untitled 10](https://user-images.githubusercontent.com/67780144/93719156-b73e7000-fbbb-11ea-9c07-570059e4ebe0.png)

    ![Apache+Tomcat+MariaDB%20c9e97d58812e4bd699ae33209e566a94/Untitled%2010.png](Apache+Tomcat+MariaDB%20c9e97d58812e4bd699ae33209e566a94/Untitled%2010.png)

- Java Web Server

    ### 톰캣

    오픈소스 자바 서블릿 컨테이너

    서블릿, JSP, JSTL, WebSocket 등 여러가지 JavaEE 기술을 구현하고, Java 코드를 실행하는 순수 Java HTTP 웹서버이다.

    ### 톰캣 카탈리나

    톰캣은 여러개의 기능(부품)으로 구성한다. 톰캣의 코어 컴포넌트는 카탈리나라고 칭한다.

    카탈리나는 톰캣의 서블렛 스펙의 실질적인 구동을 제공한다. 톰캣 서버를 가동시킬 경우, 카탈리나를 구동 시킨 것이라고 생각하면 된다. 

    카탈리나 기본 동작은 톰캣의 6가지 config 파일을 편집하여 구현/제어할 수 있다.

    - catalina.policy

        → JavaEE 스펙에 정의된 표준 보안 정책 구문으로 표현된 카탈리나 자바 클래스의 톰캣 보안 정책이다. 톰캣의 코어 보안 정책, 시스템 코드, 웹앱, 카탈리나 자체의 퍼미션이 정의되어 있다.

    - catalina.properties

        → 카탈리나 클래스를 위한 표준 자바 property이다. 보안 패키지 리스트, 클래스 로더 패스 등과 같은 정보이다. 톰캣의 성능 최적화를 위한 String 캐시 설정이 포함된다.

    - logging.properties

        → 임계값, 로그값의 위치와 같은 카탈리나의 로깅 기능을 구성하는 방법이다.

    - content.xml

        → 톰캣에 구동되는 webapp에 대해 로드될 정보이다.

    - server.xml

        → 톰캣의 메인 config 파일이다. 자바 서블릿 스펙에 지정된 게층적 문법을 사용하여 카탈리나의 초기 상태 구성, 톰캣을 부팅하고 구성 요소의 빌드 순서를 정의한다. 

    - tomcat-user.xml

        → 톰캣 서버의 많은 유저, 패스워드, 유저 롤에 관한 정보와 데이터에 액세스하는 신뢰된 영역(JNDI, JDBC)에 대한 정보가 들어있다.

    - web.xml

        → 버퍼 크기, 디버깅 레벨, 클래스패스와 같은 Jasper 옵션, MIME 유형 및 웹페이지 index 파일 같은 서블릿 정의를 포함하여 톰캣 인스턴스에 로드되는 모든 응용 프로그램에 적용하는 옵션 또는 값이다.

    ### 재스퍼(Jasper)

    - 톰캣의 JSP 엔진이다. 제스퍼는 JSP 파일을 파싱하여 서블릿 (JavaEE) 코드로 컴파일한다. JSP 파일의 변경을 감지하여 리컴파일 작업도 수행한다.
- Tomcat Directories

    ### context.xml

    → 톰캣에 구동되는 webapp에 대해 로드될 정보이다. 


    ### server.xml

    → 톰캣의 메인 config 파일이다. 자바 서블릿 스펙에 지정된 게층적 문법을 사용하여 카탈리나의 초기 상태 구성, 톰캣을 부팅하고 구성 요소의 빌드 순서를 정의한다. 


    - Server port
        - Listener
        - GlobalNamingResources

    - Service name=Catalina
    - Connector Port를 정할 수 있고, Timeout도 정할 수 있고, redirecPort도 정할 수 있다.
    - Connector port를 8080과 8009 두개로 정할 수 있는데 redirecPort가 8443인거 보니까 8443이 servlet이지 않을까? 직접 들어오는 것은 8080이고 AJP로 들어오는 것은 8009인 것 같다. 이 파일을 통해 확인할 수 있다.
    - Engine Name은 Catalina이며 defaultHost는 localhost라고 써있다.
    - Host name, unpackWARs, autoDeploy, appBase 등을 지정할 수 있다.

    ### tomcat.conf

    - TOMCAT_CFG_LOADED
    - TOMCATS_BASE
    - JAVA_HOME
    - CATALINA_HOME
    - CATALINA_TMPDIR
    - SECURITY_MANAGER

    ### catalina.policy

    → JavaEE 스펙에 정의된 표준 보안 정책 구문으로 표현된 카탈리나 자바 클래스의 톰캣 보안 정책이다. 톰캣의 코어 보안 정책, 시스템 코드, 웹앱, 카탈리나 자체의 퍼미션이 정의되어 있다.

    ### catalina. properties

    → 카탈리나 클래스를 위한 표준 자바 property이다. 보안 패키지 리스트, 클래스 로더 패스 등과 같은 정보이다. 톰캣의 성능 최적화를 위한 String 캐시 설정이 포함된다.

    ### logging. properties

    → 임계값, 로그값의 위치와 같은 카탈리나의 로깅 기능을 구성하는 방법이다.

    ### content.xml

    → 톰캣에 구동되는 webapp에 대해 로드될 정보이다.

    ### server.xml

    → 톰캣의 메인 config 파일이다. 자바 서블릿 스펙에 지정된 게층적 문법을 사용하여 카탈리나의 초기 상태 구성, 톰캣을 부팅하고 구성 요소의 빌드 순서를 정의한다. 

    ### tomcat-user.xml

    → 톰캣 서버의 많은 유저, 패스워드, 유저 롤에 관한 정보와 데이터에 액세스하는 신뢰된 영역(JNDI, JDBC)에 대한 정보가 들어있다.

    ### web.xml

    → 버퍼 크기, 디버깅 레벨, 클래스패스와 같은 Jasper 옵션, MIME 유형 및 웹페이지 index 파일 같은 서블릿 정의를 포함하여 톰캣 인스턴스에 로드되는 모든 응용 프로그램에 적용하는 옵션 또는 값이다.

- 용어 정리

    **mod_jk**
    아파치, 톰캣 연동을 위해 mod_jk라는 모듈을 사용하는데, 이는 AJP프로토콜을 사용하여 톰캣과 연동하기 위해 만들어진 모듈이다. mod_jk는 톰캣의 일부로 배포되지만, 아파치 웹서버에 설치하여야 한다.

    **톰캣의 컴포넌트 종류**
    1. Catalina : 서블릿 컨테이너로써 자바 서블릿을 호스팅하는 환경
    2. Jasper : 톰캣의 JAP 컴포넌트이다. 실제로는 JSP 페이지의 요청을 처리하는 서블릿이다.
    3. Tomcat : Catalina, Jasper와 서버를 시작하고 멈추는 배치 파일들, 예제 애플리케이션 등으로 구성

    **WAR(Web application ARchive)**
    ⇒ 자바서버 페이지, 자바 서블릿, 자바 클래스, XML, 파일, 태그 라이브러리, 정적 웹 페이지 (HTML 관련 파일) 및 웹 애플리케이션을 함께 이루는 기타 자원을 한데 모아 배포하는데 사용되는 JAR 파일이다.

    **JAR(Java Archive)**
    여러개의 자바 클래스 파일과, 클래스들이 이용하는 관련 리소스(텍스트, 그림 등) 및 메타데이터를 하나의 파일로 모아서 자바 플랫폼에 응용 소프트웨어나 라이브러리를 배포하기 위한 소프트웨어 패키지 파일 포맷이다.

    **AJP(Apache JServ Protocol)**
    웹서버(Apache) 뒤에 있는 어플리케이션 서버로부터 웹서버로 들어오늘 요청을 위임할 수 있는 바이너리 프로토콜이다.

    웹 개발자들은 대체로 AJP를 여러 웹서버로부터 여러개의 애플리케이션 서버로의 로드 밸런서 구현에 이용한다. 세션들의 각각의 애플리케이션 서버 인스턴스의 이름을 갖는 라우팅 메커니즘을 사용하는 현재 어플리케이션 서버로 리다이렉트된다. 이 경우 애플리케이션 서버를 위한 리버시 프록시로 웹서버는 동작한다.

    **포워드 프록시 서버 (Proxy Server)**
    클라이언트가 인터넷을 통해 연결하려고 하면 프록시 서버가 요청을 받은 후 그 결과를 클라이언트에게 전달한다. 대개 캐슁 기능이 있으므로 자주 사용하는 컨텐츠라면 월등한 성능 향상을 가져올 수 있으며 정해진 사이트만 연결하게 설정하는 등 웹 사용 환경을 제한할 수 있다

    **리버스 프록시 서버 (Reverse Proxy Server)**
    포워드 프록시와 반대 방향이라 생각하면 된다.
    내부 인트라넷에 있는 서버를 호출하기 위해서 인터넷 망에 있는 클라이언트가 리버스 프록시 서버에 요청하여 응답을 받는 방식이다. 서버가 누구인지 감추는 역할을 해주며 클라이언트는 리버스 프록시 서버를 먼저 호출하게 되기 때문에 실제 서버의 IP를 알 수 없다.

  
