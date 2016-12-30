/**
 * This class contains Data set up for Sales Organization
 * @see     UserSetSalesOrganizationTest.cls
 * @author  susmita.a.kar@accenture.com
 * @version 2015-10-16  susmita.a.kar@accenture.com     creation
 * Note : Sales Org uses a global picklist which must be deployed with data in target environment before running
          Sales Org dependent class.
 */
@isTest
public with Sharing class UL_SalesOrgTestFactory {

    //Default Sales_Organization__c
    public static ACCL__Sales_Organization__c defaultSalesOrg;
    
    //Language Master Values enum to be used in test class
  public enum LANGUAGE{en,fr,es,de,it}
  //Language_Postfix values
  public static final string LANG_1 = 'Language1';
  public static final string LANG_2 = 'Language2';
  public static final string LANG_3 = 'Language3';
  public static final string LANG_4 = 'Language4';

    /**This function is for getting default SalesOrg Data 
    *  @name getDefaultSalesOrg
    *  @param No parameters
    *  @return Sales Org
    */
    public static ACCL__Sales_Organization__c getDefaultSalesOrg() {
        if( defaultSalesOrg == null ){
            defaultSalesOrg = insertSalesOrg();
        }
        return defaultSalesOrg;
    }

     /**This function is for inserting default SalesOrg Data 
    *  @name getDefaultSalesOrg
    *  @param No parameters
    *  @return Sales Org
    */
    public static ACCL__Sales_Organization__c insertSalesOrg()
    {
        ACCL__Sales_Organization__c sOrg = buildSalesOrg();
        insert sOrg;
        return sOrg;
    }

    /**This function is for building default SalesOrg Data 
    *  @name getDefaultSalesOrg
    *  @param No parameters
    *  @return Sales Org
    */
    public static ACCL__Sales_Organization__c buildSalesOrg() {
        return buildSalesOrgList()[0];
    }

    /**This function is for building List of Sales Org data
    *  @name buildSalesOrgList
    *  @param No parameters
    *  @return list of Sales Org
    */
    public static List<ACCL__Sales_Organization__c> buildSalesOrgList()
    {
        List<ACCL__Sales_Organization__c> listSalesOrg = new List<ACCL__Sales_Organization__c>();

        for(String salesOrg: UL_UserTestFactory.getSalesOrg())
        {
            ACCL__Sales_Organization__c sOrg = new ACCL__Sales_Organization__c();
            sOrg.Name = salesOrg;
            sOrg.ACCL__Currency__c = 'US Dollar';
            sOrg.ACCL__Default_Price_Type__c = 'Factory';
            sOrg.ACCL__Default_Price_List_Type__c = 'Direct Customers';
            sOrg.ACCL__Description_Language_1__c = salesOrg +  '(Engish)';

            //set the language using enums
            sOrg.ACCL__Language_1__c = LANGUAGE.en.name();
            sOrg.ACCL__Language_2__c = LANGUAGE.de.name();
            sOrg.ACCL__Language_3__c = LANGUAGE.es.name();
            sOrg.ACCL__Language_4__c = LANGUAGE.fr.name();
            listSalesOrg.add(sOrg);
        }

        return listSalesOrg;
    }
     /**This function is for inserting List of Sales Org data
    *  @name buildSalesOrgList
    *  @param No parameters
    *  @return list of Sales Org
    */
    public static List<ACCL__Sales_Organization__c> insertSalesOrgList()
    {
        List<ACCL__Sales_Organization__c> listSalesOrg =  buildSalesOrgList();
        insert listSalesOrg;
        return listSalesOrg;
    }
     /**This function is for inserting Sales Org data for call planning
    *  @name insertSalesOrgData
    *  @param No parameters
    *  @return Sales Org
    */
    public static ACCL__Sales_Organization__c insertSaleOrgData(String firstDayOfWeek,String firstWeekOfYear ) {
        ACCL__Sales_Organization__c salesOrg = new ACCL__Sales_Organization__c();
        salesOrg.Name='global';
        salesOrg.ACCL__First_Day_Of_Week__c=firstDayOfWeek;
        salesOrg.ACCL__Description_Language_1__c='English';
        salesOrg.ACCL__First_Week_Of_Year__c=firstWeekOfYear;
        salesOrg.ACCL__Global_Sales_Org__c=true;
        insert salesOrg;
        return salesOrg;
    }
     /**This function is for inserting Sales Org data for call planning
    *  @name insertSalesOrgData
    *  @param No parameters
    *  @return Sales Org
    */
    public static ACCL__Sales_Organization__c insertSaleOrgData() {
        ACCL__Sales_Organization__c salesOrg = new ACCL__Sales_Organization__c();
        salesOrg.Name='global';
        salesOrg.ACCL__First_Day_Of_Week__c='1';
        salesOrg.ACCL__Description_Language_1__c='English';
        salesOrg.ACCL__First_Week_Of_Year__c='0';
        salesOrg.ACCL__Global_Sales_Org__c=false;
        insert salesOrg;
        return salesOrg;
    }
    public static ACCL__Consider_Default_SalesOrg__c insertDefaultSalesOrg() {
        ACCL__Consider_Default_SalesOrg__c defaultsales = new ACCL__Consider_Default_SalesOrg__c();
        defaultsales.ACCL__Consider_Global__c = True;
        insert defaultsales;
        return defaultsales;
    }

    public static ACCL__Sales_Organization__c insertGlobalSalesOrg(String Name,String Currency1){
            ACCL__Sales_Organization__c sOrg = new ACCL__Sales_Organization__c();
            sOrg.Name = Name;
            sOrg.ACCL__Currency__c = Currency1;
            sOrg.ACCL__Default_Price_Type__c = 'Factory';
            sOrg.ACCL__Default_Price_List_Type__c = 'Direct Customers';
            sOrg.ACCL__Description_Language_1__c = Name + '(Engish)';
            sOrg.ACCL__Global_Sales_Org__c = true;

            //set the language using enums
            sOrg.ACCL__Language_1__c = LANGUAGE.en.name();
            sOrg.ACCL__Language_2__c = LANGUAGE.de.name();
            sOrg.ACCL__Language_3__c = LANGUAGE.es.name();
            sOrg.ACCL__Language_4__c = LANGUAGE.fr.name();
            insert sOrg; 
            return sOrg;
    }

    public static ACCL__Sales_Organization__c insertSalesOrg(String Name,String Currency1){
            ACCL__Sales_Organization__c sOrg = new ACCL__Sales_Organization__c();
            sOrg.Name = Name;
            sOrg.ACCL__Currency__c = Currency1;
            sOrg.ACCL__Default_Price_Type__c = 'Factory';
            sOrg.ACCL__Default_Price_List_Type__c = 'Direct Customers';
            sOrg.ACCL__Description_Language_1__c = Name + '(Engish)';

            //set the language using enums
            sOrg.ACCL__Language_1__c = LANGUAGE.en.name();
            sOrg.ACCL__Language_2__c = LANGUAGE.de.name();
            sOrg.ACCL__Language_3__c = LANGUAGE.es.name();
            sOrg.ACCL__Language_4__c = LANGUAGE.fr.name();
            insert sOrg; 
            return sOrg;
    }
}