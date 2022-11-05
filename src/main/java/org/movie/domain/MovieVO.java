package org.movie.domain;

import java.util.List;

import lombok.Data;
import lombok.ToString;

@Data
public class MovieVO {
	private Long code; 
	private String title; 
	private int price;
	private String director; 
	private String actor;  
	private String synopsis;
	
	private List<MovieAttachVO> attachList;
}
