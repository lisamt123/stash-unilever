/**
    About
    -----
    Description: Class Oblix_Ctrl05SOWDetails_CC
    Created for: OBLIX Project
    Create date: 10/ 2015
    Created by Asmae ESSBAI
    Author : @Asmae
    Details
    -------
    
       Update History
    --------------    
*/
    public with sharing class Oblix_Ctrl06SOWView_CC {
        
        public Marketing_SOW__c selSow {get;set;}
        public id sowId {get;set;}
        public id projectId {get;set;}         
        public List<Attachment> lstAttachements {get;set;}
        //Projects to the Sow
        public List<Oblix_SOW_Projects__c> lstProjects {get;set;}
        // Ids of SOW projects
        private set<id> setIdsProject;
        public string IdsProject {get;set;}
        public list<Oblix_Project_Assets__c> lstAssets {get;set;}
        public boolean isEdit {get;set;}
        public User userConnected {get;set;}
        public Oblix_SOW_Projects__c pr {get;set;}
        public string PrStatus {get;set;}
        public string PrStage {get;set;}
        public set<string> setRecordType  {get;set;}
        public Oblix_SOW_Projects__c SelectedProject {get;set;}
        public boolean isViewProject {get;set;}
        
        
         //Thousand Block Part : 
        public  limitWrapper[] thousandBlocks {get;set;}
        private final integer listLimit;
        
        
        public Oblix_Ctrl06SOWView_CC(){
            listLimit = 999;
            thousandBlocks = new List<limitWrapper>();
            lstProjects = new List<Oblix_SOW_Projects__c>();
            lstAttachements = new List<Attachment>();
            IdsProject = '';
            setRecordType  = new set<string>();
            if(projectId == null) SelectedProject = new Oblix_SOW_Projects__c();
            pr = new Oblix_SOW_Projects__c ();
            isEdit = false;
            setIdsProject = new set<id>();
            lstAssets = new list<Oblix_Project_Assets__c>();
            init();
        }
        
        public void init(){
        
            Id idUser = UserInfo.getUserId();
            userConnected = [Select Name from User where Id =: idUser ];
            sowId = ApexPAges.currentPage().getParameters().get('sowId');
            projectId = ApexPAges.currentPage().getParameters().get('projectId');
            if(sowId == null){ selSow = new Marketing_SOW__c ();  }         
            else{
            selSow = [Select Id, Agency_Contact__r.name, Unilever_Lead__r.name, CreatedById, CreatedBy.Name, Currency__c, 
                        BigOblixProductCategory__r.Name, OblixBrand__r.Name, SmallProductCategory__r.Name,
                        LastModifiedById, FINAL_APPROVED_FEE_K__c, LastModifiedBy.Name, Financial_Year__c, BigOblixProductCategory__c, 
                        Name, SmallProductCategory__c, OblixBrand__c, Marketing_Agency__c, LastModifiedDate, CreatedDate, 
                        SOW_Status__c, BB_or_BD__c   from Marketing_SOW__c where Id=: sowId 
                      ];
             }
             System.debug('###selSow : '+selSow);
             if(projectId == null) SelectedProject = new Oblix_SOW_Projects__c();
             else
             SelectedProject = [Select Id,Name, Project_Finish_Date__c,Project_Stage__c,Platform__c,CreatedById, Project_Start_Date__c,CreatedDate,OblixRegion__c,Project_Priority__c,Project_Completion_Date__c,Description__c,OblixCountries__c,First_Air_Date__c,Production_Completion_Date__c, Financial_Year__c from Oblix_SOW_Projects__c where id=:projectId];
            
             if(selSow != null && selSow.Id != null){
                    lstAttachements = [Select Id, Name, Body, ParentId, Parent.Name from Attachment where ParentId =: selSow.Id];
                    lstProjects = [Select Id,Name, Project_Finish_Date__c,Project_Stage__c,Platform__c,CreatedById, Project_Start_Date__c,CreatedDate,OblixRegion__c,Project_Priority__c,Project_Completion_Date__c,Description__c,OblixCountries__c,First_Air_Date__c,Production_Completion_Date__c, Financial_Year__c from Oblix_SOW_Projects__c where Financial_Year__c =: selSow.Id];
              
              }
              if(lstProjects.size()>0){
                  getthousandBlocks(lstProjects);
                  for(Oblix_SOW_Projects__c pr:lstProjects){
                      setIdsProject.add(pr.id);
                   }
              }
              if(setIdsProject.size()>0) {
                  for(id id :setIdsProject){
                      IdsProject = IdsProject +'\''+id+'\',';
                  }
              }
              IdsProject = '['+IdsProject.removeEnd(',')+']';
              lstAssets = [select Id,Agency_Projects__r.id,Channels__c,RecordType.Name,Name,RecordTypeId,Sub_Category__c,FULL_Description__c from Oblix_Project_Assets__c];
              for(Oblix_Project_Assets__c asset:lstAssets)
              setRecordType.add(asset.RecordType.Name);
              
              
        }
        
        public pageReference backAction(){
            return new pageReference('/apex/Oblix_VF05_SOWDetails');
        }
        public pageReference CreateProjectAction(){
            return new pageReference('/apex/Oblix_VF07_ProjectNew?projectId='+projectId);
        }
        public pageReference SaveProjectAction(){
            return new pageReference('/apex/Oblix_VF06_SOWView?id='+sowId);
        }
        public void EditAction(){
            isEdit = true;
        }
        
        
        //List of Projects Part
        /**************************************************************/
         /**
     * Method used to avoid Limit of Thousand Record by Repeat component
     * @return [List of Records by Block of Thousand ] 
     */ 
    public limitWrapper[] getthousandBlocks(List<Oblix_SOW_Projects__c> lstProjectsLoc)
    {   
        //declare it above
        thousandBlocks = new List<limitWrapper>();
        
        integer counter = 0;
        integer loopCount = 0;
        list<Oblix_SOW_Projects__c> tmpProject = new list<Oblix_SOW_Projects__c>();
            for(Integer i=0;i< lstProjectsLoc.size();i++)
            {
                if(counter < listLimit)
                {   
                    
                    if(i!=lstProjectsLoc.size()-1){
                         tmpProject.add(lstProjectsLoc.get(i));
                         counter++;
                    }
                    else{
                         tmpProject.add(lstProjectsLoc.get(i));  
                         counter++;
                         loopCount++;
                      
                     thousandBlocks.add(new limitWrapper(tmpProject,loopCount));
                      return thousandBlocks;
                    }
                   
                }
                else
                {   
                      loopCount++;
                        thousandBlocks.add(new limitWrapper(tmpProject,loopCount));
                        tmpProject= new List<Oblix_SOW_Projects__c>();
                        tmpProject.add(lstProjectsLoc.get(i));
                        counter = 0;
                }
                            
            }
        
        if(thousandBlocks.size() == 0)
        {
            loopCount++;
            thousandBlocks.add(new limitWrapper(tmpProject,loopCount));
        }
        
        return thousandBlocks;
    }
        
        
        /*
        *   Wrapper Class : Used to bypass the Limit of 1000 Record on a repeat
        */
        public class limitWrapper
        {
            public  List<Oblix_SOW_Projects__c>  lstProjects {get;set;}
            public integer blockNumber {get;set;}
            public limitWrapper(List<Oblix_SOW_Projects__c> projectRecords, integer i)
            {
                lstProjects = projectRecords;
                blockNumber = i;
            }
            
        }        
        
        
        
        
        
        
        
        
        
       
    }