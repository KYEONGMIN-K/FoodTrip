<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%> 
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<form:form modelAttribute="NewMarker" encType="multipart/form-data">
		<p>
			<label>마커명</label>
			<form:input path="markerId"/>
		</p>
		<p>
			<label>좌표 X</label>
		<form:input path="pointX"/>
		<p>
			<label>좌표 Y</label>
		<form:input path="pointY"/>
		<p>
			<label>카테고리</label>
		<form:input path="category"/>
		<p>
			<label>장소명</label>
		<form:input path="pointName"/>
		<p>
			<label>전화번호</label>
		<form:input path="phone"/>
		<p>
			<label>주소</label>
		<form:input path="address"/>
		<p>
			<label>장소설명</label>
			<form:textarea path="description" col="50" row="20"/>
		<p>
			<label>장소이미지</label>
		<form:input path="image" type="file"/>
		
		<input type="submit" value="등록"/>
	</form:form>
</body>
</html>