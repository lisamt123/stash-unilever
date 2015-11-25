/*******************************************************
 * @Description: Test class for Data Sharing Prototype
 * @Author:Cognizant
 * @Date:10/11/2015
 * *****************************************************/
@isTest
private class IPM_SampleTestProjShare {

   public static User loginUser;
   public static List<User> userList;
   public static List<IPM_Project__c> projectList;
    /**
        *  Used for Setting test Data for Project Creation . 
        *  @name projectSetUp
    */
    
     @testSetup static void projectSetUp() 
     {
        User userobj = IPM_TestFactory_Helper.createUser(false);
        userobj.email = 'globalUser@unilever.test.com';
        insert userobj;
        system.AssertEquals(userobj.Id,[SELECT id FROM User where id =:userobj.Id].id,'User creation failed' );
        
        projectList = IPM_TestFactory_Helper.createIPMProjectList(false,3);
                
        System.runAs(userobj) 
        {
            for(IPM_Project__c p:projectList){
                p.IPM_Project_Leader__c = userobj.Id;
            }
            insert projectList;  
            
            List<IPM_Project__c> insertedProjectList =  new List<IPM_Project__c>([SELECT id, Name FROM IPM_Project__c where id IN:projectList]);            
			system.AssertEquals(3,insertedProjectList.size(),'Project creation failed');   			            
        }                  
     }
     
     static testMethod void AsynTest() {
        Set<String> projectNameSet = new Set<String>{'TestComments1', 'TestComments2', 'TestComments3'};
        set<id> projidset = new set<id>();
        User userobj = [Select Id from user where email = 'globalUser@unilever.test.com'];
        List<IPM_Project__c> updatedprojectList;
        IPM_Project__c ProjectRec;
        
        System.runAs(userobj)
        {
            Test.startTest();
            
            updatedprojectList = [Select Id,owner.type,ownerid,IPM_Project_Leader__c,IPM_Phase__c,Name,IPM_Complexity__c from IPM_Project__c where Name in:projectNameSet];
            system.AssertNOTEquals(0,updatedprojectList.size());

            ProjectRec = updatedprojectList[0];        
            System.AssertEquals('Queue', ProjectRec.owner.type,'Project owner is not updated to Queue');
            
            Test.stopTest();
        }
        
        boolean memexists=false;
        list<GroupMember> memberList = new List<GroupMember>([SELECT Id, UserOrGroupId, GroupId FROM GroupMember WHERE GroupId =: ProjectRec.ownerid LIMIT 100]);  
        for(GroupMember memid:memberList)
        {
            if(memid.UserOrGroupId == userobj.id) 
            {
            	memexists =true;
            }
        }
        System.AssertEquals(true, memexists,'User is not a member of the queue');
    }

}