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

public class Core_CA_InterestedParty_Handler{

    public void handleBeforeInsert(List<Core_Approver_Details__c > approverList){
        List<RecordType> aribaRecordType  = [SELECT Id FROM RecordType where Name ='Ariba' AND SobjectType = 'Core_Approver_Details__c'];
        List<RecordType> gtesRecordType   = [SELECT Id FROM RecordType where Name ='GTES' AND SobjectType = 'Core_Approver_Details__c'];
        //List<RecordType> remedyRecordType = [SELECT Id FROM RecordType where Name ='Remedy' AND SobjectType = 'Core_Approver_Details__c'];
               
        for(Core_Approver_Details__c approverRec : approverList){    
            
            //Fetching Record Type Id for Selected Source System.            
            if(approverRec.Source_System__c == 'Ariba')
                approverRec.RecordTypeId = aribaRecordType[0].Id;
            if(approverRec.Source_System__c == 'GTES')
                approverRec.RecordTypeId = gtesRecordType[0].Id;
            //if(approverRec.Source_System__c == 'Remedy')
                //approverRec.RecordTypeId = remedyRecordType[0].Id;
            
            //Updating Name field with Role.            
            approverRec.Name = approverRec.CA_Role__c;
        }
    }
    
    public void handleAfterInsert(List<Core_Approver_Details__c > approverList){
        try{
        Set<Core_Approval_Header__Share> setShareHeader = new Set<Core_Approval_Header__Share>();
        Set<EntitySubscription> setEntitySubHeader=new Set<EntitySubscription>();
        List<FeedItem> lstFeedItem = new List<FeedItem>();
        List<EntitySubscription> lstEntitySubDelete=new List<EntitySubscription>();
        //Set<Core_Approval_Header__c> setHeaderStatus=new Set<Core_Approval_Header__c>();
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
        Map<Id,Core_Approval_Header__c> lstHeader =new Map<Id,Core_Approval_Header__c> ([SELECT id,Requested_By__c,Name,Requested_For__c,Status__c,Fully_Approved__c,Manager__c,Requested_For_Details__c,Requested_by_details__c FROM Core_Approval_Header__c WHERE Id IN :approverHeaderids]); 
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
        
        
        //****EntitySubscription Follow Start
        for(Core_Approver_Details__c approverRec : approverList){
            /* Start of Apex Header record Entity Subscription code */
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
            if(approverRec.Interested_Party__c != null && ( (approverRec.Source_System__c=='GTES' && approverRec.Role__c=='APP'&& approverRec.Action__c == 'ACTV') ||(approverRec.Source_System__c=='Ariba'&& approverRec.Is_Active__c==true && approverRec.Role__c=='APP' && (approverRec.Action__c==''||approverRec.Action__c==' '||approverRec.Action__c==null)) ) && !(userIdForEntity.contains(approverRec.Interested_Party__c)) ) 
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
        
        
        
        for(Core_Approval_Header__c id : lstHeader.values()){
            approverIPids.add(id.Requested_For__c);
            approverIPids.add(id.Requested_By__c);
        }
        
        //map of user
        Map<Id,User> mapUser = new Map<Id,User>([Select Name FROM User WHERE IsActive= true and Id IN : approverIPids]);
        
        
        
        // iterate through the Interested party records
        for(Core_Approver_Details__c approverRec : approverList){
           
          //****EntitySubscription Unfollow Start
        
          //for(Core_Approver_Details__c approverRec : approverList){
            Boolean bolMultipleRec=false;
            //if(approverRec.Source_System__c=='Ariba'){
                for(Core_Approver_Details__c  appRec : mapApprover.get(approverRec.Approval_Header__c)){
                    //if(approverRec.Interested_Party__c==appRec.Interested_Party__c && appRec.Is_Active__c==true && appRec.Action__c!='APPR' && approverRec.Id!=appRec.Id) bolMultipleRec=true; 
                    if(appRec.Source_System__c=='Ariba' && approverRec.Interested_Party__c==appRec.Interested_Party__c && appRec.Is_Active__c==true && appRec.Role__c=='APP' && ((appRec.Action__c==''||appRec.Action__c==' '||appRec.Action__c==null)&&(appRec.Status__c==''||appRec.Status__c==' '||appRec.Status__c==null)) && approverRec.Id!=appRec.Id) bolMultipleRec=true; 
                }
            //}
            List<EntitySubscription> lstEntitySubQuery=new List<EntitySubscription>();
            /* Start of Apex Header record Entity Subscription code */
            //if( approverRec.Interested_Party__c!=lstHeader.get(approverRec.Approval_Header__c).Requested_By__c && approverRec.Interested_Party__c!=lstHeader.get(approverRec.Approval_Header__c).Requested_For__c && approverRec.Interested_Party__c!=lstHeader.get(approverRec.Approval_Header__c).Manager__c && approverRec.Source_System__c=='Ariba' && approverRec.Action__c=='APPR' && bolMultipleRec==false)  {
            if( approverRec.Source_System__c=='Ariba' && (approverRec.Action__c=='APPR'|| approverRec.Action__c=='REJC') && approverRec.Role__c=='APP' && bolMultipleRec==false)  {
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
            if(approverRec.Interested_Party__c != null && approverRec.Role__c == 'APP'  && !(userId.contains(approverRec.Interested_Party__c)) ) 
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
           
           
                                      
            String strBody; //Variable to save to feedItem body
            
        /* Start of GTES notification  after insert code */
            if(approverRec.Source_System__c=='GTES' && CORE_Chatter_Approval__c.getinstance('GTES_Notification').Text_Value__c == 'Yes' && lstHeader.get(approverRec.Approval_Header__c).Fully_Approved__c==false){
                
             //Expense Claim Submitted with(Action 'SUBM' and Role 'EMP')
                // If the Requestor__c on Header object is same as  Interested_Party__c 
                /*if(approverRec.Role__c == 'EMP' && approverRec.Action__c == 'SUBM' && lstHeader.get(approverRec.Approval_Header__c).Requested_By__c == approverRec.Interested_Party__c && approverRec.Interested_Party__c != null && lstHeader.get(approverRec.Approval_Header__c).Requested_By__c!=null){
                    strBody = CORE_Chatter_Approval__c.getinstance('GTES-ExpenseClaimSubmitted1').Text_Value__c;
                    strBody = strBody.replace('XXX',lstHeader.get(approverRec.Approval_Header__c).Name);  
                    strBody = strBody.replace('YYY',mapUser.get(approverRec.Interested_Party__c).Name); 
                    lstFeedItem.add(new FeedItem(Type = 'LinkPost', Body = strBody, ParentId = approverRec.Approval_Header__c, LinkURL =baseUrl+'/'+lstHeader.get(approverRec.Approval_Header__c).Id, Title = lstHeader.get(approverRec.Approval_Header__c).Name,CreatedById = CORE_Chatter_Approval__c.getinstance('GTES').Text_Value__c));     
                    //setHeaderStatus.add(new Core_Approval_Header__c(id=lstHeader.get(approverRec.Approval_Header__c).Id,Status__c='Submitted'));
                }
                // If the Requestor__c on Header object is not same as  Interested_Party__c 
                if(approverRec.Role__c == 'EMP' && approverRec.Action__c == 'SUBM' && lstHeader.get(approverRec.Approval_Header__c).Requested_By__c != approverRec.Interested_Party__c && approverRec.Interested_Party__c != null && lstHeader.get(approverRec.Approval_Header__c).Requested_By__c!=null){
                    strBody = CORE_Chatter_Approval__c.getinstance('GTES-ExpenseClaimSubmitted2').Text_Value__c;
                    strBody = strBody.replace('XXX',lstHeader.get(approverRec.Approval_Header__c).Name);
                    strBody = strBody.replace('YYY',mapUser.get(approverRec.Interested_Party__c).Name);
                    lstFeedItem.add(new FeedItem(Type = 'LinkPost', Body = strBody, ParentId = approverRec.Approval_Header__c, LinkURL =baseUrl+'/'+lstHeader.get(approverRec.Approval_Header__c).Id, Title = lstHeader.get(approverRec.Approval_Header__c).Name,CreatedById = CORE_Chatter_Approval__c.getinstance('GTES').Text_Value__c)); 
                    //setHeaderStatus.add(new Core_Approval_Header__c(id=lstHeader.get(approverRec.Approval_Header__c).Id,Status__c='Submitted'));
                }
                
                
             //Expense Claim Submitted with(Action 'SUBM' and Role 'SUB')
                // If the Requestor__c on Header object is same as  Interested_Party__c
                if(approverRec.Role__c == 'SUB' && approverRec.Action__c == 'SUBM' && lstHeader.get(approverRec.Approval_Header__c).Requested_By__c == approverRec.Interested_Party__c && approverRec.Interested_Party__c != null && lstHeader.get(approverRec.Approval_Header__c).Requested_By__c!=null){
                    strBody = CORE_Chatter_Approval__c.getinstance('GTES-ExpenseClaimSubmitted3').Text_Value__c;
                    strBody = strBody.replace('XXX',lstHeader.get(approverRec.Approval_Header__c).Name); 
                    strBody = strBody.replace('YYY',mapUser.get(approverRec.Interested_Party__c).Name);
                    lstFeedItem.add(new FeedItem(Type = 'LinkPost', Body = strBody, ParentId = approverRec.Approval_Header__c, LinkURL ='/'+lstHeader.get(approverRec.Approval_Header__c).Id, Title = lstHeader.get(approverRec.Approval_Header__c).Name,CreatedById = CORE_Chatter_Approval__c.getinstance('GTES').Text_Value__c)); 
                    //setHeaderStatus.add(new Core_Approval_Header__c(id=lstHeader.get(approverRec.Approval_Header__c).Id,Status__c='Submitted'));
                }                 
                // If the Requestor__c on Header object is not same as  Interested_Party__c
                if(approverRec.Role__c == 'SUB' && approverRec.Action__c == 'SUBM' && lstHeader.get(approverRec.Approval_Header__c).Requested_By__c != approverRec.Interested_Party__c && approverRec.Interested_Party__c != null && lstHeader.get(approverRec.Approval_Header__c).Requested_By__c!=null){
                    strBody = CORE_Chatter_Approval__c.getinstance('GTES-ExpenseClaimSubmitted4').Text_Value__c;
                    strBody = strBody.replace('XXX',lstHeader.get(approverRec.Approval_Header__c).Name);
                    strBody = strBody.replace('YYY',mapUser.get(approverRec.Interested_Party__c).Name); 
                    strBody = strBody.replace('ZZZ',mapUser.get(lstHeader.get(approverRec.Approval_Header__c).Requested_By__c).Name);
                    lstFeedItem.add(new FeedItem(Type = 'LinkPost', Body = strBody, ParentId = approverRec.Approval_Header__c, LinkURL ='/'+lstHeader.get(approverRec.Approval_Header__c).Id, Title = lstHeader.get(approverRec.Approval_Header__c).Name,CreatedById = CORE_Chatter_Approval__c.getinstance('GTES').Text_Value__c));  
                    //setHeaderStatus.add(new Core_Approval_Header__c(id=lstHeader.get(approverRec.Approval_Header__c).Id,Status__c='Submitted'));
                }*/           
                
            //Approver Added with (Role__c 'APP') and (Action <> APPR)
                if(approverRec.Role__c == 'APP' && approverRec.Action__c != 'APPR' && approverRec.Action__c != 'REJC' && approverRec.Action__c != 'COPY'){
                    strBody = CORE_Chatter_Approval__c.getinstance('GTES-ApproverAdded').Text_Value__c;
                    if(approverRec.Interested_Party_Details__c!=null) strBody = strBody.replace('XXX',approverRec.Interested_Party_Details__c);
                    else strBody = strBody.replace('XXX','');
                    strBody = strBody.replace('YYY',lstHeader.get(approverRec.Approval_Header__c).Name);
                    if(lstHeader.get(approverRec.Approval_Header__c).Requested_by_details__c!=null) strBody = strBody.replace('ZZZ',lstHeader.get(approverRec.Approval_Header__c).Requested_by_details__c);
                    else strBody = strBody.replace('ZZZ','');
                    //lstFeedItem.add(new FeedItem(Type = 'LinkPost', Body = strBody, ParentId = approverRec.Approval_Header__c, LinkURL = baseUrl+'/apex/Core_CA_ApprovalHomePage#/MyApprovalsHome?headerId='+lstHeader.get(approverRec.Approval_Header__c).Id+'&ipId='+approverRec.Id, Title = lstHeader.get(approverRec.Approval_Header__c).Name,CreatedById = CORE_Chatter_Approval__c.getinstance('GTES').Text_Value__c)); 
                    lstFeedItem.add(new FeedItem(Type = 'LinkPost', Body = strBody, ParentId = approverRec.Approval_Header__c, LinkURL = baseUrl+'/'+lstHeader.get(approverRec.Approval_Header__c).Id, Title = lstHeader.get(approverRec.Approval_Header__c).Name,CreatedById = CORE_Chatter_Approval__c.getinstance('GTES').Text_Value__c)); 
                }
                
            //Fully Approved with (Action 'APPR' and Role 'SYS') or with (Role 'PST')
                /*if((approverRec.Role__c == 'SYS' && approverRec.Action__c == 'APPR') || (approverRec.Role__c == 'PST') ){
                    if(mapApprover.get(approverRec.Approval_Header__c) != null){
                        setHeaderStatus.add(new Core_Approval_Header__c(id=lstHeader.get(approverRec.Approval_Header__c).Id,Status__c='Fully Approved'));
                        Boolean bolExistedNotification=false;
                        for(Core_Approver_Details__c otherApproverRec : mapApprover.get(approverRec.Approval_Header__c)){
                            if((otherApproverRec.Role__c=='SYS' && otherApproverRec.Action__c=='APPR' && otherApproverRec.Id != approverRec.Id  )||(otherApproverRec.Role__c=='PST' && otherApproverRec.Id != approverRec.Id)) bolExistedNotification=true;
                        }
                        for(Core_Approver_Details__c otherApproverRec : mapApprover.get(approverRec.Approval_Header__c)){
                            if((otherApproverRec.Role__c=='EMP' || otherApproverRec.Role__c=='SUB') && otherApproverRec.Interested_Party__c != null && bolExistedNotification==false){
                                strBody=CORE_Chatter_Approval__c.getinstance('GTES-FullyApproved').Text_Value__c;
                                strBody=strBody.replace('XXXXXX',lstHeader.get(approverRec.Approval_Header__c).Name);
                                lstFeedItem.add(new FeedItem( Type = 'LinkPost', Body = strBody, ParentId = otherApproverRec.Interested_Party__c,
                                LinkURL =baseUrl+'/'+lstHeader.get(approverRec.Approval_Header__c).Id, Title = lstHeader.get(approverRec.Approval_Header__c).Name,CreatedById = CORE_Chatter_Approval__c.getinstance('GTES').Text_Value__c)); 
                            }
                        }
                    }
                }*/ 
                
                 //Rejected (Role 'APP' and Action 'REJC' )
                    /*if((approverRec.Role__c=='APP' || approverRec.Role__c=='PRE') &&  approverRec.Action__c=='REJC' && (approverRec.Interested_Party__c!=null || approverRec.Interested_Party_Details__c != null)){
                        
                        //if(mapApprover.get(approverRec.Approval_Header__c) != null){
                            //for(Core_Approver_Details__c otherApproverRec : mapApprover.get(approverRec.Approval_Header__c)){
                               //if((otherApproverRec.Role__c=='EMP' || otherApproverRec.Role__c=='SUB') && otherApproverRec.Interested_Party__c != null){                            
                                    strBody=CORE_Chatter_Approval__c.getinstance('GTES-Rejected').Text_Value__c;
                                    strBody=strBody.replace('XXX',lstHeader.get(approverRec.Approval_Header__c).Name);
                                    if(approverRec.Interested_Party__c != null) strBody=strBody.replace('YYY',mapUser.get(approverRec.Interested_Party__c).Name);
                                        //strBody=strBody+' '+ mapUser.get(approverRec.Interested_Party__c).Name+'.';
                                    if(approverRec.Interested_Party__c == null && approverRec.Interested_Party_Details__c != null) strBody=strBody.replace('YYY',approverRec.Interested_Party_Details__c);
                                        //strBody=strBody+' '+ approverRec.Interested_Party_Details__c+'.';
                                    lstFeedItem.add(new FeedItem( Type = 'LinkPost', Body = strBody, ParentId = approverRec.Approval_Header__c,
                                    LinkURL =baseUrl+'/'+lstHeader.get(approverRec.Approval_Header__c).Id, Title = lstHeader.get(approverRec.Approval_Header__c).Name,CreatedById = CORE_Chatter_Approval__c.getinstance('GTES').Text_Value__c));
                              //}
                           //}
                        //}   
                    }*/           
            }  
         /* End of GTES notification code */
            
         /* Start of Ariba notification after insert code */
            if(approverRec.Source_System__c=='Ariba' && CORE_Chatter_Approval__c.getinstance('Ariba_Notification').Text_Value__c == 'Yes' ){
                 
            //Request Approved with (Role__c = 'APP' and Action__c ='APPR') 
               /* if(lstHeader.get(approverRec.Approval_Header__c).Status__c=='Submitted' && approverRec.Role__c == 'APP' && approverRec.Action__c == 'APPR' && (approverRec.Interested_Party__c != null || approverRec.Interested_Party_Details__c != null)){  
                    strBody=CORE_Chatter_Approval__c.getinstance('Ariba-RequestApproved').Text_Value__c;
                    strBody = strBody.replace('XXX',lstHeader.get(approverRec.Approval_Header__c).Name);                  
                    if(approverRec.Interested_Party__c != null)                       
                        strBody = strBody.replace('YYY',mapUser.get(approverRec.Interested_Party__c).Name);                   
                    if(approverRec.Interested_Party__c == null && approverRec.Interested_Party_Details__c != null)
                        strBody = strBody.replace('YYY',approverRec.Interested_Party_Details__c);                                     
                    lstFeedItem.add(new FeedItem(Type = 'LinkPost', Body = strBody, ParentId = lstHeader.get(approverRec.Approval_Header__c).Id, LinkURL =baseUrl+'/'+lstHeader.get(approverRec.Approval_Header__c).Id, Title = lstHeader.get(approverRec.Approval_Header__c).Name,CreatedById = CORE_Chatter_Approval__c.getinstance('Ariba').Text_Value__c));  
                } */
                
             //Request Rejected with (Role__c = 'APP' and Action__c ='REJC') 
               /* else if(lstHeader.get(approverRec.Approval_Header__c).Status__c=='Denied' && approverRec.Role__c == 'APP' && approverRec.Action__c == 'REJC' && (approverRec.Interested_Party__c != null || approverRec.Interested_Party_Details__c != null)){
                    strBody=CORE_Chatter_Approval__c.getinstance('Ariba-RequestRejected').Text_Value__c;
                    strBody = strBody.replace('XXX',lstHeader.get(approverRec.Approval_Header__c).Name);
                    if(approverRec.Interested_Party__c != null)    
                        strBody = strBody.replace('YYY',mapUser.get(approverRec.Interested_Party__c).Name);
                    if(approverRec.Interested_Party__c == null && approverRec.Interested_Party_Details__c != null)
                        strBody = strBody.replace('YYY',approverRec.Interested_Party_Details__c);  
                    lstFeedItem.add(new FeedItem(Type = 'LinkPost', Body = strBody, ParentId = lstHeader.get(approverRec.Approval_Header__c).Id, LinkURL =baseUrl+'/'+lstHeader.get(approverRec.Approval_Header__c).Id, Title = lstHeader.get(approverRec.Approval_Header__c).Name,CreatedById = CORE_Chatter_Approval__c.getinstance('Ariba').Text_Value__c));  
                } */
                               
            //Approver added with (Role__c = 'APP' and Is_Active__c=true))
                 if(lstHeader.get(approverRec.Approval_Header__c).Status__c=='Submitted' && approverRec.Role__c == 'APP' && approverRec.Is_Active__c==true && approverRec.Action__c != 'REJC' && approverRec.Action__c != 'APPR' ){
                    //send a notification to newly added approver.
                    if(lstHeader.get(approverRec.Approval_Header__c).Requested_For_Details__c == lstHeader.get(approverRec.Approval_Header__c).Requested_By_Details__c){
                        strBody = CORE_Chatter_Approval__c.getinstance('Ariba-ApproverAdded1').Text_Value__c;
                        if(lstHeader.get(approverRec.Approval_Header__c).Requested_For_Details__c != null)
                            strBody = strBody.replace('ZZZ',lstHeader.get(approverRec.Approval_Header__c).Requested_For_Details__c);
                        else
                            strBody = strBody.replace('ZZZ','');    
                    }  
                      
                    if(lstHeader.get(approverRec.Approval_Header__c).Requested_For_Details__c != lstHeader.get(approverRec.Approval_Header__c).Requested_By_Details__c){
                        strBody = CORE_Chatter_Approval__c.getinstance('Ariba-ApproverAdded2').Text_Value__c;
                        if(lstHeader.get(approverRec.Approval_Header__c).Requested_For_Details__c != null)
                            strBody = strBody.replace('ZZZ',lstHeader.get(approverRec.Approval_Header__c).Requested_For_Details__c);
                        else
                            strBody = strBody.replace('ZZZ','');
                        if(lstHeader.get(approverRec.Approval_Header__c).Requested_By_Details__c != null)
                            strBody = strBody.replace('AAA',lstHeader.get(approverRec.Approval_Header__c).Requested_By_Details__c);
                        else
                            strBody = strBody.replace('AAA','');    
                    }
                    
                    if(strBody != null){
                        //Replace YYY with PR id
                        strBody = strBody.replace('YYY',lstHeader.get(approverRec.Approval_Header__c).Name);
                        
                        //Replace XXX with Approver name                                     
                        if(approverRec.Interested_Party_Details__c != null )
                            strBody = strBody.replace('XXX',approverRec.Interested_Party_Details__c);  
                        else
                            strBody = strBody.replace('XXX','');                                        
                        lstFeedItem.add(new FeedItem(Type = 'LinkPost', Body = strBody, ParentId = lstHeader.get(approverRec.Approval_Header__c).Id, LinkURL =baseUrl+'/'+lstHeader.get(approverRec.Approval_Header__c).Id, Title = lstHeader.get(approverRec.Approval_Header__c).Name,CreatedById = CORE_Chatter_Approval__c.getinstance('Ariba').Text_Value__c));  
                        //lstFeedItem.add(new FeedItem(Type = 'LinkPost', Body = strBody, ParentId = lstHeader.get(approverRec.Approval_Header__c).Id, LinkURL =baseUrl+'/apex/Core_CA_ApprovalHomePage#/MyApprovalsHome?headerId='+lstHeader.get(approverRec.Approval_Header__c).Id+'&ipId='+approverRec.Id, Title = lstHeader.get(approverRec.Approval_Header__c).Name,CreatedById = CORE_Chatter_Approval__c.getinstance('Ariba').Text_Value__c));  
                    }
                    
                    
                    //send a notification to Requested_For.
                    /*if(CORE_Chatter_Approval__c.getinstance('Ariba_RequestedFor_Notification').Text_Value__c == 'true' || CORE_Chatter_Approval__c.getinstance('Ariba_RequestedFor_Notification').Text_Value__c == 'True'){
                        strBody=CORE_Chatter_Approval__c.getinstance('Ariba-ApproverAdded2').Text_Value__c;
                        if(approverRec.Interested_Party__c != null){
                            strBody = strBody.replace('XXX',lstHeader.get(approverRec.Approval_Header__c).Name)+' '+mapUser.get(approverRec.Interested_Party__c).Name+'.';                           
                        }
                        if( approverRec.Interested_Party__c == null && approverRec.Interested_Party_Details__c != null){
                           strBody = strBody.replace('XXX',lstHeader.get(approverRec.Approval_Header__c).Name)+' '+approverRec.Interested_Party_Details__c+'.';
                        }
                        if(lstHeader.get(approverRec.Approval_Header__c).Requested_For__c!=null && (approverRec.Interested_Party__c != null || approverRec.Interested_Party_Details__c != null))             
                            lstFeedItem.add(new FeedItem(Type = 'LinkPost', Body = strBody, ParentId = lstHeader.get(approverRec.Approval_Header__c).Id, LinkURL =baseUrl+'/'+lstHeader.get(approverRec.Approval_Header__c).Id, Title = lstHeader.get(approverRec.Approval_Header__c).Name,CreatedById = CORE_Chatter_Approval__c.getinstance('Ariba').Text_Value__c));
                   } */
                }
                              
            }   
        }  
        /* End of Ariba notification code */
        
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
        
        //update the list of header records whose status need to be changed for GTES.
        /*if(!setHeaderStatus.isempty()){
            List<Core_Approval_Header__c> lstHeaderStatus=new List<Core_Approval_Header__c>();
            Map<Id,List<String>> mapHeaderStatus=new Map<Id,List<String>>();
            for(Core_Approval_Header__c header : setHeaderStatus){
                if(!mapHeaderStatus.containsKey(header.Id))
                    mapHeaderStatus.put(header.Id,new List<String>());            
                mapHeaderStatus.get(header.Id).add(header.Status__c);
            }
            for(Id id : mapHeaderStatus.keyset()){
                List<string> lstStatus=new List<string>();
                lstStatus=mapHeaderStatus.get(id);
                if(lstStatus.size()>1)
                    lstHeaderStatus.add(new Core_Approval_Header__c(id=id,Status__c='Fully Approved'));
                else
                    lstHeaderStatus.add(new Core_Approval_Header__c(id=id,Status__c=lstStatus[0]));
            }
            Database.update(lstHeaderStatus);
        }*/
        }
        Catch(Exception ex){}
    }
    
    public void handleAfterUpdate(Map<id,Core_Approver_Details__c> approverNew , Map<id,Core_Approver_Details__c> approverOld){
        try{        
        List<feeditem> lstFeedItem=new List<feeditem>();
        Set<EntitySubscription> setEntitySubHeader=new Set<EntitySubscription>();
        List<EntitySubscription> lstEntitySubDelete=new List<EntitySubscription>();
        //Set<Core_Approval_Header__c> setHeaderStatus=new Set<Core_Approval_Header__c>();
        Map<Id,Core_Approval_Header__c> mapHeader =new Map<Id,Core_Approval_Header__c> ([SELECT id,Requested_By__c,Name,Requested_For__c,Status__c,Fully_Approved__c,Manager__c,Requested_For_Details__c,Requested_by_details__c  FROM Core_Approval_Header__c WHERE Id IN (select Approval_Header__c from Core_Approver_Details__c WHERE Id IN : approverNew.keyset())]);
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
            if(approverRec.Interested_Party__c != null && ( (approverRec.Source_System__c=='GTES' && approverRec.Role__c=='APP'&& approverRec.Action__c == 'ACTV' && newApprover.Action__c !=oldApprover.Action__c) || (approverRec.Source_System__c=='Ariba' && newApprover.Is_Active__c==true && oldApprover.Is_Active__c==false && approverRec.Role__c=='APP' && (approverRec.Action__c==''||approverRec.Action__c==' '||approverRec.Action__c==null) ) ) && !(userIdForEntity.contains(approverRec.Interested_Party__c)) ) 
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
                //if(){
                    for(Core_Approver_Details__c  appRec : mapApprover.get(approverRec.Approval_Header__c)){
                        //if(approverRec.Interested_Party__c==appRec.Interested_Party__c && appRec.Is_Active__c==true && appRec.Action__c!='APPR' && approverRec.Id!=appRec.Id) bolMultipleRec=true; 
                       // if(approverRec.Source_System__c=='Ariba' && approverRec.Interested_Party__c==appRec.Interested_Party__c && appRec.Is_Active__c==true && appRec.Action__c!='APPR' && appRec.Action__c!='REJC' && approverRec.Id!=appRec.Id && approverRec.Role__c=='APP' && ((approverRec.Action__c==''||approverRec.Action__c==' '||approverRec.Action__c==null)||(approverRec.Status__c==''||approverRec.Status__c==' '||approverRec.Status__c==null))) bolMultipleRec=true; 
                        //if(approverRec.Source_System__c=='Ariba' && approverRec.Interested_Party__c==appRec.Interested_Party__c && appRec.Is_Active__c==true  && approverRec.Id!=appRec.Id && approverRec.Role__c=='APP' && ((approverRec.Action__c==''||approverRec.Action__c==' '||approverRec.Action__c==null)&&(approverRec.Status__c==''||approverRec.Status__c==' '||approverRec.Status__c==null))) bolMultipleRec=true; 
                        if(appRec.Source_System__c=='Ariba' && approverRec.Interested_Party__c==appRec.Interested_Party__c && appRec.Is_Active__c==true  && approverRec.Id!=appRec.Id && appRec.Role__c=='APP'){
                            if((appRec.Action__c==''||appRec.Action__c==' '||appRec.Action__c==null)&&(appRec.Status__c==''||appRec.Status__c==' '||appRec.Status__c==null)) bolMultipleRec=true;
                        }        
                        if(appRec.Source_System__c=='GTES' && approverRec.Interested_Party__c==appRec.Interested_Party__c && ((appRec.Action__c==''||appRec.Action__c==' '||appRec.Action__c==null)&&(appRec.Status__c==''||appRec.Status__c==' '||appRec.Status__c==null)) && approverRec.Id!=appRec.Id && appRec.Role__c=='APP') bolMultipleRecGTES=true; 
                    }
                //} 
                List<EntitySubscription> lstEntitySubQuery=new List<EntitySubscription>();
                /* Start of Apex Header record Entity Subscription code */
                //if( approverRec.Interested_Party__c!=mapHeader.get(approverRec.Approval_Header__c).Requested_By__c && approverRec.Interested_Party__c!=mapHeader.get(approverRec.Approval_Header__c).Requested_For__c&& approverRec.Interested_Party__c!=mapHeader.get(approverRec.Approval_Header__c).Manager__c){
                   //if((approverRec.Source_System__c=='GTES' && (approverRec.Role__c=='APP'&& (approverRec.Action__c == 'APPR'||approverRec.Action__c == 'REJC'||approverRec.Action__c == 'COPY'))) ||(approverRec.Source_System__c=='Ariba' && approverRec.Action__c=='APPR' && bolMultipleRec==false) && bolMultipleRec==false){
                   if((approverRec.Source_System__c=='GTES' && approverRec.Role__c=='APP'&& bolMultipleRecGTES==false &&
                        ((newApprover.Action__c !=oldApprover.Action__c && (approverRec.Action__c == 'APPR'||approverRec.Action__c == 'REJC'||approverRec.Action__c == 'COPY')) ||
                        (newApprover.Status__c !=oldApprover.Status__c && (approverRec.Status__c=='Approved'||approverRec.Status__c=='Rejected')))
                        ) 
                        ||
                        (approverRec.Source_System__c=='Ariba' && approverRec.Role__c=='APP' && bolMultipleRec==false &&
                        (( newApprover.Action__c !=oldApprover.Action__c && (approverRec.Action__c=='APPR'||approverRec.Action__c=='REJC')) ||
                        (newApprover.Status__c !=oldApprover.Status__c && (approverRec.Status__c=='Approved'||approverRec.Status__c=='Rejected'))
                        )) 
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
            if((newApprover.Interested_Party__c != oldApprover.Interested_Party__c || newApprover.Role__c != oldApprover.Role__c) && approverRec.Interested_Party__c != null && approverRec.Role__c == 'APP'  && !(userId.contains(approverRec.Interested_Party__c)) ) 
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
            if(CORE_Chatter_Approval__c.getinstance('GTES_Notification').Text_Value__c=='Yes'){
                if(approverRec.Source_System__c=='GTES' && mapHeader.get(approverRec.Approval_Header__c).Fully_Approved__c==false){                       
                    
                    //Rejected (Role 'APP' and Action 'REJC' )
                    /*if((approverRec.Role__c=='APP' || approverRec.Role__c=='PRE') &&  approverRec.Action__c=='REJC' && newApprover.Action__c != oldApprover.Action__c && (approverRec.Interested_Party__c!=null || approverRec.Interested_Party_Details__c != null)){
                        
                        //if(mapApprover.get(approverRec.Approval_Header__c) != null){
                            //for(Core_Approver_Details__c otherApproverRec : mapApprover.get(approverRec.Approval_Header__c)){
                               //if((otherApproverRec.Role__c=='EMP' || otherApproverRec.Role__c=='SUB') && otherApproverRec.Interested_Party__c != null){                            
                                    strBody=CORE_Chatter_Approval__c.getinstance('GTES-Rejected').Text_Value__c;
                                    strBody=strBody.replace('XXX',mapHeader.get(approverRec.Approval_Header__c).Name);
                                    if(approverRec.Interested_Party__c != null) strBody=strBody.replace('YYY',mapUser.get(approverRec.Interested_Party__c).Name);
                                        //strBody=strBody+' '+ mapUser.get(approverRec.Interested_Party__c).Name+'.';
                                    if(approverRec.Interested_Party__c == null && approverRec.Interested_Party_Details__c != null) strBody=strBody.replace('YYY',approverRec.Interested_Party_Details__c);
                                        //strBody=strBody+' '+ approverRec.Interested_Party_Details__c+'.';
                                    lstFeedItem.add(new FeedItem( Type = 'LinkPost', Body = strBody, ParentId = approverRec.Approval_Header__c,
                                    LinkURL =baseUrl+'/'+mapHeader.get(approverRec.Approval_Header__c).Id, Title = mapHeader.get(approverRec.Approval_Header__c).Name,CreatedById = CORE_Chatter_Approval__c.getinstance('GTES').Text_Value__c));
                              //}
                           //}
                        //}   
                    }*/
                    
                    //Fully Approved ( Role 'SYS' and Action 'APPR' )
                    /*if(approverRec.Role__c=='SYS' &&  approverRec.Action__c=='APPR' && newApprover.Action__c != oldApprover.Action__c ){
                        if(mapApprover.get(approverRec.Approval_Header__c) != null){
                            setHeaderStatus.add(new Core_Approval_Header__c(id=mapHeader.get(approverRec.Approval_Header__c).Id,Status__c='Fully Approved'));
                            Boolean bolExistedNotification=false;
                            for(Core_Approver_Details__c otherApproverRec : mapApprover.get(approverRec.Approval_Header__c)){
                                if((otherApproverRec.Role__c=='SYS' && otherApproverRec.Action__c=='APPR' && otherApproverRec.Id != approverRec.Id  )||(otherApproverRec.Role__c=='PST' && otherApproverRec.Id != approverRec.Id)) bolExistedNotification=true;
                            }
                            for(Core_Approver_Details__c otherApproverRec : mapApprover.get(approverRec.Approval_Header__c)){
                                if((otherApproverRec.Role__c=='EMP' || otherApproverRec.Role__c=='SUB') && otherApproverRec.Interested_Party__c != null && bolExistedNotification==false){
                                    strBody=CORE_Chatter_Approval__c.getinstance('GTES-FullyApproved').Text_Value__c;
                                    strBody=strBody.replace('XXXXXX',mapHeader.get(approverRec.Approval_Header__c).Name);
                                    lstFeedItem.add(new FeedItem( Type = 'LinkPost', Body = strBody, ParentId = otherApproverRec.Interested_Party__c,
                                    LinkURL =baseUrl+'/'+mapHeader.get(approverRec.Approval_Header__c).Id, Title = mapHeader.get(approverRec.Approval_Header__c).Name,CreatedById = CORE_Chatter_Approval__c.getinstance('GTES').Text_Value__c));
                                }
                            }
                        }   
                    }*/
                   
                   //Recalled 
                   if(approverRec.Role__c=='EMP' &&  approverRec.Action__c=='SUBM' && oldApprover.Role__c=='EMP' && oldApprover.Action__c=='CANC' ){
                       if(mapApprover.get(approverRec.Approval_Header__c) != null){
                           for(Core_Approver_Details__c otherApproverRec : mapApprover.get(approverRec.Approval_Header__c)){
                               if(otherApproverRec.Role__c=='APP' && otherApproverRec.Action__c == 'ACTV'  && otherApproverRec.Status__c!='Approved' && otherApproverRec.Status__c!='Rejected'){                            
                                    strBody = CORE_Chatter_Approval__c.getinstance('GTES-ApproverAdded').Text_Value__c;
                                    if(otherApproverRec.Interested_Party_Details__c!=null) strBody = strBody.replace('XXX',otherApproverRec.Interested_Party_Details__c);
                                    else strBody = strBody.replace('XXX','');
                                    strBody = strBody.replace('YYY',mapHeader.get(approverRec.Approval_Header__c).Name);
                                    if(mapHeader.get(approverRec.Approval_Header__c).Requested_by_details__c!=null) strBody = strBody.replace('ZZZ',mapHeader.get(approverRec.Approval_Header__c).Requested_by_details__c);
                                    else strBody = strBody.replace('ZZZ','');
                                    lstFeedItem.add(new FeedItem(Type = 'LinkPost', Body = strBody, ParentId = approverRec.Approval_Header__c, LinkURL =baseUrl+'/'+mapHeader.get(approverRec.Approval_Header__c).Id, Title = mapHeader.get(approverRec.Approval_Header__c).Name,CreatedById = CORE_Chatter_Approval__c.getinstance('GTES').Text_Value__c));
                                    //lstFeedItem.add(new FeedItem(Type = 'LinkPost', Body = strBody, ParentId = approverRec.Approval_Header__c, LinkURL =baseUrl+'/apex/Core_CA_ApprovalHomePage#/MyApprovalsHome?headerId='+mapHeader.get(approverRec.Approval_Header__c).Id+'&ipId='+approverRec.Id, Title = mapHeader.get(approverRec.Approval_Header__c).Name,CreatedById = CORE_Chatter_Approval__c.getinstance('GTES').Text_Value__c));
                             }
                          }
                       }
                   } 
                   
                   //To set IPStatus Blank
                   if(approverRec.Action__c == 'ACTV' && approverRec.Role__c == 'APP' && newApprover.Action__c != oldApprover.Action__c && approverRec.Interested_Party__c != null) setIpStatus.add(new Core_Approver_Details__c(id=approverRec.Id,Status__c =''));
                }           
            }
            /* End of GTES notification  after update code */
            
            /* Start of Ariba notification  after update code */ 
            if(approverRec.Source_System__c=='Ariba' && CORE_Chatter_Approval__c.getinstance('Ariba_Notification').Text_Value__c == 'Yes' ){
                             
                //In Denied to Resubmit. 
                 if(mapHeader.get(approverRec.Approval_Header__c).Status__c=='Submitted' && approverRec.Role__c == 'APP' && newApprover.Action__c != oldApprover.Action__c && oldApprover.Action__c=='REJC' && (approverRec.Action__c == null || approverRec.Action__c =='') ){               
                   
                   //Set the Ip status to blank
                   setIpStatus.add(new Core_Approver_Details__c(id=approverRec.Id,Status__c =''));
                    
                   //Notification when Requested For == Requested by
                   /* if(mapHeader.get(approverRec.Approval_Header__c).Requested_For__c== mapHeader.get(approverRec.Approval_Header__c).Requested_By__c || mapHeader.get(approverRec.Approval_Header__c).Requested_By__c==null){ 
                        strBody = CORE_Chatter_Approval__c.getinstance('Ariba-ExpenseClaimSubmitted1').Text_Value__c;
                        strBody = strBody.replace('XXX',mapHeader.get(approverRec.Approval_Header__c).Name);
                        strBody = strBody.replace('YYY',mapUser.get(mapHeader.get(approverRec.Approval_Header__c).Requested_For__c).Name);
                        lstFeedItem.add(new FeedItem(Type = 'LinkPost', Body = strBody, ParentId = mapHeader.get(approverRec.Approval_Header__c).Id, LinkURL =baseUrl+'/'+mapHeader.get(approverRec.Approval_Header__c).Id, Title = mapHeader.get(approverRec.Approval_Header__c).Name,CreatedById = CORE_Chatter_Approval__c.getinstance('Ariba').Text_Value__c));     
                    }
                    
                    //Notification when Requested For <> Requested by
                    if(mapHeader.get(approverRec.Approval_Header__c).Requested_By__c!=null && mapHeader.get(approverRec.Approval_Header__c).Requested_For__c!= mapHeader.get(approverRec.Approval_Header__c).Requested_By__c ){
                        strBody = CORE_Chatter_Approval__c.getinstance('Ariba-ExpenseClaimSubmitted2').Text_Value__c;
                        strBody = strBody.replace('XXX',mapHeader.get(approverRec.Approval_Header__c).Name); 
                        strBody = strBody.replace('YYY',mapUser.get(mapHeader.get(approverRec.Approval_Header__c).Requested_By__c).Name);
                        strBody = strBody.replace('ZZZ',mapUser.get(mapHeader.get(approverRec.Approval_Header__c).Requested_For__c).Name);
                        lstFeedItem.add(new FeedItem(Type = 'LinkPost', Body = strBody, ParentId = mapHeader.get(approverRec.Approval_Header__c).Id, LinkURL =baseUrl+'/'+mapHeader.get(approverRec.Approval_Header__c).Id, Title = mapHeader.get(approverRec.Approval_Header__c).Name, CreatedById = CORE_Chatter_Approval__c.getinstance('Ariba').Text_Value__c));     
                   }*/
                   
                   //Approver added Notification to approver other than denied approver.
                   if(mapApprover.get(approverRec.Approval_Header__c) != null){ 
                       for(Core_Approver_Details__c otherApproverRec : mapApprover.get(approverRec.Approval_Header__c)){
                             if(otherApproverRec.Role__c=='APP' && otherApproverRec.Is_Active__c == true && otherApproverRec.Action__c != 'APPR' ){ 
                                 if(mapHeader.get(approverRec.Approval_Header__c).Requested_For_Details__c == mapHeader.get(approverRec.Approval_Header__c).Requested_By_Details__c){
                                     strBody=CORE_Chatter_Approval__c.getinstance('Ariba-ApproverAdded1').Text_Value__c;
                                     if(mapHeader.get(approverRec.Approval_Header__c).Requested_For_Details__c != null )                         
                                         strBody = strBody.replace('ZZZ',mapHeader.get(approverRec.Approval_Header__c).Requested_For_Details__c);
                                     else
                                         strBody = strBody.replace('ZZZ','');      
                                 }
                                 
                                 if(mapHeader.get(approverRec.Approval_Header__c).Requested_For_Details__c != mapHeader.get(approverRec.Approval_Header__c).Requested_By_Details__c){
                                     strBody=CORE_Chatter_Approval__c.getinstance('Ariba-ApproverAdded2').Text_Value__c;
                                     if(mapHeader.get(approverRec.Approval_Header__c).Requested_For_Details__c != null )                         
                                         strBody = strBody.replace('ZZZ',mapHeader.get(approverRec.Approval_Header__c).Requested_For_Details__c);
                                     else
                                         strBody = strBody.replace('ZZZ','');
                                     if(mapHeader.get(approverRec.Approval_Header__c).Requested_By_Details__c != null)
                                         strBody = strBody.replace('AAA',mapHeader.get(approverRec.Approval_Header__c).Requested_By_Details__c);
                                     else
                                         strBody = strBody.replace('AAA','');    
                                }
                               
                               if(strBody != null){
                                   strBody = strBody.replace('YYY',mapHeader.get(approverRec.Approval_Header__c).Name);
                                   
                                   if( otherApproverRec.Interested_Party_Details__c != null )
                                       strBody = strBody.replace('XXX',otherApproverRec.Interested_Party_Details__c);  
                                   else
                                       strBody = strBody.replace('XXX',''); 
                                   
                                   lstFeedItem.add(new FeedItem(Type = 'LinkPost', Body = strBody, ParentId = mapHeader.get(approverRec.Approval_Header__c).Id, LinkURL =baseUrl+'/'+mapHeader.get(approverRec.Approval_Header__c).Id, Title = mapHeader.get(approverRec.Approval_Header__c).Name,CreatedById = CORE_Chatter_Approval__c.getinstance('Ariba').Text_Value__c));                             
                                   //lstFeedItem.add(new FeedItem(Type = 'LinkPost', Body = strBody, ParentId = mapHeader.get(approverRec.Approval_Header__c).Id, LinkURL =baseUrl+'/apex/Core_CA_ApprovalHomePage#/MyApprovalsHome?headerId='+mapHeader.get(approverRec.Approval_Header__c).Id+'&ipId='+approverRec.Id, Title = mapHeader.get(approverRec.Approval_Header__c).Name,CreatedById = CORE_Chatter_Approval__c.getinstance('Ariba').Text_Value__c));                             
                              }
                           }
                       }    
                    }                                    
                }
                //Request Approved with (Role__c = 'APP' and Action__c ='APPR')
                /*if(mapHeader.get(approverRec.Approval_Header__c).Status__c =='Submitted' && approverRec.Role__c == 'APP' && newApprover.Action__c != oldApprover.Action__c && approverRec.Action__c == 'APPR' && (approverRec.Interested_Party__c != null || approverRec.Interested_Party_Details__c != null)){
                    strBody=CORE_Chatter_Approval__c.getinstance('Ariba-RequestApproved').Text_Value__c;
                    strBody = strBody.replace('XXX',mapHeader.get(approverRec.Approval_Header__c).Name);
                    if(approverRec.Interested_Party__c != null)                        
                        strBody = strBody.replace('YYY',mapUser.get(approverRec.Interested_Party__c).Name);
                    if(approverRec.Interested_Party__c == null && approverRec.Interested_Party_Details__c != null)
                        strBody = strBody.replace('YYY',approverRec.Interested_Party_Details__c);                                
                    lstFeedItem.add(new FeedItem(Type = 'LinkPost', Body = strBody, ParentId = mapHeader.get(approverRec.Approval_Header__c).Id, LinkURL =baseUrl+'/'+mapHeader.get(approverRec.Approval_Header__c).Id, Title = mapHeader.get(approverRec.Approval_Header__c).Name,CreatedById = CORE_Chatter_Approval__c.getinstance('Ariba').Text_Value__c));  
                } 
             
                else
                //Request Rejected with (Role__c = 'APP' and Action__c ='REJC')
                if(mapHeader.get(approverRec.Approval_Header__c).Status__c =='Denied' && approverRec.Role__c == 'APP' && newApprover.Action__c != oldApprover.Action__c && approverRec.Action__c == 'REJC' && (approverRec.Interested_Party__c != null || approverRec.Interested_Party_Details__c != null)){
                    strBody=CORE_Chatter_Approval__c.getinstance('Ariba-RequestRejected').Text_Value__c;
                    strBody = strBody.replace('XXX',mapHeader.get(approverRec.Approval_Header__c).Name);
                    if(approverRec.Interested_Party__c != null)                    
                        strBody = strBody.replace('YYY',mapUser.get(approverRec.Interested_Party__c).Name);                    
                    if(approverRec.Interested_Party__c == null && approverRec.Interested_Party_Details__c != null)                       
                        strBody = strBody.replace('YYY',approverRec.Interested_Party_Details__c);                      
                    lstFeedItem.add(new FeedItem(Type = 'LinkPost', Body = strBody, ParentId = mapHeader.get(approverRec.Approval_Header__c).Id, LinkURL =baseUrl+'/'+mapHeader.get(approverRec.Approval_Header__c).Id, Title = mapHeader.get(approverRec.Approval_Header__c).Name,CreatedById = CORE_Chatter_Approval__c.getinstance('Ariba').Text_Value__c));  
                } */
                
               // else
                //Approver Added with IsActive changed from false to true
                if(mapHeader.get(approverRec.Approval_Header__c).Status__c =='Submitted' && approverRec.Role__c == 'APP' && newApprover.Is_Active__c == true && oldApprover.Is_Active__c == false && approverRec.Action__c != 'REJC' && approverRec.Action__c != 'APPR' ){
                    //send a notification to newly added approver.
                    if(mapHeader.get(approverRec.Approval_Header__c).Requested_For_Details__c == mapHeader.get(approverRec.Approval_Header__c).Requested_By_Details__c){
                        strBody=CORE_Chatter_Approval__c.getinstance('Ariba-ApproverAdded1').Text_Value__c;
                        if(mapHeader.get(approverRec.Approval_Header__c).Requested_For_Details__c != null )                         
                            strBody = strBody.replace('ZZZ',mapHeader.get(approverRec.Approval_Header__c).Requested_For_Details__c);
                        else
                            strBody = strBody.replace('ZZZ','');      
                    }
                    
                    if(mapHeader.get(approverRec.Approval_Header__c).Requested_For_Details__c != mapHeader.get(approverRec.Approval_Header__c).Requested_By_Details__c){
                        strBody=CORE_Chatter_Approval__c.getinstance('Ariba-ApproverAdded2').Text_Value__c;
                        if(mapHeader.get(approverRec.Approval_Header__c).Requested_For_Details__c != null )                         
                            strBody = strBody.replace('ZZZ',mapHeader.get(approverRec.Approval_Header__c).Requested_For_Details__c);
                        else
                            strBody = strBody.replace('ZZZ','');
                        if(mapHeader.get(approverRec.Approval_Header__c).Requested_By_Details__c != null)
                            strBody = strBody.replace('AAA',mapHeader.get(approverRec.Approval_Header__c).Requested_By_Details__c);
                        else
                            strBody = strBody.replace('AAA','');    
                    }
                    
                    if(strBody != null){
                        strBody = strBody.replace('YYY',mapHeader.get(approverRec.Approval_Header__c).Name);
                    
                        if(approverRec.Interested_Party_Details__c !=null )
                            strBody = strBody.replace('XXX',approverRec.Interested_Party_Details__c);  
                        else
                            strBody = strBody.replace('XXX','');  
                        
                        lstFeedItem.add(new FeedItem(Type = 'LinkPost', Body = strBody, ParentId = mapHeader.get(approverRec.Approval_Header__c).Id, LinkURL =baseUrl+'/'+mapHeader.get(approverRec.Approval_Header__c).Id, Title = mapHeader.get(approverRec.Approval_Header__c).Name,CreatedById = CORE_Chatter_Approval__c.getinstance('Ariba').Text_Value__c));  
                       // lstFeedItem.add(new FeedItem(Type = 'LinkPost', Body = strBody, ParentId = mapHeader.get(approverRec.Approval_Header__c).Id, LinkURL =baseUrl+'/apex/Core_CA_ApprovalHomePage#/MyApprovalsHome?headerId='+mapHeader.get(approverRec.Approval_Header__c).Id+'&ipId='+approverRec.Id, Title = mapHeader.get(approverRec.Approval_Header__c).Name,CreatedById = CORE_Chatter_Approval__c.getinstance('Ariba').Text_Value__c));  
                    }
                    //send a notification to Requested_For.
                   /* if(CORE_Chatter_Approval__c.getinstance('Ariba_RequestedFor_Notification').Text_Value__c == 'true' || CORE_Chatter_Approval__c.getinstance('Ariba_RequestedFor_Notification').Text_Value__c == 'True'){
                        strBody=CORE_Chatter_Approval__c.getinstance('Ariba-ApproverAdded2').Text_Value__c;
                        if(approverRec.Interested_Party__c != null){
                            strBody = strBody.replace('XXX',mapHeader.get(approverRec.Approval_Header__c).Name)+' '+mapUser.get(approverRec.Interested_Party__c).Name+'.';                           
                        }
                        if( approverRec.Interested_Party__c == null && approverRec.Interested_Party_Details__c != null){
                           strBody = strBody.replace('XXX',mapHeader.get(approverRec.Approval_Header__c).Name)+' '+approverRec.Interested_Party_Details__c+'.';
                        }
                        if(mapHeader.get(approverRec.Approval_Header__c).Requested_For__c!=null && (approverRec.Interested_Party__c != null || approverRec.Interested_Party_Details__c != null))             
                            lstFeedItem.add(new FeedItem(Type = 'LinkPost', Body = strBody, ParentId = mapHeader.get(approverRec.Approval_Header__c).Id, LinkURL =baseUrl+'/'+mapHeader.get(approverRec.Approval_Header__c).Id, Title = mapHeader.get(approverRec.Approval_Header__c).Name,CreatedById = CORE_Chatter_Approval__c.getinstance('Ariba').Text_Value__c));
                    }*/
                }
                
            }
            /* End of Ariba notification after update code */
            
        }
        //insert the list of feed item record.
        if(!lstFeedItem.isempty()) Database.insert(lstFeedItem);
        //update the list of header records whose status need to be changed for GTES.
        /*if(!setHeaderStatus.isempty()){ 
            List<Core_Approval_Header__c> lstHeaderStatus= new List<Core_Approval_Header__c>(setHeaderStatus);
            Database.update(lstHeaderStatus);
        }*/
        
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
        catch(Exception ex){}
    }
    public void handleAfterDelete (List<Core_Approver_Details__c > approverList){
        try{
        List<feeditem> lstFeedItem=new List<feeditem>();
        Set<Id> approverHeaderids = new Set<Id>();
        Set<Id> approverInterestedparty = new Set<Id>();
        List<Core_Approval_Header__Share> lstApexSharingDelete=new List<Core_Approval_Header__Share>();
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
         
        for(Core_Approver_Details__c id : approverList){
            approverHeaderids.add(id.Approval_Header__c); 
            approverInterestedparty.add(id.Interested_Party__c);    
        } 
        
        Map<Id,Core_Approval_Header__c> mapHeader =new Map<Id,Core_Approval_Header__c> ([SELECT Requested_By__c,Requested_For__c,Name,Id,Status__c,Manager__c FROM Core_Approval_Header__c WHERE Id IN : approverHeaderids]); 
        
        List<Core_Approver_Details__c> lstApprover = [SELECT Approval_Header__c , Role__c,Interested_Party__c,Action__c,Is_Active__c,Interested_Party_Details__c  FROM Core_Approver_Details__c where Approval_Header__c in :approverHeaderids and Is_Active__c=true and Source_System__c='Ariba'];
        
        
        for(Core_Approval_Header__c id : mapHeader.values()){
            approverInterestedparty.add(id.Requested_For__c);
            approverInterestedparty.add(id.Requested_By__c);
        }
        
        Map<Id,User> mapUser = new Map<Id,User>([Select Name FROM User WHERE IsActive= true and Id IN : approverInterestedparty]);
        
        for(Core_Approver_Details__c approverRec : approverList){
            
            //****Delete access to record Start
        
            //for(Core_Approver_Details__c approverRec : approverList){
                Boolean bolMultipleRec=false;
                if(approverRec.Source_System__c=='Ariba'){
                    for(Core_Approver_Details__c  appRec : lstApprover){
                        if(approverRec.Approval_Header__c==appRec.Approval_Header__c && approverRec.Interested_Party__c==appRec.Interested_Party__c && appRec.Is_Active__c==true && appRec.Action__c!='APPR' && approverRec.Id!=appRec.Id) bolMultipleRec=true; 
                    }
                }
                List<Core_Approval_Header__Share> lstApexSharingQuery=new List<Core_Approval_Header__Share>();
                /* Start of Apex Header record Entity Subscription code */
                if(approverRec.Interested_Party__c!=mapHeader.get(approverRec.Approval_Header__c).Requested_By__c && approverRec.Interested_Party__c!=mapHeader.get(approverRec.Approval_Header__c).Requested_For__c && approverRec.Interested_Party__c!=mapHeader.get(approverRec.Approval_Header__c).Manager__c && ((approverRec.Source_System__c=='GTES' )  || (approverRec.Source_System__c=='Ariba' && bolMultipleRec==false)) )  {
                    lstApexSharingQuery=[SELECT Id,ParentId,UserOrGroupId FROM Core_Approval_Header__Share WHERE UserOrGroupId = :approverRec.Interested_Party__c AND ParentId = :approverRec.Approval_Header__c];
                }
                if(!lstApexSharingQuery.isempty()) lstApexSharingDelete.add(lstApexSharingQuery[0]);
            //}
            
            //****Delete access to record End
            
            /*if(approverRec.Source_System__c=='Ariba' && CORE_Chatter_Approval__c.getinstance('Ariba_Notification').Text_Value__c == 'Yes'){
                String strBody;
                              
                //Approver Deleted
                if(mapHeader.get(approverRec.Approval_Header__c).Status__c=='Submitted' && approverRec.Role__c == 'APP' && (approverRec.Interested_Party__c != null || approverRec.Interested_Party_Details__c != null) ) {   
                    strBody = CORE_Chatter_Approval__c.getinstance('Ariba-ApproverDeleted').Text_Value__c;
                    strBody = strBody.replace('YYY',mapHeader.get(approverRec.Approval_Header__c).Name);
                    
                    if(approverRec.Interested_Party__c != null){
                        strBody = strBody.replace('XXX',mapUser.get(approverRec.Interested_Party__c).Name);
                    }
                    if(approverRec.Interested_Party__c == null && approverRec.Interested_Party_Details__c != null){
                        strBody = strBody.replace('XXX',approverRec.Interested_Party_Details__c);
                    } 
                    lstFeedItem.add(new FeedItem(Type = 'LinkPost', Body = strBody, ParentId = mapHeader.get(approverRec.Approval_Header__c).Id, LinkURL =baseUrl+'/'+mapHeader.get(approverRec.Approval_Header__c).Id, Title = mapHeader.get(approverRec.Approval_Header__c).Name,CreatedById = CORE_Chatter_Approval__c.getinstance('Ariba').Text_Value__c));     
                    
                }
            } */
        }
        //insert the list of feed item record.
        if(!lstFeedItem.isempty()) Database.insert(lstFeedItem);
        
        //delete access to record
        if(!lstApexSharingDelete.isempty()) Database.delete(lstApexSharingDelete);
        }
        catch(Exception ex){}
    }
}