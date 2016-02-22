trigger CAP_AfterAttachment on Attachment (after insert, before delete) {
    
    if(trigger.isafter && trigger.isinsert ){
        List<Attachment> lstAttachment = new List<Attachment>();
        List<Attachment> lstAttachmentCR = new List<Attachment>();
        List<Attachment> lstAttachmentRead = new List<Attachment>();
        List<Attachment> lstAttachmentLOI = new List<Attachment>();
        set<Id> setParentId = new set<Id>();
        
        for(Attachment objAttachemt : trigger.new){
            string srtTemp = objAttachemt.ParentId;
            if((srtTemp.startswith(label.CAP_ParentId_For_Attachment_trigger) || srtTemp.startswith(label.CAP_ParentId_For_Attachment_CR)) ){
                    lstAttachmentRead.add(objAttachemt);
                    if(srtTemp.startswith(label.CAP_ParentId_For_Attachment_trigger))
                        lstAttachment.add(objAttachemt);
                    if (srtTemp.startswith(label.CAP_ParentId_For_Attachment_CR))
                        lstAttachmentCR.add(objAttachemt);
                   
                    setParentId.add(objAttachemt.ParentId);
            }
            system.debug(' objAttachemt.Name-->'+ objAttachemt.Name);
            system.debug(' objAttachemt.ContentType-->'+objAttachemt.ContentType);
             if(srtTemp.startswith(label.CAP_ParentId_For_Attachment_LOI) && objAttachemt.ContentType.contains('pdf') && objAttachemt.Name.startswith('LOI') ){
                        lstAttachmentLOI.add(objAttachemt);
            }
            
        }
        CPA_AttchemntUnit.ReadFile(lstAttachmentRead);
        if(lstAttachment!=null && lstAttachment.size()>0){
           CPA_AttchemntUnit.updateCPAPWO(lstAttachment,setParentId);
           system.debug('Update for PWO-->'+ lstAttachment);
        }
        if(lstAttachmentCR!=null && lstAttachmentCR.size()>0){
        system.debug('Update for CR--> '+lstAttachmentCR);
          CPA_AttchemntUnit.updateCPACR(lstAttachmentCR,setParentId);
        }
        if(lstAttachmentLOI != null && lstAttachmentLOI.size()>0){
            CPA_AttchemntUnit.updateLOI(lstAttachmentLOI);
        }
    }
    if(trigger.isbefore && trigger.isdelete){
        List<Attachment> lstAttachmentRead = new List<Attachment>();
        List<Attachment> lstAttachmentRead1 = new List<Attachment>();
        List<Attachment> lstAttachmentLOI = new List<Attachment>();
        for(Attachment objAttachemt : trigger.old){
            string srtTemp = objAttachemt.ParentId;
            if(objAttachemt.Name.startswith('Commercial') &&(srtTemp.startswith(label.CAP_ParentId_For_Attachment_trigger) || srtTemp.startswith(label.CAP_ParentId_For_Attachment_CR)) ){
                    lstAttachmentRead.add(objAttachemt);
            }
          if(objAttachemt.ContentType.contains('pdf')  &&(srtTemp.startswith(label.CAP_ParentId_For_Attachment_trigger) || srtTemp.startswith(label.CAP_ParentId_For_Attachment_CR)) ){
                 lstAttachmentRead1.add(objAttachemt);
             }
             if(srtTemp.startswith(label.CAP_ParentId_For_Attachment_LOI) && objAttachemt.ContentType.contains('pdf') && objAttachemt.Name.startswith('LOI') ){
                 
                 lstAttachmentLOI.add(objAttachemt);
             }
            
        }
        CPA_AttchemntUnit.deleteCommericalData(lstAttachmentRead);
        CPA_AttchemntUnit.deleteContract(lstAttachmentRead1);
        CPA_AttchemntUnit.DeleteLOI(lstAttachmentLOI);
    }
}