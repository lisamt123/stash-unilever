/*********************************************************************************************************
    @Description : This class is used to update the owner of the project with the Queue to give open up 
                   the access of the project to the team members.
    @Created Date: 30/06/2014
    @Author: Cognizant
    @Referenced: IPM_ProjectOwnerUpdate_Batch
**********************************************************************************************************/

/*  
    This class would initially run in System mode to make sure that it can view all project specific data and associations.
    However internal invocations for Helpers are 'With sharing'. 
*/

global class IPM_ProjectOwnerUpdate_Batch implements Database.Batchable<sObject> 
{

     global set<id> projectidSet = new Set<id>();//set of project id's
     global final String query;//hold soql query
     global string projectidstr;//hold project id
     global Set<id> projectidtobeprocess = new Set<id>() ;
     public static String executeMethod ='execute';//method name
     public static String CLASS_NAME = IPM_ProjectOwnerUpdate_Batch.class.getName();
     
    /****************************************************************************************
    @Description : Constructor
    @Param:set of project id's
    *****************************************************************************************/
    global IPM_ProjectOwnerUpdate_Batch(Set<id> projectid, Set<id> projectidforprocess)
    {
       projectidtobeprocess = projectidforprocess;
       projectidSet = projectid;
      
     //Where clause changed  
       query = 'SELECT Id,IPM_Project_Name__c,Name,OwnerId,IPM_Bosscard__r.id, IPM_Global_Project_Id__c,IPM_Golbal_Project_OwnerId__c, IPMProject_Span__c' 
                +' FROM IPM_Project__c WHERE Id IN:projectidSet LIMIT 50000';
       
    }
    /****************************************************************************************
    @Description : batch start method
    @Param:BatchableContext
    *****************************************************************************************/
    
    global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(query);
    }
    /****************************************************************************************
    @Description : batch execute method to assign project records owner as queue
    @Param:BatchableContext
    @Param:List of projects
    *****************************************************************************************/
    global void execute(Database.BatchableContext BC,  List<IPM_Project__c> ProjectList) 
    {
        
        Set<string> grpnameSet=new Set<string>();
        Map<id,id>ChildParentProjectMap= new Map<id,id>();
        projectidstr = '';
                  
          for(IPM_Project__c proj:ProjectList){
                projectidstr = proj.id;
                projectidstr = projectidstr.Substring(0,15);
                if(proj.IPM_Global_Project_Id__c == projectidstr){
                    grpnameSet.add(IPM_ConstantUtils.IPM_IPMNNAME+projectidstr);
                    grpnameSet.add(IPM_ConstantUtils.IPM_IPMNNAME+proj.name);
                }else{
                    ChildParentProjectMap.put(proj.id,proj.IPM_Golbal_Project_OwnerId__c);                   
                }
                
          }
          
          Map<String,Group> grpMap=new Map<String,Group>();
          if(grpnameSet != null && !grpnameSet.isEmpty()){
              for(Group g:[SELECT Id,Name FROM Group WHERE Name IN: grpnameSet LIMIT 50000]){
                  grpMap.put(g.Name,g);
              }
          }
          list <IPM_Project__c> updateProjectOwnerList=new list <IPM_Project__c>();
          map <string,id> projectowneridmap = new map <string,id>();
          map <id,id> bosscardprojectidmap = new map <id,id>();
          
          for(IPM_Project__c proj:ProjectList){
              projectidstr = proj.id;
              if(grpMap.get(IPM_ConstantUtils.IPM_IPMNNAME+projectidstr.Substring(0,15))!=null ){
              
                  proj.OwnerId=grpMap.get(IPM_ConstantUtils.IPM_IPMNNAME+projectidstr.Substring(0,15)).Id;
                  projectowneridmap.put(proj.id,proj.OwnerId);
                  projectidstr = proj.id;
                  projectowneridmap.put(projectidstr.Substring(0,15),proj.OwnerId);
                  if(projectidtobeprocess.contains(proj.id)){
                    updateProjectOwnerList.add(proj);
                    bosscardprojectidmap.put(proj.IPM_Bosscard__r.id,proj.id);
                  }
              }
                else if(grpMap.get(IPM_ConstantUtils.IPM_IPMNNAME+proj.name)!=null){
                    proj.OwnerId=grpMap.get(IPM_ConstantUtils.IPM_IPMNNAME+proj.Name).Id;
                    projectowneridmap.put(proj.id,proj.OwnerId);
                    projectidstr = proj.id;
                    projectowneridmap.put(projectidstr.Substring(0,15),proj.OwnerId);
                    if(projectidtobeprocess.contains(proj.id)){
                        updateProjectOwnerList.add(proj);
                        bosscardprojectidmap.put(proj.IPM_Bosscard__r.id,proj.id);
                    }
                }
                    else if(ChildParentProjectMap.get(proj.id)!=null){
                        proj.OwnerId=ChildParentProjectMap.get(proj.id);
                       
                        projectowneridmap.put(proj.id,proj.OwnerId);
                        projectidstr = proj.id;
                        projectowneridmap.put(projectidstr.Substring(0,15),proj.OwnerId);
                        if(projectidtobeprocess.contains(proj.id)){
                            updateProjectOwnerList.add(proj);
                            bosscardprojectidmap.put(proj.IPM_Bosscard__r.id,proj.id);
                        }
                    }              
          }          
          
          if(updateProjectOwnerList != null && !updateProjectOwnerList.isEmpty()){
            try{
                Update updateProjectOwnerList;
            }catch(Exception ex)
            {
                ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,executeMethod,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,null);
            }
          
          //Update the ownerid of financial records to Queueid i.e. ownerid of the project
            List<IPM_Financial__c> updateFinanceOwnerList=new List<IPM_Financial__c>();          
            
            //New Code-from the migration prospect
            for(IPM_Financial__c finance:[select id, ownerid, Parent_Project__r.id, Regional_Project__r.id, Local_Project__r.id, Global_Project_Id__c from IPM_Financial__c where Parent_Project__c IN:projectidtobeprocess or Regional_Project__c IN:projectidtobeprocess or Local_Project__c IN:projectidtobeprocess]){
                if(finance.Local_Project__r.id != null && projectidtobeprocess.contains(finance.Local_Project__r.id) &&  projectowneridmap.containskey(finance.Global_Project_Id__c)){
                    finance.ownerid = projectowneridmap.get(finance.Global_Project_Id__c);
                    updateFinanceOwnerList.add(finance);
                } else if(finance.Regional_Project__r.id != null && projectidtobeprocess.contains(finance.Regional_Project__r.id) && projectowneridmap.containskey(finance.Global_Project_Id__c)){
                    finance.ownerid = projectowneridmap.get(finance.Global_Project_Id__c);
                    updateFinanceOwnerList.add(finance);
                }else if(finance.Parent_Project__r.id != null && projectidtobeprocess.contains(finance.Parent_Project__r.id) && projectowneridmap.containskey(finance.Global_Project_Id__c)){
                    finance.ownerid = projectowneridmap.get(finance.Global_Project_Id__c);
                    updateFinanceOwnerList.add(finance);
                }   
            }
            
            //Update the ownerid of boscard to Queueid i.e. ownerid of the project
            List<IPM_Bosscard__c> updatebosscardOwnerList=new List<IPM_Bosscard__c>();
            if(bosscardprojectidmap.keyset() != null && bosscardprojectidmap.keyset().size()>0){
                for(IPM_Bosscard__c boss:[select id, ownerid from IPM_Bosscard__c where id IN:bosscardprojectidmap.keyset()]){
                    if(bosscardprojectidmap.containskey(boss.id)){
                        boss.ownerid = projectowneridmap.get(bosscardprojectidmap.get(boss.id));
                        updatebosscardOwnerList.add(boss);
                    }
                }     
             }
            
            //Update the ownerid of Document Section Content to Queueid i.e. ownerid of the project
            List<IPM_Project_Document_Section_Content__c> updateDocSecConOwnerList=new List<IPM_Project_Document_Section_Content__c>(); 
            for(IPM_Project_Document_Section_Content__c  DocSecCon:[SELECT id,ownerid,IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__r.ownerid 
                                            FROM IPM_Project_Document_Section_Content__c
                                            //WHERE IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__r.id IN: projectowneridmap.keyset()]){
                                            WHERE IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__r.id IN: projectidtobeprocess]){
              if(DocSecCon.IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__r.ownerid !=null){
                DocSecCon.ownerid = DocSecCon.IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__r.ownerid;
                updateDocSecConOwnerList.add(DocSecCon);
              }                                           
            }

            if(updateFinanceOwnerList != null && !updateFinanceOwnerList.isEmpty()){
                try{    
                    Update updateFinanceOwnerList;
                }catch(Exception ex)
                {
                    ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,executeMethod,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,null);
                }                
            }
             
                
            if(updatebosscardOwnerList != null && !updatebosscardOwnerList.isEmpty()){
                try{                 
                    Update updatebosscardOwnerList;
                }catch(Exception ex)
        {
          ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,executeMethod,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,null);
        }                        
           }
          
                      
          if(!updateDocSecConOwnerList.isEmpty()){
             try{    
                 Update updateDocSecConOwnerList;
                }catch(Exception ex){
                   ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,executeMethod,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,null);
                  } 
          }          
    }
   } 

    //finish Mehtod
    global void finish(Database.BatchableContext BC)
    {       
       // Query the AsyncApexJob object to retrieve the current job's information.
       AsyncApexJob apexJob = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email
                  			   FROM AsyncApexJob 
                   			   WHERE Id =:bC.getJobId()];
       
       if(apexJob.NumberOfErrors>0){       
       		//sends an email for job status, after the job is completed.
       		IPM_Utils.sendApexJobStatusMail(BC);
       } 
    }

}