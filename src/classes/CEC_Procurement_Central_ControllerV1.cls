public class CEC_Procurement_Central_ControllerV1{
    final string STR_CONST_ProCentralAdmin = 'VPM_Procurement';
    final Integer STR_CONST_TotalNosOfApprovalPossilbe = 10;


    public boolean buttonDisp {get;set;}
    public boolean ClickGo {get;set;}
    public boolean ClickGoAssign {get;set;}
    public boolean ClickGoRemove {get;set;}
    public boolean showTable{get;set;}
    public Boolean ClickGoTemp {get;set;}
    public VPM_CommodityApprover__c com {get;set;}
    public User us{get; set;}
    public List<CommApproverList> commApprover {get;set;}
    public string country{get;set;}
    public boolean MainScreen {get;set;}
    public string MDMVendor {get;set;}
    public string newUser {get;set;}
    public string oldUser {get;set;}
    Public Date TillDate{get;set;}
    
        public class CommApproverList{
        
        public boolean checkFlag {get;set;}
        public boolean setFlag {get;set;}
        public VPM_CommodityApprover__c comApp {get;set;}
    
    }


           // Constructor
        public CEC_Procurement_Central_ControllerV1()
             {
                 com = new VPM_CommodityApprover__c();
                 us= new User();
                 //commApprover = new List<CommApproverList>();
                 
                 MainScreen = true;
                 buttonDisp = false;
                 //ClickGo  = false;
             }

     public PageReference ChangeApprover()
     {
        
        oldUser = com.VPM_Approver1__c;
        newUser = com.VPM_Approver2__c;
        country= com.VPM_Country__c;
        TillDate=com.VPM_TempApproverDate1__c;
        if(MDMVendor == 'Replace'){
          try{
            // Steps for replace approval
            //throw error message if oldUser and newUser is null
            if((oldUser==null && newuser==null)|| (oldUser==null && newuser!=null) || (oldUser!=null && newuser==null)){
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,''+'Please select the approvers to be replaced'));
             }else{
                      // Step no 1) Replace old user with new user in commodity approval.
                      replaceApproverInCommodity(oldUser, newUser, null);
                      // Step no 2) Add new permission to newUser and remove permission from oldUser.
                      removeProcurmentPermission(oldUser, newUser);
                                
                   }
               }catch(Exception e){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'YOUR MESSAGE HERE'));
               }  
         }
                 
                 if(MDMVendor == 'Temporary')
                   {
                    // Steps for replace approval
                        //throw error message if oldUser and newUser is null
                        if(TillDate==null)
                        {
                            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,''+'Please select the Temporary Replace Date'));
                        }
                        if((oldUser==null && newuser==null)|| (oldUser==null && newuser!=null) || (oldUser!=null && newuser==null)){
                        
                            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,''+'Please select the approvers to be replaced'));
                        }else{
                            
                            // Step no 1) Replace old user with new user in commodity approval.
                            replaceApproverInCommodity(oldUser, newUser, null);
                            system.debug('Temp Completed');
                            // Step no 2) Add new permission to newUser if doesnt have.
                            AddProcurementPermission(newUser);
                            
                          
                        }
                        
                   }
        
                   if(MDMVendor == 'Assign')
                   {
                       
                    // Steps for add new user
                        // Step no 1) Pass null to old user, Add new approval in commodity
                            assignRemoveCommodity(null, newUser, country);
                        // Step no 2) Add new permission to newUser.
                            removeProcurmentPermission(null, newUser);
                   }
        
        
                   if(MDMVendor == 'Remove')
                   {
                    // Steps for Remove User
                        // Step no 1) Pass null to new user.
                            assignRemoveCommodity(oldUser, null, country);
                        // Step no 2) Add new permission to newUser.
                            removeProcurmentPermission(oldUser, null);
                            
                   }
                   com.VPM_Approver2__c=null;
                   com.VPM_Approver1__c=null;
                   com.VPM_Country__c=null;
                   com.VPM_TempApproverDate1__c=null;
                   return null;
     }

         public PageReference GoBack() {
           MDMVendor = '';
           buttonDisp = false;
           ClickGoAssign = false;
           ClickGoRemove = false;
           ClickGoTemp=False;
           ClickGo = false;
           MainScreen = true;
           com.VPM_Approver2__c=null;
           com.VPM_Approver1__c=null;
           com.VPM_Country__c=null;
           com.VPM_TempApproverDate1__c=null;
           return null;
        }
        
       public PageReference goAssign() {
           
           try{
            system.debug('@@ inside go');
           if(MDMVendor == 'Assign')
              {
                ClickGoAssign = true;
                buttonDisp = true;
                 showTable = true;
                if(com.VPM_Approver2__c==null)
                 {
                     Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,''+'Please select the approver'));
                     showTable=false;
                     buttonDisp=false;
                 }   
                else if(com.VPM_Country__c ==null)   
                {  Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,''+'Please select the country'));
                   showTable=false;
                   buttonDisp=false;
                }
                 else{
                     AddApproverInCommodity(null,com.VPM_Approver2__c, com.VPM_Country__c);
                     this.commApprover = commApprover;
                 }  
                
                //return null;
                
              }else if(MDMVendor == 'Remove')
              {
                  ClickGoRemove = true;
                 system.debug('@@ com.VPM_Approver1__c' + com.VPM_Approver1__c);
                  buttonDisp = true;
                  showTable = true;
                  if(com.VPM_Approver1__c==null)
                 {   Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,''+'Please select the approver'));
                    showTable=false;
                    buttonDisp=false;
                    
                    
                 }
                  else
                  {
                      system.debug('@@ debug' +com.VPM_Approver1__c);
                      AddApproverInCommodity(com.VPM_Approver1__c,null, com.VPM_Country__c);
                      this.commApprover = commApprover;
                      system.debug('@@ inside remove');
                  }
                  
              
              }
           }catch(Exception ex){
              
                  system.debug('Error' +ex.getMessage());
                  if(ex.getMessage().contains('Multiple items found'))
                     Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,''+'Multiple items found. Select from drop-down or click icon to refine search.')); 
           }
           
            
                return null;
            }
        public PageReference Go() {
        
          buttonDisp = true;
          MainScreen = false;
          ClickGo = false;      
          ClickGoAssign = false;
          if( MDMVendor == 'Replace')
          {       
            ClickGo = true;
          }
          else if(MDMVendor == 'Assign')
          {
            ClickGoAssign = true;
            showTable = false;
            buttonDisp =false;
            
          }
          else if(MDMVendor == 'Remove')
          {
            ClickGoRemove = true;
            showTable = false;
            buttonDisp =false;
            
          }
            else if (MDMVendor == 'Temporary' )
            {
                ClickGoTemp=true;
            }
          return null;
        }


    public void AddProcurementPermission(string newuser)
    {
        PermissionSet pr =[SELECT  id FROM PermissionSet WHERE name =: STR_CONST_ProCentralAdmin LIMIT 1];
        if(newUser != null)
        {
             list<PermissionSetAssignment> checkProcPermission = [SELECT Assignee.Name, PermissionSet.Id FROM PermissionSetAssignment where Assignee.id=:newUser and PermissionSetId=:pr.id limit 1];      
             if(checkProcPermission.size() == 0)
             {    
                 // Add permission set
                PermissionSetAssignment newProcPermission = new PermissionSetAssignment(AssigneeId=newUser,PermissionSetId=pr.id);
                insert newProcPermission;
                
             }
        }
        
    }

    /* Created By : Vaishali Nagar
       Created on : 09 Oct 2016
       Description: Remove permission from oldUser and add permission to newUser.
    */
    public void removeProcurmentPermission(String oldUser, String newUser)
    {
        PermissionSet pr =[SELECT  id FROM PermissionSet WHERE name =: STR_CONST_ProCentralAdmin LIMIT 1];
        if(oldUser != null)
        {
        
             list<PermissionSetAssignment> perSetAss = [Select id , AssigneeId from PermissionSetAssignment where AssigneeId=:oldUser AND PermissionSetId=:pr.id];
            delete perSetAss;
        }
        if(newUser != null)
        {
            list<PermissionSetAssignment> checkProcPermission = [SELECT Assignee.Name, PermissionSet.Id FROM PermissionSetAssignment where Assignee.id=:newUser and PermissionSetId=:pr.id limit 1];      
           if(checkProcPermission.size() == 0)
            {    
              // Add permission set
                PermissionSetAssignment newProcPermission = new PermissionSetAssignment(AssigneeId=newUser,PermissionSetId=pr.id);
                insert newProcPermission;
                
            }
            else{
            
                //Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,''+'The Approver selected already has procurement permission'));
            }
        }
    } 

    /* Created By :Vaishali Nagar
       Created on : 09 Oct 2016
       Description: Replace or Add oldUser commodity approval name with newUser.
    */
    public void replaceApproverInCommodity(String oldUser, String newUser, String country)
    {
        List<VPM_CommodityApprover__c> commAppList = new List<VPM_CommodityApprover__c>();
        if(oldUser != null)
            commAppList = [select id, VPM_Approver1__c , VPM_Approver2__c,VPM_Approver3__c,VPM_Approver4__c,VPM_Approver5__c,
                                                   VPM_Approver6__c,VPM_Approver7__c,VPM_ConfiguredApprovers__c,VPM_Approver8__c,VPM_Approver9__c,VPM_Approver10__c from VPM_CommodityApprover__c 
                                                   where VPM_Approver1__c =: oldUser or VPM_Approver2__c =: oldUser or VPM_Approver3__c =: oldUser or VPM_Approver4__c =: oldUser
                                                    or VPM_Approver5__c =: oldUser or VPM_Approver6__c =: oldUser or VPM_Approver7__c =: oldUser or VPM_Approver8__c =: oldUser
                                                    or VPM_Approver9__c =: oldUser or VPM_Approver10__c =: oldUser limit 50000];
         
         
         if(commAppList.isEmpty() && oldUser != null)
            {
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,''+'The Old Approver selected is no longer an approver. Please select another approver'));
                
            }
            else
            {
                  
                            for(VPM_CommodityApprover__c commAPP : commAppList)
                            {                         
                                String userToReplace = oldUser;
                                for(Integer approversCount =1; approversCount <= commAPP.VPM_ConfiguredApprovers__c; approversCount ++)
                                {                               
                                    if(newUser == null) // for removing user from approvals
                                    {
                                        if(commAPP.get('VPM_Approver'+approversCount+'__c') == userToReplace && approversCount < 10)
                                        {
                                        integer nextApprovor = approversCount+1; 
                                         commAPP.put('VPM_Approver'+approversCount+'__c', commAPP.get('VPM_Approver'+nextApprovor+'__c')) ;
                                           userToReplace =  string.valueOf(commAPP.get('VPM_Approver'+nextApprovor+'__c'));
                                           if(nextApprovor == 10)
                                             commAPP.put('VPM_Approver'+approversCount+'__c', null) ;
                                        }
                                        Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,''+'Approver successfully removed'));
                                    }
                                    else
                                    {
                                        //replace old approver with new approver
                                       
                                        if (MDMVendor == 'Temporary' )
                                        {
                                            if(commAPP.get('VPM_Approver'+approversCount+'__c') == oldUser)
                                            {
                                                    commAPP.put('VPM_Approver'+approversCount+'__c', newUser) ;    
                                                    commAPP.put('VPM_TempApprover'+approversCount+'__c', oldUser) ;
                                                    commAPP.put('VPM_TempApproverDate'+approversCount+'__c', TillDate) ;
                                                
                                            }       
                                            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,''+'Selected Commodity Approvers has been Temporary replaced successfully'));
                                        }
                                        else 
                                        {
                                            if(commAPP.get('VPM_Approver'+approversCount+'__c') == oldUser)
                                            {
                                                    commAPP.put('VPM_Approver'+approversCount+'__c', newUser) ;
                                            }       
                                            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,''+'Approver successfully replaced'));
                                        }
                                    }
                                    
                                }
                            }
                            updateCommApprover(json.serialize(commAppList));
                        
                     
                     //Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,''+'Approver successfully replaced'));
                            
            }
        }
          @future
    public static void updateCommApprover(String seriliazeLstCommoApprover){
           List<VPM_CommodityApprover__c> commoditApprovers =     (List<VPM_CommodityApprover__c>)Json.Deserialize(seriliazeLstCommoApprover, List<VPM_CommodityApprover__c>.class);
        System.debug('@@@@@@@ commoditApprovers -------- ' + commoditApprovers);
            update commoditApprovers ;
    }
    

    /* Created By :Vaishali Nagar
       Created on : 09 Oct 2016
       Description: Set value for dataTable.
    */
    
   
    
    public void AddApproverInCommodity(string oldUser,String newUser,String Country){
        
         List<VPM_CommodityApprover__c> commAppList =new List<VPM_CommodityApprover__c>();
         if(oldUser==null)
         {
             commAppList = [select id, VPM_ConfiguredApprovers__c, VPM_Approver1__c , VPM_Approver2__c,VPM_Approver3__c,VPM_Approver4__c,VPM_Approver5__c,
                                                   VPM_Approver6__c,VPM_Approver7__c,VPM_Approver8__c,VPM_Approver9__c,VPM_Approver10__c,VPM_CommodityClass__c from VPM_CommodityApprover__c 
                                                   where VPM_Country__c =: country and (VPM_Approver1__c !=: newUser and VPM_Approver2__c !=: newUser and VPM_Approver3__c !=: newUser and VPM_Approver4__c !=: newUser
                                                    and VPM_Approver5__c !=: newUser and VPM_Approver6__c !=: newUser and VPM_Approver7__c !=: newUser and VPM_Approver8__c !=: newUser
                                                    and VPM_Approver9__c !=: newUser and VPM_Approver10__c !=: newUser)limit 50000];
                                                   
         }else
         {
            commAppList = [select id, VPM_Approver1__c , VPM_Approver2__c,VPM_Approver3__c,VPM_Approver4__c,VPM_Approver5__c,VPM_CommodityClass__c,
                                                   VPM_Approver6__c,VPM_Approver7__c,VPM_ConfiguredApprovers__c,VPM_Approver8__c,VPM_Approver9__c,VPM_Approver10__c from VPM_CommodityApprover__c 
                                                   where VPM_Approver1__c =: oldUser or VPM_Approver2__c =: oldUser or VPM_Approver3__c =: oldUser or VPM_Approver4__c =: oldUser
                                                    or VPM_Approver5__c =: oldUser or VPM_Approver6__c =: oldUser or VPM_Approver7__c =: oldUser or VPM_Approver8__c =: oldUser
                                                    or VPM_Approver9__c =: oldUser or VPM_Approver10__c =: oldUser limit 50000];
        
        
         }
         
        if(commAppList.isEmpty())
        {
             if(oldUser==null)
             Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,''+'No Commodities found for the selected country'));
             else
                   Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,''+'No Commodities found for the selected approver'));
                   
            showTable = false;
            buttonDisp =false;
        
        }else{
        commApprover = new List<CommApproverList>();
           
            for(VPM_CommodityApprover__c commAPP : commAppList){
                 CommApproverList com= new CommApproverList();
                
                
                if(olduser==null)
                {
                     if(commAPP.VPM_ConfiguredApprovers__c <10)
                    {
                                                  
                           com.checkFlag=false;
                           com.comApp =commAPP;
                           commApprover.add(com);
                    }else
                    {
                           com.checkFlag=true;
                           com.comApp =commAPP;
                           commApprover.add(com);
                    } 
               }else
               {
                   
                                                  
                           com.checkFlag=false;
                           com.comApp =commAPP;
                           commApprover.add(com);
                   
                   system.debug('@@ inside remove1');
               }
           }
        }
        
       
    }
    
    public pagereference assignRemoveCommodity(string oldUser,string newUser,string Country){
   
                           List<VPM_CommodityApprover__c> commodity = new List<VPM_CommodityApprover__c>();
                            
                                CommApproverList com= new CommApproverList();                             
                                system.debug('@@ commodityapproverlist' + commApprover + commApprover.size());
                                
                           
                                   system.debug('Click Change');
                                    boolean isSelected = false;
                                   for(CommApproverList comp : commApprover){
                                         
                                        if(oldUser==null){
                                           
                                            if(comp.setFlag==true){
                                                
                                                
                                                if(comp.comApp.VPM_Approver1__c == newUser || comp.comApp.VPM_Approver2__c == newUser || comp.comApp.VPM_Approver3__c == newUser || comp.comApp.VPM_Approver4__c == newUser|| comp.comApp.VPM_Approver5__c == newUser|| comp.comApp.VPM_Approver6__c == newUser|| comp.comApp.VPM_Approver7__c == newUser|| comp.comApp.VPM_Approver8__c == newUser|| comp.comApp.VPM_Approver9__c == newUser|| comp.comApp.VPM_Approver10__c == newUser){
                                                
                                                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,''+'Already added as Commodity approver for' + comp.comApp.VPM_CommodityClass__c));
                                                    comp.setFlag=false;
                                                    return null;
                                               }else{
                                                    system.debug('Track'+ comp);
                                                    isSelected = true;
                                                    integer approvercount=integer.valueOf(comp.comApp.VPM_ConfiguredApprovers__c)+1 ;
                                                    
                                                            comp.comApp.put('VPM_Approver'+approvercount +'__c',newUser);
                                                            commodity.add(comp.comApp);
                                                            system.debug('Assigned user' + commodity );
                                                            comp.setFlag=false;
                                                            
                                                   }         
                                                
                                            }
                                        }else{
                                        
                                         String userToReplace = oldUser;
                                        for(Integer approversCount =1; approversCount <= comp.comApp.VPM_ConfiguredApprovers__c; approversCount ++)
                                        {                               
                                            if(comp.setFlag==true && newUser==null) // for removing user from approvals
                                            {    
                                                isSelected = true;
                                                if(comp.comApp.get('VPM_Approver'+approversCount+'__c') == userToReplace && approversCount < 10)
                                                {
                                                integer nextApprovor = approversCount+1; 
                                                 comp.comApp.put('VPM_Approver'+approversCount+'__c', comp.comApp.get('VPM_Approver'+nextApprovor+'__c')) ;
                                                   userToReplace =  string.valueOf(comp.comApp.get('VPM_Approver'+nextApprovor+'__c'));
                                                   if(nextApprovor == 10)
                                                     comp.comApp.put('VPM_Approver'+approversCount+'__c', null) ;
                                                     
                                                }
                                                //Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,''+'Approver successfully removed'));
                                            }
                                            
                                        
                                        }
                                        comp.setFlag=false;
                                        commodity.add(comp.comApp);
                                        system.debug('@@ commodity' +commodity);
                                      }
                                            
                                 }
                                    
                                    
                                     if(!isSelected ){
                                                
                                                if(oldUser==null)
                                                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,''+'No records selected.Please try again by selecting the approver and country'));
                                                else
                                                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,''+'No records selected.Please try again by selecting the approver '));
                                                
                                                commApprover.clear();
                                                showTable=false;
                                                buttonDisp=false;
                                                return null;
                                     }
                                     
                                         updateCommApprover(json.serialize(commodity));
                                         
                                         commApprover.clear();
                                         //commodity.clear();
                                         system.debug('@@ commmApprover' + commApprover);
                                         showTable=false;
                                         buttonDisp=false;
                                        if(oldUser==null)
                                            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,''+'Added as commodity approver'));
                                        else
                                            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,''+'Removed as commodity approver'));
                                         //GoBack();
                                   
                                         
                                   
                                
                           
                            return null;
    }
    
   }