<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page session="false" %>
<%@ page import ="com.spring.domain.Member" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<%@ include file="../menu/menu.jsp" %>
	<form:form modelAttribute="addBrd" method="post">
		<p>닉네임 : <form:input path="nickName" value="<%=sessionId.getNickName()%>" readonly="true" />
		<p>제목 : <form:input path="title" placeholder="제목을 입력해주세요"/>
		<p>내용 : 
			<p><form:textarea path="content" cols="100" rows="30"/>
		<p>	<input type="submit" value="등록"/>
	</form:form>
</body>
</html>