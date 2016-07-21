public class AF_AgencyEstimateController
{

    public Boolean IsReadyforPO { get; set; }
    public Boolean fieldsReadOnly {get;set;}
    public Boolean isAgency{get;set;}
    public Boolean isCatFinance{get;set;}
    public Boolean catFieldsReadOnly {get;set;}
    public Boolean isCMCO {get;set;}
    public Boolean cmcoFieldsReadOnly {get;set;}
    public Boolean isControllerPro{get;set;}
    public Boolean isCMCOSuperUser{get;set;}
    public Boolean isCMCOReadyPOEdit{get;set;}
    public List<AF_CMCO__c> cmcoEditDateList{get;set;}
    public Boolean CMCORO{get;set;}
    //Record Members
    public AF_Agency_Estimate__c AgencyEstimate {get;set;}    
    public AF_Entity_Exception__c EntityException {get;set;}
    public list<AF_Entity_Exception__c> lst_EntityException=new list<AF_Entity_Exception__c>();
    public list<Entitywrapper>Wrapperlist {get;set;}
    public list<selectoption> Countrynames{get;set;}
    public Boolean IsEditMode {get;set;}   
    //Display Members
    public Double DisplayTotal {get;set;}
    public Boolean IsUpdate {get;set;}
    public Boolean IsInsert {get;set;}
    public string UnileverEntityName {get;set;}
    public string AgencyEntityName {get;set;}
    public Boolean DisplayExceptionList {get;set;}
       
    public Double EntityExceptionPercentage {get;set;}
    public Double EntityExceptionValue {get;set;}
    public string EntityExceptionCountry {get;set;}
    public string ExceptionId {get;set;}
    Public Boolean isPOEditable{get;set;}
    public String delCountryId{get;set;}
       
    //Collection Members
    public List<AF_Comments__c> CommentsCollection {get;set;}
    public List<Document> DocumentsCollection {get;set;}
    public List<string> HistoryCollection {get;set;}
    public List<AF_Entity_Exception__c> EntityExceptionCollection {get;set;}

    public List<AF_Entity__c> UnileverEntity {get;set;}
    public Boolean IsCentralHub {get;set;} 
    public Boolean IsReadonlyPO{get;set;}
    public Boolean IsShowPOTab{get;set;}
    public String ParentId {get;set;}
    public String ParentRecordType {get;set;}
    public String ErrorMessage {get;set;}
    public AF_Comments__c CommentRecord {get;set;}
    public Boolean IsLocked {get;set;} 
    public Boolean IsError {get;set;}
    Public String ActivePanel {get;set;}
    Public Decimal TotalPercent{get;set;}
    Public Decimal TotalValue{get;set;}
    Public Decimal TotalLocal{get;set;}
    Public Decimal TotalLocalUSD{get;set;}
    Public Decimal PoNumber{get;set;}
    Public Decimal PoValue{get;set;}
    public Integer posDelete{get;set;}
    Public Boolean isAgencyEstEditable{get;set;}
    public Decimal traditionalUSD{get;set;}
    public Decimal DigitalUSD{get;set;}
    public Decimal AdaptationUSD{get;set;}
    public Boolean bConfirmBox{get;set;}
    public Decimal OverrideTotal{get;set;}
    public Decimal overrideTrad{get;set;}
    public Decimal overrideDigital{get;set;}
    public Decimal overrideAdapt{get;set;}
    public String overridePONumber{get;set;}
    Public String brandEstQuarter;
    public Boolean POOverrideDisplay{get;set;}
    public String TraditionalDisplay{     
        get{String result = '';if(AgencyEstimate .AF_Traditional__c != null){if(AgencyEstimate .AF_Traditional__c > 0) {result = AgencyEstimate .AF_Traditional__c.format();}else{result ='';}}return result;}
        set{/*System.debug('TraditionalDisplay: ' + value);*/value = CommaFilter(value);System.debug('TraditionalDisplay: ' + value);if(value != ''){AgencyEstimate .AF_Traditional__c = Integer.valueOf(value);}else{AgencyEstimate.AF_Traditional__c = 0.00;}}
    }
   
    public String DigitalDisplay
    {        
        get{String result = '';if(AgencyEstimate.AF_Digital__c != null){if(AgencyEstimate .AF_Digital__c > 0) {result = AgencyEstimate .AF_Digital__c.format();}else{result ='';}}return result;}
        set{/*System.debug('DigitalDisplay: ' + value);*/value = CommaFilter(value);System.debug('DigitalDisplay: ' + value);if(value != ''){AgencyEstimate .AF_Digital__c = Integer.valueOf(value);}else{AgencyEstimate .AF_Digital__c = 0.00;}}        
    }
    
    public String AdaptationDisplay
    {
        get{String result = '';if(AgencyEstimate .AF_Adaptation__c != null){if(AgencyEstimate.AF_Adaptation__c > 0) {result = AgencyEstimate.AF_Adaptation__c.format();}else{result ='';}}return result;}        
        set{/*System.debug('AdaptationDisplay: ' + value);*/value = CommaFilter(value);System.debug('AdaptationDisplay: ' + value);if(value != ''){AgencyEstimate.AF_Adaptation__c = Integer.valueOf(value);}else{AgencyEstimate.AF_Adaptation__c = 0.00;}}        
    }
    
  public String TotalDisplay
    {        
        get;
        set;
        //set{System.debug('AdaptationDisplay: ' + value);value = CommaFilter(value);System.debug('AdaptationDisplay: ' + value);if(value != ''){BrandEstimateObj.AF_Total__c = Integer.valueOf(value);}else{BrandEstimateObj.AF_Total__c = 0.00;}}
    }
      public decimal TotalDisplayN{get;set;}
    
    
       /* private Integer traditionalDisplayValue;
        public Integer TraditionalDisplay{get{return traditionalDisplayValue;}set{traditionalDisplayValue = value;}}
        private Integer digitalDisplayValue;
        public Integer DigitalDisplay{get{return digitalDisplayValue;}set{digitalDisplayValue = value;}}
        private Integer adaptationDisplayValue;
        public Integer AdaptationDisplay{get{return adaptationDisplayValue;}set{adaptationDisplayValue = value;}}
*/

        public List<AF_Entity_Exception__c> getDisplayEntityException()
        {               
                return EntityExceptionCollection;
        }
        
    public void clearErrorMsg(){
       ApexPages.getMessages().clear();
      }
     
        
    private string CommaFilter(string value)
    {
        if(value.contains(',') == true){value = value.replaceAll(',','');}
        return value;       
    }
            
    private void SetDisplayValues()
    {

      /**  DigitalDisplay = (Integer)AgencyEstimate.AF_Digital__c;
        TraditionalDisplay = (Integer)AgencyEstimate.AF_Traditional__c;
        AdaptationDisplay = (Integer)AgencyEstimate.AF_Adaptation__c;
                    
        if(AgencyEstimate.AF_Traditional_Local__c != null){AgencyEstimate.AF_Traditional_Local__c = AgencyEstimate.AF_Traditional_Local__c; AgencyEstimate.AF_Traditional_Local__c = AgencyEstimate.AF_Traditional_Local__c.setscale(0);}
        if(AgencyEstimate.AF_Digital_Local__c != null){AgencyEstimate.AF_Digital_Local__c = AgencyEstimate.AF_Digital_Local__c;AgencyEstimate.AF_Digital_Local__c = AgencyEstimate.AF_Digital_Local__c.setscale(0);}
        if(AgencyEstimate.AF_Adaptation_Local__c != null){AgencyEstimate.AF_Adaptation_Local__c = AgencyEstimate.AF_Adaptation_Local__c;AgencyEstimate.AF_Adaptation_Local__c = AgencyEstimate.AF_Adaptation_Local__c.setscale(0);}
    **/
        DigitalDisplay = String.valueof(AgencyEstimate.AF_Digital__c);
        TraditionalDisplay = String.valueof(AgencyEstimate.AF_Traditional__c);
        AdaptationDisplay = String.valueof(AgencyEstimate.AF_Adaptation__c);
                    
       
        if(AgencyEstimate.AF_Traditional_Local__c != null){AgencyEstimate.AF_Traditional_Local__c = Double.valueof(AgencyEstimate.AF_Traditional_Local__c); AgencyEstimate.AF_Traditional_Local__c = Double.valueof(AgencyEstimate.AF_Traditional_Local__c.setscale(0));}
        if(AgencyEstimate.AF_Digital_Local__c != null){AgencyEstimate.AF_Digital_Local__c = Double.valueof(AgencyEstimate.AF_Digital_Local__c);AgencyEstimate.AF_Digital_Local__c = Double.valueof(AgencyEstimate.AF_Digital_Local__c.setscale(0));}
        if(AgencyEstimate.AF_Adaptation_Local__c != null){AgencyEstimate.AF_Adaptation_Local__c = Double.valueof(AgencyEstimate.AF_Adaptation_Local__c);AgencyEstimate.AF_Adaptation_Local__c = Double.valueof(AgencyEstimate.AF_Adaptation_Local__c.setscale(0));}
        
         if(AgencyEstimate.AF_Traditional_Local__c!=null){
          TotalLocal=AgencyEstimate.AF_Traditional_Local__c+AgencyEstimate.AF_Digital_Local__c+AgencyEstimate.AF_Adaptation_Local__c;
        }
        System.debug('local digi'+ AgencyEstimate.AF_Digital_Local__c);
        System.debug('local trad'+AgencyEstimate.AF_Traditional_Local__c);
        System.debug('local adap'+AgencyEstimate.AF_Adaptation_Local__c)  ; 
        //Chnage for displaying one more row for ready for PoNumber
        
         if(AgencyEstimate.Traditional_USD_Formula__c != null){traditionalUSD = AgencyEstimate.Traditional_USD_Formula__c;}
        if(AgencyEstimate.AF_Digital_USD_Formula__c != null){DigitalUSD = Double.valueof(AgencyEstimate.AF_Digital_USD_Formula__c.setscale(0));}
        if(AgencyEstimate.Adaptation_USD_Formula__c != null){AdaptationUSD = Double.valueof(AgencyEstimate.Adaptation_USD_Formula__c.setscale(0));}
        
         if(AgencyEstimate.Traditional_USD_Formula__c!=null){
          TotalLocalUSD=AgencyEstimate.Traditional_USD_Formula__c+AgencyEstimate.AF_Digital_USD_Formula__c+AgencyEstimate.Adaptation_USD_Formula__c;
        }
        System.debug('local digi USD'+ AgencyEstimate.AF_Digital_USD_Formula__c);
        
        System.debug('local adap USD'+AgencyEstimate.Adaptation_USD_Formula__c)  ; 
  
    }
    
    private void SetDisplayValuesForSave()
    {
       /** AgencyEstimate.AF_Digital__c = Decimal.valueof(DigitalDisplay) ;
        AgencyEstimate.AF_Traditional__c = Decimal.valueof(TraditionalDisplay) ;
        AgencyEstimate.AF_Adaptation__c = Decimal.valueof(AdaptationDisplay) ;
        
        if(AgencyEstimate.AF_Traditional_Local__c != null){AgencyEstimate.AF_Traditional_Local__c =(AgencyEstimate.AF_Traditional_Local__c);AgencyEstimate.AF_Traditional_Local__c =(AgencyEstimate.AF_Traditional_Local__c.setscale(0));}
        if(AgencyEstimate.AF_Digital_Local__c != null){AgencyEstimate.AF_Digital_Local__c = (AgencyEstimate.AF_Digital_Local__c);AgencyEstimate.AF_Digital_Local__c = (AgencyEstimate.AF_Digital_Local__c.setscale(0));} 
        if(AgencyEstimate.AF_Adaptation_Local__c != null){AgencyEstimate.AF_Adaptation_Local__c =(AgencyEstimate.AF_Adaptation_Local__c);AgencyEstimate.AF_Adaptation_Local__c = (AgencyEstimate.AF_Adaptation_Local__c.setscale(0));} 
     **/
      
       /** AgencyEstimate.AF_Digital__c = DigitalDisplay ;
        AgencyEstimate.AF_Traditional__c = TraditionalDisplay ;
        AgencyEstimate.AF_Adaptation__c = AdaptationDisplay ;
        
        if(AgencyEstimate.AF_Traditional_Local__c != null){AgencyEstimate.AF_Traditional_Local__c = AgencyEstimate.AF_Traditional_Local__c;AgencyEstimate.AF_Traditional_Local__c = AgencyEstimate.AF_Traditional_Local__c.setscale(0);}
        if(AgencyEstimate.AF_Digital_Local__c != null){AgencyEstimate.AF_Digital_Local__c = AgencyEstimate.AF_Digital_Local__c;AgencyEstimate.AF_Digital_Local__c = AgencyEstimate.AF_Digital_Local__c.setscale(0);} 
        if(AgencyEstimate.AF_Adaptation_Local__c != null){AgencyEstimate.AF_Adaptation_Local__c = AgencyEstimate.AF_Adaptation_Local__c;AgencyEstimate.AF_Adaptation_Local__c = AgencyEstimate.AF_Adaptation_Local__c.setscale(0);} 
       **/
    }
    Public user LoggedinUser{set;get;}
    public boolean SubmitButtonDisplay {set;get;}
    public AF_PO_Report__c poReportObj{get;set;}
    
    public AF_AgencyEstimateController()
    {           
        isCMCOSuperUser = false;
        isCMCO = false;
        cmcoFieldsReadOnly = false;
        isAgency = false;
        fieldsReadOnly = false;
        catFieldsReadOnly=false;
        isCatFinance = false;
        IsShowPOTab=false;
        IsReadonlyPO=false;
        IsEditMode=true;
        TotalPercent=0;
        TotalValue=0;
        TotalLocal=0;
        IsReadyforPO=false;
        PoNumber=0;
        PoValue=0;
        isPOEditable=false;
        isAgencyEstEditable=false;
        isControllerPro = false;
        posDelete =0;
        CMCORO = false;
      //  TraditionalDisplay = 0;
      //  DigitalDisplay = 0;
      //  AdaptationDisplay = 0; 
        IsCentralHub = true; 
        ActivePanel='Agency Estimate';
        ParentId = ApexPages.currentPage().getParameters().get('Id');    
        GetCountry();
        EntityException = new AF_Entity_Exception__c(); 
        Wrapperlist =new  list<Entitywrapper>();
        isCMCOReadyPOEdit = false;
        bConfirmBox = false;
        cmcoEditDateList = new List<AF_CMCO__c>();
        CallEntityWrapper();
        poReportObj = new AF_PO_Report__c();
        OverrideTotal=0;
        brandEstQuarter='';
        POOverrideDisplay = false;
       
      /**            
        List<PermissionSetAssignment> permissionSetAssign =[select PermissionSet.Name from PermissionSetAssignment where Assignee.Id = :userId and (PermissionSet.Name like'%CMCO%' or PermissionSet.Name like'%Category%' or PermissionSet.Name like'%Agency%')  order by PermissionSet.Name];
        for (PermissionSetAssignment Names:permissionSetAssign ){
            string permissionSetName = Names.PermissionSet.Name;
            if(permissionSetName.contains('CMCO')){
                isCMCO=true;
            }else if(permissionSetName.contains('Category')){
                isFinance=true;
            }
        
        }**/
        
        //EntityExceptionCollection = new List<AF_Entity_Exception__c>();  
        LoggedinUser=[select id,IsActive,Username,Name,AF_Brand__c,AF_Agency_Fees_User_Type__c,profile.name  from  User  where id=:Userinfo.getuserid()   and IsActive=true  Order by CreatedDate Limit 50000];             
        if(LoggedinUser.AF_Agency_Fees_User_Type__c!=null){
            if(LoggedinUser.AF_Agency_Fees_User_Type__c=='CMCO Super User' || LoggedinUser.AF_Agency_Fees_User_Type__c=='Category Finance' || LoggedinUser.AF_Agency_Fees_User_Type__c=='Controller' || LoggedinUser.AF_Agency_Fees_User_Type__c=='Regional Category Finance'){
                isPOEditable=true;
            }
           if(LoggedinUser.AF_Agency_Fees_User_Type__c=='CMCO Super User' || LoggedinUser.AF_Agency_Fees_User_Type__c=='Category Finance' || LoggedinUser.AF_Agency_Fees_User_Type__c=='Agency' ){
                isAgencyEstEditable=true;
            } 
            if(LoggedinUser.AF_Agency_Fees_User_Type__c=='CMCO User' || LoggedinUser.AF_Agency_Fees_User_Type__c=='Procurement'  ||  LoggedinUser.AF_Agency_Fees_User_Type__c=='Agency'){
            IsReadonlyPO=true;
               }
            if(LoggedinUser.AF_Agency_Fees_User_Type__c=='CMCO Super User' || LoggedinUser.AF_Agency_Fees_User_Type__c=='Category Finance'|| LoggedinUser.AF_Agency_Fees_User_Type__c=='CMCO User' || LoggedinUser.AF_Agency_Fees_User_Type__c=='Procurement' || LoggedinUser.AF_Agency_Fees_User_Type__c=='Controller' || LoggedinUser.AF_Agency_Fees_User_Type__c=='Regional Category Finance'||LoggedinUser.AF_Agency_Fees_User_Type__c=='Agency' ){
            IsShowPOTab=true;
               }  
            if(LoggedinUser.AF_Agency_Fees_User_Type__c=='Agency'){
            isAgency= true;
            }
            if(LoggedinUser.AF_Agency_Fees_User_Type__c=='Category Finance'){
            isCatFinance= true;
            }
            if(LoggedinUser.AF_Agency_Fees_User_Type__c=='CMCO User'){
            isCMCO= true;
            //Added to make the fields read Only for CMCO Finance 
            CMCORO=true;
            }
            if(LoggedinUser.AF_Agency_Fees_User_Type__c=='Procurement' || LoggedinUser.AF_Agency_Fees_User_Type__c=='Controller'){
            isControllerPro = true;
            }
            if(LoggedinUser.AF_Agency_Fees_User_Type__c=='CMCO Super User'){
            isCMCOSuperUser = true;
            }
            
        }
        cmcoEditDateList = [select AF_CMCO_Rights__c from AF_CMCO__c];
        if(cmcoEditDateList.size()>0){
            if(cmcoEditDateList[0].AF_CMCO_Rights__c == true){
                isCMCOReadyPOEdit = true;
                system.debug('isCMCOReadyPOEdit...'+isCMCOReadyPOEdit);
            }
        }   
        if(ApexPages.currentPage().getParameters().get('Id') != null)
        {
                IsUpdate = true;
                IsInsert = false;               
                                       
            AgencyEstimate = [select Id,AF_OverridePO_Adaptation_LC__c,AF_OverridePO_Digital_LC__c,AF_OverridePO_Traditional_LC__c,AF_Category_Finance_Flag__c,AF_Total_USD__c,AF_Total_Local__c,Traditional_USD_Formula__c,AF_Digital_USD_Formula__c,Adaptation_USD_Formula__c,AF_IsCrossborder__c,AF_Ready_For_PO_Entry_Currency__c,AF_Agency_Spot_Rate__c,AF_Quarter_PO_Raised__c,AF_PO_Value__c,AF_Adaptation__c,AF_PO_Number__c,AF_Brand_Estimate__r.AF_CMCO_Rejected__c,AF_Brand_Estimate__r.AF_Basefee_Estimate_Initial_Quarter__c,AF_Brand_Estimate__r.AF_Status_Base_Fees__c,AF_Is_Unilever_Central_Hub__c,AF_CentralBilling__c, AF_Unilever_Entity_Name__c,AF_Agency_Entity_Name__c,AF_isLocked__c, AF_Digital__c, AF_Traditional__c,AF_Agency_Entity__c,AF_Unilever_Entity__c,AF_Total__c,AF_Matrix_Data_Entry_Currency__c, AF_Traditional_Local__c, AF_Digital_Local__c, AF_Adaptation_Local__c,AF_Agency_Exchange_Rate__c,AF_CentralBillingMessage__c,AF_LC_Traditional__c,AF_LC_Digital__c,AF_LC_Adaptation__c,AF_LC_Total__c  FROM AF_Agency_Estimate__c WHERE Id = : ParentId];
            EntityExceptionCollection = [select Id, AF_Agency_Estimate__c, AF_Value_Euro__c,AF_Value__c,AF_Country__c FROM AF_Entity_Exception__c where AF_Agency_Estimate__c = : ParentId];
            if(EntityExceptionCollection != null){if(EntityExceptionCollection.size() > 0){DisplayExceptionList = true;}}            
            if(AgencyEstimate != null)
            {      
                //SetDisplayValues();
                UnileverEntityName = AgencyEstimate.AF_Unilever_Entity_Name__c;
                AgencyEntityName = AgencyEstimate.AF_Agency_Entity_Name__c;
                IsCentralHub = AgencyEstimate.AF_CentralBilling__c;
                if(AgencyEstimate.AF_Brand_Estimate__r.AF_Status_Base_Fees__c=='Ready for PO'){
                   IsReadyforPO=true;
                   if(AgencyEstimate.AF_PO_Number__c!=null){
                  // PoNumber=Decimal.valueof(AgencyEstimate.AF_PO_Number__c);
                   }
                   if(AgencyEstimate.AF_Quarter_PO_Raised__c!=null){
                   PoValue=(AgencyEstimate.AF_Quarter_PO_Raised__c);
                   }
                }else{
                SetDisplayValues();
                }
                //Added by Reetha for access rights of agency Users
                if(AgencyEstimate.AF_Brand_Estimate__r.AF_Status_Base_Fees__c=='With Agency'){
                    fieldsReadOnly = true;
                }
                if(AgencyEstimate.AF_Brand_Estimate__r.AF_Status_Base_Fees__c=='With Category Finance'){
                    catFieldsReadOnly = true;
                }
                if(AgencyEstimate.AF_Brand_Estimate__r.AF_Status_Base_Fees__c=='With CMCO'){
                    cmcoFieldsReadOnly = true;
                }
                
                if(AgencyEstimate.AF_Brand_Estimate__r.AF_Basefee_Estimate_Initial_Quarter__c!=null){
                    brandEstQuarter = AgencyEstimate.AF_Brand_Estimate__r.AF_Basefee_Estimate_Initial_Quarter__c;
                    if(!brandEstQuarter.contains('Q4')){
                        POOverrideDisplay = true;
                    }
                }
                
                if(AgencyEstimate.AF_isLocked__c == null || AgencyEstimate.AF_isLocked__c == false)IsLocked = true;else{IsLocked = false;}
                CalculateTotal();
                if(AgencyEstimate.af_total__c >0)
                {
                    IsEditMode=true;
                }
                else
                {
                    IsEditMode=true;
                }
                try{
                poReportObj = [SELECT AF_Calculate_Tradition_Local__c,AF_Calculate_Adaptation_Local__c,AF_Calculate_Digital_Local__c,AF_PO_Value_Total_LC__c from AF_PO_Report__c where AF_Agency_Estimate_ID__c=:ParentId];
                }
                catch(Exception e){
                    system.debug(e);
                }
                if(AgencyEstimate.AF_OverridePO_Adaptation_LC__c!=null)
                OverrideTotal = OverrideTotal + AgencyEstimate.AF_OverridePO_Adaptation_LC__c;
                if(AgencyEstimate.AF_OverridePO_Digital_LC__c!=null)
                OverrideTotal = OverrideTotal + AgencyEstimate.AF_OverridePO_Digital_LC__c; 
                if(AgencyEstimate.AF_OverridePO_Traditional_LC__c!=null)
                OverrideTotal = OverrideTotal + AgencyEstimate.AF_OverridePO_Traditional_LC__c;
                
                system.debug('OverrideTotal..1.'+OverrideTotal);
                //if(AgencyEstimate.AF_OverridePO_Adaptation_LC__c!=null)
                overrideTrad =  AgencyEstimate.AF_OverridePO_Traditional_LC__c;
                //if(AgencyEstimate.AF_OverridePO_Digital_LC__c!=null)
                overrideDigital = AgencyEstimate.AF_OverridePO_Digital_LC__c;
                //if(AgencyEstimate.AF_OverridePO_Traditional_LC__c!=null)
                overrideAdapt = AgencyEstimate.AF_OverridePO_Adaptation_LC__c;
                overridePONumber = AgencyEstimate.AF_PO_Number__c;
                
                system.debug('overrideTrad.1.'+overrideTrad);
            system.debug('overrideDigital.1.'+overrideDigital);
            system.debug('overrideAdapt.1.'+overrideAdapt);
                
            }            
                  
        }
        else
        {
                if(ApexPages.currentPage().getParameters().get('bid') != null && ApexPages.currentPage().getParameters().get('aid') != null && ApexPages.currentPage().getParameters().get('uid') != null)
                {
                        IsUpdate = false;
                        IsInsert = true;
                        IsCentralHub = false;
                        AgencyEstimate = new AF_Agency_Estimate__c();                   
                        AgencyEstimate.AF_Brand_Estimate__c = ApexPages.currentPage().getParameters().get('bid'); 
                        AgencyEstimate.AF_Unilever_Entity__c = ApexPages.currentPage().getParameters().get('uid');
                        AgencyEstimate.AF_Agency_Entity__c = ApexPages.currentPage().getParameters().get('aid');  
                        UnileverEntityName = AF_Utils.EntityNameValue(ApexPages.currentPage().getParameters().get('uid'));
                        AgencyEntityName = AF_Utils.EntityNameValue(ApexPages.currentPage().getParameters().get('aid'));                                                
                        //EntityExceptionCollection = [select Id, AF_Agency_Estimate__c, AF_Value_Euro__c,AF_Value__c,AF_Country__c FROM AF_Entity_Exception__c where AF_Agency_Estimate__c = : ParentId];                                                                              
                }                
        }
        

        if((AgencyEstimate.AF_Brand_Estimate__r.AF_Status_Base_Fees__c=='With Agency' && LoggedinUser.AF_Agency_Fees_User_Type__c=='Agency') || 
           (AgencyEstimate.AF_Brand_Estimate__r.AF_Status_Base_Fees__c=='With Category Finance' && LoggedinUser.AF_Agency_Fees_User_Type__c=='Category Finance') ||
           LoggedinUser.AF_Agency_Fees_User_Type__c=='CMCO Super User')
        {
            SubmitButtonDisplay=true;            
        }
        Else
        {
            SubmitButtonDisplay=false;
        } 
         
                
    }
   
   public void getupdatedC_breakdown(){
      system.debug('inside brekdown');
      Wrapperlist.clear();
      CallEntityWrapper(); 
   }
   public void CallEntityWrapper(){
        Wrapperlist.clear();
        TotalPercent=0;
        TotalValue=0;
        Integer wrapperPos=-1;
        Wrapperlist =new  list<Entitywrapper>();
        lst_EntityException =[Select id,name,AF_Country__c,AF_Agency_Estimate__c,AF_Value__c,AF_Value_Euro__c from AF_Entity_Exception__c where AF_Agency_Estimate__c=:ParentId ];
        if(lst_EntityException.size()>0){
        for(AF_Entity_Exception__c Entity_exc:lst_EntityException){
            wrapperPos++;
        system.debug('Entity_exc.AF_Value_Euro__c Wrapper'+Entity_exc.AF_Value_Euro__c);
        if(Entity_exc.AF_Value__c!=null){
         TotalPercent=TotalPercent+Entity_exc.AF_Value__c;
        }
       if(Entity_exc.AF_Value_Euro__c!=Null){
        TotalValue= TotalValue+Entity_exc.AF_Value_Euro__c;
        }
        Wrapperlist.add(new Entitywrapper(Entity_exc,true,wrapperPos));
        }
       
        }    
        
   }
    
        public List<SelectOption> getUnileverEntities()
    {
        UnileverEntity = [select id, name from AF_Entity__c LIMIT 50];
        List<SelectOption> UEList = new List<SelectOption>();
        for(AF_Entity__c afe : UnileverEntity)
        {           
           UEList.add(new SelectOption(afe.Name,afe.Name));
        }
        return UEList;
    }
    
    private boolean IsCentralHub(string pId)
    {
        AF_Entity__c entity = [select id, IsCentralHub__c FROM AF_Entity__c where Id = : pId];
        return entity.IsCentralHub__c;
    }
    public void confirmBox(){
    bConfirmBox = true;
    }
    public void closePopupReject(){
    bConfirmBox = false;
    }
    public void UpdatPO(){
    
        if(AgencyEstimate.AF_PO_Number__c!=null){
            system.debug('inside....');
            system.debug('overrideTrad..'+overrideTrad);
            system.debug('overrideDigital..'+overrideDigital);
            system.debug('overrideAdapt..'+overrideAdapt);
            if(overrideTrad != AgencyEstimate.AF_OverridePO_Traditional_LC__c)
             AgencyEstimate.AF_OverridePO_Traditional_LC__c = overrideTrad;
            if(overrideDigital != AgencyEstimate.AF_OverridePO_Digital_LC__c)
             AgencyEstimate.AF_OverridePO_Digital_LC__c = overrideDigital;
             if(overrideAdapt != AgencyEstimate.AF_OverridePO_Adaptation_LC__c)
             AgencyEstimate.AF_OverridePO_Adaptation_LC__c = overrideAdapt;
            system.debug('AgencyEstimate.AF_OverridePO_Traditional_LC__c..'+AgencyEstimate.AF_OverridePO_Traditional_LC__c);
            system.debug('AgencyEstimate.AF_OverridePO_Digital_LC__c..'+AgencyEstimate.AF_OverridePO_Digital_LC__c);
            system.debug('AgencyEstimate.AF_OverridePO_Adaptation_LC__c.'+AgencyEstimate.AF_OverridePO_Adaptation_LC__c);
            update AgencyEstimate;
            overridePONumber = AgencyEstimate.AF_PO_Number__c;
            apexpages.addmessage(new apexpages.message(apexpages.severity.Confirm,'Record successfully saved'));
        }    
    }
    public void OverridePO(){
    OverrideTotal=0;
    Boolean errMsgOverride=false;
    bConfirmBox = false;
            if(overridePONumber != AgencyEstimate.AF_PO_Number__c)
              AgencyEstimate.AF_PO_Number__c = overridePONumber;
            if(AgencyEstimate.AF_OverridePO_Adaptation_LC__c!=null)
                OverrideTotal = OverrideTotal + AgencyEstimate.AF_OverridePO_Adaptation_LC__c;
                if(AgencyEstimate.AF_OverridePO_Digital_LC__c!=null)
                OverrideTotal = OverrideTotal + AgencyEstimate.AF_OverridePO_Digital_LC__c;
                if(AgencyEstimate.AF_OverridePO_Traditional_LC__c!=null)
                OverrideTotal = OverrideTotal + AgencyEstimate.AF_OverridePO_Traditional_LC__c;
                
                if(OverrideTotal>AgencyEstimate.AF_LC_Total__c){
                    errMsgOverride=true;
                    
                    apexpages.addmessage(new apexpages.message(apexpages.severity.Error,'POOverride value cannot be more than the BaseFee'));
                }
                
                system.debug('OverrideTotal..2.'+OverrideTotal);
    
    if(errMsgOverride==false){
        
    update AgencyEstimate;
    overrideTrad =  AgencyEstimate.AF_OverridePO_Traditional_LC__c;
    overrideDigital =  AgencyEstimate.AF_OverridePO_Digital_LC__c;
    overrideAdapt =  AgencyEstimate.AF_OverridePO_Adaptation_LC__c;
    try{
     poReportObj = [SELECT AF_Calculate_Tradition_Local__c,AF_Calculate_Adaptation_Local__c,AF_Calculate_Digital_Local__c,AF_PO_Value_Total_LC__c from AF_PO_Report__c where AF_Agency_Estimate_ID__c=:ParentId];
     system.debug('poReportObj....'+poReportObj);
     }
     catch(Exception e){
        system.debug(e);
     }
      apexpages.addmessage(new apexpages.message(apexpages.severity.Confirm,'Record successfully saved')); 
     }
    }
    
    public PageReference Save()
    {        
                PageReference pageRef;          
               
        try
        {
            SetDisplayValuesForSave();
            
            
            upsert AgencyEstimate;
            apexpages.addmessage(new apexpages.message(apexpages.severity.Confirm,'Record successfully saved'));    
           // pageRef = new PageReference('/apex/AF_CloseAndRefresh?IsError=false');
           // pageRef.setRedirect(true); 
        }
        catch(DMLException ex)
        {
            System.debug(ex);
            //ApexPages.addMessages(ex);
            pageRef = new PageReference('/apex/AF_CloseAndRefresh?IsError=true');
            pageRef.setRedirect(true);             
        }
        
        return pageRef;
    }
    public PageReference JustSave()
    {        
                PageReference pageRef;          
               
       try
        {
           // SetDisplayValues();
            //SetDisplayValuesForSave();
            CalculateTotal();
            IsEditMode=True;
            TraditionalDisplay = TraditionalDisplay.Remove(',');
            DigitalDisplay = DigitalDisplay.Remove(',');
            AdaptationDisplay = AdaptationDisplay.Remove(',');
            
            System.debug('\n Agency:'+AgencyEstimate.AF_Brand_Estimate__r.AF_CMCO_Rejected__c);
            System.debug('\n Agency:'+AgencyEstimate.AF_Brand_Estimate__r.AF_Status_Base_Fees__c);
            //if(AgencyEstimate.AF_Brand_Estimate__r.AF_CMCO_Rejected__c==true &&AgencyEstimate.AF_Brand_Estimate__r.AF_Status_Base_Fees__c == 'With Category Finance')
            if(AgencyEstimate.AF_Brand_Estimate__r.AF_Status_Base_Fees__c == 'With Category Finance' && isCatFinance==true)
            AgencyEstimate.AF_Category_Finance_Flag__c=true;
            
           
            upsert AgencyEstimate;
            
            UpdateEntityEX();
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,system.label.AF_AgencyEstimateSuccess);
            ApexPages.addMessage(myMsg);
            if(IsCentralHub)  ActivePanel='Country Breakdown';
           return null; 
        }
        catch(Exception ex)
        {
            
             String str = ex.getMessage();
             system.debug('Print the error'+str);
             if(str.contains('DMLException')){
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Record Can not be saved'));
              
             }
             else if(str.contains('NoAccessException')){
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'User does not have access'));
              
             
             }
            System.debug(ex);
           // ApexPages.addMessages(ex);
            return null;            
        }
        
        return pageRef;
    }
    
    public void UpdateEntityEX(){
     if( IsCentralHub = true){
     system.debug('inside cetrahub');
     list<AF_Entity_Exception__c>getoldetityexc=[Select id,name,AF_Country__c,AF_Agency_Estimate__c,AF_Value__c,AF_Value_Euro__c from AF_Entity_Exception__c where AF_Agency_Estimate__c=:ParentId ];
             list<AF_Entity_Exception__c>updatedenitytexception=new list<AF_Entity_Exception__c>();
               if(getoldetityexc.size()>0){
               
                for(AF_Entity_Exception__c Entity_exc1:getoldetityexc){
                if(Entity_exc1.AF_Value__c!=null){
                 Entity_exc1.AF_Value_Euro__c=Entity_exc1.AF_Value__c*TotalDisplayN/100;
                 System.debug('AF_Value_Euro__c'+Entity_exc1.AF_Value_Euro__c);
                 updatedenitytexception.add(Entity_exc1);
               }
        update updatedenitytexception;
        Wrapperlist.clear();
       TotalPercent=0;
       TotalValue=0; 
        Integer wrapperPos=-1;
       
        lst_EntityException =[Select id,name,AF_Country__c,AF_Agency_Estimate__c,AF_Value__c,AF_Value_Euro__c from AF_Entity_Exception__c where AF_Agency_Estimate__c=:ParentId ];
        if(lst_EntityException.size()>0){
        for(AF_Entity_Exception__c Entity_exc:lst_EntityException){
        wrapperPos++;
        system.debug('Entity_exc.AF_Value_Euro__c Wrapper'+Entity_exc.AF_Value_Euro__c);
        if(Entity_exc.AF_Value__c!=null){
         TotalPercent=TotalPercent+Entity_exc.AF_Value__c;
        }
       if(Entity_exc.AF_Value_Euro__c!=Null){
        TotalValue= TotalValue+Entity_exc.AF_Value_Euro__c;
        }
        Wrapperlist.add(new Entitywrapper(Entity_exc,true,wrapperPos));
        }
       
        }    
      }
    }
   }
  } 
   public void delCounrtyRecord(){
   
    system.debug('delCountryId...'+delCountryId);
    if(delCountryId!=''){
   
    AF_Entity_Exception__c delEntity = new AF_Entity_Exception__c();
    delEntity = [select Id from AF_Entity_Exception__c where Id=:delCountryId];
    delete delEntity;
    Integer counter=-1;
    for(Entitywrapper ent:Wrapperlist){
        counter++;
        if(ent.EntityEx.Id == delCountryId){
            TotalPercent = (TotalPercent - ent.EntityEx.AF_Value__c);
            TotalValue = (TotalValue - ent.EntityEx.AF_Value_Euro__c);
            break;
        }
    }
    system.debug('Wrapperlist...'+Wrapperlist.size());
    system.debug('counter....'+counter);
    Wrapperlist.remove(counter);
    }
    else{
        Integer counterWrapper=-1;
        for(Entitywrapper ent:Wrapperlist){
            counterWrapper++;
            if(ent.del == false && ent.position == posDelete){
            //TotalPercent = (TotalPercent - ent.EntityEx.AF_Value__c);
            //TotalValue = (TotalValue - ent.EntityEx.AF_Value_Euro__c);
                break;
            }
            
        }
    system.debug('counterWrapper....'+counterWrapper);
    Wrapperlist.remove(counterWrapper);
    }
    }
    public PageReference SaveEntityException()
    {
        PageReference pageRef;                         
        try
        {                       
                EntityException.AF_Agency_Estimate__c = ParentId;                               
                insert EntityException;
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,system.label.AF_EntityException);
                ApexPages.addMessage(myMsg);
                return null;
        }
        catch(DMLException ex)
        {
            System.debug(ex);
            ApexPages.addMessages(ex);
            //pageRef = new PageReference('/apex/AF_CloseAndRefresh?IsError=true');
            //pageRef.setRedirect(true);             
            pageRef = null;
        }
        return pageRef;         
    }
    
    public PageReference UpdateDisplayTotal() 
    {
        CalculateTotal();    
        return null;
    }
    public PageReference NowInEditMode()
    {
        IsEditMode=true;
        system.debug('IsEditMode:' +IsEditMode);
        return null;
    }
    
    public void CalculateTotal()
    {

       // DisplayTotal = ((TraditionalDisplay) + (DigitalDisplay) + (AdaptationDisplay));
        Double calc =  (AgencyEstimate .AF_Traditional__c + AgencyEstimate .AF_Digital__c + AgencyEstimate .AF_Adaptation__c);
        DisplayTotal = (calc.round());
        system.debug('Total value is...'+DisplayTotal );
        //DisplayTotal=calc.round();
       // DisplayTotal = DisplayTotal.setscale(2);
       // TotalDisplay = string.ValueOf(calc.round()); 
         TotalDisplayN=calc.round(); 
         
       if(AgencyEstimate.AF_Agency_Exchange_Rate__c!=null && IsReadyforPO==false){
        AgencyEstimate.AF_Digital_Local__c=AgencyEstimate.AF_Agency_Exchange_Rate__c* AgencyEstimate .AF_Digital__c;
        AgencyEstimate.AF_Traditional_Local__c= AgencyEstimate.AF_Agency_Exchange_Rate__c*AgencyEstimate .AF_Traditional__c;
        AgencyEstimate.AF_Adaptation_Local__c=AgencyEstimate.AF_Agency_Exchange_Rate__c*AgencyEstimate .AF_Adaptation__c ; 
        
        TotalLocal=AgencyEstimate.AF_Digital_Local__c+  AgencyEstimate.AF_Traditional_Local__c+ AgencyEstimate.AF_Adaptation_Local__c;
        
        }else{
            TotalLocal=AgencyEstimate.AF_Total_Local__c;
          }  
        
         
         //SetDisplayValues();
    }
    
    public PageReference Reload()
    {
        PageReference pageRef = ApexPages.currentPage();
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    public void DeleteEntityException(){
     AF_Entity_Exception__c delEntityException = new AF_Entity_Exception__c(Id=ExceptionId);
     delete delEntityException;          
    }
    
    public PageReference DeleteException()
    {
        PageReference pageRef;
        try
        {   
                //System.debug('ExceptionId : ' + ExceptionId);         
                AF_Entity_Exception__c delEntityException = new AF_Entity_Exception__c(Id=ExceptionId);
                delete delEntityException;
                pageRef = ApexPages.currentPage();
                pageRef.setRedirect(true);
        }
        catch(DMLException ex)
        {
                System.debug(ex);
            ApexPages.addMessages(ex);
            pageRef = new PageReference('/apex/AF_CloseAndRefresh?IsError=true');
            pageRef.setRedirect(true);
            pageRef = null;             
        }
         return pageRef;
    }
    
      public PageReference AddComment()
    {
        PageReference pageRef = new PageReference('/apex/AF_AddComment?Id=' + ParentId);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    //supporting classes
    public class CustomException extends Exception {}
      
      public List<SelectOption> getCountry(){
       Schema.sObjectType sobject_type = AF_Entity_Exception__c.getSObjectType();
       Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
       Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
       List<Schema.PicklistEntry> pick_list_values = field_map.get('AF_Country__c').getDescribe().getPickListValues();
          
       Countrynames = new List<SelectOption>();
       Countrynames.add(new selectoption('','--Country--'));
       /*List<AF_Entity__c> UEntity=[select id,name from AF_Entity__c where RecordType.Name =:'Unilever Entity' order By name ASC]; 
         for(AF_Entity__c UE:UEntity)
          {
              Countrynames.add(new selectoption(UE.name,UE.name));
          }
        */
          for (Schema.PicklistEntry a : pick_list_values) {
                      Countrynames.add(new selectOption(a.getValue(), a.getValue()));
          }
          return Countrynames;
    } 
    
 public void AddNewRow(){
    CalculateCountryValue();
    AF_Entity_Exception__c  entity_ex=new AF_Entity_Exception__c();
    Integer wrapperSize =  Wrapperlist.size();
     Wrapperlist.add(new Entitywrapper(entity_ex,false,wrapperSize));
    }
 Public void CalculateCountryValue(){
         TotalPercent=0;
         TotalValue=0;
         for(Entitywrapper ent_wrp:Wrapperlist){
         system.debug('Percent val...'+ent_wrp.EntityEx.AF_Value__c );
             if(ent_wrp.EntityEx.AF_Value__c!=NUll){
               
                 ent_wrp.EntityEx.AF_Value_Euro__c=TotalDisplayN*ent_wrp.EntityEx.AF_Value__c/100;
                 //ent_wrp.EntityEx.AF_Value_Euro__c= AgencyEstimate.AF_Total__c*ent_wrp.EntityEx.AF_Value__c/100;
                
                TotalPercent=TotalPercent+ent_wrp.EntityEx.AF_Value__c;
                TotalValue=TotalValue+ ent_wrp.EntityEx.AF_Value_Euro__c;
             }
         }
        }
public void SaveEntityExceptionRecords(){
    CalculateCountryValue();
    list<AF_Entity_Exception__c >updated_entity_ex=new list<AF_Entity_Exception__c>();
    decimal totalper=0;
    Integer counter=0;
    Integer counterSave=0;
    try{
        system.debug('TotalPercent'+TotalPercent);
       
        for(integer i=0;i<Wrapperlist.size();i++){
            for(integer j=i+1;j<Wrapperlist.size();j++){
            system.debug('Wrapperlist[i].EntityEx.AF_Country__c...'+Wrapperlist[i].EntityEx.AF_Country__c);
            system.debug('Wrapperlist[j].EntityEx.AF_Country__c...'+Wrapperlist[j].EntityEx.AF_Country__c);
                if(Wrapperlist[i].EntityEx.AF_Country__c == Wrapperlist[j].EntityEx.AF_Country__c){
                    counter++;
                    apexpages.addmessage(new apexpages.message(apexpages.severity.Error,'Selected country already exists'));
                }
            }
        
        }
        
        if(counter==0){
        for(Entitywrapper ent:Wrapperlist){
         AF_Entity_Exception__c  entity_ex_new=new AF_Entity_Exception__c();
         entity_ex_new.AF_Agency_Estimate__c=ParentId;
         entity_ex_new.AF_Country__c=ent.EntityEx.AF_Country__c;
         entity_ex_new.AF_Value__c=ent.EntityEx.AF_Value__c;
         entity_ex_new.AF_Value_Euro__c=ent.EntityEx.AF_Value_Euro__c;
         entity_ex_new.id=ent.EntityEx.id;
         totalper=totalper+ent.EntityEx.AF_Value__c;
         updated_entity_ex.add(entity_ex_new);
         if(ent.EntityEx.AF_Country__c==null){
                counterSave=1;
                Apexpages.addmessage(new apexpages.message(apexpages.severity.ERROR,  'Please select the country'));
             }
        }
        if(counterSave==0){
        if(!(totalper>100)){
        upsert updated_entity_ex;
        apexpages.addmessage(new apexpages.message(apexpages.severity.Confirm,'Record successfully saved')); 
        CallEntityWrapper();
        }
       
       else{
       apexpages.addmessage(new apexpages.message(apexpages.severity.Error,system.label.AF_Country_breakdown_percentage));  
       }
       
       }       
       }
       
    }
    Catch(exception ex){
    
   }
}     
  public class Entitywrapper{
    public AF_Entity_Exception__c EntityEx{get;set;}
    public Boolean Del{get;set;}
    public Integer position{get;set;}
    public Entitywrapper(AF_Entity_Exception__c EntityEx,Boolean Del,Integer pos){
    this.EntityEx=EntityEx;
    this.Del = Del;
    this.position = pos;
    
    }
    }
 
}