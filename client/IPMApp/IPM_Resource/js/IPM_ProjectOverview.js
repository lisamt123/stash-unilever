/*  
***********************************************************************************
*@Description:This script is used for project overview page specific interaction
*@Author: Cognizant
*@Created Date: 28/05/2015 
***********************************************************************************
*/
 var jq = jQuery.noConflict();
 jq(document).ready(function(){
     hilightTaskScript();
 
 /* Below script replace a text with a specific time format. */
    jq(".dueDate").each(function () {
        jq(this).text(jq(this).text().replace('00:00:00 GMT',''));
    });
    
    /* Below script works on click event. It hides the modal. */
    jq('.modal-header-bet .close').click(function() {  
        jq('#myModal').modal('hide');
    });
 /* Below script works on click event. If the condition is true it shows the alerts content with the text. Also it replaces '-' with '+' else vice versa. */
     jq(document).on('click', '.alertAccordian', function() {
        var $this = jq(this);
         if (jq('.alertContent').is(':visible')) {
             $this.removeClass('fa-minus');
             $this.addClass('fa-plus');
             jq('.alertContent').hide();
             jq('.alerttext').show();
         } else {
             jq('.alerttext').hide();
             $this.addClass('fa-minus');
             $this.removeClass('fa-plus');
             jq('.alertContent').show();
         }
     });
     
 /* Below works on click event. It is to open the modal */
     jq(document).on('click', '.openModal', function() {
         var $this = jq(this);
         var modalDlg = jq('#ipmModal .modal-dialog');
         var url = $this.attr('value');
         var modalTitle = $this.attr('modalTitle');
         openModal(url);
         jq('#ipmModal .modal-title').html(modalTitle);
         modalDlg.width('900px');
         modalDlg.height('90%');
     });

     /* Below works on click event. It is to remove a div. */
     jq('.closeMessage').on('click', function() {
         jq(this).closest('div').remove();
     }); 

  /* Below script works on click event. When clicked on the button it changes the css styles of the modal. */
    jq(document).on('click', '.shipTrade', function(e) { 
        e.preventDefault ? e.preventDefault() : e.returnValue = false;                        
        jq('#shipToPLE .modal-dialog').css({'margin-top':'10%','z-index':'999'});     
    }); 
     
 /*BET Section*/
 
 /* Below script replace a text with a specific time format. */
 jq(".dueDate").each(function () {
      jq(this).text(jq(this).text().replace('00:00:00 GMT',''));
 });

  /* Below script works on click event. When clicked on the button it changes the css styles of the modal. */
 jq(document).on('click', '.createBET', function(e) { 
    e.preventDefault ? e.preventDefault() : e.returnValue = false;  
     jq('#initiateProjectBKPanel .modal-dialog').width('80%');
    jq('#initiateProjectBKPanel .modal-dialog').height('90%');                        
    jq('#initiateProjectBKPanel .modal-dialog').css({'margin-top':'2%','z-index':'999'});     
}); 

if(IPMApp.showSuggestedMembers === true && window.location.href.indexOf("showMembers") > -1){
       document.getElementById("suggestedMembersButton").click();
   }else if (window.location.href.indexOf("createBET") > -1){
        document.getElementById("createBETButton").click();
}
     
var statusCheckApproved = IPMApp.DocumentStatus;

  /* Below script works on click event. If the condition is true the page will be reloaded. */
    jq("#ipmModal .close").on("click", function() 
        {
           if (jq("#ipmModal .modal-title").text().indexOf("Comment") !== -1) {
           window.top.location.href = IPMApp.ProjectOverviewPage+'?id='+IPMApp.projectId;
        }
});
    
jq('.skipButtoncontainer .ipmButton').removeClass('btn');

  /* Below script works on click event. When clicked on the link it hides one div and displays another div. Also it adds a css class for two elements. */
jq( ".unfollowLink" ).click(function( event ) {
        event.preventDefault();
        document.getElementById('followchatter').style.display = "none";
        document.getElementById('chatterblock').style.display = "block";
    }); 
    jq('.zen-media.zen-mediaExt img.chatter-followIcon').addClass('chatterIcon');
    jq('.zen-media.zen-mediaExt img.chatter-checkedIcon').addClass('chatterIcon');
});

/* Below function checks the checkboxes based on the selected class */
function compScript(){
    jq('.ipmCheckbox > input[type=checkbox].selected').each(function(){
         jq(this).attr("checked", true);
    }); 
}

/* Below function hides one div and displays another div. */
function showDiv() {
    document.getElementById('followchatter').style.display = "block";
    document.getElementById('chatterblock').style.display = "none";
}  

 /* Below function redirects the page to Project overview page. */
function moveToNextDoc(){
    window.top.location.href=IPMApp.ProjectOverviewPage+'?id='+IPMApp.projectId+'&showMembers=true&createBET=true'
}

/* Below function contains the script which has the tooltip functionality. This function is called when the rerendering happens and the script will run again */
function hilightTaskScript(){
    jq(".info").tooltip({ position: { my: 'center top', at: 'center bottom+10' }});
    jq(".deleteChannel").tooltip({ position: { my: 'center top', at: 'center bottom+10' }});    
    jq(".arrow-left").tooltip({ position: { my: 'left top', at: 'center bottom+10' },tooltipClass:'ui-lefttip'}); 
    jq(".aTabs").find("input[type=checkbox]:checked").closest(".aTabs").addClass("active");
}
/*JQUERY: STOPWATCH & COUNTDOWN*/
jq(document).ready(function() {
 (function(jq){    
        jq.extend({            
            APP : {
                formatTimer : function(a) {
                    if (a < 10) {
                        a = '0' + a;
                    }                              
                    return a;
                }, 
                startTimer : function(dir) { 
                    var a;                     
                    jq.APP.dir = dir; // save type
                    jq.APP.d1 = new Date(); // get current date
                    switch(jq.APP.state) {  
                        case 'pause' :
                            jq.APP.t1 = jq.APP.d1.getTime() - jq.APP.td;   // resume timer ,get current timestamp (for calculations) and substract time difference between pause and now
                        break;
                        default :
                        jq.APP.t1 = jq.APP.d1.getTime();  // get current timestamp (for calculations)
                            if (jq.APP.dir === 'cd') {
                                var hms = IPMApp.countDownProjectStop;   // your input string
                                var a1 = hms.split(':'); // split it at the colons
                                var seconds_val = (+a1[0]) * 60 * 60 + (+a1[1]) * 60 + (+a1[2]);  // minutes are worth 60 seconds. Hours are worth 60 minutes.
                                jq.APP.t1 += parseInt(seconds_val)*1000;
                            }     
                        break;
                
                    }                                   
                    jq.APP.state = 'alive';    // reset state
                    jq('#' + jq.APP.dir + '_status').html('Running');
                    jq.APP.loopTimer();    // start loop 
                },
                loopTimer : function() {
                    var td;
                    var d2,t2;
                    var ms = 0;
                    var s  = 0;
                    var m  = 0;
                    var h  = 0;
                    if (jq.APP.state === 'alive') {
                        d2 = new Date(); // get current date and convert it into
                        t2 = d2.getTime();  // timestamp for calculations 
                        if (jq.APP.dir === 'sw') {
                            td = t2 - jq.APP.t1;// calculate time difference between initial and current timestamp
                        } else {
                            td = jq.APP.t1 - t2; //reversed if countdown
                            if (td <= 0) {
                                jq.APP.endTimer(function(){
                                    jq.APP.resetTimer(); // if time difference is 0 end countdown
                                    jq('#' + jq.APP.dir + '_status').html('Ended & Reset');
                                });
                            }    
                        }    
                        ms = td%1000;
                        if (ms < 1) {
                            ms = 0;
                        } else {    
                            s = (td-ms)/1000;
                            if (s < 1) {
                                s = 0;
                            } else {
                                var m = (s-(s%60))/60;
                                if (m < 1) {
                                    m = 0;
                                } else {
                                    var h = (m-(m%60))/60;
                                    if (h < 1) {
                                        h = 0;
                                    }                             
                                }    
                            }
                        }
                        ms = Math.round(ms/100); // substract elapsed minutes & hours
                        s  = s-(m*60);
                        m  = m-(h*60);                                
                        jq('#' + jq.APP.dir + '_s').html(jq.APP.formatTimer(s));
                        jq('#' + jq.APP.dir + '_m').html(jq.APP.formatTimer(m));
                        jq('#' + jq.APP.dir + '_h').html(jq.APP.formatTimer(h));
                        jq.APP.t = setTimeout(jq.APP.loopTimer,1); // loop
                    } else {
                        clearTimeout(jq.APP.t);     // kill loop
                        return true;
                    }     
                }       
            }
        });
       window.onload = function(){
           jq.APP.startTimer('cd');
        }           
    })(jQuery);
});