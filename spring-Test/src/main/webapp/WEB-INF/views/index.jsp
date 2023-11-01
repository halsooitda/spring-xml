<%@ page language="java" contentType="text/html; charset=UTF-8" 
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<jsp:include page="./layout/header.jsp"></jsp:include>

<h1>
	Hello world!  
</h1>

<P> My Spring Project </P>

<script type="text/javascript">
	const msg_login = `<c:out value="${msg_login}" />`;
	if(msg_login == 1){
		alert("로그인 실패");
	}
	const msg_logout = `<c:out value="${msg_logout}" />`;
	if(msg_logout == 1){
		alert("로그아웃 되었습니다.");
	}
	const msg_modify = `<c:out value="${msg_modify}" />`;
	if(msg_modify == 2){
		alert("수정완료되었습니다. 다시 로그인해주세요.");
	}
</script>

<jsp:include page="./layout/footer.jsp"></jsp:include>
