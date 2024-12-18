<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="/FoodTrip/resources/css/menu.css"/>
<style>
	.contain{
		display:flex;
	}
</style>
</head>
<body>
	<%@ include file="../menu/menu.jsp" %>
<div class="contain">
	<div id=map style="width:100%;height:550px;">
		<!-- 지도 공간  -->
		
	</div>
	<!-- 코스 리스트 -->
	<div>
		<h2>생성되어 있는 코스</h2>
		<ul id="placesList">
		
		</ul>
	</div>
</div>
	<script src="http://code.jquery.com/jquery-latest.min.js"></script>
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey="></script>
	<script>
	var courseObj=[];
	var markers = [];
	var sw = new kakao.maps.LatLng(35.0966621, 128.4888436),
		ne = new kakao.maps.LatLng(35.3108556, 128.8502120);
	
	var listEl = document.querySelector('#placesList');
	// 지도 출력을 위한 기본적인 코드 -------- START
	var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
	    mapOption = { 
	        center: new kakao.maps.LatLng(35.2538433, 128.6402609), // 지도의 중심좌표
	        level: 9 // 지도의 확대 레벨
	    };
	
	// 지도를 표시할 div와  지도 옵션으로  지도를 생성합니다
	var map = new kakao.maps.Map(mapContainer, mapOption); 
	// 지도 출력을 위한 기본적인 코드 -------- END
	
	getAllRoad();
		
	// 처음 요청을 보내 모든 코스정보를 받아오는 함수
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
	
	//리스트에 코스를 표시하는 함수
	function addList(){
		//courseObj : 요청에 대한 응답 json 배열		
		for(var i=0; i<courseObj.length; i++){
			
			(function(index){
				var data = courseObj[index];
				//console.log(data);
			//	var courseAry = data.points;
				var courseName = [];
				for(var j=0; j<data.points.length; j++){
					courseName[j] = data.points[j].pointName;
				}
				var courseString = courseName.join(" -> ");
				//console.log(courseAry);
				var list = document.createElement('li');
				list.setAttribute("id", "cslist");
				list.innerHTML = '<div>'+data.category+'</div><br><div>'
								+data.description+'</div><br><h3>코스</h3><div>'
								+ courseString +'</div><br>'
								+'<div><a href="/FoodTrip/road/roadUpdate?id='
								+data.roadId+'">수정</a><a href="/FoodTrip/road/roadDelete?id='
								+data.roadId+'">삭제</a></div>'
				list.addEventListener("click", function(){
					viewMarker(data);					
				});
				listEl.appendChild(list);
			})(i);
			
		}
	}
	
	//코스 리스트를 클릭하면 마커가 지도에 보이게
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
					//console.log(map);
					 marker.setMap(map); // 지도 위에 마커를 표출합니다
					 markers.push(marker);  // 배열에 생성된 마커를 추가합니다

				 bounds.extend(placePosition);	
			})(i);
		}
		
		//마지막 시점전환
		bounds = new kakao.maps.LatLngBounds(sw, ne); 
		map.setBounds(bounds);
	}
	
	//모든 마커 지우기 -- 마커 refresh
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