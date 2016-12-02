/*
Class to present Audit Trail page with Desc Order of ID/Name
*/

global with sharing class KeyOrientationController {

   private integer counter=0;  //keeps track of the offset
   private integer list_size=10; //sets the page size or number of rows
   public integer total_size; //used to show user the total size of the list
   
   private static final String OPT1 = 'All';
   private static final String OPT2 = 'Changed';
   private static final String OPT3 = 'No Change';

   public String selectedItem { get; set; } { selectedItem = OPT1; }

   public List<SelectOption> options { get; private set; }
   {
       options = new List<SelectOption>();
       options.add(new SelectOption(OPT1, OPT1)); 
       options.add(new SelectOption(OPT2, OPT2));
       options.add(new SelectOption(OPT3, OPT3));
   }
   
   public KeyOrientationController () {
   total_size = [select count() from KeyOrientation__c] ; //set the total size in the constructor
   }
   
   public KeyOrientation__c[] getDetails() {
      
      string filterExp = '';
      try{
             KeyOrientation__c[] details;
             if(selectedItem != 'All'){
                 filterExp = (filterExp == 'Changed' ? 'Changed' : 'No Change');
                 details = [select Name, Response_Code__c, Timestamp__c, LastModifiedDate 
                                from KeyOrientation__c 
                                where Response_Code__c = :selectedItem 
                                order by name desc 
                                limit :list_size 
                                offset :counter];
             }else{
             
                 details = [select Name, Response_Code__c, Timestamp__c, LastModifiedDate 
                                    from KeyOrientation__c 
                                    order by name desc 
                                    limit :list_size 
                                    offset :counter];
               }
               return details;
             } catch (QueryException e) {
                 ApexPages.addMessages(e);   
                 return null;
             }
   }
   
    public PageReference GetHistory() { //user clicked end
      counter = 0;
      string filterExp = '';
       if(selectedItem != 'All'){
                 filterExp = (filterExp == 'Changed' ? 'Changed' : 'No Change');
                 total_size = [select count() from KeyOrientation__c where Response_Code__c = :selectedItem ]; 
             }else{
                 total_size = [select count() from KeyOrientation__c];
               }
      return null;
   }

   
   public PageReference Beginning() { //user clicked beginning
      counter = 0;
      return null;
   }
 
   public PageReference Previous() { //user clicked previous button
      counter -= list_size;
      return null;
   }
 
   public PageReference Next() { //user clicked next button
      counter += list_size;
      return null;
   }
 
   public PageReference End() { //user clicked end
      counter = total_size - math.mod(total_size, list_size);
      return null;
   }
 
   public Boolean getDisablePrevious() { 
      //this will disable the previous and beginning buttons
      if (counter>0) return false; else return true;
   }
 
   public Boolean getDisableNext() { //this will disable the next and end buttons
      if (counter + list_size < total_size) return false; else return true;
   }
 
   public Integer getTotal_size() {
      return total_size;
   }
 
   public Integer getPageNumber() {
      return counter/list_size + 1;
   }
 
   public Integer getTotalPages() {
      if (math.mod(total_size, list_size) > 0) {
         return total_size/list_size + 1;
      } else {
         return (total_size/list_size);
      }
   }


}