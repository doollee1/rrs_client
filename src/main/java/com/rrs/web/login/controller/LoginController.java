package com.rrs.web.login.controller;

import com.google.gson.Gson;
import com.google.gson.JsonParser;
import com.rrs.web.login.service.LoginService;
import com.rrs.web.login.service.vo.LoginVO;

import com.rrs.comm.util.EgovFileScrty;

import java.util.Map;
import java.security.KeyFactory;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.spec.RSAPublicKeySpec;
import java.util.LinkedHashMap;
import javax.annotation.Resource;
import javax.crypto.Cipher;
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

@Controller("loginController")
public class LoginController {
	private static final Logger logger = LoggerFactory.getLogger(LoginController.class);
	
	public static String RSA_WEB_KEY  = "_RSA_WEB_Key_"; // 개인키 session key
	public static String RSA_INSTANCE = "RSA";           // rsa transformation

	@Resource(name = "loginService")
	LoginService loginService;

	@RequestMapping(value = "/go_MLogin.do", method = RequestMethod.GET) 
	public String Login () throws Exception {
		//return "m_Login";
		return "Login";
	}

	@RequestMapping(value = "/test.do", method = RequestMethod.GET) 
	public String test (HttpServletRequest req) throws Exception {
		//return "m_Login";
		initRsa(req);
		return "test.view1";
	}

	@RequestMapping(value = {"/login.do"}, method = {RequestMethod.POST})
	@ResponseBody
	public String login(@ModelAttribute("LoginVO") LoginVO vo, HttpServletRequest req) throws Exception {
		logger.info("login");
		logger.info("화면에서 입력한 패스워드 ::::: " + vo.getIn_pw());

		// 복호화
		HttpSession session = req.getSession();
		PrivateKey privateKey = (PrivateKey) session.getAttribute(LoginController.RSA_WEB_KEY);
		vo.setIn_pw(decryptRsa(privateKey, vo.getIn_pw()));
		logger.info("> 복호화 처리한 패스워드 ::::: " + vo.getIn_pw());

		// 암호화 DB체크, insert 시
		vo.setIn_pw(EgovFileScrty.encryptPassword(vo.getIn_pw(), vo.getIn_id()));
		logger.info(">> 암호화 처리한 패스워드 ::::: " + vo.getIn_pw());

		logger.info(EgovFileScrty.encryptPassword("oms1234", "admin"));
		return "Y";
	}

	/**
	 * rsa 공개키, 개인키 생성
	 * @param request
	 */
	public void initRsa(HttpServletRequest req) {
		
		logger.info("===== RSA 공개키, 개인키 생성 =====");
		HttpSession session = req.getSession();

		KeyPairGenerator generator;
		try {
			generator = KeyPairGenerator.getInstance(LoginController.RSA_INSTANCE);
			generator.initialize(1024);

			KeyPair keyPair = generator.genKeyPair();
			KeyFactory keyFactory = KeyFactory.getInstance(LoginController.RSA_INSTANCE);
			PublicKey publicKey = keyPair.getPublic();
			PrivateKey privateKey = keyPair.getPrivate();

			session.setAttribute(LoginController.RSA_WEB_KEY, privateKey); // session에 RSA 개인키를 세션에 저장

			RSAPublicKeySpec publicSpec = (RSAPublicKeySpec) keyFactory.getKeySpec(publicKey, RSAPublicKeySpec.class);
			String publicKeyModulus = publicSpec.getModulus().toString(16);
			String publicKeyExponent = publicSpec.getPublicExponent().toString(16);

			req.setAttribute("RSAModulus" , publicKeyModulus ); // rsa modulus 를 request 에 추가
			req.setAttribute("RSAExponent", publicKeyExponent); // rsa exponent 를 request 에 추가
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 복호화
	 * @param privateKey
	 * @param securedValue
	 * @return
	 * @throws Exception
	 */
	public String decryptRsa(PrivateKey privateKey, String securedValue) throws Exception {
		Cipher cipher = Cipher.getInstance(LoginController.RSA_INSTANCE);
		byte[] encryptedBytes = hexToByteArray(securedValue);
		cipher.init(Cipher.DECRYPT_MODE, privateKey);
		byte[] decryptedBytes = cipher.doFinal(encryptedBytes);
		String decryptedValue = new String(decryptedBytes, "utf-8"); // 문자 인코딩 주의.
		return decryptedValue;
	}

	/**
	 * 16진 문자열을 byte 배열로 변환한다.
	 * @param hex
	 * @return
	 */
	public static byte[] hexToByteArray(String hex) {
		if (hex == null || hex.length() % 2 != 0) { return new byte[] {}; }

		byte[] bytes = new byte[hex.length() / 2];
		for (int i = 0; i < hex.length(); i += 2) {
			byte value = (byte) Integer.parseInt(hex.substring(i, i + 2), 16);
			bytes[(int) Math.floor(i / 2)] = value;
		}
		return bytes;
	}







	// TODO
	// 참고 후 제거
//	@RequestMapping(value = {"/login.do"}, method = {RequestMethod.POST})
//	@ResponseBody
//	public String login(@ModelAttribute("LoginVO") LoginVO vo, HttpServletRequest req) throws Exception {
//		logger.info("login");
//		HttpSession session = null;
//		LoginVO login = this.loginService.login(vo);
//		String loginYn = "";
//		if (login == null) {
//			loginYn = "N";
//		} else if (login.getMb_level() == 2) {
//			loginYn = "R";
//		} else {
//			session = req.getSession(true);
//			session.setAttribute("login"      , login                                   );
//			session.setAttribute("usrid"      , login.getMb_id()                        );
//			session.setAttribute("usrlvl"     , Integer.valueOf(login.getMb_level())    );
//			session.setAttribute("loginYn"    , "Y"                                     );
//			session.setAttribute("pw_chk"     , login.getMb_pw_chk()                    );
//			session.setAttribute("projectPlYn", login.getMb_projectPlYn()               );
//			session.setAttribute("projectNo"  , Integer.valueOf(login.getMb_projectNo()));
//
//			if ("1".equals(login.getMb_pw_chk())) loginYn = "Y";
//			else loginYn = "F";
//		}
//		return loginYn;
//	}

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
