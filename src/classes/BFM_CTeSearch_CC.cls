public with sharing class BFM_CTeSearch_CC {
public BFM_CT_e__c cte{get;set;}
public List<BFM_CT_e__c> cteList {get;set;}
// create a list of strings to hold the conditions
List<string> conditions = new List<string>();
private integer totalRecs = 0;
private integer OffsetSize = 0;
private integer LimitSize= 10;

public BFM_CTeSearch_CC(){
 cte = new BFM_CT_e__c();
 //cteList  = new List<BFM_CT_e__c>();
}

public void searchCTe(){
totalRecs = 0;
OffsetSize = 0;
if(cteList !=null && cteList.size()>0){
 cteList=null;
}
searchCTes ();
conditions.clear();
}


public Void searchCTes(){

System.debug('Total Records is ==>'+totalRecs);
System.debug('OffsetSize is ==>'+OffsetSize);

if(cteList != null && !cteList.isEmpty()){
  cteList.clear();
}
 String strQuery ='SELECT id, name,CNPJ_issuer__c,CNPJ_Service_Taker__c,CT_e_key__c,CT_e_Number__c from BFM_CT_e__c';
 if(cte.Name !=null && cte.Name !=''){
   conditions.add('Name Like \'%' +cte.Name +'%\' ');
 }
  if(cte.CT_e_Number__c !=null && cte.CT_e_Number__c !=''){
   conditions.add('CT_e_Number__c Like\'%' +cte.CT_e_Number__c +'%\' ');
 }

  if (conditions.size() > 0) {
   strQuery += '  WHERE ' + conditions[0];
   for (Integer i = 1; i < conditions.size(); i++)
            strQuery += '  AND ' + conditions[i];
  }
 if(totalRecs !=null && totalRecs ==0){
    List<BFM_CT_e__c> ctTemp = Database.query(strQuery);
    totalRecs = (ctTemp !=null &&ctTemp.size()>0)?ctTemp.size():0;
 }

 system.debug('strQuery ==>'+strQuery );
 // add sort and limits at the end  
  strQuery += ' ORDER BY Name  ASC LIMIT :LimitSize OFFSET :OffsetSize';
  
  cteList  =Database.query(strQuery);
  
   

  //conditions.clear();
  //return cteList.size();
}

public void FirstPage()
{
OffsetSize = 0;
searchCTes();
}
public void previous()
{
OffsetSize = (OffsetSize-LimitSize);
searchCTes();
}
public void next()
{
OffsetSize = OffsetSize + LimitSize;
searchCTes();
}
public void LastPage()
{
OffsetSize = totalrecs - math.mod(totalRecs,LimitSize);
searchCTes();
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