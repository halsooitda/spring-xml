<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인 페이지</title>
</head>
<body>
<jsp:include page="../layout/header.jsp"></jsp:include>
<form action="/member/login" method="post"> <br>
	ID : <input type="text" name="id" placeholder="아이디 입력"> <br>
	Password : <input type="password" name="pw" placeholder="비밀번호 입력">
	<button type="submit">로그인</button>
</form>

<jsp:include page="../layout/footer.jsp"></jsp:include>
</body>
</html>