/*  
 ********************************************************************************
 *@Description:This script is used for IPM Posquestions page specific interaction
 *@Author: Cognizant
 *@Created Date: 28/05/2015 
 ********************************************************************************
 */
var jq = jQuery.noConflict();
jq(document).ready(function() {
    waitForElement();
});

/* Below function calls slider functions to set the sliders on page load. */
function waitForElement() {
    jq("#showQues").show();
    initSlider();
    initSlider1();
}

/* Below function contains the script for the slider functionality in first Otif list. 
It contains the complete functionality code when user clicks on the options the pointer ball moves to the clicked option. 
Also it saves the selected option when clicked on it. */
function initSlider() {
    jq("[data-toggle=tooltip]").tooltip();
    var itemsProposed = ['Select', '1', '3', '5'];
    var s = jq(".sliderStat");
    var score;
    var PointerT = 100 / (itemsProposed.length - 1);

    s.slider({
        min: 1,
        max: itemsProposed.length,
        animate: 'slow',
        stop: function(event, ui) {

            var pointer = ui.value - 1;
            jq('#s' + ui.value).prop('checked', true);
            score = itemsProposed[pointer];
        },
        slide: function( event, ui ) {
            jq(this).find(".legendSld label").css({color: "#555", fontWeight: "normal"}).eq(ui.value -1).css({color: "#E98824", fontWeight: "bold"});
            jq(this).find(".legendSld label").eq(ui.value -1).click();
        }
    });

    /* Below works on click event. It highlights the selected option with a different color and different font style. Also it moves the help text pointer to selected option. */    
    jq(".legendSld label").on("click", function() {
        var lpos = jq(".legendSld label").offset().left;
        var $this = jq(this);
        $this.parent().find('label').css({
            'color': '#222222',
            'font-weight': 'normal'
        });
        $this.css({
            'color': '#e98824',
            'font-weight': 'bold'
        });
        jq("toolTipMsg:before").css("left", lpos + "px");

    });
    jq("input[type=radio][id^='s']").hide();

    /* Below script highlights the selected option with a different color when the condition is true. Also it moves the slider handle position
based on the condition. */ 
    jq(".scoreDB").each(function() {
        var $this = jq(this);
        var score = $this.val();

        if (score === "1") {
            $this.next(".sliderStat").find(".ui-slider-handle").css("left", "33.3333333333333%");
            $this.next(".sliderStat").find("label[for=s1]").css({
                'color': '#e98824',
                'font-weight': 'bold'
            });
        } else if (score === "3") {
            $this.next(".sliderStat").find(".ui-slider-handle").css("left", "66.6666666666667%");
            $this.next(".sliderStat").find("label[for=s2]").css({
                'color': '#e98824',
                'font-weight': 'bold'
            });
        } else if (score === "5") {
            $this.next(".sliderStat").find(".ui-slider-handle").css("left", "100%");
            $this.next(".sliderStat").find("label[for=s3]").css({
                'color': '#e98824',
                'font-weight': 'bold'
            });
        } else {
            $this.next(".sliderStat").find(".ui-slider-handle").css("left", "0");
            $this.next(".sliderStat").find("label[for=s0]").css({
                'color': '#e98824',
                'font-weight': 'bold'
            });
        }

    });
}

/* Below function contains the script for the slider functionality in first Otif list. 
It contains the complete functionality code when user clicks on the options the pointer ball moves to the clicked option. 
Also it saves the selected option when clicked on it. */
function initSlider1() {
    setTimeout(function() {
        var itemsProposed = ['Select', '1', '2', '3', '4', '5'];
        var sp = jq(".sliderStat1");
        var quest;
        var PointerT = 100 / (itemsProposed.length - 1);

        sp.slider({
            min: 1,
            max: itemsProposed.length,
            animate: 'slow',
            stop: function(event, ui) {
                var pointer = ui.value - 1;
                jq('#s' + ui.value).prop('checked', true);
                quest = itemsProposed[pointer];
            },
            slide: function( event, ui ) {
                jq(this).find(".legendSld label").css({color: "#555", fontWeight: "normal"}).eq(ui.value -1).css({color: "#E98824", fontWeight: "bold"});
                jq(this).find(".legendSld label").eq(ui.value -1).click();
            }
        });

        /* Below works on click event. It highlights the selected option with a different color and different font style. Also it moves the help text pointer to selected option. */    
        jq(".legendSld label").on("click", function() {
            var lpos = jq(".legendSld label").offset().left;
            var $this = jq(this);
            $this.parent().find('label').css({
                'color': '#555555',
                'font-weight': 'normal'
            });
            $this.css({
                'color': '#e98824',
                'font-weight': 'bold'
            });
            jq("toolTipMsg:before").css("left", lpos + "px");

        });
        jq("input[type=radio][id^='s']").hide();
        jq("[data-toggle=tooltip]").tooltip();

        /* Below script highlights the selected option with a different color when the condition is true. Also it moves the slider handle position
based on the condition. */ 

        jq("input[name=quest]").each(function() {
            var $this = jq(this);
            var quest = $this.val();
            if (quest === "1") {
                $this.next(".sliderStat1").find(".ui-slider-handle").css("left", "20%");
                $this.next(".sliderStat1").find("label[for=s5]").css({
                    'color': '#e98824',
                    'font-weight': 'bold'
                });
            } else if (quest === "2") {
                $this.next(".sliderStat1").find(".ui-slider-handle").css("left", "40%");
                $this.next(".sliderStat1").find("label[for=s6]").css({
                    'color': '#e98824',
                    'font-weight': 'bold'
                });
            } else if (quest === "3") {
                $this.next(".sliderStat1").find(".ui-slider-handle").css("left", "60%");
                $this.next(".sliderStat1").find("label[for=s7]").css({
                    'color': '#e98824',
                    'font-weight': 'bold'
                });
            } else if (quest === "4") {
                $this.next(".sliderStat1").find(".ui-slider-handle").css("left", "80%");
                $this.next(".sliderStat1").find("label[for=s8]").css({
                    'color': '#e98824',
                    'font-weight': 'bold'
                });
            } else if (quest === "5") {
                $this.next(".sliderStat1").find(".ui-slider-handle").css("left", "100%");
                $this.next(".sliderStat1").find("label[for=s9]").css({
                    'color': '#e98824',
                    'font-weight': 'bold'
                });
            } else {
                $this.next(".sliderStat1").find(".ui-slider-handle").css("left", "0%");
                $this.next(".sliderStat1").find("label[for=s4]").css({
                    'color': '#e98824',
                    'font-weight': 'bold'
                });
            }

        });

    }, 1000);
}

/* Below function calls another function */
function changeScore(id,score)
    {    
        callChangeScore(id,score);
    }
    /* Below function calls another function */
    function changeScore1(id,score)
    {
        callChangeScore1(id,score);
    }
    
/* Below function performs page redirection. */
    function goToParentPage()
    {            
        window.top.location.href = IPMApp.pageName+'?id='+IPMApp.projectId+'&projDocSecId='+IPMApp.projDocSecId;
    }    
 
 /* Below function opens a delete modal. */
        function delQuestion(str) {  
            jq('#ipmDeleteModal').modal({show:true, keyboard: false, backdrop:'static'});
            jq('#ipmDeleteModal .modal-title').html(IPMApp.RiskRemoveQuestion);
            jq('#ipmDeleteModal .confirmMsg').html(IPMApp.systemDelMsg);
            jq('#ipmDeleteModal .confirmAction').attr('value', str);
            jq(".confirmAction").addClass("removeRiskQuestion");
        }
 /* Below script works on click event. When clicked on remove button it calls a delete function and also hides the delete modal */
        jq(document).on('click', '#ipmDeleteModal .removeRiskQuestion', function(){
            var questionId = jq(this).attr('value');
            deleteQuestion(questionId);
            jq("#ipmDeleteModal").modal('hide');
        });

var unsaved = false;
var oldTextareaval = "";
var newTextareaval = "";
var initialValue = true;
jq(function(){  
      var frame = parent.document.getElementById("ipmModalDiv");
       jq(frame).find('.close').click(function(){
           if(unsaved){
               jq(this).removeAttr( "data-dismiss" );
               unloadIframe();
           }
           else{
               jq(this).attr("data-dismiss","modal");
           }
       });
        if(initialValue !== false){
            oldTextareaval = jq(".txtArea ").val();
        }
   });   
   
   function unloadIframe(){
       window.parent.location.href=IPMApp.pageName + '?id=' + IPMApp.projectId + '&projDocSecId=' + IPMApp.projDocSecId;
   }

   function selectchk(){
    unsaved = true;
   }
   
   function checktextval(){
   inputTextArea = jq(".ipmQuestTextarea ");
    inputTextArea.bind('input propertychange', function() {
            newTextareaval = jq(".ipmQuestTextarea ").val();
            initialValue = false;
            if( oldTextareaval !== newTextareaval ){
              unsaved = true;
            }else{
              unsaved = false;
            }
            oldTextareaval = newTextareaval;
         });
     }
  
  function unloadPage()
  { 
      if(unsaved){
          return IPMApp.wmessage;
      }
  } 
 
  window.onbeforeunload = unloadPage;
  
  /* Below code is to skip the unsaved changes*/
  function skipValidation() {  
    unsaved = false;
  }