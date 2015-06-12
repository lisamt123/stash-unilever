/*
Created by:Rajesh(Cognizant)
Created date:12/03/2015
Description:save eco design section records
*/

public  class IPM_EcoDesignSection {
public IPM_Project_Document_Section_Content__c IPM_SecContent{get;set;}
public Id ProdocSecId;
public ID getProdocSecId(){ return ProdocSecId; }
public boolean isEditable{get;set;}
public string ecoDid{get;set;}
public void setProdocSecId (ID p){
        ProdocSecId= p;
        getEcodesign();
   }
   
public IPM_EcoDesignSection (){
getEcodesign();
isEditable=true;
IPM_SecContent=new IPM_Project_Document_Section_Content__c();
}
public void Saverecords(){
if(ecoDid ==''){
IPM_SecContent.IPM_Project_Document_Section__c=ProdocSecId;
insert IPM_SecContent;
ecoDid=IPM_SecContent.id;
getEcodesign();
}else{
IPM_SecContent.id=ecoDid;
update IPM_SecContent;
getEcodesign();
system.debug('update.....'+IPM_SecContent);
}

}
public void getEcodesign(){
ecoDid='';
system.debug('.....'+IPM_SecContent);
IPM_Project_Document_Section_Content__c ecodesign1=new IPM_Project_Document_Section_Content__c();
list<IPM_Project_Document_Section_Content__c>ecodesign=[select id from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__c=:ProdocSecId limit 1];
if(ecodesign.size()>0){
IPM_SecContent=[select id,IPM_Comparison_SKU__c,New_SKU__c,IPM_Comparison_SKU_Waste__c,IPM_New_SKU_Waste__c,
                    IPM_Expected_Change_Waste__c,IPM_Directional_View_Waste__c,IPM_Comparison_SKU_Water__c,
                    IPM_New_SKU_Water__c,IPM_Expected_Change_Water__c,IPM_Directional_View_Water__c,
                    IPM_Comparison_SKU_Greenhouse__c,IPM_New_SKU_Greenhouse__c,IPM_Expected_Change_Greenhouse__c,
                    IPM_Directional_View_Greenhouse__c,IPM_Comparison_SKU_Sourcing__c,IPM_Sustainale_Sourcing__c,IPM_Nutrition__c
                     from IPM_Project_Document_Section_Content__c where id=:ecodesign[0].id];
ecoDid=IPM_SecContent.id;
}
}
}