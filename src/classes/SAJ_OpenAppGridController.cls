public class SAJ_OpenAppGridController {

   public Business_Solution__c[] valueHighComplexHigh {get;set;}
    public Business_Solution__c[] valueHighComplexMed {get;set;}
    public Business_Solution__c[] valueHighComplexLow {get;set;}
    public Business_Solution__c[] valueHighComplexUnkwn {get;set;}
    public Business_Solution__c[] valueMedComplexHigh {get;set;}
    public Business_Solution__c[] valueMedComplexMed {get;set;}  
    public Business_Solution__c[] valueMedComplexLow {get;set;}
    public Business_Solution__c[] valueMedComplexUnkwn {get;set;}  
    public Business_Solution__c[] valueLowComplexHigh {get;set;}
    public Business_Solution__c[] valueLowComplexMed {get;set;}
    public Business_Solution__c[] valueLowComplexLow {get;set;}
    public Business_Solution__c[] valueLowComplexUnkwn {get;set;}
    public Business_Solution__c[] undefinedBucket {get;set;}
  

  public SAJ_OpenAppGridController(){
      
    refresh();
    
  }
  
  public void refresh(){
    
    valueHighComplexHigh = new List<Business_Solution__c>();
    valueHighComplexMed = new List<Business_Solution__c>();
    valueHighComplexLow = new List<Business_Solution__c>();
    valueHighComplexUnkwn = new List<Business_Solution__c>();
    valueMedComplexHigh = new List<Business_Solution__c>();
    valueMedComplexMed = new List<Business_Solution__c>();
    valueMedComplexLow = new List<Business_Solution__c>();
    valueMedComplexUnkwn = new List<Business_Solution__c>();
    valueLowComplexHigh = new List<Business_Solution__c>();
    valueLowComplexMed = new List<Business_Solution__c>();
    valueLowComplexLow = new List<Business_Solution__c>();
    valueLowComplexUnkwn = new List<Business_Solution__c>();
    undefinedBucket = new List<Business_Solution__c>();
    
    for(Business_Solution__c eachApp : [SELECT id, Name, Complexity__c, Business_Value__c, IPIX_Funded__c, Description__c, Status__c, Phase__c FROM Business_Solution__c WHERE Status__c IN ('Pre-Project','IPIX Project') ORDER BY Name asc]){
        System.debug('App is '+eachApp.Name+', Complexity='+eachApp.Complexity__c+', Business Value='+eachApp.Business_Value__c);
        if ( eachApp.Business_Value__c == null || eachApp.Complexity__c == null ) {
            System.debug('Added '+eachApp.Name+ ' to undefined list.');
            undefinedBucket.add(eachApp);
        } else if ( eachApp.Business_Value__c == '' || eachApp.Complexity__c == '' ) {
            System.debug('Added '+eachApp.Name+ ' to undefined list.');
            undefinedBucket.add(eachApp);
        } else {
            if(eachApp.Business_Value__c == 'High'){
               
              if(eachApp.Complexity__c == 'High')
                valueHighComplexHigh.add(eachApp);
              if(eachApp.Complexity__c == 'Medium')
                valueHighComplexMed.add(eachApp);
              if(eachApp.Complexity__c == 'Low')
                valueHighComplexLow.add(eachApp);
              if(eachApp.Complexity__c == 'Unknown')
                valueHighComplexUnkwn.add(eachApp);                
                                 
             } else if(eachApp.Business_Value__c == 'Medium'){
               
              if(eachApp.Complexity__c == 'High')
                valueMedComplexHigh.add(eachApp);
              if(eachApp.Complexity__c == 'Medium')
                valueMedComplexMed.add(eachApp);
              if(eachApp.Complexity__c == 'Low')
                valueMedComplexLow.add(eachApp);         
              if(eachApp.Complexity__c == 'Unknown')
                valueMedComplexUnkwn.add(eachApp); 
                         
             } else if(eachApp.Business_Value__c == 'Low'){
               
              if(eachApp.Complexity__c == 'High')
                valueLowComplexHigh.add(eachApp);
              if(eachApp.Complexity__c == 'Medium')
                valueLowComplexMed.add(eachApp);
              if(eachApp.Complexity__c == 'Low')
                valueLowComplexLow.add(eachApp);    
              if(eachApp.Complexity__c == 'Unknown')
                valueLowComplexUnkwn.add(eachApp);    
             }      
         
         }
        
      }
  }
}