package com.spring.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.spring.domain.Marker;

public interface MarkerService {
	void markerCreate(Marker marker);
	List<Marker> markerReadAll();
	Marker markerReadOne(String markerId);
	void markerUpdate(Marker marker);
	void markerDelete(String markerId);
}
