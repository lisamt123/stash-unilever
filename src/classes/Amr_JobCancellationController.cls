public with sharing class Amr_JobCancellationController {

   Public List<wrapperClass> WrapperList{get;set;}
    Public Integer noOfRecords{get; set;}
    Public Integer size{get;set;}
    
      public Amr_JobCancellationController(ApexPages.StandardController controller) {
        } 
     public ApexPages.StandardSetController setJob {
        get{
            if(setJob == null){
                size = 10 ;
                string queryString ='select id,AdManagerText__c,createdDate,Stage_of_Production_Activity__c,Job_Cancelled__c,Unilever_Project_Leader_Email__c,Project_Leader_Country__c,Category1__c,Brand_Positioning1__c,Brand_Name1__c,Project_Name__c,Lead_Creative_Agency_name__c,Allocated_Budget_euro__c,Allocated__c,Accepted__c from Amr_Job_Details__c where  Job_Cancelled__c=False';

                setJob = new ApexPages.StandardSetController(Database.getQueryLocator(queryString));
                setJob.setPageSize(size);
                noOfRecords = setJob.getResultSize();
            }
            return setJob;
        }set;
    }
    Public List<Amr_Job_Details__c> getjobdetails1(){
        List<Amr_Job_Details__c> jobList = new List<Amr_Job_Details__c>();
        for(Amr_Job_Details__c job: (List<Amr_Job_Details__c>)setJob.getRecords())
            jobList.add(job);
        return jobList;
    }
         
        // Wrapper class include Sobject and select box
         Public Class wrapperClass{
             Public Boolean SelectBox{get;set;}
             Public Amr_Job_Details__c sObjRec{get;set;}
           
             Public WrapperClass(Boolean checkbx, Amr_Job_Details__c sObjRecord){
                SelectBox = checkbx;
                sObjRec = sObjRecord;
             }
        }
           
       Public List<wrapperClass> getListWrapperMethod(){
         WrapperList = new List<WrapperClass>();
          list<Amr_Job_Details__c>  jobdetailList = getjobdetails1();
           for(Amr_Job_Details__c sObj: jobdetailList ){
                 WrapperList.add( new wrapperClass(false,sObj)) ;
             }
             return WrapperList;
        }
        
       
       // To call Cancel button on VF Page
       Public PageReference changeStatus(){
          List<Amr_Job_Details__c> selectList = New List<Amr_Job_Details__c>();
          for(wrapperclass wc:WrapperList){
              if(wc.SelectBox  == true)
                 selectList.add(wc.sObjRec); 
          }
          if(selectList.size()>0){
           List<Amr_Job_Details__c> jobdetails1=[select id ,Name,Job_Cancelled__c,Your_Email_Address__c,Unilever_Project_Leader_Email__c,Unilever_Finance_Member_Email__c,
                                              Final_Approver_Of_Material_Email__c,Agency_Contact_Account_Director_Email__c  from Amr_Job_Details__c where Id =:selectList];
           List<Amr_Job_Details__c> jobdList=new List<Amr_Job_Details__c>();
           
           for(Amr_Job_Details__c jd:jobdetails1){
               jd.Job_Cancelled__c=TRUE;
               jobdList.add(jd);           
           }
           
           update jobdList;
           
            PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
            pageRef.setRedirect(true);
            return pageRef;
            
          }
          
          else{
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select any value'));
                return null;
          } 
    }
    public Boolean hasNext {
        get {
            return setJob.getHasNext();
        }
        set;
    }
    public Boolean hasPrevious {
        get {
            return setJob.getHasPrevious();
        }
        set;
    }
  
    public Integer pageNumber {
        get {            
            return setJob.getPageNumber();
        }
        set;
    }
  
    public void first() {
        setJob.first();
    }
  
    public void last() {
        setJob.last();
    }
  
    public void previous() {
        setJob.previous();
    }
  
    public void next() {
        setJob.next();
    }           
}