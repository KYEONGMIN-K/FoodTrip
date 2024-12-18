<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page import="com.spring.domain.Board" %>
<%@ page import="com.spring.domain.Member" %>
<%@ page import="java.util.List" %>
<%@ page session="false"%>
<%
	List<Board> list = (List<Board>)request.getAttribute("list");
	Board brd = (Board)request.getAttribute("board");
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 수정</title>
</head>
<body>
	<%@ include file="../menu/menu.jsp" %>
	<form:form modelAttribute="uptBrd" method="post">
<%
		if(brd.getDepth()==1){ System.out.println("남바 : " +brd.getBrdNum() + " brdcontent : "  + brd.getContent());%>
		<p>닉네임 : <form:input path="nickName" value="<%=brd.getNickName()%>" readonly="true" />
		<p>제목 : <form:input path="title" value="<%=brd.getTitle() %>"/>
		<p>내용 : 
			<p><textarea name="content" cols="100" rows="30" ><%=brd.getContent()%></textarea>
		<p>	<input type="submit" value="수정"/>
	<%	
		} %>
	</form:form>
	
</body>
</html>