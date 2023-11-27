package com.rrs.web.product.service.impl;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import java.util.List;
import java.util.Map;

@Mapper("productMapper")
public interface ProductMapper {
	List<Map<String, Object>> productList(Map<String, Object> paramMap) throws Exception;
}
