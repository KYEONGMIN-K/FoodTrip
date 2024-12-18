package com.spring.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

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
import com.spring.domain.Member;
import com.spring.service.MarkerService;

@Controller
@RequestMapping("/marker")
public class MarkerController {
	
	private static final String restId = "RS";
	private static final String hotelId = "HT";
	private static final String tourId = "TU";
	
	//ajax 
	Gson g = new Gson();
	
	@Autowired
	private MarkerService markerService;
	
	
	@GetMapping("/test")
	public String markertest(HttpSession session, Member member) {
		Member sessionId = (Member) session.getAttribute("sessionId");
        if (sessionId == null) {
            return "redirect:/login";
        }
		return "marker/addMarkerJS";
	}
	
	//-------   CREATE   -------
	
	/*
	 * 2024.12.07 
	 * editor : KYEONGMIN
	 * Marker �깮�꽦 Form View濡� �씠�룞 , GET() 
	 * Param : none
	 * return : String
	 */
	@GetMapping("/addMarker")
	public String markertest() {
		return "marker/addMarkerJS";
	}
	
	/*
	 * 2024.12.08
	 * editor : KYEONGMIN
	 * Marker �깮�꽦 Form �엯�젰 �썑 ajax瑜� �넻�빐 諛쒖깮�맂 �슂泥��쓣 諛쏆� �썑 DB濡� �엯�젰 , POST() 
	 * Param : HashMap<String, Object>, HttpSerlvetRequest
	 * return : String
	 */
	@ResponseBody
	@PostMapping("/addMarker")
	public String addMarker(@RequestBody HashMap<String, Object> map, HttpServletRequest req) {
//		System.out.println(map);

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
		
		//	以묐났 �솗�씤
		Boolean ie = markerService.isExist(pname, paddr);
		if(ie) {
			return null;
		}
		//移댄뀒怨좊━�뿉 �뵲�씪 留덉빱 遺꾨쪟
		String tmp = marker.getCategory();
		tmp = tmp.replaceAll("\\s+", "");
		String cate[] = tmp.split(">");
		String result[] = cate[1].split(",");
		
		for(int i=0; i<cate.length; i++)
			System.out.println(cate[i]);
		//移댄뀒怨좊━�뿉 �뵲�씪 ID遺��뿬
		if(cate[0].equals("�쓬�떇�젏")) {
			//System.out.println(restId+numToStr);
			marker.setmarkerId(restId);
		}else { 
			if(result[0].equals("愿�愿�")){
				marker.setmarkerId(tourId);
			}else if(result[0].equals("�닕諛�")) {
				marker.setmarkerId(hotelId);
			}
		}
		
		String realPath = req.getServletContext().getRealPath("resources/images");
		//System.out.println(realPath);
		MultipartFile file = marker.getImage();
		String imageName = null;
		File f = null;
		if(file !=null) {
			imageName= file.getOriginalFilename();
			f = new File(realPath, imageName);
		}
		if(imageName != null && !imageName.isEmpty()) {
			try {
				System.out.println("imageName null �븘�떂");
				file.transferTo(f);
				System.out.println("�뙆�씪 trans�셿猷�");
				marker.setImageName(imageName);
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		
		markerService.markerCreate(marker);
		
		return "success";
	}
	
	
	
	//-------   READ   -------	
	
	/*
	 * 2024.12.09
	 * Editor : KYEONGMIN
	 * Description : Marker 由ъ뒪�듃 View濡� �씠�룞�븯�뒗 硫붿꽌�뱶 : GET()
	 * Param : Model
	 * Return : ResponseEntity<String>
	 */
	@GetMapping("/readalljson")
	public String readjson() {
		return "marker/markerListJS";
	}
	
	
	/*
	 * 2024.12.09
	 * Editor : KYEONGMIN
	 * Description : Marker�쓽 �쟾泥� 由ъ뒪�듃瑜� ajax濡쒕��꽣 �슂泥� 諛쏆븘 JSON�쑝濡� �룎�젮二쇰뒗 硫붿꽌�뱶
	 * Param : Model
	 * Return : ResponseEntity<String>
	 */	
	@GetMapping("/readMkAll")
	@ResponseBody
	public ResponseEntity<String> readMarkerAll(Model model) {
		System.out.println("readall IN");
		
		List<Marker> list = markerService.markerReadAll();
		System.out.println("readAll list get");
		
		model.addAttribute("list", list);
		//Map<String, Marker>[] a = new HashMap<String, Marker>();
		/*
		 * list�뒗 dto瑜� 媛�吏�怨� �엳�뒗 諛곗뿴.
		 * 諛곗뿴 �븯�굹�븯�굹�뒗 dto�쓽 二쇱냼瑜� �떞怨� �엳�떎. 諛곗뿴�쓣 �뵲�씪媛�硫� dto媛� �굹�삩�떎.
		 * list[0]�� dto瑜� 媛�由ы궎硫� list[0].getxxx()�쓣 �넻�빐 �빐�떦 dto�쓽 媛믪쓣 媛��졇�삱 �닔 �엳�떎.
		 * */
	//	Map<String, String> result = new HashMap();
		String listJson = g.toJson(list);
		//System.out.println(listJson);
		
		//�븳湲� 源⑥쭚 諛⑹�
		 HttpHeaders headers = new HttpHeaders();
		 headers.setContentType(MediaType.APPLICATION_JSON);
		 headers.set("Content-Type", "application/json; charset=UTF-8");
		
		return new ResponseEntity<>(listJson, headers, HttpStatus.OK);
	}	
		
	//-------   UPDATE   -------
	
	/*
	 * 2024. 12. 07 
	 * Editor : KYEONGMIN
	 * Description : Marker Update �뤌 �씠�룞
	 * Param : String, Model
	 * return : String
	 */
	@GetMapping("/markerUpdate")
	public String markerEditView(@RequestParam("id") String markerId,Model model){
		System.out.println("Marker Edit IN");
		Marker marker = new Marker();
		marker = markerService.markerReadOne(markerId);
		model.addAttribute("marker", marker);
		
		return "marker/markerEditForm";
	}
	
	/*
	 * 2024. 12. 07 
	 * Editor : KYEONGMIN
	 * Description : Marker Update �닔�젙 �썑 ajax瑜� �넻�빐 �뱾�뼱�삩 �뜲�씠�꽣 
	 * Param : String, Model
	 * return : String
	 */
	@ResponseBody
	@PostMapping("/editexecute")
	public String markerEditExecute(@RequestBody HashMap<String, Object> map) {
		System.out.println("edit execute in");
		System.out.println(map.get("pointName"));
		System.out.println(map.get("markerId"));
		//�쟾泥섎━
		Marker marker = new Marker();
		marker.setmarkerId((String)map.get("markerId"));
		marker.setPointX(Double.parseDouble((String)map.get("pointX")));
		marker.setPointY(Double.parseDouble((String)map.get("pointY")));
		marker.setPointName((String)map.get("pointName"));
		marker.setAddress((String)map.get("address"));
		marker.setPhone((String)map.get("phone"));
		marker.setCategory((String)map.get("category"));
		marker.setDescription((String)map.get("description"));

		//紐⑤뜽�씠�룞
		markerService.markerUpdate(marker);
		//由ы꽩
		
		return "good";
	}
	
	//-------   DELETE   -------	
	
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
	@ResponseBody
	@PostMapping("/jsonrdall")
	public List<Marker> getAllMarker(){
		List<Marker> list = markerService.markerReadAll();
				
		return list;
	}
	*/
	//===================================== �븘�옒�뒗 JSP �룞�옉 (�쁽�옱 �궗�슜�븯吏� �븡�쓬) =========================================
	
	/*
	 * 2024.12.02 
	 * editor : KYEONGMIN
	 * Marker Update �뤌 �옉�꽦 �썑 �떎�젣 �궫�엯�쓣 �쐞�븳 DB�뿰寃� method , POST()
	 * Param : Marker, HttpServletRequest
	 * return : String
	 */	
	
	//-------   CREATE   -------

	/*
	 * 2024.12.02 
	 * editor : KYEONGMIN
	 * Marker �깮�꽦 �뤌view濡� �씠�룞 , GET() 
	 * Param : Model
	 * return : String
	 */
	//@GetMapping("/create")
	public String markerCreate(Model model) {
		model.addAttribute("NewMarker", new Marker());
		
		return "marker/addMarker";
	}
	
	/*
	 * 2024.12.02 
	 * editor : KYEONGMIN
	 * Marker Create form �엯�젰 �썑 DB濡� �떎�젣 �궫�엯�븯�뒗 method , POST() 
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
				System.out.println("imageName null �븘�떂");
				file.transferTo(f);
				System.out.println("�뙆�씪 trans�셿猷�");
				marker.setImageName(imageName);
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		
		markerService.markerCreate(marker);	
		
		return "redirect:home";
	}
	
	//-------   READ   -------	
	
	/*
	 * 2024.12.02 
	 * editor : KYEONGMIN
	 * Marker ReadALL method , GET()
	 * Param : Model
	 * return : String
	 */
	//@GetMapping("/readall")
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
	//@GetMapping("/readone")
	public String markerReadOne(@RequestParam("id") String markerid, Model model) {
		System.out.println("readone IN : "+markerid);
		Marker marker = markerService.markerReadOne(markerid);
		model.addAttribute("marker",marker);
		
		return "marker/markerInfo";
	}
	
	//-------   UPDATE   -------

	/*
	 * 2024.12.02 
	 * editor : KYEONGMIN
	 * Marker Update瑜� �쐞�븳 �뤌view濡� �씠�룞 , GET()
	 * Param : String, Model
	 * return : String
	 */	
	
	public String markerUpdateView(@RequestParam("id") String markerId, Model model) {
		System.out.println("update IN : "+markerId);
		Marker marker = markerService.markerReadOne(markerId);
		
		model.addAttribute("UpdateMarker", new Marker());
		model.addAttribute("marker", marker);
		System.out.println("update end return");
		
		return "marker/updateForm";
	}
	
	
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
	
	//-------   DELETE   -------
	
	
}
