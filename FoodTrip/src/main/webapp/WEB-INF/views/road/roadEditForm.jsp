<%@ page isELIgnored="false" language="java" contentType="text/html; charset=UTF-8"
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
	
	<script src="http://code.jquery.com/jquery-latest.min.js"></script>
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey="></script>
	<script>
	var rid = "${id}";
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
	getOneRoad();
			
	function getOneRoad(){
		$.ajax({
			url : "readOneRoad",
			type : "post",
			data : JSON.stringify(rid),
			contentType : "application/json",
			success : function(response){
				//지도에 뿌리기
			}
			
		});
	}
	</script>
</body>
</html>