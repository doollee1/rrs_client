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

	// 상품리스트 상품별 날짜 3개까지 이어 만듬(최대 3row에서 1row로 merge)
	public List<Map<String, Object>> makeList(List<Map<String, Object>> tmpList) {
		List<Map<String, Object>> tableList = new ArrayList<Map<String, Object>>();
		Map<String, Object> nextData = new HashMap<String, Object>();
		int maxSize = tmpList.size() -1;
		for(int i=0; i<tmpList.size(); i++) {
			String header = "";
			String cntn   = "";
			Map<String, Object> data = tmpList.get(i);
			header = Integer.toString((Integer)data.get("BAS_YY_SEQ"));
			Map<String, Object> rowData = new HashMap<String, Object>();
			rowData.put("TITLE" , data.get("TITLE"));
			cntn = (String)data.get("CNTN") + (String)data.get("CNTN2");
			rowData.put("CNTN1" , cntn);
			rowData.put("ST_DT1", data.get("ST_DT1"));
			rowData.put("ED_DT1", data.get("ED_DT1"));
			if(data.get("ST_DT2") != null && !"".equals(data.get("ST_DT2"))) {
				cntn = (String)data.get("CNTN") + (String)data.get("CNTN2");
				rowData.put("CNTN2" , cntn);
				rowData.put("ST_DT2", data.get("ST_DT2"));
				rowData.put("ED_DT2", data.get("ED_DT2"));
				if(data.get("ED_DT3") != null && !"".equals(data.get("ED_DT3"))) {
					cntn = (String)data.get("CNTN") + (String)data.get("CNTN2");
					rowData.put("CNTN3" , cntn);
					rowData.put("ST_DT3", data.get("ST_DT3"));
					rowData.put("ED_DT3", data.get("ED_DT3"));
				} else {
					if(maxSize > i) {
						nextData = tmpList.get(i+1);
						if(data.get("HDNG_GBN").equals(nextData.get("HDNG_GBN")) && data.get("PROD_COND").equals(nextData.get("PROD_COND"))) {
							i++;
							header += "||" + Integer.toString((Integer)nextData.get("BAS_YY_SEQ"));
							cntn = (String)nextData.get("CNTN") + (String)nextData.get("CNTN2");
							rowData.put("CNTN3" , cntn);
							rowData.put("ST_DT3", nextData.get("ST_DT1"));
							rowData.put("ED_DT3", nextData.get("ED_DT1"));
						}
					}
				}
			} else {
				if(maxSize > i) {
					nextData = tmpList.get(i+1);
					if(data.get("HDNG_GBN").equals(nextData.get("HDNG_GBN")) && data.get("PROD_COND").equals(nextData.get("PROD_COND"))) {
						i++;
						header += "||" + Integer.toString((Integer)nextData.get("BAS_YY_SEQ"));
						cntn = (String)nextData.get("CNTN") + (String)nextData.get("CNTN2");
						rowData.put("CNTN2"  , cntn);
						rowData.put("ST_DT2", nextData.get("ST_DT1"));
						rowData.put("ED_DT2", nextData.get("ED_DT1"));
						if(nextData.get("ED_DT2") != null && !"".equals(nextData.get("ED_DT2"))) {
							cntn = (String)nextData.get("CNTN") + (String)nextData.get("CNTN2");
							rowData.put("CNTN3" , cntn);
							rowData.put("ST_DT3", nextData.get("ST_DT2"));
							rowData.put("ED_DT3", nextData.get("ED_DT2"));
						} else {
							if(maxSize > i) {
								nextData = tmpList.get(i+1);
								if(data.get("HDNG_GBN").equals(nextData.get("HDNG_GBN")) && data.get("PROD_COND").equals(nextData.get("PROD_COND"))) {
									cntn = (String)nextData.get("CNTN") + (String)nextData.get("CNTN2");
									rowData.put("CNTN3" , cntn);
									rowData.put("ST_DT3", nextData.get("ST_DT1"));
									rowData.put("ED_DT3", nextData.get("ED_DT1"));
									i++;
									header += "||" + Integer.toString((Integer)nextData.get("BAS_YY_SEQ"));
								}
							}
						}
					}
				}
			}
			String date1 = EgovDateUtil.formatDate2((String)rowData.remove("ST_DT1")) + "~" + EgovDateUtil.formatDate2((String)rowData.remove("ED_DT1"));
			rowData.put("DT1", date1);
			if((String)rowData.get("ST_DT2") != null && !"".equals((String)rowData.get("ST_DT2"))) {
				String date2 = EgovDateUtil.formatDate2((String)rowData.remove("ST_DT2")) + "~" + EgovDateUtil.formatDate2((String)rowData.remove("ED_DT2"));
				rowData.put("DT2", date2);
			} else {
				rowData.put("DT2", rowData.get("DT1"));
				rowData.put("CNTN2", rowData.get("CNTN1"));
			}

			if((String)rowData.get("ST_DT3") != null && !"".equals((String)rowData.get("ST_DT3"))) {
				String date3 = EgovDateUtil.formatDate2((String)rowData.remove("ST_DT3")) + "~" + EgovDateUtil.formatDate2((String)rowData.remove("ED_DT3"));
				rowData.put("DT3", date3);
			} else {
				rowData.put("DT3", rowData.get("DT2"));
				rowData.put("CNTN3", rowData.get("CNTN2"));
			}
			rowData.put("HEADER", header);
			tableList.add(rowData);
		}
		return tableList;
	}

	// 로우별 날짜(최대3개)로 그룹핑
	public List<List<Map<String, Object>>> listGroupBy(List<Map<String, Object>> tableList) {
		Map<String, List<Map<String, Object>>> table = tableList.stream().collect(Collectors.groupingBy((map) -> (String)map.get("HEADER")));

		int tableSize = table.size() > 0 ? table.size() : 0;
		List<List<Map<String, Object>>> tableLists = new ArrayList<List<Map<String, Object>>>(tableSize);

		for(String key : table.keySet()) {
			tableLists.add(table.get(key));
		}

		return tableLists;
	}
}
