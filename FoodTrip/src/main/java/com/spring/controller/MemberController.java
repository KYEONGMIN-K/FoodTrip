package com.spring.controller;

import java.sql.Timestamp;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.spring.domain.Member;
import com.spring.service.MemberService;

@Controller
public class MemberController {

	@Autowired
	private MemberService memberService;
	
	// 로그인 폼 제공
	@GetMapping("/login")
	public String loginForm(@ModelAttribute("mem") Member member) {
		System.out.println("loginForm()실행 : 로그인 폼 제공");
		return "/Member/login";
	}
	
	@GetMapping("/logout")
	public String logout(HttpSession session) {
		session.invalidate();
		return "redirect:/test";
	}
	
	// 계정 확인 : Read
	@PostMapping("/login")
	public String loginCheck(@ModelAttribute("mem") Member member, Model model,HttpSession session,HttpServletRequest request) {
		System.out.println("loginCheck() 실행 : 계정 존재 확인");
		String fullEmail = member.getEmail1() + "@" + member.getEmail2();
	    member.setEmail(fullEmail);
	    
	    Member members = memberService.getOneMember(member);
		System.out.println("loginCheck()의 members : " + members);
		
		if(members==null) {	
			model.addAttribute("error","true");
			return "Member/login";
		}
		session = request.getSession(true);
		session.setAttribute("sessionId", members);
		return "redirect:/test";
	}
	
	
	
	// 회원가입 폼 제공 
	@GetMapping("/addMember")
	public String addMember(@ModelAttribute("addMem")Member member) {
		System.out.println("addMember()실행 : 회원가입 폼 제공");
		return "/Member/addMember";
	}
	
	// 회원 생성 : Create
	@PostMapping("/addMember")
	public String submitMember(@ModelAttribute("addMem")Member member) {
		System.out.println("submitMember()실행 : 회원가입 시작");
		String fullEmail = member.getEmail1() + "@" + member.getEmail2();
	    member.setEmail(fullEmail);
	    Timestamp time = new Timestamp(System.currentTimeMillis());
	    member.setJoinDay(time);
	    
		memberService.setNewMember(member);
		return "redirect:/login";
	}
	
	// 회원 수정 폼 제공
	@GetMapping("/update")
	public String updateForm(@ModelAttribute("updateMember")Member member, Model model) {
		System.out.println("updateForm() 실행 : 수정 폼 제공");
		Member oneMember = memberService.getOneMember(member);
		model.addAttribute("member", member);
		return "/Member/updateForm";
	}
	
	// 회원 정보 수정 : Update
	@PostMapping("/update")
	public String submitUpdate(@ModelAttribute("udateMember")Member member) {
		System.out.println("submitForm() 실행 : 회원 정보 수정 시작");
		memberService.setUpdateMember(member);
		return "redirect:/test";
	}
	
	// 회원 삭제 : Delete
	@GetMapping("/delete")
	public String deleteMember(Model model, @RequestParam("email") String email,HttpSession session) {
		System.out.println("deleteMember() 실행 : 회원 삭제 // 이메일 : " + email);
		memberService.setDeleteMember(email);
		session.invalidate();
		return "redirect:/test";
	}
	
}
