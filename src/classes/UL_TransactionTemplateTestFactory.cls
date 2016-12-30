@isTest
/**
* Name          : TransactionTemplateTestFactory
* Description   : Transaction Template test factory class for test classes
* @author       : ankita.tukaram.parab@accenture.com
* Date          : 16-May-2016
*/
public with sharing class UL_TransactionTemplateTestFactory {
    private static ACCL__Fund_Transaction_Template__c defaultTransactionTemplate;
    Public final static string TRANSACTION_TYPE_INITIAL = 'Initial';
    public final static String STRING_NULL = null;
    
    /**
    * Name          : buildTransactionTemplate
    * Description   : buildTransactionTemplate method for test classes
    * @author       : ankita.tukaram.parab@accenture.com
    * Date          : 16-May-2016
    */
    public static ACCL__Fund_Transaction_Template__c buildTransactionTemplate(Integer nameSuffix,
                                                                   String transactionType,Integer sortNumber,String salesOrg) {
        ACCL__Fund_Transaction_Template__c transactionTemplate = new ACCL__Fund_Transaction_Template__c();
        transactionTemplate.Name = 'test'+nameSuffix; 
        transactionTemplate.ACCL__Active__c = True;
        transactionTemplate.ACCL__Transaction_Type__c = transactionType;
        transactionTemplate.ACCL__Description_Language_1__c ='English';
        transactionTemplate.ACCL__Sort__c= sortNumber;
        transactionTemplate.ACCL__Sales_Org__c = salesOrg;
        return transactionTemplate;
    }
    /**
    * Name          : buildDefaultTransactionTemplate
    * Description   : buildDefaultTransactionTemplate method for test classes
    * @author       : ankita.tukaram.parab@accenture.com
    * Date          : 16-May-2016
    */
    public static ACCL__Fund_Transaction_Template__c buildDefaultTransactionTemplate() {
        return buildTransactionTemplate(-1,TRANSACTION_TYPE_INITIAL,1,STRING_NULL);
    }
    /**
    * Name          : insertTransactionTemplate
    * Description   : insertTransactionTemplate method for test classes
    * @author       : ankita.tukaram.parab@accenture.com
    * Date          : 16-May-2016
    */
    public static ACCL__Fund_Transaction_Template__c insertTransactionTemplate(Integer nameSuffix,
                                                                    String transactionType,Integer sortNumber,
                                                                    String salesOrg) {
        ACCL__Fund_Transaction_Template__c transactionTemplate = buildTransactionTemplate(nameSuffix,transactionType,sortNumber,salesOrg); 
        insert transactionTemplate;
        return transactionTemplate;
    }
    /**
    * Name          : getDefaultTransactionTemplate
    * Description   : getDefaultTransactionTemplate method for test classes
    * @author       : ankita.tukaram.parab@accenture.com
    * Date          : 16-May-2016
    */
    public static ACCL__Fund_Transaction_Template__c getDefaultTransactionTemplate() {
        if(defaultTransactionTemplate == null) {
            defaultTransactionTemplate = insertTransactionTemplate(-1,TRANSACTION_TYPE_INITIAL,1,STRING_NULL);   
        }
        return defaultTransactionTemplate;
    }
    /**
    * Name          : buildTransactionTemplateList
    * Description   : buildTransactionTemplateList method for test classes
    * @author       : ankita.tukaram.parab@accenture.com
    * Date          : 16-May-2016
    */
    public static List<ACCL__Fund_Transaction_Template__c> buildTransactionTemplateList(Integer noOfTransactionTemplate,
                                                                             String transactionType,Integer sortNumber,
                                                                             String salesOrg) {
        List<ACCL__Fund_Transaction_Template__c> listTransactionTemplate= new List<ACCL__Fund_Transaction_Template__c>();
        for(Integer i=0 ; i < noOfTransactionTemplate; i++){
          listTransactionTemplate.add(buildTransactionTemplate(i,transactionType,sortNumber,salesOrg));
        }
        return listTransactionTemplate;
    } 
    /**
    * Name          : insertTransactionTemplates
    * Description   : insertTransactionTemplates method for test classes
    * @author       : ankita.tukaram.parab@accenture.com
    * Date          : 16-May-2016
    */ 
    public static List<ACCL__Fund_Transaction_Template__c> insertTransactionTemplates(Integer noOfTransactionTemplate,
                                                                           String transactionType,Integer sortNumber,
                                                                           String salesOrg){
        List<ACCL__Fund_Transaction_Template__c> transactionTemplateList=  buildTransactionTemplateList(noOfTransactionTemplate,
                                                                                             transactionType,sortNumber,
                                                                                             salesOrg);
        insert transactionTemplateList;
        return transactionTemplateList;
    }
}