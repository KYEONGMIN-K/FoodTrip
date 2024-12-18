package com.spring.repository;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

import com.spring.domain.Member;

public class MemberRowMapper implements RowMapper<Member>{

	@Override
	public Member mapRow(ResultSet rs, int rowNum) throws SQLException {
		System.out.println("Member의 mapRow() 실행");
		Member mb = new Member();
		mb.setEmail(rs.getString(1));
		System.out.println("이메일 : " + rs.getString(1));
		mb.setPassword(rs.getString(2));
		mb.setNickName(rs.getString(3));
		mb.setGender(rs.getString(4));
		mb.setAge(rs.getInt(5));
		mb.setBadgeName(rs.getString(6));
		mb.setJoinDay(rs.getTimestamp(7));
		return mb;
	}

}
