package com.rrs.comm.web;
import com.google.gson.Gson;
import com.google.gson.JsonParser;
import com.rrs.comm.service.LoginService;
import com.rrs.comm.service.vo.LoginVO;
import com.rrs.comm.web.LoginController;

import java.util.Map;
import java.util.LinkedHashMap;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class LoginController {
  private static final Logger logger = LoggerFactory.getLogger(LoginController.class);
  
  @Resource(name = "loginService")
  LoginService loginService;
  
  @RequestMapping(value = {"/login.do"}, method = {RequestMethod.POST})
  @ResponseBody
  public String login(@ModelAttribute("LoginVO") LoginVO vo, HttpServletRequest req) throws Exception {
    logger.info("login");
    HttpSession session = null;
    LoginVO login = this.loginService.login(vo);
    String loginYn = "";
    if (login == null) {
        loginYn = "N";
    } else if (login.getMb_level() == 2) {
        loginYn = "R";
    } else {
        session = req.getSession(true);
        session.setAttribute("login"      , login                                   );
        session.setAttribute("usrid"      , login.getMb_id()                        );
        session.setAttribute("usrlvl"     , Integer.valueOf(login.getMb_level())    );
        session.setAttribute("loginYn"    , "Y"                                     );
        session.setAttribute("pw_chk"     , login.getMb_pw_chk()                    );
        session.setAttribute("projectPlYn", login.getMb_projectPlYn()               );
        session.setAttribute("projectNo"  , Integer.valueOf(login.getMb_projectNo()));
       
        if ("1".equals(login.getMb_pw_chk())) loginYn = "Y";
        else loginYn = "F";
    }
    return loginYn;
  }
  
  @RequestMapping(value = {"/loginApp.do"}, produces = {"application/json;charset=UTF-8"})
  @ResponseBody
  public LinkedHashMap<String, Object> loginApp(@RequestBody LoginVO vo, HttpServletRequest req) throws Exception {
    logger.info("loginApp");
    HttpSession session = null;
    JsonParser p = new JsonParser();
    LoginVO login = this.loginService.login(vo);
    String rs = "";
    if (login == null) {
      rs = "{\"successYn\":\"N\"} ";
    } else if (login.getMb_level() == 2) {
      rs = "{\"successYn\":\"R\"} ";
    } else if (!"1".equals(login.getMb_pw_chk())) {
      session = req.getSession(true);
      session.setAttribute("login", login);
      session.setAttribute("usrid", login.getMb_id());
      session.setAttribute("usrlvl", Integer.valueOf(login.getMb_level()));
      session.setAttribute("loginYn", "Y");
      session.setAttribute("pw_chk", login.getMb_pw_chk());
      session.setAttribute("projectPlYn", login.getMb_projectPlYn());
      session.setAttribute("projectNo", Integer.valueOf(login.getMb_projectNo()));
      rs = "{\"successYn\":\"F\" , \"menu\":[{\"name\":\"Company\", \"login\":\"0\", \"url\":\"\", \"depth\":[{\"name\":\"\", \"url\":\"/Company.do\", \"login\":\"0\", \"right\":\"0\"},{\"name\":\"\", \"url\":\"/Recruit.do\", \"login\":\"0\", \"right\":\"0\"},{\"name\":\"\", \"url\":\"/noticeList.do\", \"login\":\"0\", \"right\":\"0\"}]} ,{\"name\":\"Business\", \"login\":\"0\", \"url\":\"\", \"depth\":[   {\"name\":\"\", \"url\":\"/Business_outline.do\", \"login\":\"0\", \"right\":\"0\"}, {\"name\":\"\", \"url\":\"/Business_consulting.do\", \"login\":\"0\", \"right\":\"0\"}, {\"name\":\"\", \"url\":\"/Business_service.do\", \"login\":\"0\", \"right\":\"0\"}, {\"name\":\"\", \"url\":\"/Business_solution.do\", \"login\":\"0\", \"right\":\"0\"}]},{\"name\":\"Project\", \"login\":\"0\", \"url\":\"\", \"depth\":[  {\"name\":\"\", \"url\":\"/Project_actual.do\", \"login\":\"0\", \"right\":\"1\"}]},{\"name\":\"Contact\", \"login\":\"0\", \"url\":\"\", \"depth\":[  {\"name\":\"\", \"url\":\"/Contact_insert.do\", \"login\":\"0\", \"right\":\"1\"}, {\"name\":\"\", \"url\":\"/Contact_select.do\", \"login\":\"0\", \"right\":\"1\"}]},{\"name\":\"Member\", \"login\":\"1\", \"url\":\"\", \"depth\":[  {\"name\":\"\", \"url\":\"/Member_user.do\", \"login\":\"1\", \"right\":\"1\"}]} ]} ";
    } else {
      session = req.getSession(true);
      session.setAttribute("login", login);
      session.setAttribute("usrid", login.getMb_id());
      session.setAttribute("usrlvl", Integer.valueOf(login.getMb_level()));
      session.setAttribute("loginYn", "Y");
      session.setAttribute("pw_chk", login.getMb_pw_chk());
      session.setAttribute("projectPlYn", login.getMb_projectPlYn());
      session.setAttribute("projectNo", Integer.valueOf(login.getMb_projectNo()));
      if ("0".equals(Integer.valueOf(login.getMb_level()))) {
        rs = "{\"successYn\":\"Y\", \"menu\":[{\"name\":\"Company\", \"login\":\"0\", \"url\":\"\", \"depth\":[{\"name\":\"\", \"url\":\"/Company.do\", \"login\":\"0\", \"right\":\"0\"},{\"name\":\"\", \"url\":\"/Recruit.do\", \"login\":\"0\", \"right\":\"0\"},{\"name\":\"\", \"url\":\"/noticeList.do\", \"login\":\"0\", \"right\":\"0\"}]} ,{\"name\":\"Business\", \"login\":\"0\", \"url\":\"\", \"depth\":[   {\"name\":\"\", \"url\":\"/Business_outline.do\", \"login\":\"0\", \"right\":\"0\"}, {\"name\":\"\", \"url\":\"/Business_consulting.do\", \"login\":\"0\", \"right\":\"0\"}, {\"name\":\"\", \"url\":\"/Business_service.do\", \"login\":\"0\", \"right\":\"0\"}, {\"name\":\"\", \"url\":\"/Business_solution.do\", \"login\":\"0\", \"right\":\"0\"}]},{\"name\":\"Project\", \"login\":\"0\", \"url\":\"\", \"depth\":[  {\"name\":\"\", \"url\":\"/Project_actual.do\", \"login\":\"0\", \"right\":\"1\"}]},{\"name\":\"Contact\", \"login\":\"0\", \"url\":\"\", \"depth\":[  {\"name\":\"\", \"url\":\"/Contact_insert.do\", \"login\":\"0\", \"right\":\"1\"}, {\"name\":\"\", \"url\":\"/Contact_select.do\", \"login\":\"0\", \"right\":\"1\"}]},{\"name\":\"Member\", \"login\":\"1\", \"url\":\"\", \"depth\":[  {\"name\":\"\", \"url\":\"/Member_sel.do\", \"login\":\"1\", \"right\":\"1\"}, {\"name\":\"\", \"url\":\"/Comm_code.do\", \"login\":\"1\", \"right\":\"1\"}, {\"name\":\"\", \"url\":\"/Doollee_holi_main_app.do\", \"login\":\"1\", \"right\":\"1\"}, {\"name\":\"\", \"url\":\"/Doollee_holi_confirm_main_app.do\", \"login\":\"1\", \"right\":\"1\"}, {\"name\":\"\", \"url\":\"/Doollee_prod_main.do\", \"login\":\"1\", \"right\":\"1\"}, {\"name\":\"\", \"url\":\"/Doollee_repair_main.do\", \"login\":\"1\", \"right\":\"1\"}, {\"name\":\"\", \"url\":\"/Doollee_trans_main.do\", \"login\":\"1\", \"right\":\"1\"}]} ]} ";
      } else if ("1".equals(Integer.valueOf(login.getMb_level())) && "1".equals(login.getMb_projectPlYn())) {
        rs = "{\"successYn\":\"Y\" , \"menu\":[{\"name\":\"Company\", \"login\":\"0\", \"url\":\"\", \"depth\":[{\"name\":\"\", \"url\":\"/Company.do\", \"login\":\"0\", \"right\":\"0\"},{\"name\":\"\", \"url\":\"/Recruit.do\", \"login\":\"0\", \"right\":\"0\"},{\"name\":\"\", \"url\":\"/noticeList.do\", \"login\":\"0\", \"right\":\"0\"}]} ,{\"name\":\"Business\", \"login\":\"0\", \"url\":\"\", \"depth\":[   {\"name\":\"\", \"url\":\"/Business_outline.do\", \"login\":\"0\", \"right\":\"0\"}, {\"name\":\"\", \"url\":\"/Business_consulting.do\", \"login\":\"0\", \"right\":\"0\"}, {\"name\":\"\", \"url\":\"/Business_service.do\", \"login\":\"0\", \"right\":\"0\"}, {\"name\":\"\", \"url\":\"/Business_solution.do\", \"login\":\"0\", \"right\":\"0\"}]},{\"name\":\"Project\", \"login\":\"0\", \"url\":\"\", \"depth\":[  {\"name\":\"\", \"url\":\"/Project_actual.do\", \"login\":\"0\", \"right\":\"1\"}]},{\"name\":\"Contact\", \"login\":\"0\", \"url\":\"\", \"depth\":[  {\"name\":\"\", \"url\":\"/Contact_insert.do\", \"login\":\"0\", \"right\":\"1\"}, {\"name\":\"\", \"url\":\"/Contact_select.do\", \"login\":\"0\", \"right\":\"1\"}]},{\"name\":\"Member\", \"login\":\"1\", \"url\":\"\", \"depth\":[  {\"name\":\"\", \"url\":\"/Member_user.do\", \"login\":\"1\", \"right\":\"1\"}, {\"name\":\"\", \"url\":\"/Doollee_trans_main.do\", \"login\":\"1\", \"right\":\"1\"}, {\"name\":\"\", \"url\":\"/Doollee_holi_confirm_main_app.do\", \"login\":\"1\", \"right\":\"1\"}, {\"name\":\"\", \"url\":\"/Doollee_holi_main_app.do\", \"login\":\"1\", \"right\":\"1\"}]} ]} ";
      } else {
        rs = "{\"successYn\":\"Y\" , \"menu\":[{\"name\":\"Company\", \"login\":\"0\", \"url\":\"\", \"depth\":[{\"name\":\"\", \"url\":\"/Company.do\", \"login\":\"0\", \"right\":\"0\"},{\"name\":\"\", \"url\":\"/Recruit.do\", \"login\":\"0\", \"right\":\"0\"},{\"name\":\"\", \"url\":\"/noticeList.do\", \"login\":\"0\", \"right\":\"0\"}]} ,{\"name\":\"Business\", \"login\":\"0\", \"url\":\"\", \"depth\":[   {\"name\":\"\", \"url\":\"/Business_outline.do\", \"login\":\"0\", \"right\":\"0\"}, {\"name\":\"\", \"url\":\"/Business_consulting.do\", \"login\":\"0\", \"right\":\"0\"}, {\"name\":\"\", \"url\":\"/Business_service.do\", \"login\":\"0\", \"right\":\"0\"}, {\"name\":\"\", \"url\":\"/Business_solution.do\", \"login\":\"0\", \"right\":\"0\"}]},{\"name\":\"Project\", \"login\":\"0\", \"url\":\"\", \"depth\":[  {\"name\":\"\", \"url\":\"/Project_actual.do\", \"login\":\"0\", \"right\":\"1\"}]},{\"name\":\"Contact\", \"login\":\"0\", \"url\":\"\", \"depth\":[  {\"name\":\"\", \"url\":\"/Contact_insert.do\", \"login\":\"0\", \"right\":\"1\"}, {\"name\":\"\", \"url\":\"/Contact_select.do\", \"login\":\"0\", \"right\":\"1\"}]},{\"name\":\"Member\", \"login\":\"1\", \"url\":\"\", \"depth\":[  {\"name\":\"\", \"url\":\"/Member_user.do\", \"login\":\"1\", \"right\":\"1\"}, {\"name\":\"\", \"url\":\"/Doollee_trans_main.do\", \"login\":\"1\", \"right\":\"1\"}, {\"name\":\"\", \"url\":\"/Doollee_holi_main_app.do\", \"login\":\"1\", \"right\":\"1\"}]} ]} ";
      } 
    } 
    Gson gson = new Gson();
    LinkedHashMap<String, Object> map = new LinkedHashMap<>();
    map = (LinkedHashMap<String, Object>)gson.fromJson(rs, map.getClass());
    return map;
  }
  
  @RequestMapping(value = {"/menuCall.do"}, produces = {"application/json;charset=UTF-8"})
  @ResponseBody
  public LinkedHashMap<String, Object> menuCall(@ModelAttribute("LoginVO") LoginVO vo, HttpServletRequest req) throws Exception {
    logger.info("menuCall");
    String rs = "{\"menu\":[{\"name\":\"Company\", \"login\":\"0\", \"url\":\"\", \"depth\":[{\"name\":\"\", \"url\":\"/Company.do\", \"login\":\"0\", \"right\":\"0\"},{\"name\":\"\", \"url\":\"/Recruit.do\", \"login\":\"0\", \"right\":\"0\"},{\"name\":\"\", \"url\":\"/noticeList.do\", \"login\":\"0\", \"right\":\"0\"}]} ,{\"name\":\"Business\", \"login\":\"0\", \"url\":\"\", \"depth\":[   {\"name\":\"\", \"url\":\"/Business_outline.do\", \"login\":\"0\", \"right\":\"0\"}, {\"name\":\"\", \"url\":\"/Business_consulting.do\", \"login\":\"0\", \"right\":\"0\"}, {\"name\":\"\", \"url\":\"/Business_service.do\", \"login\":\"0\", \"right\":\"0\"}, {\"name\":\"\", \"url\":\"/Business_solution.do\", \"login\":\"0\", \"right\":\"0\"}]},{\"name\":\"Project\", \"login\":\"0\", \"url\":\"\", \"depth\":[  {\"name\":\"\", \"url\":\"/Project_actual.do\", \"login\":\"0\", \"right\":\"1\"}]},{\"name\":\"Contact\", \"login\":\"0\", \"url\":\"\", \"depth\":[  {\"name\":\"\", \"url\":\"/Contact_insert.do\", \"login\":\"0\", \"right\":\"1\"}, {\"name\":\"\", \"url\":\"/Contact_select.do\", \"login\":\"0\", \"right\":\"1\"}]}]} ";
    Gson gson = new Gson();
    LinkedHashMap<String, Object> map = new LinkedHashMap<>();
    map = (LinkedHashMap<String, Object>)gson.fromJson(rs, map.getClass());
    HttpSession session = null;
    session = req.getSession(true);
    session.setAttribute("appYn", "Y");
    return map;
  }
  
  @RequestMapping(value = {"/logout.do"}, method = {RequestMethod.GET})
  public String logout(HttpSession session) throws Exception {
    //app에서 invalidate 가 동작하지 않아서 추가
    session.removeAttribute("login"      );
    session.removeAttribute("usrid"      );
    session.removeAttribute("usrlvl"     );
    session.removeAttribute("loginYn"    );
    session.removeAttribute("pw_chk"     );
    session.removeAttribute("projectPlYn");
    session.removeAttribute("projectNo"  );
	session.invalidate();
    //session.setAttribute("login"      , "" );
    //session.setAttribute("usrid"      , "" );
    //session.setAttribute("usrlvl"     , "" );
    //session.setAttribute("loginYn"    , "" );
    //session.setAttribute("pw_chk"     , "" );
    //session.setAttribute("projectPlYn", "" );
    //session.setAttribute("projectNo"  , "" );
    
    return "Login";
  }

	@RequestMapping(value = "/deviceInfoIns.do", method = RequestMethod.POST)
	public @ResponseBody String deviceInfoIns(@RequestParam Map<String,Object> map,HttpServletRequest req) throws Exception {
		int rs = loginService.deviceInfoIns(map);
		return rs != 0 ? "Y" : "N" ;
	}
}
