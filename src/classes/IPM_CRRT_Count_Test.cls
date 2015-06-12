@isTest
public class IPM_CRRT_Count_Test{

public static IPM_CRRT_Count ipm_crrt_count;

public static testMethod void displayCRRTCountsTest(){
Test.startTest();
ipm_crrt_count=new IPM_CRRT_Count();
ipm_crrt_count.displayCRRTCounts();
Test.stopTest();
}

}