trigger CAP_AfterAttachment on Attachment (after insert, before delete) {
    
    if(trigger.isafter && trigger.isinsert ){
        List<Attachment> lstAttachment = new List<Attachment>();
        List<Attachment> lstAttachmentRead = new List<Attachment>();
        set<Id> setParentId = new set<Id>();
        
        for(Attachment objAttachemt : trigger.new){
            string srtTemp = objAttachemt.ParentId;
            if(srtTemp.startswith(label.CAP_ParentId_For_Attachment_trigger)){
                lstAttachment.add(objAttachemt);
                setParentId.add(objAttachemt.ParentId);
                
            }
            if(objAttachemt.Name.startswith('Commercial') &&(srtTemp.startswith(label.CAP_ParentId_For_Attachment_trigger) || srtTemp.startswith(label.CAP_ParentId_For_Attachment_CR)) ){
                    lstAttachmentRead.add(objAttachemt);
            }
            
        }
        CPA_AttchemntUnit.updateCPAPWO(lstAttachment,setParentId);
        
        
        CPA_AttchemntUnit.ReadFile(lstAttachmentRead);
    }
    if(trigger.isbefore && trigger.isdelete){
        List<Attachment> lstAttachmentRead = new List<Attachment>();
        for(Attachment objAttachemt : trigger.old){
            string srtTemp = objAttachemt.ParentId;
            if(objAttachemt.Name.startswith('Commercial') &&(srtTemp.startswith(label.CAP_ParentId_For_Attachment_trigger) || srtTemp.startswith(label.CAP_ParentId_For_Attachment_CR)) ){
                    lstAttachmentRead.add(objAttachemt);
            }
            
        }
        CPA_AttchemntUnit.deleteCommericalData(lstAttachmentRead);
    }
}