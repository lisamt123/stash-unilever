/***************************************************************
Class Name: MB_Controller_IPassVarienceClass_Test.cls
Copyright © 2016 Salesforce

Purpose:
Requirement/Project Name: Unilever Salesforce Engagement
Requirement/Description: Test class For TEM app.

History:
VERSION     AUTHOR         DATE              DETAIL Description
1.0         Mindtree       30/05/2016        test class For TEM app
***************************************************************/

@IsTest
public class MB_Controller_IPassVarienceClass_Test{
  static testMethod void testUsageDetailClass(){
   
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
  System.runAs(userObject1)
  {   
      MB_Device_Details__c deviceDetailsObject = new MB_Device_Details__c(Name = 'Nokia Lumia 625');
      insert deviceDetailsObject;
      MB_Usage_Type__c usageTypeObject1 = new MB_Usage_Type__c(Name = 'iPass');
      insert usageTypeObject1;
      MB_Charge_Type__c chargeTypeObject1 = new MB_Charge_Type__c(Name = 'Domestic Wi-Fi Offloading');
      insert chargeTypeObject1; 
      MB_Usage_Type__c usageTypeObject2 = new MB_Usage_Type__c(Name = 'NonUsage');
      insert usageTypeObject2;
      MB_Charge_Type__c chargeTypeObject2 = new MB_Charge_Type__c(Name = 'Recurring');
      insert chargeTypeObject2; 
      
      MB_Billing_Entity__c billingEntityObject1 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC1', Billing_Month__c = 'January 2016', Call_Minutes__c = 50.00, Data_Consumed_In_MB__c = 0.00, 
                                        iPass_Consumed_In_MB__c = 0.00, Item_Count__c = 5.00, Local_Net_Amount__c = 25.00, Messages__c = 0.00, Non_Usage_Consumed__c = 0.00, 
                                        Service_Name__c = 'SN1');
      billingEntityObject1.Device_Details__c = deviceDetailsObject.Id;
      billingEntityObject1.Usage_Type__c = usageTypeObject1.Id;
      billingEntityObject1.Charge_Type__c = chargeTypeObject1.Id;
      billingEntityObject1.User__c = UserInfo.getUserId();
      insert billingEntityObject1;
      
      MB_Billing_Entity__c billingEntityObject2 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC2', Billing_Month__c = 'February 2016', Call_Minutes__c = 80.00, Data_Consumed_In_MB__c = 0.00, 
                                    iPass_Consumed_In_MB__c = 0.00, Item_Count__c = 8.00, Local_Net_Amount__c = 44.00, Messages__c = 0.00, Non_Usage_Consumed__c = 0.00, 
                                    Service_Name__c = 'SN2');
      billingEntityObject2.Device_Details__c = deviceDetailsObject.Id;
      billingEntityObject2.Usage_Type__c = usageTypeObject1.Id;
      billingEntityObject2.Charge_Type__c = chargeTypeObject1.Id;
      billingEntityObject2.User__c =UserInfo.getUserId();
      insert billingEntityObject2;
      
      MB_Billing_Entity__c billingEntityObject3 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC3', Billing_Month__c = 'March 2016', Call_Minutes__c = 60.00, Data_Consumed_In_MB__c = 0.00, 
                                    iPass_Consumed_In_MB__c = 0.00, Item_Count__c = 6.00, Local_Net_Amount__c = 30.00, Messages__c = 0.00, Non_Usage_Consumed__c = 0.00, 
                                    Service_Name__c = 'SN3');
      billingEntityObject3.Device_Details__c = deviceDetailsObject.Id;
      billingEntityObject3.Usage_Type__c = usageTypeObject1.Id;
      billingEntityObject3.Charge_Type__c = chargeTypeObject1.Id;
      billingEntityObject3.User__c = UserInfo.getUserId();
      insert billingEntityObject3;
      
      MB_Billing_Entity__c billingEntityObject4 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC4', Billing_Month__c = 'April 2016', Call_Minutes__c = 60.00, Data_Consumed_In_MB__c = 0.00, 
                                    iPass_Consumed_In_MB__c = 0.00, Item_Count__c = 6.00, Local_Net_Amount__c = 30.00, Messages__c = 0.00, Non_Usage_Consumed__c = 0.00, 
                                    Service_Name__c = 'SN4');
      billingEntityObject4.Device_Details__c = deviceDetailsObject.Id;
      billingEntityObject4.Usage_Type__c = usageTypeObject1.Id;
      billingEntityObject4.Charge_Type__c = chargeTypeObject1.Id;
      billingEntityObject4.User__c = UserInfo.getUserId();
      insert billingEntityObject4;
      
      MB_Billing_Entity__c billingEntityObject5 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC1', Billing_Month__c = 'January 2016', Call_Minutes__c = 0.00, Data_Consumed_In_MB__c = 0.00, 
                                        iPass_Consumed_In_MB__c = 0.00, Item_Count__c = 5.00, Local_Net_Amount__c = 25.00, Messages__c = 0.00, Non_Usage_Consumed__c = 0.00, 
                                        Service_Name__c = 'SN1');
      billingEntityObject5.Device_Details__c = deviceDetailsObject.Id;
      billingEntityObject5.Usage_Type__c = usageTypeObject2.Id;
      billingEntityObject5.Charge_Type__c = chargeTypeObject2.Id;
      billingEntityObject5.User__c = UserInfo.getUserId();
      insert billingEntityObject5;
      
      MB_Billing_Entity__c billingEntityObject6 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC2', Billing_Month__c = 'February 2016', Call_Minutes__c = 0.00, Data_Consumed_In_MB__c = 0.00, 
                                    iPass_Consumed_In_MB__c = 0.00, Item_Count__c = 8.00, Local_Net_Amount__c = 44.00, Messages__c = 0.00, Non_Usage_Consumed__c = 0.00, 
                                    Service_Name__c = 'SN2');
      billingEntityObject6.Device_Details__c = deviceDetailsObject.Id;
      billingEntityObject6.Usage_Type__c = usageTypeObject2.Id;
      billingEntityObject6.Charge_Type__c = chargeTypeObject2.Id;
      billingEntityObject6.User__c =UserInfo.getUserId();
      insert billingEntityObject6;
      
      MB_Billing_Entity__c billingEntityObject7 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC3', Billing_Month__c = 'March 2016', Call_Minutes__c = 0.00, Data_Consumed_In_MB__c = 0.00, 
                                    iPass_Consumed_In_MB__c = 0.00, Item_Count__c = 6.00, Local_Net_Amount__c = 30.00, Messages__c = 0.00, Non_Usage_Consumed__c = 0.00, 
                                    Service_Name__c = 'SN3');
      billingEntityObject7.Device_Details__c = deviceDetailsObject.Id;
      billingEntityObject7.Usage_Type__c = usageTypeObject2.Id;
      billingEntityObject7.Charge_Type__c = chargeTypeObject2.Id;
      billingEntityObject7.User__c = UserInfo.getUserId();
      insert billingEntityObject7;
      
      MB_Billing_Entity__c billingEntityObject8 = new MB_Billing_Entity__c(Billing_Currency__c = 'BC4', Billing_Month__c = 'April 2016', Call_Minutes__c = 60.00, Data_Consumed_In_MB__c = 0.00, 
                                    iPass_Consumed_In_MB__c = 0.00, Item_Count__c = 6.00, Local_Net_Amount__c = 30.00, Messages__c = 0.00, Non_Usage_Consumed__c = 0.00, 
                                    Service_Name__c = 'SN4');
      billingEntityObject8.Device_Details__c = deviceDetailsObject.Id;
      billingEntityObject8.Usage_Type__c = usageTypeObject2.Id;
      billingEntityObject8.Charge_Type__c = chargeTypeObject2.Id;
      billingEntityObject8.User__c = UserInfo.getUserId();
      insert billingEntityObject8;
      
      Decimal totalUsageAmount1 = MB_Controller_IPassVarienceClass.getSpendDetails(billingEntityObject1.Billing_Month__c,usageTypeObject1.Name);
      System.assertEquals(totalUsageAmount1,25.00); 
      
      Decimal totalUsageAmount2 = MB_Controller_IPassVarienceClass.getSpendDetails(billingEntityObject5.Billing_Month__c ,usageTypeObject2.Name);
      System.assertEquals(totalUsageAmount2,25.00);
     
      Decimal TotalUsageAmount3 = MB_Controller_IPassVarienceClass.getSpendDetailsforchargetype(billingEntityObject1.Billing_Month__c ,chargeTypeObject1.Name); 
      System.assertEquals(totalUsageAmount3,25.00); 
     
      Decimal TotalUsageAmount4 = MB_Controller_IPassVarienceClass.getSpendDetailsforchargetype(billingEntityObject5.Billing_Month__c ,chargeTypeObject2.Name); 
      System.assertEquals(totalUsageAmount4,0.00); 
      
      String previousBillingPeriod = MB_Controller_IPassVarienceClass.getPreviousMonth(billingEntityObject1.Billing_Month__c); 
      System.assertEquals(previousBillingPeriod,'December 2015'); 
      
      MB_Billing_Currency__c billingCurrencyObject = new MB_Billing_Currency__c(Name = 'GBP',Symbol__c= 'S1');
      insert billingCurrencyObject;
      
      MB_Wrapper_Class.UsageAmountType_Wraper wraperObject1 = MB_Controller_IPassVarienceClass.getUsageTotalAmount(billingEntityObject1.Billing_Month__c ,usageTypeObject1.Name);
      System.assertEquals(wraperObject1.chargeTypeName,'iPass'); 
      System.assertEquals(wraperObject1.UsageCurrentAmount,25.00); 
      System.assertEquals(wraperObject1.UsagePreviousAmount,0.00); 
      System.assertEquals(wraperObject1.UsageChangeAmount,25.00); 
      System.assertEquals(wraperObject1.UsageVarience,0); 
      System.assertEquals(wraperObject1.VarianceArrow,1); 
      
      MB_Wrapper_Class.UsageAmountType_Wraper wraperObject2 = MB_Controller_IPassVarienceClass.getUsageTotalAmount(billingEntityObject2.Billing_Month__c ,usageTypeObject1.Name);
      System.assertEquals(wraperObject2.UsageCurrentAmount,44.00); 
      System.assertEquals(wraperObject2.UsagePreviousAmount,25.00); 
      System.assertEquals(wraperObject2.UsageChangeAmount,19.00); 
      System.assertEquals(wraperObject2.UsageVarience,76); 
      System.assertEquals(wraperObject2.VarianceArrow,1); 
      
      MB_Wrapper_Class.UsageAmountType_Wraper wraperObject3 = MB_Controller_IPassVarienceClass.getUsageTotalAmount(billingEntityObject4.Billing_Month__c ,usageTypeObject1.Name);
      System.assertEquals(wraperObject3.UsageCurrentAmount,30.00); 
      System.assertEquals(wraperObject3.UsagePreviousAmount,30.00); 
      System.assertEquals(wraperObject3.UsageChangeAmount,0.00); 
      System.assertEquals(wraperObject3.UsageVarience,0); 
      System.assertEquals(wraperObject3.VarianceArrow,3); 
      
       
      
      List<MB_Wrapper_Class.UsageAmountType_Wraper> wraperList1 = MB_Controller_IPassVarienceClass.getSpendDetailsforChargelist(billingEntityObject1.Billing_Month__c ,usageTypeObject1.Name);
      System.assert(wraperList1 != null); 
      
      List<MB_Wrapper_Class.UsageAmountType_Wraper> wraperList2 = MB_Controller_IPassVarienceClass.getSpendDetailsforChargelist(billingEntityObject2.Billing_Month__c ,usageTypeObject1.Name);
      System.assert(wraperList2 != null);  
            
      List<MB_Wrapper_Class.UsageAmountType_Wraper> wraperList3 = MB_Controller_IPassVarienceClass.getSpendDetailsforChargelist(billingEntityObject4.Billing_Month__c ,usageTypeObject1.Name);
      System.assert(wraperList3 != null); 
      
      List<MB_Wrapper_Class.UsageAmountType_Wraper> wraperList4 = MB_Controller_IPassVarienceClass.getSpendDetailsforChargelist(billingEntityObject5.Billing_Month__c ,usageTypeObject2.Name);
      System.assert(wraperList4 != null);  
      
      List<MB_Wrapper_Class.UsageAmountType_Wraper> wraperList5 = MB_Controller_IPassVarienceClass.getSpendDetailsforChargelist(billingEntityObject6.Billing_Month__c ,usageTypeObject2.Name);
      System.assert(wraperList5 != null); 
            
      List<MB_Wrapper_Class.UsageAmountType_Wraper> wraperList6 = MB_Controller_IPassVarienceClass.getSpendDetailsforChargelist(billingEntityObject8.Billing_Month__c ,usageTypeObject2.Name);
      System.assert(wraperList6 != null); 
      
      
  }
  
  Test.stopTest();
  }
  }