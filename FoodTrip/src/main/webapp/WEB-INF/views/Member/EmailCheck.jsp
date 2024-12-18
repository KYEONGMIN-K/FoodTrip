<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<%
	String mailCheck = (String)request.getAttribute("true");
%>
<head>
<link rel="stylesheet" href="/FoodTrip/resources/css/bootstrap.min.css">
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	
	<form:form modelAttribute="email" method="post">
	<p>이메일 : <form:input path="email1"/> @
					<form:select path="email2">
						<option value="naver.com">naver.com</option>
						<option value="daum.net">daum.net</option>
						<option value="gmail.com">gmail.com</option>
						<option value="nate.com">nate.com</option>
					</form:select> 
					<input type="submit" value="이메일인증"/>
					<%if(mailCheck!=null){%>
					<div class="alert alert-danger">가입된 이메일이 존재합니다.</div>
					<%} %>
	</form:form>
	
</body>
</html>