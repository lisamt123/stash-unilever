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
 VERSION  AUTHOR                        DATE              DETAIL                    Description    
 1.0      Shreyas Mangalvedhekar        21/12/2015      INITIAL DEVELOPMENT          CSR: 
 ***********************************************************************/

public class CPA_AttchemntUnit {

 /*******************************************************************    
   Purpose:  This static method will return the file type of each attachment                                                            
  Parameters: List of attachment     
  Returns: its return the key value for each attachment with his type    

  ********************************************************************/ 
    
    public static map<id,string> findAttachmentType(List<Attachment> lstAttachment) {
    
        map<id,string> mapAttachmentType = new map<id,string> ();        // Variable declaration  
        
        for(Attachment objAttachment:lstAttachment){
            
            if(objAttachment.ContentType.contains('spreadsheet') || objAttachment.ContentType.contains('ms-excel'))
            {
                mapAttachmentType.put(objAttachment.id,'spreadsheet');
            }else if(objAttachment.ContentType.contains('pdf')){
                mapAttachmentType.put(objAttachment.id,'pdf');
            }else {
                mapAttachmentType.put(objAttachment.id,'unkonwn');
                
            }       
            
        }
        return mapAttachmentType;
        
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
        set<CPA_PWO__c> lstUpdatePWO = new set<CPA_PWO__c>();
        map<Id,CPA_PWO__c> mapPwo = new map<Id,CPA_PWO__c>();
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
       
        for(CPA_PWO__c objPWO :[Select Id,chk_Excel_Attached__c,chk_PDF_Attached__c from CPA_PWO__c where ID IN:setParentId]){
            
            if((objPWO.chk_Excel_Attached__c != true ||  objPWO.chk_PDF_Attached__c!= true) && mapAttachmentIDPWOID.get(objPWO.ID)!= null){
                for(Attachment objAttachment:mapAttachmentIDPWOID.get(objPWO.Id)){
                    if(mapAttachmentType.get(objAttachment.id) == 'spreadsheet'){
                        objPWO.chk_Excel_Attached__c = true;
                            mapPwo.put(objPWO.id,objPWO);
                        
                                            
                    }
                    if(mapAttachmentType.get(objAttachment.id) == 'pdf'){
                        objPWO.chk_PDF_Attached__c =true;
                        mapPwo.put(objPWO.id,objPWO);                       
                        
                    }
                }
            }       
        }
        system.debug('Updaterecords -->' + mapPwo.values());
        
        update mapPwo.values();
        
    }
    
}