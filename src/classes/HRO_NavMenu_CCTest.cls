/**********************************************************************
 Name:  HRO_NavMenu_CCTest()
 Copyright © 2015  Salesforce
 ======================================================
======================================================
Purpose:                                                            
Test Class for HRO_NavMenu_CC  class                                                       
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL            Description
   1.0    Karol Szepietowski        08/10/2015      INITIAL DEVELOPMENT          CSR: 
***********************************************************************/
@isTest
private class HRO_NavMenu_CCTest {
    
    private static final String HRADMIN = 'HRO_HRAdmin';
    private static final String HRMANAGER = 'HRO_HeadstartManager';
     
	/*******************************************************************
   Purpose:  Testing gerIsHROAdmin property                                                
   Parameters: []
   Returns: []
   Throws [Exceptions]: []                                                          
  ********************************************************************/
	@isTest static void testIsHroAdmin() {
        User hroAdmin = HRO_UnitTestFactory.createUserManager('HROtestManager');
		
        Id hroAdminId = [Select id From PermissionSet Where name =: HRADMIN Limit 1].get(0).Id;
        PermissionSetAssignment permSet = new PermissionSetAssignment(PermissionSetId = hroAdminId, AssigneeId =hroAdmin.id);
        List<PermissionSetAssignment> perSetLst = [Select id from PermissionSetAssignment where PermissionSetId =: hroAdminId and AssigneeId =: hroAdmin.id];
        if(perSetLst.isEmpty()){
        	insert permSet;    
        }
        Test.startTest();
        System.runAs(hroAdmin){
            HRO_NavMenu_CC componentCtrl = new HRO_NavMenu_CC();
        	system.assertEquals(true, componentCtrl.getIsHROAdmin(),'User should have assinged HRO Admin Permission set');
        }
        //delete permission set
        if(!perSetLst.isEmpty()){
            delete perSetLst;
        }else{
            delete permSet;
        }
        
        System.runAs(hroAdmin){
            HRO_NavMenu_CC componentCtrl1 = new HRO_NavMenu_CC();
        	system.assertEquals(false, componentCtrl1.getIsHROAdmin(),'User should not have assinged HRO Admin Permission set');
        }
        
        Test.stopTest();
    }
    
    /*******************************************************************
   Purpose:  Testing gerIsHRManager property                                                
   Parameters: []
   Returns: []
   Throws [Exceptions]: []                                                          
  ********************************************************************/
	@isTest static void testIsHrManager() {
        User hroManager = HRO_UnitTestFactory.createUserManager('HROtestManager');
        Id hroManagerId = [Select id From PermissionSet Where name =: HRMANAGER Limit 1].get(0).Id;
        PermissionSetAssignment permSet = new PermissionSetAssignment(PermissionSetId = hroManagerId, AssigneeId =hroManager.id);
        List<PermissionSetAssignment> perSetLst = [Select id from PermissionSetAssignment where PermissionSetId =: hroManagerId and AssigneeId =: hroManager.id];
        if(perSetLst.isEmpty()){
        	insert permSet;    
        }
        Test.startTest();
        System.runAs(hroManager){
            HRO_NavMenu_CC componentCtrl = new HRO_NavMenu_CC();
        	system.assertEquals(true, componentCtrl.getIsManager(),'User should have assinged HRO Manager Permission set');
        }
        
        if(!perSetLst.isEmpty()){
            delete perSetLst;
        }else{
            delete permSet;
        }
        
        System.runAs(hroManager){
            HRO_NavMenu_CC componentCtrl1 = new HRO_NavMenu_CC();
        	system.assertEquals(false, componentCtrl1.getIsManager(),'User should not have assinged HRO Manager Permission set');
        }
        
        Test.stopTest();
    }

}