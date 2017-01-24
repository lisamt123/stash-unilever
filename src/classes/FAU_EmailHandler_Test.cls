/*
* Name:        -   FAU_EmailHandler
* @description -   This is the test class for FAU_EmailHandler Class.
* @Author      -   Tejasvi Gujjula     
*/

@isTest()
public with sharing class FAU_EmailHandler_Test 
{
    
    public STATIC  FINAL String FromAddresses = 'Chief.Learning.Officer@unilever.com';
    PRIVATE STATIC FINAL String EMAILSPLIT = ',';
    
    /*method Name: SendEmailTest
*/
    static testmethod void sendEmailTest()
    {
        List<FAU_Email__c> emailList = new List<FAU_Email__c>();
        FAU_Email__c email1 =new FAU_Email__c();
        email1.FAU_Subject__c = 'Testmail';
        email1.FAU_Additional_To__c='teja.gujjula@gmail.com';
        email1.FAU_Body__c='Hi';
        email1.FAU_CC__c='teja.sfdc99@gmail.com';
        email1.FAU_To_Address__c='t.reddy.gujjula@accenture.com';
        email1.From_Address__c='Chief.Learning.Officer@unilever.com';
        //  email1.FAU_Send_Email__c=TRUE;
        // email1.FAU_Additional_To__c='testemail@unilever.com';
        
        insert email1;
        emailList.add(email1);
        
        
        FAU_Email__c email2 =new FAU_Email__c();
        email2.FAU_Subject__c = 'Testmail1';
        email2.FAU_Additional_To__c='teja.gujjula1@gmail.com';
        email2.FAU_Body__c='Hi1';
        email2.FAU_CC__c='';
        email2.FAU_To_Address__c='t.reddy.gujjula@accenture.com';
        email2.From_Address__c='Chief.Learning.Officer@unilever.com';
        //  email2.FAU_Send_Email__c=TRUE;
        //  email2.FAU_Additional_To__c='testemail2@unilever.com';
        
        insert email2;
        email2.FAU_Send_Email__c = TRUE;
        update email2;
        emailList.add(email2);
        
        
        FAU_EmailHandler ehand= new FAU_EmailHandler();
        FAU_EmailHandler.sendEmail(emailList);
        
        
        
        
    }
    
}