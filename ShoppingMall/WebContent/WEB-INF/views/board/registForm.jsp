<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<h3>글 등록하기</h3>
<form action="regist.go" method="post">
	<input type="text" name="title" placeholder="제목" required><br>
	<input type="text" name="writer" placeholder="작성자" required><br>
	<textarea rows="4" cols="20" name="content" placeholder="내용"></textarea><br>
	<input type="submit" value="등록">
</form>
</body>
</html>