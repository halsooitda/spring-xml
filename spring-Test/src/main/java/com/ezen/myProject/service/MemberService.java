package com.ezen.myProject.service;

import com.ezen.myProject.domain.MemberVO;

public interface MemberService {

	int register(MemberVO mvo);

	MemberVO isUser(MemberVO mvo);

	int modify(MemberVO mvo);

}
