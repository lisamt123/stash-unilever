public class AF_middlebonusmatrix {
    public String url_brandid{get;set;}
    Public String url_agencyid{get;set;}
    Public String url_year{get;set;}
    Public String bonusSummaryId {get;set;}
    Public  List<AF_Bonus_Summary__c> bonusSummaries{get;set;}
    public Boolean isAgencyAccess{get;set;}
    public Boolean isAgencyFlag{get;set;}
        public AF_middlebonusmatrix (){
       isAgencyFlag=false;
       isAgencyAccess = false;
       url_brandid=ApexPages.currentPage().getParameters().get('Brandid');
       url_agencyid=ApexPages.currentPage().getParameters().get('Agencyid');
       url_year=ApexPages.currentPage().getParameters().get('Year');
        User userObj = new User();
        userObj = [select AF_Agency_Fees_User_Type__c from User where Id =:UserInfo.getUserId()];
        if(userObj.AF_Agency_Fees_User_Type__c=='Agency'){
            isAgencyFlag=true;
        }
        List<AF_Agency_Bonus_Access__c> agencyAccessList = AF_Agency_Bonus_Access__c.getall().values();
                system.debug('** agencyAccessList : ' + agencyAccessList);
        for(AF_Agency_Bonus_Access__c eachBonusSetting : agencyAccessList) {
            system.debug(system.today() + ' ** eachBonusSetting.AF_Access_Date__c : ' + eachBonusSetting.AF_Access_Date__c);
            system.debug(url_year + ' ** eachBonusSetting.AF_Access_Date__c : ' + eachBonusSetting.AF_Fiscal_Year__c);
                        if(isAgencyFlag && eachBonusSetting.AF_Access_Date__c <= system.today() && url_year == eachBonusSetting.AF_Fiscal_Year__c) {
                                isAgencyAccess = true;  
                        }
                }  
     bonusSummaries = [SELECT ID,AF_Agency__c, Name,
                                                        (SELECT AF_Agency_Entity__r.AF_Country__c,AF_Unilever_Entity__r.Name
                                                            FROM Bonus_Matrix__r) 
                                                         FROM AF_Bonus_Summary__c 
                                                         WHERE AF_Brand__c=:url_brandid and AF_Agency__c=:url_agencyid and AF_Fiscal_Year__c=:url_year LIMIT 1];
       if(bonusSummaries.size()==1){
       bonusSummaryId =bonusSummaries[0].id;
       system.debug('bonusSummaryId '+bonusSummaryId );
       }
       
 }    
}