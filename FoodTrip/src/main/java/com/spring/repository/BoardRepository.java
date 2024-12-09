package com.spring.repository;

import java.util.List;

import com.spring.domain.Board;

public interface BoardRepository {

	List<Board> getAllBoards(int offset, int limit);

	int getBoardCount(String items, String text);

	void setAddBoard(Board board);

	List<Board> getOneBoard(long brdNum);

	void setViews(long brdNum);

	void setComment(Board board);

	void setUpdateBoard(Board board);

}
