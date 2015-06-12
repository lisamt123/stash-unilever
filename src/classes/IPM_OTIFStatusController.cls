public class IPM_OTIFStatusController
{
    public Id projDocSecId;
    public ID getprojDocSecId(){ return projDocSecId; }
        public void setprojDocSecId (ID p){
            projDocSecId= p;
            showSectionContent();
        }
    public Id secConId{get; set;}
    public Boolean edit{get; set;}
    public string status{get; set;}
    public List<IPM_Project_Document_Section_Content__c> secConList{get; set;}
    public IPM_Project_Document_Section_Content__c secCon{get; set;}
    public boolean Iseditable{get;set;}
    public ID projectId{get;set;}
    public IPM_Project_Document_Section__c projDocSec{get;set;}
    public String type{get; set;}
    public void showSectionContent()
    {
        projectId=ApexPages.currentPage().getParameters().get('Id');
        System.debug(projDocSecId+'Before Error');
        projDocSec=[Select Id,IPM_Section_Sequence__c from IPM_Project_Document_Section__c where Id=:projDocSecId];
        System.debug(type+'OTIF Type');
        if(type=='Table')
            secConList=[Select Id,IPM_OTIF_No_of_Status__c,IPM_OTIF_Measure__c,IPM_OTIF_Responsibility__c,IPM_OTIF_Status__c,IPM_Project_Document_Section__c,IPM_Section_type__c,IPM_OTIF_HelpText_Red__c,IPM_OTIF_HelpText_NA__c,IPM_OTIF_HelpText_Green__c,IPM_OTIF_HelpText_Amber__c,IPM_Section_Number__c,IPM_OTIF_Sequence__c,IPM_Section_Id__c,IPM_Section_Name__c from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__c=:projDocSecId order by IPM_OTIF_Sequence__c asc];
        else if(type=='Section')
            secConList=[Select Id,IPM_OTIF_No_of_Status__c,IPM_OTIF_Measure__c,IPM_OTIF_Responsibility__c,IPM_OTIF_Status__c,IPM_Project_Document_Section__c,IPM_Section_type__c,IPM_OTIF_HelpText_Red__c,IPM_OTIF_HelpText_NA__c,IPM_OTIF_HelpText_Green__c,IPM_OTIF_HelpText_Amber__c,IPM_Section_Number__c,IPM_OTIF_Sequence__c,IPM_Section_Id__c,IPM_Section_Name__c from IPM_Project_Document_Section_Content__c where IPM_Section_Id__c=:projDocSecId order by IPM_OTIF_Sequence__c asc];     
    }
    public pageReference updateOTIFStatus()
    {
        secCon=[Select Id,IPM_OTIF_No_of_Status__c,IPM_OTIF_Measure__c,IPM_OTIF_Responsibility__c,IPM_OTIF_Status__c,IPM_Project_Document_Section__c,IPM_Section_type__c,IPM_OTIF_HelpText_Red__c,IPM_OTIF_HelpText_NA__c,IPM_OTIF_HelpText_Green__c,IPM_OTIF_HelpText_Amber__c,IPM_Section_Id__c,IPM_Section_Name__c from IPM_Project_Document_Section_Content__c where Id=:secConId];
        secCon.IPM_OTIF_Status__c=status;
        update secCon;
        showSectionContent();
        return null;     
    }
}