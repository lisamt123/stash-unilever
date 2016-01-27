trigger CAP_AfterAttachment on Attachment (after insert) {
    
    if(trigger.isafter && trigger.isinsert ){
        List<Attachment> lstAttachment = new List<Attachment>();
        set<Id> setParentId = new set<Id>();
        
        for(Attachment objAttachemt : trigger.new){
            string srtTemp = objAttachemt.ParentId;
            if(srtTemp.startswith(label.CAP_ParentId_For_Attachment_trigger)){
                lstAttachment.add(objAttachemt);
                setParentId.add(objAttachemt.ParentId);
            }
        }
        CPA_AttchemntUnit.updateCPAPWO(lstAttachment,setParentId);
        
    }
}