<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
	.markerlist{
		width:100%;
		list-style : none;
		display:flex;
		flex-wrap:wrap;
	}
	.listCh {
		width: 38%;
		margin-top: 10px;
		margin-left: 20px;
		margin-bottom: 10px;
		border: 1px solid #000000;
	}
</style>
</head>
<body>
		<div id=map style="width:70%;height:550px;">
		<!-- 지도 공간  -->
		
	</div>
	<!-- 마커 리스트  -->
	<ul class="markerlist">
	
	</ul>	
	
	<script src="http://code.jquery.com/jquery-latest.min.js"></script>
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey="></script>
	<script>
	var category= document.querySelector("#category");
	var pName= document.querySelector("#pointName");
	var phone= document.querySelector("#phone");
	var addr= document.querySelector("#address");
	var desc= document.querySelector("#description");
	var useMarker = [];
	getAllMarker();	
	var sw = new kakao.maps.LatLng(35.180809, 128.547572),
    	ne = new kakao.maps.LatLng(35.251352, 128.731078);
	
	var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
	    mapOption = { 
	        center: new kakao.maps.LatLng(35.2538433, 128.6402609), // 지도의 중심좌표
	        level: 6 // 지도의 확대 레벨
	    };
	
	// 지도를 표시할 div와  지도 옵션으로  지도를 생성합니다
	var map = new kakao.maps.Map(mapContainer, mapOption); 

	/*

		***** 클릭하면 지도에 마커 생성 start *****	

	*/
	//지도를 클릭했을때 클릭한 위치에 마커를 추가하도록 지도에 클릭이벤트를 등록합니다
	kakao.maps.event.addListener(map, 'click', function(mouseEvent) {        
	    // 클릭한 위치에 마커를 표시합니다 
	              
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
	/*
			
	***** 클릭하면 지도에 마커 생성 end *****	
		
	*/

	function getAllMarker(){
		$.ajax({
			url : "readMkAll",
			type : "get",
			success: function(response) {
		        //console.log(response);  // 응답 구조를 확인
				JSON.stringify(response);
		        // 응답이 배열인지 확인하고, 배열이 비어있지 않으면 첫 번째 항목을 사용
		        if (Array.isArray(response) && response.length > 0) {
		        	
		        	addElements(response);
		            // 첫 번째 항목의 데이터로 필드를 채웁니다
		            /*
		            category.innerHTML = response[0].category;
		            pName.innerHTML = response[0].pointName;
		            phone.innerHTML = response[0].phone;
		            addr.innerHTML = response[0].address;
		            desc.href = response[0].description;
		            */
		        } else {
		            console.log("응답이 비어있거나 배열이 아닙니다.");
		        }
		    },
		    error: function(xhr, status, error) {
		        //console.error("AJAX 요청 실패:", error);
		        console.log("상태:", status);
		        //console.log("응답 텍스트:", xhr.responseText);
		    }
		});
	}
	
	function addElements(data){
		
		var parent = document.querySelector(".markerlist");
		
		console.log(data[0].category);
		for(var i=0; i<data.length; i++){
			console.log(data[i].markerId);
			(function(index){
				var dataOne	= data[index];	
				//console.log(dataOne.pointX);
				var list = document.createElement('li');
				list.addEventListener("click", function(place){
					useMarker.push(dataOne);		//사용자가 지정한 마커가 순서대로 배열에 저장
					console.log(useMarker);
					place = dataOne;
					//console.log(place.pointX);
					var bounds = new kakao.maps.LatLngBounds(sw, ne);
					var placePosition = new kakao.maps.LatLng(place.pointY ,place.pointX);
					//kakao.maps.LatLngBounds() 내 파라미터를 주지 않으면 빈 공간을 생성한다.

		            marker = new kakao.maps.Marker({
		            	map : map,
		            	position: placePosition, // 마커의 위치
		        	});
					
				    marker.setMap(map); // 지도 위에 마커를 표출합니다
				    markers.push(marker);  // 배열에 생성된 마커를 추가합니다
				    
				    bounds.extend(placePosition);
				    map.setBounds(bounds);
				    
				    if (markers.length > 1) {
				        map.setBounds(bounds);
				    } else {
				        map.setCenter(placePosition); // 마커가 하나면 중앙 설정
				    }
				});
				list.setAttribute("class", "listCh");
				//console.log(data[i].category);
				//console.log("Category" +data[i].category);
				//console.log(index);
				list.innerHTML='<div class="category">'+data[index].category+"</div><div class='pointName'>"
								+ data[index].pointName + "</div><div class='phone'>"
								+ data[index].phone + "</div><div class='address'>"
								+ data[index].address + "</div><a href='"+data[index].description +"' class='description' target='_blank'>"
								+ "사이트이동" +"</a><br><a href='/FoodTrip/marker/markerUpdate?id="+data[index].markerId+"'>수정</a><br><a href='/FoodTrip/marker/delete?id="+data[index].markerId+"'>삭제</a>";
				parent.appendChild(list);	
			})(i);
		}
	}
	
	function poinMarker(place){
	
	}
	</script>
</body>
</html>