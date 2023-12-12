package com.rrs.web.qna.service.impl;

import java.util.List;
import java.util.Map;

import com.rrs.web.qna.service.vo.QnaVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("qnaMapper")
public interface QnaMapper {
	int qnaListCnt() throws Exception;
	int myQnaListCnt(String user_id) throws Exception;
	List<Map<String, Object>> qnaList(Map<String, Object> map) throws Exception;
	List<Map<String, Object>> myQnaList(Map<String, Object> map) throws Exception;
	List<Map<String, Object>> qnaView(String qna_seq) throws Exception;
	void qnaWrite(QnaVO vo) throws Exception;
	void qnaModify(QnaVO vo) throws Exception;
	void qnaDelete(QnaVO vo) throws Exception;
}
