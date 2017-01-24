/*  
***********************************************************************************
*@Description:This script is used for IPM New Project page specific interaction
*@Author: Cognizant
*@Created Date: 28/05/2015 
***********************************************************************************
*/
var jq = jQuery.noConflict();  
/* Below function performs a validation check for the key pressed. If the characters entered other than numerical characters it gives out an error. */ 
function isNumberKey(evt)
{
  var charCode = (evt.which) ? evt.which : event.keyCode;
  var result = false;
  var errorMsg = document.getElementById("regTitle");
  if ( charCode !== 46 && charCode > 31 && (charCode < 48 || charCode > 57 ) )
  {
   errorMsg.innerHTML = "<b>Please use numerical characters only.</b>";
   result = false;
  }
  else
  {
   errorMsg.innerHTML = "";
   result = true;         
  }             
  return result;
}