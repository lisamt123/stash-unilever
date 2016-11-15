/* Class is used for  update Agency esimatate Exhcage Rates */

Public Class AF_UpdateAgencyEstimatesValues
{
    //Static Mehtod 
    public static void UpdateExchageRates(list<AF_Agency_Estimate__c> ae)
    {
         set<id>   AgencyEntity= new set<id>();
         set<id>   unileverEntity=new set<id>();
         Map<id ,String> AgencyEntityNames=new Map<id,String>();
         Map<id ,String> unileverEntityNames=new Map<id,String>();
         List<AF_Agency_Estimate__c> agencyRecords=ae;
         List<string> matrixCountries=new list<string>();
         Map<id,list<string>>  mapMatrixtable=new Map<id,list<string>>();
         Map<id,string> mapMatrixcountry=new Map<id,string>();
         Map<id,string> mapReadyForPOCountry=new Map<id,string>();
         Map<string,Double>  CurrencyMap=new  Map<string,Double>();
         Map<string,Double>  CurrencyMapforUSD=new  Map<string,Double>();
         Map<string,Double>  CurrencyMapforGBP=new  Map<string,Double>();
         set<string>  currncycodes=new set<string>();
         list<string> matrixString;
         Map<id,String>  matrixDataEntryCurrency=new Map<id,String>();
         Map<id,String>  matrixReadyforconversion=new Map<id,String>();
         Map<id,String>  ReadyForPOEntryCurrency=new Map<id,String>();
         Integer MatrixRecoundCount=0;
         Double USDValue=0.0;
         Double EURValue=0.0;

         
         if(agencyRecords.size()>0)
         for(AF_Agency_Estimate__c agencyEst:agencyRecords)
         {   
             if(agencyEst.AF_Agency_Entity__c!=null)
             AgencyEntity.add(agencyEst.AF_Agency_Entity__c);//collecting AgencyEnties  

             if(agencyEst.AF_Unilever_Entity__c!=null)       
             unileverEntity.add(agencyEst.AF_Unilever_Entity__c);// Collecting Unilever  Entities

             
         }
         
         // query for retrieve  Entities countries(Agency)
         If(AgencyEntity.size()>0)
            for(AF_Entity__c  entity:[Select id,Name,AF_Country__c from AF_Entity__c  where id IN:AgencyEntity limit 50000 ])

            {
               AgencyEntityNames.put(entity.id,entity.AF_Country__c );// Add id,and its Agency Country from Entity 
            }
            
         // query for retrieve  Entities countries(unilever)   
         If(unileverEntity.size()>0)
            for(AF_Entity__c  entity:[Select id,Name,AF_Country__c from AF_Entity__c  where id IN:unileverEntity limit 50000 ])
            {
               unileverEntityNames.put(entity.id,entity.AF_Country__c );// Add id,and its unilever Country from Entity 
            }
            
            
         //Query for matrix Table reocrds    
         list<AF_Matrix_Table__c> matrixRecords=[select id, AF_Agency_Country__c,AF_Matrix_Country__c,AF_Matrix_country_Currency__c,AF_Matrix_Currency_Code__c,AF_Ready_For_PO_Country__c,AF_Ready_For_PO_Country_Currency__c,AF_Ready_For_PO_Currency_Code__c,Ready_For_PO_Conversion__c,AF_Unilver_Country__c from AF_Matrix_Table__c limit 50000];   
        

         if(matrixRecords.size()>0)
         for(AF_Matrix_Table__c mtable:matrixRecords)
         {
             String matrixcurrency;
             string readyforPo;
             if(mtable.AF_Unilver_Country__c!=null && mtable.AF_Agency_Country__c!=null )
             {
                 
                 if(mtable.AF_Matrix_Country__c!=null && mtable.AF_Matrix_Currency_Code__c!=null )
                 {
                     matrixcurrency=mtable.AF_Matrix_Country__c+'-'+mtable.AF_Matrix_Currency_Code__c;                  
                     currncycodes.add(matrixcurrency);
                     mapMatrixcountry.put(mtable.id,matrixcurrency);
                     matrixDataEntryCurrency.put(mtable.id,mtable.AF_Matrix_Currency_Code__c);
                 }
                 
                 if(mtable.AF_Ready_For_PO_Country__c!=null && mtable.AF_Ready_For_PO_Currency_Code__c!=null )
                 {
                     readyforPo=mtable.AF_Ready_For_PO_Country__c+'-'+mtable.AF_Ready_For_PO_Currency_Code__c;                     
                     mapReadyForPOCountry.put(mtable.id,readyforPo);
                     currncycodes.add(readyforPo);
                     ReadyForPOEntryCurrency.put(mtable.id,mtable.AF_Ready_For_PO_Currency_Code__c);
                     //matrixReadyforconversion.put(mtable.id,mtable.Ready_For_PO_Conversion__c);
                 }
                 
                 if(mtable.Ready_For_PO_Conversion__c!='--None--')
                 MatrixReadyforConversion.put(mtable.id,mtable.Ready_For_PO_Conversion__c);
                               
                     matrixCountries=new list<string>();
                     matrixCountries.add(mtable.AF_Unilver_Country__c);
                     matrixCountries.add(mtable.AF_Agency_Country__c);
                     mapMatrixtable.put(mtable.id,matrixCountries);
                 
             }     
                 
         }
         // Query for USD Currency
         AF_Currency__c USDCurrencyTable=[select id,Country_Currency__c,AF_Currency_Code__c ,AF_Average_Exchange_Rate_To_EUR__c,Ready_For_PO_Exchange_Rate_SGD_To_USD__c,Ready_For_PO_Exchange_Rate_To_EUR__c from AF_Currency__c where Locked__c=:false and AF_Currency_Code__c=:'USD'  and AF_Fiscal_Year_new__c=:string.valueof(System.now().year())  Order by Createddate limit 1];
         if(USDCurrencyTable!=null)
         if(USDCurrencyTable.AF_Average_Exchange_Rate_To_EUR__c!=null)
         {
                     EURValue=USDCurrencyTable.AF_Average_Exchange_Rate_To_EUR__c;
                     system.debug('^^^^EuR'+EURValue);
         }    
             
          
         // Query for Retrieve Currency Records
         List<AF_Currency__c> currencyrecords=[select id,Country_Currency__c,AF_Currency_Code__c ,AF_Average_Exchange_Rate_To_EUR__c,Ready_For_PO_Exchange_Rate_SGD_To_USD__c,Ready_For_PO_Exchange_Rate_To_EUR__c from AF_Currency__c where Locked__c=:false and Country_Currency__c IN:currncycodes  and AF_Fiscal_Year_new__c=:string.valueof(System.now().year()) limit 50000];
         if(currencyrecords.size()>0)
         for(AF_Currency__c  curren:currencyrecords)
         {
             if(curren.Country_Currency__c!=null)
             {
                 CurrencyMap.put(curren.Country_Currency__c,curren.AF_Average_Exchange_Rate_To_EUR__c );
                 CurrencyMapforUSD.put(curren.Country_Currency__c,curren.Ready_For_PO_Exchange_Rate_SGD_To_USD__c );
                 CurrencyMapforGBP.put(curren.Country_Currency__c,curren.Ready_For_PO_Exchange_Rate_To_EUR__c );
             }
             If(curren.AF_Currency_Code__c=='EUR')
             if(curren.Ready_For_PO_Exchange_Rate_To_EUR__c!=null)
             USDValue=curren.Ready_For_PO_Exchange_Rate_To_EUR__c;
             
             /*If(curren.AF_Currency_Code__c=='USD')
             {
                 system.debug('^^^^Test'+EURValue);
                 if(curren.AF_Average_Exchange_Rate_To_EUR__c!=null)
                 {
                     EURValue=curren.AF_Average_Exchange_Rate_To_EUR__c;
                     system.debug('^^^^EuR'+EURValue);
                 }    
             }*/
             
             
             
         }
        
        
         if(agencyRecords.size()>0)
         for(AF_Agency_Estimate__c agencyEst:agencyRecords)
         {     
               String agncyentity;
               string unlieverentity;
               MatrixRecoundCount=0;      
               if(agencyEst.AF_Agency_Entity__c!=null)
               agncyentity= AgencyEntityNames.get(agencyEst.AF_Agency_Entity__c);
               if(agencyEst.AF_Unilever_Entity__c!=null)
               unlieverentity=unileverEntityNames.get(agencyEst.AF_Unilever_Entity__c);

               if(matrixRecords.size()>0)
               for(AF_Matrix_Table__c mt:matrixRecords)
               { 
                   Boolean Testexit=false; 
                   matrixString=mapMatrixtable.get(mt.id);
                   
                   //if(matrixString!=null)
                   if(matrixString.size()==2)
                   {
                       if(matrixString[0]==unlieverentity && matrixString[1]==agncyentity)
                       {   
                           String Matccode=mapMatrixcountry.get(mt.id);
                           string readypcode=mapReadyForPOCountry.get(mt.id);

                               if(agencyEst.AF_Status__c=='Ready for PO')
                               {     
                               
                                   if(MatrixReadyforConversion.get(mt.id)!='--None--' && MatrixReadyforConversion.get(mt.id)=='GBP')
                                   agencyEst.AF_Agency_Spot_Rate__c= CurrencyMapforUSD.get(readypcode);
                                   else if(MatrixReadyforConversion.get(mt.id)!='--None--' && MatrixReadyforConversion.get(mt.id)=='USD')
                                   agencyEst.AF_Agency_Spot_Rate__c= CurrencyMapforGBP.get(readypcode);
                                   
                                   if(agencyEst.Unilever_Code__c!=matrixDataEntryCurrency.get(mt.id))
                                   {
                                       agencyEst.AF_Agency_Exchange_Rate__c= CurrencyMap.get(Matccode);
                                   }
                                   
                                   if(agencyEst.AF_Agency_Spot_Rate__c != null && agencyEst.AF_Agency_Spot_Rate__c!= 0 && agencyEst.AF_Traditional__c  != null  && agencyEst.AF_Agency_Exchange_Rate__c!=null)
                                   agencyEst.AF_Traditional_Local__c = (agencyEst.AF_Traditional__c*agencyEst.AF_Agency_Exchange_Rate__c)/agencyEst.AF_Agency_Spot_Rate__c;
                                    
                                   if(agencyEst.AF_Agency_Spot_Rate__c  != null && agencyEst.AF_Agency_Spot_Rate__c != 0 && agencyEst.AF_Digital__c != null && agencyEst.AF_Agency_Exchange_Rate__c!=null) 
                                   agencyEst.AF_Digital_Local__c =(agencyEst.AF_Digital__c*agencyEst.AF_Agency_Exchange_Rate__c)/agencyEst.AF_Agency_Spot_Rate__c ;
                                    
                                   if(agencyEst.AF_Agency_Spot_Rate__c  != null && agencyEst.AF_Agency_Spot_Rate__c!= 0 && agencyEst.AF_Adaptation__c != null && agencyEst.AF_Agency_Exchange_Rate__c!=null) 
                                   agencyEst.AF_Adaptation_Local__c = (agencyEst.AF_Adaptation__c*agencyEst.AF_Agency_Exchange_Rate__c)/agencyEst.AF_Agency_Spot_Rate__c ;
                                   
                                   if(agencyEst.AF_Agency_Spot_Rate__c !=null && agencyEst.AF_Agency_Spot_Rate__c !=0 && USDValue!=0.0)
                                   agencyEst.Indicative_Gain_in_USD__c = ((agencyEst.AF_Traditional__c+agencyEst.AF_Digital__c+agencyEst.AF_Adaptation__c)/USDValue)-(agencyEst.AF_Traditional_Local__c+agencyEst.AF_Digital_Local__c +agencyEst.AF_Adaptation_Local__c) ;
                                   
                                   system.debug('small test************'+agencyEst.Indicative_Gain_in_USD__c);
                                   if( agencyEst.Indicative_Gain_in_USD__c!=null && EURValue!=null && EURValue!=0.0)
                                   {
                                       system.debug('Test****************');
                                       agencyEst.Indicative_Gain_Loss_in_EUR__c=agencyEst.Indicative_Gain_in_USD__c/EURValue;
                                       system.debug('***********8'+agencyEst.Indicative_Gain_Loss_in_EUR__c);
                                   }
                                  
                                   
                               }
                                
                               else 
                               {
                                   agencyEst.AF_Agency_Spot_Rate__c=null; 
                                    
                                   /*if(agencyEst.Unilever_Code__c!=matrixDataEntryCurrency.get(mt.id))
                                   {
                                       agencyEst.AF_Agency_Exchange_Rate__c= CurrencyMap.get(Matccode);
                                   }*/
                                   
                                   agencyEst.AF_Agency_Exchange_Rate__c= CurrencyMap.get(Matccode);
                                   if(agencyEst.AF_Agency_Exchange_Rate__c != null && agencyEst.AF_Agency_Exchange_Rate__c!= 0 && agencyEst.AF_Traditional__c  != null)
                                   agencyEst.AF_Traditional_Local__c = agencyEst.AF_Traditional__c*agencyEst.AF_Agency_Exchange_Rate__c;
                                        
                                   if(agencyEst.AF_Agency_Exchange_Rate__c  != null && agencyEst.AF_Agency_Exchange_Rate__c != 0 && agencyEst.AF_Digital__c != null) 
                                   agencyEst.AF_Digital_Local__c =agencyEst.AF_Digital__c*agencyEst.AF_Agency_Exchange_Rate__c ;
                                        
                                   if(agencyEst.AF_Agency_Exchange_Rate__c  != null && agencyEst.AF_Agency_Exchange_Rate__c!= 0 && agencyEst.AF_Adaptation__c != null) 
                                   agencyEst.AF_Adaptation_Local__c = agencyEst.AF_Adaptation__c*agencyEst.AF_Agency_Exchange_Rate__c ;
  
                               }  
                                
                           agencyEst.AF_Matrix_Data_Entry_Currency__c=matrixDataEntryCurrency.get(mt.id);
                           agencyEst.AF_Ready_For_PO_Entry_Currency__c=MatrixReadyforConversion.get(mt.id);
                           
                           Testexit=true;
                           matrixString.clear();
                           
                       } 
                       else
                       {
                           MatrixRecoundCount=MatrixRecoundCount+1;
                        
                       }
                    }
                   
                   if(Testexit==true)
                   break;
               }
               /*if(MatrixRecoundCount==matrixRecords.size())
               {
                   String ErrorMessage=System.label.AF_AgencyEstimate_Entity_Message;
                   System.debug('***********ErrorMessage=='+ErrorMessage);
                   agencyEst.addError(ErrorMessage);
                   System.debug('***********MatrixRecoundCount=='+MatrixRecoundCount);
               }*/
               
               
         }

    }

}