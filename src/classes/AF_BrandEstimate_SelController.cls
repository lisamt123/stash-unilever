public with sharing class AF_BrandEstimate_SelController {

    public String agencyId {get;set;}
    public String fiscalYear {get;set;}
    public String brandId {get;set;}
    public List<AF_Brand_Estimate__c> brandEstimates {get;set;}
    public String linkRed{get;set;}
    public Boolean isAgencyFlag{get;set;}
    public AF_BrandEstimate_SelController() {
        isAgencyFlag=false;
        brandId = ApexPages.currentPage().getParameters().get('bId');
        agencyId = ApexPages.currentPage().getParameters().get('aId');
        fiscalYear = ApexPages.currentPage().getParameters().get('fy');
        
        User userObj = new User();
        userObj = [select Id,Contact.Account.Name, AF_Category__c, AF_Brand__c,Profile.Name, AF_Agency_Fees_User_Type__c from User where Id =:UserInfo.getUserId()];
        if(userObj.AF_Agency_Fees_User_Type__c=='Agency'){
            isAgencyFlag=true;
          }
            
        brandEstimates = [SELECT Name, AF_Status_Base_Fees__c FROM AF_Brand_Estimate__c 
                                WHERE Brand__c = :brandId AND AF_Agency__c = :agencyId AND AF_Fiscal_year__c = :fiscalYear  order by createddate desc];
        if(brandEstimates.size() == 1) {
            linkRed = brandEstimates[0].Id;
        }
        system.debug('** brandEstimates : ' + brandEstimates + ' ** brandId : ' + brandId + ' ** agencyId : ' + agencyId + '** fiscalYear : ' + fiscalYear);
    }
}