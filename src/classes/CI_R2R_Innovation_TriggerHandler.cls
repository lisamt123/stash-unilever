/**********************************************************************
Name: CI_R2R_Innovation_TriggerHandler
Purpose:
This TriggerHandler is used to populate the Project Lead 
according to the SME on CI_R2R_Innovations records dynamically from custom settings
VERSION   AUTHOR   DATE    
1.0       Chandana June-2016   
***********************************************************************/
public with sharing class CI_R2R_Innovation_TriggerHandler implements ITrigger{
    
    // Constructor
    public CI_R2R_Innovation_TriggerHandler() {       
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
    }
     /***********************************************************************************************************************************
    * bulkAfter
    *
    * This method is called prior to execution of a AFTER trigger. Use this to cache
    * any data required into maps prior execution of the trigger.
    */
    public void bulkAfter(){
        //This method has been included as the class implements the ITrigger interface
        Integer count=0;
        Id cid=null;
        string pic='';
    for(CI_R2R_Innovation__c r2r : (list<CI_R2R_Innovation__c>)Trigger.new){
       pic = r2r.R2R_SME_Area__c;
       cid=r2r.Id;       
    } 
    
    List<CI_R2R_Innovation__c> cilist = [select R2R_SME_Area__c from CI_R2R_Innovation__c where R2R_SME_Area__c =:pic]; 
    
    count = CIList.size(); 
    
    List<CI_R2R_Innovation__c> r2rList = new List<CI_R2R_Innovation__c>();
    
    Map<string,string> mapsme = new Map<string,string>();
    mapsme.put('Fixed Assets','FA');
    mapsme.put('Account Reconciliation','AR');
    mapsme.put('Continuous Improvement','CI');
    mapsme.put('Financial Reporting','FR');
    mapsme.put('FX Revaluation','FX');
    mapsme.put('Intercompany','IC');
    mapsme.put('Journal Entries','JE');
    mapsme.put('GL MDM','GLMDM');
    mapsme.put('Period-End','PE');
    mapsme.put('Project','PT');
    mapsme.put('SAP Roles','SR');
    mapsme.put('Tools','PT');
    mapsme.put('GPM','GPM');
    mapsme.put('SCOA','SCOA');
    mapsme.put('Direct Tax','DT');
    mapsme.put('Indirect Tax','IDT');
    mapsme.put('SI – External','SI');
    for(CI_R2R_Innovation__c CI : [select R2R_SME_Area__c from CI_R2R_Innovation__c where ID=:cid]){
        CI_R2R_Innovation__c clist = new CI_R2R_Innovation__c(id=CI.id);
        
        DateTime dt = system.now();
        String yearstr = string.valueof(dt.year());
        
        if(mapsme.containsKey(CI.R2R_SME_Area__c)){
            clist.Project2__c = yearstr +'.'+ mapsme.get(CI.R2R_SME_Area__c)+'.'+ count;
        }
        r2rList.add(clist);
    }
    if(!r2rList.isEmpty()){
        update r2rList;    
    }
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