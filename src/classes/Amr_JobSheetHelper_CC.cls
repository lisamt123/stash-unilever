/*******************************************************************************************************
Name:  Amr_JobSheetHelper_CC ()  Copyright © 2015  Salesforce  
====================================================== 
====================================================== 
Purpose:                                                           
-------    Helper class to Amr_JobSheetController_CC                                                        
 ====================================================== 
 ====================================================== 
 History                                                             
 -------                                                             
 VERSION   AUTHOR                        DATE              DETAIL                    Description    
 1.0       Mindtree                  16/12/2015      INITIAL DEVELOPMENT            CSR: 
 *********************************************************************************************************************/
 
public with sharing Class Amr_JobSheetHelper_CC{


    /*******************************************************************    
   Purpose:  This method is used to to check validation of production activity type                                 
   Parameters: 
   Returns: It’s return boolean
   ********************************************************************/

    public Boolean productionActivityTypeValidation( Amr_Job_Details__c jobList){
          Boolean okayToSaveCheck = true;
     if(!jobList.NewOriginalMaster__c && !jobList.LanguageAdaptionMaster__c && !jobList.Create_Additional_Material__c && !jobList.ReworkExistingMaterial__c && !jobList.BuyoutsTalent__c && !jobList.BuyoutsMusic__c ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_Production_activity_types_at_least_one_option_must_be_selected));
            okayToSaveCheck =false;
        }
      if(jobList.NewOriginalMaster__c && !jobList.NewOriginalMasterCinema__c && !jobList.NewOriginalMasterTv__c && 
            !jobList.NewOriginalMasterRadio__c && !jobList.NewOriginalMasterPrint__c && !jobList.NewOriginalMasterOutofHome__c &&
                !jobList.NewOriginalMasterInStore__c && !jobList.NewOriginalMasterDigital__c && !jobList.NewOriginalMasterInternalVideo__c ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_For_New_Original_Masterat_least_one_option_of_Media_Channel_must_be_selected));
            okayToSaveCheck =false;
        }
      if(jobList.NewOriginalMaster__c && jobList.NewOriginalMasterOutofHome__c && !jobList.NewOriginalMasterOutofHomeMovingImage__c && 
            !jobList.NewOriginalMasterOutofHomeAudio__c && !jobList.NewOriginalMasterOutofHomeStillImage__c  ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_NewOriginMaster_at_leastoneoption_ofMedium_mustbe_selected_corres_to_outOfHo));
            okayToSaveCheck =false; 
        }
      if(jobList.NewOriginalMaster__c && jobList.NewOriginalMasterInStore__c && !jobList.NewOriginalMasterInStoreMovingImage__c && 
            !jobList.NewOriginalMasterInStoreAudio__c && !jobList.NewOriginalMasterInStoreStillImage__c  ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_NewOrigiMastat_least_one_option_of_Medium_mustbe_selected_corresto_instore));
            okayToSaveCheck =false;
        }
      if(jobList.NewOriginalMaster__c && !jobList.NewOriginalMasterCinema__c && !jobList.NewOriginalMasterTv__c && 
            !jobList.NewOriginalMasterRadio__c && !jobList.NewOriginalMasterPrint__c && !jobList.NewOriginalMasterOutofHome__c &&
                !jobList.NewOriginalMasterInStore__c && !jobList.NewOriginalMasterDigital__c && !jobList.NewOriginalMasterInternalVideo__c ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_For_New_Original_Masterat_least_one_option_of_Media_Channel_must_be_selected   ));
            okayToSaveCheck =false;
        }
       if(jobList.NewOriginalMaster__c && jobList.NewOriginalMasterOutofHome__c && !jobList.NewOriginalMasterOutofHomeMovingImage__c && 
            !jobList.NewOriginalMasterOutofHomeAudio__c && !jobList.NewOriginalMasterOutofHomeStillImage__c  ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_NewOriginMaster_at_leastoneoption_ofMedium_mustbe_selected_corres_to_outOfHo));
            okayToSaveCheck =false;
        }
       if(jobList.NewOriginalMaster__c && jobList.NewOriginalMasterInStore__c && !jobList.NewOriginalMasterInStoreMovingImage__c && 
            !jobList.NewOriginalMasterInStoreAudio__c && !jobList.NewOriginalMasterInStoreStillImage__c  ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_NewOrigiMastat_least_one_option_of_Medium_mustbe_selected_corresto_instore));
            okayToSaveCheck =false;
        }
    if(jobList.NewOriginalMaster__c && jobList.NewOriginalMasterDigital__c && !jobList.NewOriginalMasterDigitalMovingImage__c && 
            !jobList.NewOriginalMasterDigitalAudio__c && !jobList.NewOriginalMasterDigitalStillImage__c  
            && !jobList.New_Original_Master_Digital_ED__c){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_NewOriginMaster_at_least_one_option_of_Medium_mustbeselected_corre_todigital));
            okayToSaveCheck =false;
        }
      if(!jobList.NewOriginalMaster__c && jobList.LanguageAdaptionMaster__c && !jobList.LanguageAdaptionMasterTv__c && 
            !jobList.LanguageAdaptionMasterCinema__c && !jobList.LanguageAdaptionMasterRadio__c 
            && !jobList.LanguageAdaptionMasterPrint__c && 
                !jobList.LanguageAdaptionMasterOutofHome__c && 
                !jobList.LanguageAdaptionMasterInStore__c && 
                !jobList.LanguageAdaptionMasterDigital__c &&
                !jobList.LanguageAdaptionMasterInternalVideo__c ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_Language_Adaption_Master_at_least_one_option_of_Medium_must_be_selected));
            okayToSaveCheck =false;
        }
       if(!jobList.NewOriginalMaster__c && jobList.LanguageAdaptionMaster__c && jobList.LanguageAdaptionMasterOutofHome__c && 
            !jobList.LanguageAdaptionMasterOutofHomeAudio__c && 
            !jobList.LanguageAdaptionMasterOutHomeStillImage__c && 
            !jobList.LanguageAdaptionMasterOutHomeMovingImage__c 
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_LangAdaptMaster_atleast_one_option_of_Medium_mustbe_selected_correTo_OutO));
            okayToSaveCheck =false;
        }
       if(!jobList.NewOriginalMaster__c && jobList.LanguageAdaptionMaster__c && jobList.LanguageAdaptionMasterInStore__c && 
            !jobList.LanguageAdaptionMasterInStoreAudio__c && 
            !jobList.LanguageAdaptionMasterInStoreMovingImage__c && 
            !jobList.LanguageAdaptionMasterInStoreStillImage__c 
            
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_LangAdaptMaster_atleast_oneoption_of_Medium_mustbe_selectedcorres_in_st));
            okayToSaveCheck =false;
        }
       if(!jobList.NewOriginalMaster__c && jobList.LanguageAdaptionMaster__c && jobList.LanguageAdaptionMasterDigital__c && 
            !jobList.LanguageAdaptionMasterDigitalAudio__c && 
            !jobList.LanguageAdaptionMasterDigitalMovingImage__c && 
            !jobList.LanguageAdaptionMasterDigitalStillImage__c && !jobList.Language_Adaptation_of_Master_Digital_ED__c
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_LanguageAdaptionMaster_least_one_optionofMedium_mustbe_selected_corr_to_Digi));
            okayToSaveCheck =false;
        }
       if(!jobList.NewOriginalMaster__c && jobList.Create_Additional_Material__c && jobList.AdditionalSupplementaryNewMaterialOOH__c && 
            !jobList.AdditionalSupplementaryNewMaterialOofHMI__c && 
            !jobList.AdditionalSupplementaryNewMaterialOofHSI__c && 
            !jobList.AdditionalSupplementaryNewMaterialOofHA__c  
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_AdditiSuppNewMaterial_atleast_one_optionofMedium_mustbe_selected_corr_toou));
            okayToSaveCheck =false;
        }
        if(!jobList.NewOriginalMaster__c && jobList.Create_Additional_Material__c && jobList.AdditionalSupplementaryNewMaterialStore__c && 
            !jobList.AdditionalSupplementaryNewMaterialInSMI__c && 
            !jobList.AdditionalSupplementaryNewMaterialInSA__c && 
            !jobList.AdditionalSupplementaryNewMaterialInSSI__c  
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_AdditSuppNewMaterial_at_least_one_optionofMedium_mustbeselect_cor_toinstore));
            okayToSaveCheck =false;
        }
          if(!jobList.NewOriginalMaster__c && jobList.Create_Additional_Material__c && jobList.AdditionalSupplementaryNewMaterialDigi__c && 
            !jobList.AdditionalSupplementaryNewMaterialDigiMI__c && 
            !jobList.AdditionalSupplementaryNewMaterialDigiA__c && 
            !jobList.AdditionalSupplementaryNewMaterialDigiSI__c  &&
            !jobList.Digital_Editorial__c 
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_AddiSuppNewMaterial_atleast_oneoptionofMedium_must_be_selected_corr_to_Dig));
            okayToSaveCheck =false;
        }
        if(!jobList.NewOriginalMaster__c && jobList.Create_Additional_Material__c &&  
            !jobList.AdditionalSupplementaryNewMaterialStore__c && 
            !jobList.AdditionalSupplementaryNewMaterialDigi__c &&
            !jobList.AdditionalSupplementaryNewMaterialTv__c &&
            !jobList.AdditionalSupplementaryNewMaterialCinema__c &&
            !jobList.AdditionalSupplementaryNewMaterialRadio__c &&
            !jobList.AdditionalSupplementaryNewMaterialOOH__c &&
            !jobList.AdditionalSupplementaryNewMaterialIVideo__c
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_AdditionalSupplNewMaterial_atleast_oneoptionof_MedChannel_mustbe_sel));
            okayToSaveCheck =false;
        }
          if(!jobList.NewOriginalMaster__c && jobList.ReworkExistingMaterial__c && jobList.ReworkExistingMaterialOutofHome__c && 
            !jobList.ReworkExistingMaterialOutHomeMovingImage__c && 
            !jobList.ReworkExistingMaterialOutofHomeAudio__c && 
            !jobList.ReworkExistingMaterialOutHomeStillImage__c
            
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_RewExistingMat_at_least_one_optionofMedium_mustbe_selected_corr_to_OOH));
            okayToSaveCheck =false;
        }
          if(!jobList.NewOriginalMaster__c && jobList.ReworkExistingMaterial__c && jobList.ReworkExistingMaterialInStore__c && 
            !jobList.ReworkExistingMaterialInStoreMovingImage__c && 
            !jobList.ReworkExistingMaterialInStoreAudio__c && 
            !jobList.In_Store_Still_Image__c
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_ReworkExistMater_atleast_oneoption_of_Medium_mustbeselected_corr_to_inStor));
            okayToSaveCheck =false;
        }
          if(!jobList.NewOriginalMaster__c && jobList.ReworkExistingMaterial__c && jobList.ReworkExistingMaterialDigital__c && 
            !jobList.ReworkExistingMaterialDigitalMovingImage__c && 
            !jobList.ReworkExistingMaterialDigitalAudio__c && 
            !jobList.ReworkExistingMaterialDigitalStillImage__c  &&
            !jobList.Rework_Exisiting_Material_Digital_ED__c 
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_RewExistMaterial_atleastone_option_of_Medium_must_be_selected_corr_to_Digi));
            okayToSaveCheck =false;
        }
          if(!jobList.NewOriginalMaster__c && jobList.ReworkExistingMaterial__c && !jobList.ReworkExistingMaterialOutofHome__c && 
            !jobList.ReworkExistingMaterialInStore__c && 
            !jobList.ReworkExistingMaterialDigital__c 
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_ReworkExistMat_atleast_oneoption_of_Media_Channel_mustbe_selected));
            okayToSaveCheck =false;
        }
            if(!jobList.NewOriginalMaster__c && jobList.BuyoutsTalent__c && jobList.BuyoutsTalentOutofHome__c && 
            !jobList.BuyoutsTalentOutofHomeMovingImage__c && 
            !jobList.BuyoutsTalentOutofHomeAudio__c && 
            !jobList.BuyoutsTalentOutofHomeStillImage__c
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_Buyouts_Talent_atleast_one_optionofMedium_mustbe_selected_corr_to_OOH));
            okayToSaveCheck =false;
        }
        if(!jobList.NewOriginalMaster__c && jobList.BuyoutsTalent__c && jobList.BuyoutsTalentInStore__c && 
            !jobList.BuyoutsTalentInStoreMovingImage__c && 
            !jobList.BuyoutsTalentInStoreAudio__c && 
            !jobList.BuyoutsTalentInStoreStillImage__c
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_BuyoutsTalent_at_least_oneoptionofMedium_mustbe_selected_corre_to_Instore));
            okayToSaveCheck =false;
        }
         if(!jobList.NewOriginalMaster__c && jobList.BuyoutsTalent__c && jobList.BuyoutsTalentDigital__c && 
            !jobList.BuyoutsTalentDigitalMovingImage__c && 
            !jobList.BuyoutsTalentDigitalAudio__c && 
            !jobList.BuyoutsTalentDigitalStillImage__c &&
            !jobList.Buyouts_Talent_Digital_ED__c
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_BuyTalent_atleastoneoption_of_Medium_mustbe_selected_corr_to_Digital));
            okayToSaveCheck =false;
        }
          if(!jobList.NewOriginalMaster__c && jobList.BuyoutsTalent__c && !jobList.BuyoutsTalentOutofHome__c && 
            !jobList.BuyoutsTalentInStore__c && 
            !jobList.BuyoutsTalentDigital__c 
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_Buyouts_Talent_at_least_one_option_of_Media_Channel_must_be_selected));
            okayToSaveCheck =false;
        }
        if(!jobList.NewOriginalMaster__c && jobList.BuyoutsMusic__c && jobList.BuyoutsMusicOutofHome__c && 
            !jobList.BuyoutsMusicOutofHomeMovingImage__c && 
            !jobList.BuyoutsMusicOutofHomeAudio__c && 
            !jobList.BuyoutsMusicOutofHomeStillImage__c
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_BuyoutMusic_at_least_one_option_of_Medium_mustbe_selected_corre_to_OutOfHome));
            okayToSaveCheck =false;
        }
         if(!jobList.NewOriginalMaster__c && jobList.BuyoutsMusic__c && !jobList.BuyoutsMusicInStore__c && 
            !jobList.BuyoutsMusicDigital__c && 
            !jobList.BuyoutsMusicTv__c &&
            !jobList.BuyoutsMusicCinema__c &&
            !jobList.BuyoutsMusicRadio__c &&
            !jobList.BuyoutsMusicInternalVideo__c &&
            !jobList.BuyoutsMusicOutofHome__c
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_For_Buyouts_Music_at_least_one_option_of_Media_Channel_must_be_selected));
            okayToSaveCheck =false;
        }
        if(!jobList.NewOriginalMaster__c && jobList.BuyoutsMusic__c && jobList.BuyoutsMusicInStore__c && 
            !jobList.BuyoutsMusicInStoreMovingImage__c && 
            !jobList.BuyoutsMusicInStoreAudio__c && 
            !jobList.BuyoutsMusicInStoreStillImage__c
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_Buyouts_Music_at_least_one_option_of_Medium_mustbe_selected_corr_to_Instore));
            okayToSaveCheck =false;
        }
            if(!jobList.NewOriginalMaster__c && jobList.BuyoutsMusic__c && jobList.BuyoutsMusicDigital__c && 
            !jobList.BuyoutsMusicDigitalMovingImage__c && 
            !jobList.BuyoutsMusicDigitalAudio__c && 
            !jobList.BuyoutsMusicDigitalStillImage__c  &&
            !jobList.Buyouts_Music_Digital_ED__c
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_Buyouts_Music_at_least_one_option_of_Medium_must_be_selected_corre_to_Digita));
            okayToSaveCheck =false;
        }
         return okayToSaveCheck;
   }
   
    /***********************************************************************************************************************************
Purpose:  This method contains the logic to cancel the job and is called from 
        both CAP and RAP cancel job method.
Parameters: 
Returns: 

************************************************************************************************************************************/   
       
    public void jobCancellation(Amr_Job_Details__c jobDetail, String jobId, Amr_Job_Allocation__c jobAlloc,String ownerIdOfSelectedJob){
       try{
        
     //   List<String> toEmailAddress = new List<String>();
        List<Amr_Job_Allocation__c> jbAlloc  = [select Id,Name,User__c,Job_Status__c  from Amr_Job_Allocation__c where AM_Job_Detail__c = :jobId AND Is_Primary__c = TRUE ];
        jobDetail.Job_Cancelled__c = TRUE;
        if(jbAlloc != null && !jbAlloc.isEmpty() ){
        jbAlloc[0].Job_Status__c = Label.Amr_Job_Cancelled;
            update jbAlloc;
        }
        List<Amr_Job_Allocation__c> canceledJobList = [select id, Is_Primary__c from Amr_Job_Allocation__c where AM_Job_Detail__c = :jobId And Is_Primary__c = false];
        
        List<Amr_Job_Allocation__c> jbAllocCancel = new List<Amr_Job_Allocation__c> ();
        if(!canceledJobList.isEmpty()){
            for(Amr_Job_Allocation__c obj : canceledJobList){
                obj.Job_Status__c = Label.Amr_Job_Cancelled;
                jbAllocCancel.add(obj);
                
            }
             update jbAllocCancel;
            
        }
        List<Amr_Job_Details__Share> cancelShareList = [Select Id from Amr_Job_Details__Share where id = :jobId AND  UserOrGroupId != :ownerIdOfSelectedJob];
        
        if(!cancelShareList.isEmpty()){
            delete cancelShareList; 
        }
        

        update jobDetail;
    
       }catch(Exception e){
       system.debug(e.getmessage());
       
       }
    }
    
    /***********************************************************************************************************************************
Purpose:Method to update Ad Manager number, if Brand name is being Updated
Parameters: 
Returns: 

************************************************************************************************************************************/
     
    public void updateAdManagerText(Amr_job_details__c jobList,String brandNameFromPage){

        String adManText = jobList.AdManagerText__c;
        String adManTextUpdatedStr = adManText.Right(6);
        String brandUpdatedNameStr =brandNameFromPage.left(3);
        String finalAdManagerNumber = brandUpdatedNameStr + adManTextUpdatedStr ;
        jobList.AdManagerText__c = finalAdManagerNumber;
        
    }
    
   
   
   }