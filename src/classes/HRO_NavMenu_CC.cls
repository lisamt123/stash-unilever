/**********************************************************************
 Name:  HRO_NavMenu_CC()
 Copyright © 2015  Salesforce
 ======================================================
======================================================
Purpose:                                                            
Class for NavMenu Component                                                     
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL            Description
   1.0    Karol Szepietowski        22/10/2015      INITIAL DEVELOPMENT          CSR: 
***********************************************************************/

public with sharing class HRO_NavMenu_CC {
	
    public static final String HRADMIN = 'HRO_HRAdmin';
    public static final String HRMANAGER = 'HRO_HeadstartManager';
    
    public HRO_NavMenu_CC(){}
   /*******************************************************************
   Purpose:  Checking if current user have an HRO Admin permission set
   assigned                                                   
   Parameters: []
   Returns: [Boolean]
   Throws [Exceptions]: []                                                          
  ********************************************************************/
    public Boolean getIsHROAdmin(){
        system.debug('***HRO Entring getIsHROAdmin');
        Id hroAdminId = [Select id From PermissionSet Where name =: HRADMIN Limit 1].get(0).Id;
        List<PermissionSetAssignment> managerPermission = [SELECT id from PermissionSetAssignment where AssigneeId =:UserInfo.getUserId() AND PermissionSetId =: hroAdminId];
        if(!managerPermission.isEmpty()){
            system.debug('***HRO Exiting getIsHROAdmin:'+true);
            return true;
        }
        system.debug('***HRO Exiting getIsHROAdmin:'+false);
        return false;
    }
    
    /*******************************************************************
   Purpose:  Checking if current user have an HRO Manager permission set
   assigned                                                   
   Parameters: []
   Returns: [Boolean]
   Throws [Exceptions]: []                                                          
  ********************************************************************/
    public  Boolean getIsManager(){
        system.debug('***HRO Entring getIsManager');
        Id hroManager = [Select id From PermissionSet Where name =: HRMANAGER Limit 1].get(0).Id;
        List<PermissionSetAssignment> managerPermission = [SELECT id from PermissionSetAssignment where AssigneeId =:UserInfo.getUserId() AND PermissionSetId =: hroManager];
        if(!managerPermission.isEmpty()){
            system.debug('***HRO Exiting getIsManager:'+true);
            return true;
        }
        system.debug('***HRO Exiting getIsManager:'+false);
        return false;
    }
}