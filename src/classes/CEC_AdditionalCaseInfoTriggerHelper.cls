/**********************************************************************
 Name:  CEC_AlertTrackerEmailSenderHelper
 Copyright © 2014  Unilever
 ======================================================================
=======================================================================
Purpose: This is the Helper class for CEC_Alert_Tracker__c trigger 
         This class is used to send email alerts.                                                                                                                     
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE            DETAIL               Description
   1.0 - Shruti            25/09/2014      INITIAL DEVELOPMENT  CSR
 
***********************************************************************/

/**
Helper class for Trigger for CEC_AlertTrackerTrigger
*/

public class CEC_AdditionalCaseInfoTriggerHelper {

    /**
    This method is used to generate report for the newly inserted 'AdditionalCaseInfo' object
    @param : addtionalCaseInfoList- List of cec_Additional_Case_Information__c objects which are inserted
    @return : void
    */
    public void generateReport(List<cec_Additional_Case_Information__c> addtionalCaseInfoList, MAP<Id,cec_Additional_Case_Information__c> addtionalCaseInfoMap){
        try{
            Map <Id, cec_Additional_Case_Information__c> caseInfoMap = new Map <Id, cec_Additional_Case_Information__c>();
            List<cec_Additional_Case_Information__c> caseInfoList = [select id, Issue__r.L2_Product_Category__c, Issue__r.CEC_Product__r.Brand__c, Issue__r.CEC_Product__r.Variant_Flavour__c, Issue__r.CEC_Product__r.GTIN_EAN_UPC_Code__c,  Issue__r.CEC_Product__r.Pack_Size_Net_Content__c from cec_Additional_Case_Information__c where id in : addtionalCaseInfoMap.keySet()];
            System.debug('caseInfoList = ' + caseInfoList );
            for (cec_Additional_Case_Information__c caseInfoObj :caseInfoList ){
                caseInfoMap.put(caseInfoObj.Id, caseInfoObj );
            } 
            
            
            AdditionalCaseInfoWrapper wrapperObj; 
            Map<Id, List<AdditionalCaseInfoWrapper>> wrapperMap = new Map<Id, List<AdditionalCaseInfoWrapper>>();
            
            if (addtionalCaseInfoList != null && addtionalCaseInfoList.size() > 0){
                for (cec_Additional_Case_Information__c addInfoObj : addtionalCaseInfoList){
                    Id caseId = addInfoObj.Case__c;
                    wrapperObj = new AdditionalCaseInfoWrapper(addInfoObj);
                    List<AdditionalCaseInfoWrapper> wrapperList;
                    if (wrapperMap.containsKey(caseId)){
                        wrapperList = wrapperMap.get(caseId);
                        wrapperList.add(wrapperObj );
                    }
                    else{
                        wrapperList = new List<AdditionalCaseInfoWrapper>();
                        wrapperList.add(wrapperObj );
                    }
                    wrapperMap.put(caseId , wrapperList );
                }
            }
            
            System.debug('wrapperMap!!!!!!!!!!!!!!--------------' + wrapperMap);
            

            //List<Case> caseList = [select Id, casenumber, createdDate, country__c, Origin, account.Age__c, account.Gender__c from case where id in : wrapperMap.keySet()];
            List<Case> caseList = [select Id, casenumber, createdDate, Origin, account.Age__c, account.Gender__c from case where id in : wrapperMap.keySet()];
            if (caseList != null && caseList .size() > 0){
                for(Case caseObj : caseList ){
                    if (wrapperMap.containsKey(caseObj.Id)){
                        List<AdditionalCaseInfoWrapper> wrapperList = wrapperMap.get(caseObj.Id);
                        for (AdditionalCaseInfoWrapper w : wrapperList ){
                            w.caseNumber = caseObj.casenumber;
                            w.createdDate = caseObj.createdDate ;
                            //w.country = caseObj.country__c;
                            w.caseMethod = caseObj.Origin;
                            w.age = caseObj.account.Age__c;
                            w.gender = caseObj.account.Gender__c;
                        }
                    }
                }
            }
            
            System.debug('wrapperMap#############--------------' + wrapperMap);
            
            if (wrapperMap != null && wrapperMap.size() > 0){
                for(Id caseId : wrapperMap.keySet()){
                    List<AdditionalCaseInfoWrapper> wList = wrapperMap.get(caseId );
                    if (wList != null && wList.size() > 0){
                        for(AdditionalCaseInfoWrapper wObj : wList ){
                            //Id id1 = wObj.Id;
                            if (caseInfoMap.containsKey(wObj.wrapperId)){
                                wObj.category = caseInfoMap.get(wObj.wrapperId).Issue__r.L2_Product_Category__c;
                                wObj.packType= caseInfoMap.get(wObj.wrapperId).Issue__r.CEC_Product__r.Pack_Size_Net_Content__c;
                                wObj.brand= caseInfoMap.get(wObj.wrapperId).Issue__r.CEC_Product__r.Brand__c;
                                wObj.productVariant= caseInfoMap.get(wObj.wrapperId).Issue__r.CEC_Product__r.Variant_Flavour__c;
                                wObj.EAN= caseInfoMap.get(wObj.wrapperId).Issue__r.CEC_Product__r.GTIN_EAN_UPC_Code__c;
                            }
                        }
                    }
                }
          }
            
          String reportContents = generateExcelReport(wrapperMap);
            
          Document objD = new Document();

          objD.name = 'testFile.csv';
          objD.body = blob.valueof(reportContents );
          objD.folderId = UserInfo.getUserId();

          //objD.folderId = UserInfo.getUserId();
          insert objD;
          System.debug('objD--@@@@@@@@@---------' + objD);
     
        
        }catch(Exception ex){
            System.debug('Exception' + ex);
        }
    }
    
    
    
    
    
    public String generateExcelReport(Map<Id, List<AdditionalCaseInfoWrapper>> wrapperMap){
           String contents = '';
           String tabChar = ',';
           String newLineChar = '\r\n';
           List<AdditionalCaseInfoWrapper> wrapperList;
                      
           if (wrapperMap != null && wrapperMap.size() > 0){
               contents += 'Case Code';
               contents += tabChar;
               contents += 'Case Creation Date';
               contents += tabChar;
               //contents += 'Country';
               contents += tabChar;
               contents += 'Comment';
               contents += tabChar;
               contents += 'Categoryyyyyyyy';
               contents += tabChar;
               contents += 'Pack Type';
               contents += tabChar;
               contents += 'Brand';
               contents += tabChar;
               contents += 'Product Variant';
               contents += tabChar;
               contents += 'EAN';
               contents += tabChar;
               contents += 'Questions';
               contents += tabChar;
               contents += 'Answer';
               contents += tabChar;
               contents += 'Case Method';
               contents += newLineChar;
               
               for (Id caseId : wrapperMap.keySet()){
                   wrapperList = wrapperMap.get(caseId );
                   if (wrapperList != null && wrapperList.size() > 0){
                       for (AdditionalCaseInfoWrapper wrapperObj : wrapperList ){
                           Integer count = 1;
                           while  ( count <= 10){
                               contents += wrapperObj.caseNumber;
                               contents += tabChar;
                               contents += wrapperObj.createdDate;
                               contents += tabChar;
                               //contents += wrapperObj.country;
                               contents += tabChar;
                               contents += wrapperObj.comments;
                               contents += tabChar;
                               contents += wrapperObj.category;
                               contents += tabChar;
                               contents += wrapperObj.packType;
                               contents += tabChar;
                               contents += wrapperObj.brand;
                               contents += tabChar;
                               contents += wrapperObj.productVariant;
                               contents += tabChar;
                               contents += wrapperObj.ean;
                               contents += tabChar;
                               if (count == 1){
                                   contents += wrapperObj.q1;
                                   contents += tabChar;
                                   contents += wrapperObj.a1;
                                   contents += tabChar;
                               }else if (count == 2 ){ 
                                       contents += wrapperObj.q2;
                                       contents += tabChar;
                                       contents += wrapperObj.a2;
                                       contents += tabChar;
                               }else if (count == 3 ){ 
                                       contents += wrapperObj.q3;
                                       contents += tabChar;
                                       contents += wrapperObj.a3;
                                       contents += tabChar;
                                }else if (count == 4 ){ 
                                       contents += wrapperObj.q4;
                                       contents += tabChar;
                                       contents += wrapperObj.a4;
                                       contents += tabChar;
                                }else if (count == 5 ){ 
                                       contents += wrapperObj.q5;
                                       contents += tabChar;
                                       contents += wrapperObj.a5;
                                       contents += tabChar;
                                }else if (count == 6 ){  
                                       contents += wrapperObj.q6;
                                       contents += tabChar;
                                       contents += wrapperObj.a6;
                                       contents += tabChar;
                                }else if (count == 7 ){ 
                                       contents += wrapperObj.q7;
                                       contents += tabChar;
                                       contents += wrapperObj.a7;
                                       contents += tabChar;
                                }else if (count == 8 ){ 
                                       contents += wrapperObj.q8;
                                       contents += tabChar;
                                       contents += wrapperObj.a8;
                                       contents += tabChar;
                                }else if (count == 9 ){ 
                                       contents += wrapperObj.q9;
                                       contents += tabChar;
                                       contents += wrapperObj.a9;
                                       contents += tabChar;
                                } else if (count == 10 ){ 
                                       contents += wrapperObj.q10;
                                       contents += tabChar;
                                       contents += wrapperObj.a10;
                                       contents += tabChar;
                                } else if (count == 11 ){ 
                                       contents += wrapperObj.q11;
                                       contents += tabChar;
                                       contents += wrapperObj.a11;
                                       contents += tabChar;
                               }else if (count == 12 ){ 
                                       contents += wrapperObj.q12;
                                       contents += tabChar;
                                       contents += wrapperObj.a12;
                                       contents += tabChar;
                                }else if (count == 13 ){ 
                                       contents += wrapperObj.q13;
                                       contents += tabChar;
                                       contents += wrapperObj.a13;
                                       contents += tabChar;
                                }else if (count == 14 ){ 
                                       contents += wrapperObj.q14;
                                       contents += tabChar;
                                       contents += wrapperObj.a14;
                                       contents += tabChar;
                                }else if (count == 15 ){  
                                       contents += wrapperObj.q15;
                                       contents += tabChar;
                                       contents += wrapperObj.a15;
                                       contents += tabChar;
                                }else if (count == 16 ){ 
                                       contents += wrapperObj.q16;
                                       contents += tabChar;
                                       contents += wrapperObj.a16;
                                       contents += tabChar;
                                }else if (count == 17 ){ 
                                       contents += wrapperObj.q17;
                                       contents += tabChar;
                                       contents += wrapperObj.a17;
                                       contents += tabChar;
                                }else if (count == 18 ){ 
                                       contents += wrapperObj.q18;
                                       contents += tabChar;
                                       contents += wrapperObj.a18;
                                       contents += tabChar;
                                } else if (count == 19 ){ 
                                       contents += wrapperObj.q10;
                                       contents += tabChar;
                                       contents += wrapperObj.a10;
                                       contents += tabChar;
                                } else if (count == 20 ){ 
                                       contents += wrapperObj.q2;
                                       contents += tabChar;
                                       contents += wrapperObj.a2;
                                       contents += tabChar;
                               }else if (count == 21 ){ 
                                       contents += wrapperObj.q3;
                                       contents += tabChar;
                                       contents += wrapperObj.a3;
                                       contents += tabChar;
                                }else if (count == 22 ){ 
                                       contents += wrapperObj.q4;
                                       contents += tabChar;
                                       contents += wrapperObj.a4;
                                       contents += tabChar;
                                }else if (count == 23 ){ 
                                       contents += wrapperObj.q5;
                                       contents += tabChar;
                                       contents += wrapperObj.a5;
                                       contents += tabChar;
                                }else if (count == 24 ){  
                                       contents += wrapperObj.q6;
                                       contents += tabChar;
                                       contents += wrapperObj.a6;
                                       contents += tabChar;
                                }else if (count == 25 ){ 
                                       contents += wrapperObj.q7;
                                       contents += tabChar;
                                       contents += wrapperObj.a7;
                                       contents += tabChar;
                                }else if (count == 26 ){ 
                                       contents += wrapperObj.q8;
                                       contents += tabChar;
                                       contents += wrapperObj.a8;
                                       contents += tabChar;
                                } else if (count == 27 ){ 
                                       contents += wrapperObj.q9;
                                       contents += tabChar;
                                       contents += wrapperObj.a9;
                                       contents += tabChar;
                                } else if (count == 28 ){ 
                                       contents += wrapperObj.q10;
                                       contents += tabChar;
                                       contents += wrapperObj.a10;
                                       contents += tabChar;
                                } else if (count == 29 ){ 
                                       contents += wrapperObj.q10;
                                       contents += tabChar;
                                       contents += wrapperObj.a10;
                                       contents += tabChar;
                                }  else if (count == 30 ){ 
                                       contents += wrapperObj.q10;
                                       contents += tabChar;
                                       contents += wrapperObj.a10;
                                       contents += tabChar;
                                } else if (count == 31 ){ 
                                       contents += wrapperObj.q9;
                                       contents += tabChar;
                                       contents += wrapperObj.a9;
                                       contents += tabChar;
                                } else if (count == 32 ){ 
                                       contents += wrapperObj.q10;
                                       contents += tabChar;
                                       contents += wrapperObj.a10;
                                       contents += tabChar;
                                } else if (count == 33 ){ 
                                       contents += wrapperObj.q10;
                                       contents += tabChar;
                                       contents += wrapperObj.a10;
                                       contents += tabChar;
                                }  else if (count == 34 ){ 
                                       contents += wrapperObj.q10;
                                       contents += tabChar;
                                       contents += wrapperObj.a10;
                                       contents += tabChar;
                                }    else if (count == 35 ){ 
                                       contents += wrapperObj.q10;
                                       contents += tabChar;
                                       contents += wrapperObj.a10;
                                       contents += tabChar;
                                } else if (count == 36 ){ 
                                       contents += wrapperObj.q9;
                                       contents += tabChar;
                                       contents += wrapperObj.a9;
                                       contents += tabChar;
                                } else if (count == 37 ){ 
                                       contents += wrapperObj.q10;
                                       contents += tabChar;
                                       contents += wrapperObj.a10;
                                       contents += tabChar;
                                } else if (count == 38 ){ 
                                       contents += wrapperObj.q10;
                                       contents += tabChar;
                                       contents += wrapperObj.a10;
                                       contents += tabChar;
                                }  else if (count == 39 ){ 
                                       contents += wrapperObj.q10;
                                       contents += tabChar;
                                       contents += wrapperObj.a10;
                                       contents += tabChar;
                                }   else if (count == 40 ){ 
                                       contents += wrapperObj.q10;
                                       contents += tabChar;
                                       contents += wrapperObj.a10;
                                       contents += tabChar;
                                } else if (count == 41 ){ 
                                       contents += wrapperObj.q9;
                                       contents += tabChar;
                                       contents += wrapperObj.a9;
                                       contents += tabChar;
                                } else if (count == 42 ){ 
                                       contents += wrapperObj.q10;
                                       contents += tabChar;
                                       contents += wrapperObj.a10;
                                       contents += tabChar;
                                } else if (count == 43 ){ 
                                       contents += wrapperObj.q10;
                                       contents += tabChar;
                                       contents += wrapperObj.a10;
                                       contents += tabChar;
                                }  else if (count == 44 ){ 
                                       contents += wrapperObj.q10;
                                       contents += tabChar;
                                       contents += wrapperObj.a10;
                                       contents += tabChar;
                                } else if (count == 45 ){ 
                                       contents += wrapperObj.q10;
                                       contents += tabChar;
                                       contents += wrapperObj.a10;
                                       contents += tabChar;
                                } else if (count == 46 ){ 
                                       contents += wrapperObj.q9;
                                       contents += tabChar;
                                       contents += wrapperObj.a9;
                                       contents += tabChar;
                                } else if (count == 47 ){ 
                                       contents += wrapperObj.q10;
                                       contents += tabChar;
                                       contents += wrapperObj.a10;
                                       contents += tabChar;
                                } else if (count == 48 ){ 
                                       contents += wrapperObj.q10;
                                       contents += tabChar;
                                       contents += wrapperObj.a10;
                                       contents += tabChar;
                                }  else if (count == 49 ){ 
                                       contents += wrapperObj.q10;
                                       contents += tabChar;
                                       contents += wrapperObj.a10;
                                       contents += tabChar;
                                }  else if (count == 50 ){ 
                                       contents += wrapperObj.q10;
                                       contents += tabChar;
                                       contents += wrapperObj.a10;
                                       contents += tabChar;
                                }            
                               contents += wrapperObj.caseMethod;
                               contents += newLineChar; 
                               count ++;
                           }
                       }
                   }
           }
           
           
    }
    return contents;
    
    
   } 
    public class AdditionalCaseInfoWrapper{
        Id wrapperid;
        String caseNumber;
        DateTime createdDate;
        String country;
        String gender;
        String age;
        String category;
        String packType;
        String brand;
        String productVariant;
        String EAN;
        String batchcode;
        String comments;
        String question;  
        String answer;  
        String untranslatedAnswers;
        String caseMethod;     
        String q1, q2, q3, q4, q6, q7, q8, q10, q11, q12, q13, q14, q15, q16, q17, q18, q19, q20, q21, q22, q23, q24, q25, q26, q27, q28, q29, q30, q31, q32, q33, q34, q35, q36, q37, q38, q39, q40, q41, q42, q43, q44, q45, q46, q47, q48, q49, q50; 
        String a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17, a18, a19, a20, a21, a22, a23, a24, a25, a26, a27, a28, a29, a30, a31, a32, a33, a34, a35, a36, a37, a38, a39, a40, a41, a42, a43, a44, a45, a46, a47, a48, a49, a50; 
        //String ua1, ua2, ua3, ua4, ua5, ua6, ua7, ua8, ua9; 
        Date q5, q9;
                
        public AdditionalCaseInfoWrapper(){}
        
        
        public AdditionalCaseInfoWrapper(cec_Additional_Case_Information__c caseInfoObj){
            this.wrapperid = caseInfoObj.Id;
            this.q1 = caseInfoObj.q1__c;
            this.q2 = caseInfoObj.q2__c;
            this.q3 = caseInfoObj.q3__c;
            this.q4 = caseInfoObj.q4__c;
            this.q5 = caseInfoObj.q5__c;
            this.q6 = caseInfoObj.q6__c;
            this.q7 = caseInfoObj.q7__c;
            this.q8 = caseInfoObj.q8__c;
            this.q9 = caseInfoObj.q9__c;
            
           /* this.a1 = caseInfoObj.q1__c;
            this.a2 = caseInfoObj.q2__c;
            this.a3 = caseInfoObj.q3__c;
            this.a4 = caseInfoObj.q4__c;
            this.a5 = caseInfoObj.q5__c;
            this.a6 = caseInfoObj.q6__c;
            this.a7 = caseInfoObj.q7__c;
            this.a8 = caseInfoObj.q8__c;
            this.a9 = caseInfoObj.q9__c; */
        }
        
       
        
    }

    

}