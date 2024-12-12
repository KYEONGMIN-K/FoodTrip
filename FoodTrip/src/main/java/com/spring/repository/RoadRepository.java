package com.spring.repository;

import java.util.List;

import com.spring.domain.Road;

public interface RoadRepository {
	void roadCreate(Road road);
	void roadDelete(String roadId);
	List<Road> roadReadAll();
	Road roadReadOne(String roadId);
	void roadUpdate(Road road);
}
