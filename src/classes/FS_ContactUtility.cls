/**********************************************************************
Name: FS_ContactUtility  
======================================================
======================================================
Purpose: For storing the Hardcoded values that are being used 
for the PII Contact Integration to Brandtone.
-------
======================================================
======================================================
History
-------
VERSION AUTHOR   DATE        DETAIL Description
1.0     Dinesh 26/07/2016 INITIAL DEVELOPMENT 
***********************************************************************/


Public  Class FS_ContactUtility  {

    Public Static Final String CONTACTCREATEPAGEURL = '/apex/FS_CreateContact';
    Public Static Final String IDTEXTFOREXTRAPARAMETERS = 'Id';
    Public Static Final String STATUSVALUEOK = 'Ok';
    Public Static Final Integer STATUSCODE = 200;
    Public Static Final Integer VALIDPHONELENGTH = 20;
    Public Static Final Integer ENCRYPTINTEGER= 256;
    Public Static Final String ERRORMESSAGE = 'An issue was received while saving the record. Please try again or notify support team in case of repeating.';
    Public Static Final String ERRORMESSAGERETRIVE = 'An issue was received while retriving the record. Please try again or notify support team in case of repeating.';
    Public Static Final String POSTTEXTVALUE= 'POST';
    Public Static Final String CONTENTTYPETEXT= 'content-type';
    Public Static Final String APPPLICATIONJSONTEXT= 'application/json'; 
    Public Static Final String CLIENTIDTEXT= 'client_id';
    Public Static Final String CLIENTSECRETTEXT= 'client_secret';
    Public Static Final String CONTACTDETAILURL='/apex/FS_ContactDetailPage?id=';
    Public Static Final String CONTACTEDITURL ='/apex/FS_ContactDetailPage?id=';
    Public Static Final String POSITIONTEXT ='Position';
    Public Static Final String STATETEXT='State';
    Public Static Final String OWNERIDTEXT='OwnerId';
    Public Static Final String OWNERNAMETEXT='OwnerName';
    Public Static Final String ACCOUNTIDTEXT='AccountId';
    Public Static Final String ACCOUNTNAMETEXT='AccountName';
    Public Static Final String BLANKTEXT='';
    Public Static Final String ERRORMESSAGETEXT='Some error occurred Please contact your Administrator';
    Public Static Final String SITELEADID='?siteLeadId=';
    Public Static Final String CONTENTTYPE='content-type';
    Public Static Final String APPLICATIONJSON='application/json';
    Public Static Final String GETTEXTVALUE= 'GET';
    Public Static Final String POSITIONTEXTVALUE= 'Position';
    Public Static Final String STATETEXTVALUE= 'State';
    Public Static Final String IDTEXTFORACCOUNT = 'Id';
    Public Static Final String DECISIONMAKER = 'DecisionMaker';   
    Public Static Final String ENCRYPTTEXT='AES256'; 
    Public Static Final String TRUETEXT='true';    
    Public Static Final String ERRORTRYAGINTEXT='Please try again';
    Public Static Final String ERRORENTERVALUETEXT='Please enter value';
    Public Static Final String MODEEDITTEXT= '&mode=edit'; 
    Public Static Final String CODEERROR=  'ErrorCode';
    Public Static Final String ZEROTEXT=  '0';
    Public Static Final String THREEHUNTEXT= '300';
    Public Static Final String TELEPHONETEXT= 'Entered Telephone Number already exists in our Database.';
    Public Static Final String PERSONALPHONETEXT= 'personalPhoneNumber';
    Public Static Final String WORKPHONETEXT= 'workPhoneNumber';
    Public Static Final String MOBILEPHONETEXT= 'Mobile';
    Public Static Final String CODEPOSTALTEXT= 'PostalCode';
    Public Static Final String MYEMAILTEXT= 'Email';
    Public Static Final String MYTELEPHONETEXT= 'Telephone';
    Public Static Final String MYSAVETEXT= 'Save';
    Public Static Final String MYOWNERTEXT= 'Owner';
    Public Static Final String MYLASTNAMETEXT= 'Last Name';
    Public Static Final String MYTRUETEXT= 'true';
    Public Static Final String MODETEXT= 'mode';
    Public Static Final String EDITTEXT= 'edit';
    
   
    
    
    
}