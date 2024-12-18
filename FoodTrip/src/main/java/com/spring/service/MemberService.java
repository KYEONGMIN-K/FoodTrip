package com.spring.service;

import java.util.List;

import com.spring.domain.Member;

public interface MemberService {

	Member getOneMember(Member member);
	void setNewMember(Member member);
	void setUpdateMember(Member member);
	void setDeleteMember(String email);
	boolean existMail(String id);
	boolean findOneNickName(String nickName);
	List<Member> getAllMembers(int offset, int limit, int memberlist);
	double getMemberCount();
	
}
