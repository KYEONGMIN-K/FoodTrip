<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div id=map style="width:70%;height:550px;">
		<!-- 지도 공간  -->
		
	</div>
	<!-- 코스 리스트 -->
	<ul id="placesList">
	
	</ul>
	
	<script src="http://code.jquery.com/jquery-latest.min.js"></script>
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey="></script>
	<script>
	var courseObj=[];
	var markers = [];
	var sw = new kakao.maps.LatLng(35.180809, 128.547572),
		ne = new kakao.maps.LatLng(35.251352, 128.731078);
	
	var listEl = document.querySelector('#placesList');
	// 지도 출력을 위한 기본적인 코드 -------- START
	var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
	    mapOption = { 
	        center: new kakao.maps.LatLng(35.2538433, 128.6402609), // 지도의 중심좌표
	        level: 6 // 지도의 확대 레벨
	    };
	
	// 지도를 표시할 div와  지도 옵션으로  지도를 생성합니다
	var map = new kakao.maps.Map(mapContainer, mapOption); 
	// 지도 출력을 위한 기본적인 코드 -------- END
	
	getAllRoad();
		
	function getAllRoad(){
		$.ajax({
			url : "readRoad",
			type : "post", 
			success : function(response){
				courseObj = response;
				console.log(courseObj);
				addList();
			}
			
		});
	}
	
	function addList(){
		//리스트에 코스를 표시하는 함수
		//courseObj : 요청에 대한 응답 json 배열
		
		for(var i=0; i<courseObj.length; i++){
			
			(function(index){
				var data = courseObj[index];
				var list = document.createElement('li');
				list.setAttribute("id", "cslist");
				list.innerHTML = '<div>'+data.category+'</div><br><div>'+data.roadId+'</div><br><div><a href="/FoodTrip/road/roadUpdate?id='+data.roadId+'">수정</a><a href="/FoodTrip/road/roadDelete?id='+data.roadId+'">삭제</a></div>'
				list.addEventListener("click", function(){
					viewMarker(data);					
				});
				listEl.appendChild(list);
			})(i);
			
		}
	}
	
	function viewMarker(data){ 
		//console.log(data);
		//console.log(data.points);
		markerRemove();
		var bounds = new kakao.maps.LatLngBounds(); 
		for(var i=0; i<data.points.length; i++){
			(function(index){	
				var ary = data.points;
				
			    bounds = new kakao.maps.LatLngBounds(), 
			    listStr = '';
			 
				 var placePosition = new kakao.maps.LatLng(ary[index].pointY, ary[index].pointX);
				// console.log(ary[i]);

				 var imageSrc = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_number_blue.png', // 마커 이미지 url, 스프라이트 이미지를 씁니다
			        imageSize = new kakao.maps.Size(36, 37),  // 마커 이미지의 크기
			        imgOptions =  {
			            spriteSize : new kakao.maps.Size(36, 691), // 스프라이트 이미지의 크기
			            spriteOrigin : new kakao.maps.Point(0, (index*46)+10), // 스프라이트 이미지 중 사용할 영역의 좌상단 좌표
			            offset: new kakao.maps.Point(13, 37) // 마커 좌표에 일치시킬 이미지 내에서의 좌표
			        },
			        markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imgOptions),
			            marker = new kakao.maps.Marker({
			            position: placePosition, // 마커의 위치
			            image: markerImage 
			        });
					console.log(map);
					 marker.setMap(map); // 지도 위에 마커를 표출합니다
					 markers.push(marker);  // 배열에 생성된 마커를 추가합니다

				 bounds.extend(placePosition);	
			})(i);
		}
		
		//마지막 시점전환
		bounds = new kakao.maps.LatLngBounds(sw, ne); 
		map.setBounds(bounds);
	}
	
	function markerRemove(){
		console.log("rm IN");
		for ( var i = 0; i < markers.length; i++ ) {
			markers[i].setMap(null);
			//useMarker[i].setMap(null);
			//console.log(userMarker);
	    }
		markers = [];
	}
	
	</script>
</body>
</html>