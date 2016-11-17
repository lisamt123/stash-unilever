@isTest

public class WWP_Losstree_Copy_Component_Ctrl_test{


    Static testMethod void testExtensionmethode(){
    
    String oRString = 'Output Reliability';
    String ORName1 = 'ORName1';
    String ORSubfamily1 = 'ORSubfamily1';
    string B = 'B100';
    String O = 'ORdesc11';
         
        
        WWP_Master_Table__c wwpMaster = new WWP_Master_Table__c();
        wwpMaster.name = B;
        wwpMaster.OR_Tolerance__c = 95;
        insert wwpMaster;
       
    
        WWP_PlantCode_User_Mapping__c pcuser = new WWP_PlantCode_User_Mapping__c();
        pcuser.name='pcuser1';
        pcuser.plant_code__c = B;
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
        setting1.Loss_Description__c=O;
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
    
    
    
    WWP_Losstree_Copy_Component_Ctrl ectrl = new WWP_Losstree_Copy_Component_Ctrl();
    
    ectrl.getSelectedType ='Output Reliability';
    ectrl.fetchLossTree1();
    ectrl.resetd();
    
    Apexpages.currentPage().getParameters().put('firstParams3',O);
    ectrl.controls33();
    Apexpages.currentPage().getParameters().put('firstParams2',ORSubfamily1);
    ectrl.controls22();
    Apexpages.currentPage().getParameters().put('firstParams1',ORName1);
    ectrl.controls11();
    
    
    }
}