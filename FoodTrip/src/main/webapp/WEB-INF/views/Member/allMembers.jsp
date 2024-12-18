<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.spring.domain.Member" %>
<!DOCTYPE html>
<html>
<%
	int pageNum = (Integer) request.getAttribute("pageNum");
	int totalPage = (Integer) request.getAttribute("totalPage");
	System.out.println("페이지넘 : " + pageNum);
	System.out.println("토탈페이지 : " + totalPage);
%>
<head>
<meta charset="UTF-8">
<title>전체 회원 관리</title>
</head>
<body>
	<%@ include file="../menu/menu.jsp" %>
	<div>전체 회원</div>
	<div>
	<a href="./allMembers?memberlist=1">가입 날짜 순</a>
	<a href="./allMembers?memberlist=2">가나다 순</a>
		<table border="1">
			<tr>
				<th>이메일</th>
				<th>닉네임</th>
				<th>성별</th>
				<th>나이</th>
				<th>뱃지</th>
				<th>가입날짜</th>
				<th></th>
			</tr>
			<%
				List<Member> list = (List<Member>) request.getAttribute("memberList");
				for(int j=0; j<list.size(); j++){
					Member member = list.get(j);
			%>
			<tr>
				<th><%=member.getEmail()%></th>
				<th><%=member.getNickName() %></th>
				<th><%=member.getGender() %></th>
				<th><%=member.getAge() %></th>
				<th><%=member.getBadgeName() %></th>
				<th><%=member.getJoinDay() %></th>
				<th><a href="/member/deleteMember?email=<%=member.getEmail()%>" class="btn btn-danger">삭제</a>
			</tr>
		<%} %>
		</table>
		<%for(int i=1; i<=totalPage; i++){%>
		<a href="/member/allMembers?pageNum=<%=i %>">
			<%if(pageNum == i){ %>
			<font color='4C5317'><b>[<%=i%>]</b></font>
			<%}else{ %>
			<font color='4C5317'><b>[<%=i%>]</b></font>
			<%} %>
		</a>
		<%} %>
	</div>
</body>
</html>