package com.spring.controller;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
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
	public String addBoard(@ModelAttribute("addBrd")Board board,HttpSession session) {// Member member,HttpServletRequest request
		System.out.println("/addBoard()실행 : 게시글 작성 폼 제공");
		Member sessionId = (Member) session.getAttribute("sessionId");
        if (sessionId == null) {
            return "redirect:/login";
        }
		System.out.println(sessionId.getEmail());
		return "/Board/addBoard";
	}
	
	
	@PostMapping("/addBoard")
	public String submitBoard(@ModelAttribute("addBrd")Board board,HttpSession session, HttpServletRequest request) {
		System.out.println("submitBoard() 실행 : 게시글 생성 시작");
		Member sessionId = (Member) session.getAttribute("sessionId");
        if (sessionId == null) {
            return "redirect:/login";
        }
		// Ip 주소를 저장
		board.setIp(request.getRemoteAddr());
		// 게시글 작성 시간을 저장
		board.setNickName(sessionId.getNickName());
        board.setCreateTime(new SimpleDateFormat("yyyy-MM-dd HH:mm").format(new Timestamp(System.currentTimeMillis())));
        board.setDepth(1); // 게시글은 depth 1
        boardService.setAddBoard(board);

		return "redirect:/boards";
	}
	
	// 게시판 게시글 전체 조회 : ReadAll
	@GetMapping("/boards")     //파라미터가 필수요소가 아님을 설정, 기본값 1 설정
	public String getAllBoards(@RequestParam(value = "pageNum", required = false, defaultValue = "1")int pageNum,Model model,HttpServletRequest request) {
		System.out.println("getAllBoards()실행 : 게시글 조회");
		
		int limit=10; // 한 페이지에 표시할 게시글 수
		List<Board> boardList = boardService.getAllBoards((pageNum - 1) * limit, limit);
        int totalPage = (int) Math.ceil((double) boardService.getBoardCount() / limit);

        model.addAttribute("boardList", boardList);
        model.addAttribute("pageNum", pageNum);
        model.addAttribute("totalPage", totalPage);
        return "Board/Boards"; 
		
		
	
	}
	
	// 게시글 조회 (1개) : ReadOne
	@GetMapping("/BoardView")
	public String boardView(@RequestParam("num") long brdNum,HttpSession session,
							Model model) 
	{	// @RequestParam("pageNum") int pageNum, Board board, HttpServletRequest request
		
		Board board = boardService.getOneBoard(brdNum);
	    if (board == null) {
	        return "redirect:/boards"; // 게시글이 없는 경우 목록으로 리다이렉트
	    }
	    Member sessionId = (Member) session.getAttribute("sessionId");
	    if (sessionId == null || !board.getNickName().equals(sessionId.getNickName())) {
	    	return "redirect:/login";
	    }
	    
	    
	    // 댓글 조회
	    List<Board> comments = boardService.getCommentsByBoardId(brdNum);
	    if (comments == null) {
	        comments = new ArrayList<>(); // null 방지를 위해 빈 리스트로 초기화
	    }

	    model.addAttribute("board", board);
	    model.addAttribute("comments", comments);
	    boardService.setViews(brdNum); // 조회수 증가
	    return "Board/BoardView";
		
		
		
	}
	
	// 게시글 수정 : Update
	@GetMapping("/updateBoard")
	public String updateBoard(@ModelAttribute("uptBrd") Board board, @RequestParam("num") long brdNum,Model model,HttpSession session) { // @ModelAttribute("uptBrd") Board board,	@RequestParam("num") long brdNum, @RequestParam("pageNum") int pageNum,	Model model,HttpServletRequest request
		System.out.println("updateBoard()실행 : 게시글 수정 폼 제공");
		
		Member sessionId = (Member) session.getAttribute("sessionId");
        if (sessionId == null) {
            return "redirect:/login";
        }

        board = boardService.getOneBoard(brdNum);
        if (board == null || !board.getNickName().equals(sessionId.getNickName())) {
            return "redirect:/boards";
        }

        model.addAttribute("board", board);
        return "Board/updateBoard";

	}

	@PostMapping("/updateBoard")
	public String submitUpdateBoard(@ModelAttribute("uptBrd") Board board, HttpSession session) { // @RequestParam("num")long brdNum
		System.out.println("submitUpdateBoard() 실행 : 게시글 수정 시작");
		Member sessionId = (Member) session.getAttribute("sessionId");
		if (sessionId == null || !board.getNickName().equals(sessionId.getNickName())) {
	           return "redirect:/login";
		}

		board.setUpdateDay(new SimpleDateFormat("yyyy-MM-dd HH:mm").format(new Timestamp(System.currentTimeMillis())));
		boardService.setUpdateBoard(board);

		return "redirect:/BoardView?num=" + board.getBrdNum();
		
	}
	
	// 게시판 삭제 : Delete
	@GetMapping("/deleteBoard")
	public String deleteBoard(@RequestParam("num")long brdNum, HttpSession session) { // Board board
		Member sessionId = (Member) session.getAttribute("sessionId");
        if (sessionId == null) {
            return "redirect:/login";
        }

        Board board = boardService.getOneBoard(brdNum);
        if (board != null && board.getNickName().equals(sessionId.getNickName())) {
            boardService.deleteBoard(brdNum);
        }

        return "redirect:/boards";

	}
	
	

	// 댓글, 대댓글 생성 : Create
	@ResponseBody
	@PostMapping("/comment")
	public String comment(@RequestBody HashMap<String,Object> map, HttpServletRequest request) { 
		System.out.println("comment() 실행");
		
		Board comment = new Board();
        comment.setNickName(map.get("nickName").toString());
        comment.setContent(map.get("content").toString());
        comment.setParentNum(Long.parseLong(map.get("parentNum").toString()));
        comment.setDepth(Integer.parseInt(map.get("depth").toString()));
        comment.setCreateTime(new SimpleDateFormat("yyyy-MM-dd HH:mm").format(new Timestamp(System.currentTimeMillis())));
        comment.setIp(request.getRemoteAddr());
        boardService.addComment(comment);
        return "success";
		
	}
	
	// 댓글 수정 : Update
	@ResponseBody
	@PutMapping("/comment")
	public String updateComment(@RequestBody HashMap<String,Object> map) {
		System.out.println("updateComment() 실행 : 댓글 수정");
		Board brd = new Board();
		brd.setBrdNum(Long.parseLong(map.get("brdNum").toString()));
		brd.setContent(map.get("content").toString());
		brd.setUpdateDay(new SimpleDateFormat("yyyy-MM-dd HH:mm").format(new Timestamp(System.currentTimeMillis())));
		
		boardService.updateComment(brd);
		return "success";
	}
	
	// 댓글 삭제 : Delete
	@ResponseBody
	@DeleteMapping("/comment/{id}")
	public String deleteComment(@PathVariable("id") long commentId) {
		System.out.println("deleteComment() 실행 : 댓글삭제");
		boardService.deleteComment(commentId);
		return "success";
	}
	
}
