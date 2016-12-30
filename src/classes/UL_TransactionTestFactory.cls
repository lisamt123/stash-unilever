@isTest
/**
* Name          : TransactionTestFactory
* Description   : Transaction test factory class for test classes
* @author       : ankita.tukaram.parab@accenture.com
* Date          : 16-May-2016
*/
public with sharing class UL_TransactionTestFactory {
    public static ACCL__Fund_Transaction__c defaultTransaction;
    Public final static string FUND_STATUS_ACTIVE = 'Active';

    /* buildTransaction method which will create the Transaction record but will not insert it into DB.
    This method takes amount,source fund,target fund and transaction template as parameters
    */
    public static ACCL__Fund_Transaction__c buildTransaction(Decimal amount,ACCL__Fund__c sourceFund,
                                                  ACCL__Fund__c targetFund,ACCL__Fund_Transaction_Template__c transactionTemplate) {
        ACCL__Fund_Transaction__c transactionRecord = new ACCL__Fund_Transaction__c(); 
        transactionRecord.ACCL__Amount__c = amount;
        if(sourceFund != null){
            transactionRecord.ACCL__Source_Fund__c = sourceFund.id;
        }
        transactionRecord.ACCL__Target_Fund__c = targetFund.id;
        transactionRecord.ACCL__Fund_Transaction_Template__c =transactionTemplate.id;
        return transactionRecord;
    }
    /* buildDefaultTransaction method which will create the default Transaction record but will not insert it into DB.
    This method does not take any parameters
    */
    public static ACCL__Fund_Transaction__c buildDefaultTransaction() {
        List<ACCL__Fund__c>listFund=UL_FundTestFactory.insertFundList(UL_AccountExtensionTestFactory.getDefaultAccountExtension(),
                                                            UL_ProductTestFactory.insertProducts(10),UL_FundTemplateTestFactory.getDefaultFundTemplate(),
                                                            FUND_STATUS_ACTIVE,System.Today(),System.Today().adddays(5));
        return buildTransaction(1000,listFund[0],listFund[1],UL_TransactionTemplateTestFactory.getDefaultTransactionTemplate());
    }
    /* insertTransaction method which will create the Transaction record and  will insert it into DB.
    This method takes amount,source fund,target fund and transaction template as parameters
    */
    public static ACCL__Fund_Transaction__c insertTransaction(Decimal amount, ACCL__Fund__c sourceFund,
                                                   ACCL__Fund__c targetFund,ACCL__Fund_Transaction_Template__c transactionTemplate ){
        ACCL__Fund_Transaction__c transactionRecord =  buildTransaction(amount,sourceFund,targetFund,transactionTemplate ) ;
        insert transactionRecord;
        return transactionRecord;
    }
    /* getDefaultTransaction method which will create the default Transaction record and will insert it into DB.
    This method does not take any parameters*/
    public static ACCL__Fund_Transaction__c getDefaultTransaction() {
        if(defaultTransaction == null) {
        List<ACCL__Fund__c>listFund=UL_FundTestFactory.insertFundList(UL_AccountExtensionTestFactory.getDefaultAccountExtension(),
                                                            UL_ProductTestFactory.insertProducts(10),UL_FundTemplateTestFactory.getDefaultFundTemplate(),
                                                            FUND_STATUS_ACTIVE,System.Today(),System.Today().adddays(5));
            defaultTransaction = insertTransaction(1000,listFund[0],listFund[1],
                                 UL_TransactionTemplateTestFactory.getDefaultTransactionTemplate());
        }
        return defaultTransaction;
    }
    /* buildTransactionList method which will create the Transaction record but will not insert it into DB.
    This method takes amount,source fund,target fund and transaction template as parameters*/
    public static List<ACCL__Fund_Transaction__c> buildTransactionList(Decimal amount,List<ACCL__Fund__c>sourceFundList,
                                                            List<ACCL__Fund__c> targetFundList,ACCL__Fund_Transaction_Template__c transactionTemplate ) {
        List<ACCL__Fund_Transaction__c> listTransactionBuild=new List<ACCL__Fund_Transaction__c>();
        for(Integer i=0;i<sourceFundList.size();i++){
            for(Integer j=0;j<targetFundList.size();j++){
            listTransactionBuild.add(buildTransaction(amount,sourceFundList[i],targetFundList[i],transactionTemplate));
        }
      }
        return listTransactionBuild;
    }
    /* buildTransaction method which will create the Transaction record but will not insert it into DB.
    This method takes amount,source fund,target fund and transaction template as parameters*/
    public static List<ACCL__Fund_Transaction__c> insertTransactionList(Decimal amount,List<ACCL__Fund__c>sourceFundList,
                                                            List<ACCL__Fund__c> targetFundList,ACCL__Fund_Transaction_Template__c transactionTemplate ) {
        List<ACCL__Fund_Transaction__c> listTransactionBuild= buildTransactionList(amount,sourceFundList,targetFundList,transactionTemplate);
        insert listTransactionBuild;
        return listTransactionBuild;
    }

}