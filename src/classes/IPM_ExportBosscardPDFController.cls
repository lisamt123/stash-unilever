/* Type Name: IPM_ExportBosscardPDFController 
Author: 
Created Date:
Reason: For Creating PDF Document for Bosscard
Change History:
Author: 
Modified Date:  */
public with sharing class IPM_ExportBosscardPDFController 
{
    //Initializing Variables
    public String Bosscard_Id;
    public IPM_Bosscard__c Bosscard {get; set;}
    public User usr{get; set;}
    public String printBosscard;
    public Boolean isPrint {get; set;}
    
    //Initializing Constructor
    public IPM_ExportBosscardPDFController()
    {    
                    
         Bosscard_Id=ApexPages.currentPage().getParameters().get('id');
         System.debug('bosscard id.........'+Bosscard_Id);
         printBosscard=ApexPages.currentPage().getParameters().get('print');
         if(printBosscard=='true')
             isPrint=true;
         Bosscard=[Select Id,IPM_BosscardName__c,IPM_Target_Launch_Date__c,IPM_Category__c,IPM_Bosscard_Logo__c,IPM_BosscardIdea__c,IPM_Gate_Keeper__c,IPM_Gate_Keeper__r.Name,IPM_Brand__c,IPM_Assumptions__c,IPM_Background__c,IPM_Constraints__c,IPM_Deliverables__c,IPM_Opportunity__c,IPM_Potential_Business_Opportunity__c,IPM_Consumer_Need__c,IPM_Resources__c,IPM_Brand_Positioning__c,IPM_Scope__c,IPM_Sustainibility__c from IPM_Bosscard__c where Id=:Bosscard_Id];
         usr=[SELECT Id,IPM_Brand_Name__c,IPM_Category__c,IPM_Role__c,Name FROM User where Id=:UserInfo.getUserId()];
         Apexpages.currentPage().getHeaders().put('content-disposition', 'attachment; filename='+Bosscard.IPM_BosscardName__c+'_BOSSCARD-'+system.today().format()+'.pdf');
    }

}