/**********************************************************************
Name: CI_R2R_Budget_TriggerHandler
Purpose:
This TriggerHandler is used to populate the Costcentre 
according to the ICC and company code and SME Area on CI_R2R_Budget records 
VERSION   AUTHOR   DATE    
1.0       Chandana June-2016   
***********************************************************************/
public with sharing class CI_R2R_Budget_TriggerHandler implements ITrigger{
    
    // Constructor
    public CI_R2R_Budget_TriggerHandler() {       
        ExceptionLoggingHelper.initializeExceptionLog(); 
    }
    /***********************************************************************************************************************************
    * bulkBefore
    *
    * This method is called prior to execution of a BEFORE trigger. Use this to cache
    * any data required into maps prior execution of the trigger.
    */
    public void bulkBefore(){
    
    //This method has been included as the class implements the ITrigger interface
         Map<string,string> mapbudget = new Map<string,string>();
         Map<id,CI_R2R_Innovation__c> mapinn = new Map<id,CI_R2R_Innovation__c>();

         List<CI_R2R_Budget_Mapping__c> listrec = CI_R2R_Budget_Mapping__c.getall().values();
         
         set<id> setinnovation = new set<id>();
         for(CI_R2R_Budget__c r2r: (List<CI_R2R_Budget__c>)trigger.new){       
           //cid = r2r.id;   
           setinnovation.add(r2r.CI_R2R_Innovation__c); 
         }
         List<CI_R2R_Innovation__c> innList = [select R2R_SME_Area__c,id from CI_R2R_Innovation__c where id=:setinnovation];
         for(CI_R2R_Innovation__c inn: innList){
             mapinn.put(inn.id,inn);
         }
         if(trigger.isInsert){
            for(CI_R2R_Budget_Mapping__c crb : listrec){            
                mapbudget.put(crb.R2R_SME_Area__c + crb.ICC_Number__c + crb.Company_Code__c, crb.Cost_Centre__c); 
                //system.debug('dddddddddddd'+crb.R2R_SME_Area__c + crb.ICC_Number__c + crb.Company_Code__c);                   
            }

            for(CI_R2R_Budget__c Budget : (List<CI_R2R_Budget__c>)trigger.new){
                system.debug('ffffffffffff'+mapinn.get(Budget.CI_R2R_Innovation__c).R2R_SME_Area__c+ Budget.ICC_Number2__c + Budget.Company_Code__c);
                if(mapbudget.containsKey(mapinn.get(Budget.CI_R2R_Innovation__c).R2R_SME_Area__c + Budget.ICC_Number2__c + Budget.Company_Code__c)){
                Budget.Cost_Centre__c= mapbudget.get(mapinn.get(Budget.CI_R2R_Innovation__c).R2R_SME_Area__c + Budget.ICC_Number2__c + Budget.Company_Code__c);
                system.debug('ssss'+Budget.Cost_Centre__c);
                }
                else{
                    Budget.addError('Combination of ICC Number,Company Code and SME doesnot exist');
                    system.debug('else entered');
                }

            }
         }        
    }
     /***********************************************************************************************************************************
    * bulkAfter
    *
    * This method is called prior to execution of a AFTER trigger. Use this to cache
    * any data required into maps prior execution of the trigger.
    */
    public void bulkAfter(){
        //This method has been included as the class implements the ITrigger interface

    }
    public void beforeInsert(SObject so){
        //This method has been included as the class implements the ITrigger interface
        
    }
    
    public void beforeUpdate(SObject oldSo, SObject so){   
        //This method has been included as the class implements the ITrigger interface
      
    }
    public void beforeDelete(SObject so){      
        //This method has been included as the class implements the ITrigger interface
    }
    
    public void afterInsert(SObject so){
        //This method has been included as the class implements the ITrigger interface
        
    }
    
    public void afterUpdate(SObject oldSo, SObject so){    
        //This method has been included as the class implements the ITrigger interface
          
     
    }
    
    public void afterDelete(SObject so){
        //This method has been included as the class implements the ITrigger interface
    } 
    public void andFinally(){
        //Added by Devendra - call method to insert all exception logs got while excecution of trigger
        ExceptionLoggingHelper.insertLogRecordList();
    }   
    
    
}