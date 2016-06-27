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
public with sharing class PBS_LMSHeaderController_CC {

    public /*transient*/ String loggedUsername {get;set;}
    public /*transient*/ String loggedUsernameImageUrl { get; set; }
    public /*transient*/ String section {get;set;}
    public /*transient*/ String customLogo {get; private set;}
    public /*transient*/ String backgroundColor {get; private set;}
    public /*transient*/ String textColor {get; private set;}
    public /*transient*/ String textHoverColor {get; private set;}
    public /*transient*/ String backToSFURL {get; private set;}
    public /*transient*/ String customSectionName {get; private set;}
    public /*transient*/ String customSectionURL {get; private set;}
    public /*transient*/ Boolean hideBackToSFButton {get;private set;}

   public /*transient*/ List<PBS_AlmondNavigation__c> navigationItems {get;private set;}

    public PBS_LMSHeaderController_CC (){
        loggedUsername         = UserInfo.getFirstName();
        Id uId                 = UserInfo.getUserId();

        // No need to enforce CRUD/FLS check here, all users are authorized to view the object and smallphoto url
        List<User> users       = [select SmallPhotoUrl from User where Id = :uId];
        loggedUsernameImageUrl = users.get(0).SmallPhotoUrl;

        String pageURL         = ApexPages.currentPage().getUrl().toLowerCase();

        customLogo             = almond.LMSSettings.getCustomLogo();
        backgroundColor        = almond.LMSSettings.getHeaderBackgroundColor();
        textColor              = almond.LMSSettings.getHeaderTextColor();
        textHoverColor         = almond.LMSSettings.getHeaderTextHoverColor();
        backToSFURL            = almond.LMSSettings.getBacktoSFUrl();
        hideBackToSFButton     = false;
        
        //Removed - As it is public in package
        //almond.LMSSettings.getHideBackToSFButton();

        //customSectionName = LMSSettings.getCustomHeaderName();
        //customSectionURL  = LMSSettings.getCustomHeaderURL();
        //navigationItems   = PBS_AlmondNavigation__c.getValues();

        // find section by current page
        //if(pageURL.contains('mytraining') || pageURL.contains('trainingplandetail')){
        //    section = 'mytraining';
        //}else if(pageURL.contains('myprofile') || (pageURL.contains('achievementsusersearch'))){
        //    section = 'myprofile';
        //}else if(pageURL.contains('catalog') || pageURL.contains('trainingplanpreview') || pageURL.contains('trainingplanssearch')){
        //    section = 'catalog';
        //}else if(pageURL.contains('trainingtracks') || pageURL.contains('trainingtrackdetail')){
        //    section = 'tracks';
        //}else if(customSectionURL != null && customSectionURL.toLowerCase().contains(pageURL)){
        //    section = 'custom';
        //}

        // Custom navigatio code 
        navigationItems    = [
            SELECT
                Name, Active__c, Label__c , Order__c , SectionOtherPages__c , URL__c, RenderAsDisabled__c
            FROM
                PBS_AlmondNavigation__c
            WHERE
                Active__c = true
            ORDER BY
                Order__c, Name
        ];


        section = null;
        List<String> sections;
        for (PBS_AlmondNavigation__c item : navigationItems) {
         
            if (pageURL.contains(item.URL__c)) {
                section = item.Name;
            } else if (!String.isBlank(item.SectionOtherPages__c)) {
           
                sections = item.SectionOtherPages__c.split(',');
                for (String sectionPart : sections) {
                    if (pageURL.contains(sectionPart)) {
                    
                        section = item.Name;
                        break;
                    }
                }
            }

            if (section != null) {
                break;
            }
        }
    }
}