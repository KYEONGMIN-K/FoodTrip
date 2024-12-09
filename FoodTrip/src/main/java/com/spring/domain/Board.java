package com.spring.domain;

import java.sql.Timestamp;

public class Board {

	private long brdNum;         	// 게시글 번호 (Primary Key)
    private long parentNum;     	// 부모 게시글 번호 (null이면 최상위 게시글)
    private String nickName;       	// 작성자 이메일
    private String title;        	// 게시글 제목
    private String content;      	// 게시글 내용
    private Timestamp createTime;	// 작성 날짜 및 시간
    private String ip;          	// 작성자 IP 주소
    private int likes;       		// 좋아요 수
    private int views;      		// 조회 수
    private int depth;      		// 계층 깊이 (1: 게시글, 2: 댓글, 3: 답글)
    private Timestamp updateDay;	// 게시글 수정 날짜
    

	public Board() {}
    
    public Board(long brdNum, String nickName, String title, Timestamp createTime, int likes, int views) {
		this.brdNum = brdNum;
		this.nickName = nickName;
		this.title = title;
		this.createTime = createTime;
		this.likes = likes;
		this.views = views;
	}

	// Getter & Setter
    public Timestamp getUpdateDay() {
    	return updateDay;
    }
    
    public void setUpdateDay(Timestamp updateDay) {
    	this.updateDay = updateDay;
    }
	public long getBrdNum() {
		return brdNum;
	}

	public void setBrdNum(long brdNum) {
		this.brdNum = brdNum;
	}

	public long getParentNum() {
		return parentNum;
	}

	public void setParentNum(long parentNum) {
		this.parentNum = parentNum;
	}

	public String getNickName() {
		return nickName;
	}

	public void setNickName(String nickName) {
		this.nickName = nickName;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public Timestamp getCreateTime() {
		return createTime;
	}

	public void setCreateTime(Timestamp createTime) {
		this.createTime = createTime;
	}

	public String getIp() {
		return ip;
	}

	public void setIp(String ip) {
		this.ip = ip;
	}

	public int getLikes() {
		return likes;
	}

	public void setLikes(int likes) {
		this.likes = likes;
	}

	public int getViews() {
		return views;
	}

	public void setViews(int views) {
		this.views = views;
	}

	public int getDepth() {
		return depth;
	}

	public void setDepth(int depth) {
		this.depth = depth;
	}
    
	// 추가: 역할 구분
    public boolean isPost() {
        return depth == 1;
    }

    public boolean isComment() {
        return depth == 2;
    }

    public boolean isReply() {
        return depth == 3;
    }
}	
