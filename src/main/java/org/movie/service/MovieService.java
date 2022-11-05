package org.movie.service;

import java.util.List;

import org.movie.domain.MovieAttachVO;
import org.movie.domain.MovieVO;

public interface MovieService {
	
	public List<MovieVO> getList();
	
	public void register(MovieVO movie);
	
	public MovieVO getMovie(Long code);
	
	public List<MovieAttachVO> getAttachList(Long code);
	
	public boolean modify(MovieVO movie);
	
	public boolean remove(Long code);

}
