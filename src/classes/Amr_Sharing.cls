public with sharing class Amr_Sharing {


public PageReference Reallocate() {
        list<Amr_Job_Details__c> joblist = new list<Amr_Job_Details__c>();
        joblist = [select id,name,Ownerid from Amr_Job_Details__c where id =: 'a6pc00000000472'];
        for(Amr_Job_Details__c jb : joblist ){
        jb.Ownerid = selectusername;
        update jb;
    } 
        return null;
    }





//start sharing 
public List<selectoption> usernam{get;set;}
public id selectusername{get;set;}
public Amr_Sharing (){
usernam = new list<selectoption>();

for(user usr :[Select name, Profile.Name, ProfileId, IsActive, Id From User  where IsActive = True and profile.name='RAP'] ){
  selectoption obj=new selectoption(usr.id,usr.name);
        usernam.add(obj);
}
 
}

public void relatedrecords(){
system.debug('username*************'+selectusername);
user u = [select id,name from user where id=: selectusername  ];

system.debug('usernameiddddddd*************'+u.id);


      Amr_Job_Details__share jobShr  = new Amr_Job_Details__share();
  
      // Set the ID of record being shared.
      jobShr.parentid= 'a6pc00000000472';
       
      // Set the ID of user or group being granted access.
      jobShr.UserOrGroupId = u.id;
       
      // Set the access level.
      jobShr.AccessLevel = 'Read';
      //jobShr.OpportunityAccessLevel = 'Read';
       //insert jobShr;
     
      Database.SaveResult sr = Database.insert(jobShr,false);

      if(sr.isSuccess()){
         //return true;
      }
      else {
         Database.Error err = sr.getErrors()[0];
         if(err.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION  && 
                  err.getMessage().contains('AccessLevel')){
            //return true;
         }
         else{
           //return false;
         }
       }
}

//end sharing
    

   

}