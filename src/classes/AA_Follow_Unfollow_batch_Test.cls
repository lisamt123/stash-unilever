@isTest
public class AA_Follow_Unfollow_batch_Test {    
    public static testMethod void testMethodFollowUnfollowBatch(){
    test.starttest();
    AA_Follow_Unfollow_batch obj= new AA_Follow_Unfollow_batch();
   /*      Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];

        User u2 = new User(Alias = 'tdfss', Email='tes23132t@testorg.com',ProfileId = p.Id ,
        
        EmailEncodingKey='UTF-8', LastName='Tes3423423ting', LanguageLocaleKey=AA_Constants.Stringen_us,
        LocaleSidKey=AA_Constants.Stringen_us, TimeZoneSidKey='America/Los_Angeles', UserName='sdadaas123@testorg.com');
        insert u2;
        system.debug('Test user Id==>'+u2.Id);
          aa_Cluster__c clusterData = new aa_Cluster__c(Name =AA_Constants.ClusterSample);
        insert clusterData;
        system.debug('Test cluster Id==>'+clusterData.Id);
        aa_Country__c countryData = new aa_Country__c(Name = AA_Constants.CountrySample,Cluster_Id__c = clusterData.Id);
        insert countryData; 
        EntitySubscription objTemp = new EntitySubscription();
            objTemp.SubscriberId = u2.Id;
            objTemp.ParentId = clusterData.Id;
            insert objTemp;
         EntitySubscription objTemp2 = new EntitySubscription();
            objTemp2.SubscriberId = u2.Id;
            objTemp2.ParentId = countryData.Id;
            insert objTemp2;
        */
         Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];

        User u2 = new User(Alias = 'tdfss', Email='tes23132t@testorg.com',ProfileId = p.Id ,
        
        EmailEncodingKey='UTF-8', LastName='Tes3423423ting', LanguageLocaleKey=AA_Constants.Stringen_us,
        LocaleSidKey=AA_Constants.Stringen_us, TimeZoneSidKey='America/Los_Angeles', UserName='sdadaas123@testorg.com');
        insert u2;
        aa_agent_app_custom_setting__c customsetting = new aa_agent_app_custom_setting__c(Name='Follow batch Last Run Time');
        customsetting.key__c='Follow Batch Last Run Time';
        customsetting.Value__c='2016-06-29 09:59:02';
        insert customsetting;
        
        aa_agent_app_custom_setting__c customsetting1= new aa_agent_app_custom_setting__c(Name='Follow Batch User ID');
        customsetting1.key__c='Follow_Batch_User_ID';
        customsetting1.Value__c='00518000000ptkH';
        insert customsetting1;
        
        //Creating cluster for Africa
        aa_Cluster__c objCluster = new aa_Cluster__c ();
        objCluster.Name ='Africa';
        insert objCluster;        
        //Creating country 
        aa_Country__c objCountry = new aa_Country__c();
        objCountry.Name ='India';
        objCountry.Cluster_Id__c =objCluster.Id;
        insert objCountry;
        
        //creating glbal cluster
        aa_Cluster__c objCluster1 = new aa_Cluster__c ();
        objCluster1.Name ='Global';
        insert objCluster1;
        
        //Creating cluster Europe
        aa_Cluster__c objCluster2 = new aa_Cluster__c ();
        objCluster2.Name ='Europe';
        insert objCluster2;        
        //Creating country 
        aa_Country__c objCountry2 = new aa_Country__c(Name='India');
       // objCountry2.Name ='India';
        objCountry2.Cluster_Id__c =objCluster2.Id;
        insert objCountry2;
        
        //Creating cluster Latin America
        aa_Cluster__c objCluster3 = new aa_Cluster__c ();
        objCluster3.Name ='Latin America';
        insert objCluster3;
        //Creating country 
        aa_Country__c objCountry3 = new aa_Country__c();
        objCountry3.Name ='India';
        objCountry3.Cluster_Id__c =objCluster3.Id;
        insert objCountry3;
        
        //Creating cluster NAMET & RUB
        aa_Cluster__c objCluster4 = new aa_Cluster__c ();
        objCluster4.Name ='NAMET & RUB';
        insert objCluster4;
        //Creating country 
        aa_Country__c objCountry4 = new aa_Country__c();
        objCountry4.Name ='India';
        objCountry4.Cluster_Id__c =objCluster4.Id;
        insert objCountry4;
        
        //Creating cluster North America
        aa_Cluster__c objCluster5 = new aa_Cluster__c ();
        objCluster5.Name ='North America';
        insert objCluster5;
        //Creating country 
        aa_Country__c objCountry5 = new aa_Country__c();
        objCountry5.Name ='India';
        objCountry5.Cluster_Id__c =objCluster5.Id;
        insert objCountry5;
        
        //Creating cluster South Asia
        aa_Cluster__c objCluster6 = new aa_Cluster__c ();
        objCluster6.Name ='South Asia';
        insert objCluster6;
        //Creating country
        aa_Country__c objCountry6 = new aa_Country__c();
        objCountry6.Name ='India';
        objCountry6.Cluster_Id__c =objCluster6.Id;
        insert objCountry6;
        
        //Creating cluster North Asia
        aa_Cluster__c objCluster7 = new aa_Cluster__c ();
        objCluster7.Name ='North Asia';
        insert objCluster7;
        //Creating country
        aa_Country__c objCountry7 = new aa_Country__c();
        objCountry7.Name ='India';
        objCountry7.Cluster_Id__c =objCluster7.Id;
        insert objCountry7;
        
        //Creating cluster SEAA
        aa_Cluster__c objCluster8 = new aa_Cluster__c ();
        objCluster8.Name ='SEAA';
        insert objCluster8;
        //Creating country
        aa_Country__c objCountry8 = new aa_Country__c();
        objCountry8.Name ='India';
        objCountry8.Cluster_Id__c =objCluster8.Id;
        insert objCountry8; 
        
        //Creating cluster SEAA
        aa_Cluster__c objCluster9 = new aa_Cluster__c ();
        objCluster9.Name ='Asia';
        insert objCluster9;
        //Creating country
        aa_Country__c objCountry9 = new aa_Country__c();
        objCountry9.Name ='India';
        objCountry9.Cluster_Id__c =objCluster9.Id;
        insert objCountry9; 
        
        //Following country for objUser 
        EntitySubscription objFollow = new EntitySubscription();
        objFollow.ParentId = objCountry9.Id;
        objFollow.SubscriberId  = userinfo.getuserid();
        insert objFollow;
        
      insert new aa_agent_app_custom_setting__c(Name='Test');

        List<aa_Agent_App_User_Preference__c> UserSet = new List<aa_Agent_App_User_Preference__c>();
        aa_Agent_App_User_Preference__c objUserSet = new aa_Agent_App_User_Preference__c();
        objUserSet.UserId__c = userinfo.getuserid();     
        UserSet.add(objUserSet);
    aa_Agent_App_User_Preference__c userPref = new aa_Agent_App_User_Preference__c(Auto_follow__c= true,UserId__c =u2.Id);
    insert userPref;
    List<aa_Agent_App_User_Preference__c> objAgent =  new  List<aa_Agent_App_User_Preference__c>();
    objAgent.add(userPref);
    Database.BatchableContext BC;
    obj.start(BC);
    obj.execute(BC,objAgent);
    obj.finish(BC);
    test.stoptest();
    
    }
  }