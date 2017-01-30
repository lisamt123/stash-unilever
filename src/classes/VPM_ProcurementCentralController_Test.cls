@isTest 
public class VPM_ProcurementCentralController_Test {
    /*Constant Values*/
    public static final string  VPM_COUNTRYNAME='Algeria';
    public static final string VPM_NOACCESS = System.Label.VPM_Profile;
    public static final string STR_CONST_USER = 'standt';
    public static final string STR_CONST_EMAIL = 'standarduser24571@testorg.com';
    public static final string STR_CONST_EMAILNAME = 'testpermissionsetuser3552@testorg.com';
    public static final string STR_CONST_USERS = 'standt1';
     public static final string STR_CONST_USERS2 = 'standt2';
    public static final string STR_CONST_EMAILS =  'standarduser12@testorg1.com';
        public static final string STR_CONST_EMAILS2 =  'standarduser234@testorg2.com';
    public static final string STR_CONST_EMAILNAMES = 'testpermissionsetuser1345@testorg1.com';
      public static final string STR_CONST_EMAILNAMES2 = 'testpermissionsetuser2456@testorg2.com';


    static testMethod void TestApproverReplace(){
        Test.startTest();
        
        User Approver1 = VPM_TestDataFactory.CreateUser(STR_CONST_USER ,STR_CONST_EMAIL,STR_CONST_EMAILNAME ,VPM_NOACCESS );
        insert Approver1;

         User Approver2 = VPM_TestDataFactory.CreateUser(STR_CONST_USERS , STR_CONST_EMAILS ,STR_CONST_EMAILNAMES ,VPM_NOACCESS );
        insert Approver2;
                       
        VPM_CommodityApprover__c com = VPM_TestDataFactory.CreateCommodityApprover(Approver1.id, Approver2.id,VPM_COUNTRYNAME);
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
    
    
    static testMethod void testTempaoryReplaceApproverNull(){
        Test.startTest();
        
        User Approver1 = VPM_TestDataFactory.CreateUser(STR_CONST_USER ,STR_CONST_EMAIL ,STR_CONST_EMAILNAME ,VPM_NOACCESS );
        insert Approver1;
        
        User Approver3 = VPM_TestDataFactory.CreateUser(STR_CONST_USERS2,STR_CONST_EMAILS2 , STR_CONST_EMAILNAMES2 ,VPM_NOACCESS );
        insert Approver3;

         User Approver2 = VPM_TestDataFactory.CreateUser(STR_CONST_USERS,STR_CONST_EMAILS , STR_CONST_EMAILNAMES ,VPM_NOACCESS );
        insert Approver2;
                       
        VPM_CommodityApprover__c com = VPM_TestDataFactory.CreateCommodityApprover(Approver1.id, Approver3.id, VPM_COUNTRYNAME);
        insert com;
        com =[select VPM_Approver1__c,VPM_TempApproverDate1__c,VPM_Approver2__c,VPM_CommodityClass__c,VPM_Country__c, id, VPM_ConfiguredApprovers__c from VPM_CommodityApprover__c where id=: com.id];
        
        System.runAs(Approver1){
        VPM_ProcurementCentralController controller = new VPM_ProcurementCentralController();
        controller.MDMVendor  ='Temporary';
        com.VPM_TempApproverDate1__c =null;
        controller.com  =com;
        controller.oldUser=com.VPM_Approver1__c;
        controller.newUser=com.VPM_Approver2__c;
        system.assertEquals(controller.oldUser,com.VPM_Approver1__c);
        system.assertEquals(controller.newUser,com.VPM_Approver2__c);
        controller.Go();
        controller.ChangeApprover();
            
             com.VPM_TempApproverDate1__c =Date.today().addDays(-1);
            controller.com  =com;
        controller.oldUser=com.VPM_Approver1__c;
        controller.newUser=com.VPM_Approver2__c;
 
        controller.Go();
        controller.ChangeApprover();
        
                com.VPM_TempApproverDate1__c =Date.Today();
            controller.com  =com;
        controller.oldUser=null;
        controller.newUser=null;

        controller.Go();
        controller.ChangeApprover();
        controller.GoBack();
            
        }

        test.stopTest();    
    }
    
    static testMethod void testTempaoryReplaceApprover(){
        Test.startTest();
        
        User Approver1 = VPM_TestDataFactory.CreateUser(STR_CONST_USER ,STR_CONST_EMAIL ,STR_CONST_EMAILNAME ,VPM_NOACCESS );
        insert Approver1;
        
        User Approver3 = VPM_TestDataFactory.CreateUser(STR_CONST_USERS2,STR_CONST_EMAILS2 , STR_CONST_EMAILNAMES2 ,VPM_NOACCESS );
        insert Approver3;

         User Approver2 = VPM_TestDataFactory.CreateUser(STR_CONST_USERS,STR_CONST_EMAILS , STR_CONST_EMAILNAMES ,VPM_NOACCESS );
        insert Approver2;
                       
        VPM_CommodityApprover__c com = VPM_TestDataFactory.CreateCommodityApprover(Approver1.id, Approver3.id, VPM_COUNTRYNAME);
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
    
        static testMethod void testAssignNewAppoverNull(){
        Test.startTest();
        
        User Approver1 = VPM_TestDataFactory.CreateUser(STR_CONST_USER ,STR_CONST_EMAIL ,STR_CONST_EMAILNAME ,VPM_NOACCESS );
        insert Approver1;

         User Approver2 = VPM_TestDataFactory.CreateUser(STR_CONST_USERS,STR_CONST_EMAILS ,STR_CONST_EMAILNAMES ,VPM_NOACCESS );
        insert Approver2;
        
        myGroup(Approver2.Id);
                       
        VPM_CommodityApprover__c com = VPM_TestDataFactory.CreateCommodityApprover(Approver1.id, Approver2.id,VPM_COUNTRYNAME);
        insert com;
        com =[select VPM_Approver1__c,VPM_TempApproverDate1__c,VPM_Approver2__c,VPM_CommodityClass__c,VPM_Country__c, id, VPM_ConfiguredApprovers__c from VPM_CommodityApprover__c where id=: com.id];
        
        System.runAs(Approver2){
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
        //controller.ChangeApprover(); 
        controller.goAssign();
        controller.com.VPM_Country__c =null;
        controller.com.VPM_Approver2__c =null;
        controller.goAssign();
                    controller.com.VPM_Country__c =null;
        controller.com.VPM_Approver2__c =Approver2.id;
        controller.goAssign();
        controller.com.VPM_Country__c = VPM_COUNTRYNAME;
        controller.goAssign();
        controller.GoBack();
        system.assertEquals(comlist1.checkFlag,true);
        system.assertEquals(comlist1.setFlag,false);
            
        }

        test.stopTest();    
    }
    
    static testMethod void testAssignNewAppover(){
        Test.startTest();
        
        User Approver1 = VPM_TestDataFactory.CreateUser(STR_CONST_USER ,STR_CONST_EMAIL ,STR_CONST_EMAILNAME ,VPM_NOACCESS );
        insert Approver1;

         User Approver2 = VPM_TestDataFactory.CreateUser(STR_CONST_USERS,STR_CONST_EMAILS ,STR_CONST_EMAILNAMES ,VPM_NOACCESS );
        insert Approver2;
        
        myGroup(Approver2.Id);
                       
        VPM_CommodityApprover__c com = VPM_TestDataFactory.CreateCommodityApprover(Approver1.id, Approver2.id,VPM_COUNTRYNAME);
        insert com;
        com =[select VPM_Approver1__c,VPM_TempApproverDate1__c,VPM_Approver2__c,VPM_CommodityClass__c,VPM_Country__c, id, VPM_ConfiguredApprovers__c from VPM_CommodityApprover__c where id=: com.id];
        
        System.runAs(Approver2){
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
        //controller.ChangeApprover(); 
        controller.goAssign();
        controller.com.VPM_Country__c =null;
        controller.com.VPM_Approver2__c =Approver2.id;
        controller.goAssign();
        controller.com.VPM_Country__c = VPM_COUNTRYNAME;
        controller.goAssign();
        controller.GoBack();
        system.assertEquals(comlist1.checkFlag,true);
        system.assertEquals(comlist1.setFlag,false);
            
        }

        test.stopTest();    
    }
    
        static testMethod void TestRemoveApprover(){
               Test.startTest();
        
        User Approver1 = VPM_TestDataFactory.CreateUser(STR_CONST_USER ,STR_CONST_EMAIL ,STR_CONST_EMAILNAME,VPM_NOACCESS );
        insert Approver1;

         User Approver2 = VPM_TestDataFactory.CreateUser(STR_CONST_USERS,STR_CONST_EMAILS ,STR_CONST_EMAILNAMES ,VPM_NOACCESS );
        insert Approver2;
                       
        VPM_CommodityApprover__c com = VPM_TestDataFactory.CreateCommodityApprover(Approver1.id, Approver2.id,VPM_COUNTRYNAME);
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
        system.assertEquals(comlist2.setFlag,true);
        system.assertequals(comlist2.setFlag,true);
            
        }

        test.stopTest();    
    }
    
    static testMethod void TestRemoveApprover1(){
               Test.startTest();
        
        User Approver1 = VPM_TestDataFactory.CreateUser(STR_CONST_USER ,STR_CONST_EMAIL ,STR_CONST_EMAILNAME,VPM_NOACCESS );
        insert Approver1;

         User Approver2 = VPM_TestDataFactory.CreateUser(STR_CONST_USERS,STR_CONST_EMAILS ,STR_CONST_EMAILNAMES ,VPM_NOACCESS );
        insert Approver2;
                       
        VPM_CommodityApprover__c com = VPM_TestDataFactory.CreateCommodityApprover(Approver1.id, null,VPM_COUNTRYNAME);
        insert com;
        com =[select VPM_Approver1__c,VPM_TempApproverDate1__c,VPM_Approver2__c,VPM_CommodityClass__c,VPM_Country__c, id, VPM_ConfiguredApprovers__c from VPM_CommodityApprover__c where id=: com.id];
        
        System.runAs(Approver2){
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
        //controller.commApprover.add(comlist2);
         
        
        controller.Go();
        controller.ChangeApprover(); 
        //controller.com.VPM_Approver2__c = null;
       // controller.goAssign();
       // controller.com.VPM_Approver1__c = Approver1.id;
        //controller.goAssign();
        controller.com.VPM_Approver2__c = Approver2.id;
        controller.goAssign();
        controller.GoBack();
        system.assertEquals(comlist2.setFlag,true);
        system.assertequals(comlist2.setFlag,true);
            
        }

        test.stopTest();    
    }
    
    
    
    
    @future
public static void myGroup(string Approver2)
{
   ///2nd DML operation
  
   Group gr= new Group();
        gr.Type = 'Queue';
        gr.Name = 'ProcurementGroup';
        gr.DeveloperName = 'VPM_ProcurementAdmin';
        insert gr;
        
        GroupMember gm = new GroupMember();
            gm.UserOrGroupId = Approver2;
            gm.GroupId = gr.Id;
            insert gm;
            system.assertEquals(gm.UserOrGroupId,Approver2);
}
}