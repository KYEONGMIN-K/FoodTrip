<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="/FoodTrip/resources/css/menu.css"/>
<style>
	.markerlist{
		width:100%;
		list-style : none;
		display:flex;
		flex-wrap:wrap;
	}
	.listCh {
		margin-top: 10px;
		margin-left: 20px;
		margin-bottom: 10px;
		border: 1px solid #000000;
	}
	.wrap {position: absolute;left: 0;bottom: 40px;width: 288px;height: 132px;margin-left: -144px;text-align: left;overflow: hidden;font-size: 12px;font-family: 'Malgun Gothic', dotum, '돋움', sans-serif;line-height: 1.5;}
    .wrap * {padding: 0;margin: 0;}
    .wrap .info {width: 286px;height: 120px;border-radius: 5px;border-bottom: 2px solid #ccc;border-right: 1px solid #ccc;overflow: hidden;background: #fff;}
    .wrap .info:nth-child(1) {border: 0;box-shadow: 0px 1px 2px #888;}
    .info .title {padding: 5px 0 0 10px;height: 30px;background: #eee;border-bottom: 1px solid #ddd;font-size: 18px;font-weight: bold;}
    .info .close {position: absolute;top: 10px;right: 10px;color: #888;width: 17px;height: 17px;background: url('https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/overlay_close.png');}
    .info .close:hover {cursor: pointer;}
    .info .body {position: relative;overflow: hidden;}
    .info .desc {position: relative;margin: 13px 0 0 90px;height: 75px;}
    .desc .ellipsis {overflow: hidden;text-overflow: ellipsis;white-space: nowrap;}
    .desc .jibun {font-size: 11px;color: #888;margin-top: -2px;}
    .info .img {position: absolute;top: 6px;left: 5px;width: 73px;height: 71px;border: 1px solid #ddd;color: #888;overflow: hidden;}
    .info:after {content: '';position: absolute;margin-left: -12px;left: 50%;bottom: 0;width: 22px;height: 12px;background: url('https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/vertex_white.png')}
    .info .link {color: #5085BB;}
</style>
</head>
<body>
	<%@ include file="../menu/menu.jsp" %>
	<div id=map style="width:100%;height:550px;">
		<!-- 지도 공간  -->
		
	</div>
	<div id="menu">
		<button id="create">코스 생성</button>
		<button id="reset">리셋</button>
		<select id="choice">
			<option value="chicken">치킨</option>
			<option value="chinese">중식</option>
			<option value="pasta">파스타</option>
			<option value="snack">분식</option>
			<option value=disert>디저트</option>
		</select>
	</div>
	<!-- 마커 리스트  -->
	<div>
		코스에 대한 설명 : 
		<textarea cols="100" rows="10" id="description"></textarea>
	</div>
	<h2>마커 리스트</h2>
	<div class="container">
		<div class="listblock">
			<h3>관광지</h3>
			<ul class="tourlist">
				
			</ul>
		</div>
		<br><br>
		<div class="listblock">		
			<h3>음식점</h3>
			<ul class="restlist">
				
			</ul>
		</div>		
		<br><br>
		<div class="listblock">
			<h3>숙소</h3>
			<ul class="staylist">
				
			</ul>
		</div>
	</div>
	
	<script src="http://code.jquery.com/jquery-latest.min.js"></script>
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=a8fb3e9990ea2c741f7c154e957f99be"></script>
	<script>
	var choice = document.querySelector("#choice");
	
	var userNick = "admin";
	
	var rsbtn = document.querySelector("#reset");		
	var create = document.querySelector("#create");
	var desc = document.querySelector("#description");
	var overId;	
	var indexG;
	var overlay;
	var overlayAry= [];
	var dtoList=[];
	var dtoObj = {
		"inputdata":"",
		"markerId":"",
		"pointX":"",
		"pointY":"",
		"category":"",
		"pointName":"",
		"phone":"",
		"address":"",
		"description":""
	};
	//지도에 표시된 마커 객체를 가지고 있을 배열입니다
	var markers = [];  // 맵에 출력되는 마커 객체 배열, 지도에 마커 출력을 위해 사용
	var useMarker = [];// 마커가 가지고 있는 정보를 담는 데이터 배열, 리스트 및 마커가 어떤 정보를 가지고 있는지(장소이름, 위도경도 등)
	var sendObj = {
			"user":"",
			"plan":[],
			"createtime":"",
			"endtime":"",
			"category":"",
			"courseSize":"",
			"description":""
	};
	
	//1. 가장 먼저 실행되는 함수, 마커 리스트를 출력
	getAllMarker();	
	
	//
	var sw = new kakao.maps.LatLng(35.180809, 128.547572),
    	ne = new kakao.maps.LatLng(35.251352, 128.731078);
	
	// 지도 출력을 위한 기본적인 코드 -------- START
	var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
	    mapOption = { 
	        center: new kakao.maps.LatLng(35.2538433, 128.6402609), // 지도의 중심좌표
	        level: 9 // 지도의 확대 레벨
	    };
	
	// 지도를 표시할 div와  지도 옵션으로  지도를 생성합니다
	var map = new kakao.maps.Map(mapContainer, mapOption); 
	// 지도 출력을 위한 기본적인 코드 -------- END
	
	rsbtn.addEventListener("click", markerRemove);
	create.addEventListener("click", planCreate);
	/*
	 * 처음 로딩 시 DB에 저장된 모든 마커를 가져와 리스트로 출력해주는 함수
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
		        	copyMk(response);
		        	addElements(dtoList);
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
		
	//처음 리스트 생성	
	function addElements(data){
		var tourParents = document.querySelector(".tourlist");
		var stayParents = document.querySelector(".staylist");
		var restParents = document.querySelector(".restlist");
		
		//console.log(data[0].category);
		for(var i=0; i<data.length; i++){
			//console.log(data[i].markerId);
			(function(index){
				var dataOne	= data[index];	
				//console.log(dataOne.pointX);
				var list = document.createElement('li');
				
				//함수에 파라미터 전달을 위해 아래 방식으로 구현
				list.addEventListener("click", function(place){
					indexG = useMarker.length;
					place = dataOne;
					//console.log(place.pointX);
					var bounds = new kakao.maps.LatLngBounds(sw, ne);
					var placePosition = new kakao.maps.LatLng(place.pointY ,place.pointX);
					//kakao.maps.LatLngBounds() 내 파라미터를 주지 않으면 빈 공간을 생성한다.

				   	//중복검사 로직 추가 ------- START
				   	var result = isDuplicate(place);		
				   	
				   	if(result==0){
				   	 	var imageSrc = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_number_blue.png', // 마커 이미지 url, 스프라이트 이미지를 씁니다
				        imageSize = new kakao.maps.Size(36, 37),  // 마커 이미지의 크기
				        imgOptions =  {
				            spriteSize : new kakao.maps.Size(36, 691), // 스프라이트 이미지의 크기
				            spriteOrigin : new kakao.maps.Point(0, (indexG*46)+10), // 스프라이트 이미지 중 사용할 영역의 좌상단 좌표
				            offset: new kakao.maps.Point(13, 37) // 마커 좌표에 일치시킬 이미지 내에서의 좌표
				        },
				        markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imgOptions),
				            marker = new kakao.maps.Marker({
				            position: placePosition, // 마커의 위치
				            image: markerImage				            
				        });
				   	 	closeOverlayAll();
				   	 	createOverLay(marker, place);
					   	//overlayAry.push(overlay);
					   	//console.log(overlayAry);
					    marker.setMap(map); // 지도 위에 마커를 표출합니다
					   	markers.push(marker);  // 배열에 생성된 마커를 추가합니다
					   	useMarker.push(place);		//사용자가 지정한 마커가 순서대로 배열에 저장
					   	
					   	bounds.extend(placePosition);
					    map.setBounds(bounds);
				   	}	
				   	//----------중복 안되면 추가 END
				   	
					//console.log(useMarker);
				    
				    
				    if (markers.length > 1) {
				        map.setBounds(bounds);
				    } else {
				        map.setCenter(placePosition); // 마커가 하나면 중앙 설정
				    }
				});
				list.setAttribute("class", "listCh");
				
				var cate = dataOne.markerId.substring(0,2);
				listMake(list, dataOne);
				
				if(cate == "TU"){
					tourParents.appendChild(list);
				}else if(cate == "RS"){
					restParents.appendChild(list);
				}else if(cate == "HT"){
					stayParents.appendChild(list);
				}
			})(i);
		}
		
	}
	
	function createOverLay(marker, data){
	   		overId = overlayAry.length;
	   		// console.log(overlayAry);
	   		console.log("overid : "+overId);
	   		var content = '<div class="wrap">' + 
        	'    <div class="info">' + 
            '        <div class="title">' + 
            '            '+ data.pointName + 
            '            <div class="close" onclick="closeOverlay('+overId+')" title="닫기"></div>' + 
            '        </div>' + 
            '        <div class="body">' + 
            '            <div class="img">' +
            '                <img src="https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/thumnail.png" width="73" height="70">' +
            '           </div>' + 
            '            <div class="desc">' + 
            '                <div class="ellipsis">'+ data.address +'</div>' +  
            '                <div><a href='+ data.description  +' target="_blank" class="link">사이트이동</a></div>' + 
            '            </div>' + 
            '        </div>' + 
            '    </div>' +    
            '</div>';	            	
        	//closeOverlay();
        	var overlay = new kakao.maps.CustomOverlay({
        	    content: content,
        	    map: map,
        	    position: marker.getPosition()       
        	});
        	overlayAry.push(overlay);
        	
           	kakao.maps.event.addListener(marker, 'click', function() {
	            	overlay.setMap(map);
           	});
	}
	function closeOverlayAll(){
		for(var i=0; i<overlayAry.length; i++){
			overlayAry[i].setMap(null);
		}
	}	
	
	function closeOverlay(id) {
		console.log("close!");
		//console.log(overlayAry[id]);
		overlayAry[id].setMap(null);
	    //overlay.setMap(null);     
	}
	
	function listMake(list, data){
		list.innerHTML='<div class="category">'+data.category+"</div><div class='pointName'>"
		+ data.pointName + "</div><div class='phone'>"
		+ data.phone + "</div><div class='address'>"
		+ data.address + "</div><a href='"+data.description +"' class='description' target='_blank'>사이트이동</a>";
	}
	
	function copyMk(markerlist){
		//console.log(markerlist.length);
		for(var i=0; i<markerlist.length; i++){
			(function(index){
			//객체를 새로 생성하지 않으면 참조 오류가 생긴다.
			var dtoObj ={
				"markerId":markerlist[index].markerId,
				"pointX": markerlist[index].pointX,
			    "pointY": markerlist[index].pointY,
				"category":markerlist[index].category,
				"pointName":markerlist[index].pointName,
				"phone":markerlist[index].phone,
				"address": markerlist[index].address,
				"description":markerlist[index].description
			};

			dtoList.push(dtoObj);
			})(i);
		}
	}
	
	//리셋 버튼 클릭 시 맵에 존재하는 모든 마커 삭제
	function markerRemove(){
		console.log("rm IN");
		for ( var i = 0; i < markers.length; i++ ) {
			markers[i].setMap(null);
			//useMarker[i].setMap(null);
			//console.log(userMarker);
	    }   
		useMarker = [];
		indexG=0;
		console.log(markers);
	}
	
	/*
		배열 내에 같은 마커가 있는지 없는지 검사
		return : 0 중복 없음 , 1 중복
	*/
	function isDuplicate(data){
		//console.log(data);
		var compared = 0;
		console.log("useMarker.length"+ useMarker.length);
		if(useMarker.length <= 0){
			return 0;
		}else{
			for(var i=0; i<useMarker.length; i++){
				console.log(data.markerId +" | " + useMarker[i].markerId);
				if(data.markerId !== useMarker[i].markerId){
					console.log("diff data push");
				}else{
					console.log("Same data ...  continue ");
					return 1;
				}		
			}
		}
		return 0;
	}
	
	function planCreate(){
		var data = new Date();
		sendObj.user = userNick;
		console.log("userncik : "+ sendObj.user);
		for(var i=0; i<useMarker.length; i++){
			sendObj.plan[i] = useMarker[i].markerId;
		}		
		//sendObj.createtime = data.toLocaleString(); //사용자가 생성했을 때
		sendObj.createtime = "";
		sendObj.endtime = "";
		sendObj.category = choice.value;
		sendObj.courseSize = useMarker.length;
		sendObj.description = desc.value;
		$.ajax({
			url : "/FoodTrip/road/addCourse",
			type : "post",
			data : JSON.stringify(sendObj),
			contentType : "application/json",
			success : function(response){
				alert("코스 생성 및 저장완료");
				closeOverlayAll();
				markerRemove();
				objReset();
			}
		});
	}
	
	function objReset(){
		sendObj.user = "";
		sendObj.plan = [];		
		//sendObj.createtime = data.toLocaleString(); //사용자가 생성했을 때
		sendObj.createtime = "";
		sendObj.endtime = "";
		sendObj.category = "";
		sendObj.courseSize = "";
	}
	
	// 여행 계획 함수
	function planner(){
		//출발지 및 도착지 선택
	}
	</script>
</body>
</html>