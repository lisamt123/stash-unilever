trigger CPA_Attachment_Trigger on Attachment (after insert, before delete) {
    
   CPA_Trigger_Pattern__c objAttachmentPattern = CPA_Trigger_Pattern__c.getValues(CPA_ConstantsForContractingAppClasses.ATTACHMENTTRIGERNAME);
	if(objAttachmentPattern != null && objAttachmentPattern.chk_Check_Run__c){
   
	   if(trigger.isafter && trigger.isinsert ){
	        List<Attachment> lstAttachment = new List<Attachment>();
	        List<Attachment> lstAttachmentCR = new List<Attachment>();
	        List<Attachment> lstAttachmentRead = new List<Attachment>();
	        List<Attachment> lstAttachmentLOI = new List<Attachment>();
	        set<Id> setParentId = new set<Id>();
	        
	        for(Attachment objAttachemt : trigger.new){
	            string srtTemp = objAttachemt.ParentId;
	            if((srtTemp.startswith(label.CPA_ParentId_For_Attachment_trigger) || srtTemp.startswith(label.CPA_ParentId_For_Attachment_CR)) ){
	                    lstAttachmentRead.add(objAttachemt);
	                    if(srtTemp.startswith(label.CPA_ParentId_For_Attachment_trigger))
	                        lstAttachment.add(objAttachemt);
	                    if (srtTemp.startswith(label.CPA_ParentId_For_Attachment_CR))
	                        lstAttachmentCR.add(objAttachemt);
	                   
	                    setParentId.add(objAttachemt.ParentId);
	            }
	            system.debug(' objAttachemt.Name-->'+ objAttachemt.Name);
	            system.debug(' objAttachemt.ContentType-->'+objAttachemt.ContentType);
	             if(srtTemp.startswith(label.CPA_ParentId_For_Attachment_LOI) && objAttachemt.ContentType.contains('pdf') && objAttachemt.Name.startswith('LOI') ){
	                        lstAttachmentLOI.add(objAttachemt);
	            }
	            
	        }
	        if(lstAttachmentRead!=null && lstAttachmentRead.size()>0){
	            CPA_AttachmentUtil.ReadFile(lstAttachmentRead[0]);
	        }
	        if(lstAttachment!=null && lstAttachment.size()>0){
	           CPA_AttachmentUtil.updateCPAPWO(lstAttachment,setParentId);
	           system.debug('Update for PWO-->'+ lstAttachment);
	        }
	        if(lstAttachmentCR!=null && lstAttachmentCR.size()>0){
	        system.debug('Update for CR--> '+lstAttachmentCR);
	          CPA_AttachmentUtil.updateCPACR(lstAttachmentCR,setParentId);
	        }
	        if(lstAttachmentLOI != null && lstAttachmentLOI.size()>0){
	            CPA_AttachmentUtil.updateLOI(lstAttachmentLOI);
	        }
	    }
	    if(trigger.isbefore && trigger.isdelete){
	        List<Attachment> lstAttachmentRead = new List<Attachment>();
	        List<Attachment> lstAttachmentRead1 = new List<Attachment>();
	        List<Attachment> lstAttachmentLOI = new List<Attachment>();
	        for(Attachment objAttachemt : trigger.old){
	            string srtTemp = objAttachemt.ParentId;
	            if(objAttachemt.Name.startswith('Commercial') &&(srtTemp.startswith(label.CPA_ParentId_For_Attachment_trigger) || srtTemp.startswith(label.CPA_ParentId_For_Attachment_CR)) ){
	                    lstAttachmentRead.add(objAttachemt);
	            }
	          if(objAttachemt.ContentType.contains('pdf')  &&(srtTemp.startswith(label.CPA_ParentId_For_Attachment_trigger) || srtTemp.startswith(label.CPA_ParentId_For_Attachment_CR)) ){
	                 lstAttachmentRead1.add(objAttachemt);
	             }
	             if(srtTemp.startswith(label.CPA_ParentId_For_Attachment_LOI) && objAttachemt.ContentType.contains('pdf') && objAttachemt.Name.startswith('LOI') ){
	                 
	                 lstAttachmentLOI.add(objAttachemt);
	             }
	            
	        }
	        CPA_AttachmentUtil.deleteCommericalData(lstAttachmentRead);
	        CPA_AttachmentUtil.deleteContract(lstAttachmentRead1);
	        CPA_AttachmentUtil.DeleteLOI(lstAttachmentLOI);
	    }
	}
}