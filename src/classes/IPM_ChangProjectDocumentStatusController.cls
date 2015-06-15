public class IPM_ChangProjectDocumentStatusController {
    public Id projectId{get; set;}
    public IPM_Project__c project{get; set;}
    public IPM_Project_Document__c projectDoc {get; set;}
    public List<IPM_Project_Document_Section__c> projSectionList {get; set;}
    public List<IPM_Project_Document_Section__c> projSectionListUpdate {get; set;}
    public List<IPM_Milestone__c> dueMilestones{get; set;}
    public Boolean showSkipSections{get; set;}
    public String Status{get; set;}
    public Integer oldSize{get;set;}
    public Boolean showValidation {get;set;}
    public Integer rolloutCount;
    public Integer rolloutFilledCount;
    public List<IPM_Questionnaire__c> riskQuesList;
     public IPM_Project__C ParentProject{get;set;}
    public IPM_ChangProjectDocumentStatusController()
    {
        projectId=ApexPages.currentPage().getParameters().get('Id');

        if(projectId!=null)
        {
            project=[Select Id,IPM_Parent_Project__c,IPM_IsCompleted__c,IPMProject_Span__c,IPM_Fast_Track_Project__c,IPM_Complexity__c,IPM_Stopped_Comments__c,IPM_Stopped_Date_Time__c,IPM_Project_Type__c,IPM_Project_Name__c,Is_Archieved__c,IPM_Project_Gatekeeper__c,IPM_Phase__c,IPM_GateKeeping_Model__c  from IPM_Project__c where Id=:projectId FOR UPDATE];
            if(project.IPM_Phase__c=='Ideas')            
            projectDoc=[Select Id,IPM_Project_Template__r.IPM_Template_Complexity__c,IPM_Document_Status__c,LastModifiedDate,IPM_Postponement_Date__c,IPM_Approval_Date__c,LastModifiedBy.smallPhotoURL,IPM_Approved_Comments__c,IPM_Postponed_Comments__c,LastModifiedBy.Name,IPM_GateDocuments__c,IPM_Stopped_Comments__c  from IPM_Project_Document__c where IPM_Project__c=:project.Id and IPM_GateDocuments__c='Charter'];    
            else if(project.IPM_Phase__c=='Feasibility')            
            projectDoc=[Select Id,IPM_Project_Template__r.IPM_Template_Complexity__c,IPM_Document_Status__c,LastModifiedDate,IPM_Postponement_Date__c,IPM_Approval_Date__c,LastModifiedBy.smallPhotoURL,IPM_Approved_Comments__c,IPM_Postponed_Comments__c,LastModifiedBy.Name,IPM_GateDocuments__c,IPM_Stopped_Comments__c  from IPM_Project_Document__c where IPM_Project__c=:project.Id and IPM_GateDocuments__c='Contract']; 
            else if(project.IPM_Phase__c=='Capability')            
            projectDoc=[Select Id,IPM_Project_Template__r.IPM_Template_Complexity__c,IPM_Document_Status__c,LastModifiedDate,IPM_Postponement_Date__c,IPM_Approval_Date__c,LastModifiedBy.smallPhotoURL,IPM_Approved_Comments__c,IPM_Postponed_Comments__c,LastModifiedBy.Name,IPM_GateDocuments__c,IPM_Stopped_Comments__c  from IPM_Project_Document__c where IPM_Project__c=:project.Id and IPM_GateDocuments__c='Market Ready']; 
            else if(project.IPM_Phase__c=='Market Ready')            
            projectDoc=[Select Id,IPM_Project_Template__r.IPM_Template_Complexity__c,IPM_Document_Status__c,LastModifiedDate,IPM_Postponement_Date__c,IPM_Approval_Date__c,LastModifiedBy.smallPhotoURL,IPM_Approved_Comments__c,IPM_Postponed_Comments__c,LastModifiedBy.Name,IPM_GateDocuments__c,IPM_Stopped_Comments__c  from IPM_Project_Document__c where IPM_Project__c=:project.Id and IPM_GateDocuments__c='Market Deployment'];
            projSectionList=[Select Id,IPM_Section_Type__c,IPM_Section_Sequence__c,IPM_Section_Name__c,IPM_Gate_Document_Summary__c from IPM_Project_Document_Section__c where (Not IPM_Section_Sequence__c like '8.%') and IPM_Project_Document__c=:projectDoc.Id and IPM_Section_Status__c='Not Started' and IPM_Negotiable__c=false and IPM_Section__r.IPM_Section_Type__c!='Header' and IPM_Section__r.IPM_Section_Type__c!='Sub Header'  order by IPM_Section_Sequence__c asc];
            projSectionListUpdate=[Select Id,IPM_Section_Type__c,IPM_Section_Sequence__c,IPM_Section_Name__c,IPM_Gate_Document_Summary__c from IPM_Project_Document_Section__c where IPM_Project_Document__c=:projectDoc.Id and IPM_Section_Status__c='Not Started' and IPM_Negotiable__c=false and IPM_Section__r.IPM_Section_Type__c!='Header' and IPM_Section__r.IPM_Section_Type__c!='Sub Header' order by IPM_Section_Sequence__c asc];
            //if(projectDoc.IPM_Document_Status__c=='Proposed')
            //Status='Stopped';
            //else
            Status=projectDoc.IPM_Document_Status__c;
            
            if(projSectionList.size() >0)
            {
                showSkipSections=true;
                oldSize=projSectionList.size();
            }
        }
    }
    public void updateStatus()
    {
        //update projectDoc;
        System.debug('Status'+Status);
    }
    public void submit()
    {
        showValidation=true;
        Boolean isRiskComplete=true;
        projectDoc.IPM_Document_Status__c=Status;
        List<IPM_Project__c> childProjects=new List<IPM_Project__c>();
        if(projectDoc.IPM_Document_Status__c=='Stopped')
        {
            if(projectDoc.IPM_Stopped_Comments__c !=null && projectDoc.IPM_Stopped_Comments__c !=''){
                showValidation=true;
                Date dt=date.parse(System.today().format());
                projectDoc.IPM_Stopped_Date__c=dt;
                project.IPM_Stopped_Date_Time__c=dt;
                project.Is_Archieved__c=true;
                project.IPM_Stopped_Comments__c=projectDoc.IPM_Stopped_Comments__c;
                update project;
                update projectDoc;
                update projSectionList;
            }else{
                showValidation=false;
                apexpages.addmessage(new apexpages.message(apexpages.severity.error,system.label.IPM_Stopmsg));
            }
            //return null;
        }
        else if(projectDoc.IPM_Document_Status__c=='Proposed')
        {
            showValidation=true;
            String errorMsg='';
            dueMilestones=[Select Id from IPM_Milestone__c where IPM_Due_Date__c=null and IPM_Project__c=:project.id and IPM_Phase__c=:project.IPM_Phase__c];
            IPM_Financial__c fin=new IPM_Financial__c();
            string finExternalID=project.IPM_Project_Name__c+'_CONSOLIDATED';
            if(dueMilestones.size()>0)
            {
                showValidation=false;
                errorMsg=errorMsg+'<a href="apex/ipm_TaskList?id='+ProjectId+'" target="_top">'+'Complete current milestones'+'</a><br/>';
            }
            if(project.IPMProject_Span__c=='Global')
            {
                rolloutCount=[SELECT count() FROM IPM_Project_Rollout__c WHERE IPM_Project__c=:projectId];
                rolloutFilledCount=[SELECT count() FROM IPM_Project_Rollout__c WHERE IPM_Project__c=:projectId and RecordTypeId=:Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get('Regional Rollout').getRecordTypeId() and (IPM_Regional_PL__c=null OR Target_Launch_Date__c=null)];
                fin=[Select Year_3_iTO_Global__c,Year_3_iTO_Regional__c from IPM_Financial__c where Financial_External_ID__c=:finExternalID];
            }
            else if(project.IPMProject_Span__c=='Regional')
            {
                rolloutCount=[SELECT count() FROM IPM_Project_Rollout__c WHERE Regional_Project__c=:projectId];
                rolloutFilledCount=[SELECT count() FROM IPM_Project_Rollout__c WHERE Regional_Project__c=:projectId and RecordTypeId=:Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get('Local Rollouts').getRecordTypeId() and (IPM_Regional_PL__c=null OR Target_Launch_Date__c=null)];
                fin=[Select Year_3_iTO_Regional__c,Year_3_iTO_Global__c from IPM_Financial__c where Financial_External_ID__c=:finExternalID];
            }
           
            riskQuesList=new List<IPM_Questionnaire__c >();
            riskQuesList=[Select Id,IPM_Comments__c,IPM_Project_Document_Section__c,IPM_Project__c from IPM_Questionnaire__c where IPM_Score__c>=4 and IPM_Active_RQS__c=true and IPM_Project__c=:projectId];
            if(rolloutCount<1 && project.IPMProject_Span__c=='Global')
            {
                showValidation=false;
                errorMsg=errorMsg+'<a href="/apex/ipmrolloutplansadd?id='+ProjectId+'"  target="_top" >'+'Please Create Regional Rollouts'+'</a><br/>';
                System.debug('Entering regRoll'+showValidation);
                //apexpages.addmessage(new apexpages.message(apexpages.severity.error,'Please Create Regional Rollouts'));
            }
            if(rolloutFilledCount>0 && project.IPMProject_Span__c=='Global')
            {
                 showValidation=false;
                 errorMsg=errorMsg+'<a href="/apex/ipmrolloutplans?id='+ProjectId+'"  target="_top">'+'Please Fill Regional Project leader and Target Launch Date in Regional Rollouts'+'</a><br/>';
                 //errorMsg=errorMsg+'Please Fill Regional Project leader and Target Launch Date in Regional Rollouts<br/>';
                //apexpages.addmessage(new apexpages.message(apexpages.severity.error,'Please Fill Regional Project leader and Target Launch Date in Regional Rollouts'));
            }
            if(rolloutFilledCount>0 && project.IPMProject_Span__c=='Regional')
            {
                 showValidation=false;
                 errorMsg=errorMsg+'<a href="/apex/ipmrolloutplans?id='+ProjectId+'" target="_top">'+'Please Fill Country Project leader and Target Launch Date in Local Rollouts'+'</a><br/>';
                 //errorMsg=errorMsg+'Please Fill Country Project leader and Target Launch Date in Local Rollouts<br/>';
                //apexpages.addmessage(new apexpages.message(apexpages.severity.error,'Please Fill Regional Project leader and Target Launch Date in Regional Rollouts'));
            }
           if(fin.Year_3_iTO_Global__c==0.00 && project.IPMProject_Span__c=='Global')
            {
                showValidation=false;
                errorMsg=errorMsg+'<a href="/apex/ipmFinancial?id='+ProjectId+'" target="_top">'+'Please fill calendar year Y3 Turnover financial data'+'</a><br/>';
                //errorMsg=errorMsg+'Please Fill Financial Data<br/>';
                //apexpages.addmessage(new apexpages.message(apexpages.severity.error,'Please Fill Financial Data'));
            }
            if(fin.Year_3_iTO_Regional__c==0.00 && project.IPMProject_Span__c=='Regional')
            {
                showValidation=false;
                errorMsg=errorMsg+'<a href="/apex/ipmFinancial?id='+ProjectId+'" target="_top">'+'Please fill calendar year Y3 Turnover financial data'+'</a><br/>';
                //errorMsg=errorMsg+'Please Fill Financial Data<br/>';
                //apexpages.addmessage(new apexpages.message(apexpages.severity.error,'Please Fill Financial Data'));
            }
            for(IPM_Questionnaire__c risk:riskQuesList)
            {
                if(risk.IPM_Comments__c==''||risk.IPM_Comments__c==null)
                {
                    isRiskComplete=false;
                }    
            }
            if(isRiskComplete==false)
            {
                showValidation=false;
                errorMsg=errorMsg+'<a href="/apex/ipm_gateDocument?id='+ProjectId+'" target="_top">'+'Please Fill Comments in Risk Section'+'</a><br/>';
            }       
            if(project.IPM_IsCompleted__c==false)
            {
                showValidation=false;
                errorMsg=errorMsg+'<a href="/apex/IPM_Tasklist?id='+ProjectId+'" target="_top">'+'Complete all CoParameters'+'</a><br/>';
            }
            if(showValidation!=false)
            {
                system.debug('Project Section List'+projSectionList);
                for(IPM_Project_Document_Section__c pds:projSectionList)
                {
                    if(pds.IPM_Gate_Document_Summary__c==NULL||pds.IPM_Gate_Document_Summary__c=='')
                    {
                        system.debug('Project Section List'+projSectionList);
                        showValidation=false;
                    }
                }
                System.debug('Project Section List'+showValidation);
                if(showValidation!=false)
                {
                    showValidation=true;
                    update projectDoc;
                    System.debug('projSectionList'+showValidation);
                    update projSectionList;
                    //sendEmail();
                    //return null;
                }else{
                    showValidation=false;
                    apexpages.addmessage(new apexpages.message(apexpages.severity.error,system.label.IPM_GateStatus_msg));
                }
            }
            else
            {
                showValidation=false;
                apexpages.addmessage(new apexpages.message(apexpages.severity.error,errorMsg));
            }
            System.debug('End'+showValidation);
            
        }
        else if(projectDoc.IPM_Document_Status__c=='Postponed')
        {
            
            if(projectDoc.IPM_Postponed_Comments__c !=null && projectDoc.IPM_Postponed_Comments__c !='' && projectDoc.IPM_Postponement_Date__c !=null){
                showValidation = true;
                update projectDoc;
                update projSectionList;
            }else{
                showValidation = false;
                apexpages.addmessage(new apexpages.message(apexpages.severity.error,system.label.IPM_Stopmsg));
            }
            
            //return null;
        }

        else if(projectDoc.IPM_Document_Status__c=='Approved')
        {
            Integer rolloutCount=[Select count() from IPM_Project_Rollout__c where IPM_Project__c=:project.Id];
            Date dt=date.parse(System.today().format());
            projectDoc.IPM_Approval_Date__c=dt;
            if(projectDoc.IPM_Approval_Date__c==null)
            {
                showValidation = false;
                apexpages.addmessage(new apexpages.message(apexpages.severity.error,'Please Enter Approval Date'));
            }
            /*  else if(rolloutCount<1)
    {
        showValidation = false;
        apexpages.addmessage(new apexpages.message(apexpages.severity.error,'Please Create Rollouts Before Approving Charter Gate Document'));
    }*/
            /* else if(rolloutCount<1)
            {
                if(project.IPM_Project_Type__c!='Rollout')
                {
                    showValidation = false;
                    apexpages.addmessage(new apexpages.message(apexpages.severity.error,'Please Create Rollouts Before Approving Charter Gate Document'));
                }
            }*/
            else{
                showValidation = true;
                if(project.IPM_Phase__c=='Ideas')
                project.IPM_Phase__c='Feasibility';
                else 
                {
                    childProjects=[Select Id,IPM_Phase__c,IPM_Parent_Project__c from IPM_Project__c where IPM_Parent_Project__c=:project.Id];
                    if(project.IPM_Phase__c=='Feasibility' && project.IPMProject_Span__c=='Regional')
                    {
                        for(IPM_Project__c cp:childProjects)
                        {
                            cp.IPM_Phase__c='Capability';    
                        }
                        project.IPM_Phase__c='Capability';
                    }
                    else if(project.IPM_Phase__c=='Feasibility' && project.IPMProject_Span__c=='Global')
                    {
                        project.IPM_Phase__c='Capability';    
                    }
                    else if(project.IPM_Phase__c=='Capability' && project.IPMProject_Span__c=='Regional')
                    {
                        for(IPM_Project__c cp:childProjects)
                        {
                            cp.IPM_Phase__c='Market Ready';    
                        }
                        project.IPM_Phase__c='Market Ready';
                    }
                    else if(project.IPM_Phase__c=='Capability' && project.IPMProject_Span__c=='Global')
                    {
                        project.IPM_Phase__c='Market Ready';    
                    }   
                   
                     else if(project.IPM_Phase__c=='Market Ready' && project.IPMProject_Span__c=='Local')
                    {
                        project.IPM_Phase__c='Market Deployment';    
                    }
                 if(project.IPM_Parent_Project__c!=null && project.IPMProject_Span__c=='Regional' && project.IPM_Project_Type__c=='Rollout' && project.IPM_GateKeeping_Model__c=='RCLT'){
                    ParentProject=[select id,IPM_Phase__c from IPM_Project__C where id=:project.IPM_Parent_Project__c];
                    ParentProject.IPM_Phase__c=project.IPM_Phase__c;
                    update ParentProject;
                  }
                }
                update project;
                if(childProjects.size()>0)
                update childProjects;
                projectDoc.IPM_Contract_GateKeeper_Model__c=project.IPM_GateKeeping_Model__c;
                
                update projectDoc;
                update projSectionList;
               // IPM_CreateIPMProjectTasks.createIPMTasks(new Set<Id>{project.Id});
            }
            
            
            System.debug('Number of Queries used in this Apex code so far: ' + Limits.getQueries());
        }
        
        else{
            // showValidation = true;
            update projectDoc;
            update projSectionList;
            
        }

        /*PageReference url;
if(project.Is_Archieved__c==true)
{
url=new PageReference('/apex/ipmHome');
}
else
{
url=new PageReference('/apex/ipmGetDocumentV5?id='+projectId);
}
return url;*/



    }


    public pageReference sendEmail()
    {
        System.debug('project.IPM_Project_Gatekeeper__c'+project.IPM_Project_Gatekeeper__c);
        if(project.IPM_Project_Gatekeeper__c!=null)
        {   
            String email;
            User gateKeeper=[Select Id,Email from User where Id=:project.IPM_Project_Gatekeeper__c];
            email=gateKeeper.Email;
            System.debug('Email Id'+email);
            PageReference pdf = Page.ipmGateDocumentPDF;
            // add parent id to the parameters for standardcontroller
            pdf.getParameters().put('id',project.Id);
            if(projectDoc.IPM_Document_Status__c=='Approved')
                pdf.getParameters().put('printDoc',projectDoc.IPM_GateDocuments__c);
            // the contents of the attachment from the pdf
            Blob body;

            try {

                // returns the output of the page as a PDF
                body = pdf.getContent();

                // need to pass unit test -- current bug  
            } catch (VisualforceException e) {
                body = Blob.valueOf('Some Text');
            }

            Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
            attach.setContentType('application/pdf');
            attach.setFileName(project.IPM_Project_Name__c+'_ '+ projectDoc.IPM_GateDocuments__c+ 'Gate document-'+system.today().format()+'.pdf');
            attach.setInline(false);
            attach.Body = body;

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setUseSignature(false);
            mail.setToAddresses(new String[] { email });
            mail.setSubject('Project'+project.IPM_Project_Name__c+'_ '+ projectDoc.IPM_GateDocuments__c+ 'Gate document');
            mail.setHtmlBody('Hi, Please find the attachment for Project'+project.IPM_Project_Name__c+'_ '+ projectDoc.IPM_GateDocuments__c+ 'Gate document');
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach }); 

            // Send the email
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Email with PDF sent to '+email));

            

        }
        return null;
    }  
}