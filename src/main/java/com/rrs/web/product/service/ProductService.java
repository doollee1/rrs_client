package com.rrs.web.product.service;

import java.util.*;

public interface ProductService {
	List<Map<String, Object>> productList(Map<String, Object> paramMap) throws Exception;
	
	List<Map<String, Object>> productCommonList(Map<String, Object> paramMap) throws Exception;
}
