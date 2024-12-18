package com.spring.repository;

import java.util.List;

import com.spring.domain.Board;

public interface BoardRepository {

	void setAddBoard(Board board);
	List<Board> getAllBoards(int offset, int limit);
	int getBoardCount();
	Board getOneBoard(long brdNum);
	void setUpdateBoard(Board board);
	void deleteBoard(long brdNum);
	void setViews(long brdNum);


	void addComment(Board board);
	void updateComment(Board board);
	void deleteComment(long commentId);
	List<Board> getCommentsByBoardId(long boardId);
}
