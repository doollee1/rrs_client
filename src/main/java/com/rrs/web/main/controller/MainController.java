package com.rrs.web.main.controller;

import com.google.gson.Gson;
import com.rrs.web.comm.service.vo.MainContactVO;
import com.rrs.web.comm.service.vo.ProjectVO;
import com.rrs.web.login.service.LoginService;
import com.rrs.web.login.service.vo.LoginVO;
import com.rrs.web.main.controller.MainController;
import com.rrs.web.main.service.MainService;

import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class MainController {
	private static final Logger logger = LoggerFactory.getLogger(MainController.class);

  	@Resource(name = "mainService")
  	MainService mainService;
  
  	@Resource(name = "loginService")
  	LoginService loginService;
  
  @RequestMapping(value = {"/getMartData.do"}, method = {RequestMethod.POST})
  @ResponseBody
  public ResponseEntity<String> getMartData(@RequestParam Map<String, Object> map) throws Exception {
    String rcvCode = (String)map.get("code");
    logger.info("rcvCode==" + rcvCode);
    String rtnStr = "N";
    if (rcvCode != null && !"".equals(rcvCode)) {
      rtnStr = this.mainService.selectLocalFoodConfirm(rcvCode);
      logger.info("rtnStr==" + rtnStr);
    } 
    HttpHeaders responseHeaders = new HttpHeaders();
    responseHeaders.add("Content-Type", "text/html; charset=UTF-8");
    return new ResponseEntity(rtnStr, (MultiValueMap)responseHeaders, HttpStatus.CREATED);
  }
  
  @RequestMapping(value = {"/Contact_select.do"}, method = {RequestMethod.GET})
  public String r_Contact_001(Model model, HttpServletRequest httpServletRequest, MainContactVO mainContactVo) throws Exception {
    HttpSession session = httpServletRequest.getSession();
    String loginYn = (String)session.getAttribute("loginYn");
    String qna_sqno = httpServletRequest.getParameter("qna_sqno");
    if (qna_sqno != null) {
      mainContactVo.setLoginYn(loginYn);
      model.addAttribute("listContactSelect", this.mainService.r_Contact_002(mainContactVo));
    } 
    model.addAttribute("listContact", this.mainService.r_Contact_001());
    return "Contact_select";
  }
  
  @RequestMapping(value = {"/privacyInfo.do"}, method = {RequestMethod.GET})
  public String privacyInfo(Model model) throws Exception {
    logger.info("projectInsert");
    return "privacyInfo";
  }
  
  @RequestMapping(value = {"updateContact.do"}, method = {RequestMethod.POST})
  @ResponseBody
  public String u_Contact_001(@ModelAttribute("mainContactVo") MainContactVO mainContactVo) throws Exception {
    logger.info("update");
    int rs = this.mainService.u_Contact_001(mainContactVo);
    return (rs == 0) ? "N" : "Y";
  }
  
  @RequestMapping(value = {"Contact_insert.do"}, method = {RequestMethod.GET})
  public String c_Contact_001(Model model) throws Exception {
    logger.info("insert");
    return "Contact_insert";
  }
  
  @RequestMapping(value = {"Contact_insert.do"}, method = {RequestMethod.POST})
  @ResponseBody
  public String c_Contact_002(@ModelAttribute("mainContactVo") MainContactVO mainContactVo, Model model) throws Exception {
    logger.info("select");
    int rs = this.mainService.c_Contact_001(mainContactVo);
    return (rs == 0) ? "N" : "Y";
  }
  
  @RequestMapping(value = {"Contact_pwChk.do"}, method = {RequestMethod.POST})
  @ResponseBody
  public String c_Contact_pwChk(@ModelAttribute("mainContactVo") MainContactVO mainContactVo, Model model, HttpServletRequest req) throws Exception {
    logger.info("pwChk");
    List<MainContactVO> list = this.mainService.r_Contact_002(mainContactVo);
    HttpSession session = req.getSession();
    String rs = (list.size() == 0) ? "N" : "Y";
    return rs;
  }
  
  @RequestMapping(value = {"/projectInsert.do"}, method = {RequestMethod.GET})
  public String e_Project_002(Model model) throws Exception {
    logger.info("projectInsert");
    return "Project_insert";
  }
  
  @RequestMapping(value = {"/projectSave.do"}, method = {RequestMethod.POST})
  public String c_Project_001(ProjectVO projectVO, Model model) throws Exception {
    logger.info("projectSave");
    this.mainService.c_Project_001(projectVO);
    model.addAttribute("projectList", this.mainService.r_General_001());
    model.addAttribute("listTotal", this.mainService.r_Project_001());
    model.addAttribute("listMainten", this.mainService.r_Maintenance_001());
    model.addAttribute("public_sector", this.mainService.r_Public_001());
    return "Project_actual";
  }
  
  @RequestMapping(value = {"/projectView.do"}, method = {RequestMethod.GET})
  public String e_Project_001(Model model, HttpServletRequest request, ProjectVO projectVO) throws Exception {
    logger.info("projectView");
    model.addAttribute("read", this.mainService.e_Project_001(projectVO.getNo()));
    return "Project_update";
  }
  
  @RequestMapping(value = {"/projectUpdate.do"}, method = {RequestMethod.POST})
  public String u_Project_001(ProjectVO projectVO, Model model) throws Exception {
    logger.info("projectUpdate");
    this.mainService.u_Project_001(projectVO);
    model.addAttribute("projectList", this.mainService.r_General_001());
    model.addAttribute("listTotal", this.mainService.r_Project_001());
    model.addAttribute("listMainten", this.mainService.r_Maintenance_001());
    model.addAttribute("public_sector", this.mainService.r_Public_001());
    return "Project_actual";
  }
  
  @RequestMapping(value = {"/projectDelete.do"}, method = {RequestMethod.POST})
  @ResponseBody
  public String d_Project_001(ProjectVO projectVO, Model model) throws Exception {
    logger.info("projectDelete");
    int chk = this.mainService.d_Project_001(projectVO.getNo());
    return (chk > 0) ? "Y" : "N";
  }
  
  @RequestMapping(value = {"/teamView.do"}, method = {RequestMethod.GET})
  public String teamInsert(ProjectVO projectVO, Model model) throws Exception {
    logger.info("teamInsert");
    this.mainService.u_Project_001(projectVO);
    model.addAttribute("projectList", this.mainService.r_General_001());
    return "Project_team";
  }
  
  @RequestMapping(value = {"/teamSave.do"}, method = {RequestMethod.POST})
  @ResponseBody
  public String teamSave(@RequestParam MultiValueMap<String, String> params, HttpServletRequest request) throws Exception {
    logger.info("teamSave");
    Map<String, Object> map = new HashMap<>();
    Enumeration<String> enums = request.getParameterNames();
    while (enums.hasMoreElements()) {
      String paramName = enums.nextElement();
      String[] parameters = request.getParameterValues(paramName);
      if (parameters.length > 0) {
        List<Object> parmList = new ArrayList();
        for (int i = 0; i < parameters.length; i++)
          parmList.add(parmList.size(), parameters[i].toString()); 
        logger.debug("===============");
        logger.debug(parmList.toString());
        map.put(paramName, parmList);
      } 
    } 
    System.out.println(map.toString());
    this.mainService.teamSave(map);
    return "Y";
  }
  
  @RequestMapping(value = {"/teamMemDelete.do"}, method = {RequestMethod.POST})
  @ResponseBody
  public String teamMemDelete(@RequestParam Map<String, Object> param, Model model) throws Exception {
    logger.info("teamMemDelete");
    int chk = this.mainService.teamMemDelete(param);
    return "Y";
  }
  
  @RequestMapping(value = {"/selectProject.do"}, produces = {"text/plain;charset=UTF-8"})
  @ResponseBody
  public String selectProject(ProjectVO projectVO, Map<String, Object> map) throws Exception {
    logger.info("selectProject");
    List<ProjectVO> rs = this.mainService.selectProject();
    Gson gson = new Gson();
    return gson.toJson(rs);
  }
  
  @RequestMapping(value = {"/teamList.do"}, produces = {"text/plain;charset=UTF-8"})
  @ResponseBody
  public String teamList(@RequestParam Map<String, Object> map) throws Exception {
    logger.info("selectProject");
    List<ProjectVO> rs = this.mainService.teamList(map);
    System.out.println("===========================================");
    System.out.println(map.get("no"));
    System.out.println("===========================================");
    Gson gson = new Gson();
    return gson.toJson(rs);
  }
  
  @RequestMapping(value = {"/mainPage.do"}, method = {RequestMethod.GET})
  public String r_Notice_001(Model model) throws Exception {
    logger.info("list");
    model.addAttribute("list", this.mainService.r_Notice_001());
    return "index";
  }
  
  @RequestMapping(value = {"/Company.do"}, method = {RequestMethod.GET})
  public String Company() throws Exception {
    logger.info("Company");
    return "Company";
  }
  
  @RequestMapping(value = {"/Recruit.do"}, method = {RequestMethod.GET})
  public String Recruit() throws Exception {
    logger.info("Recruit");
    return "Recruit";
  }
  
  @RequestMapping({"/noticeList.do"})
  public String noticeList(@RequestParam Map<String, Object> map, Model model) throws Exception {
    logger.info("noticeList");
    List<Map<String, Object>> rsList = null;
    int rsListCnt = 0;
    int page = 0;
    int countList = 10;
    int countPage = 10;
    int totalCount = 0;
    int totalPage = 0;
    int lastPage = 0;
    String strPage = (String)map.get("page");
    if (!map.containsKey("page")) {
      map.put("page", Integer.valueOf(0));
      page = 1;
    } else {
      page = Integer.parseInt(strPage);
      map.put("page", Integer.valueOf(page * 10 - 10));
    } 
    rsList = this.mainService.noticesList(map);
    rsListCnt = this.mainService.noticeListCnt();
    totalCount = rsListCnt;
    totalPage = totalCount / countList;
    if (totalCount % countList > 0)
      totalPage++; 
    if (totalPage < page)
      page = totalPage; 
    int startPage = (page - 1) / 10 * 10 + 1;
    int endPage = startPage + countPage - 1;
    if (endPage > totalPage)
      endPage = totalPage; 
    lastPage = (int)Math.ceil(rsListCnt / countList);
    model.addAttribute("page", Integer.valueOf(page));
    model.addAttribute("startPage", Integer.valueOf(startPage));
    model.addAttribute("endPage", Integer.valueOf(endPage));
    model.addAttribute("lastPage", Integer.valueOf(lastPage));
    model.addAttribute("rsList", rsList);
    model.addAttribute("rsListCnt", Integer.valueOf(rsListCnt));
    return "noticeList";
  }
  
  @RequestMapping({"/noticeDetail.do"})
  public ModelAndView noticesDetail(@RequestParam Map<String, Object> map, Model model) throws Exception {
    logger.info("noticesDetail");
    Map<String, Object> rsMap = new HashMap<>();
    rsMap = this.mainService.noticeDetail(map);
    ModelAndView mav = new ModelAndView();
    mav.addObject("rsMap", rsMap);
    mav.setViewName("notice_detail");
    return mav;
  }
  
  @RequestMapping({"/noticeWrite.do"})
  public ModelAndView noticeWrite(@RequestParam Map<String, Object> map, Model model) throws Exception {
    logger.info("noticeWrite");
    Map<String, Object> rsMap = new HashMap<>();
    String check = "";
    if (map.containsKey("check")) {
      check = "UPDATE";
      rsMap = this.mainService.noticeDetail(map);
    } else {
      check = "INSERT";
    } 
    ModelAndView mav = new ModelAndView();
    mav.addObject("check", check);
    mav.addObject("rsMap", rsMap);
    mav.setViewName("notice_write");
    return mav;
  }
  
  @RequestMapping(value = {"/noticeIns.do"}, method = {RequestMethod.POST})
  @ResponseBody
  public String r_Notice_004(@RequestParam Map<String, Object> map, HttpServletRequest req) throws Exception {
    logger.info("noticesIns");
    HttpSession session = req.getSession();
    LoginVO loginVo = (LoginVO)session.getAttribute("login");
    map.put("sessionId", loginVo.getIn_id());
    map.put("sessionName", loginVo.getMb_name());
    int rs = this.mainService.noticeIns(map);
    return (rs != 0) ? "Y" : "N";
  }
  
  @RequestMapping(value = {"/Business_outline.do"}, method = {RequestMethod.GET})
  public String Business_outline() throws Exception {
    logger.info("Business_outline");
    return "Business_outline";
  }
  
  @RequestMapping(value = {"/Business_consulting.do"}, method = {RequestMethod.GET})
  public String Business_consulting() throws Exception {
    logger.info("Business_consulting");
    return "Business_consulting";
  }
  
  @RequestMapping(value = {"/Business_service.do"}, method = {RequestMethod.GET})
  public String Business_service() throws Exception {
    logger.info("Business_service");
    return "Business_service";
  }
  
  @RequestMapping(value = {"/Business_solution.do"}, method = {RequestMethod.GET})
  public String Business_solution() throws Exception {
    logger.info("Business_solution");
    return "Business_solution";
  }
  
  @RequestMapping(value = {"/Project_actual.do"}, method = {RequestMethod.GET})
  public String r_Project_001(Model model) throws Exception {
    logger.info("Project_actual");
    model.addAttribute("projectList", this.mainService.r_General_001());
    model.addAttribute("listTotal", this.mainService.r_Project_001());
    model.addAttribute("listMainten", this.mainService.r_Maintenance_001());
    model.addAttribute("public_sector", this.mainService.r_Public_001());
    return "Project_actual";
  }
  
  @RequestMapping(value = {"/go_Login.do"}, method = {RequestMethod.GET})
  public String Login() throws Exception {
    return "Login";
  }
  
  @RequestMapping(value = {"/Business_outline_tailesTest.do"}, method = {RequestMethod.GET})
  public String Business_outline_tailesTest() throws Exception {
    logger.info("Business_outline_tailesTest");
    return "Business_outline_tailesTest.view1";
  }
  
  @RequestMapping({"/Member_sel.do"})
  public String Member_sel(@RequestParam Map<String, Object> map, Model model) throws Exception {
    logger.info("Member_sel");
    List<LoginVO> rsList = null;
    int rsListCnt = 0;
    int page = 0;
    int countList = 10;
    int countPage = 10;
    int totalCount = 0;
    int totalPage = 0;
    int lastPage = 0;
    String strPage = (String)map.get("page");
    if (!map.containsKey("page")) {
      map.put("page", Integer.valueOf(0));
      page = 1;
    } else {
      page = Integer.parseInt(strPage);
      map.put("page", Integer.valueOf(page * 10 - 10));
    } 
    rsList = this.mainService.member_sel(map);
    rsListCnt = this.mainService.member_selCnt(map);
    totalCount = rsListCnt;
    totalPage = totalCount / countList;
    if (totalCount % countList > 0)
      totalPage++; 
    if (totalPage < page)
      page = totalPage; 
    int startPage = (page - 1) / 10 * 10 + 1;
    int endPage = startPage + countPage - 1;
    if (endPage > totalPage)
      endPage = totalPage; 
    lastPage = (int)Math.ceil(rsListCnt / countList);
    model.addAttribute("page", Integer.valueOf(page));
    model.addAttribute("startPage", Integer.valueOf(startPage));
    model.addAttribute("endPage", Integer.valueOf(endPage));
    model.addAttribute("lastPage", Integer.valueOf(lastPage));
    model.addAttribute("rsList", rsList);
    model.addAttribute("rsListCnt", Integer.valueOf(rsListCnt));
    return "Member_sel";
  }
  
  @RequestMapping({"/Member_newIns.do"})
  public String Member_newIns(@RequestParam Map<String, Object> map, Model model) throws Exception {
    logger.info("Member_newIns");
    return "Member_newIns";
  }
  
  @RequestMapping({"/Member_upd.do"})
  public String Member_upd(@RequestParam Map<String, Object> map, Model model) throws Exception {
    logger.info("Member_upd");
    LoginVO loginVo = null;
    loginVo = this.mainService.member_detailSel(map);
    model.addAttribute("map", loginVo);
    return "Member_upd";
  }
  
  @RequestMapping({"/Member_user.do"})
  public String Member_user(@RequestParam Map<String, Object> map, Model model, HttpServletRequest req) throws Exception {
    logger.info("Member_ins");
    String usrid = "";
    LoginVO loginVo = null;
    HttpSession session = req.getSession();
    usrid = (String)session.getAttribute("usrid");
    map.put("mb_id", usrid);
    loginVo = this.mainService.member_detailSel(map);
    session.setAttribute("pw_chk", loginVo.getMb_pw_chk());
    model.addAttribute("map", loginVo);
    return "Member_user";
  }
  
  @RequestMapping(value = {"/Member_save.do"}, method = {RequestMethod.POST})
  @ResponseBody
  public String Member_save(@ModelAttribute("loginVo") LoginVO loginVo, HttpServletRequest req) throws Exception {
    logger.info("Member_save");
    String rs = "";
    rs = this.mainService.member_save(loginVo);
    HttpSession session = null;
    if ("2".equals(loginVo.getGubun()) && "Y".equals(rs) && !"".equals(loginVo.getMb_password())) {
      loginVo.setIn_id(loginVo.getMb_id());
      loginVo.setIn_pw(loginVo.getMb_password());
      LoginVO login = this.loginService.login(loginVo);
      session = req.getSession(true);
      session.setAttribute("login", login);
      session.setAttribute("usrid", login.getMb_id());
      session.setAttribute("usrlvl", Integer.valueOf(login.getMb_level()));
      session.setAttribute("loginYn", "Y");
      session.setAttribute("pw_chk", login.getMb_pw_chk());
      session.setAttribute("projectPlYn", login.getMb_projectPlYn());
      session.setAttribute("projectNo", Integer.valueOf(login.getMb_projectNo()));
    } 
    return rs;
  }
  
  @RequestMapping(value = {"/Member_pwdInit.do"}, method = {RequestMethod.POST})
  @ResponseBody
  public String Member_pwdInit(@ModelAttribute("loginVo") LoginVO loginVo) throws Exception {
    logger.info("Member_reSetPwd");
    int rs = this.mainService.member_password_init(loginVo);
    return (rs == 0) ? "N" : "Y";
  }
  
  @RequestMapping({"/Comm_code.do"})
  public String Comm_code(@RequestParam Map<String, Object> map, Model model) throws Exception {
    logger.info("Comm_code.do");
    return "Comm_code";
  }
  
  @RequestMapping(value = {"/Comm_codeList.do"}, method = {RequestMethod.POST})
  @ResponseBody
  public List<Map<String, Object>> Comm_codeList(@RequestParam Map<String, Object> map) throws Exception {
    logger.info("Comm_codeList");
    return this.mainService.Comm_codeList(map);
  }
  
  @RequestMapping(value = {"/Comm_codeDetail.do"}, method = {RequestMethod.POST})
  @ResponseBody
  public List<Map<String, Object>> Comm_codeDetail(@RequestParam Map<String, Object> map) throws Exception {
    logger.info("Comm_codeDetail");
    return this.mainService.Comm_codeDetail(map);
  }
  
  @RequestMapping(value = {"/Comm_codeCud.do"}, method = {RequestMethod.POST})
  @ResponseBody
  public String Comm_codeCud(@RequestParam MultiValueMap<String, String> params, HttpServletRequest request) throws Exception {
    logger.info("Comm_codeCud");
    Map<String, Object> map = new HashMap<>();
    Map<String, Object> rs = new HashMap<>();
    Enumeration<String> enums = request.getParameterNames();
    while (enums.hasMoreElements()) {
      String paramName = enums.nextElement();
      String[] parameters = request.getParameterValues(paramName);
      if (parameters.length > 1) {
        List<Object> parmList = new ArrayList();
        for (int i = 0; i < parameters.length; i++)
          parmList.add(parmList.size(), parameters[i]); 
        map.put(paramName, parmList);
        continue;
      } 
      map.put(paramName, parameters[0]);
    } 
    this.mainService.Comm_codeCud(map);
    return "Y";
  }
  
  @RequestMapping(value = {"/Doollee_prod_main.do"}, method = {RequestMethod.GET})
  public ModelAndView Doollee_prod_info() throws Exception {
    logger.info("Doollee_prod_main");
    ModelAndView mav = new ModelAndView();
    Map<String, String> param = new HashMap<>();
    List<Map<String, Object>> prod_gbn_list = new ArrayList<>();
    param.put("simp_tpc", "PROD_GBN");
    param.put("attr_1", "");
    prod_gbn_list = this.mainService.selectCommList(param);
    List<Map<String, Object>> prod_sts_list = new ArrayList<>();
    param.put("simp_tpc", "PROD_STS");
    param.put("attr_1", "");
    prod_sts_list = this.mainService.selectCommList(param);
    mav.addObject("prod_gbn_list", prod_gbn_list);
    mav.addObject("prod_sts_list", prod_sts_list);
    mav.setViewName("Doollee_prod_main");
    return mav;
  }
  
  @RequestMapping(value = {"/Doollee_prod_main_app.do"}, method = {RequestMethod.GET})
  public ModelAndView Doollee_prod_main_app() throws Exception {
    logger.info("Doollee_prod_main_app");
    ModelAndView mav = new ModelAndView();
    Map<String, String> param = new HashMap<>();
    List<Map<String, Object>> prod_gbn_list = new ArrayList<>();
    param.put("simp_tpc", "PROD_GBN");
    param.put("attr_1", "");
    prod_gbn_list = this.mainService.selectCommList(param);
    List<Map<String, Object>> prod_sts_list = new ArrayList<>();
    param.put("simp_tpc", "PROD_STS");
    param.put("attr_1", "");
    prod_sts_list = this.mainService.selectCommList(param);
    mav.addObject("prod_gbn_list", prod_gbn_list);
    mav.addObject("prod_sts_list", prod_sts_list);
    mav.setViewName("Doollee_prod_main_app.view2");
    return mav;
  }
  
  @RequestMapping({"/selectProdInfo.do"})
  public ModelAndView selectProdInfo(@RequestParam Map<String, Object> map, Model model, HttpServletRequest req) throws Exception {
    logger.info("selectProdInfo");
    ModelAndView mav     = new ModelAndView();
    HttpSession  session = req.getSession();
    LoginVO      loginVo = (LoginVO)session.getAttribute("login");
    
    if(null == loginVo) {
        mav.setViewName("Login");
        return mav;
    }
    
    model.addAttribute("prodList", this.mainService.selectProdInfo(map));
    mav.setViewName("Doollee_prod_list");
    return mav;
  }
  
  @RequestMapping({"/selectProdInfoApp.do"})
  public ModelAndView selectProdInfoApp(@RequestParam Map<String, Object> map, Model model, HttpServletRequest req) throws Exception {
    logger.info("selectProdInfoApp");
    ModelAndView mav     = new ModelAndView();
    HttpSession  session = req.getSession();
    LoginVO      loginVo = (LoginVO)session.getAttribute("login");
    
    if(null == loginVo) {
        mav.setViewName("Login");
        return mav;
    }
    
    model.addAttribute("prodList", this.mainService.selectProdInfo(map));
    mav.setViewName("Doollee_prod_list_app");
    return mav;
  }
  
  @RequestMapping(value = {"/prodInfoReg.do"}, method = {RequestMethod.POST})
  public ModelAndView prodInfoReg(HttpServletRequest req) throws Exception {
    logger.info("prodInfoReg");
    ModelAndView        mav     = new ModelAndView();
    Map<String, String> param   = new HashMap<>();
    HttpSession         session = req.getSession();
    LoginVO             loginVo = (LoginVO)session.getAttribute("login");
    
    if(null == loginVo) {
        mav.setViewName("Login");
        return mav;
    }
    
    //장비구분 selectbox 내용조회
    List<Map<String, Object>> prod_gbn_list = new ArrayList<>();
    param.put("simp_tpc", "PROD_GBN");
    param.put("attr_1", "");
    prod_gbn_list = this.mainService.selectCommList(param);
    
    //장비상태 selectbox 내용조회
    List<Map<String, Object>> prod_sts_list = new ArrayList<>();
    param.put("simp_tpc", "PROD_STS");
    param.put("attr_1", "");
    prod_sts_list = this.mainService.selectCommList(param);
    
    mav.addObject("prod_gbn_list", prod_gbn_list);
    mav.addObject("prod_sts_list", prod_sts_list);
    mav.addObject("modal_title", "신규등록");
    mav.setViewName("Doollee_prod_regPop");
    
    return mav;
  }
  
  @RequestMapping(value = {"/Doollee_repair_main.do"}, method = {RequestMethod.GET})
  public ModelAndView Doollee_prod_repair() throws Exception {
    logger.info("Doollee_repair_main");
    ModelAndView mav = new ModelAndView();
    Map<String, String> param = new HashMap<>();
    List<Map<String, Object>> prod_gbn_list = new ArrayList<>();
    param.put("simp_tpc", "PROD_GBN");
    param.put("attr_1", "");
    prod_gbn_list = this.mainService.selectCommList(param);
    List<Map<String, Object>> prod_sts_list = new ArrayList<>();
    param.put("simp_tpc", "PROD_STS");
    param.put("attr_1", "");
    prod_sts_list = this.mainService.selectCommList(param);
    mav.addObject("prod_gbn_list", prod_gbn_list);
    mav.addObject("prod_sts_list", prod_sts_list);
    mav.setViewName("Doollee_repair_main");
    return mav;
  }
  
  @RequestMapping({"/selectProdRepair.do"})
  public ModelAndView selectProdReapair(@RequestParam Map<String, Object> map, Model model) throws Exception {
    logger.info("selectProdRepair");
    ModelAndView mav = new ModelAndView();
    model.addAttribute("repairList", this.mainService.selectProdRepair(map));
    mav.setViewName("Doollee_repair_list");
    return mav;
  }
  
  @RequestMapping(value = {"/Doolllee_repair_popup.do"}, method = {RequestMethod.GET})
  public ModelAndView DoollleeRepairPopup() throws Exception {
    logger.info("prod_repair_view");
    ModelAndView mav = new ModelAndView();
    Map<String, String> param = new HashMap<>();
    List<Map<String, Object>> prod_gbn_list = new ArrayList<>();
    param.put("simp_tpc", "PROD_GBN");
    param.put("attr_1", "");
    prod_gbn_list = this.mainService.selectCommList(param);
    List<Map<String, Object>> prod_sts_list = new ArrayList<>();
    param.put("simp_tpc", "PROD_STS");
    param.put("attr_1", "");
    prod_sts_list = this.mainService.selectCommList(param);
    mav.addObject("prod_gbn_list", prod_gbn_list);
    mav.addObject("prod_sts_list", prod_sts_list);
    mav.setViewName("Doollee_repair_popup");
    return mav;
  }

  @RequestMapping(value = {"/insertProdInfo.do"}, method = {RequestMethod.POST})
  @ResponseBody
  public Map<String, Object> insertProdInfo(@RequestParam Map<String, Object> map, HttpServletRequest req) {
    logger.info("insertProdInfo");
        
    String errorTest = "";
    try {
        HttpSession session = req.getSession();
        LoginVO     loginVo = (LoginVO)session.getAttribute("login");
        if(null == loginVo) {
            map.put("errorTest", "sessionOut");
            return map;
        }
        if( "insert".equals(map.get("status")) ) this.mainService.insertProdInfo(map);
        else                                     this.mainService.updateProdInfo(map);
    } catch(Exception e) {
        errorTest = e.getMessage();
    }
    map.put("errorTest", errorTest);
    
    return map ;
  }
  
  @RequestMapping({"/prodSelPop.do"})
  public ModelAndView prodSelPop(@RequestParam Map<String, Object> map, Model model) throws Exception {
    logger.info("prodSelPop");
    ModelAndView mav = new ModelAndView();
    Map<String, String> param = new HashMap<>();
    List<Map<String, Object>> prod_gbn_list = new ArrayList<>();
    param.put("simp_tpc", "PROD_GBN");
    if (map.containsKey("attr_1")) {
      param.put("attr_1", map.get("attr_1").toString());
    } else {
      param.put("attr_1", "");
    } 
    prod_gbn_list = this.mainService.selectCommList(param);
    List<Map<String, Object>> prod_sts_list = new ArrayList<>();
    param.put("simp_tpc", "PROD_STS");
    param.put("attr_1", "");
    prod_sts_list = this.mainService.selectCommList(param);
    mav.addObject("prod_gbn_list", prod_gbn_list);
    mav.addObject("prod_sts_list", prod_sts_list);
    Set<Map.Entry<String, Object>> entries = map.entrySet();
    for (Map.Entry<String, Object> entry : entries) {
      mav.addObject(entry.getKey(), entry.getValue());
      System.out.println(String.valueOf(entry.getKey()) + " :(prodSelPop) " + entry.getValue());
    } 
    mav.setViewName("Doollee_prod_selPopMain");
    return mav;
  }
  
  @RequestMapping({"/selectProdInfoPop.do"})
  public ModelAndView selectProdInfoPop(@RequestParam Map<String, Object> map, Model model) throws Exception {
    logger.info("selectProdInfoPop");
    ModelAndView mav = new ModelAndView();
    model.addAttribute("prodList", this.mainService.selectProdInfo(map));
    mav.setViewName("Doollee_prod_selPopList");
    return mav;
  }
  
  @RequestMapping({"/userPop.do"})
  public ModelAndView userPop(@RequestParam Map<String, Object> map, Model model) throws Exception {
    logger.info("Doollee_user_selPop");
    ModelAndView mav = new ModelAndView();
    if (!"".equals(map.get("gubun")))
      mav.addObject("gubun", map.get("gubun")); 
    mav.setViewName("Doollee_user_popMain");
    return mav;
  }
  
  @RequestMapping({"/selectUserPop.do"})
  public ModelAndView selectUserPop(@RequestParam Map<String, Object> map, Model model) throws Exception {
    logger.info("Doollee_user_listPop");
    ModelAndView mav = new ModelAndView();
    model.addAttribute("usrList", this.mainService.selectUserList(map));
    mav.setViewName("Doollee_user_popList");
    return mav;
  }
  
  @RequestMapping(value = {"/prodInfoUpd.do"}, method = {RequestMethod.POST})
  public ModelAndView prodInfoupd(@RequestParam Map<String, Object> map, Model model, HttpServletRequest req) throws Exception {
    logger.info("prodInfoUpd");
    
    ModelAndView        mav     = new ModelAndView();
    Map<String, String> param   = new HashMap<>();
    HttpSession         session = req.getSession();
    LoginVO             loginVo = (LoginVO)session.getAttribute("login");
    
    if(null == loginVo) {
        mav.setViewName("Login");
        return mav;
    }

    //제품구분 selectbox 내용 조회
    List<Map<String, Object>> prod_gbn_list = new ArrayList<>();
    param.put("simp_tpc", "PROD_GBN");
    param.put("attr_1", "");
    prod_gbn_list = this.mainService.selectCommList(param);
    
    //장비상태 selectbox 내용 조회
    List<Map<String, Object>> prod_sts_list = new ArrayList<>();
    param.put("simp_tpc", "PROD_STS");
    param.put("attr_1", "");
    prod_sts_list = this.mainService.selectCommList(param);
    
    //장비관리 선택 내용 조회
    List<Map<String, Object>> prodList = this.mainService.selectProdInfo(map);
    Map<String, Object>       prodMap  = prodList.get(0) ;
    
    mav.addObject("prod_gbn_list", prod_gbn_list);
    mav.addObject("prod_sts_list", prod_sts_list);
    mav.addObject("modal_title"  , "정보수정"      );
    
    Set<Map.Entry<String, Object>> entries = prodMap.entrySet();
    for (Map.Entry<String, Object> entry : entries) mav.addObject(entry.getKey(), entry.getValue()); 
    
    mav.setViewName("Doollee_prod_regPop");
    return mav;
  }
  
  @RequestMapping(value = {"/prodRepairReg.do"}, method = {RequestMethod.POST})
  public ModelAndView prodRepairReg() throws Exception {
    logger.info("prodRepairReg");
    ModelAndView mav = new ModelAndView();
    Map<String, String> param = new HashMap<>();
    List<Map<String, Object>> repair_gbn_list = new ArrayList<>();
    param.put("simp_tpc", "REPAIR_GBN");
    param.put("attr_1", "");
    repair_gbn_list = this.mainService.selectCommList(param);
    mav.addObject("repair_gbn_list", repair_gbn_list);
    mav.addObject("modal_title", "신규등록");
    mav.setViewName("Doollee_repair_regPop");
    return mav;
  }
  
  @RequestMapping(value = {"/insertProdRepair.do"}, method = {RequestMethod.POST})
  public ModelAndView insertProdRepair(@RequestParam Map<String, Object> map, Model model) throws Exception {
    logger.info("insertProdRepair");
    ModelAndView mav = new ModelAndView();
    Set<Map.Entry<String, Object>> entries = map.entrySet();
    for (Map.Entry<String, Object> entry : entries)
      mav.addObject(entry.getKey(), entry.getValue()); 
    this.mainService.insertProdRepair(map);
    this.mainService.updateProdSts(map);
    mav.setViewName("Doollee_repair_main");
    return mav;
  }
  
  @RequestMapping(value = {"/prodRepairUpd.do"}, method = {RequestMethod.POST})
  public ModelAndView prodRepairUpd(@RequestParam Map<String, String> map, Model model) throws Exception {
    logger.info("prodRepairUpd");
    ModelAndView mav = new ModelAndView();
    Map<String, String> param = new HashMap<>();
    List<Map<String, Object>> repair_gbn_list = new ArrayList<>();
    param.put("simp_tpc", "REPAIR_GBN");
    param.put("attr_1", "");
    repair_gbn_list = this.mainService.selectCommList(param);
    mav.addObject("repair_gbn_list", repair_gbn_list);
    mav.addObject("modal_title", "정보수정");
    Set<Map.Entry<String, String>> entries = map.entrySet();
    for (Map.Entry<String, String> entry : entries)
      mav.addObject(entry.getKey(), entry.getValue()); 
    mav.setViewName("Doollee_repair_regPop");
    return mav;
  }
  
  @RequestMapping(value = {"/updateProdRepair.do"}, method = {RequestMethod.POST})
  public ModelAndView updateProdRepair(@RequestParam Map<String, Object> map, Model model) throws Exception {
    logger.info("updateProdRepair");
    ModelAndView mav = new ModelAndView();
    Set<Map.Entry<String, Object>> entries = map.entrySet();
    for (Map.Entry<String, Object> entry : entries)
      mav.addObject(entry.getKey(), entry.getValue()); 
    this.mainService.updateProdRepair(map);
    this.mainService.updateProdSts(map);
    mav.setViewName("Doollee_repair_main");
    return mav;
  }
  
  @RequestMapping(value = {"/updateYnRepair.do"}, method = {RequestMethod.POST})
  public ModelAndView updateYnProdRepair(@RequestParam Map<String, Object> map, Model model) throws Exception {
    logger.info("updateYnRepair");
    ModelAndView mav = new ModelAndView();
    this.mainService.updateYnProdRepair(map);
    mav.setViewName("Doollee_repair_main");
    return mav;
  }
  
  @RequestMapping(value = {"/Doollee_trans_main.do"}, method = {RequestMethod.GET})
  public ModelAndView Doollee_trans_main() throws Exception {
    logger.info("Doollee_trans_main");
    ModelAndView mav = new ModelAndView();
    Map<String, String> param = new HashMap<>();
    List<Map<String, Object>> trans_gbn_list = new ArrayList<>();
    param.put("simp_tpc", "TRANS_GBN");
    param.put("attr_1", "");
    trans_gbn_list = this.mainService.selectCommList(param);
    List<Map<String, Object>> take_sts_list = new ArrayList<>();
    param.put("simp_tpc", "TAKE_STS");
    param.put("attr_1", "");
    take_sts_list = this.mainService.selectCommList(param);
    List<Map<String, Object>> project_gbn_list = new ArrayList<>();
    param.put("simp_tpc", "PROJECT_GBN");
    param.put("attr_1", "");
    project_gbn_list = this.mainService.selectCommList(param);
    mav.addObject("trans_gbn_list", trans_gbn_list);
    mav.addObject("take_sts_list", take_sts_list);
    mav.addObject("project_gbn_list", project_gbn_list);
    mav.setViewName("Doollee_trans_main");
    return mav;
  }
  
  @RequestMapping(value = {"/selectProdTrans.do"}, method = {RequestMethod.POST})
  public ModelAndView selectProdTrans(@RequestParam Map<String, Object> map, Model model) throws Exception {
    logger.info("selectProdTrans");
    ModelAndView mav = new ModelAndView();
    mav.addObject("transList", this.mainService.selectProdTrans(map));
    mav.setViewName("Doollee_trans_list");
    return mav;
  }
  
  @RequestMapping(value = {"/prodTransReg.do"}, method = {RequestMethod.POST})
  public ModelAndView Doollee_trans_regPop() throws Exception {
    logger.info("prodTransReg");
    ModelAndView mav = new ModelAndView();
    Map<String, String> param = new HashMap<>();
    List<Map<String, Object>> trans_gbn_list = new ArrayList<>();
    param.put("simp_tpc", "TRANS_GBN");
    param.put("attr_1", "");
    trans_gbn_list = this.mainService.selectCommList(param);
    List<Map<String, Object>> take_sts_list = new ArrayList<>();
    param.put("simp_tpc", "TAKE_STS");
    param.put("attr_1", "");
    take_sts_list = this.mainService.selectCommList(param);
    List<Map<String, Object>> project_gbn_list = new ArrayList<>();
    param.put("simp_tpc", "PROJECT_GBN");
    param.put("attr_1", "");
    project_gbn_list = this.mainService.selectCommList(param);
    mav.addObject("trans_gbn_list", trans_gbn_list);
    mav.addObject("take_sts_list", take_sts_list);
    mav.addObject("project_gbn_list", project_gbn_list);
    mav.addObject("modal_title", "인수/인계 신규등록");
    mav.setViewName("Doollee_trans_regPop");
    return mav;
  }
  
  @RequestMapping(value = {"/prodTransUpd.do"}, method = {RequestMethod.POST})
  public ModelAndView Doollee_trans_UpdPop(@RequestParam Map<String, String> map, Model model) throws Exception {
    logger.info("prodTransUpd");
    ModelAndView mav = new ModelAndView();
    Map<String, String> param = new HashMap<>();
    List<Map<String, Object>> trans_gbn_list = new ArrayList<>();
    param.put("simp_tpc", "TRANS_GBN");
    param.put("attr_1", "");
    trans_gbn_list = this.mainService.selectCommList(param);
    List<Map<String, Object>> take_sts_list = new ArrayList<>();
    param.put("simp_tpc", "TAKE_STS");
    param.put("attr_1", "");
    take_sts_list = this.mainService.selectCommList(param);
    List<Map<String, Object>> project_gbn_list = new ArrayList<>();
    param.put("simp_tpc", "PROJECT_GBN");
    param.put("attr_1", "");
    project_gbn_list = this.mainService.selectCommList(param);
    Set<Map.Entry<String, String>> entries = map.entrySet();
    for (Map.Entry<String, String> entry : entries) {
      mav.addObject(entry.getKey(), entry.getValue());
      System.out.println(String.valueOf(entry.getKey()) + " :(TransPop) " + (String)entry.getValue());
    } 
    mav.addObject("trans_gbn_list", trans_gbn_list);
    mav.addObject("take_sts_list", take_sts_list);
    mav.addObject("project_gbn_list", project_gbn_list);
    mav.addObject("modal_title", "인수/인계 정보수정");
    mav.setViewName("Doollee_trans_regPop");
    return mav;
  }
  
  @RequestMapping(value = {"/insertTransTake.do"}, method = {RequestMethod.POST})
  public ModelAndView insertTransTake(@RequestParam Map<String, Object> map, Model model) throws Exception {
    logger.info("insertTransTake");
    ModelAndView mav = new ModelAndView();
    mav = this.mainService.insertTransTake(map);
    mav.setViewName("Doollee_trans_main");
    return mav;
  }
  
  @RequestMapping(value = {"/updateTransTake.do"}, method = {RequestMethod.POST})
  public ModelAndView updateTransTake(@RequestParam Map<String, Object> map, Model model) throws Exception {
    logger.info("updateTransTake");
    ModelAndView mav = new ModelAndView();
    Set<Map.Entry<String, Object>> entries = map.entrySet();
    for (Map.Entry<String, Object> entry : entries) {
      mav.addObject(entry.getKey(), entry.getValue());
      System.out.println(String.valueOf(entry.getKey()) + " ::(update) " + entry.getValue());
    } 
    this.mainService.updateTransTake(map);
    this.mainService.updateTransProdSts(map);
    mav.setViewName("Doollee_trans_main");
    return mav;
  }
  
  @RequestMapping(value = {"/updateYnTransTake.do"}, method = {RequestMethod.POST})
  public ModelAndView updateYnTransTake(@RequestParam Map<String, Object> map, Model model) throws Exception {
    logger.info("updateYnTransTake");
    ModelAndView mav = new ModelAndView();
    this.mainService.updateYnTransTake(map);
    mav.setViewName("Doollee_trans_main");
    return mav;
  }
  
  @RequestMapping(value = {"/Doollee_holi_main.do"}, method = {RequestMethod.GET})
  public ModelAndView Doollee_holi_main(HttpServletRequest req) throws Exception {
    logger.info("Doollee_holi_main");
    ModelAndView              mav           = new ModelAndView();
    Map<String, String>       param         = new HashMap<>();
    List<Map<String, Object>> holi_gbn_list = new ArrayList<>();
    HttpSession               session       = req.getSession();
    LoginVO                   loginVo       = (LoginVO)session.getAttribute("login");

    if(null == loginVo) {
        mav.setViewName("Login");
        return mav;
    }
    
    param.put("simp_tpc", "VACA_GBN");
    param.put("attr_1", "");
    holi_gbn_list = this.mainService.selectCommList(param);
    
    List<Map<String, Object>> holi_sts_list = new ArrayList<>();
    param.put("simp_tpc", "REQ_GBN");
    param.put("attr_1", "");
    holi_sts_list = this.mainService.selectCommList(param);

    mav.addObject("holi_gbn_list", holi_gbn_list);
    mav.addObject("holi_sts_list", holi_sts_list);
    mav.setViewName("Doollee_holi_main");
    return mav;
  }
  
  @RequestMapping({"/selectHoliInfo.do"})
  public ModelAndView selectHoliInfo(@RequestParam Map<String, Object> map, HttpServletRequest req, Model model) throws Exception {
    logger.info("selectHoliInfo");
    HttpSession  session = req.getSession();
    LoginVO      loginVo = (LoginVO)session.getAttribute("login");
    ModelAndView mav     = new ModelAndView();
    
    if( loginVo == null ) map.put("mb_id", "");
    else                  map.put("mb_id", loginVo.getMb_id());
    
    //마스터관리자(마스터승인자) 여부 (여:1 부:0)
    map.put("masterYn", this.mainService.selectApporoverMasterYn(map));
    
    List<Map<String, Object>> selList = this.mainService.selectHoliRegInfo(map);
    model.addAttribute("holiList", selList.size()==0 ? "" : selList);
    mav.setViewName("Doollee_holi_list");
    return mav;
  }
  
  @RequestMapping(value = {"/deleteHoliRegInfo.do"}, method = {RequestMethod.POST})
  @ResponseBody
  public Map<String, Object> deleteHoliRegInfo(@RequestParam Map<String, Object> map, HttpServletRequest req) {
      logger.info("deleteHoliInfo");
  
      String errorTest = "";
      try {
          HttpSession session = req.getSession();
          LoginVO     loginVo = (LoginVO)session.getAttribute("login");
          
          if(null == loginVo) {
        	  errorTest = "sessionOut";
          } else {
              this.mainService.deleteHoliRegInfo(map);
          }
      
      } catch(Exception e) {
          errorTest = e.getMessage();
      }
  
      map.put("errorTest", errorTest);
      return map;
  }
  
  @RequestMapping({"/callProjectPop.do"})
  public ModelAndView callProjectPop(@RequestParam Map<String, Object> map, Model model) throws Exception {
    logger.info("callProjectPop");
    ModelAndView mav = new ModelAndView();
    mav.setViewName("Doollee_project_popMain");
    return mav;
  }
  
  @RequestMapping({"/selectProjectList.do"})
  public ModelAndView selectProjectList(@RequestParam Map<String, Object> map, Model model) throws Exception {
    logger.info("selectProjectList");
    ModelAndView mav = new ModelAndView();
    model.addAttribute("projectList", this.mainService.selectProjectList(map));
    mav.setViewName("Doollee_project_popList");
    return mav;
  }
  
  @RequestMapping(value = {"/Doollee_holi_main_app.do"}, method = {RequestMethod.GET})
  public ModelAndView Doollee_holi_main_app(HttpServletRequest req) throws Exception {
    logger.info("Doollee_holi_main_app");
    ModelAndView              mav           = new ModelAndView();
    Map<String, String>       param         = new HashMap<>();
    List<Map<String, Object>> holi_gbn_list = new ArrayList<>();
    HttpSession               session       = req.getSession();
    LoginVO                   loginVo       = (LoginVO)session.getAttribute("login");
    
    if(null == loginVo) {
    	mav.setViewName("Login");
        return mav;
    }
    
    param.put("simp_tpc", "VACA_GBN");
    param.put("attr_1", "");
    holi_gbn_list = this.mainService.selectCommList(param);
    
    List<Map<String, Object>> holi_sts_list = new ArrayList<>();
    param.put("simp_tpc", "REQ_GBN");
    param.put("attr_1", "");
    holi_sts_list = this.mainService.selectCommList(param);
    
    mav.addObject("holi_gbn_list", holi_gbn_list);
    mav.addObject("holi_sts_list", holi_sts_list);
    mav.addObject("login_level"  , Integer.valueOf(loginVo.getMb_level()));
    mav.addObject("req_id"       , loginVo.getMb_id());
    mav.setViewName("Doollee_holi_main_app.view2");
    return mav;
  }
  
  @SuppressWarnings("unused")
  @RequestMapping({"/selectHoliInfoApp.do"})
  public ModelAndView selectHoliInfoApp(@RequestParam Map<String, Object> map, HttpServletRequest req, Model model) throws Exception {
    logger.info("selectHoliInfoApp");
    HttpSession               session = req.getSession();
    LoginVO                   loginVo = (LoginVO)session.getAttribute("login");
    ModelAndView              mav     = new ModelAndView();
    
    if( loginVo == null ) map.put("mb_id", "");
    else                  map.put("mb_id", loginVo.getMb_id());
    
    //마스터관리자(마스터승인자) 여부 (여:1 부:0)
    map.put("masterYn", this.mainService.selectApporoverMasterYn(map));
    
    List<Map<String, Object>> selList = this.mainService.selectHoliRegInfo(map);
    model.addAttribute("holiList"   , selList.size()==0 ? "" : selList);
    mav.setViewName("Doollee_holi_list_app");
    
    return mav;
  }
  
  @RequestMapping(value = {"/holiInfoRegApp.do"}, method = {RequestMethod.POST})
  public ModelAndView holiInfoRegApp(@RequestParam Map<String, Object> map, HttpServletRequest req, Model model) throws Exception {
    logger.info("holiInfoRegApp");
    ModelAndView        mav     = new ModelAndView();
    Map<String, String> param   = new HashMap<>();
    HttpSession         session = req.getSession();
    LoginVO             loginVo = (LoginVO)session.getAttribute("login");
    
    if(null == loginVo) {
        mav.setViewName("Login");
        return mav;
    }
    
    //휴가구분 공통코드 조회
    List<Map<String, Object>> holi_gbn_list = new ArrayList<>();
    param.put("simp_tpc", "VACA_GBN");
    param.put("attr_1", "");
    holi_gbn_list = this.mainService.selectCommList(param);
    
    //휴가상태 공통코드 조회
    List<Map<String, Object>> holi_sts_list = new ArrayList<>();
    param.put("simp_tpc", "REQ_GBN");
    param.put("attr_1", "");
    holi_sts_list = this.mainService.selectCommList(param);
    
    //휴가승인자 공통코드 조회
    List<Map<String, Object>> holi_appr_list = new ArrayList<>();
    param.put("simp_tpc", "APPOROVER");
    param.put("attr_1", "");
    holi_appr_list = this.mainService.selectCommList(param);
    
    //로그인 회원 ID, 회원이 마스터 승인자인지 여부 조회
    map.put("mb_id"   , loginVo.getMb_id());
    map.put("masterYn", this.mainService.selectApporoverMasterYn(map)); //마스터승인자여부
    
    //회원조회 (휴가신청자대상 목록)
    List<LoginVO> member_sel_list = new ArrayList<>();
    map.put("sortUserSet", "mb_name");
    member_sel_list = this.mainService.member_sel(map);
       
    if( !map.containsKey("holi_seq") ) map.put("holi_seq", -1);
    List<Map<String, Object>> selList = this.mainService.selectHoliRegInfo(map);
    if( selList.size()==0 ) {
    	Map<String, Object> dummyMap = new HashMap<>();
    	//마스터 승인자가 아니고 조회내용이 없는경우(신규신청인 경우) 신청자ID를 로그인한 사용자ID로 초기화
    	if( !"1".equals(map.get("masterYn")) ) {
    		dummyMap.put("requestor_id", loginVo.getMb_id()  );
    		dummyMap.put("requestor_nm", loginVo.getMb_name());
    	}
        selList.add( dummyMap );
    }
    model.addAttribute("holiList", selList);
    
    mav.addObject("holi_gbn_list"  , holi_gbn_list  );
    mav.addObject("holi_sts_list"  , holi_sts_list  );
    mav.addObject("holi_appr_list" , holi_appr_list );
    mav.addObject("member_sel_list", member_sel_list);
    mav.addObject("login_id"   , loginVo.getMb_id() );
    mav.addObject("master_yn"  , map.get("masterYn"));
    
    mav.setViewName("Doollee_holi_regPop_app.popup");
    return mav;
  }
}
