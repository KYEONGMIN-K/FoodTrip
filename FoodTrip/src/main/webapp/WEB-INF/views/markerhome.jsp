<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spring.domain.Member" %>
<%@ page session="false" %>
<!DOCTYPE html>
<html>
<head>
<%
	HttpSession session = request.getSession(false);
	Member sessionId = (Member)session.getAttribute("sessionId");
	if(sessionId != null){
		System.out.println("게시글 작성 폼 세션 널아님!!");
		System.out.println("닉네임 : " + sessionId.getNickName());
	}
%>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<a href="create">마커 생성</a>
	<a href="test">마커 생성(javascript)</a>
	<a href="readall">마커 전체 가져오기</a>
	<a href="readalljson">마커 전체 가져오기(javascript)</a>
</body>
</html>