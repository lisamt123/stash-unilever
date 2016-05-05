/** 
    About
    -----
    Description: Class Oblix_Ctrl001DeepCloneSOW_CC
    Created for: Oblix Unilever Project
    Create date: 10/ 2015
    Created by Jamal Rida
    Author : @Jamal
    Details
    -------
    This class is  : Used as a  class to make Version Control fro SOW Record
                        
            Functionnalities : 
                    
    Update History
    --------------    
*/ 
public with sharing class Oblix_Ctrl001DeepCloneSOW_CC {
    
    public String sowRecordID {get;set;}
    private String financialYear {get;set;}
    public Boolean isEnaughCopies {get;set;}
    public Marketing_SOW__c sowParent {get;set;}
    public String nextStageTypeSow {get;set;}
    private String baseline = 'Baseline';
    public Boolean canClone {get;set;}
    public Oblix_Ctrl001DeepCloneSOW_CC(){
        
        
    }
    /**
     * Initialise the treatment,
     * @param sowId [sowId]
     * @param fyear [fyear]
     */  
    public void init(){
        sowRecordID = ApexPages.currentPage().getParameters().get('sowId');
        financialYear = ApexPages.currentPage().getParameters().get('fyear');
        //Parent Records for SOW Marketing
         canClone = false;
         Id adminProfileId = [Select Id, Name from Profile where Name ='System Administrator'].Id;
        
        if(Userinfo.getProfileId() == adminProfileId){
            canClone = true;
        }else{
            List<PermissionSetAssignment> lstperrmissions = [Select Id, AssigneeId, PermissionSetId, PermissionSet.Name from PermissionSetAssignment where AssigneeId =: Userinfo.getUserId()];
            system.debug('##lstperrmissions :'+lstperrmissions);
            if(!lstperrmissions.isEmpty()){
                for(PermissionSetAssignment permission : lstperrmissions){
                    system.debug('##permission Name :'+permission.PermissionSet.Name);
                    if(permission.PermissionSet.Name == 'Oblix_SWOP_UL_1_V1' || permission.PermissionSet.Name == 'Oblix_SWOP_Super_User_V1'){
                        canClone = true;
                    }
                }
            }
        }
        
        
        if(canClone){
            isEnaughCopies = false;
            nextStageTypeSow = financialYear;
            sowParent = new Marketing_SOW__c();
            List<Marketing_SOW__c> lstMarkSowP = new List<Marketing_SOW__c>();
            Marketing_SOW__c sowChildPrevious =  new Marketing_SOW__c();
            System.debug('###sowRecord PArent : '+sowRecordID);
            lstMarkSowP = [ 
              Select m.Unilever_SOW_Approver_Name__c, m.Unilever_Lead__c, m.Unilever_Approval_Date__c, m.Type_of_SOW__c, m.RecordTypeId, 
              m.OwnerId, m.Name, m.Marketing_Agency__c, m.MarketingSOWParent__c, m.Id, m.Financial_Year__c, m.FINAL_APPROVED_FEE_K__c, 
              m.Currency__c, m.CreatedDate, m.CreatedById,  m.BB_or_BD__c, // m.Brand__c, m.Category_Small_C__c, m.Big_C__c,
              m.Allocated_Budget_K__c, m.Agency_SOW_Approver_Name__c, m.Agency_Contact__c, m.Agency_Approval_Date__c, m.Active__c ,
            
            (Select Id, Name, Financial_Year__c, Type_of_SOW__c from Marketing_SOW__r 
            where Financial_Year__c=: financialYear AND  RecordTypeId =: Oblix_Utils.MapRecordType('Marketing_SOW__c').get('ChildSowMarketing') 
                    order by CreatedDate desc) 
            from Marketing_SOW__c m
                 where id =: sowRecordID and RecordTypeId =: Oblix_Utils.MapRecordType('Marketing_SOW__c').get('ParentSowMarketing')
             ];
             baseline = 'Baseline'; 
             
            if(!lstMarkSowP.isEmpty()){  lstMarkSowP[0] = sowParent  ;}
                     
            if(sowParent.Marketing_SOW__r != null && sowParent.Marketing_SOW__r.size()>=5){ isEnaughCopies = true; }
            else{
                    //if the Parent has Sow Clones
                    if(!sowParent.Marketing_SOW__r.isEmpty()){
                        //Different Q's for Clones Childs 
                        for(Marketing_SOW__c marketingChild : sowParent.Marketing_SOW__r){
                                sowChildPrevious = marketingChild;
                                break;
                        }
                        //if this Last Created Clone is Baseline means it's the first Clone, OtherWise find the Next Quarter
                        if(sowChildPrevious.Type_of_SOW__c == baseline){
                            nextStageTypeSow += 'Q1';
                        }else{
                            Integer tmp_nxtStage = Integer.valueOf(sowChildPrevious.Type_of_SOW__c.subString(sowChildPrevious.Type_of_SOW__c.length()-1, sowChildPrevious.Type_of_SOW__c.length()));
                            tmp_nxtStage += 1;
                            System.debug('###tmp_nxtStage1 : '+tmp_nxtStage);    
                            nextStageTypeSow +='Q'+tmp_nxtStage; 
                        }
                               
                    }else{
                        //Baseline
                        nextStageTypeSow += baseline;
                    }
                    
            }
        }
        
    }
    
     /**
     * Clone the Statement of Work
     * @return [RecordId] page reference
     */  
    public PageReference CloneSowParent(){
        //Parent Records
        //List<Marketing_Basics__c> lstMarketingBasicsParent = new List<Marketing_Basics__c>();
        //List<Oblix_SOW_Projects__c> lstMarketingProjectParent = new List<Oblix_SOW_Projects__c>();
       
        ////Child Records
        //Marketing_SOW__c sowChild = new Marketing_SOW__c();
        //List<Marketing_Basics__c> lstMarketingBasicsChild = new List<Marketing_Basics__c>();
        //List<Oblix_SOW_Projects__c> lstMarketingProjectChild = new List<Oblix_SOW_Projects__c>();
        //List<Oblix_Project_Assets__c> lstMarketingAssetChild = new List<Oblix_Project_Assets__c>();
        
        //sowChild = sowParent.Clone();
        //sowChild.Name = sowParent.Name+''+(nextStageTypeSow.substring(nextStageTypeSow.length()-2, nextStageTypeSow.length()-1)== 'Q' ? nextStageTypeSow.substring(nextStageTypeSow.length()-2, nextStageTypeSow.length()) : baseline);
        //sowChild.RecordTypeId = Oblix_Utils.MapRecordType('Marketing_SOW__c').get('ChildSowMarketing');
        //sowChild.MarketingSOWParent__c = sowParent.Id;
        //sowChild.Type_of_SOW__c = (nextStageTypeSow.substring(nextStageTypeSow.length()-2, nextStageTypeSow.length()-1)== 'Q' ? nextStageTypeSow.substring(nextStageTypeSow.length()-2, nextStageTypeSow.length()) : baseline);
        //sowChild.Active__c = false;
        
        //if(sowChild!= null){ 
            
        //    try{
        //       insert sowChild;
               
        //   }catch(DMLException le){
        //      if(le.getMessage().contains('DUPLICATE_VALUE')){
        //              sowChild.Name = sowChild.Name + Math.round(Math.random() * (10 - 1)) + 1;  
        //               insert sowChild;
        //       }
        //    }    
                
        //}
        ////List of Parent Basics Marketing
        //lstMarketingBasicsParent = [Select Id, Name, Oblix_SOWMarketing__c from Marketing_Basics__c where Oblix_SOWMarketing__c =: sowRecordID];
        ////list of cloned marketing basics from parent
        //lstMarketingBasicsChild = lstMarketingBasicsParent.deepClone();
       
        //    for(Marketing_Basics__c marketingBasic : lstMarketingBasicsChild){
        //        //update the Sow MArketing field from Parent ==> Child
        //        //marketingBasic.Name += financialYear+''+(nextStageTypeSow.substring(nextStageTypeSow.length()-2, 
        //        //nextStageTypeSow.length()-1)== 'Q' ? nextStageTypeSow.substring(nextStageTypeSow.length()-2, nextStageTypeSow.length()) : 'Baseline');
        //        marketingBasic.Oblix_SOWMarketing__c = sowChild.Id;
        //    }
        //    insert lstMarketingBasicsChild;
       
        
        ////List of Parent Projects MArketing with there childs of Asset projects
        //lstMarketingProjectPArent = [Select Total_Fees_for_Project__c, Total_Digital_Fee__c, Total_Adapt_Fees__c, 
        //                             Timescale_Notes__c, SystemModstamp, Stimulus_Requirements__c, 
        //                             Should_legal_review_this_project__c, Region__c, Project_Start_Date__c, 
        //                             Project_Stage__c, Project_Scale_2__c, Project_Scale_1__c, 
        //                             Project_Priority__c, Project_Finish_Date__c, Project_Completion_Date__c, 
        //                             Production_Completion_Date__c, Platform__c, Overall_Project_Complete__c, 
        //                             Other_Kinds_of_Research__c, OblixClonedFromParentProject__c, Number_of_Previews__c, 
        //                             Number_of_Markets_for_Preview__c, Name, List_Preview_Markets__c, LastModifiedDate, 
        //                             Jobs_to_be_Done__c, Is_type_of_item_usually_poduced_by_this__c, Is_this_High_Risk__c, 
        //                             Innovation_Projects__c, Id, First_Air_Date__c, Financial_Year__c, Description__c, 
        //                             CreatedDate, Campaign_Idea__c, Budget_Burnt_to_date__c, Brand_Led_Growth__c,
        //                             (Select Target_Delivery_Date__c, Sub_Category__c,
        //                                     RecordTypeId, Quantity__c, OblixClonedFromParentAsset__c, Name, 
        //                                     Location__c, Id, FULL_Description__c, CreatedDate, Channels__c, 
        //                                     Asset_Type__c, Asset_Total_Score__c, Asset_Scoring_Number__c, Asset_Description__c, 
        //                                     Agency_Projects__c, Additional_Description__c, Actual_Delivery_Date__c 
        //                                     From Agency_Project_Assets__r  )
        //                                    From Oblix_SOW_Projects__c  where Financial_Year__c =:sowRecordID];
                                            
                                            
                                            
        //Map<String, Id> MapProjectParentToChild = new Map<String, Id>();
        
        //if(!lstMarketingProjectParent.isEmpty()){
        //    for(Oblix_SOW_Projects__c project : lstMarketingProjectParent){
                    
        //            Oblix_SOW_Projects__c projectChild = new Oblix_SOW_Projects__c();
        //            projectChild = project.Clone();
        //            projectChild.Name += financialYear+''+(nextStageTypeSow.substring(nextStageTypeSow.length()-2, nextStageTypeSow.length()-1)== 'Q' ? nextStageTypeSow.substring(nextStageTypeSow.length()-2, nextStageTypeSow.length()) : baseline);
        //            projectChild.Financial_Year__c = sowChild.Id;
        //            projectChild.OblixClonedFromParentProject__c = project.Id;
                    
        //            lstMarketingProjectChild.add(projectChild);
        //    }
        //    if(!lstMarketingProjectChild.isEmpty()){
                  
        //          try{
        //               insert lstMarketingProjectChild;
                       
        //           }catch(DMLException le){
        //              if(le.getMessage().contains('DUPLICATE_VALUE')){
        //                      for(Oblix_SOW_Projects__c projChild : lstMarketingProjectChild){
        //                          projChild.Name = projChild.Name + Math.round(Math.random() * (10 - 1)) + 1;  
        //                      }    
                              
        //                       insert lstMarketingProjectChild;
        //               }
        //            }    
                  
        //          for(Oblix_SOW_Projects__c projChild : lstMarketingProjectChild){
        //            //Construct Map for each parent it's related Child
        //            if(!MapProjectParentToChild.containsKey(projChild.OblixClonedFromParentProject__c)){
        //                MapProjectParentToChild.put(projChild.OblixClonedFromParentProject__c, projChild.Id);
        //            }
                    
        //          }
        //    }
        //}
        
        ////Create lst of Asset Childs
        //    for(Oblix_SOW_Projects__c project : lstMarketingProjectParent){
        //        System.debug('###project : '+project);
        //        if(!project.Agency_Project_Assets__r.isEmpty()){
        //            for(Oblix_Project_Assets__c assetParent : project.Agency_Project_Assets__r){
        //                    System.debug('###assetParent : '+assetParent);
        //                    Oblix_Project_Assets__c assetChild = new Oblix_Project_Assets__c();
        //                        assetChild = assetParent.Clone();
        //                        assetChild.OblixClonedFromParentAsset__c = assetParent.Id;  
        //                        if(MapProjectParentToChild.get(project.Id) != null){
        //                            assetChild.Agency_Projects__c = MapProjectParentToChild.get(project.Id);
        //                        }
        //                        lstMarketingAssetChild.add(assetChild);
        //            }
        //        }
        //    }
        //    if(!lstMarketingAssetChild.isEmpty()){ insert lstMarketingAssetChild;}
        
        return new PageReference('/'+sowRecordID);
    }
}