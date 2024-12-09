package com.spring.service;

import java.util.List;

import com.spring.domain.Board;

public interface BoardService {

	List<Board> getAllBoards(int pageNum, int limit);

	int getBoardCount(String items, String text);

	void setAddBoard(Board board);

	List<Board> getOneboard(long brdNum);

	void setViews(long brdNum);

	void setComment(Board board);

	void setUpdateBoard(Board board);

}
