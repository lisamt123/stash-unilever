/****************************************************************************
 * ClassName: CustomLookupSelectionController
 * Description: Class is Invoked When a Lookup Icon is clicked on Send Email
 *              page to select the contacts
 * Author: Accenture Offshore Team
 * *************************************************************************/
public with sharing class FAU_CustomLookupSelectionController {
   
    public List < FAU_Participant__c> results {
        get;
        set;
    } 
    // search results
    public string searchString {
        get;
        set;
    } // search keyword
    public string ObjectName {
        get;
        set;
    }
    public String sObjectType {
        get;
        set;
    }
    public String ProgramID {get; set; }
    PRIVATE STATIC FINAL String PARAM = 'ObjType';
    PRIVATE STATIC FINAL String PARAM1 = 'frm';
    PRIVATE STATIC FINAL String PARAM2 = 'txt';
    //PRIVATE STATIC FINAL String QURY = 'select id, name ,Email,Phone from ';
    PRIVATE STATIC FINAL String QURY = 'select id, name ,Email,Phone from ';
    //PRIVATE STATIC FINAL String QURY1 = ' where Email != null';
    PRIVATE STATIC FINAL String QURY1 = ' where Email != null';
    PRIVATE STATIC FINAL String QURY2 = ' AND name LIKE \'%';
    PRIVATE STATIC FINAL String QURY3 = '%\'';
    PRIVATE STATIC FINAL String QURY4 = ' limit 1000';
    
  /**************************************************************************
     * MethodName: FAU_CustomLookupSelectionController 
     * ReturnType: 
     * param: 
     * Description: This method is used to get the param passed in the url and fetch
     *              contacts.
  ***********************************************************************************/
    public FAU_CustomLookupSelectionController () {

        ObjectName = System.currentPageReference().getParameters().get(PARAM);
        ProgramID = ApexPages.currentPage().getParameters().get('id');
        system.debug('+++++++++Program Id+++++++++++'+ProgramID );
        runSearch();
    }

    /********************************************************************************
     * MethodName: search
     * ReturnType: PageReference
     * param: void
     * Description: This Method is used to fire a Search query and show the results
   ***********************************************************************************/
    public PageReference search() {
        runSearch();
        return null;
    }

   /********************************************************************************
     * MethodName: runSearch
     * ReturnType: PageReference
     * param: void
     * Description: This Method is used to fire a Search query and show the results
   ***********************************************************************************/
    private void runSearch() {
        // TODO prepare query string for complex serarches & prevent injections
        sObjectType = System.currentPageReference().getParameters().get(PARAM);
        results = performSearch(searchString);
        
    }

   /********************************************************************************
     * MethodName: performSearch
     * ReturnType: List of SObject
     * param: String
     * Description: This Method is used to fire a Search query and fetch the results
   ***********************************************************************************/ 
    private List < Sobject > performSearch(string searchString) {
        sObjectType = System.currentPageReference().getParameters().get(PARAM);
        /*String soql = QURY + sObjectType + QURY1;
        if (String.isNotBlank(searchString)){
                soql =  soql + QURY2 + searchString + QURY3;
        }   
        soql = soql + QURY4;*/
        String soql = 'SELECT FAU_Email_Address__c,FAU_User__r.Name,PA_Email_and_PA_Email__c,FAU_First_Name__c,FAU_Invite_State__c,FAU_Last_Name__c,Id,Name,FAU_Mobile_Number__c FROM FAU_Participant__c WHERE FAU_Program_Wave__c =\''+ProgramID+'\'';
         
         system.debug('----------soql --------->'+soql );
        system.debug('----------SOQL Result --------->'+database.query(soql) );
        return database.query(soql);

    }


   /********************************************************************************
     * MethodName: getFormTag
     * ReturnType: String
     * param: Void
     * Description: This Method returns the param value which is used in VF page
     *              to return to parent page
   ***********************************************************************************/
    public string getFormTag() {
        return System.currentPageReference().getParameters().get(PARAM1);
    }

   /********************************************************************************
     * MethodName: getTextBox
     * ReturnType: String
     * param: void
     * Description: his Method returns the param value which is used in VF page
     *              to return to parent page
   ***********************************************************************************/
    public string getTextBox() {
        return System.currentPageReference().getParameters().get(PARAM2);
    }

}