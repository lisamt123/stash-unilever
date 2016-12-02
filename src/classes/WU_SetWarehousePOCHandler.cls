/*************************************************************
*@Author :          Cognizant
*@Date :            December 2015
*@Description :     Handler class for trigger WU_SetWarehousePOC
*************************************************************/
public without sharing class WU_SetWarehousePOCHandler 
{
    public static Boolean isInserted = false;
    private static Map<string, User> userMap=new Map<string, User>();
    
    @Testvisible private WU_SetWarehousePOCHandler() {}
    public static void onBeforeInsert(List<WU_Master_Warehouse__c> InsertedItems, Map<Id, WU_Master_Warehouse__c> itemMap) {
    
        isInserted = false;
        userMap=getUserMap(InsertedItems);
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
        setOwner(InsertedItems);
    }
    
    public static void setOwner(List<WU_Master_Warehouse__c> InsertedItems) {
        Set<String> sUser = new Set<String>();
        for(WU_Master_Warehouse__c wareHouse: InsertedItems){
            if(String.isNotBlank(wareHouse.WU_WarehousePOC_Email__c)){
                sUser.add(wareHouse.WU_WarehousePOC_Email__c);
                //sUser.add(wareHouse.WU_Warehouse_Secondary_POC_Email__c);                
            }
            
        }
        Map<String, Id> mUserIdByEmail= new Map<String, Id>();
        for(User u : [SELECT ID, EMAIL FROM USER WHERE isActive=true and Email IN :sUser]){
            mUserIdByEmail.put(u.Email, u.Id);
        }
        
        for(WU_Master_Warehouse__c wareHouse: InsertedItems){
            if(String.isNotBlank(wareHouse.WU_WarehousePOC_Email__c) && mUserIdByEmail.ContainsKey(wareHouse.WU_WarehousePOC_Email__c)){
                wareHouse.OwnerId=mUserIdByEmail.get(wareHouse.WU_WarehousePOC_Email__c);
            }
        }
        
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
        // changed on 15.09.2016
        setOwner(updatedItems);

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
       
        return userMap;
    }
    
    
    
   /** Get user profile detaqils for warehouse POC **/ 
   /*
   
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
            list<WU_Master_Warehouse__Share> lstShareToInsert = new list<WU_Master_Warehouse__Share>();
            
            
            for(WU_Master_Warehouse__Share objShare : wareHouseShareList ){
                lstExistingUsers.add(objShare.ParentId);
            }
            list<WU_Master_Warehouse__Share> lstShared = [select id,ParentId,UserOrGroupId from WU_Master_Warehouse__Share Where ParentId in : lstExistingUsers ];
            System.debug('####wareHouseShareList (All )'+wareHouseShareList);
            System.debug('####lstShared (Existing)'+lstShared);
            for(WU_Master_Warehouse__Share objShare : wareHouseShareList){
                System.debug('####wareHouseShareList (Single )'+objShare);
                boolean isRecordExists = false;
                
                for(WU_Master_Warehouse__Share objExistingShare : lstShared ){
                    System.debug('####lstShared (Single Existing)'+objExistingShare);
                    if(objShare.ParentId == objExistingShare.ParentId &&  objShare.UserOrGroupId == objExistingShare.UserOrGroupId  ){
                        isRecordExists = true;
                        System.debug('####objShare (Single after test)'+objShare);
                    }
                }
                
                if(!isRecordExists){
                    lstShareToInsert.add(objShare);
                }
            }
            
            if(lstShareToInsert.size() > 0){
            System.debug('####'+lstShareToInsert);
                insert lstShareToInsert;
            }
        }
    }   
    
    public static void sendEmailSecPOC(List<WU_Master_Warehouse__c> wareHouseSecPocList)
    {
        set<string>emailSet = new set<string>();
        
        if(!wareHouseSecPocList.isEmpty()){
                
            for(WU_Master_Warehouse__c masterWH : wareHouseSecPocList)
            {
         
                                               
                if(masterWH.WU_Warehouse_Secondary_POC_Email__c != Null && masterWH.WU_Committed_Max_PalletStorage__c <> masterWH.WU_Prior_CommittedPalletStorage__c)
                {
                    
                    emailSet = retriveSetString(masterWH.WU_Warehouse_Secondary_POC_Email__c,emailSet);                             
                }
            }
            
            
            sendMessage(wareHouseSecPocList,emailSet);
        }
    }
    
    private static set<string>retriveSetString(string commaSeperatedString,set<string>commaSeperatedSet){
        if(!string.isBlank(commaSeperatedString)){
            if(commaSeperatedString.contains(','))commaSeperatedSet.addAll(commaSeperatedString.split(','));
            else commaSeperatedSet.add(commaSeperatedString);
        }
    return commaSeperatedSet;
    }       
    
    private static void sendMessage(List<WU_Master_Warehouse__c> wareHouseSecPocList1,set<string>emailSet){
        Map<string,Id> usersMap=new Map<string,Id>();
        for(User usr:[SELECT Id,Email FROM User WHERE Email In:emailSet]){
            usersMap.put(usr.Email,usr.Id);
        }
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        
        OrgWideEmailAddress orgEmail = [select id, DisplayName, Address from OrgWideEmailAddress where DisplayName ='WH Visibility'];
          
          EmailTemplate warehouseTemplateId = [select Id, DeveloperName, Subject, HtmlValue, Body from EmailTemplate where DeveloperName=: 'WU_Warehouse_Committed_StoragetoPOC'];
          System.debug(warehouseTemplateId +'warehouseTemplateId ************');
          
          
          
          for (WU_Master_Warehouse__c whLst : wareHouseSecPocList1) {
            if (whLst.WU_Warehouse_Secondary_POC_Email__c != null && whLst.WU_Committed_Max_PalletStorage__c <> whLst.WU_Prior_CommittedPalletStorage__c) {
              List<String> sendTo = new List<String>();
              // Step 1: Create a new Email
              Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
              // Step 2: Set list of people who should get the email
              //
              for(String emailId:whLst.WU_Warehouse_Secondary_POC_Email__c.split(',')){
                  sendTo.add(emailId);
              }
              // process the merge fields
                String subject = warehouseTemplateId.Subject;
                System.debug(whLst+'**************');
                if(whLst.WU_LocationName__c!=null)
                subject = subject.replace('{!WU_Master_Warehouse__c.WU_LocationName__c}', whLst.WU_LocationName__c);
                else
                subject = subject.replace('{!WU_Master_Warehouse__c.WU_LocationName__c}', '');
            
              
                String plainBody = warehouseTemplateId.Body;
                plainBody = plainBody.replace('{!WU_Master_Warehouse__c.OwnerFullName}', 'User(s)');
                if(whLst.WU_SAPCode_s__c!=null)
                plainBody = plainBody.replace('{!WU_Master_Warehouse__c.WU_SAPCode_s__c}', whLst.WU_SAPCode_s__c);
                if(whLst.Submitted_by__c!=null)
                plainBody = plainBody.replace('{!WU_Master_Warehouse__c.Submitted_by__c}', whLst.Submitted_by__c);
                else
                plainBody = plainBody.replace('{!WU_Master_Warehouse__c.Submitted_by__c}', '');
                
                if(whLst.WU_LocationName__c!=null)
                plainBody = plainBody.replace('{!WU_Master_Warehouse__c.WU_LocationName__c}', whLst.WU_LocationName__c);
                else
               plainBody = plainBody.replace('{!WU_Master_Warehouse__c.WU_LocationName__c}', '');
                if(whLst.WU_Prior_CommittedPalletStorage__c!=null)
                plainBody = plainBody.replace('{!WU_Master_Warehouse__c.WU_Prior_CommittedPalletStorage__c}', String.valueOf(whLst.WU_Prior_CommittedPalletStorage__c));
                if(whLst.WU_Committed_Max_PalletStorage__c!=null)
                plainBody = plainBody.replace('{!WU_Master_Warehouse__c.WU_Committed_Max_PalletStorage__c}', String.valueOf(whLst.WU_Committed_Max_PalletStorage__c));
    
                mail.setSubject(subject);
    mail.setPlainTextBody(plainBody);
        
              mail.setOrgWideEmailAddressId(orgEmail.Id);
              mail.setToAddresses(sendTo); 
                 mail.setOrgWideEmailAddressId(orgEmail.id);         
              mail.setTargetObjectId(UserInfo.getUserId());
              mail.setTreatTargetObjectAsRecipient(false);
              mail.setTemplateid(warehouseTemplateId.ID);
              mail.saveAsActivity = false;
              mails.add(mail);
            }
          }
      // Step 6: Send all emails in the master list
      System.debug(mails+'**************mails************');
      Messaging.sendEmail(mails);
        
    }
      public static void sendRejectionEmailSecPOC(List<WU_Master_Warehouse__c> wareHouseSecPocList)
    {
        set<string>emailSet = new set<string>();
        if(!wareHouseSecPocList.isEmpty()){
                
            for(WU_Master_Warehouse__c masterWH : wareHouseSecPocList)
            {
                System.debug(+'**************Rejection************'+masterWH );
                if(masterWH.WU_Warehouse_Secondary_POC_Email__c != Null && !string.isblank(masterWH.WU_Approval_Status__c) &&  masterWH.WU_Approval_Status__c.equalsIgnoreCase('Rejected'))
                {
                    emailSet = retriveSetString(masterWH.WU_Warehouse_Secondary_POC_Email__c,emailSet);                             
                }
            }
            
            
            sendRejectionMessage(wareHouseSecPocList,emailSet);
        }
    }


 private static void sendRejectionMessage(List<WU_Master_Warehouse__c> wareHouseSecPocList1,set<string>emailSet){
        Map<string,Id> usersMap=new Map<string,Id>();
        for(User usr:[SELECT Id,Email FROM User WHERE Email In:emailSet]){
            usersMap.put(usr.Email,usr.Id);
        }
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
          
          EmailTemplate warehouseTemplateId = [select Id, DeveloperName, Subject, HtmlValue, Body from EmailTemplate where DeveloperName=: 'WU_Warehouse_Committed_StoragetoPOC_Rejection'];
          System.debug(warehouseTemplateId +'warehouseTemplateId ************');
          
          OrgWideEmailAddress  orgEmail = [SELECT Id, DisplayName, Address FROM OrgWideEmailAddress where DisplayName ='WH Visibility'];
             
          
          for (WU_Master_Warehouse__c whLst : wareHouseSecPocList1) {
            if (whLst.WU_Warehouse_Secondary_POC_Email__c != null && !string.isblank(whLst.WU_Approval_Status__c) && whLst.WU_Approval_Status__c.equalsIgnoreCase('Rejected')) {
              List<String> sendTo = new List<String>();
              // Step 1: Create a new Email
              Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
              // Step 2: Set list of people who should get the email
              //
              for(String emailId:whLst.WU_Warehouse_Secondary_POC_Email__c.split(',')){
                  sendTo.add(emailId);
              }
              // process the merge fields
                String subject = warehouseTemplateId.Subject;
                System.debug(whLst+'**************');
                if(whLst.WU_LocationName__c!=null)
                subject = subject.replace('{!WU_Master_Warehouse__c.WU_LocationName__c}', whLst.WU_LocationName__c);
                else
                subject = subject.replace('{!WU_Master_Warehouse__c.WU_LocationName__c}', '');
            
          
                String plainBody = warehouseTemplateId.Body;
                plainBody = plainBody.replace('{!WU_Master_Warehouse__c.OwnerFullName}', 'User(s)');
               
               if(whLst.WU_SAPCode_s__c!=null)
                plainBody = plainBody.replace('{!WU_Master_Warehouse__c.WU_SAPCode_s__c}', whLst.WU_SAPCode_s__c);
                if(whLst.Submitted_by__c!=null)
                plainBody = plainBody.replace('{!WU_Master_Warehouse__c.Submitted_by__c}', whLst.Submitted_by__c);
                if(whLst.WU_LocationName__c!=null)
                plainBody = plainBody.replace('{!WU_Master_Warehouse__c.WU_LocationName__c}', whLst.WU_LocationName__c);
                else
                plainBody = plainBody.replace('{!WU_Master_Warehouse__c.WU_LocationName__c}', '');
                
                if(whLst.WU_Committed_Max_PalletStorage__c!=null)
                plainBody = plainBody.replace('{!WU_Master_Warehouse__c.WU_Committed_Max_PalletStorage__c}', String.valueOf(whLst.WU_Committed_Max_PalletStorage__c));
                
                        mail.setSubject(subject);
                       mail.setPlainTextBody(plainBody);
                        mail.setOrgWideEmailAddressId(orgEmail.id);
               
              mail.setToAddresses(sendTo); 
              mail.setOrgWideEmailAddressId(orgEmail.id);
              
              mail.setTargetObjectId(UserInfo.getUserId());
              mail.setTreatTargetObjectAsRecipient(false);
              mail.setTemplateid(warehouseTemplateId.ID);
              mail.saveAsActivity = false;
              mails.add(mail);
            }
          }
      // Step 6: Send all emails in the master list
      System.debug(mails+'**************mails************');
      Messaging.sendEmail(mails);
        
    }
     public static void sendApprovalEmailSecPOC(List<WU_Master_Warehouse__c> wareHouseSecPocList)
    {
        set<string>emailSet = new set<string>();
        if(!wareHouseSecPocList.isEmpty()){
                
            for(WU_Master_Warehouse__c masterWH : wareHouseSecPocList)
            {
                System.debug(+'**************Approved************'+masterWH );
                if(masterWH.WU_Warehouse_Secondary_POC_Email__c != Null && !string.isblank(masterWH.WU_Approval_Status__c) &&  masterWH.WU_Approval_Status__c.equalsIgnoreCase('Approved'))
                {
                    emailSet = retriveSetString(masterWH.WU_Warehouse_Secondary_POC_Email__c,emailSet);                             
                }
            }
            
            
            sendApprovalMessage(wareHouseSecPocList,emailSet);
        }
    }
    private static void sendApprovalMessage(List<WU_Master_Warehouse__c> wareHouseSecPocList1,set<string>emailSet){
        Map<string,Id> usersMap=new Map<string,Id>();
        for(User usr:[SELECT Id,Email FROM User WHERE Email In:emailSet]){
            usersMap.put(usr.Email,usr.Id);
        }
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        
          
          EmailTemplate warehouseTemplateId = [select Id, DeveloperName, Subject, HtmlValue, Body from EmailTemplate where DeveloperName=: 'WU_Warehouse_Committed_StoragetoPOC_for_Approval_Secondary_POC'];
          System.debug(warehouseTemplateId +'warehouseTemplateId ************');
          
         OrgWideEmailAddress  orgEmail = [SELECT Id, DisplayName, Address FROM OrgWideEmailAddress where DisplayName ='WH Visibility'];
             
          
          for (WU_Master_Warehouse__c whLst : wareHouseSecPocList1) {
            if (whLst.WU_Warehouse_Secondary_POC_Email__c != null && !string.isblank(whLst.WU_Approval_Status__c) && whLst.WU_Approval_Status__c.equalsIgnoreCase('Approved')) {
              List<String> sendTo = new List<String>();
              // Step 1: Create a new Email
              Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
              // Step 2: Set list of people who should get the email
              //
              for(String emailId:whLst.WU_Warehouse_Secondary_POC_Email__c.split(',')){
                  sendTo.add(emailId);
              }
              // process the merge fields
                 String subject = warehouseTemplateId.Subject;
                System.debug(whLst+'**************');
                if(whLst.WU_LocationName__c!=null)
                subject = subject.replace('{!WU_Master_Warehouse__c.WU_LocationName__c}', whLst.WU_LocationName__c);
                else
                subject = subject.replace('{!WU_Master_Warehouse__c.WU_LocationName__c}', '');
            
              
                String plainBody = warehouseTemplateId.Body;
                plainBody = plainBody.replace('{!WU_Master_Warehouse__c.OwnerFullName}', 'User(s)');
                if(whLst.WU_SAPCode_s__c!=null)
                plainBody = plainBody.replace('{!WU_Master_Warehouse__c.WU_SAPCode_s__c}', whLst.WU_SAPCode_s__c);
                if(whLst.Submitted_by__c!=null)
                plainBody = plainBody.replace('{!WU_Master_Warehouse__c.Submitted_by__c}', whLst.Submitted_by__c);
                else
                plainBody = plainBody.replace('{!WU_Master_Warehouse__c.Submitted_by__c}', '');
                
                if(whLst.WU_LocationName__c!=null)
                plainBody = plainBody.replace('{!WU_Master_Warehouse__c.WU_LocationName__c}', whLst.WU_LocationName__c);
                else
               plainBody = plainBody.replace('{!WU_Master_Warehouse__c.WU_LocationName__c}', '');
                //if(whLst.WU_Prior_CommittedPalletStorage__c!=null)
                //plainBody = plainBody.replace('{!WU_Master_Warehouse__c.WU_Prior_CommittedPalletStorage__c}', String.valueOf(whLst.WU_Prior_CommittedPalletStorage__c));
                if(whLst.WU_Committed_Max_PalletStorage__c!=null)
                plainBody = plainBody.replace('{!WU_Master_Warehouse__c.WU_Committed_Max_PalletStorage__c}', String.valueOf(whLst.WU_Committed_Max_PalletStorage__c));
    
                mail.setSubject(subject);
                mail.setPlainTextBody(plainBody);

              mail.setToAddresses(sendTo); 
               mail.setOrgWideEmailAddressId(orgEmail.Id);          
              mail.setTargetObjectId(UserInfo.getUserId());
              mail.setTreatTargetObjectAsRecipient(false);
              mail.setTemplateid(warehouseTemplateId.ID);
              mail.saveAsActivity = false;
              mail.setOrgWideEmailAddressId(orgEmail.id); 
              mails.add(mail);
            }
          }
      // Step 6: Send all emails in the master list
      System.debug(mails+'**************mails************');
      Messaging.sendEmail(mails);
        
    }
    
    
    
 }