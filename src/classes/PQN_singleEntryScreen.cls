public without sharing class PQN_singleEntryScreen{
    public PQN_Pallet_Quality_Non_Conformance__c pqn{get; set;}
    public PQN_Supplier__c sup{get;set;}
    // public PQN_DC_Volumes__c dcv{get;set;}
    public boolean immediate{get; set;}
//    public boolean readMode {get;set;}
    public boolean freezePeriodFlag {get;set;}
    public boolean immediatevalidate{get; set;}
    public List<selectoption> reportingdc{get;set;}
    public boolean showsingleedit{set; get;}
//    public Long dayLeft {get;set;}
    Id pqnId;
    integer err=0;
    Map<string,PQN_DC_Hierarchy__c> mapdcdata = new Map<string,PQN_DC_Hierarchy__c>();
    
    public PQN_singleEntryScreen(ApexPages.StandardController controller){
        immediate=true;
        immediatevalidate = true;
        freezePeriodFlag = true;
        showsingleedit = true;
        
        pqn = new PQN_Pallet_Quality_Non_Conformance__c();

        reportingdc = new List<selectoption>();
        pqnId = Apexpages.currentpage().getparameters().get('id');
        string firstdc='';
        Map<string,PQN_DC_Hierarchy__c> mapmasterdata = new Map<string,PQN_DC_Hierarchy__c>();
        if(pqnId!=null){
            pqn = [select id,Reporting_DC__c,Region__c,DC_Country__c,MCO__c,Cluster__c,Sub_Cluster__c, Delivery_Note_Number__c,Description__c,
                    Product_Name__c,Product_Group__c,Product_Category__c,SKU__c,Supplier_type__c,Supplier__c,Supplier_Number__c,Non_compliance_reason_code__c,
                    Number_of_Pallets_Per_SKU_Non_Compliant__c,Date_Pallet_Received__c,Comments__c,Days_Left_Before_Freeze__c 
                    from PQN_Pallet_Quality_Non_Conformance__c where id=: pqnId];    
        
        if(userinfo.getusertype() == 'Standard'){
            List<PermissionSetAssignment> PermissionSetAssigs = new List<PermissionSetAssignment>();
            PermissionSetAssigs = [select id,PermissionSet.name,Assignee.country from PermissionSetAssignment where AssigneeId =: userinfo.getuserid()];
            for(PermissionSetAssignment psa: PermissionSetAssigs){
                if(psa.PermissionSet.name == 'PQN_Internal_User' && psa.Assignee.country != pqn.DC_Country__c){
                   // showsingleedit = false;
                   system.debug('enter');
                }
            }
        }
        
        }
        else{
            if(userinfo.getusertype() == 'PowerPartner'){
                List<PQN_User_Creation_Request__c> listpr = new List<PQN_User_Creation_Request__c>();
                listpr = [select id,user__c,user__r.contactid,user__r.contact.account.name,User_Type__c,Sub_Cluster__c,Region__c,MCO__c,DC_Country__c,
                            Cluster__c,(SELECT Account__c,Account__r.name FROM PQN_User_Account_Requests__r ORDER by Account__r.name) from PQN_User_Creation_Request__c where user__c =: userinfo.getuserid() ];
            
                if(!listpr.isEmpty()){
                    PQN_User_Creation_Request__c p = new PQN_User_Creation_Request__c();
                    p = listpr[0];
                    //pqn.Reporting_DC__c = p.
                    pqn.Region__c = p.Region__c;
                    pqn.Cluster__c = p.Cluster__c;
                    pqn.Sub_Cluster__c = p.Sub_Cluster__c;
                    pqn.MCO__c= p.MCO__c;
                    pqn.DC_Country__c= p.DC_Country__c;
                    
                    for(PQN_User_Account_Request__c pu: p.PQN_User_Account_Requests__r){
                        reportingdc.add(new selectoption(pu.Account__r.name,pu.Account__r.name));
                    }
                    
                }
            }
            
            if(userinfo.getusertype() == 'Standard'){
                user u = [select id,country from user where id=:userinfo.getuserid()];
                List<Account> listac = new List<Account>();
                //if(u.country!=null){
                    listac = [select id,name,billingcountry,pqn_country__c from Account where pqn_country__c!=null order by Name];
               // }
                if(!listac.isEmpty()){
                    for(Account a:listac){
                        reportingdc.add(new selectoption(a.name,a.name));
                        if(firstdc == ''){
                            firstdc = a.name;
                        }
                    }
                }
            }
        }
        
        
        
        mapmasterdata = PQN_DC_Hierarchy__c.getAll();
        for(PQN_DC_Hierarchy__c dc: mapmasterdata.values()){
            mapdcdata.put(dc.dc__c,dc);             
        }
        if(pqnId==null && userinfo.getusertype() == 'Standard' && reportingdc.size()>0 && firstdc!='' && mapdcdata.containskey(firstdc)){
            
            pqn.Region__c = mapdcdata.get(firstdc).region__c;
            pqn.DC_Country__c = mapdcdata.get(firstdc).country__c;
            pqn.Cluster__c = mapdcdata.get(firstdc).cluster__c;
            pqn.Sub_Cluster__c = mapdcdata.get(firstdc).sub_cluster__c;                 
            pqn.MCO__c = mapdcdata.get(firstdc).mco__c;
            
        }
        
        
    }
    
    public void callRepDC(){
        String repDC= ApexPages.currentPage().getParameters().get('repDC');
        system.debug('sssssssssss'+mapdcdata.get(repDC));
        if(mapdcdata.containskey(repDC) && mapdcdata.get(repDC)!=null){
            pqn.Region__c = mapdcdata.get(repDC).region__c;
            pqn.DC_Country__c = mapdcdata.get(repDC).country__c;
            pqn.Cluster__c = mapdcdata.get(repDC).cluster__c;
            pqn.Sub_Cluster__c = mapdcdata.get(repDC).sub_cluster__c;                 
            pqn.MCO__c = mapdcdata.get(repDC).mco__c;
        }
      /*  if(repDC=='3512 - Jacksonville, FL DC'){
        
            pqn.Region__c ='Americas';
            pqn.DC_Country__c ='United States';
            pqn.Cluster__c = 'North America';
            pqn.Sub_Cluster__c = 'North America';                 
            pqn.MCO__c = 'North America';
            
        
        }
        if(repDC=='Bornem DC'){
        
            pqn.Region__c ='Europe';
            pqn.DC_Country__c ='Netherlands';
            pqn.Cluster__c = 'Europe';
            pqn.Sub_Cluster__c = 'BeNeFra';                 
            pqn.MCO__c = 'Benelux';
            
        
        }
        if(repDC=='Rentis DC'){
        
            pqn.Region__c ='Europe';
            pqn.DC_Country__c ='Greece';
            pqn.Cluster__c = 'Europe';
            pqn.Sub_Cluster__c = 'South Europe';                 
            pqn.MCO__c = 'Greece';
            
        
        }*/
        
    
    }

//freeze period function starts here
    Public  pageReference checkFreezePeriod(){
        try{        
            if(ApexPages.currentPage().getParameters().get('Id') != NULL){
            system.debug('the page id is' + ApexPages.currentPage().getParameters().get('Id'));

                //get the user profile Id and fetch the profile name                
                Id pId = userinfo.getProfileId();
                List<profile> profileList  = [select Name from Profile where Id =: pId LIMIT 1];
                if(profileList[0].Name == 'System Administrator'){
            
                    // if not Admin then restrict user from editing the freezed records                 
                    system.debug('Entered the method');
                    
                    //get the page Id and get the created month of the record
                    Id pageId = ApexPages.currentPage().getParameters().get('Id');
                    List<PQN_Pallet_Quality_Non_Conformance__c> pqnListResult = [select Name , CreatedDate, Date_Pallet_Received__c from PQN_Pallet_Quality_Non_Conformance__c where Id =: pageId LIMIT 1];
                    List<PQNFreezeDate__c> freezePeriod = [select Id, Freeze_Date__c from PQNFreezeDate__c where Numeric_Value__c =: pqnListResult[0].Date_Pallet_Received__c.month()];
                 //   dayLeft  =  system.Today().daysBetween(freezePeriod[0].Freeze_Date__c);
                    if (freezePeriod[0].Freeze_Date__c < system.Today()){
                            system.debug('Freeze Date crossed pls check');
                            ApexPages.Message myFreezeMessage = new ApexPages.Message(ApexPages.Severity.INFO,'You have crossed the freeze period');
                            ApexPages.addMessage(myFreezeMessage);
                            freezePeriodFlag = false;
    //                      readMode = true;
                            return null;
                        }
                        
                }
                
            }
            
        }catch(Exception e){
            system.debug('an exception occured in freeze period function');
        }
        return null;
     
    }
    
//freeze period function ends here


    
    
    
    
    public void validate(){
    
        String skuName =Apexpages.currentPage().getParameters().get('skuName');
       String suppName =Apexpages.currentPage().getParameters().get('suppName');
       String losName =Apexpages.currentPage().getParameters().get('losName');
       validateIte(skuName,suppName,losName);
        //return null;
    }
    public void validateIte(String skuName,String suppName,String losName){
        try{ 
                err=0;              
               system.debug(losName+'********');
               if(skuName.length()>0){
                   List<PQN_Pallet_Quality_Non_Conformance__c > xPQNCList= [select id,Product_Category__c,Product_Name__c,Product_Group__c,SKU__c from PQN_Pallet_Quality_Non_Conformance__c where SKU__c=:skuName Limit 1];
                   if(xPQNCList.size()>0){
                       for(PQN_Pallet_Quality_Non_Conformance__c  xP: xPQNCList){
                       
                           pqn.Product_Category__c = xP.Product_Category__c;
                           pqn.Product_Name__c = xP.Product_Name__c ;
                           pqn.Product_Group__c = xP.Product_Group__c;
                           //immediate=false;
                       }
                   }else{
                       pqn.Product_Category__c = '';
                       pqn.Product_Name__c = '' ;
                       pqn.Product_Group__c = '';
                       ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'No Product Found.');
                       ApexPages.addMessage(myMsg);
                       err++;
                   }
                   
               }else{
                   ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'SKU is null.');
                   ApexPages.addMessage(myMsg);
               }
              List<PQN_Supplier__c> PQNList_Sup= new List<PQN_Supplier__c>();
              system.debug('sssssssssss'+pqn.Supplier__c);
              if(suppName!=null && suppName!=''){
               PQNList_Sup= [select id,Name,Supplier_type__c,Supplier_Number__c  from PQN_Supplier__c where Name=:suppName limit 1];
                if(PQNList_Sup.isempty()){   
                  pqn.Supplier_Number__c = '';
                    pqn.Supplier_type__c = '';            
                   ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,'Supplier is not found.');
                   ApexPages.addMessage(myMsg1);  
                   err++;                 
                }
                else{
                    pqn.Supplier_Number__c = string.valueof(PQNList_Sup[0].Supplier_Number__c);
                    pqn.Supplier_type__c = PQNList_Sup[0].Supplier_type__c;
                    immediatevalidate = true;
                }
                }
                
                Map<string,PQN_Pallet_Loss_Tree__c> lossCodes = PQN_Pallet_Loss_Tree__c.getAll();
                Map<integer,PQN_Pallet_Loss_Tree__c> maplosses = new Map<integer,PQN_Pallet_Loss_Tree__c>();
                set<integer> setlosscodes = new set<integer>();
                for(PQN_Pallet_Loss_Tree__c p: lossCodes.values()){
                    setlosscodes.add(integer.valueof(p.Loss_Code__c)); 
                    system.debug(setlosscodes);   
                    maplosses.put(integer.valueof(p.Loss_Code__c),p);
                }
                if (!setlosscodes.contains(integer.valueof(losName)))
                {
                   ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,'LossCode is not found.');
                   ApexPages.addMessage(myMsg1);
                   err++;
                }
                if(losName!=null && maplosses.containskey(integer.valueof(losName))){
                pqn.Loss_Level_2__c= maplosses.get(integer.valueof(losName)).Loss_L2__c;
                pqn.loss_level_3__c = maplosses.get(integer.valueof(losName)).Loss_L3__c;
                pqn.loss_level_4__c = maplosses.get(integer.valueof(losName)).Loss_L4__c;
                }
                
                   
       }
        catch(Exception e){
            
        }
    }
    public void Target_update(){
    try{
    List<PQN_Targets__c> listtar=new List<PQN_Targets__c>();
    listtar=[select id,Target_Reduction__c,Target__c,Region__c,Year__c,Month__c from PQN_Targets__c where 
               Year__c=:string.valueof(pqn.Date_Pallet_Received__c.year()) AND  Region__c=:pqn.Region__c limit 1];
     
  
     if(listtar.size()>0){
       system.debug('aaa'+listtar[0]);
        pqn.Targets__c= listtar[0].id;
        pqn.Target_Reduction__c=listtar[0].Target_Reduction__c;
    
    }
    }
    catch(Exception e){
            
        }
    
    
    }
     public void DC_Vol_update(){
    try{
    List<PQN_DC_Volumes__c> listdcv=new List<PQN_DC_Volumes__c>();
    listdcv=[select id,Total_Pallets_Checked_By_DC__c,Total_Pallets_received_by_DC__c,Reporting_DC__c,year__c,month__c from PQN_DC_Volumes__c where 
              year__c=:string.valueof(pqn.Date_Pallet_Received__c.year()) and month__c =:string.valueof(pqn.Date_Pallet_Received__c.month()) and Reporting_DC__c=:pqn.Reporting_DC__c limit 1];
  system.debug('DC year'+listdcv[0].Year__c+pqn.Year__c);
  system.debug('DC Month'+listdcv[0].month__c+pqn.Month__c);
  
  system.debug('ddd'+listdcv[0]);
   if(listdcv.size()>0){
   system.debug('Rep DC'+listdcv[0].Reporting_DC__c+pqn.Reporting_DC__c);
  //system.debug(listdcv[0]);
  system.debug( listdcv[0].id);
    pqn.DC_Volumes__c = listdcv[0].id;
    pqn.Total_pallets_received_by_DC__c=listdcv[0].Total_Pallets_received_by_DC__c;
    
    }
    }
    catch(Exception e){
            
        }
    
    
    }
    public pagereference savePQN(){
    
           
     validateIte(pqn.SKU__c,pqn.Supplier__c,string.valueof(pqn.Non_compliance_reason_code__c));
     if(pqn.id==null){
     DC_Vol_update();
     Target_update();
       assignAccount(); 
       }
        
        try{
            if(pqn!=null && err==0){
                
               
   
                String clone = apexpages.currentpage().getparameters().get('clone');
                if (clone == '1'){
                    PQN_Pallet_Quality_Non_Conformance__c pqn1 = new PQN_Pallet_Quality_Non_Conformance__c();
                    pqn1 = pqn;
                    pqn1.Id = null;
                    Insert pqn1;
                }else{
                // adding the value to Days Left : rajesh
                 //   pqn.Days_Left_Before_Freeze__c = dayLeft;
                    upsert pqn;
                }
              
                //PageReference redirectPage = new PageReference('/'+pqn.id);
                PageReference redirectPage = page.PQN_Conformance_Detail_VF;
                redirectPage.setRedirect(true);
                redirectPage.getParameters().put('id',pqn.id);
                return redirectPage;
            }
        }
        catch(Exception e){
            ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,e.getmessage());
            ApexPages.addMessage(myMsg1);
        }
        return null;
    }
    
    
    public pagereference cancelPQN(){
        if(pqn.id==null){
            PageReference pqnhomePage = page.PQN_home;
            pqnhomePage.setRedirect(true);        
            return pqnhomePage;
        } 
        else{
            PageReference recordPage = page.PQN_Conformance_Detail_VF;
            recordPage.setRedirect(true);   
            recordPage.getParameters().put('id',pqn.id);     
            return recordPage;
        } 
        
        return null;
          
    }
    public void assignAccount(){
        if(userinfo.getusertype() == 'PowerPartner'){
            user u = [select id,contactid,contact.accountid from user where id=:userinfo.getuserid()];
            if(u.contact.accountid!=null){
                pqn.account__c = u.contact.accountid;
            }
            else{
                ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,'Reporting DC not found in Master Data. Please contact Administrator');
                ApexPages.addMessage(myMsg1);
                err++;
            }
        }
        if(userinfo.getusertype() == 'Standard'){
            List<Account> listacc = new List<Account>();
            listacc = [select id,name from account where name=:pqn.reporting_dc__c];
            if(!listacc.isEmpty()){
                pqn.account__c = listacc[0].id;    
            }
            else{
                ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,'Reporting DC not found in Master Data. Please contact Administrator');
                ApexPages.addMessage(myMsg1);
                err++;
            }
        }
    }
}