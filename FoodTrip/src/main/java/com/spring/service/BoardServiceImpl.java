package com.spring.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.domain.Board;
import com.spring.repository.BoardRepository;

@Service
public class BoardServiceImpl implements BoardService {

	@Autowired
	private BoardRepository boardRepository;
	
	// 게시글 생성
	public void setAddBoard(Board board) {
		boardRepository.setAddBoard(board);
	}
	// 게시글 목록 조회
	public List<Board> getAllBoards(int offset, int limit) {
		return boardRepository.getAllBoards(offset, limit);
	}
	// 전체 게시글 수 조회
	public int getBoardCount() {
		return boardRepository.getBoardCount();
	}
	// 게시글 상세 조회
	public Board getOneBoard(long brdNum) {
		return boardRepository.getOneBoard(brdNum);
	}
	// 게시글 수정
	public void setUpdateBoard(Board board) {
		boardRepository.setUpdateBoard(board);
	}
	// 게시글 삭제
	public void deleteBoard(long brdNum) {
		boardRepository.deleteBoard(brdNum);
	}
	// 조회수 증가
	public void setViews(long brdNum) {
		boardRepository.setViews(brdNum);
	}
	// 댓글/대댓글 생성
	public void addComment(Board board){
		boardRepository.addComment(board);
	}
	// 댓글/대댓글 수정
    public void updateComment(Board comment) {
        boardRepository.updateComment(comment);
    }

    // 댓글/대댓글 삭제
    public void deleteComment(long commentId) {
        boardRepository.deleteComment(commentId);
    }
    // 댓글 조회 메서드
    public List<Board> getCommentsByBoardId(long boardId) {
        return boardRepository.getCommentsByBoardId(boardId);
    }
	
	
}
