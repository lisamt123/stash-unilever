/*
Created by:Rajesh(Cognizant)
Crated Date:23/02/2015
Description:Assortment Strategy by local project country level
*/
public class IPM_AssortmentStrategy {
    public string DistributionType{get;set;}//get selected distribustion type
    public List<String> Names{get; set;}//get Customer Channels names
    public list<mdm_CU_Sales_SKU_Count_Mapping__c>ipmCUslst{get;set;}
    public String channelName{get; set;}//get selected customer channels from UI
    public set<string>setchannelName{get;set;}//set of selected channels name
    public string SelectedCUsNames{get;set;}//get selected CUs name
    public set<string>setSelectedCUsNames{get;set;}//set all selected CUs name
    public IPM_Project_Document_Section_Content__c IPMProdocContent{get;set;}
   // public string ProdocSecId{get;set;}//Get SectionID
    public list<IPM_Project_Document_Section_Content__c>lstAssortStrategy{get;set;}
    public set<string>setAssortStrategy{get;set;}//Unique AssortID
    public string selecteAssortTodelete{get;set;}//get Assort id to be delete
    public string selecteAssortName{get;set;}//get Assort name to be delete
    public string AssortTarget{get;set;}
    public string AssortPriority{get;set;}
    public Id ProdocSecId;
    public ID getProdocSecId(){ return ProdocSecId; }
    public void setProdocSecId (ID p){
        ProdocSecId= p;
        getAssortStrategy();
   }
    
//Constructor
public IPM_AssortmentStrategy (){
        DistributionType='';
        SelectedCUsNames='';
        selecteAssortName='';
        AssortTarget='';
        AssortPriority='';
        setSelectedCUsNames=new set<string>();
        setchannelName=new set<string>();
        IPMProdocContent=new IPM_Project_Document_Section_Content__c();
        selecteAssortTodelete='';
       // ProdocSecId=apexpages.currentpage().getparameters().get('projDocSecId');
        getCChannelsNames();
        getCUs();
        getAssortStrategy();
        
}

//Get list of Customer Chennels names
public void getCChannelsNames(){
    Names=new List<String>();
    Schema.DescribeFieldResult fieldResult = IPM_Project_Document_Section_Content__c.IPM_Customer_Channels__c.getDescribe();
    List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
    
    for( Schema.PicklistEntry f : ple)
    {
        Names.add(f.getValue());
    }    
 }
//Get CUs cuontry related list
public void getCUs(){
    ipmCUslst=new list<mdm_CU_Sales_SKU_Count_Mapping__c>();
    ipmCUslst=[select CU_Description__c,name,Country__c from mdm_CU_Sales_SKU_Count_Mapping__c where Country__c='Argentina'];
    
}
//get all selected customer channels
public void HoldCustomesChannels(){
    if(setchannelName.size()<=5){
        if(setchannelName.contains(channelName)){
            setchannelName.remove(channelName);
        }else{
         setchannelName.add(channelName);
        }
   }else{
   
   }
   system.debug('setchannelName....'+setchannelName); 
}

//get selected all CUs based on country
public void HoldCUsNames(){
     if(setSelectedCUsNames.contains(SelectedCUsNames)){
        setSelectedCUsNames.remove(SelectedCUsNames);
     }else{
     setSelectedCUsNames.add(SelectedCUsNames);
     }
  system.debug('setSelectedCUsNames....'+setSelectedCUsNames);   
}
//create AssortStrategy
public void CreateAssortStrategy(){
getAssortStrategy();
list<IPM_Project_Document_Section_Content__c>lstProDocContent=new list<IPM_Project_Document_Section_Content__c>();
IPM_Project_Document_Section_Content__c ProdocCon=new IPM_Project_Document_Section_Content__c();
//Map<String,IPM_Customer_Channel_Priority_Order__c> channelPriority=IPM_Customer_Channel_Priority_Order__c.getAll();
if(setSelectedCUsNames.size()>0 && setchannelName.size()>0){
    for(string cu:setSelectedCUsNames){
        for(string cuname:setchannelName){
              boolean isdupval=false;
              for(IPM_Project_Document_Section_Content__c dupcus:lstAssortStrategy){
                  
                  if(dupcus.IPM_Incumbent_CUs__c==cu && dupcus.IPM_Customer_Channels__c==cuname){
                      isdupval=true;
                      break;
                  }
             
               }
            if(isdupval==false){
            ProdocCon=new IPM_Project_Document_Section_Content__c();
            ProdocCon.IPM_Incumbent_CUs__c=cu;
            ProdocCon.IPM_Customer_Channels__c=cuname;
            ProdocCon.IPM_AssortmentStrategy_From__c=IPMProdocContent.IPM_AssortmentStrategy_From__c;
            ProdocCon.IPM_AssortmentStrategy_To__c=IPMProdocContent.IPM_AssortmentStrategy_To__c;
            ProdocCon.IPM_Distribution_Type__c=DistributionType;
            ProdocCon.IPM_Project_Document_Section__c=ProdocSecId;
           // ProdocCon.IPM_Customer_Channel_Priority_Order__c=Integer.valueOf(channelPriority.get(ProdocCon.IPM_Customer_Channels__c).Priority_Order_Value__c);
            lstProDocContent.add(ProdocCon);
            }
        }
    }
upsert lstProDocContent;
getAssortStrategy();
}
}
//get allready created AssortStrategy
public void getAssortStrategy(){
lstAssortStrategy=new list<IPM_Project_Document_Section_Content__c>();
setAssortStrategy=new set<string>();
//setAssortStrategy=(new map<string,IPM_Project_Document_Section__c>([select IPM_Incumbent_CUs__c from IPM_Project_Document_Section_Content__c 
                            //where IPM_Project_Document_Section__c=:ProdocSecId ])).keyset();
lstAssortStrategy=[select IPM_Customer_Channel_Priority__c,IPM_Incumbent_CUs__c,IPM_Assortment_Strategy_Priority__c,IPM_Assortment_strategy_Target__c,IPM_Customer_Channels__c,IPM_AssortmentStrategy_From__c,
                    IPM_AssortmentStrategy_To__c,IPM_Distribution_Type__c,IPM_Project_Document_Section__c 
                    from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__c=:ProdocSecId];
                    
for(IPM_Project_Document_Section_Content__c  AssortS:lstAssortStrategy) {
    setAssortStrategy.add(AssortS.IPM_Incumbent_CUs__c);
}                   
}
//Delete singleRecord of AssortStrategy
/*public void DeleteSingleAssortS(){
    IPM_Project_Document_Section_Content__c dltAssortS=[select id from IPM_Project_Document_Section_Content__c where
                                                        id=:selecteAssortTodelete];
    delete dltAssortS;                                                    
    getAssortStrategy();
}*/
//Delete all record related to Assort header
public void DltAllAssort(){
    list<IPM_Project_Document_Section_Content__c> dltAllAssortS=[select id from IPM_Project_Document_Section_Content__c where
                                                        IPM_Incumbent_CUs__c=:selecteAssortName and IPM_Project_Document_Section__c=:ProdocSecId];
    delete dltAllAssortS;                                                    
    getAssortStrategy();
}
//Update Assort Strategy record with priority
public void updateAssortS(){
    IPM_Project_Document_Section_Content__c updateAssort=new IPM_Project_Document_Section_Content__c();
    updateAssort.id=selecteAssortTodelete;
    if(AssortPriority !=''){
    updateAssort.IPM_Assortment_Strategy_Priority__c=AssortPriority;
    }
    system.debug('AssortTarget .....'+AssortTarget);
    if(AssortTarget !=''){
    updateAssort.IPM_Assortment_strategy_Target__c=AssortTarget;
    }
    update updateAssort;
    getAssortStrategy();    
}
}