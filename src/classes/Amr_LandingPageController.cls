public with sharing class Amr_LandingPageController {
    
    public String UserId{get;set;}
    public List<PermissionSetAssignment> PermissionSetAssignmentList{get;set;}
    public boolean flag{get;set;}
    public boolean display{get;set;}
    public boolean displayRap{get;set;}
    
    public Amr_LandingPageController(){
        
    }
    
    
    public PageReference Redirect(){
    
         UserId = userinfo.getuserid();  
       // PermissionSetAssignmentList = [select id,Assignee.Name,Assignee.id from PermissionSetAssignment where PermissionSet.Name = :Label.Amr_CAP order by Assignee.name];
        PermissionSetAssignmentList = [select id,Assignee.Name,Assignee.id,PermissionSet.Name from PermissionSetAssignment where (PermissionSet.Name = :Label.Amr_CAP OR PermissionSet.Name = 'RAP' OR PermissionSet.Name = 'AdManager') order by Assignee.name];
        system.debug('------>PermissionSetAssignmentList=='+PermissionSetAssignmentList );
        
        flag = false;
        display = false;
        displayRap = false;
        
        for(PermissionSetAssignment permissionObject:PermissionSetAssignmentList ){
               system.debug('=======>'+permissionObject.PermissionSet.Name);
               if(permissionObject.PermissionSet.Name == Label.Amr_CAP && permissionObject.Assignee.id == UserId ){
                   system.debug('inside cap==>');
                   PageReference pageRef = new PageReference('/apex/Am_CAPJobportfolio');
                   pageRef.setRedirect(true);
                   return pageRef;
                  
                   
               } 
               if(permissionObject.PermissionSet.Name == 'RAP' && permissionObject.Assignee.id == UserId ){
                  system.debug('inside RAP==>');
                   PageReference pageRef = new PageReference('/apex/Am_JobPortfolio');
                    pageRef.setRedirect(true);
                   return pageRef;
                  
                   
               }
               
               if(permissionObject.PermissionSet.Name == 'AdManager' && permissionObject.Assignee.id == UserId ){
                   system.debug('inside AdManager==>');
                   PageReference pageRef = new PageReference('/apex/Amr_AdManager');
                   pageRef.setRedirect(true);
                   return pageRef;
                       
               }
        
        }
        
        PageReference pageRef = new PageReference('/apex/Am_JobPortfolio');
        pageRef.setRedirect(true);
        return pageRef;
    }
}