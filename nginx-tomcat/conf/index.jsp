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