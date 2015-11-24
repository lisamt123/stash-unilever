trigger IPM_ProjetsShr on IPM_Project__c (after insert,after update) {
IPM_ProjectShare handler=new IPM_ProjectShare();

if(IPM_UpdateChildIpmProjects.off_Trigger){
        return;
    }
   
list<IPM_Project__c>proupdt=new list<IPM_Project__c >();
if(trigger.isinsert){
for(IPM_Project__c ipmpro:trigger.new){
    proupdt.add(new IPM_Project__C(id=ipmpro.id,IPM_Technical_Project_Leader__c=ipmpro.IPM_Project_Leader__c,Deputy_Project_Leader__c=ipmpro.IPM_Project_Leader__c,IPM_Project_Gatekeeper__c=ipmpro.IPM_Project_Leader__c) );
}
 
//update proupdt; 
}
if(trigger.isupdate){
    handler.Sharerecords(trigger.newmap,trigger.oldmap);
    boolean ischanged=false;
    for(IPM_Project__c ipmpro:trigger.new){
        if(ipmpro.IPMProject_Span__c=='Local')
        ischanged=true;
    }
   if(ischanged==true)
    handler.ShareWithLocalMember(trigger.newmap,trigger.oldmap);
}
if(trigger.isinsert){
    handler.SharerecordswithRPL(trigger.newmap,trigger.oldmap);
    handler.ShareWithLocalPL(trigger.newmap);
}
}