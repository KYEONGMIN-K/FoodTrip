<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>   
<%@ page session="false" %>
<%@ page import="com.spring.domain.Member" %>
<%
	HttpSession session = request.getSession(false);
	Member mb = (Member)session.getAttribute("sessionId");
	if(mb != null){
		System.out.println("업데이트폼 세션 널아님!!");
		System.out.println("1"+mb.getEmail());
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="/FoodTrip/resources/css/bootstrap.min.css" rel="stylesheet"/>
<title>Insert title here</title>
</head>
<body>
	<h1>회원수정</h1>
	<form:form modelAttribute="updateMember" method="post">
		<p>이메일 : <form:input path="email" value="<%=mb.getEmail()%>" readonly="true"/> 
		<p>비밀번호 : <form:input path="password" value="<%=mb.getPassword() %>"/>
		<p>닉네임 : <form:input path="nickName" value="<%=mb.getNickName()%>" />
		<p>성별 : <div>
					<form:radiobutton path="gender" value="남성"/>남성
					<form:radiobutton path="gender" value="여성"/>여성
				</div>
		<p>나이 : <form:input type="number" value="<%=mb.getAge() %>" path="age"/>
		<p>	<input type="submit" value="수정">
			<a href="delete?email=<%=mb.getEmail()%>" class="btn btn-danger">삭제</a>
	</form:form>
</body>
</html>