package com.peterservice.etp.lets.denis.traineeship.servicedesk.web;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class HealthController {
	
	@RequestMapping(value="health/check", method = RequestMethod.GET)
	@ResponseBody
	public String check(@RequestParam(value="answerTo", required=false) String answerTo) {
		return "I'm OK" + (!StringUtils.isEmpty(answerTo) ? ", " + answerTo : "") + "!";
	}

}
