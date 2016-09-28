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
global with sharing class PBS_SubFolderController_CC {
    public string selectedGeography{get;set;}
    public string selectedWorkLevel{get;set;}
    public string selectedJobProfile{get;set;}
    public string selectedCourseType{get;set;}
    public PBS_Learning_Category__c learningcategory {get; private set;}
	public String categoryId;
    public PBS_SubFolderController_CC(){
        categoryId = Apexpages.currentPage().getParameters().get('id');
        if(categoryId != null){
        List<PBS_Learning_Category__c> lcats = PBS_LMSService_CC.getLearningCategories(categoryId);
            if(lcats.size()>0){
                learningcategory = lcats.get(0);
            }
        }
    }
    public List<SelectOption> getGeographyOptions(){
    	List<SelectOption> geographyList = new List<SelectOption>();
        Schema.DescribeFieldResult fieldresult = PBS_Training_Plan_Category__c.Geography__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple){
        geographyList.add(new SelectOption(f.getValue(),f.getValue()));
        }
        return geographyList;
    }


    public List<SelectOption> getWorkLevelOptions(){
        List<SelectOption> worklevellist = new List<SelectOption>();
        Schema.DescribeFieldResult fieldresult = PBS_Training_Plan_Category__c.Work_Level__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple){
        worklevellist.add(new SelectOption(f.getValue(),f.getValue()));
        }
        return worklevellist;
    }
    
    public List<SelectOption> getJobProfileOptions(){
        List<SelectOption> jobprofilelist = new List<SelectOption>();
        Schema.DescribeFieldResult fieldresult = PBS_Training_Plan_Category__c.PlannerType__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple){
        jobprofilelist.add(new SelectOption(f.getValue(),f.getValue()));
        }
        return jobprofilelist;
    }
    
    public List<SelectOption> getCourseTypeOptions(){
        List<SelectOption> journeytype = new List<SelectOption>();
        Schema.DescribeFieldResult fieldresult = PBS_Training_Plan_Category__c.Journey_Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple){
        journeytype.add(new SelectOption(f.getValue(),f.getValue()));
        }
        return journeytype;
    }

    public PageReference filterResults(){
       
        PageReference pageRef = Page.PBS_TrainingCatalogDetail;
        pageRef.getParameters().put('id',categoryId);
        pageRef.getParameters().put('geo',selectedGeography);
        pageRef.getParameters().put('course',selectedCourseType);
        pageRef.getParameters().put('profile',selectedJobProfile);
        pageRef.getParameters().put('worklevel',selectedWorkLevel);
        return pageRef;
    }
    
    private String getCategory(string cid){
        if(cid != null){
           return [Select id,Name from PBS_Learning_Category__c WHERE Id =: categoryId LIMIT 1].Name;
        }
        else{
            return null;
        }
        
    }

}