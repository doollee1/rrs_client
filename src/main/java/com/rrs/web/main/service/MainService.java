package com.rrs.web.main.service;

import java.util.List;
import java.util.Map;
import org.springframework.web.servlet.ModelAndView;

import com.rrs.web.comm.service.vo.MainContactVO;
import com.rrs.web.comm.service.vo.MainNoticeVO;
import com.rrs.web.comm.service.vo.ProjectVO;
import com.rrs.web.login.service.vo.LoginVO;

public interface MainService {
  List<MainContactVO> r_Contact_001() throws Exception;
  
  List<MainContactVO> r_Contact_002(MainContactVO paramMainContactVO) throws Exception;
  
  int u_Contact_001(MainContactVO paramMainContactVO) throws Exception;
  
  int c_Contact_001(MainContactVO paramMainContactVO) throws Exception;
  
  List<MainNoticeVO> r_Notice_001() throws Exception;
  
  List<MainNoticeVO> r_Notice_002() throws Exception;
  
  List<Map<String, Object>> noticesList(Map<String, Object> paramMap) throws Exception;
  
  int noticeListCnt() throws Exception;
  
  Map<String, Object> noticeDetail(Map<String, Object> paramMap) throws Exception;
  
  int noticeIns(Map<String, Object> paramMap) throws Exception;
  
  List<ProjectVO> r_General_001() throws Exception;
  
  List<ProjectVO> r_Project_001() throws Exception;
  
  List<ProjectVO> r_Maintenance_001() throws Exception;
  
  List<ProjectVO> r_Public_001() throws Exception;
  
  void c_Project_001(ProjectVO paramProjectVO) throws Exception;
  
  void u_Project_001(ProjectVO paramProjectVO) throws Exception;
  
  ProjectVO e_Project_001(int paramInt) throws Exception;
  
  int d_Project_001(int paramInt) throws Exception;
  
  List<ProjectVO> selectProject() throws Exception;
  
  List<ProjectVO> teamList(Map<String, Object> paramMap) throws Exception;
  
  int teamSave(Map<String, Object> paramMap) throws Exception;
  
  int teamMemDelete(Map<String, Object> paramMap) throws Exception;
  
  List<LoginVO> member_sel(Map<String, Object> paramMap) throws Exception;
  
  LoginVO member_detailSel(Map<String, Object> paramMap) throws Exception;
  
  int member_selCnt(Map<String, Object> paramMap) throws Exception;
  
  String member_save(LoginVO paramLoginVO) throws Exception;
  
  int member_user_upd(LoginVO paramLoginVO) throws Exception;
  
  int member_password_init(LoginVO paramLoginVO) throws Exception;
  
  int member_admin_upd(LoginVO paramLoginVO) throws Exception;
  
  List<Map<String, Object>> Comm_codeList(Map<String, Object> paramMap) throws Exception;
  
  List<Map<String, Object>> Comm_codeDetail(Map<String, Object> paramMap) throws Exception;
  
  Map<String, Object> Comm_codeCud(Map<String, Object> paramMap) throws Exception;
  
  List<Map<String, Object>> selectProdInfo(Map<String, Object> paramMap) throws Exception;
  
  List<Map<String, Object>> selectCommList(Map<String, String> paramMap) throws Exception;
  
  List<Map<String, Object>> selectProdRepair(Map<String, Object> paramMap) throws Exception;
  
  List<Map<String, Object>> selectUserList(Map<String, Object> paramMap) throws Exception;
  
  void updateProdInfo(Map<String, Object> paramMap) throws Exception;
  
  void insertProdInfo(Map<String, Object> paramMap) throws Exception;
  
  void insertProdRepair(Map<String, Object> paramMap) throws Exception;
  
  void updateProdRepair(Map<String, Object> paramMap) throws Exception;
  
  void updateYnProdRepair(Map<String, Object> paramMap) throws Exception;
  
  void updateProdSts(Map<String, Object> paramMap) throws Exception;
  
  List<Map<String, Object>> selectProjectList(Map<String, Object> paramMap) throws Exception;
  
  List<Map<String, Object>> selectProdTrans(Map<String, Object> paramMap) throws Exception;
  
  ModelAndView insertTransTake(Map<String, Object> paramMap) throws Exception;
  
  void updateTransTake(Map<String, Object> paramMap) throws Exception;
  
  void updateYnTransTake(Map<String, Object> paramMap) throws Exception;
  
  void updateTransProdSts(Map<String, Object> paramMap) throws Exception;
  
  List<Map<String, Object>> selectHoliRegInfo(Map<String, Object> paramMap) throws Exception;
  
  String selectApporoverMasterYn(Map<String, Object> paramMap) throws Exception;
  
  void insertHoliRegInfo(Map<String, Object> paramMap) throws Exception;
  
  void updateHoliRegInfo(Map<String, Object> paramMap) throws Exception; 
  
  void deleteHoliRegInfo(Map<String, Object> paramMap) throws Exception;
  
  List<Map<String, Object>> selectDeviceRegList(Map<String, Object> paramMap) throws Exception;
  
  String selectLocalFoodConfirm(String paramString) throws Exception;
}
