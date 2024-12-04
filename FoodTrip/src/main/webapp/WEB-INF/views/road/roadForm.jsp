<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div id="map" style="width:1000px;height:800px;"></div>
	<div id="view"></div>
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=본인key입력&libraries=services"></script>
	
	<script>
		// 마커를 클릭하면 장소명을 표출할 인포윈도우 입니다
		var infowindow = new kakao.maps.InfoWindow({zIndex:1});
		var viewpoint = document.querySelector("#view");
		
		var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
		    mapOption = {
		        center: new kakao.maps.LatLng(35.2538433, 128.6402609), // 지도의 중심좌표
		        level: 7 // 지도의 확대 레벨
		    };  
		
		// 지도를 생성합니다    
		var map = new kakao.maps.Map(mapContainer, mapOption); 
		
		
		var centerPosition; // 원의 중심좌표 입니다
		var drawingCircle; // 그려지고 있는 원을 표시할 원 객체입니다
		var drawingLine; // 그려지고 있는 원의 반지름을 표시할 선 객체입니다
		var drawingOverlay; // 그려지고 있는 원의 반경을 표시할 커스텀오버레이 입니다
		var drawingDot; // 그려지고 있는 원의 중심점을 표시할 커스텀오버레이 입니다
		
		/*
			
			***** 클릭하면 지도에 마커 생성 *****	
		
		*/
		
		//지도를 클릭했을때 클릭한 위치에 마커를 추가하도록 지도에 클릭이벤트를 등록합니다
		kakao.maps.event.addListener(map, 'click', function(mouseEvent) {        
		    // 클릭한 위치에 마커를 표시합니다 
		    addMarker(mouseEvent.latLng);             
		});
		
		//지도에 표시된 마커 객체를 가지고 있을 배열입니다
		var markers = [];
		
		//마커 하나를 지도위에 표시합니다 
		//addMarker(new kakao.maps.LatLng(35.2538433, 128.6402609));
		
		// 마커를 생성하고 지도위에 표시하는 함수입니다
		function addMarker(position) {
		    
		    // 마커를 생성합니다
		    var marker = new kakao.maps.Marker({
		        position: position
		    });
		
		    // 마커가 지도 위에 표시되도록 설정합니다
		    marker.setMap(map);
		    
		    // 생성된 마커를 배열에 추가합니다
		    markers.push(marker);
		    
		    kakao.maps.event.addListener(marker, 'click', function() {
		        // 마커를 클릭하면 장소명이 인포윈도우에 표출됩니다
		        infowindow.setContent('<div style="padding:5px;font-size:12px;">' + '생성된 마커' + '</div>');
		        infowindow.open(map, marker);
		    });
		}
		
		// 배열에 추가된 마커들을 지도에 표시하거나 삭제하는 함수입니다
		function setMarkers(map) {
		    for (var i = 0; i < markers.length; i++) {
		        markers[i].setMap(map);
		    }            
		}
		
		// 장소 검색 객체를 생성합니다
		var tour = new kakao.maps.services.Places(); 
		// 키워드로 장소를 검색합니다
		// keywordSearch('키워드', 함수)
		tour.keywordSearch('창원 관광지', placesSearchCB); 
		/*
			목표 : 관광지 마커만 생성 후, 숙박과 음식점을 반경 내에서 생성한다.
		*/
		
		
		
		
		
		// 키워드 검색 완료 시 호출되는 콜백함수 입니다
		function placesSearchCB (data, status, pagination) {
		    if (status === kakao.maps.services.Status.OK) {
		
		        // 검색된 장소 위치를 기준으로 지도 범위를 재설정하기위해
		        // LatLngBounds 객체에 좌표를 추가합니다
		        var bounds = new kakao.maps.LatLngBounds();
		        viewpoint.innerHTML = data.length;
		        for (var i=0; i<data.length; i++) {
		        	
		            displayMarker(data[i]);    
		            bounds.extend(new kakao.maps.LatLng(data[i].y, data[i].x));
		        }       
		
		        // 검색된 장소 위치를 기준으로 지도 범위를 재설정합니다
		        map.setBounds(bounds);
		    } 
		}
		function placesSearchCB2 (data, status, pagination) {
		    if (status === kakao.maps.services.Status.OK) {
		
		        // 검색된 장소 위치를 기준으로 지도 범위를 재설정하기위해
		        // LatLngBounds 객체에 좌표를 추가합니다
		        var bounds = new kakao.maps.LatLngBounds();
		        viewpoint.innerHTML = data.length;
		        for (var i=0; i<data.length; i++) {
		        	
		        	displayMarkerHotel(data[i]);    
		            bounds.extend(new kakao.maps.LatLng(data[i].y, data[i].x));
		        }       
		
		        // 검색된 장소 위치를 기준으로 지도 범위를 재설정합니다
		        map.setBounds(bounds);
		    } 
		}
		function placesSearchCB3 (data, status, pagination) {
		    if (status === kakao.maps.services.Status.OK) {
		
		        // 검색된 장소 위치를 기준으로 지도 범위를 재설정하기위해
		        // LatLngBounds 객체에 좌표를 추가합니다
		        var bounds = new kakao.maps.LatLngBounds();
		        viewpoint.innerHTML = data.length;
		        for (var i=0; i<data.length; i++) {
		        	
		        	displayMarkerRest(data[i]);    
		            bounds.extend(new kakao.maps.LatLng(data[i].y, data[i].x));
		        }       
		
		        // 검색된 장소 위치를 기준으로 지도 범위를 재설정합니다
		        map.setBounds(bounds);
		    } 
		}
		
		function displayMarkerHotel(place) {
			var imageSrc = '/FoodTrip/resources/images/hotel_marker.png', // 마커이미지의 주소입니다    
			imageSize = new kakao.maps.Size(32, 39), // 마커이미지의 크기입니다
			imageOption = {offset: new kakao.maps.Point(27, 69)}; // 마커이미지의 옵션입니다. 마커의 좌표와 일치시킬 이미지 안에서의 좌표를 설정합니다.
		
			var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imageOption);
			
		    // 마커를 생성하고 지도에 표시합니다
		    var marker = new kakao.maps.Marker({
		        map: map,
		        position: new kakao.maps.LatLng(place.y, place.x), 
		    	image: markerImage
		    });
		
		    // 마커에 클릭이벤트를 등록합니다
		    kakao.maps.event.addListener(marker, 'click', function() {
		    	/*
		    		place의 주요 속성
		    		place_name : 장소명
		    		x : 경도
		    		y : 위도
		    		address_name : 주소
		    	*/
		        // 마커를 클릭하면 장소명이 인포윈도우에 표출됩니다
		        view.innerHTML = 
		        infowindow.setContent('<div style="padding:5px;font-size:12px;">' + 
		        		'<strong>' + place.place_name + '</strong><br>' +
		                '위도: ' + place.y + '<br>' +
		                '경도: ' + place.x + +'</div>');
		        infowindow.open(map, marker);
		    });
		}
		
		function displayMarkerRest(place) {
			var imageSrc = '/FoodTrip/resources/images/rest_marker.png', // 마커이미지의 주소입니다    
			imageSize = new kakao.maps.Size(32, 39), // 마커이미지의 크기입니다
			imageOption = {offset: new kakao.maps.Point(27, 69)}; // 마커이미지의 옵션입니다. 마커의 좌표와 일치시킬 이미지 안에서의 좌표를 설정합니다.
		
			var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imageOption);
			
		    // 마커를 생성하고 지도에 표시합니다
		    var marker = new kakao.maps.Marker({
		        map: map,
		        position: new kakao.maps.LatLng(place.y, place.x), 
		    	image: markerImage
		    });
		
		    // 마커에 클릭이벤트를 등록합니다
		    kakao.maps.event.addListener(marker, 'click', function() {
		    	/*
		    		place의 주요 속성
		    		place_name : 장소명
		    		x : 경도
		    		y : 위도
		    		address_name : 주소
		    	*/
		        // 마커를 클릭하면 장소명이 인포윈도우에 표출됩니다
		        infowindow.setContent('<div style="padding:5px;font-size:12px;">' + 
		        		'<strong>' + place.place_name + '</strong><br>' +
		                '위도: ' + place.y + '<br>' +
		                '경도: ' + place.x + +'</div>');
		        infowindow.open(map, marker);
		    });
		}
		
		
		
		// 지도에 마커를 표시하는 함수입니다 (관광지)
		function displayMarker(place) {
		    var position = new kakao.maps.LatLng(place.y, place.x);
		    // 마커를 생성하고 지도에 표시합니다
		    var marker = new kakao.maps.Marker({
		        map: map,
		        position: position
		    });
		
		    // 마커에 클릭이벤트를 등록합니다
		    kakao.maps.event.addListener(marker, 'click', function() {
		    	
		    	var circle = new kakao.maps.Circle({
		    		center : position,	//원의 중심좌표(생성된 마커 기준)
		    		radius : 1000,		//원의 반지름(m)
		    		strokeWeight: 1, // 선의 두께입니다
		            strokeColor: '#00a0e9', // 선의 색깔입니다
		            strokeOpacity: 0.1, // 선의 불투명도입니다 0에서 1 사이값이며 0에 가까울수록 투명합니다
		            strokeStyle: 'solid', // 선의 스타일입니다
		            fillColor: '#00a0e9', // 채우기 색깔입니다
		            fillOpacity: 0.1  // 채우기 불투명도입니다		    	
		    	});
		    		
		    	circle.setMap(map);		
		    	
		    	if(true 
		    		//여기서 반경 내에 해당하는 마커만 생성될 수 있도록 조건		
		    	){
		    		
		    	}
		    	var accom = new kakao.maps.services.Places();
				var rest = new kakao.maps.services.Places();
				
				accom.keywordSearch('창원 숙박', placesSearchCB2);
				rest.keywordSearch('창원 음식점', placesSearchCB3);
		    	
		        // 마커를 클릭하면 장소명이 인포윈도우에 표출됩니다
		        infowindow.setContent('<div style="padding:5px;font-size:12px;">' + 
		        		'<strong>' + place.place_name + '</strong><br>' +
		                '위도: ' + place.y + '<br>' +
		                '경도: ' + place.x + +'</div>');
		        infowindow.open(map, marker);
		    });
		}
</script>
</body>
</html>