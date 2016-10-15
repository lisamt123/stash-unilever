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
@isTest
public class PBS_TestLearningData_Test {
/*
    public static List<Almond__Learning__c> createTestLearning(Integer iNum, String recordType, Boolean bSyncProgress){
        List<Almond__Learning__c> lResult = new List<Almond__Learning__c>();
        String learningObjectName = PBS_LMSUtils_CC.getPackageNamespace()+'Almond__Learning__c';
        List<RecordType> learningRT = [select Id, Name, DeveloperName from RecordType where SobjectType = :learningObjectName and DeveloperName =: recordType];

        for(Integer i = 0; i < iNum; i++){
            Almond__Learning__c olearning = new Almond__Learning__c();
            olearning.Almond__Description__c = 'dummy description';
            olearning.Almond__Duration__c = TestUtilClass.getRandomInteger(5, 200); //minutes
            olearning.Almond__Sync_progress__c = bSyncProgress;
            olearning.RecordTypeId = learningRT.get(0).Id;

            lResult.add(olearning);
        }

        insert lResult;
        return lResult;
    }


    public static List<Almond__Learning_Category__c> createTestLearningCategories(Integer iNum){
        List<Almond__Learning_Category__c> lResult = new List<Almond__Learning_Category__c>();
        for(Integer i = 0; i < iNum; i++){
            Almond__Learning_Category__c lc = new Almond__Learning_Category__c();
            lc.Name =  'Test Category '+i;
            lResult.add(lc);
        }

        insert lResult;
        return lResult;
    }

    public static List<Almond__Quiz__c> createTestQuiz(List<Almond__Learning__c> learnings){
        List<Almond__Quiz__c> lResult = new List<Almond__Quiz__c>();

        for(Almond__Learning__c ol : learnings){
            Almond__Quiz__c oquiz = new Almond__Quiz__c();
            oquiz.Almond__Description__c = 'dummy description';
            oquiz.Almond__Learning__c = ol.Id;
            oquiz.Almond__Max_Attempts__c = PBS_TestUtilClass.getRandomInteger(0, 20);
            oquiz.Almond__Passing_Score__c = 70;

            lResult.add(oquiz);
        }

        insert lResult;
        return lResult;
    }

    public static List<Almond__Quiz__c> createTestQuiz(List<Almond__Learning__c> learnings, Map<String,Object> params){
        List<Almond__Quiz__c> lResult = new List<Almond__Quiz__c>();

        for(Almond__Learning__c ol : learnings){
            Almond__Quiz__c oquiz = new Almond__Quiz__c();
            oquiz.Almond__Description__c = 'dummy description';
            oquiz.Almond__Learning__c = ol.Id;
            oquiz.Almond__Max_Attempts__c = PBS_TestUtilClass.getRandomInteger(0, 20);
            oquiz.Almond__Passing_Score__c = (Decimal)params.get('Almond__Passing_Score__c');
            lResult.add(oquiz);
        }

        insert lResult;
        return lResult;
    }

    public static List<Almond__Question_Line__c> createTestQuestionLine(List<Almond__Quiz__c> lquiz, Integer iNum){
        List<Almond__Question_Line__c> lResult = new List<Almond__Question_Line__c>();

        for(Almond__Quiz__c oquiz : lquiz){
            for(Integer i = 0; i < iNum; i++){
                Almond__Question_Line__c oql = new Almond__Question_Line__c();
                oql.Almond__Description__c = 'dummy description';
                oql.Almond__Order__c = i;
                oql.Almond__Quiz__c = oquiz.Id;

                lResult.add(oql);
            }
        }

        insert lResult;
        return lResult;
    }

    public static List<Almond__Question__c> createTestQuestions(List<Almond__Question_Line__c> qlines, Integer iNum, String questionType){
        List<Almond__Question__c> lResult = new List<Almond__Question__c>();
        Map<String,List<Almond__Question__c>> mResult = new Map<String,List<Almond__Question__c>>();

        for(Almond__Question_Line__c oql : qlines){
            for(Integer i = 0; i < iNum; i++){
                Almond__Question__c oq = new Almond__Question__c();
                String qtype = String.isBlank(questionType) ? PBS_TestUtilClass.getRandomQuestionType() : questionType;

                if(!mResult.containsKey(qtype)){
                    mResult.put(qtype, new List<Almond__Question__c>());
                }

                if(qtype == 'Boolean'){
                    oq.Almond__Correct_Boolean__c = (Math.roundToLong(Math.random()) == 1) ? 'true' : 'false';
                }

                if(qtype == 'Number'){
                    oq.Almond__Correct_Number__c = PBS_TestUtilClass.getRandomInteger(1, 100);
                }

                oq.Almond__Description__c = 'dummy description';
                oq.Almond__Description_RTA__c = 'dummy large description';
                oq.Almond__Order__c = i;
                oq.Almond__Question_Line__c = oql.Id;
                oq.Almond__Type__c = qtype;
                oq.Almond__Answer_Sequence__c = null;


                mResult.get(qtype).add(oq);
            }
        }

        //handle select one & select multiple
        //iterate result maps and create answer sequence
        List<Almond__Question__c> lselectone = mResult.get('SelectOneQuestion');
        List<Almond__Question__c> lselectmultiple = mResult.get('SelectMultipleQuestion');

        if(lselectone != null && !lselectone.isEmpty()){
            List<Almond__Answer_Sequence__c> aseq = createTestAnswerSequences(lselectone.size(), 'SelectOneQuestion');
            Integer countSelOne = lselectone.size() - 1;

            for(Almond__Question__c qst : mResult.get('SelectOneQuestion')){
                qst.Almond__Answer_Sequence__c = aseq.get(countSelOne).Id;
                countSelOne--;
            }
        }

        if(lselectmultiple != null && !lselectmultiple.isEmpty()){
            List<Almond__Answer_Sequence__c> aseqM = createTestAnswerSequences(lselectmultiple.size(), 'SelectMultipleQuestion');
            Integer countSelMult = lselectmultiple.size() - 1;

            for(Almond__Question__c qst : lselectmultiple){
                qst.Almond__Answer_Sequence__c = aseqM.get(countSelMult).Id;
                countSelMult--;
            }
        }

        for(String key : mResult.keySet()){
            lResult.addAll(mResult.get(key));
        }

        insert lResult;
        return lResult;
    }

    public static List<Almond__Answer_Sequence__c> createTestAnswerSequences(Integer iNum, String qtype){
        List<Almond__Answer_Sequence__c> lResult = new List<Almond__Answer_Sequence__c>();

        for(Integer i = 0; i < iNum; i++){
            Almond__Answer_Sequence__c oaseq = new Almond__Answer_Sequence__c();
            oaseq.Almond__Internal_Notes__c = 'dummy internal notes';

            lResult.add(oaseq);
        }

        insert lResult;
        //call create answer seq items
        List<Almond__Answer_Sequence_Item__c> lasi = createTestAnswerSeqItems(lResult, PBS_TestUtilClass.getRandomInteger(2, 6), qtype);
        return lResult;
    }

    public static List<Almond__Answer_Sequence_Item__c> createTestAnswerSeqItems(List<Almond__Answer_Sequence__c> ansSeq, Integer iNum, String qtype){
        List<Almond__Answer_Sequence_Item__c> lResult = new List<Almond__Answer_Sequence_Item__c>();

        for(Almond__Answer_Sequence__c oas : ansSeq){
            List<Almond__Answer_Sequence_Item__c> lResultInt = new List<Almond__Answer_Sequence_Item__c>();

            for(Integer i = 0; i < iNum; i++){
                Almond__Answer_Sequence_Item__c oasi = new Almond__Answer_Sequence_Item__c();
                oasi.Almond__Item_Id__c = PBS_TestUtilClass.getRandomUniqueString(20);
                oasi.Almond__Answer_Sequence__c = oas.Id;
                oasi.Almond__Answer_Text__c = PBS_TestUtilClass.getRandomSentence(10); //.substring(1,254);
                oasi.Almond__Is_Correct_Answer__c = false;
                oasi.Almond__Order__c = i;

                lResultInt.add(oasi);
            }

            if(qtype == 'SelectOneQuestion'){
                lResultInt.get(TestUtilClass.getRandomInteger(0, iNum)).Almond__Is_Correct_Answer__c = true;
            }

            if(qtype == 'SelectMultipleQuestion'){
                for(Integer i = 0; i < PBS_TestUtilClass.getRandomInteger(1, iNum); i++){
                    lResultInt.get(PBS_TestUtilClass.getRandomInteger(0, iNum)).Almond__Is_Correct_Answer__c = true;
                }
            }
            lResult.addAll(lResultInt);
        }

        insert lResult;
        return lResult;
    }

    public static Map<String, Almond__Response__c> createTestQuestionResponses(set<Id> qlineIds, Id UserId, Id learningAssignmentId){
        Map<String, Almond__Response__c> mResult = new Map<String, Almond__Response__c>();

        Set<String> typeOne = new Set<String>{'Text','Number','Boolean'};
        List<Almond__Question__c> lquestions1 = [select Id,
                                            Almond__Answer_Sequence__c,
                                            Almond__Correct_Boolean__c,
                                            Almond__Correct_Number__c,
                                            Almond__Question_Line__c,
                                            Almond__Type__c from Almond__Question__c where Almond__Question_Line__c in :qlineIds and Almond__Type__c in :typeOne];

        if(!lquestions1.isEmpty()){
            for(Almond__Question__c q1: lquestions1){
                Almond__Response__c response = new Almond__Response__c();
                if(q1.Almond__Type__c == 'Text'){
                    response.Almond__Response_Text__c = 'Dummy Value';
                    response.Almond__Response_Text_Long__c = 'Dummy Value Long';
                }

                if(q1.Almond__Type__c == 'Number'){
                    response.Almond__Number_Response__c = q1.Almond__Correct_Number__c;
                }

                if(q1.Almond__Type__c == 'Boolean'){
                    response.Almond__Boolean_Response__c = q1.Almond__Correct_Boolean__c;
                }

                response.Almond__Learning_Assignment__c = learningAssignmentId;
                response.Almond__Question__c = q1.Id;
                response.Almond__User__c = UserId;

                mResult.put(q1.Id, response);
            }
        }

        Set<String> typeTwo = new Set<String>{'SelectOneQuestion','SelectMultipleQuestion'};
        List<Almond__Question__c> lquestions2 = [select Id,
                                            Almond__Answer_Sequence__c,
                                            Almond__Correct_Boolean__c,
                                            Almond__Correct_Number__c,
                                            Almond__Question_Line__c,
                                            Almond__Type__c from Almond__Question__c where Almond__Question_Line__c in :qlineIds and Almond__Type__c in :typeTwo and Almond__Answer_Sequence__c != null];

        if(!lquestions2.isEmpty()){

            set<Id> asSet = new Set<Id>();
            for(Almond__Question__c oq2 : lquestions2){
                asSet.add(oq2.Almond__Answer_Sequence__c);
            }

            Map<String, List<Almond__Answer_Sequence_Item__c>> mAnsSeqItem = new Map<String, List<Almond__Answer_Sequence_Item__c>>();

            for(Almond__Answer_Sequence_Item__c oAnsSeqItem : [select Id,
                                                        Almond__Item_Id__c,
                                                        Almond__Answer_Sequence__c,
                                                        Almond__Answer_Text__c
                                                        from Almond__Answer_Sequence_Item__c
                                                        where Almond__Answer_Sequence__c in :asSet and Almond__Is_Correct_Answer__c = true]){

                if(mAnsSeqItem.containsKey(oAnsSeqItem.Almond__Answer_Sequence__c)){
                    mAnsSeqItem.get(oAnsSeqItem.Almond__Answer_Sequence__c).add(oAnsSeqItem);
                }else{
                    mAnsSeqItem.put(oAnsSeqItem.Almond__Answer_Sequence__c, new List<Almond__Answer_Sequence_Item__c>{oAnsSeqItem});
                }
            }//for

            for(Almond__Question__c q2: lquestions2){
                Almond__Response__c response = new Almond__Response__c();
                if(q2.Almond__Type__c == 'SelectOneQuestion'){
                    response.Almond__Response_Answer_Sequence_Label__c = mAnsSeqItem.get(q2.Almond__Answer_Sequence__c).get(0).Almond__Answer_Text__c;
                    response.Almond__Response_Answer_Sequence_Long__c = mAnsSeqItem.get(q2.Almond__Answer_Sequence__c).get(0).Almond__Item_Id__c;
                }

                if(q2.Almond__Type__c == 'SelectMultipleQuestion'){
                    String labels = '';
                    String longs = '';
                    for(Almond__Answer_Sequence_Item__c oasi : mAnsSeqItem.get(q2.Almond__Answer_Sequence__c)){
                        labels += oasi.Almond__Answer_Text__c + ';';
                        longs += oasi.Almond__Item_Id__c + ';';
                    }

                    response.Almond__Response_Answer_Sequence_Label__c = labels;
                    response.Almond__Response_Answer_Sequence_Long__c = longs;
                }

                response.Almond__Response_Answer_Sequence__c = q2.Almond__Answer_Sequence__c;
                response.Almond__Learning_Assignment__c = learningAssignmentId;
                response.Almond__Question__c = q2.Id;
                response.Almond__User__c = UserId;

                mResult.put(q2.Id, response);
            }//for q2

        }//if lquestions2

        return mResult;
    }

    public static List<Almond__Training_Resource__c> createTestTrainingResource(List<Almond__Learning__c> learnings){
        List<Almond__Training_Resource__c> lResult = new List<Almond__Training_Resource__c>();

        for(Almond__Learning__c olearn : learnings){
            Almond__Training_Resource__c tresource = new Almond__Training_Resource__c();
            tresource.Name = PBS_TestUtilClass.getRandomUniqueString(20);
            tresource.Almond__Add_training_parameters_to_URL__c = false;
            tresource.Almond__Prevent_completion_on_launch__c = false;
            tresource.Almond__Description__c = PBS_TestUtilClass.getRandomSentence(5);
            tresource.Almond__Display_in_Iframe__c = false;
            tresource.Almond__Learning__c = olearn.Id;
            tresource.Almond__Resource_URL__c = 'https://www.' + PBS_TestUtilClass.getRandomUniqueString(10) + '.com';

            lResult.add(tresource);
        }

        insert lResult;
        return lResult;
    }

    public static List<Almond__Task__c> createTestTask(List<Almond__Learning__c> learnings){
        List<Almond__Task__c> lResult = new List<Almond__Task__c>();

        for(Almond__Learning__c olearn : learnings){
            Almond__Task__c task = new Almond__Task__c();
            task.Name = PBS_TestUtilClass.getRandomUniqueString(20);
            task.Almond__Add_training_parameters_to_URL__c = false;
            task.Almond__Description__c = PBS_TestUtilClass.getRandomSentence(5);
            task.Almond__Enable_Image_Upload__c = false;
            task.Almond__External_Resource_Name__c = PBS_TestUtilClass.getRandomSentence(3);
            task.Almond__External_Resource_Target__c = 'blank';
            task.Almond__External_Resource_URL__c = 'https://www.' + PBS_TestUtilClass.getRandomUniqueString(10) + '.com';
            task.Almond__Learning__c = olearn.Id;
            task.Almond__Requires_Manager_Approval__c = false;

            lResult.add(task);
        }

        insert lResult;
        return lResult;
    }

    public static void publishLearning(Id learningId,String learningType,Id learningContentId,Boolean askForVersionSelection){

        Almond__Learning__c learning = new Almond__Learning__c(id=learningId);
        Map<String,String> rtFieldMapping = new Map<String,String>{
           'task'=>'Almond__Task__c'
           ,'quiz'=>'Almond__Quiz__c'
           ,'resource'=>'Almond__Training_Resource__c'
        };

        Almond__Learning_Version__c lVersion = new Almond__Learning_Version__c();
        lVersion.Almond__Learning__c = learningId;
        lVersion.Almond__Version_selection_behavior__c = askForVersionSelection?'Ask user for version selection':'Update version on launch';
        lVersion.put(rtFieldMapping.get(learningType),learningContentId);
        lVersion.Almond__Type__c = 'Published';
        lVersion.Almond__Version__c = 1;
        insert lVersion;

        //Update learning with latest published version reference
        learning.Almond__Published__c = true;
        learning.Almond__Current_Published_Version__c = lVersion.Id;
        update learning;
    }
*/
}