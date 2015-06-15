public class IPM_BosscardStatusController 
{
    public IPM_Bosscard__c bosscard{get; set;}
    public IPM_Project__c project{get; set;}
    public string bosscardId{get; set;}
    public boolean isApproved{get;set;}
    public id selectedCompany{get;set;}
    public String CompanyType{get;set;}
    public list<selectoption>lstCompany{get;set;}
     
    public list<IPM_User_Profile__c>CompanyCard=new list<IPM_User_Profile__c>();
    public list<IPM_User_Profile__c>lstGatekeeper=new list<IPM_User_Profile__c>();
    public IPM_BosscardStatusController()
    {
        bosscardId = ApexPages.currentPage().getParameters().get('Id');
        bosscard=[Select Id,IPM_BosscardName__c,IPM_Category__c,IPM_Bosscard_Status__c,IPM_Company_Card__c,IPM_Bosscard_Approver_Comments__c,IPM_Filled_In_Percent__c,IPM_Bosscard_Logo_Id__c,IPM_Target_Launch_Date__c,IPM_Bosscard_Logo__c,IPM_BosscardIdea__c,IPM_Gate_Keeper__c,IPM_Gate_Keeper__r.Name,IPM_Brand__c,IPM_Assumptions__c,IPM_Background__c,IPM_Constraints__c,IPM_Deliverables__c,IPM_Opportunity__c,IPM_Potential_Business_Opportunity__c,IPM_Consumer_Need__c,IPM_Resources__c,IPM_Brand_Positioning__c,IPM_Scope__c,IPM_Sustainibility__c from IPM_Bosscard__c where Id=:bosscardId];
        project=[Select Id,IPM_Bosscard__c,IPM_Company_Card__c,IPM_Project_Name__c from IPM_Project__c where IPM_Bosscard__c=:bosscardId];
        string CCardid='';
        CompanyCard=[select IPM_Company_Card__c,IPM_Project_Leader__c from IPM_User_Profile__c where IPM_User__c=:userinfo.getuserid()];
            if(CompanyCard.size()>0){
                CCardid=CompanyCard[0].IPM_Company_Card__c;   
             }
           if(CCardid !=''){
            lstGatekeeper=[select IPM_User__c from IPM_User_Profile__c where IPM_Company_Card__c=:CCardid];
            }
    }
    /* Type Name: getStatusValue()
Author: 
Parameter(s)
ReturnType: List
Reason: For getting Bosscard Status Values*/  
    public List<SelectOption> getStatusValue(){
        Schema.sObjectType sobject_type = IPM_Bosscard__c.getSObjectType();

        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();

        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        
        List<Schema.PicklistEntry> pick_list_values = field_map.get('IPM_Bosscard_Status__c').getDescribe().getPickListValues();

        List<selectOption> options = new List<selectOption>();

        for (Schema.PicklistEntry a : pick_list_values) {
            options.add(new selectOption(a.getLabel(), a.getValue()));
        }
        return options;
    }
    /* Type Name: archive()
Author: 
Parameter(s)
ReturnType: void 
Reason: For Archieving Bosscard */     
    public void archive() 
    {
        try
        {
            bosscard.IPM_Is_Draft__c = false;
            bosscard.IPM_Is_Accepted__c=false;
            bosscard.IPM_Is_Archived__c=true;
            update bossCard;
            project.IPM_Project_Name__c=bosscard.IPM_BosscardName__c;
            project.IPM_Project_Leader__c=UserInfo.getUserId();
            project.IPM_Brand__c=bosscard.IPM_Brand__c;
            project.IPM_Category_Text__c=bosscard.IPM_Category__c;
            project.IPM_Brand_Positioning__c=bosscard.IPM_Brand_Positioning__c;
            project.IPM_Project_Gatekeeper__c=bosscard.IPM_Gate_Keeper__c;
            project.IPM_Target_Launch_Date__c=bosscard.IPM_Target_Launch_Date__c;
            project.IPM_Bosscard__c=bosscard.Id;
            project.Is_Archieved__c=true;
            project.IPM_Project_Logo__c=bosscard.IPM_Bosscard_Logo__c;
            project.IPM_Project_Logo_Id__c=bosscard.IPM_Bosscard_Logo_Id__c;
            update project;
        }       
        catch(Exception e)
        {
            if(e.getMessage().contains(IPM_ConstantUtils.DUPLICATE_EXCEPTION))
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,System.Label.IPM_Project_Name_Exists)); 
        }               
    }  

    /* Type Name: accept()
Author: 
Parameter(s)
ReturnType: void 
Reason: For Self-Approval of Bosscard  */ 
    public void accept()
    {        
        try
        {
            bosscard.IPM_Is_Draft__c = false;
            bosscard.IPM_Is_Accepted__c=true;
            bosscard.IPM_Is_Archived__c=false;
            update bossCard;
            project.IPM_Phase__c='Ideas';
            project.IPM_Project_Name__c=bosscard.IPM_BosscardName__c;
            project.IPM_Project_Leader__c=UserInfo.getUserId();
            project.IPM_Brand__c=bosscard.IPM_Brand__c;
            project.IPM_Category_Text__c=bosscard.IPM_Category__c;
            project.IPM_Brand_Positioning__c=bosscard.IPM_Brand_Positioning__c;
            project.IPM_Project_Gatekeeper__c=bosscard.IPM_Gate_Keeper__c;
            project.IPM_Target_Launch_Date__c=bosscard.IPM_Target_Launch_Date__c;
            project.IPM_Bosscard__c=bosscard.Id;
            project.IPM_Project_Logo__c=bosscard.IPM_Bosscard_Logo__c;
            project.IPM_Project_Logo_Id__c=bosscard.IPM_Bosscard_Logo_Id__c;
           /* if(lstGatekeeper.size()>0){
                  project.IPM_Project_Gatekeeper__c=lstGatekeeper[0].IPM_User__c;
                 }*/
            
           project.IPM_Company_Card__c=Bosscard.IPM_Company_Card__c;
           update project;
            
        }       
        Catch(Exception e)
        {
            if(e.getMessage().contains(IPM_ConstantUtils.DUPLICATE_EXCEPTION))
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,System.Label.IPM_Project_Name_Exists)); 
        }
    }
    /* Type Name: updateStatus()
Author: 
Parameter(s)
ReturnType: void 
Reason: For changing the status of Bosscard  */     
    public void updateStatus()
    {
        System.debug(bosscard.IPM_Bosscard_Status__c+'bosscard.IPM_Bosscard_Status__c');
        if(bosscard.IPM_Bosscard_Status__c=='In Progress')
        {
            update bosscard;
        }
        else if(bosscard.IPM_Bosscard_Status__c=='Not Approved')
        {
            update bosscard;
        }
        else if(bosscard.IPM_Bosscard_Status__c=='Approved')
        {
            accept();
        }
        else if(bosscard.IPM_Bosscard_Status__c=='Discard')
        {
            archive();    
        }
    }        
public void checkApproved(){
system.debug('bosscard.IPM_Bosscard_Status__c.....'+bosscard.IPM_Bosscard_Status__c);
if(bosscard.IPM_Bosscard_Status__c=='Approved'){ 
isApproved=true;
}else{
isApproved=false;
}

}
public void setStatus()
{
System.debug(bosscard.IPM_Bosscard_Status__c+'bosscard.IPM_Bosscard_Status__c');

}



}