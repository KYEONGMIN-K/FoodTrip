<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page session="false" %>
<%@ page import ="com.spring.domain.Member" %>
<%
	HttpSession session = request.getSession(false);
	Member sessionId = (Member)session.getAttribute("sessionId");
	if(sessionId != null){
		System.out.println("게시글 작성 폼 세션 널아님!!");
		System.out.println(sessionId.getNickName());
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<form:form modelAttribute="addBrd" method="post">
		<p>이메일 : <form:input path="nickName" value="<%=sessionId.getNickName()%>" readonly="true" />
		<p>제목 : <form:input path="title" placeholder="제목을 입력해주세요"/>
		<p>내용 : 
			<p><form:textarea path="content" cols="100" rows="30"/>
		<p>	<input type="submit" value="등록"/>
	</form:form>
</body>
</html>