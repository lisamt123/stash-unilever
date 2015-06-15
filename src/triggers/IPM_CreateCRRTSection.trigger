/* Type Name: IPM_CreateCRRTSection
Developed By: Kannan and Samrat
Change History: 
Reason: To Create CRRT Section Records for Gate Documents */
trigger IPM_CreateCRRTSection on IPM_Country__c (after insert,before delete) 
{

    List<IPM_Country__c> countryList=new List<IPM_Country__c>();
    Set<Id> countryListIds=new Set<Id>();
    if(trigger.isInsert)
    {
        for(IPM_Country__c c:Trigger.New)
        {
            countryListIds.add(c.Id);
            //countryList.add(c);
        }
        countryList=[Select Id,Country_Code__c,Country_Name__c,Geography__c,Local_Rollout__c,Market_Cluster_Code__c,Market_Cluster_Name__c,MCO_Code__c,MCO_Name__c,Project_Country__c,IPM_Project__c from IPM_Country__c where Id in:countryListIds and IPM_Project__r.IPM_Phase__c='Ideas'];
        System.debug(countryList+'countryList');
        if(countryList.size()>0 && countryList!=null)
        IPM_CRRT_Section_Controller.createCRRTSections('Charter',countryList,'');
    }
    if(trigger.isDelete)
    {
        List<IPM_Country__c> deleteCountryList=new List<IPM_Country__c>();
        for(IPM_Country__c c:Trigger.Old)
        {
            deleteCountryList.add(c);
        }
        if(deleteCountryList.size()>0)
        IPM_CRRT_Section_Controller.deleteCRRTSection(deleteCountryList);
    }

}