/**********************************************************************
Name: SAM_RequestAgeing ()
Copyright © 2016 Salesforce
======================================================
======================================================
Purpose: This Class is used to perform claculation of Request aging
-------
======================================================
======================================================

-------
VERSION     AUTHOR                 DATE            DETAIL Description
1.0         Mindtree             19/07/2016     INITIAL DEVELOPMENT CSR:
***********************************************************************/
public with sharing class SAM_RequestAgeing {

    /*******************************************************************
    Purpose: This method is used calculate Age of the request
    Parameters: List<SAM_Request__c>
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static void RequestAgeUpdateScheduler(List<SAM_Request__c> requestList){
  
        system.debug('requestList>>'+requestList);
        List <SAM_Request__c>newRequestList = new List<SAM_Request__c>();
        boolean requestorFlag=false;
        boolean samAdminFlag=false;
        boolean samTeamFlag=false;  
        Double ticketAge = 0;
     
        Map<String,String>permissionMap = new Map<String,String>();
        //Dinesh 26/7 - replace below hardcoded values with constants
        for(PermissionSetAssignment permObj:[SELECT Id,PermissionSet.Name,AssigneeId FROM PermissionSetAssignment where PermissionSet.Name IN ('SAM_Requestor','SAM_Admin','SAM_Team')]){
            permissionMap.put(permObj.AssigneeId,permObj.PermissionSet.Name);
        }
     
        system.debug('permissionMap>>'+permissionMap);
 
        for(SAM_Request__c req:requestList){
     
        //aging calculation for project non project type request
        if(req.pkl_Status__c != 'Close' && req.pkl_Status__c != null){
        
            if(req.RecordType.DeveloperName !=null){
                if(req.RecordType.DeveloperName == SAM_Constants.SAM_RW_PROJECT_REQUEST || req.RecordType.DeveloperName == SAM_Constants.SAM_RW_NON_PROJECT_REQUEST){
                     if(req.pkl_Status__c == SAM_Constants.OPEN || req.pkl_Status__c == SAM_Constants.INPROGRESS || req.pkl_Status__c == SAM_Constants.QUOTE_REJECTED || req.pkl_Status__c == SAM_Constants.INFORMATION_PROVIDED || (req.pkl_Status__c== SAM_Constants.DRAFT_QUOTE_PROVIDED && req.rus_Pending_with_Project__c == 0  && req.rus_Pending_with_SAM_records__c > 0) ){
                         system.debug('Inside status!!!'+req.pkl_Status__c+'id>>>'+req.Id );
                         if(req.Ticket_Age__c !=null){
                             ticketAge =0;
                             ticketAge = req.Ticket_Age__c;
                             ticketAge= ticketAge + 1;
                             req.Ticket_Age__c = ticketAge; 
                             //req.Ticket_Age__c = req.Ticket_Age__c+1;
                             newRequestList.add(req);
                             system.debug('req.Ticket_Age__c >>'+req.Ticket_Age__c+'newRequestList>>>>'+newRequestList);
                     
                         }
                     
                     }
                 
          //aging calculation for query type request
          
                }else if(req.RecordType.DeveloperName == SAM_Constants.SAM_RW_QUERY_REQUEST){
             
                    requestorFlag =false;
                    samAdminFlag=false;
                    samTeamFlag=false;  
                    
                    system.debug('permissionMap.get(req.createdById)!!!!'+permissionMap.get(req.createdById));
                
                    if(permissionMap.get(req.createdById) == SAM_Constants.SAM_REQUESTOR){
                        requestorFlag = true;
                    }else if(permissionMap.get(req.createdById) == SAM_Constants.SAM_TEAM){
                        samTeamFlag = true;
                    }else if(permissionMap.get(req.createdById) == SAM_Constants.SAM_ADMIN){
                        samAdminFlag = true;
                    }
                
                    system.debug('requestorFlag>>'+requestorFlag+'samAdminFlag>>'+samAdminFlag+'samTeamFlag>>'+samTeamFlag);
                
                
                    if(requestorFlag == true && samAdminFlag == false && samTeamFlag == false){
                        if(req.pkl_Status__c == SAM_Constants.OPEN || req.pkl_Status__c == SAM_Constants.INPROGRESS ){
                             if(req.Ticket_Age__c !=null){
                                 ticketAge =0;
                                 ticketAge = req.Ticket_Age__c;
                                 ticketAge= ticketAge + 1;
                                 req.Ticket_Age__c = ticketAge; 
                             //   req.Ticket_Age__c = req.Ticket_Age__c+1;
                             
                                newRequestList.add(req);
                                system.debug('query emp ticket age >>'+req.Ticket_Age__c+'newRequestList>>>>'+newRequestList);
                            }
                        }
                  
                    } else{
                        if(req.date_Query_End_Date__c !=null && req.date_Query_Start_Date__c !=null){
                            if(req.Ticket_Age__c !=null){
                                ticketAge =0;
                                ticketAge  = req.date_Query_Start_Date__c.daysBetween(req.date_Query_End_Date__c);
                                req.Ticket_Age__c = ticketAge; 
                                newRequestList.add(req);
                                system.debug('query sam  ticket age >>'+req.Ticket_Age__c+'newRequestList>>>>'+newRequestList);
                            }
                        }
                      }
             
                 }
                } 
           } 
         }
         
         if(newRequestList.size()>0){
             update newRequestList;
             system.debug('newRequestList>>'+newRequestList);
         }
 
    }
}