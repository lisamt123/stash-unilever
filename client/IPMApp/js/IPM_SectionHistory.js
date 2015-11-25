/*  
**********************************************************
*@Description:This script is used for Section History Page
*@Author: Cognizant
*@Created Date: 28/05/2015 
**********************************************************
*/ 	   
 var jq = jQuery.noConflict();  
 
 /* Below code is for the tab functionality */
jq(document).ready(function(){
        jq('#ipmSecHistoryTab .ipmTabContent').show();
        jq('#ipmSecHistoryTab .ipmTabContent:last').hide();
        jq('#ipmSecHistoryTab .ipmTabs li:first').addClass('active');                
        jq('#ipmSecHistoryTab .ipmTabs li').on('click', function(e){ 
            e.preventDefault();
            jq('#ipmSecHistoryTab .ipmTabs li').removeClass('active');  
            var $this = jq(this);   
            var getId = $this.attr('class').split(" ");
            var rdData1 = getId[0];
            jq('#ipmSecHistoryTab .ipmTabContent').hide();
            $this.addClass('active');
            jq('#'+rdData1).fadeIn("fast");                    
        }); 
});     