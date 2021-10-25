<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script>
	alert('${requestScope.message}'); // 메세지 출력해주기
	location.href = "${requestScope.loc}";
	location.reload(true);
</script>

