package com.spring.repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.spring.domain.Member;

@Repository
public class MemberRepositoryImpl implements MemberRepository {

	private JdbcTemplate template;
	private List<Member> members = new ArrayList<Member>();
	
	@Autowired
	public void setTempalte(DataSource dataSource) {
		this.template = new JdbcTemplate(dataSource);
	}
	
	// 회원 생성하기 : Create
	public void setNewMember(Member member) {
		System.out.println("setNewMember()실행 : 회원 생성");
		String SQL = "INSERT INTO MEMBER values(?,?,?,?,?,?,?)";
		System.out.println("1 : " + member.getEmail());
		System.out.println("2 : " + member.getPassword());
		System.out.println("3 : " + member.getNickName());
		System.out.println("4 : " + member.getGender());
		System.out.println("5 : " + member.getAge());
		System.out.println("6 : " + member.getBadgeName());
		System.out.println("7 : " + member.getJoinDay());
		
		template.update(SQL, member.getEmail(), member.getPassword(), member.getNickName(), member.getGender(), member.getAge(), member.getBadgeName(), member.getJoinDay());
	}
	
	// 회원 조회하기 (1인) : Read 
	public Member getOneMember(Member member) {
		System.out.println("getOneMember()실행 : 회원 조회");
		String email = member.getEmail();
		String password = member.getPassword();
		System.out.println(email);
		System.out.println(password);
		String SQL = "SELECT * FROM member WHERE email=? AND password=?";
		List<Member> members = template.query(SQL, new Object[]{email, password}, new MemberRowMapper());
		if(!members.isEmpty()) {
			return members.get(0);
		} else {
			return null;
		}
		
	}
	
	// 회원정보 수정하기 : Update
	public void setUpdateMember(Member member) {
		System.out.println("setUpdateMember() 실행 : 회원 수정 ");
		System.out.println("이메일 : " + member.getEmail());
		String SQL = "UPDATE MEMBER SET password=?, nickName=?, gender=?, age=?, badge=? where email=?";
		template.update(SQL, member.getPassword(), member.getNickName(), member.getGender(), member.getAge(), member.getBadgeName(), member.getEmail());
	}
	
	public void setDeleteMember(String email) {
		System.out.println("setDeleteMember()실행 이메일 : " + email);
		String SQL = "DELETE FROM Member WHERE email = ?";
		template.update(SQL, email);
	}
}
