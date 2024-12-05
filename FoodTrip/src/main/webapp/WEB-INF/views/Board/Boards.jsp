<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.spring.domain.Board" %>
<!DOCTYPE html>
<html>
	<%
		int total_record = ((Integer) request.getAttribute("total_record")).intValue();
		int pageNum = ((Integer) request.getAttribute("pageNum")).intValue();
		int total_page = ((Integer) request.getAttribute("total_page")).intValue();
		System.out.println("JSP토탈페이지 : " +  total_page);
		System.out.println("JSP토탈레코드 : " + total_record);
		System.out.println("JSP페이지넘 : " + pageNum);
	%>

<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div>전체</div>
	<div>
		<table border="1">
			<tr>
				<th>번호</th>
				<th>제목</th>
				<th>작성자</th>
				<th>조회   |   좋아요</th>
				<th>작성날자</th>
			</tr>
			<%
				List<Board> brd = (List<Board>)request.getAttribute("brd");
				for(int j=0; j<brd.size(); j++){
					Board notice = (Board) brd.get(j);
					long parent = notice.getParentNum();
					
			%>
						<tr>
							<td><%=notice.getBrdNum() %></td>
							<td><a href="./BoardView?num=<%=notice.getBrdNum()%>&pageNum=<%=pageNum%>"><%=notice.getTitle() %></a></td>
							<td><%=notice.getNickName() %></td>
							<td><%=notice.getViews() %>|<%=notice.getLikes() %></td>
							<td><%=notice.getCreateTime() %></td>
						</tr>
			<%
					
				}
			%>
				</table>
				<div>
					<%for(int i=1; i<=total_page; i++){%>
						<a href="boards?pageNum=<%=i %>">
						<%if(pageNum == i){ %>
							<font color='4C5317'><b>[<%=i %>]</b></font>
						<%}else{ %>
							<font color='4C5317'>[<%=i %>]</font>
						<%} %>
					</a>
				    <%} %>			
		</div>
		<div>
			<a href="./addBoard">글쓰기</a>
		</div>
	</div>
</body>
</html>