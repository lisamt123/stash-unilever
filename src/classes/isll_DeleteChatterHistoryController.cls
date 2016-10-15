/**********************************************************************
 Name:  isll_DeleteChatterHistoryController
 Copyright © 2013  Unilever
 ======================================================
======================================================
Purpose:Manages My Library part of ISLL                                                            
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                      Description
 1.0 -   Shyam Bhundia     31/07/2013        INITIAL DEVELOPMENT         Story id:USLL-180   	
 
***********************************************************************/
public with sharing class isll_DeleteChatterHistoryController {
	
	public PageReference deleteAllChatterHistory(){
		List<Chatter_History__c> chatterHistory = [select id from Chatter_History__c];
		if(chatterHistory.isEmpty()){
			//no feeds to delete
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,'No Chatter history to delete'));
		}
		else{
			boolean isSucessful;
			try{
				delete chatterHistory;
				ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Chatter history cleared'));		
			}
			catch (DmlException e){
				ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error clearing Chatter history'));
			}
		}
		return null;
	}
}