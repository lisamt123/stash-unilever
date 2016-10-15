@isTest
public with sharing class Core_CA_BaseApplicationServicesTest {
      /* -- SONAR Issue explanation -- 
       This test class is calling Core_CA_BaseApplicationServices.cls that class has NPath complexity so test class is having Npath complexity.
     */ 
   
     @TestVisible static String strAriba= 'Ariba';
    @TestVisible static String strApp= 'APP';
    @TestVisible static String strPost= 'POST';
    @TestVisible static String strApproved='Approved';
    @TestVisible static String strApprover='Approver';
    @TestVisible static String strGtes= 'GTES';
    @TestVisible static String strGetExpenseDetailData='GetExpenseDetailData'; 
    @TestVisible static String strGetMyApprovalsData= 'GetMyApprovalsData';
    @TestVisible static String strStatus= 'Approver Added';
    @TestVisible static String strClosingTags= '}}';
    @TestVisible static String strClarity = 'Clarity';
    @TestVisible static String strInvoice = 'Invoice'; 
    
     static testmethod void invokeTest(){
     
        //Test data for Ariba     
        Core_Approval_Header__c headerObj=new Core_Approval_Header__c(Name= 'Test Ariba1' ,Source_System__c=strAriba,Invalid_PR__c= true,Invalid_PR_Reason__c='invalid');
        insert headerObj;
        System.assertEquals(strAriba,headerObj.Source_System__c,'Error');
        Core_Approver_Details__c approverObj=new Core_Approver_Details__c(Approval_Header__c=headerObj.Id,Interested_Party__c=Userinfo.getuserId(),Name=strApprover,Is_Active__c=true,Source_System__c=strAriba,Role__c=strApp);
        insert approverObj;
        System.assertEquals(strAriba,approverObj.Source_System__c,'Error');
     
        //Test data for GTES
        Core_Approval_Header__c objHeader = new Core_Approval_Header__c( Name = 'testHeader1', Source_System__c = strGtes, Status__c= strStatus,Manager__c = Userinfo.getuserId() ,
                                               Requested_By__c= Userinfo.getuserId(),Requested_For__c = Userinfo.getuserId(), Reminder_Alert_Days__c=0,Fully_Approved__c=false);
        insert objHeader;
        System.assertEquals(strGtes,objHeader.Source_System__c,'Error');
        Core_Approver_Details__c  objApprover = new Core_Approver_Details__c (Interested_Party__c = Userinfo.getuserId() ,Source_System__c = strGtes,Approval_Header__c =  objHeader.Id,
                                               Role__c = strApp,Action__c='ACTV');
        insert objApprover;
        System.assertEquals(strGtes,objApprover.Source_System__c,'Error');                     
        
        String jsonInput = '{"myApprovalsDataRequest": {"ExpenseStatus":"All","RecordsShownCount": 0,"ExpenseTypeSelected": "All"}}';
         System.assert(jsonInput != null);
        Core_CA_ApplicationWrapper remoteServCallObj = constructRequestBody(jsonInput, 'GetMyApprovalsData', strPost);
         System.assert(remoteServCallObj != null);
        
        Test.startTest();
             Core_CA_BaseApplicationServices.invokeService(remoteServCallObj);
              /* -- SONAR Issue explanation -- 
                  We can only access Status Code and success message because the return type of invokeService method is Core_CA_BaseApplicationWrapper
                  which contains only these two field. So we can't access any other fields.
             */
             System.assertEquals(200,Core_CA_BaseApplicationServices.invokeService(remoteServCallObj).statusCode,'error');
             System.assertEquals('SUCCESS',Core_CA_BaseApplicationServices.invokeService(remoteServCallObj).message,'error');
             System.assert(Core_CA_BaseApplicationServices.invokeService(remoteServCallObj) != null);

         Test.stopTest();
    }
    
    
     private static Core_CA_ApplicationWrapper constructRequestBody(String serviceJSONObject,String serviceName,String requestType){
        Core_CA_ApplicationWrapper serviceCallObj = new Core_CA_ApplicationWrapper();
        try{
            serviceCallObj.serviceJSONObjectasString = serviceJSONObject;
            serviceCallObj.serviceName = serviceName;
            serviceCallObj.requestType = requestType;
        }catch(Core_CA_BaseServiceException baseAppEx){ 
            throw new Core_CA_BaseServiceException('Exception occured: RemoteServiceCallController : constructRequestBody method11 ',baseAppEx);
        }
        
        return serviceCallObj;
    }
 
}