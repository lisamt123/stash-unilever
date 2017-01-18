public with sharing class BFM_NFSManualLink_CC{
List<BFM_NFS__c> listNFS{get; set;}
List<BFM_Stage__c> liststages = new List<BFM_Stage__c>();
set<id> setShipmentids = new set<id>();
Map<id,List<BFM_SES__c>> mapShipses = new Map<id,List<BFM_SES__c>>();
public list <NFSwrapper> nfs_list {get; set;}
      // public list<SESwrapper> ses_list {get; set;}
    public BFM_NFSManualLink_CC(ApexPages.StandardController controller){
        listNFS = new List<BFM_NFS__c>();
        nfs_list = new list <NFSwrapper>();
        listNFS = [select id,Shipment__c,NFS_Series__c,NFS_Emission_Date_Time__c,name from BFM_NFS__c where NFS_Link_Check_Status__c ='Pending link' and id=:ApexPages.currentPage().getParameters().get('id')]; 
        for(BFM_NFS__c nfs: listNFS){
            setShipmentids.add(nfs.Shipment__c);
        }
        liststages = [select id,Shipment__c, (select id,name,SES_Number__c,SES_Plant_Code__c,Shipment_Type__c from BFM_SESs__r where NFS__c=null) from BFM_Stage__c where Shipment__c in: setShipmentids];
        for(BFM_Stage__c stg: liststages){
            system.debug('aaaaaaaaaaaaaasssssssssss'+stg.Shipment__c);
            system.debug('aaaaaaaaaaaaaa'+stg.BFM_SESs__r);
            if(!mapShipses.containskey(stg.Shipment__c)){
                mapShipses.put(stg.Shipment__c,stg.BFM_SESs__r);  
            }  
            else{
                List<BFM_SES__c> listShipses = new List<BFM_SES__c>();
                if( mapShipses.get(stg.Shipment__c)!=null){
                listShipses.addAll(mapShipses.get(stg.Shipment__c));
                system.debug('llllllllllllllll'+listShipses);	
                }
                if(!stg.BFM_SESs__r.isEmpty()){
                    listShipses.addAll(stg.BFM_SESs__r);
                    system.debug('rrrrrrrrrrrrrrrrrrr'+listShipses);
                }
                mapShipses.put(stg.Shipment__c,listShipses);
            }
            system.debug('mmm'+mapShipses);
        }
        list<seswrapper> second_list = new list<seswrapper>();
        for(BFM_NFS__c nfs: listNFS){
            second_list.clear(); 
            if(mapShipses.containskey(nfs.Shipment__c) && mapShipses.get(nfs.Shipment__c)!=null){
            for(BFM_SES__c ses:mapShipses.get(nfs.Shipment__c)){
                seswrapper s = new seswrapper(ses);
                second_list.add(s);    
            }
            system.debug('sssssssssssssss'+second_list);
               // if(!second_list.isEmpty()){
                NFSwrapper n = new NFSwrapper(nfs, second_list);
                nfs_list.add(n);
               // }
               system.debug('nnnnnnnnnnnnnnn'+nfs_list);
            }     
        }
    
    
    
    
    }
    
    public class NFSwrapper{
           public BFM_NFS__c nfs {set;get;}
           public list <seswrapper> ses_list {set;get;}
           public nfswrapper(BFM_NFS__c nfsrecord, list <seswrapper> second_list){
               ses_list = new list <seswrapper>();
               nfs = nfsrecord;
               ses_list.addAll(second_list);
           }
       }

       public class SESwrapper{
           public boolean isselected{get; set;}
           public BFM_SES__c ses{get; set;}
           public seswrapper(BFM_SES__c sesrecord){
               isselected = false;
               ses = sesrecord;
           }
       } 
       List<BFM_SES__c> listsesupfdate = new List<BFM_SES__c>();
       List<BFM_NFS__c> listnfsupfdate = new List<BFM_NFS__c>();
       public PageReference linkNFS_SES(){
           for(NFSwrapper nw: nfs_list){
               if(!nw.ses_list.isEmpty()){
                   for(SESwrapper sw: nw.ses_list){
                       if(sw.isselected == true){
                           BFM_SES__c sesu = new BFM_SES__c(id = sw.ses.id);
                           sesu.NFS__c = nw.nfs.id;
                           listsesupfdate.add(sesu);
                           
                           BFM_NFS__c nfsu = new BFM_NFS__c(id = nw.nfs.id);
                           nfsu.NFS_Link_Check_Status__c = 'Link Ok';
                           listnfsupfdate.add(nfsu);
                       }
                   }
               }
           }
           
           if(!listsesupfdate.isEmpty()){
               update listsesupfdate;
           }
           if(!listnfsupfdate.isEmpty()){
               update listnfsupfdate;
           }
           
           PageReference redirectPage = Page.BFM_NFSManualLink_VF;
           redirectPage.setRedirect(true);
           return redirectPage;
       } 
       
        
    
}