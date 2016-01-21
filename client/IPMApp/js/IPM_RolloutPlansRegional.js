/*  
 ********************************************************************************
 *@Description:This script is used for IPM Rollouts plans regional page specific interaction
 *@Author: Cognizant
 *@Created Date: 28/05/2015 
 ********************************************************************************
 */
var jq=jQuery.noConflict();
	var selectedMCOs=[], unselectedMCOs=[], selectedCountries=[], unselectedCountries=[], selectedNoRollouts=[], unselectedNoRollouts=[];                        
	jq(document).ready(function(){
		regionalscriptpanel();
		populateRolloutData();
	});
	
/* Below code is to check or disable the checkboxes */
	function regionalscriptpanel(){
		jq('input:radio[name ^=grp]').each(function(){
		var $this = jq(this);
		if($this.hasClass('checked')){
			$this.prop('checked', 'true');
		}
		
		if($this.hasClass('disabled')){
			$this.prop('disabled', 'true');
			}
		});
		var srchTxt = jq('#srchTxt');
		srchTxt.addClass('placeholder');
		srchTxt.val(srchTxt.attr('placeholder'));
		jq(document).on('keypress, keydown','[placeholder]',function() {
			var input = jq(this);
			if (input.val() == input.attr('placeholder')) {
				input.val('');
				input.removeClass('placeholder');
			}
		})
		jq('[placeholder]').blur(function() {
			var input = jq(this);
			if (input.val() == '' || input.val() == input.attr('placeholder')) {
				input.addClass('placeholder');
				input.val(input.attr('placeholder'));
			}
		}).blur();	
/* Below code is to push the selected values */
	jq(document).on('click','.changeMCOTab', function(){
		var mcoCode = jq(this).attr('id')
		jq('input:radio[name ^=grp]').each(function(){
			var $radio = jq(this);
			if($radio.is(":checked")){
				//MCO
				if($radio.attr('id').indexOf('grp1') !=-1){
					selectedMCOs.push($radio.val());
				} else {
					unselectedMCOs.push($radio.val());
				}
				//Country
				if($radio.attr('id').indexOf('grp2') !=-1){
					selectedCountries.push($radio.val());
				} else {
					unselectedCountries.push($radio.val());
				}
				//No Rollouts
				if($radio.attr('id').indexOf('grp3') !=-1){
					selectedNoRollouts.push($radio.val());
				} else {
					unselectedNoRollouts.push($radio.val());
				}
			}
		}); 
		changeMCO(selectedMCOs.toString(),unselectedMCOs.toString(),selectedCountries.toString(),unselectedCountries.toString(),selectedNoRollouts.toString(),unselectedNoRollouts.toString(),mcoCode);
	});
}
	function invokeRolloutGeneration()
	{
		populateRolloutData();
		generateRollouts(selectedMCOs.toString(),unselectedMCOs.toString(),selectedCountries.toString(),unselectedCountries.toString(),selectedNoRollouts.toString(),unselectedNoRollouts.toString());
	}
	
/* Below code is to redirect to regional page */
	function setRedirect()
	{
		if(IPMregionalApp.completed)
		{
			window.top.location = IPMregionalApp.url+'?Id='+IPMregionalApp.proid+'&EditMode=false';
		}
	}
	
	function populateRolloutData()
	{
		selectedMCOs=[], unselectedMCOs=[], selectedCountries=[], unselectedCountries=[], selectedNoRollouts=[], unselectedNoRollouts=[];                        
		jq('input:radio[name ^=grp]').each(function()
		{
			var $radio = jq(this);  
			if($radio.is(":checked"))
			{
				//MCO
				if($radio.attr('id').indexOf('grp1') !=-1){
					selectedMCOs.push($radio.val());
				} else {
					unselectedMCOs.push($radio.val());
				}
				//Country
				if($radio.attr('id').indexOf('grp2') !=-1){
					selectedCountries.push($radio.val());
				} else {
					unselectedCountries.push($radio.val());
				}
				//No Rollouts
				if($radio.attr('id').indexOf('grp3') !=-1){
					selectedNoRollouts.push($radio.val());
				} else {
					unselectedNoRollouts.push($radio.val());
				}
				
			}
		});
	}
	
	function validateIfWarningRequired() 
        { 
			var intialSelectedNoRollouts = selectedNoRollouts; 
			
			// Populate with Latest Changes 
			populateRolloutData(); 
			
			var issameNoRollout = (intialSelectedNoRollouts.length == selectedNoRollouts.length) && intialSelectedNoRollouts.every(function(element, index)  

			{ 
					return element === selectedNoRollouts[index]; 
			}); 
			
			if(issameNoRollout) 
			{ 
					return true; 
			} 
			return false; 
        }
	
	jq(".generateRolloutBtn").on("click",function(e)
	{
		e.stopPropagation();
		var checkIfSame = validateIfWarningRequired();
		if(checkIfSame)
		{
			invokeRolloutGeneration();
		}
		else
		{
			jq('#ipmDeleteModal').modal('show');
			jq('#ipmDeleteModal .modal-title').text(IPMregionalApp.warningTitle);
			jq('#ipmDeleteModal .confirmMsg').text(IPMregionalApp.warningMsg);
			jq('#ipmDeleteModal .cancelAction').text(IPMregionalApp.cancelBtnText);
			jq('#ipmDeleteModal .confirmAction').text(IPMregionalApp.acceptBtnText);
			
			jq('#ipmDeleteModal .modal-body').css({
			"height": "120px",
			"margin-right": "15px"
			});
			
			jq('#ipmDeleteModal .confirmAction').on("click",function(){invokeRolloutGeneration();});
			jq('#ipmDeleteModal .cancelAction').on("click",function(){
				window.top.location = IPMregionalApp.baseUrl+'?Id='+IPMregionalApp.proid;
			});
		}
	});