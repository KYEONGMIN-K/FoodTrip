package com.spring.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/road")
public class RoadController {
	
	@GetMapping("/home")
	public String roadhome() {
		return "roadhome";
	}

	@GetMapping("/create")
	public String createRoad() {
		return "road/roadcreate";
	}
	
	@GetMapping("/readall")
	public String roadReadAll() {
		return "road/roadreadall";
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
