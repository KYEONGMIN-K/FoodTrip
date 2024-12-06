package com.spring.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;
import com.spring.domain.Marker;
import com.spring.service.MarkerService;
import com.spring.service.RoadService;

@Controller
@RequestMapping("/road")
public class RoadController {
	
	Gson g = new Gson();
	
	@Autowired
	private MarkerService markerService;
	
	@Autowired
	private RoadService roadService;
	
	
	@GetMapping("/home")
	public String roadhome() {
		return "roadhome";
	}

	@GetMapping("/makeRoad")
	public String createRoad() {
		return "road/roadForm";
	}

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
	
	@GetMapping("/update")
	public String roadupdate() {
		return "road/roadupdate";
	}
	
	@GetMapping("/delete")
	public String roaddelete() {
		return "road/roaddelete";
	}
}
