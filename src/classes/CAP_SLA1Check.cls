/**
 * @author Pooja Kanani
 * @date 29/12/2015
 * @description - This Class is used to update PWORF after SLA1 clock is completed
 */
global class CAP_SLA1Check implements Schedulable{
    global void execute(SchedulableContext sc){
        autoAcceptedPWORF();
    }
/*
    * Method Name : autoAcceptedPWORF
    * Parameter   : 
    * Return type : None
    * Description : This method is used to auto update of PWORF Status fielf to Auto Accepted once SLA1 cloc is completed
    */    
    global void autoAcceptedPWORF(){
        List<CPA_PWORF__c> PWORFList = new List<CPA_PWORF__c>();       
        PWORFList = [Select Id,dat_Submitted_Date__c,dat_Resubmitted_Date__c,dat_SLA1_Accepted_Date__c,dat_Withhold_Date__c,pkl_Status__c from CPA_PWORF__c where pkl_Status__c='Submitted' OR pkl_Status__c='Resubmitted'];

        if(PWORFList != null && !PWORFList.isEmpty()){
            for(CPA_PWORF__c PWORF : PWORFList){
                if(PWORF.dat_SLA1_Accepted_Date__c == System.Today()){
                    try{
                        PWORF.pkl_Status__c = 'Auto Accepted';
                    }
                    catch(Exception exp){
                        system.debug('Exception while Updating Status' + exp.getMessage());
                    }
                }
            }
        }
    }
}