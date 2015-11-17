/**
* @author:Cognizant
* @date:06/05/2015
* @description:Trigger Handler for the IPM_Company_Card__c SObject. This class implements the ITrigger
* interface to help ensure the trigger code is bulkified and all in one place.
*/
public with sharing class IPM_CompanyCardHandler implements ITrigger{   
   /* List<IPM_Company_Card__Share> IPMCCard  = new List<IPM_Company_Card__Share>();
    List<IPM_Company_Card__Share> IPMCCardDelete  = new List<IPM_Company_Card__Share>();
    IPM_Company_Card__Share CCard; */
    set<id>changedBP=new set<id>();
    map<id,id>BPtoCCuser=new map<id,id>();
    map<id,id>oldBPuser=new map<id,id>();
	final String IPM_COMPANY_CARD_HANDLER = 'IPMCompanyCardHandler';
	private static final string BULK_AFTER = 'bulkAfter';

    // Constructor
    public IPM_CompanyCardHandler (){
    	ExceptionLoggingHelper.initializeExceptionLog(); 
    }
    
    
    /**
    * @description:bulkBefore
    * This method is called prior to execution of a BEFORE trigger. Use this to cache
    * any data required into maps prior execution of the trigger.
    */
    public void bulkBefore(){
        if(trigger.isDelete){
           // List<IPM_Company_Card__Share> IPMCCardDelete  = new List<IPM_Company_Card__Share>();
            set<id>changedBP=new set<id>();
            for(IPM_Company_Card__c ipmCard:(list<IPM_Company_Card__c>)trigger.old){
                if(ipmCard.IPM_Business_Partner__c !=null){
                    changedBP.add(ipmCard.IPM_Business_Partner__c );
                    BPtoCCuser.put(ipmCard.id,ipmCard.IPM_Business_Partner__c);
                }   
            }
            if(BPtoCCuser != NULL && !BPtoCCuser.isEmpty()){
               // IPM_PermissionSet.DeleteBPPermission(BPtoCCuser);
                //IPM_PermissionSet.DeleteShareWithBP(BPtoCCuser);
            }
            if(changedBP != NULL && !changedBP.isEmpty()){
               // IPMCCardDelete=[SELECT id FROM IPM_Company_Card__Share WHERE UserOrGroupid IN:changedBP Limit 50000];
                /*if(IPMCCardDelete != NULL && !IPMCCardDelete.isEmpty()){
                    try{
                        delete IPMCCardDelete;
                    }
                    catch(exception ex){
                        ExceptionLoggingHelper.createErrorLogofIPM(UserInfo.getUserId(),IPM_COMPANY_CARD_HANDLER,
            				'bulkBefore',ex.getMessage(),ex, 'Error', null, null, null); 
                    }
                }*/
            }  
        } 
    }
    /** 
    * @description:bulkAfter
    * This method is called prior to execution of a AFTER trigger. Use this to cache
    * any data required into maps prior execution of the trigger.
    */
    public void bulkAfter(){
        if(trigger.Isinsert){
           /* List<IPM_Company_Card__Share> IPMCCard  = new List<IPM_Company_Card__Share>();
            IPM_Company_Card__Share CCard; */
            
            for(IPM_Company_Card__c ipmCard:(list<IPM_Company_Card__c>)trigger.new){
                if(ipmCard.IPM_Business_Partner__c !=null){
                   /* CCard=new IPM_Company_Card__Share();
                    CCard.parentid=ipmCard.id;
                    CCard.UserOrGroupid=ipmCard.IPM_Business_Partner__c;
                    CCard.Accesslevel=IPM_ConstantUtils.READ_ACCESS;
                    IPMCCard.add(CCard);*/
                    BPtoCCuser.put(ipmCard.id,ipmCard.IPM_Business_Partner__c);
                }
            }
            if(BPtoCCuser != NULL && !BPtoCCuser.isEmpty()){
             //   IPM_PermissionSet.addPermissionToBP(BPtoCCuser);
             //   IPM_PermissionSet.ShareWithBP(BPtoCCuser);
            }
           /* if(IPMCCard != NULL && !IPMCCard.isEmpty())
                try{
                    insert IPMCCard;
                }
            catch(exception ex){
                ExceptionLoggingHelper.createErrorLogofIPM(UserInfo.getUserId(),IPM_COMPANY_CARD_HANDLER,
            		BULK_AFTER,ex.getMessage(),ex, 'Error', null, null, null); 
            } */
        }
        
        if(trigger.isUpdate){
           /* List<IPM_Company_Card__Share> IPMCCard  = new List<IPM_Company_Card__Share>();
            List<IPM_Company_Card__Share> IPMCCardDelete  = new List<IPM_Company_Card__Share>(); */
            set<id>changedBP=new set<id>();
            //IPM_Company_Card__Share CCard;
            for(sobject ipmCard:trigger.new){
                IPM_Company_Card__c copmcard=(IPM_Company_Card__c )ipmCard;
                IPM_Company_Card__c  oldcopmcard = (IPM_Company_Card__c )trigger.oldMap.get(copmcard.Id) ;
              /*  if(copmcard.IPM_Business_Partner__c !=null){
                    if(oldcopmcard.IPM_Business_Partner__c !=copmcard.IPM_Business_Partner__c ){
                        string BPuser=oldcopmcard.IPM_Business_Partner__c ;
                        changedBP.add(BPuser);
                        CCard=new IPM_Company_Card__Share();
                        CCard.parentid=copmcard.id;
                        CCard.UserOrGroupid=copmcard.IPM_Business_Partner__c ;
                        CCard.Accesslevel=IPM_ConstantUtils.READ_ACCESS;
                        IPMCCard.add(CCard);
                        BPtoCCuser.put(copmcard.id,copmcard.IPM_Business_Partner__c);
                        oldBPuser.put(copmcard.id,oldcopmcard.IPM_Business_Partner__c);
                    }
                } */
            }
            if(BPtoCCuser != NULL && !BPtoCCuser.isEmpty()){
              //  IPM_PermissionSet.addPermissionToBP(BPtoCCuser);
               // IPM_PermissionSet.DeleteBPPermission(oldBPuser);
               // IPM_PermissionSet.ShareWithBP(BPtoCCuser);
               // IPM_PermissionSet.DeleteShareWithBP(oldBPuser);
            }
            /* try{
                if(IPMCCard != NULL && !IPMCCard.isEmpty())
                    insert IPMCCard;
            }  
            catch(exception ex){
                ExceptionLoggingHelper.createErrorLogofIPM(UserInfo.getUserId(),IPM_COMPANY_CARD_HANDLER,
            		BULK_AFTER,ex.getMessage(),ex, 'Error', null, null, null); 
            } */
            if(changedBP != NULL && !changedBP.isEmpty()){
                /*IPMCCardDelete=[SELECT id FROM IPM_Company_Card__Share WHERE UserOrGroupid IN:changedBP limit 50000];
                if(IPMCCardDelete != NULL && !IPMCCardDelete.isEmpty()){
                    try{
                        delete IPMCCardDelete;
                    }
                    catch(exception ex){
                        ExceptionLoggingHelper.createErrorLogofIPM(UserInfo.getUserId(),IPM_COMPANY_CARD_HANDLER,
            				BULK_AFTER,ex.getMessage(),ex, 'Error', null, null, null); 
                    } 
                    
                }*/
            }
            
        }
        
    }
    /**
    * @description:beforeInsert
    * This method is called iteratively for each record to be insert during a AFTER
    * trigger.
    * @para:sobject record
    */    
    public void beforeInsert(SObject so){
		//This method has been included as the class implements the ITrigger interface
    }
    /**
    * @description:beforeUpdate
    * This method is called iteratively for each record to be update during a BEFORE
    * trigger.
    * @para:old sobject record
    * @para:new sobject record
    */
    public void beforeUpdate(SObject oldSo, SObject so){   
		//This method has been included as the class implements the ITrigger interface
    }
    
    /**
    * @description:beforeDelete
    * This method is called iteratively for each record to be deleted during a BEFORE
    * trigger.
    */
    public void beforeDelete(SObject so){      
		//This method has been included as the class implements the ITrigger interface
    }
    /**
    * @description:afterInsert
    * This method is called iteratively for each record to be insert during a AFTER
    * trigger.
    * @para:sobject record
    */
    public void afterInsert(SObject so){
		//This method has been included as the class implements the ITrigger interface
    }
    /**
    * @description:afterUpdate
    * This method is called iteratively for each record to be update during a AFTER
    * trigger.
    * @para:old sobject record
    * @para:new sobject record
    */
    public void afterUpdate(SObject oldSo, SObject so){   
		//This method has been included as the class implements the ITrigger interface
    }
    /**
    * @description:afterDelete
    * This method is called iteratively for each record to be delete during a AFTER
    * trigger.
    * @para:sobject record
    */
    public void afterDelete(SObject so){
		//This method has been included as the class implements the ITrigger interface
    }
    
    /**
    * @description:andFinally
    * This method is called once all records have been processed by the trigger. Use this 
    * method to accomplish any final operations such as creation or updates of other records.
    */
    public void andFinally(){
		//Added by Devendra - call method to insert all exception logs got while excecution of trigger	 
		ExceptionLoggingHelper.insertLogRecordList();
    }
}