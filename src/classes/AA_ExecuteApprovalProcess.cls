global with sharing class AA_ExecuteApprovalProcess{
    public String AssginedOwner{get;set;}
    public aa_Agent_Report__c AgentReportObjNew {
        get{
            if(AgentReportObjNew == null){
                AgentReportObjNew = new aa_Agent_Report__c();
            }
            return AgentReportObjNew;
        }set;
    }
  //  public static aa_Agent_Report__c AgentReportDisplayObj{get;set;}
    public aa_Agent_Report__c AgentReportDisplay{get;set;}
    
   webService static void executeApproval(String reportId){
       
        aa_Agent_Report__c AgentReportObj = [select Report_Title__c,status__c ,Approve_Reject__c,Country__c,ownerId,Country__r.Cluster_Id__r.Name, id,Clusterid__c,Clusterid__r.Name from aa_Agent_Report__c where id = :reportId ];
        List<QueueSobject> queues=[Select q.SobjectType, q.QueueId, q.Id ,q.Queue.Name From QueueSobject q where q.SobjectType ='aa_agent_report__c'];
        Map<string,string> queueID=new Map<string,string>();
        for(QueueSobject que : queues){
              queueID.put(que.Queue.Name,que.QueueId);
        }
      //CI owner Assigment 
      if(!String.isEmpty(AgentReportObj.Country__c)){
           
        if(AgentReportObj.Country__r.Cluster_Id__r.Name==AA_Constants.CLUSTER_AFRICA){
            
            AgentReportObj.ownerId=queueID.get('CI Manager Africa Queue');
            
        }else if(AgentReportObj.Country__r.Cluster_Id__r.Name==AA_Constants.CLUSTER_EUROPE){
            
            AgentReportObj.ownerId=queueID.get('CI Manager Europe Queue');
          
        }else if(AgentReportObj.Country__r.Cluster_Id__r.Name==AA_Constants.CLUSTER_LATIN_AMERICA){
            
            AgentReportObj.ownerId=queueID.get('CI Manager Latin America Queue');
            
        }else if(AgentReportObj.Country__r.Cluster_Id__r.Name==AA_Constants.CLUSTER_NAMET_RUB){
        
            
            AgentReportObj.ownerId=queueID.get('CI Manager NametRub Queue');
           
        }else if(AgentReportObj.Country__r.Cluster_Id__r.Name==AA_Constants.CLUSTER_NORTH_AMERICA){
            
            AgentReportObj.ownerId=queueID.get('CI Manager North America Queue');
           
        }else if(AgentReportObj.Country__r.Cluster_Id__r.Name==AA_Constants.CLUSTER_SOUTH_ASIA){
            
            
            AgentReportObj.ownerId=queueID.get('CI Manager South Asia Queue');
            
        }else if(AgentReportObj.Country__r.Cluster_Id__r.Name==AA_Constants.CLUSTER_NORTH_ASIA){
            
            AgentReportObj.ownerId=queueID.get('CI Manager North Asia Queue');
            
        }else if(AgentReportObj.Country__r.Cluster_Id__r.Name==AA_Constants.CLUSTER_SEAA){
            
            AgentReportObj.ownerId=queueID.get('CI Manager SEAA Queue');
            
        }else{
                AgentReportObj.ownerId=queueID.get('CI Manager Default Queue');
        }             
        }         
       //Assigning approvers based on clusterid   
                 
             if(String.isEmpty(AgentReportObj.Country__c)  && !String.isEmpty(AgentReportObj.ClusterId__c)){
                      
             if(AgentReportObj.ClusterId__r.Name==AA_Constants.CLUSTER_AFRICA){
                 
                AgentReportObj.ownerId=queueID.get('CI Manager Africa Queue');
          
             }else if(AgentReportObj.ClusterId__r.Name==AA_Constants.CLUSTER_EUROPE){
                 
                AgentReportObj.ownerId=queueID.get('CI Manager Europe Queue');
         
             }else if(AgentReportObj.ClusterId__r.Name==AA_Constants.CLUSTER_LATIN_AMERICA){
                
                AgentReportObj.ownerId=queueID.get('CI Manager Latin America Queue');
             
             }else if(AgentReportObj.ClusterId__r.Name==AA_Constants.CLUSTER_NAMET_RUB){
                
                AgentReportObj.ownerId=queueID.get('CI Manager NametRub Queue');
             
             }else if(AgentReportObj.ClusterId__r.Name==AA_Constants.CLUSTER_NORTH_AMERICA){
                
                AgentReportObj.ownerId=queueID.get('CI Manager North America Queue');
         
             }else if(AgentReportObj.ClusterId__r.Name==AA_Constants.CLUSTER_SOUTH_ASIA){
               
                AgentReportObj.ownerId=queueID.get('CI Manager South Asia Queue');
                
             } else if(AgentReportObj.ClusterId__r.Name==AA_Constants.CLUSTER_NORTH_ASIA){
                
                AgentReportObj.ownerId=queueID.get('CI Manager North Asia Queue');
                
             } else if(AgentReportObj.ClusterId__r.Name==AA_Constants.CLUSTER_SEAA){
              
              
                AgentReportObj.ownerId=queueID.get('CI Manager SEAA Queue');
         
             }else{
                 
                 AgentReportObj.ownerId = queueID.get('CI Manager Default Queue');
                              }         
                 }
        
        AgentReportObj.status__c = 'CI Manager Approval Pending';
        Schema.DescribeSObjectResult R = aa_Agent_Report__c.SObjectType.getDescribe();
        Map<String,Schema.RecordTypeInfo> RT = R.getRecordTypeInfosByName();
        Id recTypeId = (RT.get('CI Manger Record type')).getRecordTypeId();
       
        AgentReportObj.RecordTypeId=recTypeId;
        update AgentReportObj;
   
    }

    public PageReference executeApprovalfromMobile(){         
         
         String reportId=ApexPages.currentPage().getParameters().get('id');      
       
         aa_Agent_Report__c AgentReportObj = [select Report_Title__c,status__c ,Approve_Reject__c,Country__c,ownerId,Country__r.Cluster_Id__r.Name, id,ClusterId__c, ClusterId__r.Name  from aa_Agent_Report__c where id = :reportId ];
          
         if(AgentReportObj.Approve_Reject__c=='Approve' || AgentReportObj.Approve_Reject__c=='Reject' || AgentReportObj.status__c=='Published (Public)' || AgentReportObj.status__c=='Published (Private)' ){
                     
             return null;
             
         }else{
           
             List<QueueSobject> queues=[Select q.SobjectType, q.QueueId, q.Id ,q.Queue.Name From QueueSobject q where q.SobjectType ='aa_agent_report__c'];
             Map<string,string> queueID=new Map<string,string>();
           
             for(QueueSobject que : queues){
                
                queueID.put(que.Queue.Name,que.QueueId);
                
             }
             
             if(!String.isEmpty(AgentReportObj.Country__c)){
                      
             if(AgentReportObj.Country__r.Cluster_Id__r.Name==AA_Constants.CLUSTER_AFRICA){
                 
                AgentReportObj.ownerId=queueID.get('CI Manager Africa Queue');
          
             }else if(AgentReportObj.Country__r.Cluster_Id__r.Name==AA_Constants.CLUSTER_EUROPE){
                 
                AgentReportObj.ownerId=queueID.get('CI Manager Europe Queue');
         
             }else if(AgentReportObj.Country__r.Cluster_Id__r.Name==AA_Constants.CLUSTER_LATIN_AMERICA){
                
                AgentReportObj.ownerId=queueID.get('CI Manager Latin America Queue');
             
             }else if(AgentReportObj.Country__r.Cluster_Id__r.Name==AA_Constants.CLUSTER_NAMET_RUB){
                
                AgentReportObj.ownerId=queueID.get('CI Manager NametRub Queue');
             
             }else if(AgentReportObj.Country__r.Cluster_Id__r.Name==AA_Constants.CLUSTER_NORTH_AMERICA){
                
                AgentReportObj.ownerId=queueID.get('CI Manager North America Queue');
         
             }else if(AgentReportObj.Country__r.Cluster_Id__r.Name==AA_Constants.CLUSTER_SOUTH_ASIA){
               
                AgentReportObj.ownerId=queueID.get('CI Manager South Asia Queue');
                
             } else if(AgentReportObj.Country__r.Cluster_Id__r.Name==AA_Constants.CLUSTER_NORTH_ASIA){
                
                AgentReportObj.ownerId=queueID.get('CI Manager North Asia Queue');
                
             } else if(AgentReportObj.Country__r.Cluster_Id__r.Name==AA_Constants.CLUSTER_SEAA){
                
                AgentReportObj.ownerId=queueID.get('CI Manager SEAA Queue');
         
             }else{
                 
                 AgentReportObj.ownerId = queueID.get('CI Manager Default Queue');
                              }         
                 }
                 
              //Assigning approvers based on clusterid   
                 
             if(String.isEmpty(AgentReportObj.Country__c)  && !String.isEmpty(AgentReportObj.ClusterId__c)){
                      
             if(AgentReportObj.ClusterId__r.Name==AA_Constants.CLUSTER_AFRICA){
                 
                AgentReportObj.ownerId=queueID.get('CI Manager Africa Queue');
          
             }else if(AgentReportObj.ClusterId__r.Name==AA_Constants.CLUSTER_EUROPE){
                 
                AgentReportObj.ownerId=queueID.get('CI Manager Europe Queue');
         
             }else if(AgentReportObj.ClusterId__r.Name==AA_Constants.CLUSTER_LATIN_AMERICA){
                
                AgentReportObj.ownerId=queueID.get('CI Manager Latin America Queue');
             
             }else if(AgentReportObj.ClusterId__r.Name==AA_Constants.CLUSTER_NAMET_RUB){
                
                AgentReportObj.ownerId=queueID.get('CI Manager NametRub Queue');
             
             }else if(AgentReportObj.ClusterId__r.Name==AA_Constants.CLUSTER_NORTH_AMERICA){
                
                AgentReportObj.ownerId=queueID.get('CI Manager North America Queue');
         
             }else if(AgentReportObj.ClusterId__r.Name==AA_Constants.CLUSTER_SOUTH_ASIA){
               
                AgentReportObj.ownerId=queueID.get('CI Manager South Asia Queue');
                
             } else if(AgentReportObj.ClusterId__r.Name==AA_Constants.CLUSTER_NORTH_ASIA){
                
                AgentReportObj.ownerId=queueID.get('CI Manager North Asia Queue');
                
             } else if(AgentReportObj.ClusterId__r.Name==AA_Constants.CLUSTER_SEAA){
              

              
                AgentReportObj.ownerId=queueID.get('CI Manager SEAA Queue');
         
             }else{
                 
                 AgentReportObj.ownerId = queueID.get('CI Manager Default Queue');
                              }         
                 }
           
       AgentReportObj.status__c = 'CI Manager Approval Pending';
        if(!validateForm()){
                return null;
         }
       AgentReportObj.Comments__c = AgentReportObjNew.Comments__c;
       Schema.DescribeSObjectResult R = aa_Agent_Report__c.SObjectType.getDescribe();
        Map<String,Schema.RecordTypeInfo> RT = R.getRecordTypeInfosByName();
        Id recTypeId = (RT.get('CI Manger Record type')).getRecordTypeId();
        
       AgentReportObj.RecordTypeId=recTypeId;
       update AgentReportObj;
              
        
      String redirect = AgentReportObj.id;
      String ListView = redirect.subString(0,3);
      PageReference pageRef = new PageReference('/' + ListView );     
      return pageRef;
         }
         
}


    public void OwnerAssginment(){
        
        String reportId=ApexPages.currentPage().getParameters().get('id'); 
        
        if(reportId!=Null){
        aa_Agent_Report__c AgentReportObj = [select Report_Title__c,Retailer__r.Name,name,Category__r.Name,Competitor_Brand__r.Name,Competitor_Name__r.Name,Country__r.Name,status__c ,Approve_Reject__c,Country__c,ownerId,Country__r.Cluster_Id__r.Name, id,ClusterId__c, ClusterId__r.Name from aa_Agent_Report__c where id = :reportId ];
         AgentReportDisplay = new aa_Agent_Report__c();
         AgentReportDisplay = AgentReportObj ;
        if(AgentReportObj.Approve_Reject__c=='Approve' || AgentReportObj.Approve_Reject__c=='Reject' || AgentReportObj.status__c=='Published (Public)' || AgentReportObj.status__c=='Published (Private)' ){
           system.debug('Record already approved or rejected can not reassign');
             
        } else{
           
           List<QueueSobject> queues=[Select q.SobjectType, q.QueueId, q.Id ,q.Queue.Name From QueueSobject q where q.SobjectType ='aa_agent_report__c'];
           Map<string,string> queueID=new Map<string,string>();
           
           for(QueueSobject que : queues)
           {
              queueID.put(que.Queue.Name,que.QueueId);
           }
           
           //If Country is selected
            if(!String.isEmpty(AgentReportObj.Country__c)){
                     
           if(AgentReportObj.Country__r.Cluster_Id__r.Name==AA_Constants.CLUSTER_AFRICA)
           {
            
             AssginedOwner = 'Record will be assigned to CI Manager Africa Queue';
           }else
           if(AgentReportObj.Country__r.Cluster_Id__r.Name==AA_Constants.CLUSTER_EUROPE)
           {
          
           AssginedOwner = 'Record will be assigned to CI Manager Europe Queue';
           }else
           if(AgentReportObj.Country__r.Cluster_Id__r.Name==AA_Constants.CLUSTER_LATIN_AMERICA)
           {
          
           AssginedOwner = 'Record will be assigned to CI Manager Latin America Queue';
           }else
           if(AgentReportObj.Country__r.Cluster_Id__r.Name==AA_Constants.CLUSTER_NAMET_RUB)
           {
          
           AssginedOwner = 'Record will be assigned to CI Manager NametRub Queue';
           }else
           if(AgentReportObj.Country__r.Cluster_Id__r.Name==AA_Constants.CLUSTER_NORTH_AMERICA)
           {
          
           AssginedOwner = 'Record will be assigned to CI Manager North America Queue';
           }else
           if(AgentReportObj.Country__r.Cluster_Id__r.Name==AA_Constants.CLUSTER_SOUTH_ASIA)
           {
          
           AssginedOwner = 'Record will be assigned to CI Manager South Asia Queue';
           }   else
           if(AgentReportObj.Country__r.Cluster_Id__r.Name==AA_Constants.CLUSTER_NORTH_ASIA)
           {
           AssginedOwner = 'Record will be assigned to CI Manager North Asia Queue';
         //  AssginedOwner = 'Record is assgined to CI Manager North America Queue';
           } else
           if(AgentReportObj.Country__r.Cluster_Id__r.Name==AA_Constants.CLUSTER_SEAA)
           {
           AssginedOwner = 'Record will be assigned to CI Manager SEAA Queue';
         //  AssginedOwner = 'Record is assgined to CI Manager North America Queue';
           }  else{
                AssginedOwner = 'Record will be assigned to CI Manager Default Queue';
           
            } 
           }   
           
           //Assigning approvers based on clusterid   
                 
             if(String.isEmpty(AgentReportObj.Country__c)  && !String.isEmpty(AgentReportObj.ClusterId__c)){ 
              if(AgentReportObj.ClusterId__r.Name==AA_Constants.CLUSTER_AFRICA)
           {
            
             AssginedOwner = 'Record will be assigned to CI Manager Africa Queue';
           }else
           if(AgentReportObj.ClusterId__r.Name==AA_Constants.CLUSTER_EUROPE)
           {
          
           AssginedOwner = 'Record will be assigned to CI Manager Europe Queue';
           }else
           if(AgentReportObj.ClusterId__r.Name==AA_Constants.CLUSTER_LATIN_AMERICA)
           {
          
           AssginedOwner = 'Record will be assigned to CI Manager Latin America Queue';
           }else
           if(AgentReportObj.ClusterId__r.Name==AA_Constants.CLUSTER_NAMET_RUB)
           {
          
           AssginedOwner = 'Record will be assigned to CI Manager NametRub Queue';
           }else
           if(AgentReportObj.ClusterId__r.Name==AA_Constants.CLUSTER_NORTH_AMERICA)
           {
          
           AssginedOwner = 'Record will be assigned to CI Manager North America Queue';
           }else
           if(AgentReportObj.ClusterId__r.Name==AA_Constants.CLUSTER_SOUTH_ASIA)
           {
          
           AssginedOwner = 'Record will be assigned to CI Manager South Asia Queue';
           }   else
           if(AgentReportObj.ClusterId__r.Name==AA_Constants.CLUSTER_NORTH_ASIA)
           {
           AssginedOwner = 'Record will be assigned to CI Manager North Asia Queue';
         //  AssginedOwner = 'Record is assgined to CI Manager North America Queue';
           } else
           if(AgentReportObj.ClusterId__r.Name==AA_Constants.CLUSTER_SEAA)
           {
           AssginedOwner = 'Record will be assigned to CI Manager SEAA Queue';
         //  AssginedOwner = 'Record is assgined to CI Manager North America Queue';
           }  else{
                AssginedOwner = 'Record will be assigned to CI Manager Default Queue';
           
            } 
           }   
    
    
    }
        }

}


    public PageReference reportApproved(){
        PageReference  pageRef;
         try{
             String reportId = ApexPages.currentPage().getParameters().get('id'); 
              system.debug('====>'+ reportId);
            
             
             aa_Agent_Report__c AgentReportObj = [select Report_Title__c,recordTypeId,status__c ,Approve_Reject__c,Country__c,ownerId,Country__r.Cluster_Id__r.Name, id,TF_Mention_User__c,TF_Topic_Name__c,CreatedById from aa_Agent_Report__c where id = :reportId ];
            
            system.debug('====>'+ AgentReportObj.Status__c);
             AgentReportObj.Comments__c = AgentReportObjNew.Comments__c;
             AgentReportObj.Approve_Reject__c = 'Approve';
             List<RecordType> recordTypeObj =  [select name,id from RecordType where name = 'Competitor Report'];
             
             if(AgentReportObj.Status__c == 'ETS Approval Pending'){
                AgentReportObj.Status__c = 'Published (Public)';
                AgentReportObj.Approved_By__c=Userinfo.getUserId();
                AgentReportObj.Approved_On__c=system.now();
              //  AA_DatabaseServiceUtil.sendToChatter(Id.valueof(AgentReportObj.id),AgentReportObj.CreatedById, AgentReportObj.Report_Title__c, AgentReportObj.id,AgentReportObj.Country__c,AgentReportObj.TF_Mention_User__c,AgentReportObj.TF_Topic_Name__c);
             }else           
             
             if(AgentReportObj.Status__c == 'CI Manager Approval Pending'){
                AgentReportObj.Status__c = 'Published (Public)';
                AgentReportObj.Approved_By__c=Userinfo.getUserId();
                AgentReportObj.Approved_On__c=system.now();
               //  AA_DatabaseServiceUtil.sendToChatter(Id.valueof(AgentReportObj.id),AgentReportObj.CreatedById, AgentReportObj.Report_Title__c, AgentReportObj.id,AgentReportObj.Country__c,AgentReportObj.TF_Mention_User__c,AgentReportObj.TF_Topic_Name__c);
             }
                          
             if(recordTypeObj.size()>0){
                AgentReportObj.recordTypeId = recordTypeObj[0].id;
             }             
             
             
             update AgentReportObj;
             
             //String redirect = AgentReportObj.id;
             //pageRef =AgentReportObj.id;
             //String ListView = redirect.subString(0,3);
             //pageRef = new PageReference('/' + ListView );
             //pageRef = Page.Agent_App_Report;
             
             String redirect = AgentReportObj.id;
             String ListView = redirect.subString(0,3);
             pageRef = new PageReference('/' + ListView );
             
         }catch(DMLException ex){
            system.debug('=====>'+ ex.getMessage());
            
         }catch(Exception e){
            system.debug('=====>'+ e.getMessage());
            
         }
         return pageRef;
    }
    
    public PageReference reportRejected(){
        PageReference  pageRef;
        try{
            String reportId = ApexPages.currentPage().getParameters().get('id'); 
             
             
             aa_Agent_Report__c AgentReportObj = [select Report_Title__c,recordTypeId,status__c ,Approve_Reject__c,Country__c,ownerId,Country__r.Cluster_Id__r.Name, id from aa_Agent_Report__c where id = :reportId ];
              if(!validateForm()){
                return null;
             }
             AgentReportObj.Comments__c = AgentReportObjNew.Comments__c;
             if(AgentReportObj.Status__c == 'ETS Approval Pending'){
                AgentReportObj.Status__c = 'Rejected';
                AgentReportObj.RejectedBy__c=Userinfo.getUserId();
                AgentReportObj.Rejected_On__c=system.now();
             }
             
              if(AgentReportObj.Status__c == 'CI Manager Approval Pending'){
                AgentReportObj.Status__c = 'Rejected';
                AgentReportObj.RejectedBy__c=Userinfo.getUserId();
                AgentReportObj.Rejected_On__c=system.now();
             }
             AgentReportObj.Approve_Reject__c = 'Reject';
             
             update AgentReportObj;
          
            String redirect = AgentReportObj.id;
            // String ListView = redirect.subString(0,3);
             pageRef = new PageReference('/' + redirect );
            // pageRef = Page.Agent_App_Report;
        }catch(DMLException ex){
            system.debug('=====>'+ ex.getMessage());
            
         }catch(Exception e){
            system.debug('=====>'+ e.getMessage());
            
         }
         return pageRef;
    }
    
    
    public void reportValues(){
         String reportId=ApexPages.currentPage().getParameters().get('id'); 
          
         
         AgentReportDisplay = [Select Report_Title__c,Id,Agent_App_Unilever_Brand__r.Name, Agent_App_Unilever_Brand__c,
                                            Town__c,Retailer__c, Retailer__r.Name,  
                                            RecordType.Name, Name, 
                                            CreatedDate, 
                                            CreatedBy.SmallPhotoUrl, 
                                            CreatedBy.Name, 
                                            Comments__c,
                                            Country__c,
                                            Country__r.Name, 
                                            Country__r.Cluster_Id__r.name, 
                                            Competitor_Name__c,
                                            Competitor_Name__r.Name,  
                                            Competitor_Brand__c,
                                            Competitor_Brand__r.Name,  
                                            Category__c,
                                            Category__r.Name from aa_Agent_Report__c where id = :reportId ];
    
    }
    
    public PageReference cancel(){
        
        String reportId = ApexPages.currentPage().getParameters().get('id');
        PageReference MyNewPage = new PageReference('/' + reportId);
        return MyNewPage;
    }
    
     public Boolean validateForm(){
         Boolean validate = true;
         if(AgentReportObjNew.Comments__c== null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Enter the comments'));
            validate = false;
         }
        return validate;
     
     }
}