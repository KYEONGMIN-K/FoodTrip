package com.spring.repository;

import java.net.InetAddress;
import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.spring.domain.Board;

@Repository
public class BoardRepositoryImpl implements BoardRepository{
	
	private JdbcTemplate template;
	private List<Board> brd = new ArrayList<Board>();
	
	@Autowired
	public void setTemplate(DataSource dataSource) {
		this.template = new JdbcTemplate(dataSource);
	}
	
	
	// 게시글 생성
	public void setAddBoard(Board board) {
		String SQL = "INSERT INTO board (nickName, title, content, createTime, ip, depth) VALUES (?, ?, ?, ?, ?, ?)";
        template.update(SQL, board.getNickName(), board.getTitle(), board.getContent(), board.getCreateTime(), board.getIp(), board.getDepth());
	}
	
	
	// 게시글 목록 조회
    public List<Board> getAllBoards(int offset, int limit) {
        String SQL = "SELECT * FROM board WHERE depth = 1 ORDER BY createTime DESC LIMIT ? OFFSET ?";
        return template.query(SQL, new Object[]{limit, offset}, new BoardRowMapper());
    }
	
    // 전체 게시글 수 조회
    public int getBoardCount() {
        String SQL = "SELECT COUNT(*) FROM board WHERE depth = 1";
        return template.queryForObject(SQL, Integer.class);
    }
	
	
    // 게시글 상세 조회
    public Board getOneBoard(long brdNum) {
        String SQL = "SELECT * FROM board WHERE brdNum = ?";
        List<Board> list = template.query(SQL, new Object[]{brdNum}, new BoardRowMapper());
        return list.isEmpty() ? null : list.get(0);
    }
	
    // 게시글 수정
    public void setUpdateBoard(Board board) {
        String SQL = "UPDATE board SET title = ?, content = ?, updateDay = ? WHERE brdNum = ?";
        template.update(SQL, board.getTitle(), board.getContent(), board.getUpdateDay(), board.getBrdNum());
    }
	
    // 게시글 삭제
    public void deleteBoard(long brdNum) {
        String SQL = "DELETE FROM board WHERE brdNum = ?";
        template.update(SQL, brdNum);
    }
	
	// 조회 수 증가
	public void setViews(long brdNum) {
		String SQL = "UPDATE board SET views=views+1 WHERE brdNum = ?";
		template.update(SQL,brdNum);
		
	}
	
	// 댓글/대댓글 생성
    public void addComment(Board comment) {
        String SQL = "INSERT INTO board (parentNum, nickName, content, createTime, ip, depth) VALUES (?, ?, ?, ?, ?, ?)";
        template.update(SQL, comment.getParentNum(), comment.getNickName(), comment.getContent(), comment.getCreateTime(), comment.getIp(), comment.getDepth());
    }
    
    // 댓글/대댓글 수정
    public void updateComment(Board comment) {
        String SQL = "UPDATE board SET content = ?, updateDay = ? WHERE brdNum = ?";
        template.update(SQL, comment.getContent(), comment.getUpdateDay(), comment.getBrdNum());
    }

    // 댓글/대댓글 삭제
    public void deleteComment(long commentId) {
        String SQL = "UPDATE board SET content='삭제된 메시지입니다' WHERE brdNum=?";
        template.update(SQL, commentId);
    }
    // 댓글 조회 메서드
    public List<Board> getCommentsByBoardId(long boardId) {
    	String SQL = """
    	        WITH RECURSIVE CommentTree AS (
    	            -- 댓글 가져오기 (parentNum이 게시글 번호이고 depth=2)
    	            SELECT brdNum, parentNum, content, depth, createTime, updateDay, ip, likes, views,
    	                   CAST(brdNum AS CHAR) AS path
    	            FROM board
    	            WHERE parentNum = ? AND depth = 2

    	            UNION ALL

    	            SELECT b.brdNum, b.parentNum, b.content, b.depth, b.createTime, b.updateDay, b.ip, b.likes, b.views,
    	                   CONCAT(ct.path, '-', b.brdNum) AS path
    	            FROM board b
    	            INNER JOIN CommentTree ct ON b.parentNum = ct.brdNum
    	            WHERE b.depth = 3
    	        )
    	        SELECT *
    	        FROM CommentTree
    	        ORDER BY path, createTime;
    	    """;
        return template.query(SQL, new Object[]{boardId}, new BoardRowMapper());
    }
}
