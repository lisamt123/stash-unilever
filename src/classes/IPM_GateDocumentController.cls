public class IPM_GateDocumentController {

    

  public IPM_Project__c project {get; set;}
    public Boolean HeaderVal{get;set;}
    public string SubSectionID{get;set;}
    public string SubSectionName{get;set;}
    public string Sub1SectionName{get;set;}
    public IPM_Project_Document__c projectDoc {get; set;}
    public String projectId{get; set;}
    public List<IPM_Project_Document_Section__c> projSectionList {get; set;}
    public List<IPM_Project_Document_Section__c> projSubSectionList {get; set;} 
    //public list<IPM_CoreParameters__c>ProjectCoreParemeters=new list<IPM_CoreParameters__c>();
    public IPM_Project_Resource__c projectResource {get;set;}
    public boolean isCoreParameter{get;set;}
    public Map<Id,IPM_Project_Document_Section__c> docSecMap{get; set;}
    public List<IPM_Project_Document_Section__c> projDocSectionList {get; set;}
    //public IPM_CoreParameters__c coreParam{get; set;}
    public string SectionName{get;set;}
    //Type
    public Boolean IsNegotiable{get;set;}
    public Boolean Isoptional{get;set;}
    public Boolean IsTypeAll{get; set;}
    public Boolean ShowFinanceMember{get;set;}
    //Status
    public Boolean IsStatusAll{get; set;}
    public Boolean IsNotstarted{get;set;}
    public Boolean IsFilledIn{get;set;}
    //Functional role
    public Boolean IsRoleAll{get; set;}
    public Boolean IsBD{get;set;}
    public Boolean IsCMI{get;set;}
    public Boolean IsCD{get;set;}
    public Boolean IsRnD{get;set;}
    public Boolean IsSC{get;set;}
    public Boolean IsFinance{get;set;}
    public Boolean IsBB{get;set;}
    //Total filter counts
    public integer NonNegotiableCount{get;set;}
    public integer OptionalCount{get;set;}
    public integer NotstartedCount{get;set;}
    public integer FilledinCount{get;set;}
    public integer ExcludedCount{get;set;}
    public integer BDCount{get;set;}
    public integer CMICount{get;set;}
    public integer CDCount{get;set;}
    public integer RnDCount{get;set;}
    public integer FinanceCount{get;set;}
    public integer BBCount{get;set;}
    public integer SCCount{get;set;}
    //filledin percentage
    public decimal FilledinPer{get;set;}
    public Boolean IsModified{get;set;}
    public list<IPM_Project_Document_Section__c>ListtoupdateSubSection=new list<IPM_Project_Document_Section__c>();
    //Milestone due date
    public integer DaysLeft{get;set;}
    public IPM_Milestone__c mstn{get;set;}     
    public Datetime dateformat{get;set;} 
    //count header non negotiable and optional
    public integer IntroNegotiable{get;set;}
    public integer IntroOptional{get;set;}
    public integer ExterNegotiable{get;set;}
    public integer ExterOptional{get;set;}
    public integer MixNegotiable{get;set;}
    public integer MixOptional{get;set;}
    public integer DeploNegotiable{get;set;}
    public integer DeploOptional{get;set;}
    public integer TechNegotiable{get;set;}
    public integer TechOptional{get;set;}
    public integer FinNegotiable{get;set;}
    public integer FinOptional{get;set;}
    public integer ProMNegotiable{get;set;}
    public integer ProMOptional{get;set;}
    public string ComplexityType{get;set;}
    public boolean IsUpdateStatus{get;set;}
    
    public string gateDocument{get;set;}
    //get user types
    public Boolean isReadable{get;set;}
    public String userrole{get;set;}
    public String printDoc{get;set;}
    public string milestoneGateType{get;set;}
   
    public IPM_GateDocumentController()
    {
        isReadable=false;
        userrole='';
        IsUpdateStatus=false;
        ListtoupdateSubSection=new list<IPM_Project_Document_Section__c>();
        projectId=ApexPages.currentPage().getParameters().get('Id');
        printDoc=ApexPages.currentPage().getParameters().get('printDoc');
       
        //DaysLeft=(Date.today()).daysBetween(mstn.IPM_Due_Date__c);
       // datetime dt=datetime.newInstance((mstn.IPM_Due_Date__c).year(), (mstn.IPM_Due_Date__c).month(),(mstn.IPM_Due_Date__c).day());
       // dateformat=dt.format('dd-MMM-yyyy');
       // dateformat=dt;
        HeaderVal=false;
        IsModified=false;
        /*IsNegotiable=true;
        Isoptional=true;
        Notstarted='Not Started';
        FilledIn='Filled-in';
        Excluded='Excluded';
        BD='BD';
        CMI='CMI';
        CD='CD';
        RnD='R&D';
        SC='SC';
        Finance='Finance';
        BB='BB';*/
        //Total filter counts
         NonNegotiableCount=0;
         OptionalCount=0;
         NotstartedCount=0;
         FilledinCount=0;
         ExcludedCount=0;
         BDCount=0;
         CMICount=0;
         CDCount=0;
         RnDCount=0;
         FinanceCount=0;
         BBCount=0;
         SCCount=0;
         FilledinPer=0;
        if(projectId!=null)
        {
            project=[Select Id,IPM_Project_Name__c,IPMProject_Span__c,IPM_Project_Type__c,IPM_FilledIn_Percentage__c,IPM_GateKeeping_Model__c,IPM_Project_Logo__c,IPM_Phase__c,IPM_Finance_Member__c,IPM_Finance_Member__r.Name,IPM_Target_Launch_Date__c,IPM_Brand__c,IPM_Project_Gatekeeper__c,IPM_Project_Gatekeeper__r.Name,IPM_CPP__c,IPM_Project_Leader__c,IPM_Project_Leader__r.Name,IPM_Complexity__c,IPM_Category__c,IPM_Market__c,IPM_Category_Icon__c from IPM_Project__C where Id=:projectId];
            /*isCoreParameter=false;
            ProjectCoreParemeters = [Select id, IPM_IsCompleted__c from IPM_CoreParameters__c where IPM_Project__r.id =:projectId];
            if(ProjectCoreParemeters.size()>0){
                if(ProjectCoreParemeters[0].IPM_IsCompleted__c==true){
                    isCoreParameter=true;
                }
            }*/
        getIpmuserType();   
        if(printDoc==null || printDoc=='')
        {
            if(project.IPM_Phase__c=='Ideas') 
                gateDocument='Charter';
                //projectDoc=[Select Id,IPM_Project_Template__r.IPM_Template_Complexity__c,IPM_Document_Status__c,LastModifiedDate,IPM_Postponement_Date__c,IPM_Approval_Date__c,LastModifiedBy.smallPhotoURL,IPM_Approved_Comments__c,IPM_Postponed_Comments__c,LastModifiedBy.Name,IPM_GateDocuments__c from IPM_Project_Document__c where IPM_Project__c=:project.Id and IPM_GateDocuments__c='Charter'];    
            else if(project.IPM_Phase__c=='Feasibility' && project.IPM_GateKeeping_Model__c=='GCLT')            
                gateDocument='Contract';
                //projectDoc=[Select Id,IPM_Project_Template__r.IPM_Template_Complexity__c,IPM_Document_Status__c,LastModifiedDate,IPM_Postponement_Date__c,IPM_Approval_Date__c,LastModifiedBy.smallPhotoURL,IPM_Approved_Comments__c,IPM_Postponed_Comments__c,LastModifiedBy.Name,IPM_GateDocuments__c from IPM_Project_Document__c where IPM_Project__c=:project.Id and IPM_GateDocuments__c='Contract'];        
            else if(project.IPM_Phase__c=='Feasibility' && project.IPM_GateKeeping_Model__c=='RCLT' && project.IPM_Project_Type__c=='Rollout')
                gateDocument='Contract';
                //projectDoc=[Select Id,IPM_Project_Template__r.IPM_Template_Complexity__c,IPM_Document_Status__c,LastModifiedDate,IPM_Postponement_Date__c,IPM_Approval_Date__c,LastModifiedBy.smallPhotoURL,IPM_Approved_Comments__c,IPM_Postponed_Comments__c,LastModifiedBy.Name,IPM_GateDocuments__c from IPM_Project_Document__c where IPM_Project__c=:project.Id and IPM_GateDocuments__c='Contract'];        
            else if(project.IPM_Phase__c=='Feasibility' && project.IPM_GateKeeping_Model__c=='RCLT')      
                 gateDocument='Charter';
                //projectDoc=[Select Id,IPM_Project_Template__r.IPM_Template_Complexity__c,IPM_Document_Status__c,LastModifiedDate,IPM_Postponement_Date__c,IPM_Approval_Date__c,LastModifiedBy.smallPhotoURL,IPM_Approved_Comments__c,IPM_Postponed_Comments__c,LastModifiedBy.Name,IPM_GateDocuments__c from IPM_Project_Document__c where IPM_Project__c=:project.Id and IPM_GateDocuments__c='Charter'];    
            else if(project.IPM_Phase__c=='Feasibility' && project.IPM_GateKeeping_Model__c=='GCLT & RCLT')      
                gateDocument='Contract';
                //projectDoc=[Select Id,IPM_Project_Template__r.IPM_Template_Complexity__c,IPM_Document_Status__c,LastModifiedDate,IPM_Postponement_Date__c,IPM_Approval_Date__c,LastModifiedBy.smallPhotoURL,IPM_Approved_Comments__c,IPM_Postponed_Comments__c,LastModifiedBy.Name,IPM_GateDocuments__c from IPM_Project_Document__c where IPM_Project__c=:project.Id and IPM_GateDocuments__c='Contract'];                
            else if(project.IPM_Phase__c=='Capability')            
                gateDocument='Market Ready';
                //projectDoc=[Select Id,IPM_Project_Template__r.IPM_Template_Complexity__c,IPM_Document_Status__c,LastModifiedDate,IPM_Postponement_Date__c,IPM_Approval_Date__c,LastModifiedBy.smallPhotoURL,IPM_Approved_Comments__c,IPM_Postponed_Comments__c,LastModifiedBy.Name,IPM_GateDocuments__c from IPM_Project_Document__c where IPM_Project__c=:project.Id and IPM_GateDocuments__c='Market Ready'];        
            else if(project.IPM_Phase__c=='Market Ready' && (project.IPMProject_Span__c=='Regional' || project.IPMProject_Span__c=='Global'))
                gateDocument='Market Ready';
            else if(project.IPM_Phase__c=='Market Ready' && project.IPMProject_Span__c=='Local')
                gateDocument='Market Deployment';
            else if(project.IPM_Phase__c=='Market Deployment' && project.IPMProject_Span__c=='Local')
                gateDocument='Market Deployment';    
             else if(project.IPM_Phase__c=='PLE' && project.IPMProject_Span__c=='Local')
                gateDocument='Market Deployment';       
        }
        else
            gateDocument=printDoc;
        System.debug(printDoc+'printDoc'+gateDocument+'gateDocument');  
            projectDoc=[Select Id,IPM_Project_Template__r.IPM_Template_Complexity__c,IPM_Document_Status__c,LastModifiedDate,IPM_Postponement_Date__c,IPM_Approval_Date__c,LastModifiedBy.smallPhotoURL,IPM_Approved_Comments__c,IPM_Postponed_Comments__c,LastModifiedBy.Name,IPM_GateDocuments__c from IPM_Project_Document__c where IPM_Project__c=:project.Id and IPM_GateDocuments__c=:gateDocument];            
            ComplexityType=projectDoc.IPM_Project_Template__r.IPM_Template_Complexity__c;
            NonNegotiableCount=[select count() from IPM_Project_Document_Section__c where IPM_Negotiable__c=false and IPM_Project_Document__c=:projectDoc.Id and IPM_Section__r.IPM_Section_Type__c!='Header' and IPM_Section__r.IPM_Section_Type__c!='Sub Header'];
            OptionalCount=[select count() from IPM_Project_Document_Section__c where IPM_Section__r.IPM_Negotiable__c=true and IPM_Project_Document__c=:projectDoc.Id and IPM_Section__r.IPM_Section_Type__c!='Header' and IPM_Section__r.IPM_Section_Type__c!='Sub Header'];
            NotstartedCount=[select count() from IPM_Project_Document_Section__c where IPM_Section_Status__c='Not Started' and IPM_Project_Document__c=:projectDoc.Id and IPM_Section__r.IPM_Section_Type__c!='Header' and IPM_Section__r.IPM_Section_Type__c!='Sub Header'];
            FilledinCount=[select count() from IPM_Project_Document_Section__c where IPM_Section_Status__c='Filled-in' and IPM_Project_Document__c=:projectDoc.Id and IPM_Section__r.IPM_Section_Type__c!='Header' and IPM_Section__r.IPM_Section_Type__c!='Sub Header'];
            ExcludedCount=[select count() from IPM_Project_Document_Section__c where IPM_Section_Status__c='Excluded' and IPM_Project_Document__c=:projectDoc.Id and IPM_Section__r.IPM_Section_Type__c!='Header' and IPM_Section__r.IPM_Section_Type__c!='Sub Header'];
            BDCount=[select count() from IPM_Project_Document_Section__c where IPM_FunctionalRole__c='BD' and IPM_Project_Document__c=:projectDoc.Id and IPM_Section__r.IPM_Section_Type__c!='Header' and IPM_Section__r.IPM_Section_Type__c!='Sub Header'];
            CMICount=[select count() from IPM_Project_Document_Section__c where IPM_FunctionalRole__c='CMI' and IPM_Project_Document__c=:projectDoc.Id and IPM_Section__r.IPM_Section_Type__c!='Header' and IPM_Section__r.IPM_Section_Type__c!='Sub Header'];
            CDCount=[select count() from IPM_Project_Document_Section__c where IPM_FunctionalRole__c='CD' and IPM_Project_Document__c=:projectDoc.Id and IPM_Section__r.IPM_Section_Type__c!='Header' and IPM_Section__r.IPM_Section_Type__c!='Sub Header'];
            RnDCount=[select count() from IPM_Project_Document_Section__c where IPM_FunctionalRole__c='R&D' and IPM_Project_Document__c=:projectDoc.Id and IPM_Section__r.IPM_Section_Type__c!='Header' and IPM_Section__r.IPM_Section_Type__c!='Sub Header'];
            FinanceCount=[select count() from IPM_Project_Document_Section__c where IPM_FunctionalRole__c='Finance' and IPM_Project_Document__c=:projectDoc.Id and IPM_Section__r.IPM_Section_Type__c!='Header' and IPM_Section__r.IPM_Section_Type__c!='Sub Header'];
            BBCount=[select count() from IPM_Project_Document_Section__c where IPM_FunctionalRole__c='BB' and IPM_Project_Document__c=:projectDoc.Id and IPM_Section__r.IPM_Section_Type__c!='Header' and IPM_Section__r.IPM_Section_Type__c!='Sub Header'];
            SCCount=[select count() from IPM_Project_Document_Section__c where IPM_FunctionalRole__c='SC' and IPM_Project_Document__c=:projectDoc.Id and IPM_Section__r.IPM_Section_Type__c!='Header' and IPM_Section__r.IPM_Section_Type__c!='Sub Header'];
            
            //count header non negotiable and optional
            IntroNegotiable=[select count() from IPM_Project_Document_Section__c where IPM_Section__r.IPM_Negotiable__c=false and IPM_Project_Document__c=:projectDoc.Id and IPM_Section__r.IPM_Section_Type__c!='Header' and IPM_Section__r.IPM_Section_Type__c!='Sub Header' and IPM_Section__r.IPM_Section_Sequence__c like '1%'];
            IntroOptional=[select count() from IPM_Project_Document_Section__c where IPM_Section__r.IPM_Negotiable__c=true and IPM_Project_Document__c=:projectDoc.Id and IPM_Section__r.IPM_Section_Type__c!='Header' and IPM_Section__r.IPM_Section_Type__c!='Sub Header' and IPM_Section__r.IPM_Section_Sequence__c like '1%'];
            ExterNegotiable=[select count() from IPM_Project_Document_Section__c where IPM_Section__r.IPM_Negotiable__c=false and IPM_Project_Document__c=:projectDoc.Id and IPM_Section__r.IPM_Section_Type__c!='Header' and IPM_Section__r.IPM_Section_Type__c!='Sub Header' and IPM_Section__r.IPM_Section_Sequence__c like '2%'];
            ExterOptional=[select count() from IPM_Project_Document_Section__c where IPM_Section__r.IPM_Negotiable__c=true and IPM_Project_Document__c=:projectDoc.Id and IPM_Section__r.IPM_Section_Type__c!='Header' and IPM_Section__r.IPM_Section_Type__c!='Sub Header' and IPM_Section__r.IPM_Section_Sequence__c like '2%'];
            MixNegotiable=[select count() from IPM_Project_Document_Section__c where IPM_Section__r.IPM_Negotiable__c=false and IPM_Project_Document__c=:projectDoc.Id and IPM_Section__r.IPM_Section_Type__c!='Header' and IPM_Section__r.IPM_Section_Type__c!='Sub Header' and IPM_Section__r.IPM_Section_Sequence__c like '3%'];
            MixOptional=[select count() from IPM_Project_Document_Section__c where IPM_Section__r.IPM_Negotiable__c=true and IPM_Project_Document__c=:projectDoc.Id and IPM_Section__r.IPM_Section_Type__c!='Header' and IPM_Section__r.IPM_Section_Type__c!='Sub Header' and IPM_Section__r.IPM_Section_Sequence__c like '3%'];
            DeploNegotiable=[select count() from IPM_Project_Document_Section__c where IPM_Section__r.IPM_Negotiable__c=false and IPM_Project_Document__c=:projectDoc.Id and IPM_Section__r.IPM_Section_Type__c!='Header' and IPM_Section__r.IPM_Section_Type__c!='Sub Header' and IPM_Section__r.IPM_Section_Sequence__c like '4%'];
            DeploOptional=[select count() from IPM_Project_Document_Section__c where IPM_Section__r.IPM_Negotiable__c=true and IPM_Project_Document__c=:projectDoc.Id and IPM_Section__r.IPM_Section_Type__c!='Header' and IPM_Section__r.IPM_Section_Type__c!='Sub Header' and IPM_Section__r.IPM_Section_Sequence__c like '4%'];
            TechNegotiable=[select count() from IPM_Project_Document_Section__c where IPM_Section__r.IPM_Negotiable__c=false and IPM_Project_Document__c=:projectDoc.Id and IPM_Section__r.IPM_Section_Type__c!='Header' and IPM_Section__r.IPM_Section_Type__c!='Sub Header' and IPM_Section__r.IPM_Section_Sequence__c like '5%'];
            TechOptional=[select count() from IPM_Project_Document_Section__c where IPM_Section__r.IPM_Negotiable__c=true and IPM_Project_Document__c=:projectDoc.Id and IPM_Section__r.IPM_Section_Type__c!='Header' and IPM_Section__r.IPM_Section_Type__c!='Sub Header' and IPM_Section__r.IPM_Section_Sequence__c like '5%'];
            FinNegotiable=[select count() from IPM_Project_Document_Section__c where IPM_Section__r.IPM_Negotiable__c=false and IPM_Project_Document__c=:projectDoc.Id and IPM_Section__r.IPM_Section_Type__c!='Header' and IPM_Section__r.IPM_Section_Type__c!='Sub Header' and IPM_Section__r.IPM_Section_Sequence__c like '6%'];
            FinOptional=[select count() from IPM_Project_Document_Section__c where IPM_Section__r.IPM_Negotiable__c=true and IPM_Project_Document__c=:projectDoc.Id and IPM_Section__r.IPM_Section_Type__c!='Header' and IPM_Section__r.IPM_Section_Type__c!='Sub Header' and IPM_Section__r.IPM_Section_Sequence__c like '6%'];
            ProMNegotiable=[select count() from IPM_Project_Document_Section__c where IPM_Section__r.IPM_Negotiable__c=false and IPM_Project_Document__c=:projectDoc.Id and IPM_Section__r.IPM_Section_Type__c!='Header' and IPM_Section__r.IPM_Section_Type__c!='Sub Header' and IPM_Section__r.IPM_Section_Sequence__c like '7%'];
            ProMOptional=[select count() from IPM_Project_Document_Section__c where IPM_Section__r.IPM_Negotiable__c=true and IPM_Project_Document__c=:projectDoc.Id and IPM_Section__r.IPM_Section_Type__c!='Header' and IPM_Section__r.IPM_Section_Type__c!='Sub Header' and IPM_Section__r.IPM_Section_Sequence__c like '7%'];
            
            system.debug('IntroNegotiable'+ IntroNegotiable);
            integer removeoptional=[select count() from IPM_Project_Document_Section__c where IPM_Section_Status__c='Filled-in' and IPM_Project_Document__c=:projectDoc.Id and  IPM_Negotiable__c=false and IPM_Section__r.IPM_Section_Type__c!='Header' and IPM_Section__r.IPM_Section_Type__c!='Sub Header'];
            if(NonNegotiableCount!=0){
            FilledinPer=math.round((Decimal.valueof(removeoptional)/decimal.valueof(NonNegotiableCount))*100);
                
            }
         //   FilledinPer=FilledinPer.setScale(2);
            getProjectDocumentSection();
            getDocumentSectionMap();
            gateDocumentData(project.Id);
            System.debug(projSectionList+'For Section Names');
        } 
        
         
      /*  if(projectDoc.IPM_GateDocuments__c=='Charter')
            milestoneGateType='Charter Gate Approval'; 
        else if(projectDoc.IPM_GateDocuments__c=='Contract')
           milestoneGateType='Contract Gate Approval';
        else if(projectDoc.IPM_GateDocuments__c=='Market Ready')
            milestoneGateType='Market Ready Gate Approval'; 
        else if(projectDoc.IPM_GateDocuments__c=='Market Deployment')
            milestoneGateType='Market Deployment Gate Approval'; */
            mstn=new IPM_Milestone__c();
        //mstn=[select IPM_Due_Date__c from IPM_Milestone__c where IPM_Type_of_gate__c=:projectDoc.IPM_GateDocuments__c and IPM_Project__c=:projectId]; 
        System.debug('Number of Queries used in this Apex code so far: ' + Limits.getQueries());  
    } 
 // Get user type with access permission
 public void getIpmuserType(){
 list<IPM_Project_Resource__c>lstProuser=[select IPM_Role_Type__c,IPM_User__c,IPM_Project_Role_Owner__c,IPM_Project__r.IPM_Project_Leader__c from IPM_Project_Resource__c where 
                                         IPM_Project__c=:projectId and IPM_User__c=:userinfo.getuserid() limit 1];
 if(lstProuser.size()>0){
    isReadable=true;
    if(lstProuser[0].IPM_Role_Type__c=='BD'){
    userrole='BD';
       
    }else if(lstProuser[0].IPM_Role_Type__c=='CMI'){
    userrole='CMI';
    }
    else if(lstProuser[0].IPM_Role_Type__c=='CD'){
     userrole='CD';
    }
    else if(lstProuser[0].IPM_Role_Type__c=='R&D'){
     userrole='R&D';
    }
    else if(lstProuser[0].IPM_Role_Type__c=='SC'){
     userrole='SC';
    }
    else if(lstProuser[0].IPM_Role_Type__c=='Finance'){
     userrole='Finance';
    }
    else if(lstProuser[0].IPM_Role_Type__c=='BB'){
     userrole='BB';
    }
 } 
 list<IPM_Project__c>lstofuser=[select IPM_Project_Leader__c,IPM_Project_Gatekeeper__c,Deputy_Project_Leader__c from IPM_Project__c where 
                                        id=:projectId and (IPM_Project_Leader__c =:userinfo.getuserid() or IPM_Project_Gatekeeper__c=:userinfo.getuserid() 
                                         or Deputy_Project_Leader__c=:userinfo.getuserid() ) limit 1];

 if(lstofuser.size()>0){
     if(lstofuser[0].IPM_Project_Gatekeeper__c==userinfo.getuserid()){
     isReadable=true;
     }else{
      isReadable=false;
     }
     if(lstofuser[0].IPM_Project_Leader__c==userinfo.getuserid()){
     isReadable=false;
     }
     if(lstofuser[0].Deputy_Project_Leader__c==userinfo.getuserid()){
     isReadable=false;
     }
     IsUpdateStatus=true;
  
    userrole='BD'+' '+ 'CMI'+' '+'CD'+' '+'R&D'+' '+'SC'+' '+'Finance'+' '+'BB';
 }else{
 isReadable=true;
 }
 system.debug('hi......'+isReadable);
list<PermissionSetAssignment>PermissonS=[select Assignee.Name, PermissionSet.Name
                                        from PermissionSetAssignment where (PermissionSet.Name='IPM_Central_Team' or PermissionSet.Name='IPM_Business_Partners') and Assignee.id=:userinfo.getuserid()];
 if(PermissonS.size()>0){
 IsUpdateStatus=true;
 isReadable=false;
 userrole='BD'+' '+ 'CMI'+' '+'CD'+' '+'R&D'+' '+'SC'+' '+'Finance'+' '+'BB';
 }                                       
List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() and name='System Administrator' LIMIT 1];
if(PROFILE .size()>0){
IsUpdateStatus=true;
isReadable=false;
}
                                         
 }   
    public void ChangeSection() {
        IPM_Project_Document_Section__c newupdateOfDocSec=new IPM_Project_Document_Section__c ();
        newupdateOfDocSec=new IPM_Project_Document_Section__c ();
        list<IPM_Project_Document_Section__c>ListtoupdateSubSection=new list<IPM_Project_Document_Section__c>();
        ListtoupdateSubSection=new list<IPM_Project_Document_Section__c>(); 
       for(IPM_Project_Document_Section__c ProDocSec:projSectionList){
        if(ProDocSec.IPM_Section__r.IPM_Section_Name__c==SectionName){
            newupdateOfDocSec=[select id,LastModifiedDate,name,IPM_Section__r.IPM_Section_Name__c,IPM_Default_Section__c from IPM_Project_Document_Section__c where id=:ProDocSec.id and IPM_Section__r.IPM_Section_Name__c=:SectionName];
        if(newupdateOfDocSec.IPM_Default_Section__c==true){
            newupdateOfDocSec.IPM_Default_Section__c=false;
            HeaderVal=false;
        }else{
        newupdateOfDocSec.IPM_Default_Section__c=true;
        HeaderVal=true;
        }
       ListtoupdateSubSection.add(newupdateOfDocSec);
       break;
         }
       }
       system.debug('SubSectionID....'+SubSectionID);
       list<IPM_Project_Document_Section__c> IsSubdocEmpty=new list<IPM_Project_Document_Section__c> ();
       IsSubdocEmpty=[select id,IPM_Section__r.IPM_Parent_Section__c,IPM_Default_Section__c,LastModifiedDate from IPM_Project_Document_Section__c where IPM_Section__r.IPM_Parent_Section__c=:SubSectionID ] ;
   if(IsSubdocEmpty.size()>0){
   for(IPM_Project_Document_Section__c projsubDocs:IsSubdocEmpty){
        IPM_Project_Document_Section__c newupdateOfSubDocSec=new IPM_Project_Document_Section__c ();
        newupdateOfSubDocSec=new IPM_Project_Document_Section__c ();
     if(projsubDocs.IPM_Section__r.IPM_Parent_Section__c==SubSectionID){
         newupdateOfSubDocSec.IPM_Default_Section__c=HeaderVal;
         newupdateOfSubDocSec.id=projsubDocs.id;
         ListtoupdateSubSection.add(newupdateOfSubDocSec); 
       } 
     } 
   IPM_Project_Document_Section__c lstSubOfSubSec=new IPM_Project_Document_Section__c ();
   lstSubOfSubSec=[select id,IPM_Section__r.Id,LastModifiedDate  from IPM_Project_Document_Section__c where IPM_Section__r.IPM_Parent_Section__c=:SubSectionID limit 1] ;
   for(IPM_Project_Document_Section__c ProjSubOfSubSec:projSubSectionList) {
       IPM_Project_Document_Section__c newupdateSubOfSubDocSec=new IPM_Project_Document_Section__c ();
       newupdateSubOfSubDocSec=new IPM_Project_Document_Section__c ();
       if(ProjSubOfSubSec.IPM_Section__r.IPM_Parent_Section__c==lstSubOfSubSec.IPM_Section__r.Id){
       newupdateSubOfSubDocSec.IPM_Default_Section__c=HeaderVal;
       newupdateSubOfSubDocSec.id=ProjSubOfSubSec.id;
       ListtoupdateSubSection.add(newupdateSubOfSubDocSec); 
       }
      }
    }
     update ListtoupdateSubSection;
     getProjectDocumentSection();
     getDocumentSectionMap(); 
       
    }
    
public void ChangeSubSection(){
        HeaderVal=false;
       
       list<IPM_Project_Document_Section__c> IsSubdocEmpty=new list<IPM_Project_Document_Section__c> ();
       IsSubdocEmpty=[select id,IPM_Default_Section__c,LastModifiedDate  from IPM_Project_Document_Section__c where IPM_Section__r.IPM_Parent_Section__c=:SubSectionID and IPM_Negotiable__c =true] ;
       for(IPM_Project_Document_Section__c projsubDocs:projSubSectionList){
            IPM_Project_Document_Section__c newupdateOfSubDocSec=new IPM_Project_Document_Section__c ();
            newupdateOfSubDocSec=new IPM_Project_Document_Section__c ();
            newupdateOfSubDocSec=[select IPM_Section_Name__c,IPM_Default_Section__c,LastModifiedDate  from IPM_Project_Document_Section__c where  id=:projsubDocs.id];
          if(newupdateOfSubDocSec.IPM_Section_Name__c==SubSectionName ){
            if(newupdateOfSubDocSec.IPM_Default_Section__c==true){
            newupdateOfSubDocSec.IPM_Default_Section__c=false;
            HeaderVal=false;
              }else{
            newupdateOfSubDocSec.IPM_Default_Section__c=true;
            HeaderVal=true;
            }
             newupdateOfSubDocSec.id=projsubDocs.id;
             ListtoupdateSubSection.add(newupdateOfSubDocSec); 
           break;
           }
         }
        if(IsSubdocEmpty.size()>0){
            for(IPM_Project_Document_Section__c SubOfSubSection:IsSubdocEmpty){
                IPM_Project_Document_Section__c newupdateSubOfSubDocSec=new IPM_Project_Document_Section__c ();
                newupdateSubOfSubDocSec=new IPM_Project_Document_Section__c ();
                newupdateSubOfSubDocSec.IPM_Default_Section__c=HeaderVal;
                newupdateSubOfSubDocSec.id=SubOfSubSection.id;
                ListtoupdateSubSection.add(newupdateSubOfSubDocSec);
            }
        } 
        if(ListtoupdateSubSection.size()>0){
        IsModified=true;
        }
         
       /*  update  ListtoupdateSubSection;
         getProjectDocumentSection();
         getDocumentSectionMap(); */
}
//For Sub1 Section
public void ChangeSub1Section(){
      //list<IPM_Project_Document_Section__c>ListtoupdateSubSection=new list<IPM_Project_Document_Section__c>();
      for(IPM_Project_Document_Section__c projsubDocs:projSubSectionList){
            IPM_Project_Document_Section__c newupdateOfSubDocSec=new IPM_Project_Document_Section__c ();
            newupdateOfSubDocSec=[select IPM_Section_Name__c,IPM_Default_Section__c,LastModifiedDate  from IPM_Project_Document_Section__c where id=:projsubDocs.id limit 1];
          if(newupdateOfSubDocSec.IPM_Section_Name__c==Sub1SectionName){
            if(newupdateOfSubDocSec.IPM_Default_Section__c==true){
            newupdateOfSubDocSec.IPM_Default_Section__c=false;
            }else{
            newupdateOfSubDocSec.IPM_Default_Section__c=true;
            }
             ListtoupdateSubSection.add(newupdateOfSubDocSec); 
           break;
           }
        }
        if(ListtoupdateSubSection.size()>0){
        IsModified=true;
        }
        /* update  ListtoupdateSubSection;
         getProjectDocumentSection();
         getDocumentSectionMap(); */
}


    /*public void IsNegotiable(){
    if(IsNegotiable==true || Isoptional==true){
    projSectionList=[Select Id,IPM_Section__c,IPM_Negotiable__c ,IPM_Default_Section__c,IPM_Section__r.IPM_Section_Type__c,IPM_Section__r.IPM_Section_Label_Type__c,IPM_Section__r.Id,IPM_Section__r.IPM_Section_Name__c,Name,LastModifiedBy.Name,LastModifiedDate,IPM_Section__r.IPM_Parent_Section__c,IPM_Project_Document__c,IPM_Section_Status__c,IPM_Section__r.IPM_Section_Sequence__c,IPM_Gate_Document_Summary__c,IPM_Count_of_Comments__c from IPM_Project_Document_Section__c where IPM_Project_Document__c=:projectDoc.Id and IPM_Section__r.IPM_Parent_Section__c=null order by IPM_Section__r.IPM_Section_Sequence__c asc];
    Set<Id> projectSecId=new Set<Id>();
        for(Integer i=0;i<projSectionList.size();i++)
        {
            projectSecId.add(projSectionList[i].IPM_Section__r.Id);
        } 
     projSubSectionList=[Select Id,IPM_GateHistory_Date__c,IPM_GateHistory__c,IPM_Section__c,IPM_Default_Section__c,IPM_FunctionalRole__c,IPM_Section__r.IPM_Section_Type__c,
                            IPM_Section__r.IPM_Section_Sequence__c,IPM_Section__r.IPM_Section_Label_Type__c,IPM_Section__r.IPM_Section_Name__c,Name,LastModifiedBy.Name,LastModifiedDate,
                            IPM_Section__r.IPM_Parent_Section__c,IPM_Project_Document__c,IPM_Section_Status__c,
                            IPM_Gate_Document_Summary__c,IPM_Count_of_Comments__c from IPM_Project_Document_Section__c where IPM_Project_Document__c=:projectDoc.Id and IPM_Section__r.IPM_Parent_Section__c !=null and (IPM_Negotiable__c!=:IsNegotiable or IPM_Negotiable__c=:Isoptional or IPM_Section__r.IPM_Section_Type__c='Sub Header') and
                           (IPM_Section_Status__c=:Notstarted or IPM_Section_Status__c=:FilledIn or  IPM_Section_Status__c=:Excluded or IPM_Section__r.IPM_Section_Type__c='Sub Header') and 
                           (IPM_FunctionalRole__c=:BD or IPM_FunctionalRole__c=:CMI or IPM_FunctionalRole__c=:CD or IPM_FunctionalRole__c=:RnD or IPM_FunctionalRole__c=:SC or IPM_FunctionalRole__c=:Finance or IPM_FunctionalRole__c=:BB ) and IPM_Default_Section__c=true order by IPM_Section__r.IPM_Section_Sequence__c asc]; 
     }else{
     projSectionList=[Select Id,IPM_Section__c,IPM_Negotiable__c ,IPM_Default_Section__c,IPM_Section__r.IPM_Section_Type__c,IPM_Section__r.IPM_Section_Label_Type__c,IPM_Section__r.Id,IPM_Section__r.IPM_Section_Name__c,Name,LastModifiedBy.Name,LastModifiedDate,IPM_Section__r.IPM_Parent_Section__c,IPM_Project_Document__c,IPM_Section_Status__c,IPM_Section__r.IPM_Section_Sequence__c,IPM_Gate_Document_Summary__c,IPM_Count_of_Comments__c from IPM_Project_Document_Section__c where IPM_Project_Document__c=:projectDoc.Id and IPM_Section__r.IPM_Parent_Section__c=null order by IPM_Section__r.IPM_Section_Sequence__c asc];   system.debug('list of section.....'+projSectionList.size());
      Set<Id> projectSecId=new Set<Id>();
        for(Integer i=0;i<projSectionList.size();i++)
        {
            projectSecId.add(projSectionList[i].IPM_Section__r.Id);
        } 
     projSubSectionList=[Select Id,IPM_GateHistory_Date__c,IPM_GateHistory__c,IPM_Section__c,IPM_Default_Section__c,IPM_FunctionalRole__c,IPM_Section__r.IPM_Section_Type__c,IPM_Section__r.IPM_Section_Label_Type__c,IPM_Section__r.IPM_Section_Name__c,Name,LastModifiedBy.Name,LastModifiedDate,IPM_Section__r.IPM_Parent_Section__c,
                         IPM_Project_Document__c,IPM_Section_Status__c,IPM_Section__r.IPM_Section_Sequence__c,IPM_Gate_Document_Summary__c,IPM_Count_of_Comments__c 
                         from IPM_Project_Document_Section__c where IPM_Project_Document__c=:projectDoc.Id and IPM_Section__r.IPM_Parent_Section__c !=null
                         and (IPM_Section_Status__c=:Notstarted or IPM_Section_Status__c=:FilledIn or  IPM_Section_Status__c=:Excluded or IPM_Section__r.IPM_Section_Type__c='Sub Header') and 
                         (IPM_FunctionalRole__c=:BD or IPM_FunctionalRole__c=:CMI or IPM_FunctionalRole__c=:CD or IPM_FunctionalRole__c=:RnD or IPM_FunctionalRole__c=:SC or IPM_FunctionalRole__c=:Finance or IPM_FunctionalRole__c=:BB or IPM_Section__r.IPM_Section_Type__c='Sub Header')
                         and IPM_Default_Section__c=true order by IPM_Section__r.IPM_Section_Sequence__c asc]; 
    
  
    }
    
}
public void IPMStatus(){
   
     if(Notstarted=='Not Started' ||  FilledIn=='Filled-in' || Excluded=='Excluded'){
     projSectionList=[Select Id,IPM_Section__c,IPM_Negotiable__c ,IPM_Default_Section__c,IPM_Section__r.IPM_Section_Type__c,IPM_Section__r.IPM_Section_Label_Type__c,IPM_Section__r.Id,IPM_Section__r.IPM_Section_Name__c,Name,LastModifiedBy.Name,LastModifiedDate,IPM_Section__r.IPM_Parent_Section__c,IPM_Project_Document__c,IPM_Section_Status__c,IPM_Section__r.IPM_Section_Sequence__c,IPM_Gate_Document_Summary__c,IPM_Count_of_Comments__c from IPM_Project_Document_Section__c where IPM_Project_Document__c=:projectDoc.Id and IPM_Section__r.IPM_Parent_Section__c=null order by IPM_Section__r.IPM_Section_Sequence__c asc];       Set<Id> projectSecId=new Set<Id>();
        for(Integer i=0;i<projSectionList.size();i++)
        {
            projectSecId.add(projSectionList[i].IPM_Section__r.Id);
        } 
     projSubSectionList=[Select Id,IPM_GateHistory_Date__c,IPM_GateHistory__c,IPM_Section__c,IPM_Default_Section__c,IPM_FunctionalRole__c,IPM_Section__r.IPM_Section_Type__c,
                            IPM_Section__r.IPM_Section_Label_Type__c,IPM_Section__r.IPM_Section_Name__c,Name,LastModifiedBy.Name,LastModifiedDate,
                            IPM_Section__r.IPM_Parent_Section__c,IPM_Project_Document__c,IPM_Section_Status__c,IPM_Section__r.IPM_Section_Sequence__c,
                            IPM_Gate_Document_Summary__c,IPM_Count_of_Comments__c from IPM_Project_Document_Section__c where IPM_Project_Document__c=:projectDoc.Id and IPM_Section__r.IPM_Parent_Section__c !=null and (IPM_Negotiable__c!=:IsNegotiable or IPM_Negotiable__c=:Isoptional) and
                           (IPM_Section_Status__c=:Notstarted or IPM_Section_Status__c=:FilledIn or  IPM_Section_Status__c=:Excluded or IPM_Section__r.IPM_Section_Type__c='Sub Header') and 
                           (IPM_FunctionalRole__c=:BD or IPM_FunctionalRole__c=:CMI or IPM_FunctionalRole__c=:CD or IPM_FunctionalRole__c=:RnD or IPM_FunctionalRole__c=:SC or IPM_FunctionalRole__c=:Finance or IPM_FunctionalRole__c=:BB )  and IPM_Default_Section__c=true order by IPM_Section__r.IPM_Section_Sequence__c asc]; 
     }else{
      projSectionList=[Select Id,IPM_Section__c,IPM_Negotiable__c ,IPM_Default_Section__c,IPM_Section__r.IPM_Section_Type__c,IPM_Section__r.IPM_Section_Label_Type__c,IPM_Section__r.Id,IPM_Section__r.IPM_Section_Name__c,Name,LastModifiedBy.Name,LastModifiedDate,IPM_Section__r.IPM_Parent_Section__c,IPM_Project_Document__c,IPM_Section_Status__c,IPM_Section__r.IPM_Section_Sequence__c,IPM_Gate_Document_Summary__c,IPM_Count_of_Comments__c from IPM_Project_Document_Section__c where IPM_Project_Document__c=:projectDoc.Id and IPM_Section__r.IPM_Parent_Section__c=null order by IPM_Section__r.IPM_Section_Sequence__c asc];   Set<Id> projectSecId=new Set<Id>();
        for(Integer i=0;i<projSectionList.size();i++)
        {
            projectSecId.add(projSectionList[i].IPM_Section__r.Id);
        } 
     projSubSectionList=[Select Id,IPM_GateHistory_Date__c,IPM_GateHistory__c,IPM_Section__c,IPM_Default_Section__c,IPM_FunctionalRole__c,IPM_Section__r.IPM_Section_Type__c,IPM_Section__r.IPM_Section_Label_Type__c,IPM_Section__r.IPM_Section_Name__c,Name,LastModifiedBy.Name,LastModifiedDate,IPM_Section__r.IPM_Parent_Section__c,IPM_Project_Document__c,IPM_Section_Status__c,IPM_Section__r.IPM_Section_Sequence__c,IPM_Gate_Document_Summary__c,IPM_Count_of_Comments__c from IPM_Project_Document_Section__c where IPM_Project_Document__c=:projectDoc.Id and IPM_Section__r.IPM_Parent_Section__c !=null
                         and (IPM_Negotiable__c!=:IsNegotiable or IPM_Negotiable__c =:Isoptional) and
                         (IPM_FunctionalRole__c=:BD or IPM_FunctionalRole__c=:CMI or IPM_FunctionalRole__c=:CD or IPM_FunctionalRole__c=:RnD or IPM_FunctionalRole__c=:SC or IPM_FunctionalRole__c=:Finance or IPM_FunctionalRole__c=:BB) and IPM_Default_Section__c=true order by IPM_Section__r.IPM_Section_Sequence__c asc]; 
    
  
    }

}
//Fulter based on functional role
public void FunctionRole(){
     
     if(BD=='BD' || CMI=='CMI' || CD=='CD' || RnD=='R&D' || SC=='SC' || Finance=='Finance' || BB=='BB'){
    
     projSectionList=[Select Id,IPM_Section__c,IPM_Negotiable__c ,IPM_Default_Section__c,IPM_Section__r.IPM_Section_Type__c,IPM_Section__r.IPM_Section_Label_Type__c,IPM_Section__r.Id,IPM_Section__r.IPM_Section_Name__c,Name,LastModifiedBy.Name,LastModifiedDate,IPM_Section__r.IPM_Parent_Section__c,IPM_Project_Document__c,IPM_Section_Status__c,IPM_Section__r.IPM_Section_Sequence__c,IPM_Gate_Document_Summary__c,IPM_Count_of_Comments__c from IPM_Project_Document_Section__c where IPM_Project_Document__c=:projectDoc.Id and IPM_Section__r.IPM_Parent_Section__c=null order by IPM_Section__r.IPM_Section_Sequence__c asc];      system.debug('size of.....'+ projSectionList.size());
        Set<Id> projectSecId=new Set<Id>();
        for(Integer i=0;i<projSectionList.size();i++)
        {
            projectSecId.add(projSectionList[i].IPM_Section__r.Id);
        } 
     projSubSectionList=[Select Id,IPM_GateHistory_Date__c,IPM_GateHistory__c,IPM_Section__c,IPM_Default_Section__c,IPM_FunctionalRole__c,IPM_Section__r.IPM_Section_Type__c,
                            IPM_Section__r.IPM_Section_Label_Type__c,IPM_Section__r.IPM_Section_Name__c,Name,LastModifiedBy.Name,LastModifiedDate,
                            IPM_Section__r.IPM_Parent_Section__c,IPM_Project_Document__c,IPM_Section_Status__c,IPM_Section__r.IPM_Section_Sequence__c,
                            IPM_Gate_Document_Summary__c,IPM_Count_of_Comments__c from IPM_Project_Document_Section__c where IPM_Project_Document__c=:projectDoc.Id and 
                            IPM_Section__r.IPM_Parent_Section__c !=null and (IPM_Negotiable__c!=:IsNegotiable or IPM_Negotiable__c=:Isoptional) and
                           (IPM_Section_Status__c=:Notstarted or IPM_Section_Status__c=:FilledIn or  IPM_Section_Status__c=:Excluded or IPM_Section__r.IPM_Section_Type__c='Sub Header') and 
                           (IPM_FunctionalRole__c=:BD or IPM_FunctionalRole__c=:CMI or IPM_FunctionalRole__c=:CD or IPM_FunctionalRole__c=:RnD or IPM_FunctionalRole__c=:SC or IPM_FunctionalRole__c=:Finance or IPM_FunctionalRole__c=:BB ) and IPM_Default_Section__c=true order by IPM_Section__r.IPM_Section_Sequence__c asc]; 
    system.debug('size of.....'+ projSubSectionList.size());
    }else{
     projSectionList=[Select Id,IPM_Section__c,IPM_Negotiable__c ,IPM_Default_Section__c,IPM_Section__r.IPM_Section_Type__c,IPM_Section__r.IPM_Section_Label_Type__c,IPM_Section__r.Id,IPM_Section__r.IPM_Section_Name__c,Name,LastModifiedBy.Name,LastModifiedDate,IPM_Section__r.IPM_Parent_Section__c,IPM_Project_Document__c,IPM_Section_Status__c,IPM_Section__r.IPM_Section_Sequence__c,IPM_Gate_Document_Summary__c,IPM_Count_of_Comments__c from IPM_Project_Document_Section__c where IPM_Project_Document__c=:projectDoc.Id and IPM_Section__r.IPM_Parent_Section__c=null order by IPM_Section__r.IPM_Section_Sequence__c asc];        Set<Id> projectSecId=new Set<Id>();
        for(Integer i=0;i<projSectionList.size();i++)
        {
            projectSecId.add(projSectionList[i].IPM_Section__r.Id);
        }
        if(IsNegotiable==false && Isoptional==false && Notstarted=='' && Excluded=='' && FilledIn==''){
         projSubSectionList=[Select Id,IPM_GateHistory_Date__c,IPM_GateHistory__c,IPM_Section__c,IPM_Negotiable__c ,IPM_Default_Section__c,IPM_Section__r.IPM_Section_Type__c,IPM_Section__r.IPM_Section_Label_Type__c,IPM_Section__r.IPM_Section_Name__c,Name,LastModifiedBy.Name,LastModifiedDate,IPM_Section__r.IPM_Parent_Section__c,IPM_Project_Document__c,IPM_Section_Status__c,IPM_Section__r.IPM_Section_Sequence__c,IPM_Gate_Document_Summary__c,IPM_Count_of_Comments__c,IPM_FunctionalRole__c from IPM_Project_Document_Section__c where IPM_Project_Document__c=:projectDoc.Id and IPM_Section__r.IPM_Parent_Section__c !=null and IPM_Default_Section__c=true order by IPM_Section__r.IPM_Section_Sequence__c asc]; 
        }else{
       projSubSectionList=[Select Id,IPM_GateHistory_Date__c,IPM_GateHistory__c,IPM_Section__c,IPM_Default_Section__c,IPM_FunctionalRole__c,IPM_Section__r.IPM_Section_Type__c,IPM_Section__r.IPM_Section_Label_Type__c,
                             IPM_Section__r.IPM_Section_Name__c,Name,LastModifiedBy.Name,LastModifiedDate,IPM_Section__r.IPM_Parent_Section__c,IPM_Project_Document__c,
                             IPM_Section_Status__c,IPM_Section__r.IPM_Section_Sequence__c,IPM_Gate_Document_Summary__c,IPM_Count_of_Comments__c from 
                             IPM_Project_Document_Section__c where IPM_Project_Document__c=:projectDoc.Id and IPM_Section__r.IPM_Parent_Section__c !=null 
                             and (IPM_Negotiable__c!=:IsNegotiable or IPM_Negotiable__c=:Isoptional) and
                             (IPM_Section_Status__c=:Notstarted or IPM_Section_Status__c=:FilledIn or  IPM_Section_Status__c=:Excluded or IPM_Section__r.IPM_Section_Type__c='Sub Header') 
                             and IPM_Default_Section__c=true order by IPM_Section__r.IPM_Section_Sequence__c asc]; 
      }
  
    }   
}*/
    public void filterSections()
    {
        System.debug('Entering Filter Dynamic SOQl');
        projSectionList=[Select Id,IPM_Section__c,IPM_Negotiable__c ,IPM_Default_Section__c,IPM_Section__r.IPM_Section_Type__c,IPM_Section__r.IPM_Section_Label_Type__c,IPM_Section__r.Id,IPM_Section__r.IPM_Section_Name__c,Name,LastModifiedBy.Name,LastModifiedDate,IPM_Section__r.IPM_Parent_Section__c,IPM_Project_Document__c,IPM_Section_Status__c,IPM_Section__r.IPM_Section_Sequence__c,IPM_Gate_Document_Summary__c,IPM_Count_of_Comments__c from IPM_Project_Document_Section__c where IPM_Project_Document__c=:projectDoc.Id and IPM_Section__r.IPM_Parent_Section__c=null order by IPM_Section__r.IPM_Section_Sequence__c asc];
        String Query='SELECT Id,IPM_Count_of_Comments__c,IPM_Default_Section__c,IPM_FunctionalRole__c,IPM_GateHistory_Date__c,IPM_GateHistory__c,IPM_Gate_Document_Summary__c,IPM_Is_Excluded__c,IPM_Negotiable__c,IPM_PDPHistoty_Date__c,IPM_PDPHistoty__c,IPM_PDP_Document_Summary__c,IPM_Project_Document__c,IPM_Project_ID__c,IPM_Project_Section__c,IPM_Section_Help_Text_Long__c,IPM_Section_Help_Text__c,IPM_Section_Name__c,IPM_Section_Owner__c,IPM_Section_Sequence_Number__c,IPM_Section_Sequence__c,IPM_Section_Status__c,IPM_Section_Type__c,IPM_Section__c,Name,IPM_Section__r.IPM_Parent_Section__c,IPM_Section__r.IPM_Parent_Section__r.IPM_Section_Name__c,IPM_Section__r.IPM_Section_Type__c,IPM_Section__r.IPM_Section_Sequence__c,IPM_Section__r.IPM_Section_Name__c FROM IPM_Project_Document_Section__c where IPM_Project_Document__c=\'' + projectDoc.Id + '\''+'and IPM_Section__r.IPM_Parent_Section__c !=null';
        String filterValue='';
        System.debug('Query'+Query);
        Integer roleCount=0;
        String nonNegotiableCountQuery='select count() from IPM_Project_Document_Section__c where IPM_Negotiable__c=false and IPM_Project_Document__c=\'' + projectDoc.Id + '\''+' and IPM_Section__r.IPM_Section_Type__c!=\'Header\' and IPM_Section__r.IPM_Section_Type__c!=\'Sub Header\'';
        String optionalCountQuery='select count() from IPM_Project_Document_Section__c where IPM_Negotiable__c=true and IPM_Project_Document__c=\'' + projectDoc.Id + '\''+' and IPM_Section__r.IPM_Section_Type__c!=\'Header\' and IPM_Section__r.IPM_Section_Type__c!=\'Sub Header\'';
        String notStartedCountQuery='select count() from IPM_Project_Document_Section__c where IPM_Section_Status__c=\'Not Started\' and IPM_Project_Document__c=\'' + projectDoc.Id + '\''+' and IPM_Section__r.IPM_Section_Type__c!=\'Header\' and IPM_Section__r.IPM_Section_Type__c!=\'Sub Header\'';
        String filledInCountQuery='select count() from IPM_Project_Document_Section__c where IPM_Section_Status__c=\'Filled-in\' and IPM_Project_Document__c=\'' + projectDoc.Id + '\''+' and IPM_Section__r.IPM_Section_Type__c!=\'Header\' and IPM_Section__r.IPM_Section_Type__c!=\'Sub Header\'';
        String bdCountQuery='select count() from IPM_Project_Document_Section__c where IPM_FunctionalRole__c=\'BD\' and IPM_Project_Document__c=\'' + projectDoc.Id + '\''+' and IPM_Section__r.IPM_Section_Type__c!=\'Header\' and IPM_Section__r.IPM_Section_Type__c!=\'Sub Header\'';
        String cmiCountQuery='select count() from IPM_Project_Document_Section__c where IPM_FunctionalRole__c=\'CMI\' and IPM_Project_Document__c=\'' + projectDoc.Id + '\''+' and IPM_Section__r.IPM_Section_Type__c!=\'Header\' and IPM_Section__r.IPM_Section_Type__c!=\'Sub Header\'';
        String cdCountQuery='select count() from IPM_Project_Document_Section__c where IPM_FunctionalRole__c=\'CD\' and IPM_Project_Document__c=\'' + projectDoc.Id + '\''+' and IPM_Section__r.IPM_Section_Type__c!=\'Header\' and IPM_Section__r.IPM_Section_Type__c!=\'Sub Header\'';
        String rndCountQuery='select count() from IPM_Project_Document_Section__c where IPM_FunctionalRole__c=\'R&D\' and IPM_Project_Document__c=\'' + projectDoc.Id + '\''+' and IPM_Section__r.IPM_Section_Type__c!=\'Header\' and IPM_Section__r.IPM_Section_Type__c!=\'Sub Header\'';
        String financeCountQuery='select count() from IPM_Project_Document_Section__c where IPM_FunctionalRole__c=\'Finance\' and IPM_Project_Document__c=\'' + projectDoc.Id + '\''+' and IPM_Section__r.IPM_Section_Type__c!=\'Header\' and IPM_Section__r.IPM_Section_Type__c!=\'Sub Header\'';
        String bbCountQuery='select count() from IPM_Project_Document_Section__c where IPM_FunctionalRole__c=\'BB\' and IPM_Project_Document__c=\'' + projectDoc.Id + '\''+' and IPM_Section__r.IPM_Section_Type__c!=\'Header\' and IPM_Section__r.IPM_Section_Type__c!=\'Sub Header\'';
        String scCountQuery='select count() from IPM_Project_Document_Section__c where IPM_FunctionalRole__c=\'SC\' and IPM_Project_Document__c=\'' + projectDoc.Id + '\''+' and IPM_Section__r.IPM_Section_Type__c!=\'Header\' and IPM_Section__r.IPM_Section_Type__c!=\'Sub Header\'';

        /*For Type Filter*/
        if(IsTypeAll==true)
        {
            filterValue=filterValue+' and (IPM_Negotiable__c=true OR IPM_Negotiable__c=false)';
        }
        else
        {
            if(IsNegotiable==true)
            filterValue=filterValue+' and IPM_Negotiable__c=false';
            if(Isoptional==true)
            filterValue=filterValue+' and IPM_Negotiable__c=true';
        }
        /*For Status Filter*/
        if(IsStatusAll==true)
        {
            filterValue=filterValue+' and (IPM_Section_Status__c=\'Not Started\' OR IPM_Section_Status__c=\'Filled-in\')';
        }
        else
        {
            if(IsNotstarted==true)
            filterValue=filterValue+' and IPM_Section_Status__c=\'Not Started\'';
            if(IsFilledIn==true)
            filterValue=filterValue+' and IPM_Section_Status__c=\'Filled-in\'';
        }
        /*For Role Filter*/
        if(IsRoleAll==true)
        {
            filterValue=filterValue+' and (IPM_FunctionalRole__c=\'BD\' OR IPM_FunctionalRole__c=\'CMI\' OR IPM_FunctionalRole__c=\'CD\' OR IPM_FunctionalRole__c=\'R&D\' OR IPM_FunctionalRole__c=\'SC\' OR IPM_FunctionalRole__c=\'Finance\' OR IPM_FunctionalRole__c=\'BB\')';
        }
        else
        {
            if(IsBD==true)
            {
                filterValue=filterValue+' and (IPM_FunctionalRole__c=\'BD\'';
                roleCount++;
            }
            if(IsCMI==true)
            {
                if(roleCount>0)
                {
                    filterValue=filterValue+' OR IPM_FunctionalRole__c=\'CMI\'';
                }
                else
                {
                    filterValue=filterValue+' and (IPM_FunctionalRole__c=\'CMI\'';
                    roleCount++;
                }
            }
            if(IsCD==true)
            {
                if(roleCount>0)
                {
                    filterValue=filterValue+' OR IPM_FunctionalRole__c=\'CD\'';
                }
                else
                {
                    filterValue=filterValue+' and (IPM_FunctionalRole__c=\'CD\'';
                    roleCount++;
                }
            }
            if(IsRnD==true)
            {
                if(roleCount>0)
                {
                    filterValue=filterValue+' OR IPM_FunctionalRole__c=\'R&D\'';
                }
                else
                {
                    filterValue=filterValue+' and (IPM_FunctionalRole__c=\'R&D\'';
                    roleCount++;
                }
            }
            if(IsSC==true)
            {
                if(roleCount>0)
                {
                    filterValue=filterValue+' OR IPM_FunctionalRole__c=\'SC\'';
                }
                else
                {
                    filterValue=filterValue+' and (IPM_FunctionalRole__c=\'SC\'';
                    roleCount++;
                }
            }
            if(IsFinance==true)
            {
                if(roleCount>0)
                {
                    filterValue=filterValue+' OR IPM_FunctionalRole__c=\'Finance\'';
                }
                else
                {
                    filterValue=filterValue+' and (IPM_FunctionalRole__c=\'Finance\'';
                    roleCount++;
                }
            }
            if(IsBB==true)
            {
                if(roleCount>0)
                {
                    filterValue=filterValue+' OR IPM_FunctionalRole__c=\'BB\'';
                }
                else
                {
                    filterValue=filterValue+' and (IPM_FunctionalRole__c=\'BB\'';
                    roleCount++;
                }
            }
            if(roleCount>0)
            filterValue=filterValue+')';
        }
        System.debug('filterValue'+filterValue);
        Query=Query+filterValue+' order by IPM_Section__r.IPM_Section_Sequence__c asc';
        System.debug('Query'+Query);
        projSubSectionList=Database.query(Query);
        NonNegotiableCount=Database.countQuery(nonNegotiableCountQuery+filterValue);
        OptionalCount=Database.countQuery(optionalCountQuery+filterValue);
        NotstartedCount=Database.countQuery(notStartedCountQuery+filterValue);
        FilledinCount=Database.countQuery(filledInCountQuery+filterValue);
        BDCount=Database.countQuery(bdCountQuery+filterValue);
        CMICount=Database.countQuery(cmiCountQuery+filterValue);
        CDCount=Database.countQuery(cdCountQuery+filterValue);
        RnDCount=Database.countQuery(rndCountQuery+filterValue);
        FinanceCount=Database.countQuery(financeCountQuery+filterValue);
        BBCount=Database.countQuery(bbCountQuery+filterValue);
        SCCount=Database.countQuery(scCountQuery+filterValue);
    }
    public void getProjectDocumentSection(){
        projSectionList=[Select Id,IPM_Section__c,IPM_Negotiable__c ,IPM_Default_Section__c,IPM_Section__r.IPM_Section_Type__c,IPM_Section__r.IPM_Section_Label_Type__c,IPM_Section__r.Id,IPM_Section__r.IPM_Section_Name__c,Name,LastModifiedBy.Name,LastModifiedDate,IPM_Section__r.IPM_Parent_Section__c,IPM_Project_Document__c,IPM_Section_Status__c,IPM_Section__r.IPM_Section_Sequence__c,IPM_Gate_Document_Summary__c,IPM_Count_of_Comments__c from IPM_Project_Document_Section__c where IPM_Project_Document__c=:projectDoc.Id and IPM_Section__r.IPM_Parent_Section__c=null order by IPM_Section__r.IPM_Section_Sequence__c asc]; 
    } 
    public void getDocumentSectionMap()
    {
        Set<Id> projectSecId=new Set<Id>();
        for(Integer i=0;i<projSectionList.size();i++)
        {
            projectSecId.add(projSectionList[i].IPM_Section__r.Id);
        } 
        System.debug(projectSecId+'Set for projectSecId');
        /*
        docSecMap=new Map<Id,IPM_Project_Document_Section__c>();
        //  List<IPM_Project_Document_Section__c> projSubSectionList=[Select Id,IPM_Section__c,IPM_Section__r.IPM_Section_Type__c,IPM_Section__r.IPM_Parent_Section__c,IPM_Section__r.IPM_Section_Label_Type__c,IPM_Section__r.IPM_Section_Name__c,Name,LastModifiedBy.Name,LastModifiedDate,IPM_Project_Document__c,IPM_Section_Status__c,IPM_Section__r.IPM_Section_Sequence__c,IPM_Gate_Document_Summary__c from IPM_Project_Document_Section__c where IPM_Project_Document__c=:projectDoc.Id and IPM_Section__r.IPM_Parent_Section__c In:projectSecId order by IPM_Section__r.IPM_Section_Sequence__c asc]; 
        List<IPM_Project_Document_Section__c> projSubSectionList=[Select Id,IPM_Section__c,IPM_Default_Section__c,IPM_Section__r.IPM_Section_Type__c,IPM_Section__r.IPM_Parent_Section__c,IPM_Section__r.IPM_Section_Label_Type__c,IPM_Section__r.IPM_Section_Name__c,Name,LastModifiedBy.Name,LastModifiedDate,IPM_Project_Document__c,IPM_Section_Status__c,IPM_Section__r.IPM_Section_Sequence__c,IPM_Gate_Document_Summary__c,IPM_FunctionalRole__c from IPM_Project_Document_Section__c ]; 

        for(Integer i=0;i<projSubSectionList.size();i++)
        {
            docSecMap.put(projSubSectionList[i].IPM_Section__r.IPM_Parent_Section__c,projSubSectionList[i]);
        }  
        System.debug(docSecMap+'Map for Document Section'); */
        //  projSubSectionList=[Select Id,IPM_Section__c,IPM_Section__r.IPM_Section_Type__c,IPM_Section__r.IPM_Section_Label_Type__c,IPM_Section__r.IPM_Section_Name__c,Name,LastModifiedBy.Name,LastModifiedDate,IPM_Section__r.IPM_Parent_Section__c,IPM_Project_Document__c,IPM_Section_Status__c,IPM_Section__r.IPM_Section_Sequence__c,IPM_Gate_Document_Summary__c from IPM_Project_Document_Section__c where IPM_Project_Document__c=:projectDoc.Id and IPM_Section__r.IPM_Parent_Section__c In:projectSecId order by IPM_Section__r.IPM_Section_Sequence__c asc]; 
        projSubSectionList=[Select Id,IPM_GateHistory__c,IPM_GateHistory_Date__c,IPM_Section__c,IPM_Negotiable__c ,IPM_Default_Section__c,IPM_Section__r.IPM_Section_Type__c,IPM_Section__r.IPM_Section_Label_Type__c,IPM_Section__r.IPM_Section_Name__c,Name,LastModifiedBy.Name,LastModifiedDate,IPM_Section__r.IPM_Parent_Section__c,IPM_Section__r.IPM_Parent_Section__r.IPM_Section_Name__c,IPM_Project_Document__c,IPM_Section_Status__c,IPM_Section__r.IPM_Section_Sequence__c,IPM_Gate_Document_Summary__c,IPM_Count_of_Comments__c,IPM_FunctionalRole__c from IPM_Project_Document_Section__c where IPM_Project_Document__c=:projectDoc.Id and IPM_Section__r.IPM_Parent_Section__c !=null and IPM_Default_Section__c=true  order by IPM_Section__r.IPM_Section_Sequence__c asc]; 

    }
    /* Type Name: exportToPdf()
Author: 
Parameter(s)
ReturnType: PageReference 
Reason: To Create PDF for Gate Document */     
    public PageReference exportToPdf()
    { 
        PageReference url = null;
        url = Page.ipmGateDocumentPDF;
        url.setRedirect(false);
        gateDocumentData(project.Id);
        Apexpages.currentPage().getHeaders().put('content-disposition', 'attachment; filename='+project.IPM_Project_Name__c+ '_'+projectDoc.IPM_GateDocuments__c+' document-'+system.today().format()+'.pdf');
        return url;
    }
    /* Type Name: gateDocumentData()
Author: 
Parameter(s): Id
ReturnType: PageReference 
Reason: For Exporting Gate Document in PDF  */
    void gateDocumentData(Id pId)
    {
        project=[Select Id,IPM_Phase__c,IPM_Category_Icon__c,IPM_Answer_of_Q1__c,IPM_Category_Text__c,IPM_Fast_Track_Project__c,IPM_Brand_Positioning__c,IPMProject_Span__c,IPM_Project_Logo_Id__c,IPM_Target_Launch_Dates__c,IPM_Project_Name__c,IPM_Project_Logo__c,IPM_Finance_Member__c,IPM_Finance_Member__r.Name,IPM_Target_Launch_Date__c,IPM_Brand__c,IPM_Project_Gatekeeper__c,IPM_Project_Gatekeeper__r.Name,IPM_CPP__c,IPM_Project_Leader__c,IPM_Project_Leader__r.Name,IPM_Complexity__c,IPM_Category__c,IPM_Market__c from IPM_Project__C where Id=:pId];
        Integer resourceCount=[Select Count() from IPM_Project_Resource__c where IPM_Project_Role_Owner__c=True and IPM_Project__r.Id=:pId and IPM_Role_Type__c='Finance'];
        if(resourceCount>0)
        {
            projectResource=[Select IPM_Project_Role_Owner__c,IPM_User__c,IPM_User__r.Name,IPM_Role_Type__c from IPM_Project_Resource__c where IPM_Project_Role_Owner__c=True and IPM_Project__r.Id=:pId and IPM_Role_Type__c='Finance']; // to get the finance Member name
            ShowFinanceMember=true;
        }
        
        else{
            ShowFinanceMember=false;
        }
      //  coreParam=[Select Id,IPM_Category_Group__c,IPM_Market__c,IPM_Category__c from IPM_CoreParameters__c where IPM_Project__c=:pId];
        if(project.IPM_Complexity__c=='Full')
            projDocSectionList=[Select Id,IPM_Section_Name__c,IPM_Default_Section__c,IPM_Section_Sequence__c,IPM_Section__c,IPM_Section__r.IPM_Section_Type__c,IPM_Section__r.IPM_Section_Label_Type__c,IPM_Section__r.Id,IPM_Section__r.IPM_Section_Name__c,Name,LastModifiedBy.Name,LastModifiedDate,IPM_Section__r.IPM_Parent_Section__c,IPM_Project_Document__c,IPM_Section_Status__c,IPM_Section__r.IPM_Section_Sequence__c,IPM_Gate_Document_Summary__c,IPM_FunctionalRole__c from IPM_Project_Document_Section__c where IPM_Project_Document__c=:projectDoc.Id order by IPM_Section__r.IPM_Section_Sequence__c asc];
        else if(project.IPM_Complexity__c=='Lite')
            projDocSectionList=[Select Id,IPM_Section_Name__c,IPM_Default_Section__c,IPM_Section_Sequence__c,IPM_Section__c,IPM_Section__r.IPM_Section_Type__c,IPM_Section__r.IPM_Section_Label_Type__c,IPM_Section__r.Id,IPM_Section__r.IPM_Section_Name__c,Name,LastModifiedBy.Name,LastModifiedDate,IPM_Section__r.IPM_Parent_Section__c,IPM_Project_Document__c,IPM_Section_Status__c,IPM_Section__r.IPM_Section_Sequence__c,IPM_Gate_Document_Summary__c,IPM_FunctionalRole__c,IPM_Negotiable__c from IPM_Project_Document_Section__c where IPM_Project_Document__c=:projectDoc.Id  and IPM_Negotiable__c=false order by IPM_Section__r.IPM_Section_Sequence__c asc];

    } 
    /* Type Name: shareViaChatter()
Author: 
Parameter(s)
ReturnType: PageReference 
Reason: For Sharing GateDocument through Chatter  
    public PageReference shareViaChatter(){
        gateDocumentData(project.Id);
        PageReference PR=Page.ipmGateDocumentPDF;
        blob pdf = PR.getContent();
        feeditem a = new feeditem();
        //a.ContentData = pdf;
        a.Type = 'LinkPost';
        a.LinkUrl='/apex/ipmGateDocumentPDF?id='+project.Id;
        //a.ContentFileName = project.IPM_Project_Name__c+'_Charter-'+system.today().format()+'.pdf';
        a.Title=project.IPM_Project_Name__c+'_CharterGate document-'+system.today().format()+'.pdf';
        a.parentid = UserInfo.getUserId();
        try {
            insert a;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'Gate Document Charter Shared via Chatter'));
        }
        catch (Exception e)
        {
            return null;
        }
        return null;                        
        
    }  
    public PageReference printGateDocument()
    {
        PageReference url = null;
        url = Page.ipmPrintGateDocument;
        url.setRedirect(false);
        gateDocumentData(project.Id);
        Apexpages.currentPage().getHeaders().put('content-disposition', 'inline; filename='+project.IPM_Project_Name__c+'_CharterGate document-'+system.today().format()+'.pdf');
        return url;
        
    }*/ 
  //Method to save section and go back to parent page  
   public void SaveAddManage(){
         try{
          update projSubSectionList;
         }catch(Exception e){
         
         }
     }
     public void moveToPLE()
     {
         project.IPM_Phase__c='PLE';
         update project;
     }
     
     public string DummyFilter()
     {
         // do nothing
         return null;
     } 
     
     public void ResetFilters() {
     
         IsTypeAll=true;
         IsStatusAll=true;
         IsRoleAll=true;
         filterSections();
        
    }
   
}