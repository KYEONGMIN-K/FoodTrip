package com.spring.controller;

import java.sql.Timestamp;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.domain.Board;
import com.spring.domain.Member;
import com.spring.service.BoardService;

@Controller
public class BoardController {

	@Autowired
	private BoardService boardService;
	
	// 게시판 게시글 생성 : Create
	@GetMapping("/addBoard")
	public String addBoard(@ModelAttribute("addBrd")Board board, Member member,HttpServletRequest request) {
		System.out.println("/addBoard()실행 : 게시글 작성 폼 제공");
		HttpSession session;
		session = request.getSession(false);
		Member sessionId = (Member)session.getAttribute("sessionId");
		if(sessionId == null) {
			return "redirect:/login";
		}
		System.out.println(sessionId.getEmail());
		return "/Board/addBoard";
	}
	
	// 게시글 생성 
	@PostMapping("/addBoard")
	public String submitBoard(@ModelAttribute("addBrd")Board board,HttpServletRequest request) {
		System.out.println("submitBoard() 실행 : 게시글 생성 시작");
		// Ip 주소를 저장
		board.setIp(request.getRemoteAddr());
		// 게시글 작성 시간을 저장
		Timestamp time = new Timestamp(System.currentTimeMillis());
	    board.setCreateTime(time);
	    
	    boardService.setAddBoard(board);
		return "redirect:/boards";
	}
	
	// 게시판 게시글 전체 조회 : Read
	@GetMapping("/boards")     //파라미터가 필수요소가 아님을 설정, 기본값 1 설정
	public String getAllBoards(@RequestParam(value = "pageNum", required = false, defaultValue = "1")int pageNum,Model model,HttpServletRequest request) {
		System.out.println("getAllBoards()실행 : 게시글 조회");
		
		int limit=10; // 한 페이지에 표시할 게시글 수
		
		
		String items = request.getParameter("items");
		String text = request.getParameter("text");
		
		// 전체 게시글 수와 전체 페이지 수 계산
		int total_record = boardService.getBoardCount(items, text);
		List<Board> arrbrd = boardService.getAllBoards(pageNum, limit);		
		
		int total_page;
		
		if(total_record % limit==0) {
			total_page = total_record/limit;
			Math.floor(total_page);
		}
		else {
			total_page = total_record/limit;
			Math.floor(total_page);
			total_page = total_page+1;
		}
		System.out.println("토탈페이지 : " +  total_page);
		System.out.println("토탈레코드 : " + total_record);
		System.out.println("페이지넘 : " + pageNum);
		
		request.setAttribute("pageNum", pageNum);		  
   		request.setAttribute("total_page", total_page);   
		request.setAttribute("total_record",total_record); 
		model.addAttribute("brd",arrbrd);
		
		return "Board/Boards"; 
	}
	
	// 게시글 조회 (1개)
	
	@GetMapping("/BoardView")
	public String boardView(
							@RequestParam("num") long brdNum,
							@RequestParam("pageNum") int pageNum,
							Board board, Model model,HttpServletRequest request) 
	{	
		board.setBrdNum(brdNum);
		List<Board> list = boardService.getOneboard(brdNum);
		for(int i=0; i<list.size(); i++) {
			board = list.get(i);
			if(board.isPost()) {
				model.addAttribute("list", list);	// 게시글 처리			
			}
			else if(board.isComment()) {
				model.addAttribute("list", list);	// 댓글 처리
			}
			else if(board.isReply()) {
				model.addAttribute("list", list);	// 대댓글 처리
			}
		}
		HttpSession session = request.getSession(false);
		Member sessionId = (Member)session.getAttribute("sessionId");
		if(sessionId == null){
			return "redirect:/login";
		} 
		
		boardService.setViews(brdNum);
		return "Board/BoardView";
	}
	
	// 댓글, 대댓글 생성 : Create
	@ResponseBody
	@PostMapping("/comment")
	public void comment(@RequestBody HashMap<String,Object> map,
						HttpServletRequest request,
						Long brdNum,
						Integer depth,
						Board board) {
		System.out.println("comment() 실행");
		System.out.println(map.get("nickName"));
		System.out.println(map.get("content"));
		
	
		String nick = (String)map.get("nickName");
		String content = (String)map.get("content");
		brdNum = Long.valueOf(map.get("brdNum").toString());
	    depth = Integer.valueOf(map.get("depth").toString());
		board.setNickName(nick);	// 회원 닉네임
		board.setContent(content);	// 댓글 내용
		board.setParentNum(brdNum);	// 부모 게시글
		board.setDepth(depth);		// 계층설정
		Timestamp time = new Timestamp(System.currentTimeMillis());
	    board.setCreateTime(time);	// 작성시간
	    board.setIp(request.getRemoteAddr());	// 유저IP
	    
		System.out.println(brdNum +" : " + depth);
		boardService.setComment(board);
	}
	
	// 게시판 수정 : Update
	// 게시판 삭제 : Delete
	
	
	
}
