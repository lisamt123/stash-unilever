/*  
**********************************************************
*@Description:This script is used for Section History Page
*@Author: Cognizant
*@Created Date: 28/05/2015 
**********************************************************
*/     
 var jq = jQuery.noConflict();  
jq(document).ready(function(){
/* Below script is for the Tab functionality on page load. It hides all the tabs content and shows only the first tabs content */
        jq('#ipmSecHistoryTab .ipmTabContent').show();
        jq('#ipmSecHistoryTab .ipmTabContent:last').hide();
        jq('#ipmSecHistoryTab .ipmTabs li:first').addClass('active');  
        
/* Below script is for the Tab functionality on click event. Based on the clicked li the tab is highlighted and the content related the clicked tab is displayed. Also it hides the previous opened content */      
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