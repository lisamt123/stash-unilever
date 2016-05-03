/*********************************************************************************************************
Class Name      :       BC_BrandCentreHomeTabController 
Class Desc.       :       Controller class for VF page: BC_BrandCentreHomeTabPage
Author                 :       Accenture India
**********************************************************************************************************/
public class BC_BrandCentreHomeTabController {
    /** Description: Creates the url for redirection to another page
      * Return Type: Page Reference
      */
    public PageReference Redirect(){
        uw_Custom_Setting__c mc = uw_Custom_Setting__c.getvalues('ID_FOR_BRAND_CENTRE_HOME_PAGE');
        uw_Custom_Setting__c mc1 = uw_Custom_Setting__c.getvalues('PATH_FOR_BRAND_CENTRE_HOME_PAGE');
        PageReference pgreference = new PageReference(mc1.Text_Value__c + mc.Text_Value__c); 
        pgreference.setRedirect(true);
        return pgreference;
    }  
}