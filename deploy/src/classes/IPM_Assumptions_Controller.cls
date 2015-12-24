/****************************************************************************************************************************
@Author: Cognizant
@Name: IPM_Assumptions_Controller
@Created Date: 2015/08/06
@Description: Used for the Getting Comments for Assumptions
@Version: 1.0
@Reference: Project Document Section Editor Page
*/
public with sharing class IPM_Assumptions_Controller {
    //Initializing Variables
    public IPM_Project_Document_Section_Content__c assumption{get; set;} //For getting assumption record 
    public string gateDocType{get;set;}// used in corresponding component
    public string contentName{get; set;} //For saving comments 
    public string comments{get; set;} //For saving comments 
    public ID projDocSecId{ 
        get {
            return projDocSecId; // to get the project document section ID from the component used from Gate document page
        }
        set {
            projDocSecId= value;// setting the value of project document section
            getAssumptions();
        }
    }
    public Integer contentCount;//for updation
    //For try-catch
    public string IPM_ASSUMPTIONS_CONTROLLER_NAME=IPM_Assumptions_Controller.class.getName();
    public static final string GET_ASSUMPTIONS='getAssumptions';
    public static final string SAVE_ASSUMPTIONS='saveAssumptions';
    
    /************************************************************************************************************************
    *  Description To Create Assumptions Comments
    *  @name getAssumptions
    *  @param none
    *  @return void
    *  @throws query exception
    */
    public void getAssumptions(){   
        contentCount=0;
        assumption=new IPM_Project_Document_Section_Content__c();
        try{
            contentCount=[SELECT Count() FROM IPM_Project_Document_Section_Content__c WHERE IPM_Project_Document_Section__c=:projDocSecId and IPM_Gate_Type__c=:gateDocType];
            if(contentCount>0){
                assumption=[SELECT Id,IPM_Gate_Type__c,IPM_Content_Type__c,IPM_Assumption_A_P__c,IPM_Assumption_CAPEX__c,IPM_Assumption_Countries__c, IPM_Assumption_GM__c,
                                   IPM_Assumption_Volume__c,IPM_Assumption_Market_Size__c,IPM_Assumption_Pricing__c,IPM_Assumption_Restages__c,IPM_Assumption_T_O_Cannibalization__c,
                                   IPM_Assumption_Volume_Yr_2__c,IPM_Assumption_Yr_1_Trade_Promotion__c,IPM_Project_Document_Section__c
                            FROM   IPM_Project_Document_Section_Content__c
                            WHERE  IPM_Project_Document_Section__c=:projDocSecId and IPM_Gate_Type__c=:gateDocType Limit 1];
            }
        }
        
        catch(QueryException ex){
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_ASSUMPTIONS_CONTROLLER_NAME,
                GET_ASSUMPTIONS,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);

        }
    }           
    
    /************************************************************************************************************************
    *  Description To Save Assumptions Comments
    *  @name saveAssumptions
    *  @param none
    *  @return void
    *  @throws dml exception
    */
    public void saveAssumptions(){
        try{
            getAssumptions();
            if(contentName==IPM_ConstantUtils.MARKET_SIZE) {
                assumption.IPM_Assumption_Market_Size__c=comments;
            }
            else if(contentName==IPM_ConstantUtils.AP) {
                assumption.IPM_Assumption_A_P__c=comments;
            }
            else if(contentName==IPM_ConstantUtils.CAPEX){
                assumption.IPM_Assumption_CAPEX__c=comments;
            }
            else if(contentName==IPM_ConstantUtils.COUNTRIES){
                assumption.IPM_Assumption_Countries__c=comments;
            }
            else if(contentName==IPM_ConstantUtils.GM){
                assumption.IPM_Assumption_GM__c=comments;
            }       
            else if(contentName==IPM_ConstantUtils.VOLUME_ASSUMPTION){
                assumption.IPM_Assumption_Volume__c=comments;
            }
            else if(contentName==IPM_ConstantUtils.PRICING){
                assumption.IPM_Assumption_Pricing__c=comments;
            }
            else if(contentName==IPM_ConstantUtils.RESTAGES){
                assumption.IPM_Assumption_Restages__c=comments;
            }
            else if(contentName==IPM_ConstantUtils.CANNIBALIZATION){
                assumption.IPM_Assumption_T_O_Cannibalization__c=comments;
            }
            else if(contentName==IPM_ConstantUtils.VOLUME_YEAR_2){
                assumption.IPM_Assumption_Volume_Yr_2__c=comments;
            }    
            else {
                assumption.IPM_Assumption_Yr_1_Trade_Promotion__c=comments;
            }
            if(contentCount<1){
                assumption.IPM_Gate_Type__c=gateDocType;
                assumption.IPM_Content_Type__c=IPM_ConstantUtils.ASSUMPTIONS;
                assumption.IPM_Project_Document_Section__c=projDocSecId;
                insert assumption;
            }
            else{
                update assumption;
            }
        }
        catch(DMLException ex){
             ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_ASSUMPTIONS_CONTROLLER_NAME,
                    SAVE_ASSUMPTIONS,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
        }
        catch(Exception ex){
             ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_ASSUMPTIONS_CONTROLLER_NAME,
                    SAVE_ASSUMPTIONS,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
        }
    }   
}