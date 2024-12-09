<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page import="com.spring.domain.Board" %>
<%@ page import="com.spring.domain.Member" %>
<%@ page import="java.util.List" %>
<%@ page session="false" %>
<%
	List<Board> list = (List<Board>)request.getAttribute("list");
	HttpSession session = request.getSession(false);
	Board brd = new Board();
	int pageNum = (Integer)request.getAttribute("pageNum");
	Member sessionId = (Member)session.getAttribute("sessionId");
	if(sessionId != null){
		System.out.println("게시글 작성 폼 세션 널아님!!");
		System.out.println(sessionId.getNickName());
	} 
%>

<link href="/FoodTrip/resources/css/bootstrap.min.css" rel="stylesheet"/>
<!DOCTYPE html>
<html>
<head>
<head>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%

	for(int i=0; i<list.size(); i++){
		brd = list.get(i);
		if(brd.getDepth()==1){ System.out.println("남바 : " +brd.getBrdNum());%> 
			<div>
				<h2>제목</h2><p><%=brd.getTitle()%>
				<span>조회 수 :<%=brd.getViews()%></span>
				<span>좋아요 수 :<%=brd.getLikes()%></span>
				<hr>
				<div>
					<h4>작성자:<%=brd.getNickName()%></h4>
					<p>작성시간:<%=brd.getCreateTime()%>
				<hr>
				</div>
			</div>
			<div>
				<h2>내용</h2>
				<p><%=brd.getContent()%>
			</div>
			<%
				if(brd.getNickName().equals(sessionId.getNickName())){ System.out.println("게시글 작성자와 현재 계정이 동일");%>
					<a href="updateBoard?num=<%=brd.getBrdNum()%>&pageNum=<%=pageNum%>" class="btn btn-primary">수정</a>
			<%		System.out.println("게시글번호 : " + brd.getBrdNum() + "pageNum : " + pageNum );	}%>
			<hr>
			<div>
				<div>
					<em id="nick"><%=sessionId.getNickName()%></em>
				</div>
				<textarea id="text" placeholder="댓글을 남겨주세요" cols="100" rows="3"></textarea><button id="comSubmit" data-brdNum="<%=brd.getBrdNum()%>" data-depth="2">등록</button>
			</div>
			<hr>
	<%} else if(brd.getDepth()==2){%>
		<div>
			<div>
				<em><%=brd.getNickName()%></em><small>댓글C</small>
			</div>
			<div>
				<%=brd.getContent()%>
			</div>
			<div>
				<small><%=brd.getLikes() %> | <%=brd.getCreateTime()%></small>
			</div>
			<div>
				<button id="reply">댓글</button>
			</div>
			<hr>
		</div>
	<%} else if(brd.getDepth()==3){ System.out.println("그"+brd.getBrdNum());%>
		<div>
			<div>
				<em><%=brd.getNickName()%></em><small>답글R</small>
			</div>
			<div>
				<%=brd.getContent()%>
			</div>
			<div>
				<small><%=brd.getCreateTime()%></small>
			</div>
			<div>
				<button id="reply">댓글</button>
			</div>
			<hr>
		</div>
	<%}
	}%>
	

	<script>
	document.addEventListener("click", function (event) {
	    // 답글 버튼 이벤트
	    if (event.target && event.target.id === "reply") {
	        const replyButton = event.target;

	        // 답글 입력 폼 추가
	        const replyDiv = document.createElement("div");
	        
	        replyDiv.innerHTML = `
	            <hr>
	            <div class="container">
	                <div>
	                    <em id="nick"><%= sessionId.getNickName() %></em>
	                </div>
	                <textarea class="text" placeholder="답글을 남겨주세요" cols="100" rows="3"></textarea>
	                <button class="replyCom" data-brdNum="<%=brd.getBrdNum()%>" data-depth="3">답글 쓰기</button>
	            </div>
	        `;
	        replyButton.parentElement.appendChild(replyDiv);
	   	 }

		    // 동적으로 생성된 replyCom 버튼 이벤트
		    if (event.target && event.target.classList.contains("replyCom")) {
		        const replyComButton = event.target;
		        const nick = document.querySelector("#nick").textContent;
		        const inputdata = replyComButton.previousElementSibling.value; // textarea 값 가져오기
		        const brdNum = replyComButton.getAttribute("data-brdNum");
		        const depth = replyComButton.getAttribute("data-depth");
	
		        console.log("답글 데이터:", { nick, inputdata, brdNum, depth });
	
		        $.ajax({
		            url: "comment",
		            type: "post",
		            data: JSON.stringify({ nickName: nick, content: inputdata, brdNum: brdNum, depth: depth }),
		            contentType: "application/json",
		            success: function (data) {
		                location.reload();
		            },
		            error: function (errorThrown) {
		                alert("fail");
		            }
		        });
		    }
		});
		var btn = document.querySelector("#comSubmit");
		console.log(btn);
		btn.addEventListener("click", comment);
		function comment(){
			console.log("케이스2실행");
			var nick = document.querySelector("#nick").textContent;
			var inputdata = document.querySelector("#text").value;
			var brdNum = btn.getAttribute("data-brdnum");
		    var depth = btn.getAttribute("data-depth");
			console.log(inputdata);
			console.log(nick);
			console.log(brdNum);
			console.log(depth);
			$.ajax({
				url : "comment",
				type : "post",
				data : JSON.stringify({nickName:nick, content:inputdata, brdNum:brdNum, depth:depth}),
				contentType : "application/json",
				success : function(data){
					location.reload();
				},
				error : function(errorThrown){
					alert("fail");
				}
			})
		}
				
	</script>
</body>
</html>