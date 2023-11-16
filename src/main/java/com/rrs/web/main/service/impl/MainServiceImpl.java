package com.rrs.web.main.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import com.rrs.web.comm.service.vo.MainContactVO;
import com.rrs.web.comm.service.vo.MainNoticeVO;
import com.rrs.web.comm.service.vo.ProjectVO;
import com.rrs.web.login.service.vo.LoginVO;
import com.rrs.web.main.service.MainService;
import com.rrs.web.main.service.impl.MainMapper;
import com.rrs.web.main.service.impl.MainServiceImpl;

@Service("mainService")
public class MainServiceImpl implements MainService {
  @Resource(name = "mainMapper")
  private MainMapper mainMapper;
  
  public List<MainContactVO> r_Contact_001() throws Exception {
    return this.mainMapper.listContact();
  }
  
  public List<MainContactVO> r_Contact_002(MainContactVO mainContactVO) throws Exception {
    return this.mainMapper.listContactSelect(mainContactVO);
  }
  
  public int u_Contact_001(MainContactVO mainContactVO) throws Exception {
    return this.mainMapper.updateContact(mainContactVO);
  }
  
  public int c_Contact_001(MainContactVO mainContactVo) throws Exception {
    return this.mainMapper.Contact_insert(mainContactVo);
  }
  
  public List<MainNoticeVO> r_Notice_001() throws Exception {
    return this.mainMapper.listMain();
  }
  
  public List<MainNoticeVO> r_Notice_002() throws Exception {
    return this.mainMapper.list();
  }
  
  public int noticeListCnt() throws Exception {
    return this.mainMapper.noticeListCnt();
  }
  
  public List<Map<String, Object>> noticesList(Map<String, Object> map) throws Exception {
    return this.mainMapper.noticeList(map);
  }
  
  public Map<String, Object> noticeDetail(Map<String, Object> map) throws Exception {
    Map<String, Object> rsMap = new HashMap<>();
    this.mainMapper.noticeHitUpd(map);
    return this.mainMapper.noticeDetail(map);
  }
  
  public int noticeIns(Map<String, Object> map) throws Exception {
    int rs = 0;
    String chk = (String)map.get("chk"); 
    if ("I".equals(chk)) {
      rs = this.mainMapper.noticeIns(map);
    } else if ("D".equals(chk)) {
      rs = this.mainMapper.noticeDel(map);
    } else {
      rs = this.mainMapper.noticeUpd(map);
    } 
    return rs;
  }
  
  public List<ProjectVO> r_Project_001() throws Exception {
    return this.mainMapper.listTotal();
  }
  
  public List<ProjectVO> r_Public_001() throws Exception {
    return this.mainMapper.public_sector();
  }
  
  public List<ProjectVO> r_General_001() throws Exception {
    return this.mainMapper.projectList();
  }
  
  public List<ProjectVO> r_Maintenance_001() throws Exception {
    return this.mainMapper.listMainten();
  }
  
  public void c_Project_001(ProjectVO projectVO) throws Exception {
    this.mainMapper.projectSave(projectVO);
  }
  
  public void u_Project_001(ProjectVO projectVO) throws Exception {
    this.mainMapper.projectUpdate(projectVO);
  }
  
  public ProjectVO e_Project_001(int no) throws Exception {
    return this.mainMapper.projectView(no);
  }
  
  public int d_Project_001(int no) throws Exception {
    return this.mainMapper.projectDelete(no);
  }
  
  public List<ProjectVO> selectProject() throws Exception {
    return this.mainMapper.selectProject();
  }
  
  public List<ProjectVO> teamList(Map<String, Object> map) throws Exception {
    return this.mainMapper.teamList(map);
  }
  
  public int teamSave(Map<String, Object> map) throws Exception {
    List<String> no = (List<String>)map.get("no");
    List<String> userId = (List<String>)map.get("userId");
    List<String> tuip_fr_dt = (List<String>)map.get("tuip_fr_dt");
    List<String> tuip_ed_dt = (List<String>)map.get("tuip_ed_dt");
    System.out.println("=====================");
    System.out.println("no::::" + no);
    System.out.println("userId::::" + userId);
    System.out.println("=====================");
    for (int i = 0; i < userId.size(); i++) {
      Map<String, Object> inMap = new HashMap<>();
      inMap.put("no", no.get(0));
      inMap.put("userId", userId.get(i));
      inMap.put("tuip_fr_dt", tuip_fr_dt.get(i));
      inMap.put("tuip_ed_dt", tuip_ed_dt.get(i));
      this.mainMapper.teamSave(inMap);
    } 
    return 0;
  }
  
  public int teamMemDelete(Map<String, Object> param) throws Exception {
    return this.mainMapper.teamMemDelete(param);
  }
  
  public List<LoginVO> member_sel(Map<String, Object> map) throws Exception {
    return this.mainMapper.member_sel(map);
  }
  
  public LoginVO member_detailSel(Map<String, Object> map) throws Exception {
    return this.mainMapper.member_detailSel(map);
  }
  
  public int member_selCnt(Map<String, Object> map) throws Exception {
    return this.mainMapper.member_selCnt(map);
  }
  
  public String member_save(LoginVO vo) throws Exception {
    Map<String, Object> rsMap = new HashMap<>();
    int rs = 0;
    int passCnt = 0;
    String chk = vo.getGubun();
    if ("1".equals(chk)) {
      rs = this.mainMapper.member_ins(vo);
    } else if ("2".equals(chk)) {
      passCnt = this.mainMapper.member_pass_chk(vo);
      if (passCnt == 1)
        return "F"; 
      rs = this.mainMapper.member_user_upd(vo);
    } else if ("3".equals(chk)) {
      rs = this.mainMapper.member_admin_upd(vo);
    } 
    return (rs == 0) ? "N" : "Y";
  }
  
  public int member_user_upd(LoginVO vo) throws Exception {
    return 0;
  }
  
  public int member_password_init(LoginVO vo) throws Exception {
    return this.mainMapper.member_password_init(vo);
  }
  
  public int member_admin_upd(LoginVO vo) throws Exception {
    return 0;
  }
  
  public List<Map<String, Object>> Comm_codeList(Map<String, Object> map) throws Exception {
    return this.mainMapper.Comm_codeList(map);
  }
  
  public List<Map<String, Object>> Comm_codeDetail(Map<String, Object> map) throws Exception {
    return this.mainMapper.Comm_codeDetail(map);
  }
  
  public Map<String, Object> Comm_codeCud(Map<String, Object> map) throws Exception {
    Map<String, Object> inMap = new HashMap<>();
    Map<String, Object> rsMap = new HashMap<>();
    List<String> simp_c = (List<String>)map.get("simp_c");
    List<String> simp_cnm = (List<String>)map.get("simp_cnm");
    List<String> order_num = (List<String>)map.get("order_num");
    List<String> use_yn = (List<String>)map.get("use_yn");
    List<String> attr_1 = (List<String>)map.get("attr_1");
    List<String> attr_2 = (List<String>)map.get("attr_2");
    String simp_tpc = (String)map.get("simp_tpc");
    String simp_tpcnm = (String)map.get("simp_tpcnm");
    for (int i = 0; i < simp_c.size(); i++) {
      inMap.put("simp_tpc", simp_tpc);
      inMap.put("simp_tpcnm", simp_tpcnm);
      inMap.put("simp_c", simp_c.get(i));
      inMap.put("simp_cnm", simp_cnm.get(i));
      inMap.put("order_num", order_num.get(i));
      inMap.put("use_yn", use_yn.get(i));
      inMap.put("attr_1", attr_1.get(i));
      inMap.put("attr_2", attr_2.get(i));
      this.mainMapper.Comm_codeIns(inMap);
    } 
    return rsMap;
  }
  
  public List<Map<String, Object>> selectProdInfo(Map<String, Object> map) throws Exception {
    return this.mainMapper.selectProdInfo(map);
  }
  
  public List<Map<String, Object>> selectCommList(Map<String, String> param) throws Exception {
    return this.mainMapper.selectCommList(param);
  }
  
  public List<Map<String, Object>> selectProdRepair(Map<String, Object> map) throws Exception {
    return this.mainMapper.selectProdRepair(map);
  }
  
  public void insertProdInfo(Map<String, Object> map) throws Exception {
    this.mainMapper.insertProdInfo(map);
  }
  
  public void updateProdInfo(Map<String, Object> map) throws Exception {
    this.mainMapper.updateProdInfo(map);
  }
  
  public List<Map<String, Object>> selectUserList(Map<String, Object> map) throws Exception {
    return this.mainMapper.selectUserList(map);
  }
  
  public void insertProdRepair(Map<String, Object> map) throws Exception {
    this.mainMapper.insertProdRepair(map);
  }
  
  public void updateProdRepair(Map<String, Object> map) throws Exception {
    this.mainMapper.updateProdRepair(map);
  }
  
  public void updateYnProdRepair(Map<String, Object> map) throws Exception {
    this.mainMapper.updateYnProdRepair(map);
  }
  
  public void updateProdSts(Map<String, Object> map) throws Exception {
    this.mainMapper.updateProdSts(map);
  }
  
  public List<Map<String, Object>> selectProdTrans(Map<String, Object> map) throws Exception {
    return this.mainMapper.selectProdTrans(map);
  }
  
  public String selectApporoverMasterYn(Map<String, Object> map) throws Exception {
    return this.mainMapper.selectApporoverMasterYn(map);
  }
  
  public ModelAndView insertTransTake(Map<String, Object> map) throws Exception {
    ModelAndView mav = new ModelAndView();
    int pt = 0;
    String take_user_id = "";
    String take_project = "";
    if ("2".equals(map.get("trans_gbn"))) {
      take_user_id = (String)map.get("take_user_id");
      take_project = (String)map.get("take_project");
      map.put("take_sts", "2");
      map.put("take_user_id", "0");
      map.put("take_project", "0");
    } 
    map.put("link_seq", "0");
    this.mainMapper.insertTransTake(map);
    if ("2".equals(map.get("trans_gbn"))) {
      map.put("take_sts", "1");
      map.put("take_user_id", take_user_id);
      map.put("take_project", take_project);
      map.put("trans_user_id", "0");
      map.put("trans_project", "0");
      map.put("link_seq", map.get("prod_seq"));
      this.mainMapper.insertTransTake(map);
    } else {
      this.mainMapper.updateTransProdSts(map);
    } 
    return mav;
  }
  
  public void updateTransTake(Map<String, Object> map) throws Exception {
    this.mainMapper.updateTransTake(map);
  }
  
  public void updateYnTransTake(Map<String, Object> map) throws Exception {
    this.mainMapper.updateYnTransTake(map);
    if ("2".equals(map.get("trans_gbn")))
      this.mainMapper.updateLinkedDelete(map); 
    map.put("delete", "Y");
    this.mainMapper.updateTransProdSts(map);
  }
  
  public void updateTransProdSts(Map<String, Object> map) throws Exception {
    this.mainMapper.updateTransProdSts(map);
  }
  
  public List<Map<String, Object>> selectHoliRegInfo(Map<String, Object> map) throws Exception {
    return this.mainMapper.selectHoliRegInfo(map);
  }
  
  public void insertHoliRegInfo(Map<String, Object> map) throws Exception {
    this.mainMapper.insertHoliRegInfo(map);
  }
  
  public void updateHoliRegInfo(Map<String, Object> map) throws Exception {
    this.mainMapper.updateHoliRegInfo(map);
  }
  
  public void deleteHoliRegInfo(Map<String, Object> map) throws Exception {
    this.mainMapper.deleteHoliRegInfo(map);
  }
  
  public List<Map<String, Object>> selectDeviceRegList(Map<String, Object> map) throws Exception {
	  return this.mainMapper.selectDeviceRegList(map);
  }
  
  public List<Map<String, Object>> selectProjectList(Map<String, Object> map) throws Exception {
    return this.mainMapper.selectProjectList(map);
  }
  
  public String selectLocalFoodConfirm(String strCode) throws Exception {
    return this.mainMapper.selectLocalFoodConfirm(strCode);
  }
}
