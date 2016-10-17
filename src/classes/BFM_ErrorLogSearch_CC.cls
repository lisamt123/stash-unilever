public with sharing class BFM_ErrorLogSearch_CC {
public BFM_Error_Log__c errlog{get;set;}
public List<BFM_Error_Log__c> errlogList {get;set;}
List<string> conditions = new List<string>();
private integer totalRecs = 0;
private integer OffsetSize = 0;
private integer LimitSize= 10;

public BFM_ErrorLogSearch_CC(){
 errlog = new BFM_Error_Log__c();
}

public void searcherrorlog(){
totalRecs = 0;
OffsetSize = 0;
if(errlogList !=null && errlogList.size()>0){
 errlogList=null;
}
errorlogsearch();
conditions.clear();
}


public Void errorlogsearch(){
if(errlogList != null && !errlogList.isEmpty()){
  errlogList.clear();
}
 String strQuery ='SELECT Id, Name, Reason__c, BFM_MDF_e__c, BFM_CC_e__c, BFM_CT_e__c, BFM_NF_e__c,BFM_POD__c, BFM_SES__c, BFM_Shipment__c, BFM_Occurrence__c,BFM_NFS__c FROM BFM_Error_Log__c';
 if(errlog.Name !=null && errlog.Name !=''){
   conditions.add('Name Like \'%' +errlog.Name +'%\' ');
   system.debug('---->'+errlog.BFM_MDF_e__c);
 }
  /*if(ses.SES_Number__c !=null && ses.SES_Number__c !=''){
   conditions.add('SES_Number__c Like\'%' +ses.SES_Number__c +'%\' ');
 }*/

  if (conditions.size() > 0) {
   strQuery += '  WHERE ' + conditions[0];
   for (Integer i = 1; i < conditions.size(); i++)
            strQuery += '  AND ' + conditions[i];
  }
 if(totalRecs !=null && totalRecs ==0){
    List<BFM_Error_Log__c> errlogTemp = Database.query(strQuery);
    totalRecs = (errlogTemp !=null &&errlogTemp.size()>0)?errlogTemp.size():0;
 }

  strQuery += ' ORDER BY Name  ASC LIMIT :LimitSize OFFSET :OffsetSize'; 
  errlogList  =Database.query(strQuery);
}

public void FirstPage()
{
OffsetSize = 0;
errorlogsearch();
}
public void previous()
{
OffsetSize = (OffsetSize-LimitSize);
errorlogsearch();
}
public void next()
{
OffsetSize = OffsetSize + LimitSize;
errorlogsearch();
}
public void LastPage()
{
OffsetSize = totalrecs - math.mod(totalRecs,LimitSize);
errorlogsearch();
}
public boolean getprev()
{

if(OffsetSize == 0){

return true;
}
else {

return false;
}
}
public boolean getnxt()
{
if((OffsetSize + LimitSize) > totalRecs){

return true;
}
else {

return false;
}
}
}