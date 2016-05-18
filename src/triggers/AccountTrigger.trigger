trigger AccountTrigger on Account (after insert, after update, before insert, before update) {

    if(trigger.isInsert && (trigger.isAfter || trigger.isbefore)){
        //To Populate Zone,Region,Territory and account Number Fields On account object for Operator
        NAFS_AccountHelper.insertAccount(trigger.new,trigger.isAfter,trigger.isBefore);
    }    
}