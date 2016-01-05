public class Oblix_wrapper_NonCamp{  
      
        private String ActivityName= System.Label.Oblix_Lbl_Activity;
        private String marKObjName= System.Label.Oblix_Lbl_Marketing_Basics_c ;
    
        public String name {get;set;}
        //public id itemID{get;set;} 
        public Marketing_Basics__c lookupActivity{get;set;}
        public String selectedRoleTitle{get;set;}        
        public String selectedCountry{get;set;}
        public String selectedCountryname{get;set;}
        public String selectedAgencyDepartment{get;set;}
        public String Rate {get;set;}
        public String RateRounded {get;set;}
        public String result {get;set;}
        public  integer val {get;set;}
        
        public Boolean agencyVisible {get;set;}
        public Boolean roleVisible {get;set;}
        public Boolean valVisible {get;set;}
        public Boolean rateVisible {get;set;}
        public Boolean resultVisible {get;set;}
        public Boolean addVisible {get;set;}
        
        public Oblix_wrapper_NonCamp(){
            lookupActivity = new Marketing_Basics__c ();
            lookupActivity.RecordTypeId = Oblix_Utils.MapRecordType(marKObjName).get(ActivityName);
        
        }
        
        public void clear() {
             lookupActivity = new Marketing_Basics__c ();
            String empty_Value = '';
            lookupActivity.RecordTypeId = Oblix_Utils.MapRecordType(marKObjName).get(ActivityName);
            lookupActivity.Activities__c = empty_Value;
            lookupActivity.Other_Activities__c = empty_Value;
            val = 0;
            selectedCountry = empty_Value;
            selectedCountryname = empty_Value;
            selectedRoleTitle = empty_Value;
            selectedAgencyDepartment = empty_Value;
            result = empty_Value;
            rate = empty_Value;
            rateRounded = empty_Value;
           
            agencyVisible = false;
            roleVisible = false;
            valVisible = false;
            resultVisible = false;
            addVisible = false;
        
            }   
    }