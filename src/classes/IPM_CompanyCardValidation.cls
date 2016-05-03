/*****************************************************************
@Description : Used for company card validation
@Created Date-15/09/2015
@Author: Cognizant
@Referenced:IPM_CompanyCard visual force page
*******************************************************************/

public with sharing class IPM_CompanyCardValidation {
    /*****************************************************************
    @Description:get edit access for company card
    @Return: boolean
    *******************************************************************/
    public static boolean companyCCValidation(Set<id>ccIdSet){
        boolean editAccess=false;
      
        List<IPM_User_Profile__c>userPList=new List<IPM_User_Profile__c>();
        List<IPM_Company_Card__c>ccardPList=new List<IPM_Company_Card__c>();
        userPList=[SELECT ID FROM IPM_User_Profile__c WHERE IPM_User_Function__c=:IPM_ConstantUtils.PERMISSION_USER_ROLE_DEPUTY_BUSINESS_PARTNER AND 
                    IPM_User__c=:userinfo.getuserid() AND IPM_Company_Card__c=:ccIdSet LIMIT 1000];
        if(!userPList.isEmpty()){
            editAccess=true;
            
        }
        ccardPList=[SELECT ID FROM IPM_Company_Card__c WHERE IPM_Business_Partner__c=:userinfo.getuserid() AND id=:ccIdSet LIMIT 1000];
        if(!ccardPList.isEmpty()){
            editAccess=true;
        }
        //security for central team 
        IPM_CustomPermission cpr = new IPM_CustomPermission();
        boolean isCentralTeam=false;
        isCentralTeam = cpr.hasPermission(IPM_ConstantUtils.IPM_CENTRALTEAM_PERMISSION);
        if(isCentralTeam){
            editAccess=true;
        }
        if(!editAccess){
            editAccess=companyCCNameValidation();
        }
        
        return  editAccess; 
    }
    /*****************************************************************
    @Description:get edit access for company card
    @Return: boolean
    *******************************************************************/
    public static boolean companyCCNameValidation(){
        boolean editAccess=false;
        String myProflieName=IPM_ConstantUtils.BLANK;
        List<Profile> profileList = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        if(!profileList.isEmpty()){
            myProflieName = profileList [0].Name;   
        }
        if(string.isNotblank(myProflieName) && myProflieName.equals(IPM_ConstantUtils.PERMISSION_SYSTEM_ADMINISTRATOR)){
            editAccess=true;
        }
        return  editAccess; 
    }

}