@isTest
/**
* Name          : FundTestFactory
* Description   : Fund test factory class for test classes
* @author       : ankita.tukaram.parab@accenture.com
* Date          : 03-May-2016
*/
public with sharing class UL_FundTestFactory {
    private static ACCL__Fund__c defaultFund;
    Public final static string FUND_STATUS_ACTIVE = 'Active';
     
    /* buildFund method which creates the fund record but does not insert into DB.
    Parameters passed  to this method are anchorCustomerExtension,anchorProduct,fundTemplate,status,validFrom,validThru*/
    public static ACCL__Fund__c buildFund(ACCL__Account_Extension__c anchorCustomerExtension,
                                    ACCL__Product__c anchorProduct,ACCL__Fund_Template__c fundTemplate,
                                    String status,Date validFrom,Date validThru) {
        ACCL__Fund__c fundRecord = new ACCL__Fund__c(); 
        fundRecord.ACCL__Anchor_Account__c=anchorCustomerExtension.ACCL__Account__c;
        if(anchorProduct != null){
            fundRecord.ACCL__Anchor_Product__c=anchorProduct.id;
        }
        fundRecord.ACCL__Fund_Template__c=fundTemplate.id;
        fundRecord.ACCL__Status__c=status;
        fundRecord.ACCL__Valid_From__c=validFrom;
        fundRecord.ACCL__Valid_Thru__c=validThru;
        return fundRecord;
    }
    /* buildDefaultFund method which builds the default fund record but does not insert into DB.
    No Parameters are passed to this method*/
    public static ACCL__Fund__c buildDefaultFund() {
        return buildFund(UL_AccountExtensionTestFactory.getDefaultAccountExtension(),
                        UL_ProductTestFactory.getDefaultProductForProductRecordType(),
                        UL_FundTemplateTestFactory.getDefaultFundTemplate(),
                        FUND_STATUS_ACTIVE,System.Today(),System.Today().adddays(5));
    }
    /* insertFund method which builds the default fund record and inserts into DB.
    Parameters passed  to this method are anchorCustomerExtension,anchorProduct,fundTemplate,status,validFrom,validThru*/
    public static ACCL__Fund__c insertFund(ACCL__Account_Extension__c anchorCustomerExtension,
                                    ACCL__Product__c anchorProduct,ACCL__Fund_Template__c fundTemplate,
                                    String status,Date validFrom,Date validThru) {
        ACCL__Fund__c fundRecord =  buildFund(anchorCustomerExtension,anchorProduct,fundTemplate,status,validFrom,validThru);
        insert fundRecord;
        return fundRecord;
    }
    /* getDefaultFund method which builds the default fund record and inserts into DB.
    No Parameters are passed to this method*/
    public static ACCL__Fund__c getDefaultFund() {
        if(defaultFund == null) {
            defaultFund = insertFund(UL_AccountExtensionTestFactory.getDefaultAccountExtension(),
                                    UL_ProductTestFactory.getDefaultProductForProductRecordType(),
                                    UL_FundTemplateTestFactory.getDefaultFundTemplate(),
                                    FUND_STATUS_ACTIVE,System.Today(),System.Today().adddays(5));
        }
        return defaultFund;
    }
    /* buildFundList method which builds list of fund records but do not insert into DB.
    Parameters passed  to this method are anchorCustomerExtension,listProduct,fundTemplate,status,validFrom,validThru*/
    public static List<ACCL__Fund__c> buildFundList(ACCL__Account_Extension__c anchorCustomerExtension,
                                            List<ACCL__Product__C> listProduct,ACCL__Fund_Template__c fundTemplate,
                                            String status,Date validFrom,Date validThru) {
        List<ACCL__Fund__c> listFundBuild=new List<ACCL__Fund__c>();
        for(Integer i=0;i<listProduct.size();i++){
            listFundBuild.add(buildFund(anchorCustomerExtension,listProduct[i],
                                        fundTemplate,status,validFrom.addDays(i),validFrom.addDays(i+1)));
        }
        return listFundBuild;
    }
    /* insertFundList method which builds list of fund records and inserts into DB.
    Parameters passed  to this method are anchorCustomerExtension,listProduct,fundTemplate,status,validFrom,validThru*/
    public static List<ACCL__Fund__c> insertFundList(ACCL__Account_Extension__c anchorCustomerExtension,
                                                List<ACCL__Product__C> listProduct,ACCL__Fund_Template__c fundTemplate,
                                                String status,Date validFrom,Date validThru) {
        List<ACCL__Fund__c> listFundBuild= buildFundList(anchorCustomerExtension,listProduct,fundTemplate,status,validFrom,validThru);
        insert listFundBuild;
        return listFundBuild;
    }

}