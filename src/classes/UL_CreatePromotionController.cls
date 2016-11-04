/**
@Author - vinod.thupakula@accenture.com
@name - UL_CreatePromotionController 
@CreateDate - 03-10-2016
@Description - this class inserting promotion records
@Version - 1.0
@reference - N/A
*/
public with sharing class UL_CreatePromotionController{
    
    private ApexPages.StandardController promotionController;        
    public ACSFUL001__Promotion__c relatedRecord { get; private set; }    
    public String defaultsoldto{set;get;}   
    public String planingLevelCustomers{set;get;}     
    public  Boolean msgFlag{get;set;}
    public List<SelectOption> defultsoldtocustomers{set;get;} 
    private String salesOrg{set;get;}
    String promotionTemplateSalesOrg{set;get;}
    private Map<Id,String> promotionTemplateWithSalesOrg = new Map<Id,String>();
    
    /**
    @Author - vinod.thupakula@accenture.com
    @method name - UL_CreatePromotionController
    @CreateDate - 03-10-2016
    @Description - this constructor feth the promotion templates.
    @Param - 
    @Version - 1.0
    @reference - NR
    */
    public UL_CreatePromotionController(ApexPages.StandardController ctr) {
        defultsoldtocustomers = new List<SelectOption>();
        this.promotionController = ctr;
        this.relatedRecord = (ACSFUL001__Promotion__c) ctr.getRecord();        
        salesOrg = UL_UtilityController.usersSalesOrg();
        loadPromotionTemplates();        
    }  
    
    /**
    @Author - vinod.thupakula@accenture.com
    @method name - PromotionTemplates
    @CreateDate - 03-10-2016
    @Description - this method feth the promotion templates assign to promotiontemplate variable.
    @Param - 
    @Version - 1.0
    @reference - NR
    */
    public List<SelectOption> PromotionTemplates {
        get {
            if (PromotionTemplates == null) {
                loadPromotionTemplates();
            }
            return PromotionTemplates;
        }
        private set;
    }
    
    /**
    @Author - vinod.thupakula@accenture.com
    @method name - Customers
    @CreateDate - 03-10-2016
    @Description - this method feth the accounts assign to Customers variable.
    @Param - 
    @Version - 1.0
    @reference - NR
    */
    public List<SelectOption> Customers{
        get {
            if (Customers== null) {
                loadCustomers();
            }
            return Customers;
        }
        private set;
    }
    /**
    @Author - vinod.thupakula@accenture.com
    @method name - loadPromotionTemplates
    @CreateDate - 03-10-2016
    @Description - this method feth the promotion templates.
    @Param - 
    @Version - 1.0
    @reference - NR
    */ 
    private void loadPromotionTemplates() {
        PromotionTemplates = new List<SelectOption>();      
        
        
        For (ACSFUL001__Promotion_template__c template:[SELECT Id, 
                                                               ACSFUL001__Description__c, 
                                                               ACSFUL001__Anchor_Type__c, 
                                                               ACSFUL001__Sales_Org__c 
                                                                        FROM ACSFUL001__Promotion_Template__c 
                                                                        WHERE 
                                                               ACSFUL001__Active__c = TRUE 
                                                                        AND   
                                                               ACSFUL001__Sales_Org__c =:salesOrg 
                                                                        AND  
                                                               ACSFUL001__Creation_Platform__c <> 'Mobility' 
                                                                        ORDER BY 
                                                               ACSFUL001__Description__c
                                                                        LIMIT :(Limits.getLimitQueryRows()-Limits.getQueryRows())]) {  
            promotionTemplateWithSalesOrg.put(template.Id,template.ACSFUL001__Sales_Org__c);
            PromotionTemplates.add(new SelectOption(template.Id, template.ACSFUL001__Description__c+UL_Utility.hyphen+template.ACSFUL001__Sales_Org__c));
            promotionTemplateSalesOrg  = template.ACSFUL001__Sales_Org__c;             
        }
        if(PromotionTemplates.size()==1){        
            loadCustomers();
        }
        if(PromotionTemplates.size()<0){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 
                                    System.Label.ACSFUL001.ERROR_NO_PROMOTION_TEMPLATE_AVAILABLE);
            ApexPages.addMessage(msg);
        }
       
    }
   
    /**
    @Author - vinod.thupakula@accenture.com
    @method name - loadCustomers
    @CreateDate - 03-10-2016
    @Description - this method feth the accounts.
    @Param - 
    @Version - 1.0
    @reference - NR
    */ 
   public void loadCustomers(){
       try{
            Customers = new List<SelectOption>(); 
            defultsoldtocustomers.clear(); 
            if(relatedRecord.ACSFUL001__Promotion_Template__c != null){    
                promotionTemplateSalesOrg=promotionTemplateWithSalesOrg.get(relatedRecord.ACSFUL001__Promotion_Template__c);    
            }   
            For (Account accRecord:[SELECT Id, 
                                           Name          FROM Account   where 
                                           UL_Planning_Level__c = true  AND
                                           UL_Customer_Role_Valid_Thru__c >= today AND
                                           UL_Sales_Organization__c =:promotionTemplateSalesOrg 
                                           ORDER BY Name Limit 50000]) {          
                Customers.add(new SelectOption(accRecord.Id,accRecord.name ));
            }
            if(Customers.isEmpty()){
                msgFlag = true;
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.Ul_EmptyAccounts);
                ApexPages.addMessage(msg);
            }
            if(Customers.size()==1){
            loaddefultsoldtocustomers();
            }
       }
       catch(Exception ex) {
           msgFlag = true;
           ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage());
           ApexPages.addMessage(msg);
       }
    }
   /**
   @Author - vinod.thupakula@accenture.com
   @method name - save
   @CreateDate - 03-10-2016
   @Description - this method save the promotion record.
   @Param - 
   @Version - 1.0
   @reference - NR
   */ 
   public PageReference save() {
        PageReference pref = null;
        
        try {
            mapPromotionFields();
            Database.insert(relatedRecord);
            id promotionId = relatedRecord.id;
            ApexPages.StandardController ctr = new ApexPages.StandardController(this.relatedRecord);
            String recordTypeDevName = [SELECT RecordType.DeveloperName 
                                                       FROM ACSFUL001__Promotion__c 
                                                       where 
                                               Id = :this.relatedRecord.Id].RecordType.DeveloperName;
            if(recordTypeDevName.equals(UL_Utility.promotiontype)){
                pref = ctr.edit();
                Map<String, String> params = pref.getParameters();
                params.clear();
                params.put(UL_Utility.retURL, ctr.view().getURL());
            }
            else{
                pref = new PageReference('/apex/MyPromotionPlanning?id='+promotionId);
            } 
            pref.setRedirect(true);
        } 
        catch(Exception ex) {
            msgFlag = true;
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage());
            ApexPages.addMessage(msg);
            
        }        
        return pref;
    }
    
   /**
   @Author - vinod.thupakula@accenture.com
   @method name - fetchingDefaultsoldto
   @CreateDate - 03-10-2016
   @Description - this method called to loaddefultsoldtocustomers method.
   @Param - 
   @Version - 1.0
   @reference - NR
   */ 
    public void fetchingDefaultsoldto(){
       loaddefultsoldtocustomers();
    }
    /**
    @Author - vinod.thupakula@accenture.com
    @method name - loaddefultsoldtocustomers
    @CreateDate - 03-10-2016
    @Description - this method feth the planning leval accounts based on anchor customer.
    @Param - 
    @Version - 1.0
    @reference - NR
    */  
    private void loaddefultsoldtocustomers(){        
        defultsoldtocustomers.clear();        
        list<Account> accountRecord = [select id,
                                              Name,
                                              UL_Customer_Hierarchy_Level__c,
                                              UL_Planning_Level__c 
                                                     from Account 
                                                     where 
                                              id=:planingLevelCustomers
                                                     LIMIT :(Limits.getLimitQueryRows()-Limits.getQueryRows())];
            if(!accountRecord.isEmpty() && !String.isblank(accountRecord[0].UL_Customer_Hierarchy_Level__c)){
                    String customerlevel = accountRecord[0].UL_Customer_Hierarchy_Level__c;
                    customerlevel = customerlevel.substringAfter(UL_Utility.space);      
                    Integer levelNumber = Integer.valueOf(customerlevel);  
                    String level = UL_Utility.level;
                    String query = UL_Utility.accQuery+level+UL_Utility.andCommand;
                    query +=UL_Utility.levelField+levelNumber+UL_Utility.underscoreC+accountRecord[0].id+UL_Utility.colon;                      
                    List<Account>  allLevelRecords= Database.query(query);                   
                    For (Account accRecord:allLevelRecords) {          
                        defultsoldtocustomers.add(new SelectOption(accRecord.id,accRecord.name ));
                    }
            }   
     }
    /**
    @Author - vinod.thupakula@accenture.com
    @method name - redirPage
    @CreateDate - 03-10-2016
    @Description - this method redirect page based on user sales org.
    @Param - 
    @Version - 1.0
    @reference - NR
    */ 
     public PageReference redirPage(){
        Pagereference ref = null;
        try{          
            List<UL_SalesOrg__c> sOrgValues = UL_SalesOrg__c.getall().values();
            for(UL_SalesOrg__c sOrg:sOrgValues){
                if(sOrg.Name.equals(salesOrg)){                    
                  ref = new Pagereference(UL_Utility.creationpage);                  
                  ref.setRedirect(true);    
                } 
            }
                         
        }
        catch(Exception l_objEx){
            ref = null; 
        }
         return ref;
    }
     /**
    @Author - vinod.thupakula@accenture.com
    @method name - mapPromotionFields
    @CreateDate - 03-10-2016
    @Description - this method map the promotion fields.
    @Param - 
    @Version - 1.0
    @reference - NR
    */ 
    private void mapPromotionFields(){
        relatedRecord.ACSFUL001__Anchor_Account__c = planingLevelCustomers;
         relatedRecord.UL_Account__c = defaultsoldto;
         relatedRecord.ACSFUL001__Placement_Date_Thru__c= relatedRecord.ACSFUL001__Placement_Date_From__c.addDays(1);
         relatedRecord.ACSFUL001__Commit_Date__c = relatedRecord.ACSFUL001__Placement_Date_From__c;

         relatedRecord.ACSFUL001__Date_From__c= relatedRecord.ACSFUL001__Placement_Date_From__c ;
         relatedRecord.ACSFUL001__Date_Thru__c= relatedRecord.ACSFUL001__Placement_Date_From__c.addDays(1);
 
         relatedRecord.ACSFUL001__Order_Date_From__c = relatedRecord.ACSFUL001__Placement_Date_From__c ;
         relatedRecord.ACSFUL001__Order_Date_Thru__c = relatedRecord.ACSFUL001__Placement_Date_From__c.addDays(1);
 
         relatedRecord.ACSFUL001__Delivery_Date_From__c = relatedRecord.ACSFUL001__Placement_Date_From__c ;
         relatedRecord.ACSFUL001__Delivery_Date_Thru__c = relatedRecord.ACSFUL001__Placement_Date_From__c.addDays(1);
    }
          
}