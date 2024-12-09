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
	
	public List<Board> getAllBoards(int pageNum, int limit) {
		// pageNum을 기반으로 offset과 limit을 계산한 뒤 Repository에서
		// 해당 페이지 데이터를 가져옴
		int offset = (pageNum - 1) * limit;
		return boardRepository.getAllBoards(offset, limit);
	}
	
	public List<Board> getOneboard(long brdNum) {
		 
		return (List<Board>) boardRepository.getOneBoard(brdNum);
	}
	
	public int getBoardCount(String items, String text) {
		return boardRepository.getBoardCount(items,text);
	}
	
	public void setAddBoard(Board board) {
		boardRepository.setAddBoard(board);
	}
	
	public void setViews(long brdNum) {
		boardRepository.setViews(brdNum);
	}
	
	public void setComment(Board board){
		boardRepository.setComment(board);
	}
	
	public void setUpdateBoard(Board board) {
		boardRepository.setUpdateBoard(board);
	}
}
