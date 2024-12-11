<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.spring.domain.*" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<%
		List<Marker> list = (List<Marker>)request.getAttribute("list");
	
		if(list != null){
			for(int i=0; i<list.size(); i++){
				Marker marker = list.get(i);
	%>		
		<div>
			<p><%= marker.getCategory()%>
			<p><%= marker.getPointName()%>
			<p><%= marker.getPhone()%>
			<p><%= marker.getAddress()%>
			<p><%= marker.getDescription()%>
			<p><%= marker.getImageName()%>
			<a href="/FoodTrip/marker/readone?id=<%= marker.getmarkerId()%>">상세보기</a>
			<br><br><br><br>
		</div>
	<%		
			}
		}
	%>
</body>
</html>