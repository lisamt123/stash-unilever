/* Type Name: IPM_CRRT_Section_Controller
Developed By: Kannan and Samrat
Change History: 
Reason: To Create,Modify,Delete CRRT Section */
public class IPM_CRRT_Section_Controller
{
    public Boolean isEditable {get; set;}
    public Id projDocSecId;
    public ID getprojDocSecId(){ return projDocSecId; }
    public void setprojDocSecId (ID p){
        projDocSecId= p;
        showCountryUnitList();
    }
    public IPM_Project_Document_Section__c projDocSec{get;set;} 
    public List<IPM_Project_Document_Section_Content__c> countryUnitList{get; set;}
    public List<IPM_Country__c> countryList{get; set;}
    public String gate{get; set;}
    public Id conId{get; set;}
    public IPM_Project_Document_Section_Content__c secCon{get; set;}
    public String crrtStatus{get; set;}
    public String incumbentUnit{get; set;}
    public Integer cuVolume{get;set;}
    public String crrtCountry{get; set;}
    public Integer noChangeCount{get; set;}
    public Integer discontinueCount{get; set;}
    public Integer replaceCount{get; set;}
    public Integer newCount{get; set;}
    public Integer totalCount{get; set;}
    public Boolean filterNoChange{get; set;}
    public static String GKM_MODEL_GLOBAL='GCLT' ;
    public static String GKM_MODEL_REGIONAL='RCLT' ;
    public static String GKM_MODEL_BOTH='GCLT & RCLT' ;
    
    
    public IPM_CRRT_Section_Controller()
    {
        
    }
    public void showCountryUnitList()
    {
        if(projDocSecId!=null)
        {
            projDocSec=[Select Id,IPM_Section_Sequence__c,IPM_Project_Document__c,IPM_Project_Document__r.IPM_Project__c from IPM_Project_Document_Section__c where Id=:projDocSecId];
            countryUnitList=[Select Id,IPM_CRRT_Country__c,IPM_CRRT_Status__c,IPM_CU_Sales_SKU_Count_Mapping__c,IPM_CU_Sales_SKU_Count_Mapping__r.Country__c,IPM_CU_Volume__c,IPM_Incumbent_CUs__c,IPM_Project_Document_Section__c from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__c=:projDocSec.Id order by IPM_CU_Volume__c desc];
            System.debug(countryUnitList.size()+'countryUnitList.size()');
            countryList=[Select Id,Country_Name__c,IPM_Project__c from IPM_Country__c where IPM_Project__c=:projDocSec.IPM_Project_Document__r.IPM_Project__c order by Country_Name__c asc];
            System.debug(countryList.size()+'countryList.size()');
            noChangeCount=[Select count() from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__c=:projDocSec.Id and IPM_CRRT_Status__c='No Change'];
            discontinueCount=[Select count() from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__c=:projDocSec.Id and IPM_CRRT_Status__c='Discontinued'];
            replaceCount=[Select count() from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__c=:projDocSec.Id and IPM_CRRT_Status__c='Replace'];
            newCount=[Select count() from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__c=:projDocSec.Id and IPM_New_CRRT__c=true];
            totalCount=[Select count() from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__c=:projDocSec.Id];
            totalCount=totalCount-noChangeCount;
        }
    }
    //Method for Creating CRRT Records for Project Document Section
    public static void createCRRTSections(String gateType,List<IPM_Country__c> countryList,String gateKeepingModel)
    {
        //Getting Project Ids and Country Names
        Set<String> countryNames=new Set<String>();
        Set<Id> projId=new Set<Id>();
        for(IPM_Country__c c:countryList)
        {
            projId.add(c.IPM_Project__c);
            countryNames.add(c.Country_Name__c);
        }
        System.debug(countryNames+'countryNames');
        if(gateType=='Charter')
        {
            //Getting Project Document Sections
            List<IPM_Project_Document_Section__c> crrtSectionList=new List<IPM_Project_Document_Section__c>();
            crrtSectionList=[Select Id,IPM_Section_Sequence_Number__c,IPM_Project_Document__c,IPM_Project_Document__r.IPM_Project__c,IPM_Project_Document__r.IPM_GateDocuments__c from IPM_Project_Document_Section__c where IPM_Project_Document__r.IPM_Project__c In:projId and IPM_Project_Document__r.IPM_GateDocuments__c=:gateType and IPM_Section_Sequence_Number__c=:'3.2.1'];
            System.debug(countryNames+'crrtSectionList');
            List<IPM_Project_Document_Section_Content__c> insertCRRTSection=new List<IPM_Project_Document_Section_Content__c>();
            
            //Getting Consumer Unit Mapping for Countries
            List<mdm_CU_Sales_SKU_Count_Mapping__c> cuSKUMappingList=new List<mdm_CU_Sales_SKU_Count_Mapping__c>();
            cuSKUMappingList=[SELECT Brand_Code__c,Brand_Name__c,Category_Group_Code__c,Category_Group_Name__c,Channel_Name__c,Country__c,CU_Cases__c,CU_Code__c,CU_Description__c,CU_GP__c,CU_Value__c,CU_Volume__c,Id,Market_Cluster__c,Market_Code__c,Market_Name__c,Name,Quarter_Name__c,SKU_Cases__c,SKU_Count__c,SKU_GP__c,SKU_Sales__c,SKU_Volume__c FROM mdm_CU_Sales_SKU_Count_Mapping__c where Country__c In:countryNames];
            
            //Creating CRRT Section Records
            for(IPM_Project_Document_Section__c pds:crrtSectionList)
            {
                for(IPM_Country__c c:countryList)
                {
                    if(pds.IPM_Project_Document__r.IPM_Project__c==c.IPM_Project__c)
                    {
                        for(Integer i=0;i<cuSKUMappingList.size();i++)
                        {
                            if(c.Country_Name__c==cuSKUMappingList[i].Country__c)
                            {
                                IPM_Project_Document_Section_Content__c pdsc=new IPM_Project_Document_Section_Content__c();
                                pdsc.IPM_CU_Sales_SKU_Count_Mapping__c=cuSKUMappingList[i].Id;
                                pdsc.IPM_Incumbent_CUs__c=cuSKUMappingList[i].CU_Description__c;
                                pdsc.IPM_CU_Volume__c=cuSKUMappingList[i].CU_Volume__c;
                                pdsc.IPM_Project_Document_Section__c=pds.Id;
                                pdsc.IPM_CRRT_Status__c='No Change';
                                insertCRRTSection.add(pdsc);
                            }
                        }
                    }
                }
            }
            if(insertCRRTSection.size()>0)
            Insert insertCRRTSection;
            System.debug(insertCRRTSection+'insertCRRTSection');    
        }
        else if(gateType=='Contract')
        {
            system.debug('Inside Contract');
            List<IPM_Project_Document_Section__c> crrtSectionList=new List<IPM_Project_Document_Section__c>();
            crrtSectionList=[Select Id,IPM_Section_Sequence_Number__c,IPM_Project_Document__r.IPM_Project__r.IPM_Parent_Project__c,IPM_Project_Document__c,IPM_Project_Document__r.IPM_Project__c,IPM_Project_Document__r.IPM_Project_Span__c,IPM_Project_Document__r.IPM_GateDocuments__c from IPM_Project_Document_Section__c where IPM_Project_Document__r.IPM_Project__c In:projId and IPM_Project_Document__r.IPM_GateDocuments__c=:gateType and IPM_Section_Sequence_Number__c=:'3.3.3' Limit 999];
            System.debug(countryNames+'crrtSectionList');
            List<IPM_Project_Document_Section_Content__c> crrtSectionContentList=new List<IPM_Project_Document_Section_Content__c>();
            List<IPM_Project_Document_Section_Content__c> insetCRRTSectionContentList=new List<IPM_Project_Document_Section_Content__c>();
            If(gateKeepingModel==GKM_MODEL_REGIONAL|| gateKeepingModel==GKM_MODEL_BOTH)
            {
                List<IPM_Project__c> projectList=[Select Id,IPM_Parent_Project__c from IPM_Project__c where Id in:projId];
                Set<Id> parentProjId=new Set<Id>();
                for(IPM_Project__c p:projectList)
                {
                    if(p.IPM_Parent_Project__c!=null)
                    parentProjId.add(p.IPM_Parent_Project__c);
                }
                System.debug(parentProjId);
                crrtSectionContentList=[Select Id,IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__r.IPM_Parent_Project__c,IPM_CU_Sales_SKU_Count_Mapping__c,IPM_CU_Sales_SKU_Count_Mapping__r.Country__c,IPM_Incumbent_CUs__c,IPM_CU_Volume__c,IPM_Project_Document_Section__c,IPM_Project_Document_Section__r.IPM_Project_Document__c,IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__c,IPM_CRRT_Status__c from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__c In:parentProjId and IPM_Project_Document_Section__r.IPM_Section_Sequence_Number__c='3.2.1' and IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_GateDocuments__c='Charter' Limit 999];
            }

            for(IPM_Project_Document_Section__c cpds:crrtSectionList)
            {
                for(IPM_Project_Document_Section_Content__c cpdsc:crrtSectionContentList)
                {
                    if(cpds.IPM_Project_Document__r.IPM_Project_Span__c=='Global')
                    {
                        if(cpds.IPM_Project_Document__r.IPM_Project__c==cpdsc.IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__c)
                        {
                            IPM_Project_Document_Section_Content__c crrtSection=new IPM_Project_Document_Section_Content__c();
                            crrtSection.IPM_CU_Sales_SKU_Count_Mapping__c=cpdsc.IPM_CU_Sales_SKU_Count_Mapping__c;
                            crrtSection.IPM_CU_Volume__c=cpdsc.IPM_CU_Volume__c;
                            crrtSection.IPM_Project_Document_Section__c=cpds.Id;
                            crrtSection.IPM_CRRT_Status__c=cpdsc.IPM_CRRT_Status__c;
                            crrtSection.IPM_Incumbent_CUs__c=cpdsc.IPM_Incumbent_CUs__c;
                            insetCRRTSectionContentList.add(crrtSection);
                        }
                    }
                    else if(cpds.IPM_Project_Document__r.IPM_Project_Span__c=='Regional')
                    {
                        if(cpds.IPM_Project_Document__r.IPM_Project__r.IPM_Parent_Project__c==cpdsc.IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__c)
                        {
                            IPM_Project_Document_Section_Content__c crrtSection=new IPM_Project_Document_Section_Content__c();
                            crrtSection.IPM_CU_Sales_SKU_Count_Mapping__c=cpdsc.IPM_CU_Sales_SKU_Count_Mapping__c;
                            crrtSection.IPM_CU_Volume__c=cpdsc.IPM_CU_Volume__c;
                            crrtSection.IPM_Project_Document_Section__c=cpds.Id;
                            crrtSection.IPM_CRRT_Status__c=cpdsc.IPM_CRRT_Status__c;
                            crrtSection.IPM_Incumbent_CUs__c=cpdsc.IPM_Incumbent_CUs__c;
                            insetCRRTSectionContentList.add(crrtSection);
                        }
                    }
                }
            }
            if(insetCRRTSectionContentList.size()>0)
            insert insetCRRTSectionContentList;
        }
        ///Markert Ready
        else if(gateType=='Market Ready')
        {
            system.debug('Inside Market Ready');
            List<IPM_Project_Document_Section__c> crrtSectionList=new List<IPM_Project_Document_Section__c>();
            crrtSectionList=[Select Id,IPM_Section_Sequence_Number__c,IPM_Project_Document__r.IPM_Project__r.IPM_Parent_Project__c,IPM_Project_Document__c,IPM_Project_Document__r.IPM_Project__c,IPM_Project_Document__r.IPM_Project_Span__c,IPM_Project_Document__r.IPM_GateDocuments__c from IPM_Project_Document_Section__c where IPM_Project_Document__r.IPM_Project__c In:projId and IPM_Project_Document__r.IPM_GateDocuments__c=:gateType and IPM_Section_Sequence_Number__c=:'3.3.3' Limit 999];
            System.debug(countryNames+'crrtSectionList');
            List<IPM_Project_Document_Section_Content__c> crrtSectionContentList=new List<IPM_Project_Document_Section_Content__c>();
            List<IPM_Project_Document_Section_Content__c> insetCRRTSectionContentList=new List<IPM_Project_Document_Section_Content__c>();
           /* If(gateKeepingModel==GKM_MODEL_REGIONAL|| gateKeepingModel==GKM_MODEL_BOTH)
            {
                List<IPM_Project__c> projectList=[Select Id,IPM_Parent_Project__c from IPM_Project__c where Id in:projId];
                Set<Id> parentProjId=new Set<Id>();
                for(IPM_Project__c p:projectList)
                {
                    if(p.IPM_Parent_Project__c!=null)
                    parentProjId.add(p.IPM_Parent_Project__c);
                }
                System.debug(parentProjId);*/
                crrtSectionContentList=[Select Id,IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__r.IPM_Parent_Project__c,IPM_CU_Sales_SKU_Count_Mapping__c,IPM_CU_Sales_SKU_Count_Mapping__r.Country__c,IPM_Incumbent_CUs__c,IPM_CU_Volume__c,IPM_Project_Document_Section__c,IPM_Project_Document_Section__r.IPM_Project_Document__c,IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__c,IPM_CRRT_Status__c from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__c In:projId and IPM_Project_Document_Section__r.IPM_Section_Sequence_Number__c='3.3.3' and IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_GateDocuments__c='Contract' Limit 999];
           // }

            for(IPM_Project_Document_Section__c cpds:crrtSectionList)
            {
                for(IPM_Project_Document_Section_Content__c cpdsc:crrtSectionContentList)
                {
                   // if(cpds.IPM_Project_Document__r.IPM_Project_Span__c=='Global')
                    //{
                        if(cpds.IPM_Project_Document__r.IPM_Project__c==cpdsc.IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__c)
                        {
                            IPM_Project_Document_Section_Content__c crrtSection=new IPM_Project_Document_Section_Content__c();
                            crrtSection.IPM_CU_Sales_SKU_Count_Mapping__c=cpdsc.IPM_CU_Sales_SKU_Count_Mapping__c;
                            crrtSection.IPM_CU_Volume__c=cpdsc.IPM_CU_Volume__c;
                            crrtSection.IPM_Project_Document_Section__c=cpds.Id;
                            crrtSection.IPM_CRRT_Status__c=cpdsc.IPM_CRRT_Status__c;
                            crrtSection.IPM_Incumbent_CUs__c=cpdsc.IPM_Incumbent_CUs__c;
                            insetCRRTSectionContentList.add(crrtSection);
                        }
                    //}
                    /*else if(cpds.IPM_Project_Document__r.IPM_Project_Span__c=='Regional')
                    {
                        if(cpds.IPM_Project_Document__r.IPM_Project__r.IPM_Parent_Project__c==cpdsc.IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__c)
                        {
                            IPM_Project_Document_Section_Content__c crrtSection=new IPM_Project_Document_Section_Content__c();
                            crrtSection.IPM_CU_Sales_SKU_Count_Mapping__c=cpdsc.IPM_CU_Sales_SKU_Count_Mapping__c;
                            crrtSection.IPM_CU_Volume__c=cpdsc.IPM_CU_Volume__c;
                            crrtSection.IPM_Project_Document_Section__c=cpds.Id;
                            crrtSection.IPM_CRRT_Status__c=cpdsc.IPM_CRRT_Status__c;
                            crrtSection.IPM_Incumbent_CUs__c=cpdsc.IPM_Incumbent_CUs__c;
                            insetCRRTSectionContentList.add(crrtSection);
                        }
                    }*/
                }
            }
            if(insetCRRTSectionContentList.size()>0)
            insert insetCRRTSectionContentList;
        }
    }
    //Method for updating the CRRT Status
    public void updateCRRTStatus()
    {
        if(conId!=null)
        {
            secCon=[Select Id,IPM_CRRT_Status__c,IPM_CU_Sales_SKU_Count_Mapping__c,IPM_CU_Sales_SKU_Count_Mapping__r.Country__c,IPM_CU_Volume__c,IPM_Incumbent_CUs__c,IPM_Project_Document_Section__c from IPM_Project_Document_Section_Content__c where Id=:conId];
            secCon.IPM_CRRT_Status__c=crrtStatus;
            update secCon;
        }
        countryUnitList=[Select Id,IPM_CRRT_Country__c,IPM_CRRT_Status__c,IPM_CU_Sales_SKU_Count_Mapping__c,IPM_CU_Sales_SKU_Count_Mapping__r.Country__c,IPM_CU_Volume__c,IPM_Incumbent_CUs__c,IPM_Project_Document_Section__c from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__c=:projDocSec.Id];  
    }
    //Method for Creating New Consumer Units
    public void createCRRTSection()
    {
        IPM_Project_Document_Section_Content__c pdsc=new IPM_Project_Document_Section_Content__c();
        pdsc.IPM_Incumbent_CUs__c=incumbentUnit;
        pdsc.IPM_CU_Volume__c=cuVolume;
        pdsc.IPM_Project_Document_Section__c=projDocSecId;
        pdsc.IPM_CRRT_Status__c='No Change';
        pdsc.IPM_CRRT_Country__c=crrtCountry;
        pdsc.IPM_New_CRRT__c=true;
        Insert pdsc;
        countryUnitList=[Select Id,IPM_CRRT_Country__c,IPM_CRRT_Status__c,IPM_CU_Sales_SKU_Count_Mapping__c,IPM_CU_Sales_SKU_Count_Mapping__r.Country__c,IPM_CU_Volume__c,IPM_Incumbent_CUs__c,IPM_Project_Document_Section__c from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__c=:projDocSec.Id];  
    }
    //Method for Removing Consumer Units
    public void removeCRRTSection()
    {
        if(conId!=null)
        {
            IPM_Project_Document_Section_Content__c delCon=[Select Id from IPM_Project_Document_Section_Content__c where Id=:conId];
            Delete delCon;
        }
        countryUnitList=[Select Id,IPM_CRRT_Country__c,IPM_CRRT_Status__c,IPM_CU_Sales_SKU_Count_Mapping__c,IPM_CU_Sales_SKU_Count_Mapping__r.Country__c,IPM_CU_Volume__c,IPM_Incumbent_CUs__c,IPM_Project_Document_Section__c from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__c=:projDocSec.Id];  
    }
    //Method for Removing Consumer Units When Countries Deleted
    public static void deleteCRRTSection(List<IPM_Country__c> countryList)
    {
        //Getting Project Ids and Country Names
        Set<String> countryNames=new Set<String>();
        Set<Id> projId=new Set<Id>();
        for(IPM_Country__c c:countryList)
        {
            projId.add(c.IPM_Project__c);
            countryNames.add(c.Country_Name__c);
        }
        System.debug(countryNames+'countryNames');
        //Getting Project Document Sections
        List<IPM_Project_Document_Section__c> projDocSectionList=new List<IPM_Project_Document_Section__c>();
        projDocSectionList=[Select Id,IPM_Section_Sequence_Number__c,IPM_Project_Document__c,IPM_Project_Document__r.IPM_Project__c from IPM_Project_Document_Section__c where IPM_Project_Document__r.IPM_Project__c In:projId and IPM_Section_Sequence_Number__c='3.1.3'];
        Set<Id> crrtSection=new Set<Id>();
        for(IPM_Project_Document_Section__c pds:projDocSectionList)
        {
            crrtSection.add(pds.Id);
        }
        List<IPM_Project_Document_Section_Content__c> crrtSectionList=new List<IPM_Project_Document_Section_Content__c>();
        List<IPM_Project_Document_Section_Content__c> deleteCRRTSectionList=new List<IPM_Project_Document_Section_Content__c>();
        crrtSectionList=[Select Id,IPM_CU_Sales_SKU_Count_Mapping__c,IPM_CU_Sales_SKU_Count_Mapping__r.Country__c,IPM_Project_Document_Section__c from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__c In:crrtSection];
        for(IPM_Project_Document_Section__c pds:projDocSectionList)
        {
            for(IPM_Country__c c:countryList)
            {
                if(pds.IPM_Project_Document__r.IPM_Project__c==c.IPM_Project__c)
                {
                    for(Integer i=0;i<crrtSectionList.size();i++)
                    {
                        if(c.Country_Name__c==crrtSectionList[i].IPM_CU_Sales_SKU_Count_Mapping__r.Country__c)
                        {
                            deleteCRRTSectionList.add(crrtSectionList[i]);
                        }
                    }
                }
            }
        }       
    }
    //Method for NoChange Filter
    public void filterNoChange()
    {
        if(filterNoChange==true)
        {
            countryUnitList=[Select Id,IPM_CRRT_Country__c,IPM_CRRT_Status__c,IPM_CU_Sales_SKU_Count_Mapping__c,IPM_CU_Sales_SKU_Count_Mapping__r.Country__c,IPM_CU_Volume__c,IPM_Incumbent_CUs__c,IPM_Project_Document_Section__c from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__c=:projDocSec.Id and IPM_CRRT_Status__c='No Change' order by IPM_CU_Volume__c desc];
        }
        else
        {
            countryUnitList=[Select Id,IPM_CRRT_Country__c,IPM_CRRT_Status__c,IPM_CU_Sales_SKU_Count_Mapping__c,IPM_CU_Sales_SKU_Count_Mapping__r.Country__c,IPM_CU_Volume__c,IPM_Incumbent_CUs__c,IPM_Project_Document_Section__c from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__c=:projDocSec.Id order by IPM_CU_Volume__c desc];
        }
    }
}