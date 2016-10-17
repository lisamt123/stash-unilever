public with sharing class BFM_SESSearch_CC {
public BFM_SES__c ses{get;set;}
public List<BFM_SES__c> sesList {get;set;}
List<string> conditions = new List<string>();
private integer totalRecs = 0;
private integer OffsetSize = 0;
private integer LimitSize= 10;

public BFM_SESSearch_CC(){
 ses = new BFM_SES__c();
}

public void searchses(){
totalRecs = 0;
OffsetSize = 0;
if(sesList !=null && sesList.size()>0){
 sesList=null;
}
searchsess();
conditions.clear();
}


public Void searchsess(){
if(sesList != null && !sesList.isEmpty()){
  sesList.clear();
}
 String strQuery ='SELECT id, name,CT_E__c,SES_Number__c,NFS__c from BFM_SES__c';
 if(ses.Name !=null && ses.Name !=''){
   conditions.add('Name Like \'%' +ses.Name +'%\' ');
 }
  if(ses.SES_Number__c !=null && ses.SES_Number__c !=''){
   conditions.add('SES_Number__c Like\'%' +ses.SES_Number__c +'%\' ');
 }

  if (conditions.size() > 0) {
   strQuery += '  WHERE ' + conditions[0];
   for (Integer i = 1; i < conditions.size(); i++)
            strQuery += '  AND ' + conditions[i];
  }
 if(totalRecs !=null && totalRecs ==0){
    List<BFM_SES__c> seTemp = Database.query(strQuery);
    totalRecs = (seTemp !=null &&seTemp.size()>0)?seTemp.size():0;
 }

 system.debug('strQuery ==>'+strQuery );
 // add sort and limits at the end  
  strQuery += ' ORDER BY Name  ASC LIMIT :LimitSize OFFSET :OffsetSize';
  
  sesList  =Database.query(strQuery);
}

public void FirstPage()
{
OffsetSize = 0;
searchsess();
}
public void previous()
{
OffsetSize = (OffsetSize-LimitSize);
searchsess();
}
public void next()
{
OffsetSize = OffsetSize + LimitSize;
searchsess();
}
public void LastPage()
{
OffsetSize = totalrecs - math.mod(totalRecs,LimitSize);
searchsess();
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