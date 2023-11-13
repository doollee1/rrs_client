package com.rrs.comm.util;

import egovframework.rte.fdl.cmmn.exception.handler.ExceptionHandler;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.rrs.comm.util.EgovSampleOthersExcepHndlr;

public class EgovSampleOthersExcepHndlr implements ExceptionHandler {
  private static final Logger LOGGER = LoggerFactory.getLogger(EgovSampleOthersExcepHndlr.class);
  
  public void occur(Exception exception, String packageName) {
    LOGGER.debug(" EgovServiceExceptionHandler run...............");
  }
}
