<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.spring.domain.*" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <title>게시글 상세보기</title>
<link rel="stylesheet" href="/FoodTrip/resources/css/bootstrap.min.css">
</head>
<body>
    <div class="container">
        <% 
	        Board board = (Board) request.getAttribute("board");
	        Member sessionId = (Member) session.getAttribute("sessionId");
	        List<Board> comments = (List<Board>) request.getAttribute("comments");
        	System.out.println("코멘트 : " + comments);
        %>

        <h1><%= board.getTitle() %></h1>
        <p><%= board.getContent() %></p>
        <p><small class="text-muted">작성자: <%= board.getNickName() %> | 작성일: <%= board.getCreateTime() %></small></p>
        <!-- 게시글 수정/삭제 버튼 -->
        <% if (sessionId != null && sessionId.getNickName().equals(board.getNickName())) { %>
            <a href="/FoodTrip/updateBoard?num=<%= board.getBrdNum() %>" class="btn btn-primary">수정</a>
            <a href="/FoodTrip/deleteBoard?num=<%= board.getBrdNum() %>" class="btn btn-danger" onclick="return confirm('정말 삭제하시겠습니까?');">삭제</a>
        <% } %>
        <hr>

		<!-- 댓글 입력 -->
        <div>
            <textarea id="commentContent" class="form-control mb-2" placeholder="댓글을 입력하세요"></textarea>
            <button id="addComment" class="btn btn-primary" data-parent="<%=board.getBrdNum()%>" data-depth="2" data-nick="<%=sessionId.getNickName()%>">댓글 작성</button>
        </div>
        <hr>

        <!-- 댓글 목록 -->
        <h4>댓글</h4>
        <% for (int i = 0; i < comments.size(); i++) {
            Board comment = comments.get(i);
            System.out.println("뎁스 : " + comment.getDepth());
        	if(comment.getDepth()==2 && !comment.getContent().equals("삭제된 메시지입니다")){
        %>
	       	<div class="mb-3" style="margin-left:20px;">
			    <p class="commentContent"><%= comment.getContent() %></p>
			    <p><small class="text-muted">작성자: <%= comment.getNickName() %> | 작성일: <%= comment.getCreateTime() %></small></p>		
				<button class="btn btn-sm btn-secondary replyButton" 
	        			data-id="<%= comment.getBrdNum() %>" data-depth="3">답글</button>
			    <!-- 수정 버튼 및 삭제 버튼 -->
			    <% if (sessionId != null && sessionId.getNickName().equals(comment.getNickName())) { %>
			        <button class="btn btn-sm btn-secondary editComment" data-id="<%= comment.getBrdNum() %>">수정</button>
			        <button class="btn btn-sm btn-danger deleteComment" data-id="<%= comment.getBrdNum() %>">삭제</button>
			    <% } %>
			
			    <!-- 수정 입력 영역 (동적 추가) -->
			    <div class="editSection" style="display: none;">
			        <textarea class="form-control editTextarea"></textarea>
			        <button class="btn btn-sm btn-primary saveEdit" data-id="<%= comment.getBrdNum() %>">저장</button>
			        <button class="btn btn-sm btn-secondary cancelEdit">취소</button>
			    </div>
	    	</div>
	    	<hr>
	        <%
	        }else if(comment.getDepth()==2 &&comment.getContent().equals("삭제된 메시지입니다")){%>
	        	<div class="mb-3" style="margin-left:20px;">삭제된 메시지입니다</div>
	        	<hr>
	        <% } 
        	else if(comment.getDepth()==3 && !comment.getContent().equals("삭제된 메시지입니다")){%>
        		<div class="mb-3" style="margin-left:40px;">
				    <p class="commentContent"><%= comment.getContent() %></p>
				    <p><small class="text-muted">작성자: <%= comment.getNickName() %> | 작성일: <%= comment.getCreateTime() %></small></p>
					<button class="btn btn-sm btn-secondary replyButton" 
		        			data-id="<%= comment.getBrdNum() %>" data-depth="3">답글</button>
				    <!-- 수정 버튼 및 삭제 버튼 -->
				    <% if (sessionId != null && sessionId.getNickName().equals(comment.getNickName())) { %>
				        <button class="btn btn-sm btn-secondary editComment" data-id="<%= comment.getBrdNum() %>">수정</button>
				        <button class="btn btn-sm btn-danger deleteComment" data-id="<%= comment.getBrdNum() %>">삭제</button>
				    <% } %>
				
				    <!-- 수정 입력 영역 (동적 추가) -->
				    <div class="editSection" style="display: none;">
				        <textarea class="form-control editTextarea"></textarea>
				        <button class="btn btn-sm btn-primary saveEdit" data-id="<%= comment.getBrdNum() %>">저장</button>
				        <button class="btn btn-sm btn-secondary cancelEdit">취소</button>
				    </div>
	    		</div>
	    		<hr>
	       	<%}else if(comment.getDepth()==3 && comment.getContent().equals("삭제된 메시지입니다")){ %>
	       		<div class="mb-3" style="margin-left:40px;">삭제된 메시지입니다</div>
	       		<hr>
	       	<%	}
        	} %>

    <!-- JavaScript for 댓글 AJAX -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/FoodTrip/resources/js/board.js?version=6" type="text/javascript"></script>
</body>
</html>
