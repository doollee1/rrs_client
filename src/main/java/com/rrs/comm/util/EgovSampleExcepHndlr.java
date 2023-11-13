package com.rrs.comm.util;

import egovframework.rte.fdl.cmmn.exception.handler.ExceptionHandler;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.rrs.comm.util.EgovSampleExcepHndlr;

public class EgovSampleExcepHndlr implements ExceptionHandler {
  private static final Logger LOGGER = LoggerFactory.getLogger(EgovSampleExcepHndlr.class);
  
  public void occur(Exception ex, String packageName) {
    LOGGER.debug(" EgovServiceExceptionHandler run...............");
  }
}
