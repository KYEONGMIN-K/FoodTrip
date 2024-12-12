package com.spring.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.google.gson.Gson;
import com.spring.domain.Marker;
import com.spring.service.MarkerService;

@Controller
@RequestMapping("/marker")
public class MarkerController {
	
	private static final String restId = "RS";
	private static final String hotelId = "HT";
	private static final String tourId = "TU";
	
	Gson g = new Gson();
	
	@Autowired
	private MarkerService markerService;
	
	@GetMapping("/test")
	public String markertest() {
		return "marker/addMarkerJS";
	}
	
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
	//@PostMapping("/create")
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
	
	@ResponseBody
	@PostMapping("/addMarker")
	public ResponseEntity<Map<String, String>> addMarker(@RequestBody HashMap<String, Object> map, HttpServletRequest req) {
		System.out.println(map);
		//만약 같은 데이터가 들어온다면
		
		
		//전처리
		Map<String, String> saveSearch = new HashMap(); 
		saveSearch.put("inputdata", (String)map.get("inputdata"));
		
		System.out.println((String)map.get("inputdata"));
		Marker marker = new Marker();
		//marker.setmarkerId("TEST");
		marker.setPointX(Double.parseDouble((String)map.get("pointX")));
		marker.setPointY(Double.parseDouble((String)map.get("pointY")));
		marker.setPointName((String)map.get("pointName"));
		marker.setAddress((String)map.get("address"));
		marker.setPhone((String)map.get("phone"));
		marker.setCategory((String)map.get("category"));
		marker.setDescription((String)map.get("description"));
		String pname = marker.getPointName();
		String paddr = marker.getAddress();
		
		Boolean ie = markerService.isExist(pname, paddr);
		if(ie) {
			return null;
		}
		//카테고리에 따라 마커 분류
		String tmp = marker.getCategory();
		tmp = tmp.replaceAll("\\s+", "");
		String cate[] = tmp.split(">");
		String result[] = cate[1].split(",");
		
		for(int i=0; i<cate.length; i++)
			System.out.println(cate[i]);
		//카테고리에 따라 ID부여
		if(cate[0].equals("음식점")) {
			//System.out.println(restId+numToStr);
			marker.setmarkerId(restId);
		}else { 
			if(result[0].equals("관광")){
				marker.setmarkerId(tourId);
			}else if(result[0].equals("숙박")) {
				marker.setmarkerId(hotelId);
			}
		}
		
		String realPath = req.getServletContext().getRealPath("resources/images");
		System.out.println(realPath);
		MultipartFile file = marker.getImage();
		String imageName = null;
		File f = null;
		if(file !=null) {
			imageName= file.getOriginalFilename();
			f = new File(realPath, imageName);
		}
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
		
		return ResponseEntity.ok(saveSearch);
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
	
	
	
	@GetMapping("/readMkAll")
	@ResponseBody
	public ResponseEntity<String> readMarkerAll(Model model) {
		System.out.println("readall IN");
		
		List<Marker> list = markerService.markerReadAll();
		System.out.println("readAll list get");
		
		model.addAttribute("list", list);
		//Map<String, Marker>[] a = new HashMap<String, Marker>();
		/*
		 * list는 dto를 가지고 있는 배열.
		 * 배열 하나하나는 dto의 주소를 담고 있다. 배열을 따라가면 dto가 나온다.
		 * list[0]은 dto를 가리키며 list[0].getxxx()을 통해 해당 dto의 값을 가져올 수 있다.
		 * */
	//	Map<String, String> result = new HashMap();
		String listJson = g.toJson(list);
		//System.out.println(listJson);
		
		//한글 깨짐 방지
		 HttpHeaders headers = new HttpHeaders();
		 headers.setContentType(MediaType.APPLICATION_JSON);
		 headers.set("Content-Type", "application/json; charset=UTF-8");
		
		return new ResponseEntity<>(listJson, headers, HttpStatus.OK);
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
	//@GetMapping("/update")
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
//	@PostMapping("/update")
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
	
	
	@GetMapping("/markerUpdate")
	public String markerEditView(@RequestParam("id") String markerId,Model model){
		System.out.println("Marker Edit IN");
		Marker marker = new Marker();
		marker = markerService.markerReadOne(markerId);
		model.addAttribute("marker", marker);
		
		return "marker/markerEditForm";
	}
	
	
	@ResponseBody
	@PostMapping("/editexecute")
	public String markerEditExecute(@RequestBody HashMap<String, Object> map) {
		System.out.println("edit execute in");
		System.out.println(map.get("pointName"));
		System.out.println(map.get("markerId"));
		//전처리
		Marker marker = new Marker();
		marker.setmarkerId((String)map.get("markerId"));
		marker.setPointX(Double.parseDouble((String)map.get("pointX")));
		marker.setPointY(Double.parseDouble((String)map.get("pointY")));
		marker.setPointName((String)map.get("pointName"));
		marker.setAddress((String)map.get("address"));
		marker.setPhone((String)map.get("phone"));
		marker.setCategory((String)map.get("category"));
		marker.setDescription((String)map.get("description"));

		//모델이동
		markerService.markerUpdate(marker);
		//리턴
		
		return "good";
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
		System.out.println("delete IN"+markerId);
		
		markerService.markerDelete(markerId);
		
		return "redirect:readalljson";
	}
	
	/*
	 * JSON READ
	 * 
	 * */
	@GetMapping("/readalljson")
	public String readjson() {
		return "marker/markerListJS";
	}
	
	
	@ResponseBody
	@PostMapping("/jsonrdall")
	public List<Marker> getAllMarker(){
		List<Marker> list = markerService.markerReadAll();
				
		return list;
	}
	
}
