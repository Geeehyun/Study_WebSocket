package ws;

import java.io.IOException;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

import jakarta.websocket.OnClose;
import jakarta.websocket.OnError;
import jakarta.websocket.OnMessage;
import jakarta.websocket.OnOpen;
import jakarta.websocket.Session;
import jakarta.websocket.server.ServerEndpoint;

@ServerEndpoint("/ChatServer")
public class ChatServer {
	private static Set<Session> clients = Collections.synchronizedSet(new HashSet<Session>());
	
	@OnOpen
	public void onOpen(Session session) {
		System.out.println("웹소켓 연결 : " + session.getId());
		clients.add(session);
	}
	
	@OnMessage
	public void onMessage(String msg, Session session) throws IOException {
		System.out.println(
				String.format("메시지 전송 -> %s : %s", session.getId(), msg)
		);
		
		synchronized(clients) {
			for(Session client : clients) {
				if(!client.equals(session)) {
					client.getBasicRemote().sendText(msg);
				}
			}
		}
	}
	
	@OnClose
	public void onClose(Session session) {
		System.out.println("웹소켓 종료 : " + session.getId());
		clients.remove(session);
	}
	
	@OnError
	public void onErroer(Throwable e) {
		System.out.println("에러 발생 : " + e.getMessage());
		e.printStackTrace();
	}
	
	/* 기본적으로 채팅 서비스는 이 구조가 다임
	 * 단, 이모티큰이라던지, 이미지 전송 등을 할려면 추가 작업이 필요합니다.
	 * 예외 처리라던지 용량 제한이러던지 상용화 채팅 서비스에서는 추가 작업이 많이 필요 함.
	 * */
}
