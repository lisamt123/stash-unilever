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
public with sharing class PBS_CourseStatsInDetailReport_CC {
    public List<PBS_Profile__c> userNames;
    public String selectedValue{get;set;}

     public List<SelectOption> getUserNames(){
      List<SelectOption> namesList = new List<SelectOption>();
      userNames = [SELECT id,User__r.Name from PBS_Profile__c ORDER BY User__r.Name limit :integer.valueof(System.Label.PBS_soqllimit)];
      for(PBS_Profile__c plist : userNames){
      namesList.add(new SelectOption(plist.User__r.Name,plist.User__r.Name));
      }
       return namesList;    
    }
    
     public Pagereference gnertCrseStusInDtlRprt(){
        Pagereference pageref= null;
         ID reportid =  ApexPages.currentPage().getParameters().get('id') ;
         pageref = new Pagereference('/'+reportid+'?pv0='+selectedValue);
        return pageref;
    }
}