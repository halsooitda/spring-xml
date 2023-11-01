package com.ezen.myProject.controller;

import java.util.List;

import javax.inject.Inject;

import org.apache.ibatis.annotations.Delete;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.ezen.myProject.domain.BoardDTO;
import com.ezen.myProject.domain.BoardVO;
import com.ezen.myProject.domain.FileVO;
import com.ezen.myProject.domain.PagingVO;
import com.ezen.myProject.handler.FileHandler;
import com.ezen.myProject.handler.PagingHandler;
import com.ezen.myProject.service.BoardService;

import lombok.extern.slf4j.Slf4j;

@Slf4j //log
@RequestMapping("/board/*")
@Controller
public class BoardController {
	@Inject //객체를 생성해주는 것, BoardService bsv = new BoardService();
	private BoardService bsv;
	
	@Inject
	private FileHandler fhd;

	//화면을 띄어주는 get
	@GetMapping("/register")  
	public String boardRegisterGet() {
		return "/board/register"; //destpage, .jsp는 자동으로 붙이도록 설정했음.
	}
	
//	@PostMapping("/register")
//	public String register(BoardVO bvo) {
//		log.info(">>>>> "+bvo.toString());
//		int isOk = bsv.register(bvo);
//		log.info(">>>>> board register "+(isOk>0? "성공" : "실패"));
//		return "redirect:/board/list";
//	}
	
	//파일 포함 게시물 등록
	@PostMapping("/register")
	public String register(BoardVO bvo, 
			@RequestParam(name="files", required = false)MultipartFile[] files) { 
		//@RequestParam:물음표로 달고오는 애를 받을 때, required(필수여부)=false : 해당 파라미터가 없어도 예외가 발생하지 않음.
		log.info(">>>>> bvo >>> "+bvo.toString());
		log.info(">>>>> files >>> "+files);
		List<FileVO> flist = null;
		
		//files가 null일 수 있음. 첨부파일이 있을 경우에만 fhd 호출
		if(files[0].getSize() > 0) { 
			//첫번째 파일이 size가 0보다 크다면 = 파일이 있다
			//flist에 파일 객체 담기
			flist = fhd.uploadFiles(files);			
		}else {
			log.info("file null");
		}
		
		BoardDTO bdto = new BoardDTO(bvo, flist);
		
//		int isOk = bsv.register(bvo);
		int isOk = bsv.register(bdto);
		log.info(">>>>> board register "+(isOk>0? "성공" : "실패"));
		return "redirect:/board/list";
	}
	
	@GetMapping("/list")
	public String list(Model model, PagingVO pgvo) { //Model객체 -> getAttribute해줌
		log.info(">>>> PagingVO >>> "+pgvo);
		
		//1. getList(pgvo) 수정
		List<BoardVO> list = bsv.getList(pgvo);
		//log.info(">>>>> getList >>> "+list.get(0));
		model.addAttribute("list", list); //addAttribute = setAttribute

		//2.등록
		int totalCount = bsv.getTotalCount(pgvo);
		PagingHandler ph = new PagingHandler(pgvo, totalCount);
		model.addAttribute("ph", ph);
		
		//list에 댓글수, 파일수
		int isOk = bsv.count(list);
		log.info(">>>>> board Count "+(isOk>0? "성공" : "실패"));
		
		return "/board/list";
	}
	
	@GetMapping({"/detail", "/modify"})
	public void detail(Model model, @RequestParam("bno")int bno) { //void = 온 곳으로 가라는 뜻
		log.info(">>>>> detail bno >> "+bno);
		
//		//readCount +1
//		int isOk = bsv.readCount(bno);
//		log.info(">>>>> board readcount "+(isOk>0? "성공" : "실패"));
		
		//detail페이지 불러오기
		//BoardVO bvo = bsv.getDetail(bno);
		//model.addAttribute("bvo", bvo);	
		
		//파일 내용도 포함해서 같이 가져와야 함.
		BoardDTO bdto = bsv.getDetailFile(bno);
		model.addAttribute("bdto", bdto);
	}
	
	//수정할 때 들어가는 부당 read_count 2개 빼주기
	@PostMapping("/modify")
	public String modify(BoardVO bvo, RedirectAttributes reAttr,
			@RequestParam(name="files", required = false)MultipartFile[] files) {
		log.info(">>>>> bvo >> "+bvo);
		log.info(">>>>> files >> "+files);
		
		List<FileVO> flist = null;
		if(files[0].getSize() > 0) { //파일이 존재함
			//기존 파일은 이미 DB에 등록완료. 삭제할 파일은 비동기로 이미 삭제 완료.
			//새로 추가할 파일만 추가
			flist = fhd.uploadFiles(files); //fvo 구성 List로 리턴
		}
		BoardDTO bdto = new BoardDTO(bvo, flist);
		
		int isOk = bsv.modifyFile(bdto);
		log.info(">>>>> board modify "+(isOk>0? "성공" : "실패"));
		return "redirect:/board/detail?bno="+bvo.getBno(); //detail에 업데이트된 데이터를 달고 가라
		//reAttr.addFlashAttribute(null, reAttr) => 1회성임
	}
	
	@GetMapping("/remove")
	public String remove(@RequestParam("bno")int bno, RedirectAttributes reAttr) {
		log.info(">>>>> remove bno >> "+bno);
		
		int isOk = bsv.remove(bno);
		log.info(">>>>> board remove "+(isOk>0? "성공" : "실패"));
		reAttr.addFlashAttribute("isOk", isOk);
		return "redirect:/board/list"; //redirect = 해당 페이지를 한번 더 타라는 뜻
	}
	
	@DeleteMapping(value="/file/{uuid}", produces = MediaType.TEXT_PLAIN_VALUE)
	public ResponseEntity<String> removeFile(@PathVariable("uuid")String uuid){
		log.info("uuid >>>>> "+uuid);
		int isOk = bsv.removeFile(uuid);
		return isOk > 0 ? new ResponseEntity<String>("1", HttpStatus.OK) : new ResponseEntity<String>("0", HttpStatus.INTERNAL_SERVER_ERROR);		
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
