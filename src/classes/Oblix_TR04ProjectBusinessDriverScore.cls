/** 
    S.M. 2016-03-12 - THIS CLASS IS NO LONGER USED!! 
    Replaced by Oblix_ProjectHandlerLogic as part of code refactoring

    About
    -----
    Description: Class Oblix_TR04ProjectBusinessDriverScore
    Created for: Oblix Unilever Project
    Create date: 10/ 2015
    Created by Jamal Rida
    Author : @Jamal
    Details
    -------
    This class is  : used as a fired class from Trigger  "After insert, update, delete" on SOW Asset object, to calculate the TotalProjectFee
                  information retrieved from : Porject Split "Countries" then retrieve from Calculator the related Box range record,
                  calculate the TotalBusinessvaluedriverScore then the TotalProjectScore, and that value is between >Low_Point and High_Point
                   from Calculator, and this fits into a box number
                  to be selected from Calculator "Countries" then Calculate the Fee on the project
                        
            Functionnalities : 
                    
    Update History 
    --------------    
*/
public with sharing class Oblix_TR04ProjectBusinessDriverScore {
    /*
    *    @Description : This method is used to return the list of SOW Project records to calculalte Ascoring and Total Campaign Fees
    *    @Param : lstProjTrig from Trigger
    *    @return : List<Oblix_SOW_Projects__c>
    */
    //public static List<Oblix_SOW_Projects__c> retrieveProject(List<Oblix_SOW_Projects__c> lstProjTrig){
    //    return [Select o.Total_Value_Driver__c, o.ProjectTotalAssetScore__c, o.Innovation_Projects__c, o.Brand_Led_Growth__c, o.Total_Project_Score__c, o.Total_Fees_for_Project__c, o.Project_Stage__c, o.Project_Scale_2__c, o.Project_Scale_1__c, o.Oblix_ProjectBoxNumber__c, o.Campaign_Countries__c, o.Name, o.Id, o.Campaign_Total_Fees__c, o.Campaign_Total_Adjustment__c, o.Campaign_Status__c, o.Campaign_Idea__c, o.Campaign_Fees_Total__c From Oblix_SOW_Projects__c o  where id in :lstProjTrig];
    //}
    
   
    ///*
    //*   @Description : Method used to get Innovation Score for project
    //*   @param  : project Id
    //*   @return : Decimalscore innovation
    //*/
    //private Decimal getScoreInnovation(Oblix_SOW_Projects__c project){
    //    Decimal score_innonvationLoc = 0;
    //    if(project.Innovation_Projects__c == Oblix_Constants.Innovation_Projects_Innovation){
    //                          System.debug('###Innovation : '+project.Innovation_Projects__c);
    //                        if(project.Brand_Led_Growth__c == Oblix_Constants.BrandLedGrowth_IncremTurnoverLess10){
    //                            score_innonvationLoc = 0.150;
    //                        }else if(project.Brand_Led_Growth__c == Oblix_Constants.BrandLedGrowth_IncremTurnover1020){
    //                            score_innonvationLoc = 0.250;
    //                        }else if(project.Brand_Led_Growth__c == Oblix_Constants.BrandLedGrowth_IncremTurnoverLess2030){
    //                            score_innonvationLoc = 0.350;
    //                        }else if(project.Brand_Led_Growth__c == Oblix_Constants.BrandLedGrowth_IncremTurnoverLess3040){
    //                            score_innonvationLoc = 0.450;
    //                        }else if(project.Brand_Led_Growth__c == Oblix_Constants.BrandLedGrowth_IncremTurnoverLessAbove40){
    //                            score_innonvationLoc = 0.500;
    //                        }else {
    //                            score_innonvationLoc = 0;
    //                        }
    //                        System.debug('###score_innonvationLoc : '+score_innonvationLoc );
    //     }
    //     return score_innonvationLoc ;
    //}
    
    ///*
    //*   @Description : Method used to get Brand Led Growth Score for project
    //*   @param  : project Id
    //*   @return : Decimalscore Brand Led Growth
    //*/
    //private Decimal getScoreBrandLedGrowth(Oblix_SOW_Projects__c project){
    //     Decimal score_brandLedGrowthLoc = 0;
    //     if(project.Innovation_Projects__c == Oblix_Constants.Innovation_Projects_BrandLedGrowth){
    //                        if(project.Brand_Led_Growth__c == Oblix_Constants.BrandLedGrowth_Less100){
    //                            score_brandLedGrowthLoc = 0.150;
    //                        }else if(project.Brand_Led_Growth__c == Oblix_Constants.BrandLedGrowth_100_200){
    //                            score_brandLedGrowthLoc = 0.250;
    //                        }else if(project.Brand_Led_Growth__c == Oblix_Constants.BrandLedGrowth_IncremTurnover200_300){
    //                            score_brandLedGrowthLoc = 0.350;
    //                        }else if(project.Brand_Led_Growth__c == Oblix_Constants.BrandLedGrowth_IncremTurnoverLess300_400){
    //                            score_brandLedGrowthLoc = 0.450;
    //                        }else if(project.Brand_Led_Growth__c == Oblix_Constants.BrandLedGrowth_IncremTurnoverLessAbove400){
    //                            score_brandLedGrowthLoc = 0.500;
    //                        }else{
    //                            score_brandLedGrowthLoc =0;
    //                        }
    //                        System.debug('###project.Innovation_Projects__c: '+project.Innovation_Projects__c);
    //                        System.debug('###score_brandLedGrowthLoc : '+score_brandLedGrowthLoc);
    //     }
    //     return score_brandLedGrowthLoc;
    //}
    
    ///*
    //*   @Description : Method used to get Market Score for project
    //*   @param  : project Id
    //*   @return : Decimalscore Market
    //*/
    //private Decimal getScoreMarket(Oblix_SOW_Projects__c project){
    //     Decimal score_marketLoc = 0;
    //     System.debug('###project.Project_Scale_1__c : '+project.Project_Scale_1__c);
    //     if(project.Project_Scale_1__c != null){
    //                    if(project.Project_Scale_1__c == Oblix_Constants.Innovation_Projects_Market1){
    //                    score_marketLoc = 0.150;
    //                    }else if(project.Project_Scale_1__c == Oblix_Constants.Innovation_Projects_Market2){
    //                        score_marketLoc = 0.250;
    //                    }else if(project.Project_Scale_1__c == Oblix_Constants.Innovation_Projects_Market3){
    //                        score_marketLoc = 0.350;
    //                    }else if(project.Project_Scale_1__c == Oblix_Constants.Innovation_Projects_Market4){
    //                        score_marketLoc = 0.450;
    //                    }else if(project.Project_Scale_1__c == Oblix_Constants.Innovation_Projects_Market5){
    //                        score_marketLoc = 0.500;
    //                         System.debug('###project.score_marketLoc : '+score_marketLoc);
    //                    }else{
    //                        score_marketLoc = 0;
    //                    }   
    //     }
    //     return score_marketLoc;
    //}
    
    ///*
    //*   @Description : Method used to get Hubs Score for project
    //*   @param  : project Id
    //*   @return : Decimalscore Market
    //*/
    //private Decimal getScoreHubs(Oblix_SOW_Projects__c project){
    //    Decimal score_hubPartnerLoc = 0;
    //    if(project.Project_Scale_2__c != null){
    //                    if(project.Project_Scale_2__c == Oblix_Constants.Innovation_Projects_HubsPartners1){
    //                    score_hubPartnerLoc = 0.100;
    //                    }else if(project.Project_Scale_2__c == Oblix_Constants.Innovation_Projects_HubsPartners2){
    //                        score_hubPartnerLoc = 0.150;
    //                    }else if(project.Project_Scale_2__c == Oblix_Constants.Innovation_Projects_HubsPartners3){
    //                        score_hubPartnerLoc = 0.200;
    //                    }else if(project.Project_Scale_2__c == Oblix_Constants.Innovation_Projects_HubsPartners4){
    //                        score_hubPartnerLoc = 0.250;
    //                    }else if(project.Project_Scale_2__c == Oblix_Constants.Innovation_Projects_HubsPartners5){
    //                        score_hubPartnerLoc = 0.300;
    //                    }else{
    //                        score_hubPartnerLoc = 0;
    //                    } 
    //    }
    //    return score_hubPartnerLoc;
    //}
    ///*
    //*   @Description : Method used to get Hubs Score for project
    //*   @param  : project Id
    //*   @return : Decimalscore Campaign
    //*/
    //private Decimal getScoreCampaign(Oblix_SOW_Projects__c project){
    //    Decimal score_campaignIdeaLoc =0;
    //    if(project.Campaign_Idea__c != null){
    //                    if(project.Campaign_Idea__c == Oblix_Constants.Innovation_Projects_Existing){
    //                    score_campaignIdeaLoc = 0.600;
    //                    }else if(project.Campaign_Idea__c == Oblix_Constants.Innovation_Projects_NewOne){
    //                        score_campaignIdeaLoc = 1.000;
    //                    }else if(project.Campaign_Idea__c == Oblix_Constants.Innovation_Projects_NewMulti){
    //                        score_campaignIdeaLoc = 1.200;
    //                    }else{
    //                        score_campaignIdeaLoc = 0;
    //                    }
    //     }
    //     return score_campaignIdeaLoc;
    //}
    
    ///*
    //*   @Description : Method used to get collection for each project a list of splits 
    //*   @param  : List<Oblix_Marketing_SOW_Project_Splits__c>
    //*   @return : Map <Id, List<Oblix_Marketing_SOW_Project_Splits__c>>
    //*/    
    ////private Map <Id, List<Oblix_Marketing_SOW_Project_Splits__c>> getProjectToSplits(List<Oblix_Marketing_SOW_Project_Splits__c> lstProjectSplits_Loc){
    ////    Map <Id, List<Oblix_Marketing_SOW_Project_Splits__c>> mapProjectToSplits_Loc = new Map <Id, List<Oblix_Marketing_SOW_Project_Splits__c>>();
    ////    if(!lstProjectSplits_Loc.isEmpty()){
    ////            for(Oblix_Marketing_SOW_Project_Splits__c projSplit : lstProjectSplits_Loc){
    ////                if(!mapProjectToSplits_Loc.containsKey(projSplit.Project_Splits__c)){
    ////                    mapProjectToSplits_Loc.put(projSplit.Project_Splits__c, new List<Oblix_Marketing_SOW_Project_Splits__c>());
    ////                }
    ////                mapProjectToSplits_Loc.get(projSplit.Project_Splits__c).add(projSplit);
    ////            }
    ////    }
    ////    return mapProjectToSplits_Loc;
    ////}
    

    ///*
    //*   @Description : Method used to get set of Countries 
    //*   @param  : List<Oblix_Marketing_SOW_Project_Splits__c>
    //*   @return : set<Id>
    //*/   
    //private set<String> getSetCountriesNames(List<Oblix_Marketing_SOW_Project_Splits__c> lstProjectSplits_Loc){
    //    set<String> setCountries_Loc = new set<String>();
    //    if(!lstProjectSplits_Loc.isEmpty()){
    //            for(Oblix_Marketing_SOW_Project_Splits__c projSplit : lstProjectSplits_Loc){
    //                setCountries_Loc.add(projSplit.OblixCountry__r.Name);
    //            }
    //    }
    //    return setCountries_Loc;
    //}
    
    // /*
    //*    @Description : List of  Campaigns with More quiery fields.
    //*    @Param :  lstProjectTrigger
    //*    @return :  List<Oblix_SOW_Projects__c>
    //*/
    // public static List<Oblix_SOW_Projects__c> getCampaignsByIds(List<Oblix_SOW_Projects__c> lstProjectTrigger) {
    //    return [Select Id, Name, Financial_Year__c, Financial_Year__r.Financial_Year__c from Oblix_SOW_Projects__c where id in: lstProjectTrigger];
    //}
    // /*
    //*    @Description : List of Split by Campaign
    //*    @Param :  lstProjectTrigger
    //*    @return :  List<Oblix_Marketing_SOW_Project_Splits__c>
    //*/
    //public static List<Oblix_Marketing_SOW_Project_Splits__c> getSplitsByProjects(List<Oblix_SOW_Projects__c> lstProjectTrigger){
    //    return [Select Id, Name, Project_Splits__c, OblixCountry__c, OblixCountry__r.Name, Percentage__c from Oblix_Marketing_SOW_Project_Splits__c where Project_Splits__c in : lstProjectTrigger and Project_Splits__c != null];
    //}
    // /*
    //*    @Description : List of Oblix Calculator with these Countries and RT  = Country_Box_Number // For every Calculator associate its related Split Project.
    //*    @Param : projectTrig, lstProjectSplits 
    //*    @return :  List<Oblix_Calculator__c>
    //*/
    //public static List<Oblix_Calculator__c> getOblixCalculators(List<Oblix_SOW_Projects__c> lstProjectTrigger, List<Oblix_Marketing_SOW_Project_Splits__c> lstProjectSplits ){
    //     Oblix_TR04ProjectBusinessDriverScore instanceTR04 = new Oblix_TR04ProjectBusinessDriverScore();
    //    //List<Oblix_Marketing_SOW_Project_Splits__c>  lstProjectSplits = [Select Id, Name, Project_Splits__c, OblixCountry__c, OblixCountry__r.Name, Percentage__c from Oblix_Marketing_SOW_Project_Splits__c where Project_Splits__c in : lstProjectTrigger and Project_Splits__c != null];
    //    Set<String> setCountries = instanceTR04.getSetCountriesNames(lstProjectSplits);
    //    return   [Select Id, Name, Points_Low__c, Points_HigH__c, Box_Range__c, Financial_Year__c
    //        ,Box_9__c, Box_8__c, Box_7__c, Box_6__c, Box_5__c, Box_4__c, Box_3__c, Box_2__c, Box_20__c, Box_1__c, Box_19__c, Box_18__c, Box_17__c, Box_16__c, Box_15__c, Box_14__c, Box_13__c, Box_12__c, Box_11__c, Box_10__c
    //        FROM Oblix_Calculator__c WHERE RecordTypeId =: Oblix_Utils.MapRecordType('Oblix_Calculator__c').get('Country_Box_Number') and  Name in: setCountries
    //        ];
    //}
    
    ///*
    //*    @Description : This method returns the list of calculator records used for campaign total fees
    //*    @Param : --
    //*    @return : the list of calculator records with record type of Box_Range - List<Oblix_Calculator__c>
    //*/
    //public static List<Oblix_Calculator__c> getCalculatorBoxRange(){
    //    return [Select Id, Name, Points_Low__c, Points_HigH__c, Box_Range__c, Financial_Year__c,
    //                 Box_9__c, Box_8__c, Box_7__c, Box_6__c, Box_5__c, Box_4__c, Box_3__c, Box_2__c, Box_20__c, Box_1__c, Box_19__c, Box_18__c, Box_17__c, Box_16__c, Box_15__c, Box_14__c, Box_13__c, Box_12__c, Box_11__c, Box_10__c 
    //                 from Oblix_Calculator__c where RecordTypeId =: Oblix_Utils.MapRecordType('Oblix_Calculator__c').get('Box_Range')];
    //}

    
    // /*
    //*   @Description : Get a map of Project Id and the related project split records
    //*   @param  : List<Oblix_SOW_Projects__c>
    //*   @return : Map<Id, List<Oblix_Marketing_SOW_Project_Splits__c>>
    //*/    
    //public static Map<Id, List<Oblix_Marketing_SOW_Project_Splits__c>> getProjectAndTheRelatedProjectSplits(List<Oblix_SOW_Projects__c> li_projects){
        
    //    Set<Id> sid_project_ids = new Set<Id>();

    //    // get the project ids in scope
    //    for (Oblix_SOW_Projects__c project: li_projects){
    //        sid_project_ids.add(project.Id);
    //    }

    //    // build a map of project id and the related project splits
    //    Map<Id,List<Oblix_Marketing_SOW_Project_Splits__c>> mid_liso_projects_ids_with_related_project_splits = new Map<Id,List<Oblix_Marketing_SOW_Project_Splits__c>>();
        
    //    for (Oblix_Marketing_SOW_Project_Splits__c project_splits: [Select Name, Project_Splits__c, OblixCountry__c, OblixCountry__r.Name, Percentage__c 
    //        FROM Oblix_Marketing_SOW_Project_Splits__c WHERE Project_Splits__c in : sid_project_ids AND Project_Splits__c != NULL]){

    //        if (!mid_liso_projects_ids_with_related_project_splits.containsKey(project_splits.Project_Splits__c)){
    //            mid_liso_projects_ids_with_related_project_splits.put(project_splits.Project_Splits__c, new List<Oblix_Marketing_SOW_Project_Splits__c>());
    //        }

    //        mid_liso_projects_ids_with_related_project_splits.get(project_splits.Project_Splits__c).add(project_splits);
    //    }

    //    return mid_liso_projects_ids_with_related_project_splits;
    //}

    ///*
    //*    @Description : This method is used to calculate : Total Calculated Fee in a campaign
    //*    @Param : projectTrig, lstProjTrig from Trigger
    //*    @return : void
    //*/
    //public static void updateProjectCalculatorFees(Oblix_SOW_Projects__c projectTrig, List<Oblix_SOW_Projects__c> lstProjectTrigger, List<Oblix_SOW_Projects__c> lstProjectsQueried
    //    , List<Oblix_Calculator__c> lstCalculatorCountryRange, List<Oblix_Calculator__c> lstCalculatorBoxRange, Map<Id, List<Oblix_Marketing_SOW_Project_Splits__c>> mapProjectToSplits ){
    //         //List of Oblix Calculator
    //    Oblix_TR04ProjectBusinessDriverScore instanceTR04 = new Oblix_TR04ProjectBusinessDriverScore();

    //    Set<Id> setProjectIds = getProjectIds(lstProjectTrigger, projectTrig);

    //    // S.M. 20160121 - commenting out below lines as is causing too many soql query error!
    //    //List<Oblix_Marketing_SOW_Project_Splits__c>  lstProjectSplits = [Select Id, Name, Project_Splits__c, OblixCountry__c, OblixCountry__r.Name, Percentage__c from Oblix_Marketing_SOW_Project_Splits__c where Project_Splits__c in : setProjectIds and Project_Splits__c != null];
    //    //Map<Id,List<Oblix_Marketing_SOW_Project_Splits__c>> mapProjectToSplits = new Map <Id, List<Oblix_Marketing_SOW_Project_Splits__c>>();
        
    //   // Set<String> setCountries = instanceTR04.getSetCountriesNames(lstProjectSplits);

    //    //mapProjectToSplits = instanceTR04.getProjectToSplits(lstProjectSplits);
        
    //    //system.Debug('###setCountries : '+setCountries);
        
    //    Map<Id,String> mapProjectToFinancialYear = getMapOfProjectToFinancialYear(lstProjectTrigger, projectTrig, setProjectIds, lstProjectsQueried);
    //    //List of Oblix Calculator with these Countries and RT  = Country_Box_Number // For very Calculator associate its related Split Project.
    //    //Loop Over Project for the Initial requirement : calculating Score
    //    for(Oblix_SOW_Projects__c project : lstProjectTrigger){
            
    //        setProjectAttributes(project, projectTrig,lstCalculatorBoxRange, lstCalculatorCountryRange, mapProjectToFinancialYear, instanceTR04, mapProjectToSplits);
    //    }
    //}

    //private static Set<Id> getProjectIds(List<Oblix_SOW_Projects__c> lstProjectTrigger, Oblix_SOW_Projects__c projectTrig){
    //    Set<Id> setProjectIds = new set<Id>();
        
    //    for(Oblix_SOW_Projects__c project : lstProjectTrigger){
    //        if(project.Id == projectTrig.Id){
    //            setProjectIds.add(project.Id);
    //        }
    //    }

    //    return setProjectIds;
    //}


    //private static Map<Id,String> getMapOfProjectToFinancialYear(List<Oblix_SOW_Projects__c> lstProjectTrigger, Oblix_SOW_Projects__c projectTrig, Set<Id> setProjectIds, List<Oblix_SOW_Projects__c> lstProjectTriggerTmp){
       
    //    Map<Id,String> mapProjectToFinancialYear = new Map<Id, String>();

    //    for(Oblix_SOW_Projects__c projTmp : lstProjectTriggerTmp){
    //        if(!mapProjectToFinancialYear.containsKey(projTmp.Id)){
    //            mapProjectToFinancialYear.put(projTmp.Id, projTmp.Financial_Year__r.Financial_Year__c);
    //        }
    //    }

    //    return mapProjectToFinancialYear;
    //}

    //private static void setProjectAttributes(Oblix_SOW_Projects__c project, Oblix_SOW_Projects__c projectTrig, List<Oblix_Calculator__c> lstCalculatorBoxRange
    //    , List<Oblix_Calculator__c> lstCalculatorCountryRange, Map<Id,String> mapProjectToFinancialYear, Oblix_TR04ProjectBusinessDriverScore instanceTR04
    //    , Map<Id,List<Oblix_Marketing_SOW_Project_Splits__c>> mapProjectToSplits ){
            
    //    if(project.Id == projectTrig.Id){
    //        Decimal score_innonvation = 0;
    //        Decimal score_brandLedGrowth = 0;
    //        Decimal score_market = 0;
    //        Decimal score_hubPartner =0;
    //        Decimal score_campaignIdea =0;
    //        Decimal TotalBusinessvaluedriverScore = 0;
    //        Decimal TotalProjectScore = 0;
    //        Decimal tmp_projectFee = 0;
            
    //        String Calculator_BoxRange = '';

    //        //Business Value Creation == INNOVATION
    //        if(project.Innovation_Projects__c != null){
    //            score_innonvation = instanceTR04.getScoreInnovation(project);
    //            //Business Value Creation BrandLedGrowth
    //            score_brandLedGrowth = instanceTR04.getScoreBrandLedGrowth(project);
    //        }

    //        //Business Value    Number of markets  
    //        score_market = instanceTR04.getScoreMarket(project);

    //        //System.debug('###score_market : '+score_market );
    //        //Business Value Number of hubs or partners
        
    //        score_hubPartner = instanceTR04.getScoreHubs(project);
    //        //System.debug('###score_hubPartner : '+score_hubPartner);
    //        //Business Value Campaign Idea
    //        score_campaignIdea = instanceTR04.getScoreCampaign(project);

    //        //System.debug('###score_campaignIdea : '+score_campaignIdea );


    //        //Calculate TotalBusinessvaluedriverScore
    //        TotalBusinessvaluedriverScore = score_innonvation+score_brandLedGrowth+score_market+score_hubPartner+score_campaignIdea+TotalBusinessvaluedriverScore;

    //        project.Total_Value_Driver__c = TotalBusinessvaluedriverScore;
    //        //System.debug('###project.Total_Value_Driver__c : '+project.Total_Value_Driver__c);
    //        //System.debug('###project.ProjectTotalAssetScore__c : '+project.ProjectTotalAssetScore__c );

    //        if(project.ProjectTotalAssetScore__c != null){ TotalProjectScore = (project.ProjectTotalAssetScore__c/100)*TotalBusinessvaluedriverScore; }

    //        project.Total_Project_Score__c = TotalProjectScore ;
 
    //        if(!lstCalculatorBoxRange.isEmpty()){
    //            for(Oblix_Calculator__c calculatorRange : lstCalculatorBoxRange){
                    
    //                if(TotalProjectScore >= calculatorRange.Points_Low__c && TotalProjectScore <= calculatorRange.Points_HigH__c 
    //                    && calculatorRange.Financial_Year__c == mapProjectToFinancialYear.get(project.Id)){

    //                    //Create Field Project Box Number
    //                    Calculator_BoxRange =  calculatorRange.Box_Range__c;
    //                    project.Oblix_ProjectBoxNumber__c = calculatorRange.Box_Range__c;
                        
    //                }
    //            }
    //        }

    //        Calculator_BoxRange = Calculator_BoxRange.replace(' ', '_');
    //        Calculator_BoxRange += '__c';

    //        //System.debug('###Calculator_BoxRange : '+Calculator_BoxRange);
    //        // A project has multi project splits, for every split we need to have a Calculator By Country
    //        //For every project look over Splits and for every split get with a Map the Correct Calculator Country.
            
    //        if(mapProjectToSplits.get(project.Id) != null){
    //           //system.debug('###lstCalculatorCountryRange :'+lstCalculatorCountryRange);
               
    //           tmp_projectFee = TotalCalculatedFee(mapProjectToFinancialYear.get(project.Id),Calculator_BoxRange,mapProjectToSplits.get(project.Id),lstCalculatorCountryRange);
    //           //System.debug('###tmp_projectFee : '+tmp_projectFee);
    //        }

    //        project.Total_Fees_for_Project__c = tmp_projectFee; 
    //    }
    //}

    //private static Decimal TotalCalculatedFee(String  myprojectFinancial, String Calculator_BoxRange, List<Oblix_Marketing_SOW_Project_Splits__c> lstProjectSplitsTmp, List<Oblix_Calculator__c> lstCalculatorCountrRange){
    //         Decimal tmp_fee = 0;
    //         system.debug('###lstProjectSplitsTmp : '+lstProjectSplitsTmp);
    //         system.debug('###lstCalculatorCountrRange : '+lstCalculatorCountrRange);
    //         for(Oblix_Marketing_SOW_Project_Splits__c projSplit : lstProjectSplitsTmp){
    //                for(Oblix_Calculator__c calculatorCountry : lstCalculatorCountrRange){
    //                    if( projsplit.OblixCountry__r.Name != null && projsplit.OblixCountry__r.Name.toUpperCase().contains(calculatorCountry.Name) && Calculator_BoxRange.contains('Box_') && myprojectFinancial == calculatorCountry.Financial_Year__c){
    //                        tmp_fee += (Decimal) (calculatorCountry.get(Calculator_BoxRange)!= null ? calculatorCountry.get(Calculator_BoxRange) : 0)* (projSplit.Percentage__c != null ? projSplit.Percentage__c/100 : 0);
    //                        System.debug('###tmp_fee : '+tmp_fee);
    //                    } 
    //                }
    //            }
    //       return tmp_fee;
    //}
    
}