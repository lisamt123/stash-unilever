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
    Id cid;
    string pic;
    for(CI_R2R_Innovation__c r2r : (list<CI_R2R_Innovation__c>)Trigger.new){
       pic = r2r.R2R_SME_Area__c;
       cid=r2r.Id;       
    } 
    
    List<CI_R2R_Innovation__c> cilist = [select R2R_SME_Area__c from CI_R2R_Innovation__c where R2R_SME_Area__c =:pic]; 
    
    count = CIList.size(); 
    
    List<CI_R2R_Innovation__c> r2rList = new List<CI_R2R_Innovation__c>();
    for(CI_R2R_Innovation__c CI : [select R2R_SME_Area__c from CI_R2R_Innovation__c where ID=:cid]){
        CI_R2R_Innovation__c clist = new CI_R2R_Innovation__c(id=CI.id);
        
        DateTime dt = system.now();
        String yearstr = string.valueof(dt.year());
        
        if(CI.R2R_SME_Area__c == 'Fixed Assets'){
            clist.Project2__c = yearstr +'.'+ 'FA'+'.'+ count;
        }
        if(CI.R2R_SME_Area__c == 'Account Reconciliation'){
            clist.Project2__c = yearstr +'.'+ 'AR'+'.'+ count;
        }
        if(CI.R2R_SME_Area__c == 'Continuous Improvement'){
            clist.Project2__c = yearstr +'.'+ 'CI'+'.'+ count;
        }
        if(CI.R2R_SME_Area__c == 'Financial Reporting'){
            clist.Project2__c = yearstr +'.'+ 'FR'+'.'+ count;
        }
        if(CI.R2R_SME_Area__c == 'FX Revaluation'){
            clist.Project2__c = yearstr +'.'+ 'FX'+'.'+ count;
        }
        if(CI.R2R_SME_Area__c == 'Intercompany'){
            clist.Project2__c = yearstr +'.'+ 'IC'+'.'+ count;
        }
        if(CI.R2R_SME_Area__c == 'Journal Entries'){
            clist.Project2__c = yearstr +'.'+ 'JE'+'.'+ count;
        }
        if(CI.R2R_SME_Area__c == 'GL MDM'){
            clist.Project2__c = yearstr +'.'+ 'MDM'+'.'+ count;
        }
        if(CI.R2R_SME_Area__c == 'Period-End'){
            clist.Project2__c = yearstr +'.'+ 'PE'+'.'+ count;
        }
        if(CI.R2R_SME_Area__c == 'Project'){
            clist.Project2__c = yearstr +'.'+ 'PT'+'.'+ count;
        }
        if(CI.R2R_SME_Area__c == 'SAP Roles'){
            clist.Project2__c = yearstr +'.'+ 'SR'+'.'+ count;
        }
        if(CI.R2R_SME_Area__c == 'Tax'){
            clist.Project2__c = yearstr +'.'+ 'Tx'+'.'+ count;
        }
        if(CI.R2R_SME_Area__c == 'Tools'){
            clist.Project2__c = yearstr +'.'+ 'PT'+'.'+ count;
        }
        if(CI.R2R_SME_Area__c == 'GPM'){
            clist.Project2__c = yearstr +'.'+ 'GPM'+'.'+ count;
        }
        if(CI.R2R_SME_Area__c == 'SCOA'){
            clist.Project2__c = yearstr +'.'+ 'SCOA'+'.'+ count;
        }
        if(CI.R2R_SME_Area__c == 'Direct Tax'){
            clist.Project2__c = yearstr +'.'+ 'DT'+'.'+ count;
        }
        if(CI.R2R_SME_Area__c == 'Indirect Tax'){
            clist.Project2__c = yearstr +'.'+ 'IDT'+'.'+ count;
        }
        r2rList.add(clist);
    }
    if(r2rList.size()>0){
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