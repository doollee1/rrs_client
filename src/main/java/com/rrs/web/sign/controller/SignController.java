package com.rrs.web.sign.controller;

import com.rrs.web.sign.service.SignService;
import com.rrs.web.sign.service.vo.SignVO;
import com.rrs.comm.util.EgovFileScrty;
import com.rrs.web.comm.service.MailSendService;
import com.rrs.web.sign.controller.SignController;

import java.security.KeyFactory;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.spec.RSAPublicKeySpec;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.crypto.Cipher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * @author 이민구
 * 파일이름 : SignController.java
 * 파일설명 : 회원가입 컨트롤러
 * ***************************************************************************
 * 함수명			- 함수설명						방식	URL
 * ---------------------------------------------------------------------------
 * initRsa()		- RSA 키 생성
 * encryptRsa()		- RSA 암호화
 * decryptRsa()		- RSA 복호화
 * hexToByteArray()	- 16진 문자열 > byte 배열 전환
 * signInPage()		- 로그인 화면 진입				GET		/signIn.do
 * signIn()			- 로그인 처리					POST	/signIn.do
 * signUpPage()		- 회원가입 화면 진입			GET		/signUp.do
 * signUp()			- 회원가입 처리					POST	/signUp.do
 * idChk()			- 아이디 중복 체크				POST	/signUpIdChk.do
 * findIdPage()		- 아이디 찾기 화면 진입			GET		/findId.do
 * findId()			- 아이디 찾기 처리				POST	/findId.do
 * findPwPage()		- 비밀번호 찾기 화면 진입		GET		/findPw.do
 * findPw()			- 비밀번호 찾기 처리			POST	/findPw.do
 * ***************************************************************************
 */
@Controller
public class SignController {
	
	private static final Logger logger = LoggerFactory.getLogger(SignController.class);
	
	@Resource(name = "signService")
	SignService signService;
	
	@Resource(name = "mailSendService")
	MailSendService mailSendService;
	
	public static String RSA_WEB_KEY	= "_RSA_WEB_Key_";	// 개인키 session key
	public static String RSA_INSTANCE	= "RSA";				// rsa transformation
	
	/**
	 * rsa 공개키, 개인키 생성
	 * @param request
	 */
	public void initRsa(HttpServletRequest req) {
		HttpSession session = req.getSession();

		KeyPairGenerator generator;
		try {
			generator = KeyPairGenerator.getInstance(SignController.RSA_INSTANCE);
			generator.initialize(1024);

			KeyPair keyPair = generator.genKeyPair();
			KeyFactory keyFactory = KeyFactory.getInstance(SignController.RSA_INSTANCE);
			PublicKey publicKey = keyPair.getPublic();
			PrivateKey privateKey = keyPair.getPrivate();

			session.setAttribute(SignController.RSA_WEB_KEY, privateKey); // session에 RSA 개인키를 세션에 저장

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
		Cipher cipher = Cipher.getInstance(SignController.RSA_INSTANCE);
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
	
	// 로그인 화면 진입
	@RequestMapping(value = {"/signIn.do"}, method = {RequestMethod.GET})
	public String signInPage(HttpServletRequest req) throws Exception {
		initRsa(req);
		return "user/signIn.view1";
	}
	
	// 로그인 처리
	@RequestMapping(value = {"/signIn.do"}, method = {RequestMethod.POST})
	@ResponseBody
	public String signIn(@ModelAttribute("SignVO") SignVO vo, HttpServletRequest req) throws Exception {
		logger.info("signIn");
//		logger.info("화면에서 입력한 패스워드 ::::: " + vo.getPasswd());
		
		HttpSession session = req.getSession();
		PrivateKey privateKey = (PrivateKey) session.getAttribute(SignController.RSA_WEB_KEY);
		vo.setPasswd(decryptRsa(privateKey, vo.getPasswd()));
//		logger.info("> 복호화 처리한 패스워드 ::::: " + vo.getPasswd());
		
		vo.setPasswd(EgovFileScrty.encryptPassword(vo.getPasswd(), vo.getUser_id()));
//		logger.info("> DB 암호화 패스워드 ::::: " + vo.getPasswd());
		
		SignVO login = this.signService.signIn(vo);
		String loginYn = "";
		
		if (login == null) {
			int chk = this.signService.idChk(vo.getUser_id());
			logger.debug("chk ::::: " + chk);
			if(chk > 0) {
				loginYn = "N"; //아이디 혹은 비밀번호 오류
			} else {
				loginYn = ""; //존재하지 않는 계정 정보
			}
		} else {
			session = req.getSession(true);
			
			session.setAttribute("user_id",	login.getUser_id());	//사용자id
			session.setAttribute("mem_gbn",	login.getMem_gbn());	//회원구분 01 멤버 / 02 일반 / 03 교민 / 04 에이전시
			session.setAttribute("han_name",login.getHan_name());	//한글이름
			session.setAttribute("eng_name",login.getEng_name());	//영문이름
			session.setAttribute("tel_no",	login.getTel_no());		//전화번호
			session.setAttribute("email",	login.getEmail());		//이메일
			session.setAttribute("passwd",	login.getPasswd());		//비밀번호
			session.setAttribute("ret_yn",	login.getRet_yn());		//탈퇴여부
			session.setAttribute("reg_dtm",	login.getReg_dtm());	//등록일시
			session.setAttribute("upd_dtm",	login.getUpd_dtm());	//수정일시
			
			
			if(login.getPasswd().equals("1234")){
				loginYn = "D"; //D : 비밀번호가 초기상태일 경우
			} else if(login.getRet_yn().equals("Y")){
				loginYn = "F"; //F : 사용자 게정이 이용불가 상태일 경우
			} else{
				loginYn = "Y"; //Y : 로그인 성공
			}
			
		}
		
		logger.debug("loginYN ::::: " + loginYn);
		
		return loginYn;
	}
	
	// 회원가입 화면 진입
	@RequestMapping(value = {"/signUp.do"}, method = {RequestMethod.GET})
	public String signUpPage(HttpServletRequest req) throws Exception {
		logger.info("signUpPage");
		initRsa(req);
		return "user/signUp.view1";
	}
	
	// 회원가입 화면 - 회원가입 처리 로직
	@RequestMapping(value = {"/signUp.do"}, method = {RequestMethod.POST})
	@ResponseBody
	public String signUp(@ModelAttribute("SignVO") SignVO vo, HttpServletRequest req) throws Exception {
		logger.info("signUp");
//		logger.info("화면에서 입력한 패스워드 ::::: " + vo.getPasswd());
		
		HttpSession session = req.getSession();
		PrivateKey privateKey = (PrivateKey) session.getAttribute(SignController.RSA_WEB_KEY);
		vo.setPasswd(decryptRsa(privateKey, vo.getPasswd()));
//		logger.info("> 복호화 처리한 패스워드 ::::: " + vo.getPasswd());
		
		vo.setUser_id(req.getParameter("user_id"));
		vo.setMem_gbn(req.getParameter("mem_gbn"));
		vo.setHan_name(req.getParameter("han_name"));
		vo.setEng_name(req.getParameter("eng_name"));
		vo.setTel_no(req.getParameter("tel_no"));
		vo.setEmail(req.getParameter("email"));
		vo.setPasswd(EgovFileScrty.encryptPassword(vo.getPasswd(), vo.getUser_id()));
//		logger.info("> DB 암호화 패스워드 ::::: " + vo.getPasswd());
		vo.setRet_yn(req.getParameter("ret_yn"));
		vo.setReg_dtm(req.getParameter("reg_dtm"));
		vo.setUpd_dtm(req.getParameter("upd_dtm"));
		
		int chk = this.signService.signUp(vo);
		int memchk = this.signService.memberChk(vo);
		
		return (chk > 0) ? (memchk > 0) ? "M" : "Y" : "N";
	}
	
	// 회원가입 화면 - 아이디 중복체크 로직
	@RequestMapping(value = {"/signUpIdChk.do"}, method = {RequestMethod.POST})
	@ResponseBody
	public String idChk(HttpServletRequest req) throws Exception{
		String id = req.getParameter("user_id");
		logger.info("idChk : " + id);
		int chk = this.signService.idChk(id);
		logger.debug("chk : " + chk);
		return (chk > 0) ? "Y" : "N";
	}
	
	// 아이디 찾기 화면 진입
	@RequestMapping(value = {"/findId.do"}, method = {RequestMethod.GET})
	public String findIdPage() throws Exception {
		logger.info("findIdPage");
		return "user/findId.view1";
	}
	
	// 아이디 찾기 처리
	 @RequestMapping(value = {"/findId.do"}, method = {RequestMethod.POST})
	 @ResponseBody
	 public String findId(@ModelAttribute("SignVO") SignVO vo, HttpServletRequest req) throws Exception {
		logger.info("findId");
		
		String result = "";
		String find = this.signService.findId(vo);
		logger.debug("find ::::: " + find);
		if(find == null){
			result = "NONE"; // 해당 정보 없음
		} else {
			logger.debug("email");
			Map<String, Object> param = new HashMap<String, Object>();
			String han_name = req.getParameter("han_name");
			String title = "PalmResort 예약 시스템 " + han_name + " 회원 님의 아이디입니다.";
			String content = "회원님의 아이디는 " + find + " 입니다.";
			param.put("to", req.getParameter("email"));
			param.put("title", title);
			param.put("content", content);
			mailSendService.sendMail(param);
			result = "Y";
		}
		return result;
	 }
	
	// 비밀번호 찾기 화면 진입
	@RequestMapping(value = {"/findPw.do"}, method = {RequestMethod.GET})
	public String findPwPage(HttpServletRequest req) throws Exception {
		logger.info("findPwPage");
		initRsa(req);
		return "user/findPw.view1";
	}
	
	// 비밀번호 찾기 처리
	@RequestMapping(value = {"/findPw.do"}, method = {RequestMethod.POST})
	@ResponseBody
	public String findPw(@ModelAttribute("SignVO") SignVO vo, HttpServletRequest req) throws Exception {
		logger.info("findPw");
		
		HttpSession session = req.getSession();
		String result = "";
		
		// 입력받은 비밀번호를 복호화 후 다시 암호화하여 DB형식의 데이터로 전환
		PrivateKey privateKey = (PrivateKey) session.getAttribute(SignController.RSA_WEB_KEY);
		vo.setPasswd(decryptRsa(privateKey, vo.getPasswd()));
		
		String find = this.signService.findPw(vo);
		logger.debug("find ::::: " + find);
		if(find == null){
			result = "NONE"; // 해당 정보 없음
		} else {
			this.signService.resetPw(vo); // 비밀번호를 초기화, 회원 상태 변경 : R
			result = "Y";
		}
		
		
		return result;
	}
	/*
	@RequestMapping(value = {"/signOut.do"}, method = {RequestMethod.GET})
	public String logout(HttpSession session) throws Exception {
		
		//app에서 invalidate 가 동작하지 않아서 추가
		session.removeAttribute("user_id");
		session.removeAttribute("mem_gbn");
		session.removeAttribute("han_name");
		session.removeAttribute("eng_name");
		session.removeAttribute("tel_no");
		session.removeAttribute("email");
		session.removeAttribute("passwd");
		session.removeAttribute("ret_yn");
		session.removeAttribute("reg_dtm");
		session.removeAttribute("upd_dtm");
		session.invalidate();
		
		return "user/signOut.view";
	}
	*/
	
}
