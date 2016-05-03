/*****************************************************************
@Description : Used for IMP central team to create company card
@Created Date-FEBRUARY 2015
@Author: Cognizant
@Referenced:IPM_CompanyCard visual force page
*******************************************************************/

public with sharing class IPM_CompanyCard {

    public IPM_Company_Card__c IPMCompanyCard{get;set;}//Company Card object variable
    public list<selectoption> lstRegion{get;set;}//Used in VF page for picklist options
    public list<selectoption> lstUnileverCluster{get;set;}//Used in VF page for picklist options
    public list<selectoption> lstCountryCluster{get;set;}//Used in VF page for picklist options
    public list<selectoption> lstISOCountryDependencyName {get;set;}//Used in VF page for picklist options
    public list<selectoption> lstManCat{get;set;}//Used in VF page for picklist options
    public string selectedCountryCluster{get;set;}//Used to store selected country cluster
    public list<string> selectedISOCountryDependencyName{get;set;}//list of selected country dependency name
    public string oneUnileverCluster{get;set;}// Used to store market cluster value
    public string ccRecordType{get;set;}// Used to store company card record type
    public id globalRid{get;set;} // Used for global company card record type id
    public id regionalRid{get;set;} // Used for regional company card record type id
    public id localRid{get;set;}// Used for local company card record type id
    public string ccid{get;set;} // Used for company card id
    public boolean managedErrMsg{get;set;}// True we don't select managed catagory at global or regional
    public boolean managedErrMsgLocal{get;set;}// True we don't select managed catagory at local
    public string selectedManagedCatagory{get;set;} // Used to store selected managed catagory
    public IPM_CompanyCard__c ipmCompanyConfig{get;set;}//company card configuration
    public List<selectoption>companyCardTypeList{get;set;}//list of company card type
    public static final string CLASSNAME=IPM_CompanyCard.class.getName();
    public boolean isEditable{get;set;}//edit access on vf page
    public boolean duplicateCCName{get;set;}//duplicate companycard name
    private static final string SAVEMETHOD='SaveCC';//save method
    @TestVisible private set<string>countryClusterSet=new set<string>();//set of country cluster
    @TestVisible private  set<string>isoCountryDependencyNameSet=new set<string>();//set of country name
    public boolean isGeoScopeLocal{get;set;}//check validation for local company card
    public boolean isMcoLocal {get;set;}//check validation for local company card
    public boolean isMarketClusterLocal {get;set;}//check validation for local company card
    public boolean isMarketClusterRegional {get;set;}//check validation for regional company card
    
        
    /*****************************************************************
    @Description:Standard Controller
    *******************************************************************/
    public IPM_CompanyCard (){
        initialise();//call method to initialise all required data
        getUserAccess();//call method for security
        
   }
   /*****************************************************************
    @Description: Used for IMP central team to create company card
    *******************************************************************/
   @Testvisible private void initialise(){
        globalRid=null;
        regionalRid=null;
        localRid=null;
        isEditable=false;
        duplicateCCName=false;
        ccRecordType=IPM_ConstantUtils.BLANK;
        oneUnileverCluster=IPM_ConstantUtils.BLANK;
        managedErrMsg=false;
        isGeoScopeLocal = false;
        isMcoLocal =false;
        isMarketClusterLocal=false;
        isMarketClusterRegional =false;
        managedErrMsgLocal=false;
        ipmCompanyConfig=new IPM_CompanyCard__c();
        IPMCompanyCard=new IPM_Company_Card__c ();
        ccid= ApexPages.currentPage().getParameters().get(IPM_ConstantUtils.SF_ID);
        lstUnileverCluster = new list<selectoption>();
        lstCountryCluster= new list<selectoption>();
        lstISOCountryDependencyName = new list<selectoption>();
        companyCardTypeList=new List<selectoption>();
        selectedISOCountryDependencyName=new list<string>();
        lstRegion=new list<selectoption>();
        recordTypeinfo();
        if(string.isNotBlank(ccid)){
            IPMCompanyCard=[SELECT name,IPM_TxtGeographical_Scope__c,RecordTypeId,
                            IPM_Market_Cluster__c,IPM_MCO__c,IPM_Managed_Category__c FROM IPM_Company_Card__c  WHERE id=:CCid LIMIT 1];
            list<RecordType>ccRecordTypeList=new list<RecordType>();
            ccRecordTypeList=[SELECT ID, Name FROM RecordType WHERE id =:IPMCompanyCard.RecordTypeId LIMIT 1];
            if(!ccRecordTypeList.isEmpty()){
                ccRecordType=ccRecordTypeList[0].Name.Substringbefore(IPM_ConstantUtils.IPM_SPACE);
            }
            selectedManagedCatagory=IPMCompanyCard.IPM_Managed_Category__c;
            if(IPM_ConstantUtils.CC_RECORD_TYPE_REGIONAL.equals(ccRecordType)){
                oneUnileverCluster=IPMCompanyCard.IPM_TxtGeographical_Scope__c;
            }
            if(ccRecordType.equals(IPM_ConstantUtils.CC_RECORD_TYPE_LOCAL)){
                oneUnileverCluster=IPMCompanyCard.IPM_Market_Cluster__c;
                selectedCountryCluster=IPMCompanyCard.IPM_MCO__c ;
            }
            if(ccRecordType.equals(IPM_ConstantUtils.CC_RECORD_TYPE_LOCAL) && IPMCompanyCard.IPM_TxtGeographical_Scope__c!=null){
                list<String>selectedcountryList=IPMCompanyCard.IPM_TxtGeographical_Scope__c.split(IPM_ConstantUtils.SEMICOLON);
                SelectedISOCountryDependencyName=selectedcountryList;
            }
            showDropdown();//Call this method to get values related to selected company card(like Global company card)
        }
        Schema.DescribeFieldResult statusFieldDescription = IPM_Company_Card__c.IPM_Managed_Category__c.getDescribe();
        lstManCat = new list<SelectOption>();
        lstManCat.add(new Selectoption(IPM_ConstantUtils.BLANK,system.label.IPM_Select_Category));
        for (Schema.Picklistentry picklistEntry : statusFieldDescription.getPicklistValues()){
            lstManCat.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
        }
        onRegionSelection();
        onUnileverClusterSelection();
        onCountryClusterSelection();    
        
   }
   /*****************************************************************
    @Description: get all company card record types
    *******************************************************************/
   @Testvisible private void recordTypeinfo(){
        list<RecordType>RType=[SELECT ID, Name FROM RecordType WHERE sObjectType =:IPM_ConstantUtils.COMPANY_CARD_OBJECT Order By Name LIMIT 1000];
        companyCardTypeList.add(new selectoption(IPM_ConstantUtils.BLANK,system.label.IPM_select_company_card_type));
        for(RecordType rt:RType){
            if(IPM_ConstantUtils.COMPANY_CARD_RECORD_TYPE_GLOBAL.equals(rt.Name)){
                GlobalRid=rt.id;
            }
            if(IPM_ConstantUtils.COMPANY_CARD_RECORD_TYPE_REGIONAL.equals(rt.Name)){
                RegionalRid=rt.id;
            }
            if(IPM_ConstantUtils.COMPANY_CARD_RECORD_TYPE_LOCAL.equals(rt.Name)){
                LocalRid=rt.id;
            }
            companyCardTypeList.add(new selectoption(rt.Name.substringBefore(IPM_ConstantUtils.IPM_SPACE),rt.Name.substringBefore(IPM_ConstantUtils.IPM_SPACE)));
        }
   
   }
    /*****************************************************************
    @Description:Get all unilever cluster list
    @Return: String
    *******************************************************************/
    
    public String onRegionSelection() {
        list<MDO_Geography__c>geolist=[SELECT id,Name,mdm_id__c 
                                       FROM MDO_Geography__c WHERE geography_type__c=:IPM_ConstantUtils.UNILIVER_CLUSTER 
                                       AND Status__c =:IPM_ConstantUtils.STRING_STATUS_ACTIVE  LIMIT 1000];
        lstUnileverCluster = new list<selectoption>();
        lstUnileverCluster.add(new selectoption(IPM_ConstantUtils.BLANK,system.label.IPM_SELECT_UNILEVER_CLUSTER));
        set<string>unileverClusterSet=new set<string>();
        for(MDO_Geography__c getCluster:geolist){
            if(!unileverClusterSet.contains(getCluster.Name)){
                lstUnileverCluster.add(new selectoption(getCluster.Name,getCluster.Name));
                unileverClusterSet.add(getCluster.Name);
            }
        }
        return null;
    }
    
    /*****************************************************************
    @Description:Get all MCO list based on selection
    @Return: String
    *******************************************************************/
    
    public String onUnileverClusterSelection() {
        if(string.isNotBlank(OneUnileverCluster)){
            list<MDO_Geography__c>geolist=[SELECT id,Name FROM MDO_Geography__c WHERE parent_id__r.Name=:OneUnileverCluster 
                                            AND geography_type__c=:IPM_ConstantUtils.COUNTRY_CLUSTER 
                                            AND Status__c =:IPM_ConstantUtils.STRING_STATUS_ACTIVE LIMIT 1000];
            lstCountryCluster= new list<selectoption>();
            countryClusterSet=new set<string>();
            lstCountryCluster.add(new selectoption(IPM_ConstantUtils.BLANK,system.label.IPM_SELECT_COUNTRY_CLUSTER));
            for(MDO_Geography__c getCluster:geolist){
                if(!countryClusterSet.contains(getCluster.Name)){
                    lstCountryCluster.add(new selectoption(getCluster.Name,getCluster.Name));
                    countryClusterSet.add(getCluster.Name);
                }
                
            }
        }
        return null;
        
    }
    
    
    /*****************************************************************
    @Description:get all country name based on MCO selection
    @Return: String
    *******************************************************************/
    
    public String onCountryClusterSelection() {
        if(String.isNotBlank(selectedCountryCluster)){
            list<MDO_Geography__c>geolist=[Select id,Name FROM MDO_Geography__c WHERE parent_L2__r.Name=:selectedCountryCluster 
                                            AND geography_type__c=:IPM_ConstantUtils.IPM_GEOGRAPHY_COUNTRY
                                            AND Status__c =:IPM_ConstantUtils.STRING_STATUS_ACTIVE LIMIT 1000];
            lstISOCountryDependencyName = new list<selectoption>();
            isoCountryDependencyNameSet=new set<string>();
            for(MDO_Geography__c getISOCountryDepName:geolist){
                if(!isoCountryDependencyNameSet.contains(getISOCountryDepName.Name)){
                    lstISOCountryDependencyName.add(new selectoption(getISOCountryDepName.Name,getISOCountryDepName.Name));
                    isoCountryDependencyNameSet.add(getISOCountryDepName.Name );
                }
               
            }
         }
           
            return null;
    }
    
    /*****************************************************************
    @Description:Company card type selection
    *******************************************************************/
    
    public void showDropdown() {
        ipmCompanyConfig=IPM_CompanyCard__c.getinstance(ccRecordType);
        isGeoScopeLocal = false;
        isMcoLocal =false;
        isMarketClusterLocal=false;
        isMarketClusterRegional =false;
        
    }
    
    /*****************************************************************
    @Description:SelectedManagedCatagory setter
    @Return:string
    *******************************************************************/
    public String getSelectedManagedCatagory() {
        return selectedManagedCatagory;
    }
    
    /*****************************************************************
    @Description:save the company card and goto standard company card page
    @Return: Page Reference
    *******************************************************************/
    
    public PageReference SaveCC(){
        isGeoScopeLocal = false;
        isMcoLocal =false;
        isMarketClusterLocal=false;
        isMarketClusterRegional =false;
        
        
        if(ccRecordType.equals(IPM_ConstantUtils.CC_RECORD_TYPE_GLOBAL)) {
            IPMCompanyCard.IPM_TxtGeographical_Scope__c=ccRecordType;
            IPMCompanyCard.RecordTypeId =GlobalRid;
            IPMCompanyCard.IPM_Managed_Category__c=selectedManagedCatagory;
            IPMCompanyCard.IPM_Market_Cluster__c=null;
            IPMCompanyCard.IPM_MCO__c=null;
        }
        
        //GeoScope has to mandatory 
        else if(ccRecordType.equals(IPM_ConstantUtils.CC_RECORD_TYPE_REGIONAL) ){
            
            if(string.isBlank(OneUnileverCluster))
            {
                isMarketClusterRegional=true;
            }
            else{
                IPMCompanyCard.IPM_TxtGeographical_Scope__c=OneUnileverCluster;
                IPMCompanyCard.RecordTypeId =RegionalRid;
                IPMCompanyCard.IPM_Managed_Category__c=selectedManagedCatagory;
                IPMCompanyCard.IPM_Market_Cluster__c=null;
                IPMCompanyCard.IPM_MCO__c=null;
            }
        }
        //MarketCluster, MCO, GeoScope has to Mandatory 
        else if(ccRecordType.equals(IPM_ConstantUtils.CC_RECORD_TYPE_LOCAL)){
            if(IPMCompanyCard.IPM_Managed_Category__c==null){
                managedErrMsgLocal=true;
            }
            else{
                managedErrMsgLocal=false;
            }
            
            string uCountryName=IPM_ConstantUtils.BLANK;
            for(string countryname:SelectedISOCountryDependencyName){
                uCountryName=uCountryName+countryname+IPM_ConstantUtils.SEMICOLON;
            }
                IPMCompanyCard.IPM_TxtGeographical_Scope__c=uCountryName;
                IPMCompanyCard.RecordTypeId =LocalRid;  
                IPMCompanyCard.IPM_Market_Cluster__c=oneUnileverCluster;
                IPMCompanyCard.IPM_MCO__c=selectedCountryCluster;
            
                if(string.isBlank(uCountryName)){
                    isGeoScopeLocal = true;
                }
                if(string.isBlank(oneUnileverCluster)){
                    isMarketClusterLocal=true;
                }
                if(string.isBlank(selectedCountryCluster)){
                    isMcoLocal =true;
                }
            
        }
        
        if(!ccRecordType.equals(IPM_ConstantUtils.CC_RECORD_TYPE_LOCAL)){
            if(String.isBlank(selectedManagedCatagory)){
                managedErrMsg=true;
            }
            else{
                managedErrMsg=false;
            }
        }
        if(IPMCompanyCard.name!=null){
            duplicateCCName=IPM_WithoutShareController.duplicateCompanyCard(IPMCompanyCard.id,IPMCompanyCard.name); 
        }
        
        if(managedErrMsg || managedErrMsgLocal || duplicateCCName || isGeoScopeLocal || isMarketClusterLocal || isMcoLocal || isMarketClusterRegional){
            return null;
        } 
        try{
            
            upsert IPMCompanyCard;
            return new PageReference(IPM_ConstantUtils.IPM_BACKSLASH+IPMCompanyCard.id);
            
        }
        catch(DMLexception ex){
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASSNAME,
                            SAVEMETHOD,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,system.label.IPM_System_Admin));
            return null;
        }
        catch(exception ex){
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASSNAME,
            SAVEMETHOD,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,system.label.IPM_System_Admin));
            return null;
        } 
    }
    /*****************************************************************
    @Description:get edit or create access for company card
    @Return: null
    *******************************************************************/
    @TestVisible private void getUserAccess(){
        //security for IDC users
        String myProflieName=IPM_ConstantUtils.BLANK;
        List<Profile> profile_List = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        if(!profile_List.isEmpty()){
            myProflieName = profile_List[0].Name;   
        }
        if(string.isNotblank(myProflieName) && myProflieName.equals(IPM_ConstantUtils.PERMISSION_SYSTEM_ADMINISTRATOR)){
            isEditable=true;
        }
        if(!isEditable){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info,system.label.IPM_No_permission_on_page));    
        }
    
    }
}