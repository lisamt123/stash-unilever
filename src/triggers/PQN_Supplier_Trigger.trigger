trigger PQN_Supplier_Trigger on PQN_Pallet_Quality_Non_Conformance__c(before insert) {
    PQN_updateSUP.update_SUP(trigger.new);  
}