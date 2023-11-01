<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<jsp:include page="../layout/header.jsp"></jsp:include>
<c:set value="${bdto.bvo }" var="bvo"></c:set>
<table class="table">
	<tr>
		<th>BNO</th>
		<td>${bvo.bno }</td>
	</tr>
	<tr>
		<th>TITLE</th>
		<td>${bvo.title }</td>
	</tr>
	<tr>
		<th>WRITER</th>
		<td>${bvo.writer }</td>
	</tr>
	<tr>
		<th>CONTENT</th>
		<td>${bvo.content }</td>
	</tr>
	
	<c:set value="${bdto.flist }" var="flist"></c:set>
	<c:if test="${flist.size() > 0 }">
	<tr>
		<th>FILE</th>
		<c:forEach items="${flist }" var="fvo">
				<td>
					<c:choose>
						<c:when test="${fvo.file_type > 0 }">
							<div>
								<!-- /upload/year/month/day/uuid_fileName -->
								<img alt="그림없음" src="/upload/${fn:replace(fvo.save_dir,'\\','/')}/${fvo.uuid}_th_${fvo.file_name}">
							</div>
						</c:when>
						<c:otherwise>
							<div>
								<!-- file 아이콘 같은 모양 값으로 넣을 수 있음 -->
								
							</div>
						</c:otherwise>
					</c:choose>
					<div>
						<div>${fvo.file_name }</div>
						${fvo.reg_date }
					</div>
					<span>${fvo.file_size }Byte</span>
				</td>
			</c:forEach>
	</tr>
	</c:if>
	
	<tr>
		<th>REG_DATE</th>
		<td>${bvo.registerDate }</td>
	</tr>
	<tr>
		<th>READ</th>
		<td>${bvo.read_count }</td>
	</tr>
</table>

<!-- file 표현 영역 -->
<%-- <c:set value="${bdto.flist }" var="flist"></c:set>
<div>
	<ul>
		<!-- 파일 개수만큼 li를 추가하여 파일을 표시, 타입이 1일 경우만 표시(그림파일만) -->
		<!-- li
			div => img 그림표시 
			div => div 파일이름, 작성일자 span 크기 설정 -->
			<!-- 하나의 파일만 따와서 fvo로 저장 -->
			<c:forEach items="${flist }" var="fvo">
				<li>
					<c:choose>
						<c:when test="${fvo.file_type > 0 }">
							<div>
								<!-- /upload/year/month/day/uuid_fileName -->
								<img alt="그림없음" src="/upload/${fn:replace(fvo.save_dir,'\\','/')}/
								${fvo.uuid}_th_${fvo.file_name}">
							</div>
						</c:when>
						<c:otherwise>
							<div>
								<!-- file 아이콘 같은 모양 값으로 넣을 수 있음 -->
								
							</div>
						</c:otherwise>
					</c:choose>
					<div>
						<div>${fvo.file_name }</div>
						${fvo.reg_date }
					</div>
					<span>${fvo.file_size }Byte</span>
				</li>
			</c:forEach>
	</ul>
</div> --%>

<c:if test="${ses.id eq bvo.writer }">
<a href="/board/modify?bno=${bvo.bno }">
	<button type="button">수정</button>
</a>
<a href="/board/remove?bno=${bvo.bno }">
	<button type="button">삭제</button>
</a>
</c:if>
<a href="/board/list">
	<button type="button">리스트</button>
</a>
<br><br>

<!-- 댓글 라인 -->
<div>
	<!-- 댓글 작성 라인 -->
	<div>
		<span id="cmtWriter">${ses.id }</span>
		<input type="text" id="cmtText" placeholder="Add Comment...">
		<button type="button" id="cmtPostBtn">댓글 등록</button>
	</div>
	<!-- 댓글 표시 라인 -->
	<div>
		<ul id="cmtListArea">
			<li>
				<div>
					<div>Writer</div>
					Content				
				</div>
				<span>reg_date</span>
			</li>
		</ul>
	</div>
</div>

<script type="text/javascript">
const bnoVal = `<c:out value="${bvo.bno}"/>`;
console.log(bnoVal);
const id = `<c:out value="${ses.id}"/>`;
</script>
<script type="text/javascript" src="/resources/js/boardComment.js"></script>
<script type="text/javascript">
getCommentList(bnoVal);
</script>

<jsp:include page="../layout/footer.jsp"></jsp:include>
</body>
</html>