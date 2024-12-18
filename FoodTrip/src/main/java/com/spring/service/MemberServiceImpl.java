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
	
	public void setUpdateMember(Member member) {
		memberRepository.setUpdateMember(member);
	}
	
	public boolean existMail(String id) {
		return memberRepository.existMail(id);
	}
	public boolean findOneNickName(String nickName) {
		return memberRepository.findOneNickName(nickName);
	}
	
	public void setDeleteMember(String email) {
		memberRepository.setDeleteMember(email);
	}
	
	public List<Member> getAllMembers(int offset, int limit, int memberlist){
		return memberRepository.getAllmembers(offset, limit, memberlist);
	}
	
	public double getMemberCount() {
		return memberRepository.getMemberCount();
	}
}
