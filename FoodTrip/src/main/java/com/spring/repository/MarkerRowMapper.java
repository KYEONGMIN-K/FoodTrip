package com.spring.repository;

import com.spring.domain.*;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

public class MarkerRowMapper implements RowMapper<Marker>{

	@Override
	public Marker mapRow(ResultSet rs, int rowNum) throws SQLException {
		Marker marker = new Marker();
		
		marker.setmarkerId(rs.getString(2));
		marker.setPointX(rs.getDouble(3));
		marker.setPointY(rs.getDouble(4));
		marker.setCategory(rs.getString(5));
		marker.setPointName(rs.getString(6));
		marker.setPhone(rs.getString(7));
		marker.setAddress(rs.getString(8));
		marker.setDescription(rs.getString(9));
		marker.setImageName(rs.getString(10));
		
		return marker;
	}

}
