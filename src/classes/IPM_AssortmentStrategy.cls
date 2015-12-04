/****************************************************************************************************
* @author:Cognizant
* @date:23/02/2015
* @description:Assortment Strategy by local project country level and filled in gate document section
*/
public with sharing class IPM_AssortmentStrategy {
    /****************************************************************************************************
    * @description:get selected distribution type
    */
    public Set<String> channelNameSet{get; set;}
    public string DistributionType{get;set;}
    public Map<string,List<IPM_Project_Document_Section_Content__c>> assotmentMap{get; set;}
    /****************************************************************************************************
    * @description:get Customer Channels names
    */
    public transient List<String> Names{get; set;}
    public Integer deletedPriority;
    /****************************************************************************************************
    * @description:get list of customer channels and country mapping
    */
    public transient list<mdm_CU_Sales_SKU_Count_Mapping__c>ipmCUslst{get;set;}
    /****************************************************************************************************
    * @description:get selected customer channels From UI
    */
    public String channelName{get; set;}
    /****************************************************************************************************
    * @description:set of selected channels name
    */
    public transient set<string>setchannelName{get;set;}
    /****************************************************************************************************
    * @description:get selected CUs name
    */
    public string selectedCUsNames{get;set;}
    /****************************************************************************************************
    * @description:set all selected CUs name
    */
    public transient set<string>setselectedCUsNames{get;set;}
    /****************************************************************************************************
    * @description:Used in update CCRT section records
    */
    public IPM_Project_Document_Section_Content__c IPMProdocContent{get;set;}
    /****************************************************************************************************
    * @description:list assortment strategy records
    */
    public transient list<IPM_Project_Document_Section_Content__c>lstAssortStrategy{get;set;}
    /****************************************************************************************************
    * @description:hold set of unique assortment id
    */
    public transient set<string>setAssortStrategy{get;set;}
    /****************************************************************************************************
    * @description:get assortment id to be delete
    */
    public string selecteAssortTodelete{get;set;}
    /****************************************************************************************************
    * @description:get assort name to be delete
    */
    public string selecteAssortName{get;set;}
    /****************************************************************************************************
    * @description:hold target of assortment strategy
    */
    public string AssortTarget{get;set;}
    /****************************************************************************************************
    * @description:assign priority of assortment strategy
    */
    public string AssortPriority{get;set;}
    public Map<String,Integer> assortPriorityMap{get; set;}
    /****************************************************************************************************
    * @description:hold project document section id
    */
    public Id ProdocSecId;
    /****************************************************************************************************
    * @description:get project document section id
    * @param:
    * @return:project document section id
    */
    public ID getProdocSecId(){ return ProdocSecId; }
    public Integer priorityNumber{get; set;} // integer to store the priority Number
    public Integer countCU{get; set;}
   
    public Id secConId{get; set;}// to store the section Content Id
    /****************************************************************************************************
    * @description:checking whether current logged in user has permission to edit assortment strategy section
    */
    public boolean isEditable{get;set;}
    
    public string priorityCU{get; set;}
    public string arrow{get; set;} // string to store the priority arrow
     
    private static final String IPM_ASSORTMENTSTRATEGY_STR= IPM_AssortmentStrategy.class.getName();
    private static  final String CREATEASSORTSTRATEGY='createAssortStrategy';
    private static  final String DLTALLASSORT='DltAllAssort';
    private static  final String UPDATEASSORTS='updateAssortS';
    private static  final String CHANGE_PRIORITY_STR='changePriority';
    private static  final String UPDATE_PRIORITY_STR='updatePriority';
    private static  final String ERROR='Error';
    /****************************************************************************************************
    * @description:get project document section details
    * @param:project document section id
    * @return:
    */
    public void setProdocSecId (ID p){
        ProdocSecId= p;
        getAssortStrategy();
    }
    
    /****************************************************************************************************
    * @description:constructor of the class,initialise of variables and get customer channels name
    * @param:
    * @return:
    */
    public IPM_AssortmentStrategy (){
        DistributionType='';
        selectedCUsNames='';
        selecteAssortName='';
        AssortTarget='';
        AssortPriority='';
        isEditable=false;
        setselectedCUsNames=new set<string>();
        setchannelName=new set<string>();
        IPMProdocContent=new IPM_Project_Document_Section_Content__c();
        selecteAssortTodelete='';
        
        getCChannelsNames();
        getCUs();
        getAssortStrategy();
        
    }
    /****************************************************************************************************
    * @description:Get list of customer channels names
    * @param:
    * @return:
    */
    public void getCChannelsNames(){
        Names=new List<String>();
        Schema.DescribeFieldResult fieldResult = IPM_Project_Document_Section_Content__c.IPM_Assort_Channel_Name__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple){
            Names.add(f.getValue());
        }    
    }
    /****************************************************************************************************
    * @description:Get CUs country related list
    * @param:
    * @return:
    */
    public void getCUs(){
        ipmCUslst=new list<mdm_CU_Sales_SKU_Count_Mapping__c>();
        String projectId=Apexpages.currentpage().getparameters().get(IPM_ConstantUtils.SF_ID);
        list<IPM_Country__c> ipmlocalCountry=[Select Country_Name__c From IPM_Country__c Where 
        IPM_Local_Project__c=:projectId and IPM_Local_Project__c!=null limit 1];
        
        if(!ipmlocalCountry.isEmpty())
        {
            ipmCUslst=[Select CU_Description__c,name,Country__c From mdm_CU_Sales_SKU_Count_Mapping__c 
            Where Country__c=:ipmlocalCountry[0].Country_Name__c limit 50000];
        }
    }
    /****************************************************************************************************
    * @description:get all selected customer channels
    * @param:
    * @return:
    */
    public void HoldCustomesChannels()
    {
        String[] CName=channelName.split(',');
        
        for(Integer i=0;i<CName.size();i++)
        {
            setchannelName.add(CName[i]);
        }   
    }
    /****************************************************************************************************
    * @description:get selected all CUs based on country
    * @param:
    * @return:
    */
    public void HoldCUsNames()
    {
        String[] CuName= selectedCUsNames.split(',');
        for(Integer i=0;i<CuName.size();i++)
        {
            setselectedCUsNames.add(CuName[i]);
        }   
    }
    /****************************************************************************************************
    * @description:create assortment strategy
    * @param:
    * @return:
    */
    public void createAssortStrategy(){
        list<IPM_Project_Document_Section_Content__c>lstProDocContent=new list<IPM_Project_Document_Section_Content__c>();
        IPM_Project_Document_Section_Content__c ProdocCon=new IPM_Project_Document_Section_Content__c();
        Integer countAssort=0; 
        if(String.isBlank(channelName)){
            for(IPM_Project_Document_Section_Content__c  AssortS:lstAssortStrategy){
                if(String.isBlank(channelName)){
                    channelName=AssortS.IPM_Assort_Channel_Name__c;
                }
                else{
                    if(!channelName.contains(AssortS.IPM_Assort_Channel_Name__c)){
                        channelName=channelName+','+AssortS.IPM_Assort_Channel_Name__c;
                        ++countAssort;
                    }   
                }
            }    
        }
        String[] CName=new List<String>();
        CName=(channelName).split(',');
        for(Integer i=0;i<CName.size();i++){
            if(CName[i]!=null && String.isNotBlank(CName[i])) {
				setchannelName.add(CName[i]);
			}
        }  
        
        String[] CusName=new List<String>();
        CusName=(selectedCUsNames).split(';');
        for(Integer i=0;i<CusName.size();i++){
            if(CusName[i]!=null && String.isNotBlank(CusName[i])) {
				setselectedCUsNames.add(CusName[i]);
			}
        }  

        if(setselectedCUsNames!=null && setselectedCUsNames.size()>0&& setchannelName!=null && setchannelName.size()>0){
            for(string cu:setselectedCUsNames){
              ++countAssort;
                for(string cuname:setchannelName){
                    boolean isdupval=false;
                    for(IPM_Project_Document_Section_Content__c dupcus:lstAssortStrategy){
                        if(dupcus.IPM_Incumbent_CUs__c.equalsIgnoreCase(cu) && dupcus.IPM_Assort_Channel_Name__c.equalsIgnoreCase(cuname)){
                            isdupval=true;
                            break;
                        } 
                    }
                    if(isdupval != null && !isdupval){
                        ProdocCon=new IPM_Project_Document_Section_Content__c();
                        ProdocCon.IPM_Content_Type__c = IPM_ConstantUtils.ASSORTMENT_CONTENT_TYPE;
                        ProdocCon.IPM_Incumbent_CUs__c=cu;
                        ProdocCon.IPM_Assort_Channel_Name__c=cuname;
                        ProdocCon.IPM_AssortmentStrategy_From__c=IPMProdocContent.IPM_AssortmentStrategy_From__c;
                        ProdocCon.IPM_AssortmentStrategy_To__c=IPMProdocContent.IPM_AssortmentStrategy_To__c;
                        ProdocCon.IPM_Distribution_Type__c=DistributionType;
                        ProdocCon.IPM_Project_Document_Section__c=ProdocSecId;
                        ProdocCon.IPM_Assortment_CU_Priority__c=countAssort;
                        lstProDocContent.add(ProdocCon);
                    }
                }
            }
			if(insertAssortList!=null && !insertAssortList.isEmpty()){
				insert insertAssortList;
			}                           
        }
        catch(DmlException ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_ASSORTMENTSTRATEGY_STR,
                CREATEASSORTSTRATEGY,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
            }
            catch(exception eX){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
                ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_ASSORTMENTSTRATEGY_STR,
                CREATEASSORTSTRATEGY,ex.getMessage(),ex, ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION); 
            }
            getAssortStrategy();
        }
    }
    /****************************************************************************************************
    * @description:get already created assortment strategy
    * @param:
    * @return:
    */
    public void getAssortStrategy(){
        lstAssortStrategy=new list<IPM_Project_Document_Section_Content__c>();
        setAssortStrategy=new set<string>();
        channelNameSet=new set<string>();
        setselectedCUsNames=new set<string>();
        setchannelName=new set<string>();
        assortPriorityMap=new Map<String,Integer>();
        lstAssortStrategy=[Select IPM_Assortment_Cus__c,IPM_Assortment_CU_Priority__c,IPM_Customer_Channel_Priority__c,IPM_Incumbent_CUs__c,IPM_Assortment_Strategy_Priority__c,IPM_Assortment_strategy_Target__c,IPM_Assort_Channel_Name__c,IPM_AssortmentStrategy_From__c,
        IPM_AssortmentStrategy_To__c,IPM_Distribution_Type__c,IPM_Project_Document_Section__c 
        From IPM_Project_Document_Section_Content__c Where IPM_Project_Document_Section__c=:ProdocSecId order by IPM_Assortment_CU_Priority__c asc];
        if(lstAssortStrategy!=null && !lstAssortStrategy.isEmpty()){        
            IPMProdocContent.IPM_AssortmentStrategy_From__c=lstAssortStrategy[0].IPM_AssortmentStrategy_From__c;
            IPMProdocContent.IPM_AssortmentStrategy_To__c=lstAssortStrategy[0].IPM_AssortmentStrategy_To__c;
            DistributionType=lstAssortStrategy[0].IPM_Distribution_Type__c;
            
        }   
        for(IPM_Project_Document_Section_Content__c  AssortS:lstAssortStrategy){
            setAssortStrategy.add(AssortS.IPM_Incumbent_CUs__c);
            channelNameSet.add(AssortS.IPM_Assort_Channel_Name__c);
            assortPriorityMap.put(AssortS.IPM_Incumbent_CUs__c,(Integer)AssortS.IPM_Assortment_CU_Priority__c);
            if(String.isBlank(channelName)){
                channelName=AssortS.IPM_Assort_Channel_Name__c;
            }
            else{
                if(!channelName.contains(AssortS.IPM_Assort_Channel_Name__c)){
                    channelName=channelName+','+AssortS.IPM_Assort_Channel_Name__c;
                }   
            }            
        } 
        List<IPM_Project_Document_Section_Content__c> appendList;
        assotmentMap=new Map<string,List<IPM_Project_Document_Section_Content__c>>();
        //For Displaying Appendix
        for(string assortm:setAssortStrategy){
            appendList=new List<IPM_Project_Document_Section_Content__c>();
            for(IPM_Project_Document_Section_Content__c  Assortc:lstAssortStrategy){
                if(Assortc.IPM_Incumbent_CUs__c==assortm){
                    appendList.add(Assortc);
                }
            }
            assotmentMap.put(assortm,appendList);
        }
    countCU=assortPriorityMap.size();        
    }
    /****************************************************************************************************
    * @description:Delete all record related to assortment header
    * @param:
    * @return:
    */
    public void DltAllAssort(){
        list<IPM_Project_Document_Section_Content__c> dltAllAssortS=[Select id,IPM_Assortment_CU_Priority__c From IPM_Project_Document_Section_Content__c Where
        IPM_Incumbent_CUs__c=:selecteAssortName and IPM_Project_Document_Section__c=:ProdocSecId limit 50000];
        try{
            if(dltAllAssortS!=null && dltAllAssortS.size()>0){
                deletedPriority=(Integer)dltAllAssortS[0].IPM_Assortment_CU_Priority__c;
                delete dltAllAssortS;    
            }
        }
        catch(DmlException ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_ASSORTMENTSTRATEGY_STR,
            DLTALLASSORT,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
        }
        catch(exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_ASSORTMENTSTRATEGY_STR,
            DLTALLASSORT,ex.getMessage(),ex, ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION); 
        }
        updatePriority(deletedPriority);
        getAssortStrategy();
    }
    /****************************************************************************************************
    * @description:Update assortment strategy record with priority
    * @param:
    * @return:
    */
    public void updateAssortS(){
        IPM_Project_Document_Section_Content__c updateAssort=new IPM_Project_Document_Section_Content__c();
        updateAssort=[SELECT IPM_Assortment_Strategy_Priority__c FROM IPM_Project_Document_Section_Content__c WHERE id=:selecteAssortTodelete limit 1];
        if(String.isNotBlank(AssortPriority)){
            updateAssort.IPM_Assortment_Strategy_Priority__c=AssortPriority;
        }
        if(String.isNotBlank(AssortTarget)){
            updateAssort.IPM_Assortment_strategy_Target__c=AssortTarget;
        }
        try{
            if(updateAssort!=null) {
				update updateAssort;   
			}
        }
        catch(DmlException ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_ASSORTMENTSTRATEGY_STR,
            UPDATEASSORTS,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
        }
        catch(exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_ASSORTMENTSTRATEGY_STR,
            UPDATEASSORTS,ex.getMessage(),ex, ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION); 
        }
        getAssortStrategy();    
    }
    
    
     /************************************************************************************************************************
    *  Description To change the customer channel section priority
    *  @name changePriority
    *  @param none
    *  @return void
    *  @throws dml exception
    */
    public void changePriority(){
        try{
          Integer pNumeber=(Integer) priorityNumber;
          if(arrow=='up'){
            pNumeber=pNumeber-1;
          }
          else if(arrow=='down'){
            pNumeber=pNumeber+1;
          }
            List<IPM_Project_Document_Section_Content__c> newPriorityList=new List<IPM_Project_Document_Section_Content__c>();
            List<IPM_Project_Document_Section_Content__c> oldPriorityList=new List<IPM_Project_Document_Section_Content__c>();
            newPriorityList=[SELECT Id,IPM_Incumbent_CUs__c,IPM_Assortment_CU_Priority__c FROM IPM_Project_Document_Section_Content__c 
                     WHERE IPM_Incumbent_CUs__c=:priorityCU AND IPM_Project_Document_Section__c=:ProdocSecId];
           oldPriorityList=[SELECT Id,IPM_Incumbent_CUs__c,IPM_Assortment_CU_Priority__c FROM IPM_Project_Document_Section_Content__c 
                     WHERE IPM_Project_Document_Section__c=:ProdocSecId AND IPM_Assortment_CU_Priority__c=:pNumeber];
           for(IPM_Project_Document_Section_Content__c newPriority:newPriorityList){
               newPriority.IPM_Assortment_CU_Priority__c=pNumeber;
           }  
           update newPriorityList;
           
           for(IPM_Project_Document_Section_Content__c oldPriority:oldPriorityList){
               if(arrow=='down'){
                 oldPriority.IPM_Assortment_CU_Priority__c=pNumeber-1;
               }
               else{
                 oldPriority.IPM_Assortment_CU_Priority__c=pNumeber+1;  
               }
               
           }
	if(oldPriorityList!=null && !oldPriorityList.isEmpty()){ 
           update oldPriorityList;  
	 }
           getAssortStrategy();         
        }
        catch (QueryException ex) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_ASSORTMENTSTRATEGY_STR,
            CHANGE_PRIORITY_STR,ex.getMessage(),ex, ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
        }
        catch (DMLException ex) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_ASSORTMENTSTRATEGY_STR,
            UPDATEASSORTS,ex.getMessage(),ex, ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
        }
    }
    
    public void updatePriority(Integer delPriority){
        try{
            List<IPM_Project_Document_Section_Content__c> newPriorityList=new List<IPM_Project_Document_Section_Content__c>();
            newPriorityList=[SELECT Id,IPM_Incumbent_CUs__c,IPM_Assortment_CU_Priority__c FROM IPM_Project_Document_Section_Content__c 
                             WHERE IPM_Project_Document_Section__c=:ProdocSecId AND IPM_Assortment_CU_Priority__c>:delPriority];
            for(IPM_Project_Document_Section_Content__c newPriority:newPriorityList){
               newPriority.IPM_Assortment_CU_Priority__c=(Integer)newPriority.IPM_Assortment_CU_Priority__c-1;
            }  
            update newPriorityList;     
        }
        catch (DMLException ex) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_ASSORTMENTSTRATEGY_STR,
            UPDATEASSORTS,ex.getMessage(),ex, ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
        }   
    }    
}