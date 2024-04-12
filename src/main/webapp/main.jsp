<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>채팅서비스 메인페이지</title>
<script>
	function openChatWin() {
		const chatId = document.querySelector("#chatId");
		if(!chatId.value) {
			alert("대화명을 입력하세요");
			chatId.focus();
			return;
		}

		window.open("ChatWin.jsp?chatId=" + chatId.value , "", "top=200, left=200, width = 510, height = 520, menubar = no, toolbar = no, location = no, status = no, scrollbars = no");
	}
</script>
</head>
<body>
	<div>
		<div>
			<h2>웹소켓 채팅 - 대화명 입력</h2>
			<span>대화명 : </span>
			<input type="text" name="chatId" id="chatId" value="" maxlength="20">
			<button id="btnAcess" onclick="openChatWin()">채팅참여</button>
		</div>
	</div>
</body>
</html>