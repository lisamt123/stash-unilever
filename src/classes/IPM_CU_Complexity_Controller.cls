/******************************************************************
@Description :Used for the storing Total Cu Count value in Cu_Complexity Section
@Created Date:07/08/2015
@Author: Cognizant
******************************************************************/
public with sharing class IPM_CU_Complexity_Controller {
    
    //For try-catch
    private static final string SAVE_CUCOUNT='saveCuCount';
    private static final string GET_CUCOUNT='getCuCount';
    private static final string SAVE_INC_OR_DEC='saveIncOrDec';
    private static final string SAVE_NET_PROJECT_EFFECT='saveNetProjectEffect';
    private static final string IPM_CU_COMPLEXITY_CONTROLLER_STR=IPM_CU_Complexity_Controller.class.getName();
    
    //Initializing Variables
    public Integer contentCount;
    public String typeOfGate{get; set;}//used in corresponding component
    public String phase{get; set;}//used in corresponding component
    public Boolean isEditable{get;set;}//used in corresponding component
    public Decimal incDecBy{get;set;}//for storing increased by or decreased by value
    public String projectEffect{get;set;}//for storing project effect value
    public String isIncDecBy{get;set;}//for setting parameter
    public Id projectId{get; set;} //Contains Project Id
    public String projSpan{get; set;}//used in corresponding component
    public String projModel{get; set;}//used in corresponding component
    public Boolean isBD{get;set;}//for checking whether BD user are there or not
    public Id projectSecId{
        get {
            return projectSecId; // to get the project document section ID from the component used from Gate document page
        }
        set {
            projectSecId= value;// setting the value of project document section
            getCuCount();
        }
    }
    public String cuCount{get;set;}//For saving CuCount
    public Id projDocSecConId{get;set;}//For getting section content id
    public IPM_Project_Document_Section_Content__c projDocSecCon{get;set;}//For getting Content record 
    
    
    
    /******************************************************************
    @Description :To Create CuCount value  
    @return: Void
    ******************************************************************/
    public void getCuCount(){
        
        //isBD=false;
        projectId=ApexPages.currentPage().getParameters().get('Id');
        projDocSecCon=new IPM_Project_Document_Section_Content__c();
        contentCount=0;
        try{
            contentCount=[SELECT Count() FROM IPM_Project_Document_Section_Content__c WHERE IPM_Project_Document_Section__c=:projectSecId and IPM_Gate_Type__c=:typeOfGate];
            if(contentCount>0){
                projDocSecCon=[select IPM_Gate_Type__c,IPM_Project_Effect__c,IPM_Content_Type__c,IPM_Total_Cu_Count_Impact__c,IPM_Decreased_By__c,IPM_Increased_By__c from  IPM_Project_Document_Section_Content__c
                Where IPM_Project_Document_Section__c=:projectSecId and IPM_Gate_Type__c=:typeOfGate];
            }
        }
        
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_CU_COMPLEXITY_CONTROLLER_STR,
            GET_CUCOUNT,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,null);
        }
        
    }   

    /******************************************************************
    @Description :To Create CuCount value
    @return: Void
    ******************************************************************/ 
    public void saveCuCount(){
        try{
            projDocSecCon=new IPM_Project_Document_Section_Content__c();
            if(contentCount<1){
                projDocSecCon.IPM_Gate_Type__c=typeOfGate;
                projDocSecCon.IPM_Project_Document_Section__c=projectSecId;
                projDocSecCon.IPM_Total_Cu_Count_Impact__c=cuCount;
                projDocSecCon.IPM_Content_Type__c=IPM_ConstantUtils.CU_COMPLEXITY;
                insert projDocSecCon;
            }
            else{
                projDocSecCon.Id=projDocSecConId;
                projDocSecCon.IPM_Total_Cu_Count_Impact__c=cuCount;
                projDocSecCon.IPM_Content_Type__c=IPM_ConstantUtils.CU_COMPLEXITY;
                update projDocSecCon;
            }
        }        
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_CU_COMPLEXITY_CONTROLLER_STR,
            SAVE_CUCOUNT,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,null);
        }
    }

    
    /******************************************************************
    @Description :To Create or update IncDecBy value
    @return: Void
    ******************************************************************/ 
    public void saveIncOrDec(){
        try{
            projDocSecCon=new IPM_Project_Document_Section_Content__c();
            if(contentCount<1){
                projDocSecCon.IPM_Gate_Type__c=typeOfGate;
                projDocSecCon.IPM_Project_Document_Section__c=projectSecId;
                projDocSecCon.IPM_Project_Effect__c=projectEffect;
                if(projDocSecCon.IPM_Project_Effect__c==IPM_ConstantUtils.INCREASE_IN_COM_BY){
                    projDocSecCon.IPM_Increased_By__c=incDecBy;
                }
                else if(projDocSecCon.IPM_Project_Effect__c==IPM_ConstantUtils.DECREASE_IN_COM_BY){
                    projDocSecCon.IPM_Decreased_By__c=incDecBy;
                }
                projDocSecCon.IPM_Content_Type__c=IPM_ConstantUtils.CU_COMPLEXITY;
                insert projDocSecCon;
            }
            else{
                projDocSecCon.Id=projDocSecConId;
                projDocSecCon.IPM_Project_Effect__c=projectEffect;
                if(projDocSecCon.IPM_Project_Effect__c==IPM_ConstantUtils.INCREASE_IN_COM_BY){
                    projDocSecCon.IPM_Increased_By__c=incDecBy;
                    projDocSecCon.IPM_Decreased_By__c=null;
                }
                else if(projDocSecCon.IPM_Project_Effect__c==IPM_ConstantUtils.DECREASE_IN_COM_BY){
                    projDocSecCon.IPM_Decreased_By__c=incDecBy;
                    projDocSecCon.IPM_Increased_By__c=null;
                }
               
                projDocSecCon.IPM_Content_Type__c=IPM_ConstantUtils.CU_COMPLEXITY;
                update projDocSecCon;
            }
        }
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_CU_COMPLEXITY_CONTROLLER_STR,
            SAVE_INC_OR_DEC,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,null);
        }
    }
    
    /******************************************************************
    @Description :To Create or update Project Effect value
    @return: Void
    ******************************************************************/ 
    
    public void saveNetProjectEffect(){
        try{
            projDocSecCon=new IPM_Project_Document_Section_Content__c();
            if(contentCount<1){
                projDocSecCon.IPM_Gate_Type__c=typeOfGate;
                projDocSecCon.IPM_Project_Document_Section__c=projectSecId;
                projDocSecCon.IPM_Project_Effect__c=projectEffect;
                projDocSecCon.IPM_Content_Type__c=IPM_ConstantUtils.CU_COMPLEXITY;
                insert projDocSecCon;
            }
            else{
                projDocSecCon.Id=projDocSecConId;
                projDocSecCon.IPM_Project_Effect__c=projectEffect;
                if(projDocSecCon.IPM_Project_Effect__c=='No Effect'){
                    projDocSecCon.IPM_Decreased_By__c=null;
                    projDocSecCon.IPM_Increased_By__c=null;
                }
                projDocSecCon.IPM_Content_Type__c=IPM_ConstantUtils.CU_COMPLEXITY;
                update projDocSecCon;
            }
        }
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_CU_COMPLEXITY_CONTROLLER_STR,
            SAVE_NET_PROJECT_EFFECT,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,null);
        }
    }
    
     /****************************************************************************
    @Description : For getting project effect value
    @Return: List of project effect picklist value
    *****************************************************************************/
    public List<SelectOption> getProjEffect(){
        Schema.sObjectType sobject_type = IPM_Project_Document_Section_Content__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map=new Map<String, Schema.SObjectField>();
        field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get(IPM_ConstantUtils.PROJECT_EFFECT).getDescribe().getPickListValues();
        List<selectOption> options = new List<selectOption>();
        
        for (Schema.PicklistEntry a : pick_list_values) {
            options.add(new selectOption(a.getLabel(), a.getValue()));
        }
        
        return options;
    }  
    
 
                
    
}