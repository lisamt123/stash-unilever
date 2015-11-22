List<IPM_Task__c> tskList=[Select Id,IPM_Type_of_Gate__c,IPM_Section_Number__c,IPM_Project_Template__c,IPM_Section__c from IPM_Task__c ];
List<IPM_Section__c> sectionList=[SelectId,IPM_Section_Sequence__c,IPM_Document_Template__c,IPM_Document_Template__r.IPM_Document_Type__c,IPM_Document_Template__r.IPM_Project_Template__c from IPM_Section__c];
for(IPM_Task__c tsk:tskList){
                for(IPM_Section__c sec:sectionList){
                                if(tsk.IPM_Project_Template__c==sec.IPM_Document_Template__r.IPM_Project_Template__c && tsk.IPM_Type_of_Gate__c==sec.IPM_Document_Template__r.IPM_Document_Type__c && tsk.IPM_Section_Number__c==sec.IPM_Section_Sequence__c){
                                                tsk.IPM_Section__c=sec.Id;
                                }
                }
}
update tskList;