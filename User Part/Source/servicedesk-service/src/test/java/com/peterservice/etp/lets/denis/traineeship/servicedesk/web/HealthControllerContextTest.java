package com.peterservice.etp.lets.denis.traineeship.servicedesk.web;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

@RunWith(SpringRunner.class)
@WebAppConfiguration
@ContextConfiguration("classpath:spring/servlet-context.xml")
public class HealthControllerContextTest {
	@Autowired
	private WebApplicationContext wac;
	
	private MockMvc mockMvc;
	
	@Before
	public void setup() {
		this.mockMvc = MockMvcBuilders.webAppContextSetup(this.wac).build();
	}

	@Test
	public void checkMethodShouldBeMapped() throws Exception{
		mockMvc.perform(get("/health/check?answerTo=honey")).andExpect(status().isOk());
	}
	
	@Test
	public void answerToParameterShouldBeMapped() throws Exception{
		mockMvc.perform(get("/health/check?answerTo=honey")).andExpect(status().isOk()).andExpect(content().string("I'm OK, honey!"));
	}
	
	@Test
	public void answerToParameterShouldBeOptional() throws Exception{
		mockMvc.perform(get("/health/check")).andExpect(status().isOk()).andExpect(content().string("I'm OK!"));
	}

}
