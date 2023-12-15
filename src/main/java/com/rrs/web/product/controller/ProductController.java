package com.rrs.web.product.controller;

import com.rrs.comm.util.EgovDateUtil;
import com.rrs.web.product.service.ProductService;

import java.util.*;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

@Controller("productController")
public class ProductController {
	private static final Logger logger = LoggerFactory.getLogger(ProductController.class);

	@Resource(name = "productService")
	ProductService productService;

	@RequestMapping(value = "/productInfo.do", method = RequestMethod.GET) 
	public ModelAndView productInfo() throws Exception {
		logger.info("productInfo.do");
		ModelAndView mav = new ModelAndView();
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("currentYear", EgovDateUtil.getNowYear());
		paramMap.put("ssnGbn"     , "1"                      );  // 성수기

		// 성수기
		List<Map<String, Object>> productListTmp  = productService.productList(paramMap);

		// 비수기
		paramMap.put("ssnGbn", "2"); // 비수기
		List<Map<String, Object>> productListTmp2 = productService.productList(paramMap);
		
		System.out.println(productListTmp);

		// 리스트 merge
		List<Map<String, Object>> tableList  = makeList(productListTmp );
		List<Map<String, Object>> tableList2 = makeList(productListTmp2);

		// 리스트 날짜별로 그룹핑
		List<List<Map<String, Object>>> tableLists  = listGroupBy(tableList );
		List<List<Map<String, Object>>> tableLists2 = listGroupBy(tableList2);
		
		System.out.println(tableLists);
		System.out.println(tableLists2);

		mav.addObject("tableLists" , tableLists );  // 성수기
		mav.addObject("tableLists2", tableLists2);  // 비수기
		mav.setViewName("product/product.view1");
		return mav;
	}

	// 상품리스트 상품별 날짜3개까지 1row로 만듬
	public List<Map<String, Object>> makeList(List<Map<String, Object>> tmpList) {
		List<Map<String, Object>> tableList = new ArrayList<Map<String, Object>>();
		Map<String, Object> nextData = new HashMap<String, Object>();
		int maxSize = tmpList.size() -1;
		for(int i=0; i<tmpList.size(); i++) {
			Map<String, Object> data = tmpList.get(i);
			Map<String, Object> newData = new HashMap<String, Object>();
			int dtNum1 = 1;
			int dtNum2 = 1;
			do {
				String stDt = (String)data.get("ST_DT" + dtNum2);
				while(stDt != null && !"".equals(stDt)) {
					if(dtNum1 == 4) {
						newData.put("TITLE" , data.get("TITLE"));
						Map<String, Object> newData2 = new HashMap<String, Object>();
						newData2.putAll(newData);
						tableList.add(newData2);
						newData.clear();
						dtNum1 = 1;
					}
					String dt   = EgovDateUtil.formatDate2((String)data.get("ST_DT" + dtNum2)) + "~" + EgovDateUtil.formatDate2((String)data.get("ED_DT" + dtNum2));
					String cntn = (String)data.get("CNTN") + (String)data.get("CNTN2");
					newData.put("DT"   + dtNum1, dt  );
					newData.put("CNTN" + dtNum1, cntn);
					dtNum1++;
					dtNum2++;
					stDt = (String)data.get("ST_DT" + dtNum2);
				}
				if(i < maxSize) {
					nextData = tmpList.get(i + 1);
					if(data.get("HDNG_GBN").equals(nextData.get("HDNG_GBN")) && data.get("PROD_COND").equals(nextData.get("PROD_COND"))) {
						dtNum2 = 1;
						i++;
						data = nextData;
						continue;
					}
				}
				newData.put("TITLE" , data.get("TITLE"));
				tableList.add(newData);
				break;
			} while(true);
		}
		return tableList;
	}

	// 로우별 날짜(최대3개)로 그룹핑
	public List<List<Map<String, Object>>> listGroupBy(List<Map<String, Object>> tableList) {
		Map<String, List<Map<String, Object>>> table = tableList.stream().collect(Collectors.groupingBy((map) -> (String)map.get("DT1")+(String)map.get("DT2")+(String)map.get("DT3")));

		int tableSize = table.size() > 0 ? table.size() : 0;
		List<List<Map<String, Object>>> tableLists = new ArrayList<List<Map<String, Object>>>(tableSize);

		for(String key : table.keySet()) {
			tableLists.add(table.get(key));
		}

		return tableLists;
	}
}
