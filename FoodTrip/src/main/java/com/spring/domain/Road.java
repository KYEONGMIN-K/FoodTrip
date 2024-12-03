package com.spring.domain;

import java.util.ArrayList;

import org.springframework.web.multipart.MultipartFile;

public class Road {
	private int roadNum;
	private String roadMaker;
	private Marker startPoint;
	private String sPointStr;
	private Marker endPoint;
	private String ePointStr;
	private ArrayList<Marker> points;
	private String category;
//	private MultipartFile image;
//	private String imageName;
	
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
