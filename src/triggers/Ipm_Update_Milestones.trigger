trigger Ipm_Update_Milestones on IPM_Project_Document__c (After insert, after update)
{
    set<id> projset = new set<id>();
    map<id,date> docmap = new map<id,date>();
    map<id,string> IpmGate_map = new map<id,string>();
    for(IPM_Project_Document__c ipd : trigger.new)
    {
       if(ipd.IPM_GateDocuments__c != null && ipd.IPM_Document_Status__c == 'Approved' && ipd.IPM_Project__c != null)
       {
           projset.add(ipd.IPM_Project__c);
           IpmGate_map.put(ipd.IPM_Project__c,ipd.IPM_GateDocuments__c );
       }
       if(ipd.IPM_Project__c != null && ipd.IPM_Approval_Date__c != null)
           docmap.put(ipd.IPM_Project__c ,ipd.IPM_Approval_Date__c);
    }
    map<id,IPM_Milestone__c> miles_Map = new map<id,IPM_Milestone__c>([select id,IPM_Type_of_Milestone__c,IPM_Type_of_gate__c,IPM_Completed_On__c,IPM_Project__c from IPM_Milestone__c where IPM_Project__c in : projset and IPM_Type_of_Milestone__c =: 'Standard']);
    List<IPM_Milestone__c > Mile_list = new list<IPM_Milestone__c >();
    for(IPM_Milestone__c M : miles_Map.values())
    {
        if(M.IPM_Project__c != null && IpmGate_map.containskey(M.IPM_Project__c) && M.IPM_Type_of_gate__c == IpmGate_map.get(M.IPM_Project__c) && docmap.containskey(M.IPM_Project__c ) && docmap.get(M.IPM_Project__c ) != null)
        {
            M.IPM_Completed_On__c = docmap.get(M.IPM_Project__c );
            Mile_list.add(M);
        }
    }
    
    if(Mile_list.size() > 0)
        update Mile_list;
}