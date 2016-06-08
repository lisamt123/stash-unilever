/******************************************** 
*@Author:Cognizant
*@Date:October 2014
*@Description : To update approver user 
*Referring in page ipm_approverList page 
*********************************************/
public with sharing class IPM_ApproverList {
    //*@Description:string value to search approver
    Public String searchapprover_STR{get;set;}
    //*@Description:list of IPM User Profile for approver list
    Public List<IPM_User_Profile__c>approverList{get;set;}
    //*@Description:check if no approver found
    Public Boolean noResultfound_Bool{get;set;}
    //*@Description:hold approver id
    public string approverid{get;set;}
    //*@Description:If approver has been selected then show the update button
    public Boolean displayApproveBtn{get;set;}
    //*@Description:hold bosscard id
    public string bosscardId{get;set;}
    private string saveApproverMethod='saveApprover';//saveApprover method
    private string IPM_ApproverList_STR=IPM_ApproverList.class.getName();//get class name
    //*@Description:constructor
    public IPM_ApproverList(){
        // call utility class to save having to do this multiple times in multiple places
        IPM_IECompatible.ieFix();
        noResultfound_Bool=false;
        displayApproveBtn=false;  
        searchapprover_STR=IPM_ConstantUtils.BLANK;
        bosscardId=apexpages.currentPage().getparameters().get(IPM_ConstantUtils.SF_ID);
        loadUserList();           
    }
    /********************************************************************************
    *@Description : For retriveing the approver list
    *********************************************************************************/
    public void searchApproverUser(){
        displayApproveBtn=false;
        noResultfound_Bool=false;
        if(!String.isEmpty(searchapprover_STR)){
            loadUserList();
        } 
        
        if(approverList.isEmpty()){
            noResultfound_Bool=true;
        }
        if(String.isEmpty(searchapprover_STR)){
            noResultfound_Bool=false;
            loadUserList();
        }
    }
    /********************************************************************************
    *@Description : hold the approver user id
    *********************************************************************************/
    public void holdApproverID(){
        if(!string.isEmpty(approverid)){
            displayApproveBtn=true; 
        }
        
    }
    /********************************************************************************
    *@Description : save the approver user
    *********************************************************************************/
    public void saveApprover(){
        if(string.isNotBlank(bosscardId)){
            IPM_Bosscard__c bossupdate=new IPM_Bosscard__C();
            bossupdate.id=bosscardId;
            bossupdate.IPM_Gate_Keeper__c=approverid;
            try{
                update bossupdate;
            }
            catch(Exception ex) {
                ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_ApproverList_STR,
                                                       saveApproverMethod,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, null);
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Label.IPM_Generic_ErrorMessage));              
            } 
        }
    }
    /********************************************************************************
    *@Description : For retriveing the approver list onload of the page
    *********************************************************************************/
    private void loadUserList(){
        approverList=new List<IPM_User_Profile__c>();
        map<id,id>avoidDupUsemap=new map<id,id>();
        String per_Str='%';
        String UQuery='SELECT IPM_User__c,IPM_User__r.name,IPM_User__r.smallphotourl,IPM_User__r.email ';
        UQuery+=' FROM IPM_User_Profile__c WHERE  IPM_User__r.IsActive=True AND (IPM_User__r.name Like \'' + per_Str + String.escapeSingleQuotes(searchapprover_STR) + per_Str + '\' ';
        UQuery+=' OR IPM_User__r.email Like \'' + per_Str + String.escapeSingleQuotes(searchapprover_STR) + per_Str + '\') LIMIT 50000';                            
        approverList=database.query(UQuery);
        for(IPM_User_Profile__c up:approverList){
            if(!avoidDupUsemap.containskey(up.IPM_User__c)){
                avoidDupUsemap.put(up.IPM_User__c,up.id);
            }
            
        }
        approverList=[SELECT IPM_User__r.id,IPM_User_Role__c,IPM_User__r.name,IPM_User__r.email,
                      IPM_User__r.SmallPhotoUrl FROM IPM_user_profile__c WHERE id IN:avoidDupUsemap.values() ORDER BY IPM_User__r.name limit 50000];
        
    }
}