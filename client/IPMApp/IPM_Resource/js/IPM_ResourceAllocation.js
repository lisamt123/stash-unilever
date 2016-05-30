/*  
****************************************************************************************
*@Description:This script is used for IPM Resource Part Revamp page specific interaction
*@Author: Cognizant
*@Created Date: 28/05/2015 
****************************************************************************************
*/
var jq= jQuery.noConflict();
jq(document).ready(function() {
/* Below script works on click event. When clicked on the button it hides the container and loads the container again. */
    jq(document).on('click', '.ipmTable .rbutton', function(){
        var editContainer = jq('.editbContainer');
           editContainer.hide(); 
           jq('.cust-overlay').show().delay(2000).fadeOut(); 
           editContainer.show();
      });
      
  /* Below script adds a css class to a table row if the condition is true */
       jq(".teamCheck").change(function() {
        var $this = jq(this);
        if($this.is(':checked')) {
            $this.closest('tr').addClass('selected'); 
            }
        else {
            $this.closest('tr').removeClass('selected');
            }
    });
    jq('.teamSearch1 input').clearSearch();
    jq('.teamSearch2 input').clearSearch();
    jq('.teamSearch3 input').clearSearch();
});

/* Below function performs a trigger which clicks on the close button of a modal which closes the modal. */
 function dismissModal(){      
         var frame = parent.document.getElementById("ipmAddMemberModal");
         jq(frame).find('.close').trigger('click');
}

/* Below function performs the search functionality. If the condition is true it will call the function based on the condition. */
function callsearch(blnInvokedFromRollOuts) {
   if (document.getElementById('mycategory').checked) {
        if(blnInvokedFromRollOuts)
        {
             searchLeaderMem();
        }
        else
        {
             searchTeamMem();
        }
    }
    if (document.getElementById('allcategory').checked) {
        if (blnInvokedFromRollOuts)
        {
               searchallLeaderMem();
        }
        else
        {
               searchallTeamMem();
        }
    }  
                
}

/* Below function the save functionality of the selected team members. It also disables the button once clicked. */
function submitOnClick(objSubmitBtn) {
    objSubmitBtn.disabled = true;
    objSubmitBtn.value = 'Adding...';
    saveMembers();
}

/* Below function to add the selected members */
function submitAdd(objSubmitBtn) {
    objSubmitBtn.value = 'Add';
    objSubmitBtn.disabled = false;
}

/* Below function the save functionality of the role. It also disables the button once clicked. */
function submitOnClickRole(objSubmitBtn) {
    objSubmitBtn.disabled = true;
    objSubmitBtn.value = 'Adding...';
    RoleAndCategoryMem();
}

/* Below function performs a page redirection. */
function closepopup(){
     window.top.location.href=IPMApp.projectUrl+'?Pid='+IPMApp.projectName+'&TeamMemid=teammembers';
} 