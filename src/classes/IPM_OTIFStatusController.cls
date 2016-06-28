/****************************************************************************************************************************
   @Author: Cognizant
   @Name: IPM_OTIFStatusController
   @Created Date: 19/02/2015
   @Description: To Display OTIF Questions in Project Document Section Editor Page
   @Version: 1.0
   @Reference: IPM_OTIFSectionStatus,IPM_OTIFStatusTable,IPM_OTIFStatusTableVIew component
*/
public with sharing class IPM_OTIFStatusController{
    public Id projDocSecId{get;set;}   
    public Id secConId{get; set;} //Contains Project Document Section Content Id 
    public string status{get; set;} //Contains OTIF Question Status 
    public IPM_Project_Document_Section_Content__c secCon{get; set;} //Contains Project Document Section Content(OTIF Section) Record for Updation 
    public boolean Iseditable{get;set;} //To enable Read or Editable
    public ID projectId{get;set;} //Contains Project Id 
    public IPM_Project_Document_Section__c projDocSec{get;set;} //Contains Project Document Section Record
    public String otifType{get; set;} //Indicates OTIF Table or Section
    public Map<Id,IPM_Project_Document_Section_Content__c> readOnlyOTIFContentMap{get;set;}
    //For exception handling
    private static final string UPDATE_OTIF_STATUS_STR='updateOTIFStatus';
    private static final string SHOW_SECTION_CONTENT_STR='showSectionContent';
    private static final String PROJ_DOC_SEC_ID='projDocSecId';
    private static final string IPM_OTIFSTATUSCONTROLLER_STR=IPM_OTIFStatusController.class.getName();
    
    /************************************************************************************************************************
    *  Description For Displaying OTIF Questions and Status
    *  @name showSectionContent
    *  @param none
    *  @return void
    *  @throws query exception
    */
    public IPM_OTIFStatusController()
    {
        readOnlyOTIFContentMap = new Map<Id,IPM_Project_Document_Section_Content__c>();
    }
    public List<IPM_Project_Document_Section_Content__c> getSecConList()
    {
        IPM_IECompatible.ieFix();//For IE Compatibility
        projectId=ApexPages.currentPage().getParameters().get(IPM_ConstantUtils.SF_ID);
        projDocSecId = ApexPages.currentPage().getParameters().get(PROJ_DOC_SEC_ID);
        List<IPM_Project_Document_Section_Content__c> secConList = new List<IPM_Project_Document_Section_Content__c>();
        String query=IPM_ConstantUtils.BLANK;
        try{
            //Retrieving Project Document Section (OTIF Section) Record
            if(projDocSecId !=null )
            {
            projDocSec=[SELECT Id,IPM_Section_Sequence__c,IPM_Master_Section_External_Id__c FROM IPM_Project_Document_Section__c WHERE Id=:projDocSecId];
            
            //For Displaying OTIF Questions and Status Based on Type (Section or Table)
            query='SELECT Id,IPM_OTIF_No_of_Status__c,IPM_OTIF_Measure__c,IPM_OTIF_Responsibility__c,IPM_OTIF_Status__c,IPM_Project_Document_Section__c,IPM_Project_Document_Section__r.IPM_Master_Section_External_Id__c,IPM_Section_type__c,IPM_OTIF_HelpText_Red__c,IPM_OTIF_HelpText_NA__c,IPM_OTIF_HelpText_Green__c,IPM_OTIF_HelpText_Amber__c,IPM_Section_Number__c,IPM_OTIF_Sequence__c,IPM_Section_Id__c,IPM_Section_Name__c,Section_Content_Ext_Id__c,BETCurrentStatus__c,DependentFieldAPIName__c,IPM_Project_BETStatus__c,IPM_OTIF_Question_Help_Text__c FROM IPM_Project_Document_Section_Content__c'; 
              if(otifType==IPM_ConstantUtils.OTIF_TABLE)
              {
                secConList=Database.query(query+'  WHERE IPM_Project_Document_Section__c=\''+ string.escapeSingleQuotes(projDocSecId) +'\' '+' order by IPM_OTIF_Sequence__c ASC');
            }
              else if(otifType==IPM_ConstantUtils.OTIF_SECTION)
              {
                secConList=Database.query(query+'  WHERE IPM_Section_Id__c=\''+ string.escapeSingleQuotes(projDocSecId) +'\' '+' order by IPM_OTIF_Sequence__c ASC');                           
            }
            
                     
            			for(IPM_Project_Document_Section_Content__c docSectionContent : secConList)
            		{       		
                  String dependentAPIName = docSectionContent.DependentFieldAPIName__c;       
                  if(String.isNotBlank(dependentAPIName))
            				{
                      String value  = (String)docSectionContent.get(dependentAPIName);
                      docSectionContent.IPM_OTIF_Status__c = value;
                      docSectionContent.IPM_Content_Type__c = IPM_ConstantUtils.OTIF_CONTENT_TYPE;
                      readOnlyOTIFContentMap.put(docSectionContent.Id,docSectionContent);
	
            		}
        		}	
            }
                             
        }
        catch (QueryException ex) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_OTIFSTATUSCONTROLLER_STR,
                SHOW_SECTION_CONTENT_STR,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
        }
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_OTIFSTATUSCONTROLLER_STR,
                SHOW_SECTION_CONTENT_STR,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
        }
        return secConList;  
    }
    
    /************************************************************************************************************************
    *  Description For Updating OTIF Question Answer Status
    *  @name updateOTIFStatus
    *  @param none
    *  @return void
    *  @throws dml exception
    */
    public void updateOTIFReadOnlyStatus()
    {
        //To Update OTIF Question Status
        try
        {
            if(!readOnlyOTIFContentMap.isEmpty())
            {
               update readOnlyOTIFContentMap.values(); 
            }
        }
        catch(DmlException ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_OTIFSTATUSCONTROLLER_STR,
                UPDATE_OTIF_STATUS_STR,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
        }
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_OTIFSTATUSCONTROLLER_STR,
                UPDATE_OTIF_STATUS_STR,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
        }
    }
    /************************************************************************************************************************
    *  Description For Updating OTIF Question Answer Status
    *  @name updateOTIFStatus
    *  @param none
    *  @return void
    *  @throws dml exception
    */
    public void updateOTIFStatus()
    {
        //To Update OTIF Question Status
        try
        {
            if(String.isNotBlank(secConId))
            {
                secCon=new IPM_Project_Document_Section_Content__c();
                secCon.Id=secConId;
                secCon.IPM_OTIF_Status__c=status;
                secCon.IPM_Content_Type__c = IPM_ConstantUtils.OTIF_CONTENT_TYPE;
                update secCon;
            }
        }
        catch(DmlException ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_OTIFSTATUSCONTROLLER_STR,
                UPDATE_OTIF_STATUS_STR,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
        }
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_OTIFSTATUSCONTROLLER_STR,
                UPDATE_OTIF_STATUS_STR,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
        }
    }
}