public with sharing class Amr_RAPJobPortfolioHelper_CC{

/***********************************************************************************************************************************
Purpose: Method to remove duplicate records from priority jobs.
Parameters: list of priority jobs.
Returns: 

************************************************************************************************************************************/     
        
           public void removeDuplicatePriority(List<Amr_Job_Allocation__c> lstPriorityJobsToShow,list<Amr_Job_Allocation__c>priorityJobsToShow){
            try{
             List<Amr_Job_Allocation__c> lstRemoveDuplicate = new  List<Amr_Job_Allocation__c>();
             lstRemoveDuplicate = lstPriorityJobsToShow;
            // lstPriorityJobsToShow = new  List<Amr_Job_Allocation__c>();
             Set<String>jobAllocIds = new Set<String>();
             for(Amr_Job_Allocation__c job:lstRemoveDuplicate){
              
                if(!jobAllocIds.contains(job.AM_Job_Detail__r.Id )){
                    jobAllocIds.add(job.AM_Job_Detail__r.Id);
                   // lstPriorityJobsToShow.add(job);
                    priorityJobsToShow.add(job);
                }
             
             }
          }catch(Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
          }  
        }
/***********************************************************************************************************************************
Purpose: Method to remove duplicate records from pending jobs.
Parameters: list of pending jobs.
Returns: 

************************************************************************************************************************************/        
        
         public void removeDuplicatePending(List<Amr_Job_Allocation__c> lstPendingJobsToShow,list<Amr_Job_Allocation__c>pendingJobsToShow){
            try{
             List<Amr_Job_Allocation__c> lstRemoveDuplicate = new  List<Amr_Job_Allocation__c>();
             lstRemoveDuplicate = lstPendingJobsToShow;
             //lstPriorityJobsToShow = new  List<Amr_Job_Allocation__c>();
             Set<String>jobAllocIds = new Set<String>();
              for(Amr_Job_Allocation__c job:lstRemoveDuplicate){
                 if(!jobAllocIds.contains(job.AM_Job_Detail__r.Id )){
                    jobAllocIds.add(job.AM_Job_Detail__r.Id);
                    pendingJobsToShow.add(job);
                }
               
             }
           }catch(Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
          } 
        }
/***********************************************************************************************************************************
Purpose: Method to remove duplicate records from dormant jobs.
Parameters: list of dormant jobs.
Returns: 

************************************************************************************************************************************/        
        
         public void removeDuplicateDormant(List<Amr_Job_Allocation__c> lstDormantJobsToShow,list<Amr_Job_Allocation__c>dormantJobsToShow){
            try{
             List<Amr_Job_Allocation__c> lstRemoveDuplicate = new  List<Amr_Job_Allocation__c>();
             lstRemoveDuplicate = lstDormantJobsToShow;
            // lstPriorityJobsToShow = new  List<Amr_Job_Allocation__c>();
             Set<String>jobAllocIds = new Set<String>();
             
              for(Amr_Job_Allocation__c job:lstRemoveDuplicate){
                if(!jobAllocIds.contains(job.AM_Job_Detail__r.Id )){
                    jobAllocIds.add(job.AM_Job_Detail__r.Id);
                 //   lstPriorityJobsToShow.add(job);
                    dormantJobsToShow.add(job);
                }
                            }
            }catch(Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
          }
        }
/***********************************************************************************************************************************
Purpose: Method to remove duplicate records from live jobs.
Parameters: list of live jobs.
Returns: 

************************************************************************************************************************************/        
         public void removeDuplicateLive(List<Amr_Job_Allocation__c> lstLiveJobsToShow,list<Amr_Job_Allocation__c>liveJobsToShow){
            try{
             List<Amr_Job_Allocation__c> lstRemoveDuplicate = new  List<Amr_Job_Allocation__c>();
             lstRemoveDuplicate = lstLiveJobsToShow;
           //  lstPriorityJobsToShow = new  List<Amr_Job_Allocation__c>();
             Set<String>jobAllocIds = new Set<String>();
              for(Amr_Job_Allocation__c job:lstRemoveDuplicate){
                if(!jobAllocIds.contains(job.AM_Job_Detail__r.Id )){
                    jobAllocIds.add(job.AM_Job_Detail__r.Id);
              //      lstPriorityJobsToShow.add(job);
                    liveJobsToShow.add(job);
                }
              
             }
            }catch(Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
          }
        }
}