 $(document).ready(function() {
         $('[id*="saveButton"],[id*="cancelButton"]').hide();
         
         $('[id*="saveButton"],[id*="cancelButton"],[id*="btnIamWorking"]').on('click',function() {
            $('input[type="text"],textarea').blur();
            $('[id*="saveButton"],[id*="cancelButton"]').hide();         
         });
         
          $('input[type="text"],textarea,select').on('click keyup keypress blur change dblclick',function(){ //$(document).dblclick(function() {
              $('[id*="saveButton"],[id*="cancelButton"]').show();
          });
          
          $('[id*="ECC"],[id*="TPT"],[id*="PT"]').on('click dblclick',function(){
               $('[id*="ECC"]').prop('disabled','disabled');
               $('[id*="TPT"],[id*="PT"]').removeAttr('disabled');
          });
     });

     function func(){
      alert('Only relevant for Manual Blocks/Unblocks/Deletes/Undeletes'); 
    }
    
    function openAdvanceform(){
        window.top.location='https://'+localhost+'/apex/VPM_AdvancedForm_V1?id='+purId;
    }
    function PageReload(){
      window.top.location='https://'+localhost+'/'+purId;
      return false;
    }
    
    function redirectToListView(customId)
    {
      window.top.location='https://'+localhost+'/apex/VPM_VendorRequestsHome';
      return false;
    }
    
    function reworkBtnClick(){
		

        if ((currentstatus.indexOf('Draft') >= 0 )||(rework=='Yes')){ 
	
            if(rework=='Yes'){ 
                alert(VPMAlreadyRework); 
            } 
            else{ 
                alert(VPMCannotSendRework); 
            } 
            
        }
        else
        {
            var r = confirm(VPMOkForRework); 
            if(r == true){
                    ReworkAction();
                    return false;
               }
            
            else 
                alert(VPMReworkCancel);
        } 
    }
    function callSendToSAPAPI()
    {
        callSendToSAPAPI();
        return false;
    }
    
    function openProcureAtAGlance(){
        window.top.location='https://'+localhost+'/apex/VPM_ProcurementAtAGlance?id='+purId;
    }
