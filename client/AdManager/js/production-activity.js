$j = jQuery.noConflict();
function getSummary() {
	$j('.summary').attr('style','visibility:none;');
	$j('.summary').html('');
	
	$j('.sub-master').each(function() {                                                      
		if(this.checked) {
			$j('.summary').html('<div class="summary-title">Summary</div><div class="clear"></div>');     
		}
	});
	
	$j('.secondary-parent').each(function() {
		var level1  = $j(this).closest('.secondary-parent').attr('summaryText');
		level1      = level1.replace('secondary-parent','').trim();
			$j(this).find('.mediamasterdiv').each(function(){                                                        
				if($j(this).find('input:checkbox').is(':checked')) {
					if( $j(this).find('input:checkbox').hasClass('additional') ) {
						level2 = $j(this).find('input:checkbox').attr('summary-text');
						$j('.summary').show();
						var classname = level1.replace(/\s/g, '-');                                 
						if($j('.'+classname).length) {
							$j('.'+classname).append(', '+level2);
						} else {                                        
							$j('.summary').append('<div class="summary-detail">'+level1+'</div><div class="summary-detail1 '+classname+'">'+level2+'</div><div class="clear"></div>');
						}                                   
					}                                                                                                                                       
				}
															
			});
			
			/*start new code*/
			
			$j(this).find('.submediamasterdiv').each(function(){                                                     
				if($j(this).find('input:checkbox').is(':checked')) {                             
					
					$j(this).find('input:checkbox').each(function(){
						if(this.checked) {
							level2 = $j(this).attr('labelText');                                     
							if(level2) {								
								$j('.summary').show();
								var classname = level1.replace(/\s/g, '-');                                 
								if($j('.'+classname).length) {
									$j('.'+classname).append(', '+level2);
								} else {
									$j('.summary').append('<div class="summary-detail">'+level1+'</div><div class="summary-detail1 '+classname+'">'+level2+'</div><div class="clear"></div>');
								}
								
							}                                       
						}                                   
					});                                                                                                                                                                                                 
				}
															
			});
			
			/* end new code*/
			
	});         
}

function removeOnlyOneClass(selected) {
	$j('.'+selected).each(function(){
		var otherClasses         = $j(this).attr('class');
		var modifiedOtherClasses = otherClasses.replace(selected,'');
		$j(this).attr('class',modifiedOtherClasses);
	});             
}
function disableDependent() {
	$j('.dependentOut_Of_Home input:checkbox').attr('disabled','disabled');
	$j('.dependentIn_Store input:checkbox').attr('disabled','disabled');
	$j('.dependentDigital input:checkbox').attr('disabled','disabled');
}

$j(document).ready(function() {
	$j('.defaultTv').attr('disabled','disabled');
	$j('.defaultCinema').attr('disabled','disabled');
	$j('.defaultRadio').attr('disabled','disabled');
	$j('.defaultPrint').attr('disabled','disabled');
	$j('.defaultInternalVideo').attr('disabled','disabled');
	
	
	// production activity logic 
	//1. if none selected, dont show anything and only one master can be selected
	
	var masterselection = true;
	$j('.master').click(function() {
		if(this.checked) {
		
			var selected_parent = $j(this).attr('data-id');
			$j('.secondary-parent').hide();
			$j('.'+selected_parent).show();
						
			removeOnlyOneClass('dfn-selected'); //sunil
			$j(this).parent().addClass('dfn-selected'); //Sunil
						
			masterselection = true;
			
			if($j(this).hasClass('original_master')) {
				$j('.other_master').prop('checked', false);
				$j('.secondary-parent').each(function(){
					if(!($j(this).hasClass('main-new-original-master'))) {	
						$j(this).find('input:checkbox').prop('checked',false);					
					} 
				//	else {
				//		$j(this).find('input:checkbox').prop('checked',false);						
				//	}					
				});
			} else {
				$j('.original_master').prop('checked', false);				
				$j('.secondary-parent').each(function(){
					if($j(this).hasClass('main-new-original-master')) {						
						$j(this).find('input:checkbox').prop('checked',false);
					}					
				});				
			}                        
			
		} else {
		
			$j('.secondary-parent').hide();//Sunil
			
			//uncheck associates
			var selected_parent = $j(this).attr('data-id');
			console.log('parent is'+selected_parent+'__');                    
			$j('.'+selected_parent).find('input:checkbox').prop('checked', false);
						
				$j('.'+selected_parent).hide(); 			
				removeOnlyOneClass('dfn-selected');
				
				var flip_to_selection = false;
				var flip_to;
				$j('.master').each(function() {                                                      
					if(this.checked) {                                  
						flip_to = $j(this).attr('data-id');					   
						flip_to_selection = true;                                         
					}
				}); 
				
				if(flip_to_selection == true) {                             
					$j('.'+flip_to).show();					
					$j('input[data-id='+flip_to+']').parent().addClass('dfn-selected');
				}							
			// end
														
			masterselection = false;
			$j('.master').each(function() {                                                      
				if(this.checked) {
					masterselection = true;     
				}
			});
			
			if( masterselection == false ) {
							  
			  removeOnlyOneClass('dfn-selected');
				//$j('.original_master').removeAttr('disabled');
				//$j('.other_master').removeAttr('disabled');
				$j('.summary').html('');
				
				$j('.secondary-parent').hide();
				
				$j('.mediamasterdiv input:checkbox').each( function() {
					$j(this).prop('checked', false);
				});
				
				$j('.submediamasterdiv input:checkbox').each( function() {
					$j(this).prop('checked', false);
				});
				
				disableDependent();           
			}                                                                                             
		}
		getSummary();
	});
	
	
	// 2. default value selected
	
	$j('.additional').click(function() {
		selectedDefault = $j(this).attr('data-id');
		if(this.checked) {                    		  
		  $j(this).closest(".secondary-parent").find('.'+selectedDefault).prop('checked', true);                   
		} else {                		  
		  $j(this).closest(".secondary-parent").find('.'+selectedDefault).prop('checked', false);
		}
	});
	
	$j('.additional2').click(function() {                    
		selectedDependent = $j(this).attr('media');                    
		if(this.checked) {                                                                 		   
			$j(this).closest(".secondary-parent").find('.dependent'+selectedDependent).find('input:checkbox').removeAttr('disabled');               
		} else {                                        
			$j(this).closest(".secondary-parent").find('.dependent'+selectedDependent).find('input:checkbox').prop('checked', false);
			$j(this).closest(".secondary-parent").find('.dependent'+selectedDependent).find('input:checkbox').attr('disabled','disabled'); 
		}
	}); 
	
	$j('.master_parent label').click(function(){
		
		var flag = false;
		
		$j(this).parent('div').find('input:checkbox').each(function() {                 
			if(this.checked) {
				flag = true;
			}
		});
		
		if( flag == true ) {
			var siblingCheckboxMedia = $j(this).parent('div').children('input:checkbox').attr('data-id');                    
			$j('.secondary-parent').hide();
			$j('.'+siblingCheckboxMedia).show();		   
			removeOnlyOneClass('dfn-selected');
			$j(this).parent().addClass('dfn-selected');   
		}                                                                              
	});
	
	$j('.mediamasterdiv input:checkbox').click(function() {                  
		if(this.checked) {
			var required_parent = $j(this).closest('.secondary-parent').attr('class');
			required_parent = required_parent.replace('secondary-parent','').trim();
			
			$j('.master').each(function(){
				var required_parent1 = $j(this).attr('data-id');
				if( required_parent == required_parent1 ) {
					$j(this).prop('checked', true);
				}
			});                                             
		}                                   
	});
	
	//Summary logic
	$j('.mediamasterdiv input:checkbox, .submediamasterdiv input:checkbox').click(function() {
		getSummary();                                       
	});                     
					
	disableDependent();   
	
	/*Start of repeated code*/
	
	var selected_master = false; 
	
	$j('.master').each(function(){
		if(this.checked) {
		
			if($j(this).hasClass('original_master')) {
				//$j('.other_master').attr('disabled', 'disabled');
				$j('.other_master').prop('checked', false);
				$j('.secondary-parent').each(function(){
					if(!($j(this).hasClass('main-new-original-master'))) {						
						$j(this).find('input:checkbox').prop('checked',false);	
					}
				//	 else {
				//		$j(this).find('input:checkbox').prop('checked',false);						
				//	}					
				});
			} else {
				//$j('.original_master').attr('disabled', 'disabled');
				$j('.original_master').prop('checked', false);
				$j('.secondary-parent').each(function(){
					if($j(this).hasClass('main-new-original-master')) {						
						$j(this).find('input:checkbox').prop('checked',false);
					}					
				});
			} 
		
			var selected_parent = $j(this).attr('data-id');
			$j('.secondary-parent').hide();
			$j('.'+selected_parent).show();
			
			removeOnlyOneClass('dfn-selected'); //sunil
			$j(this).parent().addClass('dfn-selected'); //Sunil
			
			selected_master = true;
		}       
	});
	
	if( selected_master == true ) {
		getSummary();
	}               
	
	$j('.additional2').each(function(){
		selectedDependent = $j(this).attr('media');                    
		if(this.checked) {                                                                                     
			$j(this).closest(".secondary-parent").find('.dependent'+selectedDependent).find('input:checkbox').removeAttr('disabled');               
		} else {                                        
			$j(this).closest(".secondary-parent").find('.dependent'+selectedDependent).find('input:checkbox').prop('checked', false);
			$j(this).closest(".secondary-parent").find('.dependent'+selectedDependent).find('input:checkbox').attr('disabled','disabled'); 
		}               
	});                             
	
	/*End of repeated code*/
	
	/*Load Error code*/
	
	$j('.loadError').each(function(){ 
		var lengthOfParent = $j(this).attr('data-width');
		if(lengthOfParent) {
			$j(this).closest('.form-field-parent').addClass('loadErrorParent width70percent');
		} else {
			$j(this).closest('.form-field-parent').addClass('loadErrorParent');
		}                                       
	});
		
	/*End of load error code*/
	
	if($j(".loadErrorParent").length) {
		$j('html,body').animate({scrollTop: $j(".loadErrorParent").offset().top},'slow');
	} else if($j(".errorM3").length){
		$j('html,body').animate({scrollTop: $j(".errorM3").offset().top},'slow');
	}
	
});