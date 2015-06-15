public class IPM_CreateProjectDocumentSections
{
    List<IPM_Project_Document__c> projDocList=new List<IPM_Project_Document__c>();
   //IPM_GatekeeperChecklist gkCheckList=new IPM_GatekeeperChecklist(); 
public void createSections(List<IPM_Project__c> projectList,Set<Id> bosscardId)
    {
        Map<Id,String> projectTemplatesMap=new Map<Id,String>();
        
        Map<Id,IPM_Bosscard__c> bosscardMap=new Map<Id,IPM_Bosscard__c>();
        Set<Id> projectTemplatesId=new Set<Id>();
        if(projectList.size()>0)
        {
            for(IPM_Project_Template__c temp:[Select Id,IPM_Template_Complexity__c from IPM_Project_Template__c])
            {
                for(Integer i=0;i<projectList.size();i++)
                {
                    if(temp.IPM_Template_Complexity__c==projectList[i].IPM_Complexity__c)
                    {
                        projectTemplatesMap.put(temp.Id,projectList[i].Id);
                        projectTemplatesId.add(temp.Id);
                    }

                }
            }
            System.debug('Template Picked');
            if(bosscardId.size()>0)
            {
                for(IPM_Bosscard__c boss:[Select Id,IPM_Consumer_Need__c,IPM_Sustainibility__c,IPM_Background__c,IPM_Bosscard_Approver_Comments__c from IPM_Bosscard__c where Id In: bosscardId])
                {
                    for(Integer i=0;i<projectList.size();i++)
                    {
                        if(projectList[i].IPM_Bosscard__c==boss.Id)
                        {
                            bosscardMap.put(projectList[i].IPM_Bosscard__c,boss);
                        }
                    }
                }
            }
            System.debug('projectTemplatesMap'+projectTemplatesMap);
            System.debug('projectTemplatesId'+projectTemplatesId);
            Set<Id> docTempId=new Set<Id>();
            Map<Id,String> docTempMap=new Map<Id,String>();
            for(IPM_Document_Template__c docTemp:[Select Id,IPM_Project_Template__c,IPM_Document_Type__c from IPM_Document_Template__c where IPM_Project_Template__c In: projectTemplatesId and IPM_Document_Type__c='Charter'])
            {
                IPM_Project_Document__c projDoc=new IPM_Project_Document__c();
                System.debug(projectTemplatesMap.get(docTemp.IPM_Project_Template__c)+'From Map');
                projDoc.IPM_Project__c=projectTemplatesMap.get(docTemp.IPM_Project_Template__c);
                projDoc.IPM_Project_Template__c=docTemp.IPM_Project_Template__c;
                projDoc.IPM_GateDocuments__c=docTemp.IPM_Document_Type__c;
                projDoc.IPM_Document_Status__c='Not Started';
                projDocList.add(projDoc);
                docTempId.add(docTemp.Id);  
                docTempMap.put(projDoc.IPM_Project_Template__c,docTemp.Id);
                //IPM_GatekeeperChecklist.generateGKChecklist(projDoc.IPM_GateDocuments__c,projDoc.IPM_Project__c);
            }
            Insert projDocList;
            System.debug('docTempId'+docTempId);
            System.debug('docTempMap'+docTempMap);
            System.debug('projDocList'+projDocList);
            List<IPM_Section__c> secList=[Select Id,IPM_Section_Sequence__c,IPM_Section_Name__c,IPM_Negotiable__c,IPM_Document_Template__c,IPM_FunctionalRole__c,IPM_Section_Help_Text__c,IPM_Section_Type__c from IPM_Section__c where IPM_Document_Template__c  In:docTempId];
            System.debug('secList'+secList);
            List<IPM_Project_Document_Section__c> projDocSectionList=new List<IPM_Project_Document_Section__c>();
            for(IPM_Project__c proj:projectList)
            {
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
                            projDocSect.IPM_Negotiable__c=sect.IPM_Negotiable__c;
                            projDocSect.IPM_Section_Sequence_Number__c=sect.IPM_Section_Sequence__c;
                            projDocSect.IPM_Section_Type__c=sect.IPM_Section_Type__c;
                            System.debug('Complexity'+proj.IPM_Complexity__c+'Negotiable'+sect.IPM_Negotiable__c);
                            if(proj.IPM_Complexity__c=='Full')
                            projDocSect.IPM_Default_Section__c=true;
                            else if(proj.IPM_Complexity__c=='Lite' && sect.IPM_Negotiable__c==false)
                            projDocSect.IPM_Default_Section__c=true; 
                            
                            if(proj.IPM_Bosscard__c!=null) 
                            {
                                System.debug('proj.IPM_Bosscard__c'+proj.IPM_Bosscard__c);
                                System.debug('bosscardMap'+bosscardMap);
                                if(bosscardMap.get(proj.IPM_Bosscard__c).IPM_Consumer_Need__c!=null  && projDocSect.IPM_Section_Name__c=='Consumer Need')
                                {
                                    projDocSect.IPM_Gate_Document_Summary__c=bosscardMap.get(proj.IPM_Bosscard__c).IPM_Consumer_Need__c;
                                    projDocSect.IPM_Section_Status__c='Filled-in';
                                }
                                if(bosscardMap.get(proj.IPM_Bosscard__c).IPM_Sustainibility__c!=null  && projDocSect.IPM_Section_Name__c=='Environmental Impact')
                                {
                                    projDocSect.IPM_Gate_Document_Summary__c=bosscardMap.get(proj.IPM_Bosscard__c).IPM_Sustainibility__c;
                                    projDocSect.IPM_Section_Status__c='Filled-in';
                                }
                                if(bosscardMap.get(proj.IPM_Bosscard__c).IPM_Background__c!=null  && projDocSect.IPM_Section_Name__c=='Strategic Fit')
                                {
                                    projDocSect.IPM_Gate_Document_Summary__c=bosscardMap.get(proj.IPM_Bosscard__c).IPM_Background__c;
                                    projDocSect.IPM_Section_Status__c='Filled-in';
                                }
                                if(bosscardMap.get(proj.IPM_Bosscard__c).IPM_Bosscard_Approver_Comments__c!=null  && projDocSect.IPM_Section_Name__c=='Feedback from BOSSCARD')
                                {
                                    projDocSect.IPM_Gate_Document_Summary__c=bosscardMap.get(proj.IPM_Bosscard__c).IPM_Bosscard_Approver_Comments__c;
                                    projDocSect.IPM_Section_Status__c='Filled-in';
                                }
                            }
                            if(sect.IPM_Section_Type__c=='Header' || sect.IPM_Section_Type__c=='Sub Header')
                            projDocSect.IPM_Section_Status__c='';
                            projDocSectionList.add(projDocSect);
                        }
                    }
                }
            }
            System.debug('projDocSectionList'+projDocSectionList);
            if(projDocSectionList.size()>0)
            {
                Insert projDocSectionList;
                createOTIFStatus(projDocSectionList);
                System.debug('Calling'+projDocSectionList);
                createGateCheckList();
                createRiskQuestions();
            }
        }
    }
    public void createGateCheckList()
    {   
        List<Id> ProjectIds=new List<Id>();
        for(IPM_Project_Document__c ip:projDocList) 
        {
            ProjectIds.add(ip.IPM_Project__c);
        }    
       // if(projDocList.size()>0)
       // { 
           // for(IPM_Project_Document__c pd: projDocList)
          //  {
              //  gkCheckList.generateGKChecklist(pd.IPM_GateDocuments__c,pd.IPM_Project__c);
           // } 
           System.debug('From Classssssssssss'+ProjectIds);
        IPM_GatekeeperChecklist.generateGKChecklist('Charter',ProjectIds);
       // }              
    }

    public void createRiskQuestions()
    {
        for(IPM_Project_Document__c pd: projDocList)
        {
            IPM_GateDocumentRiskManagement.generatePOSforProject(pd.IPM_Project__c);
        }
    }
    public static void createOTIFStatus(List<IPM_Project_Document_Section__c> projDocSecList)
    {
        List<IPM_Project_Document_Section_Content__c> insertOTIFStatus=new List<IPM_Project_Document_Section_Content__c>();
        List<IPM_OTIF_Status__c> otiFStatus=[Select Name,IPM_Gate_Document_Type__c,OTIF_Help_Text__c,OTIF_HelpText_Red__c,OTIF_HelpText_Green__c,OTIF_HelpText_Amber__c,OTIF_Measure__c,OTIF_No_of_Status__c,OTIF_Responsibility__c,OTIF_Status__c,IPM_Section_Number__c,OTIF_Sequence_Number__c from IPM_OTIF_Status__c where IPM_Gate_Document_Type__c='Charter'];
        
        Map<String,Id>sectionIds=new Map<String,Id>();
        Map<String,String>sectionNames=new Map<String,String>();
        for(IPM_Project_Document_Section__c ips:projDocSecList) 
        {
            sectionIds.put(ips.IPM_Section_Sequence_Number__c,ips.Id);
            sectionNames.put(ips.IPM_Section_Sequence_Number__c,ips.IPM_Section_Name__c);
        }
        System.debug(sectionIds+'Id map'+sectionNames+'name map'+projDocSecList+'projDocSecList');
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
    public void updateSections(List<IPM_Project__c> projectList,Set<Id> bosscardId)
    {
        Map<Id,String> projectTemplatesMap=new Map<Id,String>();
        Map<Id,IPM_Bosscard__c> bosscardMap=new Map<Id,IPM_Bosscard__c>();
        Set<Id> projectTemplatesId=new Set<Id>();
        Set<Id> projId=new Set<Id>();
        if(projectList.size()>0)
        {
            for(IPM_Project_Template__c temp:[Select Id,IPM_Template_Complexity__c from IPM_Project_Template__c])
            {
                for(Integer i=0;i<projectList.size();i++)
                {
                    if(temp.IPM_Template_Complexity__c==projectList[i].IPM_Complexity__c)
                    {
                        projectTemplatesMap.put(temp.Id,projectList[i].Id);
                        projectTemplatesId.add(temp.Id);
                        projId.add(projectList[i].Id);
                    }

                }
            }
            System.debug('Template Picked');
            if(bosscardId.size()>0)
            {
                for(IPM_Bosscard__c boss:[Select Id,IPM_Consumer_Need__c,IPM_Sustainibility__c,IPM_Background__c,IPM_Bosscard_Approver_Comments__c from IPM_Bosscard__c where Id In: bosscardId])
                {
                    for(Integer i=0;i<projectList.size();i++)
                    {
                        if(projectList[i].IPM_Bosscard__c==boss.Id)
                        {
                            bosscardMap.put(projectList[i].IPM_Bosscard__c,boss);
                        }
                    }
                }
            }
            System.debug('projectTemplatesMap'+projectTemplatesMap);
            System.debug('projectTemplatesId'+projectTemplatesId);
            List<IPM_Project_Document__c> projDocList=new List<IPM_Project_Document__c>();
            Set<Id> docTempId=new Set<Id>();
            Set<Id> projDocId=new Set<Id>();
            Map<Id,String> docTempMap=new Map<Id,String>();
            projDocList=[Select Id,IPM_Project__c,IPM_Project_Template__c,IPM_GateDocuments__c,IPM_Document_Status__c from IPM_Project_Document__c where IPM_Project__c In:projId];
            for(IPM_Document_Template__c docTemp:[Select Id,IPM_Project_Template__c,IPM_Document_Type__c from IPM_Document_Template__c where IPM_Project_Template__c In: projectTemplatesId and IPM_Document_Type__c='Charter'])
            {
                for(Integer i=0;i<projDocList.size();i++)
                {
                    if(projDocList[i].IPM_Project__c==projectTemplatesMap.get(docTemp.IPM_Project_Template__c))
                    {
                        projDocList[i].IPM_Project_Template__c=docTemp.IPM_Project_Template__c;
                        projDocList[i].IPM_GateDocuments__c=docTemp.IPM_Document_Type__c;
                        projDocList[i].IPM_Document_Status__c='Not Started';
                        docTempId.add(docTemp.Id);  
                        projDocId.add(projDocList[i].Id);
                        docTempMap.put(projDocList[i].IPM_Project_Template__c,docTemp.Id);                    
                    }
                }
                
            }
            Update projDocList;
            System.debug('docTempId'+docTempId);
            System.debug('docTempMap'+docTempMap);
            System.debug('projDocList'+projDocList);
            List<IPM_Section__c> secList=[Select Id,IPM_Section_Name__c,IPM_Negotiable__c,IPM_Document_Template__c,IPM_FunctionalRole__c,IPM_Section_Help_Text__c,IPM_Section_Type__c,IPM_Section_Sequence__c from IPM_Section__c where IPM_Document_Template__c  In:docTempId];
            System.debug('secList'+secList);
            List<IPM_Project_Document_Section__c> projDocSectionList=new List<IPM_Project_Document_Section__c>();
            projDocSectionList=[Select Id,IPM_Project_Document__c,IPM_Section_Sequence__c,IPM_Section_Name__c,IPM_Section__c,IPM_Section_Status__c,IPM_FunctionalRole__c,IPM_Section_Help_Text_Long__c,IPM_Negotiable__c,IPM_Default_Section__c,IPM_Gate_Document_Summary__c,IPM_Section_Type__c from IPM_Project_Document_Section__c where IPM_Project_Document__c In:projDocId];
            for(IPM_Project__c proj:projectList)
            {
                for(IPM_Project_Document__c projDocs:projDocList)
                {
                    for(IPM_Section__c sect:secList)
                    {
                        if(docTempMap.get(projDocs.IPM_Project_Template__c)==sect.IPM_Document_Template__c)
                        {
                            for(Integer i=0;i<projDocSectionList.size();i++)
                            {
                                if(projDocSectionList[i].IPM_Project_Document__c==projDocs.Id && projDocSectionList[i].IPM_Section_Sequence__c==sect.IPM_Section_Sequence__c )
                                {
                                    projDocSectionList[i].IPM_Section__c=sect.Id;
                                    projDocSectionList[i].IPM_Section_Status__c='Not Started';
                                    projDocSectionList[i].IPM_FunctionalRole__c=sect.IPM_FunctionalRole__c;
                                    projDocSectionList[i].IPM_Section_Help_Text_Long__c=sect.IPM_Section_Help_Text__c;
                                    projDocSectionList[i].IPM_Negotiable__c=sect.IPM_Negotiable__c;
                                    System.debug('Complexity'+proj.IPM_Complexity__c+'Negotiable'+sect.IPM_Negotiable__c);
                                    if(proj.IPM_Complexity__c=='Full')
                                    projDocSectionList[i].IPM_Default_Section__c=true;
                                    else if(proj.IPM_Complexity__c=='Lite' && sect.IPM_Negotiable__c==false)
                                    projDocSectionList[i].IPM_Default_Section__c=true; 
                                    
                                    if(proj.IPM_Bosscard__c!=null) 
                                    {
                                        System.debug('proj.IPM_Bosscard__c'+proj.IPM_Bosscard__c);
                                        System.debug('bosscardMap'+bosscardMap);
                                        if(bosscardMap.get(proj.IPM_Bosscard__c).IPM_Consumer_Need__c!=null  && projDocSectionList[i].IPM_Section_Name__c=='Consumer Need')
                                        {
                                            projDocSectionList[i].IPM_Gate_Document_Summary__c=bosscardMap.get(proj.IPM_Bosscard__c).IPM_Consumer_Need__c;
                                            projDocSectionList[i].IPM_Section_Status__c='Filled-in';
                                        }
                                        if(bosscardMap.get(proj.IPM_Bosscard__c).IPM_Sustainibility__c!=null  && projDocSectionList[i].IPM_Section_Name__c=='Environmental Impact')
                                        {
                                            projDocSectionList[i].IPM_Gate_Document_Summary__c=bosscardMap.get(proj.IPM_Bosscard__c).IPM_Sustainibility__c;
                                            projDocSectionList[i].IPM_Section_Status__c='Filled-in';
                                        }
                                        if(bosscardMap.get(proj.IPM_Bosscard__c).IPM_Background__c!=null  && projDocSectionList[i].IPM_Section_Name__c=='Strategic Fit')
                                        {
                                            projDocSectionList[i].IPM_Gate_Document_Summary__c=bosscardMap.get(proj.IPM_Bosscard__c).IPM_Background__c;
                                            projDocSectionList[i].IPM_Section_Status__c='Filled-in';
                                        }
                                        if(bosscardMap.get(proj.IPM_Bosscard__c).IPM_Bosscard_Approver_Comments__c!=null  && projDocSectionList[i].IPM_Section_Name__c=='Feedback from BOSSCARD')
                                        {
                                            projDocSectionList[i].IPM_Gate_Document_Summary__c=bosscardMap.get(proj.IPM_Bosscard__c).IPM_Bosscard_Approver_Comments__c;
                                            projDocSectionList[i].IPM_Section_Status__c='Filled-in';
                                        }
                                    }
                                    if(sect.IPM_Section_Type__c=='Header' || sect.IPM_Section_Type__c=='Sub Header')
                                    projDocSectionList[i].IPM_Section_Status__c='';
                                }
                            }
                            
                        }
                    }
                }
            }
            System.debug('projDocSectionList'+projDocSectionList);
            Update projDocSectionList;
        }
    }
    /*
    Creating Country Feedback Sections for the Local Projects to View in Regional and Global Level Contract Documents
    */
    public static void createCountryFeedbackSections(Set<Id> projIds,String gateModel)
    {
        List<IPM_Project__c> localProjects=[Select Id,IPM_Project_Name__c,IPM_Complexity__c,IPM_Parent_Project__c,IPM_Parent_Project__r.IPM_Parent_Project__c from IPM_Project__c where IPM_Parent_Project__c In:projIds];
        List<IPM_Project_Document__c> regionalProjDocs=[Select Id,IPM_Project__c,IPM_GateDocuments__c from IPM_Project_Document__c where IPM_GateDocuments__c='Contract' and IPM_Project__c In:projIds];
        if(gateModel=='GCLT & RCLT')
        {
            Set<Id> globalprojIds=new Set<Id>();
            List<IPM_Project__c> regionalProj=[Select Id,IPM_Project_Name__c,IPM_Parent_Project__c,IPM_Phase__c from IPM_Project__c where IPM_Phase__c='Feasibility' and Id In:projIds];
            for(IPM_Project__c rpo:regionalProj)
            {
                globalprojIds.add(rpo.Id);
            }
            List<IPM_Project_Document__c> globalProjDocs=[Select Id,IPM_Project__c,IPM_GateDocuments__c from IPM_Project_Document__c where IPM_GateDocuments__c='Contract' and IPM_Project__c In:globalprojIds];
            regionalProjDocs.addAll(globalProjDocs);
        }   
        Integer i=0;
        List<IPM_Project_Document_Section__c> lstProjDocSections=new List<IPM_Project_Document_Section__c>();
        for(IPM_Project_Document__c rpDoc:regionalProjDocs)
        {   
            i=1;
            for(IPM_Project__c lp:localProjects)
            {
                if((lp.IPM_Parent_Project__c==rpDoc.IPM_Project__c && gateModel=='RCLT')||(gateModel=='GCLT & RCLT' && lp.IPM_Parent_Project__r.IPM_Parent_Project__c==rpDoc.IPM_Project__c )||(gateModel=='GCLT & RCLT' && lp.IPM_Parent_Project__c==rpDoc.IPM_Project__c ))
                {
                    IPM_Project_Document_Section__c projDocSect=new IPM_Project_Document_Section__c();
                    projDocSect.IPM_Project_Document__c=rpDoc.Id;
                    projDocSect.IPM_Section_Name__c=lp.IPM_Project_Name__c;
                    projDocSect.IPM_Section_Status__c='Not Started';
                    projDocSect.IPM_FunctionalRole__c='BB';
                    projDocSect.IPM_Section_Sequence_Number__c='7.2.'+i;
                    projDocSect.IPM_Negotiable__c=true;
                    if(lp.IPM_Complexity__c=='Full')
                    projDocSect.IPM_Default_Section__c=true;
                    lstProjDocSections.add(projDocSect);    
                }
            }
        }
        if(lstProjDocSections.size()>0)
        Insert lstProjDocSections;
    }
}