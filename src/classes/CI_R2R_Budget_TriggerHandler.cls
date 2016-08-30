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
            
    }
     /***********************************************************************************************************************************
    * bulkAfter
    *
    * This method is called prior to execution of a AFTER trigger. Use this to cache
    * any data required into maps prior execution of the trigger.
    */
    public void bulkAfter(){
        //This method has been included as the class implements the ITrigger interface
        Id cid;
    for(CI_R2R_Budget__c r2r: (List<CI_R2R_Budget__c>)trigger.new){
        cid = r2r.id;    
    }
    List<CI_R2R_Budget__c> budgetList = [select CI_R2R_Innovation__r.R2R_SME_Area__c,Company_Code__c,Cost_Centre__c,ICC_Number2__c from CI_R2R_Budget__c where id=:cId];
    system.debug('budgetList-->'+budgetList.size());
    List<CI_R2R_Budget__c> r2rbudgetList = new List<CI_R2R_Budget__c>();
    for(CI_R2R_Budget__c bud :budgetList){
        CI_R2R_Budget__c budget = new CI_R2R_Budget__c(id=bud.id);
        if(bud.CI_R2R_Innovation__r.R2R_SME_Area__c=='SCOA' && bud.Company_Code__c=='2646' && bud.ICC_Number2__c=='ICC14131'){
            budget.Cost_Centre__c = '19193';
          }
         if(bud.CI_R2R_Innovation__r.R2R_SME_Area__c=='Intercompany' && bud.Company_Code__c=='2646' && bud.ICC_Number2__c=='ICC11825'){
                    budget.Cost_Centre__c = '17441';
          }
          if(bud.CI_R2R_Innovation__r.R2R_SME_Area__c=='Intercompany' && bud.Company_Code__c=='2465' && bud.ICC_Number2__c=='ICC11825'){
                    budget.Cost_Centre__c = '1105700018';
          }
          if(bud.CI_R2R_Innovation__r.R2R_SME_Area__c=='Intercompany' && bud.Company_Code__c=='3009' && bud.ICC_Number2__c=='ICC11825'){
                    budget.Cost_Centre__c = '86I4451';
          }
           if(bud.CI_R2R_Innovation__r.R2R_SME_Area__c=='Intercompany' && bud.Company_Code__c=='5069' && bud.ICC_Number2__c=='ICC11825'){
                    budget.Cost_Centre__c = 'A956000239';
          }
           if(bud.CI_R2R_Innovation__r.R2R_SME_Area__c=='Intercompany' && bud.Company_Code__c=='2000' && bud.ICC_Number2__c=='ICC11825'){
                    budget.Cost_Centre__c = 'B500171733';
          }
           if(bud.CI_R2R_Innovation__r.R2R_SME_Area__c=='Intercompany' && bud.Company_Code__c=='1609' && bud.ICC_Number2__c=='ICC11825'){
                    budget.Cost_Centre__c = 'C002R873';
          }
          if(bud.CI_R2R_Innovation__r.R2R_SME_Area__c=='Intercompany' && bud.Company_Code__c=='3128' && bud.ICC_Number2__c=='ICC11825'){
                    budget.Cost_Centre__c = 'UU02R873';
          }
         if(bud.CI_R2R_Innovation__r.R2R_SME_Area__c=='Account Reconciliation' && bud.Company_Code__c=='3128' && bud.ICC_Number2__c=='ICC13071'){
                    budget.Cost_Centre__c = 'UU02P001';
          }
          if(bud.CI_R2R_Innovation__r.R2R_SME_Area__c=='Fixed Assets' && bud.Company_Code__c=='3128' && bud.ICC_Number2__c=='ICC13071'){
                    budget.Cost_Centre__c = 'UU02P003';
          }
          if(bud.CI_R2R_Innovation__r.R2R_SME_Area__c=='Journal Entries' && bud.Company_Code__c=='3128' && bud.ICC_Number2__c=='ICC13071'){
                    budget.Cost_Centre__c = 'UU02P006';
          }
          if(bud.CI_R2R_Innovation__r.R2R_SME_Area__c=='GL MDM' && bud.Company_Code__c=='3128' && bud.ICC_Number2__c=='ICC13071'){
                    budget.Cost_Centre__c = 'UU02P007';
          }
          if(bud.CI_R2R_Innovation__r.R2R_SME_Area__c=='FX Revaluation' && bud.Company_Code__c=='3128' && bud.ICC_Number2__c=='ICC13071'){
                    budget.Cost_Centre__c = 'UU02P007';
          }
          if(bud.CI_R2R_Innovation__r.R2R_SME_Area__c=='GPM' && bud.Company_Code__c=='3128' && bud.ICC_Number2__c=='ICC13071'){
                    budget.Cost_Centre__c = 'UU02P004';
          }
          if(bud.CI_R2R_Innovation__r.R2R_SME_Area__c=='Continuous Improvement' && bud.Company_Code__c=='3128' && bud.ICC_Number2__c=='ICC13071'){
                    budget.Cost_Centre__c = 'UU02P002';
          }
          if(bud.CI_R2R_Innovation__r.R2R_SME_Area__c=='Tools' && bud.Company_Code__c=='3128' && bud.ICC_Number2__c=='ICC13071'){
                    budget.Cost_Centre__c = 'UU02P009';
          }
          if(bud.CI_R2R_Innovation__r.R2R_SME_Area__c=='Project' && bud.Company_Code__c=='3128' && bud.ICC_Number2__c=='ICC13071'){
                    budget.Cost_Centre__c = 'UU02P009';
          }
          if(bud.CI_R2R_Innovation__r.R2R_SME_Area__c=='Period-End' && bud.Company_Code__c=='3128' && bud.ICC_Number2__c=='ICC13071'){
                    budget.Cost_Centre__c = 'UU02P007';
          }
          if(bud.CI_R2R_Innovation__r.R2R_SME_Area__c=='SAP Roles' && bud.Company_Code__c=='3128' && bud.ICC_Number2__c=='ICC13071'){
                    budget.Cost_Centre__c = 'UU02P008';
          }
          if(bud.CI_R2R_Innovation__r.R2R_SME_Area__c=='Account Reconciliation' && bud.Company_Code__c=='5069' && bud.ICC_Number2__c=='ICC13071'){
                    budget.Cost_Centre__c = 'A956001278';
          }
          if(bud.CI_R2R_Innovation__r.R2R_SME_Area__c=='Fixed Assets' && bud.Company_Code__c=='5069' && bud.ICC_Number2__c=='ICC13071'){
                    budget.Cost_Centre__c = 'A956001279';
          }
          if(bud.CI_R2R_Innovation__r.R2R_SME_Area__c=='Account Reconciliation' && bud.Company_Code__c=='5069' && bud.ICC_Number2__c=='ICC13071'){
                    budget.Cost_Centre__c = 'A956001278';
          }
          if(bud.CI_R2R_Innovation__r.R2R_SME_Area__c=='Journal Entries' && bud.Company_Code__c=='5069' && bud.ICC_Number2__c=='ICC13071'){
                    budget.Cost_Centre__c = 'A956001281';
          }
          if(bud.CI_R2R_Innovation__r.R2R_SME_Area__c=='GL MDM' && bud.Company_Code__c=='5069' && bud.ICC_Number2__c=='ICC13071'){
                    budget.Cost_Centre__c = 'A956001282';
          }
          if(bud.CI_R2R_Innovation__r.R2R_SME_Area__c=='FX Revaluation' && bud.Company_Code__c=='5069' && bud.ICC_Number2__c=='ICC13071'){
                    budget.Cost_Centre__c = 'A956001282';
          }
          if(bud.CI_R2R_Innovation__r.R2R_SME_Area__c=='Period-End' && bud.Company_Code__c=='5069' && bud.ICC_Number2__c=='ICC13071'){
                    budget.Cost_Centre__c = 'A956001282';
          }
          if(bud.CI_R2R_Innovation__r.R2R_SME_Area__c=='GPM' && bud.Company_Code__c=='5069' && bud.ICC_Number2__c=='ICC13071'){
                    budget.Cost_Centre__c = 'A956001283';
          }
          if(bud.CI_R2R_Innovation__r.R2R_SME_Area__c=='Continuous Improvement' && bud.Company_Code__c=='5069' && bud.ICC_Number2__c=='ICC13071'){
                    budget.Cost_Centre__c = 'A956001284';
          }
          if(bud.CI_R2R_Innovation__r.R2R_SME_Area__c=='Tools' && bud.Company_Code__c=='5069' && bud.ICC_Number2__c=='ICC13071'){
                    budget.Cost_Centre__c = 'A956001285';
          }
          if(bud.CI_R2R_Innovation__r.R2R_SME_Area__c=='Project' && bud.Company_Code__c=='5069' && bud.ICC_Number2__c=='ICC13071'){
                    budget.Cost_Centre__c = 'A956001285';
          }
          if(bud.CI_R2R_Innovation__r.R2R_SME_Area__c=='SAP Roles' && bud.Company_Code__c=='5069' && bud.ICC_Number2__c=='ICC13071'){
                    budget.Cost_Centre__c = 'A956001286';
          }
          
         if(bud.CI_R2R_Innovation__r.R2R_SME_Area__c=='Direct Tax' && bud.Company_Code__c=='5069' && bud.ICC_Number2__c=='ICC13605'){
                    budget.Cost_Centre__c = 'A956000847';
          }
         if(bud.CI_R2R_Innovation__r.R2R_SME_Area__c=='Indirect Tax' && bud.Company_Code__c=='5069' && bud.ICC_Number2__c=='ICC13606'){
                    budget.Cost_Centre__c = 'A956000848';
          }
         if(bud.CI_R2R_Innovation__r.R2R_SME_Area__c=='SCOA' && bud.Company_Code__c=='3128' && bud.ICC_Number2__c=='ICC14131'){
                    budget.Cost_Centre__c = 'UU02O103';
          }
         if(bud.CI_R2R_Innovation__r.R2R_SME_Area__c=='SCOA' && bud.Company_Code__c=='5069' && bud.ICC_Number2__c=='ICC14131'){
                    budget.Cost_Centre__c = 'A956001274';
          }
        r2rbudgetList.add(budget);
    }
    if(r2rbudgetList.size()>0){
        update r2rbudgetList;
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