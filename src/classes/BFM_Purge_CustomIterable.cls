global class BFM_Purge_CustomIterable implements Iterator<SObject>{ 
   
   List<SObject> sobjs {get; set;} 
   Integer i {get; set;} 
   public BFM_Purge_CustomIterable(){ 
       sobjs = new List<SObject>();
       string selectedobject ='';
       Map<string,BFM_Purge_Objects__c> mapOjects = new Map<string,BFM_Purge_Objects__c>();       
       mapOjects = BFM_Purge_Objects__c.getAll();      
       for(string obj:mapOjects.keyset()){
           selectedobject = obj;
           integer noofdays=integer.valueof(label.BFM_Purge_days);
           string cQuery = 'select id from '+selectedObject+' where createddate <= LAST_N_DAYS:'+noofdays;
           sobjs.addall(database.query(cQuery));          
      }
      
      /* List<Account> accs = [SELECT id, name, numberofEmployees FROM Account WHERE name !=: NULL ]; 
       for( Account acc : accs ) {
           sobjs.add(acc);
       }
       
       List<Contact> cons = [SELECT id, name FROM Contact WHERE lastname !=: Null ]; 
       for( Contact con : cons ) {
           sobjs.add(con);
       }*/
       i = 0; 
   }   
   global boolean hasNext(){ 
       
       if(i >= sobjs.size()) 
           return false; 
       else 
           return true; 
   }    
   global SObject next(){ 
       if(i == 8){ i++; return null;} 
       i=i+1; 
       return sobjs[i-1]; 
   } 
}