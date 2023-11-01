package com.ezen.myProject.repository;

import com.ezen.myProject.domain.MemberVO;

public interface MemberDAO {

	int insert(MemberVO mvo);

	MemberVO getUser(String id);

	int update(MemberVO mvo);

}
