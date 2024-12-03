package com.spring.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.domain.Member;
import com.spring.repository.MemberRepository;

@Service
public class MemberServiceImpl implements MemberService{

	@Autowired 
	private MemberRepository memberRepository;
	
	public Member getOneMember(Member member) {
		
		
		return memberRepository.getOneMember(member);
	}
	
	public void setNewMember(Member member) {
		memberRepository.setNewMember(member);
	}
}