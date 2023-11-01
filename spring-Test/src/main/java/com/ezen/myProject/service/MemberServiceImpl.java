package com.ezen.myProject.service;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import com.ezen.myProject.domain.MemberVO;
import com.ezen.myProject.repository.MemberDAO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class MemberServiceImpl implements MemberService {
	@Inject
	private MemberDAO mdao;
	
	//password Encode 하기 위한 security 디펜던시 추가
	@Inject
	BCryptPasswordEncoder passwordEncoder;
	
	//ses.pw를 가져오기 위해서
	@Inject
	HttpServletRequest request;

	@Override
	public int register(MemberVO mvo) {
		//아이디가 중복되면 회원가입 실패
		//아이디를 주고, DB에서 일치하는 유저를 달라고 요청
		//일치하는 유저가 없다면 가입(1) / 유저가 있으면 실패(0)
		MemberVO temp = mdao.getUser(mvo.getId());
		if(temp != null) {
			return 0; //여기서 끝남
		}
		
		//password가 null이면, 혹은 값이 없다면 가입불가
		if(mvo.getId() == null || mvo.getId().length() == 0) {
			return 0;
		}
		if(mvo.getPw() == null || mvo.getPw().length() == 0) {
			return 0;
		}
		
		//암호화(encode) / matches(원래비번, 암호화된 비번) => true / false
		String pw = mvo.getPw();
		
		String encodePw = passwordEncoder.encode(pw); //패스워드 암호화
		//멤버 객체에 암호화된 패스워드로 변경
		mvo.setPw(encodePw); 
		
		//아이디가 중복되지 않고, 비밀번호를 제대로 입력했으면 회원가입 진행
		return mdao.insert(mvo);
	}

	@Override
	public MemberVO isUser(MemberVO mvo) {
		//로그인 유저 확인 메서드
		//아이디를 주고, 해당 아이디의 객체 가져오기
		MemberVO temp = mdao.getUser(mvo.getId()); //회원가입할 때 사용했던 메서드 호출
		
		//객체가 없는 경우
		if(temp == null) {
			return null;
		}
		
		//passwordencoder.matches(원래 비번, 암호화된 비번) : 매치가 되는지 체크
		//맞으면 true / 아니면 false
		if(passwordEncoder.matches(mvo.getPw(), temp.getPw())) {
			return temp;
		}else {
			return null;			
		}
		
	}

	@Override
	public int modify(MemberVO mvo) {
		//mvo 객체에서 pw의 값이 있는지 체크
		//mvo의 pw가 없다면 기존 값으로 setting
		if(mvo.getPw() == null || mvo.getPw().length() == 0) {
			MemberVO sesMVO = (MemberVO)request.getSession().getAttribute("ses");
			mvo.setPw(sesMVO.getPw());
		}else { //pw가 있다면 바뀐값을 암호화해서 setting
			String setpw = passwordEncoder.encode(mvo.getPw()); //패스워드 암호화
			//멤버 객체에 암호화된 패스워드로 변경
			mvo.setPw(setpw); 
		}
		log.info(">>>>> pw 수정 후 >>> "+mvo);
		return mdao.update(mvo);
	}
	
}
