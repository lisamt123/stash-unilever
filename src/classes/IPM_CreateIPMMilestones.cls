public class IPM_CreateIPMMilestones {
    public static Boolean offtrigger=false;
    
    @future
    public static void updateprojects(){
        //update updprojects;
    }

    public static void createMileStonesTargetLaunchDate(List<IPM_Project__c> ipmprojects){
        List<IPM_Project__c> project=new List<IPM_Project__c>();
        for(IPM_Project__c projects:ipmprojects){
            if(projects.IPM_Target_Launch_Dates__c != null){
            
                Date myDate = date.newinstance(projects.CreatedDate.year(), projects.CreatedDate.month(), projects.CreatedDate.day());
                System.debug('\n Date Value:'+myDate.daysBetween(projects.IPM_Target_Launch_Dates__c));
                System.debug(myDate);
               // if(myDate.daysBetween(projects.IPM_Target_Launch_Dates__c) > 390)
                    project.add(projects);
                }
        }
       if(!project.isEmpty()) {
           createMilestones(project);
       }
    }
    public static void createMilestones(List<IPM_Project__c> ipmprojects){
        Id milePMRecordType=Schema.SObjectType.IPM_Milestone__c.getRecordTypeInfosByName().get('IPM Project Milestones').getRecordTypeId();
        Id mileMRecordType=Schema.SObjectType.IPM_Milestone__c.getRecordTypeInfosByName().get('IPM Milestones').getRecordTypeId();
        List<IPM_Project__c> project=new List<IPM_Project__c>();
        for(IPM_Project__c projects:ipmprojects){
            if(projects.IPM_Target_Launch_Dates__c != null)
                project.add(projects);
        }
        
        List<IPM_Milestone__c> lstMilestone;
        
         lstMilestone=[SELECT Id,IPM_Market_Type__c,IPM_Category__c,IPM_No_Of_Days_for_Developing__c,IPM_No_Of_Days_for_Developing_Emerging__c,IPM_Completed_On__c,IPM_Completed__c,IPM_Due_Date__c,IPM_Milestone__c,IPM_Name__c,IPM_No_of_Days__c,IPM_Phase__c,IPM_Planned_Date__c,IPM_Project__c,IPM_Type_of_gate__c,IPM_Type_of_Milestone__c FROM IPM_Milestone__c where IPM_Project__c IN:project];

        List<IPM_Milestone__c> createMilestone=new List<IPM_Milestone__c>();
        List<IPM_Milestone__c> cMilestone=new List<IPM_Milestone__c>();
        if(lstMilestone.isEmpty()){
            lstMilestone=[SELECT Id,IPM_Market_Type__c,IPM_Category__c,IPM_No_Of_Days_for_Developing__c,IPM_No_Of_Days_for_Developing_Emerging__c,IPM_Completed_On__c,IPM_Completed__c,IPM_Due_Date__c,IPM_Milestone__c,IPM_Name__c,IPM_No_of_Days__c,IPM_Phase__c,IPM_Planned_Date__c,IPM_Project__c,IPM_Type_of_gate__c,IPM_Type_of_Milestone__c FROM IPM_Milestone__c where RecordTypeId =: mileMRecordType and IPM_Type_of_Milestone__c = 'Standard'];
        }
       /* for(IPM_Project__c proj:project){
            for(IPM_Milestone__c mStone:lstMilestone){
                if(mStone.IPM_Category__c == proj.IPM_Category_Group__c){
                    cMilestone.add(mStone);
                }
            }
        }*/
        if(!lstMilestone.isEmpty()){
            for(IPM_Project__c proj:project){
                for(IPM_Milestone__c mile:lstMilestone){
                    System.debug('Check Values:'+proj.IPM_Category_Group__c+mile.IPM_Category__c);
                    System.debug('Check Values:'+mile.IPM_No_of_Days__c);
                    if(proj.IPM_Category_Group__c== mile.IPM_Category__c){
                        IPM_Milestone__c milestone=new IPM_Milestone__c();
                        milestone.IPM_Name__c =mile.IPM_Name__c;
                        milestone.IPM_Phase__c =mile.IPM_Phase__c;
                        milestone.IPM_Category__c=mile.IPM_Category__c;
                        milestone.IPM_Type_of_gate__c =mile.IPM_Type_of_gate__c;
                        milestone.IPM_Type_of_Milestone__c =mile.IPM_Type_of_Milestone__c;
                        milestone.IPM_No_Of_Days_for_Developing__c=mile.IPM_No_Of_Days_for_Developing__c;
                        milestone.IPM_No_Of_Days_for_Developing_Emerging__c=mile.IPM_No_Of_Days_for_Developing_Emerging__c;
                        Date myDate = date.newinstance(proj.CreatedDate.year(), proj.CreatedDate.month(), proj.CreatedDate.day());
                        System.debug('Days Between'+myDate.daysBetween(proj.IPM_Target_Launch_Dates__c));
                        //if(myDate.daysBetween(proj.IPM_Target_Launch_Dates__c) > 390 ){ 
                            
                            if(proj.IPM_Market_Type__c =='Developing' && !(proj.IPM_Fast_Track_Project__c) && String.isNotEmpty(mile.IPM_No_Of_Days_for_Developing__c)){
                                if(proj.IPM_Target_Launch_Dates__c + Integer.valueOf(mile.IPM_No_Of_Days_for_Developing__c) > myDate){
                                    milestone.IPM_Planned_Date__c =proj.IPM_Target_Launch_Dates__c + Integer.valueOf(mile.IPM_No_Of_Days_for_Developing__c);
                                }
                                
                            }else if(proj.IPM_Market_Type__c =='Developing & Emerging' && !(proj.IPM_Fast_Track_Project__c) && String.isNotEmpty(mile.IPM_No_Of_Days_for_Developing_Emerging__c)){
                                if(proj.IPM_Target_Launch_Dates__c + Integer.valueOf(mile.IPM_No_Of_Days_for_Developing_Emerging__c) > myDate){
                                    milestone.IPM_Planned_Date__c =proj.IPM_Target_Launch_Dates__c + Integer.valueOf(mile.IPM_No_Of_Days_for_Developing_Emerging__c);
                                }
                            }
                           /* if(mile.IPM_Phase__c =='Ideas'){
                            
                                Date sampledate=proj.IPM_Target_Launch_Dates__c + Integer.valueOf(mile.IPM_No_of_Days__c); 
                                    if(sampledate.year() - proj.IPM_Target_Launch_Dates__c.year() == 2 || proj.IPM_Target_Launch_Dates__c.Month() == 1){
                                        milestone.IPM_Planned_Date__c =proj.IPM_Target_Launch_Dates__c + Integer.valueOf(mile.IPM_No_of_Days__c);    
                                    }else{
                                        milestone.IPM_Planned_Date__c=date.newInstance(proj.IPM_Target_Launch_Dates__c.year()-2, 12, 31);
                                    }
                            }else {
                                milestone.IPM_Planned_Date__c =proj.IPM_Target_Launch_Dates__c + Integer.valueOf(mile.IPM_No_of_Days__c);    
                            }*/
                        //}
                        
                        milestone.IPM_Project__c =proj.Id;
                        milestone.RecordTypeId=milePMRecordType;
                        milestone.ExternalField__c=milestone.IPM_Name__c +'-'+ proj.Id ;
                        createMilestone.add(milestone);
                    }
                }
            }
        }
        
        if(!createMilestone.isEmpty()){
        System.debug(createMilestone);
            IPM_CreateIPMMilestones.offtrigger=true;
            upsert createMilestone ExternalField__c;
        }
        
    }
}