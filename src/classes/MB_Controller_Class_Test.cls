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
  public static final String Month_April = 'April 2016';
  public static final String Month_May = 'May 2016';
  public static final String Local_Key = 'en_US';
    
  static testMethod void testMBControllerWithoutCollegue(){
  Test.startTest();
      
  ID adminProfileID = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].ID;
  user  userObject1 = new User(username='firstuserdb@test.com',
                                  alias = 'fu',
                                  email ='firstuser@test.com',
                                  emailencodingkey = 'UTF-8',
                                  firstname = 'fufn',
                                  lastname = 'fuln',
                                  CommunityNickname = 'fucn',
                                  languagelocalekey = Local_Key,
                                  localesidkey = Local_Key,                                            
                                  profileid = adminProfileID,
                                  timezonesidkey = 'Europe/Berlin',
                                  country = 'India'
                                 );
  insert  userObject1;
          
  System.runAs(userObject1)
  {      
  String previousMonth1 = MB_Controller_Class.getPreviousMonth('January 2016');
  System.assertEquals(previousMonth1, 'December 2015');
    
  String previousMonth2 = MB_Controller_Class.getPreviousMonth(Month_May);
  System.assertEquals(previousMonth2, Month_April);
    
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
      
  MB_Billing_Currency__c billingCurrencyObject = new MB_Billing_Currency__c(Name = 'GBP', Symbol__c = 'USD');
  insert billingCurrencyObject;
       
  MB_Billing_Entity__c billingEntityObject1 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC1', Billing_Month__c = Month_May, Call_Minutes__c = 50.00, Data_Consumed_In_MB__c = 0.00, 
                                    iPass_Consumed_In_MB__c = 0.00, Item_Count__c = 5.00, Local_Net_Amount__c = 25.00, Messages__c = 0.00, Non_Usage_Consumed__c = 0.00, 
                                    Service_Name__c = 'SN1');
      
  billingEntityObject1.Device_Details__c = deviceDetailsObject.Id;
  billingEntityObject1.Usage_Type__c = usageTypeObject1.Id;
  billingEntityObject1.Charge_Type__c = chargeTypeObject1.Id;
  billingEntityObject1.User__c = UserInfo.getUserId();
  insert billingEntityObject1;
  
   MB_Billing_Entity__c billingEntityObject2 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC1', Billing_Month__c = Month_May, Call_Minutes__c = 50.00, Data_Consumed_In_MB__c = 0.00, 
                                    iPass_Consumed_In_MB__c = 0.00, Item_Count__c = 5.00, Local_Net_Amount__c = 25.00, Messages__c = 0.00, Non_Usage_Consumed__c = 0.00, 
                                    Service_Name__c = 'SN1');
  billingEntityObject2.Device_Details__c = deviceDetailsObject.Id;
  billingEntityObject2.Usage_Type__c = usageTypeObject1.Id;
  billingEntityObject2.Charge_Type__c = chargeTypeObject1.Id;
  billingEntityObject2.User__c = UserInfo.getUserId();
  insert billingEntityObject2;
            
  MB_Billing_Entity__c billingEntityObject3 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC2', Billing_Month__c = Month_May, Call_Minutes__c = 0.00, Data_Consumed_In_MB__c = 0.00, 
                                    iPass_Consumed_In_MB__c = 100.00, Item_Count__c = 10.00, Local_Net_Amount__c = 50.00, Messages__c = 0.00, Non_Usage_Consumed__c = 0.00, 
                                    Service_Name__c = 'SN2');
  billingEntityObject3.Device_Details__c = deviceDetailsObject.Id;
  billingEntityObject3.Usage_Type__c = usageTypeObject2.Id;
  billingEntityObject3.Charge_Type__c = chargeTypeObject2.Id;
  billingEntityObject3.User__c = UserInfo.getUserId();
  insert billingEntityObject3;
  
  MB_Billing_Entity__c billingEntityObject4= new MB_Billing_Entity__c(Billing_Currency__c = 'BC2', Billing_Month__c = Month_May, Call_Minutes__c = 0.00, Data_Consumed_In_MB__c = 0.00, 
                                    iPass_Consumed_In_MB__c = 100.00, Item_Count__c = 10.00, Local_Net_Amount__c = 50.00, Messages__c = 0.00, Non_Usage_Consumed__c = 0.00, 
                                    Service_Name__c = 'SN2');
  billingEntityObject4.Device_Details__c = deviceDetailsObject.Id;
  billingEntityObject4.Usage_Type__c = usageTypeObject2.Id;
  billingEntityObject4.Charge_Type__c = chargeTypeObject2.Id;
  billingEntityObject4.User__c = UserInfo.getUserId();
  insert billingEntityObject4;
     
  MB_Billing_Entity__c billingEntityObject5 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC3', Billing_Month__c = Month_May, Call_Minutes__c = 0.00, Data_Consumed_In_MB__c = 500.00, 
                                    iPass_Consumed_In_MB__c = 0.00, Item_Count__c = 50.00, Local_Net_Amount__c = 175.00, Messages__c = 0.00, Non_Usage_Consumed__c = 0.00, 
                                    Service_Name__c = 'SN3');
  billingEntityObject5.Device_Details__c = deviceDetailsObject.Id;
  billingEntityObject5.Usage_Type__c = usageTypeObject3.Id;
  billingEntityObject5.Charge_Type__c = chargeTypeObject3.Id;
  billingEntityObject5.User__c = UserInfo.getUserId();
  insert billingEntityObject5;
  
   MB_Billing_Entity__c billingEntityObject6 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC3', Billing_Month__c = Month_May, Call_Minutes__c = 0.00, Data_Consumed_In_MB__c = 500.00, 
                                    iPass_Consumed_In_MB__c = 0.00, Item_Count__c = 50.00, Local_Net_Amount__c = 175.00, Messages__c = 0.00, Non_Usage_Consumed__c = 0.00, 
                                    Service_Name__c = 'SN3');
  billingEntityObject6.Device_Details__c = deviceDetailsObject.Id;
  billingEntityObject6.Usage_Type__c = usageTypeObject3.Id;
  billingEntityObject6.Charge_Type__c = chargeTypeObject3.Id;
  billingEntityObject6.User__c = UserInfo.getUserId();
  insert billingEntityObject6;
      
  MB_Billing_Entity__c billingEntityObject7 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC4', Billing_Month__c = Month_May, Call_Minutes__c = 0.00, Data_Consumed_In_MB__c = 0.00, 
                                    iPass_Consumed_In_MB__c = 0.00, Item_Count__c = 9.00, Local_Net_Amount__c = 75.00, Messages__c = 90.00, Non_Usage_Consumed__c = 0.00, 
                                    Service_Name__c = 'SN4');
  billingEntityObject7.Device_Details__c = deviceDetailsObject.Id;
  billingEntityObject7.Usage_Type__c = usageTypeObject4.Id;
  billingEntityObject7.Charge_Type__c = chargeTypeObject4.Id;
  billingEntityObject7.User__c = UserInfo.getUserId();
  insert billingEntityObject7;
      
  MB_Billing_Entity__c billingEntityObject8 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC4', Billing_Month__c = Month_May, Call_Minutes__c = 0.00, Data_Consumed_In_MB__c = 0.00, 
                                    iPass_Consumed_In_MB__c = 0.00, Item_Count__c = 9.00, Local_Net_Amount__c = 75.00, Messages__c = 90.00, Non_Usage_Consumed__c = 0.00, 
                                    Service_Name__c = 'SN4');
  billingEntityObject8.Device_Details__c = deviceDetailsObject.Id;
  billingEntityObject8.Usage_Type__c = usageTypeObject4.Id;
  billingEntityObject8.Charge_Type__c = chargeTypeObject4.Id;
  billingEntityObject8.User__c = UserInfo.getUserId();
  insert billingEntityObject8;
      
  MB_Billing_Entity__c billingEntityObject9 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC5', Billing_Month__c = Month_May, Call_Minutes__c = 0.00, Data_Consumed_In_MB__c = 0.00, 
                                    iPass_Consumed_In_MB__c = 0.00, Item_Count__c = 10.00, Local_Net_Amount__c = 50.00, Messages__c = 0.00, Non_Usage_Consumed__c = 50.00, 
                                    Service_Name__c = 'SN5');
  billingEntityObject9.Device_Details__c = deviceDetailsObject.Id;
  billingEntityObject9.Usage_Type__c = usageTypeObject5.Id;
  billingEntityObject9.Charge_Type__c = chargeTypeObject5.Id;
  billingEntityObject9.User__c = UserInfo.getUserId();
  insert billingEntityObject9;
      
  MB_Billing_Entity__c billingEntityObject10 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC5', Billing_Month__c = Month_May, Call_Minutes__c = 0.00, Data_Consumed_In_MB__c = 0.00, 
                                    iPass_Consumed_In_MB__c = 0.00, Item_Count__c = 10.00, Local_Net_Amount__c = 50.00, Messages__c = 0.00, Non_Usage_Consumed__c = 50.00, 
                                    Service_Name__c = 'SN5');
  billingEntityObject10.Device_Details__c = deviceDetailsObject.Id;
  billingEntityObject10.Usage_Type__c = usageTypeObject5.Id;
  billingEntityObject10.Charge_Type__c = chargeTypeObject5.Id;
  billingEntityObject10.User__c = UserInfo.getUserId();
  insert billingEntityObject10;
      
  MB_Billing_Entity__c billingEntityObject11 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC10', Billing_Month__c = Month_April, Call_Minutes__c = 0.00, Data_Consumed_In_MB__c = 500.00, 
                                    iPass_Consumed_In_MB__c = 0.00, Item_Count__c = 50.00, Local_Net_Amount__c = 175.00, Messages__c = 0.00, Non_Usage_Consumed__c = 0.00, 
                                    Service_Name__c = 'SN3');
  billingEntityObject11.Device_Details__c = deviceDetailsObject.Id;
  billingEntityObject11.Usage_Type__c = usageTypeObject3.Id;
  billingEntityObject11.Charge_Type__c = chargeTypeObject3.Id;
  billingEntityObject11.User__c = UserInfo.getUserId();
  insert billingEntityObject11;
             
  boolean testVariance1 = MB_Controller_Class.getVariance(200,100);
  System.assertEquals(testVariance1, true);
  
  boolean testVariance2 = MB_Controller_Class.getVariance(100,100);
  System.assertEquals(testVariance2, null);
   
  boolean testVariance3 = MB_Controller_Class.getVariance(100,200);
  System.assertEquals(testVariance3, false);
  
  boolean testVariance4 = MB_Controller_Class.getVariance(100,null);
  System.assertEquals(testVariance4, null);
      
  string userName = MB_Controller_Class.getUserName();
  System.assertEquals(userName, 'fufn');
  
  MB_Wrapper_Class  wrapperObject1 = MB_Controller_Class.getSpendDetails(deviceDetailsObject.Id,Month_May);
      
  List<MB_Wrapper_Class.MB_Device_Wrapper_Class> wrapperList1 = MB_Controller_Class.deviceSpendDetailsForUser(Month_May);
 }
         
  Test.stopTest();
  }
    
static testMethod void testMBControllerWithCollegue(){
  Test.startTest();
      
  ID adminProfileID = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].ID;
  user  userObject2 = new User(username='seconduserdb@test.com',
                                  alias = 'su',
                                  email ='seconduser@test.com',
                                  emailencodingkey = 'UTF-8',
                                  lastname = 'suln',
                                  CommunityNickname = 'sucn',
                                  languagelocalekey = Local_Key,
                                  localesidkey = Local_Key,                                            
                                  profileid = adminProfileID,
                                  timezonesidkey = 'Europe/Berlin',
                                  country = 'India'
                                 );
  insert  userObject2;

  user  userObject3 = new User(username='thirduserdb@test.com',
                                  alias = 'tu',
                                  email ='thirduser@test.com',
                                  emailencodingkey = 'UTF-8',
                                  lastname = 'tuln',
                                  CommunityNickname = 'tucn',
                                  languagelocalekey = Local_Key,
                                  localesidkey = Local_Key,                                            
                                  profileid = adminProfileID,
                                  timezonesidkey = 'Europe/Berlin',
                                  country = 'India'
                                 );
  insert  userObject3;
       
  System.runAs(userObject2)
  {         
  MB_Device_Details__c deviceDetailsObject = new MB_Device_Details__c(Name = 'Samsung Galaxy');
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
  MB_Charge_Type__c chargeTypeObject2 = new MB_Charge_Type__c(Name = 'Domestic Wi-Fi Offloading');
  insert chargeTypeObject2;
  MB_Charge_Type__c chargeTypeObject3 = new MB_Charge_Type__c(Name = 'Domestic Data');
  insert chargeTypeObject3;
  MB_Charge_Type__c chargeTypeObject4 = new MB_Charge_Type__c(Name = 'Roaming Outgoing SMS');
  insert chargeTypeObject4;
      
  MB_Billing_Currency__c billingCurrencyObject = new MB_Billing_Currency__c(Name = 'GBP', Symbol__c = 'USD');
  insert billingCurrencyObject;
       
  MB_Billing_Entity__c billingEntityObject1 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC6', Billing_Month__c = Month_May, Call_Minutes__c = 50.00, Data_Consumed_In_MB__c = 0.00, 
                                    iPass_Consumed_In_MB__c = 0.00, Item_Count__c = 5.00, Local_Net_Amount__c = 25.00, Messages__c = 0.00, Non_Usage_Consumed__c = 0.00, 
                                    Service_Name__c = 'SN11');
      
  billingEntityObject1.Device_Details__c = deviceDetailsObject.Id;
  billingEntityObject1.Usage_Type__c = usageTypeObject1.Id;
  billingEntityObject1.Charge_Type__c = chargeTypeObject1.Id;
  billingEntityObject1.User__c = UserInfo.getUserId();
  insert billingEntityObject1;
            
  MB_Billing_Entity__c billingEntityObject2 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC7', Billing_Month__c = Month_May, Call_Minutes__c = 0.00, Data_Consumed_In_MB__c = 0.00, 
                                    iPass_Consumed_In_MB__c = 100.00, Item_Count__c = 10.00, Local_Net_Amount__c = 50.00, Messages__c = 0.00, Non_Usage_Consumed__c = 0.00, 
                                    Service_Name__c = 'SN12');
  billingEntityObject2.Device_Details__c = deviceDetailsObject.Id;
  billingEntityObject2.Usage_Type__c = usageTypeObject2.Id;
  billingEntityObject2.Charge_Type__c = chargeTypeObject2.Id;
  billingEntityObject2.User__c = UserInfo.getUserId();
  insert billingEntityObject2;
     
  MB_Billing_Entity__c billingEntityObject3 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC8', Billing_Month__c = Month_May, Call_Minutes__c = 0.00, Data_Consumed_In_MB__c = 500.00, 
                                    iPass_Consumed_In_MB__c = 0.00, Item_Count__c = 50.00, Local_Net_Amount__c = 175.00, Messages__c = 0.00, Non_Usage_Consumed__c = 0.00, 
                                    Service_Name__c = 'SN13');
  billingEntityObject3.Device_Details__c = deviceDetailsObject.Id;
  billingEntityObject3.Usage_Type__c = usageTypeObject3.Id;
  billingEntityObject3.Charge_Type__c = chargeTypeObject3.Id;
  billingEntityObject3.User__c = UserInfo.getUserId();
  insert billingEntityObject3;
  
  
      
  MB_Billing_Entity__c billingEntityObject4 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC9', Billing_Month__c = Month_May, Call_Minutes__c = 0.00, Data_Consumed_In_MB__c = 0.00, 
                                    iPass_Consumed_In_MB__c = 0.00, Item_Count__c = 9.00, Local_Net_Amount__c = 75.00, Messages__c = 90.00, Non_Usage_Consumed__c = 0.00, 
                                    Service_Name__c = 'SN14');
  billingEntityObject4.Device_Details__c = deviceDetailsObject.Id;
  billingEntityObject4.Usage_Type__c = usageTypeObject4.Id;
  billingEntityObject4.Charge_Type__c = chargeTypeObject4.Id;
  billingEntityObject4.User__c = UserInfo.getUserId();
  insert billingEntityObject4;
      
  MB_Billing_Entity__c billingEntityObject5 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC6', Billing_Month__c = Month_May, Call_Minutes__c = 50.00, Data_Consumed_In_MB__c = 0.00, 
                                    iPass_Consumed_In_MB__c = 0.00, Item_Count__c = 5.00, Local_Net_Amount__c = 25.00, Messages__c = 0.00, Non_Usage_Consumed__c = 0.00, 
                                    Service_Name__c = 'SN11');
  billingEntityObject5.Device_Details__c = deviceDetailsObject.Id;
  billingEntityObject5.Usage_Type__c = usageTypeObject1.Id;
  billingEntityObject5.Charge_Type__c = chargeTypeObject1.Id;
  billingEntityObject5.User__c = userObject3.Id;
  insert billingEntityObject5;
            
  MB_Billing_Entity__c billingEntityObject6 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC7', Billing_Month__c = Month_May, Call_Minutes__c = 0.00, Data_Consumed_In_MB__c = 0.00, 
                                    iPass_Consumed_In_MB__c = 100.00, Item_Count__c = 10.00, Local_Net_Amount__c = 50.00, Messages__c = 0.00, Non_Usage_Consumed__c = 0.00, 
                                    Service_Name__c = 'SN12');
  billingEntityObject6.Device_Details__c = deviceDetailsObject.Id;
  billingEntityObject6.Usage_Type__c = usageTypeObject2.Id;
  billingEntityObject6.Charge_Type__c = chargeTypeObject2.Id;
  billingEntityObject6.User__c = userObject3.Id;
  insert billingEntityObject6;
     
  MB_Billing_Entity__c billingEntityObject7 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC8', Billing_Month__c = Month_May, Call_Minutes__c = 0.00, Data_Consumed_In_MB__c = 500.00, 
                                    iPass_Consumed_In_MB__c = 0.00, Item_Count__c = 50.00, Local_Net_Amount__c = 175.00, Messages__c = 0.00, Non_Usage_Consumed__c = 0.00, 
                                    Service_Name__c = 'SN13');
  billingEntityObject7.Device_Details__c = deviceDetailsObject.Id;
  billingEntityObject7.Usage_Type__c = usageTypeObject3.Id;
  billingEntityObject7.Charge_Type__c = chargeTypeObject3.Id;
  billingEntityObject7.User__c = userObject3.Id;
  insert billingEntityObject7;
      
  MB_Billing_Entity__c billingEntityObject8= new MB_Billing_Entity__c(Billing_Currency__c = 'BC9', Billing_Month__c = Month_May, Call_Minutes__c = 0.00, Data_Consumed_In_MB__c = 0.00, 
                                    iPass_Consumed_In_MB__c = 0.00, Item_Count__c = 9.00, Local_Net_Amount__c = 75.00, Messages__c = 90.00, Non_Usage_Consumed__c = 0.00, 
                                    Service_Name__c = 'SN14');
  billingEntityObject8.Device_Details__c = deviceDetailsObject.Id;
  billingEntityObject8.Usage_Type__c = usageTypeObject4.Id;
  billingEntityObject8.Charge_Type__c = chargeTypeObject4.Id;
  billingEntityObject8.User__c = userObject3.Id;
  insert billingEntityObject8;
      
  MB_Billing_Entity__c billingEntityObject9 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC6', Billing_Month__c = Month_April, Call_Minutes__c = 50.00, Data_Consumed_In_MB__c = 0.00, 
                                    iPass_Consumed_In_MB__c = 0.00, Item_Count__c = 5.00, Local_Net_Amount__c = 25.00, Messages__c = 0.00, Non_Usage_Consumed__c = 0.00, 
                                    Service_Name__c = 'SN11');
      
  billingEntityObject9.Device_Details__c = deviceDetailsObject.Id;
  billingEntityObject9.Usage_Type__c = usageTypeObject1.Id;
  billingEntityObject9.Charge_Type__c = chargeTypeObject1.Id;
  billingEntityObject9.User__c = UserInfo.getUserId();
  insert billingEntityObject9;
            
  MB_Billing_Entity__c billingEntityObject10 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC7', Billing_Month__c = Month_April, Call_Minutes__c = 0.00, Data_Consumed_In_MB__c = 0.00, 
                                    iPass_Consumed_In_MB__c = 100.00, Item_Count__c = 10.00, Local_Net_Amount__c = 50.00, Messages__c = 0.00, Non_Usage_Consumed__c = 0.00, 
                                    Service_Name__c = 'SN12');
  billingEntityObject10.Device_Details__c = deviceDetailsObject.Id;
  billingEntityObject10.Usage_Type__c = usageTypeObject2.Id;
  billingEntityObject10.Charge_Type__c = chargeTypeObject2.Id;
  billingEntityObject10.User__c = UserInfo.getUserId();
  insert billingEntityObject10;
     
  MB_Billing_Entity__c billingEntityObject11 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC8', Billing_Month__c = Month_April, Call_Minutes__c = 0.00, Data_Consumed_In_MB__c = 500.00, 
                                    iPass_Consumed_In_MB__c = 0.00, Item_Count__c = 50.00, Local_Net_Amount__c = 175.00, Messages__c = 0.00, Non_Usage_Consumed__c = 0.00, 
                                    Service_Name__c = 'SN13');
  billingEntityObject11.Device_Details__c = deviceDetailsObject.Id;
  billingEntityObject11.Usage_Type__c = usageTypeObject3.Id;
  billingEntityObject11.Charge_Type__c = chargeTypeObject3.Id;
  billingEntityObject11.User__c = UserInfo.getUserId();
  insert billingEntityObject11;
  
  MB_Billing_Entity__c billingEntityObject12 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC9', Billing_Month__c = Month_April, Call_Minutes__c = 0.00, Data_Consumed_In_MB__c = 0.00, 
                                    iPass_Consumed_In_MB__c = 0.00, Item_Count__c = 9.00, Local_Net_Amount__c = 75.00, Messages__c = 90.00, Non_Usage_Consumed__c = 0.00, 
                                    Service_Name__c = 'SN14');
  billingEntityObject12.Device_Details__c = deviceDetailsObject.Id;
  billingEntityObject12.Usage_Type__c = usageTypeObject4.Id;
  billingEntityObject12.Charge_Type__c = chargeTypeObject4.Id;
  billingEntityObject12.User__c = UserInfo.getUserId();
  insert billingEntityObject12;

  MB_Wrapper_Class.MB_Device_Wrapper_Class wrapperObject2 = MB_Controller_Class.getUsageDetails(Month_May);
  System.assertEquals(wrapperObject2.totalCallUsagePattern,'00:49:60');
  System.assertEquals(wrapperObject2.totalDataUsage,500.00);
  System.assertEquals(wrapperObject2.totalIpassUsage,100.00);
  System.assertEquals(wrapperObject2.totalMessageUsage,90.00);
  System.assertEquals(wrapperObject2.totalUsage,325.00);
 
  MB_Wrapper_Class.MB_Device_Wrapper_Class wrapperObject3 = MB_Controller_Class.getUsageDetails('November 2015');
 }
         
  Test.stopTest();
  }
}