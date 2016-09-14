public class ChatterAuraMessageSegment {
    
    @AuraEnabled
    public String text {get; set;} 
    
    @AuraEnabled
    public String type {get; set;}
    
    @AuraEnabled
    public String referenceId {get; set;}

}