public with sharing class UL_DefaultSoldTOCustomersController{
    public UL_Planning_Level__c relatedRecord{private set;get;}
    public String defaultsoldto{set;get;}
    public list<SelectOption> defultsoldtocustomers{set;get;}
    public String redirectUrl{set;get;}
    public Boolean showSaveButton{set;get;}
    public String buttonLab{set;get;} 
    public static final Boolean getAllChildLevel = true ;
    
    
    private ApexPages.StandardController ctr;
    
    
    public UL_DefaultSoldTOCustomersController(ApexPages.StandardController controller) {
       this.relatedRecord = (UL_Planning_Level__c ) controller.getRecord();  
          
          //Assign default start & end date. Temporary solution to read defult field value. 
          this.relatedRecord.UL_Planning_Level_End_Date__c = Date.newInstance(2099, 12, 31);
          this.relatedRecord.UL_Planning_Level_Start_Date__c = Date.Today();
          this.ctr = controller;   
          showSaveButton = true ; 
          buttonLab = 'Cancel' ; 
    }
    
        
    public void loadDefaultSoldCustomers(){
        defultsoldtocustomers = new list<SelectOption>();
        if(relatedRecord.UL_Planning_Level_Start_Date__c != null && relatedRecord.UL_Planning_Level_End_Date__c!= null){
            Account currPLCustRec = [SELECT Id, Name,UL_Customer_Hierarchy_Level__c From Account WHERE Id =: relatedRecord.UL_Customer__c] ;
            String relAccLev = currPLCustRec.UL_Customer_Hierarchy_Level__c ;            
            if(relAccLev.equalsIgnoreCase(UL_Utility.LEVEL8)){
                defultsoldtocustomers.add(new SelectOption(relatedRecord.UL_Customer__c, currPLCustRec .Name));
            }
            
         List<Account> accRecords = UL_CustomerUtility.getCustomerTradeOrgHierarchy(relatedRecord.UL_Customer__c, UL_Utility.LEVEL8,relatedRecord.UL_Planning_Level_Start_Date__c,relatedRecord.UL_Planning_Level_End_Date__c,false);
          if(accRecords != null){
           for(Account acc:accRecords){
               defultsoldtocustomers.add(new SelectOption(acc.id,acc.name));
           }
          }
        }
    }
    
    
    public void pageInit() {
        Id  currCustId = relatedRecord.UL_Customer__c ;
        List<Account> custLevLst = new List<Account>() ;
        
        String customerLevel = null;
        
        List<Account> customerList = [SELECT UL_Customer_Hierarchy_Level__c From Account Where Id =: currCustId] ;
                
        if(customerList.size() > 0){
            customerLevel = customerList[0].UL_Customer_Hierarchy_Level__c ;
        }
        
        if(String.isNotBlank(customerLevel)){
            customerLevel = customerLevel.substringAfter(UL_Utility.space);
            Integer level = Integer.valueOf(customerLevel);
            
            if(level < 3) {
                showSaveButton = false ;
                buttonLab = 'Back' ;
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.UL_PlanningLevelBetween3To7);
                ApexPages.addMessage(msg);
            }
        }
        
        loadDefaultSoldCustomers() ;
    }
    

    public pageReference save(){
        Id  currCustId = relatedRecord.UL_Customer__c ;
        Date currPLRecStartDt = relatedRecord.UL_Planning_Level_Start_Date__c ;
        Date currPLRecEndDt = relatedRecord.UL_Planning_Level_End_Date__c ;
        
        Boolean planLev = false ;
        
        List<Account>  custHierAccLst = new List<Account>();
        List<UL_Planning_Level__c> custHierAccPLLst = new List<UL_Planning_Level__c>();
        List<UL_Planning_Level__c> currCustPLLst = new List<UL_Planning_Level__c>();
        Set<Id> custHierAccIds = new Set<Id> () ;
        
                
        custHierAccLst = UL_CustomerUtility.getCustomerHierarchyAllCustomers(currCustId, UL_Utility.LEVEL8, currPLRecStartDt , currPLRecEndDt , getAllChildLevel) ;
                
        if(custHierAccLst != null){        
            if(custHierAccLst.size() > 0){
                system.debug('custHierAccLst size  '+custHierAccLst.size() );
                for(Account custHierAcc : custHierAccLst){
                    custHierAccIds.add(custHierAcc.Id) ;
                }
            }
        }
        
        if(custHierAccIds.size() > 0){      
            custHierAccPLLst = [SELECT Id, Name,UL_Planning_Level_Start_Date__c,UL_Planning_Level_End_Date__c  From UL_Planning_Level__c WHERE UL_Customer__c =: custHierAccIds] ;
        }        
        
        currCustPLLst = [SELECT Id, Name,UL_Planning_Level_Start_Date__c,UL_Planning_Level_End_Date__c  From UL_Planning_Level__c WHERE UL_Customer__c =: relatedRecord.UL_Customer__c] ;
        
        if(currCustPLLst.size() > 0){
            for(UL_Planning_Level__c currCustPL : currCustPLLst){
                custHierAccPLLst.add(currCustPL) ;
            }
        }
        
        if(custHierAccPLLst.size() > 0){
            for(UL_Planning_Level__c custHierAccPL : custHierAccPLLst){
                if((currPLRecStartDt == custHierAccPL.UL_Planning_Level_Start_Date__c) || (currPLRecEndDt == custHierAccPL.UL_Planning_Level_End_Date__c)
                || (currPLRecStartDt > custHierAccPL.UL_Planning_Level_Start_Date__c && currPLRecStartDt < custHierAccPL.UL_Planning_Level_End_Date__c)
                || (currPLRecEndDt > custHierAccPL.UL_Planning_Level_Start_Date__c && currPLRecEndDt < custHierAccPL.UL_Planning_Level_End_Date__c)
                || (custHierAccPL.UL_Planning_Level_Start_Date__c > currPLRecStartDt && custHierAccPL.UL_Planning_Level_Start_Date__c < currPLRecEndDt)
                || (custHierAccPL.UL_Planning_Level_End_Date__c > currPLRecStartDt && custHierAccPL.UL_Planning_Level_End_Date__c  < currPLRecEndDt)){
                    planLev = true ;
                    break ;
                }
            }
        }
            
        if (planLev){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.UL_PlanningLevelAndCurrency);
            ApexPages.addMessage(msg);
            return null;
        }
        else{
            pageReference pref = new PageReference('/'+relatedRecord.UL_Customer__c);
            Database.insert(relatedRecord);
            pref.setRedirect(true);
            return pref;
        }
    }
}