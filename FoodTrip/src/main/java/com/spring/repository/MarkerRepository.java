package com.spring.repository;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.spring.domain.Marker;

public interface MarkerRepository {
	void markerCreate(Marker marker);
	List<Marker> markerReadAll();
	Boolean isExist(String name, String addr);
	Marker markerReadOne(String markerId);
	void markerUpdate(Marker marker);
	void markerDelete(String markerId);
}
