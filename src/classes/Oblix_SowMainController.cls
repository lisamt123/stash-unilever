/*****************************************************************************************
* @author       Slavko Skular
* @date         2016-02-02
* @description  This class controls Oblix_SOWMain page
*
*    --------------------------------------------------------------------------
*    Developer                  Date                Description
*    --------------------------------------------------------------------------
*   
*    Slavko Skular              2016-02-23          Created

******************************************************************************************/
public with sharing class Oblix_SowMainController extends Oblix_SWOPparentController {

    public String selectedSowId {get; set;}

    public Boolean can_create_sow {
        get{
            return Oblix_PermissionHandler.canCreateSOW();
        }
    }

    public List<List<SOWWrapper>> liliso_sow {
        get{
            if(liliso_sow == null){
                liliso_sow = getAllSOWRecords();
            }
            return liliso_sow;
        } set;
    }

    /*******************************************************************************
    * @author       Slavko Skular
    * @date         2016-02-02
    * @description  top link on the page exists SWOP app
    ********************************************************************************/
    public Pagereference redirectToSOWDetailPage() {
        
        Pagereference meNewPage = Page.Oblix_SOWMainDetail;
        meNewPage.getParameters().put('sowId', selectedSowId);
        return meNewPage;

    }

    /*******************************************************************************
    * @author       Slavko Skular
    * @date         2016-02-23
    * @description  redirect to a create new SOW page
    ********************************************************************************/
    public pageReference createSOWAction() {
        PageReference mypageViewSow = Page.Oblix_SOWCreate;
        return mypageViewSow;
    }

    /*******************************************************************************
    * @author       Slavko Skular
    * @date         2016-02-23
    * @description  returns list of all SOWs in the system to display in homepage
                    table
    ********************************************************************************/
    private List<List<SOWWrapper>> getAllSOWRecords(){

        List<List<SOWWrapper>> sowLists = new List<List<SOWWrapper>>();

        //List<String> fields = Oblix_Utils.getAllFieldsInFieldsSet('Marketing_SOW__c', 'Oblix_SOW_Main');
        List<String> fields = new List<String>{'Id', 'Name', 'Brand_Name__c', 'SmallProductCategory__r.Name', 'Agency_Name__c', 'LastModifiedDate', 'SOW_Status__c', 'Oblix_Current_FY_Total__c', 'Approved_version__c'};
        String soqlString = buildSOQLquery(fields, 'Marketing_SOW__c', null, null, null, null);
        
        for(List<Marketing_SOW__c> sowList: Database.query(soqlString)){
            //sowLists.add(sowList);
            List<SOWWrapper> sowWrapperList = new List<SOWWrapper>();
            for(Marketing_SOW__c sow : sowList){
                SOWWrapper w = new SOWWrapper(sow, Oblix_PermissionHandler.canSeeFinancialField(sow.SOW_Status__c, sow.Approved_version__c));
                sowWrapperList.add(w);
            }
            sowLists.add(sowWrapperList);
        }

        return sowLists;

    }

    public class SOWWrapper {
        public Marketing_SOW__c sow {get; set;}
        public Boolean disaplyFinancialData {get; set;}

        SOWWrapper(Marketing_SOW__c pSow, Boolean pDisplayFinancialData){
            sow = pSow;
            disaplyFinancialData = pDisplayFinancialData;
        }
    }
}