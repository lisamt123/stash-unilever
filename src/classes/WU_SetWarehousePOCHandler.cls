/*************************************************************
*@Author :          Cognizant
*@Date :            December 2015
*@Description :     Handler class for trigger WU_SetWarehousePOC
*************************************************************/
public class WU_SetWarehousePOCHandler 
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
            if(!userMap.isEmpty()){
                if(userMap.containsKey(wc.WU_WarehousePOC_Email__c)  && wc.WU_WarehousePOC_Email__c!=null){
                    User usr=userMap.get(wc.WU_WarehousePOC_Email__c);
                    wc.OwnerId =usr.Id;
                    //if(mgrMap.containsKey(usr.ManagerId)){
                        //wc.WU_WarehouseManager_Email__c=(mgrMap.get(usr.ManagerId)).Email;
                    //}
                }
            }
            else{
                wc.OwnerId =UserInfo.getuserid();
                
            }
        }
        isInserted = true;
    }
    
    public static void onBeforeUpdate(Map<Id, WU_Master_Warehouse__c>  oldMapItems, List<WU_Master_Warehouse__c> updatedItems, Map<Id, WU_Master_Warehouse__c> newMapItems) {
        userMap=getUserMap(updatedItems);
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
    private static Map<string, User> getUserMap(List<WU_Master_Warehouse__c> lstWc){
        set<string> profileSet= getUserProfile();
        set<string> eMailSet=new set<string>();
        for(WU_Master_Warehouse__c w:lstWc){
            eMailSet.add(w.WU_WarehousePOC_Email__c);
        }
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
        
        return userMap;
    }
    
    
   /** Get user profile detaqils for warehouse POC **/ 
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
}