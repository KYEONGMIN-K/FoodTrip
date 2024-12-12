package com.spring.repository;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

import com.spring.domain.Road;

public class RoadRowMapper implements RowMapper<Road>{

	@Override
	public Road mapRow(ResultSet rs, int rowNum) throws SQLException {
		Road road = new Road();
		
		road.setRoadId(rs.getString(2));
		System.out.println("1번완");
		road.setUserNick(rs.getString(3));
		System.out.println("2번완");
		road.setCourseToString(rs.getString(4));
		System.out.println("3번완");
		road.setCourseSize(rs.getInt(5));
		System.out.println("4번완");
		road.setCategory(rs.getString(6));
		System.out.println("5번완");
		road.setDescription(rs.getString(7));
		
		road.setCreateTime(rs.getDate(8));
		System.out.println("6번완");
		road.setEndTime(rs.getDate(9));
		System.out.println("7번완");
		road.setCheckTimeToStrDB(rs.getString(10));
		System.out.println("8번완");
		
		return road;
	}

}
