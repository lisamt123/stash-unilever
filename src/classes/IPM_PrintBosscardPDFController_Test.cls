@isTest
public class IPM_PrintBosscardPDFController_Test {
public static IPM_Project__c project;
public static IPM_Bosscard__c boss=new IPM_Bosscard__c();
static testMethod void initializeData(){
project=new IPM_Project__c();


project.Name='TestComments45';
project.IPM_Phase__c='Ideas';
project.IPM_Complexity__c='Full';
project.IPM_GateKeeping_Model__c='Both'; 
insert project;

//boss.Name='abc';
         boss.IPM_BosscardName__c='abc';
         //boss.IPM_Bosscard_Logo_Id__c=
         boss.IPM_Target_Launch_Date__c='06/06/2015';
         boss.IPM_Bosscard_Logo__c='sf';
         boss.IPM_BosscardIdea__c='dfdsf';
         //boss.IPM_Gate_Keeper__c='''
         //boss.IPM_Gate_Keeper__r.Name
         boss.IPM_Brand__c='sdf';
         boss.IPM_Assumptions__c='df';
         boss.IPM_Background__c='dfd';
         boss.IPM_Constraints__c='fdf';
         boss.IPM_Deliverables__c='fdfg';
         boss.IPM_Opportunity__c='gdfg';
         boss.IPM_Potential_Business_Opportunity__c='dfg';
         boss.IPM_Consumer_Need__c='fgfd';
         boss.IPM_Resources__c='gfd';
         boss.IPM_Brand_Positioning__c='fgfdg';
         boss.IPM_Scope__c='fgf';
         boss.IPM_Sustainibility__c='3';
          insert boss;

      

}


 
     
     static testMethod void dotest()
     {
     initializeData();
          PageReference pRef = new PageReference('/apex/IPM_PDocumentTriggerHandler?id='+boss.Id);
         Test.setCurrentPage(pRef);
         
        
         IPM_PrintBosscardPDFController ipmPD=new IPM_PrintBosscardPDFController();
        
         
     }
}