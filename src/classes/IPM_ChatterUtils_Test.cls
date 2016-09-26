/******************************************** 
   @Author:Cognizant
   @name:ChatterUtils_Test
   @CreateDate:02/09/2015
   @Description:Test class to test IPM_ChatterUtils Class
   @Version:1.0
   @reference: 
*********************************************/

@isTest
private class IPM_ChatterUtils_Test {
    
    private static List<IPM_Project__c> ipmProjectList;
    private static User standardUser = IPM_TestFactory_Helper.createUser(true); 
    private static Set<Id> iDs;
    private static final String PROJECT_NOT_INSERTED = 'Projects not Inserted';
    private static final String FEED_UPDATED_NOT_ASSERTED = 'Feed not Updated';
    private static final String PROJ_NOT_EQUAL= 'Projects are not equal';
    private static final String TEST_STR='test Message';
    
    /***********************************
      Description of the purpose of the method. 
      @name: initializeData
      @Description: Test Data Creation
      @param: none
      @return: none
      @throws: none
    ***********************************/    
    static void initializeData(){
    	iDs = new Set<Id>();
        ipmProjectList = IPM_TestFactory_Helper.createIPMProjectList(true, 20);
        iDs.clear();
        for(IPM_Project__c eachProj : ipmProjectList) {
           iDs.add(eachProj.Id);
        }
        System.assertEquals(20, [Select count() from IPM_Project__c where id in:iDs],PROJECT_NOT_INSERTED);
    }
    
    /***********************************
      Description of the purpose of the method. 
      @name: testChatterUtils
      @Description: To test postChatterFeedWithMention method
      @param: none
      @return: none
      @throws: none
    ***********************************/
    static testMethod void testChatterUtils(){
        system.runAs(standardUser){
            initializeData();
            Set<Id> subjectIdSet = new Set<Id>();
            Map<Id, String> subjectIdMessageMap = new Map<Id, String>();
            Map<Id,Set<Id>> subjectIdMentionIdSetMap = new Map<Id,Set<Id>>();
            Set<Id> userIdSet = new Set<Id>();
            
            List<IPM_Project__c> projectlist = [select Id, Name, IPM_Project_Leader__c from IPM_Project__c where id =:ipmProjectList[0].Id limit 1];
            system.assertEquals(projectlist[0].Id,ipmProjectList[0].Id,PROJ_NOT_EQUAL);
            
            for(IPM_Project__c ipm:ipmprojectlist){
                if(ipm.IPM_Project_Leader__c != null){
                    userIdSet.add(ipm.IPM_Project_Leader__c);
               }
               subjectIdSet.add(ipm.Id);
               subjectIdMentionIdSetMap.put(ipm.id,userIdSet);
               subjectIdMessageMap.put(ipm.id,TEST_STR);
            }
            Test.startTest();
                IPM_ChatterUtils.postChatterFeedWithMention(subjectIdSet, subjectIdMessageMap, subjectIdMentionIdSetMap);
                for(IPM_Project__Feed projectFeed : [SELECT Body,ParentId,CreatedDate,CreatedById FROM IPM_Project__Feed limit 50000])
             	{
             		//Check whether the chatter post has been made correctly
                	System.assert(projectFeed.Body.contains(TEST_STR),FEED_UPDATED_NOT_ASSERTED);
             	}  
            Test.stopTest();
       }
       
    }
    

}