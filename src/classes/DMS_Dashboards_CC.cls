/**********************************************************************
Name: DMS_Hexagon_CC
Copyright © 2016 Salesforce
====================================================== 
====================================================== 
Purpose: 
Class used to constructor of visual force DMS_Hexagono
====================================================== 
======================================================
History 

VERSION: 1.0
AUTHOR: DIMITRI M. SANTANA
DATE :26/05/2016
Description: INITIAL DEVELOPMENT

***********************************************************************/

public class DMS_Dashboards_CC 
{
    public boolean exibirEco {get;set;}
    public boolean exibirImpac {get;set;}
    
    public DMS_Dashboards_CC()
    {
        exibirEco = true;
        exibirImpac = false;
    }
      
   /*******************************************************************
    * Purpose: Change report for display in visualforce
    ********************************************************************/
    public void changeDashboard()
    {       
        exibirEco = !exibirEco;
     	exibirImpac = !exibirImpac;
       
    }
}