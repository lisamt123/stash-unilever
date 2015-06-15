public without sharing class IPM_ProjectDocumentSectionController{

public IPM_Project__c project{get; set;}
public IPM_Project_Document__c projDoc{get; set;}
public IPM_Project_Document_Section__c projDocSec{get; set;}
public Id projDocSecId{get; set;}
public Id projectId{get; set;}
public List<Attachment> attachmentList{get; set;}
public string attachId{get; set;}
public list<IPM_Task__c> lsttask{get;set;}
public string SectionName{get;set;}
public string taskid{get;set;}
public string isChecked{get;set;}
public list<IPM_Project_Resource__c>ProjectResource{get;set;}
public list<IPM_Project_Document_Section__c >ProjectCharCount{get;set;}
public list<IPM_Project_Document_Section__c>projSectionList{get;set;}
public integer CharCount{get;set;}
public integer CountLimit{get;set;}
public integer remainingChar{get;set;}
public integer countOfTask{get;set;}// cont the number of task remaining
public Integer countOfCountries{get; set;}
public string IsGateSave{get;set;}
public String selectedOTIFStatus{get; set;}
public Id cId{get; set;}
public Boolean IsEditableOutC{get;set;}
public Boolean IsEditableSumm{get;set;}
public string Frole{get;set;}
public boolean isTaskeditable{get;set;}
public string RnDSection{get;set;}
public boolean IsCRRTEditable{get;set;}
public boolean isEditGateCMI{get;set;}
public boolean isAssortEdit{get;set;}
public boolean isEcodesignEdit{get;set;}
/*
public List<IPM_Project_Document_Section_Content__c> secConList{get; set;}
public Map<Id,String> conMap=new Map<Id,String>();

*/
 public IPM_ProjectDocumentSectionController() {
    RnDSection='R&D Initial Outline (Product/Pack)';
    IsCRRTEditable=false;
    isEcodesignEdit=false;
    isAssortEdit=false;
    isEditGateCMI=false;
    IsEditableOutC=false;
    IsEditableSumm=false;
    isTaskeditable=false;
    string sequence='';
    remainingChar=0;
    isChecked='';
    attachId='';
    CharCount=0;
    CountLimit=0;  
    Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=edge');
    ProjectResource=new list<IPM_Project_Resource__c>();
    projectId=ApexPages.currentPage().getParameters().get('Id');
    project=[Select Id,IPM_Phase__c,IPMProject_Span__c from IPM_Project__c where Id=:projectId];
    Frole=''; 
   
   if(project.IPM_Phase__c=='Ideas')            
        projDoc=[Select Id,IPM_Project_Template__r.IPM_Template_Complexity__c,IPM_Document_Status__c,LastModifiedDate,IPM_Postponement_Date__c,IPM_Approval_Date__c,LastModifiedBy.smallPhotoURL,IPM_Approved_Comments__c,IPM_Postponed_Comments__c,LastModifiedBy.Name,IPM_GateDocuments__c from IPM_Project_Document__c where IPM_Project__c=:project.Id and IPM_GateDocuments__c='Charter'];    
    else if(project.IPM_Phase__c=='Feasibility')            
        projDoc=[Select Id,IPM_Project_Template__r.IPM_Template_Complexity__c,IPM_Document_Status__c,LastModifiedDate,IPM_Postponement_Date__c,IPM_Approval_Date__c,LastModifiedBy.smallPhotoURL,IPM_Approved_Comments__c,IPM_Postponed_Comments__c,LastModifiedBy.Name,IPM_GateDocuments__c from IPM_Project_Document__c where IPM_Project__c=:project.Id and IPM_GateDocuments__c='Contract'];
   else if(project.IPM_Phase__c=='Capability')            
        projDoc=[Select Id,IPM_Project_Template__r.IPM_Template_Complexity__c,IPM_Document_Status__c,LastModifiedDate,IPM_Postponement_Date__c,IPM_Approval_Date__c,LastModifiedBy.smallPhotoURL,IPM_Approved_Comments__c,IPM_Postponed_Comments__c,LastModifiedBy.Name,IPM_GateDocuments__c from IPM_Project_Document__c where IPM_Project__c=:project.Id and IPM_GateDocuments__c='Market Ready'];
   else if(project.IPM_Phase__c=='Market Ready')            
        projDoc=[Select Id,IPM_Project_Template__r.IPM_Template_Complexity__c,IPM_Document_Status__c,LastModifiedDate,IPM_Postponement_Date__c,IPM_Approval_Date__c,LastModifiedBy.smallPhotoURL,IPM_Approved_Comments__c,IPM_Postponed_Comments__c,LastModifiedBy.Name,IPM_GateDocuments__c from IPM_Project_Document__c where IPM_Project__c=:project.Id and IPM_GateDocuments__c='Market Deployment']; 
    projDocSecId=ApexPages.currentPage().getParameters().get('projDocSecId');
    
    ProjectCharCount=new list<IPM_Project_Document_Section__c >();
    projSectionList=new list<IPM_Project_Document_Section__c>();
    if(project.IPMProject_Span__c=='Global')
    countOfCountries=[Select count() from IPM_Country__c where IPM_Project__c=:project.id];
    else if(project.IPMProject_Span__c=='Regional')
    countOfCountries=[Select count() from IPM_Country__c where IPM_Regional_Project__c=:project.id];
      
        ProjectCharCount=[select IPM_Section_Sequence__c from IPM_Project_Document_Section__c where Id=:projDocSecId order by IPM_Section__r.IPM_Section_Sequence__c asc];
        sequence=ProjectCharCount[0].IPM_Section_Sequence__c;
      
        if(sequence.substring(0,1)=='1'){
         CountLimit=Integer.valueof(system.label.IPM_Introduction_Char_Limit);
        }
        else if(sequence.substring(0,1)=='2'){
        CountLimit=Integer.valueof(system.label.IPM_External_Char_Limit);
        }
        else if(sequence.substring(0,1)=='3'){
        CountLimit=Integer.valueof(system.label.IPM_Mix_Char_Limit);
        }
        else if(sequence.substring(0,1)=='4'){
        CountLimit=Integer.valueof(system.label.IPM_Deployment_Char_Limit);
        }
         else if(sequence.substring(0,1)=='5'){
        CountLimit=Integer.valueof(system.label.IPM_Technical_Char_Limit);
        }
        else if(sequence.substring(0,1)=='6'){
        CountLimit=Integer.valueof(system.label.IPM_Finance_Char_Limit);
        }
        else if(sequence.substring(0,1)=='7'){
        CountLimit=Integer.valueof(system.label.IPM_ProjectManagement_Char_Limit);
        }
   
    projSectionList=[Select Id,IPM_Section__c,IPM_GateHistory_Date__c,IPM_PDPHistoty_Date__c,IPM_Gate_Document_Summary__c from IPM_Project_Document_Section__c where IPM_Project_Document__c=:projDoc.Id and IPM_Section_Sequence__c like :sequence.substring(0,1)+'%' and IPM_Section_Type__c='Text' order by IPM_Section__r.IPM_Section_Sequence__c asc]; 
    if(projSectionList.size()>0){
        for(IPM_Project_Document_Section__c ProDocCharCount:projSectionList){
            if(ProDocCharCount.IPM_Gate_Document_Summary__c!=null){
            string CountSumm=ProDocCharCount.IPM_Gate_Document_Summary__c;
            CountSumm=CountSumm.replaceAll('<[^>]+>','');
            CharCount=CharCount+ CountSumm.length();
            }
        }
    }
    remainingChar=CountLimit-CharCount;
    projDocSec=[Select Id,IPM_Section_Sequence_Number__c,IPM_Section_Sequence__c,IPM_GateHistory_Date__c,IPM_PDPHistoty_Date__c,IPM_GateHistory__c,IPM_PDPHistoty__c,IPM_Section_Name__c,IPM_Section_Help_Text_Long__c,IPM_FunctionalRole__c,IPM_Negotiable__c,IPM_Notify_Team__c,LastModifiedBy.Name,LastModifiedDate,IPM_PDP_Document_Summary__c,IPM_Gate_Document_Summary__c,IPM_Count_of_Comments__c from IPM_Project_Document_Section__c where Id=:projDocSecId];
  /*  if(projDocSec.IPM_Section_Name__c=='OTIF Status')
    secConList=[Select Id,IPM_OTIF_No_of_Status__c,IPM_OTIF_Measure__c,IPM_OTIF_Responsibility__c,IPM_OTIF_Status__c,IPM_Project_Document_Section__c,IPM_Section_type__c from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__c=:projDocSec.Id];*/
     if(projDocSec.IPM_FunctionalRole__c=='BD'){
       Frole='BD';
       }
     else if(projDocSec.IPM_FunctionalRole__c=='RnD'){
       Frole='R&D';
       }
     else if(projDocSec.IPM_FunctionalRole__c=='SC'){
       Frole='Supply Chain';
       }else
       {
          Frole=projDocSec.IPM_FunctionalRole__c;
       } 
    ProjectResource=[select IPM_Role_Type__c,IPM_send_an_email__c from IPM_Project_Resource__c where IPM_Project__c=:projectId and IPM_Role_Type__c=:Frole ];
    system.debug('Size of.....'+ProjectResource.size());
    SectionName=projDocSec.IPM_Section_Name__c;
    system.debug('Section name....'+SectionName);
    attachmentList=[Select Id,Name,ParentId,Description from Attachment where ParentId=:projDocSecId];
    getAssociatedTask();
     getIpmuserType();
    }
   /* public List<SelectOption> getOptions(){
            Schema.sObjectType sobject_type = IPM_OTIF_Status__c.getSObjectType();

            Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();

            Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
          
            List<Schema.PicklistEntry> pick_list_values = field_map.get('IPM_OTIF_Status__c').getDescribe().getPickListValues();

            List<selectOption> options = new List<selectOption>();

           for (Schema.PicklistEntry a : pick_list_values) {
                      options.add(new selectOption(a.getLabel(), a.getValue()));
          }
      return options;
      }
   public void changeOTIFStatus()
    {
            otifStatus=new IPM_OTIF_Status__c();
            otifStatus.IPM_OTIF_Status__c=selectedOTIFStatus;
            otifStatus.IPM_Project_Document_Section__c=projDocSec.Id;
            insert otifStatus;
    }  */
    
    
// Get user type with access permission
 public void getIpmuserType(){
 system.debug('function role.....'+Frole);
 list<IPM_Project_Resource__c>CountTaskSCUser=[select IPM_Role_Type__c from IPM_Project_Resource__c where 
                                         IPM_Project__c=:projectId and IPM_User__c=:userinfo.getuserid() and IPM_Role_Type__c='Supply Chain' limit 1];
 if(CountTaskSCUser.size()>0){
 isTaskeditable=true;
 }                                        
 list<IPM_Project_Resource__c>lstProuser=[select IPM_Role_Type__c,IPM_User__c,IPM_Project_Role_Owner__c,IPM_Project__r.IPM_Project_Leader__c from IPM_Project_Resource__c where 
                                         IPM_Project__c=:projectId and IPM_User__c=:userinfo.getuserid() and IPM_Role_Type__c=:Frole  limit 1];
 
 if(lstProuser.size()>0){
    
    if(lstProuser[0].IPM_Role_Type__c=='BD'){
    IsEditableOutC=true;
    IsEditableSumm=false;
    isTaskeditable=true;
    IsCRRTEditable=true;
    isEditGateCMI=true;
    }else if(lstProuser[0].IPM_Role_Type__c=='CMI' ){
    IsEditableOutC=true;
    IsEditableSumm=false;
    isTaskeditable=true;
    isEditGateCMI=true;
    }
    else if(lstProuser[0].IPM_Role_Type__c=='CD' ){
    IsEditableOutC=true;
    IsEditableSumm=false;
    isTaskeditable=true;
    isAssortEdit=true;
    }
    else if(lstProuser[0].IPM_Role_Type__c=='R&D' ){
    IsEditableOutC=true;
    IsEditableSumm=false;
    isTaskeditable=true;
    isEcodesignEdit=true;
    }
    else if(lstProuser[0].IPM_Role_Type__c=='Supply Chain' ){
    isTaskeditable=true;
    IsEditableOutC=true;
    IsEditableSumm=false;
   // IsCRRTEditable=true;
    }
    else if(lstProuser[0].IPM_Role_Type__c=='Finance' ){
    IsEditableOutC=true;
    IsEditableSumm=true;
    }
    else if(lstProuser[0].IPM_Role_Type__c=='BB'){
    IsEditableOutC=true;
    IsEditableSumm=true;
    isTaskeditable=true;
    }
 } else{
  IsEditableOutC=false;
  IsEditableSumm=false;
 }
integer CountProuser=[select count() from IPM_Project_Resource__c where 
                                         IPM_Project__c=:projectId and IPM_Role_Type__c=:Frole and IPM_Project_Role_Owner__c=true limit 1];
 list<IPM_Project__c>lstofuser=[select IPM_Project_Leader__c,IPM_Project_Gatekeeper__c,Deputy_Project_Leader__c,IPM_Technical_Project_Leader__c from IPM_Project__c where 
                                         id=:projectId limit 1];
 if(lstofuser.size()>0){
    if(lstofuser[0].IPM_Project_Leader__c==userinfo.getuserid()){
        if(CountProuser==0){
        IsEditableOutC=true;
        isEditGateCMI=true;
        IsCRRTEditable=true;
        isAssortEdit=true;
        isEcodesignEdit=true;
        }else{
        IsEditableOutC=false;
        }
        
     isTaskeditable=true;   
     IsEditableSumm=true;
    }else if(lstofuser[0].IPM_Project_Gatekeeper__c==userinfo.getuserid()){
    IsEditableOutC=false;
    IsEditableSumm=false;
    }else if(lstofuser[0].Deputy_Project_Leader__c==userinfo.getuserid()){
    IsEditableOutC=false;
    IsEditableSumm=true;
    isTaskeditable=true;
    IsCRRTEditable=true;
    }else if(lstofuser[0].IPM_Technical_Project_Leader__c==userinfo.getuserid()){
    IsEditableOutC=false;
    IsEditableSumm=true;
    isTaskeditable=true;
    }
   }
list<PermissionSetAssignment>PermissonS=[select Assignee.Name, PermissionSet.Name
                                        from PermissionSetAssignment where (PermissionSet.Name='IPM_Central_Team' or PermissionSet.Name='IPM_Business_Partners') and Assignee.id=:userinfo.getuserid()];
 if(PermissonS.size()>0){
  IsEditableOutC=true;
  IsEditableSumm=true;
  isTaskeditable=true;
  IsCRRTEditable=true; 
  isEditGateCMI=true;
 }                                       
system.debug('isEditGateCMI...'+isEditGateCMI);
}   
       
    public void save()
    {
        boolean showmsg=true;
        integer SummaryCount=0;
        string summm='';
        if(projDocSec.IPM_Gate_Document_Summary__c!=null){
        SummaryCount=projDocSec.IPM_Gate_Document_Summary__c.length();
        summm=projDocSec.IPM_Gate_Document_Summary__c;
        summm=summm.replaceAll('<[^>]+>','');
        }
        system.debug('charCount.......'+SummaryCount+'.......'+summm);
        
        //if(CharCount+SummaryCount<CountLimit){
        list<IPM_Project_Resource__c> lstupdatedResource=new list<IPM_Project_Resource__c>();
        lstupdatedResource=new list<IPM_Project_Resource__c>();
        
        String IPMRQSGateType;
            
        if(project.IPM_Phase__c=='Ideas'){
                IPMRQSGateType = 'Charter';
        }
        if(project.IPM_Phase__c=='Feasibility'){
                IPMRQSGateType = 'Contract';
        }
        if(project.IPM_Phase__c=='Capability'){
                IPMRQSGateType = 'Market Ready';
        }
        if(project.IPM_Phase__c=='Market Ready'){
                IPMRQSGateType = 'Market Deployment';
        }
            
        List<IPM_Questionnaire__c> ipmQuestionaires   = [select id,IPM_GK_Answers__c,IPM_Project__c,IPM_Section_Sequence_Number__c,IPM_RQS_Gate_Type__c  from IPM_Questionnaire__c where IPM_Project_Document_Section__c=: projDocSec.Id];

        if(ipmQuestionaires.size()>0)
        {
            for(IPM_Questionnaire__c ipmQuestionaire:ipmQuestionaires)
            {
                if(ipmQuestionaire.IPM_GK_Answers__c<> '--None--' && ipmQuestionaire.IPM_GK_Answers__c<> null && ipmQuestionaire.IPM_GK_Answers__c<> '')
                {
                    if(projDocSec.IPM_Gate_Document_Summary__c!=null && projDocSec.IPM_Gate_Document_Summary__c!='' && summm.length()>=15 && projDocSec.IPM_Negotiable__c==false)
                    {
                        projDocSec.IPM_Section_Status__c='Filled-in';
                        showmsg=false;
             
                    }
                    
                    else if(projDocSec.IPM_Negotiable__c==True){
                        projDocSec.IPM_Section_Status__c='Filled-in';
                        showmsg=false;
                        
                        
                    }

                    
                }
            }   
                
        }
        
        
        List<IPM_Project_Document__c> ipmProjectDocument = [select id,IPM_GateDocuments__c from IPM_Project_Document__c where IPM_Project__c=: project.Id and IPM_GateDocuments__c=:IPMRQSGateType];
        Set<id> projectDocumentId= new Set<id>();
        for(IPM_Project_Document__c projectDocument:ipmProjectDocument)
        {
                System.debug('--------------------------------0>');
                projectDocumentId.add(projectDocument.Id);
        }
        
        List<IPM_Project_Document_Section__c> ipmProjectDocumentSectionOTIF =  [select id from IPM_Project_Document_Section__c where IPM_Section_Name__c='OTIF Status' and IPM_Project_Document__c in :projectDocumentId];   
        Set<id> otifSectionId= new Set<id>();
        
        System.debug('--------------------------------1>');
        for(IPM_Project_Document_Section__c otifSection:ipmProjectDocumentSectionOTIF)
        {
                otifSectionId.add(otifSection.Id);
                        System.debug('--------------------------------2>');

        }
        
        Boolean status= true;
        List<IPM_Project_Document_Section_Content__c> ipmProjectDocumentSectionContents   = [select id,IPM_OTIF_Status__c,IPM_Section_Number__c,IPM_Project_Document_Section__c from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__c in : otifSectionId];        
        
        System.debug('preoject section id-------'+'***********'+projDocSec.Id);
        System.debug(ipmProjectDocumentSectionOTIF.size()+'***********'+ipmProjectDocumentSectionOTIF);
        
        if(ipmProjectDocumentSectionOTIF.size()>0)
        {           System.debug('--------------------------------3>');

            for(IPM_Project_Document_Section_Content__c ipmProjectDocumentSectionContent:ipmProjectDocumentSectionContents)
            {   
                    System.debug(ipmProjectDocumentSectionContent.IPM_Section_Number__c+ '--------------------------------4>' +  projDocSec.IPM_Section_Sequence_Number__c);

                if(ipmProjectDocumentSectionContent.IPM_Section_Number__c == projDocSec.IPM_Section_Sequence_Number__c)
                {
                    System.debug('--------------------------------5>');
                    status = false;
                    if(ipmProjectDocumentSectionContent.IPM_OTIF_Status__c<> '--None--' && ipmProjectDocumentSectionContent.IPM_OTIF_Status__c<> null && ipmProjectDocumentSectionContent.IPM_OTIF_Status__c<> '')
                    {           System.debug('--------------------------------6>');

                        if(projDocSec.IPM_Gate_Document_Summary__c!=null && projDocSec.IPM_Gate_Document_Summary__c!='' && summm.length()>=15 && projDocSec.IPM_Negotiable__c==false)
                        {
                                    System.debug('--------------------------------7>');

                            projDocSec.IPM_Section_Status__c='Filled-in';
                            showmsg=false;
                 
                        }
                        
                        else if(projDocSec.IPM_Negotiable__c==True){
                                    System.debug('--------------------------------8>');

                            projDocSec.IPM_Section_Status__c='Filled-in';
                            showmsg=false;
                            
                            
                        }
                        
                        
                    }
                } 
                


                
            }   
                
        }
        
        if (ipmQuestionaires.size()==0 && status ==true)
                {
                            
                            
                            if(projDocSec.IPM_Gate_Document_Summary__c!=null && projDocSec.IPM_Gate_Document_Summary__c!='' && summm.length()>=15 && projDocSec.IPM_Negotiable__c==false)
                            {

                                projDocSec.IPM_Section_Status__c='Filled-in';
                                showmsg=false;
                     
                            }
                            
                            else if(projDocSec.IPM_Negotiable__c==True){
                                

                                projDocSec.IPM_Section_Status__c='Filled-in';
                                showmsg=false;
                                
                                
                            }
                            

                            
                            
                }
        
        
        
        
        
        if(IsGateSave=='Gate'){
        DateTime dT = System.now();
        Date myDate = dT.date();//date.newinstance(dT.day(),dT.month(),dT.year());
        projDocSec.IPM_GateHistory_Date__c=myDate;
        projDocSec.IPM_GateHistory__c=Userinfo.getname();
        }else {
        DateTime dT = System.now();
        Date myDate = dT.date();//date.newinstance(dT.day(),dT.month(),dT.year());
        projDocSec.IPM_PDPHistoty_Date__c=myDate;
        projDocSec.IPM_PDPHistoty__c=Userinfo.getname() ;
        showmsg=false;
        }
        update projDocSec;
        
        if(projDoc.IPM_Document_Status__c=='Not Started')
            projDoc.IPM_Document_Status__c='In Progress';
        update projDoc;
        //Update Project Document Section Content
       // updateOTIFStatus();
    if(isChecked !=''){
      if(ProjectResource.size()>0){
          for(IPM_Project_Resource__c ProRes:ProjectResource){
              IPM_Project_Resource__c updatedResource=new IPM_Project_Resource__c();
              updatedResource.id=ProRes.id;
              updatedResource.IPM_send_an_email__c=true;
              lstupdatedResource.add(updatedResource);
          }
       update lstupdatedResource;
       }
      }
      //if(showmsg==true){
     //    apexpages.addmessage(new apexpages.message(apexpages.severity.info,system.label.IPM_Not_applicable));
    //  }
    // }else{ Commented because of a weired Error DEF 1411
      //   apexpages.addmessage(new apexpages.message(apexpages.severity.info,'Your character count has been excceded'));
     //}     
     
     /* For Storing Filled-In Percentage Calculation in Project Object */
    Integer NonNegotiableCount=[select count() from IPM_Project_Document_Section__c where IPM_Negotiable__c=false and IPM_Project_Document__c=:projDoc.Id and IPM_Section__r.IPM_Section_Type__c!='Header' and IPM_Section__r.IPM_Section_Type__c!='Sub Header'];

Integer removeoptional=[select count() from IPM_Project_Document_Section__c where IPM_Section_Status__c='Filled-in' and IPM_Project_Document__c=:projDoc.Id and  IPM_Negotiable__c=false and IPM_Section__r.IPM_Section_Type__c!='Header' and IPM_Section__r.IPM_Section_Type__c!='Sub Header'];
            if(NonNegotiableCount!=0){
            Decimal FilledinPer=math.round((Decimal.valueof(removeoptional)/decimal.valueof(NonNegotiableCount))*100);
            project.IPM_FilledIn_Percentage__c=FilledinPer;
            update project;
            }
            
       //projDocSec.IPM_Notify_Team__c = false;     
            
    }
    
    public PageReference cancel()
    {
        PageReference url;
        url=new PageReference('/apex/ipmProjectDocumentSectionEditorV1?Id='+projectId+'&projDocSecId='+projDocSecId);
        url.setRedirect(true);
        return url;
    }
    
    public void delet()
    {
        Attachment a=new Attachment();
        system.debug('attached id.....'+ attachId);
        a=[Select Id from Attachment where Id=:attachId];
        delete a;
        attachmentList=[Select Id,Name,ParentId,Description from Attachment where ParentId=:projDocSecId];
    }
//task associated with section
public void getAssociatedTask(){
   lsttask=new list<IPM_Task__c >();
   lsttask=[SELECT IPM_Task_Name__c, IPM_Phase__c,IPM_Due_Date1__c, IPM_Project_Document_Section__r.IPM_Section_Name__c,
                                            IPM_Project_Document_Section__r.IPM_Section_Sequence__c, IPM_Assignee__r.Name, IPM_Project__c,
                                             IPM_Completed__c,IPM_Task_Type__c,IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_GateDocuments__c FROM IPM_Task__c 
                                            WHERE IPM_Project__c=:projectId and IPM_Project_Document_Section__r.IPM_Section_Name__c=:SectionName and IPM_Function__c=:Frole order by IPM_Completed__c desc ];
    countOfTask =  [SELECT count() FROM IPM_Task__c WHERE IPM_Project__c=:projectId and IPM_Project_Document_Section__r.IPM_Section_Name__c=:SectionName and IPM_Project_Document_Section__r.IPM_Negotiable__c=true];                                      
   }
public void TaskDelete(){
    getAssociatedTask();
   IPM_Task__c tasktodelete=new IPM_Task__c();
   tasktodelete=[select id from IPM_Task__c where id=:taskid];
   delete tasktodelete;
   getAssociatedTask();
} 
public void changeType()
{
update projDocSec;
  /* For Storing Filled-In Percentage Calculation in Project Object */
    Integer NonNegotiableCount=[select count() from IPM_Project_Document_Section__c where IPM_Negotiable__c=false and IPM_Project_Document__c=:projDoc.Id and IPM_Section__r.IPM_Section_Type__c!='Header' and IPM_Section__r.IPM_Section_Type__c!='Sub Header'];

Integer removeoptional=[select count() from IPM_Project_Document_Section__c where IPM_Section_Status__c='Filled-in' and IPM_Project_Document__c=:projDoc.Id and  IPM_Negotiable__c=false and IPM_Section__r.IPM_Section_Type__c!='Header' and IPM_Section__r.IPM_Section_Type__c!='Sub Header'];
            if(NonNegotiableCount!=0){
            Decimal FilledinPer=math.round((Decimal.valueof(removeoptional)/decimal.valueof(NonNegotiableCount))*100);
            project.IPM_FilledIn_Percentage__c=FilledinPer;
            System.debug(NonNegotiableCount+''+removeoptional+''+FilledinPer);
            update project;
            }
}
//Update task
Public void UpdateTask(){
update lsttask;
}
public void IsNotify(){
}  
/*public pageReference updateOTIFStatus()
{

//System.debug('selectedOTIFStatus'+selectedOTIFStatus);
//conMap.put(cId,selectedOTIFStatus);
//System.debug('Content Map'+conMap);

//selectedOTIFStatus=System.currentPagereference().getParameters().get('status');
//System.debug(selectedOTIFStatus+'selectedOTIFStatus');
System.debug('Outside if '+secConList);
if(projDocSec.IPM_Section_Name__c=='OTIF Status')
{
 
 update secConList;
     secConList=[Select Id,IPM_OTIF_No_of_Status__c,IPM_OTIF_Measure__c,IPM_OTIF_Responsibility__c,IPM_OTIF_Status__c,IPM_Project_Document_Section__c,IPM_Section_type__c from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__c=:projDocSec.Id];
System.debug('inside if '+secConList);
 
}
return null;     
}*/
}