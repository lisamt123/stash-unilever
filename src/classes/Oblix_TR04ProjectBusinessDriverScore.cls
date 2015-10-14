public with sharing class Oblix_TR04ProjectBusinessDriverScore {
  	 
	public static void myMethod(List<Oblix_SOW_Projects__c> lstProjectTrigger){
		//List of Oblix Calculator
		List<Oblix_Calculator__c> lstCalculatorBoxRange = [Select Id, Name, Points_Low__c, Points_HigH__c, Box_Range__c, 
					 Box_9__c, Box_8__c, Box_7__c, Box_6__c, Box_5__c, Box_4__c, Box_3__c, Box_2__c, Box_20__c, Box_1__c, Box_19__c, Box_18__c, Box_17__c, Box_16__c, Box_15__c, Box_14__c, Box_13__c, Box_12__c, Box_11__c, Box_10__c 
					 from Oblix_Calculator__c where RecordTypeId =: Oblix_Utils.MapRecordType('Oblix_Calculator__c').get('Box_Range')];
		
		Map<Id, String> MapProjectToBoxRange = new Map<Id, String>();
		set<Id> setProjectIds = new set<Id>();
		
		for(Oblix_SOW_Projects__c project : lstProjectTrigger){
			setProjectIds.add(project.Id);
		}
		List<Oblix_Marketing_SOW_Project_Splits__c>	 lstProjectSplits = [Select Id, Name, Country__c, Project_Splits__c, Percentage__c from Oblix_Marketing_SOW_Project_Splits__c where Project_Splits__c in : setProjectIds];
		Map <Id, List<Oblix_Marketing_SOW_Project_Splits__c>> MapProjectToSplits = new Map <Id, List<Oblix_Marketing_SOW_Project_Splits__c>>();
		 set<String> setCountries = new set<String>();
		 
		if(lstProjectSplits.size()>0){
			for(Oblix_Marketing_SOW_Project_Splits__c projSplit : lstProjectSplits){
				setCountries.add(projSplit.Country__c);
				if(!MapProjectToSplits.containsKey(projSplit.Project_Splits__c)){
					MapProjectToSplits.put(projSplit.Project_Splits__c, new List<Oblix_Marketing_SOW_Project_Splits__c>());
				}
				MapProjectToSplits.get(projSplit.Project_Splits__c).add(projSplit);
			}
		}
		
		//List of Oblix Calculator with these Countries and RT  = Country_Box_Number // For very Calculator associate its related Split Project.
		List<Oblix_Calculator__c> lstCalculatorCountryRange = [Select Id, Name, Points_Low__c, Points_HigH__c, Box_Range__c,
				 Box_9__c, Box_8__c, Box_7__c, Box_6__c, Box_5__c, Box_4__c, Box_3__c, Box_2__c, Box_20__c, Box_1__c, Box_19__c, Box_18__c, Box_17__c, Box_16__c, Box_15__c, Box_14__c, Box_13__c, Box_12__c, Box_11__c, Box_10__c
		 from Oblix_Calculator__c where RecordTypeId =: Oblix_Utils.MapRecordType('Oblix_Calculator__c').get('Country_Box_Number') and Name in :setCountries];
		
		
		
		//Loop Over Project for the Initial requirement : calculating Score
		for(Oblix_SOW_Projects__c project : lstProjectTrigger){
			Decimal score_innonvation = 0;
			Decimal score_brandLedGrowth = 0;
			Decimal score_market = 0;
			Decimal score_hubPartner =0;
			Decimal score_campaignIdea =0;
			Decimal TotalBusinessvaluedriverScore = 0;
			Decimal TotalProjectScore = 0;
			Decimal tmp_projectFee = 0;
			
			String Calculator_BoxRange = '';
			//Business Value Creation == INNOVATION
			if(project.Innovation_Projects__c != null){
				if(project.Innovation_Projects__c == Oblix_Constants.Innovation_Projects_Innovation){
					if(project.Brand_Led_Growth__c == Oblix_Constants.BrandLedGrowth_IncremTurnoverLess10){
						score_innonvation = 0.150;
					}else if(project.Brand_Led_Growth__c == Oblix_Constants.BrandLedGrowth_IncremTurnover1020){
						score_innonvation = 0.250;
					}else if(project.Brand_Led_Growth__c == Oblix_Constants.BrandLedGrowth_IncremTurnoverLess2030){
						score_innonvation = 0.350;
					}else if(project.Brand_Led_Growth__c == Oblix_Constants.BrandLedGrowth_IncremTurnoverLess3040){
						score_innonvation = 0.450;
					}else if(project.Brand_Led_Growth__c == Oblix_Constants.BrandLedGrowth_IncremTurnoverLessAbove40){
						score_innonvation = 0.500;
					}else {
						score_innonvation = 0;
					}
				}
			}
			//Business Value Creation BrandLedGrowth
			if(project.Innovation_Projects__c != null){
				if(project.Innovation_Projects__c == Oblix_Constants.Innovation_Projects_BrandLedGrowth){
					if(project.Brand_Led_Growth__c == Oblix_Constants.BrandLedGrowth_Less100){
						score_brandLedGrowth = 0.150;
					}else if(project.Brand_Led_Growth__c == Oblix_Constants.BrandLedGrowth_100_200){
						score_brandLedGrowth = 0.250;
					}else if(project.Brand_Led_Growth__c == Oblix_Constants.BrandLedGrowth_IncremTurnover200_300){
						score_brandLedGrowth = 0.350;
					}else if(project.Brand_Led_Growth__c == Oblix_Constants.BrandLedGrowth_IncremTurnoverLess300_400){
						score_brandLedGrowth = 0.450;
					}else if(project.Brand_Led_Growth__c == Oblix_Constants.BrandLedGrowth_IncremTurnoverLessAbove400){
						score_brandLedGrowth = 0.500;
					}else{
						score_brandLedGrowth =0;
					}
				}
			}
			//Business Value 	Number of markets  
			if(project.Project_Scale_1__c != null){
				if(project.Project_Scale_1__c == Oblix_Constants.Innovation_Projects_Market1){
				score_market = 0.150;
				}else if(project.Project_Scale_1__c == Oblix_Constants.Innovation_Projects_Market2){
					score_market = 0.250;
				}else if(project.Project_Scale_1__c == Oblix_Constants.Innovation_Projects_Market3){
					score_market = 0.350;
				}else if(project.Project_Scale_1__c == Oblix_Constants.Innovation_Projects_Market4){
					score_market = 0.450;
				}else if(project.Project_Scale_1__c == Oblix_Constants.Innovation_Projects_Market5){
					score_market = 0.500;
				}else{
					score_market = 0;
				}	
			}
			
			//Business Value Number of hubs or partners
			if(project.Project_Scale_2__c != null){
				if(project.Project_Scale_2__c == Oblix_Constants.Innovation_Projects_HubsPartners1){
				score_hubPartner = 0.100;
				}else if(project.Project_Scale_2__c == Oblix_Constants.Innovation_Projects_HubsPartners2){
					score_hubPartner = 0.150;
				}else if(project.Project_Scale_2__c == Oblix_Constants.Innovation_Projects_HubsPartners3){
					score_hubPartner = 0.200;
				}else if(project.Project_Scale_2__c == Oblix_Constants.Innovation_Projects_HubsPartners4){
					score_hubPartner = 0.250;
				}else if(project.Project_Scale_2__c == Oblix_Constants.Innovation_Projects_HubsPartners5){
					score_hubPartner = 0.300;
				}else{
					score_hubPartner = 0;
				}	
			}
			
			//Business Value Campaign Idea
			if(project.Campaign_Idea__c != null){
				if(project.Campaign_Idea__c == Oblix_Constants.Innovation_Projects_Existing){
				score_campaignIdea = 0.600;
				}else if(project.Campaign_Idea__c == Oblix_Constants.Innovation_Projects_NewOne){
					score_campaignIdea = 1.000;
				}else if(project.Campaign_Idea__c == Oblix_Constants.Innovation_Projects_NewMulti){
					score_campaignIdea = 1.200;
				}else{
					score_campaignIdea = 0;
				}
			}
			
			//Calculate TotalBusinessvaluedriverScore
			TotalBusinessvaluedriverScore = score_innonvation+score_brandLedGrowth+score_market+score_hubPartner+score_campaignIdea+TotalBusinessvaluedriverScore;
			if(project.ProjectTotalAssetScore__c != null) TotalProjectScore = (project.ProjectTotalAssetScore__c/100)*TotalBusinessvaluedriverScore;
			
			if(lstCalculatorBoxRange.size()>0){
				for(Oblix_Calculator__c calculatorRange : lstCalculatorBoxRange){
					if(TotalProjectScore >= calculatorRange.Points_Low__c && TotalProjectScore <= calculatorRange.Points_HigH__c){
						//Create Field Project Box Number
						Calculator_BoxRange =  calculatorRange.Box_Range__c;
						project.Oblix_ProjectBoxNumber__c = calculatorRange.Box_Range__c;
					}
				}
			}
			Calculator_BoxRange = Calculator_BoxRange.replace(' ', '_');
		Calculator_BoxRange += '__c';
		System.debug('###Calculator_BoxRange : '+Calculator_BoxRange);
		// A project has multi project splits, for every split we need to have a Calculator By Country
		//For every project look over Splits and for every split get with a Map the Correct Calculator Country.
		if(MapProjectToSplits.get(project.Id) != null){
			for(Oblix_Marketing_SOW_Project_Splits__c projSplit : MapProjectToSplits.get(project.Id)){
				for(Oblix_Calculator__c calculatorCountry : lstCalculatorCountryRange){
					if(calculatorCountry.Name == projsplit.Country__c){
						tmp_projectFee += (Decimal) (calculatorCountry.get(Calculator_BoxRange)!= null ? calculatorCountry.get(Calculator_BoxRange) : 0)* (projSplit.Percentage__c != null ? projSplit.Percentage__c : 0);
					}
				}
			}
		}
		project.Total_Fees_for_Project__c = tmp_projectFee;
			
		}
		
	}
}