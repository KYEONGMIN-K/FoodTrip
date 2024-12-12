package com.spring.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.spring.domain.Road;

@Service
public interface RoadService {
	void roadCreate(Road road);
	void roadDelete(String roadId);
	List<Road> roadReadAll();
	Road roadReadOne(String roadId);
	void roadUpdate(Road road);
}
