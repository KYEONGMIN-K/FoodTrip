package com.spring.domain;

import java.sql.Timestamp;

public class Board {

	private long brdNum;         	// 게시글 번호 (Primary Key)
    private long parentNum;     	// 부모 게시글 번호 (null이면 최상위 게시글)
    private String nickName;       	// 작성자 이메일
    private String title;        	// 게시글 제목
    private String content;      	// 게시글 내용
    private String createTime;	// 작성 날짜 및 시간
    private String ip;          	// 작성자 IP 주소
    private int likes;       		// 좋아요 수
    private int views;      		// 조회 수
    private int depth;      		// 계층 깊이 (1: 게시글, 2: 댓글, 3: 답글)
    private String updateDay;	// 게시글 수정 날짜
    private String path;         // 댓글 계층 구조를 나타내는 경로
    



	public Board() {}
    
	public Board(long brdNum, long parentNum, String nickName, String title, String content, String createTime,
			String ip, int likes, int views, int depth, String updateDay, String path) {
		super();
		this.brdNum = brdNum;
		this.parentNum = parentNum;
		this.nickName = nickName;
		this.title = title;
		this.content = content;
		this.createTime = createTime;
		this.ip = ip;
		this.likes = likes;
		this.views = views;
		this.depth = depth;
		this.updateDay = updateDay;
		this.path = path;
	}
	
    public Board(long brdNum, String nickName, String title, String createTime, int likes, int views) {
		this.brdNum = brdNum;
		this.nickName = nickName;
		this.title = title;
		this.createTime = createTime;
		this.likes = likes;
		this.views = views;
	}

	// Getter & Setter

    public String getPath() {
    	return path;
    }
    
    public void setPath(String path) {
    	this.path = path;
    }
    public String getUpdateDay() {
    	return updateDay;
    }
    
    public void setUpdateDay(String updateDay) {
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

	public String getCreateTime() {
		return createTime;
	}

	public void setCreateTime(String formattime) {
		this.createTime = formattime;
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
