public with sharing class Oblix_Ctrl02OverrideAssetNew { 
    
    public Oblix_Project_Assets__c asset {get;set;}
    public Id rt_AudioVisuel {get;set;}
    public Id rt_StaticImagery {get;set;}
    public Id rt_Admin {get;set;}
    public Id rt_Digital {get;set;}
    public Id rt_Experiential {get;set;}
    public Id rt_Stimulus_Materials_Research_requirements{get;set;}
    public  String rtName{get;set;}
    private String assetObjectName = 'oblix_project_assets__c';
    public Id agencyid {get;set;}
    
    public Oblix_Ctrl02OverrideAssetNew(ApexPages.StandardController controller){
         if(!System.Test.isRunningTest()){
             controller.addFields(new List<String>{'RecordType.Name','RecordTypeId','Sub_Category__c', 'Asset_Type__c', 'Agency_Projects__c'});
         }
         this.asset  = (Oblix_Project_Assets__c) controller.getRecord();
         System.debug('###asset.Id : '+asset.Id);
         agencyid = asset.Agency_Projects__c;
         	//List of Record Types to be used in VF
         	rt_AudioVisuel = Oblix_Utils.MapRecordType(assetObjectName).get('Audio_Visual'); 
            rt_StaticImagery = Oblix_Utils.MapRecordType(assetObjectName).get('Static_Imagery');
            rt_Admin = Oblix_Utils.MapRecordType(assetObjectName).get('Admin');
            rt_Digital = Oblix_Utils.MapRecordType(assetObjectName).get('Digital');
            rt_Experiential = Oblix_Utils.MapRecordType(assetObjectName).get('Experiential');
            rt_Stimulus_Materials_Research_requirements    = Oblix_Utils.MapRecordType(assetObjectName).get('Stimulus_Materials_Research_requirements');
            
         String clone = ApexPages.currentPage().getParameters().get('clone');
         if(clone != null && clone =='1'){
         	String idClonedFrom =  ApexPages.currentPage().getParameters().get('retUrl');
	        idClonedFrom = idClonedFrom.replace('/','');
	         asset = asset.clone();
         }else{
         	if(asset == null || asset.Id == null){
	            if(ApexPages.currentPage().getParameters().get('RecordType') != null){
	                  asset = new Oblix_Project_Assets__c(RecordTypeId=ApexPages.currentPage().getParameters().get('RecordType'));//(Oblix_Project_Assets__c)Oblix_Project_Assets__c.sObjectType.newSObject(ApexPages.currentPage().getParameters().get('RecordType'), true) ;
	                  rtName = [Select Id, Name, DeveloperName from RecordType where Id =: asset.RecordTypeId Limit 1].Name;
	                asset.Agency_Projects__c = agencyid;  
	            }
		   }else{
		       asset = [Select Id, Name, Asset_Type__c, Sub_Category__c, Agency_Projects__c, RecordTypeId,RecordType.Name,
		                    Quantity__c, Channels__c, Location__c, FULL_Description__c, Additional_Description__c, Asset_Picklist__c
		                        from Oblix_Project_Assets__c where Id =: ApexPAges.currentPage().getParameters().get('Id')
		                    ];
		         }
         }
    }
    
    public PageReference save(){
        try{
            System.debug('asset : '+asset);
            if(asset != null && asset.Id != null){
                update asset;
            }else{
                insert asset;
            }
            return new PAgeReference('/'+asset.Id);
        }catch(DmlException e){
            System.debug('Error Occured :'+e.getMessage());
        }
        return null;
        
    }
    
}