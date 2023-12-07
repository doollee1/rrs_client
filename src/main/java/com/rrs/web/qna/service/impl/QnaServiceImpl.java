package com.rrs.web.qna.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import org.springframework.stereotype.Service;

import com.rrs.web.qna.service.QnaService;
import com.rrs.web.qna.service.vo.QnaVO;

@Service("qnaService")
public class QnaServiceImpl implements QnaService {
	@Resource(name = "qnaMapper")
	private QnaMapper qnaMapper;
	
	public int qnaListCnt() throws Exception {
		return qnaMapper.qnaListCnt();
	}
	public int myQnaListCnt(String user_id) throws Exception {
		return qnaMapper.myQnaListCnt(user_id);
	}
	public List<Map<String, Object>> qnaList(Map<String, Object> map) throws Exception {
		return qnaMapper.qnaList(map);
	}
	public List<Map<String, Object>> myQnaList(Map<String, Object> map) throws Exception {
		return this.qnaMapper.myQnaList(map);
	}
	public List<Map<String, Object>> qnaView(String qna_seq) throws Exception {
		return qnaMapper.qnaView(qna_seq);
	}
	public void qnaWrite(QnaVO vo) throws Exception {
		this.qnaMapper.qnaWrite(vo);
	}
	public void qnaModify(QnaVO vo) throws Exception {
		this.qnaMapper.qnaModify(vo);
	}
}
