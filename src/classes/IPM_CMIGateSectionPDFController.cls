/******************************************************************************************************************************************
* @author Cognizant (Kannan and Samrat)
* @date 29/07/2015
* @description To Show CMI Table
*/
public with sharing Class IPM_CMIGateSectionPDFController{
    public Id projDocSecId; //Contains Project Document Section Id 
    public Id projectId{get; set;} //For Getting Project Id
    public List<IPM_Project_Document_Section_Content__c> secConCharterList{get; set;} //For Getting Charter CMI Contents
    public ID getprojDocSecId(){ return projDocSecId; } //Getting Project Document Section Id 
    //Setter for Project Document Section Id and Retrieving Project Document Section Contents
    public void setprojDocSecId (ID secId){
        projDocSecId= secId;
        showTableData();
    }
    public List<IPM_Gate_CMI__c> gateCMICharterList{get; set;} //For Getting CharterGate CMI Data
    public IPM_Project__c project{get; set;} //For Getting Project
    public String gateType{get; set;} //For Getting Project Gate Type
    public Map<Id,List<IPM_Project_Document_Section_Content__c>> contentMap{get; set;}
    
    public Map<String,IPM_Project_Document_Section_Content__c> displayCon{get; set;}
    public set<String> countryNames{get; set;}
    public Map<String,Integer> inputCount{get; set;}
    public String gateTypeCharter{get; set;} //For Getting Charter Gate Type
    public String gateTypeContract{get; set;} //For Getting Contract Gate Type
    public String gateTypeMarketReady{get; set;} //For Getting Market Ready Gate Type
    /**********************************************************************************************************************************
    @description For Showing Gate CMI Data Values in Table
    **********************************************************************************************************************************/
    public void showTableData(){
        //Initializing Lists
        gateCMICharterList=new List<IPM_Gate_CMI__c>();
        secConCharterList=new List<IPM_Project_Document_Section_Content__c>();
        contentMap=new Map<Id,List<IPM_Project_Document_Section_Content__c>>();
        displayCon=new Map<String,IPM_Project_Document_Section_Content__c>(); 
        inputCount=new Map<String,Integer>();
        countryNames=new set<String>();
        gateTypeCharter=IPM_ConstantUtils.CHARTER_GATE;
        gateTypeContract=IPM_ConstantUtils.CONTRACT_GATE;
        gateTypeMarketReady=IPM_ConstantUtils.MARKET_READY_GATE;
        try{
           
           //Getting KPI Input count for tests
            for(IPM_Gate_CMI_KPI_Inputs__c kpi:IPM_Gate_CMI_KPI_Inputs__c.getall().values()){
                inputCount.put(kpi.IPM_Test__c,(Integer)kpi.IPM_Input_Size__c);
            }
            
            //Getting Project
            project=[SELECT Id,IPM_Parent_Project__c FROM IPM_Project__c WHERE Id=:projectId];  
            //Getting Gate CMI Records
            gateCMICharterList=[SELECT Id,Gate__c,IPM_CMI_Overall_Colour_Score_Method__c,Element__c,Test__c,KPI__c,Input__c,Results__c,Country__c,Approx_Results_Timing__c,IPM_Skip_Test__c,IPM_Skip_Test_Reason__c 
                                FROM IPM_Gate_CMI__c 
                                WHERE IPM_Skip_Test__c=false and IPM_Project__c=:project.Id and Gate__c='Charter'];
            secConCharterList=[SELECT Id,IPM_CMI_Color_Score_Value__c,IPM_CMI_Overall_Score_Achieved__c,IPM_CMI_Overall_Colour_Achieved__c ,IPM_CMI_Color_Score_Value_Achieved__c,IPM_CMI_Free_Text__c,IPM_CMI_Overall_Comments__c,IPM_CMI_Is_Free_Text__c,IPM_CMI_Result_Timing__c,IPM_CMI_Country__c,IPM_Gate_CMI__c,IPM_CMI_Input__c,IPM_CMI_Comments__c,IPM_CMI_Result__c,
                               IPM_Project_Document_Section__c,IPM_CMI_Outcome_Color_Achieved__c,IPM_CMI_Results_Acheived__c,IPM_CMI_Outcome_Color__c,IPM_CMI_Overall_Colour__c,IPM_CMI_Overall_Colour_Coding_Method__c,IPM_CMI_Overall_Score__c 
                               FROM IPM_Project_Document_Section_Content__c 
                               WHERE IPM_Content_Type__c=:IPM_ConstantUtils.CMIGATE_CONTENT_TYPE AND IPM_Gate_CMI__r.Gate__c='Charter' AND IPM_Project_Document_Section__c=:projDocSecId];
            List<IPM_Project_Document_Section_Content__c> addContList;
            for(IPM_Gate_CMI__c cmi:gateCMICharterList){
                    addContList=new List<IPM_Project_Document_Section_Content__c>();
                    for(IPM_Project_Document_Section_Content__c con:secConCharterList){
                        if(cmi.Id==con.IPM_Gate_CMI__c){
                            displayCon.put(cmi.Test__c+con.IPM_CMI_Country__c,con);
                            countryNames.add(cmi.Test__c+con.IPM_CMI_Country__c);
                            addContList.add(con);
                        }
                    }
                contentMap.put(cmi.Id,addContList);
            }     
        }
        catch(Exception ex){
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),'IPM_CMIGateSectionPDFController',
                'showTableData',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);                
        }
    }
}