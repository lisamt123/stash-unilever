/*
Copyright (c) 2014, salesforce.com, Inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice,
    this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.
    * Neither the name of the salesforce.com, Inc. nor the names of its contributors
    may be used to endorse or promote products derived from this software
    without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
OF THE POSSIBILITY OF SUCH DAMAGE.

*/
public with sharing class PBS_Learning_Preview_Ext_CC{

    public PBS_Learning__c learning{get;set;}
    public String selectedContent{get;set;}
    @TestVisible
    private String currentRecordType;
    private ApexPages.StandardSetController contentsSSC{get;set;}
    private PBS_Learning_Version__c previewlVersion;

    private Map<String,String> rtObjectMapping;
    private Map<String,String> rtFieldMapping;

    public PBS_Learning_Preview_Ext_CC(ApexPages.StandardController cont){

        try{

            //BEGIN Access Check
            Map<Schema.sObjectType,List<String>> relatedFieldsObjects = new Map<Schema.sObjectType,List<String>>();
            relatedFieldsObjects.put(PBS_Learning__c.sObjectType,new List<String>{
                'Id'
                ,'Name'
                ,'Published__c'
                ,'Current_Published_Version__c'
                ,'Custom_Preview_URL__c'
            });
            PBS_LMS_ESAPI_CC.isAuthorizedToView(relatedFieldsObjects);
            //END Access Check

            //Fetch current learning information
            learning = [select id
                                ,name
                                ,published__c
                                ,current_published_version__c
                                ,recordtype.developerName
                                ,Custom_Preview_URL__c
                                from PBS_Learning__c
                                where id = :cont.getId()];

            init();

         }catch(PBS_LMSPlugins_CC.LMSPluginsException e){
             PBS_LMSUtils_CC.addErrorMessage(e.getMessage());
         }catch(Exception e){
             PBS_LMSUtils_CC.logException(e,'Learning_Preview_Ext');
             PBS_LMSUtils_CC.addGenericUnknownErrorMessage('Learning_Preview_Ext - init (1)');
         }

    }

    private void init(){

        //Init auxiliary field/object maps
        rtObjectMapping = new Map<String,String>{
           'task'=>'PBS_Task__c'
           ,'quiz'=>'PBS_Quiz__c'
           ,'resource'=>'PBS_Training_Resource__c'
        };

        rtFieldMapping = new Map<String,String>{
           'task'=>'Task__c'
           ,'quiz'=>'Quiz__c'
           ,'resource'=>'Training_Resource__c'
        };

        //Get the record type for the current learning
        currentRecordType = learning.recordType.developerName;
        currentRecordType = currentRecordType.toLowerCase();

        List<String> listSOQLFields = new List<String>{
            'Id'
            ,'Name'
            ,'CreatedDate'
        };

        //BEGIN Access Check
        Map<Schema.sObjectType,List<String>> relatedFieldsObjects = new Map<Schema.sObjectType,List<String>>();
        relatedFieldsObjects.put(PBS_Task__c.sObjectType,listSOQLFields);
        relatedFieldsObjects.put(PBS_Quiz__c.sObjectType,listSOQLFields);
        relatedFieldsObjects.put(PBS_Training_Resource__c.sObjectType,listSOQLFields);

        PBS_LMS_ESAPI_CC.isAuthorizedToView(relatedFieldsObjects);
        //END Access Check

        //Update the object names with the package namespace
        for(String rtKey : rtObjectMapping.keySet()){
            String objectName = rtObjectMapping.get(rtKey);
            rtObjectMapping.put(rtKey,PBS_LMSUtils_CC.getPackageNamespace()+objectName);
        }

        //Get additional record types for learning plugins
        String learningObjectName = PBS_LMSUtils_CC.getPackageNamespace()+'PBS_Learning__c';
        Map<String,String> recordTypeNamespaceMap = new Map<String,String>();
        for(RecordType rt : [select Id,DeveloperName from RecordType where SobjectType = :learningObjectName]){
            String developerName = (rt.DeveloperName).toLowerCase();
            //Skip standard learnings
            if(rtObjectMapping.containsKey(developerName)){
                recordTypeNamespaceMap.put(developerName,PBS_LMSUtils_CC.getPackageNamespace());
                continue;
            }
            PBS_LMSPlugins_CC.LearningConfig customLearningConfig = PBS_LMSPlugins_CC.getLearningPluginConfig(rt.DeveloperName);
            String nameSpacePrefix = String.isBlank(customLearningConfig.namespacePrefix)?'':customLearningConfig.namespacePrefix+'__';
            recordTypeNamespaceMap.put(developerName,nameSpacePrefix);
            rtObjectMapping.put(developerName, nameSpacePrefix+customLearningConfig.objectName);
            rtFieldMapping.put(developerName, nameSpacePrefix+customLearningConfig.learningVersionLookupField);
        }

        //Init Standard set controller
        Id lid = learning.Id;
        String soql = 'select '+String.join(listSOQLFields,',')+' from '+rtObjectMapping.get(currentRecordType)+' where '+recordTypeNamespaceMap.get(currentRecordType)+'Learning__c = :lid order by CreatedDate desc';
        contentsSSC = new ApexPages.StandardSetController(Database.getQueryLocator(soql));
    }

    //Get records from the standard set controller
    public List<SObject> getContents() {
        if(contentsSSC == null){
            return new List<SObject>();
        }
        return contentsSSC.getRecords();
    }

    //Metho that creates a preview learning version for the selected learning
    public PageReference previewContent(){

        try{

            //Create or fetch preview learning version
            if(!String.isBlank(selectedContent)){

                previewlVersion = new PBS_Learning_Version__c();

                Id learningId = learning.Id;
                String selectedContentId = selectedContent;

                //BEGIN Access Check
                List<String> lvFields =  new List<String>{'PBS_Learning__c','Version__c','Type__c'};
                Map<Schema.sObjectType,List<String>> relatedFieldsObjectsView = new Map<Schema.sObjectType,List<String>>();
                relatedFieldsObjectsView.put(PBS_Learning_Version__c.sObjectType,lvFields);
                Map<Schema.sObjectType,List<String>> relatedFieldsObjectsCreate = new Map<Schema.sObjectType,List<String>>();
                relatedFieldsObjectsCreate.put(PBS_Learning_Version__c.sObjectType,lvFields);

                PBS_LMS_ESAPI_CC.isAuthorizedToView(relatedFieldsObjectsView);
                PBS_LMS_ESAPI_CC.isAuthorizedToCreate(relatedFieldsObjectsCreate);
                //END Access Check

                //Fetch existing learning version for current content
                String soql = 'select id from PBS_Learning_Version__c where Type__c = \'Preview\' and Learning__c = :learningId';
                soql+= ' and '+rtFieldMapping.get(currentRecordType)+' = :selectedContentId';

                //Set common attributes
                previewlVersion.put(rtFieldMapping.get(currentRecordType),selectedContent);
                previewlVersion.Learning__c = learning.Id;
                previewlVersion.Version__c = 0;
                previewlVersion.Type__c = 'Preview';

                //Look for an existing preview version, if there's a match just return that version
                List<PBS_Learning_Version__c> existingPreviewLVs = (List<PBS_Learning_Version__c>)Database.query(soql);

                if(existingPreviewLVs.size()>0){
                    previewlVersion = existingPreviewLVs.get(0);
                }else{
                    //Nope, there's no version create a new preview version
                    upsert previewlVersion;
                }

                return doRedirection();

            }else{
                PBS_LMSUtils_CC.addErrorMessage(System.Label.ALMS_Preview_Version_Error);
                return null;
            }

        }catch(Exception e){
            PBS_LMSUtils_CC.logException(e,'Learning_Preview_Ext');
            PBS_LMSUtils_CC.addGenericUnknownErrorMessage('Learning_Preview_Ext - previewContent (2)');
            return null;
        }

    }

    //This method creates an assignment for the preview learning version and redirects to the preview page
    public PageReference doRedirection(){

        try{

            PBS_Learning_Assignment__c previewAssignment = new PBS_Learning_Assignment__c();

            //BEGIN Access Check
            List<String> laFields =  new List<String>{'PBS_Learning__c'
                                                        ,'Learning_Version__c'
                                                        ,'Is_Test_Assignment__c'
            };
            Map<Schema.sObjectType,List<String>> relatedFieldsObjectsView = new Map<Schema.sObjectType,List<String>>();
            relatedFieldsObjectsView.put(PBS_Learning_Assignment__c.sObjectType,laFields);
            Map<Schema.sObjectType,List<String>> relatedFieldsObjectsCreate = new Map<Schema.sObjectType,List<String>>();
            relatedFieldsObjectsCreate.put(PBS_Learning_Assignment__c.sObjectType,laFields);

            PBS_LMS_ESAPI_CC.isAuthorizedToView(relatedFieldsObjectsView);
            PBS_LMS_ESAPI_CC.isAuthorizedToCreate(relatedFieldsObjectsCreate);
            //END Access Check

            //Fetch existing preview assignments
            List<PBS_Learning_Assignment__c> previewAssignments = [select id
                                                                    ,name
                                                                    from PBS_Learning_Assignment__c
                                                                    where Learning__c = :learning.Id
                                                                    and Learning_Version__c = :previewlVersion.Id
                                                                    and User__c = :UserInfo.getUserId()
                                                                    and Is_Test_Assignment__c = true];

            if(previewAssignments.size()>0){
                //We found an existing test assignment, no need to create a new one, use this one instead
                previewAssignment = previewAssignments.get(0);
            }else{
                //There's no preview assignment, let's create one
                previewAssignment.Learning__c = learning.Id;
                previewAssignment.Learning_Version__c = previewlVersion.Id;
                previewAssignment.Is_Test_Assignment__c = true;
                previewAssignment.User__c = UserInfo.getUserId();
                insert previewAssignment;
            }

            //Redirect to content launcher
            PageReference ref = null;

            if(learning.Custom_Preview_URL__c != null){
                ref = new PageReference(learning.Custom_Preview_URL__c);
            }else{

                if(currentRecordType == PBS_LMSConstants_CC.RT_TASK){
                    ref = Page.PBS_TaskViewer;
                }else if(currentRecordType == PBS_LMSConstants_CC.RT_TRAINING_RESOURCE){
                    ref = Page.PBS_ResourceViewer;
                }else if(currentRecordType == PBS_LMSConstants_CC.RT_QUIZ){
                    ref = Page.PBS_QuizViewer;
                }else{
                    //Check for plugin launch URL
                    PBS_LMSPlugins_CC.LearningConfig customLearningConfig = PBS_LMSPlugins_CC.getLearningPluginConfig(currentRecordType);
                    ref = new PageReference(customLearningConfig.getLaunchURLWithNamespace());
                }

            }

            //Add common parameters to content launcher page
            ref.setRedirect(true);
            ref.getParameters().put('aid',previewAssignment.Id);
            ref.getParameters().put('pMode','true');

            return ref;
        }catch(Exception e){
            PBS_LMSUtils_CC.logException(e,'Learning_Preview_Ext');
            PBS_LMSUtils_CC.addGenericUnknownErrorMessage('Learning_Preview_Ext - doRedirection (3)');
            return null;
        }

    }

}