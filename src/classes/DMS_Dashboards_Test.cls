/**********************************************************************
Name: DMS_Hexagon_CC
Copyright © 2016 Salesforce
====================================================== 
====================================================== 
Purpose: 
Class used to test the class DMS_Dashboards_CC
====================================================== 
======================================================
History 

VERSION: 1.0
AUTHOR: DIMITRI M. SANTANA
DATE :26/05/2016
Description: INITIAL DEVELOPMENT

***********************************************************************/
@isTest
public class DMS_Dashboards_Test {

    /*******************************************************************
    * Purpose: test the change dashboard  
    ********************************************************************/
    public static testMethod void testChangeDashboard(){
        DMS_Dashboards_CC dash = new DMS_Dashboards_CC();                         
        dash.changeDashboard();
        
        System.assert(!dash.exibirEco);
        System.assert(dash.exibirImpac); 
        
        dash.changeDashboard();
        
        System.assert(dash.exibirEco);
        System.assert(!dash.exibirImpac);
    }
}