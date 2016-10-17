public with sharing class BFM_NFSSearch_CC {
public BFM_NFS__c nfs{get;set;}
public List<BFM_NFS__c> nfsList {get;set;}
List<string> conditions = new List<string>();
private integer totalRecs = 0;
private integer OffsetSize = 0;
private integer LimitSize= 10;

public BFM_NFSSearch_CC(){
 nfs = new BFM_NFS__c();
}

public void searchnfs(){
totalRecs = 0;
OffsetSize = 0;
if(nfsList !=null && nfsList.size()>0){
 nfsList=null;
}
searchnfsrec();
conditions.clear();
}


public Void searchnfsrec(){
if(nfsList != null && !nfsList.isEmpty()){
  nfsList.clear();
}
 String strQuery ='SELECT id, Name,NFS_Number__c,NFS_Status__c,NFS_Emission_Date_Time__c,Tax_Status__c from BFM_NFS__c';
 if(nfs.Name !=null && nfs.Name !=''){
   conditions.add('Name Like \'%' +nfs.Name +'%\' ');
 }
  if(nfs.NFS_Number__c !=null && nfs.NFS_Number__c !=''){
   conditions.add('NFS_Number__c Like\'%' +nfs.NFS_Number__c +'%\' ');
 }

  if (conditions.size() > 0) {
   strQuery += '  WHERE ' + conditions[0];
   for (Integer i = 1; i < conditions.size(); i++)
            strQuery += '  AND ' + conditions[i];
  }
 if(totalRecs !=null && totalRecs ==0){
    List<BFM_NFS__c> nfsTemp = Database.query(strQuery);
    totalRecs = (nfsTemp !=null &&nfsTemp.size()>0)?nfsTemp.size():0;
 }
  strQuery += ' ORDER BY Name  ASC LIMIT :LimitSize OFFSET :OffsetSize';
  
  nfsList  =Database.query(strQuery);
}

public void FirstPage()
{
OffsetSize = 0;
searchnfsrec();
}
public void previous()
{
OffsetSize = (OffsetSize-LimitSize);
searchnfsrec();
}
public void next()
{
OffsetSize = OffsetSize + LimitSize;
searchnfsrec();
}
public void LastPage()
{
OffsetSize = totalrecs - math.mod(totalRecs,LimitSize);
searchnfsrec();
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