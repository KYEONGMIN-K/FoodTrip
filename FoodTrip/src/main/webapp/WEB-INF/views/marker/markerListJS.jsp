<%@ page isELIgnored="false" language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.spring.domain.*" %>
<%@ page import="java.util.*" %>
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
	.listBox{
		width:250px;
		height:800px;
		position: relative;
		overflow-y:auto;
		background-color: #EFF2FB;
	}
	.listBox > *, ul{
		padding:0;
		margin:0 auto;
	}
	.listbody{
		position:relative;
	}
	.tablist{
		list-style:none;
		display:flex;
		justify-content:space-between;
	}
	.tablist button{
		width:100%;
	}
	.tablist div{
		width:30%;
		margin:0 10px 0 10px;
		border:1px solid rgba(0,0,0,0.3);
	}
	.markerList{
		display:flex;
		flex-direction:column;
		list-style : none;
	}
	.listCh{
		width:80%;
		margin-top: 10px;
		margin-left: 20px;
		margin-bottom: 10px;
	}
	.listblock{
		position:absolute;
		top:0;
		left:0;
	}
	div ul{
		list-style:none;
	}
	.btnList{
		display:flex;
		justify-content:space-between;
	}
	.btnList a{
		color:rgb(2,7,21);
		text-align:center;
		text-decoration:none;
		background-color:#E6E6E6;
		padding:3px;
		border-radius:10px;
	}
</style>
</head>
<body>

	<%@ include file="../menu/menu.jsp" %>
	<!-- 
		<ul>
			<li>로 구현할 때 
			전체 리스트로 쭉 뿌리고 카테고리에 따라 분류	
	 -->
	<h2>마커 리스트</h2>
<div class="contain">
<!-- 	
	<div class="listBox">
		<ul class="tablist">
			<div class="tourtab" id="tab">관광지</div>
			<div class="resttab" id="tab">식당</div>
			<div class="staytab" id="tab">숙소</div>
		</ul>
		<ul class="markerList">
		
		</ul>
	</div>
	 -->
	<div class="listBox">
		<ul class="tablist">
			<button class="tourtab" id="tab">관광지</button>
			<button class="resttab" id="tab">식당</button>
			<button class="staytab" id="tab">숙소</button>
		</ul>	
		<div class="listbody">
			<div class="listblock">
				<ul class="tourlist">
					
				</ul>
			</div>
			<br><br>
			<div class="listblock">		
				<ul class="restlist">
					
				</ul>
			</div>		
			<br><br>
			<div class="listblock">
				<ul class="staylist">
					
				</ul>
			</div>
		</div>
	</div>
	<div id=map style="width:100%;height:800px;">
		<!-- 지도 공간  -->
		
	</div> 
</div>		
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey="></script>
<script>
	var box = document.querySelector(".listblock");
	var ullist = document.querySelector(".markerList");
	var tourParents = document.querySelector(".tourlist");
	var stayParents = document.querySelector(".staylist");
	var restParents = document.querySelector(".restlist");
	
	
	var tourTab = document.querySelector(".tourtab");
	var restTab = document.querySelector(".resttab");
	var stayTab = document.querySelector(".staytab");
	
	//var tablist = document.querySelectorAll("#tab");
	
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

	tourTab.addEventListener("click", tourFilter);
	restTab.addEventListener("click", restFilter);
	stayTab.addEventListener("click", stayFilter);
	
	
	var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
    mapOption = { 
        center: new kakao.maps.LatLng(35.2538433, 128.6402609), // 지도의 중심좌표
        level: 9 // 지도의 확대 레벨
    };

	// 지도를 표시할 div와  지도 옵션으로  지도를 생성합니다
	var map = new kakao.maps.Map(mapContainer, mapOption); 
	
	
	getAllMarker();	
	
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
		        	tourFilter(dtoList);
		        	//addElements(dtoList);
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
	/*	
	function addElements(data){
		for(var j=0; j<tablist.length; j++){
			tablist[j].addEventListener("click", function(e){
				var me = e.target.className;	//이벤트가 일어나는 클래스명 찾기
				console.log(me);
				if(me == "tourtab"){
					ullist.innerHTML="";
					var list = document.createElement('li');
					list.setAttribute("class", "listCh");
					listMake(ullist, list);
				}else if(me == "resttab"){
					ullist.innerHTML="";
					var list = document.createElement('li');
					list.setAttribute("class", "listCh");
					listMake(ullist, list);
				}else if(me == "staytab"){
					ullist.innerHTML="";
					var list = document.createElement('li');
					list.setAttribute("class", "listCh");
					listMake(ullist, list);
				}				
				
			});
		}
	}
	
	function listMake(ullist, list){
		for(var i=0; i<dtoList.length; i++){
			(function(index){
				var data = dtoList[index];
								
				list.innerHTML='<div class="category">'+data.category+"</div><a href='"+ data.description+"' class='pointName'>"
				+ data.pointName + "</a><br><a href='/FoodTrip/marker/markerUpdate?id="+data.markerId+"'>수정</a><br><a href='/FoodTrip/marker/delete?id="+data.markerId+"'>삭제</a>";
				ullist.appendChild(list);
			})(i);
		}
		
		
	}
	
	
	function addElements(data){
		console.log(tablist);
		for(var i=0; i<data.length; i++){
			//console.log(data[i].markerId);
			(function(index){
				
				//console.log(data[i].category);
				//console.log("Category" +data[i].category);
				//console.log(index);
				
				//여기서 숙소, 음식점, 관광지를 분류하여 출력
				var cate = dataOne.markerId.substring(0,2);
				//console.log(list);
				//굳이 함수로 안하고 on/off로 표현
				for(var j=0; j<tablist.length; j++){
					tablist[j].addEventListener("click", function(e){
						ullist.innerHTML="";
						e.preventDefault();
						var me = e.target.className;	//이벤트가 일어나는 클래스명 찾기
						console.log(me);
						if(cate == "TU" && me == "tourtab"){
							var list = document.createElement('li');
							list.setAttribute("class", "listCh");
							listMake(list, dataOne);
							console.log("tour");
							ullist.appendChild(list);
						}else if(cate == "RS" && me == "resttab"){
							var list = document.createElement('li');
							list.setAttribute("class", "listCh");
							listMake(list, dataOne);
							console.log("rest");
							ullist.appendChild(list);
						}else if(cate == "HT" && me == "staytab"){
							var list = document.createElement('li');
							list.setAttribute("class", "listCh");
							listMake(list, dataOne);
							console.log("stay");
							ullist.appendChild(list);
						}						
					});
				}
				/*
				if(cate == "TU"){
					tourParents.appendChild(list);
				}else if(cate == "RS"){
					restParents.appendChild(list);
				}else if(cate == "HT"){
					stayParents.appendChild(list);
				}
			})(i);
		}
	}*/

	function listMake(list, data){
		console.log(data.description);
		list.innerHTML="<a href='"+data.description+"'class=pointName target='_blank'>"
		+ data.pointName + "</a><div class='category'>"+data.category
		+"</div><br><div class='btnList'><a href='/FoodTrip/marker/markerUpdate?id="
		+data.markerId+"'>수정</a><a href='/FoodTrip/marker/delete?id="
		+data.markerId+"'>삭제</a></div><hr>";
	}
/*
 *<a href='/FoodTrip/marker/markerUpdate?id="+data.markerId
		+"'>수정</a><a href='/FoodTrip/marker/delete?id="+data.markerId+"'>삭제</a><hr>" 

 */
	

	function addElements(data){
		console.log(data[0].category);
		for(var i=0; i<data.length; i++){
			console.log(data[i].markerId);
			(function(index){
				var dataOne = data[index];
				var list = document.createElement('li');
				list.setAttribute("class", "listCh");
				//console.log(data[i].category);
				//console.log("Category" +data[i].category);
				//console.log(index);
				
				//여기서 숙소, 음식점, 관광지를 분류하여 출력
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
/*
	function listMake(list, data){
		list.innerHTML='<div class="category">'+data.category+"</div><div class='pointName'>"
		+ data.pointName + "</div><div class='phone'>"
		+ data.phone + "</div><div class='address'>"
		+ data.address + "</div><a href='"+data.description +"' class='description' target='_blank'>"
		+ "사이트이동" +"</a><br><a href='/FoodTrip/marker/markerUpdate?id="+data.markerId+"'>수정</a><br><a href='/FoodTrip/marker/delete?id="+data.markerId+"'>삭제</a>";
	}
*/
	//필터로 탭을 누르면 해당하는 것만 출력
	function tourFilter(){
		addElements(dtoList);
		restParents.innerHTML="";
		stayParents.innerHTML="";
	}
	function restFilter(){
		addElements(dtoList);
		tourParents.innerHTML="";
		stayParents.innerHTML="";
	}
	function stayFilter(){
		addElements(dtoList);
		restParents.innerHTML="";
		tourParents.innerHTML="";
	}
	
	function copyMk(markerlist){
		console.log(markerlist.length);
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
</script>
		
</body>
</html>