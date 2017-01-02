Public with sharing class PQNUpdateFreezePeriodCtrl{

    public List<PQNFreezeDate__c> result {get;set;}
   // Public Date currentDate = date.Today();
    //Integer monthValue = currentDate.month();
    public list<PQNFreezeDate__c> currentMonthFreezePeriod {get;set;}
     

    
    public List<PQNFreezeDate__c> getResult(){    
        return result;
        
    }


    
    Public Date January {get;set;}
    Public Date February {get;set;}
    Public Date March {get;set;}
    Public Date April {get;set;}
    Public Date May {get;set;}
    Public Date June {get;set;}
    Public Date July {get;set;}
    Public Date August {get;set;}
    Public Date September {get;set;}
    Public Date October {get;set;}
    Public Date November {get;set;}
    Public Date December {get;set;}
    Public Boolean flag {get;set;}
    
    
    Public PQNUpdateFreezePeriodCtrl (){
        currentMonthFreezePeriod = [select Id, Name, Numeric_Value__c, Freeze_Date__c from PQNFreezeDate__c where Numeric_Value__c =: Date.Today().Month() LIMIT 1];
        system.debug('The date is' + currentMonthFreezePeriod);
        system.debug('Inside the ext controller');
        Id pId = userinfo.getProfileId();
        List<Profile> pList = [select Id, Name from Profile where Id=: pId LIMIT 1];
        String pName = pList[0].Name;
        if(pName == 'system Administrator')
        flag = true;
        result = [select Id, Name, Numeric_Value__c, Freeze_Date__c from PQNFreezeDate__c ORDER BY Numeric_Value__c];
        January = result[0].Freeze_Date__c ;
        February = result[1].Freeze_Date__c ;
        March = result[2].Freeze_Date__c ;
        April = result[3].Freeze_Date__c ;
        May = result[4].Freeze_Date__c ;
        June = result[5].Freeze_Date__c ;
        July = result[6].Freeze_Date__c ;
        August = result[7].Freeze_Date__c ;
        September = result[8].Freeze_Date__c ;
        October = result[9].Freeze_Date__c ;
        November = result[10].Freeze_Date__c ;
        December = result[11].Freeze_Date__c ; 
    }
    
    Public pageReference updateFreezePeriod(){
    try{
            //get the List of PQNFreezeDate__c and store in the list            
            
        result[0].Freeze_Date__c = January;
        result[1].Freeze_Date__c = February;
        result[2].Freeze_Date__c = March;
        result[3].Freeze_Date__c = April;
        result[4].Freeze_Date__c = May;
        result[5].Freeze_Date__c = June;
        result[6].Freeze_Date__c = July;
        result[7].Freeze_Date__c = August;
        result[8].Freeze_Date__c = September;
        result[9].Freeze_Date__c = October;
        result[10].Freeze_Date__c = November;
        result[11].Freeze_Date__c = December;
            
            update result;
            system.debug('The list is' + result);

            
            //Compare the 'Name' of the custom setting record and update the date value
            /*
            
            Integer i = 0;
            While ( i < result.size()){
                if(result[i].Name == 'January'){
                    result[i].Freeze_Date__c  = January;
                    system.debug('The value is' + result[i].Freeze_Date__c);
                }
                else if(result[i].Name == 'February'){
                    result[i].Freeze_Date__c = February;
                    system.debug('The value is' + result[i].Freeze_Date__c);
                }
                else if(result[i].Name == 'March'){
                    result[i].Freeze_Date__c = March;
                    system.debug('The value is' + result[i].Freeze_Date__c);
                }
                else if(result[i].Name == 'April'){
                    result[i].Freeze_Date__c = April;
                    system.debug('The value is' + result[i].Freeze_Date__c);
                }
                else if(result[i].Name == 'May'){
                    result[i].Freeze_Date__c = May;
                    system.debug('The value is' + result[i].Freeze_Date__c);
                }
                else if(result[i].Name == 'June'){
                    result[i].Freeze_Date__c = June;
                    system.debug('The value is' + result[i].Freeze_Date__c);
                }
                else if(result[i].Name == 'July'){
                    result[i].Freeze_Date__c = July;
                    system.debug('The value is' + result[i].Freeze_Date__c);
                }
                else if(result[i].Name == 'August'){
                    result[i].Freeze_Date__c = August;
                    system.debug('The value is' + result[i].Freeze_Date__c);
                }
                else if(result[i].Name == 'September'){
                    result[i].Freeze_Date__c = September;
                    system.debug('The value is' + result[i].Freeze_Date__c);
                }
                else if(result[i].Name == 'October'){
                    result[i].Freeze_Date__c = October;
                    system.debug('The value is' + result[i].Freeze_Date__c);
                }
                else if(result[i].Name == 'November'){
                    result[i].Freeze_Date__c = November;
                    system.debug('The value is' + result[i].Freeze_Date__c);
                }
                else if(result[i].Name == 'December'){
                    result[i].Freeze_Date__c = December;
                    system.debug('The value is' + result[i].Freeze_Date__c);
                }
                else{
                    system.debug('Some error');
                    system.debug('The value is' + result[i].Freeze_Date__c);
                }
                
                i++;

        }
        update result;
        
        */
        }catch(Exception e){
            system.debug('An exception occured' + e.getMessage());
         }
        return null;
    }
    
    Public void cancel(){
    system.debug('cancel');
    }

/*
     Public PQNUpdateFreezePeriodCtrl(){
         PQNFreezeDate__c freezeDate = [select Id, Name, Freeze_Date__c 
                                    from PQNFreezeDate__c where Name='December'];
          fDate = Date.newInstance(freezeDate.Freeze_Date__c.year(), 
                                   freezeDate.Freeze_Date__c.month(), 
                                   freezeDate.Freeze_Date__c.day());
          system.debug('the date is' + fDate);
     }  
     */  
     
      
}