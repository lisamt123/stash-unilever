@isTest
/**
* Name          : TransactionRowsTestFactory
* Description   : Transaction Row test factory class for test classes
* @author       : ankita.tukaram.parab@accenture.com
* Date          : 16-May-2016
*/
public with sharing class UL_TransactionRowTestFactory {
    private static ACCL__Fund_Transaction_Row__c defaultTransactionRow;
    Public final static string FUND_STATUS_ACTIVE = 'Active';
    
    /**
    * Name          : buildTransactionRow method
    * Description   : buildTransactionRow method for test classes
    * @author       : ankita.tukaram.parab@accenture.com
    * Date          : 16-May-2016
    */
    public static ACCL__Fund_Transaction_Row__c buildTransactionRow(Decimal amount,ACCL__Fund__c sourceFund,
                                                         ACCL__Fund__c targetFund,ACCL__Fund_Transaction__c transactionRecord) {
        ACCL__Fund_Transaction_Row__c transactionRowRecord = new ACCL__Fund_Transaction_Row__c(); 
        transactionRowRecord.ACCL__Amount__c = amount;
        transactionRowRecord.ACCL__Source_Fund__c = sourceFund.id;
        transactionRowRecord.ACCL__Target_Fund__c = targetFund.id;
        transactionRowRecord.ACCL__Fund_Transaction__c = transactionRecord.id;
        return transactionRowRecord;
    }
    /**
    * Name          : buildDefaultTransactionRow method
    * Description   : buildDefaultTransactionRow method for test classes
    * @author       : ankita.tukaram.parab@accenture.com
    * Date          : 16-May-2016
    */
    public static ACCL__Fund_Transaction_Row__c buildDefaultTransactionRow() {
        List<ACCL__Fund__c>listFund=UL_FundTestFactory.insertFundList(UL_AccountExtensionTestFactory.getDefaultAccountExtension(),
                                                             UL_ProductTestFactory.insertProducts(10),
                                                             UL_FundTemplateTestFactory.getDefaultFundTemplate(),
                                                             FUND_STATUS_ACTIVE,System.Today(),
                                                             System.Today().adddays(5));
        return buildTransactionRow(1000,listFund[0],listFund[1],
                                    UL_TransactionTestFactory.insertTransaction(1000,listFund[0],listFund[1],
                                    UL_TransactionTemplateTestFactory.getDefaultTransactionTemplate()));
    }
    
    /**
    * Name          : insertTransactionRow method
    * Description   : insertTransactionRow method for test classes
    * @author       : ankita.tukaram.parab@accenture.com
    * Date          : 16-May-2016
    */
    public static ACCL__Fund_Transaction_Row__c insertTransactionRow(Decimal amount, ACCL__Fund__c sourceFund,ACCL__Fund__c targetFund,
                                                          ACCL__Fund_Transaction__c transactionRecord){
        ACCL__Fund_Transaction_Row__c transactionRowRecord =  buildTransactionRow(amount,sourceFund,targetFund,transactionRecord) ;
        insert transactionRowRecord;
        return transactionRowRecord;
    }
    
    /**
    * Name          : getDefaultTransactionRow method
    * Description   : getDefaultTransactionRow method for test classes
    * @author       : ankita.tukaram.parab@accenture.com
    * Date          : 16-May-2016
    */
    public static ACCL__Fund_Transaction_Row__c getDefaultTransactionRow() {
        if(defaultTransactionRow == null) {
        List<ACCL__Fund__c>listFund=UL_FundTestFactory.insertFundList(UL_AccountExtensionTestFactory.getDefaultAccountExtension(),
                                                             UL_ProductTestFactory.insertProducts(10),
                                                             UL_FundTemplateTestFactory.getDefaultFundTemplate(),
                                                             FUND_STATUS_ACTIVE,System.Today(),
                                                             System.Today().adddays(5));
            defaultTransactionRow = insertTransactionRow(1000,listFund[0],listFund[1],
                                                         UL_TransactionTestFactory.insertTransaction(1000,listFund[0],listFund[1],
                                                         UL_TransactionTemplateTestFactory.getDefaultTransactionTemplate()));
        }
        return defaultTransactionRow;
    }
}