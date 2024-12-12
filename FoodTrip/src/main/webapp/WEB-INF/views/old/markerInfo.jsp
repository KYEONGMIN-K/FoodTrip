<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.spring.domain.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<%
		Marker marker = (Marker)request.getAttribute("marker");
	%>
	
	<p><%= marker.getmarkerId()%>
	<p><%= marker.getPointX()%>
	<p><%= marker.getPointY()%>
	<p><%= marker.getCategory()%>
	<p><%= marker.getPointName()%>
	<p><%= marker.getPhone()%>
	<p><%= marker.getAddress()%>
	<p><%= marker.getDescription()%>
	<img src="/FoodTrip/resources/images/<%= marker.getImageName()%>" style="width:100px"/>
	<p><a href="update?id=<%= marker.getmarkerId()%>">수정</a>
	<p><a href="delete?id=<%= marker.getmarkerId()%>">삭제</a>
</body>
</html>