package com.spring.service;

import java.util.List;

import com.spring.domain.Member;

public interface MemberService {

	Member getOneMember(Member member);
	void setNewMember(Member member);
	void setUpdateMember(Member member);
	void setDeleteMember(String email);

}
