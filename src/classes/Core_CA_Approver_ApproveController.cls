/*
  Class Name: Core_CA_Approver_ApproveController
  Author : Mindtree
  Date: 17 Sept 2014
  Requirement/Project Name: Unilever Salesforce Engagement
  Requirement/Description: Approve action from Approver record   
*/

public with sharing class Core_CA_Approver_ApproveController {
    
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
    public Core_CA_Approver_ApproveController(ApexPages.StandardController controller) {
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
        List<Core_Approver_Details__c> lstApprover=new List<Core_Approver_Details__c>();
        List<Core_Approver_Details__c> lstApproverId=[SELECT Interested_Party__c,Id,Approval_Header__c,Status__c,Source_System__c,Role__c,Is_Active__c,Action__c  FROM Core_Approver_Details__c where id=:urlId ];
        if(!lstApproverId.isempty()) lstApprover=[SELECT Interested_Party__c,Id,Approval_Header__c,Status__c,Source_System__c,Role__c,Is_Active__c,Action__c FROM Core_Approver_Details__c where Approval_Header__c=:lstApproverId[0].Approval_Header__c]; 
        if(!lstApprover.isempty()){
            integer count=0;
            for(Core_Approver_Details__c Approver : lstApprover){
                    if(Approver.Interested_Party__c==Userinfo.getuserId() && Approver.Role__c=='APP'&&Approver.Source_System__c=='Ariba' && Approver.Is_Active__c) count++;
                    if(Approver.Role__c=='EMP'&& Approver.Action__c =='CANC'&& Approver.Source_System__c=='GTES') bolGTES_CANC=true;
            }
            if(lstApproverId[0].Interested_Party__c==Userinfo.getuserId() && lstApproverId[0].Role__c=='APP'){ 
                if(lstApproverId[0].Source_System__c=='Ariba'){ 
                    strMsg=CORE_Chatter_Approval__c.getinstance('AppRejAribaMessage').Text_Value__c;
                    bolAribaChkBox=true;
                }
                if((lstApproverId[0].Source_System__c=='GTES' && lstApproverId[0].Action__c!='COPY') || (lstApproverId[0].Source_System__c=='Ariba' && lstApproverId[0].Is_Active__c)){ 
                    if(lstApproverId[0].Status__c=='Approved'||lstApproverId[0].Status__c=='Rejected') bolAppRej=true;
                    if(lstApproverId[0].Status__c=='Rejected'&&lstApproverId[0].Source_System__c=='Ariba'&&count==1) bolAppRej=false;
                    //if(lstApproverId[0].Source_System__c=='Ariba') bolAribaChkBox=true;
                    if(lstApproverId[0].Source_System__c=='GTES') bolGTESChkBox=true;
                        bolApprover =true;
                        ApproverId=lstApproverId[0].Interested_Party__c;
                        approverRecId =lstApproverId[0].id;
                        strStatus=lstApproverId[0].Status__c;
                        strSourceSystem=lstApproverId[0].Source_System__c;
                        if(bolGTES_CANC) bolCANCConfirm=true;
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
            strConfirmationMsg = CORE_Chatter_Approval__c.getinstance('AppRejDBErrorMessage').Text_Value__c;
            bolConfirmation =true;
            strConfirmStatus ='error'; 
        }
    }

}