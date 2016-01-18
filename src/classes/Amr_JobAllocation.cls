Public with sharing Class Amr_JobAllocation{
   
    public string selectedOptionValue {get;set;}
    public List<selectOption> lstUser {get;set;}
    public Amr_JobAllocation(){
        
        
        lstUser  = getlstUser();
        
    }
    
     public List<selectOption> getlstUser() 
      {
          List<selectOption> options = new List<selectOption>(); 
          
          options.add(new selectOption('', '- None -')); 
         
          List<User> lstUser  = [SELECT id, name
             FROM User Where Profile.Name='System Administrator'  ];
          for(User objUser : lstUser){
           
              options.add(new selectOption(objUser.name, objUser.name));
          
          }
          return options;
      }
    
   public pageReference allocateJob(){
    
        Amr_Job_Details__c objJobDetail  = [SELECT id, name 
             FROM Amr_Job_Details__c
             WHERE id =: ApexPages.currentPage().getParameters().get('Id')];
          List<User> lstUser = new  List<User>();   
          lstUser  = [SELECT id, name
             FROM User Where Name =: selectedOptionValue];
              system.debug('***selectedOptionValue*****'+selectedOptionValue);
             system.debug('***lstUser  *****'+lstUser  );
          if(lstUser.isEmpty()){
                                  
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Invalid Input.');
            ApexPages.addMessage(errorMsg );  
            return null;    
          }
             
         objJobDetail.ownerId =  lstUser[0].id;
         update objJobDetail;   
         return null;
    
    }



}