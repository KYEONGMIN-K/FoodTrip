package com.spring.repository;

import java.util.List;

import com.spring.domain.Member;

public interface MemberRepository {
	Member getOneMember(Member member);

	void setNewMember(Member member);

	void setUpdateMember(Member member);

	void setDeleteMember(String email);
	
	boolean existMail(String id);
	
	boolean findOneNickName(String nickName);

	List<Member> getAllmembers(int offset, int limit, int memberlist);

	double getMemberCount();
}
