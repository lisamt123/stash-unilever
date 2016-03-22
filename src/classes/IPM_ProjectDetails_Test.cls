/**
* @author       Cognizant 
* @date         19/01/2016
* @description  This class is used to test the functionality of IPM_ProjectDetails class 
*/
@isTest
private class IPM_ProjectDetails_Test {
 
    /**
    *  To test IPM_ProjectDetails class
    *  @name :test_IPM_ProjectDetails_Test
    *  @param : nil
    *  @return : nil
    */
    private static final String PROJECT_NAME = 'Test_Project';
    private static final boolean IS_BOSS = TRUE;
    private static final boolean IS_BOSS_PRESENT = TRUE;
    
    public static testmethod void test_IPM_ProjectDetails_Test()
    {
        IPM_ProjectDetails projectDetails = new IPM_ProjectDetails();
        Test.startTest();
            projectDetails.ProjectName = PROJECT_NAME;
            projectDetails.isBoss = IS_BOSS;
            projectDetails.isBossPresent = IS_BOSS_PRESENT;
            // as it is warapper class, so no need to query before asserting
            system.assertEquals(projectDetails.ProjectName, 'Test_Project', 'Project name doesn\'t match');
            system.assertEquals(projectDetails.isBoss, TRUE, 'Boss aren\'t same');
            system.assertEquals(projectDetails.isBossPresent, TRUE, 'Boos is not present');
        Test.stopTest();
    }

}