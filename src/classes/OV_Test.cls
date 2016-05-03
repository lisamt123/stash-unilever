public with sharing class OV_Test {
	public static void test() {
        Schema.DescribeSObjectResult contactDesc = Contact.getSObjectType().getDescribe();

        Map<String, Schema.SObjectField> contactFieldsMap = contactDesc.fields.getMap();
        for(String contactFieldName : contactFieldsMap.keySet()){
            system.debug('___________'+contactFieldName);
            Schema.DescribeFieldResult contactFieldDesc = contactFieldsMap.get(contactFieldName).getDescribe();
            // && contactFieldDesc.isPermissionable() to eliminate system fields however then add createdby/updatedon etc 
            if(contactFieldDesc.isFilterable() && contactFieldDesc.isAccessible()){
                 system.debug('___________2'+contactFieldName);
                //System.debug('_________Contact Field: '+ contactFieldDesc.getLabel());
                //if this field is lookup or master details
                if(contactFieldDesc.getReferenceTo().size() > 0){
                    String contactLookupTo = String.valueOf(contactFieldDesc.getReferenceTo()[0]);
                    Schema.DescribeSObjectResult contactRelatedObjectDescription = Schema.getGlobalDescribe().get(contactLookupTo).getDescribe();
                    Map<String, Schema.SObjectField> contactRODFieldsMap = contactRelatedObjectDescription.fields.getMap();

                    String cFieldName = '';
                    if(contactFieldDesc.isCustom()){
                        cFieldName = contactFieldName.replace('__c', '__r.');
                    }else{
                        cFieldName = contactFieldDesc.getRelationshipName()+'.';
                    }
                    for(String contactRODFieldName : contactRODFieldsMap.keySet()){
                        Schema.DescribeFieldResult contactRODFieldDesc = contactRODFieldsMap.get(contactRODFieldName).getDescribe();
                        //&& contactFieldDesc.isPermissionable()
                        if(contactRODFieldDesc.isFilterable() && contactRODFieldDesc.isAccessible() ){   
                            //if this field from lookup object is lookup or master detail
                            if(contactRODFieldDesc.getReferenceTo().size() > 0){
                                String contactRODFieldDescLookup = String.valueOf(contactRODFieldDesc.getReferenceTo()[0]);
                                Schema.DescribeSObjectResult contactRODFieldDescLookupObjectDesc = Schema.getGlobalDescribe().get(contactRODFieldDescLookup).getDescribe();

                                if(contactRODFieldDesc.isCustom()){
                                    String lookupName = contactRODFieldDesc.getName().replace('__c', '__r');
                                    String lookupFieldName = contactRODFieldDescLookup.replace('__c', '__r.Name');

                                    String finalName = cFieldName +'.'+ lookupName +'.'+ lookupFieldName;
                                    String finalLabel = contactFieldDesc.getLabel() + ' ' +contactRODFieldDesc.getLabel() + ' ' + contactRODFieldDescLookupObjectDesc.getLabel() + ' ' + 'Name';
                                    String finalWhereName = 'Contact';
                                    Boolean finalIsContactField = true;
                                    String finalType = 'LOOKUP';

                                    system.debug('____________'+finalLabel);
                                    //CMP_Wrapper.FilterField wrappedField = new CMP_Wrapper.FilterField(finalName, finalLabel, finalType, finalIsContactField, finalWhereName);
                                    //mapOfFields.put(finalLabel, wrappedField);
                                }else{
                                    if(contactRODFieldDesc.getRelationshipName() != null){
                                        String finalName = cFieldName+contactRODFieldDesc.getRelationshipName()+ '.Name';
                                        String finalLabel = contactFieldDesc.getLabel() + ' ' +contactRODFieldDesc.getLabel() + ' ' + contactRODFieldDescLookupObjectDesc.getLabel() + ' '+ 'Name';
                                        String finalWhereName = 'Contact';
                                        Boolean finalIsContactField = true;
                                        String finalType = 'LOOKUP';

                                        system.debug('____________'+finalLabel);
                                        //CMP_Wrapper.FilterField wrappedField = new CMP_Wrapper.FilterField(finalName, finalLabel, finalType, finalIsContactField, finalWhereName);
                                       //mapOfFields.put(finalLabel, wrappedField);
                                    }                            
                                }
                            }else{
                                String finalName = cFieldName+contactRODFieldDesc.getName();
                                String finalLabel = contactFieldDesc.getLabel() + ' ' +contactRODFieldDesc.getLabel();
                                String finalWhereName = 'Contact';
                                Boolean finalIsContactField = true;
                                String finalType = String.valueOf(contactRODFieldDesc.getType());
                                // if this field from lookup object is not a lookup or master detail then normally parse it                        
                                //CMP_Wrapper.FilterField wrappedField = new CMP_Wrapper.FilterField(finalName, finalLabel, finalType, finalIsContactField, finalWhereName);
         
                                if(finalType == 'PICKLIST'){
                                    for(Schema.PicklistEntry entry : contactFieldDesc.getPicklistValues()){
                                        //wrappedField.addValue(entry.getValue());
                                    }
                                }else if(finalType == 'BOOLEAN'){
                                    //wrappedField.addValue('TRUE');
                                    //wrappedField.addValue('FALSE');
                                }

                                system.debug('____________'+finalLabel);
                               // mapOfFields.put(finalLabel, wrappedField);
                            }
                        }else{
                            //
                        }
                    }        
                }else{
                    String finalName = contactFieldDesc.getName();
                    String finalLabel = contactFieldDesc.getLabel();
                    String finalWhereName = 'Contact';
                    Boolean finalIsContactField = true;
                    String finalType = String.valueOf(contactFieldDesc.getType());

                    //CMP_Wrapper.FilterField wrappedField = new CMP_Wrapper.FilterField(finalName, finalLabel, finalType, finalIsContactField, finalWhereName);

                    if(finalType == 'PICKLIST'){
                        for(Schema.PicklistEntry entry : contactFieldDesc.getPicklistValues()){
                            //wrappedField.addValue(entry.getValue());
                        }
                    }else if(finalType == 'BOOLEAN'){
                        //wrappedField.addValue('TRUE');
                        //wrappedField.addValue('FALSE');
                    }
                    system.debug('____________'+finalLabel);
                    //mapOfFields.put(finalLabel, wrappedField);
                }
            }else{
                //    
            }        
        }

        List<Schema.SObjectType> allObjects = Schema.getGlobalDescribe().Values();
        for(Schema.SObjectType obj : allObjects){
            if(obj.getDescribe().isCustom()){
                Schema.DescribeSObjectResult objectDesc = obj.getDescribe();
               
                Map<String, Schema.SObjectField> fieldsMap = objectDesc.fields.getMap();
                for(String fieldName : fieldsMap.keySet()){
                    Schema.DescribeFieldResult fieldDesc = fieldsMap.get(fieldName).getDescribe();
                    
                    //means that it's master details
                    if (fieldDesc.isAccessible() && fieldDesc.isFilterable() && fieldDesc.getRelationshipOrder() != null && String.valueOf(fieldDesc.getReferenceTo()[0]) == 'Contact'){
                        //then find another master detail
                        for(String fieldName2 : fieldsMap.keySet()){
                            Schema.DescribeFieldResult fieldDesc2 = fieldsMap.get(fieldName2).getDescribe();
                            if (fieldDesc2.isAccessible() && fieldDesc2.isFilterable() && fieldDesc2.getRelationshipOrder() != null && String.valueOf(fieldDesc2.getReferenceTo()[0]) != 'Contact'){
                                String refTo = String.valueOf(fieldDesc2.getReferenceTo()[0]);

                                SObjectType detailObject = Schema.getGlobalDescribe().get(refTo);
                                Schema.DescribeSObjectResult detailObjectDesc = detailObject.getDescribe();
                                Map<String, Schema.SObjectField> detailObjectfieldsMap = detailObjectDesc.fields.getMap();
                                for(String detailFieldName : detailObjectfieldsMap.keySet()){
                                    Schema.DescribeFieldResult detailFieldDesc = detailObjectfieldsMap.get(detailFieldName).getDescribe();

                                    if(detailFieldDesc.getReferenceTo().size() > 0){
                                        if(detailFieldDesc.isCustom()){
                                            String detailLookupName = fieldDesc2.getName().replace('__c', '__r');
                                            String detailLookupFieldName = detailFieldDesc.getName().replace('__c', '__r.Name');

                                            String finalName = detailLookupName +'.'+detailLookupFieldName;
                                            String finalLabel = objectDesc.getLabel() + ': '+ fieldDesc2.getLabel() + ' ' +detailFieldDesc.getLabel() + 'Name';
                                            String finalWhereName = objectDesc.getName();
                                            Boolean finalIsContactField = false;
                                            String finalType = 'LOOKUP';
                                            system.debug('____________'+finalLabel);
                                            //CMP_Wrapper.FilterField wrappedField = new CMP_Wrapper.FilterField(finalName, finalLabel, finalType, finalIsContactField, finalWhereName);
                                            //mapOfFields.put(finalLabel, wrappedField);
                                        }else{
                                            if(detailFieldDesc.getRelationshipName() != null){
                                                String detailLookupName = fieldDesc2.getName().replace('__c', '__r');
                                                String detailLookupFieldName = detailFieldDesc.getRelationshipName()+'.Name';

                                                String finalName = detailLookupName +'.'+ detailLookupFieldName;
                                                String finalLabel = objectDesc.getLabel() + ': '+fieldDesc2.getLabel() + ' ' +detailFieldDesc.getLabel() + 'Name';
                                                String finalWhereName = objectDesc.getName();
                                                Boolean finalIsContactField = false;
                                                String finalType = 'LOOKUP';
                                                system.debug('____________'+finalLabel);
                                                //CMP_Wrapper.FilterField wrappedField = new CMP_Wrapper.FilterField(finalName, finalLabel, finalType, finalIsContactField, finalWhereName);
                                                //mapOfFields.put(finalLabel, wrappedField);
                                            }                            
                                        }
                                    }else{
                                        String finalName = fieldDesc2.getName().replace('__c', '__r') +'.'+detailFieldDesc.getName();
                                        String finalLabel = objectDesc.getLabel() + ': '+ fieldDesc2.getLabel() + ' ' +detailFieldDesc.getLabel();
                                        String finalWhereName = objectDesc.getName();
                                        Boolean finalIsContactField = false;
                                        String finalType = String.valueOf(detailFieldDesc.getType());

                                        //CMP_Wrapper.FilterField wrappedField = new CMP_Wrapper.FilterField(finalName, finalLabel, finalType, finalIsContactField, finalWhereName);              

                                        if(finalType == 'PICKLIST'){
                                            for(Schema.PicklistEntry entry : detailFieldDesc.getPicklistValues()){
                                                //wrappedField.addValue(entry.getValue());
                                            }
                                        }else if(finalType == 'BOOLEAN'){
                                            //wrappedField.addValue('TRUE');
                                            //wrappedField.addValue('FALSE');
                                        }
                                        system.debug('____________'+finalLabel);
                                        //mapOfFields.put(finalLabel, wrappedField);
                                    }
                                }
                                break;
                            }
                        }
                    }
                }
            }
        }		
	}
}