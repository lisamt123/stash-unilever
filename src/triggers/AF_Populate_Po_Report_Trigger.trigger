trigger AF_Populate_Po_Report_Trigger on AF_PO_Report__c (after insert,after update) {
                 if(checkRecursivePOReport.run){
                set<String> compundKeySet = new set<String>();
                Map<String,String> compundKeyReportType = new Map<String,String>();
                for(AF_PO_Report__c  poReport:Trigger.new){
                                compundKeyReportType.put(poReport.AF_Compound_Key__c,poReport.AF_PO_Report_Type__c);
                                compundKeySet.add(poReport.AF_Compound_Key__c);
                }
               checkRecursivePOReport.run=false;
                if(compundKeySet.size()>0){
                AF_GetBaseFeePOData.CalculatePoReportValues(compundKeyReportType,compundKeySet);
                }
                }
                
 
}