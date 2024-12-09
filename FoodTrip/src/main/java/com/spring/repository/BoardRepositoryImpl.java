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
	
	public boolean isValidIp(String ip) {
	    try {
	        InetAddress.getByName(ip);
	        return true;
	    } catch (Exception e) {
	        return false;
	    }
	}
	
	// 전체 게시글을 조회 DB에서 10개씩 가져옴
	public List<Board> getAllBoards(int offset, int limit) {
		// offset과 limit 값 검증
	    if (offset < 0) offset = 0;
	    if (limit <= 0) limit = 10;
		
		String SQL = "SELECT * FROM board WHERE parentNum is null ORDER BY createTime DESC LIMIT ? OFFSET ?";
	    return template.query(SQL, new Object[]{limit, offset}, new BoardRowMapper());
	}
	
	// 전체 게시글 수를 조회
	public int getBoardCount(String items, String text) {	
		String SQL;
		if(items==null&&text==null) {
			return this.template.queryForObject("SELECT COUNT(*) FROM Board WHERE parentNum is null", Integer.class);
		}
		else {
			return this.template.queryForObject("SELECT COUNT(*) FROM Board WHERE parent IS NULL AND items = ? AND text = ?",new Object[] {items,text}, Integer.class);
		}
	}
	// 게시글 생성
	public void setAddBoard(Board board) {
		String SQL = "INSERT INTO board ( brdNum, nickName, title, content, createTime, ip) VALUES (?,?, ?, ?, ?, ?)";
		template.update(SQL, board.getBrdNum(),board.getNickName(), board.getTitle(), board.getContent(), board.getCreateTime(), board.getIp());
		isValidIp(board.getIp());
	}
	
	// 한 개의 게시글을 조회
	public List<Board> getOneBoard(long brdNum) {
		
		System.out.println("getOneBoard() 실행 : 한 개의 게시글 상세보기");
		String SQL = "SELECT * "
						+ "FROM board "
							+ "WHERE brdNum = ? or parentNum = ? "
							+ "ORDER BY "
							+ "depth ASC,"
							+ "createTime ASC ";
		brd = template.query(SQL, new Object[] {brdNum,brdNum},new BoardRowMapper());
		return brd;
	}
	
	// 게시글 수정 : Update
	public void setUpdateBoard(Board board) {
		System.out.println("setUpdateBoard() 실행 : 게시글 수정");
		String SQL = "Update board SET title=?, content=? WHERE brdNum=?";
		template.update(SQL, board.getTitle(), board.getContent(), board.getBrdNum());
	}
	
	// 조회 수 증가
	public void setViews(long brdNum) {
		String SQL = "UPDATE board SET views=views+1 WHERE brdNum = ?";
		template.update(SQL,brdNum);
		
	}
	
	// 댓글 삽입
	public void setComment(Board board){
		String SQL = "INSERT INTO board(parentNum, title, nickName, content, createTime, ip, depth) VALUES(?,?,?,?,?,?,?)";	
		board.setTitle("댓글");
		template.update(SQL, board.getParentNum(), board.getTitle(), board.getNickName(), board.getContent(), board.getCreateTime(), board.getIp(),board.getDepth());
	}
	
	
}
