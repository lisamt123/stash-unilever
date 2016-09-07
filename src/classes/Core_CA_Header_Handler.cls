/*
  Class Name: Core_CA_Header_Handler
  Author : Mindtree
  Date: 15 Oct 2014
  Requirement/Project Name: Unilever Salesforce Engagement
  Requirement/Description: This is a handler class which executes from trigger, This class is mainly used to
                           1. Update few fields -before insert
                           2. Give permission to specific users - Apex sharing -after insert
                           3. Trigger notification -after update
*/

public class Core_CA_Header_Handler{

    public void handleBeforeInsert(List<Core_Approval_Header__c > headerList){
    
        List<RecordType> aribaRecordType  = [SELECT Id FROM RecordType where Name ='Ariba' AND SobjectType = 'Core_Approval_Header__c'];
        List<RecordType> gtesRecordType   = [SELECT Id FROM RecordType where Name ='GTES' AND SobjectType = 'Core_Approval_Header__c'];
        List<RecordType> clarityRecordType  = [SELECT Id FROM RecordType where Name ='Clarity' AND SobjectType = 'Core_Approval_Header__c'];
        List<RecordType> invoiceRecordType   = [SELECT Id FROM RecordType where Name ='Invoice' AND SobjectType = 'Core_Approval_Header__c'];
        
        for(Core_Approval_Header__c headerRec : headerList){
          
           //Fetching Record Type Id for Selected Source System.
           if(headerRec.Source_System__c == 'GTES')
                headerRec.RecordTypeId  = gtesRecordType[0].ID;                             
           if(headerRec.Source_System__c == 'Ariba')
                headerRec.RecordTypeId  = aribaRecordType[0].ID;
           if(headerRec.Source_System__c == 'Clarity')
                headerRec.RecordTypeId  = clarityRecordType[0].ID;                             
           if(headerRec.Source_System__c == 'Invoice')
                headerRec.RecordTypeId  = invoiceRecordType[0].ID;
           
           
           // Updating Name field with External System Value.
           headerRec.Name = headerRec.External_System_Id__c;           
        }
    }
    
    public void handleAfterInsert(List<Core_Approval_Header__c > headerList){
        try{
        List<Core_Approval_Header__Share> lstShareHeader=new List<Core_Approval_Header__Share>();
        List<EntitySubscription> lstEntitySubHeader=new List<EntitySubscription>();
        List<FeedItem> lstFeedItem = new List<FeedItem>();
        List<Core_Approver_Details__c> lstactiveApprover = new List<Core_Approver_Details__c>();
        Set<Id> headerids = new Set<Id>();
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
        Map<Id,List<Core_Approver_Details__c>> mapApprover = new Map<Id,List<Core_Approver_Details__c>>();
        Set<Core_Approval_Header__c> setHeaderStatus=new Set<Core_Approval_Header__c>();
        Set<Id> userIds= new Set<Id>();
        //List<EntitySubscription> lstEntitySubDelete=new List<EntitySubscription>();
        
        for(Core_Approval_Header__c id : headerList){
            headerids.add(id.ID);
            userIds.add(id.Requested_By__c);
            userIds.add(id.Requested_For__c);
            userIds.add(id.Invalid_PR_Approver__c);
        }
        
        List<Core_Approver_Details__c> lstApprover = [SELECT id,Approval_Header__c , Role__c,Interested_Party__c FROM Core_Approver_Details__c where Approval_Header__c IN: headerids and Source_System__c='GTES'];      
                 
        List<Core_Approval_Header__Share> headerShareObj= [SELECT UserOrGroupId,ParentId  FROM Core_Approval_Header__Share WHERE ParentId IN : headerids ];
        List<EntitySubscription> headerEntitySubObj= [SELECT ParentId,SubscriberId FROM EntitySubscription WHERE ParentId IN : headerids ];
        
        //Create map with Header record along with all the IP's.
        for(Core_Approver_Details__c approver: lstApprover){
            if(!mapApprover.containsKey(approver.Approval_Header__c))
               mapApprover.put(approver.Approval_Header__c,new List<Core_Approver_Details__c>());            
            mapApprover.get(approver.Approval_Header__c).add(approver);
        }
        
        //Create Map of users
        Map<Id,User> mapUser = new Map<Id,User>([Select Name,Id FROM User WHERE IsActive= true and Id IN : userIds]);
        
        // Iterate through the Header records          
        for(Core_Approval_Header__c headerRec : headerList){       
           /*
           Set<Id> setUserId=new Set<Id>();
           Set<Id> userorGroupIds = new Set<Id>();
           
           //create Set of userIds which are having sharing permission for the current record.
           for(Core_Approval_Header__Share shareid : headerShareObj){
               if(shareid.ParentId  == headerRec.Id)
                userorGroupIds.add(shareid.UserOrGroupId);
           }
           
           
           //Check whether Manager is not null and dont have sharing permission for current record.
           if(headerRec.Manager__c!=null && !(userorGroupIds.contains(headerRec.Manager__c)))
              setUserId.add(headerRec.Manager__c);
           //Check whether Requested By is not null and dont have sharing permission for current record.
           if(headerRec.Requested_By__c!=null && !(userorGroupIds.contains(headerRec.Requested_By__c)))
              setUserId.add(headerRec.Requested_By__c);
           //Check whether Requested For is not null and dont have sharing permission for current record.
           if(headerRec.Requested_For__c!=null && !(userorGroupIds.contains(headerRec.Requested_For__c))) 
              setUserId.add(headerRec.Requested_For__c);
             
                    
           for(Id userId:setUserId){
            //Create Header Share object and assign the userId to whom the current record permission should be given. 
               Core_Approval_Header__Share shareObj=new Core_Approval_Header__Share();
               shareObj.ParentId=headerRec.Id;
               shareObj.UserOrGroupId=userId;
               shareObj.AccessLevel='Edit';
               lstShareHeader.add(shareObj);
           }*/ 
           
           Set<Id> setUserIdForEntity=new Set<Id>();
           Set<Id> subscriberIdForEntity = new Set<Id>();
           
           //create Set of userIds who are already following the current record.
           for(EntitySubscription entityid : headerEntitySubObj){
               if(entityid.ParentId  == headerRec.Id)
                subscriberIdForEntity.add(entityid.SubscriberId);
           }
           
           //Check whether Manager is not null and not following the current record.
           //Commented Code ((headerRec.Source_System__c=='GTES' && headerRec.Fully_Approved__c!=True) || (headerRec.Source_System__c=='Ariba' && headerRec.Status__c!='Fully Approved'))
           /*if(headerRec.Manager__c!=null && !(subscriberIdForEntity.contains(headerRec.Manager__c)))
              setUserIdForEntity.add(headerRec.Manager__c);
           //Check whether Requested By is not null and not following the current record.
           if(headerRec.Requested_By__c!=null && !(subscriberIdForEntity.contains(headerRec.Requested_By__c)))
              setUserIdForEntity.add(headerRec.Requested_By__c);
           //Check whether Requested For is not null and not following the current record.
           if(headerRec.Requested_For__c!=null && !(subscriberIdForEntity.contains(headerRec.Requested_For__c))) 
              setUserIdForEntity.add(headerRec.Requested_For__c);
                      
           for(Id userId:setUserIdForEntity){
            //Create EntitySubscription object and assign the user who need to follow the current record. 
               EntitySubscription entityObj=new EntitySubscription();
               entityObj.ParentId=headerRec.Id;
               entityObj.SubscriberId=userId;
               lstEntitySubHeader.add(entityObj);
           }*/
           
           if(headerRec.Source_System__c=='GTES' && CORE_Chatter_Approval__c.getinstance('GTES_Notification').Text_Value__c=='Yes'){
                //If Fully Approved field is True
                if(headerRec.Fully_Approved__c){
                    /*List<EntitySubscription> lstEntitySubQuery=new List<EntitySubscription>();
                    lstEntitySubQuery=[SELECT Id,ParentId,SubscriberId FROM EntitySubscription WHERE ParentId = :headerRec.Id];
                    if(!lstEntitySubQuery.isempty()) lstEntitySubDelete.addAll(lstEntitySubQuery);*/
                    setHeaderStatus.add(new Core_Approval_Header__c(id=headerRec.Id,Status__c='Fully Approved'));
                    //if( mapApprover.get(headerRec.Id) != null){
                        //for(Core_Approver_Details__c approverRec : mapApprover.get(headerRec.Id)){
                            //if((approverRec.role__c=='EMP' || approverRec.role__c=='SUB')&& approverRec.Interested_Party__c!=null){
                                    /*String strBody=CORE_Chatter_Approval__c.getinstance('GTES-FullyApproved').Text_Value__c;
                                    strBody=strBody.replace('XXX',headerRec.Name);
                                    lstFeedItem.add(new FeedItem( Type = 'LinkPost', Body = strBody, ParentId = headerRec.Id,
                                                                  LinkURL = baseUrl+'/'+headerRec.Id, Title = headerRec.Name,CreatedById = CORE_Chatter_Approval__c.getinstance('GTES').Text_Value__c));*/
                            //}
                        //} 
                    //}    
                }
                else setHeaderStatus.add(new Core_Approval_Header__c(id=headerRec.Id,Status__c='Submitted'));
            }
           
           //if(headerRec.Source_System__c=='Ariba' && CORE_Chatter_Approval__c.getinstance('Ariba_Notification').Text_Value__c == 'Yes'){
                //String strBody;
                
                /*trigger notification regarding invalid PR
                if(headerRec.Invalid_PR__c == true){                   
                    strBody = CORE_Chatter_Approval__c.getinstance('Ariba-InvalidPR').Text_Value__c; 
                    strBody = strBody.replace('XXX',headerRec.Name);
                   
                    if(headerRec.Invalid_PR_Approver__c != null) strBody = strBody.replace('YYY',mapUser.get(headerRec.Invalid_PR_Approver__c).Name);
                    else strBody = strBody.replace('YYY','');
                    
                    if(headerRec.Invalid_PR_Reason__c != null)strBody = strBody.replace('ZZZ',headerRec.Invalid_PR_Reason__c); 
                    else strBody = strBody.replace('ZZZ','');  
                    
                    lstFeedItem.add(new FeedItem(Type = 'LinkPost', Body = strBody, ParentId = headerRec.Id, LinkURL = baseUrl+'/'+headerRec.Id, Title = headerRec.Name, CreatedById = CORE_Chatter_Approval__c.getinstance('Ariba').Text_Value__c));                 
                    
                    //Clear the values of all active approver who have blank field value in action.
                    if( mapApprover.get(headerRec.Id) != null){                                                                          
                        for(Core_Approver_Details__c approverRec : mapApprover.get(headerRec.Id)){
                            if(approverRec.role__c=='APP'&& approverRec.Is_Active__c == true && (approverRec.Action__c == '' || approverRec.Action__c == null) ){
                                lstactiveApprover.add(new Core_Approver_Details__c(Id=approverRec.Id,Send_to_Source_System__c='',Status__c=''));        
                            }
                        }
                    } 
                }*/ 
                
                
               /* if(headerRec.Status__c=='Submitted'){
                   
                  //Notification when Requested For == Requested by
                  if(headerRec.Requested_For__c != null && (headerRec.Requested_For__c== headerRec.Requested_By__c || headerRec.Requested_By__c==null)){
                    strBody = CORE_Chatter_Approval__c.getinstance('Ariba-ExpenseClaimSubmitted1').Text_Value__c;
                    strBody = strBody.replace('XXX',headerRec.Name);
                    strBody = strBody.replace('YYY',mapUser.get(headerRec.Requested_For__c).Name); 
                    lstFeedItem.add(new FeedItem(Type = 'LinkPost', Body = strBody, ParentId = headerRec.Id, LinkURL =baseUrl+'/'+headerRec.Id, Title = headerRec.Name,CreatedById = CORE_Chatter_Approval__c.getinstance('Ariba').Text_Value__c));     
                  }
                  
                  //Notification when Requested For <> Requested by
                  if(headerRec.Requested_For__c != null && headerRec.Requested_By__c!=null && headerRec.Requested_For__c!=headerRec.Requested_By__c){
                    strBody = CORE_Chatter_Approval__c.getinstance('Ariba-ExpenseClaimSubmitted2').Text_Value__c;
                    strBody = strBody.replace('XXX',headerRec.Name); 
                    strBody = strBody.replace('YYY',mapUser.get(headerRec.Requested_By__c).Name);
                    strBody = strBody.replace('ZZZ',mapUser.get(headerRec.Requested_For__c).Name);  
                    lstFeedItem.add(new FeedItem(Type = 'LinkPost', Body = strBody, ParentId = headerRec.Id, LinkURL =baseUrl+'/'+headerRec.Id, Title = headerRec.Name,CreatedById = CORE_Chatter_Approval__c.getinstance('Ariba').Text_Value__c));     
                  }
                  
                }
                //Request Fully Approved
                if(headerRec.Status__c=='Fully Approved'){
                    //List<EntitySubscription> lstEntitySubQuery=new List<EntitySubscription>();
                    //lstEntitySubQuery=[SELECT Id,ParentId,SubscriberId FROM EntitySubscription WHERE ParentId = :headerRec.Id];
                    //if(!lstEntitySubQuery.isempty()) lstEntitySubDelete.addAll(lstEntitySubQuery);
                    strBody = CORE_Chatter_Approval__c.getinstance('Ariba-RequestFullyApproved').Text_Value__c;
                    strBody = strBody.replace('XXX',headerRec.Name);  
                    //if(headerRec.Requested_For__c!=null ) 
                        lstFeedItem.add(new FeedItem(Type = 'LinkPost', Body = strBody, ParentId = headerRec.Id, LinkURL =baseUrl+'/'+headerRec.Id, Title = headerRec.Name,CreatedById = CORE_Chatter_Approval__c.getinstance('Ariba').Text_Value__c));     
                } */
                
             //}
          }
          //insert the feed item record.
          if(!lstFeedItem.isEmpty()) Database.insert(lstFeedItem);
          //insert the header share record.
          if(!lstShareHeader.isempty()) Database.insert(lstShareHeader);
          //update the list of header records whose status need to be changed for GTES.    
          if(!setHeaderStatus.isempty()){ 
              List<Core_Approval_Header__c> lstHeaderStatus= new List<Core_Approval_Header__c>(setHeaderStatus);
              Database.update(lstHeaderStatus);
          }
          //insert the active aprover during invalid PR case.
          if(!lstactiveApprover.isempty()) {
          //system.debug('####'+lstactiveApprover);
              Database.update(lstactiveApprover);
          }
          //insert the entity subscription record.
          //if(!lstEntitySubHeader.isempty()) Database.insert(lstEntitySubHeader);
          //delete entity subscription record
          //if(!lstEntitySubDelete.isempty()) Database.delete(lstEntitySubDelete);
        }
        catch (Exception ex) {
         while (ex.getCause() != null)
         ex = ex.getCause();
         System.Debug('Error:['+ ex.getMessage()+']');   
    
      }
    }
    
    public void handleAfterUpdate(map<Id,Core_Approval_Header__c> headerNew, map<Id,Core_Approval_Header__c> headerOld){
        try{
        List<feeditem> lstFeedItem=new List<feeditem>();
        List<Core_Approver_Details__c> lstactiveApprover = new List<Core_Approver_Details__c>();
        Set<Core_Approval_Header__c> setHeaderStatus=new Set<Core_Approval_Header__c>();
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
        Set<Id> userIds= new Set<Id>();
        //List<EntitySubscription> lstEntitySubDelete=new List<EntitySubscription>();
        
        //Create map with Header record along with all the IP's.
        Map<Id,List<Core_Approver_Details__c>> mapApprover = new Map<Id,List<Core_Approver_Details__c>>();
        List<Core_Approver_Details__c> lstApprover = [SELECT id,Approval_Header__c , Role__c,Interested_Party__c,Is_Active__c,Action__c FROM Core_Approver_Details__c where Approval_Header__c IN: headerNew.keyset() ];
               
        for(Core_Approver_Details__c approver: lstApprover){
            if(!mapApprover.containsKey(approver.Approval_Header__c))
               mapApprover.put(approver.Approval_Header__c,new List<Core_Approver_Details__c>());            
            mapApprover.get(approver.Approval_Header__c).add(approver);
        }
        
        //Create Map of users
        for(Core_Approval_Header__c id : headerNew.values()){
            userIds.add(id.Requested_By__c);
            userIds.add(id.Requested_For__c);
            userIds.add(id.Invalid_PR_Approver__c);
        }
        Map<Id,User> mapUser = new Map<Id,User>([Select Name,Id FROM User WHERE IsActive= true and Id IN : userIds]);
        
        // Iterate through the Header records 
        for(Core_Approval_Header__c headerRec : headerNew.values()){
           Core_Approval_Header__c newHeader = headerNew.get(headerRec.Id);
           Core_Approval_Header__c oldHeader = headerOld.get(headerRec.Id);
           
           if(headerRec.Source_System__c=='GTES' && CORE_Chatter_Approval__c.getinstance('GTES_Notification').Text_Value__c=='Yes'){
                //If Ledger Extract field not equal to null
                if(newHeader.Ledger_Extract__c != null && oldHeader.Ledger_Extract__c==null){
                    setHeaderStatus.add(new Core_Approval_Header__c(id=headerRec.Id,Status__c='Sent for Payment'));
                    //if( mapApprover.get(headerRec.Id) != null){
                        //for(Core_Approver_Details__c approverRec : mapApprover.get(headerRec.Id)){
                            //if((approverRec.role__c=='EMP' || approverRec.role__c=='SUB')&& approverRec.Interested_Party__c!=null){
                                    /*String strBody=CORE_Chatter_Approval__c.getinstance('GTES-SentforPayment').Text_Value__c;
                                    strBody=strBody.replace('XXX',headerRec.Name);
                                    lstFeedItem.add(new FeedItem( Type = 'LinkPost', Body = strBody, ParentId = headerRec.Id,
                                                                  LinkURL = baseUrl+'/'+headerRec.Id, Title = headerRec.Name,CreatedById = CORE_Chatter_Approval__c.getinstance('GTES').Text_Value__c));*/
                            //}
                        //} 
                    //}    
                }
                
                //If Fully Approved field is True
                if(newHeader.Fully_Approved__c && !oldHeader.Fully_Approved__c){
                    /*List<EntitySubscription> lstEntitySubQuery=new List<EntitySubscription>();
                    lstEntitySubQuery=[SELECT Id,ParentId,SubscriberId FROM EntitySubscription WHERE ParentId = :headerRec.Id];
                    if(!lstEntitySubQuery.isempty()) lstEntitySubDelete.addAll(lstEntitySubQuery);*/
                    setHeaderStatus.add(new Core_Approval_Header__c(id=headerRec.Id,Status__c='Fully Approved'));
                    //if( mapApprover.get(headerRec.Id) != null){
                        //for(Core_Approver_Details__c approverRec : mapApprover.get(headerRec.Id)){
                            //if((approverRec.role__c=='EMP' || approverRec.role__c=='SUB')&& approverRec.Interested_Party__c!=null){
                                    /*String strBody=CORE_Chatter_Approval__c.getinstance('GTES-FullyApproved').Text_Value__c;
                                    strBody=strBody.replace('XXX',headerRec.Name);
                                    lstFeedItem.add(new FeedItem( Type = 'LinkPost', Body = strBody, ParentId = headerRec.Id,
                                                                  LinkURL = baseUrl+'/'+headerRec.Id, Title = headerRec.Name,CreatedById = CORE_Chatter_Approval__c.getinstance('GTES').Text_Value__c));*/
                            //}
                        //} 
                    //}    
                }
            }
           
           if(headerRec.Source_System__c=='Ariba' && CORE_Chatter_Approval__c.getinstance('Ariba_Notification').Text_Value__c == 'Yes'){
                String strBody;
                
                if(!oldHeader.Invalid_PR__c  && newHeader.Invalid_PR__c){
                    //trigger notification regarding invalid PR
                    if(headerRec.Invalid_PR_Reason__c != null) 
                        strBody = CORE_Chatter_Approval__c.getinstance('Ariba-InvalidPR').Text_Value__c; 
                    else if(headerRec.Invalid_PR_Reason__c == null)
                        strBody = CORE_Chatter_Approval__c.getinstance('Ariba-InvalidPR-Reason').Text_Value__c; 
                    
                    strBody = strBody.replace('XXX',headerRec.Name);
                   
                    if(headerRec.Invalid_PR_Approver__c != null) strBody = strBody.replace('YYY',mapUser.get(headerRec.Invalid_PR_Approver__c).Name);
                    else strBody = strBody.replace('YYY','');
                    
                    if(headerRec.Invalid_PR_Reason__c != null)strBody = strBody.replace('ZZZ',headerRec.Invalid_PR_Reason__c); 
                     
                    lstFeedItem.add(new FeedItem(Type = 'LinkPost', Body = strBody, ParentId = headerRec.Id, LinkURL = baseUrl+'/'+headerRec.Id, Title = headerRec.Name, CreatedById = CORE_Chatter_Approval__c.getinstance('Ariba').Text_Value__c));                 
                    
                    //Clear the values of all active approver who have blank field value in action.
                    if( mapApprover.get(headerRec.Id) != null){                                                                          
                        for(Core_Approver_Details__c approverRec : mapApprover.get(headerRec.Id)){
                            if(approverRec.role__c=='APP'&& approverRec.Is_Active__c && (approverRec.Action__c == '' || approverRec.Action__c == null) ){
                                lstactiveApprover.add(new Core_Approver_Details__c(Id=approverRec.Id,Send_to_Source_System__c='',Status__c=''));        
                            }
                        }
                    } 
                } 
                
                /*if(newHeader.Status__c != oldHeader.Status__c && oldHeader.Status__c=='Withdrawn' && headerRec.Status__c=='Submitted') {
                   
                   //Notification when Requested For == Requested by
                   if(headerRec.Requested_For__c!= null && (headerRec.Requested_For__c==headerRec.Requested_By__c||headerRec.Requested_By__c==null)){
                       strBody = CORE_Chatter_Approval__c.getinstance('Ariba-ExpenseClaimSubmitted1').Text_Value__c;
                       strBody = strBody.replace('XXX',headerRec.Name);
                       strBody = strBody.replace('YYY',mapUser.get(headerRec.Requested_For__c).Name); 
                         lstFeedItem.add(new FeedItem(Type = 'LinkPost', Body = strBody, ParentId = headerRec.Id, LinkURL =baseUrl+'/'+headerRec.Id, Title = headerRec.Name,CreatedById = CORE_Chatter_Approval__c.getinstance('Ariba').Text_Value__c));     
                   }
                   
                   //Notification when Requested For <> Requested by
                   if(headerRec.Requested_For__c!= null && headerRec.Requested_By__c!=null && headerRec.Requested_For__c!=headerRec.Requested_By__c){
                        strBody = CORE_Chatter_Approval__c.getinstance('Ariba-ExpenseClaimSubmitted2').Text_Value__c;
                        strBody = strBody.replace('XXX',headerRec.Name); 
                        strBody = strBody.replace('YYY',mapUser.get(headerRec.Requested_By__c).Name);
                        strBody = strBody.replace('ZZZ',mapUser.get(headerRec.Requested_For__c).Name);   
                            lstFeedItem.add(new FeedItem(Type = 'LinkPost', Body = strBody, ParentId = headerRec.Id, LinkURL =baseUrl+'/'+headerRec.Id, Title = headerRec.Name,CreatedById = CORE_Chatter_Approval__c.getinstance('Ariba').Text_Value__c));     
                    }
                 }   
                 
                //Request Fully Approved
                if(newHeader.Status__c != oldHeader.Status__c && headerRec.Status__c=='Fully Approved'){
                    //List<EntitySubscription> lstEntitySubQuery=new List<EntitySubscription>();
                    //lstEntitySubQuery=[SELECT Id,ParentId,SubscriberId FROM EntitySubscription WHERE ParentId = :headerRec.Id];
                    //if(!lstEntitySubQuery.isempty()) lstEntitySubDelete.addAll(lstEntitySubQuery);
                    strBody = CORE_Chatter_Approval__c.getinstance('Ariba-RequestFullyApproved').Text_Value__c;
                    strBody = strBody.replace('XXX',headerRec.Name);  
                    //if(headerRec.Requested_For__c!=null ) 
                        lstFeedItem.add(new FeedItem(Type = 'LinkPost', Body = strBody, ParentId = headerRec.Id, LinkURL =baseUrl+'/'+headerRec.Id, Title = headerRec.Name,CreatedById = CORE_Chatter_Approval__c.getinstance('Ariba').Text_Value__c));     
                }*/
           } 
        }
        //insert the list of feed item record.
        if(!lstFeedItem.isempty()) Database.insert(lstFeedItem);
        //update the list of header records whose status need to be changed for GTES.
        
        //insert the active aprover during invalid PR case.
        if(!lstactiveApprover.isempty()) {
        //system.debug('####'+lstactiveApprover);
        Database.update(lstactiveApprover);
        }
        
        //delete entity subscription record
            //if(!lstEntitySubDelete.isempty()) Database.delete(lstEntitySubDelete);
        
        if(!setHeaderStatus.isempty()){
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
        }
      }
       catch (Exception ex) {
         while (ex.getCause() != null)
         ex = ex.getCause();
         System.Debug('Error:['+ ex.getMessage()+']');   
    
      }
    }
}