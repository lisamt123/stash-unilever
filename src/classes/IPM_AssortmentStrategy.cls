/****************************************************************************************************************************
@Author: Cognizant
@Name: IPM_AssortmentStrategy
@Created Date: 23/02/2015
@Description: Assortment Strategy by local project country level and filled in gate document section
@Version: 1.0
@Reference: Project Document Section Editor Page
*/
public with sharing class IPM_AssortmentStrategy {
    private static final String IPM_ASSORTMENTSTRATEGY_STR= IPM_AssortmentStrategy.class.getName();
    private static final String CREATEASSORTSTRATEGY_STR='createAssortStrategy';
    private static final String DLTALLASSORT_STR='dltAllAssort';
    private static final String UPDATEASSORTS_STR='updateAssortS';
    private static final String CHANGE_PRIORITY_STR='changePriority';
    private static final String UPDATE_PRIORITY_STR='updatePriority';
    private static final String GETASSORTSTRATEGY_STR='getAssortStrategy';
    private static final String ERROR='Error';
    //Initializing Variables
    public Id prodocSecId; //For Project Document Section Id
    public Integer deletedPriority; //For getting deleted priority
    public Set<String> channelNameSet{get; set;} //Customer Channel Name Set 
    public string distributionType{get;set;} //Getting Distribution type
    public Map<string,List<IPM_Project_Document_Section_Content__c>> assotmentMap{get; set;} //For getting assortment list
    public List<String> Names{get; set;} //For Checkbox in UI
    public String channelName{get; set;} //Customer Channel Name
    public set<string>setchannelName{get;set;} //Customer Channel Name Set 
    public string selectedCUsNames{get;set;} //Contains Select CU Name
    public set<string>setselectedCUsNames{get;set;} //Contains Select CU Name Set
    public IPM_Project_Document_Section_Content__c ipmProdocContent{get;set;} //For Getting Content
    public list<IPM_Project_Document_Section_Content__c>lstAssortStrategy{get;set;} //For Getting List of Assortment Strategies
    public set<string>setAssortStrategy{get;set;} //For Getting Set of Assortment Strategies
    public string selecteAssort{get;set;} //Selected Assort for Update
    public string selecteAssortName{get;set;}  //Selected Assort Name for Update
    public string assortTarget{get;set;} //Assortment Target value
    public string assortPriority{get;set;} //Assortment Priority
    public Map<String,Integer> assortPriorityMap{get; set;} //List of Contents associated with channel
    public ID getProdocSecId(){ return prodocSecId; } //Project Document Section Id
    public Integer priorityNumber{get; set;} // integer to store the priority Number
    public Integer countCU{get; set;} //Number of CUs
    public Id secConId{get; set;}// to store the section Content Id
    public Boolean isEditable{get;set;} //Variable for Readonly 
    public Boolean isTarget{get; set;} //For checking updating target or not
    public string priorityCU{get; set;} //For updating priority
    public string arrow{get; set;} // string to store the priority arrow
    
    /************************************************************************************************************************
    * @name setProdocSecId
    * @description Get project document section details
    * @param project document section id
    * @return void
    */
    public void setProdocSecId (ID p){
        prodocSecId= p;
        getAssortStrategy();
    }
    
    /************************************************************************************************************************
    * @description:constructor of the class,initialise of variables and get customer channels name
    */
    public IPM_AssortmentStrategy (){
        distributionType=IPM_ConstantUtils.BLANK;
        selectedCUsNames=IPM_ConstantUtils.BLANK;
        selecteAssortName=IPM_ConstantUtils.BLANK;
        assortTarget=IPM_ConstantUtils.BLANK;
        assortPriority=IPM_ConstantUtils.BLANK;
        isEditable=false;
        setselectedCUsNames=new set<string>();
        setchannelName=new set<string>();
        ipmProdocContent=new IPM_Project_Document_Section_Content__c();
        selecteAssort=IPM_ConstantUtils.BLANK;
        isTarget=false;
        getCChannelsNames();
        getAssortStrategy();
    }

    /************************************************************************************************************************
    *  @Description Getting list of customer channels names 
    *  @name getCChannelsNames
    *  @param none
    *  @return void
    */
    public void getCChannelsNames(){
        Names=new List<String>();
        Schema.DescribeFieldResult fieldResult = IPM_Project_Document_Section_Content__c.IPM_Assort_Channel_Name__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple){
            Names.add(f.getValue());
        }    
    }

    /************************************************************************************************************************
    *  Description For caprturing customer channels 
    *  @name holdCustomesChannels
    *  @param none
    *  @return void
    */
    public void holdCustomesChannels(){
        String[] CName=channelName.split(IPM_ConstantUtils.COMMA);
        channelName=IPM_ConstantUtils.BLANK;
        for(Integer i=0;i<CName.size();i++)
        {
            setchannelName.add(CName[i]);
            if(String.isBlank(channelName)){
                channelName=CName[i];
            }
            else{
                if(!channelName.contains(CName[i])){
                    channelName=channelName+IPM_ConstantUtils.COMMA+CName[i];
                }   
            }
        }   
    }

    /************************************************************************************************************************
    *  Description For caprturing CUs 
    *  @name holdCUsNames
    *  @param none
    *  @return void
    */
    public void holdCUsNames(){
        String[] cuName= selectedCUsNames.split(IPM_ConstantUtils.COMMA);
        for(Integer i=0;i<cuName.size();i++)
        {
            setselectedCUsNames.add(cuName[i]);
        }   
    }

    /************************************************************************************************************************
    *  Description For creating assortment strategy
    *  @name createAssortStrategy
    *  @param none
    *  @return void
    *  @throws exception
    */
    public void createAssortStrategy(){
        try{
            Integer countAssort=0;
            IPM_Project_Document_Section_Content__c projDocSecCon=new IPM_Project_Document_Section_Content__c();
            Set<String> existingChannel=new Set<String>();
            Set<String> existingCUs=new Set<String>();
            List<IPM_Project_Document_Section_Content__c> insertAssortList=new list<IPM_Project_Document_Section_Content__c>();
            Map<String,Integer> assortPriorityMap=new Map<String,Integer>();
            //Getting Existing Channels and CUs
            for(IPM_Project_Document_Section_Content__c  assort:lstAssortStrategy){
                if(!assortPriorityMap.containsKey(assort.IPM_Incumbent_CUs__c)){
                    assortPriorityMap.put(assort.IPM_Incumbent_CUs__c,(Integer)assort.IPM_Assortment_CU_Priority__c);
                }
                existingCUs.add(assort.IPM_Incumbent_CUs__c);
                existingChannel.add(assort.IPM_Assort_Channel_Name__c);
            }
            countAssort=existingCUs.size();
            //Getting Channels
            Set<String> channelSet=new Set<String>();
            if(String.isNotBlank(channelName)){
                String[] channels=channelName.split(IPM_ConstantUtils.COMMA);
                for(String channel:channels){
                    channelSet.add(channel);
                }
            }
            //Getting CUs
            Set<String> cuSet=new Set<String>();
            if(String.isNotBlank(selectedCUsNames)){
                String[] cus=selectedCUsNames.split(IPM_ConstantUtils.SEMICOLON);
                for(String cu:cus){
                    cuSet.add(cu);
                }
            }
            channelSet.addAll(existingChannel);
            cuSet.addAll(existingCUs);
            for(String cus:cuSet){
                if(!existingCUs.contains(cus)){
                    countAssort++;
                }
                for(String ch:channelSet){
                    if(!existingChannel.contains(ch) || !existingCUs.contains(cus)){
                        projDocSecCon=new IPM_Project_Document_Section_Content__c();
                        projDocSecCon.IPM_Content_Type__c = IPM_ConstantUtils.ASSORTMENT_CONTENT_TYPE;
                        projDocSecCon.IPM_Incumbent_CUs__c=cus;
                        projDocSecCon.IPM_Assort_Channel_Name__c=ch;
                        projDocSecCon.IPM_AssortmentStrategy_From__c=ipmProdocContent.IPM_AssortmentStrategy_From__c;
                        projDocSecCon.IPM_AssortmentStrategy_To__c=ipmProdocContent.IPM_AssortmentStrategy_To__c;
                        projDocSecCon.IPM_Distribution_Type__c=distributionType;
                        projDocSecCon.IPM_Project_Document_Section__c=prodocSecId;
                        if(existingCUs.contains(cus)){
                            projDocSecCon.IPM_Assortment_CU_Priority__c=assortPriorityMap.get(cus);
                        }
                        else{
                            projDocSecCon.IPM_Assortment_CU_Priority__c=countAssort;
                        }
                        insertAssortList.add(projDocSecCon);
                    }
                }  
            }
            if(insertAssortList!=null && !insertAssortList.isEmpty()){
                insert insertAssortList;
            }                           
        }
        catch(DMLException ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_ASSORTMENTSTRATEGY_STR,
                CREATEASSORTSTRATEGY_STR,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
        }
        getAssortStrategy();
    }

    /************************************************************************************************************************
    *  Description Get all record related to assortment
    *  @name getAssortStrategy
    *  @param none
    *  @return void
    *  @throws exception
    */
    public void getAssortStrategy(){
    	try{
	        lstAssortStrategy=new list<IPM_Project_Document_Section_Content__c>();
	        setAssortStrategy=new set<string>();
	        channelNameSet=new set<string>();
	        setselectedCUsNames=new set<string>();
	        setchannelName=new set<string>();
	        assortPriorityMap=new Map<String,Integer>();
	        lstAssortStrategy=[SELECT IPM_Assortment_Cus__c,IPM_Assortment_CU_Priority__c,IPM_Customer_Channel_Priority__c,IPM_Incumbent_CUs__c,IPM_Assortment_strategy_Target__c,IPM_Assort_Channel_Name__c,
	        						  IPM_AssortmentStrategy_To__c,IPM_Distribution_Type__c,IPM_Project_Document_Section__c,IPM_Assortment_Strategy_Priority__c,IPM_AssortmentStrategy_From__c 
	        				   FROM IPM_Project_Document_Section_Content__c 
	        				   WHERE IPM_Project_Document_Section__c=:prodocSecId order by IPM_Assortment_CU_Priority__c asc];
	        				   
	        if(lstAssortStrategy!=null && !lstAssortStrategy.isEmpty()){        
	            ipmProdocContent.IPM_AssortmentStrategy_From__c=lstAssortStrategy[0].IPM_AssortmentStrategy_From__c;
	            ipmProdocContent.IPM_AssortmentStrategy_To__c=lstAssortStrategy[0].IPM_AssortmentStrategy_To__c;
	            distributionType=lstAssortStrategy[0].IPM_Distribution_Type__c;
	        }
	        
	        //Clear CU value
	        ipmProdocContent.IPM_Incumbent_CUs__c=IPM_ConstantUtils.BLANK;
	        
	        for(IPM_Project_Document_Section_Content__c  AssortS:lstAssortStrategy){
	            setAssortStrategy.add(AssortS.IPM_Incumbent_CUs__c);
	            channelNameSet.add(AssortS.IPM_Assort_Channel_Name__c);
	            assortPriorityMap.put(AssortS.IPM_Incumbent_CUs__c,(Integer)AssortS.IPM_Assortment_CU_Priority__c);
	            if(String.isBlank(channelName)){
	                channelName=AssortS.IPM_Assort_Channel_Name__c;
	            }
	            else{
	                if(!channelName.contains(AssortS.IPM_Assort_Channel_Name__c)){
	                    channelName=channelName+IPM_ConstantUtils.COMMA+AssortS.IPM_Assort_Channel_Name__c;
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
	        countCU=setAssortStrategy.size();  
    	}
    	catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_ASSORTMENTSTRATEGY_STR,
            	GETASSORTSTRATEGY_STR,ex.getMessage(),ex, ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION); 
        }
    }

    /************************************************************************************************************************
    *  Description Delete all record related to assortment
    *  @name dltAllAssort
    *  @param none
    *  @return void
    *  @throws exception
    */
    public void dltAllAssort(){
        list<IPM_Project_Document_Section_Content__c> dltAllAssortS=new list<IPM_Project_Document_Section_Content__c>();
        dltAllAssortS=[SELECT id,IPM_Assortment_CU_Priority__c FROM IPM_Project_Document_Section_Content__c 
        			   WHERE IPM_Incumbent_CUs__c=:selecteAssortName AND IPM_Project_Document_Section__c=:prodocSecId limit 10];
        try
        {
            if(dltAllAssortS!=null && !dltAllAssortS.isEmpty())
            {
                deletedPriority=(Integer)dltAllAssortS[0].IPM_Assortment_CU_Priority__c;
                delete dltAllAssortS;    
            }
        }
        catch(DMLException ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_ASSORTMENTSTRATEGY_STR,
            	DLTALLASSORT_STR,ex.getMessage(),ex, ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION); 
        }
        updatePriority(deletedPriority);
        channelName=IPM_ConstantUtils.BLANK;
        getAssortStrategy();
    }
    
    /************************************************************************************************************************
    *  Description To Change the Assortment Priority
    *  @name updateAssortS
    *  @param none
    *  @return void
    *  @throws exception
    */
    public void updateAssortS(){
        IPM_Project_Document_Section_Content__c updateAssort=new IPM_Project_Document_Section_Content__c();
        updateAssort=[SELECT IPM_Assortment_Strategy_Priority__c FROM IPM_Project_Document_Section_Content__c 
        			  WHERE id=:selecteAssort limit 1];
        if(isTarget){
            updateAssort.IPM_Assortment_strategy_Target__c=assortTarget;
        }
        else{
        	updateAssort.IPM_Assortment_Strategy_Priority__c=assortPriority;
        }
        try{
            if(updateAssort!=null) {
                update updateAssort;   
            }
        }
        catch(DMLException ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_ASSORTMENTSTRATEGY_STR,
            	UPDATEASSORTS_STR,ex.getMessage(),ex, ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION); 
        }
        getAssortStrategy();    
    }

    /************************************************************************************************************************
    *  Description To Change the Assortment Priority
    *  @name changePriority
    *  @param none
    *  @return void
    *  @throws query,dml exception
    */
    public void changePriority(){
        try{
            Integer pNumeber=(Integer) priorityNumber;
            if(arrow==IPM_ConstantUtils.UP_ARROW){
                pNumeber=pNumeber-1;
            }
            else if(arrow==IPM_ConstantUtils.DOWN_ARROW){
                pNumeber=pNumeber+1;
            }
            List<IPM_Project_Document_Section_Content__c> newPriorityList=new List<IPM_Project_Document_Section_Content__c>();
            List<IPM_Project_Document_Section_Content__c> oldPriorityList=new List<IPM_Project_Document_Section_Content__c>();
            newPriorityList=[SELECT Id,IPM_Incumbent_CUs__c,IPM_Assortment_CU_Priority__c FROM IPM_Project_Document_Section_Content__c 
                             WHERE IPM_Incumbent_CUs__c=:priorityCU AND IPM_Project_Document_Section__c=:prodocSecId];
            oldPriorityList=[SELECT Id,IPM_Incumbent_CUs__c,IPM_Assortment_CU_Priority__c FROM IPM_Project_Document_Section_Content__c 
                             WHERE IPM_Project_Document_Section__c=:prodocSecId AND IPM_Assortment_CU_Priority__c=:pNumeber];
            for(IPM_Project_Document_Section_Content__c newPriority:newPriorityList){
                newPriority.IPM_Assortment_CU_Priority__c=pNumeber;
            }
            if(newPriorityList!=null && !newPriorityList.isEmpty()){  
                update newPriorityList;
            }
            for(IPM_Project_Document_Section_Content__c oldPriority:oldPriorityList){
                if(arrow==IPM_ConstantUtils.DOWN_ARROW){
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
        catch (DMLException ex) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_ASSORTMENTSTRATEGY_STR,
            	CHANGE_PRIORITY_STR,ex.getMessage(),ex, ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
        }
    }
    
    /************************************************************************************************************************
    *  Description To Update Assortment Priority
    *  @name updatePriority
    *  @param Integer
    *  @return void
    *  @throws query,dml exception
    */
    public void updatePriority(Integer delPriority){
        try{
            List<IPM_Project_Document_Section_Content__c> newPriorityList=new List<IPM_Project_Document_Section_Content__c>();
            newPriorityList=[SELECT Id,IPM_Incumbent_CUs__c,IPM_Assortment_CU_Priority__c FROM IPM_Project_Document_Section_Content__c 
                             WHERE IPM_Project_Document_Section__c=:prodocSecId AND IPM_Assortment_CU_Priority__c>:delPriority];
            for(IPM_Project_Document_Section_Content__c newPriority:newPriorityList){
                newPriority.IPM_Assortment_CU_Priority__c=(Integer)newPriority.IPM_Assortment_CU_Priority__c-1;
            }
            if(newPriorityList!=null && !newPriorityList.isEmpty()){  
                update newPriorityList;     
            }
        }
        catch(DMLException ex) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_ASSORTMENTSTRATEGY_STR,
            	UPDATE_PRIORITY_STR,ex.getMessage(),ex, ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
        }   
    }    
}