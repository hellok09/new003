package org.movie.controller;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import org.movie.domain.MovieAttachVO;
import org.movie.domain.MovieVO;
import org.movie.service.MovieService;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;


import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@RequestMapping("/movie")
@Log4j
@AllArgsConstructor
public class MovieController {

	private MovieService service;
	
	
	@GetMapping("/list")
	public void list(Model model) {
		
		log.info("list");
		
		model.addAttribute("list", service.getList());
	}
	
	@GetMapping("/register")
	public void register() {
		
		
	}
	
	@PostMapping("/register")
	public String register(MovieVO movie, RedirectAttributes rttr) {
		
		log.info("register:........." + movie);
		
		
		if(movie.getAttachList() != null) {
			
			movie.getAttachList().forEach(attach -> log.info(attach));
		}
		service.register(movie);
		rttr.addFlashAttribute("result", movie.getCode());
		
		return "redirect:/movie/list";
	}
	
	@GetMapping({"/get", "/modify"})
	public void get(@RequestParam("code") Long code, Model model) {
		log.info("/get or /modify");
		
		model.addAttribute("movie", service.getMovie(code));
	
	}
	
	@PostMapping("/modify")
	public String modify(MovieVO movie, RedirectAttributes rttr) {
		
		log.info("modify..........................");
		
		if(movie.getAttachList() != null) {
			List<MovieAttachVO> attachList = service.getAttachList(movie.getCode());
			deleteFiles(attachList);
			movie.getAttachList().forEach(attach -> log.info(attach));
			
		}
		
		boolean result = service.modify(movie);
		if(result) {
			rttr.addFlashAttribute("result", "success");
		}
		return "redirect:/movie/list";
		
	}
	
	@GetMapping("/remove")
	public String remove(@RequestParam("code")Long code, RedirectAttributes rttr) {
		
		log.info("remove......." +code);
		
		List<MovieAttachVO> attachList = service.getAttachList(code);
		
		if(service.remove(code)) {
			deleteFiles(attachList);
			rttr.addFlashAttribute("result","success");
		}
		
		return "redirect:/movie/list";
	}
	
	private void deleteFiles(List<MovieAttachVO> attachList) {
		
		if(attachList == null || attachList.size()==0) {
			return;
		}
		
		attachList.forEach(attach -> {
			try {
				Path file = Paths.get(attach.getUploadPath()+"\\"+attach.getUuid()+"_"+attach.getFileName());
				Files.deleteIfExists(file);
				
				Path thumbNail = Paths.get(attach.getUploadPath()+"\\"+"s_"+attach.getUuid()+"_"+attach.getFileName());
				Files.delete(thumbNail);
			}catch(Exception e) {
				e.printStackTrace();
			}
		});
	}
	
	
	
	@GetMapping(value="/getAttachList", produces=MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<MovieAttachVO>> getAttachList(Long code){
		log.info(code);
		
		return new ResponseEntity<>(service.getAttachList(code), HttpStatus.OK);
	}
}
