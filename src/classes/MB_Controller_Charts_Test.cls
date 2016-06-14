/***************************************************************
Class Name: MB_Controller_Charts_Test.cls
Copyright © 2016 Salesforce

Purpose:
Requirement/Project Name: Unilever Salesforce Engagement
Requirement/Description: Test class For TEM app.

History:
VERSION     AUTHOR         DATE              DETAIL Description
1.0         Mindtree       30/05/2016        test class For TEM app
***************************************************************/

@IsTest
public class MB_Controller_Charts_Test{
  static testMethod void testControllerChartsWithCollegue(){
   
  Test.startTest();
       
  ID adminProfileID = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].ID;
  user  userObject1 = new User(username='firstuserdb@test.com',
                                  alias = 'fu',
                                  email ='firstuser@test.com',
                                  emailencodingkey = 'UTF-8',
                                  lastname = 'fuln',
                                  CommunityNickname = 'fucn',
                                  languagelocalekey = 'en_US',
                                  localesidkey = 'en_US',                                            
                                  profileid = adminProfileID,
                                  timezonesidkey = 'Europe/Berlin',
                                  country = 'India'
                                 );
  insert  userObject1;
      
  user  userObject2 = new User(username='seconduserdb@test.com',
                                  alias = 'su',
                                  email ='seconduser@test.com',
                                  emailencodingkey = 'UTF-8',
                                  lastname = 'suln',
                                  CommunityNickname = 'sucn',
                                  languagelocalekey = 'en_US',
                                  localesidkey = 'en_US',                                            
                                  profileid = adminProfileID,
                                  timezonesidkey = 'Europe/Berlin',
                                  country = 'India'
                                 );
  insert  userObject2;
 
  System.runAs(userObject1)
  {  
  MB_Device_Details__c deviceDetailsObject = new MB_Device_Details__c(Name = 'Nokia Lumia 625');
  insert deviceDetailsObject;
      
  MB_Usage_Type__c usageTypeObject1 = new MB_Usage_Type__c(Name = 'Calls');
  insert usageTypeObject1;
  MB_Usage_Type__c usageTypeObject2 = new MB_Usage_Type__c(Name = 'iPass');
  insert usageTypeObject2;
  MB_Usage_Type__c usageTypeObject3 = new MB_Usage_Type__c(Name = 'Data');
  insert usageTypeObject3;
  MB_Usage_Type__c usageTypeObject4 = new MB_Usage_Type__c(Name = 'Messaging');
  insert usageTypeObject4;
      
  MB_Charge_Type__c chargeTypeObject1 = new MB_Charge_Type__c(Name = 'Domestic Outgoing Calls');
  insert chargeTypeObject1;
  MB_Charge_Type__c chargeTypeObject2 = new MB_Charge_Type__c(Name = 'International Outgoing Calls');
  insert chargeTypeObject2;
  MB_Charge_Type__c chargeTypeObject3 = new MB_Charge_Type__c(Name = 'Domestic Wi-Fi Offloading');
  insert chargeTypeObject3;
  MB_Charge_Type__c chargeTypeObject4 = new MB_Charge_Type__c(Name = 'International Wi-Fi Offloading');
  insert chargeTypeObject4;
  MB_Charge_Type__c chargeTypeObject5 = new MB_Charge_Type__c(Name = 'Domestic Data');
  insert chargeTypeObject5;
  MB_Charge_Type__c chargeTypeObject6 = new MB_Charge_Type__c(Name = 'International Data');
  insert chargeTypeObject6;
  MB_Charge_Type__c chargeTypeObject7 = new MB_Charge_Type__c(Name = 'Domestic Outgoing SMS');
  insert chargeTypeObject7;
  MB_Charge_Type__c chargeTypeObject8 = new MB_Charge_Type__c(Name = 'International Outgoing SMS');
  insert chargeTypeObject8;    
      
      
  MB_Billing_Entity__c billingEntityObject1 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC1', Billing_Month__c = 'April 2016', Call_Minutes__c = 50.00, Data_Consumed_In_MB__c = 0.00, 
                                    iPass_Consumed_In_MB__c = 0.00, Item_Count__c = 10.00, Local_Net_Amount__c = 25.00, Messages__c = 0.00, Non_Usage_Consumed__c = 0.00, 
                                    Service_Name__c = 'SN1');
  billingEntityObject1.Device_Details__c = deviceDetailsObject.Id;
  billingEntityObject1.Usage_Type__c = usageTypeObject1.Id;
  billingEntityObject1.Charge_Type__c = chargeTypeObject1.Id;
  billingEntityObject1.User__c = UserInfo.getUserId();
  insert billingEntityObject1;
            
  MB_Billing_Entity__c billingEntityObject2 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC1', Billing_Month__c = 'April 2016', Call_Minutes__c = 50.00, Data_Consumed_In_MB__c = 0.00, 
                                    iPass_Consumed_In_MB__c = 0.00, Item_Count__c = 10.00, Local_Net_Amount__c = 25.00, Messages__c = 0.00, Non_Usage_Consumed__c = 0.00, 
                                    Service_Name__c = 'SN1');
  billingEntityObject2.Device_Details__c = deviceDetailsObject.Id;
  billingEntityObject2.Usage_Type__c = usageTypeObject1.Id;
  billingEntityObject2.Charge_Type__c = chargeTypeObject2.Id;
  billingEntityObject2.User__c = UserInfo.getUserId();
  insert billingEntityObject2;
            
  MB_Billing_Entity__c billingEntityObject3 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC2', Billing_Month__c = 'April 2016', Call_Minutes__c = 0.00, Data_Consumed_In_MB__c = 0.00, 
                                    iPass_Consumed_In_MB__c = 100.00, Item_Count__c = 10.00, Local_Net_Amount__c = 50.00, Messages__c = 0.00, Non_Usage_Consumed__c = 0.00, 
                                    Service_Name__c = 'SN2');
  billingEntityObject3.Device_Details__c = deviceDetailsObject.Id;
  billingEntityObject3.Usage_Type__c = usageTypeObject2.Id;
  billingEntityObject3.Charge_Type__c = chargeTypeObject3.Id;
  billingEntityObject3.User__c = UserInfo.getUserId();
  insert billingEntityObject3;
      
  MB_Billing_Entity__c billingEntityObject4 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC2', Billing_Month__c = 'April 2016', Call_Minutes__c = 0.00, Data_Consumed_In_MB__c = 0.00, 
                                    iPass_Consumed_In_MB__c = 100.00, Item_Count__c = 10.00, Local_Net_Amount__c = 50.00, Messages__c = 0.00, Non_Usage_Consumed__c = 0.00, 
                                    Service_Name__c = 'SN2');
  billingEntityObject4.Device_Details__c = deviceDetailsObject.Id;
  billingEntityObject4.Usage_Type__c = usageTypeObject2.Id;
  billingEntityObject4.Charge_Type__c = chargeTypeObject4.Id;
  billingEntityObject4.User__c = UserInfo.getUserId();
  insert billingEntityObject4;
     
  MB_Billing_Entity__c billingEntityObject5 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC3', Billing_Month__c = 'April 2016', Call_Minutes__c = 0.00, Data_Consumed_In_MB__c = 500.00, 
                                    iPass_Consumed_In_MB__c = 0.00, Item_Count__c = 25.00, Local_Net_Amount__c = 175.00, Messages__c = 0.00, Non_Usage_Consumed__c = 0.00, 
                                    Service_Name__c = 'SN3');
  billingEntityObject5.Device_Details__c = deviceDetailsObject.Id;
  billingEntityObject5.Usage_Type__c = usageTypeObject3.Id;
  billingEntityObject5.Charge_Type__c = chargeTypeObject5.Id;
  billingEntityObject5.User__c = UserInfo.getUserId();
  insert billingEntityObject5;
      
   MB_Billing_Entity__c billingEntityObject6 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC3', Billing_Month__c = 'April 2016', Call_Minutes__c = 0.00, Data_Consumed_In_MB__c = 500.00, 
                                    iPass_Consumed_In_MB__c = 0.00, Item_Count__c = 25.00, Local_Net_Amount__c = 175.00, Messages__c = 0.00, Non_Usage_Consumed__c = 0.00, 
                                    Service_Name__c = 'SN3');
  billingEntityObject6.Device_Details__c = deviceDetailsObject.Id;
  billingEntityObject6.Usage_Type__c = usageTypeObject3.Id;
  billingEntityObject6.Charge_Type__c = chargeTypeObject6.Id;
  billingEntityObject6.User__c = UserInfo.getUserId();
  insert billingEntityObject6;
      
  MB_Billing_Entity__c billingEntityObject7 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC4', Billing_Month__c = 'April 2016', Call_Minutes__c = 0.00, Data_Consumed_In_MB__c = 0.00, 
                                    iPass_Consumed_In_MB__c = 0.00, Item_Count__c = 30.00, Local_Net_Amount__c = 75.00, Messages__c = 90.00, Non_Usage_Consumed__c = 0.00, 
                                    Service_Name__c = 'SN4');
  billingEntityObject7.Device_Details__c = deviceDetailsObject.Id;
  billingEntityObject7.Usage_Type__c = usageTypeObject4.Id;
  billingEntityObject7.Charge_Type__c = chargeTypeObject7.Id;
  billingEntityObject7.User__c = UserInfo.getUserId();
  insert billingEntityObject7;
      
  MB_Billing_Entity__c billingEntityObject8 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC4', Billing_Month__c = 'April 2016', Call_Minutes__c = 0.00, Data_Consumed_In_MB__c = 0.00, 
                                    iPass_Consumed_In_MB__c = 0.00, Item_Count__c = 30.00, Local_Net_Amount__c = 75.00, Messages__c = 90.00, Non_Usage_Consumed__c = 0.00, 
                                    Service_Name__c = 'SN4');
  billingEntityObject8.Device_Details__c = deviceDetailsObject.Id;
  billingEntityObject8.Usage_Type__c = usageTypeObject4.Id;
  billingEntityObject8.Charge_Type__c = chargeTypeObject8.Id;
  billingEntityObject8.User__c = UserInfo.getUserId();
  insert billingEntityObject8;
  
  MB_Wrapper_Class.MB_Device_Wrapper_Class deviceWrapperClassObject1 = new MB_Wrapper_Class.MB_Device_Wrapper_Class();
  deviceWrapperClassObject1 = MB_Controller_Charts.getChargeType('April 2016', deviceDetailsObject.Id);

  System.assertEquals(deviceWrapperClassObject1.totalDomesticDataUsage,500.00); 	
  System.assertEquals(deviceWrapperClassObject1.totalInternationalDataUsage,500.00); 	
  System.assertEquals(deviceWrapperClassObject1.totalDomesticCallUsage,50.00); 	
  System.assertEquals(deviceWrapperClassObject1.totalDomesticSMSUsage,90.00); 
  System.assertEquals(deviceWrapperClassObject1.totalInternationalSMSUsage,90.00); 	
  System.assertEquals(deviceWrapperClassObject1.totalDomesticIpassUsage,100.00); 	
  System.assertEquals(deviceWrapperClassObject1.totalInternationalCallUsage,50.00); 	
  System.assertEquals(deviceWrapperClassObject1.totalInternationalIpassUsage,100.00); 
      
  MB_Billing_Entity__c billingEntityObject9 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC1', Billing_Month__c = 'April 2016', Call_Minutes__c = 50.00, Data_Consumed_In_MB__c = 0.00, 
                                    iPass_Consumed_In_MB__c = 0.00, Item_Count__c = 10.00, Local_Net_Amount__c = 25.00, Messages__c = 0.00, Non_Usage_Consumed__c = 0.00, 
                                    Service_Name__c = 'SN1');
  billingEntityObject9.Device_Details__c = deviceDetailsObject.Id;
  billingEntityObject9.Usage_Type__c = usageTypeObject1.Id;
  billingEntityObject9.Charge_Type__c = chargeTypeObject1.Id;
  billingEntityObject9.User__c =  userObject2.Id;
  insert billingEntityObject9;
            
  MB_Billing_Entity__c billingEntityObject10 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC2', Billing_Month__c = 'April 2016', Call_Minutes__c = 0.00, Data_Consumed_In_MB__c = 0.00, 
                                    iPass_Consumed_In_MB__c = 100.00, Item_Count__c = 10.00, Local_Net_Amount__c = 50.00, Messages__c = 0.00, Non_Usage_Consumed__c = 0.00, 
                                    Service_Name__c = 'SN2');
  billingEntityObject10.Device_Details__c = deviceDetailsObject.Id;
  billingEntityObject10.Usage_Type__c = usageTypeObject2.Id;
  billingEntityObject10.Charge_Type__c = chargeTypeObject3.Id;
  billingEntityObject10.User__c = userObject2.Id;
  insert billingEntityObject10;
      
   MB_Billing_Entity__c billingEntityObject11 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC3', Billing_Month__c = 'April 2016', Call_Minutes__c = 0.00, Data_Consumed_In_MB__c = 500.00, 
                                    iPass_Consumed_In_MB__c = 0.00, Item_Count__c = 25.00, Local_Net_Amount__c = 175.00, Messages__c = 0.00, Non_Usage_Consumed__c = 0.00, 
                                    Service_Name__c = 'SN3');
  billingEntityObject11.Device_Details__c = deviceDetailsObject.Id;
  billingEntityObject11.Usage_Type__c = usageTypeObject3.Id;
  billingEntityObject11.Charge_Type__c = chargeTypeObject5.Id;
  billingEntityObject11.User__c = userObject2.Id;
  insert billingEntityObject11;
      
  MB_Billing_Entity__c billingEntityObject12 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC4', Billing_Month__c = 'April 2016', Call_Minutes__c = 0.00, Data_Consumed_In_MB__c = 0.00, 
                                    iPass_Consumed_In_MB__c = 0.00, Item_Count__c = 30.00, Local_Net_Amount__c = 75.00, Messages__c = 90.00, Non_Usage_Consumed__c = 0.00, 
                                    Service_Name__c = 'SN4');
  billingEntityObject12.Device_Details__c = deviceDetailsObject.Id;
  billingEntityObject12.Usage_Type__c = usageTypeObject4.Id;
  billingEntityObject12.Charge_Type__c = chargeTypeObject7.Id;
  billingEntityObject12.User__c = userObject2.Id;
  insert billingEntityObject12;
  
  MB_Billing_Entity__c billingEntityObject13 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC4', Billing_Month__c = 'March 2016', Call_Minutes__c = 0.00, Data_Consumed_In_MB__c = 0.00, 
                                    iPass_Consumed_In_MB__c = 0.00, Item_Count__c = 30.00, Local_Net_Amount__c = 75.00, Messages__c = 90.00, Non_Usage_Consumed__c = 0.00, 
                                    Service_Name__c = 'SN4');
  billingEntityObject13.Device_Details__c = deviceDetailsObject.Id;
  billingEntityObject13.Usage_Type__c = usageTypeObject4.Id;
  billingEntityObject13.Charge_Type__c = chargeTypeObject8.Id;
  billingEntityObject13.User__c = userObject2.Id;
  insert billingEntityObject13;
      
  MB_Billing_Entity__c billingEntityObject14 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC2', Billing_Month__c = 'February 2016', Call_Minutes__c = 0.00, Data_Consumed_In_MB__c = 0.00, 
                                    iPass_Consumed_In_MB__c = 100.00, Item_Count__c = 10.00, Local_Net_Amount__c = 50.00, Messages__c = 0.00, Non_Usage_Consumed__c = 0.00, 
                                    Service_Name__c = 'SN2');
  billingEntityObject14.Device_Details__c = deviceDetailsObject.Id;
  billingEntityObject14.Usage_Type__c = usageTypeObject2.Id;
  billingEntityObject14.Charge_Type__c = chargeTypeObject3.Id;
  billingEntityObject14.User__c = userObject2.Id;
  insert billingEntityObject14;
      
  MB_Wrapper_Class.MB_Device_Wrapper_Class deviceWrapperClassObject2 = new MB_Wrapper_Class.MB_Device_Wrapper_Class();
  deviceWrapperClassObject2 = MB_Controller_Charts.getyourCollegueChargeType('April 2016'); 
      
  System.assertEquals(deviceWrapperClassObject2.totalAverageCallUsage,25.00); 
  System.assertEquals(deviceWrapperClassObject2.totalAverageDataUsage,250.00); 	
  System.assertEquals(deviceWrapperClassObject2.totalAverageIpassUsage,50.00);	
  System.assertEquals(deviceWrapperClassObject2.totalAverageMessageUsage,45.00); 	
  System.assertEquals(deviceWrapperClassObject2.totalCallUsage,100.00); 
  System.assertEquals(deviceWrapperClassObject2.totalDataUsage,1000.00); 	  
  System.assertEquals(deviceWrapperClassObject2.totalMessageUsage,180.00);
  System.assertEquals(deviceWrapperClassObject2.totalIpassUsage,200.00);
         
  MB_Wrapper_Class.MB_Device_Wrapper_Class deviceWrapperClassObject3 = new MB_Wrapper_Class.MB_Device_Wrapper_Class();
  deviceWrapperClassObject3 = MB_Controller_Charts.getyourCollegueChargeType('March 2016');
  
  System.assertEquals(deviceWrapperClassObject3.totalAverageCallUsage,0.00); 
  System.assertEquals(deviceWrapperClassObject3.totalAverageDataUsage,0.00); 	
  System.assertEquals(deviceWrapperClassObject3.totalAverageIpassUsage,0.00);	
  System.assertEquals(deviceWrapperClassObject3.totalAverageMessageUsage,90.00); 	
  System.assertEquals(deviceWrapperClassObject3.totalCallUsage,0.00); 
  System.assertEquals(deviceWrapperClassObject3.totalDataUsage,0.00); 	  
  System.assertEquals(deviceWrapperClassObject3.totalMessageUsage,0.00);
  System.assertEquals(deviceWrapperClassObject3.totalIpassUsage,0.00);
        
  MB_Wrapper_Class.MB_Device_Wrapper_Class deviceWrapperClassObject4 = new MB_Wrapper_Class.MB_Device_Wrapper_Class();
  deviceWrapperClassObject4 = MB_Controller_Charts.getyourCollegueChargeType('February 2016');
  
  System.assertEquals(deviceWrapperClassObject4.totalAverageCallUsage,0.00); 
  System.assertEquals(deviceWrapperClassObject4.totalAverageDataUsage,0.00); 	
  System.assertEquals(deviceWrapperClassObject4.totalAverageIpassUsage,100.00);	
  System.assertEquals(deviceWrapperClassObject4.totalAverageMessageUsage,0.00); 	
  System.assertEquals(deviceWrapperClassObject4.totalCallUsage,0.00); 
  System.assertEquals(deviceWrapperClassObject4.totalDataUsage,0.00); 	  
  System.assertEquals(deviceWrapperClassObject4.totalMessageUsage,0.00);
  System.assertEquals(deviceWrapperClassObject4.totalIpassUsage,0.00);
      
  MB_Wrapper_Class.MB_Device_Wrapper_Class deviceWrapperClassObject5 = new MB_Wrapper_Class.MB_Device_Wrapper_Class();
  deviceWrapperClassObject5 = MB_Controller_Charts.getyourCollegueChargeType('January 2016');
  System.assertEquals(deviceWrapperClassObject5,null);
  }    
                         
  Test.stopTest();
  }
}