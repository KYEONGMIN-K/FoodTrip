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
	<h1>회원가입</h1>
	<form:form modelAttribute="addMem" method="post">
		<p>이메일 : <form:input path="email1"/> @
					<form:select path="email2">
						<option value="naver.com">naver.com</option>
						<option value="daum.net">daum.net</option>
						<option value="gmail.com">gmail.com</option>
						<option value="nate.com">nate.com</option>
					</form:select> 
		<p>비밀번호 : <form:input path="password"/>
		<p>닉네임 : <form:input path="nickName"/>
		<p>성별 : <div>
					<form:radiobutton path="gender" value="남성"/>남성
					<form:radiobutton path="gender" value="여성"/>여성
				</div>
		<p>나이 : <form:input type="number" path="age"/>
		<p>	<input type="submit" value="회원가입">
	</form:form>
</body>
</html>