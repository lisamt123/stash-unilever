public class AF_EmailToCatFinance 
{
    List<AF_Brand_Estimate__c> lstBrandEstimate=new list<AF_Brand_Estimate__c>();
    public AF_EmailToCatFinance()
    {
        string year_url=ApexPages.CurrentPage().getParameters().get('Year');
        lstBrandEstimate=[SELECT Id,name,AF_Fiscal_Year__c,Brand__r.Name,AF_Notified_To_CatFinance__c FROM AF_Brand_Estimate__c WHERE AF_Status_Base_Fees__c = 'Initiate' AND AF_Active__c = true AND AF_Locked__c = false AND AF_Created_By_Batch__c = true AND AF_Notified_To_CatFinance__c = false AND AF_Fiscal_Year__c =:year_url];
        
        if(lstBrandEstimate.size()==0)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'No records to notify'));
    }
    
    public boolean displayPopup {get; set;}
    public PageReference confirm() 
    {       
        
        if(lstBrandEstimate.size()>0)
        {        
            
            //List<Id> lstusers=new List<Id>();
            //List<String> lstEmail=new List<String>();
            Map<string,string> mapusers=new Map<string,string>();
            
            List<PermissionSetAssignment> permissionSetAssign=[SELECT Assignee.email,Assignee.name,Id,PermissionSetId FROM PermissionSetAssignment where PermissionSet.name=:'AF_Category_Finance'];
            if(permissionSetAssign.size()>0)
            {
                for(PermissionSetAssignment assignment : permissionSetAssign)
                {
                    //lstusers.add(assignment.AssigneeId);
                    //lstEmail.add(assignment.Assignee.email);
                    mapusers.put(assignment.Assignee.email,assignment.Assignee.name);
                }
            }
            
                mapusers.put('yamunayarlagadda@gmail.com','Yamuna Yarlagadda');
                if(!mapusers.isempty())
                {
                    list<AF_Brand_Estimate__c> BrandEstimates=new list<AF_Brand_Estimate__c>();
                    
                    string strbody='';
                    strbody+='<p>Creative agency fee estimates are required to be entered in the tool for "2014" financial year. Please log into the Agency Fees application, using the link below, and enter your overall estimate for Brand Beverages';
                    for(AF_Brand_Estimate__c AFB:lstBrandEstimate)
                    {
                        AFB.AF_Notified_To_CatFinance__c=true;
                        BrandEstimates.add(AFB);
                        strbody+=', '+AFB.Brand__r.Name+'';
                    }
                    strbody+='</p>';
                    
                    list<Messaging.SingleEmailMessage> emailslist=new list<Messaging.SingleEmailMessage>();
                    for(string str: mapusers.keyset())
                    {
                        List<String> lstEmail=new List<String>();
                        lstEmail.add(str);
                        string headdr='Dear '+mapusers.get(str)+'<br/>';
                        headdr+=strbody+'<br/><br/>';
                        headdr+='From<br/><br/>CMCO Finance';
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage() ;                    
                        mail.setToAddresses(lstEmail) ;
                        mail.setSubject('Agency Fees alignment process for the current financial year');         
                        mail.setHtmlBody(headdr);
                        emailslist.add(mail);
                    }
                    
                    
                    if(!emailslist.isempty() && !Test.isRunningTest())
                    {     
                        Messaging.sendEmail(emailslist);
                    }
                    update BrandEstimates;
                    displayPopup =true;
                }
            
        }
        Else
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'No records to notify'));
        }
        return null;
    }
    
    public void closePopup() 
        { 
           system.debug('control is inside Closepopup action method');
           displayPopup = false;    
        }

}