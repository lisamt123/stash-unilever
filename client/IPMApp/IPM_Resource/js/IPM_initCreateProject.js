/*  
******************************************************************************************
*@Description:This script is used for develop Create New Project page specific interaction
*@Author: Cognizant
*@Created Date: 28/05/2015 
******************************************************************************************
*/  
// To prevent conflict with prototype.js
var jq = jQuery.noConflict();
jq(document).ready(function() {

/* Below works on click event. Based on the options selected by the user the option will be highlighted in blue color. */
    jq(document).on("click", ".radioButton input[type=radio]", function(){ 
        var $this = jq(this);
        var radioId = jq(this).attr('id');
        var radioIcon = jq('.radioIcon');
        radioIcon.removeClass("projectbutton-blue");
        radioIcon.removeClass("bosscardbutton-blue");
        radioIcon.css("border-color","#999");

        radioIcon.addClass("bosscardbutton-gray");
        radioIcon.addClass("projectbutton-gray");
        jq('.radioButton').find('.rlabel').css("font-weight","normal");
        jq('.radioButton').find('label').removeClass('selected');
        if($this.is(':checked')){
        $this.parent().prev().addClass(radioId +"-blue");
        $this.parent().prev(".radioIcon").css("border-color","#007CBA");
        $this.next("label").addClass("selected");
        $this.parent().next(".rlabel").css("font-weight","bold");
        }else{ 
        $this.parent().prev().removeClass(radioId +"-blue");
        $this.next("label").removeClass("selected"); 
        $this.next("label").next(".rlabel").css("font-weight","normal");
        } 
    });  
});

/* Below function closes the modal by triggering the click event of close button. */
function closeModal(){
   jq(document).on('click', '.cancelButton', function() { 
   var frame = parent.document.getElementById("ipmModal");
   jq(frame).find('.close').trigger('click');
});
}

/* Below function checks for the validation. Once the user tries to create a project it validates with some back end information 
and if it passes it will be redirected to Project setup page else an error message will be displayed. */
 function createPro(){
         if(jq("input[type='radio'].rbutton").is(':checked')){
                   card_type  = jq("input[type='radio'].rbutton:checked").val();
                    if(card_type.indexOf('IPM_ProjectSetup') > 0){
                    
        Visualforce.remoting.Manager.invokeAction(
            IPMApp.RemoteActionCreatePro,
                function(result, event){
                    
                    if (event.status) {
                       if(event.result!==null){
                            window.top.location.href=IPMApp.projectsrc+'?Pid='+event.result;        
                        }
                        else{
                            alert(IPMApp.systemMsg);
                        }
                    }
                }
            );
        }
        else{
        Visualforce.remoting.Manager.invokeAction(
            IPMApp.RemoteActionCreateBoss,
            function(result, event){
                if (event.status) {
                 if(event.result!==null){
                     window.top.location.href=IPMApp.bosscardsrc + '?id='+event.result;
                     }
                 else{
                     alert(IPMApp.systemMsg);
                 }    
                }
            }
        );
        }
    }            
   } 