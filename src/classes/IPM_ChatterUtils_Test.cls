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
    
    public static List<IPM_Project__c> ipmProjectList;
    public static User standardUser = IPM_TestFactory_Helper.createUser(true); 
    
    /***********************************
      Description of the purpose of the method. 
      @name: initializeData
      @Description: Test Data Creation
      @param: none
      @return: none
      @throws: none
    ***********************************/    
    static void initializeData(){
        ipmProjectList = IPM_TestFactory_Helper.createIPMProjectList(true, 20);
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
            system.assertEquals(projectlist[0].Id,ipmProjectList[0].Id);
            
            for(IPM_Project__c ipm:ipmprojectlist){
                if(ipm.IPM_Project_Leader__c != null){
                    userIdSet.add(ipm.IPM_Project_Leader__c);
               }
               subjectIdSet.add(ipm.Id);
               subjectIdMentionIdSetMap.put(ipm.id,userIdSet);
               subjectIdMessageMap.put(ipm.id,'test Message');
            }
            Test.startTest();
                IPM_ChatterUtils.postChatterFeedWithMention(subjectIdSet, subjectIdMessageMap, subjectIdMentionIdSetMap);
            Test.stopTest();
       }
       
    }
    

}