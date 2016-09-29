/**********************************************************************
 Name:  CPA_attachment_Trigger_Handler()
 Copyright © 2016  Unilever
 ======================================================
======================================================
Purpose: Trigger Handler for the CPA_HLE_Request__c SObject. This class implements the ITrigger
 interface to help ensure the trigger code is bulkified and all in one place.                                                      
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR                      DATE              DETAIL                 Description
   1.0   Shreyas Mangalvedhekar      03/04/2016        INITIAL DEVELOPMENT           
***********************************************************************/

public with sharing class CPA_attachment_Trigger_Handler
    implements CPA_Interface_Trigger
{   
    
   CPA_Trigger_Pattern__c objAttachmentPattern = CPA_Trigger_Pattern__c.getValues(CPA_ConstantsForContractingAppClasses.ATTACHMENTTRIGERNAME);
    
    boolean triggerShouldExecute = objAttachmentPattern.chk_Check_Run__c;
    
    // Constructor
    public CPA_attachment_Trigger_Handler()
    {
    }

    /**
     * bulkBefore
     *
     * This method is called prior to execution of a BEFORE trigger. Use this to cache
     * any data required into maps prior execution of the trigger.
     */
    public void bulkBefore()
    {   
        System.debug('Entering CPA_attachment_Trigger_Handler.bulkBefore');     
        System.debug('Exiting CPA_attachment_Trigger_Handler.bulkBefore');
        
    }
    
    public void bulkAfter()
    {
        System.debug('Entering CPA_attachment_Trigger_Handler.bulkAfter');     
        System.debug('Exiting CPA_attachment_Trigger_Handler.bulkAfter');
        
    }
        
    public void beforeInsert(SObject so)
    {
        System.debug('Entering CPA_attachment_Trigger_Handler.beforeInsert');     
        System.debug('Exiting CPA_attachment_Trigger_Handler.beforeInsert');
        
    }
    
    public void beforeUpdate(SObject oldSo, SObject so)
    {
         System.debug('Entering CPA_attachment_Trigger_Handler.beforeUpdate');     
        System.debug('Exiting CPA_attachment_Trigger_Handler.beforeUpdate');
        
    }
    

    public void beforeDelete(SObject so)
    {   
        List<Attachment> lstAttachmentRead = new List<Attachment>();
        List<Attachment> lstAttachmentRead1 = new List<Attachment>();
        List<Attachment> lstAttachmentLOI = new List<Attachment>();
        
        for(sobject objAtt : trigger.old){
            Attachment objAttachemt = (Attachment)objAtt;
            string srtTemp = objAttachemt.ParentId;
            if(objAttachemt !=null && objAttachemt.Name.startswith('Commercial') &&(srtTemp.startswith(CPA_ConstantsForContractingAppClasses.CPA_PWO_OBJECT_ID ) || srtTemp.startswith(CPA_ConstantsForContractingAppClasses.CPA_CR_ID)) ){
                    lstAttachmentRead.add(objAttachemt);
            }
          if(objAttachemt !=null && objAttachemt.ContentType!=null && objAttachemt.ContentType.contains('pdf')  &&(srtTemp.startswith(CPA_ConstantsForContractingAppClasses.CPA_PWO_OBJECT_ID ) || srtTemp.startswith(CPA_ConstantsForContractingAppClasses.CPA_CR_ID)) ){
         
                 lstAttachmentRead1.add(objAttachemt);
             }
             if(objAttachemt !=null &&  srtTemp.startswith(CPA_ConstantsForContractingAppClasses.CPA_LOI_ID) && objAttachemt.ContentType.contains('pdf') && objAttachemt.Name.startswith('LOI') ){
                 
                 lstAttachmentLOI.add(objAttachemt);
             }
            
        }
        IF(lstAttachmentRead!= NULL && lstAttachmentRead.size()>0){
            CPA_AttachmentUtil.deleteCommericalData(lstAttachmentRead);
        }
        if(lstAttachmentRead1 != null && lstAttachmentRead1.size()>0){
            CPA_AttachmentUtil.deleteContract(lstAttachmentRead1);
        }
        if(lstAttachmentLOI !=null && lstAttachmentLOI.size()>0){
            CPA_AttachmentUtil.DeleteLOI(lstAttachmentLOI);
        }
        
        
        
    }
    
    public void afterInsert(SObject so) 
    {
        if(triggerShouldExecute){
            List<Attachment> lstAttachment = new List<Attachment>();
            List<Attachment> lstAttachmentCR = new List<Attachment>();
            List<Attachment> lstAttachmentRead = new List<Attachment>();
            List<Attachment> lstAttachmentLOI = new List<Attachment>();
            set<Id> setParentId = new set<Id>();
            
            for(sobject objAtt : trigger.new){
                Attachment objAttachemt = (Attachment)objAtt;
                string srtTemp = objAttachemt.ParentId;
                if((srtTemp.startswith(CPA_ConstantsForContractingAppClasses.CPA_PWO_OBJECT_ID ) || srtTemp.startswith(CPA_ConstantsForContractingAppClasses.CPA_CR_ID)) ){
                        lstAttachmentRead.add(objAttachemt);
                        if(srtTemp.startswith(CPA_ConstantsForContractingAppClasses.CPA_PWO_OBJECT_ID ))
                            lstAttachment.add(objAttachemt);
                        if (srtTemp.startswith(CPA_ConstantsForContractingAppClasses.CPA_CR_ID))
                            lstAttachmentCR.add(objAttachemt);
                       
                        setParentId.add(objAttachemt.ParentId);
                }
                
                 if(srtTemp.startswith(CPA_ConstantsForContractingAppClasses.CPA_LOI_ID) && objAttachemt.ContentType.contains('pdf') && objAttachemt.Name.startswith('LOI') ){
                            lstAttachmentLOI.add(objAttachemt);
                }
                
            }
            if(lstAttachmentRead!=null && lstAttachmentRead.size()>0){
                CPA_AttachmentUtil.ReadFile(lstAttachmentRead[0]);
            }
            if(lstAttachment!=null && lstAttachment.size()>0){
               CPA_AttachmentUtil.updateCPAPWO(lstAttachment,setParentId);
               
            }
            if(lstAttachmentCR!=null && lstAttachmentCR.size()>0){
            
              CPA_AttachmentUtil.updateCPACR(lstAttachmentCR,setParentId);
            }
            if(lstAttachmentLOI != null && lstAttachmentLOI.size()>0){
                CPA_AttachmentUtil.updateLOI(lstAttachmentLOI);
            }
            
        }
        
    }
    
    public void afterUpdate(SObject oldSo, SObject so)
    {
        System.debug('Entering CPA_attachment_Trigger_Handler.afterUpdate');     
        System.debug('Exiting CPA_attachment_Trigger_Handler.afterUpdate');
        
    }
    /*******************************************************************
    Purpose: This method is present in interface, hence need to override here
    Parameters: SObject
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public void afterDelete(SObject so)
    {
        System.debug('This method is present in interface, hence need to override here');
    }
    
    /**
     * andFinally
     *
     * This method is called once all records have been processed by the trigger. Use this 
     * method to accomplish any final operations such as creation or updates of other records.
     */
    public void andFinally()
    {
        System.debug('Entering CPA_attachment_Trigger_Handler.andFinally');     
        System.debug('Exiting CPA_attachment_Trigger_Handler.andFinally');
    }

}