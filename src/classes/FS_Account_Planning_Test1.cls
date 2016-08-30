/**********************************************************************
Purpose: Test class for OpportunityTrigger.
History :
VERSION  AUTHOR         DATE          DETAIL Description
1.0     Accenture     13/July/2016     Created
                          
***********************************************************************/
@isTest
public class FS_Account_Planning_Test1 {
    @testSetup static void setupTestData(){
        String profile='System Administrator';
        String permissionset='FS_Sales_Rep';         
        Profile p = [SELECT Id FROM Profile WHERE Name=:profile];
        Userrole role=[SELECT Id FROM UserRole WHERE Name = 'FS 59040 Sales Rep'];
        User SalesRepUser1 = new User(Alias = 'newUser', Email='newuser1@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,UserRoleId=role.id,
        TimeZoneSidKey='America/Los_Angeles', UserName='newuseropphelper1@testorg.com');
        insert SalesRepUser1;
        User SalesRepUser = new User(Alias = 'newUser', Email='newuser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,UserRoleId=role.id,ManagerId = SalesRepUser1.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='newuseropphelper@testorg.com');
        insert SalesRepUser;
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name =:permissionset];
        PermissionSetAssignment psetassignment = new PermissionSetAssignment();
        psetassignment.AssigneeId = SalesRepUser.Id;
        psetassignment.PermissionSetId = ps.Id;
        insert psetassignment;      
        system.runAs(SalesRepUser){
            //Set up Custom settings for Opportunity Trigger
            FSOpportunityTriggerSettings__c OppCustomSettings=new FSOpportunityTriggerSettings__c(name='isEnabled',Enabled__c=true);
            insert OppCustomSettings;
            
            // Set up the Account records
            List<Account> accounts = new List<Account>();
            RecordType Acc_rt = [select id,Name from RecordType where SobjectType='Account' and Name='Operator' Limit 1];
            for(Integer i=0;i<5;i++){
               accounts.add(new Account(Name ='FS_Acc_Plan_'+i,recordtypeid=Acc_rt.id));
            }
            system.debug(accounts);
             insert accounts;              
            //Set up account plan records
            RecordType AccPlan_rt = [select id,Name from RecordType where SobjectType='FS_Account_Plan__c' and Name='Operator' Limit 1];
            List<FS_Account_Plan__c> AccPlanList = new List<FS_Account_Plan__c>();
            for(Account acc:accounts){
                AccPlanList.add(new FS_Account_Plan__c(FS_Customer__c=acc.id,FS_Status__c='Planning',FS_Start_Date__c=date.today(),FS_End_Date__c=date.today(),RecordTypeid=AccPlan_rt.Id));
            }           
          insert AccPlanList;
            //Added from here
            
        
            //Set up defined objective
            RecordType Obj_rt = [select id,Name from RecordType where SobjectType='FS_Defined_objective__c' and Name='Operator Objective' Limit 1];
            List<FS_Defined_Objective__c> ObjList=new List<FS_Defined_Objective__c>(); 
            for(FS_Account_Plan__C AccPlan:AccPlanList){
                for(integer i=0;i<5;i++){
                ObjList.add(new FS_Defined_Objective__c(FS_Account_Plan__c=AccPlan.id,FS_Customer__c=AccPlan.FS_Customer__c,FS_Status__C='Planning',RecordTypeid=Obj_rt.Id));
            }
            }
            insert ObjList;
                 
           }//End of system.runas
     }//End of test data set up
    //Test Method for Approved
    Static TestMethod Void AccPlanUnitTest1(){
        Integer i=0;
            List<FS_Account_Plan__c> AccPlanList_To_Approve=new List<FS_Account_Plan__c>();
            List<FS_Account_Plan__c> AccPlanList_To_Submit=new List<FS_Account_Plan__c>();
        	List<FS_Account_Plan__c> AccPlanList_To_Reject=new List<FS_Account_Plan__c>();
            List<FS_Account_Plan__c> AccPlanList=[select id,name,FS_Status__c,FS_approved__c from FS_Account_Plan__c];
            for(FS_Account_Plan__c AccPlan : AccPlanList){                
                    AccPlan.FS_Status__c='Approval Requested';                    
                    AccPlanList_To_Submit.add(AccPlan);                                                 
            }
            Update AccPlanList_To_Submit;
            List<FS_Account_Plan__c> AccPlanList_After_Approval=[select id,name,FS_Status__c,FS_approved__c from FS_Account_Plan__c];
            i=0;
            for(FS_Account_Plan__c AccPlan : AccPlanList_After_Approval){
                if(i<5){
                    AccPlan.FS_Status__c='Approved';
                    AccPlan.FS_approved__c=true;
                    AccPlanList_To_Approve.add(AccPlan);
                    i++;
                }
                if(i>5){
                    AccPlan.FS_Status__c='Planning';                    
                    AccPlanList_To_Approve.add(AccPlan);
                    i++;
                }
            }
            Test.startTest();
            //Cause Opportunity trigger to fire
            Update AccPlanList_To_Approve;
            Test.stopTest();
    }
    //Test method for Rejected
    Static TestMethod Void AccPlanUnitTest2(){
        Integer i=0;
            List<FS_Account_Plan__c> AccPlanList_To_Approve=new List<FS_Account_Plan__c>();
            List<FS_Account_Plan__c> AccPlanList_To_Submit=new List<FS_Account_Plan__c>();
        	List<FS_Account_Plan__c> AccPlanList_To_Reject=new List<FS_Account_Plan__c>();
            List<FS_Account_Plan__c> AccPlanList=[select id,name,FS_Status__c,FS_approved__c from FS_Account_Plan__c];
            for(FS_Account_Plan__c AccPlan : AccPlanList){                
                    AccPlan.FS_Status__c='Approval Requested';                    
                    AccPlanList_To_Submit.add(AccPlan);                                                 
            }
            Update AccPlanList_To_Submit;
            List<FS_Account_Plan__c> AccPlanList_After_Approval=[select id,name,FS_Status__c,FS_approved__c from FS_Account_Plan__c];
            i=0;
            for(FS_Account_Plan__c AccPlan : AccPlanList_After_Approval){
                    AccPlan.FS_Status__c='Planning';
                    AccPlan.FS_approved__c=true;
                    AccPlanList_To_Approve.add(AccPlan);
                    i++;  i++;
                }
            Test.startTest();
            //Cause Opportunity trigger to fire
            Update AccPlanList_To_Approve;
            Test.stopTest();
    }

}