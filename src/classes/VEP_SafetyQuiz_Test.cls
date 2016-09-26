@isTest
private class VEP_SafetyQuiz_Test{
    static testMethod void test_VEP_SafetyQuiz_VF(){
        List<VEP_Question__c> listQues = new List<VEP_Question__c>();
        List<VEP_Answer__c> listAnsw = new List<VEP_Answer__c>();
        integer i=0;
        
        VEP_Question__c Q1= new VEP_Question__c();
        Q1.question__c = 'Question1';
        listQues.add(Q1);
        VEP_Question__c Q2= new VEP_Question__c();
        Q2.question__c = 'Question2';
        listQues.add(Q2);
        VEP_Question__c Q3= new VEP_Question__c();
        Q3.question__c  = 'Question3';
        listQues.add(Q3);
        VEP_Question__c Q4= new VEP_Question__c();
        Q4.question__c = 'Question4';
        listQues.add(Q4);
        VEP_Question__c Q11= new VEP_Question__c();
        Q11.question__c = 'Question11';
        listQues.add(Q11);
        VEP_Question__c Q12= new VEP_Question__c();
        Q12.question__c = 'Question12';
        listQues.add(Q12);
        VEP_Question__c Q13= new VEP_Question__c();
        Q13.question__c = 'Question13';
        listQues.add(Q13);
        VEP_Question__c Q14= new VEP_Question__c();
        Q14.question__c = 'Question14';
        listQues.add(Q14);
        insert listQues;
        
        VEP_Answer__c a1 = new VEP_Answer__c();
        a1.answer__c='Answer1';
        a1.Question__c = Q1.id;
        a1.is_true__c = true;
        listAnsw.add(a1);
        VEP_Answer__c a2 = new VEP_Answer__c();
        a2.answer__c='Answer2';
        a2.Question__c = Q2.id;
        a2.is_true__c = true;
        listAnsw.add(a2);
        VEP_Answer__c a3 = new VEP_Answer__c();
        a3.answer__c='Answer3';
        a3.Question__c = Q3.id;
        a3.is_true__c = true;
        listAnsw.add(a3);
        VEP_Answer__c a4 = new VEP_Answer__c();
        a4.answer__c='Answer4';
        a4.Question__c = Q4.id;
        a4.is_true__c = true;
        listAnsw.add(a4);
        VEP_Answer__c a11 = new VEP_Answer__c();
        a11.answer__c='Answer11';
        a11.Question__c = Q11.id;
        listAnsw.add(a11);
        VEP_Answer__c a12 = new VEP_Answer__c();
        a12.answer__c='Answer12';
        a12.Question__c = Q12.id;
        a12.is_true__c = true;
        listAnsw.add(a12);
        VEP_Answer__c a13 = new VEP_Answer__c();
        a13.answer__c='Answer13';
        a13.Question__c = Q13.id;
        a13.is_true__c = true;
        listAnsw.add(a13);
        VEP_Answer__c a14 = new VEP_Answer__c();
        a14.answer__c='Answer14';
        a14.Question__c = Q14.id;
        a14.is_true__c = true;
        listAnsw.add(a14);
        insert listAnsw;
        
        VEP_Visitor__c visitor = new VEP_Visitor__c();
        visitor.name='Test Visitor';        
        insert visitor;
        visitor = [select id,VEP_number__c from VEP_Visitor__c where id=:visitor.id];
        
        Test.startTest();
        Apexpages.currentpage().getparameters().put('VEPnumber',visitor.VEP_number__c);
        VEP_SafetyQuiz_CC safetyQuiz = new VEP_SafetyQuiz_CC();
        //VEP_SafetyQuiz_CC.AnswerWrapper  AnsW = new VEP_SafetyQuiz_CC.AnswerWrapper(aq11);
        safetyQuiz.getQuesRecords();
        System.assert(safetyQuiz.getQuesRecords() != null);
        safetyQuiz.previous();
        safetyQuiz.next();
        safetyQuiz.submitTest();
        safetyQuiz.showQApage();        
        safetyQuiz.closepage();
        safetyQuiz.back2Video();
        safetyQuiz.correctPercentage=70;
        safetyQuiz.visitorPass();
        safetyQuiz.generatePdf();
        List<VEP_SafetyQuiz_CC.AnswerWrapper> li = new List<VEP_SafetyQuiz_CC.AnswerWrapper>();
       
        safetyQuiz.mapQAnsWrapper.get(Q1.id)[0].checked=true;
        safetyQuiz.submitTest();
        System.assertEquals(10,safetyQuiz.correctPercentage);
      
        
        boolean test1 = safetyQuiz.hasNext;
        boolean test2 = safetyQuiz.hasPrevious;
        integer test3 = safetyQuiz.pageNumber;
        
        VEP_Visitor_Pass__c visitorPass = new VEP_Visitor_Pass__c ();
        visitorPass.Visitor__c = visitor.id; 
        insert visitorPass;
        System.assert(visitorPass.id != null);
        VEP_SafetyQuiz_CC safetyQuiz1 = new VEP_SafetyQuiz_CC();
        
        Apexpages.currentpage().getparameters().put('VEPnumber',null);
        VEP_SafetyQuiz_CC safetyQuiz2 = new VEP_SafetyQuiz_CC();
        
        Test.stopTest();
        
       
        
    }
}