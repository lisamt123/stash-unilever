/**********************************************************************  
Name:  CPA_AttchemntUnit ()  Copyright © 2015  Salesforce  
====================================================== 
====================================================== 
Purpose:                                                           
-------   This class is holds the  business logic for CAP [Contracting process Automation] attachment type verification.                                                         
 ====================================================== 
 ====================================================== 
 History                                                             
 -------                                                             
 VERSION  AUTHOR                        DATE              DETAIL                                        Description    
 1.0      Shreyas Mangalvedhekar        21/12/2015      INITIAL DEVELOPMENT                              CSR: 
 1.1      Shreyas Mangalvedhekar        16/03/2015      use of Custom Label                              CSR: 
 1.2      Shreyas Mangalvedhekar        21/03/2015      Varied Target Blend Rate* marked blank           CSR: 
 ***********************************************************************/

public with sharing class CPA_AttachmentUtil {

 /*******************************************************************    
   Purpose:  This static method will return the file type of each attachment                                                            
  Parameters: List of attachment     
  Returns: its return the key value for each attachment with his type    

  ********************************************************************/ 
    
    public static map<id,string> findAttachmentType(List<Attachment> lstAttachment) {
    
        map<id,string> mapAttachmentType = new map<id,string> ();        // Variable declaration  
        
        for(Attachment objAttachment:lstAttachment){
            string srtTemp = objAttachment.ParentId;
            if(objAttachment.Name.startswith(CPA_ConstantsForContractingAppClasses.COMMERCIAL) &&( objAttachment.ContentType.contains(CPA_ConstantsForContractingAppClasses.SPREADSHEET) || objAttachment.ContentType.contains(CPA_ConstantsForContractingAppClasses.MSEXCEL)))
            {
                mapAttachmentType.put(objAttachment.id,CPA_ConstantsForContractingAppClasses.SPREADSHEET);
            }else if(objAttachment.Name.startswith(CPA_ConstantsForContractingAppClasses.PWO) && objAttachment.ContentType.contains(CPA_ConstantsForContractingAppClasses.PDF) && srtTemp.startswith(CPA_ConstantsForContractingAppClasses.CPA_PWO_OBJECT_ID  )){
                mapAttachmentType.put(objAttachment.id,CPA_ConstantsForContractingAppClasses.PDF);
            }else if(objAttachment.Name.startswith(CPA_ConstantsForContractingAppClasses.CR) && objAttachment.ContentType.contains(CPA_ConstantsForContractingAppClasses.PDF) && srtTemp.startswith(CPA_ConstantsForContractingAppClasses.CPA_CR_ID)){
               mapAttachmentType.put(objAttachment.id,CPA_ConstantsForContractingAppClasses.PDF);
            }else {
             mapAttachmentType.put(objAttachment.id,CPA_ConstantsForContractingAppClasses.UNKONWN);
            }
        }
        return mapAttachmentType;
    }
    
    /*******************************************************************    
    Purpose:  This static method will update the respective LOI
    Parameters: List of attachment and set for Parent ID    
    Returns: It’s retunes nothing but it’s update the LOI      
    ********************************************************************/  
    
     public static void updateLOI(List<Attachment> lstAttachment) {
         set<ID>setLOI = new set<Id>();
          for(Attachment objAttachment : lstAttachment){
                setLOI.add(objAttachment.ParentId);
            }
         List<CPA_LOI__c> listLOI = new List<CPA_LOI__c>();
         for(CPA_LOI__c obj : [Select Id,chk_Contract_Attached__c from CPA_LOI__c where id IN:setLOI]){
              obj.chk_Contract_Attached__c = true;
              listLOI.add(obj);
         }
         if(listLOI!=null && listLOI.size()>0){
             update listLOI;
         }
     }
     
     
    /*******************************************************************    
    Purpose:  This static method will update the respective LOI
    Parameters: List of attachment and set for Parent ID    
    Returns: It’s retunes nothing but it’s update the LOI      
    ********************************************************************/  
    public static void DeleteLOI(List<Attachment> lstAttachment) {
         set<ID>setLOI = new set<Id>();
          for(Attachment objAttachment : lstAttachment){
                setLOI.add(objAttachment.ParentId);
            }
         List<CPA_LOI__c> listLOI = new List<CPA_LOI__c>();
         for(CPA_LOI__c obj : [Select Id,chk_Contract_Attached__c from CPA_LOI__c where id IN:setLOI]){
              obj.chk_Contract_Attached__c = false;
              listLOI.add(obj);
         }
         if(listLOI!=null && listLOI.size()>0){
             update listLOI;
         }
    }
    
    
    /*******************************************************************    
  Purpose:  This static method will update the respective CR
  Parameters: List of attachment and set for Parent ID    
  Returns: It’s retunes nothing but it’s update the CR      

  ********************************************************************/  
    
     public static void updateCPACR(List<Attachment> lstAttachment,set<Id>setParentId) {
        
        // Variable declaration section 
        map<id,string> mapAttachmentType = findAttachmentType(lstAttachment);
        map<Id,list<Attachment>> mapAttachmentIDPWOID = new map<Id,list<Attachment>>();
        set<CPA_CR__c> lstUpdateCR = new set<CPA_CR__c>();
        map<Id,CPA_CR__c> mapCR = new map<Id,CPA_CR__c>();
        // Variable declaration section 
        
        for(Id objID : setParentId){
            List<Attachment> lstTempd = new List<Attachment>();
            for(Attachment objAttachment : lstAttachment){
                if(objAttachment.ParentId == objID){
                    lstTempd.add(objAttachment);
                }
            }
            mapAttachmentIDPWOID.put(objID,lstTempd);
        }
       
        for(CPA_CR__c objCR :[Select Id,chk_Contract_Excel_Attached__c,chk_Contract_Attached__c from CPA_CR__c where ID IN:setParentId]){
            
            if((!objCR.chk_Contract_Excel_Attached__c ||  !objCR.chk_Contract_Attached__c) && mapAttachmentIDPWOID.get(objCR.ID)!= null){
                for(Attachment objAttachment:mapAttachmentIDPWOID.get(objCR.Id)){
                    if(mapAttachmentType.get(objAttachment.id) == CPA_ConstantsForContractingAppClasses.SPREADSHEET){
                        objCR.chk_Contract_Excel_Attached__c = true;
                            mapCR.put(objCR.id,objCR);
                    }
                    if(mapAttachmentType.get(objAttachment.id) == CPA_ConstantsForContractingAppClasses.PDF){
                        objCR.chk_Contract_Attached__c =true;
                        mapCR.put(objCR.id,objCR);                       
                    }
                }
            }       
        }
        update mapCR.values();
    }

  /*******************************************************************    
  Purpose:  This static method will update the respective PWO
  Parameters: List of attachment and set for Parent ID    
  Returns: It’s retunes nothing but it’s update the PWO      
  ********************************************************************/  
    public static void updateCPAPWO(List<Attachment> lstAttachment,set<Id>setParentId) {
        
        // Variable declaration section 
        map<id,string> mapAttachmentType = findAttachmentType(lstAttachment);
        map<Id,list<Attachment>> mapAttachmentIDPWOID = new map<Id,list<Attachment>>();
        set<CPA_project_work_order__c> lstUpdatePWO = new set<CPA_project_work_order__c>();
        map<Id,CPA_project_work_order__c> mapPwo = new map<Id,CPA_project_work_order__c>();
        // Variable declaration section 
        
        for(Id objID : setParentId){
            List<Attachment> lstTempd = new List<Attachment>();
            for(Attachment objAttachment : lstAttachment){
                if(objAttachment.ParentId == objID){
                    lstTempd.add(objAttachment);
                }
            }
            mapAttachmentIDPWOID.put(objID,lstTempd);
        }
       
        for(CPA_project_work_order__c objPWO :[Select Id,chk_Excel_Attached__c,chk_PDF_Attached__c from CPA_project_work_order__c where ID IN:setParentId]){
            
            if((!objPWO.chk_Excel_Attached__c ||  !objPWO.chk_PDF_Attached__c) && mapAttachmentIDPWOID.get(objPWO.ID)!= null){
                for(Attachment objAttachment:mapAttachmentIDPWOID.get(objPWO.Id)){
                    if(mapAttachmentType.get(objAttachment.id) == CPA_ConstantsForContractingAppClasses.SPREADSHEET){
                        objPWO.chk_Excel_Attached__c = true;
                            mapPwo.put(objPWO.id,objPWO);
                    }
                    if(mapAttachmentType.get(objAttachment.id) == CPA_ConstantsForContractingAppClasses.PDF){
                        objPWO.chk_PDF_Attached__c =true;
                        mapPwo.put(objPWO.id,objPWO);                       
                    }
                }
            }       
        }
        update mapPwo.values();
    }
    
    /*******************************************************************
    Purpose: This method is used to delete commercials data
    Parameters: lstatt
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static void deleteCommericalData(List<Attachment> lstatt)    {
        List<CPA_Commercial_Details__c >listComDetail = new List<CPA_Commercial_Details__c>();
        set<Id> setPWOID = new set<Id>();
        set<Id> setCRID = new set<Id>();
        
        for(Attachment objAtta : lstatt){
            string srtTemp = objAtta.ParentId;
            if(objAtta.Name.startswith(CPA_ConstantsForContractingAppClasses.COMMERCIAL)) {
                if( srtTemp.startswith(CPA_ConstantsForContractingAppClasses.CPA_PWO_OBJECT_ID )) {
                    setPWOID.add(objAtta.ParentId);
                }   
                else if(srtTemp.startswith(CPA_ConstantsForContractingAppClasses.CPA_CR_ID)){
                    setCRID.add(objAtta.ParentId);
                }
            }
        }
        listComDetail = [Select Id, Name , CR__c,Project_Work_Order__c from CPA_Commercial_Details__c where Project_Work_Order__c IN : setPWOID OR CR__c IN :setCRID];
        List<CPA_project_work_order__c>lstPWO = [Select chk_Excel_Attached__c,ID,num_Expense_charges_of_work_order__c,pec_Expense__c,pec_Estimated_Off_shore__c,pec_Estimated_On_shore__c,Name,num_Estimated_Man_days_of_PWO__c,num_RMS_value__c,num_Estimated_Value_of_PWO__c,num_Target_Blend_Rate__c,num_Total_work_order_charge__c,num_Authorisation_charges__c,num_Effort_Cost__c,num_Authorisation_man_days__c,num_Varied_Target_Blend_Rate__c from CPA_project_work_order__c where ID IN :setPWOID];
        List<CPA_CR__c> lstCR = [Select Id,Name,num_Estimated_Man_days_of_CR__c,num_Estimated_Value_of_CR__c,num_Target_Blend_Rate__c,num_Total_charge_of_CR__c,num_Expense_charges_of_CR__c,pec_Expense__c,num_Authorisation_charges__c,num_Authorisation_man_days__c,num_RMS_value__c,num_Total_Resource_Cost_CR__c,num_Effort_Cost__c,num_Delta_Efforts__c,num_Total_Resource_Efforts_CR__c,num_Total_Expenses_of_CR__c,num_Varied_Target_Blend_Rate__c,pec_Estimated_Off_shore__c,pec_Estimated_On_shore__c  from CPA_CR__c where ID IN:  setCRID];
        List<CPA_project_work_order__c>  lstTemp = new List<CPA_project_work_order__c>();
        List<CPA_CR__c> lstTempCR = new List<CPA_CR__c>();
        
        if(listComDetail!=null && listComDetail.size()>0){
            delete listComDetail;
            for(CPA_project_work_order__c obj :lstPWO ){
                obj.num_Expense_charges_of_work_order__c = NULL;
                obj.pec_Expense__c=NULL;
                obj.pec_Estimated_Off_shore__c=NULL;
                obj.pec_Estimated_On_shore__c=NULL;
                obj.num_Estimated_Man_days_of_PWO__c=NULL;
                obj.num_Estimated_Value_of_PWO__c=NULL;
                obj.num_Target_Blend_Rate__c=NULL;
                obj.num_Total_work_order_charge__c=NULL;
                obj.num_Authorisation_charges__c =NULL;
                obj.num_Authorisation_man_days__c =NULL;
                obj.num_Effort_Cost__c =NULL;
                obj.num_RMS_value__c = NULL;
                obj.num_Varied_Target_Blend_Rate__c = NULL;
                obj.chk_Excel_Attached__c = false;
                
                lstTemp.add(obj);
            }
            for(CPA_CR__c obj1 : lstCR){
                obj1.num_Estimated_Man_days_of_CR__c = NULL;
                obj1.num_Estimated_Man_days_of_CR__c = NULL;
                obj1.num_Estimated_Value_of_CR__c = NULL;
                obj1.num_Target_Blend_Rate__c = NULL;
                obj1.num_Total_charge_of_CR__c = NULL;
                obj1.num_Expense_charges_of_CR__c = NULL;
                obj1.pec_Expense__c = NULL;
                obj1.num_Authorisation_charges__c = NULL;
                obj1.num_Authorisation_man_days__c = NULL;
                obj1.num_RMS_value__c = NULL;
                obj1.chk_Contract_Excel_Attached__c = false;
                obj1.num_Total_Resource_Cost_CR__c =NULL;
                obj1.num_Effort_Cost__c =NULL;
                obj1.num_Delta_Efforts__c = NULL;
                obj1.num_Total_Resource_Efforts_CR__c = NULL;
                obj1.num_Total_Expenses_of_CR__c  = NULL;
                obj1.num_Varied_Target_Blend_Rate__c = NULL;
                obj1.pec_Estimated_Off_shore__c =NULL;
                obj1.pec_Estimated_On_shore__c= NULL;
                lstTempCR.add(obj1);
            }
            if(lstTemp !=null && lstTemp.size()>0){
                update lstTemp;
            }
            if(lstTempCR !=null && lstTempCR.size()>0){
                update lstTempCR;
            }
        }
    }
    /*******************************************************************
    Purpose: This method is used to delete Contracts
    Parameters: lstatt
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static void deleteContract(List<Attachment> lstatt)    {
        List<CPA_Commercial_Details__c >listComDetail = new List<CPA_Commercial_Details__c>();
        set<Id> setPWOID = new set<Id>();
        set<Id> setCRID = new set<Id>();
        List<CPA_project_work_order__c>  lstTemp = new List<CPA_project_work_order__c>();
        List<CPA_CR__c> lstTempCR = new List<CPA_CR__c>();
        
        for(Attachment objAtta : lstatt){
            string srtTemp = objAtta.ParentId;
            if( srtTemp.startswith(CPA_ConstantsForContractingAppClasses.CPA_PWO_OBJECT_ID ) && objAtta.Name.startswith('PWO')) {
                setPWOID.add(objAtta.ParentId);
            }   
            else if(srtTemp.startswith(CPA_ConstantsForContractingAppClasses.CPA_CR_ID) && objAtta.Name.startswith('CR')){
                setCRID.add(objAtta.ParentId);
            }
        }
       
        List<CPA_project_work_order__c>lstPWO = [Select chk_Excel_Attached__c,ID, chk_PDF_Attached__c ,Name from CPA_project_work_order__c where ID IN :setPWOID];
        List<CPA_CR__c> lstCR = [Select Id,Name,chk_Contract_Attached__c,chk_Contract_Excel_Attached__c from CPA_CR__c where ID IN:  setCRID];
        
        for(CPA_CR__c objCR : lstCR){
            objCR.chk_Contract_Attached__c = false;
            lstTempCR.add(objCR);
        }
        for(CPA_project_work_order__c objPWO :lstPWO ){
           objPWO.chk_PDF_Attached__c = false;
           lstTemp.add(objPWO);
        }
              
        if(lstCR!=null && lstCR.size()>0){
            update lstCR;
        }
        if(lstTemp !=null && lstTemp.size()>0){
            update lstTemp;
        }
    }
 
    //public static void ReadFile(List<Attachment> lstatt)    {
    /*******************************************************************
    Purpose: This function reads the CSV file and inserts records into the CPA_Commercial_Details__c object.
    Parameters: att
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
     public static void ReadFile(Attachment att)    {
        //for(Attachment att : lstatt)
        If (att!=null) {
            if(att.ContentType.contains(CPA_ConstantsForContractingAppClasses.MSEXCEL)){              
            string nameFile;
            String[] filelines = new String[]{};
            List<CPA_Commercial_Details__c> PWOupload;
            try{
                    nameFile =att.body.toString();
                    //Now sepatate every row of the excel file
                    filelines = nameFile.split('\n');
                    
                    //Iterate through every line and create a CPA_Commercial_Details__c record for each row
                    PWOupload = new List<CPA_Commercial_Details__c>();
                    
                    for (Integer i=1;i<filelines.size();i++)
                    {
                        String[] inputvalues = new String[]{};
                        
                        inputvalues = filelines[i].split(',');                    
                        CPA_Commercial_Details__c a = new CPA_Commercial_Details__c();
                        if(inputvalues[0].trim() !=  null & inputvalues[0].trim() != ''){
                            a.num_Entity_Type__c =  Integer.valueof(inputvalues[0].trim());
                        }else {
                            a.num_Entity_Type__c = 0;
                        }
                        
                        a.txt_Entity_Name__c = inputvalues[1];       
                        a.txt_Role__c = inputvalues[2];
                        a.txt_Location__c = inputvalues[3];
                        a.txt_Level__c = inputvalues[4];
                        if(inputvalues[5].trim() !=null &inputvalues[5].trim() !=''){
                            a.num_Rate__c =  Integer.valueof(inputvalues[5].trim());
                        }else{
                            a.num_Rate__c =0;
                        }
                        
                        a.txt_Cost_Name__c = inputvalues[6];
                        if(inputvalues[7].trim()!=null & inputvalues[7].trim()!=''){
                            a.num_Year__c =Integer.valueof(inputvalues[7].trim());
                        }else{
                                a.num_Year__c = 0;
                        }
                        
                        a.txt_month__c = inputvalues[8].trim();
                        if(inputvalues[9].trim() != NULL & inputvalues[9].trim()!= ''){
                            a.num_Efforts__c = Integer.valueof(inputvalues[9].trim());
                        }else {
                            a.num_Efforts__c = 0;
                        }
                        
                        if(inputvalues[10].trim() !=null & inputvalues[10].trim()!= ''){
                            a.num_Value__c = Integer.valueof(inputvalues[10].trim());  
                        }else{
                            a.num_Value__c =0;
                        }
                        string srtTemp = att.ParentId;
                        if(srtTemp.startswith(CPA_ConstantsForContractingAppClasses.CPA_PWO_OBJECT_ID )){
                            a.Project_Work_Order__c = att.ParentId;
                        }else if(srtTemp.startswith(CPA_ConstantsForContractingAppClasses.CPA_CR_ID)){
                            a.CR__c = att.ParentId;
                        }
 
                        PWOupload.add(a);
                    }
             }
             catch(Exception e){
                   att.addError('Operation is failed Due to internal error');
             }       
            //Finally, insert the collected records
            try{
                insert PWOupload;
                set<Id> setPWOID = new set<Id>();
                set<Id> setCRID = new set<Id>();
                
                for (CPA_Commercial_Details__c obj :PWOupload ){
                    if(obj.Project_Work_Order__c!=null){
                        setPWOID.add(obj.Project_Work_Order__c);
                    }else if(obj.CR__c!=null){
                        setCRID.add(obj.CR__c);
                    }               
                }
                
                if(setPWOID !=null && setPWOID.size()>0){
                    ReadPWOFile(setPWOID,PWOupload);
                }else if(setCRID !=null && setCRID.size()>0){
                
                    ReadCRFile(setCRID,PWOupload);
                }
                
            }
            catch(Exception e)
            {
                 att.addError('Operation is failed Due to internal error');
            }
        }
    }
     }
     
     
    /*******************************************************************    
    Purpose:  This static method will update the respective PWO With Commercial 
    Parameters: List of attachment of Commercial data  and set for Parent ID    
    Returns: It’s retunes nothing but it’s update the PWO      
    ********************************************************************/  
    public  static void ReadPWOFile(set<Id> setPWOID,List<CPA_Commercial_Details__c> PWOuploadCommerical) {
        
        map<ID,list<CPA_Commercial_Details__c>> mapPWOComDetai = new map<ID,list<CPA_Commercial_Details__c>>();
        List<CPA_project_work_order__c> lstUpdatePWO = new List < CPA_project_work_order__c>();
        
        
        List<CPA_project_work_order__c>lstPWO = [Select ID,num_Expense_charges_of_work_order__c,pec_Expense__c,pec_Estimated_Off_shore__c,pec_Estimated_On_shore__c,Name,num_Estimated_Man_days_of_PWO__c,num_Estimated_Value_of_PWO__c,num_Target_Blend_Rate__c,num_Varied_Target_Blend_Rate__c,num_Total_work_order_charge__c,num_Authorisation_charges__c,num_RMS_value__c,num_Authorisation_man_days__c,num_Effort_Cost__c from CPA_project_work_order__c where ID IN :setPWOID];
        
        if(lstPWO !=null && setPWOID !=null){
            for(CPA_project_work_order__c objPWO : lstPWO){
                List <CPA_Commercial_Details__c>lstTemp = new List<CPA_Commercial_Details__c>();
                for(CPA_Commercial_Details__c obj : PWOuploadCommerical){
                    if(obj.Project_Work_Order__c == objPWO.Id){
                        lstTemp.add(obj);
                    }
                }
                mapPWOComDetai.put(objPWO.Id,lstTemp);
            }
            
            for(CPA_project_work_order__c objPWO : lstPWO){
                Decimal  intTotalmandays = 0;
                //Decimal  intEstimatedValue = 0;
                Decimal  intIndicativeExpenses  = 0;
                Decimal  intNonPayroll   = 0;
                Decimal  intPMOTax = 0;
                Decimal  intContingencyCharges  =0;
                Decimal  intDiscounts = 0;
                Decimal  intAuthorisation = 0;
                Decimal  intAuthorisationman= 0;
                Decimal  intRMS = 0;
                Decimal  intOther = 0;
                Decimal  intCostResource = 0;
                //Decimal  intTotalcost = 0;
                Decimal  intoffshower = 0;
                Decimal  intOnshower = 0;
                Decimal  intNoOfResources = 0;
                for(CPA_Commercial_Details__c objCOm : mapPWOComDetai.get(objPWO.id)){
                    if(objCOm.txt_Entity_Name__c == CPA_ConstantsForContractingAppClasses.RESOURCE || objCOm.num_Entity_Type__c ==1 ){
                        intTotalmandays = intTotalmandays + objCOm.num_Efforts__c;
                        intCostResource = intCostResource + (objCOm.num_Efforts__c * objCOm.num_Rate__c );
                        intNoOfResources = intNoOfResources+1;
                        string strLocation = objCOm.txt_Location__c.trim();
                        strLocation = strLocation.toUpperCase();
                        if(strLocation == CPA_ConstantsForContractingAppClasses.INDIA || strLocation == CPA_ConstantsForContractingAppClasses.PHILIPPINES){
                            intoffshower = intoffshower + 1;
                        }else {
                            intOnshower = intOnshower + 1;
                        }
                        
                    }
                    if(objCOm.txt_Entity_Name__c == CPA_ConstantsForContractingAppClasses.INDICATIVEEXPENSES || objCOm.num_Entity_Type__c ==2){
                        intIndicativeExpenses = intIndicativeExpenses + objCOm.num_Value__c;
                    }
                    if(objCOm.txt_Entity_Name__c == CPA_ConstantsForContractingAppClasses.NONPAYROLL || objCOm.num_Entity_Type__c ==3){
                        intNonPayroll = intNonPayroll +  objCOm.num_Value__c;
                    }
                    if(objCOm.txt_Entity_Name__c == CPA_ConstantsForContractingAppClasses.PMOTAX  || objCOm.num_Entity_Type__c ==4){
                        intPMOTax = intPMOTax +  objCOm.num_Value__c;
                    }
                    if(objCOm.txt_Entity_Name__c == CPA_ConstantsForContractingAppClasses.CONTINGENCYCHARGES || objCOm.num_Entity_Type__c ==5){
                        intContingencyCharges = intContingencyCharges+  objCOm.num_Value__c;
                    }
                    if(objCOm.txt_Entity_Name__c == CPA_ConstantsForContractingAppClasses.DISCOUNTS || objCOm.num_Entity_Type__c ==6){
                        intDiscounts = intDiscounts+  objCOm.num_Value__c;
                    }
                    if(objCOm.txt_Entity_Name__c == CPA_ConstantsForContractingAppClasses.AUTHORISATION || objCOm.num_Entity_Type__c ==8){
                        intAuthorisation = intAuthorisation+ objCOm.num_Value__c;
                        intAuthorisationman = intAuthorisationman + objCOm.num_Efforts__c;
                    }
                    if(objCOm.txt_Entity_Name__c == CPA_ConstantsForContractingAppClasses.RMS || objCOm.num_Entity_Type__c ==9){
                        intRMS = intRMS+objCOm.num_Value__c;
                    }
                    if(objCOm.txt_Entity_Name__c == CPA_ConstantsForContractingAppClasses.OTHERS || objCOm.num_Entity_Type__c ==7){
                        intOther = intOther +  objCOm.num_Value__c;
                    }
                }
                objPWO.num_Estimated_Value_of_PWO__c = (intCostResource  + intContingencyCharges + intNonPayroll +intOther + intIndicativeExpenses + intPMOTax ) - intDiscounts;
                objPWO.num_Estimated_Man_days_of_PWO__c = intTotalmandays;
                if(intTotalmandays> 0){
                    objPWO.num_Varied_Target_Blend_Rate__c = intCostResource / intTotalmandays;
                }else {
                    objPWO.num_Varied_Target_Blend_Rate__c =0;
                }
                objPWO.num_Authorisation_charges__c = intAuthorisation;
                objPWO.num_Authorisation_man_days__c = intAuthorisationman;
                objPWO.num_Expense_charges_of_work_order__c  =intIndicativeExpenses;
                if(intNoOfResources> 0){
                    objPWO.pec_Estimated_Off_shore__c = (intoffshower/intNoOfResources)*100;
                    objPWO.pec_Estimated_On_shore__c = (intOnshower/intNoOfResources)*100;
                }
                if(intCostResource>0){
                    objPWO.pec_Expense__c = (intIndicativeExpenses/intCostResource)*100;
                    objPWO.num_Effort_Cost__c  = intCostResource;
                }else {
                    objPWO.pec_Expense__c = 0;
                }
                objPWO.chk_Excel_Attached__c = true;
                objPWO.num_Total_work_order_charge__c= objPWO.num_Estimated_Value_of_PWO__c;
                objPWO.num_RMS_value__c =intRMS;
                objPWO.num_Effort_Cost__c  = intCostResource;
                lstUpdatePWO.add(objPWO);
            }
        
            if(lstUpdatePWO !=null && lstUpdatePWO.size() > 0){
                update lstUpdatePWO;
            }
        }
        
    }   
/*******************************************************************    
    Purpose:  This static method will update the respective CR With Commercial 
    Parameters: List of attachment of Commercial data  and set for Parent ID    
    Returns: It’s retunes nothing but it’s update the CR      
    ********************************************************************/      
    public  static void ReadCRFile(set<Id> setCRID,List<CPA_Commercial_Details__c> CRuploadCommerical) {
    
        map<ID,list<CPA_Commercial_Details__c>> mapCRComDetai = new map<ID,list<CPA_Commercial_Details__c>>();      
        List<CPA_CR__c> lstUpdateCR = new List < CPA_CR__c>();
        List<CPA_CR__c> lstCR = [Select Id,Name,num_Estimated_Man_days_of_CR__c,num_Estimated_Value_of_CR__c,num_Target_Blend_Rate__c,num_Total_charge_of_CR__c,num_Expense_charges_of_CR__c,pec_Expense__c,num_Authorisation_charges__c,num_Authorisation_man_days__c,num_RMS_value__c,num_Effort_Cost__c,num_Total_Resource_Cost_CR__c ,num_Total_Resource_Efforts_CR__c from CPA_CR__c where ID IN:  setCRID];
        
        if(lstCR !=null && setCRID !=null){
            for(CPA_CR__c objCR : lstCR){
                List <CPA_Commercial_Details__c>lstTemp = new List<CPA_Commercial_Details__c>();
                for(CPA_Commercial_Details__c obj : CRuploadCommerical){
                    if(obj.CR__c == objCR.Id){
                        lstTemp.add(obj);
                    }
                }
                mapCRComDetai.put(objCR.Id,lstTemp);
                 
            }
            for(CPA_CR__c objCR : lstCR){
                Decimal  intTotalmandays = 0;
                //Decimal  intEstimatedValue = 0;
                Decimal  intIndicativeExpenses  = 0;
                Decimal  intNonPayroll   = 0;
                Decimal  intPMOTax = 0;
                Decimal  intContingencyCharges  =0;
                Decimal  intDiscounts = 0;
                Decimal  intAuthorisation = 0;
                Decimal  intAuthorisationman= 0;
                Decimal  intRMS = 0;
                Decimal  intOther = 0;
                Decimal  intCostResource = 0;
                //Decimal  intTotalcost = 0;
                Decimal  intoffshower = 0;
                Decimal  intOnshower = 0;
                Decimal  intNoOfResources = 0;

                for(CPA_Commercial_Details__c objCOm : mapCRComDetai.get(objCR.id)){
               
                    if(objCOm.txt_Entity_Name__c == CPA_ConstantsForContractingAppClasses.RESOURCE || objCOm.num_Entity_Type__c ==1 ){
                        intTotalmandays = intTotalmandays + objCOm.num_Efforts__c;
                        intNoOfResources = intNoOfResources+1;
                        intCostResource = intCostResource + (objCOm.num_Efforts__c * objCOm.num_Rate__c );
                        string strLocation = objCOm.txt_Location__c.trim();
                strLocation = strLocation.toUpperCase();
                
                if(strLocation == CPA_ConstantsForContractingAppClasses.INDIA || strLocation == CPA_ConstantsForContractingAppClasses.PHILIPPINES){
                    intoffshower = intoffshower + 1;
                }else {
                    intOnshower = intOnshower + 1;
                }
                    }
                    
                    if(objCOm.txt_Entity_Name__c == CPA_ConstantsForContractingAppClasses.INDICATIVEEXPENSES || objCOm.num_Entity_Type__c ==2){
                        intIndicativeExpenses = intIndicativeExpenses + objCOm.num_Value__c;
                    }
                    if(objCOm.txt_Entity_Name__c==CPA_ConstantsForContractingAppClasses.NONPAYROLL || objCOm.num_Entity_Type__c ==3){
                        intNonPayroll = intNonPayroll +  objCOm.num_Value__c;
                    }
                    if(objCOm.txt_Entity_Name__c==CPA_ConstantsForContractingAppClasses.PMOTAX  || objCOm.num_Entity_Type__c ==4){
                        intPMOTax = intPMOTax +  objCOm.num_Value__c;
                    }
                    if(objCOm.txt_Entity_Name__c==CPA_ConstantsForContractingAppClasses.CONTINGENCYCHARGES || objCOm.num_Entity_Type__c ==5){
                        intContingencyCharges = intContingencyCharges+  objCOm.num_Value__c;
                    }
                    if(objCOm.txt_Entity_Name__c==CPA_ConstantsForContractingAppClasses.DISCOUNTS || objCOm.num_Entity_Type__c ==6){
                        intDiscounts = intDiscounts+  objCOm.num_Value__c;
                    }
                    if(objCOm.txt_Entity_Name__c==CPA_ConstantsForContractingAppClasses.AUTHORISATION || objCOm.num_Entity_Type__c ==8){
                        intAuthorisation = intAuthorisation+ objCOm.num_Value__c;
                        intAuthorisationman = intAuthorisationman + objCOm.num_Efforts__c;
                    }
                    if(objCOm.txt_Entity_Name__c==CPA_ConstantsForContractingAppClasses.RMS || objCOm.num_Entity_Type__c ==9){
                        intRMS = intRMS+objCOm.num_Value__c;
                    }
                    if(objCOm.txt_Entity_Name__c==CPA_ConstantsForContractingAppClasses.OTHERS || objCOm.num_Entity_Type__c ==7){
                        intOther = intOther +  objCOm.num_Value__c;
                    }
                }
                objCR.num_Estimated_Value_of_CR__c = (intCostResource + intContingencyCharges + intNonPayroll +intOther + intIndicativeExpenses + intPMOTax ) - intDiscounts;
                objCR.num_Estimated_Man_days_of_CR__c = intTotalmandays;
                objCR.num_Total_Resource_Efforts_CR__c = intTotalmandays;
                if(intTotalmandays> 0){
                  objCR.num_Varied_Target_Blend_Rate__c =  intCostResource / intTotalmandays;
                }else {
                    objCR.num_Varied_Target_Blend_Rate__c = 0;
                }
                objCR.num_Authorisation_charges__c = intAuthorisation;
                objCR.num_Authorisation_man_days__c = intAuthorisationman;
                objCR.num_Expense_charges_of_CR__c  =intIndicativeExpenses;
                objCR.num_RMS_value__c  =intRMS;
                if(intCostResource!=null& intCostResource > 0){
                    objCR.pec_Expense__c = (intIndicativeExpenses/ intCostResource)*100;
                    objCR.num_Effort_Cost__c  = intCostResource;
                    objCR.num_Total_Resource_Cost_CR__c = intCostResource;
                }else {
                    objCR.pec_Expense__c = 0;
                }
                if(intNoOfResources> 0){
                    objCR.pec_Estimated_Off_shore__c = (intoffshower/intNoOfResources)*100;
                    objCR.pec_Estimated_On_shore__c = (intOnshower/intNoOfResources)*100;
                }
                lstUpdateCR.add(objCR);
               
            }
            
            if(lstUpdateCR !=null && lstUpdateCR.size() > 0){
                update lstUpdateCR;
                
            }
        }
    }

  
}