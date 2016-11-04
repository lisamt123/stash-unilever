public with sharing class UL_FetchingLevels {
    ApexPages.StandardController controller;
    public String defSoldTo{set;get;}
    public String redirectUrl{set;get;}
    private Account accountRecord{set;get;}
    public List<SelectOption> Items{set;get;}
    public String defaultSold{set;get;}
    public Boolean displayPopup {get;set;}
    public Boolean displayPage{get;set;}  
      
    public void showPopup(){        
        displayPopup = true;    
    }    
    public void closePopup() {
        displayPopup = false;        
    }
    
    public PageReference redirectPopup(){
        displayPopup = false;
        PageReference p=new Pagereference('/001');
        p.setRedirect(true);
        return p;      
    }
    public UL_FetchingLevels(ApexPages.StandardController controller){
            this.controller = controller;
            Account accRecordId = (Account)controller.getRecord();
            Items = new List<SelectOption>();
            accountRecord = [select id,name,UL_Customer_Hierarchy_Level__c,UL_Planning_Level__c from Account where id=:accRecordId.id];
            String level = accountRecord.UL_Customer_Hierarchy_Level__c;
            level = level.substringAfter(' ');      
            Integer levelNumber = Integer.valueOf(level);  
            displayPage =  accountRecord.UL_Planning_Level__c;          
            dynamicQuery(levelNumber);
                  
          }
    
    public PageReference Save(){
            accountRecord.UL_DefaultSoldTo__c = defSoldTo;
            Database.update(accountRecord);
            redirectUrl = Controller.view().getUrl();  
            System.debug('--url---'+redirectUrl );           
            return null;
    }
    
    public void dynamicQuery(Integer levelNumber){
        String level = 'Level 8';
        String query ='select id,name,UL_Level_8__c,UL_Level_8__r.name ,UL_Customer_Hierarchy_Level__c  from  Account where UL_Customer_Hierarchy_Level__c=\''+level+'\' AND  ';
               query +='UL_Level_'+levelNumber+'__c =\''+accountRecord.id+'\'';                      
               List<Account>  allLevelRecords= Database.query(query);
               for(Account acc:allLevelRecords){                 
                    Items.add(new SelectOption(acc.name,acc.name));                          
            }   
    }
}