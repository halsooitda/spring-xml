package com.ezen.myProject.repository;

import java.util.List;

import com.ezen.myProject.domain.FileVO;

public interface FileDAO {

	int insertFile(FileVO fvo);

	int fileCount(int bno);

	List<FileVO> getFileList(int bno);

	int removeFile(String uuid);

}
