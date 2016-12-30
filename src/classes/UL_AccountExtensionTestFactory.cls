@isTest
/**
* Name          : AccountExtensionTestFactory
* Description   : AccountExtension test factory class for test classes
* @author       : ankita.tukaram.parab@accenture.com
* Date          : 03-May-2016
*/
public with sharing class UL_AccountExtensionTestFactory {
    public static ACCL__Account_Extension__c defaultAccountExtension;
    public static ACCL__Account_Extension__c buildAccountExtension(Account account,Date fundValidFrom,Date fundValidThru,
                                                            Date billToValidFrom,Date billToValidThru,
                                                            Date brokerRoleValidFrom,Date brokerRoleValidThru,
                                                            Date customerValidFrom,Date customerValidThru,
                                                            Date deliveryRoleValidFrom,Date deliveryRoleValidThru,
                                                            Date orderRoleValidFrom,Date orderRoleValidThru,
                                                            Date payerRoleValidFrom,Date payerRoleValidThru,
                                                            Date storeRoleValidFrom,Date storeRoleValidThru,
                                                            Date promotionValidFrom,Date promotionValidThru){
        ACCL__Account_Extension__c accountExtensionRecord = new ACCL__Account_Extension__c();
        accountExtensionRecord.ACCL__Account__c = account.id;
        accountExtensionRecord.ACCL__Fund_Role_Valid_From__c= fundValidFrom;
        accountExtensionRecord.ACCL__Fund_Role_Valid_Thru__c= fundValidThru;
        accountExtensionRecord.ACCL__Bill_To_Role_Valid_From__c= billToValidFrom;
        accountExtensionRecord.ACCL__Bill_To_Role_Valid_Thru__c= billToValidThru;
        accountExtensionRecord.ACCL__Broker_Role_Valid_From__c= brokerRoleValidFrom;
        accountExtensionRecord.ACCL__Broker_Role_Valid_Thru__c= brokerRoleValidThru;
        accountExtensionRecord.ACCL__Customer_Role_Valid_From__c= customerValidFrom;
        accountExtensionRecord.ACCL__Customer_Role_Valid_Thru__c= customerValidThru;
        accountExtensionRecord.ACCL__Delivery_Role_Valid_From__c= deliveryRoleValidFrom;
        accountExtensionRecord.ACCL__Delivery_Role_Valid_Thru__c= deliveryRoleValidThru;
        accountExtensionRecord.ACCL__Order_Role_Valid_From__c= orderRoleValidFrom;
        accountExtensionRecord.ACCL__Order_Role_Valid_Thru__c= orderRoleValidThru;
        accountExtensionRecord.ACCL__Payer_Role_Valid_From__c= payerRoleValidFrom;
        accountExtensionRecord.ACCL__Payer_Role_Valid_Thru__c= payerRoleValidThru;
        accountExtensionRecord.ACCL__Promotion_Valid_From__c= promotionValidFrom;
        accountExtensionRecord.ACCL__Promotion_Valid_Thru__c= promotionValidThru;
        accountExtensionRecord.ACCL__Store_Role_Valid_From__c= storeRoleValidFrom;
        accountExtensionRecord.ACCL__Store_Role_Valid_Thru__c= storeRoleValidThru;
        
        return accountExtensionRecord;
    }
    public static ACCL__Account_Extension__c buildDefaultAccountExtension() {
        return buildAccountExtension(UL_AccountTestFactory.getDefaultAccount(),System.Today(),System.Today().addDays(5),
                                    System.Today(),System.Today().addDays(5),
                                    System.Today(),System.Today().addDays(5),
                                    System.Today(),System.Today().addDays(5),
                                    System.Today(),System.Today().addDays(5),
                                    System.Today(),System.Today().addDays(5),
                                    System.Today(),System.Today().addDays(5),
                                    System.Today(),System.Today().addDays(5),
                                    System.Today(),System.Today().addDays(5)
                                    );
    }
    public static ACCL__Account_Extension__c insertAccountExtension(Account account,Date fundValidFrom,Date fundValidThru,
                                                            Date billToValidFrom,Date billToValidThru,
                                                            Date brokerRoleValidFrom,Date brokerRoleValidThru,
                                                            Date customerValidFrom,Date customerValidThru,
                                                            Date deliveryRoleValidFrom,Date deliveryRoleValidThru,
                                                            Date orderRoleValidFrom,Date orderRoleValidThru,
                                                            Date payerRoleValidFrom,Date payerRoleValidThru,
                                                            Date storeRoleValidFrom,Date storeRoleValidThru,
                                                            Date promotionValidFrom,Date promotionValidThru){
        ACCL__Account_Extension__c accountExtensionRecord =  buildAccountExtension(account,fundValidFrom,fundValidThru,
                                                            billToValidFrom,billToValidThru,brokerRoleValidFrom,brokerRoleValidThru,
                                                            customerValidFrom,customerValidThru,
                                                            deliveryRoleValidFrom,deliveryRoleValidThru,
                                                            orderRoleValidFrom,orderRoleValidThru,
                                                            payerRoleValidFrom,payerRoleValidThru,
                                                            storeRoleValidFrom,storeRoleValidThru,
                                                            promotionValidFrom,promotionValidThru);
        insert accountExtensionRecord;
        return accountExtensionRecord;
    }
    public static ACCL__Account_Extension__c getDefaultAccountExtension() {
        if(defaultAccountExtension == null) {
            defaultAccountExtension = insertAccountExtension(UL_AccountTestFactory.getDefaultAccount(),
                                    System.Today(),System.Today().addDays(5),
                                    System.Today(),System.Today().addDays(5),
                                    System.Today(),System.Today().addDays(5),
                                    System.Today(),System.Today().addDays(5),
                                    System.Today(),System.Today().addDays(5),
                                    System.Today(),System.Today().addDays(5),
                                    System.Today(),System.Today().addDays(5),
                                    System.Today(),System.Today().addDays(5),
                                    System.Today(),System.Today().addDays(5));
        }
        return defaultAccountExtension;
    }
}