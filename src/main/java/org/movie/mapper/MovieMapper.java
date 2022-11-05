package org.movie.mapper;

import java.util.List;

import org.movie.domain.MovieVO;

public interface MovieMapper {
	
	public List<MovieVO> getList();
	
	public void insertMovie(MovieVO movie);
	
	public MovieVO selectProductByCode(Long code);
	
	public int deleteMovie(Long code);
	
	public int modify(MovieVO movie);

}
