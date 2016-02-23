public with sharing class Amr_Sharecontroler
{
    public list<User> userStr = new list<User>();
    public list<string> leftselected{get;set;}
    public list<selectOption> selectoptions {get;set;}
    
    public Amr_Sharecontroler()
    {
        leftselected = new list<string>();
        selectoptions = new list<selectOption>();
        
        userStr = [Select Id ,name,isActive,ProfileId, Profile.Name From User where isActive = True and profile.name='RAP'order by name];
        For(User u:userStr)
        {
            selectoptions.add(new SelectOption(u.name,u.name));
        }       
        
    }
    public pagereference recordShare()
    {
       List<User> user=[Select Id,name,isActive,ProfileId, Profile.Name From User where isActive = True and profile.name='RAP' and Name IN :leftselected ];
       
      
       ApexPages.addMessage(new ApexPages.Message( ApexPages.Severity.INFO,'Notification has been successfully completed'));
    
        // Final List To Share
       List<Amr_Job_Details__share> jobShrList  = new List<Amr_Job_Details__share> ();
       
          Amr_Job_Details__share jobShr;
          
          for (User eachSelectedUser : [Select Id,name,isActive,ProfileId, Profile.Name From User where isActive = True and profile.name='RAP' and Name IN :leftselected  ])
          {
                system.debug('Value'+eachSelectedUser);      
                jobShr  = new Amr_Job_Details__share ();
                jobShr.ParentId = 'a8f18000000CaXZ';
                jobShr.UserOrGroupId = eachSelectedUser.Id;
                jobShr.AccessLevel = 'Read';
                jobShr.RowCause = Schema.Amr_Job_Details__share.RowCause.Manual; 
                
                jobShrList.add(jobShr);
          }
          
         
          if(jobShrList.size() > 0)
                Database.SaveResult[] sr = Database.insert(jobShrList,False);
      
         
           
            PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
            pageRef.setRedirect(true);
            return pageRef;
    }

}