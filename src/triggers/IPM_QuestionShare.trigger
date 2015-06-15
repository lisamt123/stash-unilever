trigger IPM_QuestionShare on IPM_Questionnaire__c (after insert) {

if(trigger.isinsert){
List<IPM_Questionnaire__Share>IpmQuests=new list<IPM_Questionnaire__Share>();
IPM_Questionnaire__Share IPMQuestshr;
set<id>proid=new set<id>();
for(IPM_Questionnaire__c ques:trigger.new){
proid.add(ques.IPM_Project__c);
}

list<IPM_Project_Resource__c>lstRes=[select id,IPM_Role_Type__c,IPM_User__c from IPM_Project_Resource__c where IPM_Project__c IN:proid];
if(lstRes.size()>0){
 for(IPM_Questionnaire__c ques:trigger.new){
   
    for(IPM_Project_Resource__c res:lstRes){
       IPMQuestshr=new IPM_Questionnaire__Share();
       IPMQuestshr.ParentId=ques.id;
       IPMQuestshr.UserOrGroupId=res.IPM_User__c;
       if(res.IPM_Role_Type__c!='Guest'){
       IPMQuestshr.AccessLevel='Edit';
       }else{
       IPMQuestshr.AccessLevel='Read';
       }
    IpmQuests.add(IPMQuestshr);
    }
 }
if(IpmQuests.size()>0)
insert IpmQuests;
}
}
}