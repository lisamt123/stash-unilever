/*
	Unilever

	Class Name: AR_AttachmentTransferClass

	Created by: Jan Schwetasch | 2013-09-19

	Description: Controller to Transfer Attachments

	Timeline
	Date 					| Name 				| Description
	2013-09-19				| Jan Schwetasch	| Initial development.
*/
public with sharing class AR_AttachmentTransferClass {
	@future
	public static void transferAttachments(Id p_AccountId,List<Id> ListAttachment)
    {
    	system.debug(logginglevel.info, '#Start attachment transfer...');
    	
    	system.debug(logginglevel.info, '#transferAttachments - p_AccountId: ' + p_AccountId);
    	system.debug(logginglevel.info, '#transferAttachments - ListAttachment: ' + ListAttachment);
    	
    	List<Attachment> tmp_insertList = new List<Attachment>();
    	for(Attachment a:[Select id,Body,Name,parentId from Attachment where Id IN:ListAttachment])
    	{
    		Attachment tmp_Att = a.clone(false,true,false,false);
    		tmp_Att.ParentId = p_AccountId;
    		tmp_insertList.add(tmp_Att);
    	}
    	
    	system.debug(logginglevel.info, '#transferAttachments - tmp_insertList: ' + tmp_insertList);
    	
    	insert tmp_insertList;
    }
}