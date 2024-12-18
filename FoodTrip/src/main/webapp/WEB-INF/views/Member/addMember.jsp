<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page session="false" %>
<!DOCTYPE html>
<html>
<%
	String email = (String)request.getAttribute("email");
	System.out.println("폼에서이메일 : " + email);
%>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<%@ include file="../menu/menu.jsp" %>
	<h1>회원가입</h1>
	<form:form modelAttribute="addMem" method="post">
		<p>이메일 : <form:input path="email" value="<%=email%>" readonly="true"/> <h3>인증완료</h3> 
		<p>비밀번호 : <form:input path="password"/>
		<p>닉네임 : <form:input path="nickName" id="nickName"/>
		<button class="btn btn-sm btn-primary overlap" type="button">중복확인</button>
		<p>성별 : <div>
					<form:radiobutton path="gender" value="Man"/>남성
					<form:radiobutton path="gender" value="Woman"/>여성
				</div>
		<p>나이 : <form:input type="number" path="age"/>
		<p>	<input type="submit" value="회원가입" disabled>
	</form:form>
	<!-- JavaScript for 댓글 AJAX -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/FoodTrip/resources/js/Member.js?version=18" type="text/javascript"></script>
</body>
</html>