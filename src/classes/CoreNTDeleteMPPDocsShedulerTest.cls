@isTest
public with sharing class CoreNTDeleteMPPDocsShedulerTest {
	public static testMethod void myTestMethod() {
		Test.StartTest();
		SchedulableContext sc;
		CoreNTDeleteMPPDocsScheduler shedulerObj=new CoreNTDeleteMPPDocsScheduler();
		shedulerObj.execute(sc);
		Test.StopTest();
	}
}