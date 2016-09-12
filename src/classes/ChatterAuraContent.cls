public class ChatterAuraContent {

    @AuraEnabled
    public String fileType {get; set;}
    
    @AuraEnabled
    public String downloadUrl {get; set;}
    
    @AuraEnabled
    public String title {get; set;}
    
    @AuraEnabled
    public String fileExtension {get; set;}
    
    @AuraEnabled
    public String renditionUrl {get; set;}  
    
     @AuraEnabled
    public String renditionUrl240By180 {get; set;} 
    
     @AuraEnabled
    public String renditionUrl720By480 {get; set;} 
    
    @AuraEnabled
    public String contentUrl {get; set;}  
 
    @AuraEnabled
    public String versionId {get; set;} 
    
    @AuraEnabled
    public String contentId {get; set;}
    
    
}