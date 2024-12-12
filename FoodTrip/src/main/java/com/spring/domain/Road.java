package com.spring.domain;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

public class Road {
	private String roadId;
	private String userNick;
	private String course[];
	private String courseToString;
	private int courseSize;
	private String category;
	private ArrayList<Marker> points;	//마커 정보를 담고 있는 배열
	private Date createTime;
	private Date endTime;
	private Date[] checkTime;
	private String checkTimeToStrDB;
	private String description;
	
	public String getRoadId() {
		return roadId;
	}
	public void setRoadId(String roadId) {
		this.roadId = roadId;
	}
	public String getUserNick() {
		return userNick;
	}
	public void setUserNick(String userNick) {
		this.userNick = userNick;
	}
	public String[] getCourse() {
		return course;
	}
	public void setCourse(String[] course) {
		setCourseToString(course);
		this.course = course;
	}
	public int getCourseSize() {
		return courseSize;
	}
	public void setCourseSize(int courseSize) {
		this.courseSize = courseSize;
	}
	public ArrayList<Marker> getPoints() {
		return points;
	}
	public void setPoints(ArrayList<Marker> points) {
		this.points = points;
	}
	public String getCategory() {
		return category;
	}
	public void setCategory(String category) {
		this.category = category;
	}
	public Date getCreateTime() {
		return createTime;
	}
	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}
	public Date getEndTime() {
		return endTime;
	}
	public void setEndTime(Date endTime) {
		this.endTime = endTime;
	}
	public Date[] getCheckTime() {
		return checkTime;
	}
	public void setCheckTime(Date[] checkTime) {
		this.checkTime = checkTime;
	}
	public String getCourseToString() {
		return courseToString;
	}
	public void setCourseToString(String[] courseToString) {
		this.courseToString = String.join(",", courseToString);
	}	
	public String getCheckTimeToStrDB() {
		return checkTimeToStrDB;
	}
	public void setCheckTimeToStrDB(String checkTimeToStrDB) {
		this.checkTimeToStrDB = checkTimeToStrDB;
	}
	public void setCourseToString(String courseToString) {
		this.courseToString = courseToString;
		StringToCourse();
	}
	
	public void StringToCourse() {
		//course = new String[courseSize];
		this.course = courseToString.split(",");		
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	
	
	
/*
	private String roadMaker;
	private Marker startPoint;
	private String sPointStr;
	private Marker endPoint;
	private String ePointStr;
*/
	
//	private MultipartFile image;
//	private String imageName;
/*	
	public Marker getStartPoint() {
		return startPoint;
	}
	public void setStartPoint(Marker startPoint) {
		this.startPoint = startPoint;
	}
	public Marker getEndPoint() {
		return endPoint;
	}
	public void setEndPoint(Marker endPoint) {
		this.endPoint = endPoint;
	}*/
/*	
	public MultipartFile getImage() {
		return image;
	}
	public void setImage(MultipartFile image) {
		this.image = image;
	}
	public String getImageName() {
		return imageName;
	}
	public void setImageName(String imageName) {
		this.imageName = imageName;
	}
	*/
}
