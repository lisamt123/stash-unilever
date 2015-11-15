List<IPM_Section__c> secList=[Select Id,IPM_Section_Sequence__c,IPM_Document_Template__c, IPM_Parent_Section__c from IPM_Section__c where NOT(IPM_Section_Sequence__c LIKE '%.%.%')];
List<IPM_Section__c> parentSecList=[Select Id,IPM_Section_Sequence__c,IPM_Document_Template__c, IPM_Parent_Section__c from IPM_Section__c where IPM_Section_Sequence__c like '%.%'];
System.debug(parentSecList.size());
for(IPM_Section__c sec:secList){
    for(IPM_Section__c psec:parentSecList){
        if(psec.IPM_Section_Sequence__c.length()==5 && sec.IPM_Section_Sequence__c.length()==3 && psec.IPM_Document_Template__c==sec.IPM_Document_Template__c && psec.IPM_Section_Sequence__c.subString(0,3)==sec.IPM_Section_Sequence__c){
                                                psec.IPM_Parent_Section__c=sec.Id;
        }
        if(psec.IPM_Section_Sequence__c.length()==3 && sec.IPM_Section_Sequence__c.length()==1 && psec.IPM_Document_Template__c==sec.IPM_Document_Template__c && psec.IPM_Section_Sequence__c.subString(0,1)==sec.IPM_Section_Sequence__c){
                                                psec.IPM_Parent_Section__c=sec.Id;
        }
    }
}
update parentSecList;