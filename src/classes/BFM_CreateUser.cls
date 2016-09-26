public class BFM_CreateUser
{  
    @future  
    public static void createuser(Map<id,string> mapcon,set<id> conids,set<id> BFMconids)
    {
        List<Contact> listcon = new List<Contact>();
        List<BFM_Contact__c> listBFMcon = new List<BFM_contact__c>();
        contact objCon = new contact();
        if(!conids.isEmpty()){
            listcon = [select id,lastname,email from contact where id in: conids]; 
            objCon = listcon[0];       
        }
        
        
        if(!BFMconids.isEmpty()){
            listBFMcon = [select id,first_name__c,last_name__c,email__c from BFM_Contact__c where id in:BFMconids];
        } 
        User newCommunitiesUser = new User();  
        for(BFM_Contact__c bcon: listBFMcon){
            
            newCommunitiesUser.contactId=objCon.Id;
            newCommunitiesUser.username=bcon.Email__c+'user';                           
            newCommunitiesUser.firstname=bcon.First_Name__c;
            newCommunitiesUser.lastname=bcon.Last_Name__c; 
            newCommunitiesUser.email=bcon.Email__c;
            newCommunitiesUser.communityNickname = bcon.Last_Name__c + '_'+Math.random();
            newCommunitiesUser.alias = string.valueof(bcon.First_Name__c.substring(0,1) + 
                      bcon.Last_Name__c.substring(0,1) + Math.random() ).substring(0,5); 
            newCommunitiesUser.profileid = '00eE00000011wbF'; 
            newCommunitiesUser.emailencodingkey='UTF-8';
            newCommunitiesUser.languagelocalekey='en_US'; 
            newCommunitiesUser.localesidkey='en_US';
            newCommunitiesUser.timezonesidkey='America/Los_Angeles';  
            
            
            

           // Database.DMLOptions dlo=new Database.DMLOptions();
//dlo.EmailHeader.triggerUserEmail =true;
//dlo.EmailHeader.triggerAutoResponseEmail=true;
//dlo.EmailHeader.triggerOtherEmail = false;
//newCommunitiesUser.setOptions(dlo);   
//Database.saveresult sr = Database.insert(newCommunitiesUser,dlo);             
     // insert newCommunitiesUser;     
      } 
      Database.DMLOptions dlo = new Database.DMLOptions();
dlo.EmailHeader.triggerUserEmail = true;
database.insert(newCommunitiesUser, dlo);
    
    }
    
}