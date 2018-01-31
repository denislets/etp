package com.peterservice.etp.lets.denis.traineeship.servicedesk.web;

import static org.junit.Assert.*;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.runners.MockitoJUnitRunner;

@RunWith(MockitoJUnitRunner.class)
public class HealthControllerTest {
	@InjectMocks
	private HealthController testee;

	@Test
	public void whenAnswerToIsNullThenResponseShouldBeSimpleOk() {
		String response = testee.check(null);
		assertEquals("response", "I'm OK!" , response);
	}
	
	@Test
	public void whenAnswerToIsEmptyThenResponseShouldBeSimpleOk() {
		String response = testee.check("");
		assertEquals("response", "I'm OK!" , response);
	}
	
	@Test
	public void whenAnswerToIsNotEmptyhenResponseShouldBeOkWithName() {
		String response = testee.check("honey");
		assertEquals("response", "I'm OK, honey!" , response);
	}

}
