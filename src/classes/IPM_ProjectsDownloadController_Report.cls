/******************************************** 
*@Author:Cognizant
*@Date: November 2014
*@Description : To download as an excel 
*Referring in  IPM_ProjectsDownloadController_Report
*********************************************/

public with sharing class IPM_ProjectsDownloadController_Report{
    
    public String downloadExcel { get; set; } // To download as an excel
    private static final String CLASS_NAME = 'IPM_ProjectsDownloadController_Report';
    
    /***************************************************************
*@Description : To downlaod as an excel and redirect to excel page
****************************************************************/
    
    
    public PageReference downloadExcel() {
        try{
            return new PageReference(IPM_Utils.Reports);
        }catch(Exception ex)
        {
            ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,IPM_Utils.Invalidproject);
            ApexPages.addMessage(myMsg); 
            return null;
        }
    }
    
    
    /***************************************************************
*@Description :Constructor to fetch the details of the report
****************************************************************/
    
    
    public transient List<ProjectWrapper> lstProjectWrap{get; set;} // To initialize the projectswrap
    
    public pageReference reportspage(){
        try{
            
            Set<string> setOfYear = new Set<string>(); // Setting the years to pull the report
            setOfYear.add(IPM_Utils.n1); // Getting the n Year
            setOfYear.add(IPM_Utils.Y1); // Getting the Year 1
            setOfYear.add(IPM_Utils.y2012); // Getting for 2012 records
            setOfYear.add(IPM_Utils.y2013);  // Getting for 2013 records
            setOfYear.add(IPM_Utils.y2014);  // Getting for 2014 records
            setOfYear.add(IPM_Utils.y2015);  //Getting for 2015 records
            setOfYear.add(IPM_Utils.y2016);  //Getting for 2016 records
            setOfYear.add(IPM_Utils.y2017);   //Getting for 2017 records
            setOfYear.add(IPM_Utils.y2018);   //Getting for 2018 records
            setOfYear.add(IPM_Utils.y2019);   //Getting for 2019 records
            setOfYear.add(IPM_Utils.y2020);    //Getting for 2020 records  
            setOfYear.add(IPM_Utils.y2021);    //Getting for 2021 records
            
            Set<string> setOfYear1 = new Set<string>(); // Setting the Next Years
            setOfYear1.add(IPM_Utils.n0); // Getting the next set for Y1
            setOfYear1.add(IPM_Utils.n1); // Getting the next set foe Y2
            setOfYear1.add(IPM_Utils.n2);  // Getting the next set for Y3
            setOfYear1.add(IPM_Utils.n3);  //// Getting the next set for Y4
            
            
            // To query the project obj
            
            List<IPM_Project__c> lstProjects = [Select Project_External_ID__c,Name,IPM_Parent_Project__c,
                                                IPM_Project_Leader__c,Deputy_Project_Leader__c,IPM_Rollout_Status__c,
                                                IPM_Finance_Member__c,IPM_Category_Text__c,IPM_Phase__c,IPM_Brand_Positioning__c,
                                                IPMProject_Span__c, IPMProject_Type__c,IPM_No_of_Country_Rollouts__c,IPM_Threshold_Value__c,IPM_Company_Card__c,IPM_Clustering__c,
                                                IPM_Answer_of_Q1__c, IPM_Answer_of_Q2__c, Exempt_from_Threshold__c, IPM_Answer_of_Q3__c,IPM_Strategic_Intent__c,
                                                IPM_Target_Launch_Year__c,IPM_Target_Launch_Month__c,IPM_Actual_Launch_Date__c, IPM_Actual_Launch_Month__c,IPM_Actual_Launch_Year__c,IPMPlatform__c,IPM_Project_Type__c,
                                                IPM_Project_Description__c, CreatedDate,
                                                (Select id,IPM_Status__c,Market_Cluster_Name__c from IPM_Project_Rollout__r where Market_Cluster_Name__c != null),
                                                (Select id,Name,IPM_Due_Date__c,IPM_Type_of_gate__c,IPM_Completed_on__c,
                                                 IPM_Actual_Target_Launch_Year__c,IPM_Target_Launch_Year__c,IPM_Target_Launch_Month__c,IPM_Proposed_Date__c,IPM_Actual_Target_Launch_Month__c
                                                 from IPM_Milestones__r where IPM_Type_of_Milestone__c =: IPM_Utils.Standard) 
                                                from IPM_Project__c where Is_Archieved__c = false];
            
            
            // Mapping the financila year records
            map<id,IPM_Financial_Year__c> frmap = new map<id,IPM_Financial_Year__c>([Select id,Name,Financial_External_ID__c,IPM_Financial__r.Parent_Project__r.name , IPM_Financial__r.Regional_Project__r.name, IPM_Financial__r.Local_Project__r.name,IPM_Financial__r.Parent_Project__c,IPM_Financial__r.Business_Impact_Global__c,IPM_Financial__r.Business_Impact_Regional__c,IPM_Financial__r.Business_Impact_Local__c,IPM_Financial__r.Threshold__c,IPM_Financial__r.Misaligned__c,Advertising_Promotions_Global__c,Advertising_Promotions_Regional__c,Advertising_Promotions_Local__c,IPM_Financial__r.Regional_Project__c,IPM_Financial__r.Local_Project__c,IPM_Financial__c ,Year__c ,Gross_Profit_Global__c,Gross_Profit_Regional__c,Gross_Profit_Local__c,Turnover_Global__c,Turnover_Local__c,Turnover_Regional__c,Year_Type__c,PL_Type__c from IPM_Financial_Year__C where IPM_Financial__r.Parent_Project__c in: lstProjects]); //  and Name IN: setOfYear and Year__c IN: setOfYear1
            
            // Mapping the country obj
            List<IPM_Country__c> lstIpmCountry=[SELECT Country_Code__c,Country_Name__c,IPM_Project__c,IPM_Project__r.IPMProject_Span__c FROM IPM_Country__c WHERE IPM_Project__c IN : lstProjects];
            Map<Id, List<IPM_Country__c>> mpIpmCountry = new Map<Id, List<IPM_Country__c>>(); 
            for(IPM_Country__c country:lstIpmCountry){
                if(country.IPM_Project__r.IPMProject_Span__c != IPM_Utils.valueGlobal && country.Country_Name__c != null){
                    if(!mpIpmCountry.containsKey(country.IPM_Project__c)){
                        mpIpmCountry.put(country.IPM_Project__c, new List<IPM_Country__c>{country});
                    }
                    else{
                        List<IPM_Country__c> lstCont = mpIpmCountry.get(country.IPM_Project__c);
                        lstCont.add(country);
                        mpIpmCountry.put(country.IPM_Project__c, lstCont);
                    }
                }
            }
            
            // Quering the Financial year records for projects
            
            Map<Id, List<IPM_Financial_Year__c>> mpFinalFin = new Map<Id, List<IPM_Financial_Year__c>>(); 
            for(IPM_Financial_Year__c ify: frmap.values()){
                
                if(ify.IPM_Financial__r.Regional_Project__c != null){
                    
                    if(!mpFinalFin.containsKey(ify.IPM_Financial__r.Regional_Project__c)){
                        mpFinalFin.put(ify.IPM_Financial__r.Regional_Project__c, new List<IPM_Financial_Year__c>{ify});
                    }
                    else{
                        List<IPM_Financial_Year__c> lstYears = mpFinalFin.get(ify.IPM_Financial__r.Regional_Project__c);
                        lstYears.add(ify);
                        mpFinalFin.put(ify.IPM_Financial__r.Regional_Project__c, lstYears);
                    }
                    
                }else if(ify.IPM_Financial__r.Local_Project__c != null){
                    if(!mpFinalFin.containsKey(ify.IPM_Financial__r.Local_Project__c)){
                        mpFinalFin.put(ify.IPM_Financial__r.Local_Project__c, new List<IPM_Financial_Year__c>{ify});
                    }
                    else{
                        List<IPM_Financial_Year__c> lstYears = mpFinalFin.get(ify.IPM_Financial__r.Local_Project__c);
                        lstYears.add(ify);
                        mpFinalFin.put(ify.IPM_Financial__r.Local_Project__c, lstYears);
                    }
                }else {
                    if(!mpFinalFin.containsKey(ify.IPM_Financial__r.Parent_Project__c)){
                        mpFinalFin.put(ify.IPM_Financial__r.Parent_Project__c, new List<IPM_Financial_Year__c>{ify});
                    }
                    else{
                        List<IPM_Financial_Year__c> lstYears = mpFinalFin.get(ify.IPM_Financial__r.Parent_Project__c);
                        lstYears.add(ify);
                        mpFinalFin.put(ify.IPM_Financial__r.Parent_Project__c, lstYears);
                    }
                }
            }
            
           // System.debug('Map Size:'+mpFinalFin);
            lstProjectWrap = new List<ProjectWrapper>();
            for(IPM_Project__c proj: lstProjects){
                ProjectWrapper pWrap = new ProjectWrapper();
                string rolls = '';
                string status ='';
                string geography='';
                
                if(mpIpmCountry.containsKey(proj.Id)){
                    for(IPM_Country__c  pcountry : mpIpmCountry.get(proj.Id)){
                        if(geography == '')
                            geography = pcountry.Country_Name__c;
                        else
                            geography = geography+IPM_Utils.amp+pcountry.Country_Name__c;
                    }
                }
                
                if(geography != null){
                    pWrap.geography = geography;
                }
                
                
                // Querying for project rollouts
                for(IPM_Project_Rollout__c pRoll : proj.IPM_Project_Rollout__r){
                    if(!rolls.contains(pRoll.Market_Cluster_Name__c)){
                        if(rolls == ''){
                            rolls = pRoll.Market_Cluster_Name__c;
                        }
                        else{
                            rolls = rolls+IPM_Utils.amp+pRoll.Market_Cluster_Name__c;
                        }
                    }
                    
                    if(pRoll.IPM_Status__c != null){
                        if(!status.contains(pRoll.IPM_Status__c)){
                            if(status == '')
                                status = pRoll.IPM_Status__c;
                            else
                                status = status +IPM_Utils.amp+pRoll.IPM_Status__c;
                        }
                    }
                }
                pWrap.MasterCluster = rolls;
                pWrap.status =status;
                
                // Quering and initilaizing the vlues for Milestones 
                for(IPM_Milestone__c mile : proj.IPM_Milestones__r){
                    if(mile.IPM_Type_of_gate__c == IPM_Utils.Charter){
                        pWrap.charterDueDate = mile.IPM_Due_Date__c;
                        pWrap.charterCompletedDate = mile.IPM_Completed_on__c;
                        pWrap.charterProposedDate = mile.IPM_Proposed_Date__c;
                        
                    }
                    else if(mile.IPM_Type_of_gate__c == IPM_Utils.Contract){
                        pWrap.contractDueDate = mile.IPM_Due_Date__c;
                        pWrap.contractCompletedDate = mile.IPM_Completed_on__c;
                        pWrap.contractProposedDate = mile.IPM_Proposed_Date__c;
                    }
                    else if(mile.IPM_Type_of_gate__c == IPM_Utils.MarketReady){
                        pWrap.readyDueDate = mile.IPM_Due_Date__c;
                        pWrap.readyCompletedDate = mile.IPM_Completed_on__c;
                        pWrap.readyProposedDate = mile.IPM_Proposed_Date__c;
                    }
                    else if(mile.IPM_Type_of_gate__c == IPM_Utils.MarketDeployment){
                        pWrap.deployDueDate = mile.IPM_Due_Date__c;
                        pWrap.deployCompletedDate = mile.IPM_Completed_on__c;
                        pWrap.deployProposedDate = mile.IPM_Proposed_Date__c;
                    }
                    //else if(mile.IPM_Type_of_gate__c == null && mile.name.contains('Ship to'))
                    else if(mile.IPM_Type_of_gate__c == IPM_Utils.PLELearnings){
                        pWrap.shipToMonth = mile.IPM_Target_Launch_Month__c;
                        pWrap.shipToYear = mile.IPM_Target_Launch_Year__c;
                        pWrap.actualyear = mile.IPM_Completed_on__c;
                    }
                    
                }
                
                if(proj.IPM_Project_Type__c==IPM_Utils.Original){
                    pWrap.isOriginal = true;
                    pWrap.isRollOut = false;
                }
                if(proj.IPM_Project_Type__c==IPM_Utils.Rollout){
                    pWrap.isOriginal = false;
                    pWrap.isRollOut = true;
                }
                
                if(proj.IPMProject_Span__c==IPM_Utils.valueGlobal){
                    pWrap.projecttype = string.valueof(proj.IPMProject_Type__c);
                    pWrap.geography =IPM_Utils.valueGlobal;
                }
                if(proj.IPMProject_Span__c==IPM_Utils.Regional){
                    pWrap.projecttype = string.valueof(proj.IPM_Project_Type__c);
                }
                
                if(proj.IPMProject_Span__c==IPM_Utils.Local){
                    pWrap.projecttype = string.valueof(proj.IPM_Project_Type__c);
                }
                
             //   System.debug('Contains Key:'+mpFinalFin.containsKey(proj.id));
                if(mpFinalFin.containsKey(proj.id)){
                    for(IPM_Financial_Year__c fr : mpFinalFin.get(proj.id)) {  
                    //    system.debug('proj inside the values '+proj.id); 
                        string sFinancial_External_ID = fr.Financial_External_ID__c;
                        if(sFinancial_External_ID.contains(IPM_Utils.CONSOLIDATED)){
                            sFinancial_External_ID = sFinancial_External_ID.substringBefore(IPM_Utils.CONSOLIDATED);
                        }
                        if(fr.IPM_Financial__r.Local_Project__c != null)
                       //     System.debug('sFinancial_External_ID '+sFinancial_External_ID);
                       // System.debug(fr.IPM_Financial__r.Regional_Project__c + fr.IPM_Financial__r.Regional_Project__r.name);
                    //    System.debug(fr.IPM_Financial__r.Local_Project__c + fr.IPM_Financial__r.Local_Project__r.name);
                    //    System.debug(fr.IPM_Financial__r.Parent_Project__c + fr.IPM_Financial__r.Parent_Project__r.name);
                        if((fr.IPM_Financial__r.Regional_Project__c != null &&  fr.IPM_Financial__r.Regional_Project__r.name == sFinancial_External_ID )||
                           (fr.IPM_Financial__r.Local_Project__c != null &&  fr.IPM_Financial__r.Local_Project__r.name == sFinancial_External_ID )||
                           (fr.IPM_Financial__r.Parent_Project__c != null && fr.IPM_Financial__r.Parent_Project__r.name == sFinancial_External_ID)){
                           //    System.debug(proj.IPMProject_Span__c);
                               if(proj.IPMProject_Span__c == IPM_Utils.Local && fr.Name == IPM_Utils.Y1 && fr.Year_Type__c == IPM_Utils.Innovation && fr.PL_Type__c == IPM_Utils.Gross)
                                   pWrap.turnover = string.valueof(fr.Turnover_Local__c);
                               else if(proj.IPMProject_Span__c == IPM_Utils.Regional && fr.Name == IPM_Utils.Y1 && fr.Year_Type__c == IPM_Utils.Innovation && fr.PL_Type__c == IPM_Utils.Gross)
                                   pWrap.turnover = string.valueof(fr.Turnover_Regional__c);
                               else if(proj.IPMProject_Span__c == IPM_Utils.valueGlobal && fr.Name == IPM_Utils.Y1 && fr.Year_Type__c == IPM_Utils.Innovation && fr.PL_Type__c == IPM_Utils.Gross)
                                   pWrap.turnover = string.valueof(fr.Turnover_Global__c); 
                               // innovative
                               
                               if(proj.IPMProject_Span__c == IPM_Utils.Local && fr.Name == IPM_Utils.Y1 && fr.Year_Type__c == IPM_Utils.Innovation && fr.PL_Type__c == IPM_Utils.Incremental)
                               {
                                   pWrap.turnover_ito = fr.Turnover_Local__c;
                                   pwrap.turnover_igp = fr.Turnover_Local__c;
                               }
                               else if(proj.IPMProject_Span__c == IPM_Utils.Regional && fr.Name == IPM_Utils.Y1 && fr.Year_Type__c == IPM_Utils.Innovation && fr.PL_Type__c == IPM_Utils.Incremental)
                               {
                                   pWrap.turnover_ito = fr.Turnover_Regional__c; 
                                   pWrap.turnover_igp  = fr.Turnover_Regional__c; 
                               }   
                               else if(proj.IPMProject_Span__c == IPM_Utils.valueGlobal && fr.Name == IPM_Utils.Y1 && fr.Year_Type__c == IPM_Utils.Innovation && fr.PL_Type__c == IPM_Utils.Incremental)
                               {
                                   pWrap.turnover_ito = fr.Turnover_Global__c;
                                   pWrap.turnover_igp = fr.Gross_Profit_Global__c;  
                               }  
                               // 2012
                               if(proj.IPMProject_Span__c == IPM_Utils.Local && fr.Name == IPM_Utils.y2012 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Gross)
                                   pWrap.turnover_2012 = string.valueof(fr.Turnover_Local__c);
                               else if(proj.IPMProject_Span__c == IPM_Utils.Regional && fr.Name == IPM_Utils.y2012 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Gross)
                                   pWrap.turnover_2012 = string.valueof(fr.Turnover_Regional__c);
                               else if(proj.IPMProject_Span__c == IPM_Utils.valueGlobal && fr.Name == IPM_Utils.y2012 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Gross)
                                   pWrap.turnover_2012 = string.valueof(fr.Turnover_Global__c); 
                               // 2013
                               if(proj.IPMProject_Span__c == IPM_Utils.Local && fr.Name == IPM_Utils.y2013 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Gross)
                                   pWrap.turnover_2013 = string.valueof(fr.Turnover_Local__c);
                               else if(proj.IPMProject_Span__c == IPM_Utils.Regional && fr.Name == IPM_Utils.y2013 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Gross)
                                   pWrap.turnover_2013 = string.valueof(fr.Turnover_Regional__c);
                               else if(proj.IPMProject_Span__c == IPM_Utils.valueGlobal && fr.Name == IPM_Utils.y2013 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Gross)
                                   pWrap.turnover_2013 = string.valueof(fr.Turnover_Global__c); 
                               // 2014
                               if(proj.IPMProject_Span__c == IPM_Utils.Local && fr.Name== IPM_Utils.y2014 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Gross)
                                   pWrap.turnover_2014 = string.valueof(fr.Turnover_Local__c);
                               else if(proj.IPMProject_Span__c == IPM_Utils.Regional && fr.Name == IPM_Utils.y2014 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Gross)
                                   pWrap.turnover_2014 = string.valueof(fr.Turnover_Regional__c);
                               else if(proj.IPMProject_Span__c == IPM_Utils.valueGlobal && fr.Name == IPM_Utils.y2014 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Gross)
                                   pWrap.turnover_2014 = string.valueof(fr.Turnover_Global__c); 
                               // 2015
                               if(proj.IPMProject_Span__c == IPM_Utils.Local && fr.Name == IPM_Utils.y2015 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Gross)
                                   pWrap.turnover_2015 = string.valueof(fr.Turnover_Local__c);
                               else if(proj.IPMProject_Span__c == IPM_Utils.Regional && fr.Name == IPM_Utils.y2015 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Gross)
                                   pWrap.turnover_2015 = string.valueof(fr.Turnover_Regional__c);
                               else if(proj.IPMProject_Span__c == IPM_Utils.valueGlobal && fr.Name == IPM_Utils.y2015 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Gross)
                                   pWrap.turnover_2015 = string.valueof(fr.Turnover_Global__c); 
                               // 2016
                               if(proj.IPMProject_Span__c == IPM_Utils.Local && fr.Name == IPM_Utils.y2016 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Gross)
                                   pWrap.turnover_2016 = string.valueof(fr.Turnover_Local__c);
                               else if(proj.IPMProject_Span__c == IPM_Utils.Regional && fr.Name == IPM_Utils.y2016 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Gross)
                                   pWrap.turnover_2016 = string.valueof(fr.Turnover_Regional__c);
                               else if(proj.IPMProject_Span__c == IPM_Utils.valueGlobal && fr.Name == IPM_Utils.y2016 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Gross)
                                   pWrap.turnover_2016 = string.valueof(fr.Turnover_Global__c); 
                               // 2017
                               if(proj.IPMProject_Span__c == IPM_Utils.Local && fr.Name == IPM_Utils.y2017 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Gross)
                                   pWrap.turnover_2017 = string.valueof(fr.Turnover_Local__c);
                               else if(proj.IPMProject_Span__c == IPM_Utils.Regional && fr.Name == IPM_Utils.y2017 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Gross)
                                   pWrap.turnover_2017 = string.valueof(fr.Turnover_Regional__c);
                               else if(proj.IPMProject_Span__c == IPM_Utils.valueGlobal && fr.Name == IPM_Utils.y2017 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Gross)
                                   pWrap.turnover_2017 = string.valueof(fr.Turnover_Global__c); 
                               //2018
                               if(proj.IPMProject_Span__c == IPM_Utils.Local && fr.Name == IPM_Utils.y2018 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Gross)
                                   pWrap.turnover_2018 = string.valueof(fr.Turnover_Local__c);
                               else if(proj.IPMProject_Span__c == IPM_Utils.Regional && fr.Name == IPM_Utils.y2018 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Gross)
                                   pWrap.turnover_2018 = string.valueof(fr.Turnover_Regional__c);
                               else if(proj.IPMProject_Span__c == IPM_Utils.valueGlobal && fr.Name == IPM_Utils.y2018 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Gross)
                                   pWrap.turnover_2018 = string.valueof(fr.Turnover_Global__c); 
                               //2019
                               if(proj.IPMProject_Span__c == IPM_Utils.Local && fr.Name == IPM_Utils.y2019 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Gross)
                                   pWrap.turnover_2019 = string.valueof(fr.Turnover_Local__c);
                               else if(proj.IPMProject_Span__c == IPM_Utils.Regional && fr.Name == IPM_Utils.y2019 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Gross)
                                   pWrap.turnover_2019 = string.valueof(fr.Turnover_Regional__c);
                               else if(proj.IPMProject_Span__c == IPM_Utils.valueGlobal && fr.Name == IPM_Utils.y2019 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Gross)
                                   pWrap.turnover_2019 = string.valueof(fr.Turnover_Global__c); 
                               //2020
                               if(proj.IPMProject_Span__c == IPM_Utils.Local && fr.Name == IPM_Utils.y2020 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Gross)
                                   pWrap.turnover_2020 = string.valueof(fr.Turnover_Local__c);
                               else if(proj.IPMProject_Span__c == IPM_Utils.Regional && fr.Name == IPM_Utils.y2020 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Gross)
                                   pWrap.turnover_2020 = string.valueof(fr.Turnover_Regional__c);
                               else if(proj.IPMProject_Span__c == IPM_Utils.valueGlobal && fr.Name == IPM_Utils.y2020 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Gross)
                                   pWrap.turnover_2020 = string.valueof(fr.Turnover_Global__c); 
                               // ITO 2012
                               if(proj.IPMProject_Span__c == IPM_Utils.Local && fr.Name == IPM_Utils.y2012 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Incremental)
                               {
                                   pWrap.turnover_ITO2012 = string.valueof(fr.Turnover_Local__c);
                                   pWrap.turnover_IGO2012 = string.valueof(fr.Gross_Profit_Local__c);
                               }
                               else if(proj.IPMProject_Span__c == IPM_Utils.Regional && fr.Name == IPM_Utils.y2012 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Incremental)
                               {
                                   pWrap.turnover_ITO2012 = string.valueof(fr.Turnover_Regional__c);
                                   pWrap.turnover_IGO2012 = string.valueof(fr.Gross_Profit_Regional__c);
                               }
                               else if(proj.IPMProject_Span__c == IPM_Utils.valueGlobal && fr.Name == IPM_Utils.y2012 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Incremental)
                               {
                                   pWrap.turnover_ITO2012 = string.valueof(fr.Turnover_Global__c); 
                                   pWrap.turnover_IGO2012 = string.valueof(fr.Gross_Profit_Global__c); 
                               }
                               // ITO 2013
                               if(proj.IPMProject_Span__c == IPM_Utils.Local && fr.Name == IPM_Utils.y2013 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Incremental)
                               {
                                   pWrap.turnover_ITO2013 = string.valueof(fr.Turnover_Local__c);
                                   pWrap.turnover_IGO2013 = string.valueof(fr.Gross_Profit_Local__c);
                               }
                               else if(proj.IPMProject_Span__c == IPM_Utils.Regional && fr.Name == IPM_Utils.y2013 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Incremental)
                               {   
                                   pWrap.turnover_ITO2013 = string.valueof(fr.Turnover_Regional__c);
                                   pWrap.turnover_IGO2013 = string.valueof(fr.Gross_Profit_Regional__c);
                               }
                               else if(proj.IPMProject_Span__c == IPM_Utils.valueGlobal && fr.Name == IPM_Utils.y2013 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Incremental)
                               {   
                                   pWrap.turnover_ITO2013 = string.valueof(fr.Turnover_Global__c);
                                   pWrap.turnover_IGO2013 = string.valueof(fr.Gross_Profit_Global__c);
                               }
                               // ITO 2014
                               if(proj.IPMProject_Span__c == IPM_Utils.Local && fr.Name == IPM_Utils.y2014 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Incremental)
                               { 
                                   pWrap.turnover_ITO2014 = string.valueof(fr.Turnover_Local__c);
                                   pWrap.turnover_IGO2014 = string.valueof(fr.Gross_Profit_Local__c);
                               }
                               else if(proj.IPMProject_Span__c == IPM_Utils.Regional && fr.Name == IPM_Utils.y2014 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Incremental)
                               {  
                                   pWrap.turnover_ITO2014 = string.valueof(fr.Turnover_Regional__c);
                                   pWrap.turnover_IGO2014 = string.valueof(fr.Gross_Profit_Regional__c);
                               }
                               else if(proj.IPMProject_Span__c == IPM_Utils.valueGlobal && fr.Name == IPM_Utils.y2014 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Incremental)
                               { 
                                   pWrap.turnover_ITO2014 = string.valueof(fr.Turnover_Global__c);
                                   pWrap.turnover_IGO2014 = string.valueof(fr.Gross_Profit_Global__c);
                               }
                               // ITO 2015
                               if(proj.IPMProject_Span__c == IPM_Utils.Local && fr.Name == IPM_Utils.y2015 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Incremental)
                               {  
                                   pWrap.turnover_ITO2015 = string.valueof(fr.Turnover_Local__c);
                                   pWrap.turnover_IGO2015 = string.valueof(fr.Gross_Profit_Local__c);
                               }
                               else if(proj.IPMProject_Span__c == IPM_Utils.Regional && fr.Name == IPM_Utils.y2015 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Incremental)
                               {   
                                   pWrap.turnover_ITO2015 = string.valueof(fr.Turnover_Regional__c);
                                   pWrap.turnover_IGO2015 = string.valueof(fr.Gross_Profit_Regional__c);
                               }
                               else if(proj.IPMProject_Span__c == IPM_Utils.valueGlobal && fr.Name == IPM_Utils.y2015 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Incremental)
                               {   
                                   pWrap.turnover_ITO2015 = string.valueof(fr.Turnover_Global__c);
                                   pWrap.turnover_IGO2015 = string.valueof(fr.Gross_Profit_Global__c);
                               }
                               // ITO 2016
                               if(proj.IPMProject_Span__c == IPM_Utils.Local && fr.Name == IPM_Utils.y2016 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Incremental)
                               {  
                                   pWrap.turnover_ITO2016 = string.valueof(fr.Turnover_Local__c);
                                   pWrap.turnover_IGO2016 = string.valueof(fr.Gross_Profit_Local__c);
                               }
                               else if(proj.IPMProject_Span__c == IPM_Utils.Regional && fr.Name == IPM_Utils.y2016 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Incremental)
                               {  
                                   pWrap.turnover_ITO2016 = string.valueof(fr.Turnover_Regional__c);
                                   pWrap.turnover_IGO2016 = string.valueof(fr.Gross_Profit_Regional__c);
                               }
                               else if(proj.IPMProject_Span__c == IPM_Utils.valueGlobal && fr.Name == IPM_Utils.y2016 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Incremental)
                               {  
                                   pWrap.turnover_ITO2016 = string.valueof(fr.Turnover_Global__c);
                                   pWrap.turnover_IGO2016 = string.valueof(fr.Gross_Profit_Global__c);
                               }
                               // ITO 2017
                               if(proj.IPMProject_Span__c == IPM_Utils.Local && fr.Name == IPM_Utils.y2017 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Incremental)
                               { 
                                   pWrap.turnover_ITO2017 = string.valueof(fr.Turnover_Local__c);
                                   pWrap.turnover_IGO2017 = string.valueof(fr.Gross_Profit_Local__c);
                               }
                               else if(proj.IPMProject_Span__c == IPM_Utils.Regional && fr.Name == IPM_Utils.y2017 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Incremental)
                               { 
                                   pWrap.turnover_ITO2017 = string.valueof(fr.Turnover_Regional__c);
                                   pWrap.turnover_IGO2017 = string.valueof(fr.Gross_Profit_Regional__c); 
                               }
                               else if(proj.IPMProject_Span__c == IPM_Utils.valueGlobal && fr.Name == IPM_Utils.y2017 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Incremental)
                               {
                                   pWrap.turnover_ITO2017 = string.valueof(fr.Turnover_Global__c); 
                                   pWrap.turnover_IGO2017 = string.valueof(fr.Gross_Profit_Global__c); 
                               }
                               // ITO 2018
                               if(proj.IPMProject_Span__c == IPM_Utils.Local && fr.Name == IPM_Utils.y2018 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Incremental)
                               { 
                                   pWrap.turnover_ITO2018 = string.valueof(fr.Turnover_Local__c);
                                   pWrap.turnover_IGO2018 = string.valueof(fr.Gross_Profit_Local__c);
                               }
                               else if(proj.IPMProject_Span__c == IPM_Utils.Regional && fr.Name == IPM_Utils.y2018 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Incremental)
                               {  
                                   pWrap.turnover_ITO2018 = string.valueof(fr.Turnover_Regional__c);
                                   pWrap.turnover_IGO2018 = string.valueof(fr.Gross_Profit_Regional__c);
                               }
                               else if(proj.IPMProject_Span__c == IPM_Utils.valueGlobal && fr.Name == IPM_Utils.y2018 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Incremental)
                               { 
                                   pWrap.turnover_ITO2018 = string.valueof(fr.Turnover_Global__c);
                                   pWrap.turnover_IGO2018 = string.valueof(fr.Gross_Profit_Global__c);
                               }
                               // ITO 2019
                               if(proj.IPMProject_Span__c == IPM_Utils.Local && fr.Name == IPM_Utils.y2019 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Incremental)
                               { 
                                   pWrap.turnover_ITO2019 = string.valueof(fr.Turnover_Local__c);
                                   pWrap.turnover_IGO2019 = string.valueof(fr.Gross_Profit_Local__c);
                               }
                               else if(proj.IPMProject_Span__c == IPM_Utils.Regional && fr.Name == IPM_Utils.y2019 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Incremental)
                               { 
                                   pWrap.turnover_ITO2019 = string.valueof(fr.Turnover_Regional__c);
                                   pWrap.turnover_IGO2019 = string.valueof(fr.Gross_Profit_Regional__c);
                               }
                               else if(proj.IPMProject_Span__c == IPM_Utils.valueGlobal && fr.Name == IPM_Utils.y2019 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Incremental)
                               {
                                   pWrap.turnover_ITO2019 = string.valueof(fr.Turnover_Global__c);
                                   pWrap.turnover_IGO2019 = string.valueof(fr.Gross_Profit_Global__c);
                               }
                               // ITO 2020
                               if(proj.IPMProject_Span__c == IPM_Utils.Local && fr.Name == IPM_Utils.y2020 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Incremental)
                               { 
                                   pWrap.turnover_ITO2020 = string.valueof(fr.Turnover_Local__c);
                                   pWrap.turnover_IGO2020 = string.valueof(fr.Gross_Profit_Local__c);
                               }
                               else if(proj.IPMProject_Span__c == IPM_Utils.Regional && fr.Name == IPM_Utils.y2020 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Incremental)
                               {  
                                   pWrap.turnover_ITO2020 = string.valueof(fr.Turnover_Regional__c);
                                   pWrap.turnover_IGO2020 = string.valueof(fr.Gross_Profit_Regional__c);
                               }
                               else if(proj.IPMProject_Span__c == IPM_Utils.valueGlobal && fr.Name == IPM_Utils.y2020 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Incremental)
                               {
                                   pWrap.turnover_ITO2020 = string.valueof(fr.Turnover_Global__c);
                                   pWrap.turnover_IGO2020 = string.valueof(fr.Gross_Profit_Global__c);
                               }
                               
                               //Y3 iTO
                               
                               if(proj.IPMProject_Span__c == IPM_Utils.Local && fr.Year__c == IPM_Utils.n3 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Incremental)
                               { 
                                   pWrap.y3_ITO = string.valueof(fr.Turnover_Local__c);
                                   
                               }
                               else if(proj.IPMProject_Span__c == IPM_Utils.Regional && fr.Year__c == IPM_Utils.n3 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Incremental)
                               {  
                                   pWrap.y3_ITO  = string.valueof(fr.Turnover_Regional__c);
                                   
                               }
                               else if(proj.IPMProject_Span__c == IPM_Utils.valueGlobal && fr.Year__c == IPM_Utils.n3 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Incremental)
                               {
                                   pWrap.y3_ITO = string.valueof(fr.Turnover_Global__c);
                                   
                               }
                               
                               //Y3 GTO
                               
                               if(proj.IPMProject_Span__c == IPM_Utils.Local && fr.Year__c == IPM_Utils.n3 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Gross)
                               { 
                                   pWrap.y3_GTO = string.valueof(fr.Turnover_Local__c);
                                   
                               }
                               else if(proj.IPMProject_Span__c == IPM_Utils.Regional && fr.Year__c == IPM_Utils.n3 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Gross)
                               {  
                                   pWrap.y3_GTO  = string.valueof(fr.Turnover_Regional__c);
                                   
                               }
                               else if(proj.IPMProject_Span__c == IPM_Utils.valueGlobal && fr.Year__c == IPM_Utils.n3 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Gross)
                               {
                                   pWrap.y3_GTO = string.valueof(fr.Turnover_Global__c);
                                   
                               }
                               
                               // a&p
                               if(proj.IPMProject_Span__c == IPM_Utils.Local && fr.Name == IPM_Utils.y2012 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Incremental)
                               { 
                                   pWrap.turnover_ap2012= string.valueof(fr.Advertising_Promotions_Local__c);
                                   
                               }
                               else if(proj.IPMProject_Span__c == IPM_Utils.Regional && fr.Name == IPM_Utils.y2012 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Incremental)
                               {  
                                   pWrap.turnover_ap2012= string.valueof(fr.Advertising_Promotions_Regional__c);
                                   
                               }
                               else if(proj.IPMProject_Span__c == IPM_Utils.valueGlobal && fr.Name == IPM_Utils.y2012 && fr.Year_Type__c == IPM_Utils.Calendar && fr.PL_Type__c == IPM_Utils.Incremental)
                               {
                                   pWrap.turnover_ap2012= string.valueof(fr.Advertising_Promotions_Global__c);
                                   
                               }
                               
                               //if(sFinancial_External_ID.contains(IPM_Utils.CONSOLIDATED)){
                               if(proj.IPMProject_Span__c == IPM_Utils.valueGlobal){
                                   pWrap.BusinessImpact = fr.IPM_Financial__r.Business_Impact_Global__c;
                                   pWrap.threshold=fr.IPM_Financial__r.Threshold__c;
                               }
                               
                               if(proj.IPMProject_Span__c == IPM_Utils.Regional){
                                   pWrap.BusinessImpact =fr.IPM_Financial__r.Business_Impact_Regional__c;
                                   pWrap.threshold=fr.IPM_Financial__r.Threshold__c;
                               }
                               if(proj.IPMProject_Span__c == IPM_Utils.Local){
                                   pWrap.BusinessImpact =fr.IPM_Financial__r.Business_Impact_Local__c;
                                   pWrap.threshold=fr.IPM_Financial__r.Threshold__c;
                               }
                               
                               
                           }
                    }
                }
                pWrap.proj = proj;
                lstProjectWrap.add(pWrap);
            }
            return null;
        }catch(Exception ex)
        {
            ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,IPM_Utils.Invalidproject);
            ApexPages.addMessage(myMsg); 
            return null;
        }
    }
    
    /***************************************************************
*@Description : Initializing all variables
****************************************************************/
    public class ProjectWrapper{
        public IPM_Project__c proj{get; set;} // Geeting the project obj
        public String BusinessImpact{get; set;} // Initializing for Business Impact
        public string masterCluster{get; set;} // Getting the details for marketcluster value
        public Decimal threshold {get;set;} // Getting the value for threshold
        public Boolean misaligned {get;set;} // Getting the value for misalligned
        public string status{get; set;} // Initilaizing the status
        public String geography {get;set;} // initilaizing the geography
        public string projecttype{get; set;} // Getting the value for projecttype
        public Date charterDueDate{get; set;} // Getting the value for Charter due date
        public Date chartercompletedDate{get; set;} // Getting the value for Chartercompleted date
        public Date contractDueDate{get; set;} // Contract Due date
        public Date charterProposedDate{get; set;} // Value for Charter proposed date
        public Date contractProposedDate{get; set;} // Getting for Contract Proposed date
        public Date readyProposedDate{get; set;} // Getting for MR Proposed date
        public Date deployProposedDate{get; set;} // Getting for MD Proposed date
        public Date contractcompletedDate{get; set;} // Getting for Contract completed date
        public Date readyDueDate{get; set;}  // MR Due date
        public Date readycompletedDate{get; set;} // MD Completed date
        public Date deployDueDate{get; set;} // MD Due date
        public Date deploycompletedDate{get; set;} // MD Completed date
        public boolean isOriginal{get; set;} // Setting the Value to check the original project
        public boolean isRollOut{get; set;} // To check the rollouts
        public string shipToYear{get; set;} // To get the value for Ship year
        public string shipToMonth{get; set;} // Values for ship Month dates
        public Date actualyear{get; set;} // Getting the values for Year
        Public string turnover{get; set;} // Getting the values for Turn over for Financials
        Public decimal turnover_ito{get; set;} // Getting the value for Turnover_ito
        Public decimal  turnover_igp{get; set;} // Turnover for igp column
        Public string turnover_2012{get; set;}  // Turnover for 2012 
        Public string turnover_2013{get; set;} // Turnover for 2013
        Public string turnover_2014{get; set;} // Turnover for 2014
        Public string turnover_2015{get; set;} // Turnover for 2015
        Public string turnover_2016{get; set;} // Turnover for 2016
        Public string turnover_2017{get; set;} // Turnover for 2017
        Public string turnover_2018{get; set;} // Turnover for 2018
        Public string turnover_2019{get; set;} // Turnover for 2019
        Public string turnover_2020{get; set;} // Turnover for 2020
        Public string turnover_ITO2012{get; set;} // Turnover for ITO 2012
        Public string turnover_ITO2013{set;get;} // Turnover for ITO 2013
        Public string turnover_ITO2014{set;get;} // Turnover for ITO 2014
        Public string turnover_ITO2015{set;get;} // Turnover for ITO 2015
        Public string turnover_ITO2016{set;get;} // Turnover for ITO 2016
        Public string turnover_ITO2017{set;get;} // Turnover for ITO 2017
        Public string turnover_ITO2018{set;get;} // Turnover for ITO 2018
        Public string turnover_ITO2019{set;get;} // Turnover for ITO 2019
        Public string turnover_ITO2020{set;get;} // Turnover for ITO 2020
        Public string turnover_IGO2012{set;get;} // Turnover for IGO 2012
        Public string turnover_IGO2013{set;get;} // Turnover for gross profit 2013
        Public string turnover_IGO2014{set;get;} // Turnover for IGP 2014
        Public string turnover_IGO2015{set;get;} // Turnover for Igp 2015
        Public string turnover_IGO2016{set;get;} // Turnover for IGP 2016
        Public string turnover_IGO2017{set;get;} // Turnover for IGP 2017
        Public string turnover_IGO2018{set;get;} // Turnover for IGP 2018
        Public string turnover_IGO2019{set;get;}  // Turnover for IGP 2019
        Public string turnover_IGO2020{set;get;} // Turnover for IGP 2020
        Public string turnover_ap2012{set;get;} // Turnover for Advertizing 2012
        Public string y3_GTO {set;get;} // Y3 Gross profit
        Public string y3_ITO {set;get;} // Y3 Incremental
    }
}