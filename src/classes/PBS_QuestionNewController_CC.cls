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
public with sharing class PBS_QuestionNewController_CC{

    public PBS_Question__c question{get;set;}
    private PBS_Answer_Sequence__c answerSequence {get;set;}
    public List<PBS_Answer_Sequence_Item__c> lanswerseqitems {get;set;}
    public Boolean banswerseq {get;set;}
    public Boolean banswernum {get;set;}
    public Boolean banswerbool {get;set;}
    public String questiontype {get;set;}
    public String qlid {get; private set;}

    //Note: still need to handle deleting answer sequence items on edit
    //Note: might need some refactoring when all functionality is in place

    //initialize
    public PBS_QuestionNewController_CC(ApexPages.StandardController controller){

        try{

            //default all boolean flags
            setDefaults();

            if(!Test.isRunningTest()){
                //add all Question__c fields used on vf page
                controller.addFields(new List<String>{'Name','Description__c','Description_RTA__c','Type__c', 'Order__c', 'Correct_Number__c' , 'Correct_Boolean__c', 'Answer_Sequence__c'});
            }

            //record id
            String recid = controller.getRecord().Id;

            //initliaize question record
            if(String.isNotBlank(recid)){
                question = (PBS_Question__c)controller.getRecord();
                PBS_Question__c questionDetails = getQuestionDetails(question.Id);
                if(questionDetails != null){
                    qlid = questionDetails.Question_Line__c;
                }
                editmode();
            }else{
                answerSequence = new PBS_Answer_Sequence__c();
                question = new PBS_Question__c();
                qlid = ApexPages.CurrentPage().getParameters().get('retURL');
                question.Question_Line__c = qlid.replace('/', '');
            }

        }catch(Exception e){
            PBS_LMSUtils_CC.logException(e,'QuestionNewController');
            PBS_LMSUtils_CC.addGenericUnknownErrorMessage('QuestionNewController - constructor (1)');
        }

    }

    private PBS_Question__c getQuestionDetails(Id questionId){
        List<PBS_Question__c> qDetails = [select id,Question_Line__c from PBS_Question__c where id = :questionId limit 1];
        if(qDetails.size() > 0){
            return qDetails.get(0);
        }else{
            return null;
        }
    }

    public void editmode(){

        //BEGIN Access Check
        Map<Schema.sObjectType,List<String>> relatedFieldsObjects = new Map<Schema.sObjectType,List<String>>();
        relatedFieldsObjects.put(PBS_Question__c.sObjectType,new List<String>{
            'Description__c'
            ,'Description_RTA__c'
            ,'Type__c'
            ,'Order__c'
            ,'Correct_Number__c'
            ,'Correct_Boolean__c'
        });
        relatedFieldsObjects.put(PBS_Answer_Sequence__c.sObjectType,new List<String>{
            'Id'
            ,'Internal_Notes__c'
        });
        relatedFieldsObjects.put(PBS_Answer_Sequence_Item__c.sObjectType,new List<String>{
            'Id'
            ,'Item_Id__c'
            ,'Answer_Text__c'
            ,'Is_Correct_Answer__c'
            ,'Order__c'
            ,'Answer_Sequence__c'
        });
        PBS_LMS_ESAPI_CC.isAuthorizedToView(relatedFieldsObjects);
        //END Access Check

        banswerseq = question.Answer_Sequence__c != null ? true : false;
        banswernum = question.Type__c == 'Number' ? true : false;
        banswerbool = question.Type__c == 'Boolean' ? true : false;
        questiontype = question.Type__c;

        if(banswerseq){
            answerSequence = [select Id, Internal_Notes__c from PBS_Answer_Sequence__c where Id =: question.Answer_Sequence__c];

            lanswerseqitems = [select Id,
                                    Item_Id__c,
                                    Answer_Text__c,
                                    Is_Correct_Answer__c,
                                    Order__c,
                                    Answer_Sequence__c from PBS_Answer_Sequence_Item__c where Answer_Sequence__c =: question.Answer_Sequence__c];
        }
    }

    //enable types of question
    public PageReference answerseqenabler(){

        setDefaults();

        if(!String.isBlank(questiontype) ){

            if(questiontype == 'SelectMultipleQuestion' || questiontype == 'SelectOneQuestion'){
                banswerseq = true;
                //initializes Answer Sequence Item list
                lanswerseqitems = new List<PBS_Answer_Sequence_Item__c>();
                lanswerseqitems.add(new PBS_Answer_Sequence_Item__c());
            }

            if(questiontype == 'Number'){
                banswernum = true;
            }

            if(questiontype == 'Boolean'){
                banswerbool = true;
            }

        }

        return null;
    }

    public void setDefaults(){
        banswerseq = false;
        banswernum = false;
        banswerbool = false;
    }

    //call with actionfunction
    public PageReference addanswerseqitem(){
        lanswerseqitems.add(new PBS_Answer_Sequence_Item__c());
        return null;
    }

    public PageReference c_save(){

        try{

            //BEGIN Access Check
            Map<Schema.sObjectType,List<String>> relatedFieldsObjects = new Map<Schema.sObjectType,List<String>>();
            relatedFieldsObjects.put(PBS_Question__c.sObjectType,new List<String>{
                'Description__c'
                ,'Description_RTA__c'
                ,'Type__c'
                ,'Order__c'
                ,'Correct_Number__c'
                ,'Correct_Boolean__c'
            });
            relatedFieldsObjects.put(PBS_Answer_Sequence_Item__c.sObjectType,new List<String>{
                'Answer_Text__c'
                ,'Is_Correct_Answer__c'
                ,'Order__c'
                ,'Answer_Sequence__c'
            });
            relatedFieldsObjects.put(PBS_Question__c.sObjectType,new List<String>{
                'Answer_Sequence__c'
                ,'Type__c'
            });
            PBS_LMS_ESAPI_CC.isAuthorizedToCreate(relatedFieldsObjects);
            PBS_LMS_ESAPI_CC.isAuthorizedToUpdate(relatedFieldsObjects);
            //END Access Check

            if(banswerseq){
                upsert answerSequence;

                for(PBS_Answer_Sequence_Item__c asi : lanswerseqitems){
                    asi.Answer_Sequence__c = answerSequence.Id;
                }

                upsert lanswerseqitems;

                question.Answer_Sequence__c = answerSequence.Id;
                upsert question;

            }else{
                upsert question;
                //Note: need to handle deleting Answer Sequence & Answer Sequence Items in case Type changes on edit from options to Text, Boolean or Number
            }
        }catch(Exception e){
            PBS_LMSUtils_CC.addErrorMessage(e.getMessage());
            PBS_LMSUtils_CC.logException(e,'QuestionNewController');
            PBS_LMSUtils_CC.addGenericUnknownErrorMessage('QuestionNewController - c_save (2)');
            return null;
        }

        PageReference refPage = new PageReference ('/' + question.id);
        refPage.setRedirect(true);
        return refPage;
    }

    public PageReference c_save_new(){

        PageReference saveRef = c_save();
        if(saveRef != null){
            PageReference refPage = Page.PBS_QuestionNew;
            refPage.getParameters().put('retURL','/'+qlid);
            refPage.setRedirect(true);
            return refPage;
        }else{
            return saveRef;
        }

    }

    public PageReference cancel(){
        String returl = ApexPages.CurrentPage().getParameters().get('retURL');
        PageReference refPage = new PageReference (returl);
        refPage.setRedirect(true);
        return refPage;
    }

}