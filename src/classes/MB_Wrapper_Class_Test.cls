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
    deviceWrapperClassObject.dataVariance = true;
    deviceWrapperClassObject.callVariance = true;
    deviceWrapperClassObject.smsVariance = true;
    deviceWrapperClassObject.ipassVariance = true;
    
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
    
    Test.stopTest();
  }
}