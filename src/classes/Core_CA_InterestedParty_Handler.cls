/*
Class Name: Core_CA_InterestedParty_Handler
Author : Mindtree
Date: 15 Oct 2014
Requirement/Project Name: Unilever Salesforce Engagement
Requirement/Description: This is a handler class which executes from trigger, This class is mainly used to
                        1. Update few fields -before insert
                        2. Give permission to specific users - Apex sharing -after insert
                        3. Trigger notification -after insert & after update
*/

/* -- SONAR Issue explanation -- 
    This is Handler class for the Trigger written on Approval Status object.When bunch of records are inserted by the external system with as a non-admin user, and If we use 'Sharing' keyword for this class.    
    For EntitySubscription SOQL max we can extract 1000 records as a non admin user but the query return more than 1000 records and we cannot exclude other records. We have included the Where cluase already. And following error is thrown     
    System.QueryException: Implementation restriction: EntitySubscription only allows security evaluation for non-admin users when LIMIT is specified and at most 1000
*/
 
public class Core_CA_InterestedParty_Handler{
    
    public static String strAribaTemp ='Ariba';
    public static String strGtesTemp ='GTES';
    public static String strClarityTemp ='Clarity';
    public static String strInvoiceTemp ='Invoice';
    public static String strAppTemp = 'APP';
    public static String strEndTemp = 'END';
    public static String strActvTemp ='ACTV';
    public static String strApprTemp = 'APPR';
    public static String strRejcTemp = 'REJC';
    public static String strxxxTemp ='XXX';//check 
    public static String stryyyTemp ='YYY';
    public static String strzzzTemp ='ZZZ';
    public static String straaaTemp ='AAA';
    public static String strLinkpstTemp ='LinkPost';
    public static String strTextValue = 'Yes' ;
    
    public void handleBeforeInsert(List<Core_Approver_Details__c > approverList){
        /* -- SONAR Issue explanation -- 
          When the Record is inserted by the External system depending on the Source System We are assigning the relevant record type to the record.
          there are 4 Recordtype for the approval status object.So its been retrived in the below code snippet 
        */
        String strApproverobjTemp ='Core_Approver_Details__c';
        List<RecordType> aribaRecordType  = [SELECT Id FROM RecordType where Name =: strAribaTemp AND SobjectType =: strApproverobjTemp];
        List<RecordType> gtesRecordType   = [SELECT Id FROM RecordType where Name =: strGtesTemp AND SobjectType =: strApproverobjTemp];
        List<RecordType> clarityRecordType  = [SELECT Id FROM RecordType where Name =: strClarityTemp AND SobjectType =: strApproverobjTemp];
        List<RecordType> invoiceRecordType   = [SELECT Id FROM RecordType where Name =: strInvoiceTemp AND SobjectType =: strApproverobjTemp];
             
        for(Core_Approver_Details__c approverRec : approverList){    
            
            //Fetching Record Type Id for Selected Source System.            
            if(approverRec.Source_System__c == strAribaTemp)
                approverRec.RecordTypeId = aribaRecordType[0].Id;
            if(approverRec.Source_System__c == strGtesTemp)
                approverRec.RecordTypeId = gtesRecordType[0].Id;
            if(approverRec.Source_System__c == strClarityTemp)
                approverRec.RecordTypeId = clarityRecordType[0].Id;
            if(approverRec.Source_System__c == strInvoiceTemp){
                approverRec.RecordTypeId = invoiceRecordType[0].Id;
                if(approverRec.Action__c== strActvTemp && approverRec.Status__c=='Return to AP')
                        approverRec.Status__c='';
                if(approverRec.Action__c== strActvTemp)
                        approverRec.Comments__c='';  
            }   
            
            //Updating Name field with Role.            
            approverRec.Name = approverRec.CA_Role__c;
        }
    }
    /* -- SONAR Issue explanation -- 
      This is handler class for trigger written for AfterInsert instance of Approval Status.
      Which has Follow/Unfollow logic, Apex sharing and Chatter notification code. 
      So multiple If else condition inside for loop to create chatter notification and multiple SOQL, DML are written thats leading to the Npath Complexity.  
    */
    public void handleAfterInsert(List<Core_Approver_Details__c > approverList){
        String strCopyTemp ='COPY';
        try{
        Set<Core_Approval_Header__Share> setShareHeader = new Set<Core_Approval_Header__Share>();
        Set<EntitySubscription> setEntitySubHeader=new Set<EntitySubscription>();
        List<FeedItem> lstFeedItem = new List<FeedItem>();
        List<EntitySubscription> lstEntitySubDelete=new List<EntitySubscription>();
        Set<Id> approverids = new Set<Id>();
        Set<Id> approverHeaderids = new Set<Id>();
        Set<Id> approverIPids = new Set<Id>();
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
          
        for(Core_Approver_Details__c id : approverList){
            approverids.add(id.ID);  
            approverHeaderids.add(id.Approval_Header__c);  
            approverIPids.add(id.Interested_Party__c);      
        }  
        
        //map of chatter Approval header 
        Map<Id,Core_Approval_Header__c> lstHeader =new Map<Id,Core_Approval_Header__c> ([SELECT id,Requested_By__c,Name,Requested_For__c,Status__c,Fully_Approved__c,Manager__c,Requested_For_Details__c,Requested_by_details__c,Ariba_Company_Code__c,Category__c FROM Core_Approval_Header__c WHERE Id IN :approverHeaderids]); 
        List<Core_Approval_Header__Share> headerShareObj= [SELECT UserOrGroupId, ParentId  FROM Core_Approval_Header__Share WHERE ParentId IN :approverHeaderids]; 
        List<EntitySubscription> headerEntitySubObj= [SELECT ParentId,SubscriberId FROM EntitySubscription WHERE ParentId IN : approverHeaderids];
        
        //map of <Header id and List<Interested party> >
        Map<Id,List<Core_Approver_Details__c>> mapApprover = new Map<Id,List<Core_Approver_Details__c>>();
        List<Core_Approver_Details__c> lstApprover = [SELECT Id,Approval_Header__c , Role__c,Interested_Party__c,Action__c,Is_Active__c,Status__c,Source_System__c FROM Core_Approver_Details__c where Approval_Header__c in:approverHeaderids];
        
        for(Core_Approver_Details__c approver: lstApprover){
            if(!mapApprover.containsKey(approver.Approval_Header__c))
               mapApprover.put(approver.Approval_Header__c,new List<Core_Approver_Details__c>());            
            mapApprover.get(approver.Approval_Header__c).add(approver);
        }
        
        
        /* Start of Apex Header record Entity Subscription code */
        for(Core_Approver_Details__c approverRec : approverList){           
            Set<Id> userIdForEntity = new Set<Id>();
            Set<ID> subscriberIds = new Set<ID>();
            
            //create Set of userIds who are already following the current header record.   
            for(EntitySubscription entityid : headerEntitySubObj){
                if(entityid.ParentId == approverRec.Approval_Header__c) 
                    userIdForEntity.add(entityid.SubscriberId);
             }
            
            //Check whether Interested Party is not null and not following the current record.
            //if(approverRec.Interested_Party__c != null && ( (approverRec.Source_System__c=='GTES' && ((approverRec.Role__c=='EMP'||approverRec.Role__c=='SUB')||(approverRec.Role__c=='APP'&& approverRec.Action__c == 'ACTV'))) ||(approverRec.Source_System__c=='Ariba'&& (approverRec.Is_Active__c==true && approverRec.Action__c!='APPR')) ) && !(userIdForEntity.contains(approverRec.Interested_Party__c)) ) 
                //subscriberIds.add(approverRec.Interested_Party__c);
             if(approverRec.Interested_Party__c != null && !(userIdForEntity.contains(approverRec.Interested_Party__c)) &&
                (((approverRec.Source_System__c== strGtesTemp || approverRec.Source_System__c== strInvoiceTemp) && approverRec.Role__c== strAppTemp && approverRec.Action__c == strActvTemp) 
                ||(approverRec.Source_System__c== strAribaTemp && approverRec.Is_Active__c && approverRec.Role__c== strAppTemp && (approverRec.Action__c==''||approverRec.Action__c==' '||approverRec.Action__c==null))  
                ||(approverRec.Source_System__c== strClarityTemp && (approverRec.Role__c== strAppTemp || approverRec.Role__c== strEndTemp) && approverRec.Action__c == strActvTemp)))
                subscriberIds.add(approverRec.Interested_Party__c);
            
            for(Id id : subscriberIds ){
                //Create EntitySubscription object and assign the user who need to follow the current record. 
               EntitySubscription entityObj=new EntitySubscription();
               entityObj.ParentId=approverRec.Approval_Header__c;
               entityObj.SubscriberId=id;
               setEntitySubHeader.add(entityObj);
            }          
        }       
            //insert the entity subscription record.
            if(!setEntitySubHeader.isempty()){ 
                List<EntitySubscription> lstEntitySubHeader= new List<EntitySubscription>(setEntitySubHeader);
                Database.insert(lstEntitySubHeader);  
            }
        /* end of Entity Subscription */
                
        for(Core_Approval_Header__c id : lstHeader.values()){
            approverIPids.add(id.Requested_For__c);
            approverIPids.add(id.Requested_By__c);
        }       
        //map of user
        Map<Id,User> mapUser = new Map<Id,User>([Select Name FROM User WHERE IsActive= true and Id IN : approverIPids]);
        
        /* EntitySubscription Unfollow Start */
        for(Core_Approver_Details__c approverRec : approverList){       
           Boolean bolMultipleRec=false;
            //if(approverRec.Source_System__c=='Ariba'){
                for(Core_Approver_Details__c  appRec : mapApprover.get(approverRec.Approval_Header__c)){
                    //if(approverRec.Interested_Party__c==appRec.Interested_Party__c && appRec.Is_Active__c && appRec.Action__c!='APPR' && approverRec.Id!=appRec.Id) bolMultipleRec=true; 
                    if(appRec.Source_System__c== strAribaTemp && approverRec.Interested_Party__c==appRec.Interested_Party__c && appRec.Is_Active__c && appRec.Role__c== strAppTemp && ((appRec.Action__c==''||appRec.Action__c==' '||appRec.Action__c==null)&&(appRec.Status__c==''||appRec.Status__c==' '||appRec.Status__c==null)) && approverRec.Id!=appRec.Id) bolMultipleRec=true; 
                }
            //}
            List<EntitySubscription> lstEntitySubQuery=new List<EntitySubscription>();
            /* Start of Apex Header record Entity Subscription code */
            //if( approverRec.Interested_Party__c!=lstHeader.get(approverRec.Approval_Header__c).Requested_By__c && approverRec.Interested_Party__c!=lstHeader.get(approverRec.Approval_Header__c).Requested_For__c && approverRec.Interested_Party__c!=lstHeader.get(approverRec.Approval_Header__c).Manager__c && approverRec.Source_System__c=='Ariba' && approverRec.Action__c=='APPR' && bolMultipleRec==false)  {
            if( approverRec.Source_System__c== strAribaTemp && (approverRec.Action__c== strApprTemp|| approverRec.Action__c== strRejcTemp) && approverRec.Role__c== strAppTemp && !bolMultipleRec)  {
                lstEntitySubQuery=[SELECT Id,ParentId,SubscriberId FROM EntitySubscription WHERE SubscriberId = :approverRec.Interested_Party__c AND ParentId = :approverRec.Approval_Header__c];
            }
            if(!lstEntitySubQuery.isempty()) lstEntitySubDelete.add(lstEntitySubQuery[0]);
          //}
        
        //****EntitySubscription Unfollow End 
           
          /* Start of Apex Header record sharing code */
            Set<Id> userId = new Set<Id>();
            Set<ID> userorGroupIds = new Set<ID>();
            
           //create Set of userIds which are having sharing permission for the current record.   
            for(Core_Approval_Header__Share shareid : headerShareObj){
                if(shareid.ParentId == approverRec.Approval_Header__c) 
                    userId.add(shareid.UserOrGroupId);
             }
            
            
            //Check whether Interested Party is not null and dont have sharing permission for current record.
            if(approverRec.Interested_Party__c != null && (approverRec.Role__c == strAppTemp || (approverRec.Role__c == strEndTemp && approverRec.Source_System__c == strClarityTemp))  && !(userId.contains(approverRec.Interested_Party__c)) ){ 
                userorGroupIds.add(approverRec.Interested_Party__c);
                system.debug('Apex sharing'+approverRec.Interested_Party__c);
            }    
            
            for(Id id : userorGroupIds ){
                //Create Header Share object and assign the userId to whom the current record permission should be given. 
                Core_Approval_Header__Share shareObj=new Core_Approval_Header__Share();
                shareObj.ParentId = approverRec.Approval_Header__c;
                shareObj.UserOrGroupId = id ;
                shareObj.AccessLevel = 'Edit';
                setShareHeader.add(shareObj);
            }
           /* end of Apex header sharing */
                                                 
            String strBody; //Variable to save to feedItem body
            
        /* Start of GTES notification  after insert code */
            if(approverRec.Source_System__c==strGtesTemp && CORE_Chatter_Approval__c.getinstance('GTES_Notification').Text_Value__c == strTextValue && !lstHeader.get(approverRec.Approval_Header__c).Fully_Approved__c){
                              
            //Approver Added with (Role__c 'APP') and (Action <> APPR)
                if(approverRec.Role__c == strAppTemp && approverRec.Action__c != strApprTemp && approverRec.Action__c != strRejcTemp && approverRec.Action__c != strCopyTemp){
                    strBody = CORE_Chatter_Approval__c.getinstance('GTES-ApproverAdded').Text_Value__c;
                    if(approverRec.Interested_Party_Details__c!=null) strBody = strBody.replace(strxxxTemp ,approverRec.Interested_Party_Details__c);
                    else strBody = strBody.replace(strxxxTemp,'');
                    strBody = strBody.replace(stryyyTemp,lstHeader.get(approverRec.Approval_Header__c).Name);
                    if(lstHeader.get(approverRec.Approval_Header__c).Requested_by_details__c!=null) strBody = strBody.replace(strzzzTemp,lstHeader.get(approverRec.Approval_Header__c).Requested_by_details__c);
                    else strBody = strBody.replace(strzzzTemp,'');
                    //lstFeedItem.add(new FeedItem(Type = 'LinkPost', Body = strBody, ParentId = approverRec.Approval_Header__c, LinkURL = baseUrl+'/apex/Core_CA_ApprovalHomePage#/MyApprovalsHome?headerId='+lstHeader.get(approverRec.Approval_Header__c).Id+'&ipId='+approverRec.Id, Title = lstHeader.get(approverRec.Approval_Header__c).Name,CreatedById = CORE_Chatter_Approval__c.getinstance('GTES').Text_Value__c)); 
                    lstFeedItem.add(new FeedItem(Type = strLinkpstTemp , Body = strBody, ParentId = approverRec.Approval_Header__c, LinkURL = baseUrl+'/'+lstHeader.get(approverRec.Approval_Header__c).Id, Title = lstHeader.get(approverRec.Approval_Header__c).Name,CreatedById = CORE_Chatter_Approval__c.getinstance(strGtesTemp).Text_Value__c)); 
                }                             
            }  
         /* End of GTES notification code */
            
         /* Start of Ariba notification after insert code */
            if(approverRec.Source_System__c==strAribaTemp && CORE_Chatter_Approval__c.getinstance('Ariba_Notification').Text_Value__c == strTextValue ){
                                   
            //Approver added with (Role__c = 'APP' and Is_Active__c=true))
                 if(lstHeader.get(approverRec.Approval_Header__c).Status__c=='Submitted' && approverRec.Role__c == strAppTemp && approverRec.Is_Active__c && approverRec.Action__c != strRejcTemp && approverRec.Action__c != strApprTemp ){
                    //send a notification to newly added approver.
                    if(lstHeader.get(approverRec.Approval_Header__c).Requested_For_Details__c == lstHeader.get(approverRec.Approval_Header__c).Requested_By_Details__c){
                        strBody = CORE_Chatter_Approval__c.getinstance('Ariba-ApproverAdded1').Text_Value__c;
                        if(lstHeader.get(approverRec.Approval_Header__c).Requested_For_Details__c != null)
                            strBody = strBody.replace(strzzzTemp,lstHeader.get(approverRec.Approval_Header__c).Requested_For_Details__c);
                        else
                            strBody = strBody.replace(strzzzTemp,'');    
                    }  
                      
                    if(lstHeader.get(approverRec.Approval_Header__c).Requested_For_Details__c != lstHeader.get(approverRec.Approval_Header__c).Requested_By_Details__c){
                        strBody = CORE_Chatter_Approval__c.getinstance('Ariba-ApproverAdded2').Text_Value__c;
                        if(lstHeader.get(approverRec.Approval_Header__c).Requested_For_Details__c != null)
                            strBody = strBody.replace(strzzzTemp,lstHeader.get(approverRec.Approval_Header__c).Requested_For_Details__c);
                        else
                            strBody = strBody.replace(strzzzTemp,'');
                        if(lstHeader.get(approverRec.Approval_Header__c).Requested_By_Details__c != null)
                            strBody = strBody.replace(straaaTemp,lstHeader.get(approverRec.Approval_Header__c).Requested_By_Details__c);
                        else
                            strBody = strBody.replace(straaaTemp,'');    
                    }
                    
                    if(strBody != null){
                        //Replace YYY with PR id
                        strBody = strBody.replace(stryyyTemp,lstHeader.get(approverRec.Approval_Header__c).Name);
                        
                        //Replace XXX with Approver name                                     
                        if(approverRec.Interested_Party_Details__c != null )
                            strBody = strBody.replace(strxxxTemp,approverRec.Interested_Party_Details__c);  
                        else
                            strBody = strBody.replace(strxxxTemp,'');                                        
                        lstFeedItem.add(new FeedItem(Type = strLinkpstTemp, Body = strBody, ParentId = lstHeader.get(approverRec.Approval_Header__c).Id, LinkURL =baseUrl+'/'+lstHeader.get(approverRec.Approval_Header__c).Id, Title = lstHeader.get(approverRec.Approval_Header__c).Name,CreatedById = CORE_Chatter_Approval__c.getinstance(strAribaTemp).Text_Value__c));    
                    }                    
                }
                              
            } 
            /* End of Ariba notification code */
            
            /* Start of clarity code*/
            if(approverRec.Source_System__c==strClarityTemp && CORE_Chatter_Approval__c.getinstance('Clarity_Notification').Text_Value__c == strTextValue ){
                //Approver Added with (Role__c 'APP') and (Action <> APPR)
                if((approverRec.Role__c == strAppTemp || approverRec.Role__c == strEndTemp) && approverRec.Action__c == strActvTemp){
                    
                    strBody = CORE_Chatter_Approval__c.getinstance('Clarity_ApproverAdded').Text_Value__c;
                    if(approverRec.Interested_Party_Details__c!=null) strBody = strBody.replace(strxxxTemp,approverRec.Interested_Party_Details__c);
                    else strBody = strBody.replace(strxxxTemp,'');
                    strBody = strBody.replace(stryyyTemp,lstHeader.get(approverRec.Approval_Header__c).Name);
                    lstFeedItem.add(new FeedItem(Type = strLinkpstTemp, Body = strBody, ParentId = approverRec.Approval_Header__c, LinkURL = baseUrl+'/'+lstHeader.get(approverRec.Approval_Header__c).Id, Title = lstHeader.get(approverRec.Approval_Header__c).Name,CreatedById = CORE_Chatter_Approval__c.getinstance('Clarity').Text_Value__c)); 
                }
            }
            /* End of clarity code*/
            
            /* Start of invoice code*/
            if(approverRec.Source_System__c==strInvoiceTemp && CORE_Chatter_Approval__c.getinstance('Invoice_Notification').Text_Value__c == strTextValue ){
                if(approverRec.Role__c == strAppTemp && approverRec.Action__c == strActvTemp){
                    strBody = CORE_Chatter_Approval__c.getinstance('Invoice_ApproverAdded').Text_Value__c;
                    if(approverRec.Interested_Party_Details__c!=null) strBody = strBody.replace(strxxxTemp,approverRec.Interested_Party_Details__c);
                    else strBody = strBody.replace(strxxxTemp,'');
                    strBody = strBody.replace(stryyyTemp,lstHeader.get(approverRec.Approval_Header__c).Requested_For_Details__c);
                    strBody = strBody.replace(strzzzTemp,lstHeader.get(approverRec.Approval_Header__c).Ariba_Company_Code__c);
                    
                    if(lstHeader.get(approverRec.Approval_Header__c).Category__c == 'INV') strBody = strBody.replace(straaaTemp,strInvoiceTemp);
                    else if(lstHeader.get(approverRec.Approval_Header__c).Category__c == 'CN') strBody = strBody.replace(straaaTemp,'Credit note');
                    else strBody = strBody.replace(straaaTemp,'Invoice');
                    
                    lstFeedItem.add(new FeedItem(Type = strLinkpstTemp, Body = strBody, ParentId = approverRec.Approval_Header__c, LinkURL = baseUrl+'/'+lstHeader.get(approverRec.Approval_Header__c).Id, Title = lstHeader.get(approverRec.Approval_Header__c).Requested_For_Details__c,CreatedById = CORE_Chatter_Approval__c.getinstance('Invoice').Text_Value__c)); 
                }
            }
            /* End of invoice code*/
        }  
        
        
        //insert the feed item regarding GTES and Ariba notification record.
        if(!lstFeedItem.isEmpty())
        Database.insert(lstFeedItem);
        
        //insert the header share record.
        if(!setShareHeader.isEmpty()){
            List<Core_Approval_Header__Share> lstShareHeader= new List<Core_Approval_Header__Share>(setShareHeader);
            Database.insert(lstShareHeader);
        }
        
        //delete entity subscription record
        if(!lstEntitySubDelete.isempty()) Database.delete(lstEntitySubDelete);
        
        }
       catch (Exception ex) {
         while (ex.getCause() != null)
         ex = ex.getCause();
         System.Debug('Error:['+ ex.getMessage()+']');   
    
      }
    }
    
    public void handleAfterUpdate(Map<id,Core_Approver_Details__c> approverNew , Map<id,Core_Approver_Details__c> approverOld){
        String strCopyTemp ='COPY';
        String strRewoTemp ='REWO';
        String strReworkTemp ='Rework';
        String strApprvedTemp ='Approved';
        String strRejectedTemp ='Rejected';
        try{        
        List<feeditem> lstFeedItem=new List<feeditem>();
        Set<EntitySubscription> setEntitySubHeader=new Set<EntitySubscription>();
        List<EntitySubscription> lstEntitySubDelete=new List<EntitySubscription>();
        Map<Id,Core_Approval_Header__c> mapHeader =new Map<Id,Core_Approval_Header__c> ([SELECT id,Requested_By__c,Name,Requested_For__c,Status__c,Fully_Approved__c,Manager__c,Requested_For_Details__c,Requested_by_details__c,Ariba_Company_Code__c,Category__c  FROM Core_Approval_Header__c WHERE Id IN (select Approval_Header__c from Core_Approver_Details__c WHERE Id IN : approverNew.keyset())]);
        List<Core_Approver_Details__c> setIpStatus = new List<Core_Approver_Details__c>();
        Set<Core_Approval_Header__Share> setShareHeader = new Set<Core_Approval_Header__Share>(); 
        Set<Id> approverIPids = new Set<Id>();
        Set<Id> approverHeaderids = new Set<Id>();
        for(Core_Approver_Details__c id : approverNew.values()){
            approverIPids.add(id.Interested_Party__c); 
            approverHeaderids.add(id.Approval_Header__c); 
        }
        
        for(Core_Approval_Header__c id : mapHeader.values()){
            approverIPids.add(id.Requested_For__c);
            approverIPids.add(id.Requested_By__c);
        } 
        
        List<EntitySubscription> headerEntitySubObj= [SELECT ParentId,SubscriberId FROM EntitySubscription WHERE ParentId IN : approverHeaderids];
        List<Core_Approval_Header__Share> headerShareObj= [SELECT UserOrGroupId, ParentId  FROM Core_Approval_Header__Share WHERE ParentId IN :approverHeaderids];
        
        //****EntitySubscription Follow Start
        for(Core_Approver_Details__c approverRec : approverNew.values()){
            /* Start of Apex Header record Entity Subscription code */
            Set<Id> userIdForEntity = new Set<Id>();
            Set<ID> subscriberIds = new Set<ID>();
            
            //Get old and new values after update
              Core_Approver_Details__c newApprover = approverNew.get(approverRec.Id);
              Core_Approver_Details__c oldApprover = approverOld.get(approverRec.Id);
            
            //create Set of userIds who are already following the current header record.   
            for(EntitySubscription entityid : headerEntitySubObj){
                if(entityid.ParentId == approverRec.Approval_Header__c) 
                    userIdForEntity.add(entityid.SubscriberId);
             }
            
            
            //Check whether Interested Party is not null and not following the current record.
            if(approverRec.Interested_Party__c != null && !(userIdForEntity.contains(approverRec.Interested_Party__c)) &&
            (((approverRec.Source_System__c==strGtesTemp || approverRec.Source_System__c== strInvoiceTemp) && approverRec.Role__c==strAppTemp&& approverRec.Action__c == strActvTemp && newApprover.Action__c !=oldApprover.Action__c) 
            ||(approverRec.Source_System__c==strAribaTemp && newApprover.Is_Active__c && !oldApprover.Is_Active__c && approverRec.Role__c==strAppTemp && (approverRec.Action__c==''||approverRec.Action__c==' '||approverRec.Action__c==null) ) 
            ||(approverRec.Source_System__c== strClarityTemp && (approverRec.Role__c== strAppTemp || approverRec.Role__c== strEndTemp) && approverRec.Action__c == strActvTemp && newApprover.Action__c !=oldApprover.Action__c))) 
                subscriberIds.add(approverRec.Interested_Party__c);
            
            for(Id id : subscriberIds ){
                //Create EntitySubscription object and assign the user who need to follow the current record. 
               EntitySubscription entityObj=new EntitySubscription();
               entityObj.ParentId=approverRec.Approval_Header__c;
               entityObj.SubscriberId=id;
               setEntitySubHeader.add(entityObj);
            }
           /* end of Entity Subscription */
        }
        
        //insert the entity subscription record.
        if(!setEntitySubHeader.isempty()){ 
            List<EntitySubscription> lstEntitySubHeader= new List<EntitySubscription>(setEntitySubHeader);
            Database.insert(lstEntitySubHeader);  
        }
        //****EntitySubscription Follow End
        
        
        
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
        Map<Id,List<Core_Approver_Details__c>> mapApprover = new Map<Id,List<Core_Approver_Details__c>>();
        List<Core_Approver_Details__c> lstApprover = [SELECT Id,Approval_Header__c , Role__c,Interested_Party__c,Action__c,Is_Active__c,Interested_Party_Details__c,Status__c,Source_System__c  FROM Core_Approver_Details__c where Approval_Header__c in :approverHeaderids];
        
        for(Core_Approver_Details__c id : lstApprover){
            approverIPids.add(id.Interested_Party__c);
        }
        
        Map<Id,User> mapUser = new Map<Id,User>([Select Name FROM User WHERE IsActive= true and Id IN : approverIPids]);
        
        for(Core_Approver_Details__c approver: lstApprover){
            if(!mapApprover.containsKey(approver.Approval_Header__c))
               mapApprover.put(approver.Approval_Header__c,new List<Core_Approver_Details__c>());            
            mapApprover.get(approver.Approval_Header__c).add(approver);
        }
        
        // iterate through the Interested party records
        for(Core_Approver_Details__c approverRec : approverNew.values()){           
              String strBody;
            
            //Get old and new values after update
              Core_Approver_Details__c newApprover = approverNew.get(approverRec.Id);
              Core_Approver_Details__c oldApprover = approverOld.get(approverRec.Id);
              
              
              //****EntitySubscription Unfollow Start
             //List<EntitySubscription> lstEntitySubDelete=new List<EntitySubscription>();
             //for(Core_Approver_Details__c approverRec : approverNew.values()){
                Boolean bolMultipleRec=false;
                Boolean bolMultipleRecGTES=false;
                Boolean bolMultipleRecClarity=false;
                Boolean bolMultipleRecInvoice=false;
                
                for(Core_Approver_Details__c  appRec : mapApprover.get(approverRec.Approval_Header__c)){                       
                    if(appRec.Source_System__c== strAribaTemp && approverRec.Interested_Party__c==appRec.Interested_Party__c && appRec.Is_Active__c && approverRec.Id!=appRec.Id && appRec.Role__c== strAppTemp){
                        if((appRec.Action__c==''||appRec.Action__c==' '||appRec.Action__c==null)&&(appRec.Status__c==''||appRec.Status__c==' '||appRec.Status__c==null)) bolMultipleRec=true;
                    }        
                    if(appRec.Source_System__c==strGtesTemp && approverRec.Interested_Party__c==appRec.Interested_Party__c && ((appRec.Action__c==''||appRec.Action__c==' '||appRec.Action__c==null)&&(appRec.Status__c==''||appRec.Status__c==' '||appRec.Status__c==null)) && approverRec.Id!=appRec.Id && appRec.Role__c==strAppTemp) bolMultipleRecGTES=true; 
                    if(appRec.Source_System__c==strClarityTemp && approverRec.Interested_Party__c==appRec.Interested_Party__c && ((appRec.Action__c==''||appRec.Action__c==' '||appRec.Action__c==null)&&(appRec.Status__c==''||appRec.Status__c==' '||appRec.Status__c==null)) && approverRec.Id!=appRec.Id && (appRec.Role__c==strAppTemp || appRec.Role__c==strEndTemp)) bolMultipleRecClarity=true; 
                    if(appRec.Source_System__c==strInvoiceTemp && approverRec.Interested_Party__c==appRec.Interested_Party__c && ((appRec.Action__c==''||appRec.Action__c==' '||appRec.Action__c==null)&&(appRec.Status__c==''||appRec.Status__c==' '||appRec.Status__c==null)) && approverRec.Id!=appRec.Id && appRec.Role__c==strAppTemp) bolMultipleRecInvoice=true; 
                } 
                List<EntitySubscription> lstEntitySubQuery=new List<EntitySubscription>();
                /* Start of Apex Header record Entity Subscription code */
                   if((approverRec.Source_System__c==strGtesTemp && approverRec.Role__c==strAppTemp&& !bolMultipleRecGTES &&
                    ((newApprover.Action__c !=oldApprover.Action__c && (approverRec.Action__c == strApprTemp||approverRec.Action__c == strRejcTemp||approverRec.Action__c == strCopyTemp)) ||
                    (newApprover.Status__c !=oldApprover.Status__c && (approverRec.Status__c==strApprvedTemp||approverRec.Status__c==strRejectedTemp)))) 
                    ||
                    (approverRec.Source_System__c==strAribaTemp && approverRec.Role__c==strAppTemp && !bolMultipleRec &&
                    (( newApprover.Action__c !=oldApprover.Action__c && (approverRec.Action__c==strApprTemp||approverRec.Action__c==strRejcTemp)) ||
                    (newApprover.Status__c !=oldApprover.Status__c && (approverRec.Status__c==strApprvedTemp||approverRec.Status__c==strRejectedTemp))
                    )) 
                    ||
                    (approverRec.Source_System__c==strClarityTemp && (approverRec.Role__c==strAppTemp || approverRec.Role__c==strEndTemp)&& !bolMultipleRecClarity &&
                    ((newApprover.Action__c !=oldApprover.Action__c && (approverRec.Action__c == strApprTemp||approverRec.Action__c == strRejcTemp||approverRec.Action__c == strRewoTemp)) ||
                    (newApprover.Status__c !=oldApprover.Status__c && (approverRec.Status__c== strApprvedTemp||approverRec.Status__c==strRejectedTemp ||approverRec.Status__c==strReworkTemp ))))
                    ||
                    (approverRec.Source_System__c==strInvoiceTemp && approverRec.Role__c==strAppTemp&& !bolMultipleRecInvoice &&
                    ((newApprover.Action__c !=oldApprover.Action__c && (approverRec.Action__c == strApprTemp||approverRec.Action__c == strRejcTemp)) ||
                    (newApprover.Status__c !=oldApprover.Status__c && (approverRec.Status__c==strApprvedTemp ||approverRec.Status__c=='Return to AP'))))
                    ){
                       lstEntitySubQuery=[SELECT Id,ParentId,SubscriberId FROM EntitySubscription WHERE SubscriberId = :approverRec.Interested_Party__c AND ParentId = :approverRec.Approval_Header__c];
                    } 
                //}
                // lstEntitySubQuery=[SELECT Id,ParentId,SubscriberId FROM EntitySubscription WHERE SubscriberId = :approverRec.Interested_Party__c AND ParentId = :approverRec.Approval_Header__c];
                //}
                if(!lstEntitySubQuery.isempty()) lstEntitySubDelete.add(lstEntitySubQuery[0]);
             //}
            
            //****EntitySubscription Unfollow End
             
           /* Start of Apex Header record sharing code */
            Set<Id> userId = new Set<Id>();
            Set<ID> userorGroupIds = new Set<ID>();
            
           //create Set of userIds which are having sharing permission for the current record.   
            for(Core_Approval_Header__Share shareid : headerShareObj){
                if(shareid.ParentId == approverRec.Approval_Header__c) 
                    userId.add(shareid.UserOrGroupId);
             }
            
            
            //Check whether Interested Party is not null and dont have sharing permission for current record.
            if((newApprover.Interested_Party__c != oldApprover.Interested_Party__c || newApprover.Role__c != oldApprover.Role__c) && approverRec.Interested_Party__c != null && !(userId.contains(approverRec.Interested_Party__c)) &&
               (approverRec.Role__c == strAppTemp || (approverRec.Source_System__c == strClarityTemp && approverRec.Role__c == strEndTemp))) 
                userorGroupIds.add(approverRec.Interested_Party__c);
            
            for(Id id : userorGroupIds ){
                //Create Header Share object and assign the userId to whom the current record permission should be given. 
                Core_Approval_Header__Share shareObj=new Core_Approval_Header__Share();
                shareObj.ParentId = approverRec.Approval_Header__c;
                shareObj.UserOrGroupId = id ;
                shareObj.AccessLevel = 'Edit';
                setShareHeader.add(shareObj);
            }
           /* end of Apex header sharing */  
                  
            /* Start of GTES notification  after update code */
            if(CORE_Chatter_Approval__c.getinstance('GTES_Notification').Text_Value__c==strTextValue){
                if(approverRec.Source_System__c==strGtesTemp && !mapHeader.get(approverRec.Approval_Header__c).Fully_Approved__c){                       
                                     
                   //Recalled 
                   if(approverRec.Role__c=='EMP' &&  approverRec.Action__c=='SUBM' && oldApprover.Role__c=='EMP' && oldApprover.Action__c=='CANC' ){
                       if(mapApprover.get(approverRec.Approval_Header__c) != null){
                           for(Core_Approver_Details__c otherApproverRec : mapApprover.get(approverRec.Approval_Header__c)){
                               if(otherApproverRec.Role__c==strAppTemp && otherApproverRec.Action__c == strActvTemp  && otherApproverRec.Status__c!=strApprvedTemp && otherApproverRec.Status__c!=strRejectedTemp){                            
                                    strBody = CORE_Chatter_Approval__c.getinstance('GTES-ApproverAdded').Text_Value__c;
                                    if(otherApproverRec.Interested_Party_Details__c!=null) strBody = strBody.replace(strxxxTemp,otherApproverRec.Interested_Party_Details__c);
                                    else strBody = strBody.replace(strxxxTemp,'');
                                    strBody = strBody.replace(stryyyTemp,mapHeader.get(approverRec.Approval_Header__c).Name);
                                    if(mapHeader.get(approverRec.Approval_Header__c).Requested_by_details__c!=null) strBody = strBody.replace(strzzzTemp,mapHeader.get(approverRec.Approval_Header__c).Requested_by_details__c);
                                    else strBody = strBody.replace(strzzzTemp,'');
                                    lstFeedItem.add(new FeedItem(Type = strLinkpstTemp, Body = strBody, ParentId = approverRec.Approval_Header__c, LinkURL =baseUrl+'/'+mapHeader.get(approverRec.Approval_Header__c).Id, Title = mapHeader.get(approverRec.Approval_Header__c).Name,CreatedById = CORE_Chatter_Approval__c.getinstance(strGtesTemp).Text_Value__c));                              
                             }
                          }
                       }
                   } 
                   
                   //To set IPStatus Blank
                   if(approverRec.Action__c == strActvTemp && approverRec.Role__c == strAppTemp && newApprover.Action__c != oldApprover.Action__c && approverRec.Interested_Party__c != null) setIpStatus.add(new Core_Approver_Details__c(id=approverRec.Id,Status__c =''));
                }           
            }
            /* End of GTES notification  after update code */
            
            /* Start of Ariba notification  after update code */ 
            if(approverRec.Source_System__c== strAribaTemp && CORE_Chatter_Approval__c.getinstance('Ariba_Notification').Text_Value__c == strTextValue ){
                             
                //In Denied to Resubmit. 
                 if(mapHeader.get(approverRec.Approval_Header__c).Status__c=='Submitted' && approverRec.Role__c == strAppTemp && newApprover.Action__c != oldApprover.Action__c && oldApprover.Action__c==strRejcTemp && (approverRec.Action__c == null || approverRec.Action__c =='') ){               
                   
                   //Set the Ip status to blank
                   setIpStatus.add(new Core_Approver_Details__c(id=approverRec.Id,Status__c =''));
                   
                   //Approver added Notification to approver other than denied approver.
                   if(mapApprover.get(approverRec.Approval_Header__c) != null){ 
                       for(Core_Approver_Details__c otherApproverRec : mapApprover.get(approverRec.Approval_Header__c)){
                             if(otherApproverRec.Role__c==strAppTemp && otherApproverRec.Is_Active__c && otherApproverRec.Action__c != strApprTemp){ 
                                 if(mapHeader.get(approverRec.Approval_Header__c).Requested_For_Details__c == mapHeader.get(approverRec.Approval_Header__c).Requested_By_Details__c){
                                     strBody=CORE_Chatter_Approval__c.getinstance('Ariba-ApproverAdded1').Text_Value__c;
                                     if(mapHeader.get(approverRec.Approval_Header__c).Requested_For_Details__c != null )                         
                                         strBody = strBody.replace(strzzzTemp,mapHeader.get(approverRec.Approval_Header__c).Requested_For_Details__c);
                                     else
                                         strBody = strBody.replace(strzzzTemp,'');      
                                 }
                                 
                                 if(mapHeader.get(approverRec.Approval_Header__c).Requested_For_Details__c != mapHeader.get(approverRec.Approval_Header__c).Requested_By_Details__c){
                                     strBody=CORE_Chatter_Approval__c.getinstance('Ariba-ApproverAdded2').Text_Value__c;
                                     if(mapHeader.get(approverRec.Approval_Header__c).Requested_For_Details__c != null )                         
                                         strBody = strBody.replace(strzzzTemp,mapHeader.get(approverRec.Approval_Header__c).Requested_For_Details__c);
                                     else
                                         strBody = strBody.replace(strzzzTemp,'');
                                     if(mapHeader.get(approverRec.Approval_Header__c).Requested_By_Details__c != null)
                                         strBody = strBody.replace(straaaTemp,mapHeader.get(approverRec.Approval_Header__c).Requested_By_Details__c);
                                     else
                                         strBody = strBody.replace(straaaTemp,'');    
                                }
                               
                               if(strBody != null){
                                   strBody = strBody.replace(stryyyTemp,mapHeader.get(approverRec.Approval_Header__c).Name);
                                   
                                   if( otherApproverRec.Interested_Party_Details__c != null )
                                       strBody = strBody.replace(strxxxTemp,otherApproverRec.Interested_Party_Details__c);  
                                   else
                                       strBody = strBody.replace(strxxxTemp,''); 
                                   
                                   lstFeedItem.add(new FeedItem(Type = strLinkpstTemp, Body = strBody, ParentId = mapHeader.get(approverRec.Approval_Header__c).Id, LinkURL =baseUrl+'/'+mapHeader.get(approverRec.Approval_Header__c).Id, Title = mapHeader.get(approverRec.Approval_Header__c).Name,CreatedById = CORE_Chatter_Approval__c.getinstance(strAribaTemp).Text_Value__c));                                                          
                              }
                           }
                       }    
                    }                                    
                }
                
               // else
                //Approver Added with IsActive changed from false to true
                if(mapHeader.get(approverRec.Approval_Header__c).Status__c =='Submitted' && approverRec.Role__c == strAppTemp && newApprover.Is_Active__c  && !oldApprover.Is_Active__c && approverRec.Action__c != strRejcTemp && approverRec.Action__c != strApprTemp ){
                    //send a notification to newly added approver.
                    if(mapHeader.get(approverRec.Approval_Header__c).Requested_For_Details__c == mapHeader.get(approverRec.Approval_Header__c).Requested_By_Details__c){
                        strBody=CORE_Chatter_Approval__c.getinstance('Ariba-ApproverAdded1').Text_Value__c;
                        if(mapHeader.get(approverRec.Approval_Header__c).Requested_For_Details__c != null )                         
                            strBody = strBody.replace(strzzzTemp,mapHeader.get(approverRec.Approval_Header__c).Requested_For_Details__c);
                        else
                            strBody = strBody.replace(strzzzTemp,'');      
                    }
                    
                    if(mapHeader.get(approverRec.Approval_Header__c).Requested_For_Details__c != mapHeader.get(approverRec.Approval_Header__c).Requested_By_Details__c){
                        strBody=CORE_Chatter_Approval__c.getinstance('Ariba-ApproverAdded2').Text_Value__c;
                        if(mapHeader.get(approverRec.Approval_Header__c).Requested_For_Details__c != null )                         
                            strBody = strBody.replace(strzzzTemp,mapHeader.get(approverRec.Approval_Header__c).Requested_For_Details__c);
                        else
                            strBody = strBody.replace(strzzzTemp,'');
                        if(mapHeader.get(approverRec.Approval_Header__c).Requested_By_Details__c != null)
                            strBody = strBody.replace(straaaTemp,mapHeader.get(approverRec.Approval_Header__c).Requested_By_Details__c);
                        else
                            strBody = strBody.replace(straaaTemp,'');    
                    }
                    
                    if(strBody != null){
                        strBody = strBody.replace(stryyyTemp,mapHeader.get(approverRec.Approval_Header__c).Name);
                    
                        if(approverRec.Interested_Party_Details__c !=null )
                            strBody = strBody.replace(strxxxTemp,approverRec.Interested_Party_Details__c);  
                        else
                            strBody = strBody.replace(strxxxTemp,'');  
                        
                        lstFeedItem.add(new FeedItem(Type = strLinkpstTemp, Body = strBody, ParentId = mapHeader.get(approverRec.Approval_Header__c).Id, LinkURL =baseUrl+'/'+mapHeader.get(approverRec.Approval_Header__c).Id, Title = mapHeader.get(approverRec.Approval_Header__c).Name,CreatedById = CORE_Chatter_Approval__c.getinstance(strAribaTemp).Text_Value__c));                      
                    }
                }
                
            }
            /* End of Ariba notification after update code */
            
            /*Start of Clarity notification  after update code */
            if(approverRec.Source_System__c==strClarityTemp && CORE_Chatter_Approval__c.getinstance('Clarity_Notification').Text_Value__c == strTextValue ){                            
                //Approver Added with (Role__c 'APP') and (Action = ACTV)
                if((approverRec.Role__c == strAppTemp || approverRec.Role__c == strEndTemp) && approverRec.Action__c == strActvTemp && (newApprover.Action__c != oldApprover.Action__c || newApprover.Role__c != oldApprover.Role__c )){
                    strBody = CORE_Chatter_Approval__c.getinstance('Clarity_ApproverAdded').Text_Value__c;
                    if(approverRec.Interested_Party_Details__c!=null) strBody = strBody.replace(strxxxTemp,approverRec.Interested_Party_Details__c);
                    else strBody = strBody.replace(strxxxTemp,'');
                    strBody = strBody.replace(stryyyTemp,mapHeader.get(approverRec.Approval_Header__c).Name); 
                    lstFeedItem.add(new FeedItem(Type = strLinkpstTemp, Body = strBody, ParentId = mapHeader.get(approverRec.Approval_Header__c).Id, LinkURL = baseUrl+'/'+mapHeader.get(approverRec.Approval_Header__c).Id, Title = mapHeader.get(approverRec.Approval_Header__c).Name,CreatedById = CORE_Chatter_Approval__c.getinstance('Clarity').Text_Value__c)); 
                }                        
            }
            /*End of Clarity notification after update code */
            
            /* Start of invoice notification  after update code */
            if(approverRec.Source_System__c==strInvoiceTemp && CORE_Chatter_Approval__c.getinstance('Invoice_Notification').Text_Value__c == strTextValue ){
                if(approverRec.Role__c == strAppTemp && approverRec.Action__c == strActvTemp && (newApprover.Action__c != oldApprover.Action__c || newApprover.Role__c != oldApprover.Role__c )){
                    strBody = CORE_Chatter_Approval__c.getinstance('Invoice_ApproverAdded').Text_Value__c;
                    if(approverRec.Interested_Party_Details__c!=null) strBody = strBody.replace(strxxxTemp,approverRec.Interested_Party_Details__c);
                    else strBody = strBody.replace(strxxxTemp,'');
                    strBody = strBody.replace(stryyyTemp,mapHeader.get(approverRec.Approval_Header__c).Requested_For_Details__c);
                    strBody = strBody.replace(strzzzTemp,mapHeader.get(approverRec.Approval_Header__c).Ariba_Company_Code__c);
                    
                    if(mapHeader.get(approverRec.Approval_Header__c).Category__c == 'INV') strBody = strBody.replace(straaaTemp, strInvoiceTemp);
                    else if(mapHeader.get(approverRec.Approval_Header__c).Category__c == 'CN') strBody = strBody.replace(straaaTemp,'Credit note');
                    else strBody = strBody.replace(straaaTemp,'Invoice');
                    
                    lstFeedItem.add(new FeedItem(Type = strLinkpstTemp, Body = strBody, ParentId = mapHeader.get(approverRec.Approval_Header__c).Id, LinkURL = baseUrl+'/'+mapHeader.get(approverRec.Approval_Header__c).Id, Title = mapHeader.get(approverRec.Approval_Header__c).Requested_For_Details__c,CreatedById = CORE_Chatter_Approval__c.getinstance('Invoice').Text_Value__c)); 
                }
            }
            /* End of invoice notification  after update code */
            
        }
        //insert the list of feed item record.
        if(!lstFeedItem.isempty()) Database.insert(lstFeedItem);
        
        //insert the header share record.
        if(!setShareHeader.isEmpty()){
            List<Core_Approval_Header__Share> lstShareHeader= new List<Core_Approval_Header__Share>(setShareHeader);
            Database.insert(lstShareHeader);
        }
        
        //delete entity subscription record
        if(!lstEntitySubDelete.isempty()) Database.delete(lstEntitySubDelete);
        
        //Update the Ip status
        if(!setIpStatus.isempty()) Database.update(setIpStatus);
        }
        catch (Exception ex) {
          while (ex.getCause() != null)
          ex = ex.getCause();
          System.Debug('Error:['+ ex.getMessage()+']');   
    
      }
    }
    
     /* -- SONAR Issue explanation -- 
      This is handler class for trigger written for AfterDelete instance of Approval Status.
      Which has Apex sharing 
      So multiple If else condition inside for loop and multiple SOQL, DML are written thats leading to the Npath Complexity.  
    */
    public void handleAfterDelete (List<Core_Approver_Details__c > approverList){
        try{
        List<feeditem> lstFeedItem=new List<feeditem>();
        Set<Id> approverHeaderids = new Set<Id>();
        Set<Id> approverInterestedparty = new Set<Id>();
        List<Core_Approval_Header__Share> lstApexSharingDelete=new List<Core_Approval_Header__Share>();
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
         List<EntitySubscription> lstEntitySubDelete=new List<EntitySubscription>();
       
        
        for(Core_Approver_Details__c id : approverList){
            approverHeaderids.add(id.Approval_Header__c); 
            approverInterestedparty.add(id.Interested_Party__c);    
        } 
        
        Map<Id,Core_Approval_Header__c> mapHeader =new Map<Id,Core_Approval_Header__c> ([SELECT Requested_By__c,Requested_For__c,Name,Id,Status__c,Manager__c FROM Core_Approval_Header__c WHERE Id IN : approverHeaderids]); 
        
        List<Core_Approver_Details__c> lstApprover = [SELECT Approval_Header__c , Role__c,Interested_Party__c,Action__c,Is_Active__c,Interested_Party_Details__c  FROM Core_Approver_Details__c where Approval_Header__c in :approverHeaderids and Is_Active__c=true and Source_System__c=: strAribaTemp];
        
        
        for(Core_Approval_Header__c id : mapHeader.values()){
            approverInterestedparty.add(id.Requested_For__c);
            approverInterestedparty.add(id.Requested_By__c);
        }
        
        Map<Id,User> mapUser = new Map<Id,User>([Select Name FROM User WHERE IsActive= true and Id IN : approverInterestedparty]);
        
        /** unfollow Map**/
        Map<Id,List<EntitySubscription>> mapSubscription = new Map<Id,List<EntitySubscription>>();
        List<EntitySubscription> headerEntitySubObjUnfollow = [SELECT ParentId,SubscriberId FROM EntitySubscription WHERE ParentId IN : approverHeaderids ];
        for(EntitySubscription subscription : headerEntitySubObjUnfollow){
        if(!mapSubscription.containsKey(subscription.ParentId))
            mapSubscription.put(subscription.ParentId,new List<EntitySubscription>());            
            mapSubscription.get(subscription.ParentId).add(subscription);
        }
        /** unfollow Map**/
        
        for(Core_Approver_Details__c approverRec : approverList){
            
            //****Delete access to record Start
        
            //for(Core_Approver_Details__c approverRec : approverList){
                Boolean bolMultipleRec=false;
                if(approverRec.Source_System__c==strAribaTemp){
                    for(Core_Approver_Details__c  appRec : lstApprover){
                        if(approverRec.Approval_Header__c==appRec.Approval_Header__c && approverRec.Interested_Party__c==appRec.Interested_Party__c && appRec.Is_Active__c && appRec.Action__c!=strApprTemp&& approverRec.Id!=appRec.Id) bolMultipleRec=true; 
                    }
                }
                List<Core_Approval_Header__Share> lstApexSharingQuery=new List<Core_Approval_Header__Share>();
                /* Start of Apex sharing code */
                if(approverRec.Interested_Party__c!=mapHeader.get(approverRec.Approval_Header__c).Requested_By__c && approverRec.Interested_Party__c!=mapHeader.get(approverRec.Approval_Header__c).Requested_For__c && approverRec.Interested_Party__c!=mapHeader.get(approverRec.Approval_Header__c).Manager__c && ((approverRec.Source_System__c==strGtesTemp ) || (approverRec.Source_System__c==strInvoiceTemp) || (approverRec.Source_System__c==strClarityTemp) || (approverRec.Source_System__c==strAribaTemp && !bolMultipleRec)) )  {
                    lstApexSharingQuery=[SELECT Id,ParentId,UserOrGroupId FROM Core_Approval_Header__Share WHERE UserOrGroupId = :approverRec.Interested_Party__c AND ParentId = :approverRec.Approval_Header__c];
                }
                if(!lstApexSharingQuery.isempty()) lstApexSharingDelete.add(lstApexSharingQuery[0]);
                
                /*Entity subscription follow record  */
                if((approverRec.Source_System__c == strInvoiceTemp || approverRec.Source_System__c == strClarityTemp )  &&  mapSubscription.containsKey(approverRec.Approval_Header__c)){
                    if(mapSubscription.get(approverRec.Approval_Header__c) != null){
                       for(EntitySubscription appRec : mapSubscription.get(approverRec.Approval_Header__c)){
                            if(appRec.SubscriberId == approverRec.Interested_Party__c)
                                lstEntitySubDelete.add(appRec);
                        }
                    }   
                }
                       

        }
        //insert the list of feed item record.
        if(!lstFeedItem.isempty()) Database.insert(lstFeedItem);
        
        //delete entity subscription record
        if(!lstEntitySubDelete.isempty()) Database.delete(lstEntitySubDelete);
        
        //delete access to record
        if(!lstApexSharingDelete.isempty()) Database.delete(lstApexSharingDelete);
        }
        catch (Exception ex) {
         while (ex.getCause() != null)
         ex = ex.getCause();
         System.Debug('Error:['+ ex.getMessage()+']');   
    
      }
    }
}