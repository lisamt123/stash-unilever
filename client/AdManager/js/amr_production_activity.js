$j = jQuery.noConflict();

function getSummary() {
    $j('.summary').attr('style', 'visibility:none;');
    $j('.summary').html('');

    $j('.sub-master').each(function() {
        if (this.checked) {
            $j('.summary').html('<div class="summary-title">Summary</div><div class="clear"></div>');
        }
    });

    $j('.secondary-parent').each(function() {
        var level1 = $j(this).closest('.secondary-parent').attr('summaryText');
        level1 = level1.replace('secondary-parent', '').trim();
        $j(this).find('.mediamasterdiv').each(function() {
            if ($j(this).find('input:checkbox').is(':checked') && $j(this).find('input:checkbox').hasClass('additional')) { // If condition was separate, I have merged it. Need to check its impact.
                //if( $j(this).find('input:checkbox').hasClass('additional') ) {
                level2 = $j(this).find('input:checkbox').attr('summary-text');
                $j('.summary').show();
                var classname = level1.replace(/\s/g, '-');
                if ($j('.' + classname).length) {
                    $j('.' + classname).append(', ' + level2);
                } else {
                    $j('.summary').append('<div class="summary-detail">' + level1 + '</div><div class="summary-detail1 ' + classname + '">' + level2 + '</div><div class="clear"></div>');
                }
                //}                                                                                                                                       
            }

        });

        /*start new code*/

        $j(this).find('.submediamasterdiv').each(function() {
            if ($j(this).find('input:checkbox').is(':checked')) {

                $j(this).find('input:checkbox').each(function() {
                    if (this.checked) {
                        level2 = $j(this).attr('labelText');
                        if (level2) {
                            $j('.summary').show();
                            var classname = level1.replace(/\s/g, '-');
                            if ($j('.' + classname).length) {
                                $j('.' + classname).append(', ' + level2);
                            } else {
                                $j('.summary').append('<div class="summary-detail">' + level1 + '</div><div class="summary-detail1 ' + classname + '">' + level2 + '</div><div class="clear"></div>');
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
    $j('.' + selected).each(function() {
        var otherClasses = $j(this).attr('class');
        var modifiedOtherClasses = otherClasses.replace(selected, '');
        $j(this).attr('class', modifiedOtherClasses);
    });
}

function disableDependent() {
    $j('.dependentOut_Of_Home input:checkbox').attr('disabled', 'disabled');
    $j('.dependentIn_Store input:checkbox').attr('disabled', 'disabled');
    $j('.dependentDigital input:checkbox').attr('disabled', 'disabled');
}

$j(document).ready(function() {
	$j('.single_multiply_show_hide select').attr('disabled','disabled');              	
           	         	
	if($j('.single_or_multiply input[type="radio"]:checked').val() == 'Multiply' ) {           
		$j('.multiply_of_single_multiply select').removeAttr('disabled');           		
		$j('.single_of_single_multiply select').closest('.loadErrorParent').find('.loadError').remove();           		
		$j('.single_of_single_multiply select').closest('.loadErrorParent').attr('class','form-field-parent');           		
	} else {           
		$j('.single_of_single_multiply select').removeAttr('disabled');
		$j('.single_or_multiply input[type="radio"][value="single"]').prop( "checked", true );           		
		$j('.multiply_of_single_multiply select').closest('.loadErrorParent').find('.loadError').remove();           		
		$j('.multiply_of_single_multiply select').closest('.loadErrorParent').attr('class','form-field-parent');           		
	}
								
	$j('.single_or_multiply input[type="radio"]').change(function(){            
		$j('.single_multiply_show_hide select').attr('disabled','disabled');            		            	
		$j('.'+$j(this).val().toLowerCase()+'_of_single_multiply select').removeAttr('disabled');
	});
	
    var masterselection = true;
    $j('.master').click(function() {
        if (this.checked) {
            var selected_parent = $j(this).attr('data-id');
            $j('.secondary-parent').hide();
            $j('.' + selected_parent).show();
            removeOnlyOneClass('dfn-selected');
            $j(this).parent().addClass('dfn-selected');
            masterselection = true;
            if ($j(this).hasClass('original_master')) {
                $j('.other_master').prop('checked', false);
                $j('.secondary-parent').each(function() {
                    if (!($j(this).hasClass('main-new-original-master'))) {
                        $j(this).find('input:checkbox').prop('checked', false);
                    }
                });
            } else {
                $j('.original_master').prop('checked', false);
                $j('.secondary-parent').each(function() {
                    if ($j(this).hasClass('main-new-original-master')) {
                        $j(this).find('input:checkbox').prop('checked', false);
                    }
                });
            }
        } else {
            $j('.secondary-parent').hide();
            var selected_parent = $j(this).attr('data-id');
            $j('.' + selected_parent).find('input:checkbox').prop('checked', false);
            $j('.' + selected_parent).hide();
            removeOnlyOneClass('dfn-selected');
            var flip_to_selection = false;
            var flip_to;
            $j('.master').each(function() {
                if (this.checked) {
                    flip_to = $j(this).attr('data-id');
                    flip_to_selection = true;
                }
            });
            if (flip_to_selection == true) {
                $j('.' + flip_to).show();
                $j('input[data-id=' + flip_to + ']').parent().addClass('dfn-selected');
            }
            masterselection = false;
            $j('.master').each(function() {
                if (this.checked) {
                    masterselection = true;
                }
            });

            if (masterselection == false) {
                removeOnlyOneClass('dfn-selected');
                $j('.summary').html('');
                $j('.secondary-parent').hide();
                $j('.mediamasterdiv input:checkbox').each(function() {
                    $j(this).prop('checked', false);
                });
                $j('.submediamasterdiv input:checkbox').each(function() {
                    $j(this).prop('checked', false);
                });
                disableDependent();
            }
        }
        getSummary();
    });

    var selected_master = false;
    $j('.master').each(function() {
        if (this.checked) {
            if ($j(this).hasClass('original_master')) {
                $j('.other_master').prop('checked', false);
                $j('.secondary-parent').each(function() {
                    if (!($j(this).hasClass('main-new-original-master'))) {
                        $j(this).find('input:checkbox').prop('checked', false);
                    }
                });
            } else {
                $j('.original_master').prop('checked', false);
                $j('.secondary-parent').each(function() {
                    if ($j(this).hasClass('main-new-original-master')) {
                        $j(this).find('input:checkbox').prop('checked', false);
                    }
                });
            }
            var selected_parent = $j(this).attr('data-id');
            $j('.secondary-parent').hide();
            $j('.' + selected_parent).show();
            removeOnlyOneClass('dfn-selected');
            $j(this).parent().addClass('dfn-selected');
            selected_master = true;
        }
    });

    if (selected_master == true) {
        getSummary();
    }    
    paOptionClick();    
});

function paOptionClick() {
	
	loadErrorParentCall();
    loadDefaultAmr();        
    disableDependent();
	enableAdditionalPAValues();
	
    $j('.additional').click(function() {
        selectedDefault = $j(this).attr('data-id');
        if (this.checked) {
            $j(this).closest(".secondary-parent").find('.' + selectedDefault).prop('checked', true);
        } else {
            $j(this).closest(".secondary-parent").find('.' + selectedDefault).prop('checked', false);
        }
    });

    $j('.additional2').click(function() {
        selectedDependent = $j(this).attr('media');
        if (this.checked) {
            $j(this).closest(".secondary-parent").find('.dependent' + selectedDependent).find('input:checkbox').removeAttr('disabled');
        } else {
            $j(this).closest(".secondary-parent").find('.dependent' + selectedDependent).find('input:checkbox').prop('checked', false);
            $j(this).closest(".secondary-parent").find('.dependent' + selectedDependent).find('input:checkbox').attr('disabled', 'disabled');
        }
    });

    $j('.master_parent label').click(function() {

        var flag = false;

        $j(this).parent('div').find('input:checkbox').each(function() {
            if (this.checked) {
                flag = true;
            }
        });

        if (flag == true) {
            var siblingCheckboxMedia = $j(this).parent('div').children('input:checkbox').attr('data-id');
            $j('.secondary-parent').hide();
            $j('.' + siblingCheckboxMedia).show();
            removeOnlyOneClass('dfn-selected');
            $j(this).parent().addClass('dfn-selected');
        }
    });

    $j('.mediamasterdiv input:checkbox').click(function() {
        if (this.checked) {
            var required_parent = $j(this).closest('.secondary-parent').attr('class');
            required_parent = required_parent.replace('secondary-parent', '').trim();

            $j('.master').each(function() {
                var required_parent1 = $j(this).attr('data-id');
                if (required_parent == required_parent1) {
                    $j(this).prop('checked', true);
                }
            });
        }
    });

    //Summary logic
    $j('.mediamasterdiv input:checkbox, .submediamasterdiv input:checkbox').click(function() {
        getSummary();
    });
}

function enableAdditionalPAValues() {
    $j('.additional2').each(function() {
        selectedDependent = $j(this).attr('media');
        if (this.checked) {
            $j(this).closest(".secondary-parent").find('.dependent' + selectedDependent).find('input:checkbox').removeAttr('disabled');
        } else {
            $j(this).closest(".secondary-parent").find('.dependent' + selectedDependent).find('input:checkbox').prop('checked', false);
            $j(this).closest(".secondary-parent").find('.dependent' + selectedDependent).find('input:checkbox').attr('disabled', 'disabled');
        }
    });
}

function loadDefaultAmr() {
 //   $j('select.agencypick option[value=""]').html('None of the above');
	$j('.inputIdClass').attr('placeholder','Local Currency (Example '+'\u20AC'+'123,456.00)');
	
    $j('.defaultTv').attr('disabled', 'disabled');
    $j('.defaultCinema').attr('disabled', 'disabled');
    $j('.defaultRadio').attr('disabled', 'disabled');
    $j('.defaultPrint').attr('disabled', 'disabled');
    $j('.defaultInternalVideo').attr('disabled', 'disabled');
	
	var finalValue = $j('.outputIdClass').val();
	if(finalValue) {
		$j('.outputIdClass').val('\u20AC'+' '+finalValue);
	}	
}