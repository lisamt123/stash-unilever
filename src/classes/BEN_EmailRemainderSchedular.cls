/*
  Class Name: BEN_EmailRemainderSchedular 
  Author : Mindtree
  Date: 4 Jan 2017
  Requirement/Project Name: SF Benchmarking
  Requirement/Description: This Class will Schedule Email Reminder to all Members in a Queue
**************************************************************************************************************************
*/ 
public with sharing class BEN_EmailRemainderSchedular implements Schedulable{
 
  public static void execute(SchedulableContext sc){
   //creating Set of Distinct users
   Set<String> distinctListofuser=new Set<String>();
   //creating Set of Distinct users Ids
   Set<Id> distinctuserIds=new Set<Id>();
   //creating list of users
   List<String> listofUser=new List<String>();
   // creating reference for User list
   List<User> userEmail;
   // fetchiung all Ids from group members based on Queue Name
   List<GroupMember> Ids=[SELECT UserOrGroupId FROM GroupMember where GroupId IN (SELECT Id FROM Group WHERE Name LIKE 'BEN%' AND Type =: BEN_ConstantsForBenchmarkingAppClasses.QUEUE)];
   for(GroupMember GrpId:Ids){
       //fetching records from user object base on ids
       userEmail=[SELECT Email,Id FROM User where Id =:GrpId.UserOrGroupId ];
       //putting all emails into distinct list
       distinctListofuser.add((String)userEmail[0].Email);
       distinctuserIds.add(userEmail[0].Id);
    }
    
   for(String distUser:distinctListofuser){
     //adding  all email records from set to list
     listofUser.Add(distUser);
    }
    
    OrgWideEmailAddress Orgid = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'sagar.ambasankar@unilever.com' LIMIT 1];
    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
    //setting from address
    message.setOrgWideEmailAddressId(Orgid.Id);
   //setting to address
   for(String distUserIds:distinctuserIds){
     message.setTargetObjectId(distUserIds);
    }  
    message.setSaveAsActivity(false);
    
    message.setToAddresses(new String[]{});
    message.setCcAddresses(new String[]{});
    message.BccAddresses=listofUser;
    message.subject='Reminder to enter test results for this quarter';
    String body1='Hi CTI Category Directors,';
    String body2='Reminder to enter test results for your category for the last quarter.';
    String body3='Kindly ignore this mail, if already undertaken.';
    String body4='This is an automatically generated email, please do not reply'; 
    String body5='Thanks,';
    String body6='GPL Team';
    //preparing main body
    String mailBody=body1+'\n'+'\n'+body2+'\n'+body3+'\n'+'\n'+body4+'\n'+'\n'+body5+'\n'+body6;
    message.plainTextBody=mailBody;
   try{        
   Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
   Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
   }
   catch(System.EmailException ex){
      System.debug(ex.getMessage());
    }
  }

}