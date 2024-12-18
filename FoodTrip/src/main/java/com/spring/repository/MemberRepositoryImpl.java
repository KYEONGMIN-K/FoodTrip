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
	
	// 회원정보 전체조회 : Read
	public List<Member> getAllmembers(int offset, int limit, int memberlist){
		System.out.println("getAllMembers() 실행 : 전체 회원 조회"); 
		System.out.println("멤버리스트 번호 : " + memberlist);
		if(memberlist==1) {
			System.out.println("가입 날짜 순 정렬");
			String SQL = "SELECT * FROM member ORDER BY joinDay DESC LIMIT ? OFFSET ?";
			members = template.query(SQL, new Object[] {limit, offset}, new MemberRowMapper());
		}else if(memberlist==2) {
			System.out.println("가나다 순 정렬");
			String SQL = "SELECT * FROM member ORDER BY nickName ASC LIMIT ? OFFSET ?";
			members = template.query(SQL, new Object[] {limit, offset}, new MemberRowMapper());
		}
		return members;
		
	}
	
	// 전체 회원 수 조회하기 : Read
	public double getMemberCount() {
		System.out.println("getMemberCount() 실행 : 전체 회원 수 조회하기");
		String SQL = "SELECT COUNT(*) FROM member";
		return template.queryForObject(SQL, Integer.class);
	}
	
	
	// 회원정보 수정하기 : Update
	public void setUpdateMember(Member member) {
		System.out.println("setUpdateMember() 실행 : 회원 수정 ");
		System.out.println("이메일 : " + member.getEmail());
		String SQL = "UPDATE MEMBER SET password=?, nickName=?, gender=?, age=?, badge=? where email=?";
		template.update(SQL, member.getPassword(), member.getNickName(), member.getGender(), member.getAge(), member.getBadgeName(), member.getEmail());
	}
	
	// 회원정보 삭제하기 : Delete
	public void setDeleteMember(String email) {
		System.out.println("setDeleteMember()실행 이메일 : " + email);
		String SQL = "DELETE FROM Member WHERE email = ?";
		template.update(SQL, email);
	}
	
	// 회원 메일 중복 확인
		public boolean existMail(String id) {
			String SQL = "SELECT * FROM member WHERE email = ?";
			List<Member> member = template.query(SQL, new Object[]{id},new MemberRowMapper());
			if(!member.isEmpty()) {
				return true;
			} else {
				return false;
			}
		}
		
		// 회원가입 닉네임 중복 확인
		public boolean findOneNickName(String nickName) {
			String SQL = "SELECT * FROM member WHERE nickName = ?";
			List<Member> member = template.query(SQL, new Object[]{nickName},new MemberRowMapper());
			if(!member.isEmpty()) {
				return true;
			}else {
				return false;
			}
			
		}

		
		
}
