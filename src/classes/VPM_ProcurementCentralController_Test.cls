@isTest 
public class VPM_ProcurementCentralController_Test {

    static testMethod void TestApproverReplace(){
        Test.startTest();
        
        User Approver1 = VPM_TestDataFactory.CreateUser('standt', 'standarduser@testorg.com', 'testpermissionsetuser@testorg.com', 'VPM - No Access');
        insert Approver1;

         User Approver2 = VPM_TestDataFactory.CreateUser('standt1', 'standarduser@testorg1.com', 'testpermissionsetuser@testorg1.com', 'VPM - No Access');
        insert Approver2;
                       
        VPM_CommodityApprover__c com = VPM_TestDataFactory.CreateCommodityApprover(Approver1.id, Approver2.id, 'Algeria');
        insert com;
        com =[select VPM_Approver1__c,VPM_TempApproverDate1__c,VPM_Approver2__c,VPM_CommodityClass__c,VPM_Country__c, id, VPM_ConfiguredApprovers__c from VPM_CommodityApprover__c where id=: com.id];
        
        System.runAs(Approver1){
        VPM_ProcurementCentralController controller = new VPM_ProcurementCentralController();
        controller.MDMVendor  ='Replace';
        com.VPM_TempApproverDate1__c =Date.Today();
        controller.com  =com;
        // replacing Approver1 with Approver2
        controller.Go();
        controller.ChangeApprover();
        // Approver2 =null means Removing Approver1 from commodity Approver
        controller.com.VPM_Approver2__c =null;
        controller.ChangeApprover();
        controller.GoBack();
        system.assertEquals(controller.com.VPM_Approver2__c,null);  
        }

        test.stopTest();    
    }
    
    static testMethod void testTempaoryReplaceApprover(){
        Test.startTest();
        
        User Approver1 = VPM_TestDataFactory.CreateUser('standt', 'standarduser@testorg.com', 'testpermissionsetuser@testorg.com', 'VPM - No Access');
        insert Approver1;

         User Approver2 = VPM_TestDataFactory.CreateUser('standt1', 'standarduser@testorg1.com', 'testpermissionsetuser@testorg1.com', 'VPM - No Access');
        insert Approver2;
                       
        VPM_CommodityApprover__c com = VPM_TestDataFactory.CreateCommodityApprover(Approver1.id, Approver2.id, 'Algeria');
        insert com;
        com =[select VPM_Approver1__c,VPM_TempApproverDate1__c,VPM_Approver2__c,VPM_CommodityClass__c,VPM_Country__c, id, VPM_ConfiguredApprovers__c from VPM_CommodityApprover__c where id=: com.id];
        
        System.runAs(Approver1){
        VPM_ProcurementCentralController controller = new VPM_ProcurementCentralController();
        controller.MDMVendor  ='Temporary';
        com.VPM_TempApproverDate1__c =Date.Today();
        controller.com  =com;
        controller.oldUser=com.VPM_Approver1__c;
        controller.newUser=com.VPM_Approver2__c;
        system.assertEquals(controller.oldUser,com.VPM_Approver1__c);
        system.assertEquals(controller.newUser,com.VPM_Approver2__c);
        controller.Go();
        controller.ChangeApprover(); 
        
        controller.GoBack();
            
        }

        test.stopTest();    
    }
    
    static testMethod void testAssignNewAppover(){
        Test.startTest();
        
        User Approver1 = VPM_TestDataFactory.CreateUser('standt', 'standarduser@testorg.com', 'testpermissionsetuser@testorg.com', 'VPM - No Access');
        insert Approver1;

         User Approver2 = VPM_TestDataFactory.CreateUser('standt1', 'standarduser@testorg1.com', 'testpermissionsetuser@testorg1.com', 'VPM - No Access');
        insert Approver2;
                       
        VPM_CommodityApprover__c com = VPM_TestDataFactory.CreateCommodityApprover(Approver1.id, Approver2.id, 'Algeria');
        insert com;
        com =[select VPM_Approver1__c,VPM_TempApproverDate1__c,VPM_Approver2__c,VPM_CommodityClass__c,VPM_Country__c, id, VPM_ConfiguredApprovers__c from VPM_CommodityApprover__c where id=: com.id];
        
        System.runAs(Approver1){
        VPM_ProcurementCentralController controller = new VPM_ProcurementCentralController();
        controller.MDMVendor  ='Assign';
        com.VPM_TempApproverDate1__c =Date.Today();
        controller.com  =com;
            
        VPM_ProcurementCentralController.CommApproverList  comlist1 = new VPM_ProcurementCentralController.CommApproverList();
        VPM_ProcurementCentralController.CommApproverList  comlist2 = new VPM_ProcurementCentralController.CommApproverList();
        comlist1.checkFlag =true;
        comlist1.setFlag =false;
        comlist1.comApp =com;
        controller.commApprover  = new List<VPM_ProcurementCentralController.CommApproverList>();
        controller.commApprover.add(comlist1);
         comlist2.checkFlag =true;
        comlist2.setFlag =true;
         comlist2.comApp =com;
        controller.commApprover.add(comlist2);
        
        controller.Go();
        controller.ChangeApprover(); 
        controller.goAssign();
        controller.com.VPM_Country__c =null;
        controller.com.VPM_Approver2__c =Approver2.id;
        controller.goAssign();
        controller.com.VPM_Country__c = 'Algeria';
        controller.goAssign();
        controller.GoBack();
            
        }

        test.stopTest();    
    }
    
        static testMethod void TestRemoveApprover(){
               Test.startTest();
        
        User Approver1 = VPM_TestDataFactory.CreateUser('standt', 'standarduser@testorg.com', 'testpermissionsetuser@testorg.com', 'VPM - No Access');
        insert Approver1;

         User Approver2 = VPM_TestDataFactory.CreateUser('standt1', 'standarduser@testorg1.com', 'testpermissionsetuser@testorg1.com', 'VPM - No Access');
        insert Approver2;
                       
        VPM_CommodityApprover__c com = VPM_TestDataFactory.CreateCommodityApprover(Approver1.id, Approver2.id, 'Algeria');
        insert com;
        com =[select VPM_Approver1__c,VPM_TempApproverDate1__c,VPM_Approver2__c,VPM_CommodityClass__c,VPM_Country__c, id, VPM_ConfiguredApprovers__c from VPM_CommodityApprover__c where id=: com.id];
        
        System.runAs(Approver1){
        VPM_ProcurementCentralController controller = new VPM_ProcurementCentralController();
        controller.MDMVendor  ='Remove';
        com.VPM_TempApproverDate1__c =Date.Today();
        controller.com  =com;
            
        VPM_ProcurementCentralController.CommApproverList  comlist1 = new VPM_ProcurementCentralController.CommApproverList();
        VPM_ProcurementCentralController.CommApproverList  comlist2 = new VPM_ProcurementCentralController.CommApproverList();
        comlist1.checkFlag =true;
        comlist1.setFlag =false;
        comlist1.comApp =com;
        controller.commApprover  = new List<VPM_ProcurementCentralController.CommApproverList>();
        controller.commApprover.add(comlist1);
         comlist2.checkFlag =true;
        comlist2.setFlag =true;
         comlist2.comApp =com;
        //controller.commApprover.add(comlist2);
         
        
        controller.Go();
        controller.ChangeApprover(); 
        controller.com.VPM_Approver1__c = null;
        controller.goAssign();
        controller.com.VPM_Approver1__c = Approver1.id;
        controller.goAssign();
            controller.com.VPM_Approver2__c = Approver2.id;
        controller.goAssign();
        controller.GoBack();
            
        }

        test.stopTest();    
    }
}