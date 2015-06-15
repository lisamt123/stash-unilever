public with sharing class isll_SustainableLivingExpertsController {
    public isll_SustainableLivingExpertsController(){
        fillExpertsMap();
    }
    
    public List<String> expertises {get; set;}
    
    // List of elements.
    public Map<String, List<User>> expertsByExpertise
    {
        get{
            if(expertsByExpertise == null){
                fillExpertsMap();
            }
            return expertsByExpertise;
        }
        
        set;
    }
    
    public void fillExpertsMap(){
        expertsByExpertise = new Map<String, List<User>>();
        expertises = new List<String>();
        
        for(User user : [SELECT Id, Sustainability_Expert__c, Expertise__c, Name, FullPhotoUrl, SmallPhotoUrl, LocaleSidKey, Email, Phone, Title
                        FROM User 
                        WHERE Sustainability_Expert__c = true 
                        AND   Expertise__c != null
                        ORDER BY Name]) 
        {
           for(String expertise : user.Expertise__c.split(';')){
                addExpertToMap(expertise, user);
            }
        }
        
        expertises.sort();
    }
    
    private void addExpertToMap(String expertise, User expert){
        if(expertsByExpertise.get(expertise) == null){
            expertsByExpertise.put(expertise, new List<User>());
            expertises.add(expertise);
        }
        expertsByExpertise.get(expertise).add(expert);
    }
}