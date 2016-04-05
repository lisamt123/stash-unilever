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
private class PBS_LMSTemplateController_Test{

    static testMethod void testInit(){
        createTestCustomSetting(false);
        PBS_LMSTemplateController_CC cont = new PBS_LMSTemplateController_CC();
        // Default value should be false
        System.assertEquals(cont.customJSEnabled ,false);
    }

    static testMethod void testInitWithSFHeader(){
        createTestCustomSetting(true);
        PBS_LMSTemplateController_CC cont = new PBS_LMSTemplateController_CC();
        // Default value should be false
        System.assertEquals(cont.customJSEnabled ,false);
    }

    static void createTestCustomSetting(Boolean showSFHeader){
        almond__Almond_Settings__c cs = new almond__Almond_Settings__c();
        cs.almond__Company_Logo__c = 'https://www.salesforce.com/logo.png';
        cs.almond__Header_Background_Color__c = '#2C82B9';
        cs.almond__Header_Text_Color__c = 'DBE5F2';
        cs.SetupOwnerId = null; //Org-wide default
        cs.almond__Disable_Track_Achievements__c = true;
        cs.almond__Disable_Future_Progress_Calculation__c = true;
        cs.almond__Show_Salesforce_Header__c = showSFHeader;
        insert cs;
    }

}