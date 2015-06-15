/* Type Name: IPM_CreateGateDocuments
Developed By: Kannan and Samrat
Change History: 
Reason: To create Gate Documents(Contract,Market Ready,Market Deployment) and and related Project Document Sections */
public class IPM_CreateGateDocuments
{
    //Method for creating Contract Gate Document
    public static List<IPM_Project_Document__c> projDocList=new List<IPM_Project_Document__c>();
    public static void createContractDocument(List<IPM_Project_Document__c> charterProjDocList,String GateKeepingModel)
    {
        //For GateKeeping Model RCLT
        Set<Id> projectIdsRCLT=new Set<Id>();
        List<IPM_Project__c> regionalProjects=new List<IPM_Project__c>();
        if(GateKeepingModel=='RCLT' || GateKeepingModel=='GCLT & RCLT')
        {
            for(IPM_Project_Document__c pd:charterProjDocList)
            {
                projectIdsRCLT.add(pd.IPM_Project__c);
            }
            System.debug(projectIdsRCLT+'projectIdsRCLT and BoTH');
            regionalProjects=[Select Id,IPM_Parent_Project__c,IPM_Parent_Project__r.Id,IPM_GateKeeping_Model__c from IPM_Project__c where IPM_Parent_Project__c In:projectIdsRCLT];
        }

        Set<Id> projectTemplatesId=new Set<Id>();
        Set<Id> projectDocumentId=new Set<Id>();
        Map<Id,IPM_Project_Document__c> projDocMap=new Map<Id,IPM_Project_Document__c>();
        
        //Fetching Charter Gate Document Project Template Id and Project Document Details
        for(IPM_Project_Document__c pd:charterProjDocList)
        {
            projectDocumentId.add(pd.Id);
            projectTemplatesId.add(pd.IPM_Project_Template__c);
            projDocMap.put(pd.IPM_Project_Template__c,pd);
        }
        Map<Id,Map<String,IPM_Project_Document_Section__c>> projDocSectMap=new Map<Id,Map<String,IPM_Project_Document_Section__c>>();
        Map<String,IPM_Project_Document_Section__c> innerMap = new Map<String,IPM_Project_Document_Section__c>();
        
        //Map of Project Document Section Corresponding to Project Document Which is Used to Carry Over from Charter to Contract Project Document Section
        for(IPM_Project_Document_Section__c prods:[Select Id,IPM_Default_Section__c,IPM_PDP_Document_Summary__c,IPM_Project_Document__c,IPM_Project_Document__r.IPM_Project__c,IPM_Section_Name__c,IPM_Project_Document__r.IPM_Approved_Comments__c,IPM_Gate_Document_Summary__c from IPM_Project_Document_Section__c where IPM_Project_Document__c In:projectDocumentId])
        {
            innerMap.put(prods.IPM_Section_Name__c,prods);
            projDocSectMap.put(prods.IPM_Project_Document__r.IPM_Project__c,innerMap); 
        }
        System.debug(projDocSectMap+'projDocSectMap');
        Set<Id> docTempId=new Set<Id>();
        Map<Id,String> docTempMap=new Map<Id,String>();
        
        //Creating Contract Project Document
        Set<Id> newProjDocsId=new Set<Id>();
        if(GateKeepingModel=='RCLT' || GateKeepingModel=='GCLT & RCLT')
        {
            for(IPM_Document_Template__c docTemp:[Select Id,IPM_Project_Template__c,IPM_Document_Type__c from IPM_Document_Template__c where IPM_Project_Template__c In: projectTemplatesId and IPM_Document_Type__c='Contract'])
            {
                for(Integer i=0;i<regionalProjects.size();i++)
                {
                    IPM_Project_Document__c projDoc=new IPM_Project_Document__c();
                    projDoc.IPM_Project__c=regionalProjects[i].Id;
                    projDoc.IPM_Project_Template__c=docTemp.IPM_Project_Template__c;
                    projDoc.IPM_GateDocuments__c=docTemp.IPM_Document_Type__c;
                    projDoc.IPM_Document_Status__c='Not Started';
                    projDoc.IPM_Contract_GateKeeper_Model__c=regionalProjects[i].IPM_GateKeeping_Model__c;
                    projDocList.add(projDoc);
                    docTempId.add(docTemp.Id);
                    docTempMap.put(projDoc.IPM_Project_Template__c,docTemp.Id);
                }
            }
        }
        if(GateKeepingModel=='GCLT' || GateKeepingModel=='GCLT & RCLT')
        {
            for(IPM_Document_Template__c docTemp:[Select Id,IPM_Project_Template__c,IPM_Document_Type__c from IPM_Document_Template__c where IPM_Project_Template__c In: projectTemplatesId and IPM_Document_Type__c='Contract'])
            {
                IPM_Project_Document__c projDoc=new IPM_Project_Document__c();
                projDoc.IPM_Project__c=projDocMap.get(docTemp.IPM_Project_Template__c).IPM_Project__c;
                projDoc.IPM_Project_Template__c=docTemp.IPM_Project_Template__c;
                projDoc.IPM_GateDocuments__c=docTemp.IPM_Document_Type__c;
                projDoc.IPM_Document_Status__c='Not Started';
                projDoc.IPM_Contract_GateKeeper_Model__c=projDocMap.get(docTemp.IPM_Project_Template__c).IPM_Contract_GateKeeper_Model__c;
                projDocList.add(projDoc);
                docTempId.add(docTemp.Id);
                docTempMap.put(projDoc.IPM_Project_Template__c,docTemp.Id);
            }
        }
        if(projDocList.size() > 0)
        {
            Insert projDocList;
        }
        for(IPM_Project_Document__c pdc:projDocList)
        {
            newProjDocsId.add(pdc.Id);
        }
        system.debug('New ProjectDoc IDs'+newProjDocsId);
        System.debug('Number of Queries used in this Apex code so far: ' + Limits.getQueries());
        projDocList=[Select Id,IPM_Project__c,IPM_Project_Template__c,IPM_GateDocuments__c,IPM_Contract_GateKeeper_Model__c,IPM_Document_Status__c,IPM_Project_Complexity__c,IPM_Project__r.IPM_Parent_Project__c,IPM_Approved_Comments__c from IPM_Project_Document__c where Id In:newProjDocsId];
        List<IPM_Section__c> secList=[Select Id,IPM_Section_Sequence__c,IPM_Section_Name__c,IPM_Negotiable__c,IPM_Document_Template__c,IPM_FunctionalRole__c,IPM_Section_Help_Text__c,IPM_Section_Type__c from IPM_Section__c where IPM_Document_Template__c  In:docTempId];
        List<IPM_Project_Document_Section__c> projDocSectionList=new List<IPM_Project_Document_Section__c>();  
        System.debug(projDocList+'projDocList');
        //Inserting Project Document Sections for Contract Project Document and Carry Over the Data from Charter to Contract
        for(IPM_Project_Document__c projDocs:projDocList)
        {
            for(IPM_Section__c sect:secList)
            {   
                if(docTempMap.get(projDocs.IPM_Project_Template__c)==sect.IPM_Document_Template__c)
                {
                    IPM_Project_Document_Section__c projDocSect=new IPM_Project_Document_Section__c();
                    projDocSect.IPM_Project_Document__c=projDocs.Id;
                    projDocSect.IPM_Section_Name__c=sect.IPM_Section_Name__c;
                    projDocSect.IPM_Section__c=sect.Id;
                    projDocSect.IPM_Section_Status__c='Not Started';
                    projDocSect.IPM_Section_Sequence_Number__c=sect.IPM_Section_Sequence__c;
                    projDocSect.IPM_FunctionalRole__c=sect.IPM_FunctionalRole__c;
                    projDocSect.IPM_Section_Help_Text_Long__c=sect.IPM_Section_Help_Text__c;
                    projDocSect.IPM_Negotiable__c=sect.IPM_Negotiable__c;
                    projDocSect.IPM_Section_Type__c=sect.IPM_Section_Type__c;
                    if(projDocs.IPM_Project_Complexity__c=='Full')
                    {
                        projDocSect.IPM_Default_Section__c=true;
                    }   
                    else if(projDocs.IPM_Project_Complexity__c=='Lite' && sect.IPM_Negotiable__c==false)
                    {   
                        projDocSect.IPM_Default_Section__c=true; 
                    }
                    System.debug(projDocs.IPM_Contract_GateKeeper_Model__c+'projDocs.IPM_Contract_GateKeeper_Model__c');
                    System.debug(projDocSectMap+'projDocSectMap');
                    System.debug(projDocs+'projDocs');
                    System.debug(projDocs.IPM_Project__r.IPM_Parent_Project__c+'projDocs.IPM_Project__r.IPM_Parent_Project__c');
                    if(projDocSect.IPM_Section_Name__c=='Idea / Graphic')//1
                    {
                        if(projDocs.IPM_Contract_GateKeeper_Model__c=='GCLT')
                        {
                            projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                            projDocSect.IPM_PDP_Document_Summary__c = projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                            projDocSect.IPM_Section_Status__c='Filled-in';
                        }
                        else if(projDocs.IPM_Contract_GateKeeper_Model__c=='RCLT')
                        {
                            projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                            projDocSect.IPM_PDP_Document_Summary__c = projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                            projDocSect.IPM_Section_Status__c='Filled-in';
                        }
                        else if(projDocs.IPM_Contract_GateKeeper_Model__c=='GCLT & RCLT')
                        {
                            if(projDocs.IPM_Project__r.IPM_Parent_Project__c!=null)
                            {
                                projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                                projDocSect.IPM_PDP_Document_Summary__c =projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                                projDocSect.IPM_Section_Status__c='Filled-in';
                            }
                            else
                            {
                                projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                                projDocSect.IPM_PDP_Document_Summary__c = projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                                projDocSect.IPM_Section_Status__c='Filled-in';
                            }
                        }
                    }
                    if(projDocSect.IPM_Section_Name__c=='Concept')//2
                    {
                        if(projDocs.IPM_Contract_GateKeeper_Model__c=='GCLT')
                        {
                            projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                            projDocSect.IPM_PDP_Document_Summary__c = projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                            projDocSect.IPM_Section_Status__c='Filled-in';
                        }
                        else if(projDocs.IPM_Contract_GateKeeper_Model__c=='RCLT')
                        {
                            projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                            projDocSect.IPM_PDP_Document_Summary__c = projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                            projDocSect.IPM_Section_Status__c='Filled-in';
                        }
                        else if(projDocs.IPM_Contract_GateKeeper_Model__c=='GCLT & RCLT')
                        {
                            if(projDocs.IPM_Project__r.IPM_Parent_Project__c!=null)
                            {
                                projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                                projDocSect.IPM_PDP_Document_Summary__c = projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                                projDocSect.IPM_Section_Status__c='Filled-in';
                            }
                            else
                            {
                                projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                                projDocSect.IPM_PDP_Document_Summary__c = projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                                projDocSect.IPM_Section_Status__c='Filled-in';
                            }
                        }
                    }
                    if(projDocSect.IPM_Section_Name__c=='Priority Channels, Key Customer Feedback & Implications to the Mix/Plan')//3
                    {
                        if(projDocs.IPM_Contract_GateKeeper_Model__c=='GCLT')
                        {
                            projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get('Customers/Channels').IPM_Gate_Document_Summary__c;
                            projDocSect.IPM_PDP_Document_Summary__c = projDocSectMap.get(projDocs.IPM_Project__c).get('Customers/Channels').IPM_PDP_Document_Summary__c;
                            projDocSect.IPM_Section_Status__c='Filled-in';
                            if(projDocSectMap.get(projDocs.IPM_Project__c).get('Customers/Channels').IPM_Default_Section__c==true)
                                projDocSect.IPM_Default_Section__c=projDocSectMap.get(projDocs.IPM_Project__c).get('Customers/Channels').IPM_Default_Section__c;
                        }
                        else if(projDocs.IPM_Contract_GateKeeper_Model__c=='RCLT')
                        {
                        System.debug(projDocSectMap+'projDocSectMap');
                        System.debug(projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c)+'projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c)');
                        System.debug(projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get('Customers/Channels')+'projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(Customers/Channel)');
                        
                            projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get('Customers/Channels').IPM_Gate_Document_Summary__c;
                            projDocSect.IPM_PDP_Document_Summary__c = projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get('Customers/Channels').IPM_PDP_Document_Summary__c;
                            projDocSect.IPM_Section_Status__c='Filled-in';
                            if(projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get('Customers/Channels').IPM_Default_Section__c==true)
                                projDocSect.IPM_Default_Section__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get('Customers/Channels').IPM_Default_Section__c;
                        }
                        else if(projDocs.IPM_Contract_GateKeeper_Model__c=='GCLT & RCLT')
                        {
                            if(projDocs.IPM_Project__r.IPM_Parent_Project__c!=null)
                            {
                                projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get('Customers/Channels').IPM_Gate_Document_Summary__c;
                                projDocSect.IPM_PDP_Document_Summary__c = projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get('Customers/Channels').IPM_PDP_Document_Summary__c;
                                projDocSect.IPM_Section_Status__c='Filled-in';
                                if(projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get('Customers/Channels').IPM_Default_Section__c==true)
                                    projDocSect.IPM_Default_Section__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get('Customers/Channels').IPM_Default_Section__c;
                            }
                            else
                            {
                                projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get('Customers/Channels').IPM_Gate_Document_Summary__c;
                                projDocSect.IPM_PDP_Document_Summary__c = projDocSectMap.get(projDocs.IPM_Project__c).get('Customers/Channels').IPM_PDP_Document_Summary__c;
                                projDocSect.IPM_Section_Status__c='Filled-in';
                                if(projDocSectMap.get(projDocs.IPM_Project__c).get('Customers/Channels').IPM_Default_Section__c==true)
                                    projDocSect.IPM_Default_Section__c=projDocSectMap.get(projDocs.IPM_Project__c).get('Customers/Channels').IPM_Default_Section__c;
                            }
                        }
                    }
                    if(projDocSect.IPM_Section_Name__c=='Target Audience')//4
                    {
                        if(projDocs.IPM_Contract_GateKeeper_Model__c=='GCLT')
                        {
                            projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                            projDocSect.IPM_PDP_Document_Summary__c = projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                            projDocSect.IPM_Section_Status__c='Filled-in';
                            if(projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c==true)
                                projDocSect.IPM_Default_Section__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c;
                        }
                        else if(projDocs.IPM_Contract_GateKeeper_Model__c=='RCLT')
                        {
                            projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                            projDocSect.IPM_PDP_Document_Summary__c = projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                            projDocSect.IPM_Section_Status__c='Filled-in';
                            if(projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c==true)
                                projDocSect.IPM_Default_Section__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c;
                        }
                        else if(projDocs.IPM_Contract_GateKeeper_Model__c=='GCLT & RCLT')
                        {
                            if(projDocs.IPM_Project__r.IPM_Parent_Project__c!=null)
                            {
                                projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                                projDocSect.IPM_PDP_Document_Summary__c = projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                                projDocSect.IPM_Section_Status__c='Filled-in';
                                if(projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c==true)
                                    projDocSect.IPM_Default_Section__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c;
                            }
                            else
                            {
                                projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                                projDocSect.IPM_PDP_Document_Summary__c =projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                                projDocSect.IPM_Section_Status__c='Filled-in';
                                if(projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c==true)
                                    projDocSect.IPM_Default_Section__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c;
                            }
                        }
                    }
                    if(projDocSect.IPM_Section_Name__c=='Consumer Evidence - Concept')//5
                    {
                        if(projDocs.IPM_Contract_GateKeeper_Model__c=='GCLT')
                        {
                            projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                            projDocSect.IPM_PDP_Document_Summary__c =projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                            projDocSect.IPM_Section_Status__c='Filled-in';
                            if(projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c==true)
                                projDocSect.IPM_Default_Section__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c;
                        }
                        else if(projDocs.IPM_Contract_GateKeeper_Model__c=='RCLT')
                        {
                            projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                            projDocSect.IPM_PDP_Document_Summary__c =projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                            projDocSect.IPM_Section_Status__c='Filled-in';
                            if(projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c==true)
                                projDocSect.IPM_Default_Section__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c;
                        }
                        else if(projDocs.IPM_Contract_GateKeeper_Model__c=='GCLT & RCLT')
                        {
                            if(projDocs.IPM_Project__r.IPM_Parent_Project__c!=null)
                            {
                                projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                                projDocSect.IPM_PDP_Document_Summary__c =projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                                projDocSect.IPM_Section_Status__c='Filled-in';
                                if(projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c==true)
                                    projDocSect.IPM_Default_Section__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c;
                            }
                            else
                            {
                                projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                                projDocSect.IPM_PDP_Document_Summary__c =projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                                projDocSect.IPM_Section_Status__c='Filled-in';
                                if(projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c==true)
                                    projDocSect.IPM_Default_Section__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c;
                            }
                        }
                    }
                    if(projDocSect.IPM_Section_Name__c=='Mix Qualification Plan and Action Standards (Table)')//6
                    {
                        if(projDocs.IPM_Contract_GateKeeper_Model__c=='GCLT')
                        {
                            projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                            projDocSect.IPM_PDP_Document_Summary__c =projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                            projDocSect.IPM_Section_Status__c='Filled-in';
                        }
                        else if(projDocs.IPM_Contract_GateKeeper_Model__c=='RCLT')
                        {
                            projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                            projDocSect.IPM_PDP_Document_Summary__c =projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                            projDocSect.IPM_Section_Status__c='Filled-in';
                        }
                        else if(projDocs.IPM_Contract_GateKeeper_Model__c=='GCLT & RCLT')
                        {
                            if(projDocs.IPM_Project__r.IPM_Parent_Project__c!=null)
                            {
                                projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                                projDocSect.IPM_PDP_Document_Summary__c =projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                                projDocSect.IPM_Section_Status__c='Filled-in';
                            }
                            else
                            {
                                projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                                projDocSect.IPM_PDP_Document_Summary__c =projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                                projDocSect.IPM_Section_Status__c='Filled-in';
                            }
                        }
                    }
                    if(projDocSect.IPM_Section_Name__c=='Business Case vs. Action Standards')//7
                    {
                        if(projDocs.IPM_Contract_GateKeeper_Model__c=='GCLT')
                        {
                            projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get('Financial Action Standards').IPM_Gate_Document_Summary__c;
                            projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get('Financial Action Standards').IPM_PDP_Document_Summary__c;
                            projDocSect.IPM_Section_Status__c='Filled-in';
                        }
                        else if(projDocs.IPM_Contract_GateKeeper_Model__c=='RCLT')
                        {
                            projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get('Financial Action Standards').IPM_Gate_Document_Summary__c;
                            projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get('Financial Action Standards').IPM_PDP_Document_Summary__c;
                            projDocSect.IPM_Section_Status__c='Filled-in';
                        }
                        else if(projDocs.IPM_Contract_GateKeeper_Model__c=='GCLT & RCLT')
                        {
                            if(projDocs.IPM_Project__r.IPM_Parent_Project__c!=null)
                            {
                                projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get('Financial Action Standards').IPM_Gate_Document_Summary__c;
                                projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get('Financial Action Standards').IPM_PDP_Document_Summary__c;
                                projDocSect.IPM_Section_Status__c='Filled-in';
                            }
                            else
                            {
                                projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get('Financial Action Standards').IPM_Gate_Document_Summary__c;
                                projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get('Financial Action Standards').IPM_PDP_Document_Summary__c;
                                projDocSect.IPM_Section_Status__c='Filled-in';
                            }
                        }
                    } 
                    if(projDocSect.IPM_Section_Name__c=='Rollout Plans')//8
                    {
                        if(projDocs.IPM_Contract_GateKeeper_Model__c=='GCLT')
                        {
                            projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                            projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                            projDocSect.IPM_Section_Status__c='Filled-in';
                            if(projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c==true)
                                projDocSect.IPM_Default_Section__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c;
                        }
                        else if(projDocs.IPM_Contract_GateKeeper_Model__c=='RCLT')
                        {
                            projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                            projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                            projDocSect.IPM_Section_Status__c='Filled-in';
                            if(projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c==true)
                                projDocSect.IPM_Default_Section__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c;
                        }
                        else if(projDocs.IPM_Contract_GateKeeper_Model__c=='GCLT & RCLT')
                        {
                            if(projDocs.IPM_Project__r.IPM_Parent_Project__c!=null)
                            {
                                projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                                projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                                projDocSect.IPM_Section_Status__c='Filled-in';
                                if(projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c==true)
                                    projDocSect.IPM_Default_Section__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c;
                            }
                            else
                            {
                                projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                                projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                                projDocSect.IPM_Section_Status__c='Filled-in';
                                if(projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c==true)
                                    projDocSect.IPM_Default_Section__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c;
                            }
                        }
                    }
                    if(projDocSect.IPM_Section_Name__c=='Risk')//9
                    {
                        if(projDocs.IPM_Contract_GateKeeper_Model__c=='GCLT')
                        {
                            projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                            projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                            projDocSect.IPM_Section_Status__c='Filled-in';
                        }
                        else if(projDocs.IPM_Contract_GateKeeper_Model__c=='RCLT')
                        {
                            projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                            projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                            projDocSect.IPM_Section_Status__c='Filled-in';
                        }
                        else if(projDocs.IPM_Contract_GateKeeper_Model__c=='GCLT & RCLT')
                        {
                            if(projDocs.IPM_Project__r.IPM_Parent_Project__c!=null)
                            {
                                projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                                projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                                projDocSect.IPM_Section_Status__c='Filled-in';
                            }
                            else
                            {
                                projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                                projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                                projDocSect.IPM_Section_Status__c='Filled-in';
                            }
                        }
                    }
                    if(projDocSect.IPM_Section_Name__c=='Milestones')//10
                    {
                        if(projDocs.IPM_Contract_GateKeeper_Model__c=='GCLT')
                        {
                            projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                            projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                            projDocSect.IPM_Section_Status__c='Filled-in';
                            if(projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c==true)
                                projDocSect.IPM_Default_Section__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c;
                        }
                        else if(projDocs.IPM_Contract_GateKeeper_Model__c=='RCLT')
                        {
                            projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                            projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                            projDocSect.IPM_Section_Status__c='Filled-in';
                            if(projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c==true)
                                projDocSect.IPM_Default_Section__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c;
                        }
                        else if(projDocs.IPM_Contract_GateKeeper_Model__c=='GCLT & RCLT')
                        {
                            if(projDocs.IPM_Project__r.IPM_Parent_Project__c!=null)
                            {
                                projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                                projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                                projDocSect.IPM_Section_Status__c='Filled-in';
                                if(projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c==true)
                                    projDocSect.IPM_Default_Section__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c;
                            }
                            else
                            {
                                projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                                projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                                projDocSect.IPM_Section_Status__c='Filled-in';
                                if(projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c==true)
                                    projDocSect.IPM_Default_Section__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c;
                            }
                        }
                    }
                    if(projDocSect.IPM_Section_Name__c=='OTIF Status')//11
                    {
                        if(projDocs.IPM_Contract_GateKeeper_Model__c=='GCLT')
                        {
                            projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                            projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                            projDocSect.IPM_Section_Status__c='Filled-in';
                        }
                        else if(projDocs.IPM_Contract_GateKeeper_Model__c=='RCLT')
                        {
                            projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                            projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                            projDocSect.IPM_Section_Status__c='Filled-in';
                        }
                        else if(projDocs.IPM_Contract_GateKeeper_Model__c=='GCLT & RCLT')
                        {
                            if(projDocs.IPM_Project__r.IPM_Parent_Project__c!=null)
                            {
                                projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                                projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                                projDocSect.IPM_Section_Status__c='Filled-in';
                            }
                            else
                            {
                                projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                                projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                                projDocSect.IPM_Section_Status__c='Filled-in';
                            }
                        }
                    } 
                    if(projDocSect.IPM_Section_Name__c=='Feedback from Last Gate')//12 Sprint 5 Requirement
                    {
                        if(projDocs.IPM_Contract_GateKeeper_Model__c=='GCLT')
                        {
                            projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get('Feedback from BOSSCARD').IPM_Project_Document__r.IPM_Approved_Comments__c;
                            projDocSect.IPM_Section_Status__c='Filled-in';
                        }
                        else if(projDocs.IPM_Contract_GateKeeper_Model__c=='RCLT')
                        {
                            projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get('Feedback from BOSSCARD').IPM_Project_Document__r.IPM_Approved_Comments__c;
                            projDocSect.IPM_Section_Status__c='Filled-in';
                        }
                        else if(projDocs.IPM_Contract_GateKeeper_Model__c=='GCLT & RCLT')
                        {
                            if(projDocs.IPM_Project__r.IPM_Parent_Project__c!=null)
                            {
                                projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get('Feedback from BOSSCARD').IPM_Project_Document__r.IPM_Approved_Comments__c;
                                projDocSect.IPM_Section_Status__c='Filled-in';
                            }
                            else
                            {
                                projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get('Feedback from BOSSCARD').IPM_Project_Document__r.IPM_Approved_Comments__c;
                                projDocSect.IPM_Section_Status__c='Filled-in';
                            }
                        }
                    }
                    if(sect.IPM_Section_Type__c=='Header' || sect.IPM_Section_Type__c=='Sub Header')
                    projDocSect.IPM_Section_Status__c='';
                    projDocSectionList.add(projDocSect);  
                }
            }
        }
        if(projDocSectionList.size()>0)
        {
            system.debug('Default Check'+projDocSectionList);
            insert projDocSectionList;
            createOTIFStatus(projDocSectionList,'Contract');
            System.debug(projDocSectionList);
            createGateCheckList(projDocList,'Contract');
            List<IPM_Country__c> countryList=new List<IPM_Country__c>();
            Set<Id> projDocId=new Set<Id>(); 
            Set<Id> parentProjId=new Set<Id>();
            for(IPM_Project_Document__c pd:projDocList)
            {
                projDocId.add(pd.IPM_Project__c);
                parentProjId.add(pd.IPM_Project__r.IPM_Parent_Project__c);
            }
            parentProjId.remove(null);
            /***** Yamuna's future method starts to create tasks */
            IPM_CreateIPMProjectTasks.createIPMTasks(projDocId);
            /***** Yamuna's future method ends to create tasks */
            countryList=[Select Id,Country_Name__c,IPM_Project__c,IPM_Project__r.IPM_Parent_Project__c from IPM_Country__c where IPM_Project__c In:projDocId];
            system.debug('Country List At Contract'+countryList);
            IPM_CRRT_Section_Controller.createCRRTSections('Contract',countryList,GateKeepingModel);
            IPM_GateCMIContorller.copyCMISections(parentProjId,projDocId,'Contract');
            IPM_GateDocumentRiskManagement.CharterToContractRiskQuestions(parentProjId,projDocId);
        }
    }
    //Method for creating Market Ready Gate Document
    public static void createMarketReadyDocument(List<IPM_Project_Document__c> contractProjDocList)
    {
        Set<Id> projectTemplatesId=new Set<Id>();
        Set<Id> projectDocumentId=new Set<Id>();
        Map<Id,IPM_Project_Document__c> projDocMap=new Map<Id,IPM_Project_Document__c>();
        
        //Fetching Charter Gate Document Project Template Id and Project Document Details
        for(IPM_Project_Document__c pd:contractProjDocList)
        {
            projectDocumentId.add(pd.Id);
            projectTemplatesId.add(pd.IPM_Project_Template__c);
            projDocMap.put(pd.IPM_Project_Template__c,pd);
        }
        Map<Id,Map<String,IPM_Project_Document_Section__c>> projDocSectMap=new Map<Id,Map<String,IPM_Project_Document_Section__c>>();
        Map<String,IPM_Project_Document_Section__c> innerMap = new Map<String,IPM_Project_Document_Section__c>();
        
        //Map of Project Document Section Corresponding to Project Document Which is Used to Carry Over from Contract to Market Ready Project Document Section
        for(IPM_Project_Document_Section__c prods:[Select Id,IPM_Project_Document__r.IPM_Approved_Comments__c,IPM_Default_Section__c,IPM_PDP_Document_Summary__c,IPM_Project_Document__c,IPM_Project_Document__r.IPM_Project__c,IPM_Section_Name__c,IPM_Gate_Document_Summary__c from IPM_Project_Document_Section__c where IPM_Project_Document__c In:projectDocumentId])
        {
            innerMap.put(prods.IPM_Section_Name__c,prods);
            projDocSectMap.put(prods.IPM_Project_Document__r.IPM_Project__c,innerMap); 
        }
        Set<Id> docTempId=new Set<Id>();
        Map<Id,String> docTempMap=new Map<Id,String>();
        
        //Creating Contract Project Document
        Set<Id> newProjDocsId=new Set<Id>();
        for(IPM_Document_Template__c docTemp:[Select Id,IPM_Project_Template__c,IPM_Document_Type__c from IPM_Document_Template__c where IPM_Project_Template__c In: projectTemplatesId and IPM_Document_Type__c='Market Ready'])
        {
            IPM_Project_Document__c projDoc=new IPM_Project_Document__c();
            projDoc.IPM_Project__c=projDocMap.get(docTemp.IPM_Project_Template__c).IPM_Project__c;
            projDoc.IPM_Project_Template__c=docTemp.IPM_Project_Template__c;
            projDoc.IPM_GateDocuments__c=docTemp.IPM_Document_Type__c;
            projDoc.IPM_Document_Status__c='Not Started';
            projDocList.add(projDoc);
            docTempId.add(docTemp.Id);
            docTempMap.put(projDoc.IPM_Project_Template__c,docTemp.Id);
            
        }
        if(projDocList.size() > 0)
        {
            Insert projDocList;
        }
        for(IPM_Project_Document__c pdc:projDocList)
        {
            newProjDocsId.add(pdc.Id);
        }
        projDocList=[Select Id,IPM_Project__c,IPM_Project_Template__c,IPM_GateDocuments__c,IPM_Document_Status__c,IPM_Project_Complexity__c,IPM_Approved_Comments__c,IPM_Project__r.IPM_Parent_Project__c from IPM_Project_Document__c where Id In:newProjDocsId];
        List<IPM_Section__c> secList=[Select Id,IPM_Section_Sequence__c,IPM_Section_Name__c,IPM_Negotiable__c,IPM_Document_Template__c,IPM_FunctionalRole__c,IPM_Section_Help_Text__c,IPM_Section_Type__c from IPM_Section__c where IPM_Document_Template__c  In:docTempId];
        List<IPM_Project_Document_Section__c> projDocSectionList=new List<IPM_Project_Document_Section__c>();  

        //Inserting Project Document Sections for market Ready Project Document and Carry Over the Data from COntract to MRD
        for(IPM_Project_Document__c projDocs:projDocList)
        {
            for(IPM_Section__c sect:secList)
            {   
                if(docTempMap.get(projDocs.IPM_Project_Template__c)==sect.IPM_Document_Template__c)
                {
                    IPM_Project_Document_Section__c projDocSect=new IPM_Project_Document_Section__c();
                    projDocSect.IPM_Project_Document__c=projDocs.Id;
                    projDocSect.IPM_Section_Name__c=sect.IPM_Section_Name__c;
                    projDocSect.IPM_Section__c=sect.Id;
                    projDocSect.IPM_Section_Status__c='Not Started';
                    projDocSect.IPM_FunctionalRole__c=sect.IPM_FunctionalRole__c;
                    projDocSect.IPM_Section_Help_Text_Long__c=sect.IPM_Section_Help_Text__c;
                    projDocSect.IPM_Section_Sequence_Number__c=sect.IPM_Section_Sequence__c;
                    projDocSect.IPM_Negotiable__c=sect.IPM_Negotiable__c;
                    projDocSect.IPM_Section_Type__c=sect.IPM_Section_Type__c;
                    if(projDocs.IPM_Project_Complexity__c=='Full')
                    {
                        projDocSect.IPM_Default_Section__c=true;
                    }   
                    else if(projDocs.IPM_Project_Complexity__c=='Lite' && sect.IPM_Negotiable__c==false)
                    {   
                        projDocSect.IPM_Default_Section__c=true; 
                    }
                    if(projDocSect.IPM_Section_Name__c=='Idea / Graphic')//1
                    {
                        projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                        projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                        projDocSect.IPM_Section_Status__c='Filled-in';
                    }
                    
                    if(projDocSect.IPM_Section_Name__c=='Priority Channels, Key Customer Feedback & Implications to the Mix/Plan')//2
                    {
                        projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                        projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                        projDocSect.IPM_Section_Status__c='Filled-in';
                    }
                    
                    if(projDocSect.IPM_Section_Name__c=='Trade Story')//3
                    {
                        projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                        projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                        projDocSect.IPM_Section_Status__c='Filled-in';
                    }
                    
                    if(projDocSect.IPM_Section_Name__c=='Target Audience')//4
                    {
                        projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                        projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                        projDocSect.IPM_Section_Status__c='Filled-in';
                        if(projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c==true)
                            projDocSect.IPM_Default_Section__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c;
                    }
                    
                    if(projDocSect.IPM_Section_Name__c=='Concept')//5
                    {
                        projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                        projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                        projDocSect.IPM_Section_Status__c='Filled-in';
                    }
                    
                    if(projDocSect.IPM_Section_Name__c=='Consumer Evidence – Concept')//6
                    {
                        projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                        projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                        projDocSect.IPM_Section_Status__c='Filled-in';
                        if(projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c==true)
                            projDocSect.IPM_Default_Section__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c;
                    }
                    
                    if(projDocSect.IPM_Section_Name__c=='Communication')//7
                    {
                        projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                        projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                        projDocSect.IPM_Section_Status__c='Filled-in';
                        if(projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c==true)
                            projDocSect.IPM_Default_Section__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c;
                    }
                    
                    if(projDocSect.IPM_Section_Name__c=='Trademarks')//8
                    {
                        projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                        projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                        projDocSect.IPM_Section_Status__c='Filled-in';
                    }
                    if(projDocSect.IPM_Section_Name__c=='Pack/Graphics')//9
                    {
                        projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                        projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                        projDocSect.IPM_Section_Status__c='Filled-in';
                    }
                    if(projDocSect.IPM_Section_Name__c=='Consumer Evidence – Pack')//10
                    {
                        projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                        projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                        projDocSect.IPM_Section_Status__c='Filled-in';
                        if(projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c==true)
                            projDocSect.IPM_Default_Section__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c;
                    }
                    
                    if(projDocSect.IPM_Section_Name__c=='Product')//11
                    {
                        projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                        projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                        projDocSect.IPM_Section_Status__c='Filled-in';
                    }
                    if(projDocSect.IPM_Section_Name__c=='Consumer Evidence - Product')//12
                    {
                        projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                        projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                        projDocSect.IPM_Section_Status__c='Filled-in';
                        if(projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c==true)
                            projDocSect.IPM_Default_Section__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c;
                    }
                    if(projDocSect.IPM_Section_Name__c=='CUs and Complexity')//13
                    {
                        projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                        projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                        projDocSect.IPM_Section_Status__c='Filled-in';
                    }
                    if(projDocSect.IPM_Section_Name__c=='Proposed Pricing')//14
                    {
                        projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                        projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                        projDocSect.IPM_Section_Status__c='Filled-in';
                    }
                    if(projDocSect.IPM_Section_Name__c=='Consumer Evidence – Price')//15
                    {
                        projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                        projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                        projDocSect.IPM_Section_Status__c='Filled-in';
                        if(projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c==true)
                            projDocSect.IPM_Default_Section__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c;
                    }
                    if(projDocSect.IPM_Section_Name__c=='Other Price Rationale')//16
                    {
                        projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                        projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                        projDocSect.IPM_Section_Status__c='Filled-in';
                        if(projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c==true)
                            projDocSect.IPM_Default_Section__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c;
                    }
                    if(projDocSect.IPM_Section_Name__c=='Full Mix')//17
                    {
                        projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                        projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                        projDocSect.IPM_Section_Status__c='Filled-in';
                    }
                    if(projDocSect.IPM_Section_Name__c=='Degree of Commonality')//18
                    {
                        projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                        projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                        projDocSect.IPM_Section_Status__c='Filled-in';
                        if(projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c==true)
                            projDocSect.IPM_Default_Section__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c;
                    }
                    if(projDocSect.IPM_Section_Name__c=='Mix Qualification Plan and Action Standards')//19
                    {
                        projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get('Mix Qualification Plan and Action Standards (Table)').IPM_Gate_Document_Summary__c;
                        projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get('Mix Qualification Plan and Action Standards (Table)').IPM_PDP_Document_Summary__c;
                        projDocSect.IPM_Section_Status__c='Filled-in';
                    }
                    if(projDocSect.IPM_Section_Name__c=='Promotion Guidance for Deployment – PRELIMINARY')//20
                    {
                        projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                        projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                        projDocSect.IPM_Section_Status__c='Filled-in';
                        if(projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c==true)
                            projDocSect.IPM_Default_Section__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c;
                    }
                    if(projDocSect.IPM_Section_Name__c=='Assortment Strategy')//21
                    {
                        projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                        projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                        projDocSect.IPM_Section_Status__c='Filled-in';
                        if(projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c==true)
                            projDocSect.IPM_Default_Section__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c;
                    }
                    if(projDocSect.IPM_Section_Name__c=='Merchandising Strategy')//22
                    {
                        projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                        projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                        projDocSect.IPM_Section_Status__c='Filled-in';
                        if(projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c==true)
                            projDocSect.IPM_Default_Section__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c;
                    }
                    if(projDocSect.IPM_Section_Name__c=='Trade Promotion Strategy')//23
                    {
                        projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                        projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                        projDocSect.IPM_Section_Status__c='Filled-in';
                        if(projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c==true)
                            projDocSect.IPM_Default_Section__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c;
                    }
                    if(projDocSect.IPM_Section_Name__c=='Environmental Impact')//24
                    {
                        projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                        projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                        projDocSect.IPM_Section_Status__c='Filled-in';
                        if(projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c==true)
                            projDocSect.IPM_Default_Section__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c;
                    }
                    if(projDocSect.IPM_Section_Name__c=='Business Case vs. Action Standards')//25
                    {
                        projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                        projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                        projDocSect.IPM_Section_Status__c='Filled-in';
                    } 
                    
                    if(projDocSect.IPM_Section_Name__c=='Assumptions')//26
                    {
                        projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                        projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                        projDocSect.IPM_Section_Status__c='Filled-in';
                    } 
                    
                    if(projDocSect.IPM_Section_Name__c=='Sensitivity Analysis')//27
                    {
                        projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                        projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                        projDocSect.IPM_Section_Status__c='Filled-in';
                        if(projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c==true)
                            projDocSect.IPM_Default_Section__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c;
                    } 
                    
                    if(projDocSect.IPM_Section_Name__c=='BD/BB Alignment')//28
                    {
                        projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                        projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                        projDocSect.IPM_Section_Status__c='Filled-in';
                    } 
                    
                    if(projDocSect.IPM_Section_Name__c=='Business Waste')//29
                    {
                        projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                        projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                        projDocSect.IPM_Section_Status__c='Filled-in';
                        if(projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c==true)
                            projDocSect.IPM_Default_Section__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c;
                    }
                    if(projDocSect.IPM_Section_Name__c=='Rollout Plans')//30
                    {
                        projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                        projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                        projDocSect.IPM_Section_Status__c='Filled-in';
                    } 
                    if(projDocSect.IPM_Section_Name__c=='Risk')//31
                    {
                        projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                        projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                        projDocSect.IPM_Section_Status__c='Filled-in';
                    }
                    if(projDocSect.IPM_Section_Name__c=='Milestones')//32
                    {
                        projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                        projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                        projDocSect.IPM_Section_Status__c='Filled-in';
                        if(projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c==true)
                            projDocSect.IPM_Default_Section__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c;
                    }
                    if(projDocSect.IPM_Section_Name__c=='OTIF Status')//33
                    {
                        projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                        projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                        projDocSect.IPM_Section_Status__c='Filled-in';
                    } 
                    if(projDocSect.IPM_Section_Name__c=='Key Changes since Market Ready Gate')//34 Sprint 5 Requirement
                    {
                        projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__c).get('Feedback from Last Gate').IPM_Project_Document__r.IPM_Approved_Comments__c;
                        projDocSect.IPM_Section_Status__c='Filled-in';
                    } 
                    if(sect.IPM_Section_Type__c=='Header' || sect.IPM_Section_Type__c=='Sub Header')
                    projDocSect.IPM_Section_Status__c='';
                    projDocSectionList.add(projDocSect);  
                }
            }
        }
        if(projDocSectionList.size()>0)
        {
            insert projDocSectionList;
            
            
            
            // for CRRT
             List<IPM_Country__c> countryList=new List<IPM_Country__c>();
            Set<Id> projDocId=new Set<Id>(); 
            Set<Id> parentProjId=new Set<Id>();
            for(IPM_Project_Document__c pd:projDocList)
            {
                projDocId.add(pd.IPM_Project__c);
                parentProjId.add(pd.IPM_Project__r.IPM_Parent_Project__c);
            }
             /***** Yamuna's future method starts to create tasks */
            IPM_CreateIPMProjectTasks.createIPMTasks(projDocId);
            /***** Yamuna's future method ends to create tasks */
            parentProjId.remove(null);
            countryList=[Select Id,Country_Name__c,IPM_Project__c,IPM_Project__r.IPM_Parent_Project__c from IPM_Country__c where IPM_Project__c In:projDocId];
            system.debug('Country List At Contract'+countryList);
            IPM_CRRT_Section_Controller.createCRRTSections('Market Ready',countryList,'GCLT & RCLT');
            //upto here
            createOTIFStatus(projDocSectionList,'Market Ready');
            createGateCheckList(projDocList,'Market Ready');
        }
    }
    //Method for creating Market Deployment Gate Document
    public static void createMarketDeploymentDocument(List<IPM_Project_Document__c> marketReadyProjDocList)
    {
        //For GateKeeping Model RCLT and BOTH
        Set<Id> projectIdsRCLT=new Set<Id>();
        List<IPM_Project__c> localProjects=new List<IPM_Project__c>();
        for(IPM_Project_Document__c pd:marketReadyProjDocList)
        {
            projectIdsRCLT.add(pd.IPM_Project__c);
        }
        System.debug(projectIdsRCLT+'projectIdsRCLT and BoTH');
        localProjects=[Select Id,IPM_Parent_Project__c,IPM_Parent_Project__r.Id,IPM_GateKeeping_Model__c from IPM_Project__c where IPM_Parent_Project__c In:projectIdsRCLT];
        
        Set<Id> projectTemplatesId=new Set<Id>();
        Set<Id> projectDocumentId=new Set<Id>();
        Map<Id,IPM_Project_Document__c> projDocMap=new Map<Id,IPM_Project_Document__c>();
        
        //Fetching Charter Gate Document Project Template Id and Project Document Details
        for(IPM_Project_Document__c pd:marketReadyProjDocList)
        {
            projectDocumentId.add(pd.Id);
            projectTemplatesId.add(pd.IPM_Project_Template__c);
            projDocMap.put(pd.IPM_Project_Template__c,pd);
        }
        Map<Id,Map<String,IPM_Project_Document_Section__c>> projDocSectMap=new Map<Id,Map<String,IPM_Project_Document_Section__c>>();
        Map<String,IPM_Project_Document_Section__c> innerMap = new Map<String,IPM_Project_Document_Section__c>();
        
        //Map of Project Document Section Corresponding to Project Document Which is Used to Carry Over from Contract to Market Ready Project Document Section
        for(IPM_Project_Document_Section__c prods:[Select Id,IPM_Project_Document__r.IPM_Approved_Comments__c,IPM_Default_Section__c,IPM_PDP_Document_Summary__c,IPM_Project_Document__c,IPM_Project_Document__r.IPM_Project__c,IPM_Section_Name__c,IPM_Gate_Document_Summary__c from IPM_Project_Document_Section__c where IPM_Project_Document__c In:projectDocumentId])
        {
            innerMap.put(prods.IPM_Section_Name__c,prods);
            projDocSectMap.put(prods.IPM_Project_Document__r.IPM_Project__c,innerMap); 
        }
        Set<Id> docTempId=new Set<Id>();
        Map<Id,String> docTempMap=new Map<Id,String>();
        
        //Creating Market Deployment Project Document
        Set<Id> newProjDocsId=new Set<Id>();
        for(IPM_Document_Template__c docTemp:[Select Id,IPM_Project_Template__c,IPM_Document_Type__c from IPM_Document_Template__c where IPM_Project_Template__c In: projectTemplatesId and IPM_Document_Type__c='Market Deployment'])
        {
            for(Integer i=0;i<localProjects.size();i++)
            {
                IPM_Project_Document__c projDoc=new IPM_Project_Document__c();
                //projDoc.IPM_Project__c=projDocMap.get(docTemp.IPM_Project_Template__c).IPM_Project__c;
                projDoc.IPM_Project__c=localProjects[i].Id;
                projDoc.IPM_Project_Template__c=docTemp.IPM_Project_Template__c;
                projDoc.IPM_GateDocuments__c=docTemp.IPM_Document_Type__c;
                projDoc.IPM_Document_Status__c='Not Started';
                projDoc.IPM_Contract_GateKeeper_Model__c=localProjects[i].IPM_GateKeeping_Model__c;
                projDocList.add(projDoc);
                docTempId.add(docTemp.Id);
                docTempMap.put(projDoc.IPM_Project_Template__c,docTemp.Id);
            }
        }
        if(projDocList.size() > 0)
        {
            Insert projDocList;
        }
        for(IPM_Project_Document__c pdc:projDocList)
        {
            newProjDocsId.add(pdc.Id);
        }
        projDocList=[Select Id,IPM_Project__c,IPM_Project_Template__c,IPM_GateDocuments__c,IPM_Project__r.IPM_Parent_Project__c,IPM_Document_Status__c,IPM_Project_Complexity__c,IPM_Approved_Comments__c from IPM_Project_Document__c where Id In:newProjDocsId];
        List<IPM_Section__c> secList=[Select Id,IPM_Section_Sequence__c,IPM_Section_Name__c,IPM_Negotiable__c,IPM_Document_Template__c,IPM_FunctionalRole__c,IPM_Section_Help_Text__c,IPM_Section_Type__c from IPM_Section__c where IPM_Document_Template__c  In:docTempId];
        List<IPM_Project_Document_Section__c> projDocSectionList=new List<IPM_Project_Document_Section__c>();  
        System.debug(projDocList+'projDocList');
        //Inserting Project Document Sections for Contract Project Document and Carry Over the Data from Charter to Contract
        for(IPM_Project_Document__c projDocs:projDocList)
        {
            for(IPM_Section__c sect:secList)
            {   
                if(docTempMap.get(projDocs.IPM_Project_Template__c)==sect.IPM_Document_Template__c)
                {
                    IPM_Project_Document_Section__c projDocSect=new IPM_Project_Document_Section__c();
                    projDocSect.IPM_Project_Document__c=projDocs.Id;
                    projDocSect.IPM_Section_Name__c=sect.IPM_Section_Name__c;
                    projDocSect.IPM_Section__c=sect.Id;
                    projDocSect.IPM_Section_Status__c='Not Started';
                    projDocSect.IPM_Section_Sequence_Number__c=sect.IPM_Section_Sequence__c;
                    projDocSect.IPM_FunctionalRole__c=sect.IPM_FunctionalRole__c;
                    projDocSect.IPM_Section_Help_Text_Long__c=sect.IPM_Section_Help_Text__c;
                    projDocSect.IPM_Negotiable__c=sect.IPM_Negotiable__c;
                    projDocSect.IPM_Section_Type__c=sect.IPM_Section_Type__c;
                    if(projDocs.IPM_Project_Complexity__c=='Full')
                    {
                        projDocSect.IPM_Default_Section__c=true;
                    }   
                    else if(projDocs.IPM_Project_Complexity__c=='Lite' && sect.IPM_Negotiable__c==false)
                    {   
                        projDocSect.IPM_Default_Section__c=true; 
                    }
                    if(projDocSect.IPM_Section_Name__c=='Idea / Graphic')//1
                    {
                        projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                        projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                        projDocSect.IPM_Section_Status__c='Filled-in';
                    }
                    if(projDocSect.IPM_Section_Name__c=='Trade Story')//2
                    {
                        projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                        projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                        projDocSect.IPM_Section_Status__c='Filled-in';
                    }
                    if(projDocSect.IPM_Section_Name__c=='Target Audience')//3
                    {
                        projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                        projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                        projDocSect.IPM_Section_Status__c='Filled-in';
                        if(projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c==true)
                            projDocSect.IPM_Default_Section__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c;
                    }
                    if(projDocSect.IPM_Section_Name__c=='Concept')//4
                    {
                        projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                        projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                        projDocSect.IPM_Section_Status__c='Filled-in';
                    }
                    if(projDocSect.IPM_Section_Name__c=='Communication')//5
                    {
                        projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                        projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                        projDocSect.IPM_Section_Status__c='Filled-in';
                        if(projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c==true)
                            projDocSect.IPM_Default_Section__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c;
                    }
                    if(projDocSect.IPM_Section_Name__c=='Pack')//6
                    {
                        projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get('Pack/Graphics').IPM_Gate_Document_Summary__c;
                        projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get('Pack/Graphics').IPM_PDP_Document_Summary__c;
                        projDocSect.IPM_Section_Status__c='Filled-in';
                    }
                    if(projDocSect.IPM_Section_Name__c=='Product')//7
                    {
                        projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                        projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                        projDocSect.IPM_Section_Status__c='Filled-in';
                        if(projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c==true)
                            projDocSect.IPM_Default_Section__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c;
                    }
                    if(projDocSect.IPM_Section_Name__c=='Pricing')//8
                    {
                        projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get('Proposed Pricing').IPM_Gate_Document_Summary__c;
                        projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get('Proposed Pricing').IPM_PDP_Document_Summary__c;
                        projDocSect.IPM_Section_Status__c='Filled-in';
                    }
                    if(projDocSect.IPM_Section_Name__c=='Other Price Rationale (beyond consumer evidence shown in 3.5 below)')//9
                    {
                        projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get('Other Price Rationale').IPM_Gate_Document_Summary__c;
                        projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get('Other Price Rationale').IPM_PDP_Document_Summary__c;
                        projDocSect.IPM_Section_Status__c='Filled-in';
                        if(projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get('Other Price Rationale').IPM_Default_Section__c==true)
                            projDocSect.IPM_Default_Section__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get('Other Price Rationale').IPM_Default_Section__c;
                    }
                    if(projDocSect.IPM_Section_Name__c=='Mix Summary of Performance vs. Action Standards')//10
                    {
                        projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get('Mix Qualification Plan and Action Standards').IPM_Gate_Document_Summary__c;
                        projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get('Mix Qualification Plan and Action Standards').IPM_PDP_Document_Summary__c;
                        projDocSect.IPM_Section_Status__c='Filled-in';
                    }
                    if(projDocSect.IPM_Section_Name__c=='Promotion')//11
                    {
                        projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get('Promotion Guidance for Deployment – PRELIMINARY').IPM_Gate_Document_Summary__c;
                        projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get('Promotion Guidance for Deployment – PRELIMINARY').IPM_PDP_Document_Summary__c;
                        projDocSect.IPM_Section_Status__c='Filled-in';
                        if(projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get('Promotion Guidance for Deployment – PRELIMINARY').IPM_Default_Section__c==true)
                            projDocSect.IPM_Default_Section__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get('Promotion Guidance for Deployment – PRELIMINARY').IPM_Default_Section__c;
                    }
                    if(projDocSect.IPM_Section_Name__c=='Assortment Strategy')//12
                    {
                        projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                        projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                        projDocSect.IPM_Section_Status__c='Filled-in';
                        if(projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c==true)
                            projDocSect.IPM_Default_Section__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c;
                    }
                    if(projDocSect.IPM_Section_Name__c=='Merchandising Strategy')//13
                    {
                        projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                        projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                        projDocSect.IPM_Section_Status__c='Filled-in';
                        if(projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c==true)
                            projDocSect.IPM_Default_Section__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c;
                    }
                    if(projDocSect.IPM_Section_Name__c=='Trade Promotional Strategy')//14
                    {
                        projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get('Trade Promotion Strategy').IPM_Gate_Document_Summary__c;
                        projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get('Trade Promotion Strategy').IPM_PDP_Document_Summary__c;
                        projDocSect.IPM_Section_Status__c='Filled-in';
                        if(projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get('Trade Promotion Strategy').IPM_Default_Section__c==true)
                            projDocSect.IPM_Default_Section__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get('Trade Promotion Strategy').IPM_Default_Section__c;
                    }
                    if(projDocSect.IPM_Section_Name__c=='Business Waste')//15
                    {
                        projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                        projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                        projDocSect.IPM_Section_Status__c='Filled-in';
                        if(projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c==true)
                            projDocSect.IPM_Default_Section__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c;
                    }
                    if(projDocSect.IPM_Section_Name__c=='Milestones')//16
                    {
                        projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Gate_Document_Summary__c;
                        projDocSect.IPM_PDP_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_PDP_Document_Summary__c;
                        projDocSect.IPM_Section_Status__c='Filled-in';
                        if(projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c==true)
                            projDocSect.IPM_Default_Section__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get(projDocSect.IPM_Section_Name__c).IPM_Default_Section__c;
                    }
                    if(projDocSect.IPM_Section_Name__c=='Key Changes since Market Ready Gate')//17 Sprint 5 Requirement
                    {
                        projDocSect.IPM_Gate_Document_Summary__c=projDocSectMap.get(projDocs.IPM_Project__r.IPM_Parent_Project__c).get('Key Changes since Contract Gate').IPM_Project_Document__r.IPM_Approved_Comments__c;
                        projDocSect.IPM_Section_Status__c='Filled-in';
                    } 
                    if(sect.IPM_Section_Type__c=='Header' || sect.IPM_Section_Type__c=='Sub Header')
                    projDocSect.IPM_Section_Status__c='';
                    projDocSectionList.add(projDocSect);  
                }
            }
        }
        if(projDocSectionList.size()>0)
        {
            insert projDocSectionList;
            createGateCheckList(projDocList,'Market Deployment');
           /***** Yamuna's future method starts to create tasks */
              Set<Id> projDocId=new Set<Id>(); 
            for(IPM_Project_Document__c pd:projDocList)
            {
                projDocId.add(pd.IPM_Project__c);
            }
            IPM_CreateIPMProjectTasks.createIPMTasks(projDocId);
            /***** Yamuna's future method ends to create tasks */

        }
    }
    public static void createOTIFStatus(List<IPM_Project_Document_Section__c> projDocSecList,String gateDocumentType )
    {
        List<IPM_Project_Document_Section_Content__c> insertOTIFStatus=new List<IPM_Project_Document_Section_Content__c>();
        List<IPM_OTIF_Status__c> otiFStatus=[Select Name,IPM_Gate_Document_Type__c,OTIF_Help_Text__c,OTIF_HelpText_Red__c,OTIF_HelpText_Green__c,OTIF_HelpText_Amber__c,OTIF_Measure__c,OTIF_No_of_Status__c,OTIF_Responsibility__c,OTIF_Status__c,IPM_Section_Number__c,OTIF_Sequence_Number__c from IPM_OTIF_Status__c where IPM_Gate_Document_Type__c=:gateDocumentType];
        Map<String,Id>sectionIds=new Map<String,Id>();
        Map<String,String>sectionNames=new Map<String,String>();
        for(IPM_Project_Document_Section__c ips:projDocSecList) 
        {
            sectionIds.put(ips.IPM_Section_Sequence_Number__c,ips.Id);
            sectionNames.put(ips.IPM_Section_Sequence_Number__c,ips.IPM_Section_Name__c);
        }
        for(IPM_Project_Document_Section__c ps: projDocSecList)
        {
            if(ps.IPM_Section_Type__c=='Static Table' && ps.IPM_Section_Name__c=='OTIF Status')
            {
                for( IPM_OTIF_Status__c os:otiFStatus)
                {
                    IPM_Project_Document_Section_Content__c secCon=new IPM_Project_Document_Section_Content__c();
                    secCon.IPM_Project_Document_Section__c=ps.Id;
                    secCon.IPM_OTIF_Responsibility__c=os.OTIF_Responsibility__c;
                    secCon.IPM_OTIF_Measure__c=os.OTIF_Measure__c;
                    secCon.IPM_OTIF_Status__c=os.OTIF_Status__c;
                    secCon.IPM_Section_type__c=ps.IPM_Section_Type__c;
                    secCon.IPM_OTIF_No_of_Status__c=os.OTIF_No_of_Status__c;
                    secCon.IPM_OTIF_HelpText_Red__c=os.OTIF_HelpText_Red__c;
                    secCon.IPM_OTIF_HelpText_Green__c=os.OTIF_HelpText_Green__c;
                    secCon.IPM_OTIF_HelpText_Amber__c=os.OTIF_HelpText_Amber__c;
                    secCon.IPM_OTIF_HelpText_NA__c=os.OTIF_Help_Text__c;
                    secCon.IPM_Section_Number__c=os.IPM_Section_Number__c; // to fetch the related section
                    secCon.IPM_OTIF_Sequence__c=os.OTIF_Sequence_Number__c; //sequence number for OTIF
                    secCon.IPM_Section_Id__c=sectionIds.get(secCon.IPM_Section_Number__c);
                    secCon.IPM_Section_Name__c=sectionNames.get(secCon.IPM_Section_Number__c);
                    insertOTIFStatus.add(secCon);
                }
            }
        }               
        if(insertOTIFStatus.size()>0)
        insert insertOTIFStatus; 
    }
    public static void createGateCheckList(List<IPM_Project_Document__c> projDocsList,String gateDocumentType)
    {
        System.debug(projDocsList+'projDocSecList from Calling Gatekeeper'+gateDocumentType);
        List<Id> ProjectIds=new List<Id>();
        for(IPM_Project_Document__c ip:projDocsList) 
        {
            ProjectIds.add(ip.IPM_Project__c);
        }   
        System.debug(ProjectIds+'ProjectIds');
        IPM_GatekeeperChecklist.generateGKChecklist(gateDocumentType,ProjectIds);   
    }
}