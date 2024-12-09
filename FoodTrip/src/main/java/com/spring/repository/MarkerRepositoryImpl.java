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
		String remakeId = null;
		remakeId = idCreate(marker.getmarkerId());
		marker.setmarkerId(remakeId);
		
		String SQL = "INSERT INTO marker (markerId, pointX, pointY, category, pointName, phone, address, description, image) values(?,?,?,?,?,?,?,?,?)";
		template.update(SQL, marker.getmarkerId(), marker.getPointX(), marker.getPointY(), marker.getCategory(), marker.getPointName(), marker.getPhone(), marker.getAddress(), marker.getDescription(), marker.getImageName());
	}

	@Override
	public List<Marker> markerReadAll() {
		System.out.println("rdall repo IN");
		String SQL = "SELECT * FROM marker";
		List<Marker> list = template.query(SQL, new MarkerRowMapper());
		System.out.println("rdall repo Query END");
		return list;
	}
	
	
	
	@Override
	public Boolean isExist(String name, String addr) {
		System.out.println("exist? : " + name + " | "+ addr);
		String SQL = "SELECT * FROM marker where pointName=? and address=?";
		
		try {
			Marker marker = template.queryForObject(SQL, new Object[] {name, addr}, new MarkerRowMapper());
			if(marker != null && marker.getPointName().equals(name) && marker.getAddress().equals(addr)) {
				//존재한다.
				System.out.println("exist!!");
				return true;
			}
		}catch(Exception e) {
			System.out.println("no exist");
			return false;
		}
		return false;
	}

	@Override
	public Marker markerReadOne(String markerId) {
		
		String SQL = "SELECT * FROM marker where markerId=?";
		Marker marker = template.queryForObject(SQL, new Object[] {markerId},new MarkerRowMapper());
		
		return marker;
	}

	@Override
	public void markerUpdate(Marker marker) {
		System.out.println(marker.getPointName());
		if(marker.getImageName() != null) {
			String SQL = "update marker set pointX=?, pointY=?, category=?, pointName=?, phone=?, address=?, description=?, image=? where markerId=?";
			template.update(SQL, marker.getPointX(), marker.getPointY(), marker.getCategory(), marker.getPointName(), marker.getPhone(), marker.getAddress(), marker.getDescription(), marker.getImageName(), marker.getmarkerId());
		}else if(marker.getImageName() == null) {
			System.out.println("update image null IN");
			System.out.println(marker.getmarkerId());
			String SQL = "update marker set pointX=?, pointY=?, category=?, pointName=?, phone=?, address=?, description=? where markerId=?";
			template.update(SQL, marker.getPointX(), marker.getPointY(), marker.getCategory(), marker.getPointName(), marker.getPhone(), marker.getAddress(), marker.getDescription(), marker.getmarkerId());
		}
	}

	@Override
	public void markerDelete(String markerId) {
		String SQL = "delete from marker where markerId=?";
		template.update(SQL, markerId);		
	}

	public String idCreate(String id) {
		String SQL ="select num from marker order by num desc limit 0, 1";
		System.out.println(id);
		int num;
		try {
			num = template.queryForObject(SQL, Integer.class);
		}catch(Exception e) {
			num = 0;
		}

		System.out.println("return last : "+ num);
		num++;
		String result = Long.toString(num);
		String reId = id + result;
		
		return reId;
	}

}
