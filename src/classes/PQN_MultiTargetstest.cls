@isTest 
private class  PQN_MultiTargetstest {
    static testMethod void testPQN_MultiTargets_M1() {
    
     test.starttest();
    
    PQN_Targets__c t1=new PQN_Targets__c();
     t1.Target_Reduction__c=20;
     t1.Year__c = '2016';
     
    PQN_Targets__c t2=new PQN_Targets__c();
     t2.Target_Reduction__c=-20;
       
        
     PQN_MultiTargets mt1=new  PQN_MultiTargets();
     //PQN_MultiTargets.PQN_tabledata wrap1=new PQN_MultiTargets.PQN_tabledata(t1);
     
      
     mt1.mystring = '{"DataCollection" :[ { "Target_Reduction__c" : "20"}]}'; 
     mt1.parseData();
     mt1.savedata();
     mt1.clicksuccesslink();
     mt1.clickerrorlink();
     
     PQN_MultiTargets mt2=new  PQN_MultiTargets();
     mt2.sfileformat='a.xls';
     mt2.parseData();
     mt2.savedata();
     mt2.clicksuccesslink();
     mt2.clickerrorlink();
     string jstr = '{'+'/n';
      jstr = jstr+'"Sheet1": ['+'/n';
      jstr = jstr+'{'+'/n';
      jstr = jstr+'"Year__c": "2016",'+'/n';
      jstr = jstr+'"Target_Reduction__c": "124"'+'/n';
      jstr = jstr+'}'+'/n';
      jstr = jstr+']'+'/n';
     jstr = jstr+'}';
    
      
      
    
  

     PQN_MultiTargets mt3=new  PQN_MultiTargets();
     mt3.mystring = jstr;
      
     mt3.sfileformat='a.xls';
     mt3.parseData();     
     PQN_MultiTargets.PQN_tabledata wrap1=new PQN_MultiTargets.PQN_tabledata(t1);
     PQN_MultiTargets.PQN_tabledata wrap2=new PQN_MultiTargets.PQN_tabledata(t2);
     mt3.listTargetWrapper.add(wrap1);
     mt3.listTargetWrapper.add(wrap2);
     mt3.savedata();
     
     test.stoptest();
     }
     
   }