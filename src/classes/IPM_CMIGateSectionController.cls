/******************************************************************************************************************************************
* @author Cognizant (Kannan and Samrat)
* @date 29/07/2015
* @description To Show CMI Table
*/
public with sharing Class IPM_CMIGateSectionController{
    public Id projDocSecId; //Contains Project Document Section Id 
    public Id projectId{get; set;} //For Getting Project Id
    public List<IPM_Project_Document_Section_Content__c> secConList{get; set;} //For Getting CMI Contents
    public ID getprojDocSecId(){ return projDocSecId; } //Getting Project Document Section Id 
    //Setter for Project Document Section Id and Retrieving Project Document Section Contents
    public void setprojDocSecId (ID secId){
        projDocSecId= secId;
        showTableData();
    }
    public List<IPM_Gate_CMI__c> gateCMIList{get; set;} //For Getting Gate CMI Data
    public IPM_Project__c project{get; set;} //For Getting Project
    public String gateType{get; set;} //For Getting Project Gate Type
    public List<String> gateTypes{get; set;} //Contains Gate Types
    public Map<Id,Integer> contentCount{get; set;}
    public Integer count;
    public Map<String,IPM_Project_Document_Section_Content__c> displayCon{get; set;}
    public set<String> countryNames{get; set;}
    public Map<String,Integer> inputCount{get; set;}
    @TestVisible private String gateDocument;
    private static string CLASS_NAME=IPM_CMIGateSectionController.class.getName();
    /**********************************************************************************************************************************
    @description For Showing Gate CMI Data Values in Table
    **********************************************************************************************************************************/
    public void showTableData(){
        //Initializing Lists
        gateTypes=new List<String>();  
        gateCMIList=new List<IPM_Gate_CMI__c>();
        secConList=new List<IPM_Project_Document_Section_Content__c>();
        contentCount=new Map<Id,Integer>();
        displayCon=new Map<String,IPM_Project_Document_Section_Content__c>(); 
        inputCount=new Map<String,Integer>();
        countryNames=new set<String>();
        gateDocument=IPM_ConstantUtils.BLANK;
        try{
            if(gateType==IPM_ConstantUtils.CHARTER_GATE){
                gateDocument=IPM_ConstantUtils.CHARTER_GATE;
            }
            if(gateType==IPM_ConstantUtils.CONTRACT_GATE){
                gateDocument=IPM_ConstantUtils.CONTRACT_GATE;
            }
            if(gateType==IPM_ConstantUtils.MARKET_READY_GATE){
                gateDocument=IPM_ConstantUtils.MARKET_READY_GATE;
            }
            if(gateType==IPM_ConstantUtils.MARKET_DEPLOYMENT_GATE){
                gateDocument=IPM_ConstantUtils.MARKET_READY_GATE;
            }
            //Initializing list of gate types
            gateTypes.add(IPM_ConstantUtils.CHARTER_GATE);
            gateTypes.add(IPM_ConstantUtils.CONTRACT_GATE);
            gateTypes.add(IPM_ConstantUtils.MARKET_READY_GATE);
            
            //Getting KPI Input count for tests
            for(IPM_Gate_CMI_KPI_Inputs__c kpi:IPM_Gate_CMI_KPI_Inputs__c.getall().values()){
                inputCount.put(kpi.IPM_Test__c,(Integer)kpi.IPM_Input_Size__c);
            }
            
            //Getting Project
            project=[SELECT Id,IPM_Parent_Project__c FROM IPM_Project__c WHERE Id=:projectId];  
            if(gateType==IPM_ConstantUtils.MARKET_DEPLOYMENT_GATE){
                //Getting Gate CMI Records
                gateCMIList=[SELECT Id,Gate__c,IPM_CMI_Overall_Colour_Score_Method__c,Element__c,Test__c,KPI__c,Input__c,Results__c,Country__c,Approx_Results_Timing__c,IPM_Skip_Test__c,IPM_Skip_Test_Reason__c 
                             FROM IPM_Gate_CMI__c 
                             WHERE IPM_Skip_Test__c=false and  IPM_Project__c=:project.IPM_Parent_Project__c LIMIT 1000];   
                
                //Getting CMI Content Records                     
                secConList=[SELECT Id,IPM_CMI_Color_Score_Value__c,IPM_CMI_Overall_Score_Achieved__c,IPM_CMI_Overall_Colour_Achieved__c ,IPM_CMI_Color_Score_Value_Achieved__c,IPM_CMI_Free_Text__c,IPM_CMI_Overall_Comments__c,IPM_CMI_Is_Free_Text__c,IPM_CMI_Result_Timing__c,IPM_CMI_Country__c,IPM_Gate_CMI__c,IPM_CMI_Input__c,IPM_CMI_Comments__c,IPM_CMI_Result__c,
                                   IPM_Project_Document_Section__c,IPM_CMI_Outcome_Color_Achieved__c,IPM_CMI_Results_Acheived__c,IPM_CMI_Outcome_Color__c,IPM_CMI_Overall_Colour__c,IPM_CMI_Overall_Colour_Coding_Method__c,IPM_CMI_Overall_Score__c 
                            FROM IPM_Project_Document_Section_Content__c 
                            WHERE IPM_Content_Type__c=:IPM_ConstantUtils.CMIGATE_CONTENT_TYPE AND IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_GateDocuments__c=:gateDocument AND IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__c=:project.IPM_Parent_Project__c LIMIT 1000];
            }
            else{
                //Getting Gate CMI Records
                gateCMIList=[SELECT Id,Gate__c,IPM_CMI_Overall_Colour_Score_Method__c,Element__c,Test__c,KPI__c,Input__c,Results__c,Country__c,Approx_Results_Timing__c,IPM_Skip_Test__c,IPM_Skip_Test_Reason__c 
                             FROM IPM_Gate_CMI__c 
                             WHERE IPM_Skip_Test__c=false and  IPM_Project__c=:projectId LIMIT 1000];   
                
                //Getting CMI Content Records                     
                secConList=[SELECT Id,IPM_CMI_Color_Score_Value__c,IPM_CMI_Overall_Score_Achieved__c,IPM_CMI_Overall_Colour_Achieved__c ,IPM_CMI_Color_Score_Value_Achieved__c,IPM_CMI_Free_Text__c,IPM_CMI_Overall_Comments__c,IPM_CMI_Is_Free_Text__c,IPM_CMI_Result_Timing__c,IPM_CMI_Country__c,IPM_Gate_CMI__c,IPM_CMI_Input__c,IPM_CMI_Comments__c,IPM_CMI_Result__c,
                                   IPM_Project_Document_Section__c,IPM_CMI_Outcome_Color_Achieved__c,IPM_CMI_Results_Acheived__c,IPM_CMI_Outcome_Color__c,IPM_CMI_Overall_Colour__c,IPM_CMI_Overall_Colour_Coding_Method__c,IPM_CMI_Overall_Score__c 
                            FROM IPM_Project_Document_Section_Content__c 
                            WHERE IPM_Content_Type__c=:IPM_ConstantUtils.CMIGATE_CONTENT_TYPE AND IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_GateDocuments__c=:gateDocument AND IPM_Project_Document_Section__c=:projDocSecId LIMIT 1000];
            }       
            for(IPM_Gate_CMI__c cmi:gateCMIList){
                 count=1;   
                 for(IPM_Project_Document_Section_Content__c con:secConList){
                    if(cmi.Id==con.IPM_Gate_CMI__c){
                        displayCon.put(cmi.Test__c+con.IPM_CMI_Country__c,con);
                        countryNames.add(cmi.Test__c+con.IPM_CMI_Country__c);
                        ++count;
                    }
                }
                contentCount.put(cmi.Id,count);
            }                    
        }
        catch(Exception ex){
            
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Label.IPM_Generic_ErrorMessage));  
             
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,
                'showTableData',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);                
        }
                       
    }
}