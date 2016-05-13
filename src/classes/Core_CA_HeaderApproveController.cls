/*
  Class Name: Core_CA_HeaderApproveController 
  Author : Mindtree
  Date: 15 Sept 2014
  Requirement/Project Name: Unilever Salesforce Engagement
  Requirement/Description: Approve action from Header record   
*/

public with sharing class Core_CA_HeaderApproveController {
    
    public string urlId { get; set; }
    public string HeaderId {get; set;}
    public string ApproverId {get; set;}
    public boolean bolApprover {get;set;}
    public string strMsg {get;set;}
    public string approverComments {get;set;}
    public string approverRecId {get;set;}
    public string strConfirmationMsg {get;set;}
    public boolean bolConfirmation {get;set;}
    public string strConfirmStatus {get;set;}
    public boolean bolAppRej {get;set;}
    public string strStatus {get;set;}
    public String sfdcURL {get; set;}
    public Boolean AribaChkBox {get; set;}
    public Boolean bolAribaChkBox {get; set;}
    public String strSourceSystem {get;set;}
    public Boolean bolCloseSuccess {get;set;}
    public Map<string,string> mapParam {get;set;}
    public Boolean bolAction {get;set;}
    public Boolean bolButton {get;set;}
    public Boolean bolExit {get;set;}
    public String outputMessage {get;set;}
    public string myApprovalUrlId { get; set; }
    public string myApprovalTabId { get; set; }
    public Boolean bolGTESChkBox {get; set;}
    
    //Constructor: To check if the user is Approver or not
    public Core_CA_HeaderApproveController(ApexPages.StandardController controller) {
        bolApprover =false;
        bolConfirmation =false;
        bolAppRej =false;
        AribaChkBox=false;
        bolAribaChkBox=false; 
        Boolean bolGTES_CANC=false;
        Boolean bolCANCConfirm=false;
        myApprovalUrlId='/apex/Core_CA_ApprovalDetails';
        myApprovalTabId=myApprovalUrlId +'?sfdc.tabName='+CORE_Chatter_Approval__c.getinstance('MyApprovalsTabId').Text_Value__c;
        outputMessage=CORE_Chatter_Approval__c.getinstance('AppRejSubmitMessage').Text_Value__c;
        mapParam=ApexPages.currentPage().getParameters();
        bolAction=mapParam.containsKey('inline');
        bolButton=mapParam.containsKey('scontrolCaching');
        strMsg =CORE_Chatter_Approval__c.getinstance('AppErrorMessage').Text_Value__c;
        urlId = ApexPages.currentPage().getParameters().get('id');
        sfdcURL = URL.getSalesforceBaseUrl().toExternalForm() + '/'+urlId;
        List<Core_Approval_Header__c> lstHeader =[SELECT id FROM Core_Approval_Header__c where id=:urlId ]; 
        if(!lstHeader.isempty()){
            HeaderId = lstHeader[0].id; 
            integer count=0;
            List<Core_Approver_Details__c> lstApprover=[SELECT Interested_Party__c,Id,Status__c,Source_System__c,Role__c,Is_Active__c,CreatedDate,Action__c FROM Core_Approver_Details__c WHERE Approval_Header__c =:HeaderId ORDER BY CreatedDate ASC];
            if(!lstApprover.isempty()){
                for(Core_Approver_Details__c Approver : lstApprover){
                    if(Approver.Interested_Party__c==Userinfo.getuserId() && Approver.Role__c=='APP'&&Approver.Source_System__c=='Ariba' && Approver.Is_Active__c) count++;
                    if(Approver.Role__c=='EMP'&& Approver.Action__c =='CANC'&& Approver.Source_System__c=='GTES') bolGTES_CANC=true;
                }
                for(Core_Approver_Details__c Approver : lstApprover){
                    if(Approver.Interested_Party__c==Userinfo.getuserId() && Approver.Role__c=='APP'){
                        if(Approver.Source_System__c=='Ariba'){
                            strMsg=CORE_Chatter_Approval__c.getinstance('AppRejAribaMessage').Text_Value__c;
                            bolAribaChkBox=true;
                        }
                        //For single approver having same Interested Party user with same role for both Ariba/GTES system
                        if((Approver.Source_System__c=='GTES' && Approver.Action__c!='COPY') || (Approver.Source_System__c=='Ariba' && Approver.Is_Active__c && count==1)){
                            if(Approver.Status__c=='Approved'||Approver.Status__c=='Rejected') bolAppRej=true; 
                            if(Approver.Status__c=='Rejected'&&Approver.Source_System__c=='Ariba') bolAppRej=false;
                            //if(Approver.Source_System__c=='Ariba') bolAribaChkBox=true;
                            if(Approver.Source_System__c=='GTES') bolGTESChkBox=true;
                                bolApprover =true;
                                ApproverId=Approver.Interested_Party__c;
                                approverRecId =Approver.id;
                                strStatus=Approver.Status__c;
                                strSourceSystem=Approver.Source_System__c;
                                if(bolGTES_CANC) bolCANCConfirm=true;
                                break;
                        }
                        //For multiple approver having same Interested Party user with same role for Ariba
                        else if(Approver.Source_System__c=='Ariba' && Approver.Is_Active__c && count>1){
                                if(Approver.Status__c=='Approved'||Approver.Status__c=='Rejected'){
                                    bolAppRej=true;
                                    continue;
                                }
                                else 
                                {
                                    bolAppRej=false;
                                    bolApprover =true;
                                    bolAribaChkBox=true;
                                    ApproverId=Approver.Interested_Party__c;
                                    approverRecId =Approver.id;
                                    strStatus=Approver.Status__c;
                                    strSourceSystem=Approver.Source_System__c;
                                    break;
                                }
                        }
                    }
                }
            }
        }
        if(bolAppRej||bolCANCConfirm){
            if(bolAppRej) strMsg=CORE_Chatter_Approval__c.getinstance('AppRejAlreadyStatus').Text_Value__c;
            if(bolCANCConfirm) strMsg=CORE_Chatter_Approval__c.getinstance('AppRejGTESCANCMessage').Text_Value__c;
            //strMsg= strMsg.replace('XXXXXX',strStatus);
            bolApprover =false;
        }
        
    }
    
    //Method: To navivate to Record Details page
    public void exit(){
        bolExit=true;
    }
    
    //Method: To update approver comments to database
    public void submitComments(){
    try{
        List<Core_Approver_Details__c> lstAppDetails=new List<Core_Approver_Details__c>();
        Core_Approver_Details__c ObjAppDetails=new Core_Approver_Details__c ();
        ObjAppDetails.Id=approverRecId;
        ObjAppDetails.Comments__c=approverComments;
        ObjAppDetails.Status__c='Approved';
        ObjAppDetails.Send_to_Source_System__c='Yes';
        if(strSourceSystem=='Ariba') ObjAppDetails.Visible_to_Supplier__c=AribaChkBox;
        if(approverComments.length()<=255){
            lstAppDetails.add(ObjAppDetails);
        }
        else
        {
            strConfirmationMsg =CORE_Chatter_Approval__c.getinstance('AppRejStringLengthMessage').Text_Value__c;
            bolConfirmation =true;
            strConfirmStatus ='error';
        }
        if(!lstAppDetails.isempty()){
                update lstAppDetails;
            bolCloseSuccess =true;
            strConfirmationMsg =CORE_Chatter_Approval__c.getinstance('AppConfirmMessage').Text_Value__c;
            bolConfirmation =true;
            strConfirmStatus ='confirm';
            
        }
        }
        catch(Exception ex){
            strConfirmationMsg =CORE_Chatter_Approval__c.getinstance('AppRejDBErrorMessage').Text_Value__c;
            bolConfirmation =true;
            strConfirmStatus ='error';
        }
    }
}