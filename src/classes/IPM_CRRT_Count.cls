public class IPM_CRRT_Count
{
    public Integer noChangeCount{get; set;}
    public Integer discontinueCount{get; set;}
    public Integer replaceCount{get; set;}
    public Integer newCount{get; set;}
    public Integer totalCount{get; set;}
    
    public string gateDocType{get;set;}
    public ID projDocSecId{ 
        get {
            return projDocSecId;
        }
        set {
            projDocSecId= value;
            displayCRRTCounts();         
        }
      }
   
    public void displayCRRTCounts()
    {
            noChangeCount=[Select count() from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__c=:projDocSecId and IPM_CRRT_Status__c='No Change'];
            discontinueCount=[Select count() from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__c=:projDocSecId and IPM_CRRT_Status__c='Discontinued'];
            replaceCount=[Select count() from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__c=:projDocSecId and IPM_CRRT_Status__c='Replace'];
            newCount=[Select count() from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__c=:projDocSecId and IPM_New_CRRT__c=true];
            totalCount=[Select count() from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__c=:projDocSecId];
            totalCount=totalCount-noChangeCount;
    }

}