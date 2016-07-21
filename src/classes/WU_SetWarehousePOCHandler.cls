/*************************************************************
*@Author :          Cognizant
*@Date :            December 2015
*@Description :     Handler class for trigger WU_SetWarehousePOC
*************************************************************/
public with sharing class WU_SetWarehousePOCHandler 
{
    public static Boolean isInserted = false;
    private static Map<string, User> userMap=new Map<string, User>();
    //private static Map<Id, User> mgrMap=new Map<Id, User>();
    //private static List<WU_Master_Warehouse__c> errorWCU = new List<WU_Master_Warehouse__c>();
    
    private WU_SetWarehousePOCHandler() {}
    public static void onBeforeInsert(List<WU_Master_Warehouse__c> InsertedItems, Map<Id, WU_Master_Warehouse__c> itemMap) {
        isInserted = false;
        userMap=getUserMap(InsertedItems);
        //mgrMap=GetManagerMap(InsertedItems);
        system.debug('@userMap--->'+userMap);
        for(WU_Master_Warehouse__c wc:InsertedItems){
            
            wc.WU_Prior_CommittedPalletStorage__c=wc.WU_Committed_Max_PalletStorage__c;
            if(Date.today().month()!=wc.WU_Previous_Month__c){
                wc.WU_Previous_Month__c=Date.today().month();
            }
            if(userMap.isEmpty()){
                wc.OwnerId =UserInfo.getuserid();
            }
        }
        isInserted = true;
    }
    
    public static void onAfterInsert(List<WU_Master_Warehouse__c> InsertedItems) {
        list<WU_Warehouse_Capacity_Detail__c> warehouseCapacityDetailListToInsert = new list<WU_Warehouse_Capacity_Detail__c>();
        for(WU_Master_Warehouse__c masterWH : InsertedItems ){
            if(masterWH.WU_Committed_Max_PalletStorage__c != Null && masterWH.WU_Current_Utilization__c != Null && masterWH.WU_ToDate__c != Null &&
                masterWH.WU_FromDate__c != Null && masterWH.WU_Utilization_Type__c != Null  ){
                    WU_Warehouse_Capacity_Detail__c warehouseCapacityDetail = new WU_Warehouse_Capacity_Detail__c();
                    warehouseCapacityDetail.Master_Warehouse__c = masterWH.id;
                    warehouseCapacityDetail.WU_Committed_Max_PalletStorage__c = masterWH.WU_Committed_Max_PalletStorage__c;
                    warehouseCapacityDetail.WU_Current_Pallet_Utilization__c = masterWH.WU_Current_Utilization__c;
                    warehouseCapacityDetail.WU_Utilization_End_Date__c = masterWH.WU_ToDate__c;
                    warehouseCapacityDetail.WU_Utilization_Start_Date__c = masterWH.WU_FromDate__c;
                    warehouseCapacityDetail.WU_Utilization_Type__c = masterWH.WU_Utilization_Type__c;
                    warehouseCapacityDetailListToInsert.add(warehouseCapacityDetail);
            }
        }
        insert warehouseCapacityDetailListToInsert;
    }
    
    public static void onBeforeUpdate(Map<Id, WU_Master_Warehouse__c>  oldMapItems, List<WU_Master_Warehouse__c> updatedItems, Map<Id, WU_Master_Warehouse__c> newMapItems) {
        userMap=getUserMap(updatedItems);
        system.debug ('###@@UserMap--->'+userMap);
        //mgrMap=GetManagerMap(updatedItems);
        WU_Master_Warehouse__c oldWc;
        for(WU_Master_Warehouse__c wc:updatedItems){
            if(oldMapItems.containsKey(wc.Id)){
                oldWc=oldMapItems.get(wc.Id);
                
                if(oldWc!=null && oldWc.WU_Committed_Max_PalletStorage__c!=wc.WU_Committed_Max_PalletStorage__c) 
                {
                    wc.WU_Prior_CommittedPalletStorage__c=oldWc.WU_Committed_Max_PalletStorage__c;
                }
                if(oldWc!=null && oldWc.WU_WarehousePOC_Email__c!=wc.WU_WarehousePOC_Email__c) 
                {
                    //UpdatePOCOwner(wc, userMap, mgrMap);
                    UpdatePOCOwner(wc, userMap);
                }
            }
            IsNewMonth(wc);
            
        }
        

    }
    
    /*
    * Allow updates only if :
    *     Start Date is changed
    *     Old value of Current Utilization is non zero and not null
    *
    * Throw error if:
    *     Start date remains same, but Current utilization is changed from a non zero, non null value to a some other numeric value  and 
    *     if the current day falls between the Start Date and End Dates.
    *
    *    What to be done if Start & End Date changes to some future date. This will allow updating the values till the time updates are 
    *    done on a day which does not fall between Start & End Dates.
    */
    
    Private static void IsNewMonth(WU_Master_Warehouse__c wc){
         if(Date.today().month()!=wc.WU_Previous_Month__c){
            wc.WU_Previous_Month__c=Date.today().month();
         }
    }
    //Private static void UpdatePOCOwner(WU_Master_Warehouse__c wc, Map<string, User> urMap,Map<Id, User> mrMap){
    Private static void UpdatePOCOwner(WU_Master_Warehouse__c wc, Map<string, User> urMap){
        if(!urMap.isEmpty() && (urMap.containsKey(wc.WU_WarehousePOC_Email__c)  && wc.WU_WarehousePOC_Email__c!=null)){
                User usr=urMap.get(wc.WU_WarehousePOC_Email__c);
                system.debug('@@@user---->'+usr);
                wc.OwnerId =usr.Id;
                //if(usr.ManagerId==null){wc.WU_WarehouseManager_Email__c='';}
                //if(mrMap.containsKey(usr.ManagerId)){
                    //wc.WU_WarehouseManager_Email__c=(mrMap.get(usr.ManagerId)).Email;
                //}
        }
        else{
            wc.OwnerId =UserInfo.getuserid();
        }
    }   
   
   /*
    public static Map<Id, User> GetManagerMap(List<WU_Master_Warehouse__c> lstWc){
        set<string> sProfile=getManagerProfile();
        system.debug('@@@sProfile--->'+sProfile);
        set<string> eMailSet=new set<string>();
        for(WU_Master_Warehouse__c w:lstWc){
            eMailSet.add(w.WU_WarehousePOC_Email__c);
        }
        /*sProfile.add('WU-Logistics Leadership Team');
        sProfile.add('WU-Warehouse Excellence Operations');        */
       /* if(!sProfile.isEmpty())
        {
            Map<Id,Profile> pMap=new Map<Id,Profile>([Select Id from profile where name IN : sProfile]);
            mgrMap=new Map<Id, User>([Select u.Profile.Name, u.ProfileId, u.Name, u.LastName, u.Id, u.FirstName, u.Email,u.ManagerId From User u 
                            where u.IsActive=true
                            and u.Email IN :eMailSet
                            and u.ProfileId IN: pMap.keySet() LIMIT 2000]);
        }
        
                        
        return  mgrMap;              
    }*/
     
    /** Get user mapping  **/
    private static Map<string, User> getUserMap(List<WU_Master_Warehouse__c> lstWc)
    {
        set<String> pocUsers = fetchUsersWithExcellencePermissions();
        //set<string> profileSet= getUserProfile();
        set<string> eMailSet=new set<string>();
        
        for(WU_Master_Warehouse__c w:lstWc){
            eMailSet.add(w.WU_WarehousePOC_Email__c);
        }
        
        if(!pocUsers.isEmpty() && !eMailSet.isEmpty())
        {
            for(User ur:[Select  u.Profile.Name, u.ProfileId, u.Name, u.LastName, u.Id, u.FirstName, u.Email,u.ManagerId From User u 
                            where u.IsActive=true
                            and u.Id IN :pocUsers
                            and u.Email In :eMailSet
                            LIMIT 2000])
                            {
                                userMap.put(ur.Email, ur); 
                            }
        }
        /*
        if(!profileSet.isEmpty())
        {
            Map<Id,Profile> pMap=new Map<Id,Profile>([Select Id from profile where name IN : profileSet]);
              
            for(User ur:[Select  u.Profile.Name, u.ProfileId, u.Name, u.LastName, u.Id, u.FirstName, u.Email,u.ManagerId From User u 
                            where u.IsActive=true
                            and u.Email IN :eMailSet
                            and u.ProfileId IN: pMap.keySet() LIMIT 2000]){
                userMap.put(ur.Email, ur);
               
            }
        }
        */
        return userMap;
    }
    
    
    
   /** Get user profile detaqils for warehouse POC **/ 
   /*
    private static set<string> getUserProfile(){
        set<string> profileSet=new set<string>();
        WMS_Settings__c profileCode = WMS_Settings__c.getValues('WarehousePOC Profile'); 
        if(profileCode!=null)
        {
            string aryProfile=profileCode.Warehouse_Profiles__c;
            List<string> lstProfile=aryProfile.split(',');
            if(!lstProfile.isEmpty()){
                profileSet.addAll(lstProfile);
            }
            else{
                profileSet.add(aryProfile);
            }
        }
        
        system.debug ('***profileSet-->'+profileSet);
        return profileSet;
    }
    */
    private static Set<String> fetchUsersWithExcellencePermissions()
    {
        Set<String> UserIds = new Set<String>();
        Set<String> permissionLabelsSet = new Set<String>();
        WU_Permission_Set_Name__c permissionSetLabel = WU_Permission_Set_Name__c.getValues('PermissionSetName'); 
                
        if(permissionSetLabel!=null)
        {
            string permSetName=permissionSetLabel.Permission_Name__c;
            List<string> lstPerms=permSetName.split(',');
            if(!lstPerms.isEmpty()){
                permissionLabelsSet.addAll(lstPerms);
            }
            else{
                permissionLabelsSet.add(permSetName);
            }
        }
        if(!permissionLabelsSet.isEmpty())
        {
            List<PermissionSetAssignment> excellencePermissionAssigneesList = new List<PermissionSetAssignment>();
            excellencePermissionAssigneesList = [SELECT Assignee.Name,AssigneeId FROM PermissionSetAssignment where PermissionSetId IN : permissionLabelsSet LIMIT 2000];
            
            for(PermissionSetAssignment perm : excellencePermissionAssigneesList)
            {
                UserIds.add(perm.AssigneeId);
            }
        }
        
        return UserIds;
    }
    /** Get user profile detaqils for warehouse POC **/ 
    /*
    private static set<string> getManagerProfile(){
        set<string> profileSet=new set<string>();
        WMS_Settings__c profileCode = WMS_Settings__c.getValues('WarehousePOC Profile'); 
        if(profileCode!=null)
        {
            string aryProfile=profileCode.Warehouse_ManagerProfiles__c;
            List<string> lstProfile=aryProfile.split(','); 
            if(!lstProfile.isEmpty()){
                profileSet.addAll(lstProfile);
            }
            else{
                profileSet.add(aryProfile);
            }
            
        }
        
        system.debug ('***profileSet-->'+profileSet);
        return profileSet;
    }
    */
    /*For Sharing Records with POC Email Owners*/
    
    
    public static void wareHouseShare(List<WU_Master_Warehouse__c> newWareHouseShareList){
        Set<String> userEmail=new Set<String>();
        List<WU_Master_Warehouse__Share> wareHouseShareList=new List<WU_Master_Warehouse__Share>();
        for(WU_Master_Warehouse__c masterWare:newWareHouseShareList){
            if(String.isNotBlank(masterWare.WU_WarehousePOC_Email__c)){
                userEmail.add(masterWare.WU_WarehousePOC_Email__c);
            }
            if(String.isNotBlank(masterWare.WU_Warehouse_Secondary_POC_Email__c)){
                for(String email:masterWare.WU_Warehouse_Secondary_POC_Email__c.split(',')){
                    userEmail.add(email);
                }
            }
        }
        Map<String,User> userIdMap=new Map<String,User>();
        for(User u:[Select Id,Email from User where isActive=true and Email in:userEmail]){
            userIdMap.put(u.Email,u);
        }
        for(WU_Master_Warehouse__c masterWareHouse:newWareHouseShareList){
             if(String.isNotBlank(masterWareHouse.WU_Warehouse_Secondary_POC_Email__c)){
                for(String sEmail:masterWareHouse.WU_Warehouse_Secondary_POC_Email__c.split(',')){
                    if(userIdMap.containsKey(sEmail) && masterWareHouse.owner.Email != sEmail  ){
                        WU_Master_Warehouse__Share wareShare=new WU_Master_Warehouse__Share();
                        wareShare.ParentId=masterWareHouse.Id;
                        wareShare.AccessLevel = 'Edit';
                        wareShare.UserOrGroupId = userIdMap.get(sEmail).Id;
                        wareHouseShareList.add(wareShare);
                    }
                }
            }
            if(String.isNotBlank(masterWareHouse.WU_WarehousePOC_Email__c) && userIdMap.containsKey(masterWareHouse.WU_WarehousePOC_Email__c)){
                if(masterWareHouse.owner.Email != masterWareHouse.WU_WarehousePOC_Email__c){
                    WU_Master_Warehouse__Share wareShare=new WU_Master_Warehouse__Share();
                    wareShare.ParentId=masterWareHouse.Id;
                    wareShare.AccessLevel = 'Edit';
                    wareShare.UserOrGroupId = userIdMap.get(masterWareHouse.WU_WarehousePOC_Email__c).Id;
                    wareHouseShareList.add(wareShare);
                }
            }
        }
        updateWareHouseShare(wareHouseShareList);
    }

    public static void updateWareHouseShare(List<WU_Master_Warehouse__Share> wareHouseShareList){
        if(!wareHouseShareList.isEmpty()){
            list<string> lstExistingUsers = new list<string>();
            //Map<string,list<string>> mapExistingUser = new Map<string,list<string>>();
            list<WU_Master_Warehouse__Share> lstShareToInsert = new list<WU_Master_Warehouse__Share>();
            
            
            for(WU_Master_Warehouse__Share objShare : wareHouseShareList ){
                lstExistingUsers.add(objShare.ParentId);
            }
            list<WU_Master_Warehouse__Share> lstShared = [select id,ParentId,UserOrGroupId from WU_Master_Warehouse__Share Where ParentId in : lstExistingUsers ];
            /*
            for(string parentRecordRecId : lstExistingUsers ){
                list<string> existingUserlst = new list<string>();
                mapExistingUser.put(parentRecordRecId,existingUserlst);
                for(WU_Master_Warehouse__Share objShare1: lstShared ){
                    if(parentRecordRecId == objShare1.ParentId ){
                        
                    }
                }
            }
            */
            
            for(WU_Master_Warehouse__Share objShare : wareHouseShareList){
                boolean isRecordExists = false;
                for(WU_Master_Warehouse__Share objExistingShare : lstShared ){
                    if(objShare.ParentId == objExistingShare.ParentId &&  objShare.UserOrGroupId == objExistingShare.UserOrGroupId  ){
                        isRecordExists = true;
                    }
                }
                
                if(!isRecordExists){
                    lstShareToInsert.add(objShare);
                }
            }
            
            if(lstShareToInsert.size() > 0){
                insert lstShareToInsert;
            }
        }
    }   
}
}