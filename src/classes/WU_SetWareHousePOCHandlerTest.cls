/*@Author :          Cognizant
*@Date :            March 2016
*@Description :     To test WU_WarehouseSearchController Class.
*************************************************************/
    
    @isTest(SeeAlldata=false)
private class WU_SetWareHousePOCHandlerTest {
    static testMethod void onBeforeTest() {
        test.startTest();
        // test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
          User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='test@dummy1.com');
          insert u;
        
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'WU_Warehouse_Admin'];
       
        EmailTemplate validEmailTemplate = new EmailTemplate();
        validEmailTemplate.isActive = true;
        validEmailTemplate.Name = 'name';
        validEmailTemplate.DeveloperName = 'test';
        validEmailTemplate.TemplateType = 'text';
        validEmailTemplate.FolderId = UserInfo.getUserId();
        validEmailTemplate.Subject = 'WU_warehouse_subject';
        validEmailTemplate.Body = 'WU_warehouse_body';
        insert validEmailTemplate;
        // Assign the above inserted user for the above Permission Set.
        PermissionSetAssignment psa = new PermissionSetAssignment();
        psa.AssigneeId = u.Id;
        psa.PermissionSetId = ps.Id;
        insert psa;
           System.runAs(u)
           {
       list<WU_Master_Warehouse__c>masterWareHouseList = new list<WU_Master_Warehouse__c>();
       map<Id,WU_Master_Warehouse__c>masterWarehouseMap = new map<Id,WU_Master_Warehouse__c>();
      
            // fetching master warehouse details
       WU_Master_Warehouse__c  masterWareHouse = getMasterWareHouseDetails();
        WU_Master_Warehouse__c  masterWareHouse1 = getMasterWareHouseDetailsApproved();
       masterWareHouseList.add(masterWareHouse);
         masterWareHouseList.add(masterWareHouse1);
        
       system.debug('masterWareHouse-->'+masterWareHouse);
       system.debug('masterWareHouse1-->'+masterWareHouse1);
       system.debug('masterWareHouseList 111 -->'+masterWareHouseList);
            insert masterWareHouseList; 
            for(WU_Master_Warehouse__c wmw:masterWareHouseList){
            wmw.WU_WarehousePOC_Email__c='tserst123@xze.com';
            }
        
           update masterWareHouseList;
           WU_SetWarehousePOCHandler.sendEmailSecPOC(masterWareHouseList);
           WU_SetWarehousePOCHandler.sendRejectionEmailSecPOC(masterWareHouseList);
           WU_SetWarehousePOCHandler.sendApprovalEmailSecPOC(masterWareHouseList);
               
               
           //masterWarehouseMap.put(masterWareHouse.Id,masterWareHouse);
           //WU_SetWarehousePOCHandler.onBeforeInsert(masterWareHouseList,masterWarehouseMap);
           
       system.debug('masterWareHouseList-->'+masterWareHouseList);
        
        
    
           }  
    }
        
        
      private static WU_Master_Warehouse__c getMasterWareHouseDetails(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
          User u = new User(Alias = 'oneuser', Email='standarduser1@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='test1@dummy1.com');
          insert u;
   WU_Master_Warehouse__c masterWarehouseItem = new WU_Master_Warehouse__c (WU_SAPCode_s__c='test12',
   WU_Procurement_Manager__c=u.Id,
   WU_WarehouseManager_Email__c='test@xyza.com',
   WU_WarehousePOC_Email__c='tserst1231@xze.com',
   WU_Committed_Max_PalletStorage__c= 1000.0,
   WU_Current_Utilization__c = 100,
    //WU_Active_WH__c='Yes',                                                                        
   WU_Previous_Month__c=9.0,
   WU_Approval_Status__c='Rejected',                                                                     
    WU_Current_Pallet_Utilization__c= 10.0,
    WU_ToDate__c= System.Today(),
    WU_FromDate__c=System.Today(),
    WU_Utilization_Type__c='Daily',
    Submitted_by__c='Prateek',                                                                                                                                                                                                                                                                                                                                                  
    WU_Warehouse_Secondary_POC_Email__c='Test@cxyz.com',
     WU_Prior_CommittedPalletStorage__c= 90.0,
      WU_LocationName__c='Udaipur',WU_Network__c='Cross-Category');                                                                    
                                                                           
   return masterWarehouseItem ;
}
     private static WU_Master_Warehouse__c getMasterWareHouseDetailsApproved(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
          User u = new User(Alias = 'twouser', Email='standarduser2@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='test2@dummy1.com');
          insert u;
   WU_Master_Warehouse__c masterWarehouseItem = new WU_Master_Warehouse__c (WU_SAPCode_s__c='test',
   WU_Procurement_Manager__c= u.Id,
   WU_WarehouseManager_Email__c='test@xyza.com',
   WU_WarehousePOC_Email__c='tserst1231@xze.com',
   WU_Committed_Max_PalletStorage__c= 100.0,
   WU_Current_Utilization__c = 10,
    //WU_Active_WH__c='Yes',                                                                        
   WU_Previous_Month__c=9.0,
   WU_Approval_Status__c='Approved',                                                                     
    WU_Current_Pallet_Utilization__c= 10.0,
    WU_ToDate__c= System.Today(),
    WU_FromDate__c=System.Today(),
    WU_Utilization_Type__c='Daily',
    Submitted_by__c='Prateek',                                                                                                                                                                                                                                                                                                                                                  
    WU_Warehouse_Secondary_POC_Email__c='Test@cxyz.com',
     WU_Prior_CommittedPalletStorage__c= 90.0,
      WU_LocationName__c='Udaipur',WU_Country__c='Turkey',WU_CityName__c='Kocaeli');                                                                    
                                                                           
   return masterWarehouseItem ;
    

   
        
}
    
}