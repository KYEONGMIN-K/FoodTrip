package com.spring.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;
import com.spring.domain.Marker;
import com.spring.domain.Road;
import com.spring.service.MarkerService;
import com.spring.service.RoadService;

@Controller
@RequestMapping("/road")
public class RoadController {
	
	private static final String cateChicken = "CK";
	private static final String cateChinese = "CH";
	private static final String catePasta = "PS";
	private static final String cateDisert = "DS";
	private static final String cateSnack = "SN";
	
	Gson g = new Gson();
	
	@Autowired
	private MarkerService markerService;
	
	@Autowired
	private RoadService roadService;
	
	//-------   CREATE   -------
	
	@GetMapping("/makeRoad")
	public String createRoad() {
		return "road/roadMake";
	}
	
	@PostMapping("/addCourse")
	@ResponseBody
	public String addCourse(@RequestBody Map<String, Object> map) {
		System.out.println("add Course IN");
		System.out.println(map);
		
		Road road = new Road();
		
		road.setCategory((String)map.get("category"));
		road.setUserNick((String)map.get("user"));
		road.setCourseSize((int)map.get("courseSize"));
		road.setDescription((String)map.get("description"));
		System.out.println("course size: "+road.getCourseSize());
		
		List<String> planlist = (List<String>)map.get("plan");
		String[] planary = planlist.toArray(new String[0]);
		
		road.setCourse(planary);
		
		System.out.println(road.getCourse()[1]);
		
		//카테고리에 따른 id부여 로직
		String getCate = road.getCategory();
		System.out.println(getCate);
		/*
			<option value="chicken">치킨</option>
			<option value="chinese">중식</option>
			<option value="pasta">파스타</option>
			<option value="snack">분식</option>
			<option value=disert>디저트</option>		
		*/
		if(getCate.equals("chicken")) {
			road.setRoadId(cateChicken);
		}else if(getCate.equals("chinese")) {
			road.setRoadId(cateChinese);
		}else if(getCate.equals("pasta")) {
			road.setRoadId(catePasta);
		}else if(getCate.equals("snack")) {
			road.setRoadId(cateSnack);
		}else if(getCate.equals("disert")) {
			road.setRoadId(cateDisert);
		}

		roadService.roadCreate(road);
		
		return "success";
	}
	
	//-------   READ   -------

	//Road Read ALL
	@GetMapping("/readRoad")
	public String getAllRoad() {
		System.out.println("get all road IN");
		
		return "road/roadreadall";
	}
	
	//Read All Marker
	@GetMapping("/readMkAll")
	@ResponseBody
	public ResponseEntity<String> roadReadAll(Model model) {
		List<Marker> list = markerService.markerReadAll();
		
		String listJson = g.toJson(list);
		model.addAttribute(list);
		//한글 깨짐 방지
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_JSON);
		headers.set("Content-Type", "application/json; charset=UTF-8");
		
		return new ResponseEntity<>(listJson, headers, HttpStatus.OK);
	}
	
	
	//Road Read ALL
	@PostMapping("/readRoad")
	@ResponseBody
	public ResponseEntity<String> getAllRoadResult() {
		//먼저 저장된 코스 정보를 전부 가져온다.
		List<Road> list = roadService.roadReadAll();
		System.out.println("readAll list get");
		System.out.println("list size : "+list.size());
		
		findMarker(list);
		
		//model.addAttribute("list", list);
		
		String listJson = g.toJson(list);
		System.out.println(listJson);
		
		//한글 깨짐 방지
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_JSON);
		headers.set("Content-Type", "application/json; charset=UTF-8");
		
		return new ResponseEntity<>(listJson, headers, HttpStatus.OK);
	}
	
	public void findMarker(List<Road> list){
		//코스가 가진 마커id로 마커를 전부 가져온다.
		//1. 리스트의 요소에 접근
		for(int i=0; i<list.size();i++) {
			ArrayList<Marker> find = new ArrayList<Marker>();
			Road roadOne = list.get(i);
			//System.out.println(roadOne.getCourse());
			String[] tmp = new String[roadOne.getCourseSize()];
			//2. 리스트 요소 내 마커 리스트에 접근
			//System.out.println("rd id in read " + roadOne.getRoadId());
			//System.out.println("rd size in read " + roadOne.getCourseSize());
			System.out.println("tmp size : "+tmp.length);
			for(int j=0; j<roadOne.getCourseSize(); j++) {
				tmp = roadOne.getCourse();	//주소값만 받음.
				System.out.println("tmp in size : "+tmp.length);
				Marker mk = markerService.markerReadOne(tmp[j]);
				System.out.println(mk.getmarkerId());
				find.add(mk);
			}
			roadOne.setPoints(find);
		} 
	}
	
	public void findMarker(Road road) {
		ArrayList<Marker> find = new ArrayList<Marker>();
		Road roadOne = road;
		String[] tmp = new String[roadOne.getCourseSize()];
		//2. 리스트 요소 내 마커 리스트에 접근
		System.out.println("tmp size : "+tmp.length);
		for(int j=0; j<roadOne.getCourseSize(); j++) {
			tmp = roadOne.getCourse();	//주소값만 받음.
			System.out.println("tmp in size : "+tmp.length);
			Marker mk = markerService.markerReadOne(tmp[j]);
			System.out.println(mk.getmarkerId());
			find.add(mk);
		}
		roadOne.setPoints(find);
	}
	
	
	
	//Road Read One
	@GetMapping("/roadUpdate")
	public String roadupdate(@RequestParam("id") String roadId, Model model) {
		System.out.println("수정 : "+roadId);
		model.addAttribute("id", roadId);
		return "road/roadEditForm";
	}
	
	@PostMapping("/readOneRoad")
	@ResponseBody
	public ResponseEntity<String> oneRoad(@RequestBody String rid){
		System.out.println("하나 줄래 ? : "+rid);
		String id = rid.replace('"', ' ');
		id = id.trim();
		System.out.println("바꿔줄래? : "+id);
		Road road = roadService.roadReadOne(id); 
		//가져온 로드 하나에 마커 정보 입력
		findMarker(road);
				
		String itemJson = g.toJson(road);
		
		System.out.println("가져온 하나 : "+ itemJson);
		//한글 깨짐 방지
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_JSON);
		headers.set("Content-Type", "application/json; charset=UTF-8");
		
		return new ResponseEntity<>(itemJson, headers, HttpStatus.OK);
	}
	
	//-------   UPDATE   -------
	@PostMapping("/roadUpExe")
	@ResponseBody
	public String roadUpdateExecute(@RequestBody Map<String, Object> map) {
		System.out.println("update IN : "+map);
		
		Road road = new Road();
		road.setRoadId((String)map.get("roadId"));
		road.setCategory((String)map.get("category"));
		road.setCourseSize((int)map.get("courseSize"));
		List<String> planlist = (List<String>)map.get("plan");
		String[] planary = planlist.toArray(new String[0]);
		road.setCourse(planary);
		System.out.println(road.getRoadId());
//		System.out.println(road.getCourseToString());
		roadService.roadUpdate(road);
		
		return "end"; 
	}

	//-------   DELETE   -------
	@GetMapping("/roadDelete")
	public String roaddelete(@RequestParam("id") String id) {
		System.out.println("삭제할 id : "+id);
		
		roadService.roadDelete(id);		
		
		return "redirect:readRoad";
	}
}
