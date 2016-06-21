/*
Class Name: MB_DeleteBillingData_Test
Author : Mindtree
Date: 15 May 2016
Requirement/Project Name: Unilever Salesforce Engagement
Requirement/Description: Test Class For MB_DeleteBillingData_Batch.
*/
@IsTest
public class MB_DeleteBillingData_Test {


  static testMethod void testDeleteBillingData(){
  Test.startTest();
      
  ID adminProfileID = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].ID;
  user  userObject1 = new User(username='firstuserdb@test.com',
                                  alias = 'fu',
                                  email ='firstuser@test.com',
                                  emailencodingkey = 'UTF-8',
                                  firstname = 'fufn',
                                  lastname = 'fuln',
                                  CommunityNickname = 'fucn',
                                  languagelocalekey = 'en_US',
                                  localesidkey = 'en_US',                                            
                                  profileid = adminProfileID,
                                  timezonesidkey = 'Europe/Berlin',
                                  country = 'India'
                                 );
  insert  userObject1;
      
  System.runAs(userObject1)
  {  
  
  MB_Device_Details__c deviceDetailsObject = new MB_Device_Details__c(Name = 'Nokia Lumia 625');
  insert deviceDetailsObject;
      
  MB_Usage_Type__c usageTypeObject1 = new MB_Usage_Type__c(Name = 'Calls');
  insert usageTypeObject1;
     
  MB_Charge_Type__c chargeTypeObject1 = new MB_Charge_Type__c(Name = 'Domestic Outgoing Calls');
  insert chargeTypeObject1;
 
  MB_Billing_Entity__c billingEntityObject1 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC1', Billing_Month__c = 'November 2015', Call_Minutes__c = 50.00, Data_Consumed_In_MB__c = 0.00, 
                                    iPass_Consumed_In_MB__c = 0.00, Item_Count__c = 5.00, Local_Net_Amount__c = 25.00, Messages__c = 0.00, Non_Usage_Consumed__c = 0.00, 
                                    Service_Name__c = 'SN1');
  billingEntityObject1.Device_Details__c = deviceDetailsObject.Id;
  billingEntityObject1.Usage_Type__c = usageTypeObject1.Id;
  billingEntityObject1.Charge_Type__c = chargeTypeObject1.Id;
  billingEntityObject1.User__c = UserInfo.getUserId();
  insert billingEntityObject1;
      
  MB_Billing_Entity__c billingEntityObject2 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC2', Billing_Month__c = 'May 2016', Call_Minutes__c = 150.00, Data_Consumed_In_MB__c = 0.00, 
                                    iPass_Consumed_In_MB__c = 0.00, Item_Count__c = 15.00, Local_Net_Amount__c = 75.00, Messages__c = 0.00, Non_Usage_Consumed__c = 0.00, 
                                    Service_Name__c = 'SN1');
  billingEntityObject2.Device_Details__c = deviceDetailsObject.Id;
  billingEntityObject2.Usage_Type__c = usageTypeObject1.Id;
  billingEntityObject2.Charge_Type__c = chargeTypeObject1.Id;
  billingEntityObject2.User__c = UserInfo.getUserId();
  insert billingEntityObject2;
  
  List<MB_Billing_Entity__c> billingEntityList = new List<MB_Billing_Entity__c>();
  billingEntityList.add(billingEntityObject1);
  billingEntityList.add(billingEntityObject2);
      
 
      //MB_ScheduleBillingDataDeletion_Batch batchObj =new MB_ScheduleBillingDataDeletion_Batch();
       system.schedule('my batch job', '0 0 0 1 4 ?', new MB_ScheduleBillingDataDeletion_Batch() );
      
      //String caseJSON = '{"attributes":"type":"CasSe","url":"/services/data/v25.0/sobjects/Case/500E0000002nH2fIAE"},"Id":"500E0000002nH2fIAE","Status":"Closed","CreatedDate":"2012-10-04T17:54:26.000+0000", "ClosedDate":"2012-10-04T17:54:26.000+0000","Reason":"Spam"}'; 
//Case c = (Case) JSON.deserialize(caseJSON, Case.class );
      
       /*MB_DeleteBillingData_Batch batchObject1 = new MB_DeleteBillingData_Batch();
  		//Database.BatchableContext batchContext;
      	Database.executeBatch(batchObject1);*/
      
  System.assert(billingEntityList != null,'billingEntityList cannot be null');
  //batchObject.start(batchContext);
  //batchObject.finish(batchContext);  
  }
      
  Test.stopTest();
  }   
}