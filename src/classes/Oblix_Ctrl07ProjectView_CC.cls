/**
    About
    -----
    Description: Class Oblix_Ctrl07ProjectView_CC 
    Created for: OBLIX Project
    Create date: 10/ 2015  (23/10/2015)
    Created by Jamal Rida
    Author : @Jamal
    Details
    -------
    
       Update History
    --------------    
*/

public with sharing class Oblix_Ctrl07ProjectView_CC {
        
        public Oblix_SOW_Projects__c SelectedProject {get;set;}
        public List<Oblix_Marketing_SOW_Project_Splits__c> lstProjectSplitHubs {get;set;}
        public list<Oblix_Project_Assets__c> lstAssets {get;set;}
        public set<string> setRecordType  {get;set;}
        public string IdsProject {get;set;}
        public String sowID  {get;set;}
        public String ItemsEdit {get;set;}
        public User userConnected {get;set;}
        public list<string> lstStage {get;set;}
        public map<string,integer> mapNumberItem {get;set;}
        public string itemToDelete {get;set;}
        public Oblix_Project_Assets__c  itemToEdit {get;set;}
        public boolean isEditItem {get;set;}
        public map<string,string> mapStageIdCSS {get;set;}
        public map<string,integer> feePercentages {get;set;}
        public map<string,integer> feeValues {get;set;}
        public string lstIdCSSSelected {get;set;}
        public Map<String, String> mapTurnoverToSize {get;set;}
        public Boolean canDelete {get;set;}
        // Cancel project popup 
        public integer percentageToBePaid {get;set;}
        public boolean isLocked {get;set;}
        
        
        
        public Oblix_Ctrl07ProjectView_CC (){
              IdsProject = '';
              isEditItem = false;
              lstIdCSSSelected = '';
              percentageToBePaid = 0;
              isLocked = false;
              lstStage = new list<string>();
              mapNumberItem = new map<string,integer>();
              itemToEdit = new Oblix_Project_Assets__c();
              mapStageIdCSS = new map<string,string>();
              feePercentages = new map<string,integer>(); 
              feeValues = new map<string,integer>();   
        }
        
        /*
        *   @Description : this method allows only UL1, SuperUser, Sys Admin, to adjust Fees and view the Adjust Fee Button.
        */
        public void isAllowedToDeleteAsset(){
            Id adminProfileId = [Select Id, Name from Profile where Name ='System Administrator'].Id;
            List<PermissionSetAssignment> lstperrmissions = [Select Id, AssigneeId, PermissionSetId, PermissionSet.Name from PermissionSetAssignment where AssigneeId =: Userinfo.getUserId()];
            system.debug('##lstperrmissions :'+lstperrmissions);
            if(Userinfo.getProfileId() == adminProfileId){
                canDelete = true;
            }
            if(!lstperrmissions.isEmpty()){
                for(PermissionSetAssignment permission : lstperrmissions){
                    system.debug('##permission Name :'+permission.PermissionSet.Name);
                    if(permission.PermissionSet.Name == 'Oblix_SWOP_UL_1_V1' || permission.PermissionSet.Name == 'Oblix_SWOP_UL_2_V1' || permission.PermissionSet.Name == 'Oblix_SWOP_Super_User_V1'){
                        canDelete = true;
                        break;
                    }
                }
            }
        }
        
         /* 
        @Description : initialize form values 
       
        */    
        public void init(){
            isAllowedToDeleteAsset();
            
            setRecordType = new set<String>();
            Id idUser = UserInfo.getUserId();
            mapTurnoverToSize = new Map<String, String>(); 
            mapTurnoverToSize.put(Oblix_Constants.BrandLedGrowth_IncremTurnoverLess10, 'S');
            mapTurnoverToSize.put(Oblix_Constants.BrandLedGrowth_IncremTurnover1020, 'S/M');
            mapTurnoverToSize.put(Oblix_Constants.BrandLedGrowth_IncremTurnoverLess2030, 'M');
            mapTurnoverToSize.put(Oblix_Constants.BrandLedGrowth_IncremTurnoverLess3040, 'M/L');
            mapTurnoverToSize.put(Oblix_Constants.BrandLedGrowth_IncremTurnoverLessAbove40, 'L');
            
            mapTurnoverToSize.put(Oblix_Constants.BrandLedGrowth_Less100, 'S');
            mapTurnoverToSize.put(Oblix_Constants.BrandLedGrowth_100_200, 'S/M');
            mapTurnoverToSize.put(Oblix_Constants.BrandLedGrowth_IncremTurnover200_300, 'M');
            mapTurnoverToSize.put(Oblix_Constants.BrandLedGrowth_IncremTurnoverLess300_400, 'M/L');
            mapTurnoverToSize.put(Oblix_Constants.BrandLedGrowth_IncremTurnoverLessAbove400, 'L');
            
            userConnected = [Select Name from User where Id =: idUser ];
            SelectedProject = [Select o.Total_Fees_for_Project__c, o.Preview_Date__c ,o.Total_Digital_Fee__c,o.Value_to_be_paid_in_Current_FY__c ,o.Projected_Stage__c,o.Completed_Stage__c,o.Campaign_Status__c, o.Total_Adapt_Fees__c, o.Timescale_Notes__c, o.SystemModstamp, o.Stimulus_Requirements__c, 
                                 o.Should_legal_review_this_project__c, o.Region__c, o.Project_Start_Date__c, o.Project_Stage__c, o.Project_Scale_2__c, o.Project_Scale_1__c, o.Project_Priority__c, 
                                 o.Project_Finish_Date__c, o.Project_Completion_Date__c, o.ProjectTotalAssetscore__c, o.Production_Completion_Date__c, o.Platform__c, 
                                 o.Percentage_of_Fee_for_this_FY__c, o.Overall_Project_Complete__c, o.Other_Kinds_of_Research__c, o.Oblix_ProjectBoxNumber__c, o.OblixRegion__c, 
                                 o.OblixProjectSplitPercentage_Comment__c,o.Campaign_Fees_Total__c, o.OblixCountries__c, o.OblixClonedFromParentProject__c, o.Number_of_Previews__c, o.Number_of_Markets_for_Preview__c, 
                                 o.Name, o.List_Preview_Markets__c, o.LastModifiedDate, o.LastModifiedById, LastModifiedBy.Name, o.Jobs_to_be_Done__c, 
                                 o.Is_type_of_item_usually_poduced_by_this__c, o.Is_this_High_Risk__c, o.IsDeleted, o.Innovation_Projects__c, o.Id, o.First_Air_Date__c, o.Financial_Year__c, 
                                 o.Description__c, o.Date_for_Assets_to_be_in_BET__c, o.CreatedDate, o.CreatedById, o.Campaign_Idea__c, o.Budget_Burnt_to_date__c, o.Brand_Led_Growth__c, 
                                 o.Agency_Percentage_of_Fees_to_this_FY__c,o.Financial_Year__r.currency__c,o.BET_first_release__c,o.Final_release__c,o.Start_of_TV_production__c,o.Live_date_Asset_delivery__c,o.Live_Date__c From Oblix_SOW_Projects__c o where id =:ApexPages.currentPage().getParameters().get('projectId')];
              if(SelectedProject.OblixCountries__c != null){
                  SelectedProject.OblixCountries__c = SelectedProject.OblixCountries__c.replaceAll(',',', ');
              }    
              lstIdCSSSelected = Oblix_Utils.getSelectedStageCheckbox(SelectedProject.Projected_Stage__c,SelectedProject.Completed_Stage__c);
              sowID =  SelectedProject.Financial_Year__c;                  
              IdsProject = IdsProject +'\''+SelectedProject.id+'\',';
              IdsProject = '['+IdsProject.removeEnd(',')+']';   
                              
             lstProjectSplitHubs = [Select Id, Name, OblixCountry__r.name,OblixCountry__c, Project_Splits__c, Percentage__c from Oblix_Marketing_SOW_Project_Splits__c where Project_Splits__c =: SelectedProject.Id ];
             
             lstAssets = [select Id,Agency_Projects__r.id,Location__c ,Asset_name__c,Asset_Picklist__c ,LastModifiedDate,Quantity__c,Additional_Description__c,Target_Delivery_Date__c ,Actual_Delivery_Date__c, FULL_Description__r.Name, Channels__c,RecordType.Name,Name,RecordTypeId,Sub_Category__c,FULL_Description__c from Oblix_Project_Assets__c where Agency_Projects__c =:SelectedProject.Id];
             System.debug('###lstAssets : '+lstAssets );
             
             if(!lstAssets.isEmpty()){
                  for(Oblix_Project_Assets__c asset:lstAssets){
                      if(!mapNumberItem.containsKey(asset.RecordType.Name)){
                          mapNumberItem.put(asset.RecordType.Name,1);
                      }else{                    
                          mapNumberItem.put(asset.RecordType.Name,mapNumberItem.get(asset.RecordType.Name)+1);
                      }
                      asset.Asset_name__c = Oblix_Utils.getAssetName(asset);
                  }
             } 
             if(mapNumberItem.get(Label.Oblix_Lbl_UIUX_AudioVisuel) == null) { mapNumberItem.put(Label.Oblix_Lbl_UIUX_AudioVisuel,0);}
             if(mapNumberItem.get(Label.Oblix_Lbl_UIUX_Digital) == null) { mapNumberItem.put(Label.Oblix_Lbl_UIUX_Digital,0);}
             if(mapNumberItem.get(Label.Oblix_Lbl_UIUX_Experiential) == null) { mapNumberItem.put(Label.Oblix_Lbl_UIUX_Experiential,0);}
             if(mapNumberItem.get(Label.Oblix_Lbl_UIUX_Static_Img) == null) { mapNumberItem.put(Label.Oblix_Lbl_UIUX_Static_Img,0);}
             if(mapNumberItem.get(Label.Oblix_Lbl_UIUX_Stimulus_Materials) == null) { mapNumberItem.put(Label.Oblix_Lbl_UIUX_Stimulus_Materials,0);}    
             System.debug('###setRecordType : '+setRecordType);
             
             lstStage = Oblix_Utils.getStageList();
             feePercentages.put(lstStage[0],10);
             feePercentages.put(lstStage[1],20);
             feePercentages.put(lstStage[2],30);
             feePercentages.put(lstStage[3],25);
             feePercentages.put(lstStage[4],15);
             
             feeValues.put(lstStage[0],10);
             feeValues.put(lstStage[1],30);
             feeValues.put(lstStage[2],60);
             feeValues.put(lstStage[3],85);
             feeValues.put(lstStage[4],100);
             
             for(string stage:lstStage){
                mapStageIdCSS.put(stage,stage.replaceAll(' & ','_').replaceAll(' ','_'));
            } 
            
              
         }
        /* Method used to redirect Back To Sow View
         * @return [Redirection to the Sow View Page] 
         */ 
        public PageReference BackToSow(){
            return new PageReference('/apex/Oblix_VF06_SOWView?sowId='+SelectedProject.Financial_Year__c);
        }
        
        /* 
        @Description : Action used to clone project
        @return : VF8  with project to clone in params
        */
        public pageReference CloneCampaign(){

           Oblix_SOW_Projects__c project = new Oblix_SOW_Projects__c(); //SelectedProject.clone();
           project.name = SelectedProject.name +' Clone';
           project.Financial_Year__c = selectedProject.Financial_Year__c;
           try{
               insert project;
               insertRelatedCloneRecords(project, SelectedProject);
           }catch(DMLException le){
             String duplicateValue ='';
              if(le.getMessage().contains('DUPLICATE_VALUE')){
                      duplicateValue = '1';
               }
                project.Name = project.Name + Math.round(Math.random() * (10 - 1)) + 1;  
                insert project;
                insertRelatedCloneRecords(project, SelectedProject);
                 System.debug('###Error Occured : '+le.getMessage());   
                 return new PageReference('/apex/Oblix_VF08_ProjectEdit?duplicateValue=1&isClone=1&projectId='+project.Id);
            }
            
           // id clonedProjId = Oblix_Utils.CloneProject(project.id);
            return new PageReference('/apex/Oblix_VF08_ProjectEdit?isClone=1&projectId='+project.Id);
        }
        
        /* 
        @Description : Method inserting Related List records of the project to clone with new parent
        */
        private static void insertRelatedCloneRecords(Oblix_SOW_Projects__c project, Oblix_SOW_Projects__c SelectedProject){
            //get assets of the parent
         List<Oblix_Project_Assets__c> lstAssetFromParent = [Select Target_Delivery_Date__c,Asset_name__c, Sub_Category__c,
                                             RecordTypeId, Quantity__c, OblixClonedFromParentAsset__c, Name, 
                                             Location__c, Id, FULL_Description__c, CreatedDate, Channels__c, 
                                             Asset_Type__c, Asset_Total_Score__c, Asset_Scoring_Number__c, Asset_Description__c, 
                                             Agency_Projects__c, Additional_Description__c, Actual_Delivery_Date__c 
                                             From Oblix_Project_Assets__c where Agency_Projects__c =:SelectedProject.Id];
        //clone assets, insert them 
         List<Oblix_Project_Assets__c> lstAssetClone = lstAssetFromParent.deepClone();
                    if(!lstAssetClone.isEmpty()){
                        for(Oblix_Project_Assets__c assetClone : lstAssetClone){
                            assetClone.Agency_Projects__c = project.Id;
                        }
                        insert lstAssetClone;
                    }                        
          /*
           //get splits of the parent         
          List<Oblix_Marketing_SOW_Project_Splits__c> lstSplitFromParent = [Select Id, Name, Project_Splits__c, OblixCountry__c, 
                                                Percentage__c from Oblix_Marketing_SOW_Project_Splits__c where Project_Splits__c =: SelectedProject.Id
                                                            ];
        //clone splits, insert them 
         List<Oblix_Marketing_SOW_Project_Splits__c> lstSplitClone = lstSplitFromParent.deepClone();
                    if(!lstSplitClone.isEmpty()){
                        for(Oblix_Marketing_SOW_Project_Splits__c splitClone : lstSplitClone){
                            splitClone.Project_Splits__c = project.Id;
                        }
                        insert lstSplitClone;
                    }
         */           
        }
        /* 
        @Description : Function related to the asset record 
        */
         public void EditItemsAction(){
             isEditItem = true;
         }
         
         /* 
         @Description : ======
         */
          public void DeleteItemsAction(){
             Oblix_Project_Assets__c assetToDelete = new Oblix_Project_Assets__c();
             integer position = 0;
             system.debug('###itemToDelete : '+itemToDelete);
             for(Integer i=0;i<lstAssets.size();i++){
                 if(lstAssets[i].Id == itemToDelete){
                    assetToDelete = lstAssets[i];
                    position = i;
                    //delete lstAssets[i] ;
                   
                 }
             }
             
            mapNumberItem.put(assetToDelete.RecordType.Name, mapNumberItem.get(assetToDelete.RecordType.Name)-1);
            delete assetToDelete;
            if(position > 0) { lstAssets.remove(position); } 
             lstAssets = [select Id,Agency_Projects__r.id,Asset_name__c,LastModifiedDate,Additional_Description__c,Target_Delivery_Date__c ,Actual_Delivery_Date__c, FULL_Description__r.Name, Channels__c,RecordType.Name,Name,RecordTypeId,Sub_Category__c,FULL_Description__c from Oblix_Project_Assets__c where Agency_Projects__c =:SelectedProject.Id];
         }
         /* 
         @Description : ======
         */ 
         public void SaveItemsAction(){  
             Oblix_Project_Assets__c assetToUpdate = new Oblix_Project_Assets__c();
             for(Oblix_Project_Assets__c  asset : lstAssets){
                 if(asset.Id == itemToDelete){
                     assetToUpdate = asset;
                     //update asset;
                 }
             }
             update assetToUpdate;
             lstAssets = [select Id,Agency_Projects__r.id,Asset_name__c,LastModifiedDate,Additional_Description__c,Target_Delivery_Date__c ,Actual_Delivery_Date__c, FULL_Description__r.Name, Channels__c,RecordType.Name,Name,RecordTypeId,Sub_Category__c,FULL_Description__c from Oblix_Project_Assets__c where Agency_Projects__c =:SelectedProject.Id];
             isEditItem = false;
         }
         
         /* 
         @Description : Method used to update the curent Project
         */ 
         public void SaveProject(){
             try{
                 update SelectedProject;
             }catch(Exception e){
                 System.debug('###Error Occured : '+e.getMessage());
                 ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Error while saving the project, please review data'));
             }
         }   
         
         /* Method used to redirect Back To Item Edit Page
         * @return [Redirection to the Items Edit Page] 
         */ 
         public PageReference EditItems(){
             system.debug('###ItemsEdit : '+ItemsEdit);
           
            return new PageReference('/apex/Oblix_VF08_ProjectEdit?projectId='+SelectedProject.Id+'&assetId='+ItemsEdit);
         }
         /* Method used to redirect Back To Project Edit Page
         * @return [Redirection to theProject Edit Page] 
         */ 
         public PageReference EditAddItems(){
             return new PageReference('/apex/Oblix_VF08_ProjectEdit?projectId='+SelectedProject.Id);
         }


    /**
    *   Method used to cancel this campaign
    *   @return [reload page]
    */
    public void cancelCampaign(){

        try{

            selectedProject.Campaign_Status__c = 'canceled';
            isLocked = true;
            update selectedProject;
            // to lock the project            
            
        } catch (DMLException e){

            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'There was an issue while trying to update this campaign: ' + e.getMessage()));

        }

    }
       
         
     
     
}