<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>채팅창</title>
<script>
	const webSocket = new WebSocket("ws://localhost:8080/ws/ChatServer");
	let chatWin, chatId, chatMsg;
	window.onload = () => {
		chatWin = document.querySelector("#chatWin");
		chatId = document.querySelector("#chatId");
		chatMsg = document.querySelector("#chatMsg");
	};
	webSocket.onopen = (e) => {
		if(chatWin == null) {
			chatWin = document.querySelector("#chatWin");
		}
		chatWin.innerHTML += "웹소켓 서버와 연결 되었습니다. <br>";
		chatWin.innerHTML += "${param.chatId}님이 입장하셨습니다. <br>";
	};
	webSocket.onmessage = (e) => {
		let arrMsg = e.data.split("|"); // 대화명과 메시지로 분리해서 사용
		let sender = arrMsg[0];
		let msg = arrMsg[1];
		if(msg) {
			// 귓속말일 경우
 			if(msg.match("\/")) {
 				const tmpMsg = chatId.value + "\/";
				if(msg.match(tmpMsg)) {
					let tmpTO = msg.replace(tmpMsg, "[귓속말] :");
					chatWin.innerHTML += "<div class='chatMsg'>"+ sender + " " + tmpTO + "</div>";
				}
			} else {
				// 일반대화일 경우
				chatWin.innerHTML += "<div class='chatMsg'>" + sender + " : " + msg + "</div>";
			} 
		}
		chatWin.scrollTop = chatWin.scrollHeight;
	};
	webSocket.onclose = (e) => {
		chatWin.innerHTML += "${param.chatId}님이 퇴장하셨습니다. <br>";
		chatWin.innerHTML += "웹소켓 서버와의 연결이 종료되었습니다. <br>"; 
	};
	function keyPress() {
		if(window.event.keyCode == 13) {
			sendMsg();	
		}
	}
	
	function sendMsg() {
		
		chatWin.innerHTML += "<div style='width : 100%; text-align:right;'><span class='myMsg'>"+chatMsg.value+"</sapn></div>";
		webSocket.send(chatId.value + "|" + chatMsg.value);
		chatMsg.value = "";
		chatWin.scrollTop = chatWin.scrollHeight;
	}
	
	function socketClose() {
		const flag = confirm("채팅을 종료합니다.");
		if(flag) {
			webSocket.close();
			window.close();
		}
	}

</script>
<style>
#chatWin {
	width : 100%;
	height : 300px;
	overflow : scrolll;
	border : 1px solid #000;
}
.myMsg {
	background : pink;
}
.chatMsg {
	background : #eee;
}
</style>
</head>
<body>
	<div>
		<div>
			<span>대화명 : </span>
			<input type="text" name="chatId" id="chatId" value="${param.chatId}" readonly>
			<button id="btnClose" onclick="socketClose()">채팅 종료</button>
		</div>
		<div id="chatWin">
		</div>
		<div>
			<input type="text" name="chatMsg" id="chatMsg" onkeyup="keyPress()">
			<button id="btnSend" onclick="sendMsg()">전송</button>
		</div>
	</div>
</body>
</html>