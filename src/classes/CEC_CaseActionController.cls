public class CEC_CaseActionController {
    
    // to store the caseId from parent page
    public String CurrentCaseId{get; set;}
    // list used to store all case Actions
    Public list <cec_Case_Action__c> CaseActionList {get;set;}

    
     //Class Constructor
    Public CEC_CaseActionController(){
        // get case id
        CurrentCaseId = ApexPages.CurrentPage().getparameters().get('id');
        if(CurrentCaseId!= null ){
        
            CaseActionList = [Select Id, Case_Id__c , Q2_Data__c, Q3_Data__c, Q4_Data__c, Q5_Data__c, Q6_Data__c, Q7_Data__c, Q8_Data__c, Q9_Data__c, Q10_Data__c, Q11_Data__c,Q12_Data__c, Survey_Id__c, Survey_Name__c From cec_Case_Action__c WHERE Case_Id__c = :CurrentCaseId];
        }
        
    }
}