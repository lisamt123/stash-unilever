@isTest
public class WWP_LossTree_Test {
    
    Static testMethod void testlosstree1(){
    String oRString = 'Output Reliability';
    String ORName1 = 'ORName1';
    String ORSubfamily1 = 'ORSubfamily1';
    
        //custom setting 
        list<WWP_Master_Table__c> wwpMasterList = new list<WWP_Master_Table__c>();
        WWP_Master_Table__c wwpMaster = new WWP_Master_Table__c();
        wwpMaster.name = 'B100';
        wwpMaster.OR_Tolerance__c = 95;
        insert wwpMaster;
       // wwpMasterList.add(wwpMaster);
        //insert wwpMasterList;
    
        WWP_PlantCode_User_Mapping__c pcuser = new WWP_PlantCode_User_Mapping__c();
        pcuser.name='pcuser1';
        pcuser.plant_code__c = 'B100';
        pcuser.user__c = userinfo.getuseremail();
        insert pcuser;
        
        
        List<WWP_LossTree__c> ltreesetting = new List<WWP_LossTree__c>();
        WWP_LossTree__c setting1 = new WWP_LossTree__c();
        WWP_LossTree__c setting2 = new WWP_LossTree__c();
        WWP_LossTree__c setting3 = new WWP_LossTree__c();
        WWP_LossTree__c setting4 = new WWP_LossTree__c();
        setting1.name='OR1';
        setting1.Loss_Type__c=oRString ;
        setting1.Loss_Name__c=ORName1;
        setting1.Loss_Sub_Family__c=ORSubfamily1;
        setting1.Loss_Description__c='ORdesc11';
        ltreesetting.add(setting1);
        
        setting2.name='OR2';
        setting2.Loss_Type__c=oRString ;
        setting2.Loss_Name__c=ORName1;
        setting2.Loss_Sub_Family__c=ORSubfamily1;
        setting2.Loss_Description__c='ORdesc12';
        ltreesetting.add(setting2);
        
        setting3.name='OR3';
        setting3.Loss_Type__c=oRString ;
        setting3.Loss_Name__c=ORName1;
        setting3.Loss_Sub_Family__c=ORSubfamily1;
        setting3.Loss_Description__c='ORdesc21';
        ltreesetting.add(setting3);
        
        setting4.name='OR4';
        setting4.Loss_Type__c=oRString ;
        setting4.Loss_Name__c='ORName2';
        setting4.Loss_Sub_Family__c='ORSubfamily21';
        setting4.Loss_Description__c='ORdesc212';
        ltreesetting.add(setting4);
        
        insert ltreesetting;
                
        WWP_Loss_Tree__c ltree = new WWP_Loss_Tree__c();
        ltree.Loss_Updated_in_SCDG__c = false;
        ltree.Loss_Type__c= oRString ;
        ltree.Plant_Code__c= 'B100';
        ltree.Week__c = '201512';
        ltree.Loss_Name__c=ORName1;
        ltree.Loss_Sub_Family__c=ORSubfamily1;
        ltree.Loss_Description__c='ORdesc11';
        ltree.Planned_production__c = 234;
        insert ltree;
        
        Test.startTest();
        WWP_LossTree_CC wwp = new WWP_LossTree_CC();
        //wwp.lossTree = ltree;
        wwp.lossTree.Loss_Type__c = oRString ;
        wwp.lossTree.Plant_Code__c= 'B100';
        wwp.selectedWeek= '201512';
        wwp.dispalyAll = true;
        
        
        
        
        
        
        wwp.fetchLossTree();
        //system.assert(wwp.mapbox12.size()>0);
        system.assertEquals(wwp.listLossTree.size(),1);
        
        Apexpages.currentPage().getParameters().put('firstParam','0');
        Apexpages.currentPage().getParameters().put('secondParam',ORName1);
        wwp.control1213();
        system.assertEquals(wwp.listLossTreeW[0].listbox1[0].getvalue(),ORName1);
        
        Apexpages.currentPage().getParameters().put('firstParam2','0');
        Apexpages.currentPage().getParameters().put('secondParam2',ORSubfamily1);
        wwp.control2123();
        system.assertEquals(wwp.listLossTreeW[0].listbox2[0].getvalue(),ORSubfamily1);
        
        Apexpages.currentPage().getParameters().put('firstParam3','0');
        Apexpages.currentPage().getParameters().put('secondParam3','ORdesc11');
        wwp.control3132();
        system.assertEquals(wwp.listLossTreeW[0].listbox3[0].getvalue(),'ORdesc11');
        
        wwp.listLossTreeW[0].selectbox2=ORSubfamily1;
        wwp.control1213(); 
                
        wwp.listLossTreeW[0].selectbox2='None';
        wwp.control1213();
        
        
        
        Apexpages.currentPage().getParameters().put('mrpfirstParam','0');
        Apexpages.currentPage().getParameters().put('mrpsecondParam','ORName2');
        wwp.controlMRP12();
        
        Apexpages.currentPage().getParameters().put('mrpfirstParam2','0');
        Apexpages.currentPage().getParameters().put('mrpsecondParam2','ORSubfamily21');
        wwp.controlMRP21();
        
        Apexpages.currentPage().getParameters().put('resetite','0');
        wwp.resetline();
        
        wwp.control2123();
        
        wwp.updateLossTree();
        wwp.listLossTreeW[0].selectbox1='OR1';
        wwp.listLossTreeW[0].selectbox2='OR2';
        wwp.listLossTreeW[0].selectbox3='OR3';
        wwp.listLossTreeW[0].checkbox1=true;
        wwp.updateLossTree();
        
        wwp.lossTree.Loss_Type__c = 'testors';
        wwp.fetchLossTree();
        
        wwp.lossTree.Loss_Type__c = null;
        wwp.fetchLossTree();
        
        Test.stopTest();
    }
}