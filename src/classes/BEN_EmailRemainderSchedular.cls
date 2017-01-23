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
   //creating list of users
   List<String> listofUser=new List<String>();
   // creating reference for User list
   List<User> userEmail;
   // fetchiung all Ids from group members based on Queue Name
   List<GroupMember> Ids=[SELECT UserOrGroupId FROM GroupMember where GroupId IN (SELECT Id FROM Group WHERE Name LIKE 'BEN%' AND Type =: BEN_ConstantsForBenchmarkingAppClasses.QUEUE)];
   for(GroupMember GrpId:Ids){
       //fetching records from user object base on ids
       userEmail=[SELECT Email FROM User where Id =:GrpId.UserOrGroupId ];
       //putting all emails into distinct list
       distinctListofuser.add((String)userEmail[0].Email);
    }
    
   for(String distUser:distinctListofuser){
     //adding  all email records from set to list
     listofUser.Add(distUser);
    }
    
    //OrgWideEmailAddress Orgid = [Select Id,displayname from OrgWideEmailAddress];
    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
    //setting toaddress
    //message.setOrgWideEmailAddressId('0D2E00000004Fc3KAE'); 
    //setting from address
    message.setToAddresses(new String[]{});
    message.setCcAddresses(new String[]{});
    message.BccAddresses=listofUser;
    message.subject='Reminder to enter test results for this quarter';
    String body1='Hi CTI Category Directors,';
    String body2='Reminder to enter test results for your category for the last quarter.';
    String body3='Kindly ignore this mail, if already undertaken.';
    String body4='This is an automatically generated email, please do not reply'; 
    String body5='Thanks,';
    String body6    ='<GPL Team>';
    //preparing main body
    String mailBody=body1+'\n'+'\n'+body2+'\n'+body3+'\n'+'\n'+body4+'\n'+'\n'+body5+'\n'+body6;
    message.plainTextBody=mailBody;
            
   Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
   Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
   
  }

}