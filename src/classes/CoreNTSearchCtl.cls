/*
*       Class Name:CoreNTSearchCtl
*       Author:Mindtree
*       Date:09 May 2014
*       Description : This class is added to implement the Search functionality
*                     of the SearchPage
*/

public with sharing class CoreNTSearchCtl {
 
public String searchInput {get; set;}
public String searchCriteria {get; set;}
public List<String> searchObjects {get; set;}
List<SelectOption> options {get; set;}
/*
Variables that hold the search Results
*/
public List<CORE_NT_Project__c> lstProjects {get; set;}
public List<CORE_NT_Summary_Task__c> lstSummaryTasks {get; set;}
public List<CORE_NT_Task__c> lstTasks {get; set;}
public List<CORE_NT_Task__c> lstMilestones {get; set;}
public boolean showProjectSection {get; set;}
public boolean showSummTaskSection {get; set;}
public boolean showTaskSection {get; set;}  
public boolean showMilestoneSection {get; set;}     
        public CoreNTSearchCtl(){    
                searchObjects = new List<String>();
                showProjectSection = false ;
                showSummTaskSection = false;
                showTaskSection =  false;
                showMilestoneSection = false;
        }
            public List<SelectOption> getItems() {
                options = new List<SelectOption>();
                options.add(new SelectOption('Project','Project'));
                options.add(new SelectOption('Summary Task','Summary Task'));
                options.add(new SelectOption('Task','Task'));
                options.add(new SelectOption('Milestone','Milestone'));

        return options;
        }
/*
 *      The following method facilitates to fetch the search results
 *      depending on the searchInput
 *      @param None
 *      @return PageReference
    
*/
        public PageReference searchAction() {
                   lstProjects = new List<CORE_NT_Project__c>();
                   lstTasks = new List<CORE_NT_Task__c>();
                   lstSummaryTasks = new List<CORE_NT_Summary_Task__c>();
                    showProjectSection = false ;
                    showSummTaskSection = false;
                    showTaskSection =  false;
                    showMilestoneSection = false;
                   //searchCriteria = '%'+searchInput+'%'; 
                   if(searchInput!=null && searchInput!='' && searchInput.length() > 1){
                   searchCriteria = searchInput+'*'; 
                   String query = 'FIND {'+searchCriteria+'} IN ALL FIELDS RETURNING '+
                                                         'CORE_NT_Project__c(Id,Name,Owner.Name,Description__c)'+
                                                     ',CORE_NT_Task__c(Id,Name,Project_Milestone__r.Name,Assigned_To__r.Name, Description__c WHERE Milestone__c = false )'+
                                                     ',CORE_NT_Summary_Task__c(Id,Name,Owner.Name,Description__c)';
                   System.debug('searchObjects.size>>>'+searchObjects.size());
                    
                   List<List<SObject>> searchList = search.query(query );
                   lstProjects = (List<CORE_NT_Project__c>)searchList[0];
                   lstTasks = (List<CORE_NT_Task__c>)searchList[1];
                   lstSummaryTasks = (List<CORE_NT_Summary_Task__c>)searchList[2];
                  // System.debug('searchList[0]>>>'+searchList[0]);
                  // System.debug('searchList[1]>>>'+searchList[1]);
                  // System.debug('searchList[2]>>>'+searchList[2]);
                  // System.debug('searchList>>>'+searchList.size()+'   lstProjects.size()  '+lstProjects.size());
                   
                   String queryForMilestones = 'FIND {'+searchCriteria+'} IN ALL FIELDS RETURNING '+                                                         
                                                     'CORE_NT_Task__c(Id,Name,Project_Milestone__r.Name,Assigned_To__r.Name,Description__c WHERE Milestone__c = true )';
                                                      
	                List<List<SObject>> milestoneList = search.query(queryForMilestones);
	                lstMilestones = milestoneList[0];   
	               //System.debug('lstMilestones>>'+lstMilestones);
                   
                   
                   if(searchObjects.size() == 0){
                    //System.debug('searchObjects.size>>>'+searchObjects.size()); 
                    if(lstProjects.size()==0 && lstSummaryTasks.size() ==0 && lstTasks.size()==0 && lstMilestones.size() == 0){
                                Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.WARNING,'No Results found.'));
                        }
                    else{
                   		showProjectSection = true;
	                    showSummTaskSection = true;
	                    showTaskSection =  true;
	                    showMilestoneSection = true;
	                    }
                    //Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.WARNING,'Please select objects to search'));
                   
                   }
                   
                   if(searchObjects.size()!=0){
                        for(Integer i=0 ; i<searchObjects.size(); i++){
                               // System.debug('searchObjects.get(i)>>'+searchObjects.get(i));
                        if(searchObjects.get(i).equals('Project') && lstProjects.size()!=0){
                            showProjectSection = true;
                            //System.debug('showProjectSection'+showProjectSection);
                        }
                        
                        else if(searchObjects.get(i).equals('Summary Task') && lstSummaryTasks.size()!=0){
                            showSummTaskSection = true;
                        }
                        else if(searchObjects.get(i).equals('Task') && lstTasks.size()!=0){
                            showTaskSection = true;
                        }
                        else if(searchObjects.get(i).equals('Milestone') && lstMilestones.size()!=0){                           
                        showMilestoneSection = true;
                        }
                        
                        
                   }
                   if(lstProjects.size()==0 && lstSummaryTasks.size() ==0 && lstTasks.size()==0 && lstMilestones.size() == 0){
                                Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.WARNING,'No Results found.'));
                        }
                   }
                   
                 
                                                                        
                   
                   
                   }
                   else
                   Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR,'Please enter a search value greater than one letter'));
                    
                   //lstProjects = [Select Id,Name,Status__c,Owner.Name from CORE_NT_Project__c where Name like : searchCriteria];
                   //lstTasks = [Select Name,Project_Milestone__r.Name from CORE_NT_Task__c where Name like : searchCriteria];
                   
                    return null;
    }

}