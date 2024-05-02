package com.rrs.web.comm.service.impl;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import java.util.*;

@Mapper("commonMapper")
public interface CommonMapper {
	List<Map<String, Object>> commCodeList(Map<String, Object> paramMap) throws Exception;

	List<Map<String, Object>> getChatIdList() throws Exception;
}
