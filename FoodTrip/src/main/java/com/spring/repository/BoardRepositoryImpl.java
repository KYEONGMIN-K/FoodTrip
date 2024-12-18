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
		System.out.println("setAddBoard() 실행 : 게시글 생성하기");
		String SQL = "INSERT INTO board (nickName, title, content, createTime, ip, depth) VALUES (?, ?, ?, ?, ?, ?)";
        template.update(SQL, board.getNickName(), board.getTitle(), board.getContent(), board.getCreateTime(), board.getIp(), board.getDepth());
	}
	
	
	// 게시글 목록 조회
    public List<Board> getAllBoards(int offset, int limit) {
    	System.out.println("getAllBoards() 실행 : 게시글 목록 조회하기");
        String SQL = "SELECT * FROM board WHERE depth = 1 ORDER BY createTime DESC LIMIT ? OFFSET ?";
        return template.query(SQL, new Object[]{limit, offset}, new BoardRowMapper());
    }
	
    // 전체 게시글 수 조회
    public int getBoardCount() {
    	System.out.println("getBoardCount() 실행 : 전체 게시글 수 조회하기");
        String SQL = "SELECT COUNT(*) FROM board WHERE depth = 1";
        return template.queryForObject(SQL, Integer.class);
    }
	
	
    // 게시글 상세 조회
    public Board getOneBoard(long brdNum) {
    	System.out.println("getOneMember() 실행 : 게시글 상세 조회하기");
        String SQL = "SELECT * FROM board WHERE brdNum = ?";
        List<Board> list = template.query(SQL, new Object[]{brdNum}, new BoardRowMapper());
        if(!list.isEmpty()) {
			return list.get(0);
		} else {
			return null;
		}
    }
	
    // 게시글 수정
    public void setUpdateBoard(Board board) {
    	System.out.println("setUpdateBoard() 실행 : 게시글 수정하기");
    	System.out.println("타이틀" + board.getTitle() + "// 내용" + board.getContent() + "//수정날짜" + board.getUpdateDay() + "//넘버" + board.getBrdNum());
        String SQL = "UPDATE board SET title = ?, content = ?, updateDay = ? WHERE brdNum = ?";
        template.update(SQL, board.getTitle(), board.getContent(), board.getUpdateDay(), board.getBrdNum());
    }
	
    // 게시글 삭제
    public void deleteBoard(long brdNum) {
    	System.out.println("deleteBoard() 실행 : 게시글 삭제하기");
        String SQL = """
        				WITH RECURSIVE DeleteTree AS (
					    -- 삭제 대상 게시글 찾기
					    SELECT brdNum
					    FROM board
					    WHERE brdNum = ?
					
					    UNION ALL
					
					    -- 삭제 대상의 하위 항목 찾기
					    SELECT b.brdNum
					    FROM board b
					    INNER JOIN DeleteTree dt ON b.parentNum = dt.brdNum
						)
						-- 실제 삭제 수행
						DELETE FROM board
						WHERE brdNum IN (SELECT brdNum FROM DeleteTree);
        			""";
        template.update(SQL, brdNum);
    }
	
	// 조회 수 증가
	public void setViews(long brdNum) {
		System.out.println("setViews() 실행 : 조회 수 증가하기");
		String SQL = "UPDATE board SET views=views+1 WHERE brdNum = ?";
		template.update(SQL,brdNum);
		
	}
	
	// 댓글/대댓글 생성
    public void addComment(Board comment) {
    	System.out.println("addComment() 실행 : 댓글/대댓글 생성하기");
        String SQL = "INSERT INTO board (parentNum, nickName, content, createTime, ip, depth) VALUES (?, ?, ?, ?, ?, ?)";
        template.update(SQL, comment.getParentNum(), comment.getNickName(), comment.getContent(), comment.getCreateTime(), comment.getIp(), comment.getDepth());
    }
    
    // 댓글/대댓글 수정
    public void updateComment(Board comment) {
    	System.out.println("updateComment() 실행 : 댓글/대댓글 수정하기");
        String SQL = "UPDATE board SET content = ?, updateDay = ? WHERE brdNum = ?";
        template.update(SQL, comment.getContent(), comment.getUpdateDay(), comment.getBrdNum());
    }

    // 댓글/대댓글 삭제
    public void deleteComment(long commentId) {
    	System.out.println("deleteComment() 실행 : 댓글/대댓글 삭제하기");
        String SQL = "UPDATE board SET content='삭제된 메시지입니다' WHERE brdNum=?";
        template.update(SQL, commentId);
    }
    // 댓글 조회 메서드
    public List<Board> getCommentsByBoardId(long boardId) {
    	System.out.println("getCommentByBoardId() 실행 : 댓글 조회 하기");
    	String SQL ="""
                WITH RECURSIVE CommentTree AS (
				    SELECT 
				        brdNum, 
				        parentNum, 
				        nickName, 
				        title, 
				        content,  
				        createTime, 
				        NULL AS updateDay, 
				        NULL AS ip, 
				        0 AS likes, 
				        0 AS views,
				        depth, 
			 			CAST(brdNum AS CHAR) AS path
						FROM board
		   				WHERE parentNum = ? AND depth = 2
					
					    UNION ALL
					
					    SELECT 
				        b.brdNum, 
				        b.parentNum, 
				        b.nickName, 
				        b.title, 
				        b.content,  
				        b.createTime, 
				        NULL AS updateDay, 
				        NULL AS ip, 
				        0 AS likes, 
				        0 AS views,
				        b.depth, 
				        CONCAT(ct.path, '-', CAST(b.brdNum AS CHAR)) AS path
					    FROM board b
					    INNER JOIN CommentTree ct ON b.parentNum = ct.brdNum
					    WHERE b.depth = 3
						)
						SELECT * 
						FROM CommentTree
						ORDER BY path, createTime
					""";
        return template.query(SQL, new Object[]{boardId}, new BoardRowMapper());
    }
}
