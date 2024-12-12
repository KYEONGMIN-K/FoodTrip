<%@ page isELIgnored="false" language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="false" %>
<%@ page import="com.spring.domain.Member" %>
<html>
<%
	HttpSession session = request.getSession(false);
	String sessionId = null;
	if(session != null){
		
		Member mb = (Member) session.getAttribute("sessionId");
		System.out.println("세션null아님 " );
		if(mb != null){
			System.out.println("mb null아님");
			sessionId = mb.getEmail();
		}
	}
%>
<body>
<a href="test">테스트</a>
<%
	if(sessionId != null && !sessionId.isEmpty()){
%>
	<a href="logout">로그아웃</a>
	<a href="update">회원정보수정</a>
<%}else{%>
	<a href="login">로그인</a>
	<a href="addMember">회원가입</a>
<%} %>

<a href="boards">리뷰게시판</a>
</body>
</html>
