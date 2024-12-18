<%@ page isELIgnored="false" language="java" contentType="text/html; charset=UTF-8"
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
	.markerlist div{
		display:block;
	}
	.mymlist{
		width:100%;
		list-style : none;
		display:flex;
		flex-wrap:wrap;
	}
	.mymlist div{
		display:block;
	}
	.listCh {
		margin-top: 10px;
		margin-left: 20px;
		margin-bottom: 10px;
		border: 1px solid #000000;
	}
</style>
</head>
<body>
	<%@ include file="../menu/menu.jsp" %>
	<div id=map style="width:100%;height:550px;">
		<!-- 지도 공간  -->
		
	</div>
	
	<div id="menu">
		<button id="update">코스 수정</button>
		<button id="reset">리셋</button>
	<!-- <select id="choice">
			<option value="chicken">치킨</option>
			<option value="chinese">중식</option>
			<option value="pasta">파스타</option>
			<option value="snack">분식</option>
			<option value=disert>디저트</option>
		</select>-->
	</div> 
	<!-- 마커 리스트  -->
	<div class="container">
		<div class="mymlist">
			<div class="listblock">
				<h3>관광지</h3>
				<ul class="mytourlist">
					
				</ul>
			</div>
			<br><br>
			<div class="listblock">		
				<h3>음식점</h3>
				<ul class="myrestlist">
					
				</ul>
			</div>		
			<br><br>
			<div class="listblock">
				<h3>숙소</h3>
				<ul class="mystaylist">
					
				</ul>
			</div>
		</div>
	</div>
	<hr><hr>
	<div class="container">
		<div class="markerlist">
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
	</div>
<!-- 	
	<ul class="mymlist">
		<h3>내가 선택한 마커</h3>
	
	</ul>
	<hr><hr><br>
	<ul class="markerlist">
	
	</ul>	
 -->
	
	<script src="http://code.jquery.com/jquery-latest.min.js"></script>
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=a8fb3e9990ea2c741f7c154e957f99be"></script>
	<script>
	var rid = "${id}";

	var sw = new kakao.maps.LatLng(35.180809, 128.547572),
		ne = new kakao.maps.LatLng(35.251352, 128.731078);
	var dellist;
	
	var indexG;
	
	var listEl = document.querySelector('#placesList');
	var choice = document.querySelector("#choice");
	
	var userNick = "admin";	//사용자 닉네임 저장
	
	var rsbtn = document.querySelector("#reset");
	var upbtn = document.querySelector("#update");
	var allMarkers;
	var oneRoad;
	
	//지도에 표시된 마커 객체를 가지고 있을 배열입니다
	var markers = [];   // 맵에 출력되는 마커 객체 배열, 지도에 마커 출력을 위해 사용
	var useMarker = []; // 마커가 가지고 있는 정보를 담는 데이터 배열, 리스트 및 마커가 어떤 정보를 가지고 있는지(장소이름, 위도경도 등)
	var viewlist = [];	// 보여지는 리스트 중 내가 선택하지 않은 마커들의 배열
	var mlist = document.querySelector(".markerlist");
	var mylist = document.querySelector(".mymlist");
	var mytourParents = document.querySelector(".mytourlist");
	var mystayParents = document.querySelector(".mystaylist");
	var myrestParents = document.querySelector(".myrestlist");
	var tourParents = document.querySelector(".tourlist");
	var stayParents = document.querySelector(".staylist");
	var restParents = document.querySelector(".restlist");
	
	
	var sendObj = {
			"roadId":"",
			"user":"",
			"plan":[],
			"createtime":"",
			"endtime":"",
			"category":"",
			"courseSize":""
	}; 
	
	var dto = {
			"roadId":"",
			"userNick":"",
			"courseSize":"",
			"category":"",
			"points":[]
	};
	
	var mkdto = 
		{
			"address":"",
			"category":"", 
			"description":"",
			"markerId":"",
			"phone":"",
			"pointName":"",
			"pointX":"",
			"pointY":"" 
		}
	var mkdtoAry= [];		

	
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
	//console.log(map);
	rsbtn.addEventListener("click", markerRemove);
	upbtn.addEventListener("click", planCreate);
	
	//ajax를 동기식으로 바꾸면 함수 호출 위치에 따라 되는게 있고 안되는게 있다.
	//1. 가장 먼저 실행되는 함수, 마커 리스트를 출력
	getOneRoad();
	getAllMarker();	

	function getOneRoad(){
		$.ajax({
			url : "readOneRoad",
			type : "post",
			data : JSON.stringify("${id}"),
			async : false,
			contentType : "application/json",
			success : function(response){
				//전역 변수 복제
				copyResp(response);
				//가져온 하나의 마커를 따로 찍는다.
				setMyMarker(dto);

			}
		});
	}
	//console.log(dto);
	function copyResp(orgData){
		//마커정보
		dto.roadId = orgData.roadId;
		dto.userNick = orgData.userNick;
		dto.courseSize = orgData.courseSize;
		dto.category = orgData.category;
		for(var i=0; i<orgData.courseSize; i++){
//			console.log(orgData.points[i]);
			dto.points[i] = orgData.points[i];	
		}
	}

	/*
	 * 처음 로딩 시 DB에 저장된 모든 마커를 가져와 리스트로 출력해주는 함수
	*/
	function getAllMarker(){
		$.ajax({
			url : "readMkAll",
			type : "get",
			async : false,			
			success: function(response) {
		        console.log(response);  // 응답 구조를 확인
				//JSON.stringify(response);
		        //콜백함수
		        //callback(response);
				//allMarkers = response;
		        // 응답이 배열인지 확인하고, 배열이 비어있지 않으면 첫 번째 항목을 사용
		        if (Array.isArray(response) && response.length > 0) {
		        	copyMk(response);
		        //	console.log(mkdto);
		        //	console.log(mkdtoAry);
		        	addElements(mkdtoAry);
		            // 첫 번째 항목의 데이터로 필드를 채웁니다
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
	
	function copyMk(markerlist){
	
		console.log(markerlist.length);
		for(var i=0; i<markerlist.length; i++){
			(function(index){
				
			//객체를 새로 생성하지 않으면 참조 오류가 생긴다.
			 var mkdto = {
			      "address": markerlist[index].address,
			      "category": markerlist[index].category,
			      "description": markerlist[index].description,
			      "markerId": markerlist[index].markerId,
			      "phone": markerlist[index].phone,
			      "pointName": markerlist[index].pointName,
			      "pointX": markerlist[index].pointX,
			      "pointY": markerlist[index].pointY
				};

				mkdtoAry.push(mkdto);
			})(i);
		}
	}
		
	function setMyMarker(data){
		markerRemove();
		console.log("setmymarker : "+useMarker.length);
		//objMapping(data);	//가져온 dto(road) 하나를 복제
		var list = document.createElement('li');
		//console.log(data);
		indexG = data.courseSize;
		var myMarker = data.points;
		for(var i=0; i<data.courseSize; i++){		
			(function(index){
				//console.log("index: "+index);
				//console.log(myMarker);
				var bounds = new kakao.maps.LatLngBounds(sw, ne);
				var placePosition = new kakao.maps.LatLng(myMarker[index].pointY, myMarker[index].pointX);
				//kakao.maps.LatLngBounds() 내 파라미터를 주지 않으면 빈 공간을 생성한다.
				
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
			    marker.setMap(map); 	// 지도 위에 마커를 표출합니다
			   	markers.push(marker);   // 배열에 생성된 마커를 추가합니다
			   	console.log(useMarker);
			   	useMarker.push(myMarker[index]);		//사용자가 지정한 마커가 순서대로 배열에 저장
			   //	console.log(markers);
			})(i);
		}
		//console.log(useMarker);
	}

	//전체 마커 리스트 생성 ---- 그리기
	function addElements(data){
		//console.log("addelements in");
		//console.log(data);
		//리스트를 추가할 부모 요소
		//console.log(mytourParents);
		//listReset(mlist, mylist);
		//가져온 전체 마커를 반복
		mytourParents.innerHTML = "";
		tourParents.innerHTML = "";
		mystayParents.innerHTML = "";
		stayParents.innerHTML = "";
		myrestParents.innerHTML = "";
		restParents.innerHTML = "";
		for(var i=0; i<data.length; i++){
		//	console.log(data[i].markerId);
			(function(index){
				//console.log("바깥 for문"+ index);
				//반복할 때, 내가 이미 선택한 마커는 위쪽에 배치되게?
				var dataOne	= data[index];	
					
				//console.log(dataOne.pointX);
				var list = document.createElement('li');
				
				var addbtn = document.createElement('button');
				addbtn.innerHTML = "추가";
				
				var delbtn = document.createElement('button');
				delbtn.innerHTML = "삭제";
				delbtn.setAttribute("id", "delList"+dataOne.markerId);
				//button id='delList"+dataOne.markerId+"
				delbtn.addEventListener("click", function(event){
					
					deleteMarker(dataOne);
					setMyMarker(dto);
					addElements(mkdtoAry);
				});
				
				//함수에 파라미터 전달을 위해 아래 방식으로 구현
				addbtn.addEventListener("click", function(){
					place = dataOne;
					addMarker(place);
					addElements(mkdtoAry);
				});

				list.innerHTML='<div class="category">'+dataOne.category+"</div><div class='pointName'>"
								+ dataOne.pointName + "</div><div class='phone'>"
								+ dataOne.phone + "</div><div class='address'>"
								+ dataOne.address + "</div><a href='"+dataOne.description +"' class='description' target='_blank'>사이트이동</a>";

				//console.log("여기 안와?");
				//var exvalue = 0;
				//var delvalue = 0;
				console.log(useMarker.length);
				var cate = dataOne.markerId.substring(0,2);
				//listMake(list, dataOne);
				console.log(cate);
				if(useMarker.length>0){
					for(var j=0; j<useMarker.length; j++){
						if(useMarker[j].markerId == dataOne.markerId){
							//console.log(parent);
							//console.log(tourParents);
							if(cate == "TU"){
								mytourParents.appendChild(list);
								//mylist.appendChild(tourParents);
							}else if(cate == "RS"){
								myrestParents.appendChild(list);
								//mylist.appendChild(restParents);
							}else if(cate == "HT"){
								mystayParents.appendChild(list);
								//mylist.appendChild(stayParents);
							}
							list.setAttribute("class", "select");
							list.appendChild(delbtn);
							//mylist.appendChild(list);
							break;
						}else{
							//배열을 끝까지 순회한 후에도 같은 마커가 없다면
							if(j == useMarker.length-1){
								//console.log(parent);
							//	console.log(tourParents);
								if(cate == "TU"){
									tourParents.appendChild(list);
									//mlist.appendChild(tourParents);
								}else if(cate == "RS"){
									restParents.appendChild(list);
									//mlist.appendChild(restParents);
								}else if(cate == "HT"){
									stayParents.appendChild(list);
									//mlist.appendChild(stayParents);
								}
								list.setAttribute("class", "none");
								list.appendChild(addbtn);
								//mlist.appendChild(list);
							}
						}
					}
				}else{
					list.setAttribute("class", "none");
					list.appendChild(addbtn);
					mlist.appendChild(list);
				}
				
				
			})(i);
		}
	}
	
	function listMake(list, data){
		list.innerHTML='<div class="category">'+data.category+"</div><div class='pointName'>"
		+ data.pointName + "</div><div class='phone'>"
		+ data.phone + "</div><div class='address'>"
		+ data.address + "</div><a href='"+data.description +"' class='description' target='_blank'>사이트이동</a>";
	}
	
	
	//마커 추가함수
	function addMarker(data){
		var place = data;
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
	   		
	   	  // 이미 markers 배열에 해당 마커가 없으면 추가

            marker.setMap(map); // 지도에 마커 추가
            markers.push(marker); // 마커 배열에 추가
            useMarker.push(place); // 사용자 마커 배열에 추가
            dto.points.push(place);
            dto.courseSize++;
            indexG++;
	        
		    marker.setMap(map); 		// 지도 위에 마커를 표출합니다

			//addElements(mkdtoAry);
		    
		   	//setMyMarker(dto);
	   	}
	   	//----------중복 안되면 추가 END
	   	
		//console.log(useMarker);
	    bounds.extend(placePosition);
	    map.setBounds(bounds);
	    
	    if (markers.length > 1) {
	        map.setBounds(bounds);
	    } else {
	        map.setCenter(placePosition); // 마커가 하나면 중앙 설정
	    }
	}
	
	//마커 삭제함수
	function deleteMarker(dataOne){
		var id = event.target.id;
		//console.log(id);
		var tmp = id.substring(7);  //id 
		//console.log(tmp);
		console.log(useMarker);
		console.log(useMarker.length);
		for(var i=0; i<useMarker.length; i++){
			//console.log(useMarker[i].markerId);
			if(tmp === useMarker[i].markerId){
				//console.log("같다");
				//리스트 제거
				viewlist.push(dataOne);
				var tmp = event.target.parentElement;
				console.log(tmp);
				tmp.remove();
				//console.log(tmp.parentElement);
				
				//배열 요소 제거
				useMarker.splice(i,1);
				dto.points.splice(i,1);
				dto.courseSize--;
				console.log(useMarker);
				break;
			}	
		}
	}

	//현재 사용안함
	function listReset(list1, list2){
		list1.replaceChildren();
		list2.replaceChildren();
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
		//console.log(markers);
	}
	
	//빼기 버튼 누르면 요소 하나 삭제
	function markerRemoveOne(event){
		//markers
		//console.log(event.target);
		var id = event.target.id;
	//	console.log(id);
		var tmp = id.substring(7);  //id 
		//console.log(tmp);
		//console.log(useMarker);
		
		for(var i=0; i<useMarker.length; i++){
			//console.log(useMarker[i].markerId);
			if(tmp === useMarker[i].markerId){
				//console.log("같다");
				useMarker.splice(i, 1);
				//console.log(useMarker);
			}	
		}
			
		/*
		document.getElementById("buttonContainer").addEventListener("click", function(event) {
		    if (event.target.tagName === "BUTTON") { // 클릭한 요소가 <button>인지 확인
		        const buttonId = event.target.getAttribute("data-id"); // 버튼의 data-id 값 가져오기
		        console.log(`클릭한 버튼의 ID: ${buttonId}`);
		        console.log(`클릭한 버튼의 텍스트: ${event.target.innerText}`);
		    }
		});
		*/
	}
	
	/*
		배열 내에 같은 마커가 있는지 없는지 검사
		return : 0 중복 없음 , 1 중복
	*/
	function isDuplicate(data){
		//console.log(data);
		var compared = 0;
		//console.log("useMarker.length"+ useMarker.length);
		if(useMarker.length <= 0){
			return 0;
		}else{
			for(var i=0; i<useMarker.length; i++){
				//console.log(data.markerId +" | " + useMarker[i].markerId);
				if(data.markerId !== useMarker[i].markerId){
					//console.log("diff data push");
				}else{
					//console.log("Same data ...  continue ");
					return 1;
				}		
			}
		}
		return 0;
	}
	
	function planCreate(){
		var data = new Date();
		sendObj.roadId = rid;		
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
		$.ajax({
			url : "/FoodTrip/road/roadUpExe",
			type : "post",
			data : JSON.stringify(sendObj),
			contentType : "application/json",
			success : function(response){
				alert("코스 생성 및 저장완료");
				markerRemove();
				objReset();
				window.location.href ='readRoad';
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
	
	
	</script>
</body>
</html>