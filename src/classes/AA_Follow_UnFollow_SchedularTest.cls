/**
 * Name:        -   AA_Follow_UnFollow_Schedular _Test
 * @description -   This is the test class for AA_Follow_UnFollow_Schedular  Class to verify the Follow_UnFollow_Schedular  Class.
 * @Author      -   Ipsita     
 */
@isTest
public class AA_Follow_UnFollow_SchedularTest {
 public static String CRON_EXP = '0 0 0 3 9 ? 2022';

    static testMethod void Follow_UnFollow_SchedularTest() {
        aa_agent_app_custom_setting__c agentCustomSetting = new aa_agent_app_custom_setting__c();
        agentCustomSetting.Name = 'Follow Batch Last Run Time';
        insert agentCustomSetting;
        test.starttest();
                
        String sc = System.schedule('ScheduleApexClassTest',
                        CRON_EXP, 
                        new AA_Follow_UnFollow_Schedular());

        System.assert(CRON_EXP != sc ); 
        test.stoptest();
    }
}