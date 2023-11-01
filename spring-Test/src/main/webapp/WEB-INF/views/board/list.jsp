<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<jsp:include page="../layout/header.jsp"></jsp:include>

<!-- 검색 라인 -->
<div>
<!-- method 안 쓰면 자동 get -->
<form action="/board/list" method="get">
	<c:set value="${ph.pgvo.type }" var="typed"></c:set>
	<!-- type의 값을 typed라는 변수에 넣어줌 -->
	<!-- 1 -->
	<select name="type" class="choose">
		<option ${typed == null? 'selected' : '' }>Choose</option>
		<option value="t" ${typed eq 't'? 'selected' : '' }>title</option>
		<option value="w" ${typed eq 'w'? 'selected' : '' }>writer</option>
		<option value="c" ${typed eq 'c'? 'selected' : '' }>content</option>
		<option value="tw" ${typed eq 'tw'? 'selected' : '' }>title+writer</option>
		<option value="tc" ${typed eq 'tc'? 'selected' : '' }>title+content</option>
		<option value="wc" ${typed eq 'wc'? 'selected' : '' }>writer+content</option>
		<option value="twc" ${typed eq 'twc'? 'selected' : '' }>title+writer+content</option>
	</select>
	<!-- 2 -->
	<input type="text" name="keyword" value="${ph.pgvo.keyword }" placeholder="Search" class="searchBox">
	<!-- 검색 후 페이징을 하기 위해서 보내는 값 -->
	<input type="hidden" name="pageNo" value="1"> 
										<!-- 검색 후 현재 페이지넘버가 아니라 무조건 1페이지로 가도록 -->
	<input type="hidden" name="qty" value="${ph.pgvo.qty }">
	<!-- 3 -->
	<button type="submit" class="btn btn-secondary position-relative">
 		search
  	<span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
   		${ph.totalCount }
    <span class="visually-hidden">unread messages</span>
 	</span>
	</button>
	
	<%-- <button type="submit" class="btn btn-secondary sBtn">search</button>
	<span>${ph.totalCount }</span> --%>
</form>
</div>

<table class="table">
	<thead>
		<tr>
			<th>#</th>
			<th>제목</th>
			<th>작성자</th>
			<th>작성일</th>
			<th>조회수</th>
			<th>댓글수</th>
			<th>파일수</th>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${list }" var="bvo">
			<tr>
				<td>${bvo.bno }</td>
				<td> <a href="/board/detail?bno=${bvo.bno }">${bvo.title }</a> </td>
				<td>${bvo.writer }</td>
				<td>${bvo.registerDate }</td>
				<td>${bvo.read_count }</td>
				<td>${bvo.commentCount }</td>
				<td>${bvo.fileCount }</td>
			</tr>
		</c:forEach>
	</tbody>

</table>

<!-- 페이징 라인 -->
<nav aria-label="Page navigation example">
  <ul class="pagination">
	<!-- prev -->
  	<li class="page-item">
		<c:if test="${ph.prev }">
			<a href="/board/list?pageNo=${ph.startPage-1 }&qty=${ph.pgvo.qty}&type=${ph.pgvo.type}&keyword=${ph.pgvo.keyword}" class="page-link" aria-label="Previous">
				<span aria-hidden="true">&laquo;</span>
			</a>
		</c:if>
	</li>
	
	<c:forEach begin="${ph.startPage }" end="${ph.endPage }" var="i">
		<li class="page-item">
			<!-- 페이지 번호를 i라는 변수에 담아서 사용 -->
			<a href="/board/list?pageNo=${i }&qty=${ph.pgvo.qty}&type=${ph.pgvo.type}&keyword=${ph.pgvo.keyword}" class="page-link">${i }</a>
		</li>
	</c:forEach>

	<!-- next -->
	<li class="page-item">
		<c:if test="${ph.next }">
			<a href="/board/list?pageNo=${ph.endPage+1 }&qty=${ph.pgvo.qty}&type=${ph.pgvo.type}&keyword=${ph.pgvo.keyword}" class="page-link" aria-label="Next">
				<span aria-hidden="true">&raquo;</span>
			</a>
		</c:if>
	 </li>
  </ul>
</nav>

<script type="text/javascript">
const isOk = `<c:out value="${isOk }" />`;
console.log(isOk);
if(isOk == 1){
	alert('삭제 완료');
}
</script>

<jsp:include page="../layout/footer.jsp"></jsp:include>
</body>
</html>