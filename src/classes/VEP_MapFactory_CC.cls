/**********************************************************************
Name: VEP_MapFactory_CC
Purpose:
This Apex Class is used to select a Factory to be visited by the visitor
and visitor can view his/her visitor requests
VERSION   AUTHOR   DATE    
1.0       Leena   Jan-2016   
***********************************************************************/

public with sharing class VEP_MapFactory_CC{
    
    public Vep_Factory__c factoryDetails{get; set;}
    public List<Vep_Factory__c> factoryList{get; set;}
    public boolean showFactoryList{get; set;}  
    public boolean showDetailPage{get; set;}     
    public string factname{get; set;}
    public integer approvedCount{get; set;}
    public integer rejectedCount{get; set;}
    public String targetField { get; set; }
    public integer pendingCount{get; set;}
    public integer pendingApprovalCount{get; set;}
    public boolean showRequests{get; set;}
    public boolean showROB{get; set;}
    public String ListViewId{get; set;}
    public String reqRecordTypeId {get; set;}
    public String robRecordTypeId {get; set;}
    
    
    
    User loggedinuser = new User();
    
    
        
    public VEP_MapFactory_CC(){  
        try{
        showFactoryList= true;
        showDetailPage= false;
        loggedinuser = [select id,name,email,MobilePhone,Phone,Department from user where id=:userinfo.getuserid()];
        factoryList = new List<Vep_Factory__c>();        
        factoryList = [select id,name,Factory_Details__c,Factory_Image_Code__c,Latitude__c,Longitude__c from Vep_Factory__c limit 200];
        reqRecordTypeId = Schema.SObjectType.VEP_Visitor__c.getRecordTypeInfosByName().get('Request').getRecordTypeId();
        robRecordTypeId = Schema.SObjectType.VEP_Visitor__c.getRecordTypeInfosByName().get('Request on Behalf').getRecordTypeId();
        AggregateResult[] listCount = [select count(id) sCount, status__c status from Vep_Visitor__c where (status__c='Approved' OR Status__c='Rejected' OR Status__c='Pending Approval' OR Status__c='Pending Visit') Group By Status__c];     
        approvedCount = 0;
        rejectedCount = 0;
        pendingCount = 0;
        pendingApprovalCount = 0;
        if(listCount!=null && listCount.size()>0){
            for(AggregateResult c: listCount){
                if(c.get('status') == 'Approved'){
                    approvedCount = (Integer)c.get('sCount');
                }
                if(c.get('status') == 'Rejected'){
                    rejectedCount  = (Integer)c.get('sCount');
                }
                if(c.get('status') == 'Pending Visit'){
                    pendingCount = (Integer)c.get('sCount');
                }
                if(c.get('status') == 'Pending Approval'){
                    pendingApprovalCount = (Integer)c.get('sCount');
                }
            }
        } 
        
            showRequests = true;
            PermissionSet ps = new PermissionSet();
            ps=[SELECT Id,IsOwnedByProfile,Label FROM PermissionSet where name='VEP_VisitorManager_Permissions'];  
            List<PermissionSetAssignment> psa = new List<PermissionSetAssignment>();
            psa = [SELECT Assignee.Name, PermissionSet.Id, PermissionSet.isOwnedByProfile, PermissionSet.Profile.Name, PermissionSet.Label FROM PermissionSetAssignment WHERE PermissionSetId =: ps.id and AssigneeId=:userinfo.getuserid()];
            if(!psa.isEmpty()){
                showROB = true;
            }
            Schema.DescribeSObjectResult r = VEP_Visitor__c.sObjectType.getDescribe();
            String keyPrefix = r.getKeyPrefix();            
            ListViewId = keyPrefix;
        }
        Catch(Exception e){
            ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.Warning,e.getmessage() );
            ApexPages.addmessage(msg);
            
        }
           
  
    
    }
    public void searchFactoryList(){
        try{ 
         
            if(targetField!=null){                
                Factorylist = [select id,name,Factory_Details__c,Factory_Image_Code__c,state__c,Factory_Contact__c,Factory_Address__c,Air_Connectivity__c,Rail_Connectivity__c,Road_Connectivity__c,Latitude__c,Longitude__c  from Vep_Factory__c where id =: targetField];
            }
            if(!Factorylist.isEmpty()){
                Factorydetails = Factorylist[0];
            }             
            ShowDetailPage= true;
            ShowFactoryList= false;
        }
        catch(Exception e){
            ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.Warning,e.getmessage() );
            ApexPages.addmessage(msg);
        }
    }
    public void stateFactoryList(){
        try{
        if(factname!=null && factname!=''){
            showDetailPage= true;
            showFactoryList= false;
            factoryDetails = [select id,name,Factory_Contact__c,Factory_Address__c,Factory_Details__c,Air_Connectivity__c,Rail_Connectivity__c,Road_Connectivity__c,Factory_Image_Code__c,latitude__c,longitude__c from Vep_Factory__c where name=:factname];
            }
        else{
            showDetailPage= false;
            showFactoryList= true;
        }
        }
        catch(Exception e){
            showDetailPage= false;
            showFactoryList= true;
            ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.Warning,e.getmessage() );
            ApexPages.addmessage(msg);
        }
    }
    
    public void back2Factories(){
        showFactoryList= true;
    }
    public pagereference gotoVFORM(){
        Schema.DescribeSObjectResult r = VEP_Visitor__c.sObjectType.getDescribe();
        String keyPrefix = r.getKeyPrefix();

        PageReference redirectPage = new Pagereference('/'+keyPrefix+'/e');
        redirectPage.setRedirect(true);
        redirectPage.getParameters().put('RecordType',reqRecordTypeId);
        redirectPage.getParameters().put(label.VEP_Factory_Name_Id,Factorydetails.name);
        redirectPage.getParameters().put('Name',userinfo.getname());
        redirectPage.getParameters().put(label.VEP_Visitor_Email_Id,userinfo.getuseremail());
        if(loggedinuser.Phone!=null){
            redirectPage.getParameters().put(label.VEP_Visitor_Contact_Id,loggedinuser.Phone);
        }
        if(loggedinuser.mobilePhone!=null){
            redirectPage.getParameters().put(label.VEP_Visitor_Contact_Id,loggedinuser.mobilePhone);
        }
        redirectPage.getParameters().put(label.VEP_Visitor_Department_id,loggedinuser.department);
        redirectPage.getParameters().put('retURL','apex/VEP_VisitorMap_VF');
        return redirectPage;
    }
    public pagereference gotoVFORMROB(){
        Schema.DescribeSObjectResult r = VEP_Visitor__c.sObjectType.getDescribe();
        String keyPrefix = r.getKeyPrefix();
        
        PageReference redirectPage = new Pagereference('/'+keyPrefix+'/e');
        redirectPage.setRedirect(true);
        redirectPage.getParameters().put('RecordType',robRecordTypeId);
        redirectPage.getParameters().put(label.VEP_Factory_Name_Id,Factorydetails.name);
        redirectPage.getParameters().put('retURL','apex/VEP_VisitorMap_VF');
        return redirectPage;
    }

}