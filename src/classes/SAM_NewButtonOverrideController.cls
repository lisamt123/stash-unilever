/********************************************************************
 Name:  SAM_NewButtonOverrideController()
 Copyright © 2016  Unilever
 ======================================================
======================================================
Purpose:  This class has methods for record types                                                     
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR    DATE              DETAIL                 Description
   1.0   Name      12/07/2016        INITIAL DEVELOPMENT           
***********************************************************************/
public with sharing class SAM_NewButtonOverrideController{
    
        public List<RecordType> schemeList{get;set;}
        public String recordtypeId {get;set;}
        public String titleText {get;set;}
        public List<RecordType>recordTypeInfoList{get;set;}
        public String retUrl;
        public List<PermissionSetAssignment> loggedInUserPermissionList;
        public PermissionSet requestorPermissionSet;  
        public PermissionSet samAdminPermissionSet;  
        public PermissionSet samTeamPermissionSet;  
        public boolean requestorFlag;
        public boolean samAdminFlag;
        public boolean samTeamFlag;  
                    
        public SAM_NewButtonOverrideController(ApexPages.StandardController controller){
        requestorFlag =false;
        samAdminFlag = false;
        samTeamFlag =false;
        retUrl = Apexpages.CurrentPage().getParameters().get(SAM_Constants.RETURL);
        loggedInUserPermissionList = [SELECT Id, PermissionSet.Name,AssigneeId FROM PermissionSetAssignment WHERE AssigneeId = :Userinfo.getUserId()];
        //Dinesh 26/7 - replace below hardcoded values with constants
        requestorPermissionSet = [select id,Name from PermissionSet where Name = 'SAM_Requestor' limit 1];
        samAdminPermissionSet = [select id,Name from PermissionSet where Name = 'SAM_Admin' limit 1];
        samTeamPermissionSet = [select id,Name from PermissionSet where Name = 'SAM_Team' limit 1];
        
        if(loggedInUserPermissionList.size()>0 ){
          for(PermissionSetAssignment permissionSetObj:loggedInUserPermissionList){
              if(requestorPermissionSet!=null){
                if(permissionSetObj.PermissionSet.Name == requestorPermissionSet.Name){
                    requestorFlag = true;
                }
               }else if(samAdminPermissionSet!=null){
                if(permissionSetObj.PermissionSet.Name == samAdminPermissionSet.Name){
                    samAdminFlag = true;
                }
               } else if(samTeamPermissionSet!=null){
                if(permissionSetObj.PermissionSet.Name == samTeamPermissionSet.Name){
                    samTeamFlag = true;
                }
               }  
            }
        }
        //Dinesh 26/7 - Remove this debug, once you are done with testing of this method
        system.debug('requestorFlag>>'+requestorFlag+'samAdminFlag>>'+samAdminFlag+'samTeamFlag>>'+samTeamFlag);
        
        //Dinesh 27/7 - modified below if condition to fix SonarQube issue
        //if(requestorFlag == true && samAdminFlag == false && samTeamFlag == false){
        if(requestorFlag && !samAdminFlag && !samTeamFlag){
                //Dinesh 26/7 - replace below hardcoded values with constants
                recordTypeInfoList = [SELECT Id,DeveloperName,Name,Description FROM RecordType Where DeveloperName IN('SAM_RW_Project_Request','SAM_RW_Non_Project_Request','SAM_RW_Query_Request')] ;
            }else{
                recordTypeInfoList = [SELECT Id,DeveloperName,Name,Description FROM RecordType Where DeveloperName IN('SAM_RW_Project_Request','SAM_RW_Non_Project_Request','SAM_RW_CrossCharge_Request','SAM_RW_Query_Request')] ;
            }
        }
        
    /*******************************************************************
    Purpose: This method is used to fetch record type list
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public  List<SelectOption> getRecordTypeList() {
        
        schemeList = new List<RecordType>();
        List<SelectOption> optionsList = new List<SelectOption>();
        try {
            //Dinesh 27/7 - modified below if condition to fix SonarQube issue
            //if(requestorFlag == true && samAdminFlag == false && samTeamFlag == false){
            if(requestorFlag && !samAdminFlag && !samTeamFlag){
                    //Dinesh 26/7 - replace below hardcoded values with constants
                    schemeList = [SELECT Id,DeveloperName,Name,Description FROM RecordType Where DeveloperName IN('SAM_RW_Project_Request','SAM_RW_Non_Project_Request','SAM_RW_Query_Request')] ;
                }else{
                     schemeList = [SELECT Id,DeveloperName,Name,Description FROM RecordType Where DeveloperName IN('SAM_RW_Project_Request','SAM_RW_Non_Project_Request','SAM_RW_CrossCharge_Request','SAM_RW_Query_Request')] ;
            }  
            system.debug('schemeList !!'+schemeList );
            if(!schemeList.isEmpty()) {
                //optionsList.add(new SelectOption('None','None'));
                for(RecordType schemeRs:schemeList) {
                    optionsList.add(new SelectOption(schemeRs.Id, schemeRs.Name));
                }   
                // optionsList.sort();
                return optionsList;
            }
        }catch (Exception e){
                system.debug(e.getMessage());
        }
        return new List<SelectOption>();
    }
    /*******************************************************************
    Purpose: This method is used to redirect the page
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public PageReference redirectToPageNewItem() {  
             PageReference massPageUrl = null;
            try{
                String UrlLink ='';
                UrlLink = '/'+SAM_Request__c.getSObjectType().getDescribe().getKeyPrefix()+'/e?retURL='+SAM_Request__c.getSObjectType().getDescribe().getKeyPrefix()+'&RecordType='+recordtypeId+'&nooverride=1';
                massPageUrl = new PageReference(UrlLink);
                massPageUrl.setRedirect(true);
                system.debug('massPageUrl>>>'+massPageUrl);  
            }catch(Exception e){
                system.debug(e.getMessage());
            } 
            return massPageUrl;
       
       }
       
    /*******************************************************************
    Purpose: This method is used to redirect to the cancel page
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public PageReference cancelRedirect() {  
      PageReference massPageUrl = null;
      try{
      
          if(retUrl!=null){
          massPageUrl = new PageReference(retUrl);
          massPageUrl.setRedirect(true);
          }
      }catch(Exception e){
          system.debug(e.getMessage());
      }     
        return massPageUrl;
    }
}