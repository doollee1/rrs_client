package com.rrs.web.sign.controller;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.security.KeyFactory;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.RSAPublicKeySpec;
import java.util.Base64;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.crypto.Cipher;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Controller;
import org.springframework.util.ObjectUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.util.WebUtils;

import com.rrs.comm.util.EgovFileScrty;
import com.rrs.web.comm.service.MailSendService;
import com.rrs.web.sign.service.SignService;
import com.rrs.web.sign.service.vo.SignVO;

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
	SignService signService;   //로그인 서비스
	
	@Resource(name = "mailSendService")
	MailSendService mailSendService;
	
	@Value("${spring.profiles.active}")
	private String activeProfile;
	
	public static String RSA_WEB_KEY	= "_RSA_WEB_Key_";	// 개인키 session key
	public static String RSA_INSTANCE	= "RSA";			// rsa transformation
	public static int RESET_PASSWORD_SIZE	= 10;				// 랜덤 비밀번호 자리 수 설정
	
	/**
	 * rsa 공개키, 개인키 생성
	 * @param request
	 */
	public void initRsa(HttpServletRequest req) {
		
		logger.info("========= RSA 공개키, 개인키 생성 ===========");
		
		HttpSession session = req.getSession();

		KeyPairGenerator generator;
		try {
			generator = KeyPairGenerator.getInstance(SignController.RSA_INSTANCE);
			generator.initialize(1024);  //1024

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
		Cipher cipher = Cipher.getInstance("RSA/ECB/PKCS1Padding");
		byte[] encryptedBytes = hexToByteArray(securedValue);
		
		cipher.init(Cipher.DECRYPT_MODE, privateKey);
		byte[] decryptedBytes = cipher.doFinal(encryptedBytes);
		String decryptedValue = new String(decryptedBytes, "utf-8"); // 문자 인코딩 주의.
		return decryptedValue;
	}
	
	
	 /**
     * RSA 복호화
     * 
     * @param encryptedText
     * @param stringPrivateKey
     * @return
     */
    public String decryptRsa(String encryptedText) {
		String decryptedText = "";
    	
		try {
			
			//RSA 개인키의 문자열
			org.springframework.core.io.Resource privateKeyResource = new ClassPathResource("/cert/private.key");
			String privateKeyContent = new BufferedReader(new InputStreamReader(privateKeyResource.getInputStream())).lines().collect(Collectors.joining("\n"));
			privateKeyContent = privateKeyContent
					.replace("-----BEGIN PRIVATE KEY-----", "")
					.replace("-----END PRIVATE KEY-----", "")
					.replaceAll("\\s+", "");
			
			//RSA 개인키를 Private 객체로 변환			
			byte[] privateKeyBytes = Base64.getDecoder().decode(privateKeyContent);
			PKCS8EncodedKeySpec keySpec = new PKCS8EncodedKeySpec(privateKeyBytes);
			KeyFactory keyFactory = KeyFactory.getInstance("RSA");
			PrivateKey privateKey = keyFactory.generatePrivate(keySpec);

			//암호문을 바이트 배열로 변환하고 복호화
			byte[] encryptedBytes =  Base64.getDecoder().decode(encryptedText);
			Cipher cipher = Cipher.getInstance("RSA");
			cipher.init(Cipher.DECRYPT_MODE, privateKey);
			byte[] decryptedBytes = cipher.doFinal(encryptedBytes);
			
			//복호화된 데이터 문자열로 변환					
			decryptedText = new String(decryptedBytes, StandardCharsets.UTF_8);
			
		} catch (Exception e) {
			e.printStackTrace();			
		}

		return decryptedText;
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
		
		logger.info("========= 로그인화면 진입 ===========");
		logger.info("========= 프로파일 : "+activeProfile);
				
		return "user/signIn.view1";
	}
	
	
	/**
	 * RSA 초기화
	 * 
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/initRsaAjax.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> initRsaAjax(HttpServletRequest request) throws Exception{
		
		logger.info("======== RSA 초기화  =======");
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		HttpSession session = request.getSession();
		 
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

			resultMap.put("RSAModulus", publicKeyModulus); 	//rsa modulus 
			resultMap.put("RSAExponent", publicKeyExponent); //rsa exponent
            
		} catch (Exception e) {
			e.printStackTrace();
		}
		
        return resultMap;        
	}
	
	
	/**
	 * 로그인 처리
	 * 
	 * @param vo
	 * @param req
	 * @param res
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = {"/signIn.do"}, method = {RequestMethod.POST})
	@ResponseBody
	public String signIn(@ModelAttribute("SignVO") SignVO vo, HttpServletRequest req, HttpServletResponse res) throws Exception {
		
		logger.info("========= 로그인 처리 Controller ==========");
		//logger.info("========= SignVO : "+vo.toString());
		
		HttpSession session = req.getSession();
				
	    // 복호화	        	        	
        String decryptedPasswd = decryptRsa(vo.getPasswd());
        logger.info("======== decryptedPasswd : "+decryptedPasswd);	
        vo.setPasswd(decryptedPasswd);
        
		vo.setPasswd(EgovFileScrty.encryptPassword(vo.getPasswd(), vo.getUser_id()));
		
		SignVO login = this.signService.signIn(vo);
		//logger.info("========= login : "+ (ObjectUtils.isEmpty(login)? null : login.toString()));
		
		session.removeAttribute(SignController.RSA_WEB_KEY);  //개인키 세션에서 제거
		
		String loginYn = "";
		
		if (login == null) {
			// 아이디 존재 여부 체크
			int chk = this.signService.idChk(vo.getUser_id());
			if(chk > 0) {
				// 아이디는 존재하지만 비밀번호 오류
				loginYn = "N";
			}
			
		} else {
			
			session = req.getSession(true);						
			
			if(login.getRet_yn().equals("Y")) { // 계정 이용불가 상태
				
				loginYn = "F";
				return loginYn;
			} else if(login.getRet_yn().equals("R")) {  //비밀번호 초기화
				
				loginYn = "R";			
				return loginYn;
			} else {
				
				//에이전시 회원일 경우 반환
				String memGbn = login.getMem_gbn();
				if(!"01".equals(memGbn) && !"02".equals(memGbn)) {  //01(멤버), 02(일반) 회원이 아닌 경우
					
					loginYn = "Q";			
					return loginYn;
				}
				
				
				//관리자 여부
				String isAdminYn = this.signService.isAdminYn(vo.getUser_id());
				logger.info("======== 관리자여부 : "+isAdminYn);
				
				loginYn = "Y".equals(isAdminYn) ? "A" : "Y" ;  // Y : 일반 로그인 성공, A : 관리자로그인 성공
			}
			
													
			session = req.getSession(true);
			session.setAttribute("login",	login);
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
			
			
			//자동로그인 선택시
			if(StringUtils.isNotEmpty(vo.getUseCookie())) {
				
				Cookie loginCookie = new Cookie("loginCookie", session.getId());
        		logger.info("===== loginCookie.name : "+loginCookie.getName() );
        		logger.info("===== loginCookie.value : "+loginCookie.getValue() );
        		
        		int amount = 60*60*24*1;   //1일 유지
             	loginCookie.setPath("/");
             	loginCookie.setMaxAge(amount);   //자동로그인 1일
             	
             	//쿠키추가
             	res.addCookie(loginCookie);

             	
				//쿠키유효시간
				Date sessionLimit = new Date(System.currentTimeMillis() + (1000*amount));
				
				Map<String, Object> paramMap = new HashMap<>();
				paramMap.put("user_id", login.getUser_id());
				paramMap.put("sessionId", session.getId());
				paramMap.put("sessionLimit", sessionLimit);
				
				//로그인 유지
				this.signService.keepLogin(paramMap);
			}
						
		}
		
		logger.debug("loginYn ::::: " + loginYn);
		
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
		
		session.removeAttribute(SignController.RSA_WEB_KEY);  //개인키 세션에서 제거
		
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
		logger.info("======= 아이디찾기 처리 =======");
				
		String result = "";
		String find = this.signService.findId(vo);
		logger.debug("find ::::: " + find);
		if(find == null){
			result = "NONE"; // 해당 정보 없음
		} else {
			logger.debug("email");
			Map<String, Object> param = new HashMap<String, Object>();
			String han_name = req.getParameter("han_name");
			String title = "[PalmResort 예약 시스템] " + han_name + " 회원 님의 아이디찾기 서비스입니다.";
			String content = title
					+ System.lineSeparator() + "회원님의 아이디 : " + find
					+ System.lineSeparator() + "해당 아이디로 로그인 후 이용해주세요.";
			param.put("to", req.getParameter("email"));
			param.put("title", title);
			param.put("content", content);
			//param.put("title", new String(title.getBytes("utf-8"), "euc-kr"));
			//param.put("content", new String(content.getBytes("utf-8"), "euc-kr"));
			boolean sendYn = mailSendService.sendMail(param);
			result =  sendYn? "Y" : "N";
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
		
		String result = "";
		
		String find = this.signService.findPw(vo);
		logger.debug("find ::::: " + find);
		if(find == null){
			result = "NONE"; // 해당 정보 없음
		} else {
			
			Map<String, Object> param = new HashMap<String, Object>();
			
			String changePw = this.signService.getRandomPassword(RESET_PASSWORD_SIZE);
			logger.debug("changePw ::::: " + changePw);
			
			vo.setPasswd(EgovFileScrty.encryptPassword(changePw, vo.getUser_id()));
			this.signService.resetPw(vo); // 비밀번호를 초기화, 회원 상태 변경 : R
			
			String user_id = req.getParameter("user_id");
			String title = "[PalmResort 예약 시스템] " + user_id + " 회원 님의 비밀번호찾기 서비스입니다.";
			String content = title
					+ System.lineSeparator() + "변경된 비밀번호 : " + changePw 
					+ System.lineSeparator() + "변경된 비밀번호로 로그인 후 이용해주세요.";
			param.put("to", req.getParameter("email"));
			param.put("title", title);
			param.put("content", content);
			boolean sendYn = mailSendService.sendMail(param);
			
			logger.debug("*****************************");
			logger.debug("이메일 발송 완료 - 비밀번호 찾기");
			logger.debug("이용자 : " + user_id);
			logger.debug("email : " + param.get("to"));
			logger.debug("*****************************");
			
			result = sendYn? "Y" : "N";
		}
		
		
		return result;
	}
	
	// 세팅 화면 진입
	@RequestMapping(value = {"/setting.do"}, method = {RequestMethod.GET})
	public String settingPage(HttpServletRequest req) throws Exception {
		logger.info("settingPage");
		return "user/setting.view";
	}
	
	// 개인정보처리방침 화면 진입
	@RequestMapping(value = {"/policy.do"}, method = {RequestMethod.GET})
	public String policyPage(HttpServletRequest req) throws Exception {
		logger.info("policyPage");
		return "user/policy.view1";
	}
	
	// 개인정보 변경 화면 진입
	@RequestMapping(value = {"/infoChange.do"}, method = {RequestMethod.GET})
	public String infoChangePage(HttpServletRequest req) throws Exception {
		logger.info("infoChangePage");
		initRsa(req);
		return "user/infoChange.view";
	}
	
	// 개인정보 변경 처리
	@RequestMapping(value = {"/infoChange.do"}, method = {RequestMethod.POST})
	@ResponseBody
	public String infoChange(@ModelAttribute("SignVO") SignVO vo, HttpServletRequest req) throws Exception {
		logger.info("infoChange");
		
		String result = "";
		
		HttpSession session = req.getSession();
		PrivateKey privateKey = (PrivateKey) session.getAttribute(SignController.RSA_WEB_KEY);
		
		// 기존 비밀번호 : 화면에서 입력받은 내용
		String passwdOri = req.getParameter("passwdOri");
		passwdOri = decryptRsa(privateKey, passwdOri);
		logger.debug("passwdOri ::::: " + passwdOri);
		
		// 변경할 비밀번호 : 화면에서 입력받은 내용
		String passwdChange = req.getParameter("passwd");
		passwdChange = decryptRsa(privateKey, passwdChange);
		logger.debug("passwdChange ::::: " + passwdChange);
		
		// 아이디 비밀번호 체크, 사용자 계정 상태 확인
		vo.setPasswd(EgovFileScrty.encryptPassword(passwdOri, vo.getUser_id()));
		int chk = this.signService.userChk(vo);
		
		if(chk == 0) {
			// 일치하는 계정 정보가 없음
			result = "NONE";
			return result;
		} else {
			// 아이디, 비밀번호가 일치할 경우 비밀번호 값을 변경할 비밀번호로 변경하여 개인정보 변경처리
			vo.setPasswd(EgovFileScrty.encryptPassword(passwdChange, vo.getUser_id()));
			this.signService.changeInfo(vo);
			result = "Y";
		}
		
		session.removeAttribute(SignController.RSA_WEB_KEY);  //개인키 세션에서 제거
		
		logger.debug("infoChange - result ::::: " + result);
		
		return result;
	}
	
	// 회원탈퇴 처리
	@RequestMapping(value = {"/userOut.do"}, method = {RequestMethod.GET})
	@ResponseBody
	public String userOut(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
		logger.info("userOut");
		
		String result = "N";
		int chk = this.signService.userOut((String) session.getAttribute("user_id"));
		logger.debug("userOut - user_id ::::: " + (String) session.getAttribute("user_id"));
		
		if(chk > 0) {
			logger.debug("userOut - "+ (String) session.getAttribute("user_id") +" 탈퇴처리 및 로그아웃");
			result = (String) session.getAttribute("user_id");
			this.signOut(request, response, session);
		}
		
		logger.debug("userOut - chk ::::: " + chk);
		
		return result;
	}
	
	
	// 로그아웃 처리
	@RequestMapping({"/signOut.do"})
	public String signOut(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("======== 로그아웃 처리 =========");
		
		//session.removeAttribute("login");
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
		//session.invalidate();
			
		
		Object object = session.getAttribute("login");
		logger.info("===== object : "+object);
		
		//login 세션이 있을 경우 로그아웃 처리
		if(!ObjectUtils.isEmpty(object)) {
			
			SignVO login = (SignVO) object;
			
			session.removeAttribute("login");	
			session.invalidate(); //세션 무효화 처리
			
			
			//로그인쿠키 가져오기
			Cookie loginCookie = WebUtils.getCookie(request, "loginCookie");
			logger.info("===== loginCookie : "+loginCookie);
			
			if(loginCookie != null) {
				loginCookie.setPath("/");
				loginCookie.setMaxAge(0);
				response.addCookie(loginCookie);
				
				//자동로그인 초기화
				Map<String, Object> paramMap = new HashMap<>();
				paramMap.put("user_id", login.getUser_id());
				paramMap.put("sessionId", "none");
				paramMap.put("sessionLimit", new Date());
				
				this.signService.keepLogin(paramMap);
				
			}
		}
				
		
		logger.debug("======== 로그아웃 처리완료 =========");
		
		return "main.index";
	}
	
}
