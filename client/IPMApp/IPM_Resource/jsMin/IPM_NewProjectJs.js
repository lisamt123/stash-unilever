var jq=jQuery.noConflict();function isNumberKey(evt){var charCode=evt.which?evt.which:event.keyCode;var result=false;var errorMsg=document.getElementById("regTitle");if(charCode!==46&&charCode>31&&(charCode<48||charCode>57)){errorMsg.innerHTML="<b>Please use numerical characters only.</b>";result=false}else{errorMsg.innerHTML="";result=true}return result}