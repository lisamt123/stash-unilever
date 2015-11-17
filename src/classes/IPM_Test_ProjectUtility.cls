@isTest
public class IPM_Test_ProjectUtility{
    
    public static testmethod void m1(){
        
       RecordType projrec = [Select id from RecordType where developerName='Clustering'];
       IPM_Project__c proj = new IPM_Project__c();
       proj.recordtypeId= projrec.Id;
       proj.name='test';
       insert proj;
       
       IPM_Project__c projc = new IPM_Project__c();
       projc.recordtypeId= projrec.Id;
       projc.name='test';
       projc.IPM_Parent_Project__c = proj.Id;
       insert projc;
       
       RecordType milerec = [Select id from RecordType where developerName='IPM_Milestones'];
       IPM_Milestone__c mile1 = new IPM_Milestone__c();
       mile1.recordTypeid = milerec.Id;
       mile1.name='Test Mile 1';
       mile1.IPM_Project__c = proj.Id;
       insert mile1; 
              
       IPM_Milestone__c mile2 = new IPM_Milestone__c();
       mile2.recordTypeid = milerec.Id;
       mile2.name='Test Mile 2';
       mile2.IPM_Project__c = proj.Id;
       mile2.IPM_Phase__c='Feasibility';
       insert mile2; 
       
       IPM_Milestone__c mile3 = new IPM_Milestone__c();
       mile3.recordTypeid = milerec.Id;
       mile3.name='Test Mile 3';
       mile3.IPM_Project__c = proj.Id;
       mile3.IPM_Phase__c='Feasibility';
       insert mile3;  
       
       IPM_Milestone__c mile4 = new IPM_Milestone__c();
       mile4.recordTypeid = milerec.Id;
       mile4.name='Test Mile 4';
       mile4.IPM_Project__c = proj.Id;
       mile4.IPM_Milestone__c = mile3.Id;
       mile4.IPM_Phase__c='Feasibility';
       insert mile4;  
       
       IPM_Project__c projClone = new IPM_Project__c();
       projClone.recordtypeId= projrec.Id;
       projClone.name='test';
       projClone.IPMProject_Span__c = 'Regional';
       projClone.IPM_Parent_Project__c = proj.Id;
       projClone.IPM_Phase__c='Feasibility';
       insert projClone;
       
       projClone.IPM_Phase__c='Capability';
       update projClone;
    }
    
}