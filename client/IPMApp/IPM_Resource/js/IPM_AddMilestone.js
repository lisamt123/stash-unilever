/***************************************************************************************
 *@Description:This script used to create IPM_AddMilestone page specific utility methods.
 *@Author: Cognizant
 *@Created Date: 28/05/2015 
****************************************************************************************/

var jq = jQuery.noConflict();
jq("#errorMsg").hide();

/* Below function performs the validation and display the error message based on the Due date field value */
function validate() {
    if (jq("#dueDate").val() === null) {
        $("#errorMsg").show();
    }
}
/* Below function performs a redirection to the Task List page */
function pageclose() {
    window.top.location.href = IPMAppComp.pageRef + '?id=' + IPMAppComp.projectId;
}
/* Below function performs a redirection based on a condition. If the condition is true it will redirect to Project setup page. If it is false it will redirect to Tasklist page*/
function pagecloseProSetUp() {
    if (IPMAppComp.ProjectWizard !== '' || IPMAppComp.ProjectWizard !== null) {
        window.top.location.href = IPMAppComp.pageRefProSetupView + '?Pid=' + IPMAppComp.projectId + '&Milestoneid=milestones';
    } else {
        window.top.location.href = IPMAppComp.pageRefTask + '?id=' + IPMAppComp.projectId;
    }
}

/* Below function calls another function 'selectMiniMilestones' */
function selectMiniMs(miniMs)
{
  selectMiniMilestones(miniMs);
}
  
/* Below function checks each checkbox whether it is checked or not. If the checkbox is checked it also highlights the closest row by adding a color */
function applySelectedRowClass()
{
  jq('input[type=checkbox]').each(function() 
  {
    var $this = jq(this);
    var val = $this.prop('checked');
    if ($this.prop('checked') === true) 
    {
      $this.next('label').addClass('selected');
      $this.closest("tr").addClass("selected");
    } 
    else 
    {
      $this.next('label').removeClass("selected");
      $this.closest("tr").removeClass("selected");
    }
  });
}

jq(document).ready(function() {
/* Below script is for the Tab functionality on page load. It hides all the tabs content and shows only the first tabs content */
    jq('#ipmAddMilestoneTab .ipmMilestoneContent').hide();
    jq('#ipmAddMilestoneTab .ipmMilestoneTabs li:first').addClass('active');
    jq('#ipmAddMilestoneTab .ipmMilestoneContent:first').show();
  
/* Below script is for the Tab functionality on click event. Based on the clicked li the tab is highlighted and the content related the clicked tab is displayed. Also it hides the previous opened content */
    jq('#ipmAddMilestoneTab .ipmMilestoneTabs li').on('click', function(e) {
        e.preventDefault();
        jq('#ipmAddMilestoneTab .ipmMilestoneTabs li').removeClass('active');
        var $this = jq(this);
        var getClass = $this.attr('class').split(' ');
        var getId = getClass[0];
        jq('#ipmAddMilestoneTab .ipmMilestoneContent').hide();
        $this.addClass('active');
        jq('#' + getId).fadeIn("fast");
    });
    jq(document).find(".additionalMstone input[type=checkbox]:checked").closest("tr").addClass("selected");
  
/* Below script performs on click event where it checks each checkbox whether it is checked or not. If the checkbox is checked it also highlights the closest row by adding a color */
    jq(document).on("click", ".additionalMstone input[type=checkbox]", function() {
        var $this = jq(this);
        if ($this.is(":checked")) {
            $this.next('label').addClass("selected");
            $this.closest("tr").addClass("selected");
        } else {
            $this.next('label').removeClass("selected");
            $this.closest("tr").removeClass("selected");
        }
    });
  
  jq(document).on("click", ".dateInputBoxAdd", function() {
    jq(this).parents().find('.datePicker').addClass('customDatepicker');
  });
  jq(document).on("click", ".listDate", function() {
    jq(this).parents().find('.datePicker').removeClass('customDatepicker');
  });
/* Below script checks each checkbox whether it has the value 'true'. If the checkbox has the value 'true' it checks the checkbox */
    jq('input[type=checkbox]').each(function() {
        var $this = jq(this);
        var val = $this.attr('value');
        if (val === 'true') {
            $this.prop('checked', true);
            $this.next('label').addClass('selected');
        } else {
            $this.prop('checked', false);
        }
    });
});
       
  var unsaved = false;
  var jq = jQuery.noConflict();
  jq(function(){       
        jq(":input").change(function() {
             unsaved = true;
         });
     if(window.parent.location.href.indexOf("Tasklist") > -1) {
      var frame = parent.document.getElementById("ipmModalDiv");
     }else{
      var frame = parent.document.getElementById("ipmaddMstonWizard");
     }
        jq(frame).find('.close').click(function(){
            if(unsaved){
                jq(this).removeAttr( "data-dismiss" );
                unloadIframe();
            }
            else{
                jq(this).attr("data-dismiss","modal");
            }
        });
         
    });   
    
    function unloadIframe(){
      if(window.parent.location.href.indexOf("Tasklist") > -1) {
      window.top.location.href = IPMAppComp.pageRef + '?id=' + IPMAppComp.projectId;
      }else{
      window.top.location.href = IPMAppComp.pageRefProSetupView + '?Pid=' + IPMAppComp.projectId + '&Milestoneid=milestones'; 
      }
  }
    
     function unloadPage()
   { 
       if(unsaved){
           return IPMAppComp.wmessage;
       }
   } 
  
   window.onbeforeunload = unloadPage;
   
   /* Below code is to skip the unsaved changes*/
   function skipValidation() {
       unsaved = false;
   }
   function pageclosemilestone(){
    window.top.location.href = IPMAppComp.pageRef + '?id=' + IPMAppComp.projectId + '&name=newMstone';
}