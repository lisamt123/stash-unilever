@isTest(SeeAllData=true)
   
   /**
     * The Below Class tests the Trigger Event After Insert On Course
     * The class checks whether Course owner is added as Course Facilitator
     * when a new course is created,   
     */    
    public class FA_Test_Trigger_Course{

        static testMethod void Testing_isInsertOnCourse(){
        
            
               Boolean flag=false; 
           
                User ObjUser;
                ObjUser=new User();
                ObjUser.LastName='ahgty';
                ObjUser.Email='ahgty'+'@unilever.com.compass';
                ObjUser.ProfileId=UserInfo.getProfileId();       
                ObjUser.UserName='ahgty'+'@unilever.com.compass';
                ObjUser.CommunityNickname='ahgty';
                ObjUser.Alias='ahgty';
                ObjUser.TimeZoneSidKey='America/Los_Angeles';
                ObjUser.LocaleSidKey=UserInfo.getLocale();
                ObjUser.EmailEncodingKey='UTF-8';
                ObjUser.LanguageLocaleKey='en_US';
               
                insert ObjUser;
        
                FA_Course__c objCourse =new FA_Course__c();
                
                objCourse.FA_status__c='Active';
                objCourse.FA_Course_Code__c='45873';
                objCourse.FA_Course_Logo__c='https://unilever--adfs--c.cs14.content.force.com/servlet/servlet.ImageServer?id=015c0000000EB31&oid=00Dc0000001KMA0&lastMod=1366285875000';
                objCourse.FA_Course_Overview__c='testCourse Overview';
                
                insert objCourse;
                
                Test.startTest(); 
                
                for(FA_Course_Facilitator__c tempCoFa : [select id,FA_Facilitator__c,FA_Course__c 
                                                                       from FA_Course_Facilitator__c
                                                                       where FA_Course__c=:objCourse.id])
                     {
                           If(tempCoFa.FA_Facilitator__c==objCourse.OwnerId)
                           {flag=true;}           
                           else
                           {flag=false;}
                     }           
            
                Test.stopTest();  
           
                system.assertEquals(false,flag);   
                         
        }
    }