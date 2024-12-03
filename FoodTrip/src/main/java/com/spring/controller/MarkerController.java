package com.spring.controller;

import java.io.File;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.spring.domain.Marker;
import com.spring.service.MarkerService;

@Controller
@RequestMapping("/marker")
public class MarkerController {
	
	@Autowired
	private MarkerService markerService;
	
	/*
	 * 2024.12.02 
	 * Marker home view method , GET()
	 * editor : KYEONGMIN
	 * Param : none
	 * return : String
	 */
	@GetMapping("/home")
	public String markerhome() {
		return "markerhome";
	}
	
	
	/*
	 * 2024.12.02 
	 * editor : KYEONGMIN
	 * Marker 생성 폼view로 이동 , GET() 
	 * Param : Model
	 * return : String
	 */
	@GetMapping("/create")
	public String markerCreate(Model model) {
		model.addAttribute("NewMarker", new Marker());
		
		return "marker/addMarker";
	}
	
	/*
	 * 2024.12.02 
	 * editor : KYEONGMIN
	 * Marker Create form 입력 후 DB로 실제 삽입하는 method , POST() 
	 * Param : Marker, HttpServlet
	 * return : String
	 */
	@PostMapping("/create")
	public String markerInsert(@ModelAttribute("NewMarker") Marker marker, HttpServletRequest req) {
		
		String realPath = req.getServletContext().getRealPath("resources/images");
		System.out.println(realPath);
		MultipartFile file = marker.getImage();
		String imageName = file.getOriginalFilename();
		File f = new File(realPath, imageName);
		
		if(imageName != null && !imageName.isEmpty()) {
			try {
				System.out.println("imageName null 아님");
				file.transferTo(f);
				System.out.println("파일 trans완료");
				marker.setImageName(imageName);
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		
		markerService.markerCreate(marker);	
		
		return "redirect:home";
	}
	
	
	/*
	 * 2024.12.02 
	 * editor : KYEONGMIN
	 * Marker ReadALL method , GET()
	 * Param : Model
	 * return : String
	 */
	@GetMapping("/readall")
	public String markerReadAll(Model model) {
		System.out.println("readall IN");
		List<Marker> list = markerService.markerReadAll();
		System.out.println("readAll list get");
		model.addAttribute("list", list);
		return "marker/markerList";
	}
	
	/*
	 * 2024.12.02 
	 * editor : KYEONGMIN
	 * Marker ReadOne method , GET()
	 * Param : String, Model
	 * return : String
	 */
	@GetMapping("/readone")
	public String markerReadOne(@RequestParam("id") String markerid, Model model) {
		System.out.println("readone IN : "+markerid);
		Marker marker = markerService.markerReadOne(markerid);
		model.addAttribute("marker",marker);
		
		return "marker/markerInfo";
	}
	
	/*
	 * 2024.12.02 
	 * editor : KYEONGMIN
	 * Marker Update를 위한 폼view로 이동 , GET()
	 * Param : String, Model
	 * return : String
	 */	
	@GetMapping("/update")
	public String markerUpdateView(@RequestParam("id") String markerId, Model model) {
		System.out.println("update IN : "+markerId);
		Marker marker = markerService.markerReadOne(markerId);
		
		model.addAttribute("UpdateMarker", new Marker());
		model.addAttribute("marker", marker);
		System.out.println("update end return");
		
		return "marker/updateForm";
	}
	
	
	/*
	 * 2024.12.02 
	 * editor : KYEONGMIN
	 * Marker Update 폼 작성 후 실제 삽입을 위한 DB연결 method , POST()
	 * Param : Marker, HttpServletRequest
	 * return : String
	 */	
	@PostMapping("/update")
	public String markerUpdateExecute(@ModelAttribute("UpdateMarker") Marker marker, HttpServletRequest req) {
		System.out.println("update Execute IN");
		String realpath = req.getServletContext().getRealPath("resources/images"); 
		System.out.println("image name : "+marker.getImageName());
		
		MultipartFile mpf = marker.getImage();
		if(mpf != null && !mpf.isEmpty()) {
			String imagename = mpf.getOriginalFilename();
			File f = new File(realpath,imagename);
			try {
				mpf.transferTo(f);
				marker.setImageName(imagename);
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		markerService.markerUpdate(marker);
		return "redirect:home";
	}
	
	/*
	 * 2024.12.02 
	 * editor : KYEONGMIN
	 * Marker delete method  , GET()
	 * Param : String
	 * return : String
	 */
	@GetMapping("/delete")
	public String markerDelete(@RequestParam("id") String markerId) {
		markerService.markerDelete(markerId);
		
		return "redirect:home";
	}
}
