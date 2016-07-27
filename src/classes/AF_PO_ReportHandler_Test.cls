/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_PO_ReportHandler  
@CreateDate : 10/9/2014
@Description : This is a Test class for AF_PO_ReportHandler   class, 
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@isTest(SeeAlldata=false)
public class AF_PO_ReportHandler_Test
{    
    Static Integer IcurrYear = System.Today().year();
    Static string currYear=string.valueof(IcurrYear);
    static user UserForAF_PO_ReportHandler;
    /***********************************************************************************
*  @Description: this method will the test data
*  @name : AF_PO_ReportHandler  
*  @param : none.
*  @return: none.
*************************************************************************************/
    Static testMethod void AF_PO_ReportHandler()
    {
        Test.startTest();
        UserForAF_PO_ReportHandler=AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id,Email FROM user WHERE id=:UserForAF_PO_ReportHandler.id LIMIT 1];
        System.runAs(u)
        { 
            //insert PO Report.
            List<AF_PO_Report__c> poLst =AF_TestFactory_Helper.insertPOReport(true,1);
            List<AF_PO_Report__c> poLstQuery = [SELECT ID FROM AF_PO_Report__c LIMIT 1];
            system.assert(poLstQuery[0].id!=null,'The po report record is inserted');
            system.assertEquals(poLstQuery[0].id!=null,poLst[0].id!=null,'The po report record is inserted');
            AF_PO_ReportHandler  pohand =new AF_PO_ReportHandler ();
            AF_PO_Report__c so = new AF_PO_Report__c();
            AF_PO_Report__c oldso = new AF_PO_Report__c();
            pohand.bulkBefore();
            pohand.beforeInsert(so);
            pohand.beforeUpdate(oldso,so);
            pohand.beforeDelete(so);
            pohand.afterInsert(so);
            pohand.afterUpdate(oldso,so);
            pohand.afterDelete(so);
            pohand.andFinally();
        }
    }
}