/***************************************************************
Class Name: MB_Controller_Class_Test.cls
Copyright © 2016 Salesforce

Purpose:
Requirement/Project Name: Unilever Salesforce Engagement
Requirement/Description: Test class For TEM app.

History:
VERSION     AUTHOR         DATE              DETAIL Description
1.0         Mindtree       27/05/2016        test class For TEM app
***************************************************************/

@IsTest
public with sharing class MB_Controller_Class_Test {
  static testMethod void testMBControllerClass(){
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
  
  String previousMonth1 = MB_Controller_Class.getPreviousMonth('January 2016');
  System.assertEquals(previousMonth1, 'December 2015');
    
  String previousMonth2 = MB_Controller_Class.getPreviousMonth('April 2016');
  System.assertEquals(previousMonth2, 'March 2016');
    
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
  MB_Usage_Type__c usageTypeObject5 = new MB_Usage_Type__c(Name = 'Recurring');
  insert usageTypeObject5;
      
  MB_Charge_Type__c chargeTypeObject1 = new MB_Charge_Type__c(Name = 'Domestic Outgoing Calls');
  insert chargeTypeObject1;
  MB_Charge_Type__c chargeTypeObject2 = new MB_Charge_Type__c(Name = 'Domestic Wi-Fi Offloading');
  insert chargeTypeObject2;
  MB_Charge_Type__c chargeTypeObject3 = new MB_Charge_Type__c(Name = 'Domestic Data');
  insert chargeTypeObject3;
  MB_Charge_Type__c chargeTypeObject4 = new MB_Charge_Type__c(Name = 'Roaming Outgoing SMS');
  insert chargeTypeObject4;
  MB_Charge_Type__c chargeTypeObject5 = new MB_Charge_Type__c(Name = 'Tax');
  insert chargeTypeObject5;
       
  MB_Billing_Entity__c billingEntityObject1 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC1', Billing_Month__c = 'April 2016', Call_Minutes__c = 50.00, Data_Consumed_In_MB__c = 0.00, 
                                    iPass_Consumed_In_MB__c = 0.00, Item_Count__c = 5.00, Local_Net_Amount__c = 25.00, Messages__c = 0.00, Non_Usage_Consumed__c = 0.00, 
                                    Service_Name__c = 'SN1');
  billingEntityObject1.Device_Details__c = deviceDetailsObject.Id;
  billingEntityObject1.Usage_Type__c = usageTypeObject1.Id;
  billingEntityObject1.Charge_Type__c = chargeTypeObject1.Id;
  billingEntityObject1.User__c = UserInfo.getUserId();
  insert billingEntityObject1;
  
   MB_Billing_Entity__c billingEntityObject17 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC1', Billing_Month__c = 'April 2016', Call_Minutes__c = 50.00, Data_Consumed_In_MB__c = 0.00, 
                                    iPass_Consumed_In_MB__c = 0.00, Item_Count__c = 5.00, Local_Net_Amount__c = 25.00, Messages__c = 0.00, Non_Usage_Consumed__c = 0.00, 
                                    Service_Name__c = 'SN1');
  billingEntityObject17.Device_Details__c = deviceDetailsObject.Id;
  billingEntityObject17.Usage_Type__c = usageTypeObject1.Id;
  billingEntityObject17.Charge_Type__c = chargeTypeObject1.Id;
  billingEntityObject17.User__c = UserInfo.getUserId();
  insert billingEntityObject17;
            
  MB_Billing_Entity__c billingEntityObject2 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC2', Billing_Month__c = 'April 2016', Call_Minutes__c = 0.00, Data_Consumed_In_MB__c = 0.00, 
                                    iPass_Consumed_In_MB__c = 100.00, Item_Count__c = 10.00, Local_Net_Amount__c = 50.00, Messages__c = 0.00, Non_Usage_Consumed__c = 0.00, 
                                    Service_Name__c = 'SN2');
  billingEntityObject2.Device_Details__c = deviceDetailsObject.Id;
  billingEntityObject2.Usage_Type__c = usageTypeObject2.Id;
  billingEntityObject2.Charge_Type__c = chargeTypeObject2.Id;
  billingEntityObject2.User__c = UserInfo.getUserId();
  insert billingEntityObject2;
  
  MB_Billing_Entity__c billingEntityObject18= new MB_Billing_Entity__c(Billing_Currency__c = 'BC2', Billing_Month__c = 'April 2016', Call_Minutes__c = 0.00, Data_Consumed_In_MB__c = 0.00, 
                                    iPass_Consumed_In_MB__c = 100.00, Item_Count__c = 10.00, Local_Net_Amount__c = 50.00, Messages__c = 0.00, Non_Usage_Consumed__c = 0.00, 
                                    Service_Name__c = 'SN2');
  billingEntityObject18.Device_Details__c = deviceDetailsObject.Id;
  billingEntityObject18.Usage_Type__c = usageTypeObject2.Id;
  billingEntityObject18.Charge_Type__c = chargeTypeObject2.Id;
  billingEntityObject18.User__c = UserInfo.getUserId();
  insert billingEntityObject18;
     
  MB_Billing_Entity__c billingEntityObject3 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC3', Billing_Month__c = 'April 2016', Call_Minutes__c = 0.00, Data_Consumed_In_MB__c = 500.00, 
                                    iPass_Consumed_In_MB__c = 0.00, Item_Count__c = 50.00, Local_Net_Amount__c = 175.00, Messages__c = 0.00, Non_Usage_Consumed__c = 0.00, 
                                    Service_Name__c = 'SN3');
  billingEntityObject3.Device_Details__c = deviceDetailsObject.Id;
  billingEntityObject3.Usage_Type__c = usageTypeObject3.Id;
  billingEntityObject3.Charge_Type__c = chargeTypeObject3.Id;
  billingEntityObject3.User__c = UserInfo.getUserId();
  insert billingEntityObject3;
  
   MB_Billing_Entity__c billingEntityObject16 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC3', Billing_Month__c = 'April 2016', Call_Minutes__c = 0.00, Data_Consumed_In_MB__c = 500.00, 
                                    iPass_Consumed_In_MB__c = 0.00, Item_Count__c = 50.00, Local_Net_Amount__c = 175.00, Messages__c = 0.00, Non_Usage_Consumed__c = 0.00, 
                                    Service_Name__c = 'SN3');
  billingEntityObject16.Device_Details__c = deviceDetailsObject.Id;
  billingEntityObject16.Usage_Type__c = usageTypeObject3.Id;
  billingEntityObject16.Charge_Type__c = chargeTypeObject3.Id;
  billingEntityObject16.User__c = UserInfo.getUserId();
  insert billingEntityObject16;
      
  MB_Billing_Entity__c billingEntityObject4 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC4', Billing_Month__c = 'April 2016', Call_Minutes__c = 0.00, Data_Consumed_In_MB__c = 0.00, 
                                    iPass_Consumed_In_MB__c = 0.00, Item_Count__c = 9.00, Local_Net_Amount__c = 75.00, Messages__c = 90.00, Non_Usage_Consumed__c = 0.00, 
                                    Service_Name__c = 'SN4');
  billingEntityObject4.Device_Details__c = deviceDetailsObject.Id;
  billingEntityObject4.Usage_Type__c = usageTypeObject4.Id;
  billingEntityObject4.Charge_Type__c = chargeTypeObject4.Id;
  billingEntityObject4.User__c = UserInfo.getUserId();
  insert billingEntityObject4;
      
  MB_Billing_Entity__c billingEntityObject19 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC4', Billing_Month__c = 'April 2016', Call_Minutes__c = 0.00, Data_Consumed_In_MB__c = 0.00, 
                                    iPass_Consumed_In_MB__c = 0.00, Item_Count__c = 9.00, Local_Net_Amount__c = 75.00, Messages__c = 90.00, Non_Usage_Consumed__c = 0.00, 
                                    Service_Name__c = 'SN4');
  billingEntityObject19.Device_Details__c = deviceDetailsObject.Id;
  billingEntityObject19.Usage_Type__c = usageTypeObject4.Id;
  billingEntityObject19.Charge_Type__c = chargeTypeObject4.Id;
  billingEntityObject19.User__c = UserInfo.getUserId();
  insert billingEntityObject19;
      
  MB_Billing_Entity__c billingEntityObject5 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC5', Billing_Month__c = 'April 2016', Call_Minutes__c = 0.00, Data_Consumed_In_MB__c = 0.00, 
                                    iPass_Consumed_In_MB__c = 0.00, Item_Count__c = 10.00, Local_Net_Amount__c = 50.00, Messages__c = 0.00, Non_Usage_Consumed__c = 50.00, 
                                    Service_Name__c = 'SN5');
  billingEntityObject5.Device_Details__c = deviceDetailsObject.Id;
  billingEntityObject5.Usage_Type__c = usageTypeObject5.Id;
  billingEntityObject5.Charge_Type__c = chargeTypeObject5.Id;
  billingEntityObject5.User__c = UserInfo.getUserId();
  insert billingEntityObject5;
             
  MB_Billing_Entity__c billingEntityObject6 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC1', Billing_Month__c = 'April 2016', Call_Minutes__c = 50.00, Data_Consumed_In_MB__c = 0.00, 
                                    iPass_Consumed_In_MB__c = 0.00, Item_Count__c = 5.00, Local_Net_Amount__c = 25.00, Messages__c = 0.00, Non_Usage_Consumed__c = 0.00, 
                                    Service_Name__c = 'SN1');
  billingEntityObject6.Device_Details__c = deviceDetailsObject.Id;
  billingEntityObject6.Usage_Type__c = usageTypeObject1.Id;
  billingEntityObject6.Charge_Type__c = chargeTypeObject1.Id;
  billingEntityObject6.User__c = userObject2.Id;
  insert billingEntityObject6;
            
  MB_Billing_Entity__c billingEntityObject7 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC2', Billing_Month__c = 'April 2016', Call_Minutes__c = 0.00, Data_Consumed_In_MB__c = 0.00, 
                                    iPass_Consumed_In_MB__c = 100.00, Item_Count__c = 10.00, Local_Net_Amount__c = 50.00, Messages__c = 0.00, Non_Usage_Consumed__c = 0.00, 
                                    Service_Name__c = 'SN2');
  billingEntityObject7.Device_Details__c = deviceDetailsObject.Id;
  billingEntityObject7.Usage_Type__c = usageTypeObject2.Id;
  billingEntityObject7.Charge_Type__c = chargeTypeObject2.Id;
  billingEntityObject7.User__c = userObject2.Id;
  insert billingEntityObject7;
     
  MB_Billing_Entity__c billingEntityObject8 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC3', Billing_Month__c = 'April 2016', Call_Minutes__c = 0.00, Data_Consumed_In_MB__c = 500.00, 
                                    iPass_Consumed_In_MB__c = 0.00, Item_Count__c = 50.00, Local_Net_Amount__c = 175.00, Messages__c = 0.00, Non_Usage_Consumed__c = 0.00, 
                                    Service_Name__c = 'SN3');
  billingEntityObject8.Device_Details__c = deviceDetailsObject.Id;
  billingEntityObject8.Usage_Type__c = usageTypeObject3.Id;
  billingEntityObject8.Charge_Type__c = chargeTypeObject3.Id;
  billingEntityObject8.User__c = userObject2.Id;
  insert billingEntityObject8;
      
  MB_Billing_Entity__c billingEntityObject9 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC4', Billing_Month__c = 'April 2016', Call_Minutes__c = 0.00, Data_Consumed_In_MB__c = 0.00, 
                                    iPass_Consumed_In_MB__c = 0.00, Item_Count__c = 9.00, Local_Net_Amount__c = 75.00, Messages__c = 90.00, Non_Usage_Consumed__c = 0.00, 
                                    Service_Name__c = 'SN4');
  billingEntityObject9.Device_Details__c = deviceDetailsObject.Id;
  billingEntityObject9.Usage_Type__c = usageTypeObject4.Id;
  billingEntityObject9.Charge_Type__c = chargeTypeObject4.Id;
  billingEntityObject9.User__c = userObject2.Id;
  insert billingEntityObject9;

    MB_Billing_Entity__c billingEntityObject10 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC5', Billing_Month__c = 'April 2016', Call_Minutes__c = 0.00, Data_Consumed_In_MB__c = 0.00, 
                                    iPass_Consumed_In_MB__c = 0.00, Item_Count__c = 10.00, Local_Net_Amount__c = 50.00, Messages__c = 0.00, Non_Usage_Consumed__c = 50.00, 
                                    Service_Name__c = 'SN5');
  billingEntityObject10.Device_Details__c = deviceDetailsObject.Id;
  billingEntityObject10.Usage_Type__c = usageTypeObject5.Id;
  billingEntityObject10.Charge_Type__c = chargeTypeObject5.Id;
  billingEntityObject10.User__c = UserInfo.getUserId();
  insert billingEntityObject10;
      
  MB_Billing_Entity__c billingEntityObject11 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC1', Billing_Month__c = 'March 2016', Call_Minutes__c = 50.00, Data_Consumed_In_MB__c = 0.00, 
                                    iPass_Consumed_In_MB__c = 0.00, Item_Count__c = 5.00, Local_Net_Amount__c = 25.00, Messages__c = 0.00, Non_Usage_Consumed__c = 0.00, 
                                    Service_Name__c = 'SN1');
  billingEntityObject11.Device_Details__c = deviceDetailsObject.Id;
  billingEntityObject11.Usage_Type__c = usageTypeObject1.Id;
  billingEntityObject11.Charge_Type__c = chargeTypeObject1.Id;
  billingEntityObject11.User__c = UserInfo.getUserId();
  insert billingEntityObject11;
            
  MB_Billing_Entity__c billingEntityObject12 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC2', Billing_Month__c = 'March 2016', Call_Minutes__c = 0.00, Data_Consumed_In_MB__c = 0.00, 
                                    iPass_Consumed_In_MB__c = 100.00, Item_Count__c = 10.00, Local_Net_Amount__c = 50.00, Messages__c = 0.00, Non_Usage_Consumed__c = 0.00, 
                                    Service_Name__c = 'SN2');
  billingEntityObject12.Device_Details__c = deviceDetailsObject.Id;
  billingEntityObject12.Usage_Type__c = usageTypeObject2.Id;
  billingEntityObject12.Charge_Type__c = chargeTypeObject2.Id;
  billingEntityObject12.User__c = UserInfo.getUserId();
  insert billingEntityObject12;
     
  MB_Billing_Entity__c billingEntityObject13 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC3', Billing_Month__c = 'March 2016', Call_Minutes__c = 0.00, Data_Consumed_In_MB__c = 500.00, 
                                    iPass_Consumed_In_MB__c = 0.00, Item_Count__c = 50.00, Local_Net_Amount__c = 175.00, Messages__c = 0.00, Non_Usage_Consumed__c = 0.00, 
                                    Service_Name__c = 'SN3');
  billingEntityObject13.Device_Details__c = deviceDetailsObject.Id;
  billingEntityObject13.Usage_Type__c = usageTypeObject3.Id;
  billingEntityObject13.Charge_Type__c = chargeTypeObject3.Id;
  billingEntityObject13.User__c = UserInfo.getUserId();
  insert billingEntityObject13;
      
  MB_Billing_Entity__c billingEntityObject14 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC4', Billing_Month__c = 'March 2016', Call_Minutes__c = 0.00, Data_Consumed_In_MB__c = 0.00, 
                                    iPass_Consumed_In_MB__c = 0.00, Item_Count__c = 9.00, Local_Net_Amount__c = 75.00, Messages__c = 90.00, Non_Usage_Consumed__c = 0.00, 
                                    Service_Name__c = 'SN4');
  billingEntityObject14.Device_Details__c = deviceDetailsObject.Id;
  billingEntityObject14.Usage_Type__c = usageTypeObject4.Id;
  billingEntityObject14.Charge_Type__c = chargeTypeObject4.Id;
  billingEntityObject14.User__c = UserInfo.getUserId();
  insert billingEntityObject14;
      
   MB_Billing_Entity__c billingEntityObject15 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC5', Billing_Month__c = 'March 2016', Call_Minutes__c = 0.00, Data_Consumed_In_MB__c = 0.00, 
                                    iPass_Consumed_In_MB__c = 0.00, Item_Count__c = 5.00, Local_Net_Amount__c = 25.00, Messages__c = 0.00, Non_Usage_Consumed__c = 50.00, 
                                    Service_Name__c = 'SN5');
  billingEntityObject15.Device_Details__c = deviceDetailsObject.Id;
  billingEntityObject15.Usage_Type__c = usageTypeObject5.Id;
  billingEntityObject15.Charge_Type__c = chargeTypeObject5.Id;
  billingEntityObject15.User__c = UserInfo.getUserId();
  insert billingEntityObject15;
          
  List<MB_Wrapper_Class.MB_Device_Wrapper_Class> wrapperList1 = MB_Controller_Class.deviceSpendDetailsForUser('April 2016');
  System.assertEquals(wrapperList1.get(0).userName,'fufn');
  System.assertEquals(wrapperList1.get(0).userCurrency,'BC1');
  System.assertEquals(wrapperList1.get(0).deviceName,'Nokia Lumia 625');
  System.assertEquals(wrapperList1.get(0).deviceImageUrl,null);
  System.assertEquals(wrapperList1.get(0).totalUsage,750.00); 
      
  List<MB_Billing_Entity__c> billingEntityList = new List<MB_Billing_Entity__c>();
  billingEntityList.add(billingEntityObject1);  
  billingEntityList.add(billingEntityObject2);
  billingEntityList.add(billingEntityObject3);
  billingEntityList.add(billingEntityObject4);
  billingEntityList.add(billingEntityObject5);    
  decimal totalDeviceAmount1 = MB_Controller_Class.totalDeviceSpend(billingEntityList, deviceDetailsObject.Id);
  System.assertEquals(totalDeviceAmount1, 375.00);
           
  string userName = MB_Controller_Class.getUserName();
  System.assertEquals(userName, 'fufn');
      
  MB_Wrapper_Class.MB_Device_Wrapper_Class wrapperObject1 = MB_Controller_Class.getUsageDetails('April 2016');
  System.assertEquals(wrapperObject1.callVariance,true);
  System.assertEquals(wrapperObject1.dataVariance,true);
  System.assertEquals(wrapperObject1.ipassVariance,true);
  System.assertEquals(wrapperObject1.smsVariance,true);
  System.assertEquals(wrapperObject1.totalCallUsage,100.00);
  System.assertEquals(wrapperObject1.totalDataUsage,1000.00);
  System.assertEquals(wrapperObject1.totalIpassUsage,200.00);
  System.assertEquals(wrapperObject1.totalMessageUsage,180.00);
  System.assertEquals(wrapperObject1.totalUsage,750.00);
  System.assertEquals(wrapperObject1.userName,'fufn');
      
  MB_Wrapper_Class.MB_Device_Wrapper_Class wrapperObject2 = MB_Controller_Class.getUsageDetails('January 2016');
  System.assertEquals(wrapperObject2,null);
  
  boolean testVariance1 = MB_Controller_Class.getVariance(200,100);
  System.assertEquals(testVariance1, true);
  
  boolean testVariance2 = MB_Controller_Class.getVariance(100,100);
  System.assertEquals(testVariance2, null);
   
  boolean testVariance3 = MB_Controller_Class.getVariance(100,200);
  System.assertEquals(testVariance3, false);
  
  decimal previousUsage;
  boolean testVariance4 = MB_Controller_Class.getVariance(100,previousUsage);
  System.assertEquals(testVariance4, null);
  
  MB_Wrapper_Class  wrapperObject3 = MB_Controller_Class.getSpendDetails(deviceDetailsObject.Id,'April 2016');
  System.assertEquals(wrapperObject3.callsWrapperList.get(0).chargeTypeName,'Domestic Outgoing Calls');
  System.assertEquals(wrapperObject3.callsWrapperList.get(0).totalSpend,50.00);
  System.assertEquals(wrapperObject3.dataWrapperList.get(0).chargeTypeName,'Domestic Data');
  System.assertEquals(wrapperObject3.dataWrapperList.get(0).totalSpend,350.00);
  System.assertEquals(wrapperObject3.ipassWrapperList.get(0).chargeTypeName,'Domestic Wi-Fi Offloading');
  System.assertEquals(wrapperObject3.ipassWrapperList.get(0).totalSpend,100.00);
  System.assertEquals(wrapperObject3.messageWrapperList.get(0).chargeTypeName,'Roaming Outgoing SMS');
  System.assertEquals(wrapperObject3.messageWrapperList.get(0).totalSpend,150.00);
  System.assertEquals(wrapperObject3.nonusageWrapperList.get(0).chargeTypeName,'Tax');
  System.assertEquals(wrapperObject3.nonusageWrapperList.get(0).totalSpend,100.00);
  System.assertEquals(wrapperObject3.objdeviceWrapper.userCurrency,'BC1');
  System.assertEquals(wrapperObject3.objdeviceWrapper.userName,'fufn');
  System.assertEquals(wrapperObject3.objdeviceWrapper.totalDataUsage,350.00);
  System.assertEquals(wrapperObject3.objdeviceWrapper.totalCallUsage,50.00);
  System.assertEquals(wrapperObject3.objdeviceWrapper.totalMessageUsage,150.00);
  System.assertEquals(wrapperObject3.objdeviceWrapper.totalIpassUsage,100.00);
  System.assertEquals(wrapperObject3.objdeviceWrapper.totalnonUsage,100.00);
  System.assertEquals(wrapperObject3.objdeviceWrapper.totalUsage,750.00);
  System.assertEquals(wrapperObject3.objdeviceWrapper.dataVariance,true);
  System.assertEquals(wrapperObject3.objdeviceWrapper.callVariance,true);
  System.assertEquals(wrapperObject3.objdeviceWrapper.smsVariance,true);
  System.assertEquals(wrapperObject3.objdeviceWrapper.ipassVariance,true);
  System.assertEquals(wrapperObject3.objdeviceWrapper.nonUsageVariance,true);
  System.assertEquals(wrapperObject3.objdeviceWrapper.totalSpendVariance,true);
  
  MB_Wrapper_Class  wrapperObject4 = MB_Controller_Class.getSpendDetails(deviceDetailsObject.Id,'March 2016');
  System.assertEquals(wrapperObject4.callsWrapperList.get(0).chargeTypeName,'Domestic Outgoing Calls');
  System.assertEquals(wrapperObject4.callsWrapperList.get(0).totalSpend,25.00);
  System.assertEquals(wrapperObject4.dataWrapperList.get(0).chargeTypeName,'Domestic Data');
  System.assertEquals(wrapperObject4.dataWrapperList.get(0).totalSpend,175.00);
  System.assertEquals(wrapperObject4.ipassWrapperList.get(0).chargeTypeName,'Domestic Wi-Fi Offloading');
  System.assertEquals(wrapperObject4.ipassWrapperList.get(0).totalSpend,50.00);
  System.assertEquals(wrapperObject4.messageWrapperList.get(0).chargeTypeName,'Roaming Outgoing SMS');
  System.assertEquals(wrapperObject4.messageWrapperList.get(0).totalSpend,75.00);
  System.assertEquals(wrapperObject4.nonusageWrapperList.get(0).chargeTypeName,'Tax');
  System.assertEquals(wrapperObject4.nonusageWrapperList.get(0).totalSpend,25.00);
  System.assertEquals(wrapperObject4.objdeviceWrapper.userCurrency,'BC1');
  System.assertEquals(wrapperObject4.objdeviceWrapper.userName,'fufn');
  System.assertEquals(wrapperObject4.objdeviceWrapper.totalDataUsage,175.00);
  System.assertEquals(wrapperObject4.objdeviceWrapper.totalCallUsage,25.00);
  System.assertEquals(wrapperObject4.objdeviceWrapper.totalMessageUsage,75.00);
  System.assertEquals(wrapperObject4.objdeviceWrapper.totalIpassUsage,50.00);
  System.assertEquals(wrapperObject4.objdeviceWrapper.totalnonUsage,25.00);
  System.assertEquals(wrapperObject4.objdeviceWrapper.totalUsage,350.00);
  System.assertEquals(wrapperObject4.objdeviceWrapper.dataVariance,true);
  System.assertEquals(wrapperObject4.objdeviceWrapper.callVariance,true);
  System.assertEquals(wrapperObject4.objdeviceWrapper.smsVariance,true);
  System.assertEquals(wrapperObject4.objdeviceWrapper.ipassVariance,true);
  System.assertEquals(wrapperObject4.objdeviceWrapper.nonUsageVariance,true);
  System.assertEquals(wrapperObject4.objdeviceWrapper.totalSpendVariance,true); 
      
  decimal totalDeviceAmount2 = MB_Controller_Class.totalDeviceUsageSpend(billingEntityList, 'Calls');
  System.assertEquals(totalDeviceAmount2,0);
 }
         
  Test.stopTest();
  }
}