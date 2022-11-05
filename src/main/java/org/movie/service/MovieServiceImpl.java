package org.movie.service;

import java.util.List;

import org.movie.domain.MovieAttachVO;
import org.movie.domain.MovieVO;
import org.movie.mapper.MovieAttachMapper;
import org.movie.mapper.MovieMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Log4j
@Service
@AllArgsConstructor
public class MovieServiceImpl implements MovieService {

	
	private MovieMapper mapper;
	private MovieAttachMapper attachMapper;
	
	@Override
	public List<MovieVO> getList(){
		log.info("getList............");
		
		return mapper.getList();
	}
	
	@Override 
	@Transactional
	public void register(MovieVO movie) {
		log.info("register........."+movie);
		
		mapper.insertMovie(movie);
		
		if(movie.getAttachList() == null || movie.getAttachList().size()<0) {
			return;
		}
		
		movie.getAttachList().forEach(attach -> {
			attach.setCode(movie.getCode());
			
			attachMapper.insert(attach);
		});
	}
	
	@Override
	public MovieVO getMovie(Long code) {
		
		log.info("get movie............");

		return mapper.selectProductByCode(code);
	}
	
	@Override
	public List<MovieAttachVO> getAttachList(Long code){
		log.info("get attach.......................");
		
		return attachMapper.findByCode(code);
	}
	
	@Override
	@Transactional
	public boolean modify(MovieVO movie) {
		
		log.info("modify............................");
		
		
		boolean result = mapper.modify(movie) ==1;
		
		if(movie.getAttachList() != null) {
			attachMapper.deleteAll(movie.getCode());
			if(result && movie.getAttachList().size() > 0) {
				movie.getAttachList().forEach(attach -> {
					attach.setCode(movie.getCode());
					attachMapper.insert(attach);
					
					});
				}
			}
			return result;
	}
	
	@Override
	@Transactional
	public boolean remove(Long code) {
		log.info("remove...."+code);
		
		attachMapper.deleteAll(code);
	
		
		return mapper.deleteMovie(code) == 1;
	}
}
