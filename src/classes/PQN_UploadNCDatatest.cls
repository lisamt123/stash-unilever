@isTest 
private class PQN_UploadNCDatatest {
    static testMethod void PQN_UploadNCData_M1() {
    
  
     test.starttest();
     
       PQN_UploadNCData t=new PQN_UploadNCData();
        
       t.selectedfile='unilever';
       t.mystring = '{"DataCollection" :[ { "Cluster__c" : "testd"}]}';  
       t.parseData();
       t.selectedfile='cannock';
       t.parseData();
       t.selectedfile='Heilbronn';
       t.parseData();
     
        
           
       t.savedata();
       t.showsucesstable();
       t.hidesuccesstable();
       PageReference pageRef = Page.PQN_MultiEditScreen_VF;
       Test.setCurrentPage(pageRef);
       t.export2excel();
       
    
       test.stoptest();
    
    }

}