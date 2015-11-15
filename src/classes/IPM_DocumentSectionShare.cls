/****************************************************************************************************************** 
* @Author: Cognizant
* @Date:04/01/2015
* @Description: sharing project document section records to respective users
*/
public with sharing class IPM_DocumentSectionShare {
     private static final string CLASS_NAME = 'IPM_DocumentSectionShare';
    /****************************************************************************************************************** 
    * @Description: sharing project document section records to respective users
    * @param:list of new project document section
    */
    public void insertProjectDocSection(list<IPM_Project_Document_Section__c> prodocSectionList){
        /****************************************************************************************************************** 
        * @Description: list of project document section share object
        */
        //List<IPM_Project_Document_Section__Share>ProDocuments=new list<IPM_Project_Document_Section__Share>();
        /****************************************************************************************************************** 
        * @Description: list of company card object
        */
        list<IPM_Company_Card__c>lstCC=new list<IPM_Company_Card__c>();
        /****************************************************************************************************************** 
        * @Description: set of project id
        */
        set<id>ProID=new set<id>();
        /****************************************************************************************************************** 
        * @Description: set of duplicate user id's
        */
        set<id>DupUser=new set<id>();
        /****************************************************************************************************************** 
        * @Description: set of company card id's
        */
        map<id,id>companyIdMap=new map<id,id>();
        for(IPM_Project_Document_Section__c prodoc:prodocSectionList){
            ProID.add(prodoc.IPM_Project_ID__c);
        }
        if(ProID != NULL && !ProID.isEmpty()){
            list<IPM_Project_Resource__c>Resourcetoshare=[SELECT id,IPM_Project_Role_Owner__c,IPM_Project__c,IPM_Role_Type__c,IPM_User__c FROM IPM_Project_Resource__c
                                                          WHERE IPM_Project__c IN:ProID LIMIT 50000] ;
            
            list<IPM_Project__c>prolst=[SELECT IPM_Company_Card__c,IPM_Project_Leader__c,IPM_Technical_Project_Leader__c,
                                        Deputy_Project_Leader__c,IPM_Project_Gatekeeper__c
                                        FROM IPM_Project__c WHERE id IN:ProID limit 1];
            if(prolst != NULL && !prolst.isEmpty()){
                for(IPM_Project__c pid:prolst){
                    companyIdMap.put(pid.id,pid.IPM_Company_Card__c);
                }
                
            }
            if(companyIdMap != NULL && !companyIdMap.isEmpty()){
                lstCC=[SELECT IPM_Business_Partner__c,IPM_Managed_Category__c
                                                FROM IPM_Company_Card__c WHERE id=:companyIdMap.values() limit 50000];                           
            }
            
            /* IPM_Project_Document_Section__Share ProDocShr;
            IPM_Project_Document_Section__Share DPL;
            IPM_Project_Document_Section__Share TPL;
            IPM_Project_Document_Section__Share Gk;
            IPM_Project_Document_Section__Share PL;
            if(Resourcetoshare != NULL && !Resourcetoshare.isEmpty()){
                for(IPM_Project_Document_Section__c docsec:prodocSectionList){
                    
                    for(IPM_Project_Resource__c proRes:Resourcetoshare){
                        if(proRes.IPM_Project__c==docsec.IPM_Project_ID__c){
                            ProDocShr=new IPM_Project_Document_Section__Share();
                            ProDocShr.ParentId=docsec.id;
                            ProDocShr.UserOrGroupid=proRes.IPM_User__c;
                            if(proRes.IPM_Role_Type__c==docsec.IPM_FunctionalRole__c){
                                ProDocShr.AccessLevel=IPM_ConstantUtils.EDIT_ACCESS;
                            }else{
                                ProDocShr.AccessLevel=IPM_ConstantUtils.READ_ACCESS;
                            }
                            ProDocuments.add(ProDocShr);
                            DupUser.add(proRes.IPM_User__c);
                        }   
                    }
                } 
            }  */
            if(prolst != NULL && !prolst.isEmpty()){
                for(IPM_Project_Document_Section__c docsec:prodocSectionList){
                    
                    if(lstCC != NULL && !lstCC.isEmpty()){
                        for(IPM_Company_Card__c cc:lstCC){
                            if(cc.IPM_Business_Partner__c!=null && cc.IPM_Business_Partner__c!=userinfo.getuserid() && companyIdMap.get(docsec.IPM_Project_ID__c)==cc.id){
                               /* IPM_Project_Document_Section__Share docshr=  new IPM_Project_Document_Section__Share();
                                docshr.parentid=docsec.id;
                                docshr.accesslevel=IPM_ConstantUtils.EDIT_ACCESS;
                                docshr.UserOrGroupId=cc.IPM_Business_Partner__c;
                                ProDocuments.add(docshr); */
                            }
                            
                        }
                    }    
                        for(IPM_Project__c pid:prolst){
                            if(pid.id==docsec.IPM_Project_ID__c){
                                if(pid.IPM_Project_Leader__c!=null)
                                    DupUser.add(pid.IPM_Project_Leader__c);
                                if(pid.IPM_Technical_Project_Leader__c!=null)
                                    DupUser.add(pid.IPM_Technical_Project_Leader__c);
                                if(pid.Deputy_Project_Leader__c!=null)
                                    DupUser.add(pid.Deputy_Project_Leader__c);
                                if(pid.IPM_Project_Gatekeeper__c!=null)
                                    DupUser.add(pid.IPM_Project_Gatekeeper__c);
                               /* DPL=new IPM_Project_Document_Section__Share ();
                                TPL=new IPM_Project_Document_Section__Share ();
                                Gk=new IPM_Project_Document_Section__Share ();
                                PL=new IPM_Project_Document_Section__Share ();
                                if(userinfo.getuserid()!=pid.Deputy_Project_Leader__c && pid.Deputy_Project_Leader__c !=null
                                    && pid.Deputy_Project_Leader__c!=pid.IPM_Project_Leader__c){
                                    DPL.ParentId =docsec.id;
                                    DPL.UserOrGroupId=pid.Deputy_Project_Leader__c;
                                    DPL.AccessLevel=IPM_ConstantUtils.EDIT_ACCESS;
                                    ProDocuments.add(DPL);
                                }
                                if(pid.IPM_Project_Gatekeeper__c!=null && pid.Deputy_Project_Leader__c!=pid.IPM_Project_Leader__c 
                                    && userinfo.getuserid()!=pid.IPM_Project_Gatekeeper__c ){
                                    Gk.ParentId =docsec.id;
                                    Gk.UserOrGroupId=pid.IPM_Project_Gatekeeper__c;
                                    Gk.AccessLevel=IPM_ConstantUtils.EDIT_ACCESS;
                                    ProDocuments.add(Gk);
                                }    
                                if(pid.IPM_Technical_Project_Leader__c !=null && pid.IPM_Technical_Project_Leader__c!=pid.IPM_Project_Leader__c){
                                    TPL.ParentId =docsec.id;
                                    TPL.UserOrGroupId=pid.IPM_Technical_Project_Leader__c;
                                    TPL.AccessLevel=IPM_ConstantUtils.EDIT_ACCESS;
                                    ProDocuments.add(TPL);
                                }
                            
                                string PLuser=pid.IPM_Project_Leader__c;
                                if(userinfo.getuserid()!=pid.IPM_Project_Leader__c && PLuser!=null){
                                    PL.ParentId =docsec.id;
                                    PL.UserOrGroupId=PLuser;
                                    PL.AccessLevel=IPM_ConstantUtils.EDIT_ACCESS;
                                    ProDocuments.add(PL);
                                } */
                            }           
                        }
                    }
                    
            } 
            list<IPM_User_Profile__c>lstUProfile=[SELECT IPM_User__c,IPM_User_Category__c,IPM_Company_Card__c,IPM_Work_Level__c 
                                                    FROM IPM_User_Profile__c WHERE IPM_Work_Level__c=:IPM_ConstantUtils.WL_TWO and 
                                                    IPM_Company_Card__c=:companyIdMap.values() and IPM_User__c Not IN:DupUser LIMIT 50000];
            
            for(IPM_Project_Document_Section__c docsec:prodocSectionList){
                for(IPM_Company_Card__c cc:lstCC){
                    for(IPM_User_Profile__c up:lstUProfile){
                        if(cc.IPM_Managed_Category__c.contains(up.IPM_User_Category__c) && up.IPM_User__c!=userinfo.getuserid() && companyIdMap.get(docsec.IPM_Project_ID__c)==cc.id ){
                          /*  IPM_Project_Document_Section__Share docshr=  new IPM_Project_Document_Section__Share();
                            docshr.parentid=docsec.id;
                            docshr.accesslevel=IPM_ConstantUtils.READ_ACCESS;
                            docshr.UserOrGroupId=up.IPM_User__c;
                            ProDocuments.add(docshr); */
                        }
                    }
                }  
            }
          /*  try{
                if(ProDocuments != NULL && !ProDocuments.isEmpty())
                Upsert ProDocuments;  
            }
            catch(exception ex){
                ExceptionLoggingHelper.createErrorLogofIPM(UserInfo.getUserId(),CLASS_NAME,
            				'insertProjectDocSection',ex.getMessage(),ex, 'Error', null, null, null);
            }
            ProDocuments=new list<IPM_Project_Document_Section__Share>();  */
        }
    }
    /****************************************************************************************************************** 
    * @Description: sharing project document section records to respective users
    * @param:map of old project document section
    */
    public void deleteProjectDocSection(map<ID,IPM_Project_Document_Section__c> prodocSectionMap){
        /****************************************************************************************************************** 
        * @Description: list of project document section share object
        */
       // list<IPM_Project_Document_Section__Share>DocsecShrs=new list<IPM_Project_Document_Section__Share>();
        /****************************************************************************************************************** 
        * @Description: set of document section id's
        */
        set<id>docsecid=new set<id>();
        for(IPM_Project_Document_Section__c docs:prodocSectionMap.values()){
            docsecid.add(docs.id);
        }
        /* DocsecShrs=[SELECT id FROM IPM_Project_Document_Section__Share WHERE ParentId IN:docsecid LIMIT 50000];
        try{
            if(DocsecShrs != NULL && !DocsecShrs.isEmpty())
                delete DocsecShrs;
        }
        catch(exception ex){
            ExceptionLoggingHelper.createErrorLogofIPM(UserInfo.getUserId(),CLASS_NAME,
            				'deleteProjectDocSection',ex.getMessage(),ex, 'Error', null, null, null);
        }    */
        
    }
    
}