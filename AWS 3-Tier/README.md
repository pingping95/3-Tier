# Overview

Apache-Tomcat-RDS 3-Tier를 구현해보고자 합니다.

# 목적

- AWS 상에서 고가용성 3-Tier를 구현한다.
    - 2개의 가용 영역을 구현함으로써 고가용성 인프라 구현
    - Apache - Tomcat - RDS
    - 정적인 Content는 Web Server가 처리하고 동적인 Content는 Tomcat이 처리한다.

# Architecture

![Untitled_Diagram](https://user-images.githubusercontent.com/67780144/100350992-15f5ef00-302e-11eb-88f4-0392a23b7e53.png)
- 가용성을 보장하기 위해 2개의 Available Zone으로 구성하였습니다.
- Public Subnet에는 NAT Gateway, Bastion Node가 있습니다.
- Private Subnet에는 각각 Front-Tier, Backend-Tier, DB-Tier로 구성되어 있습니다.
- Master DB(RDS)가 장애가 발생하여 Down되면 즉시 Slave DB(RDS)가 즉시 동작하게 됩니다.
- Web Server : Apache
- Web Application Server : Tomcat
- Database : RDS (MySQL)

# 전체적인 과정

- IAM 생성 : 3tier-user
- VPC를 생성합니다.
- Subnet을 생성합니다.
    - Public, Private Subnet
- Security Group을 생성
    - External LB, Internal LB, Web, WAS, DB, Bastion, ..
- Internet Gateway 생성
- NAT Gateway 생성
- EC2 Instance 생성
    - Bastion Node
    - Apache server - #1, #2
    - Tomcat Server - #1, #2
- RDS - #1, #2
- ALB 생성
- ALB Group 생성
- Apache - Tomcat 연동 : LB를 통한 부하 분산이 가능하도록 설정
- Tomcat - DB 연동 ((( RDS 비용때문에 실제로 진행하진 않았음 )))
    - JDBC Driver를 통해 DB와 연동, Connection 객체를 받아옴
    - JAVA, TOMCAT 설치 경로에 binary jar 파일 복사
    - context.xml에 DB Endpoint, 계정 정보, 패스워드, .. 기입
    - web.xml 파일 설정
    - DB 연동 테스트를 위한 test.jsp 생성

    ```bash
    ## 예시 ##

    <Resource       name="jdbc/dbmy"
                    auth="Container"
                    type="javax.sql.DataSource"
                    maxActive="50"
                    maxIdle="30"
                    maxWait="10000"
                    username="testuser"
                    password="1234"
                    driverClassName="com.mysql.jdbc.Driver"
                    url="jdbc:mysql://<<DB IP>>:3306/testdb"/>
    </Context>

    <resource-ref>
    <description>MariaDB Datasource</description>
    <res-ref-name>jdbc/dbmy</res-ref-name>
    <res-type>javax.sql.DataSource</res-type>
    <res-auth>Container</res-auth>
    </resource-ref>

    <%@ page language="java" contentType="text/html; charset=UTF-8"
           pageEncoding="UTF-8" import="java.sql.*"%>
    <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
    <html>
    <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>DB Connection Test</title>
    </head>
    <body>
           <%
                  String DB_URL = "jdbc:mysql://<<DB IP>>:3306/"testdb";
                  String DB_USER = "testuser";
                  String DB_PASSWORD = "1234";
                  Connection conn;
                  Statement stmt;
                  PreparedStatement ps;
                  ResultSet rs;
                  try {
                         Class.forName("com.mysql.jdbc.Driver");
                         conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
                         stmt = conn.createStatement();

                        /* SQL 처리 코드 추가 부분 */

                         conn.close();
                         out.println("MySQL JDBC Driver Connection Test Success!!!");

    /* 예외 처리  */
                  } catch (Exception e) {
                         out.println(e.getMessage());
                  }
           %>
    </body>
    </html>
    ```

# Result

- Subnet

![Untitled](https://user-images.githubusercontent.com/67780144/100350968-11313b00-302e-11eb-9e1c-85a5839fd8c3.png)
- Security Group

![Untitled 1](https://user-images.githubusercontent.com/67780144/100350975-12626800-302e-11eb-8ace-038dd24cebeb.png)

- 인스턴스

![Untitled 2](https://user-images.githubusercontent.com/67780144/100350977-12fafe80-302e-11eb-99c7-b092320e483c.png)

- 외부, 내부 로드 밸런서 설정

![Untitled 3](https://user-images.githubusercontent.com/67780144/100350980-13939500-302e-11eb-9ebf-666b8428b19b.png)

- web 01, web 02 골고루 로드밸런싱이 되고 있음을 확인할 수 있다.

![Untitled 4](https://user-images.githubusercontent.com/67780144/100350984-142c2b80-302e-11eb-8b99-095b9aa65e92.png)

![Untitled 5](https://user-images.githubusercontent.com/67780144/100350985-142c2b80-302e-11eb-86d0-eccd5cd11cd9.png)

---

- 웹 서버로 접속하여 index.jsp란 동적 컨텐츠를 요청하니 뒷 단으로 대신 Request를 보내는 것을 확인
- tomcat-1, tomcat-2 골고루 접속이 됨을 확인할 수 있다.

![Untitled 6](https://user-images.githubusercontent.com/67780144/100350988-14c4c200-302e-11eb-84aa-534f7c6cc3fc.png)

![Untitled 7](https://user-images.githubusercontent.com/67780144/100350989-155d5880-302e-11eb-8620-1b48827ab81f.png)

- Reference

    [https://medium.com/@nnamani.kenechukwu](https://medium.com/@nnamani.kenechukwu)

    [https://pearlluck.tistory.com/72?category=830422](https://pearlluck.tistory.com/72?category=830422)`****