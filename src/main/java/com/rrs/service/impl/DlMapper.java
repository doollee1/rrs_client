package com.rrs.service.impl;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import java.util.List;
import java.util.Map;

import com.rrs.comm.service.vo.LoginVO;
import com.rrs.service.vo.MainContactVO;
import com.rrs.service.vo.MainNoticeVO;
import com.rrs.service.vo.ProjectVO;

@Mapper("dlMapper")
public interface DlMapper {
  List<MainContactVO> listContact() throws Exception;
  
  List<MainContactVO> listContactSelect(MainContactVO paramMainContactVO) throws Exception;
  
  int updateContact(MainContactVO paramMainContactVO) throws Exception;
  
  int Contact_insert(MainContactVO paramMainContactVO) throws Exception;
  
  List<MainNoticeVO> listMain() throws Exception;
  
  List<MainNoticeVO> list() throws Exception;
  
  List<Map<String, Object>> noticeList(Map<String, Object> paramMap) throws Exception;
  
  int noticeListCnt() throws Exception;
  
  Map<String, Object> noticeDetail(Map<String, Object> paramMap) throws Exception;
  
  int noticeIns(Map<String, Object> paramMap) throws Exception;
  
  int noticeHitUpd(Map<String, Object> paramMap) throws Exception;
  
  int noticeUpd(Map<String, Object> paramMap) throws Exception;
  
  int noticeDel(Map<String, Object> paramMap) throws Exception;
  
  List<ProjectVO> listTotal() throws Exception;
  
  List<ProjectVO> public_sector() throws Exception;
  
  List<ProjectVO> projectList() throws Exception;
  
  List<ProjectVO> listMainten() throws Exception;
  
  void projectSave(ProjectVO paramProjectVO) throws Exception;
  
  void projectUpdate(ProjectVO paramProjectVO) throws Exception;
  
  ProjectVO projectView(int paramInt) throws Exception;
  
  int projectDelete(int paramInt) throws Exception;
  
  List<ProjectVO> selectProject() throws Exception;
  
  List<ProjectVO> teamList(Map<String, Object> paramMap) throws Exception;
  
  int teamSave(Map<String, Object> paramMap) throws Exception;
  
  int teamMemDelete(Map<String, Object> paramMap) throws Exception;
  
  List<LoginVO> member_sel(Map<String, Object> paramMap) throws Exception;
  
  LoginVO member_detailSel(Map<String, Object> paramMap) throws Exception;
  
  int member_selCnt(Map<String, Object> paramMap) throws Exception;
  
  int member_ins(LoginVO paramLoginVO) throws Exception;
  
  int member_user_upd(LoginVO paramLoginVO) throws Exception;
  
  int member_pass_chk(LoginVO paramLoginVO) throws Exception;
  
  int member_password_init(LoginVO paramLoginVO) throws Exception;
  
  int member_admin_upd(LoginVO paramLoginVO) throws Exception;
  
  List<Map<String, Object>> Comm_codeList(Map<String, Object> paramMap) throws Exception;
  
  List<Map<String, Object>> Comm_codeDetail(Map<String, Object> paramMap) throws Exception;
  
  int Comm_codeIns(Map<String, Object> paramMap) throws Exception;
  
  int Comm_codeUpd(Map<String, Object> paramMap) throws Exception;
  
  List<Map<String, Object>> selectProdInfo(Map<String, Object> paramMap) throws Exception;
  
  List<Map<String, Object>> selectProdRepair(Map<String, Object> paramMap) throws Exception;
  
  List<Map<String, Object>> selectCommList(Map<String, String> paramMap) throws Exception;
  
  void insertProdInfo(Map<String, Object> paramMap) throws Exception;
  
  void updateProdInfo(Map<String, Object> paramMap) throws Exception;
  
  List<Map<String, Object>> selectUserList(Map<String, Object> paramMap) throws Exception;
  
  void insertProdRepair(Map<String, Object> paramMap) throws Exception;
  
  void updateProdRepair(Map<String, Object> paramMap) throws Exception;
  
  void updateYnProdRepair(Map<String, Object> paramMap) throws Exception;
  
  void updateProdSts(Map<String, Object> paramMap) throws Exception;
  
  List<Map<String, Object>> selectProdTrans(Map<String, Object> paramMap) throws Exception;
  
  void insertTransTake(Map<String, Object> paramMap) throws Exception;
  
  List<Map<String, Object>> selectProjectList(Map<String, Object> paramMap) throws Exception;
  
  void updateTransTake(Map<String, Object> paramMap) throws Exception;
  
  void updateYnTransTake(Map<String, Object> paramMap) throws Exception;
  
  void updateLinkedDelete(Map<String, Object> paramMap) throws Exception;
  
  void updateTransProdSts(Map<String, Object> paramMap) throws Exception;
  
  List<Map<String, Object>> selectHoliRegInfo(Map<String, Object> paramMap) throws Exception;
  
  String selectApporoverMasterYn(Map<String, Object> paramMap) throws Exception;
  
  void insertHoliRegInfo(Map<String, Object> paramMap) throws Exception;
  
  void updateHoliRegInfo(Map<String, Object> paramMap) throws Exception;
  
  void deleteHoliRegInfo(Map<String, Object> paramMap) throws Exception;
  
  List<Map<String, Object>> selectDeviceRegList(Map<String, Object> paramMap) throws Exception;
  
  String selectLocalFoodConfirm(String paramString) throws Exception;
}
