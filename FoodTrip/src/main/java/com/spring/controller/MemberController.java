package com.spring.controller;

import java.sql.Timestamp;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.MailSender;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.domain.Member;
import com.spring.service.MemberService;

@Controller
@RequestMapping("/member")
public class MemberController {

	@Autowired
	private MemberService memberService;
	
	@Autowired
	MailSender sender;
	
	// 로그인 폼 제공
	@GetMapping("/login")
	public String loginForm(@ModelAttribute("mem") Member member) {
		System.out.println("loginForm()실행 : 로그인 폼 제공");
		return "/Member/login";
	}
	
	@GetMapping("/logout")
	public String logout(HttpSession session) {
		session.invalidate();
		return "redirect:/";
	}
	
	// 계정 존재 확인 : Read
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
		return "redirect:/";
	}
	
	
	
	// 회원가입 폼 제공 
	@GetMapping("/addMember")
	public String addMember(@ModelAttribute("addMem")Member member, @RequestParam("userId") String email, Model model) {
		System.out.println("addMember()실행 : 회원가입 폼 제공");
		if(email.isEmpty()) {
			System.out.println("존재하니?");
			return null;
		}
		model.addAttribute("email",email);
		System.out.println("이메이이이이일 : " + email);
		return "Member/addMember";
	}
	
	// 회원 생성 : Create
	@PostMapping("/addMember")
	public String submitMember(@ModelAttribute("addMem")Member member, HttpServletRequest request, Model model) {
		System.out.println("submitMember()실행 : 회원가입 시작");
		boolean existNick = memberService.findOneNickName(member.getNickName());
		System.out.println("닉존재하냐? : " + existNick);
		if(existNick) {
			model.addAttribute("existNick", "exist");
			return "Member/addMember";
		}
	    Timestamp time = new Timestamp(System.currentTimeMillis());
	    member.setJoinDay(time);
	    
		memberService.setNewMember(member);
		return "redirect:/member/login";
	}
	
	// 회원 수정 폼 제공
	@GetMapping("/update")
	public String updateForm(@ModelAttribute("updateMember") Member member, Model model) {
		System.out.println("updateForm() 실행 : 수정 폼 제공");
		Member oneMember = memberService.getOneMember(member);
		model.addAttribute("member", oneMember);
		return "/Member/updateForm";
	}
	
	
	
	// 회원 정보 수정 : Update
	@PostMapping("/update")
	public String submitUpdate(@ModelAttribute("updateMember")Member member) {
		System.out.println("submitForm() 실행 : 회원 정보 수정 시작");
		memberService.setUpdateMember(member);
		return "redirect:/";
	}
	
	// 회원 삭제 : Delete
	@GetMapping("/delete")
	public String deleteMember(@RequestParam("email") String email,HttpSession session) {
		System.out.println("deleteMember() 실행 : 회원 삭제 // 이메일 : " + email);
		memberService.setDeleteMember(email);
		session.invalidate();
		return "redirect:/";
	}
	
	// 이메일 인증 폼
	@GetMapping("/email")
	public String eMail(@ModelAttribute("email")Member member) {
		System.out.println("eMail()실행 : 이메일 폼 제공");
		return "/Member/EmailCheck";
	}
	
	// 이메일 인증 
	@PostMapping("/email")
	public String send(@ModelAttribute("email")Member member,Model model) {
		System.out.println("send() 실행 : 이메일 인증 시작");
		String id = member.getEmail1() + "@" + member.getEmail2();
		member.setEmail(id);
		System.out.println("이메일아이디 : " + id);
		boolean ec = memberService.existMail(id);
		System.out.println(ec);
	    if(ec==true) {
	    	System.out.println("이메일 중복됨");
	    	model.addAttribute("true","true");
	    	return "Member/EmailCheck";
	    }
		
	    String host ="http://localhost:8080/FoodTrip/addMember";
		String from ="soledd54@gmail.com";
		String to = id;
		String content = "클릭하여 이메일 인증을 완료해주십시오\n"
				+ "<a href='"+host+"?userId="+id+"'>이메일 인증하기</a>";
		SimpleMailMessage message = new SimpleMailMessage();
		message.setTo(to);
		message.setSubject("전달메시지");
		message.setText(content);
		message.setFrom(from);
		sender.send(message);
		return "/Member/successEmail";
	}
	
	// 닉네임 중복 확인
	@ResponseBody
	@PostMapping("/overlap")
	public boolean overlap(@RequestBody HashMap<String,Object> map) {
		System.out.println("overlap() 실행 : 닉네임 중복 확인");
		String nickName = (String)map.get("nickName");
		Member member = new Member();
		member.setNickName(nickName);
		boolean oneNick = memberService.findOneNickName(nickName);
		System.out.println("참거짓 : " + oneNick);
		return oneNick;
	}
	
	// 전체 회원 조회 ( 관리자 ) 
	@GetMapping("/allMembers")
	public String getAllMembers(@RequestParam(value="pageNum", required = false, defaultValue = "1")int pageNum,
								@RequestParam(value="memberlist", required = false, defaultValue = "1")int memberlist, Model model,
								HttpSession session) {
		System.out.println("getAllMembers() 실행 : 전체 회원 조회 ( 관리자 ) ");
		System.out.println("컨트롤러에 파라미터로 들어오는 멤버리스트 번호 : " + memberlist);
		Member sessionId = (Member) session.getAttribute("sessionId");
		if (sessionId == null) {
            return "redirect:/member/login";
        }
        // 관리자 계정이 아닐 경우 접근 제어 
		if (!sessionId.getNickName().equals("admin")) {
			return "redirect:/access";
		}
		System.out.println("관리자맞나? : " + sessionId.getNickName().equals("admin"));
		int limit=100; // 한 페이지에 표시할 게시글 수 
		List<Member> memberList = memberService.getAllMembers((pageNum-1)*limit, limit, memberlist);
		int totalPage = (int) Math.ceil((double) memberService.getMemberCount()/limit);
		System.out.println("멤버리스트 : " + memberList);
		model.addAttribute("memberList", memberList);
		model.addAttribute("pageNum", pageNum);
		model.addAttribute("totalPage", totalPage);
		
		return "Member/allMembers";
	}
	
	// 회원 삭제 ( 관리자 )
	@GetMapping("/deleteMember")
	public String deleteMemberAdmin(@RequestParam("email")String email, HttpSession session) {
		System.out.println("deleteMemberAdmin() 실행 : 관리자 회원 삭제");
		Member sessionId = (Member) session.getAttribute("sessionId");
        if (sessionId == null) {
            return "redirect:/member/login";
        }
		if (!sessionId.getNickName().equals("admin")) {
			return "redirect:/access";
		}		
		memberService.setDeleteMember(email);
		return "redirect:/member/allMembers";
	}
}
