/***************************************************************
Class Name: MB_Wrapper_Class_Test.cls
Copyright © 2016 Salesforce

Purpose:
Requirement/Project Name: Unilever Salesforce Engagement
Requirement/Description: Test class For TEM app.

History:
VERSION     AUTHOR         DATE              DETAIL Description
1.0         Mindtree       27/05/2016        test class For TEM app
***************************************************************/

@IsTest
public with sharing class MB_Wrapper_Class_Test {
  static testMethod void testWrapperClass(){
    Test.startTest();
    
    MB_Wrapper_Class.MB_Device_Wrapper_Class deviceWrapperClassObject = new MB_Wrapper_Class.MB_Device_Wrapper_Class();
    deviceWrapperClassObject.userName = 'UN';
    deviceWrapperClassObject.deviceName = 'DN';
    deviceWrapperClassObject.deviceId = 'DI';
    deviceWrapperClassObject.deviceImageUrl = 'DIU';
    deviceWrapperClassObject.userCurrency = 'UC';
    deviceWrapperClassObject.totaldeviceUsage = 100.00;
    deviceWrapperClassObject.totalUsage = 200.00;
    deviceWrapperClassObject.totalDomesticCallUsage = 10.00;
    deviceWrapperClassObject.totalInternationalCallUsage = 10.00;
    deviceWrapperClassObject.totalDomesticSMSUsage = 10.00;
    deviceWrapperClassObject.totalInternationalSMSUsage = 10.00;
    deviceWrapperClassObject.totalDomesticDataUsage = 10.00;
    deviceWrapperClassObject.totalInternationalDataUsage = 10.00;
    deviceWrapperClassObject.totalDomesticIpassUsage = 10.00;
    deviceWrapperClassObject.totalInternationalIpassUsage = 10.00;
    deviceWrapperClassObject.totalDataUsage = 20.00;
    deviceWrapperClassObject.totalCallUsage = 20.00;
    deviceWrapperClassObject.totalMessageUsage = 20.00;
    deviceWrapperClassObject.totalIpassUsage = 20.00;
    deviceWrapperClassObject.totalnonUsage = 20.00;
    deviceWrapperClassObject.totalAverageDataUsage = 30.00;
    deviceWrapperClassObject.totalAverageCallUsage = 30.00;
    deviceWrapperClassObject.totalAverageMessageUsage = 30.00;
    deviceWrapperClassObject.totalAverageIpassUsage = 30.00;
    deviceWrapperClassObject.totalSpendVariance = true;
    deviceWrapperClassObject.dataVariance = true;
    deviceWrapperClassObject.callVariance = true;
    deviceWrapperClassObject.smsVariance = true;
    deviceWrapperClassObject.ipassVariance = true;
    deviceWrapperClassObject.nonUsageVariance = true;
    
    System.assertEquals(deviceWrapperClassObject.userName,'UN');
    System.assertEquals(deviceWrapperClassObject.deviceName,'DN');
    System.assertEquals(deviceWrapperClassObject.deviceId,'DI');
    System.assertEquals(deviceWrapperClassObject.deviceImageUrl,'DIU');
    System.assertEquals(deviceWrapperClassObject.userCurrency,'UC');
    System.assertEquals(deviceWrapperClassObject.totaldeviceUsage,100.00);
    System.assertEquals(deviceWrapperClassObject.totalUsage,200.00);
    System.assertEquals(deviceWrapperClassObject.totalDomesticCallUsage,10.00);
    System.assertEquals(deviceWrapperClassObject.totalInternationalCallUsage,10.00);
    System.assertEquals(deviceWrapperClassObject.totalDomesticSMSUsage,10.00);
    System.assertEquals(deviceWrapperClassObject.totalInternationalSMSUsage,10.00);
    System.assertEquals(deviceWrapperClassObject.totalDomesticDataUsage,10.00);
    System.assertEquals(deviceWrapperClassObject.totalInternationalDataUsage,10.00);
    System.assertEquals(deviceWrapperClassObject.totalDomesticIpassUsage,10.00);
    System.assertEquals(deviceWrapperClassObject.totalInternationalIpassUsage,10.00);
    System.assertEquals(deviceWrapperClassObject.totalDataUsage,20.00);
    System.assertEquals(deviceWrapperClassObject.totalCallUsage,20.00);
    System.assertEquals(deviceWrapperClassObject.totalMessageUsage,20.00);
    System.assertEquals(deviceWrapperClassObject.totalIpassUsage,20.00);
    System.assertEquals(deviceWrapperClassObject.totalnonUsage,20.00);
    System.assertEquals(deviceWrapperClassObject.totalAverageDataUsage,30.00);
    System.assertEquals(deviceWrapperClassObject.totalAverageCallUsage,30.00);
    System.assertEquals(deviceWrapperClassObject.totalAverageMessageUsage,30.00);
    System.assertEquals(deviceWrapperClassObject.totalAverageIpassUsage,30.00);
    System.assertEquals(deviceWrapperClassObject.dataVariance,true);
    System.assertEquals(deviceWrapperClassObject.callVariance,true);
    System.assertEquals(deviceWrapperClassObject.smsVariance,true);
    System.assertEquals(deviceWrapperClassObject.ipassVariance,true);
    System.assertEquals(deviceWrapperClassObject.totalSpendVariance,true);
    System.assertEquals(deviceWrapperClassObject.nonUsageVariance,true);
            
    MB_Wrapper_Class.DataChargeType_Wraper dataChargeTypeWraperObject = new MB_Wrapper_Class.DataChargeType_Wraper();
    dataChargeTypeWraperObject.chargeTypeName = 'DCT';
    dataChargeTypeWraperObject.totalSpend = 10.00;
    System.assertEquals(dataChargeTypeWraperObject.chargeTypeName, 'DCT');
    System.assertEquals(dataChargeTypeWraperObject.totalSpend, 10.00);
    
    MB_Wrapper_Class.CallsChargeType_Wraper callsChargeTypeWraperObject = new MB_Wrapper_Class.CallsChargeType_Wraper();
    callsChargeTypeWraperObject.chargeTypeName = 'CCT';
    callsChargeTypeWraperObject.totalSpend = 10.00;
    System.assertEquals(callsChargeTypeWraperObject.chargeTypeName, 'CCT');
    System.assertEquals(callsChargeTypeWraperObject.totalSpend, 10.00);
    
    MB_Wrapper_Class.MessagingChargeType_Wraper messagingChargeTypeWraperObject = new MB_Wrapper_Class.MessagingChargeType_Wraper();
    messagingChargeTypeWraperObject.chargeTypeName = 'MCT';
    messagingChargeTypeWraperObject.totalSpend = 10.00;
    System.assertEquals(messagingChargeTypeWraperObject.chargeTypeName, 'MCT');
    System.assertEquals(messagingChargeTypeWraperObject.chargeTypeName, 'MCT');
    
    MB_Wrapper_Class.NonUsageChargeType_Wrapper nonUsageChargeTypeWrapperObject = new MB_Wrapper_Class.NonUsageChargeType_Wrapper();
    nonUsageChargeTypeWrapperObject.chargeTypeName = 'NUCT';
    nonUsageChargeTypeWrapperObject.totalSpend = 10.00;
    System.assertEquals(nonUsageChargeTypeWrapperObject.chargeTypeName, 'NUCT');
    System.assertEquals(nonUsageChargeTypeWrapperObject.totalSpend, 10.00);
    
    MB_Wrapper_Class.IpassChargeType_Wraper ipassChargeTypeWraperObject = new MB_Wrapper_Class.IpassChargeType_Wraper();
    ipassChargeTypeWraperObject.chargeTypeName = 'ICT';
    ipassChargeTypeWraperObject.totalSpend = 10.00;
    System.assertEquals(ipassChargeTypeWraperObject.chargeTypeName, 'ICT');
    System.assertEquals(ipassChargeTypeWraperObject.totalSpend, 10.00);
      
    MB_Wrapper_Class.UsageAmountType_Wraper usageAmountTypeWraperObject = new MB_Wrapper_Class.UsageAmountType_Wraper();
    usageAmountTypeWraperObject.chargeTypeName = 'RD';
    usageAmountTypeWraperObject.UsageCurrentAmount = 50.00;
    usageAmountTypeWraperObject.UsagePreviousAmount = 40.00;
    usageAmountTypeWraperObject.UsageChangeAmount = 10.00;
    usageAmountTypeWraperObject.UsageVarience = 25;
    usageAmountTypeWraperObject.VarianceArrow = 1;
    usageAmountTypeWraperObject.userCurrency = 'USD';
    System.assertEquals(usageAmountTypeWraperObject.chargeTypeName,'RD');
    System.assertEquals(usageAmountTypeWraperObject.UsageCurrentAmount,50.00);
    System.assertEquals(usageAmountTypeWraperObject.UsagePreviousAmount,40.00);
    System.assertEquals(usageAmountTypeWraperObject.UsageChangeAmount,10.00);
    System.assertEquals(usageAmountTypeWraperObject.UsageVarience,25);
    System.assertEquals(usageAmountTypeWraperObject.VarianceArrow,1);
    System.assertEquals(usageAmountTypeWraperObject.userCurrency,'USD');
      
    MB_Wrapper_Class wrapperClassObject = new  MB_Wrapper_Class();
    List<MB_Wrapper_Class.DataChargeType_Wraper> list1 = new List<MB_Wrapper_Class.DataChargeType_Wraper>();
    list1.add(dataChargeTypeWraperObject);
    wrapperClassObject.dataWrapperList = list1;
    List<MB_Wrapper_Class.CallsChargeType_Wraper> list2 = new List<MB_Wrapper_Class.CallsChargeType_Wraper>();
    list2.add(callsChargeTypeWraperObject);
    wrapperClassObject.callsWrapperList = list2;
    List<MB_Wrapper_Class.MessagingChargeType_Wraper> list3 = new List<MB_Wrapper_Class.MessagingChargeType_Wraper>();
    list3.add(messagingChargeTypeWraperObject);
    wrapperClassObject.messageWrapperList = list3;
    List<MB_Wrapper_Class.IpassChargeType_Wraper> list4 = new List<MB_Wrapper_Class.IpassChargeType_Wraper>();
    list4.add(ipassChargeTypeWraperObject);
    wrapperClassObject.ipassWrapperList = list4;
    List<MB_Wrapper_Class.NonUsageChargeType_Wrapper> list5 = new List<MB_Wrapper_Class.NonUsageChargeType_Wrapper>();
    list5.add(nonUsageChargeTypeWrapperObject);
    wrapperClassObject.nonusageWrapperList = list5;
    wrapperClassObject.objdeviceWrapper = deviceWrapperClassObject;
      
    Test.stopTest();
  }
}