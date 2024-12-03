package com.spring.repository;

import com.spring.domain.*;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

public class MarkerRowMapper implements RowMapper<Marker>{

	@Override
	public Marker mapRow(ResultSet rs, int rowNum) throws SQLException {
		Marker marker = new Marker();
		
		marker.setmarkerId(rs.getString(1));
		marker.setPointX(rs.getDouble(2));
		marker.setPointY(rs.getDouble(3));
		marker.setCategory(rs.getString(4));
		marker.setPointName(rs.getString(5));
		marker.setPhone(rs.getString(6));
		marker.setAddress(rs.getString(7));
		marker.setDescription(rs.getString(8));
		marker.setImageName(rs.getString(9));
		
		return marker;
	}

}
