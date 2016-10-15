/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_BrandEstimate_SelController
@CreateDate : 14/7/2014
@Description : This is a controller class for AgencyHomePage Page, 
@             this is used to display all the Brand Estimate for a particular year in an intermediate page before Base Fee Matrix.
@Version : 1.0
@reference : none
****************************************************************************************************************************/
public with sharing class AF_BrandEstimate_SelController {
    public String agencyId {get;set;}
    public String fiscalYear {get;set;}
    public String brandId {get;set;}
    public List<AF_Brand_Estimate__c> brandEstimates {get;set;}
    public String linkRed{get;set;}
    public Boolean isAgencyFlag{get;set;}
    public String categoryParam{get;set;}
    public String brandVal{get;set;}
    /**********************************************************************
*  @Description: Contructor method
*  @name : AF_BrandEstimate_SelController
*  @param : none
*  @return : none
*************************************************************************/  
    public AF_BrandEstimate_SelController() {
        isAgencyFlag=false;
        brandId = ApexPages.currentPage().getParameters().get('bId');
        agencyId = ApexPages.currentPage().getParameters().get('aId');
        fiscalYear = ApexPages.currentPage().getParameters().get('fy');
        categoryParam = ApexPages.currentPage().getParameters().get('category');
        brandVal = ApexPages.currentPage().getParameters().get('brandvalue');
        User userObj = new User();
        userObj = [select Id,Contact.Account.Name, AF_Category__c, AF_Brand__c,Profile.Name, AF_Agency_Fees_User_Type__c from User where Id =:UserInfo.getUserId()];
        if(userObj.AF_Agency_Fees_User_Type__c==AF_Constants.UT_AGENCY){
            isAgencyFlag=true;
        }
        brandEstimates = [SELECT Name, AF_Status_Base_Fees__c FROM AF_Brand_Estimate__c 
        WHERE Brand__c = :brandId AND AF_Agency__c = :agencyId AND AF_Fiscal_year__c = :fiscalYear  order by createddate desc];
        if(brandEstimates.size() == 1) {
            linkRed = brandEstimates[0].Id;
        }
    }
}