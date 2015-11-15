public with sharing class IPM_ProjectsDownloadController{

    public String downloadExcel { get; set; }
    public static final String BLANK_STR = ''; 

   /* public void downloadExcel() {
        //PageReference pg=new PageReference('/apex/IPM_ProjectsOverview_XL');
        //pg.setRedirect(false);
        //return pg;
    }*/
    
    public PageReference downloadExcel() {
        return new PageReference('/apex/IPM_ProjectsOverview_XL');
    }

    public IPM_ProjectsDownloadController(){

    }
    public transient List<ProjectWrapper> lstProjectWrap{get; set;}

    public pageReference reportspage(){

        Set<string> setOfYear = new Set<string>(); 
        setOfYear.add('1');
        setOfYear.add(IPM_ConstantUtils.Y1_LABEL);
        setOfYear.add(IPM_ConstantUtils.YEAR_2012); 
        setOfYear.add(IPM_ConstantUtils.YEAR_2013);
        setOfYear.add(IPM_ConstantUtils.YEAR_2014);
        setOfYear.add(IPM_ConstantUtils.YEAR_2015);
        setOfYear.add(IPM_ConstantUtils.YEAR_2016);
        setOfYear.add(IPM_ConstantUtils.YEAR_2017);
        setOfYear.add(IPM_ConstantUtils.YEAR_2018);
        setOfYear.add(IPM_ConstantUtils.YEAR_2019);
        setOfYear.add(IPM_ConstantUtils.YEAR_2020);
        setOfYear.add('2021');

        Set<string> setOfYear1 = new Set<string>(); 
        setOfYear1.add('0');
        setOfYear1.add('1');
        setOfYear1.add('2');
        setOfYear1.add(IPM_ConstantUtils.Y3_YEARINDEX);

        List<IPM_Project__c> lstProjects = [Select Project_External_ID__c,Name,IPM_Parent_Project__c,
                                       IPM_Project_Leader__c,Deputy_Project_Leader__c,IPM_Rollout_Status__c,
                                       IPM_Finance_Member__c,IPM_Category_Text__c,IPM_Phase__c,IPM_Brand_Positioning__c,
                                       IPMProject_Span__c, IPMProject_Type__c,IPM_No_of_Country_Rollouts__c ,IPM_Company_Card__c,IPM_Clustering__c,
                                       IPM_Answer_of_Q1__c, IPM_Answer_of_Q2__c, Exempt_from_Threshold__c, IPM_Answer_of_Q3__c,IPM_Strategic_Intent__c,
                                       IPM_Target_Launch_Year__c,IPM_Target_Launch_Month__c,IPM_Actual_Launch_Date__c, IPM_Actual_Launch_Month__c,IPM_Actual_Launch_Year__c,IPMPlatform__c,IPM_Project_Type__c,
                                       IPM_Project_Description__c, CreatedDate,
                                       (Select id,IPM_Status__c,IPM_Rollout_Type__c,Target_Launch_Date__c,IPM_Project__c,Name,IPM_Rollout_Span__c,Market_Cluster__c,Market_Cluster_Name__c from IPM_Project_Rollout__r where Market_Cluster_Name__c != null),
                                       (Select id,Name,IPM_Due_Date__c,IPM_Type_of_gate__c,IPM_Completed_on__c,
                                       IPM_Actual_Target_Launch_Year__c,IPM_Target_Launch_Year__c,IPM_Target_Launch_Month__c,IPM_Proposed_Date__c,IPM_Actual_Target_Launch_Month__c
                                       from IPM_Milestones__r where IPM_Type_of_Milestone__c = 'Standard') 
                                       from IPM_Project__c where Is_Archieved__c = false]; //a0tM0000002JK3K
                                       
        List<Id> lstfinancialId=new List<Id>();                               
        if(!lstProjects.isEmpty()){
            for(IPM_Project__c proj: lstProjects){
                for(IPM_Project_Rollout__c pRoll : proj.IPM_Project_Rollout__r){
                    lstfinancialId.add(pRoll.Id);
                }
            }    
        } 

        //Map<Id,List<IPM_Financial__c>> maprollIdfinancial=new Map<Id,List<IPM_Financial__c>>();
        Map<Id,List<IPM_Financial_Year__c>> mapfinancialyear=new Map<Id,List<IPM_Financial_Year__c>>();
        if(!lstfinancialId.isEmpty()){
            List<IPM_Financial__c> lstfinancial=[Select Id,Name,Financial_External_ID__c,IPM_Project_Rollout__c,RecordTypeId from IPM_Financial__c where IPM_Project_Rollout__c IN : lstfinancialId];

            List<IPM_Financial_Year__c> lstfinancialyear =[Select id,Name,Financial_External_ID__c,IPM_Financial__r.Parent_Project__r.name , IPM_Financial__r.Regional_Project__r.name, IPM_Financial__r.Local_Project__r.name,IPM_Financial__r.Parent_Project__c,IPM_Financial__r.Business_Impact_Global__c,IPM_Financial__r.Business_Impact_Regional__c,IPM_Financial__r.Business_Impact_Local__c,IPM_Financial__r.Threshold__c,IPM_Financial__r.Misaligned__c,Advertising_Promotions_Global__c,Advertising_Promotions_Regional__c,Advertising_Promotions_Local__c,IPM_Financial__r.Regional_Project__c,IPM_Financial__r.Local_Project__c,IPM_Financial__c ,Year__c ,Gross_Profit_Global__c,Gross_Profit_Regional__c,Gross_Profit_Local__c,Turnover_Global__c,Turnover_Local__c,Turnover_Regional__c,Year_Type__c,PL_Type__c from IPM_Financial_Year__C where IPM_Financial__c  in: lstfinancial];
            Map<Id,List<IPM_Financial_Year__c>> mapfinancial=new Map<Id,List<IPM_Financial_Year__c>>();
            for(IPM_Financial_Year__c finYear:lstfinancialyear){
                if(mapfinancial.containsKey(finYear.IPM_Financial__c )){
                     List<IPM_Financial_Year__c> lstFinan = mapfinancial.get(finYear.IPM_Financial__c);
                    lstFinan.add(finYear);
                    mapfinancial.put(finYear.IPM_Financial__c, lstFinan);
                }else{
                     mapfinancial.put(finYear.IPM_Financial__c, new List<IPM_Financial_Year__c>{finYear});
                }
            }
            Map<Id,List<IPM_Financial__c>> maprollIdfinancial=new Map<Id,List<IPM_Financial__c>>();
            Id defaultrecTypeID=Schema.SObjectType.IPM_Financial__c.RecordTypeInfosByName.get('Default').RecordTypeId;
            List<String> localrollNames=new List<String>();
            for(IPM_Financial__c finan:lstfinancial){
                if(finan.RecordtypeID == defaultrecTypeID){
                    localrollNames.add(finan.Financial_External_ID__c);
                }
            }
         //   System.debug('\n localrollNames'+localrollNames);
            List<IPM_Project_Rollout__c> localrolls=[Select Id,Name from IPM_Project_Rollout__c where Name IN : localrollNames];
            Map<String,Id> mapnamelocal=new Map<String,Id>();
            for(IPM_Project_Rollout__c r:localrolls){
                mapnamelocal.put(r.Name,r.Id);
            }
         //   System.debug('mapnamelocal'+mapnamelocal.keySet());
            for(IPM_Financial__c fin:lstfinancial){
                if(fin.RecordtypeID == defaultrecTypeID){
                    if(maprollIdfinancial.containsKey(mapnamelocal.get(fin.Financial_External_ID__c))){
                         List<IPM_Financial__c> lstFinan = maprollIdfinancial.get(mapnamelocal.get(fin.Name));
                        lstFinan.add(fin);
                        maprollIdfinancial.put(mapnamelocal.get(fin.Financial_External_ID__c), lstFinan);
                    }else{
                         maprollIdfinancial.put(mapnamelocal.get(fin.Financial_External_ID__c), new List<IPM_Financial__c>{fin});
                    }
                }else{
                    if(maprollIdfinancial.containsKey(fin.IPM_Project_Rollout__c)){
                         List<IPM_Financial__c> lstFinan = maprollIdfinancial.get(fin.IPM_Project_Rollout__c);
                        lstFinan.add(fin);
                        maprollIdfinancial.put(fin.IPM_Project_Rollout__c, lstFinan);
                    }else{
                         maprollIdfinancial.put(fin.IPM_Project_Rollout__c, new List<IPM_Financial__c>{fin});
                    }
                }
            }
        //    System.debug('\n maprollIdfinancial'+maprollIdfinancial.keySet());
            for(Id rollout:maprollIdfinancial.keySet()){
                List<IPM_Financial__c> lstFinan1 = maprollIdfinancial.get(rollout);
                for(IPM_Financial__c finn:lstFinan1){
                    if(mapfinancial.containsKey(finn.Id)){
                         List<IPM_Financial_Year__c> lstFinan = mapfinancial.get(finn.Id);
                        mapfinancialyear.put(rollout, lstFinan);
                    }
                }
            }
        //    System.debug('mapfinancialyear'+mapfinancialyear.keySet());
         
        }    

        map<id,IPM_Financial_Year__c> frmap = new map<id,IPM_Financial_Year__c>([Select id,Name,Financial_External_ID__c,IPM_Financial__r.Parent_Project__r.name , IPM_Financial__r.Regional_Project__r.name, IPM_Financial__r.Local_Project__r.name,IPM_Financial__r.Parent_Project__c,IPM_Financial__r.Business_Impact_Global__c,IPM_Financial__r.Business_Impact_Regional__c,IPM_Financial__r.Business_Impact_Local__c,IPM_Financial__r.Threshold__c,IPM_Financial__r.Misaligned__c,Advertising_Promotions_Global__c,Advertising_Promotions_Regional__c,Advertising_Promotions_Local__c,IPM_Financial__r.Regional_Project__c,IPM_Financial__r.Local_Project__c,IPM_Financial__c ,Year__c ,Gross_Profit_Global__c,Gross_Profit_Regional__c,Gross_Profit_Local__c,Turnover_Global__c,Turnover_Local__c,Turnover_Regional__c,Year_Type__c,PL_Type__c from IPM_Financial_Year__C where IPM_Financial__r.Parent_Project__c in: lstProjects]); //  and Name IN: setOfYear and Year__c IN: setOfYear1
        
        List<IPM_Country__c> lstIpmCountry=[SELECT Country_Code__c,Country_Name__c,IPM_Project__c,IPM_Project__r.IPMProject_Span__c FROM IPM_Country__c WHERE IPM_Project__c IN : lstProjects];
        Map<Id, List<IPM_Country__c>> mpIpmCountry = new Map<Id, List<IPM_Country__c>>(); 
        for(IPM_Country__c country:lstIpmCountry){
            if(country.IPM_Project__r.IPMProject_Span__c != IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && country.Country_Name__c != null){
                if(!mpIpmCountry.containsKey(country.IPM_Project__c))
                    mpIpmCountry.put(country.IPM_Project__c, new List<IPM_Country__c>{country});
                else{
                    List<IPM_Country__c> lstCont = mpIpmCountry.get(country.IPM_Project__c);
                    lstCont.add(country);
                    mpIpmCountry.put(country.IPM_Project__c, lstCont);
                }
            }
        }

        Map<Id, List<IPM_Financial_Year__c>> mpFinalFin = new Map<Id, List<IPM_Financial_Year__c>>(); 
        for(IPM_Financial_Year__c ify: frmap.values()){

            if(ify.IPM_Financial__r.Regional_Project__c != null){
        
                if(!mpFinalFin.containsKey(ify.IPM_Financial__r.Regional_Project__c))
                    mpFinalFin.put(ify.IPM_Financial__r.Regional_Project__c, new List<IPM_Financial_Year__c>{ify});
                else{
                    List<IPM_Financial_Year__c> lstYears = mpFinalFin.get(ify.IPM_Financial__r.Regional_Project__c);
                    lstYears.add(ify);
                    mpFinalFin.put(ify.IPM_Financial__r.Regional_Project__c, lstYears);
                }

            }else if(ify.IPM_Financial__r.Local_Project__c != null){
                if(!mpFinalFin.containsKey(ify.IPM_Financial__r.Local_Project__c))
                    mpFinalFin.put(ify.IPM_Financial__r.Local_Project__c, new List<IPM_Financial_Year__c>{ify});
                else{
                    List<IPM_Financial_Year__c> lstYears = mpFinalFin.get(ify.IPM_Financial__r.Local_Project__c);
                    lstYears.add(ify);
                    mpFinalFin.put(ify.IPM_Financial__r.Local_Project__c, lstYears);
                }
            }else {
                if(!mpFinalFin.containsKey(ify.IPM_Financial__r.Parent_Project__c))
                    mpFinalFin.put(ify.IPM_Financial__r.Parent_Project__c, new List<IPM_Financial_Year__c>{ify});
                else{
                    List<IPM_Financial_Year__c> lstYears = mpFinalFin.get(ify.IPM_Financial__r.Parent_Project__c);
                    lstYears.add(ify);
                    mpFinalFin.put(ify.IPM_Financial__r.Parent_Project__c, lstYears);
                }
            }
        }

      //  System.debug('Map Size:'+mpFinalFin);
        lstProjectWrap = new List<ProjectWrapper>();
        for(IPM_Project__c proj: lstProjects){
            ProjectWrapper pWrap = new ProjectWrapper();
            string rolls = BLANK_STR;
            string status =BLANK_STR;
            string geography=BLANK_STR;
            
            if(mpIpmCountry.containsKey(proj.Id)){
                for(IPM_Country__c  pcountry : mpIpmCountry.get(proj.Id)){
                    if(geography == BLANK_STR)
                        geography = pcountry.Country_Name__c;
                    else
                        geography = geography+' & '+pcountry.Country_Name__c;
                }
            }
            
            if(geography != null){
                pWrap.geography = geography;
            }

            for(IPM_Project_Rollout__c pRoll : proj.IPM_Project_Rollout__r){
                if(!rolls.contains(pRoll.Market_Cluster_Name__c)){
                if(rolls == BLANK_STR)
                    rolls = pRoll.Market_Cluster_Name__c;
                else
                    rolls = rolls+' & '+pRoll.Market_Cluster_Name__c;
                }

                if(pRoll.IPM_Status__c != null){
                    if(!status.contains(pRoll.IPM_Status__c)){
                        if(status == BLANK_STR)
                            status = pRoll.IPM_Status__c;
                        else
                            status = status +' & '+pRoll.IPM_Status__c;
                    }
                }
            }
            pWrap.MasterCluster = rolls;
            pWrap.status =status;
            for(IPM_Milestone__c mile : proj.IPM_Milestones__r){
                if(mile.IPM_Type_of_gate__c == 'Charter'){
                pWrap.charterDueDate = mile.IPM_Due_Date__c;
                pWrap.charterCompletedDate = mile.IPM_Completed_on__c;
                pWrap.charterProposedDate = mile.IPM_Proposed_Date__c;
                
                }
                else if(mile.IPM_Type_of_gate__c == 'Contract'){
                pWrap.contractDueDate = mile.IPM_Due_Date__c;
                pWrap.contractCompletedDate = mile.IPM_Completed_on__c;
                pWrap.contractProposedDate = mile.IPM_Proposed_Date__c;
                }
                else if(mile.IPM_Type_of_gate__c == 'Market Ready'){
                pWrap.readyDueDate = mile.IPM_Due_Date__c;
                pWrap.readyCompletedDate = mile.IPM_Completed_on__c;
                pWrap.readyProposedDate = mile.IPM_Proposed_Date__c;
                }
                else if(mile.IPM_Type_of_gate__c == 'Market Deployment'){
                pWrap.deployDueDate = mile.IPM_Due_Date__c;
                pWrap.deployCompletedDate = mile.IPM_Completed_on__c;
                pWrap.deployProposedDate = mile.IPM_Proposed_Date__c;
                }
                //else if(mile.IPM_Type_of_gate__c == null && mile.name.contains('Ship to'))
                else if(mile.IPM_Type_of_gate__c == 'PLE/Learnings'){
                pWrap.shipToMonth = mile.IPM_Target_Launch_Month__c;
                pWrap.shipToYear = mile.IPM_Target_Launch_Year__c;
                pWrap.actualyear = mile.IPM_Completed_on__c;
                }

            }

            if(proj.IPM_Project_Type__c=='Original'){
                pWrap.isOriginal = true;
                pWrap.isRollOut = false;
            }
            if(proj.IPM_Project_Type__c=='Rollout'){
                pWrap.isOriginal = false;
                pWrap.isRollOut = true;
            }

            if(proj.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_GLOBAL){
                pWrap.projecttype = string.valueof(proj.IPMProject_Type__c);
                pWrap.geography =IPM_ConstantUtils.PROJECT_SPAN_GLOBAL;
            }
            if(proj.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_REGIONAL){
                pWrap.projecttype = string.valueof(proj.IPM_Project_Type__c);
            }

            if(proj.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_LOCAL){
                pWrap.projecttype = string.valueof(proj.IPM_Project_Type__c);
            }
            
         //   System.debug('Contains Key:'+mpFinalFin.containsKey(proj.id));
            if(mpFinalFin.containsKey(proj.id)){
                for(IPM_Financial_Year__c fr : mpFinalFin.get(proj.id)) {  
          //          system.debug('proj inside the values '+proj.id); 
                    string sFinancial_External_ID = fr.Financial_External_ID__c;
                    if(sFinancial_External_ID.contains(IPM_ConstantUtils.FINANCIAL_CONSOLIDATE)){
                        sFinancial_External_ID = sFinancial_External_ID.substringBefore(IPM_ConstantUtils.FINANCIAL_CONSOLIDATE);
                    }
                    if(fr.IPM_Financial__r.Local_Project__c != null)
              //      System.debug('sFinancial_External_ID '+sFinancial_External_ID);
             //       System.debug(fr.IPM_Financial__r.Regional_Project__c + fr.IPM_Financial__r.Regional_Project__r.name);
              //      System.debug(fr.IPM_Financial__r.Local_Project__c + fr.IPM_Financial__r.Local_Project__r.name);
              //      System.debug(fr.IPM_Financial__r.Parent_Project__c + fr.IPM_Financial__r.Parent_Project__r.name);
                    if((fr.IPM_Financial__r.Regional_Project__c != null &&  fr.IPM_Financial__r.Regional_Project__r.name == sFinancial_External_ID )||
                       (fr.IPM_Financial__r.Local_Project__c != null &&  fr.IPM_Financial__r.Local_Project__r.name == sFinancial_External_ID )||
                       (fr.IPM_Financial__r.Parent_Project__c != null && fr.IPM_Financial__r.Parent_Project__r.name == sFinancial_External_ID)){
                  //     System.debug(proj.IPMProject_Span__c);
                        if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL && fr.Name == IPM_ConstantUtils.Y1_LABEL && fr.Year_Type__c == IPM_ConstantUtils.CORE_STRATEGIC_INNOVATION && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                            pWrap.turnover = string.valueof(fr.Turnover_Local__c);
                        else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && fr.Name == IPM_ConstantUtils.Y1_LABEL && fr.Year_Type__c == IPM_ConstantUtils.CORE_STRATEGIC_INNOVATION && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                            pWrap.turnover = string.valueof(fr.Turnover_Regional__c);
                        else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && fr.Name == IPM_ConstantUtils.Y1_LABEL && fr.Year_Type__c == IPM_ConstantUtils.CORE_STRATEGIC_INNOVATION && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                            pWrap.turnover = string.valueof(fr.Turnover_Global__c); 
                        // innovative
                        
                        if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL && fr.Name == IPM_ConstantUtils.Y1_LABEL && fr.Year_Type__c == IPM_ConstantUtils.CORE_STRATEGIC_INNOVATION && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                        {
                            pWrap.turnover_ito = fr.Turnover_Local__c;
                            pwrap.turnover_igp = fr.Turnover_Local__c;
                        }
                         else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && fr.Name == IPM_ConstantUtils.Y1_LABEL && fr.Year_Type__c == IPM_ConstantUtils.CORE_STRATEGIC_INNOVATION && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                         {
                            pWrap.turnover_ito = fr.Turnover_Regional__c; 
                             pWrap.turnover_igp  = fr.Turnover_Regional__c; 
                         }   
                         else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && fr.Name == IPM_ConstantUtils.Y1_LABEL && fr.Year_Type__c == IPM_ConstantUtils.CORE_STRATEGIC_INNOVATION && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                         {
                            pWrap.turnover_ito = fr.Turnover_Global__c;
                            pWrap.turnover_igp = fr.Gross_Profit_Global__c;  
                         }  
                         // 2012
                         if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL && fr.Name == IPM_ConstantUtils.YEAR_2012 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                            pWrap.turnover_2012 = string.valueof(fr.Turnover_Local__c);
                         else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && fr.Name == IPM_ConstantUtils.YEAR_2012 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                            pWrap.turnover_2012 = string.valueof(fr.Turnover_Regional__c);
                         else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && fr.Name == IPM_ConstantUtils.YEAR_2012 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                            pWrap.turnover_2012 = string.valueof(fr.Turnover_Global__c); 
                         // 2013
                         if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL && fr.Name == IPM_ConstantUtils.YEAR_2013 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                            pWrap.turnover_2013 = string.valueof(fr.Turnover_Local__c);
                         else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && fr.Name == IPM_ConstantUtils.YEAR_2013 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                            pWrap.turnover_2013 = string.valueof(fr.Turnover_Regional__c);
                         else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && fr.Name == IPM_ConstantUtils.YEAR_2013 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                            pWrap.turnover_2013 = string.valueof(fr.Turnover_Global__c); 
                         // 2014
                         if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL && fr.Name== IPM_ConstantUtils.YEAR_2014 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                            pWrap.turnover_2014 = string.valueof(fr.Turnover_Local__c);
                         else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && fr.Name == IPM_ConstantUtils.YEAR_2014 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                            pWrap.turnover_2014 = string.valueof(fr.Turnover_Regional__c);
                         else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && fr.Name == IPM_ConstantUtils.YEAR_2014 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                            pWrap.turnover_2014 = string.valueof(fr.Turnover_Global__c); 
                         // 2015
                         if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL && fr.Name == IPM_ConstantUtils.YEAR_2015 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                            pWrap.turnover_2015 = string.valueof(fr.Turnover_Local__c);
                         else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && fr.Name == IPM_ConstantUtils.YEAR_2015 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                            pWrap.turnover_2015 = string.valueof(fr.Turnover_Regional__c);
                         else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && fr.Name == IPM_ConstantUtils.YEAR_2015 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                            pWrap.turnover_2015 = string.valueof(fr.Turnover_Global__c); 
                         // 2016
                         if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL && fr.Name == IPM_ConstantUtils.YEAR_2016 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                            pWrap.turnover_2016 = string.valueof(fr.Turnover_Local__c);
                         else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && fr.Name == IPM_ConstantUtils.YEAR_2016 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                            pWrap.turnover_2016 = string.valueof(fr.Turnover_Regional__c);
                         else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && fr.Name == IPM_ConstantUtils.YEAR_2016 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                            pWrap.turnover_2016 = string.valueof(fr.Turnover_Global__c); 
                          // 2017
                           if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL && fr.Name == IPM_ConstantUtils.YEAR_2017 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                            pWrap.turnover_2017 = string.valueof(fr.Turnover_Local__c);
                         else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && fr.Name == IPM_ConstantUtils.YEAR_2017 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                            pWrap.turnover_2017 = string.valueof(fr.Turnover_Regional__c);
                         else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && fr.Name == IPM_ConstantUtils.YEAR_2017 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                            pWrap.turnover_2017 = string.valueof(fr.Turnover_Global__c); 
                          //2018
                           if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL && fr.Name == IPM_ConstantUtils.YEAR_2018 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                            pWrap.turnover_2018 = string.valueof(fr.Turnover_Local__c);
                         else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && fr.Name == IPM_ConstantUtils.YEAR_2018 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                            pWrap.turnover_2018 = string.valueof(fr.Turnover_Regional__c);
                         else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && fr.Name == IPM_ConstantUtils.YEAR_2018 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                            pWrap.turnover_2018 = string.valueof(fr.Turnover_Global__c); 
                         //2019
                          if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL && fr.Name == IPM_ConstantUtils.YEAR_2019 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                            pWrap.turnover_2019 = string.valueof(fr.Turnover_Local__c);
                         else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && fr.Name == IPM_ConstantUtils.YEAR_2019 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                            pWrap.turnover_2019 = string.valueof(fr.Turnover_Regional__c);
                         else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && fr.Name == IPM_ConstantUtils.YEAR_2019 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                            pWrap.turnover_2019 = string.valueof(fr.Turnover_Global__c); 
                        //2020
                         if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL && fr.Name == IPM_ConstantUtils.YEAR_2020 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                            pWrap.turnover_2020 = string.valueof(fr.Turnover_Local__c);
                         else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && fr.Name == IPM_ConstantUtils.YEAR_2020 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                            pWrap.turnover_2020 = string.valueof(fr.Turnover_Regional__c);
                         else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && fr.Name == IPM_ConstantUtils.YEAR_2020 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                            pWrap.turnover_2020 = string.valueof(fr.Turnover_Global__c); 
                         // ITO 2012
                          if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL && fr.Name == IPM_ConstantUtils.YEAR_2012 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                          {
                            pWrap.turnover_ITO2012 = string.valueof(fr.Turnover_Local__c);
                            pWrap.turnover_IGO2012 = string.valueof(fr.Gross_Profit_Local__c);
                          }
                         else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && fr.Name == IPM_ConstantUtils.YEAR_2012 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                         {
                            pWrap.turnover_ITO2012 = string.valueof(fr.Turnover_Regional__c);
                            pWrap.turnover_IGO2012 = string.valueof(fr.Gross_Profit_Regional__c);
                         }
                         else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && fr.Name == IPM_ConstantUtils.YEAR_2012 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                         {
                            pWrap.turnover_ITO2012 = string.valueof(fr.Turnover_Global__c); 
                            pWrap.turnover_IGO2012 = string.valueof(fr.Gross_Profit_Global__c); 
                         }
                         // ITO 2013
                          if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL && fr.Name == IPM_ConstantUtils.YEAR_2013 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                          {
                            pWrap.turnover_ITO2013 = string.valueof(fr.Turnover_Local__c);
                            pWrap.turnover_IGO2013 = string.valueof(fr.Gross_Profit_Local__c);
                          }
                         else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && fr.Name == IPM_ConstantUtils.YEAR_2013 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                         {   
                             pWrap.turnover_ITO2013 = string.valueof(fr.Turnover_Regional__c);
                             pWrap.turnover_IGO2013 = string.valueof(fr.Gross_Profit_Regional__c);
                         }
                         else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && fr.Name == IPM_ConstantUtils.YEAR_2013 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                         {   
                             pWrap.turnover_ITO2013 = string.valueof(fr.Turnover_Global__c);
                             pWrap.turnover_IGO2013 = string.valueof(fr.Gross_Profit_Global__c);
                         }
                         // ITO 2014
                          if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL && fr.Name == IPM_ConstantUtils.YEAR_2014 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                          { 
                              pWrap.turnover_ITO2014 = string.valueof(fr.Turnover_Local__c);
                              pWrap.turnover_IGO2014 = string.valueof(fr.Gross_Profit_Local__c);
                          }
                         else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && fr.Name == IPM_ConstantUtils.YEAR_2014 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                         {  
                              pWrap.turnover_ITO2014 = string.valueof(fr.Turnover_Regional__c);
                              pWrap.turnover_IGO2014 = string.valueof(fr.Gross_Profit_Regional__c);
                         }
                         else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && fr.Name == IPM_ConstantUtils.YEAR_2014 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                          { 
                               pWrap.turnover_ITO2014 = string.valueof(fr.Turnover_Global__c);
                               pWrap.turnover_IGO2014 = string.valueof(fr.Gross_Profit_Global__c);
                          }
                        // ITO 2015
                          if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL && fr.Name == IPM_ConstantUtils.YEAR_2015 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                          {  
                              pWrap.turnover_ITO2015 = string.valueof(fr.Turnover_Local__c);
                              pWrap.turnover_IGO2015 = string.valueof(fr.Gross_Profit_Local__c);
                          }
                         else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && fr.Name == IPM_ConstantUtils.YEAR_2015 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                         {   
                             pWrap.turnover_ITO2015 = string.valueof(fr.Turnover_Regional__c);
                             pWrap.turnover_IGO2015 = string.valueof(fr.Gross_Profit_Regional__c);
                         }
                         else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && fr.Name == IPM_ConstantUtils.YEAR_2015 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                         {   
                             pWrap.turnover_ITO2015 = string.valueof(fr.Turnover_Global__c);
                             pWrap.turnover_IGO2015 = string.valueof(fr.Gross_Profit_Global__c);
                         }
                        // ITO 2016
                          if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL && fr.Name == IPM_ConstantUtils.YEAR_2016 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                          {  
                              pWrap.turnover_ITO2016 = string.valueof(fr.Turnover_Local__c);
                              pWrap.turnover_IGO2016 = string.valueof(fr.Gross_Profit_Local__c);
                          }
                         else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && fr.Name == IPM_ConstantUtils.YEAR_2016 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                          {  
                              pWrap.turnover_ITO2016 = string.valueof(fr.Turnover_Regional__c);
                                pWrap.turnover_IGO2016 = string.valueof(fr.Gross_Profit_Regional__c);
                          }
                         else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && fr.Name == IPM_ConstantUtils.YEAR_2016 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                          {  
                              pWrap.turnover_ITO2016 = string.valueof(fr.Turnover_Global__c);
                              pWrap.turnover_IGO2016 = string.valueof(fr.Gross_Profit_Global__c);
                          }
                        // ITO 2017
                          if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL && fr.Name == IPM_ConstantUtils.YEAR_2017 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                          { 
                               pWrap.turnover_ITO2017 = string.valueof(fr.Turnover_Local__c);
                                pWrap.turnover_IGO2017 = string.valueof(fr.Gross_Profit_Local__c);
                          }
                         else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && fr.Name == IPM_ConstantUtils.YEAR_2017 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                         { 
                           pWrap.turnover_ITO2017 = string.valueof(fr.Turnover_Regional__c);
                           pWrap.turnover_IGO2017 = string.valueof(fr.Gross_Profit_Regional__c); 
                         }
                         else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && fr.Name == IPM_ConstantUtils.YEAR_2017 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                         {
                            pWrap.turnover_ITO2017 = string.valueof(fr.Turnover_Global__c); 
                               pWrap.turnover_IGO2017 = string.valueof(fr.Gross_Profit_Global__c); 
                         }
                         // ITO 2018
                          if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL && fr.Name == IPM_ConstantUtils.YEAR_2018 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                          { 
                               pWrap.turnover_ITO2018 = string.valueof(fr.Turnover_Local__c);
                                pWrap.turnover_IGO2018 = string.valueof(fr.Gross_Profit_Local__c);
                          }
                         else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && fr.Name == IPM_ConstantUtils.YEAR_2018 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                          {  
                              pWrap.turnover_ITO2018 = string.valueof(fr.Turnover_Regional__c);
                              pWrap.turnover_IGO2018 = string.valueof(fr.Gross_Profit_Regional__c);
                          }
                         else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && fr.Name == IPM_ConstantUtils.YEAR_2018 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                         { 
                               pWrap.turnover_ITO2018 = string.valueof(fr.Turnover_Global__c);
                                 pWrap.turnover_IGO2018 = string.valueof(fr.Gross_Profit_Global__c);
                         }
                        // ITO 2019
                          if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL && fr.Name == IPM_ConstantUtils.YEAR_2019 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                          { 
                               pWrap.turnover_ITO2019 = string.valueof(fr.Turnover_Local__c);
                                pWrap.turnover_IGO2019 = string.valueof(fr.Gross_Profit_Local__c);
                          }
                         else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && fr.Name == IPM_ConstantUtils.YEAR_2019 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                         { 
                            pWrap.turnover_ITO2019 = string.valueof(fr.Turnover_Regional__c);
                             pWrap.turnover_IGO2019 = string.valueof(fr.Gross_Profit_Regional__c);
                         }
                         else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && fr.Name == IPM_ConstantUtils.YEAR_2019 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                         {
                            pWrap.turnover_ITO2019 = string.valueof(fr.Turnover_Global__c);
                               pWrap.turnover_IGO2019 = string.valueof(fr.Gross_Profit_Global__c);
                         }
                        // ITO 2020
                          if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL && fr.Name == IPM_ConstantUtils.YEAR_2020 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                           { 
                               pWrap.turnover_ITO2020 = string.valueof(fr.Turnover_Local__c);
                               pWrap.turnover_IGO2020 = string.valueof(fr.Gross_Profit_Local__c);
                           }
                         else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && fr.Name == IPM_ConstantUtils.YEAR_2020 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                         {  
                              pWrap.turnover_ITO2020 = string.valueof(fr.Turnover_Regional__c);
                               pWrap.turnover_IGO2020 = string.valueof(fr.Gross_Profit_Regional__c);
                         }
                         else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && fr.Name == IPM_ConstantUtils.YEAR_2020 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                         {
                            pWrap.turnover_ITO2020 = string.valueof(fr.Turnover_Global__c);
                               pWrap.turnover_IGO2020 = string.valueof(fr.Gross_Profit_Global__c);
                         }
                         
                         //Y3 iTO
                         
                          if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL && fr.Year__c == IPM_ConstantUtils.Y3_YEARINDEX && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                           { 
                               pWrap.y3_ITO = string.valueof(fr.Turnover_Local__c);
                              
                           }
                         else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && fr.Year__c == IPM_ConstantUtils.Y3_YEARINDEX && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                         {  
                              pWrap.y3_ITO  = string.valueof(fr.Turnover_Regional__c);
                               
                         }
                         else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && fr.Year__c == IPM_ConstantUtils.Y3_YEARINDEX && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                         {
                            pWrap.y3_ITO = string.valueof(fr.Turnover_Global__c);
                              
                         }
                         
                          //Y3 GTO
                         
                          if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL && fr.Year__c == IPM_ConstantUtils.Y3_YEARINDEX && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                           { 
                               pWrap.y3_GTO = string.valueof(fr.Turnover_Local__c);
                              
                           }
                         else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && fr.Year__c == IPM_ConstantUtils.Y3_YEARINDEX && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                         {  
                              pWrap.y3_GTO  = string.valueof(fr.Turnover_Regional__c);
                               
                         }
                         else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && fr.Year__c == IPM_ConstantUtils.Y3_YEARINDEX && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                         {
                            pWrap.y3_GTO = string.valueof(fr.Turnover_Global__c);
                              
                         }
                         
                         // a&p
                        if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL && fr.Name == IPM_ConstantUtils.YEAR_2012 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                           { 
                               pWrap.turnover_ap2012= string.valueof(fr.Advertising_Promotions_Local__c);
                             
                           }
                         else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && fr.Name == IPM_ConstantUtils.YEAR_2012 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                         {  
                              pWrap.turnover_ap2012= string.valueof(fr.Advertising_Promotions_Regional__c);
                               
                         }
                         else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && fr.Name == IPM_ConstantUtils.YEAR_2012 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                         {
                            pWrap.turnover_ap2012= string.valueof(fr.Advertising_Promotions_Global__c);
                           
                         }
                         
                         //if(sFinancial_External_ID.contains(IPM_ConstantUtils.FINANCIAL_CONSOLIDATE)){
                             if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL){
                                 pWrap.BusinessImpact = fr.IPM_Financial__r.Business_Impact_Global__c;
                                 pWrap.threshold=fr.IPM_Financial__r.Threshold__c;
                             }
                             
                             if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL){
                                 pWrap.BusinessImpact =fr.IPM_Financial__r.Business_Impact_Regional__c;
                                  pWrap.threshold=fr.IPM_Financial__r.Threshold__c;
                             }
                             if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL){
                                 pWrap.BusinessImpact =fr.IPM_Financial__r.Business_Impact_Local__c;
                                  pWrap.threshold=fr.IPM_Financial__r.Threshold__c;
                             }
                         //}
                         
                         //pWrap.threshold=fr.IPM_Financial__r.Threshold__c;
                         //pWrap.misaligned=fr.IPM_Financial__r.Misaligned__c; 
                     
                    }
                }
            }
            
            pWrap.proj = proj;
            lstProjectWrap.add(pWrap);
            
            for(IPM_Project_Rollout__c pRoll : proj.IPM_Project_Rollout__r){
                ProjectWrapper prwp=new ProjectWrapper(pWrap);
                //prwp=pWrap;
                prwp.proj=proj.clone(false, true);
                prwp.proj.Name=pRoll.Name;
                prwp.proj.IPMProject_Span__c=pRoll.IPM_Rollout_Span__c;
                prwp.proj.IPMProject_Type__c = pRoll.IPM_Rollout_Type__c;
                prwp.proj.IPM_Rollout_Status__c=pRoll.IPM_Status__c;
                prwp.MasterCluster=pRoll.Market_Cluster_Name__c;
           //    System.debug(pRoll.IPM_Rollout_Span__c);
                if(pRoll.IPM_Rollout_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL){
                    prwp.shipToYear = String.valueOf(pRoll.Target_Launch_Date__c);
                }else if(pRoll.IPM_Rollout_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL){
                    prwp.shipToMonth = String.valueOf(pRoll.Target_Launch_Date__c);
                }
            //    System.debug('\n Test');
            //    System.debug('\n Keys'+mapfinancialyear.keyset());
            //    System.debug(pRoll.Id);
                if(mapfinancialyear.containsKey(pRoll.Id)){
              //      System.debug(mapfinancialyear.get(pRoll.id));
                    for(IPM_Financial_Year__c fr : mapfinancialyear.get(pRoll.id)) {  
                        string sFinancial_External_ID = fr.Financial_External_ID__c;
                        if(sFinancial_External_ID.contains(IPM_ConstantUtils.FINANCIAL_CONSOLIDATE)){
                            sFinancial_External_ID = sFinancial_External_ID.substringBefore(IPM_ConstantUtils.FINANCIAL_CONSOLIDATE);
                        }
                  //      System.debug('Rollout Span:'+pRoll.IPM_Rollout_Span__c);
                        for(IPM_Milestone__c mile : proj.IPM_Milestones__r){
                            if(mile.IPM_Type_of_gate__c == 'Charter'){
                                prwp.charterDueDate = mile.IPM_Due_Date__c;
                                prwp.charterCompletedDate = mile.IPM_Completed_on__c;
                                prwp.charterProposedDate = mile.IPM_Proposed_Date__c;
                            }
                            else if(mile.IPM_Type_of_gate__c == 'Contract'){
                                prwp.contractDueDate = mile.IPM_Due_Date__c;
                                prwp.contractCompletedDate = mile.IPM_Completed_on__c;
                                prwp.contractProposedDate = mile.IPM_Proposed_Date__c;
                            }
                            else if(mile.IPM_Type_of_gate__c == 'Market Ready'){
                                prwp.readyDueDate = mile.IPM_Due_Date__c;
                                prwp.readyCompletedDate = mile.IPM_Completed_on__c;
                                prwp.readyProposedDate = mile.IPM_Proposed_Date__c;
                            }
                            else if(mile.IPM_Type_of_gate__c == 'Market Deployment'){
                                prwp.deployDueDate = mile.IPM_Due_Date__c;
                                prwp.deployCompletedDate = mile.IPM_Completed_on__c;
                                prwp.deployProposedDate = mile.IPM_Proposed_Date__c;
                            }
                            //else if(mile.IPM_Type_of_gate__c == null && mile.name.contains('Ship to'))
                            
                        }
                        
                            if(pRoll.IPM_Rollout_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL && fr.Name == IPM_ConstantUtils.Y1_LABEL && fr.Year_Type__c == IPM_ConstantUtils.CORE_STRATEGIC_INNOVATION && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                                prwp.turnover = string.valueof(fr.Turnover_Local__c);
                            else if(pRoll.IPM_Rollout_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && fr.Name == IPM_ConstantUtils.Y1_LABEL && fr.Year_Type__c == IPM_ConstantUtils.CORE_STRATEGIC_INNOVATION && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                                prwp.turnover = string.valueof(fr.Turnover_Regional__c);
                            else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && fr.Name == IPM_ConstantUtils.Y1_LABEL && fr.Year_Type__c == IPM_ConstantUtils.CORE_STRATEGIC_INNOVATION && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                                prwp.turnover = string.valueof(fr.Turnover_Regional__c); 
                            // innovative
                            
                            if(pRoll.IPM_Rollout_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL && fr.Name == IPM_ConstantUtils.Y1_LABEL && fr.Year_Type__c == IPM_ConstantUtils.CORE_STRATEGIC_INNOVATION && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                            {
                                prwp.turnover_ito = fr.Turnover_Local__c;
                                prwp.turnover_igp = fr.Turnover_Local__c;
                            }
                             else if(pRoll.IPM_Rollout_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && fr.Name == IPM_ConstantUtils.Y1_LABEL && fr.Year_Type__c == IPM_ConstantUtils.CORE_STRATEGIC_INNOVATION && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                             {
                                prwp.turnover_ito = fr.Turnover_Regional__c; 
                                 prwp.turnover_igp  = fr.Turnover_Regional__c; 
                             }   
                             else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && fr.Name == IPM_ConstantUtils.Y1_LABEL && fr.Year_Type__c == IPM_ConstantUtils.CORE_STRATEGIC_INNOVATION && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                             {
                                prwp.turnover_ito = fr.Turnover_Regional__c;
                                prwp.turnover_igp = fr.Gross_Profit_Global__c;  
                             }  
                             // 2012
                             if(pRoll.IPM_Rollout_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL && fr.Name == IPM_ConstantUtils.YEAR_2012 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                                prwp.turnover_2012 = string.valueof(fr.Turnover_Local__c);
                             else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && fr.Name == IPM_ConstantUtils.YEAR_2012 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                                prwp.turnover_2012 = string.valueof(fr.Turnover_Regional__c);
                             else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && fr.Name == IPM_ConstantUtils.YEAR_2012 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                                prwp.turnover_2012 = string.valueof(fr.Turnover_Regional__c); 
                             // 2013
                             if(pRoll.IPM_Rollout_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL && fr.Name == IPM_ConstantUtils.YEAR_2013 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                                prwp.turnover_2013 = string.valueof(fr.Turnover_Local__c);
                             else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && fr.Name == IPM_ConstantUtils.YEAR_2013 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                                prwp.turnover_2013 = string.valueof(fr.Turnover_Regional__c);
                             else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && fr.Name == IPM_ConstantUtils.YEAR_2013 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                                prwp.turnover_2013 = string.valueof(fr.Turnover_Regional__c); 
                             // 2014
                             if(pRoll.IPM_Rollout_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL && fr.Name== IPM_ConstantUtils.YEAR_2014 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                                prwp.turnover_2014 = string.valueof(fr.Turnover_Local__c);
                             else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && fr.Name == IPM_ConstantUtils.YEAR_2014 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                                prwp.turnover_2014 = string.valueof(fr.Turnover_Regional__c);
                             else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && fr.Name == IPM_ConstantUtils.YEAR_2014 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                                prwp.turnover_2014 = string.valueof(fr.Turnover_Regional__c); 
                             // 2015
                             if(pRoll.IPM_Rollout_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL && fr.Name == IPM_ConstantUtils.YEAR_2015 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                                prwp.turnover_2015 = string.valueof(fr.Turnover_Local__c);
                             else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && fr.Name == IPM_ConstantUtils.YEAR_2015 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                                prwp.turnover_2015 = string.valueof(fr.Turnover_Regional__c);
                             else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && fr.Name == IPM_ConstantUtils.YEAR_2015 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                                prwp.turnover_2015 = string.valueof(fr.Turnover_Regional__c); 
                             // 2016
                             if(pRoll.IPM_Rollout_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL && fr.Name == IPM_ConstantUtils.YEAR_2016 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                                prwp.turnover_2016 = string.valueof(fr.Turnover_Local__c);
                             else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && fr.Name == IPM_ConstantUtils.YEAR_2016 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                                prwp.turnover_2016 = string.valueof(fr.Turnover_Regional__c);
                             else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && fr.Name == IPM_ConstantUtils.YEAR_2016 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                                prwp.turnover_2016 = string.valueof(fr.Turnover_Regional__c); 
                              // 2017
                               if(pRoll.IPM_Rollout_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL && fr.Name == IPM_ConstantUtils.YEAR_2017 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                                prwp.turnover_2017 = string.valueof(fr.Turnover_Local__c);
                             else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && fr.Name == IPM_ConstantUtils.YEAR_2017 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                                prwp.turnover_2017 = string.valueof(fr.Turnover_Regional__c);
                             else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && fr.Name == IPM_ConstantUtils.YEAR_2017 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                                prwp.turnover_2017 = string.valueof(fr.Turnover_Regional__c); 
                              //2018
                               if(pRoll.IPM_Rollout_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL && fr.Name == IPM_ConstantUtils.YEAR_2018 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                                prwp.turnover_2018 = string.valueof(fr.Turnover_Local__c);
                             else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && fr.Name == IPM_ConstantUtils.YEAR_2018 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                                prwp.turnover_2018 = string.valueof(fr.Turnover_Regional__c);
                             else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && fr.Name == IPM_ConstantUtils.YEAR_2018 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                                prwp.turnover_2018 = string.valueof(fr.Turnover_Regional__c); 
                             //2019
                              if(pRoll.IPM_Rollout_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL && fr.Name == IPM_ConstantUtils.YEAR_2019 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                                prwp.turnover_2019 = string.valueof(fr.Turnover_Local__c);
                             else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && fr.Name == IPM_ConstantUtils.YEAR_2019 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                                prwp.turnover_2019 = string.valueof(fr.Turnover_Regional__c);
                             else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && fr.Name == IPM_ConstantUtils.YEAR_2019 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                                prwp.turnover_2019 = string.valueof(fr.Turnover_Regional__c); 
                            //2020
                             if(pRoll.IPM_Rollout_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL && fr.Name == IPM_ConstantUtils.YEAR_2020 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                                prwp.turnover_2020 = string.valueof(fr.Turnover_Local__c);
                             else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && fr.Name == IPM_ConstantUtils.YEAR_2020 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                                prwp.turnover_2020 = string.valueof(fr.Turnover_Regional__c);
                             else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && fr.Name == IPM_ConstantUtils.YEAR_2020 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                                prwp.turnover_2020 = string.valueof(fr.Turnover_Regional__c); 
                             // ITO 2012
                              if(pRoll.IPM_Rollout_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL && fr.Name == IPM_ConstantUtils.YEAR_2012 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                              {
                                prwp.turnover_ITO2012 = string.valueof(fr.Turnover_Local__c);
                                prwp.turnover_IGO2012 = string.valueof(fr.Gross_Profit_Local__c);
                              }
                             else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && fr.Name == IPM_ConstantUtils.YEAR_2012 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                             {
                                prwp.turnover_ITO2012 = string.valueof(fr.Turnover_Regional__c);
                                prwp.turnover_IGO2012 = string.valueof(fr.Gross_Profit_Regional__c);
                             }
                             else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && fr.Name == IPM_ConstantUtils.YEAR_2012 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                             {
                                prwp.turnover_ITO2012 = string.valueof(fr.Turnover_Regional__c); 
                                prwp.turnover_IGO2012 = string.valueof(fr.Gross_Profit_Regional__c); 
                             }
                             // ITO 2013
                              if(pRoll.IPM_Rollout_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL && fr.Name == IPM_ConstantUtils.YEAR_2013 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                              {
                                prwp.turnover_ITO2013 = string.valueof(fr.Turnover_Local__c);
                                prwp.turnover_IGO2013 = string.valueof(fr.Gross_Profit_Local__c);
                              }
                             else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && fr.Name == IPM_ConstantUtils.YEAR_2013 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                             {   
                                 prwp.turnover_ITO2013 = string.valueof(fr.Turnover_Regional__c);
                                 prwp.turnover_IGO2013 = string.valueof(fr.Gross_Profit_Regional__c);
                             }
                             else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && fr.Name == IPM_ConstantUtils.YEAR_2013 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                             {   
                                 prwp.turnover_ITO2013 = string.valueof(fr.Turnover_Regional__c);
                                 prwp.turnover_IGO2013 = string.valueof(fr.Gross_Profit_Regional__c);
                             }
                             // ITO 2014
                              if(pRoll.IPM_Rollout_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL && fr.Name == IPM_ConstantUtils.YEAR_2014 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                              { 
                                  prwp.turnover_ITO2014 = string.valueof(fr.Turnover_Local__c);
                                  prwp.turnover_IGO2014 = string.valueof(fr.Gross_Profit_Local__c);
                              }
                             else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && fr.Name == IPM_ConstantUtils.YEAR_2014 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                             {  
                                  prwp.turnover_ITO2014 = string.valueof(fr.Turnover_Regional__c);
                                  prwp.turnover_IGO2014 = string.valueof(fr.Gross_Profit_Regional__c);
                             }
                             else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && fr.Name == IPM_ConstantUtils.YEAR_2014 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                              { 
                                   prwp.turnover_ITO2014 = string.valueof(fr.Turnover_Regional__c);
                                   prwp.turnover_IGO2014 = string.valueof(fr.Gross_Profit_Global__c);
                              }
                            // ITO 2015
                              if(pRoll.IPM_Rollout_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL && fr.Name == IPM_ConstantUtils.YEAR_2015 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                              {  
                                  prwp.turnover_ITO2015 = string.valueof(fr.Turnover_Local__c);
                                  prwp.turnover_IGO2015 = string.valueof(fr.Gross_Profit_Local__c);
                              }
                             else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && fr.Name == IPM_ConstantUtils.YEAR_2015 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                             {   
                                 prwp.turnover_ITO2015 = string.valueof(fr.Turnover_Regional__c);
                                 prwp.turnover_IGO2015 = string.valueof(fr.Gross_Profit_Regional__c);
                             }
                             else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && fr.Name == IPM_ConstantUtils.YEAR_2015 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                             {   
                                 prwp.turnover_ITO2015 = string.valueof(fr.Turnover_Regional__c);
                                 prwp.turnover_IGO2015 = string.valueof(fr.Gross_Profit_Regional__c);
                             }
                            // ITO 2016
                              if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL && fr.Name == IPM_ConstantUtils.YEAR_2016 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                              {  
                                  prwp.turnover_ITO2016 = string.valueof(fr.Turnover_Local__c);
                                  prwp.turnover_IGO2016 = string.valueof(fr.Gross_Profit_Local__c);
                              }
                             else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && fr.Name == IPM_ConstantUtils.YEAR_2016 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                              {  
                                  prwp.turnover_ITO2016 = string.valueof(fr.Turnover_Regional__c);
                                    prwp.turnover_IGO2016 = string.valueof(fr.Gross_Profit_Regional__c);
                              }
                             else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && fr.Name == IPM_ConstantUtils.YEAR_2016 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                              {  
                                  prwp.turnover_ITO2016 = string.valueof(fr.Turnover_Regional__c);
                                  prwp.turnover_IGO2016 = string.valueof(fr.Gross_Profit_Regional__c);
                              }
                            // ITO 2017
                              if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL && fr.Name == IPM_ConstantUtils.YEAR_2017 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                              { 
                                   prwp.turnover_ITO2017 = string.valueof(fr.Turnover_Local__c);
                                    prwp.turnover_IGO2017 = string.valueof(fr.Gross_Profit_Local__c);
                              }
                             else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && fr.Name == IPM_ConstantUtils.YEAR_2017 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                             { 
                               prwp.turnover_ITO2017 = string.valueof(fr.Turnover_Regional__c);
                               prwp.turnover_IGO2017 = string.valueof(fr.Gross_Profit_Regional__c); 
                             }
                             else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && fr.Name == IPM_ConstantUtils.YEAR_2017 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                             {
                                prwp.turnover_ITO2017 = string.valueof(fr.Turnover_Regional__c); 
                                   prwp.turnover_IGO2017 = string.valueof(fr.Gross_Profit_Regional__c); 
                             }
                             // ITO 2018
                              if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL && fr.Name == IPM_ConstantUtils.YEAR_2018 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                              { 
                                   prwp.turnover_ITO2018 = string.valueof(fr.Turnover_Local__c);
                                    prwp.turnover_IGO2018 = string.valueof(fr.Gross_Profit_Local__c);
                              }
                             else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && fr.Name == IPM_ConstantUtils.YEAR_2018 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                              {  
                                  prwp.turnover_ITO2018 = string.valueof(fr.Turnover_Regional__c);
                                  prwp.turnover_IGO2018 = string.valueof(fr.Gross_Profit_Regional__c);
                              }
                             else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && fr.Name == IPM_ConstantUtils.YEAR_2018 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                             { 
                                   prwp.turnover_ITO2018 = string.valueof(fr.Turnover_Regional__c);
                                     prwp.turnover_IGO2018 = string.valueof(fr.Gross_Profit_Regional__c);
                             }
                            // ITO 2019
                              if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL && fr.Name == IPM_ConstantUtils.YEAR_2019 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                              { 
                                   prwp.turnover_ITO2019 = string.valueof(fr.Turnover_Local__c);
                                    prwp.turnover_IGO2019 = string.valueof(fr.Gross_Profit_Local__c);
                              }
                             else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && fr.Name == IPM_ConstantUtils.YEAR_2019 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                             { 
                                prwp.turnover_ITO2019 = string.valueof(fr.Turnover_Regional__c);
                                 prwp.turnover_IGO2019 = string.valueof(fr.Gross_Profit_Regional__c);
                             }
                             else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && fr.Name == IPM_ConstantUtils.YEAR_2019 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                             {
                                prwp.turnover_ITO2019 = string.valueof(fr.Turnover_Regional__c);
                                   prwp.turnover_IGO2019 = string.valueof(fr.Gross_Profit_Regional__c);
                             }
                            // ITO 2020
                              if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL && fr.Name == IPM_ConstantUtils.YEAR_2020 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                               { 
                                   prwp.turnover_ITO2020 = string.valueof(fr.Turnover_Local__c);
                                   prwp.turnover_IGO2020 = string.valueof(fr.Gross_Profit_Local__c);
                               }
                             else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && fr.Name == IPM_ConstantUtils.YEAR_2020 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                             {  
                                  prwp.turnover_ITO2020 = string.valueof(fr.Turnover_Regional__c);
                                   prwp.turnover_IGO2020 = string.valueof(fr.Gross_Profit_Regional__c);
                             }
                             else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && fr.Name == IPM_ConstantUtils.YEAR_2020 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                             {
                                prwp.turnover_ITO2020 = string.valueof(fr.Turnover_Regional__c);
                                   prwp.turnover_IGO2020 = string.valueof(fr.Gross_Profit_Regional__c);
                             }
                             
                             //Y3 iTO
                             
                              if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL && fr.Year__c == IPM_ConstantUtils.Y3_YEARINDEX && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                               { 
                                   prwp.y3_ITO = string.valueof(fr.Turnover_Local__c);
                                  
                               }
                             else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && fr.Year__c == IPM_ConstantUtils.Y3_YEARINDEX && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                             {  
                                  prwp.y3_ITO  = string.valueof(fr.Turnover_Regional__c);
                                   
                             }
                             else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && fr.Year__c == IPM_ConstantUtils.Y3_YEARINDEX && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                             {
                                prwp.y3_ITO = string.valueof(fr.Turnover_Regional__c);
                                  
                             }
                             
                              //Y3 GTO
                             
                              if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL && fr.Year__c == IPM_ConstantUtils.Y3_YEARINDEX && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                               { 
                                   prwp.y3_GTO = string.valueof(fr.Turnover_Local__c);
                                  
                               }
                             else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && fr.Year__c == IPM_ConstantUtils.Y3_YEARINDEX && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                             {  
                                  prwp.y3_GTO  = string.valueof(fr.Turnover_Regional__c);
                                   
                             }
                             else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && fr.Year__c == IPM_ConstantUtils.Y3_YEARINDEX && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS)
                             {
                                prwp.y3_GTO = string.valueof(fr.Turnover_Regional__c);
                                  
                             }
                             
                             // a&p
                            if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL && fr.Name == IPM_ConstantUtils.YEAR_2012 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                               { 
                                   prwp.turnover_ap2012= string.valueof(fr.Advertising_Promotions_Local__c);
                                 
                               }
                             else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && fr.Name == IPM_ConstantUtils.YEAR_2012 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                             {  
                                  prwp.turnover_ap2012= string.valueof(fr.Advertising_Promotions_Regional__c);
                                   
                             }
                             else if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && fr.Name == IPM_ConstantUtils.YEAR_2012 && fr.Year_Type__c == IPM_ConstantUtils.YEAR_TYPE_CALENDAR && fr.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL)
                             {
                                prwp.turnover_ap2012= string.valueof(fr.Advertising_Promotions_Regional__c);
                               
                             }
                             
                             //if(sFinancial_External_ID.contains(IPM_ConstantUtils.FINANCIAL_CONSOLIDATE)){
                                 if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL){
                                     prwp.BusinessImpact = fr.IPM_Financial__r.Business_Impact_Regional__c;
                                     prwp.threshold=fr.IPM_Financial__r.Threshold__c;
                                 }
                                 
                                  /*if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && pRoll.IPM_Rollout_Span__c==IPM_ConstantUtils.PROJECT_SPAN_REGIONAL){
                                     prwp.proj.IPM_Target_Launch_Dates__c=pRoll.Target_Launch_Date__c;
                                 }*/
                                 
                                 if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL){
                                     prwp.BusinessImpact =fr.IPM_Financial__r.Business_Impact_Regional__c;
                                      prwp.threshold=fr.IPM_Financial__r.Threshold__c;
                                 }
                                 if(proj.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL){
                                     prwp.BusinessImpact =fr.IPM_Financial__r.Business_Impact_Local__c;
                                      prwp.threshold=fr.IPM_Financial__r.Threshold__c;
                                 }
                             //}
                             
                             //prwp.threshold=fr.IPM_Financial__r.Threshold__c;
                             //prwp.misaligned=fr.IPM_Financial__r.Misaligned__c; 
                         
                        }
                    }
                lstProjectWrap.add(prwp);
            }
        }
        return null;
    }
    public class ProjectWrapper{
    
        ProjectWrapper(){
        }
    
       ProjectWrapper(ProjectWrapper pw){
            this.proj=pw.proj;
            this.BusinessImpact=pw.BusinessImpact;
            this.masterCluster=pw.masterCluster;
            this.threshold =pw.threshold ;
            this.misaligned  =pw.misaligned ;
            this.status=pw.status;
            this.geography  =pw.geography ;
            this.projecttype=pw.projecttype;
            this.charterDueDate=pw.charterDueDate;
            this.chartercompletedDate=pw.chartercompletedDate;
            this.contractDueDate=pw.contractDueDate;
            this.charterProposedDate=pw.charterProposedDate;
            this.contractProposedDate=pw.contractProposedDate;
            this.readyProposedDate=pw.readyProposedDate;
            this.deployProposedDate=pw.deployProposedDate;
            this.contractcompletedDate=pw.contractcompletedDate;
            this.readyDueDate=pw.readyDueDate;
            this.readycompletedDate=pw.readycompletedDate;
            this.deployDueDate=pw.deployDueDate;
            this.deploycompletedDate=pw.deploycompletedDate;
            this.isOriginal=pw.isOriginal;
            this.isRollOut=pw.isRollOut;
            this.shipToYear=pw.shipToYear;
            this.shipToMonth=pw.shipToMonth;
            this.actualyear=pw.actualyear;
            this.turnover=pw.turnover;
            this.turnover_ito=pw.turnover_ito;
            this.turnover_igp=pw.turnover_igp;
            this.turnover_2012=pw.turnover_2012;
            this.turnover_2013=pw.turnover_2013;
            this.turnover_2014=pw.turnover_2014;
            this.turnover_2015=pw.turnover_2015;
            this.turnover_2016=pw.turnover_2016;
            this.turnover_2017=pw.turnover_2017;
            this.turnover_2018=pw.turnover_2018;
            this.turnover_2019=pw.turnover_2019;
            this.turnover_2020=pw.turnover_2020;
            this.turnover_ITO2012=pw.turnover_ITO2012;
            this.turnover_ITO2013 =pw.turnover_ITO2013;
            this.turnover_ITO2014 =pw.turnover_ITO2014;
            this.turnover_ITO2015 =pw.turnover_ITO2015;
            this.turnover_ITO2016 =pw.turnover_ITO2016;
            this.turnover_ITO2017 =pw.turnover_ITO2017;
            this.turnover_ITO2018 =pw.turnover_ITO2018;
            this.turnover_ITO2019 =pw.turnover_ITO2019;
            this.turnover_ITO2020 =pw.turnover_ITO2020;
            this.turnover_IGO2012 =pw.turnover_IGO2012;
            this.turnover_IGO2013 =pw.turnover_IGO2013;
            this.turnover_IGO2014 =pw.turnover_IGO2014;
            this.turnover_IGO2015 =pw.turnover_IGO2015;
            this.turnover_IGO2016 =pw.turnover_IGO2016;
            this.turnover_IGO2017 =pw.turnover_IGO2017;
            this.turnover_IGO2018 =pw.turnover_IGO2018;
            this.turnover_IGO2019=pw.turnover_IGO2019;
            this.turnover_IGO2020 =pw.turnover_IGO2020;
            this.turnover_ap2012 =pw.turnover_ap2012;
            this.y3_GTO  =pw.y3_GTO ;
            this.y3_ITO  =pw.y3_ITO ;
       }
       
        public IPM_Project__c proj{get; set;}
        public String BusinessImpact{get; set;}
        //public String BusinessImpactRegional{get; set;}
        //public String BusinessImpactLocal{get; set;}
        public string masterCluster{get; set;}
        public Decimal threshold {get;set;} 
        public Boolean misaligned {get;set;}
        public string status{get; set;}
        public String geography {get;set;}
        public string projecttype{get; set;}
        public Date charterDueDate{get; set;}
        public Date chartercompletedDate{get; set;}
        public Date contractDueDate{get; set;}
        public Date charterProposedDate{get; set;}
        public Date contractProposedDate{get; set;}
        public Date readyProposedDate{get; set;}
        public Date deployProposedDate{get; set;}
        public Date contractcompletedDate{get; set;}
        public Date readyDueDate{get; set;}
        public Date readycompletedDate{get; set;}
        public Date deployDueDate{get; set;}
        public Date deploycompletedDate{get; set;}
        public boolean isOriginal{get; set;}
        public boolean isRollOut{get; set;}
        public string shipToYear{get; set;}
        public string shipToMonth{get; set;}
        public Date actualyear{get; set;}
        Public string turnover{get; set;}
        Public decimal turnover_ito{get; set;}
        Public decimal  turnover_igp{get; set;}
        Public string turnover_2012{get; set;}
        Public string turnover_2013{get; set;}
        Public string turnover_2014{get; set;}
        Public string turnover_2015{get; set;}
        Public string turnover_2016{get; set;}
        Public string turnover_2017{get; set;}
        Public string turnover_2018{get; set;}
        Public string turnover_2019{get; set;}
        Public string turnover_2020{get; set;}
        Public string turnover_ITO2012{get; set;}
        Public string turnover_ITO2013{set;get;}
        Public string turnover_ITO2014{set;get;}
        Public string turnover_ITO2015{set;get;}
        Public string turnover_ITO2016{set;get;}
        Public string turnover_ITO2017{set;get;}
        Public string turnover_ITO2018{set;get;}
        Public string turnover_ITO2019{set;get;} 
        Public string turnover_ITO2020{set;get;}
        Public string turnover_IGO2012{set;get;}
        Public string turnover_IGO2013{set;get;}
        Public string turnover_IGO2014{set;get;}
        Public string turnover_IGO2015{set;get;}
        Public string turnover_IGO2016{set;get;}
        Public string turnover_IGO2017{set;get;}
        Public string turnover_IGO2018{set;get;}
        Public string turnover_IGO2019{set;get;} 
        Public string turnover_IGO2020{set;get;}
        Public string turnover_ap2012{set;get;}
        Public string y3_GTO {set;get;}
        Public string y3_ITO {set;get;}
    }
}