/*************************************************************
*@Author :          Cognizant
*@Date :            December 2015
*@Description :     Handler class for WU_SetWarehousePOCHandler_Test
*************************************************************/

public class WU_TestFactory_Helper{
    /**CONSTANTS **/
    public static String WAREHOUSE_POC = 'WU-Warehouse Excellence Operations';  //'';
    public static final string EMPTY_STRING = '';
    
     //User specific literals
     public static final String USER_LOCALEKEY = 'en_US';
     public static final String USER_WU_ROLE = 'WU-Warehouse Excellence Operations';
     public static final String USER_EMAIL_ENCODE = 'UTF-8';
     public static final String USER_TIMEZONEKEY = 'Europe/London';
     
     
    /** VARIABLES **/
    public static List<WU_Master_Warehouse__c> warehouseList = new List<WU_Master_Warehouse__c>();
    //public static Profile PAdmin = [SELECT Id FROM Profile WHERE Name='System Administrator']; //retrieve the profile of the user
    public static Profile PWarehousePOC= [SELECT Id FROM Profile WHERE Name='Unilever - Force MultiApp Standard']; //retrieve the profile of the warehouse POC user
    //public static Profile PWarehouseLLT= [SELECT Id FROM Profile WHERE Name='WU-Logistics Leadership Team']; //retrieve the profile of the warehouse POC user       
    public static PermissionSet perms = [SELECT Id,Name from PermissionSet WHERE Name = 'WU_Warehouse_Excellence_Operations'];
    public static String uniqueUserEmail  = WU_TestFactory_Helper.getUniqueUsername();
    public static User ur=WU_TestFactory_Helper.createWarehouseProfileUser();
    
    //public static PermissionSetAssignment permsAssign = WU_TestFactory_Helper.assignPermSet();
    

    private WU_TestFactory_Helper(){}
    
    public static List<WU_Master_Warehouse__c> insertWUWarehouseList(Integer numberOfRecords){ 
    
        //WMS_Settings__c WsConfig=WU_TestFactory_Helper.createCustomSettingValues();
        //system.assert(WsConfig!=null);
        //uniqueUserEmail  =    getUniqueUsername();     
        system.assert(ur!=null);
        for(integer i=0;i<numberOfRecords;i++){
                       
            WU_Master_Warehouse__c w=new WU_Master_Warehouse__c(
            WU_WarehousePOC_Email__c=uniqueUserEmail,            
            WU_Current_Utilization__c = 100,
            WU_Committed_Max_PalletStorage__c= 1000,
            WU_Utilization_Type__c = 'Daily',
            WU_FromDate__c = Date.Today(),
            WU_ToDate__c = Date.Today(), 
            WU_Network__c='Cross-Category',
            WU_Region__c='AAR',
            WU_MCO__c='NAMETRUB',
            WU_Country__c='Turkey',
            WU_CityName__c='Kocaeli',
            WU_SAPCode_s__c=String.valueof(1+i),
            OwnerId =ur.Id
            );
            warehouseList.add(w);
        }
        if(!warehouseList.isEmpty()){
            insert warehouseList;
                
                                   
            List<WU_Master_Warehouse__c> lstWRHSCU = new List<WU_Master_Warehouse__c>();
            lstWRHSCU = [Select Id, WU_Current_Utilization__c, WU_WarehousePOC_Email__c, WU_Committed_Max_PalletStorage__c,
                         WU_Network__c,WU_Region__c, WU_MCO__c, WU_Country__c, WU_CityName__c, WU_SAPCode_s__c,WU_FromDate__c,WU_ToDate__c              
                         from WU_Master_Warehouse__c 
                         where Id in:warehouseList];            
            

            lstWRHSCU[0].WU_Current_Utilization__c=50;
            lstWRHSCU[0].WU_FromDate__c = Date.Today() +1;
            lstWRHSCU[0].WU_ToDate__c = Date.Today() +1;
            
            update lstWRHSCU;
            
            lstWRHSCU[1].WU_Current_Utilization__c=50;
            
			try
			{
				database.update(lstWRHSCU,false);
			}
			
			catch(exception e)
			{
				Boolean expectedExceptionThrown =  e.getMessage().contains(Label.WU_DuplicateCapacityDetailWhileInsert) ? true : false;
				System.AssertEquals(expectedExceptionThrown, true);
			}
            
                        

            //update
            /*****warehouseList[0].WU_WarehousePOC_Email__c=getUniqueUsername();
            warehouseList[0].WU_Committed_Max_PalletStorage__c=1100;
            warehouseList[0].WU_Current_Utilization__c=50;
            warehouseList[0].WU_Network__c='Cross-Category';
            warehouseList[0].WU_Region__c='AAR';
            warehouseList[0].WU_MCO__c='NAMETRUB';
            warehouseList[0].WU_Country__c='Turkey';
            warehouseList[0].WU_CityName__c='Kocaeli';
            warehouseList[0].WU_SAPCode_s__c='9999999';*****/
            //warehouseList[0].WU_WarehouseManager_Email__c=WU_SetWarehousePOCHandler.getManagerEmail(ur);
             
            /*****warehouseList[1].WU_Current_Utilization__c=90;
            warehouseList[1].WU_Region__c='Europe';
            warehouseList[1].WU_WarehousePOC_Email__c=getUniqueUsername();*****/
            
            /****update warehouseList;***/            
                   
        }
        
        // ensure the record submitted for approval
        //List<ProcessInstance> processInstances = [select Id, Status from ProcessInstance where TargetObjectId =:warehouseList[0].id];
        //System.assert(processInstances.size()!=0);
        
        //VF Page 
        ApexPages.StandardController sc = new ApexPages.StandardController(warehouseList[0]);
        WU_WarehouseSearchController testWcController = new WU_WarehouseSearchController(sc);
        PageReference pageRef = Page.WU_WarehouseSearchPage;
        pageRef.getParameters().put('Id', String.valueOf(warehouseList[0].Id));
        Test.setCurrentPage(pageRef);
        testWcController.getExistingViews();
        testWcController.lstWarehouses = new ApexPages.StandardSetController(testWcController.AllSearchRecords);
        //testWcController.AllSearchRecords;
        
        testWcController.warehouseCapacity=warehouseList[0];
        testWcController.AllSearchRecords=warehouseList; 
        testWcController.SearchRecords();
        testWcController.previous();
        testWcController.hasPrevious=true;
        testWcController.next();
        testWcController.hasNext=true;
        testWcController.pageNumber  =1;
        return warehouseList;
    }
        
    
    public static User createWarehouseProfileUser() {
        //string uniqueUserEMailId = getUniqueUsername();
        string uniqueUserEMailId= uniqueUserEmail;
        User uMgr = new User();
        uMgr.Alias = uniqueUserEMailId.substring(18,23);
        uMgr.Email= uniqueUserEMailId; 
        uMgr.EmailEncodingKey=USER_EMAIL_ENCODE; 
        uMgr.LastName='WAREHOUSE_USER'; 
        uMgr.LanguageLocaleKey=USER_LOCALEKEY;
        uMgr.LocaleSidKey='en_US';
        uMgr.ProfileId = PWarehousePOC.Id; 
        //u.UserRoleId= RWarehouse.Id;
        uMgr.TimeZoneSidKey=USER_TIMEZONEKEY;
        uMgr.UserName=uniqueUserEMailId+'MGR';
        uMgr.isActive =true;
        insert uMgr;
        User u = new User();
        u.Alias = uniqueUserEMailId.substring(18,23);
        u.Email= uniqueUserEMailId; 
        u.EmailEncodingKey=USER_EMAIL_ENCODE; 
        u.LastName='WAREHOUSE_USER'; 
        u.LanguageLocaleKey=USER_LOCALEKEY;
        u.LocaleSidKey='en_US';
        u.ProfileId = PWarehousePOC.Id; 
        //u.UserRoleId= RWarehouse.Id;
        u.TimeZoneSidKey=USER_TIMEZONEKEY;
        u.UserName=uniqueUserEMailId;
        u.ManagerId=uMgr.Id;
        u.isActive =true;
        insert u;
        
        return u;
    }
    
     public static String getUniqueUsername() {
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ',EMPTY_STRING).replace(':',EMPTY_STRING).replace('-',EMPTY_STRING);
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        
        return (uniqueName + '@warehouse' + orgId + '.org');
    }
    
        
    
    public static WMS_Settings__c createCustomSettingValues(){
        WMS_Settings__c cs=new WMS_Settings__c();
        cs.Name='WarehousePOC Profile';
        cs.Warehouse_Profiles__c='Unilever - Force MultiApp Standard';
        cs.Warehouse_ManagerProfiles__c='Unilever - Force MultiApp Standard';
        insert cs;
        return cs;
    }
    
    public Static void assignPermSet()
    {
    	PermissionSetAssignment psa = new PermissionSetAssignment();
    	psa.AssigneeId = ur.Id;
    	if(perms!=null)
    	{
    		psa.PermissionSetId = perms.Id;
	    	insert psa;
    	}
	    
	    //return psa;
    }
}