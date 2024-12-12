package com.spring.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.domain.Road;
import com.spring.repository.RoadRepository;

@Service
public class RoadServiceImpl implements RoadService{

	@Autowired
	private RoadRepository roadRepository;
	
	@Override
	public void roadCreate(Road road) {
		roadRepository.roadCreate(road);
	}

	@Override
	public void roadDelete(String roadId) {
		roadRepository.roadDelete(roadId);		
	}

	@Override
	public List<Road> roadReadAll() {	
		List<Road> list = roadRepository.roadReadAll();

		return list;
	}

	@Override
	public Road roadReadOne(String roadId) {
		Road road = roadRepository.roadReadOne(roadId);
		return road;
	}

	@Override
	public void roadUpdate(Road road) {
		roadRepository.roadUpdate(road);		
	}
	

}
