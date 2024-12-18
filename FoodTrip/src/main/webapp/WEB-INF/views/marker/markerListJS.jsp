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
      overflow:hidden;
      background-color: #EFF2FB;
      border:1px solid black;
   }
   .listBox > *, ul{
      padding:0;
      margin:0 auto;
   }
   .listbody{
      height:100%;
      position:relative;
      overflow-y:auto;
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
   .pointName{
      font-weight:700;
      text-decoration:none;
      color:black;
   }
   .category{
      font-size:11px;
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
      <div class="tablist">
         <button class="tourtab" id="TU">관광지</button>
         <button class="resttab" id="RS">식당</button>
         <button class="staytab" id="HT">숙소</button>
      </div>   
      <div class="listbody">
         <div class="listblock">
            <ul class="mklist">
            <!-- <ul class="tourlist">-->
               
            </ul>
         </div>
         <!-- 
         <br><br>
         <div class="listblock">      
            <ul class="restlist">
               
            </ul>
         </div>      
         <br><br>
         <div class="listblock">
            <ul class="staylist">
               
            </ul>
         </div> -->
      </div>
   </div>
   <div id=map style="width:100%;height:800px;">
      <!-- 지도 공간  -->
      
   </div> 
</div>      
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=a8fb3e9990ea2c741f7c154e957f99be"></script>
<script>
   //맵 변수
   var mapContainer;
   var map;
   //리스트 li를 추가할 부모요소
   var mkParents = document.querySelector(".mklist");
   
   //리스트 탭
   var tourTab = document.querySelector(".tourtab");
   var restTab = document.querySelector(".resttab");
   var stayTab = document.querySelector(".staytab");
   
   //이벤트 타겟
   //var whoTarget;
   
   //원 반경을 표시하는 변수
   let activeCircle = null;
   
   //마커가 맵에 표시될 때 저장되는 마커 배열
   var baseMarkers = [];
   
   //반경 내 마커만 저장하는 배열
   var circleMarkers = [];
   var isIn;
   
   //DB에서 가져온 마커 DTO Ary
   var dtoList=[];
   
   //마커 DTO
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

   //탭 버튼에 이벤트 할당
   tourTab.addEventListener("click",() => listFilter(event, dtoList));
   restTab.addEventListener("click",() => listFilter(event, dtoList));
   stayTab.addEventListener("click",() => listFilter(event, dtoList));
   

   //가장 먼저 실행되는 ajax
   getAllMarker();   
   makeMap();
   
   
   //데이터 가져오기
   function getAllMarker(){
      $.ajax({
         url : "readMkAll",
         type : "get",
         success: function(response) {
              //console.log(response);  // 응답 구조를 확인
            JSON.stringify(response);
              // 응답이 배열인지 확인하고, 배열이 비어있지 않으면
              if (Array.isArray(response) && response.length > 0) {
                 mkParents.innerHTML = "";
                 copyMk(response);   //가져온 JSON을 합친다.
              } else {
                  console.log("응답이 비어있거나 배열이 아닙니다.");
              }
          },
          error: function(status) {
              console.log("상태:", status);
          }
      });
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

   
   //맵 만들기
   function makeMap(){
      mapContainer = document.getElementById('map'), // 지도를 표시할 div 
       mapOption = { 
           center: new kakao.maps.LatLng(35.2538433, 128.6402609), // 지도의 중심좌표
           level: 9 // 지도의 확대 레벨
       };

      map = new kakao.maps.Map(mapContainer, mapOption); 
   }
   
   
   //리스트 만들기
   function listMake(list, data){
      //console.log(data.description);
      list.innerHTML="<a href='"+data.description+"'class='pointName' target='_blank'>"
      + data.pointName + "</a><div class='category'>"+data.category
      +"</div><br>"
      //
      var div = document.createElement('div');
      div.setAttribute("class", "btnList");
      div.innerHTML = "<a href='/FoodTrip/marker/markerUpdate?id="+data.markerId+"'>수정</a>";
      
      var btn = document.createElement('button');
      var hr = document.createElement('hr');
      btn.addEventListener("click", () => addMarker(data));
      btn.innerHTML = "등록";
      div.appendChild(btn);
      
      list.appendChild(div);
      list.appendChild(hr);
      //list.innerHTML += `</div>`;
   }//삭제 버튼 : <a href='/FoodTrip/marker/delete?id="+data.markerId+"'>삭제</a></div><hr>
   
   //마커 찍기
   /*
      맵에 마커를 출력하며 마커에 이벤트를 할당하는 함수
      Param : cate(마커의 카테고리), data(마커 dto 리스트)
   */
   function addMarkerInCircle(cate, data){
      //console.log(circleMarkers);
      var placePosition = new kakao.maps.LatLng(data.pointY, data.pointX);
      var imageSrc = "/FoodTrip/resources/images/"+cate+".png" , // 마커 이미지 url, 스프라이트 이미지를 씁니다
        imageSize = new kakao.maps.Size(36, 37),  // 마커 이미지의 크기
        imgOptions =  {         
            offset: new kakao.maps.Point(13, 37) // 마커 좌표에 일치시킬 이미지 내에서의 좌표
        };
    
       markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imgOptions),
            marker = new kakao.maps.Marker({
            map : map,
            position: placePosition, // 마커의 위치
            image: markerImage                        
        });   
       
       return marker;
   }
   
   
   
   function addMarker(cate, data){
   //   console.log(data);
      var placePosition = new kakao.maps.LatLng(data.pointY, data.pointX);
      bounds = new kakao.maps.LatLngBounds();
      bounds.extend(placePosition);
   //   console.log("isIn");
   //   console.log(isIn);
      var imageSrc = "/FoodTrip/resources/images/"+cate+".png" , // 마커 이미지 url, 스프라이트 이미지를 씁니다
           imageSize = new kakao.maps.Size(36, 37),  // 마커 이미지의 크기
           imgOptions =  {         
               offset: new kakao.maps.Point(13, 37) // 마커 좌표에 일치시킬 이미지 내에서의 좌표
           };
       
       markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imgOptions),
            marker = new kakao.maps.Marker({
              map:map,
            position: placePosition, // 마커의 위치
            image: markerImage                        
        });

       marker.setMap(map);
       baseMarkers.push(marker);
      //console.log(data.pointX, data.pointY);
      for(var l=0; l<baseMarkers.length; l++){
         var oneMarker = baseMarkers[l];
         kakao.maps.event.addListener(oneMarker, 'click', function () {
             // 클릭된 마커를 중심으로 원을 그리도록 함수 호출
             getRangeRestTour(oneMarker, data);
             //filterMarkersByCircle(oneMarker, data);
             console.log("1. click ! ");
         });
      }
      //console.log(circleMarkers.length);
   }
   
   /*
      마커를 클릭했을 때 위도,경도로 계산된 반경 내 해당하는 마커만 출력
   */
   function getRangeRestTour(marker, data){
      //console.log(data.pointX, data.pointY);
      //console.log("rm circle before");
      console.log("3. range check");
      rmAllMarker(circleMarkers);
      var exist = false;
      var x = data.pointX;
      var y = data.pointY;
      var positionX;
      var positionY;   
   //   console.log("test point");
      //dtoList는 마커 전체 리스트
      for(var i=0; i<dtoList.length; i++){
         var cate = dtoList[i].markerId.substring(0,2);
         var viewdata = dtoList[i];
         positionX = viewdata.pointX;
         positionY = viewdata.pointY;
         if(cate=="RS"){
            //위도 경도 조건 
            var km = haversineDistance(x, y, positionX, positionY);
            if(km <= 0.72){
               console.log("km :  "+km);
               var cMarker = addMarkerInCircle(cate, viewdata);
               circleMarkers.push(cMarker);   
            }
            
           
            if(haversineDistance(positionY, positionX, y, x)<=1){
               console.log("보여주려는 마커 = x:y");
               console.log(positionX +" | " +positionY);
               console.log("기준 마커 = x:y");
               console.log(x +" | " +y);
               //console.log("IN");
               var cMarker = addMarkerInCircle(cate, viewdata);
               kakao.maps.event.addListener(cMarker, 'click', function () {
                   // 클릭된 마커를 중심으로 원을 그리도록 함수 호출
                   console.log(cMarker.getPosition());
               });
               circleMarkers.push(cMarker);                     
            }   
         }
      }
   }
   function addElements(data){
      var dataOne = data;
      var list = document.createElement('li');
      list.setAttribute("class", "listCh");

      //여기서 숙소, 음식점, 관광지를 분류하여 출력
      var cate = dataOne.markerId.substring(0,2);
      listMake(list, dataOne);
      mkParents.appendChild(list);
   }
   
   //필터로 탭을 누르면 해당하는 것만 출력
   function listFilter(event, dtoList){
      mkParents.innerHTML ="";
      //console.log("event");
      //console.log(event);
      var me = event.target.id;
      //console.log(me);
      rmAllMarker(baseMarkers);
      //rmCircleMarker();
      for(var i=0; i<dtoList.length; i++)
      {
         (function(index){
            //1. 어떤 것을 출력할지 필터부터.
            var dataOne = dtoList[index];
            var cate = dataOne.markerId.substring(0,2);
            if(cate == me){
            //2. 필터로 걸러진 것만 출력      
               //console.log(cate);
               addElements(dataOne);
               addMarker(cate, dataOne);
            }else if(cate == me){
               addElements(cate, dataOne);
               addMarker(dataOne);
            }else if(cate == me){
               addElements(dataOne);
               addMarker(cate, dataOne);
            }
         })(i);   
      }
      //inIn = 1;
   }

   //마커 삭제하기
   function rmAllMarker(markers){
      //console.log("markers.length");
      //console.log(markers.length);
      
      for(var k=0; k<markers.length; k++){
         //console.log("k");
         //console.log(k);
         //console.log("rm IN SETNULL")
         markers[k].setMap(null);   
      }
      //markers.length = 0;
      markers = [];
   }
   
   function filterMarkersByCircle(marker, data) {   //marker는 클릭한 마커
       const radius = 1000; // 반경 1km (미터 단위)
       const centerPosition = marker.getPosition();   //마커의 포지션
      console.log("2. circle make");
      console.log("마커의 포지션 : " + centerPosition) 
       //원이 존재하면 삭제
       if (activeCircle) {
           activeCircle.setMap(null);
       }
       
       // 원 객체 생성
       const circle = new kakao.maps.Circle({
           center: centerPosition, // 원의 중심좌표
           radius: radius, // 반경 (미터 단위)
           strokeWeight: 2,
           strokeColor: '#75B8FA',
           strokeOpacity: 1,
           strokeStyle: 'solid',
           fillColor: '#CFE7FF',
           fillOpacity: 0.5
       });
       
       //클릭한 마커로 화면을 이동하는데 쓰이는 변수
       var viewPosition = marker.getPosition();
       var bounds = new kakao.maps.LatLngBounds();
       
       bounds.extend(viewPosition);
       var padding = 0.01; // 여백 정도를 설정 (값을 조정해 멀리 보이도록 설정)

       // 마커 위치를 기준으로 상하좌우에 약간의 거리 추가
       bounds.extend(new kakao.maps.LatLng(viewPosition.getLat() + padding, viewPosition.getLng() + padding)); // 북동쪽
      bounds.extend(new kakao.maps.LatLng(viewPosition.getLat() - padding, viewPosition.getLng() - padding)); // 남서쪽

        map.panTo(viewPosition);
        map.setBounds(bounds);
        
       circle.setMap(map); // 원을 지도에 표시
       activeCircle = circle;

       //getRangeRestTour(marker, data);
       
       
       //console.log("setmap before");
       //console.log(circleMarkers.length);
          
       
       for(var i=0; i<circleMarkers.length; i++){
          if (distance <= radius) {
             console.log("true!");
          }
       }
       
       
       /*       
       for(var i=0; i<circleMarkers.length; i++){
          //const centerPosition = new kakao.maps.LatLng(marker.getPosition().getLat(), marker.getPosition().getLng());
          //console.log(centerPosition);

         const markerLat = marker.getPosition().getLat();
           const markerLng = marker.getPosition().getLng();
           const distance = getDistance(centerLat, centerLng, markerLat, markerLng);
         
         //const distance = centerPosition.getDistance();
          //var cMarker = circleMarkers[i];
          
          //const distance = haversineDistance(marker.getPosition().getLat(), marker.getPosition().getLng(), cMarker.getPosition().getLat(), cMarker.getPosition().getLng());
        if (distance <= radius) {
               // console.log("distance" + distance);
               // console.log("radius" + radius);
             // cMarker.setMap(map); // 원 안에 있으면 표시
          // }else{
             // console.log("setmap null");
             // cMarker.setMap(null); // 원 밖이면 숨김
           }
       }*/
   }

   function haversineDistance(lat1, lon1, lat2, lon2) {
      const R = 6371;
       const toRad = (x) => (x * Math.PI) / 180;

       const dLat = toRad(lat2 - lat1);
       const dLon = toRad(lon2 - lon1);
		
       const a = 
           Math.sin(dLat / 2) * Math.sin(dLat / 2) +
           Math.cos(toRad(lat1)) * Math.cos(toRad(lat2)) * 
           Math.sin(dLon / 2) * Math.sin(dLon / 2);
       const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
       /*
       const a = Math.sin(dLat / 2) ** 2 +
                 Math.cos(toRad(lat1)) * Math.cos(toRad(lat2)) *
                 Math.sin(dLon / 2) ** 2;

       const c = 2 * Math.asin(Math.sqrt(a));
       */
      // console.log("math : " + c);
       return R * c; // 거리 (킬로미터)
   }

</script>
      
</body>
</html>