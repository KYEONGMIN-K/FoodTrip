<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page import="com.spring.domain.*" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<%
		Marker marker = (Marker)request.getAttribute("marker");
		
	%>

	<form:form modelAttribute="UpdateMarker" encType="multipart/form-data">
		<p>
			<label>마커명</label>
			<form:input path="markerId" value="<%=marker.getmarkerId() %>"/>
		</p>
		<p>
			<label>좌표 X</label>
			<form:input path="pointX" value="<%=marker.getPointX() %>"/>
		<p>
			<label>좌표 Y</label>
			<form:input path="pointY" value="<%=marker.getPointY() %>"/>
		<p>
			<label>카테고리</label>
			<form:input path="category" value="<%=marker.getCategory() %>"/>
		<p>
			<label>장소명</label>
			<form:input path="pointName" value="<%=marker.getPointName() %>"/>
		<p>
			<label>전화번호</label>
			<form:input path="phone" value="<%=marker.getPhone() %>"/>
		<p>
			<label>주소</label>
			<form:input path="address" value="<%=marker.getAddress() %>"/>
		<p>
			<label>장소설명</label>
			<textarea name="description"><%=marker.getDescription() %></textarea>
		<p>
			<label>장소이미지</label>
			<form:input path="image" type="file"/>
		
		<input type="submit" value="등록"/>
	</form:form>
</body>
</html>