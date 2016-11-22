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
public class PBS_LMSPlugins_Test {

    static testmethod void testPluginInterface(){
        Test.startTest();

        PBS_LMSPlugins_CC.LearningConfig config = new PBS_LMSPlugins_CC.LearningConfig();
        config.objectName = 'TestCustomLearning__c';
        config.learningVersionLookupField = 'TestCustomLearning__c';
        config.launchURL = '/apex/customLauncher';
        String launcURL = config.getLaunchURLWithNamespace();
        System.assert(launcURL != null);

        Test.stopTest();
    }

    static testmethod void testPluginInit(){
        Test.startTest();

        try{
            //PBS_LMSPlugins_CC.LearningConfig config =
            PBS_LMSPlugins_CC.getLearningPluginConfig('TestCustomLearning1');// sonar fix
            //PBS_LMSPlugins_CC.getLearningPluginConfig('TestCustomLearning1');
            System.assert(false, 'Plugin exception was not thrown');
        }catch(PBS_LMSPlugins_CC.LMSPluginsException e){
           // System.assert(true);
           System.debug(e);
        }

        Test.stopTest();
    }
    static testmethod void testPluginInitExceptionFlow(){
        Test.startTest();

        try{
            //PBS_LMSPlugins_CC.LearningConfig config = 
            PBS_LMSPlugins_CC.getLearningPluginConfig('TestCustomLearning2'); // sonar fix
            //PBS_LMSPlugins_CC.getLearningPluginConfig('TestCustomLearning2');
            System.assert(false, 'Plugin exception was not thrown');
        }catch(PBS_LMSPlugins_CC.LMSPluginsException e){
            System.assert(true, 'Plugin exception was thrown');
        }

        Test.stopTest();
    }


}