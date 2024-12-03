<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page session="false" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h1>로그인</h1>
	<form:form modelAttribute="mem" method="post">
		<p>이메일 : <form:input path="email1"/> @ 
					<form:select path="email2" >
						<option>naver.com</option>
						<option>daum.net</option>
						<option>gmail.com</option>
						<option>nate.com</option>
					</form:select> 
		<p>비밀번호 : <form:input path="password"/>
		<p> <input type="submit" value="로그인">
		<%
			String error = (String)request.getAttribute("error");
			if(error!=null){
		%>
			<div class="alert alert-danger">
				이메일 혹인 비밀번호가 일치하지 않습니다.<br/>
			</div>
			<%} %>
		<a href="addMember">회원가입</a>
	</form:form>
</body>
</html>