package com.spring.repository;

import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

//import org.apache.tomcat.jdbc.pool.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.spring.domain.Marker;

@Repository
public class MarkerRepositoryImpl implements MarkerRepository{

	private JdbcTemplate template;
	
	List<Marker> listOfMarker = new ArrayList<Marker>();
	
	@Autowired
	public void setJdbctemplate(DataSource dataSource) {
		this.template = new JdbcTemplate(dataSource);
	}
	
	@Override
	public void markerCreate(Marker marker) {

		String SQL = "INSERT INTO marker (markerId, pointX, pointY, category, pointName, phone, address, description, image) values(?,?,?,?,?,?,?,?,?)";
		template.update(SQL, marker.getmarkerId(), marker.getPointX(), marker.getPointY(), marker.getCategory(), marker.getPointName(), marker.getPhone(), marker.getAddress(), marker.getDescription(), marker.getImageName());
	}

	@Override
	public List<Marker> markerReadAll() {
		
		String SQL = "SELECT * FROM marker";
		List<Marker> list = template.query(SQL, new MarkerRowMapper());
		
		return list;
	}
	
	@Override
	public Marker markerReadOne(String markerId) {
		
		String SQL = "SELECT * FROM marker where markerId=?";
		Marker marker = template.queryForObject(SQL, new Object[] {markerId},new MarkerRowMapper());
		
		return marker;
	}

	@Override
	public void markerUpdate(Marker marker) {
		
		if(marker.getImageName() != null) {
			String SQL = "update marker set pointX=?, pointY=?, category=?, pointName=?, phone=?, address=?, description=?, image=? where markerId=?";
			template.update(SQL, marker.getPointX(), marker.getPointY(), marker.getCategory(), marker.getPointName(), marker.getPhone(), marker.getAddress(), marker.getDescription(), marker.getImageName(), marker.getmarkerId());
		}else if(marker.getImageName() == null) {
			String SQL = "update marker set pointX=?, pointY=?, category=?, pointName=?, phone=?, address=?, description=? where markerId=?";
			template.update(SQL, marker.getPointX(), marker.getPointY(), marker.getCategory(), marker.getPointName(), marker.getPhone(), marker.getAddress(), marker.getDescription(), marker.getmarkerId());
		}
	}

	@Override
	public void markerDelete(String markerId) {
		String SQL = "delete from marker where markerId=?";
		template.update(SQL, markerId);		
	}


}
