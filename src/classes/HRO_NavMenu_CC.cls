public with sharing class HRO_NavMenu_CC {
    public static  String HRADMIN='HRO_HRAdmin';
    public static  String HRMANAGER='HRO_HeadstartManager';
    public static  String HRNEWLEADER='HRO_Headstart';
    public static  List<String> HROPERMISSIONS=new List<String>{'HRO_HRAdmin','HRO_HeadstartManager','HRO_Headstart'};
        
    public String userId{get;set;}
   
    
    
    public  Boolean getIsHRAdmin(){
        Id hrAdminPermissionSet = [Select id From PermissionSet Where name =: HRADMIN Limit 1].get(0).Id;
        if([SELECT id from PermissionSetAssignment where AssigneeId =:userId AND PermissionSetId =: hrAdminPermissionSet].size()>0){
            return true;
        }
        return false;
    }
    
    public  Boolean getIsManager(){
        Id hroManager = [Select id From PermissionSet Where name =: HRMANAGER Limit 1].get(0).Id;
        if([SELECT id from PermissionSetAssignment where AssigneeId =:userId AND PermissionSetId =: hroManager].size()>0){
            return true;
        }
        return false;
    }
    
    public  Boolean getIsNewLeader(){
        Id hroNewLeader = [Select id From PermissionSet Where name =: HRNEWLEADER Limit 1].get(0).Id;
        if([SELECT id from PermissionSetAssignment where AssigneeId =:userId AND PermissionSetId =: hroNewLeader].size()>0){
            return true;
        }
        return false;
    }
	
    /*
    public static Boolean getIsNewLeader(){
        
        Map<Id,PermissionSet> permissionSetMap = new Map<ID,PermissionSet>([Select id,name From PermissionSet Where name in :HROPERMISSIONS]);
        for(PermissionSetAssignment assigment : [SELECT id from PermissionSetAssignment where AssigneeId =:userId AND PermissionSetId =: permissionSetMap.keySet()]){
            if(permissionSetMap.get(assigment.PermissionSetId).name == HRADMIN){
                isHRAdmin=true;
            }
            if(permissionSetMap.get(assigment.PermissionSetId).name == HRMANAGER){
                isManager=true;
            }
            
            if(permissionSetMap.get(assigment.PermissionSetId).name == HRNEWLEADER){
                isNewLeader=true;
            }
         }
        
        return true;
    }
	*/
    
    public String getOnboardingList(){
        Schema.DescribeSObjectResult r = HRO_Onboarding_Plan__c.sObjectType.getDescribe();
		String keyPrefix = r.getKeyPrefix();
        return '/'+keyPrefix+'/o';
    }
}