/************************************************* 
*@Author:Cognizant
*@Date:January 2015
*@Description :  For Creating PDF Document for Bosscard
**************************************************/
public with sharing class IPM_ExportBosscardPDFController 
{
    //*@Description :Bosscard_Id to capture the ID from Page parameters.
    public String Bosscard_Id;
    
    //*@Description :Bosscard to retrive the BOSSCARD details of the current record.
    public IPM_Bosscard__c Bosscard {get; set;}
    
    //*@Description :usr to get the details of current logged in user.
    public User usr{get; set;}
    
    //*@Description : printBosscard to capture the Print status from Page parameters
    public String printBosscard;
    
    //*@Description :isPrint to capture the Print status and use it in the page. 
    public Boolean isPrint {get; set;}
    
    /**************************************************************************************
    *@Description :Initializing constructor  and to read the information from the page paramaters
                   To Query the detials of the BOSSCARD.
    ***************************************************************************************/
    public IPM_ExportBosscardPDFController()
    {    
                    
         Bosscard_Id=ApexPages.currentPage().getParameters().get('id');
         printBosscard=ApexPages.currentPage().getParameters().get('print');
         if(printBosscard=='true')
             isPrint=true;
        if (String.isNotBlank(Bosscard_Id)) {
            Bosscard=[SELECT Id,IPM_BosscardName__c,IPM_Target_Launch_Date__c,IPM_Category__c,IPM_Bosscard_Logo__c,
                     IPM_BosscardIdea__c,IPM_Gate_Keeper__c,IPM_Gate_Keeper__r.Name,IPM_Brand__c,IPM_Assumptions__c,
                     IPM_Background__c,IPM_Constraints__c,IPM_Deliverables__c,IPM_Opportunity__c,
                     IPM_Potential_Business_Opportunity__c,IPM_Consumer_Need__c,IPM_Resources__c,
                     IPM_Brand_Positioning__c,IPM_Scope__c,IPM_Sustainibility__c FROM IPM_Bosscard__c 
                     WHERE Id=:Bosscard_Id];
        }
        Apexpages.currentPage().getHeaders().put('content-disposition', 'attachment; filename='+Bosscard.IPM_BosscardName__c+IPM_ConstantUtils.BOSSCARD_PDF_FORMAT+system.today().format()+IPM_ConstantUtils.ATTACHMENT_FILE_TYPE);
    }

}