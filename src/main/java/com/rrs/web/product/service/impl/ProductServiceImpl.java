package com.rrs.web.product.service.impl;

import java.util.*;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;

import com.rrs.web.product.service.ProductService;

@Service("productService")
public class ProductServiceImpl implements ProductService {
	@Resource(name = "productMapper")
	private ProductMapper productMapper;

	public List<Map<String, Object>> productList(Map<String, Object> map) throws Exception {
		return this.productMapper.productList(map);
	}
	
	public List<Map<String, Object>> productCommonList(Map<String, Object> map) throws Exception {
		return this.productMapper.productCommonList(map);
	}
}
