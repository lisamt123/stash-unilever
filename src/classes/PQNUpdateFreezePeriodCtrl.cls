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
    
    
    // "PQNUpdateFreezePeriodCtrl" constructor
    Public PQNUpdateFreezePeriodCtrl (){
    
        //Fetch the current month value of the custom setting record and display the value
        currentMonthFreezePeriod = [select Id, Name, Numeric_Value__c, Freeze_Date__c from PQNFreezeDate__c where Numeric_Value__c =: Date.Today().Month() LIMIT 1];
        
        //Get the Profile ID of the Logged in User to check wheather logged in User is internal user or not
        Id pId = userinfo.getProfileId();
        List<Profile> pList = [select Id, Name from Profile where Id=: pId LIMIT 1];
        String pName = pList[0].Name;
        
        //If profile id "Admin" display the button for the user
        if(pName == 'system Administrator' || pName == 'Unilever - Salesforce MultiApp Standard')
        flag = true;
        
        //Fetch all the custom setting records
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
        system.debug('method about to call');
    }
    
    Public pageReference updateFreezePeriod(){
    try{
        
        /*
        //Validation : Check wheather the Freeze Date entedred by the user is not less than Today's date
            
        if( January < Date.Today() || February < Date.Today() || March < Date.Today() || April < Date.Today() || May < Date.Today() || June < Date.Today() || July < Date.Today() || August < Date.Today() || September < Date.Today() || October < Date.Today() || November < Date.Today() || December < Date.Today()){
            // display an error message to the user
        
            ApexPages.Message myFreezeMessage = new ApexPages.Message(ApexPages.Severity.FATAL,'Freeze Date should be greater than today');
            ApexPages.addMessage(myFreezeMessage);
            system.debug('Not valid date');
            system.debug('Jan' + January);
            return null;
                
        }
        //Validation Ends Here
        
        else{
        
        */
        
        
        //set the List of PQNFreezeDate__c and store in the list
        
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
        
        
        // Update the Custom Setting
        update result;
        system.debug('The list is' + result);
        
        
        
        

        }catch(Exception e){
            system.debug('An exception occured' + e.getMessage());
         }
        return null;
    } 
}