<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.spring.domain.*" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="/FoodTrip/resources/css/menu.css"/>
<style>
	.map_wrap, .map_wrap * {margin:0;padding:0;font-family:'Malgun Gothic',dotum,'돋움',sans-serif;font-size:12px;}
	.map_wrap a, .map_wrap a:hover, .map_wrap a:active{color:#000;text-decoration: none;}
	.map_wrap {position:relative;width:70%;height:500px;}
	#menu_wrap {position:absolute;top:0;left:0;bottom:0;width:250px;margin:10px 0 30px 10px;padding:5px;overflow-y:auto;background:rgba(255, 255, 255, 0.7);z-index: 1;font-size:12px;border-radius: 10px;}
	.bg_white {background:#fff;}
	#menu_wrap hr {display: block; height: 1px;border: 0; border-top: 2px solid #5F5F5F;margin:3px 0;}
	#menu_wrap .option{text-align: center;}
	#menu_wrap .option p {margin:10px 0;}  
	#menu_wrap .option button {margin-left:5px;}
	#placesList li {list-style: none;}
	#placesList .item {position:relative;border-bottom:1px solid #888;overflow: hidden;cursor: pointer;min-height: 65px;}
	#placesList .item span {display: block;margin-top:4px;}
	#placesList .item h5, #placesList .item .info {text-overflow: ellipsis;overflow: hidden;white-space: nowrap;}
	#placesList .item .info{padding:10px 0 10px 55px;}
	#placesList .info .gray {color:#8a8a8a;}
	#placesList .info .jibun {padding-left:26px;background:url(https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/places_jibun.png) no-repeat;}
	#placesList .info .tel {color:#009900;}
	#placesList .item .markerbg {float:left;position:absolute;width:36px; height:37px;margin:10px 0 0 10px;background:url(https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_number_blue.png) no-repeat;}
	#placesList .item .marker_1 {background-position: 0 -10px;}
	#placesList .item .marker_2 {background-position: 0 -56px;}
	#placesList .item .marker_3 {background-position: 0 -102px}
	#placesList .item .marker_4 {background-position: 0 -148px;}
	#placesList .item .marker_5 {background-position: 0 -194px;}
	#placesList .item .marker_6 {background-position: 0 -240px;}
	#placesList .item .marker_7 {background-position: 0 -286px;}
	#placesList .item .marker_8 {background-position: 0 -332px;}
	#placesList .item .marker_9 {background-position: 0 -378px;}
	#placesList .item .marker_10 {background-position: 0 -423px;}
	#placesList .item .marker_11 {background-position: 0 -470px;}
	#placesList .item .marker_12 {background-position: 0 -516px;}
	#placesList .item .marker_13 {background-position: 0 -562px;}
	#placesList .item .marker_14 {background-position: 0 -608px;}
	#placesList .item .marker_15 {background-position: 0 -654px;}
	#pagination {margin:10px auto;text-align: center;}
	#pagination a {display:inline-block;margin-right:10px;}
	#pagination .on {font-weight: bold; cursor: default;color:#777;}
</style>
</head>
<body>
	<%
		Marker marker = (Marker)request.getAttribute("marker");
	%>
	<%@ include file="../menu/menu.jsp" %>	
	<div class="map_wrap">
	    <div id="map" style="width:100%;height:100%;position:relative;overflow:hidden;"></div>
	
	    <div id="menu_wrap" class="bg_white">
	        <div class="option">
	            <div>
	                <form onsubmit="searchPlaces(); return false;">
	                    키워드 : <input type="text" id="keyword" size="15"> 
	                    <button type="submit">검색하기</button> 
	                </form>
	            </div>
	        </div>
	        <hr>
	        <ul id="placesList"></ul>
	        <div id="pagination"></div>
	    </div>
	</div>
	<div>
		<form onsubmit="return false;">
			<p>
				<label>마커ID</label>
				<input id="markerId" value="<%=marker.getmarkerId() %>" readOnly/>
			</p>
			<p>
				<label>좌표 X</label>
				<input id="pointX" value="<%=marker.getPointX() %>"/>
			<p>
				<label>좌표 Y</label>
				<input id="pointY" value="<%=marker.getPointY() %>"/>
			<p>
				<label>카테고리</label>
				<input id="category" value="<%=marker.getCategory() %>"/>
			<p>
				<label>장소명</label>
				<input id="pointName" value="<%=marker.getPointName() %>"/>
			<p>
				<label>전화번호</label>
				<input id="phone" value="<%=marker.getPhone() %>"/>
			<p>
				<label>주소</label>
				<input id="address" value="<%=marker.getAddress() %>"/>
			<p>
				<label>정보보기</label>
				<a href="#" id="urlData" target="_blank">정보보기</a>
			<p>
				<label>장소설명</label>
				<input id="url" value="<%=marker.getDescription() %>"/>
			<p>
			
			<button id="sendbtn">전송</button>
		</form>
	</div>
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=&libraries=services"></script>
	<script src="http://code.jquery.com/jquery-latest.min.js"></script>
	<script>
	
	// input 태그 
	var id = document.querySelector("#markerId");
	var px = document.querySelector("#pointX");
	var py = document.querySelector("#pointY");
	var cate = document.querySelector("#category");
	var pn = document.querySelector("#pointName");
	var ph = document.querySelector("#phone");
	var addr = document.querySelector("#address");
	var urldata = document.querySelector("#urlData");
	var desc = document.querySelector("#description");
	var send = document.querySelector("#sendbtn");
	var insertKeyword = document.querySelector("#keyword");

	var saveKeyword;
	// 마커를 담을 배열입니다
	var markers = [];
	//dto 매핑 객체
	var dtoObj ={
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
	
	var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
	    mapOption = {
	        center: new kakao.maps.LatLng(35.2538433, 128.6402609), // 지도의 중심좌표
	        level: 3 // 지도의 확대 레벨
	    };  

	// 지도를 생성합니다    
	var map = new kakao.maps.Map(mapContainer, mapOption); 

	// 장소 검색 객체를 생성합니다
	var ps = new kakao.maps.services.Places();  

	// 검색 결과 목록이나 마커를 클릭했을 때 장소명을 표출할 인포윈도우를 생성합니다
	var infowindow = new kakao.maps.InfoWindow({zIndex:1});

	
	//이벤트 할당
//	var send = document.querySelector("#sendbtn");
	send.addEventListener('click', updateData);
	
	//setInsertKey();
	// 키워드로 장소를 검색합니다
	searchPlaces();

	// 키워드 검색을 요청하는 함수입니다
	function searchPlaces() {
		
	    var keyword = insertKeyword.value;
	    
	    if (!keyword.replace(/^\s+|\s+$/g, '')) {
	    //    alert('키워드를 입력해주세요!');
	        return false;
	    }
	    
	    dtoObj.inputdata = keyword;
	    // 장소검색 객체를 통해 키워드로 장소검색을 요청합니다
	    ps.keywordSearch( keyword, placesSearchCB); 
	}

	// 장소검색이 완료됐을 때 호출되는 콜백함수 입니다
	/*
			여기서 마커들의 배열을 받아온다.
	*/	
	function placesSearchCB(data, status, pagination) {
	    if (status === kakao.maps.services.Status.OK) {

	        // 정상적으로 검색이 완료됐으면
	        // 검색 목록과 마커를 표출합니다
	        displayPlaces(data);

	        // 페이지 번호를 표출합니다
	        displayPagination(pagination);

	    } else if (status === kakao.maps.services.Status.ZERO_RESULT) {

	        alert('검색 결과가 존재하지 않습니다.');
	        return;

	    } else if (status === kakao.maps.services.Status.ERROR) {

	        alert('검색 결과 중 오류가 발생했습니다.');
	        return;

	    }
	}

	// 검색 결과 목록과 마커를 표출하는 함수입니다
	function displayPlaces(places) {

	    var listEl = document.getElementById('placesList'), 
	    menuEl = document.getElementById('menu_wrap'),
	    fragment = document.createDocumentFragment(), 
	    bounds = new kakao.maps.LatLngBounds(), 
	    listStr = '';
	    
	    // 검색 결과 목록에 추가된 항목들을 제거합니다
	    removeAllChildNods(listEl);

	    // 지도에 표시되고 있는 마커를 제거합니다
	    removeMarker();
	    
	    for ( var i=0; i<places.length; i++ ) {
	    	
	        // 마커를 생성하고 지도에 표시합니다
	        var placePosition = new kakao.maps.LatLng(places[i].y, places[i].x);
//	            marker = addMarker(placePosition, i),
			//마커 생성 --- (원본)함수구현
			var imageSrc = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_number_blue.png', // 마커 이미지 url, 스프라이트 이미지를 씁니다
		        imageSize = new kakao.maps.Size(36, 37),  // 마커 이미지의 크기
		        imgOptions =  {
		            spriteSize : new kakao.maps.Size(36, 691), // 스프라이트 이미지의 크기
		            spriteOrigin : new kakao.maps.Point(0, (i*46)+10), // 스프라이트 이미지 중 사용할 영역의 좌상단 좌표
		            offset: new kakao.maps.Point(13, 37) // 마커 좌표에 일치시킬 이미지 내에서의 좌표
		        },
		        markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imgOptions),
		            marker = new kakao.maps.Marker({
		            position: placePosition, // 마커의 위치
		            image: markerImage 
		        });
	
			    marker.setMap(map); // 지도 위에 마커를 표출합니다
			    markers.push(marker);  // 배열에 생성된 마커를 추가합니다

	            itemEl = getListItem(i, places[i]); // 검색 결과 항목 Element를 생성합니다
     			
	            //********************  함수 삽입 ********************
	            // 마커 클릭 시, 위치 정보가 input태그에 바로 삽입될 수 있게하는 함수
	            setInputValue(marker, places[i]);
				
	            setEventList(itemEl, places[i]);

	            
	        // 검색된 장소 위치를 기준으로 지도 범위를 재설정하기위해
	        // LatLngBounds 객체에 좌표를 추가합니다
	        bounds.extend(placePosition);

	        // 마커와 검색결과 항목에 mouseover 했을때
	        // 해당 장소에 인포윈도우에 장소명을 표시합니다
	        // mouseout 했을 때는 인포윈도우를 닫습니다
	        (function(marker, title) {
	            kakao.maps.event.addListener(marker, 'mouseover', function() {
	                displayInfowindow(marker, title);
	            });

	            kakao.maps.event.addListener(marker, 'mouseout', function() {
	                infowindow.close();
	            });

	            itemEl.onmouseover =  function () {
	                displayInfowindow(marker, title);
	            };

	            itemEl.onmouseout =  function () {
	                infowindow.close();
	            };
	        })(marker, places[i].place_name);
	        
	        
	        fragment.appendChild(itemEl);
	    }
		
	    // 검색결과 항목들을 검색결과 목록 Element에 추가합니다
	    listEl.appendChild(fragment);
	    menuEl.scrollTop = 0;

	    // 검색된 장소 위치를 기준으로 지도 범위를 재설정합니다
	    map.setBounds(bounds);
	}

	// 검색결과 항목을 Element로 반환하는 함수입니다
	function getListItem(index, places) {

	    var el = document.createElement('li'),
	    itemStr = '<span class="markerbg marker_' + (index+1) + '"></span>' +
	                '<div class="info">' +
	                '   <h5>' + places.place_name + '</h5>';

	    if (places.road_address_name) {
	        itemStr += '    <span>' + places.road_address_name + '</span>' +
	                    '   <span class="jibun gray">' +  places.address_name  + '</span>';
	    } else {
	        itemStr += '    <span>' +  places.address_name  + '</span>'; 
	    }
	                 
	      itemStr += '  <span class="tel">' + places.phone  + '</span>' +
	                '</div>';           

	    el.innerHTML = itemStr;
	    el.className = 'item';

	    return el;
	}

	// 마커를 생성하고 지도 위에 마커를 표시하는 함수입니다
	// 원래 함수로 사용하고 있었으나 현재는 밖으로 꺼내 사용하지 않고 있음
/*	
	function addMarker(position, idx, title) {
	    var imageSrc = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_number_blue.png', // 마커 이미지 url, 스프라이트 이미지를 씁니다
	        imageSize = new kakao.maps.Size(36, 37),  // 마커 이미지의 크기
	        imgOptions =  {
	            spriteSize : new kakao.maps.Size(36, 691), // 스프라이트 이미지의 크기
	            spriteOrigin : new kakao.maps.Point(0, (idx*46)+10), // 스프라이트 이미지 중 사용할 영역의 좌상단 좌표
	            offset: new kakao.maps.Point(13, 37) // 마커 좌표에 일치시킬 이미지 내에서의 좌표
	        },
	        markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imgOptions),
	            marker = new kakao.maps.Marker({
	            position: position, // 마커의 위치
	            image: markerImage 
	        });

	    marker.setMap(map); // 지도 위에 마커를 표출합니다
	    markers.push(marker);  // 배열에 생성된 마커를 추가합니다

	    return marker;
	}
*/
	// 지도 위에 표시되고 있는 마커를 모두 제거합니다
	function removeMarker() {
	    for ( var i = 0; i < markers.length; i++ ) {
	        markers[i].setMap(null);
	    }   
	    markers = [];
	}

	// 검색결과 목록 하단에 페이지번호를 표시는 함수입니다
	function displayPagination(pagination) {
	    var paginationEl = document.getElementById('pagination'),
	        fragment = document.createDocumentFragment(),
	        i; 

	    // 기존에 추가된 페이지번호를 삭제합니다
	    while (paginationEl.hasChildNodes()) {
	        paginationEl.removeChild (paginationEl.lastChild);
	    }

	    for (i=1; i<=pagination.last; i++) {
	        var el = document.createElement('a');
	        el.href = "#";
	        el.innerHTML = i;

	        if (i===pagination.current) {
	            el.className = 'on';
	        } else {
	            el.onclick = (function(i) {
	                return function() {
	                    pagination.gotoPage(i);
	                }
	            })(i);
	        }

	        fragment.appendChild(el);
	    }
	    paginationEl.appendChild(fragment);
	}

	// 검색결과 목록 또는 마커를 클릭했을 때 호출되는 함수입니다
	// 인포윈도우에 장소명을 표시합니다
	function displayInfowindow(marker, title) {
	    var content = '<div style="padding:5px;z-index:1;">' + title + '</div>';

	    infowindow.setContent(content);
	    infowindow.open(map, marker);
	}

	 // 검색결과 목록의 자식 Element를 제거하는 함수입니다
	function removeAllChildNods(el) {   
	    while (el.hasChildNodes()) {
	        el.removeChild (el.lastChild);
	    }
	}

	function setEventList(list, data){
		list.onclick = function(){
	        pn.value = data.place_name;
	    	px.value = data.x;
	    	py.value = data.y;
	    	addr.value = data.address_name;
	    	ph.value = data.phone;
	    	cate.value = data.category_name;
	    	urldata.href = data.place_url;
	    	setDTO(data);
	     };
	}
	 
	function setInputValue(marker, data){
		/*
		Document data 
			이름					타입			설명
			id					String		장소 ID
			place_name			String		장소명, 업체명
			category_name		String		카테고리 이름
			category_group_code	String		중요 카테고리만 그룹핑한 카테고리 그룹 코드
			category_group_name	String		중요 카테고리만 그룹핑한 카테고리 그룹명
			phone				String		전화번호
			address_name		String		전체 지번 주소
			road_address_name	String		전체 도로명 주소
			x					String		X 좌표값, 경위도인 경우 longitude (경도)
			y					String		Y 좌표값, 경위도인 경우 latitude(위도)
			place_url			String		장소 상세페이지 URL
			distance			String		중심좌표까지의 거리 (단, x,y 파라미터를 준 경우에만 존재)
			단위 meter
		*/	
		kakao.maps.event.addListener(marker,'click', function(){
			//id.value = data.id;
			pn.value = data.place_name;
			px.value = data.x;
			py.value = data.y;
			addr.value = data.address_name;
			ph.value = data.phone;
			cate.value = data.category_name;
			urldata.href = data.place_url;
			desc.value = data.place_url;
			setDTO(data);
		});
	} 
	function setDTO(data){
		dtoObj.markerId = data.markerId,
		dtoObj.pointX = data.x;
		dtoObj.pointY = data.y;
		dtoObj.category = data.category_name;
		dtoObj.pointName = data.place_name;
		dtoObj.phone = data.phone;
		dtoObj.address = data.address_name;
		dtoObj.description = data.place_url;
	}	
	
	function setDTObefore(){
		console.log(id.value);
		dtoObj.markerId = id.value;
		dtoObj.pointX = px.value;
		dtoObj.pointY = py.value;
		dtoObj.category = cate.value;
		dtoObj.pointName = pn.value;
		dtoObj.phone = ph.value;
		dtoObj.address = addr.value;
		dtoObj.description = urldata.value;
	}	
	
	function updateData(event){
		 event.preventDefault();
		 setDTObefore();
		$.ajax({
			url : "/FoodTrip/marker/editexecute",
			type : "post",
			data : JSON.stringify(dtoObj),
			contentType : "application/json",
			success : function(response){
				alert("마커 수정완료");
				console.log(response);
				location.href="/FoodTrip/marker/readalljson"
				//insertKeyword.value = response.inputdata;
				//$("#keyword").val(response.inputdata);
			},
			error : function(){
				alert("마커 입력 에러")
			}
		});
	}
	
	function setInsertKey(){
		insertKeyword.value = saveKeyword;
	}
	</script>
	
</body>
</html>