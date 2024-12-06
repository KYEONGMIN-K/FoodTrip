<%@ page isELIgnored="false" language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.spring.domain.*" %>
<%@ page import="java.util.*" %>
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
	<h2>마커 리스트</h2>
	<ul class="markerlist">
		
	</ul>

<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script>
	var category= document.querySelector("#category");
	var pName= document.querySelector("#pointName");
	var phone= document.querySelector("#phone");
	var addr= document.querySelector("#address");
	var desc= document.querySelector("#description");

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
				var list = document.createElement('li');
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
</script>
		
</body>
</html>